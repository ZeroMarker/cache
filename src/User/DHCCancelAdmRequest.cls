Class User.DHCCancelAdmRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Cancel_RowID, SqlTableName = DHC_CancelAdmRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Cancel_Adm
Property CancelAdm As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = Cancel_Adm ];

/// Cancel_Date
Property CancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Cancel_Date ];

/// Cancel_Time
Property CancelTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = Cancel_Time ];

/// Cancel_User
Property CancelUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = Cancel_User ];

/// Cancel_Comment
Property CancelComment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Cancel_Comment ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCANCELADMREQUEST)</SqlIdExpression>
<SQLMap name="MasterDHCCANCELADMREQUEST">
<Data name="Cancel_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Cancel_Comment">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Cancel_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Cancel_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Cancel_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCANCELADMREQUEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Cancel_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Cancel_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCancelAdmRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
