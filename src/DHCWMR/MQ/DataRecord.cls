Class DHCWMR.MQ.DataRecord Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCWMR.MQ.DataMaster [ Cardinality = parent, Inverse = ChildRecord ];

Property DataItem As DHCWMR.MQ.DataItems;

Property ItemValue As %String(MAXLEN = 500, TRUNCATE = 1);

Property ValType As %String(MAXLEN = 100, TRUNCATE = 1);

Property DataIndex As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexParRef On (ParRef, DataItem, ItemValue As Exact);

Index IndexDataItemValue On (DataItem, ItemValue As Exact);

Index IndexParRefIndex On (ParRef, DataItem, DataIndex);

Index IndexParRefItem On (ParRef, DataItem);

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  取首页数据
/// Table：       DHCWMR.MQ.DataRecord
/// Input：       ID : DHCWMR.MQ.DataRecord.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataRecord).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataRecord
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataRecord).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataRecord).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  更新首页数据
/// Table：       DHCWMR.MQ.DataRecord
/// Input：       InputStr ：首页数据
///               Separate : 分隔符（不允许带"^"）
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataRecord).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set MasterID=$p(aInputStr,aSeparate,1)
	Set ItemID=$p(aInputStr,aSeparate,2)
	Set ItemValue=$p(aInputStr,aSeparate,3)
	Set ValType=$p(aInputStr,aSeparate,4)
	Set DataIndex=+$p(aInputStr,aSeparate,5)
	Quit:(MasterID="")||(ItemID="")||(ValType="")||(DataIndex="") return
	
	Set objMaster=##class(DHCWMR.MQ.DataMaster).GetObjById(MasterID)
	Quit:'$IsObject(objMaster) return
	
	Set objItem=##class(DHCWMR.MQ.DataItems).GetObjById(ItemID)
	Quit:'$IsObject(objItem) return
	Quit:objItem.IsActive'=1 return
	
	Set ID=$o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefIndex",MasterID,ItemID," "_DataIndex,0))
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.DataRecord).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.DataRecord).%OpenId(MasterID_"||"_ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=objMaster
	Set obj.DataItem=objItem
	Set obj.ItemValue=ItemValue
	Set obj.ValType=ValType
	Set obj.DataIndex=DataIndex
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  删除首页数据
/// Table：       DHCWMR.MQ.DataRecord
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataRecord).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.DataRecord).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
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
<StreamLocation>^DHCWMR.MQ.DataRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
