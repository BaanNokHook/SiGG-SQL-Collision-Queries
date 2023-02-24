CREATE OR REPLACE FUNCTION fnc_recommended_peer(choosePeer varchar)  
    RETURNS varchar  
AS 
$$
WITH rcmd_peers AS  
        (SELECT fr.nickname, recomendedpeer, count(recomendedpeer) AS countRcmnd  
        FROM (SELECT nickname, peer2 AS friend 
            FROM peers 
                    JOIN friends ON peers.nickname = peer1) AS fr
                LEFT JOIN recommendations ON fr.friend = recommendations.peer   
            WHERE nickname = choosePeer
                AND nickname != recommendations.recommendedpeer  
            GROUP BY recommendedpeer, fr.nickname  
            ORDER BY fr.nickname, recomendedpeer)  
SELECT recomendedpeer
FROM rcmd_peers  
order by countRcmnd DESC 
LIMIT 1  

$$
    LANGUAGE sql;  

SELECT nickname AS Peer, fnc_recommended_peer(nickname) AS RecomendedPeer  
FROM peers;  