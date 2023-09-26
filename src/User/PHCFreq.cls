/// PHC Frequency           (PHCFR,140)
Class User.PHCFreq Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_Freq, StorageStrategy = SQLStorage ]
{

Relationship ChildPHCDispensingTime As PHCDispensingTime [ Cardinality = children, Inverse = PHCDTPHCFRParRef ];

/// Code 代码
Property PHCFRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCFR_Code ];

/// Factor 分发次数
Property PHCFRFactor As %Float(MAXVAL = 99999999, MINVAL = 1) [ SqlColumnNumber = 3, SqlFieldName = PHCFR_Factor ];

/// Description 英文描述
Property PHCFRDesc1 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHCFR_Desc1 ];

/// Description 中文描述
Property PHCFRDesc2 As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCFR_Desc2 ];

/// 间隔天数->间隔数
Property PHCFRDays As %Float [ SqlColumnNumber = 8, SqlFieldName = PHCFR_Days ];

/// 是否激活 节点位置6  空时默认为激活  chenying add@2017-06-12 
Property PHCFRActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHCFR_ActiveFlag ];

/// 就诊类型(门诊O,急诊E,住院I,体检H,新生儿N) 节点位置7 chenying add@2017-06-12 
Property PHCFRClinicType As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = PHCFR_ClinicType ];

/// 门诊默认按分发次数全执行  chenying add@2018-08-22  节点位置8
Property PHCFRNoDelayExecute As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PHCFR_NoDelayExecute ];

/// 周频次  节点位置9  Y/N  chenying add@2018-08-22 
Property PHCFRWeekFlag As %String [ SqlColumnNumber = 12, SqlFieldName = PHCFR_WeekFlag ];

/// 住院默认按分发次数全执行  节点位置10 chenying add@2018-08-22  
Property PHCFRNoDelayExecute2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PHCFR_NoDelayExecute2 ];

/// 周频次系数 节点位置11 chenying add @2019-05-08 
Property PHCFRWeekFactor As %String [ SqlColumnNumber = 14, SqlFieldName = PHCFR_WeekFactor ];

/// 间隔时间（单位：小时）  节点位置12 --不用了
Property PHCFRIntervalTime As %String [ SqlColumnNumber = 15, SqlFieldName = PHCFR_IntervalTime ];

/// 不规则分发时间标志  chenying add@2020-11-04  节点位置13
Property PHCFRIrregularDistributTimeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PHCFR_IrregularDistributTimeFlag ];

/// 间隔单位 ^14,为空默认为天，不影响之前业务运行（天D，小时H) 2021-12-27
/// PHCFRDays+PHCFRIntervalUom(间隔数+单位)的维护，间隔数填写数字，单位选择：天，小时；这样则可以维护比天要小的间隔时间
Property PHCFRIntervalUom As %String [ SqlColumnNumber = 17, SqlFieldName = PHCFR_IntervalUom ];

/// 星期  ^15 zrf
Property PHCFRWeek As %String(MAXLEN = "") [ SqlColumnNumber = 18, SqlFieldName = PHCFR_Week ];

Index PHCFRCodeUnqIdx1 On PHCFRCode [ Unique ];

Parameter EXTENTSIZE = 20;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCFreq).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCFreq","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCFreq).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCFreq","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCFreq).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCFreq","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCFreq).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCFreq","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCFreq).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCFreq","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="PHCFRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFRDays">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFRDesc1">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFRDesc2">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCFRFactor">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PHCFR(0))</SqlIdExpression>
<SQLMap name="DataMasterPHCFR">
<Data name="PHCFR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCFR_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCFR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCFR_Days">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCFR_Desc1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCFR_Desc2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCFR_Factor">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCFR_IntervalTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHCFR_IntervalUom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHCFR_IrregularDistributTimeFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHCFR_NoDelayExecute">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCFR_NoDelayExecute2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCFR_Week">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHCFR_WeekFactor">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCFR_WeekFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PHCFR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHCFR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCFRCode">
<Global>^PHCFR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCFR_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCFR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCFRDesc1">
<Global>^PHCFR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCFR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCFR_Desc1})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCFR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCFR_RowId</SqlRowIdName>
<StreamLocation>^User.PHCFreqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
