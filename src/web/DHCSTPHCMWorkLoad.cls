/// Creator:bianshuai
/// CreateDate:2014-06-30
/// Descript:住院工作量统计
Class web.DHCSTPHCMWorkLoad Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:住院用户审方工作量统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","2015-11-09","2015-11-09","1136","")
Query QueryInPhWorkLoad(StDate As %String = "", EndDate As %String = "", PLocID As %String = "", WLocID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TTotal:%String,TPass:%String,TRefuse:%String,TSuss:%String,TFail:%String") [ SqlProc ]
{
}

ClassMethod QueryInPhWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", PLocID As %String = "", WLocID As %String = "", UserID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StDate["-" StDate=$zdh(StDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)

	S pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global

	//S:PLocID="1136" PLocIDList="1136^1987^1129"
	
	F dd=StDate:1:EndDate D
	.F i=1:1:$L(PLocIDList,"^") D
	..S PLocID=$p(PLocIDList,"^",i)
	..S phaomID=""
	..F  S phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,PLocID,phaomID)) Q:phaomID=""  D
	...S userID=$p(^DHCPHORDM(phaomID),"^",1)     //用户ID
	...S userCode=$p(^SSU("SSUSR",userID),"^",1)  //工号
	...S userName=$p(^SSU("SSUSR",userID),"^",2)  //姓名
	...S auditFlag=$p(^DHCPHORDM(phaomID),"^",2)  //审核结果
	...S agreeFlag=$p(^DHCPHORDM(phaomID),"^",8)  //医生同意
	...S ch=""
	...F  S ch=$o(^DHCPHORDM(phaomID,"I",ch)) Q:ch=""  D
	....S orditm=$p(^DHCPHORDM(phaomID,"I",ch),"^",2) //住院医嘱ID
	....S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	....Q:moeori=""
	....Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori))  //同一张处方只统计一次
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori)=""
	....S EpisodeID=$p(^OEORD(+moeori),"^",1) //就诊表
	....S WardID=$p(^PAADM(EpisodeID),"^",70)  //病区
	....q:(WLocID'="")&(WLocID'=WardID)
	....
	....S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad",pid,userID))
	....I mdata="" S mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	....
	....S $p(mdata,"^",3)=$p(mdata,"^",3)+1  //处方总量
	....S:auditFlag="Y" $p(mdata,"^",4)=$p(mdata,"^",4)+1  //审核通过
	....S:agreeFlag="Y" $p(mdata,"^",6)=$p(mdata,"^",6)+1  //干预成功
	....S:(auditFlag="A")||(auditFlag="N") $p(mdata,"^",5)=$p(mdata,"^",5)+1    //审核拒绝
	....S:auditFlag="A" $p(mdata,"^",7)=$p(mdata,"^",7)+1   //医生不赞同
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad",pid,userID)=mdata
	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad",pid,index))
	.Q:mdata=""
	.// mdata列表 TUserCode,TUserName,TTotal,TPass,TRefuse,TSuss,TFail
	.// mdata列表 工号 姓名 处方总量 审通过 审核拒绝 干预成功量 干预失败量
	
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryInPhWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInPhWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInPhWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInPhWorkLoadExecute ]
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

/// Descript:住院科室处方量审核结果统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad","2015-11-09","2015-11-09","1136","","")
Query QueryInPhDeptWorkLoad(StDate As %String = "", EndDate As %String = "", PLocID As %String = "", WLocID As %String = "", InUserID As %String = "") As %Query(ROWSPEC = "TPid:%String,TLocDr:%String,TDept:%String,TTotal:%String,TPass:%String,TRefuse:%String,TSuss:%String,TFail:%String,TNoAudit:%String") [ SqlProc ]
{
}

ClassMethod QueryInPhDeptWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", PLocID As %String = "", WLocID As %String = "", InUserID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StDate["-" StDate=$zdh(StDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)

	S pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global
	
	
	F dd=StDate:1:EndDate D
	.F i=1:1:$L(PLocIDList,"^") D
	..S PLocID=$p(PLocIDList,"^",i)
	..S phaomID=""
	..F  S phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,PLocID,phaomID)) Q:phaomID=""  D
	...S userID=$p(^DHCPHORDM(phaomID),"^",1)     //用户ID
	...Q:(InUserID'="")&(InUserID'=userID)
	...S userCode=$p(^SSU("SSUSR",userID),"^",1)  //工号
	...S userName=$p(^SSU("SSUSR",userID),"^",2)  //姓名
	...S auditFlag=$p(^DHCPHORDM(phaomID),"^",2)  //审核结果
	...S agreeFlag=$p(^DHCPHORDM(phaomID),"^",8)  //医生同意
	...S ch=""
	...F  S ch=$o(^DHCPHORDM(phaomID,"I",ch)) Q:ch=""  D
	....S orditm=$p(^DHCPHORDM(phaomID,"I",ch),"^",2) //住院医嘱ID
	....S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	....Q:moeori=""
	....Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori))  //同一张处方只统计一次
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori)=""
	....s EpisodeID=$p(^OEORD(+moeori),"^",1) //就诊表
	....s WardID=$p(^PAADM(EpisodeID),"^",70)  //病区
	....q:(WLocID'="")&(WLocID'=WardID)
	....s WardDesc=$p(^PAWARD(WardID),"^",2)   //病区描述
	
	....S reasondesc=""
    ....S audReasondr=$p(^DHCPHORDM(phaomID,"I",ch),"^",3) //审核原因
 	....i audReasondr'="" S reasondesc=$p(^DHCPCREASON(audReasondr),"^",2)
 	
	....I (auditFlag="A")||(auditFlag="N") D ..SaveLocNoPassDetail(pid,WardID,orditm,reasondesc)
	....
	....S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad",pid,WardID)) 
	....I mdata="" S mdata=pid_"^"_WardID_"^"_WardDesc_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	....
	....S $p(mdata,"^",4)=$p(mdata,"^",4)+1  //处方总量
	....S:auditFlag="Y" $p(mdata,"^",5)=$p(mdata,"^",5)+1  //审核通过
	....S:agreeFlag="Y" $p(mdata,"^",7)=$p(mdata,"^",7)+1  //干预成功
	....S:(auditFlag="A")||(auditFlag="N") $p(mdata,"^",6)=$p(mdata,"^",6)+1    //审核拒绝
	....S:auditFlag="A" $p(mdata,"^",8)=$p(mdata,"^",8)+1 //医生不赞同
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad",pid,WardID)=mdata
	....

	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad",pid,index))
	.Q:mdata=""
	.// mdata列表 TPid,TLocDr,TDept,TTotal,TPass,TRefuse,TSuss,TFail,TNoAudit
	.// mdata列表 进程号 科室ID 科室 总量 审通过 审核拒绝 干预成功量 干预失败量 未审核处方
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryInPhDeptWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInPhDeptWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInPhDeptWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInPhDeptWorkLoadExecute ]
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

