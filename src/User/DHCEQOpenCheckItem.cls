Class User.DHCEQOpenCheckItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OCI_RowID, SqlTableName = DHC_EQOpenCheckItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OCI_OpenCheckRequestDR
Property OCIOpenCheckRequestDR As User.DHCEQOpenCheckRequest [ SqlColumnNumber = 2, SqlFieldName = OCI_OpenCheckRequestDR ];

/// OCI_CheckItemDR
Property OCICheckItemDR As User.DHCEQCCheckItem [ SqlColumnNumber = 3, SqlFieldName = OCI_CheckItemDR ];

/// OCI_CheckContent
Property OCICheckContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OCI_CheckContent ];

/// OCI_CheckResultDR
Property OCICheckResultDR As User.DHCEQCCheckResult [ SqlColumnNumber = 5, SqlFieldName = OCI_CheckResultDR ];

/// OCI_CheckResultRemark
Property OCICheckResultRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OCI_CheckResultRemark ];

/// OCI_NormalFlag
Property OCINormalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = OCI_NormalFlag ];

/// OCI_Remark
Property OCIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OCI_Remark ];

/// OCI_Users
Property OCIUsers As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OCI_Users ];

/// OCI_Date
Property OCIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = OCI_Date ];

/// OCI_Time
Property OCITime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = OCI_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOpenCheckItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OCI_CheckContent">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OCI_CheckItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCI_CheckResultDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OCI_CheckResultRemark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OCI_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCI_NormalFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCI_OpenCheckRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OCI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OCI_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OCI_Users">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQOpenCheckItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OCI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNormalFlag">
<Global>^DHCEQOpenCheckItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NormalFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_OpenCheckRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_NormalFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpenCheckRequest">
<Global>^DHCEQOpenCheckItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpenCheckRequest"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCI_OpenCheckRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOpenCheckItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
