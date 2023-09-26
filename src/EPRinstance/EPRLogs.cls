/// ************************************************************
/// *  类名称	: EPRinstance.EPRLogs
/// *  描述 : 存储病历操作日志和状态
/// *  编写者： gaojb
/// *  编写日期	  : 2009-7-22
/// ************************************************************/
Class EPRinstance.EPRLogs Extends %Persistent [ ClassType = persistent, CompileAfter = (EPRmeta.EPRTemplateCategory, EPRmeta.EPRStatus, EPRmeta.EPRAction), ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1);

/// 病历结构ID，即打印模板在病历结构表中的RowID
Property EPRDocID As %String(TRUNCATE = 1);

/// 病历顺序号，对唯一病历，该值始终为1，对可重复病历的可重复模板，该值为相应的ListNo, 对可重复病历的唯一模板，该值为0
Property EPRNum As %Integer;

/// 病历目前最新状态Code(EPRmeta.EPRStatus)
Property EPRStatus As %String(TRUNCATE = 1);

/// 病历操作日志
Property Log As list Of InstanceLog;

/// 病历对应医疗行为发生日期（如是哪天的病程记录，可以修改，内部格式）
Property HappenDate As %String(TRUNCATE = 1);

/// 病历对应医疗行为发生时间(如是哪天的病程记录，可以修改，内部格式)
Property HappenTime As %String(TRUNCATE = 1);

/// 病历创建的实际日期(不可修改，内部格式)
Property CreateDate As %String(TRUNCATE = 1);

/// 病历创建的实际时间(不可修改，内部格式)
Property CreateTime As %String(TRUNCATE = 1);

/// 病历创建者的UserID
Property CreateUserID As %String(TRUNCATE = 1);

Index IdxMain On (EpisodeID, EPRDocID, EPRNum) [ Unique ];

Index IdxForLink On (EpisodeID, HappenDate, HappenTime, EPRDocID) [ Unique ];

Index IdxCreateDateTime On (CreateDate, CreateTime, EpisodeID, EPRDocID, EPRNum);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EpisodeID:%String,EPRDocID:%String,EPRNum:%String,EPRStatus:%String,HappenDate:%String,HappenTime:%String,CreateDate:%String,CreateTime:%String,CreateUserID:%String")
{
		SELECT ID,EpisodeID,EPRDocID,EPRNum, EPRStatus, HappenDate, HappenTime, CreateDate, CreateTime, CreateUserID
		FROM EPRinstance.EPRLogs
		ORDER BY ID
}

Query SelectByEpisodeID(parEpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EPRDocID:%String,EPRNum:%String,EPRStatus:%String,HappenDate:%String,HappenTime:%String,CreateDate:%String,CreateTime:%String,CreateUserID:%String")
{
		SELECT ID,EPRDocID,EPRNum,EPRStatus, HappenDate, HappenTime, CreateDate, CreateTime, CreateUserID
		FROM EPRinstance.EPRLogs
		WHERE EpisodeID = :parEpisodeID
		ORDER BY ID
}

/// Desc: 取某个病人的ID为DocIDd的病历在EPRLogs里面有几个
/// Input: parEpisodeID:就诊rowid
///  	   parEPRDocID：病历结构ID
/// Output: 
/// Return：-1：出错，>-1：病历数
ClassMethod GetEPRDocCount(parEpisodeID As %String, parEPRDocID As %String) As %String
{
	s $zt="errhandle"
	s count=0
	k SQLCODE
	&sql(select max(EPRNum) into :count from EPRinstance.EPRLogs WHERE EpisodeID = :parEpisodeID and EPRDocID=:parEPRDocID)
	q count
errhandle
	q "-1"
}

/// Desc: 取某次就诊、某份病历、某段日期范围内的日志rowid
/// Input: parEpisodeID:就诊rowid，parStartDate：起始日期，parEndDate：结束日期，
///  		   parEPRDocIDs：打印模板在病历结构表中的ID序列，如 23^24^34^40
/// Output: 无
/// Return：EPRLogs的rowid序列，如1^3^4^6
/// Debug: w ##class(EPRinstance.EPRLogs).GetLogIDByDate("297","0","0","61613","0","28")
/// Others: 停用，使用 EPRservice.BOEPRLogs).GetLogIDByDate()
ClassMethod GetLogIDByDate(parEpisodeID As %String, parStartDate As %String, parStartTime As %String, parEndDate As %String, parEndTime As %String, parEPRDocIDs As %String) As %String
{
	;s ^houjtest("EPRLogs") = parEpisodeID_"^"_parStartDate_"^"_parStartTime_"^"_parEndDate_"^"_parEndTime_"^"_parEPRDocIDs
	q:((parEpisodeID="")||(parStartDate="")||(parEndDate="")||(parStartTime="")||(parEndTime="")||(parEPRDocIDs="")) ""
	q:((+parStartDate)>(+parEndDate)) ""
	s retValue = ""
	
	s blankEID = " "_parEpisodeID
	s blankStDate = " "_parStartDate
	s blankEndDate = " "_parEndDate
	s blankStTime = " "_parStartTime
	s blankEndTime = " "_parEndTime
	s eprDocIDList= "^"_parEPRDocIDs_"^"
	
	s date = blankStDate
	while (date '= "") 
	{
		s time = ""
		for {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			s time = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time))
			q:(time="")
			
			if $$CheckDateTime(date,time)="0" continue
			
			s eprDocId=""
			for {
				s eprDocId = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time,eprDocId))
				q:(eprDocId="")
				
				if $find(eprDocIDList,"^"_$E(eprDocId,2,$L(eprDocId))_"^")>0
				{
					s rowid = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time,eprDocId,""))
					s retValue = retValue_"^"_rowid
				}
			}
		}
		
		s date =  $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date))
		q:(date="")
		q:(date>blankEndDate)
	}
	
	if retValue '= ""
	{	s retValue = $E(retValue,2,$L(retValue))}
	
	q retValue
	
