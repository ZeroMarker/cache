Class DHCWL.DM.T.CubeBase Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property DimsBit As %String(MAXLEN = 1024) [ Required ];

Property CreatedDate As %Date [ Required ];

Property DimNum As %Integer [ Required ];

Property ScheduleDate As ThemeDims;

// Property ScheduleDateConverter As %String;

// Property SDCCInteger As %String;

// ScheduleDateConverter convert to integer

Property Code As %String;

Index MainI On (ThemeBase, DimsBit As EXACT);

Index CodeI On Code As EXACT;

Index CodeIU On Code [ Unique ];

// d ##class(DHCWL.DM.T.CubeBase).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.CubeDStructMap)
	&sql(delete DHCWL_DM_T.CubeBase)
	&sql(delete DHCWL_DM_T.CubeDims)
	&sql(delete DHCWL_DM_T.CubeMetrics)
	k ^DHCWL.DM.T.CubeBaseD,^DHCWL.DM.T.CubeBaseI,^DHCWL.DM.T.CubeDimsD,^DHCWL.DM.T.CubeDimsI,^DHCWL.DM.T.CubeMetricsD,^DHCWL.DM.T.CubeMetricsI,^DHCWL.DM.T.CubeDStructMapI,^DHCWL.DM.T.CubeDStructMapD
	//w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload.t",$lb("OrdDate","RecDep","PatDep","AdmType"),$lb("Price"))
	//w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload.t",$lb("OrdDate","RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc"),$lb("Quantity","UnitPrice","Price"))
    //w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload.t",$lb("OrdDate","RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","TarACDr","TarECDr","TarICDr","TarOutDr","TarItemDr","ItemCatDr","ItemOrdDr","OEORIDr"),$lb("Quantity","UnitPrice","Price"))
    //w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload2.t",$lb("OrdDate","RecDep","PatDep","AdmType"),$lb("Price"))
	//w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload2.t",$lb("OrdDate","RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc"),$lb("Quantity","UnitPrice","Price"))
    //w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload2.t",$lb("OrdDate","RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","TarACDr","TarECDr","TarICDr","TarOutDr","TarItemDr","ItemCatDr","ItemOrdDr","OEORIDr"),$lb("Quantity","UnitPrice","Price"))
    
    w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workload4.t",$lb("ordDate","flagDate","billSub","tarItem","itemOrd","papmi","resDoc","patDoc","recDoc","userDr","RecDep","resDep","patDep","patWard","userDep","tarac","tarsc","tarout","tarec","tarmc","taric","tarmcnew","WLRowId","type","itemCat","billGrp","paadm","ordStatus","arpbl","oeori","paidFlag","receipti","cashero","holdFlag","holdFlagDate","dataType","pbd","admReason","oeore","socialStatus","phcc","phcd","phcf","phcin"),$lb("unitPrice","quantity","titalPrice","payorPrice","discPrice","pasharePrice"))
    
    //w ##class(DHCWL.DM.T.CubeBase).NewCube2("/WorkLoadAlll.t",$lb("WL_ABDATE","WL_ABDATE_FK","WL_ABTIME","WL_ABTIME_FK","WL_ADMREASON","WL_ARCBG_FK","WL_ARCBS_FK","WL_ARCIC_FK","WL_ARCIM_FK","WL_BILL_FK","WL_DATE","WL_DATE_FK","WL_EXECDOC_FK","WL_FLAGDATE","WL_FLAGDATE_FK","WL_FLAGTIME","WL_FLAGTIME_FK","WL_ID","WL_INSDATE","WL_INSDATE_FK","WL_INSTIME","WL_INSTIME_FK","WL_OEORI_FK","WL_ORDDATE","WL_ORDDATE_FK","WL_ORDERDOC_FK","WL_ORDLOC_FK","WL_ORDTIME","WL_ORDTIME_FK","WL_ORDUSER","WL_PAADMTYPE","WL_PAADM_FK","WL_PAPMI_FK","WL_PATDOC_FK","WL_PATLOC_FK","WL_PATWARD_FK","WL_PHCC_FK","WL_PHCDF_FK","WL_PHCD_FK","WL_PHCIN_FK","WL_PHCSC_FK","WL_PRTUSER","WL_PRTZYUSER","WL_PRTZY_FK","WL_PRT_FK","WL_RECLOC_FK","WL_SOCIALSTATUS_FK","WL_TARAC_FK","WL_TARCMCNEW","WL_TAREC_FK","WL_TARIC_FK","WL_TARITEM_FK","WL_TARMC_FK","WL_TAROUT_FK","WL_TARSC_FK","WL_TIME","WL_TIME_FK","WL_WORKLOADALLID"),$lb("WL_TOTALPRICE","WL_UNITPRICE","WL_DISCPRICE","WL_PAYORPRICE","WL_QUANTITY","WL_PASHAREPRICE"))

    //w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workloadall.t",$lb("ORDDate","PersonID","ARCIMDR","TarItemDR","OrderDocDR","OrdLocDR","PatDocDR","PatLocDR","RecLocDR","TarACDR","TarECDR","TarSCDR","ARCICDR","ADMReaSon","PAADMType","FlagDate","PatWardDR","ExecDocDR","WLDate","InsDate","ABDate","ORDTime","FlagTime","WLTime","InsTime","PHCINDR","PRTUser","PRTZYUser","ORDUser","InsTypeDR","PatBedDR","PRTRowid","PRTZYRowid","PAADMID","WorkloadAllId"),$lb("UnitPrice","Quantity","TotalPrice","PayorPrice","DiscPrice","PaSharePrice"))
}

