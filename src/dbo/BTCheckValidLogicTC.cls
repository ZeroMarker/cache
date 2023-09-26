/// BTCheckValidLogicTC
Class dbo.BTCheckValidLogicTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidLogicTC, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidLogicTC created via DDL
ForeignKey FKCheckValidLogicTC(CheckValidLogicDR) References dbo.BTCheckValidLogic(PKBTCHECKVALIDLOGIC) [ SqlName = FK_CheckValidLogicTC ];

/// Foreign Key FKCheckValidLogicTCTestCode created via DDL
ForeignKey FKCheckValidLogicTCTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidLogicTCTestCode ];

Index IndexDataMaster On (CheckValidLogicDR, TestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDLOGICTC On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDLOGICTC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 自动审核项目  
Property CheckValidLogicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCheckValidLogicTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidLogicDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidLogicTCD</DataLocation>
<DefaultData>BTCheckValidLogicTCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidLogicTCD</IdLocation>
<IndexLocation>^dbo.BTCheckValidLogicTCI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidLogicTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
