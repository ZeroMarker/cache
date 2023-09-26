Class web.DHCCPW.MR.CheckNoInPath Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      李毅
/// CreatDate:    2012-05-12
/// Description:  查询一段时间内未入径病人信息
/// Table:        
/// Input：       就诊日期，就诊结束日期,临床路径字典ID,科室ID
/// Return：      病人姓名，就诊号,科室,主诊断名称,适合路径,入院医生,登记号,年龄,性别,病区,床位
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MR.CheckNoInPath","QueryNIPath","2014-12-23","2014-12-23","","")
Query QueryNIPath(argDateFrom As %String, argDateTo As %String, argLocID As %String, argCPWID As %String) As %Query(ROWSPEC = "Paadm:%String,PatName:%String,AdmLoc:%String,DiagnoseDesc:%String,CPWDesc:%String,AdmDoc:%String,NotInCPWReason:%String,NotInCPWResume:%String,PapmiNo:%String,AdmWard:%String,Age:%String,Sex:%String,AdmRoomBed:%String")
{
}

ClassMethod QueryNIPathExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argCPWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	;Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	;Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set argDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argDateFrom)
	Set argDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argDateTo)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	;Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	;Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Set:argDateTo="" argDateTo=$p($h,",",1)
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索	
	For tempDate = argDateFrom:1:argDateTo{
		//Set Paadm=""
		Set xVolID=""
		For {
			//Set Paadm=$o(^PAADMi(AdmDateIndex,tempDate,Paadm))
			//Quit:Paadm=""
			//update by zhouruimeng 20170315 BUG:342462-查询不出数据;修改为使用生成住院病案的索引，只取住院的患者
			Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexBuildDate"," A",tempDate,xVolID))
			Quit:xVolID=""
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			
			Set Paadm=##class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
			Continue:Paadm=""
			Continue:$p(^PAADM(Paadm),"^",17)'=""   //已做医疗结算病人
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"
			Continue:$p(AdmInfo,"^",20)="C"
			
			Set PAADMMainMRADMDR=$p($g(^PAADM(+Paadm)),"^",61)
			Continue:$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_PAADMMainMRADMDR)) //已入径
			Set GetCPWICDType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("GetCPWICDType")  //诊断判断类型(基础参数设置)
			Set MrDiagnoseSub="",IsNoInPath=0
			For {
				Set MrDiagnoseSub=$o(^MR(PAADMMainMRADMDR,"DIA",MrDiagnoseSub))
				Quit:MrDiagnoseSub=""
				Quit:IsNoInPath=1	//一个患者一条就诊只取一条未入径记录
				
				Set MRCICDRowid=$p($g(^MR(PAADMMainMRADMDR,"DIA",MrDiagnoseSub)),"^",1)
				Continue:MRCICDRowid=""
				Set TypeDicCode=""
				Set MRDiagType=$o(^MR(PAADMMainMRADMDR,"DIA",MrDiagnoseSub,"TYP",0))
				If MRDiagType'="" {
					Set TypeDicID=$p($g(^MR(PAADMMainMRADMDR,"DIA",MrDiagnoseSub,"TYP",MRDiagType)),"^",1)
					Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
				}
				If (GetCPWICDType=1){		//主要诊断
					Continue:TypeDicCode'="M" 
				}
				ElseIf (GetCPWICDType=3){		//入院主诊断
					Continue:TypeDicCode'="PRE"
				}
				else {	//所有诊断
				}
				
				//判断此诊断是否符合临床路径要求
				Set Info=..ComPareDiaCPW(Paadm,MRCICDRowid,argCPWID)
				Continue:Info=""
				Set IsNoInPath=1	//一个患者一条就诊只取一条未入径记录 add by zhouruimeng 20170315
				
				Set DiagnoseDesc=$p(Info,"^",1)
				Set CPWDesc=$p(Info,"^",2)
				//如果已填写不入径原因,把不入径原因显示出来
				Set NotInPathInfo=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetLogByPaadm(Paadm,"^")
				Set NotInCPWReason=""
				Set NotInCPWResume=""
				If (NotInPathInfo'="")
				{
					Set NotInCPWResume=$p(NotInPathInfo,"^",10)
					Set NotInCPWReasonDr=$p($p(NotInPathInfo,"^",9),",",1)
					//add by pylian 20160307 多条诊断符合入径条件时，判断诊断和提示入径的路径是否一致
					Set NoticePathWayVerID=$p(NotInPathInfo,"^",8)
					Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(NoticePathWayVerID)
					If $IsObject(objCPW) {
						Set PathDesc=objCPW.CPWDesc
					}
					Continue:CPWDesc'[PathDesc
			
					If (NotInCPWReasonDr'=""){
						Set NotInCPWReasonObj=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(NotInCPWReasonDr)
						Set NotInCPWReason=NotInCPWReasonObj.VRDesc
					}
				}
				//病人基本信息,姓名,科室,床位,性别,年龄
				Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
				Continue:'$IsObject(objPaadm)
				
		    	Set PatientID=objPaadm.PatientID
		    	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		    	Set PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)
		    	Set Sex=$p($g(^CT("SEX",$p($g(^PAPER(+PatientID,"ALL")),"^",7))),"^",2)
				Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
				Set:Birthday'="" Birthday=$zd(Birthday,3)
				//update by zf 20150228 统一调用年龄计算方法
    			Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”
    		
				Set AdmLocID=objPaadm.DepartmentID
				Continue:(argLocID'="")&&(argLocID'=AdmLocID)
			    Set AdmLoc=objPaadm.Department   //科室
			    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
				
				Set AdmWard=objPaadm.Ward
				Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
				
				Set AdmRoom=objPaadm.Room
				Set AdmBed=objPaadm.Bed
				Set AdmRoomBed=AdmRoom_"-"_AdmBed
				Set AdmDoc=objPaadm.DoctorName
				
				Set Data=$lb(Paadm,PatName,AdmLoc,DiagnoseDesc,CPWDesc,AdmDoc,NotInCPWReason,NotInCPWResume,PapmiNo,AdmWard,Age,Sex,AdmRoomBed)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryNIPathClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNIPathExecute ]
{
 	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNIPathFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNIPathExecute ]
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
	 Set qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator：     李毅
