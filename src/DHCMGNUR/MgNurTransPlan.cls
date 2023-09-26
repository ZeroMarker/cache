/// 轮转计划记录
Class DHCMGNUR.MgNurTransPlan Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 护士工号 MgPersons PersonID
Property PlanNurseID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Plan_Nurse_ID ];

/// 拟调科室 CTLoc ID
Property PlanNextWard As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Plan_Next_Ward ];

/// 开始日期
Property PlanStDate As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = Plan_St_Date ];

/// 结束日期
Property PlanEndDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Plan_End_Date ];

/// 备注
Property PlanRemarks As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Plan_Remarks ];

/// 有效位 Y:有效 N:无效
Property PlanValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Plan_Valid ];

/// 执行状态 Y:已执行 N:未执行
Property PlanStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Plan_Status ];

/// 当前MgNurTransDep ID
Property PlanNTransID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Plan_NTrans_ID ];

/// 上一条MgNurTransDep ID
Property PlanLTransID As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = Plan_LTrans_ID ];

/// 创建日期
Property PlanCrtDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Plan_Crt_Date ];

/// 创建时间
Property PlanCrtTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Plan_Crt_Time ];

/// 创建人
Property PlanCrtPerson As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Plan_Crt_Person ];

Index Nurse On PlanNurseID;

Index Date On PlanStDate;

Index Status On PlanStatus;

Index Valid On PlanStatus;

ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s tmp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	s a=##class(DHCMGNUR.MgNurTransPlan).%New()
	i $d(tmp("PlanNurseID"))'=0 s a.PlanNurseID=tmp("PlanNurseID")
	i $d(tmp("PlanNextWard"))'=0 s a.PlanNextWard=tmp("PlanNextWard")
	i $d(tmp("PlanStDate"))'=0 s a.PlanStDate=$zdh(tmp("PlanStDate"),3)
	i $d(tmp("PlanEndDate"))'=0 s a.PlanEndDate=$zdh(tmp("PlanEndDate"),3)
	i $d(tmp("PlanRemarks"))'=0 s a.PlanRemarks=tmp("PlanRemarks")
	s a.PlanValid="Y"
	s a.PlanStatus="N"
	s a.PlanNTransID=""
	s a.PlanLTransID=""
	s a.PlanCrtDate=+$h
	s a.PlanCrtTime=$P($h,",",2)
	i $d(tmp("PlanCrtPerson"))'=0 s a.PlanCrtPerson=tmp("PlanCrtPerson")
	TStart
	s sc=a.%Save()
	i $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "ERROR"
	}
	else
	{
		TCommit
		q "OK"
	}
}

/// w ##class(DHCMGNUR.MgNurTransPlan).getVal(1)
ClassMethod getVal(ID As %String) As %String
{
	q:ID=""
	s ret=""
	s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(ID)
	i a.PlanNurseID'="" s ret="PlanNurseID|"_a.PlanNurseID
	s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_a.PlanNurseID,""))
	i MgPerID'="" d
	.s mp=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	.s ret=ret_"^"_"PersonName|"_mp.PersonName
	.i mp.PersonWorkDateTime'="" d 
	..s ret=ret_"^"_"WorkStDate|"_$zd(mp.PersonWorkDateTime,3)
	.else  s ret=ret_"^"_"WorkStDate|"
	.s NowStayLoc=##class(web.DHCNurTransPlan).getPersonInfo(a.PlanNurseID)
	.s ret=ret_"^"_NowStayLoc
	else  s ret=ret_"^"_"PersonName|"
	s ret=ret_"^"_"PlanNextWard|"_a.PlanNextWard
	i a.PlanNextWard'="" s ret=ret_"^"_"WardCode|"_$P(^CTLOC(a.PlanNextWard),"^",1)
	else  s ret=ret_"^"_"WardCode|"
	s ret=ret_"^"_"PlanStDate|" i a.PlanStDate'="" s ret=ret_$zd(a.PlanStDate,3)
	s ret=ret_"^"_"PlanEndDate|" i a.PlanEndDate'="" s ret=ret_$zd(a.PlanEndDate,3)
	s ret=ret_"^"_"PlanRemarks|"_$Tr(a.PlanRemarks,$C(10,13))
	s ret=ret_"^"_"PlanValid|"_a.PlanValid
	s ret=ret_"^"_"PlanStatus|"_a.PlanStatus
	s ret=ret_"^"_"PlanNTransID|"_a.PlanNTransID
	s ret=ret_"^"_"PlanLTransID|"_a.PlanLTransID
	s ret=ret_"^"_"PlanCrtDate|"_$zd(a.PlanCrtDate,3)
	s ret=ret_"^"_"PlanCrtTime|"_$zt(a.PlanCrtTime,1)
	i a.PlanCrtPerson'="" d
	.s ret=ret_"^"_"PlanCrtPerson|"_a.PlanCrtPerson
	.s CrtMgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(a.PlanCrtPerson,"U"),""))
	.b ;01
	.i CrtMgPerID'="" d
	..s cmp=##class(DHCMGNUR.MgPersons).%OpenId(CrtMgPerID)
	..s ret=ret_"^"_"CrtPersonName|"_cmp.PersonName
	.else  s ret=ret_"^"_"CrtPersonName|"
	else  s ret=ret_"^"_"CrtPersonName|"
	s ret=ret_"^"_"ID|"_ID
	q ret
}