CheckDateTime(date, time)
    s tmpTime = $E(time,2,$L(time))
    
	if (blankStDate = blankEndDate)
	{
		//起始日期等于结束日期，时间要满足：起始时间 <= time <= 结束时间	
		if (tmpTime '<  parStartTime)&&(tmpTime '> parEndTime)
		{	q "1"}
	}
	elseif (date = blankStDate)
	{
		//起始日期不等于结束日期且date等于起始日期，时间要满足：time >= 起始时间
		if (tmpTime '< parStartTime) {q "1"}
	}
	elseif (date = blankEndDate)
	{
		//起始日期不等于结束日期且date等于结束日期，时间要满足：time <= 结束时间
		if (tmpTime '> parEndTime) {q "1"}
	}
	else
	{
		//起始日期不等于结束日期且date在起始和结束日期之间，任何时间都满足条件
		q "1"
	}
	
	q "0"
}

/// Desc: 校验发生日期和时间是否合法：EpisodeID + EPRDocID + HappenDate + HappenTime 应该唯一
/// Input: parEpisodeID: 就诊rowid
/// 		parEPRDocID：打印模板在病历结构表中的ID
/// 		parHappendDate: 发生日期
/// 		parHappendTime: 发生时间
/// 		parEPRLogsID: EPRLogs的rowid，未保存过的为空
/// Output：无
/// Return：1：合法			0：非法		-1：非法参数
ClassMethod CheckHappenDateTime(parEpisodeID As %String, parEPRDocID As %String, parHappenDate As %String, parHappenTime As %String, parEPRLogsID As %String) As %String
{
	q:(($d(parEpisodeID)=0)||($d(parEPRDocID)=0)||($d(parHappenDate)=0)||($d(parHappenTime)=0)||($d(parEPRLogsID)=0)) -1
	q:((parEpisodeID="")||(parEPRDocID="")||(parHappenDate="")||(parHappenTime="")) -1
	
	s episodeID = " "_parEpisodeID
	s eprDocID = " "_parEPRDocID
	s happenDate = " "_parHappenDate
	s happenTime = " "_parHappenTime
	
	s rowid = $O(^DHCEPRI.EPRLogsI("IdxForLink",episodeID,happenDate,happenTime,eprDocID,""))
	
	//未发现记录，合法
	q:(rowid="") 1
	
	//发现记录，但记录为其自身，合法
	q:(rowid=parEPRLogsID) 1
	
	//发现其它发生日期时间相同的记录，非法
	q 0
}

/// Desc: 批量更新日志(操作不允许为保存)
/// Input: 	parEpisodeID: 就诊rowid
/// 		parStr： EPRDocID1^EPRNum1#EPRDocID2^EPRNum2#EPRDocID3^EPRNum3
/// 		parAction: 操作
/// 		parIP：操作机器的IP
/// 		parUserID：用户ID
/// Output：无
/// Return：1：更新成功			0：更新失败
/// Debug: w ##class(EPRinstance.EPRLogs).UpdateEPRLogs("49","47","1^2^3","commit","192.168.1.1","10000")
ClassMethod UpdateEPRLogs(parEpisodeID As %String, parAllStr As %String, parAction As %String, parIP As %String, parUserID As %String) As %String
{
	q:(($d(parEpisodeID)=0)||($d(parAllStr)=0)||($d(parAction)=0)||($d(parIP)=0)||($d(parUserID)=0)) "0"
	q:((parEpisodeID="")||(parAllStr="")||(parAction="")||(parIP="")||(parUserID="")) "0"
	q:(parAction="save") "0"
	
	s $zt = "ErrorHandler"
	s flag = "true"
	
	TStart
	
	s count = $L(parAllStr,"#")
	for i = 1:1:count
	{
		s now = $H
		s date = $P(now,",",1)
		s time = $P(now,",",2)
			
		s oneStr = $P(parAllStr,"#",i)
		s eprDocID = $P(oneStr, "^", 1)
		s num = $P(oneStr, "^", 2)
		
		s logId = ..GetLogID(parEpisodeID, eprDocID, num)
		if logId=""
		{
			//未找到相应日志
			s flag = "false"
			q
		}
		else
		{
			if ( ..UpdateEPRLogByID(logId, parAction, parIP, parUserID) = "0" )
			{
				//更新日志失败
				s flag = "false"
				q
			}
		}		
	}	
	
	if (flag = "true")
	{	
		TCommit
		q "1"	
	}
	else
	{	
		TRollback	
		q "0"
	}

ErrorHandler
	TRollback
	q "0"
}

/// Desc: 更新日志(操作不允许为保存)
/// Debug: w ##class(EPRinstance.EPRLogs).UpdateEPRLogByID("53","complete","10.10.141.116","50")
ClassMethod UpdateEPRLogByIDBak(parLogID As %String, parAction As %String, parIP As %String, parUserID As %String) As %String
{
	q:(($d(parLogID)=0)||($d(parAction)="")||($d(parIP)="")||($d(parUserID)=0)) "0"
	q:((parLogID="")||(parAction="")||(parIP="")||(parUserID="")) "0"
	q:(parAction="save") "0"
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(parLogID)
	q:(objEPRLogs="") "0"
	
	//更新操作后的病历状态
	s initStatus = objEPRLogs.EPRStatus														//初始状态	
	s finalStatus = ##class(EPRmeta.EPRActStatusCfg).GetPostStatus(initStatus, parAction)	//最终状态
	q:(finalStatus="") "0"
	
	d objEPRLogs.ChangeStatus(finalStatus)	
	
	//插入一条EPRinstance.InstanceLog
	s instanceLog = ##class(EPRinstance.InstanceLog).%New()
	q:(instanceLog="") "0"
	
	s now = $H
	s date = $P(now,",",1)
	s time = $P(now,",",2)
	s instanceLog.Action = parAction
	s instanceLog.OperateDate = date
	s instanceLog.OperateTime = time
	s instanceLog.OperateMachineIP= parIP
	s instanceLog.InitStatus = initStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = parUserID
		
	s status = objEPRLogs.AddLog(instanceLog)
	q:('$$$ISOK(status)) "0"
	
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"
	
	q "1"
}

/// Desc: 更新日志(操作为保存)
/// return: 1--success, 0--failed
/// Debug: w ##class(EPRinstance.EPRLogs).UpdateEPRLogByID("61","Reference","10.10.141.115","5972","Single","62236","56140",826)
ClassMethod UpdateEPRLogByID(parLogID As %String, parAction As %String, parIP As %String, parUserID As %String, parType As %String = "", parHappenDate As %String = "", parHappenTime As %String = "", parTemplateID As %String = "")
{
	q:(($d(parLogID)=0)||($d(parAction)=0)||($d(parIP)=0)||($d(parUserID)=0)||($d(parType)=0)) "0"
	q:((parLogID="")||(parAction="")||(parIP="")||(parUserID="")) "0"
	q:((parType="Multiple")&&((parHappenDate="")||(parHappenTime=""))) "0"
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(parLogID)
	q:(objEPRLogs="") "0"
	
	//更新操作后的病历状态
	s initStatus = objEPRLogs.EPRStatus														//初始状态	
	s finalStatus = ##class(EPRmeta.EPRActStatusCfg).GetPostStatus(initStatus, parAction)	//最终状态
	q:(finalStatus="") "0"
	
	d objEPRLogs.ChangeStatus(finalStatus)	
	
	//插入一条EPRinstance.InstanceLog
	s instanceLog = ##class(EPRinstance.InstanceLog).%New()
	q:(instanceLog="") "0"
	
	s now = $H
	s date = $P(now,",",1)
	s time = $P(now,",",2)
	s instanceLog.Action = parAction
	s instanceLog.OperateDate = date
	s instanceLog.OperateTime = time
	s instanceLog.OperateMachineIP= parIP
	s instanceLog.InitStatus = initStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = parUserID
	s instanceLog.TemplateID = parTemplateID
		
	s status = objEPRLogs.AddLog(instanceLog)
	q:('$$$ISOK(status)) "0"
	
	if (parType="Multiple")
	{
		s objEPRLogs.HappenDate = parHappenDate
		s objEPRLogs.HappenTime = parHappenTime
	}

	s $ECODE=""
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"
	
	q "1"
}

/// Desc: 创建日志 
/// Input：	parEpisodeID: 就诊rowid
/// 		parEPRDocID：打印模板在病历结构表中的ID
/// 		parAction
/// 		parIP
/// 		parUserID
/// 		parHappenDate
/// 		parHappenTime
/// Output: 无
/// Return：EPRLogs的rowid  或者 0(失败)
/// Debug：##class(EPRinstance.EPRLogs).CreateEPRLog("1","1","save","10.10.141.116","50","1","1")
ClassMethod CreateEPRLog(parEpisodeID As %String, parEPRDocID As %String, parAction As %String, parIP As %String, parUserID As %String, parHappenDate As %String, parHappenTime As %String, parEPRNum As %String, parTemplateID As %String) As %String
{
	q:(($d(parEpisodeID)=0)||($d(parEPRDocID)=0)||($d(parAction)=0)||($d(parIP)=0)||($d(parUserID)=0)) "0"
	q:(($d(parHappenDate)=0)||($d(parHappenTime)=0)) "0"
	q:((parEpisodeID="")||(parEPRDocID="")||(parAction="")||(parIP="")||(parUserID="")) "0"
	q:((parHappenDate="")||(parHappenTime="")) "0"
	q:((parEPRNum="")||(parEPRNum<0)) "0"
		
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%New()
	q:(objEPRLogs="") "0"
	
	s now = $H
	s date = $P(now,",",1)
	s time = $P(now,",",2)
	
	/* modified on 2010-07-05 by houj
	if parEPRNum="0"
	{
		s eprNum = "0"
	}
	else
	{
			s eprNum = ..GetEPRDocCount(parEpisodeID,parEPRDocID)
			if (eprNum = "")
			{	s eprNum = 1}
			else
			{	s eprNum = eprNum + 1}
	}
	*/
	s eprNum = parEPRNum
	
	s objEPRLogs.EpisodeID = parEpisodeID
	s objEPRLogs.EPRDocID = parEPRDocID
	s objEPRLogs.EPRNum = eprNum
	s objEPRLogs.CreateUserID = parUserID
	s objEPRLogs.HappenDate = parHappenDate
	s objEPRLogs.HappenTime = parHappenTime
	s objEPRLogs.CreateDate = date
	s objEPRLogs.CreateTime = time
	
	s initStatus = " "																		//初始状态	
	s finalStatus = ##class(EPRmeta.EPRActStatusCfg).GetPostStatus(initStatus, parAction)	//最终状态
	q:(finalStatus="") "0"
	d objEPRLogs.ChangeStatus(finalStatus)	
	
	//插入一条EPRinstance.InstanceLog
	s instanceLog = ##class(EPRinstance.InstanceLog).%New()
	q:(instanceLog="") "0"
	
	s instanceLog.Action = parAction
	s instanceLog.OperateDate = date
	s instanceLog.OperateTime = time
	s instanceLog.OperateMachineIP= parIP
	s instanceLog.InitStatus = finalStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = parUserID
	s instanceLog.TemplateID = parTemplateID

	s status = objEPRLogs.AddLog(instanceLog)
	q:(status '= 1) "0"
	
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"
	
	q objEPRLogs.%Id()
}

/// Function:    GetEPRStatus
/// Description: 根据EpisodeID、EPRStructID、EPRDateTime和CreateDateTime取得病历当前状态
/// Input:       parEpisodeID, parEPRStructID:打印模板在病历结构表中的ID, HappenDate:病历对应医疗行为发生日期，HappenTime:病历对应医疗行为发生时间, CreateDate：病历创建日期，CreateTime:病历实际创建时间
/// Return:      病历当前状态Code(EPRmeta.EPRStatus)
/// Others:      
ClassMethod GetEPRStatus(parEpisodeID As %String, parEPRStructID As %String, parEPRNum As %String) As %String
{
	s status=""
	&sql(SELECT EPRStatus into :status
		FROM EPRinstance.EPRLogs
		WHERE EpisodeID = :parEpisodeID and EPRDocID=:parEPRStructID and EPRNum=:parEPRNum )
	q status
}

/// Function:    GetLogID
/// Description: 根据EpisodeID、EPRStructID、EPRNum取得病历日志记录的ID
/// Input:       parEpisodeID, parEPRStructID：打印模板在病历结构表中的ID, parEPRNum: EPRNum, 对唯一病历其值为1，对可重复病历，其值为对应实例数据的ListNo
/// Return:      RowID
/// Others:      
ClassMethod GetLogID(parEpisodeID As %String, parEPRStructID As %String, parEPRNum As %String) As %String
{
	s id=""
	&sql(SELECT ID into :id
		FROM EPRinstance.EPRLogs
		WHERE EpisodeID = :parEpisodeID and EPRDocID=:parEPRStructID and EPRNum=:parEPRNum)
	q id
}

/// Function:    GetFirstLogByFinalStatus
/// Description: 实例方法，取出当前日志记录中第一个FinalStatus是argStatus的日志
/// Input:       argStatus: 需要查询的状态
/// Return:      符合条件的日志
/// Others:      
Method GetFirstLogByFinalStatus(argStatus As %String) As InstanceLog
{
	s count=0,log="",result="0"
	s count=##this.Log.Count()
	q:(count=0) ""
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(i)
		if ($zcvt(log.FinalStatus,"U")=$zcvt(argStatus,"U")) {s result="1"}
	}
	
	q:(result="1") log
	q ""
}

/// Function:    GetFirstLogByAction
/// Description: 实例方法，取出当前日志记录中第一个操作是argAction的日志
/// Input:       argAction: 需要查询的操作
/// Return:      符合条件的日志
/// Others:      
Method GetFirstLogByAction(argAction As %String) As InstanceLog
{
	s count=0,log="",result="0"
	s count=##this.Log.Count()
	q:(count=0) ""
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(i)
		if ($zcvt(log.Action,"U")=$zcvt(argAction,"U")) {s result="1"}
	}
	
	q:(result="1") log
	q ""
}

Method GetFirstLogByActionNew(argAction As %String) As InstanceLog
{
	s count=0,log="",result="0",userloc="",userId="",arguserloc=""
	s count=##this.Log.Count()
	s arguserloc=$o(^CTLOC(0,"Code",$Zcvt("病案室","U"),""))
	q:arguserloc="" result
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(i)
		if ($zcvt(log.Action,"U") = $zcvt(argAction,"U"))
		 {   
		     s userId=log.OperateUserID
			 continue:(userId="")
			 s userloc=$P($g(^SSU("SSUSR",userId)),"^",4)
			 continue:(userloc="")
			 if ($zcvt(userloc,"U")=$zcvt(arguserloc,"U")){s result=1}
		 }
	}
	q result
}

/// Function:    AddLog
/// Description: 实例方法，增加一条日志
/// Input:       argLog: 需要增加的日志
/// Return:      是否成功
/// Others:      
Method AddLog(argLog As InstanceLog) As %String
{
	q:($d(argLog)=0)||(argLog="") 0
	q:('$IsObject(argLog)) 0
	q:($p(argLog,"@",2)'="EPRinstance.InstanceLog") 0
	q:(##class(EPRmeta.EPRAction).ActionCodeValid(argLog.Action)=0) 0 //验证日志中操作code的合法性
	q:(##class(EPRmeta.EPRStatus).StatusCodeValid(argLog.InitStatus)=0) 0 //验证日志中状态code的合法性
	q:(##class(EPRmeta.EPRStatus).StatusCodeValid(argLog.FinalStatus)=0) 0 //验证日志中状态code的合法性
	s status=##this.Log.Insert(argLog)
	q status
}

/// Function:    GetFinalLog
/// Description: 实例方法，取得最后一条日志
/// Input:       
/// Return:      日志实例
/// Others:      
Method GetFinalLog() As InstanceLog
{
	s count=0
	s count=##this.Log.Count()
	q:(count=0) ""
	s log=""
	s log=##this.Log.GetAt(count)
	q log
}

/// Function:    ClearLog
/// Description: 实例方法，清除所有日志，日常操作不会用到，仅用于后台维护
/// Input:       
/// Return:      
/// Others:      
Method ClearLog()
{
	d ##this.Log.Clear()
}

/// Function:    ChangeStatus
/// Description: 实例方法，改变病历日志记录的当前状态
/// Input:       状态字符
/// Return:      
/// Others:      
Method ChangeStatus(argStatus As %String)
{
	s ##this.EPRStatus=argStatus
}

/// Function:    GetAllLogs
/// Description: 实例方法，取得当前病历日志记录的所有日志
/// Input:       
/// Return:      日志List
/// Others:      
Method GetAllLogs() As %ListOfObjects
{
	q ##this.Log
}

/// CreateTime: 2009-12-02
/// Creator: gaojb
/// 取得当前病历日志
/// input:
/// argEpisodeID, argDocID, argEPRNum
/// return: 
/// debug: w ##class(EPRinstance.EPRLogs).GetCurrLog(59,45,1)
ClassMethod GetCurrLog(argEpisodeID As %String, argDocID As %String, argEPRNum As %String, argStatus As %String = "") As EPRinstance.InstanceLog
{
	s $zt="errhandle"
  s logid="",log=""
  s logid=..GetLogID(argEpisodeID,argDocID,argEPRNum)
  q:(logid="0") ""
  
  s log=##class(EPRinstance.EPRLogs).%OpenId(logid)
  q:(log="") ""
  q log
  
errhandle
	q ""
}

/// 取日志信息
/// 根据GetCurrStatus方法改写
ClassMethod GetLogStatus(episodeID As %String, printTemplateDocId As %String, eprNum As %String) As %String
{
  	s divStateServer = ""
  	s logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, printTemplateDocId, eprNum)
  	
  	s objPrtDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printTemplateDocId)
  	s chapterDocID = objPrtDoc.ParentCategoryID
  	d objPrtDoc.%Close()
  	k objPrtDoc
  	
  	s objChapterDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(chapterDocID)
  	s categoryNameServer = objChapterDoc.CategoryName
  	d objChapterDoc.%Close()
  	k objChapterDoc
  	  	
  	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(logID)
  	if (eprLogs '= "")
  	{
  		//提取创建者信息
  		s author=""
  		s author=eprLogs.CreateUserID
  		s:(author'="") author=##class(EPRmeta.Privilege.PowerUser).GetUserName(author)
  		
  		s lastInstanceLog = eprLogs.GetFinalLog()
  		
  		//<modified on 2010-08-02 by houj>
  		s userName = lastInstanceLog.OperateUserName
  		
  		s dateServer = $ZD(lastInstanceLog.OperateDate, 3)
  		s timeServer = $ZT(lastInstanceLog.OperateTime, 1)
  		s ip = lastInstanceLog.OperateMachineIP		//add by zhuj on 2010-2-25
  		s action = lastInstanceLog.Action
  		s actionServer = ""
  		&sql(select ActionName into :actionServer from EPRmeta.EPRAction where ActionCode = :action)
  		
  		s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, printTemplateDocId, eprNum)
  		s currStateServer = ""
  		&sql(select StatusName into :currStateServer from EPRmeta.EPRStatus where StatusCode = :currState)
  			
  		//转换回车和换行符 -- added on 2010-01-28
  		s userName = $tr(userName,$c(13),"")
  		s userName = $tr(userName,$c(10),"")
  		s author = $tr(author,$c(13),"")
  		s author = $tr(author,$c(10),"") 
  		
  		s divStateServer =" | "_"创建者:"_author_" | 用户:"_userName_" "_actionServer_" "_dateServer_" "_timeServer_" IP:"_ip_" | 当前状态:"_currStateServer_" | "
  	}
  	else
  	{
	  	s divStateServer =" | "_"当前状态:未完成"_" | "
	}
  	q divStateServer
}

/// Function:    GetAllLogs
/// Description: 取得当前病例状态字串
/// Input:       
/// Return:      当前病例状态
/// Others:    
ClassMethod GetCurrStatus(episodeID As %String, printTemplateDocId As %String, eprNum As %String) As %String
{
  	s divStateServer = ""
  	s logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, printTemplateDocId, eprNum)
  	
  	s objPrtDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printTemplateDocId)
  	s chapterDocID = objPrtDoc.ParentCategoryID
  	d objPrtDoc.%Close()
  	k objPrtDoc
  	
  	s objChapterDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(chapterDocID)
  	s categoryNameServer = objChapterDoc.CategoryName
  	d objChapterDoc.%Close()
  	k objChapterDoc
  	  	
  	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(logID)
  	if (eprLogs '= "")
  	{
  		//提取创建者信息
  		s author=""
  		s author=eprLogs.CreateUserID
  		s:(author'="") author=##class(EPRmeta.Privilege.PowerUser).GetUserName(author)
  		
  		s lastInstanceLog = eprLogs.GetFinalLog()
  		
  		//<modified on 2010-08-02 by houj>
  		s userName = lastInstanceLog.OperateUserName
  		
  		s dateServer = $ZD(lastInstanceLog.OperateDate, 3)
  		s timeServer = $ZT(lastInstanceLog.OperateTime, 1)
  		s ip = lastInstanceLog.OperateMachineIP		//add by zhuj on 2010-2-25
  		s action = lastInstanceLog.Action
  		s actionServer = ""
  		&sql(select ActionName into :actionServer from EPRmeta.EPRAction where ActionCode = :action)
  		
  		s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, printTemplateDocId, eprNum)
  		s currStateServer = ""
  		&sql(select StatusName into :currStateServer from EPRmeta.EPRStatus where StatusCode = :currState)
  			
  		//转换回车和换行符 -- added on 2010-01-28
  		s userName = $tr(userName,$c(13),"")
  		s userName = $tr(userName,$c(10),"")
  		s author = $tr(author,$c(13),"")
  		s author = $tr(author,$c(10),"") 
  		
  		s divStateServer = "<<"_categoryNameServer_"(创建者: "_author_")>>  由用户 "_userName_" 于 "_dateServer_" "_timeServer_" "_actionServer_"         当前状态: "_currStateServer_"      操作IP: "_ip
  	}
  	else
  	{
		 s divStateServer = "<"_categoryNameServer_">  当前状态:未完成"
	}
  	q divStateServer
}

/// CreateTime: 2009-12-01
/// Creator: gaojb
/// 判断病历日志中是否有某状态
/// input:
/// argEpisodeID, argDocID, argEPRNum, argStatus(需要判断的病历状态)
/// return: 0--没有, 1--有
/// debug: w ##class(EPRinstance.EPRLogs).RecHasStatus(59,45,1,"commited")
ClassMethod RecHasStatus(argEpisodeID As %String, argDocID As %String, argEPRNum As %String, argStatus As %String) As %String
{
	s $zt="errhandle"
  s log=""
  s log=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(log="") "0"
  
  q:(log.GetFirstLogByFinalStatus(argStatus)="") "0"
  q "1"
  
errhandle
	q "0"
}

/// CreateTime: 2009-12-01
/// Creator: gaojb
/// 判断病历日志中是否有某操作
/// input:
/// argEpisodeID, argDocID, argEPRNum, argAction(需要判断的病历操作)
/// return: 0--没有, 1--有
/// debug: w ##class(EPRinstance.EPRLogs).RecHasAction(59,45,1,"complete")
ClassMethod RecHasAction(argEpisodeID As %String, argDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s $zt="errhandle"
  s log=""
  s log=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(log="") "0"

  q:(log.GetFirstLogByAction(argAction)="") "0"
  q "1"
  
errhandle
	q "0"
}

/// CreateTime: 2013-06-21
/// Creator: mengsx
/// 判断病历日志中是否有某科室医生执行某操作
/// input:argEpisodeID,就诊号;argDocID,病历展现结构模板ID,argEPRNumarg可重复模板的列表顺序号（唯一模板1）;Action,用户执行的操作
/// argEpisodeID, argDocID, argEPRNum, argAction，a(需要判断的病历操作)
/// return: 0--没有, 1--有                                 
/// debug: w ##class(EPRinstance.EPRLogs).RecHasActionNew(67,659,1,"complete")
ClassMethod RecHasActionNew(argEpisodeID As %String, argDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
  s $zt="errhandle"
  s log=""
  s log=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(log="") "0"
  q log.GetFirstLogByActionNew(argAction)
  
  
errhandle
	q "0"
}

/// get author of a record
/// 取得病历作者
/// return value: 病历作者的SSUser.SSUSR_RowId, 错误或者无作者返回空串
/// debug: w ##class(EPRinstance.EPRLogs).GetRecAuthor(59,45,1)
ClassMethod GetRecAuthor(argEpisodeID As %String, argDocID As %String, argEPRNum As %String) As %String
{
	s $zt="errhandle"
  s logs=""
  s logs=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(logs="") ""
  
  s log=logs.GetFirstLogByAction("save")
  q:(log'="") log.RealOperateUserID
  
  s log=logs.GetFirstLogByAction("complete")
  q:(log'="") log.RealOperateUserID
  
	q ""
  
errhandle
	q ""
}

/// CreateTime: 2009-09-14
/// Creator: Gaojb
/// Desc: 保存/更新模板时生成唯一模板的日志并取得操作后病历状态，用于dll的保存/更新模板后日志操作
/// Input: parAction: 操作，目前是save和refresh(更新界面模板）
///        parEpisodeID: 就诊ID
/// 		   parEprDocID: 打印模板Doc ID
/// 		   parEprNum: 病历序号
/// 		   parTemplateDocID: 界面模板Doc ID
///        parHappenDate: 发生日期
///        parHappenTime: 发生时间
///        parAction: 操作
///        parIP: 操作IP
///        parUserID: 用户ID
/// Output: success^<出院记录> 由用户 ys001 于 2009-09-14 21:31:49 完成 当前状态: 已提交^55^finished
/// Debug:	w ##class(EPRinstance.EPRLogs).InitAfterSingleOper("Reference",201764,"21",1,"68","2011-05-25","15:35:40","10.10.141.115",5972)
ClassMethod InitAfterSingleOper(parAction As %String, parEpisodeID As %String, parEprDocID As %String, parEprNum As %String, parTemplateDocID As %String, parHappenDate As %String, parHappenTime As %String, parIP As %String, parUserID As %String, parTemplateID As %String) As %String
{
	s $zt="errhandle"
	
	/*
	s printType = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPrtDocType(parEprDocID)
	if (printType="")||(printType="Multiple")
	{
		//挂载在科研病历或可重复打印病历下
		s parEprNum = "0"
	}
	else
	{
		//挂载在唯一打印病历下
		s parEprNum = "1"
	}
	*/
	//b "s"
	s printType = ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateType(parEprDocID)
	s parEprNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(parEprDocID)
	
	
	if ($zcvt(parAction,"l")="save") {
		if (printType="Multiple")
		{
			s action = "complete"
		}
		else
		{
			set actionType = ##class(EPRmeta.EPRAction).GetSaveType(parEpisodeID, parEprDocID)
			set:(actionType = 1) action = "complete"
			set:(actionType = 0) action = "save"
		}
	}
	elseif ($zcvt(parAction,"l")="reference")
	{
		if (printType="Multiple")
		{
			s action = "refcomplete"
		}
		else
		{
			set actionType = ##class(EPRmeta.EPRAction).GetSaveType(parEpisodeID, parEprDocID)
			set:(actionType = 1) action = "refcomplete"
			set:(actionType = 0) action = "reference"
		}	
	}
	elseif (parAction="refreshNecessary")||(parAction="refreshUnnecessary")
	{
		if (printType="Multiple")
		{
			s action = "refreshNecessary"
		}
		else
		{
			set actionType = ##class(EPRmeta.EPRAction).GetSaveType(parEpisodeID, parEprDocID)
			//set:(actionType = "-1") action = "refreshAll"
			s action = $s((actionType = "-1"):"refreshAll",1:parAction)
		}	
	}
	else {s action=parAction}
	
	set parHappenDate=$zdh(parHappenDate,3)
	set parHappenTime=$zth(parHappenTime,3)

	set type = "Single"
	set logID =..GetLogID(parEpisodeID, parEprDocID, parEprNum)
	
	if (logID = "")		//若为保存第一个界面模板
	{
		set logID = ..CreateEPRLog(parEpisodeID,parEprDocID,action,parIP,parUserID,parHappenDate,parHappenTime,parEprNum,parTemplateID)
		q:(logID = "0") "Error"
	}
	else
	{
		s status = ..UpdateEPRLogByID(logID,action,parIP,parUserID,type,"","",parTemplateID)
		q:(status = "0") "Error"
	}
	
	s currState = ..GetEPRStatus(parEpisodeID, parEprDocID, parEprNum)
	
	//s divStateServer =..GetCurrStatus(parEpisodeID, parEprDocID, parEprNum)
	s divStateServer =..GetLogStatus(parEpisodeID, parEprDocID, parEprNum)
	 
	;s ^gjbtest("ddddd")="success^"_divStateServer_"^"_logID_"^"_currState
    s signLog=##Class(EPRservice.BLDigitalSignature).GetSignLog(parEpisodeID, parEprDocID, parEprNum)
	if (signLog'="") {s divStateServer = divStateServer_signLog }
	q "success^"_divStateServer_"^"_logID_"^"_currState
errhandle
	q "Error"
}

/// CreateTime: 2009-09-14
/// Creator: Gaojb
/// Desc: 保存时生成历次模板的日志并取得操作后病历状态，用于dll的保存后日志操作
/// Input: parAction: 操作，目前是save和refresh(更新界面模板）
///        parEpisodeID: 就诊ID
/// 		   parEprDocID：打印模板Doc ID
/// 		   parEprNum:病历序号
///        parHappenDate:发生日期
///        parHappenTime:发生时间
///        parIP:操作IP
///        parUserID:用户ID
/// Output: success^38^3^<出院记录> 由用户 ys001 于 2009-09-14 21:31:49 完成 当前状态: 已提交
/// Debug:
/// 
/// UpdateTime: 2010-07-05
/// UpdateUser: houj
/// Desc: 	
ClassMethod InitAfterMultiOper(parAction As %String, parEpisodeID As %String, parEprDocID As %String, parEprNum As %String, parIP As %String, parHappenDate As %String, parHappenTime As %String, parUserID As %String, parTemplateID As %String) As %String
{
	q:(parEprNum = "-1") "Error"
	
	s $zt="errhandle"
	//s ^gjbtest("eprlogs")=parAction_"^"_parEpisodeID_"^"_parEprDocID_"^"_parEprNum_"^"_parIP_"^"_parHappenDate_"^"_parHappenTime_"^"_parUserID
	
	///如果通过了质控检查，保存操作即为完成操作，否则仍为保存
	///gaojb 2009-12-15
	if ($zcvt(parAction,"l")="save") {
		s action = "complete"
	}
	elseif ($zcvt(parAction,"l")="reference")
	{
		s action = "refcomplete"	
	}
	elseif (parAction="refreshNecessary")||(parAction="refreshUnnecessary")
	{
	    s action = "refreshAll"
	}
	else {s action=parAction}
	set type = "Multiple"
	set logID = ""
	set parHappenDate=$zdh(parHappenDate,3)
	set parHappenTime=$zth(parHappenTime,3)
	
	/* modified on 2010-07-05 by houj
	if (parEprNum = "-1")
	{
		set logID = ..CreateEPRLog(parEpisodeID,parEprDocID,action,parIP,parUserID,parHappenDate,parHappenTime)
		q:(logID = "0") "Error"
	}
	else
	{
		set logID = ..GetLogID(parEpisodeID, parEprDocID, parEprNum)
		s status = ..UpdateEPRLogByID(logID,action,parIP,parUserID,type,parHappenDate,parHappenTime)
		q:(status = "0") "Error"
	}
	*/
	set logID = ..GetLogID(parEpisodeID, parEprDocID, parEprNum)
	if (logID = "")
	{
		set logID = ..CreateEPRLog(parEpisodeID,parEprDocID,action,parIP,parUserID,parHappenDate,parHappenTime,parEprNum,parTemplateID)
		q:(logID = "0") "Error"
	}
	else
	{
		s status = ..UpdateEPRLogByID(logID,action,parIP,parUserID,type,parHappenDate,parHappenTime,parTemplateID)
		q:(status = "0") "Error"
	}
	
	s eprLogs = ..%OpenId(logID)
	s eprNum = eprLogs.EPRNum
	s finalStatus=eprLogs.EPRStatus //gaojb 2009-12-21 quality control when commit
	d eprLogs.%Close()	
	//s divStateServer = ..GetCurrStatus(parEpisodeID, parEprDocID, eprNum)
	s divStateServer = ..GetLogStatus(parEpisodeID, parEprDocID, eprNum)
    s signLog=##Class(EPRservice.BLDigitalSignature).GetSignLog(parEpisodeID, parEprDocID, eprNum)
	if (signLog'="") {s divStateServer = divStateServer_signLog }	
	q "success^"_logID_"^"_eprNum_"^"_divStateServer_"^"_finalStatus
errhandle
	q "Error"
}

/// CreateTime: 2010-1-22
/// Creator: Gaojb
/// Desc: 核对指定EpisodeID、DocID和TemplateID的《唯一》界面模板的数据和日志是否一致，仅限于新框架
/// Input: parEpisodeID: 就诊ID
/// 		   parEprDocID: 打印模板DocID
/// 		   parEPRTemplateID: 界面模板在病历结构中的ID
/// Output: 1－一致，0－不一致
/// Debug:	w ##Class(EPRinstance.EPRLogs).CheckSingleLogs(58,3,2)
ClassMethod CheckSingleLogs(parEpisodeID As %String, parEprDocID As %String, parEPRTemplateID As %String) As %String
{
	s $zt="errhandle"
	;b "s"
	q:(($d(parEpisodeID)=0)||(parEpisodeID="")||($d(parEprDocID)=0)||(parEprDocID="")||($d(parEPRTemplateID)=0)||(parEPRTemplateID="")) 0
	
	///查询日志ID
	k SQLCODE
	s logID=""
	&sql(select ID into :logID from EPRinstance.EPRLogs where EpisodeID=:parEpisodeID and EPRDocID=:parEprDocID and EPRNum=1)
	
	///取得界面模板ID
	s eprTemplate="", templateID=""
	s eprTemplate=##class(EPRmeta.EPRTemplate).%OpenId(parEPRTemplateID)
	q:(eprTemplate="") 0
	s templateID=eprTemplate.BindTemplateID
	q:(templateID="") 0
	s eprTemplate=""
	
	///取得实例数据数量
	s ECRecordCount=0, ECRecordID=""
	&sql(select count(*) into :ECRecordCount from EPRinstance.ECRecord where episodeid=:parEpisodeID and chartitemid='CG'||:templateID)
	q:(ECRecordCount'=1) 0 //ECRecord数量不对返回0, 即使是新建的唯一界面模板也有ECRecord
	
	&sql(select ID into :ECRecordID from EPRinstance.ECRecord where episodeid=:parEpisodeID and chartitemid='CG'||:templateID)
	q:(ECRecordID="") 0
	
	s instanceCount=0
	&sql(select count(*) into :instanceCount from EPRinstance.InstanceData where TheECRecord=:ECRecordID and ListNo=1 and CreateDate is not NULL)
	
	///没有日志就应该没有保存过的实例数据
	q:((logID="")&&(instanceCount=0)) 1
	///有日志就应该有保存过的实例数据
	q:((logID'="")&&(instanceCount=1)) 1
	
	q 0
	
errhandle
	q 0
}

/// CreateTime: 2009-12-24
/// Creator: Gaojb
/// Desc: 核对指定EpisodeID和ChartItemID的《可重复》病历的数据条数和日志条数是否相同，仅限于新框架
/// Input: parEpisodeID: 就诊ID
/// 		   parEprDocID：打印模板DocID, "ML"+DocID=ChartItemID
/// Output: 1－一致，0－不一致
/// Debug:	w ##Class(EPRinstance.EPRLogs).CheckMultiLogsCount(90,24)
ClassMethod CheckMultiLogsCount(parEpisodeID As %String, parEprDocID As %String) As %String
{
	s $zt="errhandle"
	
	q:(($d(parEpisodeID)=0)||(parEpisodeID="")||($d(parEprDocID)=0)||(parEprDocID="")) 0
	
	k SQLCODE
	s instanceCount=0, logCount=0
	
	&sql(select count(*) into :instanceCount from eprinstance.instancedata as a, eprinstance.ecrecord as b
	where b.episodeid=:parEpisodeID and b.chartitemid='ML'||:parEprDocID and a.theecrecord=b.id)
	
	&sql(select count(*) into :logCount from eprinstance.eprlogs where episodeid=:parEpisodeID and eprdocid=:parEprDocID and EPRNum>0)
	
	k SQLCODE

	q (instanceCount=logCount)

errhandle
	q 0
}

/// CreateTime: 2010-1-22
/// Creator: Gaojb
/// Desc: 核对指定EpisodeID、DocID的《可重复》界面模板的数据和日志是否一致，仅限于新框架
///       只核对InstanceData下所有的实例数据都有相应的日志，前提是两者的总数相等
/// Input: parEpisodeID: 就诊ID
/// 		   parEprDocID: 打印模板DocID
/// Output: 1－一致，0－不一致
/// Debug:	w ##Class(EPRinstance.EPRLogs).CheckMultiLogs(49,24)
ClassMethod CheckMultiLogs(parEpisodeID As %String, parEprDocID As %String) As %String
{
	s $zt="errhandle"
	;b "s"
	q:(($d(parEpisodeID)=0)||(parEpisodeID="")||($d(parEprDocID)=0)||(parEprDocID="")) 0
	
	k SQLCODE
	s listNo="", pass=1
	
	///循环所有的instancedata
	&sql(declare c CURSOR FOR select a.ListNo into :listNo from eprinstance.instancedata as a, eprinstance.ecrecord as b
	where b.episodeid=:parEpisodeID and b.chartitemid='ML'||:parEprDocID and a.theecrecord=b.id)
	
	&sql(OPEN c)
	&sql(FETCH c)
	
	///每条instancedata查询是否有对应的log
	While (SQLCODE = 0) {
		q:(pass=0)
    s logCount=0
    &sql(select count(*) into :logCount from eprinstance.eprlogs where EpisodeID=:parEpisodeID and EPRDocID=:parEprDocID and EPRNum=:listNo)
    s:(logCount'=1) pass=0
    k SQLCODE
    &sql(FETCH c)
  }
    
  &sql(CLOSE c)

	q pass
 
errhandle
	q 0
}

/// Desc: 获取病历创建者ID
/// CreateUser：houj
/// CreateDate: 2010-07-01
ClassMethod GetCreateUserID(argEpisodeID As %String, argDocID As %String, argEPRNum As %String) As %String
{
  	s logs=""
  	s logs=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  	q:(logs="") ""
  	q logs.CreateUserID
}

/// Desc: 获取首页状态
/// w ##Class(EPRinstance.EPRLogs).GetStatus("201869")
/// insert into EPRmeta.CustomDictionary values("病案首页","fpDocId","","病案首页打印模板在病历结构表中的ID","","34","病案首页打印模板","","","","Y","PrintDocType")
ClassMethod GetStatus(argEpisodeID As %String) As %String
{
	q:""=argEpisodeID ""
	//Index IdxMain On (EpisodeID, EPRDocID, EPRNum) [ Unique ];
	s EPRDocID=##Class(EPRmeta.CustomDictionary).GetCtmDictLinkByCode("fpDocId")   
    q:""=EPRDocID ""
	s id=""
	s id=$O(^DHCEPRI.EPRLogsI("IdxMain", " "_argEpisodeID, " "_EPRDocID, 1, id))
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(id)
	q:(objEPRLogs="") ""
	q objEPRLogs.EPRStatus
}

/// get commit of a record  2013-9-24 zengweishan
/// 取得病历提交者
/// return value: 病历提交者的SSUser.SSUSR_RowId, 错误或者无作者返回空串
/// debug: w ##class(EPRinstance.EPRLogs)GetCommit(59,45,1)
ClassMethod GetFirstCommitUserID(argEpisodeID As %String, argDocID As %String, argEPRNum As %String) As %String
{
	s $zt="errhandle"
  	s logs=""
  	s logs=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  	q:(logs="") ""
  
  	s log=logs.GetFirstLogByAction("commit")
  	q:(log'="") log.RealOperateUserID
  
	q ""
  
errhandle
	q ""
}

/// get commit of a record  2013-9-24 zengweishan
/// 取得病历提交者
/// return value: 病历提交者的SSUser.SSUSR_RowId, 错误或者无作者返回空串
/// debug: w ##class(EPRinstance.EPRLogs)GetFirstCommitUserID(59,45,1)
ClassMethod GetLastCommitUserID(argEpisodeID As %String, argDocID As %String, argEPRNum As %String) As %String
{
	s $zt="errhandle"
  s logs=""
  s logs=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(logs="") ""
  
  s log=logs.GetLastLogByAction("commit")
  q:(log'="") log.RealOperateUserID
  
  
	q ""
  
errhandle
	q ""
}

/// get attendingCheck of a record  2013-9-27 zengweishan
/// 取得病历主治审核者
/// return value: 病历主治审核者的SSUser.SSUSR_RowId, 错误或者无作者返回空串
/// debug: w ##class(EPRinstance.EPRLogs)GetFirstAttendingCheckUserID(59,45,1)
ClassMethod GetLastAttendingCheckUserID(argEpisodeID As %String, argDocID As %String, argEPRNum As %String) As %String
{
	s $zt="errhandle"
  s logs=""
  s logs=..GetCurrLog(argEpisodeID,argDocID,argEPRNum)
  q:(logs="") ""
  
  s log=logs.GetLastLogByAction("attendingCheck")
  q:(log'="") log.RealOperateUserID
  
  
	q ""
  
errhandle
	q ""
}

/// Function:    GetFirstLogByAction
/// Description: 实例方法，取出当前日志记录中最后一个操作是argAction的日志
/// Input:       argAction: 需要查询的操作
/// Return:      符合条件的日志
/// Others:      
Method GetLastLogByAction(argAction As %String) As InstanceLog
{
	s count=0,log="",result="0"
	s count=##this.Log.Count()
	q:(count=0) ""
	for i=1:1:count {
		q:(result="1")
		s log=##this.Log.GetAt(count-i+1)
		if ($zcvt(log.Action,"U")=$zcvt(argAction,"U")) {s result="1"}
	}
	
	q:(result="1") log
	q ""
}

Storage Default
{
<Data name="EPRLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRStatus</Value>
</Value>
<Value name="3">
<Value>EPRStructID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>Log</Value>
</Value>
<Value name="6">
<Value>EPRMultiNum</Value>
</Value>
<Value name="7">
<Value>EPRRecordID</Value>
</Value>
<Value name="8">
<Value>EPRNum</Value>
</Value>
<Value name="9">
<Value>EPRDocID</Value>
</Value>
<Value name="10">
<Value>CreateDateTime</Value>
</Value>
<Value name="11">
<Value>CreateUserID</Value>
</Value>
<Value name="12">
<Value>EPRDateTime</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateTime</Value>
</Value>
<Value name="15">
<Value>HappenDate</Value>
</Value>
<Value name="16">
<Value>HappenTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPRLogsD</DataLocation>
<DefaultData>EPRLogsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EPRLogsD</IdLocation>
<IndexLocation>^DHCEPRI.EPRLogsI</IndexLocation>
<StreamLocation>^DHCEPRI.EPRLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
