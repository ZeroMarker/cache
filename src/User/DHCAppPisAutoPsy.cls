Class User.DHCAppPisAutoPsy Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisAutoPsy, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppPisMaster Parent Reference AP_ParRef_Dr
Relationship APParRefDr As User.DHCAppPisMaster [ Cardinality = parent, Inverse = ChildDHCAPPPISAUTOPSY, Required, SqlFieldName = AP_ParRef_Dr ];

/// AP_ChildSub
Property APChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AP_ChildSub ];

/// 自发病至死亡病程时日  AP_MorToDeaPro 
Property APMorToDeaPro As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AP_MorToDeaPro ];

/// 病史及治疗过程  AP_DisAndTrePro 
Property APDisAndTrePro As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_DisAndTrePro ];

/// 临床体格检查及化验检查  AP_PhyAndLabTest
Property APPhyAndLabTest As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AP_PhyAndLabTest ];

/// 解剖后尸体之处理   AP_CorTrePro
Property APCorTrePro As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AP_CorTrePro ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AP_CorTrePro">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_DisAndTrePro">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_MorToDeaPro">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_PhyAndLabTest">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppPisMaster.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppPisMaster.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisAutoPsyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
