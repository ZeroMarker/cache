/// Patient Drugs(1300)
Class User.PADrugs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Drugs, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 29;

Index RowIDBasedIDKeyIndex On DRGChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship DRGParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPADrugs, Required, SqlFieldName = DRG_ParRef ];

/// Childsub
Property DRGChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DRG",0))}, SqlColumnNumber = 2, SqlFieldName = DRG_Childsub ];

/// Des Ref to DrugMast
Property DRGDrugMastDR As PHCDrgMast [ SqlColumnNumber = 3, SqlFieldName = DRG_DrugMast_DR ];

/// Duration in Days
Property DRGDuratDays As %Float [ SqlColumnNumber = 4, SqlFieldName = DRG_DuratDays ];

/// Duration in Month
Property DRGDuratMonth As %Float [ SqlColumnNumber = 5, SqlFieldName = DRG_DuratMonth ];

/// Duration in Year
Property DRGDuratYear As %Float [ SqlColumnNumber = 6, SqlFieldName = DRG_DuratYear ];

/// Onset Date
Property DRGOnsetDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DRG_OnsetDate ];

/// Description
Property DRGDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = DRG_Desc, SqlListType = SUBNODE ];

/// Date
Property DRGDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = DRG_Date ];

/// Time
Property DRGTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = DRG_Time ];

/// Des Ref CTCP
Property DRGCTCPDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = DRG_CTCP_DR ];

/// Des Ref User
Property DRGUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = DRG_UpdateUser_DR ];

/// InActive
Property DRGInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DRG_InActive ];

/// UpdateDate
Property DRGUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = DRG_UpdateDate ];

/// UpdateTime
Property DRGUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = DRG_UpdateTime ];

/// Des Ref UpdateHospital
Property DRGUpdateHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = DRG_UpdateHospital_DR ];

/// DSReportFlag
Property DRGDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DRG_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADrugs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugs","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADrugs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugs","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADrugs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugs","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADrugs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugs","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADrugs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugs","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>29</ExtentSize>
<Property name="DRGCTCPDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DRGChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRGDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRGDate">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="DRGDesc">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="DRGDrugMastDR">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="DRGDuratDays">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="DRGDuratMonth">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DRGDuratYear">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DRGInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRGOnsetDate">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="DRGParRef">
<Selectivity>4.5455%</Selectivity>
</Property>
<Property name="DRGTime">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="DRGUpdateDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DRGUpdateHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DRGUpdateTime">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DRGUpdateUserDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DRG_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRG_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRG_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRG_Desc">
<Node>"REM"</Node>
</Data>
<Data name="DRG_DrugMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRG_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRG_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRG_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRG_InActive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRG_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRG_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRG_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRG_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRG_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRG_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DRG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DRG_RowId</SqlRowIdName>
<StreamLocation>^User.PADrugsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
