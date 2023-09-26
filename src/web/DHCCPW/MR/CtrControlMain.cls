Class web.DHCCPW.MR.CtrControlMain Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 
/// Creator：     liyang
/// CreatDate：   2011-02-14
/// Description:  运行中临床路径监控
/// Input：       Loc(科室),PathWayDicID(临床路径),PathStatus(入径:I、出径:O、完成:C),FromDate(开始日期),ToDate(结束日期)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.CtrControlMain","QryCtl","","","","2010-001-01","2011-02-14")
Query QryCtl(Loc As %String, PathWayDicID As %String, PathStatus As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "PatientID:%String,Paadm:%String,RegNo:%String:登记号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,DisDate:%String:出院日期,Loc:%String:科室,Ward:%String:病房,Days:%String:住院天数,InPathDate:%String:入径日期,PathName:%String:路径名称,InDays:%String:入径天数,CurrStatus:%String:当前状态,OutDate:%String:出径日期,Reason:%String:出径原因,PathWayVerID:%String,repid:%String,CurrentFee:%String:当前费用,PathWayID:%String,CurrentFeePercent:%String:当前花费比（占估计费用）,FiredItem:%String:触发项目")
{
}

ClassMethod QryCtlExecute(ByRef qHandle As %Binary, Loc As %String, PathWayDicID As %String, PathStatus As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID))
		Quit:CPWID=""
		Set objCPW=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		Continue:'$IsObject(objCPW)
		Continue:'$IsObject(objCPW.CPWCPWDicDR)
		Set CPWDicID=objCPW.CPWCPWDicDR.%Id()
		Continue:(PathWayDicID'="")&&(PathWayDicID'=CPWDicID)
		
		Set aInDate=FromDate-1
		For {
			Set aInDate=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,aInDate))
			Quit:(aInDate="")||(aInDate>ToDate)
			Set aInTime=0
			For {
				Set aInTime=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,aInDate,aInTime))
				Quit:aInTime=""
				
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexPathWayInDate",CPWID,aInDate,aInTime,PathWayID))
					Quit:PathWayID=""
					;w "监控病人："_PathWayID,!
					Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					Continue:'$IsObject(objPathWay)
					Set CPWStatus=objPathWay.CPWStatus
					;b:((Status'="")&&(Status'=CPWStatus))
					Continue:((PathStatus'="")&&(PathStatus'=CPWStatus))
					Set MRAdm=objPathWay.CPWMRADMDR
					Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					Set AdmInfo=$g(^PAADM(EpisodeID))
					Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
					Set Summary=##class(web.DHCCPW.MR.CtrModulePatSummary).GetPathWaySummary(PathWayID)
					Set InCPWDays=+$p(Summary,"^",3)
					
					//临床路径监控程序
					Set flg=##class(web.DHCCPW.MR.CtrModulePatProcess).ProcessSinglePerson(repid,EpisodeID,PathWayID,Summary)
					;w "Paadm:"_EpisodeID_"   "_flg,!
					Continue:flg<1 //没有触发任何项目
					
					Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID)=""
					Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmDays,AdmLoc,AdmWard)=""
					Set (PathWayDesc,RefCost,RefDays,Status,StatusDesc,InDate,InTime,OutDate,OutTime,OutReasonDR,OutReasonDesc)=""
					Set objPaadm=##Class(User.PAAdm).%OpenId(EpisodeID)
				    If $IsObject(objPaadm)
				    {
					    If $IsObject(objPaadm.PAADMPAPMIDR)
					    {
						    Set objPatient=objPaadm.PAADMPAPMIDR
						    Set PatientID=objPatient.%Id()
						    //Set PapmiNo=objPatient.PAPMINo
						    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
						    Set PatName=objPatient.PAPMIName
						    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
						    Set Birthday=objPatient.PAPMIDOB
		    				Set:Birthday'="" Birthda=$zd(Birthday,3)
							
		    				//update by zf 20150228 统一调用年龄计算方法
		    				Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,"","")	//返回“*岁*月*天”

						    Set PersonalID=objPatient.PAPMIID
						}
						
					    //Set AdmitDate=objPaadm.PAADMAdmDate
					    //Set AdmitTime=objPaadm.PAADMAdmTime
					    //upadte by pylian 2016-02-18 修改入院时间取值方式
    					Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
						Set AdmitDate=$p(AdmDateTime,"^",1)
						Set AdmitTime=$p(AdmDateTime,"^",2)
					    //Set DisDate=objPaadm.PAADMDischgDate
    					//Set DisTime=objPaadm.PAADMDischgTime
    					//Update by pylian 2016-01-21 修改出院时间取值方式
						Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
						Set DisDate=$p(DischDateTime,"^",1)
						Set DisTime=$p(DischDateTime,"^",2)
					    If DisDate'="" {
						    Set AdmDays=DisDate-AdmitDate
					    } Else {
							Set AdmDays=+$h-AdmitDate
						}
					    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
					    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
					    Set:DisDate'="" DisDate=$zd(DisDate,3)
					    Set:DisTime'="" DisTime=$zt(DisTime,1)
					    If $IsObject(objPaadm.PAADMDepCodeDR)
					    {
						    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
						    Continue:(Loc'="")&&(AdmLoc'=Loc)
						    Set:$p(objPaadm.PAADMDepCodeDR.CTLOCDesc,"-",2)'="" AdmLoc=$p(objPaadm.PAADMDepCodeDR.CTLOCDesc,"-",2)
						}
					    If $IsObject(objPaadm.PAADMCurrentWardDR)
					    {
						    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
						    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
						}
					}
					Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(EpisodeID)
					Set CountCost=+$p(strCost,"^",1)  //住院总费用
					Set:CountCost'="" CountCost=$fn(CountCost,"",2)
					
					If $IsObject(objPathWay.CPWPathwayDR)
					{
						Set PathwayDR=objPathWay.CPWPathwayDR.%Id()
						Set PathWayDesc=objPathWay.CPWPathwayDR.CPWDesc
						Set RefCost=objPathWay.CPWPathwayDR.CPWCost
						Set RefDays=objPathWay.CPWPathwayDR.CPWDays
					}
					Set Status=objPathWay.CPWStatus
					Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
					Set InDate=objPathWay.CPWInDate
					Set InTime=objPathWay.CPWInTime
					Set:InDate'="" InDate=$zd(+InDate,3)
					Set:InTime'="" InTime=$zt(+InTime,2)
					Set OutDate=objPathWay.CPWOutDate
					Set OutTime=objPathWay.CPWOutTime
					Set:OutDate'="" OutDate=$zd(+OutDate,3)
					Set:OutTime'="" OutTime=$zt(+OutTime,2)
					If $IsObject(objPathWay.CPWOutReasonDR)
					{
						Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
						Set OutReasonDesc=objPathWay.CPWOutReasonDR.VRDesc
					}
					
					Set MaxCost=+$p(RefCost,"-",2)
					If MaxCost'=0 {
						Set CostRatio=$fn((CountCost/$p(RefCost,"-",2))*100,"",2)_"%"
					}Else{
						Set CostRatio="0.00%"
					}
					
					//触发项目
					s FiredItem=""
					S:$d(^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired","Order")) FiredItem=FiredItem_"医嘱^"
					S:$d(^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired","Fee")) FiredItem=FiredItem_"费用^"
					S:$d(^CacheTemp("CPWControl",repid,"paadm",EpisodeID,"IsFired","Days")) FiredItem=FiredItem_"住院日^"
					//
					
					Set Data=$lb(PatientID)    //1 PatientID
					Set Data=Data_$lb(EpisodeID)  //2 EpisodeID
					Set Data=Data_$lb(PapmiNo)  //3 登记号
					Set Data=Data_$lb(PatName)  //4 姓名
					Set Data=Data_$lb(Sex)  //5 性别
					Set Data=Data_$lb(Age)  //6 年龄
					Set Data=Data_$lb(AdmitDate)  //7 住院日期 
					Set Data=Data_$lb(DisDate)  //8 出院日期
					Set Data=Data_$lb(AdmLoc)  //9 科室
					Set Data=Data_$lb(AdmWard)  //10 病区
					Set Data=Data_$lb(AdmDays)  //11 住院天数
					Set Data=Data_$lb(InDate)  //12 入径日期
					Set Data=Data_$lb(PathWayDesc)  //13 路径名称
					Set Data=Data_$lb(InCPWDays)  //14 入径天数
					Set Data=Data_$lb(StatusDesc)  //15 当前状态
					Set Data=Data_$lb(OutDate)  //16 出径日期
					Set Data=Data_$lb(OutReasonDesc)  //17 出径原因
					Set Data=Data_$lb(CPWID)  //18 CPWID
					Set Data=Data_$lb(repid)  //19 repid
					Set Data=Data_$lb(CountCost)  //20 住院费用
					Set Data=Data_$lb(PathWayID)  //21 PathWayID
					Set Data=Data_$lb(CostRatio)  //22 (当前费用/参考费用)%
					Set Data=Data_$lb(FiredItem) //23 触发项目 //Add By LiYang 2011-04-07
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	k ^CacheTemp("CPWControl",repid)
	Quit $$$OK
	
	/*
BuildQryCtlExecute(param)
	s data=$lb("")
	s $li(data,1)=objPatient.Papmi  //PatientID:%String
	s $li(data,2)=objMRAdm.AdmDr //Paadm:%String
	s $li(data,3)=objPatient.PapmiNo //RegNo:%String:登记号
	s $li(data,4)=objPatient.PatientName //PatientName:%String:姓名
	s $li(data,5)=objPatient.Sex //Sex:%String:性别
	s $li(data,6)=objPatient.Age //Age:%String:年龄
	s $li(data,7)=objAdm.AdmitDate //AdmitDate:%String:住院日期
	s $li(data,8)=objAdm.DisDate //DisDate:%String:出院日期
	s $li(data,9)=objAdm.Department //Loc:%String:科室
	s $li(data,10)=objAdm.Ward //Ward:%String:病房
	s $li(data,11)=objAdm.Days //Days:%String:住院天数
	s:objAdm.DisDate="" $li(data,11)=+$h-$zdh(objAdm.AdmitDate,3)
	s $li(data,12)=$p(SummaryInfo,"^",1) //InPathDate:%String:入径日期
	s $li(data,13)=objRec.CPWPathwayDR.CPWCPWDicDR.CPWDDesc //PathName:%String:路径名称
	s $li(data,14)=$p(SummaryInfo,"^",3) //InDays:%String:入径天数
	s $li(data,15)=""
	s:objRec.CPWStatus="I" $li(data,15)="入径"
	s:objRec.CPWStatus="O" $li(data,15)="出径"
	s:objRec.CPWStatus="C" $li(data,15)="完成" //CurrStatus:%String:当前状态
	s $li(data,16)=""
	s:objRec.CPWOutDate'="" $li(data,16)=$zd(objRec.CPWOutDate,3) //OutDate:%String:出径日期
	s:objRec.CPWOutReasonDR'="" $li(data,17)=objRec.CPWOutReasonDR.VRDesc //Reason:%String:出径原因
	s $li(data,18)=objRec.CPWPathwayDR.%Id()  //临床路径ID
	s $li(data,19)=repid
	s $li(data,20)=$p(##class(web.UDHCJFBaseCommon).GetAdmDepositAndFee(objMRAdm.AdmDr),"^",2)
	s $li(data,21)=objRec.%Id() //临床路径记录ID
	s $li(data,22)="没有维护路径参考费用"
	s:objRec.CPWPathwayDR.CPWCost'="" $li(data,22)=$number($li(data,20)/objRec.CPWPathwayDR.CPWCost*100,2)_"%" //当前花费占路径估计花费的比例
	q data
	*/
}

ClassMethod QryCtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryCtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlExecute ]
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

/* update by zf 20110212
ClassMethod Test()
{
	//w ##class(web.DHCCPW.MR.CtrControlMain).Test()
	d ##class(%Library.ResultSet).RunQuery("web.DHCCPW.MR.CtrControlMain","QryCtl","","4","","2009-1-1","2011-12-31")
	q "OK"
}
*/
}
