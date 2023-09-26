/// 名称:DtPortal.NH.NH02Message.NH0215RejectSpec
/// 描述:护士长事务性提示拒收标本
/// 编写者：bmz
/// 编写日期: 2014-12-08
Class DtPortal.NH.NH02Message.NH0215RejectSpec Extends %RegisteredObject [ Not ProcedureBlock ]
{

///  Creator：	bmz
/// CreatDate： 2014-12-08
/// Description: 查询护士长事务性提示拒收标本---参考web.DHCNurCom 中 LookUpRejectSpec
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.15.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0215RejectSpec","NH021501","059")
Query NH021501(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,arcimDesc:%String,ororiDate:%String,ororiTime:%String,rejectUser:%String,rejectReason:%String,rejectDate:%String,rejectTime:%String,labNo:%String")
{
}

ClassMethod NH021501Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace

 	//$p(^["LabData"]TTAB("SPEC",tempSPECCode),"\",1)
 	s labNo=""
 	f  s labNo=$o(^[LABDATA]DHCRS(labNo)) q:labNo=""  d
 	    .s cttsCode=""
 	    .f  s cttsCode=$o(^[LABDATA]DHCRS(labNo,cttsCode)) q:cttsCode=""  d
 	        ..s drsId=""
 	        ..f  s drsId=$o(^[LABDATA]DHCRS(labNo,cttsCode,drsId)) q:drsId=""  d
	            ...s drsStr=^[LABDATA]DHCRS(labNo,cttsCode,drsId)
	            ...s rejStatDr=$p(drsStr,"\",10)
	            ...;q:(rejStatDr'=0)&(rejStatDr'=2)    //过滤--
	            ...q:(rejStatDr'=0)     //过滤---bmz
	            ...i rejStatDr=0 s rejStat="拒收"
	            ...i rejStatDr=2 s rejStat="护士阅读"
	            ...s regNo=$p(drsStr,"\",1)
	            ...;q:(queryRegNo'=regNo)&(queryRegNo'="")
	            ...s patName=$p(drsStr,"\",2)
	            ...s patLocId=$p(drsStr,"\",3)
	            ...i patLocId'=""  s patLocDesc=$P($G(^CTLOC(patLocId)),"^",2)
	            ...e  s patLocDesc=""
	            ...q:$p(drsStr,"\",4)<(+$H-7)
	            ...s rejectDate=$zd($p(drsStr,"\",4),3)
	            ...s rejectTime=$zt($p(drsStr,"\",5),2)
	            ...s rejectUserCode=$p(drsStr,"\",6)     //拒收用户 
	            ...s rejectUserCode1=$$ALPHAUP^SSUTIL4(rejectUserCode)   //转换Code为大写去索引----20150514bmz
	            ...s rejectUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",rejectUserCode1,0))
	            ...s rejectUser=$p($g(^SSU("SSUSR",rejectUserId)),"^",2)   //修改取到的userCode为userName--20150506bmz
	            ...s rejectReason=$p(drsStr,"\",11)
	            ...s patWardId=$p(drsStr,"\",12)
	            ...s wardDesc=$p(^PAWARD(wardId),"^",2)
	            ...i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
	            ...q:(patWardId'=wardDesc)   //非本病区退出--bmz patWardId为描述？
	            ...i patWardId'="" s patWard=$P($G(^PAWARD(patWardId)),"^",2)
	            ...e  s patWard=""
	            ...s oeordId=$o(^OEORD(0,"EpisNo",labNo,""))
	            ...s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,+oeordId,""))
	            ...i oeordId'="",oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	            ...e  s oeoriId=""
	            ...q:oeoriId=""
	            ...s arcimDesc=$p(##class(web.DHCNurCom).GetArcim(oeoriId),"^")
	            ...s ororiDate=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",7)
	            ...i ororiDate'="" s ororiDate=$zd(ororiDate,3)
	            ...s ororiTime=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",15)
	            ...i ororiTime'="" s ororiTime=$zt(ororiTime)
	            ...//取病人信息
	            ...s EpisodeId=$p(^OEORD(oeordId),"^",1)
	 			...s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 				...s bedCode=$p(patInfoStr,"^",1)
 				...s name=$p(patInfoStr,"^",2)
 				...s sex=$p(patInfoStr,"^",3)
 				...s age=$p(patInfoStr,"^",4)
 				...s medicareNo=$p(patInfoStr,"^",5)   //病案号
 				...s admReason=$p(patInfoStr,"^",6)    //费用类型
 				...s regNo=$p(patInfoStr,"^",7)    //登记号
 				...s docDesc=$p(patInfoStr,"^",11)
				...s nurseDesc=$p(patInfoStr,"^",12)
				...s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
				...s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    			...s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    			...s inDate=$p(inTimeStr,"^",1)
    			...s inDate=$zd(inDate,3)
    			...s inTime=$p(inTimeStr,"^",2)
    			...s inTime=$zt(inTime,2)
    			...s inDateTime=inDate_"&nbsp;"_inTime
	            ...d RejectSpecInfo
	
 
  	q $$$OK
RejectSpecInfo
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,arcimDesc,ororiDate,ororiTime,rejectUser,rejectReason,rejectDate,rejectTime,labNo)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
