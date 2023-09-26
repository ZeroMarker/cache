/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2020-06-04
Class web.DHCBL.MKB.BDPBackLog Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2020-06-04
/// Description：保存修改内容
/// Table：User.BDPBackLog
/// Input：web.Entity.MKB.BDPBackLog 实体类
/// Return：成功返回success:'true'和新增或修改的数据ID；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.BDPBackLog).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.MKB.BDPBackLog) As %String
{
	
	s result = ""
	//Set UpdateDate=$p($h,",",1)       //创建时间日期
    Set UpdateUserDR=%session.Get("LOGON.USERID")         //上传人
	if $IsObject(eobj)
	{
		if (eobj.ID="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.BDPBackLog).%New()
			//s obj.CreateDate = UpdateDate
            d:UpdateUserDR'="" obj.BLCreateUserSetObjectId(UpdateUserDR)
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.BDPBackLog).%OpenId(eobj.ID)
		}

		s obj.BLDetails = eobj.BLDetails
		s obj.BLDesc = eobj.BLDesc
		d:eobj.BLModular'="" obj.BLModularSetObjectId(eobj.BLModular)
		d:eobj.BLModular="" obj.BLModularSetObjectId("")
		d:eobj.BLUser'="" obj.BLUserSetObjectId(eobj.BLUser)
		d:eobj.BLUser="" obj.BLUserSetObjectId("")
		s obj.BLState = 1
		s obj.BLEvaluateHour = eobj.BLEvaluateHour
		s obj.BLWoringHour = eobj.BLWoringHour
		if (eobj.BLPlanStartTime'=""){
			s obj.BLPlanStartTime = $zdh(eobj.BLPlanStartTime,3)
		}else{
			s obj.BLPlanStartTime = ""
		}
		if (eobj.BLPlanEndTime'=""){
			s obj.BLPlanEndTime =  $zdh(eobj.BLPlanEndTime,3)
		}else{
			s obj.BLPlanEndTime = ""
		}
		
		s obj.BLType = eobj.BLType
		s num = 0
		if (eobj.BLType=1){
			s num = ..GetLastCodeNum("CF")
			s num = num + 1
			s obj.BLCode = "CF-"_num
		}elseif(eobj.BLType=2){
			s num = ..GetLastCodeNum("CC")
			s num = num + 1
			s obj.BLCode = "CC-"_num
		}elseif(eobj.BLType=3){
			s num = ..GetLastCodeNum("CS")
			s num = num + 1
			s obj.BLCode = "CS-"_num
		}elseif(eobj.BLType=4){
			s num = ..GetLastCodeNum("CK")
			s num = num + 1
			s obj.BLCode = "CK-"_num
		}elseif(eobj.BLType=5){
			s num = ..GetLastCodeNum("CW")
			s num = num + 1
			s obj.BLCode = "CW-"_num
		}elseif(eobj.BLType=6){
			s num = ..GetLastCodeNum("CO")
			s num = num + 1
			s obj.BLCode = "CO-"_num
		}
		
		s obj.BLSpint = eobj.BLSpint
		s obj.BLNote = eobj.BLNote
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：石萧伟
/// CreatDate: 2020-06-04
/// Description：保存进行状态
/// Table：User.BDPBackLog
/// Input：id,state
/// Other: w ##class(web.DHCBL.MKB.BDPBackLog).SaveState(1,2)
ClassMethod SaveState(id, state) As %String
{
	
	s result = ""
	Set UpdateDate=$p($h,",",1)       //创建时间日期
    Set UpdateUserDR=%session.Get("LOGON.USERID")         
    
	s obj=##class(User.BDPBackLog).%OpenId(id)

	s obj.BLState = state
	if (state=4){
		s obj.BLTestTime = UpdateDate
		d:UpdateUserDR'="" obj.BLTestUserSetObjectId(UpdateUserDR)
	}
	if ((state=2)||(state=3)){
		
		if (state=2){
			s obj.BLStartDate = UpdateDate
		}else{
			s obj.BLEndTime = UpdateDate
		}
		d:UpdateUserDR'="" obj.BLUserSetObjectId(UpdateUserDR)
	}

	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}

	
	q result
}