/// Descript:处方量审核结果统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryDeptWorkLoad","","","","","")
Query QueryDeptWorkLoad(StDate As %String = "", EndDate As %String = "", PhLoc As %String = "", LocID As %String = "", UserID As %String = "", Type As %String = "") As %Query(ROWSPEC = "TPid:%String,TLocDr:%String,TDept:%String,TTotal:%String,TBeChargeNum:%String,TSussNum:%String,TFailNum:%String,TPassNum:%String,TNoPassNum:%String,TPassRate:%String") [ SqlProc ]
{
}

ClassMethod QueryDeptWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", PhLoc As %String = "", LocID As %String = "", UserID As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StDate["-" StDate=$zdh(StDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)

	S pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global
	
	F dd=StDate:1:EndDate D
	.S phaomID=""
	.F  S phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,PhLoc,phaomID)) Q:phaomID=""  D
	..S userID=$p(^DHCPHORDM(phaomID),"^",1)     //用户ID
	..S userCode=$p(^SSU("SSUSR",userID),"^",1)  //工号
	..S userName=$p(^SSU("SSUSR",userID),"^",2)  //姓名
	..S ret=$p(^DHCPHORDM(phaomID),"^",2)        //审核结果
	..S locID=$p(^DHCPHORDM(phaomID),"^",5)      //科室ID
	..S LocDesc=""
	..S:locID'="" LocDesc=$p(^CTLOC(locID),"^",2) //科室描述
	..S:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..S agreeFlag=$p(^DHCPHORDM(phaomID),"^",8)
	..S ch=""
	..F  S ch=$o(^DHCPHORDM(phaomID,"I",ch)) Q:ch=""  D
	...S prescno=$p(^DHCPHORDM(phaomID,"I",ch),"^",4)  //门诊处方号
	...Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,index))  //同一张处方只统计一次
	...S chargeFlag=""
	...S:prescno'="" chargeFlag=..CheckIfAudBeforeCharge(phaomID,prescno) //判断处方是否审方前结算
	...S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,index)=""
	...S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid,locID))
	...I mdata="" D
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid,locID)=pid_"^"_locID_"^"_LocDesc_"^"_1_"^"_chargeFlag_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	...Else  D
	....S $p(mdata,"^",4)=$p(mdata,"^",4)+1
	....S $p(mdata,"^",5)=$p(mdata,"^",5)+chargeFlag
	....S $p(mdata,"^",6)=$p(mdata,"^",6)+1
	....S $p(mdata,"^",7)=$p(mdata,"^",7)+1
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid,locID)=mdata
	...//记录审核不合格数
	...S prescno=$p(^DHCPHORDM(phaomID,"I",ch),"^",4)  //门诊处方号
	...S:prescno="" prescno=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),1),"^",14)
	...I ret="N" D ..SaveLocNoPassDetail(pid,locID,prescno)

	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid,index))
	.Q:mdata=""
	.// mdata列表 TPid,TLocDr,TDept,TTotal,TBeChargeNum,TSussNum,TFailNum,TPassNum,TNoPassNum,TPassRate
	.// mdata列表 进程号 科室ID 科室 总量  计费前审方量  干预成功量 干预失败量 合格数 不合格数 合格率
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDeptWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDeptWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDeptWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDeptWorkLoadExecute ]
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

/// Descript:判断处方是否审方前结算 是返回1 ,否 返回0
ClassMethod CheckIfAudBeforeCharge(phaomID, PrescNo) As %String
{
	N (phaomID,PrescNo)
	Q:'$d(^DHCPHORDM(phaomID)) "0"
	S AudDate=$p(^DHCPHORDM(phaomID),"^",3) //审核日期
	S AudTime=$p(^DHCPHORDM(phaomID),"^",4) //审核时间
	S ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
	Q:ord="" "0"
	S itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,""))
	Q:itm="" "0"
	Q:'$d(^OEORD(ord,"I",itm)) "0"   //医嘱ID
	S PBORowID=$p(^OEORD(ord,"I",itm,1),"^",16)
	S BCIRowid=$o(^DHCBCI(0,"bill",+PBORowID,"")) //账单
	Q:BCIRowid="" "0"
	S Prt=+$p(^DHCBCI(BCIRowid),"^",1)
	Q:'$d(^DHCINVPRT(Prt)) "0"
	S prtDate=$P(^DHCINVPRT(Prt),"^",5) //结算日期
	S prtTime=$P(^DHCINVPRT(Prt),"^",20) //结算时间
	Q:AudDate<prtDate "0"   //审核日期小于结算日期
	Q:AudDate>prtDate "1"
	Q:AudTime>prtTime "0"
	Q 1
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhDeptWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid)
	k ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInHosPatInfo",pid)
}

/// Creator: bianshuai
/// Descript:门诊审方工作量统计(按用户/按科室) 根据入参 TabType 设置调用Query
/// D ##Class(web.DHCSTPHCMWorkLoad).MonitoWorkLoad("2015-11-01","2015-11-03","982","","O","tabUser")
ClassMethod MonitoWorkLoad(Params As %String) As %String
{
	N (Params)
	S StDate=$p(Params,"^",1)  ///开始日期
	S EndDate=$p(Params,"^",2) ///结束日期
	S LocID=$p(Params,"^",3)   ///科室ID
	S UserID=$p(Params,"^",4)  ///用户ID
	S TabType=$p(Params,"^",5) ///tab页签
 	If TabType="tabUser" S Query="web.DHCSTPHCMWorkLoad:QueryOutPhWorkLoad"     //按用户统计
	Else  S Query="web.DHCSTPHCMWorkLoad:QueryOutPhDeptWorkLoad"  //按科室统计
 	Set result=##class(%Library.ResultSet).%New(Query)
 	Set sc=result.Execute(StDate,EndDate,LocID,UserID)
 	If $$$ISERR(sc) Quit ""

    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Write ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(0) //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 Write ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	 Do result.Close()
	 Quit ""
}

