/// 治疗项目设置
Class User.DHCDocCureItemSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDCIS_Rowid, SqlTableName = DHC_DocCureItemSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCureItemSetPlan As User.DHCDocCureItemSetPlan [ Cardinality = children, Inverse = DDCISPParRef ];

Relationship ChildDHCDocCureItemAppendItem As User.DHCDocCureItemAppendItem [ Cardinality = children, Inverse = DDCIAIParRef ];

Relationship ChildDHCDocCureItemSetRT As User.DHCDocCureItemSetRecordTemp [ Cardinality = children, Inverse = DDCRTParRef ];

Relationship ChildDHCDocCureItemSetExp As User.DHCDocCureItemSetExpand [ Cardinality = children, Inverse = DDCISExpParRef ];

/// DDCIS_ItmMast_DR  治疗项目
Property DDCISItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DDCIS_ItmMast_DR ];

/// DDCIS_ShortName  简称
Property DDCISShortName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DDCIS_ShortName ];

/// DDCIS_ServiceGroup_DR   服务组
Property DDCISServiceGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DDCIS_ServiceGroup_DR ];

/// DDCIS_AutoApp  自动预约开关
Property DDCISAutoApp As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DDCIS_AutoApp ];

/// DDCIS_Effect  治疗作用
Property DDCISEffect As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DDCIS_Effect ];

/// DDCIS_Indication  治疗适应症
Property DDCISIndication As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DDCIS_Indication ];

/// DDCIS_Avoid  治疗禁忌
Property DDCISAvoid As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DDCIS_Avoid ];

/// DDCIS_AutoApply  手动申请
Property DDCISManualApply As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DDCIS_ManualApply ];

/// DDCIS_AutoApp  门诊预约时直接执行
Property DDCISApplyExec As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DDCIS_ApplyExec ];

/// DDCIS_AutoApp  是否激活
Property DDCISActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DDCIS_Active ];

/// DDCIS_AutoApp  住院预约时直接执行
Property DDCISIPApplyExec As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DDCIS_IPApplyExec ];

/// DDCIS_Hospital_DR  院区
Property DDCISHospitalDR As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = DDCIS_Hospital_DR ];

/// DDCIS_RelateAssTemp  关联的评估模板
Property DDCISRelateAssTemp As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DDCIS_RelateAssTemp ];

/// DDCIS_RelateRecordTemp  关联的记录模板
Property DDCISRelateRecordTemp As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DDCIS_RelateRecordTemp ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureItemSet)</SqlIdExpression>
<SQLMap name="IndexHospItmMast">
<Global>^DHCDocCureItemSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDCIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospItmMast"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCIS_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCIS_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmMast">
<Global>^DHCDocCureItemSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCIS_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRelateAssTemp">
<Global>^DHCDocCureItemSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCIS_RelateAssTemp}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DDCIS_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDCIS_ApplyExec">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCIS_AutoApp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCIS_Avoid">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCIS_Effect">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCIS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDCIS_IPApplyExec">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDCIS_Indication">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCIS_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCIS_ManualApply">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCIS_RelateAssTemp">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDCIS_RelateRecordTemp">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DDCIS_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCIS_ShortName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocCureItemSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DDCIS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTimePeriodSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
