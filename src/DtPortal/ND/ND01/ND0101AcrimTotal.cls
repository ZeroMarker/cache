/// 类名: DtPortal.ND.ND01.ND0101AcrimTotal
/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询护理部重点关注医嘱相关的患者统计
Class DtPortal.ND.ND01.ND0101AcrimTotal Extends %RegisteredObject
{

/// 获取护理部的各个指标的数据，当前病危、当前病种、特级护理、一级护理 当前在院、待审核不良医嘱
/// creator 赵丽 20190821
/// //d ##class(DtPortal.ND.ND01.ND0101AcrimTotal).ND010100()
ClassMethod ND010100(userCode As %String) As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	//Set $ZT = "ErrSendMessage"
	
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	Set retVal=""
	
	///当前病危
	set criticallyNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0101AcrimTotal:ND010101")
	d obj.Execute("CRITICALLY")
		
	While (obj.Next()) {
		set criticallyNum=criticallyNum++$g(obj.Data("y"))
	}
	
	///当前病重
	set seriouslyNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0101AcrimTotal:ND010101")
	d obj.Execute("SERIOUSLY")
		
	While (obj.Next()) {
		set seriouslyNum=seriouslyNum++$g(obj.Data("y"))
	}
		
	///特级护理
	set criticalcareNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0101AcrimTotal:ND010101")
	d obj.Execute("CRITICALCARE")
		
	While (obj.Next()) {
		set criticalcareNum=criticalcareNum++$g(obj.Data("y"))
	}
	///一级护理
	set firstcareNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0101AcrimTotal:ND010101")
	d obj.Execute("FIRSTCLSCARE")
		
	While (obj.Next()) {
		set firstcareNum=firstcareNum++$g(obj.Data("y"))
	}
	
	////获取当前在院
	
	set patNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0105NowPatList:ND010501")
	d obj.Execute()
	While (obj.Next()) {
		set patNum=patNum++$g(obj.Data("PatNum"))
	}
	
	////待处理不良事件
	set aeNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND08PendingAdverseEvent:ND080101")
	d obj.Execute(userCode)
	While (obj.Next()) {
		set aeNum=aeNum+1
	}
	
	d jsonObj.Put("criticallyNum",criticallyNum)
	d jsonObj.Put("seriouslyNum",seriouslyNum)
	d jsonObj.Put("criticalcareNum",criticalcareNum)
	d jsonObj.Put("firstcareNum",firstcareNum)
	d jsonObj.Put("patNum",patNum)
	d jsonObj.Put("aeNum",aeNum)

	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = "["_jsonObj.Json()_"]"
	;w ret.data,!
	;b ;222222
	Quit ret
		
///ErrSendMessage
	
	Set ret.status = -1
	Set ret.errMSG = $ZE
	Set ret.data = ""

	Quit ret
}

/// 获取护理部的各个指标的数据，一周转科、一周死亡、一周出院
/// creator 赵丽 20190821
/// //d ##class(DtPortal.ND.ND01.ND0101AcrimTotal).ND010000("2018-04-03","2019-04-03")
ClassMethod ND010000(startDate As %String, endDate As %String) As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	//Set $ZT = "ErrSendMessage"
	
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	Set retVal=""
	
	///转科患者
	set tranNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0102TransferList:ND010201")
	d obj.Execute(startDate,endDate)
		
	While (obj.Next()) {
		set tranNum=tranNum++$g(obj.Data("y"))
	}
	
	///出院患者
	set disPatNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0103DischgPat:ND010301")
	d obj.Execute(startDate,endDate)
		
	While (obj.Next()) {
		set disPatNum=disPatNum++$g(obj.Data("y"))
	}
	
	///出院患者
	set deadPatNum=0
	set obj=##class(%ResultSet).%New("DtPortal.ND.ND01.ND0104DeathPat:ND010401")
	d obj.Execute(startDate,endDate)
		
	While (obj.Next()) {
		set deadPatNum=deadPatNum++$g(obj.Data("y"))
	}
	
	
	d jsonObj.Put("tranNum",tranNum)
	d jsonObj.Put("disPatNum",disPatNum)
	d jsonObj.Put("deadPatNum",deadPatNum)
	

	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = "["_jsonObj.Json()_"]"
	w ret.data,!
	
	Quit ret
		
///ErrSendMessage
	
	Set ret.status = -1
	Set ret.errMSG = $ZE
	Set ret.data = ""

	Quit ret
}

/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询全院各病区当前有某类医嘱的患者数量
/// Input：   AcrimCode		医嘱配置code,与his配置中医嘱配置的code一致
/// Return： 
/// 服务编码：ND01.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0101AcrimTotal","ND010101","CRITICALLY")
Query ND010101(AcrimCode As %String) As DtPortal.Query(ROWSPEC = "name:%String,y:%String,WardId:%String")
{
}

ClassMethod ND010101Execute(ByRef qHandle As %Binary, AcrimCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
		
	d ##class(DtPortal.Common.PaadmService).GetArcData(+$h,AcrimCode)
	
	set Ward=""
	for
	{
		set Ward=$o(^||TEMPPortalArcData($j,Ward))
		quit:Ward=""
		set WardDesc=$p(^PAWARD(Ward),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
    	set PatNum=^||TEMPPortalArcData($j,Ward)
    
    	set Data=$lb(WardDesc,PatNum,Ward)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
	k ^||TEMPPortalArcData($j)
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 按病区查询病区某类医嘱明细
/// Input：  WardId 		病区ID
/// 		 ArcimCode     	医嘱code  
/// Return： 
/// 服务编码：ND01.05.03
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0101AcrimTotal","ND010102",5,"SERIOUSLY")
Query ND010102(WardId As %String, AcrimCode As %String) As DtPortal.Query(ROWSPEC = "BedCode:%String,Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,Diag:%String")
{
}

ClassMethod ND010102Execute(ByRef qHandle As %Binary, WardId As %String, AcrimCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	d ##class(DtPortal.Common.PaadmService).GetArcData(+$h,AcrimCode)
	
	set Ward=""
	for
	{
		set Ward=$o(^||TEMPPortalArcData($j,Ward))
		quit:Ward=""
		
		continue:(WardId'="")&&(WardId'=Ward)
		set admID=""
		for
		{
			set admID=$o(^||TEMPPortalArcData($j,Ward,admID))
			quit:admID=""
			
			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admID)
 			set BedCode=$p(patInfoStr,"^",1)
 			set Name=$p(patInfoStr,"^",2)
 			set Sex=$p(patInfoStr,"^",3)
 			set Age=$p(patInfoStr,"^",4)
 			set MedicareNo=$p(patInfoStr,"^",5)   //病案号
 			set AdmReason=$p(patInfoStr,"^",6)    //费用类型
 			set Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admID) //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
			
			set Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag)
		 	set ^||CacheTemp(repid,ind)=Data	
		 	set ind=ind+1
		}
	}
	
 	k ^||TEMPPortalArcData($j)
  	q $$$OK
}

}
