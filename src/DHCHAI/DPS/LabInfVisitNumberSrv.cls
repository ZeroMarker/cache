/// 名称: DHCHAI.DPS.LabInfVisitNumberSrv
/// 描述: 检验标本接收记录相关服务
/// 编写者：zhoubo
/// 编写日期: 2021-09-06
Class DHCHAI.DPS.LabInfVisitNumberSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-09-06
/// Description:  根据条码获取检验结果信息
/// Table：       DHCHAI.DP.LabInfVisitNumber
/// Input：       aBarCode : 条码号
///               aLabType : 业务类型（1环境卫生学、2职业暴露）
/// Return：      返回String
/// w ##Class(DHCHAI.DPS.LabInfVisitNumberSrv).GetLabByCode("00000603",2)
ClassMethod GetLabByCode(aBarCode As %String, aLabType As %String) As %String
{
	New (aBarCode,aLabType)
	Set return=""
	Quit:(aBarCode="")||(aLabType="") return
	Set:aLabType=1 aBarCode = "E"_aBarCode
	Set:aLabType=2 aBarCode = "O"_aBarCode
	// 检验条码索引 唯一性
	Set VisitID  = $o(^DHCHAI.DP.LabInfVisitNumberI("IndexLabEpisodeNo"," "_aBarCode,0))
	Set obj = ##class(DHCHAI.DP.LabInfVisitNumber).GetObjById(VisitID)
	Quit:'$IsObject(obj) return
	Set RstInfo=""
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCHAI.DP.LabInfVisitReportI("IndexVisit",VisitID,xRepID))
		Quit:xRepID=""			  
		Set objRep=##class(DHCHAI.DP.LabInfVisitReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Set LabRegDate  = objRep.LabRegDate   // 录入日期(送检日期)
		Set:LabRegDate'="" LabRegDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabRegDate)
		Set LabAuthDate = objRep.LabAuthDate  // 审核日期
		Set:LabAuthDate'="" LabAuthDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(LabAuthDate)
		
		Set xRepRstID=""
		For {
			Set xRepRstID=$o(^DHCHAI.DP.LabInfVisitResultI("IndexLabReportDr",xRepID,xRepRstID))
			Quit:xRepRstID=""			  
			Set objRepRst=##class(DHCHAI.DP.LabInfVisitResult).GetObjById(xRepRstID)
			Continue:'$IsObject(objRepRst)
			
			Set LabTestDesc  = objRepRst.LabTestDesc     // 检验项目名称
			Set LabTestCode  = objRepRst.LabTestCode     // 检验项目代码
			Set LabRstFormat = objRepRst.LabRstFormat    // 结果类型（数字:N、文本:T、列表:S、血型ABO:A、RH血型:R、细菌:M）
			Set LabResult    = objRepRst.LabResult       // 检测结果
			Set LabTextRes   = objRepRst.LabTextRes      // 定性结果
			Set LabResNoes   = objRepRst.LabResNoes      // 结果说明
			Set LabAbFlag    = objRepRst.LabAbFlag       // 异常提示
			Set LabRefRanges = objRepRst.LabRefRanges    // 参考范围
			Set RstInfo = RstInfo_"#"_LabTestDesc_"^"_LabTestCode_"^"_LabRegDate_"^"_LabAuthDate_"^"_LabRstFormat_"^"_LabResult_"^"_LabResNoes_"^"_LabAbFlag_"^"_LabRefRanges
		}	 
	}
	Set:RstInfo'="" RstInfo=$e(RstInfo,2,$l(RstInfo))
	Set return = RstInfo
	
	Quit return
}

}
