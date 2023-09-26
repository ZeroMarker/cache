Class User.DHCMGTrans Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Trans ]
{

//调科

Property PersonDr As User.DHCMGPersons;

Property DepDr As %String(TRUNCATE = 1);

Property NurTranStDate As %Library.Date(FORMAT = 1);

Property NurTranStTime As %Library.Time;

Property NurTranEndDate As %Library.Date(FORMAT = 1);

Property NurTranEndTime As %Library.Time;

Property NurTranMem As %String(TRUNCATE = 1);

Property NurTranCurrent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index Person On PersonDr;

ClassMethod Save(parr As %String) As %String
{
  // s parr="^528^1082^2006-03-14^13:54:24^Y"
   s id=$P(parr,"^",1)
   s per=$P(parr,"^",2)
   s dep=$P(parr,"^",3)
   s stdate=$P(parr,"^",4)
   s sttime=$P(parr,"^",5)
   s curr=$P(parr,"^",6)
   s mem=$P(parr,"^",7)
   s stdate=$ZDH(stdate,3)
   if sttime'="" s sttime=$ZTH(sttime)
   e  s sttime=$P($H,",",2)
   s id="",upid=""
   
   s rw=""  f  s rw=$O(^User.DHCMGTransI("Person",per,rw)) q:rw=""  d
   .s loc=$List(^User.DHCMGTransD(rw),9)
   .s enddate=$List(^User.DHCMGTransD(rw),3)
   .if (loc=dep)&(enddate="") s id=rw
   .e  d
   ..s id="",upid=rw

   if id'="" s a=##class(User.DHCMGTrans).%OpenId(id)
   e  s a=##class(User.DHCMGTrans).%New()
   s a.PersonDr=##class(User.DHCMGPersons).%OpenId(per)
   s a.DepDr=dep //##class(User.CTLoc).%OpenId(dep)
   s a.NurTranStDate=stdate
   s a.NurTranStTime=sttime
   s a.NurTranCurrent=curr
   s a.NurTranMem=mem
   //b //233
   d a.%Save()
   if upid'="" 
   {
      s aa=##class(User.DHCMGTrans).%OpenId(upid)
      s aa.NurTranEndDate=stdate
      s aa.NurTranEndTime=sttime
      s aa.NurTranCurrent="N"
      d aa.%Save()
      
  }
  // if curr="Y"
  // {
 //  s bper=##class(User.DHCMGPersons).%OpenId(per)
 //	   s bper.PersonEnterDepDate=stdate
 //	   s bper.PersonDepDR=##class(User.CTLoc).%OpenId(dep)
  //	   d bper.%Save()
  // }
   q 0
}

Storage Default
{
<Data name="DHCMGTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurTranCurrent</Value>
</Value>
<Value name="3">
<Value>NurTranEndDate</Value>
</Value>
<Value name="4">
<Value>NurTranMem</Value>
</Value>
<Value name="5">
<Value>NurTranStDate</Value>
</Value>
<Value name="6">
<Value>PersonDr</Value>
</Value>
<Value name="7">
<Value>NurTranEndTime</Value>
</Value>
<Value name="8">
<Value>NurTranStTime</Value>
</Value>
<Value name="9">
<Value>DepDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTransD</DataLocation>
<DefaultData>DHCMGTransDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTransD</IdLocation>
<IndexLocation>^User.DHCMGTransI</IndexLocation>
<StreamLocation>^User.DHCMGTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
