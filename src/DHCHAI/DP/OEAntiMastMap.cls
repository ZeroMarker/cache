/// 名称: DHCHAI.DP.OEAntiMastMap
/// 描述: 医嘱-抗菌药物对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEAntiMastMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 抗菌药物名称
Property BTAnitDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 药品通用名
Property BTGeneric As %String(MAXLEN = 500, TRUNCATE = 1);

/// 药品化学名
Property BTChemical As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准抗菌药物名称
Property BTMapItemDr As DHCHAI.DP.OEAntiMast;

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

/// 标准抗菌药物名称
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码 + 抗菌药物名称 索引
Index IndexSCodeAnitDesc On (BTSCode As Exact, BTAnitDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗菌药物分类对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       ID:    DHCHAI.DP.OEAntiMastMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiMastMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEAntiMastMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEAntiMastMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEAntiMastMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  根据抗菌药物名称取抗菌药物分类对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       aSCode: DHCHAI.DP.OEAntiMastMap.BTSCode
/// 			  aAntiDesc: DHCHAI.DP.OEAntiMastMap.BTAnitDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(1)
ClassMethod GetObjByAntiDesc(aSCode As %String, aAntiDesc As %String) As DHCHAI.DP.OEAntiMastMap
{
	New (aSCode,aAntiDesc)
	Set return=""
	Quit:(aSCode="")||(aAntiDesc="") return
	
	Set aAntiDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aAntiDesc)  //去掉特殊字符
	Set id = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",aSCode,aAntiDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗菌药物分类对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEAntiMastMap).Update("^抗菌药物名称^1^备注^RB01^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set AnitDesc	= $p(InStr,aSeparete,2)
	Set PHCGeneric	= $p(InStr,aSeparete,3)		//药品通用名 add by zf 20171128
	Set PHChemical	= $p(InStr,aSeparete,4)		//药品化学名 add by zf 20171128
	Set MapItemDr	= $p(InStr,aSeparete,5)
	Set MapNote		= $p(InStr,aSeparete,6)
	Set SCode		= $p(InStr,aSeparete,7)
	Set IsActive	= +$p(InStr,aSeparete,8)
	Set ActDate		= $p(InStr,aSeparete,9)
	Set ActTime		= $p(InStr,aSeparete,10)
	Set ActUser		= $p(InStr,aSeparete,11)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(AnitDesc="")||(SCode="")||(IsActive="") return
	
	Set AnitDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AnitDesc)  //去掉特殊字符
	
	//子系统代码+抗菌药物名称 唯一性
	Set tID =$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,AnitDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem = ##class(DHCHAI.DP.OEAntiMast).GetObjById(MapItemDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEAntiMastMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEAntiMastMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTAnitDesc	= AnitDesc
	Set obj.BTGeneric   = PHCGeneric  //药品通用名 add by zf 20171128
	Set obj.BTChemical  = PHChemical  //药品化学名 add by zf 20171128
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTMapNote	= MapNote
	Set obj.BTSCode		= SCode	
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= objActUser

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
/// Description:  删除抗菌药物分类对照
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OEAntiMastMap).%DeleteId(+Id)
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
/// Description:  删除抗菌药物对照关系
/// Table：       DHCHAI.DP.OEAntiMastMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.OEAntiMastMap).%OpenId(Id)
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
/// Description:  导入抗菌用药对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEAntiMastMap).ImportOEAntiMast("多西环素片(台城)[0.1G 100片/瓶]^HIS01^1")
ClassMethod ImportOEAntiMast(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set AnitDesc	= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Set IsActive    = +$p(aInputStr,aSeparete,3)
	Quit:(AnitDesc="")||(SCode="") return
	
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set ID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,AnitDesc,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.OEAntiMastMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		//Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_AnitDesc
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
<Value>BTAnitDesc</Value>
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
<Value>BTSCode</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUser</Value>
</Value>
<Value name="11">
<Value>BTGeneric</Value>
</Value>
<Value name="12">
<Value>BTChemical</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OEAntiMastMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEAntiMastMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEAntiMastMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEAntiMastMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
