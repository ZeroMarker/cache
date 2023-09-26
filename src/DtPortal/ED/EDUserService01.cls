Class DtPortal.ED.EDUserService01 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取第一条用户的急诊登录科室数据
/// zw ##class(DtPortal.ED.EDUserService01).ED000001("ys01")
ClassMethod ED000001(userCode As %String) As DtPortal.OutPut
{
	new (userCode)
	
	Set ret = ##class(DtPortal.OutPut).%New()
	set status=1,data="",errMSG=""
	try{
		s locID=0,locDesc=0
		s EmLoginInfo=##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo(userCode)
		if (EmLoginInfo=""){
			s status=-1
			s errMSG="当前用户未关联急诊科室"
			g ED000001Ret
		}
		set locID=$p(EmLoginInfo,"^")
		set:locID'="" locDesc=$p(^CTLOC(locID),"^",2)
		set:locDesc["-" locDesc=$p(locDesc,"-",2)
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		
		d jsonObj.Put("locID",locID)
		d jsonObj.Put("locDesc",locDesc)

		Set status = 1
		Set errMSG = ""
		Set data = "["_jsonObj.Json()_"]"
		g ED000001Ret
		
	}catch{
		Set status = -1
		Set errMSG = $ZE
		Set data = ""
		g ED000001Ret
	}
	
ED000001Ret
	Set ret.status = status
	Set ret.errMSG = errMSG
	Set ret.data = data
	Quit ret
}

/// d ##class(%ResultSet).RunQuery("DtPortal.ED.EDUserService01","ED010001","ys01")
Query ED010001(userCode As %String) As DtPortal.Query(ROWSPEC = "observingNum,rescueNum") [ SqlProc ]
{
}

ClassMethod ED010001Execute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	new (qHandle,userCode)
	Set repidE1=$I(^||CacheTemp)
	Set qHandle=$lb(0,repidE1,0)
	Set indED010001=1
	
	s lgNum=0,qjNum=0
	s EmLoginInfo=##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo(userCode)
	q:EmLoginInfo="" $$$OK
	set locID=$p(EmLoginInfo,"^")
	Set object = ##class(%ResultSet).%New("web.DHCEMInterfaceCom:QueryStayAdm")
	
	Do object.Execute(locID,"")
	While (object.Next()) {
		s wardInfo=object.Data("ward")
		if (wardInfo["留观"){
			s lgNum=lgNum+1
		}elseif(wardInfo["抢救"){
			s qjNum=qjNum+1
		}
		
	}
	s observingNum=lgNum,rescueNum=qjNum
	
	d outPutED010001
	
	q $$$OK
outPutED010001
    s Data=$lb(observingNum,rescueNum)
    
 	s ^||CacheTemp(repidE1,indED010001)=Data	
 	s indED010001=indED010001+1
	q
}

/// 获取急诊分级数量
/// zw ##class(DtPortal.ED.EDUserService01).ED010002("ys01")
ClassMethod ED010002(userCode As %String) As DtPortal.OutPut
{
	new (userCode)
	
	Set ret = ##class(DtPortal.OutPut).%New()
	set status=1,data="",errMSG=""
	try{
		s redNum=0,orangeNum=0,yellowNum=0,greenNum=0
		s EmLoginInfo=##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo(userCode)
		if (EmLoginInfo=""){
			s status=-1
			s errMSG="当前用户未关联急诊科室"
			g ED010002Ret
		}
		set locID=$p(EmLoginInfo,"^")
		Set object = ##class(%ResultSet).%New("web.DHCEMInterfaceCom:QueryStayAdm")
		
		Do object.Execute(locID,"")
		While (object.Next()) {
			s EpisodeID=object.Data("Episode")
			
			s Area=##Class(DtPortal.Common.PaadmService).GetEPatZone(EpisodeID)
			if (Area="红区"){
				s redNum=redNum+1
			}elseif(Area="橙区"){
				s orangeNum=orangeNum+1
			}elseif(Area="黄区"){
				s yellowNum=yellowNum+1
			}elseif(Area="绿区"){
				s greenNum=greenNum+1
			}
			
		}
		
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("redNum",redNum)
		d jsonObj.Put("orangeNum",orangeNum)
		d jsonObj.Put("yellowNum",yellowNum)
		d jsonObj.Put("greenNum",greenNum)
		Set status = 1
		Set errMSG = ""
		Set data = "["_jsonObj.Json()_"]"
		g ED010002Ret
		
	}catch{
		Set status = -1
		Set errMSG = $ZE
		Set data = ""
		g ED010002Ret
	}
	
ED010002Ret
	Set ret.status = status
	Set ret.errMSG = errMSG
	Set ret.data = data
	Quit ret
}

/// 获取待转入院和绿色通道数量
/// zw ##class(DtPortal.ED.EDUserService01).ED010003("ys01")
ClassMethod ED010003(userCode As %String) As DtPortal.OutPut
{
	new (userCode)
	Set ret = ##class(DtPortal.OutPut).%New()
	set status=1,data="",errMSG=""
	try{
		s inPatNum=0,greenChannelNum=0
		s EmLoginInfo=##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo(userCode)
		if (EmLoginInfo=""){
			s status=-1
			s errMSG="当前用户未关联急诊科室"
			g ED010003Ret
		}
		
		s waitAdmStr=##class(DtPortal.ED.EDUserService01).getWaitToHosPat()
		
		set locID=$p(EmLoginInfo,"^")
		Set object = ##class(%ResultSet).%New("web.DHCEMInterfaceCom:QueryStayAdm")
		
		Do object.Execute(locID,"")
		While (object.Next()) {
			s EpisodeID=object.Data("Episode")
			s isInPat=##Class(web.DHCEMInterfaceCom).getInhospitalFlag(EpisodeID)
			//if isInPat=1 set inPatNum=inPatNum+1
			if $LF($LISTFROMSTRING(waitAdmStr,"^"),EpisodeID) set inPatNum=inPatNum+1
			s isGreenChannelNum=##class(web.DHCEMInterfaceCom).CheckGreenRec(EpisodeID)
			if isGreenChannelNum=1 set greenChannelNum=greenChannelNum+1
		}
		set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("inPatNum",inPatNum)
		d jsonObj.Put("greenChannelNum",greenChannelNum)
		Set status = 1
		Set errMSG = ""
		Set data = "["_jsonObj.Json()_"]"
		g ED010003Ret
	}catch{
		Set status = -1
		Set errMSG = $ZE
		Set data = ""
		g ED010003Ret
	}
	
ED010003Ret
	Set ret.status = status
	Set ret.errMSG = errMSG
	Set ret.data = data
	Quit ret
}

/// 获取待转入院的就诊id串
/// w ##class(DtPortal.ED.EDUserService01).getWaitToHosPat(+$h-300,$h)
ClassMethod getWaitToHosPat(StartDate = "", EndDate = "")
{
	new (StartDate,EndDate)
	s EpisodeIDStr=""
	if (StartDate="")||(EndDate="") {
		s StartDate=+$h-300
		s EndDate=+$h
	}
	
	F dd=StartDate:1:EndDate D
	.s WtID=""
	.F  s WtID=$o(^DHCEMWH(0,"CreateDate",dd,WtID)) Q:WtID=""  D
	..Q:$p(^DHCEMWH(WtID),"^",6)'="Y"
	..s EpisodeID=$p(^DHCEMWH(WtID),"^",1)        /// 就诊ID
	..q:EpisodeID=""
	..i EpisodeIDStr="" s EpisodeIDStr=EpisodeID
	..e  s EpisodeIDStr=EpisodeIDStr_"^"_EpisodeID
	q EpisodeIDStr
}

/// 获取急诊患者列表
/// otherType 1-待转入院  2-绿色通道
/// d ##class(%ResultSet).RunQuery("DtPortal.ED.EDUserService01","ED010101","ys01","抢救")
Query ED010101(userCode As %String, type As %String = "", EZoneType As %String = "", otherType As %String = "") As DtPortal.Query(ROWSPEC = "wardInfo,EpisodeID,BedNo,MedicareNo,Name,Sex,Age,AdmReason,EMRDocID,EMRLocID,EMRInstanceID,locID,PatientID,InTime,DiagnoseDesc,UserID,currELevel,preELevel,ifNewIn") [ SqlProc ]
{
}

ClassMethod ED010101Execute(ByRef qHandle As %Binary, userCode As %String, type As %String = "", EZoneType As %String = "", otherType As %String = "") As %Status
{
	new (qHandle,userCode,type,EZoneType,otherType)
	Set repidED010101=$I(^||CacheTemp)
	Set qHandle=$lb(0,repidED010101,0)
	Set indED010101=1
	
	s EmLoginInfo=##class(DtPortal.Common.PublicService).GetSingleEmLoginInfo(userCode)
	q:EmLoginInfo="" $$$OK
	
	//
	s waitAdmStr=##class(DtPortal.ED.EDUserService01).getWaitToHosPat()
	
	set locID=$p(EmLoginInfo,"^")
	Set object = ##class(%ResultSet).%New("web.DHCEMInterfaceCom:QueryStayAdm")
	
	Do object.Execute(locID,"")
	
	While (object.Next()) {
		s wardInfo=object.Data("ward")
		if (wardInfo'[type){
			continue
		}
		s EpisodeID=object.Data("Episode")
		
		if (EZoneType'=""){
			//急诊分区类型
			s area=##Class(DtPortal.Common.PaadmService).GetEPatZone(EpisodeID)
			if EZoneType'=area continue
		}
		
		if (otherType'=""){
			if (otherType=1){
				//s typeTemp=##Class(web.DHCEMInterfaceCom).getInhospitalFlag(EpisodeID)
				//continue:typeTemp'=1
				continue:'$LF($LISTFROMSTRING(waitAdmStr,"^"),EpisodeID)
				
			}elseif(otherType=2){
				s typeTemp=##Class(web.DHCEMInterfaceCom).CheckGreenRec(EpisodeID)
				continue:typeTemp'=1
			}
			
		}
		
		
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		s BedNo=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s Name=$p(patInfoStr,"^",2)
		s Sex=$p(patInfoStr,"^",3)
		s Age=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		s InTime=""
		s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
		s InDate=$p(inDateTimeStr,"^",1)
		
		//是否新入院  1-新入院    其他-非新入院
		s ifNewIn="99"
		if (InDate=+$h){
			s ifNewIn="1"
		}
		
		s InTime=$p(inDateTimeStr,"^",2)
		i InDate'="" s InDate=$zd(InDate,3)
		i InTime'="" s InTime=$zt(InTime,2)
		
		s InTime=InDate_"&nbsp;"_InTime   //加空格，用于前台显示
		
		//##Class(web.DHCEMInterfaceCom).GetPatChkLvCareInfo---抢救
		
		s PAAdmDate=$ZD($P($g(^PAADM(EpisodeID)),"^",6),3)
		
		
		s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set EMRLocID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)

		set preELevel=##Class(web.DHCEMInterfaceCom).GetEmPatCheckArea(EpisodeID)  //预检分区
		set currELevel=##Class(DtPortal.Common.PaadmService).GetEPatZone(EpisodeID)	//当前分区
		d outPut
	}
	d object.Close()
	
	q $$$OK
outPut
    s Data=$lb(wardInfo,EpisodeID,BedNo,MedicareNo,Name,Sex,Age,AdmReason,EMRDocID,EMRLocID,EMRInstanceID,locID,PatientID,InTime,DiagnoseDesc,UserID,currELevel,preELevel,ifNewIn)
 	s ^||CacheTemp(repidED010101,indED010101)=Data	
 	s indED010101=indED010101+1
	q
}

}
