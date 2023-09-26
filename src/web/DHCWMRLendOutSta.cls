Import SQLUser

/// 病案借阅查询
/// Create By LiYang 2008-11-20
Class web.DHCWMRLendOutSta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 102;

/// 获取一次就诊信息  
/// VolID  卷ID
ClassMethod GetAdmitInfoString(VolID)
{
	n (VolID)
	set VolInfo = $g(^DHCWMRVOL(VolID))

	quit:VolInfo="" ""
	set PaadmID = $p(VolInfo, "^", 2)
	set HisAdmID = $p(VolInfo, "^", 3)	
	set VolAdmID = ""
	set LastAdmID = ""
	if (PaadmID '= "")
	{
		set strAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(PaadmID)
		set LastChildSub = $o(^DHCWMRVOL(VolID, "ADM", ""),-1)
		set LastAdmID =  +$g(^DHCWMRVOL(VolID, "ADM", LastChildSub))
		set strLastAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(LastAdmID)
		set AdmitDate = $p(strAdm, "^", 4)
		set AdmitDep =  $p($p(strAdm, "^", 7),"/",2)
		set DisDate = $p(strLastAdm, "^", 12)
		set DisDep = $p($p(strLastAdm, "^", 7),"/",2)
	}
	else
	{
		set strAdm = $g(^DHCWMRHISADM(HisAdmID))
		set AdmitDate = $p(strAdm, "^", 2)
		set AdmitDep = $p(strAdm, "^", 4)
		set DisDate = $p(strAdm, "^", 6)
		set DisDep = $p(strAdm, "^", 8)	
		set:AdmitDate'="" AdmitDate	= $zd(AdmitDate, 3)
		set:DisDate'="" DisDate = $zd(DisDate, 3)
	}

	if (AdmitDate'="")&(DisDate'="")
	{
		set Days = $zdh(DisDate, 3) - $zdh(AdmitDate, 3)
	}
	else
	{
		set Days = 0
	}
	quit AdmitDate_"^"_AdmitDep_"^"_DisDate_"^"_DisDep_"^"_Days
}

/// 查询附加项目
/// MainID 病案主信息ID
/// MainStatusChild 病案状态信息的ChildSub
/// WorkDetailCode 附加项目的代码
///  ^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{DHC_WMR_MainStatus.ChildSub},"D",{ChildSub})
ClassMethod GetWorkItemExtraMain(MainID, MainStatusChild, WorkDetailCode)
{
	n (MainID, MainStatusChild, WorkDetailCode)
	quit:(MainID="")!(MainStatusChild="")!(WorkDetailCode="")
	set ret = ""
	set WorkIDetailtemID = $o(^DHCWMRWDTL(0, "Code", WorkDetailCode, ""))
	
	
	set ChildSub = ""
	while (1)
	{
		set ChildSub = $o(^DHCWMRMAIN(MainID,"S", MainStatusChild,"D", ChildSub))
		quit:ChildSub=""
		set strData = $g(^DHCWMRMAIN(MainID, "S", MainStatusChild, "D", ChildSub))
		continue:$p(strData,"^",1)'=WorkIDetailtemID
		set ret=$p(strData,"^",2)
		s DataType=$p($g(^DHCWMRWDTL(+WorkIDetailtemID)),"^",3) //add 2010-11-17 取附加项目类型
		s:DataType="Dictionary" ret=$p($g(^DHCWMRDIC(+ret)),"^",3) //add 2010-11-17 如果是字典类型，取出描述
	}
	quit ret
}

ClassMethod GetWorkItemExtraVol(VolID, VolStatusChild, WorkDetailCode)
{
	n (VolID, VolStatusChild, WorkDetailCode)
	quit:(VolID="")!(VolStatusChild="")!(WorkDetailCode="")
	set ret = ""
	set WorkIDetailtemID = $o(^DHCWMRWDTL(0, "Code", WorkDetailCode, ""))
	set ChildSub = ""
	while (1)
	{
		set ChildSub = $o(^DHCWMRVOL(VolID,"S", VolStatusChild,"D", ChildSub))
		quit:ChildSub=""
		set strData = $g(^DHCWMRVOL(VolID, "S", VolStatusChild, "D", ChildSub))
		continue:$p(strData,"^",1)'=WorkIDetailtemID
		set ret=$p(strData,"^",2)
		s DataType=$p($g(^DHCWMRWDTL(+WorkIDetailtemID)),"^",3) //add 2010-11-17 取附加项目类型
		s:DataType="Dictionary" ret=$p($g(^DHCWMRDIC(+ret)),"^",3) //add 2010-11-17 如果是字典类型，取出描述
	}
	quit ret
}

ClassMethod QueryLendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLendExecute ]
{
	Quit $$$OK
}

