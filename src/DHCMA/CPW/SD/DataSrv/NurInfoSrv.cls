Class DHCMA.CPW.SD.DataSrv.NurInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMA.CPW.SD.DataSrv.NurInfoSrv).SynNurDataByAdm(605)
ClassMethod SynNurDataByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	//"收缩压","舒张压","脉搏","呼吸","心率","体重(kg)","身高","血氧饱和度","压疮风险评估"
	Set NurCode=##class(DHCMA.Util.BT.Config).GetValueByCode("SDNurCode")
	Set ParamList=$lfs(NurCode,",")
	Set:ParamList="" ParamList=$lb("sysPressure","diaPressure","pulse","breath","heartbeat","weight","height","degrBlood","Bedsore")
	Set inputStr=aEpisodeID
	/* //通过接口获取首次体温记录
	For xNurInd=1:1:$ll(ParamList) {
		Set param=$lg(ParamList,xNurInd)
		Set return=""
		Set return=##class(web.DHCMGNurComm).getFirstItemValue(aEpisodeID,param)
		Set inputStr=inputStr_$c(1)_return
	}*/
	Set Paadm=aEpisodeID
	Set MRAdm=$P(^PAADM(Paadm),"^",61)
	Set Count=0
	Set AdmDate=$p($g(^PAADM(Paadm,"DHC")),"^",31)
	For xDate=AdmDate:1:+$h{
		Set xItemDr="",xList=ParamList
		Continue:'$d(^MR(MRAdm,"OBS",0,"Date",xDate))
		For{
				Set xItemDr=$o(^MR(MRAdm,"OBS",0,"Date",xDate,xItemDr))
				Quit:xItemDr=""
				Set ItemCode=$p(^MRC("OBITM",xItemDr),"^",1)
				Set Targe=$lf(xList,ItemCode)
				Continue:Targe<1
				//取第一次测量值
				Set xSubID=$o(^MR(MRAdm,"OBS",0,"Date",xDate,xItemDr,0))
				Continue:xSubID=""
				Set Value=$p(^MR(MRAdm,"OBS",xSubID),"^",2)
				Set $list(xList,Targe)=Value
			}
		//将没有识别的xList中的代码识别为空
		For xListInd=1:1:$ll(xList) {
			Set:+$lg(xList,xListInd)=0 $list(xList,xListInd)=""
		}
		Set inputStr=aEpisodeID_$c(1)_xDate_$c(1)_$lts(xList,$c(1))
		Set ret=##class(DHCMA.CPW.SD.Data.NurInfo).Update(inputStr,$c(1))
		Set:+ret>0 Count=Count+1
 	}
	Quit Count
}

/// w ##class(DHCMA.CPW.SD.DataSrv.NurInfoSrv).GetDataByAdm()
ClassMethod GetDataByAdm(aEpisodeID As %String) As DHCMA.CPW.SD.Data.NurInfo
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set ret=""
	Set xID=$o(^DHCMA.CPW.SD.Data.NurInfoI("IdxAdm",aEpisodeID,0))
	Quit:xID="" ret
	Set ret=##class(DHCMA.CPW.SD.Data.NurInfo).GetObjById(xID)
	Quit ret
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.NurInfoSrv","QryNurInfo",605,"3||246")
Query QryNurInfo(aEpisodeID As %String, aItemID As %String) As %Query(ROWSPEC = "EpisodeID,RecDate,SBP,DBP,pulse,breath,heartRate,weight,height,satO2,braden")
{
}

ClassMethod QryNurInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="") $$$OK
 	Set Field="",return=""
 	If (aItemID'="") {
	 	//根据标准字典信息，标记特定信息
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(objItem) $$$OK
		Set aItemDesc=objItem.BTDesc
		Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
		If (DicID'="") {
			Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
			Set:(TabelInfo'="")&&(TabelInfo["Nur") Field=$p(TabelInfo,"^",2)
		}
 	}
 	Set xRowID="",GetFlg=0
 	For {
	 	Set xRowID=$o(^DHCMA.CPW.SD.Data.NurInfoI("IdxAdm",aEpisodeID,xRowID))
	 	Quit:xRowID=""
	 	Set xobj=##class(DHCMA.CPW.SD.Data.NurInfo).GetObjById(xRowID)
	 	Set RecDate=xobj.RecDate
	 	Set RecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(RecDate)
	 	//默认标记第一次体温测量值
	 	If (GetFlg=0)&&(Field'="") {
	 		Set $property(xobj,Field)="*"_$property(xobj,Field)	
	 		Set GetFlg=1
	 	} 
	 	Set SBP=xobj.SBP
	 	Set DBP=xobj.DBP
	 	Set pulse=xobj.pulse
	 	Set breath=xobj.breath
	 	Set heartRate=xobj.heartRate
	 	Set weight=xobj.weight
	 	Set height=xobj.height
	 	Set satO2=xobj.satO2
	 	Set braden=xobj.braden	
		Set Data=$lb(aEpisodeID,RecDate,SBP,DBP,pulse,breath,heartRate,weight,height,satO2,braden)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryNurInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNurInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNurInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNurInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
