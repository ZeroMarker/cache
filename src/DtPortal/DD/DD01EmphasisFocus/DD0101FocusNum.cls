/// ClassName:    DtPortal.DD.DD14InfectiousDiseases
/// Description:  临床科主任重点关注服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-09
Class DtPortal.DD.DD01EmphasisFocus.DD0101FocusNum Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     chengpeng
/// CreatDate：   2015-12-18
/// Description:  DD01.01.01 重点关注数量
/// Input：       UserCode    	 : 科主任工号
/// Return：      DtPortal.OutPut
/// set obj=##class(DtPortal.DD.DD01EmphasisFocus.DD0101FocusNum).DD010101("1940","I*157||O*")
/// do $System.OBJ.Dump(obj)
ClassMethod DD010101(UserCode As %String, locGroupID As %String) As DtPortal.OutPut
{
	
	Set return=##Class(DtPortal.OutPut).%New()
	set DocLocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupID,"I")
	if DocLocStr=""{
		Set return.status = -2
		Set return.errMSG = "没有维护科室，请联系管理员维护!"
		Set return.data = ""
		Quit return
	}
	Set $ZT="EmphasisFocusNum"
	
	set (CriticalPatNum,CriticalValueNum,AdmitPatNum,TotalBedNum,BedUsageRate,emptyBedNum,bedNumCount)=0
	set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
	set FocusNums=..GetFocusNums(DocLocStr)
	set CRITICALLYNum=$p(FocusNums,"^",1)  //病危数量
	set SERIOUSLYNum=$p(FocusNums,"^",2)	//病重数量
	set CriticalPatNum=$p(FocusNums,"^",3)
	set AdmitPatNum=$p(FocusNums,"^",4)
	set UnSubmitNum=$p(FocusNums,"^",5)
	
	d jsonObj.Put("CRITICALLYNum",CRITICALLYNum)
	d jsonObj.Put("SERIOUSLYNum",SERIOUSLYNum)
	d jsonObj.Put("CriticalPatNum",CriticalPatNum)
	d jsonObj.Put("AdmitPatNum",AdmitPatNum)
	d jsonObj.Put("UnSubmitNum",UnSubmitNum)
	
	//申请会诊数量
	s SQConsultationNum=0
	Set rset = ##class(%ResultSet).%New("DtPortal.DD.DD01EmphasisFocus.DD0106Consultation:DD010601")
	Do rset.Execute(UserCode,locGroupID,"1","R")
	While (rset.Next()) {
		Set SQConsultationNum=SQConsultationNum+1
	}
	
	//被邀会诊数量
	s BYConsultationNum=0
	Set rset = ##class(%ResultSet).%New("DtPortal.DD.DD01EmphasisFocus.DD0106Consultation:DD010601")
	Do rset.Execute(UserCode,locGroupID,"1","C")
	While (rset.Next()) {
		Set BYConsultationNum=BYConsultationNum+1
	}
	
	d jsonObj.Put("SQConsultationNum",SQConsultationNum)
	d jsonObj.Put("BYConsultationNum",BYConsultationNum)

	//危急值未响应数量
	Set rset = ##class(%ResultSet).%New("DtPortal.DD.DD01EmphasisFocus.DD0103CVReports:DD010301")
	Do rset.Execute(UserCode,"C",locGroupID)

	While (rset.Next()) {
		Set CriticalValueNum=CriticalValueNum+1
	}
	d jsonObj.Put("CriticalValueNum",CriticalValueNum)
	
	set WardLocIDStr=##class(DtPortal.Common.PublicService).getWardLocStrByLocIDStr(DocLocStr)
	set length=$l(WardLocIDStr,"^")
	for index=1:1:length
	{
		set WardLocID=$p(WardLocIDStr,"^",index)
		Continue:WardLocID=""
		set WardID=$o(^PAWARD("0","WARD_LocationDR",WardLocID,""))
		if (WardID="") Continue
		Set bedInfo=""  //空床的详细信息
		//总床位数
		Set roomId=""
		For
		{
			Set roomId=$o(^PAWARD(0,"WardRoom",WardID,roomId)) 
			quit:roomId="" 
			
			Set bedChild=""
			For
			{
				Set bedChild=$o(^PAWARD(0,"WardRoom",WardID,roomId,bedChild)) 
				quit:bedChild=""
				s isValid=##class(DtPortal.Common.PublicService).isValidBed(WardID_"||"_bedChild)
				continue:isValid'="1"
				set rcFlag=$p($g(^PAWARD(WardID,"BED",bedChild)),"^",4)
				if rcFlag'="Y" continue
				Set TotalBedNum=TotalBedNum+1
				
				//过滤床位不可用
				s bedAvailable=$$CO18^at153(WardID_"||"_bedChild)  //取床位是否可用
				s ifBedExist=##class(DtPortal.Common.PublicService).ifBaoChuang(WardID_"||"_bedChild)  //判断床位是否被占用
				continue:(bedAvailable="Y")&&(ifBedExist=0)
				s bedNumCount=bedNumCount+1 //床位数
					
			}  
			  
		} 	
	}
	//床位使用率
	Set:TotalBedNum'=0 BedUsageRate=$fn(bedNumCount/TotalBedNum,"",4)*100
	i (BedUsageRate[".")&&($p(BedUsageRate,".",1)="") s BedUsageRate="0"_BedUsageRate
	d jsonObj.Put("TotalBedNum",TotalBedNum)
	
	d jsonObj.Put("BedUsageRate",BedUsageRate)
	Set return.status = 1
	Set return.errMSG = ""
	Set return.data ="["_jsonObj.Json()_"]"
	Quit return
	
EmphasisFocusNum

	Set return.status = -1
	Set return.errMSG = $ZE
	b ;err
	Set return.data = ""
	Quit return
}

