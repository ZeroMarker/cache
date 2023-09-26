/// 创建者：李阳
/// 日期：2011-06-26
/// 监控类
Class DHCMed.EPDService.Control Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##class(DHCMed.EPDService.Control).SinglePatientControl(74023)
/// 返回值：触发问题数量
/// 功能：用来对单个Paadm进行监控
/// Todo:周二请吴工请教如何配置 图标列表
ClassMethod SinglePatientControl(Paadm As %String)
{
	n (Paadm)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:$IsObject(objSubject)=0 -1 //没有找到传染病监控字典
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set objSubject=""
	Kill objSubject
	Set Result=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm,SubjectID,"")
	
	Set TotalScore=0
	Set Desc=""
	Set ResultRowCnt=$ll(Result)
	Set i=0
	For i=1:1:ResultRowCnt {
		Set tmpRow=$li(Result,i)
		Set ItemDesc=$li(tmpRow,1)
		Set Score=$li(tmpRow,2)
		Set TotalScore=TotalScore+Score
		Set ^CacheTemp("EpdSinglePatientControl",Paadm,ItemDesc)=""
	}
	Set tmp=""
	For {
		Set tmp=$o(^CacheTemp("EpdSinglePatientControl",Paadm,tmp))
		Quit:tmp=""
		Set:Desc'="" Desc=Desc_","
		Set Desc=Desc_tmp
	}
	Set ^CacheTemp("EpdSinglePatientControl","Desc",Paadm)=Desc
	Quit (TotalScore'=0)
}

ClassMethod GetSinglePatientControlDesc(Paadm) As %String
{
	n (Paadm)
	Set ret=$g(^CacheTemp("EpdSinglePatientControl","Desc",Paadm))
	//Kill CacheTemp("EpdSinglePatientControl","Desc",Paadm)
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
	
	//s:FromDate["-" FromDate=$zdh(FromDate,3)
	//s:FromDate["/" FromDate=$zdh(FromDate,4)
	//s:ToDate["-" ToDate=$zdh(ToDate,3)
	//s:ToDate["/" ToDate=$zdh(ToDate,4)
	Set FromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FromDate)
	Set ToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ToDate)
	
	
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
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Control","EpidemicControl","2008-8-1","2008-8-1",2,"")
Query EpidemicControl(FromDate As %String, ToDate As %String, Days As %String, SubjectItmIDList As %String) As %Query(ROWSPEC = "PatientID:%String,Paadm:%String,AdmType:%String:就诊类型,RegNo:%String:就诊卡号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:就诊日期,AdmitDep:%String:就诊科室,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,FiredType:%String:触发的类别,Detail:%String")
{
}

ClassMethod EpidemicControlExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Days As %String, SubjectItmIDList As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	Kill ^CacheTemp
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	;Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("InfCC")
	Quit:$IsObject(objSubject)=0 $$$OK
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set PaadmStoreRepid=..CreatePaadmList(FromDate,ToDate,Days)
	Set i=""
	For {
		Set i=$o(^CacheTemp(PaadmStoreRepid,i))
		Quit:i=""
		Set Paadm=$g(^CacheTemp(PaadmStoreRepid,i))
		;W "Process:"_Paadm,!
		Set result=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm,SubjectID,SubjectItmIDList)
		If (result'="")
		{
			Set ^CacheTemp("EpidemicControl",repid,Paadm)=result	
			Set ^CacheTemp(repid,ind)=$$BuildEpidemicControl(repid,Paadm)
			Kill ^CacheTemp("EpidemicControl",repid,Paadm)
			Set ind=ind+1
		}
		
	}
	Kill ^CacheTemp(PaadmStoreRepid)
	//Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,PaadmStoreRepid,SubjectItmIDList)
	
	
	Quit $$$OK
	
	
	
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
	//Set Summary=$g(^CacheTemp(handle,"Paadm",Paadm))
	Set Result=$g(^CacheTemp("EpidemicControl",handle,Paadm))

	
	
	Set TotalScore=0
	Set ItemCount=0
	Set ItemList=""
	Set ResultRowCnt=$ll(Result)
	For i=1:1:ResultRowCnt {
		Set tmpRow=$li(Result,i)
		Set ItemDesc=$li(tmpRow,1)
		Set Score=$li(tmpRow,2)
		Set CtlResult=$li(tmpRow,3)
		Set ExtraData=$li(tmpRow,4)
		Set ErrData=$li(tmpRow,5)		
		Set ^CacheTemp("TMP",handle,Paadm,ItemDesc)=""
		Set TotalScore=TotalScore+Score

		Set ResultExtraDataCnt=$ll(ExtraData)
		For j=2:1:ResultExtraDataCnt {
			Set ExtraDataRow=$li(ExtraData,j)
			Set ItemCount=ItemCount+1
			Set ItemList=ItemList_ExtraDataRow_"<BR/>"
		}
		
	}
	
	Set Type=""
	Set TypeCount=0
	Set TypeList=""
	For {
		Set Type=$o(^CacheTemp("TMP",handle,Paadm,Type))
		Quit:Type=""
		Set TypeCount=TypeCount+1
		Set TypeList=TypeList_Type_","
	}
	Kill ^CacheTemp("TMP",handle,Paadm)
	
	/*
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.;s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.;d itemSubCat.%Close()
	.s ^CacheTemp(handle,"Paadm",Paadm,"SubCate",itemDic.IDSubCatDr)=""
	Set FiredType=""
	Set subCatID=""
	s subCatID="" f  s subCatID=$o(^CacheTemp(handle,"Paadm",Paadm,"SubCate",subCatID)) q:subCatID=""  d
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s FiredType=FiredType_$s(FiredType'="":",",1:"")_itemSubCat.ISCDesc
	
	set strDetail=""
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	..s data=$lb("")
	..s:strDetail'="" strDetail=strDetail_"<BR/>"
	..s strDetail=strDetail_"<B>"_itemSubCat.ISCDesc_"--"
	..s strDetail=strDetail_itemDic.IDDesc_":</B>"
	..s strDetail=strDetail_$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter))
	*/
	
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
	Set $li(data,12)=TypeCount  //$p(Summary,"^",3)   //FiredTypeCnt:%String:触发类型数量
	Set $li(data,13)=TypeList //触发项目类别
	Set $li(data,14)=ItemList
	
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

