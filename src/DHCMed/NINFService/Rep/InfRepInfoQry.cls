/// 名称: DHCMed.NINFService.Rep.InfRepInfoQry
/// 描述: 感染报告相关数据查询
/// 编写者：LiuYH
/// 编写日期: 2013-01-09
Class DHCMed.NINFService.Rep.InfRepInfoQry Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LiuYH
/// CreatDate：   2013-01-09
/// Description:  查询医院感染报告转归信息
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfRepInfoQry","QryRepInfoByDateLoc","1","2013-01-01","2013-01-10","")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String) As %Query(ROWSPEC = "LocDescStr:%String,RepNum:%String,LocRepNum:%String,InfRepNum:%String,InfRepRate:%String,DPNum1:%String,DPNum2:%String,DPNum3:%String,DPNum4:%String,DPNum5:%String,DPNum1Rate:%String,DPNum2Rate:%String,DPNum3Rate:%String,DPNum4Rate:%String,DPNum5Rate:%String,DRNum1:%String,DRNum2:%String,DRNum3:%String,DRNum1Rate:%String,DRNum2Rate:%String,DRNum3Rate:%String,OperNum1:%String,OperNum2:%String,OperNum3:%String,OperNum1Rate:%String,OperNum2Rate:%String,OperNum3Rate:%String,MenNum:%String,WoMenNum:%String,MenNumRate:%String,WoMenNumRate:%String,Age1:%String,Age2:%String,Age3:%String,Age4:%String,Age5:%String,Age6:%String,Age1Rate:%String,Age2Rate:%String,Age3Rate:%String,Age4Rate:%String,Age5Rate:%String,Age6Rate:%String")
{
}

