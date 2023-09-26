/// 名称: DHCMA.Util.Task.SyncEpisQueue
/// 描述: HIS接口服务 就诊信息
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.Task.SyncEpisQueue Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  创建就诊队列（出院Disch）
/// Table：       DHCMA.Util.EP.EpisQueue
/// Input：		  aSYSCode ：DHCMA.Util.BT.SYSTEM.Code
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateDischQueue("","NewTestCodeDic","2019-06-01","2019-09-26")
ClassMethod CreateDischQueue(aSYSCode As %String, aQueueType As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSYSCode,aQueueType,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="CreateDischQueueErr"
	
	Set:aQueueType="" aQueueType="Disch"
	
	Set:aSYSCode="" aSYSCode="HIS01"
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSYSCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=$p(Date,"-",3)
	Set NUM=$i(^DHCMA.Util.Task.SyncEpisQueue(YY_"-"_MM,DD))
	Set ^DHCMA.Util.Task.SyncEpisQueue(YY_"-"_MM,DD,NUM,"命令")="AutoTask("_aDateFrom_","_aDateTo_")"
	Set ^DHCMA.Util.Task.SyncEpisQueue(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	If SYSExCode="localhost" {
		//直接调用本地库类方法
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^PAADMi(DischDateIndex,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xEpisodeID=0
			For {
				Set xEpisodeID=$o(^PAADMi(DischDateIndex,xDate,xEpisodeID))
				Quit:xEpisodeID=""
				
				//只同步南山医院病人
				Set LocID=$p($g(^PAADM(xEpisodeID)),"^",4)
				//Continue:$p($g(^CTLOC(LocID)),"^",22)'=3		//南山医院HIS系统医院ID为3
				
				Set AdmType=$p(^PAADM(xEpisodeID),"^",2)
				Continue:AdmType'="I"
				
				// InputStr    : Type_"^"_EpisID_"!!"_SYSDr_"^"_EpisInfo
				// ---Type     ：队列类型（自定义、默认:在院Admit,出院Disch,提交病历Emr,编目完成Coding,门急诊OPEP）
				// ---EpisID   ：PA_Adm.ID
				// ---SYSDr    ：DHCMA.Util.BT.SYSTEM.ID
				// ---EpisInfo : 无
				Set InputStr=aQueueType_"^"_xEpisodeID_"!!"_SYSDr
				Set flg=##class(DHCMA.Util.EP.EpisQueue).CreateTask(InputStr)
				Continue:(+flg)<1
				Set Count=Count+1
			}
		}
	} Else {
		//调用Webservice接口
	}
	//记录执行任务日志（成功标记）
	Set ^DHCMA.Util.Task.SyncEpisQueue(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Set return=Count
	Quit return
	
CreateDischQueueErr
	Set return=-999_"^"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  创建就诊队列（在院Admit）
/// Table：       DHCMA.Util.EP.EpisQueue
/// Input：		  aSYSCode ：DHCMA.Util.BT.SYSTEM.Code
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateAdmitQueue("HIS01")
ClassMethod CreateAdmitQueue(aSYSCode As %String, aQueueType As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aSYSCode,aQueueType,aDateFrom,aDateTo)
	Set return=0,Count=0
	;Quit:(aSYSCode="") return
	
	Set $ZT="CreateAdmitQueueErr"
	
	Set:aQueueType="" aQueueType="Admit"
	
	Set:aSYSCode="" aSYSCode="HIS01"
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSYSCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	If SYSExCode="localhost" {
		//直接调用本地库类方法
		Set xWardID=""
		For {
			Set xWardID=$o(^PAADMi("CurrWard",xWardID))
			Quit:xWardID=""
			
			Set xRoomID=""
			For {
				Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
				Quit:xRoomID=""
				
				Set xEpisodeID=""
				For {
					Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
					Quit:xEpisodeID=""
					
					//只同步南山医院病人
					Set LocID=$p($g(^PAADM(xEpisodeID)),"^",4)
					//Continue:$p($g(^CTLOC(LocID)),"^",22)'=3		//南山医院HIS系统医院ID为3
					
					Set AdmType=$p(^PAADM(xEpisodeID),"^",2)
					Continue:AdmType'="I"
					
					// InputStr    : Type_"^"_EpisID_"!!"_SYSDr_"^"_EpisInfo
					// ---Type     ：（自定义、默认:在院Admit,出院Disch,提交病历Emr,编目完成Coding,门急诊OPEP）
					// ---EpisID   ：PA_Adm.ID
					// ---SYSDr    ：DHCMA.Util.BT.SYSTEM.ID
					// ---EpisInfo : 无
					Set InputStr=aQueueType_"^"_xEpisodeID_"!!"_SYSDr
					Set flg=##class(DHCMA.Util.EP.EpisQueue).CreateTask(InputStr)
					Continue:(+flg)<1
					Set Count=Count+1
				}
			}
		}
	} Else {
		//调用Webservice接口
	}
	Set return=Count
	Quit return
	
CreateAdmitQueueErr
	Set return=-999_"^"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  创建就诊队列（提交病历Emr）
/// Table：       DHCMA.Util.EP.EpisQueue
/// Input：		  aSYSCode ：DHCMA.Util.BT.SYSTEM.Code
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateEmrQueue("HIS01")
ClassMethod CreateEmrQueue(aSYSCode As %String, aQueueType As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aSYSCode,aQueueType,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aSYSCode="") return
	
	Set $ZT="CreateEmrQueueErr"
	
	Set:aQueueType="" aQueueType="Emr"
	
	Set:aSYSCode="" aSYSCode="HIS01"
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSYSCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	If SYSExCode="localhost" {
		//直接调用本地库类方法
		For {
			//获取待执行队列
			Set xTaskExecInfo=##class(DHCMA.Util.IO.FromEmrSrv).FetchTask()
			Quit:xTaskExecInfo=""
			
			Set TaskExecID    = $p(xTaskExecInfo,"^",1)  //执行队列ID
			Set EpisodeID     = $p(xTaskExecInfo,"^",2)  //就诊号
			Set CandidateDate = $p(xTaskExecInfo,"^",3)  //申请日期
			Set CandidateTime = $p(xTaskExecInfo,"^",4)  //申请时间
			
			//只同步南山医院病人
			Set LocID=$p($g(^PAADM(EpisodeID)),"^",4)
			//Continue:$p($g(^CTLOC(LocID)),"^",22)'=3		//南山医院HIS系统医院ID为3
			
			Set AdmType=$p(^PAADM(EpisodeID),"^",2)
			Continue:AdmType'="I"
			
			//同步出院（预出院）病历记录
			// InputStr    : Type_"^"_EpisID_"!!"_SYSDr_"^"_EpisInfo
			// ---Type     ：队列类型（自定义、默认:在院Admit,出院Disch,提交病历Emr,编目完成Coding,门急诊OPEP）
			// ---EpisID   ：PA_Adm.ID
			// ---SYSDr    ：DHCMA.Util.BT.SYSTEM.ID
			// ---EpisInfo : CandidateDate_"|"_CandidateTime
			Set InputStr=aQueueType_"^"_xEpisodeID_"!!"_SYSDr_"^"_CandidateDate_"!!"_CandidateTime
			Set flg=##class(DHCMA.Util.EP.EpisQueue).CreateTask(InputStr)
			Continue:(+flg)<1
			Set Count=Count+1
			
			//处理执行队列->完成队列
			Set flg=##Class(DHCMA.Util.IO.FromEmrSrv).CompleteTask(TaskExecID)
		}
	} Else {
		//调用Webservice接口
	}
	Set return=Count
	Quit return
	
CreateEmrQueueErr
	Set return=-999_"^"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  创建门急诊就诊队列（门急诊OPEP）
/// Table：       DHCMA.Util.EP.EpisQueue
/// Input：		  aSYSCode ：DHCMA.Util.BT.SYSTEM.Code
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCMA.Util.Task.SyncEpisQueue).CreateOPEPQueue("HIS01","","2015-01-01","2018-08-01")
ClassMethod CreateOPEPQueue(aSYSCode As %String, aQueueType As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSYSCode,aQueueType,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="CreateOPEPQueueErr"
	
	Set:aQueueType="" aQueueType="OPEP"
	
	Set:aSYSCode="" aSYSCode="HIS01"
	Set objSYS=##class(DHCMA.Util.BT.SYSTEM).GetObjByCode(aSYSCode)
	Quit:'$IsObject(objSYS) return
	Set SYSDr=objSYS.%Id()
	Set SYSExCode=objSYS.SYSExCode
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	If SYSExCode="localhost" {
		//直接调用本地库类方法
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^PAADMi("PAADM_AdmDate",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xEpisodeID=0
			For {
				Set xEpisodeID=$o(^PAADMi("PAADM_AdmDate",xDate,xEpisodeID))
				Quit:xEpisodeID=""
				
				//只同步南山医院病人
				Set LocID=$p($g(^PAADM(xEpisodeID)),"^",4)
				//Continue:$p($g(^CTLOC(LocID)),"^",22)'=3		//南山医院HIS系统医院ID为3
				
				Set AdmType=$p(^PAADM(xEpisodeID),"^",2)
				Continue:(AdmType'="O")&&(AdmType'="E")
				
				// InputStr    : Type_"^"_EpisID_"!!"_SYSDr_"^"_EpisInfo
				// ---Type     ：队列类型（自定义、默认:在院Admit,出院Disch,提交病历Emr,编目完成Coding,门急诊OPEP）
				// ---EpisID   ：PA_Adm.ID
				// ---SYSDr    ：DHCMA.Util.BT.SYSTEM.ID
				// ---EpisInfo : 无
				Set InputStr=aQueueType_"^"_xEpisodeID_"!!"_SYSDr
				Set flg=##class(DHCMA.Util.EP.EpisQueue).CreateTask(InputStr)
				Continue:(+flg)<1
				Set Count=Count+1
			}
		}
	} Else {
		//调用Webservice接口
	}
	Set return=Count
	Quit return
	
CreateOPEPQueueErr
	Set return=-999_"^"_$ZError
	Quit return
}

}
