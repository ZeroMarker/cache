/// 名称: DHCHAI.IRS.VAEFunctionSrv
/// 描述: VAE监测规则函数服务类
/// 编写者: zhoubo
/// 编写日期: 2022-01-20
Class DHCHAI.IRS.VAEFunctionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-03-03
/// Description:  VAE子项--函数--FiO2(吸氧浓度)
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aEpisodeDr
///               aArgDate   : VAE监测日期
///               aBeforeDay : 保持稳定几天
///               aLaterDay  : 连续升高几天
///               aMaxValue  : 较前两天内升高的值
/// Return：      Fio2异常：返回VAE日期，不：返回""
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEFio("689750","66199","2","2","20%")
ClassMethod GetVAEFio(aEpisodeDr As %String, aArgDate As %String, aBeforeDay As %String, aLaterDay As %String, aMaxValue As %String) As %String
{
	New (aEpisodeDr,aArgDate,aBeforeDay,aLaterDay,aMaxValue)
	Set return=""
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	Set aBeforeDay = +aBeforeDay
	Set aLaterDay = +aLaterDay
	Set aMaxValue = +aMaxValue
	// 计算判定周期 默认是四天
	Set SurrDayNum = aBeforeDay+aLaterDay
	Set aSttDate = aArgDate-SurrDayNum+1
	Set aEndDate = aArgDate
	
	Set ArryResult = ##Class(%ArrayOfDataTypes).%New()
	
	Set ResultStr = ..GetVAEDataByCode(aEpisodeDr,aSttDate,aEndDate,"FIO2")
	Set Num=$l(ResultStr,"#")
	Quit:Num<SurrDayNum return  // 某一天没有数据
	Set FirstValue = ..GetVAEDataByDate(aEpisodeDr,aSttDate-1,"FIO2")  // 获取前面一天是否有数据  五天周期
	Set NoFlag=0    // 没保持稳定标志
	For indNum=1:1:Num{
		Set Result=$p(ResultStr,"#",indNum)
		Continue:Result=""
		Set ResultDate  = $p(Result,"^",1)
		Set ResultValue = +$p(Result,"^",2)
		If (indNum=1)&&(FirstValue'=""){
			Set:((+FirstValue)<ResultValue) NoFlag=1  //第二天没有保持稳定
		}
		Do ArryResult.SetAt(ResultValue,indNum)
	}
	Quit:NoFlag=1 return
	//1，首先判断是否保持稳定
	//每日最低FIO2保持稳定或降低大于aBeforeDay
	Set Flag=0,tmpRstValue=0
	Set MaxValue=0  //前两天最大Fio2值
	For indArr=1:1:aBeforeDay{
		Quit:Flag=1
		Set RstValue=ArryResult.GetAt(indArr)
		Continue:RstValue=""
		If (tmpRstValue'=0)&&(RstValue>tmpRstValue){
			Set Flag=1
		}
		Set:(MaxValue=0) MaxValue = RstValue
		If (RstValue>MaxValue){
			Set MaxValue = RstValue
		}
		Set tmpRstValue=RstValue
	}
	Quit:Flag=1 return
	//1，在判断较前两天最大值是否连续2天升高20%
	Set MaxValue=MaxValue+(MaxValue*((+aMaxValue)/100))
	Set Flag=1,tmpRstValue=0
	For indArr=(aBeforeDay+1):1:Num{
		Quit:Flag=0
		Set RstValue=ArryResult.GetAt(indArr)
		Continue:RstValue=""
		
		If ((RstValue-MaxValue)<0){  //未连续升高20%
			Set Flag=0	
		}
	}
	Quit:Flag=0 return
	
	Set VAEDate=aSttDate+aBeforeDay 
	
	Set VAEDate=$zd(VAEDate,3)
	
	Quit VAEDate
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-03
/// Description:  VAE子项--函数--PEEP(呼吸末正压)
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aEpisodeDr
///               aArgDate   : VAE监测日期
///               aBeforeDay : 保持稳定几天
///               aLaterDay  : 连续升高几天
///               aMaxValue  : 较前两天内升高的值
/// Return：      Peep异常：返回VAE日期，不：返回""
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEPeep("17","2022-01-04","2","2","3")
ClassMethod GetVAEPeep(aEpisodeDr As %String, aArgDate As %String, aBeforeDay As %String, aLaterDay As %String, aMaxValue As %String) As %String
{
	New (aEpisodeDr,aArgDate,aBeforeDay,aLaterDay,aMaxValue)
	Set return=""
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	Set aBeforeDay = +aBeforeDay
	Set aLaterDay = +aLaterDay
	Set aMaxValue = +aMaxValue
	// 计算判定周期 默认是四天
	Set SurrDayNum = aBeforeDay+aLaterDay
	Set aSttDate = aArgDate-SurrDayNum+1
	Set aEndDate = aArgDate
	
	Set ArryResult = ##Class(%ArrayOfDataTypes).%New()
	
	Set ResultStr = ..GetVAEDataByCode(aEpisodeDr,aSttDate,aEndDate,"PEEP")
	Set Num=$l(ResultStr,"#")
	Quit:Num<SurrDayNum return  // 某一天没有数据
	Set FirstValue = ..GetVAEDataByDate(aEpisodeDr,aSttDate-1,"PEEP")  // 获取前面一天是否有数据  五天周期
	Set NoFlag=0    // 没保持稳定标志
	For indNum=1:1:Num{
		Set Result=$p(ResultStr,"#",indNum)
		Continue:Result=""
		Set ResultDate  = $p(Result,"^",1)
		Set ResultValue = +$p(Result,"^",2)
		If (indNum=1)&&(FirstValue'=""){
			Set:((+FirstValue)<ResultValue) NoFlag=1  //第二天没有保持稳定
		}
		Do ArryResult.SetAt(ResultValue,indNum)
	}
	Quit:NoFlag=1 return
	//1，首先判断是否保持稳定
	//每日最低PEEP保持稳定或降低大于aBeforeDay
	Set Flag=0,tmpRstValue=0
	Set MaxValue=0  //前两天最大PEEP值
	For indArr=1:1:aBeforeDay{
		Quit:Flag=1
		Set RstValue=ArryResult.GetAt(indArr)
		Continue:RstValue=""
		If (tmpRstValue'=0)&&(RstValue>tmpRstValue){
			Set Flag=1
		}
		Set:(MaxValue=0) MaxValue = RstValue
		If (RstValue>MaxValue){
			Set MaxValue = RstValue
		}
		Set tmpRstValue=RstValue
	}
	Quit:Flag=1 return
	//1，在判断较前两天最大值是否连续2天升高3
	Set Flag=1,tmpRstValue=0
	For indArr=(aBeforeDay+1):1:Num{
		Quit:Flag=0
		Set RstValue=ArryResult.GetAt(indArr)
		Continue:RstValue=""
		
		If ((RstValue-MaxValue)<aMaxValue){  //未连续升高3
			Set Flag=0	
		}
	}
	Quit:Flag=0 return
	
	Set VAEDate=aSttDate+aBeforeDay 
	
	Set VAEDate=$zd(VAEDate,3)
	
	Quit VAEDate
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-03
/// Description:  获取患者一段期间每天PEEP最低值
/// Table：       DHCHAI.DP.VAEICUPeep
/// Input：       aEpisodeDr
///               aDateFrom  : 开始日期
///               aDateTo    : 结束日期
///               aVAEType   : 类型PEEP或FiO2
/// Return：      VAE数值
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEDataByCode("17","66172","66172","PEEP")
ClassMethod GetVAEDataByCode(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, aVAEType As %String) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,aVAEType)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="")||(aVAEType="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aVAEType = $zcvt(aVAEType,"U")
	
	For xDate=aDateFrom:1:aDateTo {
		//获取当天最小值
		Set MinPeepValue=0
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisTypeDate",aEpisodeDr,aVAEType,xDate,xID))
			
			Quit:(xID="")
			Set VaeData=$g(^DHCHAI.DP.VAEICUPeepD(xID))
			Continue:VaeData=""
			Set Result=+$li(VaeData,5)
			
			Continue:Result<=0
			Set:(MinPeepValue=0) MinPeepValue = Result
			If (Result<MinPeepValue){
				Set MinPeepValue = Result
			}
		}
		Continue:MinPeepValue=0 // 不可能为0
		Set return = return_"#"_xDate_"^"_MinPeepValue
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-03
/// Description:  获取患者某一天PEEP最低值
/// Table：       DHCHAI.DP.VAEICUPeep
/// Input：       aEpisodeDr
///               aDateFrom  : 开始日期
///               aVAEType   : 类型PEEP或FiO2
/// Return：      VAE数值
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetVAEDataByDate("1","2022-01-01","FIO2")
ClassMethod GetVAEDataByDate(aEpisodeDr As %String, aDateFrom As %String, aVAEType As %String) As %String
{
	New (aEpisodeDr,aDateFrom,aVAEType)
	Set return=""
	Quit:(aDateFrom="")||(aVAEType="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set aDateTo = aDateFrom
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aVAEType = $zcvt(aVAEType,"U")
	
	For xDate=aDateFrom:1:aDateTo {
		//获取当天最小值
		Set MinPeepValue=0
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisTypeDate",aEpisodeDr,aVAEType,xDate,xID))
			Quit:(xID="")
			Set VaeData=$g(^DHCHAI.DP.VAEICUPeepD(xID))
			Continue:VaeData=""
			Set Result=+$li(VaeData,5)
			Continue:Result<=0
			Set:(MinPeepValue=0) MinPeepValue = Result
			If (Result<MinPeepValue){
				Set MinPeepValue = Result
			}
		}
		Continue:MinPeepValue=0 // 不可能为0
		Set return = MinPeepValue
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-02-18
/// Description:  VAE子项--函数--检出菌-在 VAC 出现前后 2 天内
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       aEpisodeDr
///               aArgDate    : VAE日期
///               aBeforeDay  : VAE日期前几天
///               aLaterDay   : VAE日期后几天
///               aTestSetArg : 检验医嘱IDs -- DHCHAI.DP.LabTestSetMap
///               aSpecArg    : 送检标本IDs -- DHCHAI.DP.LabSpecimen
///               aBactArg    : 病原体IDs   -- DHCHAI.DP.LabBacteria
/// Return：      满足条件：返回1，不满足：返回0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetBactDate("44","2020-04-15","2","2","","","##278,1721")
ClassMethod GetBactDate(aEpisodeDr As %String, aArgDate As %String, aBeforeDay As %String, aLaterDay As %String, aTestSetArg As %String, aSpecArg As %String, aBactArg As %String) As %String
{
	New (aEpisodeDr,aArgDate,aBeforeDay,aLaterDay,aTestSetArg,aSpecArg,aBactArg)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	
	Set aSttDate = aArgDate-aBeforeDay
	Set aEndDate = aArgDate+aBeforeDay
	
	//如果设置了检验医嘱包含，那必须是包含里面的检验医嘱才算。否则只设置排除
	Set ContOELabList=""
	Set ExclOELabList=""
	For i=1:1:$l(aTestSetArg,"#") {
		Set Arg=$p(aTestSetArg,"#",i)
		Continue:Arg=""
		
		Set LabID=$p(Arg,",",1)
		Set objLab=##class(DHCHAI.DP.LabTestSetMap).GetObjById(LabID)
		Continue:('$IsObject(objLab))
		Set TestSetDesc=objLab.BTTestSet
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContOELabList=ContOELabList_$lb(TestSetDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclOELabList=ExclOELabList_$lb(TestSetDesc)
		}
	}
	
	// 标本
	Set ContSpecList=""
	Set ExclSpecList=""
	For i=1:1:$l(aSpecArg,"#") {
		Set Arg=$p(aSpecArg,"#",i)
		Continue:Arg=""
		
		Set SpecID=$p(Arg,",",1)
		Set objSpec=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecID)
		Continue:('$IsObject(objSpec))
		Set BTSpecDesc=objSpec.BTSpecDesc
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContSpecList=ContSpecList_$lb(BTSpecDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclSpecList=ExclSpecList_$lb(BTSpecDesc)
		}
	}
	// 检出菌
	Set ContBactList=""
	Set ExclBactList=""
	For i=1:1:$l(aBactArg,"#") {
		Set Arg=$p(aBactArg,"#",i)
		Continue:Arg=""
		
		Set BactID=$p(Arg,",",1)
		Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BactID)
		Continue:('$IsObject(objBact))
		Set BactDesc=objBact.BTBacDesc
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContBactList=ContBactList_$lb(BactDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclBactList=ExclBactList_$lb(BactDesc)
		}
	}
	
	Set RetFlag=0   // 满足条件Flag
	//循环标本表
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeDr,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		Quit:(RetFlag=1)
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		//过滤日期	
		Continue:(aSttDate'="")&(CollDate<aSttDate)
		Continue:(aEndDate'="")&(CollDate>aEndDate)
		
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode		//LIS01
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo	//检验号|标本号
		//标本过滤
		Set Specimen 	= objVisitNumber.LabSpecimen	//标本名称[血.....]
		If (ContSpecList'=""){
			Continue:($lf(ContSpecList,Specimen)<1)
		}
		If (ExclSpecList'=""){
			Continue:($lf(ExclSpecList,Specimen)>0)
		}
		//送检科室
		Set LocDesc = ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocDesc=objVisitNumber.LabLocDr.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
		}
		// 循环检验医嘱表[检查送检记录是否是(检出菌、常规检验、PCT（降钙素原）、CRP（C反应蛋白）、G试验、M试验)]
		Set OrdListDesc=""	//检验医嘱名称
		Set xTestSetDesc="",checkFlg=0,IsCom=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
			Quit:(RetFlag=1)
			Set xID =""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc,xID))
				Quit:xID=""
				Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
				Continue:LabVisitTestData=""
				Set ComSetCode =$lg(LabVisitTestData,7)		
				Set:ComSetCode'="" IsCom=1			//合管检验医嘱代码
			}
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
			//对照后检验医嘱
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:(objTestSetMap.BTIsActive'=1)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
			Set CatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
			Continue:(CatDesc'="微生物送检")
			//检验医嘱过滤
			Set BTTestSet = objTestSetMap.BTTestSet
			If (ContOELabList'=""){
				Continue:($lf(ContOELabList,BTTestSet)<1)
			}
			If (ExclOELabList'=""){
				Continue:($lf(ExclOELabList,BTTestSet)>0)
			}
			Set TSMapItemDr=objTestSetMap.BTMapItemDr.%Id()
			Set checkFlg =1			
		}
		Continue:checkFlg'=1
		//循环检验报告表
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			Quit:(RetFlag=1)
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				Quit:(RetFlag=1)
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
				
				Set xResultID=""
				For {
					Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					
					Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
					Continue:'$isobject(objResult)
					
					Set TestDesc = objResult.LabTestDesc
					Set Bacteria = objResult.LabResult
					Continue:Bacteria=""
					Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria("LIS01",Bacteria)
					Continue:'$IsObject(objBactMap)
					Set objBTMapItemDr = objBactMap.BTMapItemDr
					Continue:'$IsObject(objBTMapItemDr)
					//细菌过滤
					Set BTBacDesc = objBTMapItemDr.BTBacDesc
					If (ContBactList'=""){
						Continue:($lf(ContBactList,BTBacDesc)<1)
					}
					If (ExclBactList'=""){
						Continue:($lf(ExclBactList,BTBacDesc)>0)
					}
					Set RetFlag=1
					Quit:(RetFlag=1)
				}
			}
		}
	}
	Set return=RetFlag
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-02-18
/// Description:  VAE子项--函数--白细胞计数≥1200  在 VAC 出现前后 2 天内
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       aEpisodeDr
///               aArgDate    : VAE日期
///               aBeforeDay  : VAE日期前几天
///               aLaterDay   : VAE日期后几天
///               aTestSetArg : 检验医嘱IDs
///               aSpecArg    : 送检标本IDs
///               aWbcCntArg  : 白细胞数
/// Return：      满足条件：返回1，不满足：返回0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetWBCDate("12","2020-04-20","2","2","##11,1720","","12000")
ClassMethod GetWBCDate(aEpisodeDr As %String, aArgDate As %String, aBeforeDay As %String, aLaterDay As %String, aTestSetArg As %String, aSpecArg As %String, aWbcCntArg As %String) As %String
{
	New (aEpisodeDr,aArgDate,aBeforeDay,aLaterDay,aTestSetArg,aSpecArg,aWbcCntArg)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	
	Set aSttDate = aArgDate-aBeforeDay
	Set aEndDate = aArgDate+aBeforeDay
	Quit:+aWbcCntArg=0 return
	Set aWbcCntArg=aWbcCntArg/1000 //单位转换下，检验那边一般是L 
	//如果设置了检验医嘱包含，那必须是包含里面的检验医嘱才算。否则只设置排除
	Set ContOELabList=""
	Set ExclOELabList=""
	For i=1:1:$l(aTestSetArg,"#") {
		Set Arg=$p(aTestSetArg,"#",i)
		Continue:Arg=""
		
		Set LabID=$p(Arg,",",1)
		Set objLab=##class(DHCHAI.DP.LabTestSetMap).GetObjById(LabID)
		Continue:('$IsObject(objLab))
		Set TestSetDesc=objLab.BTTestSet
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContOELabList=ContOELabList_$lb(TestSetDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclOELabList=ExclOELabList_$lb(TestSetDesc)
		}
	}
	
	// 标本
	Set ContSpecList=""
	Set ExclSpecList=""
	For i=1:1:$l(aSpecArg,"#") {
		Set Arg=$p(aSpecArg,"#",i)
		Continue:Arg=""
		
		Set SpecID=$p(Arg,",",1)
		Set objSpec=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecID)
		Continue:('$IsObject(objSpec))
		Set BTSpecDesc=objSpec.BTSpecDesc
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContSpecList=ContSpecList_$lb(BTSpecDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclSpecList=ExclSpecList_$lb(BTSpecDesc)
		}
	}
	Set RetFlag=0   // 满足条件Flag
	//循环标本表
	Set xVisitNumberDr=""
	For {
		Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeDr,xVisitNumberDr))
		Quit:xVisitNumberDr=""
		
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xVisitNumberDr)
		Continue:'$isobject(objVisitNumber)
		Continue:objVisitNumber.LabIsActive'=1
		
		Set CollDate=objVisitNumber.LabCollDate		//采集日期
		Set CollTime=objVisitNumber.LabCollTime
		
		Set RecDate=objVisitNumber.LabRecDate		//接收日期
		Set RecTime=objVisitNumber.LabRecTime
		
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
		//过滤日期	
		Continue:(aSttDate'="")&(CollDate<aSttDate)
		Continue:(aEndDate'="")&(CollDate>aEndDate)
		
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set:CollTime'="" CollTime=$zt(CollTime,1)
		
		Set SCode	 	= objVisitNumber.LabSCode		//LIS01
		Set EpisodeNo 	= objVisitNumber.LabEpisodeNo	//检验号|标本号
		//标本过滤
		Set Specimen 	= objVisitNumber.LabSpecimen	//标本名称[血.....]
		If (ContSpecList'=""){
			Continue:($lf(ContSpecList,Specimen)<1)
		}
		If (ExclSpecList'=""){
			Continue:($lf(ExclSpecList,Specimen)>0)
		}
		//送检科室
		Set LocDesc = ""
		If $isobject(objVisitNumber.LabLocDr){
			Set LocDesc=objVisitNumber.LabLocDr.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set LocDesc2=objVisitNumber.LabLocDr.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
		}
		
		// 循环检验医嘱表[检查送检记录是否是(检出菌、常规检验、PCT（降钙素原）、CRP（C反应蛋白）、G试验、M试验)]
		Set OrdListDesc=""	//检验医嘱名称
		Set xTestSetDesc="",checkFlg=0,IsCom=0
		For {
			Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
			Quit:xTestSetDesc=""
			Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
			
			Set xID =""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc,xID))
				Quit:xID=""
				Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
				Continue:LabVisitTestData=""
				Set ComSetCode =$lg(LabVisitTestData,7)		
				Set:ComSetCode'="" IsCom=1			//合管检验医嘱代码
			}
			Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
			//对照后检验医嘱
			Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
			Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
			Continue:'$isobject(objTestSetMap)
			Continue:'$isobject(objTestSetMap.BTMapItemDr)
			Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
			Set CatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
			Continue:(CatDesc'="常规检验")
			//检验医嘱过滤
			Set BTTestSet = objTestSetMap.BTTestSet
			If (ContOELabList'=""){
				Continue:($lf(ContOELabList,BTTestSet)<1)
			}
			If (ExclOELabList'=""){
				Continue:($lf(ExclOELabList,BTTestSet)>0)
			}
			Set TSMapItemDr=objTestSetMap.BTMapItemDr.%Id()
			Set checkFlg =1			
		}
		Continue:checkFlg'=1
		//循环检验报告表
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				
				Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
				Continue:'$IsObject(objVisitReport)
				
				Set Status = objVisitReport.LabStatus
				Set IsActive = objVisitReport.LabIsActive
				Continue:IsActive=0
				
				Set xResultID=""
				For {
					Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					
					Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
					Continue:'$isobject(objResult)
					
					Set TestDesc = objResult.LabTestDesc
					Continue:(TestDesc'["白细胞")
					Set Result =+objResult.LabResult
					
					If (Result>aWbcCntArg){
						Set RetFlag=1
					}
				}
			}
		}
	}
	Set return=RetFlag
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-21
/// Description:  VAE子项--函数--持续使用抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aEpisodeDr
///               aArgDate : VAE日期
///               aNewAntiFlag : 使用新的抗生素
///               aAntiDay : 持续天数
/// Return：      使用抗生素：返回1，未使用：0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetContAntiByDate("162","2019-02-23","1","2")
ClassMethod GetContAntiByDate(aEpisodeDr As %String, aArgDate As %String, aNewAntiFlag As %String, aAntiDay As %String) As %String
{
	New (aEpisodeDr,aArgDate,aNewAntiFlag,aAntiDay)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	// 新的抗菌药物的定义：在VAC本次使用之前的 2 天内没有使用过的抗菌药物。
	Set aSttDate = aArgDate-2
	Set aEndDate = aArgDate+aAntiDay-1
	Quit:(aSttDate>aEndDate) return
	Set UseConAntiFlag=1,IsAntiUse=0  // 持续使用抗生素标志
	Set AntiUseDateList=$lb("")
	Set AntiBeforeList=$lb("") // 前两天使用的抗生素
	Set AntiArryResult = ##Class(%ArrayOfDataTypes).%New()  // 后面持续使用的抗生素
	For xDate=aSttDate:1:aEndDate {
		Set AntiLaterList=$lb("")
		Set xScode = ""
		For {
			Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode))
			Quit:xScode=""
			
			Set xSttDate = ""
			For {
				Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode,1,xSttDate))
				Quit:xSttDate=""
				Continue:(xSttDate>xDate)
				
				Set xOrdItemID =""
				For {
					Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode,1,xSttDate,xOrdItemID))
					Quit:xOrdItemID=""
					
					Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0	// 无效医嘱
					Set SCode   = objOrdItem.OESCode
					Set OrdType = objOrdItem.OEOrdType
					Continue:OrdType'="R" //过滤掉非药品医嘱
					//抗菌用药标志 
					Continue:objOrdItem.OEAntUseFlag'=1 
					Set SttDate = objOrdItem.OESttDate
		            Set SttTime = objOrdItem.OESttTime
					Set EndDate = objOrdItem.OEXDate
					Set EndTime	= objOrdItem.OEXTime
					
		            Set Priority = objOrdItem.OEPriority //医嘱类型		
					Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
					Continue:PriorityMap=""
					Continue:PriorityMap="OUT"
		            If PriorityMap="N"{
						Set EndDate = SttDate
						Set EndTime	= SttTime
					}
					Continue:(EndDate<xDate)&&(EndDate'="")  // 停药日期在转入日期前
					
					
					Set OEGeneric = objOrdItem.OEGeneric
					Set OrdDesc   = objOrdItem.OEOrdDesc
					Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OEGeneric) 
					 If (ObjAntiMap=""){
						Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OrdDesc) 
					}
					Continue:'$IsObject(ObjAntiMap) // 未对照的过滤
					Continue:'$IsObject(ObjAntiMap.BTMapItemDr)
					
					Set AntMapDesc = ObjAntiMap.BTMapItemDr.BTName
					If (xDate<(aSttDate+2)){
						Set AntiBeforeList=AntiBeforeList_$lb(AntMapDesc)
					}Else{
						Set AntiLaterList=AntiLaterList_$lb(AntMapDesc)
					}
					Set AntiUseDateList=AntiUseDateList_$lb(xDate)
					Set IsAntiUse=1
				}
			}
		}
		Do AntiArryResult.SetAt(AntiLaterList,xDate)
	}
	// 连续使用的定义：使用间断不超过一天也算做连续使用。
	Set tmpDate=aSttDate
	For xDate=aSttDate:1:aEndDate {
		If ($lf(AntiUseDateList,xDate)>0){
			If (xDate-tmpDate)>2{
				Set UseConAntiFlag=0  // 没有持续性
			}
			Set tmpDate=xDate
		}
	}
	Set:IsAntiUse=0 UseConAntiFlag=0  // 没有使用抗菌药物
	Quit:UseConAntiFlag=0 UseConAntiFlag
	// 新的抗菌药物的定义：在VAC本次使用之前的 2 天内没有使用过的抗菌药物。
	// 关于联合使用抗菌药物，只要其中一种抗菌药物为新的抗菌药物就算当天使用了新的抗菌药物。
	
	Set Flag=""
	For xDate=aArgDate:1:aEndDate{
		Set AntiList=AntiArryResult.GetAt(xDate)
		Continue:$ll(AntiList)="1"
		Set Flag=2    // 表示VAE日期后有使用抗菌药物
		Set NewAntiFlag=0
		For xindx=1:1:$ll(AntiList){
			Set xAntiDesc=$lg(AntiList,xindx)
			Continue:xAntiDesc=""
			If ($lf(AntiBeforeList,xAntiDesc)<1){  // 判断前两天有没有使用
				Set NewAntiFlag=1
			}
		}
		If (NewAntiFlag'=1){  // 当天未使用新的抗生素
			Set Flag=1
			Quit
		}	
	}
	If (aNewAntiFlag=1){
		Set:((Flag=1)||(Flag="")) UseConAntiFlag=0
	}
	Set return = UseConAntiFlag
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-21
/// Description:  VAE子项--函数--抗生素     ------暂时不用用不到
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aEpisodeDr
///               aVAEArg   : 抗生素设置
/// Return：      使用抗生素：返回1，未使用：0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetAntiByDate("162","##196,883","2019-02-21","2019-02-27")
ClassMethod GetAntiByDate(aEpisodeDr As %String, aVAEArg As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeDr,aVAEArg,aDateFrom,aDateTo)
	Set return=0
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") return
 	
	//如果设置了抗生素包含，那必须是包含里面的抗生素才算。否则只设置排除
	Set ContAntiList=""
	Set ExclAntiList=""
	For i=1:1:$l(aVAEArg,"#") {
		Set Arg=$p(aVAEArg,"#",i)
		Continue:Arg=""
		
		Set AntiID=$p(Arg,",",1)
		Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntiID)
		Continue:('$IsObject(objAnti))
		Set AntDesc=objAnti.BTAntDesc
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContAntiList=ContAntiList_$lb(AntDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclAntiList=ExclAntiList_$lb(AntDesc)
		}
	}
	Set UseAntiFlag=0  // 使用抗生素标志
	For xDate=aDateFrom:1:aDateTo {
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,"HIS01","1",xDate,xID))
			Quit:xID=""
		
			Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
			Continue:'$IsObject(objOrdItem)
			Continue:objOrdItem.OEIsActive=0	// 无效医嘱
			Set SCode   = objOrdItem.OESCode
			Set OrdType = objOrdItem.OEOrdType
			Continue:OrdType'="R" //过滤掉非药品医嘱
			//抗菌用药标志 
			Continue:objOrdItem.OEAntUseFlag'=1 
			Set OEGeneric = objOrdItem.OEGeneric
			Set OrdDesc   = objOrdItem.OEOrdDesc
			Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OEGeneric) 
			 If (ObjAntiMap=""){
				Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OrdDesc) 
			}
			Continue:'$IsObject(ObjAntiMap) // 未对照的过滤
			Continue:'$IsObject(ObjAntiMap.BTMapItemDr)
			
			Set AntMapDesc = ObjAntiMap.BTMapItemDr.BTName
			
			If (ContAntiList'=""){
				Continue:($lf(ContAntiList,AntMapDesc)<1)
			}
			If (ExclAntiList'=""){
				Continue:($lf(ExclAntiList,AntMapDesc)>0)
			}
			Set UseAntiFlag=1  // 使用抗生素标志
		}
	}
	Set return = UseAntiFlag
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-20
/// Description:  VAE子项--函数--持续发热38度  --暂时用不到该函数
/// Table：       DHCHAI.DP.MRObservations
/// Input：       aEpisodeDr
///               aArgDate   : 监测日期
///               aContDay   : 持续发热天数
/// Return：      持续发热：返回1，没持续：0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetContByDate("22","2020-04-14","3")
ClassMethod GetContByDate(aEpisodeDr As %String, aArgDate As %String, aContDay As %String) As %String
{
	New (aEpisodeDr,aArgDate,aContDay)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	
	Set aSttDate = aArgDate-aContDay+1
	Set aEndDate = aArgDate
	Set ContFlag=1,IsFeverFlag=0 // 持续标志,是否发热，有发热才去判断是否持续发热
	Set DateList=$lb("")
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode))
		Quit:((xSCode="")||(ContFlag=0))
		
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc))
			Quit:((xItemDesc="")||(ContFlag=0))
			
			//根据体温筛查“发热”项目
			Set objOBSIM=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(xSCode,xItemDesc)
			Continue:'$IsObject(objOBSIM)
			Continue:'$IsObject(objOBSIM.BTMapItemDr)
			Set OBSItemCat=objOBSIM.BTMapItemDr.BTCatDr
			Continue:'$IsObject(OBSItemCat)	
			Set LabType=OBSItemCat.BTDesc
			Continue:(LabType'="体温")
			Set xDate=aSttDate-1
			For {
				Set xDate=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate))
				Quit:((xDate="")||(ContFlag=0))
				Quit:xDate>aEndDate
				
				Set FeverFlag=0
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate,xID))
					Quit:(xID="")
					
					Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(xID)
					Continue:'$IsObject(objMRObs)
					Continue:'$IsObject(objMRObs.OBEpisodeDr)
					Set IsActive=objMRObs.OBIsActive
					Continue:IsActive'=1
					
					Set ItemDesc=objMRObs.OBItemDesc      //护理项目
					Set ItemCode=objMRObs.OBItemCode      //护理项目代码
					
					Set ItemValue=objMRObs.OBItemValue    //结果
					Continue:ItemValue=""                 //发热标准
					If (+ItemValue>38){
						Set FeverFlag=1	
						Set IsFeverFlag=1
					}
				}
				If (FeverFlag=1){
					Set DateList=DateList_$lb(xDate)
				}
			}
		}
	}
	For xDate=aSttDate:1:aEndDate {
		If ($lf(DateList,xDate)<1){
			Set ContFlag=0  // 没有持续性
		}
	}
	Set:IsFeverFlag=0 ContFlag=0
	Set return = ContFlag
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-20
/// Description:  VAE子项--函数--发热
/// Table：       DHCHAI.DP.MRObservations
/// Input：       aEpisodeDr
///               aArgDate   : VAE监测日期
///               aBeforeDay : 监测日期前几天
///               aLaterDay  : 监测日期后几天
///               aTempMax   : 体温异常范围高
///               aTempMin   : 体温异常范围低
/// Return：      发热：返回1，不发热：返回0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetFerverByDate("98","65485","3","3","38","36")
ClassMethod GetFerverByDate(aEpisodeDr As %String, aArgDate As %String, aBeforeDay As %String, aLaterDay As %String, aTempMax As %String, aTempMin As %String) As %String
{
	New (aEpisodeDr,aArgDate,aBeforeDay,aLaterDay,aTempMax,aTempMin)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	
	Set aSttDate = aArgDate-aBeforeDay
	Set aEndDate = aArgDate+aBeforeDay
	
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode))
		Quit:((xSCode="")||(return=1))
		
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc))
			Quit:((xItemDesc="")||(return=1))
			
			//根据体温筛查“发热”项目
			Set objOBSIM=##class(DHCHAI.DP.MROBSItemMap).GetObjByItemDesc(xSCode,xItemDesc)
			Continue:'$IsObject(objOBSIM)
			Continue:'$IsObject(objOBSIM.BTMapItemDr)
			Set OBSItemCat=objOBSIM.BTMapItemDr.BTCatDr
			Continue:'$IsObject(OBSItemCat)	
			Set LabType=OBSItemCat.BTDesc
			Continue:(LabType'="体温")
			Set xDate=aSttDate-1
			For {
				Set xDate=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate))
				Quit:((xDate="")||(return=1))
				Quit:xDate>aEndDate
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeDr,xSCode,xItemDesc,xDate,xID))
					Quit:((xID="")||(return=1))
					
					Set objMRObs=##class(DHCHAI.DP.MRObservations).GetObjById(xID)
					Continue:'$IsObject(objMRObs)
					Continue:'$IsObject(objMRObs.OBEpisodeDr)
					Set IsActive=objMRObs.OBIsActive
					Continue:IsActive'=1
					
					Set ItemDesc=objMRObs.OBItemDesc      //护理项目
					Set ItemCode=objMRObs.OBItemCode      //护理项目代码
					
					Set ItemValue=objMRObs.OBItemValue    //结果
					Continue:ItemValue=""                 //发热标准
					If ((+ItemValue>aTempMax)||(+ItemValue<aTempMin)){
						Set return=1	
					}
				}
			}
		}
	}
	Quit return
}

