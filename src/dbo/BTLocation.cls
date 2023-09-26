/// 检验科室
Class dbo.BTLocation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Location, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On (HospitalDR, HISCode) [ SqlName = Index_HISCode, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBTLOCATION On RowID [ PrimaryKey, SqlName = PK_BT_LOCATION, Type = index, Unique ];

/// Foreign Key FKLocationHospital created via DDL
ForeignKey FKLocationHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_LocationHospital ];

/// Foreign Key FKLocationWhoNetType created via DDL
ForeignKey FKLocationWhoNetType(LocationTypeWhoNetDR) References dbo.BTLocationWhoNetClass(PKBTLOCATIONWHONETCLASS) [ SqlName = FK_LocationWhoNetType ];

/// Foreign Key FKLocationType created via DDL
ForeignKey FKLocationType(LocationTypeDR) References dbo.BTLocationClass(PKBTLOCATIONCLASS) [ SqlName = FK_LocationType ];

/// Foreign Key FKLocationType created via DDL
ForeignKey FKLocationWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_LocationWorkGroup ];

/// Foreign Key FKLocationType created via DDL
ForeignKey FKLocationBBLocationClass(BBLocationClassDR) References dbo.BBRULocationClass(PKBBRULOCATIONCLASS) [ SqlName = FK_LocationBBLocationClass ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// HIS系统对照码  
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6 ];

/// 病WHONET对照码  
Property WCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

/// 负责人  
Property Leader As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 联系电话  
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 科室类别  
Property LocationTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 病区WhoNet类型  
Property WhonetType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

///       
Property LocationTypeWhoNetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 是否为登录科室      
Property IsLogin As %Library.Boolean [ SqlColumnNumber = 15 ];

///   所属输血科   
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 标本是否特殊提示      
Property IsPrompt As %Library.Boolean [ SqlColumnNumber = 17 ];

/// L:科室 W:病区      
Property LocType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 18 ];

/// 输血知识库科室类别   
Property BBLocationClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="BTLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>HISCode</Value>
</Value>
<Value name="6">
<Value>WCode</Value>
</Value>
<Value name="7">
<Value>Leader</Value>
</Value>
<Value name="8">
<Value>Telephone</Value>
</Value>
<Value name="9">
<Value>LocationTypeDR</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>WhonetType</Value>
</Value>
<Value name="13">
<Value>LocationTypeWhoNetDR</Value>
</Value>
<Value name="14">
<Value>IsLogin</Value>
</Value>
<Value name="15">
<Value>WorkGroupDR</Value>
</Value>
<Value name="16">
<Value>IsPrompt</Value>
</Value>
<Value name="17">
<Value>LocType</Value>
</Value>
<Value name="18">
<Value>BBLocationClassDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTLocationD</DataLocation>
<DefaultData>BTLocationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTLocationD</IdLocation>
<IndexLocation>^dbo.BTLocationI</IndexLocation>
<StreamLocation>^dbo.BTLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
