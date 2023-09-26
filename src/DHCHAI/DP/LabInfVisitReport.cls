/// 名称: DHCHAI.DP.LabInfVisitReport
/// 描述: 院感检验报告
/// 编写者：zhufei
/// 编写日期: 2020-10-28
Class DHCHAI.DP.LabInfVisitReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验标本
Property LabVisitNumberDr As DHCHAI.DP.LabInfVisitNumber [ Required ];

/// 检验报告ID
Property LabReportID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 报告序号
Property LabRepOrder As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 报告状态(1登记，2初审，3审核，4复查，5取消审核，6作废，A审核)
Property LabStatus As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// 审核日期时间索引
Index IndexAuthDateTime On (LabAuthDate, LabAuthTime);

/// 审核日期时间索引
Index IndexVisitAuthDateTime On (LabVisitNumberDr, LabAuthDate, LabAuthTime);

/// 检验标本 索引
Index IndexVisit On LabVisitNumberDr;

/// 更新日期 索引
Index IndexVisitUpdateDate On (LabVisitNumberDr, LabUpdateDate);

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取院感检验报告
/// Table：       DHCHAI.DP.LabInfVisitReport
/// Input：       aId : DHCHAI.DP.LabInfVisitReport.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfVisitReport).GetObjById(62)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.LabInfVisitReport
{
	New (aId)
	Quit:'##class(DHCHAI.DP.LabInfVisitReport).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.LabInfVisitReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2021-09-03
/// Description:  根据索引码取检验报告
/// Table：       DHCHAI.DP.LabInfVisitReport
/// Input：       aSCode:DHCHAI.DP.LabInfVisitReport.LabSCode
/// 			  aXCode:DHCHAI.DP.LabInfVisitReport.aXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabInfVisitReport).GetObjByXCode("LIS02","9225||1")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.LabInfVisitReport
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = $o(^DHCHAI.DP.LabInfVisitReportI("IndexSCodeXCode",aSCode,aXCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  更新院感检验报告
/// Table：       DHCHAI.DP.LabInfVisitReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitReport).Update("^6^1001^1^A^2021-09-06^2343^|23|Med^2021-09-06^2343^|23|Med^1^LIS01^12212^1^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			   = $p(aInputStr,aSeparete,1)
	Set VisitNumberDr  = $p(aInputStr,aSeparete,2)
	Set LabReportID    = $p(aInputStr,aSeparete,3)
	Set LabRepOrder    = $p(aInputStr,aSeparete,4)
	Set LabStatus 	   = $p(aInputStr,aSeparete,5)
	Set LabRegDate	   = $p(aInputStr,aSeparete,6)
	Set LabRegTime	   = $p(aInputStr,aSeparete,7)
	Set LabRegUser	   = $p(aInputStr,aSeparete,8)
	Set LabAuthDate    = $p(aInputStr,aSeparete,9)
	Set LabAuthTime    = $p(aInputStr,aSeparete,10)
	Set LabAuthUser    = $p(aInputStr,aSeparete,11)
	Set LabTestSetDr   = $p(aInputStr,aSeparete,12)
	Set LabSCode	   = $p(aInputStr,aSeparete,13)
	Set LabXCode	   = $p(aInputStr,aSeparete,14)
	Set LabIsActive	   = $p(aInputStr,aSeparete,15)
	Set UpdateDate	   = $p(aInputStr,aSeparete,16)
	Set UpdateTime     = $p(aInputStr,aSeparete,17)
									   
	Quit:(VisitNumberDr="")||(LabReportID="")||(LabXCode="") return
	
	Set:LabRegDate'="" LabRegDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabRegDate)
	Set:LabRegTime[":" LabRegTime = $zth(LabRegTime,1)
	Set:LabRegDate="" LabRegDate=+$h
	Set:LabRegTime="" LabRegTime=$p($h,",",2)
	
	Set:LabAuthDate'="" LabAuthDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabAuthDate)
	Set:LabAuthTime[":" LabAuthTime = $zth(LabAuthTime,1)
	Set:LabAuthDate="" LabAuthDate=+$h
	Set:LabAuthTime="" LabAuthTime=$p($h,",",2)
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set objVisitNum = ##class(DHCHAI.DP.LabInfVisitNumber).GetObjById(VisitNumberDr)
	Set objTestSet  = ##class(DHCHAI.DP.LabInfTestSet).GetObjById(LabTestSetDr)
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.LabInfVisitReportI("IndexSCodeXCode",LabSCode,LabXCode,"")) 
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabInfVisitReport).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabInfVisitReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabVisitNumberDr = objVisitNum
	Set obj.LabReportID      = LabReportID
	Set obj.LabRepOrder      = LabRepOrder
	Set obj.LabStatus	     = LabStatus
	Set obj.LabRegDate	     = LabRegDate
	Set obj.LabRegTime	     = LabRegTime
	Set obj.LabRegUser	     = LabRegUser
	Set obj.LabAuthDate	     = LabAuthDate
	Set obj.LabAuthTime	     = LabAuthTime
	Set obj.LabAuthUser	     = LabAuthUser
	Set obj.LabTestSetDr	 = objTestSet
	Set obj.LabSCode		 = LabSCode
	Set obj.LabXCode 	     = LabXCode						
	Set obj.LabIsActive      = LabIsActive
	Set obj.LabUpdateDate    = UpdateDate
	Set obj.LabUpdateTime    = UpdateTime
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  删除院感检验报告
/// Table：       DHCHAI.DP.LabInfVisitReport
/// Input：       aId : DHCHAI.DP.LabInfVisitReport.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitReport).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.LabInfVisitReport).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="LabInfVisitReportDefaultData">
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
<Value>LabStatus</Value>
</Value>
<Value name="6">
<Value>LabRegDate</Value>
</Value>
<Value name="7">
<Value>LabRegTime</Value>
</Value>
<Value name="8">
<Value>LabRegUser</Value>
</Value>
<Value name="9">
<Value>LabAuthDate</Value>
</Value>
<Value name="10">
<Value>LabAuthTime</Value>
</Value>
<Value name="11">
<Value>LabAuthUser</Value>
</Value>
<Value name="12">
<Value>LabTestSetDr</Value>
</Value>
<Value name="13">
<Value>LabSCode</Value>
</Value>
<Value name="14">
<Value>LabXCode</Value>
</Value>
<Value name="15">
<Value>LabIsActive</Value>
</Value>
<Value name="16">
<Value>LabUpdateDate</Value>
</Value>
<Value name="17">
<Value>LabUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabInfVisitReportD</DataLocation>
<DefaultData>LabInfVisitReportDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabInfVisitReportD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabInfVisitReportI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabInfVisitReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
