/// 名称: DHCCPW.IO.FromFeeSrv
/// 描述: 计费提供接口服务
/// 编写者：zhufei
/// 编写日期: 2016-02-01
Class DHCCPW.IO.FromFeeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-02-01
/// Description:  根据就诊号/账单号查询病人费用分类（From计费组）
/// Input：       Adm：就诊号
///               ItmFlag：项目标记
/// 					OC:门诊子分类,	TOC:门诊大类(默认)
/// 					IC:住院子分类,	TIC:住院大类
/// 					AC:会计子分类,	TAC:会计大类
/// 					MC:病案首页子分类,	TMC:病案首页大类 (注意：病案首页分类需根据医院具体情况取)
/// 					MCNew:新病案首页子分类,	TMCNew:新病案首页大类
/// Return:		  返回String=分类Rowid^分类Code^分类名称^分类金额！分类Rowid^分类Code^分类名称^分类金额!....
/// w ##class(DHCCPW.IO.FromFeeSrv).IGetTarItemCate(13761925)
ClassMethod IGetTarItemCate(aEpisodeID As %String, aItmFlag As %String = "MCNew") As %String
{
	New (aEpisodeID,aItmFlag)
	Set return=""
	Quit:(aEpisodeID="")||(aItmFlag="") return
	
	Set return=##class(web.DHCBillInterface).IGetTarItemCate(aEpisodeID,"",aItmFlag,"^^^^")
	Quit return
}

}
