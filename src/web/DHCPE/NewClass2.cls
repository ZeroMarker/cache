Class web.DHCPE.NewClass2 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right ]
{

Parameter BUILD = 339;

/// d ##Class(web.DHCPE.ReportGetInfor).GetReportInfo()
ClassMethod GetReportInfo()
{
	
	Q ""
}

/// 取得患者信息GetPatientInfo()
/// 使用：
/// 	dhcpesendsms.csp	短信发送
/// 	
/// 	
/// d ##Class(web.DHCPE.ReportGetInfor).GetPatient()
ClassMethod GetPatient(PAAdmRowid As %String)
{
	Q:(""=PAAdmRowid) "0"
	k ^TMPReport("PatInfo")
	
	// DHC_PE_IADM.{ IADM_RowId }
	s IADMDR=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,0))
	Q:(""=IADMDR) "0"
	
	s CurData=$G(^DHCPEIADM(IADMDR))
	// DHC_PE_IADM.{ IADM_AdmDate } 体检日期
	s AdmDate=$P(CurData,"^",5)
	s ArrDate=+AdmDate
	s:(""'=AdmDate) AdmDate=$ZD(AdmDate,3)
	s ^TMPReport("PatInfo","AdmDate")=""
	s:(""'=AdmDate) ^TMPReport("PatInfo","AdmDate")=AdmDate
	
	// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
	s PIADMDR=$P(CurData,"^",4)
	Q:(""=PIADMDR) "0"
	
	
	s CurData=$G(^DHCPEPreIADM(PIADMDR))
	// DHC_PE_PreIADM.{ PIADM_PIBI_DR } = DHC_PE_PreIBaseInfo.{  }
	s PIBIDR=$P(CurData,"^",1)
	Q:(""=PIBIDR) "0"
	s OrderSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PIADMDR)
	s ^TMPReport("PatInfo","OrderSetsDesc")=OrderSetsDesc
	s GADM=$P(CurData,"^",2)
	s TeamID=$P(CurData,"^",3)
	i TeamID'="" d
	.s Char=##class(web.DHCPE.PreIADM).NumToChar($p(TeamID,"||",2))
	.s SortNo=Char_$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PIADMDR))
	e  d
	.s SortNo=""
	s CurData=$G(^DHCPEPreIBI(PIBIDR))
	// PIBI_PAPMINo		登记号
	s PAPMINo=$p(CurData,"^",1)
	s ^TMPReport("PatInfo","PatRegNo")=PAPMINo	
	
	// PIBI_Name	姓名
	s Name=$p(CurData,"^",2)
	s ^TMPReport("PatInfo","PatName")=Name
	
	// PIBI_Sex_DR = CT_Sex.{}	性别
	s SexDR=$p(CurData,"^",3)
	s:(""'=SexDR) ^TMPReport("PatInfo","PatSexDR")=$p(^CT("SEX",SexDR),"^",1)
	s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
	s ^TMPReport("PatInfo","PatSex")=SexDRName


	// PIBI_DOB		出生日期
	s Dob=$p(CurData,"^",4)
 	i Dob'="" s PAPERDob=$ZD(Dob,3)
 	s ^TMPReport("PatInfo","PatBirthday")=Dob
 	i ArrDate=0 s ArrDate=+$h
 	// 年龄 
 	s Age=""
 	s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,ArrDate)
 	s Age=$P(Age,"Y")
 	
	s ^TMPReport("PatInfo","PatAge")=Age_" 岁"
	
	// PIBI_PatType_DR 客户类型
	s PatTypeDR=$p(CurData,"^",5)
 	s ^TMPReport("PatInfo","PatType")=PatTypeDR
	
	// PIBI_Tel1 电话1 
	s Tel1=$p(CurData,"^",6)
 	s ^TMPReport("PatInfo","PatTel1")=Tel1
	
	// PIBI_Tel2 电话1
	s Tel2=$p(CurData,"^",7)
 	s ^TMPReport("PatInfo","PatTel2")=Tel2
	
	// PIBI_MobilePhone 手机
	s MobilePhone=$p(CurData,"^",8)
 	s ^TMPReport("PatInfo","MobilePhone")=MobilePhone
	
	s:(""'=Tel1) ^TMPReport("PatInfo","PatTel")=Tel1
	s:(""'=MobilePhone) ^TMPReport("PatInfo","PatTel")=MobilePhone
	
	
	// PIBI_IDCard 身份证号
	s IDCard=$p(CurData,"^",9)
 	s ^TMPReport("PatInfo","PatID")=IDCard
	
	// PIBI_Vocation 职业
	s Vocation=$p(CurData,"^",10)
 	s ^TMPReport("PatInfo","Vocation")=Vocation

	// PIBI_Position 职位
	s Position=$p(CurData,"^",11)
 	s ^TMPReport("PatInfo","Position")=Position
 	i Position'="" s Position="("_Position_")"
 	
 	// PIBI_Company	工作单位
 	i GADM="" d
 	.s Company=$p(CurData,"^",12)
 	.i (Company="")&&($G(^DHCPESetting("DHCPE","HospitalCode"))="SYYD") s Company="个人"
 	e  d
 	.s PreGBaseInfo=$p(^DHCPEPreGADM(GADM),"^",1)
 	.s Company=$p(^DHCPEPreGBI(PreGBaseInfo),"^",2)
 	.
 	s ^TMPReport("PatInfo","PatCompany")=Company_Position

 	// PIBI_Postalcode	邮编
 	s Postalcode=$p(CurData,"^",13)
 	s ^TMPReport("PatInfo","Postalcode")=Postalcode
 	
 	// PIBI_Address	地址
 	s Address=$p(CurData,"^",14)
 	s ^TMPReport("PatInfo","PatAddress")=Address
 	
 	
	// PIBI_Nation 民族
	s Nation=$p(CurData,"^",15)
 	s ^TMPReport("PatInfo","Nation")=Nation
 	
	// PIBI_Email 电子邮件
	s Email=$p(CurData,"^",16)
 	s ^TMPReport("PatInfo","Email")=Email
 	
	// PIBI_Married_DR 婚姻状况
	s MarriedDR=$p(CurData,"^",17)
 	s ^TMPReport("PatInfo","Married")=MarriedDR
  	
	// PIBI_Blood_DR	血型
	s BloodDR=$p(CurData,"^",18)
 	s ^TMPReport("PatInfo","Blood")=BloodDR	
 	 	
 	Q 1
}

/*

/// 获取参考范围 DHC_PE_ODStandard
/// d ##Class(web.DHCPE.ReportGetInfor).GetStandard()
ClassMethod GetStandard(STRowId As %String, ODChildSub As %String)
{
	s RowId=""	
	s Rangs=""
	f  s RowId=$o(^DHCPEST(STRowId,"OD",ODChildSub,"ODS",RowId)) q:RowId=""  d
	.s CurData=$g(^DHCPEST(STRowId,"OD",ODChildSub,"ODS",RowId))
	.s ODSNatureValue=$P(CurData,"^",6)
	.q:("Y"'=ODSNatureValue)
	.//ODS_Min,ODS_Max
	.s Rangs=$P(CurData,"^",4)_"-"_$P(CurData,"^",5)
	if ("-"=Rangs)  s Rangs=""
	q Rangs
}
*/
/// 获得体检结果表	DHC_PE_Result
/// d ##Class(web.DHCPE.ReportGetInfor).GetReportResult(5748147)
ClassMethod GetReportResult(PAAdmRowid As %String)
{
	k ^TMPReport("Result")
	
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	
	s PAPMIdr=$p(^PAADM(PAAdmRowid),"^",1)
	Q:(""=PAPMIdr) "0"
	
	// PAPER_Sex_DR	性别
	//s PAPERSexDR=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	s ^TMPReport("Result","Sex")=$G(^TMPReport("PatInfo","PatSexDR"))
	
	// PAPER_Dob		出生日期
	//s PAPERDob=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
 	//i PAPERDob'="" s PAPERDob=$ZD(PAPERDob,3)
 	//s Age=""
 	//s:(""'=PAPERDob) Age=##class(web.DHCLCNUREXCUTE).CalAge(PAPERDob,+$h)
 	//s Age=+$P(Age,"Y")
    s ^TMPReport("Result","Age")=$G(^TMPReport("PatInfo","PatAge"))

	///得到既往病史等内容
	s ODStr=$G(^DHCPESetting("DHCPE","ODStr"))
	s i=$L(ODStr,"^")
	f j=1:1:i
	{
		
		s ODDR=$p(ODStr,"^",j)
		Continue:ODDR=""
		s RLID=0
		s ResultStr=""
		f  s RLID=$o(^DHCPERLT(0,"PAADM_OD",PAAdmRowid,ODDR,RLID)) q:RLID=""  d
		.s Result=$p(^DHCPERLT(RLID),"^",4)
		.i Result'="" s ResultStr=ResultStr_Result_" "
		s Split="JZS"
		i j=1 s Split="YWGMS"
		i j=2 s Split="JWS"
		i j=3 s Split="JZS"
		
		s ^TMPReport("PatInfo",Split)=ResultStr
	}

	s TestId="" 
	f  s TestId=$o(^DHCPERLT(0,"ADMOD", PAAdmRowid, TestId)) q:(""=TestId)  d
	.s CRMID=$O(^DHCPECRMO(0,"OEORI",TestId,0))
	.q:CRMID=""
	.s ItemID=$p(^DHCPECRMO(CRMID),"^",2)
	.q:ItemID=""
	.s ItemStat=$p(^DHCPEPreIADM(+ItemID,"ORDITEM",$P(ItemID,"||",2)),"^",16)
	.q:ItemStat'="1"
	
	.s OEORDRowId=$P(TestId,"||",1) // OE_Order.OEORD_RowId
	.s OEORIChildsub=$P(TestId,"||",2) // OE_Order.OEORI_Childsub
	.
	.//在报告上不打印某些医嘱
	.s NoPrintFlag=""
	.s NoPrintFlag=$g(^DHCPEDataEx("DHCPEOrdItem","NotPrint",TestId))
	.q:NoPrintFlag="Y"
	.s ARCIMDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.Q:(""=ARCIMDR)
	.//RLT_ARCIM_DR 医嘱项目
	.s ARCIMSubScript=$p(ARCIMDR,"||",1)	//ARCIM_Desc 医嘱名称 Arc_ItmMast
	.s ARCIMVersion=$p(ARCIMDR,"||",2)
	.s ARCIMCode=$p($g(^ARCIM(ARCIMSubScript,ARCIMVersion,1)),"^",1)
	.s ARCIMDesc=$p($g(^ARCIM(ARCIMSubScript,ARCIMVersion,1)),"^",2)
	.s RFlag=..GetRisARCDesc(TestId)
	.q:RFlag="1"
	.// 获取打印格式
	.s STRowId=0
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId))
	.Q:(""=STRowId)
	.//站点顺序
	.s STSequence=$p(^DHCPEST(STRowId),"^",4)
	.q:STSequence=""
	.//项目顺序
	.s ARCSequence=$G(^DHCPEDataEx("DHCPEStationOrder","Sequence",ARCIMDR))
	.i ARCSequence="" s ARCSequence="999999999"
	.s STORDChildSub=0
	.s STORDChildSub=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR, STRowId, STORDChildSub))
	.Q:(""=STORDChildSub)
	.
	.s ReportFormat=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",4)
	.s:(""=ReportFormat) ReportFormat="RF_NOR"
	.
	.// 报告单属性 检验人/检查人 体检日期
	.s RLTRowid=0
	.s RLTRowid=$o(^DHCPERLT(0,"OEORI",TestId,RLTRowid))
	.//RLT_User_DR	检查医师
	.s RLTUser=$p(^DHCPERLT(RLTRowid),"^",5)
  	.i (""'=RLTUser) d
  	..i STRowId'=LabStation d
  	...s RLTUser=$p($g(^SSU("SSUSR",RLTUser)),"^",2)	//检查医师名称	SS_User
  	..e  d
  	...s RLTUser=$p($g(^[namespaceLab]SSU("SSUSR",1,RLTUser)),"^",2)
  	...//检验审核人 2008-06-04
  	...s AuditUser=$G(^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",TestId))
  	...i AuditUser'="" s AuditUser=$p($g(^[namespaceLab]SSU("SSUSR",1,AuditUser)),"^",2)
  	.
  	.//检验日期
	.s RLTUpdateDate=$p(^DHCPERLT(RLTRowid),"^",6)
    .i (""'=RLTUpdateDate) d
    ..s RLTUpdateDate=$ZD(RLTUpdateDate,3)
	.d:(ReportFormat["LIS") ..GetLISResult(PAAdmRowid,TestId, ARCIMDR)
	.d:(ReportFormat["NOR") ..GetRISResult(PAAdmRowid,TestId, ARCIMDR)
	.d:(ReportFormat["RIS") ..GetRISResult(PAAdmRowid,TestId, ARCIMDR)
	.d:(ReportFormat["CAT") ..GetLISResult(PAAdmRowid,TestId, ARCIMDR)
	.d:(ReportFormat["EKG") ..GetRISResult(PAAdmRowid,TestId, ARCIMDR)
	.
	.// 按打印格式索引
	.s ^TMPReport("Result","ReportFormat",ReportFormat,TestId)=ARCIMDesc

	.// 按站点索引 
	.s ^TMPReport("Result","Station",STSequence,STRowId,ARCSequence)=+$G(^TMPReport("Result","Station",STSequence,STRowId,ARCSequence))+1
	.s ^TMPReport("Result","Station",STSequence,STRowId,ARCSequence,^TMPReport("Result","Station",STSequence,STRowId,ARCSequence))=TestId
	.
	.// 按项目索引  增加AuditUser 2008-06-04
	.s ^TMPReport("Result","ARCIM",TestId)=ARCIMDesc_"^"_RLTUser_"^"_RLTUpdateDate_"^"_ReportFormat_"^"_$G(AuditUser)


	Q ""
}

/// 获取LIS格式数据
/// d ##Class(web.DHCPE.ReportGetInfor).GetLISResult(5748147,"5152911||14","3870||1")
ClassMethod GetLISResult(PAAdmRowid As %String, arcimRowID As %String, ARCIMDR As %String)
{
	//w PAAdmRowid_","_arcimRowID_","_ARCIMDR_":"
	s iLLoop=1
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	Set CurNS=$ZNSPACE
	
	s Sequence=""
	f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIMDR,Sequence)) q:Sequence=""  d
	.s RowId=""
	.f  s RowId=$O(^DHCPEODR(0,"Sequence",ARCIMDR,Sequence,RowId)) q:RowId=""  d
	..Set RLTODDR=$P($g(^DHCPEODR(RowId)),"^",2)
	..s RLTRowid=0
	..s RLTResult=""
	..s RLTTemplateDesc=""
	..s RLTRowid=$o(^DHCPERLT(0,"ADMOD", PAAdmRowid, arcimRowID,RLTODDR, RLTRowid))
	..q:RLTRowid=""
	..
	..s Flag=1
	..//RLT_OD_DR	细项
	..s ODRowId=$p(^DHCPERLT(RLTRowid),"^",3)
	..q:$G(^DHCPEDataEx("DHCPEOrderDetail","NoPrint",ODRowId))="1"    
	..s STRowId=$p(ODRowId,"||",1)			//站点编码
	..
	..s ODChildSub=$p(ODRowId,"||",2)		//项目编码
	..
	..//OD_Desc
	..s ODDesc=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)	//细项名称	DHC_PE_OrderDetail
	..s ODLabCode=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",10)	//检验细项代码	DHC_PE_OrderDetail
	..Q:(""=ODDesc)
	..//s Standard=..GetStandard(STRowId,ODChildSub)
	..s Standard=..GetStandard(STRowId_"||"_ODChildSub,^TMPReport("Result","Sex"),^TMPReport("Result","Age"))
	..
	..//OD_Unit
	..s ODUnit=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",4)
	..//s:(""'=ODUnit) ODUnit=$p($g(^CT(ODUnit)),"^",2)	//CT_UOM
	..
	..//检验结果
	..s RLTResult=$p(^DHCPERLT(RLTRowid),"^",4)
	..
	..q:RLTResult=""
	..s IsNormal=$p(^DHCPERLT(RLTRowid),"^",7)
	..s Arrow="1"
	..i LabStation=STRowId d
	...s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(Standard,RLTResult)
	...i (Standard="")&&(IsNormal=0) s Arrow=3
	...Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	...Set CTTCCode=$p(^DHCPEST(STRowId,"OD",ODChildSub),"^",10)
	...Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	...If ($e(ResultFormat,1)'="N"&&(Arrow'="3")) s Arrow=1
	...Set CTTCSynonym=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",12)
	...zn CurNS
    ..//是否正常
	..s RLTNormal=$p(^DHCPERLT(RLTRowid),"^",7)
	..// RLT_TemplateDesc 模板描述
	..s RLTTemplateDesc=$p(^DHCPERLT(RLTRowid),"^",10)
	..//s ^TMPReport("Result", "Station", STRowId)=ARCIMDR
	..s ^TMPReport("Result", "Content", arcimRowID,iLLoop)=ODDesc_"^"_RLTResult_"^"_RLTNormal_"^"_ODUnit_"^"_Standard_"^"_Arrow_"^"_RLTTemplateDesc_"^"_$G(CTTCSynonym)
	..
	..s iLLoop=1+iLLoop
	/*
	// RLT_OD_DR
	s RLTODDR=0
	f  s RLTODDR=$o(^DHCPERLT(0,"ADMOD", PAAdmRowid, arcimRowID, RLTODDR)) q:RLTODDR=""  d
	.s RLTRowid=0
	.s RLTRowid=$o(^DHCPERLT(0,"ADMOD", PAAdmRowid, arcimRowID, RLTODDR, RLTRowid))
	.Q:(""=RLTRowid)
	.
	.//RLT_OD_DR	细项
	.s ODRowId=$p(^DHCPERLT(RLTRowid),"^",3)     
	.s STRowId=$p(ODRowId,"||",1)			//站点编码
	.
	.s ODChildSub=$p(ODRowId,"||",2)		//项目编码
	.
	.//OD_Desc
	.s ODDesc=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)	//细项名称	DHC_PE_OrderDetail
	.s ODLabCode=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",10)	//检验细项代码	DHC_PE_OrderDetail
	.Q:(""=ODDesc)
	.//s Standard=..GetStandard(STRowId,ODChildSub)
	.s Standard=..GetStandard(STRowId_"||"_ODChildSub,^TMPReport("Result","Sex"),^TMPReport("Result","Age"))
	.
	.//OD_Unit
	.s ODUnit=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",4)
	.//s:(""'=ODUnit) ODUnit=$p($g(^CT(ODUnit)),"^",2)	//CT_UOM
	.
	.//检验结果
	.s RLTResult=$p(^DHCPERLT(RLTRowid),"^",4)
	.s Arrow="1"
	.i LabStation=STRowId d
	..s Arrow=##class(web.DHCPE.TransResult).GetLabResultArrow(Standard,RLTResult)
	..Set namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	..Set CTTCCode=$p(^DHCPEST(STRowId,"OD",ODChildSub),"^",10)
	..Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	..If $e(ResultFormat,1)'="N" s Arrow=1
	..zn "websource"
	..//s RLTResult=##class(web.DHCPE.TransResult).trans(ODLabCode,RLTResult) //$p(..,$C(1),2)
	..//i $l(RLTResult,$C(1))>1 d
	..//.s RLTResult=$p(RLTResult,$C(1),2)
    .//s RLTResult=RLTResult
    .//是否正常
	.s RLTNormal=$p(^DHCPERLT(RLTRowid),"^",7)
	.// RLT_TemplateDesc 模板描述
	.s RLTTemplateDesc=$p(^DHCPERLT(RLTRowid),"^",10)
	.//s ^TMPReport("Result", "Station", STRowId)=ARCIMDR
	.s ^TMPReport("Result", "Content", ARCIMDR,iLLoop)=ODDesc_"^"_RLTResult_"^"_RLTNormal_"^"_ODUnit_"^"_Standard_"^"_Arrow_"^"_RLTTemplateDesc
	.
	.s iLLoop=1+iLLoop*/
}

/// 获取参考范围 DHC_PE_ODStandard
/// w ##Class(web.DHCPE.ReportGetInfor).GetStandard("10||1",F,17)
/// w ##Class(web.DHCPE.ReportGetInfor).GetStandard("1||2",F,17)
ClassMethod GetStandard(ItemID As %String, sex As %String, age As %String)
{
	
	q ##class(web.DHCPE.ResultEdit).GetNormal(ItemID,sex,age)
}

/// test: w ##Class(web.DHCPE.ReportGetInfor).GetResultStatus("10||1","F",17)
ClassMethod GetResultStatus(ItemID, sex, age) As %String
{
	Quit:(($g(ItemID)="")||($g(sex)="")||(age="")) ""
	
	Set NormalStr=""
	Set age=+age
	Set ItemType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)
	Set ItemUOMDr=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",4)
	Set ItemUOM=""
	If ItemUOMDr'="" Set ItemUOM=$P($G(^CT("UOM",ItemUOMDr)),"^",2)
	Set Chl=0
	Set Normal="N"
	For  Set Chl=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)) Quit:(Chl="")!(Normal="Y")  Do
	.set myData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl)
	.Set tempNormal=$P(myData,"^",6)
	.
	.set tempSex=$P(myData,"^",1)
	.set tempAgeMin=+$P(myData,"^",7)
	.set tempAgeMax=+$P(myData,"^",8)
	.
	.i ("N"=ItemType)||("C"=ItemType) d
	..// 有年龄性别的限制
	..i (""'=tempSex)&&((""'=tempAgeMin)||(""'=tempAgeMax)) d
	...
	...i (sex=tempSex)&&(+age>=+tempAgeMin)&&(+age<=+tempAgeMax) d
	....s ^TMPResultStatus("Range",1)=tempAgeMin_"-"_tempAgeMax
	...
	..
	..
	..// 有性别，无年龄限制
	..i (""'=tempSex)&&(""=tempAgeMin)&&(""'=tempAgeMax) d
	...
	...i (sex=tempSex) d
	....s ^TMPResultStatus("Range",2)=tempAgeMin_"-"_tempAgeMax
	...
	...
	..
	..
	..// 无性别，有年龄限制
	..i (""=tempSex)&&((""'=tempAgeMin)||(""'=tempAgeMax)) d
	...Q:(""'=tempAgeMin)&&(age>=+tempAgeMin)
	...Q:(""'=tempAgeMax)&&(age<=+tempAgeMax)
	...s ^TMPResultStatus("Range",3)=tempAgeMin_"-"_tempAgeMax
	..
	..
	..// 无年龄性别的限制 通用
	..i (""'=tempSex)&&(""'=tempAgeMin)&&(""'=tempAgeMax) d
	...
	...s ^TMPResultStatus("Range",4)=tempAgeMin_"-"_tempAgeMax
	...
	..
	..
	.
	.Quit:tempNormal'="Y"
	.Quit:(((tempAgeMin>age)||(tempAgeMax<age))&&((tempAgeMin'=0)&&(tempAgeMax'=0)))
	.Quit:(tempSex'="N")&&(tempSex'=sex)
	.set Normal="Y"
	.If ItemType="N" Do
	..Set Min=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",4)
	..Set Max=+$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",5)
	..Set NormalStr=Min_ItemUOM_" - "_Max_ItemUOM
	.Else  Do
	..Set NormalStr=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)

	Quit NormalStr
}

ClassMethod GetResultNormal(ItemID, sex, age) As %String
{
	q:(($g(ItemID)="")||($g(sex)="")||(age="")) ""
	
	Set NormalStr=""
	
	s age=+age
	
	// DHC_PE_OrderDetail.{ OD_Type }
	s ODType=$P($g(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2))),"^",2)

	s ind=0
	f  s ind=$O(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ind)) q:(ind="")  d
	.s CurData=^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",ind)
	.// ODS_NatureValue_
	.s ODSNatureValue=$P(CurData,"^",6)
	.
	.s ODSSex=$P(CurData,"^",1)
	.s ODSAgeMin=+$P(CurData,"^",7)
	.s ODSAgeMax=+$P(CurData,"^",8)
	.s ODSMin=+$P(CurData,"^",4)
	.s ODSMax=+$P(CurData,"^",5)
	.
	.// 有年龄性别的限制
	.i (""'=ODSSex)&&((""'=ODSAgeMin)||(""'=ODSAgeMax)) d
	..
	..i (sex=ODSSex)&&(+age>=+ODSAgeMin)&&(+age<=+ODSAgeMax) d
	...s:("N"=ODType)||("C"=ODType) ^TMPResultStatus("Range",1)=ODSMin_"-"_ODSMax
	..
	.
	.
	.// 有性别，无年龄限制
	.i (""'=ODSSex)&&(""=ODSAgeMin)&&(""'=ODSAgeMax) d
	..
	..i (sex=ODSSex) d
	...s:("N"=ODType)||("C"=ODType) ^TMPResultStatus("Range",2)=ODSMin_"-"_ODSMax
	..
	..
	.
	.
	.// 无性别，有年龄限制
	.i (""=ODSSex)&&((""'=ODSAgeMin)||(""'=ODSAgeMax)) d
	..Q:(""'=ODSAgeMin)&&(age>=+ODSAgeMin)
	..Q:(""'=ODSAgeMax)&&(age<=+ODSAgeMax)
	..s:("N"=ODType)||("C"=ODType) ^TMPResultStatus("Range",3)=ODSMin_"-"_ODSMax
	.
	.
	.// 无年龄性别的限制 通用
	.i (""'=ODSSex)&&(""'=ODSAgeMin)&&(""'=ODSAgeMax) d
	..
	..s:("N"=ODType)||("C"=ODType) ^TMPResultStatus("Range",4)=ODSMin_"-"_ODSMax
	..
	.
	.
	.
	.Quit:tempNormal'="Y"
	.Quit:(((tempAgeMin>age)||(tempAgeMax<age))&&((tempAgeMin'=0)&&(tempAgeMax'=0)))
	.Quit:(tempSex'="N")&&(tempSex'=sex)
	.set Normal="Y"
	.If ItemType="N" Do
	..
	..
	..Set NormalStr=Min_ItemUOM_" - "_Max_ItemUOM
	.Else  Do
	..Set NormalStr=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2),"ODS",Chl),"^",2)
	//
	Quit NormalStr
}

