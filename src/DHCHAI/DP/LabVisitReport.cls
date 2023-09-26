/// 名称: DHCHAI.DP.LabVisitReport
/// 描述: 检验报告
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabVisitReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验标本
Property LabVisitNumberDr As DHCHAI.DP.LabVisitNumber [ Required ];

/// 检验报告ID
Property LabReportID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 报告序号
Property LabRepOrder As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检验结果（医嘱表）
Property LabTestSetRow As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态(1登记，2初审，3审核，4复查，5取消审核，6作废，A审核)
Property LabStatus As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 录入日期
Property LabRegDate As %Date;

/// 录入时间
Property LabRegTime As %Time;

/// 录入人（ID|Code|Desc）
Property LabRegUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核日期
Property LabAuthDate As %Date;

/// 审核时间
Property LabAuthTime As %Time;

/// 审核人（ID|Code|Desc）
Property LabAuthUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 指向检验医嘱
Property LabTestSetDr As DHCHAI.DP.LabVisitTestSet;

/// 子系统代码
Property LabSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property LabXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property LabIsActive As %Boolean [ Required ];

/// 更新日期
Property LabUpdateDate As %Date [ Required ];

/// 更新时间
Property LabUpdateTime As %Time [ Required ];

/// 子系统代码+记录索引码索引
Index IndexSCodeXCode On (LabSCode As Exact, LabXCode As Exact);

/// 就诊+检验报告索引
Index IndexVisitTestSetDrOrder On (LabVisitNumberDr, LabTestSetDr, LabRepOrder As Exact);

/// 检验报告索引
Index IndexLabReportID On LabReportID As Exact;

/// 检验号/检验报告索引
Index IndexLabTestSetRow On LabTestSetRow As Exact;

/// 审核日期时间索引
Index IndexAuthDateTime On (LabAuthDate, LabAuthTime);

/// 审核日期时间索引
Index IndexVisitAuthDateTime On (LabVisitNumberDr, LabAuthDate, LabAuthTime);

/// 更新日期 索引
Index IndexVisitUpdateDate On (LabVisitNumberDr, LabUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废检验报告
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       id:    DHCHAI.DP.LabVisitReport.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitReport).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.LabVisitReport).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.LabIsActive   = 0
	Set obj.LabUpdateDate = +$h
	Set obj.LabUpdateTime = $p($h,",",2)
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
/// Description:  根据ID取检验报告
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       ID:    DHCHAI.DP.LabVisitReport.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitReport
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitReport).%ExistsId(+id) return
	Set obj=##Class(DHCHAI.DP.LabVisitReport).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-12
