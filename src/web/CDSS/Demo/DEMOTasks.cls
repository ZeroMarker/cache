/// 名称:     web.CDSS.Demo.DEMOTasks.cls
/// 描述:     疑似诊断评测工具-目录界面
/// 编写者：  杨继鸿
/// 编写日期: 2021-10-29
Class web.CDSS.Demo.DEMOTasks Extends %RegisteredObject
{

/// Creator：      杨继鸿
/// CreatDate：    2021-11-04
/// Description:   保存病历任务集表、调用保存病历任务集详情表的入口
/// Table：        WDT_CDSS.DEMOTasks
/// Input：        web.CDSSEntity.Demo.DEMOTasks
/// Output：       json串：success 成功标志，taskid 新建的任务集ID，detailinfo 调用保存任务集详情的返回信息，errorinfo 错误信息
/// Return：       成功返回{success:1,taskid:id,detailinfo:{}}；失败返回{success:0,taskid:id,detailinfo:{},[errorinfo:""]}
/// Others：       d ##class(web.CDSS.Demo.DEMOTasks).SaveData()
/// 
/// UpdateDate:    2021-12-03
/// 新增数据时由SaveData控制SaveTasksDetail
/// UpdateDate:    2021-12-24
/// 添加书写错误日志代码
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.DEMOTasks) As %String
{
    s ^TMP("HYL",1)=$now()
    s $zt="SaveTasksERROE"
    s result={}
    s user=$g(%session.Data("LOGON.USERNAME"))
	;s user="yjh"
	s flag=0
    if $IsObject(eobj)
    {   
    	if (eobj.ID="")	//ID未赋值，新增数据
    	{	    	
        	s obj=##class(WDT.CDSS.DEMOTasks).%New()
        	s obj.InitialHitRate=eobj.HitRate	//初始命中率
        	
	        s obj.TaskName=eobj.TaskName	//任务名称
			s obj.TaskTarget=eobj.TaskTarget	//任务目的
			s obj.DocumentType=eobj.DocumentType	//文书类型（ALL/入院记录）
			s obj.CreateUser=user	//创建人员
			s obj.CreateTime=$ZDATETIME($H,3)	//创建时间
			s ^TMP("HYL",2)=$now()
    	}
    	else	//修改数据
    	{
	    	s obj=##class(WDT.CDSS.DEMOTasks).%OpenId(eobj.ID)	  
	    	s ^TMP("HYL",3)=$now()  	
    	}
    	
    	TS
		s obj.HitRate=eobj.HitRate	//最新命中率
		
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            s id = obj.%Id()
			
			// 再保存任务集详情
			s jsonStr=..SaveTasksDetail("", eobj.PatientIDs, id, user)
			s result.detailinfo=jsonStr
			s json={}.%FromJSON(jsonStr)
			s ^TMP("HYL",4)=$now()
			// 保存任务集详情失败，回滚保存任务集事务
			if ('json.success)
			{
				s flag=1
            	s result.errorinfo="保存任务集失败，原因如下：<br>"_json.errorinfo  //返回错误信息
			}
			else
			{
				//并保存命中率记录
				s saveHitRateRecord=##class(web.CDSS.Demo.DEMOTasksHitRate).SaveData(id, eobj.HitRate)
				s saveResult={}.%FromJSON(saveHitRateRecord)
				if 'saveResult.success
				{
					s flag=1
					d result.%Set("errorinfo","保存任务集失败，原因如下：<br>"_saveResult.errorinfo)
				}
				else
				{
					s result.taskid = id  //新建的任务集ID
	            	s result.detailIds=json.ids	//新建的任务集详情IDs串
				}
	            
			}
        }
        else
        {
	        s flag=1
            s result.errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集表","web.CDSS.Demo.DEMOTasks","SaveData",eobj)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
        if (flag=1)
        {
	        // 保存失败
	        TRO
	        s result.success=0
        }
        else
        {
	        // 保存成功
	        TC
	        s result.success=1
        }        
    }
    else
    {
	    s result.success=0
        s result.errorinfo="对象不存在！"
    }
    q result.%ToJSON()
SaveTasksERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集表","web.CDSS.Demo.DEMOTasks","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
 	s result.success=0
    s result.errorinfo="保存任务集失败！原因如下：<br>ERROR保存失败！"
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-10-29
/// Description:   删除任务集、删除任务集详情入口、删除任务集命中率记录表入口
/// Table：        WDT.CDSS.DEMOTasks
/// Input：        id 任务集ID
/// Output：       success 1 成功 0 失败；id 任务集ID；errorinfo 错误信息
/// Return：       result={ success, [id,] [errorinfo,] }
/// Others：       w ##class(web.CDSS.Demo.DEMOTasks).DeleteTasks("1")
ClassMethod DeleteTasks(id As %String) As %String
{
	s $zt="DeleteTasksERROE"
    s json={"ID":"","TaskName":"","TaskTarget":"","DocumentType":"","CreateUser":"","CreateTime":""}
    s result={"success":0}
    s user=$g(%session.Data("LOGON.USERNAME"))
    ;s user="yjh"
    
    s obj=##class(WDT.CDSS.DEMOTasks).%OpenId(id)
    if obj'=""
    {
	    s json.ID=id
	    s json.TaskName=obj.TaskName
	    s json.TaskTarget=obj.TaskTarget
	    s json.DocumentType=obj.DocumentType
	    s json.CreateUser=obj.CreateUser
	    s json.CreateTime=obj.CreateTime
	    
	    s flag=0
	    Tstart
	    //先删除任务集详情
	    s deldetailsc=##class(web.CDSS.Demo.DEMOTasks).DeleteTasksDetail("",id,user)
	    s deldetailrs={}.%FromJSON(deldetailsc)
	    if (deldetailrs.success)
	    {
		    //并删除任务集命中率记录表
	    	s delHitRateRecords=##class(web.CDSS.Demo.DEMOTasksHitRate).DeleteData(id)
	    	s delHitRateRecords={}.%FromJSON(delHitRateRecords)
	    	if (delHitRateRecords.success)
	    	{		    	
			    //最后删除任务集
			    s sc=##class(WDT.CDSS.DEMOTasks).%DeleteId(id)
			    if $$$ISOK(sc)
			    {
			        s result.id=id
			        s re=##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOTasks","WDT.CDSS.DEMOTasks","病历任务集表",id,json.TaskName,"D",json.%ToJSON())
			    }
			    else
			    {
				    s flag=1
				    s errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
			    	s result.errorinfo="删除任务集失败！原因如下：<br>"_errorinfo
			    	
			    	//保存错误日志
			    	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集","web.CDSS.Demo.DEMOTasks","DeleteTasks",json.%ToJSON())
				    s ^ERRORLOGINFO(logid)=errorinfo
			    }
	    	}
	    	else
	    	{
		    	s flag=1
		    	s result.errorinfo="删除任务集失败！原因如下：<br>"_delHitRateRecords.errorinfo
	    	}
	    }
	    else
	    {
		    s flag=1
		    s result.errorinfo="删除任务集失败！原因如下：<br>"_deldetailrs.errorinfo
	    }
	    if flag=1
	    {
		    TRO
		    s result.success=0
	    }
	    else
	    {
		    TC
		    s result.success=1
	    }
    }
    else
    {
	    s result.success=0
	    s result.errorinfo="删除任务集失败！原因如下：<br>ID为"_id_"的数据不存在！"
    }
    q result.%ToJSON()
DeleteTasksERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集","web.CDSS.Demo.DEMOTasks","DeleteTasks",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze
 	s result.success=0
	s result.errorinfo="删除任务集失败！原因如下：<br>ERROE保存失败！"
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-01-20
/// Description:   保存任务集命中率
/// Table：        WDT.CDSS.DEMOTasks
/// Input：        id 任务集ID；hitRate 命中率；user 操作用户
/// Output：       success 1 成功 0 失败；id 任务集ID；errorinfo 错误信息
/// Return：       result={ success, [id,] [errorinfo,] }
/// Others：       w ##class(web.CDSS.Demo.DEMOTasks).SaveHitRate("2","0.6")
ClassMethod SaveHitRate(id As %String = "", hitRate As %String = "", user)
{
	s result={}	//保存返回值
	if id=""
	{
		d result.%Set("success",0)
		d result.%Set("errorinfo","id为空！")
	}
	else
	{
		s obj=##class(WDT.CDSS.DEMOTasks).%OpenId(id)
		if obj=""
		{
			d result.%Set("success",0)
			d result.%Set("errorinfo","id="_id_"，数据不存在！")
		}
		else
		{			
			s obj.HitRate=hitRate	//命中率
			s initRate=obj.InitialHitRate
			//如果初始命中率是空，则表示是新增任务集，赋值。反之，为更新命中率，不能修改初始命中率
			if initRate=""
			{
				s obj.InitialHitRate=hitRate
			}
			
			s flag=0
			
			TS
			s sc=obj.%Save()
	        d obj.%Close()
	        If $$$ISOK(sc)
	        {
		        //再给命中率记录子表保存一条命中率数据
				s saveHitRateRecord=##class(web.CDSS.Demo.DEMOTasksHitRate).SaveData(id, hitRate)
				s saveResult={}.%FromJSON(saveHitRateRecord)
				if 'saveResult.success
				{
					s flag=1
					d result.%Set("errorinfo","保存命中率失败，原因如下：<br>"_saveResult.errorinfo)
				}
	        }
	        else
	        {
		        s flag=1
		        d result.%Set("errorinfo","保存命中率失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))  //返回错误信息
	        }
	        if flag=1
	        {
		        TRO
		        d result.%Set("success",0)
	        }
	        else
	        {
		        TC
		        d result.%Set("success",1)
		        d result.%Set("id",id)
	        }
		}
	}
	q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-10-29
/// Description:   查询病历任务集数据
/// Table：        WDT.CDSS.DEMOTasks
/// Input：        taskname 任务集名称，tasktarget 任务集目的，starttime 创建开始时间，endtime 创建结束时间，documenttype 文书类型
/// Output：       ID,TaskName,TaskTarget,CreateTime,CreateUser,DocumentType
/// Return：       返回符合查询条件的病历任务集数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetDataList","","","2021-09-23","2021-12-23","") 
Query GetDataList(taskname As %String, tasktarget As %String, starttime As %String, endtime As %String, documenttype As %String) As %Query(ROWSPEC = "ID:%String,TaskName:%String,TaskTarget:%String,InitialHitRate,HitRate,CreateTime:%String,CreateUser:%String,DocumentType:%String")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, taskname As %String, tasktarget As %String, starttime As %String, endtime As %String, documenttype As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	s:starttime["-" starttime=$zdh(starttime,3)
	s:endtime["-" endtime=$zdh(endtime,3)

	s ID=0
	for
	{
		s ID=$o(^WDT.CDSS.DEMOTasksD(ID))
		q:ID=""
		s TaskName=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),2)
		s TaskTarget=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),3)
		s DocumentType=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),4)
		s CreateTime=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),6)
		s CreateTime=$p(CreateTime," ",1)
		s CreateTime=$zdh(CreateTime,3)
		
		s HitRate=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),7)	//命中率
		s InitialHitRate=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),8)	//命中率

		if ((TaskName[taskname))&((TaskTarget[tasktarget))&((documenttype=DocumentType) || (documenttype="") )&(((CreateTime>=starttime)||(starttime=""))&((CreateTime<=endtime)||(endtime="")))
		{
			s CreateTime=$zd(CreateTime,3)
			s CreateUser=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),5)	// 创建人员
			d OutputTasksRow
		}
	}
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputTasksRow
    set ^CacheTemp(repid,ind)=$lb(ID,TaskName,TaskTarget,InitialHitRate,HitRate,CreateTime,CreateUser,DocumentType)
    Set ind=ind+1
    quit
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      杨继鸿
/// CreatDate：    2021-12-03
/// Description:   保存病历任务集详情
/// Table：        WDT_CDSS.DEMOTasksDetail
/// Input：        rowid 病历任务集详情表ID, patientids 患者基础信息表ID和是否命中, taskid 病历任务集ID, user 操作人员
/// Output：       json串：success成功标志、idnos 患者基础信息表IDNO串、ids 病历任务集详情表ID串、errorinfo 错误信息
/// Return：       成功返回 {success:1,[id:id]}；失败返回 {success:0,[id:id]}
/// Others：       d ##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail("","1_1,2_0","4","yjh")
ClassMethod SaveTasksDetail(rowid As %String = "", patientids As %String = "", taskid As %String = "", user As %String = "") As %String
{
	s $zt="SaveTDetailERROE"
	s result={}
	s ids=""	//病历任务集详情表ID串
	//病历任务集详情JSON对象
	s jsonObj={"ID":"","PatientDR":"","TaskDR":"","State":"","OperatorUser":"","OperationTime":""}
	s jsonObj.ID=rowid
	s jsonObj.TaskDR=taskid	// 指向任务集ID
	s jsonObj.OperatorUser=user	// 操作人员
	s jsonObj.State="0"	// 编辑状态
	if (rowid'="")	// 修改数据
	{
		s obj=##class(WDT.CDSS.DEMOTasksDetail).%OpenId(rowid)
		if (obj'="")
		{
			s obj.State="1",jsonObj.State="1"
			s obj.OperationTime=$ZDATETIME($H,3)
			s User=$g(%session.Data("LOGON.USERNAME"))
			if (User'="")
			{
				//能获取到USERNAME
				s obj.OperatorUser=User
			}
			else
			{
				s obj.OperatorUser=user
			}
			
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				TC
				d result.%Set("success",1)
				d result.%Set("id",rowid)
			}
			else
			{
				TRO
				d result.%Set("success",0)
				s info=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				d result.%Set("errorinfo","保存任务集详情失败！原因如下：<br>"_info)
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情表","web.CDSS.Demo.DEMOTasks","SaveTasksDetail",jsonObj.%ToJSON())
	   	    	s ^ERRORLOGINFO(logid)=info
			}
		}
		else
		{
			d result.%Set("success",0)
			d result.%Set("errorinfo","保存任务集详情失败！原因如下：<br>数据不存在！")
		}
		
	}
	else	// 新增数据
	{
		s n=$length(patientids, ",")
		s flag=0
		TS
		for i=1:1:n
		{
			s patientidAndIshit=$p(patientids, ",", i)
			if patientidAndIshit=""
			{
				continue
			}
			s obj = ##class(WDT.CDSS.DEMOTasksDetail).%New()
			
			s patientid=$p(patientidAndIshit, "_", 1)
			
			d obj.PatientDRSetObjectId(patientid)	// 指向算法评测平台的患者基础信息表
	    	d obj.TaskDRSetObjectId(taskid)	// 指向任务集
	    	s obj.State="0"	// 0-状态:编辑/1-继续编辑
		    s obj.OperatorUser=user	//操作人员		    
		    s obj.OperationTime=$ZDATETIME($H,3) //操作时间
		    s obj.IsHit=$p(patientidAndIshit, "_", 2)	//是否命中
		    
		    s jsonObj.PatientDR=patientid	// 患者基础信息表ID
		    
		    ;s idno=$g(^WDT.CDSS.DEMOPatMasterI("IDNOIndex"))
		 
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
		    {	
		    	if (ids="")
		    	{
			    	s ids = obj.%Id()
		    	}
		    	else
		    	{        
		        	s ids = ids_"^"_obj.%Id()
		    	}
			}
			else
			{
				s flag=1
				d result.%Set("success",0)
				s info=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				d result.%Set("errorinfo","保存任务集详情失败！原因如下：<br>"_info)
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情表","web.CDSS.Demo.DEMOTasks","SaveTasksDetail",jsonObj.%ToJSON())
	   	    	s ^ERRORLOGINFO(logid)=info
				Quit
			}
		}
		if (flag=1)
		{
			TRO
		}
		else
		{
			TC
			d result.%Set("success", 1)
		    d result.%Set("idnos", patientids)
		    d result.%Set("ids", ids)
		}
	}
	q result.%ToJSON()
SaveTDetailERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情表","web.CDSS.Demo.DEMOTasks","SaveTasksDetail",jsonObj.%ToJSON())
	s ^ERRORLOGINFO(logid)=$ze
 	d result.%Set("success",0)
	d result.%Set("errorinfo","保存任务集详情失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2021-10-29
/// Description:   删除任务集、删除任务集详情入口、删除任务集命中率记录表入口
/// Table：        WDT.CDSS.DEMOTasks
/// Input：        id 任务集详情ID，taskid 任务集ID，opuser 操作人员
/// Output：       success 1 成功 0 失败；id 任务集ID；errorinfo 错误信息
/// Return：       result={ success, [id,] [errorinfo,] }
/// Others：       w ##class(web.CDSS.Demo.DEMOTasks).DeleteTasksDetail("","1","yjh")
ClassMethod DeleteTasksDetail(id As %String = "", taskid As %String = "", opuser As %String = "") As %String
{
	s $zt="ERROE"
	s json={"ID":"","PatientDR":"","TaskDR":"","State":"","OperatorUser":"","OperationTime":""}
    s result={"success":0}
    s user=opuser
    s ids=""
    
    if (id'="")
    {
	    s obj=##class(WDT.CDSS.DEMOTasksDetail).%OpenId(id)
	    if obj'=""
	    {
		    
		    s json.ID=id
		    s json.PatientDR=obj.PatientDR.%Id()
		    s json.TaskDR=obj.TaskDR.%Id()
		    s json.State=obj.State
		    s json.OperatorUser=obj.OperatorUser
		    s json.OperationTime=obj.OperationTime
		    
		    Tstart
		    s sc=##class(WDT.CDSS.DEMOTasksDetail).%DeleteId(id)
		    if $$$ISOK(sc)
		    {
			    //删除关联的NLP、推荐疑似诊断记录
			    s delNLP=##class(web.CDSS.Demo.DEMONLPIdentify).DeleteNLPIdentify("",id,user)
			    
			    s rs1={}.%FromJSON(delNLP)
			    s delSuspdise=##class(web.CDSS.Demo.DEMONLPIdentify).DeleteSuspDise("",id,user)
			    
			    s rs2={}.%FromJSON(delSuspdise)
			    if (rs1.success) & (rs2.success)
			    {
			        Tcommit
			        d result.%Set("success",1)
			        d result.%Set("id",id)
			        
			        //保存删除日志
			        s re=##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOTasksDetail","WDT.CDSS.DEMOTasksDetail","病历任务集详情",id,json.TaskName,"D",json.%ToJSON())
			    }
			    else
			    {
				    Trollback
			    }
		    }
		    else 
		    {
		        Trollback
		        //保存错误日志
		    }
	    }
	    else
	    {
	        d result.%Set("success",0)
	        d result.%Set("errorinfo","删除任务集详情失败，原因如下：<br>数据不存在！")
	    }
    }
    //id为空，说明正在批量删除任务集详情
    else
    {
	    s flag=0
	    s ID=0
	    
	    Tstart
	    for
	    {
		    s ID=$o(^WDT.CDSS.DEMOTasksDetailI("TaskIndex",taskid,ID))
		    q:ID=""
		    
		    s json.ID=ID
		    s json.PatientDR=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(ID)),2)	// 指向患者基础信息表的ID
		    s json.TaskDR=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(ID)),3)
		    s json.State=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(ID)),4)
		    s json.OperatorUser=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(ID)),5)
		    s json.OperationTime=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(ID)),6)
		    s jsonstr=json.%ToJSON()
		    
		    //先删除关联的NLP、推荐疑似诊断记录
		    s delNLP=##class(web.CDSS.Demo.DEMONLPIdentify).DeleteNLPIdentify("",ID,user)
		    s rs1={}.%FromJSON(delNLP)
		    
		    s delSuspdise=##class(web.CDSS.Demo.DEMONLPIdentify).DeleteSuspDise("",ID,user)
		    s rs2={}.%FromJSON(delSuspdise)
		    if (rs1.success) & (rs2.success)
		    {
			    //最后删除任务集详情
			    s sc=##class(WDT.CDSS.DEMOTasksDetail).%DeleteId(ID)
			    if $$$ISOK(sc)
			    {
				    if (ids="")
				    {
					    s ids=ID
				    }
				    else
				    {
					    s ids=ids_"^"_ID
				    }
				    //保存删除日志，批量删除不写知识库日志
			        //s re=##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOTasksDetail","WDT.CDSS.DEMOTasksDetail","病历任务集详情",id,json.TaskName,"D",json.%ToJSON())
			    }
			    else
			    {
				    s flag=1
				    s errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
				    s result.errorinfo="删除任务集详情失败，原因如下：<br>"_errorinfo
				    
				    //保存错误日志
				    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情","web.CDSS.Demo.DEMOTasks","DeleteTasksDetail",json.%ToJSON())
			        s ^ERRORLOGINFO(logid)=errorinfo
				    
				    Quit
			    }
		    }
		    else
		    {
			    s flag=1
			    if ('rs1.success)
			    {
				    s result.errorinfo="删除任务集详情失败！原因如下：<br>"_rs1.errorinfo
			    }
			    else
			    {
				    s result.errorinfo="删除任务集详情失败！原因如下：<br>"_rs2.errorinfo
			    }			    
			    Quit
		    }
	    }
	    if (flag=1)
	    {
		    TRO
		    s result.success=0
	    }
	    else
	    {
		    TC
		    s result.success=1
		    s result.ids=ids
	    }
    }
    q result.%ToJSON()
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("病历任务集详情","web.CDSS.Demo.DEMOTasks","DeleteTasksDetail",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 	    
    d result.%Set("success",0)
    d result.%Set("errorinfo","删除任务集详情失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-13
/// Description:   保存任务集详情是否命中IsHit，0-未命中/1-命中
/// Table：        WDT.CDSS.DEMOTasksDetail
/// Input：        id 任务集详情ID；isHit 0 未命中 1 命中；user 操作人员
/// Output：       success 1 成功 0 失败；id 任务集ID；errorinfo 错误信息
/// Return：       result={ success, [id,] [errorinfo,] }
/// Others：       w ##class(web.CDSS.Demo.DEMOTasks).SaveIsHit("1","1")
ClassMethod SaveIsHit(id As %String = "", isHit As %String = "", user)
{
	s result={}	//保存返回值
	if id=""
	{
		d result.%Set("success",0)
		d result.%Set("errorinfo","保存任务集详情是否命中失败，原因如下：<br>id为空！")
	}
	else
	{
		s obj=##class(WDT.CDSS.DEMOTasksDetail).%OpenId(id)
		if obj=""
		{
			d result.%Set("success",0)
			d result.%Set("errorinfo","保存任务集详情是否命中失败，原因如下：<br>id="_id_"，数据不存在！")
		}
		else
		{
			s oldV=obj.IsHit
			if (oldV=isHit)
			{
				//是否命中状态没有变化，不保存
				d result.%Set("success",1)
			}
			else
			{
				s obj.IsHit=isHit	//是否命中
				s obj.OperationTime=$ZDATETIME($H,3)	//操作时间
				s obj.OperatorUser=user	// 操作人员
			
				TS
				s sc=obj.%Save()
		        d obj.%Close()
		        If $$$ISOK(sc)
		        {
			        TC
			        d result.%Set("success",1)
			        d result.%Set("id",id)
		        }
		        else
		        {
			        TRO
			        d result.%Set("success",0)
			        d result.%Set("errorinfo","保存任务集详情是否命中失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))  //返回错误信息
		        }	
			}
		}
	}
	q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2021-11-10
/// Description:	查询病历任务集详情表数据
/// Table:			WDT.CDSS.DEMOTasksDetail
/// Input:			rowid 病历任务集详情表ID, taskid 病历任务集表ID
/// Return:			返回某任务集对应的任务集详情数据
/// Other:			d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetDetailList","","1")
Query GetDetailList(rowid As %String, taskid As %String) As %Query(ROWSPEC = "RowId,PatientDR,IDNO,State,IsHit,OperatorUser,OperationTime,TaskDR")
{
}

ClassMethod GetDetailListExecute(ByRef qHandle As %Binary, rowid, taskid) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid

		s PatientID=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),2)	// 指向患者基础信息表的ID 3-20
		
		s PatientDR=$LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientID)),3)

		s IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientDR)),2)	// 患者基础信息表的患者主索引IDNO

		s State = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),4)
		s OperatorUser = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),5)
		s OperationTime = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),6)
		s IsHit = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),7)
		s:IsHit="0" IsHit="未命中"
		s:IsHit="1" IsHit="命中"
		s:IsHit="3" IsHit="不计入命中"
		s:IsHit="2" IsHit="无效数据"
		s:IsHit="" IsHit="未统计是否命中"
		s TaskDR = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),3)

		d OutputTasksDetailRow
	}
	else
	{
		s patientID=0
		for
		{
			s patientID=$o(^WDT.CDSS.DEMOTasksDetailI("PatientIndex", taskid, patientID))
			q:patientID=""
			
			s RowId=$o(^WDT.CDSS.DEMOTasksDetailI("PatientIndex", taskid, patientID, 0))

			s PatientID=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),2)	// 指向患者基础信息表的ID
			//s PatientID=$LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),2)	// 指向患者基础信息表的ID 3-20
		
			s PatientDR=$LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientID)),3)

			s IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(PatientID)),2)	// 患者基础信息表的患者主索引IDNO

			s State = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),4)
			s OperatorUser = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),5)
			s OperationTime = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),6)
			s IsHit = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),7)
			s:IsHit="0" IsHit="未命中"
			s:IsHit="1" IsHit="命中"
			s:IsHit="2" IsHit="无效数据"
			s:IsHit="3" IsHit="不计入命中"
			s:IsHit="" IsHit="未统计是否命中"
			s TaskDR = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(RowId)),3)
			
			d OutputTasksDetailRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputTasksDetailRow
	set Data=$lb(RowId,PatientDR,IDNO,State,IsHit,OperatorUser,OperationTime,TaskDR)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：杨继鸿
