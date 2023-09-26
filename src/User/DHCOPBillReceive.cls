Class User.DHCOPBillReceive Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPRec_RowId, SqlTableName = DHC_OPBillReceive, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPRec_Date
Property OPRecDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = OPRec_Date ];

/// OPRec_Time
Property OPRecTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = OPRec_Time ];

/// OPRec_User_DR
Property OPRecUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = OPRec_User_DR ];

/// OPRec_StDate
Property OPRecStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = OPRec_StDate ];

/// OPRec_EndDate
Property OPRecEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OPRec_EndDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPBILLRECEIVE)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="OPRec_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPRec_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPRec_StDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPRec_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPRec_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCOPBILLRECEIVE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCOPBILLRECEIVEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPRec_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUserDR">
<Global>^DHCOPBILLRECEIVEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPREC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USERDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPRec_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPREC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPBillReceiveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
