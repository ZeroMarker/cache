/// 用户
Class dbo.SYSUser Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_User, StorageStrategy = Default ]
{

/// Foreign Key FKUserHospital created via DDL
ForeignKey FKUserHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_UserHospital ];

/// Foreign Key FKUserLanguage created via DDL
ForeignKey FKUserLanguage(LanguageDR) References dbo.SYSLanguage(PKSYSLANGUAGE) [ SqlName = FK_UserLanguage ];

/// Foreign Key FKDoctorPostionTitle created via DDL
ForeignKey FKDoctorPostionTitle(PositionTitleDR) References dbo.BTPositionTitle(PKBTPOSITIONTITLE) [ SqlName = FK_DoctorPostionTitle ];

/// Foreign Key FKUserPermission created via DDL
ForeignKey FKUserPermission(PermissionDR) References dbo.SYSPermission(PKSYSPERMISSION) [ SqlName = FK_UserPermission ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSUSER On RowID [ PrimaryKey, SqlName = PK_SYS_USER, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 密码  
Property Password As %Library.String(COLLATION = "Exact", MAXLEN = 64) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 语言  
Property LanguageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 限制级别  
Property SecurityType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

/// PIN密码  
Property PIN As %Library.String(COLLATION = "Exact", MAXLEN = 64) [ SqlColumnNumber = 9 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 职称  
Property PositionTitleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 用户类别  
Property UserType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// Ukey编号  
Property UKeyNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 签名图片  
Property SignImage As %Library.String(COLLATION = "Exact", MAXLEN = 999999) [ SqlColumnNumber = 16 ];

/// 主题  
Property Theme As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 系统菜单模式  {0:左侧菜单, 1:顶部菜单, 2:混合}
Property MenuModel As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 18 ];

/// 权限  
Property PermissionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="SYSUserDefaultData">
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
<Value>Password</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>LanguageDR</Value>
</Value>
<Value name="7">
<Value>SecurityType</Value>
</Value>
<Value name="8">
<Value>PIN</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>PositionTitleDR</Value>
</Value>
<Value name="13">
<Value>UserType</Value>
</Value>
<Value name="14">
<Value>UKeyNo</Value>
</Value>
<Value name="15">
<Value>SignImage</Value>
</Value>
<Value name="16">
<Value>Theme</Value>
</Value>
<Value name="17">
<Value>MenuModel</Value>
</Value>
<Value name="18">
<Value>PermissionDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUserD</DataLocation>
<DefaultData>SYSUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserD</IdLocation>
<IndexLocation>^dbo.SYSUserI</IndexLocation>
<StreamLocation>^dbo.SYSUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
