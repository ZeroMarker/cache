Class DHCMA.VTE.DI.PAADM Extends %RegisteredObject
{

/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.PAADM","QryPaadmByDate","2019-01-01","2019-01-01")
Query QryPaadmByDate(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "PatientID:%String,xEpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,IdentityCode:%String,Nation:%String,HomeAddress:%String,DeathDate:%String,DeathTime:%String,IsDeath:%String,AdmLoc:%String,AdmLocCode:%String,AdmLocDesc:%String,AdmWard:%String,AdmWardCode:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischWard:%String,DischWardCode:%String,DischWardDesc:%String,DischDate:%String,DischTime:%String,AdmDocDr:%String,AdmDocCode:%String,AdmDocDesc:%String,VisitStatus:%String,Height:%String,Weight:%String,PACondition:%String,UserDocID:%String,RelativeTel:%String,temperature:%String,pulse:%String,heartbeat:%String,breath:%String,sysPressure:%String,diaPressure:%String,cost:%String,PAAdmTimes:%String") [ SqlProc ]
{
}

ClassMethod QryPaadmByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set $ZT="AutoTaskErr"
	//出院患者
	Set DischDateIndex=""  //取出院时间索引 赋空值
	If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
		Set DischDateIndex="DischargeDateExt"
	} Else {
		Set DischDateIndex="DischDate"
	}
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi(DischDateIndex,xDate,xEpisodeID))
			Quit:xEpisodeID=""
			Set AdmStr = $g(^PAADM(+xEpisodeID))
			//出院患者过滤就诊状态为A的患者  出院日期为医生下达时间时
			If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
				Continue:$p(AdmStr,"^",20)="A" 
			}
			Do SyncAdmByEpisodeID
		}
	}
	//在院患者
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAADMi("CurrWard",xWardID,xRoomID,xEpisodeID))
				Quit:xEpisodeID=""
				Do SyncAdmByEpisodeID
			}
		}
	}
	
	//退院患者
	For xDate=aDateFrom:1:aDateTo{
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi("UpdDate",xDate,xEpisodeID))
			Quit:xEpisodeID=""
			Set VisitStatus = $p($g(^PAADM(+xEpisodeID)),"^",20)	//就诊状态 C为退院
			Continue:VisitStatus'="C"
			Do SyncAdmByEpisodeID
		}
	}
	
	Quit $$$OK
