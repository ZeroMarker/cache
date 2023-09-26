/// 查询门诊病历患者
Class EPRservice.Quality.GetOutPatientList Extends %RegisteredObject
{

/// creater:  ZHX
/// Create Date:	2019-11-18
/// Description:	质控患者查询
/// Return:         患者基本信息  StartDate,EndDate,AdmStatus,selectPro,specialAdm
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.Quality.GetOutPatientList","GetOutPatientList","2019-02-01","2019-02-02","A","0.1")
Query GetOutPatientList(StartDate As %Date, EndDate As %Date, AdmStatus As %String, LocIds As %Text, selectPro As %String, extractNums As %String, HOSPID = "") As %Query(ROWSPEC = "PAPMIDR,PAADMRowID,PAPMIName,PAPMISex,PAAdmDepCodeDR,MainDiagnos,Age,length,LocNumber,extractPro,LocName,number")
{
}

ClassMethod GetOutPatientListExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, AdmStatus As %String, LocIds As %Text, selectPro As %String, extractNums As %String, HOSPID = "") As %Status
{
		
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	s AdmDate = ""
	k ^CacheTemp("EPRQuality","PaAdmList")
	k ^tempquality("quality")                // 临时存放当前名下就诊号
	k ^tempquality  
	
	s ^tempSelect("PAADMRowID")=""
	
	s IncludeEmergencyFlag=1  //是否抽取急诊病历,默认抽取
	
	if ((StartDate '= "")&&(EndDate '= "")&&(AdmStatus="A"))  //将患者换成门诊患者***(wei20200707)
	{
		// 所有的数据条数
		s numDate = 0
		//出院患者按日期查询
		s StDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	    s EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
		for i = StDate:1:EndDate 
		{
			s AdmTime = ""
			for {	
				s AdmTime = $o(^PAADMi("TypeDate","O",i,AdmTime))
				
				q:(AdmTime="")
				
				s PAADMRowID=""
				
				for
				{
					s PAADMRowID=$o(^PAADMi("TypeDate","O",i,AdmTime,PAADMRowID))
					
					q:(PAADMRowID="")
					
					s numDate = numDate + 1     // 总数
					
					s admInfo=$g(^PAADM(PAADMRowID))
					
					s PAAdmStatus=$P(admInfo,"^",20)  //就诊状态
					
					s locId=$P(admInfo,"^",4)  //科室
					
					s LocFiltter=1
					s:(LocIds'="") LocFiltter=##class(EPRservice.Quality.GetAdmList).CheckLoc(LocIds,locId)
					continue:(LocFiltter=0)

					s objCtLoc=$g(^CTLOC(+locId))
					
					s HospID=$P(objCtLoc,"^",22)
					
					continue:(HospID'="")&&(HOSPID'="")&&(HOSPID'=HospID) //过滤非本院区患者
					
					q:(AdmStatus '= PAAdmStatus)  //过滤非在院患者
					
					d storeData
				}
				continue:(IncludeEmergencyFlag=0)
				
				for
				{
					s PAADMRowID=$o(^PAADMi("TypeDate","E",i,AdmTime,PAADMRowID))
					
					q:(PAADMRowID="")
					
					s numDate = numDate + 1     // 总数
					
					s admInfo=$g(^PAADM(PAADMRowID))
					
					s PAAdmStatus=$P(admInfo,"^",20)  //就诊状态
					
					s locId=$P(admInfo,"^",4)  //科室
					
					s LocFiltter=1
					s:(LocIds'="") LocFiltter=##class(EPRservice.Quality.GetAdmList).CheckLoc(LocIds,locId)
					continue:(LocFiltter=0)

					s objCtLoc=$g(^CTLOC(+locId))
					
					s HospID=$P(objCtLoc,"^",22)
					
					continue:(HospID'="")&&(HOSPID'="")&&(HOSPID'=HospID) //过滤非本院区患者
					
					q:(AdmStatus '= PAAdmStatus)  //过滤非在院患者
					
					d storeData
				}
				
				
				
			}
		}			
	}
	
	d noSpecialAdm
	
	
	// 按科室患者数量
	s LocNums = ""
    for {
		s LocNums = $o(^CacheTemp("EPRQuality","PaAdmList",LocNums))
		q:(LocNums = "")
		s tmpAdmID = ""
		for {
			s tmpAdmID = $o(^CacheTemp("EPRQuality","PaAdmList",LocNums,tmpAdmID))
			q:(tmpAdmID = "")
			s Data = $g(^CacheTemp("EPRQuality","PaAdmList",LocNums,tmpAdmID))
				//continue:(Data="")
				
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	} 
	k ^CacheTemp("EPRQuality","PaAdmList")
	Quit $$$OK
	
	
storeData()  //每个查询到的患者按着科室比例存储
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
		s PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	//设置临时 global 用于存储数据,用来抽取数据
	
	
	
	s ^tempquality("quality",PAADMDepCode)=$g(^tempquality("quality",PAADMDepCode))_"^"_PAADMRowID
	
	Quit


    //******* 没有重点患者 *********//
noSpecialAdm()
	// 随机抽取，并且把抽到的患者（不重复）放到临时 Global 并且在页面显示
	s DepCode = 0
	for{
		s DepCode = $o(^tempquality("quality",DepCode))
		q:DepCode=""
		s ^tempquality("quality",DepCode) = $e(^tempquality("quality",DepCode),2,$l(^tempquality("quality",DepCode)))
		s length = $l(^tempquality("quality",DepCode),"^")  //每个科室的门诊患者数量
		continue:(length=0)
		//按照百分比抽取的数量
		if selectPro'=""
		{
			s number = $j(length*selectPro,1,0)   //每个科室抽取患者数量	
		}
		s Pro=selectPro
		if extractNums'=""
		{
			s number =  extractNums  //每个科室抽取患者数量
			s:(length<number) number=length
			s Pro=$j(number/length,1,2)	
		}
		
		s:(number=0) number=1
		s LocNumber=number
		
		// 存放抽取患者位置的临时global
		s ^tempquality("extract",DepCode) = ""
		// number2:抽取次数
		
		s number2 = 0  //抽取数量
		for
		{
			q:(number2=number)  //抽取指定数量后退出或者抽完本医疗组数量时退出
			
			s locaPAADMRowID = $r(length)+1  //随机数
			
			s PAADMRowID=$p(^tempquality("quality",DepCode),"^",locaPAADMRowID)
			
			if ($g(^tempquality("extract",DepCode,PAADMRowID))="")
			{
				s number2=number2+1
				
				s ^tempquality("extract",DepCode,PAADMRowID)=number2	
				
				s mCurrRow=$g(^PAADM(PAADMRowID))
				
				s PAADMDepCode=$p($g(mCurrRow),"^",4)
				
				if (PAADMDepCode'="")
				{
					s PAADMDepCodeDR=$p($g(^CTLOC(PAADMDepCode)),"^",2)
					s PAADMDepCodeDR=$p(PAADMDepCodeDR,"-",2)
				}else
				{
					s PAADMDepCodeDR="无"
				}
				
				
				d outputrow
			}
				
			
		}
		
		k ^tempquality("extract",DepCode)
		
			
	}
	
	QUIT

	
	
	
outputrow


	s PAPMIDR = $p($g(mCurrRow),"^",1)   //登记号  患者基本信息表rowid
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	
	
	s LocName = $p($g(^CTLOC(PAADMDepCode)),"^",2) //科室
	
	
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)  //性别
	
	//主要诊断
	s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (MainDiagnos = "")
    {
        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(PAADMRowID)
        //s MainDiagnos = $P(MainDiagnos,"^",3)
    }
	if (MainDiagnos '= "")
	{	
		s MainDiagnos = $P(MainDiagnos,"^",3)
		s MainDiagnos = $tr(MainDiagnos,"'","\'")
	}
	

	
	s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,PAADMRowID,"","")
	
	s extractPro=Pro*100_"%"
	
	s ^CacheTemp("EPRQuality","PaAdmList",length,PAADMRowID) = $LB(PAPMIDR,PAADMRowID,PAPMIName,PAPMISex,PAAdmDepCodeDR,MainDiagnos,Age,length,LocNumber,extractPro,LocName,number2)
	
	s ^tempSelect("PAADMRowID")=^tempSelect("PAADMRowID")_PAADMRowID_"^"
	
	Quit
}

ClassMethod GetOutPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSecondAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOutPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSecondAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