Method %OnNew(isComputedFlag As %Boolean = 0) As %Status [ Private, ServerOnly = 1 ]
{
	
	q $$$OK
}

ClassMethod GetByCode(code) As CubeBase
{
	q:(code="")||('$d(^DHCWL.DM.T.CubeBaseI("CodeI",code))) ""
	s id=$o(^DHCWL.DM.T.CubeBaseI("CodeI",code,""))
	q ##class(CubeBase).%OpenId(id)
}

ClassMethod GetCubeFetchConfi(themePath) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" list
	s tid=theme.%Id()
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",tid)) list
	s bit="" f{
		s bit=$o(^DHCWL.DM.T.CubeBaseI("MainI",tid,bit))
		q:bit=""
		s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",tid,bit,""))
		s cube=##class(CubeBase).%OpenId(id)
		continue:cube=""
		s config=##class(CubeFetchConfig).GetByCode(cube.Code)
		d list.Insert(config)
	}
	q list
}

// s cube=##class(DHCWL.DM.T.CubeBase).Get("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType"),$lb("Price"))

// s cube=##class(DHCWL.DM.T.CubeBase).Get("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc"),$lb("Quantity","UnitPrice","Price"))

// s cube=##class(DHCWL.DM.T.CubeBase).Get("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","TarACDr","TarECDr","TarICDr","TarOutDr","TarItemDr","ItemCatDr","ItemOrdDr","OEORIDr"),$lb("Quantity","UnitPrice","Price"))

ClassMethod Get(themePath, scheduleDate, dimCodeList As %List, metricList As %List) As CubeBase
{
	
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" ""
	s scheduleDim=theme.GetDim(scheduleDate)
	s themeId=theme.%Id()
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",themeId)) ""
	s upSD=$zcvt(scheduleDate,"U")
	s bit=""
	s len=$ll(dimCodeList),aggLen=$ll(metricList)
	s themeMetricList=$lb()
	k metricMap
	s flag=0,mCount=0
	f i=1:1:aggLen {
	  s metric=$lg(metricList,i,"")
	  continue:metric=""
	  s obj=theme.GetMetric(metric)
	  if obj=""{
		s flag=1
		q 
	  }
	  continue:$d(metricMap(metric))
	  s mCount=mCount+1
	  s $list(themeMetricList,mCount)=obj.%Id()
	  s metricMap(metric)=""
	}
	q:flag=1 ""
	f i=1:1:len {
	  s dimCode=$lg(dimCodeList,i)
	  continue:dimCode=""
	  continue:$zcvt(dimCode,"U")=upSD
	  s dimPro=theme.GetDim(dimCode)
	  s $bit(bit,dimPro.SerialNumber)=1
	}
	s min=99999999,bestBit=""
	s allBit="" f{
	  s allBit=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit))
	  q:allBit=""
	  s bit2=$BITLOGIC(allBit & bit)
	  s checkBit=$BITLOGIC(bit2 ^ bit)
	  s zeroCheck=$bitcount(checkBit,1)
	  continue:zeroCheck'=0
	  s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit,""))
	  s cube=##class(CubeBase).%OpenId(id)
	  continue:cube.ScheduleDate.%Id()'=scheduleDim.%Id()
	  s flag=0
	  f j=1:1:aggLen {
	    s cubeMetric=##class(CubeMetrics).Get(id,$lg(themeMetricList,j))
	    i cubeMetric="" {
	      s flag=1
	      q
	    }
	  }
	  q:flag=1
	  s dimCount=$bitcount(allBit,1)
	  i min>dimCount {
	    s min=dimCount,bestBit=allBit
	  }
	}
	q:bestBit="" ""
	s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bestBit,""))
	q ##class(CubeBase).%OpenId(id)
}

