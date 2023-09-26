/// 监控中心的自动处理核心程序
/// 作者：李阳
/// 创建日期：2012-06-14
Class DHCMed.CCService.AutoProcess.CoreVM Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// <H3>功能：自动监控的主处理函数</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>需要监控的主题ID，参见类<B>DHCMed.CC.Subject</B></LI>
/// <LI><B>FromDate </B>监控开始日期，格式:Cache日期格式或YYYY-MM-DD</LI>
/// <LI><B>ToDate   </B>监控结束日期，格式:Cache日期格式或YYYY-MM-DD</LI>
/// <LI><B>EpisodeID</B>就诊号（可选），处理单个人数据时传此参数</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 成功返回"OK"，错误返回错误捕获信息。
/// <H4>备注</H4>
/// 自动监控日志记录在<B>^DHCMed.CC.CtlResultL("CtlLog")</B>中。
/// 类库运行异常，系统会将错误日志存储在类<B>DHCMed.CC.ErrorLog</B>中，管理员应该经常检查此实体类的内容。
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).Process("9","2014-03-01","2014-03-16")
ClassMethod Process(aSubjectID As %Integer, aFromDate As %Date, aToDate As %String, aEpisodeID As %String = "", aSubCatCode As %String = "", aKeywordCode As %String = "") As %String
{
	New (aSubjectID, aFromDate, aToDate, aEpisodeID, aSubCatCode, aKeywordCode)
	Set return=""
	Quit:(aSubjectID="")||(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set $ZT="ProcessErr"
	
	//获取临时Global进程号
	Set repid=$I(^CacheTemp)
	Set ctlDate=+$h
	
	//清除监控结果历史数据(防止多次调用引起的数据重复)
	//Modified By LiYang 2012-11-21 不再删除旧的监控记录，保留所有监控记录。并在监控前判断如果该PAADM该主题已经监控则不再监控
	//Do ##class(DHCMed.CC.CtlResult).ClearData(aFromDate,aToDate,aSubjectID,"","") 
	//清除监控摘要历史数据(防止多次调用引起的数据重复)
	//程序可以重复处理数据，不需要清除监控摘要历史数据
	//Do ##class(DHCMed.CC.CtlSummary).ClearData(aFromDate,aToDate,aSubjectID,aEpisodeID)
	
	Kill ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3))
	
	//获取监控项目列表
	//^CacheTemp(repid,"CtlItem")
	Kill ^CacheTemp(repid,"CtlItem")
	Set flg=..GetCtlItemList(repid,aSubjectID,aSubCatCode,aKeywordCode)
	If flg'="OK" {
		Kill ^CacheTemp(repid)
		Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"GetCtlItemList")=flg
	}
	
	//获取就诊列表
	//^CacheTemp(repid,"CtlPaadm")
	Kill ^CacheTemp(repid,"CtlPaadm")
	If aEpisodeID="" {
		Set flg=..GetCtlPaadmList(repid,aFromDate,aToDate)
		If flg'="OK" {
			Kill ^CacheTemp(repid)
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"GetCtlPaadmList")=flg
		}
	} Else {
		Set ^CacheTemp(repid,"CtlPaadm",aEpisodeID)=""
	}
	
	//按天执行监控,并同步保存监控结果
	Set flg=..ExamPaadmList(repid,aSubjectID,aFromDate,aToDate)
	If flg'="OK" {
		Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ExamPaadmList")=flg
	} Else {
		Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ExamPaadmList")="OK"
	}
	
	For ctlDate=aFromDate:1:aToDate {
		//计算合计信息
		//Set flg=..CalcSummary(aSubjectID,ctlDate,aEpisodeID)
		//If flg'="OK" {
		//	Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CalcSummary",$zd(+ctlDate,3))=flg
		//} Else {
		//	Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CalcSummary",$zd(+ctlDate,3))="OK"
		//}
		
		//同步更新时间线数据
		Set flg=..ProTimeLine(aSubjectID,ctlDate,aEpisodeID)
		If flg'="OK" {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ProTimeLine",$zd(+ctlDate,3))=flg
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ProTimeLine",$zd(+ctlDate,3))="OK"
		}
	}
	
	/************************************************************************
	//update by zf 2013-07-29     避免程序重复执行
	//把生成转科记录转移到【DHCMed.CCService.AutoProcess.AutoWorkService】类中
	//执行命令【w ##Class(DHCMed.CC.CtlAdmTrans).ProAdmTrans(StartDate,EndDate)】
	Set flg=..ProAdmTrans(repid)
	If flg'="OK" {
		Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ProAdmTrans")=flg
	} Else {
		Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"ProAdmTrans")="OK"
	}
	*************************************************************************/
	
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	
	Quit "OK"
	
ProcessErr
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	Quit $ZError
}

ClassMethod ProInHospPatLog(repid As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid, aFromDate, aToDate)
	Set return=""
	
	Set $ZT="ProInHospPatLogErr"
	
	Set Paadm=0
	For {
		Set Paadm=$o(^CacheTemp(repid,"CtlPaadm",Paadm))
		Quit:Paadm=""
		
		//Set AdmitDate=$p($g(^PAADM(Paadm)),"^",6)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		//Update by pylian 2016-01-21 修改出院时间取值方式
		//Set DischDate=$p($g(^PAADM(Paadm)),"^",59)
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DischDate=$p(DischDateTime,"^",1)
	
		Set AdmStatus=$p($g(^PAADM(Paadm)),"^",20)
		Set:AdmStatus'="D" DischDate=""
		Set:DischDate="" DischDate=+$h-1
		Continue:aFromDate>DischDate
		Continue:aToDate<AdmitDate
		
		For tmpDate=aFromDate:1:aToDate {
			//add by LiuYH 2012-12-13 记录每天患者在院情况
			Set flg=##class(DHCMed.NINF.Srv.InHospPatList).UpdateByPaadm(Paadm,tmpDate)
		}
	}
	
	Quit "OK"
	
