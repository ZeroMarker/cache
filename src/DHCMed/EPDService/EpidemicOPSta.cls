Class DHCMed.EPDService.EpidemicOPSta Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 统计分析门诊传染病发病情况
/// w ##class(DHCMed.EPDService.EpidemicOPSta).GetColumnList()
ClassMethod GetColumnList() As %String
{
	n
	Set ret=""
	Set $p(ret,"^",1)="科室"
	Set $p(ret,"^",2)="门诊数量"
	Set $p(ret,"^",3)="总计应报"
	Set $p(ret,"^",4)="总计未报"
	Set $p(ret,"^",5)="漏报率"
	
	Set intCounter=6
	Set rowid=""
	For {
		Set rowid=$o(^DHCMed.SS.DictionaryI("IdxofType"," EPDEMICTYPE",rowid))
		Quit:rowid=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(rowid)
		Do objDic.%Close()
		
		Set $p(ret,"^",intCounter)=objDic.Description_"-应报"
		Set intCounter=intCounter+1
		Set $p(ret,"^",intCounter)=objDic.Description_"-未报"
		Set intCounter=intCounter+1
		Kill objDic
	}
	
	Quit ret
}

/// w ##class(DHCMed.EPDService.EpidemicOPSta).Sta("2008-08-01","2008-08-10","","")
ClassMethod Sta(FromDate As %String, ToDate As %String, Loc As %String, HospitalID As %String)
{
	Kill ^CacheTemp
	
	//Set:FromDate["-" FromDate=$zdh(FromDate,3)
	//Set:FromDate["/" FromDate=$zdh(FromDate,4)
	//Set:ToDate["-" ToDate=$zdh(ToDate,3)
	//Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set FromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FromDate)
	Set ToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ToDate)
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:$IsObject(objSubject)=0 -1
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	

	Set repid=$I(^CacheTemp)
	Set ind=1
	
	Set StoreID=##class(DHCMed.CCService.System.VMShell).CreateStoreID()
	Set tmpDate=""
	For tmpDate=FromDate:1:ToDate {
		Set paadm=""
		For {
			set paadm=$o(^PAADMi("PAADM_AdmDate",tmpDate,paadm))
			Quit:paadm=""
			Continue:$d(^PAADMi("PAADM_Type","O",paadm))=0
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
			Do objAdm.%Close()
			Continue:((objAdm.DepartmentID'=Loc)&&(Loc'=""))
			Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(objAdm.DepartmentID)
			Do objCtloc.%Close()
			Continue:((objCtloc.HospitalDr'=HospitalID)&&(HospitalID'=""))
			Set tmp=##class(DHCMed.CCService.System.VMShell).SaveStorePaadm(StoreID,paadm)
		}
	}
	Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,StoreID,"")
	Set handle=$li(ret,2)
	
	s paadm="" f  s paadm=$o(^CacheTemp(handle,"Paadm",paadm)) q:paadm=""  d
	.Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	.Do objAdm.%Close()	
	.Set summaryInfo=$g(^CacheTemp(handle,"Paadm",paadm))
	.Set TotalScore=$p(summaryInfo,"^",1) //总分
	.Set tmpDepData=$g(^CacheTemp(repid,"Result", objAdm.DepartmentID))
	.Set $p(tmpDepData,"^",1)=$p(tmpDepData,"^",1)+1 //总数
	.Quit:TotalScore=0 //没有发现问题
	.Set $p(tmpDepData,"^",2)=$p(tmpDepData,"^",2)+1 //应报
	.s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	..Set itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	..Do itemDic.%Close()
	..Quit:$d(^DHCMed.EPDCi("IF",0,"ICD",itemDic.IDCode))=0
	..Set infectionID=$o(^DHCMed.EPDCi("IF",0,"ICD",itemDic.IDCode,""))
	..Set objInf=##class(DHCMed.EPD.Infection).GetObjById(infectionID)
	..Quit:$IsObject(objInf)=0
	..Quit:objInf.MIFIsActive'="Y"
	..Set tmpDisData=$g(^CacheTemp(repid,"Result",objAdm.DepartmentID,"Disease",objInf.MIFKind))
	..Do objInf.%Close()
	..Set $p(tmpDisData,"^",1)=$p(tmpDisData,"^",1)+1 //应报
	..Set EpdFlag=##class(DHCMed.EPDService.EpidemicSrv).IsReported(paadm,infectionID)
	..Set:EpdFlag=0 $p(tmpDisData,"^",2)=$p(tmpDisData,"^",2)+1 //未报
	..Set:EpdFlag=0 $p(tmpDepData,"^",3)=$p(tmpDepData,"^",3)+1 //科室总未报
	..Set ^CacheTemp(repid,"Result",objAdm.DepartmentID,"Disease",objInf.MIFKind)=tmpDisData
	.Set ^CacheTemp(repid,"Result", objAdm.DepartmentID)=tmpDepData
	..s itemDic=""
	..k itemDic
	..k objAdm
	
	Set loc=""
	For {
		Set loc=$o(^CacheTemp(repid,"Result",loc))
		Quit:loc=""
		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(loc)
		Do objLoc.%Close()
		Set tmpDepData=$g(^CacheTemp(repid,"Result",objLoc.Rowid))
		Set data=$lb("")
		Set $li(data,1)=objLoc.Descs //科室
		Set $li(data,2)=$p(tmpDepData,"^",1) //总数
		Set $li(data,3)=$p(tmpDepData,"^",2) //应报
		Set $li(data,4)=$p(tmpDepData,"^",3) //未报
		Set $li(data,5)="" 
		Set $li(data,5)=$number($p(tmpDepData,"^",3)/$p(tmpDepData,"^",1)*100,2)_"%" //漏报率
		Set Counter=6
		Set rowid=""
		For {
			Set rowid=$o(^DHCMed.SS.DictionaryI("IdxofType"," EPDEMICTYPE",rowid))
			Quit:rowid=""
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(rowid)
			Do objDic.%Close()
			
			Set tmpDisData=$g(^CacheTemp(repid,"Result",loc,"Disease",objDic.Code))
			Set $li(data,Counter)=$p(tmpDisData,"^",1) //疾病未报
			Set $li(data,Counter+1)=$p(tmpDisData,"^",2) //疾病未报
			Set Counter=Counter+2
			Kill objDic
		}
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	
	Kill ^CacheTemp(handle)
	Kill ^CacheTemp(StoreID)
	Kill ^CacheTemp(repid,"Result")
	Quit repid
}

