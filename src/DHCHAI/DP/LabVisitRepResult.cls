/// 名称: DHCHAI.DP.LabVisitRepResult
/// 描述: 检验结果
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabVisitRepResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验报告
Property LabReportDr As DHCHAI.DP.LabVisitReport [ Required ];

/// 检验项目名称
Property LabTestDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验项目代码
Property LabTestCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 结果类型（数字:N、文本:T、列表:S、血型ABO:A、RH血型:R、细菌:M）
Property LabRstFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检测结果
Property LabResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定性结果
Property LabTextRes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果说明(备注)
Property LabResNoes As %String(MAXLEN = 500, TRUNCATE = 1);

/// 异常提示
Property LabAbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property LabUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 参考范围
Property LabRefRanges As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐结果
Property LabMDRResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 细菌感染类型  add 20201028
Property LabMakeInfType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 细菌感染类型添加方式  add 20201028
Property LabIsByHand As %Boolean;

/// 多耐菌群   add 20230423
Property MultipleResChild As %String(MAXLEN = 100, TRUNCATE = 1);

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

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据检验项目代码取检验结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       aReportDr:DHCHAI.DP.LabVisitRepResult.LabReportDr
/// 			  aTCCode:DHCHAI.DP.LabVisitRepResult.LabTestCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepResult).GetObjByTestCode("293","F0032")
ClassMethod GetObjByTestCode(aReportDr As %String, aTCCode As %String) As DHCHAI.DP.LabVisitRepResult
{
	New (aReportDr,aTCCode)
	Set return=""
	Quit:(aReportDr="")||(aTCCode="") return
	
	Set id=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",aReportDr,aTCCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-08-15
/// Description:  作废监控结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       
/// Return：      返回String
/// w ##class(DHCHAI.DP.LabVisitRepResult).CancelResult(299)
ClassMethod CancelResult(aReportDr) As %String
{
	New (aReportDr)
	Set return = ""
	Quit:(aReportDr="") return
	Set xID = 0
	For {
		Set xID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",aReportDr,xID))
		Quit:xID=""
		Continue:'##class(DHCHAI.DP.LabVisitRepResult).%ExistsId(+xID)
		Do ..DeleteById(xID)
	}
	Quit "1"
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取检验结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       ID:    DHCHAI.DP.LabVisitRepResult.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabVisitRepResult
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabVisitRepResult).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabVisitRepResult).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检验结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitRepResult).Update("^282^LISA001^检查结果^T^检查结果^检查结果^^^^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set ReportDr	= $p(InStr,aSeparete,2)
	Set TestCode	= $p(InStr,aSeparete,3)
	Set TestDesc	= $p(InStr,aSeparete,4)
	Set RstFormat	= $p(InStr,aSeparete,5)
	Set Result		= $p(InStr,aSeparete,6)
	Set TextRes		= $p(InStr,aSeparete,7)
	Set ResNoes		= $p(InStr,aSeparete,8)
	Set AbFlag		= $p(InStr,aSeparete,9)
	Set Unit		= $p(InStr,aSeparete,10)
	Set RefRanges	= $p(InStr,aSeparete,11)
	Set MDRResult	= $p(InStr,aSeparete,12)
	Set MakeInfType	= $p(InStr,aSeparete,13)
	Set IsByHand	= $p(InStr,aSeparete,14)
	Set MultipleRes = $p(InStr,aSeparete,15)  //add 20230423
	Quit:(ReportDr="")||(TestCode="") return
	
	//检验结果唯一性
	Set tID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",ReportDr,TestCode,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objReport = ##class(DHCHAI.DP.LabVisitReport).GetObjById(ReportDr)
	Quit:'$isobject(objReport) return
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabVisitRepResult).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabVisitRepResult).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabReportDr	= objReport
	Set obj.LabTestDesc	= TestDesc
	Set obj.LabTestCode	= TestCode
	Set obj.LabRstFormat= RstFormat
	Set obj.LabResult	= Result
	Set obj.LabTextRes	= TextRes
	Set obj.LabResNoes	= ResNoes
	Set obj.LabAbFlag	= AbFlag
	Set obj.LabUnit		= Unit
	Set obj.LabRefRanges= RefRanges
	Set obj.LabMDRResult= MDRResult
    //add 20220302 污染细菌根据备注说明同步为污染类型，有多条细菌结果只备注一条，需特殊处理
	If (ResNoes["污染") {
		Set obj.LabMakeInfType = 4
		Set obj.LabIsByHand = 1
	}
	//已经标记的数据重新同步不修改标记
	If (IsByHand'="") {
		Set obj.LabMakeInfType=MakeInfType
		Set obj.LabIsByHand =IsByHand
	}
	
    Set obj.MultipleResChild = MultipleRes
   
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
/// Description:  删除检验结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabVisitRepResult).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2020-10-28
/// Description:  更新检验结果感染类型
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabVisitRepResult).Update("")
ClassMethod UpdateInfType(aID As %String, aMakeInfType As %String, aIsByHand As %String) As %String
{
	New (aID,aMakeInfType,aIsByHand)
	Quit:aID="" return
	Set obj=##class(DHCHAI.DP.LabVisitRepResult).%OpenId(aID)
	Quit:'$IsObject(obj) return

	Set obj.LabMakeInfType=aMakeInfType
	Set obj.LabIsByHand =aIsByHand

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
/// CreatDate：   2020-12-28
/// Description:  更新检验结果感染类型
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       ID:    DHCHAI.DP.LabVisitRepResult.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepResult).GetInfType(303)
ClassMethod GetInfType(aID As %String) As %String
{
	New (aID)
	Set return=""
	Quit:aID="" return
    Set RepResult=$g(^DHCHAI.DP.LabVisitRepResultD(aID))
    Quit:RepResult="" ""
    Set InfTypeCode = $lg(RepResult,13)
    Quit:InfTypeCode="" ""
    Set TypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode","IRInfType",0))
	Quit:TypeID="" ""
    Set InfTypeID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,InfTypeCode,0))
    Quit:InfTypeID="" ""
    Set InfTypeInfo=$g(^DHCHAI.BT.DictionaryD(InfTypeID))
    Quit:InfTypeInfo="" ""
    Set InfType=$lg(InfTypeInfo,3) 
    Set return = InfTypeID_"^"_InfTypeCode_"^"_InfType
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-12-28
/// Description:  多重耐药菌报告感染类型标记检验结果
/// Table：       DHCHAI.DP.LabVisitRepResult
/// Input：       ID:    DHCHAI.DP.LabVisitRepResult.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabVisitRepResult).ReportInfType(303)
ClassMethod ReportInfType(aID As %String, aInfType As %String) As %String
{
	New (aID,aInfType)
	Quit:aID="" return
	Set InfTypeInfo=$g(^DHCHAI.BT.DictionaryD(aInfType))
    Quit:InfTypeInfo="" ""
    Set InfTypeCode=$lg(InfTypeInfo,2) 
    Quit:InfTypeCode="" ""
    
	Set obj=##class(DHCHAI.DP.LabVisitRepResult).%OpenId(aID)
	Quit:'$IsObject(obj) return

	Set obj.LabMakeInfType=InfTypeCode
	Set obj.LabIsByHand =1

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
<Value name="12">
<Value>LabMDRResult</Value>
</Value>
<Value name="13">
<Value>LabMakeInfType</Value>
</Value>
<Value name="14">
<Value>LabIsByHand</Value>
</Value>
<Value name="15">
<Value>MultipleResChild</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabVisitRepResultD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabVisitRepResultD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabVisitRepResultI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabVisitRepResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
