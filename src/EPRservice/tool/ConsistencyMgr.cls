/// 名称：EPRservice.tool.ConsistencyMgr
/// 描述：电子病历数据一致性检查工具
/// 	  
/// 	  方法1: 批量检查日志和病历一致性
/// 	  w ##class(EPRservice.tool.ConsistencyMgr).CheckLogAndInstance
/// 	  
/// 	  方法2: 批量修改日志和病历一致性
/// 	  w ##class(EPRservice.tool.ConsistencyMgr).SyncLogAndInstance
/// 创建者：houj
/// 创建日期：2010-01-28
Class EPRservice.tool.ConsistencyMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 批量检查日志和病历一致性
/// Input: stEpisodeID 就诊rowid,totCount 检查的就诊rowid数量
/// Output: 统计信息文件,生成在数据库服务器上,文件名见termianl输出信息
/// CreateDate: 2010-02-03
/// CreateUser: houj
/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).CheckLogAndInstance("1","10000")
ClassMethod CheckLogAndInstance(stEpisodeID As %String, totCount As %Integer) As %String
{
	s fileName = ..GetFileName(stEpisodeID,totCount)
	q:(fileName="")
	
	//输出信息到文件
	s date = $zd($P($h,",",1),3)
	s time = $zt($P($h,",",2),1)
	s startInfo =  "==================="
	s startInfo = startInfo_$C(13)_$C(10)_"检查开始日期: "_date_", 开始时间: "_time_", 就诊起始rowid: "_stEpisodeID_",  计划检查就诊数量为: "_totCount
	d ..ExportInfo(fileName, startInfo_$C(13)_$C(10))
	w startInfo,!
	
	s count = 0
	s errCount = 0
	
	
	//遍历就诊表
	s episodeID = stEpisodeID
	for {
		q:(episodeID="")
		q:(count'<totCount)
		
		w "检查"_..GetPatientInfo(episodeID),!
		d ..CheckMulti(episodeID,fileName,.errCount)	
		
		s episodeID = $O(^PAADM(episodeID))
		s count = count + 1 
	}
	
	//输出统计信息到文件
	s date = $zd($P($h,",",1),3)
	s time = $zt($P($h,",",2),1)
	s statInfo = "==================="
	s statInfo = statInfo_$C(13)_$C(10)_"检查结束日期:"_date_", 结束时间: "_time_", 就诊起始rowid: "_stEpisodeID_", 实际检查就诊数量为: "_count
	s statInfo = statInfo_$C(13)_$C(10)_"其中病历和日志不一致的数据有: "_errCount
	s statInfo = statInfo_$C(13)_$C(10)_"统计信息文件: "_fileName
	w statInfo,!
	d ..ExportInfo(fileName, statInfo_$C(13)_$C(10))
	q "1"
}

ClassMethod CheckMulti(episodeID As %String, fileName As %String, ByRef errCount As %Integer)
{
	//遍历电子病历实例数据
	s chartID = " ML"
	for {
		s chartID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, chartID))
		q:(chartID="")
		q:($find(chartID, " ML")'=4)
		
		//是否为可重复病历	
		//if $find(chartID," ML")'=4 continue
		
		s prtDocID = $e(chartID, 4, $L(chartID))
		if prtDocID="" continue
		
		s countOK = ##Class(EPRinstance.EPRLogs).CheckMultiLogsCount(episodeID, prtDocID)
		s listOK = ##Class(EPRinstance.EPRLogs).CheckMultiLogs(episodeID, prtDocID)		
		
		if (countOK'="1")||(listOK'="1")
		{
			//输出错误信息到文件
			s errCount = errCount + 1
			s errInfo = ..GetErrorInfo(countOK, listOK)
			s patInfo = ..GetPatientInfo(episodeID)
			s recInfo = ..GetRecordInfo(prtDocID)
			s extInfo = "--------------------"_$C(13)_$C(10)_patInfo_$C(13)_$C(10)_recInfo_$C(13)_$C(10)_errInfo
			d ..ExportInfo(fileName, extInfo_$C(13)_$C(10))
			w "-----------"_$C(13)_$C(10)_"异常信息: "_recInfo_" : "_errInfo_$C(13)_$C(10)_"-----------------",!
		}	
	}
}

