Class EPRmeta.Privilege.PowerRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On RoleName [ Unique ];

/// 动作
Property PAction As list Of EPRmeta.Privilege.PowerAction;

/// 名称
Property RoleName As %String(TRUNCATE = 1);

/// 用户组
Property UserGroup As list Of %String(TRUNCATE = 1);

/// 取得角色的行为和用户组
Method GetActionsAndGroups(ByRef argActions As %List, ByRef argGroups As %List) As %Status
{
	
	s $ETrap="w 0"
	
	s i=0, j=1, tmpVar=""
	do
	{
		s tmpVar=##this.PAction.GetObjectIdNext(i)
		q:(tmpVar="")
		s $li(argActions,j)=tmpVar
		s i=i+1
		s j=j+1
	} while 1
	
	s i=0, j=1, tmpVar=""
	do
	{
		s tmpVar=##this.UserGroup.GetObjectIdNext(i)
		q:(tmpVar="")
		s $li(argGroups,j)=tmpVar
		s i=i+1
		s j=j+1
	} while 1
	
	q $$$OK
}

ClassMethod GetGroupRole(argGroupID As %String) As %String
{
	k %msql
	set RoleID=""
	set exist="0"
	Set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
	If rs.QueryIsValid()
	{	///
		Do rs.Prepare("SELECT ID FROM EPRmeta_Privilege.PowerRole")
		Set status=rs.Execute() // no parameters required
		If 'status Quit ""
		WHILE rs.Next() 
		{
			set RoleID=rs.Data("ID")
			set i=0
			set aPowerRole=##class(DHC.EPR.PowerRole).%OpenId(RoleID)
			do
			{
				s tmpVar=aPowerRole.UserGroup.GetObjectIdNext(i)
				i (tmpVar=argGroupID) {s exist="1"}
				q:(tmpVar="")||(tmpVar=argGroupID)
				s i=i+1
			} while 1
			q:(tmpVar=argGroupID)
		}
	}
	q:(exist="1") RoleID
	q ""
}

/// 设置动作和用户组, 由于不能在.net中直接设置这两个属性, 需要单独建立一个方法
Method SetActionsAndGroups(argActions As %List, argGroups As %List) As %Status
{
	s $ETrap="w 0"
	s i=0
	
	d ##this.PAction.Clear()
	d ##this.UserGroup.Clear()

	for i=1:1:$ll(argActions) {
		d ##this.PAction.InsertObjectId($li(argActions,i))
		}
		
	s i=0
	for i=1:1:$ll(argGroups) {
		d ##this.UserGroup.InsertObjectId($li(argGroups,i))
		}
	
	q ##this.%Save()
}

/// 查询所有角色配置
Query SelectAll() As %SQLQuery(CONTAINID = 1)
{
 SELECT ID,RoleName FROM EPRmeta_Privilege.PowerRole
 ORDER BY ID
}

Storage Default
{
<Data name="PowerRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAction</Value>
</Value>
<Value name="3">
<Value>RoleName</Value>
</Value>
<Value name="4">
<Value>UserGroup</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PowerRoleD</DataLocation>
<DefaultData>PowerRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PowerRoleD</IdLocation>
<IndexLocation>^DHCEPRM.PowerRoleI</IndexLocation>
<StreamLocation>^DHCEPRM.PowerRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
