/// Creator：     chengpeng
/// CreatDate：   2017-01-10
/// Description:  统计会诊信息
Class DtPortal.MD.MD36Consultation Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     bmz
/// CreatDate：   2017-12-18
/// Description:  MD36.01.01统计用户会诊总数量
/// Table：       DHC_Consultation
/// Input：       无
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD36Consultation","MD360101","","year","2017","2017")
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD36Consultation","MD360101","","month","2017-10-01","2017-10-31")
Query MD360101(hospitalId As %String = "", dateType As %String = "", startDate As %String = "", endDate As %String = "") As DtPortal.Query(ROWSPEC = "conDate,conNum")
{
}

ClassMethod MD360101Execute(ByRef qHandle As %Binary, hospitalId As %String = "", dateType As %String = "", startDate As %String = "", endDate As %String = "") As %Status
{
	n (qHandle,hospitalId,dateType,startDate,endDate)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s mode="H"
	if (dateType="month"){
		s dateType=""
		s kpiRule="DtPortal0004:ResLoc"
		s filterRule=""
		i hospitalId'="" S filterRule="DtPortal0004:({ResLoc.HospIdByLoc}="_hospitalId_")"
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,"")
		s sDate=$zdh(startDate,3)
		s eDate=$zdh(endDate,3)
		
		k ^TEMPDHCWL($j)
		
		For date=sDate:1:eDate d
		.s ^TEMPDHCWL($j,date)=0
		
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			s date=rs.Data("month")
			set mDate=rs.Data("month")
			set mDate=$p(rs.Data("month"),"年",1)_"-"_$p($p(rs.Data("month"),"年",2),"月",1)_"-"_$p(rs.Data("month"),"月",2)
			set mDate=$p(mDate,"日",1)
			set date=$zdh(mDate,3)
			set ^TEMPDHCWL($j,date)=$g(^TEMPDHCWL($j,date))+rs.Data("kpiValueCol1")

		}
		s date=0 f  s date=$o(^TEMPDHCWL($j,date)) q:date=""  d
		.s WithDate=$zd(date,3)
		.;s WithDate=$p(WithDate,"-",1)_"年"_$p(WithDate,"-",2)_"月"_$p(WithDate,"-",3)_"日"
		.s ^||CacheTemp(repid,ind)=$lb(WithDate,$g(^TEMPDHCWL($j,date)))
 		.s ind=ind+1
		k ^TEMPDHCWL($j)
	}
	
	if (dateType="year"){
		s dateType="byMonth"
		s kpiRule="DtPortal0004:ResLoc"
		s filterRule=""
		i hospitalId'="" S filterRule="DtPortal0004:({ResLoc.HospIdByLoc}="_hospitalId_")"
		
		
		
		
		k ^TEMPDHCWL($j)
		s ^TEMPDHCWL($j,startDate_"年01月")=0,^TEMPDHCWL($j,startDate_"年02月")=0
		s ^TEMPDHCWL($j,startDate_"年03月")=0,^TEMPDHCWL($j,startDate_"年04月")=0
		s ^TEMPDHCWL($j,startDate_"年05月")=0,^TEMPDHCWL($j,startDate_"年06月")=0
		s ^TEMPDHCWL($j,startDate_"年07月")=0,^TEMPDHCWL($j,startDate_"年08月")=0
		s ^TEMPDHCWL($j,startDate_"年09月")=0,^TEMPDHCWL($j,startDate_"年10月")=0
		s ^TEMPDHCWL($j,startDate_"年11月")=0,^TEMPDHCWL($j,startDate_"年12月")=0
		s endDate=startDate
		s startDate=startDate_"-01"
		s endDate=endDate_"-12"
		
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,"")

		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			s date=rs.Data("month")
			s ^TEMPDHCWL($j,date)=$g(^TEMPDHCWL($j,date))+rs.Data("kpiValueCol1")

		}
		s SDate="" f  s SDate=$o(^TEMPDHCWL($j,SDate)) q:SDate=""  d
		.s lastmonth=$p($p(SDate,"年",2),"月",1)
		.s nowmonth=$p($zd($p($h,",",1),3),"-",2)
		.s lastyear=$p(SDate,"年",1)
		.s nowyear=$p($zd($p($h,",",1),3),"-",1)
		.i lastyear=nowyear q:lastmonth>nowmonth
		.s date=lastyear_"-"_lastmonth
		.s num=$g(^TEMPDHCWL($j,SDate))
		.s ^||CacheTemp(repid,ind)=$lb(date,num)
		.s ind=ind+1
		k ^TEMPDHCWL($j)
	}
	Quit $$$OK
}

