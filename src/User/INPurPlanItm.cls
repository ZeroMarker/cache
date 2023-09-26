Class User.INPurPlanItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INPPI_Rowid, SqlTableName = IN_PurPlanItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000000;

Index RowIDBasedIDKeyIndex On INPPIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCINPPReqItm As User.DHCINPPReqItm [ Cardinality = children, Inverse = PPREQIINPPIParref ];

/// IN_PurPlan Parent Reference
Relationship INPPIParref As User.INPurPlan [ Cardinality = parent, Inverse = ChildINPurPlanItm, Required, SqlFieldName = INPPI_Parref ];

/// INPPI_Childsub
Property INPPIChildsub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INPPI_Childsub ];

/// INPPI_INCI_DR
Property INPPIINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = INPPI_INCI_DR ];

/// INPPI_Qty
Property INPPIQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INPPI_Qty ];

/// INPPI_CTUOM_DR
Property INPPICTUOMDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = INPPI_CTUOM_DR ];

/// INPPI_PurPrice
Property INPPIPurPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INPPI_PurPrice ];

/// INPPI_APCVM_DR
Property INPPIAPCVMDR As User.APCVendor [ SqlColumnNumber = 8, SqlFieldName = INPPI_APCVM_DR ];

/// INPPI_PHMNF_DR
Property INPPIPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 9, SqlFieldName = INPPI_PHMNF_DR ];

/// INPPI_INPOI_DR
Property INPPIINPOIDR As User.INPOItm [ SqlColumnNumber = 10, SqlFieldName = INPPI_INPOI_DR ];

/// INPPI_Carrier_DR
Property INPPICarrierDR As User.DHCCarrier [ SqlColumnNumber = 11, SqlFieldName = INPPI_Carrier_DR ];

/// INPPI_AvailQty
Property INPPIAvailQty As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INPPI_AvailQty ];

/// INPPI_RLOC_DR
Property INPPIRLOCDR As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = INPPI_RLOC_DR ];

/// INPPI_Sp
Property INPPISp As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INPPI_Sp ];

/// INPPI_ProPurQty
Property INPPIProPurQty As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INPPI_ProPurQty ];

/// 备注
Property INPPIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INPPI_Remark ];

/// INPPI_SpecList 具体规格
Property INPPISpecList As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INPPI_SpecList ];

/// INPPI_RefuseFlag 拒绝标志
Property INPPIRefuseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = INPPI_RefuseFlag ];

/// INPPI_RefuseUser_DR 拒绝人
Property INPPIRefuseUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = INPPI_RefuseUser_DR ];

/// INPPI_RefuseDate 拒绝日期
Property INPPIRefuseDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = INPPI_RefuseDate ];

/// INPPI_RefuseTime 拒绝时间
Property INPPIRefuseTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = INPPI_RefuseTime ];

/// INPPI_ReqCanceled -请领取消标志
Property INPPIReqCanceled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = INPPI_ReqCanceled ];

/// 现有库存可用天数
Property INPPIStkUsedDays As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INPPI_StkUsedDays ];

/// 消耗数量
Property INPPIDispQty As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = INPPI_DispQty ];

/// 送货日期
Property INPPIDateNeeded As %Library.Date [ SqlColumnNumber = 26, SqlFieldName = INPPI_DateNeeded ];

/// INPPI_OriginQty 计划采购数量 完成提交时记录
Property INPPIOriginQty As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = INPPI_OriginQty ];

/// INPPI_UrgentFlag 加急标志
Property INPPIUrgentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = INPPI_UrgentFlag ];

Storage SQLStorage
{
<ExtentSize>25000000</ExtentSize>
<SQLMap name="DataMasterINPPI">
<Data name="INPPI_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPPI_AvailQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPPI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPPI_Carrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPPI_DateNeeded">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INPPI_DispQty">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INPPI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPPI_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPPI_OriginQty">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INPPI_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPPI_ProPurQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPPI_PurPrice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPPI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPPI_RLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPPI_RefuseDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INPPI_RefuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPPI_RefuseTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPPI_RefuseUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPPI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPPI_ReqCanceled">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INPPI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPPI_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPPI_StkUsedDays">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INPPI_UrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^INPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_PurPlan.INPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INPPI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IN_PurPlan.INPP_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PPI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INPPI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINPOI">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PurPlan.INPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INPPI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPOI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INPPI_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IN_PurPlan.INPP_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INPPI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PurPlan.INPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INPPI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INPPI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IN_PurPlan.INPP_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INPPI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INPurPlanItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
