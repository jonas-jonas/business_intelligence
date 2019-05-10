-- First Level Analysis; Gibt die Anzahl Patentanmeldungen pro Jahr aus
SELECT p.year, COUNT(p.patent_id) as count
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group ccg
  ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
GROUP BY p.year;

-- Second Level Analysis; Gibt zu jedem Jahr, jedes Land und die Anzahl der Patentanmeldung des Jahres aus
-- Head: year, country, count
--       1970, DE, 123
--       1970, US, 147
WITH CountryCount (country, count) AS
       (
         SELECT TOP 10 COALESCE(p.firstnamed_assignee_country, p.firstnamed_inventor_country), COUNT(p.patent_id)
         FROM Patentsview.patent p
                JOIN Patentsview.cpc_current_group ccg ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'
         GROUP BY COALESCE(p.firstnamed_assignee_country, p.firstnamed_inventor_country)
         ORDER BY COUNT(p.patent_id) DESC
       )
SELECT p.year, cc.country, COUNT(ccg.patent_id) AS count
FROM Patentsview.cpc_current_group ccg
       JOIN Patentsview.patent p
            ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
       JOIN CountryCount cc ON cc.country = COALESCE(p.firstnamed_assignee_country, p.firstnamed_inventor_country)
GROUP BY p.year, cc.country
ORDER BY p.year;



