Class User.DHCSubLocGrpAllotScale Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLGAS_Rowid, SqlTableName = DHC_SubLocGrpAllotScale, StorageStrategy = SqlStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SLGASChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_SubLocGrpAllot Parent Reference
Relationship SLGASSLGAParref As User.DHCSubLocGrpAllot [ Cardinality = parent, Inverse = ChildDHCSubLocGrpAllotScale, Required, SqlFieldName = SLGAS_SLGA_Parref ];

/// SLGAI_Childsub
Property SLGASChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SLGAS_Childsub ];

/// SLGAI_User_DR
Property SLGASUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SLGAS_User_DR ];

/// SLGAI_AllotValue
Property SLGASAllotValue As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SLGAS_ScaleValue ];

/// SLGAI_AllotRpAmt
Property SLGASAllotRpAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SLGAS_ScaleRpAmt ];

/// SLGAI_AllotSpAmt
Property SLGASAllotSpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SLGAS_ScaleSpAmt ];

Storage SqlStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexUser">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SubLocGrpAllot.SLGA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SLGAS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGAS_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllot.SLGA_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SLGAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SLGAS_ScaleRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLGAS_ScaleSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLGAS_ScaleValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLGAS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSLGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SubLocGrpAllot.SLGA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SLGAS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllot.SLGA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGAS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSubLocGrpAllotScaleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
