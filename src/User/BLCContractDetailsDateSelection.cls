/// BLC Contract DetailsDateSel(1491)
Class User.BLCContractDetailsDateSelection Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_ContractDetailsDateSelection, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property SELARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = SEL_ARCIM_DR ];

/// Des Ref ARCOS
Property SELARCOSDR As ARCOrdSets [ SqlColumnNumber = 10, SqlFieldName = SEL_ARCOS_DR ];

/// Childsub
Property SELChildsub As %Float [ InitialExpression = {$i(^BLC("CONTR",$p(%d(0),"||"),"DATE",$p(%d(0),"||",2),"SEL",0))}, SqlColumnNumber = 2, SqlFieldName = SEL_Childsub ];

/// Des REf Department
Property SELDepartmentDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = SEL_Department_DR ];

/// Episode Type
Property SELEpisodeType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,HealthPromotion,NewBorn", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,O,E,H,N") [ SqlColumnNumber = 6, SqlFieldName = SEL_EpisodeType ];

/// Insert/Delete Flag
Property SELFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SEL_Flag ];

/// Order Set Flag
Property SELOrderSetFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SEL_OrderSetFlag ];

/// BLC_ContractDetailsDate Parent Reference
Relationship SELParRef As BLCContractDetailsDate [ Cardinality = parent, Inverse = ChildBLCContractDetailsDateSele, Required, SqlFieldName = SEL_ParRef ];

/// Qty
Property SELQty As %Float [ SqlColumnNumber = 12, SqlFieldName = SEL_Qty ];

/// Text1 (DR to BillGroup/Govern)
Property SELText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SEL_Text1 ];

/// Text2 (DR to Bill Subgrp/Govern)
Property SELText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SEL_Text2 ];

Index RowIDBasedIDKeyIndex On SELChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 163;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateSelection).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateSelection","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateSelection).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateSelection","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateSelection).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateSelection","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCContractDetailsDateSelection).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateSelection","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCContractDetailsDateSelection).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateSelection","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>163</ExtentSize>
<Property name="SELARCIMDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="SELARCOSDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SELChildsub">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="SELDepartmentDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SELEpisodeType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="SELFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SELOrderSetFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SELParRef">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="SELQty">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SELText1">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="SELText2">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SEL_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SEL_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SEL_Department_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SEL_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SEL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SEL_OrderSetFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SEL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SEL_Text1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SEL_Text2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SEL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Condition>{SEL_ARCIM_DR}'=""</Condition>
<Global>^BLC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L11}</Expression>
<Field>SEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SEL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SEL_Text1}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SEL_Text2}</Expression>
</Subscript>
<Subscript name="10">
<Expression>
<![CDATA[{SEL_ARCIM_DR}_"&"_{SEL_Department_DR}_"&"_{SEL_EpisodeType}]]></Expression>
</Subscript>
<Subscript name="11">
<Expression>{SEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Condition>{SEL_ARCOS_DR}'=""</Condition>
<Global>^BLC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L11}</Expression>
<Field>SEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SEL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SEL_Text1}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SEL_Text2}</Expression>
</Subscript>
<Subscript name="10">
<Expression>
<![CDATA[{SEL_ARCOS_DR}_"&"_{SEL_Department_DR}_"&"_{SEL_EpisodeType}]]></Expression>
</Subscript>
<Subscript name="11">
<Expression>{SEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText1">
<Condition>{SEL_Text2}=""</Condition>
<Global>^BLC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>SEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SEL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"Text1"</Expression>
</Subscript>
<Subscript name="8">
<Expression>
<![CDATA[{SEL_Text1}_"&"_{SEL_Department_DR}_"&"_{SEL_EpisodeType}]]></Expression>
</Subscript>
<Subscript name="9">
<Expression>{SEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText2">
<Condition>{SEL_Text2}'="",{SEL_ARCIM_DR}="",{SEL_ARCOS_DR}=""</Condition>
<Global>^BLC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>SEL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SEL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"Text2"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SEL_Text1}</Expression>
</Subscript>
<Subscript name="9">
<Expression>
<![CDATA[{SEL_Text2}_"&"_{SEL_Department_DR}_"&"_{SEL_EpisodeType}]]></Expression>
</Subscript>
<Subscript name="10">
<Expression>{SEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SEL_RowId</SqlRowIdName>
<StreamLocation>^User.BLCContractDetailsDateSelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
