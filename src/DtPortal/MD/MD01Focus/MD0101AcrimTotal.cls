/// 名称:  DtPortal.MD.MD01Focus.MD0101AcrimTotal
/// 描述: 查询全院某医嘱项目服务
/// 编写者：程鹏
/// 编写日期:2018-12-18
Class DtPortal.MD.MD01Focus.MD0101AcrimTotal Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator： 程鹏
/// CreatDate： 2018-12-18
/// Description: 查询全院当前某医嘱项目总人数
/// Input：     ArcCode  医嘱项目Code(his医嘱配置中维护)
/// 		    hospitalId  院区ID     
/// Return：   医嘱总人数
/// w ##class(DtPortal.MD.MD01Focus.MD0101AcrimTotal).GetAcrimNum("CRITICALLY","")
ClassMethod GetAcrimNum(ArcCode As %String, hospitalId As %String = "") As %String
{
	
	Set $ZT = "ErrGetAcrimNum"
	
    d ##class(DtPortal.Common.PaadmService).GetArcData(+$h,ArcCode)
    set num=0
	set ward=""
	for
	{
		set ward=$o(^||TEMPPortalArcData($j,ward))
		quit:ward=""
		
		set wardLoc=$p(^PAWARD(ward),"^",5)
		set hospID=$p(^CTLOC(wardLoc),"^",22)
		continue:(hospitalId'="")&&(hospitalId'=hospID)
		set num=num+^||TEMPPortalArcData($j,ward)
	}
	
	k ^||TEMPPortalArcData($j)

	Quit num
	
ErrGetAcrimNum

	Quit -1
}

/// Creator： 程鹏
/// CreatDate： 2018-12-18
/// Description: 取全院各个病区有某医嘱的人数
/// Input：     ArcCode  医嘱项目Code(his医嘱配置中维护)
/// 		    hospitalId  院区ID  
/// Return： 病区Id,病区名称,人数,
/// 服务编码：MD01.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0101AcrimTotal","MD010101","CRITICALLY","")
Query MD010101(ArcCode As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "WardID,WardDesc,WardNum1")
{
}

ClassMethod MD010101Execute(ByRef qHandle As %Binary, ArcCode As %String, hospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 
    d ##class(DtPortal.Common.PaadmService).GetArcData(+$h,ArcCode)
    set num=0
	set ward=""
	for
	{
		set ward=$o(^||TEMPPortalArcData($j,ward))
		quit:ward=""
		
		set wardLoc=$p(^PAWARD(ward),"^",5)
		set hospID=$p(^CTLOC(wardLoc),"^",22)
		continue:(hospitalId'="")&&(hospitalId'=hospID)
		
		set WardNum1=$G(^||TEMPPortalArcData($j,ward))
		s WardDesc=$p(^PAWARD(ward),"^",2)
		set Data=$lb(ward,WardDesc,WardNum1)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
		
	}
    
    
    
    k ^||TEMPPortalArcData($j)
	
  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-18
/// Description: 查询某病区有某医嘱的患者详情
/// Input：     ArcCode  医嘱项目Code(his医嘱配置中维护)
/// 		    WardId  病区ID     
/// Return： 
/// 服务编码：MD01.01.02
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD01Focus.MD0101AcrimTotal","MD010102","CRITICALLY",5,"")
Query MD010102(ArcCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,NurseLevel,VitalSign,EpisodeId,PatientID,ArcDesc")
{
}

ClassMethod MD010102Execute(ByRef qHandle As %Binary, ArcCode As %String, WardId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	//根据配置医嘱code取医嘱ID,取全部护理
	set NueLeveArcIDs=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)	
	
	//要查询的医嘱ID串串
	set ArcIDs=##Class(DtPortal.Configure.arcim).getArcImID(ArcCode,1)	
	

	Set EpisodeIdStr=""
	Set EpisodeIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",WardId)
	Quit:EpisodeIdStr="" $$$OK
	
	Set inNNum=$l(EpisodeIdStr,"^")

	for i=1:1:inNNum
	{
		set EpisodeId=$p(EpisodeIdStr,"^",i)
			
		set ArcDesc=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,ArcIDs,+$h)
		continue:ArcDesc=""
		
		set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
		set BedCode=$p(patInfoStr,"^",1)
		set Name=$p(patInfoStr,"^",2)
		set Sex=$p(patInfoStr,"^",3)
		set Age=$p(patInfoStr,"^",4)
		set MedicareNo=$p(patInfoStr,"^",5)   //病案号
		set AdmReason=$p(patInfoStr,"^",6)    //费用类型
		set Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId) //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		
		s NurseLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,NueLeveArcIDs)
		
		set VitalSign=""
		Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(EpisodeId)
		if VitalSignStr'="" s VitalSign="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)_"mmHg"
		s PatientID=$P($g(^PAADM(EpisodeId)),"^",1)
		
		set Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,NurseLevel,VitalSign,EpisodeId,PatientID,ArcDesc)
	 	set ^||CacheTemp(repid,ind)=Data	
	 	set ind=ind+1
		
	}
	
	k ^||TEMPPortalArcData($j)
  	q $$$OK
}

}
