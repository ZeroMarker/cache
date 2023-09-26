Class User.DHCHVMatOrdItmRet Extends (%Persistent, User.Abstract) [ SqlRowIdName = ORIR_RowId, SqlTableName = DHC_HVMat_OrdItmRet, StorageStrategy = SQLStorage ]
{

/// 医嘱明细
Property ORIROEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = ORIR_OEORI_DR ];

/// 停医嘱日期
Property ORIROEORIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ORIR_OEORI_Date ];

/// 停医嘱时间
Property ORIROEORITime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ORIR_OEORI_Time ];

/// 停医嘱人
Property ORIROEORIUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = ORIR_OEORI_User ];

/// 退费状态
Property ORIRFeeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ORIR_FeeStatus ];

/// 退费金额
Property ORIRFeeAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ORIR_FeeAmt ];

/// 医嘱接收科室
Property ORIRAdmLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = ORIR_AdmLoc_DR ];

/// 退费日期
Property ORIRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = ORIR_Date ];

/// 退费时间
Property ORIRTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ORIR_Time ];

/// 退费人
Property ORIRSSUSRDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORIR_SSUSR_DR ];

/// 类组
Property ORIRSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 12, SqlFieldName = ORIR_SCG_DR ];

Property ORIRORIDR As User.DHCHVMatOrdItm [ SqlColumnNumber = 13, SqlFieldName = ORIR_ORI_DR ];

Property ORIRAPCVMDR As User.APCVendor [ SqlColumnNumber = 18, SqlFieldName = ORIR_APCVM_DR ];

/// 单位
Property ORIRUnitDR As User.CTUOM [ SqlColumnNumber = 19, SqlFieldName = ORIR_Unit_DR ];

/// 退回数量
Property ORIRQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = ORIR_Qty ];

/// 进价
Property ORIRRp As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = ORIR_Rp ];

/// 售价
Property ORIRSp As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = ORIR_Sp ];

/// 进价金额
Property ORIRRpAmt As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = ORIR_RpAmt ];

/// 售价金额
Property ORIRSpAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = ORIR_SpAmt ];

/// 条码
Property ORIRBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ORIR_BarCode ];

/// 备注
Property ORIRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ORIR_Remark ];

/// 库存项id
Property ORIRINCIDR As User.INCItm [ SqlColumnNumber = 35, SqlFieldName = ORIR_INCI_DR ];

/// 病人登记号
Property ORIRPatientNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = ORIR_PatientNo ];

/// 病人姓名      
Property ORIRPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = ORIR_PatientName ];

/// 病人DOB       
Property ORIRPatientDOB As %Library.Date [ SqlColumnNumber = 38, SqlFieldName = ORIR_PatientDOB ];

/// 病人性别      
Property ORIRPatientSex As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = ORIR_PatientSex ];

/// 病人身份证号  
Property ORIRPersonID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = ORIR_PersonID ];

/// 医嘱项目代码  
Property ORIRItmMastCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = ORIR_ItmMastCode ];

/// 医嘱项目名称  
Property ORIRItmMastDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = ORIR_ItmMastDesc ];

/// 医生姓名     
Property ORIRUserName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = ORIR_UserName ];

/// 医生工号      
Property ORIRUserId As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = ORIR_UserId ];

/// 医嘱科室代码  
Property ORIRLocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = ORIR_LocCode ];

/// 医嘱科室名称   
Property ORIRLocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = ORIR_LocDesc ];

/// 退费日期          
Property ORIRChargeDate As %Library.Date [ SqlColumnNumber = 47, SqlFieldName = ORIR_ChargeDate ];

/// 退费时间          
Property ORIRChargeTime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = ORIR_ChargeTime ];

/// 退费人姓名         
Property ORIRChargeUserName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = ORIR_ChargeUserName ];

/// 退费人工号             
Property ORIRChargeUserId As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = ORIR_ChargeUserId ];

/// 退费单据号            
Property ORIRChargeBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = ORIR_ChargeBillNo ];

/// 退费单价              
Property ORIRChargePrice As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = ORIR_ChargePrice ];

/// 退费金额              
Property ORIRChargeAmt As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = ORIR_ChargeAmt ];

/// 医嘱号                
Property ORIRItmMastStr As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = ORIR_ItmMastStr ];

/// 补录退货单标志
Property ORIRIngdretFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = ORIR_IngdretFlag ];

/// 补录退货子表DR
Property ORIRIngdretiModifyDR As User.DHCINGdRecItm [ SqlColumnNumber = 58, SqlFieldName = ORIR_Ingdreti_Modify_DR ];

/// 发送平台标记
Property ORIRPlatSendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 59, SqlFieldName = ORIR_PlatSendFlag ];

/// 同步发票标记
Property ORIRSynInvFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 60, SqlFieldName = ORIR_SynInvFlag ];

Property ORIRInvNo As %Library.String [ SqlColumnNumber = 61, SqlFieldName = ORIR_InvNo ];

Property ORIRInvDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 62, SqlFieldName = ORIR_InvDate ];

/// 同步8.4标识
Property ORIRSendHRPFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 63, SqlFieldName = ORI_RSendHRPFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMORIRET)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ORIR_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="ORIR_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="ORIR_BarCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="ORIR_ChargeAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>18</Piece>
</Data>
<Data name="ORIR_ChargeBillNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>16</Piece>
</Data>
<Data name="ORIR_ChargeDate">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="ORIR_ChargePrice">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>17</Piece>
</Data>
<Data name="ORIR_ChargeTime">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="ORIR_ChargeUserId">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="ORIR_ChargeUserName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="ORIR_Date">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="ORIR_FeeAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="ORIR_FeeStatus">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="ORIR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>34</Piece>
</Data>
<Data name="ORIR_IngdretFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>35</Piece>
</Data>
<Data name="ORIR_Ingdreti_Modify_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>36</Piece>
</Data>
<Data name="ORIR_InvDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>41</Piece>
</Data>
<Data name="ORIR_InvNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>39</Piece>
</Data>
<Data name="ORIR_ItmMastCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="ORIR_ItmMastDesc">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="ORIR_ItmMastStr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>19</Piece>
</Data>
<Data name="ORIR_LocCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="ORIR_LocDesc">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="ORIR_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="ORIR_OEORI_Date">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ORIR_OEORI_Time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="ORIR_OEORI_User">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="ORIR_ORI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="ORIR_PatientDOB">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="ORIR_PatientName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="ORIR_PatientNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="ORIR_PatientSex">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="ORIR_PersonID">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="ORIR_PlatSendFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>37</Piece>
</Data>
<Data name="ORIR_Qty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="ORIR_Remark">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="ORIR_Rp">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="ORIR_RpAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="ORIR_SCG_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="ORIR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="ORIR_Sp">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="ORIR_SpAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="ORIR_SynInvFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>38</Piece>
</Data>
<Data name="ORIR_Time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="ORIR_Unit_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="ORIR_UserId">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="ORIR_UserName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="ORI_RSendHRPFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>20</Piece>
</Data>
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ORIR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BARCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORIR_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmMastStr">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITMMASTSTR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORIR_ItmMastStr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOrdDate">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCORDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORIR_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORIR_OEORI_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORIR_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlatFlag">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PlatFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORIR_PlatSendFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendHRPFlag">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RSendHRPFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_RSendHRPFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSynInvFlag">
<Global>^DHCHVMORIRET</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SynInvFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORIR_SynInvFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORIR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatOrdItmRetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMORIRET)
	s oldI = +$g(^mdata("DHCHVMORIRET"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMORIRET = maxI
	s ^mdata("DHCHVMORIRET") = maxI
}

}
