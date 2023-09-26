/// 出院患者的费用明细
Class User.DHCMRCClinPathWayCostDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWCD_RowId, SqlTableName = DHC_MR_ClinPathWayCostDetail ]
{

/// 病人就诊ID
Property CPWCDPaAdm As %String [ SqlColumnNumber = 2, SqlFieldName = CPWCD_Paadm ];

/// 费用类别代码
Property CPWCDCateCode As %String [ SqlColumnNumber = 3, SqlFieldName = CPWCD_CateCode ];

/// 费用类别名称
Property CPWCDCateName As %String [ SqlColumnNumber = 4, SqlFieldName = CPWCD_CateName ];

/// 计费项目名称
Property CPWCDItemName As %String [ SqlColumnNumber = 5, SqlFieldName = CPWCD_ItemName ];

/// 计费数量
Property CPWCDQty As %String [ SqlColumnNumber = 6, SqlFieldName = CPWCD_Qty ];

/// 计费单价
Property CPWCDUnitPrice As %String [ SqlColumnNumber = 7, SqlFieldName = CPWCD_UnitPrice ];

/// 计费金额
Property CPWCDAmount As %String [ SqlColumnNumber = 8, SqlFieldName = CPWCD_Amount ];

/// 费用发生日期
Property CPWCDHappenDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CPWCD_HappenDate ];

/// 单位
Property CPWCDUOM As %String [ SqlColumnNumber = 10, SqlFieldName = CPWCD_UOM ];

Index IndexPaAdm On CPWCDPaAdm As Exact;

Index IndexAdmHappDate On (CPWCDPaAdm, CPWCDHappenDate);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWCDPaAdm</Value>
</Value>
<Value name="3">
<Value>CPWCDCateCode</Value>
</Value>
<Value name="4">
<Value>CPWCDCateName</Value>
</Value>
<Value name="5">
<Value>CPWCDItemName</Value>
</Value>
<Value name="6">
<Value>CPWCDQty</Value>
</Value>
<Value name="7">
<Value>CPWCDUnitPrice</Value>
</Value>
<Value name="8">
<Value>CPWCDAmount</Value>
</Value>
<Value name="9">
<Value>CPWCDHappenDate</Value>
</Value>
<Value name="10">
<Value>CPWCDUOM</Value>
</Value>
</Data>
<DataLocation>^DHCMR("CPWCD")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("CPWCD")</IdLocation>
<IndexLocation>^DHCMRi("CPWCD",0)</IndexLocation>
<StreamLocation>User.DHCMRCClinPathWayCostDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
