Class web.DHCMDTMatReview Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCMDTMatReview).GetPageData("108","2^53^29^12175")
ClassMethod GetPageData(MdtID, LgParams)
{
	n (MdtID,LgParams)
	s DisGrpID=$p(^DHCMDTCON(MdtID),"^",16)    /// 疑难病种
	s LgUserID=$p(LgParams,"^",4)
	s DisGrpID=$p(^DHCMDTCON(MdtID),"^",16)    /// 疑难病种
	s CstStatus=$p(^DHCMDTCON(MdtID),"^",12)     /// 状态ID
	s:CstStatus'="" CstStatus=$p(^DHCMDTS(CstStatus),"^",2)
	s IsContact=##class(web.DHCMDTCom).LgUserIsContact(DisGrpID, LgUserID)
	s IsConsExperts=##class(web.DHCMDTCom).LgUserIsConsExperts(MdtID, LgUserID)
	s CstStatusID=$p(^DHCMDTCON(MdtID),"^",12)
	S CstStatusCode=""
	s:CstStatusID'="" CstStatusCode=$p(^DHCMDTS(+CstStatusID),"^",1)


	s Ret=CstStatus_"^"_IsContact_"^"_IsConsExperts_"^"_DisGrpID_"^"_CstStatusCode
	q Ret
}

}