ClassMethod QueryStayOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStayOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLendExecute(ByRef qHandle As %Binary, MrType As %String, FromDate As %String, ToDate As %String, LendStatusID As %String, ReturnStatusID As %String, MRLocation As %String, Reason As %String, LendUser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)	
	q:(FromDate="")!(ToDate="") $$$OK
	//^DHCWMRMAIN(0,"SDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_Main.Rowid},"S",{ChildSub})
	//MrType:%String:病案类型,MrNo:%String:病案号,PatientName:%String:患者姓名,Sex:%String:性别,LendOutDate:%String:借阅日期,LendOutTime:%String:节约时间,LendOutDep:%String:借阅科室,
	//LendOutUser:%String:借阅人,LendOperator:%String:借阅经手人,LendOutUserTel:%String:借阅人电话,ReturnDate:%String:归还日期,ReturnTime:%String:归还时间,ReturnUser:%String:归还人")
	f tmpDate=FromDate:1:ToDate  d
	.s mainID="" f  s mainID=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,LendStatusID,mainID)) q:mainID=""  d
	..s childSub="" f  s childSub=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,LendStatusID,mainID,"S",childSub)) q:childSub=""  d
	...s status=$g(^DHCWMRMAIN(mainID,"S",childSub))
	...q:status=""
	...s mainData=$g(^DHCWMRMAIN(mainID))
	...q:$p(mainData,"^",6)="N" //删除状态
	...q:(($p(mainData,"^",1)'=MrType)&&(MrType'="")) //病案类型不对
	...s patInfo=##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(mainID)
	...s depDicID=..GetWorkItemExtraMain(mainID,childSub,"Dep")	
	...q:((MRLocation'="")&&(depDicID'=MRLocation)) //-----------------校验科室
	...s strLendUser=##class(web.DHCWMRMedBaseCtl).GetUsrStr(+$p(status,"^",5))
	...q:((LendUser'="")&&(LendUser'=$p(strLendUser,"/",3)))  //----------校验借阅人
	...s LendAim=..GetWorkItemExtraMain(mainID,childSub,"LendReason")
	...q:((Reason'="")&&(Reason'=LendAim)) //---------------------------校验借阅原因
	...s data=$lb("")
	...s $li(data,1)=$p($g(^DHCWMRDIC(+$p(mainData,"^",1))),"^",3) //病案类型
	...s $li(data,2)=$p(mainData,"^",2) //病案号
	...s $li(data,3)=$p(patInfo,"^",2) //姓名
	...s $li(data,4)=$p(patInfo,"^",4) //性别
	...s $li(data,5)=$zd($p(status,"^",3),3) //借出日期
	...s $li(data,6)=$zt($p(status,"^",4),1) //借出时间
	...s dep=##class(web.DHCWMRDictionaryCtl).GetDataById(depDicID)
	...s dep=$p(dep,"^",4)
	...s $li(data,7)=dep //借出科室
	...s $li(data,8)=$p(strLendUser,"/",2)_" "_$p(strLendUser,"/",3) //借阅人
	...s lendOperator=##class(web.DHCWMRMedBaseCtl).GetUsrStr(+$p(status,"^",2))
	...s $li(data,9)=$p(lendOperator,"/",2)_" "_$p(lendOperator,"/",3) //借阅经手人
	...s $li(data,10)=..GetWorkItemExtraMain(mainID,childSub,"DepTel") //借阅人电话
	...s retChildSub=$o(^DHCWMRMAIN(mainID,"S",childSub))
	...s retStatus=$g(^DHCWMRMAIN(mainID,"S",+retChildSub))
	...i $p(retStatus,"^",1)=ReturnStatusID  d
	....s retSatus=$g(^DHCWMRMAIN(mainID,"S",retChildSub))
	....s $li(data,11)=$zd($p(retSatus,"^",3),3) //归还日期
	....s $li(data,12)=$zt($p(retSatus,"^",4),1) //归还时间
	....s $li(data,13)=..GetWorkItemExtraMain(mainID,childSub,"RetUser") //归还人
	...e  d
	....s $li(data,11)=""
	....s $li(data,12)=""
	....s $li(data,13)=""
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	
	f tmpDate=FromDate:1:ToDate  d
	.s volID="" f  s volID=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,LendStatusID,volID)) q:volID=""  d
	..s childSub="" f  s childSub=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,LendStatusID,volID,childSub)) q:childSub=""  d
	...s status=$g(^DHCWMRVOL(volID,"S",childSub))
	...s volData=$g(^DHCWMRVOL(volID))
	...q:(status="")!(volData="")
	...s mainID=$p(volData,"^",1)
	...s mainData=$g(^DHCWMRMAIN(mainID))
	...q:$p(mainData,"^",6)="N" //删除状态
	...q:(($p(mainData,"^",1)'=MrType)&&(MrType'="")) //病案类型不对
	...s patInfo=##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(mainID)
	...s depDicID=..GetWorkItemExtraVol(volID,childSub,"Dep")	
	...q:((MRLocation'="")&&(depDicID'=MRLocation)) //-----------------校验科室
	...s strLendUser=##class(web.DHCWMRMedBaseCtl).GetUsrStr(+$p(status,"^",5))
	...q:((LendUser'="")&&(LendUser'=$p(strLendUser,"/",3)))  //----------校验借阅人
	...s LendAim=..GetWorkItemExtraVol(volID,childSub,"LendReason")
	...q:((Reason'="")&&(Reason'=LendAim)) //---------------------------校验借阅原因	
	...s data=$lb("")
	...s $li(data,1)=$p($g(^DHCWMRDIC(+$p(mainData,"^",1))),"^",3) //病案类型
	...s $li(data,2)=$p(mainData,"^",2) //病案号
	...s $li(data,3)=$p(patInfo,"^",2) //姓名
	...s $li(data,4)=$p(patInfo,"^",4) //性别
	...s $li(data,5)=$zd($p(status,"^",3),3) //借出日期
	...s $li(data,6)=$zt($p(status,"^",4),1) //借出时间
	...s dep=##class(web.DHCWMRDictionaryCtl).GetDataById(depDicID)
	...s dep=$p(dep,"^",4)
	...s $li(data,7)=dep
	...s $li(data,8)=$p(strLendUser,"/",2)_" "_$p(strLendUser,"/",3) //借阅人
	...s lendOperator=##class(web.DHCWMRMedBaseCtl).GetUsrStr(+$p(status,"^",2))
	...s $li(data,9)=$p(lendOperator,"/",2)_" "_$p(lendOperator,"/",3) //借阅经手人
	...s $li(data,10)=..GetWorkItemExtraVol(volID,childSub,"Tel") //借阅人电话
	...s retChildSub=$o(^DHCWMRVOL(volID,"S",childSub))
	...s retStatus=$g(^DHCWMRVOL(volID,"S",+retChildSub))
	...i $p(retStatus,"^",1)=ReturnStatusID  d
	....s retSatus=$g(^DHCWMRVOL(volID,"S",retChildSub))
	....s $li(data,11)=$zd($p(retSatus,"^",3),3) //归还日期
	....s $li(data,12)=$zt($p(retSatus,"^",4),1) //归还时间
	....s $li(data,13)=..GetWorkItemExtraVol(volID,retChildSub,"DoctorName") //归还人
	...e  d
	....s $li(data,11)=""
	....s $li(data,12)=""
	....s $li(data,13)=""
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryStayOutExecute(ByRef qHandle As %Binary, MrType As %String, StatusID As %String, DateFrom As %String, DateTo As %String, PrintFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(MrType="")!(StatusID="") $$$OK
	quit:(DateFrom="")||(DateTo="") $$$OK
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	set MainID = ""
	while (1)
	{
		set MainID = $o(^DHCWMRMAIN(0,"TypeStay",MrType,"N",MainID))
		quit:MainID=""
		set ChildSub = $o(^DHCWMRMAIN(MainID, "S", ""), -1)
		;b ;strStatus
		continue:(+ChildSub=0)
		set strStatus = $g(^DHCWMRMAIN(MainID, "S", ChildSub))
		
		continue:$p(strStatus,"^",1)'=StatusID
		s CurrDate=$p(strStatus,"^",3) 						//add by liuxuefeng 2010-11-10
		continue:(CurrDate>DateTo)||((CurrDate<DateFrom)) 	//add by liuxuefeng 2010-11-10
		set ^CacheTemp(repid,ind) = $$BuildQueryStayOutMain(MainID, strStatus, ChildSub)
		set ind = ind + 1
	}
	set VolID = ""
	while (1)
	{
		set VolID = $o(^DHCWMRVOL(0,"Status", StatusID, VolID))
		quit:VolID=""
		set strVol = $g(^DHCWMRVOL(VolID))
		set MainID = $p(strVol, "^", 1)
		continue:MainID=""
		set strMain = $g(^DHCWMRMAIN(MainID))
		continue:$p(strMain,"^",1)'=MrType
		set ChildSub = $o(^DHCWMRVOL(VolID, "S", 0, "Status", StatusID, ""), -1)
		continue:(+ChildSub=0)
		set strStatus = $g(^DHCWMRVOL(VolID, "S", ChildSub))
		s CurrDate=$p(strStatus,"^",3) 						//add by liuxuefeng 2010-11-10
		continue:(CurrDate>DateTo)||((CurrDate<DateFrom)) 	//add by liuxuefeng 2010-11-10
		set ^CacheTemp(repid,ind) = $$BuildQueryStayOutVolume(MainID, VolID, strStatus, ChildSub)
		set ind = ind + 1
	}
	s Cnt=ind-1										;add by liuxuefeng 2009-07-17 页面输出列表总数
	w:PrintFlag'="Y" !,"数量:"_Cnt					;add by liuxuefeng 2009-07-17 页面输出列表总数
	Quit $$$OK
BuildQueryStayOutMain(MainID, MainStatus, MainStatusChildSub)
	n (MainID, MainStatus, MainStatusChildSub)
	set data = $lb("")
	set mainData = $g(^DHCWMRMAIN(MainID))
	set PatientData = ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainID)
	set $li(data, 1) = "整本病案"
	set $li(data, 2) = $p(mainData, "^", 2) //病案号
	set $li(data, 3) = $p(PatientData, "^", 2)
	set $li(data, 4) = ""
	set $li(data, 5) = ""
	set $li(data, 6) = $zd($p(MainStatus, "^", 3), 3) //借出日期
	set $li(data, 7) = $zt($p(MainStatus, "^", 4), 1) //借出时间
	set $li(data, 8) = ..GetWorkItemExtraMain(MainID, MainStatusChildSub, "1") //科别
	set $li(data, 9) = ..GetWorkItemExtraMain(MainID, MainStatusChildSub, "4") //借阅人
	set $li(data, 10) = ..GetWorkItemExtraMain(MainID, MainStatusChildSub, "8") //联系电话 
	set $li(data, 11) = ..GetWorkItemExtraMain(MainID, MainStatusChildSub, "5") //借阅目的
	set strUser = ##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(MainStatus,"^",2))
	set $li(data, 12) = $p(strUser, "/", 3) //借出人
	set Days = $p($h,",",1) - $p(MainStatus, "^", 3)
	set $li(data, 13) = Days
	set $li(data, 14) = MainID					//add 2010-09-07 增加病案ID
	set $li(data, 15) = ""						//add 2010-09-07 增加卷ID
	set $li(data, 16) = $p(PatientData,"^", 27)	//add 2011-02-11 增加登记号
	set $li(data, 17) = ..GetWorkItemExtraMain(MainID, MainStatusChildSub, "YQGHSJ") //add 2011-02-11 预期归还时间
	quit data