/// Creator: huangchuanqi
/// Descript:住院审方工作量统计(按用户/按科室) 根据入参 TabType 设置调用Query
/// D ##Class(web.DHCSTPHCMWorkLoad).InHosMonitoWorkLoad("2015-11-09^2015-11-09^1136^^tabDept")
ClassMethod InHosMonitoWorkLoad(Params As %String) As %String
{
	N (Params)
	S StDate=$p(Params,"^",1)  ///开始日期
	S EndDate=$p(Params,"^",2) ///结束日期
	S PLocID=$p(Params,"^",3)  ///审方科室ID
	S WLocID=$p(Params,"^",4)  ///科室ID
	S UserID=$p(Params,"^",5)  ///用户ID
	S TabType=$p(Params,"^",6) ///tab页签
 	If TabType="tabUser" S Query="web.DHCSTPHCMWorkLoad:QueryInPhWorkLoad"  //按用户统计
	Else  S Query="web.DHCSTPHCMWorkLoad:QueryInPhDeptWorkLoad"  //按科室统计
 	Set result=##class(%Library.ResultSet).%New(Query)
 	Set sc=result.Execute(StDate,EndDate,PLocID,WLocID,UserID)
 	If $$$ISERR(sc) Quit ""

    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Write ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(0) //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 Write ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	 Do result.Close()
	 Quit ""
}

/// Descript:记录审核不合格数
/// careator:huangchuanqi
///     date:2015-09-18
/// D ##Class(web.DHCSTPHCMWorkLoad).SaveLocNoPassDetail("3094","977","18436269||3","慢性病、老年病或特殊情况处方超过30日用量")
ClassMethod SaveLocNoPassDetail(pid, locID, orditm, reasondesc) As %String
{
	N (pid,locID,orditm,reasondesc)
	Q:orditm="" ""
    S ord=$p(orditm,"||",1)
	S itm=$p(orditm,"||",2)
	S AdmDr=$p(^OEORD(ord),"^",1)
	S pmidr=+$p(^PAADM(AdmDr),"^",1)
    S patno=$p(^PAPER(pmidr,"PAT",1),"^",2)
    S patname=$p(^PAPER(pmidr,"ALL"),"^",1)
	///药品信息
	S arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) //医嘱 ARC_ItmMast ARCIM_RowId
	S itmmastid=$p(arcimid,"||",1)
	S itmmastver=$p(arcimid,"||",2)
	S arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	S prescno=$p(^OEORD(ord,"I",itm,1),"^",14)   //处方号
	S puomdr=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	S qty=$p(^OEORD(ord,"I",itm,1),"^",12) //医嘱数量
	S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))  //医嘱名称
	Q:inci=""
	S buomdr=+$p($g(^INCI(inci,1)),"^",10)
	S fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	S uomdr=buomdr
	I (qty#fac)=0 d
	.S qty=qty/fac   //数量
	.S uomdr=puomdr
	S uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	S dosage=$p($g(^OEORD(ord,"I",itm,2)),"^",1) //剂量
    S doseuom=""
	S dosuomID=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	i dosuomID'="" s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	S freq=""
	S freqdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4) ;OEORI_PHFreq_DR
    i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频率
    S instru=""
    S instrudr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
    i instrudr'="" S instru=$p(^PHCIN(instrudr),"^",2)  //用法
    S duration=""
    S durationdr=+$p($g(^OEORD(ord,"I",itm,2)),"^",6)
	S:durationdr'=0 duration=$p(^PHCDU(durationdr),"^",1)  //用药疗程
	S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)  //医生
	S ordtime=$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
    S:ordtime'="" ordtime=$zd(ordtime,3)
	S Index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","LocNoPassDetail",pid,locID,""),-1)
	S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","LocNoPassDetail",pid,locID,Index+1)=patno_"^"_patname_"^"_prescno_"^"_arcitmdesc_"^"_reasondesc_"^"_instru_"^"_dosage_doseuom_"^"_uomdesc_"^"_qty_"^"_freq_"^"_doctor_"^"_ordtime
	Q ""
}

/// Descript:科室不合格处方明细列表
/// w ##class(web.DHCSTPHCMWorkLoad).QueryLocDetail(2,1,1,100)
ClassMethod QueryLocDetail(rows, page, pid, LocID) As %String
{
	N (rows,page,pid,LocID)
	//对应global的记录总数index
	S index=+$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","LocNoPassDetail",pid,LocID,""),-1)
	I index="0" W ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:index="0" ""
	S Title="TPatNo^TPatName^TPrescNo^TArcItmDesc^TReasondesc^TInstru^TDosage_doseuom^TUomdesc^TQty^TFreq^TDoctor^TOrdtime"
	
	///转换数据为Json格式
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(index) //输出json前缀串
	
	S index=(page-1)*rows, Num=0 //记录数
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","LocNoPassDetail",pid,LocID,index)) Q:(index="")||(Num>=rows)  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","LocNoPassDetail",pid,LocID,index))
	.S Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	q ""
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("MonitoWorkLoad"))
}

/// ===================================用药建议工作量统计====================================
/// Creator:    bianshuai
/// CreateDate: 2014-12-06
/// Descript:   用药建议工作量统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad","2017-08-01","2017-08-18")
Query QueryMedAdvWorkLoad(StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TTotal:%String,TDocNoNum:%String,TPhaNoNum:%String,TDocAgrNum:%String,TPhaAgrNum:%String") [ SqlProc ]
{
}

ClassMethod QueryMedAdvWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	s:StDate["-" StDate=$zdh(StDate,3)
	s:StDate["/" StDate=$zdh(StDate,1)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:EndDate["/" EndDate=$zdh(EndDate,1)

	s pid=..NewPid() //计数器
	d ..killTmpGlobal(pid) //k掉临时global
	
	f dd=StDate:1:EndDate d
	.s medAdvID=""
	.f  s medAdvID=$o(^DHCPHAD(0,"Date",dd,medAdvID)) q:medAdvID=""  d
	..s medAdvAdmDr=$p(^DHCPHAD(medAdvID),"^",1) //病人ADM
	..s Locdr=$p(^PAADM(medAdvAdmDr),"^",4)
	..q:(HOSPID'="")&(HOSPID'=$p(^CTLOC(Locdr),"^",22))   //过滤病区
	..s userID=+$p(^DHCPHAD(medAdvID),"^",2)       //用户ID
	..Q:'$d(^SSU("SSUSR",userID))
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s curStatus=$p(^DHCPHAD(medAdvID),"^",6)     //结果
	..q:(curStatus = 0)
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",3)=$p(mdata,"^",3)+1    //建议总数
	..i curStatus="10" s $p(mdata,"^",4)=$p(mdata,"^",4)+1  //医生未处理
	..i curStatus="20" s $p(mdata,"^",5)=$p(mdata,"^",5)+1  //药师未处理
	..i curStatus="30" s $p(mdata,"^",6)=$p(mdata,"^",6)+1  //医生接受建议
	..i curStatus="40" s $p(mdata,"^",7)=$p(mdata,"^",7)+1  //药师同意用药
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid,userID)=mdata
	..

	//输出
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid,index))
	.q:mdata=""
	.// mdata列表 TUserCode,TUserName,TTotal,TDocNoNum,TPhaNoNum,TDocAgrNum,TPhaAgrNum
	.// mdata列表 工号 姓名 总量  医生未处理  药师未处理 医生接受建议 药师同意用药
	.s ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.set ^CacheTemp(repid,ind)=ListData	
	.set ind=ind+1
	
	d ..killTmpGlobal(pid) //k掉临时global
    set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryMedAdvWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMedAdvWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMedAdvWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMedAdvWorkLoadExecute ]
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

