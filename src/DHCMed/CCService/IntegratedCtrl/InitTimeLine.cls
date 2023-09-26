/// 初始化TimeLine信息
/// 
Class DHCMed.CCService.IntegratedCtrl.InitTimeLine Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
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
		Set objTimeLine.Description="感染集成视图"
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
		Set objTimeLine.Description="感染集成视图"
		Set objTimeLine.Notes="医院感染可视化视图,用于院感疑似病例筛查"
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

/// 更新时间线子项字典
/// w ##class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).UpdateClinicalDataType("101^测试","^")
ClassMethod UpdateClinicalDataType(aInput As %String, aSeperator As %String = "^") As %String
{
	New (aInput,aSeperator)
	Set return=-1
	Quit:aInput="" return
	
	Set $ZT="UpdateClinicalDataTypeErr"
	
	Set Code=+$p(aInput,aSeperator,1)
	Set Desc=$p(aInput,aSeperator,2)
	Quit:(Code<10101)||(Code>19901) return
	
	If ##Class(icare.ClinicalDataType).%ExistsId(Code) {
		Set obj=##class(icare.ClinicalDataType).%OpenId(Code)
	} Else {
		Set obj=##class(icare.ClinicalDataType).%New()
	}
	Set obj.Code=Code
	Set obj.Description=Desc
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                               //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//同步保存子项行为字典
		Set aInput=Code_"01"
		Set aInput=aInput_"^"_Desc
		Set aInput=aInput_"^"_obj.%Id()
		Set flg=..UpdateClinicalDataTypeAct(aInput)
		
		//add by wuqk 2013-04-08 增加截至的Act项目
		//同步保存子项行为字典
		Set aInput=Code_"02"
		Set aInput=aInput_"^"_Desc_"截至"
		Set aInput=aInput_"^"_obj.%Id()
		Set flg=..UpdateClinicalDataTypeAct(aInput)
		
	}
	Do obj.%Close()
	
	Quit return
	
UpdateClinicalDataTypeErr
	Quit -999
}

/// 更新时间线子项行为字典
/// w ##class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).UpdateClinicalDataTypeAct("Anti^抗菌药物^LABEL^1^","^")
ClassMethod UpdateClinicalDataTypeAct(aInput As %String, aSeperator As %String = "^") As %String
{
	New (aInput,aSeperator)
	Set return=-1
	Quit:aInput="" return
	
	Set $ZT="UpdateClinicalDataTypeActErr"
	
	Set Code=$p(aInput,aSeperator,1)
	Set Desc=$p(aInput,aSeperator,2)
	Set DataTypeCode=$p(aInput,aSeperator,3)
	Quit:(Code="")||(Desc="")||(DataTypeCode="") return
	
	If ##Class(icare.ClinicalDataTypeAct).%ExistsId(Code) {
		Set obj=##class(icare.ClinicalDataTypeAct).%OpenId(Code)
	} Else {
		Set obj=##class(icare.ClinicalDataTypeAct).%New()
	}
	
	Set objDataType=##class(icare.ClinicalDataType).%OpenId(DataTypeCode)
	If objDataType'="" Do objDataType.%Close()
	
	Set obj.Code=Code
	Set obj.Description=Desc
	Set obj.DataTypeCode=objDataType
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {                               //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdateClinicalDataTypeActErr
	Quit -999
}

