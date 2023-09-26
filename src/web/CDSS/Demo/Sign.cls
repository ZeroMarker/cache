/// Description: 住院Demo-患者体征维护
/// Creator: 高姗姗
/// Date: 2021-12-01
Class web.CDSS.Demo.Sign Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-12-01
/// Description:获得患者体征内容
/// Table: WDT.CDSS.DEMOSign
/// Input: PatDR 患者基础信息表RowID
/// Return:返回所有患者体征表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.Sign","GetList",182,"")
Query GetList(Id As %String, PatDR As %String) As %Query(ROWSPEC = "RowId,BodyTemperature,PhysicalCcooling,BloodPressure,DiastolicBlood,SystolicBlood,Pulse,BreathFeature,HeartRate,OxygenSaturation,Pupil,CornealReflex,Height,Weight,PainScore,DefecateFreq,TotalAmount,UrineOutput,TotalOutput,BarthelScore,MeasureDate,Recorder,OriginalContent")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, Id As %String, PatDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (PatDR="") q ""
 	if (Id'=""){
	 	s RowId=Id
	 	s BodyTemperature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),3)
		s PhysicalCcooling = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),4)
		s BloodPressure = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),5)
		s DiastolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),6)
		s SystolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),7)
		s Pulse = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),8)
		s BreathFeature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),9)
		s HeartRate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),10)
		s OxygenSaturation = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),11)
		s Pupil = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),12)
		s CornealReflex = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),13)
		s Height = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),14)
		s Weight = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),15)
		s PainScore = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),16)
		s DefecateFreq = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),17)
		s TotalAmount = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),18)
		s UrineOutput = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),19)
		s TotalOutput = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),20)
		s BarthelScore = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),21)
		s MeasureDate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),22)
		s Recorder = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),23)
		s OriginalContent = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),24)
		
		d OutputRow
	}else{
		s RowId = 0
		for
		{
			s RowId = $o(^WDT.CDSS.DEMOSignI("PatIndex",PatDR,RowId)) q:RowId=""
			s BodyTemperature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),3)
			s PhysicalCcooling = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),4)
			s BloodPressure = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),5)
			s DiastolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),6)
			s SystolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),7)
			s Pulse = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),8)
			s BreathFeature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),9)
			s HeartRate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),10)
			s OxygenSaturation = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),11)
			s Pupil = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),12)
			s CornealReflex = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),13)
			s Height = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),14)
			s Weight = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),15)
			s PainScore = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),16)
			s DefecateFreq = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),17)
			s TotalAmount = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),18)
			s UrineOutput = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),19)
			s TotalOutput = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),20)
			s BarthelScore = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),21)
			s MeasureDate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),22)
			s Recorder = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),23)
			s OriginalContent = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),24)

			d OutputRow
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,BodyTemperature,PhysicalCcooling,BloodPressure,DiastolicBlood,SystolicBlood,Pulse,BreathFeature,HeartRate,OxygenSaturation,Pupil,CornealReflex,Height,Weight,PainScore,DefecateFreq,TotalAmount,UrineOutput,TotalOutput,BarthelScore,MeasureDate,Recorder,OriginalContent)
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
/// CreatDate:2021-12-01
/// Description:保存患者体征表
/// Table: WDT.CDSS.DEMOSign
/// Input: eobj 患者体征表实体对象
/// Return:成功返回{success:'true',id:'"_id_"'}，失败返回{success:'false',errorinfo:''}
/// others:w ##class(web.CDSS.Demo.Sign).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Demo.Sign)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s:eobj.MeasureDate="" eobj.MeasureDate=$ZDATETIME($h,3)
			s obj=##class(WDT.CDSS.DEMOSign).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(WDT.CDSS.DEMOSign).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.Demo.Sign).%New()
			if $IsObject(obj.PatDR)
			{
			 	s bobj.PatDR = obj.PatDR.%Id()
			}
			s bobj.BodyTemperature = obj.BodyTemperature
			s bobj.PhysicalCcooling = obj.PhysicalCcooling
			s bobj.BloodPressure = obj.BloodPressure
			s bobj.DiastolicBlood = obj.DiastolicBlood
			s bobj.SystolicBlood = obj.SystolicBlood
			s bobj.Pulse = obj.Pulse
			s bobj.BreathFeature = obj.BreathFeature
			s bobj.HeartRate = obj.HeartRate
			s bobj.OxygenSaturation = obj.OxygenSaturation
			s bobj.Pupil = obj.Pupil
			s bobj.CornealReflex = obj.CornealReflex
			s bobj.Height = obj.Height
			s bobj.Weight = obj.Weight
			s bobj.PainScore = obj.PainScore
			s bobj.DefecateFreq = obj.DefecateFreq
			s bobj.TotalAmount = obj.TotalAmount
			s bobj.UrineOutput = obj.UrineOutput
			s bobj.TotalOutput = obj.TotalOutput
			s bobj.BarthelScore = obj.BarthelScore
			s bobj.MeasureDate = obj.MeasureDate
			s bobj.Recorder = obj.Recorder
			s bobj.OriginalContent = obj.OriginalContent
		}
		d:eobj.PatDR'="" obj.PatDRSetObjectId(eobj.PatDR)
		s obj.BodyTemperature = eobj.BodyTemperature
		s obj.PhysicalCcooling = eobj.PhysicalCcooling
		s obj.BloodPressure = eobj.BloodPressure
		s obj.DiastolicBlood = eobj.DiastolicBlood
		s obj.SystolicBlood = eobj.SystolicBlood
		s obj.Pulse = eobj.Pulse
		s obj.BreathFeature = eobj.BreathFeature
		s obj.HeartRate = eobj.HeartRate
		s obj.OxygenSaturation = eobj.OxygenSaturation
		s obj.Pupil = eobj.Pupil
		s obj.CornealReflex = eobj.CornealReflex
		s obj.Height = eobj.Height
		s obj.Weight = eobj.Weight
		s obj.PainScore = eobj.PainScore
		s obj.DefecateFreq = eobj.DefecateFreq
		s obj.TotalAmount = eobj.TotalAmount
		s obj.UrineOutput = eobj.UrineOutput
		s obj.TotalOutput = eobj.TotalOutput
		s obj.BarthelScore = eobj.BarthelScore
		//s obj.MeasureDate = eobj.MeasureDate
		s obj.MeasureDate = $ZDATETIME($HOROLOG,3)
		s obj.Recorder = eobj.Recorder
		s obj.OriginalContent = eobj.OriginalContent
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSign","WDT.CDSS.DEMOSign","患者体征",id,eobj.BodyTemperature,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSign","WDT.CDSS.DEMOSign","患者体征",eobj.RowId,eobj.BodyTemperature,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("患者体征","web.CDSS.Demo.Sign","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("患者体征","web.CDSS.Demo.Sign","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator: 高姗姗
/// CreatDate:2021-12-01
/// Description:删除患者体征表
/// Table: WDT.CDSS.DEMOSign
/// Input: id 患者体征的id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.Sign).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(WDT.CDSS.DEMOSign).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Demo.Sign).%New()
	if $IsObject(obj.PatDR)
	{
	 	s bobj.PatDR = obj.PatDR.%Id()
	}
	s bobj.BodyTemperature = obj.BodyTemperature
	s bobj.PhysicalCcooling = obj.PhysicalCcooling
	s bobj.BloodPressure = obj.BloodPressure
	s bobj.DiastolicBlood = obj.DiastolicBlood
	s bobj.SystolicBlood = obj.SystolicBlood
	s bobj.Pulse = obj.Pulse
	s bobj.BreathFeature = obj.BreathFeature
	s bobj.HeartRate = obj.HeartRate
	s bobj.OxygenSaturation = obj.OxygenSaturation
	s bobj.Pupil = obj.Pupil
	s bobj.CornealReflex = obj.CornealReflex
	s bobj.Height = obj.Height
	s bobj.Weight = obj.Weight
	s bobj.PainScore = obj.PainScore
	s bobj.DefecateFreq = obj.DefecateFreq
	s bobj.TotalAmount = obj.TotalAmount
	s bobj.UrineOutput = obj.UrineOutput
	s bobj.TotalOutput = obj.TotalOutput
	s bobj.BarthelScore = obj.BarthelScore
	s bobj.MeasureDate = obj.MeasureDate
	s bobj.Recorder = obj.Recorder
	s bobj.OriginalContent = obj.OriginalContent

			
	s sc=##class(WDT.CDSS.DEMOSign).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("WDT_CDSS.DEMOSign","WDT.CDSS.DEMOSign","患者体征",id,bobj.BodyTemperature,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("患者体征","web.CDSS.Demo.Sign","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator: 高姗姗
/// CreatDate:2021-12-01
/// Description:批量删除患者体征表
/// Table: WDT.CDSS.DEMOSign
/// Input: idstr 患者体征的id串
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.Demo.Sign).DeleteData("")
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
		    
		    s Signid=$p(idstr,"^",j)
			s resultstr=..DeleteData(Signid)
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
/// CreatDate:2021-12-01
/// Description:通过id获取患者体征内容
/// Table: WDT.CDSS.DEMOSign
/// Input: id 患者体征id
/// Return: 患者体征内容
/// others:w ##class(web.CDSS.Demo.Sign).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Demo.Sign).%New()
	s eobj.RowId= id
	s obj=##class(WDT.CDSS.DEMOSign).%OpenId(id)
	if $IsObject(obj.PatDR)
	{
	 	s eobj.PatDR = obj.PatDR.%Id()
	}
	s eobj.BodyTemperature = obj.BodyTemperature
	s eobj.PhysicalCcooling = obj.PhysicalCcooling
	s eobj.BloodPressure = obj.BloodPressure
	s eobj.DiastolicBlood = obj.DiastolicBlood
	s eobj.SystolicBlood = obj.SystolicBlood
	s eobj.Pulse = obj.Pulse
	s eobj.BreathFeature = obj.BreathFeature
	s eobj.HeartRate = obj.HeartRate
	s eobj.OxygenSaturation = obj.OxygenSaturation
	s eobj.Pupil = obj.Pupil
	s eobj.CornealReflex = obj.CornealReflex
	s eobj.Height = obj.Height
	s eobj.Weight = obj.Weight
	s eobj.PainScore = obj.PainScore
	s eobj.DefecateFreq = obj.DefecateFreq
	s eobj.TotalAmount = obj.TotalAmount
	s eobj.UrineOutput = obj.UrineOutput
	s eobj.TotalOutput = obj.TotalOutput
	s eobj.BarthelScore = obj.BarthelScore
	s eobj.MeasureDate = obj.MeasureDate
	s eobj.Recorder = obj.Recorder
	s eobj.OriginalContent = obj.OriginalContent

	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator：高姗姗
