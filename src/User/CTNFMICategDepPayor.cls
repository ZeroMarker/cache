/// CT NFMI Categ Dep Payor(1936)
Class User.CTNFMICategDepPayor Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_NFMICategDepPayor, StorageStrategy = SQLStorage ]
{

/// Amt
Property PAAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = PA_Amt ];

/// Childsub
Property PAChildsub As %Float [ InitialExpression = {$i(^CT("NFMI",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"PA",0))}, SqlColumnNumber = 2, SqlFieldName = PA_Childsub ];

/// Date
Property PADate As %Date [ SqlColumnNumber = 3, SqlFieldName = PA_Date ];

/// Des Ref InsType
Property PAInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = PA_InsType_DR ];

/// CT_NFMI_CategDepart Parent Reference
Relationship PAParRef As CTNFMICategDepart [ Cardinality = parent, Inverse = ChildCTNFMICategDepPayor, Required, SqlFieldName = PA_ParRef ];

/// Weight
Property PAWeight As %Float [ SqlColumnNumber = 5, SqlFieldName = PA_Weight ];

Index RowIDBasedIDKeyIndex On PAChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepPayor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepPayor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepPayor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepPayor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepPayor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepPayor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTNFMICategDepPayor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepPayor","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTNFMICategDepPayor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepPayor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PA_Amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PA_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_Weight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_NFMI_Category.NFMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CT_NFMI_CategDepart.DEP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_NFMI_Category.NFMI_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_NFMI_CategDepart.DEP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PA"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PA_RowId</SqlRowIdName>
<StreamLocation>^User.CTNFMICategDepPayorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
