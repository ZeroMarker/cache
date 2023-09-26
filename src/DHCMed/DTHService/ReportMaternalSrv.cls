/// 名称：DHCMed.DTHService.ReportMaternalSrv
/// 创建者：pylian
/// 创建日期：2016-07-19
/// 功能：处理孕产妇死亡登记副卡
Class DHCMed.DTHService.ReportMaternalSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator:     pylian
/// CreateDate:  2016-07-19
/// Description: 获取报告信息
/// Input:       MthRepID:处理孕产妇死亡登记副卡ID,(DHCMed.DTH.MaternalReport)
///              DthRepID:医学死亡证明书ID，(DHCMed.DTH.Report)
/// Output:      可以用于打印或显示的信息
/// w ##class(DHCMed.DTHService.ReportMaternalSrv).GetReportString(4,14)
ClassMethod GetReportString(aMthRepID As %String, aDthRepID As %String)
{
	New (aMthRepID,aDthRepID)
	Set return=""
	Quit:(aDthRepID="")&&(aMthRepID="") return
	
	If (aMthRepID="")&&(aDthRepID'="") {
		Set aMthRepID=##class(DHCMed.DTH.MaternalReport).GetRepIDByDthID(aDthRepID)
	}
	
	Set MthRepInfo=""
	If (aMthRepID'="") { //孕产妇报告ID不为空
		Set objMthRep=##class(DHCMed.DTH.MaternalReport).GetObjById(aMthRepID)
		If $IsObject(objMthRep){
			Set $p(MthRepInfo,"^",1)=aMthRepID
			Set $p(MthRepInfo,"^",2)=objMthRep.PatientID     // 基本信息ID Pa_Patmas
			Set $p(MthRepInfo,"^",3)=objMthRep.EpisodeID     // 就诊表 ID
			Set $p(MthRepInfo,"^",4)=objMthRep.DthReportID   // 死亡报告ID DHCMed.DTH.Report
			Set aDthRepID=objMthRep.DthReportID
			Set $p(MthRepInfo,"^",5)=objMthRep.DTHNo   //编号
			Set $p(MthRepInfo,"^",6)=objMthRep.Name   // 姓名
			Set $p(MthRepInfo,"^",7)=..GetAreaByObj(objMthRep.ConProvince)    // 常住址 省
			Set $p(MthRepInfo,"^",8)=..GetAreaByObj(objMthRep.ConCity)        // 常住址  市
			Set $p(MthRepInfo,"^",9)=..GetAreaByObj(objMthRep.ConCounty)      // 常住址  县（区）
			Set $p(MthRepInfo,"^",10)=..GetAreaByObj(objMthRep.ConVillage)    //常住址 乡
			
			Set $p(MthRepInfo,"^",11)=objMthRep.ConRoad                         // 常住址 小区（村）
			Set $p(MthRepInfo,"^",12)=..GetAreaByObj(objMthRep.TempProvince)   // 暂住址 省
			Set $p(MthRepInfo,"^",13)=..GetAreaByObj(objMthRep.TempCity)       // 暂住址 市
			Set $p(MthRepInfo,"^",14)=..GetAreaByObj(objMthRep.TempCounty)     // 暂住址 县（区）
			Set $p(MthRepInfo,"^",15)=..GetAreaByObj(objMthRep.TempVillage)    // 暂住址 乡
			Set $p(MthRepInfo,"^",16)=objMthRep.TempRoad                        // 暂住址 小区（村）	
			Set $p(MthRepInfo,"^",17)=..GetDicString(objMthRep.RegType)        // 户口 1. 本地    2. 非本地 
			Set $p(MthRepInfo,"^",18)=..GetDicString(objMthRep.IsPlan)         // 计划内外
			Set $p(MthRepInfo,"^",19)=objMthRep.Age                            
			Set $p(MthRepInfo,"^",20)=..GetDicString(objMthRep.Nation)         // 民族 1. 汉族   2. 少数民族
			
			Set $p(MthRepInfo,"^",21)=..GetDicString(objMthRep.Education)      // 文化程度 1. 大专及以上  2. 高中或中专 3. 初中   4. 小学   5. 文盲 	
			Set $p(MthRepInfo,"^",22)=..GetDicString(objMthRep.FamilIncome)    // 家庭年人均收入（元）1. <1000元   2. 1000元~   3. 2000元~   4. 4000元~   5. 8000元~ 
			Set $p(MthRepInfo,"^",23)=..GetDicString(objMthRep.ConType)        // 居住地区 1. 平原  2.山区  3. 其他地区  
			Set $p(MthRepInfo,"^",24)=objMthRep.PreTimes      // 孕次
			Set $p(MthRepInfo,"^",25)=objMthRep.ProTimes      //  产次
			Set $p(MthRepInfo,"^",26)=objMthRep.LaborTimes    // 人工流产、引产次
			Set LastMenDate = objMthRep.LastMenDate 
			Set:LastMenDate'="" LastMenDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(LastMenDate)	
			Set $p(MthRepInfo,"^",27)=LastMenDate   //末次月经
			Set DeliveryDate = objMthRep.DeliveryDate 
			Set:DeliveryDate'="" DeliveryDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeliveryDate)	
			Set $p(MthRepInfo,"^",28)=DeliveryDate   //分娩日期
		    Set $p(MthRepInfo,"^",29)=objMthRep.DeliveryTime        //分娩时间
			Set DeathDate = objMthRep.DeathDate 
			Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
			Set $p(MthRepInfo,"^",30)=DeathDate   //死亡日期
		
			Set $p(MthRepInfo,"^",31)=objMthRep.DeathTime   //死亡时间
			Set $p(MthRepInfo,"^",32)=..GetDicString(objMthRep.DeliveryPosition) // 分娩地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院  4. 村接生室 5.家中    6. 途中    7. 其它    9.不详 
			Set $p(MthRepInfo,"^",33)=..GetDicString(objMthRep.DeathPosition)    // 1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 4. 村接生室 5.家中    6. 途中    7. 其它    9.不详
			Set $p(MthRepInfo,"^",34)=..GetDicString(objMthRep.DeliveryWay)      // 分娩方式  0. 未娩    1. 自然产   2. 阴道手术产  3. 剖宫产 
			Set $p(MthRepInfo,"^",35)=..GetDicString(objMthRep.IsNewWay)         // 新法接生  1. 是      2. 否  
			Set $p(MthRepInfo,"^",36)=..GetDicString(objMthRep.Deliveryer)       // 接生者    1. 医务人员  2. 乡村医生 3. 接生员  4. 其他人员
			Set $p(MthRepInfo,"^",37)=..GetDicString(objMthRep.IsPreCheck)        //  产前检查  1. 有      2. 无 
			Set $p(MthRepInfo,"^",38)=objMthRep.PregWeek // 初检孕周 周
			Set $p(MthRepInfo,"^",39)=objMthRep.PregCheckTime // 产检次数
			Set $p(MthRepInfo,"^",40)=..GetDicString(objMthRep.DiagnoseBasis)   // 死因诊断依据    1. 尸检   2. 病理    3. 临床   4. 死后推断  
		
			Set $p(MthRepInfo,"^",41)=..GetDicString(objMthRep.ProResult)       // 省级医疗保健机构评审结果  1. 可避免   2. 不可避免  
			Set $p(MthRepInfo,"^",42)=..GetDicString(objMthRep.ProReason)       // 省级 影响死亡的主要因素       编号1    编号2  编号3
			Set $p(MthRepInfo,"^",43)=..GetDicString(objMthRep.CountryResult)   // 国家级评审结果 1. 可避免   2. 不可避免  
			Set $p(MthRepInfo,"^",44)=..GetDicString(objMthRep.CountryReason)   // 国家 影响死亡的主要因素       编号1    编号2  编号3  
		    Set $p(MthRepInfo,"^",45)=objMthRep.RepDocDR
			Set $p(MthRepInfo,"^",46)=objMthRep.RepLocDR
			Set $p(MthRepInfo,"^",47)=$p($g(^SSU("SSUSR",objMthRep.RepUsrDR)),"^",2)
			Set RepDate = objMthRep.RepDate 
			Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
			Set $p(MthRepInfo,"^",48)=RepDate
			Set $p(MthRepInfo,"^",49)=$zt(+objMthRep.RepTime,1)
			//Set $p(MthRepInfo,"^",50)=..GetDicString(objMthRep.RepStatusDR)   // 状态
			Set $p(MthRepInfo,"^",50)=""      // 状态
			Set $p(MthRepInfo,"^",51)=objMthRep.ResumeText   //备注，退回原因
			Set $p(MthRepInfo,"^",52)=..GetDicString(objMthRep.LastMenDR)    // 末次月经类型
			Set $p(MthRepInfo,"^",53)=..GetDicString(objMthRep.DeliDateDR)   // 分娩时间分类
			Set $p(MthRepInfo,"^",54)=..GetDicString(objMthRep.CategoryDR)   // 死因分类编号
		}
	}
	
	Set DthRepInfo=""
	If (aDthRepID'="") { //有死亡证明书
		Set objDthRep=##class(DHCMed.DTH.Report).GetObjById(aDthRepID)
		If $IsObject(objDthRep){
			
			Set DeathDate = objDthRep.DeathDate 
			Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
			Set $p(DthRepInfo,"^",1)=DeathDate //死亡日期
			Set $p(DthRepInfo,"^",2)=$zt(objDthRep.DeathTime,1) // 死亡时间
			Set $p(DthRepInfo,"^",3)=objDthRep.AReason
			Set $p(DthRepInfo,"^",4)=objDthRep.BReason
			Set $p(DthRepInfo,"^",5)=objDthRep.CReason
			Set $p(DthRepInfo,"^",6)=objDthRep.BaseReason
			
			If (aMthRepID="") { //死亡证明书已填写好，孕产妇死亡登记副卡没填写
				Set $p(MthRepInfo,"^",60)="" //先分配60个空位
				Set $p(MthRepInfo,"^",2)=objDthRep.PatientID   // 基本信息ID Pa_Patmas
				Set $p(MthRepInfo,"^",3)=objDthRep.EpisodeID   // 就诊表 ID
				Set $p(MthRepInfo,"^",4)=objDthRep.%Id()       // 死亡报告ID DHCMed.DTH.Report
				Set $p(MthRepInfo,"^",5)=objDthRep.DeathNo     //孕产妇死亡登记副卡编号=死亡证明书编号
				Set $p(MthRepInfo,"^",6)=objDthRep.Name        // 姓名	
				Set $p(MthRepInfo,"^",19)=objDthRep.Age        // 年龄	
				Set $p(MthRepInfo,"^",30)=DeathDate            //死亡日期
				Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(objDthRep.PatientID,objDthRep.EpisodeID,objDthRep.DeathDate,objDthRep.DeathTime)
		    	Set $p(MthRepInfo,"^",49)=$c(2)_$c(2)_"新建"   //状态
						
				
			}
		}
	}
	
	Quit MthRepInfo_$C(1)_DthRepInfo
}

