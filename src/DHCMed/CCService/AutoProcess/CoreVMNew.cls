/// 监控中心业务主程序
/// 作者：zhufei
/// 创建日期：2014-04-10
Class DHCMed.CCService.AutoProcess.CoreVMNew Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator     : zhufei
/// CreateDate  : 2014-04-09
/// Description : 按监控主题ID监控主程序
/// Input       : aSubjectID:监控主题，aFromDate:开始日期，aToDate:结束日期，aEpisodeID:就诊号
///             : aSubCatCode:监控项目子类，aKeywordCode:监控项目子类对应关键字
/// Output      : ret="":成功，ret=Error:失败
///             : 执行记录查看：^DHCMed.CC.CtlResultL("CtlLog",日期)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).Process("5","2013-07-01","2014-01-01","2893905")
ClassMethod Process(aSubjectID As %Integer, aFromDate As %Date, aToDate As %String, aEpisodeID As %String = "", aSubCatCode As %String = "", aKeywordCode As %String = "") As %String
{
	New (aSubjectID, aFromDate, aToDate, aEpisodeID, aSubCatCode, aKeywordCode)
	Set return="-100"
	Quit:(aSubjectID="")||(aFromDate="")||(aToDate="") return
	
	//获取临时Global进程号
	Set repid=$I(^CacheTemp)
	
	Set $ZT="ProcessErr"
	
	Set CurrDate=$zd(+$h,3),CurrTime=$zt($p($h,",",2),1)
	Set DataIndex=$i(^DHCMed.CC.CtlResultL("CtlLog",CurrDate))
	Kill ^CacheTemp(repid) //临床Global清空
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex)=CurrDate_" "_CurrTime
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Process")=aSubjectID_","_aFromDate_","_aToDate_","_aEpisodeID_","_aSubCatCode_","_aKeywordCode
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(aSubjectID)
	Quit:'$IsObject(objSubject) return
	
	//获取监控项目列表
	Set return="-200"
	Set flg=..GetCtlItemList(repid,aSubjectID,aSubCatCode,aKeywordCode) 
	If flg'="OK" {
		Set Error="GetCtlItemList方法错误:ErrCode="_flg
		Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
	}
	//记录执行结果
	Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
	Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
	Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
	Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"GetCtlItemList")=CtlItemCnt
	If (CtlItemCnt1<1)&&(CtlItemCnt2<1)&&(CtlItemCnt3<1) {
		Kill ^CacheTemp(repid)
		Quit return
	}
	
	//获取就诊列表
	Set return="-300"
	If aEpisodeID'="" {
		Set num=$i(^CacheTemp(repid,"CtlPaadm"))
		Set ^CacheTemp(repid,"CtlPaadm",aEpisodeID)=""
	} Else {
		Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
		Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
		Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
		Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
		If CtlItemCnt1>0 {
			Set flg=..GetIPAdmList(repid,aFromDate,aToDate)
		
			If flg'="OK" {
				Set Error="GetIPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
		If CtlItemCnt2>0 {
			Set flg=..GetOPAdmList(repid,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetOPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
		If CtlItemCnt3>0 {
			Set flg=..GetEPAdmList(repid,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetEPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
	}
	//记录执行结果
	Set CtlPaadmCnt=+$g(^CacheTemp(repid,"CtlPaadm"))
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Get*AdmList")=CtlPaadmCnt
	If CtlPaadmCnt<1 {
		Kill ^CacheTemp(repid)
		Quit return
	}
	
	//按天执行监控,并同步保存监控结果
	Set flg=..GetExamList(repid,aSubjectID,aFromDate,aToDate)
	If flg'="OK" {
		Set Error="GetExamList方法错误:ErrCode="_flg
		Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
	} Else {
		//记录执行记录
		Set ExamItemCnt=+$g(^CacheTemp(repid,"GetExamList"))    //就诊记录数
		Set ExamItemCnt0=+$g(^CacheTemp(repid,"GetExamList",0)) //监控记录数
		Set ExamItemCnt1=+$g(^CacheTemp(repid,"GetExamList",1)) //保存记录数
		Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"GetExamList")=ExamItemCnt0_"/"_ExamItemCnt1
	}
	
	Set IsTimeLine=objSubject.IsTimeLine
	If (IsTimeLine=1)&&(CtlItemCnt1>0) {
		//生成时间线数据
		For ctlDate=aFromDate:1:aToDate {
			Set flg=..ProTimeLine(repid,aSubjectID,ctlDate,aEpisodeID)
			If flg'="OK" {
				Set Error="ProTimeLine方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			} Else {
				//记录执行记录
				Set ProTimeLineCnt=+$g(^CacheTemp(repid,"ProTimeLine"))
				Set ProTimeLineCnt1=+$g(^CacheTemp(repid,"ProTimeLine",1))
				Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"ProTimeLine")=ProTimeLineCnt_"/"_ProTimeLineCnt1
			}
		}
		//关闭时间线数据
		Set flg=..CloseTimeLine(repid,aSubjectID,aEpisodeID)
		If flg'="OK" {
			Set Error="CloseTimeLine方法错误:ErrCode="_flg
			Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
		} Else {
			//记录执行记录
			Set CloseTimeLineCnt=+$g(^CacheTemp(repid,"CloseTimeLine"))
			Set CloseTimeLineCnt1=+$g(^CacheTemp(repid,"CloseTimeLine",1))
			Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"CloseTimeLine")=CloseTimeLineCnt_"/"_CloseTimeLineCnt1
		}
	}
	
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	
	Quit "OK"
	
