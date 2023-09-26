Class web.DHCPE.PreIADMReplace Extends %RegisteredObject
{

// w ##class(web.DHCPE.PreIADMReplace).Save("116^0000000056^备注^933")

// StrInfo  PreIADM^新登记号^备注^用户ID

ClassMethod Save(StrInfo)
{
	s PreIADM=$P(StrInfo,"^",1)
	s OldPIBI=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s NewRegNo=$P(StrInfo,"^",2)
	s NewRegNoIndex=$$ALPHAUP^SSUTIL4(NewRegNo)
	s NewPatID=$O(^PAPERi("PAPMI_PatNo",NewRegNoIndex,""))
	q:NewPatID="" "-1^his信息不存在"
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	s PAADM="",IsExecFlag=0
	i IADM'="" d
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.s IsExecFlag=##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm(PAADM)
	q:IsExecFlag="1" "-1^医嘱已执行，不能替换"


	s NewPIBI=$O(^DHCPEPreIBI(0,"PAPMINo",NewRegNo,0))
	s UserID=$P(StrInfo,"^",4)
	TSTART
	i NewPIBI=""
	{
		s ret=##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(NewRegNo, UserID)
		s NewPIBI=$O(^DHCPEPreIBI(0,"PAPMINo",NewRegNo,0))
		if NewPIBI=""
		{
			TROLLBACK
			q "-1^插入体检基本信息错误"
		}
	}
	&SQL(Update Sqluser.DHC_PE_PreIAdm set PIADM_PIBI_DR=:NewPIBI where PIADM_RowID=:PreIADM)
	
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新预约记录失败"
	}
	i PAADM'=""
	{ 
		&SQL(Update Sqluser.PA_Adm set PAADM_PAPMI_DR=:NewPatID where PAADM_RowID=:PAADM)
		i SQLCODE'=0
		{
			TROLLBACK
			q "-1^更新PAADM记录失败"
		}
	}
	s obj=##class(User.DHCPEPreIADMReplace).%New()
	d obj.PRPreIADMDRSetObjectId(PreIADM)
	d obj.PROldIBIDRSetObjectId(OldPIBI)
	d obj.PRNewIBIDRSetObjectId(NewPIBI)
	s obj.PRRemark=$P(StrInfo,"^",3)
	d obj.PRUserDRSetObjectId(UserID)
	s obj.PRUpdateDate=+$H
	s obj.PRUpdateTime=$P($H,",",2)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		TROLLBACK
		q "-1^插入替换记录错误:"_$System.Status.GetErrorText(sc)
	}else{
		TCOMMIT
		q obj.%Id()
	}
}

/// debug： w ##class(web.DHCPE.PreIADMReplace).GetPreInfo() 
ClassMethod GetPreInfo(PreIADM, HospID As %Library.String = "")
{
	q:PreIADM="" ""
	s PIBI=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
	s Status=##Class(web.DHCPE.PreCommon).TransStatus(Status)
	s PreGADM=$P(^DHCPEPreIADM(PreIADM),"^",2)
	s PreGTeam=$P(^DHCPEPreIADM(PreIADM),"^",3)
	s GDesc="",TeamDesc=""
	i PreGADM'="" d
	.s GBaseInfo=$P(^DHCPEPreGADM(PreGADM),"^",1)
	.s GDesc=$P(^DHCPEPreGBI(GBaseInfo),"^",2)
	.s TeamDesc=$P(^DHCPEPreGADM(PreGADM,"Team",$P(PreGTeam,"||",2)),"^",1)
	s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
	
	//i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	//s:VIPLevel'="" VIPLevel=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	s ADMLocDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",26) //就诊科室
	i VIPLevel="" s VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(ADMLocDR)
	s:VIPLevel'="" VIPLevel=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3) //VIP描述
	
	s HPNo=$P(^DHCPEPreIADM(PreIADM),"^",27)
	s OldRegNo=$P(^DHCPEPreIBI(PIBI),"^",1)
	s RoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreIADM))
	s:RoomPlace'="" RoomPlace=$P($G(^DHCPECTDataEx("RoomPlace",RoomPlace)),"^",2)
	;q Status_"^"_GDesc_"^"_TeamDesc_"^"_VIPLevel_"^"_HPNo_"^"_..GetBaseInfoByRegNo(OldRegNo)
	
	/***翻译 start***/
    s VIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPLevel,"VLDesc","cls")
    s Status=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmreplace.hisui.csp",Status)
    s RoomPlace=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPERoomPlace",RoomPlace,"RPDesc","cls")
    /***翻译 end***/
    
	q Status_"^"_GDesc_"^"_TeamDesc_"^"_VIPLevel_"^"_HPNo_"^"_RoomPlace_"^"_..GetBaseInfoByRegNo(OldRegNo,HospID,"0")
}

