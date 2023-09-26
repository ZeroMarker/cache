Import Sqluser

Class web.PMPProjectUser Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("web.PMPPermission","QueryPermission","","")

//d ##class(%ResultSet).RunQuery("web.PMPProjectUser","QueryProjectUser","m","","")

Query QueryProjectUser(ProDRHidden As %String, SSUserid As %String, tel As %String) As %Query(ROWSPEC = "TProject:%String,TUser:%String,TDictionary:%String,TDate1:%String,TTime1:%String,TDate2:%String,TTime2:%String,TPhone:%String,TRemark:%String,TRowid:%String,TProjectID:%String,TUserid:%String,TDictionaryId:%String,TEmail:%String,TNewUserName:%String,TNewUserNO:%String,TPassWord:%String")
{
}

ClassMethod QueryProjectUserExecute(ByRef qHandle As %Binary, ProDRHidden As %String, SSUserid As %String, tel As %String) As %Status
{
	;s ^zzp("QueryProjectUser")=ProDRHidden_"^"_SSUserid_"^"_tel
	Set repid=$I(^CacheTemp)
	i ProDRHidden'="" s ProDRHidden=##class(web.DHCINSUPort).GetCNCODE($tr(ProDRHidden," "),4,"")
	i SSUserid'="" s SSUserid=##class(web.DHCINSUPort).GetCNCODE($tr(SSUserid," "),4,"")
	i tel'="" s tel=$tr(tel," ")
    s ind=1 ,TDictionary="",TEmail=""
    if ProDRHidden="" d 
    .s prorowid="" f  s prorowid=$o(^PMPProject(prorowid)) q:prorowid=""  d
    ..s Rowid=0 f  s Rowid=$o(^PMPProjectUseri("0","PJU_Project_DR",prorowid,Rowid)) q:(Rowid="")  d
    ...s TProjectID=$p(^PMPProjectUser(Rowid),"^",12)  //项目名称id
    ...s TProject=$p(^PMPProject(TProjectID),"^",2)
    ...s TUserid=$p(^PMPProjectUser(Rowid),"^",1)  //userid
    ...i (TUserid'="")&&($d(^SSU("SSUSR",TUserid))) s TUser=$p(^SSU("SSUSR",TUserid),"^",2)				//用户名
    ...i TUser'="" s ssusername=##class(web.DHCINSUPort).GetCNCODE($tr(TUser," "),4,"")_TUser
    ...s TDictionaryId=$p(^PMPProjectUser(Rowid),"^",2)  //职称id
    ...i (TDictionaryId'="")&&($D(^PMPDictionary(TDictionaryId))) s TDictionary=$p(^PMPDictionary(TDictionaryId),"^",2)
    ...s TDate1=$zd($p(^PMPProjectUser(Rowid),"^",4),3)  //
    ...s TDate2=$p(^PMPProjectUser(Rowid),"^",5) ;$zd(,4)  //
    ...i TDate2'="" s TDate2=$zd(TDate2,3)
    ...s TTime1=$zt($p(^PMPProjectUser(Rowid),"^",8))  //
    ...s TTime2=$p(^PMPProjectUser(Rowid),"^",9)  ;$zt()  //
    ...i TTime2'="" s TTime2=$zt(TTime2)
    ...s TPhone=$p(^PMPProjectUser(Rowid),"^",7)  //
    ...s TRemark=$p(^PMPProjectUser(Rowid),"^",3)  //
    ...s TRowid=Rowid
    ...s TNewUserName=$p(^PMPProjectUser(Rowid),"^",22)
    ...s TNewUserNO=$p(^PMPProjectUser(Rowid),"^",23)
    ...;s TPassWord=$p(^PMPProjectUser(Rowid),"^",24)
    ...s TPassWord="***********"
    ...i TNewUserName'="" s ssusername=$g(ssusername)_##class(web.DHCINSUPort).GetCNCODE($tr(TNewUserName," "),4,"")_TNewUserName
    ...q:(SSUserid'="")&($g(ssusername)'[SSUserid)
    ...q:(tel'="")&(TPhone'[tel)
    ...s TEmail=$p(^PMPProjectUser(Rowid),"^",14)
   
    ...d OutputRow
    E  D
    .s prorowid="" f  s prorowid=$o(^PMPProject(prorowid)) q:prorowid=""  d
    ..s prodesc=$p(^PMPProject(prorowid),"^",2)
    ..s code=$p(^PMPProject(prorowid),"^",1)
    ..s prodesccode=##class(web.DHCINSUPort).GetCNCODE($tr(prodesc," "),4,"")_prodesc_code
    ..q:prodesccode'[ProDRHidden
    ..s Rowid=0 f  s Rowid=$o(^PMPProjectUseri("0","PJU_Project_DR",prorowid,Rowid)) q:(Rowid="")  d
    ...s TProjectID=$p(^PMPProjectUser(Rowid),"^",12)  //项目名称id
    ...s TProject=$p(^PMPProject(TProjectID),"^",2)
    ...s TUserid=$p(^PMPProjectUser(Rowid),"^",1)  //userid
    ...i (TUserid'="")&&($d(^SSU("SSUSR",TUserid))) s TUser=$p(^SSU("SSUSR",TUserid),"^",2)				//用户名
    ...i TUser'="" s ssusername=##class(web.DHCINSUPort).GetCNCODE($tr(TUser," "),4,"")_TUser
    ...s TDictionaryId=$p(^PMPProjectUser(Rowid),"^",2)  //职称id
    ...i (TDictionaryId'="")&&($D(^PMPDictionary(TDictionaryId))) s TDictionary=$p(^PMPDictionary(TDictionaryId),"^",2)
    ...s TDate1=$zd($p(^PMPProjectUser(Rowid),"^",4),3)  //
    ...s TDate2=$p(^PMPProjectUser(Rowid),"^",5) ;$zd(,4)  //
    ...i TDate2'="" s TDate2=$zd(TDate2,3)
    ...s TTime1=$zt($p(^PMPProjectUser(Rowid),"^",8))  //
    ...s TTime2=$p(^PMPProjectUser(Rowid),"^",9)  ;$zt()  //
    ...i TTime2'="" s TTime2=$zt(TTime2)
    ...s TPhone=$p(^PMPProjectUser(Rowid),"^",7)  //
    ...s TRemark=$p(^PMPProjectUser(Rowid),"^",3)  //
    ...s TRowid=Rowid
    ...s TNewUserName=$p(^PMPProjectUser(Rowid),"^",22)
    ...s TNewUserNO=$p(^PMPProjectUser(Rowid),"^",23)
    ...;s TPassWord=$p(^PMPProjectUser(Rowid),"^",24)
    ...s TPassWord="***********"
    ...i TNewUserName'="" s ssusername=$g(ssusername)_##class(web.DHCINSUPort).GetCNCODE($tr(TNewUserName," "),4,"")_TNewUserName
    ...q:(SSUserid'="")&($g(ssusername)'[SSUserid)
    ...q:(tel'="")&(TPhone'[tel)
    ...s TEmail=$p(^PMPProjectUser(Rowid),"^",14)
    ...d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    
	set Data=$lb(TProject,TUser,TDictionary,TDate1,TTime1,TDate2,TTime2,TPhone,TRemark,TRowid,TProjectID,TUserid,TDictionaryId,TEmail,TNewUserName,TNewUserNO,TPassWord)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryProjectUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProjectUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)               
	Quit $$$OK
}

ClassMethod QueryProjectUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryProjectUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryProjectoldUser(ProDRHidden As %String, SSUserid As %String) As %Query(ROWSPEC = "TProject:%String,TUser:%String,TDictionary:%String,TDate1:%String,TTime1:%String,TDate2:%String,TTime2:%String,TPhone:%String,TRemark:%String,TRowid:%String,TProjectID:%String,TUserid:%String,TDictionaryId:%String")
{
}

ClassMethod QueryProjectUseroldExecute(ByRef qHandle As %Binary, ProDRHidden As %String, SSUserid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1 ,TDictionary=""
    if ProDRHidden="" d 
    .s ProDRHidden="" f  s ProDRHidden=$o(^PMPProject(ProDRHidden)) q:ProDRHidden=""  d
    ..s Rowid=0 f  s Rowid=$o(^PMPProjectUseri("0","PJU_Project_DR",ProDRHidden,Rowid)) q:(Rowid="")  d
    ...s TProjectID=$p(^PMPProjectUser(Rowid),"^",12)  //项目名称id
    ...s TProject=$p(^PMPProject(TProjectID),"^",2)
    ...s TUserid=$p(^PMPProjectUser(Rowid),"^",1)  //userid
    ...i SSUserid'=""  q:TUserid'=SSUserid
    ...s TUser=$p(^SSU("SSUSR",TUserid),"^",2)				//用户名
    ...s TDictionaryId=$p(^PMPProjectUser(Rowid),"^",2)  //职称id
    ...i TDictionaryId'="" s TDictionary=$p(^PMPDictionary(TDictionaryId),"^",2)
    ...s TDate1=$zd($p(^PMPProjectUser(Rowid),"^",4),4)  //
    ...s TDate2=$p(^PMPProjectUser(Rowid),"^",5) ;$zd(,4)  //
    ...i TDate2'="" s TDate2=$zd(TDate2,4)
    ...s TTime1=$zt($p(^PMPProjectUser(Rowid),"^",8))  //
    ...s TTime2=$p(^PMPProjectUser(Rowid),"^",9)  ;$zt()  //
    ...i TTime2'="" s TTime2=$zt(TTime2)
    ...s TPhone=$p(^PMPProjectUser(Rowid),"^",7)  //
    ...s TRemark=$p(^PMPProjectUser(Rowid),"^",3)  //
    ...s TRowid=Rowid
    ...d OutputRowold
    E  D
    .s Rowid=0 f  s Rowid=$o(^PMPProjectUseri("0","PJU_Project_DR",ProDRHidden,Rowid)) q:(Rowid="")  d
    ..s TProjectID=$p(^PMPProjectUser(Rowid),"^",12)  //项目名称id
    ..s TProject=$p(^PMPProject(TProjectID),"^",2)
    ..s TUserid=$p(^PMPProjectUser(Rowid),"^",1)  //userid
    ..i SSUserid'=""  q:TUserid'=SSUserid
    ..s TUser=$p(^SSU("SSUSR",TUserid),"^",2)				//用户名
    ..s TDictionaryId=$p(^PMPProjectUser(Rowid),"^",2)  //职称id
    ..i TDictionaryId'="" s TDictionary=$p(^PMPDictionary(TDictionaryId),"^",2)
    ..s TDate1=$zd($p(^PMPProjectUser(Rowid),"^",4),4)  //
    ..s TDate2=$p(^PMPProjectUser(Rowid),"^",5) ;$zd(,4)  //
    ..i TDate2'="" s TDate2=$zd(TDate2,4)
    ..s TTime1=$zt($p(^PMPProjectUser(Rowid),"^",8))  //
    ..s TTime2=$p(^PMPProjectUser(Rowid),"^",9)  ;$zt()  //
    ..i TTime2'="" s TTime2=$zt(TTime2)
    ..s TPhone=$p(^PMPProjectUser(Rowid),"^",7)  //
    ..s TRemark=$p(^PMPProjectUser(Rowid),"^",3)  //
    ..s TRowid=Rowid
    ..d OutputRowold
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowold
	set Data=$lb(TProject,TUser,TDictionary,TDate1,TTime1,TDate2,TTime2,TPhone,TRemark,TRowid,TProjectID,TUserid,TDictionaryId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryProjectUseroldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProjectUseroldExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)               
	Quit $$$OK
}

ClassMethod QueryProjectUseroldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryProjectUseroldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod insertProjectUser(ProDRHidden As %String, SSUserid As %String, dicid As %String, phone As %String, date1 As %String, time1 As %String, date2 As %String, time2 As %String, remark As %String) As %String
{
	s userid=%session.Get("LOGON.USERID")  i userid=""  s userid=1
	if date1'="" s date1=$zdh(date1,4)
	if date2'="" s date2=$zdh(date2,4)
	if time1'="" s time1=$zth(time1)
	if time2'="" s time2=$zth(time2)
	
	set Date = +$h
	set Time = $p($h,",",2)
	;s ^shen2=ProDRHidden_"^"_SSUserid_"^"_dicid_"^"_phone_"^"_date1_"^"_time1_"^"_date2_"^"_time2_"^"_remark
	//&sql(insert into SQLUser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time) values (:PermissDR,:ssuser,"Y",:Date,:Time))
 	&sql(INSERT INTO SQLUser.PMP_ProjectUser (PJU_User_DR, PJU_Profession_DR, PJU_Remark, PJU_StDate, PJU_EnDate, PJU_Updateser_DR, PJU_Tel, PJU_StTime, PJU_EnTime, PJU_Date, PJU_Time, PJU_Project_DR, PJU_Standby)
	VALUES (:SSUserid, :dicid, :remark, :date1, :date2, :userid, :phone, :time1, :time2, :Date, :Time, :ProDRHidden, ""))
 	Quit SQLCODE
}

ClassMethod updateProjectUser(ProDRHidden As %String, SSUserid As %String, dicid As %String, phone As %String, date1 As %String, time1 As %String, date2 As %String, time2 As %String, remark As %String, ProjectId As %String) As %String
{
	s userid=%session.Get("LOGON.USERID")  i userid=""  s userid=1
	;s ^zzp("data")=date1_"^"_date2_"^"_time1_"^"_time2
	if (date1'="")&(date1'=" ") s date1=$zdh(date1,4)
	e  s date1=""
	if (date2'="")&(date2'=" ") s date2=$zdh(date2,4)
	e  s date2=""
	if (time1'="")&(time1'=" ") s time1=$zth(time1)
	e  s time1=""
	if (time2'="")&(time2'=" ") s time2=$zth(time2)
	e  s time2=""
	
	set Date = +$h
	set Time = $p($h,",",2)
	;s ^sshen=ProDRHidden_"^"_SSUserid_"^"_dicid_"^"_phone_"^"_date1_"^"_time1_"^"_date2_"^"_time2_"^"_remark_"^"_ProjectId
	//&sql(insert into SQLUser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time) values (:PermissDR,:ssuser,"Y",:Date,:Time))
 	&sql(UPDATE SQLUser.PMP_ProjectUser set PJU_User_DR=:SSUserid,PJU_Profession_DR=:dicid,PJU_Remark=:remark,PJU_StDate=:date1,PJU_EnDate=:date2,PJU_Updateser_DR=:userid, PJU_Tel=:phone, PJU_StTime=:time1, PJU_EnTime=:time2, PJU_Date=:Date, PJU_Time=:Time, PJU_Project_DR=:ProDRHidden where PJU_Rowid=:ProjectId)
	Quit SQLCODE
}

//获取项目放大镜

Query LookUpDictionaryDesc(DicId As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "PJT_Rowid:%String,PJT_Desc:%String")
{
SELECT DTY_Rowid,DTY_Desc
 FROM	SQLUser.PMP_Dictionary
 WHERE	((%ALPHAUP DTY_Desc [ %ALPHAUP :DicId) OR (:DicId IS NULL) and DTY_Flag="Profession")
}

ClassMethod updatePermission(Rowid As %String, levelName As %String, ProDRHidden As %String) As %String
{
	if (Rowid '="") {
		set object=##class(User.PMPPermission).%OpenId(Rowid)
		set object.PERDesc = levelName
		set object1=##class(User.PMPProject).%OpenId(ProDRHidden)
		set object.PERProjectDR = object1
	
		set sc=object.%Save()
 		quit object.%Id()
	}
}

//获取项目放大镜

Query LookUpModuleDesc(ModeDesc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "MODE_Rowid:%String,MODE_Desc:%String")
{
SELECT MODE_Rowid,MODE_Desc
 FROM	SQLUser.PMP_Module
 WHERE	((%ALPHAUP MODE_Desc [ %ALPHAUP :ModeDesc) OR (:ModeDesc IS NULL))
}

Storage Default
{
<Data name="PMPProjectUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMPProjectUserD</DataLocation>
<DefaultData>PMPProjectUserDefaultData</DefaultData>
<IdLocation>^web.PMPProjectUserD</IdLocation>
<IndexLocation>^web.PMPProjectUserI</IndexLocation>
<StreamLocation>^web.PMPProjectUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
