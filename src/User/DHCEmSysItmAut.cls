Class User.DHCEmSysItmAut Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SA_RowID, SqlTableName = DHC_EmSysItmAut, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SAChlidSub [ IdKey, PrimaryKey, Unique ];

/// 父表ID SA_ParRef_Dr
Relationship SAParRefDr As User.DHCEmSysItm [ Cardinality = parent, Inverse = ChildDHCEmSysItmAut, Required, SqlFieldName = SA_ParRef_Dr ];

/// 子表Sub SA_ParRef_Dr
Property SAChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SA_ChlidSub ];

/// 类型 SA_Type
Property SAType As %Library.String(DISPLAYLIST = ",SS_Group,CT_Loc,SS_User,DHC", MAXLEN = 8, SELECTIVITY = "20.0000%", VALUELIST = ",G,L,U,D") [ SqlColumnNumber = 3, SqlFieldName = SA_Type ];

/// 指针 SA_Pointer	
Property SAPointer As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SA_Pointer ];

/// 值 SA_Value	
Property SAValue As %Text(MAXLEN = 300) [ SqlColumnNumber = 5, SqlFieldName = SA_Value ];

/// 集团化医院  SA_Hosp_Dr
Property SAHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = SA_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="HospIndex">
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_EmSys.SY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DHC_EmSysItm.SY_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>SA_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointerHosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_EmSys.SY_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_EmSysItm.SY_ChildSub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SA_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EmSys.SY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_EmSysItm.SY_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SA_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_EmSys.SY_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_EmSysItm.SY_ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SA_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Map1">
<Data name="SA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SA_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SA_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmSys.SY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_EmSysItm.SY_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SA_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmSys.SY_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_EmSysItm.SY_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmSysItmAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