/// Creator：     bmz
/// CreatDate：   2017-12-18
/// Description:  MD36.01.01统计用户会诊数量信息
/// Table：       DHC_Consultation
/// Input：       type  0-按申请科室统计 1-按会诊科室统计
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD36Consultation","MD360102","","2018-12-01","2018-12-31",0)
Query MD360102(hospitalId As %String = "", startDate As %String = "", endDate As %String = "", type As %String = "") As DtPortal.Query(ROWSPEC = "locDesc,locId,totalNum,completeNum,unCcompleteNum,completionRate,feNum,overFeNum")
{
}

ClassMethod MD360102Execute(ByRef qHandle As %Binary, hospitalId As %String = "", startDate As %String = "", endDate As %String = "", type As %String = "") As %Status
{
	n (qHandle,hospitalId,startDate,endDate, type)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	i (type'="0")&&(type'="1") Quit $$$OK
	
	k ^TEMPPortalMD360102($j)
	
	s findType=""
	
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	s nowDate=$p($h,",",1)
	s:nowDate=EDate EDate=EDate-1
	
	s totalNum=0,completeNum=0,unCompleteNum=0,completionRate="",feNum=0,overFeNum=0
	
	
	//会诊版本  1-护理组   2-新产品
	s version=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
	if (version=1){
		i type="0" s findType="AppDep"
		e  i type="1" s findType="ConSultDep"
		f date=SDate:1:EDate  d
		.s locIdStr=""
		.f  s locIdStr=$o(^User.DHCConsultationI(findType,date,locIdStr)) q:locIdStr=""  d
		..s conId=""
		..s tempUncom=unCompleteNum,tempCom=completeNum,tempTotal=totalNum,tempFeNum=feNum,tempOverFeNum=overFeNum
		..f  s conId=$o(^User.DHCConsultationI(findType,date,locIdStr,conId)) q:conId=""  d
		...//!!!判断删除、作废退出
		...s conObj=##Class(User.DHCConsultation).%OpenId(conId)
		...q:'$IsObject(conObj)
		...set Status=conObj.Status 
		...q:Status="C"
		...;w !,conObj.ConType_"^^"_Status_"%%"_$zd(conObj.AppDate,3)_"&"_$zt(conObj.AppTime)_"#"
		...;w $zd(conObj.ConsultDate,3)_"&"_$zt(conObj.ConsultTime)_"#"
		...;w $zd(conObj.RecDate,3)_"&"_$zt(conObj.RecTime)
		...i Status="V" s unCompleteNum=unCompleteNum+1
		...e  i Status="E" s completeNum=completeNum+1
		...s totalNum=unCompleteNum+completeNum
		...s conDate=conObj.ConsultDate,conTime=conObj.ConsultTime
		...s appDate=conObj.AppDate,appTime=conObj.AppTime
		...s ifOverFe=""
		...i conDate'="" d
		....s numTemp=(conDate-appDate)*24+$fn((conTime-appTime)/3600,"",2)
		....i (numTemp>48)&&(Status="E") s overFeNum=overFeNum+1
		....i (numTemp<48)&&(Status="E")  s feNum=feNum+1
		..s locId=$tr(locIdStr," ")
		..q:+locId=0	//科室字段为空的退出
		..s hospID=$p($g(^CTLOC(locId)),"^",22)
		..q:(hospitalId'="")&&(hospID'=hospitalId)
		..s ^TEMPPortalMD360102($j,locId,"totalNum")=$g(^TEMPPortalMD360102($j,locId,"totalNum"))+totalNum-tempTotal
		..s ^TEMPPortalMD360102($j,locId,"unCompleteNum")=$g(^TEMPPortalMD360102($j,locId,"unCompleteNum"))+unCompleteNum-tempUncom
		..s ^TEMPPortalMD360102($j,locId,"completeNum")=$g(^TEMPPortalMD360102($j,locId,"completeNum"))+completeNum-tempCom
		..s ^TEMPPortalMD360102($j,locId,"feNum")=$g(^TEMPPortalMD360102($j,locId,"feNum"))+feNum-tempFeNum
		..s ^TEMPPortalMD360102($j,locId,"overFeNum")=$g(^TEMPPortalMD360102($j,locId,"overFeNum"))+overFeNum-tempOverFeNum
	}elseif(version=2){
		i type="0" s findType="R"
		e  i type="1" s findType="C"
		set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
		d obj.Execute("","",SDate,EDate,"",findType)
		//获取会诊的完成状态code
		s ConStatusCodeFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE")
		s ConStatusCodeNotFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE")
		
		f  Quit:'obj.Next()  d            
		.s ConsultId=obj.Data("CsItmID")
		.s CsStatCode=obj.Data("CsStatCode")  //会诊状态为空退出
		
		.s CstUserID=obj.Data("CstUserID")    //申请医生	 
		.s CstRLocID=obj.Data("CstRLocID")    //申请科室ID
		.s CsLocID=obj.Data("CsLocID")    //会诊科室
		.q:(CstRLocID="")||(CsLocID="")
		.s appDate=obj.Data("CstRDate") //会诊申请时间 
		.s appTime=obj.Data("CstRTime")
		.s conDate=obj.Data("CstNDate") 	//会诊日期
		.s conTime=obj.Data("CstNTime")		//会诊时间
		
		.i appDate'="" s appDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(appDate),3)
		.i appTime'="" s appTime=$zth(appTime)
		.i conDate'="" s conDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(conDate),3)
		.i conTime'="" s conTime=$zth(conTime)
		
		.s numTemp="" //会诊时长
		.s ifOverFe=""
		.s overFeNum=0,feNum=0,unCompleteNum=0
		.i (conDate'="")&&(conTime'="") d
		..s numTemp=(conDate-appDate)*24+$fn((conTime-appTime)/3600,"",2)
		..i (numTemp>48)&&($LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode)) s overFeNum=1
		..e  i (numTemp<=48)&&($LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))  s feNum=1
		..e  i ($LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode)) s unCompleteNum=1   //未完成code里面查询未完成数量
		..//w !,nod_"^"_appDate_"^"_appTime_"^"_conDate_"^"_conTime_"#"_CsStatCode
		.e  i ($LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode)) s unCompleteNum=1  //未完成code里面查询未完成数量
		.s completeNum=overFeNum+feNum
		.s totalNum=unCompleteNum+completeNum
		.i findType="R" s locId=CstRLocID
		.e  i findType="C" s locId=CsLocID
		.q:+locId=0	//科室字段为空的退出
		.s hospID=$p($g(^CTLOC(locId)),"^",22)
		.q:(hospitalId'="")&&(hospID'=hospitalId)
		.s ^TEMPPortalMD360102($j,locId,"totalNum")=$g(^TEMPPortalMD360102($j,locId,"totalNum"))+totalNum
		.s ^TEMPPortalMD360102($j,locId,"unCompleteNum")=$g(^TEMPPortalMD360102($j,locId,"unCompleteNum"))+unCompleteNum
		.s ^TEMPPortalMD360102($j,locId,"completeNum")=$g(^TEMPPortalMD360102($j,locId,"completeNum"))+completeNum
		.s ^TEMPPortalMD360102($j,locId,"feNum")=$g(^TEMPPortalMD360102($j,locId,"feNum"))+feNum
		.s ^TEMPPortalMD360102($j,locId,"overFeNum")=$g(^TEMPPortalMD360102($j,locId,"overFeNum"))+overFeNum
			
	}
	
	
	
	s locId=""
	f  s locId=$o(^TEMPPortalMD360102($j,locId)) q:locId=""  d
	.s locDesc=$p(^CTLOC(locId),"^",2)
	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	.s totalNum=$g(^TEMPPortalMD360102($j,locId,"totalNum"))
	.q:totalNum=0
	.s completeNum=$g(^TEMPPortalMD360102($j,locId,"completeNum"))
	.s unCompleteNum=$g(^TEMPPortalMD360102($j,locId,"unCompleteNum"))
	.s feNum=$g(^TEMPPortalMD360102($j,locId,"feNum"))
	.s overFeNum=$g(^TEMPPortalMD360102($j,locId,"overFeNum"))
	.i totalNum=0 s completionRate=0
	.e  s completionRate=$fn(completeNum*100/totalNum,"",2)_"%"
	
	.s ^||CacheTemp(repid,ind)=$lb(locDesc,locId,totalNum,completeNum,unCompleteNum,completionRate,feNum,overFeNum)
 	.s ind=ind+1
	
	k ^TEMPPortalMD360102($j)
	
	Quit $$$OK
}

