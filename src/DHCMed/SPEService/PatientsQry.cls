/// ClassName:    DHCMed.SPEService.PatientsQry
/// Description:  特殊患者记录 相关操作
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DHCMed.SPEService.PatientsQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-08
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildDataErr"
	Set (Paadm,PatientID,RegNo,PatientName,Sex,Age,AdmitDate,Room,Bed,AdmType,LocDesc,WardDesc)=""
	Set (PatTypes,LocID,WardID,DoctorID,DoctorName)=""
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(argPaadm)
	Quit:$IsObject(objAdm)=0
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	Quit:$IsObject(objPatient)=0
	//统一调用年龄计算方法
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(objAdm.PatientID,argPaadm,AdmDate,AdmitTime)
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
	//Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(objAdm.PatientID,argPaadm,"","")
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(objAdm.PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set Data=$lb("")
	Set $li(Data,1)=objAdm.AdmRowID
	Set $li(Data,2)=objAdm.PatientID
	Set $li(Data,3)=objPatient.PapmiNo
	Set $li(Data,4)=objPatient.PatientName
	Set $li(Data,5)=objPatient.Sex
	Set $li(Data,6)=PatientAge
	Set $li(Data,7)=objAdm.AdmType
	Quit:objAdm.AdmType'="I"
	Set $li(Data,8)=objAdm.AdmitDate
	Set $li(Data,9)=objAdm.DepartmentID
	Set $li(Data,10)=objAdm.Department
	Set:$p(objAdm.Department,"-",2)'="" $li(Data,10)=$p(objAdm.Department,"-",2)
	Set $li(Data,11)=objAdm.WardID
	Set $li(Data,12)=objAdm.Ward
	Set:$p(objAdm.Ward,"-",2)'="" $li(Data,12)=$p(objAdm.Ward,"-",2)
	Set $li(Data,13)=objAdm.Room
	Set $li(Data,14)=objAdm.Bed
	Set $li(Data,15)=objAdm.DoctorID
	Set $li(Data,16)=objAdm.DoctorName
	
	//特殊患者标记信息
	Set xSubID="",SpeInfo=""
	For {
		Set xSubID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",argPaadm,xSubID))
		Quit:xSubID=""
		
		Set xSpeID=""
		For {
			Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",argPaadm,xSubID,xSpeID))
			Quit:xSpeID=""
			
			Set tmpSpeInfo=..GetSpeIconCont(xSpeID)
			Continue:tmpSpeInfo=""
			Set SpeInfo=SpeInfo_$c(1)_tmpSpeInfo
		}
	}
	Set:SpeInfo'="" SpeInfo=$e(SpeInfo,2,$l(SpeInfo))
	Set $li(Data,17)=SpeInfo
	Set $li(Data,18)=EncryptLevel
	Set $li(Data,19)=PatLevel
	
   	Set return=Data
	Quit return
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

ClassMethod GetSpeIconCont(aSpeID As %String) As %String
{
	New (aSpeID)
	Set return=""
	Quit:aSpeID="" return
	
	Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(aSpeID)
	Quit:'$IsObject(objSpe) return
	Set objStatus=objSpe.PSCurrStatus
	Quit:'$IsObject(objStatus) return
	Set StatusCode=objStatus.Code
	Quit:StatusCode="0" return	//"0"作废
	Set objPatType=objSpe.PSPatTypeDr
	Quit:'$IsObject(objPatType) return
	
	Set $p(return,"^",1)=aSpeID
	Set $p(return,"^",2)=objStatus.Code
	Set $p(return,"^",3)=objStatus.Description
	Set $p(return,"^",4)=objPatType.PTSDesc
	Set $p(return,"^",5)=objPatType.PTSIcon
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-08
/// Description:  查询综合监测就诊列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QryCtlPaadm","2015-10-27","2015-11-02","43/44/45/46/","","","")
Query QryCtlPaadm(aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmType:%String,AdmitDate:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,Room:%String,Bed:%String,DoctorID:%String,DoctorName:%String,PatTypes:%String,EncryptLevel:%String,PatLevel:%String,Ind:%String,CtrlCont:%String,CtrlDtl:%String")
{
}

ClassMethod QryCtlPaadmExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aDateFrom,aDateTo,aCtrls,aLocID,aWardID,aHospID)
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aCtrls="") $$$OK
 	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	//Set %ZIndex=$zn,%JIndex=$j
	//Kill ^TMP(%ZIndex,%JIndex,"QryCtlPaadm")
	
 	Set IndexCode="IndexActDateEpisodeID"    //结果日期
	For xDate=aDateFrom:1:aDateTo {
 		Set xEpisodeID=""
 		For {
 			Set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID))
 			Quit:xEpisodeID=""
 			
 			Set EpisodeID=xEpisodeID
 			Set AdmInfo=$g(^PAADM(EpisodeID))
 			Continue:$p(AdmInfo,"^",2)'="I"                 //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:AdmLoc=""
			//Set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			//Continue:(aHospID'="")&&(aHospID'=CTHospID)
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				continue:flg<1
			}
			
			Set CtrlDtl="",CtrlCont="",ItemCount=0
			For indItem=1:1:$l(aCtrls,"/") {
				Set ItemID=$p(aCtrls,"/",indItem)
				Continue:ItemID=""
				
				Continue:'$d(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID))
				
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
				Continue:'$IsObject(objItemDic)
				Set ItemDesc=objItemDic.IDDesc
				Set Score=objItem.Score
				Set ItemGroup=""
				Set:(Score>0)&&(Score<=50) ItemGroup="一级"
				Set:(Score>50)&&(Score<=100) ItemGroup="二级"
				Set:Score>100 ItemGroup="三级"
				Continue:ItemGroup=""
				
				Set ItemCount=ItemCount+1
				
				Set ResultCount=0
				Set xObjectID=""
				For {
					Set xObjectID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID,xObjectID))
 					Quit:xObjectID=""
					
 					Set xResultID=""
 					For {
	 					Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID,xObjectID,xResultID))
 						Quit:xResultID=""
						
 						Set objResult=##Class(DHCMed.CC.CtlResult).GetObjById(xResultID)
 						Continue:'$IsObject(objResult)
 						
 						If (aLocID'="")||(aWardID'="") {
				 			Set OccurDate=objResult.OccurDate
				 			Set OccurTime=objResult.OccurTime
				 			Set LocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(xEpisodeID,OccurDate,OccurTime)
				 			Set LocID=$p(LocWard,",",1)
				 			Set WardID=$p(LocWard,",",3)
				 			Continue:(aLocID'="")&&(aLocID'=LocID)
				 			Continue:(aWardID'="")&&(aWardID'=WardID)
 						}
						Set CtrlDtl=CtrlDtl_","_xResultID
						
						Set ItemID=objResult.ItemId
						Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
						Continue:'$IsObject(objItem)
						Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
						Continue:'$IsObject(objItemDic)
						Set ItemDesc=objItemDic.IDDesc
						Set ItemSubCatID=objItemDic.IDSubCatDr
						Set objItemSubCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatID)
						Continue:'$IsObject(objItemSubCat)
						Set ItemSubCatDesc=objItemSubCat.ISCDesc
						Set ItemCatID=objItemSubCat.ISCCatDr
						Set objItemCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
						Continue:'$IsObject(objItemCat)
						Set ItemCatDesc=objItemCat.ICDesc
						Continue:ItemCatDesc=""
						
						Continue:$listfind(CtrlCont,ItemCatDesc)>0
						Set CtrlCont=CtrlCont_$lb(ItemCatDesc)
					}
				}
			}
			Continue:CtrlDtl=""
			Set:CtrlDtl'="" CtrlDtl=$e(CtrlDtl,2,$l(CtrlDtl))
			
			Set tmpCtrlCont=""
			For indC=1:1:$listlength(CtrlCont) {
				Set tmpContent=$list(CtrlCont,indC)
				Continue:tmpContent=""
				Set tmpCtrlCont=tmpCtrlCont_";"_tmpContent
			}
			Set CtrlCont=tmpCtrlCont
			Set:CtrlCont'="" CtrlCont=$e(CtrlCont,2,$l(CtrlCont))
			
			Set Data=..BuildData(EpisodeID)
			Continue:Data=""
			Set Data=Data_$lb(ind,CtrlCont,CtrlDtl)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryCtlPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlPaadmExecute ]
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
/// CreatDate：   2014-03-02
/// Description:  查询综合监测项目列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QryCtrlDtlByAdm","1985323")
Query QryCtrlDtlByAdm(aResultIDs As %String) As %Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActLoc:%String,ActWard:%String,OccurDate:%String,OccurTime:%String,DataValue:%String,ObjectID:%String")
{
}

