/// Creator:         wk
/// CreatDate:       2018-01-11
/// Description:		院长查询配置数据处理方法
Class web.DHCWL.V1.YZCXData.FunctionModule Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取用户信息
/// Table：        
/// Input：       
/// Output：      
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.FunctionModule","GetUserComboQuery")
/// 
Query GetUserComboQuery(filterUser As %String) As websys.Query(ROWSPEC = "id:%String:序号,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetUserComboQueryExecute(ByRef qHandle As %Binary, filterUser As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s sql="select SSUSR_RowId,SSUSR_Name,SSUSR_Initials from SS_User"
 	s rs=##class(%Library.ResultSet).%New()
 	d rs.Prepare(sql)
 	d rs.Execute()
	s upFilterUser=$zcvt(filterUser,"U")
 	While(rs.Next()){
	 	s id=rs.Data("SSUSR_RowId")
	 	s desc=rs.Data("SSUSR_Initials")
	 	s name=rs.Data("SSUSR_Name")
	 	continue:((upFilterUser'="")&&(id'[upFilterUser)&&($zcvt(desc,"U")'[upFilterUser))&&($zcvt(name,"U")'[upFilterUser)
	 	continue:$d(^DHCWL.YZCX.HosConI("User",id))
	 	s ^CacheTemp(repid,ind)=$lb(id,name)
		s ind=ind+1
 	}
	
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取所有院区
/// Table：        
/// Input：       
/// Output：      
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.YZCXData.FunctionModule","GetAllHosQuery")
/// 
Query GetAllHosQuery(filterInfor As %String) As websys.Query(ROWSPEC = "allHosID:%String:序号,allHosCode:%String:编码,allHosDesc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetAllHosQueryExecute(ByRef qHandle As %Binary, filterInfor As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s sql="select HOSP_RowId,HOSP_Desc,HOSP_Code from CT_Hospital"
 	s rs=##class(%Library.ResultSet).%New()
 	d rs.Prepare(sql)
 	d rs.Execute()
 	s upFilterInfor=$zcvt(filterInfor,"U")
 	While(rs.Next()){
	 	s ID=rs.Data("HOSP_RowId")
	 	s code=rs.Data("HOSP_Code")
	 	s desc=rs.Data("HOSP_Desc")
	 	continue:$d(^DHCWL.YZCX.UserHosRelI("UserHos",filterInfor,ID))
	 	//continue:((upFilterInfor'="")&&(ID '[ upFilterInfor)&&($zcvt(code,"U") '[upFilterInfor)&&($zcvt(desc,"U") '[ upFilterInfor))
	 	s ^CacheTemp(repid,ind)=$lb(ID,code,desc)
		s ind=ind+1
 	}
	
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取所有院区
/// Table：        
/// Input：       
/// Output：      
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.FunctionModule","GetHosByUserQuery")
/// 
Query GetHosByUserQuery(userID As %String) As websys.Query(ROWSPEC = "ID:%String:ID,hosConHospDr:%String:医院ID,hosConHospCode:%String:医院编码,hosConHospDesc:%String:医院描述") [ SqlProc ]
{
}

ClassMethod GetHosByUserQueryExecute(ByRef qHandle As %Binary, userID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:userID="" $$$OK
	s sql="select ID,UHR_Hosp_Dr from DHCWL_YZCX.DHCWLYZCXUserHosRel where UHR_User_Dr="_userID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute() 
	While(rs.Next()){
		s id=rs.Data("UHR_Hosp_Dr")
		s code=$p($g(^CT("HOSP",id)),"^",1)
		s desc=$p($g(^CT("HOSP",id)),"^",2)
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),id,code,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取院区配置表的用户明细
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数    
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.FunctionModule","GetAllUserQuery")
/// 
Query GetAllUserQuery() As websys.Query(ROWSPEC = "ID:%String:ID,hosconUserDr:%String:用户ID,hosconUserName:%String:用户名称,flag:%String:是否关联病区标志") [ SqlProc ]
{
}

ClassMethod GetAllUserQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s count=0
	s hosConUserList=""
	s hosconUserDr=0 f  s hosconUserDr=$o(^DHCWL.YZCX.HosConI("User",hosconUserDr)) q:hosconUserDr=""  d
	.s hosConId=0 f  s hosConId=$o(^DHCWL.YZCX.HosConI("User",hosconUserDr,hosConId)) q:hosConId=""  d
	..s count=count+1
	..s userName=$p(^SSU("SSUSR",hosconUserDr),"^",2)
	..i $d(^DHCWL.YZCX.UserHosRelI("User",hosConId)) s flag="是"
	..e  s flag="否"
	..s hosConUserList=hosConUserList_"{ID:"_hosConId_",hosconUserDr:'"_hosconUserDr_"',hosconUserName:'"_userName_"',flag:'"_flag_"'},"
	..s ^CacheTemp(repid,ind)=$lb(hosConId,hosconUserDr,userName,flag)
	..s ind=ind+1
	Quit $$$OK
}

}
