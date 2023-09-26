/// 名称: DHCMed.CCService.SubjectDicSrv
/// 描述: DHCMed.CCService.SubjectDicSrv配置表的常用操作
/// 编写者：wuwj
/// 编写日期: 2010-04-19
Class DHCMed.CCService.SubjectDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  根据SDCode获取Rowid
/// Table：       DHCMed.CC.SubjectDic
/// Input：       SDCode
/// Return：      返回配置值的Id
/// Index IndexSDCode On SDCode;
/// w ##class(DHCMed.CCService.SubjectDicSrv).GetIdBySDCode("")
ClassMethod GetIdBySDCode(SDCode As %String) As %String
{
	new (SDCode)
	set val=""
	quit:SDCode="" val
	s SDCode=" "_SDCode
	s SDCode=$ZCVT(SDCode,"U") //转换为大写
	quit:'$d(^DHCMed.CC.SubjectDicI("IndexSDCode",SDCode)) val

	set id=$o(^DHCMed.CC.SubjectDicI("IndexSDCode",SDCode,""))
	quit id
}

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  查询所有的主题字典
/// Table：       DHCMed.CC.SubjectDic
/// Input：       
/// output:       所有的主题字典          
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.CCService.SubjectDicSrv","QrySubjectDic")
Query QrySubjectDic() As %Query(ROWSPEC = "myid:%String,SDCode:%String,SDDesc:%String,SDInPut:%String,SDOutPut:%String,SDMethodName:%String,SDResume:%String")
{
}

ClassMethod QrySubjectDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s myid=$o(^DHCMed.CC.SubjectDicD(""))
 	while (myid'="")
 	{
	s myconfig=##class(DHCMed.CC.SubjectDic).%OpenId(myid)
	if ($IsObject(myconfig))
	{    
	    
		s SDCode=myconfig.SDCode
		s SDDesc=myconfig.SDDesc
		s SDInPut=myconfig.SDInPut
		s SDOutPut=myconfig.SDOutPut
		s SDMethodName=myconfig.SDMethodName	// update by liuyh 2010-05-13 添加新字段
		s SDResume=myconfig.SDResume
		set Data=$lb(myid,SDCode,SDDesc,SDInPut,SDOutPut,SDMethodName,SDResume)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
      
		  } 	
	     s myid=$o(^DHCMed.CC.SubjectDicD(myid))
	 	}
	Quit $$$OK
}

ClassMethod QrySubjectDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubjectDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySubjectDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubjectDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
