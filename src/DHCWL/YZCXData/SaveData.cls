Class DHCWL.YZCXData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      xss
/// CreatDate：    2016-01-13
/// Description:： 院区配置表增加用户信息
/// Table：        DHCWL_YZCX.DHCWLYZCXHosCon
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.YZCXData.SaveData).SaveUser(.dim)
/// 
ClassMethod SaveUser(ByRef dim) As %String
{
	n (dim,%session)
	;s dim("hosconUserDr")="7"
	s hosconUserDr=$g(dim("hosconUserDr")) 
	s id=..GetHosconidByUser(hosconUserDr)
	i id'="" q "该用户已添加！"
	s date=+$h
	&sql(INSERT INTO DHCWL_YZCX.DHCWLYZCXHosCon(HosCon_User_Dr,HosCon_CUDate) values(:hosconUserDr,:date))
	s id=+$g(%ROWID)
	s result="failure"
	i SQLCODE=0  d  
	.s result="ok"
    q result
}

/// Creator：      xss
/// CreatDate：    2016-01-13
/// Description:： 删除配置用户
/// Table：        DHCWL_YZCX.DHCWLYZCXHosCon
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.YZCXData.SaveData).deleteUser("11")
/// 删除配置 需要同时删除相应的分院配置信息
ClassMethod deleteUser(ID) As %String
{
	n (ID)
	Tstart
	s id=$g(ID)
	s flag=0
	q:'$d(^DHCWL.YZCX.HosConD(id)) "请选择要删除的行"
	s uhrId="" f  s uhrId=$o(^DHCWL.YZCX.UserHosRelI("User",id,uhrId)) q:uhrId=""  d
	.
	.s excValueObj=##class(DHCWL.YZCX.UserHosRel).%OpenId(uhrId)
	.s sc=##class(DHCWL.YZCX.UserHosRel).%DeleteId(uhrId)
	.i sc'=1  d 
	..s flag=flag+1
	s exc=##class(DHCWL.YZCX.HosCon).%OpenId(id)
	s sc=##class(DHCWL.YZCX.HosCon).%DeleteId(id)
	i (sc=1)&&(flag=0) d
	.s result="ok"
	e  s result="failure"
	i result="failure" Trollback
	e  TCommit
	q $g(result)
}

/// Creator：      xss
/// CreatDate：    2016-01-13
/// Description:： 院区配置表保存用户分院信息
/// Table：        DHCWL_YZCX.DHCWLYZCXHosCon
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.YZCXData.SaveData).SaveHosp(.dim)
/// 
ClassMethod SaveHosp(ByRef dim) As %String
{
	n (dim,%session)
	s hosconUserDr=$g(dim("hosconUserDr")) 
	s hospPara=$g(dim("selecthospPara"))
	s nowDate=+$h
	s flag=0
	s result="failure"
	f count=1:1:$l(hospPara,",") d
	.s hospId=$p(hospPara,",",count)
	.q:$d(^DHCWL.YZCX.UserHosRelI("UserHos",hosconUserDr,hospId))
	.&sql(INSERT INTO DHCWL_YZCX.DHCWLYZCXUserHosRel(UHR_User_Dr,UHR_Hosp_Dr,UHR_CUDate) values(:hosconUserDr,:hospId,:nowDate))
	.i SQLCODE'=0  d  
	..s flag=$g(flag)+1
	i flag=0 s result="ok"
	
    q result
}

/// Creator：      xss
/// CreatDate：    2016-01-15
/// Description:： 删除配置分院
/// Table：        DHCWL_YZCX.DHCWLYZCXHosCon
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.YZCXData.SaveData).deleteHosp(.dim)
/// 删除院配置信息
ClassMethod deleteHosp(ByRef dim) As %String
{
	n (dim,%session)
	s result="failure"
	s id=$g(dim("hosconUserDr")) 
	s excValueObj=##class(DHCWL.YZCX.UserHosRel).%OpenId(id)
	s sc=##class(DHCWL.YZCX.UserHosRel).%DeleteId(id)
	q:sc'=1 
	s result="ok"
	q result
}

/// w ##class(DHCWL.YZCXData.SaveData).GetHosconidByUser("1")
ClassMethod GetHosconidByUser(hosconUserDr) As %String
{
	
	n (hosconUserDr)
	q:hosconUserDr="" ""
	s id=$o(^DHCWL.YZCX.HosConI("User",hosconUserDr,""))
	q id
}

}