ClassMethod QryCtrlDtlByAdmExecute(ByRef qHandle As %Binary, aResultIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aResultIDs="" $$$OK
 	
 	For indRst=1:1:$l(aResultIDs,",") {
		Set ResultID=$p(aResultIDs,",",indRst)
		Continue:ResultID=""
		
		Set (ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime)=""
		Set (ActUser,OccurDate,OccurTime,DataValue,ObjectID)=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Continue:'$IsObject(objResult)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set ItemCatID=objItemDic.IDSubCatDr
		Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ISCDesc
		
		Set Score=objItem.Score
		Set ItemGroup=""
		Set:(Score>0)&&(Score<=50) ItemGroup="一级"
		Set:(Score>50)&&(Score<=100) ItemGroup="二级"
		Set:Score>100 ItemGroup="三级"
		Continue:ItemGroup=""
		
		Set Summary=objResult.Summary
		Set DataValue=objResult.DataValue
		Set ObjectID=objResult.ObjectID
		
		Set ActDate=objResult.ActDate
		Set ActTime=objResult.ActTime
		;Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set ActUser=objResult.UserID
		Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		
		Set OccurDate=objResult.OccurDate
		Set OccurTime=objResult.OccurTime
		Set EpisodeID=objResult.EpisodeID
		set tmpLocWard=..GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
		set ActLoc=$p(tmpLocWard,",",1)
		set ActWard=$p(tmpLocWard,",",3)
		Set ActLoc=+ActLoc
	 	Set ActWard=+ActWard
	 	Set ActLoc=$p($g(^CTLOC(+ActLoc)),"^",2)
		Set:$p(ActLoc,"-",2)'="" ActLoc=$p(ActLoc,"-",2)
  		
	 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		;Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		Set Data=$lb(ResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActUser,ActLoc,ActWard,OccurDate,OccurTime,DataValue,ObjectID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCtrlDtlByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtrlDtlByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtrlDtlByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtrlDtlByAdmExecute ]
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

ClassMethod GetAdmitLocWard(aEpisodeID As %String, aActDate As %String, aActTime As %String) As %String
{
	New (aEpisodeID,aActDate,aActTime)
	Set return=""
	
	Quit:(aEpisodeID="")||(aActDate="")||(aActTime="") return
	Set:aActDate["-" aActDate=$zdh(aActDate,3)
	Set:aActTime[":" aActTime=$zth(aActTime,1)
	Set:aActTime'="" aActTime=+aActTime
	
	//Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	If (AdmDate>aActDate)||((AdmDate=aActDate)&&(AdmTime>aActTime)) {
		Set aActDate=AdmDate
		Set aActTime=AdmTime
	}
	
	Set LocID="",LocDesc="",WardID="",WardDesc=""
	Set tWardID=+$P($G(^PAADM(+aEpisodeID)),"^",70)
	Set Ward=$g(^PAWARD(+tWardID))
	Set WardCtlocID=$P(Ward,"^",5)
	Set WardID=WardCtlocID
	
	Set xTransID=0
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		Continue:tmpTrans=""
		Set TransDate=$p(tmpTrans,"^",1)
		Set TransTime=$P(tmpTrans,"^",2)
		Quit:(TransDate>aActDate)
		Quit:(TransDate=aActDate)&&(TransTime>aActTime)
		
		Set TransLoc=$p(tmpTrans,"^",6)
		If (TransLoc'="") {
			Set LocID=TransLoc
		}
		Set TransWard=$p($p(tmpTrans,"^",8),"||",1)
		If (TransWard'="") {
			Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			Set WardID=TransWard
		}
	}
	Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	sET:$P(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Set LocDesc=$tr(LocDesc,",","")
	
	Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	Set WardDesc=$tr(WardDesc,",","")
	
	Set return=LocID_","_LocDesc_","_WardID_","_WardDesc
	Quit return
}

/// w ##Class("DHCMed.SPEService.PatientsQry").QryCtlPaadmToExcel("fillxlSheet","2015-06-10^2015-07-07^594/595/596^^^")
ClassMethod QryCtlPaadmToExcel(itmjs As %String, ArgStr As %String) As %String
{
	n (itmjs,ArgStr)
	s Count=0
    
	s aStaDate=$p(ArgStr,"^",1)
    s aEndDate=$p(ArgStr,"^",2)
    s aCtrls=$p(ArgStr,"^",3)
    s aLocID=$p(ArgStr,"^",4)
    s aWardID=$p(ArgStr,"^",5)
    s aHospID=$p(ArgStr,"^",6)
   
	s ds = ##class(%Library.ResultSet).%New("DHCMed.SPEService.PatientsQry:QryCtlPaadm")
	d ds.Execute(aStaDate,aEndDate,aCtrls,aLocID,aWardID,aHospID)
	
	s StartRow=2
	while(ds.Next())
	{
	
		s Paadm=ds.Data("Paadm")
		s PatientID=ds.Data("PatientID")
		s RegNo=ds.Data("RegNo")
		s PatientName=ds.Data("PatientName")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s AdmitDate=ds.Data("AdmitDate")
		s Room=ds.Data("Room")
		s Bed=ds.Data("Bed")
		s AdmType=ds.Data("AdmType")
		s LocDesc=ds.Data("LocDesc")
		s WardDesc=ds.Data("WardDesc")
		//s PatTypes=ds.Data("PatTypes")
		s LocID=ds.Data("LocID")
		s WardID=ds.Data("WardID")
		s DoctorID=ds.Data("DoctorID")
		s DoctorName=ds.Data("DoctorName")
	    s EncryptLevel=ds.Data("EncryptLevel")
		s PatLevel=ds.Data("PatLevel")				
	    Set tmp    = "" 
		Set xSubID = ""
		For{
			Set xSubID = $o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",Paadm,xSubID))
			Quit:xSubID=""
			Set xSPEID = ""
			if xSubID '= ""
			{
				Set xSPEID = $o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",Paadm,xSubID,xSPEID))
				Quit:xSPEID=""
				Set objSpe = ##class(DHCMed.SPE.Patients).GetObjById(xSPEID)
				Quit:$IsObject(objSpe)=0
				Set objStatus = objSpe.PSCurrStatus
				Quit:'$IsObject(objStatus)
				Set StatusCode = objStatus.Code
				//Continue:(StatusCode="4")||(StatusCode="0")		//"0"作废  "4"关闭
				Set objSub = ##class(DHCMed.SPE.PatTypeSub).GetObjById(xSubID)
				Quit:$IsObject(objSub)=0
				Set StatusCode = objSub.PTSCode
				Set tmp=tmp_","_objSub.PTSDesc_"("_objStatus.Description_")"
			} 
		}
		Set:tmp'="" tmp=$e(tmp,2,$l(tmp))
        s PatTypes=tmp
        
		s str=RegNo_$c(1)_PatientName_$c(1)_Sex_$c(1)_Age_$c(1)_EncryptLevel_$c(1)_PatLevel_$c(1)_AdmitDate_$c(1)_PatTypes_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_Room_$c(1)_Bed_$c(1)_DoctorName
		s retval=itmjs_"(xlSheet,'"_$ZCVT(str,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
	}
	
	d ds.Close()
	
	q 1
}

/// creator : zhouruimeng
/// 查询特殊患者列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QrySpeCheckList","2",2,"2015-11-03","2015-11-03","","","","")
Query QrySpeCheckList(aQryStatus As %String, aOperTpCode As %String, aHospID As %String, aDateFrom As %String, aDateTo As %String, aPatType As %String, aLocID As %String, aRegNo As %String, aPatName As %String) As %Query(ROWSPEC = "SpeID:%String,PatTypeID:%String,PatTypeDesc:%String,StatusCode:%String,StatusDesc:%String,DutyUserID:%String,DutyUserDesc:%String,DutyDeptID:%String,DutyDeptDesc:%String,MarkDate:%String,MarkTime:%String,Note:%String,Opinion:%String,CheckDate:%String,CheckTime:%String,CheckOpinion:%String,ReadStatus:%String,EpisodeID:%String,PatientID:%String,RegNo:%String,PatName:%String,Sex:%String,PatientAge:%String,AdmDate:%String,AdmTime:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,Bed:%String,DoctorID:%String,DoctorName:%String")
{
}

ClassMethod QrySpeCheckListExecute(ByRef qHandle As %Binary, aQryStatus As %String, aOperTpCode As %String, aHospID As %String, aDateFrom As %String, aDateTo As %String, aPatType As %String, aLocID As %String, aRegNo As %String, aPatName As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
	//Set ^ZF=$lb(aQryStatus,aOperTpCode,aDateFrom,aDateTo,aPatType,aLocID,aRegNo,aPatName)
	
	Quit:(aQryStatus="")||(aOperTpCode="") $$$OK
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	//Set:aHospID'="" aHospID=","_aHospID_","
	
	Kill ^TMPSpeList("SpeList")  //fix bug 172227 未阅读和已阅读状态后台查询时结果重复
	
	//未审核特殊患者列表
    If aQryStatus="1" {
	    Set xDate=aDateFrom-1
	    For {
		    Set xDate=$o(^DHCMed.SPEi("Pat",0,"IndexIsCheckMark",0,xDate))
		    Quit:xDate=""
		    Quit:xDate>aDateTo
		    
		    Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"IndexIsCheckMark",0,xDate,xTime))
				Quit:xTime=""
				
			    Set xID=0
			    For {
				    Set xID=$o(^DHCMed.SPEi("Pat",0,"IndexIsCheckMark",0,xDate,xTime,xID))
				    Quit:xID=""
			    	
			    	Set Data=..BuildSpeCheckData(xID,aPatType,aQryStatus,aOperTpCode,aHospID,aLocID,aRegNo,aPatName)
			    	Continue:Data=""
			    	Set ^CacheTemp(repid,ind)=Data
			    	Set ind=ind+1
				}
			}
		}
	}
	
	//已审核特殊患者列表
    If aQryStatus="2" {
	    Set xDate=aDateFrom-1
	    For {
		    Set xDate=$o(^DHCMed.SPEi("Pat",0,"IndexCheckDate",xDate))
		    Quit:xDate=""
		    Quit:xDate>aDateTo
		    
		    Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"IndexCheckDate",xDate,xTime))
				Quit:xTime=""
				
			    Set xID=0
			    For {
				    Set xID=$o(^DHCMed.SPEi("Pat",0,"IndexCheckDate",xDate,xTime,xID))
				    Quit:xID=""
			    	
			    	Set Data=..BuildSpeCheckData(xID,aPatType,aQryStatus,aOperTpCode,aHospID,aLocID,aRegNo,aPatName)
			    	Continue:Data=""
			    	Set ^CacheTemp(repid,ind)=Data
			    	Set ind=ind+1
				}
		    }
		}
	}
	
	//未阅读消息列表
    If aQryStatus="3" {
	    Set xDate=aDateFrom-1
	    For {
		    Set xDate=$o(^DHCMed.SPEi("Pat",0,"Log","IndexIsReadNews",0,xDate))
		    Quit:xDate=""
		    Quit:xDate>aDateTo
		    
		    Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"Log","IndexIsReadNews",0,xDate,xTime))
			    Quit:xTime=""
			    
			    Set xSpeID=0
			    For {
				    Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"Log","IndexIsReadNews",0,xDate,xTime,xSpeID))
				    Quit:xSpeID=""
			    	
				    Set IsNotRead=0
				    Set xLogSub=0
				    For {
					    Set xLogSub=$o(^DHCMed.SPEi("Pat",0,"Log","IndexIsReadNews",0,xDate,xTime,xSpeID,xLogSub))
					    Quit:xLogSub=""
		    			
					    Set SpeLogID=xSpeID_"||"_xLogSub
					    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
					    Continue:'$IsObject(objLog)
					    Continue:objLog.PSLIsActive'=1  //无效
					    Continue:'$IsObject(objLog.PSLStatus)
					    Continue:objLog.PSLStatus.Code'=9  //状态不符
					    If aOperTpCode=1 {
						    Continue:objLog.PSLNewsType'=2  //临床查看管理科消息
						} Else {
							Continue:objLog.PSLNewsType'=1  //管理科查看临床消息
						}
					    Continue:objLog.PSLIsRead=1     //已读
					    Set IsNotRead=1
					    Quit
					}
					Continue:IsNotRead<1 //无未读消息,过滤
					//fix bug 172227 未阅读和已阅读状态后台查询时结果重复
					Continue:$d(^TMPSpeList("SpeList",xSpeID)) 
					Set ^TMPSpeList("SpeList",xSpeID)=""
			    	Set Data=..BuildSpeCheckData(xSpeID,aPatType,aQryStatus,aOperTpCode,aHospID,aLocID,aRegNo,aPatName)
		    		Continue:Data=""
			    	Set ^CacheTemp(repid,ind)=Data
			    	Set ind=ind+1
				}
			}
		}
	}
	
	//已阅读消息列表
    If aQryStatus="4" {
	    Set xDate=aDateFrom-1
	    For {
		    Set xDate=$o(^DHCMed.SPEi("Pat",0,"Log","IndexReadDateTime",xDate))
		    Quit:xDate=""
		    Quit:xDate>aDateTo
		    
		    Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"Log","IndexReadDateTime",xDate,xTime))
			    Quit:xTime=""
			    
			    Set xSpeID=0
			    For {
				    Set IsRead=1
				    Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"Log","IndexReadDateTime",xDate,xTime,xSpeID))
				    Quit:xSpeID=""
				    
				    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(xSpeID)
				    Continue:'$IsObject(objSpe)
				    //fix bug 172227 “已阅读”查询，管理科室查看临床消息时未阅读的仍显示在列表中
				    /*
				    Set xLogSub=0
				    For {
					    Set xLogSub=$o(^DHCMed.SPEi("Pat",0,"Log","IndexReadDateTime",xDate,xTime,xSpeID,xLogSub))
					    Quit:xLogSub=""
		    			
					    Set SpeLogID=xSpeID_"||"_xLogSub
					    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
					    Continue:'$IsObject(objLog)
					    Continue:objLog.PSLIsActive'=1  //无效
					    Continue:'$IsObject(objLog.PSLStatus)
					    Continue:objLog.PSLStatus.Code'=9  //状态不符
					    If aOperTpCode=1 {
						    Continue:objLog.PSLNewsType'=2  //临床查看管理科消息
						} Else {
							Continue:objLog.PSLNewsType'=1  //管理科查看临床消息
						}
					    Continue:objLog.PSLIsRead'=1    //已读
					    Set IsRead=1
					    Quit
					}*/
					For xLogSub=1:1:objSpe.ChildLog.Count() {
						Set SpeLogID=xSpeID_"||"_xLogSub
					    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
					    Continue:'$IsObject(objLog)
					    Continue:objLog.PSLIsActive'=1  //无效
					    Continue:'$IsObject(objLog.PSLStatus)
					    Continue:objLog.PSLStatus.Code'=9  //状态不符
					    If aOperTpCode=1 {
						    Continue:objLog.PSLNewsType'=2  //临床查看管理科消息
						} Else {
							Continue:objLog.PSLNewsType'=1  //管理科查看临床消息
						}
						Continue:objLog.PSLIsRead=1    //已读
					    Set IsRead=0
					 	Quit
					}
					
					Continue:IsRead<1 //有未读消息,过滤
					//fix bug 172227 未阅读和已阅读状态后台查询时结果重复
					Continue:$d(^TMPSpeList("SpeList",xSpeID))
					Set ^TMPSpeList("SpeList",xSpeID)=""
			    	Set Data=..BuildSpeCheckData(xSpeID,aPatType,aQryStatus,aOperTpCode,aHospID,aLocID,aRegNo,aPatName)
		    		Continue:Data=""
			    	Set ^CacheTemp(repid,ind)=Data
			    	Set ind=ind+1
				}
			}
		}
	}
	
	Kill ^TMPSpeList("SpeList")
    Quit $$$OK
}

