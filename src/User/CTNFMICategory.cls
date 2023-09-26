/// NFMI Category(1106)
Class User.CTNFMICategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_NFMI_Category, StorageStrategy = SQLStorage ]
{

Relationship ChildCTNFMICategDepart As CTNFMICategDepart [ Cardinality = children, Inverse = DEPParRef ];

/// Code
Property NFMICode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = NFMI_Code ];

/// Description
Property NFMIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = NFMI_Desc ];

/// Insur Batch Only
Property NFMIInsBatchOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = NFMI_InsBatchOnly ];

/// Des Ref NFMI
Property NFMILinkNFMIDR As CTNFMICategory [ SqlColumnNumber = 5, SqlFieldName = NFMI_LinkNFMI_DR ];

/// Des REf SubGovCateg
Property NFMIGovSubCategDR As CTGovernSubcat [ SqlColumnNumber = 6, SqlFieldName = NFMI_GovSubCateg_DR ];

Index NFMICodeUnqIdx1 On NFMICode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTNFMICategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTNFMICategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTNFMICategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTNFMICategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTNFMICategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTNFMICategory","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="NFMICode">
<Selectivity>1</Selectivity>
</Property>
<Property name="NFMIDesc">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="NFMIGovSubCategDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="NFMIInsBatchOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="NFMILinkNFMIDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("NFMI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NFMI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NFMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NFMI_GovSubCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NFMI_InsBatchOnly">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NFMI_LinkNFMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NFMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NFMI_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NFMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NFMI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NFMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NFMI_RowId</SqlRowIdName>
<StreamLocation>^User.CTNFMICategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
