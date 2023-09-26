/// Description：住院Demo-输血申请表
/// Table：WDT.CDSS.DEMOBloodTrans
Class web.CDSS.Demo.BloodTrans Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-12-07
/// Description:获得输血申请内容
/// Table: WDT.CDSS.DEMOBloodTrans
/// Input: PatDR 患者基础信息表RowID
/// Return:返回所有输血申请表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.BloodTrans","GetList","","30","")
Query GetList(Id As %String, PatDR As %String, desc As %String) As %Query(ROWSPEC = "RowId,BloodTransType,BloodTransTypeRh,BloodTransClass,BloodTransVolume,BloodTransVolumeU,BloodTransSite,BTIndication,BTIndicationValue,BTIndicationValueUnit,BloodTransPurpose,BloodTransTime,Recorder")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id As %String, PatDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (PatDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
 	if (Id'=""){
	 	s RowId=Id
	 	s BloodTransType = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),3)
		s BloodTransTypeRh = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),4)
		s BloodTransClass = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),5)
		s BloodTransVolume = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),6)
		s BloodTransVolumeU = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),7)
		s BloodTransSite = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),8)
		s BTIndication = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),9)
		s BTIndicationValue = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),10)
		s BTIndicationValueUnit = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),11)
		s BloodTransPurpose = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),12)
		s BloodTransTime = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),13)
		s Recorder = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),14)

		d OutputRow
	}else{
		s RowId = 0
		for
		{
			s RowId = $o(^WDT.CDSS.DEMOBloodTransI("PatIndex",PatDR,RowId)) q:RowId=""
			s BloodTransType = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),3)
			s BloodTransTypeRh = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),4)
			s BloodTransClass = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),5)
			s PINYIN=""
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BloodTransClass) 
			s BloodTransVolume = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),6)
			s BloodTransVolumeU = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),7)
			s BloodTransSite = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),8)
			s BTIndication = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),9)
			s BTIndicationValue = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),10)
			s BTIndicationValueUnit = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),11)
			s BloodTransPurpose = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),12)
			s BloodTransTime = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),13)
			s Recorder = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),14)

			if ($ZCONVERT(BloodTransClass,"U")[desc)||(PINYIN[desc)||(desc="")
			{
				d OutputRow
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,BloodTransType,BloodTransTypeRh,BloodTransClass,BloodTransVolume,BloodTransVolumeU,BloodTransSite,BTIndication,BTIndicationValue,BTIndicationValueUnit,BloodTransPurpose,BloodTransTime,Recorder)
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

/// Creator:高姗姗
/// CreatDate:2021-12-07
/// Description:保存输血申请表
/// Table: WDT.CDSS.DEMOBloodTrans
/// Input: eobj 输血申请表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.Demo.BloodTrans).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.BloodTrans)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(WDT.CDSS.DEMOBloodTrans).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMOBloodTrans).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Demo.BloodTrans).%New()
			if $IsObject(obj.PatDR)
			{
			 	s bobj.PatDR = obj.PatDR.%Id()
			}
			s bobj.BloodTransType = obj.BloodTransType
			s bobj.BloodTransTypeRh = obj.BloodTransTypeRh
			s bobj.BloodTransClass = obj.BloodTransClass
			s bobj.BloodTransVolume = obj.BloodTransVolume
			s bobj.BloodTransVolumeU = obj.BloodTransVolumeU
			s bobj.BloodTransSite = obj.BloodTransSite
			s bobj.BTIndication = obj.BTIndication
			s bobj.BTIndicationValue = obj.BTIndicationValue
			s bobj.BTIndicationValueUnit = obj.BTIndicationValueUnit
			s bobj.BloodTransPurpose = obj.BloodTransPurpose
			s bobj.BloodTransTime = obj.BloodTransTime
			s bobj.Recorder = obj.Recorder
			
		}
		d:eobj.PatDR'="" obj.PatDRSetObjectId(eobj.PatDR)
		s obj.BloodTransType = eobj.BloodTransType
		s obj.BloodTransTypeRh = eobj.BloodTransTypeRh
		s obj.BloodTransClass = eobj.BloodTransClass
		s obj.BloodTransVolume = eobj.BloodTransVolume
		s obj.BloodTransVolumeU = eobj.BloodTransVolumeU
		s obj.BloodTransSite = eobj.BloodTransSite
		s obj.BTIndication = eobj.BTIndication
		s obj.BTIndicationValue = eobj.BTIndicationValue
		s obj.BTIndicationValueUnit = eobj.BTIndicationValueUnit
		s obj.BloodTransPurpose = eobj.BloodTransPurpose
		s obj.BloodTransTime = eobj.BloodTransTime
		s obj.Recorder = eobj.Recorder
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOBloodTrans","WDT.CDSS.DEMOBloodTrans","输血申请",id,eobj.BloodTransClass,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOBloodTrans","WDT.CDSS.DEMOBloodTrans","输血申请",eobj.RowId,eobj.BloodTransClass,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血申请","web.CDSS.Demo.BloodTrans","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("输血申请","web.CDSS.Demo.BloodTrans","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 高姗姗
/// CreatDate:2021-12-07
/// Description:删除输血申请表
/// Table: WDT.CDSS.DEMOBloodTrans
/// Input: id 输血申请的id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.BloodTrans).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(WDT.CDSS.DEMOBloodTrans).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Demo.BloodTrans).%New()
	if $IsObject(obj.PatDR)
	{
	 	s bobj.PatDR = obj.PatDR.%Id()
	}
	s bobj.BloodTransType = obj.BloodTransType
	s bobj.BloodTransTypeRh = obj.BloodTransTypeRh
	s bobj.BloodTransClass = obj.BloodTransClass
	s bobj.BloodTransVolume = obj.BloodTransVolume
	s bobj.BloodTransVolumeU = obj.BloodTransVolumeU
	s bobj.BloodTransSite = obj.BloodTransSite
	s bobj.BTIndication = obj.BTIndication
	s bobj.BTIndicationValue = obj.BTIndicationValue
	s bobj.BTIndicationValueUnit = obj.BTIndicationValueUnit
	s bobj.BloodTransPurpose = obj.BloodTransPurpose
	s bobj.BloodTransTime = obj.BloodTransTime
	s bobj.Recorder = obj.Recorder
			
	s sc=##class(WDT.CDSS.DEMOBloodTrans).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOBloodTrans","WDT.CDSS.DEMOBloodTrans","输血申请",id,bobj.BloodTransClass,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("输血申请","web.CDSS.Demo.BloodTrans","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator: 高姗姗
/// CreatDate:2021-2-23
/// Description:批量删除输血申请表
/// Table: WDT.CDSS.DEMOBloodTrans
/// Input: idstr 输血申请的id串
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.BloodTrans).DeleteData("")
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
		    
		    s BloodTransid=$p(idstr,"^",j)
			s resultstr=..DeleteData(BloodTransid)
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

/// Creator:高姗姗
/// CreatDate:2021-12-07
/// Description:通过id获取输血申请内容
/// Table: WDT.CDSS.DEMOBloodTrans
/// Input: id 输血申请id
/// Return: 输血申请内容
/// others:w ##class(web.CDSS.Demo.BloodTrans).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.BloodTrans).%New()
	s eobj.RowId= id
	s obj=##class(WDT.CDSS.DEMOBloodTrans).%OpenId(id)
	if $IsObject(obj.PatDR)
	{
	 	s eobj.PatDR = obj.PatDR.%Id()
	}
	s eobj.BloodTransType = obj.BloodTransType
	s eobj.BloodTransTypeRh = obj.BloodTransTypeRh
	s eobj.BloodTransClass = obj.BloodTransClass
	s eobj.BloodTransVolume = obj.BloodTransVolume
	s eobj.BloodTransVolumeU = obj.BloodTransVolumeU
	s eobj.BloodTransSite = obj.BloodTransSite
	s eobj.BTIndication = obj.BTIndication
	s eobj.BTIndicationValue = obj.BTIndicationValue
	s eobj.BTIndicationValueUnit = obj.BTIndicationValueUnit
	s eobj.BloodTransPurpose = obj.BloodTransPurpose
	s eobj.BloodTransTime = obj.BloodTransTime
	s eobj.Recorder = obj.Recorder

	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-12-08
/// Description：获取输血及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOBloodTrans
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.BloodTrans).GetJSONData("29")
ClassMethod GetJSONData(PatDR) As %String
{
	s ResJSON={}
	s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
	s IDNO =pobj.IDNO //患者主索引
	s PatientDR =pobj.PatientDR //病人标识
	s VisitID =pobj.AdmissionCount //就诊次
	s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)

	s children=[]
	s RowId = 0
	for
	{
		s RowId = $o(^WDT.CDSS.DEMOBloodTransI("PatIndex",PatDR,RowId)) q:RowId=""
		s BloodTransType = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),3)
		s BloodTransTypeRh = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),4)
		s BloodTransClass = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),5)
		s BloodTransVolume = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),6)
		s BloodTransVolumeU = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),7)
		s BloodTransSite = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),8)
		s BTIndication = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),9)
		s BTIndicationValue = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),10)
		s BTIndicationValueUnit = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),11)
		s BloodTransPurpose = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),12)
		s BloodTransTime = $lg($g(^WDT.CDSS.DEMOBloodTransD(RowId)),13)
		
		s BloodJson={}
		d BloodJson.%Set("BloodTransVolume",BloodTransVolume) //输血量
		d BloodJson.%Set("BloodTransVolumeU",BloodTransVolumeU) //输血量单位
		d BloodJson.%Set("BloodTransSite",BloodTransSite) //输血部位
		d BloodJson.%Set("BloodTransType",BloodTransType) //输血血型（ABO血型系统）
		d BloodJson.%Set("BloodTransTypeRh",BloodTransTypeRh) //输血血型（Rh血型系统）
		d BloodJson.%Set("BloodTransClass",BloodTransClass) //输血品名称
		d BloodJson.%Set("BTIndication",BTIndication) //输血指征
		d BloodJson.%Set("BTIndicationValue",BTIndicationValue) //指征值
		d BloodJson.%Set("BTIndicationValueUnit",BTIndicationValueUnit) //指征值单位
		d BloodJson.%Set("PassFlag","0") //同步标记（0为同步，1为新增）

		d children.%Push(BloodJson)	
	}
	d ResJSON.%Set("children",children)
	
	q ResJSON.%ToJSON()
}

}
