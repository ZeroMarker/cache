Class User.DHCANOPMaterialList Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANOPMaterial_RowId, SqlTableName = DHC_AN_OpMaterialList, StorageStrategy = CacheStorage ]
{

Property ANOPMOpaId As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = ANOPM_OpaId ];

/// cailiao
/// 消毒供应包Dr
Property ANOPMCssdDr As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = ANOP_MCssdDr ];

/// 消毒供应包数量
Property ANOPMCssdNum As %String [ SqlColumnNumber = 4, SqlFieldName = ANOP_MCssdNum ];

/// 更新人
Property ANOPMUpdateUserDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANOP_MUpdateUserDr ];

/// 更新日期
Property ANOPMUpdateDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = ANOP_MUpdateDate ];

/// 更新时间
Property ANOPMUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = ANOP_MUpdateTime ];

Storage CacheStorage
{
<Data name="Class">
<Subscript>0</Subscript>
</Data>
<Data name="Data">
<Value name="1">
<Value>ANOPMCssdDr</Value>
</Value>
<Value name="2">
<Value>ANOPMCssdNum</Value>
</Value>
<Value name="3">
<Value>ANOPMUpdateUserDr</Value>
</Value>
<Value name="4">
<Value>ANOPMUpdateDate</Value>
</Value>
<Value name="5">
<Value>ANOPMUpdateTime</Value>
</Value>
<Value name="6">
<Value>ANOPMOpaId</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCANOPMaterial("MDetail")</DataLocation>
<DefaultData>Data</DefaultData>
<IdLocation>^DHCANOPMaterial("MDetail")</IdLocation>
<IndexLocation>^DHCANOPMaterial("MDetail",0)</IndexLocation>
<SqlRowIdName>ANOPMaterial_RowId</SqlRowIdName>
<StreamLocation>^User.DHCANOPMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index CSSDOnOpaId On ANOPMOpaId As Exact;

}
