/// creator:wangCS
/// createDate:2011-07-14
/// description:配置病案管理菜单
Class web.DHCWMRInitMenus Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// w ##Class(web.DHCWMRInitMenus).SaveMenu()
ClassMethod SaveMenu()
{
	set wsObj=##Class(websys.Menu).%New()
	set wsObj.Caption="病案管理业务20110714"
	set wsObj.Name="DHC.MR.Side_YW20110714"
	set subMenuOf=##Class(websys.Menu).%OpenId(52381)
	set wsObj.SubMenuOf=subMenuOf
	set ret=wsObj.%Save()
	set id=0
	if $system.Status.IsError(ret) {
		d $system.OBJ.DisplayError(ret)
		set id=-1	
	}
	else
	{
		set id=wsObj.%Id()
	}
	do wsObj.%Close()
	quit id
}

/// Creator:wcs
/// CreateDate:2011-07-15
/// Description:删除 "DHCWMR" 开头的菜单
/// w ##Class(web.DHCWMRInitMenus).DeleteOldMenu("DHC.MR.Side_YW2011")
ClassMethod DeleteOldMenu(namePrefix As %String)
{
	set ret=-100
	set sqlStr="Delete from websys.Menu where %SQLSTRING(Name) %STARTSWITH %SQLSTRING(?)"
	set result=##Class(%ResultSet).%New()
	set status=result.Prepare(sqlStr)
	set status=result.Execute(namePrefix)
	if (status)
	{
		set ret=1
		w "Row Count=",%ROWCOUNT_"",!
		if (%ROWCOUNT>0){
			w !,"Row Id=",%ROWID
		}
	} 
	else
	{
		w !,"Delete fail，SQLCODE=",status
	}
	quit ret
}

/// w ##Class(web.DHCWMRInitMenus).QueryOldMenu("DHCWMR")
ClassMethod QueryOldMenu(namePrefix As %String)
{
	set sqlStr="select * from websys.Menu where %SQLSTRING(Name) %STARTSWITH %SQLSTRING(?)"
	set result=##Class(%ResultSet).%New()
	set status=result.Prepare(sqlStr)
	set status=result.Execute(namePrefix)
	while (result.Next(.sc))
	{
		if ($SYSTEM.Status.IsOK(sc))
		{
			w !,"Caption:"_result.Data("Caption")_" |||"
			w "Name:"_result.Data("Name")_"|||"
			
			w "Link Url:"_$g(result.Data("LinkUrl"))_"|||"
			w "Link Component:"_$g(result.Data("LinkComponent"))
		}
		else
		{
			quit 
		}
	}
	if ($SYSTEM.Status.IsError(sc))
	{
		w !,"Error:"_$System.Status.DisplayError(sc)
	}
}

}
