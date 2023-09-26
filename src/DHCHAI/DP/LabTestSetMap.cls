/// 名称: DHCHAI.DP.LabTestSetMap
/// 描述: 检验医嘱对照
/// 编写者：zhufei
/// 编写日期: 2017-05-09
Class DHCHAI.DP.LabTestSetMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验医嘱名称
Property BTTestSet As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医嘱项名称
Property BTOrdDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 标准医嘱名称
Property BTMapItemDr As DHCHAI.DP.LabTestSet;

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

/// 子系统代码 + 检验医嘱名称索引
Index IndexSCodeTestSet On (BTSCode As Exact, BTTestSet As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  根据ID取检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       ID:    DHCHAI.DP.LabTestSetMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestSetMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTestSetMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTestSetMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTestSetMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  根据代码取检验医嘱
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       aSCode: 子系统代码
/// 			  aTestSet: 检验医嘱名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestSetMap).GetTSCatByTestSet("LIS01","全血细胞分析(五分类)(静脉血)")
ClassMethod GetTSCatByTestSet(aSCode As %String, aTestSet As %String) As DHCHAI.DP.LabTestSetCat
{
	New (aSCode,aTestSet)
	Set return=""
	Quit:(aSCode="")||(aTestSet="") return
	
	Set id=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",aSCode,aTestSet,0))
	Quit:id="" return
	Set obj=..GetObjById(id)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTMapItemDr) return
	Quit:'$IsObject(obj.BTMapItemDr.BTCatDr) return
	Set return=obj.BTMapItemDr.BTCatDr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-23
/// Description:  根据检验医嘱分类
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       aSCode: 子系统代码
/// 			  aTestSet: 检验医嘱名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet("LIS01","全血细胞分析(五分类)(静脉血)")
ClassMethod GetObjByTestSet(aSCode As %String, aTestSet As %String) As DHCHAI.DP.LabTestSetMap
{
	New (aSCode,aTestSet)
	Set return=""
	Quit:(aSCode="")||(aTestSet="") return
	
	Set aTestSet=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aTestSet)  //去掉特殊字符
	Quit:aTestSet="" return
	Set id=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",aSCode,aTestSet,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-09
/// Description:  更新检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTestSetMap).Update("1^血气分析^白细胞^bxb^文本^1^T^标准备注^男正常值范围^女正常值范围^儿童正常值范围^新生儿正常值范围^H^LIS01^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set TestSet		= $p(InStr,aSeparete,2)
	Set OrdDesc	    = $p(InStr,aSeparete,3)
	Set MapItemDr	= $p(InStr,aSeparete,4)
	Set MapNote		= $p(InStr,aSeparete,5)
	Set SCode		= $p(InStr,aSeparete,6)
	Set IsActive	= +$p(InStr,aSeparete,7)
	Set ActDate		= $p(InStr,aSeparete,8)
	Set ActTime		= $p(InStr,aSeparete,9)
	Set ActUser		= $p(InStr,aSeparete,10)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(TestSet="")||(SCode="")||(IsActive="") return
	
	Set TestSet=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSet)  //去掉特殊字符
	Quit:TestSet="" return
	
	//子系统代码 + 检验医嘱名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,TestSet,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	Set objMapItem = ##class(DHCHAI.DP.LabTestSet).GetObjById(MapItemDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabTestSetMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabTestSetMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTestSet 		= TestSet
	Set obj.BTOrdDesc 		= OrdDesc
	Set obj.BTMapItemDr 	= objMapItem
	Set obj.BTMapNote 		= MapNote
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

/// Creator：     zhufei
/// CreatDate：   2017-01-17
/// Description:  删除检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabTestSetMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-04
/// Description:  删除检验医嘱对照关系
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.LabTestSetMap).%OpenId(Id)
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

/// Creator：     zhufei
/// CreatDate：   2017-10-10
/// Description:  导入检验医嘱对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTestSetMap).ImportTestSet("活化部分凝血活酶时间(APTT)^^LIS01")
ClassMethod ImportTestSet(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set TestSet  	= $p(aInputStr,aSeparete,1)
	Set OrdDesc     = $p(aInputStr,aSeparete,2)
	Set SCode		= $p(aInputStr,aSeparete,3)
	Quit:(TestSet="")||(SCode="") return
	
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set IsActive=1
	Set ID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,TestSet,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_TestSet
	Set InputStr=InputStr_"^"_OrdDesc
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
<Data name="LabTestSetMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTestSet</Value>
</Value>
<Value name="3">
<Value>BTOrdDesc</Value>
</Value>
<Value name="4">
<Value>BTMapItemDr</Value>
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
<DataLocation>^DHCHAI.DP.LabTestSetMapD</DataLocation>
<DefaultData>LabTestSetMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTestSetMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTestSetMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTestSetMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
