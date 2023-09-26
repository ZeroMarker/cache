Class DHCMA.CPW.SDS.Stat.CommonSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取标准入参
ClassMethod GetStatParams(aStaType As %String, ayear As %String = "", aQuarter As %String = "", aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	new (aStaType,ayear,aQuarter,aDateFrom,aDateTo)
	//aStaType=1 按年季度
	//aStaType=2 按入单日期
	Set DimenMark=""
	//默认按年季度统计
	Set:aStaType="" aStaType=1
	if (aStaType=1) {
		Set CurYear=$p($zd(+$h,3),"-",1)
		if (ayear="") {
			Set DimenMark="Year"
			//默认统计近五年的上报情况，可以考虑使用配置
			Set aStartYear=CurYear-4
			Set aDateFrom=aStartYear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=+$h
		}elseif(aQuarter=""){
			//按季度，统计当前年份所有季度
			Set DimenMark="Quarter"
			Set aDateFrom=ayear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=ayear_"-12-31"
			Set aDateTo=$zdh(aDateTo,3)
		}elseif(aQuarter'=""){
			//按月份，统计当前季度所有月份
			Set DimenMark="Month"
			If (aQuarter=1){
				Set aDateFrom=ayear_"-01-01"
				Set aDateTo=ayear_"-03-31"
			}elseif(aQuarter=2){
				Set aDateFrom=ayear_"-04-01"
				Set aDateTo=ayear_"-06-30"
			}elseif(aQuarter=3){
				Set aDateFrom=ayear_"-07-01"
				Set aDateTo=ayear_"-09-30"
			}elseif(aQuarter=4){
				Set aDateFrom=ayear_"-10-01"
				Set aDateTo=ayear_"-12-31"
			}
		}else{
			Set DimenMark="Year"
			Set aStartYear=CurYear-4
			Set aDateFrom=aStartYear_"-01-01"
			Set aDateFrom=$zdh(aDateFrom,3)
			Set aDateTo=+$h
		}
	}else{
		Set DimenMark="Loc"
	}
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Quit DimenMark_"^"_aDateFrom_"^"_aDateTo
}

/// 获取输出维度
ClassMethod GetArrayStatDimens(aDimenMark As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aDimenMark)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="")||(aDimenMark="") return
	Set Count=0
	if (aDimenMark="Year") {
		Set SYear=$p($zd(aDateFrom,3),"-",1)
		Set EYear=$p($zd(aDateTo,3),"-",1)
		For xYear=SYear:1:EYear {
				Set Count=Count+1
				Set YearStr=xYear_"年"
				Do return.SetAt(YearStr,Count)
			}
	}elseif (aDimenMark="Quarter") {
		Set Year=$p($zd(aDateFrom,3),"-",1)
		For xQuarter=1:1:4 {
				Set Count=Count+1
				Set Quarter		= $Case(xQuarter,1:"一",2:"二",3:"三",4:"四")
				Set QuarterStr	= Year_"年"_Quarter_"季度"
				Do return.SetAt(QuarterStr,Count)
			}
	}elseif (aDimenMark="Month") {
		Set SMonth=+$p($zd(aDateFrom,3),"-",2)
		Set EMonth=+$p($zd(aDateTo,3),"-",2)
		For xMonth=SMonth:1:EMonth {
				Set Count=Count+1
				Set MonthStr=xMonth_"月"
				Do return.SetAt(MonthStr,Count)
			}
	}
	Quit return
}

/// 获取当前统计维护
ClassMethod GetDimenDesc(aDate As %String, aDimenMark As %String) As %String
{
	new (aDate,aDimenMark)
	Quit:(aDate="")||(aDimenMark="") ""
	Set year=$p($zd(aDate,3),"-",1)
 	Set Month=+$p($zd(aDate,3),"-",2)
 	Set Quarter=$Select(Month<4:year_"年一季度",Month<7:year_"年二季度",Month<10:year_"年三季度",1:year_"年四季度")
 	Set DimenDesc=$Case(aDimenMark,"Year":year_"年","Quarter":Quarter,"Month":Month_"月","Loc":"")	
	Quit DimenDesc
}

