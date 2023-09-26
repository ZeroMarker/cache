/// LocalityType
Class User.CTLocalityType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocalityType, StorageStrategy = SQLStorage ]
{

/// Code
Property LOCTYPECode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LOCTYPE_Code ];

/// Description
Property LOCTYPEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LOCTYPE_Desc ];

/// NationalCode
Property LOCTYPENationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LOCTYPE_NationalCode ];

/// Type
/// 增加街道类型（Street）和社区类型（Community），街道为社区上级单位。
/// 街道类型的LOCTYPENationalCode对应User.CTCityArea->CITAREACode，社区类型的LOCTYPENationalCode为User.CTLocalityType->LOCTYPECode (并且LOCTYPEType=S）
/// BDP-caihaozhe 2015-11-12 update 
Property LOCTYPEType As %String(DISPLAYLIST = ",Town,Village,Street,Community", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",T,V,S,C") [ SqlColumnNumber = 5, SqlFieldName = LOCTYPE_Type ];

/// ActiveFlag
/// BDP-caihaozhe   2015-11-26   update 
Property LOCTYPEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = LOCTYPE_ActiveFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocalityType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocalityType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocalityType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocalityType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocalityType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocalityType","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("LOCTYPE",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="LOCTYPE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LOCTYPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOCTYPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LOCTYPE_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOCTYPE_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LOCTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LOCTYPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOCTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOCTYPE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOCTYPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOCTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOCTYPE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOCTYPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOCTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocalityTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
