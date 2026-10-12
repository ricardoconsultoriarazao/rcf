export const questionGroups = {
  "30": {
    title: "Avaliacao de 30 dias",
    objective: "Verificar adaptacao, clareza da funcao, entendimento do RCF e primeiras dificuldades.",
    questions: [
      ["Como voce descreveria, com suas palavras, a missao da sua funcao?", "Avalia se o colaborador entendeu o proposito do cargo, nao apenas as tarefas."],
      ["Quais sao hoje as tres principais responsabilidades que voce entende que precisa cumprir?", "Mostra se ele sabe priorizar o que realmente sustenta a funcao."],
      ["O que voce acredita que a empresa espera como principal resultado da sua funcao?", "Conecta a rotina ao resultado esperado no RCF."],
      ["Quais atividades da sua rotina voce ja se sente seguro para executar?", "Identifica pontos que ja podem ganhar menor supervisao."],
      ["Quais atividades ainda geram duvida ou inseguranca?", "Indica necessidade de treinamento, padronizacao ou acompanhamento."],
      ["O que ficou claro para voce no RCF da sua funcao?", "Confirma compreensao do documento e dos pontos de gestao."],
      ["O que ainda nao ficou claro no seu RCF?", "Abre espaco para ajustar explicacao, exemplos e expectativas."],
      ["Quais indicadores ou resultados voce entende que serao acompanhados no seu trabalho?", "Verifica se ele sabe como sera medido."],
      ["Quais comportamentos voce acredita que sao mais importantes para ter sucesso nessa funcao?", "Avalia aderencia ao perfil profissional desejado."],
      ["Existe algum comportamento ou atitude que voce percebe que precisa ajustar?", "Estimula autoconsciencia e abertura ao feedback."],
      ["Com quais pessoas ou areas voce mais precisa se relacionar para executar bem sua funcao?", "Confirma entendimento das interfaces internas."],
      ["Onde voce percebe que ainda precisa de mais orientacao, treinamento ou acompanhamento?", "Transforma dificuldade em plano de apoio."],
      ["O que tem facilitado sua adaptacao ate agora?", "Ajuda o gestor a manter condicoes que favorecem performance."],
      ["O que tem dificultado sua adaptacao ate agora?", "Revela barreiras de processo, comunicacao, comportamento ou conhecimento."],
      ["Que apoio voce precisa do gestor para evoluir nos proximos 30 dias?", "Fecha com pedido claro e responsabilidade compartilhada."]
    ]
  },
  "60": {
    title: "Avaliacao de 60 dias",
    objective: "Verificar consistencia, autonomia inicial, cumprimento dos combinados e evolucao da rotina.",
    questions: [
      ["Desde nossa ultima conversa, em que pontos voce percebe que evoluiu?", "Compara evolucao real entre 30 e 60 dias."],
      ["Quais combinados feitos na avaliacao anterior voce conseguiu cumprir?", "Avalia compromisso e execucao."],
      ["Houve algum combinado que nao foi cumprido? O que aconteceu?", "Busca causa, nao desculpa."],
      ["Quais atividades voce ja consegue executar com autonomia?", "Mede reducao de dependencia do gestor."],
      ["Em quais situacoes voce ainda depende muito do gestor ou de outra pessoa?", "Identifica gargalos de autonomia."],
      ["Quais responsabilidades da funcao voce sente que ja domina?", "Confirma dominio percebido pelo colaborador."],
      ["Quais responsabilidades ainda precisam de melhoria?", "Direciona treinamento e acompanhamento."],
      ["Como voce acompanha se seu trabalho esta gerando o resultado esperado?", "Verifica maturidade de gestao por indicador."],
      ["Quais indicadores da sua funcao voce ja consegue entender ou acompanhar?", "Mostra se o colaborador saiu da execucao cega."],
      ["Quando algo sai do padrao, como voce costuma agir?", "Avalia criterio, comunicacao e proatividade."],
      ["Voce sente que sua rotina esta organizada? O que ainda precisa melhorar?", "Explora disciplina operacional."],
      ["Como esta sua comunicacao com as pessoas ou areas com quem voce precisa interagir?", "Mede qualidade das interfaces internas."],
      ["Que feedback recebido ate agora mais ajudou sua evolucao?", "Mostra o que funcionou na lideranca."],
      ["Que dificuldade ainda esta se repetindo?", "Identifica padrao que precisa ser interrompido."],
      ["O que voce acredita que precisa fazer para chegar aos 90 dias mais preparado?", "Cria foco para a etapa final."]
    ]
  },
  "90": {
    title: "Avaliacao de 90 dias",
    objective: "Avaliar autonomia, entrega real, aderencia cultural e decisao de continuidade ou desenvolvimento.",
    questions: [
      ["Apos 90 dias, como voce avalia sua evolucao na funcao?", "Abre a conversa com autoavaliacao madura."],
      ["O que voce entende hoje que e o principal resultado esperado do seu trabalho?", "Confirma clareza final do papel."],
      ["Voce acredita que esta entregando esse resultado? Por que?", "Exige justificativa com evidencias."],
      ["Quais responsabilidades voce ja executa com seguranca e autonomia?", "Define o que pode seguir com acompanhamento normal."],
      ["Quais responsabilidades ainda precisam de acompanhamento?", "Mostra lacunas de desenvolvimento."],
      ["Em quais situacoes voce ja consegue tomar decisao sem depender do gestor?", "Avalia autonomia pratica."],
      ["Em quais situacoes voce entende que deve escalar para o gestor?", "Avalia criterio e limite de alcada."],
      ["Quais indicadores mostram que seu trabalho esta funcionando?", "Conecta percepcao com medicao."],
      ["Que evidencias concretas mostram sua evolucao nesses 90 dias?", "Evita avaliacao baseada apenas em impressao."],
      ["O que voce aprendeu sobre a cultura e o jeito de trabalhar da empresa?", "Mede aderencia cultural."],
      ["Quais comportamentos voce acredita que mais demonstrou nesse periodo?", "Reforca comportamentos desejados."],
      ["Existe algum comportamento que voce ainda precisa corrigir?", "Mantem desenvolvimento ativo."],
      ["Como voce acredita que contribui para a equipe e para a experiencia do cliente?", "Avalia impacto alem da tarefa."],
      ["O que ainda pode comprometer sua performance se nao for ajustado?", "Identifica risco futuro."],
      ["Voce se sente preparado para seguir na funcao com acompanhamento normal?", "Fecha com percepcao de prontidao."]
    ]
  }
} as const;

