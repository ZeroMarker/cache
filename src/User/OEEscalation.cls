/// Escalation(2492)
Class User.OEEscalation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_Escalation, StorageStrategy = SQLStorage ]
{

/// Escalation Date
Property OEESCEscalationDate As %Date [ SqlColumnNumber = 2, SqlFieldName = OEESC_EscalationDate ];

/// Escalation Time
Property OEESCEscalationTime As %Time [ SqlColumnNumber = 3, SqlFieldName = OEESC_EscalationTime ];

/// Des Ref EscalationLevel
Property OEESCEscalationLevelDR As OECResultEscalation [ SqlColumnNumber = 4, SqlFieldName = OEESC_EscalationLevel_DR ];

/// Contact Method
Property OEESCContactMethod As %String(DISPLAYLIST = ",Email,Fax,Manual Notification (Phone Call),Post,Report,Pager", MAXLEN = 32, TRUNCATE = 1, VALUELIST = ",E,F,M,P,R,PG") [ SqlColumnNumber = 5, SqlFieldName = OEESC_ContactMethod ];

/// Des Ref OrderItem
Property OEESCOrderItemDR As OEOrdItem [ SqlColumnNumber = 6, SqlFieldName = OEESC_OrderItem_DR ];

/// Des Ref MainCareProvider
Property OEESCMainCareProviderDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = OEESC_MainCareProvider_DR ];

/// Des Ref HeadOfDept
Property OEESCHeadOfDeptDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = OEESC_HeadOfDept_DR ];

/// Des Ref HeadOfDivision
Property OEESCHeadOfDivisionDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = OEESC_HeadOfDivision_DR ];

/// Des Ref MedicalSuperintendent
Property OEESCMedicalSuperintendentDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = OEESC_MedicalSuperintendent_DR ];

/// External Info System
Property OEESCServiceProvider As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = OEESC_ServiceProvider ];

/// Des Ref HeadOfDeptGroup
Property OEESCHeadOfDeptGroupDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = OEESC_HeadOfDeptGroup_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEEscalation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEEscalation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEEscalation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEEscalation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEEscalation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEEscalation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEEscalation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEEscalation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEES(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OEESC_ContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OEESC_EscalationDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OEESC_EscalationLevel_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OEESC_EscalationTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEESC_HeadOfDeptGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OEESC_HeadOfDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OEESC_HeadOfDivision_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OEESC_MainCareProvider_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OEESC_MedicalSuperintendent_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OEESC_OrderItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OEESC_ServiceProvider">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^OEES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEESC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OEESC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^OEES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEESC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEESC_OrderItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEESC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OEESC_RowId</SqlRowIdName>
<StreamLocation>^User.OEEscalationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
