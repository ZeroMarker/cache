/// 名称: web.DHCCPW.MR.Interface
/// 描述: 临床路径数据接口
/// 编写者：zhufei
/// 编写日期: 2010-08-11
Class web.DHCCPW.MR.Interface Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-08-11
/// Description:  To病人列表(C/S)接口,替换原来[单双轨列]
///               具体应用请查看DHCCPWInterface.Mac文件
///               根据就诊号取当前最新临床路径状态
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID:    User.PAADM
/// Return：      ID_$c(1)_Desc
/// w ##class(web.DHCCPW.MR.Interface).GetPathWayStatus(13742542)
ClassMethod GetPathWayStatus(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetPathWayStatusErr"
	
	Quit:EpisodeID="" return
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Quit:ID="" return
	Set Status=$listget($g(^DHCMR("CPW",ID)),5)
	Set CPWOutReason=""
	If Status="O" {
		Set CPWOutReason=$listget($g(^DHCMR("CPW",ID)),12)
		Set:CPWOutReason'="" CPWOutReason=$listget($g(^DHCMRC("VR",CPWOutReason)),3)
		Set CPWComments=$listget($g(^DHCMR("CPW",ID)),13)
		Set CPWOutReason=$s(CPWComments'="":",有备注",1:"")_","_CPWOutReason_","_CPWComments
	} Else {
		Set CPWComments=$listget($g(^DHCMR("CPW",ID)),13)
		Set CPWOutReason=$s(CPWComments'="":",有备注,"_CPWComments,1:"")
	}
	
	Set VarID=0,CPWVariance=""
	For {
		Set VarID=$o(^DHCMR("CPW",ID,"VAR",VarID))
		Quit:VarID=""
		Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(ID_"||"_VarID)
		If $IsObject(objVar) {
			If $IsObject(objVar.CPWVReasonDR) {
				Set CPWVariance=CPWVariance_";"_objVar.CPWVReasonDR.VRDesc
			}
		}
	}
	Set VarianceList=$s(CPWVariance="":"",1:",有变异"_CPWVariance)
	Set return=$s(Status="I":"1"_$c(1)_"入径",Status="O":"2"_$c(1)_"出径",Status="C":"3"_$c(1)_"关闭",1:"")_CPWOutReason_VarianceList
	Quit return
	
GetPathWayStatusErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-08-11
/// Description:  关闭临床路径
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID:    User.PAADM
/// Return：      return<0 失败，return>0 成功，return=0 无操作
/// Test:         w ##class(web.DHCCPW.MR.Interface).ClosePathWay(5730431)
/// ToInterface:  web.DHCADTDischarge.GetAbnormalOrder()    //BS新版最终结算检查医嘱接口
///               web.UDHCCLDischarge.GetAbnormalOrder()    //BS旧版最终结算检查医嘱接口
///               web.DHCADTDischarge.PAAdmDischarge()      //BS医疗结算更新时执行的方法
///               web.DHCADTDischarge.PAAdmFinalDischarge() //BS最终结算更新时执行的方法
ClassMethod ClosePathWay(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Set $ZT="ClosePathWayErr"
	
	Quit:EpisodeID="" return
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set ID=0
	For {
		Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,ID))
		Quit:ID=""
		Set obj=##Class(User.DHCMRClinicalPathWay).%OpenId(ID)
		Continue:obj=""
		If obj.CPWStatus="I" {
			Set obj.CPWStatus="C"
			Set obj.CPWOutDate=+$h
			Set obj.CPWOutTime=$p($h,",",2)
			Set obj.CPWOutDoctorDR=""
			Set obj.CPWUpdateDate=+$h
			Set obj.CPWUpdateTime=$p($h,",",2)
			Set obj.CPWUpdateUserDR=""
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {    //检查Save是否成功
	   			Do $system.OBJ.DisplayError(sc)
	   			Set return=-1
			} Else {
				Set return=obj.%Id()
				//add by zf 2012-01-10
				Set flg1=##Class(web.DHCCPW.MR.InterfaceToPrj).ClosePathWayToHIS(EpisodeID)
			}
			Do obj.%Close()
		} Else {
			Set return=0
		}
	}
	Quit return
	
ClosePathWayErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2010-09-10
/// Description:  To综合统计组接口
///               根据就诊号取临床路径 入径数量^出径数量^关闭数量
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID:    User.PAADM
/// Return：      return=入径数量^出径数量^关闭数量
/// w ##class(web.DHCCPW.MR.Interface).GetPathWayCount(13479887)
ClassMethod GetPathWayCount(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set InCount=0,OutCount=0,CloseCount=0
	Set return=InCount_"^"_OutCount_"^"_CloseCount
	Set $ZT="GetPathWayCountErr"
	
	Quit:EpisodeID="" return
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set ID=0
	For {
		Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,ID))
		Quit:ID=""
		Set Status=$listget($g(^DHCMR("CPW",ID)),5)
		Set InCount=InCount+1
		Set:Status="O" OutCount=OutCount+1
		Set:Status="C" CloseCount=CloseCount+1
	}
	
	Set return=InCount_"^"_OutCount_"^"_CloseCount
	Quit return
	
GetPathWayCountErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-09-27
/// Description:  From计费组接口
///               根据就诊号取本次住院相关费用
/// Table：       
/// Input：       argEpisodeID:    User.PAADM
/// Return：      return=住院相关费用
/// w ##class(web.DHCCPW.MR.Interface).GetAdmCateFee(13479887)
ClassMethod GetAdmCateFee(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="GetAdmCateFeeErr"
	
	/* update by zf 2012-12-07
	Set StDtTmIndex=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OEOrdItemStDtTmIndex")
	If $IsObject(objConfig){
		Set StDtTmIndex=objConfig.BCValue
	}
	Set:StDtTmIndex="" StDtTmIndex="StDtTm1"
	If StDtTmIndex="YYGL" {
		//取航天中心医院HIS费用数据
		Set strCateFee=##Class(web.DHCCPW.MR.InterfaceToPrj).GetAdmCateFees(argEpisodeID)
	} Else {
		//取东华HIS费用数据
		Set strCateFee=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(argEpisodeID)
	}
	
	Set CountCost=0,DrugCost=0
	For Index=1:1:$l(strCateFee,"&")
	{
		Set Fee=$p(strCateFee,"&",Index)
		Set CountCost=CountCost+$p(Fee,"^",2)
		Set:Fee["药" DrugCost=DrugCost+$p(Fee,"^",2)
	}
	*/
	Set CountCost=0,DrugCost=0
	Set strCateFee=##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getCostInfo(argEpisodeID)
	If strCateFee'="" {
		Set CountCost=+$list(strCateFee,1)
		Set DrugCost=+$list(strCateFee,2)
	}
	
	Set return=CountCost_"^"_DrugCost
	Quit return
	
GetAdmCateFeeErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-09-27
/// Description:  From计费组接口
///               根据就诊号取本次住院相关费用
/// Table：       
/// Input：       argEpisodeID:    User.PAADM
/// Return：      return=住院相关费用
/// w ##class(web.DHCCPW.MR.Interface).GetAdmCateFees(13479887)
ClassMethod GetAdmCateFees(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="GetAdmCateFeesErr"
	
	Set StDtTmIndex=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("OEOrdItemStDtTmIndex")
	If $IsObject(objConfig){
		Set StDtTmIndex=objConfig.BCValue
	}
	Set:StDtTmIndex="" StDtTmIndex="StDtTm1"
	If StDtTmIndex="YYGL" {
		//取航天中心医院HIS费用数据
		Set return=##Class(web.DHCCPW.MR.InterfaceToPrj).GetAdmCateFees(argEpisodeID)
	} Else {
		//取东华HIS费用数据
		Set return=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(argEpisodeID)
	}
	
	Quit return
	
GetAdmCateFeesErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-11-03
/// Description:  To病人列表图标接口
///               根据就诊号取当前最新临床路径状态
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.DHCCPW.MR.Interface).GetCurrPathWay(3469035)
ClassMethod GetCurrPathWay(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetCurrPathWayErr"
	
	Quit:EpisodeID="" return
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set ID=0
	For {
		Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,ID))
		Quit:ID=""
		Set Status=$listget($g(^DHCMR("CPW",ID)),5)
		Continue:Status'="I"
		Set CPWID=$listget($g(^DHCMR("CPW",ID)),3)
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set return=objCPW.CPWDesc_",状态:"_$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"")
		}
	}
	Quit return
	
GetCurrPathWayErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-11-05
/// Description:  To诊断录入接口
///               判断是否符合临床路径准入标准,给出临床路径准入提示
/// Table：       User.DHCMRCClinPathWays
/// Input：       EpisodeID:    User.PAADM
///               MRCICDID:     MRC_ICDDx.Rowid
/// Return：      return:临床路径信息
/// w ##class(web.DHCCPW.MR.Interface).CheckCPWICD(65663,"65663||8")
ClassMethod CheckCPWICD(argEpisodeID As %String, argMRDiagnos As %String) As %String
{
	New (argEpisodeID,argMRDiagnos)
	Set return=""
	Set $ZT="CheckCPWICDErr"
	
	//add by zf 2012-04-21 增加是否启用准入提示设置
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckCPWICDToDiagnos")
	//Quit:IsCheck'="Y" return
	Quit:$p(IsCheck,"||",1)'="Y" return
	
	Quit:(argEpisodeID="")||(argMRDiagnos="") return
	
	Set MRAdm=+argMRDiagnos
	Quit:MRAdm="" return
	Set AdmType=$p($g(^PAADM(argEpisodeID)),"^",2)
	Quit:(AdmType'="I")&&(AdmType'="O") return
	Quit:($p(IsCheck,"||",2)'="")&&($p(IsCheck,"||",2)'=AdmType) return
	
	Set LocationDR=$p($g(^PAADM(argEpisodeID)),"^",4)
	Quit:LocationDR="" return
	
	//1 如果患者已入径,无论是否出径,返回空,不再检查是否入径
	Set PathWayID=0,flg=0
	For {
		Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
		Quit:PathWayID=""
		Quit:flg<0
		
		Set CPWID="",IsActive=""
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		If $IsObject(objPathWay) {
			If $IsObject(objPathWay) {
				Set CPWID=objPathWay.CPWPathwayDR.%Id()
			}
			Set PathWayStatus=objPathWay.CPWStatus
		}
		//Continue:(CPWID="")||(PathWayStatus'="I")
		//Set flg=-1
		Continue:(CPWID="")
		If (AdmType'="O") {
			Continue:(PathWayStatus'="I")
			Set flg=-1
		}
	}
	Quit:flg<0 return
	
	//update By chengpeng 2014/8/26 检查患者是否有未入经记录，则返回空，不再检查是否入经
	set UnPathWayID=""
	set UnPathWayID=$o(^DHCMRi("LOG",0,"PaadmIndex",argEpisodeID,UnPathWayID))
	Quit:UnPathWayID'="" return
	
	//2 根据类型设置取临床诊断,用于判断是否符合某条路径
	Set MRDiagnos=+$p(argMRDiagnos,"||",2)
	Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
	Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
	Set ICD10=$p(tmpICD,"^",4)
	Set ICDDesc=$p(tmpICD,"^",3)
	Set ICDResume=""
	Set DesID=$o(^MR(MRAdm,"DIA",MRDiagnos,"DES",0))
	Set:DesID'="" ICDResume=$g(^MR(MRAdm,"DIA",MRDiagnos,"DES",DesID))
	Set:ICDResume'="" ICDDesc=ICDDesc_"***"_ICDResume
	Quit:(ICD10="")&&(ICDDesc="") return	//update by liuyh 2016-03-30
	Set GetCPWICDType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("GetCPWICDType")
	If GetCPWICDType=1 {
		//类型1 只检查主要诊断
		Set TypeDicCode=""
		Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
		If MRDiagType'="" {
			Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
			Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
		}
		Quit:TypeDicCode'="M" return    //Main(M)为主要诊断类型
	} ElseIf GetCPWICDType=3 {
		//类型3 只检查入院主诊断
		Set TypeDicCode=""
		Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
		If MRDiagType'="" {
			Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
			Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
		}
		Quit:TypeDicCode'="PRE" return    //PRE 为入院主诊断代码
	} Else {
		//其他 检查所有诊断
	}
	
	//3 判断此诊断符合哪条路径的准入标准,根据准入ICD来判断
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set (CPWDesc,CPWICD,CPWLebal,CurrVersion,CPWActive,IsOpCPW)=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set CPWDesc=objCPW.CPWDesc
			Set CPWICD=objCPW.CPWICD
			Set CPWKeys=objCPW.CPWKeys
			Set CPWLebal=objCPW.CPWLabel
			Set CPWActive=objCPW.CPWActive	//zhaoyu 2012-12-06
			If $IsObject(objCPW.CPWCPWDicDR) {
				Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
				Set CPWDicID=objCPW.CPWCPWDicDR.%Id()
				Set IsOpCPW=objCPW.CPWCPWDicDR.CPWDIsOpCPW	// zhaoyu 2014-02-26
				Set IsOpCPW=$s(IsOpCPW["Y":"O",1:"I")
				Set IsActive=objCPW.CPWCPWDicDR.CPWDActive
				Set DateFrom=objCPW.CPWCPWDicDR.CPWDDateFrom
				Set DateTo=objCPW.CPWCPWDicDR.CPWDDateTo
				Continue:IsActive'["Y"
				Continue:(DateFrom'="")&&(DateFrom>+$h)
				Continue:(DateTo'="")&&(DateTo<+$h)
			}
		}
		Continue:(AdmType'=IsOpCPW)
		Continue:CurrVersion'=CPWID
		Continue:$g(CPWICD)=""
		Continue:CPWActive'="Y"	//zhaoyu 2012-12-06
		Continue:'$d(^DHCMRCi("DEPCPW",0,"IndexCPW",CPWDicID," "_LocationDR))
		
		Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(ICD10,CPWICD)
		If (CPWKeys'="")&&(ICDDesc'="")
		{
			Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(ICDDesc,CPWKeys)
		} Else {
			Set flg2=-1
		}
		Continue:(flg1<=0)&&(flg2<=0)
		
		Set CPWList(CPWID)=$lb($g(CPWDesc),$g(CPWLebal))
	}
	Quit:$o(CPWList(0))="" return
	
	//组织返回值,给医护人员提示符合哪条临床路径,多条路径符合,默认第一个路径
	Set xReturn="",xCPWID="",xCPWDesc=""
	Set CPWID=0
	For {
		Set CPWID=$o(CPWList(CPWID))
		Quit:CPWID=""
		
		Set xReturn=xReturn_$listget($g(CPWList(CPWID)),1)_";"    //$listget($g(CPWList(CPWID)),2)_";"
		
		Set xCPWID=xCPWID_$c(2)_CPWID
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		If $IsObject(objCPW) {
			Set xCPWDesc=xCPWDesc_$c(2)_objCPW.CPWDesc
		}
	}
	Set:xCPWID'="" xCPWID=$e(xCPWID,2,$l(xCPWID))
	Set:xCPWDesc'="" xCPWDesc=$e(xCPWDesc,2,$l(xCPWDesc))
	Set return="诊断【"_ICDDesc_"】符合临床路径【"_xReturn_"】准入标准!"_$c(1)_xCPWID_$c(1)_xCPWDesc_$c(1)_AdmType
	Quit return
	
CheckCPWICDErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2010-12-28
/// Description:  To医嘱录入接口
///               医嘱录入时插入临床路径实时记录
/// Table：       
/// Input：       Adm:          User.PAADM
///               OrderStr:     插入医嘱时返回值
///               User:         登录人员
///               Doctor:       医护人员
/// Return：      return:临床路径信息
/// w ##class(web.DHCCPW.MR.Interface).InsertDHCCPWImp(Adm,OrderStr,User,Doctor)
ClassMethod InsertDHCCPWImp(Adm As %String, OrderStr As %String, User As %String, Doctor As %String) As %String
{
	n (Adm,OrderStr,User,Doctor)
	s err=0
	s $ZT="InsertDHCCPWImpErr"
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp")
	
	//s OrderRowId=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(Adm)
	s MRCPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByMradm(Adm)
	s MRCPWRowId=$p(MRCPWString,"^",1)
	
	Set CurrStepStr=##class(web.DHCCPW.OPCPW.InterfaceOP).IsCurrStepOP(Adm)
	Set xPathWayId=$p(CurrStepStr,"^",1)
	Set xImplNewId=$p(CurrStepStr,"^",2)
	Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(xImplNewId)
	Set xStepId=$p(ImplNewStr,"^",2)
	Set:(xImplNewId'="") MRCPWRowId=xPathWayId
	
	if MRCPWRowId="" Quit 0
	
	f k=1:1:$l(OrderStr,"^")-1 {
		s ArcimRowId=$p($p(OrderStr,"^",k),"*",1)
		i ArcimRowId="" continue
		s OrderItemRowId=$p($p(OrderStr,"^",k),"*",2)
		i OrderItemRowId="" continue
		s CPWStepItemRowId=$p($p(OrderStr,"^",k),"*",4)
		//i CPWStepItemRowId="" continue
		s OrderStartDate=$p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1),"^",9)
		s OrderStartTime=$p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1),"^",10)
		if Doctor="" s Doctor=$P(^SSU("SSUSR",User),"^",14)
		
		If (CPWStepItemRowId'="") {
			Set ^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k,"cpw")=CPWStepItemRowId
		} Else {
			Continue:(xStepId="")
			Set ItemID=""
			Set CPWID=$p(xStepId,"||",1),EpID=$p(xStepId,"||",2),StepID=$p(xStepId,"||",3)
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:(ItemID="")
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(xStepId_"||"_ItemID)
				Continue:'$IsObject(objItem)
				Continue:'$IsObject(objItem.CPWSISubCategory)
				Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
				Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
				Continue:(CategDesc'["医嘱")	//不检查非医嘱项目
				Set CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
				Set SubCatID=objItem.CPWSISubCategory.%Id()
				Set ItemRowid=xStepId_"||"_ItemID_"-"_xStepId_"-"_SubCatID
				Set OrderItmDtl=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetItemDetailsById(ItemRowid)
				Set ItmDtlFlg="N"
				For ItmDtlInd=1:1:$l(OrderItmDtl,$c(1))-1 {
					Quit:(ItmDtlFlg="Y")
					Set ItmDtlStr=$p(OrderItmDtl,$c(1),ItmDtlInd)
					Set:($p(ItmDtlStr,"^",2)=ArcimRowId) ItmDtlFlg="Y"
				}
				If (ItmDtlFlg="Y") {
					Set ^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k,ItemID)=ItemRowid
				}
			}
			// 对照
			If ('$d(^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k))) {
				Set ContStepItem=""
				For {
					Set ContStepItem=$o(^DHCMRi("CPWC",0,"IndexCPWStepItem",CPWID,xStepId,ContStepItem))
					Quit:(ContStepItem="")
					Set ContrastId="",IsContrast="N"
					For {
						Set ContrastId=$o(^DHCMRi("CPWC",0,"IndexCPWStepItem",CPWID,xStepId,ContStepItem,ContrastId))
						Quit:(ContrastId="")!(IsContrast="Y")
						Set objContrast=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByContrastID(ContrastId)
						Set ContActive=$s($IsObject(objContrast):objContrast.CPWCActive,1:"ERROR")
						Continue:(ContActive'="Y")
						Set ContItem=objContrast.CPWCContItem
						Set:(ContItem=ArcimRowId) IsContrast="Y"
					}
					If (IsContrast="Y") {
						Set ^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k,ContStepItem)=ContStepItem
					}
				}
			}
		}
		
		Set tmpItmId=""
		For {
			Set tmpItmId=$o(^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k,tmpItmId))
			Quit:(tmpItmId="")
			Set CPWStepItemRowId=$g(^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp",k,tmpItmId))
			
			s ImplStr="^"_MRCPWRowId_"^"
			s ImplStr=ImplStr_OrderItemRowId_"^"
			s ImplStr=ImplStr_CPWStepItemRowId_"^"
			s ImplStr=ImplStr_OrderStartDate_"^"
			s ImplStr=ImplStr_OrderStartTime_"^"
			s ImplStr=ImplStr_Doctor_"^^^"
			s ImplStr=ImplStr_User
			
			Set ImplStr=ImplStr_"^^^^^^"_xImplNewId
			Set flg=##class(web.DHCCPW.MR.Implement).InsertImpl(ImplStr)
			Set err=err_"^"_flg
		}
	}
	Kill ^CacheTemp(ZIndex,JIndex,"InsertDHCCPWImp")
	Quit err
	
