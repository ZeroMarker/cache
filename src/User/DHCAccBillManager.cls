Class User.DHCAccBillManager Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccBM_RowID, SqlTableName = DHC_AccBillManager, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// the Number of begining
Property AccBMBeginNum As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AccBM_BeginNum ];

/// the Number of Current
Property AccBMCurNum As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccBM_CurNum ];

/// the Day of Getting the Number 
Property AccBMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AccBM_Date ];

/// the Number of end
Property AccBMEndNum As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AccBM_EndNum ];

/// the Priority 
Property AccBMPriority As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AccBM_Priority ];

/// the Time of Getting the Number
Property AccBMTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AccBM_Time ];

/// AccBM_UseFlag
Property AccBMUseFlag As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = AccBM_UseFlag ];

/// AccBM_User_DR
Property AccBMUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AccBM_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACD("AccBM"))</SqlIdExpression>
<SQLMap name="MastrMap">
<Data name="AccBM_BeginNum">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccBM_CurNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccBM_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccBM_EndNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccBM_Priority">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccBM_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccBM_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccBM_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AccBM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccBM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AccBM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccBillManagerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
