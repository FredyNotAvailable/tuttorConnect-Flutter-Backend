const express = require("express");
const { GoogleAuth } = require("google-auth-library");
const axios = require("axios");
const bodyParser = require("body-parser");
const cors = require("cors");
const fs = require("fs");

const SERVICE_ACCOUNT_JSON = process.env.SERVICE_ACCOUNT_JSON;
const SERVICE_ACCOUNT_PATH = "./serviceAccountKey.json";
const PROJECT_ID = process.env.FIREBASE_PROJECT_ID || "tutorconnect-b1cb4";

const serviceAccount = JSON.parse(
  SERVICE_ACCOUNT_JSON || fs.readFileSync(SERVICE_ACCOUNT_PATH, "utf8")
);

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

const SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"];
const auth = new GoogleAuth({
  credentials: serviceAccount,
  scopes: SCOPES,
});

app.post("/send-tutoring-notification", async (req, res) => {
  console.log("👉 POST /send-tutoring-notification recibida");
  console.log("Body:", req.body);

  try {
    const { tokens, topic, date, tutoringId } = req.body;

    if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
      return res.status(400).json({ error: "tokens es requerido y debe ser un array no vacío" });
    }

    const accessToken = await auth.getAccessToken();
    const formattedDate = date ? new Date(date).toLocaleDateString() : "fecha desconocida";

    const results = [];

    for (const token of tokens) {
      const message = {
        message: {
          token,
          notification: {
            title: `Nueva sesión de tutoría: ${topic || "Sin tema"}`,
            body: `Programada para el ${formattedDate}`,
          },
          data: {
            tutoringId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            screen: "home",
          },
        },
      };

      try {
        const response = await axios.post(
          `https://fcm.googleapis.com/v1/projects/${PROJECT_ID}/messages:send`,
          message,
          {
            headers: {
              Authorization: `Bearer ${accessToken.token || accessToken}`,
              "Content-Type": "application/json",
            },
          }
        );
        console.log(`✅ Notificación enviada a ${token}`);
        results.push({ token, success: true, response: response.data });
      } catch (error) {
        console.error(`❌ Error en ${token}`, error.response?.data || error.message);
        results.push({ token, success: false, error: error.response?.data || error.message });
      }
    }

    return res.json({
      results,
      successCount: results.filter(r => r.success).length,
      failureCount: results.filter(r => !r.success).length,
    });
  } catch (error) {
    console.error("❌ Error general:", error);
    return res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${port}`);
});
