/// 名称:DtPortal.DD.DD20TodayLocData
/// 描述:查询科室当日数据
/// 编写者:DanPJ
/// 编写日期:2020-12-01
Class DtPortal.DD.DD20TodayLocData Extends %RegisteredObject
{

/// DD20.01.01查询科室当日在院患者数量、入院患者数量、出院患者数量、空床数量、床位使用率
/// DanPJ 2020-12-01
/// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD20TodayLocData","DD200101","2020-12-01","2020-12-31","151^130^131^15^19")
Query DD200101(StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,PatientNum,InPatientNum,DisPatientNum,BedNum,EmptyBedNum,OccupiedBedNum,BedRate") [ SqlProc ]
{
}

ClassMethod DD200101Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	//quit:LocGroupId="" $$$OK
	
	if ((StartDate="")||(EndDate="")) set StartDate=EndDate=+$H			//如果没有传开始和结束日期，就默认查询当日数据
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	//是否包含不在床的患者  1-包含   其他-不包含
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")
	//获取住院科室ID串
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")
	//初始化数据
	set PatientNum=0,InPatientNum=0,DisPatientNum=0,BedNum=0,EmptyBedNum=0,OccupiedBedNum=0,BedRate=0.00
	for LocIndex=1:1:$l(LocStr,"^"){
		set LocId=$P(LocStr,"^",LocIndex)				//住院科室ID
		continue:LocId=""
		s locType=##class(DtPortal.Common.PublicService).getDeptType(LocId)
		//过滤掉非住院的科室
		if (locType'="I") continue
		//在院患者
		set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",LocId)  		//调用公共方法，获取各个科室患者串
		continue:PaadmStr=""
		set LocPatientNum=$length(PaadmStr,"^")
		set PatientNum=PatientNum+LocPatientNum
		
		
		//入院患者数量
		//^PAADMi("AdmTypeCurrLoc",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
		for AdmDate=StartDate:1:EndDate {
			set AdmTime=""
			for {
				set AdmTime=$o(^PAADMi("AdmTypeCurrLoc","I",LocId,AdmDate,AdmTime))	
				quit:AdmTime=""
				
				set AdmRowId=""
				for {
					set AdmRowId=$o(^PAADMi("AdmTypeCurrLoc","I",LocId,AdmDate,AdmTime,AdmRowId))
					quit:AdmRowId=""
					
					if (IfContainWaitPat'="1"){ //非1只取在床的患者
						s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(AdmRowId)
						continue:patInBed'=1   //过滤不在床位
					}
					
					set InPatientNum=InPatientNum+1	
				}
			}		
		}
		
		//出院患者数量
		//^PAADMi("DisDateDep",{PAADM_DepCode_DR},{PAADM_DischgDate},{PAADM_RowID})
		for AdmDisDate=StartDate:1:EndDate {
			set DisAdmRowId=""
			for {
				set DisAdmRowId=$o(^PAADMi("DisDateDep",LocId,AdmDisDate,DisAdmRowId))
				quit:DisAdmRowId=""
				
				set DisPatientNum=DisPatientNum+1	
			}	
		}
		
	}
	
	
	//科室床位使用情况
	set WardInLocStr=##class(DtPortal.Common.PublicService).getWardLocStrByLocIDStr(LocStr)			//获取住院科室关联的病区串
	set WardInLocNum=$length(WardInLocStr,"^")
	for WardInLocIndex=1:1:WardInLocNum {
		set WardLocId=$p(WardInLocStr,"^",WardInLocIndex)					//病区在Ct_Loc表中的ID
		continue:WardLocId=""		
		set WardId=$o(^PAWARD("0","WARD_LocationDR",WardLocId,""))			//pac_ward表中的病区ID
		continue:WardId=""													//过滤空的病区
		
		//^PAWARD(0,"WardRoom",{PAC_Ward.WARD_RowID},{BED_Room_DR},{BED_Childsub})
		set RoomDr=""
		for {
			set RoomDr=$o(^PAWARD(0,"WardRoom",WardId,RoomDr))
			quit:RoomDr=""
			
			set BedChildSub=""
			for {
				set BedChildSub=$o(^PAWARD(0,"WardRoom",WardId,RoomDr,BedChildSub))	
				quit:BedChildSub=""
				
				set BedRcFlag=$p($g(^PAWARD(WardId,"BED",BedChildSub)),"^",4)					//获取床位激活标识
				continue:BedRcFlag'="Y"															//过滤掉未激活床位
				
				set IsValid=##class(DtPortal.Common.PublicService).isValidBed(WardId_"||"_BedChildSub)			//调用公共方法，获取床位是否可用
				continue:IsValid'="1"							//1为有效床位，过滤掉无效床位
				
				set BedNum=BedNum+1								//总床位数
				
				
				//判断床位是否被占用
				set BedAvailable=$$CO18^at153(WardId_"||"_BedChildSub)  		//取床位是否可用标识
				set IfBedExist=##class(DtPortal.Common.PublicService).ifBaoChuang(WardId_"||"_BedChildSub)  //判断床位是否被占用
				continue:(BedAvailable="Y")&&(IfBedExist=0)			//过滤掉可用床位	
				
				set OccupiedBedNum=OccupiedBedNum+1					//占用床位数
				
			}	
		}	
	}
	set EmptyBedNum=BedNum-OccupiedBedNum						//空床数
	//床位使用率
	Set:BedNum'=0 BedRate=$fn(OccupiedBedNum/BedNum,"",4)*100
	if (BedRate[".")&&($p(BedRate,".",1)="") s BedRate="0"_BedRate
	
	set ^||CacheTemp(repid,ind)=$lb(ind,PatientNum,InPatientNum,DisPatientNum,BedNum,EmptyBedNum,OccupiedBedNum,BedRate)
	set ind=ind+1	
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// DD20.01.02查询科室当日在院患者信息
/// DanPJ 2020-12-01 Type:1-在院患者；2-入院患者
/// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD20TodayLocData","DD200102","2021-01-07","2021-01-07","168^170","1")
Query DD200102(StartDate As %String = "", EndDate As %String = "", LocGroupId As %String, Type As %String) As DtPortal.Query(ROWSPEC = "ind,BedNum,Name,Sex,Age,MedicareNo,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,NurseDesc,InDay,AdmDateTime,CareLevel,VitalSignStr,EMRDocID,EMRInstanceID,LocID") [ SqlProc ]
{
}

ClassMethod DD200102Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocGroupId As %String, Type As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	quit:((LocGroupId="")||(Type="")) $$$OK
	
	if ((StartDate="")||(EndDate="")) set StartDate=EndDate=+$H			//如果没有传开始和结束日期，就默认查询当日数据
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	//获取住院科室ID串
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")
	//是否包含不在床的患者  1-包含   其他-不包含
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")
	set AdmStr=""    	//初始化就诊号串
	for LocIndex=1:1:$l(LocStr,"^"){
		set LocId=$P(LocStr,"^",LocIndex)				//住院科室ID
		continue:LocId=""
		s locType=##class(DtPortal.Common.PublicService).getDeptType(LocId)
		//过滤掉非住院的科室
		if (locType'="I") continue
		//在院患者
		if Type="1" {
			set LocAdmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",LocId)  		//调用公共方法，获取各个科室患者串
			if AdmStr="" set AdmStr=LocAdmStr
			else  set AdmStr=AdmStr_"^"_LocAdmStr
		}
		if Type="2" {				//入院患者
			for AdmDate=StartDate:1:EndDate {
				set AdmTime=""
				for {
					set AdmTime=$o(^PAADMi("AdmTypeCurrLoc","I",LocId,AdmDate,AdmTime))	
					quit:AdmTime=""
				
					set AdmRowId=""
					for {
						set AdmRowId=$o(^PAADMi("AdmTypeCurrLoc","I",LocId,AdmDate,AdmTime,AdmRowId))
						quit:AdmRowId=""
						
						if (IfContainWaitPat'="1"){ //非1只取在床的患者
							s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(AdmRowId)
							continue:patInBed'=1   //过滤不在床位
						}
					
						if AdmStr="" set AdmStr=AdmRowId
						else  set AdmStr=AdmStr_"^"_AdmRowId
					}
				}
			}
		}
	}
	set LocPatientNum=$length(AdmStr,"^")
	for PaadmIndex=1:1:LocPatientNum {
		set AdmId=$P(AdmStr,"^",PaadmIndex)	
		continue:AdmId=""
		set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(+AdmId)
		set Name=$p(PatInfo,"^",2)											//姓名
		set Sex=$p(PatInfo,"^",3)											//性别
		set Age=$p(PatInfo,"^",4)											//年龄
		set MedicareNo=$p(PatInfo,"^",5)									//病案号
		set AdmReason=$p(PatInfo,"^",6)										//费用类别
		set BedNum=$p(PatInfo,"^",1)										//床号
		set RegNo=$p(PatInfo,"^",7)    										//登记号
 		set AdmDocDesc=$p(PatInfo,"^",11)									//主管医生
		set NurseDesc=$p(PatInfo,"^",12)									//主管护士
		set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(+AdmId)			//住院诊断
		set InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(+AdmId)					//住院天数
		set AdmDateTime=""
		set AdmDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(+AdmId)		//入院时间
		if $P(AdmDateTimeStr,"^",1)'="" set AdmDateTime=$zd($P(AdmDateTimeStr,"^",1),3)_"&nbsp;"_$zt($P(AdmDateTimeStr,"^",2),2)
					
		//护理级别
		set CareLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(+AdmId,ArcIDsNur)
		
		//生命体征
		Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(+AdmId)
		if VitalSignStr="^^^^^" set VitalSignStr=""
		if VitalSignStr'="" s VitalSignStr="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)	
			
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(+AdmId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set LocID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EMREpisodeID=$p(EMRinfo,"^",5)	
		set CPDocID=$p($g(^PAADM(+AdmId)),"^",9)     //主管医生
		set:CPDocID'="" UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
		set ^||CacheTemp(repid,ind)=$lb(ind,BedNum,Name,Sex,Age,MedicareNo,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,NurseDesc,InDay,AdmDateTime,CareLevel,VitalSignStr,EMRDocID,EMRInstanceID,LocID)
		set ind=ind+1	
				
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// DD20.01.03查询科室当日出院患者信息
/// DanPJ 2020-12-01
/// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD20TodayLocData","DD200103","2020-12-01","2020-12-31","151^130^131^15^19")
Query DD200103(StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,Name,Sex,Age,MedicareNo,RegNo,PatientID,LocDesc,WardDesc,DocDesc,NurseDesc,DiagnoseDesc,InDay,DischgDate") [ SqlProc ]
{
}

ClassMethod DD200103Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	quit:LocGroupId="" $$$OK
	
	if ((StartDate="")||(EndDate="")) set StartDate=EndDate=+$H			//如果没有传开始和结束日期，就默认查询当日数据
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	
	//获取住院科室ID串
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")
	//初始化数据
	set PatientNum=0,InPatientNum=0,DisPatientNum=0,BedNum=0,EmptyBedNum=0,OccupiedBedNum=0,BedRate=0.00
	for LocIndex=1:1:$l(LocStr,"^"){
		set LocId=$P(LocStr,"^",LocIndex)				//住院科室ID
		continue:LocId=""
		//出院患者数量
		//^PAADMi("DisDateDep",{PAADM_DepCode_DR},{PAADM_DischgDate},{PAADM_RowID})
		for AdmDisDate=StartDate:1:EndDate {
			set DisAdmRowId=""
			for {
				set DisAdmRowId=$o(^PAADMi("DisDateDep",LocId,AdmDisDate,DisAdmRowId))
				quit:DisAdmRowId=""
				set PatInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(+DisAdmRowId)
				set Name=$p(PatInfoStr,"^",2)								//姓名
				set Sex=$p(PatInfoStr,"^",3)								//性别
				set Age=$p(PatInfoStr,"^",4)								//年龄
				set MedicareNo=$p(PatInfoStr,"^",5) 						//病案号
				set AdmReason=$p(PatInfoStr,"^",6)							//费用类别
				set RegNo=$p(PatInfoStr,"^",7)								//登记号
				set PatientID=$p(PatInfoStr,"^",8)							//病人ID
				set LocDesc=$p(PatInfoStr,"^",9)							//病人科室
				set WardDesc=$p(PatInfoStr,"^",10)							//病人病区
				set DocDesc=$p(PatInfoStr,"^",11)							//主管医生
				set NurseDesc=$p(PatInfoStr,"^",12)						//主管护士
			
				set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(+DisAdmRowId)				//诊断
				set InDay=##class(DtPortal.Common.PaadmService).getInDayByOutPat(+DisAdmRowId)						//住院天数
				set DischgDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(+DisAdmRowId)		//出院时间
				set DischgDate=$zd($p(DischgDateTimeStr,"^",1),3)
				set DischgTime=$zt($p(DischgDateTimeStr,"^",2),2)
				set DischgDate=DischgDate_"&nbsp;"_DischgTime
			
				Set ^||CacheTemp(repid,ind)=$lb(ind,Name,Sex,Age,MedicareNo,RegNo,PatientID,LocDesc,WardDesc,DocDesc,NurseDesc,DiagnoseDesc,InDay,DischgDate)
				Set ind=ind+1
			}
		}
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

}