/// CreatDate: 2020-11-09
/// Description：查询患者基础信息数据
/// Table：WDT.CDSS.DEMOPatMaster
/// Input：rowid 患者基础信息表ID, hospital 医院, department 科室, from ID区间开始ID, to ID区间结束ID
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetPatientList","","1","")
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetPatientList","","四川大学华西二院","呼吸科","","10")
/// d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetPatientList","","NULL","","","")
Query GetPatientList(rowid, hospital, department, from, to) As %Query(ROWSPEC = "ID,IDNO,Department,Hospital,PatientDR")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, rowid, hospital, department, from, to) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
		
		s IDNO = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(rowid)),2)
		s Department = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(rowid)),14)
		s Hospital = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(rowid)),30)

		d OutputPatMasterRow
	}
	else
	{
		s ID=0
		for
		{  
			s ID=$o(^WDT.CDSS.DEMOPatMasterD(ID))
			q:ID=""

			s IDNO=$LISTGET($G(^WDT.CDSS.DEMOPatMasterD(ID)),2)
			s PatientDR=$LISTGET($G(^WDT.CDSS.DEMOPatMasterD(ID)),3)
			s Department = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(ID)),14)
			s Hospital = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(ID)),30)
			if (hospital="空") && (Hospital="")
			{
				if ((Department=department)||(department=""))&&((ID>=from)||(from=""))&&((ID<=to)||(to=""))
				{
					d OutputPatMasterRow
				}
			}
			else
			{
				if ((Hospital=hospital)||(hospital=""))&&((Department=department)||(department=""))&&((ID>=from)||(from=""))&&((ID<=to)||(to=""))
				{
					d OutputPatMasterRow
				}	

			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputPatMasterRow
    set Data=$lb(ID,IDNO,Department,Hospital,PatientDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	杨继鸿
/// CreatDate:	2021-12-02
/// Description:	查询患者基础信息表-获取医院数据
/// Table:		WDT.CDSS.DEMOPatMaster
/// Output:		Hospital
/// Return:		返回所有医院
/// Other:		d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetHospital")
Query GetHospital() As %Query(ROWSPEC = "Hospital")
{
}

ClassMethod GetHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	kill ^temphospitals	// 存放所有医院
	
	s RowId=0
	for
	{  
		s RowId=$o(^WDT.CDSS.DEMOPatMasterD(RowId))
		q:RowId=""

		s Hospital = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(RowId)),30)
		
		if (Hospital="")
		{
			s ^temphospitals("空")=""
		}
		else
		{			
			s ^temphospitals(Hospital)=""
		}
	}
	
	s Hospital=""
	for
	{
		s Hospital=$o(^temphospitals(Hospital))
		q:Hospital=""
		d OutputHospitalRow
	}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputHospitalRow
    set Data=$lb(Hospital)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	kill ^temphospitals
	Quit $$$OK
}

