Class DtPortal.Configure.RoleGroupItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DtPortal.Configure.RoleGroup [ Cardinality = parent, Inverse = ChildItem ];

/// 安全组指针
Property GroupObj As User.SSGroup;

/// 更新日期
Property RoleGUpdate As %Date;

/// 更新时间
Property RoleGUpTime As %Time;

// 安全组索引

Index IndexGroupID On GroupObj;

/// Creator：     chengpeng
/// CreatDate：   2016-08-05
/// Description:  更新角色安全组配置
/// Table：       DtPortal_Configure.RoleGroupItem
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.RoleGroupItem).Update("3^^4","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=-1
	Set:aSeparate="" aSeparate="^"
	
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	Set GropID=$p(aInput,aSeparate,3)
	
	set ID=ParRef_"||"_ChildSub
	
	set checkID=$o(^DtPortal.Configure.RoleGroupI("Item","IndexGroupID",GropID,ParRef,""))
	quit:checkID'="" 0
	
	If (ChildSub="") {
		Set obj=##class(DtPortal.Configure.RoleGroupItem).%New()
	} Else {
		Set obj=##class(DtPortal.Configure.RoleGroupItem).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DtPortal.Configure.RoleGroup).GetObjById(ParRef)
	Set obj.GroupObj  =##Class(User.SSGroup).%OpenId(GropID)
	Set obj.RoleGUpdate     = $p($h,",",1)
	Set obj.RoleGUpTime     = $p($h,",",2)
		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chengpeng
/// CreatDate：   2016-08-05
/// Description:  查询角色配置的安全组信息
/// Table：       DtPortal_Configure.RoleGroupItem
/// Input：       roleID :DtPortal.Configure.RoleGroup表ID
/// w ##Class(DtPortal.Configure.RoleGroupItem).qureyRoleGroup(,,5)
ClassMethod qureyRoleGroup(page = 1, rows = 10, roleID As %String) As %String
{
	 set start=(page-1)*rows+1
	 set end=page*rows
	 set count=0
	 w "{""rows"":["
	 
	 set RoleGroupID=""
	 for
	 {
		 set RoleGroupID=$o(^DtPortal.Configure.RoleGroupD(roleID,"Item",RoleGroupID))
		 quit:RoleGroupID=""
		 
		 Set RoleGroupObj=##class(DtPortal.Configure.RoleGroupItem).%OpenId(roleID_"||"_RoleGroupID)
		 continue:'$IsObject(RoleGroupObj)
		 
		 set count=count+1
		 continue:count<start
		 continue:count>end
		 set groupID=RoleGroupObj.GroupObj.%Id()
		 set groupDesc=RoleGroupObj.GroupObj.SSGRPDesc
	
		 w $case(count,start:"",:",")
		 w "{"
		 w """roleGroupID"":"_""""_roleID_"||"_RoleGroupID_""""_","
		 w """roleID"":"_""""_roleID_""""_","
		 w """RoleSubID"":"_""""_RoleGroupID_""""_","
		 w """groupID"":"_""""_groupID_""""_","
		 w """groupDesc"":"_""""_groupDesc_""""
		 w "}" 
		 
	 }
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：     chengpeng
/// CreatDate：   2016-08-05
/// Description:  查询角色配置的安全组信息
/// Table：       DtPortal_Configure.RoleGroupItem
/// Input：       roleID :DtPortal.Configure.RoleGroup表ID
/// w ##Class(DtPortal.Configure.RoleGroupItem).qureyRoleGroup1(3)
ClassMethod qureyRoleGroup1(roleID As %String) As %String
{
	 set return=""
	 set RoleGroupID=""
	 for
	 {
		 set RoleGroupID=$o(^DtPortal.Configure.RoleGroupD(roleID,"Item",RoleGroupID))
		 quit:RoleGroupID=""
		 
		 Set RoleGroupObj=##class(DtPortal.Configure.RoleGroupItem).%OpenId(roleID_"||"_RoleGroupID)
		 continue:'$IsObject(RoleGroupObj)
		 
		 set groupID=RoleGroupObj.GroupObj.%Id()
		 set:return'="" return=return_"^"_groupID
		 set:return="" return=groupID
		 
	 }
	
	 q return
}

/// Creator：     chengpeng
/// CreatDate：   2016-07-08
/// Description:  删除角色安全组配置
/// Table：       DtPortal_Configure.RoleGroup
/// Input：       DtPortal.Configure.RoleGroup
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.Configure.RoleGroupItem).DeleteById("5||1")
ClassMethod DeleteById(ID) As %String
{
	New (ID)
	Set return=0
	Set sc = ##class(DtPortal.Configure.RoleGroupItem).%DeleteId(ID)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="RoleGroupItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupObj</Value>
</Value>
<Value name="3">
<Value>RoleGUpdate</Value>
</Value>
<Value name="4">
<Value>RoleGUpTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Item")</DataLocation>
<DefaultData>RoleGroupItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Item")</IdLocation>
<IndexLocation>^DtPortal.Configure.RoleGroupI("Item")</IndexLocation>
<StreamLocation>^DtPortal.ConD36C.RoleGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
