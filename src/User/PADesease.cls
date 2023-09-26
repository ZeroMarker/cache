/// Patient Desease(1078)
Class User.PADesease Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Desease, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 66;

Index RowIDBasedIDKeyIndex On DESChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship DESParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPADesease, Required, SqlFieldName = DES_ParRef ];

/// Childsub
Property DESChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DES",0))}, SqlColumnNumber = 2, SqlFieldName = DES_Childsub ];

/// DES Ref to MRCICDDx
Property DESMRCICDDxDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = DES_MRCICDDx_DR ];

/// des ref to contageous disease warning
Property DESContageousWarningDR As MRCMedAlrt [ SqlColumnNumber = 4, SqlFieldName = DES_ContageousWarning_DR ];

/// Duration in Days
Property DESDuratDays As %Float [ SqlColumnNumber = 5, SqlFieldName = DES_DuratDays ];

/// Duration in Month
Property DESDuratMonth As %Float [ SqlColumnNumber = 6, SqlFieldName = DES_DuratMonth ];

/// Duration in Year
Property DESDuratYear As %Float [ SqlColumnNumber = 7, SqlFieldName = DES_DuratYear ];

/// Onset Date
Property DESOnsetDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DES_OnsetDate ];

/// Description
Property DESDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = DES_Desc, SqlListType = SUBNODE ];

/// Des Ref CTCP
Property DESCTCPDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = DES_CTCP_DR ];

/// Date
Property DESDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = DES_Date ];

/// Time
Property DESTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = DES_Time ];

/// Des Ref User
Property DESUpdateUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = DES_UpdateUser_DR ];

/// InActive
Property DESInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DES_InActive ];

/// UpdateDate
Property DESUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = DES_UpdateDate ];

/// UpdateTime
Property DESUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = DES_UpdateTime ];

/// Des Ref UpdateHospital
Property DESUpdateHospitalDR As CTHospital [ SqlColumnNumber = 17, SqlFieldName = DES_UpdateHospital_DR ];

/// DSReportFlag
Property DESDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = DES_DSReportFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADesease).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADesease","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADesease).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADesease","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADesease).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADesease","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADesease).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADesease","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADesease).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADesease","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>66</ExtentSize>
<Property name="DESCTCPDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DESChildsub">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="DESContageousWarningDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DESDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DESDate">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="DESDesc">
<Selectivity>2.6316%</Selectivity>
</Property>
<Property name="DESDuratDays">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="DESDuratMonth">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="DESDuratYear">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="DESInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DESMRCICDDxDR">
<Selectivity>2.5000%</Selectivity>
</Property>
<Property name="DESOnsetDate">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="DESParRef">
<Selectivity>3.5714%</Selectivity>
</Property>
<Property name="DESTime">
<Selectivity>1.5152%</Selectivity>
</Property>
<Property name="DESUpdateDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DESUpdateHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DESUpdateTime">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DESUpdateUserDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DES_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DES_ContageousWarning_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DES_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DES_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DES_Desc">
<Node>"REM"</Node>
</Data>
<Data name="DES_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DES_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DES_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DES_InActive">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DES_MRCICDDx_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DES_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DES_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DES_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DES_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DES_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DES_UpdateUser_DR">
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
<Field>DES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DES"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DES_RowId</SqlRowIdName>
<StreamLocation>^User.PADeseaseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