ProcessErr
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	Quit $ZError
}

/// Creator     : zhufei
/// CreateDate  : 2014-04-10
/// Description : 按主题配置Code监控主程序
/// Input       : aSubjectID:监控主题，aEpisodeID:就诊号，aFromDate:开始日期，aToDate:结束日期
///             : aDataIndex:进程号
/// Output      : ret="":成功，ret=Error:失败
///             : 执行记录查看：^DHCMed.CC.CtlResultL("CtlLog",日期)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).Process02("INTCCS","2014-04-10","2014-04-10")
ClassMethod Process02(aSubjectCode As %String, aFromDate As %String, aToDate As %String, aEpisodeID As %String = "")
{
	New (aSubjectCode,aFromDate,aToDate,aEpisodeID)
	Set return="-100"
	Quit:(aSubjectCode="")||(aFromDate="")||(aToDate="") return
	
	//获取临时Global进程号
	Set repid=$I(^CacheTemp)
	
	Set $ZT="Process02Err"
	
	Set CurrDate=$zd(+$h,3),CurrTime=$zt($p($h,",",2),1)
	Set DataIndex=$i(^DHCMed.CC.CtlResultL("CtlLog",CurrDate))
	Kill ^CacheTemp(repid) //临床Global清空
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex)=CurrDate_" "_CurrTime
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Process02")=aSubjectCode_","_aFromDate_","_aToDate_","_aEpisodeID
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	//获取监控项目列表 
	Set return="-200"
	Set flg=..GetCtlItems(repid,aSubjectCode)
	Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
	Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
	Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
	Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
	If (CtlItemCnt1<1)&&(CtlItemCnt2<1)&&(CtlItemCnt3<1) {
		Kill ^CacheTemp(repid)
		Quit return
	}
	
	//获取就诊列表
	Set return="-300"
	If aEpisodeID'="" {
		Set num=$i(^CacheTemp(repid,"CtlPaadm"))
		Set ^CacheTemp(repid,"CtlPaadm",aEpisodeID)=""
	} Else {
		Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
		Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
		Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
		Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
		If CtlItemCnt1>0 {
			Set flg=..GetIPAdmList(repid,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetIPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
		If CtlItemCnt2>0 {
			Set flg=..GetOPAdmList(repid,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetOPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
		If CtlItemCnt3>0 {
			Set flg=..GetEPAdmList(repid,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetEPAdmList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
			}
		}
	}
	//记录执行结果
	Set CtlPaadmCnt=+$g(^CacheTemp(repid,"CtlPaadm"))
	Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Get*AdmList")=CtlPaadmCnt
	If CtlPaadmCnt<1 {
		Kill ^CacheTemp(repid)
		Quit return
	}
	
	//按天执行监控,并同步保存监控结果
	Set flg=..GetExamList(repid,SubjectID,aFromDate,aToDate)
	If flg'="OK" {
		Set Error="GetExamList方法错误:ErrCode="_flg
		Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,aSubjectID,0,Error)
	} Else {
		//记录执行记录
		Set ExamItemCnt=+$g(^CacheTemp(repid,"GetExamList"))    //就诊记录数
		Set ExamItemCnt0=+$g(^CacheTemp(repid,"GetExamList",0)) //监控记录数
		Set ExamItemCnt1=+$g(^CacheTemp(repid,"GetExamList",1)) //保存记录数
		Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"GetExamList")=ExamItemCnt0_"/"_ExamItemCnt1
	}
	
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	
	Quit "OK"
	
Process02Err
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	Quit $ZError
}

