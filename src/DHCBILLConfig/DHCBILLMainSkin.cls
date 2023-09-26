Import SQLUSER

/// Creator:TangTao
/// CreateDate:2013-1-10
/// Function  :系统主题业务逻辑
Class DHCBILLConfig.DHCBILLMainSkin Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 设置主题，如果用于已经设置过，则更新原来的主题
/// w ##class(DHCBILLConfig.DHCBILLMainSkin).setSkin(1,"")
ClassMethod setSkin(guser, skin)
{
	i skin'="" d
	.i +$p(skin,"-",2)=0 s path="../scripts/dhcjfsysconfig/Ext/resources/css/ext-all.css"  
	.e  d
	..s path="../scripts/dhcjfsysconfig/Ext/theme"_+$p(skin,"-",2)_"/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=1 s path="../scripts/dhcjfsysconfig/Ext/theme1/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=2 s path="../scripts/dhcjfsysconfig/Ext/theme2/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=3 s path="../scripts/dhcjfsysconfig/Ext/theme3/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=4 s path="../scripts/dhcjfsysconfig/Ext/theme4/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=5 s path="../scripts/dhcjfsysconfig/Ext/theme5/resources/css/ext-all.css"
	.;i +$p(skin,"-",2)=6 s path="../scripts/dhcjfsysconfig/Ext/theme6/resources/css/ext-all.css"
	e  s skin="skin-0",path="../scripts/dhcjfsysconfig/Ext/resources/css/ext-all.css"    //设置默认主题
	s rtn=0
	i $d(^DHCJFSysSkin(0,"User",guser)) d
	.s skinRowid=$o(^DHCJFSysSkin(0,"User",guser,""),-1)
	.k PLIST
	.s PLIST(2)=path,PLIST(6)=$tr(skin,"-","")
	.&sql(update DHC_JFSystemSkin values :PLIST() where DHCJF_RowID=:skinRowid)
	.s rtn=SQLCODE
	e  d
	.k PLIST
	.s PLIST(2)=path ,PLIST(3)=guser,PLIST(6)=$tr(skin,"-","")
	.&sql(INSERT INTO DHC_JFSystemSkin Values :PLIST())
	.s rtn=SQLCODE 
	
	s rtn=rtn_"^"_path
	
	q rtn
}

/// 根据用户获取主题CSS的路径，如果用户没有设置过主题，则返回空
/// w ##class(DHCBILLConfig.DHCBILLMainSkin).getSkinPath(1)
ClassMethod getSkinPath(guser)
{
	 q:guser="" ""
	 s linkPath="../scripts/dhcjfsysconfig/Ext/resources/css/ext-all.css" 
	 i $d(^DHCJFSysSkin(0,"User",guser)) d 
	 .s skinRowid=$o(^DHCJFSysSkin(0,"User",guser,""),-1)
	 .s str=$g(^DHCJFSysSkin(skinRowid))
	 .s code=$p(str,"^",1)
	 .s desc=$p(str,"^",2)
	 .s path=$p(str,"^",3)
	 .s linkPath=path
	 
	 q linkPath
}

/// 根据用户获取主题Code,用于初始化“界面风格”菜单
/// w ##class(DHCBILLConfig.DHCBILLMainSkin).getSkinPath(1)
ClassMethod getSkinCode(guser)
{
	 q:guser="" ""
	 s code=""
	 i $d(^DHCJFSysSkin(0,"User",guser)) d
	 .s skinRowid=$o(^DHCJFSysSkin(0,"User",guser,""),-1)
	 .s str=$g(^DHCJFSysSkin(skinRowid))
	 .s code=$p(str,"^",1)
	 .s desc=$p(str,"^",2)
	 .s path=$p(str,"^",3)
	 
	 q code
}

}
