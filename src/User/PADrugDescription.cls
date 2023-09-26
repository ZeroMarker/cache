/// Patient Drug Description(1301)
Class User.PADrugDescription Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DrugDescription, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 16;

Index RowIDBasedIDKeyIndex On DRDChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship DRDParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPADrugDescription, Required, SqlFieldName = DRD_ParRef ];

/// Childsub
Property DRDChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DRD",0))}, SqlColumnNumber = 2, SqlFieldName = DRD_Childsub ];

/// Description
Property DRDDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = DRD_Desc, SqlListType = SUBNODE ];

/// Duration in Days
Property DRDDuratDays As %Float [ SqlColumnNumber = 4, SqlFieldName = DRD_DuratDays ];

/// Duration in Month
Property DRDDuratMonth As %Float [ SqlColumnNumber = 5, SqlFieldName = DRD_DuratMonth ];

/// Duration in Year
Property DRDDuratYear As %Float [ SqlColumnNumber = 6, SqlFieldName = DRD_DuratYear ];

/// Onset Date
Property DRDOnsetDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DRD_OnsetDate ];

/// Notes
Property DRDNotes As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = DRD_Notes, SqlListType = SUBNODE ];

/// Des Ref CTCP
Property DRDCTCPDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = DRD_CTCP_DR ];

/// Date
Property DRDDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = DRD_Date ];

/// Time
Property DRDTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = DRD_Time ];

/// Des Ref User
Property DRDUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = DRD_UpdateUser_DR ];

/// InActive
Property DRDInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DRD_InActive ];

/// UpdateDate
Property DRDUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = DRD_UpdateDate ];

/// UpdateTime
Property DRDUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = DRD_UpdateTime ];

/// Des Ref UpdateHospital
Property DRDUpdateHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = DRD_UpdateHospital_DR ];

/// DSReportFlag
Property DRDDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DRD_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADrugDescription).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugDescription","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADrugDescription).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugDescription","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADrugDescription).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugDescription","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADrugDescription).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugDescription","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADrugDescription).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADrugDescription","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>16</ExtentSize>
<Property name="DRDCTCPDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DRDChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRDDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRDDate">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DRDDesc">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="DRDDuratDays">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="DRDDuratMonth">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="DRDDuratYear">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DRDInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DRDNotes">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="DRDOnsetDate">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DRDParRef">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DRDTime">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="DRDUpdateDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DRDUpdateHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DRDUpdateTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DRDUpdateUserDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DRD_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRD_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRD_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRD_Desc">
<Node>"REM"</Node>
</Data>
<Data name="DRD_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRD_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRD_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRD_InActive">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRD_Notes">
<Node>"NOT"</Node>
</Data>
<Data name="DRD_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRD_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRD_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRD_UpdateUser_DR">
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
<Field>DRD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DRD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DRD_RowId</SqlRowIdName>
<StreamLocation>^User.PADrugDescriptionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
