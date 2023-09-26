/// 对当前在院患者进行监控
/// 
Class DHCMed.CCService.IntegratedCtrl.ControlCurrWard Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.CCService.IntegratedCtrl.ControlCurrWard).Test()
ClassMethod Test()
{
	do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.ControlCurrWard","QryCurrPatient","I","2013-04-10","2013-04-17","","","24/","1","2")
}

/// 查询当前在院患者
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.ControlCurrWard","QryCurrPatient","I","2013-04-17","2013-04-17","","","8/9/10/24/15/16/19/23/","1","2")
Query QryCurrPatient(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Query(ROWSPEC = "WardID:%String,WardDesc:%String:病区,PatientNum:%Integer:在院患者,SubCatList:%String,FiredPatNum:%Integer:触发患者数量")
{
}

ClassMethod QryCurrPatientExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCtrls="" $$$OK
	Quit:(argStatus="") $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:((argDateFrom="")||(argDateTo="")) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryCurrPatient"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItemBySubCatList(argSubjectID,argCtrls)
	
	Set SubCatCnt=0
	For indList=1:1:$l(argCtrls,"/") {
		Set SubCatID=$p(argCtrls,"/",indList)
		Continue:SubCatID=""
		Set SubCatCnt=SubCatCnt+1
	}
	
	//在院患者列表
	Set xWardID="",Count=0
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",xWardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",xWardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
				Do objAdm.%Close()
				Set WardID=objAdm.WardID
				
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",+WardID,"AdmCnt"))
			}
		}
	}
	
	For tmpDate=argDateFrom:1:argDateTo {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			
			Set AdmInfo=$g(^PAADM(EpisodeID))
			Continue:$p(AdmInfo,"^",2)'="I"  //过滤非住院患者
			Continue:$p(AdmInfo,"^",20)="C" //过滤取消就诊
			Continue:((argStatus="I")&&($p(AdmInfo,"^",20)="D"))				//就诊状态过滤
			Continue:((argStatus="O")&&($p(AdmInfo,"^",20)'="D"))				//就诊状态过滤
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objAdm)
			Do objAdm.%Close()
			Continue:((objAdm.DepartmentID'=argLocID)&&(argLocID'="")) //过滤科室
			Continue:((objAdm.WardID'=argWardID)&&(argWardID'="")) //过滤病区
			Set WardID=objAdm.WardID
			
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,argSubjectID,ResultID))
				Quit:ResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set ItemID=objResult.ItemId
				Continue:ItemID=""
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Ward",+WardID,"EpisodeID",EpisodeID,"SubCat",SubCatID,"SubjectItemID",ItemID)=""
			}
		}
	}
	
	Set WardID=""
	For {
		Set WardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID))
		Quit:WardID=""
		
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"EpisodeID",EpisodeID))
			Quit:EpisodeID=""
			
			//检查并与或的关系
			If Relation=1 {
				Set SubCatID=""
				For {
					Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"EpisodeID",EpisodeID,"SubCat",SubCatID))
					Quit:SubCatID=""
					Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"EpisodeID",EpisodeID))
				}
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"EpisodeID",EpisodeID))
				Continue:Cnt=0
				Continue:Cnt<SubCatCnt //没达到选择的子类数量
			}
			
			//计算监控分类人次数
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"EpisodeID",EpisodeID,"SubCat",SubCatID))
				Quit:SubCatID=""
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"SubCat",SubCatID))
			}
			Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"FiredCnt"))
		}
	}
	
	Set WardID=""
	For {
		Set WardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID))
		Quit:WardID=""
		
		Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
		Continue:'$IsObject(objWard)
		Do objWard.%Close()
		Set WardDesc=objWard.Descs
		Set:WardDesc="" WardDesc="其它"
		Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
		
		Set FireItem=""
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"SubCat",SubCatID))
			Quit:SubCatID=""
			
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
			Set SubCatDesc=objSubCat.ISCDesc
			
			Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"SubCat",SubCatID))
			Set IconCode=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID))
			Set:FireItem'="" FireItem=FireItem_$c(1)
			Set FireItem=FireItem_SubCatID_"^"_SubCatDesc_"^"_Cnt_"^"_IconCode
		}
		Set FiredCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"FiredCnt"))   //触发人数
		Continue:FiredCnt<1
		Set AdmCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",WardID,"AdmCnt"))       //在院人数
		
		Set Data=$lb(WardID,WardDesc,AdmCnt,FireItem,FiredCnt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryCurrPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCurrPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCurrPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCurrPatientExecute ]
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

