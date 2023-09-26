/// 名称: DHCMA.CPW.IO.ToHis
/// 描述: 给生产中心接口
/// 编写者：jiangpengpeng
/// 编写日期: 2018-12-07
Class DHCMA.CPW.IO.ToHis Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-07
/// Description:  清除临床路径业务数据
/// Input：       
/// Return:		  
/// w ##class(DHCMA.CPW.IO.ToHis).ClearSrvData()
ClassMethod ClearSrvData() As %String
{
	Kill ^DHCMA.CPW.CP.PathwayD	
	Kill ^DHCMA.CPW.CP.PathwayI
	
	Quit 1
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-07
/// Description:  清除临床路径基础数据
/// Input：       
/// Return:		  
/// w ##class(DHCMA.CPW.IO.ToHis).ClearBaseData()
ClassMethod ClearBaseData() As %String
{
	Kill ^DHCMA.CPW.BT.PathLocD			//科室常用路径
	Kill ^DHCMA.CPW.BT.PathLocI
	
	&sql(delete DHCMA_CPW_BT.PathFormOrd)	//关联医嘱
	&sql(delete DHCMA_CPW_BT.PathFormMR)	//关联病历
	Quit 1
}

}