ClassMethod QrySpeCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpeCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpeCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpeCheckListExecute ]
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

ClassMethod BuildSpeCheckData(aSpeID As %String, aPatType As %String, aQryStatus As %String, aOperTpCode As %String, aHospID As %String, aLocID As %String, aRegNo As %String, aPatName As %String) As %String
{
	New (aSpeID,aPatType,aQryStatus,aOperTpCode,aHospID,aLocID,aRegNo,aPatName)
	Set return=""
	Quit:aSpeID="" return
	
	If (aRegNo'=""){ //登记号
		Set Len=10
		Set PATCFid=$o(^CF("PATCF",""))
		Set:PATCFid'="" Len=$p($g(^CF("PATCF",+PATCFid,3)),"^",5)
		If $l(aRegNo)<Len {
			Set PreLen=Len-$l(aRegNo)
			For indPre=1:1:PreLen {
				Set aRegNo="0"_aRegNo
			}
		}
	}
    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(aSpeID)
    Quit:'$IsObject(objSpe) return
    Quit:'$IsObject(objSpe.PSPatTypeDr) return
    Quit:'$IsObject(objSpe.PSCurrStatus) return
	Set EpisodeID=objSpe.PSEpisodeID
	Set PatTypeID=objSpe.PSPatTypeDr.%Id()
	Quit:(aPatType'="")&(aPatType'=PatTypeID) return
	Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
	Set StatusCode=objSpe.PSCurrStatus.Code
	
	Set AdmInfo=$g(^PAADM(EpisodeID))
	Quit:$p(AdmInfo,"^",2)'="I" return      //就诊类型过滤
	Quit:$p(AdmInfo,"^",20)="C" return      //就诊状态过滤
	Set AdmLoc=$p(AdmInfo,"^",4)
	Quit:AdmLoc="" return
	/*Set AdmHosp=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
    If (AdmHosp'="")&&(aHospID'="") {
		Quit:(aHospID'[(","_AdmHosp_",")) return  //检查院区是否符合
    }*/
    if aHospID'="" {
		set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
		Quit:flg<1 return
	}
	
	If aQryStatus=1 {
		Quit:(StatusCode="0")||(StatusCode="3") return  //作废、关闭过滤  //关闭状态是3
	} ElseIf aQryStatus=2 {
		Quit:StatusCode="0" return  //作废过滤
		Quit:objSpe.PSIsCheck=0 return
	} ElseIf aQryStatus=3 {
		Quit:(StatusCode="0")||(StatusCode="3") return //作废、关闭,过滤
	} ElseIf aQryStatus=4 {
		Quit:StatusCode="0" return  //作废过滤
	} Else {
		Quit return
	}
	
	Set StatusDesc=objSpe.PSCurrStatus.Description
	Set DutyUserID=objSpe.PSDutyUser,DutyUserDesc=""
	Set:DutyUserID'="" DutyUserDesc=$p($g(^SSU("SSUSR",DutyUserID)),"^",2)
	Set DutyDeptID=objSpe.PSDutyDept,DutyDeptDesc=""
	Quit:(aLocID'="")&(aLocID'=DutyDeptID) return
	Set:DutyDeptID'="" DutyDeptDesc=$p($g(^CTLOC(DutyDeptID)),"^",2)
	set:$p(DutyDeptDesc,"-",2)'="" DutyDeptDesc=$p(DutyDeptDesc,"-",2)
	Set MarkDate=objSpe.PSMarkDate
	;Set:MarkDate'="" MarkDate=$zd(MarkDate,3)
	Set:MarkDate'="" MarkDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(MarkDate)
	Set MarkTime=objSpe.PSMarkTime
	Set:MarkTime'="" MarkTime=$zt(MarkTime,2)
	Set Note=objSpe.PSNote
	Set Opinion=objSpe.PSOpinion
	Set CheckDate=objSpe.PSCheckDate
	;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=objSpe.PSCheckTime
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckOpinion=objSpe.PSCheckOpinion
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objAdm) return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	Set RegNo=objPatient.PapmiNo
	Quit:(aRegNo'="")&(RegNo'=aRegNo) return  //按登记号查询
	Set PatName=objPatient.PatientName
	Quit:(aPatName'="")&(PatName'=aPatName) return   //按姓名查询
	Set Sex=objPatient.Sex
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	//统一调用年龄计算方法
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set LocID=objAdm.DepartmentID
	Set LocDesc=objAdm.Department
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Set WardID=objAdm.WardID
	Set WardDesc=objAdm.Ward
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	Set Bed=objAdm.Bed
	Set DoctorID=objAdm.DoctorID
	Set DoctorName=objAdm.DoctorName
	
    Set IsNewsFlag=0
    Set xLogSub=0
    For {
	    Set xLogSub=$o(^DHCMed.SPE("Pat",aSpeID,"Log",xLogSub))
	    Quit:xLogSub=""
		
	    Set SpeLogID=aSpeID_"||"_xLogSub
	    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
	    Continue:'$IsObject(objLog)
	    Continue:objLog.PSLIsActive'=1  //无效
	    Continue:'$IsObject(objLog.PSLStatus)
	    Continue:objLog.PSLStatus.Code'=9  //状态不符
	    
	    Set IsNewsFlag=1
	    
	    If aOperTpCode=1 {
		    Continue:objLog.PSLNewsType'=2  //临床查看管理科消息
	    } Else {
		    Continue:objLog.PSLNewsType'=1  //管理科查看临床消息
		}
	    Continue:objLog.PSLIsRead=1    //已读
	    
	    Set IsNewsFlag=2
	    Quit
	}
	Set ReadStatus=$s(IsNewsFlag=2:"未读消息",IsNewsFlag=1:"消息列表",1:"发送消息")
	
	Set Data=$lb(aSpeID)
	Set Data=Data_$lb(PatTypeID)
	Set Data=Data_$lb(PatTypeDesc)
	Set Data=Data_$lb(StatusCode)
	Set Data=Data_$lb(StatusDesc)
	Set Data=Data_$lb(DutyUserID)
	Set Data=Data_$lb(DutyUserDesc)
	Set Data=Data_$lb(DutyDeptID)
	Set Data=Data_$lb(DutyDeptDesc)
	Set Data=Data_$lb(MarkDate)
	Set Data=Data_$lb(MarkTime)
	Set Data=Data_$lb(Note)
	Set Data=Data_$lb(Opinion)
	Set Data=Data_$lb(CheckDate)
	Set Data=Data_$lb(CheckTime)
	Set Data=Data_$lb(CheckOpinion)
	Set Data=Data_$lb(ReadStatus)
	Set Data=Data_$lb(EpisodeID)
	Set Data=Data_$lb(PatientID)
	Set Data=Data_$lb(RegNo)
	Set Data=Data_$lb(PatName)
	Set Data=Data_$lb(Sex)
	Set Data=Data_$lb(PatientAge)
	Set Data=Data_$lb(AdmDate)
	Set Data=Data_$lb(AdmTime)
	Set Data=Data_$lb(LocID)
	Set Data=Data_$lb(LocDesc)
	Set Data=Data_$lb(WardID)
	Set Data=Data_$lb(WardDesc)
	Set Data=Data_$lb(Bed)
	Set Data=Data_$lb(DoctorID)
	Set Data=Data_$lb(DoctorName)
	Quit Data
}

