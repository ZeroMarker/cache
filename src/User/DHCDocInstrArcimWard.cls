Class User.DHCDocInstrArcimWard Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHCDoc_InstrArcimWard ]
{

/// 病区
Property AddItemWardDR As PACWard [ SqlColumnNumber = 2, SqlFieldName = AddItem_Ward_DR ];

/// 绑定数据类型Instr-用法绑定,Arcim-医嘱绑定
Property AddItemType As %String(COLLATION = "EXACT", DISPLAYLIST = ",Instr,Arcim", MAXLEN = 3, VALUELIST = ",I,A") [ SqlColumnNumber = 3, SqlFieldName = AddItem_Type ];

/// 绑定数据类型ID，医嘱项ID/用法ID
Property AddItemTypeDR As %String(COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = AddItem_Type_DR ];

/// 绑定医嘱项
Property AddItemArcimDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = AddItem_Arcim_DR ];

/// 绑定途径 1-下医嘱绑定 2-执行绑定
Property AddItemAppendType As %String [ SqlColumnNumber = 6, SqlFieldName = AddItem_AppendType ];

/// 绑定方式 1-一天一次 2-按次 3-按最大频次 10-首次 11-接瓶
Property AddItemExecType As %String [ SqlColumnNumber = 7, SqlFieldName = AddItem_ExecType ];

/// 启用标识
Property AddItemActiveFlag As %String [ SqlColumnNumber = 8, SqlFieldName = AddItem_ActiveFlag ];

/// 起收数量
Property AddItemStartNum As %String [ SqlColumnNumber = 9, SqlFieldName = AddItem_StartNum ];

/// 截止数量
Property AddItemEndNum As %String [ SqlColumnNumber = 10, SqlFieldName = AddItem_EndNum ];

/// 数量
Property AddItemQty As %String [ SqlColumnNumber = 11, SqlFieldName = AddItem_Qty ];

/// 绑定类型 1-自动绑定 2-手工绑定
Property AddItemByHand As %String [ SqlColumnNumber = 12, SqlFieldName = AddItem_ByHand ];

/// 仅成组医嘱绑定费用标志
Property AddItemSingleNotFee As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = AddItem_SingleNotFee ];

/// 例外的医嘱类型串
Property AddItemExcludePrior As %String [ SqlColumnNumber = 14, SqlFieldName = AddItem_ExcludePrior ];

/// 开始年龄
Property AddItemAgeFrom As %String [ SqlColumnNumber = 15, SqlFieldName = AddItem_AgeFrom ];

/// 截止年龄
Property AddItemAgeTo As %String [ SqlColumnNumber = 16, SqlFieldName = AddItem_AgeTo ];

/// 除最大频次以外加收费
Property AddItemInstrAddArcimId As %String [ SqlColumnNumber = 17, SqlFieldName = AddItem_InstrAddArcimId ];

/// 加收数量
Property AddItemAddQty As %String [ SqlColumnNumber = 18, SqlFieldName = AddItem_AddQty ];

/// 相同绑定类型下，与本配置的用法列表\\医嘱列表绑定的医嘱重复带出;该判断无关绑定方式、绑定类型，是选择配置数据的优先级，
/// 并不是计算数据的优先级，即不同绑定方式、绑定类型的配置数据时，该配置依旧生效
/// 1、一起带出的类型，不需要做逻辑判断，直接绑定
/// 2、按医嘱项绑定的医嘱，存在不能一起绑定的用法绑定医嘱时，则不需要绑定，否则绑定自己
/// 3、按用法绑定的医嘱，存在不能一起绑定的医嘱项绑定医嘱时，则不需要绑定，否则绑定自己
Property AddItemIsRepeatAppend As %String [ SqlColumnNumber = 19, SqlFieldName = AddItem_IsRepeatAppend ];

Index AddItemArcimDR On (AddItemType, AddItemWardDR, AddItemTypeDR);

Storage Default
{
<Data name="DHCDocInstrArcimWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AddItemWardDR</Value>
</Value>
<Value name="3">
<Value>AddItemType</Value>
</Value>
<Value name="4">
<Value>AddItemArcimDR</Value>
</Value>
<Value name="5">
<Value>AddItemAppendType</Value>
</Value>
<Value name="6">
<Value>AddItemExecType</Value>
</Value>
<Value name="7">
<Value>AddItemActiveFlag</Value>
</Value>
<Value name="8">
<Value>AddItemStartNum</Value>
</Value>
<Value name="9">
<Value>AddItemEndNum</Value>
</Value>
<Value name="10">
<Value>AddItemQty</Value>
</Value>
<Value name="11">
<Value>AddItemByHand</Value>
</Value>
<Value name="12">
<Value>AddItemSingleNotFee</Value>
</Value>
<Value name="13">
<Value>AddItemExcludePrior</Value>
</Value>
<Value name="14">
<Value>AddItemTypeDR</Value>
</Value>
<Value name="15">
<Value>AddItemAgeFrom</Value>
</Value>
<Value name="16">
<Value>AddItemAgeTo</Value>
</Value>
<Value name="17">
<Value>AddItemInstrAddArcimId</Value>
</Value>
<Value name="18">
<Value>AddItemAddQty</Value>
</Value>
<Value name="19">
<Value>AddItemIsRepeatAppend</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocInstrArcimWardD</DataLocation>
<DefaultData>DHCDocInstrArcimWardDefaultData</DefaultData>
<IdLocation>^User.DHCDocInstrArcimWardD</IdLocation>
<IndexLocation>^User.DHCDocInstrArcimWardI</IndexLocation>
<StreamLocation>^User.DHCDocInstrArcimWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
