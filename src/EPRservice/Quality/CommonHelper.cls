/// Class Name:  	EPRservice.Quality.CommonHelper
/// Description: 	电子病历质控系统帮助类
/// Author:	   		Zuoxiang Xie
/// LU Date:	  	2010-04-26
Class EPRservice.Quality.CommonHelper Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	过滤字符串中的特殊字符;
/// Input:	AValue为待替换字符串;
/// Return:	清理后的字符串;
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).ChangeStorageChar("")
ClassMethod ChangeStorageChar(AValue As %String) As %String
{
	s AValue = $tr(AValue,$C(0),"")
	s AValue = $tr(AValue,"~","")
	s AValue = $tr(AValue,$C(13,10),"~")
	q AValue
}

/// Desc:	将日期时间格式化为"2009-05-01 10:10:10"格式;
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ADateTime)
ClassMethod ChangeDateTime(ADateTime As %String) As %String
{
	s ret = ""
	q:(ADateTime = "") ret
	
	s Date = $p(ADateTime," ",1), Time = $p(ADateTime," ",2)
	q:(Date = "") ret
	if (Date["/")&&(($l($p(Date,"/",2))=1)||($l($p(Date,"/",3))=1))
	{
		s Date=$replace(Date,"/","年","",1)	
		s Date=$replace(Date,"/","月","",1)	
		s Date=	Date_"日"
		s Date = $zdh(Date,16)
	}
	s:(Date["年") Date = $tr(Date,"年","-"), Date = $tr(Date,"月","-"), Date = $tr(Date,"日","")
	s:(Date["-") Date = $zdh(Date,3)
	s:(Date["/") Date = $zdh(Date,4)
	s Date = +Date
	
	s:(Time[":") Time = $zth(Time,1)
	s Time = +Time
	
	s Date = $zd(Date,3)
	s Time = $zt(Time,1)
	
	s ret = Date_" "_Time
	q ret
}

/// Desc:	将日期时间格式转换为系统格式(日期与时间之间用空格分隔);
/// Debug: 	w ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys("2010年10月10日 10:10:10")
ClassMethod ChangeTimeToSys(ADateTime As %String) As %String
{
	s ret = ""
	q:(ADateTime = "") ret
	s Date = $p(ADateTime," ",1),Time=$p(ADateTime," ",2)
	q:(Date = "") ret
	if ((Date [ "/")&&($l($p(Date,"/",1))>2))
	{
		for i=1:1:$l(Date,"/")
		{
			s TmpData=$p(Date,"/",i)
			s:(((+TmpData)<=9)&&($l(TmpData)=1)) $p(Date,"/",i)="0"_TmpData
			
		}
		s Date=$replace(Date,"/","-")
	}
	s:(Date [ "年") Date = $tr(Date,"年","-"),Date = $tr(Date,"月","-"),Date = $tr(Date,"日","")
	s:(Date [ "-") Date = $zdh(Date,3)
	s:(Date [ "/") Date = $zdh(Date,4)
	s Date = +Date
	s:(Time [ ":") Time = $zth(Time,1)
	s Time = +Time
	s ret = Date_" "_Time
	q ret
}

/// Desc:	计算两个日期时间差(精确到小时)
/// Input : ADateTime1 时间1
///         ADateTime2 时间2
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap("2009-05-24 10:10:10","2009-05-25 10:10:10")
ClassMethod GetDateTimeGap(ADateTime1 As %String, ADateTime2 As %String) As %String
{
	s ret = 0
	s DateTime1 = ..ChangeDateTime(ADateTime1)
	s DateTime2 = ..ChangeDateTime(ADateTime2)
	s Date1 = $p(DateTime1," ",1),Time1 = $p(DateTime1," ",2)
	s Date2 = $p(DateTime2," ",1),Time2 = $p(DateTime2," ",2)
	q:(Date1 = "")||(Date2 = "")||(Time1 = "")||(Time2 = "") ret
	
	s ret = 1
	
	s Date1 = $zdh(Date1,3),Time1 = $zth(Time1,2)
	s Date2 = $zdh(Date2,3),Time2 = $zth(Time2,2)
	s cDay = 0, cSecond = 0
	s cDay = Date1 - Date2
	s cSecond = (Time1 - Time2)/3600
	s ret = cDay * 24 + cSecond
	q ret
}

/// Desc:	Convert string to list, if assigned <AFlag> to Y(Case-insenstive),then omit the same elements
/// Input:	AValue indicate the given string to be converted
/// 		AChar indicate the split character
/// 		AFlag indicate whether omit the empty elements or not
/// Return:	String splited by <AChar>
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).GetListFromString("无\\\无\无\无\无\无\\\无","\")
ClassMethod GetListFromString(AValue As %String, AChar As %String, AFlag As %String = "Y") As %List
{
	s ret = ""
	s $zt="GetListFromStringErr"
	s:$g(AChar)="" AChar=","
	s tmpVal="",tmpRet=""
	for Ind=1:1:$length(AValue,AChar)
	{
		s tmpVal = $p(AValue,AChar,Ind)
		continue:($zcvt(AFlag,"U") = "Y")&&(tmpVal = "")
		//continue:($zcvt(AFlag,"U") = "Y")&&(tmpRet '= "")&&($listfind(tmpRet,tmpVal) > 0)
		s tmpRet = tmpRet_$lb(tmpVal)
	}
	s ret = tmpRet
	q ret
GetListFromStringErr
   	q ""
}

/// Desc:		Convert list to string, if assigned <AFlag> to Y(Case-insenstive),then omit the same elements
/// Input:		AValue indicate the given list to be converted
/// 			AChar indicate the split character
/// 			ADuplicateFlag indicate whether omit the same elements or not
/// 			ANullableFlag indicate whether allow null value
/// Return:		String splited by <AChar>
/// Debug:		s lstTest = $lb("a","","b","c","a","","d")
/// 			w ##Class(EPRservice.Quality.CommonHelper).GetListToString(lstTest,"#")				Result:	a#b#c#a#d
/// 			w ##Class(EPRservice.Quality.CommonHelper).GetListToString(lstTest,"#","Y")			Result:	a#b#c#d
/// 			w ##Class(EPRservice.Quality.CommonHelper).GetListToString(lstTest,"#","Y","Y")		Result:	a##b#c##d
/// 			w ##Class(EPRservice.Quality.CommonHelper).GetListToString(lstTest,"#","N","Y")		Result:	a##b#c#a##d
ClassMethod GetListToString(AValue As %List, AChar As %String, ADuplicateFlag As %String = "N", ANullableFlag As %String = "N") As %String
{
	s ret = ""
	s $zt = "GetListToStringErr"
	s:($g(AChar) = "") AChar = ","
	
	s tmpVal = "", tmpRet = ""
	for Ind = 1:1:$listlength(AValue)
	{
		s tmpVal = $listget(AValue,Ind)
		continue:($zcvt(ANullableFlag,"U") = "N")&&(tmpVal = "")
		continue:($zcvt(ADuplicateFlag,"U") = "Y")&&(tmpVal '= "")&&(tmpRet '= "")&&($f(tmpRet_AChar,AChar_tmpVal_AChar) > 0)
		s tmpRet = tmpRet_AChar_tmpVal
	}
	s ret = $e(tmpRet,2,$length(tmpRet))
	q ret
GetListToStringErr
   q ""
}

/// Desc:	判断给定的项目是否存在于给定的列表中;
/// Input:	AList为给定的列表;
/// 		AItem为给定的查询项目;
/// 		AFlag=1判断恒等关系;AFlag=2判断包含关系;
/// Return:	ret=1表示为真;ret=0表示参数不合法;ret=-1表示为假;
/// Debug:	s list = $lb("aa","ab","bc")
/// 		w ##Class(EPRservice.Quality.CommonHelper).CheckItemExistInList(list,"aa",1)
ClassMethod CheckItemExistInList(AList As %List, AItem As %String, AFlag As %String = "1") As %String
{
	s ret = 0
	q:($listlength(AList) = 0)||(AItem = "") ret
	
	s ret = -1
	s item = $g(AItem)
	s list = $g(AList)
	
	for i = 1:1:$listlength(list)
	{
		s curItem = $listget(list,i)
		if (AFlag = 1)
		{
			if (curItem = item)
			{
				s ret = 1
				q
			}
		}
		elseif (AFlag = 2)
		{
			if (curItem [ item)
			{
				s ret = 1
				q
			}	
		}	
	}
	
	q ret
}

/// Desc:	判断患者本次就诊是否有效
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(AEpisodeID)
ClassMethod CheckAdmUserful(AEpisodeID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "") ret
	
	// 宁医附院通过医疗结算出院状态为"自动退院"判断就诊无效
	s tmp = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischCondit(AEpisodeID)
	q:(tmp [ "自动退院") ret
	
	// 其他医院通过就诊状态为"Cancel"判断就诊无效
	s VisitStatus = $p($g(^PAADM(+AEpisodeID)),"^",20)
	q:(VisitStatus '= "A")&&(VisitStatus '= "D") ret
	 
	// PAADM_MotherAdm_DR
	q:($p($g(^PAADM(+AEpisodeID)),"^",75) '= "") ret
	
	s ret = 1
	q ret
}

/// Desc:	检验用户是否具有某种权限（Medtrak的权限设置）
/// Input:	UserGroupId为用户安全组RowID;
/// 		ModuleName为模块名称;
/// 		MenuName为菜单名称;
/// Return:	返回0代表有权限
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).UserFunction()
ClassMethod UserFunction(UserGroupId, ModuleName, MenuName) As %String
{
	s Config = ##Class(websys.Configuration).%OpenId(1)
    s MEDDATA = Config.DataNamespace
    s LABDATA = Config.LabDataNamespace
    s CurrentNS = $ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret = $$UserFunction^SMLUserFunc(UserGroupId,ModuleName,MenuName)
	zn CurrentNS
	q ret
}

/// Desc:	统一将日期转换成数字
/// Input:	ADate格式形如2009年12月24日、2009-12-24或24/12/2009
/// w ##Class(EPRservice.Quality.CommonHelper).ChangeDateToNum(Date)
ClassMethod ChangeDateToNum(ADate As %String) As %String
{
	s ret = ""
	q:(ADate = "") ret
	
	s Date = $g(ADate)
	s Date = $tr(Date," ","")
	if (Date [ "年") 
	{
		s Date = $tr(Date,"年","-")
		s Date = $tr(Date,"月","-")
		s Date = $tr(Date,"日","")
	}
	s:(Date [ "/") Date = $zdh(Date,4)
	s:(Date [ "-") Date = $zdh(Date,3)
	
	q Date
}

/// 通过生日计算年龄
/// 输入格式：数字格式   +$h
/// w ##Class(EPRservice.Quality.CommonHelper).CalculateAge(IBirth,IToday)
ClassMethod CalculateAge(IBirth, IToday)
{
	s (XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB)=""
	s IBirth=$g(IBirth),IToday=$g(IToday)
	if IBirth>2980000 s IBirth=""
	if IBirth<0 s IBirth=""
	q:'$g(IBirth) ""
	s XBirth=$ZD(IBirth)
	s XToday=$ZD(IToday)
	s AgeMth=XToday-XBirth
	s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
	s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
	s AgeYear=CurrYear-BirthYear
	If (AgeDay<0)
	{
		s AgeMth=AgeMth-1
		s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
		q:XToday'=2
		s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	}
	If AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	if ($p(AgeYr,"|",12)>0)
	{
		s reage=$p(AgeYr,"|",12)_"岁"
	}
	else
	{
		if (AgeMth>0)
		{ s reage=AgeMth_"月" }
		else
		{ s reage=AgeDay_"天" }
	}
	q reage
}

/// Desc:	字符串多字符替换
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).ChangeString(Val,FromStr,ToStr)
ClassMethod ChangeString(Val As %String, FromStr As %String, ToStr As %String) As %String
{
	s ret=..GetListToString(..GetListFromString(Val,FromStr),ToStr)
	q ret
}

/// Desc:	清除字符串非法字符  如：清除字符串“A /B无”中的“ ”、“/”、“无”等
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).ClearChar(Val, CharSTR)
ClassMethod ClearChar(Val As %String, CharSTR As %String) As %String
{
	s ret=Val
	q:(Val="")||(CharSTR="") ret
	for i=1:1:$l(CharSTR) {
		s tmpChar=$e(CharSTR,i,i)
		s Val=$tr(Val,tmpChar,"")
	}
	s ret=Val
	q ret
}

/// Desc:	获取Http服务器信息(Trakcare的服务器，不是Medtrak的)
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).GetServerInfo()
ClassMethod GetServerInfo() As %String
{
    s CurrentNS = $ZNSPACE
	s Config = ##Class(websys.Configuration).%OpenId(1)
    s MEDDATA = Config.DataNamespace
    s LABDATA = Config.LabDataNamespace
    //s Server = Config.WebServer
    s Server = $p(Config.LayoutManager,":",2)
    s Path = Config.PathToReports
    s LayOutManager = Config.LayoutManager
    s WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp 	//获取CSP服务器的IP地址以及程序路径
   	//s WebServerAppURL = "http://127.0.0.1"_Config.PathToApp 			//获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s ret = CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q ret
}

/// Desc:	同步在院或出院自动任务标准质控项目的分数
/// Input:	ARuleCode为在院或出院自动任务标准的代码;
/// 		AType=E代表完整性项目;AType=U表示一致性项目;
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).SyncEntryScore("R001","E")
ClassMethod SyncEntryScore(ARuleCode As %String, AType As %String) As %String
{
	s ret = 1
	s $zt = "ErrorHandlerSync"
	
	s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",ARuleCode,""))
	q:(RuleID = "") "质控标准不存在!"
	
	TStart
	
	s Count = 1
	s EntryID = ""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_RuleID,EntryID))
		q:(EntryID = "")
		
		s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))

		s PoolID = $list(objEntry,1)
		s EntryScore  = $list(objEntry,4)
		
		s objPool = $g(^DHCEPRM.QualityPoolD(PoolID))
		
		s Type = $list(objPool,5)
		continue:(Type '= $zcvt(AType,"U"))

		s ScoreID = $o(^DHCEPRM.QualityEntryScoreI("IdxEntry"," "_EntryID,""))
		continue:(ScoreID '= "")
		
		k SQLCODE
		&sql(INSERT INTO EPRmeta_Quality.QualityEntryScore(EntryID,EntryScore,StartDate,EndDate,IsActive,ResumeText) VALUES(:EntryID,:EntryScore,'2000-01-01 00:00:00','2050-01-01 00:00:00','Y',''))	
		if (SQLCODE < 0)
		{
			s ret = -1
			q	
		}
		
		k SQLCODE
		&sql(UPDATE EPRinstance_Quality.QualityResultDetail SET EntryScore = :EntryScore WHERE EntryDR = :EntryID)
		if (SQLCODE < 0)
		{
			s ret = -2
			q	
		}
		
		s Count = Count + 1
		
		q:(Count = 2000)
	}
	
	if (ret = 1)
	{
		TCOMMIT
	}
	else
	{
		TROLLBACK
	}
	q ret_"^"_Count
	
ErrorHandlerSync
	TROLLBACK
	s ret = -3
	q ret
}

/// ARuleCode只能为在院自动任务标准的代码
/// w ##Class(EPRservice.Quality.CommonHelper).ClearGarbageData("R002")
ClassMethod ClearGarbageData(ARuleCode As %String) As %String
{
	s ret = 1
	s $zt = "ErrorHandlerClear"
	
	s RuleID =  $o(^DHCEPRM.QualityRuleI("IdxCode",ARuleCode,""))
	q:(RuleID = "") "无法获取质控标准RowID!"
	
	TSTART
	
	s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleID"," "_RuleID,ResultID))
		q:(ResultID = "")
		
		s objResult = $g(^DHCEPRQ.QualityResultD(ResultID))
		
		s EpisodeID = $list(objResult,3)
		
		s objPaAdm = $g(^PAADM(+EpisodeID))
		
		s VisitStatus = $p(objPaAdm,"^",20)
		if ($zcvt(VisitStatus,"U")  = "D")
		{
			s Status = ##Class(EPRinstance.Quality.QualityResult).%DeleteId(ResultID)
			if ('$$$ISOK(Status))
			{
				s ret = -1
				q 	
			}
		}	
	}
	
	if (ret > 0)
	{
		TCOMMIT	
	}
	else
	{
		TROLLBACK	
	}
	
	q ret

ErrorHandlerClear
	TROLLBACK
	s ret = -1
	q ret
}

/// 20120525 wangwnetao add 
/// AStructName, ACurrentTime, ADateTime, AHours, ASavedFlag,ACheckType , AForcedRefFlag = "1", ATimeoutCtlFlag = "0"
ClassMethod GetQualityPromptByCheckType(AStructName As %String, ACurrentTime As %String, ADateTime As %String, AHours As %String, ASavedFlag As %String, ACheckType As %String, AForcedRefFlag As %String = "1", ATimeoutCtlFlag As %String = "0", AAppointTimeCtlFlag As %String = "0") As %String
{
	//b "s"
	
	s ret = 0
	q:(ACurrentTime = "")||(ADateTime = "")||(AHours = "")||(ASavedFlag = "")||(ACheckType = "") ret
	
	
	//用于提示列表
	if ($zcvt(ACheckType,"U")="CHECKPROMPT")
	{
		s ret = 1
		
		s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ACurrentTime,ADateTime,"Y")
		q:(tmpHours < 0) ret
		
		s Hours = +AHours
		s Interval = tmpHours - Hours
		s:(Interval < 0) Interval = -Interval
		s Interval = $j(Interval,3,1)
		
		//提示详细参考标志
		if (AForcedRefFlag=1)
		{
			if (ASavedFlag < 1)
			{
				//超时之后再提示的标志
				if (ATimeoutCtlFlag = 1)
				{
					s errInfo="未超时未完成!"
					s:(tmpHours >= Hours) ret=-1,errInfo = "参考时间"_ADateTime_",超时"_Interval_"小时未完成!"
					s ret = ret_"^"_errInfo
				}
				else
				{
					s:(tmpHours < Hours) ret=-1,errInfo = "参考时间:"_ADateTime_",请在"_Interval_"小时内完成!"
					s:(tmpHours > Hours) ret=-1,errInfo = "参考时间"_ADateTime_",超时"_Interval_"小时未完成!"
					s ret = ret_"^"_errInfo
				}

			}
			else
			{
				//超时已完成,必须在规定时间内完成,才能通过.
				if (AAppointTimeCtlFlag= 1)
				{
					//b "s"
					if (tmpHours > Hours)
					{
						s ret=-1,errInfo = "参考时间"_ADateTime_",超时"_Interval_"小时完成!" ,ret = ret_"^"_errInfo
					}
					else
					{
						s ret = "1^"_AStructName_"规定时间内已完成!"
					}
				}
				else
				{
					s ret = "1^"_AStructName_"已完成!"
				}
			}	
		}
		else
		{
			if (ASavedFlag < 1)
			{
				//超时之后再提示的标志
				if (ATimeoutCtlFlag = 1)
				{
					s:(tmpHours > Hours) ret=-1,errInfo = AStructName_"超时未完成!",ret = ret_"^"_errInfo
				}
				else
				{
					s errInfo="未超时未完成!",ret = ret_"^"_errInfo
				}
				
			}
			else
			{
				//超时已完成,必须在规定时间内完成,才能通过.
				if (AAppointTimeCtlFlag= 1)
				{
					//b "s"
					if (tmpHours > Hours)
					{
						s ret=-1,errInfo = "超时完成!" ,ret = ret_"^"_errInfo
					}
					else
					{
						s ret = "1^"_AStructName_"规定时间内已完成!"
					}
				}
				else
				{
					s ret = "1^"_AStructName_"已完成!"
				}
			}
		}
	}
	//用于自动任务
	elseif ($zcvt(ACheckType,"U")="CHECKDISCH")||($zcvt(ACheckType,"U")="CHECKADMIT")
	{
		//b "s"
		s ret = 2
		
		s IsDocSavedDateTime = ACurrentTime
		s IsDocSavedFlag = ASavedFlag
			
		s hours = +$g(AHours)
		s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(IsDocSavedDateTime,ADateTime,"Y")
		q:(tmpHours < 0) ret
		
		if (tmpHours > hours)
		{
			s interval = tmpHours - hours
			s interval = $j(interval,3,1)
			
			//已完成已超时
			if (IsDocSavedFlag = 1)
			{	
				s errInfo = "参考时间:"_ADateTime_",超时"_interval_"小时已完成!"
				s ret = "-1"_"^"_errInfo
			}
			//未完成已超时
			else
			{
				s errInfo = "参考时间:"_ADateTime_",超时"_interval_"小时未完成!"
				s ret = "-1"_"^"_errInfo
			}		
		}
	}
	else
	{
		//
	}


	q ret
}

/// 解密JS加密字符串
ClassMethod UnEscape(InStr As %String) As %String
{
	s num=1,retStr="",tmpNum=1	
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num) 
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

/// Desc: 判断表达式
/// Creator:Candyxu
/// Create Date: 2012-11-23
/// Input:value1:做比较的值1,operator:比较符号,value2：做比较的值2
ClassMethod GetExpress(value1 As %String, operator As %String, value2 As %String) As %String
{
	q:(operator = ">=")&&(value1 < value2) 0
	q:(operator = "=")&&(value1 '= value2) 0
	q:(operator = "<=")&&(value1 > value2) 0
	q 1
}

/// Desc:	判断患者是否指定院区患者
/// Debug:	w ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(AEpisodeID,AHospitalID)
ClassMethod IsCurrentHosPat(AEpisodeID As %String, AHospitalID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHospitalID="") ret
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
    s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	
	s objCtLoc = $g(^CTLOC(+AdmLocID))
	s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
	q:(HospitalDR'=AHospitalID) ret
	s ret = 1
	q ret
}

/// Desc:  统一时间输出格式
/// Input: ArgDateTimeValue:需要输出的日期或时间（需为系统格式）
///       IsDataOrTime:"DateTime"日期时间，"Date"日期，"Time"时间
/// Ouput: HIS统一的时间格式
/// Debug: w ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat("65734 54477","DateTime","ChangeToFormat")
///       w ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat("65734","Date","ChangeToFormat")
///       w ##Class(EPRservice.Quality.CommonHelper).UnifiedTimeFormat("54477","Time","ChangeToFormat")
ClassMethod UnifiedTimeFormat(ArgDateTimeValue As %String, IsDataOrTime As %String, IsFormat As %String = "ChangeToFormat")
{
	s ret=""
	q:(IsFormat="")||(IsDataOrTime="")||(ArgDateTimeValue="") ret
	
	s flag=##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.Util.DateTimeFormat||GetHISStandardDateTimeFormat")
	if (flag=1)
	{
		s ret=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat(IsFormat,IsDataOrTime,ArgDateTimeValue)
	}
	else
	{
		s:(IsDataOrTime="Date") ret=$zd(ArgDateTimeValue,3)
		s:(IsDataOrTime="Time") ret=$zt(ArgDateTimeValue,1)
		s:(IsDataOrTime="DateTime") ret=$zd($p(ArgDateTimeValue," ",1),3)_" "_$zt($p(ArgDateTimeValue," ",2),1)
	}
	q ret
}

/// 是否启用新版质控维护程序
/// Debug: w ##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()
ClassMethod IsBSQualityEnable()
{
	s ret="N"
    s ParamsID=$o(^CT.MA.QC.QualityParamsI("IdxCode","IsEnabled",""))
    q:(ParamsID="") ret
    s objPatams=##class(CT.MA.QC.QualityParams).%OpenId(ParamsID)
    q:(objPatams="") ret
    s IsActive=objPatams.IsActive
    q:(IsActive'="Y") ret
    s BindValue=objPatams.BindValue
    q:(BindValue'="Y") ret
    s ret="Y"
    q ret
}

/// 指定参数是否启用
/// Debug: w ##Class(EPRservice.Quality.CommonHelper).IsParamsEnable("IsEnableDRG")
ClassMethod IsParamsEnable(AParamsCode As %String)
{
	s ret="N"
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()
	if (IsBSQualityEnable="Y")
	{
    	s ParamsID=$o(^CT.MA.QC.QualityParamsI("IdxCode",AParamsCode,""))
    	q:(ParamsID="") ret
    	s objPatams=##class(CT.MA.QC.QualityParams).%OpenId(ParamsID)
	}
	else
	{
		s ParamsID=$o(^DHCEPRM.QualityParamsI("IdxCode",AParamsCode,""))
    	q:(ParamsID="") ret
    	s objPatams=##class(EPRmeta.Quality.QualityParams).%OpenId(ParamsID)
		
	}
    q:(objPatams="") ret
    s IsActive=objPatams.IsActive
    q:(IsActive'="Y") ret
    s BindValue=objPatams.BindValue
    q:(BindValue'="Y") ret
    s ret="Y"

    q ret
}

/// Desc:将"2022/1/16" 转换为"2022-01-16"
/// Input:Date
/// Output:Date
/// Creator:wzl 2023年1月16日
/// Debug:w ##class(EPRservice.Quality.CommonHelper).DateFormat("2022/1/16")
ClassMethod DateFormat(Date As %String)
{
	
	q:(Date="") Date
	
	for i=1:1:$l(Date,"/")
	{
		s data=$p(Date,"/",i)
		
		s:(data<=9)&&(data'["0") $p(Date,"/",i)="0"_data
		
	}
	
	s Date=$replace(Date,"/","-")
	
	q Date
}

}