/// Creator     : zhufei
/// CreateDate  : 2014-04-10
/// Description : 按主题配置Code监控主程序
/// Input       : aSubjectID:监控主题，aEpisodeID:就诊号，aFromDate:开始日期，aToDate:结束日期
///             : aDataIndex:进程号
/// Output      : ret="":成功，ret=Error:失败
///             : 执行记录查看：^DHCMed.CC.CtlResultL("CtlLog",日期)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).Process03("INTCCS","AA","2014-04-21","2014-04-21")
ClassMethod Process03(aSubjectCode As %String, aDataIndex As %String, aFromDate As %String = "", aToDate As %String = "", aEpisodeID As %String = "")
{
	New (aSubjectCode,aDataIndex,aFromDate,aToDate,aEpisodeID)
	Set return="-100"
	Quit:(aSubjectCode="") return
	
	//获取临时Global进程号
	Set aDataIndex=$tr(aDataIndex,":","")
	Quit:aDataIndex="" return
	Set repid=aDataIndex
	
	Set $ZT="Process03Err"
	
	Set CurrDate=$zd(+$h,3),CurrTime=$zt($p($h,",",2),1)
	Set DataIndex=+$g(^DHCMed.CC.CtlResultL("CtlLog",CurrDate))
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aFromDate="" aFromDate=+$h  //开始日期为空，默认当天
	Set:aToDate="" aToDate=+$h      //结束日期为空，默认当天
	
	//在院患者（东华HIS）
	Do ##class(DHCMed.DCEns.HIS.InHospTask).SyncInHospByDate(aFromDate,aToDate,"HIS01","V1")
	
	//检验系统（东华检验系统）
	Do ##class(DHCMed.DCEns.LIS.TSResultTask).ProcBaseData("LIS01","V2")
	Do ##class(DHCMed.DCEns.LIS.TSResultTask).SyncRepByDate(aFromDate,aToDate,"LIS01","V2")
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	//删除历史错误数据
	If $g(^CacheTemp(repid,"CurrDate"))'=$zd(+$h,3) {
		Kill ^CacheTemp(repid)
	}
	
	If +$g(^CacheTemp(repid,"CurrStep"))<1 {
		Kill ^CacheTemp(repid) //临床Global清空
		Set ^CacheTemp(repid,"CurrDate")=$zd(+$h,3)
		Set DataIndex=$i(^DHCMed.CC.CtlResultL("CtlLog",CurrDate))
		Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex)=CurrDate_" "_CurrTime
		Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Process03")=aSubjectCode_","_aFromDate_","_aToDate_","_aEpisodeID
		
		//获取监控项目列表 
		Set return="-200"
		Set flg=..GetCtlItems(repid,aSubjectCode)
		Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
		Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
		Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
		Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
		If (CtlItemCnt1<1)&&(CtlItemCnt2<1)&&(CtlItemCnt3<1) {
			Kill ^CacheTemp(repid)
			Quit return
		}
		
		Set ^CacheTemp(repid,"CurrStep")=1
		Set Bartext="监控项目列表准备就绪..."
		Set return=0_"^"_Bartext
		Quit return
	}
	
	If +$g(^CacheTemp(repid,"CurrStep"))<2 {
		//获取就诊列表
		Set return="-300"
		If aEpisodeID'="" {
			Set num=$i(^CacheTemp(repid,"CtlPaadm"))
			Set ^CacheTemp(repid,"CtlPaadm",aEpisodeID)=""
		} Else {
			Set CtlItemCnt=$g(^CacheTemp(repid,"CtlItem"))
			Set CtlItemCnt1=+$p(CtlItemCnt,",",1)
			Set CtlItemCnt2=+$p(CtlItemCnt,",",2)
			Set CtlItemCnt3=+$p(CtlItemCnt,",",3)
			If CtlItemCnt1>0 {
				Set flg=..GetIPAdmList(repid,aFromDate,aToDate)
				If flg'="OK" {
					Set Error="GetIPAdmList方法错误:ErrCode="_flg
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,SubjectID,0,Error)
				}
			}
			If CtlItemCnt2>0 {
				Set flg=..GetOPAdmList(repid,aFromDate,aToDate)
				If flg'="OK" {
					Set Error="GetOPAdmList方法错误:ErrCode="_flg
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,SubjectID,0,Error)
				}
			}
			If CtlItemCnt3>0 {
				Set flg=..GetEPAdmList(repid,aFromDate,aToDate)
				If flg'="OK" {
					Set Error="GetEPAdmList方法错误:ErrCode="_flg
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,SubjectID,0,Error)
				}
			}
		}
		//记录执行结果
		Set CtlPaadmCnt=+$g(^CacheTemp(repid,"CtlPaadm"))
		Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"Get*AdmList")=CtlPaadmCnt
		If CtlPaadmCnt<1 {
			Kill ^CacheTemp(repid)
			Quit return
		}
		
		Set ^CacheTemp(repid,"CurrStep")=2
		Set Bartext="监控患者列表准备就绪..."
		Set return=0_"^"_Bartext
		Quit return
	}
	
	If +$g(^CacheTemp(repid,"CurrStep"))<3 {
		M ^CacheTemp(repid,"TMPPaadm")=^CacheTemp(repid,"CtlPaadm")
		Set ^CacheTemp(repid,"CurrStep")=3
	}
	
	If +$g(^CacheTemp(repid,"CurrStep"))<4 {
		Kill ^CacheTemp(repid,"CtlPaadm")
		Set ^CacheTemp(repid,"CtlPaadm")=+$g(^CacheTemp(repid,"TMPPaadm"))
		Set xPaadm="",Count=0
		For {
			Set xPaadm=$o(^CacheTemp(repid,"TMPPaadm",xPaadm))
			Quit:xPaadm=""
			Quit:Count>2
			Set Count=Count+1
			Set ^CacheTemp(repid,"CtlPaadm",xPaadm)=""
			Kill ^CacheTemp(repid,"TMPPaadm",xPaadm)
		}
		
		If Count>0 {
			//按天执行监控,并同步保存监控结果
			Set flg=..GetExamList(repid,SubjectID,aFromDate,aToDate)
			If flg'="OK" {
				Set Error="GetExamList方法错误:ErrCode="_flg
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),0,SubjectID,0,Error)
			} Else {
				//记录执行记录
				Set ExamItemCnt=+$g(^CacheTemp(repid,"GetExamList"))    //就诊记录数
				Set ExamItemCnt0=+$g(^CacheTemp(repid,"GetExamList",0)) //监控记录数
				Set ExamItemCnt1=+$g(^CacheTemp(repid,"GetExamList",1)) //保存记录数
				Set ^DHCMed.CC.CtlResultL("CtlLog",CurrDate,DataIndex,"GetExamList")=ExamItemCnt0_"/"_ExamItemCnt1
			}
			
			Set CtlPaadmCnt=+$g(^CacheTemp(repid,"CtlPaadm"))
			Set ExamItemCnt=+$g(^CacheTemp(repid,"GetExamList"))
			Set RadioNum=$fn(ExamItemCnt/CtlPaadmCnt,"",4)
			Set Bartext=RadioNum*100
			Set:Bartext<1 Bartext="0"_Bartext
			Set Bartext="监控任务处理进度("_Bartext_"%"_")..."
			Set return=RadioNum_"^"_Bartext
			Quit return
		} Else {
			Set ^CacheTemp(repid,"CurrStep")=4
		}
	}
	
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	
	if (aSubjectCode="INTCCS") {
		//处理转科记录
		Set flg=##Class(DHCMed.CC.CtlAdmTrans).ProAdmTrans(aFromDate,aToDate)
		//疑似病例筛查
		Set flg=##Class(DHCMed.NINFService.BC.AutoTask).CasesXTask(aFromDate,aToDate,"INTCCS")
		//感染暴发预警
		Set flg=##Class(DHCMed.NINFService.BC.AutoTask).WarningTask(aFromDate,aToDate,"INFWARN")
	}
	if (aSubjectCode="EPDCC") {
		//传染病筛查
		Set flg=##Class(DHCMed.EPDService.AutoTask).CasesXTask(aFromDate,aToDate,"EPDCC")
	}
	
	Quit "OK"
	
