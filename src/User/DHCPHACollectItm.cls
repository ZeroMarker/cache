Class User.DHCPHACollectItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHACI_RowID, SqlTableName = DHC_PHACollectItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHACIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPhaCollectResQty As User.DHCPhaCollectResQty [ Cardinality = children, Inverse = RESPHACIParref ];

Relationship ChildDHCPhaCollectItmLB As User.DHCPhaCollectItmLB [ Cardinality = children, Inverse = PHACILPHACIParref ];

/// DHC_PHACollected Parent Reference
Relationship PHACIPHACParRef As User.DHCPHACollected [ Cardinality = parent, Inverse = ChildDHCPHACollectItm, Required, SqlFieldName = PHACI_PHAC_ParRef ];

/// Patient Adm
Property PHACIAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHACI_Adm_DR ];

/// Prescription Number
Property PHACIPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHACI_PrescNo ];

/// PHACI_INCI_DR
Property PHACIINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = PHACI_INCI_DR ];

/// PHACI_Qty
Property PHACIQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHACI_Qty ];

/// PHACI_OEDIS_DR
Property PHACIOEDISDR As User.OEOrdItem [ SqlColumnNumber = 6, SqlFieldName = PHACI_OEDIS_DR ];

/// PHACI_ChildSub
Property PHACIChildSub As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHACI_ChildSub ];

/// Patient Bed
Property PHACIBED As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHACI_BED ];

/// Medicine Unit Price
Property PHACIPrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHACI_Price ];

/// PHACI_OrdStatus
Property PHACIOrdStatus As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHACI_OrdStatus ];

/// PHACI_AdmLoc_DR
Property PHACIAdmLocDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = PHACI_AdmLoc_DR ];

/// PHACI_ResQty
Property PHACIResQty As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PHACI_ResQty ];

/// PHACI_DODIS_DR, ! 8.3后使用指向, 之前使用字符串 
Property PHACIDODISDR As User.DHCOEDispensing [ SqlColumnNumber = 15, SqlFieldName = PHACI_DODIS_DR ];

/// Property PHACIDODISDR As User.DHCOEDispensing(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHACI_DODIS_DR ];
/// PHACI_PNo
Property PHACIPNo As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PHACI_PNo ];

/// SalePriceAmount
Property PHACISpAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PHACI_SpAmt ];

/// 分发日期
Property PHACIDateDosing As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = PHACI_DateDosing ];

/// 进价
Property PHACIRp As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PHACI_Rp ];

/// 进价金额
Property PHACIRpAmt As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = PHACI_RpAmt ];

/// 批号
Property PHACIBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PHACI_BatNo ];

/// 实发数量
Property PHACIRealQty As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = PHACI_RealQty ];

/// 实发打包表rowid串
Property PHACIRealDODISDR As %Library.String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHACI_Real_DODIS_DR ];

/// 复核标志
Property PHACIChkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = PHACI_ChkFlag ];

/// 复核人
Property PHACIChkUserDr As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = PHACI_ChkUser_Dr ];

/// 复核日期
Property PHACIChkDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = PHACI_ChkDate ];

/// 复核时间
Property PHACIChkTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = PHACI_ChkTime ];

/// 欠药标志
Property PHACIOweFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = PHACI_OweFlag ];

/// 欠药取消人
Property PHACIOweClUserDr As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = PHACI_OweClUser_Dr ];

/// 欠药取消日期
Property PHACIOweClDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = PHACI_OweClDate ];

/// 欠药取消时间
Property PHACIOweClTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = PHACI_OweClTime ];

/// 配送标志
Property PHACISendFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = PHACI_SendFlag ];

/// 配送人
Property PHACISendUserDr As User.SSUser [ SqlColumnNumber = 33, SqlFieldName = PHACI_SendUser_Dr ];

/// 配送日期
Property PHACISendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = PHACI_SendDate ];

/// 配送时间
Property PHACISendTime As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = PHACI_SendTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DATAMASTER">
<Data name="PHACI_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHACI_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHACI_BED">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHACI_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHACI_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHACI_ChkDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHACI_ChkFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHACI_ChkTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHACI_ChkUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHACI_DODIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHACI_DateDosing">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHACI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHACI_OEDIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHACI_OrdStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHACI_OweClDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHACI_OweClTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PHACI_OweClUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHACI_OweFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHACI_PHAC_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHACI_PNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHACI_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHACI_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHACI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHACI_RealQty">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHACI_Real_DODIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHACI_ResQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHACI_Rp">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHACI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHACI_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PHACI_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PHACI_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PHACI_SendUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PHACI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCPHAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHACI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHACI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXINCI">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHACI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHACI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHACI_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHACI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXPrescno">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Prescno"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHACI_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHACI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDsp">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHACI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHACI_DODIS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHACI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOweFlag">
<Condition>{PHACI_OweFlag}'=""</Condition>
<Global>^DHCPHAC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHACI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OweFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHACI_OweFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHACI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexoedis">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHACI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHADSP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHACI_OEDIS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHACI_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PHACI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHACollectItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