/// Creator：     chengpeng
/// CreatDate：   2014-08-28
/// Description:  根据标记ID（DHCMed.SPE.Patients.ID）取消息记录
/// Table：       DHCMed.SPE.PatientsLog , DHCMed.SPE.Patients
/// Input：       SpePatientsID     ：特殊患者记录ID(DHCMed.SPE.Patients_Initials)
/// Return：      消息记录
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QryNewsBySpeID","2")
Query QryNewsBySpeID(aSpeID As %String) As %Query(ROWSPEC = "SpeLogID:%String,NewsType:%String,NewsTypeDesc:%String,Opinion:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String,IsRead:%String,ReadStatus:%String,ReadDate:%String,ReadTime:%String,ReadUserID:%String,ReadUserDesc:%String")
{
}

ClassMethod QryNewsBySpeIDExecute(ByRef qHandle As %Binary, aSpeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
	
	Quit:aSpeID="" $$$OK
	Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(aSpeID)
	Quit:'$IsObject(objSpe) $$$OK
	Quit:'$IsObject(objSpe.PSPatTypeDr) $$$OK
	Quit:'$IsObject(objSpe.PSCurrStatus) $$$OK
	Set StatusCode=objSpe.PSCurrStatus.Code
	
	Set xLogSub=0
	For {
		Set xLogSub=$o(^DHCMed.SPE("Pat",aSpeID,"Log",xLogSub))
		Quit:xLogSub=""
		
		Set SpeLogID=aSpeID_"||"_xLogSub
		Set objSpeLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
		Continue:'$IsObject(objSpeLog)
		Continue:objSpeLog.PSLIsActive'=1
		
		Set NewsType=objSpeLog.PSLNewsType
		Continue:NewsType=0  //操作记录不显示
		Set NewsTypeDesc=$s(NewsType=1:"临床消息",NewsType=2:"管理科消息",1:"其它")
		Set Opinion=objSpeLog.PSLOpinion
		Set ActDate=objSpeLog.PSLActDate
		;Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set ActTime=objSpeLog.PSLActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserID=objSpeLog.PSLActUser,ActUserDesc=""
		Set:ActUserID'="" ActUserDesc=$p(^SSU("SSUSR",ActUserID),"^",2)
		Set IsRead=objSpeLog.PSLIsRead
		Set ReadStatus=$s(IsRead=0:"未读",IsRead=1:"已读",1:"")
		Set ReadDate=objSpeLog.PSLReadDate
		;Set:ReadDate'="" ReadDate=$zd(ReadDate,3)
		Set:ReadDate'="" ReadDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReadDate)
		Set ReadTime=objSpeLog.PSLReadTime
		Set:ReadTime'="" ReadTime=$zt(ReadTime,1)
		Set ReadUserID=objSpeLog.PSLReadUser,ReadUserDesc=""
		Set:ReadUserID'="" ReadUserDesc=$p(^SSU("SSUSR",ReadUserID),"^",2)
		
		Set Data=$lb(SpeLogID)
		Set Data=Data_$lb(NewsType)
		Set Data=Data_$lb(NewsTypeDesc)
		Set Data=Data_$lb(Opinion)
		Set Data=Data_$lb(ActDate)
		Set Data=Data_$lb(ActTime)
		Set Data=Data_$lb(ActUserID)
		Set Data=Data_$lb(ActUserDesc)
		Set Data=Data_$lb(IsRead)
		Set Data=Data_$lb(ReadStatus)
		Set Data=Data_$lb(ReadDate)
		Set Data=Data_$lb(ReadTime)
		Set Data=Data_$lb(ReadUserID)
		Set Data=Data_$lb(ReadUserDesc)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
    Quit $$$OK
}

ClassMethod QryNewsBySpeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNewsBySpeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNewsBySpeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNewsBySpeIDExecute ]
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