BuildQueryStayOutVolume(MainID, VolID, VolStatus, VolStatusChildSub)
	n (MainID, VolID, VolStatus, VolStatusChildSub)
	set data = $lb("")
	set mainData = $g(^DHCWMRMAIN(MainID))
	set PatientData = ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainID)
	set strAdmInfo = ..GetAdmitInfoString(VolID)
	set $li(data, 1) = "病案卷"
	set $li(data, 2) = $p(mainData, "^", 2) //病案号
	set $li(data, 3) = $p(PatientData, "^", 2)
	set $li(data, 4) = $p(strAdmInfo, "^", 1)
	set $li(data, 5) = $p(strAdmInfo, "^", 3)
	set $li(data, 6) = $zd($p(VolStatus, "^", 3), 3) //借出日期
	set $li(data, 7) = $zt($p(VolStatus, "^", 4), 1) //借出时间
	set $li(data, 8) = ..GetWorkItemExtraVol(VolID, VolStatusChildSub, "1") //科别
	set $li(data, 9) = ..GetWorkItemExtraVol(VolID, VolStatusChildSub, "4") //借阅人
	set $li(data, 10) = ..GetWorkItemExtraVol(VolID, VolStatusChildSub, "8") //联系电话 
	set $li(data, 11) = ..GetWorkItemExtraVol(VolID, VolStatusChildSub, "5") //借阅目的
	set strUser = ##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(VolStatus,"^",2))
	set $li(data, 12) =  $p(strUser, "/", 3) //借出人
	set Days = $p($h,",",1) - $p(VolStatus, "^", 3)
	set $li(data, 13) = Days
	set $li(data, 14) = MainID					//add 2010-09-07 增加病案ID
	set $li(data, 15) = VolID					//add 2010-09-07 增加卷ID
	set $li(data, 16) = $p(PatientData,"^", 27)	//add 2011-02-11 增加登记号
	set $li(data, 17) = ..GetWorkItemExtraVol(VolID, VolStatusChildSub, "YQGHSJ") //add 2011-02-11 预期归还时间
	quit data
}

