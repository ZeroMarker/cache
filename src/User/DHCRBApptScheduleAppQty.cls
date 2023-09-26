Class User.DHCRBApptScheduleAppQty Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_RBApptScheduleAppQty, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASQChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ASQASParRef As User.DHCRBApptSchedule [ Cardinality = parent, Inverse = ChildDHCRBApptScheduleAppQty ];

Property ASQChildsub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"AQ",0))}, SqlColumnNumber = 2, SqlFieldName = ASQ_Childsub ];

Property ASQMethodDR As User.RBCAppointMethod [ Required, SqlColumnNumber = 3, SqlFieldName = ASQ_Method_DR ];

Property ASQQty As %Float [ SqlColumnNumber = 4, SqlFieldName = ASQ_Qty ];

Property ASQStartNum As %Float [ SqlColumnNumber = 5, SqlFieldName = ASQ_StartNum ];

Property ASQLastUpDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ASQ_LastUpDate ];

Property ASQLastUpTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ASQ_LastUpTime ];

Property ASQLastUpUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = ASQ_LastUpUser_DR ];

Property ASQMaxQty As %Float [ SqlColumnNumber = 9, SqlFieldName = ASQ_MaxQty ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ASQ_LastUpDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASQ_LastUpTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASQ_LastUpUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASQ_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASQ_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASQ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASQ_StartNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_RBApptSchedule.AS_RES_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_RBApptSchedule.AS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>ASQ_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_RBApptSchedule.AS_RES_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_RBApptSchedule.AS_Childsub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AQ"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ASQ_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptScheduleAppQtyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
