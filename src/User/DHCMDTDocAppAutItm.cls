Class User.DHCMDTDocAppAutItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DI_RowID, SqlTableName = DHC_MDTDocAppAutItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DIChlidSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MDTGroup Parent Reference DI_ParRef_Dr
Relationship DIParRefDr As User.DHCMDTDocAppAut [ Cardinality = parent, Inverse = ChildDHCMDTDOCAPPAUTITM, Required, SqlFieldName = DI_ParRef_Dr ];

/// MD_ChlidSub
Property DIChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DI_ChlidSub ];

/// 授权类型  DI_AutType_Dr 
Property DIAutTypeDr As User.DHCMDTDicItem [ SqlColumnNumber = 3, SqlFieldName = DI_AutType_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DI_AutType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMDTDAA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MDTDocAppAut.DA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DI_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MDTDocAppAut.DA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DI_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTDocAppAutItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
