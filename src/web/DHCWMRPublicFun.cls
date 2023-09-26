Import SQLUser

/// 创建人：吴群科
/// 公共函数，为病案系统使用
Class web.DHCWMRPublicFun Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 58;

ClassMethod GetUserInfo(UserID)
{
	//***************************************
	//功能说明：获取登陆用户的信息
	//入参：UserID
	//出参：
	//调试：w ##class(web.DHCWMRPublicFun).GetUserInfo("入参")
	//***************************************
	n (UserID)
	q:UserID="" ""
	s s=UserID_"^"_$g(^SSU("SSUSR",UserID))
	q s
}

ClassMethod GetLocInfo(LocID)
{
	//***************************************
	//功能说明：获取登陆科室的信息
	//入参：LocID
	//出参：
	//调试：w ##class(web.DHCWMRPublicFun).GetLocInfo("入参")
	//***************************************
	n (LocID)
	q:LocID="" ""
	s s=LocID_"^"_$g(^CTLOC(LocID))
	q s
}

ClassMethod BuildData(repid As %String, ind As %String, s As %String)
{
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod QueryUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryUserListExecute(ByRef qHandle As %Binary, cUserName As %String, Id As %String, Flg As %String, AddStr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    k ^DHCGetUserList($j)
    s Flg=+Flg
    s Id=+Id
    q:((Flg'=0)&&(Id=0)) $$$OK
    //全部医护人员
    i Flg=0 d
    .s Rowid=0
    .f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
    ..s UserName=$p(^SSU("SSUSR",Rowid),"^",2)
    ..s UserGroup=$p(^SSU("SSUSR",Rowid),"^",5)
    ..s ^DHCGetUserList($j,UserName,Rowid)=Rowid_"^"_UserName
	//部门组下医护人员
    i Flg=1 d
    .s DepId=+Id
    .q:DepId=0
    .s LocId=0
    .f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
    ..q:'$d(^CTLOC(LocId))
    ..q:DepId'=$p(^CTLOC(LocId),"^",19)
    ..d GetUserListByLoc(LocId)
    //科室下医护人员
    i Flg=2 d
    .s LocId=+Id
    .q:LocId=0
    .d GetUserListByLoc(LocId)
    //按人员名称排序输出
    i AddStr'="" d
    .s Tmp1=$p(AddStr,"^",1)
    .s Tmp2=$p(AddStr,"^",2)
    .s s=Tmp1_"^"_Tmp2
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    i $d(^DHCGetUserList($j))'=0 d
    .s TmpName=""
    .f  s TmpName=$o(^DHCGetUserList($j,TmpName))  q:TmpName=""  d
    ..q:((cUserName'="")&&(TmpName'[cUserName))
    ..s TmpId=""
    ..f  s TmpId=$o(^DHCGetUserList($j,TmpName,TmpId))  q:TmpId=""  d
    ...s s=$g(^DHCGetUserList($j,TmpName,TmpId))
    ...d ..BuildData(repid,ind,s)
    ...s ind=ind+1
    K ^DHCGetUserList($j)
    q $$$OK

GetUserListByLoc(LocId)
    s id=0
    f  s id=$o(^RB("RES",0,"CTLOC",LocId,id)) q:id=""  d
    .s CTPCPId=$p(^RB("RES",id),"^",2)
    .s CTPCPId=+CTPCPId
    .q:CTPCPId=0
    .s SSUserActive=$P(^CTPCP(CTPCPId,1),"^",9)
    .q:SSUserActive'="Y"
    .s SSUserId=""
    .s SSUserId=$o(^SSU("SSUSR",0,"CTPCP",CTPCPId,SSUserId))
    .s SSUserId=+SSUserId
    .q:SSUserId=0
    .s ssInitials=$p(^SSU("SSUSR",SSUserId),"^",1)
    .q:ssInitials=""
    .s SSUserName=$p(^SSU("SSUSR",SSUserId),"^",2)
    .q:SSUserName=""
    .s ^DHCGetUserList($j,SSUserName,SSUserId)=SSUserId_"^"_SSUserName
    q
}

ClassMethod QueryUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserListExecute ]
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

/// 根据科室或部门查询医护人员列表
/// Flg（0:全部，1:科室,2:部门）
Query QueryUserList(cUserName As %String, Id As %String, Flg As %String, AddStr As %String) As %Query(ROWSPEC = "Rowid:%String,UserName:%String")
{
}

ClassMethod QuerySSUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySSUserExecute(ByRef qHandle As %Binary, cNo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s len=$l(cNo)
    s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
    .s UserInitials=$p(^SSU("SSUSR",Rowid),"^",1)
    .q:((cNo'="")&&(cNo'=$e(UserInitials,1,len)))
    .s UserName=$p(^SSU("SSUSR",Rowid),"^",2)
    .s s=Rowid_"^"_UserInitials_"^"_UserName
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    q $$$OK
}

ClassMethod QuerySSUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSUserExecute ]
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

/// 根据医护人员工号查询医护人员列表
Query QuerySSUser(cNo As %String) As %Query(ROWSPEC = "Rowid:%String,UserInitials:%String,UserName:%String")
{
}

ClassMethod QueryUserByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryUserByNameExecute(ByRef qHandle As %Binary, Name As %String, Ctloc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCWMRPublicFun","QueryUserByName","zh","")
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;q:Name="" $$$OK
	s Name=$$ALPHAUP^SSUTIL4(Name)
	/*
    s Rowid=$$GetDocByNameLoop(Name)
    s flag=$$CheckDoctor(Rowid,"",Name,Ctloc)
    i flag=1 d
    .s UserCode=$p($g(^SSU("SSUSR",+Rowid)),"^",1)
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserLocRowid=+$p($g(^SSU("SSUSR",+Rowid)),"^",4)
    .s UserLoc=""
    .s:UserLocRowid'=0 UserLoc=$p($g(^CTLOC(+UserLocRowid)),"^",2)
    .s:UserLoc["-" UserLoc=$p(UserLoc,"-",2)
    .s s=Rowid_"^"_UserCode_"^"_UserName_"^"_UserLoc
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    
    s tmpName=Name
    f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
    .s Rowid=$$GetDocByNameLoop(tmpName)
    .s flag=$$CheckDoctor(Rowid,"","",Ctloc)
    .i flag=1 d
    ..s UserCode=$p($g(^SSU("SSUSR",+Rowid)),"^",1)
    ..s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    ..s UserLocRowid=+$p($g(^SSU("SSUSR",+Rowid)),"^",4)
    ..s UserLoc=""
    ..s:UserLocRowid'=0 UserLoc=$p(^CTLOC(+UserLocRowid),"^",2)
    ..s:UserLoc["-" UserLoc=$p(UserLoc,"-",2)
    ..s s=Rowid_"^"_UserCode_"^"_UserName_"^"_UserLoc
    ..d ..BuildData(repid,ind,s)
    ..s ind=ind+1
    */
    s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
    .q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
    .s UserCode=$p($g(^SSU("SSUSR",+Rowid)),"^",1)
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserLocRowid=+$p($g(^SSU("SSUSR",+Rowid)),"^",4)
    .s UserPinYin=$p($g(^SSU("SSUSR",+Rowid)),"^",11)
    .;q:(Code'="")&&($e(UserCode,1,$l(Code))'=Code)
    .q:(Name'="")&&($e(UserName,1,$l(Name))'=Name)&&($e(UserPinYin,1,$l(Name))'=Name)
    .q:(Ctloc'="")&(UserLocRowid'=Ctloc)
    .s UserLoc=""
    .s:UserLocRowid'=0 UserLoc=$p(^CTLOC(+UserLocRowid),"^",2)
    .s:UserLoc["-" UserLoc=$p(UserLoc,"-",2)
    .s s=Rowid_"^"_UserCode_"^"_UserName_"^"_UserLoc
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    
    Quit $$$OK
    
GetDocByNameLoop(Name)
   n (Name)
   ;^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),{SSUSR_RowId}) 
   s Rowid=""
   q:'$d(^SSU("SSUSR",0,"SSUSR_Name",Name)) Rowid
   s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,Rowid))
   q Rowid
CheckDoctor(ssusr,Code,Name,Ctloc)
    n (ssusr,Code,Name,Ctloc)
    ;q 1
    s flag=""
    q:ssusr="" flag
    q:'$d(^SSU("SSUSR",+ssusr)) flag
    s usrCode=$p($g(^SSU("SSUSR",+ssusr)),"^",1)
    s usrName=$p($g(^SSU("SSUSR",+ssusr)),"^",2)
    s usrCtloc=$p($g(^SSU("SSUSR",+ssusr)),"^",4)
    s usrCareProvDR=$p($g(^SSU("SSUSR",+ssusr)),"^",14)
    q:usrCareProvDR="" flag
    ;w !,Code_Name_Ctloc_"/"_usrCode_usrName_usrCtloc_usrCareProvDR
    q:(Code'="")&(usrCode'[Code) flag
    q:(Name'="")&(usrName'[Name) flag
    q:(Ctloc'="")&(usrCtloc'[Ctloc) flag
    ;w !,"----"_usrCareProvDR
    s flag=1
    q flag
}

ClassMethod QueryUserByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserByNameExecute ]
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

/// 通过姓名/工号查询医护人员列表
/// w ##Class(%ResultSet).RunQuery("web.DHCWMRPublicFun","QueryUserByName","","")
Query QueryUserByName(Name As %String, Ctloc As %String) As %Query(ROWSPEC = "UserRowid:%String,UserCode:%String,UserName:%String,UserLoc:%String")
{
}

ClassMethod QueryLocByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLocByNameExecute(ByRef qHandle As %Binary, Desc As %String, Type As %String) As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.DHCWMRPublicFun","QueryLocByName","mn","")
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^CTLOC(0,"Desc",$$ALPHAUP({CTLOC_Desc}),{CTLOC_RowID})
	q:Desc="" $$$OK
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=$$GetLocByDescLoop(Desc)
	s flag=$$CheckLoc(Rowid,Type)
	i flag=1 d
	.s LocCode=$p(^CTLOC(Rowid),"^",1)
	.s LocDesc=$p(^CTLOC(Rowid),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s s=Rowid_"^"_LocCode_"^"_LocDesc
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
    
    s tmpDesc=Desc
    f  s tmpDesc=$o(^CTLOC(0,"Desc",tmpDesc)) q:(tmpDesc="")!(tmpDesc'[Desc)  d
    .s Rowid=$$GetLocByDescLoop(tmpDesc)
    .s flag=$$CheckLoc(Rowid,Type)
	.i flag=1 d
	..s LocCode=$p(^CTLOC(Rowid),"^",1)
	..s LocDesc=$p(^CTLOC(Rowid),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s s=Rowid_"^"_LocCode_"^"_LocDesc
    ..d ..BuildData(repid,ind,s)
    ..s ind=ind+1
    
    Quit $$$OK
GetLocByDescLoop(Desc)
   n (Desc)
   s Rowid=""
   q:'$d(^CTLOC(0,"Desc",Desc)) Rowid
   s Rowid=$o(^CTLOC(0,"Desc",Desc,Rowid))
   q Rowid
CheckLoc(Rowid,Type)
    n (Rowid,Type)
    s flag=""
    q:Rowid="" flag
    q:'$d(^CTLOC(Rowid)) flag
    s CTLocType=$p(^CTLOC(Rowid),"^",13)
    q:CTLocType="" flag
    q:((Type'="")&(Type'=CTLocType)) flag
    s flag=1
    q flag
}

ClassMethod QueryLocByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocByNameExecute ]
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

/// 通过姓名查询医护人员列表
Query QueryLocByName(Desc As %String, Type As %String) As %Query(ROWSPEC = "LocRowid:%String,LocCode:%String,LocName:%String")
{
}

ClassMethod QueryTypeByIndClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTypeByIndExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTypeByIndExecute(ByRef qHandle As %Binary, Ind As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind = 1
    Set qHandle=$lb(0,repid,0)
    
    s:Ind=1 tmpType="1^入院日期"_$c(1)_"2^出院日期"_$c(1)_"3^检查日期"
    f Index=1:1:$l(tmpType,$c(1)) d
    .s s=$p(tmpType,$c(1),Index)
    .q:s=""
    .d ..BuildData(repid,ind,s)
    .s ind=ind+1
	
    Quit $$$OK
}

ClassMethod QueryTypeByIndFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTypeByIndExecute ]
{
       
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
	    // if there are no more rows, finish fetching
        Set AtEnd = 1
        Set Row = ""
    }
    Else{
	    // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 查询类型（可扩展）
/// 1-日期类型  1:入院日期; 2:出院日期; 3:检查日期
/// 2-
Query QueryTypeByInd(Ind As %String) As %Query(ROWSPEC = "TypeInd:%String,TypeTitle:%String")
{
}

ClassMethod getpath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

}
