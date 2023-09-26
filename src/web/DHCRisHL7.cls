/// DHC RIS HL7 Class
/// 
Class web.DHCRisHL7 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(web.DHCRisHL7).SetHL7Server("155.1.1.137","8878")
ClassMethod SetHL7Server(Ip, Port)
{
	s ^DHCRisHL7ServerIP=Ip
	s ^DHCRisHL7ServerPort=Port
}

//d ##class(web.DHCRisHL7).ConnectHL7Server()

ClassMethod ConnectHL7Server()
{
	i $g(^DHCRisIo)'="" d
	.CLOSE ^DHCRisIo
	.k ^DHCRisIo
	SET ^DHCRisIo="|TCP|2" 
    OPEN ^DHCRisIo:(^DHCRisHL7ServerIP:^DHCRisHL7ServerPort:"M":/IOT="GB18030"):200 ;Connect to server
   	q:('$TEST) 100
  	q 0
}

/// d ##class(web.DHCRisHL7).DisConnectHL7Server()
ClassMethod DisConnectHL7Server()
{
	CLOSE ^DHCRisIo
	k ^DHCRisIo
}

ClassMethod GetSexCode(Sex)
{
    s SexCode="O"
	if Sex="男" d
	 .s SexCode="M"
	else  if Sex="女" d
	.s SexCode="F"
	else  if Sex="其他" d
	.s SexCode="O"  d
	else  if Sex="未知" d
	.s SexCode="U" d
	else  if Sex="不确定" d
	.s SexCode="A"
	else 
	.s SexCode="N"
    q SexCode
}

ClassMethod GetMaritalCode(MaritalStatus) As %String
{
	if MaritalStatus="已婚" d
	 .s MaritalCode="M"
	else  if MaritalStatus="未婚" d
	 .s MaritalCode="B"
	else  if MaritalStatus="离婚" d
	.s MaritalCode="D"
	else  if MaritalStatus="丧偶" d
	.s MaritalCode="W"
	else  d
	.s MaritalCode="O"
	q MaritalCode
}

ClassMethod GetPatientClass(PatientClass) As %String
{
	i PatientClass="H" s PatientClass="P"
	if (PatientClass'="I")&&(PatientClass'="O")&&(PatientClass'="E")&&(PatientClass'="P") s PatientClass="U"
	q PatientClass
}

//修改--yzd--081111

// 发送住院消息  ADT^A01 消息

ClassMethod SendADTA01Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNo = "", AppType = "", orditemrowid = "", forceCreate = "0") As %String
{
	s RecApplication="RIS"
	if MessageType="2" d
	.s RecApplication="US"
 
	if DOB'="" d
	.; 2008-03-20
	.s DOB=$zdh(DOB,5)
	.s DOB=$zd(DOB,8)
	s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
  
    s MessageID="A01"_VisitNumber
	s MSH="MSH|^~\&|HIS^^|R|"_RecApplication_"^^|R^^|20030408132351||ADT^A01|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	s EVN="EVN|A01|"_CurrentDateTime_$C(13)
	s SexCode=..GetSexCode(Sex)
	s MaritalStatusCode=..GetMaritalCode(MaritalStatus)
	s PatientClass=..GetPatientClass(PatientClass)
	s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^||"_DOB_"|"_SexCode_"|||"_Address_"||"_HomeTel_"|"_BussinessTel_"||"_MaritalStatus_"||||||||||||||"_$C(13)
	s PatientLocation=Ward_"^"_Room_"^"_Bed
	s PV1="PV1|1|"_PatientClass_"|"_PatientLocation_"||||"_AttendingDoctor_"|"_ReferringDoctor_"||||||||"_VIPIndicator_"|"_AdmittingDoctor_"|"_PatientType_"|"_VisitNumber_"||"
    s ADTA01=$C(11)_MSH_EVN_PID_PV1_$C(28)_$C(13) 
    s Index=""
    i MessageType="1" d
    .s Index=$g(^DHCRisHL7Index(MessageID))
    .i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7No)
    ..i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ..s ^DHCRisHL7No=^DHCRisHL7No+1
    ..s ^DHCRisHL7Message(^DHCRisHL7No)=ADTA01
	..s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	..lock -(^DHCRisHL7No)
    e  i MessageType="2" d
    .s Index=$g(^DHCRisHL7IndexBC(MessageID))
    .i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoBC)
    ..i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ..s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
    ..s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ADTA01
	..s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	..lock -(^DHCRisHL7NoBC)
    e  i MessageType="3" d
    .s Index=$g(^DHCRisHL7IndexNJ(MessageID))
    .i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoNJ)
    ..i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ..s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
    ..s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ADTA01
	..s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
	..lock -(^DHCRisHL7NoNJ)
	
    QUIT 0
}

//修改--yzd--081111

//d ##class(web.DHCRisHL7).SendADTA02Message("","06855678","王淑青","I","耳鼻喉科一病区^^24392","耳鼻喉科一病区^^24393","1548402","1","","")