/// w ##Class(DHCMed.EPDService.EpidemicOPSta).getEPDDicList()
ClassMethod getEPDDicList()
{
	New
	Set return=""
	
	/* update by zf 20111014
	Set DicID=0
	For {
		//^DHCMed.SS.DictionaryI("IndexTypeCode"," EPDEMICTYPE"," 1",1008)
		Set DicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," EPDEMICTYPE",DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set DicDesc=objDic.Description
		Continue:DicDesc=""
		Set return=return_$lb(DicDesc)
	}
	*/
	
	Set IFRowid=0
	For {
		Set IFRowid=$o(^DHCMed.EPDC("IF",IFRowid))
		Quit:IFRowid=""
		Set objIF=##class(DHCMed.EPD.Infection).GetObjById(IFRowid)
		Continue:'$IsObject(objIF)
		Continue:objIF.MIFIsActive'="Y"
		Set IFKind=objIF.MIFKind
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
		Set:$IsObject(objDic) IFKind=objDic.Description
		Continue:IFKind="AFP"  //AFP暂时不考虑
		Set DicDesc=objIF.MIFDisease
		Continue:DicDesc=""
		Set return=return_$lb(DicDesc)
	}
	Set return=return_$lb("AFP")
	//w $listtostring(return,"^"),!
	
	Quit return
}

