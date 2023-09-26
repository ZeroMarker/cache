/// <H3>功能：监控汇总信息查询</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-07-06</H4>
Class DHCMed.CCService.Feedback.SummaryService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod BuildData(objSummary)
{
	New (objSummary,repid,SubjectID,FromDate,ToDate)
	
	Set $ZT="BuildDataErr"

	
	Set %Adm=##class(DHCMed.Base.PatientAdm).GetObjById(objSummary.EpisodeID)
	If %Adm'="" Do %Adm.%Close()
	Quit:'$IsObject(%Adm) ""
	
	Set %Patient=##class(DHCMed.Base.Patient).GetObjById(%Adm.PatientID)
	If %Patient'="" Do %Patient.%Close()
	Quit:'$IsObject(%Patient) ""
	
	Set Data=$lb("")
	Set $li(Data,1)=%Adm.AdmRowID //EpisodeID:%String
	Set $li(Data,2)=%Adm.PatientID //PatientID:%String
	Set $li(Data,3)=%Patient.PapmiNo //PatNo:%String:就诊卡号
	Set $li(Data,4)=%Patient.PatientName //PatientName:%String:姓名
	Set $li(Data,5)=%Patient.Sex //Sex:%String:性别
	Set $li(Data,6)=%Patient.Age //Age:%String:年龄
	Set $li(Data,7)=%Adm.AdmitDate //AdmitDate:%String:入院日期
	Set $li(Data,8)=%Adm.Department //Department:%String:科室
	Set:$li(Data,8)["-" $li(Data,8)=$p($li(Data,8),"-",2)
	Set $li(Data,9)=%Adm.Ward //Ward:%String:病房
	Set:$li(Data,9)["-" $li(Data,9)=$p($li(Data,9),"-",2)
	
	//Set DataType=$g(DataType)
	//Set PatInfo=$g(PatInfo)
	//Quit:(DataType=1)&(PatInfo'="")&(PatInfo'=%Patient.PatientName) ""
	//Quit:(DataType=2)&(PatInfo'="")&(%Patient.InPatientMrNo'[PatInfo) ""
	///Quit:(DataType=3)&(PatInfo'="")&(%Patient.PapmiNo'[PatInfo) ""
	//总得分
	Set $li(Data,10)=0 //TotalScore:%String
	Set SummaryID=""
	For	{
		Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",objSummary.EpisodeID,SubjectID,SummaryID))
		Quit:SummaryID=""
		Set objSum=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
		Continue:'$IsObject(objSum)
		Set $li(Data,10)=$li(Data,10)+objSum.TotalScore
	}
	
	Set $li(Data,11)=objSummary.TotalScore //ScoreThisTime:%String:此次得分
	Set $li(Data,12)=objSummary.SensitiveAmount //敏感性项目数量
	Set $li(Data,13)=objSummary.SpecificityAmount //特异性项目数量
	Set $li(Data,14)=objSummary.%Id() //ID
	Set $li(Data,15)=objSummary.ItemNumber //触发项目计数
	
	//反馈信息
	Set FeedBackInfo=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(objSummary.EpisodeID,objSummary.SubjectID)
	Set $li(Data,16)=+$p(FeedBackInfo,"^",1) //反馈数量
	Set $li(Data,17)=+$p(FeedBackInfo,"^",2) //接受数量
	Set $li(Data,18)=+$p(FeedBackInfo,"^",3) //拒绝数量
	Set $li(Data,19)=+$p(FeedBackInfo,"^",4) //无响应数量
	Set $li(Data,20)=%Adm.Bed //床位
	Set $li(Data,21)=##class(DHCMed.CCService.Feedback.EpisodeService).GetInfectionSummary(objSummary.EpisodeID)
	Set $li(Data,22)=$zd(objSummary.ActDate,3) //记录日期
	Set $li(Data,23)=objSummary.Status         //状态(未通知、已通知、排除)
	Set $li(Data,24)=%Adm.DoctorName           //Add By LiYang 2013-03-31 显示医师信息
	Set $li(Data,25)=%Adm.DepartmentID         //科室
	Set $li(Data,26)=%Adm.WardID               //病区
	Quit Data
	
BuildDataErr
	Quit ""
}

/// <H3>功能：通过监控日期查询汇总信息</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：自动监控的开始日期,支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>ToDate</B>：自动监控的结束日期,支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>Status</B>：状态：0--未处理  1--已接受 2--已拒绝 9--排除</LI>
/// <LI><B>IsSensitive</B>：是否敏感性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>IsSpecificity</B>：是否特异性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>DistinctEpisodeID</B>：同一就诊多条记录是否合并，0-不合并，其他-合并</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <LI>EpisodeID:%String</LI>
/// <LI>PatientID:%String</LI>
/// <LI>PatNo:%String:就诊卡号</LI>
/// <LI>PatientName:%String:姓名</LI>
/// <LI>Sex:%String:性别</LI>
/// <LI>Age:%String:年龄</LI>
/// <LI>AdmitDate:%String:入院日期</LI>
/// <LI>Department:%String:科室</LI>
/// <LI>Ward:%String:病房</LI>
/// <LI>TotalScore:%String:总分</LI>
/// <LI>ScoreThisTime:%String:此次得分</LI>
/// <LI>SensitiveAmount:%String:敏感项目触发数量</LI>
/// <LI>SpecificityAmount:%String:特异性项目触发数量</LI>
/// <LI>SummaryID:%String</LI>
/// <LI>FireItemCount:%String:触发项目数量</LI>
/// <LI>FeedBackCnt:%String:反馈次数</LI>
/// <LI>AcceptFeedbackCnt:%String:接受反馈次数</LI>
/// <LI>RejectFeedbackCnt:%String:拒绝反馈次数</LI>
/// <LI>NoResponseFeedbackCnt:%String:无响应反馈次数</LI>
/// <LI>Bed:%String:床位</LI>
/// <LI>INFInfo:%String:医院感染信息</LI>
/// <LI>Status:%String:状态</LI>
/// </OL>
/// <H4>实例</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SummaryService","QrySummary","2013-03-20","2013-03-27","1","1","","10","","INTCCS","1")
Query QrySummary(FromDate As %String, ToDate As %String, SubjectID As %String, Status As %String, DepID As %String = "", WardID As %String = "", SubCatIDList As %String = "", ViewConfigCode As %String, Adm48Hour As %String = "", aEpisodeID As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:入院日期,Department:%String:科室,Ward:%String:病房,TotalScore:%String:总分,ScoreThisTime:%String:此次得分,SensitiveAmount:%String:敏感项目触发数量,SpecificityAmount:%String:特异性项目触发数量,SummaryID:%String,FireItemCount:%String:触发项目数量,FeedBackCnt:%String:反馈次数,AcceptFeedbackCnt:%String:接受反馈次数,RejectFeedbackCnt:%String:拒绝反馈次数,NoResponseFeedbackCnt:%String:无响应反馈次数,Bed:%String:床位,INFInfo:%String:医院感染信息,ActDate:%String:记录日期,Status:%String:状态,Doctor:%String:医师,DepID:%String,WardID:%String,LnkSummaryIDs:%String,SubCatList:%String,FireCatCnt:%String,FireCatFlag:%String")
{
}

ClassMethod QrySummaryExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectID As %String, Status As %String, DepID As %String = "", WardID As %String = "", SubCatIDList As %String = "", ViewConfigCode As %String, Adm48Hour As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QrySummary"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectID,ViewConfigCode)
	
	For i=1:1:$l(SubCatIDList,"^") {
		Set SubCatID=$p(SubCatIDList,"^",i)
		Continue:SubCatID=""
		Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubCatID",SubCatID)=""
	}
	
	For tmpDate=FromDate:1:ToDate {
		Set SummaryRowID=""
		For	{
			Set SummaryRowID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",tmpDate,SubjectID,SummaryRowID))
			Quit:SummaryRowID=""
			Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryRowID)
			Continue:'$IsObject(objSummary)
			Continue:(aEpisodeID'="")&&(objSummary.EpisodeID'=aEpisodeID)
			Continue:((objSummary.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSummary.LnkSummaryID'="")&&(objSummary.LnkSummaryID'=SummaryRowID)  //过滤重复记录
			
			//Modified By LiYang 2013-02-27
			//增加科室、病区、关键字的过滤条件
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objSummary.EpisodeID)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C")) //Add By LiYAng 2013-03-28 过滤非在院患者
			Continue:((objAdm.DepartmentID'=DepID)&&(DepID'=""))
			Continue:((objAdm.WardID'=WardID)&&(WardID'=""))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			Set flg=0,Cnt=0
			Set CtlResultID=""
			For {
				Set CtlResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,objSummary.EpisodeID,SubjectID,CtlResultID))
				Quit:CtlResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultID)
				Continue:'$IsObject(objResult)
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",+objResult.ItemId))
				Set Cnt=Cnt+1
				
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",+objResult.ItemId))
				Continue:(SubCatIDList'="")&&('$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatID",SubCatID)))
				Set flg=flg+1
				
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",objSummary.EpisodeID,"SubCat",SubCatID))
			}
			Continue:flg=0
			Continue:Cnt=0
			
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",objSummary.EpisodeID,"Summary",objSummary.%Id())=""
		}
	}
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		Quit:EpisodeID=""
		Continue:(aEpisodeID'="")&&(EpisodeID'=aEpisodeID)
		
		Set WardID=+$p($g(^PAADM(EpisodeID)),"^",70)
		Set RoomID=+$p($g(^PAADM(EpisodeID)),"^",69)
    	Set RoomDesc=$p($g(^PAROOM(+RoomID)),"^",2)
    	Set:$p(RoomDesc,"-",2)'="" RoomDesc=+$p(RoomDesc,"-",2)
    	Set BedID=$p($g(^PAADM(EpisodeID)),"^",73)
		Set BedDesc=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",1)
		
    	Set RoomDesc=""
    	Set tmpRoomDesc=$p(BedDesc,"-",1)
    	Set $p(RoomDesc,"0",10-$l(tmpRoomDesc))=tmpRoomDesc
    	
		Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",WardID_","_RoomDesc_","_BedDesc,EpisodeID)=""
		
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
			Quit:SubCatID=""
			Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		}
	}
	
	Set xBedDesc=""
	For {
		Set xBedDesc=$o(^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",xBedDesc))
		Quit:xBedDesc=""
		
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",xBedDesc,EpisodeID))
			Quit:EpisodeID=""
			
			Set FireCatCnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
			Continue:FireCatCnt=0
			
			//多条数据合并
			Set SummaryRowID="",Data="",LnkSummaryIDs=""
			For {
				Set SummaryRowID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"Summary",SummaryRowID),-1)
				Quit:SummaryRowID=""
				
				Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryRowID)
				Continue:'$IsObject(objSummary)
				Set tmpData=..BuildData(objSummary)
				Continue:tmpData=""
				
				If Data="" {
					Set Data=tmpData
				} Else {
					Set $li(Data,10)=$li(Data,10)                  //总得分
					Set $li(Data,11)=$li(Data,11)+$li(tmpData,11)  //此次得分
					Set $li(Data,12)=$li(Data,12)+$li(tmpData,12)  //敏感性项目数量
					Set $li(Data,13)=$li(Data,13)+$li(tmpData,13)  //特异性项目数量
					Set $li(Data,15)=$li(Data,14)+$li(tmpData,14)  //触发项目计数
				}
				Set LnkSummaryIDs=LnkSummaryIDs_","_SummaryRowID
			}
			Continue:Data=""
			Set:LnkSummaryIDs'="" LnkSummaryIDs=$e(LnkSummaryIDs,2,$l(LnkSummaryIDs))
			
			//触发项目
			Set FireItem=""
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
				Quit:SubCatID=""
				
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Set SubCatDesc=objSubCat.ISCDesc
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
				Set IconCode=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID))
				Set:FireItem'="" FireItem=FireItem_$c(1)
				Set FireItem=FireItem_SubCatID_"^"_SubCatDesc_"^"_Cnt_"^"_IconCode
			}
			
			Set FireCatFlag=""
			If FireCatCnt>0 {
				Set $p(FireCatFlag,"★",FireCatCnt+1)=""
			}
			
			Set ^CacheTemp(repid,ind)=Data_$lb(LnkSummaryIDs,FireItem,FireCatCnt,FireCatFlag)
			Set ind=ind+1
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QrySummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySummaryExecute ]
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

