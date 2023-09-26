Import sqluser

/// Descript:   药学咨询
/// Creator:    bianshuai
/// CreateDate: 2016-02-02
Class web.DHCSTPHCMCONSULT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存(更新)药学咨询
/// w ##class(web.DHCSTPHCMCONSULT).SaveConsult("","16243032||127||869||A||1.骨折,2.骨折||New||hello||21679^1||1.1||1.2^aa^aa^cc^dd^ee^ff^16149701||14,16149701||15")
ClassMethod SaveConsult(consultID As %String, conDataList As %String) As %String
{
	n (consultID,conDataList)
	s consName=$p(conDataList,"^",1)   //姓名
	s consTele=$p(conDataList,"^",2)   //联系电话
	s consIden=$p(conDataList,"^",3)   //咨询身份
	s consType=$p(conDataList,"^",4)   //问题类型
	s consDept=$p(conDataList,"^",5)   //咨询部门
	s consDesc=$p(conDataList,"^",6)   //咨询描述
	s consTypeCode=$p(conDataList,"^",8) //咨询类型
	s ret=0
	i consultID="" d
	.S ret=..Insert(consName,consTele,consIden,consType,consDept,consDesc,consTypeCode,"")
	e  d
	.S ret=..Update(consultID,consName,consTele,consIden,consType,consDept,consDesc,"")
	q ret
}

