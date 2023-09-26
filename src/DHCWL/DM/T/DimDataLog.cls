Class DHCWL.DM.T.DimDataLog Extends %Persistent
{

Property DimBase As DimBase [ Required ];

Property LogDate As %Date [ Required ];

Property LogTime As %Time;

Property Action As %String(DISPLAYLIST = ",Insert,Update,Delete", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",I,U,D") [ Required ];

Property OtherInfo As %String;

Index MainI On (DimBase, Action, LogDate);

ClassMethod Add(dimId, action, otherInfo = "") As %Status
{
	s ld=$p($h,",",1),lt=$p($h,",",2)
	&sql(INSERT INTO DHCWL_DM_T.DimDataLog(DimBase,LogDate,LogTime,Action,OtherInfo) values(:dimId,:ld,:lt,:action,:otherInfo))
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

Storage Default
{
<Data name="DimDataLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimBase</Value>
</Value>
<Value name="3">
<Value>LogDate</Value>
</Value>
<Value name="4">
<Value>LOgTime</Value>
</Value>
<Value name="5">
<Value>Action</Value>
</Value>
<Value name="6">
<Value>OtherInfo</Value>
</Value>
<Value name="7">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimDataLogD</DataLocation>
<DefaultData>DimDataLogDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimDataLogD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimDataLogI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimDataLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
