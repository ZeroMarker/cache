/// DHC_CL_Score
Class User.DHCCLScore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CLS_RowId, SqlTableName = DHC_CL_Score, StorageStrategy = CacheStorage ]
{

Parameter EXTENTSIZE = 10000;

/// CLS_Adm_Dr
Property CLSAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLS_Adm_Dr ];

/// CLS_Date
Property CLSDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = CLS_Date ];

/// CLS_Time
Property CLSTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = CLS_Time ];

Property CLSCLCSDr As User.DHCCLCScore [ SqlColumnNumber = 5, SqlFieldName = CLS_CLCS_Dr ];

Property CLSCLCSODr As User.DHCCLCScoreOption [ SqlColumnNumber = 6, SqlFieldName = CLS_CLCSO_Dr ];

Property CLSValue As %Float [ SqlColumnNumber = 7, SqlFieldName = CLS_Value ];

Property CLSMainCLSDr As User.DHCCLScore [ SqlColumnNumber = 8, SqlFieldName = CLS_MainCLS_Dr ];

/// CLS_UpdateDate
Property CLSUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = CLS_UpdateDate ];

/// CLS_UpdateTime
Property CLSUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = CLS_UpdateTime ];

/// CLS_UpdateUser_Dr
Property CLSUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CLS_UpdateUser_Dr ];

/// CLS_Icua_Dr
Property CLSIcuaDr As User.DHCICUArrange [ SqlColumnNumber = 12, SqlFieldName = CLS_Icua_Dr ];

/// CLS_EditFlag
Property CLSEditFlag As %Library.String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed,Pause,Undo,Ignore", MAXLEN = 7, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R,P,U,I") [ SqlColumnNumber = 13, SqlFieldName = CLS_EditFlag ];

/// CLS_OriginalScore
Property CLSOriginalScore As User.DHCCLScore [ SqlColumnNumber = 14, SqlFieldName = CLS_OriginalScore ];

/// CLS_EditedScore
Property CLSEditedScore As User.DHCCLScore [ SqlColumnNumber = 15, SqlFieldName = CLS_EditedScore ];

Index Adm On CLSAdmDr As Exact;

Index DateTime On (CLSDate As AlphaUp, CLSAdmDr As Exact, CLSTime As Plus);

Storage CacheStorage
{
<Data name="DHCCLScoreClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLScoreDefaultData">
<Value name="1">
<Value>CLSAdmDr</Value>
</Value>
<Value name="2">
<Value>CLSDate</Value>
</Value>
<Value name="3">
<Value>CLSTime</Value>
</Value>
<Value name="4">
<Value>CLSCLCSDr</Value>
</Value>
<Value name="5">
<Value>CLSCLCSODr</Value>
</Value>
<Value name="6">
<Value>CLSValue</Value>
</Value>
<Value name="7">
<Value>CLSMainCLSDr</Value>
</Value>
<Value name="8">
<Value>CLSUpdateDate</Value>
</Value>
<Value name="9">
<Value>CLSUpdateTime</Value>
</Value>
<Value name="10">
<Value>CLSUpdateUserDr</Value>
</Value>
<Value name="11">
<Value>CLSIcuaDr</Value>
</Value>
<Value name="12">
<Value>CLSEditFlag</Value>
</Value>
<Value name="13">
<Value>CLSOriginalScore</Value>
</Value>
<Value name="14">
<Value>CLSEditedScore</Value>
</Value>
</Data>
<DataLocation>^DHCCLScore</DataLocation>
<DefaultData>DHCCLScoreDefaultData</DefaultData>
<ExtentSize>10000</ExtentSize>
<IdLocation>^DHCCLScore</IdLocation>
<IndexLocation>^DHCCLScore(0)</IndexLocation>
<StreamLocation>^User.DHCCLScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
