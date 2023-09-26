Class DHCMed.CR.Report Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Property InstanceID As %String(TRUNCATE = 1) [ Required ];

Property ProjectID As %String(TRUNCATE = 1) [ Required ];

Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

Property RepStatus As %String(DISPLAYLIST = ",待审,已审,退回,删除", TRUNCATE = 1, VALUELIST = ",D,Y,R,S") [ Required ];

//Property Active As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N");

Property RepDoc As %String(TRUNCATE = 1) [ Required ];

Property RepCtloc As %String(TRUNCATE = 1);

Property RepDate As %Library.Date;

Property RepTime As %Library.Time;

Property CheckUser As %String(TRUNCATE = 1);

Property CheckDate As %Library.Date;

Property CheckTime As %Library.Time;

Property ReturnRes As %String(TRUNCATE = 1);

Property Text1 As %String(TRUNCATE = 1);

Property Text2 As %String(TRUNCATE = 1);

Property Resume As %String(TRUNCATE = 1);

Relationship Supervisor As DHCMed.CR.RepStatus [ Cardinality = children, Inverse = Parref ];

Index DateLoc On (RepDate As Exact, RepCtloc As SqlString);

Index InstanceID On InstanceID As SqlString;

Index EpisodeID On EpisodeID As SqlString;

Index IndexProjectIDInstanceID On (ProjectID As SqlString, InstanceID As SqlString);

Index IndexProjectID On ProjectID As SqlString;

ClassMethod Update(InString) As %String
{
	//new (PrjString)  //error
	//w ##class(DHCMed.CR.Report).Update("1^P0001^EditDesc^T0001^Yes^")
	set RowId=$p(InString,"^",1)
	set InstanceID=$p(InString,"^",2)
	set ProjectID=$p(InString,"^",3)
	set EpisodeID=$p(InString,"^",4)
	set RepStatus=$p(InString,"^",5)
	set RepDoc=$p(InString,"^",6)	
	set RepDate=$p(InString,"^",7)
	set:(RepDate'="")&(RepDate["-") RepDate=$zdh(RepDate,3)
	set:RepDate="" RepDate=+$h
	set RepTime=$p(InString,"^",8)
	set:(RepTime'="")&(RepTime[":") RepTime=$zth(RepTime)
	set:RepTime="" RepTime=$p($h,",",2)
	set CheckUser=$p(InString,"^",9)
	set CheckDate=$p(InString,"^",10)
	set:CheckDate'="" CheckDate=$zdh(CheckDate,3)
	//set:CheckDate="" CheckDate=+$h
	set CheckTime=$p(InString,"^",11)
	set:CheckTime'="" CheckTime=$zth(CheckTime)
	//set:CheckTime="" CheckTime=$p($h,",",2)
	set ReturnRes=$p(InString,"^",12)
	set Text1=$p(InString,"^",13)
	set Text2=$p(InString,"^",14)
	set Resume=$p(InString,"^",15)
	set RepCtloc=$p(InString,"^",16)
	
	set:RowId="" obj=##class(DHCMed.CR.Report).%New()
	set:RowId'="" obj=##class(DHCMed.CR.Report).%OpenId(+RowId)
	set obj.InstanceID = InstanceID
    set obj.ProjectID = ProjectID
    set obj.EpisodeID=EpisodeID
    set obj.RepStatus=RepStatus
    set obj.RepDoc = RepDoc
    set obj.RepDate = RepDate
    set obj.RepTime=RepTime
    set obj.CheckUser=CheckUser
    set obj.CheckDate = CheckDate
    set obj.CheckTime = CheckTime
    set obj.ReturnRes=ReturnRes
    set obj.Text1=Text1
    set obj.Text2 = Text2
    set obj.Resume=Resume
    set obj.RepCtloc=RepCtloc
	set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	} else {
		s id=obj.%Id()
	}
	d obj.%Close()
	q id
}

ClassMethod GetById(RowId As %String) As %String
{
	//n (RowId)
	s ret=""
	q:RowId="" ret
	q:'$d(^DHCMed.CR.ReportD(RowId)) ret
	s str=$g(^DHCMed.CR.ReportD(RowId))
	s ret=RowId_"^"_$li(str,2)_"^"_$li(str,3)_"^"_$li(str,4)_"^"_$li(str,5)_"^"_$li(str,6)
	s repDate=$li(str,7)
	s:repDate'="" repDate=$zd(repDate,3)
	s repTime=$li(str,8)
	s:repTime'="" repTime=$zt(repTime)
	s chkDate=$li(str,10)
	s:chkDate'="" chkDate=$zd(chkDate,3)
	s chkTime=$li(str,11)
	s:chkTime'="" chkTime=$zt(chkTime)
	s ret=ret_"^"_repDate_"^"_repTime_"^"_$li(str,9)_"^"_chkDate_"^"_chkTime_"^"_$li(str,12)_"^"_$li(str,13)_"^"_$li(str,14)_"^"_$li(str,15)_"^"_$li(str,16)
	q ret
}

Storage Default
{
<Data name="ReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>ProjectID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>RepStatus</Value>
</Value>
<Value name="6">
<Value>RepDoc</Value>
</Value>
<Value name="7">
<Value>RepDate</Value>
</Value>
<Value name="8">
<Value>RepTime</Value>
</Value>
<Value name="9">
<Value>CheckUser</Value>
</Value>
<Value name="10">
<Value>CheckDate</Value>
</Value>
<Value name="11">
<Value>CheckTime</Value>
</Value>
<Value name="12">
<Value>ReturnRes</Value>
</Value>
<Value name="13">
<Value>Text1</Value>
</Value>
<Value name="14">
<Value>Text2</Value>
</Value>
<Value name="15">
<Value>Resume</Value>
</Value>
<Value name="16">
<Value>RepCtloc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.ReportD</DataLocation>
<DefaultData>ReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.ReportD</IdLocation>
<IndexLocation>^DHCMed.CR.ReportI</IndexLocation>
<StreamLocation>^DHCMed.CR.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
