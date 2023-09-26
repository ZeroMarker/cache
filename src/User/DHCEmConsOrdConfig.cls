Class User.DHCEmConsOrdConfig Extends %Persistent [ SqlRowIdName = ECOC_RowID, SqlTableName = DHC_EmConsOrdConfig, StorageStrategy = SQLStorage ]
{

/// ECOC_RepLoc_Dr	申请科室 0:全院通用,其他:科室ID
Property ECOCRepLocDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ECOC_RepLoc_Dr ];

/// ECOC_ArcItem_Dr	医嘱项
Property ECOCArcItemDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ECOC_ArcItem_Dr ];

/// ECOC_Type 会诊类型  0院内单科，1院内多科，2院外单科，3院外多科
Property ECOCType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = ECOC_Type ];

/// ECOC_DocType_Dr	职称
Property ECOCDocTypeDr As User.CTCarPrvTp [ SqlColumnNumber = 5, SqlFieldName = ECOC_DocType_Dr ];

/// ECOC_InsertType	生成方式  0申请生成 1执行生成
Property ECOCInsertType As %Library.String [ SqlColumnNumber = 6, SqlFieldName = ECOC_InsertType ];

/// ECOC_Nat_Dr	会诊性质
Property ECOCNatDr As User.DHCEmConsDicItem [ SqlColumnNumber = 7, SqlFieldName = ECOC_Nat_Dr ];

/// ECOC_Hosp_Dr 集团化医院
Property ECOCHospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = ECOC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONSOC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ECOC_ArcItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ECOC_DocType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ECOC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ECOC_InsertType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ECOC_Nat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ECOC_RepLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ECOC_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMCONSOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ECOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ECOC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^DHCEMCONSOC</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ECOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECOC_InsertType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECOC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ECOC_RepLoc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ECOC_DocType_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ECOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeHosp">
<Global>^DHCEMCONSOC</Global>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ECOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeHosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECOC_InsertType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECOC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ECOC_RepLoc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ECOC_DocType_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ECOC_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ECOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeLoc">
<Global>^DHCEMCONSOC</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ECOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECOC_InsertType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECOC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ECOC_RepLoc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ECOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvTp">
<Global>^DHCEMCONSOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ECOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ProvTp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECOC_DocType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsOrdConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
