/// 名称: DHCHAI.DP.LabTCMap
/// 描述: 常规检验项目对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabTCMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验项目
Property BTTestCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验项目名称
Property BTTestDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 结果类型
Property BTRstFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常标志（L,H,N集合）
Property BTAbFlagS As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// 对照医嘱名称
Property BTMapItemDr As DHCHAI.DP.LabTestSet;

/// 子系统代码 + 检验项目名称索引
Index IndexSCodeTestCode On (BTSCode As Exact, BTTestCode As Exact);

/// 对照医嘱名称 索引
Index IndexMapCodeDr On (BTTestCode As Exact, BTMapItemDr);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取常规检验项目对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       ID:    DHCHAI.DP.LabTCMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTCMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTCMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTCMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-12
/// Description:  根据检验项目名称取检验结果
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       aSCode: 子系统代码
/// 				  aTCCode: 检验项目名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMap).GetObjByTestCode(1)
ClassMethod GetObjByTestCode(aSCode As %String, aTestCode As %String) As DHCHAI.DP.LabTCMap
{
	New (aSCode,aTestCode)
	Set return=""
	Quit:(aSCode="")||(aTestCode="") return
	
	Set aTestCode=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aTestCode)  //去掉特殊字符
	Set id = $o(^DHCHAI.DP.LabTCMapI("IndexSCodeTestCode",aSCode,aTestCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新常规检验项目对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTCMap).Update("^便白细胞^便常规^结果类型^^M^标准备注^男正常值范围^女正常值范围^儿童正常值范围^新生儿正常值范围^L^LIS01^1^^^处置人")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set TestCode	= $p(InStr,aSeparete,2)
	Set TestDesc    = $p(InStr,aSeparete,3)
	Set RstFormat	= $p(InStr,aSeparete,4)
	Set AbFlagS		= $p(InStr,aSeparete,5)
	Set SCode		= $p(InStr,aSeparete,6)
	Set IsActive	= +$p(InStr,aSeparete,7)
	Set ActDate		= $p(InStr,aSeparete,8)
	Set ActTime		= $p(InStr,aSeparete,9)
	Set ActUser		= $p(InStr,aSeparete,10)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(TestCode="")||(SCode="")||(IsActive="") return
	
	Set TestCode=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestCode)  //去掉特殊字符
	
	//子系统代码 + 检验项目名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabTCMapI("IndexSCodeTestCode",SCode,TestCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabTCMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabTCMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTestCode 		= TestCode
	Set obj.BTTestDesc   	= TestDesc
	Set obj.BTRstFormat 	= RstFormat
	Set obj.BTAbFlagS       = AbFlagS
	Set obj.BTSCode 		= SCode
	Set obj.BTIsActive 		= IsActive
	Set obj.BTActDate 		= ActDate
	Set obj.BTActTime 		= ActTime 
	Set obj.BTActUser 		= ActUser 
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
/// Description:  删除常规检验项目对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabTCMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2021-03-30
/// Description:  更新检验项目-检验医嘱对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTCMap).UpdateMap("80","8")
ClassMethod UpdateMap(aID As %String, aSetID As %String) As %String
{
	New (aID,aSetID)
	Set return=0
	Quit:(aID="")||(aSetID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.LabTestSet).GetObjById(aSetID)
	Quit:'$IsObject(objMapItem) return	
	Set obj=##class(DHCHAI.DP.LabTCMap).%OpenId(aID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr	= objMapItem
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

/// Creator：     pylian
/// CreatDate：   2017-08-06
/// Description:  删除常规检验项目对照关系
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.LabTCMap).%OpenId(Id)
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

Storage Default
{
<Data name="LabTCMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTestCode</Value>
</Value>
<Value name="3">
<Value>BTTestDesc</Value>
</Value>
<Value name="4">
<Value>BTRstFormat</Value>
</Value>
<Value name="5">
<Value>BTAbFlagS</Value>
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
<Value>BTMapItemDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabTCMapD</DataLocation>
<DefaultData>LabTCMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTCMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTCMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTCMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