ProInHospPatLogErr
	Quit $ZError
}

/// <H3>功能：初始化监控结果汇总信息</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>需要监控的主题ID，参见类<B>DHCMed.CC.Subject</B></LI>
/// <LI><B>FromDate </B>监控开始日期，格式:Cache日期格式或YYYY-MM-DD</LI>
/// <LI><B>ToDate   </B>监控结束日期，格式:Cache日期格式或YYYY-MM-DD</LI>
/// <LI><B>EpisodeID</B>就诊号（可选），处理单个人数据时传此参数</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 成功返回"OK"，错误返回错误捕获信息。
/// <H4>备注</H4>
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).InitSummary("16","2009-01-01","2009-01-03")
ClassMethod InitSummary(aSubjectID As %Integer, aFromDate As %Date, aToDate As %String, aEpisodeID As %String = "") As %String
{
	New (aSubjectID, aFromDate, aToDate, aEpisodeID)
	Set return=""
	Quit:(aSubjectID="")||(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set $ZT="InitSummaryErr"
	
	For ctlDate=aFromDate:1:aToDate {
		//初始化监控结果汇总日志
		If '$d(^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CtlSummary",$zd(+ctlDate,3))) {
			Continue
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CtlSummary",$zd(+ctlDate,3))=""
		}
		
		//计算合计信息
		Set flg=..CalcSummary(aSubjectID,ctlDate,aEpisodeID)
		If flg'="OK" {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CtlSummary",$zd(+ctlDate,3))=flg
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CtlSummary",$zd(+ctlDate,3))="OK"
		}
	}
	
	Quit "OK"
	
InitSummaryErr
	Quit $ZError
}