ClassMethod GetDicString(obj) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	Set $p(return,$c(2),1)=obj.%Id()
	Set $p(return,$c(2),2)=obj.Code
	Set $p(return,$c(2),3)=obj.Description
	Quit return
}

ClassMethod GetAreaByObj(obj As DHCMed.SS.AreaDic) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	Set $p(return,$c(2),1)=obj.%Id()
	Set $p(return,$c(2),2)=obj.Code
	Set $p(return,$c(2),3)=obj.ShortDesc

	quit return
}

/// Creator:     pylian
/// CreateDate:  2016-07-19
/// Description: 查询孕产妇死亡登记副卡信息
/// Input:       日期类型、开始日期、结束日期、报告科室、医院、姓名、登记号、病案号
///              aSeparate:分割符
/// Output:     成功返回1，失败返回小于0的数字
/// d ##class(%ResultSet).RunQuery("DHCMed.DTHService.ReportMaternalSrv","QryMaterDeathInfo","1","2016-07-19","2016-07-20","","","","")
Query QryMaterDeathInfo(aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aExamConts As %String, aExamSepeare As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String,MrNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmType:%String,DecDate:%String,DecTime:%String,DoctorName:%String,AdmitDate:%String,Department:%String,Ward:%String,Room:%String,Bed:%String,DisDate:%String,MthRepID:%String,MthRepDate:%String,MthRepTime:%String,MthRepUser:%String,MthRepStatus:%String,MthRepLocID:%String,MthRepLoc:%String,ReportID:%String,RepDate:%String,RepTime:%String,RepUser:%String,RepStatus:%String,RepLocID:%String,RepLoc:%String") [ SqlProc ]
{
}

ClassMethod QryMaterDeathInfoExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String, aExamConts As %String, aExamSepeare As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Set:$g(aExamSepeare)="" aExamSepeare="^"
	
	Set (PatName,RegNo,MrNo)=""
	For indCont=1:1:$l(aExamConts,aExamSepeare) {
		Set ExamCont=$p(aExamConts,aExamSepeare,indCont)
		Set:ExamCont["PatName=" PatName=$e(ExamCont,$l("PatName=")+1,$l(ExamCont))
		Set:ExamCont["MrNo=" MrNo=$e(ExamCont,$l("MrNo=")+1,$l(ExamCont))
		Set:ExamCont["RegNo=" RegNo=$e(ExamCont,$l("RegNo=")+1,$l(ExamCont))
	}
	Set:RegNo'="" RegNo=##Class(DHCMed.SSService.CommonCls).RegNoCon(RegNo)
	
	Set DateIndex=$s(aDateType=1:"IndexDate",1:"IndexDeathDate") //1：按报告日期查询 2：按死亡日期查询
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.DTHi("REP",DateIndex,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.DTHi("REP",DateIndex,xDate,xRepID))
			Quit:xRepID=""
			
		    Set objRep=##Class(DHCMed.DTH.Report).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			set RepLoc=objRep.RepLocDR
			continue:RepLoc=""
			if aLocID'="" {
				continue:RepLoc'=aLocID
			} else {
				if aHospID'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(RepLoc,aHospID)
					continue:flg<1
				}
			} 
            Set PatMrNo=objRep.MrNo
			Continue:((MrNo'="")&&(MrNo'=PatMrNo))
			set PapmiNo=objRep.PapmiNo
			continue:(RegNo'="")&&(RegNo'=PapmiNo)
			set PatientName=objRep.Name
			continue:(PatName'="")&&(PatientName'[PatName)
		    
			Set Data=..GetDataByReportID(xRepID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	
	}
	Quit $$$OK
}

ClassMethod QryMaterDeathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMaterDeathInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2) 
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod QryMaterDeathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMaterDeathInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator     : pylian
/// CreateDate  : 2016-07-19
/// Description : 根据报告ID取值死亡证明、孕产妇死亡副卡信息
/// w ##Class(DHCMed.DTHService.ReportMaternalSrv).GetDataByReportID("1")
ClassMethod GetDataByReportID(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set objRep=##Class(DHCMed.DTH.Report).GetObjById(aRepID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.RepStatusDR) return
	Set RepStatus=objRep.RepStatusDR.Description
	Quit:(RepStatus["删除")||(RepStatus["作废") return
	
	Set PatientID=objRep.PatientID
	Set EpisodeID=objRep.EpisodeID
	Set MrNo=objRep.MrNo
	Set:MrNo="" MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I")

	Set DecDate=objRep.DeathDate
	Set:DecDate'="" DecDate=$zd(DecDate,3)
	Set DecTime=objRep.DeathTime
	Set:DecTime'="" DecTime=$zt(DecTime,2)
	Set AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
	Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",AdmType="H":"体检",1:"其他")
	
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"",DecDate,DecTime)
	Set RepDate=objRep.RepDate
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.RepTime
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepUser=objRep.RepUsrDR
	Set:RepUser'="" RepUser=$p($g(^SSU("SSUSR",RepUser)),"^",2)
	Set RepLocID=objRep.RepLocDR
	Set:RepLocID'="" RepLocDesc=$p($g(^CTLOC(RepLocID)),"^",2)
	Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
   	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
   	Quit:'$IsObject(objPatient) return
   	
   	Quit:objPatient.Sex'["女" return  //死亡患者为女性的
   	Set:+Age<0 Age=objRep.Age 
	If (Age["岁") {
		Set PatAge=+Age
	} Else {
		Set PatAge=1
	}
	//Quit:(PatAge>55)||(PatAge<15) return   //死亡年龄大于55小于15的不计入
	
  	Set (mReportID,mRepDate,mRepTime,mRepUser,mRepStatus,mRepLocDesc,mRepLocID)=""
  	Set mRepID=""
  	For {
  		Set mRepID=$o(^DHCMed.DTHi("MaterREP","IndexPatientID"," "_PatientID,mRepID))
  		Quit:mRepID=""
  		
		Set objMthRep=##Class(DHCMed.DTH.MaternalReport).GetObjById(mRepID)
		Continue:'$IsObject(objMthRep)
		Continue:'$IsObject(objMthRep.RepStatusDR)
		Set mRepStatus=objMthRep.RepStatusDR.Description
		Continue:(mRepStatus["删除")
		
		Set mReportID=mRepID
		Set mRepDate=objMthRep.RepDate
		Set:mRepDate'="" mRepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(mRepDate)
		Set mRepTime=objMthRep.RepTime
		Set:mRepTime'="" mRepTime=$zt(mRepTime,1)
		Set mRepUser=objMthRep.RepUsrDR
		Set:mRepUser'="" mRepUser=$p($g(^SSU("SSUSR",mRepUser)),"^",2)
		Set mRepLocID=objMthRep.RepLocDR
		Set:mRepLocID'="" mRepLocDesc=$p($g(^CTLOC(mRepLocID)),"^",2)
		Set:mRepLocDesc["-" mRepLocDesc=$p(mRepLocDesc,"-",2)	
  	}
  	Set:mRepStatus="" mRepStatus="未报"
  	
	Set $li(return,1)=EpisodeID
	Set $li(return,2)=PatientID
	Set $li(return,3)=objPatient.PapmiNo
	Set $li(return,4)=MrNo
	Set $li(return,5)=objPatient.PatientName
	Set $li(return,6)=objPatient.Sex
	Set $li(return,7)=Age
	Set $li(return,8)=AdmType
	Set $li(return,9)=DecDate
	Set $li(return,10)=DecTime
	Set $li(return,11)=objPaadm.DoctorName
	Set $li(return,12)=objPaadm.AdmitDate
	Set AdmLoc=objPaadm.Department
	Set:AdmLoc["-" AdmLoc=$p(AdmLoc,"-",2)
	Set $li(return,13)=AdmLoc
	Set AdmWard=objPaadm.Ward
	Set:AdmWard["-" AdmWard=$p(AdmWard,"-",2)
	Set $li(return,14)=AdmWard
	Set $li(return,15)=objPaadm.Room
	Set $li(return,16)=objPaadm.Bed
	Set $li(return,17)=objPaadm.DisDate
	Set:$li(return,17)="1840-12-31" $li(return,17)=""
	Set $li(return,18)=mReportID
	Set $li(return,19)=mRepDate
	Set $li(return,20)=mRepTime
	Set $li(return,21)=mRepUser
	Set $li(return,22)=mRepStatus
	Set $li(return,23)=mRepLocID
	Set $li(return,24)=mRepLocDesc
	Set $li(return,25)=aRepID
	Set $li(return,26)=RepDate
	Set $li(return,27)=RepTime
	Set $li(return,28)=RepUser
	Set $li(return,29)=RepStatus
	Set $li(return,30)=RepLocID
	Set $li(return,31)=RepLocDesc
	Quit return
}

/// 打印孕产妇死亡副卡
/// w ##Class(DHCMed.DTHService.ReportMaternalSrv).PrintDTHMaterReport("fill(xlSheet,MergCells,DeleteRows",1)
ClassMethod PrintDTHMaterReport(itmjs As %String, aReportID As %String) As %String
{
	n (aReportID,itmjs)
	Set ret=1
	Set fillxlSheet=$p(itmjs,",",1)
	Set mergCells=$p(itmjs,",",2)
	Set deleteRows=$p(itmjs,",",3)	
	Set delimiter="^"
	
	Set t=..GetReportString(aReportID,"")  //参数位置变化
	Set t1=$p(t,$c(1),1)
	Set t2=$p(t,$c(1),2)
		
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,5),"O","JS")_"',4,26);"  // 编号
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,6),"O","JS")_"',4,5);"  // 姓名
	&javascript<#(retval)#>
	
	 //常住址
	Set ConProvince=$p($p(t,delimiter,7),$c(2),3)
	Set ConCity=$p($p(t,delimiter,8),$c(2),3)
	Set ConCounty=$p($p(t,delimiter,9),$c(2),3)
	Set ConPlace=ConProvince_ConCity_ConCounty
    Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(ConPlace,"O","JS")_"',5,5);"
	&javascript<#(retval)#>
	//暂住址
	Set TempProvince=$p($p(t,delimiter,12),$c(2),3)
	Set TempCity=$p($p(t,delimiter,13),$c(2),3)
	Set TempCounty=$p($p(t,delimiter,14),$c(2),3)
	Set TempPlace=TempProvince_TempCity_TempCounty
    Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(TempPlace,"O","JS")_"',6,5);"
    &javascript<#(retval)#>
   
    Set chkY="☑",chkN="□"
	Set row=8,col=5   //户口 1. 本地    2. 非本地 
	Set RegType=$$GetCode($p(t,delimiter,17))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMRegType","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		
		Set DicDesc=$s(DicID=RegType:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+5
	}
	Do rs.Close()
	
	Set chkY="☑",chkN="□"
	Set row=8,col=21   //计划内外
	Set IsPlan=$$GetCode($p(t,delimiter,18))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMIsPlan","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=IsPlan:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,19),"O","JS")_"',10,5);"  // 年龄
	&javascript<#(retval)#>

	Set row=10,col=19   //民族
	Set Nation=$$GetCode($p(t,delimiter,20))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMNation","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=Nation:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=11,col=5   // 文化程度 1. 大专及以上  2. 高中或中专 3. 初中   4. 小学   5. 文盲 	
	Set Education=$$GetCode($p(t,delimiter,21))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMEducation","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=Education:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=13,col=5   //家庭年人均收入（元）1. <1000元   2. 1000元~   3. 2000元~   4. 4000元~   5. 8000元~ 	
	Set FamilIncome=$$GetCode($p(t,delimiter,22))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMFamilIncome","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=FamilIncome:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=14,col=5   //居住地区 1. 平原  2.山区  3. 其他地区 	
	Set ConType=$$GetCode($p(t,delimiter,23))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMConType","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ConType:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()	
		
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,24),"O","JS")_"',15,8);"  // 孕次
	&javascript<#(retval)#>	
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,25),"O","JS")_"',15,16);"  //  产次
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,26),"O","JS")_"',15,28);" // 人工流产、引产次
	&javascript<#(retval)#>

    Set LastMenDate=$p(t,delimiter,27)   //末次月经
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(LastMenDate,1,4),"O","JS")_"',16,6);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(LastMenDate,6,7),"O","JS")_"',16,11);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(LastMenDate,9,10),"O","JS")_"',16,15);"  

	Set DeliveryDate=$p(t,delimiter,28)   //分娩日期
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeliveryDate,1,4),"O","JS")_"',17,6);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeliveryDate,6,7),"O","JS")_"',17,11);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeliveryDate,9,10),"O","JS")_"',17,15);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,29),"O","JS")_"',17,19);"   //分娩时间
	&javascript<#(retval)#>
	
	Set DeathDate=$p(t,delimiter,30)   //死亡日期
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeathDate,1,4),"O","JS")_"',18,6);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeathDate,6,7),"O","JS")_"',18,11);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($Extract(DeathDate,9,10),"O","JS")_"',18,15);"  
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,31),"O","JS")_"',18,19);"  
	&javascript<#(retval)#>
	
	
	Set row=19,col=5,count=0   // 分娩地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院  4. 村接生室 5.家中    6. 途中    7. 其它    9.不详 
	Set DeliveryPosition=$$GetCode($p(t,delimiter,32))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDeliveryPosition","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=DeliveryPosition:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+8
		Set count=count+1
		set:count#4=0 row=row+1,col=5
	}
	Do rs.Close()
	
	Set row=21,col=5,count=0   // 死亡地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院  4. 村接生室 5.家中    6. 途中    7. 其它    9.不详 
	Set DeathPosition=$$GetCode($p(t,delimiter,33))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDeathPosition","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=DeathPosition:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+8
		Set count=count+1
		set:count#4=0 row=row+1,col=5
	}
	Do rs.Close()
	
	Set row=23,col=5   //分娩方式  0. 未娩    1. 自然产   2. 阴道手术产  3. 剖宫产 	
	Set DeliveryWay=$$GetCode($p(t,delimiter,34))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDeliveryWay","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=DeliveryWay:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=24,col=5   //新法接生  1. 是      2. 否  	
	Set IsNewWay=$$GetCode($p(t,delimiter,35))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMIsNewWay","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=IsNewWay:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=25,col=5   //接生者    1. 医务人员  2. 乡村医生 3. 接生员  4. 其他人员
	Set Deliveryer=$$GetCode($p(t,delimiter,36))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDeliveryer","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=Deliveryer:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=26,col=5   //产前检查  1. 有      2. 无  	
	Set IsPreCheck=$$GetCode($p(t,delimiter,37))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMIsPreCheck","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=IsPreCheck:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
		
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,38),"O","JS")_"',27,5);"  /// 初检孕周 周
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,39),"O","JS")_"',27,21);"  /// 产检次数
	&javascript<#(retval)#>	
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,3),"O","JS")_"',28,11);"  // A原因
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,4),"O","JS")_"',29,11);"  // B原因
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,5),"O","JS")_"',30,11);"  // C原因
	&javascript<#(retval)#>
	set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t2,delimiter,6),"O","JS")_"',31,5);"  //  根本原因
	&javascript<#(retval)#>		
		
    Set row=32,col=7   //死因诊断依据    1. 尸检   2. 病理    3. 临床   4. 死后推断  
	Set DiagnoseBasis=$$GetCode($p(t,delimiter,40))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDiagnoseBasis","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=DiagnoseBasis:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=34,col=12   //省级医疗保健机构评审结果  1. 可避免   2. 不可避免  	
	Set ProResult=$$GetCode($p(t,delimiter,41))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMProResult","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=ProResult:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
	}
	Do rs.Close()
	
	Set row=35,col=13   //省级 影响死亡的主要因素       编号1    编号2  编号3
	Set Deliveryer=$$GetCode($p(t,delimiter,42))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMDeliveryer","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=Deliveryer:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set row=36,col=12   //国家级评审结果 1. 可避免   2. 不可避免	
	Set CountryResult=$$GetCode($p(t,delimiter,43))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMCountryResult","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CountryResult:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+7
	}
	Do rs.Close()
	
	Set row=37,col=13   //国家 影响死亡的主要因素       编号1    编号2  编号3
	Set CountryResult=$$GetCode($p(t,delimiter,44))
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("DTMCountryResult","1")
	While rs.Next() {
		Set DicID=rs.Get("myid")
		Set DicDesc=rs.Get("Description")
		Set DicDesc=$s(DicID=CountryResult:chkY,1:chkN)
		Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(DicDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
		Set col=col+6
	}
	Do rs.Close()
	
	Set RepLocDR=$p(t,delimiter,46)
	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocDR)
	Set:'$IsObject(objLoc) objLoc=##class(DHCMed.Base.Ctloc).%New()
	Set objHos=##class(DHCMed.Base.Hospital).GetObjById(objLoc.HospitalDr)
	Set:'$IsObject(objHos) objHos=##class(DHCMed.Base.Hospital).%New()
	Set Hosptail=objHos.Descs
			
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT(Hosptail,"O","JS")_"',40,7);" //上报医院
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,47),"O","JS")_"',40,18);" //上报医师
	&javascript<#(retval)#>
	Set retval=fillxlSheet_"(xlSheet,'"_$ZCVT($p(t,delimiter,48),"O","JS")_"',40,27);" //上报日期	
	&javascript<#(retval)#>
		
	Quit ret

GetCode(txt)
	Quit $p(txt,$c(2),1)
}

}
