/// creator:lulin
/// createdate:2020-01-04
/// description:系统任务
Class web.NurSensSysTaskComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:清空系统任务数据
/// Date:2020-01-10
/// Table:
/// Input:
/// Output：
/// Others:d ##class(web.NurSensSysTaskComm).KillAutoData()
ClassMethod KillAutoData() As %String
{
	k ^DHCNS.Config.NsAutoDataSubI
	k ^DHCNS.Config.NsAutoDataSubD
	k ^DHCNS.Config.NsAutoDataI
	k ^DHCNS.Config.NsAutoDataD
	k ^DHCNS.Config.NsAutoOrderExecI
	k ^DHCNS.Config.NsAutoOrderExecD
	k ^DHCNS.Config.NsAutoOrderI
	k ^DHCNS.Config.NsAutoOrderD
	k ^DHCNS.Config.NsAutoMgDataI
	k ^DHCNS.Config.NsAutoMgDataD
	k ^DHCNS.Config.NsAutoAdvI
	k ^DHCNS.Config.NsAutoAdvD
	k ^DHCNS.Config.NsAutoPatSubI
	k ^DHCNS.Config.NsAutoPatSubD
	k ^DHCNS.Config.NsAutoPatI
	k ^DHCNS.Config.NsAutoPatD
	k ^DHCNS.Config.NsAutoInfI
	k ^DHCNS.Config.NsAutoInfD
	k ^DHCNS.Config.NsAutoANI
	k ^DHCNS.Config.NsAutoAND
}

/// Creator:lulin
/// Description:敏感指标系统任务
/// Date:2020-01-13
/// Table:
/// Input:
/// Output：
/// Others:d ##class(web.NurSensSysTaskComm).SaveAutoData()
ClassMethod SaveAutoData() As %String
{
	s nDate=+$H-1
	s beforDateNum=0 ;往前推多少天
	s startDate=nDate-beforDateNum
	f date=startDate:1:nDate d
	.d ..SaveNurMgData(date) ;前天
	.d ..SaveOrderDataNew(date-1) ;前天
	.d ..SavePatData(date-1) ;前天
	.d ..SaveANData(date)
	.d ..SaveOtherData(date)
	d ..StopOrder()
	d ..SaveAdvData()
	d ..SaveInfData()
	d ..StopANData()
}

/// Creator:lulin
/// Description:批量获取2019-02-01-至今
/// Date:2020-01-13
/// Table:
/// Input:
/// Output：
/// Others:d ##class(web.NurSensSysTaskComm).SaveAllData()
ClassMethod SaveAllData() As %String
{
	s startDate="2022-03-25"
	s startDate=$zdh(startDate,3)
	s nDate=+$H-1
	f i=startDate:1:nDate d
	.d ..SaveNurMgData(i)
	.;d ..SaveOrderDataNew(i)
	.;d ..SavePatData(i) ;保证8点之后执行
	.;d ..SaveOtherData(i)
	.;d ..SaveANData(i)
	;d ..StopOrder()
	;d ..SaveAdvData()
	;d ..SaveInfData()
	;d ..StopANData()
	w "执行完成"
}

