/// <H3>医院感染综合监测统计</H3>
/// <H3>创建者：李阳</H3>
/// <H3>创建日期：2012-07-20</H3>
Class DHCMed.NINFService.Sta.INFControlSta Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>功能：通过日期分科室、病区统计医院感染率情况</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>监控开始日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>ToDate</B>监控结束日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>DateType</B>日期类别：1--入院日期  2--出院日期  3--在院病人（忽略FromDate、ToDate两个参数）</LI>
/// <LI><B>CtlocList</B>科室列表（<B>CT_Loc</B>表），用【^】分割，如：^科室1^科室2^科室3^ </LI>
/// <LI><B>WardList</B>病房列表（<B>PAC_Ward</B>表），用【^】分割，如：^病房1^病房2^病房3^ </LI>
/// </OL>
/// <H4>返回字段:</H4>
/// <OL>
/// <LI>DepID:%String:科室ID（<B>CT_Loc</B>表）</LI>
/// <LI>WardID:%String:病房ID（<B>PAC_Ward</B>表）</LI>
/// <LI>DepName:%String:科室/病房名称</LI>
/// <LI>InfNumber:%String:感染人数</LI>
/// <LI>DisNumber:%String:出院人数</LI>
/// <LI>InfPercent:%String:感染率</LI>
/// </OL>
/// <H4>实例：</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.INFControlSta","StaByDate","2012-08-01","2013-09-01",3,"","",1)
Query StaByDate(FromDate As %String, ToDate As %String, DateType As %String, CtlocList As %String, WardList As %String, DepType As %String) As %Query(ROWSPEC = "DepID:%String,WardID:%String,DepName:%String:科室/病房名称,DisNumber:%Integer:出院人数,InfNumber:%Integer:感染人数,InfPercent:%Float:感染率,InfPercent1000:%Float:千床感染率,Fee:%Float:次均费用,Anti:%Float:抗生素使用率,SendLabs:%Float:送检率,Bacteria:%Float:阳性率,AvgDays:%Float:次均住院日,Ventilator:%Float:呼吸机肺炎,Catheter:%Float:导尿管相关感染,VenousCatheter:%Float:静脉置管感染率,OpePos:%Float:手术部位感染率,NotRepINF:%Float:漏报率,AntiNum:%Float:抗生素使用人数,SendLabsNum:%Float:送检人数,BacteriaNum:%Float:阳性人数,VentilatorNum:%Float:呼吸机肺炎,CatheterNum:%Float:导尿管相关感染,VenousCatheterNum:%Float:静脉置管感染人数,OpePosNum:%Float:手术部位感染人数,NotRepINFNum:%Float:漏报人数") [ SqlProc ]
{
}

