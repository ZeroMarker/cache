/// Description: 死亡医嘱数据维护
/// Creator: 丁亚男
/// Date: 2021-2-25
Class web.CDSS.Demo.DeathOrders Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-2-25
/// Description:获得死亡医嘱内容
/// Table: WDT.CDSS.DEMODeathOrders
/// Input: PatDR 患者基础信息表RowID
/// Return:返回所有死亡医嘱表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.DeathOrders","GetList",182,"")
Query GetList(PatDR As %String, desc As %String) As %Query(ROWSPEC = "RowId,OrderTime,ExecutionTime,OrderType,OrderContent,Recorder")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, PatDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (PatDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s RowId = 0
	for
	{
		s RowId = $o(^WDT.CDSS.DEMODeathOrdersI("PatIndex",PatDR,RowId)) q:RowId=""
		s OrderTime = $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),3)
		s ExecutionTime= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),4)
		s OrderType= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),5)
		s OrderContent= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),6)
		s DeathName=OrderContent
		s Recorder= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),7)	
			
		if ($ZCONVERT(DeathName,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,OrderTime,ExecutionTime,OrderType,OrderContent,Recorder)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2021-2-25
/// Description:保存死亡医嘱表
/// Table: WDT.CDSS.DEMODeathOrders
/// Input: eobj 死亡医嘱表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.Demo.DeathOrders).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.DeathOrders)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.DEMODeathOrders).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMODeathOrders).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Demo.DeathOrders).%New()
			if $IsObject(obj.PatDR)
			{
			 	s bobj.PatDR = obj.PatDR.%Id()
			}
			s bobj.OrderTime = obj.OrderTime
			s bobj.ExecutionTime = obj.ExecutionTime
			s bobj.OrderType = obj.OrderType
			s bobj.OrderContent = obj.OrderContent
			s bobj.Recorder= obj.Recorder
			
		}
		d:eobj.PatDR'="" obj.PatDRSetObjectId(eobj.PatDR)
		s obj.OrderTime = eobj.OrderTime
		s obj.ExecutionTime = eobj.ExecutionTime
		s obj.OrderType = eobj.OrderType
		s obj.OrderContent = eobj.OrderContent
		s obj.Recorder= eobj.Recorder
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODeathOrders","WDT.CDSS.DEMODeathOrders","死亡医嘱",id,eobj.OrderContent,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODeathOrders","WDT.CDSS.DEMODeathOrders","死亡医嘱",eobj.RowId,eobj.OrderContent,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("死亡医嘱","web.CDSS.Demo.DeathOrders","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("死亡医嘱","web.CDSS.Demo.DeathOrders","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2021-2-25
/// Description:删除死亡医嘱表
/// Table: WDT.CDSS.DEMODeathOrders
/// Input: id 死亡医嘱的id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.DeathOrders).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(WDT.CDSS.DEMODeathOrders).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Demo.DeathOrders).%New()
	if $IsObject(obj.PatDR)
	{
	 	s bobj.PatDR = obj.PatDR.%Id()
	}
	s bobj.OrderTime = obj.OrderTime
	s bobj.ExecutionTime = obj.ExecutionTime
	s bobj.OrderType = obj.OrderType
	s bobj.OrderContent = obj.OrderContent
	s bobj.Recorder= obj.Recorder
	
			
	s sc=##class(WDT.CDSS.DEMODeathOrders).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMODeathOrders","WDT.CDSS.DEMODeathOrders","死亡医嘱",id,bobj.OrderContent,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("死亡医嘱","web.CDSS.Demo.DeathOrders","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator: 丁亚男
/// CreatDate:2021-2-23
/// Description:批量删除死亡医嘱表
/// Table: WDT.CDSS.DEMODeathOrders
/// Input: idstr 死亡医嘱的id串
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.DeathOrders).DeleteData("")
ClassMethod BatchDeleteData(idstr As %String)
{
	s result=""
	// 需要删除的id串
	if (idstr'="")
	{
		Ts
		s idlen=$Length(idstr,"^")
		//保存
		for j=1:1:idlen
		{
		    
		    s DeathOrdersid=$p(idstr,"^",j)
			s resultstr=..DeleteData(DeathOrdersid)
			s:result'="" result=result_","_resultstr
			s:result="" result=resultstr
		}
		
	}
	if (result["false")
	{
		tro
		s result="{success:'false',info:'删除失败！'}"
	}
	else
	{
		tc
		s result= "{success:'true',info:'删除成功！'}"
	}
	
	q result
}

/// Creator:丁亚男
/// CreatDate:2021-2-25
/// Description:通过id获取死亡医嘱内容
/// Table: WDT.CDSS.DEMODeathOrders
/// Input: id 死亡医嘱id
/// Return: 死亡医嘱内容
/// others:w ##class(web.CDSS.Demo.DeathOrders).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.DeathOrders).%New()
	s eobj.RowId= id
	s eobj.PatDR = $LISTGET($G(^WDT.CDSS.DEMODeathOrdersD(id)),2)
	s eobj.OrderTime= $lg($g(^WDT.CDSS.DEMODeathOrdersD(id)),3)
	s eobj.ExecutionTime = $lg($g(^WDT.CDSS.DEMODeathOrdersD(id)),4)
	s eobj.OrderType = $lg($g(^WDT.CDSS.DEMODeathOrdersD(id)),5)
	s eobj.OrderContent= $lg($g(^WDT.CDSS.DEMODeathOrdersD(id)),6)
	s eobj.Recorder= $lg($g(^WDT.CDSS.DEMODeathOrdersD(id)),7)
		
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-05-11
/// Description：获取死亡医嘱及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMODeathOrders
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.DeathOrders).GetJSONData("1")
ClassMethod GetJSONData(PatDR, Ids, Flag) As %String
{
	s ResJSON={}
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	s Name =pobj.Name //患者姓名
	s UserID ="" //医生ID 
	s UserName =$G(%session.Data("LOGON.USERNAME")) //医生姓名
	s DeptCode ="" //科室编码
	s DeptName =pobj.Department //科室名称
	s HospCode ="" //医院编码
	s HospName =pobj.Hospital //医院名称
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	d ResJSON.%Set("Name",Name)
	d ResJSON.%Set("UserID",$g(%session.Data("LOGON.USERID")))
	d ResJSON.%Set("UserName",$g(%session.Data("LOGON.USERNAME")))
	d ResJSON.%Set("DeptCode",$g(%session.Data("LOGON.CTLOCID")))
	d ResJSON.%Set("DeptName",$g(%session.Data("LOGON.CTLOCDESC")))
	d ResJSON.%Set("HospCode",HospCode)
	d ResJSON.%Set("HospName",HospName)
	
	s PatientInfo={}
	s Sex=pobj.Sex //性别
	s Gender="2"
	s:Sex="女" Gender="0"
	s:Sex="男" Gender="1"
	s BirthDate=pobj.Birthday //出生日期
	s PregnancyStatus="" //妊娠状态
	d PatientInfo.%Set("Gender",Gender)
	d PatientInfo.%Set("BirthDate",BirthDate)
	d PatientInfo.%Set("PregnancyStatus",PregnancyStatus)
	d ResJSON.%Set("PatientInfo",PatientInfo)

	s OrderEntry=[]
	s IdLen=$Length(Ids,"^")
	for i=1:1:IdLen{
		s RowId=$p(Ids,"^",i)
		s OrderTime= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),3) // 医嘱时间
		s PriorType= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),5)
		s:PriorType="长期医嘱" PriorType="long"
		s:PriorType="临时医嘱" PriorType="short"
		s OrderContent= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),6) // 医嘱内容
		s Recorder= $lg($g(^WDT.CDSS.DEMODeathOrdersD(RowId)),7) // 录入人员
		s RecorderId=""
		s:Recorder'="" RecorderId=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Recorder),0))
		s OrderJson={}
		d OrderJson.%Set("OrderID",RowId) //医嘱唯一标识
		d OrderJson.%Set("OrderClass",1) //医嘱类型 1住院医嘱
		d OrderJson.%Set("OrderFlag",Flag) //操作类型 1新增/修改 2取消
		d OrderJson.%Set("OrderType",10) //医嘱分类 1 药品 2检查 3 检验 4 手术 5 护理 6 处置 7 膳食 8 会诊 9 麻醉 10其他
		d OrderJson.%Set("PriorType",PriorType) //长期医嘱 long   临时医嘱 short
		d OrderJson.%Set("CreatTime","") //医嘱创建时间 OrderFlag=1时填写
		d OrderJson.%Set("StopTime","") //医嘱作废时间 OrderFlag=1时填写
		d OrderJson.%Set("DoctorId",RecorderId) //医生唯一标识（当前操作者）
		d OrderJson.%Set("DoctorName",Recorder) //医生姓名
		d OrderJson.%Set("CreateDeptCode","") //开立科室代码
		d OrderJson.%Set("CreatDeptName",pobj.Department) //开立科室名称
		d OrderJson.%Set("GroupSequence","1") //医嘱组顺序号
		d OrderJson.%Set("OrderCode","") //医嘱项目代码
		d OrderJson.%Set("OrderContent",OrderContent) //医嘱项目内容
		d OrderJson.%Set("Dosage","") //给药剂量 Ordertype=1时 填写
		d OrderJson.%Set("Unit","") //剂量单位 Ordertype=1时 填写
		d OrderJson.%Set("Frequency","") //频率 Ordertype=1时 填写
		d OrderJson.%Set("Specification","") //规格 Ordertype=1时 填写
		d OrderJson.%Set("Pathway","") //给药方式 Ordertype=1时 填写
		d OrderJson.%Set("Sample","") //样本 如血、尿 Ordertype=3时填写
		d OrderJson.%Set("Position","") //部位（检查部位/手术部位） Ordertype=2或4时 填写
		d OrderJson.%Set("Level","") //手术等级 Ordertype=4时填写
		d OrderJson.%Set("IncisionType","") //切口类型 Ordertype=4时填写
		d OrderJson.%Set("Anesthesia","") //麻醉方式 Ordertype=4时填写
		d OrderJson.%Set("PreoperativeDiagnose","") //术前诊断 Ordertype=4时填写
		d OrderJson.%Set("OperationPosition","") //手术体位 Ordertype=4时填写
		d OrderEntry.%Push(OrderJson)	
	}
	d ResJSON.%Set("OrderEntry",OrderEntry)
	q ResJSON.%ToJSON()
}

}
