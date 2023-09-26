Class DHCWMR.MQ.DataRecordI Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCWMR.MQ.DataMaster [ Cardinality = parent, Inverse = ChildRecordI ];

Property DataItem As DHCWMR.MQ.DataItems;

Property ItemValue As %String(MAXLEN = 500, TRUNCATE = 1);

Property ValType As %String(MAXLEN = 100, TRUNCATE = 1);

Property DataIndex As %String(MAXLEN = 100, TRUNCATE = 1);

//Index IndexParRef On (ParRef, DataItem, ItemValue As Exact);

//Index IndexDataItemValue On (DataItem, ItemValue As Exact);

//Index IndexParRefIndex On (ParRef, DataItem, DataIndex);

/// Creator：     jiangpengpeng
/// CreatDate：   2015-01-20
/// Description:  取数据对象
/// Table：       DHCWMR.MQ.DataRecordI
/// Input：       ID : DHCWMR.MQ.DataRecordI.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataRecordI).GetObjById(xID_"||"_xSub)
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataRecordI
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataRecordI).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataRecordI).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>ItemValue</Value>
</Value>
<Value name="4">
<Value>ValType</Value>
</Value>
<Value name="5">
<Value>DataIndex</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DATA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DATA")</IdLocation>
<IndexLocation>^DHCWMR.MQ.DataMasterI("DataRecord")</IndexLocation>
<StreamLocation>^DHCWMR.MQ.DataRecordIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