export function expectedAnswer(question: string, role: any) {
  const text = question.toLowerCase();
  const join = (items: unknown, limit = 4) =>
    Array.isArray(items) ? items.slice(0, limit).join("; ") : "";

  if (text.includes("missao")) return `A resposta deve se aproximar da missao: ${role.mission}`;
  if (text.includes("responsabilidades") || text.includes("responsabilidade")) return `Deve citar responsabilidades como: ${join(role.responsibilities)}.`;
  if (text.includes("resultado")) return `Deve demonstrar entendimento do resultado principal: ${role.principal}`;
  if (text.includes("atividades") || text.includes("rotina")) return `Deve trazer atividades praticas como: ${join(role.daily)}.`;
  if (text.includes("indicadores")) return `Deve mencionar indicadores como: ${join(role.indicators, 5)}.`;
  if (text.includes("comportamentos") || text.includes("comportamento") || text.includes("cultura")) return `Deve demonstrar comportamentos esperados como: ${join(role.behaviors, 5)}.`;
  if (text.includes("pessoas") || text.includes("areas") || text.includes("comunicacao")) return `Deve reconhecer interfaces como: ${join(role.interactions, 5)}.`;
  if (text.includes("autonomia") || text.includes("decisao") || text.includes("escalar")) return `Deve respeitar a autonomia definida: ${role.autonomy}`;
  return `Deve estar conectada ao RCF de ${role.title}: missao, resultado esperado, responsabilidades, indicadores e comportamentos.`;
}
