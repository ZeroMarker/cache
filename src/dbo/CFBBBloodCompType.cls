Class dbo.CFBBBloodCompType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBB_BloodCompType, StorageStrategy = Default ]
{

Index IndexMaster On (BloodComponentsDR, ReqTypeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKCFBBBCTBComponets(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_CFBB_BCT_BComponets ];

/// Foreign Key FKBBRTestItemReqType created via DDL
ForeignKey FKCFBBBCTReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_CFBB_BCT_ReqType ];

/// DDL Primary Key Specification
Index PKCFBBBLOODCOMPTYPE On RowID [ PrimaryKey, SqlName = PK_CFBB_BLOODCOMPTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血液成分  
Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 申请类型  
Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否查询解冻  {1:是,0:否}
Property IsThaw As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="CFBBBloodCompTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="3">
<Value>ReqTypeDR</Value>
</Value>
<Value name="4">
<Value>IsThaw</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBBBloodCompTypeD</DataLocation>
<DefaultData>CFBBBloodCompTypeDefaultData</DefaultData>
<IdLocation>^dbo.CFBBBloodCompTypeD</IdLocation>
<IndexLocation>^dbo.CFBBBloodCompTypeI</IndexLocation>
<StreamLocation>^dbo.CFBBBloodCompTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
