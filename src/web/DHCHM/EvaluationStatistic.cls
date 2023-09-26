Class web.DHCHM.EvaluationStatistic Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCHM.EvaluationStatistic","FindTblTree",1004)
Query FindTblTree(CodeType) As %Query(ROWSPEC = "id:%String:id,text:%String:text,leaf:%String:leaf,checked:%String:checked")
{
}

ClassMethod FindTblTreeExecute(ByRef qHandle As %Binary, CodeType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CodeType=" "_CodeType
	s Ordersub="" 
	f  s Ordersub=$o(^User.DHCHMCSettingI("STypeCodeIndex",CodeType,Ordersub)) q:Ordersub=""  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCSettingI("STypeCodeIndex",CodeType,Ordersub,ID))  quit:ID=""  d
	..d BuildDataFindTblTree
	Quit $$$OK
BuildDataFindTblTree
	d ResetVariablesFindTblTree
	s obj=##class(User.DHCHMCSetting).%OpenId(ID)
	s SCode = obj.SCode
	//s SOrder = obj.SOrder
	s SRemark = obj.SRemark
	//s STable = obj.STable
	//s STypeCode = obj.STypeCode
	s SValue = obj.SValue
	q:SValue'="Y"
	s SRemark=SRemark
	s Sleaf="true"
	s Tch="null"
	d OutputRowFindTblTree
	quit
OutputRowFindTblTree
	s Data=$lb(SCode,SRemark,Sleaf,Tch)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindTblTree
	s (SCode,SRemark,Sleaf,Tch)=""
	quit
}

ClassMethod FindTblTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTblTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTblTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTblTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.EvaluationStatistic","FindBaseInfoByType","","","")
Query FindBaseInfoByType(VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Query(ROWSPEC = "OQEId:%String,vBIPAPMINo:%String,vName:%String,SexDesc:%String,Date:%String,EducationDesc:%String,MaritalDesc:%String")
{
}

ClassMethod FindBaseInfoByTypeExecute(ByRef qHandle As %Binary, VStartDate As %String = "", VEndDate As %String = "", HCId As %String = "") As %Status
{
 	new repid, index,ID
 	k ^ypp
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s VStartDate=##class(websys.Conversions).DateHtmlToLogical(VStartDate)
	s VEndDate=##class(websys.Conversions).DateHtmlToLogical(VEndDate)
	i (VStartDate="")&&(VEndDate="") d
	.s VStartDate=+$H-15
	.s VEndDate=+$H
	i VStartDate="" s VStartDate=0
	i VEndDate="" s VEndDate=+$H
	s Date=VStartDate-1
	f  s Date=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date)) q:(Date="")||(Date>VEndDate)  d
	.s OERId=0
	.f  s OERId=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date,OERId)) q:OERId=""  d
	..s OERobj=##class(User.DHCHMOEvaluationRecord).%OpenId(OERId)
	..s OBIobj=OERobj.QOBaseInfoDR
	..s EducationDesc=OERobj.QCEducationDR.CTDesc
	..s MaritalDesc=OERobj.QCMaritalDR.CTDesc
	..s Sub=0
	..f  s Sub=$o(^User.DHCHMOQEQuestionI("QEQAddDateIndex",Date,OERId,Sub)) q:Sub=""  d
	...s OQEId=OERId_"||"_Sub
	...q:..MatchHumClass(OQEId,HCId)'=1
	...d BuildDataFindBaseInfoByType
	Quit $$$OK
BuildDataFindBaseInfoByType
	s vName=OBIobj.BIName
	s vBIPAPMINo=OBIobj.BIPAPMINo
	i $ISOBJECT(OBIobj.BICSexDR) d
	.s SexDR=OBIobj.BICSexDR.%Id()
	.i SexDR'="" d
	..s SexDesc=OBIobj.BICSexDR.CTDesc
	s vDate=$zd(Date,3)
	d OutputRowFindBaseInfoByType
	quit
OutputRowFindBaseInfoByType
	s Data=$lb(OQEId,vBIPAPMINo,vName,SexDesc,vDate,EducationDesc,MaritalDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

/// w ##class(web.DHCHM.EvaluationStatistic).MatchHumClass("61||96",2)
ClassMethod MatchHumClass(OQEQID, HCID)
{
	s ^tmpwgy("MatchHumClass")=$lb(OQEQID,HCID)
	q:HCID="" 1  //为空时全匹配
	s Flag=0
	s OQEDetailDr=""
	f  s OQEDetailDr=$o(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",+OQEQID,$P(OQEQID,"||",2),OQEDetailDr))  q:(OQEDetailDr="")||(Flag=1)  d
	.s Active=$LG(^User.DHCHMCEvaluationDetailD(OQEDetailDr),2)
	.q:Active'="Y"
	.s Desc=$LG(^User.DHCHMCEvaluationDetailD(OQEDetailDr),5)
	.q:Desc'="人员分类"   //暂时用名称匹配
	.s OQEDvaSub=$O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",+OQEQID,$P(OQEQID,"||",2),OQEDetailDr,""))
	.s OQEDvaResult=$lg(^User.DHCHMOQEQuestionD(+OQEQID,$P(OQEQID,"||",2),"DHCHMOQEvaluation",OQEDvaSub),4)
	.s:OQEDvaResult=HCID Flag=1
	q Flag
}

ClassMethod FindBaseInfoByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBaseInfoByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBaseInfoByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
