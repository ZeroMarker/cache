Class DHCWL.DocQueryData.GetDocKpiData Extends %RegisteredObject
{

/// Creator：      duh
/// CreatDate：    2016年1月28日 13:40:41
/// Description:： 初始化归类(门诊指标、住院指标、医保指标、抗菌药指标等)
/// Table：       
/// Input：       
/// Output：      ^DHCWLDocKpi   --按照节点顺序依次维护
/// Return：      
/// Others：      d ##class(DHCWL.DocQueryData.GetDocKpiData).InitClassField()
ClassMethod InitClassField() As %String
{
	s ^DHCWLDocKpi(1) = "门急诊分类"
	s ^DHCWLDocKpi(2) = "住院分类"
	s ^DHCWLDocKpi(3) = "医保分类"
	s ^DHCWLDocKpi(4) = "抗菌药分类"
	s ^DHCWLDocKpi(5) = "手术统计"
}

/// Creator：      duh
/// CreatDate：    2016年1月28日 13:46:08
/// Description:： 获取归类(门诊指标、住院指标、医保指标、抗菌药指标等)
/// Table：       
/// Input：       
/// Output：      ^DHCWLDocKpi   --按照节点顺序依次维护
/// Return：      
/// Others：      d ##class(DHCWL.DocQueryData.GetDocKpiData).GetClassField()
ClassMethod GetClassField() As %String
{
	
	s num=""  f  s num = $o(^DHCWLDocKpi(num)) q:num=""  d
	.s classField = $g(^DHCWLDocKpi(num))
	.s strData = $g(strData)_"['"_classField_"','"_classField_"'],"
	s strData = $e(strData,1,$l(strData)-1)
	s comboxData = "["_strData_"]"
	//w comboxData,!
	q comboxData
}

}