/// CreatDate: 2021-12-07
/// Description：获取生命体征及患者信息JSON，对接CDSS2.0
/// Table：WDT.CDSS.DEMOSign
/// Return:Json
/// Other: w ##class(web.CDSS.Demo.Sign).GetJSONData("18")
ClassMethod GetJSONData(RowId, Flag) As %String
{
	; {"IDNO":"就诊号","PatientDR":"登记号","VisitID":"就诊次","VisitType":"就诊类型","MeasureDate":"测量时间","BodyTemperature":"体温","BloodPressure":"血压","DiastolicBlood":"舒张压","SystolicBlood":"收缩压","Pulse":"脉搏","BreathFeature":"呼吸","HeartRate":"心率","OxygenSaturation":"血氧饱和度","Pupil":"瞳孔","CornealReflex":"角膜反射","Height":"身高","Weight":"体重"}
	s ResJSON={}
	if (Flag="1"){ //新增/修改
		s robj = ##class(WDT.CDSS.DEMOSign).%OpenId(RowId)
		s PatDR=robj.PatDR.%Id()
		s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
		s IDNO =pobj.IDNO //患者主索引
		s PatientDR =pobj.PatientDR //病人标识
		s VisitID =pobj.AdmissionCount //就诊次
		s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
		
		
		s BodyTemperature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),3)
		s BloodPressure = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),5)
		s DiastolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),6)
		s SystolicBlood = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),7)
		s Pulse = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),8)
		s BreathFeature = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),9)
		s HeartRate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),10)
		s OxygenSaturation = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),11)
		s Pupil = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),12)
		s CornealReflex = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),13)
		s Height = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),14)
		s Weight = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),15)	
		s MeasureDate = $lg($g(^WDT.CDSS.DEMOSignD(RowId)),22)
	}
	else{ //删除
		s MeasureDate=""
		s IdLen=$Length(RowId,"^")
		for i=1:1:IdLen{
			s Id=$p(RowId,"^",i)
			s robj = ##class(WDT.CDSS.DEMOSign).%OpenId(Id)
			s PatDR=robj.PatDR.%Id()
			s pobj = ##class(WDT.CDSS.DEMOPatMaster).%OpenId(PatDR)
			s IDNO =pobj.IDNO //患者主索引
			s PatientDR =pobj.PatientDR //病人标识
			s VisitID =pobj.AdmissionCount //就诊次
			s VisitType ="3" //就诊类型 1急诊，2门诊，3住院
			
			
			s BodyTemperature="",BloodPressure="",DiastolicBlood="",SystolicBlood="",Pulse="",BreathFeature="",HeartRate="",OxygenSaturation="",Pupil="",CornealReflex="",Height="",Weight=""	
			s MDate = $lg($g(^WDT.CDSS.DEMOSignD(Id)),22)	
			s:MeasureDate'="" MeasureDate=MeasureDate_","_MDate
			s:MeasureDate="" MeasureDate=MDate
		}
	}
	
	d ResJSON.%Set("IDNO",IDNO)
	d ResJSON.%Set("PatientDR",PatientDR)
	d ResJSON.%Set("VisitID",VisitID)
	d ResJSON.%Set("VisitType",VisitType)
	
	d ResJSON.%Set("MeasureDate",MeasureDate)
	if (Flag="1") //新增/修改
	{
		d ResJSON.%Set("BodyTemperature",BodyTemperature)
		d ResJSON.%Set("BloodPressure",BloodPressure)
		d ResJSON.%Set("DiastolicBlood",DiastolicBlood)
		d ResJSON.%Set("SystolicBlood",SystolicBlood)
		d ResJSON.%Set("Pulse",Pulse)
		d ResJSON.%Set("BreathFeature",BreathFeature)
		d ResJSON.%Set("HeartRate",HeartRate)
		d ResJSON.%Set("OxygenSaturation",OxygenSaturation)
		d ResJSON.%Set("Pupil",Pupil)
		d ResJSON.%Set("CornealReflex",CornealReflex)
		d ResJSON.%Set("Height",Height)
		d ResJSON.%Set("Weight",Weight)
	}
	d ResJSON.%Set("SignFlag",Flag) //1新增/修改 2删除
	q ResJSON.%ToJSON()
}

}
