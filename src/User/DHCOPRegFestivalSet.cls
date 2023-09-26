Class User.DHCOPRegFestivalSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_OPRegFestivalSet ]
{

Index FESTDateIndex On FESTDate;

Property FESTComm As %String(TRUNCATE = 1);

Property FESTComm1 As %String(TRUNCATE = 1);

Property FESTComm2 As %String(TRUNCATE = 1);

Property FESTCreateDate As %Date;

Property FESTCreateUser As %String(TRUNCATE = 1);

Property FESTDate As %Date;

Property FESTWeek As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCOPRegFestivalSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FESTComm</Value>
</Value>
<Value name="3">
<Value>FESTComm1</Value>
</Value>
<Value name="4">
<Value>FESTComm2</Value>
</Value>
<Value name="5">
<Value>FESTCreateDate</Value>
</Value>
<Value name="6">
<Value>FESTCreateUser</Value>
</Value>
<Value name="7">
<Value>FESTDate</Value>
</Value>
<Value name="8">
<Value>FESTWeek</Value>
</Value>
</Data>
<DataLocation>^User.DHCOPRegFestivalSetD</DataLocation>
<DefaultData>DHCOPRegFestivalSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCOPRegFestivalSetD</IdLocation>
<IndexLocation>^User.DHCOPRegFestivalSetI</IndexLocation>
<StreamLocation>^User.DHCOPRegFestivalSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