SyncAdmByEpisodeID
	Set AdmStr = $g(^PAADM(+xEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	//就诊类型
	Set PatientID = $p(AdmStr,"^",1)	//病人标识
	//考虑 急诊留观患者
	Quit:(AdmType'="I") 
	Quit:'$d(^PAPER(PatientID,"ALL")) 
	///////////////////病人信息///////////////////////////
	Set PapmiNo  	= $p($g(^PAPER(PatientID,"PAT",1)),"^",1)	//登记号
	Set PatName  	= $p($g(^PAPER(PatientID,"ALL")),"^",1)		//姓名	
	Set BirthDay 	= $p($g(^PAPER(PatientID,"ALL")),"^",6)		//生日
	Set HomeAddress	= $g(^PAPER(PatientID,"PER","ADD",1))		//家庭住址
	Set Company		= $p($g(^PAPER(PatientID,"PER",4)),"^",18)	//公司	
	Set RelativeName= $p($g(^PAPER(PatientID,"PER",2)),"^",13)	//联系人
	Set RelativeTel	= $p($g(^PAPER(PatientID,"ALL")),"^",4)		//联系人电话
	Set DeathDate	= $p($g(^PAPER(PatientID,"ALL")),"^",13)	//死亡日期
	Set DeathTime	= $p($g(^PAPER(PatientID,"ALL")),"^",8)		//死亡时间
	Set IsDeath  	= $s(DeathDate'="":1,1:0)					//是否死亡
	Set Nation 		= $p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)		//民族
	Set IdentityCode= $p($g(^PAPER(PatientID,"ALL")),"^",9)		//身份证号
	Set Sex	 = $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	//Set Sex	 = $s(Sex="男":"M",Sex="女":"F",1:"O")				//性别
	Set MrNo = $p($g(^PAPER(PatientID,"PAT",1)),"^",22)  //病案号
	if MrNo=""{
		Set MrNo = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(+xEpisodeID)	
	}
	
	
	//从体温单获取身高体重信息
	Set Mradm= $p(AdmStr,"^",61)	//mradm
	s ItmDrWeight="73"  //体重
	s ItmDrHeight="74"  //身高
	Set Height= 0 ;
	Set Weight= 0 ;
	i ((Mradm'="")&&($d(^MR(Mradm))))
	{
		s Date=0
		f {
			s Date=$o(^MR(Mradm,"OBS",0,"Date",Date))
			q:Date=""
			i $d(^MR(Mradm,"OBS",0,"Date",Date,ItmDrWeight))
			{
				s SubOBS="" 
				f {
					s SubOBS=$o(^MR(Mradm,"OBS",0,"Date",Date,ItmDrWeight,SubOBS))
					q:SubOBS=""
					s Weight=$p($g(^MR(Mradm,"OBS",SubOBS)),"^",2)
				}
			}
			i $d(^MR(Mradm,"OBS",0,"Date",Date,ItmDrHeight))
			{
				s SubOBS="" 
				f {
					s SubOBS=$o(^MR(Mradm,"OBS",0,"Date",Date,ItmDrHeight,SubOBS))
					q:SubOBS=""
					s Height=$p($g(^MR(Mradm,"OBS",SubOBS)),"^",2)
				}
			}
		}
	}
	
	//获取最后一次体温、脉搏、心率、呼吸、收缩压、舒张压
	set temperature = 0
	set pulse = 0
	set heartbeat = 0
	set breath = 0
	set sysPressure = 0
	set diaPressure = 0
	//判断该方法是否存在
	set retObservations=##class(%Dictionary.MethodDefinition).%ExistsId("EMRservice.HISInterface.PatientInfoAssist||GetPatObservationsNew")
	if retObservations'=0{
		set patObservations = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatObservationsNew(xEpisodeID)
		set lastPatObservations = $p(patObservations,"@",2)
		set temperature =$p($p(lastPatObservations,"^",1),":",2)  //体温
		set pulse =$p($p(lastPatObservations,"^",2),":",2)  //脉搏
		set heartbeat =$p($p(lastPatObservations,"^",3),":",2)  //心率
		set breath =$p($p(lastPatObservations,"^",4),":",2)  //呼吸
		set sysPressure =$p($p(lastPatObservations,"^",5),":",2)  //收缩压
		set diaPressure =$p($p(lastPatObservations,"^",6),":",2)  //舒张压
	}
	

	//费用
	set cost = 0
	set retCostTrakCare = ##class(%Dictionary.MethodDefinition).%ExistsId("EMRservice.HISInterface.PatientInfoAssist||InPatCostTrakCareNew")
	if retCostTrakCare'=0{
		set costStr = ##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(xEpisodeID,"")
		if costStr'=""{
			set cost = $p($p(costStr,"!",1),"^",3)
		}
	}
	
	
	//通过诊断获取身高、体重
	;Set MRRowId = $p(^PAADM(xEpisodeID),"^",61)
	;Set Weight = $p(^MR(MRRowId,"PRO",1),"^",27)
	;Set Height = $p(^MR(MRRowId,"PRO",1),"^",20)
	
			
	//就诊信息
	Set VisitStatus = $p(AdmStr,"^",20)	//就诊状态
	Set AdmDate	= "",AdmTime = ""		//入院日期 入院时间
	/*If ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(AdmType="I")){
		Set AdmDate=$p($g(^PAADM(xEpisodeID,"DHC")),"^",31)
		Set AdmTime=$p($g(^PAADM(xEpisodeID,"DHC")),"^",32)
		//按分床日期为入院日期时，若为空，计算住院日期时导致问题 
		If (AdmDate="")&&(AdmTime=""){
			Set AdmDate=$p($g(^PAADM(xEpisodeID)),"^",6)
			Set AdmTime=$p($g(^PAADM(xEpisodeID)),"^",7)
		}
	}Else{
		Set AdmDate=$p($g(^PAADM(xEpisodeID)),"^",6)
		Set AdmTime=$p($g(^PAADM(xEpisodeID)),"^",7)
	}*/
	Set AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(xEpisodeID,"")
	Quit:AdmDateTime="" 
	
	Set AdmDate=$p(AdmDateTime,",",1)
	Set AdmTime=$p(AdmDateTime,",",2)
	
	Set AdmLoc	= $p(AdmStr,"^",4)						//入院科室
	Set HospID  = $p($g(^CTLOC(AdmLoc)),"^",22)			//医院ID
	Set HospCode = $p($g(^CT("HOSP",HospID)),"^",1)		//医院CODE
	Set AdmLocCode = $p($g(^CTLOC(AdmLoc)),"^",1)		//入院科室代码
	Set AdmLocDesc = $p($g(^CTLOC(AdmLoc)),"^",2)		//入院科室描述
	Set AdmWard	= $p(AdmStr,"^",70)						//入院病区
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)			//病区科室转换一下
	Set AdmWardCode = $p($g(^CTLOC(+AdmWard)),"^",1)	//科室代码
	Set AdmWardDesc = $p($g(^CTLOC(+AdmWard)),"^",2)	//科室描述
	Set AdmRoom	= $p(AdmStr,"^",69)						//房间
	Set AdmBed	= $p(AdmStr,"^",73)						//床号
	Set:AdmBed'="" AdmBed = $p($g(^PAWARD(+AdmBed,"BED",$p(AdmBed,"||",2))),"^",1)
	Quit:(AdmBed="") 
	Set DischDate="",DischTime=""	//出院日期 出院时间
	If $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y"{
		Set DischDate=$p($g(^PAADM(xEpisodeID,"DHC")),"^",29)
		Set DischTime=$p($g(^PAADM(xEpisodeID,"DHC")),"^",30)
		If (DischDate="")&&(DischTime=""){
				Set DischDate=$p($g(^PAADM(xEpisodeID)),"^",17)
				Set DischTime=$p($g(^PAADM(xEpisodeID)),"^",18)
			}
	}Else{
		Set DischDate=$p($g(^PAADM(xEpisodeID)),"^",17)
		Set DischTime=$p($g(^PAADM(xEpisodeID)),"^",18)
	}
	//如果退院，出院日期同入院日期
	if VisitStatus="C"{
		Set DischDate = AdmDate
		Set DischTime = AdmTime
	}
	//死亡患者没有出院日期，把出院日期赋值为死亡日期
	set:DischDate="" DischDate = DeathDate
	set:DischTime="" DischTime = DeathTime
	
	Set DischLoc  = $s(DischDate'="":AdmLoc,"1":"")		//如果有出院日期，出院科室为当前科室
	Set (DischLocCode,DischLocDesc)=""
	if DischLoc'=""{
		Set DischLocCode = $p($g(^CTLOC(DischLoc)),"^",1)	//出院科室代码
		Set DischLocDesc = $p($g(^CTLOC(DischLoc)),"^",2)	//出院科室描述
	}
	Set DischWard = $s(DischDate'="":AdmWard,"1":"")	//如果有出院日期，出院病区为当前病区
	Set (DischWardCode,DischWardDesc)=""
	if DischWard'=""{
		Set DischWardCode = $p($g(^CTLOC(DischWard)),"^",1)	//出院病区代码
		Set DischWardDesc = $p($g(^CTLOC(DischWard)),"^",2)	//出院病区描述
	}
	If DischDate'="" {
		//Set AdmDays=DischDate-AdmDate+1
		Set AdmDays=DischDate-AdmDate   //修复bug:557856统一住院天数计算
		Set:AdmDays<1 AdmDays=1
	} Else {
		Set AdmDays=-1
	}
	

	Set IsActive = 1
	Set:(VisitStatus="P")||(VisitStatus="C") IsActive =0
	
	//add by chenjb 就诊次数
	Set PAAdmTimes	= $p(AdmStr,"^",29)
	//add by zhufei 主管医生
	Set AdmDocDr    = $p(AdmStr,"^",9)  //主管医生
	Set AdmDocCode="",AdmDocDesc="",UserDocID=""
	If AdmDocDr'="" {
		Set AdmDocCode=$p($g(^CTPCP(AdmDocDr,1)),"^",1)
		Set AdmDocDesc=$p($g(^CTPCP(AdmDocDr,1)),"^",2)
		//根据医护表CT_CareProv中的rowid查询用户表SS_User中的rowid，因为页面只能获取到用户表中的rowid
		//把UserDocID写入vte库中的PAADM表中的PAADMDOC 
		Set UserDocID = $o(^SSU("SSUSR",0,"CTPCP",AdmDocDr,"")) 
	}
	Set PAAdmDoc=AdmDocDr_"|"_AdmDocCode_"|"_AdmDocDesc
	Set PACondition= 0
	Set Data = $lb(PatientID,xEpisodeID,PapmiNo,MrNo,PatName,Sex,BirthDay,IdentityCode,Nation,HomeAddress,DeathDate,DeathTime,IsDeath,AdmLoc,AdmLocCode,AdmLocDesc,AdmWard,AdmWardCode,AdmWardDesc,AdmRoom,AdmBed,AdmDate,AdmTime,DischWard,DischWardCode,DischWardDesc,DischDate,DischTime,AdmDocDr,AdmDocCode,AdmDocDesc,VisitStatus,Height,Weight,PACondition,UserDocID,RelativeTel,temperature,pulse,heartbeat,breath,sysPressure,diaPressure,cost,PAAdmTimes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
AutoTaskErr
	Quit $$$OK
}

