/// Inquiry Table(1422)
Class User.INInquiry Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Inquiry, StorageStrategy = SQLStorage ]
{

/// Code
Property INQCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INQ_Code ];

/// Description1
Property INQDesc1 As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INQ_Desc1 ];

Index RowIDBasedIDKeyIndex On INQCode [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INInquiry).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INInquiry","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INInquiry).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INInquiry","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INInquiry).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INInquiry","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INInquiry).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INInquiry","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INInquiry).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INInquiry","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INQ_Desc1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TMP</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INQ_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STOCK"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$j</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INQ_Code}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IN_Inquiry</SqlRowIdName>
<StreamLocation>^User.INInquiryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