Process03Err
	//清空临时Global节点
	Kill ^CacheTemp(repid)
	Quit "-999^"_$ZError
}

/// 获取监控就诊列表(住院患者)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).GetIPAdmList(repid)
ClassMethod GetIPAdmList(repid As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aFromDate,aToDate)
	Set return=""
	Quit:(repid="")||(aFromDate="")||(aToDate="") "Error"
	
	Set $ZT="GetIPAdmListErr"
	
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
				
				Set num=$i(^CacheTemp(repid,"CtlPaadm"))
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
			//Continue:$p(AdmInfo,"^",6)>aToDate   //就诊时间过滤
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
    		Continue:$p(AdmDateTime,"^",1)>aToDate   //就诊时间过滤
    		
			Set num=$i(^CacheTemp(repid,"CtlPaadm"))
			Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
		}
	}
	
	//出院后出细菌培养结果的患者列表
	//update by zf 20160308 数据池相关程序修改(检验)
	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime))
			Quit:xTime=""
			Set xID=0
			For {
				Set xID=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime,xID))
				Quit:xID=""
				
				Set objLabRep=##class(DHCMed.DC.LIS.LabReport).GetObjById(xID)
				Continue:'$IsObject(objLabRep)
				Continue:objLabRep.IsActive'=1
				
				Set TestSetNo=objLabRep.TestSetNo
				Set EpisodeNo=##class(DHCMed.DC.LIS.LabTestSet).GetEpisodeNoByTSNo(TestSetNo)
				Continue:EpisodeNo=""
				
				Set OEOrdID=""
				Set OEOrdID=$o(^OEORD(0,"EpisNo",EpisodeNo,OEOrdID))
				Continue:OEOrdID=""
				Set Paadm=$p($g(^OEORD(+OEOrdID)),"^",1)
				Continue:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Set AdmType=$p(AdmInfo,"^",2)
				Set AdmStatus=$p(AdmInfo,"^",20)
				Continue:(AdmType'="I")&&(AdmType'="E")    	//就诊类型过滤
				Continue:AdmStatus="C"     					//就诊状态过滤
				
				Set num=$i(^CacheTemp(repid,"CtlPaadm"))
				Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
			}
		}
	}
	
	Quit "OK"
	
GetIPAdmListErr
	Kill ^CacheTemp(repid,"CtlPaadm")
	Quit $ZError
}

/// 获取监控就诊列表(门诊患者)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).GetOPAdmList(repid)
ClassMethod GetOPAdmList(repid As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aFromDate,aToDate)
	Set return=""
	Quit:(repid="")||(aFromDate="")||(aToDate="") "Error"
	
	Set $ZT="GetOPAdmListErr"
	
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="O"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
			Set num=$i(^CacheTemp(repid,"CtlPaadm"))
			Set ^CacheTemp(repid,"CtlPaadm",xPaadm)=""
		}
	}
	
	Quit "OK"
	
