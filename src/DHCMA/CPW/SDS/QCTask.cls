Class DHCMA.CPW.SDS.QCTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     fcz
/// CreatDate：   2019-1-21
/// Description:  自动判断项目执行情况     
/// d ##class(DHCMA.CPW.SDS.QCTask).AutoTaskForExcue()
ClassMethod AutoTaskForExcue() As %String
{
	set count=0
	/// 1/获取未提交的单病种列表
	/// 2/根据就诊号和病种获取质控项目
	/// 3/判断项目是否执行，已执行项目不再处理，未执行项目首先判断是否存在对照，然后同步医嘱，最后做判断
	set mrListID=""
	For {
		set mrListID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",mrListID))
		quit:mrListID=""
		set objMr=##class(DHCMA.CPW.SD.QCMrList).GetObjById(mrListID)
		set %EpisodeID=objMr.QCEpisodeID
		//获取当前病种表单版本
		Set VerID=objMr.QCEntityDr.BTVersion.%Id()
		set stateID=""
		For {
			set stateID=$o(^DHCMA.CPW.SD.QCMrListStateI("IndexParref",mrListID,stateID))
			quit:stateID=""
			set objstate=##class(DHCMA.CPW.SD.QCMrListState).GetObjById(mrListID_"||"_stateID)
			/// 获取表单状态编码
			Continue:'$IsObject(objstate.StateCode)
			Set stateCode=objstate.StateCode.BTCode
			Continue:stateCode'="Save"    
			Continue:objMr.QCState="O"
			/// 取就诊号,病种信息
			set EpisodeID=objMr.QCEpisodeID
			set QCID=objMr.QCEntityDr.%Id()
			/// 根据病种取项目
			Set xCode=""	
		 	For
		 	{	
		 		Set xCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID,xCode))
		 		Quit:xCode=""
		 		Set xSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID,xCode,QCID,0))
		 		Continue:xSubID=""
				/// 判断项目是否执行
				Set ItemID=QCID_"||"_xSubID
				Continue:$d(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",mrListID,ItemID))
				set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
				set cate=objItem.BTItemCat
				/**关联项目判断**/
				Set linkItemID="",LinkItemDicCodeStr=""
				if (objItem.BTLinkedItem)
				{
					set linkItemCode=objItem.BTLinkedItem.BTCode
					set linkItemID=objItem.BTLinkedItem.%Id()
					/// 判断关联项目是否执行
					set linkExecID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",mrListID,linkItemID,""),-1)
					Continue:linkExecID=""
					// 获取关联项目执行结果
					set objExec=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(mrListID_"||"_linkExecID)
					set linkResult=objExec.ExecResult
					Continue:(linkResult'[objItem.BTTriggerCondition)	
			
				}
				set %ItemID=ItemID
				Set %MRlistID=mrListID
				Continue:$d(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",mrListID,%ItemID))
				/**关联项目判断**/
				set exp=objItem.BTExpressDr.BTExpress
				Continue:exp=""	
				/// 未完成的项目运行表达式
				set expResult="set Result="_exp
				x expResult
				/// 运行表达式后为执行项目，则更新项目执行记录
				if (Result'="")
				{
					//如果是字典类型，通过名称匹配代码
					if (objItem.BTTypeDr.BTDesc["字典")  {
							//特殊字典对照
							if (Result="M"){
								Set Result="男"
							}elseif(Result="F"){
								Set Result="女"
							}
							
							Set DicTypeCode=objItem.BTCode
							Set DicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofCode"," "_$zcvt(DicTypeCode,"U"),0))
							Quit:DicTypeID=""
							Set DicCode=""
							For {
								Set DicCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode))
								Quit:DicCode=""
								Set DicID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode,""),-1)
								Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicID)
								Set DicDesc=DicObj.BTDesc
								Set:(DicDesc[Result)||(Result[DicDesc) Result=DicCode
								}
						}
					set execStr=mrListID_"^"_qcItemID_"^"_Result
					set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execStr)
				}
				set count=count+1
			}	
		}	
	}
	quit count
}