/// 查询当前在院患者监控结果
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.ControlCurrWard","QryCurrPatientCtl",60,"","10","376",2)
/// Relation:1--并且 2--或者
Query QryCurrPatientCtl(SubjectID As %String, DepID As %String, aWardID As %String, SubCatList As %String, Relation As %String, FromDate As %String = "", ToDate As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,InfTypes:%String,MRAdm:%String,DepID:%String,WardID:%String,Score:%String,CtrlDtl:%String,EvalInfo:%String,FeedbackTimes:%String,AcceptTimes:%String,RejectTimes:%String,NoReponseTimes:%String,LastSummaryID:%String")
{
}

ClassMethod QryCurrPatientCtlExecute(ByRef qHandle As %Binary, SubjectID As %String, DepID As %String, aWardID As %String, SubCatList As %String, Relation As %String, FromDate As %String = "", ToDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
		
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Quit:'$IsObject(objSubject) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryCurrPatientCtl"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItemBySubCatList(SubjectID,SubCatList)
	
	Set SubCatCnt=0
	For indList=1:1:$l(SubCatList,"/") {
		Set SubCatID=$p(SubCatList,"/",indList)
		Continue:SubCatID=""
		Set SubCatCnt=SubCatCnt+1
	}
	
	//在院患者列表
	Set WardID="",Count=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))
		Quit:WardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
				Do objAdm.%Close()
				Continue:((objAdm.WardID'=aWardID)&&(aWardID'=""))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",Paadm)=""
				//Set ^TMP(%ZIndex,%JIndex,%NIndex,"WardID",WardID,"EpisodeID",Paadm)=""
				Set Count=Count+1
			}
		}
	}
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		Quit:EpisodeID=""
		
		Set ResultID="",flag=0
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",EpisodeID,SubjectID,ResultID))
			Quit:ResultID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:'$IsObject(objResult)
			Continue:((objResult.ActDate<FromDate)&&(FromDate'=""))
			Continue:((objResult.ActDate>ToDate)&&(ToDate'=""))
			Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",+objResult.ItemId))=0
			Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",+objResult.ItemId))
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID,"SubjectItemID",+objResult.ItemId)=""
		}
		
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
			Quit:SubCatID=""
			Set flag=flag+1
		}
		Continue:flag=0
		Continue:((flag'<SubCatCnt)&&(Relation=1))
		
		Set Data=##class(DHCMed.CCService.IntegratedCtrl.Control).BuildCtrlData(EpisodeID)
		Continue:Data=""
		//Set arryDetail=##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultListBySubCateID(EpisodeID,SubjectID,SubCatList,argDateFrom,argDateTo) //Modified By LiYang 2013-02-28用子类的ID代替单独的项目查询
		Set DataDetail=$lb("")	
		Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(SubjectID,EpisodeID)
		Set strFeedbackTimes=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(EpisodeID,SubjectID)
		Set TotalTimes=$p(strFeedbackTimes,"^",1)
		Set AcceptTimes=$p(strFeedbackTimes,"^",2)
		Set RejectTimes=$p(strFeedbackTimes,"^",3)
		Set NoResponseTimes=$p(strFeedbackTimes,"^",4)
		Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",EpisodeID,SubjectID,""),-1)
		Set Data=Data_$lb(Score)_DataDetail_$lb(EvalInfo)_$lb(TotalTimes,AcceptTimes,RejectTimes,NoResponseTimes,LastSummaryID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		

	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryCurrPatientCtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCurrPatientCtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCurrPatientCtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCurrPatientCtlExecute ]
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

/// 查询当前在院患者
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.ControlCurrWard","QryPatListByLoc","I","2013-04-17","2013-04-17","","8/9/10/24/15/16/19/23/","1","2")
Query QryPatListByLoc(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Query(ROWSPEC = "WardID:%String,WardDesc:%String:病区,PatientNum:%Integer:在院患者,SubCatList:%String,FiredPatNum:%Integer:触发患者数量")
{
}

ClassMethod QryPatListByLocExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCtrls="" $$$OK
	Quit:(argStatus="") $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:((argDateFrom="")||(argDateTo="")) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryPatListByLoc"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set SubCatCnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItemBySubCatList(argSubjectID,argCtrls)
	Quit:SubCatCnt=0 $$$OK
	
	Set SubCatCnt=0
	For indList=1:1:$l(argCtrls,"/") {
		Set SubCatID=$p(argCtrls,"/",indList)
		Continue:SubCatID=""
		Set SubCatCnt=SubCatCnt+1
	}
	
	For xTransDate=argDateFrom:1:(argDateTo+10) {
		Set xWardID=0
		For {
			Set xWardID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID))
			Quit:xWardID=""
			
			//病区过滤
			Set LocType=$p($g(^CTLOC(xWardID)),"^",13)
			Continue:LocType'="W"
			Continue:(argWardID'="")&&(argWardID'=xWardID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //过滤非住院患者
				Continue:$p(AdmInfo,"^",20)="C"  //过滤取消就诊
				Continue:((argStatus="I")&&($p(AdmInfo,"^",20)="D"))	//就诊状态过滤
				Continue:((argStatus="O")&&($p(AdmInfo,"^",20)'="D"))	//就诊状态过滤
				
				//筛查监控结果
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID)=""
					
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>argDateTo
					Continue:TransOutDate<argDateFrom
					
					//计算科室在院人数
					If '$d(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"AdmList",xPaadm)) {
						Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"AdmCnt"))
						Set ^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"AdmList",xPaadm)=""
					}
					
					For xActDate=TransInDate:1:TransOutDate {
						Continue:xActDate<argDateFrom
						Continue:xActDate>argDateTo
						Set xResultID=""
						For {
							Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xActDate,xPaadm,argSubjectID,xResultID))
							Quit:xResultID=""
							
							Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
							Continue:'$IsObject(objResult)
							Set ItemID=objResult.ItemId
							Continue:ItemID=""
							Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
							Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
							Set ^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID,"SubjectItemID",ItemID)=""
						}
					}
				}
			}
		}
	}
	
	Set xWardID=""
	For {
		Set xWardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID))
		Quit:xWardID=""
		
		Set WardDesc=$p($g(^CTLOC(xWardID)),"^",2)
		Set:WardDesc="" WardDesc="其它"
		Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
		
		Set xPaadm=0
		For {
			Set xPaadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
			Quit:xPaadm=""
			
			//检查并与或的关系
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID))
				Quit:SubCatID=""
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
			}
			Set FireCatCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
			Continue:FireCatCnt<1
			Continue:((FireCatCnt<SubCatCnt)&&(Relation=1)) //没达到选择的子类数量--Relation=1时
			
			//计算科室监控触发人数
			If $d(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat")) {
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"FiredCnt"))
			}
			
			//计算监控分类触发次数
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID))
				Quit:SubCatID=""
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"SubCat",SubCatID))
			}
		}
		
		Set FiredCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"FiredCnt"))   //触发人数
		Continue:FiredCnt<1
		Set AdmCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"AdmCnt"))       //在院人数
		
		Set FireItem=""
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"SubCat",SubCatID))
			Quit:SubCatID=""
			
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
			Set SubCatDesc=objSubCat.ISCDesc
			
			Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"SubCat",SubCatID))
			Set IconCode=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID))
			Set:FireItem'="" FireItem=FireItem_$c(1)
			Set FireItem=FireItem_SubCatID_"^"_SubCatDesc_"^"_Cnt_"^"_IconCode
		}
		
		Set Data=$lb(xWardID,WardDesc,AdmCnt,FireItem,FiredCnt)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryPatListByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatListByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPatListByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatListByLocExecute ]
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
