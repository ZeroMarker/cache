Class web.CDSS.CMKB.VersionLib Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:ZWW
/// CreatDate:2022-06-06
/// Description：CDSS当前版本
/// Other:w ##class(web.CDSS.CMKB.VersionLib).GetVersion()
ClassMethod GetVersion() As %String
{
	q "CDSS_V2.0_20220606"	//注意：该值为版本固定值，不可随意修改，若要添加其他信息，以"_"分隔追加。
}

}
