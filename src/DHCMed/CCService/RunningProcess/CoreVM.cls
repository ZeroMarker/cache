/// 在业务过程中的监控
/// 主要项目代码、关键字进行部分主题项目的监控
/// 创建者：李阳
/// 创建日期：2012-10-30
Class DHCMed.CCService.RunningProcess.CoreVM Extends DHCMed.Abstract [ Not ProcedureBlock ]
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
/// 自动监控日志记录在<B>^DHCMed.CC.CtlResultL("ErrLog")</B>和<B>^DHCMed.CC.CtlResultL("CtlLog")</B>中。
/// 类库运行异常，系统会将错误日志存储在类<B>DHCMed.CC.ErrorLog</B>中，管理员应该经常检查此实体类的内容。
/// w ##Class(DHCMed.CCService.AutoProcess.CoreVM).Process("16","2009-01-01","2009-01-03")
ClassMethod Process(aSubjectID As %Integer, aFromDate As %Date, aToDate As %String, aEpisodeID As %String = "", aKeywordID As %Integer) As %String
{
	New (aSubjectID, aFromDate, aToDate, aEpisodeID,aKeywordID)
	Set return=""
	Quit:(aSubjectID="")||(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set $ZT="ProcessErr"
	
	//获取临时Global进程号
	Set repid=$I(^CacheTemp)
	
	//清除监控结果历史数据(防止多次调用引起的数据重复)
	Do ##class(DHCMed.CC.CtlResult).ClearData(aFromDate,aToDate,aSubjectID,aEpisodeID,aKeywordID)
	//获取监控项目列表
	//^CacheTemp(repid,"CtlItem")
	Kill ^CacheTemp(repid,"CtlItem")
	Set flg=..GetCtlItemList(repid,aSubjectID,aKeywordID)
	If flg'="OK" {
		Kill ^CacheTemp(repid)
		Set ^DHCMed.CC.CtlResultL("ErrLog",aSubjectID,$h,"GetCtlItemList")=flg
	}
	
	//获取就诊列表
	Set ctlDate=+$h
	//^CacheTemp(repid,"CtlPaadm")
	Kill ^CacheTemp(repid,"CtlPaadm")
	
		//清空监控日志记录
		Kill ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3))
		
		//按天执行监控,并同步保存监控结果
		Set flg=..ExamPaadm(aEpisodeID,aSubjectID,aFromDate,aToDate)
		If flg'="OK" {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlResult")=flg
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlResult")="OK"
		}
	For ctlDate=aFromDate:1:aToDate {	
		//计算合计信息
		Set flg=##class(DHCMed.CCService.AutoProcess.CoreVM).CalcSummary(aSubjectID,ctlDate,aEpisodeID)
		If flg'="OK" {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlSummary")=flg
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlSummary")="OK"
		}
		
		//同步更新时间线数据   ***********************************************************************
		Set flg=..ProTimeLine(aSubjectID,ctlDate,aEpisodeID)
		If flg'="OK" {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlTimeLine")=flg
		} Else {
			Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlTimeLine")="OK"
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
ClassMethod ExamPaadm(Paadm As %Integer, aSubjectID As %String, aFromDate As %String, aToDate) As %String
{
	Quit:(repid="")||(aSubjectID="") ""
	
	;Set $ZT="ExamPaadmListErr"
	
	Set %AutoRunFlag=1         //自动业务处理标志
	
	//初始化加载配置项目
	Do ##class(DHCMed.CCService.AutoProcess.CoreVM).GetVMConfig(aSubjectID,"S")
	
	Set num=$i(^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlPaadmCnt"))
	//Set ^DHCMed.CC.CtlResultL("CtlLog",aSubjectID,$zd(+ctlDate,3),"CtlPaadmDtl",Paadm)=""
	
	Set %PAADM=Paadm           //就诊号
	Set %EpisodeID=Paadm       //就诊号
	Set %TotalScore=0          //得分情况
	Set %TotalFireItmCnt=0     //触发项目计数
	Set %TotalFireItmType=0    //触发项目类别计数
	Set %DetailList=$lb("")    //触发项目明细
	
	//初始化加载配置项目
	Do ##class(DHCMed.CCService.AutoProcess.CoreVM).GetVMConfig(aSubjectID,"L")
	
	Set ItemID=""
	For {
		Set ItemID=$o(^CacheTemp(repid,"CtlItem",ItemID))
		Quit:ItemID=""
		
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		
		//判断监控项目是否只运行一次
		Set RunOnce=+objItem.IsRunOnce
		If (RunOnce>0) {
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",objItem.%Id(),ResultID))
				Quit:ResultID=""
				Do ##class(DHCMed.CC.CtlResult).%DeleteId(ResultID)
			}
			
		}
		
		//运行监控表达式,获取监控结果
		Set ItemExp=$g(^CacheTemp(repid,"CtlItem",ItemID,"Expression"))    //解析后的监控表达式
		Set KeyWord=$g(^CacheTemp(repid,"CtlItem",ItemID,"KeyWord"))       //关键字
		
		Set %PAADM=Paadm
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
					//按照时间过滤 如果是【只监控一次】的项目，就忽略时间性要求，直接可以改写以前的数据 
					Continue:((aFromDate'="")&&($p(itm,$c(3),2)<aFromDate)&&(RunOnce=0))
					Continue:((aToDate'="")&&($p(itm,$c(3),2)>aToDate)&&(RunOnce=0))
					
					//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
					Set aInput=""
					Set $p(aInput,$c(1),1)=""                     // ID
					Set $p(aInput,$c(1),2)=%PAADM                 // 就诊号
					Set $p(aInput,$c(1),3)=+$h           // 记录日期
					Set $p(aInput,$c(1),4)=objItem.%Id()          // 监控项目ID
					Set $p(aInput,$c(1),5)=$p(itm,$c(3),2)        // 日期
					Set $p(aInput,$c(1),6)=$p(itm,$c(3),3)        // 时间
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
		
	//清除配置项目
	Do ##class(DHCMed.CCService.AutoProcess.CoreVM).ClearVMConfig(aSubjectID,"L")
	
	//清除配置项目
	Do ##class(DHCMed.CCService.AutoProcess.CoreVM).ClearVMConfig(aSubjectID,"S")
	
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
				If tmpID<0 {
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

/// 获取监控项目列表
ClassMethod GetCtlItemList(repid As %String, aSubjectID As %String, aKeywordID As %Integer) As %String
{
	New (repid,aSubjectID,aKeywordID)
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
			Continue:((aKeywordID'="")&&(KeyWord'=aKeywordID)) //Modified By LiYang 2012-10-30 
		}
		
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

}