ClassMethod QueryLendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLendExecute ]
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

ClassMethod QueryStayOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStayOutExecute ]
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

Query QueryLend(MrType As %String, FromDate As %String, ToDate As %String, LendStatusID As %String, ReturnStatusID As %String, MRLocation As %String, Reason As %String, LendUser As %String) As %Query(ROWSPEC = "MrType:%String:病案类型,MrNo:%String:病案号,PatientName:%String:患者姓名,Sex:%String:性别,LendOutDate:%String:借阅日期,LendOutTime:%String:节约时间,LendOutDep:%String:借阅科室,LendOutUser:%String:借阅人,LendOperator:%String:借阅经手人,LendOutUserTel:%String:借阅人电话,ReturnDate:%String:归还日期,ReturnTime:%String:归还时间,ReturnUser:%String:归还人")
{
}

/// 查询未归架病案
/// w ##Class(%ResultSet).RunQuery("web.DHCWMRLendOutSta","QueryStayOut",7,10,"","","")
Query QueryStayOut(MrType As %String, StatusID As %String, DateFrom As %String, DateTo As %String, PrintFlag As %String) As %Query(ROWSPEC = "Type:%String:种类,MrNo:%String:病案号,PatientName:%String:病人姓名,AdmitDate:%String:住院日期,DisDate:%String:出院日期,LentDate:%String:借出日期,LendTime:%String:借出时间,LendDep:%String:借出科室,LendUser:%String:借阅人,Tel:%String:联系电话,Tel1:%String:科内电话,LendOutUser:%String:借出人,Days:%String:借出天数,MainID:%String:MainID,VolRowid:%String:VolRowid,PatientNo:%String:登记号,YQGHSJ:%String:预期归还时间")
{
}

