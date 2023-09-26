/// 创建者：李阳
/// 创建日期：2011-07-11
/// 传染病监控（我的监控程序）
Class DHCMed.EPDService.EpdControl Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##class(DHCMed.EPDService.EpdControl).SinglePatientControl(74407)
ClassMethod SinglePatientControl(Paadm As %String)
{
	New (Paadm)
	Set return=""
	Quit:Paadm="" return
	
	Set $ZT="SinglePatientControlErr"
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set ctlResult=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm,SubjectID,"")
	If ctlResult'="" {
		For ctlIndex=1:1:$listlength(ctlResult) {
			Set ctlData=$list(ctlResult,ctlIndex)
			If ctlData'="" {
				Set Desc=$list(ctlData,1)
				Continue:Desc=""
				Set ErrorList=$list(ctlData,4)
				If ErrorList'="" {
					Set ErrorDesc=$list(ErrorList,2)
					Set Desc=Desc_","_ErrorDesc
				}
			}
			Set return=return_";"_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
	
SinglePatientControlErr
	Quit "Error"
}

/// w ##class(DHCMed.EPDService.EpdControl).GetSinglePatientControlDesc(74407)
ClassMethod GetSinglePatientControlDesc(Paadm) As %String
{
	n (Paadm)
	Set ret=$g(^CacheTemp("EpdSinglePatientControl","Desc",Paadm))
	Kill CacheTemp("EpdSinglePatientControl","Desc",Paadm)
	Quit ret
}

ClassMethod ProcessControl(PaadmStoreRepid, SubjectItmIDList)
{
	n (SubjectID,PaadmStoreRepid,SubjectItmIDList)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:(($IsObject(objSubject)=0)&&(SubjectItmIDList="")) -1 //没有维护传染病监控的主题
	Set SubjectID=objSubject.%Id()
	Set objSubject=""
	Kill objSubject
	Set:SubjectItmIDList'="" SubjectID=""
	Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,PaadmStoreRepid,SubjectItmIDList)
	Kill ^CacheTemp(PaadmStoreRepid)
	Quit ret
}

/// 生成查询Paadm列表
/// FromDate:开始日期
/// ToDate：结束日期
/// Days:放大天数,FromDate会减去这个天数，ToDate会增加这个天数
/// 生成Paadm列表的范围：从FromDate-Days至ToDate-Days的所有入院病人（包括门诊、住院）以及所有在院住院病人列表
/// w ##class(DHCMed.EPDService.Control).CreatePaadmList("2008-08-01","2008-08-01",1)
ClassMethod CreatePaadmList(FromDate, ToDate, Days)
{
	n (FromDate,ToDate,Days)
	Set repid=##class(DHCMed.CCService.System.VMShell).CreateStoreID()
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:ToDate["/" ToDate=$zdh(ToDate,4)	
	
	//获取在某个时间段的入院（包括门诊、住院）的Paadm列表
	Set FromDate=FromDate-Days
	Set ToDate=ToDate+Days
	Set tmpDate=FromDate
	For tmpDate=FromDate:1:ToDate {
		Set Paadm=""
		For {
			Set Paadm=$o(^PAADMi("PAADM_AdmDate",tmpDate,Paadm))
			Quit:Paadm=""
			Set:Paadm'="" ret=##class(DHCMed.CCService.System.VMShell).SaveStorePaadm(repid,Paadm)
			
		}
	}
	
	//生成在院的Paadm列表
    Set Ward="" f  s Ward=$o(^PAADMi("CurrWard",Ward)) Q:Ward=""  d
    .Set Room="" f  s Room=$o(^PAADMi("CurrWard",+Ward,Room)) q:Room=""  d
    ..Set Paadm="" f  s Paadm=$o(^PAADMi("CurrWard",+Ward,Room,Paadm)) q:Paadm=""  d
    ...Set:Paadm'="" ret=##class(DHCMed.CCService.System.VMShell).SaveStorePaadm(repid,Paadm)
    ...;w Paadm,!
    Quit repid
}

/// 负责监控，
/// repid:存储paadm列表的CacheTemp(repid,paadmList)节点
/// SubjectItmIDList:子项目ID列表
/// 按照指定的监控主题运行VM进行监控,并组织数据输出
/// RuleID:监控主题
/// PaadmList:需要监控的Paadm列表
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpdControl","EpidemicControl","2008-8-1","2008-8-1",2,"")
Query EpidemicControl(FromDate As %String, ToDate As %String, Days As %String, SubjectItmIDList As %String) As %Query(ROWSPEC = "PatientID:%String,Paadm:%String,AdmType:%String:就诊类型,RegNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:就诊日期,AdmitDep:%String:就诊科室,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,FiredType:%String:触发的类别,Detail:%String,Doctor:%String:主管医师,DoctorID:%String,ICDCode:%String:ICD编码,IsRevisit:%String:复诊,IsReported:%String:是否已上报")
{
}

ClassMethod EpidemicControlExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Days As %String, SubjectItmIDList As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	;Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("InfCC")
	Quit:$IsObject(objSubject)=0 $$$OK
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set PaadmStoreRepid=..CreatePaadmList(FromDate,ToDate,Days)
	Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,PaadmStoreRepid,SubjectItmIDList)
	q:$li(ret,1)'="OK" $$$OK
	s handle=$li(ret,2)
	///PatientID:%String,Paadm:%String,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,
	///FiredType:%String:触发的类别,ItemDic:%String:监控条目,Detail:%String:详情
	s Paadm="" f  s Paadm=$o(^CacheTemp(handle,"Paadm",Paadm)) q:Paadm=""  d
	.s result=$g(^CacheTemp(handle,"Paadm",Paadm))
	.q:$p(result,"^",2)=0 //触发项目数量
	.s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	.d objAdm.%Close()
	.Set ^CacheTemp(repid,ind)=$$BuildEpidemicControl(handle,Paadm)
	.Set ind=ind+1
	Kill ^CacheTemp(PaadmStoreRepid)
	Kill ^CacheTemp(handle)
	Quit $$$OK



