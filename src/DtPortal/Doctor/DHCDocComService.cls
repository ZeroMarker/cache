/// 名称:DtPortal.Doctor.DHCDocComService
/// 描述:Portal D01 患者列表公共服务
/// 编写者：赵忠原
/// 编写日期: 2014-07-9
Class DtPortal.Doctor.DHCDocComService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 功能描述：向Portal推送排班信息
/// 参数：ASRowid,排班记录Rowid; BusinessCode,业务代码(1:新增或修改;3:删除)
/// Creator:赵忠原
/// modify：徐鹏,2014-09-04.
/// 		修改内容：(1)增加了业务编码;(2)接口参数Input增加后面的两个节点,ASRowid:业务唯一编码;BusinessCode:业务代码
/// w ##class(DtPortal.Doctor.DHCDocComService).SendOScheInfoPortal("459||1")
ClassMethod SendOScheInfoPortal(ASRowid As %String, BusinessCode As %String = 1) As %String
{
	n (ASRowid,BusinessCode)
	s Input=""
	s ^DHCXPTest("SendPortal","Schedule")=ASRowid
	s AsDate=$p(^RBAS(+ASRowid,$p(ASRowid,"||",2)),"^",1)
	if AsDate'="" s AsDate=$zd(AsDate,3)
	s CTPCPID=$p(^RB("RES",+ASRowid),"^",2)
	s DeptDr=$p(^RB("RES",+ASRowid),"^",1)
	q:DeptDr="" ""
	s ret=""
    s Type="Outpatient"
	s RowId=""
	f  s RowId=$o(^User.DHCMarkDocI("MarkddepDrIndex",DeptDr,RowId)) q:RowId=""  d
	.s MarkDr=$list(^User.DHCMarkDocD(RowId),3)
	.s DocDr=$list(^User.DHCMarkDocD(RowId),2)
	.q:MarkDr'=CTPCPID
	.s DocCode=""
	.if DocDr'="" d
	..s UserId=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
	..i UserId'="" s DocCode=$p(^SSU("SSUSR",UserId),"^",1)
	.q:DocCode=""
	
	.s ApptDetails=..GetApptDetails(ASRowid)
	.s Input=DocCode_"^"_"门诊出诊信息"_"^"_1_"^"_AsDate_"^"_AsDate_"^"_ApptDetails_"^"_Type_"^"_"0"_"^"_ASRowid_"^"_BusinessCode
	
	q Input
}

/// 功能：获取排班详细信息
/// Creator:徐鹏,2014-09-04
/// w ##class(DtPortal.Doctor.DHCDocComService).GetApptDetails("1315||381")
ClassMethod GetApptDetails(ASRowId As %String) As %String
{
	n (ASRowId)
	s ApptDetails=""
	s ResRowId=+ASRowId
	s ASChildSub=$P(ASRowId,"||",2)
	// 出诊时段
	s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	i TRRowId="" s TRDesc=""
	e  s:TRRowId'="" TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	// 出诊科室
	s DeptDr=$p(^RB("RES",ResRowId),"^",1)
	i DeptDr=""  s DeptDesc=""
	e  s DeptDesc=$p($g(^CTLOC(DeptDr)),"^",2)
	if (DeptDesc'="")&&($p(DeptDesc,"-",2)'="") s DeptDesc=$p(DeptDesc,"-",2)
	// 出诊诊室
	s RoomDR=$P($G(^RBAS(+ASRowId,ASChildSub,"DHC")),"^",5)
	i RoomDR="" s Room=""
	e  s Room=$P(^CTLOC(RoomDR),"^",2)
	// 出诊级别
	s SessionTypeDr=$P($G(^RBAS(+ASRowId,ASChildSub,"DHC")),"^",6)
	s SESSConv=""
	i SessionTypeDr'="" s SESSConv=$p($g(^RBC("SESS",SessionTypeDr)),"^",2)
	s ApptDetails=""
	s ApptDetails="{"_"'TRDesc'"_":"_"'"_TRDesc_"'"_","_"'"_"Room"_"'"_":"_"'"_Room_"'"_","_"'"_"DeptDesc"_"'"_":"_"'"_DeptDesc_"'"_","_"'"_"SESSConv"_"'"_":"_"'"_SESSConv_"'"_"}"
	q ApptDetails
}

// 向Portal推送预约信息

// w ##class(DtPortal.Doctor.DHCDocComService).SendAppInfoPortal("739||1918||1")

ClassMethod SendAppInfoPortal(InputParam As %String) As %String
{
	n (InputParam)
	set RBAppId=$p(InputParam,"^",1)
	set OperateType=$p(InputParam,"^",2)
	s Input=""
	s object=##class(User.RBAppointment).%OpenId(RBAppId)
	s PatientID=object.APPTPAPMIDR.%Id()
	d object.%Close()
	if (PatientID=""){
		s obj=##class(User.DHCRBAppointment).%OpenId(RBAppId)
		s CredNo=obj.APPTCredNo
		s Name=obj.APPTPatientName
		s Sex=""
		s Tel=obj.APPTMobilePhone
		s Address=obj.APPTPatientAddress
		d obj.%Close()
	}else {
		s Name=$P(^PAPER(PatientID,"ALL"),"^",1)
		Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
		if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
		s Tel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
		s CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
		s Address=$p($g(^PAPER(PatientID,"PER","ADD",1)),"^",1) ;住址
	}
	s jsonobj = ##class(ext.util.JsonObject).%New()
	d jsonobj.Put("Name",Name)
	d jsonobj.Put("Sex",Sex)
	d jsonobj.Put("CredNo",CredNo)
	d jsonobj.Put("Tel",Tel)
	d jsonobj.Put("Address",Address)
	s retJson=jsonobj.Json()
	s AsDate=$p(^RBAS(+RBAppId,$p(RBAppId,"||",2)),"^",1)
	if AsDate'="" s AsDate=$zd(AsDate,3)
	s CTPCPID=$p(^RB("RES",+RBAppId),"^",2)
	s DeptDr=$p(^RB("RES",+RBAppId),"^",1)
	;s DocCode="001"
	;s AsDate="2014-08-13"
    s Type="OPAppointment"
    s ret=""
    s DocCode=""
    if (CTPCPID'="") s DocCode=$p($g(^CTPCP(CTPCPID,1)),"^",1)
    if (DocCode'="") d
    .s UserId=$o(^SSU("SSUSR",0,"CTPCP",CTPCPID,0))
    .q:UserId=""
    .s Input=DocCode_"^"_"预约信息"_"^"_1_"^"_AsDate_"^"_AsDate_"^"_retJson_"^"_Type_"^"_"0"_"^"_RBAppId_"^"_OperateType
    /*
    s RowId=""
	f  s RowId=$o(^User.DHCMarkDocI("MarkddepDrIndex",DeptDr,RowId)) q:RowId=""  d
	.s MarkDr=$list(^User.DHCMarkDocD(RowId),3)
	.s DocDr=$list(^User.DHCMarkDocD(RowId),2)
	.q:MarkDr'=CTPCPID
	.//s DocCode=""
	.if (DocDr'="")&&(DocCode="") d
	..s UserId=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
	..i UserId'="" s DocCode=$p(^SSU("SSUSR",UserId),"^",1)
	.q:DocCode=""
	
	.s Input=DocCode_"^"_"预约信息"_"^"_1_"^"_AsDate_"^"_AsDate_"^"_retJson_"^"_Type_"^"_"0"_"^"_RBAppId_"^"_1*/
	
	
	q Input
}

}
