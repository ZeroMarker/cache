/// Description:  医生站代码外部对照表
Class User.DHCDocExtData Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MUC_Rowid, SqlTableName = DHC_DocExtData, StorageStrategy = SQLStorage ]
{

/// MUC_TypeDR
Property MUCTypeDR As DHCDocCTExtDataType [ SqlColumnNumber = 2, SqlFieldName = MUC_TypeDR ];

/// MUC_LocalDR
Property MUCLocalDR As %Library.String [ SqlColumnNumber = 3, SqlFieldName = MUC_LocalDR ];

/// MUC_LocalCode
Property MUCLocalCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = MUC_LocalCode ];

/// MUC_LocalDesc
Property MUCLocalDesc As %Library.String [ SqlColumnNumber = 5, SqlFieldName = MUC_LocalDesc ];

/// MUC_ExtCode
Property MUCExtCode As %Library.String [ SqlColumnNumber = 6, SqlFieldName = MUC_ExtCode ];

/// MUC_ExtDesc
Property MUCExtDesc As %Library.String [ SqlColumnNumber = 7, SqlFieldName = MUC_ExtDesc ];

/// MUC_Active
Property MUCActive As %Library.String(DISPLAYLIST = ",Yes,NO", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MUC_Active ];

/// MUC_ExtOrgDr
Property MUCExtOrgDr As User.DHCDocCTExtDataExtOrg [ SqlColumnNumber = 9, SqlFieldName = MUC_ExtOrgDr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMUC("MUC"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MUC_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MUC_ExtCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MUC_ExtDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MUC_ExtOrgDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MUC_LocalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MUC_LocalDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MUC_LocalDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MUC_TypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MUC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExtOrg">
<Global>^DHCMUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtOrg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_ExtOrgDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfExtLocalDR">
<Global>^DHCMUC</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtTYPELOCALDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_ExtOrgDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUC_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MUC_LocalDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfExtType">
<Global>^DHCMUC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_ExtOrgDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUC_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfLocalDR">
<Global>^DHCMUC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPELOCALDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_TypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUC_LocalDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfType">
<Global>^DHCMUC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MUC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUC_TypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MUC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedUnionCardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