/// ===================================临床药师工作量统计====================================
/// Creator:    bianshuai
/// CreateDate: 2014-12-06
/// Descript:临床药师工作量统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryCliWorkLoad","2018-03-27","2018-03-28")
Query QueryCliWorkLoad(StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TMedWardRound:%String,TWardRound:%String,TPhaCare:%String,TMedEducation:%String,TSymPosium:%String,TCaseDis:%String,TJouClub:%String,TMedConsult:%String,TDrgCal:%String,TAdrRep:%String") [ SqlProc ]
{
}

ClassMethod QueryCliWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	s StDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(StDate)  //quniapeng 2018/3/28
	s EndDate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(EndDate)
	//s:StDate["-" StDate=$zdh(StDate,3)
	//s:StDate["/" StDate=$zdh(StDate,1)
	//s:EndDate["-" EndDate=$zdh(EndDate,3)
	//s:EndDate["/" EndDate=$zdh(EndDate,1)

	s pid=..NewPid() //计数器
	q:pid=""
	d ..killTmpGlobal(pid) //k掉临时global
	d ..wrWorkLoadStat(pid,StDate,EndDate,HOSPID)     //医学查房、药学查房、药学监护、用药教育、专题讲座、病历讨论、文献报告
	//d ..consWorkLoadStat(pid,StDate,EndDate)   //药学会诊
	d ..dcWorkLoadStatNew(pid,StDate,EndDate,HOSPID)  //药历书写  //quniapeng 2018/3/28
	d ..adrWorkLoadStat(pid,StDate,EndDate,HOSPID)	   //  药品不良反应 药品替换为不良事件旧版的 qunianpeng 2018/3/28 重新写查询
	
	//无数据,退出
	i $g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid)) Quit $$$OK

	//输出
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,index))
	.q:mdata=""
	.q:$p(mdata,"^",2)=""
	.// mdata列表 TUserCode,TUserName,TMedWardRound,TWardRound,TPhaCare,TMedEducation,TSymPosium,TCaseDis,TJouClub,TMedConsult,TDrgCal,TAdrRep
	.// mdata列表 工号,姓名,医学查房,药学查房,药学监护,用药教育,专题讲座,病历讨论,文献报告,药学会诊,药历书写,不良反应报告
	.s ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.set ^CacheTemp(repid,ind)=ListData	
	.set ind=ind+1
	
	d ..killTmpGlobal(pid) //k掉临时global
    set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryCliWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCliWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCliWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCliWorkLoadExecute ]
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