/// 根据配置的病种准入排除条件，初始化单病种病例
/// input: aFromDate,aToDate 
/// 通过出院开始结束日期，获取单病种病例
/// d ##class(DHCMA.CPW.SDS.QCTask).AutoTaskForMrList("2021-01-01","2021-01-31","")
ClassMethod AutoTaskForMrList(aFromDate As %String, aToDate As %String, aEpisodeID As %String = "") As %String
{
	new (aFromDate,aToDate,aEpisodeID)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	//Set $ZT="AutoTaskForMrListErr"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMA.CPW.SDS.QCTask(YY_"-"_MM,DD))
	Set ^DHCMA.CPW.SDS.QCTask(YY_"-"_MM,DD,NUM,"命令")="do ##class(DHCMA.CPW.SDS.QCTask).AutoTaskForMrList("_aFromDate_","_aToDate_")"
	Set ^DHCMA.CPW.SDS.QCTask(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	If (aEpisodeID'="") {
		d ..CheckSDByAdm(aEpisodeID)	
	}else {
		//编目信息
		Set AdmsStr=""
		for xDate=aFromDate:1:aToDate{
			Set Adms = ##class(DHCMA.CPW.SDS.IO.GetDataSrv).IGetFPCodingAdms(xDate)
			Set AdmsStr=AdmsStr_"^"_Adms
		}
		Set AdmsStr=$tr(AdmsStr,"^",",")
		For xAdmInd=1:1:$l(AdmsStr,","){
			Set xPaadm=$p(AdmsStr,",",xAdmInd)
		/*if MRSVersion=2 {
			s ds = ##class(%Library.ResultSet).%New("web.DHCWMRInterface.FrontPage:QryFrontPage")
			d ds.Execute(xDate,aToDate)
			
		}
		while(ds.Next()) {
			if (MRSVersion=3) {
				Set xPaadm=ds.Data("EpisodeID")
			}else{ 
				Set xPaadm=ds.Data("Paadm")
			}
		*/
		/*Set DischDateIndex=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	    For xDate=aFromDate:1:aToDate {
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			
				Quit:xPaadm=""*/
				Continue:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				d ..CheckSDByAdm(xPaadm)			
	    }
    }
AutoTaskForMrListErr
	Quit "Error"
}

ClassMethod CheckSDByAdm(xPaadm As %String) As %String
{
	New (xPaadm)
	//过滤掉已经进入单病种的病例
	Set EpisodeID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(xPaadm)
	Set %EpisodeID=EpisodeID
	Set objEpisode=##class(DHCMA.Util.EPy.EpisodeSrv).GetSynObjByOID(%EpisodeID)
	Set AdmLoc=objEpisode.PAAdmLocID
	///如果患者已经存在有效的单病种表单，则退出入组判断
	Quit:$d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID)) ""
	if ($d(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID))){
		Set xMrlistID="",MrFlg=0
		for {
				Set xMrlistID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",EpisodeID,xMrlistID))
				Quit:xMrlistID=""
				Quit:MrFlg=1
				Set xMrListObj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xMrlistID)
				Set:xMrListObj.QCState'="O" MrFlg=1
			}
		Quit:MrFlg=1 ""
	}
	//遍历已经开展的质控病种
	Set MrListID="",xIndNo=0
	For {
		Set xIndNo=$o(^DHCMA.CPW.SD.QCEntityI("IdxofIndNo",xIndNo))
		Quit:xIndNo=""
		Quit:(+MrListID>0) //已入病种，退出判断
		Set EntityID=0
	 	For
	 	{
		 	Set EntityID        = $o(^DHCMA.CPW.SD.QCEntityI("IdxofIndNo",xIndNo,EntityID))
		 	Quit:EntityID=""
		 	Quit:(+MrListID>0) //已入病种，退出判断
		 	//已存在病种入组记录，退出
		 	Continue:$d(^DHCMA.CPW.SD.QCMrListI("IndexAdmEntity"," "_EpisodeID,EntityID))
		 	Set objEntity        = ##class(DHCMA.CPW.SD.QCEntity).GetObjById(EntityID)
		 	Set IsActive         = objEntity.BTIsActive
		 	Set BTLocation		 = objEntity.BTLocation
		 	//按照关联科室过滤患者
		 	Continue:(BTLocation'="")&&($listfind(BTLocation,AdmLoc)=0)
		 	Continue:IsActive'=1
		 	//遍历病种的配置项目
		 	k tmpRuleInfo
		 	Set RuleSubID=""	
		 	For
		 	{	
		 		Set RuleSubID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexParref",EntityID,RuleSubID))
		 		Quit:RuleSubID=""
		 		Set RuleID = EntityID_"||"_RuleSubID
		 		Set ObjRule = ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(RuleID)
		 		Set IsActive          	= ObjRule.IsActive
		 		Continue:IsActive'=1
		 		Set RuleType          	= ObjRule.RuleType
		 		Set RuleDesc			= ObjRule.RuleDesc
		 		Set RuleMethod          = ObjRule.RuleMethod.BTExpress
		 		Continue:RuleMethod
		 		Set RuleParam          	= ObjRule.RuleParam
		 		Set IndNo          		= ObjRule.IndNo
		 		Set RuleKey          	= ObjRule.RuleKey
		 		Set:RuleKey'="" RuleParam=RuleParam_","_RuleKey
		 		Set tmpRuleInfo(RuleType,IndNo)=$lb(RuleID,RuleMethod,RuleParam,RuleDesc)	
		 	}
		 	Set ret=""
		 	If ($d(tmpRuleInfo(1))) { //有准入配置，才进行入组判断
		 		Set xInd=""
		 		For {
		 			Set xInd=$o(tmpRuleInfo(1,xInd)) 
		 			Quit:xInd=""
		 			Set ret="N"
		 			Set xRuleID=$lg(tmpRuleInfo(1,xInd),1)
		 			Set RuleMethod=$lg(tmpRuleInfo(1,xInd),2)
		 			Set RuleParam=$lg(tmpRuleInfo(1,xInd),3) //多个参数拆分替换暂未考虑
		 			Set RuleDesc=$lg(tmpRuleInfo(1,xInd),4)
		 			Set RuleMethod=$Replace(RuleMethod,"()","")
		 			Continue:RuleMethod'["##"
		 			Set exp="Set ret="_RuleMethod_"("""_RuleParam_""")"
		 			x exp
		 			Quit:(RuleDesc["且伴")&&(ret'="Y") //前置准入条件不满足直接退出
		 			Quit:(RuleDesc'["且伴")&&(ret="Y") //满足准入规则，退出入组判断
			 	}
			 	If (ret="Y"){
		 			//如果满足第一准入条件，直接进入单病种列表
					//QCEpisodeID,PCEntityDr,QCEntityDr,QCInDocID,QCInLocID,QCInWardID
		 			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(%EpisodeID)
		 			Set userID=""
		 			Set InDocID=ObjPaadm.PAAdmDocID
		 			If (InDocID'="") {
			 			Set CPID=$p(InDocID,"!!",1)
			 			Set xSYSDr=$p(InDocID,"!!",2)
			 			Set:xSYSDr="" xSYSDr=1
			 			Set MAUserID=$o(^DHCMA.Util.EPx.SSUserI("IdxOfCPID",xSYSDr,CPID,0))
			 			Set MAUserObj=##class(DHCMA.Util.EPx.SSUser).GetObjById(MAUserID)
			 			Set:$IsObject(MAUserObj) userID=MAUserObj.SYSOID
			 		}
			 		Set:userID="" userID=InDocID
		 			Set InLocID=ObjPaadm.PAAdmLocID
		 			Set InWardID=ObjPaadm.PAAdmWardID
		 			Set InputStr=EpisodeID_"^"_""_"^"_EntityID_"^"_userID_"^"_InLocID_"^"_InWardID
		 			Set QCRet=##class(DHCMA.CPW.SDS.QCMrListSrv).InQCEntity(InputStr)
		 			if (QCRet>0 ) {
			 			Set MrListID=QCRet
			 			//增加病历状态记录
			 			Set StateStr=MrListID_"^"_"I"_"^"_InDocID
			 			Set StateID=##class(DHCMA.CPW.SD.QCMrListState).Update(StateStr)
			 			if (+StateID>0){
				 				Set StateAlias=StateID_"^"_xRuleID_"^"
				 				Set AliasID=##class(DHCMA.CPW.SD.QCMrStateAlias).Update(StateAlias)
				 			}else{
					 			Set return="-2^单病种状态更新失败"
					 			}
		 			}else{
			 			Set return="-1^进入单病种失败"
			 			}
		 			w "新增入组病历ID:"_MrListID,!
				 	if ($d(tmpRuleInfo(2)))
				 	{
					 	//对于符合准入条件，且有排除配置的病例，做自动排除判断
					 	Set yInd="",RuleIDStr=""
			 			For {
				 			Set yInd=$o(tmpRuleInfo(2,yInd))
				 			Quit:yInd=""
				 			Set xRuleID=$lg(tmpRuleInfo(2,yInd),1)
				 			Set RuleMethod=$lg(tmpRuleInfo(2,yInd),2)
				 			Set RuleParam=$lg(tmpRuleInfo(2,yInd),3) //多个参数拆分替换暂未考虑
				 			Set RuleMethod=$Replace(RuleMethod,"()","")
				 			Continue:RuleMethod'["##"
				 			Set exp="Set ret="_RuleMethod_"("""_RuleParam_""")"
				 			x exp
				 			Set:ret="Y" RuleIDStr=RuleIDStr_"&"_xRuleID
			 			}
				 		if (RuleIDStr'=""){
				 			Set RuleIDStr=$e(RuleIDStr,2,$l(RuleIDStr))
				 			//如果满足排除条件，改变单病种列表状态，并记录排除原因
				 			Set ObjPaadm=##class(DHCMA.Util.EPy.EpisodeSrv).GetLogicSynObjByOID(%EpisodeID)
				 			Set InDocID=ObjPaadm.PAAdmDocID
				 			Set InLocID=ObjPaadm.PAAdmLocID
				 			Set InWardID=ObjPaadm.PAAdmWardID
				 			Set OutStr=EpisodeID_"^"_InDocID_"^"_""_"^"_InLocID_"^"_InWardID
				 			Set OutRet=##class(DHCMA.CPW.SDS.QCMrListSrv).OutQCEntity(OutStr)
				 			if (+OutRet>0) {
					 			Set StateStr=OutRet_"^"_"O"_"^"_InDocID
					 			Set StateID=##class(DHCMA.CPW.SD.QCMrListState).Update(StateStr)
					 			if (+StateID>0){
						 				Set StateAlias=StateID_"^"_RuleIDStr_"^"
						 				Set AliasID=##class(DHCMA.CPW.SD.QCMrStateAlias).Update(StateAlias)
						 			}else{
							 			Set return="-2^单病种状态更新失败"
							 			}
					 			w "自动排除病历ID:"_MrListID,! 
					 			Set MrListID=""    //排除病历，将入组id值为空，进行下一病种的判定
					 			w "排除原因ID:"_RuleIDStr,!
				 			}
				 		}
					}
				}
			}
			//是否启用消息平台消息发送功能
			Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
			If (((+IsSendMsg)=1)&&(MrListID'="")) {
				Set admObj=##class(DHCMA.Util.EP.Episode).xGetByOID(EpisodeID)
				Set tmpOpinion="患者:["_admObj.PAPatName_"]为单病种病例，请注意填报"
				Set DocOID=admObj.PAAdmDocID
				If (DocOID'="") {
					Set ToUser=$o(^SSU("SSUSR",0,"CTPCP",$p(DocOID,"!!",1),0))
					//Set aUserID=$G(%session.Data("LOGON.USERID"))
					//调用消息平台接口
					//Set flg1=##class(web.SSMessageRecipient).SendUserMessage(tmpOpinion,ToUser,aUserID)
				}
			}
			If (MrListID'="") { 
				//新入组病例，抽取数据池
				d ##class(DHCMA.CPW.SD.DataSrv.DataTask).ExtractByAdm(1,EpisodeID)
			}
		}
	}
	Quit MrListID
}

/// d ##class(DHCMA.CPW.SDS.QCTask).InitMrlistByID(4181,2)
ClassMethod InitMrlistByID(mrListID, VerID = "") As %String
{
	New (mrListID,VerID)
	set objMr=##class(DHCMA.CPW.SD.QCMrList).GetObjById(mrListID)
	Quit:'$IsObject(objMr) ""
	set %EpisodeID=objMr.QCEpisodeID
	set %MrListID=mrListID
	//抽取数据中心数据，后面挂任务就取消掉
	d ##class(DHCMA.CPW.SD.DataSrv.DataTask).ExtractByAdm(1,%EpisodeID)
	set QCID=objMr.QCEntityDr.%Id()
	Set:VerID="" VerID=objMr.QCEntityDr.BTVersion.%Id()
	/// 根据病种取项目
	set qcItemID="",count=0
	Set xItemCode=""	
 	For
 	{	
 		Set xItemCode=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID,xItemCode))
 		Quit:xItemCode=""
 		Set xSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID,xItemCode,QCID,0))
 		Continue:xSubID=""
		/// 判断项目是否执行
		Set ItemID=QCID_"||"_xSubID
		set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(ItemID)
		set cate=objItem.BTItemCat
		set %ItemID=ItemID,ExcuteType="A"  ;自动提取
		/// 判断项目是否执行
		Continue:$d(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",mrListID,%ItemID))
		/**关联项目取值**/
		Set Result=""
		set exp=objItem.BTExpressDr.BTExpress
		if (exp'=""){
			//配置项目直接取值参数，走该方式
			Set:exp'["()" exp=exp_"()"
			/// 运行项目表达式
			set expResult="set Result="_exp
			x expResult
		}
		if (Result="") {
			//配置项目数据源标准取值，走该方式
			set Result=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetValByDataConfig(%EpisodeID,%ItemID)
		}
		if (Result=""){
			Set ExcuteType="D"  ;默认值
			Set objType = ##class(DHCMA.CPW.SD.DicType).GetObjByCode(QCID,VerID,objItem.BTCode)
		 	if ($Isobject(objType)) {
			 	Set TypeDr = objType.%Id()
			 	Set xCode = ""
			 	For {
				 	Set xCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
				 	Quit:xCode=""	 	
				 	Set DicRowID = ""
				 	For {
					   	Set DicRowID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,DicRowID))
					   	Quit:DicRowID=""
					 	Set BTDicObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicRowID)
					 	Continue:'$IsObject(BTDicObj)
					 	Continue:BTDicObj.BTIsActive'=1
					 	Continue:BTDicObj.BTIsDefault'=1
					 	Set Result=Result_","_BTDicObj.BTCode
				 	}
			 	}
			 	Set:Result'="" Result=$e(Result,2,$l(Result))
			 	}
			 	Continue:Result=""
		}
		
		/// 运行表达式|获取默认值后更新项目执行记录
		if (Result'="")
		{
			Set objItemTmp=objItem
			d InitItemValue
		}
		set count=count+1
	}		
	quit count
InitItemValue
	Set ResultTmp=Result
	Set ResultOth=""
	Set Result=$p(Result,"^",1)
	Quit:Result=""
	Set:$l(ResultTmp,"^")>1 ResultOth=$e(ResultTmp,($l(Result)+2),$l(ResultTmp))
	//如果是字典类型，通过名称匹配代码
	if (objItem.BTTypeDr.BTDesc["字典")  {
		//特殊字典对照
		Set ResultCode=""
		if (Result="M"){
			Set Result="男"
		}elseif(Result="F"){
			Set Result="女"
		}elseif(Result="有"){
			Set Result="有，是"
		}elseif(Result="无"){
			Set Result="无，否"
		}
		Set DicTypeCode=objItem.BTCode
		Set DicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",QCID,VerID," "_$zcvt(DicTypeCode,"U"),0))
		Set DicCode=""
		For {
			Set DicCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode))
			Quit:DicCode=""
			Set DicID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode,""),-1)
			Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicID)
			Set DicDesc=DicObj.BTDesc
			//增加值域字典，关键字信息匹配（来源于值域字典对照+标准字典关键字信息）
			Set KeyInfo=##class(DHCMA.CPW.SD.QCOptionMatchKey).GetKeyInfoByDicId(DicID)
			If (KeyInfo'=""){
				Set DicKey=$p(KeyInfo,"^",1)
				Set DicFilter=$p(KeyInfo,"^",2)
				Set KeyFlg=..CheckDicKey(Result,DicKey,DicFilter)
				Set:KeyFlg=1 ResultCode=ResultCode_","_DicObj.BTCode 
			}
			if (ResultCode="")&&(($ASCII(Result)>122)||($ASCII(Result)<97)||($l(Result)>8)){
				;判断，如果非a-z代码/或者超长描述，走描述匹配
				Set:(DicDesc[Result)||(Result[DicDesc) ResultCode=ResultCode_","_DicObj.BTCode
			}
			//考虑到病人医嘱可能会执行多个字典结果，拼串
			Set:((","_DicObj.BTCode_",")[(","_Result))||((","_Result_",")[(","_DicObj.BTCode_",")) ResultCode=ResultCode_","_DicObj.BTCode
			//非多选项目，ResultCode不为空则退出
			Quit:((ResultCode'="")&&(objItem.BTTypeDr.BTDesc'["多选"))
		}
		Set:ResultCode'="" ResultCode=$e(ResultCode,2,$l(ResultCode))
		Set Result=ResultCode
		
	}
	Quit:(Result="")
	set:ResultOth'="" execStr=mrListID_$c(1)_%ItemID_$c(1)_Result_$c(1,1,1,1)_ResultOth_$c(1)_ExcuteType
	Set:ResultOth="" execStr=mrListID_$c(1)_%ItemID_$c(1)_Result_$c(1,1,1,1,1)_ExcuteType
	set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execStr,$c(1))
	d InitLinkedItemValue
	Quit
InitLinkedItemValue
   	Set linkItemID=""
	if (objItemTmp.BTLinkedItem)
	{
		set linkItemCode=objItemTmp.BTLinkedItem.BTCode
		set linkItemID=objItemTmp.BTLinkedItem.%Id()
		/// 判断关联项目是否执行
		Set LinkItemType=objItemTmp.BTLinkedItem.BTUpTypeDr.BTCode
		set linkExecID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",mrListID,linkItemID,""),-1)
		//非数组项目 生成值后 将不再更新
		Quit:(linkExecID'="")&&(LinkItemType'="Array")
		// 自动生成前置项目结果(前置条件唯一，自动生成;如果前置条件多个，按代码顺序匹配)
		Set Value=objItemTmp.BTTriggerCondition
		Quit:$l(Value,",")>1 //前置项为多个值，不能自动生成
		set Result=Value
		If (linkExecID'="") {
			//数组类型的需要保留原数据
			Set xVal=""
			Set ObjExec=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(mrListID_"||"_linkExecID)
			Set:$IsObject(ObjExec) xVal=ObjExec.ExecResult
			If (xVal'="")&&((","_xVal_",")'[(","_Result_",")) {
				//如果历史值不包含新前置条件，则加上
				Set Result=xVal_","_Result
			}else{
				Set Result=xVal	
			}
		}
		Set execPStr=mrListID_"^"_linkItemID_"^"_Result
		Set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execPStr)
		Set objItemTmp=objItemTmp.BTLinkedItem
		d InitLinkedItemValue //逐级往上，直到关联项目处理完
	}
	/*elseif (objItemTmp.BTTriggerCondition'="") {
		Set Express=objItemTmp.BTTriggerCondition
		for ExpInd=1:1:$l(Express,"]") {
			Set ExpSubStr=$p(Express,"]",ExpInd)
			Set ExpSub=$p(ExpSubStr,"[",2)
			Continue:((ExpSub="")||(ExpSub'["=")||(ExpSub["'=")) //非等于条件的前置条件都无法确定前置关联项的值
			Set CodeStr=$p(ExpSub,")",1)
			Set Code=$p(CodeStr,"(",2)
			Continue:Code=""
			set linkItemSubID=$o(^DHCMA.CPW.SD.QCEntityItemI("IdxOfVerCode",VerID," "_$zcvt(Code,"U"),QCID,""),-1)
			Set Value=$p($p(ExpSub,"=",2),"""",2)
			set Result=Value
			set execPStr=mrListID_"^"_QCID_"||"_linkItemSubID_"^"_Result
			set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execPStr)
		}	
	}
	*/
	Quit
}

/// w ##class(DHCMA.CPW.SDS.QCTask).CheckDicKey("城镇医疗保险","城镇")
ClassMethod CheckDicKey(DicDesc, DicKey = "", DicFilter = "") As %String
{
	new (DicDesc,DicKey,DicFilter)
	Set return=0
	Quit:DicDesc="" return
	Quit:(DicKey="")&&(DicFilter="") return
	For KeyInd=1:1:$l(DicKey,"|") {
		Set DicSubKey=$p(DicKey,"|",KeyInd)
		Continue:DicSubKey=""
		Set:DicDesc[DicSubKey return=1
		Quit:return=1
	}
	//如果有关键字滤除，而没有关键字，默认关键字信息符合。
	Set:DicKey="" return=1
	For FilterInd=1:1:$l(DicFilter,"|") {
		Set DicFSubKey=$p(DicFilter,"|",FilterInd)
		Continue:DicFSubKey=""
		Set:DicDesc[DicFSubKey return=0
		Quit:return=0
	}
	Quit return
}

/// 单独生成某个项目的值
ClassMethod InitItemValue(aMrListID, aItemID) As %String
{
	New (aMrListID,aItemID)
	Set return="",count=0
	Quit:(aMrListID="")||(aItemID="") return
	set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
	set cate=objItem.BTItemCat
	set objMr=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMrListID)
	set %EpisodeID=objMr.QCEpisodeID
	set %ItemID=aItemID,ExcuteType="A"  ;自动提取
	/// 判断项目是否执行
	Quit:$d(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,aItemID)) return
	/**关联项目取值**/
	Set Result=""
	set exp=objItem.BTExpressDr.BTExpress
	if (exp'=""){
		//配置项目直接取值参数，走该方式
		Set:exp'["()" exp=exp_"()"
		/// 运行项目表达式
		set expResult="set Result="_exp
		x expResult
	}else{
		//配置项目数据源标准取值，走该方式
		set Result=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetValByDataConfig(%EpisodeID,%ItemID)
	}
	if (Result=""){
		Set ExcuteType="D"  ;默认值
		Set objType = ##class(DHCMA.CPW.SD.DicType).GetObjByCode(QCID,VerID,objItem.BTCode)
	 	if ($Isobject(objType)) {
		 	Set TypeDr = objType.%Id()
		 	Set xCode = ""
		 	For {
			 	Set xCode= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
			 	Quit:xCode=""	 	
			 	Set DicRowID = ""
			 	For {
				   	Set DicRowID= $o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,DicRowID))
				   	Quit:DicRowID=""
				 	Set BTDicObj= ##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicRowID)
				 	Continue:'$IsObject(BTDicObj)
				 	Continue:BTDicObj.BTIsActive'=1
				 	Continue:BTDicObj.BTIsDefault'=1
				 	Set Result=Result_","_BTDicObj.BTCode
			 	}
		 	}
		 	Set:Result'="" Result=$e(Result,2,$l(Result))
		 	}
		 	Quit:Result="" return
	}		
	/// 运行表达式|获取默认值后更新项目执行记录
	if (Result'="")
	{
		Set objItemTmp=objItem
		d InitOneItemValue
	}
	set count=count+1		
	quit count
InitOneItemValue
	Set ResultTmp=Result
	Set ResultOth=""
	Set Result=$p(Result,"^",1)
	Set:$l(ResultTmp,"^")>1 ResultOth=$e(ResultTmp,($l(Result)+2),$l(ResultTmp))
	//如果是字典类型，通过名称匹配代码
	if (objItem.BTTypeDr.BTDesc["字典")  {
		//特殊字典对照
		Set ResultCode=""
		if (Result="M"){
			Set Result="男"
		}elseif(Result="F"){
			Set Result="女"
		}elseif(Result="有"){
			Set Result="有，是"
		}elseif(Result="无"){
			Set Result="无，否"
		}
		Set DicTypeCode=objItem.BTCode
		Set DicTypeID=$o(^DHCMA.CPW.SD.DicTypeI("IdxofQCVerCode",QCID,VerID," "_$zcvt(DicTypeCode,"U"),0))
		Set DicCode=""
		For {
			Set DicCode=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode))
			Quit:DicCode=""
			Set DicID=$o(^DHCMA.CPW.SD.DictionaryI("IdxofTypeDrCode",DicTypeID,DicCode,""),-1)
			Set DicObj=##class(DHCMA.CPW.SD.Dictionary).GetObjById(DicID)
			Set DicDesc=DicObj.BTDesc
			//增加值域字典，关键字信息匹配（来源于值域字典对照+标准字典关键字信息）
			Set KeyInfo=##class(DHCMA.CPW.SD.QCOptionMatchKey).GetKeyInfoByDicId(DicID)
			//$ASCII(Result) 判断，如果是汉字描述/或者超长描述，走描述匹配
			If (($ASCII(Result)>122)||($l(Result)>8)){
				If (KeyInfo'=""){
					Set DicKey=$p(KeyInfo,"^",1)
					Set DicFilter=$p(KeyInfo,"^",2)
					Set KeyFlg=..CheckDicKey(Result,DicKey,DicFilter)
					Set:KeyFlg=1 ResultCode=ResultCode_","_DicObj.BTCode 
				}elseif (((DicDesc[Result)||(Result[DicDesc))){
						Set ResultCode=ResultCode_","_DicObj.BTCode
				}
			}
			//考虑到病人医嘱可能会执行多个字典结果，拼串
			Set:((","_DicObj.BTCode_",")[(","_Result))||((","_Result_",")[(","_DicObj.BTCode_",")) ResultCode=ResultCode_","_DicObj.BTCode
			//非多选项目，ResultCode不为空则退出
			Quit:((ResultCode'="")&&(objItem.BTTypeDr.BTDesc'["多选"))
		}
		Set:ResultCode'="" ResultCode=$e(ResultCode,2,$l(ResultCode))
		Set Result=ResultCode
		
	}
	Quit:(Result="")
	set:ResultOth'="" execStr=aMrListID_"^"_%ItemID_"^"_Result_"^^^^"_ResultOth_"^"_ExcuteType
	Set:ResultOth="" execStr=aMrListID_"^"_%ItemID_"^"_Result_"^^^^^"_ExcuteType
	set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execStr)
	d InitOneLinkedItemValue
	Quit
InitOneLinkedItemValue
   	Set linkItemID=""
	if (objItemTmp.BTLinkedItem)
	{
		set linkItemCode=objItemTmp.BTLinkedItem.BTCode
		set linkItemID=objItemTmp.BTLinkedItem.%Id()
		/// 判断关联项目是否执行
		Set LinkItemType=objItemTmp.BTLinkedItem.BTUpTypeDr.BTCode
		set linkExecID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,linkItemID,""),-1)
		//非数组项目 生成值后 将不再更新
		Quit:(linkExecID'="")&&(LinkItemType'="Array")
		// 自动生成前置项目结果(前置条件唯一，自动生成;如果前置条件多个，按代码顺序匹配)
		Set Value=objItemTmp.BTTriggerCondition
		Quit:$l(Value,",")>1 //前置项为多个值，不能自动生成
		set Result=Value
		If (linkExecID'="") {
			//数组类型的需要保留原数据
			Set xVal=""
			Set ObjExec=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_linkExecID)
			Set:$IsObject(ObjExec) xVal=ObjExec.ExecResult
			If (xVal'="")&&((","_xVal_",")'[(","_Result_",")) {
				//如果历史值不包含新前置条件，则加上
				Set Result=xVal_","_Result
			}else{
				Set Result=xVal	
			}
		}
		Set execPStr=aMrListID_"^"_linkItemID_"^"_Result
		Set execResult=##class(DHCMA.CPW.SD.QCItemExec).Update(execPStr)
		Set objItemTmp=objItemTmp.BTLinkedItem
		d InitOneLinkedItemValue //逐级往上，直到关联项目处理完
	}
	Quit
}

}
