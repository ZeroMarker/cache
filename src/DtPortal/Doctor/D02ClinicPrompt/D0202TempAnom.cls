/// creator:        白明哲
/// date:           2014.7.17
/// description:    临床提示--体温异常数据
Class DtPortal.Doctor.D02ClinicPrompt.D0202TempAnom Extends %RegisteredObject [ Not ProcedureBlock ]
{

//       

/// Creator： 白明哲
/// CreatDate： 2014-7-10
/// Description: 获取体温异常的列表
/// Input：  UserID  
/// Return： 床号、就诊号、姓名、性别、体温摘要
/// 服务代码 D02.02.01	
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0202TempAnom","D020201TempAnomQuery","P","1482")
Query D020201TempAnomQuery(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "bedNum:%String,admId:%String,name:%String,sex:%String,age:%String,tempPreYest:%String,tempYest:%String,tempToday:%String,patId:%String,MedicareNo:%String,AdmReason:%String,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID")
{
}

ClassMethod D020201TempAnomQueryExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	n (qHandle,QueryType,UserCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	
	set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	set DocId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
	
	
	s admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserID,"")
	quit:admPatList="" $$$OK
	for admIndex=1:1:$L(admPatList,"^")
	{
		set PAAdm=$p(admPatList,"^",admIndex)
		continue:PAAdm=""
		s TempData=..GetTemperatureTableData(PAAdm)
		continue:TempData=""
		s TempAnomaliesFlag=$p(TempData,"#",6)
		continue:TempAnomaliesFlag=0
		s bedNum=$p(TempData,"#",2)
		s admId=PAAdm
		s name=$p(TempData,"#",1)
		s sex=$p(TempData,"#",7)
		s tempPreYest=$p(TempData,"#",3)
		s tempYest=$p(TempData,"#",4)
		s tempToday=$p(TempData,"#",5)
		s patId=$p(TempData,"#",8)
		set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
		s age=$p(TempData,"#",9)
		s MedicareNo=$p(TempData,"#",10)
		s AdmReason=$p(TempData,"#",11)
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(PAAdm)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EMREpisodeID=$p(EMRinfo,"^",5)
		
		Do TemperatureTab 
	}
	
	
 
  	q $$$OK
TemperatureTab
    s Data=$lb(bedNum,admId,name,sex,age,tempPreYest,tempYest,tempToday,patId,MedicareNo,AdmReason,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

// w ##class("DtPortal.Doctor.ClinicPrompt.TemperatureAnomalies").GetTemperatureTableData(13)

/// Creator： 白明哲
/// CreatDate： 2014-7-10
/// Description: 获取体温异常的数据
/// Input：  AdmId         
/// Return： 个人体温异常信息Name、bedNum、OBSValueList(+$h-2)、OBSValueList(+$h-1)、OBSValueList(+$h)、flag
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0202TempAnom).GetTemperatureTableData("9")
ClassMethod GetTemperatureTableData(AdmId) As %String
{
	n (AdmId)
	//体温异常的值，从Portal配置取
	s tempValueLow=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATURELOWER")
	s tempValueHigh=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATUREHIGHER")
	i (tempValueLow="")||(tempValueHigh="") d
	.s tempValueLow=36
	.s tempValueHigh=37.5
	
	s MrAdmId=$p($g(^PAADM(AdmId)),"^",61)
	q:MrAdmId="" ""
	s tempCode=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATURECODE")
	q:tempCode="" ""
	s OBSItemDR=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(tempCode),0))  //bmz20181111按配置取值
	q:+OBSItemDR=0 ""
	s flag=0  //判断是否有体温异常标记
	f date=$h-2:1:$h d
	.s OBSValueList(date)=""
	.s childSub=""
	.f  s childSub=$O(^MR(MrAdmId,"OBS",0,"Date",date,OBSItemDR,childSub)) q:childSub=""  d
	..s OBSValue=$p($g(^MR(MrAdmId,"OBS",childSub)),"^",2)
	..s OBSTime=$p($g(^MR(MrAdmId,"OBS",childSub)),"^",4)
	..i ((OBSValue>tempValueHigh)||(OBSValue<tempValueLow))  d
	...s flag=1
	...s OBSValueList(date,OBSTime)=OBSValue
	.//用数组排序---按体温时间
	.s OBSTime1=""  f  s OBSTime1=$O(OBSValueList(date,OBSTime1)) q:OBSTime1=""  d
	..i OBSValueList(date)'="" s OBSValueList(date)=OBSValueList(date)_","_OBSValueList(date,OBSTime1)
	..e  s OBSValueList(date)=OBSValueList(date,OBSTime1)
	i flag=1 d
	.s Papmidr=$P(^PAADM(AdmId),"^",1)
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmId)
	.s bedNum=$p(patInfoStr,"^",1)
	.s Name=$p(patInfoStr,"^",2)
	.s sex=$p(patInfoStr,"^",3)
	.s age=$p(patInfoStr,"^",4)
	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	q $g(Name)_"#"_$g(bedNum)_"#"_$g(OBSValueList(+$h-2))_"#"_$g(OBSValueList(+$h-1))_"#"_$g(OBSValueList(+$h))_"#"_$g(flag)_"#"_$g(sex)_"#"_$g(Papmidr)_"#"_$g(age)_"#"_$g(MedicareNo)_"#"_$g(AdmReason)
}

}
