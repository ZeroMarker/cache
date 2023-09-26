/// Adm2 Group Number(2720)
Class User.PAAdm2GroupNumber Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2GroupNumber, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On GRPChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship GRPParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2GroupNumber, Required, SqlFieldName = GRP_ParRef ];

/// Childsub
Property GRPChildsub As %Float [ InitialExpression = {$i(^PAADM($p(initvalue,$c(1)),"GROUP",0))}, SqlColumnNumber = 2, SqlFieldName = GRP_Childsub ];

/// Number
Property GRPNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = GRP_Number ];

/// Des Ref Priority
Property GRPPriorityDR As OECPriority [ SqlColumnNumber = 4, SqlFieldName = GRP_Priority_DR ];

/// DateFrom
Property GRPDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = GRP_DateFrom ];

/// DateTo
Property GRPDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = GRP_DateTo ];

/// Des Ref ResponsibleGP
Property GRPResponsibleGPDR As PACRefDoctor [ SqlColumnNumber = 7, SqlFieldName = GRP_ResponsibleGP_DR ];

/// Des Ref ExemptionReason
Property GRPExemptionReasonDR As PACExemptionReason [ SqlColumnNumber = 8, SqlFieldName = GRP_ExemptionReason_DR ];

/// Des Ref Payor
Property GRPPayorDR As ARCInsuranceType [ SqlColumnNumber = 9, SqlFieldName = GRP_Payor_DR ];

/// Des Ref Plan
Property GRPPlanDR As ARCAuxilInsurType [ SqlColumnNumber = 10, SqlFieldName = GRP_Plan_DR ];

/// Text1
Property GRPText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = GRP_Text1 ];

/// Text2
Property GRPText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = GRP_Text2 ];

/// Text3
Property GRPText3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = GRP_Text3 ];

/// Text4
Property GRPText4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = GRP_Text4 ];

/// Text5
Property GRPText5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = GRP_Text5 ];

/// Des Ref BillGrpType
Property GRPCode1DR As ARCBillGroupType [ SqlColumnNumber = 16, SqlFieldName = GRP_Code1_DR ];

/// Des Ref BillGrpType
Property GRPCode2DR As ARCBillGroupType [ SqlColumnNumber = 17, SqlFieldName = GRP_Code2_DR ];

/// Des Ref BillGrpType
Property GRPCode3DR As ARCBillGroupType [ SqlColumnNumber = 18, SqlFieldName = GRP_Code3_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAAdm2GroupNumber).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2GroupNumber","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAAdm2GroupNumber).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2GroupNumber","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAAdm2GroupNumber).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2GroupNumber","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAAdm2GroupNumber).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2GroupNumber","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAAdm2GroupNumber).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2GroupNumber","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="GRPChildsub">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="GRPCode1DR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="GRPCode2DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPCode3DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="GRPDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPExemptionReasonDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPNumber">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="GRPParRef">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="GRPPayorDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="GRPPlanDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="GRPPriorityDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="GRPResponsibleGPDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPText1">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPText2">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPText3">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPText4">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="GRPText5">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="GRP_Code1_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GRP_Code2_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GRP_Code3_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GRP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GRP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GRP_ExemptionReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GRP_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GRP_Payor_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GRP_Plan_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GRP_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GRP_ResponsibleGP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GRP_Text1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GRP_Text2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GRP_Text3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GRP_Text4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GRP_Text5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GROUP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GRP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>GRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GroupNumber"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({GRP_Number})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GRP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GRP_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2GroupNumberS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