/// Creator:lulin
/// Description:保存直接接口数据
/// Date:2020-02-21
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensSysTaskComm).SaveOtherData()
ClassMethod SaveOtherData(date As %String = "") As %String
{
	
	s:date="" date=+$H-1
	//循环元素自动获取数据的其他的
	s flag=1
	s tmpWard=""
	d ##class(web.NurSensConfigComm).SetTmpWardByID(.tmpWard)
	s $zt="errrrr"
	TS
	s eleId="" f  s eleId=$O(^CT.DHCNS.Config.NsElementI("AutoType"," Z",eleId)) q:(eleId="")||(flag'=1)  d
	.s eleObj=##class(CT.DHCNS.Config.NsElement).%OpenId(eleId)
	.s className=eleObj.ClassName
	.s methodName=eleObj.MethodName
	.s param=eleObj.MethodParam
	.q:((className="")||(methodName=""))
	.q:($d(^oddCOM(className,"m",methodName))=0) //无此方法
	.k ^tmpWardData
	.s ^tmpWardData=""
	.s param=$tr(param,"#Date",date)
	.s x="d ##class("_className_")."_methodName_"("
	.f paramIndex=1:1:$L(param,",") d
	..s x=x_""""_$P(param,",",paramIndex)_""""
	..i paramIndex'=$L(param,",") s x=x_","
	.s x=x_")"
	.x x
	.s wardId="" f  s wardId=$O(tmpWard(wardId)) q:(wardId="")||(flag'=1)  d
	..s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	..q:(wardObj.Desc="")
	..;q:(wardObj.StDate'="")&&(wardObj.StDate>date)
	..;q:(wardObj.EndDate'="")&&(wardObj.EndDate<date)
	..s ctLocId=wardObj.CTLocDR
	..q:ctLocId=""
	..s value=$g(^tmpWardData(ctLocId))
	..;q:value=""
	..s autoId=$O(^DHCNS.Config.NsAutoDataI("Index",eleId,wardId,date,""))
	..i autoId="" s autoObj=##class(DHCNS.Config.NsAutoData).%New()
	..e  s autoObj=##class(DHCNS.Config.NsAutoData).%OpenId(autoId)
	..s autoObj.DataDate=date
	..s autoObj.IndexDR=eleId
	..s autoObj.Value=value
	..s autoObj.WardDR=wardId
	..s autoObj.UpdateDate=+$H
	..s flag=flag&&$$$ISOK(autoObj.%Save())
	..q:flag'=1
	..s autoId=autoObj.%Id()
	..;对进行变更作废的数据进行删除
	..s autoSubId="" f  s autoSubId=$O(^DHCNS.Config.NsAutoDataSubD(autoId,autoSubId)) q:(autoSubId="")||(flag'=1)  d
	...s subObj=##class(DHCNS.Config.NsAutoDataSub).%OpenId(autoId_"||"_autoSubId)
	...q:'$IsObject(subObj)
	...i $g(^tmpWardData(ctLocId,subObj.KeyWord))=""  d
	....s flag=flag&&$$$ISOK(subObj.%DeleteId(autoId_"||"_autoSubId))
	..;对没有的进行数据新增，对已有的进行数据变更
	..s keyWord="" f  s keyWord=$O(^tmpWardData(ctLocId,keyWord)) q:(keyWord="")||(flag'=1)  d
	...s SubDesc=$g(^tmpWardData(ctLocId,keyWord))
	...s autoSubId=$O(^DHCNS.Config.NsAutoDataSubI("keyWord",autoId," "_keyWord,""))
	...i autoSubId=""  s subObj=##class(DHCNS.Config.NsAutoDataSub).%New()
	...e  s subObj=##class(DHCNS.Config.NsAutoDataSub).%OpenId(autoId_"||"_autoSubId)
	...s subObj.Parref=autoObj
	...s subObj.KeyWord=keyWord
	...s subObj.SubDesc=SubDesc
	...s flag=flag&&$$$ISOK(subObj.%Save())
	k ^tmpWardData
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
errrrr
	TRO
	k ^tmpWardData
}

/// Creator:lulin
/// Description:保存患者数据
/// Date:2020-01-06
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensSysTaskComm).SavePatData()
ClassMethod SavePatData(date As %String = "") As %String
{
	s:date="" date=+$H-2
	k tmpPatData
	s tmpPatData=""
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s dStTime=sysParamObj.DayStTime
	s dEndTime=sysParamObj.DayEndTime
	s:dStTime="" dStTime=28800
	s:dEndTime="" dEndTime=57600
	d ##class(web.NurSensDHCCHISComm).getPatInfo(date,.tmpPatData,dStTime,dEndTime)
	k tmpType
	s tmpType=""
	s eleId="" f  s eleId=$O(^CT.DHCNS.Config.NsElementI("AutoType"," P",eleId)) q:eleId=""  d
	.s lgObj=$G(^CT.DHCNS.Config.NsElementD(eleId))
	.q:lgObj=""
	.s patType=$LG(lgObj,21)
	.q:patType=""
	.s tmpType(patType)=patType
	//循环病区
	k tmpWard
	s tmpWard=""
	d ##class(web.NurSensConfigComm).SetTmpWardByID(.tmpWard)
	s flag=1
	TS
	s wardId="" f  s wardId=$O(tmpWard(wardId)) q:(wardId="")||(flag'=1)  d
	.s wardObj=##class(DHCNS.Config.NsWard).%New(wardId)
	.s ctLocId=wardObj.CTLocDR
	.q:ctLocId=""
	.;q:(wardObj.StDate'="")&&(wardObj.StDate>date)
	.;q:(wardObj.EndDate'="")&&(wardObj.EndDate<date)
	.s pacward=$O(^PAWARD(0,"WARD_LocationDR",ctLocId,""))
	.q:pacward=""
	.s wardPatSum=0
	.;patType=N:0点接班患者数，DN:白新,NN:夜新，DT:白转，NT:夜转,DO:白出，NO:夜出，24：24h重返，48：48h重返
	.;接班+白新+夜新=床日数/患者总数
	.s patType="" f  s patType=$O(tmpType(patType)) q:(patType="")||(flag'=1)  d
	..s autoPatId=$O(^DHCNS.Config.NsAutoPatI("Index"," "_patType,wardId,date,""))
	..s isExistFlag=0
	..i autoPatId="" s obj=##class(DHCNS.Config.NsAutoPat).%New()
	..e  s obj=##class(DHCNS.Config.NsAutoPat).%OpenId(autoPatId),isExistFlag=1
	..s obj.WardDR=wardId
	..s obj.DataDate=date
	..s obj.Value=$g(tmpPatData(pacward,patType))
	..s obj.IndexDR=patType
	..s obj.UpdateDate=+$H
	..s flag=flag&&$$$ISOK(obj.%Save())
	..q:flag'=1
	..s autoPatId=obj.%Id()
	..;对进行变更作废的数据进行删除
	..i isExistFlag=1 d
	...s patSubId="" f  s patSubId=$O(^DHCNS.Config.NsAutoPatSubD(autoPatId,patSubId)) q:(patSubId="")||(flag'=1)  d
	....s patSubObj=##class(DHCNS.Config.NsAutoPatSub).%OpenId(autoPatId_"||"_patSubId)
	....q:'$IsObject(patSubObj)
	....i $g(tmpPatData(pacward,patType,patSubObj.KeyWord))=""  d
	.....s flag=flag&&$$$ISOK(patSubObj.%DeleteId(autoPatId_"||"_patSubId))
	..;对没有的进行数据新增，对已有的进行数据变更
	..s EpisodeID="" f  s EpisodeID=$O(tmpPatData(pacward,patType,EpisodeID)) q:(EpisodeID="")||(flag'=1)  d
	...s patInfo=$g(tmpPatData(pacward,patType,EpisodeID))
	...q:patInfo=""
	...k patSubTmp
	...s patSubTmp=""
	...d ##class(web.NurSensUtilComm).SplitStr(patInfo,"^","|",.patSubTmp)
	...s autoPatSubId=$O(^DHCNS.Config.NsAutoPatSubI("key",autoPatId," "_EpisodeID,""))
	...i autoPatSubId="" d
	....s autoPatSubObj=##class(DHCNS.Config.NsAutoPatSub).%New()
	....s autoPatSubObj.Parref=obj
	....s autoPatSubObj.KeyWord=$g(patSubTmp("KeyWord"))
	....s autoPatSubObj.Doctor=$g(patSubTmp("Doctor"))
	....s autoPatSubObj.Nurse=$g(patSubTmp("Nurse"))
	...e  s autoPatSubObj=##class(DHCNS.Config.NsAutoPatSub).%OpenId(autoPatId_"||"_autoPatSubId)
	...s autoPatSubObj.SubDesc=$g(patSubTmp("SubDesc"))
	...s autoPatSubObj.IsBaby=$g(patSubTmp("IsBaby"))
	...s autoPatSubObj.AdmDate=$g(patSubTmp("AdmDate"))
	...s autoPatSubObj.AdmTime=$g(patSubTmp("AdmTime"))
	...s autoPatSubObj.PerBirthDate=$g(patSubTmp("PerBirthDate"))
	...s autoPatSubObj.PerDiagnos=$g(patSubTmp("PerDiagnos"))
	...s autoPatSubObj.PerLeaveDiagnos=$g(patSubTmp("PerLeaveDiagnos"))
	...s flag=flag&&$$$ISOK(autoPatSubObj.%Save())
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:保存不良事件数据
/// Date:2020-01-06
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensSysTaskComm).SaveAdvData()
ClassMethod SaveAdvData() As %String
{
	k tmpAdvData
	s tmpAdvData=""
	s paramFlag=1
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s:sysParamObj.AdvInter="A" paramFlag=2
	i paramFlag=1 d 
	.d ##class(web.NurSensAdvComm).GetAdvData(.tmpAdvData)
	e  d
	.d ##class(web.NurSensAdvComm).GetAdvDataForXin(.tmpAdvData)
	;新产品组的不良事件接口
	s rw="" f  s rw=$O(tmpAdvData(rw)) q:rw=""  d
	.s str=$G(tmpAdvData(rw))
	.q:str=""
	.k tmp
	.s tmp=""
	.d ##class(web.NurSensUtilComm).SplitStr(str,"^","|",.tmp)
	.s bId=$O(^DHCNS.Config.NsAutoAdvI("Index"," "_rw,""))
	.i bId="" s obj=##class(DHCNS.Config.NsAutoAdv).%New()
	.e  s obj=##class(DHCNS.Config.NsAutoAdv).%OpenId(bId)
	.s obj.UpdateDate=+$H
	.s className="DHCNS.Config.NsAutoAdv"
	.s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmp(p)) d
	...s $ZOBJPROPERTY(obj,p)=$tr(tmp(p),"__","||")
	.d obj.%Save()
	q 1
}

/// Creator:lulin
/// Description:保存元素中护理管理相关得数据
/// Date:2020-01-06
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveNurMgData(date As %String = "") As %String
{
	s:date="" date=+$H-1
	//DHC接口方法,保存相关数据到护理管理中。
	s flag=##class(web.NurSensNurMgComm).SetAutoDataTmp(date)
}

/// Creator:lulin
/// Description:保存医嘱数据
/// Date:2020-01-10
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveOrderDataNew(date As %String = "") As %String
{
	s:date="" date=+$H-1
	s stTime="",endTime=""
	k tmpE,tmpData
	s tmpE="",tmpData="" //元素配置对应的医嘱例数和留置日数的医嘱id数组，his数据数组
	d ..SetOrderTmpE("O",.tmpE)
	d ..SetOrderTmpE("L",.tmpE)
	d ##class(web.NurSensDHCCHISComm).getOrderExec(date,.tmpE,.tmpData)
	s flag=1
	TS
	s OrderItemId="" f  s OrderItemId=$O(tmpData(OrderItemId)) q:((OrderItemId="")||(flag'=1))  d
	.s tmpParrStr=$g(tmpData(OrderItemId))
	.q:tmpParrStr=""
	.k tmpParr
	.s tmpParr=""
	.d ##class(web.NurSensUtilComm).SplitStr(tmpParrStr,"^","|",.tmpParr)
	.q:$g(tmpParr("OrderItemId"))=""
	.s tOrderWard=$g(tmpParr("OrderWard"))
	.s StartDate=$g(tmpParr("StartDate"))
	.q:tOrderWard=""
	.q:StartDate=""
	.q:(($g(tmpParr("StartDate"))'="")&&($g(tmpParr("StartTime"))'="")&&($g(tmpParr("EndDate"))'="")&&($g(tmpParr("EndTime"))'="")&&($g(tmpParr("StartDate"))=$g(tmpParr("EndDate")))&&($g(tmpParr("StartTime"))>$g(tmpParr("EndTime"))))
	.s autoOrderId=$O(^DHCNS.Config.NsAutoOrderI("Indexst"," "_OrderItemId,StartDate,""))
	.s beforOrderId="" 
	.s beforStDate=$O(^DHCNS.Config.NsAutoOrderI("Indexst"," "_OrderItemId,StartDate),-1)
	.s:beforStDate'="" beforOrderId=$O(^DHCNS.Config.NsAutoOrderI("Indexst"," "_OrderItemId,beforStDate,""))
	.i (beforOrderId'="") d
	..s beforObj=##class(DHCNS.Config.NsAutoOrder).%OpenId(beforOrderId)
	..s beforObj.EndDate=$g(tmpParr("StartDate"))
	..s beforObj.EndTime=$g(tmpParr("StartTime"))
	..s beforObj.EndFlag="Y"
	..s flag=flag&&$$$ISOK(beforObj.%Save())
	.q:flag'=1
	.i autoOrderId'="" d
	..s obj=##class(DHCNS.Config.NsAutoOrder).%OpenId(autoOrderId)
	.e  d
	..s obj=##class(DHCNS.Config.NsAutoOrder).%New()
	.s obj.UpdateDate=+$H
	.s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoOrder","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmpParr(p)) d
	...s $ZOBJPROPERTY(obj,p)=tmpParr(p)
	.i obj.EndDate="" d
	..s obj.EndFlag="N"
	.e  d
	..s obj.EndFlag="Y"
	.s flag=flag&&$$$ISOK(obj.%Save())
	.q:flag'=1
	.s autoOrderItemId=obj.%Id()
	.s oeoreSub="" f  s oeoreSub=$O(tmpData(OrderItemId,oeoreSub)) q:(oeoreSub="")||(flag'=1)  d
	..s execParr=$g(tmpData(OrderItemId,oeoreSub))
	..q:execParr=""
	..s ArcimExecID=OrderItemId_"||"_oeoreSub
	..s autoOrderExecId=$O(^DHCNS.Config.NsAutoOrderExecI("Index"," "_ArcimExecID,autoOrderItemId,""))
	..k tmpExecParr
	..s tmpExecParr=""
	..d ##class(web.NurSensUtilComm).SplitStr(execParr,"^","|",.tmpExecParr)
	..;q:$g(tmpExecParr("execStatusId"))=""
	..s execStatusId=$g(tmpExecParr("execStatusId"))
	..;s execStatusCode=$P($G(^OEC("OSTAT",$g(tmpExecParr("execStatusId")))),"^",1) ;非核实和执行不计入
	..s execStatusCode=""
	..s:execStatusId'="" execStatusCode=$P($g(^OEC("STAT",execStatusId)),"^",1)
	..s statusFlag=1
	..//如果项目需要修改获取医嘱执行的状态，根据^OEC("STAT")选择相应即可。滚完医嘱，医嘱执行状态默认空
	..i ((execStatusId'="")&&(execStatusCode'="F")&&(execStatusCode'="A")) d
	...s statusFlag=0
	..i statusFlag'=1 d
	...s execObj=##class(DHCNS.Config.NsAutoOrderExec).%OpenId(autoOrderItemId_"||"_autoOrderExecId)
	...d:$IsObject(execObj) execObj.%DeleteId(autoOrderExecId) ;删除掉不进入统计范畴的
	..q:statusFlag'=1
	..i autoOrderExecId="" s execObj=##class(DHCNS.Config.NsAutoOrderExec).%New()
	..e  s execObj=##class(DHCNS.Config.NsAutoOrderExec).%OpenId(autoOrderItemId_"||"_autoOrderExecId)
	..s execObj.UpdateDate=+$H
	..s execObj.Parref=obj
	..s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoOrderExec","a",p)) q:p=""  d
	...q:p["%"
	...q:p["ChildSub"
	...q:p["Parref"
	...i $D(tmpExecParr(p)) d
	....s $ZOBJPROPERTY(execObj,p)=tmpExecParr(p)
	..s flag=flag&&$$$ISOK(execObj.%Save())
	i flag'=1{
		TRO
		q 0	
	}
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:根据元素配置设置获取相关医嘱id
/// Date:2020-01-10
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SetOrderTmpE(type, tmpE) As %String
{
	s id="" f  s id=$O(^CT.DHCNS.Config.NsElementI("AutoType"," "_type,id)) q:id=""  d
	.s obj=##class(CT.DHCNS.Config.NsElement).%OpenId(id)
	.q:'$IsObject(obj)
	.s arcimIds=""
	.s typeId="" f  s typeId=$O(^CT.DHCNS.Config.NsEleTypeD(id,typeId)) q:typeId=""  d
	..s orderTypeObj=##class(CT.DHCNS.Config.NsEleType).%OpenId(id_"||"_typeId)
	..q:'$IsObject(orderTypeObj)
	..s arcimId=orderTypeObj.TypeID
	..q:arcimId=""
	..s tmpE(arcimId)=id
	..i arcimIds="" s arcimIds=arcimId
	..e  s arcimIds=arcimIds_"^"_arcimId
	.;q:arcimIds=""
	.;s tmpE(id)=type_"#"_arcimIds
	.;s tmpE(arcimId)=id
}

/// Creator:lulin
/// Description:保存院感数据
/// Date:2021-04-15
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.NurSensSysTaskComm).SaveInfData()
ClassMethod SaveInfData() As %String
{
	k tmpInfData
	s tmpInfData=""
	s paramFlag=1
	s sysParamObj=##class(DHCNS.Config.NsSysParam).%New(1)
	s:sysParamObj.InfInter="O" paramFlag=2
	i paramFlag=1 d 
	.d ##class(web.NurSensDHCCHISComm).GetInfRepData("","",.tmpInfData)
	e  d
	.d ##class(web.NurSensThirdInter).GetThirdInfoData("","",.tmpInfData)
	//删除，删除的或者修改类型的院感数据
#;	s infId="" f  s infId=$O(^DHCNS.Config.NsAutoInfD(infId)) q:infId=""  d
#;	.s infLB=$G(^DHCNS.Config.NsAutoInfD(infId))
#;	.q:infLB=""
#;	.s ReportID=$LG(infLB,6)
#;	.i ((ReportID="")||('$d(tmpInfData(ReportID)))) d
#;	..s oldObj=##class(DHCNS.Config.NsAutoInf).%DeleteId(infId)
	s rw="" f  s rw=$O(tmpInfData(rw)) q:rw=""  d
	.s str=$G(tmpInfData(rw))
	.q:str=""
	.k tmp
	.s tmp=""
	.d ##class(web.NurSensUtilComm).SplitStr(str,"^","|",.tmp)
	.s bId=$O(^DHCNS.Config.NsAutoInfI("Index"," "_rw,""))
	.i bId="" s obj=##class(DHCNS.Config.NsAutoInf).%New()
	.e  s obj=##class(DHCNS.Config.NsAutoInf).%OpenId(bId)
	.s obj.UpdateDate=+$H
	.s className="DHCNS.Config.NsAutoInf"
	.s EpisodeID=$g(tmp("EpisodeID")),InfDate=$g(tmp("InfDate"))
	.
	.i (($g(tmp("RepWard"))="")&&(EpisodeID'="")) d
	..s:InfDate'="" InfDate=$zdh(InfDate,3)
	..s:InfDate="" InfDate=+$H
	..s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	..s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
    ..s InfTime="00:00:01"
    ..s:InfDate=AdmDate InfTime=AdmTime
    ..s:InfTime="" InfTime="00:00:01"
	..s RepWard=##class(web.NurSensDHCCHISComm).getTransWardByDateTime(EpisodeID,InfDate,InfTime)
	..B:RepWard=""
    ..s:RepWard'="" tmp("RepWard")=$p($g(^PAWARD(RepWard)),"^",5)
	.s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..q:'$D(tmp(p))
	..s value=$tr(tmp(p),"__","||")
	..s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(value'="")&&(value'="null")) d
	...s value=$zdh(value,3)
	..i ((ptype="time")&&(value'="")&&(value'="null")) d
	...s value=$zth(value,1)
	..s $ZOBJPROPERTY(obj,p)=value
	.s sc=$$$ISOK(obj.%Save())
	q 1
}

/// w ##class(web.NurSensSysTaskComm).StopOrder()
ClassMethod StopOrder() As %String
{
	
	s tmpOrder="",flag=1
	s autoOrderId="" f  s autoOrderId=$O(^DHCNS.Config.NsAutoOrderI("End"," N",autoOrderId)) q:autoOrderId=""  d
	.s autoOrderLB=$g(^DHCNS.Config.NsAutoOrderD(autoOrderId))
	.q:autoOrderLB=""
	.s OrderItemId=$LG(autoOrderLB,2)
	.q:OrderItemId=""
	.s tmpOrder(autoOrderId)=OrderItemId
	s tmpEndData=""
	d ##class(web.NurSensDHCCHISComm).getEndOrder(.tmpOrder,.tmpEndData)
	TS
	s autoOrderId="" f  s autoOrderId=$O(tmpEndData(autoOrderId)) q:((autoOrderId="")||(flag'=1))  d
	.s tmpParrStr=$g(tmpEndData(autoOrderId))
	.q:tmpParrStr=""
	.k tmpParr
	.s tmpParr=""
	.d ##class(web.NurSensUtilComm).SplitStr(tmpParrStr,"^","|",.tmpParr)
	.s obj=##class(DHCNS.Config.NsAutoOrder).%OpenId(autoOrderId)
	.q:'$IsObject(obj)
	.q:$g(tmpParr("EndDate"))=""
	.s obj.UpdateDate=+$H
	.s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoOrder","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmpParr(p)) d
	...s $ZOBJPROPERTY(obj,p)=tmpParr(p)
	.i obj.EndDate="" d
	..s obj.EndFlag="N"
	.e  d
	..s obj.EndFlag="Y"
	.s flag=flag&&$$$ISOK(obj.%Save())
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:保存手术数据
/// Date:2020-01-10
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod SaveANData(date As %String = "") As %String
{
	s:date="" date=+$H-1
	k tmpData
	s tmpData=""
	s flag=1
	d ##class(web.NurSensDHCCHISComm).GetANData(date,.tmpData)
	TS
	s dataId="" f  s dataId=$O(tmpData(dataId)) q:((dataId="")||(flag'=1))  d
	.s tmpParrStr=$g(tmpData(dataId))
	.q:tmpParrStr=""
	.s rw=$O(^DHCNS.Config.NsAutoANI("Index"," "_dataId,""))
	.k tmpParr
	.s tmpParr=""
	.d ##class(web.NurSensUtilComm).SplitStr(tmpParrStr,"^","|",.tmpParr)
	.i rw="" s obj=##class(DHCNS.Config.NsAutoAN).%New()
	.e  s obj=##class(DHCNS.Config.NsAutoAN).%OpenId(rw)
	.s obj.UpdateDate=+$H
	.s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoAN","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmpParr(p)) d
	...s $ZOBJPROPERTY(obj,p)=tmpParr(p)
	.s flag=flag&&$$$ISOK(obj.%Save())
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
}

/// Creator:lulin
/// Description:处理未到终结状态的手术数据
/// Date:2020-01-10
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod StopANData(date As %String = "") As %String
{
	s:date="" date=+$H-1
	k tmpANData,tmpData
	s tmpData="",tmpANData=""
	s rw="" f  s rw=$O(^DHCNS.Config.NsAutoAND(rw)) q:rw=""  d
	.s anLB=$g(^DHCNS.Config.NsAutoAND(rw))
	.q:anLB=""
	.s status=$lg(anLB,13)
	.q:status="F"
	.s dataId=$lg(anLB,2)
	.s tmpANData(dataId)=$lg(anLB,16)
	d ##class(web.NurSensDHCCHISComm).GetEndANOPData(.tmpANData,.tmpData)
	s flag=1
	TS
	s dataId="" f  s dataId=$O(tmpData(dataId)) q:((dataId="")||(flag'=1))  d
	.s tmpParrStr=$g(tmpData(dataId))
	.q:tmpParrStr=""
	.s rw=$O(^DHCNS.Config.NsAutoANI("Index"," "_dataId,""))
	.k tmpParr
	.s tmpParr=""
	.d ##class(web.NurSensUtilComm).SplitStr(tmpParrStr,"^","|",.tmpParr)
	.s obj=##class(DHCNS.Config.NsAutoAN).%OpenId(rw)
	.s obj.UpdateDate=+$H
	.s p="" f  s p=$O(^oddCOM("DHCNS.Config.NsAutoAN","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..i $D(tmpParr(p)) d
	...s $ZOBJPROPERTY(obj,p)=tmpParr(p)
	.s flag=flag&&$$$ISOK(obj.%Save())
	i flag'=1{
		TRO
		q 0	
	}else{
		TC
		q 1	
	}
}

}
