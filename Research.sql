-- First Level Analysis; Gibt die Anzahl Patentanmeldungen pro Jahr aus
SELECT p.year, COUNT(p.patent_id) as count
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group ccg
  ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
GROUP BY p.year;

SELECT COUNT(p.patent_id) as count, a.organization, p.year
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group ccg
  ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
JOIN Patentsview.assignee a ON a.assignee_id = P.firstnamed_assignee_id
  GROUP BY a.organization, p.year
  HAVING COUNT(p.patent_id) > 2
  ORDER BY p.year

SELECT COUNT(a.organization) as count, p.year
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group ccg
  ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
JOIN Patentsview.assignee a ON a.assignee_id = P.firstnamed_assignee_id
  GROUP BY p.year
  ORDER BY p.year

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
-- Boeing: 156489
-- NASA: 141793
-- Lockheed: 135146
-- Navy: 195602
-- Thales: 61225
WITH OrgCount (assignee_id, organization, count) AS
       (
         SELECT a.assignee_id, a.organization, COUNT(p.patent_id)
         FROM Patentsview.patent p
                JOIN Patentsview.cpc_current_group ccg ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'
         JOIN Patentsview.assignee a ON a.assignee_id = P.firstnamed_assignee_id
         GROUP BY a.assignee_id, a.organization
         --ORDER BY COUNT(p.patent_id) DESC
       )
SELECT p.year, oc.assignee_id, COUNT(ccg.patent_id) AS count
FROM Patentsview.cpc_current_group ccg
       JOIN Patentsview.patent p
            ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
       JOIN OrgCount oc ON oc.assignee_id = p.firstnamed_assignee_id
WHERE oc.assignee_id IN (156489, 141793, 135146, 195602, 61225)
GROUP BY p.year, oc.assignee_id, p.year
--HAVING COUNT(p.patent_id) >= 3 -- Could be used to select all that have more than 3 per year
ORDER BY p.year;

SELECT p.abstract, p.title, p.year
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group ccg ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'
WHERE p.firstnamed_assignee_id in (156489, 141793, 135146, 195602, 61225);

WITH PatentGroup(patent_id, title, group_id) AS
    (
        SELECT p.patent_id, p.title, ccg.group_id
        FROM Patentsview.patent p
        JOIN Patentsview.cpc_current_group ccg
        ON ccg.patent_id = p.patent_id
    )
SELECT p.patent_id, p.title, p.group_id
FROM PatentGroup p
JOIN Patentsview.cpc_current_group ccg
ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'

SELECT p.patent_id, p.title, a.organization
FROM Patentsview.patent p
JOIN Patentsview.cpc_current_group c
ON p.patent_id = c.patent_id AND c.group_id = 'B64G'
JOIN Patentsview.assignee a
ON a.assignee_id = p.firstnamed_assignee_id
WHERE a.assignee_id in (156489, 141793, 135146, 195602, 61225);


SELECT * FROM Patentsview.assignee WHERE organization = 'RCA Corporation';