Class User.DHCMedAdvRepFile Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDF_RowID, SqlTableName = DHC_MedAdvRepFile, StorageStrategy = NewStorage1 ]
{

//审核id/转抄id  

Property MEDFPointer As %String [ SqlColumnNumber = 2, SqlFieldName = MEDF_Pointer ];

// 审核/转抄

Property MEDFType As %String [ SqlColumnNumber = 3, SqlFieldName = MEDF_Type ];

//上传人  SS_User

Property MEDFUpdUserDR As %String [ SqlColumnNumber = 4, SqlFieldName = MEDF_UpdUser_DR ];

//上传日期

Property MEDFUpdDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MEDF_UpdDate ];

//上传时间

Property MEDFUpdTime As %Time [ SqlColumnNumber = 6, SqlFieldName = MEDF_UpdTime ];

//	附件名

Property MEDFLoadFile As %String [ SqlColumnNumber = 7, SqlFieldName = MEDF_LoadFile ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCMEDREPFI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MEDF_LoadFile">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEDF_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDF_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDF_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDF_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDF_UpdUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMEDREPFI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFileName">
<Global>^DHCMEDREPFI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MEDF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FileName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDF_LoadFile}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeP">
<Global>^DHCMEDREPFI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEDF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDF_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDF_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdvRepFileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
