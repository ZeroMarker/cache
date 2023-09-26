Class User.DHCAppOtherOptItm Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AppOtherOptItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On AOIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppOtherOpt Parent Reference AIT_Temp_ParRef
Relationship AOIOptParRef As User.DHCAppOtherOpt [ Cardinality = parent, Inverse = ChildDHCAPPOTHEROPTITM, Required, SqlFieldName = AOI_Opt_ParRef ];

/// AOI_ChildSub
Property AOIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AOI_ChildSub ];

/// 代码  AOI_Code 
Property AOICode As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AOI_Code ];

/// 描述  AOI_Desc 
Property AOIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AOI_Desc ];

/// 医嘱 AOI_Arcim 
Property AOIArcim As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = AOI_Arcim ];

/// 医嘱数量  AOI_ArcimNumber 
Property AOIArcimNumber As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AOI_ArcimNumber ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AOI_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AOI_ArcimNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AOI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AOI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPOTHO</Global>
<Subscript name="1">
<Expression>{DHC_AppOtherOpt.AO_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AOI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppOtherOptItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
