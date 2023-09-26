/// 血型组配血规则
Class dbo.BBBloodGroupXMatch Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodGroupXMatch, StorageStrategy = Default ]
{

/// Foreign Key FKBBBGCMBComponens created via DDL
ForeignKey FKBBBGCMBComponens(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_BGCM_BComponens ];

/// Foreign Key FKBBBGCMGroup created via DDL
ForeignKey FKBBBGCMGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BB_BGCM_Group ];

/// Foreign Key FKBBBGCMXGroup created via DDL
ForeignKey FKBBBGCMXGroup(XBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BB_BGCM_XGroup ];

Index IndexMaster On (BloodGroupDR, BloodComponentsDR, XBloodGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (BloodGroupDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODGROUPXMATCH On RowID [ PrimaryKey, SqlName = PK_BB_BLOODGROUPXMATCH, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血型组  
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血液成分  
Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 配血血型组  
Property XBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBBloodGroupXMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodGroupDR</Value>
</Value>
<Value name="3">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="4">
<Value>XBloodGroupDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodGroupXMatchD</DataLocation>
<DefaultData>BBBloodGroupXMatchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodGroupXMatchD</IdLocation>
<IndexLocation>^dbo.BBBloodGroupXMatchI</IndexLocation>
<StreamLocation>^dbo.BBBloodGroupXMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