InsertDHCCPWImpErr
	Quit 0
}

/// Creator：     pylian
/// CreatDate：   2016-02-23
/// Description:  临床路径医嘱检查接口
///               通过医嘱ID判断医嘱是否路径内医嘱
/// Table：       
/// Input：       argOrdItemID:    User.OEOrdItem
/// Return：      1:医嘱是路径内医嘱，0：否
/// w ##class(web.DHCCPW.MR.Interface).CheckCPWOrder("511||15")
ClassMethod CheckCPWOrder(argOrdItemID As %String) As %String
{
	New (argOrdItemID)
	Set return=0

	Quit:(argOrdItemID="") return
	Set OrdItemID=argOrdItemID
	Set OrdID=$p(OrdItemID,"||",1)
	Set SubID=$p(OrdItemID,"||",2)

	Quit:'$d(^OEORD(+OrdID)) return
	Set EpisodeID=$p($g(^OEORD(+OrdID)),"^",1)   	              // OEORD_Adm_DR
	
	Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	Quit:(AdmType'="I")&&(AdmType'="O") return
	
	Set MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdm="" return
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm)) return       //未入径不再判断

	Set OEORIItmMastDR = $p($g(^OEORD(OrdID,"I",SubID,1)),"^",2)   // 医嘱项指针 ARC_ItmMast
	Set ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",2)
	Set ARCIMItemCatDR=$p($g(^ARCIM(+OEORIItmMastDR,1,1)),"^",10)
   	Set ARCICOrderType=$p($g(^ARC("IC",+ARCIMItemCatDR)),"^",7)    //医嘱大类
    Quit:ARCICOrderType'="R" return                                //只判断药品医嘱

  	Set aPathWayID=0
	For {
		Set aPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,aPathWayID))
		Quit:aPathWayID=""
	
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
		Continue:'$IsObject(objPathWay)
		Set aStepID=""
		For {
			Set aStepID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID))
			Quit:aStepID=""
	
			Set aArcim=""
			For {
				Set aArcim=$o(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",aArcim))
				Quit:aArcim=""
				Continue:aArcim'=OEORIItmMastDR
			  
			  	Set alnkArcimID=""
				For {
					Set alnkArcimID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",aArcim,alnkArcimID))
					Quit:alnkArcimID=""
					
					Set aOEItemID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",aArcim,alnkArcimID,"")) //aOEItemID="OEItemID:357||47||1"
					Set OEItemID=$p($p(aOEItemID,":",2),"||",1)_"||"_$p($p(aOEItemID,":",2),"||",2)
					Quit:OEItemID'=OrdItemID
					Set return=1
				}
			}
				
		}		
	}
	
	Quit return
}

