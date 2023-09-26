/// 名称: DHCHAI.DP.MROBSItemCat
/// 描述: 护理项目分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MROBSItemCat Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码索引
Index IndexCode On BTCode As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取护理项目分类
/// Table：       DHCHAI.DP.MROBSItemCat
/// Input：       ID:    DHCHAI.DP.MROBSItemCat.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MROBSItemCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MROBSItemCat
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MROBSItemCat).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MROBSItemCat).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新护理项目分类
/// Table：       DHCHAI.DP.MROBSItemCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MROBSItemCat).Update("^SHS^四环素")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Desc		= $p(InStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//分类代码唯一性
	Set tID =$o(^DHCHAI.DP.MROBSItemCatI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.MROBSItemCat).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MROBSItemCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
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
/// Description:  删除护理项目分类
/// Table：       DHCHAI.DP.MROBSItemCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.MROBSItemCat")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.MROBSItemCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
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
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MROBSItemCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MROBSItemCatD</IdLocation>
<IndexLocation>^DHCHAI.DP.MROBSItemCatI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MROBSItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