GetOPAdmListErr
	Kill ^CacheTemp(repid,"CtlPaadm")
	Quit $ZError
}

/// 获取监控就诊列表(急诊患者)
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).GetEPAdmList("217010",63127,63127)
ClassMethod GetEPAdmList(repid As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aFromDate,aToDate)
	Set return=""
	Quit:(repid="")||(aFromDate="")||(aToDate="") "Error"
	
	Set $ZT="GetEPAdmListErr"
	//add by pylian 2015-07-10 112360 监控不到急诊门诊的数据
	//急诊患者列表
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="E"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			Set num=$i(^CacheTemp(repid,"CtlPaadm"))
			
			Set ^CacheTemp(repid,"CtlPaadm",xPaadm)=""
		}
	}
	//急诊未办理出院患者列表
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
				Continue:$p(AdmInfo,"^",2)'="E"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				
				Set num=$i(^CacheTemp(repid,"CtlPaadm"))
				Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
			}
		}
	}
	
	//急诊出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aFromDate:1:CurrDate {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,xDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="E"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)'="D"      //就诊状态过滤
			Continue:$p(AdmInfo,"^",6)>aToDate   //就诊时间过滤
			
			Set num=$i(^CacheTemp(repid,"CtlPaadm"))
			Set ^CacheTemp(repid,"CtlPaadm",Paadm)=""
		}
	}
	
	Quit "OK"
	
GetEPAdmListErr
	Kill ^CacheTemp(repid,"CtlPaadm")
	Quit $ZError
}

