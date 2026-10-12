import { redirect } from "next/navigation";
import { prisma } from "@/lib/prisma";
import { setConsultantSession, setUserSession, verifyPassword } from "@/lib/auth";

async function login(formData: FormData) {
  "use server";

  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  const expectedEmail = process.env.CONSULTANT_EMAIL || "admin@rjlf.local";
  const expectedPassword = process.env.CONSULTANT_PASSWORD || "admin";

  if (email === expectedEmail && password === expectedPassword) {
    setConsultantSession();
    redirect("/");
  }

  const user = await prisma.appUser.findUnique({ where: { email } });
  if (user?.active && verifyPassword(password, user.passwordHash)) {
    setUserSession(user.id);
    if (user.role === "COLABORADOR") redirect("/meu-rcf");
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
        <p className="muted">Use o e-mail e a senha cadastrados para consultor, avaliador ou colaborador.</p>
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
