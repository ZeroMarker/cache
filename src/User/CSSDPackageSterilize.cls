Class User.CSSDPackageSterilize Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDPS_Rowid, SqlTableName = CSSD_PackageSterilize ]
{

Property CSSDPSLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDPS_Label ];

/// 召回日期
Property CSSDPSRecallDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = CSSDPS_RecallDate ];

/// 召回时间
Property CSSDPSRecallTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = CSSDPS_RecallTime ];

Property CSSDPSQty As %Numeric [ SqlColumnNumber = 6, SqlFieldName = CSSDPS_Qty ];

Property CSSDPSSerialNo As %Numeric [ Required, SqlColumnNumber = 7, SqlFieldName = CSSDPS_SerialNo ];

Property CSSDPSPackage As User.CSSDPackage [ SqlColumnNumber = 12, SqlFieldName = CSSDPS_Package_DR ];

Property CSSDPSParref As User.CSSDSterilizeRecord [ Required, SqlColumnNumber = 13, SqlFieldName = CSSDPS_Parref_DR ];

/// 召回标识
Property CSSDPSRecallFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDPS_RecallFlag ];

/// 召回原因
Property CSSDPSRecallReason As User.CSSDRecallReason [ SqlColumnNumber = 15, SqlFieldName = CSSDPS_RecallReson ];

/// 召回人
Property CSSDPSRecallUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CSSDPS_RecallUser ];

/// 召回时间
Property CSSDPSRecallDateTime As %Library.TimeStamp [ SqlColumnNumber = 17, SqlFieldName = CSSDPS_RecallDateTime ];

/// 合格状态：Y-合格 、N-不合格
Property CSSDPSStates As %String(COLLATION = "Exact") [ SqlColumnNumber = 22, SqlFieldName = CSSDPS_States ];

/// 不合格原因
Property CSSDPSReason As User.CSSDSteCheckReason [ SqlColumnNumber = 23, SqlFieldName = CSSDPS_Reason ];

Index IndexCSSDPSParref On CSSDPSParref As Exact;

Index IndexCSSDPSParrefLabel On (CSSDPSParref As Exact, CSSDPSLabel As Exact);

Index IndexCSSDPSLabel On CSSDPSLabel As Exact;

Storage Default
{
<Data name="CSSDPackageSterilizeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3">
<Value>CSSDPSLabel</Value>
</Value>
<Value name="4">
<Value>CSSDPSRecallDate</Value>
</Value>
<Value name="5">
<Value>CSSDPSRecallTime</Value>
</Value>
<Value name="6">
<Value>CSSDPSQty</Value>
</Value>
<Value name="7">
<Value>CSSDPSSerialNo</Value>
</Value>
<Value name="8"/>
<Value name="9"/>
<Value name="10"/>
<Value name="11"/>
<Value name="12">
<Value>CSSDPSPackage</Value>
</Value>
<Value name="13">
<Value>CSSDPSParref</Value>
</Value>
<Value name="14">
<Value>CSSDPSRecallFlag</Value>
</Value>
<Value name="15">
<Value>CSSDPSRecallReason</Value>
</Value>
<Value name="16">
<Value>CSSDPSRecallUser</Value>
</Value>
<Value name="17">
<Value>CSSDPSRecallDateTime</Value>
</Value>
<Value name="18"/>
<Value name="19"/>
<Value name="20"/>
<Value name="21"/>
<Value name="22">
<Value>CSSDPSStates</Value>
</Value>
<Value name="23">
<Value>CSSDPSReason</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageSterilizeD</DataLocation>
<DefaultData>CSSDPackageSterilizeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageSterilizeD</IdLocation>
<IndexLocation>^User.CSSDPackageSterilizeI</IndexLocation>
<SqlRowIdName>CSSDPS_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackageSterilizeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