/// w ##Class(DHCMed.EPDService.EpidemicOPSta).BuildJsonToOPStatHeader()
ClassMethod BuildJsonToOPStatHeader() As %String
{
	New
	Set return=""
	
	Set $ZT="BuildJsonToOPStatHeaderErr"
	
	Set epdList=..getEPDDicList()
	
	Set gridHeader=""
	Set gridHeader=gridHeader_"var gridHeader=["
	Set gridHeader=gridHeader_"	{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: 1}"
	Set gridHeader=gridHeader_"	,{header: '共计',align: 'center',colspan: 2}"
	Set gridHeader=gridHeader_"	,{header: '',align: 'center',colspan: 1}"
	For epdIndex=1:1:$listlength(epdList) {
		Set EpdDesc=$list(epdList,epdIndex)
		Set gridHeader=gridHeader_"	,{header: '"_EpdDesc_"',align: 'center',colspan: 2}"
	}
	Set gridHeader=gridHeader_"];"
	
	Set gridColumn=""
	Set gridColumn=gridColumn_"var gridColumn=["
	Set gridColumn=gridColumn_"	{header: '科室名称',width: 200,align: 'center',sortable: false,dataIndex: 'LocDesc'}"
	Set gridColumn=gridColumn_"	,{header: '就诊人次',width: 80,align: 'center',sortable: false,dataIndex: 'AdmCount'}"
	Set gridColumn=gridColumn_"	,{header: '应报',width: 50,align: 'center',sortable: true,dataIndex: 'EPDCount1'}"
	Set gridColumn=gridColumn_"	,{header: '未报',width: 50,align: 'center',sortable: true,dataIndex: 'EPDCount2'}"
	Set gridColumn=gridColumn_"	,{header: '漏报率%',width: 80,align: 'center',sortable: true,dataIndex: 'EPDRatio'}"
	For epdIndex=1:1:$listlength(epdList) {
		Set gridColumn=gridColumn_"	,{header: '应报',width: 50,align: 'center',sortable: false,dataIndex: 'EPD"_epdIndex_"Num1'}"
		Set gridColumn=gridColumn_"	,{header: '未报',width: 50,align: 'center',sortable: false,dataIndex: 'EPD"_epdIndex_"Num2'}"
	}
	Set gridColumn=gridColumn_"];"
	
	Set storeFields=""
	Set storeFields=storeFields_"var storeFields=["
	Set storeFields=storeFields_"	{name: 'LocDesc', mapping: 'LocDesc'}"
	Set storeFields=storeFields_"	,{name: 'AdmCount', mapping: 'AdmCount'}"
	Set storeFields=storeFields_"	,{name: 'EPDCount1', mapping: 'EPDCount1'}"
	Set storeFields=storeFields_"	,{name: 'EPDCount2', mapping: 'EPDCount2'}"
	Set storeFields=storeFields_"	,{name: 'EPDRatio', mapping: 'EPDRatio'}"
	For epdIndex=1:1:$listlength(epdList) {
		Set storeFields=storeFields_"	,{name: 'EPD"_epdIndex_"Num1', mapping: 'EPD"_epdIndex_"Num1'}"
		Set storeFields=storeFields_"	,{name: 'EPD"_epdIndex_"Num2', mapping: 'EPD"_epdIndex_"Num2'}"
	}
	Set storeFields=storeFields_"];"
	
	Set return=gridHeader_" "_gridColumn_" "_storeFields
	Quit return
	
BuildJsonToOPStatHeaderErr
	Quit ""
}

