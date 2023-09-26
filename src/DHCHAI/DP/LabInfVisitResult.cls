/// 名称: DHCHAI.DP.LabInfVisitResult
/// 描述: 院感检验结果
/// 编写者：zhufei
/// 编写日期: 2020-10-28
Class DHCHAI.DP.LabInfVisitResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验报告
Property LabReportDr As DHCHAI.DP.LabInfVisitReport [ Required ];

/// 检验项目名称
Property LabTestDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检验项目代码
Property LabTestCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 结果类型（数字:N、文本:T、列表:S、血型ABO:A、RH血型:R、细菌:M）
Property LabRstFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检测结果
Property LabResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定性结果
Property LabTextRes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果说明(备注)
Property LabResNoes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常提示
Property LabAbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property LabUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 参考范围
Property LabRefRanges As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验报告索引
Index IndexLabReportDr On LabReportDr;

/// 检验项目代码索引
Index IndexLabTCCode2 On LabTestCode;

/// 检验结果类型索引
Index IndexLabRstFormat On (LabReportDr, LabRstFormat As Exact);

/// 检验项目代码索引
Index IndexLabTCCode On (LabReportDr, LabTestCode As Exact);

/// 检验项目名称索引
Index IndexLabTestDesc On (LabReportDr, LabTestDesc As Exact);

/// 结果类型+结果索引
Index IndexRstFormatResult On (LabRstFormat, LabResult);

/// 检验项目名称索引
Index IndexTestDesc On LabTestDesc;

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取院感检验结果
/// Table：       DHCHAI.DP.LabInfVisitResult
/// Input：       aId : DHCHAI.DP.LabInfVisitResult.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfVisitResult).GetObjById(62)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.LabInfVisitResult
{
	New (aId)
	Quit:'##class(DHCHAI.DP.LabInfVisitResult).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.LabInfVisitResult).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-03
/// Description:  更新院感检验结果
/// Table：       DHCHAI.DP.LabInfVisitResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitResult).Update("^4^乙肝标志物^细菌监测^N^金葡萄球菌^1^beizhu^A^N^A")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set LabReportDr  = $p(aInputStr,aSeparete,2)
	Set LabTestDesc  = $p(aInputStr,aSeparete,3)
	Set LabTestCode  = $p(aInputStr,aSeparete,4)
	Set LabRstFormat = $p(aInputStr,aSeparete,5)
	Set LabResult	 = $p(aInputStr,aSeparete,6)
	Set LabTextRes   = $p(aInputStr,aSeparete,7)
	Set LabResNoes	 = $p(aInputStr,aSeparete,8)
	Set LabAbFlag    = $p(aInputStr,aSeparete,9)
	Set LabUnit      = $p(aInputStr,aSeparete,10)
	Set LabRefRanges = $p(aInputStr,aSeparete,11)
								   
	Quit:(LabReportDr="")||(LabTestDesc="")||(LabResult="") return
	Set objLabReport = ##class(DHCHAI.DP.LabInfVisitReport).GetObjById(LabReportDr)
	Quit:'$isobject(objLabReport) return
	//检验结果唯一性
	Set tID=$o(^DHCHAI.DP.LabInfVisitResultI("IndexLabTCCode",LabReportDr,LabTestCode,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabInfVisitResult).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabInfVisitResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabReportDr  = objLabReport
	Set obj.LabTestDesc  = LabTestDesc
	Set obj.LabTestCode  = LabTestCode
	Set obj.LabRstFormat = LabRstFormat
	Set obj.LabResult	 = LabResult
	Set obj.LabTextRes	 = LabTextRes
	Set obj.LabResNoes	 = LabResNoes
	Set obj.LabAbFlag	 = LabAbFlag
	Set obj.LabUnit	     = LabUnit
	Set obj.LabRefRanges = LabRefRanges
	
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
/// Description:  删除院感检验结果
/// Table：       DHCHAI.DP.LabInfVisitResult
/// Input：       aId : DHCHAI.DP.LabInfVisitResult.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfVisitResult).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.LabInfVisitResult).%DeleteId(aId)
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
<Data name="LabInfVisitResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabReportDr</Value>
</Value>
<Value name="3">
<Value>LabTestDesc</Value>
</Value>
<Value name="4">
<Value>LabTestCode</Value>
</Value>
<Value name="5">
<Value>LabRstFormat</Value>
</Value>
<Value name="6">
<Value>LabResult</Value>
</Value>
<Value name="7">
<Value>LabTextRes</Value>
</Value>
<Value name="8">
<Value>LabResNoes</Value>
</Value>
<Value name="9">
<Value>LabAbFlag</Value>
</Value>
<Value name="10">
<Value>LabUnit</Value>
</Value>
<Value name="11">
<Value>LabRefRanges</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabInfVisitResultD</DataLocation>
<DefaultData>LabInfVisitResultDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabInfVisitResultD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabInfVisitResultI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabInfVisitResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