/// <H3>功能：处理每条就诊信息的监控</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>repid</B>临时Global进程号</LI>
/// <LI><B>aSubjectID</B>监控主题</LI>
/// <LI><B>aCtlDate</B>监控日期</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功，返回字符串 "OK"
/// <H4>备注</H4>
/// 如果类库产生了运行异常，系统会将错误日志存储在类<B>DHCMed.CC.ErrorLog</B>中，管理员应该经常检查此实体类的内容。
ClassMethod ExamPaadmList(repid As %String, aSubjectID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aSubjectID,aFromDate,aToDate)
	Quit:(repid="")||(aSubjectID="")||(aFromDate="")||(aToDate="") "Error"
	
	Set $ZT="ExamPaadmListErr"
	
	//Set %AutoRunFlag=1         //自动业务处理标志
	
	//初始化加载配置项目
	Do ..GetVMConfig(aSubjectID,"S")
	
	Set Paadm=0
	For {
		Set Paadm=$o(^CacheTemp(repid,"CtlPaadm",Paadm))
		Quit:Paadm=""
		
		//Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
		Set AdmDate=$p(AdmDateTime,"^",1)
		//Update by pylian 2016-01-21 修改出院时间取值方式
		//Set DischDate=$p($g(^PAADM(Paadm)),"^",17)
		Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DischDate=$p(DischDateTime,"^",1)
		
		Continue:AdmDate>aToDate
		Continue:(DischDate'="")&&(DischDate<aFromDate)
		
		//w "Paadm="_Paadm,!
		
		Set %PAADM=Paadm           //就诊号
		Set %EpisodeID=Paadm       //就诊号
		Set %FromDate=aFromDate    //开始日期
		Set %ToDate=aToDate        //结束日期
		Set %CurrentDate=+$h       //当前日期
		Set %TotalScore=0          //得分情况
		Set %TotalFireItmCnt=0     //触发项目计数
		Set %TotalFireItmType=0    //触发项目类别计数
		Set %DetailList=$lb("")    //触发项目明细
		
		//初始化加载配置项目
		Do ..GetVMConfig(aSubjectID,"L")
		Set ItemID=""
		For {
			Set ItemID=$o(^CacheTemp(repid,"CtlItem",ItemID))
			Quit:ItemID=""
			
			Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
			Continue:'$IsObject(objItem)
			
			//判断监控项目是否只运行一次
			Set RunOnce=+objItem.IsRunOnce
			If (RunOnce>0) {
				Continue:$d(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",Paadm,ItemID))
			}
			
			//运行监控表达式,获取监控结果
			Set ItemExp=$g(^CacheTemp(repid,"CtlItem",ItemID,"Expression"))    //解析后的监控表达式
			Set KeyWord=$g(^CacheTemp(repid,"CtlItem",ItemID,"KeyWord"))       //关键字
			
			Set %ExtraData=$lb("")
			Set %ExtraDataCnt=0
			Set %ErrorData=$lb("")
			Set %ErrorDataCnt=0
			
			Set expResult=##class(DHCMed.CCService.AutoProcess.CoreLib).RunExpression(ItemExp)
			If $li(expResult,1)="OK" {
				If $li(expResult,2)>0 {
					For indData=1:1:$ListLength(%ExtraData) {
						Set itm=$lg(%ExtraData,indData)
						Continue:itm=""
						
						Set:$p(itm,$c(3),2)["-" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),3)
						Set:$p(itm,$c(3),2)["/" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),4)
						Set:$p(itm,$c(3),3)[":" $p(itm,$c(3),3)=$zth($p(itm,$c(3),3),1)
						
						Set:$p(itm,$c(3),8)["-" $p(itm,$c(3),8)=$zdh($p(itm,$c(3),8),3)
						Set:$p(itm,$c(3),8)["/" $p(itm,$c(3),8)=$zdh($p(itm,$c(3),8),4)
						Set:$p(itm,$c(3),9)[":" $p(itm,$c(3),9)=$zth($p(itm,$c(3),9),1)
						
						Set:$p(itm,$c(3),11)["-" $p(itm,$c(3),11)=$zdh($p(itm,$c(3),11),3)
						Set:$p(itm,$c(3),11)["/" $p(itm,$c(3),11)=$zdh($p(itm,$c(3),11),4)
						Set:$p(itm,$c(3),12)[":" $p(itm,$c(3),12)=$zth($p(itm,$c(3),12),1)
						
						Set:$p(itm,$c(3),13)["-" $p(itm,$c(3),13)=$zdh($p(itm,$c(3),13),3)
						Set:$p(itm,$c(3),13)["/" $p(itm,$c(3),13)=$zdh($p(itm,$c(3),13),4)
						Set:$p(itm,$c(3),14)[":" $p(itm,$c(3),14)=$zth($p(itm,$c(3),14),1)
						
						//按照时间段过滤,非当前时间段的监控结果,过滤掉
						Set ActDate=$p(itm,$c(3),2)
						Continue:((ActDate<aFromDate)||(ActDate>aToDate))
						
						Set num=$i(^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+aFromDate,3)_"至"_$zd(+aToDate,3),"CtlPaadmCnt",$zd(+ActDate,3)))
						
						//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
						Set aInput=""
						Set $p(aInput,$c(1),1)=""                     // ID
						Set $p(aInput,$c(1),2)=%PAADM                 // 就诊号
						Set $p(aInput,$c(1),3)=+$h                    // 记录日期
						Set $p(aInput,$c(1),4)=objItem.%Id()          // 监控项目ID
						Set $p(aInput,$c(1),5)=+$p(itm,$c(3),2)       // 日期
						Set $p(aInput,$c(1),6)=+$p(itm,$c(3),3)       // 时间
						Set $p(aInput,$c(1),7)=$p(itm,$c(3),1)        // 摘要信息，用于页面展现
						Set $p(aInput,$c(1),8)=$p(itm,$c(3),4)        // 数据值
						Set $p(aInput,$c(1),9)=$p(itm,$c(3),5)        // 业务数据指针
						Set $p(aInput,$c(1),10)=$p(itm,$c(3),6)       // 操作人员指针
						Set $p(aInput,$c(1),11)=$p(itm,$c(3),7)       // 自定义数据项
						Set $p(aInput,$c(1),12)=objItem.SubjectID     // 主题ID
						Set $p(aInput,$c(1),13)=objItem.Score         // 分数
						Set $p(aInput,$c(1),14)=objItem.IsAbsolute    // 绝对项目
						Set $p(aInput,$c(1),15)=KeyWord               // 关键字
						Set $p(aInput,$c(1),16)=objItem.IsSensitive   // 是否敏感性条件
						Set $p(aInput,$c(1),17)=objItem.IsSpecificity // 是否特异性项目
						Set $p(aInput,$c(1),18)=$p(itm,$c(3),8)       // 发生日期
						Set $p(aInput,$c(1),19)=$p(itm,$c(3),9)       // 发生时间
						Set $p(aInput,$c(1),20)=$p(itm,$c(3),10)      // 业务数据类型
						Set $p(aInput,$c(1),21)=$p(itm,$c(3),11)      // 业务开始日期
						Set $p(aInput,$c(1),22)=$p(itm,$c(3),12)      // 业务开始时间
						Set $p(aInput,$c(1),23)=$p(itm,$c(3),13)      // 业务结束日期
						Set $p(aInput,$c(1),24)=$p(itm,$c(3),14)      // 业务结束时间
						
						//存储监控结果
						Set tmpID=##class(DHCMed.CC.CtlResult).Update(aInput,$c(1))
						If tmpID<0 {
							Set error="保存监控结果错误,ErrCode="_tmpID_",Input="_aInput
							Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),Paadm,objItem.SubjectID,objItem.%Id(),error)
						}
					}
				}
				For indErr=1:1:$ListLength(%ErrorData) {
					//记录错误日志
					Set error=$lg(%ErrorData,indErr)
					Continue:error=""
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),Paadm,objItem.SubjectID,objItem.%Id(),error)
				}
			} Else {
				//记录错误日志
				Set error="表达式:"_$li(expResult,3)_";错误信息:"_$li(expResult,2)
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),Paadm,objItem.SubjectID,objItem.%Id(),error)
			}
		}
		
		//处理病人停止医嘱，插入TimeLine
		Do ..ProcessStopOEOrd(Paadm,aFromDate,aToDate)
		
		//清除配置项目
		Do ..ClearVMConfig(aSubjectID,"L")
	}
	//w cnt_"     运行时间"_($p($h,",",2)-StartTime)_"秒   速度：(人/秒)"_(cnt/($p($h,",",2)-StartTime)),!
	//清除配置项目
	Do ..ClearVMConfig(aSubjectID,"S")
	
	Quit "OK"
	
ExamPaadmListErr
	Quit $ZError
}

/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).ProTimeLine(16,"2009-01-01",25887)
ClassMethod ProTimeLine(aSubjectID As %String, aCtlDate As %Date, aEpisodeID As %String = "") As %String
{
	New (aSubjectID,aCtlDate,aEpisodeID)
	Quit:(aSubjectID="")||(aCtlDate="") ""
	
	Set $ZT="ProTimeLineErr"
	
	Set:aCtlDate["-" aCtlDate=$zdh(aCtlDate,3)
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID))
		Quit:EpisodeID=""
		Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
		
		//清除时间线历史数据
		Set flg=##Class(DHCMed.CCService.IntegratedCtrl.TimeLineService).DeleteByAdm(aSubjectID,aCtlDate,EpisodeID)
		
		Set SubjectID=""
		For {
			Set SubjectID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID))	
			Quit:SubjectID=""
			Continue:(aSubjectID'="")&&(aSubjectID'=SubjectID)
			
			Set CtlResultID=""
			For {
				Set CtlResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID,CtlResultID))
				Quit:CtlResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultID)
				Continue:'$IsObject(objResult)
				
				Set objItem=##Class(DHCMed.CC.SubjectItm).GetObjById(objResult.ItemId)
				Continue:'$IsObject(objItem)
				Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(objResult.KeyWord)
				Continue:'$IsObject(objKeyword)
				
				//存储时间线数据
				//(DHCMed.CC.KeyWord).时间线子项代码==(icare.ClinicalDataType).时间线子项代码
				//(DHCMed.CC.KeyWord).TimeLineCode==(icare.ClinicalDataType).Code
				Set tmpID=##class(DHCMed.CCService.IntegratedCtrl.TimeLineService).Update(objResult)
				If tmpID<-100 {
					Set error="同步时间线数据报错,ErrCode="_tmpID_",CtlResultID="_objResult.%Id()_",KeyWord="_objKeyword.Description
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),EpisodeID,objItem.SubjectID,objItem.%Id(),error)
				}
			}
		}
	}
	
	Quit "OK"
	