ClassMethod StaByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DateType As %String, CtlocList As %String, WardList As %String, DepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("INFCC")
	Quit:'$IsObject(objSubject) $$$OK    //BY LIKAI 2012-09-02 
	Do objSubject.%Close()
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	Set Inf1000StoreID=..CalcInfPercent1000(FromDate,ToDate,DepType)
	Set tmp=$$GetInfection(FromDate,ToDate)
	Set PaadmStoreID=##class(DHCMed.CCService.IntegratedCtrl.Common).GetEpisodeList(FromDate,ToDate,DateType,"I",CtlocList,WardList)
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID))	
		Quit:DepID=""
		Set WardID=""
		For {
			Set WardID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID,WardID))
			Quit:WardID=""
			Set EpisodeID=""
			Set:DepType=1 StoreID=DepID
			Set:DepType=2 StoreID=WardID
			For {
				Set EpisodeID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID,WardID,EpisodeID))
				Quit:EpisodeID=""
				Set tmpData=$g(^CacheTemp(repid,"StaByDate",StoreID))
				Set $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //出院人数
				Set $p(tmpData,"^",3)=$p(tmpData,"^",3)+##class(DHCMed.CCService.Feedback.EpisodeService).GetTotalFee(EpisodeID) //总费用
				//Set IsInfect=$$GetInfectionData(EpisodeID)>0 //是否是医院感染患者
				//Set:IsInfect $p(tmpData,"^",2)=$p(tmpData,"^",2)+1 //感染人数
				//Set:((IsInfect>0)&&(+$$CheckIntCheckResult(EpisodeID,"SendLabs")>0)) $p(tmpData,"^",4)=$p(tmpData,"^",4)+1 //医院感染送检数量
				//Set:((IsInfect>0)&&(+$$CheckIntCheckResult(EpisodeID,"Bacteria")>0)) $p(tmpData,"^",5)=$p(tmpData,"^",5)+1 //医院感染 阳性数量
				Set:(($$CheckIntCheckResult(EpisodeID,"Ventilator")>0)&&($$CheckIntCheckResult(EpisodeID,"Pneumoni")>0)) $p(tmpData,"^",6)=$p(tmpData,"^",6)+1 //呼吸机肺炎
				Set:(($$CheckIntCheckResult(EpisodeID,"Catheter")>0)&&($$CheckIntCheckResult(EpisodeID,"UrinaryInfection")>0)) $p(tmpData,"^",7)=$p(tmpData,"^",7)+1 //导尿管相关泌尿系感染
				Set:(($$CheckIntCheckResult(EpisodeID,"VenousCatheter")>0)&&($$CheckInfPos(EpisodeID,"2","","08^09^10^11")>0)) $p(tmpData,"^",8)=$p(tmpData,"^",8)+1 //各科室/病区置管相关血流性感染率
				Set:($$GetOperatonData(EpisodeID)>0) $p(tmpData,"^",9)=$p(tmpData,"^",9)+1 //手术部位相关感染率
				Set:($$CheckIntCheckResult(EpisodeID,"Anti")>0) $p(tmpData,"^",10)=$p(tmpData,"^",10)+1 //4、各科室/病区抗菌药物使用率柱状图
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				if (objAdm.DisDate'="")
				{
					Set Days=$zdh(objAdm.DisDate,3)-$zdh(objAdm.AdmitDate,3)
				}
				else
				{
					Set Days=+$h-$zdh(objAdm.AdmitDate,3)
				}
				Set $p(tmpData,"^",11)=$p(tmpData,"^",11)+Days  //总占用床日数
				Set:($$IsNotRepInfReport(EpisodeID,objSubject.%Id())>0) $p(tmpData,"^",12)=$p(tmpData,"^",12)+1 //漏报人数
				Set ^CacheTemp(repid,"StaByDate",StoreID)=tmpData
			}	
			//Modified By LiYang 2013-05-26 修改综合检测中对于医院感染统计途径，按照报告日期、报告科室计算
			Set tmpData=$g(^CacheTemp(repid,"StaByDate",StoreID))
			Set:DepType=1 Index="LocID"
			Set:DepType=2 Index="WardID"
			Set $p(tmpData,"^",2)=$g(^CacheTemp(repid,"InfEpisodeList",Index,StoreID,"EpisodeID"))
			Set $p(tmpData,"^",4)=$g(^CacheTemp(repid,"InfEpisodeList",Index,StoreID,"SendLabs"))
			Set $p(tmpData,"^",5)=$g(^CacheTemp(repid,"InfEpisodeList",Index,StoreID,"Bacteria"))
			Set ^CacheTemp(repid,"StaByDate",StoreID)=tmpData
		}
	}
	
	
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp(repid,"StaByDate",DepID))
		Quit:DepID=""
		Set tmpData=$g(^CacheTemp(repid,"StaByDate",DepID))
		Set data=$lb("")
		if (DepType=1)
		{
			Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
			Set:$IsObject(objDep)=0 objDep=##class(DHCMed.Base.Ctloc).%New()
			Do objDep.%Close()
			Set DepDesc=objDep.Descs
			Set $li(data,1)=objDep.Rowid  //科室ID
			Set $li(data,2)="" //病房ID
			Set $li(data,3)=objDep.Descs //病房名称
			Set:objDep.Descs["-" $li(data,3)=$p(objDep.Descs,"-",2) //去掉科室名称中的拼音前缀
		}
		if (DepType=2)
		{
			Set objDep=##class(DHCMed.Base.PacWard).GetObjById(DepID)
			Set:$IsObject(objDep)=0 objDep=##class(DHCMed.Base.PacWard).%New()
			Do objDep.%Close()
			Set DepDesc=objDep.Descs
			Set $li(data,1)=""  //科室ID
			Set $li(data,2)=objDep.Rowid //病房ID
			Set $li(data,3)=objDep.Descs //病房名称
			Set:objDep.Descs["-" $li(data,3)=$p(objDep.Descs,"-",2) //去掉科室名称中的拼音前缀
			
		}		
		Set $li(data,4)=$p(tmpData,"^",1) //出院人数
		Set PeopleCnt=$p(tmpData,"^",1) //出院人数
		Set $li(data,5)=$p(tmpData,"^",2) //感染人数
		Set InfCnt=$p(tmpData,"^",2) //感染人数
		Set $li(data,6)=0 //感染率
		if (PeopleCnt>0)
		{
			Set $li(data,6)=$Number($p(tmpData,"^",2)/$p(tmpData,"^",1),2) //感染率
		}
		
		Set $li(data,7)=$g(^CacheTemp(Inf1000StoreID,DepID)) //千床感染率
		Set $li(data,8)=""
		Set:PeopleCnt>0 $li(data,8)=$Number($p(tmpData,"^",3)/PeopleCnt,2) //次均费用
		Set $li(data,9)=""
		Set:PeopleCnt>0 $li(data,9)=$Number($p(tmpData,"^",10)/PeopleCnt,2) //Anti:%Float:抗生素使用率
		Set $li(data,10)=""
		Set:InfCnt>0 $li(data,10)=$Number($p(tmpData,"^",4)/InfCnt,2) //SendLabs:%Float:送检率	
		Set $li(data,11)=""
		Set:InfCnt>0 $li(data,11)=$Number($p(tmpData,"^",5)/InfCnt,2) //Bacteria:%Float:阳性率		
		Set $li(data,12)=""
		Set:PeopleCnt>0 $li(data,12)=$Number($p(tmpData,"^",11)/PeopleCnt,2) //AvgDays:%Float:次均住院日	
		Set $li(data,13)=""
		Set:InfCnt>0 $li(data,13)=$Number($p(tmpData,"^",6)/InfCnt,2) //Ventilator:%Float:呼吸机肺炎	
		Set $li(data,14)=""
		Set:InfCnt>0 $li(data,14)=$Number($p(tmpData,"^",7)/InfCnt,2) //Catheter:%Float:导尿管相关感染	
		Set $li(data,15)=""
		Set:PeopleCnt>0 $li(data,15)=$Number($p(tmpData,"^",8)/PeopleCnt,2) //VenousCatheter:%Float:静脉置管感染率
		Set $li(data,16)=""
		Set:PeopleCnt>0 $li(data,16)=$Number($p(tmpData,"^",9)/PeopleCnt,2) //OpePos:%Float:手术部位感染率
		Set:PeopleCnt>0 $li(data,17)=$Number($p(tmpData,"^",12)/PeopleCnt,2) //漏报率
		
		//Add By LiYang 2013-01-30 增加各种指标数量的输出
		Set $li(data,18)=$p(tmpData,"^",10) //AntiNum:%Float:抗生素使用人数
		Set $li(data,19)=$p(tmpData,"^",4) //SendLabsNum:%Float:送检人数
		Set $li(data,20)=$p(tmpData,"^",5) //BacteriaNum:%Float:阳性人数
		Set $li(data,21)=$p(tmpData,"^",6) //VentilatorNum:%Float:呼吸机肺炎
		Set $li(data,22)=$p(tmpData,"^",7) //CatheterNum:%Float:导尿管相关感染
		Set $li(data,23)=$p(tmpData,"^",8) //VenousCatheterNum:%Float:静脉置管感染人数
		Set $li(data,24)=$p(tmpData,"^",9) //OpePosNum:%Float:手术部位感染人数
		Set $li(data,25)=$p(tmpData,"^",12) //NotRepINFNum:%Float:漏报人数		
		
		
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}	
	Kill ^CacheTemp("EpisodeList",PaadmStoreID)
	Kill ^CacheTemp(repid,"StaByDate")
	Kill ^CacheTemp(repid,"InfEpisodeList")
	Kill ^CacheTemp(Inf1000StoreID)
	Quit $$$OK

GetInfection(FromDate,ToDate)
	n (repid,FromDate,ToDate,objSubject)
	Set arry=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	For i=1:1:$ll(arry) {
		Set ReportID=$li(arry)
		Continue:ReportID=""
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set tmpWard=..GetDepAndWard(objRep)
		Set LocID=$p(tmpWard,"^",3)
		Set WardID=$p(tmpWard,"^",4)
		Set EpisodeID=objRep.EpisodeID
		
		Set SendLabs=+$$CheckIntCheckResult(EpisodeID,"SendLabs")
		Set Bacteria=+$$CheckIntCheckResult(EpisodeID,"Bacteria")
		Set ^CacheTemp(repid,"InfEpisodeList","LocID",LocID,"EpisodeID",EpisodeID)=""
		Set ^CacheTemp(repid,"InfEpisodeList","WardID",WardID,"EpisodeID",EpisodeID)=""
		Set:SendLabs>0 ^CacheTemp(repid,"InfEpisodeList","LocID",LocID,"SendLabs",EpisodeID)=""
		Set:Bacteria>0 ^CacheTemp(repid,"InfEpisodeList","LocID",LocID,"Bacteria",EpisodeID)=""
		Set:SendLabs>0 ^CacheTemp(repid,"InfEpisodeList","WardID",WardID,"SendLabs",EpisodeID)=""
		Set:Bacteria>0 ^CacheTemp(repid,"InfEpisodeList","WardID",WardID,"Bacteria",EpisodeID)=""
	}
	Set Index=""
	For {
		Set Index=$o(^CacheTemp(repid,"InfEpisodeList",Index))
		Quit:Index=""
		Set LocID=""
		For {
			Set LocID=$o(^CacheTemp(repid,"InfEpisodeList",Index,LocID))
			Quit:LocID=""
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				Set ^CacheTemp(repid,"InfEpisodeList",Index,LocID,"EpisodeID")=$g(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"EpisodeID"))+1				}
		}
	}
	
	Set Index=""
	For {
		Set Index=$o(^CacheTemp(repid,"InfEpisodeList",Index))
		Quit:Index=""
		Set LocID=""
		For {
			Set LocID=$o(^CacheTemp(repid,"InfEpisodeList",Index,LocID))
			Quit:LocID=""
						
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"SendLabs",EpisodeID))
				Quit:EpisodeID=""
				Set ^CacheTemp(repid,"InfEpisodeList",Index,LocID,"SendLabs")=$g(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"SendLabs"))+1				
			}
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"Bacteria",EpisodeID))
				Quit:EpisodeID=""
				Set ^CacheTemp(repid,"InfEpisodeList",Index,LocID,"Bacteria")=$g(^CacheTemp(repid,"InfEpisodeList",Index,LocID,"Bacteria"))+1
			}	
		}	
	}
	Quit 0
	

	//医院感染信息
