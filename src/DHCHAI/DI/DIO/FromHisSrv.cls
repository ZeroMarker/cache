/// 名称: DHCHAI.DI.DIO.FromHisSrv
/// 描述: HIS数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-09-27
/// Description:  通过HIS就诊号判断患者是否存在分床记录
/// Table：       Pa_Adm、PA_AdmTransaction
/// Input：       就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetIsTranBed(3)
ClassMethod GetIsTranBed(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set Flg =0
	Set xSub=0
	For {
		Set xSub=$o(^PAADM(aEpisodeID,"TRANS",xSub))
		Quit:xSub=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xSub))	
		Set TransBed=$p(tmpTrans,"^",8)  //床位
		Set:TransBed'="" Flg=1
		Quit:Flg=1 
	}
	Set return = Flg
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-10-08
/// Description:  处理未分床患者一直在院历史记录
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.PAAdmTrans
/// Input：       就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).SyncAdmData()
ClassMethod SyncAdmData() As %String
{

	Set Count=0
	Set $ZT="SyncAdmDataErr"
	Set CurrTime = $h
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexVisitStatus",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
	
		Set xPAAdmID = ""
		For {
			Set xPAAdmID=$o(^DHCHAI.DP.PAAdmI("IndexVisitStatus",xAdmType,"A",xPAAdmID))
			Quit:xPAAdmID=""
			
			Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPAAdmID)
			Continue:'$Isobject(objAdm)
			
			Set EpisodeIDx = objAdm.PAEpisodeIDx
			Set EpisodeID = $p(EpisodeIDx,"||",2)
			Set IsTranBed = ##Class(DHCHAI.DI.DIO.FromHisSrv).GetIsTranBed(EpisodeID)
			Continue:IsTranBed=1     //有分床记录不处理
			Set VisitStatus="P"
		
			Set obj=##class(DHCHAI.DP.PAAdm).%OpenId(xPAAdmID)
			Continue:'$IsObject(obj) 
	
			Set obj.PAVisitStatus=VisitStatus
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
		   		Set return=-1
			}else{
				Set return=obj.%Id()
			}
			Do obj.%Close()
			w !,xPAAdmID
			//计数
			If (return>0){
				do ##class(DHCHAI.DP.PAAdmTrans).DeleteByEpisodeID(xPAAdmID)  //删除转科记录
				
				//删除等待状态患者ICU日志记录
				If $d(^DHCHAI.IR.ICULogDtlI("IndexEpisodeDr",xPAAdmID)) {  //先检查类中是否有这个索引，没有需添加上并重建索引
					Do ##class(DHCHAI.IR.ICULogDtl).DeleteByEpisodeID(xPAAdmID)
				}
				Set Count=Count+1
			}
				
		}	
	}
	Write "处理："_Count_"条",! 
	Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",! 
    Set return=Count
	
	Quit return
SyncAdmDataErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  通过就诊号取住院信息
/// Table：       Pa_Adm、Pa_patmas
/// Input：       就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetAdmInfo(50000022)
ClassMethod GetAdmInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetAdmInfoErr"
	Set AdmStr = $g(^PAADM(+aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	//就诊类型
	Quit:(AdmType'="I")&(AdmType'="E") return
	Set MotherDr= $p(AdmStr,"^",75)	//之婴
	Quit:MotherDr'="" return
	
	//过滤急诊流水病人，只保留急诊留观
	If AdmType="E" {
		Set EmStayInfo=##class(DHCHAI.IO.FromHisSrv).getEmStayInfo(aEpisodeID)
		Set EmStayFlag=+EmStayInfo
		Quit:EmStayFlag<1 return  //1留观、2留观出院
		Set AdmType="EP"  //转换急诊标记为急诊留观
		Set EmAdmDateTime=$p(EmStayInfo,"$",2)
		Set EmDischDateTime=$p(EmStayInfo,"$",3)
	}
	
	Set PatientID = $p(AdmStr,"^",1)
	Quit:PatientID="" return
	
	Set IsTranBed=""
	If (AdmType="I")||(AdmType="EP") {  //update 20191008 住院、急诊留观判断患者是否有首次分床记录
		Set IsTranBed=##Class(DHCHAI.DI.DIO.FromHisSrv).GetIsTranBed(aEpisodeID)		
	}
	
	//病人信息
	Set PapmiNo  	= $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	Set PatName  	= $p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set BirthDay 	= $p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set HomeAddress	= $g(^PAPER(PatientID,"PER","ADD",1))
	Set Company		= $p($g(^PAPER(PatientID,"PER",4)),"^",18)
	Set RelativeName= $p($g(^PAPER(PatientID,"PER",2)),"^",13)
	Set RelativeTel	= $p($g(^PAPER(PatientID,"ALL")),"^",4)
	Set DeathDate	= $p($g(^PAPER(PatientID,"ALL")),"^",13)
	Set DeathTime	= $p($g(^PAPER(PatientID,"ALL")),"^",8)
	Set IsDeath  	= $s(DeathDate'="":1,1:0)
	Set Nation 		= $p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)
	Set IdentityCode= $p($g(^PAPER(PatientID,"ALL")),"^",9)
	//修复bug 538526,544495病人身份证号不存在时不再取值为证件号码
	//Set:IdentityCode="" IdentityCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",6) 
	Set Sex	 = $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	Set Sex	 = $s(Sex="男":"M",Sex="女":"F",1:"O")
	Set MrNo = ##Class(DHCHAI.IO.FromAdmSrv).GetMrNoByAdm(aEpisodeID)
	
	// add 20211230 同步任务中过滤特定的测试患者
	Set ExPaAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	If ExPaAdmList'=""  {
		Quit:(PapmiNo'="")&((","_ExPaAdmList_",")[(","_PapmiNo_",")) return			
		Quit:(MrNo'="")&((","_ExPaAdmList_",")[(","_MrNo_",")) return
		Quit:(PatName'="")&((","_ExPaAdmList_",")[(","_PatName_",")) return
	}
	
	Set return = aEpisodeID_"^"_PatientID_"^"_PapmiNo_"^"_MrNo_"^"_PatName_"^"_Sex_"^"_Nation
	_"^"_BirthDay_"^"_IdentityCode_"^"_HomeAddress_"^"_Company_"^"_RelativeName
	_"^"_RelativeTel_"^"_IsDeath_"^"_DeathDate_"^"_DeathTime
	
	//就诊信息
	Set VisitStatus = $p(AdmStr,"^",20)	//就诊状态
	Set:(IsTranBed=0)&&(VisitStatus="A") VisitStatus="P"   //update 20191008 无分床记录，记为等待状态 ，只处理在院患者，以出院、退院患者不处理
	
	Set AdmDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(+aEpisodeID)	//入院日期
	Set AdmDate	= $p(AdmDateTime,"^",1)
	Set AdmTime	= $p(AdmDateTime,"^",2)
	Set AdmLoc	= $p(AdmStr,"^",4)
	Set HospID  = $p($g(^CTLOC(AdmLoc)),"^",22)
	Set HospCode = $p($g(^CT("HOSP",HospID)),"^",1)
	Set AdmLocCode = $p($g(^CTLOC(AdmLoc)),"^",1)
	Set AdmLocDesc = $p($g(^CTLOC(AdmLoc)),"^",2)
	Set AdmWard	= $p(AdmStr,"^",70)
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)  //病区科室转换一下
	Set AdmWardCode = $p($g(^CTLOC(+AdmWard)),"^",1)
	Set AdmWardDesc = $p($g(^CTLOC(+AdmWard)),"^",2)
	Set AdmRoom	= $p(AdmStr,"^",69)
	Set AdmBed	= $p(AdmStr,"^",73)
	//Set:AdmBed'="" AdmBed = $p($g(^PAWARD(+AdmBed,"BED",$p(AdmBed,"||",2))),"^",1)
	
	Set DischDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(+aEpisodeID)
	Set DischDate = $p(DischDateTime,"^",1)
	Set DischTime = $p(DischDateTime,"^",2)
	If AdmType="EP" {
		Set EmDischDate = $p(EmDischDateTime,"^",1)
		Set EmDischTime = $p(EmDischDateTime,"^",2)
		Set:EmDischDate'="" DischDate=EmDischDate
		Set:EmDischDate'="" DischTime=EmDischTime
	}
	Set DischLoc  = $s(DischDate'="":AdmLoc,"1":"")		//如果有出院日期，出院科室为当前科室
	Set (DischLocCode,DischLocDesc)=""
	if DischLoc'=""{
		Set DischLocCode = $p($g(^CTLOC(DischLoc)),"^",1)
		Set DischLocDesc = $p($g(^CTLOC(DischLoc)),"^",2)
	}
	Set DischWard = $s(DischDate'="":AdmWard,"1":"")	//如果有出院日期，出院病区为当前病区
	Set (DischWardCode,DischWardDesc)=""
	if DischWard'=""{
		Set DischWardCode = $p($g(^CTLOC(DischWard)),"^",1)
		Set DischWardDesc = $p($g(^CTLOC(DischWard)),"^",2)
	}
	Set IsNewBaby=0,BirthWeight="",AdmitWeight=""
	If DischDate'="" {
		//Set AdmDays=DischDate-AdmDate+1
		Set AdmDays=DischDate-AdmDate   //修复bug:557856统一住院天数计算
		Set:AdmDays<1 AdmDays=1
	} Else {
		Set AdmDays=-1
	}
	If BirthDay'=""{
		Set:(AdmDate-BirthDay<=28) IsNewBaby=1	//新生儿：出生28天以内
	}
	if IsNewBaby=1{
		Set BirthWeight = ""			//新生儿出生体重（g）
		Set AdmitWeight = ""			//新生儿入院体重（g）
		Set PregID=$o(^PAPRGi("BABY_Person_DR",PatientID,""))
		If PregID'=""{
			Set DelID=$o(^PAPRGi("BABY_Person_DR",PatientID,PregID,"DEL",""))
			If DelID'=""{
				Set BabyID=$o(^PAPRGi("BABY_Person_DR",PatientID,PregID,"DEL",DelID,"BABY",""))
				If BabyID'=""{
					Set PregdelBaby=$g(^PAPRG(PregID,"DEL",DelID,"BABY",BabyID))
					Set birthdate=$p(PregdelBaby,"^",13)
					Set birthtime=$p(PregdelBaby,"^",49)
					Set BirthWeight=$zcvt($p(PregdelBaby,"^",17),"L")
					Set:(BirthWeight["kg") BirthWeight=+BirthWeight*1000
					Set:(BirthWeight'["g") BirthWeight=BirthWeight_"g"
					Set:(BirthWeight="g") BirthWeight=""
				}
			}
		}
	}
	Set Age = ##class(DHCHAI.IO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set IsActive = 1
	
	Set:(VisitStatus="P")||(VisitStatus="C") IsActive =0
	Set return=return_"^"_AdmType_"^"_VisitStatus_"^"_AdmDate_"^"_AdmTime_"^"_AdmLoc
	_"^"_AdmWard_"^"_AdmRoom_"^"_AdmBed_"^"_DischDate_"^"_DischTime_"^"_DischLoc
	_"^"_DischWard_"^"_AdmDays_"^"_IsNewBaby_"^"_BirthWeight_"^"_AdmitWeight_"^"_IsActive_"^"_HospCode_"^"_Age
	
	//add by chenjb 就诊次数
	Set PAAdmTimes	= $p(AdmStr,"^",29)
	//add by zhufei 主管医生
	Set AdmDocDr    = $p(AdmStr,"^",9)  //主管医生
	Set AdmDocCode="",AdmDocDesc=""
	If AdmDocDr'="" {
		Set AdmDocCode=$p($g(^CTPCP(AdmDocDr,1)),"^",1)
		Set AdmDocDesc=$p($g(^CTPCP(AdmDocDr,1)),"^",2)
	}
	Set PAAdmDoc=AdmDocDr_"|"_AdmDocCode_"|"_AdmDocDesc
	Set return=return_"^"_PAAdmTimes_"^"_PAAdmDoc
	
	Quit return
	