ProTimeLineErr
	Quit $ZError
}

/// 判断是否长期医嘱
/// Debug:w ##Class(DHCMed.CCService.AutoProcess.CoreVM).IsLongOEOrdItem2("358347||82")
ClassMethod IsLongOEOrdItem(argOEOrdItem As %String) As %String
{
	New (argOEOrdItem)
	Set Rtn=0,OEOrdItem=argOEOrdItem
	Set StatusID=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") Rtn
	//作废,未审核,撤销,预开医嘱
	Set StatusList=$lb("U","I","C","P")
	Quit:($listfind(StatusList,StatusCode)>0) Rtn
	
	//停止医嘱
	If (StatusCode="D") {
		Set PriorityID=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),1)),"^",8)
		Set PriorityCode=$p($g(^OECPR(+PriorityID)),"^",1)
		Set PriorityDesc=$p($g(^OECPR(+PriorityID)),"^",2)
		;Set OEORIXData=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),3)),"^",34)  ;医嘱停止日期
		;Set OEORIXTime=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),2)),"^",15)  ;医嘱停止时间
		b ;11	
		Quit:PriorityDesc'["长期" Rtn
		Set Rtn=1
	}	
	Quit Rtn
}

ClassMethod IsLongOEOrdItem2(argOEOrdItem As %String) As %String
{
	New (argOEOrdItem)
	Set Rtn=0,OEOrdItem=argOEOrdItem
	Set StatusID=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
	Quit:(StatusCode="")||(StatusDesc="") Rtn
	//作废,未审核,撤销,预开医嘱
	Set StatusList=$lb("U","I","C","P")
	Quit:($listfind(StatusList,StatusCode)>0) Rtn
	
	Set PriorityID=$p($g(^OEORD(+$P(OEOrdItem,"||",1),"I",+$P(OEOrdItem,"||",2),1)),"^",8)
	Set PriorityCode=$p($g(^OECPR(+PriorityID)),"^",1)
	Set PriorityDesc=$p($g(^OECPR(+PriorityID)),"^",2)
	Quit:PriorityDesc'["长期" Rtn
    Set Rtn=1
	Quit Rtn
}

