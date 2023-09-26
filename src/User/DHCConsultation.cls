Include Nur.DateFormat

Class User.DHCConsultation Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_Consultation ]
{

// d ##class(User.DHCConsultation).%BuildIndices()

Property Adm As %String(TRUNCATE = 1);

// 医师级别

Property AppDep As %String(TRUNCATE = 1);

Property AppDate As %Library.Date(FORMAT = 1);

Property AppTime As %Library.Time;

Property AppDoc As %String(TRUNCATE = 1);

Property ConsultDep As %String(TRUNCATE = 1);

Property ConsultDoc As %String(TRUNCATE = 1);

Property ConsultDate As %Library.Date(FORMAT = 1);

Property ConsultTime As %Library.Time;

Property ConType As %Library.String(DISPLAYLIST = ",Emergency,Common,MultiLoc", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",E,C,M");

Property InOut As %Library.String(DISPLAYLIST = ",In,Out", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,O");

Property ConDestination As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0);

Property Attitude As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0);

Property Status As %Library.String(DISPLAYLIST = ",Verify,Excute,Cancel", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",V,E,C");

Property RelOrder As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1);

Property RecTime As %Library.Time;

Property RecUser As %String(TRUNCATE = 1);

Property RequestConDoc As %String(TRUNCATE = 1);

Property DocGrade As %String(TRUNCATE = 1);

Property Specordid As %String(TRUNCATE = 1);

Property MoreLoc As %String(TRUNCATE = 1);

Property ConsultGroupId As %String(TRUNCATE = 1);

// 特殊抗菌药医嘱id

Property attitudetsy As %String(TRUNCATE = 1);

Property ExcuteOrder As %String(TRUNCATE = 1);

/// ////////////////////////审核需要字段
/// 诊断
Property Diag As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0);

/// /实际执行的科室
Property ExecuteConDep As %String(TRUNCATE = 1);

/// /多科会诊地点
Property MoreConPlace As %String(TRUNCATE = 1);

/// /多科会诊要求会诊时间
Property MoreConTime As %String(TRUNCATE = 1);

/// 会诊指向--以后可能多科会诊撤销审核会用到  同仁医院
Property ConSultPontDr As User.DHCConSultationNew;

/// 会诊申请医嘱 --请什么科室会诊
Property ConSultApplyOrder As User.OEOrdItem;

/// /会诊科室子科室 会诊科室大科室对应的子科室
Property ItmConDep As %String(TRUNCATE = 1);

/// 会诊目的
Property ConDestinationtwo As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0);

/// /////////////////////////////////////////////////////////
Index Specordid On Specordid;

Index ArcimAdm On (Specordid, Adm);

Index Adm On Adm;

Index AppDep On (AppDate, AppDep);

Index ConSultDep On (AppDate, ConsultDep);

Index ConSultGroupDep On (ConsultGroupId, ConsultDep);

/// 多科会诊需要的索引
Index ExecuteConDep On (ConsultDate, ExecuteConDep);

Index ConSultPontDr On ConSultPontDr;

ClassMethod GetIPPayFlagByAdm(Adm)
{
 
	q:'$d(^DHCPB(0,"ADM",+Adm)) 0
	s Bill=""
	s payrtn=1
	 	f  s Bill=$o(^DHCPB(0,"ADM",+Adm,Bill)) q:Bill=""  d
	 	.s PayFlag=$p(^DHCPB(Bill),"^",16)
	 	.i PayFlag'="P" s payrtn=0
	 	q payrtn
}