/// Descript:医学查房、药学查房、药学监护、用药教育、专题讲座、病历讨论、文献报告
ClassMethod wrWorkLoadStat(pid As %String, stDate As %String, endDate As %String, HOSPID As %String) As %String
{
	n (pid,stDate,endDate,HOSPID)
	
	f dd=stDate:1:endDate  d
	.//药学查房
	.s wardRoundID=""
	.f  s wardRoundID=$o(^DHCPHWR(0,"Date",dd,wardRoundID)) q:wardRoundID=""  d
	..s userID=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	..q:userID=""
	..s AdmDr=$p(^DHCPHWR(wardRoundID),"^",1)
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..s hospital=$p(^CTLOC(Locdr),"^",22)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..q:'$d(^SSU("SSUSR",+userID))
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",3)=$p(mdata,"^",3)+1         //药学查房
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	..
	.
	.//医学查房
	.s cliPatID=""
	.f  s cliPatID=$o(^DHCPHCP(0,"Date",dd,cliPatID)) q:cliPatID=""  d
	..s AdmDr=$p(^DHCPHCP(cliPatID),"^",1)
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..s hospital=$p(^CTLOC(Locdr),"^",22)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..s userID=$p($g(^DHCPHCP(cliPatID)),"^",18)      //记录人
	..q:userID=""
	..q:'$d(^SSU("SSUSR",+userID))
	..s userCode=$p($g(^SSU("SSUSR",userID)),"^",1)   //工号
	..s userName=$p($g(^SSU("SSUSR",userID)),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",4)=$p(mdata,"^",4)+1         //医学查房
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	..
	.
	.//药学监护
	.s phaCareID=""
	.f  s phaCareID=$o(^DHCPHPC(0,"Date",dd,phaCareID)) q:phaCareID=""  d
	..s AdmDr=$p(^DHCPHPC(phaCareID),"^",2)
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..s hospital=$p(^CTLOC(Locdr),"^",22)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..s userID=$p(^DHCPHPC(phaCareID),"^",5)      //记录人
	..q:userID=""
	..q:'$d(^SSU("SSUSR",+userID))
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",5)=$p(mdata,"^",5)+1         //药学监护
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	..
	.
	.//用药教育
	.s medEduID=""
	.f  s medEduID=$o(^DHCPHME(0,"Date",dd,medEduID)) q:medEduID=""  d
	..s AdmDr=$p(^DHCPHME(medEduID),"^",1)
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..s hospital=$p(^CTLOC(Locdr),"^",22)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..s userID=$p(^DHCPHME(medEduID),"^",3)       //记录人
	..q:userID=""
	..q:'$d(^SSU("SSUSR",+userID))
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",6)=$p(mdata,"^",6)+1         //用药教育
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	..
	.
	.//专题讲座、病历讨论、文献报告
	/*.s repID=""
	.f  s repID=$o(^User.DHCPHReportI("ICreateDate",dd,repID)) q:repID=""  d
	..s obj = ##class(User.DHCPHReport).%OpenId(repID)
	..q:obj=""
	..s type=obj.PHRType 						  //类型
	..s userID=obj.PHRCreator 					  //创建人
	..q:userID=""
	..q:'$d(^SSU("SSUSR",+userID))
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..i type="L" s $p(mdata,"^",7)=$p(mdata,"^",7)+1         //专题讲座
	..i type="M" s $p(mdata,"^",8)=$p(mdata,"^",8)+1         //病历讨论
	..i type="D" s $p(mdata,"^",9)=$p(mdata,"^",9)+1         //文献报告
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	..
	.
	/*.s adrRepID=""		// 药品替换为不良事件旧版的 qunianpeng 2018/3/28 重新写查询 
	.f  s adrRepID=$o(^DHCPHADRR(0,"RepDate",dd,adrRepID)) q:adrRepID=""  d
	..s AdrRepStatusID=$p(^DHCPHADRR(adrRepID),"^",45) //当前状态
	..q:AdrRepStatusID=""
	..s AdrReporter=$p(^DHCPHADRR(adrRepID),"^",30)    //报告人
	..s:AdrReporter["/" AdrReporter=$p(AdrReporter,"/",2)
	..s userID=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(AdrReporter),""))
	..q:'$d(^SSU("SSUSR",+userID))
	..q:'##Class(web.DHCSTPHCMWorkLoad).filerUserBySpecGrp(+userID)
	..s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	..i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	..s $p(mdata,"^",12)=$p(mdata,"^",12)+1         //不良反应
	..s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
	*/
	q ""
}

/// Descript:药学会诊
ClassMethod consWorkLoadStat(pid As %String, stDate As %String, endDate As %String) As %String
{
	n (pid,stDate,endDate)
		
	f dd=stDate:1:endDate  d
	.
	.//s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=""
	q ""
}

/// Descript:药历书写
ClassMethod dcWorkLoadStat(pid As %String, stDate As %String, endDate As %String) As %String
{
	n (pid,stDate,endDate)
	
	s EPRDocID=" 308",EPRNum="1"
	f dd=stDate:1:endDate  d
	.s dd=" "_dd
	.s Time=""
	.f  s Time=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",dd,Time)) q:Time=""  d
	..s EpisodeID=""
	..f  s EpisodeID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",dd,Time,EpisodeID)) q:EpisodeID=""  d
	...s ID=""
	...f  s ID=$o(^DHCEPRI.EPRLogsI("IdxCreateDateTime",dd,Time,EpisodeID,EPRDocID,EPRNum,ID)) q:ID=""  d
    ....s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(ID)
	....q:objEPRLogs=""
	....s userID=objEPRLogs.CreateUserID //创建人
	....s userCode=$p(^SSU("SSUSR",userID),"^",1)   //工号
	....s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	....s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	....i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	..
	....s $p(mdata,"^",11)=$p(mdata,"^",11)+1       //药历
	....s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryMedAdvWorkLoad",pid,userID)=mdata
	..
	.s dd=$tr(dd," ","")
	q ""
}

/// Description:	药历书写统计
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-28
/// Input:			进程id,开始日期,结束日期
/// return:			
/// other:		w ##class(web.DHCSTPHCMWorkLoad).dcWorkLoadStatNew()
ClassMethod dcWorkLoadStatNew(pid As %String, stDate As %String, endDate As %String, HOSPID As %String) As %String
{
	n (pid,stDate,endDate,HOSPID)
	f dd=stDate:1:endDate  d	
	.s recordID=""
	.f  s recordID=$o(^DHCPHI.InstanceDataI("IdxHappenDateTime",recordID))  q:recordID=""  d
	..s createTime=""
	..f  s createTime=$o(^DHCPHI.InstanceDataI("IdxHappenDateTime",recordID," SAVE",dd,createTime))  q:createTime=""  d
	...s InstanceID=""
	...f  s InstanceID=$o(^DHCPHI.InstanceDataI("IdxHappenDateTime",recordID," SAVE",dd,createTime,InstanceID))  q:InstanceID=""  d
	....s userID=$List(^DHCPHI.ECRecordD(recordID,"Instances",InstanceID),4)	 //创建人
	....s AdmDr=$List(^DHCPHI.ECRecordD(recordID,"Instances",InstanceID),23)
	....s Locdr=$p(^PAADM(AdmDr),"^",4)
	....s hospital=$p(^CTLOC(Locdr),"^",22)
	....q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	....s userCode=$p(^SSU("SSUSR",userID),"^",1)  							 	 //工号
	....s userName=$p(^SSU("SSUSR",userID),"^",2)   							 //姓名
	....s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	....i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	....
	....s $p(mdata,"^",11)=$p(mdata,"^",11)+1       							 //药历
	....s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata	
	q ""
}

/// Description:	不良反应统计
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-28
/// Input:			进程id,开始日期,结束日期
/// return:		
/// Modify:     lbb 2019-0109 修改取新产品组最新不良反应报告接口	
/// other:		w ##class(web.DHCSTPHCMWorkLoad).adrWorkLoadStat(1110,)
ClassMethod adrWorkLoadStat(pid As %String, stDate As %String, endDate As %String, HOSPID As %String) As %String
{
	n (pid,stDate,endDate,HOSPID)
	s RepListInfo=##class(web.DHCADVINTERFACE).GetRepStaticInfo(stDate,endDate,"advDrug",HOSPID)
	s len=$l(RepListInfo,"$$")
	f i=1:1:len d
	.s RepList=$p(RepListInfo,"$$",i)
	.s userID=$p(RepList,"^",1)          //报告人
	.q:userID=""
	.s userCode=$p(RepList,"^",2)   //工号
	.s userName=$p(RepList,"^",3)  //姓名
	.s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID))
	.i mdata="" s mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_count
	.s $p(mdata,"^",12)=$p(RepList,"^",4)         
	.s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryCliWorkLoad",pid,userID)=mdata
}

/// Descript:门诊科室处方量审核结果统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad","2015-11-04","2015-11-05","982","")
Query QueryOutPhDeptWorkLoad(StDate As %String, EndDate As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "TPid:%String,TLocDr:%String,TDept:%String,TTotal:%String,TPass:%String,TRefuse:%String,TSuss:%String,TFail:%String,TNoAudit:%String") [ SqlProc ]
{
}

