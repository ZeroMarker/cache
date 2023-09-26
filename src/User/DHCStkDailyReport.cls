Class User.DHCStkDailyReport Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDR_RowID, SqlTableName = DHC_StkDailyReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDRChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCStkDailyReportTrans As User.DHCStkDailyReportTrans [ Cardinality = children, Inverse = SDRTSDRParref ];

/// DHC_StkDaily Parent Reference
Relationship SDRSDParref As User.DHCStkDaily [ Cardinality = parent, Inverse = ChildDHCStkDailyReport, Required, SqlFieldName = SDR_SD_Parref ];

/// SDR_ChildSub
Property SDRChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SDR_ChildSub ];

/// SDR_Inci_Dr
Property SDRInciDr As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = SDR_Inci_Dr ];

/// SDR_InciRp
Property SDRInciRp As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SDR_InciRp ];

/// SDR_InciSp
Property SDRInciSp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SDR_InciSp ];

/// SDR_DispQty
Property SDRDispQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SDR_DispQty ];

/// SDR_DispRpAmt
Property SDRDispRpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SDR_DispRpAmt ];

/// SDR_DispSpAmt
Property SDRDispSpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SDR_DispSpAmt ];

/// SDR_RetQty
Property SDRRetQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SDR_RetQty ];

/// SDR_RetRpAmt
Property SDRRetRpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SDR_RetRpAmt ];

/// SDR_RetSpAmt
Property SDRRetSpAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SDR_RetSpAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterDataDHCSDR">
<Data name="SDR_DispQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SDR_DispRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SDR_DispSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SDR_InciRp">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDR_InciSp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDR_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDR_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SDR_RetRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SDR_RetSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCSDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkDaily.SD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SDR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkDaily.SD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SDR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDailyReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
