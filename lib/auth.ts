import crypto from "crypto";
import { cookies } from "next/headers";
import { prisma } from "@/lib/prisma";

export type UserRole = "CONSULTOR" | "AVALIADOR" | "COLABORADOR";

const SESSION_COOKIE = "rjlf_session";
const USER_COOKIE = "rjlf_user";

function sessionSecret() {
  return process.env.CONSULTANT_SESSION_TOKEN || "local-dev-token";
}

function sign(value: string) {
  return crypto.createHmac("sha256", sessionSecret()).update(value).digest("hex");
}

export function hashPassword(password: string) {
  const salt = crypto.randomBytes(16).toString("hex");
  const hash = crypto.createHash("sha256").update(`${salt}:${password}`).digest("hex");
  return `${salt}:${hash}`;
}

export function verifyPassword(password: string, storedHash: string) {
  const [salt, hash] = storedHash.split(":");
  if (!salt || !hash) return false;
  const candidate = crypto.createHash("sha256").update(`${salt}:${password}`).digest("hex");
  if (hash.length !== candidate.length) return false;
  return crypto.timingSafeEqual(Buffer.from(hash), Buffer.from(candidate));
}

export function setConsultantSession() {
  cookies().set(SESSION_COOKIE, sessionSecret(), {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 12
  });
  cookies().delete(USER_COOKIE);
}

export function setUserSession(userId: string) {
  const value = `${userId}.${sign(userId)}`;
  cookies().set(SESSION_COOKIE, value, {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 12
  });
  cookies().set(USER_COOKIE, userId, {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 12
  });
}

export function clearSession() {
  cookies().delete(SESSION_COOKIE);
  cookies().delete(USER_COOKIE);
}

export async function getCurrentUser() {
  const token = cookies().get(SESSION_COOKIE)?.value;
  const envToken = sessionSecret();

  if (token === envToken) {
    return {
      id: "consultant-env",
      name: "Consultor RJLF",
      email: process.env.CONSULTANT_EMAIL || "admin@rjlf.local",
      role: "CONSULTOR" as UserRole,
      functionRoleId: null,
      collaboratorId: null
    };
  }

  const userId = cookies().get(USER_COOKIE)?.value;
  if (!token || !userId) return null;

  const [tokenUserId, signature] = token.split(".");
  if (tokenUserId !== userId || signature !== sign(userId)) return null;

  const user = await prisma.appUser.findUnique({
    where: { id: userId },
    include: { functionRole: true, collaborator: true }
  });

  if (!user || !user.active) return null;
  return user;
}

export async function requireCurrentUser() {
  const user = await getCurrentUser();
  if (!user) throw new Error("UNAUTHORIZED");
  return user;
}
