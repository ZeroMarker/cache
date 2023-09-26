Class web.CDSS.Demo.DEMORDRDetail Extends %RegisteredObject
{

/// Creator:		杨继鸿
/// CreatDate:		2022-02-25
/// Description:	保存【疑似罕见病记录详情表】数据
/// Table:			WDT_CDSS.DEMORDRDetail
/// Input:			rowid 疑似罕见病记录详情表ID, RDRDetailInfo 疑似罕见病诊断因子信息, RareDiseRecID 疑似罕见病记录表ID, TasksDetailID 病历任务集详情表ID
/// Output:			result={"success":0,"id"/"ids":id,"errorinfo":"错误信息"}
/// Return:			返回保存信息，success（成功与否0失败、1成功）；id/ids ID串；errorinfo 错误信息
/// Others:			d ##class(web.CDSS.Demo.DEMORDRDetail).SaveData("","{""就诊科室：呼吸科"": ""常见科室：胸外科,呼吸科,肿瘤科"", ""胸腔积液"": ""等级三(实体词--现病史)(以‘’收入院)""}","108")
/// d ##class(web.CDSS.Demo.DEMORDRDetail).SaveData("75","{""NLPSource"":""测试""}","","3")
ClassMethod SaveData(rowid As %String, RDRDetailInfo, RareDiseRecID As %String, TasksDetailID As %String) As %String
{
	s $zt="ERROE"
	s result={}
	s ids=""	//疑似罕见病记录详情ID串
	
	// 疑似罕见病记录详情JSON对象
	s json={"ID":"","RareDiseRecDR":"","Factor":"","FactorType":"","NLPSource":"","OperatorUser":"","OperationTime":""}
	s json.RareDiseRecDR=RareDiseRecID	// 指向疑似罕见病记录ID
	
	s user=$g(%session.Data("LOGON.USERNAME"))
	//s user="yjh"
	
	// 修改数据
	if (rowid'="")
	{		
		s factorObj={}.%FromJSON(RDRDetailInfo)
		s obj=##class(WDT.CDSS.DEMORDRDetail).%OpenId(rowid)	
	
		s json.ID=obj.RareDiseRecDR.%Id()
		s json.Factor=obj.Factor
		s json.FactorType=obj.FactorType
		s json.NLPSource=obj.NLPSource
	
		s obj.NLPSource=factorObj.NLPSource
		s obj.OperatorUser=user
		s obj.OperationTime=$ZDATETIME($H,3)
		
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			// 更新任务集详情表的状态，和操作时间		
			s tasksdetailre=##class(web.CDSS.Demo.DEMOTasks).SaveTasksDetail(TasksDetailID,"","",user)
			s tasksdetailre={}.%FromJSON(tasksdetailre)
			if (tasksdetailre.success)
			{
				TC
				d result.%Set("success",1)
				d result.%Set("id",rowid)
				//保存修改日志
				d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("WDT_CDSS.DEMOSDRDetail","WDT.CDSS.DEMORDRDetail","疑似罕见病记录详情表",rowid,json.Factor,"U",RDRDetailInfo,json.%ToJSON())
			}
			else
			{
				//更新任务集详情失败，回滚保存NLP信息
				TRO
				d result.%Set("success",0)
				d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_tasksdetailre.errorinfo)
			}
		}
		else
		{
			Tro
			d result.%Set("success",0)
			d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
			
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录详情表","web.CDSS.Demo.DEMORDRDetail","SaveData",RDRDetailInfo)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s flag=0
		TStart
		s idenObj={}.%FromJSON(RDRDetailInfo)
		s iter=idenObj.%GetIterator()
		while(iter.%GetNext(.key,.value))
		{
			s json.Factor=key	// 诊断因子名称
			s json.FactorType=value	// 诊断因子种类
			s obj=##class(WDT.CDSS.DEMORDRDetail).%New()
			
			d obj.RareDiseRecDRSetObjectId(RareDiseRecID)
			s obj.Factor=key
			s obj.FactorType=value
			s obj.OperatorUser=user	//操作人员
			s obj.OperationTime=$ZDATETIME($H,3)	//操作时间
			
	        s sc=obj.%Save()
	        d obj.%Close()
	        If $$$ISOK(sc)
	        {
	            s id = obj.%Id()	// 评测记录表ID
	            if (ids="")
	            {
		            s ids=id
	            }
	            else
	            {
		            s ids=ids_"^"_id
	            }
	        }
	        else
	        {
		        s flag=1
				d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc))
		        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录详情表","web.CDSS.Demo.DEMORDRDetail","SaveData",json.%ToJSON())
	       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		        quit
	        }
		}
		if (flag=1)
		{
			TRO
			d result.%Set("success",0)
		}
		else
		{
			TC
			d result.%Set("success",1)
			d result.%Set("ids",ids)
		}
	}
	q result.%ToJSON()
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录详情表","web.CDSS.Demo.DEMORDRDetail","SaveData",RDRDetailInfo)
 	s ^ERRORLOGINFO(logid)=$ze 
	d result.%Set("success",0)
	d result.%Set("errorinfo","保存诊断因子失败！原因如下：<br>ERROR保存失败！")
    q result.%ToJSON()
}