// s cube=##class(DHCWL.DM.T.CubeBase).Get2("/workload.t",$lb("AdmType","OrdDate","RecDep","TarECDr"),$lb("Price"))

ClassMethod Get2(themePath, dimCodeList As %List, metricList As %List) As CubeBase
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" ""
	s themeId=theme.%Id()
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",themeId)) ""
	s bit=""
	s len=$ll(dimCodeList),aggLen=$ll(metricList)
	s themeMetricList=$lb()
	k metricMap
	s flag=0,mCount=0
	f i=1:1:aggLen {
	  s metric=$lg(metricList,i,"")
	  continue:metric=""
	  s obj=theme.GetMetric(metric)
	  if obj=""{
		s flag=1
		q 
	  }
	  continue:$d(metricMap(metric))
	  s mCount=mCount+1
	  s $list(themeMetricList,mCount)=obj.%Id()
	  s metricMap(metric)=""
	}
	q:flag=1 ""
	f i=1:1:len {
	  s dimCode=$lg(dimCodeList,i)
	  continue:dimCode=""
	  s dimPro=theme.GetDim(dimCode)
	  continue:(dimPro'="")&&(dimPro.CreateType'="")&&(dimPro.CreateType.GetPath()="TD:DYNPROFUN")
	  s $bit(bit,dimPro.SerialNumber)=1
	}
	s min=99999999,bestBit=""
	s allBit="" f{
	  s allBit=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit))
	  q:allBit=""
	  s bit2=$BITLOGIC(allBit & bit)
	  s checkBit=$BITLOGIC(bit2 ^ bit)
	  s zeroCheck=$bitcount(checkBit,1)
	  continue:zeroCheck'=0
	  s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit,""))
	  s flag=0
	  f j=1:1:aggLen {
		s aggMetric=$lg(themeMetricList,j)
		continue:aggMetric=""
	    s cubeMetric=##class(CubeMetrics).Get(id,aggMetric)
	    i cubeMetric="" {
	      s flag=1
	      q
	    }
	  }
	  continue:flag=1
	  s dimCount=$bitcount(allBit,1)
	  i min>dimCount {
	    s min=dimCount,bestBit=allBit
	  }
	}
	q:bestBit="" ""
	s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bestBit,""))
	q ##class(CubeBase).%OpenId(id)
}

ClassMethod GetAll(themePath, dimCodeList As %List, metricList As %List) As %ListOfObjects
{
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" ""
	s themeId=theme.%Id()
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",themeId)) ""
	s bit=""
	s len=$ll(dimCodeList),aggLen=$ll(metricList)
	s themeMetricList=$lb()
	k metricMap
	s flag=0,mCount=0
	s cubeList=##class(%ListOfObjects).%New()
	f i=1:1:aggLen {
	  s metric=$lg(metricList,i,"")
	  continue:metric=""
	  s obj=theme.GetMetric(metric)
	  if obj=""{
		s flag=1
		q 
	  }
	  continue:$d(metricMap(metric))
	  s mCount=mCount+1
	  s $list(themeMetricList,mCount)=obj.%Id()
	  s metricMap(metric)=""
	}
	q:flag=1 ""
	f i=1:1:len {
	  s dimCode=$lg(dimCodeList,i)
	  continue:dimCode=""
	  s dimPro=theme.GetDim(dimCode)
	  s $bit(bit,dimPro.SerialNumber)=1
	}
	s min=99999999,bestBit=""
	s allBit="" f{
	  s allBit=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit))
	  q:allBit=""
	  s bit2=$BITLOGIC(allBit & bit)
	  s checkBit=$BITLOGIC(bit2 ^ bit)
	  s zeroCheck=$bitcount(checkBit,1)
	  continue:zeroCheck'=0
	  s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit,""))
	  s flag=0
	  f j=1:1:aggLen {
		continue:$lg(themeMetricList,j,"")=""
	    s cubeMetric=##class(CubeMetrics).Get(id,$lg(themeMetricList,j))
	    i cubeMetric="" {
	      s flag=1
	      q
	    }
	  }
	  continue:flag=1
	  s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,allBit,""))
	  s cube=##class(CubeBase).%OpenId(id)
	  d cubeList.Insert(cube)
	}
	q cubeList
}

