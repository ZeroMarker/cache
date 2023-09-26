Import SQLUSER

/// Creator:Lid
/// CreateDate:2010-05-25
/// Function  :系统主题业务逻辑
Class DHCBILL.Diet.DHCIPMealSkin Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Lid 
/// 2010-05-25
/// 设置主题，如果用于已经设置过，则更新原来的主题
/// w ##class(DHCBILL.Diet.DHCIPMealSkin).setSkin(1,"")
ClassMethod setSkin(guser, skin)
{
	i skin'="" d   ;写死了，需要优化啊
	.i +$p(skin,"-",2)=0 s path="../scripts/dhcdiet/Ext/resources/css/ext-all.css"             
	.i +$p(skin,"-",2)=1 s path="../scripts/dhcdiet/Ext/theme1/resources/css/ext-all.css"
	.i +$p(skin,"-",2)=2 s path="../scripts/dhcdiet/Ext/theme2/resources/css/ext-all.css"
	.i +$p(skin,"-",2)=3 s path="../scripts/dhcdiet/Ext/theme3/resources/css/ext-all.css"
	.i +$p(skin,"-",2)=4 s path="../scripts/dhcdiet/Ext/theme4/resources/css/ext-all.css"
	.i +$p(skin,"-",2)=5 s path="../scripts/dhcdiet/Ext/theme5/resources/css/ext-all.css"
	.i +$p(skin,"-",2)=6 s path="../scripts/dhcdiet/Ext/theme6/resources/css/ext-all.css"
	e  s skin="skin-0",path="../scripts/dhcdiet/Ext/resources/css/ext-all.css"    //设置默认主题
	s rtn=0
	i $d(^DHCIPMEALSysSkin(0,"User",guser)) d
	.s skinRowid=$o(^DHCIPMEALSysSkin(0,"User",guser,""),-1)
	.k PLIST
	.s PLIST(2)=path,PLIST(6)=$tr(skin,"-","")
	.&sql(update DHC_IPMealSystemSkin values :PLIST() where DHCMS_RowID=:skinRowid)
	.s rtn=SQLCODE
	e  d
	.k PLIST
	.s PLIST(2)=path ,PLIST(3)=guser,PLIST(6)=$tr(skin,"-","")
	.&sql(INSERT INTO DHC_IPMealSystemSkin Values :PLIST())
	.s rtn=SQLCODE 
	
	s rtn=rtn_"^"_path
	
	q rtn
}

/// Lid 
/// 2010-05-25
/// 根据用户获取主题CSS的路径，如果用户没有设置过主题，则返回空
/// w ##class(DHCBILL.Diet.DHCIPMealSkin).getSkinPath(1)
ClassMethod getSkinPath(guser)
{
	 q:guser="" ""
	 s linkPath="../scripts/dhcdiet/Ext/resources/css/ext-all.css" 
	 i $d(^DHCIPMEALSysSkin(0,"User",guser)) d 
	 .s skinRowid=$o(^DHCIPMEALSysSkin(0,"User",guser,""),-1)
	 .s str=$g(^DHCIPMEALSysSkin(skinRowid))
	 .s code=$p(str,"^",1)
	 .s desc=$p(str,"^",2)
	 .s path=$p(str,"^",3)
	 .s linkPath=path
	 
	 q linkPath
}

/// Lid 
/// 2010-05-25
/// 根据用户获取主题Code,用于初始化“界面风格”菜单
/// w ##class(DHCBILL.Diet.DHCIPMealSkin).getSkinPath(1)
ClassMethod getSkinCode(guser)
{
	 q:guser="" ""
	 s code=""
	 i $d(^DHCIPMEALSysSkin(0,"User",guser)) d
	 .s skinRowid=$o(^DHCIPMEALSysSkin(0,"User",guser,""),-1)
	 .s str=$g(^DHCIPMEALSysSkin(skinRowid))
	 .s code=$p(str,"^",1)
	 .s desc=$p(str,"^",2)
	 .s path=$p(str,"^",3)
	 
	 q code
}

}
