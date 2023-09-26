Class DHCEPRRBAC.BL.BLPrivilege Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CheckNoNeedApply(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AUserSSGroupID As %String)
{
	s ret = "0"

	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "QYFY")
	{
		//获取就诊入院科室ID
		s Loc = $P($g(^PAADM(AEpisodeID)),"^",4)  
		if (Loc = AUserLocID)
		{
			s ret = "1"
			q ret	
		}
		else
		{
			q ret	
		}
	}
	else
	{
		s ret = "1"
		q ret	
	}
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLPrivilege).CheckPrivilegeOut(00539881,2776,1673,1)
ClassMethod CheckPrivilegeOut(ARegNo As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String)
{
	//q "1"
	s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	q:(PAPMI = "") "0"
	    
	s nowDate = $p($h,",",1)   
	s ret = "0"
	//取所有门诊就诊
	s PAAdm = ""
	for {
		s PAAdm = $o(^PAPERdr(PAPMI,"ADM","O",PAAdm),-1)
		q:(PAAdm = "")
		//门诊日期为当天
		s PAAdmDate = $P($g(^PAADM(PAAdm)),"^",6) //入院日期

		if (PAAdmDate = nowDate)
		{
			//登录科室是门诊就诊科室，则允许
			s Loc = $P($g(^PAADM(PAAdm)),"^",4)
			if (Loc = ACTLocID) 
			{
				s ret = "1"
			}
		}

	}
	
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLPrivilege).CheckPrivilegeIn("00539881",2776,1673,1)
ClassMethod CheckPrivilegeIn(ARegNo As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String)
{
	//q "1"
	//b "s"
	s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	q:(PAPMI = "") "0"
 
	s nowDate = $p($h,",",1)   
	s ret = "0"
	//取所有住院就诊
	s PAAdm = ""
	for {
		s PAAdm = $o(^PAPERdr(PAPMI,"ADM","I",PAAdm),-1)
		q:(PAAdm = "")
		//医生出院日期
		s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",59) 
		//若为空表示仍住院，仍住院或者出院当天
		s:(PADischgeDate = $c(0)) PADischgeDate = ""
		if (PADischgeDate = "") || (PADischgeDate = nowDate)
		{
			//登录科室是住院就诊科室，则允许
			s Loc = $P($g(^PAADM(PAAdm)),"^",4)
			if (Loc = ACTLocID) 
			{
				s ret = "1"
			}
		}
	}
	q ret
}

}
