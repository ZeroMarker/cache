Class User.DHCMGArrRelayRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property NewProperty1 As %String(TRUNCATE = 1);

Index NewProperty1Index On NewProperty1 [ Unique ];

//替班记录表

//替班人

Property RelayNur As %String(TRUNCATE = 1);

//被替人

Property RelayByNur As %String(TRUNCATE = 1);

//替班日期

Property RelayDate As %Library.Date(FORMAT = 1);

//岗位ie

Property RelayPost As %String(TRUNCATE = 1);

//开始时间

Property RelayStTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

//结束时间

Property RelayEndTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RelayRecDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = Prom_RecDate ];

Property RelayRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 10, SqlFieldName = Prom_RecTime ];

Property RelayRecUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Prom_RecUser ];

Index RelDate On RelayDate;

ClassMethod SaveRelayRecord(parr As %String) As %String
{
   //s parr="^266^367^2009-02-24^3^8:39:14^8:39:14^561^1079"

   s id=$P(parr,"^")
   s nur=$P(parr,"^",2)
   s bynur=$P(parr,"^",3)
   s date=$P(parr,"^",4)
   s post=$P(parr,"^",5)
   s sttim=$P(parr,"^",6)
   s endtim=$P(parr,"^",7)
   s user=$P(parr,"^",8)
   if id="" s a=##class(User.DHCMGArrRelayRecord).%New()
   e  s a=##class(User.DHCMGArrRelayRecord).%OpenId(id)
   s a.RelayNur=nur
   s a.RelayByNur=bynur
   s a.RelayDate=$ZDH(date,3)
   s a.RelayPost=post
   s a.RelayStTime=$ZTH(sttim)
   s a.RelayEndTime=$ZTH(endtim)
   s a.RelayRecDate=+$H
   s a.RelayRecTime=$P($H,",",2)
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGArrRelayRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RelayByNur</Value>
</Value>
<Value name="3">
<Value>RelayNur</Value>
</Value>
<Value name="4">
<Value>RelayDate</Value>
</Value>
<Value name="5">
<Value>RelayEndTime</Value>
</Value>
<Value name="6">
<Value>RelayPost</Value>
</Value>
<Value name="7">
<Value>RelayStTime</Value>
</Value>
<Value name="8">
<Value>RelayRecDate</Value>
</Value>
<Value name="9">
<Value>RelayRecTime</Value>
</Value>
<Value name="10">
<Value>RelayRecUser</Value>
</Value>
<Value name="11">
<Value>NewProperty1</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGArrRelayRecordD</DataLocation>
<DefaultData>DHCMGArrRelayRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGArrRelayRecordD</IdLocation>
<IndexLocation>^User.DHCMGArrRelayRecordI</IndexLocation>
<StreamLocation>^User.DHCMGArrRelayRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
