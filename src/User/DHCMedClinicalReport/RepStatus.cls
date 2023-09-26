Class User.DHCMedClinicalReport.RepStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock, StorageStrategy = Default ]
{

Relationship Parref As User.DHCMedClinicalReport.Report [ Cardinality = parent, Inverse = Supervisor ];

Property RepStatus As %String(TRUNCATE = 1) [ Required ];

Property UserID As %String(TRUNCATE = 1) [ Required ];

Property UpdateDate As %Library.Date;

Property UpdateTime As %Library.Time;

Property Resume As %String(TRUNCATE = 1);

ClassMethod Update(Instring) As %String
{
	//new (PrjString)  //error 1||1
	//w ##class(User.DHCMedClinicalReport.RepStatus).Update("1^^Code^Desc^Condition^ConType^resNew")
	set Parref=$p(Instring,"^",1)
	set ChildSub=$p(Instring,"^",2)
	set RepStatus=$p(Instring,"^",3)
	set UserID=$p(Instring,"^",4)
	set UpdateDate=$p(Instring,"^",5)
	set:(UpdateDate'="")&(UpdateDate["-") UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate="" UpdateDate=+$h
	set UpdateTime=$p(Instring,"^",6)
	set:(UpdateTime'="")&(UpdateTime[":") UpdateTime=$zth(UpdateTime)
	set:UpdateTime="" UpdateTime=$p($h,",",2)
	set Resume=$p(Instring,"^",7)
	
	set id=Parref_"||"_ChildSub
	set:ChildSub="" obj=##class(User.DHCMedClinicalReport.RepStatus).%New()
	set:ChildSub'="" obj=##class(User.DHCMedClinicalReport.RepStatus).%OpenId(id)
	set Parent = ##class(User.DHCMedClinicalReport.Report).%OpenId(Parref)
	set:ChildSub="" obj.Parref= Parent
	set obj.RepStatus = RepStatus
    set obj.UserID = UserID
    set obj.UpdateDate= UpdateDate
    set obj.UpdateTime= UpdateTime
    set obj.Resume=Resume
	set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
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
	s Parref=$p(RowId,"||",1)
	s ChildSub=$p(RowId,"||",2)
	q:(Parref="")||(ChildSub="") ret
	q:'$d(^DHCMClin.RepStatusD(Parref,ChildSub)) ret
	s ret=$g(^DHCMClin.RepStatusD(Parref,ChildSub))
	
	s:$li(ret,4)'="" $li(ret,4)=$zd($li(ret,4),3)
	s:$li(ret,5)'="" $li(ret,5)=$zt($li(ret,5))
	s ret=$li(ret,2)_"^"_$li(ret,3)_"^"_$li(ret,4)_"^"_$li(ret,5)_"^"_$li(ret,6)
	q ret
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
<DataLocation>^DHCMClin.RepStatusD</DataLocation>
<DefaultData>RepStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildPointer")</IdLocation>
<IndexLocation>^DHCMClin.RepStatusI</IndexLocation>
<StreamLocation>^User.DHC.RepStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
