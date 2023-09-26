/// 医院感染接口
/// 创建者：李阳
/// 创建日期：2012-1-5
Class DHCMed.Base.INFService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 获取未审核医院感染报告数量
/// 返回值：%Integer
/// >0:      未审核的医院感染报告数量	
/// -1：无法获取医院感染报告类别字典信息
/// -2: 无法获取医院感染报告状态信息
/// w ##class(DHCMed.Base.INFService).GetNoCheckReportCnt()
ClassMethod GetNoCheckReportCnt() As %Integer
{
	New
	
	Set ret=-1
	Set objRepTypeDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFInfReportType","COMP",1) //COMP--医院感染报告
	Quit:'$IsObject(objRepTypeDic) ret
	Set RepTypeID=objRepTypeDic.%Id()
	
	Set ret=-2
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFInfReportStatus","2",1) //2--代表提交状态
	Quit:'$IsObject(objRepStatus) ret
	Set RepStatusID=objRepStatus.%Id()
	
	Set ret=0
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.NINFi("InfRep",0,"IndexStatus",RepTypeID,RepStatusID,RowID))
		Quit:RowID=""
		Set ret=ret+1
	}
	
	Quit ret
}

}
