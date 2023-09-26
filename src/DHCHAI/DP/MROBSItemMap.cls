/// 名称: DHCHAI.DP.MROBSItemMap
/// 描述: 护理项目对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MROBSItemMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 护理项目名称
Property BTItemDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准项目名称
Property BTMapItemDr As DHCHAI.DP.MROBSItem;

/// 标准备注
Property BTMapNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准项目名称索引
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码 + 护理项目名称 索引
Index IndexSCodeItemDesc On (BTSCode As Exact, BTItemDesc As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  根据项目名称取护理项目对照
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       aSCode: 子系统代码
/// 			  aItemDesc: 护理项目名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc("NIS01","体温")
ClassMethod GetObjByItemDesc(aSCode As %String, aItemDesc As %String) As DHCHAI.DP.MROBSItemMap
{
	New (aSCode,aItemDesc)
	Set return=""
	Quit:(aSCode="")||(aItemDesc="") return
	
	Set aItemDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aItemDesc)  //去掉特殊字符
	Set id = $o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",aSCode,aItemDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取护理项目对照
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       ID:    DHCHAI.DP.MROBSItemMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MROBSItemMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MROBSItemMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MROBSItemMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MROBSItemMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新护理项目对照
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MROBSItemMap).Update("1^NISCode2^NISName2^^^NIS01^1^64491^36501^系统自动")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set ItemDesc	= $p(InStr,aSeparete,2)
	Set MapItemDr	= $p(InStr,aSeparete,3)
	Set MapNote		= $p(InStr,aSeparete,4)
	Set SCode		= $p(InStr,aSeparete,5)
	Set IsActive	= +$p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(ItemDesc="")||(SCode="")||(IsActive="") return
	
	Set ItemDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ItemDesc)  //去掉特殊字符
	
	//子系统代码+护理分类名称 唯一性
	Set tID =$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",SCode,ItemDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem = ##class(DHCHAI.DP.MROBSItem).GetObjById(MapItemDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.MROBSItemMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MROBSItemMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTItemDesc	= ItemDesc
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTMapNote	= MapNote
	Set obj.BTSCode		= SCode	
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= ActUser

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
/// Description:  删除护理项目对照
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.MROBSItemMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-06
/// Description:  删除护理项目对照关系
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.MROBSItemMap).%OpenId(Id)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr     = ""
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

/// Creator：     mayanpeng
/// CreatDate：   2017-09-28
/// Description:  导入护理项目对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MROBSItemMap).ImportOBSItem("日总入量^NIS01^1")
ClassMethod ImportOBSItem(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ItemDesc	= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Set IsActive    = +$p(aInputStr,aSeparete,3)
	Quit:(ItemDesc="")||(SCode="") return
	
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set ID=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",SCode,ItemDesc,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.MROBSItemMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		//Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_ItemDesc
	Set InputStr=InputStr_"^"_MapItemDr
	Set InputStr=InputStr_"^"_MapNote
	Set InputStr=InputStr_"^"_SCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUser
	Set return=..Update(InputStr)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTItemDesc</Value>
</Value>
<Value name="3">
<Value>BTMapItemDr</Value>
</Value>
<Value name="4">
<Value>BTMapNote</Value>
</Value>
<Value name="5">
<Value>BTSCode</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUser</Value>
</Value>
<Value name="10">
<Value>BTItemCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MROBSItemMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MROBSItemMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.MROBSItemMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MROBSItemMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
