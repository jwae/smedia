export const API_BASE = "/api";

export async function apiRequest(path, options = {}) {
  const response = await fetch(`${API_BASE}${path}`, options);
  const contentType = response.headers.get("content-type") || "";
  const rawText = await response.text();
  let payload = null;

  if (rawText) {
    if (contentType.includes("application/json")) {
      try {
        payload = JSON.parse(rawText);
      } catch {
        throw new Error(`API-Antwort fuer ${path} enthielt ungueltiges JSON.`);
      }
    } else {
      throw new Error(`API-Antwort fuer ${path} war kein JSON.`);
    }
  }

  if (!response.ok) {
    throw new Error(payload?.fehler || `API-Fehler ${response.status}`);
  }

  return payload;
}