/// creator : zhufei
/// 查询特殊患者列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QrySpeListByAdm","189")
Query QrySpeListByAdm(aEpisodeID As %String, aOperTpCode As %String) As %Query(ROWSPEC = "RowID:%String,PatTypeID:%String,PatTypeDesc:%String,StatusCode:%String,StatusDesc:%String,MarkDate:%String,MarkTime:%String,Note:%String,CheckDate:%String,CheckTime:%String,CheckOpinion:%String,ReadStatus:%String,EpisodeID:%String,PatientID:%String,RegNo:%String,PatName:%String,Sex:%String,PatientAge:%String,EncryptLevel:%String,PatLevel:%String,MarkUser:%String,CheckUser:%String,PrognosisID:%String,PrognosisDesc:%String")
{
}

ClassMethod QrySpeListByAdmExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aOperTpCode As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
	//Set ^ZF=aEpisodeID
	Quit:(aEpisodeID="")||(aOperTpCode="") $$$OK
	
	Set xPatTypeID=0
	For {
		Set xPatTypeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID))
		Quit:xPatTypeID=""
		
		Set xSpeID=0
		For {
			Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID,xSpeID))
			Quit:xSpeID=""
			
			Set SpeID=xSpeID
		    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(SpeID)
		    Continue:'$IsObject(objSpe)
		    Continue:'$IsObject(objSpe.PSPatTypeDr)
		    Continue:'$IsObject(objSpe.PSCurrStatus)
			Set EpisodeID=objSpe.PSEpisodeID
			Set PatTypeID=objSpe.PSPatTypeDr.%Id()
			Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
			Set StatusCode=objSpe.PSCurrStatus.Code
			Set StatusDesc=objSpe.PSCurrStatus.Description
			Continue:StatusCode="0"  //作废过滤
			
			Set MarkDate=objSpe.PSMarkDate
			;Set:MarkDate'="" MarkDate=$zd(MarkDate,3)
			Set:MarkDate'="" MarkDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(MarkDate)
			Set MarkTime=objSpe.PSMarkTime
			Set:MarkTime'="" MarkTime=$zt(MarkTime,2)
			Set Note=objSpe.PSNote
			Set CheckDate=objSpe.PSCheckDate
			;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
			Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
			Set CheckTime=objSpe.PSCheckTime
			Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
			Set CheckOpinion=objSpe.PSCheckOpinion
			Set MarkUser=""
			Set MarkUserID=objSpe.PSDutyUser  //标记人即责任人
			Set:MarkUserID'="" MarkUser=$p(^SSU("SSUSR",MarkUserID),"^",2)
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objAdm)
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			Set RegNo=objPatient.PapmiNo
			Set PatName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//统一调用年龄计算方法
			//upadte by pylian 2016-02-18 修改入院时间取值方式
   			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
			;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
			
			Set (EncryptLevel,PatLevel)=""
			Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
			Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
			Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
			
		    Set IsNewsFlag=0
		    Set xLogSub=0
		    For {
			    Set xLogSub=$o(^DHCMed.SPE("Pat",xSpeID,"Log",xLogSub))
			    Quit:xLogSub=""
    			
			    Set SpeLogID=xSpeID_"||"_xLogSub
			    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
			    Continue:'$IsObject(objLog)
			    Continue:objLog.PSLIsActive'=1  //无效
			    Continue:'$IsObject(objLog.PSLStatus)
			    Continue:objLog.PSLStatus.Code'=9  //状态不符
			    
			    Set IsNewsFlag=1
			    
			    If aOperTpCode=1 {
				    Continue:objLog.PSLNewsType'=2  //临床查看管理科消息
			    } Else {
				    Continue:objLog.PSLNewsType'=1  //管理科查看临床消息
				}
			    Continue:objLog.PSLIsRead=1    //已读
			    
			    Set IsNewsFlag=2
			    Quit
			}
			Set ReadStatus=$s(IsNewsFlag=2:"未读消息",IsNewsFlag=1:"消息列表",1:"发送消息")
			Set PrognosisID="",PrognosisDesc=""
			If $IsObject(objSpe.PSPrognosis){
				Set PrognosisID=objSpe.PSPrognosis.%Id()
				Set PrognosisDesc=objSpe.PSPrognosis.Description
			}
			/*  //撤销审核再关闭时审核人仍存在?
			Set CheckUserID="", CheckUser=""
			Set aLogSub=0
		    For {
			    Set aLogSub=$o(^DHCMed.SPE("Pat",xSpeID,"Log",aLogSub))
			    Quit:aLogSub=""
    			
			    Set SpeLogID=xSpeID_"||"_aLogSub
			    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
			    Continue:'$IsObject(objLog)
			    Continue:objLog.PSLIsActive'=1  //无效
			    Continue:'$IsObject(objLog.PSLStatus)
			    Continue:objLog.PSLStatus.Code'=2 
			    Set CheckUserID=objLog.PSLUpdateUser  //只取最后一次审核
			  
		    }
	        Set:(StatusCode=2)&&(CheckUserID'="") CheckUser=$p(^SSU("SSUSR",CheckUserID),"^",2)  //撤销审核后的标记状态的审核人不应存在
		    Set:(StatusCode=3)&&(CheckUserID'="") CheckUser=$p(^SSU("SSUSR",CheckUserID),"^",2)
		  	*/
			Set Data=$lb(SpeID)
			Set Data=Data_$lb(PatTypeID)
			Set Data=Data_$lb(PatTypeDesc)
			Set Data=Data_$lb(StatusCode)
			Set Data=Data_$lb(StatusDesc)
			Set Data=Data_$lb(MarkDate)
			Set Data=Data_$lb(MarkTime)
			Set Data=Data_$lb(Note)
			Set Data=Data_$lb(CheckDate)
			Set Data=Data_$lb(CheckTime)
			Set Data=Data_$lb(CheckOpinion)
			Set Data=Data_$lb(ReadStatus)
			Set Data=Data_$lb(EpisodeID)
			Set Data=Data_$lb(PatientID)
			Set Data=Data_$lb(RegNo)
			Set Data=Data_$lb(PatName)
			Set Data=Data_$lb(Sex)
			Set Data=Data_$lb(PatientAge)
			Set Data=Data_$lb(EncryptLevel)
			Set Data=Data_$lb(PatLevel)
			Set Data=Data_$lb(MarkUser)
			Set Data=Data_$lb(CheckUser)
			Set Data=Data_$lb(PrognosisID)
			Set Data=Data_$lb(PrognosisDesc)
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
    Quit $$$OK
}

