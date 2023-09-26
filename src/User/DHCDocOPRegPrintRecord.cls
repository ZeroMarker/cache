Class User.DHCDocOPRegPrintRecord Extends %Persistent [ SqlTableName = DHC_DocOPRegPrintRecord, StorageStrategy = DHCDocOPRegPrintRecord ]
{

Relationship DHCDocOPRegPrintParRef As User.PAAdmExt [ Cardinality = parent, Inverse = ChildDHCDocOPRegPrint, Required, SqlFieldName = DHCDocOPRegPrintParRef ];

Index RowIDBasedIDKeyIndex On Childsub [ IdKey, PrimaryKey, Unique ];

Property Childsub As %Float [ InitialExpression = {$i(^DHCDocOPRegPrintRecord($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),0))}, SqlColumnNumber = 2, SqlFieldName = Childsub ];

/// 用户
Property UserID As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = UserID ];

/// 日期
Property PrintDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PrintDate ];

/// 时间
Property PrintTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PrintTime ];

/// 次数
Property Number As %String [ SqlColumnNumber = 6, SqlFieldName = Number ];

Storage DHCDocOPRegPrintRecord
{
<SQLMap name="DataMaster">
<Data name="Number">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UserID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_AdmExt.PAADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_AdmExt.PAADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPRegPrint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocOPRegPrintRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
