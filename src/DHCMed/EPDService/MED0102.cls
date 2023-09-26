Class DHCMed.EPDService.MED0102 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:fujingwei
/// CreateDate:2018-10-12
/// Description:  传染病科室疾病分布
/// Table：       DHCMed.EPD.Infection、DHCMed.EPD.Epidemic
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Return：      返回ROWSPEC
/// 疾病列表：d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryInfection","","")
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.MED0102","QryEpdLocInfec","1","2018-10-01","2018-10-12")
Query QryEpdLocInfec(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,AdmLoc:%String,LocNum:%Integer,Infection:%String,InfectionNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryEpdLocInfecExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
 	
	Set NIndex="QryInfection"
	k ^TMP($zn,$j,NIndex)
	
	For xDate=aDateFrom:1:aDateTo{
		Set xLocID=""
		For{
			Set xLocID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID))
			Quit:xLocID=""
			Set HospID=$p(^CTLOC(xLocID),"^",22)
			Continue:(aHospIDs'="")&&(aHospIDs'[(","_HospID_","))
			
			Set RepID=""
			For{
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID,RepID))
				Quit:RepID=""
				
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Set Status=objRep.MEPDStatus
				//Continue:Status'=2
				Continue:Status=4      //被订      
				Continue:Status=6      //草稿
				Continue:Status=7      //删除
		
				Continue:'$IsObject(objRep.MEPDICDDR)
				Set Infection=objRep.MEPDICDDR.MIFDisease
				
				///全院报告数
				If '$d(^TMP($zn,$j,NIndex,"Hosp","RepCount",RepID)){
					Set ^TMP($zn,$j,NIndex,"Hosp","RepCount",RepID)=""
					Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","RepCount"))
					Set ^TMP($zn,$j,NIndex,"Hosp","RepCount")=num+1
				}
				Set ^TMP($zn,$j,NIndex,"Hosp","Infection",Infection,"Rep",RepID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Hosp","Infection",Infection,"Rep"))
				Set ^TMP($zn,$j,NIndex,"Hosp","Infection",Infection,"Rep")=num+1
				///科室报告数
				If '$d(^TMP($zn,$j,NIndex,"Loc",xLocID,"RepCount",RepID))
				{
					Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"RepCount",RepID)=""
					Set num=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"RepCount"))
					Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"RepCount")=num+1
				}
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"Infection",Infection,"Rep",RepID)=""
				Set num=+$g(^TMP($zn,$j,NIndex,"Loc",xLocID,"Infection",Infection,"Rep"))
				Set ^TMP($zn,$j,NIndex,"Loc",xLocID,"Infection",Infection,"Rep")=num+1
			}
		}
	}
	
	Set HospNum=+$g(^TMP($zn,$j,NIndex,"Hosp","RepCount"))
	Set tLocID=""
	For{
		Set tLocID=$o(^TMP($zn,$j,NIndex,"Loc",tLocID))
		Quit:tLocID=""
		
		Set AdmLoc=$p(^CTLOC(tLocID),"^",2)
		Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
		Set LocNum=+$g(^TMP($zn,$j,NIndex,"Loc",tLocID,"RepCount"))
		Set tInfection=""
		For{
			Set tInfection=$o(^TMP($zn,$j,NIndex,"Loc",tLocID,"Infection",tInfection))
			Quit:tInfection=""
			
			Set InfectionNum=+$g(^TMP($zn,$j,NIndex,"Loc",tLocID,"Infection",tInfection,"Rep"))
			
			Set Data=$lb(tLocID,AdmLoc,LocNum,tInfection,InfectionNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	Set xInfection=""
	For{
		Set xInfection=$o(^TMP($zn,$j,NIndex,"Hosp","Infection",xInfection))
		Quit:xInfection=""
		
		Set InfectionNum=+$g(^TMP($zn,$j,NIndex,"Hosp","Infection",xInfection,"Rep"))
		Set Data=$lb("","全院",HospNum,xInfection,InfectionNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryEpdLocInfecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpdLocInfecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpdLocInfecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpdLocInfecExecute ]
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

///  d ##class(%ResultSet).RunQuery("DHCMed.EPDService.MED0102","QueryEpdRepByDate","2018-01-01","2018-01-01","")
Query QueryEpdRepByDate(FromDate As %String, ToDate As %String, Loc As %String, Doc As %String, Hosp As %String) As %Query(ROWSPEC = "ind:%String,RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,DiseaseICD:%String:ICD,DiseaseName:%String:疾病名称,ReportDep:%String:上报科室,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepKind:%String:传染病类别,RepRank:%String:传染病级别") [ SqlProc ]
{
}

ClassMethod QueryEpdRepByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Loc As %String, Doc As %String, Hosp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["-" FromDate=$zdh(FromDate, 3)
	Set:FromDate["/" FromDate=$zdh(FromDate, 4)
	Set:FromDate'="" FromDate=+FromDate
	Set:ToDate["-" ToDate=$zdh(ToDate, 3)
	Set:ToDate["/" ToDate=$zdh(ToDate, 4)
	Set:ToDate'="" ToDate=+ToDate
	Quit:((FromDate="")||(ToDate="")) $$$OK

	For tmpDate=FromDate:1:ToDate {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""
			If (Loc'=""){
				Continue:(tmpLoc'=Loc)
			}ElseIf(Hosp'=""){
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,Hosp)
				continue:flg<1
			}

			Set RepRowID=""
			For {
				Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
				Quit:RepRowID=""
				
				set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
				Continue:'$IsObject(objRep)
			
				If $IsObject(objRep.MEPDICDDR) {
					Set RepKindValue=objRep.MEPDICDDR.MIFKind	//病例分类
					Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKindValue,"")
					If $IsObject(objRepKind){
						Set RepKind=objRepKind.Code
					}
				}
				Set RepUser=objRep.MEPDRepUsrDR
				Continue:(RepUser'=Doc)&(Doc'="")
				Set Status=objRep.MEPDStatus
				Continue:Status=4      //被订      
				Continue:Status=6      //草稿
				Continue:Status=7      //删除
				//Add By LiYang 2014-08-08 FixBug：1430 医政管理-传染病管理系统-传染病报告查询-在【疾病类别】中选择任意疾病，查询的结果总是包含【疾病名称】为空的报告
				Continue:(($IsObject(objRep.MEPDICDDR)=0)&&(RepKind'=""))

				Set tmpData=..BuildQryEpidemic(ind,objRep)
				Set ^CacheTemp(repid,ind)=tmpData
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryEpdRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEpdRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEpdRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEpdRepByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildQryEpidemic(ind, objRep) As %List
{
	New (ind,objRep)
	Set return=""
	
	Set ReportID=objRep.%Id()                       //报告ID
	Set PatientID=objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID=objRep.MEPDText1                  //EpisodeID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		//统一调用年龄计算方法
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		//Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
		Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		//Set AdmitTime=$p($g(^PAADM(+EpisodeID)),"^",7)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
	}
	If $IsObject(objRep.MEPDICDDR){
		Set RepICD=objRep.MEPDICDDR.MIFICD			//ICD
		Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称
		Set RepKind=objRep.MEPDICDDR.MIFKind        //病例分类
		Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKind,"")
		If $IsObject(objRepKind){
			Set RepKind=objRepKind.Description
		}
		Set RepRank=objRep.MEPDICDDR.MIFRank        //传染病类别(甲、乙、丙)
		Set objRepRank=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",RepRank,"")
		If $IsObject(objRepRank){
			Set RepRank=objRepRank.Description
		}
	}
	Set RepLoc=objRep.MEPDLocDR                     //报告科室
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusCode=objRepStatus.Code
	}
	Set CheckDate=objRep.MEPDCheckDate              //审核日期
	Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set CheckTime=objRep.MEPDCheckTime              //审核时间
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckUser=objRep.MEPDCheckUsrDR                 //审核人
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	If (RepStatusDesc'="已审")&&(RepStatusDesc'="被订"){
		Set CheckDate=""
		Set CheckTime=""
		Set CheckUserCode=""
		Set CheckUserName=""
	}
	
	Set return=return_$lb($g(ind))
	Set return=return_$lb($g(ReportID))                 //报告ID
	Set return=return_$lb($g(PatientID))                //PatientID
	Set return=return_$lb($g(PapmiNo))                  //登记号
	Set return=return_$lb($g(PatientName))              //姓名
	Set return=return_$lb($g(PatientSex))               //性别
	Set return=return_$lb($g(PatientAge))               //年龄
	Set return=return_$lb($g(RepICD))                   //疾病ICD
	Set return=return_$lb($g(RepDisease))               //疾病名称
	Set return=return_$lb($g(RepLoc))                   //报告科室
	Set return=return_$lb($g(RepUserName))              //报告人
	Set return=return_$lb($g(RepDate))                  //报告日期
	Set return=return_$lb($g(RepTime))                  //报告时间
	Set return=return_$lb($g(RepStatusDesc))            //报告状态
	Set return=return_$lb($g(EpisodeID))                //EpisodeID
	Set return=return_$lb($g(CheckUserName))            //审核人
	Set return=return_$lb($g(CheckDate))                //审核日期
	Set return=return_$lb($g(CheckTime))                //审核时间
	Set return=return_$lb($g(RepKind))                  //传染病类别
	Set return=return_$lb($g(RepRank))                  //传染病级别

	Quit return
}

}