/// 获取LIS格式数据
ClassMethod GetRISResult(PAAdmRowid As %String, arcimRowID As %String, ARCIMDR As %String)
{
	s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	// RLT_OD_DR
	s ^sdwf("20110914",arcimRowID)=ARCIMDR
	s iLLoop=1
	s Sequence=""
	f  s Sequence=$O(^DHCPEODR(0,"Sequence",ARCIMDR,Sequence)) q:Sequence=""  d
	.s ^sdwf("20110914",arcimRowID,1)=ARCIMDR
	.s RowId=""
	.f  s RowId=$O(^DHCPEODR(0,"Sequence",ARCIMDR,Sequence,RowId)) q:RowId=""  d
	..Set RLTODDR=$P($g(^DHCPEODR(RowId)),"^",2)
	..s ^sdwf("20110914",arcimRowID,2)=ARCIMDR
	..i arcimRowID="258473||10" w arcimRowID_"RLTODDR:"_RLTODDR,!
	..s RLTRowid=0
	..s RLTResult=""
	..s RLTTemplateDesc=""
	..s ODUnit=""
	..s RLTNormal=""
	..s Flag=0
	..f  s RLTRowid=$o(^DHCPERLT(0,"ADMOD", PAAdmRowid, arcimRowID,RLTODDR, RLTRowid)) Q:(""=RLTRowid)||(Flag=2)  d 
	...//RLT_OD_DR	细项
	...s ODRowId=$p(^DHCPERLT(RLTRowid),"^",3)
	...s ^sdwf("20110914",arcimRowID,3)=$G(^DHCPEDataEx("DHCPEOrderDetail","NoPrint",ODRowId))
	...s:$G(^DHCPEDataEx("DHCPEOrderDetail","NoPrint",ODRowId))="1" Flag=2
	...q:Flag=2     
	...s STRowId=$p(ODRowId,"||",1)			//站点编码
	...s Station="^"_STRowId_"^"
	...s ODChildSub=$p(ODRowId,"||",2)		//项目编码
	...//OD_Desc
	...s ODDesc=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)	//细项名称	DHC_PE_OrderDetail
	...Q:(""=ODDesc)
	...s ODType=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",2)
	...s Standard=..GetStandard(STRowId_"||"_ODChildSub,$G(^TMPReport("Result","Sex")),$G(^TMPReport("Result","Age")))
	...//OD_Unit
	...s ODUnit=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",4)
	...
	...//if (""'=ODUnit) s ODUnit=$p($g(^CT(ODUnit)),"^",2)	//CT_UOM
	...s:'(("N"=ODType)||("Number"=ODType)||("C"=ODType)||("Calcul"=ODType)) ODUnit=""
	...//检验结果
	...s Result=$p($G(^DHCPERLT(RLTRowid)),"^",4)
	...i Result="" d
	....s Result=$g(^DHCPETempResult(arcimRowID))
	...q:Result=""
	...s ^sdwf("20110914",arcimRowID,4)=Result
	...s RLTResult=$G(RLTResult)_Result_$C(13)_$C(10)
	...//如果是检查结果、转换结果
    ...//i RisStation[Station d
    ...//.s RLTResult=##class(web.DHCPE.ResultDiagnosis).GetRisResult(RLTResult)
    ...s RLTTemplateDesc=RLTTemplateDesc_$p($G(^DHCPERLT(RLTRowid)),"^",10)_$C(13)_$C(10)
    ...//是否正常
	...s RLTNormal=$p(^DHCPERLT(RLTRowid),"^",7)
	...i (+RLTNormal=1)  d
	....s RLTNormal="正常"
	...e  d
	....s RLTNormal="异常"
	...s Flag=1
	
	..q:Flag'=1
	..s RLTTemplateDesc=$P(RLTTemplateDesc,$C(13)_$c(10),1,$L(RLTTemplateDesc,$C(13)_$C(10))-1)
	..s RLTResult=$P(RLTResult,$C(13)_$c(10),1,$L(RLTResult,$C(13)_$C(10))-1)
	..//s ^TMPReport("Result", "Station", STRowId)=ARCIMDR
	..s ^TMPReport("Result", "Content", arcimRowID,iLLoop)=ODDesc_"^"_RLTResult_"^"_RLTNormal_"^"_ODUnit_"^"_RLTTemplateDesc
	..s iLLoop=1+iLLoop
}

