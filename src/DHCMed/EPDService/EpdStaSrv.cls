/// 创建者：李阳
/// 日期：2011-06-26
/// 统计模块
Class DHCMed.EPDService.EpdStaSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 按日期统计
/// update by  pylian 2015-09-17  fix bug 120754 统计条件去掉就诊类型
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpdStaSrv","StaEpdByDate","2010-12-17","2012-12-18","O","","")
Query StaEpdByDate(FromDate As %String, ToDate As %String, loc As %String, HospitalID As %String) As %Query(ROWSPEC = "DataIndex:%String,DataDesc:%String,EpdNum:%String,EpdRatio:%String")
{
}

ClassMethod StaEpdByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, loc As %String, HospitalID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set argFromDate=FromDate,FromDate=""
	Set argToDate=ToDate,ToDate=""
	Set argLocID=loc,loc=""
	Set argHospID=HospitalID,HospitalID=""
	
	Set:(+argLocID=0) argLocID=""
	Set:(+argHospID=0) argHospID=""
	
	//Set:argFromDate["-" argFromDate=$zdh(argFromDate,3)
	//Set:argFromDate["/" argFromDate=$zdh(argFromDate,4)
	//Set:argToDate["-" argToDate=$zdh(argToDate,3)
	//Set:argToDate["/" argToDate=$zdh(argToDate,4)
	Set argFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argFromDate)
	Set argToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argToDate)
	Set:argFromDate'="" argFromDate=+argFromDate
	Set:argToDate'="" argToDate=+argToDate
	Quit:(argFromDate="")||(argToDate="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"StaEpdByDate")
	
	For xDate=argFromDate:1:argToDate {
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.EPDi("EPD",0,"RepDate",xDate,xRepID))
			Quit:xRepID=""
			
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.MEPDICDDR)
			
			Set RepStatus=objRep.MEPDStatus
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
			Continue:'$IsObject(objRepStatus)
			Set RepStatusDesc=objRepStatus.Description
			Set RepStatusCode=objRepStatus.Code
			Continue:(RepStatusDesc["删除")||(RepStatusDesc["作废")||(RepStatusDesc["被订")||(RepStatusDesc["草稿")
			Set ICDDr=objRep.MEPDICDDR.%Id()
			Continue:ICDDr=""
			
			Set RepPlace=objRep.MEPDRepPlace
			Continue:RepPlace=""
			//Continue:(argAdmType="O")&&((RepPlace'="O")&&(RepPlace'="E"))
			//Continue:(argAdmType="I")&&(RepPlace'="I")
			
			Set Paadm=objRep.MEPDText1
			Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
			Continue:'$IsObject(objPaadm)
			
			Set LocID=objPaadm.DepartmentID
			Continue:LocID=""
			Continue:((argLocID'="")&&(LocID'=argLocID))  //判断科室
			
			//Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
			//Set HospID=objLoc.HospitalDr
			//Continue:((argHospID'="")&&(HospID'=argHospID))  //判断医院
			if argHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,argHospID)
				continue:flg<1
			}
			
			Set RepWard=objRep.MEPDText3
			If RepWard=""
			{
				Set RepWard=$p($g(^PAADM(+Paadm)),"^",70)
				Set:RepWard'="" RepWard=$p($g(^PAWARD(+RepWard)),"^",5)
			}
			Set:RepWard="" RepWard="9999"
			
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum","合计"))
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum",LocID))
			
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum","合计"))
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum",ICDDr))
			
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum","合计"))
			Set num=$i(^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum",RepWard))
		}
	}
	
	//显示科室疾病信息
	//^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum",LocID)
	Set EpdCount=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum","合计"))
	Set xLocID="",Count=0
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum",xLocID))
		Quit:xLocID=""
		
		Set EpdNum=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","LocStat","EpdNum",xLocID))
		If xLocID="合计" {
			Set LocDesc="合计"
			Set EpdRatio=""
		} Else {
			Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			If EpdCount>0 {
				Set EpdRatio=$fn((EpdNum/EpdCount)*100,"",2)_"%"
			} Else {
				Set EpdRatio="0.00%"
			}
		}
		
		Set Count=Count+1
		Set Data=$lb("LocStat-"_xLocID,LocDesc,EpdNum,EpdRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If Count>0 {
		Set ^CacheTemp(repid,ind)=$lb("LocStat-合计-Null","","","")
		Set ind=ind+1
	}
	
	//显示病区疾病信息
	//^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum",WardID)
	Set EpdCount=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum","合计"))
	Set xWardID="",Count=0
	For {
		Set xWardID=$o(^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum",xWardID))
		Quit:xWardID=""
		
		Set EpdNum=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","WardStat","EpdNum",xWardID))
		If xWardID="合计" {
			Set WardDesc="合计"
			Set EpdRatio=""
		} Else {
			Set WardDesc=$p($g(^CTLOC(xWardID)),"^",2)
			Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
			Set:WardDesc="" WardDesc="其他"
			If EpdCount>0 {
				Set EpdRatio=$fn((EpdNum/EpdCount)*100,"",2)_"%"
			} Else {
				Set EpdRatio="0.00%"
			}
		}
		
		Set Count=Count+1
		Set Data=$lb("WardStat-"_xWardID,WardDesc,EpdNum,EpdRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If Count>0 {
		Set ^CacheTemp(repid,ind)=$lb("WardStat-合计-Null","","","")
		Set ind=ind+1
	}
	
	//疾病信息汇总
	//^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum",EpdICDDr)
	Set EpdCount=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum","合计"))
	Set xICDDr="",Count=0
	For {
		Set xICDDr=$o(^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum",xICDDr))
		Quit:xICDDr=""
		
		Set EpdNum=+$g(^TMP(ZIndex,JIndex,"StaEpdByDate","ICDStat","EpdNum",xICDDr))
		If xICDDr="合计" {
			Set ICDDesc="合计"
			Set EpdRatio=""
		} Else {
			Set objICD=##class(DHCMed.EPD.Infection).GetObjById(xICDDr)
			Continue:'$IsObject(objICD)
			Set ICDDesc=objICD.MIFDisease
			If EpdCount>0 {
				Set EpdRatio=$fn((EpdNum/EpdCount)*100,"",2)_"%"
			} Else {
				Set EpdRatio="0.00%"
			}
		}
		
		Set Count=Count+1
		Set Data=$lb("ICDStat-"_xICDDr,ICDDesc,EpdNum,EpdRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	If Count>0 {
		Set ^CacheTemp(repid,ind)=$lb("ICDStat-合计-Null","","","")
		Set ind=ind+1
	}
	
	Kill ^TMP(ZIndex,JIndex,"StaEpdByDate")
	
	Quit $$$OK
}

ClassMethod StaEpdByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaEpdByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaEpdByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaEpdByDateExecute ]
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

///  Creator：     李阳
///  CreatDate：   2010-04-07
///  Description:  通过上报日期查询传染病报告
///  Table：       DHCMed.EPD.Epidemic
///  update by pylian 2015-09-17 查询条件去掉就诊类型
///  Input：       FromDate：开始上报日期 ToDate：结束上报日期 Loc：科室 Status：状态 RepPlace：报告位置 Hospital：院区 上报CDC状态：UploadStatus 疾病类别：MIFKind
///  d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpdStaSrv","QueryEpdRepByDate","2011-01-01","2011-12-31","","*1*2*3*","ALL","3","N","")
Query QueryEpdRepByDate(FromDate As %String, ToDate As %String, loc As %String, HospitalID As %String) As %Query(ROWSPEC = "RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,DiseaseICD:%String:ICD,DiseaseName:%String:疾病名称,ReportDep:%String:上报科室,RepPlace:%String:上报位置,RepUserCode:%String:上报人工号,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,IsUpload:%String:是否上报CDC,StatusCode:%String,CheckUserCode:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepKind:%String:传染病类别,RepRank:%String:传染病级别,FamName:%String,Occupation:%String,Company:%String,Address:%String,IDAddress:%String,TelPhone:%String,SickDate:%String,DiagDate:%String,DeathDate:%String,RepNo:%String,PersonalID:%String,DelReason:%String,DemoInfo:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QueryEpdRepByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, loc As %String, HospitalID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set argFromDate=FromDate,FromDate=""
	Set argToDate=ToDate,ToDate=""
	Set argLocID=loc,loc=""
	Set argHospID=HospitalID,HospitalID=""
	
	Set:(+argLocID=0) argLocID=""
	Set:(+argHospID=0) argHospID=""
	
	//Set:argFromDate["-" argFromDate=$zdh(argFromDate,3)
	//Set:argFromDate["/" argFromDate=$zdh(argFromDate,4)
	//Set:argToDate["-" argToDate=$zdh(argToDate,3)
	//Set:argToDate["/" argToDate=$zdh(argToDate,4)
	Set argFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argFromDate)
	Set argToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argToDate)
	Set:argFromDate'="" argFromDate=+argFromDate
	Set:argToDate'="" argToDate=+argToDate
	Quit:(argFromDate="")||(argToDate="") $$$OK
	
	For xDate=argFromDate:1:argToDate {
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.EPDi("EPD",0,"RepDate",xDate,xRepID))
			Quit:xRepID=""
			
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.MEPDICDDR)
			
			Set RepStatus=objRep.MEPDStatus
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
			Continue:'$IsObject(objRepStatus)
			Set RepStatusDesc=objRepStatus.Description
			Set RepStatusCode=objRepStatus.Code
			Continue:(RepStatusDesc["删除")||(RepStatusDesc["作废")||(RepStatusDesc["被订")||(RepStatusDesc["草稿")
			Set ICDDr=objRep.MEPDICDDR.%Id()
			Continue:ICDDr=""
			
			Set RepPlace=objRep.MEPDRepPlace
			Continue:RepPlace=""
			//Continue:(argAdmType="O")&&((RepPlace'="O")&&(RepPlace'="E"))
			//Continue:(argAdmType="I")&&(RepPlace'="I")
			
			Set Paadm=objRep.MEPDText1
			Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
			Continue:'$IsObject(objPaadm)
			
			Set LocID=objPaadm.DepartmentID
			Continue:LocID=""
			Continue:((argLocID'="")&&(LocID'=argLocID))  //判断科室
			
			//Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
			//Set HospID=objLoc.HospitalDr
			//Continue:((argHospID'="")&&(HospID'=argHospID))  //判断医院
			if argHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,argHospID)
				continue:flg<1
			}
			
			Set tmpData=..BuildQryEpidemic(objRep)
			Set ^CacheTemp(repid,ind)=tmpData
			Set ind=ind+1
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

ClassMethod BuildQryEpidemic(objRep) As %List
{
	New (objRep)
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
		Set AdmTime=$p(AdmDateTime,"^",2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
		//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
		Set PersonalID=objPatient.PersonalID        //身份证号
	}
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
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
	Set RepPlace=objRep.MEPDRepPlace                //上报位置
	Set objRepPlace=##class(DHCMed.SS.Dictionary).GetByTypeCode("REPPLACE",RepPlace,"")
	If $IsObject(objRepPlace){
		Set RepPlace=objRepPlace.Description
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	}
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	//Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusCode=objRepStatus.Code
	}
	Set RepIsUpload=$s(objRep.MEPDIsUpload="Y":"已上报",1:"未上报")  //是否上报CDC
	Set CheckDate=objRep.MEPDCheckDate              //审核日期
	//Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=objRep.MEPDCheckTime              //审核时间
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckUser=objRep.MEPDCheckUsrDR                 //审核人
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	//add by pylian 2015-04-01
	If (RepStatusDesc'="已审")&&(RepStatusDesc'="被订"){
		Set CheckDate=""
		Set CheckTime=""
		Set CheckUserCode=""
		Set CheckUserName=""
	}
	Set FamName=objRep.MEPDFamName                  //家长姓名
	Set Occupation=objRep.MEPDOccupation            //职业
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetByTypeCode("Career",Occupation,"")
	If $IsObject(objOccupation){
		Set Occupation=objOccupation.Description
	}
	Set Company=objRep.MEPDCompany                  //工作单位
	Set TelPhone=objRep.MEPDTelPhone                //联系电话
	Set Address=objRep.MEPDAddress                  //现住址
	Set IDAddress=objRep.MEPDIDAddress              //户籍地址
	Set SickDate=objRep.MEPDSickDate                //发病日期
	//Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	//Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
	Set DeathDate=objRep.MEPDDeathDate              //死亡日期
	//Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	
	//通过计算得到卡片编号
	Set RepNo=objRep.MEPDText2
	
	//退卡原因或删除原因
	Set DelReason=objRep.MEPDDelReason
	//Set:($g(RepStatusCode)'="9")&&($g(RepStatusCode)'["0") DelReason=""
	// fix bug 8318 by pylian 2015-04-01 
	
	//备注
	Set DemoInfo=objRep.MEPDDemo
	
	Set return=return_$lb($g(ReportID))                 //报告ID
	Set return=return_$lb($g(PatientID))                //PatientID
	Set return=return_$lb($g(PapmiNo))                  //登记号
	Set return=return_$lb($g(PatientName))              //姓名
	Set return=return_$lb($g(PatientSex))               //性别
	Set return=return_$lb($g(PatientAge))               //年龄
	Set return=return_$lb($g(RepICD))                   //疾病ICD
	Set return=return_$lb($g(RepDisease))               //疾病名称
	Set return=return_$lb($g(RepLoc))                   //报告科室
	Set return=return_$lb($g(RepPlace))                 //上报位置
	Set return=return_$lb($g(RepUserCode))              //报告人工号
	Set return=return_$lb($g(RepUserName))              //报告人
	Set return=return_$lb($g(RepDate))                  //报告日期
	Set return=return_$lb($g(RepTime))                  //报告时间
	Set return=return_$lb($g(RepStatusDesc))            //报告状态
	Set return=return_$lb($g(EpisodeID))                //EpisodeID
	Set return=return_$lb($g(RepIsUpload))              //是否上报CDC
	Set return=return_$lb($g(RepStatusCode))            //报告状态代码
	
	Set return=return_$lb($g(CheckUserCode))            //审核人工号
	Set return=return_$lb($g(CheckUserName))            //审核人
	Set return=return_$lb($g(CheckDate))                //审核日期
	Set return=return_$lb($g(CheckTime))                //审核时间
	Set return=return_$lb($g(RepKind))                  //传染病类别
	Set return=return_$lb($g(RepRank))                  //传染病级别
	Set return=return_$lb($g(FamName))                  //家属姓名
	Set return=return_$lb($g(Occupation))               //职业
	Set return=return_$lb($g(Company))                  //工作单位
	Set return=return_$lb($g(Address))                  //现住址
	Set return=return_$lb($g(IDAddress))                //户籍地址
	Set return=return_$lb($g(TelPhone))                 //联系电话
	Set return=return_$lb($g(SickDate))                 //发病日期
	Set return=return_$lb($g(DiagDate))                 //诊断日期
	Set return=return_$lb($g(DeathDate))                //死亡日期
	Set return=return_$lb($g(RepNo))                    //卡片编号
	Set return=return_$lb($g(PersonalID))               //身份证号
	Set return=return_$lb($g(DelReason))                //退回或删除原因
	Set return=return_$lb($g(DemoInfo))                 //备注
	Set return=return_$lb($g(EncryptLevel))             //病人密级
	Set return=return_$lb($g(PatLevel))                 //病人级别
	
	Quit return
}

}