/// CreatDate：   2012-05-12
/// Description:判断诊断是否符合某条临床路径
/// Table：       User.DHCMRCClinPathWays
/// Input：       EpisodeID:    User.PAADM
///               MRCICDID:     MRC_ICDDx.Rowid
///               CPWDID：临床路径字典ID
/// Return：该诊断名称，符合的某条临床路径病种名称
/// w ##class(web.DHCCPW.MR.CheckNoInPath).ComPareDiaCPW(77380,7745,1)
ClassMethod ComPareDiaCPW(argEpisodeID As %String, argMRCICD As %String, argCPWDID As %String) As %String
{
	New (argEpisodeID,argMRCICD,argCPWDID)
	Set return=""
	Set $ZT="CheckCPWICDErr"
	Quit:(argEpisodeID="")||(argMRCICD="") return
	
	//入院日期
	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(argEpisodeID)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Quit:AdmitDate="" return
	
	//出院日期
	Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(argEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)	
	Set:DischDate="" DischDate=+$h
	
	Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(argMRCICD)
	Set ICD10=$p(tmpICD,"^",4)
	Set ICDDesc=$p(tmpICD,"^",3)
	Quit:(ICD10="")&&(ICDDesc="") return
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argEpisodeID)
	Quit:MRAdm="" return
	//如果患者为入径状态,返回空
	Set PathWayID=0,flg=0
	For {
		Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
		Quit:PathWayID=""
		Quit:flg<0
		
		Set CPWID="",IsActive=""
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		If $IsObject(objPathWay) {
			If $IsObject(objPathWay) {
				Set CPWID=objPathWay.CPWPathwayDR.%Id()
			}
			Set PathWayStatus=objPathWay.CPWStatus
		}
		//Continue:(CPWID="")||(PathWayStatus'="I")
		//出径、完成的亦不考虑
		Continue:(CPWID="")
		Set flg=-1
	}
	Quit:flg<0 return
	//判断此诊断符合哪条路径,根据准入ICD来判断
	Set CPWDescList=""
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set (CPWDesc,CPWICD,CPWLebal,CurrVersion)=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
			Set CPWICD=objCPW.CPWICD
			Set CPWKeys=objCPW.CPWKeys
			Set CPWLebal=objCPW.CPWLabel
			Continue:'$IsObject(objCPW.CPWCPWDicDR)
			
			Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
			Set CPWDicID=objCPW.CPWCPWDicDR.%Id()  //版本对应字典ID
			Set IsActive=objCPW.CPWCPWDicDR.CPWDActive
			Set DateFrom=objCPW.CPWCPWDicDR.CPWDDateFrom
			Set DateTo=objCPW.CPWCPWDicDR.CPWDDateTo
			Continue:IsActive'["Y"
			Continue:(DateFrom'="")&&(DateFrom>DischDate)
			Continue:(DateTo'="")&&(DateTo<AdmitDate)
			
			Continue:(argCPWDID'="")&&(argCPWDID'=CPWDicID)
			
		}
		Continue:CurrVersion'=CPWID
		Continue:$g(CPWICD)=""
		Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(ICD10,CPWICD)
		Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(ICDDesc,CPWKeys)

		Continue:(flg1<=0)&&(flg2<=0)
		//如果传入了临床路径字典ID,则做下面判断
		/*
		Set argCPWID=""
		If ($g(argCPWDID)){
			Set objCPWD=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(argCPWDID)
			Set argCPWID=objCPWD.CPWDVersion
			}
		Quit:(argCPWDID'="")&&(argCPWID'=CPWID)
		*/
		Set CPWDescList=CPWDescList_$lb($g(CPWDesc))
		Set CPWList=$lb($g(CPWDesc),$g(CPWID),$g(CPWDicID))
	}
	Quit:CPWList="" return
	//Set CPWDesc=$lg(CPWList,1)
	Set CPWDesc=$LISTTOSTRING(CPWDescList,";")
	Set return=ICDDesc_"^"_CPWDesc
	
	Quit return
	
CheckCPWICDErr
	Quit ""
}

}