/// Debug:w ##Class(DHCMed.CCService.AutoProcess.CoreVM).ProcessInHospOfPaadm("2013-07-01","2013-07-16")
ClassMethod ProcessInHospOfPaadm(argFromDate As %String, argToDate As %String) As %String
{
	New (argFromDate,argToDate)
	Set:argFromDate["/" argFromDate=$zdh(argFromDate,4)
	Set:argFromDate["-" argFromDate=$zdh(argFromDate,3)
	Set:argToDate["/" argToDate=$zdh(argToDate,4)
	Set:argToDate["-" argToDate=$zdh(argToDate,3)
	/*
	//在院患者列表
	Set WardID="",Count=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))
		Quit:WardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				Do ..ProcessStopOEOrd(Paadm,argFromDate,argToDate)
				Set Count=Count+1
			}
		}
	}
	*/
	Set Count=0
	Set AdmDateIndex=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18取入院时间索引
	For AdmDate=argFromDate:1:argToDate {
		Set Paadm=0
		For {
		    Set Paadm=$O(^PAADMi(AdmDateIndex,AdmDate,Paadm))
		    Quit:Paadm=""
		    
		    Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
		    Do ..ProcessStopOEOrd(Paadm,argFromDate,argToDate)
			Set Count=Count+1
		}
	}
	Quit Count
}

/// 处理病人的停止医嘱
/// Debug:w ##Class(DHCMed.CCService.AutoProcess.CoreVM).ProcessStopOEOrd(352512,"2013-04-27","2013-07-16")
ClassMethod ProcessStopOEOrd(argEpisodeID As %String, argFromDate As %String, argToDate As %String)
{
	New (argEpisodeID,argFromDate,argToDate)
	Set Rtn="",Count=0
	Quit:argEpisodeID="" Rtn
	Set:argFromDate["/" argFromDate=$zdh(argFromDate,4)
	Set:argFromDate["-" argFromDate=$zdh(argFromDate,3)
	Set:argToDate["/" argToDate=$zdh(argToDate,4)
	Set:argToDate["-" argToDate=$zdh(argToDate,3)
	;Set $ZT="ProcessStopOEOrdError"
	Set OEORDID=$O(^OEORD(0,"Adm",argEpisodeID,""),-1)
	Quit:OEORDID="" Rtn
	Set ChildSub=0
	For {
		Set ChildSub=$O(^OEORD(OEORDID,"I",ChildSub))
		Quit:ChildSub=""
		
		Set StatusID=$p($g(^OEORD(+OEORDID,"I",+ChildSub,1)),"^",13)
		Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),"^",1)
		Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),"^",2)
		Continue:(StatusCode="")||(StatusDesc="") 
	    ;b:(ChildSub="15")||(ChildSub="20")
		//作废,未审核,撤销,预开医嘱
		Set StatusList=$lb("U","I","C","P")
		Continue:($listfind(StatusList,StatusCode)>0)
	    ;w StatusCode_" "_OEORDID_"||"_ChildSub,!
		//停止医嘱
		If (StatusCode="D") {
			Set PriorityID=$p($g(^OEORD(+OEORDID,"I",+ChildSub,1)),"^",8)
			Set PriorityCode=$p($g(^OECPR(+PriorityID)),"^",1)
			Set PriorityDesc=$p($g(^OECPR(+PriorityID)),"^",2)
			Set OEORIXData=$p($g(^OEORD(+OEORDID,"I",+ChildSub,3)),"^",34)  ;医嘱停止日期
			Set OEORIXTime=$p($g(^OEORD(+OEORDID,"I",+ChildSub,2)),"^",15)  ;医嘱停止时间
			
			Continue:PriorityDesc'["长期"
			Continue:(+OEORIXData>+argToDate)||(+OEORIXData<+argFromDate)
			Set OEOrdItemID=OEORDID_"||"_ChildSub
			
			Set RtnVal=..InsertStopRepository(OEOrdItemID,argEpisodeID,OEORIXData,OEORIXTime)
			;w:+RtnVal>0 "RtnVal="_RtnVal_",EpisodeID="_argEpisodeID,!
			Set:+RtnVal>0 Count=Count+1
		}	
	}
	Quit Count
   ;ProcessStopOEOrdError
    ;Set $ZT=""
    ;b ;11
    ;Quit -100
}

/// 时间线插入停止医嘱
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).InsertStopRepository("340676||149",352512,"62013","35100")
ClassMethod InsertStopRepository(argOEORDItemID As %String, argEpisodeID As %String, argOEORIXDate As %String, argOEORIXTime As %String) As %String
{
	New (argOEORDItemID,argEpisodeID,argOEORIXDate,argOEORIXTime)
	Set Rtn="",Count=0
	Quit:(argOEORDItemID="")||(argEpisodeID="") Rtn
	Set DataCodeList="111|11101^112|11201^113|11301"
	Set Len=$L(DataCodeList,"^")
	For Index=1:1:Len {
		Set TempDataCode=$P(DataCodeList,"^",Index)
		Set TempDataTypeCode=$P(TempDataCode,"|",1)
		Set TempActCode=$P(TempDataCode,"|",2)	
		Set ObjRep=..GetRepository(argEpisodeID,TempDataTypeCode,TempActCode,argOEORDItemID)
		Continue:(ObjRep="")||('$IsObject(ObjRep))
		
		Set NewRep=##Class(icare.ClinicalRepository).%New()
		Set ObjActType=##Class(icare.ClinicalDataTypeAct).%OpenId("060102")
		Set ObjDataType=##Class(icare.ClinicalDataType).%OpenId(TempDataTypeCode)
		Set NewRep.ActCode=ObjActType
		Set NewRep.ActDate=argOEORIXDate
		Set NewRep.ActTime=argOEORIXTime
		Set NewRep.CareProviderID=ObjRep.CareProviderID
		Set NewRep.DataTypeCode=ObjDataType
		Set NewRep.DataValue=ObjRep.DataValue
		Set NewRep.EpisodeID=argEpisodeID
		Set NewRep.ObjectID=argOEORDItemID
		Set NewRep.Parameters=ObjRep.Parameters
		Set NewRep.PatientID=ObjRep.PatientID
		Set NewRep.Summary=ObjRep.Summary
		;b ;10
		Set sc=NewRep.%Save()
	    If $system.Status.IsError(sc) {    
		   //Do $system.OBJ.DisplayError(sc)
		   Set return=-1
	    } Else {
		   Set Count=Count+1
	    }
	    Do ObjActType.%Close()
	    Do ObjDataType.%Close()
		Quit:Count>0
	}
	Set Rtn=Count
	Quit Rtn
}

/// 获取开始医嘱
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).GetRepository(349442,"113","11301","337968||94")
ClassMethod GetRepository(argEpisodeID As %String, argDataTypeCode As %String, argActCode As %String, argObjectID As %String)
{
	New (argEpisodeID,argDataTypeCode,argActCode,argObjectID)
	Set Rtn=0,ObjRepository=""
	Set EpisodeID=" "_argEpisodeID,DataTypeCode=argDataTypeCode,ActCode=argActCode,ObjectID=" "_argObjectID
	Quit:'$d(^icare.ClinicalRepositoryI("IndexAct",EpisodeID,DataTypeCode,ObjectID,ActCode)) Rtn  
	Quit:$d(^icare.ClinicalRepositoryI("IndexAct",EpisodeID,DataTypeCode,ObjectID,"060102")) Rtn
	Set RepositoryID=""
	For {
		Set RepositoryID=$O(^icare.ClinicalRepositoryI("IndexAct",EpisodeID,DataTypeCode,ObjectID,ActCode,RepositoryID),-1)
		Quit:(RepositoryID="")||(ObjRepository'="")
		
		Set ObjRepository=##Class(icare.ClinicalRepository).%OpenId(RepositoryID)
		Continue:'$IsObject(ObjRepository)
	}
	Quit ObjRepository
}

//Modified By LiYang 2013-01-21 增加按照子类代码或者关键字代码查询的功能

/// 获取监控项目列表
ClassMethod GetCtlItemList(repid As %String, aSubjectID As %String, aSubCatCode As %String = "", aKeywordCode As %String = "") As %String
{
	New (repid,aSubjectID,aSubCatCode,aKeywordCode)
	Set return=""
	Quit:(repid="")||(aSubjectID="") return
	
	Set $ZT="GetCtlItemListErr"
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",aSubjectID,1,RowID))
		Quit:RowID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(RowID)
		Continue:'$IsObject(objItem)
		Set ItemID=objItem.%Id()
		
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		
		Set KeyWord=""
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItemDic.IDSubCatDr)
		If $IsObject(objSubCat) {
			Set KeyWord=objSubCat.ISCKeywordID
		}
		Continue:'$IsObject(objSubCat)	//Add by lyh 2013-1-31 不是对象过滤
		Continue:((objSubCat.ISCCode=aSubCatCode)&&(aSubCatCode'="")) //Add By LiYang 增加按照子类代码或者关键字代码查询的功能
		Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(+$g(KeyWord))
		Set:$IsObject(objKeyword)=0 objKeyword=##class(DHCMed.CC.KeyWord).%New()
		Do objKeyword.%Close()
		Continue:((objKeyword.Code'=aKeywordCode)&&(aKeywordCode'="")) //Add By LiYang 增加按照子类代码或者关键字代码查询的功能
		
		Set evaResult=##class(DHCMed.CCService.AutoProcess.ExpEvaluation).EvaExpression(objItemDic.IDExpression)
		If $li(evaResult,1)="OK" {
			Set Count=Count+1
			Set ^CacheTemp(repid,"CtlItem",ItemID,"Expression")  = $li(evaResult,2)       //解析后的监控表达式
			Set ^CacheTemp(repid,"CtlItem",ItemID,"KeyWord")     = KeyWord                //关键字
		} Else {
			For indErr=2:1:$ll(evaResult) {
				//记录错误日志
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),0,aSubjectID,0,objItemDic.IDExpression_":"_$li(evaResult,indErr))
			}
		}
	}
	
	Quit "OK"
	
GetCtlItemListErr
	Kill ^CacheTemp(repid,"CtlItem")
	Quit $ZError
}

/// 获取监控就诊列表(当前住院患者)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).GetCtlPaadmList(repid)
ClassMethod GetCtlPaadmList(repid As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aFromDate,aToDate)
	Set return=""
	Quit:(repid="")||(aFromDate="")||(aToDate="") return
	
	Set $ZT="GetCtlPaadmListErr"
	
	//在院患者列表
	Set WardID="",Count=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))
		Quit:WardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				
				Set Count=Count+1
				Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
			}
		}
	}
	
	//出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aFromDate:1:CurrDate {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,xDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			Continue:$p(AdmInfo,"^",6)>aToDate   //就诊时间过滤
			
			Set Count=Count+1
			Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
		}
	}
	
	Quit "OK"
	