ClassMethod QrySpeListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpeListByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpeListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpeListByAdmExecute ]
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

/// creator : pylian
/// CreatDate：   2015-11-10
/// 查询某段时间内特殊患者明细列表
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QrySpeList","2015-11-01","2015-11-12","","8991,8992,8993,8995","","")
Query QrySpeList(aDateFrom As %String, aDateTo As %String, aPatType As %String, aStatusList As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "SpeID:%String,PatTypeID:%String,PatTypeDesc:%String,StatusCode:%String,StatusDesc:%String,DutyUserID:%String,DutyUserDesc:%String,DutyDeptID:%String,DutyDeptDesc:%String,MarkDate:%String,MarkTime:%String,Note:%String,Opinion:%String,CheckDate:%String,CheckTime:%String,CheckOpinion:%String,ReadStatus:%String,EpisodeID:%String,PatientID:%String,RegNo:%String,PatName:%String,Sex:%String,PatientAge:%String,AdmDate:%String,AdmTime:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,Bed:%String,DoctorID:%String,DoctorName:%String")
{
}

ClassMethod QrySpeListExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aPatType As %String, aStatusList As %String, aLocID As %String, aHospID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    	
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	

	//Set:aHospID'="" aHospID=","_aHospID_","
	Set xDate=aDateFrom-1
	For {
		 Set xDate=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate))
		 Quit:xDate=""
		 Quit:xDate>aDateTo
		    
		    Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate,xTime))
				Quit:xTime=""
				
			    Set xID=0
			    For {
				    Set xID=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate,xTime,xID))
				    Quit:xID=""
			    	
			    	Set Data=..BuildSpeListData(xID,aPatType,aStatusList,aLocID,aHospID)
			    	Continue:Data=""
			    	Set ^CacheTemp(repid,ind)=Data
			    	Set ind=ind+1
				}
			}
	
	}
	
    Quit $$$OK
}

