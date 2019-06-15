-- First Level Analysis; Gibt die Anzahl Patentanmeldungen pro Jahr aus
-- patents_by_year.csv
SELECT p.year, COUNT(p.patent_id) as count
FROM Patentsview.patent p
         JOIN Patentsview.cpc_current_group ccg
              ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
GROUP BY p.year
ORDER BY p.year;

-- 2nd Level Analysis: Gibt für jedes Jahr und Organisation die Anzahl der Patentanmeldungen aus
-- patents_by_year_and_org.csv
WITH OrgCount (assignee_id, organization, count) AS
         (
             SELECT a.assignee_id, a.organization, COUNT(p.patent_id)
             FROM Patentsview.patent p
                      JOIN Patentsview.cpc_current_group ccg ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'
                      JOIN Patentsview.assignee a ON a.assignee_id = P.firstnamed_assignee_id
             GROUP BY a.assignee_id, a.organization
         )
SELECT p.year, oc.organization, COUNT(ccg.patent_id) AS count
FROM Patentsview.cpc_current_group ccg
         JOIN Patentsview.patent p
              ON p.patent_id = ccg.patent_id AND ccg.group_id = 'B64G'
         JOIN OrgCount oc ON oc.assignee_id = p.firstnamed_assignee_id
WHERE oc.assignee_id IN (156489, 141793, 135146, 210405, 346284, 195602, 88663, 14140, 317785, 61225)
GROUP BY p.year, oc.organization, p.year
ORDER BY p.year;

-- WordCloud & Clustering
-- patent_groups.csv
SELECT p.patent_id, p.title, a.organization
FROM Patentsview.patent p
         JOIN Patentsview.cpc_current_group c
              ON p.patent_id = c.patent_id AND c.group_id = 'B64G'
         JOIN Patentsview.assignee a
              ON a.assignee_id = p.firstnamed_assignee_id
WHERE a.assignee_id in (156489, 141793, 135146, 210405, 346284, 195602, 88663, 14140, 317785, 61225);

-- Helper: Top 10 Orgs in B64G: Analyse Ziel
SELECT TOP 10 COUNT(p.patent_id) as count, a.assignee_id, a.organization
FROM Patentsview.patent p
         JOIN Patentsview.assignee a
              ON p.firstnamed_assignee_id = a.assignee_id
         JOIN Patentsview.cpc_current_group ccg
              ON ccg.patent_id = p.patent_id AND ccg.group_id = 'B64G'
GROUP BY a.assignee_id, a.organization
ORDER BY COUNT(p.patent_id) DESC