ClassMethod SaveKjy(parr, InsertOrdFlag) As %String
{
	//##class(User.DHCConsultation).Save(
	s l=$L(parr,"^")
	s ^objcyf=parr //_"&"_InsertOrdFlag
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	s id=$G(tmp("id"))
	if id=""
	{  
		s a=##class(User.DHCConsultation).%New()
	}
	else
	{  
		s a=##class(User.DHCConsultation).%OpenId(id)
		s oldConsultDep=a.ConsultDep
		s oldConOrdId=a.RelOrder
	}
	if $D(tmp("EpisdeID")) s a.Adm=tmp("EpisdeID")
	if $D(tmp("AppDep")) s a.AppDep=tmp("AppDep")
	if $D(tmp("AppDate"))
	{
		if $G(tmp("AppDate"))'="" s a.AppDate=$$$ZDH(tmp("AppDate"),3)
		else  s a.AppDate=""
	}
	if $D(tmp("AppTime"))
	{
		if $G(tmp("AppTime"))'="" s a.AppTime=$ZTH(tmp("AppTime"))
		else  s a.AppTime=""
	}
	if $D(tmp("AppDoc")) s a.AppDoc=tmp("AppDoc")
	if $D(tmp("ConsultDep")) s a.ConsultDep=tmp("ConsultDep")
	if $D(tmp("ConsultDoc")) s a.ConsultDoc=tmp("ConsultDoc")
	if $D(tmp("ConsultDate"))
	{
		if $G(tmp("ConsultDate"))'="" s a.ConsultDate=$$$ZDH(tmp("ConsultDate"),3)
		else  s a.ConsultDate=""	
	}
	if $D(tmp("ConsultTime"))
	{
		if $G(tmp("ConsultTime"))'="" s a.ConsultTime=$ZTH(tmp("ConsultTime"))
		else  s a.ConsultTime=""
	}
	if $D(tmp("ConType")) s a.ConType=tmp("ConType")
	if $D(tmp("InOut")) s a.InOut=tmp("InOut")
	if $D(tmp("ConDestination")) s a.ConDestination=tmp("ConDestination")
	if $D(tmp("Attitude")) s a.Attitude=tmp("Attitude")
	if $D(tmp("Status")) s a.Status=tmp("Status")
	if $D(tmp("RelOrder")) s a.RelOrder=tmp("RelOrder")
	if $D(tmp("AppDoc")) s a.RecUser=tmp("AppDoc")
	if $D(tmp("Specordid")) s a.Specordid=tmp("Specordid")
	if $D(tmp("attitudetsy")) s a.attitudetsy=tmp("attitudetsy")
	s a.RecDate=+$H
	s a.RecTime=$P($H,",",2)
	if $D(tmp("RequestConDoc")) s a.RequestConDoc=tmp("RequestConDoc")
	if $D(tmp("DocGrade")) s a.DocGrade=tmp("DocGrade")
	if $D(tmp("MoreLoc")) s a.MoreLoc=tmp("MoreLoc")
	s consultrowid=$G(tmp("id"))
	if $D(tmp("consultGroupId")) s a.ConsultGroupId=tmp("consultGroupId")
	d a.%Save()
	d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",a.%Id(),1,tmp("EpisdeID")) //Gmin2016 portal消息推送
	s ConAppID=a.%Id()
	d ..Sendmessage($G(tmp("AppDoc")),$G(tmp("EpisdeID")),$G(tmp("RequestConDoc")),$g(tmp("ConsultDep")),ConAppID)
	q:$g(^DHCNurConsultSet("ifCreateOrderByApp"))'="Y" a.%Id() 
	//新建会诊申请时插入会诊医嘱,修改会诊科室停原会诊医嘱,新插一条
	s rtn=0
	s rtn=##class(web.DHCConsult).InsertConsultOrder($G(tmp("AppDoc")), $g(tmp("AppDep")),$G(tmp("EpisdeID")),$G(tmp("ConsultDep")),ConAppID,$G(tmp("InOut")),$G(tmp("DocGrade")),"A")
	q a.%Id()
}