ClassMethod QrySpeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySpeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpeListExecute ]
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

ClassMethod BuildSpeListData(aSpeID As %String, aPatType As %String, aStatusList As %String, aLocID As %String, aHospID As %String) As %String
{
	New (aSpeID,aPatType,aStatusList,aLocID,aHospID)
	Set return=""
	Quit:aSpeID="" return
	
    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(aSpeID)
    Quit:'$IsObject(objSpe) return
    Quit:'$IsObject(objSpe.PSPatTypeDr) return
    Quit:'$IsObject(objSpe.PSCurrStatus) return
	Set EpisodeID=objSpe.PSEpisodeID
	Set PatTypeID=objSpe.PSPatTypeDr.%Id()
	Quit:(aPatType'="")&(aPatType'=PatTypeID) return
	Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
	
	
	Set AdmInfo=$g(^PAADM(EpisodeID))
	Quit:$p(AdmInfo,"^",2)'="I" return      //就诊类型过滤
	Quit:$p(AdmInfo,"^",20)="C" return      //就诊状态过滤
	Set AdmLoc=$p(AdmInfo,"^",4)
	Quit:AdmLoc="" return
	/*Set AdmHosp=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
    If (AdmHosp'="")&&(aHospID'="") {
		Quit:(aHospID'[(","_AdmHosp_",")) return  //检查院区是否符合
    }*/
    if aHospID'="" {
		set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
		Quit:flg<1 return
	}
	
	Set StatusID=objSpe.PSCurrStatus.%Id()
	Set StatusCode=objSpe.PSCurrStatus.Code
	Set StatusDesc=objSpe.PSCurrStatus.Description
	If (StatusCode'="")&&(aStatusList'="") {
		Quit:(aStatusList'[StatusCode) return  //检查状态是否符合
    }
	Set DutyUserID=objSpe.PSDutyUser,DutyUserDesc=""
	Set:DutyUserID'="" DutyUserDesc=$p($g(^SSU("SSUSR",DutyUserID)),"^",2)
	Set DutyDeptID=objSpe.PSDutyDept,DutyDeptDesc=""
	Quit:(aLocID'="")&(aLocID'=DutyDeptID) return   //特殊患者的责任科室和责任人一直，标记人即责任人
	Set:DutyDeptID'="" DutyDeptDesc=$p($g(^CTLOC(DutyDeptID)),"^",2)
	set:$p(DutyDeptDesc,"-",2)'="" DutyDeptDesc=$p(DutyDeptDesc,"-",2)
	Set MarkDate=objSpe.PSMarkDate
	;Set:MarkDate'="" MarkDate=$zd(MarkDate,3)
	Set:MarkDate'="" MarkDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(MarkDate)
	Set MarkTime=objSpe.PSMarkTime
	Set:MarkTime'="" MarkTime=$zt(MarkTime,2)
	Set Note=objSpe.PSNote
	Set Opinion=objSpe.PSOpinion
	Set CheckDate=objSpe.PSCheckDate
	;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=objSpe.PSCheckTime
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckOpinion=objSpe.PSCheckOpinion
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objAdm) return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return	Set RegNo=objPatient.PapmiNo

	Set PatName=objPatient.PatientName
	Set Sex=objPatient.Sex
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	//统一调用年龄计算方法
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set LocID=objAdm.DepartmentID
	Set LocDesc=objAdm.Department
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Set WardID=objAdm.WardID
	Set WardDesc=objAdm.Ward
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	Set Bed=objAdm.Bed
	Set DoctorID=objAdm.DoctorID
	Set DoctorName=objAdm.DoctorName
	
    Set IsNewsFlag=0
    Set xLogSub=0
    For {
	    Set xLogSub=$o(^DHCMed.SPE("Pat",aSpeID,"Log",xLogSub))
	    Quit:xLogSub=""
		
	    Set SpeLogID=aSpeID_"||"_xLogSub
	    Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
	    Continue:'$IsObject(objLog)
	    Continue:objLog.PSLIsActive'=1  //无效
	    Continue:'$IsObject(objLog.PSLStatus)
	    Continue:objLog.PSLStatus.Code'=9  //状态不符
	    
	    Set IsNewsFlag=1
	    Continue:objLog.PSLIsRead=1    //已读
	    
	    Set IsNewsFlag=2
	    Quit
	}
	Set ReadStatus=$s(IsNewsFlag=2:"未读消息",IsNewsFlag=1:"消息列表",1:"发送消息")
	
	Set Data=$lb(aSpeID)
	Set Data=Data_$lb(PatTypeID)
	Set Data=Data_$lb(PatTypeDesc)
	Set Data=Data_$lb(StatusCode)
	Set Data=Data_$lb(StatusDesc)
	Set Data=Data_$lb(DutyUserID)
	Set Data=Data_$lb(DutyUserDesc)
	Set Data=Data_$lb(DutyDeptID)
	Set Data=Data_$lb(DutyDeptDesc)
	Set Data=Data_$lb(MarkDate)
	Set Data=Data_$lb(MarkTime)
	Set Data=Data_$lb(Note)
	Set Data=Data_$lb(Opinion)
	Set Data=Data_$lb(CheckDate)
	Set Data=Data_$lb(CheckTime)
	Set Data=Data_$lb(CheckOpinion)
	Set Data=Data_$lb(ReadStatus)
	Set Data=Data_$lb(EpisodeID)
	Set Data=Data_$lb(PatientID)
	Set Data=Data_$lb(RegNo)
	Set Data=Data_$lb(PatName)
	Set Data=Data_$lb(Sex)
	Set Data=Data_$lb(PatientAge)
	Set Data=Data_$lb(AdmDate)
	Set Data=Data_$lb(AdmTime)
	Set Data=Data_$lb(LocID)
	Set Data=Data_$lb(LocDesc)
	Set Data=Data_$lb(WardID)
	Set Data=Data_$lb(WardDesc)
	Set Data=Data_$lb(Bed)
	Set Data=Data_$lb(DoctorID)
	Set Data=Data_$lb(DoctorName)
	Quit Data
}

