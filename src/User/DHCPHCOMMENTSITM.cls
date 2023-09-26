Class User.DHCPHCOMMENTSITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCNTSI_RowID, SqlTableName = DHC_PHCOMMENTSITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PCNTSIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPHCOMMENTSLOG As User.DHCPHCOMMENTSLOG [ Cardinality = children, Inverse = PCNTSLParRefDr ];

/// DHC_PHCOMMENTS Parent Reference
Relationship PCNTSIParRefDr As User.DHCPHCOMMENTS [ Cardinality = parent, Inverse = ChildDHCPHCOMMENTSITM, Required, SqlFieldName = PCNTSI_ParRef_Dr ];

/// PCNTSI_ChildSub
Property PCNTSIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PCNTSI_ChildSub ];

/// PCNTSI_PrescNo
Property PCNTSIPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCNTSI_PrescNo ];

/// PCNTSI_OrdItem_Dr
Property PCNTSIOrdItemDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = PCNTSI_OrdItem_Dr ];

/// PCNTSI_Adm_Dr
Property PCNTSIAdmDr As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = PCNTSI_Adm_Dr ];

/// PCNTSI_DocLoc_Dr
Property PCNTSIDocLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PCNTSI_DocLoc_Dr ];

/// PCNTSI_Doc_Dr
Property PCNTSIDocDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PCNTSI_Doc_Dr ];

/// PCNTSI_CurrRet
Property PCNTSICurrRet As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PCNTSI_CurrRet ];

/// 把一个处方分配给医生去点评
/// PCNTSI_AllotUser_Dr  
Property PCNTSIAllotUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PCNTSI_AllotUser_Dr ];

/// PCNTSI_PassVal  预审核结果
Property PCNTSIPassVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PCNTSI_PassVal ];

/// 点评单状态
Property PCNTSIStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PCNTSI_Status ];

/// PCNTSI_CntItm_Dr
Property PCNTSICntItmDr As User.DHCPHCOMMENTSITM [ SqlColumnNumber = 12, SqlFieldName = PCNTSI_CntItm_Dr ];

/// 备注
Property PCNTSINote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PCNTSI_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexAdm">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PCNTSI_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAllotUser">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AllotUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSI_AllotUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCntItm">
<Global>^DHCPHCNTS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCNTSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CntItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSI_CntItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCNTSI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PCNTSI_OrdItem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSI_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCNTSI_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCNTSI_AllotUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCNTSI_CntItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCNTSI_CurrRet">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCNTSI_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCNTSI_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCNTSI_Note">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCNTSI_OrdItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCNTSI_PassVal">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCNTSI_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCNTSI_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHCNTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PCNTSI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PCNTSI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCOMMENTSITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