GetAdmInfoErr
	Quit "-999^"_$ZError
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  通过就诊号取转科信息
/// Input：       aEpisodeID:就诊号	  
/// Return：      
/// s TransList=""
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetTransInfo(19511413,.TransList)
ClassMethod GetTransInfo(aEpisodeID As %String, ByRef aTransList As %String) As %String
{
	New (aEpisodeID,aTransList)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetTransInfoErr"
	
	//处理医生结算后转科情况，后面的转科不算
	Set DischDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)		//出院日期
	Set DischTime=$p(DischDateTime,"^",2)		//出院时间
	//处理退院情况	
	Set aSCode ="HIS01"
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aSCode_"||"_aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set VisitStatus=objEpisode.PAVisitStatus
	Quit:VisitStatus="C" return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransInfo"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set xSub=0
	For {
		Set xSub=$o(^PAADM(aEpisodeID,"TRANS",xSub))
		Quit:xSub=""
		
		//Set TransID=aEpisodeID_"||"_xSub
		Set TransID=aEpisodeID_xSub    //临时global按顺序输出导致转科记录有误问题处理
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xSub))
		Set StartDate=$p(tmpTrans,"^",1)
		Set StartTime=$p(tmpTrans,"^",2)
		Set AdmDocDr=$p(tmpTrans,"^",5)
		Set AdmDocCode="",AdmDocDesc=""
		If AdmDocDr'="" {
		Set AdmDocCode=$p($g(^CTPCP(AdmDocDr,1)),"^",1)
		Set AdmDocDesc=$p($g(^CTPCP(AdmDocDr,1)),"^",2)
		}
		Set PAAdmDoc=AdmDocDr_"|"_AdmDocCode_"|"_AdmDocDesc
		Continue:(StartDate="")||(StartTime="")
		Continue:(DischDate'="")&&(StartDate>DischDate)
		Continue:(DischDate=StartDate)&&(StartTime>DischTime)
		
		Set TransLoc=$p(tmpTrans,"^",6)  //科室
		If TransLoc'="" {
			Set ^TMP(ZIndex,JIndex,NIndex,"E",StartDate,StartTime,TransID)=$lb(TransID,TransLoc,"",StartDate,StartTime,PAAdmDoc)
		}
		Set TransWard=$p(tmpTrans,"^",9)  //病区
		If TransWard'="" {
			Set TransWard=$p($g(^PAWARD(TransWard)),"^",5)
			If TransWard'="" {
				Set ^TMP(ZIndex,JIndex,NIndex,"W",StartDate,StartTime,TransID)=$lb(TransID,TransWard,"",StartDate,StartTime,PAAdmDoc)
			}
		}

		Set TransBed=$p(tmpTrans,"^",8)  //床位
		If TransBed'="" {
			Set TransWard=+TransBed
			Set TransWard=$p($g(^PAWARD(TransWard)),"^",5)
			If TransWard'="" {
				Set ^TMP(ZIndex,JIndex,NIndex,"W",StartDate,StartTime,TransID)=$lb(TransID,TransWard,"",StartDate,StartTime,PAAdmDoc)
			}
			If TransBed'="" {
				Set ^TMP(ZIndex,JIndex,NIndex,"B",StartDate,StartTime,TransID)=$lb(TransID,TransWard,TransBed,StartDate,StartTime,PAAdmDoc)
			}
		}
	}
	Set TransInfoList=""
	Set xType=""
	For {
		Set xType=$o(^TMP(ZIndex,JIndex,NIndex,xType))
		Quit:xType=""
		
		Set xSttDate=0
		For {
			Set xSttDate=$o(^TMP(ZIndex,JIndex,NIndex,xType,xSttDate))
			Quit:xSttDate=""
			
			Set xSttTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
			For {
				Set xSttTime=$o(^TMP(ZIndex,JIndex,NIndex,xType,xSttDate,xSttTime))
				Quit:xSttTime=""
				
				Set xTransID=""
				For {
					Set xTransID=$o(^TMP(ZIndex,JIndex,NIndex,xType,xSttDate,xSttTime,xTransID))
					Quit:xTransID=""
					
					Set tmpTrans=$g(^TMP(ZIndex,JIndex,NIndex,xType,xSttDate,xSttTime,xTransID))
					Continue:tmpTrans=""
					Set TransID=$lg(tmpTrans,1)
					Set TransLoc=$lg(tmpTrans,2)
					Set TransBed=$lg(tmpTrans,3)
					Set TransDate=$lg(tmpTrans,4)
					Set TransTime=$lg(tmpTrans,5)
					Set PAAdmDoc=$lg(tmpTrans,6)
					Set TransID= $e(TransID,1,$l(aEpisodeID))_"||"_$e(TransID,$l(aEpisodeID)+1,$l(TransID))
					If TransInfoList="" {
						Set TransInfoList=$lb($lb(xType,TransID,TransLoc,TransBed,TransDate,TransTime,"","",PAAdmDoc))
					} Else {
						Set LastTrans=$lg(TransInfoList,$ll(TransInfoList))
						
						Continue:(xType="E")&&(TransLoc=$lg(LastTrans,3))  //判断是否与前一科室相同
						Continue:(xType="W")&&(TransLoc=$lg(LastTrans,3))  //判断是否与前一病区相同
						Continue:(xType="B")&&(TransBed=$lg(LastTrans,4))  //判断是否与前一床位相同
						If xType=$lg(LastTrans,1){	//相同转移类型才能处理上一次结束时间
							Set $list(LastTrans,7)=TransDate
							Set $list(LastTrans,8)=TransTime
							Set $list(TransInfoList,$ll(TransInfoList))=LastTrans
						}
						Set TransInfoList=TransInfoList_$lb($lb(xType,TransID,TransLoc,TransBed,TransDate,TransTime,"","",PAAdmDoc))
					}
				}
			}
		}
		//Set aTransList=aTransList_TransInfoList
	}
	
	// 出院后结束转科记录
	If DischDate'=""{
		For indTI=1:1:$listlength(TransInfoList) {
			Set tmpTrans=$listget(TransInfoList,indTI)
			Continue:tmpTrans=""
			if $list(tmpTrans,7)=""{
				Set $list(tmpTrans,7)=DischDate
				Set $list(tmpTrans,8)=DischTime
			}
			Set aTransList=aTransList_$lb(tmpTrans)
		}
	}
	else
	{
		Set aTransList=aTransList_TransInfoList
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set return=1
	Quit return
	
GetTransInfoErr
	Quit "-999^"_$ZError
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  通过就诊号取临床诊断记录
/// Input：       aEpisodeID:就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetMrDiagnos(50098968,"2018-01-01","2018-01-26")
ClassMethod GetMrDiagnos(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	//Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	Quit:(aEpisodeID="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set $ZT="GetMrDiagnosErr"
	Set ADMNo=$p(^PAADM(aEpisodeID),"^",81)  //结构化诊断入参
	Set MRADMDR=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRADMDR="" return
	Quit:'$d(^MR(MRADMDR,"DIA")) return
	
	Set DiagSub=0
	For {
		Set DiagSub=$o(^MR(MRADMDR,"DIA",DiagSub))
		Quit:DiagSub=""
		
		Set (ICD10,ICDDesc,Note,TypeCode,TypeDesc,DiagDate,DiagTime,IsActive)=""
		Set tmpDignos = $g(^MR(MRADMDR,"DIA",DiagSub))
		Continue:tmpDignos=""
		Set DiagDate = $p(tmpDignos,"^",19)
		Set DiagTime = $p(tmpDignos,"^",20)
		Continue:DiagDate=""
		Continue:((aDateFrom'="")&&(DiagDate<aDateFrom))
		Continue:((aDateTo'="")&&(DiagDate>aDateTo))
		
		Set ICDID	 = $p(tmpDignos,"^",1)
		If ICDID'="" {
			Set tmpICD  = $g(^MRC("ID",ICDID))
			Set ICD10   = $p(tmpICD,"^",1)
			Set ICDDesc = $p(tmpICD,"^",2)
		}
		Set Note = $g(^MR(MRADMDR,"DIA",DiagSub,"DES",1))
		
		Set TypeCode=""
		Set xDiagType=$o(^MR(MRADMDR,"DIA",DiagSub,"TYP",0))
		If xDiagType'="" {
			Set TypeID=$g(^MR(MRADMDR,"DIA",DiagSub,"TYP",xDiagType))
			Set TypeCode=$p($g(^MRC("DTYP",+TypeID)),"^",1)
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeID)),"^",2)
		}
		
		// 主诊断标志 modify by liyi 20180424
		Set MrDiagID = aEpisodeID_"||"_DiagSub   // 诊断ID
		Set MainDiagFlag=$p($g(^MR(MRADMDR,"DIA",DiagSub,1)),"^",20)
		If (MainDiagFlag="Y"){
			// 诊断为主诊断记录两条诊断类型记录
			Set Data = $lb(MrDiagID_"||"_0,ICD10,ICDDesc,Note,TypeCode,TypeDesc,DiagDate,DiagTime)
			Set return = return_$lb(Data)
			Set TypeCode="M"
			Set TypeDesc="主要诊断"
			Set MrDiagID = MrDiagID_"||"_1
		}else{
			Set MrDiagID = MrDiagID_"||"_0
		}
		
		Set DiagPrefix=$p($g(^MR(MRADMDR,"DIA",DiagSub,1)),"^",26)    //诊断前缀 add 2020-09-17
		//判断类是否存在
		Set IsExist=##class(websys.Conversions).IsValidClassName("web.DHCBL.MKB.SDSDiagnosFuseInterface")
		If (IsExist="1"){
			Set RowidNN = MRADMDR_"||"_DiagSub
			//结构化诊断信息返回
			Set SDSInfo=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetStructDiagnos(ADMNo,RowidNN)
			Set SDSDesc=$P(SDSInfo,"^",4)
			//优先显示结构化诊断描述
			Set:SDSDesc'="" ICDDesc=SDSDesc
		}
		
		Set Data = $lb(MrDiagID,ICD10,ICDDesc,Note,TypeCode,TypeDesc,DiagDate,DiagTime,DiagPrefix)
		Set return = return_$lb(Data)
	}
	Quit return
GetMrDiagnosErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2017-08-16
/// Description:  查询医嘱信息
/// Table：       
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DI.DIO.FromHisSrv","QryOrdItemList","","","")
Query QryOrdItemList(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "OEItemID:%String,ArcimCode:%String,ArcimDesc:%String,ArcOrdType:%String,ArcCatDesc:%String,ArcSubCatDesc:%String,PHCCatDesc:%String,PHCSubCatDesc:%String,PHCPoisonDesc:%String,AntiFlag:%String,PHCGeneric:%String,PHChemical:%String")
{
}

ClassMethod QryOrdItemListExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,""))
	Quit:OrdID="" $$$OK
	
	If $d(^OEORDi(0,"XDate")) {
		//新开医嘱
		For xSttDate=aDateFrom:1:aDateTo{
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"StDt",xSttDate,OrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,1))
				Continue:OrdItemInfo=""
				Do BuildQryOrdItemList
			}
		}
		//新停止、作废、撤销医嘱
		For xEndDate=aDateFrom:1:aDateTo{
			Set xSubID=0
			For {
				Set xSubID=$o(^OEORDi(0,"XDate",xEndDate,OrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,"1"))
				Continue:OrdItemInfo=""
				Do BuildQryOrdItemList
			}
		}
		
	}Else {
	    Set xSubID=0
	    For {
		    Set xSubID=$o(^OEORD(OrdID,"I",xSubID))
		    Quit:xSubID=""
		    Set SttDate = $p($g(^OEORD(OrdID,"I",xSubID,1)),"^",9)  // 开始日期 
		    Continue:(SttDate'="")&&(SttDate>aDateTo)
	    	Set XDate = $p($g(^OEORD(OrdID,"I",xSubID,3)),"^",34)   // 停止日期 
	     	Continue:(XDate'="")&&(XDate<aDateFrom)
	     	Continue:(SttDate<aDateFrom)&&(XDate="")
	     	Set OrdItemInfo=$g(^OEORD(OrdID,"I",xSubID,"1"))
			Continue:OrdItemInfo=""
			Do BuildQryOrdItemList
	    }
	}
	Quit $$$OK
	
BuildQryOrdItemList
	Set ArcimID=$p($g(^OEORD(OrdID,"I",xSubID,1)),"^",2)
	Quit:ArcimID=""
	
	Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		//医嘱项代码
	Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)		//医嘱项名称
	Set ArcSubCatDr=$p($g(^ARCIM(+ArcimID,1,1)),"^",10)
	Set ArcSubCatDesc=$p($g(^ARC("IC",+ArcSubCatDr)),"^",2)	//医嘱子类
	Set ArcCatDr=$p($g(^ARC("IC",+ArcSubCatDr)),"^",8)
	Set ArcCatDesc=$p($g(^OEC("ORCAT",+ArcCatDr)),"^",2) 	//医嘱大类
	Set ArcOrdType=$p($g(^ARC("IC",+ArcSubCatDr)),"^",7)	//医嘱类型（药品R、检验L）
	Quit:ArcSubCatDesc=""
	
	//过滤皮试医嘱
	Set PHCInstrID = $p($g(^OEORD(OrdID,"I",xSubID,2)),"^",7)
	If PHCInstrID'=""{
		Set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",2)
		Quit:PHCInstrDesc["皮试"
		Set PHCInstrDesc=$p($g(^PHCIN(+PHCInstrID)),"^",3)
		Quit:PHCInstrDesc["皮试"
	}
	
	//PHC_DrgForm:药学形态
	Set DrgFormID=$p($g(^ARCIM(+ArcimID,1,1)),"^",12)
	//PHC_DrgMast药理学项
	Set DrgMastID=+DrgFormID
	//PHC_SubCat药理学子分类
	Set PHCSubCatDr=$p($g(^PHCD(DrgMastID,1)),"^",3)
	Set PHCSubCatCode=$p($g(^PHCC(+PHCSubCatDr,"SC",+$p(PHCSubCatDr,"||",2))),"^",1)
	Set PHCSubCatDesc=$p($g(^PHCC(+PHCSubCatDr,"SC",+$p(PHCSubCatDr,"||",2))),"^",2)
	
	//PHC_Generic药品通用名 add by zf 20171128
	Set PHCGenericDr=+$p($g(^PHCD(DrgMastID,4)),"^",1)
	Set PHCGeneric=""
	Set:PHCGenericDr'="" PHCGeneric=$p($g(^PHCGE("GE",PHCGenericDr)),"^",2)
	//DHCPHChemical药品化学名  add by zf 20171128
	//还未完成，暂时预留出字段
	Set:PHCGenericDr'="" PHChemicalDr=$p($g(^PHCGE("GE",PHCGenericDr,"DHC")),"^",3)      //PHC_DrgFormExt表  $p($g(^PHCD(+DrgFormID,"DF",+$p(DrgFormID,"||",2),"DHC")),"^",???)
	Set PHChemical=""
	Set:PHChemicalDr'="" PHChemical=$p($g(^DHCPHCM(PHChemicalDr)),"^",2)
	
	//PHC_Cat药理学分类
	Set PHCCatDr=+PHCSubCatDr
	Set PHCCatCode=$p($g(^PHCC(PHCCatDr)),"^",1)
	Set PHCCatDesc=$p($g(^PHCC(PHCCatDr)),"^",2)
	//PHC_Poison  管制分类
	Set PHCPoisonDr=$p($g(^PHCD(DrgMastID,1)),"^",4)
	Set PHCPoisonCode=$p($g(^PHCPO(+PHCPoisonDr)),"^",1)
	Set PHCPoisonDesc=$p($g(^PHCPO(+PHCPoisonDr)),"^",2)
	//抗生素标志
	Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",+$p(DrgFormID,"||",2),"DHC")),"^",8)
	Set AntiFlag=$s(AntiFlag="Y":1,1:0)
	
	Set Data=$lb(OrdID_"||"_xSubID,ArcimCode,ArcimDesc,ArcOrdType,ArcCatDesc,ArcSubCatDesc,PHCCatDesc,PHCSubCatDesc,PHCPoisonDesc,AntiFlag,PHCGeneric,PHChemical)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryOrdItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrdItemListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrdItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrdItemListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  通过医嘱ID取医嘱信息(滚执行记录)
/// Input：       OEORIRowId:医嘱ID
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetOrderInfo("50090214||6")
ClassMethod GetOrderInfo(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	Set $ZT="GetOrderInfoErr"
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	Set OEItemID=OrdID_"||"_SubID
	
	Set ArcimID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",2)
	Quit:ArcimID="" return
	Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
	Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
	
	//医嘱分类
	Set ArcimProperty = ##Class(DHCHAI.DI.DIO.FromHisSrv).GetArcimProperty(ArcimID)
	Set OrdCat    		= $p(ArcimProperty,"^",1)	//医嘱大类
	Set OrdSubCat 		= $p(ArcimProperty,"^",2) 	//医嘱子类
	Set PHCCatDesc 		= $p(ArcimProperty,"^",3)	//药学大类
	Set PHCSubCatDesc 	= $p(ArcimProperty,"^",4)	//药学子类
	Set PoisonCode 		= $p(ArcimProperty,"^",5)	//管制分类
	Set AntiFlag 		= $p(ArcimProperty,"^",6)	//抗生素标记
	Set OrdType   		= $p(ArcimProperty,"^",7)	//医嘱项类型
	Set DrgGeneric   	= $p(ArcimProperty,"^",8)	//药品通用名
	
	//医嘱类型（长期、临时）
	Set PriorityDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",8)
	Set PriorityDesc=$p($g(^OECPR(+PriorityDr)),"^",2)
	
	//开医嘱日期、时间、科室、医生
	Set SttDate=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",9) 			//医嘱开始日期（OEORI_SttDate）
	Set SttTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)			//医嘱开始时间（OEORI_SttTime）
	Set OrdDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",7) 			//开医嘱日期（OEORI_Date）
	Set OrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",17)			//开医嘱时间（OEORI_TimeOrd）
	Set OrdLocDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",3)			//开医嘱科室ID
	Set OrdLocCode=$p($g(^CTLOC(+OrdLocDr)),"^",1)		            //开医嘱科室
	Set OrdLocDesc=$p($g(^CTLOC(+OrdLocDr)),"^",2)		            //开医嘱科室
	Set OrdDocDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",11) 			//开医嘱医生ID
	Set OrdDocCode=$p($g(^CTPCP(+OrdDocDr,1)),"^",1)				//开医嘱医生代码
	Set OrdDocName=$p($g(^CTPCP(+OrdDocDr,1)),"^",2)				//开医嘱医生姓名
	Set RecLocDr=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",6) 			//医嘱接收科室（OEORI_RECDepartment_DR）
	Set RecLocCode=$p($g(^CTLOC(+RecLocDr)),"^",1)		            //医嘱接收科室
	Set RecLocDesc=$p($g(^CTLOC(+RecLocDr)),"^",2)		            //医嘱接收科室
	
	//停医嘱日期、时间
	Set XDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",34)              //停医嘱日期
	Set XTime=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",15)		        //停医嘱时间
	Set EndDate = $p(^OEORD(OrdID,"I",SubID,9),"^",9)		        //OEORI_EndDate	
	Set EndTime = $p(^OEORD(OrdID,"I",SubID,9),"^",10) 	            //OEORI_EndTime
	Set XDate = $s(XDate="":EndDate, 1:XDate)			            //没停止日期时,取预停日期	
	Set XTime = $s(XTime="":EndTime, 1:XTime)
	
	//给药途径、单次剂量、剂量单位、频次
	Set InstrucDr=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",7)
	Set InstrucDesc=$p($g(^PHCIN(+InstrucDr)),"^",2)				//给药途径（用法）
	Set DoseQty=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",1) 			//单次剂量 
	Set QtyUomDr=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",3) 		
	Set QtyUomDesc=$p($g(^CT("UOM",+QtyUomDr)),"^",2)	            //剂量单位
	Set FreqDr=$p($g(^OEORD(OrdID,"I",SubID,2)),"^",4) 			
	Set FreqDesc=$p($g(^PHCFR(+FreqDr)),"^",3)				        //频次
	
	//医嘱状态（核实、执行、...）
	Set OrdStatusDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",13)
	Set OrdStatusCode=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",1)
	Set OrdStatusDesc=$p($g(^OEC("OSTAT",+OrdStatusDr)),"^",2)
	
	//查找滚医嘱方式下的主医嘱
	Set OID=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",12)
	Set OID=$p(OID,"!!",1)
	If (OID'="") {
		Set OrdID2=$p(OID,"||",1)
		Set SubID2=$p(OID,"||",2)
		Set OEItemID2=OrdID2_"||"_SubID2
		
		Set SttDate=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",7)           //医嘱开始日期
		Set SttTime=$p($g(^OEORD(OrdID2,"I",SubID2,3)),"^",15)          //医嘱开始时间
		Set OrdDate=$p($g(^OEORD(OrdID2,"I",SubID2,1)),"^",9) 			//开医嘱日期
		Set OrdTime=$p($g(^OEORD(OrdID2,"I",SubID2,1)),"^",10)			//开医嘱时间
		
		//医嘱状态（核实、执行、...）
		Set OrdStatusDr2=$p($g(^OEORD(OrdID2,"I",SubID2,1)),"^",13)
		Set OrdStatusCode2=$p($g(^OEC("OSTAT",+OrdStatusDr2)),"^",1)
		Set OrdStatusDesc2=$p($g(^OEC("OSTAT",+OrdStatusDr2)),"^",2)
	} Else {
		Set OEItemID2="",OrdStatusDesc2=""
	}
	
	//医嘱备注 add by mayanpeng 2020-08-26
	Set DepProcNotes=""
	Set DepProcNotesLen=+$g(^OEORD(OrdID,"I",SubID,"DEP",0))
	If (DepProcNotesLen'=0) {
		For indx=1:1:DepProcNotesLen {
			Set DepProcNotes=DepProcNotes_","_$g(^OEORD(OrdID,"I",SubID,"DEP",indx))
		}
	}
	Set:DepProcNotes'="" DepProcNotes=$e(DepProcNotes,2,$l(DepProcNotes))
	
	Set return=OEItemID_"^"_OrdStatusDesc_"^"_OEItemID2_"^"_OrdStatusDesc2  //1-4
	_"^"_ArcimCode_"^"_ArcimDesc_"^"_OrdType_"^"_OrdCat_"^"_OrdSubCat_"^"_PriorityDesc  //5-10
	_"^"_OrdDate_"^"_OrdTime_"^"_OrdLocDr_"^"_OrdLocDesc_"^"_OrdDocCode_"^"_OrdDocName  //11-16
	_"^"_SttDate_"^"_SttTime_"^"_XDate_"^"_XTime  //17-20
	_"^"_DrgGeneric_"^"_InstrucDesc_"^"_DoseQty_"^"_QtyUomDesc_"^"_FreqDesc //21-25
	
	//抗菌药物管理信息
	Set (AntUsePurDesc,AntOthPurpose,AntIsSubm,AntInfPosDesc,AntUseDate,AntUseTime)=""
	Set AntUseID=$o(^DAUP("OEORI",OEItemID,0))
	If AntUseID'="" {
		Set AntUseInfo=##class(DHCHAI.IO.FromHisSrv).GetAntUseInfo(OEItemID)
		Set AntUsePurpDr=$p(AntUseInfo,"^",1)
		Set AntUsePurDesc=$p(AntUseInfo,"^",2)
		Set AntOthPurpose=$p(AntUseInfo,"^",3)
		Set AntIsSubm=$p(AntUseInfo,"^",4)
		Set:AntIsSubm="undefined" AntIsSubm=0  //add 20190829
		Set AntInfPosDr=$p(AntUseInfo,"^",5)
		Set AntInfPosDesc=$p(AntUseInfo,"^",6)
		Set AntUseDate=$p(AntUseInfo,"^",7)
		Set AntUseTime=$p(AntUseInfo,"^",8)
	}
    
	Set return=return_"^"_PoisonCode_"^"_AntUsePurDesc_"^"_AntOthPurpose  //26-28
	_"^"_AntIsSubm_"^"_AntInfPosDesc_"^"_AntUseDate_"^"_AntUseTime  //29-32
	
	//add by zf 后添加内容
	Set return=return_"^"_OrdLocDr    //开医嘱科室ID      33   同13
	Set return=return_"^"_OrdLocCode  //开医嘱科室代码    34
	Set return=return_"^"_OrdLocDesc  //开医嘱科室名称    35   同14
	Set return=return_"^"_RecLocDr    //医嘱接收科室ID    36
	Set return=return_"^"_RecLocCode  //医嘱接收科室代码  37
	Set return=return_"^"_RecLocDesc  //医嘱接收科室名称  38
	Set return=return_"^"_OrdDocDr    //开医嘱医生ID      39
	
	///add by wpl 添加医嘱阶段 2020-07-08
	Set (OrderStage,OrderStageDesc)=""
	Set OrderStage=$P($G(^OEORD(+aOEItemID,"I",$P(aOEItemID,"||",2),"DHC")),"^",8)
	//修改老版本临床没有取医嘱阶段方法
 	Set OrderStageDesc=$s(OrderStage="SQ":"术前",OrderStage="SZ":"术中",OrderStage="SH":"术后",OrderStage="SQ":"术前",OrderStage="CZ":"产后",1:"")	
	Set return=return_"^"_OrderStageDesc    //医嘱阶段      40
	Set return=return_"^"_DepProcNotes	//医嘱备注	41
	
	// add pylian 20220909 抗菌药物医嘱首次执行时间
	Set (ExecutDate,ExecutTime)=""
	If (AntUseID'="") {
		Set ExecSub=""
		For  {
			Set ExecSub=$o(^OEORD(OrdID,"I",SubID,"X",ExecSub))
			Quit:ExecSub=""
			Quit:(ExecutDate'="")&(ExecutTime'="")
			Set ExecInfo= $g(^OEORD(OrdID,"I",SubID,"X",ExecSub))
			Continue:ExecInfo=""
			Set OrdStatusDr=$p($g(^OEORD(OrdID,"I",SubID,"X",ExecSub)),"^",16)
			Continue:OrdStatusDr=""
			Set OrdStatus=$p($g(^OEC("STAT",OrdStatusDr)),"^",1)
			Continue:OrdStatus'="F"
			Set ExecutDate=$p($g(^OEORD(OrdID,"I",SubID,"X",ExecSub)),"^",19)
			Set ExecutTime=$p($g(^OEORD(OrdID,"I",SubID,"X",ExecSub)),"^",20)
		}
	}
	Set return=return_"^"_ExecutDate    //医嘱首次执行时间  42
	Set return=return_"^"_ExecutTime	//医嘱首次执行时间	43
	
	Quit return
	
GetOrderInfoErr
	Quit "-999^"_$ZError
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  医嘱项ID取医嘱大类、医嘱子类、药学大类、药学子类、管制分类、抗生素标记（ANTI）、医嘱项类型、通用名
/// Input：       aArcimID：医嘱项ID
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetArcimProperty("863||1")
ClassMethod GetArcimProperty(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=""
	Quit:aArcimID="" return
	
	Set $ZT="GetArcimPropertyErr"
	
	Set (ArcimCatDesc,ArcimSubCatDesc,PHCCatDesc,PHCSubCatDesc,PoisonCode,PoisonDesc,AntiFlag,ArcimOrderType,DrgGeneric)=""
	Set ArcimSubCatDR	= $p($g(^ARCIM(+aArcimID,1,1)),"^",10)
	Set ArcimSubCatDesc = $p($g(^ARC("IC",+ArcimSubCatDR)),"^",2)	//子类
	Set ArcimCatDr 		= $p($g(^ARC("IC",+ArcimSubCatDR)),"^",8)
	Set ArcimCatDesc	= $p($g(^OEC("ORCAT",+ArcimCatDr)),"^",2) 	//大类
	Set ArcimOrderType 	= $p($g(^ARC("IC",+ArcimSubCatDR)),"^",7)	//医嘱项类型
	Set DrgFormID 		= $p($g(^ARCIM(+aArcimID,1,1)),"^",12)  	//PHC_DrgForm:药学形态
	Set DrgMastID=+DrgFormID                              			//PHC_DrgMast药理学项
	If DrgMastID'=0{
		//PHC_SubCat药理学子分类
		Set PHCSubCatID=$p($g(^PHCD(DrgMastID,1)),"^",3)    
		Set PHCSubCatCode=$p($g(^PHCC(+PHCSubCatID,"SC",+$p(PHCSubCatID,"||",2))),"^",1)
		Set PHCSubCatDesc=$p($g(^PHCC(+PHCSubCatID,"SC",+$p(PHCSubCatID,"||",2))),"^",2)
		//PHC_Cat药理学分类
		Set PHCCatID=+PHCSubCatID
		Set PHCCatCode=$p($g(^PHCC(PHCCatID)),"^",1)
		Set PHCCatDesc=$p($g(^PHCC(PHCCatID)),"^",2)
		//PHC_Poison  管制分类
		Set PoisonID=$p($g(^PHCD(DrgMastID,1)),"^",4)
		Set PoisonCode=$p($g(^PHCPO(+PoisonID)),"^",1)			
		Set PoisonDesc=$p($g(^PHCPO(+PoisonID)),"^",2)
		//抗生素标志
		Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",$p(DrgFormID,"||",2),"DHC")),"^",8)
		Set AntiFlag=$s(AntiFlag="Y":AntiFlag="ANTI",1:"")
		//通用名
		Set DrgGeneric=$p($g(^PHCD(DrgMastID,4)),"^",1)
		Set:DrgGeneric'="" DrgGeneric=$p($g(^PHCGE("GE",DrgGeneric)),"^",2)
	}
	Set return=ArcimCatDesc_"^"_ArcimSubCatDesc_"^"_PHCCatDesc_"^"_PHCSubCatDesc_"^"_PoisonCode_"^"_AntiFlag_"^"_ArcimOrderType_"^"_DrgGeneric
	Quit return
	
GetArcimPropertyErr
	Quit "-999^"_$ZError
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  取HIS科室信息
/// Table：       CT_Loc
/// Input：       aLocId：HIS科室ID
/// Return：      科室信息
/// 科室类型为 Execute 且部门组为 门急诊科室  是执行科室  
/// 科室类型为 Execute 且部门组为  临床科室  是执行科室
/// 科室类型为 Ward 且部门组为  护理单元  是病区
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetLocation(1)
ClassMethod GetLocation(aLocId As %String = "") As %String
{
	New (aLocId)
	Set return=""
	Quit:aLocId="" return
	
	Set $ZT="GetLocationErr"
	Set LocInfo = $g(^CTLOC(aLocId))
	Quit:LocInfo="" return
	
	Set HospID  = $p(LocInfo,"^",22)
	Set:HospID="" HospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set LocCode = $p(LocInfo,"^",1)
	Set LocDesc = $p(LocInfo,"^",2)
	
	Set LocType = $p(LocInfo,"^",13)	//科室类型（E执行科室、W病区、O辅助科室）
  
	// 1204206 同步科室时根据his【部门组】划分 执行科室/病区/辅助科室
	Set LocDepDr=$p(LocInfo,"^",19)
	Set DEPDesc=""
	Set:LocDepDr'="" DEPDesc=$P($g(^RBC("DEP",LocDepDr)),"^",2)
	//Set strFiltLocE="门急诊科室,临床科室",strFiltLocW="护理单元"
	//Set:((LocType="E")&&(strFiltLocE'[DEPDesc)) LocType="O"
	//Set:((LocType="W")&&(strFiltLocW'[DEPDesc)) LocType="O"
	Set:((LocType="E")&&(DEPDesc'["门诊")&&(DEPDesc'["急诊")&&(DEPDesc'["住院")&&(DEPDesc'["临床科室")) LocType="O"
	Set:((LocType="W")&&(DEPDesc'["病区")&&(DEPDesc'["护理单元")&&(DEPDesc'["病房")) LocType="O"
	Set:LocType="EM" LocType="W"
	Set LocCate = ""  //科室标记（O门诊、E急诊、I住院）
	Set:LocType="W" LocCate="I"	
    Set LocCateList=$lb("O","E","I")  
    If (LocType="E") {
	    For indC=1:1:$l(LocCateList) {
		    Set xLocCate=$lg(LocCateList,indC)
		    Continue:xLocCate=""
			Continue:('$d(^PAC("ADMLOC",0,"AdmType",xLocCate,aLocId)))
			Set LocCate= xLocCate
		}
    }
			
	Set HospCode="",HospDesc=""
	if HospID'=""{
		Set HospCode = $p($g(^CT("HOSP",HospID)),"^",1)
		Set HospDesc = $p($g(^CT("HOSP",HospID)),"^",2)
	}
	Set IsActive = 1
	Set:LocDesc["停用" IsActive=0
	//根据日期判断是否有效
	Set StartDate = $p(LocInfo,"^",24)
	Set EndDate = $p(LocInfo,"^",25)
	
	if ((EndDate'="")&(EndDate<$p($h,",",1))){
		Set IsActive = 0
	}
	
	Set return = aLocId_"^"_LocCode_"^"_LocDesc_"^"_LocType_"^"_LocCate_"^"_HospID_"^"_HospCode_"^"_HospDesc_"^"_IsActive
	Quit return
GetLocationErr
	Quit "-999^"_$ZError
}

/// Creator：     liyi
/// CreatDate：   2017-06-30
/// Description:  取HIS用户信息
/// Table：       SS_User
/// Input：       aUserId：HIS用户ID
/// Return：      科室信息
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetUser(1)
ClassMethod GetUser(aUserId As %String = "") As %String
{
	New (aUserId)
	Set return=""
	Quit:aUserId="" return
	
	Set $ZT="GetUserErr"
	Set UserInfo = $g(^SSU("SSUSR",aUserId))
	Quit:UserInfo="" return
	
	Set UserCode = $p(UserInfo,"^",1)
	Set UserDesc = $p(UserInfo,"^",2)
	Set Password = $p(UserInfo,"^",3)
	Set IsActive = $p(UserInfo,"^",19)
	Set IsActive = $s(IsActive="Y":1,IsActive="N":0,1:0)
	//默认科室信息
	Set LocCode="",LocDesc=""
	Set LocId	 = $p(UserInfo,"^",4)
	if LocId'=""{
		Set LocInfo	 = $g(^CTLOC(LocId))
		Set LocCode  = $p(LocInfo,"^",1)
		Set LocDesc  = $p(LocInfo,"^",2)
	}
	//医护类型（医生D、护士N）
	Set UserType="",CarPrvTpCode="",CareProvCode="",CareProvDesc=""
	Set CareProvDr = $p(UserInfo,"^",14)
	If CareProvDr'="" {
		Set CareProvCode=$p($g(^CTPCP(CareProvDr,1)),"^",1)
		Set CareProvDesc=$p($g(^CTPCP(CareProvDr,1)),"^",2)
		Set CarPrvTpDr=$p($g(^CTPCP(CareProvDr,1)),"^",4)
		Set:CarPrvTpDr'="" CarPrvTpCode=$p($g(^CT("CPT",CarPrvTpDr)),"^",4)
		Set UserType=$s(CarPrvTpCode="DOCTOR":"D",CarPrvTpCode="NURSE":"N",1:"")
	}
	Set return = aUserId_"^"_UserCode_"^"_UserDesc_"^"_Password_"^"_LocId_"^"_LocCode_"^"_LocDesc_"^"_UserType_"^"_IsActive_"^"_CareProvDr_"^"_CareProvCode_"^"_CareProvDesc
	Quit return
GetUserErr
	Quit "-999^"_$ZError
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询治疗医嘱+抗菌用药字典
/// Table：        ARC_ItmMast
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromHisSrv","GetArcimDic")
Query GetArcimDic() As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String,ArcOrdType:%String,ArcCatDesc:%String,ArcSubCatDesc:%String,PHCCatDesc:%String,PHCSubCatDesc:%String,PHCPoisonDesc:%String,AntiFlag:%String,PHCGeneric:%String,PHChemical:%String,IsActive:%String")
{
}

ClassMethod GetArcimDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^ARCIM(xID))
		Quit:xID=""
		
		Set ArcimID=xID_"||1"
		Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		//医嘱项代码
		Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)		//医嘱项名称
		Set ArcSubCatDr=$p($g(^ARCIM(+ArcimID,1,1)),"^",10)
		Set ArcSubCatDesc=$p($g(^ARC("IC",+ArcSubCatDr)),"^",2)	//医嘱子类
		Set ArcCatDr=$p($g(^ARC("IC",+ArcSubCatDr)),"^",8)
		Set ArcCatDesc=$p($g(^OEC("ORCAT",+ArcCatDr)),"^",2) 	//医嘱大类
		Set ArcOrdType=$p($g(^ARC("IC",+ArcSubCatDr)),"^",7)	//医嘱类型（药品R、检验L）
		Continue:ArcSubCatDesc=""
		Set IsActive=1
		Set EffDateTo=$p($g(^ARCIM(+ArcimID,1,7)),"^",1)
		If EffDateTo'="" {
			If EffDateTo<(+$h) {
				Set IsActive=0
			}
		}
		
		//PHC_DrgForm:药学形态
		Set DrgFormID=$p($g(^ARCIM(+ArcimID,1,1)),"^",12)
		//PHC_DrgMast药理学项
		Set DrgMastID=+DrgFormID
		//PHC_SubCat药理学子分类
		Set PHCSubCatDr=$p($g(^PHCD(DrgMastID,1)),"^",3)
		Set PHCSubCatCode=$p($g(^PHCC(+PHCSubCatDr,"SC",+$p(PHCSubCatDr,"||",2))),"^",1)
		Set PHCSubCatDesc=$p($g(^PHCC(+PHCSubCatDr,"SC",+$p(PHCSubCatDr,"||",2))),"^",2)
		
		//PHC_Generic药品通用名 add by zf 20171128
		Set PHCGenericDr=+$p($g(^PHCD(DrgMastID,4)),"^",1)
		Set PHCGeneric=""
		Set:PHCGenericDr'="" PHCGeneric=$p($g(^PHCGE("GE",PHCGenericDr)),"^",2)
		//DHCPHChemical药品化学名  add by zf 20171128
		//还未完成，暂时预留出字段
		Set PHChemicalDr=""    //PHC_DrgFormExt表  $p($g(^PHCD(+DrgFormID,"DF",+$p(DrgFormID,"||",2),"DHC")),"^",???)
		Set PHChemical=""
		Set:PHChemicalDr'="" PHChemical=$p($g(^DHCPHCM(PHChemicalDr)),"^",2)
		
		//PHC_Cat药理学分类
		Set PHCCatDr=+PHCSubCatDr
		Set PHCCatCode=$p($g(^PHCC(PHCCatDr)),"^",1)
		Set PHCCatDesc=$p($g(^PHCC(PHCCatDr)),"^",2)
		//PHC_Poison  管制分类
		Set PHCPoisonDr=$p($g(^PHCD(DrgMastID,1)),"^",4)
		Set PHCPoisonCode=$p($g(^PHCPO(+PHCPoisonDr)),"^",1)
		Set PHCPoisonDesc=$p($g(^PHCPO(+PHCPoisonDr)),"^",2)
		//抗生素标志
		Set AntiFlag=$p($g(^PHCD(+DrgFormID,"DF",+$p(DrgFormID,"||",2),"DHC")),"^",8)
		Set AntiFlag=$s(AntiFlag="Y":1,1:0)
		
		Set Data=$lb(ArcimID,ArcimCode,ArcimDesc,ArcOrdType,ArcCatDesc,ArcSubCatDesc,PHCCatDesc,PHCSubCatDesc,PHCPoisonDesc,AntiFlag,PHCGeneric,PHChemical,IsActive)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetArcimDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcimDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArcimDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcimDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      liyi
/// CreatDate：    2018-05-08
/// Description:   查询科室关联科室
/// Table：        CT_LOC
/// Input：        LocIdD
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromHisSrv","GetLinkLocation","1")
Query GetLinkLocation(aLocID As %String) As %Query(ROWSPEC = "LinkLocID:%String,LinkLocDesc:%String")
{
}

ClassMethod GetLinkLocationExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xLinkSub=0
	For	{
		Set xLinkSub=$o(^CTLOC(aLocID,"LINK",xLinkSub))
		Quit:xLinkSub=""
		
		If xLinkSub'=0{
			Set LinkLocID = $g(^CTLOC(aLocID,"LINK",xLinkSub))
			Set LocInfo = $g(^CTLOC(LinkLocID))
			Set LocDesc = $p(LocInfo,"^",2)
			set Data=$lb(LinkLocID,LocDesc)
	    	set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetLinkLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLinkLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLinkLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLinkLocationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  通过就诊号取会诊数据
/// Input：       aEpisodeID:就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DIO.FromHisSrv).GetEmConsult(54197715,"2019-05-01","2019-08-26")
ClassMethod GetEmConsult(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set $ZT="GetEmConsultErr"
	
	Set xEmID="" 
	For {
		Set xEmID =$o(^DHCEMCON(0,"ADM",aEpisodeID,xEmID))
		Quit:xEmID=""
	    
	    Set (CLocDr,OrdItemDr)=""
	    Set xSubID = ""
	    For {
			Set xSubID =$o(^DHCEMCON(xEmID,"I",xSubID))
			Quit:xSubID=""
			
			Set CLocDr = $p(^DHCEMCON(xEmID,"I",xSubID),"^",1)      //会诊科室
			Set OrdItemDr = $p(^DHCEMCON(xEmID,"I",xSubID),"^",10)  //会诊医嘱
	    }
	    Continue:OrdItemDr=""
	    Set RLocDr      = $p(^DHCEMCON(xEmID),"^",2)     // 申请科室
		Set RDate       = $p(^DHCEMCON(xEmID),"^",3)     // 申请日期
		Continue:((aDateFrom'="")&&(RDate<aDateFrom))
		Continue:((aDateTo'="")&&(RDate>aDateTo))
		
		Set RTime       = $p(^DHCEMCON(xEmID),"^",4)      // 申请时间
		Set RUserDr     = $p(^DHCEMCON(xEmID),"^",5)      // 申请医生 
		Set TrePro      = $p(^DHCEMCON(xEmID),"^",6)      // 病情及诊疗经过  
		Set Purpose     = $p(^DHCEMCON(xEmID),"^",7)      // 会诊的理由和目的 
		Set Category    = $p(^DHCEMCON(xEmID),"^",8)      // 会诊类别  
		Set DocLev      = $p(^DHCEMCON(xEmID),"^",9)      // 医生级别  
		Set NDate       = $p(^DHCEMCON(xEmID),"^",10)     // 会诊日期 
		Set NTime       = $p(^DHCEMCON(xEmID),"^",11)     // 会诊时间
		Set NPlace      = $p(^DHCEMCON(xEmID),"^",12)     // 会诊地点  
		Set ALocDr      = $p(^DHCEMCON(xEmID),"^",13)     // 审核科室  
		Set AUserDr     = $p(^DHCEMCON(xEmID),"^",14)     // 审核人 
		Set ADate       = $p(^DHCEMCON(xEmID),"^",15)     // 审核日期 
		Set ATime       = $p(^DHCEMCON(xEmID),"^",16)     // 审核时间 
		Set TreMeasures = $p(^DHCEMCON(xEmID),"^",17)     // 最终治疗措施  
		Set RStatus     = $p(^DHCEMCON(xEmID),"^",18)     // 申请状态 
		 
		Set Status      = $p(^DHCEMCONS(RStatus),"^",2)   
		Continue:Status'="完成"                           
		Set Type        = $p(^DHCEMCON(xEmID),"^",19)     // 会诊类型
		Continue:Type="DOCA"    //抗菌药物申请不同步      
		Set CDate       = $p(^DHCEMCON(xEmID),"^",20)     // 完成日期  
		Set CTime       = $p(^DHCEMCON(xEmID),"^",21)     // 完成时间  
		Set CUserDr     = $p(^DHCEMCON(xEmID),"^",22)     // 完成人 
		Set EmFlag      = $p(^DHCEMCON(xEmID),"^",23)     // 会诊科室 
		Set OutFlag     = $p(^DHCEMCON(xEmID),"^",24)     // 是否加急  
		Set Opintion    = $p(^DHCEMCON(xEmID),"^",34)     // 是否院外  
		Set Opintion    = $tr(Opintion," ","")            // 会诊意见 
		Set ConsentAnti = $p(^DHCEMCON(xEmID),"^",35)     // 是否同意使用抗生素 
		
		Set Data = $lb(xEmID,OrdItemDr,RLocDr,RDate,RTime,RUserDr,TrePro,Purpose,Category,DocLev,NDate,NTime,NPlace,ALocDr,AUserDr,ADate,ATime,TreMeasures,RStatus,Type,CDate,CTime,CUserDr,CLocDr,EmFlag,OutFlag,Opintion,ConsentAnti)
		Set return = return_$lb(Data)
	}
	Quit return
GetEmConsultErr
	Quit "-999^"_$ZError
}

}
