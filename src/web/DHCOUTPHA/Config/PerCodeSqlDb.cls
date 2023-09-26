Import SQLUSER

/// Description:门诊药房人员代码维护操作表结构类
/// Creator:    hulihua
/// CreateDate: 2019-02-19
Class web.DHCOUTPHA.Config.PerCodeSqlDb Extends %RegisteredObject
{

/// Description:增加药房人员代码维护
/// Creator:	hulihua
/// CreateDate:	2019-02-19
/// Table:      DHC_PHPERSON--药房人员定义表
/// Input:		科室ID、人员姓名、人员ID、配药标志、发药标志、无效标志、人员ID、审核权限
/// Output:		
/// Return：	0-成功，非0-失败 
/// Others:		在原方法上仅增加注释
/// Debug:		w ##class(web.DHCOUTPHA.Config.PerCodeSqlDb).insertPhPerson("")	
ClassMethod insertPhPerson(ctloc As %Library.String = "", username As %Library.String = "", userid As %Library.String = "", py As %Library.String = "", fy As %Library.String = "", use As %Library.String = "", AuditFlag As %Library.String = "")
{
	i ctloc'=""  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i phl="" q "-1^请在门诊药房科室维护中先维护选择的科室!"
	&sql(select count(*) into :pp from sqluser.dhc_phperson where php_phl_dr=:phl and php_ssusr_dr=:userid)
	i pp'=0  q "-2^不允许添加重复数据!"
	e  d
	.&sql(insert into SQLUser.DHC_Phperson 
	(php_phl_dr,php_name,php_ssusr_dr,php_pyflag,php_fyflag,php_useflag,php_mixflag)values(:phl,:username,:userid,:py,:fy,:use,:AuditFlag))
	q SQLCODE
}

/// Description:删除药房人员代码维护
/// Creator:	hulihua
/// CreateDate:	2019-02-19
/// Table:      DHC_PHPERSON--药房人员定义表
/// Input:		删除记录ID
/// Output:		
/// Return：	0-成功，非0-失败 
/// Others:		在原方法上仅增加注释，如果发生过业务不予许删除,目前判断不出,暂不处理
/// Debug:		w ##class(web.DHCOUTPHA.Config.PerCodeSqlDb).deletePhPerson("")
ClassMethod deletePhPerson(rowid As %Library.String = "")
{
	i rowid="" q ret=-1
	e  d
	.&sql(delete from SQLUser.dhc_phperson where php_rowid=:rowid)   
	.i SQLCODE=0  s ret=0
	.e  s ret=-1
	q ret
}

/// Description:更新药房人员代码维护
/// Creator:	hulihua
/// CreateDate:	2019-02-19
/// Table:      DHC_PHPERSON--药房人员定义表
/// Input:		更新记录ID、配药标志、发药标志、无效标志、人员ID、审核权限
/// Output:		
/// Return：	0-成功，非0-失败 
/// Others:		在原方法上仅增加注释
/// Debug:		w ##class(web.DHCOUTPHA.Config.PerCodeSqlDb).updatePhPerson("")
ClassMethod updatePhPerson(rowid As %Library.String = "", pyflag As %Library.String = "", fyflag As %Library.String = "", use As %Library.String = "", userid As %Library.String = "", AuditFlag As %Library.String = "")
{
	//s ^yunhaibao("updateperson")=rowid_","_pyflag_","_fyflag_","_use_","_userid_","_ch
	s ctloc="",ccode="",ll=0
	s phl=""
	s phl=+$p(^DHCPHPER(rowid),"^",3)
	s php=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	.s perphl="",ctloc=""
	.s perphl=+$p(^DHCPHPER(php),"^",3)
	.s ctloc=+$p(^DHCPHLOC(perphl),"^",1)
	.q:phl'=perphl
	.s ll=ll+1
	i ll=0 s ret=""
	e  d
	.&sql(update SQLUser.dhc_phperson set php_pyflag=:pyflag,php_fyflag=:fyflag,php_useflag=:use,php_mixflag=:AuditFlag  where php_rowid=:rowid)   
	.i SQLCODE=0  s ret=0
	.e  s ret=""
	q ret
}

}
