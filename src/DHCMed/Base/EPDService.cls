/// 传染病系统的接口
/// 创建者：李阳
/// 创建日期：2013-1-5
Class DHCMed.Base.EPDService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 功能：获取未审核传染病报告数量
/// 返回值：Integer
///        未审核的传染病报告数量
/// w ##class(DHCMed.Base.EPDService).GetNoCheckEpdReportCnt()
ClassMethod GetNoCheckEpdReportCnt() As %Integer
{
	New
	Set ret=0
	
	Set StatusCode=1
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.EPDi("EPD",0,"Status",1,RowID))
		Quit:RowID=""
		Set ret=ret+1
	}
	
	Quit ret
}

}
