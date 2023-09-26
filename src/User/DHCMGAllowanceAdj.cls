Class User.DHCMGAllowanceAdj Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//补贴单位

Property AllowanceUnit As %String(TRUNCATE = 1);

//节日

Property FeastPrice As %String(TRUNCATE = 1);

//平日

Property FeriaPrice As %String(TRUNCATE = 1);

Property AdjStDate As %Library.Date(FORMAT = 1);

Property AdjEnDate As %Library.Date(FORMAT = 1);

Property AdjDate As %Library.Date(FORMAT = 1);

Property AdjTime As %Library.Time;

Property AdjUser As User.DHCMGPersons;

Index SDate On AdjStDate;

ClassMethod Save(parr As %String) As %String
{
   //s parr="^20^10^^2009-04-15"
   s id=$P(parr,"^",1)
   s feastprice=$P(parr,"^",2)
   s ferprice=$P(parr,"^",3)
   s unit=$P(parr,"^",4)
   s stdate=$P(parr,"^",5)
   s stdate=$ZDH(stdate,3)
   s user=$P(parr,"^",6)
   if id'=""  s a=##class(User.DHCMGAllowanceAdj).%OpenId(id)
   e  s a=##class(User.DHCMGAllowanceAdj).%New()
   s a.AllowanceUnit=unit
   s a.FeastPrice=feastprice
   s a.FeriaPrice=ferprice
   s a.AdjStDate=stdate
   s a.AdjDate=+$H
   s a.AdjTime=$P($H,",",2)
   s a.AdjUser=##class(User.DHCMGPersons).%OpenId(id)
   d a.%Save()
   q 0
}

ClassMethod getprice(sdate) As %String
{
 //取比sdate日期小的或等于 ##class(User.DHCMGAllowanceAdj).getprice()
    s feastprice="",feriprice=""
	s date="" f  s date=$O(^User.DHCMGAllowanceAdjI("SDate",date),-1) q:(date="")!(feastprice'="")  d
	.q:date>sdate
	.s rw=""  f  s rw=$O(^User.DHCMGAllowanceAdjI("SDate",date,rw)) q:rw=""!(feastprice'="")  d
	..s a=^User.DHCMGAllowanceAdjD(rw)
	..s feastprice=$list(a,3),feriprice=$list(a,4)
  q feastprice_"^"_feriprice
}

Storage Default
{
<Data name="DHCMGAllowanceAdjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AllowanceUnit</Value>
</Value>
<Value name="3">
<Value>FeastPrice</Value>
</Value>
<Value name="4">
<Value>FeriaPrice</Value>
</Value>
<Value name="5">
<Value>AdjDate</Value>
</Value>
<Value name="6">
<Value>AdjTime</Value>
</Value>
<Value name="7">
<Value>AdjUser</Value>
</Value>
<Value name="8">
<Value>AdjEnDate</Value>
</Value>
<Value name="9">
<Value>AdjStDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGAllowanceAdjD</DataLocation>
<DefaultData>DHCMGAllowanceAdjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGAllowanceAdjD</IdLocation>
<IndexLocation>^User.DHCMGAllowanceAdjI</IndexLocation>
<StreamLocation>^User.DHCMGAllowanceAdjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