/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).GetFileName("65","100")
ClassMethod GetFileName(episodeId As %String, count As %String) As %String
{
	s fileNameStr = ""
	
	//检查临时目录是否存在
	s filePath=$ZUTIL(12,"")_"Temp"
	if '##Class(%Library.File).DirectoryExists(filePath)
	{
		s isOK = ##Class(%Library.File).CreateDirectoryChain(filePath)
		if $$$ISERR(isOK)
		{
			w "创建目录:"_filePath_" 失败!"	
			q ""
		}
	}
	
	//根据操作系统信息生成文件全名称
	s fileName = "dhcepr_consist_check_"_episodeId_"_"_count_".txt"
	s osString = ##class(%SYSTEM.Version).GetOS()
 	s windowsFlag =$Find(osString,"Windows") 
 	s unixFlag =$Find(osString,"UNIX") 
	if (windowsFlag>0) 
	{	s fileNameStr = filePath_"\"_fileName}
	elseif (unixFlag>0) 
	{	s fileNameStr = filePath_"/"_fileName}
	
	q fileNameStr
}

/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).ExportInfo("d:\trakcarelive\db\trak\websrc\Temp\dhcepr_1.txt","testinfo")
ClassMethod ExportInfo(fileName As %String, info As %String) As %String
{
	 
	s stream=##class(%FileCharacterStream).%New()
	s stream.Filename = fileName
	d stream.MoveToEnd()
	d stream.Write(info)
	d stream.SaveStream()
	d stream.%Close()
}

ClassMethod GetPatientInfo(admId As %String)
{
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(admId)
	s papmiNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDR)
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmiDR)
	s sex = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(papmiDR)
	s sex = $P(sex,"^",3)
	
	s retVal = "病人信息: {姓名: "_name_"},{性别:"_sex_"},{登记号:"_papmiNo_"},{EpisodeID:"_admId_"}"
	q retVal
}

ClassMethod GetRecordInfo(prtDocId As %String)
{
	s retVal = ""
	s objPrintDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(prtDocId)
	q:(objPrintDoc="") ""
	s objCateChapter = ##class(EPRmeta.EPRTemplateCategory).%OpenId(objPrintDoc.ParentCategoryID)
	s objCategory = ##class(EPRmeta.EPRTemplateCategory).%OpenId(objCateChapter.ParentCategoryID)
	
	s retVal = "病历信息: "
	s retVal = retVal_"{主目录: "_objCategory.%Id()_", "_objCategory.CategoryName_"},"
	s retVal = retVal_"{章节目录: "_objCateChapter.%Id()_", "_objCateChapter.CategoryName_"},"
	s retVal = retVal_"{打印目录: "_objPrintDoc.%Id()_", "_objPrintDoc.CategoryName_"}"
	
	q retVal
}

ClassMethod GetErrorInfo(countOK As %String, listOK As %String)
{
	s errStr = ""
	
	if countOK '= 1
	{	
		s errStr = "日志和病历数量不相等"
	}
	if listOK '= 1
	{
		if errStr=""	
		{	s errStr = "日志EPRNum和病历ListNo不对应"}
		else
		{	s errStr = errStr_", 日志EPRNum和病历ListNo不对应"}
	}
	
	s errStr = "错误信息: "_"{"_errStr_"}"
	q errStr
}

/// Desc: 批量修改日志和病历一致性
/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).SyncLogAndInstance("49","24")
ClassMethod SyncLogAndInstance(episodeId As %String, prtDocId As %String)
{
	q:(episodeId="")||(prtDocId="") "输入参数错误!"
	
	//确认要修改的信息
	s tips = ..GetPatientInfo(episodeId)
	s tips = tips_$C(10)_$C(13)_..GetRecordInfo(prtDocId)
	q:(..Confirm(tips)="N") "您拒绝了当前操作!"
	
	//问题2：日志和病历是否一一对应,即 EPRLogs的EPRNum 是否和 InstanceData的ListNo 一一对应
	d ..SyncDetail(episodeId, prtDocId)
}

/// Desc:	与用户交互, 决定是否继续操作
ClassMethod Confirm(argTip As %String) As %String
{
	
	s input = ""
	
	w argTip,!
	
	//与用户交互
	for {	
		Read "[是]请输入y, [否]请输入n :   ", input
		w !
		
		//合法选项: Y 或 N
		q:($zcvt(input,"U")="Y")
		q:($zcvt(input,"U")="N")
		
		//非法选项
		if input="" 
		{	
			w "不能输入空值!",!
			continue
		}
		elseif $F(input," ")>0
		{	
			w "输入字符含有空格!",!
			continue
		}
		else
		{
			w "只能输入y或n!",!
		} 
	}
	
	q $zcvt(input,"U")
}

