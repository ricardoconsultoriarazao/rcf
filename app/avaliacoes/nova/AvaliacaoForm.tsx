"use client";

import { useMemo, useState } from "react";
import { expectedAnswer, questionGroups } from "@/lib/questions";

type Role = {
  id: string;
  title: string;
  area: string | null;
  mission: string;
  principal: string;
  autonomy: string;
  responsibilities: unknown;
  daily: unknown;
  indicators: unknown;
  behaviors: unknown;
  unacceptable: unknown;
  interactions: unknown;
  goals30: unknown;
  goals60: unknown;
  goals90: unknown;
};

function asList(value: unknown) {
  return Array.isArray(value) ? value.map(String) : [];
}

export default function AvaliacaoForm({ roles, selectedRoleId }: { roles: Role[]; selectedRoleId?: string }) {
  const [roleId, setRoleId] = useState(selectedRoleId || roles[0]?.id || "");
  const [cycle, setCycle] = useState<"30" | "60" | "90">("30");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");

  const role = useMemo(() => roles.find((item) => item.id === roleId) || roles[0], [roleId, roles]);
  const group = questionGroups[cycle];

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setSaving(true);
    setMessage("");

    const form = new FormData(event.currentTarget);
    const answers = group.questions.map(([question, intent], index) => ({
      question,
      intent,
      expected: expectedAnswer(question, role),
      answer: String(form.get(`answer-${index}`) || ""),
      score: Number(form.get(`score-${index}`) || 0) || null,
      observation: String(form.get(`observation-${index}`) || "")
    }));

    const payload = {
      roleId,
      cycle,
      collaboratorName: String(form.get("collaboratorName") || ""),
      collaboratorEmail: String(form.get("collaboratorEmail") || ""),
      evaluatorName: String(form.get("evaluatorName") || ""),
      status: String(form.get("status") || "Em desenvolvimento"),
      evidence: String(form.get("evidence") || ""),
      strengths: String(form.get("strengths") || ""),
      attention: String(form.get("attention") || ""),
      agreements: String(form.get("agreements") || ""),
      finalQuestion: String(form.get("finalQuestion") || ""),
      answers
    };

    const response = await fetch("/api/avaliacoes", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    setSaving(false);
    if (response.ok) {
      setMessage("Avaliacao salva com sucesso.");
      event.currentTarget.reset();
    } else {
      setMessage("Nao foi possivel salvar. Verifique os campos obrigatorios.");
    }
  }

  if (!role) return <p>Nenhum RCF carregado. Rode o seed do banco.</p>;

  return (
    <form onSubmit={submit}>
      <section className="panel">
        <h2>Identificacao</h2>
        <div className="grid">
          <div>
            <label>Funcao / RCF</label>
            <select value={roleId} onChange={(event) => setRoleId(event.target.value)}>
              {roles.map((item) => <option key={item.id} value={item.id}>{item.title}</option>)}
            </select>
          </div>
          <div>
            <label>Ciclo</label>
            <select value={cycle} onChange={(event) => setCycle(event.target.value as "30" | "60" | "90")}>
              <option value="30">30 dias</option>
              <option value="60">60 dias</option>
              <option value="90">90 dias</option>
            </select>
          </div>
          <div><label>Colaborador</label><input name="collaboratorName" required /></div>
          <div><label>E-mail do colaborador</label><input name="collaboratorEmail" type="email" /></div>
          <div><label>Gestor avaliador</label><input name="evaluatorName" required /></div>
          <div>
            <label>Status geral</label>
            <select name="status">
              <option>Em desenvolvimento</option>
              <option>Abaixo do esperado</option>
              <option>Dentro do esperado</option>
              <option>Acima do esperado</option>
              <option>Exige decisao gerencial</option>
            </select>
          </div>
        </div>
      </section>

      <section className="panel">
        <h2>Referencia do RCF selecionado</h2>
        <div className="grid">
          <div>
            <h3>{role.title}</h3>
            <p><strong>Area:</strong> {role.area}</p>
            <p><strong>Missao:</strong> {role.mission}</p>
            <p><strong>Resultado:</strong> {role.principal}</p>
            <p><strong>Autonomia:</strong> {role.autonomy}</p>
          </div>
          <div>
            <h3>O que buscar nas respostas</h3>
            <ul>
              <li>Se o colaborador entende a missao e o resultado principal.</li>
              <li>Se cita responsabilidades praticas da funcao.</li>
              <li>Se conhece indicadores de acompanhamento.</li>
              <li>Se demonstra comportamentos esperados.</li>
              <li>Se sabe quando agir e quando escalar ao gestor.</li>
            </ul>
          </div>
        </div>
        <div className="grid">
          <div><h3>Responsabilidades</h3><ul>{asList(role.responsibilities).slice(0, 5).map((item) => <li key={item}>{item}</li>)}</ul></div>
          <div><h3>Indicadores</h3><ul>{asList(role.indicators).slice(0, 6).map((item) => <li key={item}>{item}</li>)}</ul></div>
        </div>
      </section>

      <section className="hero">
        <span className="tag">{cycle} dias</span>
        <h1>{group.title}</h1>
        <p className="muted">{group.objective}</p>
      </section>

      {group.questions.map(([question, intent], index) => (
        <section className="question" key={question}>
          <h2>{index + 1}. Pergunta para o colaborador</h2>
          <p><strong>{question}</strong></p>
          <div className="hint"><strong>Intencao do gestor:</strong> {intent}</div>
          <div className="expected"><strong>Resposta esperada conforme RCF:</strong> {expectedAnswer(question, role)}</div>

          <label>Resposta do colaborador</label>
          <textarea name={`answer-${index}`} />

          <label>Nota do gestor neste ponto</label>
          <div className="score">
            {[1, 2, 3, 4, 5].map((score) => (
              <label key={score}><input type="radio" name={`score-${index}`} value={score} /> {score}</label>
            ))}
          </div>

          <label>Observacao / evidencia do gestor</label>
          <textarea name={`observation-${index}`} />
        </section>
      ))}

      <section className="panel">
        <h2>Fechamento</h2>
        <div className="grid">
          <div><label>Evidencias observadas</label><textarea name="evidence" /></div>
          <div><label>Pontos fortes</label><textarea name="strengths" /></div>
          <div><label>Pontos de atencao</label><textarea name="attention" /></div>
          <div><label>Combinados</label><textarea name="agreements" /></div>
        </div>
        <label>Pergunta final obrigatoria</label>
        <textarea name="finalQuestion" defaultValue="Se voce estivesse no meu lugar, olhando para sua propria evolucao, qual seria o feedback mais honesto que daria para voce hoje?" />
      </section>

      <p>
        <button type="submit" disabled={saving}>{saving ? "Salvando..." : "Salvar avaliacao"}</button>
      </p>
      {message ? <p className="panel">{message}</p> : null}
    </form>
  );
}