EmptyList(num)
	n (num)
	s data=$lb("")
	f i=1:1:num  d
	.s $li(data,i)=""
	q data

BuildEpidemicControl(handle,Paadm)
	n (handle,Paadm,Result)
	//PatientID:%String,Paadm:%String,AdmType:%String:就诊类型,RegNo:%String:就诊卡号,
	//PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:就诊日期,
	//AdmitDep:%String:就诊科室,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,
	//FiredTypeCnt:%String:触发类型数量
	Set data=$lb("")
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	Set Summary=$g(^CacheTemp(handle,"Paadm",Paadm))

	
	
	Set TotalScore=0
	Set ItemCount=0
	Set ItemList=""
	
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.;s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.;d itemSubCat.%Close()
	.s ^CacheTemp(handle,"Paadm",Paadm,"SubCate",itemDic.IDSubCatDr)=""
	
	Set TotalScore=$p(Summary,"^",1)
	Set FiredType=""
	Set subCatID=""
	Set SubTypeCnt=0
	s subCatID="" f  s subCatID=$o(^CacheTemp(handle,"Paadm",Paadm,"SubCate",subCatID)) q:subCatID=""  d
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s FiredType=FiredType_$s(FiredType'="":",",1:"")_itemSubCat.ISCDesc
	.s SubTypeCnt=SubTypeCnt+1
	
	set strDetail=""
	Set ItemCount=0
	Set ICDCode=""
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.Set ICDCode=itemDic.IDCode
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	..s:strDetail'="" strDetail=strDetail_"<BR/>"
	..s strDetail=strDetail_"<B>"_itemSubCat.ISCDesc_"--"
	..s strDetail=strDetail_itemDic.IDDesc_":</B>"
	..s strDetail=strDetail_$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter))
	..s ItemCount=ItemCount+1
	
	Set InfectionID=""
	Set:ICDCode'="" InfectionID=$o(^DHCMed.EPDCi("IF",0,"ICD",ICDCode,""))
	
	
	Set $li(data,1)=objAdm.PatientID //PatientID
	Set $li(data,2)=Paadm //Paadm
	Set $li(data,3)=objAdm.AdmType
	Set:objAdm.AdmType="O" $li(data,3)="门诊" //AdmType:%String:就诊类型
	Set:objAdm.AdmType="I" $li(data,3)="住院" //AdmType:%String:就诊类型
	Set:objAdm.AdmType="E" $li(data,3)="急诊" //AdmType:%String:就诊类型
	Set:objAdm.AdmType="H" $li(data,3)="体检" //AdmType:%String:就诊类型
	Set $li(data,4)=objPatient.PapmiNo //RegNo:%String:就诊卡号
	Set $li(data,5)=objPatient.PatientName //PatientName:%String:姓名
	Set $li(data,6)=objPatient.Sex //Sex:%String:性别
	Set $li(data,7)=objPatient.Age //Age:%String:年龄
	Set $li(data,8)=objAdm.AdmitDate //AdmitDate:%String:就诊日期
	Set $li(data,9)=objAdm.Department //AdmitDep:%String:就诊科室
	Set $li(data,10)=TotalScore   //TotalScore:%String:总分数
	Set $li(data,11)=ItemCount   //FiredItemCnt:%String:触发项目数量
	Set $li(data,12)=SubTypeCnt  //$p(Summary,"^",3)   //FiredTypeCnt:%String:触发类型数量
	Set $li(data,13)=FiredType //触发项目类别
	Set $li(data,14)=strDetail
	Set $li(data,15)=objAdm.DoctorCode_"  "_objAdm.DoctorName //主管医师
	Set $li(data,16)=objAdm.DoctorID //主管医师ID
	Set $li(data,17)=ICDCode //传染病ICD代码
	Set $li(data,18)=##class(DHCMed.EPDService.Service).IsRevisit(Paadm)  //从接口中获得是否是复诊
	Set $li(data,19)=##class(DHCMed.EPDService.EpidemicSrv).IsReported(Paadm,InfectionID)  //是否已上报传染病报告卡

	Set objAdm=""
	Set objPatient=""
	Kill objAdm
	Kill objPatient
	Quit data
}

