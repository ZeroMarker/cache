Class DHCMGNUR.MgNurArgJobChild Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病区
Property WardDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Ward_DR ];

/// 开始日期
Property StartDate As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Start_Date ];

/// 结束日期
Property EndDate As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = End_Date ];

/// 护士工号
Property NurseDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = Nurse_DR ];

/// 显示顺序
Property NurseOrder As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = Nurse_Order ];

/// 工作分配
Property JobAssign As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Job_Assign ];

/// 人员类别
Property NurseType As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Nurse_Type ];

/// 护士层级
Property NurseBty As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Nurse_Bty ];

Index WardDateNur On (WardDR, StartDate, EndDate, NurseDR, NurseType);

Index WardDate On (WardDR, StartDate, EndDate);

ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s WardDR=$P(parr,"^",1)
	s StartDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s NurseDR=$ZConvert($P(parr,"^",4),"U")
	s JobAssign=$P(parr,"^",5)
	s NurseOrder=$P(parr,"^",6)
	s NurseType=$P(parr,"^",7)
	s ID=$O(^DHCMGNUR.MgNurArgJobChildI("WardDateNur"," "_WardDR," "_StartDate," "_EndDate," "_NurseDR," "_NurseType,""))
	i ID'=""
	{
		s object=##class(DHCMGNUR.MgNurArgJobChild).%OpenId(ID)
	}
	else
	{
		s object=##class(DHCMGNUR.MgNurArgJobChild).%New()
		s object.WardDR=WardDR
		s object.StartDate=StartDate
		s object.EndDate=EndDate
		s object.NurseDR=NurseDR
		s object.NurseType=NurseType
	}
	s object.JobAssign=JobAssign
	s object.NurseOrder=NurseOrder
	TStart
	s sc=object.%Save()
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

ClassMethod getVal(ID As %String) As %String
{
	q:ID=""
	s a=##class(DHCMGNUR.MgNurArgJobChild).%OpenId(ID)
	s ret="WardDR|"_a.WardDR
	s ret=ret_"^StartDate|"_$zd(a.StartDate,3)
	s ret=ret_"^EndDate|"_$zd(a.EndDate,3)
	s ret=ret_"^NurseDR|"_a.NurseDR
	s ret=ret_"^NurseOrder"_a.NurseOrder
	s ret=ret_"^JobAssign|"_a.JobAssign
	s ret=ret_"^NurseType|"_a.NurseType
	s ret=ret_"^ID|"_ID
	q ret
}

ClassMethod getValue(parr As %String) As %String
{
	;w ##class(DHCMGNUR.MgNurArgJobChild).getValue("1018^2014-03-31^2014-04-06^9151")
	q:parr="" ""
	s WardDR=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s NurseDR=$$ALPHAUP^SSUTIL4($P(parr,"^",4))
	s NurseType=$P(parr,"^",5)
	s ID=$O(^DHCMGNUR.MgNurArgJobChildI("WardDateNur"," "_WardDR," "_StDate," "_EndDate," "_NurseDR," "_NurseType,""))
	q:ID="" ""
	s ret=..getVal(ID)
	q ret
}