/// <H3>功能：按就诊编号查询监控结果</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>：就诊编号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>Status</B>：状态：0--未处理  1--已接受 2--已拒绝</LI>
/// <LI><B>IsSensitive</B>：是否敏感性指标，1-是 0-否  空-查所有</LI>
/// <LI><B>IsSpecificity</B>：是否特异性指标，1-是 0-否  空-查所有</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <OL>
/// <LI>EpisodeID:%String</LI>
/// <LI>PatientID:%String</LI>
/// <LI>PatNo:%String:就诊卡号</LI>
/// <LI>PatientName:%String:姓名</LI>
/// <LI>Sex:%String:性别</LI>
/// <LI>Age:%String:年龄</LI>
/// <LI>AdmitDate:%String:入院日期</LI>
/// <LI>Department:%String:科室</LI>
/// <LI>Ward:%String:病房</LI>
/// <LI>TotalScore:%String:总分</LI>
/// <LI>ScoreThisTime:%String:此次得分</LI>
/// <LI>ItemSubTotal:%String:项目摘要</LI>
/// <LI>SensitiveAmount:%String:敏感项目触发数量</LI>
/// <LI>SpecificityAmount:%String:特异性项目触发数量</LI>
/// <LI>SummaryID:%String</LI>
/// <LI>FireItemCount:%String:触发项目数量</LI>
/// <LI>FeedBackCnt:%String:反馈次数</LI>
/// <LI>AcceptFeedbackCnt:%String:接受反馈次数</LI>
/// <LI>RejectFeedbackCnt:%String:拒绝反馈次数</LI>
/// <LI>NoResponseFeedbackCnt:%String:无响应反馈次数</LI>
/// <LI>Bed:%String:床位</LI>
/// <LI>INFInfo:%String:医院感染信息</LI>
/// </OL>
/// <H4>实例</H4>
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SummaryService","QrySummaryByEpisodeID",345,2,"","")
Query QrySummaryByEpisodeID(EpisodeID As %String, SubjectID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:入院日期,Department:%String:科室,Ward:%String:病房,TotalScore:%String:总分,ScoreThisTime:%String:此次得分,SensitiveAmount:%String:敏感项目触发数量,SpecificityAmount:%String:特异性项目触发数量,SummaryID:%String,FireItemCount:%String:触发项目数量,FeedBackCnt:%String:反馈次数,AcceptFeedbackCnt:%String:接受反馈次数,RejectFeedbackCnt:%String:拒绝反馈次数,NoResponseFeedbackCnt:%String:无响应反馈次数,Bed:%String:床位,INFInfo:%String:医院感染信息,ActDate:%String:记录日期,Status:%String:状态,Doctor:%String:医师,DepID:%String,WardID:%String")
{
}

ClassMethod QrySummaryByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String, SubjectID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:EpisodeID="" $$$OK
	
	Set SubID=""
	For	{
		Set SubID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",EpisodeID,SubID))
		Quit:SubID=""
		Continue:((SubID'=SubjectID)&&(SubjectID'=""))
		
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",EpisodeID,SubID,RowID))
			Quit:RowID=""
			
			Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(RowID)
			Continue:'$IsObject(objSummary)
			
			Set Data=..BuildData(objSummary)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySummaryByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySummaryByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySummaryByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySummaryByEpisodeIDExecute ]
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

/// 查询汇总结果的统计信息
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SummaryService","QrySummarySubtotal","2013-04-10","2013-04-15","1","2","0","","","","INTCCS","DepTemp^OutOfTemperature^1DepGermCnt^Bacteria^1PersonalGermKind^Bacteria^1DepGermKind^Bacteria^1")
Query QrySummarySubtotal(FromDate As %String, ToDate As %String, SubjectID As %String, GroupType As %String, Status As %String, DepID As %String, WardID As %String, SubCatCode As %String, ViewConfigCode As %String, WarnCtlStr As %String, Adm48Hour As %String = "") As %Query(ROWSPEC = "ItemID:%String,ItemName:%String:项目,Number:%Integer:数量,KeywordList:%String,WarnInfo:%String:预警信息")
{
}

ClassMethod QrySummarySubtotalExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectID As %String, GroupType As %String, Status As %String, DepID As %String, WardID As %String, SubCatCode As %String, ViewConfigCode As %String, WarnCtlStr As %String, Adm48Hour As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Quit:'$IsObject(objSubject) $$$OK
	Set objRule=##class(DHCMed.CC.CtlFilterRule).GetObjBySubjectID(SubjectID)
	Quit:'$IsObject(objRule) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QrySummarySubtotal"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	//疑似病例筛查，调用预警类库
	Set %ZIndexA=%ZIndex,%JIndexA=%JIndex,%NIndexA=%NIndex
	Set ret=##class(DHCMed.CCService.Feedback.WarnService).GetWarnCtlInfo(FromDate,ToDate,objSubject.Code,WarnCtlStr)
	
	//Query中调用Query，会引起repid错误
	Set repid=$I(^CacheTemp)
	Set ind=2
	Set qHandle=$lb(0,repid,0)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectID,ViewConfigCode)
	
	For tmpDate=FromDate:1:ToDate {
		Set SummaryRowID=""
		For	{
			Set SummaryRowID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",tmpDate,SubjectID,SummaryRowID))
			Quit:SummaryRowID=""
			
			Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryRowID)
			Continue:'$IsObject(objSummary)
			
			Continue:((objSummary.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSummary.LnkSummaryID'="")&&(objSummary.LnkSummaryID'=SummaryRowID)  //过滤重复记录	
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objSummary.EpisodeID)
			Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C")) //Add By LiYAng 2013-03-28 过滤非在院患者
			Continue:((objAdm.WardID'=WardID)&&(+WardID'=0))
			Continue:((objAdm.DepartmentID'=DepID)&&(+DepID'=0))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			Set CtlResultID=""
			For {
				Set CtlResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,objSummary.EpisodeID,SubjectID,CtlResultID))
				Quit:CtlResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultID)
				Continue:'$IsObject(objResult)
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexEpisodeID",objSummary.EpisodeID)="" //EpisodeID索引
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexSubCat",+SubCatID,"Paadm",objSummary.EpisodeID)=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexWard",+objAdm.WardID,"Paadm",objSummary.EpisodeID)=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexWard",+objAdm.WardID,"SubCatID",+SubCatID,"Paadm",objSummary.EpisodeID)=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexDep",+objAdm.DepartmentID,"Paadm",objSummary.EpisodeID)=""		
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndexDep",+objAdm.DepartmentID,"SubCatID",+SubCatID,"Paadm",objSummary.EpisodeID)=""		
			}
		}
	}
	
	Set IndexName="Other"
	Set:GroupType=1 IndexName="IndexDep" //按科室统计
	Set:GroupType=2 IndexName="IndexWard" //按病区统计
	Set:GroupType=3 IndexName="IndexSubCat" //按子类统计
	Set Total=$lb("")
	Set $li(Total,1)=0
	Set $li(Total,2)="全院"
	Set $li(Total,3)=0
	Set $li(Total,4)=""
	Set EpisodeID=""
	
	Set GroupData=""
	For {
		Set GroupData=$o(^TMP(%ZIndex,%JIndex,%NIndex,IndexName,GroupData))
		Quit:GroupData=""
		
		Set EpisodeID=""
		Set Cnt=0
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,IndexName,GroupData,"Paadm",EpisodeID))
			Quit:EpisodeID=""		
			Set Cnt=Cnt+1
		}
		
		Set data=$lb("")
		Set $li(data,1)=GroupData //分组的数据ID
		Set $li(data,2)="其他" //默认值
		Set $li(data,4)="" //子类集合
		Set $li(data,5)="" //预警数据
		if (GroupType=1) {
			Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(GroupData)
			Set:$IsObject(objDep) $li(data,2)=objDep.Descs
			Do:$IsObject(objDep) objDep.%Close()
		}
		if (GroupType=2) {
			Set objDep=##class(DHCMed.Base.PacWard).GetObjById(GroupData)
			Set:$IsObject(objDep) $li(data,2)=objDep.Descs
			Do:$IsObject(objDep) objDep.%Close()
			
			Set (TypeCodeList,TypeDescList,KeywordList,MinList)=""
			
			Set indWarnCtl=""
			For {
				Set indWarnCtl=$o(^TMP(%ZIndex,%JIndex,%NIndex,"WarnCtl","WardID",GroupData,indWarnCtl))
				Quit:indWarnCtl=""
				
				Set tmpData=$g(^TMP(%ZIndex,%JIndex,%NIndex,"WarnCtl","WardID",GroupData,indWarnCtl))
				Set:TypeCodeList'="" TypeCodeList=TypeCodeList_"$"
				Set TypeCodeList=TypeCodeList_$li(tmpData,2)
				Set:TypeDescList'="" TypeDescList=TypeDescList_","
				Set TypeDescList=TypeDescList_$li(tmpData,3)
				Set:MinList'="" MinList=MinList_"$"
				Set MinList=MinList_$li(tmpData,4)
				Set:KeywordList'="" KeywordList=KeywordList_"$"
				Set KeywordList=KeywordList_$li(tmpData,5)
			}
			Set $li(data,5)=""
			Set:TypeCodeList'="" $li(data,5)=$li(tmpData,1)_"^"_TypeCodeList_"^"_TypeDescList_"^"_MinList_"^"_KeywordList
			
		}		
		if (GroupType=3) {
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(GroupData)
			Set:$IsObject(objSubCat) $li(data,2)=objSubCat.ISCDesc
			Do:$IsObject(objSubCat) objSubCat.%Close()
		}
		Set:$li(data,2)["-" $li(data,2)=$p($li(data,2),"-",2)
		Set $li(data,3)=Cnt
		Set $li(Total,3)=$li(Total,3)+Cnt //合计
		Set SubCatID=""
		Set tmp=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,IndexName,+GroupData,"SubCatID",SubCatID))
			Quit:SubCatID=""
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
			Continue:$IsObject(objSubCat)=0
			Do objSubCat.%Close()
			Set Cnt=0
			Set Paadm=""
			For {
				Set Paadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,IndexName,+GroupData,"SubCatID",SubCatID,"Paadm",Paadm))
				Quit:Paadm=""
				Set Cnt=Cnt+1
			}
			Set:tmp'="" tmp=tmp_"/"
			Set tmp=tmp_SubCatID_"^"_objSubCat.ISCDesc_"^"_Cnt
		}
		Set $li(data,4)=tmp
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	If (((+DepID=0)&&(+WardID=0))&&((GroupType=1)||(GroupType=2))) {
		Set ^CacheTemp(repid,1)=Total
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QrySummarySubtotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySummarySubtotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySummarySubtotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySummarySubtotalExecute ]
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

/// Do ##Class(DHCMed.CCService.Feedback.SummaryService).Test()
ClassMethod Test()
{
	//w ##class(DHCMed.CCService.Feedback.SummaryService).Test()
	Set arg="DepGermKind^Bacteria^1"_$c(1)_"DepTemp^OutOfTemperature^1"_$c(1)_"DepGermCnt^Bacteria^1"_$c(1)_"PersonalGermKind^Bacteria^1"
	do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SummaryService","QrySummarySubtotal","2013-04-20","2013-04-26","1","3","0","","","","INTCCS","DepTemp^OutOfTemperature^1"_$c(1)_"DepGermCnt^Bacteria^1"_$c(1)_"PersonalGermKind^Bacteria^1"_$c(1)_"DepGermKind^Bacteria^1"_$c(1)_"","1")
	
	Quit "OK"
}

}
