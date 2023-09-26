/// 名称:DHCMed.NINFService.CSS.Service
/// 描述:横断面相关业务
/// 编写者：zhufei
/// 编写日期: 2013-12-24
Class DHCMed.NINFService.CSS.Service Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mxp
/// CreatDate：   2013-12-03
/// Description:  查询所有横断面调查执行记录
/// Table：       DHCMed.NINF.CSS.SurveyExec
/// Input：       
/// output:       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.Service","QrySurvExec","2,3")
Query QrySurvExec(aHospitalID As %String, aSurvMethod As %String = "", aFromDate As %String = "", aToDate As %String = "") As %Query(ROWSPEC = "Ind:%String,RowID:%String,SESurvNumber:%String,SEHospCode:%String,SEHospDR:%String,SEHospDesc:%String,SESurvMethodDR:%String,SESurvMethod:%String,SESurvSttDate:%String,SESurvEndDate:%String,SEUpdateDate:%String,SEUpdateTime:%String,SEUpdateUser:%String,SEUserCode:%String,SEUserName:%String,SEResume:%String")
{
}

ClassMethod QrySurvExecExecute(ByRef qHandle As %Binary, aHospitalID As %String, aSurvMethod As %String = "", aFromDate As %String = "", aToDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aHospitalID="" $$$OK
    
    Set:aFromDate'="" aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set:aToDate'="" aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
    
	Set xId=""
	For {
		Set xId=$o(^DHCMed.NINF.CSS("SE",xId))
	    Quit:xId=""
	    
	    Set obj=##class(DHCMed.NINF.CSS.SurveyExec).GetObjById(xId)
	    Continue:'$IsObject(obj)
	    
	    Set SurvNumber=obj.SESurvNumber
	    Set HospitalID=obj.SEHospCode
	    
	    Set HospCode=$p($g(^CT("HOSP",+HospitalID)),"^",1)
	    Set HospDesc=$p($g(^CT("HOSP",+HospitalID)),"^",2)
	    Continue:(","_aHospitalID_",")'[(","_HospitalID_",")
	    
	    Set SurvMethod=obj.SESurvMethod
	    Continue:(aSurvMethod'="")&&(SurvMethod'=aSurvMethod)
	    Set SurvMthDesc=$s(SurvMethod=1:"全院统一开展",SurvMethod=2:"分科依次开展",1:"")
	    Set SttDate=obj.SESurvSttDate
	    Continue:(aFromDate'="")&&(SttDate<aFromDate)
	    ;Set:SttDate'="" SttDate=$zd(SttDate,3)
	    Set:SttDate'="" SttDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SttDate)
	    Set EndDate=obj.SESurvEndDate
	    Continue:(aToDate'="")&&(EndDate>aToDate)
	    ;Set:EndDate'="" EndDate=$zd(EndDate,3)
	    Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)
	    Set UpdateDate=obj.SEUpdateDate
	    ;Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	    Set:UpdateDate'="" UpdateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(UpdateDate)
	    Set UpdateTime=obj.SEUpdateTime
	    Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,2)
	    Set UpdateUser=obj.SEUpdateUser
	    Set UserCode="",UserName=""
	    If UpdateUser'="" {
		    Set objUser=##class(DHCMed.Base.SSUser).GetObjById(UpdateUser)
		    If $IsObject(objUser) {
		   		Set UserCode=objUser.Code
		   		Set UserName=objUser.Name
		    }
	    }
	    Set Resume=obj.SEResume
    	
	    Set Data=$lb(ind,xId,SurvNumber,HospCode,HospitalID,HospDesc,SurvMethod,SurvMthDesc)
	    Set Data=Data_$lb(SttDate,EndDate,UpdateDate,UpdateTime,UpdateUser,UserCode,UserName,Resume)
	    Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySurvExecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurvExecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QrySurvExecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurvExecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

/// Creator：     mxp
/// CreatDate：   2013-12-03
/// Description:  查询所有床旁调查生成记录
/// Table：       DHCMed.NINF.CSS.BedSurvLog
/// Input：       
/// output:       所有的调查登记表      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.Service","QryBedSurvLog","201312240001")
Query QryBedSurvLog(aSurvNumber As %String) As %Query(ROWSPEC = "RowID:%String,SurvNumber:%String,SurvLoc:%String,SurvLocDesc:%String,SurvDate:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,UpdateUserName:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryBedSurvLogExecute(ByRef qHandle As %Binary, aSurvNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    Quit:aSurvNumber="" $$$OK
    
	Set xID=""
	For {
		Set xID=$o(^DHCMed.NINF.CSSi("BSL","IndexSurvNumber",aSurvNumber,xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.NINF.CSS.BedSurvLog).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set SurvNumber=obj.BSLSurvNumber
		Set SurvLocID=obj.BSLSurvLoc
		Set SurvLocDesc=$p($g(^CTLOC(+SurvLocID)),"^",2)
		Set:SurvLocDesc="" SurvLocDesc="全院"
		Set:$p(SurvLocDesc,"-",2)'="" SurvLocDesc=$p(SurvLocDesc,"-",2)
		Set SurvDate=obj.BSLSurvDate
		;Set:SurvDate'="" SurvDate=$zd(SurvDate,3)
		Set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SurvDate)
		Set UpdateDate=obj.BSLUpdateDate
		;Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
		Set:UpdateDate'="" UpdateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(UpdateDate)
		Set UpdateTime=obj.BSLUpdateTime
		Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,2)
		Set UpdateUser=obj.BSLUpdateUser
		Set UserCode="",UserName=""
	    If UpdateUser'="" {
		    Set objUser=##class(DHCMed.Base.SSUser).GetObjById(UpdateUser)
		    If $IsObject(objUser) {
		   		Set UserCode=objUser.Code
		   		Set UserName=objUser.Name
		    }
	    }
	    Set IsActive=obj.BSLIsActive
	    Set IsActive=$s(IsActive=1:"是",1:"否")
	    Set Resume=obj.BSLResume
		
	    Set Data=$lb(xID,SurvNumber,SurvLocID,SurvLocDesc,SurvDate,UpdateDate,UpdateTime,UpdateUser,UserName,IsActive,Resume)
	    Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
    }
    
	Quit $$$OK
}

