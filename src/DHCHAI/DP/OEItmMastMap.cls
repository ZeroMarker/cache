/// 名称: DHCHAI.DP.OEItmMastMap
/// 描述: 医嘱项对照记录
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEItmMastMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医嘱名称
Property BTOrdDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 医嘱分类（大类.子类）
Property BTOrdCatDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准名称
Property BTMapItemDr As DHCHAI.DP.OEItmMast;

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
Property BTActUser As DHCHAI.BT.SysUser;

/// 插管类别[用于'三管感染防控督查表']-ADD 2022-12
Property BTIExADr As DHCHAI.BT.Dictionary;

/// 标准名称索引
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码 + 医嘱名称 索引
Index IndexSCodeOrdDesc On (BTSCode As Exact, BTOrdDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取医嘱项对照记录
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       ID:    DHCHAI.DP.OEItmMastMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmMastMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEItmMastMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEItmMastMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEItmMastMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  根据医嘱名称取医嘱项对照记录
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       aSCode: DHCHAI.DP.OEItmMastMap.BTSCode
/// 			  aOrdDesc: DHCHAI.DP.OEItmMastMap.BTOrdDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(1)
ClassMethod GetObjByOrdDesc(aSCode As %String, aOrdDesc As %String) As DHCHAI.DP.OEItmMastMap
{
	New (aSCode,aOrdDesc)
	Set return=""
	Quit:(aSCode="")||(aOrdDesc="") return
	
	Set aOrdDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aOrdDesc)  //去掉特殊字符
	Set id = $o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",aSCode,aOrdDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新医嘱项对照记录
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEItmMastMap).Update("^医嘱名称^限制级^1^备注^OE01^1^2017-01-01^19:00:00^处置人")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set OrdDesc		= $p(InStr,aSeparete,2)
	Set OrdCatDesc  = $p(InStr,aSeparete,3)
	Set MapItemDr	= $p(InStr,aSeparete,4)
	Set MapNote		= $p(InStr,aSeparete,5)
	Set SCode		= $p(InStr,aSeparete,6)
	Set IsActive	= $p(InStr,aSeparete,7)
	Set ActDate		= $p(InStr,aSeparete,8)
	Set ActTime		= $p(InStr,aSeparete,9)
	Set ActUser		= $p(InStr,aSeparete,10)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(OrdDesc="")||(SCode="")||(IsActive="") return
	
	Set OrdDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OrdDesc)  //去掉特殊字符
	
	//子系统代码+抗生素名称 唯一性
	Set tID =$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",SCode,OrdDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem=##class(DHCHAI.DP.OEItmMast).GetObjById(MapItemDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	//ADD(2022-12) 新增'三管感染防控督查表'自动匹配规则
	Set IATypeDr	= $p(InStr,aSeparete,11)
	Set objIExA=##class(DHCHAI.BT.Dictionary).GetObjById(IATypeDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEItmMastMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEItmMastMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTOrdDesc	= OrdDesc
	Set obj.BTOrdCatDesc= OrdCatDesc
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTMapNote	= MapNote
	Set obj.BTSCode		= SCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= objActUser
	Set obj.BTIExADr	= objIExA

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
/// Description:  删除医嘱项对照记录
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OEItmMastMap).%DeleteId(+Id)
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
/// Description:  删除医嘱项对照关系
/// Table：       DHCHAI.DP.OEItmMastMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.OEItmMastMap).%OpenId(Id)
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
/// Description:  导入医嘱项对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEItmMastMap).ImportOEItmMast("二级护理(停止)^HIS01^1^护理.护理常规")
ClassMethod ImportOEItmMast(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set OrdDesc		= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Set IsActive	= +$p(aInputStr,aSeparete,3)
	Set OrdCatDesc  = $p(aInputStr,aSeparete,4)
	Quit:(OrdDesc="")||(SCode="") return
	
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set ID=$o(^DHCHAI.DP.OEItmMastMapI("IndexSCodeOrdDesc",SCode,OrdDesc,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		//Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_OrdDesc
	Set InputStr=InputStr_"^"_OrdCatDesc
	Set InputStr=InputStr_"^"_MapItemDr
	Set InputStr=InputStr_"^"_MapNote
	Set InputStr=InputStr_"^"_SCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUser
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
<Value>BTOrdDesc</Value>
</Value>
<Value name="3">
<Value>BTMapItemDr</Value>
</Value>
<Value name="4">
<Value>BTMapCatDr</Value>
</Value>
<Value name="5">
<Value>BTMapNote</Value>
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
<Value>BTSCode</Value>
</Value>
<Value name="11">
<Value>BTOrdCatDesc</Value>
</Value>
<Value name="12">
<Value>BTIExADr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OEItmMastMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEItmMastMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEItmMastMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEItmMastMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