/// shixiaowei
/// Description：查询
/// Table：User.BDPBackLog
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.BDPBackLog","GetList","","","","","")
Query GetList(module, desc, detail, state, type, user) As %Query(ROWSPEC = "ID,BLModularDesc,BLModular,BLDesc,BLDetails,BLStateDesc,BLState,BLEvaluateHour,BLUserDesc,BLUser,BLTestUser,BLCreateUser,BLWoringHour,BLTypeDesc,BLType,BLSpint,BLStartDate,BLEndTime,BLTestTime,BLNote,BLCode,BLPlanStartTime,BLPlanEndTime")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, module, desc, detail, state, type, user) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	

    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:detail'="" detail=$ZCONVERT(detail,"U") //转换成大写
	s:desc'="" desc=$tr(desc," ","") //过滤空格
	s:detail'="" detail=$tr(detail," ","") //过滤空格
    s ID=0
    for{  
      s ID=$o(^User.BDPBackLogD(ID)) q:ID=""   
      
      s BLModularDesc=$LISTGET($G(^User.BDPBackLogD(ID)),2)
      if (BLModularDesc'=""){
	      s BLModular = $LISTGET($G(^User.BDPModularD(BLModularDesc)),3)
	  }else{
		  s BLModular = ""
	  }
      
      
      s BLDesc=$LISTGET($G(^User.BDPBackLogD(ID)),3)
      
      s BLDetails=$LISTGET($G(^User.BDPBackLogD(ID)),4)
      
      s BLStateDesc=$LISTGET($G(^User.BDPBackLogD(ID)),5)
      s BLState = ""
      if (BLStateDesc = 1)
      {
	  	s BLState = "未开始"
	  }elseif(BLStateDesc = 2)
	  {
		s BLState = "进行中"
	  }elseif(BLStateDesc = 3)
	  {
		s BLState = "已完成"
	  }elseif(BLStateDesc = 4)
	  {
		s BLState = "已测试"
	  }
      
      s BLEvaluateHour=$LISTGET($G(^User.BDPBackLogD(ID)),6)
      
      s BLUserDesc=$LISTGET($G(^User.BDPBackLogD(ID)),7)
      s:BLUserDesc'="" BLUser=$p($g(^SSU("SSUSR",BLUserDesc)),"^",2)
      s:BLUserDesc="" BLUser=""

      
      s BLTestUser=$LISTGET($G(^User.BDPBackLogD(ID)),8)
      s:BLTestUser'="" BLTestUser=$p($g(^SSU("SSUSR",BLTestUser)),"^",2)
      s:BLTestUser="" BLTestUser=""
      
      s BLCreateUser=$LISTGET($G(^User.BDPBackLogD(ID)),9)
      s:BLCreateUser'="" BLCreateUser=$p($g(^SSU("SSUSR",BLCreateUser)),"^",2)
      s:BLCreateUser="" BLCreateUser=""
      
      s BLWoringHour=$LISTGET($G(^User.BDPBackLogD(ID)),10)
      
      s BLTypeDesc=$LISTGET($G(^User.BDPBackLogD(ID)),11)
      s BLType = ""
      if (BLTypeDesc = 1)
      {
	  	s BLType = "全栈"
	  }elseif(BLTypeDesc = 2)
	  {
		s BLType = "客户端"
	  }elseif(BLTypeDesc = 3)
	  {
		s BLType = "服务器端"
	  }elseif(BLTypeDesc = 4)
	  {
		s BLType = "知识整理"
	  }elseif(BLTypeDesc = 5)
	  {
		s BLType = "事物"
	  }elseif(BLTypeDesc = 6)
	  {
		s BLType = "其他"
	  }
	  
      s BLSpint=$LISTGET($G(^User.BDPBackLogD(ID)),12)
      
      s BLStartDate=$LISTGET($G(^User.BDPBackLogD(ID)),13)
      s:BLStartDate'="" BLStartDate=$zd(BLStartDate,3)
      
      s BLEndTime=$LISTGET($G(^User.BDPBackLogD(ID)),14)
      s:BLEndTime'="" BLEndTime=$zd(BLEndTime,3)
      
      s BLTestTime=$LISTGET($G(^User.BDPBackLogD(ID)),15)
      s:BLTestTime'="" BLTestTime=$zd(BLTestTime,3)

	  s BLNote=$LISTGET($G(^User.BDPBackLogD(ID)),16)
	  s BLCode=$LISTGET($G(^User.BDPBackLogD(ID)),17)
	  s BLPlanStartTime=$LISTGET($G(^User.BDPBackLogD(ID)),18)
      s:BLPlanStartTime'="" BLPlanStartTime=$zd(BLPlanStartTime,3)
      
	  s BLPlanEndTime=$LISTGET($G(^User.BDPBackLogD(ID)),19)
      s:BLPlanEndTime'="" BLPlanEndTime=$zd(BLPlanEndTime,3)
      if (($ZCONVERT(BLDesc,"U")[desc)||(desc=""))&(($ZCONVERT(BLDetails,"U")[detail)||(detail=""))&((BLModularDesc=module)||(module=""))&((BLStateDesc=state)||(state=""))&((BLTypeDesc=type)||(type="")&((BLUserDesc=user)||(user="")))
      {
        d OutputNewRow
      }
    }

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(ID,BLModularDesc,BLModular,BLDesc,BLDetails,BLStateDesc,BLState,BLEvaluateHour,BLUserDesc,BLUser,BLTestUser,BLCreateUser,BLWoringHour,BLTypeDesc,BLType,BLSpint,BLStartDate,BLEndTime,BLTestTime,BLNote,BLCode,BLPlanStartTime,BLPlanEndTime)
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
		//if there are no more rows,finish fetching...
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

/// Creator:石萧伟
/// CreatDate:2020-06-05
/// Description:根据id删除
/// Table:User.BDPModular
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.BDPModular).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""

    Tstart

    s sc=##class(User.BDPBackLog).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }

    q result
}

