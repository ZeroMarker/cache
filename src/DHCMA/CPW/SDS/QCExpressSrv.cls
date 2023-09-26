Class DHCMA.CPW.SDS.QCExpressSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCExpressSrv","QryQCExpress","GetValue")
Query QryQCExpress(aExpType As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTIsActive:%String,BTExpress:%String,BTExpressTxt:%String,BTExpressParam:%String,BTLevel:%String")
{
}

ClassMethod QryQCExpressExecute(ByRef qHandle As %Binary, aExpType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.QCExpressD(xRowID))
	 	Quit:xRowID=""
	 	Set ObjExpress        = ##class(DHCMA.CPW.SD.QCExpress).GetObjById(xRowID)
	 	Set Code                     = ObjExpress.BTCode
	 	Set Desc                     = ObjExpress.BTDesc  
	 	Set (TypeID,TypeDesc)=""
	 	if ($IsObject(ObjExpress.BTTypeDr)) {
		 	Set TypeID               = ObjExpress.BTTypeDr.%Id()
		 	Set TypeDesc             = ObjExpress.BTTypeDr.BTDesc
	 	}
		Set IsActive                 = ObjExpress.BTIsActive
		Set IsActive = $s(IsActive=1:"是",1:"否")
		
		Set BTExpress                = ObjExpress.BTExpress
		Set BTExpressTxt             = ObjExpress.BTExpressTxt
		Set BTExpressParam           = ObjExpress.BTExpressParam
		continue:(aExpType'="")&&(aExpType'=ObjExpress.BTTypeDr.BTCode)
		Set BTLevel					 = ObjExpress.BTLevel
		Set Data=$lb(xRowID,Code,Desc,TypeID,TypeDesc,IsActive,BTExpress,BTExpressTxt,BTExpressParam,BTLevel)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryQCExpressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCExpressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCExpressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCExpressExecute ]
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

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  基础信息表达式  
/// Input:	%EpisodeID/就诊号,%ItemID/项目ID
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpBaseInfo()
ClassMethod ExpBaseInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	// 找到就诊基础信息的取值参数
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	Quit:param="" return
	Set aOID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(%EpisodeID)
	Set obj=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(aOID)
	Set return="Set return = obj."_param
	x return
	quit return
}

/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpNurInfo()
ClassMethod ExpNurInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	quit return
}

/// Description:  通过费用类别取费用信息 zgz
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpFeeInfo()
ClassMethod ExpFeeInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	Quit:param="" return

	Set paadm=$p(%EpisodeID,"!!",1)
	Set obj=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(paadm)
	Set return="Set return = obj."_param
	x return
	quit return
}