/// w ##class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).UpdateTimeLineCategroy("Anti^抗菌药物^L^1^","^")
ClassMethod UpdateTimeLineCategroy(Instr, Seperator)
{
	n (Instr,Seperator)
	Set ID=$p(Instr,"^",1)
	Set obj=""
	Set:ID'="" obj=##class(icare.TimeLineCategroy).%OpenId(ID)
	quit:$IsObject(obj) ID    //add by wuqk 2013-04-08 不覆盖已有分类（例如：01-临床评估，02-生命体征）
	
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

/// w ##class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).UpdateTimeLineItem("INFReason","01^临床评估^01^A^1^","^")
ClassMethod UpdateTimeLineItem(TimeLineID, Instr, Seperator) As %String
{
	New (TimeLineID,Instr, Seperator)
	Set ret=0
	
	Set objTimeLine=##class(icare.TimeLine).%OpenId(TimeLineID)
	Quit:'$IsObject(objTimeLine) ret
	Do objTimeLine.%Close()
	
	Set Code=$p(Instr,Seperator,1)
	Quit:Code="" ret
	
	Set xID="",ID=""
	For {
		Set xID=$o(^icare.TimeLineD(TimeLineID,"Items",xID))
		Quit:xID=""
		Quit:ID'=""
		
		Set objItems=##class(icare.TimeLineItems).%OpenId(TimeLineID_"||"_xID)
		Continue:'$IsObject(objItems)
		Do objItems.%Close()
		Set ItemsCode=objItems.Code
		Continue:ItemsCode'=Code
		Set ID=TimeLineID_"||"_xID
	}
	
	If ID'="" {
		Set obj=##class(icare.TimeLineItems).%OpenId(ID)
	} Else {
		Set obj=##class(icare.TimeLineItems).%New()
	}
	
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

/// w ##Class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).ClearClinicalDataType()
ClassMethod ClearClinicalDataType() As %String
{
	New
	
	Set $ZT="ClearClinicalDataTypeErr"
	
	For ID=10101:1:19901 {
		If ##Class(icare.ClinicalDataType).%ExistsId(ID) {
			//删除子项行为字典
			Set ActID=""
			For {
				Set ActID=$o(^icare.ClinicalDataTypeActI("IndexDataTypeCode",ID,ActID))
				Quit:ActID=""
				Set sc=##class(icare.ClinicalDataTypeAct).%DeleteId(ActID)
				If $System.Status.IsError(sc) {  //检查删除是否成功
			   		Do $system.OBJ.DisplayError(sc)
				}
			}
			//删除子项字典
			Set sc=##class(icare.ClinicalDataType).%DeleteId(ID)
			If $System.Status.IsError(sc) {  //检查删除是否成功
		   		Do $system.OBJ.DisplayError(sc)
			}
		}
	}
	Quit 1
	
ClearClinicalDataTypeErr
	Quit -999
}

/// 导出时间线配置信息
/// 感染集成视图("INFReason")
/// w ##Class(DHCMed.CCService.IntegratedCtrl.InitTimeLine).ExportTimeLine("INFReason")
ClassMethod ExportTimeLine(aTimeLineCode As %String) As %String
{
	New (aTimeLineCode)
	Set return=""
	Quit:aTimeLineCode="" return
	
	Set objTimeLine=##class(icare.TimeLine).%OpenId(aTimeLineCode)
	Quit:'$IsObject(objTimeLine) return
	Do objTimeLine.%Close()
	
	Set TLCode=objTimeLine.Code
	Set TLDesc=objTimeLine.Description
	Set TLNotes=objTimeLine.Notes
	
	Set OutputStr="TimeLine^"_TLCode_"^"_TLDesc_"^"_TLNotes
		
	Set xID=""
	For {
		Set xID=$o(^icare.TimeLineD(TLCode,"Items",xID))
		Quit:xID=""
		
		Set objItem=##class(icare.TimeLineItems).%OpenId(TLCode_"||"_xID)
		Continue:'$IsObject(objItem)
		Do objItem.%Close()
		
		Set Type		 = "Item"
		Set Code		 = objItem.Code
		Set Description  = objItem.Description
		Set Resume		 = ""
		Set Pos			 = objItem.Sequence
		Set ViewType     = objItem.ViewType
		Set DataTypeList=""
		If $IsObject(objItem.CategoryCode) {
			Set DataTypeList=objItem.CategoryCode.DataTypeList	
		}
		Set ViewConfigRowID=""
		Set ViewConfigDesc=""
		Set ViewConfigParam=""
		If $IsObject(objItem.ViewConfig) {
			Set ViewConfigDesc=objItem.ViewConfig.Description
			Set ViewConfigParam=objItem.ViewConfig.Parameters	
		}
		
		Set OutputStr=OutputStr_"||"_Type
		Set OutputStr=OutputStr_"^"_Code
		Set OutputStr=OutputStr_"^"_Description
		Set OutputStr=OutputStr_"^"_Resume
		Set OutputStr=OutputStr_"^"_Pos
		Set OutputStr=OutputStr_"^"_ViewType
		Set OutputStr=OutputStr_"^"_DataTypeList
		Set OutputStr=OutputStr_"^"_ViewConfigRowID
		Set OutputStr=OutputStr_"^"_ViewConfigDesc
		Set OutputStr=OutputStr_"^"_ViewConfigParam
	}
	
	Quit OutputStr
}

}