/// w ##Class(DHCMed.EPDService.EpidemicOPSta).BuildJsonToOPStatStore("2011-08-01","2011-09-01","","")
ClassMethod BuildJsonToOPStatStore(argDateFrom As %String, argDateTo As %String, argHospID As %String, argLocID As %String, RepPlace As %String) As %String
{
	New (argDateFrom, argDateTo, argHospID, argLocID, RepPlace)
	Set return=0,Count=0
	
	Set $ZT="BuildJsonToOPStatStoreErr"
	
	Write "{record:[",!
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "DHCMed.EPDService.EpidemicOPSta"
	Set rset.QueryName = "QryOPStatInfo"
	Do rset.Execute(argDateFrom, argDateTo, argHospID, argLocID, RepPlace)
	While (rset.Next(.sc))
	{
		If ($SYSTEM.Status.IsOK(sc))
		{
			Set Count=Count+1
			Write:Count>1 ","
			Set json=""
			Set json=json_"{"
			Set json=json_"LocDesc:'"_rset.Data("LocDesc")_"'"
			Set json=json_",AdmCount:'"_rset.Data("AdmCount")_"'"
			Set EPDNumList=rset.Data("EPDNumList")
			For epdNumIndex=1:1:$l(EPDNumList,",") {
				Set tmpNum=$p(EPDNumList,",",epdNumIndex)
				Set tmpNum1=$p(tmpNum,"/",1)
				Set tmpNum2=$p(tmpNum,"/",2)
				Set json=json_",EPD"_epdNumIndex_"Num1:'"_tmpNum1_"'"
				Set json=json_",EPD"_epdNumIndex_"Num2:'"_tmpNum2_"'"
			}
			Set json=json_",EPDCount1:'"_rset.Data("EPDCount1")_"'"
			Set json=json_",EPDCount2:'"_rset.Data("EPDCount2")_"'"
			Set json=json_",EPDRatio:'"_rset.Data("EPDRatio")_"'"
			Set json=json_"}"
			Write json,!
		}Else{ Quit }
	}
	Write "],total : "_Count_"}"
	
	Set return=1
	Quit return
	
BuildJsonToOPStatStoreErr
	Write "],total : "_Count_"}"
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2011-08-08
/// Description:  查询科室传染病统计
/// Input：       
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicOPSta","QryOPStatInfo","2009-01-01","2009-02-01","","","I")
Query QryOPStatInfo(argDateFrom As %String, argDateTo As %String, argHospID As %String, argLocID As %String, RepPlace As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,AdmCount:%String,EPDNumList:%String,EPDCount1:%String,EPDCount2:%String,EPDRatio:%String")
{
}

ClassMethod QryOPStatInfoExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argHospID As %String, argLocID As %String, RepPlace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	//Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	//Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	//Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	//Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set argDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argDateFrom)
	Set argDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argDateTo)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set epdList=..getEPDDicList()
	
	/* update by zf 2012-05-02
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	If SubjectID'="" {
		Set %ZIndex=$zn,%JIndex=$j
		Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
		Set flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList(SubjectID,"")
		//Quit:flg<1 $$$OK
	}
	*/
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryOPStatInfo")
	
	For AdmDate=argDateFrom:1:argDateTo {
		Set Paadm=""
		For {
			Set Paadm=$o(^PAADMi("PAADM_AdmDate",AdmDate,Paadm))
			Quit:Paadm=""
			Set AdmType=$p($g(^PAADM(Paadm)),"^",2)
			//Continue:(AdmType'="O")&&(AdmType'="E")
			Set AdmLoc=+$p($g(^PAADM(Paadm)),"^",4)
			Continue:AdmLoc=""
			Continue:(argLocID'="")&&(argLocID'=AdmLoc)
			Set AdmHosp=+$p($g(^CTLOC(+AdmLoc)),"^",22)
			//Continue:(argHospID'="")&&(argHospID'=AdmHosp)
			if argHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,argHospID)
				continue:flg<1
			}
			
			If AdmType="I" {
				Set rRepPlace="I"	//病房
			} ElseIf AdmType="E" {
				Set rRepPlace="E"	//急诊
			} ElseIf AdmType="O" {
				Set rRepPlace="O"	//门诊
			} ElseIf AdmType="H" {
				Set rRepPlace="H"	//体检
			} Else {
				Set rRepPlace=""    //其他
			}
			Set:RepPlace="ALL" RepPlace=""
			Continue:((RepPlace'="")&&(RepPlace'=rRepPlace))
			
			Set num=$i(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"AdmCount"))  //科室就诊人次
			Set repEpdList=##class(DHCMed.EPDService.Service).getEpdDescList(Paadm)
			For epdIndex=1:1:$listlength(repEpdList) {
				Set EpdDesc=$list(repEpdList,epdIndex)
				Set:EpdDesc["AFP" EpdDesc="AFP"
				Set ^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num1",EpdDesc)=$i(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num1",EpdDesc))  //应报传染病
				Set ^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num0",EpdDesc)=$i(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num0",EpdDesc))  //已报传染病
				Set ^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Paadm",EpdDesc,Paadm)=""
			}
			
			//update by zf 2012-05-02
			//Set %ZIndex=ZIndex,%JIndex=JIndex
			//Set ctlResult=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm)
			Set ctlResult=""
			If ctlResult'="" {
				For ctlIndex=1:1:$listlength(ctlResult) {
					Set ctlData=$list(ctlResult,ctlIndex)
					If ctlData'="" {
						Set Desc=$list(ctlData,1)
						Set ErrorList=$list(ctlData,4)
						If ErrorList'="" {
							Set ErrorDesc=$list(ErrorList,2)
							Set Desc=Desc_","_ErrorDesc
						}
						Continue:Desc=""       //监控信息
						For epdIndex=1:1:$listlength(epdList) {
							Set EpdDesc=$list(epdList,epdIndex)
							If Desc[EpdDesc {
								If '$d(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Paadm",EpdDesc,Paadm)) {
									Set num=$i(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num1",EpdDesc))  //应报传染病
									Set ^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Paadm",EpdDesc,Paadm)=""
								}
							}
						}
					}
				}
			}
			
			//传染病未报
			Set EPDNotRepDiag=..GetEpdNotRepDiagnos(Paadm)
			if EPDNotRepDiag'="" {
				;w Paadm,!
				For epdIndex=1:1:$listlength(EPDNotRepDiag) {
					Set EpdDesc=$list(EPDNotRepDiag,epdIndex)
					Continue:EpdDesc=""
					Set:EpdDesc["AFP" EpdDesc="AFP"
							
					If '$d(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Paadm",EpdDesc,Paadm)) {
						Set num=$i(^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Num1",EpdDesc))  //应报传染病
						Set ^TMP(ZIndex,JIndex,"QryOPStatInfo",AdmHosp,AdmLoc,"Paadm",EpdDesc,Paadm)=""
					}
				}
			}
		}
	}
	
	Set HospID=""
	For {
		Set HospID=$o(^TMP(ZIndex,JIndex,"QryOPStatInfo",HospID))
		Quit:HospID=""
		Set LocID=""
		For {
			Set LocID=$o(^TMP(ZIndex,JIndex,"QryOPStatInfo",HospID,LocID))
			Quit:LocID=""
			Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Continue:LocDesc=""
			Set EPDNumList="",EPDCount1=0,EPDCount2=0
			For epdIndex=1:1:$listlength(epdList) {
				Set EpdDesc=$list(epdList,epdIndex)
				Set Num0=+$g(^TMP(ZIndex,JIndex,"QryOPStatInfo",HospID,LocID,"Num0",EpdDesc))
				Set Num1=+$g(^TMP(ZIndex,JIndex,"QryOPStatInfo",HospID,LocID,"Num1",EpdDesc))
				Set Num2=Num1-Num0
				Set EPDNumList=EPDNumList_","_Num1_"/"_Num2
				Set EPDCount1=EPDCount1+Num1
				Set EPDCount2=EPDCount2+Num2
			}
			If EPDCount1'=0 {
				Set EPDRatio=$fn((EPDCount2/EPDCount1)*100,"",2)_"%"   //漏报率
			}Else{
				Set EPDRatio="0.00%"
			}
			Set:EPDNumList'="" EPDNumList=$e(EPDNumList,2,$l(EPDNumList))
			Set AdmCount=+$g(^TMP(ZIndex,JIndex,"QryOPStatInfo",HospID,LocID,"AdmCount"))
			Set Data=$lb(LocID,LocDesc,AdmCount,EPDNumList,EPDCount1,EPDCount2,EPDRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryOPStatInfo")
	
	Quit $$$OK
}

ClassMethod QryOPStatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPStatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPStatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPStatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{			    	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     maxp
/// CreatDate：   2016-04-26
/// Description:  
///               传染病报卡患者返回传染病未报分类名称列表
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID:    User.PAADM
/// Return：      %String
/// w ##class(DHCMed.EPDService.Service).GetEpdNotRepDiagnos(1727)
ClassMethod GetEpdNotRepDiagnos(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEpdNotRepDiagnosErr"
	
	Set CasesXOutDiag=##class(DHCMed.EPDService.CasesXSrv).GetOutDiagnos(aEpisodeID,"EPDCC")
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,"","")
	
	Set EpdICDs="",EpdNotRepList=""
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(aEpisodeID)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set ICD10=objRec.ICD10
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		
		Continue:$listfind(CasesXOutDiag,ICDDesc)>0 //传染病筛查处置 已排除
		
		Set flg=##class(DHCMed.CCService.Library.MRDiagnos).CheckIsEPD(ICD10,ICDDesc,Comments)
		Continue:flg=""
		Set EPDDiagnos=flg
		
		Set DiagnosList=##class(DHCMed.EPDService.Service).getEpdList(aEpisodeID) //已上报
		
		For indEpd=1:1:$l(EPDDiagnos,",") {
			Set xEpdIFID=$p(EPDDiagnos,",",indEpd)
			Continue:xEpdIFID=""
			Set tmpEpdIFDesc=$p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",2)
			Continue:tmpEpdIFDesc=""
			
			Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",3)
			continue:$listfind(DiagnosList,IFDiagnosMIFKind)>0 //根据大类判断是否已报
			Continue:$listfind(EpdNotRepList,IFDiagnosMIFKind)>0 //根据大类取未报描述
			
			Set IFRank=$p($g(^DHCMed.EPDC("IF",+xEpdIFID)),"^",4)
			Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",+IFRank,"")
			Continue:'$IsObject(objIFRank)
			Set IFRankDesc=objIFRank.Description
			Continue:(IFRankDesc["AFP")&&((+PatAge)>(+AFPAgeMax)) //AFP年龄限制
			
			Set EpdNotRepList=EpdNotRepList_$lb(IFDiagnosMIFKind)
			Set:IFRankDesc["AFP" tmpEpdIFDesc="(AFP)"_tmpEpdIFDesc
			Set EpdICDs=EpdICDs_$lb(tmpEpdIFDesc)
		}
	}
	
	Set return=EpdICDs
	
	Quit return
	
GetEpdNotRepDiagnosErr
	Quit ""
}

}
