Class EMRservice.Ajax.feedbackissue Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("episodeID",1),"")
	s userId = $Get(%request.Data("userID",1),"")
	s action = $Get(%request.Data("action",1),"")
	s IssueContent=$Get(%request.Data("FeedBackIssue",1),"")
	s doctorInfo=$Get(%request.Data("DoctorInfo",1),"")
	
	if (action = "GetPatientInfo") //患者信息
	{
		w ..GetPatientInfo(episodeId)
		
	}
	elseif (action = "GetDoctorInfo")
	{
		w ..GetDoctorInfo(userId)
		
	}
	elseif(action="SaveFeedBack")
	{
		
		w ..SaveFeedBack(IssueContent,episodeId,userId)
			
	}
	elseif(action="SaveDocInfo")
	{
		
		w ..SaveDocInfo(doctorInfo,episodeId,userId)
			
	}
	elseif(action="GetFeedBackIssueMessage")
	{
		w ..ShowMessage()
	}

	q $$$OK
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.feedbackissue).GetPatientInfo(96)
ClassMethod GetPatientInfo(AEpisodeID As %String) As %String
{
	s json=""
	s (PapmiDR,RegisterNo,Name,Gender,Birthday,Age,curBed)=""
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR)
	i Gender'="" {s Gender = $p($g(Gender),"^",3)}
	
	// 出生日期			[Birthday]			PA_Person.PAPER_Dob
 	s Birthday=##Class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
 	if Birthday'=""
 	{
   		// 出生日期内部格式 PA_Person.PAPER_Dob 
   		s ArgBirthday=Birthday
   		// 出生日期外部格式 PA_Person.PAPER_Dob
   		s Birthday=$zd(Birthday,3)
 	}
 	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
		 	s AdmDate = "", AdmTime = ""
		 	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
		 	if AdmDateTime'="" 
		 	{ 
		   		// 入院日期内部格式
		   		s AdmDate = $P($G(AdmDateTime),",",1)
		   		// 入院时间内部格式 
		   		s AdmTime = $P($G(AdmDateTime),",",2)
		 	}
	  
 	// DtHealth年龄 N年 N月 N天		[Age]
   	s Age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(AEpisodeID,ArgBirthday,AdmDate,1)
   	
	s curBed=##Class(EMRservice.HISInterface.PatientInfoAssist).DisBed(AEpisodeID)
	
	s json="{""total"":5,""rows"":["
	s json=json_"{""name"":""病人ID"",""value"":"""_RegisterNo_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""姓名"",""value"":"""_Name_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""性别"",""value"":"""_Gender_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""年龄"",""value"":"""_Age_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""床号"",""value"":"""_curBed_""",""group"":""ID Settings"",""editor"":""text""}"
	s json=json_"]}"
	

	q json
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.feedbackissue).GetDoctorInfo()
ClassMethod GetDoctorInfo(AUserID As %String) As %String
{
	s json=""
	s (DocName,DocNo,LocPhone,cellphone)=""
	
	s DocName=$P(^SSU("SSUSR",AUserID),"^",2)
	s DocNo=$P(^SSU("SSUSR",AUserID),"^",1)
	//E-mail
	s docinfoid=""
	s docinfoid=$o(^DHCEMRI.FeedBackDocInfoI("IdxDocID"," "_AUserID,docinfoid))
	if (docinfoid'=""){
			s fbdocobj=##class(EMRinstance.feedbackissue.doctorinfo).%OpenId(docinfoid)
			s LocPhone=fbdocobj.LocPhoneNumber
			s cellphone=fbdocobj.SelfPhoneNumber
		}
	s json="{""total"":3,""rows"":["
	s json=json_"{""name"":""工号"",""value"":"""_DocNo_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""医生"",""value"":"""_DocName_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""<span style=color:red>* </span>科室联系方式"",""value"":"""_LocPhone_""",""group"":""ID Settings"",""editor"":""text""},"
	s json=json_"{""name"":""<span style=color:red>* </span>个人联系方式"",""value"":"""_cellphone_""",""group"":""ID Settings"",""editor"":""text""}"
	s json=json_"]}"
	q json
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.feedbackissue).SaveFeedBack("这是一个测试语句")
ClassMethod SaveFeedBack(ArgIssueContent As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s ret=0
	s obj=##class(EMRinstance.feedbackissue.feedbackissueinfo).%New()
	s obj.DoctorID=AUserID
	s obj.EpisodeID=AEpisodeID
	s obj.FeedBackDate=$zd(+$h,3)
	s obj.FeedBackTime=$zt($p($h,",",2),1)
	s obj.FeedBackMessage=ArgIssueContent
	d obj.%Save()
	s ret=1
	q ret
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.feedbackissue).SaveDocInfo("这是一个测试语句")
ClassMethod SaveDocInfo(ADocInfomation As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	//a:valuea,b:valueb
	
	s ret=0
	q:(ADocInfomation="")
	
	s (realname,username,locphnumb,selfphnumb)=""
	
	s username=$P(^SSU("SSUSR",AUserID),"^",2)
	
	s changeInfolen=$l(ADocInfomation,",")-1
	
	for i=1:1:changeInfolen{
			s tmpInfo=$p(ADocInfomation,",",i)
			s properName=$p(tmpInfo,":",1)
			s properValue=$p(tmpInfo,":",2)
			if properName="医生"{
					s realname=properValue
				}
			elseif properName="科室联系方式"{
					s locphnumb=properValue
				}
			elseif properName="个人联系方式"{
					s selfphnumb=properValue
				}
		}
	s docinfoid=""
	s docinfoid=$o(^DHCEMRI.FeedBackDocInfoI("IdxDocID"," "_AUserID,docinfoid))
	if docinfoid=""{
		
		s obj=##class(EMRinstance.feedbackissue.doctorinfo).%New()
		s obj.DocId=AUserID
		s obj.LocPhoneNumber=locphnumb
		s obj.UserName=username
		s obj.SelfPhoneNumber=locphnumb
		s obj.RealName=realname
		d obj.%Save()
		s ret=1
	}
	else {
		s ret=1
	}
	q ret
}

/// w ##Class(EMRservice.Ajax.feedbackissue).ShowMessage()
ClassMethod ShowMessage() As %String
{
	s jsontotal="",json="",jsonend="]}",result="",total=0
	s result = ##Class(%ResultSet).%New("EMRinstance.feedbackissue.feedbackissueinfo:GetAllFeedBack")
	d result.Execute()
	While (result.Next()) 
	{
		s MessageID=result.Data("MessageID")
		s DoctorID=result.Data("DoctorID")
		s EpisodeID=result.Data("EpisodeID")
		s FeedBackDate=result.Data("FeedBackDate")
		s FeedBackTime=result.Data("FeedBackTime")
		s FeedBackMessage=result.Data("FeedBackMessage")
		
		//MessageID,DoctorID,EpisodeID,FeedBackDate,FeedBackMessage
		s DocName=$p($g(^SSU("SSUSR",DoctorID)),"^",2)
		s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
		s PatName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
		
		s msgstatus="已读"
		
		s json=json_"{""msgid"":"""_MessageID_""",""msgcretuser"":"""_DocName_""",""msgpat"":"""_PatName_""",""cretdate"":"""_FeedBackDate_""",""msgcontent"":"""_FeedBackMessage_""",""status"":"""_msgstatus_"""},"		
		s total = total + 1
 	}
 	Do result.Close()
	s:(total'=0) jsontotal="{""total"":"_total_",""rows"":["
	s:(json'="") json=jsontotal_$e(json,1,*-1)_jsonend

	q json
}

}
