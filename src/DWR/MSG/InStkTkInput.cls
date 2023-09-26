/// Descript:实盘记录
/// Creater:	ZhangDongmei
/// CreateDate:	2013-06-06
/// 
Class DWR.MSG.InStkTkInput Extends (%Persistent, %XML.Adaptor)
{

//实盘记录id

Property inputId As %String;

//盘点主表id

Property instId As %String;

//库存项id

Property incRowid As %String;

//药品代码

Property incCode As %String;

//药品名称

Property incDesc As %String;

//规格

Property spec As %String;

//药品包装单位id

Property purUomId As %String;

//药品包装单位描述

Property purUomDesc As %String;

//基本单位id

Property uomId As %String;

//基本单位描述

Property uomDesc As %String;

//实盘数量（整包装）

Property countQtyPurUom As %String;

//实盘数量(基本单位)，药品的实际实盘数量=countQtyPurUom+countQtyUom

Property countQtyUom As %String;

//实盘人id

Property userId As %String;

//实盘人姓名

Property userName As %String;

//药品条码

Property barCode As %String;

Storage Default
{
<Data name="InStkTkInputDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>inputId</Value>
</Value>
<Value name="3">
<Value>instId</Value>
</Value>
<Value name="4">
<Value>incRowid</Value>
</Value>
<Value name="5">
<Value>uomId</Value>
</Value>
<Value name="6">
<Value>countQty</Value>
</Value>
<Value name="7">
<Value>userId</Value>
</Value>
<Value name="8">
<Value>barCode</Value>
</Value>
<Value name="9">
<Value>incCode</Value>
</Value>
<Value name="10">
<Value>incDesc</Value>
</Value>
<Value name="11">
<Value>spec</Value>
</Value>
<Value name="12">
<Value>purUomId</Value>
</Value>
<Value name="13">
<Value>purUomDesc</Value>
</Value>
<Value name="14">
<Value>uomDesc</Value>
</Value>
<Value name="15">
<Value>countQtyPurUom</Value>
</Value>
<Value name="16">
<Value>countQtyUom</Value>
</Value>
<Value name="17">
<Value>userName</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.InStkTkInputD</DataLocation>
<DefaultData>InStkTkInputDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.InStkTkInputD</IdLocation>
<IndexLocation>^DWR.MSG.InStkTkInputI</IndexLocation>
<StreamLocation>^DWR.MSG.InStkTkInputS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
