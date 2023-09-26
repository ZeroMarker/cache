Import SQLUser

Class web.DHCWMRStaCollect Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 103;

/// ---------------------------------统计病案收回数量
ClassMethod GetMRInfo(repid, ind, VolID, MainInfo, FirstAdmInfo, LastAdmInfo, Days, Period, ProcessDate)
{
	//n (VolID, MainInfo, FirstAdmInfo, LastAdmInfo, Days, Period)
	set ret = ""
	
	set VolPatientInfo = ##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolID)
	Set Data=$lb("")
	set $li(Data,1) = $p(MainInfo, "^", 1)		//MainID
	set $li(Data,2) = $p(MainInfo, "^", 3)		//病案号
	set $li(Data,3) = $p(VolPatientInfo, "^", 2)	//姓名
	set $li(Data,4) = $p(FirstAdmInfo, "^", 4) 	//入院日期
	set $li(Data,5) = $p($p(LastAdmInfo, "^", 7),"/",2)	//科室
	set $li(Data,6) = $p($p(LastAdmInfo, "^", 8), "/", 2) _ "  " _  $p($p(LastAdmInfo, "^", 8), "/", 3)	//医师
	set $li(Data,7) = $p($p(LastAdmInfo, "^", 9), "-", 2)	//病房
	set $li(Data,8) = $p(LastAdmInfo, "^", 10)  //病室
	set $li(Data,9) = $p(LastAdmInfo, "^", 11)  //病床
	set $li(Data,10) = $p(LastAdmInfo, "^", 12)  //出院日期
	set $li(Data,11) = Days 					 //住院天数
	if (ProcessDate '= -1)
	{
		set $li(Data,12) = $zd(ProcessDate, 3)		 //操作日期
	}
	else
	{
		set $li(Data,12) = ""
	}
	if (Period '= 9999)
	{
		set $li(Data,13) = Period					 //出院与操作间隔
	}
	else
	{
		set $li(Data,13) = "尚未收回"
		set $li(Data,12) = ""
	}
	Set Is7DaysRec="否"
	if (($li(Data,13) '= "尚未收回")&&(+$li(Data,13)<=7))
	{
		Set Is7DaysRec="是"
    }
    set $li(Data,14)=Is7DaysRec
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

/// 计算工作日
/// From：开始时间
/// To：结束时间
/// RestDay：休息日
/// WorkDay：工作日
ClassMethod CalcDays(From, To)
{
	n (From, To)
	
	set:(From["-") From = $zdh(From,3)
	set:(To["-") To = $zdh(To,3)
	set intCounter = 0
	set intDays = 0
	set WeekDay = 0
	for intCounter=(From+1):1:To
	{
		set WeekDay = ..GetWeekDay(intCounter) //取得星期几
		continue:((WeekDay=6)!(WeekDay=7))&($d(^CacheTemp("WorkDay",$j,intCounter))=0)
		continue:((WeekDay<6))&($d(^CacheTemp("RestDay",$j,intCounter))'=0)
		set intDays = intDays + 1
	}

	quit intDays
}

ClassMethod GetCollectDay(Date)
{
  
	n (Date)
	set:Date["-" Date = $zdh(Date,3)
	set intCounter = Date
	while 1
	{
		set intCounter = intCounter - 1     
		set WeekDay = ..GetWeekDay(intCounter) //取得星期几
		continue:((WeekDay=6)!(WeekDay=7))&($d(^CacheTemp("WorkDay",$j,intCounter))=0)
		continue:((WeekDay<6))&($d(^CacheTemp("RestDay",$j,intCounter))'=0)
		quit
	}
	quit intCounter
}

/// Type:
/// Prefix:Global的前缀
/// DateList：日期列表
ClassMethod ProcessDay(Prefix, DateList)
{
	n (Prefix, DateList)
	set intCounter = 0
	for intCounter=1:1:$l(DateList, ",")
	{
		Set tmpDate = $p(DateList, ",", intCounter)
		continue:tmpDate=""
		continue:$l(tmpDate,"-")'=3	//控制格式
		set ^CacheTemp(Prefix, $j, $zdh(tmpDate,3)) = ""
	}
	quit 0
}

/// 获取某一天是星期几
ClassMethod GetWeekDay(strDate)
{
	n (strDate)
	set:strDate["-" strDate = $zdh(strDate, 3)
	set RuleDay = $zdh("2007-12-31", 3) //这天是星期二
	set CurrentDay = strDate //$zdh(Date, 3)
	set Days = CurrentDay - RuleDay
	set Remain = Days - ((Days \ 7) * 7)
	
	set tmp = Remain + 1
	quit tmp
}

ClassMethod QueryCollectDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCollectDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("WorkDay", $j)
 	Kill ^CacheTemp("RestDay", $j)
	Quit $$$OK
}

/// debug:w ##Class(%ResultSet).RunQuery("web.DHCWMRStaCollect","QueryCollectDetail",7,"2011-12-01","2012-12-21",2,4,99999,"","")
Query QueryCollectDetail(MrTypeDr As %String, From As %String, To As %String, StatusID As %String, MinPeriod As %String, MaxPeriod As %String, RestDay As %String, WorkDay As %String, LocId As %String = "") As %Query(ROWSPEC = "MainID:%String,MrNo:%String:病案号,PatientName:%String:姓名,AdmitDate:%String:住院日期,Department:%String:科室,Doctor:%String:医师,Loc:%String:病区,Ward:%String:病房,Bed:%String:床号,DisDate:%String:出院日期,Days:%String:住院天数,ProcessDate:%String:收回日期,Period:%String:间隔天数,Is7DaysRec:%String:是否七天回收")
{
}

ClassMethod QueryCollectDetailExecute(ByRef qHandle As %Binary, MrTypeDr As %String, From As %String, To As %String, StatusID As %String, MinPeriod As %String, MaxPeriod As %String, RestDay As %String, WorkDay As %String, LocId As %String = "") As %Status
{
	n (qHandle, MrTypeDr, From, To, StatusID, MinPeriod, MaxPeriod, RestDay, WorkDay,LocId)
	set ^CacheTemp("QueryCollectDetailExecute")=MrTypeDr_","_From_","_To_","_StatusID_","_MinPeriod_","_MaxPeriod_","_RestDay_","_WorkDay_","_LocId
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(MrTypeDr="")!(From="")!(To="")!(StatusID="") $$$OK
	set:MinPeriod="" MinPeriod=0
	set:MaxPeriod="" MaxPeriod=9999999
	
	d ..ProcessDay("RestDay", RestDay)
	d ..ProcessDay("WorkDay", WorkDay)
	;b ;RestDay
	//modify by liulan 2012-11-27
	//set From=$zdh(From,3)
	//set To=$zdh(To, 3)
	
	//add by liulan 2012-11-27
	set:From["-" From=$zdh(From,3)
	set:To["-" To=$zdh(To,3)
	set:From["/" From=$zdh(From,4)
	set:To["/" To=$zdh(To,4)
	
	set admID = ""
	set strDisDate = 0
	for strDisDate=From:1:To
	{
		//set admID = $o(^PAADMi("DischDate", strDisDate, admID))
		do
		{
			set admID = $o(^PAADMi("DischDate", strDisDate, admID))
			set admInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+admID)
			if ($p(admInfo,"^",2)="I")   //必须是住院病人
			{
				set VolID = ""
				while 1
				{
					set VolID = $o(^DHCWMRVOL(0,"VolAdm", admID, VolID))
					set VolInfo = $g(^DHCWMRVOL(+VolID))
					quit:$p(VolInfo,"^",7)="Y"
					quit:VolID=""
				}
				Set CTLocID=$P($g(^PAADM(+admID)),"^",4)
				Continue:(LocId'="")&&(LocId'=CTLocID)
				continue:VolInfo=""  //没找到卷信息
				set MainID = $p(VolInfo, "^", 1)
				set MainInfo = $g(^DHCWMRMAIN(+MainID))
				continue:($p(MainInfo,"^",1)'=MrTypeDr)!($p(MainInfo,"^",6)'="Y")  //检查病案类型以及是否删除
				set MainInfo = MainID _ "^" _ MainInfo
				set FirstAdmID =  $o(^DHCWMRVOL(VolID, "ADM", 0))
				set LastAdmID =  $o(^DHCWMRVOL(VolID, "ADM", ""),-1)
				//while ($o(^DHCWMRVOL(VolID, "ADM", LastAdmID)) '= "")
				//{
				//	set LastAdmID = $o(^DHCWMRVOL(VolID, "ADM", LastAdmID))
				//}
				set FirstAdmInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID,"ADM",FirstAdmID)))
				set LastAdmInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID,"ADM",LastAdmID)))
				set AdmitDate = $p(FirstAdmInfo, "^", 4)
				set DisDate = $p(LastAdmInfo, "^", 12)
				continue:(AdmitDate="")!(DisDate="")
				set AdmitDate = $zdh(AdmitDate, 3)
				set DisDate = $zdh(DisDate, 3)
				set Days = DisDate-AdmitDate
				
				set StatusInfoID = $o(^DHCWMRVOL(VolID, "S", 0, "Status", StatusID, ""))
				;w !,VolID
				;b ;VolID
				if (StatusInfoID '= "")
				{
					set StatusInfo = $g(^DHCWMRVOL(VolID, "S", StatusInfoID))
					set StatusDate = $p(StatusInfo, "^", 3)
					set:StatusDate'="" StatusDate = ..GetCollectDay(StatusDate)
					
					
					set:StatusDate="" StatusDate = 1 //$p($h, ",", 1)
				}
				else
				{
					set StatusDate = 1 //$p($h, ",", 1)
				}
				if (StatusDate '= 1)
				{
					set Period = ..CalcDays(DisDate, StatusDate) 
				}
				else
				{
					set Period = 9999
				}
				if (Period '< MinPeriod) && (Period '> MaxPeriod)
				{
					set DisplayInfo = ..GetMRInfo(repid, ind, VolID, MainInfo, FirstAdmInfo, LastAdmInfo, Days, Period, StatusDate)	
					set ind = ind + 1
				}
			}
		} while(admID '= "")
	}
	Quit $$$OK
}

ClassMethod QueryCollectDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCollectDetailExecute ]
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

ClassMethod StaCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^CacheTemp("WorkDay", $j)
 	Kill ^CacheTemp("RestDay", $j)
 	kill ^CacheTemp("StaCollect", $j)
	Quit $$$OK
}

/// w ##Class(%ResultSet).RunQuery("web.DHCWMRStaCollect","StaCollect",7,"2011-12-01","2012-11-11",2,"","")
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRStaCollect","StaCollect",7,"01/12/2012","18/12/2012",2,"","")
Query StaCollect(MrTypeDr As %String, From As %String, To As %String, StatusID As %String, RestDay As %String, WorkDay As %String) As %Query(ROWSPEC = "Dep:%String:科室,SubDep:%String:病区,DisNumber:%String:出院人数,OneDay:%String:一日收回,ThreeDay:%String:三日收回,SevenDay:%String:七日收回,SevenDayLater:%String:晚于七日,NotCollect:%String:尚未收回,Longest:%String:最迟收回天数,OnePercent:%String:一天收回率,ThreePercent:%String:三日收回率,SevenPercent:%String:七日收回率")
{
}

ClassMethod StaCollectExecute(ByRef qHandle As %Binary, MrTypeDr As %String, From As %String, To As %String, StatusID As %String, RestDay As %String, WorkDay As %String) As %Status
{
	n (qHandle, MrTypeDr, From, To, StatusID, RestDay, WorkDay)
	set ^zzz("StaCollectExecute")=MrTypeDr_","_From_","_To_","_StatusID_","_RestDay_","_WorkDay
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(MrTypeDr="")!(From="")!(To="")!(StatusID="") $$$OK
	d ..ProcessDay("RestDay", RestDay)
	d ..ProcessDay("WorkDay", WorkDay)
	
	
	//add By liulan 2012-11-27
	set:From["-" From=$zdh(From,3)
	set:To["-" To=$zdh(To,3)
	set:From["/" From=$zdh(From,4)
	set:To["/" To=$zdh(To,4)
	set admID = ""
	set strDisDate = ""
	for strDisDate=From:1:To
	{
		//set admID = $o(^PAADMi("DischDate", strDisDate, admID))
		do
		{
			set admID = $o(^PAADMi("DischDate", strDisDate, admID))
			set admInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+admID)
			if ($p(admInfo,"^",2)="I")   //必须是住院病人
			{	set VolID = $o(^DHCWMRVOL(0,"VolAdm",admID,""))
				set VolInfo = $g(^DHCWMRVOL(+VolID))
				
				continue:VolInfo=""  //没找到卷信息
				set MainID = $p(VolInfo, "^", 1)
				set MainInfo = $g(^DHCWMRMAIN(+MainID))
				continue:($p(MainInfo,"^",1)'=MrTypeDr)!($p(MainInfo,"^",6)'="Y")  //检查病案类型以及是否删除
				set MainInfo = MainID _ "^" _ MainInfo
				set FirstAdmID =  $o(^DHCWMRVOL(VolID, "ADM", 0))
				set LastAdmID = FirstAdmID
				while ($o(^DHCWMRVOL(VolID,"ADM",LastAdmID)) '= "")
				{
					set LastAdmID = $o(^DHCWMRVOL(VolID,"ADM",LastAdmID))
				}
				set FirstAdmInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID,"ADM",FirstAdmID)))
				set LastAdmInfo = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID,"ADM",LastAdmID)))
				set AdmitDate = $p(FirstAdmInfo, "^", 4)
				set DisDate = $p(LastAdmInfo, "^", 12)
				continue:(AdmitDate="")!(DisDate="")
				set AdmitDate = $zdh(AdmitDate, 3)
				set DisDate = $zdh(DisDate, 3)
				set Days = DisDate-AdmitDate
				set StatusInfoID = $o(^DHCWMRVOL(VolID,"S",0,"Status",StatusID,"")) 
				if (StatusInfoID '= "")
				{
					set StatusInfo = $g(^DHCWMRVOL(VolID,"S",StatusInfoID))
					set StatusDate = $p(StatusInfo, "^", 3)
					set:StatusDate'="" StatusDate = ..GetCollectDay(StatusDate)
					//set:StatusDate="" StatusDate = $p($h, ",", 1)
				}
				else
				{
					set StatusDate = -1 //没收回来
				}
				if (StatusDate '= -1)
				{
					set Period = ..CalcDays(DisDate, StatusDate) 
				}
				else
				{
					set Period = -1
				}
				set strDep = $p($p(LastAdmInfo, "^", 7),"/",2)	//科室
				set strSubDep = $p($p(LastAdmInfo, "^", 9), "-", 2)	//病房
				;w:strDep["中医科" admInfo_"   "_Period_" "_StatusDate ,!
				set:strDep="" strDep="其他"
				set:strSubDep="" strSubDep="其他"
				set strData = $g(^CacheTemp("StaCollect", $j, strDep, strSubDep))
				set $p(strData, "^", 1) = $p(strData, "^", 1) + 1 //出院人数
				set:(Period=1)||(Period=0) $p(strData, "^", 2) = $p(strData, "^", 2) + 1 //1天
				set:(Period>=0)&(Period'>3) $p(strData, "^", 3) = $p(strData, "^", 3) + 1 //3天
				set:(Period>=0)&(Period'>7) $p(strData, "^", 4) = $p(strData, "^", 4) + 1 //7天
				set:(Period>=0)&(Period>7) $p(strData, "^", 5) = $p(strData, "^", 5) + 1 //晚于7天
				set:(Period=-1) $p(strData, "^", 6) = $p(strData, "^", 6) + 1 //没收回来
				set:(Period>$p(strData,"^",7)) $p(strData, "^", 7) = Period //最长那天
				set ^CacheTemp("StaCollect", $j, strDep, strSubDep) = strData
			}
		} while(admID '= "")
	}
	;b ;11
	set strDep = ""
	while 1
	{
		set strDep = $o(^CacheTemp("StaCollect", $j, strDep))
		quit:strDep=""
		set strSubDep = ""
		while 1
		{
			set strSubDep = $o(^CacheTemp("StaCollect", $j, strDep, strSubDep))
			quit:strSubDep=""
			set strData = $g(^CacheTemp("StaCollect", $j, strDep, strSubDep))
			set ^CacheTemp(repid, ind) = $$BuildStaCollect(strDep, strSubDep, strData)
			set ind = ind + 1
		}
		
	}
	Quit $$$OK

BuildStaCollect(Dep, SubDep, strData)
	n (Dep, SubDep, strData)
	Set Data=$lb("")
	set $li(Data,1) = Dep
	set $li(Data, 2) = SubDep
	set $li(Data, 3) = $p(strData, "^", 1) //出院人数
	set $li(Data, 4) = $p(strData, "^", 2) //1日
	set $li(Data, 5) = $p(strData, "^", 3) //3日
	set $li(Data, 6) = $p(strData, "^", 4) //7日
	set $li(Data, 7) = $p(strData, "^", 5) //7日
	set $li(Data, 8) = $p(strData, "^", 6) //尚未回来
	set $li(Data, 9) = $p(strData, "^", 7) //最长那天
	set DisCnt = $p(strData, "^", 1)
	if (DisCnt > 0) //1天收回
	{
		set tmpPercent = $number($p(strData, "^", 2) / DisCnt * 100, 2) 
		set $li(Data, 10) = tmpPercent _ "%"
	}
	else
	{
		set $li(Data, 10) = 0
	} 
	if (DisCnt > 0) //3天收回
	{
		set tmpPercent = $number($p(strData, "^", 3) / DisCnt * 100, 2) 
		set $li(Data, 11) = tmpPercent _ "%"
	}
	else
	{
		set $li(Data, 11) = 0
	} 	
	if (DisCnt > 0) //7天收回
	{
		set tmpPercent = $number($p(strData, "^", 4) / DisCnt * 100, 2) 
		set $li(Data, 12) = tmpPercent _ "%"
	}
	else
	{
		set $li(Data, 12) = 0
	} 	
	quit Data
}

ClassMethod Test()
{
	d ##Class(%ResultSet).RunQuery("web.DHCWMRStaCollect", "StaCollect", 7,"2008-10-01","2008-11-10",15,"2008-09-29,2008-09-30,2008-10-01,2008-10-02,2008-10-03,2008-10-04,2008-10-05","2008-09-27,2008-09-28")
	//d ##Class(%ResultSet).RunQuery("web.DHCWMRStaCollect", "QueryCollectDetail", 7,"2008-10-01","2008-10-31",15,4,9999,"2008-10-01,2008-10-02,2008-10-03","")
	//d ##class(web.DHCWMRStaCollect).ProcessDay("RestDay","2008-09-29,2008-09-30,2008-10-01,2008-10-02,2008-10-03,2008-10-04,,2008-10-05")
	//d ##class(web.DHCWMRStaCollect).ProcessDay("WorkDay","2008-09-27,2008-09-28")
	//w ..CalcDays("2008-09-28","2008-10-08")
	quit ""
}

ClassMethod StaCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaCollectExecute ]
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

/// Creator：    刘兰
/// CreatDate：  2012-11-28
/// Description：构造病案未按时完成导出列表数据
/// Query：      QueryMerLateTo
/// Input：      itmjs：js处理返回值函数
/// 			 cArguments：Query入参，"^"分隔。cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^"+RestDay+"^"+WorkDay;
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRStaCollect).QueryMerLateToExport("fillxlSheet","-1^20/10/2011^20/11/2012^^^^")
///              w ##Class(web.DHCWMRStaCollect).QueryMerLateToExport("fillxlSheet","7^01/11/2011^01/11/2012^2^^^")
ClassMethod QueryMerLateToExport(itmjs As %Library.String = "", cArguments As %String) As %Status
{
	n (itmjs,cArguments)
	set Count=0
	
	set MrTypeDr=$p(cArguments,"^",1)
	set From=$p(cArguments,"^",2)
	set To=$p(cArguments,"^",3)
	set StatusID=$p(cArguments,"^",4)
	set RestDay=$p(cArguments,"^",5)
	set WorkDay=$p(cArguments,"^",6)

	set ds = ##class(%Library.ResultSet).%New("web.DHCWMRStaCollect:StaCollect")
	d ds.Execute(MrTypeDr,From,To,StatusID,RestDay,WorkDay)
	set StartRow=4
	while(ds.Next())
	{  
		set Dep=ds.Data("Dep")						//科室
		set SubDep=ds.Data("SubDep")				    //病区
		set DisNumber=ds.Data("DisNumber") 		    //出院人数
		set OneDay=ds.Data("OneDay")	                //一日收回
		set ThreeDay=ds.Data("ThreeDay")		        //三日收回
		set SevenDay=ds.Data("SevenDay")				//七日收回
		set SevenDayLater=ds.Data("SevenDayLater")	//晚于七日
		set NotCollect=ds.Data("NotCollect")			//尚未收回
		set Longest=ds.Data("Longest")				//最迟收回天数
		set OnePercent=ds.Data("OnePercent")			//一天收回率
		set ThreePercent=ds.Data("ThreePercent")		//三日收回率
		set SevenPercent=ds.Data("SevenPercent")		//七日收回率
		

		//科室,病区,出院人数,一日收回,三日收回,七日收回,晚于七日,尚未收回,最迟收回天数,一天收回率,三日收回率,七日收回率
		set valCells=Dep_$c(1)_SubDep_$c(1)_DisNumber_$c(1)_OneDay_$c(1)_ThreeDay_$c(1)_SevenDay_$c(1)_SevenDayLater_$c(1)_NotCollect_$c(1)_Longest_$c(1)_OnePercent_$c(1)_ThreePercent_$c(1)_SevenPercent
	 	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		set Count=Count+1
		set StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	set valCells="病案未按时完成查询"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	set valCells="操作日期："_$zd($zdh(From,4),3)_" 至 "_$zd($zdh(To,4),3)_"    合计:"_Count_"份"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	quit Count
}

/// Creator：    刘兰
/// CreatDate：  2012-11-28
/// Description：构造病案未按时完成明细导出列表数据
/// Query：      QueryMerLateTo
/// Input：      itmjs：js处理返回值函数
/// 			 cArguments：Query入参，"^"分隔。cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^",MinPeriod+"^",MaxPeriod+"^",RestDay+"^"+WorkDay;
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRStaCollect)QueryMerLateToDetailExport("fillxlSheet","7^01/11/2011^01/11/2012^2^^^^^")             
ClassMethod QueryMerLateToDetailExport(itmjs As %Library.String = "", cArguments As %String) As %Status
{
	n (itmjs,cArguments)
	set Count=0
	
	set MrTypeDr=$p(cArguments,"^",1)
	set From=$p(cArguments,"^",2)
	set To=$p(cArguments,"^",3)
	set StatusID=$p(cArguments,"^",4)
	set MinPeriod=$p(cArguments,"^",5)
	set MaxPeriod=$p(cArguments,"^",6)
	set RestDay=$p(cArguments,"^",7)
	set WorkDay=$p(cArguments,"^",8)
    set LocId=$p(cArguments,"^",9)
	set ds = ##class(%Library.ResultSet).%New("web.DHCWMRStaCollect:QueryCollectDetail")
	d ds.Execute(MrTypeDr,From,To,StatusID,MinPeriod,MaxPeriod,RestDay,WorkDay,LocId)
	set StartRow=4
	while(ds.Next())
	{  //Days:%String:住院天数,ProcessDate:%String:收回日期,Period:%String:间隔天数
		set MainID=ds.Data("MainID")						//MainID
		set MrNo=ds.Data("MrNo")				            //病案号
		set PatientName=ds.Data("PatientName") 		        //姓名
		set AdmitDate=ds.Data("AdmitDate")	                //住院日期
		set Department=ds.Data("Department")		        //科室
		set Doctor=ds.Data("Doctor")				        //医师
		set Loc=ds.Data("Loc")	                            //病区
		set Ward=ds.Data("Ward")			                //病房
		set Bed=ds.Data("Bed")				                //床号
		set DisDate=ds.Data("DisDate")			            //出院日期
		set Days=ds.Data("Days")		                    //住院天数
		set ProcessDate=ds.Data("ProcessDate")		        //收回日期
		set Period=ds.Data("Period")		                //间隔天数
        set Is7DaysRec=ds.Data("Is7DaysRec")                //是否7天内回收
		//MainID,病案号,姓名,住院日期,科室,医师,病区,病房,床号,出院日期,住院天数,收回日期,间隔天数
		set valCells=MainID_$c(1)_MrNo_$c(1)_PatientName_$c(1)_AdmitDate_$c(1)_Department_$c(1)_Doctor_$c(1)_Loc_$c(1)_Ward_$c(1)_Bed_$c(1)_DisDate_$c(1)_Days_$c(1)_ProcessDate_$c(1)_Period_$c(1)_Is7DaysRec
	 	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		set Count=Count+1
		set StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	set valCells="病案未按时完成明细查询"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	set valCells="操作日期："_$zd($zdh(From,4),3)_" 至 "_$zd($zdh(To,4),3)_"    合计:"_Count_"份"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	quit Count
}

Storage Default
{
<Data name="DHCWMRStaCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWMRStaCollectD</DataLocation>
<DefaultData>DHCWMRStaCollectDefaultData</DefaultData>
<IdLocation>^web.DHCWMRStaCollectD</IdLocation>
<IndexLocation>^web.DHCWMRStaCollectI</IndexLocation>
<StreamLocation>^web.DHCWMRStaCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