ClassMethod QryBedSurvLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBedSurvLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryBedSurvLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBedSurvLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

/// Creator：     mxp
/// CreatDate：   2013-12-03
/// Description:  查询所有调查登记表
/// Table：       DHCMed.NINF.CSS.BedSurvRec
/// Input：       aSurvNum 调查编号 ; aLoc 科室
/// output:       所有的调查登记表
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.Service","QryBedSurvRec","201312040001","1")
Query QryBedSurvRec(aSurvNumber As %String, aSurvLoc As %String) As %Query(ROWSPEC = "RowID:%String,SurvNumber:%String,SurvDate:%String,SurvDept:%String,SurvDeptDesc:%String,SurvWard:%String,SurvWardDesc:%String,LinkReport:%String,InfType:%String,InfPos:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,IPMrNo:%String,PatSex:%String,PatAge:%String")
{
}

ClassMethod QryBedSurvRecExecute(ByRef qHandle As %Binary, aSurvNumber As %String, aSurvLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
	Set xPaadm=""
	For {
		Set xPaadm=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm))
		Quit:xPaadm=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm,xID))
		    Quit:xID=""
			
		    Set obj=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(xID)
		    Continue:'$IsObject(obj)
		    Set IsActive=obj.BSCIsActive
			Continue:IsActive'=1
			
		    Set SurvNumber=obj.BSCSurvNumber
		    Set SurvDate=obj.BSCSurvDate
			;Set:SurvDate'="" SurvDate=$zd(SurvDate,3)
			Set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SurvDate)
		    Set SurvDept=obj.BSCSurvDept
		    Set SurvWard=obj.BSCSurvWard
		    If aSurvLoc'="" {
				Set LocType=$p($g(^CTLOC(aSurvLoc)),"^",13)
				Continue:(LocType="E")&&(SurvDept'=aSurvLoc)
				Continue:(LocType="W")&&(SurvWard'=aSurvLoc)
			}
		    Set SurvDeptDesc=$p($g(^CTLOC(+SurvDept)),"^",2)
		    Set:$p(SurvDeptDesc,"-",2)'="" SurvDeptDesc=$p(SurvDeptDesc,"-",2)
		    Set SurvWardDesc=$p($g(^CTLOC(+SurvWard)),"^",2)
		    Set:$p(SurvWardDesc,"-",2)'="" SurvWardDesc=$p(SurvWardDesc,"-",2)
			Set EpisodeID=obj.BSCEpisodeID
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Set LinkReport=obj.BSCLinkReport
			//fix bug 112130 by pylian 20150625 导出床旁登记表-导出的报告编号显示不正确
			Set:LinkReport'="" LinkReport=SurvNumber_"-"_LinkReport
			Set Resume=obj.BSCResume
			Set InfType=obj.BSCInfType
			//Set InfType=$s(InfType=1:"医院感染",InfType=2:"社区感染",1:"")
			Set InfPos=obj.BSCInfPos
			
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			Set PapmiNo=objPatient.PapmiNo
			Set PatName=objPatient.PatientName
			Set IPMrNo=objPatient.InPatientMrNo
		    Set PatSex=objPatient.Sex
		   	 //修改年龄问题
		   	Set PatAge=""
		   	//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,2)	
			Set ageData=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"",AdmDate,AdmTime)	//返回值为“*岁*月*天”
			Set AgeYear=0,AgeMonth=0,AgeDay=0
			if ageData["岁" {
				set AgeYear=+ageData
			} else {
				if ageData["月" {
					set AgeMonth=+ageData
					set AgeDay=+$p(ageData,"月",2)
				}elseif ageData["天"{
					set AgeDay=+ageData
				}else{
					set AgeDay=1
				}
			}
			 
			Set AgeY        = AgeYear
			Set AgeM        = AgeMonth
			Set AgeD        = AgeDay
			
			set:(AgeY<1)&&(AgeM<1)&&(AgeD<1) AgeD=1
			If AgeY>1 {
				Set PatAge=AgeY_"岁"
			} ElseIf AgeM>1 {
				Set PatAge=AgeM_"月"
			}Else {
				Set PatAge=AgeD_"天"
			}
			
			Set objPaadm=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPaadm)
			
			Set Data=$lb(xID,SurvNumber,SurvDate,SurvDept,SurvDeptDesc,SurvWard,SurvWardDesc,LinkReport,InfType,InfPos)
			Set Data=Data_$lb(EpisodeID,PatientID,PapmiNo,PatName,IPMrNo,PatSex,PatAge)
		    Set ^CacheTemp(repid,ind)=Data
		    Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryBedSurvRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBedSurvRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryBedSurvRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBedSurvRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

/// 批处理调查床旁调查生成日志
/// w ##class(DHCMed.NINFService.CSS.Service).BuildBedSurvLog("201405060001","2014-05-06","",2040)
ClassMethod BuildBedSurvLog(aSurvNumber As %String, aSurvDate As %String, aSurvLoc As %String, aUserID As %String)
{
	new (aSurvNumber,aSurvDate,aSurvLoc,aUserID)
	set return="0^参数错误！"
	quit:(aSurvNumber="")||(aSurvDate="") return
	
	set return="-1^无对应调查执行登记记录！"
	set objSurvExec=##class(DHCMed.NINF.CSS.SurveyExec).GetObjBySurvNumber(aSurvNumber)
	quit:'$IsObject(objSurvExec) return
	set SurvMethod=objSurvExec.SESurvMethod
	
	Set SEResume=objSurvExec.SEResume //add by zhoubo 2014-12-24 fixbug
	
	set return="-2^分科调查无对应科室参数！"
	quit:(SurvMethod="2")&&(aSurvLoc="") return
	
	set return="-3^已经生成床旁调查患者就诊记录！"
	set xID=0,SurvLogID=""
	for {
		set xID=$o(^DHCMed.NINF.CSSi("BSL","IndexSurvNumber",aSurvNumber,xID))
		quit:xID=""
		quit:SurvLogID'=""
		
		set objSurvLog=##class(DHCMed.NINF.CSS.BedSurvLog).GetObjById(xID)
		continue:'$IsObject(objSurvLog)
		set IsActive=objSurvLog.BSLIsActive
		continue:IsActive'=1
		set SurvLoc=objSurvLog.BSLSurvLoc
		continue:(aSurvLoc'="")&&(SurvLoc'=aSurvLoc)
		set SurvLogID=xID
	}
	quit:SurvLogID'="" return
	
	set return="-4^生成床旁调查日志记录失败"
	set strInput=""_"^"_aSurvNumber_"^"_aSurvLoc_"^"_aSurvDate_"^"_""_"^"_""_"^"_aUserID_"^"_1_"^"_SEResume
	set flg=##Class(DHCMed.NINF.CSS.BedSurvLog).Update(strInput)
	quit:(+flg)<1 return
	
	set return="-5^生成床旁调查病人列表失败"
	set flg=..BuildBedSurvPatList(aSurvNumber,aSurvDate,aSurvLoc)
	quit:(+flg)<0 return
	
	set return=1
	quit return
}

/// 构建横断面床旁调查记录
/// Input:  aSurvNumber	调查编号
/// 	    aSurvDate	调查日期
/// 	    argLocID	科室
/// Output: count	需要调查的人数
/// w ##class(DHCMed.NINFService.CSS.Service).BuildBedSurvPatList("201312240004","2013-12-24","")
ClassMethod BuildBedSurvPatList(aSurvNumber As %String, aSurvDate As %String, aSurvLoc As %String)
{
	new (aSurvNumber,aSurvDate,aSurvLoc)
	set return=-1
	quit:(aSurvNumber="")||(aSurvDate="") return
	
	;set:aSurvDate["-" aSurvDate=$zdh(aSurvDate,3)
	set:aSurvDate'="" aSurvDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aSurvDate)
	set aSurvDate=+aSurvDate
	quit:aSurvDate>+$h return
	
	set IsHospitalGroup=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SSIsHospitalGroup","")
	
	set SurveyID=$o(^DHCMed.NINF.CSSi("SE","SurvNumber"," "_aSurvNumber,0))
	quit:SurveyID="" return
	set objExec=##class(DHCMed.NINF.CSS.SurveyExec).GetObjById(SurveyID)
	quit:'$IsObject(objExec) return
	set aHospitalID=objExec.SEHospCode
	set StartDate=objExec.SESurvSttDate
	set SurvMethod=objExec.SESurvMethod
	quit:(SurvMethod=2)&&(aSurvLoc="") return
	quit:aSurvDate<StartDate return
	
	set CSSIsCheckDayCareWard=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CSSIsCheckDayCareWard","")
	Set CSSIsCheckDayCareWard=+CSSIsCheckDayCareWard
	
	Set count=0
	//在院患者列表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Continue:$p($g(^PAADM(+xPaadm)),"^",75)'="" //婴儿不做现患率调查
				
				set AdmInfo=$g(^PAADM(xPaadm))
				continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				set AdmLoc=$p(AdmInfo,"^",4)
				set AdmWard=$p(AdmInfo,"^",70)
				set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
				if CSSIsCheckDayCareWard=1 {
					//日间病房不在横断面统计范围内
					set WardDesc=$p($g(^CTLOC(AdmWard)),"^",2)
					continue:WardDesc["日间病房"
				}
				if aSurvLoc'="" {
					set LocType=$p($g(^CTLOC(aSurvLoc)),"^",13)
					continue:(LocType="E")&&(AdmLoc'=aSurvLoc)
					continue:(LocType="W")&&(AdmWard'=aSurvLoc)
				}
				If IsHospitalGroup'=0 {
					set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
					continue:HospitalID'=aHospitalID  //医院过滤
				}
				//set AdmDate=$p(AdmInfo,"^",6)
				//upadte by pylian 2016-02-18 修改入院时间取值方式
    			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xPaadm)
				Set AdmDate=$p(AdmDateTime,"^",1)
				continue:AdmDate>=aSurvDate //过滤调查日当天就诊
				//set DischDate=$p(AdmInfo,"^",17)
				//Update by pylian 2016-01-21 修改出院时间取值方式
				Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
				Set DischDate=$p(DischDateTime,"^",1)
				continue:(DischDate'="")&&(DischDate<aSurvDate)  //过滤调查日前一天已出院
				
				set count=count+1
				continue:$d(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm))
				
				set strInput="^"_aSurvNumber_"^"_AdmLoc_"^"_AdmWard_"^"_aSurvDate_"^"_xPaadm_"^^^^1^"
				
				set flg=##Class(DHCMed.NINF.CSS.BedSurvRec).Update(strInput)
			}
		}
	}
	
	//出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引							
	For xDate=aSurvDate:1:CurrDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			
			Continue:$p($g(^PAADM(+xPaadm)),"^",75)'="" //婴儿不做现患率调查
			
			set AdmInfo=$g(^PAADM(xPaadm))
			continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			set AdmLoc=$p(AdmInfo,"^",4)
			set AdmWard=$p(AdmInfo,"^",70)
			set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
			if aSurvLoc'="" {
				set LocType=$p($g(^CTLOC(aSurvLoc)),"^",13)
				continue:(LocType="E")&&(AdmLoc'=aSurvLoc)
				continue:(LocType="W")&&(AdmWard'=aSurvLoc)
			}
			set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			continue:(aHospitalID'="")&&(HospitalID'=aHospitalID)  //医院过滤
			//set AdmDate=$p(AdmInfo,"^",6)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xPaadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			continue:AdmDate>=aSurvDate //过滤调查日当天就诊
			//set DischDate=$p(AdmInfo,"^",17)
			//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
			Set DischDate=$p(DischDateTime,"^",1)
			continue:(DischDate'="")&&(DischDate<aSurvDate)  //过滤调查日前一天已出院
			
			set count=count+1
			continue:$d(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm))
			
			set strInput="^"_aSurvNumber_"^"_AdmLoc_"^"_AdmWard_"^"_aSurvDate_"^"_xPaadm_"^^^^1^"
			
			set flg=##Class(DHCMed.NINF.CSS.BedSurvRec).Update(strInput)
		}
	}
	
	quit count
}

