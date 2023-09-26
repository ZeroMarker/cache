/// 名称: DHCHAI.DP.RBItmMast
/// 描述: 检查分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.RBItmMast Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检查分类代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检查分类名称
Property BTCName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 分类代码索引
Index IndexCode On BTCode As Exact;

/// 分类名称索引
Index IndexName On BTCName As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取检查分类
/// Table：       DHCHAI.DP.RBItmMast
/// Input：       ID:    DHCHAI.DP.RBItmMast.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.RBItmMast).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.RBItmMast
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.RBItmMast).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.RBItmMast).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取检查分类
/// Table：       DHCHAI.DP.RBItmMast
/// Input：       aCode:    项目代码
/// 			  aName:    项目名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.RBItmMast).GetObjByCodeName("","")
ClassMethod GetObjByCodeName(aCode As %String, aName As %String) As DHCHAI.DP.RBItmMast
{
	New (aCode,aName)
	Set return=""
	Quit:((aCode="")&&(aName=""))||((aCode'="")&&(aName'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.RBItmMastI("IndexCode",aCode,0))
	Set:aName'="" id = $o(^DHCHAI.DP.RBItmMastI("IndexName",aName,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检查分类
/// Table：       DHCHAI.DP.RBItmMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.RBItmMast).Update("^xxx^检查^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set Code   		= $p(InStr,aSeparete,2)
	Set CName   	= $p(InStr,aSeparete,3)
	Set IsActive   	= +$p(InStr,aSeparete,4)
	Quit:(Code="")||(CName="")||(IsActive="") return
	Set CName = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(CName) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.RBItmMastI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	//名称唯一性
	Set tID =$o(^DHCHAI.DP.RBItmMastI("IndexName",CName,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.RBItmMast).%New()
	}else{
		Set obj=##class(DHCHAI.DP.RBItmMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTCName		= CName
	Set obj.BTIsActive	= IsActive
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除检查分类
/// Table：       DHCHAI.DP.RBItmMast
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.RBItmMast")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.RBItmMast).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-28
/// Description:  导入检查分类对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.RBItmMast).ImportRBItmMast()
ClassMethod ImportRBItmMast(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set Code	= $p(aInputStr,aSeparete,1)
	Set CName	= $p(aInputStr,aSeparete,2)
	Quit:(Code="")||(CName="") return
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.RBItmMastI("IndexCode",Code,0)) 
	Set InputStr = tID_"^"_Code_"^"_CName_"^1"
	Set return = ..Update(InputStr)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTCName</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.RBItmMastD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.RBItmMastD</IdLocation>
<IndexLocation>^DHCHAI.DP.RBItmMastI</IndexLocation>
<StreamLocation>^DHCHAI.DP.RBItmMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