/// Descript:药学咨询
ClassMethod Insert(consName, consTele, consIden, consType, consDept, consDesc, consTypeCode, consDrgItmList) As %String
{
	N (consName, consTele, consIden, consType, consDept, consDesc, consTypeCode, consDrgItmList)
	s Err=0

	TS
	//药学咨询主表
	s consultID=..InsConsult(consName, consTele, consIden, consType, consDept, consDesc, consTypeCode)
	i consultID<0 tro
	q:consultID<0 consultID

	//临床药学问题询药品组合
	i consDrgItmList'="" d
	.s Err=..InsConsultItm(consultID, consDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	TC
	Q 0
}

/// Descript:药学查房
ClassMethod Update(consultID, consName, consTele, consIden, consType, consDept, consDesc, consDrgItmList) As %String
{
	N (consultID, consName, consTele, consIden, consType, consDept, consDesc, consDrgItmList)
	s Err=0

	TS
	//药学咨询主表 
	s Err=..UpdConsult(consultID, consName, consTele, consIden, consType, consDept, consDesc)
	i Err'=0 tro
	q:Err'=0 "-10"

	//删除相关子表
	s Err=..DelConsRelTab(consultID)
	i Err'=0 tro
	q:Err'=0 Err
	
	//临床药学问题询药品组合
	i consDrgItmList'="" d
	.s Err=..InsConsultItm(consultID, consDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-11"

	TC
	Q 0
}

/// Descript:插入药学咨询信息
ClassMethod InsConsult(consName, consTele, consIden, consType, consDept, consDesc, consTypeCode) As %String
{
	N (consName, consTele, consIden, consType, consDept, consDesc, consTypeCode)
	S consDate=+$H                       //记录日期
	S consTime=$p($H,",",2)              //记录日期
	s consTypeID=##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode(consTypeCode)
	
	&SQL(Insert Into DHC_PHConsult(PHCON_Date,PHCON_Time,PHCON_User_Dr,PHCON_Loc_Dr,PHCON_Desc,PHCON_QEType_Dr,PHCON_UserType,PHCON_ContactNum,PHCON_Type_Dr) 
		Values(:consDate,:consTime,:consName,:consDept,:consDesc,:consType,:consIden,:consTele,:consTypeID))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新药学咨询信息
ClassMethod UpdConsult(consultID, consName, consTele, consIden, consType, consDept, consDesc) As %String
{
	N (consultID, consName, consTele, consIden, consType, consDept, consDesc)
	
	&SQL(Update DHC_PHConsult Set PHCON_User_Dr=:consName,PHCON_Loc_Dr=:consDept,PHCON_Desc=:consDesc,PHCON_QEType_Dr=:consType,
		PHCON_UserType=:consIden,PHCON_ContactNum=:consTele Where PHCON_RowID=:consultID)
	Q SQLCODE
}

/// Descript:临床药学问题询药品
ClassMethod InsConsultItm(consultID As %String, consDrgItmList As %String) As %String
{
	N (consultID,consDrgItmList)
	S Len=$L(consDrgItmList,"!!")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S ItemInfoList=$p(consDrgItmList,"!!",i)
	.S consPhcDrgID="" //$p(ItemInfoList,"^",i)
	.S consGoodsName=$p(ItemInfoList,"^",1)
	.S consSpec=$p(ItemInfoList,"^",2)
	.S consForm=$p(ItemInfoList,"^",3)
	.S consManf=$p(ItemInfoList,"^",4)
	.S consInstruc=$p(ItemInfoList,"^",5)
	.S consDosage=$p(ItemInfoList,"^",6)
	.S consDuration=$p(ItemInfoList,"^",7)
	.S childSub=$o(^DHCPHCONI(consultID,"D",""),-1)+1
	.&SQL(Insert into DHC_PHConsultItm(PHCONI_ParRef_Dr,PHCONI_ChildSub,PHCONI_Drug_Dr,PHCONI_GoodsName,
		PHCONI_Spec,PHCONI_Form,PHCONI_Manf,PHCONI_Instruc,PHCONI_Dosage,PHCONI_Duration)
		Values(:consultID,:childSub,:consPhcDrgID,:consGoodsName,:consSpec,:consForm,
			:consManf,:consInstruc,:consDosage,:consDuration))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript: 删除药学咨询相关信息表
/// w ##class(web.DHCSTPHCMCONSULT).DelConsRelTab("11")
ClassMethod DelConsRelTab(consultID As %String) As %String
{
	N (consultID)
	S SQLCODE=0
	//临床药学问题询药品组合
	i $d(^DHCPHCONI(consultID,"D",1)) D
	.&SQL(delete from DHC_PHConsultItm where PHCONI_ParRef_Dr=:consultID)
	Q:SQLCODE'=0 SQLCODE	
	Q 0
}

/// Descript:保存(更新)药学咨询明细
/// w ##class(web.DHCSTPHCMCONSULT).SaveConsultDetail("14","2812^ASASA^")
ClassMethod SaveConsultDetail(consultID As %String, conDataList As %String) As %String
{
	n (consultID,conDataList)
	s consUserID=$p(conDataList,"^",1)  //用户ID
	s consDesc=$p(conDataList,"^",2)    //咨询描述
	s lkConDetID=$p(conDataList,"^",3)  //关联回复ID
		
	s finishFlag = $p(^DHCPHCONS(consultID), "^", 7)
	q:finishFlag="Y" "-1^已完成的记录不可以再回复！"
	s ret=..InsertConDet(consultID,consUserID,consDesc,lkConDetID)
	q ret
}

/// Descript:插入药学咨询信息
ClassMethod InsertConDet(consultID, consUserID, consDesc, lkConDetID) As %String
{
	N (consultID, consUserID, consDesc, lkConDetID)
	s flag=0          //nisijia 2016-10-10
	s LastChildSub=$o(^DHCPHCOND(consultID,"I",""),-1) 	//nisijia 2016-10-10    
 	i LastChildSub'="" d	//nisijia 2016-10-10
	.s OldconDesc=$p(^DHCPHCOND(consultID,"I",LastChildSub),"^",4) 	//nisijia 2016-10-10  
	.s:OldconDesc=consDesc flag=1	//nisijia 2016-10-10
		
	q:flag=1 0	//nisijia 2016-10-10
	S consDate=+$H               
	S consTime=$p($H,",",2)              //记录日期
	S childSub=$o(^DHCPHCOND(consultID,"I",""),-1)+1
		
	&SQL(Insert Into DHC_PHConsultDetail(PHCONTD_CON_ParRef,PHCONTD_ChildSub,PHCONTD_Date,PHCONTD_Time,PHCONTD_User_Dr,PHCONTD_Desc,PHCONTD_Cont_Dr) 
		Values(:consultID,:childSub,:consDate,:consTime,:consUserID,:consDesc,:lkConDetID))
	Q SQLCODE
}

/// Descript:更新药学咨询信息
ClassMethod UpdateConDet(consultItmID, consDesc) As %String
{
	N (consultItmID, consDesc)		
	&SQL(Update DHC_PHConsultDetail Set PHCONTD_Desc =:consDesc where PHCONTD_RowID=:consultItmID)
	Q SQLCODE
}

/// Descript:删除药学咨询信息
ClassMethod DConsultDetail(consultID) As %String
{
	N (consultID)		
	&SQL(delete DHC_PHConsultDetail where PHCONTD_CON_ParRef=:consultID)
	Q SQLCODE
}

/// Descript: 设置采纳意见状态值
/// w ##class(web.DHCSTPHCMCONSULT).saveAdoptConsult("14||1","N")
ClassMethod saveAdoptConsult(consItmID, consOkFlag) As %String
{
	N (consItmID,consOkFlag)
	&SQL(Update DHC_PHConsultDetail Set PHCONTD_OkFlag=:consOkFlag Where PHCONTD_RowID=:consItmID)
	Q SQLCODE
}

/// Descript: 设置采纳意见状态值
/// w ##class(web.DHCSTPHCMCONSULT).setConsultComplete("14","N")
ClassMethod setConsultComplete(consultID, consComFlag) As %String
{
	N (consultID,consComFlag)
	&SQL(Update DHC_PHConsult Set PHCON_FinishFlag=:consComFlag Where PHCON_RowID=:consultID)
	Q SQLCODE
}

/// Descript:保存(更新)药学咨询
/// w ##class(web.DHCSTPHCMCONSULT).SavePatConsult("","16243032||127||869||A||1.骨折,2.骨折||New||hello||21679^1||1.1||1.2^aa^aa^cc^dd^ee^ff^16149701||14,16149701||15")
ClassMethod SavePatConsult(consultID As %String, consDataList As %String, consDrgItmList As %String) As %String
{
	n (consultID,consDataList,consDrgItmList)
	s ret=0
	i consultID="" d
	.S consultID=..InsertPatConsult(consDataList, consDrgItmList)
	.i consultID>0
	.s ret=0
	e  d
	.S ret=..UpdatePatConsult(consultID, consDataList, consDrgItmList)
	
	// 发送消息到平台
	i ret = 0 d	
	.s Context = "药学咨询："_$p(consDataList,"^",12)
	.s ActionCode = "1198"
	.s FrmUser = $p(consDataList, "^", 20)
	.s EpisodeId = ""
	.s OrdItm = ""
	.s linkUrl = "dhcpha.clinical.replyconsult.csp?consultID="_consultID
	.s OtherPara = {}.%Set("link", linkUrl).%ToJSON()
	.s consDept = $p(consDataList,"^",22)
	.s hospID = $p($g(^CTLOC(+consDept)), "^", 22)
	.s ToUser = ""	//##class(web.DHCSTPHCMCONSULT).GetClinicalUsers(hospID) 
	.s msgRet = ##class(websys.DHCMessageInterface).Send(Context,ActionCode,FrmUser,EpisodeId,OrdItm,ToUser,OtherPara)
	
	q ret
}

/// Descript:药学咨询
ClassMethod InsertPatConsult(consDataList, consDrgItmList) As %String
{
	N (consDataList, consDrgItmList)
	s Err=0

	TS
	//药学咨询主表
	s consultID=..InsPatConsult(consDataList)
	i consultID<0 tro
	q:consultID<0 consultID

	//临床药学问题询药品组合
	i consDrgItmList'="" d
	.s Err=..InsConsultItm(consultID, consDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	s Err=..SaveConsDetail(consultID, consDataList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	TC
	Q consultID
}

/// Descript:药学咨询
ClassMethod UpdatePatConsult(consultID, consDataList, consDrgItmList) As %String
{
	N (consultID, consDataList, consDrgItmList)
	s Err=0

	TS
	//药学咨询主表 
	s Err=..UpdPatConsult(consultID, consDataList)
	i Err'=0 tro
	q:Err'=0 "-10"

	//删除相关子表
	s Err=..DelConsRelTab(consultID)
	i Err'=0 tro
	q:Err'=0 Err
		
	//临床药学问题询药品组合
	i consDrgItmList'="" d
	.s Err=..InsConsultItm(consultID, consDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	s Err=..SaveConsDetail(consultID, consDataList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	TC
	Q 0
}

/// Descript:插入药学咨询信息
ClassMethod InsPatConsult(consDataList) As %String
{
	N (consDataList)
	
	s consPatientID=$p(consDataList,"^",1) //病人ID
	s consPatName=$p(consDataList,"^",2)   //患者姓名
	s consPatSex=$p(consDataList,"^",3)    //性别
	s consPatAge=$p(consDataList,"^",4)    //年龄
	s consContact=$p(consDataList,"^",5)   //联系方式
	s consSpeCrowd=$p(consDataList,"^",6)  //特殊人群
	s consType=$p(consDataList,"^",7)      //问题类型
	s consDiagDesc=$p(consDataList,"^",8)  //诊断信息
	s consWays=$p(consDataList,"^",9)      //咨询方式
	s consRefMat=$p(consDataList,"^",10)   //参考资料
	s consDuration=$p(consDataList,"^",11) //服务时间
	s consQusDesc=$p(consDataList,"^",12)  //问题描述
	s consTraArc=$p(consDataList,"^",14)   //追踪建档
	s consResDept=$p(consDataList,"^",15)  //预约科室
	s consTipLimt=$p(consDataList,"^",16)  //提示期限
	s:consTipLimt'="" consTipLimt=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(consTipLimt) ;$zdh(consTipLimt,3)
	s consTraWay=$p(consDataList,"^",17)   //追踪方式
	s consAnsUser=$p(consDataList,"^",18)  //回答人员
	s consTraRes=$p(consDataList,"^",19)   //追踪结果
	s consLgUserID=$p(consDataList,"^",20) //咨询/记录人
	s consIden=$p(consDataList,"^",21)     //咨询身份
	S:consIden="" consIden="5"  		   //咨询身份 1.医生 2.护士 3.技师 4.药师 5.患者
	s consDept=$p(consDataList,"^",22) 	   //咨询部门
	s consTypeCode=$p(consDataList,"^",23) //咨询类型
	s hospId=$p(consDataList,"^",24)
	s consPatAdmID=##class(web.DHCSTPHCMCOMMON).GetLastAdm(consPatientID,hospId)
	s consDate=+$H                         //记录日期
	s consTime=$p($H,",",2)                //记录日期
	s consTypeID=##Class(web.DHCSTPHCMCONSULTQUERY).GetConsTypeByCode(consTypeCode)
	
	&SQL(Insert Into DHC_PHConsult(PHCON_Date,PHCON_Time,PHCON_User_Dr,PHCON_Desc,PHCON_QEType_Dr,PHCON_UserType,PHCON_ContactNum,PHCON_PAPMI_DR,PHCON_Adm_Dr,PHCON_PatName,
		PHCON_PatSex,PHCON_PatAge,PHCON_PatDiag,PHCON_SpecialCrowd,PHCON_Way,PHCON_RefMat,PHCON_Duration,PHCON_TraArc,PHCON_ResDept,PHCON_TipLimit,PHCON_TraWay,PHCON_AnsUser_Dr,PHCON_TraRes,PHCON_Loc_Dr,PHCON_Type_Dr) 
	Values(:consDate,:consTime,:consLgUserID,:consQusDesc,:consType,:consIden,:consContact,:consPatientID,:consPatAdmID,:consPatName,:consPatSex,:consPatAge,:consDiagDesc,:consSpeCrowd,
		:consWays,:consRefMat,:consDuration,:consTraArc,:consResDept,:consTipLimt,:consTraWay,:consAnsUser,:consTraRes,:consDept,:consTypeID))

	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// w ##class(web.DHCSTPHCMCONSULT).UpdPatConsult("28","14^李乐平^1^25岁^11^^1^1.偏头痛状态^1^2^1^1^111^^^^^^^13809^1^34^PHC")
/// Descript:更新药学咨询信息
ClassMethod UpdPatConsult(consultID, consDataList) As %String
{
	N (consultID, consDataList)
	
	s consPatientID=$p(consDataList,"^",1) //病人ID
	s consPatName=$p(consDataList,"^",2)   //患者姓名
	;s type=""
	;s type=$o(^PAPERdr(consPatientID,"ADM",type),-1)
	;s consPatAdmID=$o(^PAPERdr(consPatientID,"ADM","I",""),-1)
	s consPatSex=$p(consDataList,"^",3)    //性别
	s consPatAge=$p(consDataList,"^",4)    //年龄
	s consContact=$p(consDataList,"^",5)   //联系方式
	s consSpeCrowd=$p(consDataList,"^",6)  //特殊人群
	s consType=$p(consDataList,"^",7)      //问题类型
	s consDiagDesc=$p(consDataList,"^",8)  //诊断信息
	s consWays=$p(consDataList,"^",9)      //咨询方式
	s consRefMat=$p(consDataList,"^",10)   //参考资料
	s consDuration=$p(consDataList,"^",11) //服务时间
	s consQusDesc=$p(consDataList,"^",12)  //问题描述
	s consTraArc=$p(consDataList,"^",14)   //追踪建档
	s consResDept=$p(consDataList,"^",15)  //预约科室
	s consTipLimt=$p(consDataList,"^",16)  //提示期限
	s:consTipLimt'="" consTipLimt=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(consTipLimt) ;$zdh(consTipLimt,3)
	s consTraWay=$p(consDataList,"^",17)   //追踪方式
	s consAnsUser=$p(consDataList,"^",18)  //回答人员
	s consTraRes=$p(consDataList,"^",19)   //追踪结果
	s consIden=$p(consDataList,"^",21)     //咨询身份
	S:consIden="" consIden="5"  		   //咨询身份 1.医生 2.护士 3.技师 4.药师 5.患者
	s consDept=$p(consDataList,"^",22) 	   //咨询部门
	s hospId=$p(consDataList,"^",24)
	s consPatAdmID=##class(web.DHCSTPHCMCOMMON).GetLastAdm(consPatientID,hospId)
	&SQL(Update DHC_PHConsult Set PHCON_Desc=:consQusDesc,PHCON_QEType_Dr=:consType,PHCON_ContactNum=:consContact,PHCON_PatSex=:consPatSex,PHCON_PatAge=:consPatAge,
		 PHCON_PatDiag=:consDiagDesc,PHCON_SpecialCrowd=:consSpeCrowd,PHCON_Way=:consWays,PHCON_RefMat=:consRefMat,PHCON_Duration=:consDuration,PHCON_TraArc=:consTraArc,
		 PHCON_ResDept=:consResDept,PHCON_TipLimit=:consTipLimt,PHCON_TraWay=:consTraWay,PHCON_AnsUser_Dr=:consAnsUser,PHCON_TraRes=:consTraRes,PHCON_Loc_Dr=:consDept,
		 PHCON_UserType=:consIden ,PHCON_PAPMI_DR=:consPatientID,PHCON_Adm_Dr=:consPatAdmID,PHCON_PatName=:consPatName Where PHCON_RowID=:consultID)
	Q SQLCODE
}

/// Descript:保存(更新)药学咨询明细
/// w ##class(web.DHCSTPHCMCONSULT).SavePatConsultDetail("14","2812^ASASA^")
ClassMethod SaveConsDetail(consultID As %String, consDataList As %String) As %String
{
	n (consultID,consDataList)
	s consAnsDesc=$p(consDataList,"^",13)  //回答内容
	s consLgUserID=$p(consDataList,"^",20) //回答人员
	s ret=..InsertConDet(consultID,consLgUserID,consAnsDesc,"")
	q ret
}

/// Descript: 问题类型
/// d ##class(web.DHCSTPHCMCONSULT).QueryQuesType()
ClassMethod QueryQuesType()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHCONQT_RowID,PHCONQT_Desc FROM DHC_PHConQueType"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s quesTypeID = result.Data("PHCONQT_RowID")
		s quesTypeDesc = result.Data("PHCONQT_Desc")
		s quesTypeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConQueType","PHCONQTDesc","",quesTypeDesc)
		s tmp=quesTypeID_"^"_quesTypeDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descript: 特殊人群
/// w ##class(web.DHCSTPHCMCONSULT).QueryConSpCrowd()
ClassMethod QueryConSpCrowd()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHConSpCd_RowID,PHConSpCd_Desc FROM DHC_PHConSpCrowd"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ConSpCdID = result.Data("PHConSpCd_RowID")
		s ConSpCdDesc = result.Data("PHConSpCd_Desc")
		s ConSpCdDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConSpCrowd","PHConSpCdDesc","",ConSpCdDesc)
		s tmp=ConSpCdID_"^"_ConSpCdDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descript: 回复依据
/// w ##class(web.DHCSTPHCMCONSULT).QueryConsBasis()
ClassMethod QueryConsBasis()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHCONTB_RowID,PHCONTB_Desc FROM DHC_PHConsultBasis"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ConsBasisID = result.Data("PHCONTB_RowID")
		s ConsBasisDesc = result.Data("PHCONTB_Desc")
		s ConsBasisDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHConsultBasis","PHCONTBDesc","",ConsBasisDesc)
		s tmp=ConsBasisID_"^"_ConsBasisDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

}
