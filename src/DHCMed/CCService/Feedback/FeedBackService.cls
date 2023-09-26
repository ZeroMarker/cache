/// <H3>反馈查询</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建时间：2012-07-13</H4>
Class DHCMed.CCService.Feedback.FeedBackService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod BuildData(objFeedback, FromDate, ToDate, CheckPass)
{
	New (objFeedback,SubjectID,FromDate,ToDate,CheckPass)
	
	Set $ZT="BuildDataErr"
	
	Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(objFeedback.CtlSummaryID)
	Quit:'$IsObject(objSummary) ""
	
	//检查特异性指标
	Quit:(CheckPass=1)&&(objSummary.SpecificityAmount<1) ""
	
	Set %Adm=##class(DHCMed.Base.PatientAdm).GetObjById(objFeedback.EpisodeID)
	If %Adm'="" Do %Adm.%Close()
	Quit:'$IsObject(%Adm) ""
	
	Set %Patient=##class(DHCMed.Base.Patient).GetObjById(%Adm.PatientID)
	If %Patient'="" Do %Patient.%Close()
	Quit:'$IsObject(%Patient) ""
	
	Set Data=$lb("")
	Set $li(Data,1)=objFeedback.%Id()  //FeedbackRowID:%String
	Set $li(Data,2)=objFeedback.EpisodeID //EpisodeID:%String
	Set $li(Data,3)=objFeedback.CtlSummaryID //CtlSummaryID:%String
	Set $li(Data,4)=objFeedback.SubjectID //SubjectID:%String
	Set $li(Data,5)=objFeedback.ToDepartment //ToDepartment:%String
	
	//目标科室
	Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(objFeedback.ToDepartment)
	If $IsObject(objDep) {
		Set $li(Data,6)=objDep.Descs //ToDepartmentDesc:%String
		Set:$li(Data,6)["-" $li(Data,6)=$p($li(Data,6),"-",2)
	} Else {
		Set $li(Data,6)=""
	}
	
	//目标医师
	Set $li(Data,7)=objFeedback.ToUser //ToUser:%String
	Set objToUser=##class(DHCMed.Base.SSUser).GetObjById(objFeedback.ToUser)
	If $IsObject(objToUser) {
		Set $li(Data,8)=objToUser.Name //ToUserDesc:%String
	} Else {
		Set $li(Data,8)=""
	}
	
	//提示医师信息
	Set $li(Data,9)=objFeedback.FeedBackNote //FeedBackNote:%String
	
	//反馈医师签名
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objFeedback.FeedBackUser)
	If $IsObject(objUser) {
		Set $li(Data,10)=objUser.Name //FeedBackUser:%String
	} Else {
		Set $li(Data,10)=""
	}
	
	Set $li(Data,11)=$zd(objFeedback.FeedBackDate,3) //FeedBackDate:%String:医师反馈日期
	Set $li(Data,12)=$zt(objFeedback.FeedBackTime,1) //FeedBackTime:%String:医师反馈时间
	Set $li(Data,13)=objFeedback.ReceiveNote //ReceiveNote:%String:反馈具体描述
	
	//接受反馈的医师
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objFeedback.ReceiveUser)
	If $IsObject(objUser) {
		Set $li(Data,14)=objUser.Name //ReceiveUser:%String
	} Else {
		Set $li(Data,14)=""
	}
	
	//接受反馈的日期,接受反馈日期
	Set ReceiveDate=objFeedback.ReceiveDate
	Set:ReceiveDate'="" ReceiveDate=$zd(ReceiveDate,3)
	Set ReceiveTime=objFeedback.ReceiveTime
	Set:ReceiveTime'="" ReceiveTime=$zt(ReceiveTime,1)
	Set $li(Data,15)=ReceiveDate  //ReceiveDate:%String
	Set $li(Data,16)=ReceiveTime  //ReceiveTime:%String
	
	Set $li(Data,17)=objFeedback.ReceiveResult //ReceiveResult:%String:医师是否接受
	Set $li(Data,18)=objFeedback.ControlCorrect //ControlCorrect:%String:监控是否正确
	Set $li(Data,19)=objFeedback.ControlInCorrectReason //ControlInCorrectReason:%String:监控错误的原因
	Set $li(Data,20)=objFeedback.ReportOnTime //ReportOnTime:%String:报告及时性
	
	Set $li(Data,21)=%Adm.PatientID //PatientID:%String
	Set $li(Data,22)=%Patient.PapmiNo //PatNo:%String:就诊卡号
	Set $li(Data,23)=%Patient.PatientName //PatientName:%String:姓名
	Set $li(Data,24)=%Patient.Sex //Sex:%String:性别
	Set $li(Data,25)=%Patient.Age //Age:%String:年龄
	Set $li(Data,26)=%Adm.AdmitDate //AdmitDate:%String:入院日期
	Set $li(Data,27)=%Adm.Department //Department:%String:科室
	Set:$li(Data,27)["-" $li(Data,27)=$p($li(Data,27),"-",2)
	Set $li(Data,28)=%Adm.Ward //Ward:%String:病房
	Set:$li(Data,28)["-" $li(Data,28)=$p($li(Data,28),"-",2)
	Set $li(Data,29)=0 //TotalScore:%String:总分
	
	//计算总得分
	Set SummaryID=""
	For {
		Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",objFeedback.EpisodeID,SubjectID,SummaryID))
		Quit:SummaryID=""
		Set objSum=##class(DHCMed.CC.CtlSummary).%OpenId(SummaryID)
		Continue:$IsObject(objSum)=0
		Do objSum.%Close()
		Continue:(objFeedback.FeedBackDate<objSum.ActDate) //仅计算当次反馈之前的分数
		Set $li(Data,29)=$li(Data,29)+objSum.TotalScore
		
	}
	
	Set $li(Data,30)=objSummary.TotalScore //ScoreThisTime:%String:此次得分
	Set $li(Data,31)=objSummary.SensitiveAmount //SensitiveAmount:%String:敏感项目触发数量
	Set $li(Data,32)=objSummary.SpecificityAmount //SpecificityAmount:%String:特异性项目触发数量
	Set $li(Data,33)=objSummary.ItemNumber //FireItemCount:%String:触发项目数量
	Set $li(Data,34)=objFeedback.Status //Status:%String:状态
	
	//反馈间隔天数
	Set days=+objFeedback.ReceiveDate
	If days>0 {
		Set days=objFeedback.ReceiveDate-objFeedback.FeedBackDate
	} Else {
		Set days=+$h-objFeedback.FeedBackDate
	}
	Set $li(Data,35)=days
	
	//是否评价
	Set $li(Data,36)=$o(^DHCMed.CC.CtlResultI("CtlFeedbackEva","IndexFeedbackID",objFeedback.%Id(),"")) //IsEva:%String
	
	//反馈信息
	Set FeedBackInfo=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(objFeedback.EpisodeID,objFeedback.SubjectID)
	Set $li(Data,37)=+$p(FeedBackInfo,"^",1) //FeedBackCnt:%String:反馈次数
	Set $li(Data,38)=+$p(FeedBackInfo,"^",2) //AcceptFeedbackCnt:%String:接受反馈次数
	Set $li(Data,39)=+$p(FeedBackInfo,"^",3) //RejectFeedbackCnt:%String:拒绝反馈次数
	Set $li(Data,40)=+$p(FeedBackInfo,"^",4) //NoResponseFeedbackCnt:%String:无响应反馈次数
	Set $li(Data,41)=%Adm.Bed //Bed:%String:病床
	Set $li(Data,42)=objFeedback.FeedBackRepType //Modify By LiYang 2013-03-25 增加提示报告类别
	Quit Data
	
BuildDataErr
	Quit ""
}

/// <H3>功能：通过Paadm，主题ID查询反馈信息</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊ID，PAADM</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>Status</B>：状态：0--未阅读  1--接受  2--拒绝</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <Li>FeedbackRowID:%String</LI>
/// <Li>EpisodeID:%String</LI>
/// <Li>CtlSummaryID:%String</LI>
/// <Li>SubjectID:%String</LI>
/// <Li>ToDepartment:%String</LI>
/// <Li>ToDepartmentDesc:%String:目标科室</LI>
/// <Li>ToUser:%String</LI>
/// <Li>ToUserDesc:%String:目标医师</LI>
/// <Li>FeedBackNote:%String:提示医师信息</LI>
/// <Li>FeedBackUser:%String:反馈医师签名</LI>
/// <Li>FeedBackDate:%String:医师反馈日期</LI>
/// <Li>FeedBackTime:%String:医师反馈时间</LI>
/// <Li>ReceiveNote:%String:反馈具体描述</LI>
/// <Li>ReceiveUser:%String:接受反馈的医师</LI>
/// <Li>ReceiveDate:%String:接受反馈的日期</LI>
/// <Li>ReceiveTime:%String:接受反馈日期</LI>
/// <Li>ReceiveResult:%String:医师是否接受</LI>
/// <Li>ControlCorrect:%String:监控是否正确</LI>
/// <Li>ControlInCorrectReason:%String:监控错误的原因</LI>
/// <Li>ReportOnTime:%String:报告及时性</LI>
/// <Li>PatientID:%String</LI>
/// <Li>PatNo:%String:就诊卡号</LI>
/// <Li>PatientName:%String:姓名</LI>
/// <Li>Sex:%String:性别</LI>
/// <Li>Age:%String:年龄</LI>
/// <Li>AdmitDate:%String:入院日期</LI>
/// <Li>Department:%String:科室</LI>
/// <Li>Ward:%String:病房</LI>
/// <Li>TotalScore:%String:总分</LI>
/// <Li>ScoreThisTime:%String:此次得分</LI>
/// <Li>SensitiveAmount:%String:敏感项目触发数量</LI>
/// <Li>SpecificityAmount:%String:特异性项目触发数量</LI>
/// <Li>FireItemCount:%String:触发项目数量</LI>
/// <Li>Status:%String:状态</LI>
/// <Li>Days:%String:反馈间隔天数</LI>
/// <Li>IsEva:%String:是否评价</LI>
/// <Li>FeedBackCnt:%String:反馈次数</LI>
/// <Li>AcceptFeedbackCnt:%String:接受反馈次数</LI>
/// <Li>RejectFeedbackCnt:%String:拒绝反馈次数</LI>
/// <Li>NoResponseFeedbackCnt:%String:无响应反馈次数</LI>
/// <Li>Bed:%String:病床</LI>
/// </OL>
/// <H4>实例</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.FeedBackService","QryByEpisodeSubject",20175045,1,"","") 
Query QryByEpisodeSubject(EpisodeID As %String, SubjectID As %String, Status As %String, RepType As %String) As %Query(ROWSPEC = "FeedbackRowID:%String,EpisodeID:%String,CtlSummaryID:%String,SubjectID:%String,ToDepartment:%String,ToDepartmentDesc:%String:目标科室,ToUser:%String,ToUserDesc:%String:目标医师,FeedBackNote:%String:提示医师信息,FeedBackUser:%String:反馈医师签名,FeedBackDate:%String:医师反馈日期,FeedBackTime:%String:医师反馈时间,ReceiveNote:%String:反馈具体描述,ReceiveUser:%String:接受反馈的医师,ReceiveDate:%String:接受反馈的日期,ReceiveTime:%String:接受反馈日期,ReceiveResult:%String:医师是否接受,ControlCorrect:%String:监控是否正确,ControlInCorrectReason:%String:监控错误的原因,ReportOnTime:%String:报告及时性,PatientID:%String,PatNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:入院日期,Department:%String:科室,Ward:%String:病房,TotalScore:%String:总分,ScoreThisTime:%String:此次得分,SensitiveAmount:%String:敏感项目触发数量,SpecificityAmount:%String:特异性项目触发数量,FireItemCount:%String:触发项目数量,Status:%String:状态,Days:%String:反馈间隔天数,IsEva:%String:是否评价,FeedBackCnt:%String:反馈次数,AcceptFeedbackCnt:%String:接受反馈次数,RejectFeedbackCnt:%String:拒绝反馈次数,NoResponseFeedbackCnt:%String:无响应反馈次数,Bed:%String:病床,FeedBackRepType:%String:反馈报告类型,ActFlag:%String")
{
}

ClassMethod QryByEpisodeSubjectExecute(ByRef qHandle As %Binary, EpisodeID As %String, SubjectID As %String, Status As %String, RepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:EpisodeID="" $$$OK
	
	Set tmpSubjectID=""
	For {
		Set tmpSubjectID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,tmpSubjectID))
		Quit:tmpSubjectID=""
		Continue:((SubjectID'=tmpSubjectID)&&(SubjectID'=""))
		
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,tmpSubjectID,RowID))
			Quit:RowID=""
			
			Set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(RowID)
			Continue:'$IsObject(objFeedback)
			Continue:((Status'[objFeedback.Status)&&(Status'=""))
			Continue:((objFeedback.FeedBackRepType'=RepType)&&(RepType'="")) // Add By LiYang 2013-04-07 过滤提示报告类别
			Set Data=..BuildData(objFeedback,0,objFeedback.FeedBackDate,"")
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryByEpisodeSubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByEpisodeSubjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryByEpisodeSubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByEpisodeSubjectExecute ]
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