ClassMethod SyncDetail(episodeId As %String, prtDocId As %String)
{
	s tmpPrtDocId = "ML"_prtDocId
	s instanceCount = "", ecRecordID = ""
	&sql(select ID, InstanceCount into :ecRecordID, :instanceCount 
	     from EPRinstance.ECRecord 
	     where EpisodeID = :episodeId and ChartItemID = :tmpPrtDocId)
	
	if (ecRecordID="")||(instanceCount<1)
	{
		w !,"未找到相应病历"
		q
	}
	
	//同步ECRecord.InstanceCount内的数据和日志
	for listNo = 1:1:instanceCount 
	{
		w !, "----------------------------------"
		w !, "开始同步第 "_listNo_" 条数据"
		s eprNum = listNo
		s sub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, " "_listNo, ""))
		if (sub="") 
		{
			//b "s"
			//数据不存在,相应日志也应该删除
			s tmpid = ""
			&sql(select ID into :tmpid from EPRinstance.EPRLogs 
				where EpisodeID = :episodeId and EPRDocID = :prtDocId and EPRNum = :eprNum)	
			if (tmpid '= "")&&(tmpid'="0")
			{
				&sql(delete from EPRinstance.EPRLogs where ID = :tmpid)	
				w !, "数据不存在,但日志存在,清除相应日志"
			}
			else
			{
				w !, "数据和日志都不存在,不需处理"
			}
			
		}
		else
		{
			//数据存在,同步数据和日志的发生日期时间
			s instanceId = ecRecordID_"||"_sub
			if '..SyncEPRNumDetail(episodeId,prtDocId,eprNum,instanceId)
			{
				w !, "自动同步出现错误,请根据提示手动修改!"
				q
			}
		}
		
		w !, "成功!"
	}
}

