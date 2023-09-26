Class User.DHCBillCheckData Extends %Persistent [ SqlRowIdName = CD_RowID, SqlTableName = DHC_BillCheckData, StorageStrategy = SQLStorage ]
{

Index indexCDChildSub On CDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_BillMonitorPointConfig Parent Reference
Relationship CDParRef As User.DHCBillMonitorPointConfig [ Cardinality = parent, Inverse = ChildCheckData, Required, SqlFieldName = CD_ParRef ];

/// CD_ChildSub
Property CDChildSub As %Library.Float [ InitialExpression = {$i(^DHCMPConfig($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = CD_ChildSub ];

/// 收费天数计算方式: 算入算出 / 算入不算出
Property CDDaysMode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = CD_DaysMode ];

/// OECCAT:医嘱大类, ARCIC:医嘱子类, ARCIM:医嘱项
Property CDARCType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CD_ARCType ];

/// CD_ARCType为"OECCAT"时, 指向OEC_OrderCategory; 为"ARCIC"时,指向ARC_ItemCat; 为"ARCIM"时,指向ARC_ItmMast
Property CDARCTypeDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = CD_ARCType_DR ];

/// 空调费是否走医生站配置(0:走维护的开始结束日期, 1:走医生站配置)
Property CDAirMode As %Library.String [ SqlColumnNumber = 6, SqlFieldName = CD_AirMode ];

/// 计算空调费开始日期
Property CDAirStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = CD_AirStDate ];

/// 计算空调费结束日期
Property CDAirEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = CD_AirEndDate ];

/// 数量/次数(每天不能超过的数量)
Property CDMaxQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = CD_MaxQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CD_ARCType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CD_ARCType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CD_AirEndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CD_AirMode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CD_AirStDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CD_DaysMode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CD_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCMPConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BillMonitorPointConfig.MPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_BillMonitorPointConfig.MPC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCTypeDR">
<Global>^DHCMPConfigi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_BillMonitorPointConfig.MPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_BillMonitorPointConfig.MPC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CD_ARCType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CD_ARCType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CD_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillCheckDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
