import admin from "firebase-admin";
import fs from "fs";
import path from "path";

const serviceAccountPath = path.resolve(
  __dirname,  process.env.GOOGLE_APPLICATION_CREDENTIALS || ""
);


if (!fs.existsSync(serviceAccountPath)) {
  throw new Error(`Service account file not found at ${serviceAccountPath}`);
}

const stats = fs.statSync(serviceAccountPath);
if (!stats.isFile()) {
    throw new Error(`Service account path is not a file: ${serviceAccountPath}`);
}


const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, "utf8"));

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
  
}
export const verifyFirebaseIdToken = async (token: string) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    
    return decodedToken;
  } catch (error) {
    console.error("Error verifying Firebase ID token:", error);
    throw new Error("Invalid Firebase ID token");
  }
};

export default admin;
