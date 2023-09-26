Class DHCEPRFS.ThirdParty.BL.BLCheckNeedCreate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.BLCheckNeedCreate).Check84NeedCreate("5365109")
ClassMethod Check84NeedCreate(AEpisodeID As %String) As %String
{
	//获取出院科室ID
	s disLocID = $P($g(^PAADM(AEpisodeID)),"^",4)
	//出院科室是重症监护，那么需要生成
	q:(disLocID = "40") "1"
	
	q:($p(^PAADM(AEpisodeID),"^",2)'="I") "0"
 	q:($p(^PAADM(AEpisodeID),"^",20)="C") "0"
 	q:($p(^PAADM(AEpisodeID),"^",75)'="") "0"  //新生儿不算转科
 	
 	s flag = "false"
 	s transChildsub = ""
 	for {
		s transChildsub = $o(^PAADM(AEpisodeID,"TRANS",transChildsub))	 
		q:(transChildsub = "")
		
		s transCtlocDR = $p(transChildsub,"^",6)
		if (transCtlocDR = "40")
		{
			s flag = "true"
			q
		}
	}
	
	q:(flag = "true") "1"
	q "0"
}

}