ClassMethod GetHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：杨继鸿
/// CreatDate: 2021-12-02
/// Description：查询患者基础信息表-获取科室数据
/// Table: WDT.CDSS.DEMOPatMaster
/// Input:
/// Output:
/// Return: 返回所有科室
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetDepartment","")
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMOTasks","GetDepartment")
Query GetDepartment() As %Query(ROWSPEC = "Department")
{
}

ClassMethod GetDepartmentExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	kill ^tempdepartments	// 存放所有科室
	s RowId=0
	for
	{  
		s RowId=$o(^WDT.CDSS.DEMOPatMasterD(RowId))
		q:RowId=""			
		
		s Department = $LISTGET($G(^WDT.CDSS.DEMOPatMasterD(RowId)),14)
		if (Department="")
		{
			continue
		}
		else
		{			
			s ^tempdepartments(Department)=""
		}
		
	}
	
	s Department=""
	for
	{
		s Department=$o(^tempdepartments(Department))
		q:Department=""
		d OutputDepartmentRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputDepartmentRow
    set Data=$lb(Department)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDepartmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepartmentExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Kill ^tempdepartments
	Quit $$$OK
}

ClassMethod GetDepartmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepartmentExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-01
/// Description:批量更新任务集
/// Table: User.DHCDSSDEMOdmRec,WDT.CDSS.DEMOPatMaster
/// 测试:w ##class(web.CDSS.Demo.DEMOTasks).UpdateData("DM000761")
/// d ##class(web.CDSS.Demo.DEMOTasks).UpdateData("XiaMenXiangAN977445")
ClassMethod UpdateData(IDNOStr)
{
	s AdmID=0
	s Num=0
	for Num=1:1:$l(IDNOStr,"^")
	{
		s IDNO=$p(IDNOStr,"^",Num)
		s PatDR=$o(^WDT.CDSS.DEMOPatMasterI("IDNOIndex",IDNO,0))
		q:PatDR=""	
		s PatientDR=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),3)			//PatientDR
		s AdmissionCount=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),5)		//住院次
		s Name=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),8)				//姓名
		s Department=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),14)			//科室
		s Hospital=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),30)			//医院
		s Sex=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),9)					//性别
		s Birthday=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),10)
		s Age=$lg($g(^WDT.CDSS.DEMOPatMasterD(PatDR)),11) //年龄
		s AdmID=$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatDR,0))
		if (AdmID'=""){
			s ChiefCompSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),3)		//主诉
			s CurrentMedHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),4)	//现病史
			s PastDiagnosisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),5)
			s AllergyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),6)
			s PersonalHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),7)
			s MarryHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),8)
			s MenstrualHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),9)
			s FamilyHisSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),10)
			s PhysicalExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),11)
			s SpecExamSum=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),12)
			s AssisExam=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),13)
			s CurrentTreatMedication=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),14)
			s PreliminaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),15)		//初步
			s ConfirmDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),16)			//确诊
			s ComplementaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),17)		//补充
			s DiagnosisCorrecting=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),18)	//修正
			s RecordTime=$lg($g(^WDT.CDSS.DEMOAdmRecD(AdmID)),20)				//记录时间
		} else{
			s ChiefCompSum=""
			s CurrentMedHisSum=""
			s PastDiagnosisSum=""
			s AllergyHisSum=""
			s PersonalHisSum=""
			s MarryHisSum=""
			s MenstrualHisSum=""
			s FamilyHisSum=""
			s PhysicalExamSum=""
			s SpecExamSum=""
			s AssisExam=""
			s CurrentTreatMedication=""
			s PreliminaryDiag=""
			s ConfirmDiag=""
			s ComplementaryDiag=""
			s DiagnosisCorrecting=""
			s RecordTime=""
		}
		
        s record={}
        d record.%Set("IDNO",IDNO)
        d record.%Set("PatientDR",PatientDR)
        d record.%Set("VisitID",AdmissionCount)
        d record.%Set("VisitType","3")
        d record.%Set("Name",Name)
        d record.%Set("UserID","XXX")
        d record.%Set("UserName","XXX")
        d record.%Set("DeptCode","XXX")
        d record.%Set("DeptName",Department)
        d record.%Set("HospCode","XXX")
        d record.%Set("HospName",Hospital)
        s PatientInfo={}
        if (Sex = "女") {
            s Gender = 0
        } elseif (Sex = "男") {
            s Gender = 1
        } else{ 
            s Gender = 2
        }
        d PatientInfo.%Set("Gender",Gender)
        d PatientInfo.%Set("BirthDate",Birthday)
        d PatientInfo.%Set("Age",Age)
        d PatientInfo.%Set("PregnancyStatus",0)
        d record.%Set("PatientInfo",PatientInfo)
        s ProgressNoteList={}
        d ProgressNoteList.%Set("ProgressId","Patient"_Num_1)
        d ProgressNoteList.%Set("ProgressType",0)
        d ProgressNoteList.%Set("ProgressTempleateID","Patient"_Num_1)
        d ProgressNoteList.%Set("ProgressTemplateName","")
        d ProgressNoteList.%Set("MsgType",2)
        d ProgressNoteList.%Set("Message","")
        s MessageList=[]
        s MessageArr("1","主诉")=ChiefCompSum
        s MessageArr("2","现病史")=CurrentMedHisSum
        s MessageArr("3","既往史")=PastDiagnosisSum
        s MessageArr("4","个人史")=PersonalHisSum
        s MessageArr("5","婚育史")=MarryHisSum
        s MessageArr("6","其他史")=""
        s MessageArr("7","过敏史")=AllergyHisSum
        s MessageArr("8","家族史")=FamilyHisSum
        s MessageArr("9","月经史")=MenstrualHisSum
        s MessageArr("10","体格检查")=PhysicalExamSum
        s MessageArr("11","专科检查")=SpecExamSum
        s MessageArr("12","初步诊断")=PreliminaryDiag
        s MessageArr("13","确诊诊断")=ConfirmDiag
        s MessageArr("14","补充诊断")=ComplementaryDiag
        s MessageArr("15","修正诊断")=DiagnosisCorrecting
        s idNum=""
        for {
        	s idNum=$o(MessageArr(idNum)) q:idNum=""
        	s key=$o(MessageArr(idNum,""))
        	s value=$g(MessageArr(idNum,key))
        	s message={}
        	d message.%Set("key",key)  
        	d message.%Set("value",value)    
        	d MessageList.%Push(message)
        }
        d ProgressNoteList.%Set("MessageList",MessageList)
        d ProgressNoteList.%Set("DoctorId","XXX")
        d ProgressNoteList.%Set("DoctorName","XXX")
        d ProgressNoteList.%Set("CreateDeptCode","XXX")
        d ProgressNoteList.%Set("CreateDeptName",Department)
        d ProgressNoteList.%Set("RecordTime",RecordTime)
       	d record.%Set("ProgressNoteList",ProgressNoteList)
       	s jsonRecord=record.%ToJSON()
       	//s scHis=##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("SAVE_MEDICAL_RECORD_INFORMATION",jsonRecord)
       	d ##class(web.CDSS.Demo.PatientInfoRenew).DHCHisInterface("SAVE_MEDICAL_RECORD_INFORMATION",jsonRecord)
       
	}
	q {"success":1}.%ToJSON()
}

