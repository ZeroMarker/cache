/// 名称: DHCMA.Util.IO.FromBaseSrv
/// 描述: HIS相关基础服务
/// 编写者：zhufei
/// 编写日期: 2020-10-21
Class DHCMA.Util.IO.FromBaseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 在视图管理中配置菜单（供Portal平台调用）
/// w ##Class(DHCMA.Util.IO.FromBaseSrv).ImportViews("","^")
ClassMethod ImportViews(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	代码	名称	连接	组件 
	Set MenuCode=$p(aInputStr,aSeparate,2)
	Set MenuCaption=$p(aInputStr,aSeparate,3)
	Set LinkUrl=$p(aInputStr,aSeparate,4)
	Set Expression=""
	
	Set return=##Class(websys.View).Save("",MenuCode,MenuCaption,LinkUrl,Expression)
	Quit (+return)
}

}
