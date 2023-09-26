Import SQLUser

Class DHCDoc.DHCDocCure.AssScale Extends %RegisteredObject
{

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descritp:   保存评分
/// Input:      mListData-评分内容
/// Ouput:      评分ID
/// w ##Class(DHCDoc.DHCDocCure.AssScale).Insert("4",$lg(^tmpnk("Insert"),2))
ClassMethod Insert(ID As %String, mListData As %String) As %String
{
	s ^tmpnk("Insert")=$lb(ID,mListData)
	i ID="" D
	.s ID=..InsScore(mListData)
	E  D
	.s ID=..UpdScore(ID, mListData)
	Q ID
}

/// Creator: 	nk
/// CreateDate: 2021-06-28
/// Descritp:   取消保存评分
/// Input:      mListData-评分内容
/// Ouput:      评分ID
/// w ##Class(DHCDoc.DHCDocCure.AssScale).Insert("4",$lg(^tmpnk("Insert"),2))
ClassMethod Cancel(ID As %String, mListData As %String) As %String
{
	s ^tmpnk("Insert")=$lb(ID,mListData)
	s EpisodeID=$lg($g(^User.DHCDocCureAssScoreD(ID)),2)
	s OEOrdId=$lg($g(^User.DHCDocCureAssScoreD(ID)),10)
	s DCASStatus=$lg($g(^User.DHCDocCureAssScoreD(ID)),11)
	if DCASStatus'="F"{
		s ErrMsg="未评分,无需撤销"	
		Q "-10^"_ErrMsg
	}
	
	s NCureAdviceNum=##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(EpisodeID,"N","CureAdvise",ID)
	s ACureAdviceNum=##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(EpisodeID,"A","CureAdvise",ID)
	s CureAdviceNum=NCureAdviceNum+ACureAdviceNum
	if +CureAdviceNum>0{
		s ErrMsg="存在建议医嘱,无法撤销"	
		Q "-10^"_ErrMsg
	}
	
	s UserID=$p(mListData,"^",2) 
	
	Ts
	
	s Err=..UpdScoreStat(ID,"A")
	i +Err'=0{
		tro 1
	}
	Q:Err'=0 Err
	
	s OrderStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(+OEOrdId,"I",+$p(OEOrdId,"||",2),1)),"^",13)
	s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	if OrderStatusCode="E"{
		//将对应医嘱撤销执行
		s Err=..DelaWithExec(OEOrdId,UserID,"C",.ErrMsg)
		i Err'=0{
			tro 1
		}
		Q:Err'=0 Err_"^"_ErrMsg
		s Err=##class(appcom.OEOrdItem).Verify(OEOrdId,UserID,"",.ErrMsg) 
		i Err'=0{
			tro 1
		}
		Q:Err'=0 Err_"^"_ErrMsg
	}
	
	Tc
	Q ID
}