/// w ##class(DHCMA.CPW.SDS.Stat.StatService).CalcTime("2020-04-21 11:00:00","2020-04-20 10:00:00",24*3600)
ClassMethod CalcTime(thisDT, targetDT, CmpVal As %String = 0) As %String
{
	n (thisDT,targetDT,CmpVal)
	Set return=0
	//将时间入参转换为秒
	Set thisDate=$p(thisDT," ",1)
	Set thisTime=$p(thisDT," ",2)
	Set thisLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(thisDate)
	Set thisLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(thisTime)
	Set thisValue=thisLogicDate*86400+thisLogicTime
	Set targetDate=$p(targetDT," ",1)
	Set targetTime=$p(targetDT," ",2)
	Set targetLogicDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(targetDate)
	Set targetLogicTime=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(targetTime)
	Set targetValue=targetLogicDate*86400+targetLogicTime
	Set Exp="Set return="_thisValue_"-"_targetValue_"<="_CmpVal
	x Exp
	Quit return
}

/// 获取单病种患者表单基本信息,将常用的基本信息单独处理
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).GetBaseInfo(15)
ClassMethod GetBaseInfo(aMrListID) As %Library.List
{
	n (aMrListID)
	Set return=""
	//住院号 姓名 诊断 住院天数
	Set MrlistObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(MrlistObj) return
	Set Abbrev=MrlistObj.QCEntityDr.BTAbbrev
	Set EpisodeID=MrlistObj.QCEpisodeID
	Set QCID=MrlistObj.QCEntityDr.%Id()
	Set VerID=MrlistObj.QCEntityDr.BTVersion.%Id()
	Set:(EpisodeID["!!") EpisodeID=$p(EpisodeID,"!!",1)
	Set objPaadm=##class(DHCMA.Util.EP.Episode).GetObjByOID(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	Set MrNo=objPaadm.PAMrNo
	Set PatName=objPaadm.PAPatName
	Set InHosDays=objPaadm.PAAdmDays
	Set:InHosDays<0 InHosDays=+$h-objPaadm.PAAdmDate
	//单病种表单诊断或手术
	Set ICDItemCode="CM-0-1-3-1"
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,ICDItemCode)
	Set ItemID=ObjEntityItem.%Id()
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,ItemID,""),-1)
	Set ICDDesc=""
	IF (ESubID'="") {
		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_ESubID)
		Set ExecResult=ItemExecObj.ExecResult
 		Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,VerID,ICDItemCode,ExecResult)
		Set:$IsObject(DicItemObj) BTDesc=DicItemObj.BTDesc
		For yInd=1:1:$l(BTDesc) {
				Set xcon=$e(BTDesc,yInd,yInd)
				//分离字母数字，取疾病描述
				Continue:$ASCII(xcon)<127
				Set ICDDesc=ICDDesc_xcon
			}
	}
	//住院费用 西药费 抗菌药物费用 检查及化验费用 耗材费用
	//OC:门诊子分类,	TOC:门诊大类(默认)
	//IC:住院子分类,	TIC:住院大类
	//AC:会计子分类,	TAC:会计大类
	//MC:病案首页子分类,	TMC:病案首页大类 (注意：病案首页分类需根据医院具体情况取)
	//MCNew:新病案首页子分类,	TMCNew:新病案首页大类
	Set CostInfo=##class(DHCCPW.IO.FromFeeSrv).IGetTarItemCate(EpisodeID,"IC")
	Set (HospCost,DrugFee,AntiFee,CheckFee,MaterialFee)=0
	For i=1:1:$l(CostInfo,"!"){
		Set tmpStr=$p(CostInfo,"!",i)
		Continue:tmpStr=""
		Set CostDesc=$p(tmpStr,"^",2)
		Set CostValue=$p(tmpStr,"^",4)
		Set HospCost=HospCost+CostValue
		Set:CostDesc["西药" DrugFee=DrugFee+CostValue
		Set:(CostDesc["抗感染")||(CostDesc["抗菌") AntiFee=AntiFee+CostValue
		Set:CostDesc["检" CheckFee=CheckFee+CostValue
		Set:CostDesc["材料" MaterialFee=MaterialFee+CostValue			
	}
	//治疗效果
	Set MRAdm=$P($g(^PAADM(EpisodeID)),"^",61)
	Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
	Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
	Set:(DischCondDesc["稳定")||(DischCondDesc["恶化") DischCondDesc="未愈"
	Set:DischCondDesc["治愈" DischCondDesc="治愈"
	Set:DischCondDesc["好转" DischCondDesc="好转"
	Set:DischCondDesc["已故" DischCondDesc="死亡"
	Set:DischCondDesc["死亡" DischCondDesc="死亡"
	Set return=$lb(MrNo,PatName,InHosDays,ICDDesc,HospCost,DrugFee,AntiFee,CheckFee,MaterialFee,DischCondDesc)
	Quit return
}

/// 检查当前项目是否为有效表单项目
ClassMethod GetItemShowValue(MrListID As %String, xRowID As %String) As %String
{
	n (MrListID,xRowID)
	Set return=""
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,xRowID,""),-1)
	Set EditPower=1 //默认每个项目可编辑
	Quit:ESubID="" return
	Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_ESubID)
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
	Set QCID=ObjEntityItem.Parref.%Id()
	Set VerID=ObjEntityItem.BTVersion.%Id()
 	Set BTCode = ObjEntityItem.BTCode
	If $IsObject(ItemExecObj){
 		Set ExecResult=ItemExecObj.ExecResult
 		Set ExecResultText=""
 		//如果存的是字典代码  需要转换为描述
 		for ResultInd=1:1:$l(ExecResult,",") {
	 		Set ExecResultSub=$p(ExecResult,",",ResultInd)
 			Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,VerID,BTCode,ExecResultSub)
 			Set:$IsObject(DicItemObj) ExecResultText=ExecResultText_","_DicItemObj.BTDesc
 		}
 		Set:ExecResultText'="" ExecResultText=$e(ExecResultText,2,$l(ExecResultText))
 		Set ExecRowID=MrListID_"||"_ESubID
	}
	Set return=ExecResult
	Set:ExecResultText'="" return=ExecResult_$c(1)_ExecResultText
	if (ObjEntityItem.BTLinkedItem'=""){
		Set PValue=""
		Set PItemDr=ObjEntityItem.BTLinkedItem.%Id()
		Set PESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,PItemDr,""),-1)
 		Set PItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_PESubID)
 		Set:$IsObject(PItemExecObj) PValue=PItemExecObj.ExecResult
 		//判断前提条件是否满足a,b,c
 		Set BTTriggerCondition=","_ObjEntityItem.BTTriggerCondition_","
		Set PValue=","_PValue_","
 		Set:(PValue'[BTTriggerCondition)&&(BTTriggerCondition'[PValue) EditPower=0 //有前置质控项目的，如果不满足前提值，则不可编辑
	}elseif (ObjEntityItem.BTTriggerCondition'=""){
		Set BTLinkedParam=ObjEntityItem.BTTriggerCondition
		Set ExcuteExp=BTLinkedParam
		Set EditPower=0 //默认关联项目不显示，满足条件才显示
		for ParamExpInd=1:1:$l(BTLinkedParam,"}") {
			k CodeArr
			Set ParamExpSub=$p(BTLinkedParam,"}",ParamExpInd)
			continue:ParamExpSub=""
			Set:ParamExpSub["{" ParamExpSub=$p(ParamExpSub,"{",2)
			Set ParamExp=$p(ParamExpSub,":",2)
			Set:ParamExp'[")" ExcuteExp=0 //如果有表达式未正常写入code格式，则退出
			Quit:ExcuteExp=0
			for j=1:1:$l(ParamExpSub,")") {
				Set CodeSub=$p(ParamExpSub,")",j)
				Set Code=$p(CodeSub,"(",2)
				continue:Code=""
				Set ItemDr=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(VerID,QCID,Code)
				if ($IsObject(ItemDr)) {
					Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
					Set xItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_xSubID)
					Set xValue=""
					Set:$IsObject(xItemExecObj) xValue=xItemExecObj.ExecResult
					Set CodeArr(Code)=xValue
				}
			}
			Set CodeTmp=""
			for {
				Set CodeTmp=$o(CodeArr(CodeTmp))
				Quit:CodeTmp=""
				if ($p(ParamExpSub,":",1)="CALC-h") { //计算小时数
				Set tmpHour=0
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
				Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
				//将各个时间参数换算为与固定时间小时差
				Set tmpHour=(tmpDateLogic-60000)*24+(tmpTimeLogic\3600)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpHour)
			}elseif ($p(ParamExpSub,":",1)="CALC-m") { //计算分钟数
				Set tmpMin=0
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
				Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
				//将各个时间参数换算为与固定时间分钟差
				Set tmpMin=(tmpDateLogic-60000)*24*60+(tmpTimeLogic\60)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpMin)
			}elseif ($p(ParamExpSub,":",1)="CALC-month") { //计算月数
				Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
				Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
				if (tmpDateLogic=""){
					Set ExcuteExp=0
					Quit  //如果有时间为空 则不执行表达式
				}
				Set tmpDate=$zd(tmpDateLogic,3)
				Set tmpMon=$p(tmpDate,"-",1)*12+$p(tmpDate,"-",2)+$fn(($p(tmpDate,"-",3)/30),"",2)
				Set ParamExp=$Replace(ParamExp,CodeTmp,tmpMon)
			}else{
				//默认情况下替换Code值，进行运算
				Set CodeValue=""""_$g(CodeArr(CodeTmp))_""""
				Set ParamExp=$Replace(ParamExp,CodeTmp,CodeValue)
			}
		}
		Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,ParamExp)
		}
		//小括号被作为标记项目code符号，所以表达式优先级用[] {}来写
		Set ExcuteExp=$tr($tr(ExcuteExp,"[","("),"]",")")  //[]相当于小括号
		Set ExcuteExp=$tr($tr(ExcuteExp,"{","("),"}",")")
		Set ExcuteExp=$Replace(ExcuteExp,"包含","[")
		Set ExcuteExp=$Replace(ExcuteExp,"不包含","'[")
		Set ExcuteExp=$Replace(ExcuteExp,"!","'")
		Set Exp="Set result="_ExcuteExp
		Set Exp="Set result="_ExcuteExp
		x Exp
		Set:result EditPower=1
	}
	Set:EditPower=0 return=""
	Quit return
}

/// 2020-04-24
/// zhangdc
/// 获取最小日期
/// w ##class(DHCMA.CPW.SDS.Stat.StatService).getMinDateTime($lb("2018-01-01 10:00:11","","2018-05-03 10:00:11"))
ClassMethod getMinDateTime(arr As %ArrayOfDataTypes) As %String
{
	Set len=$LL(arr)
	Set return="",MinDate=""
	for i=1:1:len{
		Set tmpDateTime=$lg(arr,i)
		continue:tmpDateTime=""
		Set date = $p(tmpDateTime," ",1)
		Set time = $p(tmpDateTime," ",2)
		Set date=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(date)
		Set time=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(time)
		Set LogicDT=date*86400+time
		Set:return="" return=LogicDT,MinDate=tmpDateTime
		Set:return>LogicDT return=LogicDT,MinDate=tmpDateTime
	}
	Quit MinDate
}

}
