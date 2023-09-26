Class dhcinterface.BulletinInfo Extends (%Persistent, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 公告内容
Property Content As %String(TRUNCATE = 1);

/// 公告日期
Property PostDate As %String(TRUNCATE = 1);

/// 公告标题
Property Title As %String(TRUNCATE = 1);

ClassMethod GetByID(InfoId As %String) As BulletinInfo
{
	s InfoObject=##class(dhcinterface.BulletinInfo).%New()
	s InfoObject.Title="调试"
	s InfoObject.Content="本月初开始"
	s InfoObject.PostDate="2007-08-30"
	Quit InfoObject
}

}