ClassMethod QueryOutPhDeptWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, UserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StDate["-" StDate=$zdh(StDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)
	
	S userDr=UserID

	S pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global
	
	F dd=StDate:1:EndDate D
	.S phaomID=""
	.F  S phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,phaomID)) Q:phaomID=""  D
	..S userID=$p(^DHCPHORDM(phaomID),"^",1)     //用户ID
	..Q:(userDr'="")&(userDr'=userID)
	..S userCode=$p(^SSU("SSUSR",userID),"^",1)  //工号
	..S userName=$p(^SSU("SSUSR",userID),"^",2)  //姓名
	..S auditFlag=$p(^DHCPHORDM(phaomID),"^",2)  //审核结果
	..S agreeFlag=$p(^DHCPHORDM(phaomID),"^",8)  //医生同意
	..S ch=""
	..F  S ch=$o(^DHCPHORDM(phaomID,"I",ch)) Q:ch=""  D
	...S oeori=$p(^DHCPHORDM(phaomID,"I",ch),"^",2)  //医嘱ID
	...S prescno=$p(^DHCPHORDM(phaomID,"I",ch),"^",4)  //门诊处方号
	...S ord=$o(^OEORD(0,"PrescNo",prescno,""))
	...Q:ord=""
	...S itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	...Q:itm=""
	...S LocDesc=""
	...S locID=$p($g(^OEORD(ord,"I",itm,1)),"^",3)     //医生科室
	...S:locID'="" LocDesc=$p(^CTLOC(locID),"^",2) 	   //科室描述
	...//记录审核不合格数
	...S reasondesc=""
    ...S audReasondr=$p(^DHCPHORDM(phaomID,"I",ch),"^",3) //审核原因
 	...i audReasondr'="" S reasondesc=$p(^DHCPCREASON(audReasondr),"^",2)
	...I (auditFlag="A")||(auditFlag="N") D ..SaveLocNoPassDetail(pid,locID,oeori,reasondesc)
	...
	...Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,prescno))  //同一张处方只统计一次
	...S chargeFlag="" //..CheckIfAudBeforeCharge(phaomID,prescno) //判断处方是否审方前结算
	...S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,prescno)=""
	...S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,locID))
	...I mdata="" S mdata=pid_"^"_locID_"^"_LocDesc_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	...
	...S $p(mdata,"^",4)=$p(mdata,"^",4)+1  //处方总量
	...S:auditFlag="Y" $p(mdata,"^",5)=$p(mdata,"^",5)+1  //审核通过
	...S:agreeFlag="Y" $p(mdata,"^",7)=$p(mdata,"^",7)+1  //干预成功
	...S:(auditFlag="A")||(auditFlag="N") $p(mdata,"^",6)=$p(mdata,"^",6)+1    //审核拒绝
	...S:auditFlag="A" $p(mdata,"^",8)=$p(mdata,"^",8)+1 //医生不赞同
	...S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,locID)=mdata
	...

	D ..getDocLocPrescNum(pid,StDate,EndDate,LocID)  ///科室处方总计

	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,index))
	.Q:mdata=""
	.// mdata列表 TPid,TLocDr,TDept,TTotal,TPass,TRefuse,TSuss,TFail,TNoAudit
	.// mdata列表 进程号 科室ID 科室 总量 审通过 审核拒绝 干预成功量 干预失败量 未审核处方
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryOutPhDeptWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutPhDeptWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryOutPhDeptWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutPhDeptWorkLoadExecute ]
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

/// Descript:门诊审方工作量统计
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad","2015-11-1","2015-11-13","982","")
Query QueryOutPhWorkLoad(StDate As %String, EndDate As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TTotal:%String,TPass:%String,TRefuse:%String,TSuss:%String,TFail:%String") [ SqlProc ]
{
}

ClassMethod QueryOutPhWorkLoadExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, UserID As %String) As %Status
{
	
	//S ^huangchuanqi("1234")=StDate_"#"_EndDate_"#"_LocID_"#"_UserID
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	S:StDate["-" StDate=$zdh(StDate,3)
	S:EndDate["-" EndDate=$zdh(EndDate,3)

	S pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global

	F dd=StDate:1:EndDate D
	.S phaomID=""
	.F  S phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,phaomID)) Q:phaomID=""  D
	..S userID=$p(^DHCPHORDM(phaomID),"^",1)     //用户ID
	..S userCode=$p(^SSU("SSUSR",userID),"^",1)  //工号
	..S userName=$p(^SSU("SSUSR",userID),"^",2)  //姓名
	..S auditFlag=$p(^DHCPHORDM(phaomID),"^",2)  //审核结果
	..S agreeFlag=$p(^DHCPHORDM(phaomID),"^",8)  //医生同意
	..S ch=""
	..F  S ch=$o(^DHCPHORDM(phaomID,"I",ch)) Q:ch=""  D
	...S prescno=$p(^DHCPHORDM(phaomID,"I",ch),"^",4)  //门诊处方号
	...Q:prescno=""
	...Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,prescno))  //同一张处方只统计一次
	...S chargeFlag="" //..CheckIfAudBeforeCharge(phaomID,prescno)   //判断处方是否审方前结算
	...S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,prescno)=""
	...S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad",pid,userID))
	...I mdata="" S mdata=userCode_"^"_userName_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	...
	...S $p(mdata,"^",3)=$p(mdata,"^",3)+1  //处方总量
	...S:auditFlag="Y" $p(mdata,"^",4)=$p(mdata,"^",4)+1  //审核通过
	...S:agreeFlag="Y" $p(mdata,"^",6)=$p(mdata,"^",6)+1  //干预成功
	...S:(auditFlag="A")||(auditFlag="N") $p(mdata,"^",5)=$p(mdata,"^",5)+1    //审核拒绝
	...S:auditFlag="A" $p(mdata,"^",7)=$p(mdata,"^",7)+1   //医生不赞同
	...S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad",pid,userID)=mdata

	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhWorkLoad",pid,index))
	.Q:mdata=""
	.// mdata列表 TUserCode,TUserName,TTotal,TPass,TRefuse,TSuss,TFail
	.// mdata列表 工号 姓名 处方总量 审通过 审核拒绝 干预成功量 干预失败量
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryOutPhWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutPhWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryOutPhWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutPhWorkLoadExecute ]
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

/// Descript:不合理原因列表
ClassMethod jsQueryUnReasonList(waycode As %String) As %String
{
	N (waycode)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PCR_RowID,PCR_Code,PCR_Desc FROM DHC_PHCNTSREASON WHERE PCR_Way_Dr="_waycode
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "[["
	While(result.Next())
	{	
		s reasoncode = result.Data("PCR_Code")
		s reasondesc = result.Data("PCR_Desc")
		s reasonwidth = "160"
		s tmp=reasoncode_"^"_reasondesc_"^"_reasonwidth
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width",tmp)
	}
	w "]]"
}