ClassMethod Delete(themePath, scheduleDate, dimCodeList As %List, metricList As %List) As %Status
{
	s cube=..Get(themePath,scheduleDate,dimCodeList,metricList)
	q:cube="" $$$ERROR("No such cube defined!")
	q ..DeleteById(cube.%Id())
}

ClassMethod DeleteById(cubeId) As %Status
{
	&sql(delete DHCWL_DM_T.CubeDims where CubeBase=:cubeId)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	&sql(delete DHCWL_DM_T.CubeMetrics where CubeBase=:cubeId)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	&sql(delete DHCWL_DM_T.CubeBase where ID=:cubeId)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	&sql(delete DHCWL_DM_T.CubeDBDPPart where CubeMask=:cubeId)
	q:((SQLCODE'=0)&&(SQLCODE'=100)) $$$ERROR("SQLCODE="_SQLCODE)
	q $$$OK
}

// d ##class(DHCWL.DM.T.CubeBase).DeleteByThemePath("/DHCWorkLoad.t")

ClassMethod DeleteByThemePath(themePath) As %Status
{
	s themeId=##class(ThemeBase).GetIdByPath(themePath)
	q:themeId="" $$$ERROR("The path "_themePath_" is not exists!")
	d ##class(DHCWL.DM.T.CubeDStruct).ClearThemeCube(themePath)
	s list=..GetCubesId(themeId)
	s status=$$$OK
	f i=1:1:$ll(list){
		s id=$lg(list,i,"")
		continue:id=""
		s status=..DeleteById(id)
		q:status'=$$$OK
	}
	q status
}

ClassMethod GetCubes(themeId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",themeId)) list
	s bit="" f  s bit=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit)) q:bit=""  d
	.s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit,""))
	.s obj=##class(CubeBase).%OpenId(id)
	.q:obj=""
	.d list.Insert(obj)
	q list
}

ClassMethod GetCubesId(themeId) As %List
{
	s list=$lb(),count=1
	q:'$d(^DHCWL.DM.T.CubeBaseI("MainI",themeId)) list
	s bit="" f  s bit=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit)) q:bit=""  d
	.s id=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit,""))
	.q:'$d(^DHCWL.DM.T.CubeBaseD(id))
	.s $list(list,count)=id
	.s count=count+1
	q list
}

// w ##class(DHCWL.DM.T.CubeBase).NewCube("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType"),$lb("Price"))

// w ##class(DHCWL.DM.T.CubeBase).NewCube("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","PatType"),$lb("Quantity","UnitPrice","Price"))

// w ##class(DHCWL.DM.T.CubeBase).NewCube("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","TarACDr","TarECDr","TarICDr","TarOutDr","TarItemDr","PatType","ItemCatDr","ItemOrdDr","OEORIDr"),$lb("Quantity","UnitPrice","Price"))

