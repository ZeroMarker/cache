Class User.DHCPHConsultDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCONTD_RowID, SqlTableName = DHC_PHConsultDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCONTDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHConsult Parent Reference
Relationship PHCONTDCONParRef As User.DHCPHConsult [ Cardinality = parent, Inverse = ChildDHCPHConsultDetail, Required, SqlFieldName = PHCONTD_CON_ParRef ];

/// PHCONTD_Date
Property PHCONTDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCONTD_Date ];

/// PHCONTD_Time
Property PHCONTDTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHCONTD_Time ];

/// PHCONTD_User_Dr
Property PHCONTDUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHCONTD_User_Dr ];

/// PHCONTD_Desc
Property PHCONTDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHCONTD_Desc ];

/// PHCONTD_Cont_Dr
Property PHCONTDContDr As User.DHCPHConsultDetail [ SqlColumnNumber = 6, SqlFieldName = PHCONTD_Cont_Dr ];

/// PHCONTD_OkFlag
Property PHCONTDOkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHCONTD_OkFlag ];

/// PHCONTD_ChildSub
Property PHCONTDChildSub As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHCONTD_ChildSub ];

/// PHCONTD_ConB_Dr 
/// 存储单一或者一系列类似"1|2|3"，用来指向User.DHCPHConsultBasis的ID
Property PHCONTDConBDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHCONTD_ConB_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHCONTD_ConB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCONTD_Cont_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCONTD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCONTD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCONTD_OkFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCONTD_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCONTD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHCOND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHConsult.PHCON_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCONTD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHConsult.PHCON_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCONTD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConsultDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
