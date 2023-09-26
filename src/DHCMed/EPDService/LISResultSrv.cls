/// 名称: DHCMed.EPDService.LISResultSrv
/// 描述: 与LIS结果
/// 编写者：zhufei
/// 编写日期: 2013-09-04
Class DHCMed.EPDService.LISResultSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-09-04
/// Description:  通过检验项目取检验结果（字符串传出）
/// Table：       
/// Input：       LabItems ：检验项目
/// w ##class(DHCMed.EPDService.LISResultSrv).GetLabRstByAdm("","")
ClassMethod GetLabRstByAdm(aEpisodeID As %String, aLabItems As %String) As %String
{
	New (aEpisodeID,aLabItems)
	Set return=""
	Quit:(aEpisodeID="")||(aLabItems="") return
	
	Set $ZT="GetLabRstByAdmErr"
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Kill arrItemResult
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","","",aLabItems,"")
	Set TSRepCount=arrRec.Count()
	For indTSRep=1:1:TSRepCount {
		Set objTSReport=arrRec.GetAt(indTSRep)
		Continue:'$IsObject(objTSReport)
		Set SubmissionDate=objTSReport.SubmissionDate
		
		Set TSResCount=objRec.TestData.Count()
		For indTSRes=1:1:TSResCount {
			Set objTSResult=objRec.TestData.GetAt(indTSRes)
			Continue:'$IsObject(objTSResult)
			
			Set ItemResult=objTSResult.DataText
			Set ItemUnit=objTSResult.ItemUnit
			Set SubmissionDate=$p(SubmissionDate,"-",2)_"-"_$p(SubmissionDate,"-",3)
			If ItemUnit="" {
				Set tmpResult=ItemResult_"("_SubmissionDate_")"
			} Else {
				Set tmpResult=ItemResult_" "_ItemUnit_"("_SubmissionDate_")"
			}
			If $g(arrItemResult(ItemDesc))="" {
				Set arrItemResult(ItemDesc)=tmpResult
			} Else {
				Set arrItemResult(ItemDesc)=$g(arrItemResult(ItemDesc))_","_tmpResult
			}
		}
	}
	
	Set xLabItem=""
	For {
		Set xLabItem=$o(arrItemResult(xLabItem))
		Quit:xLabItem=""
		Set return=return_xLabItem_":"_$g(arrItemResult(ItemDesc))_";    "
	}
	Kill arrItemResult
	
	Quit return
	
GetLabRstByAdmErr
	Set Error=$ZERROR
	Quit ""
}

/// ret=1:成功  ret=0:不成功
/// w ##Class(DHCMed.EPDService.LISResultSrv).ComResult(140.8,"大于",10)
ClassMethod ComResult(argResult, argComCode, argComValue) As %String
{
	New (argResult,argComCode,argComValue)
	Set return=0
	If argComCode="等于" {
		Set:argResult=argComValue return=1
	}ElseIf argComCode="大于" {
		Set:(+argResult)>(+argComValue) return=1
	}ElseIf argComCode="小于" {
		Set:(+argResult)<(+argComValue) return=1
	}ElseIf argComCode="大于等于" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="小于等于" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="不等于" {
		Set:argResult'=argComValue return=1
	}ElseIf argComCode="包含" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="被包含" {
		Set:argResult]argComValue return=1
	}ElseIf argComCode="不包含" {
		Set:argResult'[argComValue return=1
	}ElseIf argComCode="=" {
		Set:argResult=argComValue return=1
	}ElseIf argComCode=">" {
		Set:(+argResult)>(+argComValue) return=1
	}ElseIf argComCode="<" {
		Set:(+argResult)<(+argComValue) return=1
	}ElseIf argComCode=">=" {
		Set:(+argResult)>=(+argComValue) return=1
	}ElseIf argComCode="<=" {
		Set:(+argResult)<=(+argComValue) return=1
	}ElseIf argComCode="'=" {
		Set:argResult'=argComValue return=1
	}ElseIf argComCode="[" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="]" {
		Set:argResult[argComValue return=1
	}ElseIf argComCode="'[" {
		Set:argResult'[argComValue return=1
	}Else{
		Set:argResult=argComValue return=1
	}
    Quit return
}

/// 判断医嘱检验结果是否异常
/// w ##Class(DHCMed.EPDService.LISResultSrv).GetRstAbnorOrderRst()
ClassMethod GetRstAbnorOrderRst(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set TestSetRow=$p($g(^OEORD(+aOEItemID,"I",+$p(aOEItemID,"||",2),3)),"^",35)
	Quit:TestSetRow="" return
	
	Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(TestSetRow)
	Quit:'$IsObject(objTSReport) return
	
	Set TSResCount=objRec.TestData.Count()
	For indTSRes=1:1:TSResCount {
		Set objTSResult=objRec.TestData.GetAt(indTSRes)
		Continue:'$IsObject(objTSResult)
		
		Set ItemDesc=objTSResult.TestDesc    //检验项目描述
		Set ItemResult=objTSResult.DataText  //结果
		Set ItemUnit=objTSResult.ItemUnit    //检验项目的单位
		Set AbnorFlag=objTSResult.AbnorFlag  //异常标记
		Continue:AbnorFlag=""
		Continue:AbnorFlag["N"
		
		Set return=return_ItemDesc_":{"_ItemResult_":"_AbnorFlag_"};"
	}
	Quit return
}

}