ClassMethod SendADTA02Message(MessageID, PatientID, PatientName, PatientClass, Location, PriorPatientLocation, VisitNumber, MessageType = "1", CardNo = "", IPNo = "") As %String
{
    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
    i MessageID'="" d
    .;s ^DHCRisHL7Message(MessageID)=$g(^DHCRisHL7Message(MessageID))
    .;USE ^DHCRisIo WRITE ^DHCRisHL7Message(MessageID),!
    else  d
    .s MessageID="A02"_CurrentDateTime
	.s MSH="MSH|^~\&|HIS^^|R|RIS^^|R^^|20030408132351||ADT^A02|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	.s EVN="EVN|A02|"_CurrentDateTime_$C(13)
	.s PatientClass=..GetPatientClass(PatientClass)
	.s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^|||||||||||||||||||||||||"_$C(13)
	.s PV1="PV1|1|"_PatientClass_"|"_Location_"|||"_PriorPatientLocation_"|||||||||||||"_VisitNumber_"||"_$C(13)
	.s ADTA02=$C(11)_MSH_EVN_PID_PV1_$C(28)_$C(13)
	 
    .i MessageType="1" d
  	..s Index=$g(^DHCRisHL7Index(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ...s ^DHCRisHL7No=^DHCRisHL7No+1
    ...s ^DHCRisHL7Message(^DHCRisHL7No)=ADTA02
	...s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	
	.e  i MessageType="2" d
	..s Index=$g(^DHCRisHL7IndexBC(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ...s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
    ...s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ADTA02
	...s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	
	.e  i MessageType="3" d
	..s Index=$g(^DHCRisHL7IndexNJ(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ...s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
    ...s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ADTA02
	...s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
	
	.;USE ^DHCRisIo WRITE ADTA02,!
	.;d ##class(web.DHCRisHL7).ReadInfo(MessageID)
    QUIT 0
}

/// SendADTA04Message 发送门诊消息
ClassMethod SendADTA04Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Location, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNo = "", AppType = "", orditemrowid = "", forceCreate = "0") As %String
{
	s RecApplication="RIS"
	if MessageType="2" d
	.s RecApplication="US"

	;s Location="^"
	if DOB'="" d
	.; 2008-03-20
	.s DOB=$zdh(DOB,5)
	.s DOB=$zd(DOB,8)
    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
    s MessageID="A04"_VisitNumber
	s MSH="MSH|^~\&|HIS^^|R|"_RecApplication_"^^|R^^|20030408132351||ADT^A04|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	s EVN="EVN|A04|"_CurrentDateTime_$C(13)
	s SexCode=..GetSexCode(Sex)
	s MaritalStatusCode=..GetMaritalCode(MaritalStatus)
	s PatientClass=..GetPatientClass(PatientClass)
	s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^||"_DOB_"|"_SexCode_"|||"_Address_"||"_HomeTel_"|"_BussinessTel_"||"_MaritalStatus_"||||||||||||||"_$C(13)
	s PV1="PV1|1|"_PatientClass_"|"_Location_"||||"_AttendingDoctor_"|"_ReferringDoctor_"||||||||"_VIPIndicator_"|"_AdmittingDoctor_"|"_PatientType_"|"_VisitNumber_"||"_$C(13)
	s ADTA04=$C(11)_MSH_EVN_PID_PV1_$C(28)_$C(13)
	s Index=""
	i MessageType="1" d
	.s Index=$g(^DHCRisHL7Index(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7No)
    ..i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ..s ^DHCRisHL7No=^DHCRisHL7No+1
    ..s ^DHCRisHL7Message(^DHCRisHL7No)=ADTA04
	..s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	..lock -(^DHCRisHL7No)
    else  i MessageType="2" d
    .s Index=$g(^DHCRisHL7IndexBC(MessageID))
    .i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoBC)
    ..i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ..s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
	..s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ADTA04
	..s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	..lock -(^DHCRisHL7NoBC)
    else  i MessageType="3" d
    .s Index=$g(^DHCRisHL7IndexNJ(MessageID))
    .i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoNJ)
    ..i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ..s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
	..s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ADTA04
	..s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
	..lock -(^DHCRisHL7NoNJ)

    QUIT 0
}

ClassMethod SendADTA06Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Location, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNo = "") As %String
{
    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
    if MessageID'="" d
    .;s ^DHCRisHL7Message(MessageID)=$g(^DHCRisHL7Message(MessageID))
    .;USE ^DHCRisIo WRITE ^DHCRisHL7Message(MessageID),!
    else  d
    .s MessageID="A06"_VisitNumber
	.s MSH="MSH|^~\&|HIS^^|R|RIS^^|R^^|20030408132351||ADT^A01|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	.s EVN="EVN|A01|"_CurrentDateTime_$C(13)
	.s SexCode=..GetSexCode(Sex)
	.s MaritalStatusCode=..GetMaritalCode(MaritalStatus)
	.s PatientClass=..GetPatientClass(PatientClass)
	.s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^||"_DOB_"|"_SexCode_"|||"_Address_"||"_HomeTel_"|"_BussinessTel_"||"_MaritalStatus_"||||||||||||||"_$C(13)
	.s PV1="PV1|1|"_PatientClass_"|"_Location_"||||"_AttendingDoctor_"|"_ReferringDoctor_"||||||||"_VIPIndicator_"|"_AdmittingDoctor_"|"_PatientType_"|"_VisitNumber_"||"_$C(13)
	.s ADTA06=$C(11)_MSH_EVN_PID_PV1_$C(28)_$C(13)
	    
    .i MessageType="1" d
	..s Index=$g(^DHCRisHL7Index(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ...s ^DHCRisHL7No=^DHCRisHL7No+1
    ...s ^DHCRisHL7Message(^DHCRisHL7No)=ADTA06
	...s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	
	.e  i MessageType="2" d
	..s Index=$g(^DHCRisHL7IndexBC(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ...s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
    ...s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ADTA06
	...s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	
	.e  i MessageType="3" d
	..s Index=$g(^DHCRisHL7IndexNJ(MessageID))
    ..i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ...i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ...s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
    ...s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ADTA06
	...s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
    
    .;USE ^DHCRisIo WRITE ADTA06,!
    .;d ##class(web.DHCRisHL7).ReadInfo(MessageID)
    QUIT 0
}

/// MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber
/// DOB :生日MM/DD/YYYY,
/// HomeTel:家庭电话，
/// BussinessTel：公司电话
/// MaritalStatus：已婚/未婚/离婚/丧偶
/// PatientClass:住院病人/门诊病人/急诊病人/..
/// AttendingDoctor
/// ReferringDoctor, 
/// VIPIndicator: VIP 标志
/// AdmittingDoctor, 
/// PatientType, 是否重要病人，可以空
/// VisitNumber paadm.rowid
ClassMethod SendADTA08Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNo = "", AppType = "", orditemrowid = "", forceCreate = "0") As %String
{
	s RecApplication="RIS"
	if MessageType="2" d
	.s RecApplication="US"
    if DOB'="" d
	.s DOB=$zdh(DOB,6)
	.s DOB=$zd(DOB,8)
    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
    s MessageID="A08"_VisitNumber_CurrentTime
	s MSH="MSH|^~\&|HIS^^|R|"_RecApplication_"^^|R^^|20030408132351||ADT^A08|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	s EVN="EVN|A08|"_CurrentDateTime_$C(13)
	s SexCode=..GetSexCode(Sex)
	s MaritalStatusCode=..GetMaritalCode(MaritalStatus)
	s PatientClass=..GetPatientClass(PatientClass)
	s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^||"_DOB_"|"_SexCode_"|||"_Address_"||"_HomeTel_"|"_BussinessTel_"||"_MaritalStatus_"||||||||||||||"_$C(13)
	s PatientLocation=Ward_"^"_Room_"^"_Bed
	s PV1="PV1|1|"_PatientClass_"|"_PatientLocation_"||||"_AttendingDoctor_"|"_ReferringDoctor_"||||||||"_VIPIndicator_"|"_AdmittingDoctor_"|"_PatientType_"|"_VisitNumber_"||"
    s ADTA08=$C(11)_MSH_EVN_PID_PV1_$C(28)_$C(13)
    b
   
    s Index=""
    i MessageType="1" d
	.s Index=$g(^DHCRisHL7Index(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7No)
    ..i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ..s ^DHCRisHL7No=^DHCRisHL7No+1
    ..s ^DHCRisHL7Message(^DHCRisHL7No)=ADTA08
	..s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	..lock -(^DHCRisHL7No)
    
    e  i MessageType="2" d
	.s Index=$g(^DHCRisHL7IndexBC(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoBC)
    ..i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ..s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
    ..s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ADTA08
	..s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	..lock -(^DHCRisHL7NoBC)
    
    e  i MessageType="3" d
	.s Index=$g(^DHCRisHL7IndexNJ(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoNJ)
    ..i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ..s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
    ..s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ADTA08
	..s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
	..lock -(^DHCRisHL7NoNJ)
     QUIT 0
}

//MessageID, ControlID, PatientID, PatientName, oeorditemrowid, PatientClass, OrderProvider, VisitNumber, ArcItmCode, ArcItemName, RecLoc, RelevantInfo

//MessageID:""

//ControlID "NW"/"CA"

// oeorditemrowid: oeorditem.rowid

// OrderProvider:下医嘱医生CODE ,CT_CAREPROV.CODE 

//  ArcItmCode, ArcItemName

//  RecLoc:执行科室的CTLOC.CODE , RelevantInfo:临床诊断^症状和体征^既往病史^备注

//d ##class(web.DHCRisHL7).SendORMO01Message("","CA","06268540","李宝平","286624||3","O","","286793","FS0026","颈椎数字化摄影(DR)正侧双斜位","187","正常","","","")

ClassMethod SendORMO01Message(MessageID, ControlID, PatientID, PatientName, oeorditemrowid, PatientClass, OrderProvider, VisitNumber, ArcItmCode, ArcItemName, RecLoc, RelevantInfo, Ward, Room, Bed, MessageType = "1", CardNo = "", IPNo = "", AppType = "", DOB = "", Sex = "", Address = "", HomeTel = "", BussinessTel = "", MaritalStatus = "", cost = "", ItemCatRowid = "", forceCreate = "0") As %String
{
	
	s RecApplication="RIS"
	if MessageType="2" d
	.s RecApplication="US"

	//MessageType 1  --放射   2--超声  3--内镜  
	s AckInfo=""
	s OrdRowid=$p(oeorditemrowid,"||",1)
	s ChildSub=$p(oeorditemrowid,"||",2)
	s oeorditemrowid1=oeorditemrowid
	s oeorditemrowid=OrdRowid_"_"_ChildSub
	
	if DOB'="" d 
	.s DOB=$zdh(DOB,6)
	.s DOB=$zd(DOB,8)
	
	s SexCode=..GetSexCode(Sex)
	s MaritalStatusCode=..GetMaritalCode(MaritalStatus)


    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
  
  
    s MessageID="O01"_ControlID_OrdRowid_ChildSub
	s PatientClass=..GetPatientClass(PatientClass)
	
	s ArcItemName=$p(ArcItemName,$c(10))
    s ArcItemName=$p(ArcItemName,$c(13))
    
    i ItemCatRowid'="" d
	.s UniverService=ArcItmCode_"^"_ArcItemName_"^"_RecLoc_"^"_ItemCatRowid
	else  d
	.s UniverService=ArcItmCode_"^"_ArcItemName_"^"_RecLoc
	
	s MSH="MSH|^~\&|HIS^^|R|"_RecApplication_"^^|R^^|20030408132351||ORM^O01|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
	s PID="PID|1||"_PatientID_"^"_CardNo_"^"_IPNo_"||"_PatientName_"^||"_DOB_"|"_SexCode_"|||"_Address_"||"_HomeTel_"|"_BussinessTel_"||"_MaritalStatusCode_"||||||||||||||"_$C(13)
	s Location=Room
	s PV1="PV1|1|"_PatientClass_"|"_Location_"||||||||||||||||"_VisitNumber_"||"_$C(13)
	s ORC="ORC|"_ControlID_"|"_oeorditemrowid_"^IHD|||||||"_CurrentDateTime_"|"_OrderProvider_"||"_OrderProvider_"|"_Location_"||"_$C(13)
    s OBR="OBR||"_oeorditemrowid_"^IHD||"_UniverService_"||||||||||||"_OrderProvider_"|||||||"_cost_"^|"_$C(13)
    s Diagnose=$p(RelevantInfo,"^",1)
    s Diagnose=..GetHL7BKField(Diagnose)
    s Current=$p(RelevantInfo,"^",2)
    s Current=..GetHL7BKField(Current)
    s ItemInfo=$p(RelevantInfo,"^",3)
    s Global=$p(RelevantInfo,"^",4)
    s Global=..GetHL7BKField(Global)
    s NTE1="NTE|1|P|"_Diagnose_$C(13)
    s NTE2="NTE|2|P|"_Current_$C(13)
    s NTE3="NTE|3|P|"_ItemInfo_$C(13)
    s NTE4="NTE|4|P|"_Global_$C(13)
    s ORMO01=$C(11)_MSH_PID_PV1_ORC_OBR_NTE1_NTE2_NTE3_NTE4_$C(28)_$C(13)
    
    s Index=""    
    i MessageType="1" d
	.s Index=$g(^DHCRisHL7Index(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7No)
    ..i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    ..s ^DHCRisHL7No=^DHCRisHL7No+1
    ..s ^DHCRisHL7Message(^DHCRisHL7No)=ORMO01
	..s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
	..lock -(^DHCRisHL7No)
	..;s ^DHCRisHL7Message("PatientID",^DHCRisHL7No)=PatientID
    
    e  i MessageType="2" d
	.s Index=$g(^DHCRisHL7IndexBC(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoBC)
    ..i $g(^DHCRisHL7NoBC)="" s ^DHCRisHL7NoBC=0
    ..s ^DHCRisHL7NoBC=^DHCRisHL7NoBC+1
    ..s ^DHCRisHL7MessageBC(^DHCRisHL7NoBC)=ORMO01
	..s ^DHCRisHL7IndexBC(MessageID)=^DHCRisHL7NoBC
	..lock -(^DHCRisHL7NoBC)
	..;s ^DHCRisHL7MessageBC("PatientID",^DHCRisHL7NoBC)=PatientID
    
    e  i MessageType="3" d
	.s Index=$g(^DHCRisHL7IndexNJ(MessageID))
	.i forceCreate'="0" s Index=""
    .i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    ..lock +(^DHCRisHL7NoNJ)
    ..i $g(^DHCRisHL7NoNJ)="" s ^DHCRisHL7NoNJ=0
    ..s ^DHCRisHL7NoNJ=^DHCRisHL7NoNJ+1
    ..s ^DHCRisHL7MessageNJ(^DHCRisHL7NoNJ)=ORMO01
	..s ^DHCRisHL7IndexNJ(MessageID)=^DHCRisHL7NoNJ
	..lock -(^DHCRisHL7NoNJ)
	..;s ^DHCRisHL7MessageNJ("PatientID",^DHCRisHL7NoNJ)=PatientID
    
    QUIT 0
}

// d ##class(web.DHCRisHL7).SendACKMessage(MessageID, MessageType, AckCode) 

ClassMethod SendACKMessage(MessageID, MessageType, AckCode) As %String
{
	s MSH="MSH|^~\&|HIS^^|R|RIS^^|R^^|20030408132351||"_MessageType_"|1|P^|2.3.1"_$C(13)
	s MSA="MSA|"_AckCode_"|"_MessageID_$C(13)
	s ACKXXX=$C(11)_MSH_MSA_$C(28)_$C(13)
	USE ^DHCRisIo WRITE ACKXXX,!
	q 0
}

ClassMethod SendHL7Message(MessageID) As %String
{
     q:MessageID="" 100
	 s ^DHCRisHL7Message(MessageID)=$g(^DHCRisHL7Message(MessageID))
     i ^DHCRisHL7Message(MessageID)'="" d
     .USE ^DHCRisIo WRITE ^DHCRisHL7Message(MessageID),!
     q 0
}

ClassMethod ReadInfo(MessageID)
{
	n (MessageID)
	s ACKInfo=""
	s MSA="MSA"
	Do
	{
		Hang 1
		USE ^DHCRisIo READ ACKInfo:3 
		if ACKInfo'="" d
		.s DHCRisHL7ACKMessage($h)=ACKInfo
		.i ACKInfo]MSA d
		..s GetMessageID=$p(ACKInfo,"|",3)
		..i GetMessageID=MessageID d
		...k ^DHCRisHL7Message(MessageID)
		else  d
		.; 没有收到回应消息，重新发送新消息
		.s ret=..SendHL7Message(MessageID)
	}while(ACKInfo'=$C(28))
}

/// 发送病人的基本信息
ClassMethod SendPatientInfo(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNO = "", AppType = "", orditemrowid = "", forcecreate = "0") As %String
{
	
	
	if (PatientClass="I")  d
	.s ret=..SendADTA01Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType,CardNo,IPNO,AppType,orditemrowid,forcecreate)
	else  d
	.s Location=Room
	.s ret=..SendADTA04Message(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Location, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType,CardNo,IPNO,AppType,orditemrowid,forcecreate)
	q ret
}

/// 查询不能处理消息列表
Query QueryUnProcessHL7Message() As %Query(ROWSPEC = "TIndex:%String,MessageInfo:%String")
{
}

ClassMethod QueryUnProcessHL7MessageExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    
 	s Index=0 f  s Index=$o(^DHCRisHL7MessageSent(Index)) q:(Index="")  d
 	.s Info=^DHCRisHL7MessageSent(Index)
	.Do OutRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow2
	set Data=$lb(Index,Info)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryUnProcessHL7MessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUnProcessHL7MessageExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryUnProcessHL7MessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUnProcessHL7MessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DeleteUnProcessHL7Message(Index As %String) As %String
{
	i Index'="" k ^DHCRisHL7MessageSent(Index)
	q "0"
}

/// 在字段中出现回车换行，转换成HL7 的回车换行 
/// 对\n和\r分别进行了16进制的转义，变为\X000a\和\X000b\ 
ClassMethod GetHL7BKField(Param) As %String
{
   s Info=""
   s nums=$l(Param,$c(13,10))
   
   for i=1:1:nums  d
   .s perContent=$p(Param,$c(13,10),i)
   .i Info="" s Info=perContent
   .else  d
   ..s Info=Info_"\X000a\"_perContent
   q Info
}

/*
/函数：ReSentADTMessage  
/功能：根据医嘱的ROWID，重新发送病人的消息 ADT^A01 或者 ADT^A04 消息
/参数：OrditemRowid  格式：23||45 
/      MessageType  1:  放射   2 超声   3 内镜
/      d ##class(web.DHCRisHL7).ReSentADTMessage("44139||9","1")
*/
ClassMethod ReSentADTMessage(OrditemRowid, MessageType = "1") As %String
{
   s orderrowid=$p(OrditemRowid,"||",1)
   s childsub=$p(OrditemRowid,"||",2)
   s paadmdr=$p(^OEORD(orderrowid),"^",1)
   
   s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
   s GetRegNo=$p(PatInfo,"^",1)
   s GetName=$p(PatInfo,"^",2)
   s GetstrDOB=$p(PatInfo,"^",3)
   i (GetstrDOB'="") d
   .s GetstrDOB=$zdh(GetstrDOB,4)
   .s GetstrDOB=$zd(GetstrDOB,3)
   s GetSexDesc=$p(PatInfo,"^",5)
   s Getpatienttype=$p(PatInfo,"^",6)
   s Gettypedesc=$p(PatInfo,"^",7)
   s GetLocName=$p(PatInfo,"^",8)
   s GetIPNo=$p(PatInfo,"^",9)
   s GetWardName=$p(PatInfo,"^",10)
   s GetBedNo=$p(PatInfo,"^",11)
   s TelNo=$p(PatInfo,"^",19)
   s address=$p(PatInfo,"^",22)
   // SendPatientInfo(MessageID, PatientID, PatientName, DOB, Sex, Address, HomeTel, BussinessTel, MaritalStatus, PatientClass, Ward, Room, Bed, AttendingDoctor, ReferringDoctor, VIPIndicator, AdmittingDoctor, PatientType, VisitNumber, MessageType = "1", CardNo = "", IPNO = "", AppType = "", orditemrowid = "",forcecreate ="0"
   s ret=##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,MessageType,"","","","","1")
   q ret
}

/*
/函数：ReSentADTA08Message
/功能：根据医嘱的ROWID，重新发送病人的消息 ADT^A08 
 参数：OrditemRowid  格式：23||45 
       MessageType  1:  放射   2 超声   3 内镜
       d ##class(web.DHCRisHL7).ReSentADTA08Message("3499613||8","1")
*/
ClassMethod ReSentADTA08Message(OrditemRowid, MessageType = "1") As %String
{
  
   s orderrowid=$p(OrditemRowid,"||",1)
   s childsub=$p(OrditemRowid,"||",2)
   s paadmdr=$p(^OEORD(orderrowid),"^",1)
   s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
   s GetRegNo=$p(PatInfo,"^",1)
   s GetName=$p(PatInfo,"^",2)
   s GetstrDOB=$p(PatInfo,"^",3)
   i (GetstrDOB'="") d
   .s GetstrDOB=$zdh(GetstrDOB,4)
   .s GetstrDOB=$zd(GetstrDOB,3)
   s GetSexDesc=$p(PatInfo,"^",5)
   s Getpatienttype=$p(PatInfo,"^",6)
   s Gettypedesc=$p(PatInfo,"^",7)
   s GetLocName=$p(PatInfo,"^",8)
   s GetIPNo=$p(PatInfo,"^",9)
   s GetWardName=$p(PatInfo,"^",10)
   s GetBedNo=$p(PatInfo,"^",11)
   s TelNo=$p(PatInfo,"^",19)
   s address=$p(PatInfo,"^",22)
  
   s PapmiHl7Ret=##class(web.DHCRisHL7).SendADTA08Message("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", "", "", "", "", "", "", "", "", "", paadmdr,MessageType ,"","","",OrditemRowid,"1")
   q PapmiHl7Ret
}

/*
/函数：ReSentOrM01Message 
/功能：根据医嘱的ROWID，重新发送病人的消息 ORM01 消息
/参数：OrditemRowid  格式：23||45 
        MessageType  1:  放射   2 超声   3 内镜
        Control: NW ,   CA 
         d ##class(web.DHCRisHL7).ReSentOrM01Message("76916||6","2","")
*/
ClassMethod ReSentOrM01Message(OrditemRowid, MessageType = "1", Control = "NW")
{
   s orderrowid=$p(OrditemRowid,"||",1)
   s childsub=$p(OrditemRowid,"||",2)
   s paadmdr=$p(^OEORD(orderrowid),"^",1)
   s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
   s GetRegNo=$p(PatInfo,"^",1)
   s GetName=$p(PatInfo,"^",2)
   s GetstrDOB=$p(PatInfo,"^",3)
   i (GetstrDOB'="") d
   .s GetstrDOB=$zdh(GetstrDOB,4)
   .s GetstrDOB=$zd(GetstrDOB,3)
   s GetSexDesc=$p(PatInfo,"^",5)
   s Getpatienttype=$p(PatInfo,"^",6)
   s Gettypedesc=$p(PatInfo,"^",7)
   s GetLocName=$p(PatInfo,"^",8)
   s GetIPNo=$p(PatInfo,"^",9)
   s GetWardName=$p(PatInfo,"^",10)
   s GetBedNo=$p(PatInfo,"^",11)
   s TelNo=$p(PatInfo,"^",19)
   s address=$p(PatInfo,"^",22)
   
   s CardNo=$p(PatInfo,"^",35)
   
   s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(orderrowid,childsub)
   s GetstrOrderName=$p(ordInfo,"^",1)
   s GetstrDate=$p(ordInfo,"^",2)
   s GetstrTime=$p(ordInfo,"^",3)
   s Getrequestdoc=$p(ordInfo,"^",4)
   s GetstrAccessionNum=$p(ordInfo,"^",5)
   s GetSGroupDesc=$p(ordInfo,"^",6)
   s GetsubCatDesc=$p(ordInfo,"^",7)
   s GetCatDesc=$p(ordInfo,"^",8)
   s Getifbed=$p(ordInfo,"^",9)
   s Getprice=$p(ordInfo,"^",10)
   s GetordDate=$p(ordInfo,"^",15)
   s ItemCode=$p(ordInfo,"^",22)
   
    s RecLocId=$p($G(^OEORD(orderrowid,"I",childsub,3)),"^",6)
	; modi by gongping 2010-11-30
	

	s RecLocDesc=""
	if (MessageType=2) d
	.i RecLocId'="" s RecLocDesc=$p(^CTLOC(RecLocId),"^",1)

   s RelevantInfo=##class(web.DHCRisApplicationBill).GetAppInfo(OrditemRowid)
   //MessageID, ControlID, PatientID, PatientName, oeorditemrowid, PatientClass, OrderProvider, VisitNumber, ArcItmCode, ArcItemName, RecLoc, RelevantInfo, Ward, Room, Bed, MessageType = "1", CardNo = "", IPNo = "", AppType = "", DOB = "", Sex = "", Address = "", HomeTel = "", BussinessTel = "", MaritalStatus = "", cost = "", ItemCatRowid = "",forceCreate ="0"
   s ret= ##class(web.DHCRisHL7).SendORMO01Message("", Control, GetRegNo, GetName, OrditemRowid, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, RecLocDesc, RelevantInfo, GetWardName,GetLocName, GetBedNo,MessageType,CardNo,GetIPNo,"",GetstrDOB,GetSexDesc,"","","","",Getprice,"","1")
   q ret
}

ClassMethod FindnotSendMessage(SendDate As %String, PatientID As %String, MessageType As %String = "1") As %String
{
}

/// Query: QueryNotSendMessage
/// 功能： 查询不能处理消息列表
/// 参数： StartDate 开始日期， EndDate 结束日期， PatientID 登记号， MessageType 消息类型， OrditemRowid 医嘱的ROWID  7||8
/// 返回 ：没有发送的消息   格式： 登记号  姓名 生日 性别  医嘱名称  消息名称  时间  序号  消息内容  
/// 作者： gongping
/// 日期:  2010-12-14 
/// d ##class(%ResultSet).RunQuery("web.DHCRisHL7","QueryNotSendMessage",62080,62080,"","1")
Query QueryNotSendMessage(StartDate As %String, EndDate As %String, PatientID As %String, MessageType As %String = "1") As %Query(ROWSPEC = "TPatientID:%String,TName:%String,TDOB:%String,TSex:%String,TOrderName:%String,TMessageName:%String,TTime:%String,TIndex:%String,TMessage:%String")
{
}

ClassMethod QueryNotSendMessageExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientID As %String, MessageType As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^TMPRIS=StartDate_"^"_EndDate_"^"_PatientID_"^"_MessageType
	i (PatientID'="")&(MessageType="1") d
	.s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSenti("PatientID",PatientID,MessageIndex)) q:MessageIndex=""  d
	..s MessageInfo=$g(^DHCRisHL7MessageSent(MessageIndex))
	..s PatientInfo=..GetPatientInfo(MessageInfo)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
	..s DOB=$p(PatientInfo,$c(1),3)
	..s Sex=$p(PatientInfo,$c(1),4)
	..s OrdName=$p(PatientInfo,$c(1),5)
	..s MessageName=$p(PatientInfo,$c(1),6)
	..s strMessageTime=""
	..i $g(PatientID)'="" d
	...s MessageTime=$g(^DHCRisHL7MessageSenti("PatientID",PatientID,MessageIndex))
	...i MessageTime'="" d
	....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	..Do OutRow1

	else  if (PatientID'="")&(MessageType="2") d
	.s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSentBCi("PatientID",PatientID,MessageIndex)) q:MessageIndex=""  d
	..s MessageInfo=$g(^DHCRisHL7MessageSentBC(MessageIndex))
	..s PatientInfo=..GetPatientInfo(MessageInfo)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
	..s DOB=$p(PatientInfo,$c(1),3)
	..s Sex=$p(PatientInfo,$c(1),4)
	..s OrdName=$p(PatientInfo,$c(1),5)
	..s MessageName=$p(PatientInfo,$c(1),6)
	..s strMessageTime=""
	..i $g(PatientID)'="" d
	...s MessageTime=$g(^DHCRisHL7MessageSentBCi("PatientID",PatientID,MessageIndex))
	...i MessageTime'="" d
	....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	..Do OutRow1
	else  if (PatientID'="")&(MessageType="3") d
	.s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSentNJi("PatientID",PatientID,MessageIndex)) q:MessageIndex=""  d
	..s MessageInfo=$g(^DHCRisHL7MessageSentNJ(MessageIndex))
	..s PatientInfo=..GetPatientInfo(MessageInfo)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
	..s DOB=$p(PatientInfo,$c(1),3)
	..s Sex=$p(PatientInfo,$c(1),4)
	..s OrdName=$p(PatientInfo,$c(1),5)
	..s MessageName=$p(PatientInfo,$c(1),6)
	..s strMessageTime=""
	..i $g(PatientID)'="" d
	...s MessageTime=$g(^DHCRisHL7MessageSentNJi("PatientID",PatientID,MessageIndex))
	...i MessageTime'="" d
	....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	..Do OutRow1
	else  if (MessageType="1") d
	.f currdate=StartDate:1:EndDate d
	..s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSenti("Date",currdate,MessageIndex)) q:MessageIndex=""  d
	...s MessageInfo=$g(^DHCRisHL7MessageSent(MessageIndex))
	...s PatientInfo=..GetPatientInfo(MessageInfo)
	...s PatientID=$p(PatientInfo,$c(1),1)
	...s Name=$p(PatientInfo,$c(1),2)
	...s DOB=$p(PatientInfo,$c(1),3)
	...s Sex=$p(PatientInfo,$c(1),4)
	...s OrdName=$p(PatientInfo,$c(1),5)
	...s MessageName=$p(PatientInfo,$c(1),6)
	...s strMessageTime=""
	...i $g(PatientID)'="" d
	....s MessageTime=$g(^DHCRisHL7MessageSenti("PatientID",PatientID,MessageIndex))
	....i MessageTime'="" d
	.....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	...Do OutRow1

	else  if (MessageType="2") d
	.f currdate=StartDate:1:EndDate d
	..s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSentBCi("Date",currdate,MessageIndex)) q:MessageIndex=""  d
	...s MessageInfo=$g(^DHCRisHL7MessageSentBC(MessageIndex))
	...s PatientInfo=..GetPatientInfo(MessageInfo)
	...s PatientID=$p(PatientInfo,$c(1),1)
	...s Name=$p(PatientInfo,$c(1),2)
	...s DOB=$p(PatientInfo,$c(1),3)
	...s Sex=$p(PatientInfo,$c(1),4)
	...s OrdName=$p(PatientInfo,$c(1),5)
	...s MessageName=$p(PatientInfo,$c(1),6)
	...s strMessageTime=""
	...i $g(PatientID)'="" d
	....s MessageTime=$g(^DHCRisHL7MessageSentBCi("PatientID",PatientID,MessageIndex))
	....i MessageTime'="" d
	.....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	...Do OutRow1


	else  if (MessageType="3") d
	.f currdate=StartDate:1:EndDate d
	..s MessageIndex=0 f  s MessageIndex=$o(^DHCRisHL7MessageSentNJi("Date",currdate,MessageIndex)) q:MessageIndex=""  d
	...s MessageInfo=$g(^DHCRisHL7MessageSentNJ(MessageIndex))
	...s PatientInfo=..GetPatientInfo(MessageInfo)
	...s PatientID=$p(PatientInfo,$c(1),1)
	...s Name=$p(PatientInfo,$c(1),2)
	...s DOB=$p(PatientInfo,$c(1),3)
	...s Sex=$p(PatientInfo,$c(1),4)
	...s OrdName=$p(PatientInfo,$c(1),5)
	...s MessageName=$p(PatientInfo,$c(1),6)
	...s strMessageTime=""
	...i $g(PatientID)'="" d
	....s MessageTime=$g(^DHCRisHL7MessageSentNJi("PatientID",PatientID,MessageIndex))
	....i MessageTime'="" d
	.....s strMessageTime=$zd(+MessageTime,3)_" "_$zt($p(MessageTime,",",2),1)
	...Do OutRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow1
    /// 登记号  姓名 生日 性别  医嘱名称  消息名称  时间  序号  消息内容  
	set Data=$lb(PatientID,Name,DOB,Sex,OrdName,MessageName,strMessageTime,MessageIndex,MessageInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryNotSendMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNotSendMessageExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryNotSendMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNotSendMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：GetPatientInfo
/// 功能：从HL7 消息里面获取病人的基本信息
/// 返回值：登记号^病人姓名^生日^性别
ClassMethod GetPatientInfo(MessageInfo As %String) As %String
{
	s MSHInfo=$p(MessageInfo,$c(13),1)
	s MessageName=$p(MSHInfo,"|",9)
	s OrdName=""
	i MessageName="ORM^O01"  d
	.s OBR=$p(MessageInfo,$c(13),5)
	.s ServiceInfo=$p(OBR,"|",5)
	.S OrdName=$p(ServiceInfo,"^",2)
	.s PatientInfo1=$p(MessageInfo,$c(13),2)

	else  d
	.s PatientInfo1=$p(MessageInfo,$c(13),3)
	 
	s RegNoInfo=$p(PatientInfo1,"|",4)
	s regNo=$p(RegNoInfo,"^",1)
	s Name=$p(PatientInfo1,"|",6)
	s Name=$p(Name,"^",1)
	s DOB=$p(PatientInfo1,"|",8)
	s Sex=$p(PatientInfo1,"|",9)
    s Info1=regNo_$c(1)_Name_$c(1)_DOB_$c(1)_Sex_$c(1)_OrdName_$c(1)_MessageName
    
	q Info1
}

/// 函数：ReSentHL7Message
/// 功能：从已发送消息队列消息 放入发送消息队列
/// 返回值：Y/N 
/// s Ret=##class(web.DHCRisHL7).ReSentHL7Message("1","1")
ClassMethod ReSentHL7Message(MessageIndex As %String, MessageType As %String = "1") As %String
{
	q:MessageIndex="" "N"
	i MessageType="1"  d
	.s ^DHCRisHL7Message(MessageIndex)=$g(^DHCRisHL7MessageSent(MessageIndex))
	.s Info=^DHCRisHL7MessageSent(MessageIndex)
	.s PatientInfo=..GetPatientInfo(Info)
	.s PatientID=$p(PatientInfo,$c(1),1)
	.s Name=$p(PatientInfo,$c(1),2)
    .s date=$g(^DHCRisHL7MessageSenti("PatientID",PatientID,MessageIndex))
    .s date=$p(date,",",1)
    .k ^DHCRisHL7MessageSenti("Date",date,MessageIndex)
    .k ^DHCRisHL7MessageSenti("PatientID",PatientID,MessageIndex)
    .k ^DHCRisHL7MessageSenti("PatientName",Name,MessageIndex)
    .k ^DHCRisHL7MessageSent(MessageIndex)
	else  if MessageType="2"  d
	.s ^DHCRisHL7MessageBC(MessageIndex)=$g(^DHCRisHL7MessageSentBC(MessageIndex))
	.s Info=^DHCRisHL7MessageSentBC(MessageIndex)
	.s PatientInfo=..GetPatientInfo(Info)
	.s PatientID=$p(PatientInfo,$c(1),1)
	.s Name=$p(PatientInfo,$c(1),2)
    .s date=$g(^DHCRisHL7MessageSentBCi("PatientID",PatientID,MessageIndex))
    .s date=$p(date,",",1)
    .k ^DHCRisHL7MessageSentBCi("Date",date,MessageIndex)
    .k ^DHCRisHL7MessageSentBCi("PatientID",PatientID,MessageIndex)
    .k ^DHCRisHL7MessageSentBCi("PatientName",Name,MessageIndex)
    .k ^DHCRisHL7MessageSentBC(MessageIndex)
	else  if MessageType="3"  d
	.s ^DHCRisHL7MessageNJ(MessageIndex)=$g(^DHCRisHL7MessageSentNJ(MessageIndex))
	.s Info=^DHCRisHL7MessageSentNJ(MessageIndex)
	.s PatientInfo=..GetPatientInfo(Info)
	.s PatientID=$p(PatientInfo,$c(1),1)
	.s Name=$p(PatientInfo,$c(1),2)
    .s date=$g(^DHCRisHL7MessageSentNJi("PatientID",PatientID,MessageIndex))
    .s date=$p(date,",",1)
    .k ^DHCRisHL7MessageSentNJi("Date",date,MessageIndex)
    .k ^DHCRisHL7MessageSentNJi("PatientID",PatientID,MessageIndex)
    .k ^DHCRisHL7MessageSentNJi("PatientName",Name,MessageIndex)
	.k ^DHCRisHL7MessageSentNJ(MessageIndex)
	q "Y"
}

ClassMethod GetMessageTypeList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisHL7:QueryMessageType")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

Query QueryMessageType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryMessageTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("1","放射")
 	Set ^CacheTemp(repid,2)=$lb("2","超声")
 	Set ^CacheTemp(repid,3)=$lb("3","内镜")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryMessageTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMessageTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryMessageTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMessageTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Query: QueryOrdInfo
/// 功能： 查询医嘱信息
/// 参数： 医嘱的ROWID  7||8
/// 返回 ：没有发送的消息   格式： 登记号  姓名 生日 性别  医嘱名称  时间   
/// 作者： gongping
/// 日期:  2010-12-14 
/// d ##class(%ResultSet).RunQuery("web.DHCRisHL7","QueryOrdInfo","34||788")
Query QueryOrdInfo(ROWID As %String) As %Query(ROWSPEC = "TPatientID:%String,TName:%String,TDOB:%String,TSex:%String,TOrderName:%String,TTime:%String,PatientType:%String")
{
}

ClassMethod QueryOrdInfoExecute(ByRef qHandle As %Binary, ROWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i ROWID="" Set qHandle=$lb(0,repid,0)
	q:ROWID="" $$$OK
	s OrdRowid=$p(ROWID,"||",1)
	s ChildSub=$p(ROWID,"||",2)
	i ChildSub="" Set qHandle=$lb(0,repid,0)
	q:ChildSub="" $$$OK
	s AdmId=$p(^OEORD(OrdRowid),"^",1)
	q:AdmId="" $$$OK
	s AdmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(AdmId)
	s PatientID=$p(AdmInfo,"^",1)
	s Name=$p(AdmInfo,"^",2)
	s DOB=$p(AdmInfo,"^",3)
	s Sex=$p(AdmInfo,"^",5)
	s PatientType=$p(AdmInfo,"^",7)
	s OrdInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrdRowid, ChildSub)
	s OrdName=$p(OrdInfo,"^",1)
	s strDate=$p(OrdInfo,"^",2)
	Do OutRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow3
    /// 登记号  姓名 生日 性别  医嘱名称  时间   
	set Data=$lb(PatientID,Name,DOB,Sex,OrdName,strDate,PatientType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrdInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrdInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：CreateHL7Message
/// 功能：根据医嘱的ROWID 生成 ADT^A01/ADT^A04 、ORM ^O01 消息
/// 参数 ： 0  成功    1 失败
/// s ret=##class(web.DHCRisHL7).CreateHL7Message(ROWID,1)
ClassMethod CreateHL7Message(ROWID As %String, MessageType) As %String
{
	q:ROWID="" "1"
    s send=..IsAdmitSend(ROWID)
    q:send="1" "1" 
	s ret=..ReSentADTMessage(ROWID,MessageType)
	s ret=..ReSentOrM01Message(ROWID, MessageType,"NW")
	q ret
}

/// 取消执行
/// d ##class(web.DHCRisHL7).CancelRegister("3499581||20")
ClassMethod CancelRegister(ROWID As %String) As %String
{
	s ret=##class(web.DHCRisRegisterPatientDoEx).UnRegister(ROWID,"","","","")
	q ret
}

/// 函数：IsAdmitSend 是否运行发送消息 
/// 对于住院病人没有出院的允许发送
/// 对于门诊病人交费后才允许发送
/// 
ClassMethod IsAdmitSend(ROWID As %String) As %String
{
	s OrderRowid=$p(ROWID,"||",1)
	s ChildSub=$p(ROWID,"||",2)
	s billed=$p(^OEORD(OrderRowid,"I",ChildSub,3),"^",5)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
	s VisitStatus=$p(^PAADM(paadmdr),"^",20)
	q:(patienttype="I")&(VisitStatus="A") "0"
	q:(patienttype="O")&(billed="P") "0"
	q "1"
}

// 函数：DeleteHL7Message 

// 功能： 删除HL7 消息 

// 参数 ：Index 消息序号，HL7MessageType 消息类型 放射

//  

ClassMethod DeleteHL7Message(Index, HL7MessageType = "1") As %String
{
    i Index'="" d
    .i HL7MessageType= "1" d
  	..s Info=^DHCRisHL7MessageSent(Index)
	..s PatientInfo=..GetPatientInfo(Info)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
    ..s date=$g(^DHCRisHL7MessageSenti("PatientID",PatientID,Index))
    ..s date=$p(date,",",1)
    ..k ^DHCRisHL7MessageSenti("Date",date,Index)
    ..k ^DHCRisHL7MessageSenti("PatientID",PatientID,Index)
    ..k ^DHCRisHL7MessageSenti("PatientName",Name,Index)
    ..k ^DHCRisHL7MessageSent(Index)
    
    .e  i HL7MessageType= "2" d
  	..s Info=^DHCRisHL7MessageSentBC(Index)
	..s PatientInfo=..GetPatientInfo(Info)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
    ..s date=$g(^DHCRisHL7MessageSentBCi("PatientID",PatientID,Index))
    ..s date=$p(date,",",1)
    ..k ^DHCRisHL7MessageSentBCi("Date",date,Index)
    ..k ^DHCRisHL7MessageSentBCi("PatientID",PatientID,Index)
    ..k ^DHCRisHL7MessageSentBCi("PatientName",Name,Index)
    ..k ^DHCRisHL7MessageSentBC(Index)
        
    .e  i HL7MessageType= "3" d
  	..s Info=^DHCRisHL7MessageSentNJ(Index)
	..s PatientInfo=..GetPatientInfo(Info)
	..s PatientID=$p(PatientInfo,$c(1),1)
	..s Name=$p(PatientInfo,$c(1),2)
    ..s date=$g(^DHCRisHL7MessageSentNJi("PatientID",PatientID,Index))
    ..s date=$p(date,",",1)
    ..k ^DHCRisHL7MessageSentNJi("Date",date,Index)
    ..k ^DHCRisHL7MessageSentNJi("PatientID",PatientID,Index)
    ..k ^DHCRisHL7MessageSentNJi("PatientName",Name,Index)
    ..k ^DHCRisHL7MessageSentNJ(Index)
    
    q 0
}

}
