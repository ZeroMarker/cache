/// 名称: DHCWMR.FPService.FrontPageGet
/// 描述: 编目基本信息取值相关服务
/// 编写者：zhufei
/// 编写日期: 2016-11-24
Class DHCWMR.FPService.FrontPageGet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-11-24
/// Description:  获取电子病历首页信息，转换为结构化存储(病案首页质量督导系统)
///               河南省人民医院调用的这个接口，希望其他医院调用MRQ中接口
/// Table：       DHCWMR.SS.Volume
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String668527
/// w ##class(DHCWMR.FPService.FrontPageGet).GetFrontPageToMRQ(1172492)
ClassMethod GetFrontPageToMRQ(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set $ZT="GetFrontPageToMRQError"
	
	Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeIDX(aEpisodeID)
	Quit:MrNo="" return
	Set return=##class(DHCWMR.IO.FromMRQSrv).GetEMRDataByAdm(aEpisodeID)
	Quit return
	
GetFrontPageToMRQError
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2014-11-24
/// Description:  获取病案首页基本信息
/// Table：       DHCWMR.FP.FPBaseInfo
/// Input：       aFrontPageID : 编目ID
///               aVolumeID : 卷ID
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FrontPageGet","QryFrontPageInfo","","26992")
Query QryFrontPageInfo(aFrontPageID As %String, aVolumeID As %String) As %Query(ROWSPEC = "DataCode:%String,DataValue:%String,FrontPageID:%String,VolumeID:%String,EpisodeID:%String") [ SqlProc ]
{
}

ClassMethod QryFrontPageInfoExecute(ByRef qHandle As %Binary, aFrontPageID As %String, aVolumeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aFrontPageID="")&&(aVolumeID="") $$$OK
 	
 	If aFrontPageID'="" {
	 	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	 	Quit:'$IsObject(objFrontPage) $$$OK
	 	Quit:'$IsObject(objFrontPage.FPVolumeDr) $$$OK
	 	Set FrontPageID=objFrontPage.%Id()
	 	Set VolumeID=objFrontPage.FPVolumeDr.%Id()
 	} Else {
	 	Set objValume=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	 	Quit:'$IsObject(objValume) $$$OK
	 	Set VolumeID=objValume.%Id()
	 	Set FrontPageID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolumeID,"F",0))
	 	If FrontPageID'="" {
			Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(FrontPageID)
			Quit:'$IsObject(objFrontPage) $$$OK
	 	}
 	}
	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
 	Quit:EpisodeID="" $$$OK
 	
 	//病案首页结构化存储(病案首页质量督导系统)
 	//update by zf 20170220 修改首页结构化存储接口调用
 	Set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
 	Set HospitalID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
 	Set GetCode=$s(FrontPageID'="":"Coding",1:"Clinic")
 	Set HospCode=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MRQHospitalCode",HospitalID)
 	Set arrData=##Class(DHCWMR.IO.FromMRQSrv).GetArrayOfDataByAdm(GetCode,HospCode,EpisodeID)
	Quit:'$IsObject(arrData) $$$OK
	//数据异常处理：取不到编目数据,取临床数据
 	If (GetCode="Coding")&&(arrData.Count()<1) {
	 	Set GetCode="Clinic"
	 	Set arrData=##Class(DHCWMR.IO.FromMRQSrv).GetArrayOfDataByAdm(GetCode,HospCode,EpisodeID)
		Quit:'$IsObject(arrData) $$$OK
 	}
	Quit:arrData.Count()<1 $$$OK
 	
	Set key=""
	For {
		Set value=arrData.GetNext(.key)
		Quit:key=""
	
		Set DataCode=key
		Set DataValue=arrData.GetAt(key)

	 	Set Data=$lb(DataCode,DataValue,aFrontPageID,aVolumeID,EpisodeID)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryFrontPageInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFrontPageInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFrontPageInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFrontPageInfoExecute ]
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

/// w ##class(DHCWMR.FPService.FrontPageGet).GetCostCode("其他费用")
ClassMethod GetCostCode(aDesc As %String) As %String
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set CostList=$lb("总费用","P60000000")
	Set CostList=CostList_$lb("手术用一次性医用材料费","P60250000")
	Set CostList=CostList_$lb("治疗用一次性医用材料费","P60240000")
	Set CostList=CostList_$lb("检查用一次性医用材料费","P60230000")
	Set CostList=CostList_$lb("其他费用","P60040000")
	Set CostList=CostList_$lb("影像学诊断费","P60070000")
	Set CostList=CostList_$lb("手术费","P60100200")
	Set CostList=CostList_$lb("一般医疗服务费","P60010000")
	Set CostList=CostList_$lb("一般治疗操作费","P60020000")
	Set CostList=CostList_$lb("护理费","P60030000")
	Set CostList=CostList_$lb("临床诊断项目费","P60080000")
	Set CostList=CostList_$lb("临床物理治疗费","P60090100")
	Set CostList=CostList_$lb("实验室诊断费","P60060000")
	Set CostList=CostList_$lb("病理诊断费","P60050000")
	Set CostList=CostList_$lb("非手术治疗项目费","P60090000")
	Set CostList=CostList_$lb("介入治疗费","P60270000")
	Set CostList=CostList_$lb("麻醉费","P60100100")
	Set CostList=CostList_$lb("康复费","P60110000")
	Set CostList=CostList_$lb("中医治疗费","P60130000")
	Set CostList=CostList_$lb("血费","P60180000")
	Set CostList=CostList_$lb("其他费","P60260000")
	Set CostList=CostList_$lb("西药费","P60150000")
	Set CostList=CostList_$lb("抗菌药物费用","P60150100")
	Set CostList=CostList_$lb("中成药费","P60160000")
	Set CostList=CostList_$lb("中草药费","P60170000")
	Set CostList=CostList_$lb("白蛋白类制品费","P60190000")
	Set CostList=CostList_$lb("球蛋白类制品费","P60200000")
	Set CostList=CostList_$lb("凝血因子类制品费","P60210000")
	Set CostList=CostList_$lb("细胞因子类制品费","P60220000")
	
	Set ind=$ListFind(CostList,aDesc)
	Quit:ind<1 return
	Set Code=$Lg(CostList,ind+1)
	Quit Code
}

}