/// Description:  通过术语集/操作项代码（全编目）取电子病历信息 zgz
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpEMRInfo()
ClassMethod ExpEMRInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	// 找到就诊基础信息的取值参数
	/*
	Set %EpisodeID=("2391756!!1")
	Set %ItemID="4||16"
	*/
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	Quit:param="" return
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set LocID=+$p($g(^PAADM(Paadm)),"^",4)
	Set HOSPID=+$p($g(^CTLOC(+LocID)),"^",22)
	Set HOSPCode=$p($g(^CT("HOSP",+HOSPID)),"^",1)
	if (HOSPCode["JNRM"){ //济宁第一人民用的第三方电子病历 东华全编目
		Set FPObj=##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(Paadm)
		Quit:'$IsObject(FPObj) return
		Set FPID=FPObj.%Id()
		//兼容费用汇总计算的情况
		if (param["+") {
			for pInd=1:1:$l(param,"+") {
				Set pValue=##Class(DHCWMR.FP.FPAdmitInfo).GetValueByFPAdm(FPID,$p(param,"+",pInd))
				Set return=return+pValue
			}
		}else{
			Set return=##Class(DHCWMR.FP.FPAdmitInfo).GetValueByFPAdm(FPID,param)
		}
	}
	else{
		//兼容费用汇总计算的情况
		if (param["+") {
			Set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Paadm,$e(param,1,9))
			for pInd=1:1:$l(param,"+") {
				Set pValue=Glossary.GetAt($p(param,"+",pInd))
				Set return=return+pValue
			}
		}elseif (param["_") {
			Set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Paadm,$e(param,1,9))
			for pInd=1:1:$l(param,"_") {
				Set pValue=Glossary.GetAt($p(param,"_",pInd))
				Set return=return_pValue
			}
		}else{
			Set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Paadm,$e(param,1,9))
			Quit:'$IsObject(Glossary) return
			Set return=Glossary.GetAt(param)
			//编码类型的项目取值进行初始化匹配
			if (objItem.BTDesc["编码")&&(objItem.BTTypeDr.BTDesc["字典") {
					Set return=..MatchItemDic(return,objItem.Parref.%Id(),objItem.BTVersion.%Id(),objItem.BTCode)
			}
			//Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(Paadm,param)
		}
		if ((return["年")&&(return["月")&&(return["日")) {
			Set return=$tr(return,"年","-")
			Set return=$tr(return,"月","-")
			Set return=$tr(return,"日","")
			//转换日期格式为标准格式
			if ($l($p(return," ",1),"-")=3) {
				Set $p(return," ",1)=##Class(DHCMA.Util.IO.FromHisSrv).ChangeDateFormat($p(return," ",1),4)
				Set:$l(return," ")>1 $p(return," ",2)=##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat($p(return," ",2),1)
			}
		}
	}
	quit return
}

/// Description:  通过关联项目取相关信息 zgz
/// 入参：如RepDate 取报告日期,OrdSDate 取开医嘱日期 RepResult 取关联报告结果
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpWithItemInfo()
ClassMethod ExpWithItemInfo(arg As %String = "") As %String
{
	new (%MRlistID,%EpisodeID,%ItemID)
	Set return=""
	// 找到就诊基础信息的取值参数
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set GetParam=objItem.GetDataParam
	Set LinkedStr=""
	Set LinkedItem=objItem.BTLinkedItem
	Set LinkedStr=LinkedItem.%Id()
	Set LinkedCode=LinkedItem.BTCode  //该项目的父Code
	Set ParrefID=objItem.Parref.%Id()
	Set ItemSubID=""
	for {
		//倒序取出被关联医嘱的表单项目，获取邻近项目执行的相关医嘱记录
		Set ItemSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfLinked",LinkedItem.%Id(),ParrefID,ItemSubID),-1)
		Quit:ItemSubID=""
		Set ItemTmpID=ParrefID_"||"_ItemSubID
		continue:ItemTmpID=%ItemID
		Set LinkedStr=LinkedStr_"^"_ItemTmpID
	}
	d objItem.%Close()
	Set Paadm=$p(%EpisodeID,"!!",1)
	//根据关联项目的执行情况
	for xLinkInd=1:1:$L(LinkedStr,"^") {
		Set xLinkedID=$p(LinkedStr,"^",xLinkInd)
		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",%MRlistID,xLinkedID,""),-1)
 		continue:ESubID=""
 		Quit:return'=""
		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(%MRlistID_"||"_ESubID)
		Continue:'$IsObject(ItemExecObj)
		Set ExecObjectID=ItemExecObj.ObjectID
		//OEITEM:1784190||1
		continue:ExecObjectID'["OEITEM"
		Set OEITEMID=$p($p(ExecObjectID,",",1),":",2)
		///通过OEITEMID取开医嘱日期、有报告的继续取报告日期和报告结果
		Set OrderDate=ItemExecObj.ExecDate
		Set:GetParam="OrderDate" return=OrderDate
		Set TestSetRow=$p($g(^OEORD(+OEITEMID,"I",$p(OEITEMID,"||",2),3)),"^",35) // 检验条码
		Set Epis=$p(TestSetRow,"||",1)
 		Set TS=$p(TestSetRow,"||",2)
 		Set TSCount=$p(TestSetRow,"||",3)
 		Continue:(Epis="")||(TS="")||(TSCount="")
 		//!!!!由于咸阳医院流程是入院先会在急诊做一个手工的检验检查项目，这部分结果没有录入到检验系统当中
 		//所以我们取首次检验检查时间 是取不到的！
 		Set xTSCount=""
 		For {
	 		Set xTSCount=$o(^TEPI(Epis,1,TS,xTSCount))
	 		Quit:xTSCount=""
	 		Set TSCount=xTSCount
	 		Set TestSetRow=Epis_"||"_TS_"||"_TSCount
	 		//根据检验项目代码过滤
	 		Set obj=""
		 	Set obj=##Class(DHCMed.DPCustom.Data.LabTestSet).GetObjById0(TestSetRow)
		 	Set RepDate=obj.CheckDate
		 	Set RepTime=obj.CheckTime
		 	Set:GetParam="RepDateT" return=RepDate_" "_RepTime
		 	if (obj.TestData.Count()>0){
			 		for tInd=1:1:obj.TestData.Count() {
			 		Set tTestData=obj.TestData.GetAt(tInd)
			 		Set tTestCode=tTestData.TestCode  //用于指定项目Code过滤
			 		Set tResult=tTestData.DataText
			 	}
		 	}
 		}
		}
	quit return
}

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  是否用药、实施手术、执行检验、检查(医嘱)表达式  
/// Input:	%EpisodeID/就诊号,%ItemID/项目ID
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOrder()
ClassMethod ExpOrder(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	// 找到项目的值域
	Set return=""
	Set Paadm=$p(%EpisodeID,"!!",1)
	set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	Set DicTypeCode=objItem.BTCode
	Set DicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofCode"," "_$zcvt(DicTypeCode,"U"),0))
	Set (DicCode,ItemOptionCodeStr,DocStr,SttDateStr,SttTimeStr,ObjectIDStr)=""
	for {
		Set DicCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode))
		Quit:DicCode=""
		Set DicID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode,""),-1)
		Set optMatchID=""
		for {
			Set optMatchID=$o(^DHCMA.CPW.SD.QCOptionMatchI("IndexOfItemOptionDr",DicID,optMatchID))
			quit:optMatchID=""	
			Set objMatch=##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(optMatchID)
			Set type=objMatch.OMType
			Set ArcimID=objMatch.OMArcimID
			Set Generic=objMatch.OMPHCGeneric
			Set Category=objMatch.OMCategory
			Set ItemOptionCode=objMatch.ItemOptionDr.BTCode
			Set ordMastID=""
			//项目执行分医嘱项和通用名执行两种方式
			// 医嘱匹配
			// 通用名匹配
			Set ArcimIDStr=ArcimID
			if type=2 {
				 Set ArcimIDStr=..GetGEArcByARCID(ArcimID)
				}
			Set OrdRowId=$o(^OEORD(0,"Adm",Paadm,""))
			for AInd=1:1:$l(ArcimIDStr,"^") {
				Set ArcimID=$p(ArcimIDStr,"^",AInd)
				continue:'$d(^OEORDi(0,"ARCIM",OrdRowId,ArcimID))
				Set SttDat=$o(^OEORDi(0,"ARCIM",OrdRowId,ArcimID,""),-1)
				Set Childsub=$o(^OEORDi(0,"ARCIM",OrdRowId,ArcimID,SttDat,""),-1) //通过医嘱项判断否执行
				Set SttTime = $p($g(^OEORD(+OrdRowId,"I",Childsub,1)),"^",10) // 开始时间 
				Set DoctorDR = $p($g(^OEORD(+OrdRowId,"I",Childsub,1)),"^",11) // 开医嘱医生 CT_CareProv
				Set ItemStatDR = $p($g(^OEORD(+OrdRowId,"I",Childsub,1)),"^",13) // 医嘱状态 OEC_OrderStatus 
				Set StatCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
				continue:(StatCode="U")||(StatCode="C") //作废、撤销的医嘱 不算执行
				Set TMPItemOptionCodeArr(ItemOptionCode,SttDat)=DoctorDR_"^"_SttDat_"^"_SttTime_"^"_"OEITEM:"_OrdRowId_"||"_Childsub
				Quit
				
			}
			
		}
		
	}
	Set xOptionCode=""
		for {
			Set xOptionCode=$o(TMPItemOptionCodeArr(xOptionCode))
			Quit:xOptionCode=""
			Set SttDat=$o(TMPItemOptionCodeArr(xOptionCode,0))
			Set CodeInfo=$g(TMPItemOptionCodeArr(xOptionCode,SttDat))
			Set DoctorDR=$p(CodeInfo,"^",1)
			Set SttDat=$p(CodeInfo,"^",2)
			Set SttTime=$p(CodeInfo,"^",3)
			Set ObjectID=$p(CodeInfo,"^",4)
			Set ItemOptionCodeStr=ItemOptionCodeStr_","_xOptionCode
			Set DocStr=DocStr_","_DoctorDR
			Set SttDateStr=SttDateStr_","_SttDat
			Set SttTimeStr=SttTimeStr_","_SttTime
			Set ObjectIDStr=ObjectIDStr_","_ObjectID	
		}
	Set:ItemOptionCodeStr'="" ItemOptionCodeStr=$e(ItemOptionCodeStr,2,$l(ItemOptionCodeStr))
	Set:DocStr'="" DocStr=$e(DocStr,2,$l(DocStr))
	Set:SttDateStr'="" SttDateStr=$e(SttDateStr,2,$l(SttDateStr))
	Set:SttTimeStr'="" SttTimeStr=$e(SttTimeStr,2,$l(SttTimeStr))
	Set:ObjectIDStr'="" ObjectIDStr=$e(ObjectIDStr,2,$l(ObjectIDStr))
	Set:ItemOptionCodeStr'="" return=ItemOptionCodeStr_"^"_DocStr_"^"_SttDateStr_"^"_SttTimeStr_"^"_ObjectIDStr
	quit return
}

/// 通过医嘱项取该项目通用名下所有医嘱项
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).GetGEArcByARCID("93||1")
ClassMethod GetGEArcByARCID(Arcim As %String) As %String
{
 ;取通用名
	n (Arcim)
	s ret=""
	//q:inci="" ""
	//s arcim=$p($g(^INCI(inci,1)),"^",3)
	q:Arcim="" ""
	s sub=$p(Arcim,"||",1),ver=$p(Arcim,"||",2)
	s gene=$p($g(^ARCIM(sub,ver,8)),"^",20)
 
	//q:gene="" ""
	s PHCGeneDesc=$p($g(^ARCIM(sub,ver,8)),"^",21)

	q:((gene="")&&(PHCGeneDesc="")) Arcim
	
	;s:PHCGeneDesc["-" PHCGeneDesc=$tr(PHCGeneDesc,"-","") ;武川
	s:PHCGeneDesc["-" PHCGeneDesc=$p(PHCGeneDesc,"-",1) ;赛罕
	;s gene=$o(^PHCGE("GE",0,"Name",PHCGeneDesc,0))
	s:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,+$p(Arcim,"||",2),1)),"^",2)   //医嘱名称
	s ArcItmDesc=""
	
	for {
		s ArcItmDesc=$o(^ARC("ALIAS",0,"Desc",PHCGeneDesc_" ",ArcItmDesc))
		q:ArcItmDesc=""
		
		s GeSub=$o(^ARC("ALIAS",0,"Desc",PHCGeneDesc_" ",ArcItmDesc,0))
		s ArcID=$p($g(^ARC("ALIAS",0,"Desc",PHCGeneDesc_" ",ArcItmDesc,GeSub,1)),"^",1)
		s:ret'[ArcID ret=ret_"^"_ArcID
	}
	
		s GeSub=0
		for{
			s GeSub=$o(^ARCIM(0,"Gener",gene,GeSub))
			q:GeSub="" 
			s ArcID=GeSub_"||"_ver
			s:ret'[ArcID ret=ret_"^"_ArcID
			
		}                              
	s:ret'="" ret=$e(ret,2,$l(ret))
	s:ret="" ret=Arcim
	q ret
}

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  检验检查结果表达式  
/// Input:	%EpisodeID/就诊号,%ItemID/项目ID
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpLisResult()
ClassMethod ExpLisResult(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	
	//首先找到该项目是否存在关联项目
	//根据关联项目找到医嘱，再由医嘱找到检验检查号
	//最后找到检验检查结果
}

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  手术前用药表达式  
/// Input:	aOperLink/关联手术,aStime/开始时间,aEtime/截止时间,aStime<aEtime,时间单位分钟/m，小时/h
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpDrugBeforeOper()
ClassMethod ExpDrugBeforeOper(aOperLink As %String, aStime As %String, aEtime As %String) As %String
{
	new (%EpisodeID,%ItemID,aOperLink,aStime,aEtime)
	Set return=""
	
	//根据手术取手术开始时间
	Set operSDate=""
	Set operSTime=""


	//计算用药开始，结束时间
	Set sStr=..CalcuTime(operSDate,operSTime,aStime,"before")
	Set eStr=..CalcuTime(operSDate,operSTime,aEtime,"before")
	Set drugSDate=$p(eStr,",",1),drugSTime=$p(eStr,",",2)
	Set drugEDate=$p(sStr,",",1),drugETime=$p(sStr,",",2)
	
	Set optionID=""
	for {
		Set optionID=$o(^DHCMA.CPW.SD.QCItemOptionsI("IndexOfItem",%ItemID,optionID))
		quit:optionID=""
		
		Set optMatchID=""
		for {
			Set optMatchID=$o(^DHCMA.CPW.SD.QCOptionMatchI("IndexOfItemOptionDr",optionID,optMatchID))
			quit:optMatchID=""
			
			Set objMatch=##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(optMatchID)
			Set type=objMatch.OMType
			Set ArcimID=objMatch.OMArcimID
			Set Generic=objMatch.OMPHCGeneric
			Set Category=objMatch.OMCategory
			
			Set ordMastID=""
			// 医嘱匹配
			Set:type=1 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfArcim",ArcimID,""))
			// 通用名匹配
			Set:type=2 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfGeneric",Generic,""))
			// 分类匹配
			Set:type=3 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfCate",Category,""))
			Continue:ordMastID=""
			Set objOrdMast=""
			// 判断医嘱时间是否在规定时间内
			Continue:(objOrdMast.SttDate<drugSDate)||(objOrdMast.SttDate>drugEDate)
			Continue:(objOrdMast.SttTime<drugSTime)||(objOrdMast.SttTime>drugETime)
			
			Set return=objOrdMast.ItemDesc_"^"_objOrdMast.DocDesc_"^"_objOrdMast.SttDate_"^"_objOrdMast.SttTime
			
			quit:return'=""		
		}
		quit:return'=""	
	}
	
	quit return
}

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  手术中用药表达式  
/// Input:	aOperLink/关联手术,aStime/开始时间,aEtime/截止时间,时间单位均为分钟
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpDrugInOper()
ClassMethod ExpDrugInOper(aOperLink As %String) As %String
{
	new (%EpisodeID,%ItemID,aOperLink,aStime,aEtime)
	Set return=""
	
	//根据手术取手术开始时间
	Set operSDate=""
	Set:operSDate["-" operSDate=$zdh(operSDate)
	Set operSTime=""
	Set:operSTime[":" operSTime=$zth(operSTime)
	Set operEDate=""
	Set:operEDate["-" operEDate=$zdh(operEDate)
	Set operETime=""
	Set:operETime[":" operETime=$zth(operETime)
	
	//用药判断的开始，结束时间
	Set drugSDate=operSDate,drugSTime=operSTime
	Set drugEDate=operEDate,drugETime=operETime

	
	Set optionID=""
	for {
		Set optionID=$o(^DHCMA.CPW.SD.QCItemOptionsI("IndexOfItem",%ItemID,optionID))
		quit:optionID=""
		
		Set optMatchID=""
		for {
			Set optMatchID=$o(^DHCMA.CPW.SD.QCOptionMatchI("IndexOfItemOptionDr",optionID,optMatchID))
			quit:optMatchID=""
			
			Set objMatch=##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(optMatchID)
			Set type=objMatch.OMType
			Set ArcimID=objMatch.OMArcimID
			Set Generic=objMatch.OMPHCGeneric
			Set Category=objMatch.OMCategory
			
			Set ordMastID=""
			// 医嘱匹配
			Set:type=1 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfArcim",ArcimID,""))
			// 通用名匹配
			Set:type=2 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfGeneric",Generic,""))
			// 分类匹配
			Set:type=3 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfCate",Category,""))
			Continue:ordMastID=""
			Set objOrdMast=""
			// 判断医嘱时间是否在规定时间内
			Continue:(objOrdMast.SttDate<drugSDate)||(objOrdMast.SttDate>drugEDate)
			Continue:(objOrdMast.SttTime<drugSTime)||(objOrdMast.SttTime>drugETime)
			
			Set return=objOrdMast.ItemDesc_"^"_objOrdMast.DocDesc_"^"_objOrdMast.SttDate_"^"_objOrdMast.SttTime
			
			quit:return'=""		
		}
		quit:return'=""	
	}
	
	quit return
}

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  手术后用药表达式  
/// Input:	aOperLink/关联手术,aStime/开始时间,aEtime/截止时间,时间单位均为分钟
/// OutPut: 空/未执行,非空(返回全部有效记录)/执行
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpDrugAfterOper()
ClassMethod ExpDrugAfterOper(aOperLink As %String, aStime As %String, aEtime As %String) As %String
{
	new (%EpisodeID,%ItemID,aOperLink,aStime,aEtime)
	Set return=""
	
	//根据手术取手术开始时间
	Set operEDate=""
	Set operETime=""


	//计算用药开始，结束时间
	Set sStr=..CalcuTime(operEDate,operETime,aStime,"after")
	Set eStr=..CalcuTime(operEDate,operETime,aEtime,"after")
	Set drugSDate=$p(sStr,",",1),drugSTime=$p(sStr,",",2)
	Set drugEDate=$p(eStr,",",1),drugETime=$p(eStr,",",2)
	
	Set optionID=""
	for {
		Set optionID=$o(^DHCMA.CPW.SD.QCItemOptionsI("IndexOfItem",%ItemID,optionID))
		quit:optionID=""
		
		Set optMatchID=""
		for {
			Set optMatchID=$o(^DHCMA.CPW.SD.QCOptionMatchI("IndexOfItemOptionDr",optionID,optMatchID))
			quit:optMatchID=""
			
			Set objMatch=##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(optMatchID)
			Set type=objMatch.OMType
			Set ArcimID=objMatch.OMArcimID
			Set Generic=objMatch.OMPHCGeneric
			Set Category=objMatch.OMCategory
			
			Set ordMastID=""
			// 医嘱匹配
			Set:type=1 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfArcim",ArcimID,""))
			// 通用名匹配
			Set:type=2 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfGeneric",Generic,""))
			// 分类匹配
			Set:type=3 ordMastID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfCate",Category,""))
			Continue:ordMastID=""
			Set objOrdMast=""
			// 判断医嘱时间是否在规定时间内
			// 判断医嘱时间是否在规定时间内
			Continue:(objOrdMast.SttDate<drugSDate)||(objOrdMast.SttDate>drugEDate)
			Continue:(objOrdMast.SttTime<drugSTime)||(objOrdMast.SttTime>drugETime)
			
			Set return=objOrdMast.ItemDesc_"^"_objOrdMast.DocDesc_"^"_objOrdMast.SttDate_"^"_objOrdMast.SttTime
			
			quit:return'=""		
		}
		quit:return'=""	
	}
	
	quit return
}

/// 时间转换
ClassMethod CalcuTime(operDate, operTime, aTime, aFlag) As %String
{
	New (operDate,operTime,aTime,aFlag)
	Set return=""
	Quit:(operDate="")||(operTime="")||(aTime="") return

	Set:operDate["-" operDate = $zdh(operDate,3)
	Set:operTime[":" operTime = $zth(operTime,1)
	//转换分钟/小时
	Set ChangeSecond=""
	Set:aTime["m" ChangeSecond=aTime*60
	Set:aTime["h" ChangeSecond=aTime*3600
	
	Set Second       = aDate*24*3600+aTime
	//判断时间前后，加减
	if (aFlag="before"){
		Set Second       = Second-ChangeSecond	
	} elseif (aFlag="after"){
		Set Second       = Second+ChangeSecond	
	} else {
		
	}
	//生成时间
	Set Hours = Second\3600
	Set Date  = Hours\24
	Set Time  = Second-(Date*24*3600)

	Set DateTime = Date_","_Time

	Set return=DateTime
	Quit return
}

/// s a=##class(DHCMA.CPW.SDS.QCExpressSrv).GetObjByDesc("年龄","")
ClassMethod GetObjByDesc(aAlias As %String, aTypeCode As %String) As DHCMA.CPW.SD.QCExpress
{
	new (aAlias,aTypeCode)
	Set return=""
	Quit:(aTypeCode="")||(aAlias="") return
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SD.QCExpressD(xRowID))
	 	Quit:(xRowID="")||(return'="")
	 	Set ObjExpress    = ##class(DHCMA.CPW.SD.QCExpress).GetObjById(xRowID)
	 	Set Code          = ObjExpress.BTCode
	 	Set Desc          = ObjExpress.BTDesc
	 	Continue:(aTypeCode'="")&&(ObjExpress.BTTypeDr.BTCode'=aTypeCode)  
	 	Set:Desc[aAlias return=ObjExpress
 	}
 Quit return
}

/*以上为表单数据同步处理函数*/

/*以下是单病种准入、排除条件判断函数，非取值函数*/
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).testRuleMehod()
ClassMethod testRuleMehod()
{
	Set %EpisodeID="2457253!!1"
	//,%ItemID="13||114",%MRlistID="216"
	Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpAge("<18岁")
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpHospInf("HAP")
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpHospDays(">60")
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpRepeatedHosp("<30")
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpNonFirstDiag()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpMDiag("I63.0~I63.6，I63.8，I63.9")
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpTransfer()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpEMRInfo()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOrder()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpWithItemInfo()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpFPDOInfo()
	;Set ret=##class(DHCMA.CPW.SDS.QCExpressSrv).ExpFeeInfo()
	Quit ret
}

/// Description:  根据配置类型 获取编目诊断手术
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpFPDOInfo(
ClassMethod ExpFPDOInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	// 找到就诊基础信息的取值参数
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	if (param="D"){
		Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(EpisodeID,"D/1",1)
		Set ODiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D/2")
		Set MDiagStr=MDiagStr_$c(1)_ODiagStr
	}
	elseif (param="O"){
		Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(EpisodeID,"O/1",1)
		Set ODiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"O/3")
		Set MDiagStr=MDiagStr_$c(1)_ODiagStr
	}else{
		Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(EpisodeID,param,1)
	}
	Set Len=$l(MDiagStr,$c(1))
	for i=1:1:Len{
		Set xDiagStr=$p(MDiagStr,$c(1),i)
		Set xDiagCode=$p(xDiagStr,$c(2),1)
		Set xDiagDesc=$p(xDiagStr,$c(2),2)
		Continue:xDiagCode="" 
		Set return=..MatchItemDic(xDiagCode,objItem.Parref.%Id(),objItem.BTVersion.%Id(),objItem.BTCode)
		quit:return'=""
	}
	
	
	/*Set MDiagCode=$p(MDiagStr,$c(1),1)
	
	
	Set MDiagCode=$p(MDiagStr,$c(2),1)
	Set MDiagDesc=$p(MDiagStr,$c(2),2)
	quit:MDiagCode="" return 
	Set return=..MatchItemDic(MDiagCode,objItem.Parref.%Id(),objItem.BTVersion.%Id(),objItem.BTCode)*/
	Quit return
}

/// Description:  根据配置类型 获取默认值
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).GetDefaultVal()
ClassMethod GetDefaultVal() As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	Quit param
}

/// Description:  手术手麻系统信息
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOperInfo()
ClassMethod ExpOperInfo(arg As %String = "") As %String
{
	new (%EpisodeID,%ItemID)
	Set return=""
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	Quit:param="" return
	Set objEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjById($p(%ItemID,"||",1))
	Set OperKey=objEntity.BTOperKey
	Set paadm=$p(%EpisodeID,"!!",1)
	Set objArr=##class(DHCMA.CPW.SD.DataSrv.OperationSrv).GetDataByAdm(paadm,OperKey)
	if (objArr.Count()>0) {
		Set obj=objArr.GetAt(1)
		Set return="Set return = obj."_param
		x return
	}
	
	quit return
}

/// Description:  主要诊断入组判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpMDiag()
ClassMethod ExpMDiag(aMDiag As %String = "") As %String
{
	new (aMDiag,%EpisodeID,%ItemID)
	Set return="N"
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Set aMDiag=$tr(aMDiag,"~","-")
	Set aMDiag=$tr(aMDiag,"、",",")
	Set IsOnlyMain=##class(DHCMA.Util.BT.Config).GetValueByCode("SDIsCheckMDiag")
	Set DataSource="2"
	;诊断数据来源
	if (DataSource=1) {
		//住院病案首页诊断
		Set MainDig="HDSD**"
		Set MDiagStr=病历接口(%EpisodeID,MainDig)
		Set OtherDig=$lb("HDSD**","HDSD**"),ODiagStr=""
		if (IsOnlyMain="N") {
			for oindex=1:1:$ll(OtherDig) {
				Set xOtherDig=$lg(OtherDig,oindex)
				Continue:xOtherDig=""
				Set xODiag=病历接口(%EpisodeID,xOtherDig)
				Set ODiagStr=ODiagStr_$c(1)_xODiag
			}
		}
		Set DiagStr=MDiagStr_$c(1)_ODiagStr
	}elseif(DataSource=2) {	
		//编目诊断
		Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(EpisodeID,"D/1",1)
		Set ODiagStr="",DiagStr=""
		If (IsOnlyMain="N"){
			Set ODiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D/2")	
		}
		Set DiagStr=MDiagStr_$c(1)_ODiagStr
	}else{
		//诊断录入
		Set MRAdm=$p($g(^PAADM(+EpisodeID)),"^",61)
		Quit:MRAdm="" return
		Set MRDIASub="",DiagStr=""
		for {
			Set MRDIASub=$o(^MR(MRAdm,"DIA",MRDIASub))
			Quit:MRDIASub=""
			Set TypeID=$o(^MR(MRAdm,"DIA",MRDIASub,"TYP",""),-1)
			continue:TypeID=""
			Set MRDIATypeID=$g(^MR(MRAdm,"DIA",MRDIASub,"TYP",TypeID))
			Set TypeCode=$p($g(^MRC("DTYP",+MRDIATypeID)),"^",1)
			Set TypeDesc=$p($g(^MRC("DTYP",+MRDIATypeID)),"^",2)
			continue:(IsOnlyMain="Y")&&(TypeCode'="DIS")   //DIS 为出院主诊断代码
			Set MRDiagnosID=MRAdm_"||"_MRDIASub
			Set ICDDR=$p($g(^MR(MRAdm,"DIA",MRDIASub)),"^",1)
			Set ICD10=$p($g(^MRC("ID",+ICDDR)),"^",4)
			Set ICDDesc=$p($g(^MRC("ID",+ICDDR)),"^",2)
			continue:(ICD10="")
			Set DiagStr=DiagStr_$c(1)_ICD10_$c(2)_ICDDesc
		}
	}
	Quit:DiagStr="" return
	//匹配诊断是否符合准入标准
	For idx=1:1:$l(DiagStr,$c(1)){
		Set DiagInfo=$p(DiagStr,$c(1),idx)
		Continue:DiagInfo=""
		Set MDiagCode=$p(DiagInfo,$c(2),1)
		Set MDiagDesc=$p(DiagInfo,$c(2),2)
		Continue:MDiagCode=""
		Set flag=""
		for i=1:1:$l(aMDiag,",")
		{
			Set xDiagCode=$p(aMDiag,",",i)
			Set flag=..CheckICDArea(MDiagCode,xDiagCode)
			Set:flag=1 return="Y"
			quit:flag=1
		}
		Quit:return="Y"
		for i=1:1:$l(aMDiag,",")
		{
			Set xDiagDesc=$p(aMDiag,",",i)
			Set flag=..CheckKeyArea(MDiagDesc,xDiagDesc)
			Set:flag=1 return="Y"
			quit:flag=1
		}
	}
	quit return
}

/// Creator：     fcz
/// CreatDate：   2019-3-8
/// Description:  其他诊断判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpODiag()
ClassMethod ExpODiag(aODiag As %String = "") As %String
{
	new (aODiag,%EpisodeID)
	Set return="N"
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Quit:aODiag="" return
	Set aODiag=$tr(aODiag,"~","-")
	Set aODiag=$tr(aODiag,"、",",")
	Set OtherDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D/2")
	quit:OtherDiagStr="" return
	Set flag=""
	for i=1:1:$l(OtherDiagStr,$c(1))
	{	
		Set iOtherDiagStr=$p(OtherDiagStr,$c(1),i)
		Set iOtherDiagCode=$p(iOtherDiagStr,$c(2),1)
		continue:iOtherDiagCode=""
		Set flag=..CheckICDArea(iOtherDiagCode,aODiag)
		Set:flag=1 return="Y"
		quit:flag=1
	}
	Quit:return="Y" return
	for i=1:1:$l(OtherDiagStr,$c(1))
	{
		Set iOtherDiagStr=$p(OtherDiagStr,$c(1),i)
		Set iOtherDiagDesc=$p(iOtherDiagStr,$c(2),2)
		Set flag=..CheckKeyArea(iOtherDiagDesc,aODiag)
		Set:flag=1 return="Y"
		quit:flag=1
	}
	quit return
}

/// CreatDate：   2021-11-8
/// Description:  全部诊断判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpAllDiag()
ClassMethod ExpAllDiag(aDiag As %String = "") As %String
{
	new (aDiag,%EpisodeID)
	Set return="N"
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Quit:aDiag="" return
	Set aDiag=$tr(aDiag,"~","-")
	Set aDiag=$tr(aDiag,"、",",")
	Set AllDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D")
	quit:AllDiagStr="" return
	Set flag=""
	for i=1:1:$l(AllDiagStr,$c(1))
	{	
		Set iAllDiagStr=$p(AllDiagStr,$c(1),i)
		Set xDiagCode=$p(iAllDiagStr,$c(2),1)
		Set xDType=$p(iAllDiagStr,$c(2),10)
		Continue:xDType["门急诊"  //过滤掉门急诊诊断
		Set flag=..CheckICDArea(xDiagCode,aDiag)
		Set:flag=1 return="Y"
		quit:flag=1
	}
	Quit:return="Y" return
	for i=1:1:$l(AllDiagStr,$c(1))
	{
		Set iAllDiagStr=$p(AllDiagStr,$c(1),i)
		Set xDiagDesc=$p(iAllDiagStr,$c(2),2)
		Set flag=..CheckKeyArea(xDiagDesc,aDiag)
		Set:flag=1 return="Y"
		quit:flag=1
	}
	quit return
}

/// Creator：     fcz
/// CreatDate：   2019-3-8
/// Description:  手术判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOper()
ClassMethod ExpOper(aOper As %String) As %String
{
	new (aOper,%EpisodeID)
	Set return="N"
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Set aOper=$tr(aOper,"~","-")
	Set aOper=$tr(aOper,"、",",")
	Set OperAllStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"O/1")
	quit:OperAllStr="" return
	
	Set flag=""
	for i=1:1:$l(OperAllStr,$c(1))
	{
		Set xOperStr=$p(OperAllStr,$c(1),i)
		Set OperCode=$p(xOperStr,$c(2),1)
		continue:OperCode=""
		Set flag=..CheckICDArea(OperCode,aOper)
		quit:flag=1	
	}
	Set:flag=1 return="Y"
	quit return
}

/// Description:  主手术判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpMOper()
ClassMethod ExpMOper(aOper As %String) As %String
{
	new (aOper,%EpisodeID)
	Set return="N"
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Set aOper=$tr(aOper,"~","-")
	Set aOper=$tr(aOper,"、",",")
	Set OperStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(EpisodeID,"O/1",1)
	Quit:OperStr="" return
	
	Set flag=""
	Set OperCode=$p(OperStr,$c(2),1)
	Quit:OperCode="" return
	Set flag=..CheckICDArea(OperCode,aOper)
	Set:flag=1 return="Y"
	quit return
}

/// Creator：     zgz
/// CreatDate：   2019-3-12
/// 转院
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpTransfer
ClassMethod ExpTransfer(arg As %String = "") As %String
{
	new (%EpisodeID,arg)
	Set return="N"
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set TransferCode=##class(DHCMA.Util.BT.Config).GetValueByCode("SDTransferCode")
	Set Tranfer=##Class(EPRservice.BOScatterData).GetDataByGlossary(Paadm,TransferCode)
	//新版的病案编目最好用这个
	//set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,$e(EMRCode,1,9))
	Set:Tranfer["转入" return="Y"
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2019-3-12
/// 检查结果
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpInspection
ClassMethod ExpInspection(arg As %String = "") As %String
{
	Set return="N"
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2019-3-12
/// 临床试验
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpClinicTest
ClassMethod ExpClinicTest(arg As %String = "") As %String
{
	Set return="N"
	Quit return
}

/// Creator：     fcz
/// CreatDate：   2019-3-8
/// Description:  年龄判断  
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpAge()
ClassMethod ExpAge(aAge As %String) As %String
{
	new (aAge,%EpisodeID)
	Set return="N"
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(Paadm)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(OID)
	Set AgeStr=objPaadm.PAAge
	Set yAge=0,mAge=0,dAge=0,targetAge=0
	if (AgeStr["岁") {
		Set yAge=+$p(AgeStr,"岁",1)
		Set dAge=yAge*365
	}elseif(AgeStr["月"){
		Set mAge=+$p(AgeStr,"月",1)
		Set dAge=mAge*30
		}
	elseif(AgeStr["天"){
		Set dAge=+$p(AgeStr,"天",1)
	}elseif((AgeStr["时")||(AgeStr["分")||(AgeStr["秒")){
		Set yAge=0
		Set dAge=0
	}else{
		Set yAge=+AgeStr
		Set dAge=yAge*365
		}
	//年龄判断，判断岁和天两种情况。
	if (aAge["天") {
		Set targetAge=dAge
		Set aAge=$tr(aAge,"天","")
	}elseif (aAge["月") {
		Set targetAge=mAge
		Set aAge=$tr(aAge,"月","")
	}else{
		//默认单位为：岁
		Set targetAge=yAge
		Set aAge=$tr(aAge,"岁","")
		}
	Set str="Set flag="_targetAge_aAge
	x str
	Set:flag=1 return="Y"
	quit return
}

/// Creator：     zgz
/// CreatDate：   2019-3-8
/// input 感染部位代码：如VAP-呼吸机相关性肺炎VAP ;HCAP-护理相关性肺炎HCAP;HAP-医院获得性肺炎HAP
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpHospInf("VAP")
ClassMethod ExpHospInf(aInfPos) As %String
{
	new (aInfPos,%EpisodeID)
	Set $ZT="GetHospInfMsgErr"
	Set:aInfPos="HCAP" aInfPos="HAP" //感染系统没找到HCAP定义，HAP处理
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set xRepID=0,return="N"
	for {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,xRepID))
		quit:xRepID=""
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.ReportType)
		Set ReportTypeCode=objReport.ReportType.Code
		Continue:ReportTypeCode'="COMP"
		Continue:'$IsObject(objReport.ReportStatus)
		Set ReportStatusDesc=objReport.ReportStatus.Description
		Continue:ReportStatusDesc["删除"
		//判断感染类别
		Set SumID=$o(^DHCMed.NINF("InfRep",xRepID,"Summ",""),-1)
		Set SumObj=##Class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(xRepID_"||"_SumID)
		Set InfTypeDesc=SumObj.InfectionType.Description
		Continue:InfTypeDesc["社区"
		
		Set xSubID=0
		for {
			Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",xSubID))
			quit:xSubID=""		
			Set objSub=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			Set (InfPosDesc,InfDiagDesc)=""
			if $IsObject(objSub.InfDiag) {
				Set InfDiagID=objSub.InfDiag.%Id()
				Set InfDiagDesc=objSub.InfDiag.IDDesc
			}
			Set:InfDiagDesc["肺炎" InfDiagDesc="HAP"    
			//侵害性操作
			For indInfPosOpr=1:1:objSub.InfPosOpr.Count() {
				Set objInfPosOpr=objSub.InfPosOpr.GetAt(indInfPosOpr)
				Continue:'$IsObject(objInfPosOpr) 
				Set InfPosOpr=objInfPosOpr.InvasiveOper.Description
				Set:InfPosOpr["呼吸机" InfDiagDesc="VAP"
			}
			Set:InfDiagDesc=aInfPos return="Y"
		}
	}
	
	quit return
	
GetHospInfMsgErr
	Set Error=$ZError
	Quit Error
}

/// Creator：     zgz
/// CreatDate：   2019-3-8
/// 反复门诊XXX类别药物治疗无效
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOPDrug
ClassMethod ExpOPDrug(arg As %String = "") As %String
{
	Set return="N"
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2019-3-8
/// 住院日 
/// input :>60 <180
ClassMethod ExpHospDays(aCompareDay) As %String
{
	new (%EpisodeID,aCompareDay)
	Set return="N"	
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(Paadm)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(OID)
	if ($IsObject(objPaadm)){
			Set AdmDate=objPaadm.PAAdmDate
			Set:AdmDate'="" AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(AdmDate)
			Set DishDate=objPaadm.PADischDate
			Set:DishDate'="" DishDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(DishDate)
			Set:DishDate="" DishDate=+$h
		}
	Set InHosDay=DishDate-AdmDate
	Set exp="Set flg="_InHosDay_aCompareDay
	x exp
	Set:flg=1 return="Y"
	Quit return
}

/// 非首次确诊
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpNonFirstDiag
ClassMethod ExpNonFirstDiag(arg As %String = "") As %String
{
	new (%EpisodeID,arg)
	Set return="N"
	Set Paadm=$p(%EpisodeID,"!!",1)
	//如果根据编码判断其首次就诊情况，很多都不一致，但属于同一单病种情况？
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(Paadm)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(OID)
	Set AdmitDate = objPaadm.PAAdmDate
	Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(Paadm,"D/1",1)
	Set CurrMDiagCode=$p(MDiagStr,$c(2),1)
	Quit:CurrMDiagCode="" return          ;如果当次主要诊断没取到，则退出
	Set PatientID=$p($g(^PAADM(+Paadm)),"^",1)
	Quit:PatientID="" return
	Set AdmType="I"
	Set xPaadm=Paadm
	For {
		Set xPaadm=$o(^PAPERdr(PatientID,"ADM",AdmType,xPaadm),-1)
		Quit:xPaadm=""
		Set VisitStatus=$p($g(^PAADM(xPaadm)),"^",20)
		Continue:VisitStatus="C"  //取消就诊
		Set MDiagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(xPaadm,"D/1",1)
		Set BeforeMDiagCode=$p(MDiagStr,$c(2),1)
		Continue:BeforeMDiagCode'=CurrMDiagCode  //判断是否有历次相同诊断，for是否首次确诊
		Set return="Y"
		Quit
	}
			
	Quit return
}

/// 重复住院
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpRepeatedHosp
ClassMethod ExpRepeatedHosp(arg As %String = "") As %String
{
	new (%EpisodeID,arg)
	Set return="N"
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(Paadm)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(OID)
	Quit:'$IsObject(objPaadm) return
	Set AdmitDate = objPaadm.PAAdmDate
	Quit:AdmitDate="" return
	Set PatientID=$p($g(^PAADM(+Paadm)),"^",1)
	Quit:PatientID="" return
	///当次就诊入组单病种
	Set MrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",%EpisodeID,""),-1)
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrlistID)
	Quit:MrListObj.QCState="O" return  						//排除状态的过滤
	Set tQCID=MrListObj.QCEntityDr.%Id()
	Set AdmType="I"
	Set xPaadm=Paadm
	For {
		Set xPaadm=$o(^PAPERdr(PatientID,"ADM",AdmType,xPaadm),-1)
		Quit:xPaadm=""
		Set VisitStatus=$p($g(^PAADM(xPaadm)),"^",20)
		Continue:VisitStatus="C"  //取消就诊
		Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
		Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(EpisodeID)
		Continue:'$IsObject(objPaadm)
		Continue:'$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))		//如果没入单病种，不做重复入组筛查
		Set AdmitDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(AdmitDate)
		Set PreDishDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(objPaadm.PADischDate)
		Continue:(AdmitDate="")||(PreDishDate="")
		Quit:(AdmitDate-PreDishDate)>365   						//默认如果两次就诊时间已经超过一年，则不再判断重复
		Set xMrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,""),-1)
		Continue:xMrlistID=""
		Set xMrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrlistID)
		Continue:xMrListObj.QCState="O"  						//排除状态的过滤
		Set QCID=xMrListObj.QCEntityDr.%Id()
		Continue:tQCID'=QCID									//匹配是否为同一疾病重复上报单病种
		Set exp="Set flg=(AdmitDate-PreDishDate)"_arg
		x exp													//判断病种是否是要求范围内的重复上报
		Set:flg=1 return="Y"
		Quit:flg=1
	}
			
	Quit return
}

/// 获取孕周信息
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpPregnant()
ClassMethod ExpPregnant(arg As %String = "") As %String
{
	New (%EpisodeID)
	Set return=""
	Quit return //暂无获取孕周信息方法
	Quit:(%EpisodeID="") return
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set PregnantCode=##class(DHCMA.Util.BT.Config).GetValueByCode()
	Set PregnantWeek=##Class(EPRservice.BOScatterData).GetDataByGlossary(Paadm,PregnantCode)
	//新版的病案编目最好用这个
	//set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,$e(EMRCode,1,9))
	If ((+PregnantWeek<28)||(+PregnantWeek>39)||(PregnantWeek="")){
		Set return="Y"
	}Else{
		Set return="N"
	}
	
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpDisch24h()
ClassMethod ExpDisch24h(arg As %String = "") As %String
{
	New (%EpisodeID,arg)
	Set return=""
	Quit:%EpisodeID="" return
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(%EpisodeID)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(OID)
	Quit:'$IsObject(objPaadm) return
	Set DishTypeCode=##class(DHCMA.Util.BT.Config).GetValueByCode("SDDishTypeCode")
	Set:DishTypeCode="" DishTypeCode="HDSD00.11.057"
	Set DishType=##Class(EPRservice.BOScatterData).GetDataByGlossary(Paadm,DishTypeCode)
	//新版的病案编目最好用这个
	//set Glossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,$e(EMRCode,1,9))
	Set AdmitDate = objPaadm.PAAdmDate
	Set AdmitTime = objPaadm.PAAdmTime
	Set DischDate = objPaadm.PADischDate
	Set DischTime = objPaadm.PADischTime
	Set AdmitDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(AdmitDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(DischDate)
	Set AdmitTime=##Class(DHCMA.Util.IO.FromHisSrv).GetTimeHtmlToLogical(AdmitTime)
	Set DischTime=##Class(DHCMA.Util.IO.FromHisSrv).GetTimeHtmlToLogical(DischTime)
	Set Hours1=(DischDate-AdmitDate)*24
	Set Hours2=(DischTime-AdmitTime)\3600
	If ((Hours1+Hours2)>24){
		Set return="N"
	}Else{
		Set return="Y"
		If (arg'="") {
			Set:((arg="TransOut")&&(DishType'["转院")) return="N"
			Set:((arg="NoOrderOut")&&(DishType="医嘱离院")) return="N"
		}
	}
	
	Quit return
}

ClassMethod ExpDeath24h(arg As %String = "") As %String
{
	New (%EpisodeID)
	Set return=""
	Quit:%EpisodeID="" return
	Set OID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(%EpisodeID)
	Set objPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(OID)
	Quit:'$IsObject(objPaadm) return
	
	Set AdmitDate = objPaadm.PAAdmDate
	Set AdmitTime = objPaadm.PAAdmTime
	Set DeathDate = objPaadm.PADeathDate
	Set DeathTime = objPaadm.PADeathTime
	Quit:DeathDate="" "N"
	Set AdmitDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(AdmitDate)
	Set DeathDate=##Class(DHCMA.Util.IO.FromHisSrv).GetDateHtmlToLogical(DeathDate)
	Set AdmitTime=##Class(DHCMA.Util.IO.FromHisSrv).GetTimeHtmlToLogical(AdmitTime)
	Set DeathTime=##Class(DHCMA.Util.IO.FromHisSrv).GetTimeHtmlToLogical(DeathTime)
	Set Hours1=(DeathDate-AdmitDate)*24
	Set Hours2=(DeathTime-AdmitTime)\3600
	If ((Hours1+Hours2)>24){
		Set return="N"
	}Else{
		Set return="Y"
	}
	
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2021-11-8
/// 入住ICU
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpIsICUPat()
ClassMethod ExpIsICUPat(arg As %String = "") As %String
{
	new (%EpisodeID,arg)
	Set return="N"
	Set Paadm=$p(%EpisodeID,"!!",1)
	Set xSub=0
	For {
		Set xSub=$o(^PAADM(Paadm,"TRANS",xSub))
		Quit:xSub=""
		Set tmpTrans=$g(^PAADM(Paadm,"TRANS",xSub))
		Set TransLoc=$p(tmpTrans,"^",6)  //科室
		Set TransWard=$p(tmpTrans,"^",9)  //病区
		Set TransBed=$p(tmpTrans,"^",8)  //床位
		Continue:(TransWard'="")||(TransBed'="") //只检索转科记录
		Set LocDesc=$p($g(^CTLOC(TransLoc)),"^",2)
		Set:(LocDesc["ICU")||(LocDesc["重症") return="Y"
	}
	Quit return
}

/// 准入规则-医嘱信息判断
/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).ExpOrdMatch("鼻腔")
ClassMethod ExpOrdMatch(aOrder As %String) As %String
{
	new (aOrder,%EpisodeID)
	Set return="N"
	Quit:aOrder="" return
	Set aOrder=$tr(aOrder,"，",",")
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Set OrdRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Set ArcimID=""
	for {
		Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdRowId,ArcimID))
		Quit:ArcimID=""
		Quit:return="Y"
		Set Desc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		For ind=1:1:$l(aOrder,",") {
			Set subOrder=$p(aOrder,",",ind)
			Set:Desc[subOrder return="Y"
			Quit:return="Y"
		}
	}
	Quit return
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).CheckICDArea("J45","J45-J46")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	Set:$e(argICD,$l(argICD))'=" " argICD=argICD_" "
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"、",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// 准入关键词范围检查方法
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).CheckKeyArea("CCC","AAA,BBB")
ClassMethod CheckKeyArea(argDiagDesc As %String, argArea As %String) As %String
{
	New (argDiagDesc,argArea)
	Set return=-1
	Quit:(argArea="")||(argDiagDesc="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"、",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	Set argDiagDesc=$tr(argDiagDesc,"，",",")
	Set argDiagDesc=$tr(argDiagDesc,"－","-")
	Set argDiagDesc=$tr(argDiagDesc,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Continue:argDiagDesc'[Area
		Set return=1
		Quit:return=1
	}
	
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCExpressSrv).MatchItemDic("I63.1",3,2,"CM-0-1-3-1")
ClassMethod MatchItemDic(aValue, aQCID, aVersion, aItemCode) As %String
{
	n (aValue,aQCID,aVersion,aItemCode)
	Set return="",ICDCode=""
	Quit:aValue="" return
	k ^tmpItemDicArr,^tmpFilterArr
	Set xDesc=""
	set rs=..GetQryDataByMethod("DHCMA.CPW.SDS.DictionarySrv","QryDictByType",aQCID,aVersion,aItemCode,1)
	For xInd=1:1:rs.Count()
	{
		Set rec=rs.GetAt(xInd)
		set xcode=rec.Data("BTCode")
		set xDesc=rec.Data("BTDesc")
		Set xDesc=..trim(xDesc)
		If ((xDesc["：")||(xDesc[":")){
			//区间范围
			Set xDesc=$tr(xDesc,"：",":")
			Set xDesc=$tr(xDesc," ","")
			Set xDesc=$p(xDesc,":",2)
			Set xDesc=$tr(xDesc,"至","-") 
		}else{
			Set ICDCode=""
			for yInd=1:1:$l(xDesc) {
				Set xcon=$e(xDesc,yInd,yInd)
				//编码为空或者为汉字，则退出
				Quit:(xcon="")||($ASCII(xcon)>127)
				Set ICDCode=ICDCode_xcon
			}
			Set xDesc=ICDCode
		}
		Set xDesc=$tr(xDesc," ","")
		Continue:xDesc=""
		Set Flg=..CheckICDArea(aValue,xDesc)
		Set:Flg=1 ^tmpFilterArr(xcode)=""
	}
	Set:$d(^tmpFilterArr)>0 return=$o(^tmpFilterArr(""),-1)
	Quit return
}

ClassMethod GetQryDataByMethod(aClassName As %String, aQueryName As %String, aInputStr...) As %ArrayOfDataTypes
{
	New (aClassName,aQueryName,aInputStr)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aClassName="")||(aQueryName="") return
	
	Set ParamStr = ""
	For ParamIndex=1:1:$g(aInputStr,0){
		Set @("Param"_ParamIndex)=$g(aInputStr(ParamIndex),"")
		Set ParamStr=ParamStr_","_"Param"_ParamIndex
	}
	Set:ParamStr'="" ParamStr=$e(ParamStr,2,$l(ParamStr))
	
	Set rs=##Class(%ResultSet).%New(aClassName_":"_aQueryName)
	XECUTE "Set sc=rs.Execute("_ParamStr_")"
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	Set ColumnCount = rs.GetColumnCount()
  	Set xCount=0
    While (rs.Next()){
	    Set ResInfo=##Class(%ArrayOfDataTypes).%New()
		For xColumnIndex = 1:1:ColumnCount {
			Set ColumnName = rs.GetColumnName(xColumnIndex)
			Set ColumnDate = rs.GetData(xColumnIndex)
			
			Do ResInfo.SetAt(ColumnDate,ColumnName)
		}
	    Set xCount=xCount+1
		Do return.SetAt(ResInfo,xCount)
    }
	Do rs.Close()
	Quit return
}

/// 通过住院证取门急诊时间
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).getOPAdmDT(2959615)
ClassMethod getOPAdmDT(AdmRowID As %String = "") As %String
{
	n (AdmRowID)
	s return=""
	q:AdmRowID="" return
	s DocIPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDTo",AdmRowID,""),-1)
	Q:DocIPBKRowID="" return
	s OPAdmRowID=$p($g(^DHCDocIPBK(DocIPBKRowID)),"^",2)
	s xAdmD=""
	s xAdmT=""
	if (OPAdmRowID'=""){
		s xAdmD=$p(^PAADM(OPAdmRowID),"^",6)
		s xAdmT=$p(^PAADM(OPAdmRowID),"^",7)
	}
	s return=xAdmD_"^"_xAdmT
	
	Q return
}

/// 取护理相关信息
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).GetNurInfo(2959615)
ClassMethod GetNurInfo(argArea As %String) As %String
{
	new (%EpisodeID,%ItemID)
	
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	s return=""
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	Quit:param="" return
	
	Set paadm=$p(%EpisodeID,"!!",1)
	Set return=##class(web.DHCMGNurComm).getFirstItemValue(EpisodeID,param)
	quit return
}

/// 取BMI相关信息
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).GetBMInfo(2692755)
ClassMethod GetBMInfo(argArea As %String) As %String
{
	new (%EpisodeID,%ItemID)
	
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	s return=""
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set param=objItem.GetDataParam
	d objItem.%Close()
	//Quit:param="" return
	
	Set paadm=$p(%EpisodeID,"!!",1)
	Set height=##class(web.DHCMGNurComm).getFirstItemValue(EpisodeID,"身高")
	Set weight=##class(web.DHCMGNurComm).getFirstItemValue(EpisodeID,"体重(kg)")
	quit:((height'>0)||(weight'>0)) return
	Set height=height/100
	Set BMI=weight/(height*height)
	Set return =$e(BMI,1,5)
	quit return
}

/// 取GCS评分
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).GetGCSInfo(2692755)
ClassMethod GetGCSInfo(argArea As %String) As %String
{
	new (%EpisodeID,%ItemID)
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	
	Set return="",GCSNum=""
	Set GCSNum=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,"#TYPE:TextDesc#TID:25#TVER:0#ECODE:E0015")
	Set:GCSNum["GCS评分" return=+$p(GCSNum,"GCS评分",2)
	quit return
}

/// 取计算值
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).GetCalcVal()
ClassMethod GetCalcVal(argArea As %String) As %String
{
	new (%EpisodeID,%ItemID,%MrListID)
	Set EpisodeID=$p(%EpisodeID,"!!",1)
	Set MrListID=%MrListID
	Set return=""
	Quit:MrListID="" return
	Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(%ItemID)
	// 取值参数
	Set ParamExp=objItem.GetDataParam
	Set aVerID=objItem.BTVersion.%Id()
	Set aQCEntityID=$p(%ItemID,"||",1)
	d objItem.%Close()
	Quit:ParamExp="" return
	//获取关联的项目代码
	Set CodeArr="",qFlg=0
	For j=1:1:$l(ParamExp,")") {
		Quit:qFlg=1
		Set CodeSub=$p(ParamExp,")",j)
		Set Code=$p(CodeSub,"(",2)
		continue:Code=""
		Set ItemDr=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCEntityID,Code)
		Set:'$IsObject(ItemDr) qFlg=1	//关联计算项如果没有值，则终止计算
		Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
		d ##class(DHCMA.CPW.SDS.QCTask).InitItemValue(MrListID,ItemDr.%Id())
		Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
		Set xItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_xSubID)
		Set xValue=""
		Set:'$IsObject(xItemExecObj) qFlg=1
		Set:$IsObject(xItemExecObj) xValue=xItemExecObj.ExecResult
		Set CodeArr(Code)=xValue
	}
	Quit:qFlg=1 return
	Set DicTypeDr=$o(^DHCMA.CPW.SD.DicTypeI("IdxofItemDR",%ItemID,0))
	Set YNFlg=0
	If (DicTypeDr) {
		Set xID="",DICCodeStr="",DicDescStr=""
		For {
	 		Set xID	= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDr",DicTypeDr,xID))
	 		Quit:xID=""
		 	//获取值域字典信息
		 	Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(xID)
		 	Continue:'$IsObject(DicObj)
		 	Set DicCode=DicObj.BTCode
		 	Set DicDesc=DicObj.BTDesc
		 	Set DICCodeStr=DICCodeStr_","_DicCode
		 	Set DicDescStr=DicDescStr_","_DicDesc
		}
		Set:((DICCodeStr["y,n")||(DICCodeStr["n,y")) YNFlg=1
	}
	If (objItem.BTTypeDr.BTDesc="日期时间"){
		Set xCode=""
		For {
			Set xCode=$o(CodeArr(xCode))
			Quit:xCode=""
			Set xDateTime=$g(CodeArr(xCode))
			Continue:xDateTime=""
			Set xDate=$p(xDateTime," ",1)
			Set xTime=$p(xDateTime," ",2)
			Set LogicxDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDate)
			Set LogicTime=$zth(xTime,3)
			Set LogicDT=(LogicxDate*24*60*60)+LogicTime
			Set ParamExp=$Replace(ParamExp,"("_xCode_")",LogicDT)
		}
		Set ParamExp=$tr(ParamExp,"[]","()")
		Set exp="set result="_ParamExp
		x exp
		Set logicDate=result\(24*60*60)
		Set logicTime=result#(24*60*60)
		Set Date=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(logicDate)
		Set Time=$zt(logicTime)
		Set DateT=Date_" "_Time
		Set return=DateT
	}elseIf (YNFlg=1){
		//判断是否
		Set xCode=""
		For {
			Set xCode=$o(CodeArr(xCode))
			Quit:xCode=""
			Set xDateTime=$g(CodeArr(xCode))
			Continue:xDateTime=""
			Set xDate=$p(xDateTime," ",1)
			Set xTime=$p(xDateTime," ",2)
			Set LogicxDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(xDate)
			Set LogicTime=$zth(xTime,3)
			Set LogicDT=(LogicxDate*24*60*60)+LogicTime
			Set ParamExp=$Replace(ParamExp,"("_xCode_")",LogicDT)
		}
		Set ParamExp=$tr(ParamExp,"[]","()")
		Set exp="set result="_ParamExp
		x exp
		Set return="n"
		Set:result=1 return="y"
	}
	quit return
}

/// 去除字符串两端字符,默认去掉空格符
/// w ##Class(DHCMA.CPW.SDS.QCExpressSrv).trim("123")
ClassMethod trim(aStr As %String, achar As %String = " ") As %String
{
	new (aStr,achar)
	if ((($e(aStr,1,1)'=achar)||($e(aStr,$l(aStr),$l(aStr))'=achar))) {
		Quit aStr
	}
	DO {
     	Set:$e(aStr,1,1)=achar $e(aStr,1,1)=""
     	Set:$e(aStr,$l(aStr),$l(aStr))=achar $e(aStr,$l(aStr),$l(aStr))=""
   	} WHILE (($e(aStr,1,1)=achar)||($e(aStr,$l(aStr),$l(aStr))=achar))
   	Quit aStr
}

}
