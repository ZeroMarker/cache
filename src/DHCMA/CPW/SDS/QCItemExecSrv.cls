Class DHCMA.CPW.SDS.QCItemExecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zgz  2018-11-21
/// 入参为入单病种记录ID
/// class： DHCMA.CPW.SD.QCMrList DHCMA.CPW.SD.QCItemExec  DHCMA.CPW.SD.QCEntityItem
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDS.QCItemExecSrv","QryQCItemExec","21","")
Query QryQCItemExec(MrListID As %String = "", aVerID As %String = "", aQCEntityID As %String = "") As %Query(ROWSPEC = "BTID:%String,aParRef:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTExpressDr:%String,BTExpressCode:%String,BTIsActive:%String,BTIndNo:%String,BTLinkedItem:%String,BTLinkedItemDesc:%String,BTTriggerCondition:%String,BTResume:%String,BTExpressParam:%String,BTIsNeeded:%String,BTItemCat:%String,BTItemSubCat:%String,ExecResult:%String,ExecResultText:%String,ExecRowID:%String,EditPower:%String,ExecWarning:%String,BTTypeCode:%String,BTUpTypeDr:%String,BTUpTypeDesc:%String,BTUpTypeCode:%String,Resume:%String,ObjectID:%String,ExecType:%String,SheetID:%String")
{
}

