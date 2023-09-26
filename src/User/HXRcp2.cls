Class User.HXRcp2 Extends %RegisteredObject
{

/// 统计该病人就诊总次数
/// createdate:2023-9-16
/// creator:黄欣然
/// w ##class(User.HXRcp2).HuangXinrancpb()
ClassMethod HuangXinrancpb(PAPMIName As %String = "")
{
	q:PAPMIName="" "病人姓名不为空"
	
	s name =$ZConvert(PAPMIName,"U") ///将病人姓名转为大写
	s papmiRowId = ""
	s papmiRowId = $o(^PAPERi("PAPER_PatName",name,papmiRowId))
	q:papmiRowId="" "病人不存在"
	///病人就诊类型
	s paAdmType = ""
	s count = 0
	///for循环遍历计算就诊次数
	for
	{
		s PaAdmType = $o(^PAPERdr(papmiRowId,"ADM",paAdmType))
		q:paAdmType="" ///遍历就诊类型
		s paAdmRowId = ""
		for
		{
			s paAdmRowId = $o(^PAPERdr(papmiRowId,"ADM",paAdmType,paAdmRowId))
			q:paAdmRowid=""
			s count = count + 1 ///统计就诊次数
		}
	}
	///输出结果
	q count
}

}
