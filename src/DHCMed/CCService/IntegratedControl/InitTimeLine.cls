/// 初始化TimeLine信息
/// 
Class DHCMed.CCService.IntegratedControl.InitTimeLine Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Install()
{
	
	
	
	
	
	
CreateClinicalDataType()

	
	
CreateTimeLineInfo()	
	n
	if ($d(^icare.TimeLineD("INFReason"))=0)
	{
		Set objTimeLine=##class(icare.TimeLine).%New()
		Set objTimeLine.Code="INFReason"
		Set objTimeLine.Description="感染因素"
		Set ret=objTimeLine.%Save()
		Do objTimeLine.%Close()
	}
	else
	{
		Set objTimeLine=##class(icare.TimeLine).%OpenId("INFReason")
		Do objTimeLine.%Close()
	}
	Quit objTimeLine
}

ClassMethod CreateTimeLineInfo()
{
	if ($d(^icare.TimeLineD("INFReason"))=0)
	{
		Set objTimeLine=##class(icare.TimeLine).%New()
		Set objTimeLine.Code="INFReason"
		Set objTimeLine.Description="感染因素"
		Set ret=objTimeLine.%Save()
		Do objTimeLine.%Close()
	}
	else
	{
		Set objTimeLine=##class(icare.TimeLine).%OpenId("INFReason")
		Do objTimeLine.%Close()
	}
	Quit objTimeLine.%Id()
}

/// 保存icare.ClinicalDataType表
ClassMethod UpdateClinicalDataType(Instr As %String, Seperator As %String) As %String
{
	n (Instr,Seperator)
	Set ID=$p(Instr,Seperator,1)
	Set obj=""
	Set:ID'="" obj=##class(icare.ClinicalDataType).%OpenId(ID)
	Set:$IsObject(obj)=0 obj=##class(icare.ClinicalDataType).%New()
	Set obj.Code=$p(Instr,Seperator,1)
	Set obj.Description=$p(Instr,Seperator,2)
	Set ret=obj.%Save()
	Do obj.%Close()
	Quit obj.%Id()
}

/// 保存icare.ClinicalDataTypeAct表
/// w ##class(DHCMed.CCService.IntegratedControl.InitTimeLine).UpdateClinicalDataTypeAct("Anti^抗菌药物^LABEL^1^","^")
ClassMethod UpdateClinicalDataTypeAct(Instr As %String, Seperator As %String) As %String
{
	n (Instr,Seperator)
	Set ID=$p(Instr,Seperator,1)
	Set obj=""
	Set obj=##class(icare.ClinicalDataTypeAct).%OpenId(ID)
	Set:$IsObject(obj)=0 obj=##class(icare.ClinicalDataTypeAct).%New()
	Set obj.Code=$p(Instr,Seperator,1)
	Set obj.Description=$p(Instr,Seperator,2)
	Set DataTypeCode=obj.Code
	Set objDataType=##class(icare.ClinicalDataType).%OpenId($p(Instr,Seperator,3))
	Do objDataType.%Close()
	Set obj.DataTypeCode=objDataType
	Set ret=obj.%Save()
	Do obj.%Close()
	Quit obj.%Id()
}

/// w ##class(DHCMed.CCService.IntegratedControl.InitTimeLine).UpdateTimeLineCategroy("Anti^抗菌药物^L^1^","^")
ClassMethod UpdateTimeLineCategroy(Instr, Seperator)
{
	n (Instr,Seperator)
	Set ID=$p(Instr,"^",1)
	Set obj=""
	Set:ID'="" obj=##class(icare.TimeLineCategroy).%OpenId(ID)
	Set:$IsObject(obj)=0 obj=##class(icare.TimeLineCategroy).%New()
	Set obj.Code=$p(Instr,Seperator,1)
	Set obj.Description=$p(Instr,Seperator,2)
	Set list=$p(Instr,Seperator,3)
	Set tmpList=""
	For i=1:1:$l(list) {
		Set itm=$p(list,"#",i)
		Continue:itm=""
		if (tmpList="")
		{
			Set tmpList=$lb(itm)
		}
		else
		{
			Set tmpList=tmpList_$lb(itm)
		}
	}
	Set obj.DataTypeList=tmpList
	Set ret=obj.%Save()
	Quit obj.%Id()
}

/// w ##class(DHCMed.CCService.IntegratedControl.InitTimeLine).UpdateTimeLineItem("Anti^抗菌药物^L^1^","^")
ClassMethod UpdateTimeLineItem(Instr, Seperator) As %String
{
	Set ID=$p(Instr,Seperator,1)
	Set obj=""
	Set obj=##class(icare.TimeLineItems).%OpenId(ID)
	Set:$IsObject(obj)=0 obj=##class(icare.TimeLineItems).%New()
	Set obj.Code=$p(Instr,Seperator,1)
	Set obj.Description=$p(Instr,Seperator,2)
	Set obj.CategoryCode=##class(icare.TimeLineCategroy).%OpenId($p(Instr,Seperator,3))
	Set obj.ViewType=$p(Instr,Seperator,4)
	Set obj.Sequence=$p(Instr,Seperator,5)
	/*
	Set objViewConfig=##class(icare.ViewTypeConfig).%New()
	Set objViewConfig.Description=obj.Description
	Set objViewConfig.Parameters=$p(Instr,Seperator,5)
	Set ret=objViewConfig.%Save()
	Do objViewConfig.%Close()
	*/
	Set objTimeLine=##class(icare.TimeLine).%OpenId("INFReason")
	Do objTimeLine.%Close()
	
	Set obj.TimeLine=objTimeLine
	Set objViewConfig=##class(icare.ViewTypeConfig).%OpenId($p(Instr,Seperator,6))
	Set obj.ViewConfig=objViewConfig
	Set ret=obj.%Save()
	Do obj.%Close()
	Quit ret
}

ClassMethod UpdateViewTypeConfig(Instr, Seperator) As %String
{
	n (Instr, Seperator)
	Set ID=$p(Instr,Seperator,1)
	if (ID="")
	{
		Set obj=##class(icare.ViewTypeConfig).%New()
	}
	else
	{
		Set obj=##class(icare.ViewTypeConfig).%OpenId(ID)
	}
	Set obj.Description=$p(Instr,Seperator,2)
	Set obj.Parameters=$p(Instr,Seperator,3)
	Set tmp=obj.%Save()
	Do obj.%Close()
	Quit:tmp<0 tmp
	Quit obj.%Id()
}

ClassMethod DeleteClinicalDataType(Code) As %String
{
	set ret=##class(icare.ClinicalDataType).%DeleteId(Code)
	set ret=##class(icare.ClinicalDataTypeAct).%DeleteId(Code_"01")
	set ret=##class(icare.TimeLineCategroy).%DeleteId(Code)
	set ret=##class(icare.TimeLineCategroy).%DeleteId(Code_"01")
	Quit ret
}

ClassMethod DeleteTimeLineInfo(Code) As %String
{
	Set ChildSub=""
	For {
		Set ChildSub=$o(^icare.TimeLineD(Code,"Items",ChildSub))
		Quit:ChildSub=""
		Do ##class(icare.TimeLineItems).%DeleteId(Code_"||"_ChildSub)
	}
	Quit ##class(icare.TimeLine).%DeleteId(Code)
}

}