ClassMethod QryQCItemExecExecute(ByRef qHandle As %Binary, MrListID As %String = "", aVerID As %String = "", aQCEntityID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;Set:MrListID="" MrListID=14 //测试用，如果传参为空，显示脑梗的表单
 	If (MrListID'="") {
	 	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
	 	Set:aQCEntityID="" aQCEntityID=MrListObj.QCEntityDr.%Id()
	 	If (aVerID="") {
		 	Set ObjQCEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjById(aQCEntityID)
		 	Set aVerID=ObjQCEntity.BTVersion.%Id()
 		}
 		//初始状态(已确认)表单自动同步表单数据

 		if (MrListObj.QCState="I") {
	 		d ..refreshForm(MrListID)
	 	}
 	}
 	Quit:(aQCEntityID="") $$$OK
 	Set TMPItemVal("E")=0		//已填报项目
 	Set TMPItemVal("A")=0		//自动采集项目
 	Set TMPItemVal("N")=0		//未填报项目
	Set xSubRowID=""	
 	For
 	{	
 		Set xSubRowID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfParref",aQCEntityID,xSubRowID))
 		Quit:xSubRowID=""
 		Set xRowID = aQCEntityID_"||"_xSubRowID
 		Set (BTCode,BTDesc,BTTypeDr,BTTypeCode,BTTypeDesc,BTUpTypeDr,BTUpTypeDesc,BTUpTypeCode,BTExpressDr,BTExpressCode,BTIsActive,BTIndNo,BTLinkedItemID,BTLinkedItemDesc,BTTriggerCondition,BTResume,BTExpressParam,BTIsNeeded,BTItemCat,BTItemCatDesc)=""
 		Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(xRowID)
 		Continue:ObjEntityItem.BTVersion.%Id()'=aVerID
 		Set BTCode          = ObjEntityItem.BTCode
 		Set BTDesc         	= ObjEntityItem.BTDesc
 		if ($IsObject(ObjEntityItem.BTTypeDr)) {
	 		Set BTTypeDr        = ObjEntityItem.BTTypeDr.%Id()
	 		Set BTTypeDesc      = ObjEntityItem.BTTypeDr.BTDesc
	 		Set BTTypeCode		= ObjEntityItem.BTTypeDr.BTCode
 		}
 		if ($IsObject(ObjEntityItem.BTUpTypeDr)) {
	 		Set BTUpTypeDr        = ObjEntityItem.BTUpTypeDr.%Id()
	 		Set BTUpTypeDesc      = ObjEntityItem.BTUpTypeDr.BTDesc
	 		Set BTUpTypeCode	  = ObjEntityItem.BTUpTypeDr.BTCode
 		}
 		if ($IsObject(ObjEntityItem.BTExpressDr))
 		{
	 		Set BTExpressDr		= ObjEntityItem.BTExpressDr.%Id()
	 		Set BTExpressCode	= ObjEntityItem.BTExpressDr.BTCode
 		}
 		Set BTIsActive      = ObjEntityItem.BTIsActive
 		Set BTIndNo      	= ObjEntityItem.BTIndNo
 		//判断如果BTIndNo为空的情况
 		Set:BTIndNo="" BTIndNo=999
 		
 		if ($IsObject(ObjEntityItem.BTLinkedItem))
 		{
 			Set BTLinkedItemID  	= ObjEntityItem.BTLinkedItem.%Id()
 			Set BTLinkedItemDesc  	= ObjEntityItem.BTLinkedItem.BTDesc
 		}
 		Set BTIsNeeded=ObjEntityItem.BTIsNeeded
 		Set BTIsActive=$s(BTIsActive=1:"是",1:"否")
 		//增加是否有效过滤
 		continue:BTIsActive="否"
 		
 		Set BTTriggerCondition = ObjEntityItem.BTTriggerCondition
 		Set BTResume = ObjEntityItem.BTResume
 		Set BTExpressParam 	= ObjEntityItem.BTExpressParam
 		Set BTItemCat  		= ObjEntityItem.BTItemCat
 		Set BTItemSubCat  	= ObjEntityItem.BTItemSubCat
 		Set EditPower=1 	//默认每个项目可编辑
 		Set ExecRowID="",ExecResult="",ExecResultText="",ObjectID="",ExecType=""
 		if (MrListID'="") {
 			Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,xRowID,""),-1)
 			
	 		if (ESubID'="") { //转换显示值
		 		Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_ESubID)
		 		If $IsObject(ItemExecObj){
			 		Set ExecResult=ItemExecObj.ExecResult
			 		Set ObjectID=ItemExecObj.ObjectID
			 		Set ExecType=ItemExecObj.ExecType
			 		Set ExecResultText=""
			 		If (BTTypeDesc["字典") {
				 		//如果存的是字典代码  需要转换为描述
			 			Set tExecResult=ExecResult

				 		for ResultInd=1:1:$l(tExecResult,",") {
					 		Set ExecResultSub=$p(tExecResult,",",ResultInd)
				 			Set DicItemObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(aQCEntityID,aVerID,BTCode,ExecResultSub)
							Continue:'$IsObject(DicItemObj)
				 			//处理平台字典变动导致原表单数据无法上传的问题
				 			If (DicItemObj.BTIsActive'=1) {
				 				if (ExecResult[(","_ExecResultSub)) {
					 				Set ExecResult=$replace(ExecResult,","_ExecResultSub,"")

				 				}else{
									Set ExecResult=$replace(ExecResult,ExecResultSub_",","")
								}
					 			Continue
							}
					 		if ($IsObject(DicItemObj)) {
						 		//翻译字典类型项目结果
						 		Set DicDesc=DicItemObj.BTDesc
						 		Set DicDesc=##class(DHCMA.CPW.SD.Dictionary).GetTranByDesc("BTDesc",DicDesc)
					 			Set ExecResultText=ExecResultText_","_DicDesc
					 		}
				 		}
			 		}else{
				 		if ((BTDesc["医师")||(BTDesc["护士")) {
					 		//翻译医护人员
					 		Set ExecResult=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ExecResult)
					 	}elseif(BTDesc["科室"){
						 	//翻译科室信息
						 	Set ExecResult=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ExecResult)
						}	
				 	}
			 		Set:ExecResultText'="" ExecResultText=$e(ExecResultText,2,$l(ExecResultText))
			 		Set:ExecResultText="" ExecResultText=ExecResult
			 		Set ExecRowID=MrListID_"||"_ESubID
		 		}
	 		}
	 		If (ObjEntityItem.BTLinkedItem'=""){
	 			Set PValue="",PEditPower=1
	 			Set PItemDr=ObjEntityItem.BTLinkedItem.%Id()
	 			Set PItemCode=ObjEntityItem.BTLinkedItem.BTCode
	 			If $d(TMPItemInfo(PItemCode)) {
		 			Set PItemInfo=$g(TMPItemInfo(PItemCode))
		 			Set PValue=$p(PItemInfo,"^",1)
		 			Set PEditPower=$p(PItemInfo,"^",2)
		 		}else{
		 			Set PESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,PItemDr,""),-1)
			 		Set PItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_PESubID)
			 		Set:$IsObject(PItemExecObj) PValue=PItemExecObj.ExecResult
			 		//判断前提条件是否满足a,b,c
			 	}
		 		Set BTTriggerCondition=","_ObjEntityItem.BTTriggerCondition_","
				Set PValue=","_PValue_","
		 		Set:(PValue'[BTTriggerCondition)&&(BTTriggerCondition'[PValue) EditPower=0 //有前置质控项目的，如果不满足前提值，则不可编辑	
 				Set:PEditPower=0 EditPower=0
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
						If $d(TMPItemInfo(Code)) {
				 			Set PItemInfo=$g(TMPItemInfo(Code))
				 			Set PValue=$p(PItemInfo,"^",1)
				 			Set PEditPower=$p(PItemInfo,"^",2)
				 			Set CodeArr(Code)=PValue
				 			Set:PEditPower=0 CodeArr(Code)=""
				 		}else{
							Set ItemDr=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCEntityID,Code)
							if ($IsObject(ItemDr)) {
								Set xSubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",MrListID,ItemDr.%Id(),""),-1)
								Set xItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(MrListID_"||"_xSubID)
								Set xValue=""
								Set:$IsObject(xItemExecObj) xValue=xItemExecObj.ExecResult
								Set CodeArr(Code)=xValue
							}
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
							Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
							Quit  //如果有时间为空 则不执行表达式
						}
						Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
						Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
						//将各个时间参数换算为与固定时间小时差
						Set tmpHour=(tmpDateLogic-60000)*24+(tmpTimeLogic/3600)
						Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpHour)
					}elseif ($p(ParamExpSub,":",1)="CALC-m") { //计算分钟数
						Set tmpMin=0
						Set tmpDate=$p(CodeArr(CodeTmp)," ",1)	
						Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
						if (tmpDateLogic=""){
							Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
							Quit  //如果有时间为空 则不执行表达式
						}
						Set tmpTime=$p(CodeArr(CodeTmp)," ",2),tmpTimeLogic=0
						Set:tmpTime tmpTimeLogic=$zth(tmpTime,1)
						//将各个时间参数换算为与固定时间分钟差
						Set tmpMin=(tmpDateLogic-60000)*24*60+(tmpTimeLogic\60)
						Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpMin)
					}elseif ($p(ParamExpSub,":",1)="CALC-month") { //计算月数
						Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
						Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
						if (tmpDateLogic=""){
							Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
							Quit  //如果有时间为空 则不执行表达式
						}
						Set tmpDate=$zd(tmpDateLogic,3)
						Set tmpMon=$p(tmpDate,"-",1)*12+$p(tmpDate,"-",2)+$fn(($p(tmpDate,"-",3)/30),"",2)
						Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpMon)
					}elseif ($p(ParamExpSub,":",1)="CALC-year") { //计算年龄
							Set EditPower=0
							Set tmpDate=$p(CodeArr(CodeTmp)," ",1)
							Set tmpDateLogic=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(tmpDate)
							if (tmpDateLogic=""){
								Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,0)
								Quit  //如果有时间为空 则不执行表达式
							}
							Set tmpDate=$zd(tmpDateLogic,3)
							Set tmpYear=$p(tmpDate,"-",1)+$fn($p(tmpDate,"-",2),"",2)+$fn(($p(tmpDate,"-",3)/(30*12)),"",2)
					
							Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",tmpYear)
					}else{
						//默认情况下替换Code值，进行运算
						Set CodeValue=""""_$g(CodeArr(CodeTmp))_""""
						Set ParamExp=$Replace(ParamExp,"("_CodeTmp_")",CodeValue)
					}
				}
				Set ExcuteExp=$Replace(ExcuteExp,ParamExpSub,ParamExp)
				Continue:ExcuteExp["("   //如果表达式替换后还有小括号，代表有项目没识别
				}
				//小括号被作为标记项目code符号，所以表达式优先级用[] {}来写
				Set ExcuteExp=$tr($tr(ExcuteExp,"[","("),"]",")")  //[]相当于小括号
				Set ExcuteExp=$tr($tr(ExcuteExp,"{","("),"}",")")
				Set ExcuteExp=$Replace(ExcuteExp,"不包含","'[")
				Set ExcuteExp=$Replace(ExcuteExp,"包含","[")
				Set ExcuteExp=$Replace(ExcuteExp,"!","'")
				//处理包含关系 oth[o类似情况
				if (ExcuteExp["[") {
					Set ExcuteExp=##class(DHCMA.CPW.SDS.QCEntityItemSrv).ChangeExp(ExcuteExp)	
				}
				Set Exp="Set result=("_ExcuteExp_")"
				x Exp
	 			Set:result EditPower=1
	 		}	
 		}else{ 
 			Set:ObjEntityItem.BTLinkedItem'="" EditPower=0 //有前置质控项目的，默认不可编辑
 			if (ObjEntityItem.BTLinkedItem="")&&(ObjEntityItem.BTTriggerCondition'=""){
	 			Set EditPower=0 //有前置条件的，默认不可编辑 
	 			Set BTLinkedParam=ObjEntityItem.BTTriggerCondition
	 			Set ExpType=$p(BTLinkedParam,":",1)
	 			If (ExpType="") { //只做默认函数处理
					Set ExcuteExp=$p(BTLinkedParam,":",2)  
					Set ExpParam=ExcuteExp
					If (ExcuteExp'="") {
			 			for j=1:1:$l(ExpParam,")") {
							Set CodeSub=$p(ExpParam,")",j)
							Set Code=$p(CodeSub,"(",2)
							continue:Code=""
							Set ExcuteExp=$Replace(ExcuteExp,"("_Code_")","""""") //初始前置项值为空
			 			}
			 			//小括号被作为标记项目code符号，所以表达式优先级用[] {}来写
						Set ExcuteExp=$tr($tr(ExcuteExp,"[","("),"]",")")  //[]相当于小括号
						Set ExcuteExp=$tr($tr(ExcuteExp,"{","("),"}",")")
						Set ExcuteExp=$Replace(ExcuteExp,"不包含","'[")
						Set ExcuteExp=$Replace(ExcuteExp,"包含","[")
						Set ExcuteExp=$Replace(ExcuteExp,"!","'")
			 			Set Exp="Set result=("_ExcuteExp_")"
						x Exp
			 			Set:result EditPower=1
					}
		 		} 
 			}
 		}
 		Set BTIsNeeded=$s(BTIsNeeded=1:"是",1:"否")
 		Continue:((BTItemCat="")||(BTItemSubCat="")) //如果项目没有分类信息，按照附加信息处理，不作为项目显示
		Set ExecWarning=""
		//2020616 add by zgz 增加项目备注
		Set Resume=ObjEntityItem.BTResume
		//将已取出的项目值及其是否展现，暂存
		Set TMPItemInfo(BTCode)=ExecResult_"^"_EditPower
		If (ExecType="") {
			//如果没有执行类型，但有数据源配置，可以显示数据源链接。
			Set source=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetItemSourceByID(xRowID)
			Set:source'="" ExecType="T"	
		}
		//翻译项目描述及其分类
		Set BTDesc=##class(DHCMA.CPW.SD.QCEntityItem).GetTranByDesc("BTDesc",BTDesc)
		Set BTItemCat=##class(DHCMA.CPW.SD.QCEntityItem).GetTranByDesc("BTDesc",BTItemCat)
		
		//获取项目评分表
		//获取当前项目评分表信息
		Set SheetID=""
		;Set SheetObj=##class(DHCMA.CPW.SDS.EvalSrv).GetSheetByItemID(xRowID)
		;Set:$IsObject(SheetObj) SheetID=SheetObj.%Id()
 		Set TMPItemExec(BTIndNo,BTCode)=$lb(xRowID,aQCEntityID,BTCode,BTDesc,BTTypeDr,BTTypeDesc,BTExpressDr,BTExpressCode,BTIsActive,BTIndNo,BTLinkedItemID,BTLinkedItemDesc,BTTriggerCondition,BTResume,BTExpressParam,BTIsNeeded,BTItemCat,BTItemSubCat,ExecResult,ExecResultText,ExecRowID,EditPower,ExecWarning,BTTypeCode,BTUpTypeDr,BTUpTypeDesc,BTUpTypeCode,Resume,ObjectID,ExecType,SheetID)
 		If (EditPower=1) {
	 		///记录表单展现项目填报情况的构成数量
	 		Set:ExecResult'="" TMPItemVal("E")=TMPItemVal("E")+1
	 		Set:(ExecResult'="")&&(ExecType="A") TMPItemVal("A")=TMPItemVal("A")+1
	 		Set:(ExecResult="")&&(BTIsNeeded="是") TMPItemVal("N")=TMPItemVal("N")+1
 		}
 	}
 	Set xInd="" 
 	for {
	 	Set xInd=$o(TMPItemExec(xInd))
		Quit:xInd=""
		Set xCode=""
		for {
				Set xCode=$o(TMPItemExec(xInd,xCode))
				Quit:xCode=""
				Set Data=TMPItemExec(xInd,xCode)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 }
	//更新表单当前填报，自动采集、应填未填数量
	Set ECount=$g(TMPItemVal("E"))
	Set ACount=$g(TMPItemVal("A"))
	Set NCount=$g(TMPItemVal("N"))
	d ..updateMrCount(MrListID,ECount,ACount,NCount)
	
	Quit $$$OK
}