GetInfectionData(EpisodeID)
	n (EpisodeID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Quit:$IsObject(arryReport)=0 0
	Set intCounter=0
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set intCounter=intCounter+1
	}
	Quit intCounter
	//手术部位信息
GetOperatonData(EpisodeID)
	n (EpisodeID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Quit:$IsObject(arryReport)=0 0
	Set intCounter=0
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set arryOperation=objRep.GetOperations(objRep.ReportID)
		For j=1:1:arryOperation.Count() {
			Set objOpe=arryOperation.GetAt(j)
			Continue:objOpe.OperInfType.Code=0
			Set intCounter=intCounter+1
		}
	}
	Quit intCounter
	
	//综合监测信息
CheckIntCheckResult(EpisodeID,Keyword)
	n (EpisodeID,Keyword,objSubject)
	Set num=##class(DHCMed.CCService.IntegratedCtrl.Interface).GetCtlResultSubTotalKeyWord(EpisodeID,objSubject.%Id(),Keyword)
	Quit num

	//过滤医院感染部位信息
CheckInfPos(EpisodeID,PosCode,OpeCode,DiaCode)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()
	Set intINFRepCnt=0
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0		
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set arryPos=objRep.GetInfPos(objRep.ReportID)
		Set posFlag=0 //过滤部位信息
		For j=1:1:arryPos.Count() {
			Set objPos=arryPos.GetAt(j)
			Continue:((objPos.InfPos.Code'=PosCode)&&(PosCode'="")) //感染部位过滤
			Set flag=0
			For k=1:1:objPos.InfPosOpr.Count() {
				Set objOpe=objPos.InfPosOpr.GetAt(k)
				Set:objOpe.Code=OpeCode flag=1
			}
			Continue:flag=0 //侵害操作过滤
			Continue:((DiaCode'[objPos.InfDiag.Code)&&(DiaCode'="")) //感染诊断
			Set posFlag=1
		}
		Continue:posFlag=0
		Set intINFRepCnt=intINFRepCnt+1
	}
	Quit intINFRepCnt

	//是否漏报