ClassMethod SyncEPRNumDetail(episodeId As %String, prtDocId As %String, eprNum As %String, instanceId As %String) As %String
{
	//同步是否成功
	s isSuccess = "0"
	
	//1：先判断数据和日志是否已经是同步的
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
	if objInstance = ""
	{
		w !, "同步实例数据: "_instanceId_" 对应EPRLogs出现错误! 错误原因：未找到实例数据"
		q isSuccess
	}
	s happenDate = objInstance.HappenDate
	s happenTime = objInstance.HappenTime
	if (happenDate="")||(happenTime="")
	{
		w !, "同步实例数据: "_instanceId_" 对应EPRLogs出现错误! 错误原因：实例数据发生日期时间为空"
		q isSuccess
	}
	
	s logsId = ""
	&sql(SELECT ID into :logsId
		FROM EPRinstance.EPRLogs
		WHERE EpisodeID = :episodeId and EPRDocID=:prtDocId and EPRNum=:eprNum)
	if logsId '= ""
	{
		s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(logsId)
		if (objEPRLogs.HappenDate=happenDate)&&(objEPRLogs.HappenTime=happenTime)
		{
			w !, "数据和日志已经是同步的, 不需处理"
			q "1"
		}
		s objEPRLogs = ""
	}
	
	
	//2：不是同步的,先校验要同步的发生日期时间是否有效,如果无效,先自动找到一个有效的日期时间
	s modifyFlag = "0"
	s i = 0
	for {
		s isLogDTValid = ..IsLogHappenDTValid(episodeId,prtDocId,eprNum,happenDate,happenTime)
		s isInsDTValid = ..IsInsHappenDTValid(instanceId,happenDate,happenTime)	
		if (isLogDTValid)&&(isInsDTValid)
		{
			q 
		}
		else
		{
			s happenTime = happenTime + 1
			if happenTime >= "86399"
			{
				s happenDate = happenDate + 1
				s happenTime = "1"
			}
			s modifyFlag = "1"
		}	
		
		s i = i + 1
		q:(i>=60)
	}	
	if ('isLogDTValid)||('isInsDTValid)
	{
		w !, "同步实例数据: "_instanceId_" 对应EPRLogs出现错误! 错误原因：无法找到合法的发生日期时间"
		q isSuccess
	}
	
	//3:不是同步的,开启一个事务,同步发生日期时间
	Tstart
	
	//3.1：修改了发生日期时间,先修改数据的相应发生日期时间
	if modifyFlag="1"
	{
		s objInstance.HappenDate = happenDate
		s objInstance.HappenTime = happenTime
		if $$$ISERR(objInstance.%Save())
		{
			TRollBack
			w !, "同步实例数据: "_instanceId_" 对应EPRLogs出现错误! 错误原因：更新实例数据发生日期时间错误"
			q isSuccess
		}
		
		w !, "当前数据发生日期时间无效,为其自动匹配有效的日期时间,比原时间推后 "_i_" 秒"
	}
	
	//3.2：同步EPRLogs的发生日期时间,若EPRLogs不存在,则创建一条新的
	if (logsId'="")
	{
		//b "s"
		//同步已有的EPRLogs的发生日期时间
		s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(logsId)
		s objEPRLogs.HappenDate = happenDate
		s objEPRLogs.HappenTime = happenTime
		if $$$ISERR(objEPRLogs.%Save())
		{
			TRollBack
			w !, "同步实例数据: "_instanceId_" 对应EPRLogs出现错误! 错误原因：更新EPRLogs发生日期时间错误"
			q isSuccess
		}
		w !, "数据和日志都存在,同步发生日期时间成功!"
	}
	else
	{
		//创建新的EPRLogs
		if objInstance.CreateUser  = ""
		{
			TRollBack
			w !, "同步实例数据: "_instanceId_" 出现错误! 错误原因：实例数据创建者为空,无法生成EPRLogs"
			q isSuccess
		}
		s createDate = objInstance.CreateDate
		s createTime = objInstance.CreateTime
		if createDate=""
		{	s createDate=$p($H,",",1)}
		if createTime=""
		{	s createTime=$p($H,",",2)}
		if '..CreateEPRLog(episodeId,prtDocId,eprNum,"complete","127.0.0.1",objInstance.CreateUser,happenDate,happenTime,createDate,createTime)
		{
			TRollBack
			w !, "同步实例数据: "_instanceId_" 出现错误! 错误原因：新增EPRLogs失败"
			q isSuccess
		}
		w !, "数据存在，但日志不存在,创建新EPRLogs成功!"
	}
	
	TCommit
	
	s isSuccess="1"
	q isSuccess
}

/// Desc: 校验发生日期和时间是否合法：EpisodeID + EPRDocID + HappenDate + HappenTime 应该唯一
/// Input: parEpisodeID: 就诊rowid
/// 		parEPRDocID：打印模板在病历结构表中的ID
/// 		parHappendDate: 发生日期
/// 		parHappendTime: 发生时间
/// 		parEPRLogsID: EPRLogs的rowid,未保存过的为空
/// Output：无
/// Return：1：合法			0：非法		-1：非法参数
ClassMethod IsLogHappenDTValid(parEpisodeID As %String, parEPRDocID As %String, parEPRNum As %String, parHappenDate As %String, parHappenTime As %String) As %String
{
	s rowid ="", eprNum = ""
	
	&sql(select ID, EPRNum into :rowid, :eprNum 
		from EPRinstance.EPRLogs 
		where EpisodeID = :parEpisodeID and HappenDate = :parHappenDate and HappenTime = :parHappenTime and EPRDocID = :parEPRDocID)
	
	//未发现记录,合法
	q:(rowid="") 1
	
	//发现记录,但记录为其自身,合法
	q:(rowid'="")&&(eprNum=parEPRNum) 1
	
	//发现其它发生日期时间相同的记录,非法
	q 0
}

ClassMethod IsInsHappenDTValid(parInstanceId As %String, parHappenDate As %String, parHappenTime As %String) As %String
{
	s ecRecordId = $P(parInstanceId, "||", 1)
	
	s sameTimeCount = -1
 	s uniqueInstanceId = ""
 	
	&sql(select count(HappenDate), ID into :sameTimeCount, :uniqueInstanceId  
		from EPRinstance.InstanceData 
		where TheECRecord = :ecRecordId and HappenDate = :parHappenDate and HappenTime = :parHappenTime)
	 	
	
	//未找到相应发生日期时间,合法
	q:((sameTimeCount=0)||(sameTimeCount="")) "1"
	
	//找到相同发生日期时间,但只有一条,且为自己,合法
	q:(sameTimeCount=1)&&(uniqueInstanceId=parInstanceId) "1"
	 
	//相同发生日期时间,只有一条但不是自己,非法	
	//找到多条同样的发生日期时间,非法
	q "0"
}

ClassMethod CreateEPRLog(parEpisodeID As %String, parEPRDocID As %String, parEPRNum As %String, parAction As %String, parIP As %String, parUserID As %String, parHappenDate As %String, parHappenTime As %String, parCreateDate As %String, parCreateTime As %String) As %String
{
	q:(($d(parEpisodeID)=0)||($d(parEPRDocID)=0)||($d(parAction)=0)||($d(parIP)=0)||($d(parUserID)=0)) "0"
	q:(($d(parHappenDate)=0)||($d(parHappenTime)=0)) "0"
	q:((parEpisodeID="")||(parEPRDocID="")||(parAction="")||(parIP="")||(parUserID="")) "0"
	q:((parHappenDate="")||(parHappenTime="")) "0"
	q:((parEPRNum="")||(parEPRNum<0)) "0"
		
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%New()
	q:(objEPRLogs="") "0"
	
	s objEPRLogs.EpisodeID = parEpisodeID
	s objEPRLogs.EPRDocID = parEPRDocID
	s objEPRLogs.EPRNum = parEPRNum
	s objEPRLogs.CreateUserID = parUserID
	s objEPRLogs.HappenDate = parHappenDate
	s objEPRLogs.HappenTime = parHappenTime
	s objEPRLogs.CreateDate = parCreateDate
	s objEPRLogs.CreateTime = parCreateTime
	
	s initStatus = " "																		//初始状态	
	s finalStatus = ##class(EPRmeta.EPRActStatusCfg).GetPostStatus(initStatus, parAction)	//最终状态
	q:(finalStatus="") "0"
	d objEPRLogs.ChangeStatus(finalStatus)	
	
	//插入一条EPRinstance.InstanceLog
	s instanceLog = ##class(EPRinstance.InstanceLog).%New()
	q:(instanceLog="") "0"
	
	s instanceLog.Action = parAction
	s instanceLog.OperateDate = parCreateDate
	s instanceLog.OperateTime = parCreateTime
	s instanceLog.OperateMachineIP= parIP
	s instanceLog.InitStatus = finalStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = parUserID

	s status = objEPRLogs.AddLog(instanceLog)
	q:(status '= 1) "0"
	
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"
	
	q objEPRLogs.%Id()
}

/// ******************************************
/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).CorrectListNoDetail("56","24")
ClassMethod CorrectListNoDetail(episodeId As %String, prtDocId As %String) As %String
{
	s errorFlag = "0"
	
	s ecRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", episodeId, "ML"_prtDocId)
	q:(ecRecordID="")
	
	
	s repId = $I(^CacheTemp)
	s listNo = ""
	for {
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo))
		q:(listNo="")
	
		s sub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo, ""))
		if (sub="") 
		{
			s errorFlag = "prepare"
			q	
		}
		
		s instanceId = ecRecordID_"||"_sub
		
		s tmpListNo = $E(listNo, 2, $L(listNo))
		s ^CacheTemp(repId,tmpListNo) = instanceId
	}
	
	if (errorFlag>"0") 
	{
		if repId'="" kill ^CacheTemp(repId)
		q "同步错误：错误代码 = "_errorFlag
	}
	
	s count = 0
	s listNo = ""
	for {
		/*
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo))
		q:(listNo="")
		
		s count = count + 1
		
		s sub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo, ""))
		if (sub="") 
		{
			s errorFlag = "1"
			q	
		}
		s instanceId = ecRecordID_"||"_sub
		*/
		
		s listNo = $O(^CacheTemp(repId,listNo))
		q:(listNo="")
		
		s count = count + 1
		
		s instanceId = $G(^CacheTemp(repId,listNo))
		if instanceId=""
		{
			s errorFlag = "1"
			q	
		}
		
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
		if (objInstance="")
		{
			s errorFlag = "2"
			q
		}
		
		if objInstance.ListNo '= count
		{
			s objInstance.ListNo = count
			if $$$ISERR(objInstance.%Save())
			{
				s errorFlag = "3"
				q
			}
		}	
	}
	
	if repId'="" kill ^CacheTemp(repId)
	
	if errorFlag>"0" q "同步错误：错误代码 = "_errorFlag_"ECRecordID = "_ecRecordID_" ListNo = "_listNo
	
	q "同步成功"
}