/// 获取不同类型的最大编码
/// w ##class(web.DHCBL.MKB.BDPBackLog).GetLastCodeNum("T")
ClassMethod GetLastCodeNum(type As %String) As %String
{
	s sxw=""
	s code=""
    s n=0
    for {
        s code=$o(^User.BDPBackLogI("CodeIndex",code))
        q:(code="")
        if (code[type){
	        s precode=$e(code,"1","4")
	        s backcode=$e(code,5,*)
	        
	       s sxw(backcode)=""
	    }
    }
   	s maxnum=$o(sxw(""),-1)
   	
    return maxnum
}

/// Creator: 李得原
/// Description：查询每个人的开发详情
/// Table：User.BDPBackLog
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.BDPBackLog","GetDetailList","SP1")
Query GetDetailList(Peroid) As %Query(ROWSPEC = "DeveloperName,TotalTime,CompletedTime,UncompletedTime,ProcessingTasks,CompletedTasks,UnstartTasks,DoneTasks,Peroid,LastLogTime")
{
}

ClassMethod GetDetailListExecute(ByRef qHandle As %Binary, Peroid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s Peroid=$zconvert(Peroid,"U")
	s Peroid=$zstrip(Peroid,"<>W")
	s DeveloperId=""
	for
	{
		s DeveloperId=$o(^User.BDPBackLogI("NameIndex",DeveloperId))    //遍历人员
		q:DeveloperId=""
		s DeveloperName=$p($g(^SSU("SSUSR",DeveloperId)),"^",2)
		if DeveloperName=""
		{
			s DeveloperName="未分配"
		}
		s TotalTime=0   //总工时
		s CompletedTime=0 //已完成时间
		s UncompletedTime=0   //未完成时间
		s ProcessingTasks=0  //进行中的任务
		s CompletedTasks=0    //已完成任务
		s UnstartTasks=0   //未开始任务
		s DoneTasks=0   //已测试任务
		s LastLogTime=""
		s DeveloperRowid=0
		for
		{
			s DeveloperRowid=$o(^User.BDPBackLogI("NameIndex",DeveloperId,DeveloperRowid))  //人员任务对应的rowid
			q:DeveloperRowid=""
			s BLModular=$lg($g(^User.BDPBackLogD(DeveloperRowid)),2)   //模块名
			s BLDesc=$lg($g(^User.BDPBackLogD(DeveloperRowid)),3)   //任务描述
			s BLDetails=$lg($g(^User.BDPBackLogD(DeveloperRowid)),4)  // 任务详情
			s BLState=$lg($g(^User.BDPBackLogD(DeveloperRowid)),5)   //任务状态
			s BLEvaluateHour=$lg($g(^User.BDPBackLogD(DeveloperRowid)),6)   //评估工时
			s BLUser=$lg($g(^User.BDPBackLogD(DeveloperRowid)),7)   //负责人
			s BLTestUser=$lg($g(^User.BDPBackLogD(DeveloperRowid)),8)   //测试人
			s BLCreateUser=$lg($g(^User.BDPBackLogD(DeveloperRowid)),9)   //创建人
			s BLWoringHour=$lg($g(^User.BDPBackLogD(DeveloperRowid)),10)   //实际工时
			s BLType=$lg($g(^User.BDPBackLogD(DeveloperRowid)),11)   //任务类型
			s BLSpint=$lg($g(^User.BDPBackLogD(DeveloperRowid)),12)   //所属周期
			continue:Peroid'=BLSpint
			s BLStartDate=$lg($g(^User.BDPBackLogD(DeveloperRowid)),13)   //开始时间
			s BLEndTime=$lg($g(^User.BDPBackLogD(DeveloperRowid)),14)   //完成时间
			s BLTestTime=$lg($g(^User.BDPBackLogD(DeveloperRowid)),15)   //测试时间
			
			s TotalTime=TotalTime+BLEvaluateHour    //总工时
			if ((BLState="3")||(BLState="4"))
			{
				s CompletedTime=CompletedTime+BLEvaluateHour  //已完成工时
			}
			
			if ((BLState="1")||(BLState="2"))     //未完成
			{
				s UncompletedTime=UncompletedTime+BLEvaluateHour
			}
			
			if (BLState="2")    //进行中的任务条数
			{
				s ProcessingTasks=ProcessingTasks+1
			}
			
			if (BLState="3")   //已完成的任务条数
			{
				s CompletedTasks=CompletedTasks+1
			}
			
			if (BLState="1")   //未开始任务条数
			{
				s UnstartTasks=UnstartTasks+1
			}
			
			if (BLState="4")     //已测试任务条数
			{
				s DoneTasks=DoneTasks+1
			}
			
		}
		d OutputNewRow
	}
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(DeveloperName,TotalTime,CompletedTime,UncompletedTime,ProcessingTasks,CompletedTasks,UnstartTasks,DoneTasks,Peroid,LastLogTime)
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
		//if there are no more rows,finish fetching...
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

/// Creator: 李得原
/// Description：返回每个人当前日期之前的未完成工时
/// Table：User.BDPBackLog
/// w ##class(web.DHCBL.MKB.BDPBackLog).GetLineChartData("2020-06-05")
ClassMethod GetLineChartData(Date As %String) As %String
{
	s Result={}
	s Time=$ZDateH(Date,3)
	s DeveloperId=""
	for
	{
		s DeveloperId=$o(^User.BDPBackLogI("NameIndex",DeveloperId))    //遍历人员
		q:DeveloperId=""
		s DeveloperName=$p($g(^SSU("SSUSR",DeveloperId)),"^",2)
		if DeveloperName=""
		{
			s DeveloperName="未分配"
		}
		s TotalTime=0   //总工时
		s CompletedTime=0 //已完成时间
		s UnCompletedTime=0
		s DeveloperRowid=0
		for
		{
			s DeveloperRowid=$o(^User.BDPBackLogI("NameIndex",DeveloperId,DeveloperRowid))  //人员任务对应的rowid
			q:DeveloperRowid=""

			s BLState=$lg($g(^User.BDPBackLogD(DeveloperRowid)),5)   //任务状态
			s BLEvaluateHour=$lg($g(^User.BDPBackLogD(DeveloperRowid)),6)   //评估工时
			s BLUser=$lg($g(^User.BDPBackLogD(DeveloperRowid)),7)   //负责人
			s BLWoringHour=$lg($g(^User.BDPBackLogD(DeveloperRowid)),10)   //实际工时
			s BLSpint=$lg($g(^User.BDPBackLogD(DeveloperRowid)),12)   //所属周期
			s BLStartDate=$lg($g(^User.BDPBackLogD(DeveloperRowid)),13)   //开始时间
			s BLEndTime=$lg($g(^User.BDPBackLogD(DeveloperRowid)),14)   //完成时间
			
			s TotalTime=TotalTime+BLEvaluateHour    //总工时
			if ((BLState="3")||(BLState="4"))
			{
				s CompletedDate=BLEndTime
				continue:CompletedDate>Time
				s CompletedTime=CompletedTime+BLEvaluateHour  //已完成工时
			}
		}
		s UnCompletedTime=TotalTime-CompletedTime   //还剩工时
		d Result.%Set(DeveloperName,UnCompletedTime)
	}
	q Result.%ToJSON()
}

}
