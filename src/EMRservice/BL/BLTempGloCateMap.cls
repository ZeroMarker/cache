Class EMRservice.BL.BLTempGloCateMap Extends %RegisteredObject
{

/// 
/// 入参：ATemplateID  	病历模板ID
/// 		 ATitleCode		可重复模板的标题ID
/// 返回值 正常值：		术语集目录内部标识符  
/// 		  无数据返回：	NULL
/// debugger: w ##class(EMRservice.BL.BLTempGloCateMap).GetGloCateInternalID(16)
/// debugger: w ##class(EMRservice.BL.BLTempGloCateMap).GetGloCateInternalID(20,1)
/// debugger: w ##class(EMRservice.BL.BLTempGloCateMap).GetGloCateInternalID(1240)
ClassMethod GetGloCateInternalID(ATemplateID As %String, ATitleCode As %String = "") As %String
{
	q:($g(ATemplateID)="") "请传入模板ID"
	s:(ATitleCode="") ATitleCode=$c(0)
	s tmpInternalID=""
	s tmpInternalID=$o(^DHCEMRM.TempGloCateMapI("IdxMain"," "_ATemplateID," "_ATitleCode,tmpInternalID))
	q:(tmpInternalID="") "NULL"
	s ret=$e(tmpInternalID,2,*)
	q ret
}

/// d ##class(EMRservice.BL.BLTempGloCateMap).foo()
ClassMethod foo()
{
	s obj = ##Class(EMRmeta.TemplateGlossaryCategoryMap).%OpenId(2)
	s obj.TitleCode=$c(0)
	d obj.%Save()
}

}
