import { cookies } from "next/headers";
import { redirect } from "next/navigation";

async function login(formData: FormData) {
  "use server";

  const email = String(formData.get("email") || "");
  const password = String(formData.get("password") || "");
  const expectedEmail = process.env.CONSULTANT_EMAIL || "admin@rjlf.local";
  const expectedPassword = process.env.CONSULTANT_PASSWORD || "admin";
  const token = process.env.CONSULTANT_SESSION_TOKEN || "local-dev-token";

  if (email === expectedEmail && password === expectedPassword) {
    cookies().set("rjlf_session", token, {
      httpOnly: true,
      sameSite: "lax",
      path: "/",
      maxAge: 60 * 60 * 12
    });
    redirect("/");
  }

  redirect("/login?erro=1");
}

export default function LoginPage({ searchParams }: { searchParams: { erro?: string } }) {
  return (
    <main>
      <section className="hero" style={{ maxWidth: 520, margin: "48px auto" }}>
        <span className="tag">Acesso interno</span>
        <h1>Entrar</h1>
        <p className="muted">Use o e-mail e a senha configurados no arquivo .env.</p>
        {searchParams.erro ? <p className="error">E-mail ou senha incorretos.</p> : null}
        <form action={login}>
          <label>E-mail</label>
          <input name="email" type="email" placeholder="admin@rjlf.local" required />
          <label>Senha</label>
          <input name="password" type="password" placeholder="Senha" required />
          <button type="submit">Entrar</button>
        </form>
      </section>
    </main>
  );
}
