/// ContractTypeDet(2554)
Class User.PACContractTypeDet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ContractTypeDet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_ContractType Parent Reference
Relationship DETParRef As PACContractType [ Cardinality = parent, Inverse = ChildPACContractTypeDet, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PAC("CONTRTYPE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Date From
Property DETDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DET_DateFrom ];

/// Date To
Property DETDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DET_DateTo ];

/// ContractRole
Property DETContractRole As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DET_ContractRole ];

/// FundArangement
Property DETFundArangement As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DET_FundArangement ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACContractTypeDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContractTypeDet","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACContractTypeDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContractTypeDet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACContractTypeDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContractTypeDet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACContractTypeDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContractTypeDet","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACContractTypeDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACContractTypeDet","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DET_ContractRole">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_FundArangement">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ContractType.CONTRTYPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTRTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ContractType.CONTRTYPE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.PACContractTypeDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
