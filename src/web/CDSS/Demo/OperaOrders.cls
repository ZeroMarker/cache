/// Description: 手术医嘱数据维护
/// Creator: 丁亚男
/// Date: 2021-2-25
Class web.CDSS.Demo.OperaOrders Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-2-25
/// Description:获得手术医嘱内容
/// Table: WDT.CDSS.DEMOOperaOrders
/// Input: PatDR 患者基础信息表RowID
/// Return:返回所有手术医嘱表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.OperaOrders","GetList",182,"")
Query GetList(PatDR As %String, desc As %String) As %Query(ROWSPEC = "RowId,OrderTime,OrderType,OrderContent,OperationName,OperaMethod,OperaDate,Recorder,OperClass,OperLevel,OperAnest,OperIncisionType")
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
		s RowId = $o(^WDT.CDSS.DEMOOperaOrdersI("PatIndex",PatDR,RowId)) q:RowId=""
		s OrderTime = $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),3)
		s OrderType= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),4)
		s OrderContent= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),5)
		s OperationName=OrderContent
		s OperaMethod= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),6)
		s OperaDate= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),7)
		s Recorder= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),8)
		s OperClass= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),10)		//手术类型
		s OperLevel= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),11)		//手术级别
		s OperAnest= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),12)		//麻醉方式
		s OperIncisionType= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),13)	//切口类型
		if ($ZCONVERT(OperationName,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,OrderTime,OrderType,OrderContent,OperationName,OperaMethod,OperaDate,Recorder,OperClass,OperLevel,OperAnest,OperIncisionType)
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
/// Description:保存手术医嘱表
/// Table: WDT.CDSS.DEMOOperaOrders
/// Input: eobj 手术医嘱表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.Demo.OperaOrders).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.OperaOrders)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.DEMOOperaOrders).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMOOperaOrders).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Demo.OperaOrders).%New()
			if $IsObject(obj.PatDR)
			{
			 	s bobj.PatDR = obj.PatDR.%Id()
			}
			s bobj.OrderTime = obj.OrderTime
			s bobj.OrderType = obj.OrderType
			s bobj.OrderContent = obj.OrderContent
			s bobj.OperaMethod = obj.OperaMethod
			s bobj.OperaDate = obj.OperaDate
			s bobj.Recorder= obj.Recorder
			s bobj.OperClass = obj.OperClass
			s bobj.OperLevel = obj.OperLevel
			s bobj.OperAnest = obj.OperAnest
			s bobj.OperIncisionType = obj.OperIncisionType
			
		}
		d:eobj.PatDR'="" obj.PatDRSetObjectId(eobj.PatDR)
		s obj.OrderTime = eobj.OrderTime
		s obj.OrderType = eobj.OrderType
		s obj.OrderContent = eobj.OperationName
		s obj.OperaMethod = eobj.OperaMethod
		s obj.OperaDate = eobj.OperaDate
		s obj.Recorder= eobj.Recorder
		s obj.OperClass = eobj.OperClass
		s obj.OperLevel = eobj.OperLevel
		s obj.OperAnest = eobj.OperAnest
		s obj.OperIncisionType = eobj.OperIncisionType
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaOrders","WDT.CDSS.DEMOOperaOrders","手术医嘱",id,eobj.OrderContent,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaOrders","WDT.CDSS.DEMOOperaOrders","手术医嘱",eobj.RowId,eobj.OrderContent,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术医嘱","web.CDSS.Demo.OperaOrders","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("手术医嘱","web.CDSS.Demo.OperaOrders","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 丁亚男
/// CreatDate:2021-2-25
/// Description:删除手术医嘱表
/// Table: WDT.CDSS.DEMOOperaOrders
/// Input: id 手术医嘱的id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.OperaOrders).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(WDT.CDSS.DEMOOperaOrders).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Demo.OperaOrders).%New()
	if $IsObject(obj.PatDR)
	{
	 	s bobj.PatDR = obj.PatDR.%Id()
	}
	s bobj.OrderTime = obj.OrderTime
	s bobj.OrderType = obj.OrderType
	s bobj.OrderContent = obj.OrderContent
	s bobj.OperaMethod = obj.OperaMethod
	s bobj.OperaDate = obj.OperaDate
	s bobj.Recorder= obj.Recorder
	s bobj.OperClass = obj.OperClass
	s bobj.OperLevel = obj.OperLevel
	s bobj.OperAnest = obj.OperAnest
	s bobj.OperIncisionType = obj.OperIncisionType
	s sc=##class(WDT.CDSS.DEMOOperaOrders).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOOperaOrders","WDT.CDSS.DEMOOperaOrders","手术医嘱",id,bobj.OrderContent,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("手术医嘱","web.CDSS.Demo.OperaOrders","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator: 丁亚男
/// CreatDate:2021-2-23
/// Description:批量删除手术医嘱表
/// Table: WDT.CDSS.DEMOOperaOrders
/// Input: idstr 手术医嘱的id串
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.OperaOrders).DeleteData("")
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
		    
		    s OperaOrdersid=$p(idstr,"^",j)
			s resultstr=..DeleteData(OperaOrdersid)
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
/// Description:通过id获取手术医嘱内容
/// Table: WDT.CDSS.DEMOOperaOrders
/// Input: id 手术医嘱id
/// Return: 手术医嘱内容
/// others:w ##class(web.CDSS.Demo.OperaOrders).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.OperaOrders).%New()
	s eobj.RowId= id
	s eobj.PatDR = $LISTGET($G(^WDT.CDSS.DEMOOperaOrdersD(id)),2)
	s eobj.OrderTime= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),3)
	s eobj.OrderType = $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),4)
	s eobj.OrderContent= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),5)
	s eobj.OperaMethod= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),6)
	s eobj.OperaDate= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),7)	
	s eobj.Recorder= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),8)
	s eobj.OperClass= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),10)		//手术类型
	s eobj.OperLevel= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),11)		//手术级别
	s eobj.OperAnest= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),12)		//麻醉方式
	s eobj.OperIncisionType= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(id)),13)	//切口类型
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-05-11
/// Description：获取手术医嘱及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOOperaOrders
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.OperaOrders).GetJSONData("1")
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
		s OrderTime= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),3) // 医嘱时间
		s PriorType= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),4)
		s:PriorType="长期医嘱" PriorType="Long"
		s:PriorType="临时医嘱" PriorType="Short"
		s OrderContent= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),5) // 医嘱内容
		s OrderContentId=""
		s:OrderContent'="" OrderContentId=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OrderContent,"U"),0))
		s OperaMethod= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),6) // 手术方式
		s Recorder= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),8) // 录入人员
		s OperClass=$lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),10)		//手术类型（急诊、择期）
		
		s OperLevel= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),11)		//手术级别
		s OperAnest= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),12)		//麻醉方式
		s OperIncisionType= $lg($g(^WDT.CDSS.DEMOOperaOrdersD(RowId)),13)	//切口类型
		
		s RecorderId=""
		s:Recorder'="" RecorderId=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Recorder),0))
		s OrderJson={}
		d OrderJson.%Set("OrderID",RowId) //医嘱唯一标识
		d OrderJson.%Set("OrderClass",OperClass) //医嘱类型 1住院医嘱
		d OrderJson.%Set("OrderFlag",Flag) //操作类型 1新增/修改 2取消
		d OrderJson.%Set("OrderType",4) //医嘱分类 1 药品 2检查 3 检验 4 手术 5 护理 6 处置 7 膳食 8 会诊 9 麻醉 10其他
		d OrderJson.%Set("PriorType",PriorType) //长期医嘱 long   临时医嘱 short
		d OrderJson.%Set("CreatTime","") //医嘱创建时间 OrderFlag=1时填写
		d OrderJson.%Set("StopTime","") //医嘱作废时间 OrderFlag=1时填写
		d OrderJson.%Set("DoctorId",RecorderId) //医生唯一标识（当前操作者）
		d OrderJson.%Set("DoctorName",Recorder) //医生姓名
		d OrderJson.%Set("CreateDeptCode","") //开立科室代码
		d OrderJson.%Set("CreatDeptName",pobj.Department) //开立科室名称
		d OrderJson.%Set("GroupSequence","1") //医嘱组顺序号
		d OrderJson.%Set("OrderCode",OrderContentId) //医嘱项目代码
		d OrderJson.%Set("OrderContent",OrderContent) //医嘱项目内容
		d OrderJson.%Set("Dosage","") //给药剂量 Ordertype=1时 填写
		d OrderJson.%Set("Unit","") //剂量单位 Ordertype=1时 填写
		d OrderJson.%Set("Frequency","") //频率 Ordertype=1时 填写
		d OrderJson.%Set("Specification","") //规格 Ordertype=1时 填写
		d OrderJson.%Set("Pathway","") //给药方式 Ordertype=1时 填写
		d OrderJson.%Set("Sample","") //样本 如血、尿 Ordertype=3时填写
		d OrderJson.%Set("Position","") //部位（检查部位/手术部位） Ordertype=2或4时 填写
		d OrderJson.%Set("Level",OperLevel) //手术等级 Ordertype=4时填写
		d OrderJson.%Set("IncisionType",OperIncisionType) //切口类型 Ordertype=4时填写
		d OrderJson.%Set("Anesthesia",OperAnest) //麻醉方式 Ordertype=4时填写
		d OrderJson.%Set("PreoperativeDiagnose","") //术前诊断 Ordertype=4时填写
		d OrderJson.%Set("OperationPosition","") //手术体位 Ordertype=4时填写
		d OrderEntry.%Push(OrderJson)	
	}
	d ResJSON.%Set("OrderEntry",OrderEntry)
	q ResJSON.%ToJSON()
}

}