/// Support add new metric
ClassMethod NewCube(themePath, scheduleDate, dimCodeList As %List, metricList As %List) As %Status
{
	s status=$$$OK
	s cube=..Get(themePath,scheduleDate,dimCodeList,metricList)
	q:cube'="" $$$ERROR("Already created this cube!")
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" $$$ERROR("Can't find theme "_themePath)
	s themeMetricList=$lb()
	s aggLen=$ll(metricList)
	f i=1:1:aggLen {
	  s metric=$lg(metricList,i,"")
	  continue:metric=""
	  s obj=theme.GetMetric(metric)
	  if obj=""{
		s status=$$$ERROR("Can't get metric:"_metric_" from theme path:"_themePath)
		q 
	  }
	  s $list(themeMetricList,i)=obj.%Id()
	}
	q:status'=$$$OK status
	s sdp=theme.GetDim(scheduleDate)
	q:sdp="" $$$ERROR(scheduleDate_" Can't find in theme "_themePath)
	s themeId=theme.%Id()
	s scheduleDateId=sdp.%Id()
	s status=##class(ThemeDims).GetDimsSerialNumber(themeId,dimCodeList,.dimSerNumMap)
	q:status'=$$$OK status
	s bit="",cubeId=""
	s dimCode="" f   {
	  s dimCode=$o(dimSerNumMap(dimCode))
	  q:dimCode="" 
	  s $bit(bit,dimSerNumMap(dimCode,"SN"))=1
	}
	s obj=""
	if ( ($d(^DHCWL.DM.T.CubeBaseI("MainI",themeId))) && ($d(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit))) ) {
	  s cubeId=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit,""))
	}
	if cubeId="" {
	  s cd=+$p($h,",",1)
	  s len=$ll(dimCodeList)
	  &sql(INSERT INTO DHCWL_DM_T.CubeBase(ThemeBase,DimsBit,CreatedDate,DimNum,ScheduleDate) values(:themeId,:bit,:cd,:len,:scheduleDateId))
	  s cubeId=%ROWID
	  q:SQLCODE'=0 $$$ERROR("Insert CubeBase SQLCODE:"_SQLCODE)
	  s status= ##class(CubeDims).Add(cubeId,scheduleDateId)
	  s dimCode="" f {
	    s dimCode=$o(dimSerNumMap(dimCode))
		q:dimCode=""  
	    s status= ##class(CubeDims).Add(cubeId,dimSerNumMap(dimCode))
	    q:status'=$$$OK
	  }
	}
	q:status'=$$$OK status
	q ..NewMetricsPri(cubeId,themeMetricList)
}

ClassMethod NewCube2(themePath, dimCodeList As %List, metricList As %List, code = "") As CubeBase
{
	s status=$$$OK
	s cube=..Get2(themePath,dimCodeList,metricList)
	q:cube'="" status //$$$ERROR("Already created this cube!")
	s theme=##class(ThemeBase).GetByPath(themePath)
	q:theme="" $$$ERROR("Can't find theme "_themePath_" when creating cube.")
	s themeId=theme.%Id()
	s themeMetricList=$lb()
	s aggLen=$ll(metricList)
	s num=0
	if code=""{
		s code=themePath_"_"_$g(^DHCWL.DM.T.CubeBaseD,1)
	}
	q:..GetByCode(code)'="" $$$ERROR("The cube with code "_code_" has exists!")
	f i=1:1:aggLen {
	  s metric=$lg(metricList,i,"")
	  continue:metric=""
	  s obj=theme.GetMetric(metric)
	  if obj=""{
		s status=$$$ERROR("Can't get metric:"_metric_" from theme path:"_themePath)
		q 
	  }
	  s num=num+1
	  s $list(themeMetricList,num)=obj.%Id()
	}
	q:status'=$$$OK status
	s status=##class(ThemeDims).GetDimsSerialNumber(themeId,dimCodeList,.dimSerNumMap)
	q:status'=$$$OK status
	s bit="",cubeId=""
	s dimCode="" f   {
	  s dimCode=$o(dimSerNumMap(dimCode))
	  q:dimCode="" 
	  s $bit(bit,dimSerNumMap(dimCode,"SN"))=1
	}
	s obj=""
	if ( ($d(^DHCWL.DM.T.CubeBaseI("MainI",themeId))) && ($d(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit))) ) {
	  s cubeId=$o(^DHCWL.DM.T.CubeBaseI("MainI",themeId,bit,""))
	}
	if cubeId="" {
	  s cd=+$p($h,",",1)
	  s len=$ll(dimCodeList)
	  s obj=##class(CubeBase).%New()
	  s obj.ThemeBase=theme,obj.DimsBit=bit,obj.DimNum=len,obj.Code=code
	  s obj.CreatedDate=+$h
	  s status=obj.%Save()
	  q:status'=$$$OK status
	  s cubeId=obj.%Id()
	  ;&sql(INSERT INTO DHCWL_DM_T.CubeBase(ThemeBase,DimsBit,CreatedDate,DimNum,Code) values(:themeId,:bit,:cd,:len,:code))
	  ;s cubeId=%ROWID
	  ;q:SQLCODE'=0 $$$ERROR("Insert CubeBase Error SQLCODE:"_SQLCODE)
	  ;s cubeObj=##class(CubeBase).GetByCode(code)
	  ;s status= ##class(CubeDims).Add(cubeId,scheduleDateId)
	  f i=1:1:len{
			s dimCode=$lg(dimCodeList,i,"")
			q:(dimCode="")||('$d(dimSerNumMap(dimCode)))  
			;s themeDimObj=theme.GetDim(dimCode)
			;if themeDimObj=""{
			;	s status=$$$ERROR("Can't get dim of "_dimCode_" from theme "_themePath)
			;}
			;s cubeDimObj=##class(CubeDims).%New()
			;s cubeDimObj.CubeBase=cubeObj,cubeDimObj.DimPro=themeDimObj
			s status= ##class(CubeDims).Add(cubeId,dimSerNumMap(dimCode))  ;cubeDimObj.%Save()
	    q:status'=$$$OK
	  }
	  q:status'=$$$OK status
	  /*s dimCode="" f {
	    s dimCode=$o(dimSerNumMap(dimCode))
		q:dimCode=""  
	    s status= ##class(CubeDims).Add(cubeId,dimSerNumMap(dimCode))
	    q:status'=$$$OK
	  }*/
	  s status= ..NewMetricsPri(cubeId,themeMetricList)
	}
	q status
}

