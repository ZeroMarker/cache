Class DHCMed.CR.RepStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.CR.Report [ Cardinality = parent, Inverse = Supervisor ];

Property RepStatus As %String(TRUNCATE = 1) [ Required ];

Property UserID As %String(TRUNCATE = 1) [ Required ];

Property UpdateDate As %Library.Date;

Property UpdateTime As %Library.Time;

Property Resume As %String(TRUNCATE = 1);

ClassMethod Update(Instring As %String) As %String
{
	New (Instring)
	Set return=-1
	
	Set Parref=$p(Instring,"^",1)
	Set ChildSub=$p(Instring,"^",2)
	Set RepStatus=$p(Instring,"^",3)
	Set UserID=+$p(Instring,"^",4)
	Set UpdateDate=$p(Instring,"^",5)
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set:UpdateDate'="" UpdateDate=+UpdateDate
	Set:UpdateDate="" UpdateDate=+$h
	Set UpdateTime=$p(Instring,"^",6)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set:UpdateTime'="" UpdateTime=+UpdateTime
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Set Resume=$p(Instring,"^",7)
	
	Set ID=Parref_"||"_ChildSub
	If ChildSub="" {
		Set objStatus=##class(DHCMed.CR.RepStatus).%New()
	} Else {
		Set objStatus=##class(DHCMed.CR.RepStatus).%OpenId(ID)
	}
	Set objParent=##Class(DHCMed.CR.Report).%OpenId(Parref)
	If objParent'="" Do objParent.%Close()
	Set objStatus.Parref=objParent
	Set objStatus.RepStatus=RepStatus
    Set objStatus.UserID=UserID
    Set objStatus.UpdateDate=UpdateDate
    Set objStatus.UpdateTime=UpdateTime
    Set objStatus.Resume=Resume
	Set sc=objStatus.%Save()
	If ($$$ISERR(sc)) {
		Do $System.Status.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=objStatus.%Id()
	}
	If objStatus'="" Do objStatus.%Close()
	
	Quit return
}

ClassMethod GetById(RowId As %String) As %String
{
	New (RowId)
	Set return=""
	
	Set Parref=$p(RowId,"||",1)
	Set ChildSub=$p(RowId,"||",2)
	Quit:(Parref="")||(ChildSub="") return
	Quit:'$d(^DHCMed.CR.RepStatusD(Parref,ChildSub)) return
	Set ret=$g(^DHCMed.CR.RepStatusD(Parref,ChildSub))
	
	Set:$li(ret,4)'="" $li(ret,4)=$zd($li(ret,4),3)
	Set:$li(ret,5)'="" $li(ret,5)=$zt($li(ret,5))
	Set ret=$li(ret,2)_"^"_$li(ret,3)_"^"_$li(ret,4)_"^"_$li(ret,5)_"^"_$li(ret,6)
	Quit return
}

Storage Default
{
<Data name="RepStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RepStatus</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>UpdateTime</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.RepStatusD</DataLocation>
<DefaultData>RepStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildPointer")</IdLocation>
<IndexLocation>^DHCMed.CR.RepStatusI</IndexLocation>
<StreamLocation>^DHCMed.CR.RepStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
