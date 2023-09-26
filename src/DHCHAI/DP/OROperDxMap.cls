/// 名称: DHCHAI.DP.OROperDxMap
/// 描述: 手术字典对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OROperDxMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术名称
Property BTOperDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准手术名称
Property BTMapOperDr As DHCHAI.DP.OROperDx;

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

/// 标准手术名称索引
Index IndexMapOperDr On BTMapOperDr;

/// 子系统代码 + 手术名称 索引
Index IndexSCodeOperDesc On (BTSCode As Exact, BTOperDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取手术名称对照
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       ID:    DHCHAI.DP.OROperDxMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperDxMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OROperDxMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OROperDxMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OROperDxMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  根据手术名称取手术名称对照
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       aSCode: 子系统代码
/// 			  aOperDesc: 手术名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OROperDxMap).GetObjByOperDesc(1)
ClassMethod GetObjByOperDesc(aSCode As %String, aOperDesc As %String) As DHCHAI.DP.OROperDxMap
{
	New (aSCode,aOperDesc)
	Set return=""
	Quit:(aSCode="")||(aOperDesc="") return
	Set aOperDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aOperDesc)  //去掉特殊字符
	Quit:aOperDesc="" return
	
	Set id = $o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",aSCode,aOperDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新手术名称对照
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OROperDxMap).Update("^头部血管治疗性超声^1^^OPS01^1^^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set OperDesc	= $p(InStr,aSeparete,2)
	Set MapOperDr	= $p(InStr,aSeparete,3)
	Set MapNote		= $p(InStr,aSeparete,4)
	Set SCode		= $p(InStr,aSeparete,5)
	Set IsActive	= +$p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate = +$h
	Set:ActTime="" ActTime = +$p($h,",",2)
	Quit:(OperDesc="")||(SCode="")||(IsActive="") return
	
	Set OperDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OperDesc)  //去掉特殊字符
	
	//子系统代码+手术名称 唯一性
	Set tID =$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",SCode,OperDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100

	Set objMapOper = ##class(DHCHAI.DP.OROperDx).GetObjById(MapOperDr)	
	if ID="" {
		Set obj=##class(DHCHAI.DP.OROperDxMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OROperDxMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTOperDesc		= OperDesc
	Set obj.BTMapOperDr     = objMapOper
	Set obj.BTMapNote		= MapNote
	Set obj.BTSCode			= SCode
	Set obj.BTIsActive		= IsActive
	Set obj.BTActDate		= ActDate
	Set obj.BTActTime		= ActTime
	Set obj.BTActUser		= ActUser
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
/// Description:  删除手术名称对照
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.OROperDxMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-07-28
/// Description:  删除手术名称对照关系
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.OROperDxMap).%OpenId(Id)
	Quit:'$IsObject(obj) return
	Set obj.BTMapOperDr     = ""
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTOperDesc</Value>
</Value>
<Value name="3">
<Value>BTMapOperDr</Value>
</Value>
<Value name="4">
<Value>BTMapOperIncDr</Value>
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
<DataLocation>^DHCHAI.DP.OROperDxMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OROperDxMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.OROperDxMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OROperDxMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
