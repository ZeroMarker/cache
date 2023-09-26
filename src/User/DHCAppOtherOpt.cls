Class User.DHCAppOtherOpt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AO_RowID, SqlTableName = DHC_AppOtherOpt, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPOTHEROPTITM As User.DHCAppOtherOptItm [ Cardinality = children, Inverse = AOIOptParRef ];

/// 代码  AO_Code
Property AOCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AO_Code ];

/// 描述  AO_Desc
Property AODesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AO_Desc ];

/// 内容类型  AO_Type
Property AOType As %Library.String(DISPLAYLIST = ",Input,Check,Combox,Order", MAXLEN = 6, SELECTIVITY = "25%", VALUELIST = ",Input,Check,Combox,Order") [ SqlColumnNumber = 4, SqlFieldName = AO_Type ];

/// 是否必填  AO_Required
Property AORequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AO_Required ];

/// 集团化医院  AO_Hosp_Dr
Property AOHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = AO_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPOTHO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AO_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AO_Required">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AO_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPOTHO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppOtherOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
