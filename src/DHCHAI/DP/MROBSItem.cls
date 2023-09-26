/// 名称: DHCHAI.DP.MROBSItem
/// 描述: 护理项目
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MROBSItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 护理项目代码
Property BTItemCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 护理项目名称
Property BTItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 护理项目分类（体温、大便次数）
Property BTCatDr As DHCHAI.DP.MROBSItemCat;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 护理项目代码索引
Index IndexItemCode On BTItemCode As Exact;

/// 护理项目名称索引
Index IndexItemDesc On BTItemDesc As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取护理项目
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       ID:    DHCHAI.DP.MROBSItem.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MROBSItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MROBSItem
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MROBSItem).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MROBSItem).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取护理项目
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       aCode:    项目代码
/// 			  aDesc:    项目名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MROBSItem).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.MROBSItem
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.MROBSItemI("IndexItemCode",aCode,0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.MROBSItemI("IndexItemDesc",aDesc,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新护理项目
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MROBSItem).Update("^代码^名称^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set ItemCode	= $p(InStr,aSeparete,2)
	Set ItemDesc	= $p(InStr,aSeparete,3)
	Set BTCatDr		= $p(InStr,aSeparete,4)
	Set IsActive	= $p(InStr,aSeparete,5)
	Quit:(ItemCode="")||(ItemDesc="") return
	Set ItemDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ItemDesc) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.MROBSItemI("IndexItemCode",ItemCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	//名称唯一性
	Set tID =$o(^DHCHAI.DP.MROBSItemI("IndexItemDesc",ItemDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objBTCat=##class(DHCHAI.DP.MROBSItemCat).GetObjById(BTCatDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.MROBSItem).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MROBSItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTItemCode	= ItemCode
	Set obj.BTItemDesc	= ItemDesc
	Set obj.BTCatDr		= objBTCat
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
/// Description:  删除护理项目
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.MROBSItem")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.DP.MROBSItem).%DeleteId(+Id)
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
<Data name="MROBSItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTItemCode</Value>
</Value>
<Value name="3">
<Value>BTItemDesc</Value>
</Value>
<Value name="4">
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MROBSItemD</DataLocation>
<DefaultData>MROBSItemDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MROBSItemD</IdLocation>
<IndexLocation>^DHCHAI.DP.MROBSItemI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MROBSItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