ClassMethod EpidemicControlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EpidemicControlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EpidemicControlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EpidemicControlExecute ]
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

/// 单独患者的传染病监控
/// 查询其结果
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.EpdControl","EpidemicControlSP",74362)
Query EpidemicControlSP(Paadm As %String) As %Query(ROWSPEC = "RowNum:%String,ItemDesc:%String:项目,Result:%String:结果,Detail:%String:详情,ItemCode:%String,IsRevisit:%String:复诊,IsReported:%String:是否上报")
{
}

ClassMethod EpidemicControlSPExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	Kill ^CacheTemp
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:$IsObject(objSubject)=0 -1 //没有找到传染病监控字典
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set objSubject=""
	Kill objSubject
	
	
	Set PaadmStoreRepid=##class(DHCMed.CCService.System.VMShell).CreateStoreID()
	Set ret=##class(DHCMed.CCService.System.VMShell).SaveStorePaadm(PaadmStoreRepid,Paadm)
	Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,PaadmStoreRepid,"")
	q:$li(ret,1)'="OK" $$$OK
	s handle=$li(ret,2)
	
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	..s data=$lb("")
	..s $li(data,1)=ind
	..s $li(data,2)=itemSubCat.ISCDesc
	..s $li(data,3)=itemDic.IDDesc
	..s $li(data,4)=$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter))
	..s $li(data,5)=itemDic.IDCode //ICD 代码
	..s $li(data,6)=##class(DHCMed.EPDService.Service).IsRevisit(Paadm)
	..Set InfectionID=""
	..Set:itemDic.IDCode'="" InfectionID=$o(^DHCMed.EPDCi("IF",0,"ICD",itemDic.IDCode,""))
	..s $li(data,7)=##class(DHCMed.EPDService.EpidemicSrv).IsReported(Paadm,InfectionID)
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1			
	Quit $$$OK
}

ClassMethod EpidemicControlSPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EpidemicControlSPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EpidemicControlSPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EpidemicControlSPExecute ]
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

