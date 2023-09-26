/// CareProvORPrefEq(2669)
Class User.CTCareProvORPrefEq Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvORPrefEq, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EQChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_CareProvORPref Parent Reference
Relationship EQParRef As CTCareProvORPref [ Cardinality = parent, Inverse = ChildCTCareProvORPrefEq, Required, SqlFieldName = EQ_ParRef ];

/// Childsub
Property EQChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ORP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"EQ",0))}, SqlColumnNumber = 2, SqlFieldName = EQ_Childsub ];

/// Des Ref ARCIM
Property EQARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = EQ_ARCIM_DR ];

/// Des Ref ARCOS
Property EQARCOSDR As ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = EQ_ARCOS_DR ];

/// Qty
Property EQQty As %Float [ SqlColumnNumber = 5, SqlFieldName = EQ_Qty ];

/// Des Ref ARCIM
Property EQEquipDR As ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = EQ_Equip_DR ];

/// EquipQty
Property EQEquipQty As %Float [ SqlColumnNumber = 7, SqlFieldName = EQ_EquipQty ];

/// Des Ref CTPCP
Property EQCTPCPDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = EQ_CTPCP_DR ];

/// CareProvType
Property EQCareProvType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EQ_CareProvType ];

/// StaffQty
Property EQStaffQty As %Float [ SqlColumnNumber = 10, SqlFieldName = EQ_StaffQty ];

/// SequenceNo
Property EQSequenceNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EQ_SequenceNo ];

/// UpdateDate
Property EQUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = EQ_UpdateDate ];

/// UpdateTime
Property EQUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = EQ_UpdateTime ];

/// Des Ref UpdateUser
Property EQUpdateUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = EQ_UpdateUser_DR ];

/// DateActiveFrom
Property EQDateActiveFrom As %Date [ SqlColumnNumber = 15, SqlFieldName = EQ_DateActiveFrom ];

/// DateActiveTo
Property EQDateActiveTo As %Date [ SqlColumnNumber = 16, SqlFieldName = EQ_DateActiveTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPrefEq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPrefEq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvORPrefEq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvORPrefEq).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvORPrefEq).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvORPrefEq","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>64</ExtentSize>
<Property name="EQARCIMDR">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="EQARCOSDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="EQCTPCPDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="EQCareProvType">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EQChildsub">
<Selectivity>3.5714%</Selectivity>
</Property>
<Property name="EQDateActiveFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQDateActiveTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQEquipDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EQEquipQty">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EQParRef">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="EQQty">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="EQSequenceNo">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="EQStaffQty">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="EQUpdateDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQUpdateTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="EQ_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EQ_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EQ_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EQ_CareProvType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EQ_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EQ_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EQ_EquipQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EQ_Equip_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EQ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EQ_SequenceNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EQ_StaffQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EQ_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EQ_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EQ_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareProv">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"CareProv"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_CareProvType}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareProvType">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"CarePrvType"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_CareProvType}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_Equip_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeq">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CT_CareProvORPref.ORP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_CareProvORPref.ORP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Seq"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_SequenceNo}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EQ_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvORPrefEqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