/// 查询监控结果详情
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Control","ViewControlDetail",35,56)
Query ViewControlDetail(handle As %String, Paadm As %String) As %Query(ROWSPEC = "SubCategory:%String:类别,ItemCaption:%String:项目,Result:%String:结果")
{
}

ClassMethod ViewControlDetailExecute(ByRef qHandle As %Binary, handle As %String, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	.s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	.d itemDic.%Close()
	.s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	.d itemSubCat.%Close()
	.s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	..s data=$lb("")
	..s $li(data,1)=itemSubCat.ISCDesc
	..s $li(data,2)=itemDic.IDDesc
	..s $li(data,3)=$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",itemDicRowID,intCounter))
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod ViewControlDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ViewControlDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ViewControlDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ViewControlDetailExecute ]
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
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Control","EpidemicControlSP",58008)
Query EpidemicControlSP(Paadm As %String) As %Query(ROWSPEC = "ItemDesc:%String:项目,Score:%String:得分,Result:%String:结果,Detail:%String:详情")
{
}

ClassMethod EpidemicControlSPExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode("EpdCC")
	Quit:$IsObject(objSubject)=0 -1 //没有找到传染病监控字典
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set objSubject=""
	Kill objSubject
	Set Result=##class(DHCMed.CCService.Sys.CtrlProcess).Main(Paadm,SubjectID,"")
	
	Set TotalScore=0
	Set Desc=""
	Set ResultRowCnt=$ll(Result)
	Set i=0
	For i=1:1:ResultRowCnt {
		Set tmpRow=$li(Result,i)
		Set ItemDesc=$li(tmpRow,1)
		Set Score=$li(tmpRow,2)
		Set CtlResult=$li(tmpRow,3)
		Set ExtraData=$li(tmpRow,4)
		Set ErrData=$li(tmpRow,5)
		
		Set TotalScore=TotalScore+Score
		
		Set ResultExtraDataCnt=$ll(ExtraData)
		For j=2:1:ResultExtraDataCnt {
			Set ExtraDataRow=$li(ExtraData,j)
			
			Set data=$lb("")
			Set $li(data,1)=ItemDesc
			Set $li(data,2)=Score
			Set $li(data,3)=CtlResult
			Set $li(data,4)=ExtraDataRow
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}
	}
			
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
/// 参数：
///    PatientID:患者ID
///    ICD:ICD编码
///    DiseaseName :疾病名称，必须传入，因为
///    IsRevisit : 是否为复诊
/// 返回值：传染病信息，格式：
ClassMethod CheckICDNeedReport(PatientID As %String, ICD As %String, DiseaseName As %String, IsRevisit As %String) As %String
{
	n (PatientID, ICD, DiseaseName, IsRevisit)
	Set ret=""
	Quit:PatientID="" ret
	Quit:ICD="" ret
	Set IsReported=0
	Set ICDDr=""
	For {
		Set ICDDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,ICDDr))
		Quit:ICDDr=""
		Set objInf=##class(DHCMed.EPD.Infection).GetObjById(ICDDr)
		Continue:$IsObject(objInf)=0
		Continue:objInf.MIFIsActive'="Y"
		Do objInf.%Close()
		Continue:objInf.MIFICD'=ICD
		Set EpdRowID=""
		For {
			Set EpdRowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,ICDDr,EpdRowID))
			Quit:EpdRowID=""
			Set objEpdRep=##class(DHCMed.EPD.Epidemic).GetObjById(EpdRowID)
			Set:(objEpdRep.MEPDStatus=3) IsReported=1
			Set:((IsReported=0)!(objInf.MIFMulti="Y")) ret=objEpdRep.ToString("^")
		}
	}
	
	Quit ret
}

}
