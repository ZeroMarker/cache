/// 预处理合格率明细
Class User.CSSDUsedPredoDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_UsedPredoDetail ]
{

Property CSSDUPDMainDr As User.CSSDUsedPrdo [ SqlColumnNumber = 2, SqlFieldName = CSSDUPD_MainDr ];

Property CSSDUPDItm As User.CSSDItem [ SqlColumnNumber = 3, SqlFieldName = CSSDUPD_Itm ];

/// 明细汇总数量
Property CSSDUPDSumNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = CSSDUPD_SumNum ];

Property CSSDUPDQueSumNum As User.CSSDCleanItmLocation [ SqlColumnNumber = 5, SqlFieldName = CSSDUPD_QueSumNum ];

/// 标牌追溯包标牌编码
Property CSSDUPDBarCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDUPD_BarCode ];

Property CSSDUPDQueWhy As User.CSSDCleanItmReason [ SqlColumnNumber = 7, SqlFieldName = CSSDUPD_QueWhy ];

Property CSSDUPDQxpcNum As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDUP_QxpcNum ];

Property CSSDUPDQxr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CSSDUPD_Qxr ];

Property CSSDUPDChuli As %Integer [ SqlColumnNumber = 10, SqlFieldName = CSSDUPD_Chuli ];

Property CSSDUPDPkg As User.CSSDPackage [ SqlColumnNumber = 11, SqlFieldName = CSSDUPD_Pkg ];

Property CSSDUPDReasonAnalysis As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDUPD_ReasonAnalysis ];

Property CSSDUPDImprove As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDUPD_Improve ];

/// 不合格包数量
Property CSSDUPDPkgNum As %Integer [ SqlColumnNumber = 14, SqlFieldName = CSSDUPD_PkgNum ];

/// 清洗明细id
Property CSSDUPDCleanDetailDr As User.CSSDCleanDetailPacks [ SqlColumnNumber = 15, SqlFieldName = CSSDUPD_CleanDetailDr ];

/// 是否已再次清洗状态：Y-已完成清洗
Property CSSDUPDStates As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDUPD_States ];

Index CSSDUPDMainDrIndex On CSSDUPDMainDr As Exact;

Index CSSDUPDMainDrItmPkgIndex On (CSSDUPDMainDr As Exact, CSSDUPDItm As Exact, CSSDUPDPkg As Exact);

Index CSSDUPDMainDrItmIndex On (CSSDUPDMainDr As Exact, CSSDUPDItm As Exact);

Index CSSDUPDMainCleanDPkgIndex On (CSSDUPDMainDr As Exact, CSSDUPDCleanDetailDr As Exact, CSSDUPDPkg As Exact);

Index CSSDUPDMainCleanDItmIndex On (CSSDUPDMainDr As Exact, CSSDUPDCleanDetailDr As Exact, CSSDUPDItm As Exact);

Index CSSDUPDCleanDItmIndex On CSSDUPDCleanDetailDr As Exact;

Index CSSDUPDCleanDItmUPDItmIndex On (CSSDUPDCleanDetailDr As Exact, CSSDUPDItm As Exact);

Storage Default
{
<Data name="CSSDUsedPredoDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDUPDMainDr</Value>
</Value>
<Value name="3">
<Value>CSSDUPDItm</Value>
</Value>
<Value name="4">
<Value>CSSDUPDSumNum</Value>
</Value>
<Value name="5">
<Value>CSSDUPDQueSumNum</Value>
</Value>
<Value name="6">
<Value>CSSDUPDBarCode</Value>
</Value>
<Value name="7">
<Value>CSSDUPDQueWhy</Value>
</Value>
<Value name="8">
<Value>CSSDUPDQxpcNum</Value>
</Value>
<Value name="9">
<Value>CSSDUPDQxr</Value>
</Value>
<Value name="10">
<Value>CSSDUPDChuli</Value>
</Value>
<Value name="11">
<Value>CSSDUPDPkg</Value>
</Value>
<Value name="12">
<Value>CSSDUPDReasonAnalysis</Value>
</Value>
<Value name="13">
<Value>CSSDUPDImprove</Value>
</Value>
<Value name="14">
<Value>CSSDUPDPkgNum</Value>
</Value>
<Value name="15">
<Value>CSSDUPDCleanDetailDr</Value>
</Value>
<Value name="16">
<Value>CSSDUPDStates</Value>
</Value>
</Data>
<DataLocation>^User.CSSDUsedPredoDetailD</DataLocation>
<DefaultData>CSSDUsedPredoDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDUsedPredoDetailD</IdLocation>
<IndexLocation>^User.CSSDUsedPredoDetailI</IndexLocation>
<StreamLocation>^User.CSSDUsedPredoDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