/// <H3>功能：按日期查询反馈信息</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：自动监控的开始日期</LI>
/// <LI><B>ToDate</B>：自动监控的结束日期</LI>
/// <LI><B>DateType</B>：日期类型：1--入院日期 2--出院日期 3--发送给医师的日期 4--医师回复的日期</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>Status</B>：状态：0--未阅读  1--接受  2--拒绝</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <Li>FeedbackRowID:%String</LI>
/// <Li>EpisodeID:%String</LI>
/// <Li>CtlSummaryID:%String</LI>
/// <Li>SubjectID:%String</LI>
/// <Li>ToDepartment:%String</LI>
/// <Li>ToDepartmentDesc:%String:目标科室</LI>
/// <Li>ToUser:%String</LI>
/// <Li>ToUserDesc:%String:目标医师</LI>
/// <Li>FeedBackNote:%String:提示医师信息</LI>
/// <Li>FeedBackUser:%String:反馈医师签名</LI>
/// <Li>FeedBackDate:%String:医师反馈日期</LI>
/// <Li>FeedBackTime:%String:医师反馈时间</LI>
/// <Li>ReceiveNote:%String:反馈具体描述</LI>
/// <Li>ReceiveUser:%String:接受反馈的医师</LI>
/// <Li>ReceiveDate:%String:接受反馈的日期</LI>
/// <Li>ReceiveTime:%String:接受反馈日期</LI>
/// <Li>ReceiveResult:%String:医师是否接受</LI>
/// <Li>ControlCorrect:%String:监控是否正确</LI>
/// <Li>ControlInCorrectReason:%String:监控错误的原因</LI>
/// <Li>ReportOnTime:%String:报告及时性</LI>
/// <Li>PatientID:%String</LI>
/// <Li>PatNo:%String:就诊卡号</LI>
/// <Li>PatientName:%String:姓名</LI>
/// <Li>Sex:%String:性别</LI>
/// <Li>Age:%String:年龄</LI>
/// <Li>AdmitDate:%String:入院日期</LI>
/// <Li>Department:%String:科室</LI>
/// <Li>Ward:%String:病房</LI>
/// <Li>TotalScore:%String:总分</LI>
/// <Li>ScoreThisTime:%String:此次得分</LI>
/// <Li>SensitiveAmount:%String:敏感项目触发数量</LI>
/// <Li>SpecificityAmount:%String:特异性项目触发数量</LI>
/// <Li>FireItemCount:%String:触发项目数量</LI>
/// <Li>Status:%String:状态</LI>
/// <Li>Days:%String:反馈间隔天数</LI>
/// <Li>IsEva:%String:是否评价</LI>
/// <Li>FeedBackCnt:%String:反馈次数</LI>
/// <Li>AcceptFeedbackCnt:%String:接受反馈次数</LI>
/// <Li>RejectFeedbackCnt:%String:拒绝反馈次数</LI>
/// <Li>NoResponseFeedbackCnt:%String:无响应反馈次数</LI>
/// <Li>Bed:%String:病床</LI>
/// </OL>
/// <H4>实例</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.FeedBackService","QryByDate","2013-04-23","2013-04-24","3","1","0","1")
Query QryByDate(FromDate As %String, ToDate As %String, DateType As %String, SubjectID As %String, Status As %String, CheckPass As %String = "") As %Query(ROWSPEC = "FeedbackRowID:%String,EpisodeID:%String,CtlSummaryID:%String,SubjectID:%String,ToDepartment:%String,ToDepartmentDesc:%String:目标科室,ToUser:%String,ToUserDesc:%String:目标医师,FeedBackNote:%String:提示医师信息,FeedBackUser:%String:反馈医师签名,FeedBackDate:%String:医师反馈日期,FeedBackTime:%String:医师反馈时间,ReceiveNote:%String:反馈具体描述,ReceiveUser:%String:接受反馈的医师,ReceiveDate:%String:接受反馈的日期,ReceiveTime:%String:接受反馈日期,ReceiveResult:%String:医师是否接受,ControlCorrect:%String:监控是否正确,ControlInCorrectReason:%String:监控错误的原因,ReportOnTime:%String:报告及时性,PatientID:%String,PatNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:入院日期,Department:%String:科室,Ward:%String:病房,TotalScore:%String:总分,ScoreThisTime:%String:此次得分,SensitiveAmount:%String:敏感项目触发数量,SpecificityAmount:%String:特异性项目触发数量,FireItemCount:%String:触发项目数量,Status:%String:状态,Days:%String:反馈间隔天数,IsEva:%String:是否评价,FeedBackCnt:%String:反馈次数,AcceptFeedbackCnt:%String:接受反馈次数,RejectFeedbackCnt:%String:拒绝反馈次数,NoResponseFeedbackCnt:%String:无响应反馈次数,Bed:%String:病床,FeedBackRepType:%String:反馈报告类型,LnkFeedBackIDs:%String")
{
}

