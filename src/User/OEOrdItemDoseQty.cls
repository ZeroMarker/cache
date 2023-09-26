Class User.OEOrdItemDoseQty Extends %Persistent [ SqlTableName = OE_OrdItemDoseQty, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OIDQChildsub [ IdKey, PrimaryKey, Unique ];

Relationship OIDQOEORIParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdItemDoseQty, Required, SqlFieldName = OIDQ_OEORI_ParRef ];

Property OIDQChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD(+$s($d(initvalue):initvalue,1:%d(0)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"DQ",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OIDQ_Childsub ];

/// 单次剂量串
Property OIDQFreqTimeDoseStr As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = OIDQ_FreqTimeDoseStr ];

/// 是否有效
Property OIDQActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = OIDQ_Active ];

/// 生效时间
Property OIDQSttDate As %Date [ SqlColumnNumber = 5, SqlFieldName = OIDQ_SttDate ];

Property OIDQSttTime As %Time [ SqlColumnNumber = 6, SqlFieldName = OIDQ_SttTime ];

/// 失效时间
/// 如果有这个时间的话，用户操作起来特别容易混乱，先禁用这个字段，目前算法也不支持
Property OIDQEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OIDQ_EndDate ];

Property OIDQEndTime As %Time [ SqlColumnNumber = 8, SqlFieldName = OIDQ_EndTime ];

Property OIDQDoctorDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = OIDQ_Doctor_DR ];

Property OIDQNote As %String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = OIDQ_Note ];

Property OIDQInsertDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = OIDQ_InsertDate ];

Property OIDQInsertTime As %Time [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 12, SqlFieldName = OIDQ_InsertTime ];

/// 是否执行-滚医嘱时将该条记录置生效
Property OIDQExeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = OIDQ_ExeFlag ];

Property OIDQExeDate As %Date [ SqlColumnNumber = 14, SqlFieldName = OIDQ_ExeDate ];

Property OIDQExeTime As %Time [ SqlColumnNumber = 15, SqlFieldName = OIDQ_ExeTime ];

Property OIDQLastUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = OIDQ_LastUpdateDate ];

Property OIDQLastUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = OIDQ_LastUpdateTime ];

Property OIDQLastUpdateDoctorDR As CTCareProv [ SqlColumnNumber = 18, SqlFieldName = OIDQ_LastUpdateDoctor_DR ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="OIDQ_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OIDQ_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OIDQ_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OIDQ_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OIDQ_ExeDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OIDQ_ExeFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OIDQ_ExeTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OIDQ_FreqTimeDoseStr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OIDQ_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OIDQ_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OIDQ_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OIDQ_LastUpdateDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OIDQ_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OIDQ_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OIDQ_SttDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OIDQ_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OIDQ_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DQ"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OIDQ_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OIDQ_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdItemDoseQtyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
