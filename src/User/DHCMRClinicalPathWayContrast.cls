/// 临床路径对照表
Class User.DHCMRClinicalPathWayContrast Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWC_RowId, SqlTableName = DHC_MR_ClinicalPathWayContrast ]
{

/// 临床路径 DHC_MRC_ClinPathWays
Property CPWCPathwayDR As User.DHCMRCClinPathWays [ SqlColumnNumber = 2, SqlFieldName = CPWC_Pathway_DR ];

/// 步骤 DHC_MRC_ClinPathWaysEpStep
Property CPWCEpStepDR As User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 3, SqlFieldName = CPWC_EpStep_DR ];

/// 步骤项目 DHC_MRC_ClinPathWaysEpStepItem
Property CPWCEpStepItemDR As User.DHCMRCClinPathWaysEpStepItem [ SqlColumnNumber = 4, SqlFieldName = CPWC_EpStepItem_DR ];

/// 对照项目
Property CPWCContItem As %String [ SqlColumnNumber = 5, SqlFieldName = CPWC_ContItem ];

/// 激活标志
Property CPWCActive As %String [ SqlColumnNumber = 6, SqlFieldName = CPWC_Active ];

/// 对照人
Property CPWCContUser As %String [ SqlColumnNumber = 7, SqlFieldName = CPWC_ContUser ];

/// 对照日期
Property CPWCContDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CPWC_ContDate ];

/// 对照时间
Property CPWCContTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CPWC_ContTime ];

/// 撤消人
Property CPWCUpdoUser As %String [ SqlColumnNumber = 10, SqlFieldName = CPWC_UpdoUser ];

/// 撤消日期
Property CPWCUpdoDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CPWC_UpdoDate ];

/// 撤消时间
Property CPWCUpdoTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CPWC_UpdoTime ];

/// 索引 临床路径、步骤、步骤项目
Index IndexCPWStepItem On (CPWCPathwayDR As Exact, CPWCEpStepDR As Exact, CPWCEpStepItemDR As Exact);

/// 索引 对照项目、步骤项目
Index IndexContStepItem On (CPWCContItem As Exact, CPWCEpStepItemDR As Exact);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWCPathwayDR</Value>
</Value>
<Value name="3">
<Value>CPWCEpStepDR</Value>
</Value>
<Value name="4">
<Value>CPWCEpStepItemDR</Value>
</Value>
<Value name="5">
<Value>CPWCContItem</Value>
</Value>
<Value name="6">
<Value>CPWCActive</Value>
</Value>
<Value name="7">
<Value>CPWCContUser</Value>
</Value>
<Value name="8">
<Value>CPWCContDate</Value>
</Value>
<Value name="9">
<Value>CPWCContTime</Value>
</Value>
<Value name="10">
<Value>CPWCUpdoUser</Value>
</Value>
<Value name="11">
<Value>CPWCUpdoDate</Value>
</Value>
<Value name="12">
<Value>CPWCUpdoTime</Value>
</Value>
</Data>
<DataLocation>^DHCMR("CPWC")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("CPWC")</IdLocation>
<IndexLocation>^DHCMRi("CPWC",0)</IndexLocation>
<StreamLocation>User.DHCMRClinicalPathWayContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