/// 获取监控项目列表
ClassMethod GetCtlItemList(repid As %String, aSubjectID As %String, aSubCatCode As %String = "", aKeywordCode As %String = "") As %String
{
	New (repid,aSubjectID,aSubCatCode,aKeywordCode)
	Set return=""
	Quit:(repid="")||(aSubjectID="") return
	
	Set $ZT="GetCtlItemListErr"
	
	Set xItemID=0,Count=0
	For {
		Set xItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",aSubjectID,1,xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemID=objItem.%Id()
		Set AdmType=objItem.AdmType
		Continue:AdmType=""
		
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItemDic.IDSubCatDr)
		Continue:'$IsObject(objSubCat)
		Set SubCatCode=objSubCat.ISCCode
		Continue:(aSubCatCode'="")&&(SubCatCode'=aSubCatCode)
		Set ISCKeyWord=objSubCat.ISCKeywordID
		
		Set KeyWordCode=""
		Set objKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(+ISCKeyWord)
		If $IsObject(objKeyWord) {
			Set KeyWordCode=objKeyWord.Code
		}
		If aKeywordCode'="" {
			Continue:KeyWordCode'=aKeywordCode
		}
		
		Set evaResult=##class(DHCMed.CCService.AutoProcess.ExpEvaluation).EvaExpression(objItemDic.IDExpression)
		If $li(evaResult,1)="OK" {
			//记录监控项目数量
			Set CtlItemCntStr=$g(^CacheTemp(repid,"CtlItem"))
			If AdmType["I" {
				Set tmpNum=+$p(CtlItemCntStr,",",1)
				Set $p(CtlItemCntStr,",",1)=tmpNum+1
			}
			If AdmType["O" {
				Set tmpNum=+$p(CtlItemCntStr,",",2)
				Set $p(CtlItemCntStr,",",2)=tmpNum+1
			}
			If AdmType["E" {
				Set tmpNum=+$p(CtlItemCntStr,",",3)
				Set $p(CtlItemCntStr,",",3)=tmpNum+1
			}
			Set ^CacheTemp(repid,"CtlItem")=CtlItemCntStr
			//记录监控项目信息
			Set ^CacheTemp(repid,"CtlItem",ItemID,"Expression")  = $li(evaResult,2)       //解析后的监控表达式
			Set ^CacheTemp(repid,"CtlItem",ItemID,"KeyWord")     = ISCKeyWord             //关键字
			Set ^CacheTemp(repid,"CtlItem",ItemID,"AdmType")     = AdmType                //就诊类型
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

/// 按照主题配置获取监控项目列表
ClassMethod GetCtlItems(repid As %String, aSubjectCode As %String) As %String
{
	New (repid,aSubjectCode)
	Set return=""
	Quit:(repid="")||(aSubjectCode="") return
	
	Set $ZT="GetCtlItemsErr"
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set xItemID=0,Count=0
	For {
		Set xItemID=$o(^DHCMed.CCi("SItem",0,"IndexSubjectID",SubjectID,1,xItemID))
		Quit:xItemID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set ItemID=objItem.%Id()
		Set AdmType=objItem.AdmType
		Continue:AdmType=""
		
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set SubCatDr=objItemDic.IDSubCatDr
		Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
		Continue:'$IsObject(objSubCat)
		Set ISCKeyWord=objSubCat.ISCKeywordID
		
		//Modified By LiYang 2014-07-07FixBug：无效过滤
		/*
		Set KeyWordCode=""
		Set objKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(+ISCKeyWord)
		If $IsObject(objKeyWord) {
			Set KeyWordCode=objKeyWord.Code
		}
		If aKeywordCode'="" {
			Continue:KeyWordCode'=aKeywordCode
		}
		*/
		
		Set evaResult=##class(DHCMed.CCService.AutoProcess.ExpEvaluation).EvaExpression(objItemDic.IDExpression)
		If $li(evaResult,1)="OK" {
			//记录监控项目数量
			Set CtlItemCntStr=$g(^CacheTemp(repid,"CtlItem"))
			If AdmType["I" {
				Set tmpNum=+$p(CtlItemCntStr,",",1)
				Set $p(CtlItemCntStr,",",1)=tmpNum+1
			}
			If AdmType["O" {
				Set tmpNum=+$p(CtlItemCntStr,",",2)
				Set $p(CtlItemCntStr,",",2)=tmpNum+1
			}
			If AdmType["E" {
				Set tmpNum=+$p(CtlItemCntStr,",",3)
				Set $p(CtlItemCntStr,",",3)=tmpNum+1
			}
			Set ^CacheTemp(repid,"CtlItem")=CtlItemCntStr
			//记录监控项目信息
			Set ^CacheTemp(repid,"CtlItem",ItemID,"Expression")  = $li(evaResult,2)       //解析后的监控表达式
			Set ^CacheTemp(repid,"CtlItem",ItemID,"KeyWord")     = ISCKeyWord             //关键字
			Set ^CacheTemp(repid,"CtlItem",ItemID,"AdmType")     = AdmType                //就诊类型
		} Else {
			For indErr=2:1:$ll(evaResult) {
				//记录错误日志
				//Modified By LiYang 2014-07-06 拼写错误,没有“aSubjectID”变量
				//Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),0,aSubjectID,0,objItemDic.IDExpression_":"_$li(evaResult,indErr))
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),0,SubjectID,0,objItemDic.IDExpression_":"_$li(evaResult,indErr))
			}
		}
	}
	
	Quit "OK"
	
GetCtlItemsErr
	Kill ^CacheTemp(repid,"CtlItem")
	Quit $ZError
}

/// 获取监控结果
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).GetExamList(repid,SubjectID,FromDate,ToDate)
ClassMethod GetExamList(repid As %String, aSubjectID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (repid,aSubjectID,aFromDate,aToDate)
	Set return="",Count=0
	Quit:(repid="")||(aSubjectID="")||(aFromDate="")||(aToDate="") return
	
	Set $ZT="GetExamListErr"
	
	Set xPaadm=0
	For {
		Set xPaadm=$o(^CacheTemp(repid,"CtlPaadm",xPaadm))
		Quit:xPaadm=""
		
		w "Paadm="_xPaadm,!
		Set num=$i(^CacheTemp(repid,"GetExamList"))
		
		Set EpisodeID=xPaadm
		Set %PAADM=EpisodeID       //就诊号
		Set %EpisodeID=EpisodeID   //就诊号
		Set %FromDate=aFromDate    //开始日期
		Set %ToDate=aToDate        //结束日期
		Set %CurrentDate=+$h       //当前日期
		Set %TotalScore=0          //得分情况
		Set %TotalFireItmCnt=0     //触发项目计数
		Set %TotalFireItmType=0    //触发项目类别计数
		Set %DetailList=$lb("")    //触发项目明细
		
		Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		
		Set xItemID=""
		For {
			Set xItemID=$o(^CacheTemp(repid,"CtlItem",xItemID))
			Quit:xItemID=""
			
			Set CtlAdmType=$g(^CacheTemp(repid,"CtlItem",xItemID,"AdmType"))
			Continue:CtlAdmType'[AdmType  //过滤就诊类型与监控项目对应就诊类型不匹配的项目
			
			Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemID=objItem.%Id()
			
			//表达式、关键字、就诊类型
			Set ItemExp=$g(^CacheTemp(repid,"CtlItem",ItemID,"Expression"))    //表达式
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
						
						//结果日期
						Set:$p(itm,$c(3),2)["-" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),3)
						Set:$p(itm,$c(3),2)["/" $p(itm,$c(3),2)=$zdh($p(itm,$c(3),2),4)
						Set:$p(itm,$c(3),3)[":" $p(itm,$c(3),3)=$zth($p(itm,$c(3),3),1)
						//发生日期
						Set:$p(itm,$c(3),8)["-" $p(itm,$c(3),8)=$zdh($p(itm,$c(3),8),3)
						Set:$p(itm,$c(3),8)["/" $p(itm,$c(3),8)=$zdh($p(itm,$c(3),8),4)
						Set:$p(itm,$c(3),9)[":" $p(itm,$c(3),9)=$zth($p(itm,$c(3),9),1)
						//开始日期
						Set:$p(itm,$c(3),11)["-" $p(itm,$c(3),11)=$zdh($p(itm,$c(3),11),3)
						Set:$p(itm,$c(3),11)["/" $p(itm,$c(3),11)=$zdh($p(itm,$c(3),11),4)
						Set:$p(itm,$c(3),12)[":" $p(itm,$c(3),12)=$zth($p(itm,$c(3),12),1)
						//结束日期
						Set:$p(itm,$c(3),13)["-" $p(itm,$c(3),13)=$zdh($p(itm,$c(3),13),3)
						Set:$p(itm,$c(3),13)["/" $p(itm,$c(3),13)=$zdh($p(itm,$c(3),13),4)
						Set:$p(itm,$c(3),14)[":" $p(itm,$c(3),14)=$zth($p(itm,$c(3),14),1)
						
						Set ActDate=$p(itm,$c(3),2)
						Set EndDate=$p(itm,$c(3),13)
						Set EndTime=$p(itm,$c(3),14)
						Set ObjectID=$p(itm,$c(3),5)
						
						//主要处理监控结果回写结束日期问题
						If EndDate'="" {
							Continue:((EndDate<aFromDate)||(EndDate>aToDate))
							Set flg1=..UpdateEndDate(ActDate,EpisodeID,objItem.%Id(),ObjectID,EndDate,EndTime)
							If flg1<0 {
								//记录错误日志
								Set error="保存监控结果(回写结束日期)错误,ErrCode="_flg1_",Input="_ActDate_","_EpisodeID_","_objItem.%Id()_","_ObjectID_","_EndDate_","_EndTime
								Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),EpisodeID,objItem.SubjectID,objItem.%Id(),error)
							}
						}
						
						//按照结果日期过滤监控结果
						Continue:((ActDate<aFromDate)||(ActDate>aToDate))
						
						Set num=$i(^CacheTemp(repid,"GetExamList",0))
						
						Set aInput=""
						Set $p(aInput,$c(1),1)=""                     // ID
						Set $p(aInput,$c(1),2)=EpisodeID              // 就诊号
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
							Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),EpisodeID,objItem.SubjectID,objItem.%Id(),error)
						} Else {
							Set num=$i(^CacheTemp(repid,"GetExamList",1))
						}
					}
				}
				For indErr=1:1:$ListLength(%ErrorData) {
					//记录错误日志
					Set error=$lg(%ErrorData,indErr)
					Continue:error=""
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),EpisodeID,objItem.SubjectID,objItem.%Id(),error)
				}
			} Else {
				//记录错误日志
				Set error="表达式:"_$li(expResult,3)_";错误信息:"_$li(expResult,2)
				Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h, $p($h,",",2),EpisodeID,objItem.SubjectID,objItem.%Id(),error)
			}
		}
	}
	
	Quit "OK"
	
GetExamListErr
	Kill ^CacheTemp(repid,"GetExamList")
	Quit $ZError
}

ClassMethod UpdateEndDate(aActDate As %String, aEpisodeID As %String, aItemID As %String, aObjectID As %String, aEndDate As %String, aEndTime As %String)
{
	new (aActDate,aEpisodeID,aItemID,aObjectID,aEndDate,aEndTime)
	set return=0
	quit:(aActDate="")||(aEpisodeID="")||(aItemID="")||(aObjectID="")||(aEndDate="") return
	
	Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexActDateEpisodeID",aActDate,aEpisodeID,aItemID," "_$zcvt(aObjectID,"U"),0))
	quit:ResultID="" return
	set return=##Class(DHCMed.CC.CtlResult).UpdateEndDate(ResultID,+aEndDate,+aEndTime)
	
	quit return
}

/// 生成时间线数据
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).ProTimeLine()
ClassMethod ProTimeLine(repid As %String, aSubjectID As %String, aCtlDate As %Date, aEpisodeID As %String = "") As %String
{
	New (repid,aSubjectID,aCtlDate,aEpisodeID)
	Quit:(aSubjectID="")||(aCtlDate="") ""
	
	Set $ZT="ProTimeLineErr"
	
	Set:aCtlDate["-" aCtlDate=$zdh(aCtlDate,3)
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID))
		Quit:EpisodeID=""
		Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
		Continue:'$d(^CacheTemp(repid,"CtlPaadm",EpisodeID))
		
		//清除时间线历史数据
		Set flg=##Class(DHCMed.CCService.IntegratedCtrl.TimeLineService).DeleteByAdm(aSubjectID,aCtlDate,EpisodeID)
		
		Set SubjectID=""
		For {
			Set SubjectID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID))	
			Quit:SubjectID=""
			Continue:(aSubjectID'="")&&(aSubjectID'=SubjectID)
			
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",aCtlDate,EpisodeID,SubjectID,xResultID))
				Quit:xResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				Continue:'$IsObject(objResult)
				
				Set num=$i(^CacheTemp(repid,"ProTimeLine"))
				
				//存储时间线数据
				//(DHCMed.CC.KeyWord).时间线子项代码==(icare.ClinicalDataType).时间线子项代码
				//(DHCMed.CC.KeyWord).TimeLineCode==(icare.ClinicalDataType).Code
				Set flg=##class(DHCMed.CCService.IntegratedCtrl.TimeLineService).Update(objResult)
				If flg<-100 {
					Set error="同步时间线数据报错,ErrCode="_flg_",CtlResultID="_objResult.%Id()
					Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),objResult.EpisodeID,objResult.SubjectID,objResult.ItemId,error)
				} Else {
					Set num=$i(^CacheTemp(repid,"ProTimeLine",1))
				}
			}
		}
	}
	
	Quit "OK"
	
