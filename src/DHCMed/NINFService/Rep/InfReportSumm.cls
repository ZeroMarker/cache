/// 名称: DHCMed.NINFService.Rep.InfReportSumm
/// 描述: 医院感染报告 摘要信息
/// 编写者：zhufei
/// 编写日期: 2011-06-21
Class DHCMed.NINFService.Rep.InfReportSumm Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReportSumm.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportSumm).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportSumm
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Summ",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReportSumm.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportSumm).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportSumm
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportSumm).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-25
/// Description:  取医院感染报告 摘要信息 字段值
///               主要处理"List"类型数据
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReportSumm.ID
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Rep.InfReportSumm).GetFieldById(1,"InfFactors")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set $ZT="GetFieldByIdErr"
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If aFieldName="InfFactors" {
		For ind=1:1:obj.InfFactors.Count() {
			Set objDic=obj.InfFactors.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} ElseIf aFieldName="InvasiveOperation" {
		For ind=1:1:obj.InvasiveOperation.Count() {
			Set objDic=obj.InvasiveOperation.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} ElseIf aFieldName="OutICUStatus" {
		For ind=1:1:obj.OutICUStatus.Count() {
			Set objDic=obj.OutICUStatus.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} ElseIf aFieldName="OutICU48Status" {
		For ind=1:1:obj.OutICU48Status.Count() {
			Set objDic=obj.OutICU48Status.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_$c(1)_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	} Else {
		Set valExpress="Set return=obj."_aFieldName
		X valExpress
	}
	
	Quit return
	
GetFieldByIdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportSumm).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportSumm).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 摘要信息
/// Table：       DHCMed.NINF.Rep.InfReportSumm
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportSumm).SaveSubRec("","")
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set return=-1
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set SubID=$o(^DHCMed.NINF("InfRep",RepID,"Summ",0))
	Set $p(aInput,CHR1,2)=SubID
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportSumm).Update(aInput,CHR1_","_CHR2)
	Quit return
	
SaveSubRecErr
	Quit -999
}

}