/// Creator:鲁为杰
/// CreatDate:2021-12-29
/// Description:获取诊断信息对应权重
/// Input: 诊断信息
/// Return:权重
/// Others:w ##class(web.CDSS.Demo.PatientInfoRenew).GetFactorWeight("等级二(实体词--主诉)")
/// Others:w ##class(web.CDSS.Demo.PatientInfoRenew).GetFactorWeight("等级一(上位词--现病史)")
/// Others:w ##class(web.CDSS.Demo.PatientInfoRenew).GetFactorWeight("等级二(上位词--现病史)")
ClassMethod GetFactorWeight(FactorInfo As %String) As %String
{
	s Weight=0
	s Value=1
	if FactorInfo["(以‘’收入院)"
	{
		s Weight=0.66
	}
	elseif FactorInfo["常见科室"
	{
		s Weight=0.01 //0.03
	}
	elseif FactorInfo["年龄最小值(天)"
	{
		s Weight=0.01 //0.002
	}
	elseif FactorInfo["患者性别："
	{
		s Weight=0.01 //0.002
	}
	elseif FactorInfo["高发地区："
	{
		s Weight=0.01 //0.002
	}
	elseif FactorInfo["等级一"
	{
		if FactorInfo["上位"
		{
			s Value=Value-0.3
		}
		if FactorInfo["主诉"
		{
			s Value=Value+0.1
		}
		elseif FactorInfo["既往史"
		{
			s Value=0.5
		}
		s Weight=0.03*Value
	}
	elseif FactorInfo["等级二"
	{
		if FactorInfo["上位"
		{
			s Value=Value-0.3
		}
		if FactorInfo["主诉"
		{
			s Value=Value+0.1
		}
		elseif FactorInfo["既往史"
		{
			s Value=0.5
		}
		s Weight=0.06*Value
	}
	elseif FactorInfo["等级三"
	{
		if FactorInfo["上位"
		{
			s Value=Value-0.3
		}
		if FactorInfo["主诉"
		{
			s Value=Value+0.1
		}
		elseif FactorInfo["既往史"
		{
			s Value=0.5
		}
		s Weight=0.11*Value
	}
	elseif FactorInfo["等级四"
	{
		if FactorInfo["上位"
		{
			s Value=Value-0.3
		}
		if FactorInfo["主诉"
		{
			s Value=Value+0.1
		}
		elseif FactorInfo["既往史"
		{
			s Value=0.5
		}
		s Weight=0.24*Value
	}
	elseif FactorInfo["等级五"
	{
		if FactorInfo["上位"
		{
			s Value=Value-0.3
		}
		if FactorInfo["主诉"
		{
			s Value=Value+0.1
		}
		elseif FactorInfo["既往史"
		{
			s Value=0.5
		}
		s Weight=0.56*Value
	}
	if Weight<1
	{
		s Weight="0"_Weight
	}
	q Weight
}

/// Creator: 杨继鸿
/// CreatDate: 2022-01-20
/// Description: 检查是否重名
/// Table: WDT_CDSS.DEMOTasks
/// Input: taskName 任务集名称
/// Output: isrepeated 1 重复 0 没有重复
/// Return: result={ isrepeated }
/// Other: w ##class(web.CDSS.Demo.DEMOTasks).IsRepeated("yjh测试")
ClassMethod IsRepeated(taskName As %String = "") As %String
{
	s ID=0
	s result={"isrepeated":0}
	for
	{
		s ID=$o(^WDT.CDSS.DEMOTasksD(ID))
		q:ID=""
		s TaskName=$lg($g(^WDT.CDSS.DEMOTasksD(ID)),2)
		if (taskName=TaskName)
		{
			d result.%Set("isrepeated",1)
			Quit
		}
	}
	q result.%ToJSON()
}

/// Creator: 杨继鸿
/// CreatDate: 2022-02-25
/// Description: 保存任务集命中率，任务集详情是否命中
/// Table: WDT_CDSS.DEMOTasks、WDT_CDSS.DEMOTasksDetail
/// Input: HitInfo {taskID:detailID:isHit^...^detailID:isHit,...,taskID:detailID:isHit^...^detailID:isHit}
/// Output: success 1 成功 0 失败；errorinfo 失败信息
/// Return: result={success,[errorinfo]}
/// Other: w ##class(web.CDSS.Demo.DEMOTasks).SaveAllHitInfo("{""1"": ""1:1^2:0^3:0"", ""2"":""21:1^22:1^23:1""}")
ClassMethod SaveAllHitInfo(HitInfo As %String) As %String
{
	s result={}	//保存返回值
	s user=$g(%session.Data("LOGON.USERNAME"))
	;s user="yjh"
	s taskHitInfo={}.%FromJSON(HitInfo)
	s iter=taskHitInfo.%GetIterator()
	
	s flag=0
	TS
	while(iter.%GetNext(.key,.value))
	{
		s hitRate=0
		s isHitNum=0,totalNum=0
		s length=$length(value, "^")
		for i=1:1:length
		{
			s Ndetail=$p(value, "^", i)
			s NdetailID=$p(Ndetail, ":", 1)
			s NdetailIsHit=$p(Ndetail, ":", 2)
			
			//s hitRate=hitRate+NdetailIsHit
			//总数过滤不计入命中的数据和无效数据 Add By ZWW 2023-04-20
			if ((NdetailIsHit'=3)&&(NdetailIsHit'=2)){
				s totalNum=totalNum+1
				if (NdetailIsHit=1){
					s isHitNum=isHitNum+1
				}
			}
			
			s rs=..SaveIsHit(NdetailID, NdetailIsHit, user)
			s rs={}.%FromJSON(rs)
			if rs.success
			{
				continue
			}
			else
			{
				s flag=1
				d result.%Set("errorinfo", "保存任务集命中率失败！原因如下：<br>"_rs.errorinfo)
				Quit
			}
		}
		if flag=1
		{
			Quit
		}
		else
		{
			//s hitRate=$fn(hitRate/length, "", 2)	//保留两位小数
			s hitRate=$fn(isHitNum/totalNum, "", 2)	//保留两位小数
			s saveHitRateRS=..SaveHitRate(key, hitRate, user)
			s saveHitRateRS={}.%FromJSON(saveHitRateRS)
			if saveHitRateRS.success
			{
				continue
			}
			else
			{
				s flag=1
				d result.%Set("errorinfo", "保存任务集命中率失败！原因如下：<br>"_rs.errorinfo)
				Quit
			}
		}
	}
	if flag=1
	{
		TRO
		d result.%Set("success", 0)
	}
	else
	{
		TC
		d result.%Set("success", 1)
	}
	q result.%ToJSON()
}

/// Creator: 赵文伟
/// CreatDate: 2023-04-19
/// Description: 修改指定患者是否命中，重新计算命中率 
/// Table: WDT_CDSS.DEMOTasks、WDT_CDSS.DEMOTasksDetail
/// Input: HitInfo (TaskID+"^"+TaskDetailID+"^"+isHit)
/// Output: success 1 成功 0 失败；errorinfo 失败信息
/// Return: result={success,[errorinfo]}
/// Other: w ##class(web.CDSS.Demo.DEMOTasks).SaveHitInfo("135^3998^3")
ClassMethod SaveHitInfo(HitInfo As %String) As %String
{
	s result={}	//保存返回值
	s flag=0
	s user=""
	if ($d(%session)) {s user=$g(%session.Data("LOGON.USERNAME"))}
	
	s TaskDR=$p(HitInfo,"^",1)
	s TaskDetailID=$p(HitInfo,"^",2)
	//s PatientDR=$p(HitInfo,"^",3)
	s IsHit=$p(HitInfo,"^",3)
	
	TS
	s rs=..SaveIsHit(TaskDetailID, IsHit, user)
	s rs={}.%FromJSON(rs)
	if rs.success
	{
		//计算命中率命中/（命中1+未命中0+未统计是否命中""）
		s hit=0,nohit=0,nocount=0,totalhit=0,hitRate=0
		&sql(SELECT COUNT(IsHit) INTO :hit FROM WDT_CDSS.DEMOTasksDetail WHERE TaskDR=:TaskDR AND IsHit=1)
		&sql(SELECT COUNT(IsHit) INTO :totalhit FROM WDT_CDSS.DEMOTasksDetail WHERE TaskDR=:TaskDR AND IsHit<>3 AND IsHit<>2)
		//&sql(SELECT COUNT(IsHit) INTO :nohit FROM WDT_CDSS.DEMOTasksDetail WHERE TaskDR=:TaskDR AND IsHit=0)
		//&sql(SELECT COUNT(IsHit) INTO :nocount FROM WDT_CDSS.DEMOTasksDetail WHERE TaskDR=:TaskDR AND IsHit IS NULL)
		if (totalhit'=0){
			s hitRate=$fn(hit/totalhit, "", 2)	//保留两位小数
			s saveHitRateRS=..SaveHitRate(TaskDR, hitRate, user)
			s saveHitRateRS={}.%FromJSON(saveHitRateRS)
			if 'saveHitRateRS.success
			{
				s flag=1
				d result.%Set("errorinfo", "保存任务集命中率失败！原因如下：<br>"_saveHitRateRS.errorinfo)
			}
		}
	}
	else
	{
		s flag=1
		d result.%Set("errorinfo", "保存失败！原因如下：<br>"_rs.errorinfo)
	}
	if flag=1
	{
		TRO
		d result.%Set("success", 0)
	}
	else
	{
		TC
		d result.%Set("success", 1)
	}
	q result.%ToJSON()
}

/// Creator: 赵文伟
/// CreatDate: 2023-04-19
/// Description: 获取当前数据命中状态
/// Table: WDT_CDSS.DEMOTasksDetail
/// Input: TaskDetailID
/// Output: IsHit
/// Other: w ##class(web.CDSS.Demo.DEMOTasks).GetNowIsHit("3998")
ClassMethod GetNowIsHit(TaskDetailID As %String) As %String
{
	s IsHit=""
	s:TaskDetailID'="" IsHit = $LISTGET($G(^WDT.CDSS.DEMOTasksDetailD(TaskDetailID)),7)
#;	s:IsHit="0" IsHit="未命中"
#;	s:IsHit="1" IsHit="命中"
#;	s:IsHit="2" IsHit="无效数据"
#;	s:IsHit="3" IsHit="不计入命中"
#;	s:IsHit="" IsHit="未统计是否命中"
	q IsHit
}

}