/// Creator:		杨继鸿
/// CreatDate:		2022-02-28
/// Description:	删除诊断因子数据
/// Table:			WDT_CDSS.DEMORDRDetail
/// Input:			rareDiseRecID 疑似罕见病记录表ID
/// Output:			json串 success 成功标志，ids 删除的诊断因子ID串，errorinfo 错误信息
/// Return:			成功返回 {"success":1,"ids":"id^id^id"},失败返回 {"success":0,"errorinfo":"错误信息"}
/// Others:			d ##class(web.CDSS.Demo.DEMORDRDetail).DeleteData("1")
ClassMethod DeleteData(rareDiseRecID As %String) As %String
{
	s $zt="DelSDRDetailERROE"
    s result={}
    s ids=""
    
    s flag=0
    s id=0
    TS
    for
    {	    
	    s id=$o(^WDT.CDSS.DEMORDRDetailI("RareDiseRecIndex",rareDiseRecID,id))
	    q:id=""
	    
		s obj=##class(WDT.CDSS.DEMORDRDetail).%OpenId(id)
		if (obj'="")
		{
			d obj.%Close()
	    	k obj
		   	s sc=##class(WDT.CDSS.DEMORDRDetail).%DeleteId(id)
		    if $$$ISOK(sc)
		    {
			    if (ids="")
			    {
					s ids=id
			    }
			    else
			    {
				    s ids=ids_"^"_id
			    }
		    }
		    else 
		    {
			    s flag=1
			    s result.success=0
		        s result.errorinfo="删除诊断因子失败！原因如下：<br>"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	//返回错误信息
		        s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似罕见病记录详情表","web.CDSS.Demo.DEMORDRDetail","DeleteData",rareDiseRecID)
		        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		        Quit
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
    }
    else
    {
	    TC
	    s result.success=1
	    s result.ids=ids
    }
    q result.%ToJSON()
    
DelSDRDetailERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("疑似诊断测评记录详情表","web.CDSS.Demo.DEMORDRDetail","DeleteData",rareDiseRecID)
 	s ^ERRORLOGINFO(logid)=$ze
 	d result.%Set("success", 0)
 	d result.%Set("errorinfo", "删除诊断因子失败，原因如下：<br>ERROE删除失败！")
    q result.%ToJSON()
}

/// Creator：      杨继鸿
/// CreatDate：    2022-02-28
/// Description:   查询【疑似罕见病记录详情表】
/// Table：        WDT_CDSS.DEMORDRDetail
/// Input：        rowid,rareDiseRecID
/// Output：       ID,RareDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight
/// Return：       与疑似诊断记录关联的诊断因子数据
/// Others：       d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DEMORDRDetail","GetList","","13") 
Query GetList(rowid As %String, rareDiseRecID As %String) As %Query(ROWSPEC = "ID,RareDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, rareDiseRecID As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
        
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        
        s RareDiseRecDR=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),2) // 病历任务集详情表DR
                
        s Factor=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),3) // 推荐疑似诊断名称
        s FactorType=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),4)	// 推荐疑似诊断ID
        
        s NLPSource=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),5)	// 推荐疑似诊断ID
        
        s OperatorUser=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),6)	// 操作人员
        s OperationTime=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),7)	// 操作时间
        
        s FactorWeight=##class(web.CDSS.Demo.DEMOTasks).GetFactorWeight(FactorType)	//诊断权重

        d OutputRow
    }
    else
    {
		s ID=0
		for 
		{
			s ID=$o(^WDT.CDSS.DEMORDRDetailI("RareDiseRecIndex",rareDiseRecID,ID))
			q:ID=""	
			                
			s RareDiseRecDR=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),2) // 病历任务集详情表DR
	        s Factor=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),3) // 推荐疑似诊断名称
	        s FactorType=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),4)	// 推荐疑似诊断ID
	        s NLPSource=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),5)	// 推荐疑似诊断ID
	        s OperatorUser=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),6)	// 操作人员
	        s OperationTime=$lg($g(^WDT.CDSS.DEMORDRDetailD(ID)),7)	// 操作时间
	        s FactorWeight=##class(web.CDSS.Demo.DEMOTasks).GetFactorWeight(FactorType)	//诊断权重	        
	        
	        d OutputRow
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,RareDiseRecDR,Factor,FactorType,NLPSource,OperatorUser,OperationTime,FactorWeight)
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
