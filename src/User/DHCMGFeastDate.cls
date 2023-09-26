Class User.DHCMGFeastDate Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_FeastDate ]
{

//节假日设定

Property FeastDr As User.DHCMGCCode;

Property FeastYearDr As User.DHCMGCCode;

Property FeastStDate As %Library.Date(FORMAT = 1);

Property FeastEndDate As %Library.Date(FORMAT = 1);

Property FeastStopDate As %Library.Date(FORMAT = 1);

Property FeastUnit As %String(TRUNCATE = 1);

Property FeastAllowance As %String(TRUNCATE = 1);

Property FeastMem As %String(TRUNCATE = 1);

Index FeastYear On (FeastYearDr, FeastDr);

Index StopDate On FeastStopDate;

ClassMethod getfeastflag(date, yeardr) As %String
{
 //判断是否节日
    s flag="N"
    s fe=""  f  s fe=$O(^User.DHCMGFeastDateI("FeastYear",yeardr,fe)) q:fe=""  d
    .s rw="" f  s rw=$O(^User.DHCMGFeastDateI("FeastYear",yeardr,fe,rw)) q:(rw="")!(flag="Y")  d
    ..s a=^User.DHCMGFeastDateD(rw)
    ..s stdate=$list(a,6),edate=$list(a,4)
    ..if (date'<stdate)&(date'>edate) s flag="Y"
    //b //getfeastflag
   q flag
}

ClassMethod SaveStop(parr As %String) As %String
{
   //s parr="^25^27^2009-01-16^2009-01-23"
   s id=$P(parr,"^",1)
   s feast=$P(parr,"^",2)
   s year=$P(parr,"^",3)
   s stopdate=$P(parr,"^",4)
   s stopdate=$ZDH(stopdate,3)
   if id'="" s a=##class(User.DHCMGFeastDate).%OpenId(id)
   e  s a=##class(User.DHCMGFeastDate).%New()
   s a.FeastDr=##class(User.DHCMGCCode).%OpenId(feast)
   s a.FeastYearDr=##class(User.DHCMGCCode).%OpenId(year)
   s a.FeastStopDate=stopdate
   d a.%Save()
   q 0
}

ClassMethod Del(id As %String) As %String
{
   //s parr="^25^27^2009-01-16^2009-01-23"
   if id'="" s a=##class(User.DHCMGFeastDate).%DeleteId(id)
   q 0
}

ClassMethod Save(parr As %String) As %String
{
   //s parr="^25^27^2009-01-16^2009-01-23"
   s id=$P(parr,"^",1)
   s feast=$P(parr,"^",2)
   s year=$P(parr,"^",3)
   s stdate=$P(parr,"^",4)
   s edate=$P(parr,"^",5)
   s stdate=$ZDH(stdate,3)
   s edate=$ZDH(edate,3)
   s Unit=""
   s Allowance=""
   s mem=""
   if id'="" s a=##class(User.DHCMGFeastDate).%OpenId(id)
   e  s a=##class(User.DHCMGFeastDate).%New()
   s a.FeastDr=##class(User.DHCMGCCode).%OpenId(feast)
   s a.FeastYearDr=##class(User.DHCMGCCode).%OpenId(year)
   s a.FeastStDate=stdate
   s a.FeastEndDate=edate
   s a.FeastUnit=Unit
   s a.FeastAllowance=Allowance
   s a.FeastMem=mem
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGFeastDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FeastAllowance</Value>
</Value>
<Value name="3">
<Value>FeastDr</Value>
</Value>
<Value name="4">
<Value>FeastEndDate</Value>
</Value>
<Value name="5">
<Value>FeastMem</Value>
</Value>
<Value name="6">
<Value>FeastStDate</Value>
</Value>
<Value name="7">
<Value>FeastYearDr</Value>
</Value>
<Value name="8">
<Value>FeastUnit</Value>
</Value>
<Value name="9">
<Value>FeastStopDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGFeastDateD</DataLocation>
<DefaultData>DHCMGFeastDateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGFeastDateD</IdLocation>
<IndexLocation>^User.DHCMGFeastDateI</IndexLocation>
<StreamLocation>^User.DHCMGFeastDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
