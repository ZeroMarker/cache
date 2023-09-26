/// 名称:     web.CDSS.Demo.DEMORareDiseRec.cls
/// 描述:     操作【疑似罕见病记录表】、疑似罕见病记录详情表
/// 编写者：  杨继鸿
/// 编写日期: 2022-02-25
Class web.CDSS.Demo.DEMORareDiseRec Extends %RegisteredObject
{

/// Creator:		杨继鸿
/// CreatDate:		2022-02-25
/// Description:	保存【疑似罕见病记录表】数据
/// Table:			WDT_CDSS.DEMORareDiseRec
/// Input:			rowid 疑似罕见病记录表ID串, RareDiseInfo 疑似罕见病信息, TasksDetailID 病历任务集详情表ID, State 更新推荐诊断记录
/// Output:			成功返回 result={"success":1,"ids":"id^id"}，失败返回{"success":0,"errorinfo":"错误信息"}
/// Return:			返回保存信息，success（成功与否0失败、1成功），ids ID串，errorinfo 错误信息
/// Others:			d ##class(web.CDSS.Demo.DEMORareDiseRec).SaveData("41^42")
/// d ##class(web.CDSS.Demo.DEMORareDiseRec).SaveData("",[{""DiseaseDetail"": {""就诊科室：呼吸科"": ""常见科室：胸外科,呼吸科,肿瘤科"", ""胸腔积液"": ""等级三(实体词--现病史)(以‘’收入院)""}, ""DiseaseID"": ""985"",""DiseaseName"": ""胸腔积液"", ""Symptom"": [""胸腔积液""], ""Weight"": ""0.672""},{...}])
ClassMethod SaveData(rowid As %String, RareDiseInfo, TasksDetailID As %String, State As %String = "0") As %String
{
	s $zt="SaveERROE"
	s result={}
	s json={"ID":"","TasksDetailDR":"","RareDise":"","RareDiseID":"","RareDiseWeight":"","RareDiseOrder":"","OperatorUser":"","OperationTime":""}
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	// 修改数据
	if (rowid'="")
	{
		s upID=$p(rowid, "^", 1)	//顺序上移的记录ID
		s downID=$p(rowid, "^", 2)	//顺序下移的记录ID
		
		s obj1=##class(WDT.CDSS.DEMORareDiseRec).%OpenId(upID)
		s obj2=##class(WDT.CDSS.DEMORareDiseRec).%OpenId(downID)
		
		// 备份旧数据
		s bjson1={}, bjson2={}
		s bjson1.ID=obj1.%Id(), bjson2.ID=obj2.%Id()
		s bjson1.TasksDetailDR=obj1.TasksDetailDR.%Id(), bjson2.TasksDetailDR=obj2.TasksDetailDR.%Id()
		s bjson1.RareDise=obj1.RareDise, bjson2.RareDise=obj2.RareDise
		s bjson1.RareDiseID=obj1.RareDiseID, bjson2.RareDiseID=obj2.RareDiseID
		s bjson1.RareDiseWeight=obj1.RareDiseWeight, bjson2.RareDiseWeight=obj2.RareDiseWeight
		s bjson1.RareDiseOrder=obj1.RareDiseOrder, bjson2.RareDiseOrder=obj2.RareDiseOrder
		s bjson1.OperationTime=obj1.OperationTime, bjson2.OperationTime=obj2.OperationTime
		s bjson1.OperatorUser=obj1.OperatorUser, bjson2.OperatorUser=obj2.OperatorUser
		
		// 更换推荐顺序
		s temporder1=obj1.RareDiseOrder
		s temporder2=obj2.RareDiseOrder
	
		s obj1.RareDiseOrder=temporder2
		s obj2.RareDiseOrder=temporder1	
		s obj1.OperatorUser=user
		s obj2.OperatorUser=user
		s obj1.OperationTime=$ZDATETIME($H,3)
		s obj2.OperationTime=$ZDATETIME($H,3)
		
		// 获取新数据，写日志
		s json2={}
		s json.ID=obj1.%Id(), json2.ID=obj2.%Id()
		s json.TasksDetailDR=obj1.TasksDetailDR.%Id(), json2.TasksDetailDR=obj2.TasksDetailDR.%Id()
		s json.RareDise=obj1.RareDise, json2.RareDise=obj2.RareDise
		s json.RareDiseID=obj1.RareDiseID, json2.RareDiseID=obj2.RareDiseID
		s json.RareDiseWeight=obj1.RareDiseWeight, json2.RareDiseWeight=obj2.RareDiseWeight
		s json.RareDiseOrder=obj1.RareDiseOrder, json2.RareDiseOrder=obj2.RareDiseOrder
		s json.OperationTime=obj1.OperationTime, json2.OperationTime=obj2.OperationTime
		s json.OperatorUser=obj1.OperatorUser, json2.OperatorUser=obj2.OperatorUser		
		
		TS
		s sc1=obj1.%Save()
		d obj1.%Close()
		
		s sc2=obj2.%Save()
		d obj2.%Close()
		If $$$ISOK(sc1) & $$$ISOK(sc2)
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				s id1=obj1.%Id()
				s id2=obj2.%Id()
				d result.%Set("success",1)
				d result.%Set("ids",rowid)

				//保存修改日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMORareDiseRec","WDT.CDSS.DEMORareDiseRec","疑似罕见病记录表",id1,json.RareDise,"U",json.%ToJSON(),bjson1.%ToJSON())
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMORareDiseRec","WDT.CDSS.DEMORareDiseRec","疑似罕见病记录表",id2,json2.RareDise,"U",json2.%ToJSON(),bjson2.%ToJSON())
			}
			else
			{
				//更新任务集详情失败，回滚修改推荐顺序操作
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存疑似罕见病失败！原因如下：<br>"+tasksdetailre.errorinfo)
			}
		}
		else
		{
			Tro
			d result.%Set("success",0)
			s errorinfo=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			d result.%Set("errorinfo",errorinfo)
			
			//仅保存一条错误日志
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","SaveData",json.%ToJSON())
			
   	    	s ^ERRORLOGINFO(logid)=errorinfo
		}
	}
	// 新增数据
	else
	{
		s flag=0
		s ids=""
		
		TStart
		
		s data=[].%FromJSON(RareDiseInfo)
		s length=data.%Size()
		
		for reps=0:1:length-1
		{
			s jsonobj={}.%FromJSON(data.%Get(reps))
			
			if (jsonobj'="")
			{
				s obj=##class(WDT.CDSS.DEMORareDiseRec).%New()	// 疾病
			
				s diseDetail=jsonobj.DiseaseDetail.%ToJSON()	// 诊断详情信息
				d obj.TasksDetailDRSetObjectId(TasksDetailID)
				s json.TasksDetailDR=TasksDetailID
				s obj.RareDise=jsonobj.DiseaseName, json.RareDise=jsonobj.DiseaseName		//诊断名称
				s obj.RareDiseID=jsonobj.DiseaseID, json.RareDiseID=jsonobj.DiseaseID		//诊断ID
				s obj.RareDiseOrder=reps-1, json.RareDiseOrder=reps-1						//推荐顺序
				s obj.RareDiseWeight=jsonobj.Weight, json.RareDiseWeight=jsonobj.Weight	//诊断权重
				s obj.OperatorUser=user, json.OperatorUser=user										//操作人员
				s obj.OperationTime=$ZDATETIME($H,3), json.OperationTime=$ZDATETIME($H,3)			//操作时间
				
		        s sc=obj.%Save()
		        d obj.%Close()
		        If $$$ISOK(sc)
		        {
			        s id=obj.%Id()
		            if (ids="")
		            {
			            s ids=id
		            }
		            else
		            {
			            s ids=ids_"^"_id
		            }
		            
		            // 调用保存【疑似罕见病记录详情表】数据
		            s savedisedetailre=##class(web.CDSS.Demo.DEMORDRDetail).SaveData("", diseDetail, id)
		            s savedisedetailre={}.%FromJSON(savedisedetailre)
		            if ('savedisedetailre.success)
		            {
			            s flag=1
			            d result.%Set("errorinfo","保存疑似罕见病失败！原因如下：<br>"_savedisedetailre.errorinfo)
			            Quit
		            }
		        }
		        else
		        {
			        s flag=1
					d result.%Set("errorinfo",##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
					
					s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","SaveData",jsonobj.%ToJSON())
		   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			        Quit
		        }
			}			
	        else
			{
				s flag=1
				d result.%Set("errorinfo","保存疑似诊断记录失败，原因如下：<br>传入空")
				Quit
			}
		}
		if (flag=1)
		{
			TRO
			d result.%Set("success",0)
		}
		else
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				d result.%Set("success",1)
				d result.%Set("ids",ids)
			}
			else
			{
				//更新任务集详情失败，回滚保存推荐诊断
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存疑似罕见病失败！原因如下：<br>"+tasksdetailre.errorinfo)
			}
		}		
	}
	q result.%ToJSON()
SaveERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","SaveData",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存疑似罕见病失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2022-02-28
/// Description:	删除罕见病数据、调用删除罕见病详情的入口
/// Table:			WDT_CDSS.DEMORareDiseRec
/// Input:			id 罕见病记录ID，tasksdetailid 病历任务集详情ID, opuser 操作人员
/// Output:			json串 success 成功标志，id 记录ID，errorinfo 错误信息
/// Return:			成功返回 {"success":1,"id":id}，失败返回{"success":0,"errorinfo":"错误信息"}
/// Others:			w ##class(web.CDSS.Demo.DEMORareDiseRec).DeleteData("","2","yjh")
ClassMethod DeleteData(id As %String = "", tasksdetailid As %String = "", opuser As %String = "") As %String
{
	s $zt="ERROE"
	s json={"ID":"","TasksDetailDR":"","RareDise":"","RareDiseID":"","RareDiseWeight":"","RareDiseOrder":"","OperatorUser":"","OperationTime":""}
    s result={"success":0}
    s user=""
    s ids=""
    
    if (opuser'="")
    {
	    s user=opuser
    }
    else
    {
	    s sessionuser=$g(%session.Data("LOGON.USERNAME"))
	    if (sessionuser'="")
	    {
		    s user=sessionuser
	    }
    }
    //s user="yjh"
    
    // id空，tasksdetailid不为空，说明正在批量删除
    if ((id="") & (tasksdetailid'=""))
    {
	    s flag=0
    	s ID=0
    	
    	TS
    	for
	    {	    
		    s ID=$o(^WDT.CDSS.DEMORareDiseRecI("TasksDetailIndex",tasksdetailid,ID))
		    q:ID=""
		    
			s obj=##class(WDT.CDSS.DEMORareDiseRec).%OpenId(ID)
			if (obj'="")
			{
				//先删除关联的诊断详情
			    s delDetailRS=##class(web.CDSS.Demo.DEMORDRDetail).DeleteData(ID)
			    s delDetailRS={}.%FromJSON(delDetailRS)
			    if ('delDetailRS.success)
			    {
				    s flag=1
				    s result.errorinfo="删除罕见病记录失败，原因如下：<br>"_delDetailRS.errorinfo
				    Quit
			    }
			    else
			    {					
					s sc=##class(WDT.CDSS.DEMORareDiseRec).%DeleteId(ID)
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
				    }
				    else
				    {
					    //删除失败，备份数据，写错误日志
					    s json.ID=ID
						s json.TasksDetailDR=obj.TasksDetailDR.%Id()
						s json.RareDise=obj.RareDise
						s json.RareDiseID=obj.RareDiseID
						s json.RareDiseWeight=obj.RareDiseWeight
						s json.RareDiseOrder=obj.RareDiseOrder
						s json.OperationTime=obj.OperationTime
						s json.OperatorUser=obj.OperatorUser

					    s flag=1
				        s result.errorinfo="删除罕见病记录失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
				        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","DeleteData",json.%ToJSON())
				        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				        Quit
				    }
			    }
			}
		    else
		    {
			    continue
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
    // 单独删除某个疑似诊断记录
    else
    {
	    s obj=##class(WDT.CDSS.DEMORareDiseRec).%OpenId(id)
	    	    
	    if obj'=""
	    {
		    // 备份数据，写日志
		    s json.ID=id
			s json.TasksDetailDR=obj.TasksDetailDR.%Id()
			s json.RareDise=obj.RareDise
			s json.RareDiseID=obj.RareDiseID
			s json.RareDiseWeight=obj.RareDiseWeight
			s json.RareDiseOrder=obj.RareDiseOrder
			s json.OperationTime=obj.OperationTime
			s json.OperatorUser=obj.OperatorUser

			s flag=0
		    Tstart		    
		    
		    // 先删除其诊断因子
		    s delDetailRS=##class(web.CDSS.Demo.DEMORDRDetail).DeleteData(id)
		    s delDetailRS={}.%FromJSON(delDetailRS)
		    if (delDetailRS.success)
		    {
			    // 再删除疑似罕见病
			    s sc=##class(WDT.CDSS.DEMORareDiseRec).%DeleteId(id)
			    if $$$ISOK(sc)
			    {
				    // 更新病历任务集详情的操作状态、时间、人员
				    s re=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(tasksdetailid,"","",user)
				    s re={}.%FromJSON(re)
				    if (re.success)
				    {					    
					    //保存删除日志
						d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMORareDiseRec","WDT.CDSS.DEMORareDiseRec","疑似罕见病记录表",id,json.RareDise,"D",json.%ToJSON())
				    }
				    else
				    {
					    s flag=1
					    s result.errorinfo="删除罕见病记录失败，原因如下：<br>"_re.errorinfo
				    }
			    }
			    else
			    {
				    s flag=1
				    s result.errorinfo="删除罕见病记录失败，原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
			        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","DeleteData",json.%ToJSON())
			        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			    }		        		        
		    }
		    else 
		    {
		        s flag=1
			    s result.errorinfo="删除罕见病记录失败，原因如下：<br>"_delDetailRS.errorinfo
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
			    s result.id=id
		    }
	    }
	    else
	    {
		    s result.success=0
		    s result.errorinfo="删除罕见病记录失败，原因如下：<br>ID为"_id_"的数据不存在！"
	    }
    }    
    q result.%ToJSON()
    
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录表","web.CDSS.Demo.DEMORareDiseRec","DeleteData",json.%ToJSON())
 	s ^ERRORLOGINFO(logid)=$ze 	    
 	s result.success=0
	s result.errorinfo="删除罕见病记录失败，原因如下：<br>ERROE保存失败！"
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-28
/// Description:   查询【疑似罕见病记录表】
/// Table：        WDT_CDSS.DEMORareDiseRec, WDT_CDSS.DEMORDRDetail
/// Input：        rowid 疑似罕见病记录ID，tasksdetailID 病历任务集详情表ID
/// Return：       返回疑似罕见病记录，再加上记录详情表的诊断信息
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMORareDiseRec","GetList", "", "")
Query GetList(rowid As %String, tasksdetailID As %String) As %Query(ROWSPEC = "ID,TasksDetailDR,RareDise,RareDiseID,RareDiseWeight,Factor,RareDiseOrder,OperatorUser,OperationTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tasksdetailID As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
        
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        
        s TasksDetailDR=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),2) // 病历任务集详情表DR
                
        s RareDise=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),3) // 推荐疑似诊断名称
        s RareDiseID=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),4)	// 推荐疑似诊断ID
        s RareDiseWeight=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),5)	// 推荐疑似诊断权重
        s RareDiseOrder=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),6)	// 推荐疑似诊断顺序
        
        s OperatorUser=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),7)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),8)	// 操作时间

        d OutputRow
    }
    else
    {
	    s order=""
	    for
	    {
		    s order=$o(^WDT.CDSS.DEMORareDiseRecI("OrderIndex", tasksdetailID, order))
		    q:order=""
		    s ID=$o(^WDT.CDSS.DEMORareDiseRecI("OrderIndex", tasksdetailID, order, 0))
		    
		    s TasksDetailDR=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),2) // 病历任务集详情表DR
		    
	    	s RareDise=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),3) // 推荐疑似诊断名称
	        s RareDiseID=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),4)	// 推荐疑似诊断ID
	        s RareDiseWeight=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),5)	// 推荐疑似诊断权重
	        
	        s Factor=""	// 从【记录详情表】获取所有的诊断因子
	        
	        s RDRDetailID=0	//疑似诊断测评记录详情表ID
	        for
	        {
		        s RDRDetailID=$o(^WDT.CDSS.DEMORDRDetailI("RareDiseRecIndex",ID,RDRDetailID))
		        q:RDRDetailID=""
		        
		        s Factor=Factor_"，"_$lg($g(^WDT.CDSS.DEMORDRDetailD(RDRDetailID)),3)
	        }
	        s Factor=$EXTRACT(Factor,2,*)	//从第2个位置取字符串
	        
	        s RareDiseOrder=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),6)	// 推荐疑似诊断顺序
	        
	        s OperatorUser=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),7)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.DEMORareDiseRecD(ID)),8)	// 操作时间
	        d OutputRow
	    }
		
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,TasksDetailDR,RareDise,RareDiseID,RareDiseWeight,Factor,RareDiseOrder,OperatorUser,OperationTime)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

}
