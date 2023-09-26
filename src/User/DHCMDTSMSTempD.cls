Class User.DHCMDTSMSTempD Extends %Persistent [ SqlRowIdName = MS_RowID, SqlTableName = DHC_MDTSMSTempD, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On MSChlidSub [ IdKey, PrimaryKey, Unique ];

Relationship MSTempParRef As User.DHCMDTSMSTemp [ Cardinality = parent, Inverse = ChildDHCMDTSMSTEMPD, Required, SqlFieldName = MS_Temp_ParRef ];

/// MS_ChlidSub
Property MSChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MS_ChlidSub ];

/// 短消息  MS_Text 
Property MSText As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MS_Text ];

Storage NewStorage1
{
<SQLMap name="DateMaster">
<Data name="MS_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMDTSMST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MDTSMSTemp.MS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MS_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MDTSMSTemp.MS_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MS_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTSMSTempDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
