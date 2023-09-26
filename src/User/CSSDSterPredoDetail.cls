/// 灭菌不合格登记
Class User.CSSDSterPredoDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SterPredoDetail ]
{

Property CSSDSPDMainDr As User.CSSDSterPrdo [ SqlColumnNumber = 2, SqlFieldName = CSSDSPD_MainDr ];

Property CSSDSPDNum As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDSPD_Num ];

Property CSSDUPDListType As %Integer [ SqlColumnNumber = 4, SqlFieldName = CSSDSPD_ListType ];

Property CSSDSUPDSterNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDSPD_SterNo ];

Property CSSDSPDResion As User.CSSDSteCheckReason [ SqlColumnNumber = 6, SqlFieldName = CSSDSPD_Resion ];

Property CSSDSPDReasonAnalysis As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDSPD_ReasonAnalysis ];

Property CSSDSPDImprove As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDSPD_Improve ];

Property CSSDSPPackage As User.CSSDPackage [ SqlColumnNumber = 9, SqlFieldName = CSSDSP_Package_DR ];

/// 灭菌的是否已再次清洗或灭菌状态：Y-已完成清洗或灭菌（部分医院灭菌不合格要重新清洗）
Property CSSDSPStates As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDSP_States ];

/// 绑定从待灭菌不合格包弹窗再次清洗的清洗明细ID 用以当此明细删除后回制灭菌不合格明细状态
Property CSSDSPCleanDetailDr As User.CSSDCleanDetailPacks [ SqlColumnNumber = 11, SqlFieldName = CSSDSP_CleanDetailDr ];

Index IndexLable On CSSDSPDNum As Exact;

Index IndexMainDr On CSSDSPDMainDr As Exact;

Index IndexMainDrLable On (CSSDSPDMainDr As Exact, CSSDSPDNum As Exact);

Index IndexCleanDetailDr On CSSDSPCleanDetailDr As Exact;

Storage Default
{
<Data name="CSSDSterPredoDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSPDMainDr</Value>
</Value>
<Value name="3">
<Value>CSSDSPDNum</Value>
</Value>
<Value name="4">
<Value>CSSDUPDListType</Value>
</Value>
<Value name="5">
<Value>CSSDSUPDSterNo</Value>
</Value>
<Value name="6">
<Value>CSSDSPDResion</Value>
</Value>
<Value name="7">
<Value>CSSDSPDReasonAnalysis</Value>
</Value>
<Value name="8">
<Value>CSSDSPDImprove</Value>
</Value>
<Value name="9">
<Value>CSSDSPPackage</Value>
</Value>
<Value name="10">
<Value>CSSDSPStates</Value>
</Value>
<Value name="11">
<Value>CSSDSPCleanDetailDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSterPredoDetailD</DataLocation>
<DefaultData>CSSDSterPredoDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDSterPredoDetailD</IdLocation>
<IndexLocation>^User.CSSDSterPredoDetailI</IndexLocation>
<StreamLocation>^User.CSSDSterPredoDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
