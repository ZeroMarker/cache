Class CKB.PDSS.UserAuthority Extends (%Persistent, User.Abstract) [ SqlRowIdName = CUA_RowID, SqlTableName = UserAuthority ]
{

/// D ##class(CKB.PDSS.UserAuthority).%BuildIndices()
/// 用户id  
Property CUAUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = CUA_User_Dr ];

/// 职务id  
Property CUARoleDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = CUA_Role_Dr ];

/// 岗位id  
Property CUAJobDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = CUA_Job_Dr ];

Index IndexUser On CUAUserDr As Exact;

Index IndexUserRoleJob On (CUAUserDr As Exact, CUARoleDr As Exact, CUAJobDr As Exact);

Storage Default
{
<Data name="UserAuthorityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUAUserDr</Value>
</Value>
<Value name="3">
<Value>CUARoleDr</Value>
</Value>
<Value name="4">
<Value>CUAJobDr</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.UserAuthorityD</DataLocation>
<DefaultData>UserAuthorityDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.UserAuthorityD</IdLocation>
<IndexLocation>^CKB.PDSS.UserAuthorityI</IndexLocation>
<StreamLocation>^CKB.PDSS.UserAuthorityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