/* update by zf 20140506 涉及自定义表单内容，暂时注掉
ClassMethod GetReportIDByPaadm(Paadm As %String, aFormCode As %String)
{
	n (Paadm,aFormCode)
	s aFormCode=$p(aFormCode,".",3)
	q:Paadm="" ""
	s reportID=""
	for {
		s reportID=$o(^DHCMed.CR.PO.DataI("IndexEpisodeID",Paadm,reportID))
		s objData=##class(DHCMed.CR.PO.Data).GetObjById(+reportID)
		continue:'$IsObject(objData)
		s objForm=##class(DHCMed.CR.PO.Form).GetObjById(+objData.FormVerDR)
		continue:'$IsObject(objForm)
		s formCode=objform.EName
		//$o(^DHCMed.CR.PO.DataD(reportID,""))
		continue:(formCode'="")&&(formCode'=aFormCode)
	}
	q reportID
}

/// 获取横断面登记表中的感染类型和感染部位
/// Input: 报告ID
/// Output: "1*InfPos1||InfPos2||InfPos3"
/// w ##class(DHCMed.NINFService.CSS.Service).getInfPosByReportID(44)
ClassMethod getInfPosByReportID(ReportID As %String)
{
	s return =""
	
	q:ReportID="" ""
	s objData=##class(DHCMed.CR.PO.Data).GetObjById(+ReportID)
	q:'$IsObject(objData) ""
	s FormID=+objData.FormVerDR
	//s objForm=##class(DHCMed.CR.PO.Form).GetObjById(+FormID)
	//s className=objForm.ESchema_"."_objForm.Type_"."_objForm.EName
	//s objReport=##class(className).%OpenId(+ReportID)
	set ClassName=$classmethod("DHCMed.CR.PO.Form","%OpenId",FormID).GetClassName()
	s objReport =$classmethod(ClassName,"%OpenId",+ReportID) // ##Class(%Dictionary.CompiledClass).%OpenId(ClassName,ReportID)
	q:'$IsObject(objReport) ""
	s infType=objReport.InfType
	if (objReport.IsInfection="Y"){ //感染
		if (infType="1"){ //医院感染
			s return = return_"1*"
			s return = return_objReport.HosInfPos1
			s:objReport.HosInfPos2'="" return = return_"||"
			s return = return_objReport.HosInfPos2
			s:objReport.HosInfPos3'="" return = return_"||"
			s return = return_objReport.HosInfPos3
		}
		else{ //社区感染
			s return = return_"2*"
			s return = return_objReport.CommuInfPos1
			s:objReport.CommuInfPos2'="" return = return_"||"
			s return = return_objReport.CommuInfPos2
			s:objReport.CommuInfPos3'="" return = return_"||"
			s return = return_objReport.CommuInfPos3
		}
	}
	q return
}
*/
Storage Default
{
<Data name="ServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFService.CSS.ServiceD</DataLocation>
<DefaultData>ServiceDefaultData</DefaultData>
<IdLocation>^DHCMed.NINFService.CSS.ServiceD</IdLocation>
<IndexLocation>^DHCMed.NINFService.CSS.ServiceI</IndexLocation>
<StreamLocation>^DHCMed.NINFService.CSS.ServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
