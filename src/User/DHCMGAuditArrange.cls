Class User.DHCMGAuditArrange Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//排班审核记录

Property AuditUser As User.DHCMGPersons;

Property AuditDate As %Library.Date(FORMAT = 1);

Property AuditSmUser As User.DHCMGPersons;

Property AuditTime As %Library.Time;

Property AuditSmDate As %Library.Date(FORMAT = 1);

Property AuditSmTime As %Library.Time;

Property AuditStDate As %Library.Date(FORMAT = 1);

Property AuditEdDate As %Library.Date(FORMAT = 1);

Property AuditDep As %Library.String(TRUNCATE = 1);

Property AuditStat As %Library.String(DISPLAYLIST = ",Submit,Audit,Refund", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,A,R");

Property AuditMem As %Library.String(TRUNCATE = 1);

Index DepDate On (AuditDep, AuditSmDate);

ClassMethod AuditArrange(parr As %String) As %String
{
  //排班提交
  //s parr="^543^2009-04-01^2009-04-20^1082"
   s id=$P(parr,"^",1)
   s user=$P(parr,"^",2)
   s dep=$P(parr,"^",3)
   s a=##class(User.DHCMGAuditArrange).%OpenId(id)
   s a.AuditUser=##class(User.DHCMGPersons).%OpenId(user)
   s a.AuditDate=+$H
   s a.AuditTime=$P($H,",",2)
   s a.AuditStat="A" //审核状态

   s stdate=a.AuditStDate
   s edate=a.AuditEdDate
   d a.%Save()
   b
   for date=stdate:1:edate 
   {
     s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date,rw)) q:rw=""  d
     .s arr=##class(User.DHCMGPersonArrange).%OpenId(rw)
     .s post=arr.ARRPostDR
     .s per=arr.ARRPerDR
     .s arrdate=arr.ARRDate
     .s dep=arr.ARRDepDR
     .s user=arr.ARRRecordUser
     .s arr.AuditDr=a
     .s arr=##class(User.DHCMGPersonPlanArrange).%New()
     .s arr.ARRPostDR=post
     .s arr.ARRPerDR=per
     .s arr.ARRDate=arrdate
     .s arr.ARRDepDR=dep
     .s arr.ARRRecDate=+$H
     .s arr.ARRRecTime=$P($H,",",2)
     .s arr.ARRRecordUser=user
     .s arr.AuditDr=a
     .d arr.%Save()
   }
   q 0
  // s date=""  f  s date=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date)) q:date=""  d
   //.s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("DepDate"," "_dep,date,rw)) q:rw=""  d
  // ..s arra=##class(User.DHCMGPersonArrange).%OpenId(rw)
  // ..if arra.AuditDr="" s arra.AutidDr=a
}

ClassMethod SubmitArrange(parr As %String) As %String
{
   //提交排班记录 //s parr="^543^2009-02-10^2009-02-28^1082"
   s id=$P(parr,"^",1)
   s user=$P(parr,"^",2)
   s stdate=$P(parr,"^",3)
   s edate=$P(parr,"^",4)
   s dep=$P(parr,"^",5)
   s stdate=$ZDH(stdate,3)
   s edate=$ZDH(edate,3)
   if id="" s a=##class(User.DHCMGAuditArrange).%New()
   e  s a=##class(User.DHCMGAuditArrange).%OpenId(id)
   s a.AuditSmUser=##class(User.DHCMGPersons).%OpenId(user)
   s a.AuditStDate=stdate
   s a.AuditEdDate=edate
   s a.AuditSmDate=+$H
   s a.AuditSmTime=$P($H,",",2)
   s a.AuditDep=dep //##class(User.CTLoc).%OpenId(dep)
   s a.AuditStat="S" //提交状态
   d a.%Save()
   q 0
}

ClassMethod RetArrange(parr As %String) As %String
{
 //退回排班记录

   //s parr="^543^2009-02-10^2009-02-28^1082"
   s id=$P(parr,"^",1)
   s user=$P(parr,"^",2)
   s mem=$P(parr,"^",3)
   if id="" s a=##class(User.DHCMGAuditArrange).%New()
   e  s a=##class(User.DHCMGAuditArrange).%OpenId(id)
   s a.AuditStat="R" //提交状态
   s a.AuditMem=mem
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGAuditArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditDate</Value>
</Value>
<Value name="3">
<Value>AuditDep</Value>
</Value>
<Value name="4">
<Value>AuditEdDate</Value>
</Value>
<Value name="5">
<Value>AuditStDate</Value>
</Value>
<Value name="6">
<Value>AuditTime</Value>
</Value>
<Value name="7">
<Value>AuditUser</Value>
</Value>
<Value name="8">
<Value>AuditStat</Value>
</Value>
<Value name="9">
<Value>AuditSmTime</Value>
</Value>
<Value name="10">
<Value>AuditSmDate</Value>
</Value>
<Value name="11">
<Value>AuditSmUser</Value>
</Value>
<Value name="12">
<Value>AuditMem</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGAuditArrangeD</DataLocation>
<DefaultData>DHCMGAuditArrangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGAuditArrangeD</IdLocation>
<IndexLocation>^User.DHCMGAuditArrangeI</IndexLocation>
<StreamLocation>^User.DHCMGAuditArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