/// Creator：     bmz
/// CreatDate：   2017-12-18
/// Description:  MD36.01.03按类型查询患者的详细信息
/// Table：       DHC_Consultation
/// Input：       depType  0-按申请科室统计 1-按会诊科室统计   
/// 				All代表全部，Complate代表完成，UnCom未完成，FE代表48小时内完成，OverFE超过48小时完成
///               ifTodayData  0-过滤当天数据   1-不过滤当天数据
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.MD.MD36Consultation","MD360103","2019-04-1","2019-04-30",0,"All","151")
Query MD360103(startDate As %String = "", endDate As %String = "", depType As %String = "", otherType As %String = "", locId As %String = "", ifTodayData As %String = "0") As DtPortal.Query(ROWSPEC = "name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc")
{
}

ClassMethod MD360103Execute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", depType As %String = "", otherType As %String = "", locId As %String = "", ifTodayData As %String = "0") As %Status
{
	n (qHandle,startDate,endDate,depType,otherType,locId,ifTodayData)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	i (depType'="0")&&(depType'="1") Quit $$$OK
	i locId="" Quit $$$OK
	
	s findType=""
	
	
	s SDate=$zdh(startDate,3)
	s EDate=$zdh(endDate,3)
	
	//控制是否取当天数据
	i ifTodayData="0"{
		if (EDate>=+$h) {
			s EDate=(+$h-1)
		}
		if (SDate>EDate){
			Quit $$$OK
		}
	}
	
	//会诊版本  1-护理组   2-新产品
	s version=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTATION")
	if (version=1){
		i depType="0" s findType="AppDep"
		e  i depType="1" s findType="ConSultDep"
		f date=SDate:1:EDate  d
		.s locIdStr=""
		.s totalNum=0,completeNum=0,unCompleteNum=0,completionRate="",feNum=0,overFeNum=0
		.s locIdStr=" "_locId
		.s conId=""
		.f  s conId=$o(^User.DHCConsultationI(findType,date,locIdStr,conId)) q:conId=""  d
		..s conObj=##Class(User.DHCConsultation).%OpenId(conId)
		..q:'$IsObject(conObj)
		..set Status=conObj.Status  
		..q:Status="C"
		..s totalNum=totalNum+1
		..q:(otherType="Complate")&&(Status'="E")
		..q:(otherType="UnCom")&&(Status'="V")
		..s totalNum=totalNum+1
		..;w !,totalNum_"**"_$zd(date,3)
		..;i Status="V" s unCompleteNum=unCompleteNum+1
		..;e  i Status="E" s completeNum=completeNum+1
		..s conDate=conObj.ConsultDate,conTime=conObj.ConsultTime
		..s appDate=conObj.AppDate,appTime=conObj.AppTime
		..s ifOverFe=""
		..s numTemp="" //会诊时长
		..s secondNum=0
		..i conDate'="" d
		...s secondNum=(conDate-appDate)*24*3600+(conTime-appTime)
		...s numTemp=(conDate-appDate)*24+$fn((conTime-appTime)/3600,"",2)
		...i numTemp<1 s numTemp=+"0"_numTemp  //解决会诊时长小于1时，不显示小数点前的"0"，by yupeng
		..q:(otherType="FE")&&((Status'="E")||(numTemp>48)||(numTemp=""))
		..q:(otherType="OverFE")&&((numTemp<=48)||(Status'="E"))
		..s admId=conObj.Adm
		..;w "admId==="_admId,!
		..q:admId=""
		..s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
		..s bedNo=$p(patInfoStr,"^",1)
		..s medicalNo=$p(patInfoStr,"^",5)
		..s name=$p(patInfoStr,"^",2)
		..s sex=$p(patInfoStr,"^",3)
		..s age=$p(patInfoStr,"^",4)
		..s admReason=$p(patInfoStr,"^",6)
		..s appLocId=conObj.AppDep
		..s applyLocDesc=$p($g(^CTLOC(appLocId)),"^",2)
		..i applyLocDesc["-" s applyLocDesc=$p(applyLocDesc,"-",2)
		..s applyDcotor=""         
		..s applyDocID=conObj.AppDoc    //申请医生  ----存的是userId
		..s applyDocID=$P($g(^SSU("SSUSR",applyDocID)),"^",14) 
		..i applyDocID'="" s applyDcotor=$P($g(^CTPCP(applyDocID,1)),"^",2) //实际会诊医生的Name
		..s applyTime=$zd(appDate,3)_"&nbsp;"_$zt(appTime)
		..s consultDcotorId=conObj.ConsultDoc
		..s consultDcotor=""
		..i consultDcotorId'="" s consultDcotor=$P($g(^CTPCP(consultDcotorId,1)),"^",2) //实际会诊医生的Name
		..s consultLocId=conObj.ConsultDep
		..s consultLocDesc=$p($g(^CTLOC(consultLocId)),"^",2)
		..i consultLocDesc["-" s consultLocDesc=$p(consultLocDesc,"-",2)
		..s consultTime=""
		..i conDate'="" s consultTime=$zd(conDate,3)_"&nbsp;"_$zt(conTime)
		..;i (numTemp="")||(numTemp<0.01) s timeLength=0_"小时"
		..;e  s timeLength=numTemp_"小时"
		..s timeLength=..getTimeNum(secondNum)
		..s consultId=conId
		..s patientId=$P($g(^PAADM(admId)),"^",1)
		..s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)    //取诊断
		..s ^||CacheTemp(repid,ind)=$lb(name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId)
	 	..s ind=ind+1
	}elseif(version=2){
		//All代表全部，Complate代表完成，UnCom未完成，FE代表48小时内完成，OverFE超过48小时完成
		i depType="0" s findType="R"
		e  i depType="1" s findType="C" 
		
		//获取会诊的完成状态code
		s ConStatusCodeFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE")
		s ConStatusCodeNotFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE")
		set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
		d obj.Execute("",locId,SDate,EDate,"",findType)
		//b ;09
		f  Quit:'obj.Next()  d              
		.s ConsultId=obj.Data("CsItmID")
		.s CsStatCode=obj.Data("CsStatCode")  //会诊状态为空退出
		.q:CsStatCode<20   //不统计申请以下的数据
		.q:(otherType="All")&&('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))&&('$LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode))
		.q:(otherType="Complate")&&('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))
		.q:(otherType="UnCom")&&('$LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode))
		.s CstUserID=obj.Data("CstUserID")    //申请医生	 
		.s CstRLocID=obj.Data("CstRLocID")    //申请科室ID
		.s CsLocID=obj.Data("CsLocID")    //会诊科室
		.q:(CstRLocID="")||(CsLocID="")
		.s appDate=obj.Data("CstRDate") //会诊申请时间 
		.s appTime=obj.Data("CstRTime")
		.s conDate=obj.Data("CstNDate") 	//会诊日期
		.s conTime=obj.Data("CstNTime")		//会诊时间
		.;b ;09
		
		.i appDate'="" s appDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(appDate),3)
		.i appTime'="" s appTime=$zth(appTime)
		.i conDate'="" s conDate=$zdh(##class(DtPortal.Common.PublicService).dateFormat(conDate),3)
		.i conTime'="" s conTime=$zth(conTime)
		
		.s numTemp="" //会诊时长
		.s ifOverFe=""
		.s secondNum=0
		.i (conDate'="")&&(conTime'="") d
		..s secondNum=(conDate-appDate)*24*3600+(conTime-appTime)
		
		..;s numTemp=(conDate-appDate)*24+$fn((conTime-appTime)/3600,"",2)
		..;i (numTemp<1)&&(numTemp[".") s numTemp=+"0"_numTemp  //解决会诊时长小于1时，不显示小数点前的"0"，by yupeng
		.q:(otherType="FE")&&(('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))||(($LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))&&(secondNum>(48*3600))))
		.q:(otherType="OverFE")&&(('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))||(($LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))&&(secondNum<=(48*3600))))
		.s admId=obj.Data("EpisodeID")				//病人就诊ID
		.;w "admId==="_admId,!
		.q:admId=""
		.;b ;0922
		.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
		.s bedNo=$p(patInfoStr,"^",1)
		.s medicalNo=$p(patInfoStr,"^",5)
		.s name=$p(patInfoStr,"^",2)
		.s sex=$p(patInfoStr,"^",3)
		.s age=$p(patInfoStr,"^",4)
		.s admReason=$p(patInfoStr,"^",6)
		.s appLocId=CstRLocID
		.s applyLocDesc=$p($g(^CTLOC(appLocId)),"^",2)
		.i applyLocDesc["-" s applyLocDesc=$p(applyLocDesc,"-",2)
		.s applyDcotor=obj.Data("CstRUser")  //申请医生        
		.s applyTime=$zd(appDate,3)_"&nbsp;"_$zt(appTime)
		.s consultDcotor=obj.Data("CsUser")  //会诊医生 
		.s consultLocId=CsLocID
		.s consultLocDesc=$p($g(^CTLOC(consultLocId)),"^",2)
		.i consultLocDesc["-" s consultLocDesc=$p(consultLocDesc,"-",2)
		.s consultTime=""
		.i conDate'="" s consultTime=$zd(conDate,3)_"&nbsp;"_$zt(conTime)
		.s timeLength=..getTimeNum(secondNum)
		.s consultId=ConsultId
		.s patientId=$P($g(^PAADM(admId)),"^",1)
		.s diagnosis=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)    //取诊断
		.s CsStatDesc=obj.Data("CsStatDesc")  
		.s ^||CacheTemp(repid,ind)=$lb(name,sex,age,medicalNo,applyLocDesc,applyTime,applyDcotor,consultDcotor,consultLocDesc,consultTime,timeLength,consultId,diagnosis,patientId,admId,CsStatDesc)
	 	.s ind=ind+1
		
		
	}
	
	
	
	
	Quit $$$OK
}

/// Creator:    bmz
/// CreateDate: 2019-05-13
/// Descript:   时长的显示处理
/// InPut:    secondNum  
/// OutPut:     
/// w ##Class(DtPortal.MD.MD36Consultation).getTimeNum("")
ClassMethod getTimeNum(secondNum As %String) As %String
{
	n (secondNum)
	q:+secondNum=0 ""
	s hour=secondNum\3600
	s minute=(secondNum-(hour*3600))\60
	s second=secondNum-(hour*3600)-(minute*60)
	i (hour'=0){
		q hour_"时"_minute_"分"_second_"秒"
	}elseif(minute'=0){
		q minute_"分"_second_"秒"
	}elseif(second'=0){
		q second_"秒"
	}
}

}
