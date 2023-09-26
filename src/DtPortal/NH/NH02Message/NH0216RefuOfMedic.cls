/// 名称:DtPortal.NH.NH02Message.NH0216RefuOfMedic
/// 描述:护士长事务性提示拒发药
/// 编写者：bmz
/// 编写日期: 2014-12-19
Class DtPortal.NH.NH02Message.NH0216RefuOfMedic Extends %RegisteredObject [ ProcedureBlock ]
{

///  Creator：	bmz
/// CreatDate： 2014-12-08
/// Description: 查询护士长事务性提示拒收发药
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.16.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0216RefuOfMedic","NH021601","2156","")
Query NH021601(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,TDate:%String,TTime:%String,TUser:%String,TWard:%String,TQty:%String,TUom:%String,TDesc:%String,TRefuseReason:%String,TPrescno:%String,RefuseDept:%String")
{
}

ClassMethod NH021601Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	set days=##Class(DtPortal.Common.PublicService).getValueByCode("REFUOFMEDICDAYS")
	
	Set obj=##class(%ResultSet).%New("web.DHCSTDRUGREFUSE:DrugRefuse")
	d obj.Execute(+$h-days,+$h,"",wardId,"","","","")    //据发药按照配置天数查询
	For  Quit:'obj.Next()  Do
	.s TDate=obj.Data("TDate")  //拒绝日期  
	.s TTime=obj.Data("TTime")		//拒绝时间
	.s TUser=obj.Data("TUser")  //拒绝用户
	.s TWard=obj.Data("TWard")		//病区
	.s TQty=obj.Data("TQty")  //数量
	.s TUom=obj.Data("TUom") //单位
	.s TDesc=obj.Data("TDesc")  //医嘱描述
	.s TRefuseReason=obj.Data("TRefuseReason")  //拒绝原因
	.s TPrescno=obj.Data("TPrescno")  //处方号
	.s RefuseDept=""    //拒绝科室 
	.s RefuseDeptId=obj.Data("TRecLocId") 
	.i +RefuseDeptId'=0 s RefuseDept=$p(^CTLOC(RefuseDeptId),"^",2)
	.i RefuseDept["-" s RefuseDept=$p(RefuseDept,"-",2)
	.s regNo=obj.Data("TRegNo")		//登记号
	.//根据登记号获取患者基本信息
	.//select * from pa_adm where PAADM_PAPMI_DR->papmi_no='09330588'--17783656
	.//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	.s papatmasId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	.q:papatmasId=""
	.s PAAdm=$o(^PAPERdr(papatmasId,"ADM","I",""),-1)
	.q:PAAdm=""
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	.s bedCode=$p(patInfoStr,"^",1)
	.s name=$p(patInfoStr,"^",2)
	.s sex=$p(patInfoStr,"^",3)
	.s age=$p(patInfoStr,"^",4)
	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	.s regNo=$p(patInfoStr,"^",7)    //登记号
	.s docDesc=$p(patInfoStr,"^",11)
	.s nurseDesc=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(PAAdm)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
	.d RefuOfMedic
	
	
	
  	q $$$OK
RefuOfMedic
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,TDate,TTime,TUser,TWard,TQty,TUom,TDesc,TRefuseReason,TPrescno,RefuseDept)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