/// Creator：     liutao
/// CreatDate：   2022-08-31
/// Description:  VAE子项--函数--新的抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       aEpisodeDr
///               aArgDate : VAE日期
///               aNewAntiFlag : 使用新的抗生素
///               aAntiDay : 持续天数
/// Return：      使用新的抗生素：返回1，未使用：0
/// w ##class(DHCHAI.IRS.VAEFunctionSrv).GetNewAntiByDate("112","2022-02-23","1","4")
ClassMethod GetNewAntiByDate(aEpisodeDr As %String, aArgDate As %String, aNewAntiFlag As %String, aAntiDay As %String) As %String
{
	New (aEpisodeDr,aArgDate,aNewAntiFlag,aAntiDay)
	Set return=0
	Set:aArgDate["-" aArgDate=$zdh(aArgDate,3)
	Set:aArgDate="" aArgDate=+$h
	// 新的抗菌药物的定义：在VAC本次使用之前的 2 天内没有使用过的抗菌药物。
	Set aSttDate = aArgDate-2
	Set aEndDate = aArgDate+aAntiDay-1
	Quit:(aSttDate>aEndDate) return
	Set UseConAntiFlag=1,IsAntiUse=0  // 持续使用抗生素标志
	Set AntiUseDateList=$lb("")
	Set AntiBeforeList=$lb("") // 前两天使用的抗生素
	Set AntiArryResult = ##Class(%ArrayOfDataTypes).%New()  // 后面持续使用的抗生素
	Set StartDate=""
	For xDate=aSttDate:1:aEndDate {
		Set AntiLaterList=$lb("")
		Set xScode = ""
		For {
			Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode))
			Quit:xScode=""
			
			Set xSttDate = ""
			For {
				Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode,1,xSttDate))
				Quit:xSttDate=""
				Continue:(xSttDate>xDate)
				
				Set xOrdItemID =""
				For {
					Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xScode,1,xSttDate,xOrdItemID))
					Quit:xOrdItemID=""
					
					Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdItemID)
					Continue:'$IsObject(objOrdItem)
					Continue:objOrdItem.OEIsActive=0	// 无效医嘱
					Set SCode   = objOrdItem.OESCode
					Set OrdType = objOrdItem.OEOrdType
					Continue:OrdType'="R" //过滤掉非药品医嘱
					//抗菌用药标志 
					Continue:objOrdItem.OEAntUseFlag'=1 
					Set SttDate = objOrdItem.OESttDate
		            Set SttTime = objOrdItem.OESttTime
					Set EndDate = objOrdItem.OEXDate
					Set EndTime	= objOrdItem.OEXTime
		            Set Priority = objOrdItem.OEPriority //医嘱类型		
					Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
					
					Continue:PriorityMap=""
					Continue:PriorityMap="OUT"
		            If PriorityMap="N"{
						Set EndDate = SttDate
						Set EndTime	= SttTime
					}
					Continue:(EndDate<xDate)&&(EndDate'="")  // 停药日期在转入日期前
					
					Set OEGeneric = objOrdItem.OEGeneric
					Set OrdDesc   = objOrdItem.OEOrdDesc
					Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OEGeneric) 
					If (ObjAntiMap=""){
						Set ObjAntiMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc("HIS01",OrdDesc) 
					}
					Continue:'$IsObject(ObjAntiMap) // 未对照的过滤
					Continue:'$IsObject(ObjAntiMap.BTMapItemDr)
					
					Set AntMapDesc = ObjAntiMap.BTMapItemDr.BTName
					If (xDate<(aSttDate+2)){
						Set AntiBeforeList=AntiBeforeList_$lb(AntMapDesc)
					}Else{

						Set:((StartDate="")&&(xSttDate>=aArgDate)) StartDate=xSttDate
						Set AntiLaterList=AntiLaterList_$lb(AntMapDesc)
					}
					Set AntiUseDateList=AntiUseDateList_$lb(xDate)
					Set IsAntiUse=1
				}
			}
		}
		Do AntiArryResult.SetAt(AntiLaterList,xDate)
	}
	
	// 新的抗菌药物的定义：在VAC本次使用之前的 2 天内没有使用过的抗菌药物。
	// 关于联合使用抗菌药物，只要其中一种抗菌药物为新的抗菌药物就算当天使用了新的抗菌药物。
	Set NewAntiFlag=""
	Set Flag=""
	For xDate=aArgDate:1:aEndDate{
		Set AntiList=AntiArryResult.GetAt(xDate)
		Continue:$ll(AntiList)="1"
		Set Flag=2    // 表示VAE日期后有使用抗菌药物
		Set NewAntiFlag=0
		For xindx=1:1:$ll(AntiList){
			Set xAntiDesc=$lg(AntiList,xindx)
			Continue:xAntiDesc=""
			If ($lf(AntiBeforeList,xAntiDesc)<1){  // 判断前两天有没有使用
				Set NewAntiFlag=1
			}
		}
	}
	Set return = NewAntiFlag_"^"_StartDate
	Quit return
}

}