ProTimeLineErr
	Kill ^CacheTemp(repid,"ProTimeLine")
	Quit $ZError
}

/// 结束时间线数据
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).CloseTimeLine()
ClassMethod CloseTimeLine(repid As %String, aSubjectID As %String, aEpisodeID As %String = "") As %String
{
	New (repid,aSubjectID,aEpisodeID)
	Set return=""
	Quit:aSubjectID="" return
	
	Set $ZT="CloseTimeLineErr"
	
	Set xPaadm=0
	For {
		Set xPaadm=$o(^CacheTemp(repid,"CtlPaadm",xPaadm))
		Quit:xPaadm=""
		Continue:(aEpisodeID'="")&&(aEpisodeID'=xPaadm)
		
		Set xKeyWord=""
		For {
			Set xKeyWord=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeKeyword",xPaadm,aSubjectID,xKeyWord))
			Quit:xKeyWord=""
			
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeKeyword",xPaadm,aSubjectID,xKeyWord,xResultID))
				Quit:xResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				Continue:'$IsObject(objResult)
				Set EpisodeID=objResult.EpisodeID
				Set ObjectID=objResult.ObjectID
				Set KeyWord=objResult.KeyWord
				Set objKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(KeyWord)
				Continue:'$IsObject(objKeyWord)
				Set TimeLineCode=objKeyWord.TimeLineCode
				Continue:TimeLineCode=""
				
				//时间线过滤
				Continue:'$d(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,TimeLineCode," "_ObjectID))
				Continue:$d(^icare.ClinicalRepositoryI("IndexAct"," "_EpisodeID,TimeLineCode," "_ObjectID,"060102"))
				
				Set ObjCategory=objResult.ObjCategory
				If ObjCategory="OE" {
					//处理长期医嘱情况
					Continue:$l(ObjectID,"||")'=2
					
					Set OrdID=$p(ObjectID,"||",1)
					Set SubID=$p(ObjectID,"||",2)
					Continue:(OrdID="")||(SubID="")
					
					Set PriorityID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",8)
					Set Priority=$g(^OECPR(+PriorityID))
					Continue:Priority'["长期"
					
					Set XDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",34)  ;医嘱停止日期
					Set XTime=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",15)  ;医嘱停止时间
					If XDate="" {
						//Set XDate=$p($g(^PAADM(EpisodeID)),"^",17)  ;最终结算日期
						//Set XTime=$p($g(^PAADM(EpisodeID)),"^",18)  ;最终结算时间
						//Update by pylian 2016-01-22 修改出院时间取值方式
						Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
						Set XDate=$p(DischDateTime,"^",1)
						Set XTime=$p(DischDateTime,"^",2)
					}
					Continue:(XDate="")||(XTime="")
					
					Set num=$i(^CacheTemp(repid,"CloseTimeLine"))
					
					//关闭时间线数据
					//(DHCMed.CC.KeyWord).时间线子项代码==(icare.ClinicalDataType).时间线子项代码
					//(DHCMed.CC.KeyWord).TimeLineCode==(icare.ClinicalDataType).Code
					Set flg=##class(DHCMed.CCService.IntegratedCtrl.TimeLineService).Close(objResult,XDate,XTime)
					If flg<-100 {
						Set error="关闭时间线数据报错,ErrCode="_flg_",CtlResultID="_objResult.%Id()
						Do ##class(DHCMed.CC.ErrorLog).SaveErrorLog(+$h,$p($h,",",2),objResult.EpisodeID,objResult.SubjectID,objResult.ItemId,error)
					} Else {
						Set num=$i(^CacheTemp(repid,"CloseTimeLine",1))
					}
				} Else {
					//处理其他情况
				}
			}
		}
	}
	
	Quit "OK"
	
CloseTimeLineErr
	Kill ^CacheTemp(repid,"CloseTimeLine")
	Quit $ZError
}

/// w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).Test()
ClassMethod Test()
{
	Set repid=$i(^CacheTemp)
	
	Set EpisodeID="632944"
	Set SubjectID="5"
	Set CtlDate=""
	//w ##Class(DHCMed.CCService.AutoProcess.CoreVMNew).ProTimeLine(repid,SubjectID,CtlDate,EpisodeID)
	
	Set EpisodeID="632944"
	Set SubjectID="5"
	Set ^CacheTemp(repid,"CtlPaadm",EpisodeID)=""
	Set flg=##Class(DHCMed.CCService.AutoProcess.CoreVMNew).CloseTimeLine(repid,SubjectID,EpisodeID)
	If flg'="OK" {
		Write flg,!
	}
	
	Kill ^CacheTemp(repid)
	
	Quit "OK"
}

}