///  1 查询哪些临床路径维护了关联医嘱
///  select distinct(CPWSI_ParRef->CPWS_ParRef->EP_ParRef->CPW_Desc) from DHC_MRC_ClinPathWaysEpStepItem where DHC_MRC_ARCIMList is not null
///  2 查询哪些临床路径项目维护了关联医嘱
///  select CPWSI_ParRef->CPWS_ParRef->EP_ParRef->CPW_Desc,CPWSI_ParRef->CPWS_ParRef->EP_Desc,CPWSI_Desc  from DHC_MRC_ClinPathWaysEpStepItem where DHC_MRC_ARCIMList is not null
/// 获取所有路径的关联医嘱项+收费项
/// w ##Class(web.DHCCPW.MR.Interface).GetARCItmMast()
ClassMethod GetARCItmMast()
{
	New
	
	Kill ^DHCMRCTD("CPWTAR")
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRC("CPW",CPWID))
		Quit:CPWID=""
		Set CPWDesc=$list($g(^DHCMRC("CPW",CPWID)),3)
		Set EpID=0
		For {
			Set EpID=$o(^DHCMRC("CPW",CPWID,"EP",EpID))
			Quit:EpID=""
			Set StepID=0
			For {
				Set StepID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID))
				Quit:StepID=""
				Set StepDesc=$list($g(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID)),4)
				Set ItemID=0
				For {
					Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
					Quit:ItemID=""
					Set ItemRowid=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
					Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowid)
					Continue:'$IsObject(objItem)
					Set ItemDesc=objItem.CPWSIDesc
					Set ARCIM=objItem.CPWSIARCIM
					Set ARCIMCnt=objItem.CPWSIARCIM.Count()
					For ARCIMInd=1:1:ARCIMCnt {
						Set objARCIM=objItem.CPWSIARCIM.GetAt(ARCIMInd)
						Continue:'$IsObject(objARCIM)
						Set ItmARCIMDR=objARCIM.ITMARCIMDR
						Set ItmARCIMDesc=$p($g(^ARCIM(+ItmARCIMDR,$p(ItmARCIMDR,"||",2),1)),"^",2)
						Continue:(ItmARCIMDR="")||(ItmARCIMDesc="")
						//GetOrderPrice(pattype, instype, arcim, sttdate, prior, instr, linkto, oeprice)
						//通过医嘱项取收费项
						Set TarId=0
						For {
							Set TarId=$o(^DHCOLT(0,"ARTTA",ItmARCIMDR,TarId))
							Quit:TarId=""
							Set TarDesc=$p($g(^DHCTARI(TarId)),"^",2)
							Set TarPrice=##class(web.UDHCJFPRICE).GetItmPrice(TarId,$h,"","","")
							Set TarPrice=$p(TarPrice,"^",1)_"元"
							//"路径名称||步骤名称||项目名称||医嘱项||收费项||单价
							Set ^DHCMRCTD("CPWTAR",CPWDesc)=StepDesc_"||"_ItemDesc_"||"_ItmARCIMDesc_"||"_TarDesc_"||"_TarPrice
						}
					}
				}
			}
		}
	}
	
	Quit "Over!"
}

