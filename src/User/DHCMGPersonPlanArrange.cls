Class User.DHCMGPersonPlanArrange Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_PersonPlanArrange ]
{

Property ARRPerDR As %String(TRUNCATE = 1);

Property ARRPostDR As %String(TRUNCATE = 1);

Property ARRDate As %Library.Date(FORMAT = 1);

Property ARRRecordUser As %String(TRUNCATE = 1);

Property ARRRecDate As %Library.Date(FORMAT = 1);

Property ARRRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property ARRMem As %String(TRUNCATE = 1);

Property ARRDepDR As %String(TRUNCATE = 1);

Property ARRRelayDR As %String(TRUNCATE = 1);

Property AuditDr As User.DHCMGAuditArrange;

//

Index Loc On ARRDepDR;

Index PersonDate On (ARRPerDR, ARRDate);

Index DepDate On (ARRDepDR, ARRDate);

Index DatePost On (ARRDate, ARRPostDR);

Index Date On ARRDate;

Index Audit On AuditDr;

ClassMethod ptarrange(parr As %String) As %String
{
   s post=$P(parr,"^",1)
   s person=$P(parr,"^",2)
   if person="" q 0
   s arrdate=$P(parr,"^",3)
   s dep=$P(parr,"^",4)
   s user=$P(parr,"^",5)
   s id=$P(parr,"^",6)
   s arr=##class(User.DHCMGPersonPlanArrange).%New()
   s arr.ARRPostDR=post
   s arr.ARRPerDR=person
   s arr.ARRDate=arrdate
   s arr.ARRDepDR=dep
   s arr.ARRRecDate=+$H
   s arr.ARRRecTime=$P($H,",",2)
   s arr.ARRRecordUser=user
   d arr.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGPersonPlanArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARRDate</Value>
</Value>
<Value name="3">
<Value>ARRDepDR</Value>
</Value>
<Value name="4">
<Value>ARRMem</Value>
</Value>
<Value name="5">
<Value>ARRPerDR</Value>
</Value>
<Value name="6">
<Value>ARRPostDR</Value>
</Value>
<Value name="7">
<Value>ARRRecDate</Value>
</Value>
<Value name="8">
<Value>ARRRecTime</Value>
</Value>
<Value name="9">
<Value>ARRRecordUser</Value>
</Value>
<Value name="10">
<Value>ARRRelayDR</Value>
</Value>
<Value name="11">
<Value>AuditDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonPlanArrangeD</DataLocation>
<DefaultData>DHCMGPersonPlanArrangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonPlanArrangeD</IdLocation>
<IndexLocation>^User.DHCMGPersonPlanArrangeI</IndexLocation>
<StreamLocation>^User.DHCMGPersonPlanArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
