/// 名称: DHCHAI.DP.LabBactMap
/// 描述: 细菌字典对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabBactMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 细菌名称
Property BTBacteria As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准细菌名称
Property BTMapItemDr As DHCHAI.DP.LabBacteria;

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

/// 标准细菌名称索引
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码+细菌名称 索引
Index IndexSCodeBacteria On (BTSCode As Exact, BTBacteria As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       ID:    DHCHAI.DP.LabBactMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabBactMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabBactMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabBactMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabBactMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据子系统代码+细菌名称取细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       aSCode ： 子系统代码
/// 			  aBacteria：细菌名称
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria("LIS01","金黄色葡萄球菌")
ClassMethod GetObjByBacteria(aSCode As %String, aBacteria As %String) As DHCHAI.DP.LabBactMap
{
	New (aSCode,aBacteria)
	Set return = ""
	Quit:(aSCode="")||(aBacteria="") return
	
	Set aBacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aBacteria)  //去掉特殊字符
	Quit:aBacteria="" return
	Set id=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",aSCode,aBacteria,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  根据子系统代码+细菌名称取细菌标准字典
/// Table：       DHCHAI.DP.LabBactMap、DHCHAI.DP.LabBacteria
/// Input：       aSCode ： 子系统代码
/// 			  aBacteria：细菌名称
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabBactMap).GetStanBactByDesc("LIS01","金黄色葡萄球菌")
ClassMethod GetStanBactByDesc(aSCode As %String, aBacteria As %String) As DHCHAI.DP.LabBacteria
{
	New (aSCode,aBacteria)
	Set return = ""
	Quit:(aSCode="")||(aBacteria="") return
	
	Set obj=..GetObjByBacteria(aSCode,aBacteria)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTMapItemDr) return
	Set return=obj.BTMapItemDr
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactMap).Update("^金黄色葡萄球菌^^^LIS01^1^^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set Bacteria	= $p(InStr,aSeparete,2)
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
	
	Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
	Quit:(Bacteria="")||(SCode="")||(IsActive="")||(ActDate="")||(ActTime="") return
		
	//子系统代码+细菌名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem = ##class(DHCHAI.DP.LabBacteria).GetObjById(MapItemDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabBactMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBactMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTBacteria	= Bacteria
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

/// Creator：     chenjb
/// CreatDate：   2023-04-25
/// Description:  更新细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactMap).UpdateActive("^金黄色葡萄球菌^^^LIS01^1^^^")
ClassMethod UpdateActive(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set MapNote	= $p(InStr,aSeparete,2)
	Set IsActive	= $p(InStr,aSeparete,3)
	Set ActDate=+$h
	Set ActTime=$p($h,",",2)
	
	Quit:(ID="")||(IsActive="")||(ActDate="")||(ActTime="") return
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabBactMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabBactMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTMapNote	= MapNote
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
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
/// Description:  删除细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabBactMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-02
/// Description:  删除细菌对照关系
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.LabBactMap).%OpenId(Id)
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
/// Description:  导入细菌对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabBactMap).ImportLabBacteria("A群β溶血链球菌^LIS01")
ClassMethod ImportLabBacteria(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set Bacteria	= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Quit:(Bacteria="")||(SCode="") return
	
	//子系统代码+细菌名称 唯一性
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set IsActive=1
	Set ID=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.LabBactMap).GetObjById(ID)
		Quit:'$IsObject(obj)
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_Bacteria
	Set InputStr=InputStr_"^"_MapItemDr
	Set InputStr=InputStr_"^"_MapNote
	Set InputStr=InputStr_"^"_SCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUser
	Set return = ..Update(InputStr,"^")
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTBacteria</Value>
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
</Data>
<DataLocation>^DHCHAI.DP.LabBactMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabBactMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabBactMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabBactMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
