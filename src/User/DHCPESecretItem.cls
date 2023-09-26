Class User.DHCPESecretItem Extends %Persistent [ ClassType = persistent, SqlTableName = DHC_PE_SecretItem, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On DHCPESecretChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DHCPESecretParRef As User.DHCPESecretPAADM [ Cardinality = parent, Inverse = ChildDHCPESecretItem, Required, SqlFieldName = DHCPESecretParRef ];

Property DHCPESecretChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPESecretPAADM1($p(%d(0),$c(1),1),"S",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCPESecretChildSub ];

/// 医嘱名称
Property ItemDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = ItemDesc ];

/// 医嘱Code
Property ItemCode As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ItemCode ];

/// 院外医嘱id
Property OutOrdItemID As %Library.String [ SqlColumnNumber = 5, SqlFieldName = OutOrdItemID ];

/// 院内医嘱id
Property InOrdItemID As %Library.String [ SqlColumnNumber = 6, SqlFieldName = InOrdItemID ];

/// 院外条码号 OEORI_LabEpisodeNo
Property OutLabEpisodeNo As %Library.String [ SqlColumnNumber = 7, SqlFieldName = OutLabEpisodeNo ];

/// 院内条码号 OEORI_LabEpisodeNo
Property InLabEpisodeNo As %Library.String [ SqlColumnNumber = 8, SqlFieldName = InLabEpisodeNo ];

/// 院外项目id
Property OutPreIOrdItemID As %Library.String [ SqlColumnNumber = 9, SqlFieldName = OutPreIOrdItemID ];

/// 院内项目id
Property InPreIOrdItemID As %Library.String [ SqlColumnNumber = 10, SqlFieldName = InPreIOrdItemID ];

/// 状态 是否导出 N Y 
Property ExportStatus As %Library.String [ SqlColumnNumber = 11, SqlFieldName = ExportStatus ];

Storage NewStorage1
{
<SQLMap name="Data">
<Data name="ExportStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="InLabEpisodeNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InOrdItemID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InPreIOrdItemID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OutLabEpisodeNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OutOrdItemID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OutPreIOrdItemID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_SecretPAADM.RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCPESecretChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PE_SecretPAADM.RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPESecretChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInPreIOrdItemDR">
<Global>^DHCPESecretPAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_SecretPAADM.RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCPESecretChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InPreIOrdItemDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_SecretPAADM.RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InPreIOrdItemID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPESecretChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutItem">
<Global>^DHCPESecretPAADMi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutOrdItemID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_SecretPAADM.RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPESecretChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutPreIOrdItemDR">
<Global>^DHCPESecretPAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_SecretPAADM.RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCPESecretChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutPreIOrdItemDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_SecretPAADM.RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutPreIOrdItemID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPESecretChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESecretItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