/// Descript:门诊科室列表
ClassMethod jsQueryOutLocList(LocID As %String, waycode As %String) As %String
{

	N (LocID,waycode)
	i (LocID="")||(waycode="") w "[]"
	Q:(LocID="")||(waycode="") ""
	s count = 0
	s subLocwidth = "140"
	s subLocalign = "center"

	w "[["
	//s ListData="reasondr^原因^160^left"  //设置为冻结列,不再返回
	//s count = count+1
	//W ##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width^align",ListData)
	s grpID=""
	f  s grpID=$o(^DHCSLG(0,"APPTYPE","DHCSTCOMMON",LocID,grpID)) q:grpID=""  d
	.s ch=""
	.f  s ch=$o(^DHCSLG(grpID,"I",ch)) q:ch=""  d
	..s subLocID=$p(^DHCSLG(grpID,"I",ch),"^",1)  //科室ID
	..q:subLocID=""
	
	..s subLocDesc=$p(^CTLOC(subLocID),"^",2)

	..s:subLocDesc["-" subLocDesc=$p(subLocDesc,"-",2)
	..
	..s ListData=subLocID_"^"_subLocDesc_"^"_subLocwidth_"^"_subLocalign
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width^align",ListData)
	..e  d
	...W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width^align",ListData)
	s ListData="total^合计^90^center"
	W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width^align",ListData)
	s ListData="rate^百分率^90^center"
	W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("field^title^width^align",ListData)

	w "]]"
	q ""
}

/// Descript门诊科室拒绝原因统计
ClassMethod jsQueryLocUnreason(rows As %String, page As %String, ParamList As %String) As %String
{
	N (rows, page, ParamList)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	
	s StartDate=$p(ParamList,"^",1) //开始日期
	s EndDate=$p(ParamList,"^",2)   //结束日期
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s LocID=$p(ParamList,"^",3)     //登录科室

	///列表
	s TitleListData="reasondr"
	s TempTotalListData="合计:"
	
	s grpID=""
	f  s grpID=$o(^DHCSLG(0,"APPTYPE","DHCSTCOMMON",LocID,grpID)) q:grpID=""  d
	.s ch=""
	.f  s ch=$o(^DHCSLG(grpID,"I",ch)) q:ch=""  d
	..s subLocID=$p(^DHCSLG(grpID,"I",ch),"^",1)  //科室ID
	..s subLocDesc=$p(^CTLOC(subLocID),"^",2)
	..s TitleListData=TitleListData_"^"_subLocID
	.
	s TitleListData=TitleListData_"^"_"total"_"^"_"rate"
	s TitleListData=$LISTFROMSTRING(TitleListData,"^")
	s TotalPosition=$LISTLENGTH(TitleListData)

	s Num=0
	f dd=StartDate:1:EndDate d
	.s phaomID=""
	.f  s phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,phaomID)) q:phaomID=""  d
	..s auditFlag=$p(^DHCPHORDM(phaomID),"^",2)  //审核结果
	..q:auditFlag="Y"
	..s ch=""
	..f  s ch=$o(^DHCPHORDM(phaomID,"I",ch)) q:ch=""  d
	...s prescno=$p(^DHCPHORDM(phaomID,"I",ch),"^",4)  //门诊处方号
	...q:prescno=""
	...s reasondr=$p(^DHCPHORDM(phaomID,"I",ch),"^",3) //拒绝原因
	...s oeori=$p(^DHCPHORDM(phaomID,"I",ch),"^",2)    //医嘱
	...q:oeori=""
	...s docLocID=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",3)  //医生科室
	...s position=$lf(TitleListData,docLocID)
	...q:position=0
	...s reasondesc=$p(^DHCPCREASON(reasondr),"^",2)
	...s Num=Num+1
	...s index=reasondr
	...
	...//原因合计
	...s $p(TempTotalListData,"^",position)=$p(TempTotalListData,"^",position)+1
	...s $p(TempTotalListData,"^",TotalPosition-1)=$p(TempTotalListData,"^",TotalPosition-1)+1
	...
	...s TempListData=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index))
	...s $p(TempListData,"^",position)=$p(TempListData,"^",position)+1
	...s $p(TempListData,"^",TotalPosition-1)=$p(TempListData,"^",TotalPosition-1)+1
	...s:$p(TempListData,"^",1)="" $p(TempListData,"^",1)=reasondesc
	...s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index)=TempListData
	...
	..

	///科室合计
	i Num'=0 d
	.s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,"99999")=TempTotalListData
	
	///百分率
	s rate=0
	i Num'=0 d
	.s index=""
	.f  s index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index)) q:index=""  d
	..s count=+$p(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index),"^",TotalPosition-1)
	..s Total=+$p(TempTotalListData,"^",TotalPosition-1)
	..s:Total'=0 rate=$fn(count/Total,"",2)*100_"%"
	..s $p(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index),"^",TotalPosition)=rate
	.	

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title=$LISTTOSTRING(TitleListData,"^")

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryLocUnreason",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript住院科室拒绝原因统计
/// d ##class(web.DHCSTPHCMWorkLoad).jsQueryInPhLocUnreason(100,1,"2015-11-09^2015-11-09^1136^^tabLocUnReason")
ClassMethod jsQueryInPhLocUnreason(rows As %String, page As %String, ParamList As %String) As %String
{
	N (rows, page, ParamList)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	
	s StartDate=$p(ParamList,"^",1) //开始日期
	s EndDate=$p(ParamList,"^",2)   //结束日期
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s LocID=$p(ParamList,"^",3)     //登录科室
   
	///列表
	s TitleListData="reasondr"
	s TempTotalListData="合计:"
	
	s grpID=""
	f  s grpID=$o(^DHCSLG(0,"APPTYPE","DHCSTCOMMON",LocID,grpID)) q:grpID=""  d
	.s ch=""
	.f  s ch=$o(^DHCSLG(grpID,"I",ch)) q:ch=""  d
	..s subLocID=$p(^DHCSLG(grpID,"I",ch),"^",1)  //科室ID
	..s subLocDesc=$p(^CTLOC(subLocID),"^",2)
	..s TitleListData=TitleListData_"^"_subLocID
	.
	s TitleListData=TitleListData_"^"_"total"_"^"_"rate"
	s TitleListData=$LISTFROMSTRING(TitleListData,"^")
	s TotalPosition=$LISTLENGTH(TitleListData)
	
	s Num=0
	S:LocID="1136" PLocIDList="1136^1987^1129"

	f dd=StartDate:1:EndDate d
	.f i=1:1:$L(PLocIDList,"^") d
	..s LocID=$p(PLocIDList,"^",i)
	..s phaomID=""
	..f  s phaomID=$o(^DHCPHORDM(0,"DateLoc",dd,LocID,phaomID)) q:phaomID=""  d
	...s auditFlag=$p($g(^DHCPHORDM(phaomID)),"^",2)  //审核结果
	...q:auditFlag="Y"
	...s ch=""
	...f  s ch=$o(^DHCPHORDM(phaomID,"I",ch)) q:ch=""  d
	....s reasondr=$p(^DHCPHORDM(phaomID,"I",ch),"^",3) //拒绝原因
	....s orditm=$p(^DHCPHORDM(phaomID,"I",ch),"^",2)    //医嘱ID
	....S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	....Q:moeori=""
	....Q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori))  //同一张处方只统计一次
	....S ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInPhWorkLoad","moeori",pid,moeori)=""
	....s EpisodeID=$p(^OEORD(+moeori),"^",1)   //就诊表
	....s WardID=$p(^PAADM(EpisodeID),"^",70)  //病区
	....s WardLocID=$p(^PAWARD(WardID),"^",5)  //病区科室id

	....s position=$lf(TitleListData,WardLocID)
	....q:position=0
	....q:reasondr=""
	....s reasondesc=$p(^DHCPCREASON(reasondr),"^",2)
	....s Num=Num+1
	....s index=reasondr
	
	.... //原因合计
	....s $p(TempTotalListData,"^",position)=$p(TempTotalListData,"^",position)+1
	....s $p(TempTotalListData,"^",TotalPosition-1)=$p(TempTotalListData,"^",TotalPosition-1)+1
	....
	....s TempListData=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index))
	....s $p(TempListData,"^",position)=$p(TempListData,"^",position)+1
	....s $p(TempListData,"^",TotalPosition-1)=$p(TempListData,"^",TotalPosition-1)+1
	....s:$p(TempListData,"^",1)="" $p(TempListData,"^",1)=reasondesc
	....s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index)=TempListData
	....
	..

	///科室合计
	i Num'=0 d
	.s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,"99999")=TempTotalListData
	
	///百分率
	s rate=0
	i Num'=0 d
	.s index=""
	.f  s index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index)) q:index=""  d
	..s count=+$p(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index),"^",TotalPosition-1)
	..s Total=+$p(TempTotalListData,"^",TotalPosition-1)
	..s:Total'=0 rate=$fn(count/Total,"",2)*100_"%"
	..s $p(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index),"^",TotalPosition)=rate
	.	

	Q:Num=0 ##class(web.DHCSTCNTUTILCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title=$LISTTOSTRING(TitleListData,"^")

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMWorkLoad","jsQueryInPhLocUnreason",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTCNTUTILCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTCNTUTILCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:科室处方总量
ClassMethod getDocLocPrescNum(pid As %String, StartDate As %String, EndDate As %String, recLoc As %String) As %String
{
	N (pid,StartDate,EndDate,recLoc)

    f dd=StartDate:1:EndDate d
    .s ord=""
    .f  s ord=$o(^OEORDi(0,"ItemDate",dd,ord)) q:ord=""  d    
    ..s itm="" 
    ..f  s itm=$o(^OEORDi(0,"ItemDate",dd,ord,itm)) q:itm=""  d
    ...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1) //医嘱核实、未核实、停止状态
	...q:oeflag="D"
    ...s loc=$p(^OEORD(ord,"I",itm,3),"^",6)  //医嘱接收科室
    ...q:loc'=recLoc
    ...s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)  //处方号
    ...q:prescno=""
	...q:$d(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryWorkLoad","PrescNo",pid,prescno))
    ...s locID=$p(^OEORD(ord,"I",itm,1),"^",3)     //医生科室
    ...s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,locID))
    ...q:mdata=""
    ...s $p(mdata,"^",$L(mdata,"^"))=$p(mdata,"^",$L(mdata,"^"))+1
    ...s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryOutPhDeptWorkLoad",pid,locID)=mdata
    q ""
}

