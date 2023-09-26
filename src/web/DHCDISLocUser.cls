Class web.DHCDISLocUser Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yuliping
/// CreatDate：    2017-01-09
/// Description:   分页显示 配送人员关联科室字典维护
/// Table：        DHC_DisLocUser
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISLocUser).ListFailReason("1","10","","")
ClassMethod ListFailReason(page = 1, rows = 10, LULocDr, LUUserDr)
{
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s LUid=""
	 f  s LUid=$o(^DHCDISLU(LUid))  q:LUid=""  d
	 .q:LUid=0
	 .s msg=$g(^DHCDISLU(LUid))
	 .q:msg=""
	 .s locdr=$p(msg,"^",1)
	 .s userdr=$p(msg,"^",2)
	 .s ActiveFlag=$p(msg,"^",3)
	 .s status=$p(msg,"^",4)
	 .i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",2)
	 .i userdr'="" s userdesc=$P($g(^SSU("SSUSR",userdr)),"^",2)
	 .s tmp=LUid_"^"_locdesc_"^"_userdesc_"^"_ActiveFlag_"^"_status_"^"_locdr_"^"_userdr
	 .q:(LULocDr'="")&(locdr'=LULocDr)
	 .q:(LUUserDr'="")&(userdr'=LUUserDr)
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LULocDr^LUUserDr^LUActiveFlag^LUStatus^LocDr^UserDr",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-09
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISLocUser).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-09
/// Description:： 下拉列表显示 空闲/忙碌
/// Return
/// d ##class(web.DHCDISLocUser).listIsActive()
ClassMethod ListStatActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","0").Put("text","空闲"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","1").Put("text","忙碌"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Description:获得科室列表
/// Creator:     yuliping
/// CreateDate:  2017-01-09
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocUser).GetLoc("2","")   
ClassMethod GetLoc(HospID As %String, q As %String = "")
{
	s Count=0
	s q=$ZCONVERT(q,"U")
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocType=$p(^CTLOC(LocId),"^",13)   //sufan 2017-11-28  增加科室类型
	.q:LocType'="W"
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s LocContactName = $p(^CTLOC(LocId),"^",43)
	.q:($f(LocContactName,q)=0)&&($f(LocDesc,q)=0)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description:获得科室列表
/// Creator:     yuliping
/// CreateDate:  2017-01-10
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocUser).GetSSUser("1","","")   
ClassMethod GetSSUser1(HospID As %String, LocId As %String, search As %String)
{
	
	;s ^SUFAN("22")=HospID_"#"_LocId
	s Count=0
	s Hosp="",locid=""
	s userId=0
	f  s userId = $o(^SSU("SSUSR",userId)) q:userId=""  d
	.s FromDate=$p(^SSU("SSUSR",userId),"^",96)
	.s EndDate=$p(^SSU("SSUSR",userId),"^",97)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^SSU("SSUSR",userId),"^",90)
	.s locid=$p(^SSU("SSUSR",userId),"^",4)
	.q:locid=""
	.;q:((LocId'=locid)&(LocId'=""))			//sufan 注释，人员取默认登录科室为后勤管理科的人员
	.s LocDesc=$p(^CTLOC(locid),"^",2)			//取科室描述
	.b   //LocDesc
	.q:(LocDesc'="")&(LocDesc'="后勤管理配送组")
	.s UserName = $p(^SSU("SSUSR",userId),"^",2)
	.q:(search'="")&(UserName'[$$ALPHAUP^SSUTIL4(search))
	.s Count=Count+1
	.s tmp = userId_"^"_UserName
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// w ##class(web.DHCDISLocUser).GetSSUser(2)
ClassMethod GetSSUser(HospID As %String, LocId As %String = "", q As %String = "")
{
	s CodeFlag=$$ALPHAUP^SSUTIL4(q)
	s Count=0,Num=0
	s Hosp="",locid=""
	s pid=..NewPid()
	k ^TMP("DHCDIS","web.DHCDISLocUser","GetSSUser",pid)
	s userId=0
	f  s userId = $o(^SSU("SSUSR",userId)) q:userId=""  d
	.s FromDate=$p(^SSU("SSUSR",userId),"^",96)
	.s EndDate=$p(^SSU("SSUSR",userId),"^",97)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s locid=$p(^SSU("SSUSR",userId),"^",4)
	.q:locid=""
	.s LocDesc=$p(^CTLOC(locid),"^",2)			//取科室描述
	.s UserName = $p(^SSU("SSUSR",userId),"^",2)
	.s QuitCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"")
	.s QuitCode=QuitCode_UserName
	.q:(CodeFlag'="")&&(QuitCode'[CodeFlag)
	.s NameCode=##class(web.DHCINSUPort).GetCNCODE(UserName,4,"^")
	.s FirCode=$p(NameCode,"^",1)
	.s CodeAII=$ASCII(FirCode)
	.s Num=Num+1
	.s ^TMP("DHCDIS","web.DHCDISLocUser","GetSSUser",pid,CodeAII,Num)=userId_"^"_UserName
	
	w "["
	s CodeNum=0
	f  s CodeNum=$o(^TMP("DHCDIS","web.DHCDISLocUser","GetSSUser",pid,CodeNum)) q:CodeNum=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCDIS","web.DHCDISLocUser","GetSSUser",pid,CodeNum,index))  q:index=""  d
	..s mdata=^(index)
	..s EsUserId=$p(mdata,"^",1)
	..s EsUserName=$p(mdata,"^",2)
	..s Count=Count+1
	..s tmp = EsUserId_"^"_EsUserName
	..i Count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	k ^TMP("DHCDIS","web.DHCDISLocUser","GetSSUser",pid)
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-10
/// Description:： 配送人员关联科室字典
/// Table：       DHC_DisLocUser
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisLocUser).%DeleteId(Id)
	  q 0
}