GetCtlPaadmListErr
	Kill ^CacheTemp(repid,"CtlPaadm")
	Quit $ZError
}

/// %PAADM       就诊号
/// aSubjectID   监控主题ID
/// aRunType     S:全局  L:局部(就诊)
/// Set %PAADM=111
/// Do ##Class(DHCMed.CCService.AutoProcess.CoreVM).GetVMConfig(9,"L")
ClassMethod GetVMConfig(aSubjectID As %String, aRunType As %String)
{
	Set arrConfig=##class(DHCMed.CC.SubjectVMStartConfig).GetConfigBySubject(aSubjectID,aRunType)
	For indArr=1:1:arrConfig.Count() {
		Set objConfig=arrConfig.GetAt(indArr)
		Set retValue=##class(DHCMed.CCService.AutoProcess.CoreLib).RunConfigExpression(objConfig.Expression)
		If ($p(retValue,$c(1),1)'="ERROR")&&(objConfig.VarName'="") {
			Set exp="s "_objConfig.VarName_"=retValue"
			X exp
		} Else {
			//记录错误日志(加载配置项目错误)
			Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),0,aSubjectID,0,"配置ID:"_objConfig.%Id()_";表达式:"_objConfig.Expression_";错误信息:"_$p(retValue,$c(1),2))
		}
	}
	Quit
}

