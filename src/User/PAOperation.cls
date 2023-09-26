/// Patient Operation(1079)
Class User.PAOperation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Operation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 86;

Index RowIDBasedIDKeyIndex On OPERChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship OPERParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAOperation, Required, SqlFieldName = OPER_ParRef ];

/// Childsub
Property OPERChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OPER",0))}, SqlColumnNumber = 2, SqlFieldName = OPER_Childsub ];

/// Des Ref to ORCOper
Property OPERORCOperDR As ORCOperation [ SqlColumnNumber = 3, SqlFieldName = OPER_ORCOper_DR ];

/// Operation Date
Property OPERDate As %Date [ SqlColumnNumber = 4, SqlFieldName = OPER_Date ];

/// Duration in Days
Property OPERDuratDays As %Float [ SqlColumnNumber = 5, SqlFieldName = OPER_DuratDays ];

/// Duration in Month
Property OPERDuratMonth As %Float [ SqlColumnNumber = 6, SqlFieldName = OPER_DuratMonth ];

/// Duration in Year
Property OPERDuratYear As %Float [ SqlColumnNumber = 7, SqlFieldName = OPER_DuratYear ];

/// Onset Date
Property OPEROnsetDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OPER_OnsetDate ];

/// Description
Property OPERDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = OPER_Desc, SqlListType = SUBNODE ];

/// Des Ref Doctor
Property OPERDoctorDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = OPER_Doctor_DR ];

/// Date Entered
Property OPERDateEntered As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = OPER_DateEntered ];

/// Time Entered
Property OPERTimeEntered As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = OPER_TimeEntered ];

/// Des REf User
Property OPERUpdateUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = OPER_UpdateUser_DR ];

/// InActive
Property OPERInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = OPER_InActive ];

/// UpdateDate
Property OPERUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = OPER_UpdateDate ];

/// UpdateTime
Property OPERUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = OPER_UpdateTime ];

/// Des Ref UpdateHospital
Property OPERUpdateHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = OPER_UpdateHospital_DR ];

/// Des Ref Laterality
Property OPERLateralityDR As PACLaterality [ SqlColumnNumber = 18, SqlFieldName = OPER_Laterality_DR ];

/// DSReportFlag
Property OPERDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = OPER_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAOperation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOperation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAOperation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOperation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAOperation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOperation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAOperation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOperation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAOperation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOperation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>86</ExtentSize>
<Property name="OPERChildsub">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="OPERDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OPERDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OPERDateEntered">
<Selectivity>2.0833%</Selectivity>
</Property>
<Property name="OPERDesc">
<Selectivity>3.3333%</Selectivity>
</Property>
<Property name="OPERDoctorDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="OPERDuratDays">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="OPERDuratMonth">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="OPERDuratYear">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="OPERInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OPERLateralityDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="OPERORCOperDR">
<Selectivity>2.4390%</Selectivity>
</Property>
<Property name="OPEROnsetDate">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="OPERParRef">
<Selectivity>1.9608%</Selectivity>
</Property>
<Property name="OPERTimeEntered">
<Selectivity>1.1628%</Selectivity>
</Property>
<Property name="OPERUpdateDate">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="OPERUpdateHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OPERUpdateTime">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="OPERUpdateUserDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OPER_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPER_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPER_DateEntered">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPER_Desc">
<Node>"REM"</Node>
</Data>
<Data name="OPER_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPER_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPER_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPER_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPER_InActive">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPER_Laterality_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OPER_ORCOper_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPER_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPER_TimeEntered">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPER_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPER_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPER_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPER_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OPER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OPER_RowId</SqlRowIdName>
<StreamLocation>^User.PAOperationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