ClassMethod Save(parr, InsertOrdFlag) As %String
{
	
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	s id=$G(tmp("id"))
	s adm=""
	if id=""
	{  
		s a=##class(User.DHCConsultation).%New()
		if $D(tmp("EpisdeID")) s a.Adm=tmp("EpisdeID")
		s adm=tmp("EpisdeID")
	}
	else
	{  
		s a=##class(User.DHCConsultation).%OpenId(id)
		s oldConsultDep=a.ConsultDep
		s oldConOrdId=a.RelOrder
		s oldStatus=a.Status
		s oldAppDoc=a.AppDoc
		s oldInOut=a.InOut
		s oldDocGrade=a.DocGrade
		s adm=a.Adm
	}
	
	s PayFlagobj=..GetIPPayFlagByAdm(adm)
	s admDep=$p($g(^PAADM(adm)),"^",4)
	s patType = $p($g(^PAADM(adm)),"^",2) 
 	i (PayFlagobj=1&patType="I") q "财务已结算,不能执行会诊!"
 	s PatVisit=$p($g(^PAADM(adm)),"^",20) //病人就诊状态 
 	s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
	q:(PatVisit="D")&(currentStatus'="B") "病人已出院" 
	if $D(tmp("AppDep")) s a.AppDep=tmp("AppDep")
	q:(admDep'=$g(tmp("AppDep")))&($g(tmp("Status"))="V") "非本科室医生不能为病人申请会诊!"
	
	if $D(tmp("AppDate"))
	{
		if $G(tmp("AppDate"))'="" s a.AppDate=$$$ZDH(tmp("AppDate"),3)
		else  s a.AppDate=""
	}
	if $D(tmp("AppTime"))
	{
		if $G(tmp("AppTime"))'="" s a.AppTime=$ZTH(tmp("AppTime"))
		else  s a.AppTime=""
	}
	if $D(tmp("AppDoc")) s a.AppDoc=tmp("AppDoc")
	if $D(tmp("ConsultDep")) s a.ConsultDep=tmp("ConsultDep")
	if $D(tmp("ConsultDoc")) s a.ConsultDoc=tmp("ConsultDoc")
	if $D(tmp("ConsultDate"))
	{
		if $G(tmp("ConsultDate"))'="" s a.ConsultDate=$$$ZDH(tmp("ConsultDate"),3)
		else  s a.ConsultDate=""	
	}
	if $D(tmp("ConsultTime"))
	{
		if $G(tmp("ConsultTime"))'="" s a.ConsultTime=$ZTH(tmp("ConsultTime"))
		else  s a.ConsultTime=""
	}
	if $D(tmp("ConType")) s a.ConType=tmp("ConType")
	if $D(tmp("InOut")) s a.InOut=tmp("InOut")
	;if $D(tmp("ConDestination")) s a.ConDestination=tmp("ConDestination")
	;if $D(tmp("Attitude")) s a.Attitude=tmp("Attitude")
	if $D(tmp("ConDestination")) d
	.i tmp("ConDestination")["<" s a.ConDestination=$Tr(tmp("ConDestination"),"<","﹤")
	.e  s a.ConDestination=tmp("ConDestination")
	if $D(tmp("Attitude")) d
	.i tmp("Attitude")["<" s a.Attitude=$Tr(tmp("Attitude"),"<","﹤")
	.e  s a.Attitude=tmp("Attitude")
	if $D(tmp("Status")) s a.Status=tmp("Status")
	if $D(tmp("RelOrder")) s a.RelOrder=tmp("RelOrder")
	if $D(tmp("AppDoc")) s a.RecUser=tmp("AppDoc")
	if $D(tmp("Specordid")) s a.Specordid=tmp("Specordid")
	if $D(tmp("attitudetsy")) s a.attitudetsy=tmp("attitudetsy")
	s a.RecDate=+$H
	s a.RecTime=$P($H,",",2)
	if $D(tmp("RequestConDoc")) s a.RequestConDoc=tmp("RequestConDoc")
	if $D(tmp("DocGrade")) s a.DocGrade=tmp("DocGrade")
    if $D(tmp("consultGroupId")) s a.ConsultGroupId=tmp("consultGroupId")
	d a.%Save()
	s ConAppID=a.%Id()
	//重发消息时处理之前的消息
	d ##class(websys.DHCMessageInterface).Exec("","1014",adm,"",ConAppID)
	d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",a.%Id(),1,adm)
	;i id=""  d //发送消息
	;.d ..Sendmessage($G(tmp("AppDoc")),adm,$G(tmp("RequestConDoc")),$g(tmp("ConsultDep")))
	//i id=""  d //发送消息
	d ..Sendmessage($G(tmp("AppDoc")),adm,$G(tmp("RequestConDoc")),$g(tmp("ConsultDep")),ConAppID,$g(tmp("DocGrade")))
	
	q:$g(^DHCNurConsultSet("ifCreateOrderByApp"))'="Y" 0 
	                     
	
	//新建会诊申请时插入会诊医嘱,修改会诊科室停原会诊医嘱,新插一条
	s rtn=0
	i id=""
	{
		s rtn=##class(web.DHCConsult).InsertConsultOrder($G(tmp("AppDoc")), $g(tmp("AppDep")),adm,$G(tmp("ConsultDep")),ConAppID,$G(tmp("InOut")),$G(tmp("DocGrade")),"A")
	}
	else
	{
		if ($D(tmp("AppDoc")))&&($D(tmp("AppDep"))){
			if $D(tmp("ConsultDep"))!($D(tmp("DocGrade")))!($D(tmp("InOut")))
			{
			if ($G(tmp("ConsultDep"))'=oldConsultDep)!($G(tmp("DocGrade"))'=oldDocGrade)!($G(tmp("InOut"))'=oldInOut)
			{
				if $G(tmp("AppDoc"))=$g(oldAppDoc)
				{
					s rtn=##class(appcom.OEOrdItem).UnUse(oldConOrdId,$G(tmp("AppDoc")))
				}else{
					s rtn=##class(appcom.OEOrdItem).Cancel(oldConOrdId,$G(tmp("AppDoc")))
				}
				
				s rtn=##class(web.DHCConsult).InsertConsultOrder($G(tmp("AppDoc")),$g(tmp("AppDep")), adm,$G(tmp("ConsultDep")),ConAppID,$G(tmp("InOut")),$G(tmp("DocGrade")),"A")		
				s insertedFlag=1
			}
		}
		if $g(oldStatus)="C"
		{
			if ((oldStatus)'=tmp("Status"))
			{
				if ($g(insertedFlag)'=1){
					s rtn=##class(web.DHCConsult).InsertConsultOrder($G(tmp("AppDoc")),$g(tmp("AppDep")),adm,$G(tmp("ConsultDep")),ConAppID,$G(tmp("InOut")),$G(tmp("DocGrade")),"A")	
				}
					
			}
		}		
	}
		
	}
	q rtn
}

// 发送消息

// w ##class(User.DHCConsultation).Sendmessage("359","426","78","1")

// 如果要求会诊医生为空则发送到会诊科室所有医生

ClassMethod Sendmessage(creatdoc, EpisodeID, receivedoc, dep, id = "", docGrade = "") As %String
{
	q:creatdoc="" ""
	q:EpisodeID="" ""
	i receivedoc'="" s receivedocdr=$o(^SSU("SSUSR",0,"CTPCP",receivedoc,""))
	e  d
	.s receivedocdr=..getlocdoc(dep,"DOCTOR",docGrade)
	s url=""""_"dhcconsult.csp?EpidsodeID="_EpisodeID_"&receivedoc="_receivedocdr_"&consultId="_id_""""
	s link="{""link"":"_url_",""dialogWidth"":"""_1000_""",""dialogHeight"":""900"",""BizObjId"":"_id_"}"
	s ToLocRowId=dep_"|OnlyFlag"
	s ret=##class(websys.DHCMessageInterface).Send("有会诊申请","1014",creatdoc , EpisodeID,"",receivedocdr, link,ToLocRowId)
	q ret
}

// w ##class(User.DHCConsultation).getlocdoc("9","DOCTOR")

// 根据类型取科室所有用户 DOCTOR:医生 NURSE:护士

ClassMethod getlocdoc(LocId, CareType, docGrade = "") As %String
{
	;s ^tempsc("getlocdoc")=LocId_","_ CareType_","_ docGrade
	    s retdocs=""
	    q:LocId="" retdocs
	    s ResId="" f  s ResId = $O(^RB("RES",0,"CTLOC",LocId,ResId)) q:ResId=""  d
		.s ResCTPCPDR = $p(^RB("RES",ResId),"^",2)	;
		.q:$g(^CTPCP(ResCTPCPDR,1))=""
		.i ResCTPCPDR>0 d
		..s CarPrvTpDR = $p(^CTPCP(ResCTPCPDR,1),"^",4) ;CTPCP_CarPrvTp_DR-->CT_CarPrvTp
		..q:CarPrvTpDR'=docGrade
		..s Type = $p(^CT("CPT",CarPrvTpDR),"^",4)		;CTCPT_InternalType
		..q:Type'=CareType
		..s DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",ResCTPCPDR,""))
		..i retdocs=""  d
		...s retdocs=DoctorUserDr
		..e  d
		...s retdocs=retdocs_"^"_DoctorUserDr
	q retdocs
}

// 113^CE^N^154^873^9"

// d ##class(User.DHCConsultation).ChangeStatus("178","E","Y","799","189","16")

ClassMethod ChangeStatus(id, statusCode, InsertOrdFlag, userId, EpisodeID, ConDepID = "") As %String
{
 ;s ^tempscv1("ChangeStatus")=id_","_ statusCode_","_ InsertOrdFlag_","_ userId_","_ EpisodeID_","_ ConDepID
 s PayFlagobj=..GetIPPayFlagByAdm(EpisodeID)
 s patType = $p($g(^PAADM(EpisodeID)),"^",2) 
 i (PayFlagobj=1&patType="I") q "财务已结算,不能对会诊操作!"
 s PatVisit=$p($g(^PAADM(EpisodeID)),"^",20) //病人就诊状态 
 s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
 q:(PatVisit="D")&(currentStatus'="B") "病人已出院,不能对会诊操作" 
 s rtn=""

 s allItem=$g(^User.DHCConsultationD(id))
 s curStatuscode=$listget(allItem,16)
 q:(statusCode="E")&(curStatuscode="E") "已经执行过了,不能执行了！"
 q:(statusCode="C")&(curStatuscode'="V") "不是申请状态,不能撤销！"
 q:(statusCode="E")&(curStatuscode="C") "已经撤销过了,不能执行了！"
 q:(statusCode="CE")&(curStatuscode'="E") "不是执行状态,不能撤销执行！"
 //i statusCode="E" d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",id,2,EpisodeID)
 //i statusCode="C" d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",id,3,EpisodeID)
 s a=##class(User.DHCConsultation).%OpenId(id)
 s Specordid=a.Specordid
 s attitudetsy=a.attitudetsy
 s adm=a.Adm    //121108

  s PayFlagobj=..GetIPPayFlagByAdm(adm) 
 i ((statusCode="CE")!(statusCode="C"))&(PayFlagobj=1)&patType="I" q "财务已结算,不能对会诊操作!"
 s PatVisit=$p($g(^PAADM(adm)),"^",20) //病人就诊状态 
 s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
 q:((statusCode="CE")!(statusCode="C"))&(PatVisit="D")&(currentStatus'="B") "病人已出院,不能对会诊操作！" 
 
 i (Specordid'="")&(attitudetsy="")&(statusCode="E") q "抗菌药物申请单请先填医生意见 ,再执行"
 if (statusCode="CE") {
	 s flag=""
	 i Specordid'="" d
	 .s arcitmid=$p(Specordid,"_")_"||"_$p(Specordid,"_",2)
	 .s flag=##class(DHCAnt.KSS.Common.Method).GetAntStatusForNurse(id) //Quinn 20170615
     i flag="0" q "抗菌药物申请单已审核不能撤销执行"
	 s a.Status="V"
	 d a.%Save()
 }
 else {
	 s a.Status=statusCode
	 d a.%Save()
 }
 
 ;s aaRowid=$o(^DHCDAAi("Consult",id,""))
 ;i (aaRowid)&&(aaRowid'="")&&(a.RequestConDoc'="") d ##class(DHCAnt.KSS.MainBusiness).DBUpdateConsultStatus(id) //QP 2016-09-01 抗菌药物
 if (Specordid'="") d ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatus(id,userId,statusCode) //Quinn 20170615
 i (statusCode="E")&($g(^DHCNurConsultSet("ifCreateOrderByExcute"))="Y") d
 .s ConAppID=id
 .s InOut=$listget(allItem,14)
 .s DocGrade=$listget(allItem,21)
 .s rtn=##class(web.DHCConsult).InsertConsultOrder(userId,ConDepID, EpisodeID,ConDepID,ConAppID,InOut,DocGrade,"E")
 .i rtn=0 d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",id,"2",adm)
 .s ConOrdId=$listget(allItem,15)
 //撤销时自动停关联的医嘱 (statusCode="C")!
 i (statusCode="CE")&($g(^DHCNurConsultSet("ifCreateOrderByExcute"))="Y") d
 .s ConOrdId=$listget(allItem,28)
 .q:ConOrdId=""
 .s rtn=##class(appcom.OEOrdItem).Cancel(ConOrdId,userId)
 .i rtn=0 d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000011",id,"1",adm)
 i (statusCode="C")&($g(^DHCNurConsultSet("ifCreateOrderByApp"))="Y") d
 .s ConOrdId=$listget(allItem,15)
 .q:ConOrdId=""
 .s rtn=##class(appcom.OEOrdItem).Cancel(ConOrdId,userId)
 s receivedoc=""
 i (statusCode="C")&&(a.RequestConDoc'="") d
 .s ctcpId=a.RequestConDoc
 .s ctcpCode=$p($g(^CTPCP(ctcpId,1)),"^",1)
 .s receivedoc=$O(^SSU("SSUSR",0,"SSUSR_Initials",ctcpCode,receivedoc))
 e  s receivedoc=userId
 s DocGrade=$listget(allItem,21)
 s receivedoc=..getlocdoc(ConDepID,"DOCTOR",DocGrade)
 s url=""""_"dhcconsult.csp?EpidsodeID="_EpisodeID_"&receivedoc="_receivedoc_"&consultId="_id_""""
 s link="{""link"":"_url_",""dialogWidth"":"""_1000_""",""dialogHeight"":""900"",""BizObjId"":"_id_"}"
 ;s ^tempscv1("handM")=receivedoc_","_EpisodeID_","_link
 d ##class(websys.DHCMessageInterface).Exec("","1014",EpisodeID,"",id,userId)
 q rtn
}

ClassMethod createConsultGroupId() As %String
{
	q $I(^consult("Group"))
#;	s ^consult("Group")=""
#;	if ^consult("Group")="" s ^consult("Group")=0
#;	s consultGroupId=^consult("Group")+1
#;	s ^consult("Group")=consultGroupId
#;	q consultGroupId
}

ClassMethod getPatientID(EpisodeID)
{
	s PatientId=$P($G(^PAADM(EpisodeID)),"^",1)
	q PatientId
}

ClassMethod ifCanCreateConsult(adm)
{
	s PatVisit=$p($g(^PAADM(adm)),"^",20) //病人就诊状态 
 	s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
	q:(PatVisit="D")&(currentStatus'="B") "病人已出院" 
	q 0
}

ClassMethod getRequestDocId(consultId)
{
	q:consultId="" ""
	s consult=##class(User.DHCConsultation).%OpenId(consultId)
	q:'$ISOBJECT(consult) ""
	s requestDocCtId=consult.RequestConDoc
	q:requestDocCtId="" ""
	s requestDocUserId=$o(^SSU("SSUSR",0,"CTPCP",requestDocCtId,""))
	q requestDocUserId
}

Storage Default
{
<Data name="DHCConsultationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Adm</Value>
</Value>
<Value name="3">
<Value>AppDate</Value>
</Value>
<Value name="4">
<Value>AppDep</Value>
</Value>
<Value name="5">
<Value>AppDoc</Value>
</Value>
<Value name="6">
<Value>AppTime</Value>
</Value>
<Value name="7">
<Value>Attitude</Value>
</Value>
<Value name="8">
<Value>ConDestination</Value>
</Value>
<Value name="9">
<Value>ConType</Value>
</Value>
<Value name="10">
<Value>ConsultDate</Value>
</Value>
<Value name="11">
<Value>ConsultDep</Value>
</Value>
<Value name="12">
<Value>ConsultDoc</Value>
</Value>
<Value name="13">
<Value>ConsultTime</Value>
</Value>
<Value name="14">
<Value>InOut</Value>
</Value>
<Value name="15">
<Value>RelOrder</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>RecDate</Value>
</Value>
<Value name="18">
<Value>RecTime</Value>
</Value>
<Value name="19">
<Value>RecUser</Value>
</Value>
<Value name="20">
<Value>RequestConDoc</Value>
</Value>
<Value name="21">
<Value>DocGrade</Value>
</Value>
<Value name="22">
<Value>SpeciaMedrowid</Value>
</Value>
<Value name="23">
<Value>Specialordid</Value>
</Value>
<Value name="24">
<Value>Specordid</Value>
</Value>
<Value name="25">
<Value>attitudetsy</Value>
</Value>
<Value name="26">
<Value>MoreLoc</Value>
</Value>
<Value name="27">
<Value>ConsultGroupId</Value>
</Value>
<Value name="28">
<Value>ExcuteOrder</Value>
</Value>
<Value name="29">
<Value>Diag</Value>
</Value>
<Value name="30">
<Value>ExecuteConDep</Value>
</Value>
<Value name="31">
<Value>MoreConPlace</Value>
</Value>
<Value name="32">
<Value>MoreConTime</Value>
</Value>
<Value name="33">
<Value>ConSultPontDr</Value>
</Value>
<Value name="34">
<Value>ConSultApplyOrder</Value>
</Value>
<Value name="35">
<Value>ItmConDep</Value>
</Value>
<Value name="36">
<Value>ConDestinationtwo</Value>
</Value>
</Data>
<DataLocation>^User.DHCConsultationD</DataLocation>
<DefaultData>DHCConsultationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCConsultationD</IdLocation>
<IndexLocation>^User.DHCConsultationI</IndexLocation>
<StreamLocation>^User.DHCConsultationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