/// Creator：     zhufei
/// CreatDate：   2011-07-28
/// Description:  To统计组临床路径统计接口
/// Table：       
/// Input：       aEpisodeID : 就诊号
/// Return：      
/// w ##class(web.DHCCPW.MR.Interface).GetPathWayInfoToStat(aEpisodeID)
ClassMethod GetPathWayInfoToStat(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	//是否医院感染（Y/N）
	Set IsHospInf=##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getIsInHospInf(aEpisodeID)
	
	//手术病人手术部位是否感染（Y/N）
	Set IsOperInf=##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getIsOperInf(aEpisodeID)
	
	//病人并发症名称
	Set Complation=""
	
	//是否进入临床路径、是否完成路径、是否变异
	Set PathWayInfo=##Class(web.DHCCPW.MR.ClinPathWayAnalysisBat).getPathWayInfo(aEpisodeID)
	Set PathWayID=$list(PathWayInfo,2)
	Set Status=$list(PathWayInfo,3)
	Set IsHaveVar=$list(PathWayInfo,4)  //是否变异（Y/N）
	Set IsInPathWay=$s(PathWayID'="":"Y",1:"N")  //是否进入临床路径（Y/N）
	Set IsClosePathWay=$s(Status="C":"Y",1:"N")  //是否完成路径（Y/N）
	
	//是否有医院感染、手术病人手术部位是否感染、病人并发症名称、是否进入临床路径、是否完成路径、是否变异
	Set return=$lb(IsHospInf,IsOperInf,Complation,IsInPathWay,IsClosePathWay,IsHaveVar)
	Quit return
}

/// Creator:wangcs
/// CreateDate:2012-11-12
/// Description:组件PAADMDischarge.Edit调用的类
/// Debug:w ##Class(web.DHCCPW.MR.Interface).CheckSign()
ClassMethod CheckSign()
{
	Write "<input type='hidden' id='CPWCheckSign' value='"_##Class(websys.Page).Encrypt($LB("web.DHCCPW.MR.Interface.CheckSignBeforeDischarge"))_"'/>" ,!
	Write "<script Language=""javascript"">" ,!
	Write "function CheckSignBeforeDischarge(){" ,!
	Write "var EpisodeID=document.getElementById('EpisodeID').value;" ,!
	Write "objc=document.getElementById(""CPWCheckSign"");" ,!
	Write "if (objc) {encmeth=objc.value} else {encmeth=''};" ,!
	Write "var userId=session['LOGON.USERID'];" ,!
	Write "ret=cspRunServerMethod(encmeth,userId,EpisodeID);" ,!
	Write "var CHR_1=String.fromCharCode(1);" ,!
	Write "var arry=ret.split(CHR_1);" ,!
	Write "var retString="""";//alert(ret);" ,!
	Write "if (arry.length>0){ret=arry[0];retString=arry[1];}" ,!
	Write "if(ret==""Y""){alert(retString);document.getElementById(""Update"").style.visibility=""hidden"";return;}",!
	Write "if(ret==""N""){alert(retString);return;}}",!
	Write "if(window.attachEvent){window.attachEvent(""onload"",CheckSignBeforeDischarge);} //IE",!
    Write "else{window.addEventListener(""load"",CheckSignBeforeDischarge,true);}  //FireFox",!
	Write !,"</script>" ,!
}

/// Creator：     liuyuhui
/// CreatDate：   2012-02-13
/// Description:  做医疗或护士结算前先判断是否有未完成的签名
/// Table：       
/// Input：       UserID     ：登陆用户ID
///               Paadm      : 就诊号
///               SignType   : 签名检查类型
/// Return：      "":无  1：有且强制控制  -1：有且提示
/// w ##class(web.DHCCPW.MR.Interface).CheckSignBeforeDischarge(390,72566,"")
ClassMethod CheckSignBeforeDischarge(UserID As %String, Paadm As %String, SignType As %String = "") As %String
{
	New (UserID,Paadm,SignType)
	Set Return=0
	//Set ^Wang("CheckSignBeforeDischarge")=UserID_","_Paadm_","_SignType
	Quit:Paadm="" Return
	Set $ZT="CheckSignBeforeDischargeErr"
	/*
	 描述：做医疗结算或最终结算前判断是否完成签名
	 数据格式：Y||0 强制医生护士签名;Y||1 强制医生签名; Y||2 强制护士签名; 
	           N||0 提示医生护士签名;N||1 提示医生签名; N||2 提示护士签名; 
	 是否强制签名："":不判断        "Y":强制签名   "N":提示但不强制签名
	 是否身份校验 ："0":全部身份校验     "1":医生签名   "2":护士签名
	*/
	Set strValue=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckSignBeforeDischarge")
	Set IsCheckBeforeDisch=$p(strValue,"||",1)
	Set IsCheckCTPCPType=+$p(strValue,"||",2)
	Quit:IsCheckBeforeDisch="" Return
	
	//临床路径记录是否有效校验
	Set MrAdmObj=##class(DHCMed.Base.MRAdm).GeObjtByPaadm(Paadm)
	Quit:'$IsObject(MrAdmObj) Return
	Set MrAdmDR=MrAdmObj.Rowid
	//该患者不是入径患者，直接退出
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdmDR)) Return
	
	/* update by zf 20130823 存在多次出入径记录的情况
	Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdmDR,""),-1)
	Set CPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetStringById(CPWID,"^")
	Quit:CPWString="" Return
	Set Status=$p($g(CPWString),"^",9)
	Quit:Status'="I" Return //I:入径，O:出径,C:完成
	*/
	Set xCPWID="",CPWID=""
	For {
		Set xCPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdmDR,xCPWID))
		Quit:xCPWID=""
		Quit:CPWID'=""
		
		Set CPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetStringById(xCPWID,"^")
		Continue:CPWString=""
		Set Status=$p($g(CPWString),"^",9)
		Continue:Status'="I" //I:入径，O:出径,C:完成
		
		Set CPWID=xCPWID
	}
	Quit:CPWID="" Return
	
	Set IsCheckSignType=""
	If SignType="1" {
		Set IsCheckSignType="DOCTOR"
	} ElseIf SignType="2" {
		Set IsCheckSignType="NURSE"
	} Else {
		If UserID'="" {
			Set UserType=##Class(web.DHCCPW.MR.PaPatmasSrv).getCPTInternalType(UserID)
		} Else {
			Set CareProvID=$p($g(^PAADM(+Paadm)),"^",9)
			Set CarPrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)
			Set UserType=$p($g(^CT("CPT",+CarPrvTpID)),"^",4)
		}
		Set IsCheckSignType=UserType
	}
	Quit:IsCheckSignType="" IsCheckBeforeDisch_$c(1)_"无法确认医疗结算、最终结算!"
	Quit:(IsCheckCTPCPType=1)&&(IsCheckSignType'="DOCTOR") 1  ;wangcs 2012.11.12 只检查医生
	Quit:(IsCheckCTPCPType=2)&&(IsCheckSignType'="NURSE") 1   ;wangcs 2012.11.12 只检查护士
	
	//获取当前路径有效步骤
	Set CPWStepInfo="",IsFinishSign="Y",NotSignStep=""
	Set CPWStepInfoLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(CPWID)
	Quit:CPWStepInfoLS="" Return
	Set CPWStepInfoCnt=$listlength(CPWStepInfoLS)
	For CPWStepInfoInd=1:1:CPWStepInfoCnt
	{
		;Set DoctorStepNoFinishFlag=1,NurseStepNoFinishFlag=1 
		Set objCPWStepInfo=$list(CPWStepInfoLS,CPWStepInfoInd)
		Set EstEpStepDR=$list(objCPWStepInfo,1)
		;w EstEpStepDR,!
		Set ObjEpStep=##Class(User.DHCMRCClinPathWaysEpStep).%OpenId(EstEpStepDR)
		;b ;EstEpStepDR
		Set:$IsObject(ObjEpStep) EstEpStepDesc=ObjEpStep.CPWSDesc
		;Quit:IsFinishSign="N"    ;wangcs 2012.11.12 有没签名的阶段退出
		
		//检查当前步骤是否存在有效的签名（根据身份类别来判断是否需要检查）
		Set SignID=0,IsHaveSign="N"
		For {
			Set SignID=$o(^DHCMRi(0,"SIGN","IndexEpStep",CPWID,EstEpStepDR,SignID))
			Quit:SignID=""
			Quit:IsHaveSign="Y"  ;wangcs 2012.11.12 有效签名退出循环
			
			Set SignObj=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(CPWID_"||"_SignID)
			Continue:'$IsObject(SignObj)
			Set CPWSDoctorDR=SignObj.CPWSDoctorDR
			Set CPWSNurseDR=SignObj.CPWSNurseDR
			Set CPWSActive=SignObj.CPWSActive
			Continue:CPWSActive'="Y"
			
			//医生签名身份校验
			If IsCheckSignType="DOCTOR" {
				Continue:CPWSDoctorDR=""
			}
			//护士签名身份校验
			If IsCheckSignType="NURSE" {
				Continue:CPWSNurseDR=""
			}
			Set IsHaveSign="Y"
		}
		If (IsHaveSign="N"){
		  Set IsFinishSign="N"
		  Set:NotSignStep="" NotSignStep="["_EstEpStepDesc
		  Set:(NotSignStep'="")&&(NotSignStep'[EstEpStepDesc) NotSignStep=NotSignStep_"、"_EstEpStepDesc
		}
	}
	// *********************************************************************************
	Set SignTipInfo=""
	If (IsFinishSign="N") {
		Set SignTipInfo=SignTipInfo_"当前入径表单"_NotSignStep_"]步骤未完成步骤签名!"
	} Else {
		Set IsCheckBeforeDisch=""
	}
	Set SyndStr=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckSyndBeforeDischarge")
	Set SyndStr=$s((SyndStr="Y")!(SyndStr="N"):SyndStr,1:"")
	If (SyndStr'="")&&(IsCheckSignType="DOCTOR") {
		Set SyndFlg=##class(web.DHCCPW.MR.ClinPathWaysSyndrome).GetSyndInfoByCPWID(CPWID)
		If ($p(SyndFlg,"^",1)="") {
			Set SignTipInfo=SignTipInfo_"临床路径合并症、并发症未填写!"
			Set:(IsCheckBeforeDisch'="Y") IsCheckBeforeDisch=SyndStr
		}
	}
	Quit IsCheckBeforeDisch_$c(1)_SignTipInfo
	// *********************************************************************************
	Set Return=1
	Quit Return
	
CheckSignBeforeDischargeErr
	Set $ZT=""
	Quit "-999"_$c(1)_$ZError
}

/// 检查是否还需要"准入提示"检查
ClassMethod CheckIsInPathWay(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=0
	
	Set $ZT="CheckIsInPathWayErr"
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aPaadm)
	Quit:MRAdm="" return
	
	//入径过的,不再提示
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,0))
	Quit:PathWayID'="" return
	
	//记录过不入径原因的,不再提示
	Set LogID=$o(^DHCMRi("LOG",0,"PaadmIndex",+aPaadm,0))
	Quit:LogID'="" return
	
	Set return=1
	Quit return
	
CheckIsInPathWayErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  提供电子病历接口
///               取临床路径出入径及变异相关信息
/// Table：       
/// Input：       aEpisodeID  : 就诊号
///               aSeparate   : 分隔符
/// Return：      
/// w ##class(web.DHCCPW.MR.Interface).GetCPWInfoToEPR(77207,"^")
ClassMethod GetCPWInfoToEPR(aEpisodeID As %String, aSeparate As %String) As %String
{
	New (aEpisodeID,aSeparate)
	Set return=""
	
	Set $p(return,aSeparate,1)="N"
	Set $p(return,aSeparate,2)="N"
	Set $p(return,aSeparate,3)="N"
	Set $p(return,aSeparate,4)=""
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
	Quit:MRAdm="" return
	Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Quit:ID="" return
	Set $p(return,aSeparate,1)="Y"                 //是否入径  是否实施临床路径管理
	
	Set VarID=0,IsVariance="N"
	For {
		Set VarID=$o(^DHCMR("CPW",ID,"VAR",VarID))
		Quit:VarID=""
		Quit:IsVariance="Y"
		
		Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(ID_"||"_VarID)
		Continue:'$IsObject(objVar)
		Continue:objVar.CPWVUpdoFlag="Y"
		Continue:'$IsObject(objVar.CPWVReasonDR)
		
		Set IsVariance="Y"
	}
	Set $p(return,aSeparate,2)=IsVariance          //是否变异
	
	Set Status=$listget($g(^DHCMR("CPW",ID)),5)
	Set CPWOutReason=""
	If Status="O" {
		Set CPWOutReason=$listget($g(^DHCMR("CPW",ID)),12)
		Set:CPWOutReason'="" CPWOutReason=$listget($g(^DHCMRC("VR",CPWOutReason)),3)
		Set CPWComments=$listget($g(^DHCMR("CPW",ID)),13)
		Set:CPWComments'="" CPWOutReason=CPWOutReason_","_CPWComments
		
		Set $p(return,aSeparate,3)="Y"             //是否出径  是否退出临床路径
		Set CPWOutReason=$tr(CPWOutReason,aSeparate,"")
		Set $p(return,aSeparate,4)=CPWOutReason    //出径原因  退出原因
	}
	
	Quit return
}

/// w ##Class(web.DHCCPW.MR.Interface).InPathWay("4981^7^3879")
ClassMethod InPathWay(aInput As %String) As %String
{
	New (aInput)
	Set return=""
	
	Set EpisodeID=$p(aInput,"^",1)
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
	Set PathwayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Set objCPW=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathwayID)
	Set CPWStatus=$s($IsObject(objCPW):objCPW.CPWStatus,1:"")
	Quit:(CPWStatus="I") return
	Set CPWID=$p(aInput,"^",2)
	Set LogonUser=$p(aInput,"^",3)
	//******* Modified by zhaoyu 2013-04-17 修改通过提示入径，出入径明细中入径人为空的bug
	//Set InDoctor=$p($g(^SSU("SSUSR",+LogonUser)),"^",9)
	Set InDoctorRet=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(LogonUser,"^")
	Set InDoctor=$p($g(InDoctorRet),"^",1)
	//*******
	
	Set InputStr=""
	Set InputStr=InputStr_"^"_MRAdm
	Set InputStr=InputStr_"^"_CPWID
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"_"I"
	Set InputStr=InputStr_"^"_InDoctor
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"
	Set InputStr=InputStr_"^"_LogonUser
	
	Set return=##Class(web.DHCCPW.MR.ClinicalPathWays).InPathWay(InputStr)
	
	Quit return
}

/// w ##Class(web.DHCCPW.MR.Interface).GetWorkflowID("DHCCPW.OrderEntry")
ClassMethod GetWorkflowID(aWorkFlowName As %String) As %String
{
	New (aWorkFlowName)
	
	Set $ZT="GetWorkflowIDErr"
	Set return=##Class(web.DHCDocOutPatientList).GetWorkflowID(aWorkFlowName)
	Quit return
	
GetWorkflowIDErr
	Quit ""
}

/// 按就诊号检查诊断符合是否入径
/// w ##class(web.DHCCPW.MR.Interface).CheckCPWICDByAdm(3881703)
ClassMethod CheckCPWICDByAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="CheckCPWICDByAdmErr"
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argEpisodeID)
	Quit:MRAdm="" return
	
	//如果患者存在入径记录,无论是否出径,返回空,不再检查是否入径
	Set PathWayID=0,flg=0
	For {
		Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
		Quit:PathWayID=""
		Quit:flg<0
		
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Continue:'$IsObject(objPathWay)
		Set flg=-1
	}
	Quit:flg<0 return
	
	Set MRDIASub=$o(^MR(MRAdm,"DIA",""),-1)
	Set TypeID=$o(^MR(MRAdm,"DIA",MRDIASub,"TYP",0))
	Quit:TypeID="" return
	Set MRDIATypeID=$g(^MR(MRAdm,"DIA",MRDIASub,"TYP",TypeID))
	Set TypeDicCode=$p($g(^MRC("DTYP",+MRDIATypeID)),"^",1)
	Quit:TypeDicCode'="PRE" return    //PRE 为入院主诊断代码
	Set MRDiagnosID=MRAdm_"||"_MRDIASub
	Quit:MRDiagnosID="" return
	
	Set return=##class(web.DHCCPW.MR.Interface).CheckCPWICD(argEpisodeID,MRDiagnosID)
	Quit return
	
CheckCPWICDByAdmErr
	Quit ""
}

/// 出院自动关闭路径任务
/// w ##class(web.DHCCPW.MR.Interface).AutoClosePathWayBat()
ClassMethod AutoClosePathWayBat()
{
	New
	
	Set xInDate=0
	For {
		Set xInDate=$o(^DHCMRi("CPW",0,"IndexStatusInDate"," I",xInDate))
		Quit:xInDate=""
		
		Set xInTime=0
		For {
			Set xInTime=$o(^DHCMRi("CPW",0,"IndexStatusInDate"," I",xInDate,xInTime))
			Quit:xInTime=""
			
			Set xPathWayID=0
			For {
				Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexStatusInDate"," I",xInDate,xInTime,xPathWayID))
				Quit:xPathWayID=""
				
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
				Continue:'$IsObject(objPathWay)
				Continue:objPathWay.CPWStatus'="I"
				Set MRAdm=objPathWay.CPWMRADMDR
				Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Continue:Paadm=""
				
				//Set DischDate=+$p($g(^PAADM(+Paadm)),"^",6)
				//Update by pylian 2016-01-22 修改出院时间取值方式
				Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(Paadm)
				Set DischDate=$p(DischDateTime,"^",1)
				Continue:DischDate<1
				Continue:$p($g(^PAADM(+Paadm)),"^",20)'="D"  //出院状态
				
				Set flg=##class(web.DHCCPW.MR.Interface).ClosePathWay(Paadm)
			}
		}
	}
	
	Quit "Over!"
}

/// 出院前检查是否完成路径
/// w ##class(web.DHCCPW.MR.Interface).IsFinPathWaySign(4084289)
ClassMethod IsFinPathWaySign(aEpisodeID As %String, aSignType As %String) As %String
{
	New (aEpisodeID,aSignType)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set $ZT="IsFinPathWaySignErr"
	
	Set MRAdm=$p($g(^PAADM(aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set PathWayID=0
	For {
		Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
		Quit:PathWayID=""
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Continue:objPathWay=""
		Continue:objPathWay.CPWStatus'="I"  //入径患者
		
		Set SignID=0,DocSignList="",NurSignList=""
		For {
			Set SignID=$o(^DHCMR("CPW",PathWayID,"SIGN",SignID))
			Quit:SignID=""
			Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(PathWayID_"||"_SignID)
			Continue:'$IsObject(objSign)
			Continue:objSign.CPWSActive'="Y"
			Continue:'$IsObject(objSign.CPWSEpStepDR)
			Set Doctor=objSign.CPWSDoctorDR
			Set Nurse=objSign.CPWSNurseDR
			Set StepID=objSign.CPWSEpStepDR.%Id()
			If Doctor'="" {
				If $listfind(DocSignList,StepID)<1 {
					Set DocSignList=DocSignList_$lb(StepID)
				}
			}
			IF Nurse'="" {
				If $listfind(NurSignList,StepID)<1 {
					Set NurSignList=NurSignList_$lb(StepID)
				}
			}
		}
		
		If aSignType="D" {
			If DocSignList'="" {
				Set EstTimes=""
				Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
				If EstTimeLS'="" {
					Set EstTimesCnt=$listlength(EstTimeLS)
					For EstTimesInd=1:1:EstTimesCnt {
						Set objEstTime=$list(EstTimeLS,EstTimesInd)
						Set EstEpStepDR=$list(objEstTime,1)
						Continue:EstEpStepDR=""
						If $listfind(DocSignList,EstEpStepDR)<1 {
							Set return=-1
						}
						Quit:return<0
					}
				}
			} Else {
				Set return=-1
			}
		}
		
		If aSignType="N" {
			If NurSignList'="" {
				Set EstTimes=""
				Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
				If EstTimeLS'="" {
					Set EstTimesCnt=$listlength(EstTimeLS)
					For EstTimesInd=1:1:EstTimesCnt {
						Set objEstTime=$list(EstTimeLS,EstTimesInd)
						Set EstEpStepDR=$list(objEstTime,1)
						Continue:EstEpStepDR=""
						If $listfind(NurSignList,EstEpStepDR)<1 {
							Set return=-1
						}
						Quit:return<0
					}
				}
			} Else {
				Set return=-1
			}
		}
	}
	
	Quit return
	
IsFinPathWaySignErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2012-12-07
/// Description:  取在径患者的路径名称
/// Table：       User.DHCMRClinicalPathWay
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.DHCCPW.MR.Interface).GetInPathWayName(3915798)
ClassMethod GetInPathWayName(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetInPathWayNameErr"
	
	Set MRAdm=$p($g(^PAADM(aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set PathWayID=0
	For {
		Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
		Quit:PathWayID=""
		
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Continue:'$IsObject(objPathWay)
		Continue:'$IsObject(objPathWay.CPWPathwayDR)
		Set Status=objPathWay.CPWStatus
		Continue:Status'="I"
		Set return=objPathWay.CPWPathwayDR.CPWDesc
	}
	Quit return
	
GetInPathWayNameErr
	Quit ""
}

/// 根据设置及就诊号取病案号
/// w ##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID()
ClassMethod GetMrNoByEpisodeID(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set ret=""
	Quit:(+EpisodeID=0) ret
	Set MrNoFlg=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("MrNoType")
	If (+MrNoFlg=0) {
		Set ret=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
	} ElseIf (+MrNoFlg=1) {
		Set ret=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",EpisodeID)
	} Else {
		//
	}
	Quit ret
}

///  临床路径与护理病历接口：通过就诊号、日期、项目名称判断是否需要填护理病历及需要填的内容
///  Input  : EpisodeID:就诊号 StrDate:开始日期 EndDate:结束日期 EmrName:护理病历项目
///  Output : flg_$c(1)_项目名称1^项目名称2^项目名称3	flg>0需要填护理病历,flg<0不需要填护理病历
/// w ##class(web.DHCCPW.MR.Interface).chkNursingHistoryItem("329506","2014-09-10","2014-09-22","")
ClassMethod chkNursingHistoryItem(EpisodeID As %String, StaDate As %String, EndDate As %String, EmrName As %String) As %String
{
	New (EpisodeID,StaDate,EndDate,EmrName)
	Set:'$d(EmrName) EmrName=""
	Set StaDate=+$s(StaDate["-":$zdh(StaDate,3),StaDate["/":$zdh(StaDate,4),1:StaDate)
	Set EndDate=+$s(EndDate["-":$zdh(EndDate,3),EndDate["/":$zdh(EndDate,4),1:EndDate)
	Set $zt="CPWToNursingHistoryErr"
	Set ret=-1	// -1 arg error
	Quit:(+EpisodeID=0)!(StaDate=0)!(EndDate=0)!(StaDate>EndDate) ret
	Set ret=-2	// -2 ' in cpw ' op cpw
	Set (CPWID,CPWDID,CPWDDesc,CPWStatus,CPWDIsOpCPW)=""
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	If $IsObject(objPathWay) {
		Set CPWStatus=objPathWay.CPWStatus
		If $IsObject(objPathWay.CPWPathwayDR) {
			Set CPWID=objPathWay.CPWPathwayDR.%Id()
			If (objPathWay.CPWPathwayDR.CPWCPWDicDR) {
				Set CPWDID=objPathWay.CPWPathwayDR.CPWCPWDicDR.%Id()
				Set CPWDDesc=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
				Set CPWDIsOpCPW=objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDIsOpCPW
			}
		}
	}
	Quit:(+CPWID=0)!(+CPWDID=0)!(CPWDDesc="")!(CPWStatus'="I")!(CPWDIsOpCPW="Y") ret
	Set CPWInfo=PathWayID_"^"_CPWDDesc
	Set ret=-3	// -3 ' date step
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(PathWayID)
	Quit:(EstTimeLS="") ret
	Kill ArrStepDate
	Set EstTimesCnt=$listlength(EstTimeLS),NHStepList=""
	For EstTimesInd=1:1:EstTimesCnt {
		Set objEstTime=$list(EstTimeLS,EstTimesInd)
		Set EstEpStepDR=$list(objEstTime,1)
		Set EstStepStaDate=$list(objEstTime,3)
		Set EstStepEndDate=$list(objEstTime,5)
		Set EstStepEndTime=$List(objEstTime,6)
		//Continue:(EstStepEndDate=StaDate)&&(+EstStepEndTime=0)
		Set:(+EstStepEndTime=0) EstStepEndDate=EstStepEndDate-1	// 00:00结束不算
		Continue:(StaDate>EstStepEndDate)!(EndDate<EstStepStaDate)
		Set NHStepList=NHStepList_EstEpStepDR_"^"
		Set ArrStepDate(EstEpStepDR)=EstStepStaDate_"^"_EstStepEndDate
	}
	Set NHStepList=$e(NHStepList,1,$l(NHStepList)-1)
	Set NHStepCnt=$l(NHStepList,"^")
	Quit:(NHStepList="")!(NHStepCnt<1) ret
	Set ret=-4	// -4 ' Nursing History Item
	Set ItmListNew="",NHItemList=""
	If (EmrName'="") {
		Set NHItemList=$lb(EmrName)
	} Else {
		Set NHItemList=NHItemList_$lb("入院评估单")
		Set NHItemList=NHItemList_$lb("产科入院评估单")
		Set NHItemList=NHItemList_$lb("一般护理记录单")
		Set NHItemList=NHItemList_$lb("骨科护理记录单")
		Set NHItemList=NHItemList_$lb("防范患者压疮评估记录表")
		Set NHItemList=NHItemList_$lb("防范患者跌倒(坠床)评估记录表")
		Set NHItemList=NHItemList_$lb("肺穿观察表")
		Set NHItemList=NHItemList_$lb("造血干细胞移植病人护理记录单")
		Set NHItemList=NHItemList_$lb("危重护理记录单")
		Set NHItemList=NHItemList_$lb("妇科手术患者护理记录单")
		Set NHItemList=NHItemList_$lb("手术病人交接记录单")
		Set NHItemList=NHItemList_$lb("围手术护理记录单")
		Set NHItemList=NHItemList_$lb("日常生活能力评分")
		Set NHItemList=NHItemList_$lb("液体出入量明细")
		Set NHItemList=NHItemList_$lb("血糖监测单")
		Set NHItemList=NHItemList_$lb("特殊血糖监测单")
		Set NHItemList=NHItemList_$lb("巡视记录表")
	}
	For NHStepInd=1:1:NHStepCnt {
		Set NHEpStepID=$p(NHStepList,"^",NHStepInd)
		Set objStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(NHEpStepID)
		Continue:'$IsObject(objStep)
		Set StepDesc=objStep.CPWSDesc
		Set ItemID=0,CPWID=$p(NHEpStepID,"||",1),EpID=$p(NHEpStepID,"||",2),StepID=$p(NHEpStepID,"||",3)
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:(ItemID="")
			Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
			Continue:'$IsObject(objItem)
			Set (SubCategID,SubCategDesc,CategID)=""
			If $IsObject(objItem.CPWSISubCategory) {
				Set SubCategID=objItem.CPWSISubCategory.%Id()
				Set SubCategDesc=objItem.CPWSISubCategory.SISCDesc
				Set:$IsObject(objItem.CPWSISubCategory.SISCParRef) CategID=objItem.CPWSISubCategory.SISCParRef.%Id()
			}
			Continue:(+CategID'=3)!(SubCategID="")!(SubCategDesc'="护理病历")
			Set ItemDesc=objItem.CPWSIDesc
			Continue:$ListFind(NHItemList,ItemDesc)<1
			Set IsMustItem=objItem.CPWSIIsMust	// Y/N
			Continue:(IsMustItem["Y")	// 可选项不提示
			Set ImplItmID=ItemRowID_"-"_NHEpStepID_"-"_SubCategID
			Set ItemImpl=##class(web.DHCCPW.MRC.FormShow).IsItemImpl("ZIndex","JIndex",PathWayID,ImplItmID,"NIndex")
			Continue:(ItemImpl>0)	// 临床路径做过的不提示
			If $d(ArrStepDate(NHEpStepID)) {
				Set EmrStaDate=$p(ArrStepDate(NHEpStepID),"^",1)
				Set EmrEndDate=$p(ArrStepDate(NHEpStepID),"^",2)
			} Else {
				Set EmrStaDate=StaDate
				Set EmrEndDate=EndDate
			}
			Set EmrStatus=..CPWGetEmrStatus(EpisodeID,EmrStaDate,EmrEndDate,ItemDesc)
			//Set EmrStatus=..CPWGetEmrStatus(EpisodeID,StaDate,EndDate,ItemDesc)
			Continue:(EmrStatus>0)	// 护理病历做过的不提示
			Continue:(("^"_ItmListNew)[("^"_ItemDesc_"^"))	// 重复只算一次
			Set ItmListNew=ItmListNew_ItemDesc_"^"
		}
	}
	Set ItmListNew=$e(ItmListNew,1,$l(ItmListNew)-1)
	Set:(ItmListNew'="") ret=1_$c(1)_ItmListNew
	Kill ArrStepDate
	Quit ret
CPWToNursingHistoryErr
	Set ret="-9"_$c(1)_$ZError
	Kill ArrStepDate
	Quit ret
}

/// 护理记录提供临床路径完成情况接口
/// Description:根据开始日期、结束日期、病历单据名称取是否有保存记录
/// Table: Nur.DHCMoudData,Nur.DHCMoudDataSub,Nur.DHCNurseRecParent,Nur.DHCNurseRecSub
/// Input: EpisodeID:就诊号,StDate：开始日期,EdDate:结束日期,EmrName:模版名称
/// Return: 记录表名^记录ID^记录日期^记录时间^记录人,无记录返回空
/// w ##class(web.DHCNUREMR).GetEmrStatus(356,"2014-10-16","2014-10-16","入院评估单")
/// w ##class(web.DHCCPW.MR.Interface).CPWGetEmrStatus("329506","2014-09-10","2014-09-22","")
ClassMethod CPWGetEmrStatus(EpisodeID As %String, StaDate As %String, EndDate As %String, EmrName As %String) As %String
{
	New (EpisodeID,StaDate,EndDate,EmrName)
	Set $zt="CPWGetEmrStatusErr",ret=-1
	Set StaDate=+$s(StaDate["-":$zdh(StaDate,3),StaDate["/":$zdh(StaDate,4),1:StaDate)
	Set EndDate=+$s(EndDate["-":$zdh(EndDate,3),EndDate["/":$zdh(EndDate,4),1:EndDate)
	Quit:(+EpisodeID=0)!(+StaDate=0)!(+EndDate=0)!(EmrName="") ret	// arg err
	Set EmrStatus=##class(web.DHCNUREMR).GetEmrStatus(EpisodeID,StaDate,EndDate,EmrName)
	Set ret=$s(EmrStatus'="":1,1:-2)
	Quit ret
CPWGetEmrStatusErr
	Set ret=-9
	Quit ret
}

/// w ##class(web.DHCCPW.MR.Interface).GetCPWSCode(65)
/// I 入径；O 出径； C 完成路径  空 未入径
ClassMethod GetCPWSCode(aEpisodeID As %String) As %String
{
    New (aEpisodeID)
    Set return=""
    Quit:aEpisodeID="" return
    Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aEpisodeID)
    Quit:MRAdm="" return
    Set xPathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
    Quit:xPathWayID="" return  
    Set obj=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(xPathWayID)
    Quit:'$IsObject(obj) return
    Set return=obj.CPWStatus
    Quit return
}

}
