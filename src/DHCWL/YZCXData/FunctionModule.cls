Class DHCWL.YZCXData.FunctionModule Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      xss
/// CreatDate：    2014-05-05
/// Description:： 获取院区配置表的用户明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.YZCXData.FunctionModule).GetAllUserList()
ClassMethod GetAllUserList() As %String
{

	s count=0
	s hosConUserList=""
	s hosconUserDr=0 f  s hosconUserDr=$o(^DHCWL.YZCX.HosConI("User",hosconUserDr)) q:hosconUserDr=""  d
	.s hosConId=0 f  s hosConId=$o(^DHCWL.YZCX.HosConI("User",hosconUserDr,hosConId)) q:hosConId=""  d
	..;s value=##class(DHCWL.YZCX.DHCWLYZCXHosCon).%OpenId(hosConId)
	..s count=count+1
	..s userName=$p(^SSU("SSUSR",hosconUserDr),"^",2)
	..i $d(^DHCWL.YZCX.UserHosRelI("User",hosConId)) s flag="是"
	..e  s flag="否"
	..
	..s hosConUserList=hosConUserList_"{ID:"_hosConId_",hosconUserDr:'"_hosconUserDr_"',hosconUserName:'"_userName_"',flag:'"_flag_"'},"
	q hosConUserList_"^"_count
}

/// Creator：      xss
/// CreatDate：    2016-01-12
/// Description:： 通过用户得到下面的分院明细
/// Table：        DHCWL_YZCX.DHCWLYZCXHosCon
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.YZCXData.FunctionModule).GetHosconHospListByUserId("1")
ClassMethod GetHosconHospListByUserId(hosconUserDr) As %String
{
	
	n (hosconUserDr)
	q:hosconUserDr="" 0
	s count=0
	s hospList=""
	s hosConHOSPDr=0 f  s hosConHOSPDr=$o(^DHCWL.YZCX.HosConI("UserHosp",hosconUserDr,hosConHOSPDr)) q:hosConHOSPDr=""  d
	.s count=count+1
	.s hosConHospCode=$p(^CT("HOSP",hosConHOSPDr),"^",1)
	.s hosConHospName=$p(^CT("HOSP",hosConHOSPDr),"^",2)
	.s hospList=hospList_"{hospID:"_hosConHOSPDr_",hospCode:'"_hosConHospCode_"',hospDesc:'"_hosConHospName_"'},"
	q hospList_"^"_count
}

}
