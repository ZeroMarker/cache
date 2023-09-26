Class User.DHCDocDataChangeApplyLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCA_RowId, SqlTableName = DHC_DocDataChangeApplyLog ]
{

Index RowIDBasedIDKeyIndex On (DCAParRef, DCAChildSub) [ IdKey, PrimaryKey, Unique ];

/// AS_RES_ParRef
Property DCAParRef As User.DHCDocDataChangeApply [ Required, SqlColumnNumber = 2, SqlFieldName = DCA_ParRef ];

/// AS_Childsub
Property DCAChildSub As %Float(MINVAL = 1) [ InitialExpression = {$i(^DHCDocDataChangeApplyLog(+$s($d(initvalue):initvalue,1:%d(2))))}, Required, SqlColumnNumber = 3, SqlFieldName = DCA_ChildSub ];

Property DCADate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = DCA_Date ];

Property DCATime As %Time [ SqlColumnNumber = 5, SqlFieldName = DCA_Time ];

Property DCAStatus As %String [ Required, SqlColumnNumber = 6, SqlFieldName = DCA_Status ];

Property DCAUpUserID As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DCA_UpUserID ];

Storage NewStorage1
{
<SqlIdExpression>DCA_RowId</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCA_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCA_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCA_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCA_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCA_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCA_UpUserID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocDataChangeApplyLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCA_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DCA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DCA_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

Storage Default
{
<Data name="DHCDocDataChangeApplyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCADate</Value>
</Value>
<Value name="3">
<Value>DCATime</Value>
</Value>
<Value name="4">
<Value>DCAStatus</Value>
</Value>
<Value name="5">
<Value>DCAUpUserID</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocDataChangeApplyLogD</DataLocation>
<DefaultData>DHCDocDataChangeApplyLogDefaultData</DefaultData>
<IdLocation>^User.DHCDocDataChangeApplyLogD</IdLocation>
<IndexLocation>^User.DHCDocDataChangeApplyLogI</IndexLocation>
<StreamLocation>^User.DHCDocDataChangeApplyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
