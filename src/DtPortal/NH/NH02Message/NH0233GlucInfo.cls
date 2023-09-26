Class DtPortal.NH.NH02Message.NH0233GlucInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称: NH023301
/// 描述: 待退药查询
/// 编写者：bmz
/// 编写日期:2018-12-13
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0233GlucInfo","NH023301","2156","10","1")
Query NH023301(userCode As %String, wardId As %String, type As %String) As DtPortal.Query(ROWSPEC = "BedNo,Name,Sex,Age,MedicareNo,AdmReason,PAPMINo,admDocName,admNurseName,diagnoseDesc,inDay,inDateTime,AdmId,OrdExeRowid,DrugDesc,RetNo,RetQty,Uom,DoseQty,ReqStatusCode,ReqStatus,ReqDate,ReqUserId,ReqUser,RetDate,RetUserId,RetUser") [ SqlProc ]
{
}

ClassMethod NH023301Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String, type As %String) As %Status
{
	new (qHandle,userCode,wardId,type)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	
	q:(wardId="")||(type="") $$$OK
	
	//退药查询天数取配置
	
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("DRUGRETDASYS")
	s days=+days
	s startDate=$zd((+$h-days),3)
	s endDate=$zd(+$h,3)
	//调用药库组query
	set obj=##class(%ResultSet).%New("web.DHCSTINTERFACE:QueryRetInfo")
	d obj.Execute(startDate,endDate,wardId,type)
    f  Quit:'obj.Next()  d
	.set (AdmId,OrdExeRowid,DrugDesc,RetNo,RetQty,Uom,DoseQty,ReqStatusCode,ReqStatus,ReqDate,ReqUserId,ReqUser,RetDate,RetUserId,RetUser)=""
	.set (BedNo,Name,Sex,Age,MedicareNo,AdmReason,PAPMINo,admDocName,admNurseName,diagnoseDesc,inDay,inDateTime)=""
	.s AdmId=obj.Data("AdmId")  //就诊id
	.s OrdExeRowid=obj.Data("OrdExeRowid") 
	.s DrugDesc=obj.Data("DrugDesc")  //药品名称
	.s RetNo=obj.Data("RetNo")  //退药单号
	.s RetQty=obj.Data("RetQty")  //退药数量
	.if RetQty["." s RetQty=$fn(RetQty,"",2)
	.s Uom=obj.Data("Uom")  //药品单位
	.s DoseQty=obj.Data("DoseQty")  //剂量
	.s ReqStatusCode=obj.Data("ReqStatusCode")
	.s ReqStatus=obj.Data("ReqStatus")  //退药状态
	.s ReqDate=obj.Data("ReqDate")  //申请日期
	.s ReqDate=##class(DtPortal.Common.PublicService).dateFormat(ReqDate)
	.s ReqUserId=obj.Data("ReqUserId")
	.s ReqUser=obj.Data("ReqUser")  //申请人
	.s RetDate=obj.Data("RetDate")  //退药日期
	.s RetDate=##class(DtPortal.Common.PublicService).dateFormat(RetDate)
	.s RetUserId=obj.Data("RetUserId")
	.s RetUser=obj.Data("RetUser")  //退药人 
	
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmId)
	.s BedNo=$p(patInfoStr,"^",1)
 	.s Name=$p(patInfoStr,"^",2)
 	.s Sex=$p(patInfoStr,"^",3)
 	.s Age=$p(patInfoStr,"^",4)
 	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
 	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
 	.s PAPMINo=$p(patInfoStr,"^",7)    //登记号
 	.s admDocName=$p(patInfoStr,"^",11)
	.s admNurseName=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmId)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(AdmId)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(AdmId)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
	
	.Do NH023301
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

NH023301
	set Data=$lb(BedNo,Name,Sex,Age,MedicareNo,AdmReason,PAPMINo,admDocName,admNurseName,diagnoseDesc,inDay,inDateTime,AdmId,OrdExeRowid,DrugDesc,RetNo,RetQty,Uom,DoseQty,ReqStatusCode,ReqStatus,ReqDate,ReqUserId,ReqUser,RetDate,RetUserId,RetUser)
 	Set ^||CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
