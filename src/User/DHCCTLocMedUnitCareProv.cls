/// Creator:      周志强
/// CreatDate:    2010.07.08
/// Description:: 医疗单元医护人员定义,作为医疗单元的子表
Class User.DHCCTLocMedUnitCareProv Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = MUCP_RowId, SqlTableName = DHC_CTLoc_MedUnitCareProv, StorageStrategy = SQLStorage ]
{

/// 医疗单元对象
Relationship MUCPParRef As User.DHCCTLocMedUnit [ Cardinality = parent, Inverse = ChildCareProv, Required, SqlFieldName = MUCP_ParRef ];

Index RowIDBasedIDKeyIndex On MUCPChildsub [ IdKey, PrimaryKey, Unique ];

Property MUCPChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"MU",$P($s($d(initvalue):initvalue,1:%d(0)),"||",2),"CP",0))}, SqlColumnNumber = 3, SqlFieldName = MUCP_Childsub ];

/// 医护人员指针
Property MUCPDoctorDR As User.CTCareProv [ SqlColumnNumber = 4, SqlFieldName = MUCP_Doctor_DR ];

/// 组长标志
Property MUCPLeaderFlag As %String(DISPLAYLIST = ",Yes,No,", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MUCP_LeaderFlag ];

/// 门诊出诊标志
Property MUCPOPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 6, SqlFieldName = MUCP_OPFlag ];

/// 住院出诊标志
Property MUCPIPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 7, SqlFieldName = MUCP_IPFlag ];

/// 开始日期
Property MUCPDateFrom As %Date [ SqlColumnNumber = 8, SqlFieldName = MUCP_DateFrom ];

/// 截止日期
Property MUCPDateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = MUCP_DateTo ];

/// 开始时间 add by sunfengchao 2016-8-29
Property MUCPTimeFrom As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = MUCP_TimeFrom ];

/// 截止时间 add by sunfengchao 2016-8-29
Property MUCPTimeTo As %Time [ SqlColumnNumber = 11, SqlFieldName = MUCP_TimeTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MUCP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MUCP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MUCP_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MUCP_IPFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MUCP_LeaderFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MUCP_OPFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MUCP_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MUCP_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CTLoc_MedUnit.CTMU_CTLOC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_CTLoc_MedUnit.CTMU_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MUCP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_CTLoc_MedUnit.CTMU_CTLOC_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"MU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_CTLoc_MedUnit.CTMU_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MUCP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTPCP">
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CTLoc_MedUnit.CTMU_CTLOC_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_CTLoc_MedUnit.CTMU_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>MUCP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CTPCP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MUCP_Doctor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_CTLoc_MedUnit.CTMU_CTLOC_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MU"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_CTLoc_MedUnit.CTMU_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{MUCP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCTLocMedUnitCareProvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