/// Creator：     pylian
/// CreatDate：   2015-11-10
/// Description:  统计科室特殊患者数量
/// d ##Class(%ResultSet).RunQuery("DHCMed.SPEService.PatientsQry","QueryStatistic","2015-11-01","2015-11-16","","","","")
Query QueryStatistic(aFromDate As %String, aToDate As %String, aTypeID As %String, aTypeSubID As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "Index:%String,LocDesc:%String:科室,TypeDesc:%String:大类,TypeSubDesc:%String:子类,CountCS:%String:标记次数,CountZS:%String:总人数,CountBJ:%String:标记人数,CountSH:%String:审核人数,CountZF:%String:作废人数,CountGB:%String:关闭人数")
{
}

ClassMethod QueryStatisticExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aTypeID As %String, aTypeSubID As %String, aLocID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Set:aFromDate'="" aFromDate=+aFromDate
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aToDate'="" aToDate=+aToDate
	Quit:(aFromDate="")||(aToDate="") $$$OK
	//Set:aHospID'="" aHospID=","_aHospID_","
	Kill ^TMP("QueryStatistic",$zn,$j)
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		 Set xTime=""
		    For {
				Set xTime=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate,xTime))
				Quit:xTime=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCMed.SPEi("Pat",0,"IndexMarkDate",xDate,xTime,xID))
					Quit:xID=""
			
			
					Set objSpe=##Class(DHCMed.SPE.Patients).GetObjById(xID)
			 		Continue:'$IsObject(objSpe)
		    		Continue:'$IsObject(objSpe.PSPatTypeDr)
		    		Continue:'$IsObject(objSpe.PSCurrStatus)
		    		Set EpisodeID=objSpe.PSEpisodeID
		    		Set AdmInfo=$g(^PAADM(EpisodeID))
					Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
					Set AdmLoc=$p(AdmInfo,"^",4)
					Continue:(AdmLoc="")
					/*Set AdmHosp=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
    				If (AdmHosp'="")&&(aHospID'="") {
					Continue:(aHospID'[(","_AdmHosp_","))  //检查院区是否符合
    				}*/
    				if aHospID'="" {
						set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
						Continue:flg<1
					}
					
				    Set DutyLoc=objSpe.PSDutyDept
			   		Continue:DutyLoc=""
					Continue:(aLocID'="")&&(aLocID'=DutyLoc)  //检查责任科室是否符合
				
				    Set Status=objSpe.PSCurrStatus.%Id()
					Set StatusCode=objSpe.PSCurrStatus.Code
					Set StatusDesc=objSpe.PSCurrStatus.Description
			
			   		Set PrognosisCode=objSpe.PSPrognosis.Code
			   		Set PrognosisDesc=objSpe.PSPrognosis.Description
  		
			   		Set PatTypeID=objSpe.PSPatTypeDr.%Id()
			   		Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
			   		
					Set objTypeSub=##Class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeID)
			 		Continue:'$IsObject(objTypeSub)
			        Set Type=objTypeSub.ParRef.%Id()
					Continue:(aTypeID'="")&&(aTypeID'=Type)
					Continue:(aTypeSubID'="")&&(aTypeSubID'=PatTypeID)
			
					Set Count=$i(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID))
					//Set:Prognosis'="" Count=$i(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Set:Status'="" Count=$i(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
				
			}
		}
	}
	Set DutyLoc=""
	For {
		Set DutyLoc=$o(^TMP("QueryStatistic",$zn,$j,DutyLoc))
		Quit:DutyLoc=""
		Set DutyLocDesc=$p($g(^CTLOC(+DutyLoc)),"^",2)
		Set:$p(DutyLocDesc,"-",2)'="" DutyLocDesc=$p(DutyLocDesc,"-",2)
		
		Set Type=""
		For {
			Set Type=$o(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type))
			Quit:Type=""
			Set objType=##Class(DHCMed.SPE.PatType).GetObjById(Type)
			Continue:'$IsObject(objType)
			Set TypeDesc=objType.PTDesc
		
			//Set (CountZS1,CountCY1,CountHZ1,CountSW1,CountZK1,CountJZ1)=0
			Set (CountCS1,CountZS1,CountBJ1,CountSH1,CountZF1,CountGB1)=0
			Set PatTypeID=""
			For {
				Set PatTypeID=$o(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID))
				Quit:PatTypeID=""
				Set objTypeSub=##Class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeID)
			 	Continue:'$IsObject(objTypeSub)
			   	Set PatTypeDesc=objTypeSub.PTSDesc
			   		
				Set (CountCS,CountBJ,CountSH,CountZF,CountGB)=0
				Set CountCS=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID))
				//Set (CountZS,CountCY,CountHZ,CountSW,CountZK,CountJZ)=0
				Set Status=""
				For {
					Set Status=$o(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
					Quit:Status=""
					Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(Status)
					Continue:'$IsObject(objStatus) 
					Set StatusCode=objStatus.Code
					
					Set:StatusCode="1" CountBJ=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
					Set:StatusCode="2" CountSH=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
					Set:StatusCode="0" CountZF=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
					Set:StatusCode="3" CountGB=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Status))
				}
				Set CountCS1=CountCS1+CountCS
				Set CountBJ1=CountBJ1+CountBJ
				Set CountSH1=CountSH1+CountSH
				Set CountZF1=CountZF1+CountZF
				Set CountGB1=CountGB1+CountGB
				
				/*
				Set CountZS=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID))
				Set Prognosis=""
				For {
					Set Prognosis=$o(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Quit:Prognosis=""
					Set objPrognosis=##class(DHCMed.SS.Dictionary).GetObjById(Prognosis)
					Continue:'$IsObject(objPrognosis) 
					Set PrognosisDesc=objPrognosis.Description
				
					Set:PrognosisDesc="出院" CountCY=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Set:PrognosisDesc="好转" CountHZ=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Set:PrognosisDesc="死亡" CountSW=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Set:PrognosisDesc="转科" CountZK=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
					Set:PrognosisDesc="加重" CountJZ=+$g(^TMP("QueryStatistic",$zn,$j,DutyLoc,Type,PatTypeID,Prognosis))
				}
				
				Set CountZS1=CountZS1+CountZS
				Set CountCY1=CountCY1+CountCY
				Set CountHZ1=CountHZ1+CountHZ
				Set CountSW1=CountSW1+CountSW
				Set CountZK1=CountZK1+CountZK
				Set CountJZ1=CountJZ1+CountJZ
				
				Set Data=$lb(ind,DutyLocDesc,TypeDesc,PatTypeDesc,CountZS,CountCY,CountHZ,CountSW,CountJZ,CountZK)
				*/
				Set Data=$lb(ind,DutyLocDesc,TypeDesc,PatTypeDesc,CountCS,CountZS,CountBJ,CountSH,CountZF,CountGB)
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			
			}
			
			Set Data=$lb(ind,DutyLocDesc,TypeDesc,"合计",CountCS1,CountZS1,CountBJ1,CountSH1,CountZF1,CountGB1)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP("QueryStatistic",$zn,$j)
	
	Quit $$$OK
}

ClassMethod QueryStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatisticExecute ]
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