// s cube=##class(DHCWL.DM.T.CubeBase).Get("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType"),$lb("Price"))

// s aggMetric=cube.NewMetric("sum(Price)")

Method NewMetric(aggExpression As %String) As %Status
{
	q ##class(CubeMetrics).New(..%Id(),aggExpression)
}

Method NewMetrics(metricList As %List) As %Status
{
	q ..NewMetricsPri(..%Id(),metricList)
}

ClassMethod NewMetricsPri(cubeId, metricList As %List) As %Status [ Private ]
{
	s len=$ll(metricList)
	s status=$$$OK
	f i=1:1:len {
	  s themeMetricId=$lg(metricList,i)
	  s status=##class(CubeMetrics).Add(cubeId,themeMetricId)
	  q:status'=$$$OK
	}
	q status
}

ClassMethod IsSchedulerDim(cubeId, dimId) As %Boolean [ CodeMode = expression ]
{
$lg(^DHCWL.DM.T.CubeBaseD(cubeId),6)=dimId
}

Method GetDim(dimCode As %String) As CubeDims
{
	q ##class(CubeDims).Get(..%Id(),..ThemeBase.GetDim(dimCode))
}

Method GetDims() As %ListOfObjects
{
	q ##class(CubeDims).GetDims(..%Id())
}

Method GetMetric(aggExp As %String) As CubeMetrics
{
	s mobj=..ThemeBase.GetMetric(aggExp)
	q:mobj="" ""
	s mid=mobj.%Id()
	s mobj=""
	q ##class(CubeMetrics).Get(..%Id(),mid)
}

Method GetMetrics() As %ListOfObjects
{
	q ##class(CubeMetrics).GetMetrics(..%Id())
}