/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).CorrectEPRNumDetail("66","37")
ClassMethod CorrectEPRNumDetail(episodeId As %String, prtDocId As %String) As %String
{
	s errorFlag = "0"
	
	s count = 0
	
	s eprNum = 0
	for {
		
		s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_episodeId, " "_prtDocId, eprNum))
		q:(eprNum="")
		
		s count = count + 1
		
		s logId = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_episodeId, " "_prtDocId, eprNum, ""))
		if (logId="") 
		{
			s errorFlag = "1"
			q	
		}
		
		s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(logId)
		if (objEPRLogs="")
		{
			s errorFlag = "2"
			q
		}
		
		if objEPRLogs.EPRNum '= count
		{
			s objEPRLogs.EPRNum = count
			if $$$ISERR(objEPRLogs.%Save())
			{
				s errorFlag = "3"
				q
			}
		}	
	}
	
	if errorFlag>"0" q "同步错误：：错误代码 = "_errorFlag_" PrintDocID = "_prtDocId_" EPRNum = "_eprNum
	
	q "同步成功"
}

/// ************************** 下列方法不启用 *************
/// Debug: w ##class(EPRservice.tool.ConsistencyMgr).CheckListNoDetail("56","24")
ClassMethod CheckListNoDetail(episodeId As %String, prtDocId As %String) As %String
{
	s isOK = "1"
	
	s ecRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", episodeId, "ML"_prtDocId)
	q:(ecRecordID="")
	
	s count = 0
	
	s listNo = 0
	for {
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo))
		q:(listNo="")
		
		s count = count + 1
		
		s sub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID, listNo, ""))
		if (sub="") 
		{
			s isOK = "0"
			q	
		}
		
		s instanceId = ecRecordID_"||"_sub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
		if (objInstance="")
		{
			s isOK = "0"
			q
		}
		
		if objInstance.ListNo '= count
		{
			
			s isOK = "0"
			q
			
		}	
	}
	
	q isOK
}