ClassMethod GetBaseInfoByRegNo(RegNo, HospID As %Library.String = "", IDCardType As %Library.String = "1")
{
	q:RegNo="" "^^^^^^^"
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s NewRegNoIndex=$$ALPHAUP^SSUTIL4(RegNo)
	s NewPatID=$O(^PAPERi("PAPMI_PatNo",NewRegNoIndex,""))
	q:NewPatID="" "^^^^^^^"
	
	s Name=$P($g(^PAPER(NewPatID,"ALL")),"^",1)
	s Dob=$P($g(^PAPER(NewPatID,"ALL")),"^",6)
	
	s Age=""
	s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(NewPatID,HospID)
	i Dob'="" 
	.;s Age=##class(web.DHCBillInterface).GetPapmiAge(NewPatID)
	s Sex=$P($g(^PAPER(NewPatID,"ALL")),"^",7)
	s:Sex'="" Sex=$P($g(^CT("SEX",Sex)),"^",2)
	//s IDCard=$P($g(^PAPER(NewPatID,"PAT",3)),"^",6)
	S PACCardDesc="",IDCard=""
	S PACCardTypeDR=$P($G(^PAPER(NewPatID,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	i (PACCardDesc["身份证")&&(IDCardType="1") s IDCard=$P($G(^PAPER(NewPatID,"PAT",3)),"^",6)
	e  s IDCard=$P($G(^PAPER(NewPatID,"PAT",3)),"^",6)

    s MaritalDesc=""
	s Marital=$P($G(^PAPER(NewPatID,"PER",2)),"^",3)
	//s:Marital'="" Marital=$P(^CT("MAR",Marital),"^",2)
	s:Marital'="" MaritalDesc=$P(^CT("MAR",Marital),"^",2)
	s PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	i (PIBIRowId'="")&(MaritalDesc="") d
    .s PIBIMarriedDR=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",17)
    .i PIBIMarriedDR'="" s MaritalDesc=$P($g(^CT("MAR",PIBIMarriedDR)),"^",2)
    
	/***翻译 start***/
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
   	s MaritalDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTMarital",MaritalDesc,"CTMARDesc","cls")
    /***翻译 end***/
    
	q NewPatID_"^"_RegNo_"^"_Name_"^"_Sex_"/"_Age_"^"_MaritalDesc_"^"_IDCard_"^"_PACCardDesc
}

/// 提供给Web页面 显示站点的的列表 DHCPEStationListCom
Query ReplaceList(PreIADM As %Library.String = "") As %SQLQuery(ROWSPEC = "TUpdateDate:%String,TUpdateTime:%String,TUpdateUser:%String,TRemark:%String,TOldInfo:%String,TNewInfo:%String")
{
	select PR_UpdateDate,PR_UpdateTime,PR_User_DR->SSUSR_Name||'('||PR_User_DR->SSUSR_Initials||')',PR_Remark,PR_OldIBI_DR->PIBI_Name||'('||PR_OldIBI_DR->PIBI_PAPMINo||')',PR_NewIBI_DR->PIBI_Name||'('||PR_NewIBI_DR->PIBI_PAPMINo||')'
	from Sqluser.DHC_PE_PreIADMReplace where PR_PreIADM_DR=:PreIADM
}

Query ReplaceListNew(PreIADM As %String = "") As %Query(ROWSPEC = "TUpdateDate:%String,TUpdateTime:%String,TUpdateUser:%String,TRemark:%String,TOldInfo:%String,TNewInfo:%String")
{
}

ClassMethod ReplaceListNewExecute(ByRef qHandle As %Binary, PreIADM As %String = "") As %Status
{
   //d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADMReplace","ReplaceListNew","") 
	Set repid=$I(^CacheTemp)
	s ind=1
	if (PreIADM=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	S ID=""
	f  s ID=$o(^User.DHCPEPreIADMReplaceI("PRPreIADMDRIndex",PreIADM,ID))   q:ID=""  d
	.s UpdateDate=$LG(^User.DHCPEPreIADMReplaceD(ID),7)
	.i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	.s UpdateTime=$LG(^User.DHCPEPreIADMReplaceD(ID),8)
	.i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	.s UpdateUser=$LG(^User.DHCPEPreIADMReplaceD(ID),6)
	.i UpdateUser'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)_"("_$p($g(^SSU("SSUSR",UpdateUser)),"^",1)_")" 
	.s Remark=$LG(^User.DHCPEPreIADMReplaceD(ID),5)
	.s OldInfo=$LG(^User.DHCPEPreIADMReplaceD(ID),3)
	.i OldInfo'="" s OldInfo=$p($g(^DHCPEPreIBI(OldInfo)),"^",2)_"("_$p($g(^DHCPEPreIBI(OldInfo)),"^",1)_")" 
	.s NewInfo=$LG(^User.DHCPEPreIADMReplaceD(ID),4)
	.i NewInfo'="" s NewInfo=$p($g(^DHCPEPreIBI(NewInfo)),"^",2)_"("_$p($g(^DHCPEPreIBI(NewInfo)),"^",1)_")" 
 	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(UpdateDate,UpdateTime,UpdateUser,Remark,OldInfo,NewInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ReplaceListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReplaceListNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReplaceListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReplaceListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