ClassMethod UpdScoreStat(ID, Status)
{
	S ErrMsg=""
	Ts
	&SQL(Update DHC_DocCureAssScore set DCAS_ScoreVal=null,DCA_Status=:Status where DCAS_RowID=:ID)
	s Err=SQLCODE
	i Err'=0{
		tro 1
		s ErrMsg="更新评分主表内容失败"
	}
	Q:Err'=0 Err_"^"_ErrMsg
	
	s Err=..DelScoreItem(ID)
	i Err'=0{
		tro 1
		s ErrMsg="删除相关子表内容失败"
	}
	Q:Err'=0 Err_"^"_ErrMsg
	
	Tc
	Q 0
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descritp:   插入评分内容
/// Input:      mListData-评分内容
/// Ouput:      申请单ID
/// w ##Class(DHCDoc.DHCDocCure.AssScale).InsScore("")
ClassMethod InsScore(mListData As %String) As %String
{
	s Err=0
	TS
	/// 插入评分主表
	s ListData=$p(mListData,$C(2),1)
	s ID=..InsScoreBus(ListData)
	i ID<0 tro 1
	Q:ID<0 ID

	/// 插入评分子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsScoreItem(ID, ListData)
	i Err'=0 tro 1
	Q:Err'=0 "-11"

	TC
	Q ID
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descritp:   更新评分内容
/// Input:      mListData-评分内容
/// Ouput:      申请单ID
/// w ##Class(DHCDoc.DHCDocCure.AssScale).UpdScore("")
ClassMethod UpdScore(ID As %String, mListData As %String, ByRef ErrMsg As %String = "") As %String
{
	s Err=0
	
	s EpisodeID=$lg($g(^User.DHCDocCureAssScoreD(ID)),2)
	s OEOrdId=$lg($g(^User.DHCDocCureAssScoreD(ID)),10)
	s ListData=$p(mListData,$C(2),1)
	s UserID=$p(ListData,"^",2) 
	//事前判断 门诊是否收费
	s myrtn=##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType(EpisodeID,OEOrdId)
	if ("^1081^1082^")[("^"_myrtn_"^"){
		s ErrMsg="患者就诊状态异常,不能进行评定,请核实!"
		q "-10"_"^"_ErrMsg
	}elseif myrtn="108"{
		s ErrMsg="医嘱未缴费,不能进行评定!"
		q "-10"_"^"_ErrMsg
	}
		
	TS

	/// 插入评分主表
	s Err=..UpdScoreBus(ID,ListData)
	i Err'=0{
		tro 1
		s ErrMsg="插入评分主表失败"
	}
	Q:Err'=0 "-11"_"^"_ErrMsg
	
	/// 删除相关字表内容重新插入
	s Err=..DelScoreItem(ID)
	i Err'=0{
		tro 1
		s ErrMsg="删除相关子表内容失败"
	}
	Q:Err'=0 "-12"_"^"_ErrMsg
	
	/// 插入评分子表
	s ListData=$p(mListData,$C(2),2)
	s Err=..InsScoreItem(ID, ListData)
	i Err'=0{
		tro 1
		s ErrMsg="插入评分子表失败"_"^"_ErrMsg
	}
	Q:Err'=0 "-13"_"^"_ErrMsg
	
	s OrderStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(+OEOrdId,"I",+$p(OEOrdId,"||",2),1)),"^",13)
	s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	if OrderStatusCode="V"{
		s Err=..DelaWithExec(OEOrdId,UserID,"E",.ErrMsg)
		i Err'=0{
			tro 1
		}
		Q:Err'=0 "-14"_"^"_ErrMsg
		
		s Err=##class(appcom.OEOrdItem).Execute(OEOrdId,UserID,"",.ErrMsg) 
		i Err'=0{
			tro 1
		}
		Q:Err'=0 "-15"_"^"_ErrMsg
	}

	TC
	Q ID
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descript: 	插入评分主表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(DHCDoc.DHCDocCure.AssScale).InsScoreBus("")
ClassMethod InsScoreBus(mListData As %String) As %String
{
	s EpisodeID=$p(mListData,"^",1)  /// EpisodeID
	s UserID=$p(mListData,"^",2)     /// 创建人
	s Type=$p(mListData,"^",3)       /// 业务类型
	s AssScaleID=$p(mListData,"^",4)    /// 评分表ID
	s ScoreVal=$p(mListData,"^",5)   /// 分值
	s CreateDate=+$H   		         /// 创建日期
	s CreateTime=$p($H,",",2)        /// 创建时间
	s PatientID=$P($G(^PAADM(EpisodeID)),"^",1)
	
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=PatientID
	s PLIST(4)=CreateDate
	s PLIST(5)=CreateTime
	s PLIST(6)=UserID
	s PLIST(7)=Type
	s PLIST(8)=AssScaleID
	s PLIST(9)=ScoreVal
	s PLIST(11)="F"
	s PLIST(12)=UserID
	&sql(insert into SQLUser.DHC_DocCureAssScore values :PLIST())
	;&SQL(Insert Into DHC_DocCureAssScore(DCAS_Adm_Dr,DCAS_Patient_Dr,DCAS_User_Dr,DCAS_Date,DCAS_Time,DCAS_Type,DCAS_AssScale_DR,DCAS_ScoreVal,DCA_Status)
	;	values(:EpisodeID,:PatientID,:UserID,:CreateDate,:CreateTime,:Type,:AssScaleID,:ScoreVal,"F"))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descript: 	更新评分主表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(DHCDoc.DHCDocCure.AssScale).UpdScoreBus("")
ClassMethod UpdScoreBus(ID As %String, mListData As %String) As %String
{
	s EpisodeID=$p(mListData,"^",1)  /// EpisodeID
	s UserID=$p(mListData,"^",2)     /// 更新人
	s Type=$p(mListData,"^",3)       /// 业务类型
	s ScoreID=$p(mListData,"^",4)    /// 评分表ID
	s ScoreVal=$p(mListData,"^",5)   /// 分值
	&SQL(Update DHC_DocCureAssScore set DCAS_ScoreVal=:ScoreVal,DCA_Status="F",DCAS_UpdateUser_Dr=:UserID where DCAS_RowID=:ID)
	Q SQLCODE
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descript: 	插入评分子表
/// Input:      EpisodeID - 就诊ID
/// Output: 	
/// W ##Class(DHCDoc.DHCDocCure.AssScale).InsScoreItem("")
ClassMethod InsScoreItem(arParref As %String, mListData As %String) As %String
{
	s Len = $L(mListData,"@")
	s quitflag=0
	F i=1:1:Len Q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i)  /// 项目列表
	.s key=$p(ListData,"^",1)        /// 元素ID
	.s Tex=$p(ListData,"^",2)        /// 元素值
	.s Type=$p(ListData,"^",3)       /// 元素类型
	.if Type="datebox" d
	..s Tex=##class(websys.Conversions).DateHtmlToLogical(Tex)
	.&SQL(Insert Into DHC_DocCureAssScoreForm(DCASF_ParRef_Dr,DCASF_key,DCASF_val,DCASF_Type)
		values(:arParref,:key,:Tex,:Type))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

ClassMethod DelaWithExec(OrdItmRowId As %String, UserRowId As %String, ExStatCode As %String, ByRef ErrMsg As %String = "")
{
	s err=0
	s NewExecStatCode=$case(ExStatCode,"E":"F",:"C")
	s err=##class(appcom.OEOrdExec).DelaWithExecAll(OrdItmRowId,UserRowId,NewExecStatCode)
	if err {
		s ErrMsg=##Class(web.DHCDocErrCodeRegister).GetErrCodeMsg("appcom.OEOrdItem",err)
	}
	Q err
}

/// Creator: 	 nk
/// CreateDate:  2021-05-28
/// Descript:    删除评分子表
/// Input:       EpisodeID - 就诊ID
/// Output: 
/// w ##Class(DHCDoc.DHCDocCure.AssScale).DelScoreItem("24")
ClassMethod DelScoreItem(ID As %String) As %String
{
	&SQL(delete from DHC_DocCureAssScoreForm where DCASF_ParRef_Dr=:ID)
	if SQLCODE=100 s SQLCODE=0
	Q SQLCODE
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descript:   取评分数据
/// w ##Class(DHCDoc.DHCDocCure.AssScale).JsGetFormScore(5)
ClassMethod JsGetFormScore(ID As %String) As %String
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s del=""""
	d Stream.Write("{")
	s Score=$lg(^User.DHCDocCureAssScoreD(ID),9)       /// 分值
	if Score="" s Score="0"
	d Stream.Write(del_"Score"_del_":"_Score)
	d Stream.Write(",""items"":")
	
	s ListTitle="key^val^type"
	d Stream.Write("[")
	s Num=0
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub))
		Q:ChildSub=""
		s key=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),2)
		s val=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),3)
		s type=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),4)
		if type="datebox"{
			s val=##class(websys.Conversions).DateLogicalToHtml(val)
		}
		s ListData=key_"^"_val_"^"_type
		s Num=Num+1
		i Num=1{
			d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}else{
			d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}
	}
	
	d Stream.Write("]")
	d Stream.Write("}")
	Q Stream.Read()
}

/// Creator: 	nk
/// CreateDate: 2021-05-28
/// Descript:   取评分数据
/// w ##Class(DHCDoc.DHCDocCure.AssScale).JsGetFormItem(170)
ClassMethod JsGetFormItem(ID As %String) As %String
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="key^val^type"
	d Stream.Write("[")
	s Num=0
	s ChildSub=""
	for{
		s ChildSub=$o(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub))
		Q:ChildSub=""
		s key=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),2)
		s val=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),3)
		s type=$lg(^User.DHCDocCureAssScoreD(ID,"ChildDHCDocCureAssScoreForm",ChildSub),4)
		s ListData=key_"^"_val_"^"_type
		s Num=Num+1
		i Num=1{
			d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}else{
			d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}
	}
	d Stream.Write("]")
	Q Stream.Read()
}

/// CreateDate: 2021-05-21
/// Descript:   取评分数据
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.AssScale","QryAssScoreList","2021-05-28","2021-06-02","","","","13229^90^2")
/// Descript:查询评定量表
Query QryAssScoreList(StartDate As %String = "", EndDate As %String = "", PAAdmID As %String = "", PatientID As %String = "", CheckAdmType As %String = "", Status As %String = "", SessionExpID As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,PAAdmType:%String,PAAdmLoc:%String,PatNo:%String,PatName:%String,PatInfo:%String,Date:%String,Time:%String,User:%String,Type:%String,AssScaleID:%String,AssScaleDesc:%String,ScoreVal:%String,DCASOEORIDR:%String,OrderBilled:%String,DCASStatus:%String")
{
}

ClassMethod QryAssScoreListExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", PAAdmID As %String = "", PatientID As %String = "", CheckAdmType As %String = "", Status As %String = "", SessionExpID As %String = "", ExpStr As %String = "") As %Status
{
	s ind=0
	s DateFormat=##class(websys.Conversions).DateFormat()
	if StartDate'="" s StartDate=$zdh(StartDate,DateFormat)
	if EndDate'="" s EndDate=$zdh(EndDate,DateFormat)
	s LogUserID=$p(SessionExpID,"^",1)
	s LogLocID=$p(SessionExpID,"^",2)
	s LogHospID=$p(SessionExpID,"^",3)
	s langid=$p(SessionExpID,"^",4)
	if $d(%session){
		s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
		s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
		s:LogHospID="" LogHospID=%session.Get("LOGON.HOSPID")
		s:langid="" langid=%session.Get("LOGON.LANGID")
	}
	s cspName=""
	if ExpStr'=""{
		s cspName=$p(ExpStr,"^",1)	
	}
	
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	if PAAdmID'=""{
		s DCASRowId=""
		for{
			s DCASRowId=$o(^User.DHCDocCureAssScoreI("DCASAdmDrIndex",PAAdmID,DCASRowId))
			Q:DCASRowId=""
			d GetAssScale
			s QuitFlag=$$CheckQuit()
			continue:QuitFlag=1
			d OutputAssScale
		}
		Quit $$$OK
	}elseif PatientID'=""{
		s DCASRowId=""
		for{
			s DCASRowId=$o(^User.DHCDocCureAssScoreI("DCASPatientDrIndex",PatientID,DCASRowId))
			Q:DCASRowId=""
			d GetAssScale
			s QuitFlag=$$CheckQuit()
			continue:QuitFlag=1
			d OutputAssScale
		}	
		Quit $$$OK
	}else{
		s:StartDate="" StartDate=+$h
		s:EndDate="" EndDate=+$h
		for QueryDate=StartDate:1:EndDate{
			for looploc=1:1:$l(LogLocIDStr,"^"){
				s LogLocID=$p(LogLocIDStr,"^",looploc)
				s OrderPar=""
				for{
					s OrderPar=$o(^OEORDi(0,"RecDepStartDateTime",LogLocID,QueryDate,OrderPar))	
					Q:OrderPar=""
					s OrderChild=""
					for{
						s OrderChild=$o(^OEORDi(0,"RecDepStartDateTime",LogLocID,QueryDate,OrderPar,OrderChild))	
						Q:OrderChild=""
						s OrderRowID=OrderPar_"||"_OrderChild
						s DCASRowId=$o(^User.DHCDocCureAssScoreI("DCASOEORIDRIndex",OrderRowID,""))	
						continue:DCASRowId=""
						d GetAssScale
						s QuitFlag=$$CheckQuit()
						continue:QuitFlag=1
						d OutputAssScale
					}
				}
			}
		}	
	}
	Quit $$$OK
GetAssScale
	s Data=$g(^User.DHCDocCureAssScoreD(DCASRowId))
	s DCASAdmDr=$lg(Data,2)
	s DCASPatientDr=$lg(Data,3)
	s DCASDate=$lg(Data,4)
	s DCASTime=$lg(Data,5)
	s DCASUserDr=$lg(Data,6)
	s DCASType=$lg(Data,7)
	s DCASAssScaleDR=$lg(Data,8)
	s DCASScoreVal=$lg(Data,9)
	s DCASOEORIDR=$lg(Data,10)
	s DCASStatus=$lg(Data,11)
	Quit
CheckQuit()
	s QuitFlag=1
	if (DCASAdmDr="")!(DCASOEORIDR=""){
		Q QuitFlag
	}
	if (Status'="ALL")&&(DCASStatus="C"){
		Q QuitFlag
	}
	s AdmLocId=$P(^PAADM(DCASAdmDr),"^",4)
	if (StartDate'="")&&(DCASDate<StartDate){
		Q QuitFlag
	}
	if (EndDate'="")&&(DCASDate>EndDate){
		Q QuitFlag
	}
	s AdmType=$P(^PAADM(DCASAdmDr),"^",2)
	Q:(((CheckAdmType="I")&&(AdmType'=CheckAdmType))!((CheckAdmType="O")&&(AdmType="I"))) QuitFlag
	
	Set OrdReLocId=$p($g(^OEORD(+DCASOEORIDR,"I",$p(DCASOEORIDR,"||",2),3)),"^",6)
	Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_OrdReLocId_"^")) QuitFlag

	q 0 
OutputAssScale
	Set PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(DCASPatientDr)
	set PatNo=##Class(web.PAPatMas).GetRegistration(DCASPatientDr)
	set PatName=$P($G(^PAPER(DCASPatientDr,"ALL")),"^",1)
	set PatSex=$P(PatientInfo,"^",4)
	set PatAge=$P(PatientInfo,"^",5)
	set PatInfo=PatSex_" "_PatAge
	set DCASDate=##Class(websys.Conversions).DateLogicalToHtml(DCASDate)
	set DCASTime=$zt(DCASTime,2)
	set DCASUser=""
	set:DCASUserDr'="" DCASUser=$p(^SSU("SSUSR",DCASUserDr),"^",2)
	Set DCASUser = ##class(User.SSUser).GetTranByDesc("SSUSRName",DCASUser,langid)
	set AssScale=##class(DHCDoc.DHCDocCure.AssScaleConfig).GetAssScale(DCASAssScaleDR)
	set DCASAssScaleDesc=$p(AssScale,"^",3)
	set AdmType=$P($G(^PAADM(DCASAdmDr)),"^",2)
	set AdmLoc=""
	set AdmLocID=$P($G(^PAADM(DCASAdmDr)),"^",4)
	set:AdmLocID'="" AdmLoc=$P($G(^CTLOC(AdmLocID)),"^",2)
	Set AdmLoc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLoc,langid)
	Set PAAdmType=$case(AdmType,
	"O":##class(websys.Translation).Get(cspName,"门诊"),
	"E":##class(websys.Translation).Get(cspName,"急诊"),
	"I":##class(websys.Translation).Get(cspName,"住院"),
	:##class(websys.Translation).Get(cspName,"其他"))
	set OrderBilled=##class(DHCDoc.DHCDocCure.Apply).GetOrderBilled(DCASOEORIDR)
	Set OrderBilled=##class(websys.Translation).Get(cspName,OrderBilled)
	set Data=$lb(DCASRowId,DCASAdmDr,PAAdmType,AdmLoc,PatNo,PatName,PatInfo,DCASDate,DCASTime,DCASUser,DCASType,DCASAssScaleDR,DCASAssScaleDesc,DCASScoreVal,DCASOEORIDR,OrderBilled,DCASStatus)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QryAssScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssScoreListExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetAssScoreInfo(AssScoreID)
{
	set Data=$g(^User.DHCDocCureAssScoreD(AssScoreID))
	Q:Data="" ""
	set DCASAdmDr=$lg(Data,2)
	set DCASPatientDr=$lg(Data,3)
	set DCASDate=$lg(Data,4)
	set DCASTime=$lg(Data,5)
	set DCASUserDr=$lg(Data,6)
	set DCASType=$lg(Data,7)
	set DCASAssScaleDR=$lg(Data,8)
	set DCASScoreVal=$lg(Data,9)
	set DCASOEORIDR=$lg(Data,10)
	set DCASStatus=$lg(Data,11)
	
	set DCASDate=##Class(websys.Conversions).DateLogicalToHtml(DCASDate)
	set DCASTime=$zt(DCASTime,2)
	set DCASUser=""
	set:DCASUserDr'="" DCASUser=$p(^SSU("SSUSR",DCASUserDr),"^",2)
	set AssScale=##class(DHCDoc.DHCDocCure.AssScaleConfig).GetAssScale(DCASAssScaleDR)
	set DCASAssScaleDesc=$p(AssScale,"^",3)
	set Info=DCASAdmDr_"^"_DCASPatientDr_"^"_DCASDate_"^"_DCASTime_"^"_DCASUserDr
	set Info=Info_"^"_DCASUser_"^"_DCASType_"^"_DCASAssScaleDR_"^"_DCASAssScaleDesc_"^"_DCASScoreVal
	set Info=Info_"^"_DCASOEORIDR_"^"_DCASStatus
	Q Info
}

/// Creator: 	nk
/// CreateDate: 2021-06-03
/// Descript:   取往期同评定量表的评分数据
/// w ##Class(DHCDoc.DHCDocCure.AssScale).GetAssScoreList(6)
ClassMethod GetAssScoreList(AssScoreID As %String, SessionExpID As %String = "", ExpStr As %String = "") As %String
{
	s cspName=""
	if ExpStr'=""{
		s cspName=$p(ExpStr,"^",1)	
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	
	if AssScoreID=""{
		d Stream.Write("]")
		Q Stream.Read()	
	}
	s Data=$g(^User.DHCDocCureAssScoreD(AssScoreID))
	s DCASPatientDr=$lg(Data,3)
	s DCASAssScaleDR=$lg(Data,8)
	s ListTitle="id^text^selected"
	
	s Num=0
	s PAAdmID="",CheckAdmType=""
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.AssScale:QryAssScoreList")
	d rset.Execute("","", PAAdmID, DCASPatientDr, CheckAdmType, "",SessionExpID,ExpStr)
	While (rset.Next()) {
		;ID:%String,EpisodeID:%String,PAAdmType:%String,PAAdmLoc:%String,PatNo:%String,PatName:%String,PatInfo:%String,Date:%String,Time:%String,User:%String,Type:%String,AssScaleID:%String,AssScaleDesc:%String,ScoreVal:%String,DCASOEORIDR:%String,OrderBilled:%String
		s ID=rset.Data("ID")
		s AssScaleID=rset.Data("AssScaleID")
		continue:AssScaleID'=DCASAssScaleDR
		s ScoreInfo=..GetAssScoreInfo(ID)
		s selected=0
		if ID=AssScoreID s selected=1
		s DCASDate=$p(ScoreInfo,"^",3)
		s DCASTime=$p(ScoreInfo,"^",4)
		s DCASScoreVal=$p(ScoreInfo,"^",10)
		s DCASStatus=$p(ScoreInfo,"^",12)
		s DCASScoreVal=$case(DCASScoreVal,
		"":##class(websys.Translation).Get(cspName,"未评"),
		:DCASScoreVal_##class(websys.Translation).Get(cspName,"分"))
		s:DCASStatus="C" DCASScoreVal=##class(websys.Translation).Get(cspName,"已取消")
		s ScoreLabel=DCASDate_"("_DCASScoreVal_")"
		s ListData=ID_"^"_ScoreLabel_"^"_selected
		s Num=Num+1
		i Num=1{
			d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}else{
			d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData))
		}
	}
	
	d Stream.Write("]")
	Q Stream.Read()
}

ClassMethod GetCAImage(RowId)
{
    s CAImageStr="",Base64Str=""
    s DCASStatus=$lg(^User.DHCDocCureAssScoreD(RowId),11) 
    s DCASUserDr=$lg(^User.DHCDocCureAssScoreD(RowId),12)
    Q:(DCASStatus'="F")!(DCASUserDr="") ""
    s Base64Str=##class(web.DHCDocSignVerify).GetImageByUserID(DCASUserDr)
    i Base64Str'=""{
        s Base64Str="data:image/jpg;base64,"_Base64Str
        s CAImageStr=Base64Str
    }
    Q CAImageStr
}

}