/// /0 继续向下执行
/// /1 返回
ClassMethod GetRisARCDesc(OEOrdItemID)
{
	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEOrdItemID,0))
	q:RARRowId="" 0
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	i $D(^TMPReport("Result","RisStudyNo",RisStudyNo))
	{
		s OEIID=$G(^TMPReport("Result","RisStudyNo",RisStudyNo))
		s OldDesc=$p(^TMPReport("Result","ARCIM",OEIID),"^",1)
		s $p(^TMPReport("Result","ARCIM",OEIID),"^",1)=OldDesc_"<br>"_ARCIMDesc
		q "1"
	}
	s ^TMPReport("Result","RisStudyNo",RisStudyNo)=OEOrdItemID
	q 0
}

/// 科室小结
/// d ##Class(web.DHCPE.ReportGetInfor).GetSummarize(5747947)
ClassMethod GetSummarize(PAAdmRowid As %String)
{
	
	//站点（科室）小结 DHC_PE_StationSummarize （所有阳性体症）
	k ^TMPReport("Summarize")

	s Delimit="^"
	s IADMRowId=""
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,IADMRowId))
	q:(""=IADMRowId) 0
	
	s STRowId=""	//科室编码
	s RowId=""	//小结编码	
	f  s STRowId=$o(^DHCPESS(0,"IADM",IADMRowId,STRowId)) q:STRowId=""  d
	.s SDesc=$p($G(^DHCPEST(STRowId)),"^",2)	//站点名称
	.Q:(""=SDesc)
	.f  s RowId=$o(^DHCPESS(0,"IADM",IADMRowId,STRowId,RowId)) q:RowId=""  d
	..//GA_AduitUser_DR
	..s AduitUser=$p(^DHCPESS(RowId,1),"^",4)	//审核人
  	..i (""'=AduitUser) s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)	//检查医师名称	SS_User
  	..
  	..//GA_AduitDate
  	..s AduitDate=$p(^DHCPESS(RowId,1),"^",3)	//审核日期
    ..i (""'=AduitDate) s AduitDate=$ZD(AduitDate,3)
	..
	..s ^TMPReport("Summarize", "Station", STRowId)=SDesc
	..
	..// 科室小结   原来调用阳性体征现改为建议
	..s ^TMPReport("Summarize", "Content", SDesc)=..GetStationAdvice(RowId)
	..//$p($G(^DHCPESS(RowId,"S")),"^",5)
	..// 科室检查人
	..s ^TMPReport("Summarize", "Content", SDesc, "AduitUser")=AduitUser
	..
	..// 科室检查日期
	..s ^TMPReport("Summarize", "Content", SDesc, "AduitDate")=AduitDate
	..
	s gSSID=$o(^DHCPEGS(0,"IADM",IADMRowId,0))
	s ^TMPReport("Summarize", "Contentgather")=..GetStationSummarizegather(gSSID)
	Q 1
}

/// 得到总检的阳性体征
ClassMethod GetStationSummarizegather(SSID)
{
	s Sub=0
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	
	s Result=""
	f  s Sub=$o(^DHCPEGS(SSID,"Result",Sub)) q:Sub=""  d
 	.s Report=$p(^DHCPEGS(SSID,"Result",Sub),"^",6)
 	.q:Report="N"
 	.s SSRId=SSID_"||"_Sub
 	.s SRID=$p(^DHCPEGS(SSID,"Result",Sub),"^",1)
 	.s RLID=$p($G(^DHCPESS($p(SRID,"||",1),"Result",$p(SRID,"||",2))),"^",1)
 	.q:RLID=""
 	.s RIDDesc=$p($g(^DHCPERLT(RLID)),"^",4)
 	.s TempDesc=$p($g(^DHCPERLT(RLID)),"^",10)
 	.i TempDesc'="" s TempDesc=" 模版:"_TempDesc
 	.s OrderDetailID=$p($g(^DHCPERLT(RLID)),"^",3)
 	.s ARCIM=$p($g(^DHCPERLT(RLID)),"^",3)
 	.i ARCIM'="" d
 	..s ItemDesc=$p($g(^DHCPEST(+ARCIM,"OD",$p(ARCIM,"||",2))),"^",1)
 	..s ItemUOMDr=$P($g(^DHCPEST(+ARCIM,"OD",$P(ARCIM,"||",2))),"^",4)
 	.e  d
 	..s ItemDesc=""
 	..s ItemUOMDr=""
 	.s Station="^"_+OrderDetailID_"^"
 	.
 	.//如果是检查结果、转换结果
    .i RisStation[Station d
    ..s RIDDesc=##class(web.DHCPE.ResultDiagnosis).GetRisResult(RIDDesc)
 	.
 	.
 	.s RIDDesc=RIDDesc_" "_ItemUOMDr
 	.s Remark=$p(^DHCPEGS(SSID,"Result",Sub),"^",2)
 	.i Remark'="" s Remark=" 备注:"_Remark
 	.i Result="" d
	..s Result=ItemDesc_": "_RIDDesc_" "_Remark
	.e  d
	..s Result=Result_$C(13,10)_ItemDesc_": "_RIDDesc_" "_TempDesc_" "_Remark
	/*s Remark=$p($g(^DHCPEGS(SSID,"S")),"^",1)
	i Result="" d
	.s Result=Remark
	e  d
	.s Result=Result_$C(13,10)_Remark*/
	q Result
}

/// 得到各个科室的建议
ClassMethod GetStationAdvice(SSID)
{
	s Advice=""
	s SSub=0
	f  s SSub=$o(^DHCPESS(SSID,"Diagnosis",SSub)) q:SSub=""  d
	.s EDID=$p($G(^DHCPESS(SSID,"Diagnosis",SSub)),"^",1)
	.s EDDesc=$p($g(^DHCPEED(EDID,"Detail")),"^",1)
	.s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
	.s EDDesc=DiagnoseConclusion
	.
	.// _": "_EDDesc
	.s Remark=$p($G(^DHCPESS(SSID,"Diagnosis",SSub)),"^",2)
	.i Remark'="" s Remark=" 备注:"_Remark
	.i Advice="" d
	..s Advice=EDDesc
	..//_" "_SRemark
	.e  d
	..s Advice=Advice_$C(13,10)_EDDesc
	..//_" "_SRemark
	q Advice
}

/// 得到各个科室的小结
ClassMethod GetStationSummarize(SSID)
{
	s SSub=0
	s Result=""
	s Station=$p(^DHCPESS(SSID,1),"^",2)
	s Station="^"_Station_"^"
	s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	q:RisStation[Station Result
	f  s SSub=$o(^DHCPESS(SSID,"Result",SSub))  q:SSub=""  d
	.s RLTDR=$p(^DHCPESS(SSID,"Result",SSub),"^",1)
	.s RLDesc=$p($g(^DHCPERLT(RLTDR)),"^",4)
	.s TempDesc=$p($g(^DHCPERLT(RLTDR)),"^",10)
	.i TempDesc'="" s TempDesc=" 模版:"_TempDesc
	.s SSRemark=$p(^DHCPESS(SSID,"Result",SSub),"^",2)
	.i SSRemark'="" s SSRemark=" 备注:"_SSRemark
	.s ARCIM=$p($g(^DHCPERLT(RLTDR)),"^",3)
 	.i ARCIM'="" d
 	..s ItemDesc=$p($g(^DHCPEST(+ARCIM,"OD",$p(ARCIM,"||",2))),"^",1)
 	..s ItemUOMDr=$P($g(^DHCPEST(+ARCIM,"OD",$P(ARCIM,"||",2))),"^",4)
 	.e  d
 	..s ItemDesc=""
 	..s ItemUOMDr=""
	.i Result="" d
	..s Result=ItemDesc_": "_RLDesc_" "_ItemUOMDr_" "_SSRemark
	.e  d
	..s Result=Result_$C(13,10)_ItemDesc_": "_RLDesc_" "_ItemUOMDr_" "_TempDesc_" "_SSRemark
	s Remark=$p($g(^DHCPESS(SSID,"S")),"^",1)
	i Result="" d
	.s Result=Remark
	e  d
	.s Result=Result_$C(13,10)_Remark
	q Result
}

/// 总检建议 DHC_PE_GeneralAdvice ^DHCPEGA
/// d ##Class(web.DHCPE.ReportGetInfor).GetGeneralAdvice(5747947)
ClassMethod GetGeneralAdvice(PAAdmRowid As %String)
{
	k ^TMPReport("GeneralAdvice") 
	s Advice=""
	s IADMRowId=""
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,IADMRowId))
	q:(""=IADMRowId) 0
	///Add
	s gSSID=$o(^DHCPEGS(0,"IADM",IADMRowId,0))
	s Sort=0
	f  s Sort=$o(^DHCPEGS(0,"GSDSort",gSSID,Sort)) q:Sort=""  d
 	.s gSub=0
 	.f  s gSub=$o(^DHCPEGS(0,"GSDSort",gSSID,Sort,gSub)) q:gSub=""  d
	..//f  s gSub
	..//=$o(^DHCPEGS(gSSID,"Diagnosis",gSub))  q:gSub=""  d
	..s EDID=$p(^DHCPEGS(gSSID,"Diagnosis",gSub),"^",1)
	..q:EDID=""
	..s EDCDR=$G(^DHCPEDataEx("DHCPEGSDiagnosis","EDCDR",gSSID_"||"_gSub))
	..i EDCDR="" s EDCDR="0"
	..s EDCode=$p($G(^DHCPEEDC(EDCDR)),"^",1)
	..i EDCode="" s EDCode="0"
	..s EDDesc=$p(^DHCPEGS(gSSID,"Diagnosis",gSub),"^",9)
	..//$p($g(^DHCPEED(EDID,"Detail")),"^",1)
	..s DiagnoseConclusion=$p($g(^DHCPEED(EDID,"1")),"^",1)
	..///去掉括号  080114
	..s j=$l(DiagnoseConclusion,"(")
	..//i j>1 d
	..//.s DiagnoseConclusion=$p(DiagnoseConclusion,"(",1,j-1)
	..//.///end
	.. s DiagnoseConclusion="<font size=4 ><b>"_DiagnoseConclusion_"</b></font>"
  	..i DiagnoseConclusion["未见异常"  d
  	...s EDDesc=DiagnoseConclusion_" "_EDDesc
  	..e  d
  	...s EDDesc=DiagnoseConclusion_": "_EDDesc
	..s SRemark=$p(^DHCPEGS(gSSID,"Diagnosis",gSub),"^",3)
	..i SRemark'="" s SRemark=" 备注:"_SRemark
	..s Sub=+$o(^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR,Sort,""),-1)+1
	..s ^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR,Sort,Sub)=EDDesc
	..//上海贵宾客户每个项目的建议
	..s OEItemID=$G(^DHCPEDataEx("GDiaginosis",gSSID_"||"_gSub))
	..i OEItemID'="" d
	...s OESub=+$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR,Sort,""),-1)+1
	...s ^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR,Sort,OESub)=EDDesc
	
	s i=0
	s EDCode=""
	f  s EDCode=$o(^TMPReport("GeneralAdvice","Temp",EDCode)) q:EDCode=""  d 
	.s EDCDR=""
	.f  s EDCDR=$o(^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR)) q:EDCDR=""  d
	..s EDCDesc=$p($G(^DHCPEEDC(EDCDR)),"^",2)
	..i EDCDesc'="" d
	...s EDCDesc="<b>"_EDCDesc_"</b>"
	...i Advice="" d
	....s Advice=EDCDesc
	...e  d
	....s Advice=Advice_$C(13,10)_EDCDesc
	..s Sort=""
	..f  s Sort=$o(^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR,Sort)) q:Sort=""  d
	...s Sub=""
	...f  s Sub=$o(^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR,Sort,Sub)) q:Sub=""  d
	....s EDDesc=$G(^TMPReport("GeneralAdvice","Temp",EDCode,EDCDR,Sort,Sub))
	....s i=i+1
	....i Advice="" d
	.....s Advice=i_"、"_EDDesc
	....e  d
	.....s Advice=Advice_$C(13,10)_i_"、"_EDDesc
	
	i i=1  s Advice=EDDesc      //by zhouli
	s Remark=$p($g(^DHCPEGS(gSSID,"S")),"^",1)
	i Advice="" d
	.s Advice=Remark
	e  d
	.s Advice=Advice_$C(13,10)_Remark
	s ^TMPReport("GeneralAdvice","Advice")=Advice
	
	////每个项目的建议  20090531 sh
	s OEItemID=""
	f  s OEItemID=$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID))  q:OEItemID=""  d //,EDCode,EDCDR,Sort,OESub)
	.s i=0
	.s Advice=""
	.s EDCode=""
	.f  s EDCode=$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode))  q:EDCode=""  d //,EDCode,EDCDR,Sort,OESub)
	..s EDCDR=""
	..f  s EDCDR=$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR)) q:EDCDR=""  d
	...s EDCDesc=$p($G(^DHCPEEDC(EDCDR)),"^",2)
	...i EDCDesc'="" d
	....s EDCDesc="<b>"_EDCDesc_"</b>"
	....i Advice="" d
	.....s Advice=EDCDesc
	....e  d
	.....s Advice=Advice_$C(13,10)_EDCDesc
	...s Sort=""
	...f  s Sort=$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR,Sort)) q:Sort=""  d
	....s Sub=""
	....f  s Sub=$o(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR,Sort,Sub)) q:Sub=""  d
	.....s EDDesc=$G(^TMPReport("GeneralAdvice","OEItemTemp",OEItemID,EDCode,EDCDR,Sort,Sub))
	.....s i=i+1
	.....i Advice="" d
	......s Advice=i_"、"_EDDesc
	.....e  d
	......s Advice=Advice_$C(13,10)_i_"、"_EDDesc
	.s ^TMPReport("GeneralAdvice","OEItemAdvice",OEItemID)=Advice
	////
	
	s RowId=$o(^DHCPEGS(0,"IADM",IADMRowId,0))
	s AduitUser=""
	i RowId'="" s AduitUser=$p(^DHCPEGS(RowId,1),"^",5)
	i AduitUser'="" s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)
	s ^TMPReport("GeneralAdvice","AduitUser")=AduitUser
	q 1
}