ClassMethod SyncCount(episodeId As %String, prtDocId As %String)
{
	s instanceCount=0, logCount=0
	
	&sql(select count(*) into :instanceCount from eprinstance.instancedata as a, eprinstance.ecrecord as b
	where b.episodeid=:episodeId and b.chartitemid='ML'||:prtDocId and a.theecrecord=b.id)
	
	&sql(select count(*) into :logCount from eprinstance.eprlogs where episodeid=:episodeId and eprdocid=:prtDocId and EPRNum>0)
	
	s:(instanceCount="") instanceCount=0
	s:(logCount="") logCount=0
	
	if instanceCount < logCount
	{
		do ..DelUnnecessaryEPRNum(episodeId, prtDocId, instanceCount, logCount)
	}	
	elseif instanceCount > logCount
	{
		//需要人工参与
		//删除多余的InstanceData
		//或这
		do ..AddEPRNum(episodeId, prtDocId, instanceCount, logCount)
	}
}

/// Desc: 删除多余的  EPRLogs
ClassMethod DelUnnecessaryEPRNum(episodeId As %String, prtDocId As %String, instanceCount As %Integer, logCount As %Integer)
{
	s count = logCount - instanceCount
	s eprNum = ""
	for i = 1:1:count
	{
		s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_episodeId," "_prtDocId,eprNum),-1)
		q:(eprNum="")
		
		//多余的EPRNum一定大于ECRecord.InstanceCount
		q:(eprNum <= instanceCount)
		
		s rowid = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_episodeId," "_prtDocId,eprNum,""))
		if rowid '= ""
		{
			w "删除EPRLogs, RowId:"_rowid_", EpisodeID:"_episodeId_", prtDocId:"_prtDocId_", EPRNum:"_eprNum	
			&sql(delete from EPRinstance.EPRLogs where ID = :rowid)
		}
	}
	
	q
}

ClassMethod AddEPRNum(episodeId As %String, prtDocId As %String, instanceCount As %Integer, logCount As %Integer)
{
}

}
