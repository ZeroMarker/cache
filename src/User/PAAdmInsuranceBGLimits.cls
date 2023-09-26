/// PA Adm Insurance BG Limit(1769)
Class User.PAAdmInsuranceBGLimits Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmInsuranceBGLimits, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LIMChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_AdmInsurance Parent Reference
Relationship LIMParRef As PAAdmInsurance [ Cardinality = parent, Inverse = ChildPAAdmInsuranceBGLimits, Required, SqlFieldName = LIM_ParRef ];

/// Childsub
Property LIMChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"INS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"LIM",0))}, SqlColumnNumber = 2, SqlFieldName = LIM_Childsub ];

/// Des Ref BillGroup
Property LIMBillGroupDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = LIM_BillGroup_DR ];

/// Des Ref BillSub
Property LIMBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = LIM_BillSub_DR ];

/// Des Ref RoomType
Property LIMRoomTypeDR As PACRoomType [ SqlColumnNumber = 5, SqlFieldName = LIM_RoomType_DR ];

/// Max Coverage
Property LIMMaxCoverage As %Float [ SqlColumnNumber = 6, SqlFieldName = LIM_MaxCoverage ];

/// Des Ref ARCIM
Property LIMARCIMDR As ARCItmMast [ SqlColumnNumber = 7, SqlFieldName = LIM_ARCIM_DR ];

/// PayorPerc
Property LIMPayorPerc As %Float [ SqlColumnNumber = 8, SqlFieldName = LIM_PayorPerc ];

/// Qty allowed
Property LIMQty As %Float [ SqlColumnNumber = 9, SqlFieldName = LIM_Qty ];

/// Qty Used
Property LIMQtyUsed As %Float [ SqlColumnNumber = 10, SqlFieldName = LIM_QtyUsed ];

/// Max Coverage Used
Property LIMMaxCoverageUsed As %Float [ SqlColumnNumber = 11, SqlFieldName = LIM_MaxCoverageUsed ];

/// Des Ref OrderStatus
Property LIMOrderStatusDR As OECOrderStatus [ SqlColumnNumber = 12, SqlFieldName = LIM_OrderStatus_DR ];

/// MaxDailyAmount
Property LIMMaxDailyAmount As %Float [ SqlColumnNumber = 13, SqlFieldName = LIM_MaxDailyAmount ];

/// Price
Property LIMPrice As %Float [ SqlColumnNumber = 14, SqlFieldName = LIM_Price ];

/// Discount Amt
Property LIMDiscountAmt As %Float [ SqlColumnNumber = 15, SqlFieldName = LIM_DiscountAmt ];

/// Discount Percentage
Property LIMDiscountPerc As %Float [ SqlColumnNumber = 16, SqlFieldName = LIM_DiscountPerc ];

/// Des Ref DiscountReason
Property LIMDiscountReasonDR As ARCDiscretDiscType [ SqlColumnNumber = 17, SqlFieldName = LIM_DiscountReason_DR ];

/// Discount Comments
Property LIMDiscountComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = LIM_DiscountComments, SqlListType = subnode ];

/// Des Ref ARCOS
Property LIMARCOSDR As ARCOrdSets [ SqlColumnNumber = 19, SqlFieldName = LIM_ARCOS_DR ];

/// Des Ref UpdateUser
Property LIMUpdateUserDR As SSUser [ SqlColumnNumber = 20, SqlFieldName = LIM_UpdateUser_DR ];

/// Update Date
Property LIMUpdateDate As %Date [ SqlColumnNumber = 21, SqlFieldName = LIM_UpdateDate ];

/// Update Time
Property LIMUpdateTime As %Time [ SqlColumnNumber = 22, SqlFieldName = LIM_UpdateTime ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAAdmInsuranceBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAAdmInsuranceBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAAdmInsuranceBGLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAAdmInsuranceBGLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAAdmInsuranceBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceBGLimits","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LIM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LIM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="LIM_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LIM_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LIM_DiscountAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="LIM_DiscountComments">
<Node>"DISCOM"</Node>
</Data>
<Data name="LIM_DiscountPerc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="LIM_DiscountReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="LIM_MaxCoverage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LIM_MaxCoverageUsed">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LIM_MaxDailyAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LIM_OrderStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LIM_PayorPerc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LIM_Price">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LIM_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LIM_QtyUsed">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LIM_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LIM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="LIM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="LIM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmInsurance.INS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>LIM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmInsurance.INS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^PAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmInsurance.INS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>LIM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmInsurance.INS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LIM_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{LIM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LIM_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmInsuranceBGLimitsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
