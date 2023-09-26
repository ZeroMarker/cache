/// Past History Condition(1156)
Class User.PAPastHistCondition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PastHistCondition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 230;

Index RowIDBasedIDKeyIndex On PHISTChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship PHISTParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAPastHistCondition, Required, SqlFieldName = PHIST_ParRef ];

/// Childsub
Property PHISTChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PHIST",0))}, SqlColumnNumber = 2, SqlFieldName = PHIST_Childsub ];

/// Des Ref PastHist
Property PHISTPastHistDR As MRCPastHistCondit [ SqlColumnNumber = 3, SqlFieldName = PHIST_PastHist_DR ];

/// Onset Date
Property PHISTOnsetDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PHIST_OnsetDate ];

/// Duration in Days
Property PHISTDuratDays As %Float [ SqlColumnNumber = 5, SqlFieldName = PHIST_DuratDays ];

/// Duration in Month
Property PHISTDuratMonth As %Float [ SqlColumnNumber = 6, SqlFieldName = PHIST_DuratMonth ];

/// Duration in Year
Property PHISTDuratYear As %Float [ SqlColumnNumber = 7, SqlFieldName = PHIST_DuratYear ];

/// Description
Property PHISTDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = PHIST_Desc, SqlListType = SUBNODE ];

/// Des Ref CTCP
Property PHISTCTCPDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = PHIST_CTCP_DR ];

/// Date
Property PHISTDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = PHIST_Date ];

/// Time
Property PHISTTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = PHIST_Time ];

/// Des Ref User
Property PHISTUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = PHIST_UpdateUser_DR ];

/// InActive
Property PHISTInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PHIST_InActive ];

/// UpdateDate
Property PHISTUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PHIST_UpdateDate ];

/// UpdateTime
Property PHISTUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PHIST_UpdateTime ];

/// Des Ref UpdateHospital
Property PHISTUpdateHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = PHIST_UpdateHospital_DR ];

/// DSReportFlag
Property PHISTDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PHIST_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPastHistCondition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPastHistCondition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPastHistCondition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPastHistCondition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPastHistCondition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPastHistCondition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPastHistCondition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPastHistCondition","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPastHistCondition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPastHistCondition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>230</ExtentSize>
<Property name="PHISTCTCPDR">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="PHISTChildsub">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PHISTDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PHISTDate">
<Selectivity>1.2048%</Selectivity>
</Property>
<Property name="PHISTDesc">
<Selectivity>1.3699%</Selectivity>
</Property>
<Property name="PHISTDuratDays">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="PHISTDuratMonth">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="PHISTDuratYear">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="PHISTInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PHISTOnsetDate">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="PHISTParRef">
<Selectivity>0.4717%</Selectivity>
</Property>
<Property name="PHISTPastHistDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="PHISTTime">
<Selectivity>0.4367%</Selectivity>
</Property>
<Property name="PHISTUpdateDate">
<Selectivity>0.9804%</Selectivity>
</Property>
<Property name="PHISTUpdateHospitalDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PHISTUpdateTime">
<Selectivity>0.5025%</Selectivity>
</Property>
<Property name="PHISTUpdateUserDR">
<Selectivity>9.0909%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PHIST_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHIST_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHIST_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHIST_Desc">
<Node>"REM"</Node>
</Data>
<Data name="PHIST_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHIST_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHIST_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHIST_InActive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHIST_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHIST_PastHist_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHIST_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHIST_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHIST_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHIST_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHIST_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHIST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHIST"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHIST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHIST_RowId</SqlRowIdName>
<StreamLocation>^User.PAPastHistConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