ClassMethod QryQCItemExecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryQCItemExecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryQCItemExecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryQCItemExecExecute ]
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

/// add by zgz  2021-10-19
/// 根据病例ID以及质控项目ID获取表单项目结果
/// w ##class(DHCMA.CPW.SDS.QCItemExecSrv).GetItemInfo("15","1||292")
ClassMethod GetItemInfo(aMrListID As %String, aItemID As %String) As %String
{
	new (aMrListID,aItemID)
	Set return=""
	Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,aItemID,""),-1)
 	Quit:ESubID="" return
 	Set (ItemType,ItemCode,Result)=""
	Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_ESubID)
	If $IsObject(ItemExecObj){
 		Set Result=ItemExecObj.ExecResult
	}
	Set ObjEntityItem = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
	Set ItemCode=ObjEntityItem.BTCode
	If ($IsObject(ObjEntityItem.BTTypeDr)) {
 		Set ItemType = ObjEntityItem.BTTypeDr.BTDesc
	}
	Set return=ItemType_"^"_ItemCode_"^"_Result
	Quit return
}

/// add by zgz  2021-11-2
/// 通过项目code value 插入数据
/// w ##class(DHCMA.CPW.SDS.QCItemExecSrv).InsertItemValue("15","1||292")
ClassMethod InsertItemValue(aInputStr As %String) As %String
{
	new (aInputStr)
	Set return=1
	Set aMrListID	= $p(aInputStr,"^",1)
	Set ItemCodeArr	= $p(aInputStr,"^",2)
	Set ValueArr	= $p(aInputStr,"^",3)
	Set aUserID		= $p(aInputStr,"^",4)
	
	Set mrObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	Quit:'$IsObject(mrObj) return
	Set aQCID=mrObj.QCEntityDr.%Id()
	Set aVerID=mrObj.QCEntityDr.BTVersion.%Id()
	Set ErrInfo=""
	For xind=1:1:$l(ItemCodeArr,$c(1)) {
		Set aItemCode=$p(ItemCodeArr,$c(1),xind)
		Set aValue=$p(ValueArr,$c(1),xind)
		//去掉项目值中的特殊字符
		Set tValue=##class(DHCMA.Util.IO.CommonSrv).CleanSpecialChar(aValue)
		if (tValue="")&&(aValue'="") {
			Set ErrInfo=ErrInfo_aItemCode_":"_aValue_"值为特殊字符;<br>"
			Continue
		}else{
			Set aValue=tValue
		}
		Set aItemObj=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode(aVerID,aQCID,aItemCode)
		Continue:'$IsObject(aItemObj)
		Set aItemID=aItemObj.%Id()
		Set aInputstr=aMrListID_"^"_aItemID_"^"_aValue_"^"_aUserID
		Set ret=##class(DHCMA.CPW.SD.QCItemExec).Update(aInputstr)
		If (+ret<0) {
			Set ErrInfo=ErrInfo_aItemCode_":"_aValue_";<br>"
		}
	}
	Set:ErrInfo'="" return="-1^"_ErrInfo
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCItemExecSrv).updateMrCount(15,1,1,1)
ClassMethod updateMrCount(aMrListID As %String, aECount As %String, aACount As %String = "", aNCount As %String = "") As %String
{
	new (aMrListID,aECount,aACount,aNCount)
	Set return=""
	Set obj=##class(DHCMA.CPW.SD.QCMrList).%OpenId(aMrListID)
	Quit:'$IsObject(obj) return
	Set ECount=obj.ECount
	Set ACount=obj.ACount
	Set NCount=obj.NCount
	If ((ECount'=aECount)||(ACount'=aACount)||(NCount'=aNCount)) {
		Set obj.ECount			= aECount
		Set obj.ACount			= aACount
		Set obj.NCount			= aNCount
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=obj.%Id()
		}
	}
	Do obj.%Close()
	Quit return
}

/// w ##class(DHCMA.CPW.SDS.QCItemExecSrv).refreshForm(9)
ClassMethod refreshForm(MrListID) As %String
{
	new (MrListID)
	Set MrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(MrListID)
 	Set QCEntityID=MrListObj.QCEntityDr.%Id()
 	Set ObjQCEntity=##class(DHCMA.CPW.SD.QCEntity).GetObjById(QCEntityID)
 	Set VerID=ObjQCEntity.BTVersion.%Id()
	//抽取数据池
	d ##class(DHCMA.CPW.SD.DataSrv.DataTask).ExtractByAdm(1,MrListObj.QCEpisodeID)
	//同步表单项目值
	If (MrListObj.QCState="I") {
		//初始状态的表单，同步值前先清空历史数据
		&sql(Delete FROM DHCMA_CPW_SD.QCItemExec where Parref=:MrListID)
	}
	d ##class(DHCMA.CPW.SDS.QCTask).InitMrlistByID(MrListID,VerID) //同步当前表单空缺项目
	Quit 1
}

}