/// w ##class(web.DHCDISLocUser).SaveUpdLevReson()
ClassMethod SaveUpdLevReson(params)
{
  
  	s ^temptest("666")=params
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   保存或者新增 陪送未完成原因字典
/// Table：        DHCDisFailReason
/// Input：	       FRCode：代码
///                FRDesc：描述
///                FRActiveFlag：是否可用             
///                FRHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败 14^3^Y^0^0^0^0
/// W ##Class(web.DHCDISLocUser).SaveOrUpdate("更新^1^Y^0^0^1^0")
/// W ##Class(web.DHCDISLocUser).SaveOrUpdate("5^innurse^Y^0^12^1^3")
ClassMethod SaveOrUpdate(str)
{
		
  		 s LULocDr=$p(str,"^",1)
		 s LUUserDr=$p(str,"^",2)
		 s LUActiveFlag=$p(str,"^",3)
		 s LUStatus=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 s LULoc=$p(str,"^",6)
		 s LUUser=$p(str,"^",7)
		 i +LULocDr=0 s LULocDr=LULoc 
		 i +LUUserDr=0 s LUUserDr=LUUser
		 Q:(+LULocDr=0)||(+LUUserDr=0) -3
		 i +ID=0 
		 {
			 s obj=##class(User.DHCDisLocUser).%New()
			 s flag=0
			 i ($d(^DHCDISLU(0,"Loc",LULocDr)))  d
			 .s rowid=""
			 .f  s rowid=$o(^DHCDISLU(0,"Loc",LULocDr,rowid)) q:rowid=""  d
			 ..s userid=$p(^DHCDISLU(rowid),"^",2)
			 ..i (userid=LUUserDr) s flag=1
			 q:flag=1 1
		 }else{
			 s obj=##class(User.DHCDisLocUser).%OpenId(ID)
			 s isIN=0
			 i $d(^DHCDISLU(0,"Loc",LULocDr)) d
			 .s rowid=""
			 .s rowid=$O(^DHCDISLU(0,"Loc",LULocDr,rowid)) q:rowid=""  d
			 ..q:rowid=ID	
			 ..s user=$p(^DHCDISLU(rowid),"^",2) 
			 ..q:user'=LUUserDr
			 ..s isIN=1
			 q:isIN=1 1
		 }
		 s obj.LULocDr=##class(User.CTLoc).%OpenId(LULocDr)
		 s obj.LUUserDr=##class(User.SSUser).%OpenId(LUUserDr)
		 s obj.LUActiveFlag=LUActiveFlag
	 	 s obj.LUStatus=LUStatus
	 	 s obj.LUWorkload=0
	     s sc=obj.%Save()   

		 i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-16
/// Description:   分页显示 配送人员关联科室Bootstrap界面
/// Table：        DHC_DisLocUser
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISLocUser).ListLocUser("1","10","","")
ClassMethod ListLocUser(LULocDr, LUUserDr)
{
	
	
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s LUid=""
	 f  s LUid=$o(^DHCDISLU(LUid))  q:LUid=""  d
	 .q:LUid=0
	 .s msg=$g(^DHCDISLU(LUid))
	 .q:msg=""
	 .s locdr=$p(msg,"^",1)
	 .s userdr=$p(msg,"^",2)
	 .s ActiveFlag=$p(msg,"^",3)
	 .s status=$p(msg,"^",4)
	 .i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",1)
	 .i userdr'="" s userdesc=$P(^SSU("SSUSR",userdr),"^",2)
	 .i userdr'="" s userinit=$P(^SSU("SSUSR",userdr),"^",1)
	 .s tmp=locdesc_"^"_userinit_"^"_userdesc_"^"_ActiveFlag_"^"_LUid
	 .q:(LULocDr'="")&(locdr'=LULocDr)
	 .q:(LUUserDr'="")&(userdr'=LUUserDr)
	 .s count=count+1
	 .w $case(count,1:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("LULocDr^LUUserInit^UserDesc^LUActiveFlag^ID",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-17
/// Description:   陪送其它项目名称
/// Table：        DHC_DisLocItem
/// Return：     
/// w ##class(web.DHCDISLocUser).ListItemCode()
ClassMethod ListItemCode()
{
	
	
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 s LiId=""
	 f  s LiId=$o(^DHCDISLI(LiId))  q:LiId=""  d
	 .q:LiId=0
	 .s msg=$g(^DHCDISLI(LiId))
	 .q:msg=""
	 .s itemcode=$p(msg,"^",1)
	 .q:$p(msg,"^",7)'=9
	 .s tmp=LiId_"^"_itemcode
	 .s count=count+1
	 .i count=1 d
	 ..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 .e  d
	 ..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-05-08
/// Description:   陪送其它项目名称
/// Table：        DHC_DisLocItem
/// Return：     
/// w ##class(web.DHCDISLocUser).ListItemCodeDs()
ClassMethod ListItemCodeDs()
{
	
	
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 s LiId=""
	 f  s LiId=$o(^DHCDISLI(LiId))  q:LiId=""  d
	 .q:LiId=0
	 .s msg=$g(^DHCDISLI(LiId))
	 .q:msg=""
	 .s itemcode=$p(msg,"^",1)
	 .q:$p(msg,"^",7)=9
	 .s tmp=LiId_"^"_itemcode
	 .s count=count+1
	 .i count=1 d
	 ..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 .e  d
	 ..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "]"
	 q ""
}

/// Description:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCDIS("DHCDISEscortArrage"))
}

}