ClassMethod QryRepInfoByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set %ZIndex=$zn
	Set %JIndex=$j
	Set %NIndex="DHCMedNINF"
	
	//按报告日期查询
	If aDateType=1 {
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=0
			For {
				Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
				Quit:xTime=""
				
				Set xLoc=0
				For {
					Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
					Quit:xLoc=""
					Continue:(aRepLoc'="")&&(aRepLoc'=xLoc)
					
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
						Quit:xRepID=""
						Set ReportID=xRepID
						Set xPaadm=""
						Do BuildReportData
					}
				}
			}
		}
	}
	//按入院日期查询
	If aDateType=2 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		//upadte by pylian 2016-02-18 修改入院时间索引
		Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					Set ReportID=xRepID
					Do BuildReportData
				}
			}
		}
	}
	//按出院日期查询
	If aDateType=3 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					Set ReportID=xRepID
					Do BuildReportData
				}
			}
		}
	}
	
	Set NINFManageLocID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFManageLocID","")
	
	//报告总数，科室报告，感染科报告
	Set tRepNum=0,tLocRepNum=0,tInfRepNum=0
	//疾病转归-治愈，好转，无变化，恶化，死亡
	Set (tDPNum1,tDPNum2,tDPNum3,tDPNum4,tDPNum5)=0
	Set (tDPNum1Rate,tDPNum2Rate,tDPNum3Rate,tDPNum4Rate,tDPNum5Rate)=0
		
	//与死亡关系-直接，间接，无关
	Set (tDRNum1,tDRNum2,tDRNum3)=0
	Set (tDRNum1Rate,tDRNum2Rate,tDRNum3Rate)=0
		
	//手术切口分类-表浅，深部，器官腔隙
	Set (tOperNum1,tOperNum2,tOperNum3)=0
	Set (tOperNum1Rate,tOperNum2Rate,tOperNum3Rate)=0
		
	//年龄分类-男，女，0-6,7-17,18-40,41-65,66-89，大于90
	Set (tMenNum,tWoMenNum,tAge1,tAge2,tAge3,tAge4,tAge5,tAge6)=0
	Set (tMenNumRate,tWoMenNumRate,tAge1Rate,tAge2Rate,tAge3Rate,tAge4Rate,tAge5Rate,tAge6Rate)=0
	
	Set LocID=""
	For {
		Set LocID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Loc",LocID))
		Quit:LocID=""
		Continue:(aRepLoc'="")&&(LocID'=aRepLoc)
		set LocDescStr=$p($g(^CTLOC(+LocID)),"^",2)
		set:$p(LocDescStr,"-",2)'="" LocDescStr=$p(DescStr,"-",2) 
		
		//报告总数，科室报告，感染科报告
		Set RepNum=0,LocRepNum=0,InfRepNum=0
		//疾病转归-治愈，好转，无变化，恶化，死亡
		Set (DPNum1,DPNum2,DPNum3,DPNum4,DPNum5)=0
		Set (DPNum1Rate,DPNum2Rate,DPNum3Rate,DPNum4Rate,DPNum5Rate)=0
		
		//与死亡关系-直接，间接，无关
		Set (DRNum1,DRNum2,DRNum3)=0
		Set (DRNum1Rate,DRNum2Rate,DRNum3Rate)=0
		
		//手术切口分类-表浅，深部，器官腔隙
		Set (OperNum1,OperNum2,OperNum3)=0
		Set (OperNum1Rate,OperNum2Rate,OperNum3Rate)=0
		
		//年龄分类-男，女，0-6,7-17,18-40,41-65,66-89，大于90
		Set (MenNum,WoMenNum,Age1,Age2,Age3,Age4,Age5,Age6)=0
		Set (MenNumRate,WoMenNumRate,Age1Rate,Age2Rate,Age3Rate,Age4Rate,Age5Rate,Age6Rate)=0
		
		Set Paadm=""
		For {
			Set Paadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Loc",LocID,Paadm))
			Quit:Paadm=""
			
			Set RepID=""
			For {
				
				Set RepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Loc",LocID,Paadm,RepID))
				Quit:RepID=""
				
				
				Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(RepID)
				Continue:'$IsObject(objReport)
				Set RepNum=RepNum+1	//报告数量
				Set ReportLoc=objReport.ReportLoc
				Set ReportLocID=""
				Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
				If $IsObject(objRepLoc) {
					Set ReportLocID=objRepLoc.Rowid
					Set ReportLocDesc=objRepLoc.Descs
				}
				if (ReportLocID'=NINFManageLocID){
					Set LocRepNum=LocRepNum+1	//临床科室上报
				}else{
					Set InfRepNum=InfRepNum+1	//感染科室上报
				}
				
				Set ObjSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(RepID_"||"_1)
				If $IsObject(ObjSumm.DiseasePrognosis){
					Set DPDesc=ObjSumm.DiseasePrognosis.Description
					Set:DPDesc["治愈" DPNum1=DPNum1+1
					Set:DPDesc["好转" DPNum2=DPNum2+1
					Set:DPDesc["无变化" DPNum3=DPNum3+1
					Set:DPDesc["恶化" DPNum4=DPNum4+1
					Set:DPDesc["死亡" DPNum5=DPNum5+1
				}
				If $IsObject(ObjSumm.DeathRelation){
					Set DRDesc=ObjSumm.DeathRelation.Description
					Set:DRDesc["直接" DRNum1=DRNum1+1
					Set:DRDesc["间接" DRNum2=DRNum2+1
					Set:DRDesc["无关" DRNum3=DRNum3+1
				}
				
					Set xSubID=0
			For {
				Set xSubID=$o(^DHCMed.NINF("InfRep",RepID,"InfPos",xSubID))
				Quit:xSubID=""
			
				Set objSub=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(RepID_"||"_xSubID)
				Continue:'$IsObject(objSub)
				
				Set InfPosDesc=""
				If $IsObject(objSub.InfPos) {
					Set InfPosID=objSub.InfPos.%Id()
					Set InfPosDesc=objSub.InfPos.IPDesc
					}
					Set:InfPosDesc["表浅" OperNum1=OperNum1+1
					Set:InfPosDesc["深部" OperNum2=OperNum2+1
					Set:(InfPosDesc["器官")||(InfPosDesc["腔隙") OperNum3=OperNum3+1
				}	
				
				Set PatientID=$p(^PAADM(Paadm),"^",1)
				
				Set PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Set Sex=PatObj.Sex
				Set Age=PatObj.Age
				Set:Sex["男" MenNum=MenNum+1
				Set:Sex["女" WoMenNum=WoMenNum+1
				
				Set:Age<7 Age1=Age1+1
				Set:(Age>6)&&(Age<18) Age2=Age2+1
				Set:(Age>17)&&(Age<41) Age3=Age3+1
				Set:(Age>40)&&(Age<66) Age4=Age4+1
				Set:(Age>65)&&(Age<90) Age5=Age5+1
				Set:Age>89 Age6=Age6+1
			}
		}
		
		Set tLocDescStr="合计"
		Set tRepNum=tRepNum+RepNum
		Set tLocRepNum=tLocRepNum+LocRepNum
		Set tInfRepNum=tInfRepNum+InfRepNum

		Set tDPNum1=tDPNum1+DPNum1
		Set tDPNum2=tDPNum2+DPNum2
		Set tDPNum3=tDPNum3+DPNum3
		Set tDPNum4=tDPNum4+DPNum4
		Set tDPNum5=tDPNum5+DPNum5
		Set tDRNum1=tDRNum1+DRNum1
		Set tDRNum2=tDRNum2+DRNum2
		Set tDRNum3=tDRNum3+DRNum3

		Set tOperNum1=tOperNum1+OperNum1
		Set tOperNum2=tOperNum2+OperNum2
		Set tOperNum3=tOperNum3+OperNum3

		Set tMenNum=tMenNum+MenNum
		Set tWoMenNum=tWoMenNum+WoMenNum

		Set tAge1=tAge1+Age1
		Set tAge2=tAge2+Age2
		Set tAge3=tAge3+Age3
		Set tAge4=tAge4+Age4
		Set tAge5=tAge5+Age5
		Set tAge6=tAge6+Age6

		Set InfRepRate=0
		if (RepNum'=0) {
			Set InfRepRate=$fn((InfRepNum/RepNum)*100,"",2)_"%"
			
			Set DPNum1Rate=$fn((DPNum1/RepNum)*100,"",2)_"%"
			Set DPNum2Rate=$fn((DPNum2/RepNum)*100,"",2)_"%"
			Set DPNum3Rate=$fn((DPNum3/RepNum)*100,"",2)_"%"
			Set DPNum4Rate=$fn((DPNum4/RepNum)*100,"",2)_"%"
			Set DPNum5Rate=$fn((DPNum5/RepNum)*100,"",2)_"%"
			
			Set DRNum1Rate=$fn((DRNum1/RepNum)*100,"",2)_"%"
			Set DRNum2Rate=$fn((DRNum2/RepNum)*100,"",2)_"%"
			Set DRNum3Rate=$fn((DRNum3/RepNum)*100,"",2)_"%"
			
			Set OperNum1Rate=$fn((OperNum1/RepNum)*100,"",2)_"%"
			Set OperNum2Rate=$fn((OperNum2/RepNum)*100,"",2)_"%"
			Set OperNum3Rate=$fn((OperNum3/RepNum)*100,"",2)_"%"
			
			Set MenNumRate=$fn((MenNum/RepNum)*100,"",2)_"%"
			Set WoMenNumRate=$fn((WoMenNum/RepNum)*100,"",2)_"%"
			
			Set Age1Rate=$fn((Age1/RepNum)*100,"",2)_"%"
			Set Age2Rate=$fn((Age2/RepNum)*100,"",2)_"%"
			Set Age3Rate=$fn((Age3/RepNum)*100,"",2)_"%"
			Set Age4Rate=$fn((Age4/RepNum)*100,"",2)_"%"
			Set Age5Rate=$fn((Age5/RepNum)*100,"",2)_"%"
			Set Age6Rate=$fn((Age6/RepNum)*100,"",2)_"%"
			
		}
		
		Set tInfRepRate=0
		if (tRepNum'=0) {
			Set tInfRepRate=$fn((tInfRepNum/tRepNum)*100,"",2)_"%"
			
			Set tDPNum1Rate=$fn((tDPNum1/tRepNum)*100,"",2)_"%"
			Set tDPNum2Rate=$fn((tDPNum2/tRepNum)*100,"",2)_"%"
			Set tDPNum3Rate=$fn((tDPNum3/tRepNum)*100,"",2)_"%"
			Set tDPNum4Rate=$fn((tDPNum4/tRepNum)*100,"",2)_"%"
			Set tDPNum5Rate=$fn((tDPNum5/tRepNum)*100,"",2)_"%"
			
			Set tDRNum1Rate=$fn((tDRNum1/tRepNum)*100,"",2)_"%"
			Set tDRNum2Rate=$fn((tDRNum2/tRepNum)*100,"",2)_"%"
			Set tDRNum3Rate=$fn((tDRNum3/tRepNum)*100,"",2)_"%"
			
			Set tOperNum1Rate=$fn((tOperNum1/tRepNum)*100,"",2)_"%"
			Set tOperNum2Rate=$fn((tOperNum2/tRepNum)*100,"",2)_"%"
			Set tOperNum3Rate=$fn((tOperNum3/tRepNum)*100,"",2)_"%"
			
			Set tMenNumRate=$fn((tMenNum/tRepNum)*100,"",2)_"%"
			Set tWoMenNumRate=$fn((tWoMenNum/tRepNum)*100,"",2)_"%"
			
			Set tAge1Rate=$fn((tAge1/tRepNum)*100,"",2)_"%"
			Set tAge2Rate=$fn((tAge2/tRepNum)*100,"",2)_"%"
			Set tAge3Rate=$fn((tAge3/tRepNum)*100,"",2)_"%"
			Set tAge4Rate=$fn((tAge4/tRepNum)*100,"",2)_"%"
			Set tAge5Rate=$fn((tAge5/tRepNum)*100,"",2)_"%"
			Set tAge6Rate=$fn((tAge6/tRepNum)*100,"",2)_"%"	
		}
		
		Set $li(Data,1)=LocDescStr      //科室
		Set $li(Data,2)=RepNum  //报告总数
		Set $li(Data,3)=LocRepNum	//科室报告数
		Set $li(Data,4)=InfRepNum	//感染科报告数
		Set $li(Data,5)=InfRepRate	//漏报率
		
		Set $li(Data,6)=DPNum1	//治愈
		Set $li(Data,7)=DPNum2	//好转
		Set $li(Data,8)=DPNum3	//无变化
		Set $li(Data,9)=DPNum4	//恶化
		Set $li(Data,10)=DPNum5	//死亡
		Set $li(Data,11)=DPNum1Rate	
		Set $li(Data,12)=DPNum2Rate	
		Set $li(Data,13)=DPNum3Rate	
		Set $li(Data,14)=DPNum4Rate	
		Set $li(Data,15)=DPNum5Rate
		
		Set $li(Data,16)=DRNum1	//直接
		Set $li(Data,17)=DRNum2	//间接
		Set $li(Data,18)=DRNum3	//无关
		Set $li(Data,19)=DRNum1Rate
		Set $li(Data,20)=DRNum2Rate
		Set $li(Data,21)=DRNum3Rate
		
		Set $li(Data,22)=OperNum1	//表浅
		Set $li(Data,23)=OperNum2	//深部
		Set $li(Data,24)=OperNum3	//器官或腔隙
		Set $li(Data,25)=OperNum1Rate
		Set $li(Data,26)=OperNum2Rate
		Set $li(Data,27)=OperNum3Rate
		
		Set $li(Data,28)=MenNum	//男
		Set $li(Data,29)=WoMenNum	//女
		Set $li(Data,30)=MenNumRate
		Set $li(Data,31)=WoMenNumRate
		Set $li(Data,32)=Age1	//0-6
		Set $li(Data,33)=Age2	//7-19
		Set $li(Data,34)=Age3	//18-40
		Set $li(Data,35)=Age4	//41-65
		Set $li(Data,36)=Age5	//66-89
		Set $li(Data,37)=Age6	//90以上
		Set $li(Data,38)=Age1Rate
		Set $li(Data,39)=Age2Rate
		Set $li(Data,40)=Age3Rate
		Set $li(Data,41)=Age4Rate
		Set $li(Data,42)=Age5Rate
		Set $li(Data,43)=Age6Rate
	
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set Data=$lb(tLocDescStr,tRepNum,tLocRepNum,tInfRepNum,tInfRepRate,tDPNum1,tDPNum2,tDPNum3,tDPNum4,tDPNum5,tDPNum1Rate,tDPNum2Rate,tDPNum3Rate,tDPNum4Rate,tDPNum5Rate,tDRNum1,tDRNum2,tDRNum3,tDRNum1Rate,tDRNum2Rate,tDRNum3Rate,tOperNum1,tOperNum2,tOperNum3,tOperNum1Rate,tOperNum2Rate,tOperNum3Rate,tMenNum,tWoMenNum,tMenNumRate,tWoMenNumRate,tAge1,tAge2,tAge3,tAge4,tAge5,tAge6,tAge1Rate,tAge2Rate,tAge3Rate,tAge4Rate,tAge5Rate,tAge6Rate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
		
	K ^TMP(%ZIndex,%JIndex,%NIndex,"Loc")
	
	Quit $$$OK
	
BuildReportData
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ReportID)
	Quit:'$IsObject(objReport)
	
	Set:$g(xPaadm)="" xPaadm=objReport.EpisodeID

	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusCode=objReport.ReportStatus.Code
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
	
	Quit:ReportStatusDesc["删除"
	
	Set ReportLoc=objReport.ReportLoc
	Set TransID=objReport.TransID
	
	Set TransSubID=$p(TransID,"||",2)
	
	Quit:TransSubID=""
	
	Quit:'$d(^PAADM(xPaadm,"TRANS",TransSubID))
	
	Set AdmLocID=$p($g(^PAADM(xPaadm,"TRANS",TransSubID)),"^",6)
	Set:AdmLocID="" AdmLocID=ReportLoc
	//考虑到 科室搂报，感染科补报情况
	
	;Quit:(aRepLoc'="")&&(AdmLocID'=LocID)
	
	Set ^TMP(%ZIndex,%JIndex,%NIndex,"Loc",AdmLocID,xPaadm,ReportID)=""
	
	Quit
}

ClassMethod QryRepInfoByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2013-03-19
/// Description:  手术切口调查统计
/// Table：       DHCMed.NINF.Rep.InfReportOpr
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfRepInfoQry","StaOperCutInf","2013-01-01","2013-08-01")
Query StaOperCutInf(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,OperLocID:%String,OperLocDesc:%String,OperationDesc:%String,OperDate:%String,OperDocID:%String,OperDocDesc:%String,OperationTypeCode:%String,OperationType:%String,AnesthesiaCode:%String,Anesthesia:%String,CuteTypeCode:%String,CuteType:%String,CuteHealingCode:%String,CuteHealing:%String,CuteInfFlagCode:%String,CuteInfFlag:%String,OperInfTypeCode:%String,OperInfType:%String,ASAScoreCode:%String,ASAScore:%String,NNISScore:%String") [ SqlProc ]
{
}

ClassMethod StaOperCutInfExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	//^DHCMed.NINFi("InfRep",0,"Opr","IndexStDate",62634,47,2)
	For xOperDate=aFromDate:1:aToDate {
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"Opr","IndexStDate",xOperDate,xRepID))
			Quit:xRepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.ReportStatus)
			Set ReportStatus=objRep.ReportStatus.Code
			Continue:(ReportStatus="0")||(ReportStatus="1")  //删除和草稿状态报告不算
			Set EpisodeID=objRep.EpisodeID
			
			Set SummID=$o(^DHCMed.NINF("InfRep",xRepID,"Summ",""),-1)
			Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(xRepID_"||"_SummID)
			Continue:'$IsObject(objSumm)
			Set TransLoc=objSumm.TransLoc
			Continue:TransLoc=""
			Set OperLocID=TransLoc
			Set OperLocDesc=$p($g(^CTLOC(+OperLocID)),"^",2)
			Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
			Set TransID=objSumm.TransID
			Continue:TransID=""
			
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCMed.NINFi("InfRep",0,"Opr","IndexStDate",xOperDate,xRepID,xSubID))
				Quit:xSubID=""
				
				Set objSub=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(xRepID_"||"_xSubID)
				Continue:'$IsObject(objSub)
				
				Set (OperationDesc,OperDate,OperDocID,OperDocDesc)=""
				Set (OperationTypeCode,OperationType,AnesthesiaCode,Anesthesia)=""
				Set (CuteTypeCode,CuteType,CuteHealingCode,CuteHealing)=""
				Set (CuteInfFlagCode,CuteInfFlag,OperInfTypeCode,OperInfType)=""
				Set (ASAScoreCode,ASAScore,NNISScore)=""
				
				//手术名称
				Set OperationID=objSub.OperationID
				Set OperationDesc=objSub.OperationDesc
				//手术开始时间、手术结束时间、手术时间(小时)、手术日期
				Set OperStartDate=objSub.OperStartDate
				Set OperStartTime=objSub.OperStartTime
				Set OperEndDate=objSub.OperEndDate
				Set OperEndTime=objSub.OperEndTime
				Set OperTime=((OperEndDate-OperStartDate)*24)+((OperEndTime-OperStartTime)\3600)
				Set OperDate=$zd(OperStartDate,3)
				//术者、手术类型、麻醉方式、切口类型、愈合情况
				//是否感染、感染类型、是否院感、ASA评分
				Set OperDocID=objSub.OperDoc
				If OperDocID'="" {
					Set OperDocDesc=$p($g(^SSU("SSUSR",+OperDocID)),"^",2)
				}
				If $IsObject(objSub.OperationType) {
					Set OperationType=objSub.OperationType.Description
					Set OperationTypeCode=objSub.OperationType.Code
				}
				If $IsObject(objSub.Anesthesia) {
					Set Anesthesia=objSub.Anesthesia.Description
					Set AnesthesiaCode=objSub.Anesthesia.Code
				}
				If $IsObject(objSub.CuteType) {
					Set CuteType=objSub.CuteType.Description
					Set CuteTypeCode=objSub.CuteType.Code
				}
				If $IsObject(objSub.CuteHealing) {
					Set CuteHealing=objSub.CuteHealing.Description
					Set CuteHealingCode=objSub.CuteHealing.Code
				}
				If $IsObject(objSub.CuteInfFlag) {
					Set CuteInfFlag=objSub.CuteInfFlag.Description
					Set CuteInfFlagCode=objSub.CuteInfFlag.Code
				}
				If $IsObject(objSub.OperInfType) {
					Set OperInfType=objSub.OperInfType.Description
					Set OperInfTypeCode=objSub.OperInfType.Code
				}
				If $IsObject(objSub.ASAScore) {
					Set ASAScore=objSub.ASAScore.Description
					Set ASAScoreCode=objSub.ASAScore.Code
				}
				//手术危险等级评分
				Set NNISScore=0
				If OperTime>3 {
					Set NNISScore=NNISScore+1
				}
				If CuteTypeCode>2 {
					Set NNISScore=NNISScore+1
				}
				If ASAScoreCode>2 {
					Set NNISScore=NNISScore+1
				}
				
				Set ReportID=xRepID_"||"_xSubID
				Set Data=$lb(ReportID,EpisodeID,OperLocID,OperLocDesc,OperationDesc,OperDate,OperDocID,OperDocDesc)
				Set Data=Data_$lb(OperationTypeCode,OperationType,AnesthesiaCode,Anesthesia)
				Set Data=Data_$lb(CuteTypeCode,CuteType,CuteHealingCode,CuteHealing)
				Set Data=Data_$lb(CuteInfFlagCode,CuteInfFlag,OperInfTypeCode,OperInfType)
				Set Data=Data_$lb(ASAScoreCode,ASAScore,NNISScore)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod StaOperCutInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaOperCutInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaOperCutInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaOperCutInfExecute ]
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