/// 根据医嘱得到对应Ris图片
/// w ##class(web.DHCPE.ReportGetInfor).GetPhotoPath("211340||12")
ClassMethod GetPhotoPath(OeordId)
{
	//##class(web.DHCRisStorage).GetLocInfo("1140")
	//##class(web.DHCRisclinicQueryOEItemDo).GetFTPByStudyNo(RisStudyNo)
	s RetStr=""
	Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OeordId,0))
	Quit:$g(RARRowId)="" RetStr
	Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	Quit:$g(RisStudyNo)="" RetStr
	s CurZN=$ZNSPACE
	s ReportId=##class(web.DHCPE.TransResult).GetMaxRisReportID(RisStudyNo)
	Quit:$g(ReportId)="" RetStr
	
	s ReportSub=0
	f  s ReportSub=$o(^DHCRBStudy(0,"ReportFiles",ReportId,ReportSub)) q:(ReportSub="")  d
	.s ImageId=$p($g(^DHCRBStudy(0,"ReportFiles",ReportId,ReportSub)),"^",4)
	.//i ImageId="" d
	.//.s GetMediumDR=$p($G(^DHCRBStudy(0,"ReportFiles",ReportId,ReportSub)),"^",3)
	.//.s GetDRMName=""
	.//.i GetMediumDR'="" s GetDRMName=$p(^DHCRBCServer("Medium",GetMediumDR),"^",2)
	.q:ImageId=""
	.s Width=$p(^DHCRBStudy(0,"StudyImages",ImageId),"^",4)
	.s GetMediumDR=$p(^DHCRBStudy(0,"StudyImages",ImageId),"^",6)
	.s GetDRMName=""
	.i GetMediumDR'="" s GetDRMName=$p(^DHCRBCServer("Medium",GetMediumDR),"^",2)
	.s Height=$p(^DHCRBStudy(0,"StudyImages",ImageId),"^",3)
	.s FileName=$p($g(^DHCRBStudy(0,"StudyImages",ImageId)),"^",1)
	.s FileName=##class(web.DHCPE.ReportGetInfor).Replace(FileName,"\","/")
	.s ImageDesc=$p($g(^DHCRBStudy(0,"StudyImages",ImageId)),"^",8)
	.zn "RIS"
	.s ServerInfo=##class(web.DHCRisStorage).GetServerInfo(GetMediumDR)
	.zn CurZN
	.s IP=$p(ServerInfo,"^",2)
	.s Port=$p(ServerInfo,"^",3)
	.s User=$p(ServerInfo,"^",5)
	.s PWD=$p(ServerInfo,"^",6)
	.q:IP=""
	.s ServerInfo="ftp://"_User_":"_PWD_"@"_IP_":"_Port_"/"
	.s ServerInfo=ServerInfo_GetDRMName_""
	.i FileName'="" d
	..s FileName=ServerInfo_FileName_"^"_Width_"^"_Height_"^"_ImageDesc
	..i RetStr="" d
	...s RetStr=FileName
	..e  d
	...s RetStr=RetStr_$C(1)_FileName
	
	Quit RetStr
}

ClassMethod GetReportStatusByPAADM(PAADM)
{
	if (""=PAADM) q "0"	//无效 Adm
	s IADMRowId=0
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,IADMRowId))
	q:(""=IADMRowId) "0"	//未找到体检人信息
	s RowId=0
	s RowId=$O(^DHCPERPT(0,"IADM",IADMRowId,RowId))
	q:(""=RowId) "0"		//未找到报告信息
	s CurData=$g(^DHCPERPT(RowId))	
	
	s Status=$p(CurData,"^",2)				//报告状态
	q:Status="NA" "0"
	q "1"
}

ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

}
