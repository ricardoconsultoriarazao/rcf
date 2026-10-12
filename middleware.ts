import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const token = request.cookies.get("rjlf_session")?.value;
  const expected = process.env.CONSULTANT_SESSION_TOKEN || "local-dev-token";
  const isLogin = request.nextUrl.pathname.startsWith("/login");
  const isApi = request.nextUrl.pathname.startsWith("/api");

  if (isLogin || isApi) return NextResponse.next();
  if (token === expected) return NextResponse.next();

  const url = request.nextUrl.clone();
  url.pathname = "/login";
  return NextResponse.redirect(url);
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"]
};
