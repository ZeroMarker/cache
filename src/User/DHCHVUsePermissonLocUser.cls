Class User.DHCHVUsePermissonLocUser Extends (%Persistent, User.Abstract) [ SqlRowIdName = HUPLU_Rowid, SqlTableName = DHC_HVUsePermisson_LocUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On HUPLUChildSub [ IdKey, PrimaryKey, Unique ];

Relationship HUPLUHuplParref As User.DHCHVUsePermissonLoc [ Cardinality = parent, Inverse = ChildDHCHVUsePermissonLocUser, Required, SqlFieldName = HUPLU_Hupl_Parref ];

Property HUPLUChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = HUPLU_ChildSub ];

/// 用户
Property HUPLUSSuserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = HUPLU_SSuser_Dr ];

/// 创建日期
Property HUPLUCreateDate As %Library.String [ SqlColumnNumber = 4, SqlFieldName = HUPLU_CreateDate ];

/// 创建人
Property HUPLUCreateUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = HUPLU_CreateUser_Dr ];

/// 更新日期
Property HUPLUUpdateDate As %Library.String [ SqlColumnNumber = 6, SqlFieldName = HUPLU_UpdateDate ];

/// 更新人
Property HUPLUUpdateUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = HUPLU_UpdateUser_Dr ];

/// 是否有效
Property HUPLUActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = HUPLU_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HUPLU_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HUPLU_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HUPLU_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HUPLU_SSuser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HUPLU_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HUPLU_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCHUPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_HVUsePermisson_Loc.HUPL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HUPLU_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_HVUsePermisson_Loc.HUPL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HUPL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{HUPLU_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="LocUserIndex">
<Global>^DHCHUPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_HVUsePermisson_Loc.HUPL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>HUPLU_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{HUPLU_SSuser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_HVUsePermisson_Loc.HUPL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{HUPLU_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HUPLU_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCHVUsePermissonLocUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
