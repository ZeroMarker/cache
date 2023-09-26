Class web.DHCWLTarEcService Extends %RegisteredObject
{

// description:初始化核算报表所使用的 分类，如:核算分类，会计分类，收费项目分类等

// createDate:2019年5月16日 14:36:06

// 节点和对应字段:

// 40 DHC_TarAcctCate 会计分类 ,41 DHC_TarEMCCate 核算分类 ,42 DHC_TarInpatCate 住院分类 ,43 DHC_TarMRCate 病案分类 ,44 DHC_TarOutpatCate 门诊分类 

// 45 DHC_TarSubCate 收费子分类

// other:d ##class(web.DHCWLTarEcService).InitTarType()

ClassMethod InitTarType()
{
	//node 和type 需要对应
	s ^DHCWLTarEc("tarNode")=41
	s ^DHCWLTarCategory("tarType")="DHC_TarEMCCate"
	s ^DHCWLTarDesc("tarDesc")="核算"
}

// other:d ##class(web.DHCWLTarEcService).HavePermissions()

// 初始化的工号才能查询明细表的所有数据

ClassMethod HavePermissions()
{
	//node 和type 需要对应
	s ^DHCWLPermission("userInitials")="2002" //工号初始化
}

}