/// aSubjectID   监控主题ID
/// aRunType     S:全局  L:局部(就诊)
/// Do ##Class(DHCMed.CCService.AutoProcess.CoreVM).ClearVMConfig(9,"L")
ClassMethod ClearVMConfig(aSubjectID As %String, aRunType As %String)
{
	Set arrConfig=##class(%Library.ListOfObjects).%New()
	Set arrConfig=##class(DHCMed.CC.SubjectVMStartConfig).GetConfigBySubject(aSubjectID,aRunType)
	For indArr=1:1:arrConfig.Count() {
		Set objConfig=arrConfig.GetAt(indArr)
		If objConfig.VarName'="" {
			Set exp="s "_objConfig.VarName_"="_$c(34)_$c(34)
			X exp
			Set exp="k "_objConfig.VarName
			X exp
		}
	}
	Quit
}

/// <H3>功能：将生成的监控明细根据分值等条件进行汇总，做到每个EpisodeID每日1条汇总记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>repid</B>：临时Global进程号</LI>
/// <LI><B>aSubjectID</B>：监控主题</LI>
/// <LI><B>aCtlDate</B>:监控日期</LI>
/// <LI><B>aEpisodeID</B>：就诊号,允许为空</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功，返回字符串 "OK"
/// <H4>备注</H4>
/// 按日汇总,每个EpisodeID每日1条汇总记录
ClassMethod CalcSummary(aSubjectID As %String, aCtlDate As %Date, aEpisodeID As %String = "")
{
	New (aSubjectID,aCtlDate,aEpisodeID)
	Quit:(aSubjectID="")||(aCtlDate="") ""
	
	Set $ZT="CalcSummaryErr"
	Set repid=$I(^CacheTemp)
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID))
		Quit:EpisodeID=""
		Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
		Set SubjectID=""
		For {
			Set SubjectID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID))	
			Quit:SubjectID=""
			Continue:(aSubjectID'="")&&(aSubjectID'=SubjectID)
			
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",EpisodeID,SubjectID,aCtlDate,""))
			If (##class(DHCMed.CC.CtlSummary).%ExistsId(SummaryID)) {
				Set objSummary=##class(DHCMed.CC.CtlSummary).%OpenId(SummaryID)
			} Else {
				Set objSummary=##class(DHCMed.CC.CtlSummary).%New()
			}
			Set objSummary.EpisodeID=EpisodeID
			Set objSummary.ActDate=aCtlDate
			Set objSummary.SubjectID=SubjectID
			Set objSummary.Status=0 //初始状态 未通知
			
			Kill ^CacheTemp(repid,"CtlSummary",EpisodeID)
			Set (ItemNumber,TotalScore,AbsoluteAmount,SensitiveAmount,SpecificityAmount)=0
			Set CtlResultID=""
			For {
				Set CtlResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID,CtlResultID))
				Quit:CtlResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultID)
				Continue:'$IsObject(objResult)
				Continue:(+objResult.Score)<1
				Set CtlItemID=objResult.ItemId
				Set objSubjectItem=##class(DHCMed.CC.SubjectItm).GetObjById(CtlItemID)
				Continue:'$IsObject(objSubjectItem)
				
				//触发项目总分计算,同时处理允许"多次扣分"问题
				If (('$d(^CacheTemp(repid,"CtlSummary",EpisodeID,CtlItemID)))||(objSubjectItem.MultiTimes=1)) {
					Set TotalScore=TotalScore+objResult.Score
				}
				Set ^CacheTemp(repid,"CtlSummary",EpisodeID,CtlItemID)=""
				
				//触发项目数量计算
				Set ItemNumber=ItemNumber+1
				//触发绝对项目数量计算
				Set:objResult.IsAbsolute=1 AbsoluteAmount=AbsoluteAmount+1
				//触发敏感项目数量计算
				Set:objResult.IsSensitive=1 SensitiveAmount=SensitiveAmount+1
				//触发特异性项目数量计算
				Set:objResult.IsSpecificity=1 SpecificityAmount=SpecificityAmount+1
			}
			Set objSummary.ItemNumber=ItemNumber                //触发项目数量
			Set objSummary.TotalScore=TotalScore                //触发项目总分
			Set objSummary.AbsoluteAmount=AbsoluteAmount        //触发绝对项目数量
			Set objSummary.SensitiveAmount=SensitiveAmount      //触发敏感项目数量
			Set objSummary.SpecificityAmount=SpecificityAmount  //触发特异性项目数量
			Set objSummary.ProcessUser=0 //系统监控
			Set objSummary.ProcessDate=+$h
			Set objSummary.ProcessTime=$p($h,",",2)
			
			Set IsFired=(..ApplyFilter(objSummary)=1)
			If (IsFired) {
				Set objSummary.Status=0
			} Else {
				Set objSummary.Status=9
			}
			
			Set sc=objSummary.%Save()
			If $system.Status.IsError(sc) {    //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
			} Else {
				Set SummaryID=objSummary.%Id()
			}
			Do objSummary.%Close()
		}
	}
	Kill ^CacheTemp(repid)
	
	Quit "OK"
	
