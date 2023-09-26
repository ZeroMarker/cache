/// 清点合格率主表
Class User.CSSDSterPrdo Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SterPredo ]
{

Property CSSDSPNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDSP_No ];

Property CSSDSPLoc As CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDSP_Loc ];

Property CSSDSPDt As %TimeStamp [ SqlColumnNumber = 4, SqlFieldName = CSSDSP_Dt ];

Property CSSDSPRegister As SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDSP_Register ];

/// 单据状态：0-未确认 、1-确认
Property CSSDSPStatus As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSSDSP_Status ];

/// 灭菌批号
Property CSSDSPSterNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDSP_SterNo ];

/// 不合格日期
Property CSSDSPDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CSSDSP_Date ];

/// 不合格时间
Property CSSDSPTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CSSDSP_Time ];

Index IndexCSSDSPDt On CSSDSPDt As Exact;

Index IndexCSSDSPSterNo On CSSDSPSterNo As Exact;

Index IndexSterNoStatus On (CSSDSPSterNo As Exact, CSSDSPStatus As Exact);

Storage Default
{
<Data name="CSSDSterPrdoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSPNo</Value>
</Value>
<Value name="3">
<Value>CSSDSPLoc</Value>
</Value>
<Value name="4">
<Value>CSSDSPDt</Value>
</Value>
<Value name="5">
<Value>CSSDSPRegister</Value>
</Value>
<Value name="6">
<Value>CSSDSPStatus</Value>
</Value>
<Value name="7">
<Value>CSSDSPSterNo</Value>
</Value>
<Value name="8">
<Value>CSSDSPDate</Value>
</Value>
<Value name="9">
<Value>CSSDSPTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSterPrdoD</DataLocation>
<DefaultData>CSSDSterPrdoDefaultData</DefaultData>
<IdLocation>^User.CSSDSterPrdoD</IdLocation>
<IndexLocation>^User.CSSDSterPrdoI</IndexLocation>
<StreamLocation>^User.CSSDSterPrdoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