/// 获取科室串数量，1-病危、2-病重、3-危重、4-在院患者、5-未提交病历数量
/// w ##class(DtPortal.DD.DD01EmphasisFocus.DD0101FocusNum).GetFocusNums("6")
ClassMethod GetFocusNums(DocLocStr) As %String
{
	s retStr=""
	s (criPatNum,seriousPatNum,criticalPatNum,inPatNum,UnSubmitNum)=0
	//1-病危 2-病重
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALLY^SERIOUSLY",1)
	//未提交病历天数
	s days=##Class(DtPortal.Common.PublicService).getValueByCode("UNSUBMITDAYS")
	
	s startdate=(+$h)-days
	s enddate=+$h
 	for locIndex=1:1:$l(DocLocStr,"^")
	{
		set loc=$p(DocLocStr,"^",locIndex) 
		continue:loc="" 
		set PaadmStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",loc)  //(科室类型，userID，locID)
		set length=$l(PaadmStr,"^")
		
		for index=1:1:length
		{
			set EpisodeID=$p(PaadmStr,"^",index)
			Continue:EpisodeID=""
			s inPatNum=inPatNum+1
			s ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(EpisodeID,arcimIDs)
			//病危
			s criPatNum=criPatNum+$p(ArcNums,"^",1)
			//病重
			s seriousPatNum=seriousPatNum+$p(ArcNums,"^",2)
			//危重
			if (($p(ArcNums,"^",1)=1)&&($p(ArcNums,"^",2)=1)){
				s criticalPatNum=criticalPatNum+1
			}else{
				s criticalPatNum=criticalPatNum+$p(ArcNums,"^",1)+$p(ArcNums,"^",2)
			} 
		}
		
		
		
		
	}
	
	
	//未提交病历数量
	for date=startdate:1:enddate {
		s PAAdm=""
		
		for {
			s PAAdm=$o(^PAADMi("EstDisch",date,PAAdm))
			q:PAAdm=""
			s patLocId=$p(^PAADM(PAAdm),"^",4)
			continue:'$LF($LISTFROMSTRING(DocLocStr,"^"),patLocId)
			s FistPageFlag=##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(PAAdm)
			continue:FistPageFlag="1"   //判断病案首页数据是否提交
			s UnSubmitNum=UnSubmitNum+1
		}     

	}
	
	s retStr=criPatNum_"^"_seriousPatNum_"^"_criticalPatNum_"^"_inPatNum_"^"_UnSubmitNum
 	q retStr
}

}
