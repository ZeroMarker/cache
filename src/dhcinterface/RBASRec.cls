Class dhcinterface.RBASRec Extends (%Persistent, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property Dept As %String(TRUNCATE = 1);

Property DeptId As %String(TRUNCATE = 1);

Property DoctorId As %String(TRUNCATE = 1);

Property DoctorIntro As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

Property DoctorTitle As %String(TRUNCATE = 1);

Property RBASDate As %String(TRUNCATE = 1);

Property RBASId As %String(TRUNCATE = 1);

Property RBASPrice As %String(TRUNCATE = 1);

Property RBASSessionCode As %String(TRUNCATE = 1);

Property RBASSessionLoad As %String(TRUNCATE = 1);

Property RBASSessionType As %String(TRUNCATE = 1);

Property RBASSessionTypeId As %String(TRUNCATE = 1);

Property Subject As %String(TRUNCATE = 1);

Property SubjectId As %String(TRUNCATE = 1);

ClassMethod GetAppQty(ASQRowId) As %String
{
	s AppQty=0
	s ResRowId=+ASQRowId
	s ASChild=$P(ASQRowId,"||",2)
	s Child=0  f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:(Child="")||(AppQty>0)  d
	.s ASQMethodDR=$P(^RBAS(ResRowId,ASChild,"AQ",Child),"^",1)
	.s ASQQty=$P(^RBAS(ResRowId,ASChild,"AQ",Child),"^",2)
	.s MethodCode=$P(^RBC("APTM",ASQMethodDR),"^",1)
	.;114预约类型代码
	.i MethodCode="TEL" s AppQty=ASQQty
	.Q:AppQty>0
	Q AppQty
}

ClassMethod GetByID(RBASId As %String) As RBASRec
{
	//w ##class(dhcinterface.RBASRec).GetByID("1201||1")
	n (RBASId)
	s RBASSessionLoad=..GetAppQty(RBASId)
	i RBASSessionLoad'=0 d
	.w "A",RBASSessionLoad_RBASId,!
	e  d
	.w "B",RBASSessionLoad_RBASId,!
	s ResRowId=$P(RBASId,"||",1)
	s ASChildSub=$P(RBASId,"||",2)
	
	s ASDate=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	If ASDate'="" Set ASDate=$ZD(ASDate,3)
	s ASSessStartTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",4)
	s RBASSessionCode=..GetSessionCode(ASSessStartTime)
	s DeptId=$p(^RB("RES",ResRowId),"^",1)
	s Dept=$P(^CTLOC(DeptId),"^",2)
	S DoctorId=$p(^RB("RES",ResRowId),"^",2)
	if DoctorId="" d
	.s RBASObject=##class(dhcinterface.RBASRec).%New()
	.s RBASObject.RBASSessionLoad=0
	q:$g(DoctorId)="" RBASObject
	s DoctorName=$p(^CTPCP(DoctorId,1),"^",2)
	s DoctorTypeRowId=$p(^CTPCP(DoctorId,1),"^",4)
	s DoctorTitle=$P($G(^CT("CPT",DoctorTypeRowId)),"^",2)
	s SubjectId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
	s Subject=""
	i (SubjectId'="")&&($D(^RBC("CLGRP",SubjectId))) s Subject=$P(^RBC("CLGRP",SubjectId),"^",2)
	;医生介绍
	s DoctorIntro=""
	s ASRBEffDateSessionDR=$P($G(^RBAS(ResRowId,ASChildSub)),"^",12)
	;取价格
	;s RBASPrice=##Class(web.DHCRBResSession).GetSessPrice(ASRBEffDateSessionDR,DoctorId)
	s RBASPrice=##class(web.DHCOPAdmReg).GetScheduleFee(RBASId,"",+$H,"||||||1")
	s RBASSessionTypeId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	s RBASSessionType=""
	i RBASSessionTypeId'="" s RBASSessionType=$P(^RBC("SESS",RBASSessionTypeId),"^",2)
	s HospitalId=""
	s RBASObject=##class(dhcinterface.RBASRec).%New()
	s RBASObject.RBASId=RBASId
	s RBASObject.RBASDate=ASDate
	s RBASObject.RBASSessionCode=RBASSessionCode
	s RBASObject.DoctorId=DoctorId
	s RBASObject.DoctorName=DoctorName
	s RBASObject.DoctorTitle=DoctorTitle
	s RBASObject.DeptId=DeptId
	s RBASObject.Dept=Dept
	s RBASObject.SubjectId=SubjectId
	s RBASObject.Subject=Subject
	s RBASObject.DoctorIntro=DoctorIntro
	s RBASObject.RBASPrice=RBASPrice 
	s RBASObject.RBASSessionTypeId=RBASSessionTypeId
	s RBASObject.RBASSessionType=RBASSessionType
	s RBASObject.RBASSessionLoad=RBASSessionLoad
    ;w RBASSessionLoad,!
	Quit RBASObject
}

ClassMethod GetSessionCode(SessionStartTime As %String) As %String
{
	s FindCode=""
	s RowId=0  f  s RowId=$O(^DHCTimeRange(RowId)) Q:(RowId="")||(FindCode'="")  d
	.s TimeStart=$P(^DHCTimeRange(RowId),"^",3)
	.s TimeEnd=$P(^DHCTimeRange(RowId),"^",4)
	.i ((SessionStartTime>TimeStart)||(SessionStartTime=TimeStart))&&(SessionStartTime<TimeEnd) s FindCode=$P(^DHCTimeRange(RowId),"^",2)
	.Q:FindCode'=""
	Quit FindCode
}

}
