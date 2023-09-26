Class User.DHCMDTConsultItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MC_RowID, SqlTableName = DHC_MDTConsultItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MDTConsult Parent Reference MC_ParRef_Dr
Relationship MCParRefDr As User.DHCMDTConsult [ Cardinality = parent, Inverse = ChildDHCMDTCONSULTITM, Required, SqlFieldName = MC_ParRef_Dr ];

/// MC_ChildSub
Property MCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MC_ChildSub ];

/// 会诊科室  MC_CLoc_Dr
Property MCCLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MC_CLoc_Dr ];

/// 要求会诊医生  MC_NDoc_Dr
Property MCNDocDr As User.CTCareProv [ SqlColumnNumber = 4, SqlFieldName = MC_NDoc_Dr ];

/// 实际会诊医生  MC_CDoc_Dr
Property MCCDocDr As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = MC_CDoc_Dr ];

/// 会诊医生职称  MC_PrvTp_Dr 
Property MCPrvTpDr As User.CTCarPrvTp [ SqlColumnNumber = 6, SqlFieldName = MC_PrvTp_Dr ];

/// 亚专业  MC_SubMar_Dr 
Property MCSubMarDr As User.DHCMDTDicItem [ SqlColumnNumber = 7, SqlFieldName = MC_SubMar_Dr ];

/// 会诊意见  MC_Opinion 
Property MCOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 1500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MC_Opinion ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="MC_CDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_CLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MC_NDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MC_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MC_PrvTp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_SubMar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMDTCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MDTConsult.MC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MDTConsult.MC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTConsultItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
