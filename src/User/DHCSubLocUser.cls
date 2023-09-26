Class User.DHCSubLocUser Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_SubLocUser, StorageStrategy = sqlStorage ]
{

Index RowIDBasedIDKeyIndex On SLUChildSub [ IdKey, PrimaryKey, Unique ];

/// SLU_Group_Parref
Relationship SLUGroupParref As DHCSubLocUserGroup [ Cardinality = parent, Inverse = ChildDHCSubLocUser, Required, SqlFieldName = SLU_Group_Parref ];

/// SLU_ChildSub
Property SLUChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCLUG($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SLU_ChildSub ];

/// SLU_User_DR
Property SLUUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SLU_User_DR ];

/// LUG_DateFrom
Property SLUDateFrom As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = SLU_DateFrom ];

/// LUG_DateTo
Property SLUDateTo As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = SLU_DateTo ];

/// LUG_ReqFlag
Property SLUReqFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SLU_ReqFlag ];

Storage sqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterSLU">
<Data name="SLU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLU_ReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLU_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLUG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SubLocUserGroup.LUG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SLU_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocUserGroup.LUG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLU_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexUser">
<Global>^DHCLUG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SubLocUserGroup.LUG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SLU_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SLU_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_SubLocUserGroup.LUG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLU_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SLU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSubLocUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
