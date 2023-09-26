/// Records of Medicine/Meterial Order 
Class User.DHCOEDispensing Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSP_RowId, SqlTableName = DHC_OEDispensing, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 确认标志  护士站审核确认标志
Property DSPConfirmFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = DSP_ConfirmFlag ];

/// 护士站审核确认数量
Property DSPConfirmQty As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DSP_ConfirmQty ];

/// 护士站审核确认人
Property DSPConfirmUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = DSP_ConfirmUser ];

/// 药房发药退药确认日期
Property DSPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DSP_Date ];

/// 插入日期
Property DSPDateAdd As %Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = DSP_DateAdd ];

/// 护士站审核确认时间
Property DSPDateConfirm As %Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = DSP_DateConfirm ];

/// 执行表指针
Property DSPOEOREDR As User.OEOrdExec [ SqlColumnNumber = 4, SqlFieldName = DSP_OEORE_DR ];

/// 医嘱表指针
Property DSPOEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DSP_OEORI_DR ];

/// 操作指针  DSP_Type=F：存门诊发药子表RowId ,DSP_Type=P：存住院发药子表RowId
Property DSPPointer As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DSP_Pointer ];

/// 发药退药数量(基本单位)
Property DSPQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DSP_Qty ];

/// 发药退药基本单位
Property DSPQtyUOM As User.CTUOM [ SqlColumnNumber = 7, SqlFieldName = DSP_QtyUOM ];

/// 每日发药顺序
Property DSPSeqNo As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DSP_SeqNo ];

/// 发药退药状态
Property DSPStatus As %Library.String(DISPLAYLIST = ",READY,Collect,Return", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",TC,C,R") [ SqlColumnNumber = 8, SqlFieldName = DSP_Status ];

/// 药房发药退药确认时间
Property DSPTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DSP_Time ];

/// 插入时间
Property DSPTimeAdd As %Time [ SqlColumnNumber = 17, SqlFieldName = DSP_TimeAdd ];

/// 护士站审核确认时间
Property DSPTimeConfirm As %Time [ SqlColumnNumber = 20, SqlFieldName = DSP_TimeConfirm ];

/// 理论分发时间点(配液时间)
Property DSPTimeDosing As %Time [ SqlColumnNumber = 21, SqlFieldName = DSP_TimeDosing ];

/// 一天医嘱总数量 
Property DSPTotalQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DSP_TotalQty ];

/// 操作类型, F：门诊发药   P：住院发药
Property DSPType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DSP_Type ];

/// 发药退药操作人
Property DSPUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DSP_User ];

/// 需配药日期(理论分发日期)
Property DSPDateDosing As %Date [ SqlColumnNumber = 22, SqlFieldName = DSP_DateDosing ];

/// 病人当时位置 CTLoc,门诊为科室，住院对应科室表里病区
Property DSPAdmLocDR As User.CTLoc [ SqlColumnNumber = 23, SqlFieldName = DSP_AdmLoc_DR ];

/// 病人当时科室
Property DSPDeptDR As User.CTLoc [ SqlColumnNumber = 24, SqlFieldName = DSP_Dept_DR ];

/// 接收科室
Property DSPRecDepDR As User.CTLoc [ SqlColumnNumber = 25, SqlFieldName = DSP_RecDep_DR ];

/// 使用科室
Property DSPInUseDepDR As User.CTLoc [ SqlColumnNumber = 26, SqlFieldName = DSP_InUseDep_DR ];

/// 病人就诊指针
Property DSPAdmDR As User.PAAdm [ SqlColumnNumber = 27, SqlFieldName = DSP_Adm_DR ];

/// 发药类别,用于住院按照类别统计
Property DSPCategory As %String [ SqlColumnNumber = 28, SqlFieldName = DSP_Category ];

// Property DSPPogFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = DSP_PogFlag ];

Property DSPPogFlag As %Library.String(DISPLAYLIST = ",Yes,No,Error,Piva", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N,E,P") [ SqlColumnNumber = 29, SqlFieldName = DSP_PogFlag ];

/// 病区专业组
Property DSPWardGroupDR As User.DHCWardProGroup [ SqlColumnNumber = 30, SqlFieldName = DSP_WardGroup_DR ];

/// 草药一个医嘱项对多个库存项目的包装组合,来源为User.OEOrdItemExt下的OEORIINCIPackComb
/// 格式：inicRow1_"!"_Qty1_$C(1)_inicRow2_"!"_Qty2_$C(1)_inicRow3_"!"_Qty3_......
Property DSPINCIPackComb As %String(COLLATION = "Exact", MAXLEN = 5000) [ SqlColumnNumber = 31, SqlFieldName = DSP_INCIPackComb ];

/// 医嘱项Id
Property DSPArcimDR As User.ARCItmMast [ SqlColumnNumber = 32, SqlComputeCode = {	
		i {DSP_OEORI_DR}="" s {DSP_Arcim_DR}="" q
		s oeori={DSP_OEORI_DR}
		s {DSP_Arcim_DR}=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
	}, SqlComputed, SqlFieldName = DSP_Arcim_DR, Transient ];

/// 胡立华，2022-08-15，新疆中医。用于标记护士领药审核时是否调用药柜接口。
Property DSPDurgCupFlag As %String(COLLATION = "Exact", MAXLEN = 5000) [ SqlColumnNumber = 33, SqlFieldName = DSP_DurgCupFlag ];

Relationship ChildBatch As User.DHCOEDispBatch [ Cardinality = children, Inverse = DSPBDSPParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOEDISQTY(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSP_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DSP_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DSP_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DSP_Category">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DSP_ConfirmFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DSP_ConfirmQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSP_ConfirmUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DSP_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSP_DateAdd">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DSP_DateConfirm">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DSP_DateDosing">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DSP_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DSP_DurgCupFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DSP_INCIPackComb">
<Delimiter>"^"</Delimiter>
<Node>"EXP"</Node>
<Piece>1</Piece>
</Data>
<Data name="DSP_InUseDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DSP_OEORE_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSP_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSP_PogFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DSP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DSP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSP_QtyUOM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSP_RecDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DSP_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSP_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSP_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSP_TimeAdd">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DSP_TimeConfirm">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DSP_TimeDosing">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DSP_TotalQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSP_Type">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DSP_User">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSP_WardGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Global>^DHCOEDISQTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DSP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXARCSTATUS">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCSTATUS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_Arcim_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_TimeDosing}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXAdmLoc">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{DSP_WardGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_Category}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXArcDspDate">
<Condition>
<![CDATA[({DSP_Arcim_Dr}'="")&&({DSP_Date}'="")]]></Condition>
<Global>^DHCOEDISQTY</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCDSPDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_Arcim_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXOEORE">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DSP_OEORE_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXOEORI">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DSP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecConArcim">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECCONARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateConfirm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_ConfirmFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_Arcim_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecDep">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_Category}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecDepAdm">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_Adm_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecDepArc">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECARC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_Arcim_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecDepConfirm">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECCONFIRM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateConfirm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_Category}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecDepConfirmAdm">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMCONFIRM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateConfirm}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_Adm_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DSP_Category}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXRecWardGroup">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L9}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>+{DSP_WardGroup_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DSP_Category}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXSeqNo">
<Global>^DHCOEDISQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEQNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSP_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSP_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOEDispensingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
