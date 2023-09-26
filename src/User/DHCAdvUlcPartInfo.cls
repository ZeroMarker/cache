Class User.DHCAdvUlcPartInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADVUP_RowID, SqlTableName = DHC_AdvUlcPartInfo, StorageStrategy = SQLStorage ]
{

/// 		报告id		
Property ADVUPRepDr As User.DHCAdvMaster [ SqlColumnNumber = 2, SqlFieldName = ADVUP_RepDr ];

/// 		表单记录id		
Property ADVUPRecordDr As User.DHCAdvFormRecord [ SqlColumnNumber = 3, SqlFieldName = ADVUP_RecordDr ];

/// 		发现日期
Property ADVUPFindDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ADVUP_FindDate ];

/// 		压疮来源
Property ADVUPUlcSource As %String [ SqlColumnNumber = 5, SqlFieldName = ADVUP_UlcSource ];

/// 		压疮部位
Property ADVUPUlcPart As %String [ SqlColumnNumber = 6, SqlFieldName = ADVUP_UlcPart ];

/// 		压疮分期
Property ADVUPUlcStage As %String [ SqlColumnNumber = 7, SqlFieldName = ADVUP_UlcStage ];

/// 		压疮面积
Property ADVUPUlcArea As %String [ SqlColumnNumber = 8, SqlFieldName = ADVUP_UlcArea ];

/// 		渗出液
Property ADVUPPercolate As %String [ SqlColumnNumber = 9, SqlFieldName = ADVUP_Percolate ];

/// 		伤口颜色
Property ADVUPWoundColor As %String [ SqlColumnNumber = 10, SqlFieldName = ADVUP_WoundColor ];

/// 		气味
Property ADVUPSmell As %String [ SqlColumnNumber = 11, SqlFieldName = ADVUP_Smell ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVULCP)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="ADVUP_FindDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADVUP_Percolate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADVUP_RecordDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADVUP_RepDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVUP_Smell">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADVUP_UlcArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADVUP_UlcPart">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADVUP_UlcSource">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADVUP_UlcStage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADVUP_WoundColor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCADVULCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVUP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVUP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="RepDrIndex">
<Global>^DHCADVULCP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVUP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVUP_RepDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVUP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvUlcPartInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