/// Description:  根据ID取最新检验报告(主要是处理细菌培养分多次出报告情况)
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       ID:    DHCHAI.DP.LabVisitReport.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitReport).GetReportByID(1)
ClassMethod GetReportByID(id As %String) As DHCHAI.DP.LabVisitReport
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=..GetObjById(id)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.LabVisitNumberDr) return
	Set return=obj
	
	Set VisitNumberDr=obj.LabVisitNumberDr.%Id()
	Quit:'$IsObject(obj.LabTestSetDr) return
	Set TestSetDr=obj.LabTestSetDr.%Id()
	Set Order=obj.LabRepOrder
	Set tOrder=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberDr,TestSetDr,""),-1)
	Quit:tOrder="" return
	Quit:tOrder=Order return //Order序号一致表示同一条记录
	
	//如果不一致，取最新报告内容
	Set VisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberDr,TestSetDr,tOrder,0))
	Quit:VisitReportDr="" return
	Set return=..GetObjById(VisitReportDr)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据索引码取检验报告
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       aSCode:DHCHAI.DP.LabVisitReport.LabSCode
/// 				  aXCode:DHCHAI.DP.LabVisitReport.aXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitReport).GetObjByXCode("LIS02","9225||1")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.LabVisitReport
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = $o(^DHCHAI.DP.LabVisitReportI("IndexSCodeXCode",aSCode,aXCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检验报告
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitReport).Update("^1^检验报告Id^检验报告序号^检验条码^检验号^报告状态^检验医嘱名称^检验医嘱代码^标本^1^2017-01-01^18:00:00^采集者^2017-01-01^18:00:00^接收者^2017-01-01^18:00:00^录入人^2017-01-01^18:00:00^审核人^子系统代码^记录索引码^2017-01-01^18:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			    = $p(InStr,aSeparete,1)
	Set VisitNumberDr	= $p(InStr,aSeparete,2)
	Set ReportID	    = $p(InStr,aSeparete,3)
	Set RepOrder	    = $p(InStr,aSeparete,4) 
	Set TestSetRow	    = $p(InStr,aSeparete,5)
	Set Status		    = $p(InStr,aSeparete,6)
	Set RegDate		    = $p(InStr,aSeparete,7)
	Set RegTime		    = $p(InStr,aSeparete,8)
	Set RegUser		    = $p(InStr,aSeparete,9)
	Set AuthDate	    = $p(InStr,aSeparete,10)
	Set AuthTime	    = $p(InStr,aSeparete,11)
	Set AuthUser	    = $p(InStr,aSeparete,12)
	Set VisitTestSetDr  = $p(InStr,aSeparete,13)
	Set SCode		    = $p(InStr,aSeparete,14)
	Set XCode		    = $p(InStr,aSeparete,15)
	Set IsActive        = +$p(InStr,aSeparete,16)
	Set UpdateDate	    = $p(InStr,aSeparete,17)
	Set UpdateTime      = $p(InStr,aSeparete,18)
	Set:RegDate["-" RegDate = $zdh(RegDate,3)
	Set:RegTime[":" RegTime = $zth(RegTime,1)
	Set:AuthDate["-" AuthDate = $zdh(AuthDate,3)
	Set:AuthTime[":" AuthTime = $zth(AuthTime,1)
	Quit:(VisitNumberDr="")||(ReportID="")||(Status="") return
	Quit:(SCode="")||(XCode="") return
	
	Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(VisitNumberDr)
	Quit:'$IsObject(objVisitNumber) return
	
	Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjById(VisitTestSetDr)
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.LabVisitReportI("IndexSCodeXCode",SCode,XCode,"")) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitReport).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabVisitNumberDr= objVisitNumber
	Set obj.LabReportID		= ReportID
	Set obj.LabRepOrder		= RepOrder
	Set obj.LabTestSetRow	= TestSetRow
	Set obj.LabStatus		= Status
	Set obj.LabRegDate		= RegDate
	Set obj.LabRegTime		= RegTime
	Set obj.LabRegUser		= RegUser
	Set obj.LabAuthDate		= AuthDate
	Set obj.LabAuthTime		= AuthTime	
	Set obj.LabAuthUser		= AuthUser
	Set obj.LabTestSetDr    = objVisitTestSet
	Set obj.LabSCode		= SCode
	Set obj.LabXCode		= XCode
	Set obj.LabIsActive     = IsActive
	Set obj.LabUpdateDate	= +$h
	Set obj.LabUpdateTime	= $p($h,",",2)
	
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
/// Description:  删除检验报告
/// Table：       DHCHAI.DP.LabVisitReport
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitReport).%DeleteId(+Id)
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
<Data name="LabVisitReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabVisitNumberDr</Value>
</Value>
<Value name="3">
<Value>LabReportID</Value>
</Value>
<Value name="4">
<Value>LabRepOrder</Value>
</Value>
<Value name="5">
<Value>LabTestSetRow</Value>
</Value>
<Value name="6">
<Value>LabStatus</Value>
</Value>
<Value name="7">
<Value>LabRegDate</Value>
</Value>
<Value name="8">
<Value>LabRegTime</Value>
</Value>
<Value name="9">
<Value>LabRegUser</Value>
</Value>
<Value name="10">
<Value>LabAuthDate</Value>
</Value>
<Value name="11">
<Value>LabAuthTime</Value>
</Value>
<Value name="12">
<Value>LabAuthUser</Value>
</Value>
<Value name="13">
<Value>LabTestSetDr</Value>
</Value>
<Value name="14">
<Value>LabSCode</Value>
</Value>
<Value name="15">
<Value>LabXCode</Value>
</Value>
<Value name="16">
<Value>LabUpdateDate</Value>
</Value>
<Value name="17">
<Value>LabUpdateTime</Value>
</Value>
<Value name="18">
<Value>LabIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitReportD</DataLocation>
<DefaultData>LabVisitReportDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitReportD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitReportI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