ClassMethod getDeptNurse(parr, tmp)
{
	; d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse("76^2015-08-10^2015-08-16",.tmp)
	q:parr=""
	s WardId=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s max=0
	s NurArray=""
	s tmp="" k tmp
	s ajStatus="N"
	s ajID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardId," "_StDate," "_EndDate,""))
	i ajID'="" d
	.s ajObj=##class(DHCMGNUR.MgNurArgJob).%OpenId(ajID)
	.s ajStatus=ajObj.Status
	i (ajStatus="Y")!(ajStatus="S") d
	.s ID="" f  s ID=$O(^DHCMGNUR.MgNurArgJobChildI("WardDate"," "_WardId," "_StDate," "_EndDate,ID)) q:ID=""  d
	..s a=##class(DHCMGNUR.MgNurArgJobChild).%OpenId(ID)
	..;s NurseID=$ZConvert(a.NurseDR,"U")
	..s NurseID=a.NurseDR
	..s type=$O(^DHCMGNUR.MgNurArgJobChildI("WardDateNur"," "_WardId," "_StDate," "_EndDate," "_NurseID,""))
	..q:type=""
	..s NurseOrder= a.NurseOrder
	..s NurseType=a.NurseType
	..s max=##class(web.DHCNurArgJobNurInfo).FindMax(max,NurseOrder)
	..s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(NurseID,"U"),""))
	..s mp=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	..s NurseName=mp.PersonName
	..s NurseBty=mp.PersonBattery
	..i mp.PersonheadshipDR'="" s NurseHeadShip=mp.PersonheadshipDR.CodeDesc
	..e  s NurseHeadShip=""
	..i (NurseBty'="") s PerBtyCode=NurseBty.Code  ;&(NurseHeadShip'="护士长")
	..else  s PerBtyCode=""
	..s tmp(NurseOrder)="PersonID|"_NurseID_"^PersonName|"_NurseName_"^PersonType|"_NurseType_"^PersonBty|"_PerBtyCode_"^PersonOrder|"_NurseOrder
	..s NurArray(NurseID)=tmp(NurseOrder)
	else  d
	.s ID="" f  s ID=$O(^DHCMGNUR.MgNurArgJobNurInfoI("Ward"," "_WardId,ID)) q:ID=""  d
	..s obj=##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID)
	..s NurseID=$ZConvert(obj.NurseID,"U")
	..s mgperdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(NurseID,"U"),""))
	..q:mgperdr=""
	..s mgperobj=##class(DHCMGNUR.MgPersons).%OpenId(mgperdr)
	..s NurseType=obj.NurseType
	..q:$d(NurArray(NurseID))'=0
	..s:NurseType="N" flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(NurseID_"^"_parr)
	..s:NurseType'="N" flag= ##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(NurseID_"^"_parr)
	..q:flag=0
	..s NurseName=obj.NurseName
	..i mgperobj.PersonheadshipDR'="" s NurseHeadShip=mgperobj.PersonheadshipDR.CodeDesc
	..e  s NurseHeadShip=""
	..s NurseBtyId=mgperobj.PersonBattery
	..i (NurseBtyId'="") s NurseBty=NurseBtyId.Code ;&($g(NurseHeadShip)'="护士长")
	..e  s NurseBty=""
	..s NurseOrder=obj.NurseOrder
	..s max=##class(web.DHCNurArgJobNurInfo).FindMax(max,NurseOrder)
	..s tmp(NurseOrder)="PersonID|"_NurseID_"^PersonName|"_NurseName_"^PersonType|"_NurseType_"^PersonBty|"_NurseBty_"^PersonOrder|"_NurseOrder
	..s NurArray(NurseID)=tmp(NurseOrder)
	.s nOrder=max+1
	.s NurArray2="",temp=""
	.d ##class(web.DHCNurArgJobNurInfo).getDeptNurse(parr,.NurArray2)
	.s perid="" f  s perid=$O(NurArray2(perid)) q:perid=""  d
	..q:$d(NurArray(perid))'=0
	..s tmp(nOrder)=NurArray2(perid)_nOrder
	..s nOrder=nOrder+1
	q 0
}

/// w ##class(DHCMGNUR.MgNurArgJobChild).getLastWeekAssign("351^2014-12-22^2014-12-28^MPS")
ClassMethod getLastWeekAssign(parr As %String) As %String
{
	q:parr=""
	s ret=""
	s WardId=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s GridType=$P(parr,"^",4)
	s tmp="",PerArray=""
	d ..getDeptNurse(parr,.tmp)
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.s ID=$O(^DHCMGNUR.MgNurArgJobChildI("WardDateNur"," "_WardId," "_(StDate-7)," "_(EndDate-7)," "_PerArray("PersonID")," "_PerArray("PersonType"),""))
	.i ID="" d  
	..s ret=ret_"^"
	.e  d
	..s a=##class(DHCMGNUR.MgNurArgJobChild).%OpenId(ID) 
	..s ret=ret_a.JobAssign_"^"
	q ret
}

/// d ##class(DHCMGNUR.MgNurArgJobChild).CheckPerson("76^2015-08-10^2015-08-16")
ClassMethod CheckPerson(parr As %String) As %String
{
	q:parr="" 0
	s wardid=$P(parr,"^",1)
	s stdate=$zdh($P(parr,"^",2),3)
	s enddate=$zdh($P(parr,"^",3),3)
	s ajid="" f  s ajid=$O(^DHCMGNUR.MgNurArgJobChildI("WardDate"," "_wardid," "_stdate," "_enddate,ajid)) q:ajid=""  d
	.s ajobj=##class(DHCMGNUR.MgNurArgJobChild).%OpenId(ajid)
	.s perid=ajobj.NurseDR
	.s pertyp=ajobj.NurseType
	.s type=$O(^DHCMGNUR.MgNurArgJobChildI("WardDateNur"," "_wardid," "_stdate," "_enddate," "_perid,""))
	.q:type=""
	.;i perid="SX20150029" b ;00
	.i pertyp="N" s flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(perid_"^"_parr)
	.e  s flag=##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(perid_"^"_parr)
	.q:flag=1
	.;b ;01
	.d ajobj.%DeleteId(ajid)
	q 1
}

Storage Default
{
<Data name="MgNurArgJobChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>NurseDR</Value>
</Value>
<Value name="6">
<Value>NurseName</Value>
</Value>
<Value name="7">
<Value>NurseOrder</Value>
</Value>
<Value name="8">
<Value>JobAssign</Value>
</Value>
<Value name="9">
<Value>NurseBty</Value>
</Value>
<Value name="10">
<Value>NurseType</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArgJobChildD</DataLocation>
<DefaultData>MgNurArgJobChildDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArgJobChildD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArgJobChildI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArgJobChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