ClassMethod QryPaadmByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPaadmByDateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPaadmByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPaadmByDateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.PAADM","QryPaAdmById","20692316")
Query QryPaAdmById(xEpisodeID As %String) As %Query(ROWSPEC = "PatientID:%String,xEpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,BirthDay:%String,IdentityCode:%String,Nation:%String,HomeAddress:%String,DeathDate:%String,DeathTime:%String,IsDeath:%String,AdmLoc:%String,AdmLocCode:%String,AdmLocDesc:%String,AdmWard:%String,AdmWardCode:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischWard:%String,DischWardCode:%String,DischWardDesc:%String,DischDate:%String,DischTime:%String,AdmDocDr:%String,AdmDocCode:%String,AdmDocDesc:%String,VisitStatus:%String,Height:%String,Weight:%String,PACondition:%String,UserDocID:%String,RelativeTel:%String,temperature:%String,pulse:%String,heartbeat:%String,breath:%String,sysPressure:%String,diaPressure:%String,cost:%String,PAAdmTimes:%String") [ SqlProc ]
{
}

ClassMethod QryPaAdmByIdExecute(ByRef qHandle As %Binary, xEpisodeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set $ZT="AutoTaskErr"
	Set AdmStr = $g(^PAADM(+xEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	//就诊类型
	Set PatientID = $p(AdmStr,"^",1)	//病人标识
	//考虑 急诊留观患者
	Quit:(AdmType'="I") $$$OK
	Quit:'$d(^PAPER(PatientID,"ALL")) $$$OK
	///////////////////病人信息///////////////////////////
	Set PapmiNo  	= $p($g(^PAPER(PatientID,"PAT",1)),"^",1)	//登记号
	Set PatName  	= $p($g(^PAPER(PatientID,"ALL")),"^",1)		//姓名	
	Set BirthDay 	= $p($g(^PAPER(PatientID,"ALL")),"^",6)		//生日
	Set HomeAddress	= $g(^PAPER(PatientID,"PER","ADD",1))		//家庭住址
	Set Company		= $p($g(^PAPER(PatientID,"PER",4)),"^",18)	//公司	
	Set RelativeName= $p($g(^PAPER(PatientID,"PER",2)),"^",13)	//联系人
	Set RelativeTel	= $p($g(^PAPER(PatientID,"ALL")),"^",4)		//联系人电话
	Set DeathDate	= $p($g(^PAPER(PatientID,"ALL")),"^",13)	//死亡日期
	Set DeathTime	= $p($g(^PAPER(PatientID,"ALL")),"^",8)		//死亡时间
	Set IsDeath  	= $s(DeathDate'="":1,1:0)					//是否死亡
	Set Nation 		= $p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)		//民族
	Set IdentityCode= $p($g(^PAPER(PatientID,"ALL")),"^",9)		//身份证号
	Set Sex	 = $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	//Set Sex	 = $s(Sex="男":"M",Sex="女":"F",1:"O")				//性别
	Set MrNo = $p($g(^PAPER(PatientID,"PAT",1)),"^",22)  //病案号
	if MrNo=""{
		Set MrNo = ##class(web.DHCDocMainOrderInterface).IGetMrNoByEpisodeID(+xEpisodeID)	
	}
	//从体温单获取身高体重信息
	Set Mradm= $p(AdmStr,"^",61)	//mradm
	s ItmDrWeight="73"  //体重
	s ItmDrHeight="74"  //身高
	Set Height= 0 ;
	Set Weight= 0 ;
	i ((Mradm'="")&&($d(^MR(Mradm))))
	{
		s Date=0
		f {
			s Date=$o(^MR(Mradm,"OBS",0,"Date",Date))
			q:Date=""
			i $d(^MR(Mradm,"OBS",0,"Date",Date,ItmDrWeight))
			{
				s SubOBS="" 
				f {
					s SubOBS=$o(^MR(Mradm,"OBS",0,"Date",Date,ItmDrWeight,SubOBS))
					q:SubOBS=""
					s Weight=$p($g(^MR(Mradm,"OBS",SubOBS)),"^",2)
				}
			}
			i $d(^MR(Mradm,"OBS",0,"Date",Date,ItmDrHeight))
			{
				s SubOBS="" 
				f {
					s SubOBS=$o(^MR(Mradm,"OBS",0,"Date",Date,ItmDrHeight,SubOBS))
					q:SubOBS=""
					s Height=$p($g(^MR(Mradm,"OBS",SubOBS)),"^",2)
				}
			}
		}
	}
	//获取最后一次体温、脉搏、心率、呼吸、收缩压、舒张压
	set temperature = 0
	set pulse = 0
	set heartbeat = 0
	set breath = 0
	set sysPressure = 0
	set diaPressure = 0
	//判断该方法是否存在
	set retObservations=##class(%Dictionary.MethodDefinition).%ExistsId("EMRservice.HISInterface.PatientInfoAssist||GetPatObservationsNew")
	if retObservations'=0{
		set patObservations = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatObservationsNew(xEpisodeID)
		set lastPatObservations = $p(patObservations,"@",2)
		set temperature =$p($p(lastPatObservations,"^",1),":",2)  //体温
		set pulse =$p($p(lastPatObservations,"^",2),":",2)  //脉搏
		set heartbeat =$p($p(lastPatObservations,"^",3),":",2)  //心率
		set breath =$p($p(lastPatObservations,"^",4),":",2)  //呼吸
		set sysPressure =$p($p(lastPatObservations,"^",5),":",2)  //收缩压
		set diaPressure =$p($p(lastPatObservations,"^",6),":",2)  //舒张压
	}
	

	//费用
	set cost = 0
	set retCostTrakCare = ##class(%Dictionary.MethodDefinition).%ExistsId("EMRservice.HISInterface.PatientInfoAssist||InPatCostTrakCareNew")
	if retCostTrakCare'=0{
		set costStr = ##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(xEpisodeID,"")
		if costStr'=""{
			set cost = $p($p(costStr,"!",1),"^",3)
		}
	}
	
	//通过诊断获取身高、体重
	;Set MRRowId = $p(^PAADM(xEpisodeID),"^",61)
	;Set Weight = $p(^MR(MRRowId,"PRO",1),"^",27)
	;Set Height = $p(^MR(MRRowId,"PRO",1),"^",20)

			
	//就诊信息
	Set VisitStatus = $p(AdmStr,"^",20)	//就诊状态
	Set AdmDate	= "",AdmTime = ""		//入院日期 入院时间
	/*If ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(AdmType="I")){
		Set AdmDate=$p($g(^PAADM(xEpisodeID,"DHC")),"^",31)
		Set AdmTime=$p($g(^PAADM(xEpisodeID,"DHC")),"^",32)
		//按分床日期为入院日期时，若为空，计算住院日期时导致问题 
		If (AdmDate="")&&(AdmTime=""){
			Set AdmDate=$p($g(^PAADM(xEpisodeID)),"^",6)
			Set AdmTime=$p($g(^PAADM(xEpisodeID)),"^",7)
		}
	}Else{
		Set AdmDate=$p($g(^PAADM(xEpisodeID)),"^",6)
		Set AdmTime=$p($g(^PAADM(xEpisodeID)),"^",7)
	}*/
	Set AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(xEpisodeID,"")
	Quit:AdmDateTime="" $$$OK
	
	Set AdmDate=$p(AdmDateTime,",",1)
	Set AdmTime=$p(AdmDateTime,",",2)
	
	
	Set AdmLoc	= $p(AdmStr,"^",4)						//入院科室
	Set HospID  = $p($g(^CTLOC(AdmLoc)),"^",22)			//医院ID
	Set HospCode = $p($g(^CT("HOSP",HospID)),"^",1)		//医院CODE
	Set AdmLocCode = $p($g(^CTLOC(AdmLoc)),"^",1)		//入院科室代码
	Set AdmLocDesc = $p($g(^CTLOC(AdmLoc)),"^",2)		//入院科室描述
	Set AdmWard	= $p(AdmStr,"^",70)						//入院病区
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)			//病区科室转换一下
	Set AdmWardCode = $p($g(^CTLOC(+AdmWard)),"^",1)	//科室代码
	Set AdmWardDesc = $p($g(^CTLOC(+AdmWard)),"^",2)	//科室描述
	Set AdmRoom	= $p(AdmStr,"^",69)						//房间
	Set AdmBed	= $p(AdmStr,"^",73)						//床号
	Set:AdmBed'="" AdmBed = $p($g(^PAWARD(+AdmBed,"BED",$p(AdmBed,"||",2))),"^",1)
	Quit:(AdmBed="") $$$OK
	Set DischDate="",DischTime=""	//出院日期 出院时间
	If $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y"{
		Set DischDate=$p($g(^PAADM(xEpisodeID,"DHC")),"^",29)
		Set DischTime=$p($g(^PAADM(xEpisodeID,"DHC")),"^",30)
	}Else{
		Set DischDate=$p($g(^PAADM(xEpisodeID)),"^",17)
		Set DischTime=$p($g(^PAADM(xEpisodeID)),"^",18)
	}
	//如果退院，出院日期同入院日期
	if VisitStatus="C"{
		Set DischDate = AdmDate
		Set DischTime = AdmTime
	}
	//死亡患者没有出院日期，把出院日期赋值为死亡日期
	set:DischDate="" DischDate = DeathDate
	set:DischTime="" DischTime = DeathTime
	
	Set DischLoc  = $s(DischDate'="":AdmLoc,"1":"")		//如果有出院日期，出院科室为当前科室
	Set (DischLocCode,DischLocDesc)=""
	if DischLoc'=""{
		Set DischLocCode = $p($g(^CTLOC(DischLoc)),"^",1)	//出院科室代码
		Set DischLocDesc = $p($g(^CTLOC(DischLoc)),"^",2)	//出院科室描述
	}
	Set DischWard = $s(DischDate'="":AdmWard,"1":"")	//如果有出院日期，出院病区为当前病区
	Set (DischWardCode,DischWardDesc)=""
	if DischWard'=""{
		Set DischWardCode = $p($g(^CTLOC(DischWard)),"^",1)	//出院病区代码
		Set DischWardDesc = $p($g(^CTLOC(DischWard)),"^",2)	//出院病区描述
	}
	If DischDate'="" {
		//Set AdmDays=DischDate-AdmDate+1
		Set AdmDays=DischDate-AdmDate   //修复bug:557856统一住院天数计算
		Set:AdmDays<1 AdmDays=1
	} Else {
		Set AdmDays=-1
	}
	Set IsActive = 1
	Set:(VisitStatus="P")||(VisitStatus="C") IsActive =0
	
	//add by chenjb 就诊次数
	Set PAAdmTimes	= $p(AdmStr,"^",29)
	//add by zhufei 主管医生
	Set AdmDocDr    = $p(AdmStr,"^",9)  //主管医生
	Set AdmDocCode="",AdmDocDesc="",UserDocID=""
	If AdmDocDr'="" {
		Set AdmDocCode=$p($g(^CTPCP(AdmDocDr,1)),"^",1)
		Set AdmDocDesc=$p($g(^CTPCP(AdmDocDr,1)),"^",2)
		//根据医护表CT_CareProv中的rowid查询用户表SS_User中的rowid，因为页面只能获取到用户表中的rowid
		//把UserDocID写入vte库中的PAADM表中的PAADMDOC 
		Set UserDocID = $o(^SSU("SSUSR",0,"CTPCP",AdmDocDr,"")) 
	}
	Set PAAdmDoc=AdmDocDr_"|"_AdmDocCode_"|"_AdmDocDesc
	Set PACondition= 0	
	
	Set Data = $lb(PatientID,xEpisodeID,PapmiNo,MrNo,PatName,Sex,BirthDay,IdentityCode,Nation,HomeAddress,DeathDate,DeathTime,IsDeath,AdmLoc,AdmLocCode,AdmLocDesc,AdmWard,AdmWardCode,AdmWardDesc,AdmRoom,AdmBed,AdmDate,AdmTime,DischWard,DischWardCode,DischWardDesc,DischDate,DischTime,AdmDocDr,AdmDocCode,AdmDocDesc,VisitStatus,Height,Weight,PACondition,UserDocID,RelativeTel,temperature,pulse,heartbeat,breath,sysPressure,diaPressure,cost,PAAdmTimes)
	Set ^CacheTemp(repid,ind)=Data
	//Set ind=ind+1
	Quit $$$OK
AutoTaskErr
	Quit $$$OK
}

ClassMethod QryPaAdmByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPaAdmByIdExecute ]
{
	Quit $$$OK
}

ClassMethod QryPaAdmByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPaAdmByIdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
