/// 定义清洗篮筐中的消毒包，便于后期灭菌、清洗、盘点扫描
Class User.CSSDBasketPackDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_BasketPackDetail ]
{

/// 回收明细id
Property CSSDCBPCallBackDetailDR As User.CSSDCallbackDetailNew [ SqlColumnNumber = 2, SqlFieldName = CSSDCBP_CallBackDetail_DR ];

Property CSSDCBPPackage As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDCBP_Package_DR ];

Property CSSDCBPPackageLabel As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDCBP_PackageLabel ];

Property CSSDCBPQty As %Integer [ SqlColumnNumber = 5, SqlFieldName = CSSDCBP_Qty ];

Property CSSDCBPWorkState As %Integer [ SqlColumnNumber = 6, SqlFieldName = CSSDCBP_WorkState ];

/// 是否清洗
Property CSSDCBPIsClean As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 7, SqlFieldName = CSSDCBP_IsClean ];

/// 清洗主表
Property CSSDCBPICleanDr As User.CSSDCleanDetailPacks [ SqlColumnNumber = 8, SqlFieldName = CSSDCBP_CleanDr ];

Property CSSDCBPBSKLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDCBP_BSKLabel ];

Property CSSDCBPMachineNoDR As User.CSSDMachineConfig [ SqlColumnNumber = 10, SqlFieldName = CSSDCBP_MachineNo_DR ];

Index CSSDCBPBSKLabelIndex On CSSDCBPBSKLabel As Exact;

Index CSSDCBPBSKLabelPkgIsCleanIndex On (CSSDCBPBSKLabel As Exact, CSSDCBPPackage As Exact, CSSDCBPIsClean As Exact);

Index CSSDCBPBSKLabelIsCleanIndex On (CSSDCBPBSKLabel As Exact, CSSDCBPIsClean As Exact);

Index CSSDCBPICleanDrPackageIndex On (CSSDCBPICleanDr As Exact, CSSDCBPPackage As Exact);

Index CSSDCBPICallBackIndex On CSSDCBPCallBackDetailDR As Exact;

Index LabelIsCleanIndex On (CSSDCBPPackageLabel As Exact, CSSDCBPIsClean As Exact);

Storage Default
{
<Data name="CSSDBasketPackDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCBPCallBackDetailDR</Value>
</Value>
<Value name="3">
<Value>CSSDCBPPackage</Value>
</Value>
<Value name="4">
<Value>CSSDCBPPackageLabel</Value>
</Value>
<Value name="5">
<Value>CSSDCBPQty</Value>
</Value>
<Value name="6">
<Value>CSSDCBPWorkState</Value>
</Value>
<Value name="7">
<Value>CSSDCBPIsClean</Value>
</Value>
<Value name="8">
<Value>CSSDCBPICleanDr</Value>
</Value>
<Value name="9">
<Value>CSSDCBPBSKLabel</Value>
</Value>
<Value name="10">
<Value>CSSDCBPMachineNoDR</Value>
</Value>
</Data>
<DataLocation>^User.CSSDBasketPackDetailD</DataLocation>
<DefaultData>CSSDBasketPackDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDBasketPackDetailD</IdLocation>
<IndexLocation>^User.CSSDBasketPackDetailI</IndexLocation>
<StreamLocation>^User.CSSDBasketPackDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