IsNotRepInfReport(EpisodeID,SubjectID)
	n (EpisodeID,SubjectID)
	Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()
	Set intINFRepCnt=0
	For i=1:1:arryReport.Count() {
		Set objRep=arryReport.GetAt(i)
		Continue:$IsObject(objRep)=0
		Continue:objRep.ReportType.Code'="COMP" //医院感染报告
		Continue:objRep.ReportStatus.Code'=3 //审核状态
		Set intINFRepCnt=intINFRepCnt+1
	}
	Set FeedbackID=""
	Set AcceptCnt=0
	For {
		Set FeedbackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,SubjectID,FeedbackID))
		Quit:FeedbackID=""
		Set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedbackID)
		Continue:$IsObject(objFeedback)=0
		SET:(objFeedback.Status=1) AcceptCnt=AcceptCnt+1
	}
	Set ret=((arryReport.Count()=0)&&(AcceptCnt>0))
	Quit ret
}

ClassMethod StaByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaByDateExecute ]
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

/// <H3>计算千床感染率</H3>
/// <H4>参数</H4>
/// <OL>
/// <LI>FromDate:开始日期，Cache日期格式</LI>
/// <LI>ToDate:结束日期，Cache日期格式</LI>
/// <LI>DepType:科室类型  1--科室  2--病房</LI>
/// </OL>
/// <H4>返回值<H4>
/// %Integer:临时Global的存储位置<BR/>
/// 如：^CacheTemp({存储ID},{科室ID})={千床感染率}
/// <H4>测试</H4>
/// w ##class(DHCMed.CCService.IntegratedCtrl.INFControlSta).CalcInfPercent1000($zdh("2012-08-01",3),$zdh("2012-08-31",3),1)
ClassMethod CalcInfPercent1000(FromDate As %Date, ToDate As %Date, DepType As %Integer) As %Integer
{
	n (FromDate, ToDate, DepType)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("INFCC")
	Set StoreID=$I(^CacheTemp)
	Quit:$IsObject(objSubject)=0 StoreID
	Set arryEpisode=##class(DHCMed.CCService.IntegratedCtrl.Interface).GetCtlResultByKeywordActDate(objSubject.%Id(),"InHospital",FromDate,ToDate)
	For i=1:1:arryEpisode.Count() {
		Set objResult=arryEpisode.GetAt(i)
		Continue:$IsObject(objResult)=0
		Set DepID=$p(objResult.DataValue,"^",2)
		Set WardID=$p(objResult.DataValue,"^",3)
		Set:DepType=1 Dep=DepID
		Set:DepType=2 Dep=WardID
		Set data=$g(^CacheTemp(StoreID,Dep))
		Set $p(data,"^",1)=$p(data,"^",1)+1 //在院人数
		Set arryReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(objResult.EpisodeID)
		Set:$IsObject(arryReport)=0 arryReport=##class(%ListOfObjects).%New()
		Set InfFlag=0
		For j=1:1:arryReport.Count() {
			Set objRep=arryReport.GetAt(j)
			Continue:$IsObject(objRep)=0
			Continue:objRep.ReportType.Code'="COMP" //医院感染报告
			Continue:objRep.ReportStatus.Code'=3 //审核状态
			Set InfFlag=1
		}
		Set:InfFlag=1 $p(data,"^",2)=$p(data,"^",2)+1 //感染人数
		Set ^CacheTemp(StoreID,Dep)=data
	}
	
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp(StoreID,DepID))
		Quit:DepID=""
		Set data=$g(^CacheTemp(StoreID,DepID))
		Set Discharge=+$p(data,"^",1)
		Set Inf=+$p(data,"^",2)
		if (+Discharge>0)
		{
			Set percent=$Number(Inf/Discharge*1000,2)
			Set ^CacheTemp(StoreID,DepID)=percent
		}
		else
		{
			Set ^CacheTemp(StoreID,DepID)=0
		}
		
	}
	Quit StoreID
}