/// 判断一个患者是否有曾经是否上报过该疾病的传染病报告
/// 下一步：请医师工作站根据此函数返回值并配合是否复诊参数判断哪些疾病应该报卡、哪些仅仅提示
/// 参数：
///    PatientID:患者ID
///    ICD:ICD编码
///    DiseaseName :疾病名称，必须传入，因为
/// 返回值：传染病信息，格式：
/// ICD^疾病名称^传染病级别^上报时限（小时）^最小上报年龄^最大上报年龄^提示^是否复诊^是否上报（1--已上报，0--未上报）$c(2)传染病报告1：报告人^报告日期与时间$c(2)传染病报告2$c(1)<下一条数据>
/// w ##class(DHCMed.EPDService.EpdControl).CheckICDNeedReport(694,"","病毒性肝炎乙型慢性轻度")
/// w ##class(DHCMed.EPDService.EpdControl).CheckICDNeedReport(74407,"","伤寒")
ClassMethod CheckICDNeedReport(EpisodeID As %String, ICD As %String, DiseaseName As %String) As %String
{
	n (EpisodeID, ICD, DiseaseName, IsRevisit)
	Kill ^CacheTemp
	Quit:EpisodeID="" -1
	Quit:((ICD="")&&(DiseaseName="")) -2
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:$IsObject(objAdm)=0 -1
	Do objAdm.%Close()
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	Do objPatient.%Close()
	Set PatientID=objAdm.PatientID
	Set IsRevisit=##class(DHCMed.EPDService.Service).IsRevisit(EpisodeID) //是否是复诊
	
	Set ret=""
	Quit:PatientID="" ret
	Set IsReported=0
	Set ICDDr=""
	Set repid=$I(^CacheTemp)
	Set tmp=$$CheckICD(repid,ICD)
	Set tmp=$$CheckAlias(repid,DiseaseName) //通过检查ICD以及别名获取应该上报的传染病疾病列表
	Set InfectionID=""
	For {
		Set ICDDr=$o(^CacheTemp(repid,ICDDr))
		Quit:ICDDr=""	
		Set objInf=##class(DHCMed.EPD.Infection).GetObjById(ICDDr)
		Continue:$IsObject(objInf)=0
		Continue:objInf.MIFIsActive'="Y"
		Do objInf.%Close()
		Set IsReported=0
		Set EpdRowID=""
		Set RepInfo=""
		For {
			Set EpdRowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,ICDDr,EpdRowID))
			Quit:EpdRowID=""
			Set objEpdRep=##class(DHCMed.EPD.Epidemic).GetObjById(EpdRowID)
			Continue:$IsObject(objEpdRep)=0
			Do objEpdRep.%Close()
			Continue:objEpdRep.MEPDStatus'=3
			Set IsReported=1 
			Do objEpdRep.%Close()
			Set RepDateTime=$zd(objEpdRep.MEPDRepDate,3)_" "_$zt(objEpdRep.MEPDRepTime,1)
			Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(objEpdRep.MEPDCheckUsrDR)
			Do objRepUser.%Close()
			Set RepInfo=RepInfo_$c(2)
			Set RepInfo=RepInfo_objRepUser.%Id()_"^"_objRepUser.Name_"^"_RepDateTime
		}
		Set objRankDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",objInf.MIFRank,1)
		Set:$IsObject(objRankDic)=0 objRankDic=##class(DHCMed.SS.Dictionary).%New()
		Do objRankDic.%Close()
		Set objTimeLimit=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTTIMELIMIT",objInf.MIFTimeLimit,1)
		Set:$IsObject(objTimeLimit)=0 objRankDic=##class(DHCMed.SS.Dictionary).%New()
		Set Notice=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdTypeNotice-"_objRankDic.Code)
		Do objTimeLimit.%Close()		
		Set:ret'="" ret=ret_$c(1)
		Set ret=ret_objInf.MIFICD_"^"_objInf.MIFDisease_"^"_objRankDic.Description_"^"_objTimeLimit.Description_"^"_objInf.MIFMinAge_"^"_objInf.MIFMaxAge_"^"_Notice_"^"_IsRevisit_"^"_IsReported_RepInfo
	}
	
	
	Kill ^CacheTemp(repid)
	Quit ret
	
CheckICD(repid,ICD)
	n (repid,ICD)
	Quit:ICD="" 0
	Set tmpICD=""
	Set ret="*"
	For {
		Set tmpICD=$o(^DHCMed.EPDCi("IF",0,"ICD",tmpICD))
		Quit:tmpICD=""
		Quit:($e(tmpICD,1,$l(ICD))'=ICD)
		Set InfectionID=""
		For {
			Set InfectionID=$o(^DHCMed.EPDCi("IF",0,"ICD",tmpICD,InfectionID))
			Quit:InfectionID=""
			Set ^CacheTemp(repid,InfectionID)=""
		}
	}
	Set InfectionID=""
	For {
		Set InfectionID=$o(^DHCMed.EPDCi("IF",0,"ICD",tmpICD,InfectionID))
		Quit:InfectionID=""
		Set ^CacheTemp(repid,InfectionID)=""
	}	

	Quit 1
CheckAlias(repid,DiseaseName)
	n (repid,DiseaseName)
	Set Alias=""
	For {
		Set Alias=$o(^DHCMed.EPDCi("IF",0,"IsKeyword",1,Alias))
		Quit:Alias=""
		Continue:DiseaseName'[Alias
		Set InfectionID=""
		For {
			Set InfectionID=$o(^DHCMed.EPDCi("IF",0,"IsKeyword",1,Alias,InfectionID))
			Quit:InfectionID=""
			Set ^CacheTemp(repid,InfectionID)=""
		}
	}
	Quit 1
}

}
