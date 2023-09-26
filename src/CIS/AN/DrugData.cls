/// 麻醉记录药品数据
Class CIS.AN.DrugData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugData ]
{

/// 麻醉记录数据
Property AnaData As CIS.AN.AnaData [ Required, SqlColumnNumber = 2 ];

/// 药品使用剂量
Property DoseQty As %Float [ SqlColumnNumber = 3 ];

/// 药品剂量单位
Property DoseUnit As CT.AN.Uom [ SqlColumnNumber = 4 ];

/// 药品用法
Property Instruction As %String [ SqlColumnNumber = 5 ];

/// 药品浓度
Property Concentration As %Float [ SqlColumnNumber = 6 ];

/// 药品浓度单位
Property ConcentrationUnit As CT.AN.Uom [ SqlColumnNumber = 7 ];

/// 用药速度
Property Speed As %Float [ SqlColumnNumber = 8 ];

/// 速度单位
Property SpeedUnit As CT.AN.Uom [ SqlColumnNumber = 9 ];

/// 余量
Property BalanceQty As %Float [ SqlColumnNumber = 10 ];

/// 用药原因
Property Reason As %String(MAXLEN = 500) [ SqlColumnNumber = 11 ];

/// 药品名称
Property Description As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 余量处置
Property BalanceDisposal As %String(MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 接收科室
Property RecvLoc As %String [ SqlColumnNumber = 14 ];

/// HIS医嘱项目ID
Property ArcimID As %String [ SqlColumnNumber = 15 ];

/// HIS医嘱ID
Property OrderItemID As %String [ SqlColumnNumber = 16 ];

/// 是否持续用药
Property Continuous As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 17 ];

/// 数据项
Property DataItem As CT.AN.DataItem [ SqlColumnNumber = 18 ];

/// 自定义数据项
Property UserDefinedItem As CF.AN.UserDefDataItem [ SqlColumnNumber = 19 ];

/// 备注
Property Note As %String [ SqlColumnNumber = 20 ];

/// 术后带回
Property TakingAway As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 21 ];

/// 靶控
Property TCI As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 22 ];

/// 输液部位
Property InjectionSite As CT.AN.InjectionSite [ SqlColumnNumber = 23 ];

/// 自动生成时绑定的收费记录明细
Property ChargeDetail As CIS.AN.ChargeDetail [ SqlColumnNumber = 24 ];

/// 麻醉记录数据索引
Index IAnaData On AnaData;

/// 数据项索引
Index IDataItem On DataItem;

/// 麻醉记录数据外键约束
ForeignKey FKAnaData(AnaData) References CIS.AN.AnaData() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugDataDefaultData">
<Value name="1">
<Value>AnaData</Value>
</Value>
<Value name="2">
<Value>DoseQty</Value>
</Value>
<Value name="3">
<Value>DoseUnit</Value>
</Value>
<Value name="4">
<Value>Instruction</Value>
</Value>
<Value name="5">
<Value>Concentration</Value>
</Value>
<Value name="6">
<Value>ConcentrationUnit</Value>
</Value>
<Value name="7">
<Value>Speed</Value>
</Value>
<Value name="8">
<Value>SpeedUnit</Value>
</Value>
<Value name="9">
<Value>BalanceQty</Value>
</Value>
<Value name="10">
<Value>Reason</Value>
</Value>
<Value name="11">
<Value>Description</Value>
</Value>
<Value name="12">
<Value>BalanceDisposal</Value>
</Value>
<Value name="13">
<Value>RecvLoc</Value>
</Value>
<Value name="14">
<Value>ArcimID</Value>
</Value>
<Value name="15">
<Value>OrderItemID</Value>
</Value>
<Value name="16">
<Value>Continuous</Value>
</Value>
<Value name="17">
<Value>DataItem</Value>
</Value>
<Value name="18">
<Value>UserDefinedItem</Value>
</Value>
<Value name="19">
<Value>Note</Value>
</Value>
<Value name="20">
<Value>TakingAway</Value>
</Value>
<Value name="21">
<Value>TCI</Value>
</Value>
<Value name="22">
<Value>InjectionSite</Value>
</Value>
<Value name="23">
<Value>ChargeDetail</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.DrugDataD</DataLocation>
<DefaultData>DrugDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.DrugDataD</IdLocation>
<IndexLocation>^CIS.AN.DrugDataI</IndexLocation>
<StreamLocation>^CIS.AN.DrugDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