/// 获取报告所在科室、病区
/// 输入参数：objRep   医院感染报告
/// 输出参数：LocDesc_"^"_WardDesc_"^"_LocID_"^"_WardID
ClassMethod GetDepAndWard(objRep)
{
	n (objRep)
	Set ret=""
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objRep.EpisodeID)
	If objAdm'="" Do objAdm.%Close()	
	Set objSumm=##class(DHCMed.NINF.Srv.InfReport).GetReportSumm(objRep.ReportID)
	Set locID=""
	Set wardID=""
	if (objSumm.TransID'="") 
	{
		Set EpisodeID=$p(objSumm.TransID,"||",1)
		Set ChildSub=$p(objSumm.TransID,"||",2)
		For {
			Set ChildSub=$o(^PAADM(EpisodeID,"TRANS",ChildSub))
			Quit:ChildSub=""
			Set transData=$g(^PAADM(EpisodeID,"TRANS",ChildSub))
			Set locID=$p(transData,"^",6)
			Set wardID=$p(transData,"^",9)
			Quit:((locID'=objSumm.TransLoc)&&(locID=""))
		}
		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(objSumm.TransLoc)
		Do objLoc.%Close()
		Set objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
		Set:'$IsObject(objWard) objWard=##class(DHCMed.Base.PacWard).%New()		
		Set LocDesc=objLoc.Descs
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set WardDesc=objWard.Descs
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		Set DepDesc=objLoc.Descs
		Set LocID=objSumm.TransLoc
		Set WardID=wardID
	}
	else
	{
		Set LocDesc=objAdm.Department
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set WardDesc=objAdm.Ward
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		Set DepDesc=objAdm.Department
		Set LocID=objAdm.DepartmentID
		Set WardID=objAdm.WardID			
	}	
	Set ret=LocDesc_"^"_WardDesc_"^"_LocID_"^"_WardID
	Quit ret
}

}
