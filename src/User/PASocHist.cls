/// Patient Social History    (SCH,104)
Class User.PASocHist Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SocHist, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SCHChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to PAPMI
Relationship SCHPAPMIParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPASocHist, Required, SqlFieldName = SCH_PAPMI_ParRef ];

/// Social History ChildSub
Property SCHChildSub As %Numeric(MAXVAL = 999999999, MINVAL = 1, SCALE = 0) [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"SCH",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SCH_ChildSub ];

/// Date
Property SCHSocDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SCH_SocDate ];

/// Smoker Flag
Property SCHSmokerFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SCH_SmokerFlag ];

/// Drinker Flag
Property SCHAlcoholFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SCH_AlcoholFlag ];

/// Time Of Exercise Per Week
Property SCHExerWeek As %Float(MAXVAL = 999999999, MINVAL = 1) [ SqlColumnNumber = 7, SqlFieldName = SCH_ExerWeek ];

/// Duration For Each Exercise
Property SCHExerDuration As %Float(MAXVAL = 999999999, MINVAL = 1) [ SqlColumnNumber = 8, SqlFieldName = SCH_ExerDuration ];

/// Archived Flag
Property SCHRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SCH_RcFlag ];

/// Des Ref to MRCHabits
Property SCHHabitsDR As MRCHabits [ SqlColumnNumber = 10, SqlFieldName = SCH_Habits_DR ];

/// Des Ref to MRCHabitsQty
Property SCHHabitsQtyDR As MRCHabitsQuantity [ SqlColumnNumber = 11, SqlFieldName = SCH_HabitsQty_DR ];

/// Duration in Days
Property SCHDuratDays As %Float [ SqlColumnNumber = 12, SqlFieldName = SCH_DuratDays ];

/// Duration in Month
Property SCHDuratMonth As %Float [ SqlColumnNumber = 13, SqlFieldName = SCH_DuratMonth ];

/// Duration in Year
Property SCHDuratYear As %Float [ SqlColumnNumber = 14, SqlFieldName = SCH_DuratYear ];

/// Onset Date
Property SCHOnsetDate As %Date [ SqlColumnNumber = 15, SqlFieldName = SCH_OnsetDate ];

/// Description
Property SCHDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = SCH_Desc, SqlListType = subnode ];

/// Des Ref CTCP
Property SCHCTCPDR As CTCareProv [ SqlColumnNumber = 17, SqlFieldName = SCH_CTCP_DR ];

/// Date
Property SCHDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 18, SqlFieldName = SCH_Date ];

/// Time
Property SCHTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 19, SqlFieldName = SCH_Time ];

/// Des Ref User
Property SCHUpdateUserDR As SSUser [ SqlColumnNumber = 20, SqlFieldName = SCH_UpdateUser_DR ];

/// InActive
Property SCHInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = SCH_InActive ];

/// UpdateDate
Property SCHUpdateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = SCH_UpdateDate ];

/// UpdateTime
Property SCHUpdateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = SCH_UpdateTime ];

/// Des Ref UpdateHospital
Property SCHUpdateHospitalDR As CTHospital [ SqlColumnNumber = 24, SqlFieldName = SCH_UpdateHospital_DR ];

/// Comments
Property SCHComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = SCH_Comments, SqlListType = subnode ];

/// DSReportFlag
Property SCHDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = SCH_DSReportFlag ];

/// Duration
Property SCHDuration As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = SCH_Duration ];

/// DurationDesc
Property SCHDurationDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = SCH_DurationDesc ];

/// ApproxOnsetDate
Property SCHApproxOnsetDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = SCH_ApproxOnsetDate ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASocHist).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASocHist).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASocHist).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASocHist).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASocHist).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASocHist","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>62</ExtentSize>
<Property name="SCHAlcoholFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHApproxOnsetDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHCTCPDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="SCHChildSub">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="SCHComments">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHDate">
<Selectivity>3.3333%</Selectivity>
</Property>
<Property name="SCHDesc">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="SCHDuratDays">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="SCHDuratMonth">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="SCHDuratYear">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="SCHDuration">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="SCHDurationDesc">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SCHExerDuration">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHExerWeek">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHHabitsDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SCHHabitsQtyDR">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="SCHInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHOnsetDate">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="SCHPAPMIParRef">
<Selectivity>3.0303%</Selectivity>
</Property>
<Property name="SCHRcFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHSmokerFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHSocDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SCHTime">
<Selectivity>1.7857%</Selectivity>
</Property>
<Property name="SCHUpdateDate">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="SCHUpdateHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHUpdateTime">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="SCHUpdateUserDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="PASCHDataMasterMap">
<Data name="SCH_AlcoholFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCH_ApproxOnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SCH_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SCH_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="SCH_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SCH_Desc">
<Node>"REM"</Node>
</Data>
<Data name="SCH_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SCH_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SCH_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SCH_Duration">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SCH_DurationDesc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SCH_ExerDuration">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCH_ExerWeek">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SCH_HabitsQty_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SCH_Habits_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SCH_InActive">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SCH_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SCH_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SCH_SmokerFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCH_SocDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCH_Time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SCH_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SCH_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SCH_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SCH_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCH_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SCH_ChildSub}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SCH_RowId</SqlRowIdName>
<StreamLocation>^User.PASocHistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
