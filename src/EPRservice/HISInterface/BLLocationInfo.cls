Class EPRservice.HISInterface.BLLocationInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取医院科室或病区列表;
/// Input:	AType为位置类型(E:科室; W:病区);
/// 		ALocID为科室RowID,当需要获取某科室下病区列表时候用;
/// 		ALocName为科室或病区名称,模糊匹配时用;
/// Debug:	d ##Class(EPRservice.HISInterface.BLLocationInfo).GetLocationList()				
ClassMethod GetLocationList(AType As %String = "E", ALocID As %String = "", ALocName As %String = "", AHospID As %String = "") As %ResultSet
{
	s result = ##Class(%ResultSet).%New("EPRservice.HISInterface.DALocationInfo:GetLocationList")
	d result.Execute(AType,ALocID,ALocName,AHospID)
	q result
}

}
