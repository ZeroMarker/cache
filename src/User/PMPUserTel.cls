Class User.PMPUserTel Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UL_Rowid, SqlTableName = PMP_UserTel, StorageStrategy = SQLStorage ]
{

/// ULuserid
Property ULuserid As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UL_Userid ];

/// ULTel
Property ULTel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UL_Tel ];

/// UL_Flag
Property ULYFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = UL_Flag ];

/// UL_Remark
Property ULRemark As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UL_Remark ];

/// UL_Standby1
Property ULStandby1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UL_Standby1 ];

/// UL_Standby2
Property ULStandby2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UL_Standby2 ];

/// UL_Loc
Property ULLoc As CTLoc [ SqlColumnNumber = 8, SqlFieldName = UL_Loc ];

/// UL_Email
Property ULEmail As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UL_Email ];

/// UL_Standby3
Property ULStandby3 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UL_Standby3 ];

/// ULProjectUser
Property ULProjectUser As PMPProjectUser [ SqlColumnNumber = 11, SqlFieldName = UL_ProjectUser ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMPUserTel("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="UL_Email">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UL_Loc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UL_ProjectUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UL_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UL_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UL_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UL_Tel">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UL_Userid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPUserTel</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofProjectUser">
<Global>^PMPUserTeli</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ProjectUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UL_ProjectUser}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUserId">
<Global>^PMPUserTeli</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UL_Userid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UL_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPUserTelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