ClassMethod QryByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DateType As %String, SubjectID As %String, Status As %String, CheckPass As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)	
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryByDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//1--入院日期 2--出院日期
	If ((DateType=1)||(DateType=2))
	{
		Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
		Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()      //update by pylian 2016-02-18取入院时间索引
		Set IndexNode=$s(DateType=1:AdmDateIndex,DateType=2:DischDateIndex,1:DischDateIndex)	
		For tmpDate=FromDate:1:ToDate {
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi(IndexNode,tmpDate,Paadm))
				Quit:Paadm=""
				Continue:(($d(^PAADMi("PAADM_Type","I",Paadm))=0)&&($d(^PAADMi("PAADM_Type","E",Paadm))=0))
				
				Set FeedBackID=""
				For {
					Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",Paadm,SubjectID,FeedBackID))
					Quit:FeedBackID=""
					
					Set objFeedBack=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
					Continue:'$IsObject(objFeedBack)
					Continue:((objFeedBack.Status'=Status)&&(Status'=""))
					Set ^TMP(ZIndex,JIndex,NIndex,objFeedBack.EpisodeID,FeedBackID)=""
				}
			}
		}
	}
	
	//3--发送日期  4--医师回应日期
	If ((DateType=3)||(DateType=4))
	{
		Set IndexNode=$s(DateType=3:"IndexSendDate",DateType=4:"IndexReceiveDate",1:"IndexReceiveDate")
		For tmpDate=FromDate:1:ToDate {
			Set tmpStatus=""
			For {
				Set tmpStatus=$o(^DHCMed.CC.CtlResultI("CtlFeedback",IndexNode,tmpDate,SubjectID,tmpStatus))
				Quit:tmpStatus=""
				Continue:((Status'[tmpStatus)&&(Status'=""))
				
				Set FeedBackID=""
				For {
					Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback",IndexNode,tmpDate,SubjectID,tmpStatus,FeedBackID))
					Quit:FeedBackID=""
					
					Set objFeedBack=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
					Continue:'$IsObject(objFeedBack)
					Continue:((objFeedBack.Status'=Status)&&(Status'=""))
					Set ^TMP(ZIndex,JIndex,NIndex,objFeedBack.EpisodeID,FeedBackID)=""
				}
			}
		}			
	}
	
	//按反馈顺序 输出结果
	Set Paadm=0
	For {
		Set Paadm=$o(^TMP(ZIndex,JIndex,NIndex,Paadm))
		Quit:Paadm=""
		
		//多条数据合并
		Set FeedBackID="",Data="",LnkFeedBackIDs=""
		For {
			Set FeedBackID=$o(^TMP(ZIndex,JIndex,NIndex,Paadm,FeedBackID))
			Quit:FeedBackID=""
			
			Set objFeedBack=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
			
			Set tmpData=..BuildData(objFeedBack,FromDate,ToDate,CheckPass)
			Continue:tmpData=""
			If Data="" {
				Set Data=tmpData
			}
			Set LnkFeedBackIDs=LnkFeedBackIDs_","_FeedBackID
		}
		Continue:Data=""
		Set:LnkFeedBackIDs'="" LnkFeedBackIDs=$e(LnkFeedBackIDs,2,$l(LnkFeedBackIDs))
		Set ^CacheTemp(repid,ind)=Data_$lb(LnkFeedBackIDs)
		Set ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取反馈的数量，各种状态的分布情况
/// w ##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(6,2)
ClassMethod GetFeedBackTimes(EpisodeID As %String, SubjectID As %String)
{
	New (EpisodeID,SubjectID)
	Quit:(EpisodeID="")||(SubjectID="") 0
	
	Set RowID="",return=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,SubjectID,RowID))
		Quit:RowID=""
		
		Set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(RowID)
		Continue:'$IsObject(objFeedback)
		
		Set $p(return,"^",1)=$p(return,"^",1)+1
		Set Status=+objFeedback.Status
		Set:Status=1 $p(return,"^",2)=$p(return,"^",2)+1  //已接受
		Set:Status=2 $p(return,"^",3)=$p(return,"^",3)+1  //已拒绝
		Set:Status=0 $p(return,"^",4)=$p(return,"^",4)+1  //未响应
	}
	
	Quit return
}

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.FeedBackService","QryFeedBackDtl","","8","")
Query QryFeedBackDtl(SummaryIDs As %String, FeedBackIDs As %String, RepType As %String) As %Query(ROWSPEC = "FeedbackRowID:%String,EpisodeID:%String,CtlSummaryID:%String,SubjectID:%String,ToDepartment:%String,ToDepartmentDesc:%String:目标科室,ToUser:%String,ToUserDesc:%String:目标医师,FeedBackNote:%String:提示医师信息,FeedBackUser:%String:反馈医师签名,FeedBackDate:%String:医师反馈日期,FeedBackTime:%String:医师反馈时间,ReceiveNote:%String:反馈具体描述,ReceiveUser:%String:接受反馈的医师,ReceiveDate:%String:接受反馈的日期,ReceiveTime:%String:接受反馈日期,ReceiveResult:%String:医师是否接受,ControlCorrect:%String:监控是否正确,ControlInCorrectReason:%String:监控错误的原因,ReportOnTime:%String:报告及时性,PatientID:%String,PatNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:入院日期,Department:%String:科室,Ward:%String:病房,TotalScore:%String:总分,ScoreThisTime:%String:此次得分,SensitiveAmount:%String:敏感项目触发数量,SpecificityAmount:%String:特异性项目触发数量,FireItemCount:%String:触发项目数量,Status:%String:状态,Days:%String:反馈间隔天数,IsEva:%String:是否评价,FeedBackCnt:%String:反馈次数,AcceptFeedbackCnt:%String:接受反馈次数,RejectFeedbackCnt:%String:拒绝反馈次数,NoResponseFeedbackCnt:%String:无响应反馈次数,Bed:%String:病床,FeedBackRepType:%String:反馈报告类型,ActFlag:%String")
{
}