ClassMethod CheckRepeatTime(parr As %String) As %String
{
	q:parr="" 0
	s tmp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	s NurseID=tmp("PlanNurseID")
	s StDate=$zdh(tmp("PlanStDate"),3)
	s EndDate=$zdh(tmp("PlanEndDate"),3)
	s flag=0
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurTransPlanI("Nurse"," "_NurseID,ID)) q:ID=""  d
	.s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(ID)
	.s PlanStDate=a.PlanStDate
	.s PlanEndDate=a.PlanEndDate
	.q:(EndDate<PlanStDate)||(StDate<PlanEndDate)
	.s flag=1
	q flag
}

ClassMethod Update(parr As %String) As %String
{
	q:parr=""
	s tmp="" 
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	i $d(tmp("ID"))'=0 d
	.s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(tmp("ID"))
	.s a.PlanNextWard=tmp("PlanNextWard")
	.s a.PlanStDate=$zdh(tmp("PlanStDate"),3)
	.s a.PlanRemarks=tmp("PlanRemarks")
	.d a.%Save()
	q
}

/// d ##class(DHCMGNUR.MgNurTransPlan).SetMarks("S!2^3^4")
ClassMethod SetMarks(parr As %String) As %String
{
	q:parr=""
	s mark=$P(parr,"!",1)
	s ids=$P(parr,"!",2)
	s l=$L(ids,"^")
	f i=1:1:l d
	.s id=$P(ids,"^",i)
	.i id'="" d
	..s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(id)
	..i mark="V" s a.PlanValid="N" d a.%Save()
	..i mark="CV" s a.PlanValid="Y" d a.%Save()
	..i mark="S" d ..DoTransPlan(id)
	..i mark="CS" d ..UnDoTransPlan(id)
}

ClassMethod DoTransPlan(ID As %String) As %String
{
	q:ID=""
	s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(ID)
	s PlanNurseID=a.PlanNurseID
	s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_PlanNurseID,""))
	s MgPerObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	s PlanNextWard=a.PlanNextWard
	s PlanStDate=a.PlanStDate
	s a.PlanStatus="Y"
	s TransDepID=$O(^DHCMGNUR.MgNurTransDepI("Current"," Y"," "_PlanNurseID,""))
	i TransDepID'="" d
	.s b=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransDepID)
	.s b.PerTranEndDate=PlanStDate-1
	.s b.PerTranCurrent="N"
	.d b.%Save()
	.s a.PlanLTransID=TransDepID
	s c=##class(DHCMGNUR.MgNurTransDep).%New()
	s c.PerDr=MgPerObj
  	s c.PerDepart=PlanNextWard
   	s c.PerID=PlanNurseID
   	s c.PerName=MgPerObj.PersonName
   	s c.PerTranStDate=PlanStDate
   	s c.PerTranStTime=0
   	s c.PerTranCurrent="Y"
   	s c.PerTranMem=""
   	s c.PerFlag=1
   	d c.%Save()
   	s a.PlanNTransID=c.%Id()
   	d a.%Save()
   	q 0
}

ClassMethod UnDoTransPlan(ID As %String) As %String
{
	q:ID=""
	s a=##class(DHCMGNUR.MgNurTransPlan).%OpenId(ID)
	s PlanNTransID=a.PlanNTransID
	s PlanLTransID=a.PlanLTransID
	s a.PlanStatus="N"
	i PlanNTransID'="" d
	.s b=##class(DHCMGNUR.MgNurTransDep).%OpenId(PlanNTransID)
	.d b.%DeleteId(PlanNTransID)
	i PlanLTransID'="" d
	.s c=##class(DHCMGNUR.MgNurTransDep).%OpenId(PlanLTransID)
	.s c.PerTranEndDate=""
	.s c.PerTranCurrent="Y"
	.d c.%Save()
	s a.PlanNTransID=""
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="MgNurTransPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanCrtDate</Value>
</Value>
<Value name="3">
<Value>PlanCrtPerson</Value>
</Value>
<Value name="4">
<Value>PlanCrtTime</Value>
</Value>
<Value name="5">
<Value>PlanEndDate</Value>
</Value>
<Value name="6">
<Value>PlanLTransID</Value>
</Value>
<Value name="7">
<Value>PlanNTransID</Value>
</Value>
<Value name="8">
<Value>PlanNextWard</Value>
</Value>
<Value name="9">
<Value>PlanNurseID</Value>
</Value>
<Value name="10">
<Value>PlanRemarks</Value>
</Value>
<Value name="11">
<Value>PlanStDate</Value>
</Value>
<Value name="12">
<Value>PlanStatus</Value>
</Value>
<Value name="13">
<Value>PlanValid</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurTransPlanD</DataLocation>
<DefaultData>MgNurTransPlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurTransPlanD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurTransPlanI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurTransPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
