Class User.DHCEmSysItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SY_RowID, SqlTableName = DHC_EmSysItm, StorageStrategy = SQLStorage ]
{

/// 主表ID SY_ParRef_Dr
Relationship SYParRefDr As User.DHCEmSys [ Cardinality = parent, Inverse = ChildDHCEMSYSITM, Required, SqlFieldName = SY_ParRef_Dr ];

/// 子表Sub SY_ChildSub
Property SYChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SY_ChildSub ];

/// 代码 SY_Code	
Property SYCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SY_Code ];

/// 描述 SY_Desc	
Property SYDesc As %Text(MAXLEN = 60) [ SqlColumnNumber = 5, SqlFieldName = SY_Desc ];

/// 备注 SY_Remark
Property SYRemark As %Text(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = SY_Remark ];

/// 可授权标识
Property SYSecFlag As %Text(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = SY_SecFlag ];

/// 标签 SY_Label	
Property SYLabel As %Text(MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = SY_Label ];

Index RowIDBasedIDKeyIndex On SYChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCEmSysItmAut As User.DHCEmSysItmAut [ Cardinality = children, Inverse = SAParRefDr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexSYCode">
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_EmSys.SY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SY_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SYCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_EmSys.SY_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SY_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SY_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="SY_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SY_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SY_Label">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SY_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SY_SecFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmSys.SY_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SY_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmSys.SY_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SY_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmSysItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