Method GetFetchSQL() As %String
{
	s sql="SELECT "
	s dimSel=##class(CubeDims).GetFetchSelect(..%Id())
	s aggSel=##class(CubeMetrics).GetFetchSelect(..%Id())
	i ( (dimSel'="") && (aggSel'="") ) d
	.s sql=sql_dimSel_","_aggSel
	else  if (dimSel'="") d
	.s sql=sql_dimSel
	else  if (aggSel'="")  d
	.s sql=sql_aggSel
	e  d
	.
	s sql=sql_" FROM theme."_..ThemeBase.GetSQLRef()_" WHERE "_..ScheduleDate.Code_"= @date " ;_##class(CubeDims).GetFetchGroupby(..%Id())
	q sql
}

Method GetDimStructMap(isRelaDim As %Boolean = 0) As %List
{
	q ##class(CubeDims).GetSelectColName(..%Id(),,isRelaDim)
}

Method GetShedulerStruct() As %List
{
	q:..ScheduleDate="" $lb()
	s cubeDimId=##class(CubeDims).GetId(..%Id(),..ScheduleDate.%Id())
	q:cubeDimId="" $lb()
	q ##class(CubeDims).GetSelectColName(..%Id(),cubeDimId)
}

Method GetMetricStructMap(metric = "") As %List
{
	s mid=""
	if (metric'=""){
	  s mobj=..GetMetric(metric)
	  q:mobj="" $lb()
	  s mid=mobj.%Id()
	  s mobj=""
	}
	q ##class(CubeMetrics).GetSelectColName(..%Id(),mid)
}

Method GetMaxStructSN() As %Integer
{
	q ##class(CubeDStructMap).GetMaxSerialNumber(..%Id())
}

Method GetDimMaxStructSN() As %Integer
{
	q ##class(CubeDims).GetMaxSN(..%Id())
}

Method GetMetricMaxStructSN() As %Integer
{
	q ##class(CubeMetrics).GetMaxSN(..%Id())
}

Method Mask() As %String
{
	q ..%Id()
}

Method GetDimSN(dimId) As %Integer
{
	q ##class(CubeDims).Get(..%Id(),dimId).SerialNumber
}

Method GetCubeDimId(themeDimId) As %String
{
	q ##class(CubeDims).Get(..%Id(),themeDimId).%Id()
}

Method GetPath() As %String
{
	q "DimsBitMap:"_..DimsBit
}

Method ToString() As %String
{
	q "{""mask"":"""_..Mask()_""",""schedulerDate"":"""_..ScheduleDate.Code_""",""cubeRefTheme"":"""_..ThemeBase.GetPath()_""",""dims"":"_##class(CubeDims).ToString(..%Id())_",""metrics"":"_##class(CubeMetrics).ToString(..%Id())_"}"
}

// d cube.SetScheduleDateConverter("class(DHCWL.DM.Function.DateConverter).YM")

// Method SetScheduleDateConverter(scheduleDateConverter As %String)

// {

//    s ..ScheduleDateConverter=scheduleDateConverter	

//    d ..%Save()

// }

// d ##class(DHCWL.DM.T.CubeBase).Test1()

ClassMethod Test1()
{
	s cube=##class(DHCWL.DM.T.CubeBase).Get("/workload.t","OrdDate",$lb("RecDep","PatDep","AdmType","PatDoc","RecDoc","ResDoc","TarACDr","TarECDr","TarICDr","TarOutDr","TarItemDr","ItemCatDr","ItemOrdDr","OEORIDr"),$lb("Quantity","UnitPrice","Price"))
	w cube.ConvertScheduleDate("2016-05-09")
}

ClassMethod Test2()
{
	s theme=##class(DHCWL.DM.T.ThemeBase).GetByPath("/Workload.t")
	s cubeList=theme.GetCubes()
	s cube=cubeList.GetAt(2)
	b ;1
	s dimRelaSN=cube.GetDimStructMap(1)
}

/*
Method ConvertScheduleDate(date As %String) As %String
{
	q:..ScheduleDateConverter="" date
	q ..ConvertScheduleDateHelper(date,..ScheduleDateConverter)
}

Method ConvertScheduleDateInteger(date As %String) As %Integer
{
	q +date
}

ClassMethod ConvertScheduleDateHelper(date, fetchFun As %String) As %String [ Private ]
{
	try{
	  s fetchFun=##class(DHCWL.DM.Util.StringUtil).Trim(fetchFun)
	  i $zcvt($e(fetchFun,1,8),"U") [ "CLASS(" {
		s exeStr=" d ##"_fetchFun_"(date,.rs)"
	  }else{
		s exeStr=" d "_fetchFun_"(date,.rs)"
	  }
	  ;w exeStr,!
	  x ("(date,rs) {"_exeStr_" }",date,.rs)
	}catch(e){
		w "ConvertScheduleDate exception:",e.Data,":",e.DisplayString(),!
	}
	q rs
}
*/
Storage Default
{
<Data name="CubeBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>DimsBit</Value>
</Value>
<Value name="4">
<Value>CreatedDate</Value>
</Value>
<Value name="5">
<Value>DimNum</Value>
</Value>
<Value name="6">
<Value>ScheduleDate</Value>
</Value>
<Value name="7">
<Value>isComputedFlag</Value>
</Value>
<Value name="8">
<Value>IsComputedFlag</Value>
</Value>
<Value name="9">
<Value>RefTheme</Value>
</Value>
<Value name="10">
<Value>PositionMask</Value>
</Value>
<Value name="11">
<Value>ScheduleDateConverter</Value>
</Value>
<Value name="12">
<Value>SDCCInteger</Value>
</Value>
<Value name="13">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeBaseD</DataLocation>
<DefaultData>CubeBaseDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeBaseD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeBaseI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
