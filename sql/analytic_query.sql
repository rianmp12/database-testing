-- Análises Analíticas - Tarefa 3.5

-- Top 10 operadoras com maiores despesas no último trimestre
SELECT 
  o.razao_social,
  d.reg_ans,
  SUM(d.vl_saldo_final) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON o.registro_ans = d.reg_ans
WHERE d.descricao ILIKE '%CONHECIDOS OU AVISADOS%' 
  AND d.descricao ILIKE '%MEDICO HOSPITALAR%'
  AND d.data >= DATE '2024-07-01'
GROUP BY o.razao_social, d.reg_ans
ORDER BY total_despesas DESC
LIMIT 10;

-- Top 10 operadoras com maiores despesas no último ano
SELECT 
  o.razao_social,
  d.reg_ans,
  SUM(d.vl_saldo_final) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON o.registro_ans = d.reg_ans
WHERE d.descricao ILIKE '%CONHECIDOS OU AVISADOS%' 
  AND d.descricao ILIKE '%MEDICO HOSPITALAR%'
  AND d.data >= DATE '2023-10-01'
  AND d.data <= DATE '2024-10-01'
GROUP BY o.razao_social, d.reg_ans
ORDER BY total_despesas DESC
LIMIT 10;