/// Descript:过滤掉非指定安全组的用户
/// W ##Class(web.DHCSTPHCMWorkLoad).filerUserBySpecGrp("2812")
ClassMethod filerUserBySpecGrp(userID As %String) As %String
{
	n (userID)
	s userGrpDescList=$LISTFROMSTRING("临床药师",",")
	s quitflag=0
	s othusr="0"
	f  s othusr=$o(^SSU("SSUSR",userID,"OTHLL",othusr)) q:(othusr="")||(quitflag=1)  d
	.s usergrpID=$p(^SSU("SSUSR",userID,"OTHLL",othusr),"^",2)
	.q:'$d(^SSU("SSGRP",usergrpID))
	.s usergrpdesc=$p(^SSU("SSGRP",usergrpID),"^",1)
	.q:$lf(userGrpDescList,usergrpdesc)=0
	.s quitflag=1
	q quitflag
}

/// Creator:    lbb
/// CreateDate: 2019-12-10
/// Descript:   取该病区在院患者列表信息
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMWorkLoad","QueryInHosPatInfo","^31")
Query QueryInHosPatInfo(input As %String) As %Query(ROWSPEC = "AdmBed:%String,patno:%String,patname:%String,patsex:%String,patage:%String,diag:%String,day:%String") [ SqlProc ]
{
}

ClassMethod QueryInHosPatInfoExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	i input="" Quit $$$OK
    s empflag=$p(input,"^",1)
    s LocID=$p(input,"^",2)
    s wardID=$p(input,"^",3)
    s InPatNo=$p(input,"^",4)
    
    s pid=..NewPid() //计数器
	d ..killTmpGlobal(pid) //k掉临时global
	
	///取最近一次就诊记录
	If (wardID="")&(InPatNo'="") D
	.s papmi=$o(^PAPERi("PAPMI_PatNo",InPatNo,""))
	.q:papmi=""
	.s AdmDr=$o(^PAPERdr(papmi,"ADM","I",""),-1)
	.q:AdmDr=""
	.d getPatInfo
	
	E   d	
	.i LocID'=""  D
	..s wardID=""
	..f  s wardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,wardID)) Q:wardID=""  d
	...s curRoomDr=""
	...f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	....s AdmDr="" 
	....f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
    .....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    .....q:patVisit'="A"
	.....d getPatInfo
	.E  D
	..s curRoomDr=""
	..f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
    ....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ....q:patVisit'="A"
	....d getPatInfo
	
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInHosPatInfo",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInHosPatInfo",pid,index))
	.q:mdata=""
	.s ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.set ^CacheTemp(repid,ind)=ListData	
	.set ind=ind+1
	
	d ..killTmpGlobal(pid) //k掉临时global
    set QHandle=$lb(0,repid,0)
	Quit $$$OK
		
	
getPatInfo	
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
    S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
    s patsex=$p(^CT("SEX",sex),"^",2)
    s patage=##class(PHA.FACE.IN.Com).GetAge(papmi,AdmDr)  ;年龄
    s diag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(AdmDr,",") //诊断
    s mLevel=##class(DHCSTPHCMEMPPAT).getPatMonLevel(AdmDr) //获取患者监护级别
    s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	i admdate'="" s admdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(admdate)  ;$zd(admdate,3)
	s day=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+$h)
    s mdata=AdmBed_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_diag_"^"_day
	s index=admward_"^"_AdmBed_"^"_admdate_"^"_patno
	s ^TMP("DHCST","web.DHCSTPHCMWorkLoad","QueryInHosPatInfo",pid,index)=mdata
	//输出
}

ClassMethod QueryInHosPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInHosPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInHosPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInHosPatInfoExecute ]
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