ClassMethod QryFeedBackDtlExecute(ByRef qHandle As %Binary, SummaryIDs As %String, FeedBackIDs As %String, RepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(SummaryIDs="")&&(FeedBackIDs="") $$$OK
	Set RepType=$g(RepType)
	Set FeedBackList=""
	
	If SummaryIDs'="" {
		For indSmy=1:1:$l(SummaryIDs,",") {
			Set SummaryID=$p(SummaryIDs,",",indSmy)
			Continue:SummaryID=""
			Set FeedBackID=0
			For {
				Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexSummary",SummaryID,FeedBackID))
				Quit:FeedBackID=""
				Set FeedBackList=FeedBackList_$lb(FeedBackID)
			}
		}
	}
	If FeedBackIDs'="" {
		For indFb=1:1:$l(FeedBackIDs,",") {
			Set FeedBackID=$p(FeedBackIDs,",",indFb)
			Continue:FeedBackID=""
			Set FeedBackList=FeedBackList_$lb(FeedBackID)
		}
	}
	Quit:FeedBackList="" $$$OK
	Set FeedBackID=$list(FeedBackList,1)
	Quit:FeedBackID="" $$$OK
	Set objFeedBack=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
	Quit:FeedBackID="" $$$OK
	Quit:'$IsObject(objFeedBack) $$$OK
	Set EpisodeID=objFeedBack.EpisodeID
	Set SubjectID=objFeedBack.SubjectID
	Quit:(EpisodeID="")||(SubjectID="") $$$OK
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,SubjectID,RowID))
		Quit:RowID=""
		
		Set ActFlag=($find(FeedBackList,RowID)>0)
		
		Set objFeedback=##class(DHCMed.CC.CtlFeedback).GetObjById(RowID)
		Continue:'$IsObject(objFeedback)
		Continue:((objFeedback.FeedBackRepType'=RepType)&&(RepType'="")) // Add By LiYang 2013-04-07 过滤提示报告类别
		Set Data=..BuildData(objFeedback,0,objFeedback.FeedBackDate,"")
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data_$lb(ActFlag)
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryFeedBackDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeedBackDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFeedBackDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeedBackDtlExecute ]
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