/// Creator：    刘学峰
/// CreatDate：  2010-11-11
/// Description：构造借出病案打印列表数据
/// Query：      QueryStayOut
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。MrType+"^"+StatusID+"^"+DateFrom+"^"+DateTo+"^"+PrintFlag
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolumeQry).QueryMissVolumeToPrint(itmjs,strArguments)
ClassMethod QueryStayOutToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s MrType=$p(strArguments,"^",1)
	s StatusID=$p(strArguments,"^",2)
	s DateFrom=$p(strArguments,"^",3)
	s DateTo=$p(strArguments,"^",4)
	s PrintFlag=$p(strArguments,"^",5)


	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRLendOutSta:QueryStayOut")
	d ds.Execute(MrType, StatusID, DateFrom, DateTo, PrintFlag)
	s StartRow=4
	while(ds.Next())
	{	
		s Type=ds.Data("Type") 						//种类
		s MrNo=ds.Data("MrNo")					 	//病案号
		s PatientName=ds.Data("PatientName") 		//病人姓名
		s AdmitDate=ds.Data("AdmitDate") 			//住院日期
		s DisDate=ds.Data("DisDate") 				//出院日期
		s LentDate=ds.Data("LentDate") 				//借出日期
		s LendTime=ds.Data("LendTime") 				//借出时间
		s LendDep=ds.Data("LendDep") 				//借出科室
		s LendUser=ds.Data("LendUser") 				//借阅人
		s Tel=ds.Data("Tel") 						//联系电话
		s Tel1=ds.Data("Tel1") 						//科内电话
		s LendOutUser=ds.Data("LendOutUser") 		//借出人
		s Days=ds.Data("Days") 						//借出天数




		//种类,病案号,病人姓名,住院日期,出院日期,借出日期,借出时间,借出科室,借阅人,联系电话,科内电话,借出人,借出天数
		s valCells=Type_$c(1)_MrNo_$c(1)_PatientName_$c(1)_AdmitDate_$c(1)_DisDate_$c(1)_LentDate_$c(1)_LendTime_$c(1)_LendDep_$c(1)_LendUser_$c(1)_Tel_$c(1)_Tel1_$c(1)_LendOutUser_$c(1)_Days
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s DefaultHospStr=##class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospDesc=$p(DefaultHospStr,"^",3)
	s WorkItemDesc=$p($g(^DHCWMRWITM(StatusID)),"^",2)
	s valCells=HospDesc_" "_WorkItemDesc_"明细"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="出院日期："_$zd($zdh(DateFrom,4),3)_" 至 "_$zd($zdh(DateTo,4),3)_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

ClassMethod Test()
{
	//w ##class(web.DHCWMRLendOutSta).Test()
	
	d ##Class(%ResultSet).RunQuery("web.DHCWMRLendOutSta","QueryLend","","2009-12-1","2009-12-31",10,13)
	q "OK"
}

}
