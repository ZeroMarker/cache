Class User.DHCWMREPRExamRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WEER_Rowid, SqlTableName = DHC_WMR_EPRExamRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WEER_EPRContent
Property WEEREPRContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = WEER_EPRContent ];

/// WEER_EventType
Property WEEREventType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WEER_EventType ];

/// WEER_ControlType
Property WEERControlType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WEER_ControlType ];

/// WEER_ExamRuleID
Property WEERExamRuleID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = WEER_ExamRuleID ];

/// WEER_IsActive
Property WEERIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = WEER_IsActive ];

/// WEER_Resume
Property WEERResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = WEER_Resume ];

/// WEER_Text1
Property WEERText1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = WEER_Text1 ];

/// WEER_Text2
Property WEERText2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = WEER_Text2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMREPRER(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="WEER_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WEER_EPRContent">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WEER_EventType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WEER_ExamRuleID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WEER_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WEER_Resume">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WEER_Text1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WEER_Text2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCWMREPRER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WEER_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WEER_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContentEvent">
<Global>^DHCWMREPRER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WEER_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CountEvent"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WEER_EPRContent}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WEER_EventType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WEER_IsActive}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{WEER_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMREPRExamRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
