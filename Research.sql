-- Alle Patente von Blue Origin
SELECT * FROM Patentsview.patent p
JOIN Patentsview.assignee a
ON  p.firstnamed_assignee_id = a.assignee_id
WHERE a.organization = 'Blue Origin, LLC';

-- TODO, Alle Patente der NASA
SELECT abstract, a.organization FROM Patentsview.patent p
JOIN Patentsview.assignee a
ON  p.firstnamed_assignee_id = a.assignee_id
WHERE a.organization in (SELECT organization FROM Patentsview.assignee WHERE a.organization LIKE '%NASA%' AND a.lastknown_country = 'US' AND a.lastknown_city IN ('Washington', 'Cleveland', 'Houston'));

-- Alle Orgs die einen Namen haben der 'National Aeronautics and Space Administration' enthällt
SELECT a.assignee_id FROM Patentsview.assignee a WHERE a.organization LIKE '%National Aeronautics and Space Administration%';

-- Gib alle Gruppen aus in denen Blue Origin tätig ist.
SELECT g.title, g.id FROM Patentsview.cpc_group g
JOIN Patentsview.assignee_cpc_group acg
ON g.id = acg.group_id
JOIN Patentsview.assignee a
ON acg.assignee_id = a.assignee_id
WHERE a.organization = 'Blue Origin, LLC';

SELECT g.title, g.id FROM Patentsview.cpc_subsection g
JOIN Patentsview.assignee_cpc_subsection acg
ON g.id = acg.subsection_id
JOIN Patentsview.assignee a
ON acg.assignee_id = a.assignee_id
WHERE a.assignee_id = 141793;

SELECT * FROM Patentsview.assignee_cpc_subsection

-- Gib alle Firmen aus, die in der Gruppe 'Cosmonautics; vehicles or equipment therefor' tätig sind.
SELECT          a.organization,
                a.lastknown_country as country,
                a.num_patents
FROM Patentsview.cpc_current_group g
JOIN Patentsview.assignee_cpc_group acg ON g.group_id = acg.group_id
JOIN Patentsview.assignee a ON acg.assignee_id = a.assignee_id
JOIN Patentsview.patent p ON p.firstnamed_assignee_id = a.assignee_id
GROUP BY g.group_id, a.organization, a.lastknown_country, a.num_patents
HAVING g.group_id = 'B64G'
ORDER BY num_patents DESC;

SELECT * FROM Patentsview.patent
WHERE firstnamed_assignee_id IN (170241, 333303, 159376, 284716, 278243, 353946, 137242, 325872, 371068, 300797, 127748, 64071, 141793, 235138, 226957, 128841, 24388, 369165, 104300, 321921, 261466, 159118, 4903, 120128, 183001);

SELECT COUNT(*) FROM Patentsview.cpc_current_group WHERE group_id='B64G';
SELECT COUNT(*) FROM Patentsview.cpc_subgroup s
    JOIN Patentsview.cpc_current c ON c.subgroup_id = s.id
JOIN Patentsview.patent p ON c.patent_id = p.patent_id
WHERE id LIKE 'B64G%'

SELECT * FROM Patentsview.cpc_subgroup WHERE ;