CalcSummaryErr
	Kill ^CacheTemp(repid)
	Quit $ZError
}

/// <H3>功能：根据汇总信息对应的监控主题ID，应用过滤筛选条件检查汇总的结果是否满足该主题的触发提示条件</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>objSummary</B>:<B>DHCMed.CC.CtlSummary</B>类的实例，需要应用筛选条件的汇总信息</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 1：已经达到该主题的触发条件  0---没有达到触发条件，可以排除
/// <H4>备注</H4>
ClassMethod ApplyFilter(objSummary As DHCMed.CC.CtlSummary)
{
	New (objSummary)
	Set return=0
	Quit:objSummary="" return
	
	//如果没有维护该主题的筛选条件，则自动触发
	Set objRule=##class(DHCMed.CC.CtlFilterRule).GetObjBySubjectID(objSummary.SubjectID)
	Quit:'$IsObject(objRule) return
	
	//触发"绝对项目"筛选条件
	If (objRule.IncludeAbsolute=1) {
		Set:(objSummary.AbsoluteAmount>0) return=1
	}
	//触发"敏感性项目数量"筛选条件
	Set MinSensitiveCount=+objRule.MinSensitiveCount
	If (MinSensitiveCount>0) {
		Set:(objSummary.SensitiveAmount>=MinSensitiveCount) return=1
	}
	//触发"特异性项目数量"筛选条件
	Set MinSpecificityCount=+objRule.MinSpecificityCount
	If (MinSpecificityCount>0) {
		Set:(objSummary.SpecificityAmount>=MinSpecificityCount) return=1
	}
	//触发"项目总分"筛选条件
	Set MinScore=+objRule.MinScore
	If (MinScore>0) {
		Set:(objSummary.TotalScore>=MinScore) return=1
	}
	
	/* update by zf 20121012 查找出总分的提示意义再加
	//住院以来触发总分值计算
	Set ScoreInfo=..CalcTotalScore(objSummary.EpisodeID, objSummary.SubjectID, objSummary.ActDate)
	//触发"住院以来累计项目总分"筛选条件
	Set TotalScore=+objRule.TotalScore
	If (TotalScore>0) {
		Set cTotalScore=+$p(ScoreInfo,"^",1)
		Set:(cTotalScore>=TotalScore) return=1
	}
	Set:(($p(ScoreInfo,"^",1)'<+objRule.TotalScore)&&(objRule.TotalScore>0)) ret=1
	//触发"住院以来已提示项目总分"筛选条件
	Set TotalNoticedScore=+objRule.TotalNoticedScore
	If (TotalNoticedScore>0) {
		Set cTotalNoticedScore=+$p(ScoreInfo,"^",3)
		Set:(cTotalNoticedScore>=TotalNoticedScore) return=1
	}
	*/
	
	Quit return
}

/// 计算入院后某个主题的总成绩
/// 返回值：  总成绩^未提示成绩^已提示成绩^已排除成绩
ClassMethod CalcTotalScore(aEpisodeID As %String, aSubjectID As %String, aActDate As %String) As %String
{
	New (aEpisodeID,aSubjectID,aActDate)
	Set return=""
	Quit:(aEpisodeID="")||(aSubjectID="")||(aActDate="") return
	
	Set (TotalScore1,TotalScore2,TotalScore3,TotalScore4)=0
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",aEpisodeID,aSubjectID,RowID))	
		Quit:RowID=""
		
		Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(RowID)
		Continue:'$IsObject(objSummary)
		Set TotalScore=+objSummary.TotalScore
		Set SummaryStatus=objSummary.Status
		Set TotalScore1=TotalScore1+TotalScore                 //总成绩
		Set:SummaryStatus=0 TotalScore2=TotalScore2+TotalScore //未提示成绩
		Set:SummaryStatus=1 TotalScore3=TotalScore3+TotalScore //已提示成绩
		Set:SummaryStatus=9 TotalScore4=TotalScore4+TotalScore //已排除成绩
	}
	Set return=TotalScore1_"^"_TotalScore2_"^"_TotalScore3_"^"_TotalScore4
	
	Quit return
}

/// 处理转科记录
ClassMethod ProAdmTrans(repid As %String)
{
	New (repid)
	Quit:repid="" "Error"
	
	Set Paadm=0
	For {
		Set Paadm=$o(^CacheTemp(repid,"CtlPaadm",Paadm))
		Quit:Paadm=""
		Continue:$p($g(^PAADM(Paadm)),"^",2)'="I"  //就诊类型过滤
		Continue:$p($g(^PAADM(Paadm)),"^",20)="C"  //就诊状态过滤
		
		Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"W")
		Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"E")
	}
	
	Quit "OK"
}

}
