Import SQLUSER

/// Creator：xiongwang
/// CreatDate：2020-10-23
/// Description: 收费应急系统-数据导回
Class BILL.CES.BL.Import Extends %RegisteredObject
{

/// w ##class(BILL.CES.BL.Import).Import(^xiongwang("Import",1),^xiongwang("Import",2))
ClassMethod Import(jsonStr As %String, expStr As %String) As %String
{
	set $ZT="ImportET"
	set ^xiongwang("Import",1)=jsonStr
	set ^xiongwang("Import",2)=expStr
	set terminalNo=$p(expStr,"^",1)
	
	set rtnCode=0
	set rtnMsg=""
	
	;判断终端是否有效
	set myrtn=##class(BILL.CES.COM.ExpLog).CheckIsValid(terminalNo)
	set rtnCode=$p(myrtn,"^",1)
	set rtnMsg=$p(myrtn,"^",2)
	quit:(+rtnCode'=0) myrtn
	
	set json = ##class(%DynamicObject).%New()	
	set json = json.%FromJSON(jsonStr)
	
	;1患者信息
	set patmasAry = json."pa_patmas"
	if ((patmasAry="")||(patmasAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="患者信息不能为空"
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;2就诊信息
	set paadmAry = json."pa_adm"
	if ((paadmAry="")||(paadmAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="就诊信息不能为空"
		set myrtn=rtnCode_"^"_rtnMsg 
	}
	quit:(+rtnCode'=0) myrtn
	;3诊断主表信息
	set mradmAry = json."mr_adm"
	if ((mradmAry="")||(mradmAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="诊断主表信息不能为空"
		set myrtn=rtnCode_"^"_rtnMsg 
	}
	quit:(+rtnCode'=0) myrtn
	;4诊断子表信息
	set mrdiagAry = json."mr_diagnos"
	;5诊断类型信息
	set mrdiagtypeAry = json."mr_diagtype"
	
	
	;6医嘱信息
	set oeorderAry = json."oe_order"
	if ((oeorderAry="")||(oeorderAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="医嘱信息不能为空" 
		set myrtn=rtnCode_"^"_rtnMsg 
	}
	quit:(+rtnCode'=0) myrtn
	;7医嘱明细信息
	set oeorditemAry = json."oe_orditem"
	if ((oeorditemAry="")||(oeorditemAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="医嘱信息不能为空"
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;8发票信息
	set invprtAry = json."dhc_invprt"
	if ((invprtAry="")||(invprtAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="发票信息不能为空" 
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;9支付方式
	set invpaymodeAry = json."dhc_invpaymode"
	if ((invpaymodeAry="")||(invpaymodeAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="支付方式信息不能为空"
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;10账单信息
	set pbAry = json."dhc_patientbill"
	if ((pbAry="")||(pbAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="账单信息不能为空" 
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;11账单医嘱信息
	set pboAry = json."dhc_patbillorder"
	if ((pboAry="")||(pboAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="账单医嘱信息不能为空" 
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	;12账单明细信息
	set pbdAry = json."dhc_patbilldetails"
	if ((pbdAry="")||(pbdAry.%Size()<1)){
		set rtnCode=-1
		set rtnMsg="账单明细信息不能为空" 
		set myrtn=rtnCode_"^"_rtnMsg
	}
	quit:(+rtnCode'=0) myrtn
	set cesId=invprtAry.%Get(0)."PRT_Rowid"
	set invDate=invprtAry.%Get(0)."PRT_Date"
	set invTime=invprtAry.%Get(0)."PRT_Time"
	set invDate=##class(websys.Conversions).DateHtmlToLogical(invDate)
	set invTime=##class(websys.Conversions).TimeHtmlToLogical(invTime, 1)
	set timeStamp=$zd(invDate,8)_$tr($zt(invTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_invprt",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnMsg="已导入成功" 
		set myrtn=rtnCode_"^"_rtnMsg
		quit myrtn
	}
	
	ts
	
	set seqNo=$i(^DHCBILL("Import"))		//生成记录一条发票导入的序号,方便查询日志
	;导回患者基本信息
	for i=0:1:patmasAry.%Size()-1 quit:(rtnCode'=0)  do
	.set patmasObj=patmasAry.%Get(i)
	.set myrtn=..ReturnPaPatMas(seqNo,expStr,patmasObj)
	.set rtnCode=$p(myrtn,"^",1)
	b:(+rtnCode'=0) ;end01
	
	;导回就诊信息
	if (rtnCode=0){
		for i=0:1:paadmAry.%Size()-1 quit:(rtnCode'=0)  do
		.set paadmObj=paadmAry.%Get(i)
		.set myrtn=..ReturnPAAdm(seqNo,expStr,paadmObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0)  ;end02
	}
	
	;导回诊断主表信息
	if (rtnCode=0){
		for i=0:1:mradmAry.%Size()-1 quit:(rtnCode'=0)  do
		.set mradmObj=mradmAry.%Get(i)
		.set myrtn=..ReturnMrAdm(seqNo,expStr,mradmObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end03
	}
	
	;导回诊断信息
	if (rtnCode=0){
		for i=0:1:mrdiagAry.%Size()-1 quit:(rtnCode'=0)  do
		.set mrdiagObj=mrdiagAry.%Get(i)
		.set myrtn=..ReturnMrDiagnos(seqNo,expStr,mrdiagObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end04
	}
	
	;导回诊断类型信息
	if (rtnCode=0){
		for i=0:1:mrdiagtypeAry.%Size()-1 quit:(rtnCode'=0)  do
		.set mrdiagtypeObj=mrdiagtypeAry.%Get(i)
		.set myrtn=..ReturnMrDiagType(seqNo,expStr,mrdiagtypeObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end05
	}
	
	;导回医嘱信息
	if (rtnCode=0){
		for i=0:1:oeorderAry.%Size()-1 quit:(rtnCode'=0)  do
		.set oeorderObj=oeorderAry.%Get(i)
		.set myrtn=..ReturnOEOrder(seqNo,expStr,oeorderObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end06-01
	}
	;导回医嘱明细信息
	if (rtnCode=0){
		for i=0:1:oeorditemAry.%Size()-1 quit:(rtnCode'=0)  do
		.set oeorditemObj=oeorditemAry.%Get(i)
		.set myrtn=..ReturnOrdItem(seqNo,expStr,oeorditemObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end06-02
        //更新关联关系
        d ##class(DHCDoc.Interface.StandAlone.Import).AfterSaveOrder(oeorditemAry)
	}
	;导回账单信息
	if (rtnCode=0){
		for i=0:1:pbAry.%Size()-1 quit:(rtnCode'=0)  do
		.set pbObj=pbAry.%Get(i)
		.set myrtn=..ReturnPB(seqNo,expStr,pbObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end07
	}
	;导回账单医嘱信息
	if (rtnCode=0){
		for i=0:1:pboAry.%Size()-1 quit:(rtnCode'=0)  do
		.set pboObj=pboAry.%Get(i)
		.set myrtn=..ReturnPBO(seqNo,expStr,pboObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end08
	}
	;导回账单明细信息
	if (rtnCode=0){
		for i=0:1:pbdAry.%Size()-1 quit:(rtnCode'=0)  do
		.set pbdObj=pbdAry.%Get(i)
		.set myrtn=..ReturnPBD(seqNo,expStr,pbdObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end09
	}
	
	;导回发票信息
	if (rtnCode=0){
		for i=0:1:invprtAry.%Size()-1 quit:(rtnCode'=0)  do
		.set invprtObj=invprtAry.%Get(i)
		.set myrtn=..ReturnInvPrt(seqNo,expStr,invprtObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end10
	}
	
	;导回发票支付方式信息
	if (rtnCode=0){
		for i=0:1:invpaymodeAry.%Size()-1 quit:(rtnCode'=0)  do
		.set invpaymodeObj=invpaymodeAry.%Get(i)
		.set myrtn=..ReturnInvPayMode(seqNo,expStr,invpaymodeObj)
		.set rtnCode=$p(myrtn,"^",1)
		b:(+rtnCode'=0) ;end11
	}
	

	if (rtnCode=0){
		tc
	}else{
		tro
	}
	set rtnMsg=$p(myrtn,"^",3)
	set myrtn=rtnCode_"^"_rtnMsg
		
	quit myrtn
ImportET
	set $zt=""
	set rtnMsg="程序异常："_$ZERROR
	if ($tl>0) tro 
	set myrtn="-99^"_rtnMsg
	quit myrtn
}

/// Creator：	xiongwang
/// CreatDate：	2020-11-10
/// Desc:		导回患者基本信息
/// w ##class(BILL.CES.BL.Import).ReturnPaPatMas()
ClassMethod ReturnPaPatMas(seqNo, expStr, patmasObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=patmasObj."PAPMI_ID"
	set papmi=patmasObj."PAPMI_RowId1"
	//set globalNo=patmasObj."PAPMI_Global_Papmi"			//应急收费系统唯一号
	set globalNo=patmasObj."PAPMI_No"	
	set pacCardTypeDR=patmasObj."PAPMI_CardType_DR"
	set patDVAnumber=patmasObj."PAPMI_DVAnumber"		;证件号码
	//set papmi=""
	if (papmi'=""){
		;存在该字段表示患者信息his存在，不需要新建
		set rtnCode=0
		set rtnValue=papmi
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		;获取导入日志
		set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("pa_patmas",globalNo)
		if (hisId'=""){
			set rtnCode=0
			set rtnValue=hisId
			set rtnMsg="成功" 
			set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
		}else{
			set patID=""
			if ((pacCardTypeDR'="")&&(patDVAnumber'="")){
				set cardTypeDesc=$p(^PAC("CARD",+pacCardTypeDR),"^",2)
				set patDVAnumber=$zcvt(patDVAnumber,"L")
				if (($l(patDVAnumber)=15)||($l(patDVAnumber)=18)||(cardTypeDesc["身份证")){
					set papmi=$O(^PAPERi("PAPMI_ICPPBC",patDVAnumber_"Z",""))
					set patID=patDVAnumber
				}
			}
			if (papmi'=""){
				set rtnCode=0
				set rtnValue=papmi
				set rtnMsg="成功"
				set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
			}else{
				;新插患者信息
				set regNo=patmasObj."PAPMI_No"
				set patName=patmasObj."PAPMI_Name"
				set sexDR=patmasObj."PAPMI_Sex_DR"
				set dob=patmasObj."PAPMI_DOB"
				set dob=##class(websys.Conversions).DateHtmlToLogical(dob)
				set socialStatusDR=patmasObj."PAPMI_SocialStatus_DR"
				set tel=patmasObj."PAPMI_TelH"
				set DVAnumber=patmasObj."PAPMI_DVAnumber"
				set cardTypeDR=patmasObj."PAPMI_CardType_DR"
				set hcpDR=patmasObj."PAPMI_HCP_DR"
				set globalPapmi=patmasObj."PAPMI_Global_Papmi"
				set updateDate=patmasObj."PAPMI_UpdateDate"
				set updateTime=patmasObj."PAPMI_UpdateTime"
				set updateDate=##class(websys.Conversions).DateHtmlToLogical(updateDate)
				set updateTime=##class(websys.Conversions).TimeHtmlToLogical(updateTime, 1)
				set updateUser=patmasObj."PAPMI_UpdateUser"
				set hospDR=patmasObj."PAPMI_Hosp_DR"
				ts
				//生成登记号
				Lock ^PAPER(0,"CNT","I")
				set PAPERNo=$i(^PAPER(0,"CNT","I"))
				Lock -^PAPER(0,"CNT","I")
				set PatLen=+$p(^CF("PATCF",1,3),"^",5)
				set PAPERNo=$e("0000000000000000000",1,PatLen-$l(PAPERNo))_PAPERNo
				&sql(INSERT INTO SQLUSER.PA_Person
					set paper_id=:PAPERID,paper_name=:patName,PAPER_DOB=:dob,paper_sex_dr=:sexDR,
						paper_UserUpdate=:updateDate,PAPER_HCP_DR=:hcpDR,
						paper_SocialStatus_DR=:socialStatusDR,paper_TelH=:tel,PAPER_UserAdded_DR=:updateUser
					)
				set rtnCode=SQLCODE
				set rtnValue=$g(%ROWID)
				;b ;01
				if (+rtnCode=0){
					&sql(update SQLUSER.pa_patmas
				         set PAPMI_ID=:patID,papmi_No=:PAPERNo, papmi_ipno=:PAPERNo,papmi_opno=:PAPERNo,PAPMI_CardType_DR=:cardTypeDR,
							 PAPMI_DVAnumber=:DVAnumber,PAPMI_Active="Y"
				       where papmi_rowid=:rtnValue )
				       set rtnCode=rtnCode+SQLCODE
				}
				
				if (rtnCode=0){
					tc
				}else{
					tro
				}
				set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
			}
		}
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"pa_patmas", rtnValue, cesId,globalNo,uploadUser,patmasObj.%ToJSON())
	}
	quit myrtn
}

/// Creator：	xiongwang
/// CreatDate：	2020-11-10
/// Desc:		导回就诊信息
/// w ##class(BILL.CES.BL.Import).ReturnPAAdm()
ClassMethod ReturnPAAdm(seqNo, expStr, paadmObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=paadmObj."PAADM_RowID"
	set globalNo=paadmObj."PAADM_Global_AdmNo"
	
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("pa_adm",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		
		set papmi=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_patmas",terminalNo,paadmObj."PAADM_PAPMI_DR")
		;b ;papmi
		if (papmi=""){
			set rtnCode=-1
			set rtnMsg="就诊表患者信息有误"
			set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
			quit:(rtnCode'=0) myrtn
		}
		
		set patTypeDR=paadmObj."PAADM_PatType_DR"
		set depCodeDR=paadmObj."PAADM_DepCode_DR"
		set admDate=paadmObj."PAADM_AdmDate"
		set admTime=paadmObj."PAADM_AdmTime"
		set admDate=##class(websys.Conversions).DateHtmlToLogical(admDate)
		set admTime=##class(websys.Conversions).TimeHtmlToLogical(admTime, 1)
		set admType=paadmObj."PAADM_Type"
		s EmergencyStatus=""
		if (admType'="E"){
			s IsEmergencyLoc=##class(web.DHCOPAdmReg).IsEmergency(depCodeDR)
			s:IsEmergencyLoc=1 admType="E"
			s:admType="E" EmergencyStatus="Q"
		}
		
		set admSrcDR=paadmObj."PAADM_AdmSrc_DR"
		set admDocDR=paadmObj."PAADM_AdmDocCodeDR"
		set preAdmitted=paadmObj."PAADM_PreAdmitted"
		set visitStatus=paadmObj."PAADM_VisitStatus"
		set createDate=paadmObj."PAADM_CreateDate"
		set createTime=paadmObj."PAADM_CreateTime"
		set createDate=##class(websys.Conversions).DateHtmlToLogical(createDate)
		set createTime=##class(websys.Conversions).TimeHtmlToLogical(createTime, 1)
		set createUser=paadmObj."PAADM_CreateUser"
		set remark=paadmObj."PAADM_Remark"
		set billFlag=paadmObj."PAADM_BillFlag"
		set admReadm=paadmObj."PAADM_AdmReadm"
		//set mradmDR=paadmObj."PAADM_MainMRADM_DR"
		//set paadmObj."PAADM_MaritalStatus_DR"
		set epissubtype=paadmObj."PAADM_Epissubtype_DR"
		set admReasonDR=paadmObj."PAADM_AdmReason_DR"
		//set paadmObj."PAADM_TriageDate"
		//paadmObj."PAADM_TriageTime"
		set updateDate=paadmObj."PAADM_UpdateDate"
		set updateTime=paadmObj."PAADM_UpdateTime"
		set updateDate=##class(websys.Conversions).DateHtmlToLogical(updateDate)
		set updateTime=##class(websys.Conversions).TimeHtmlToLogical(updateTime, 1)
		set updateUser=paadmObj."PAADM_UpdateUser_DR"
		set deptUserDR=paadmObj."PAADM_DeptUser_DR"
		set admNo=##class(web.DHCPAADM).CompADMNo(admType)
		ts
		&sql(INSERT INTO SQLUSER.PA_Adm
			set PAADM_PAPMI_DR=:papmi,PAADM_ADMNo=:admNo,PAADM_PatType_DR=:patTypeDR,PAADM_DepCode_DR=:depCodeDR,PAADM_AdmDate=:admDate,
				PAADM_AdmTime=:admTime,PAADM_Type=:admType,PAADM_AdmSrc_DR=:admSrcDR,PAADM_AdmDocCodeDR=:admDocDR,
				PAADM_PreAdmitted=:preAdmitted,PAADM_VisitStatus=:visitStatus,PAADM_CreateDate=:createDate,PAADM_CreateTime=:createTime,
				PAADM_CreateUser=:createUser,PAADM_Remark=:remark,PAADM_BillFlag=:billFlag,PAADM_AdmReadm=:admReadm,
				PAADM_Epissubtype_DR=:epissubtype,PAADM_AdmReason_DR=:admReasonDR,PAADM_UpdateDate=:updateDate,PAADM_UpdateTime=:createTime,
				PAADM_UpdateUser_DR=:updateUser,PAADM_EmergencyStatus=:EmergencyStatus
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		d ##Class(DHCDoc.Interface.StandAlone.Import).AfterReturnPAAdm(rtnValue_"^"_createUser)
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"pa_adm", rtnValue, cesId,globalNo,uploadUser,paadmObj.%ToJSON())
	}
	quit myrtn
}

/// Creator：	xiongwang
/// CreatDate：	2020-11-10
/// Desc:		导回诊断主表信息
/// w ##class(BILL.CES.BL.Import).ReturnMrAdm()
ClassMethod ReturnMrAdm(seqNo, expStr, mradmObj As %DynamicObject)
{
	
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=mradmObj."MRADM_RowId"
	set mradmDate=mradmObj."MRADM_Date"
	set mradmTime=mradmObj."MRADM_Time"
	set mradmDate=##class(websys.Conversions).DateHtmlToLogical(mradmDate)
	set mradmTime=##class(websys.Conversions).TimeHtmlToLogical(mradmTime, 1)
	set timeStamp=$zd(mradmDate,8)_$tr($zt(mradmTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("mr_adm",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set admId=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_adm",terminalNo,mradmObj."MRADM_ADM_DR")
		ts
		&sql(INSERT INTO SQLUSER.MR_Adm(MRADM_ADM_DR,MRADM_Date,MRADM_Time) values(:admId,:mradmDate,:mradmTime))
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		if (+rtnCode=0){
			//更新就诊表
			&sql(update SQLUSER.PA_Adm set PAADM_MainMRADM_DR=:rtnValue where PAADM_RowID=:admId )
			set rtnCode=SQLCODE
		}
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"mr_adm", rtnValue, cesId,globalNo,uploadUser,mradmObj.%ToJSON())
	}
	
	quit myrtn
}

/// Creator： xiongwang
/// CreatDate：	2020-11-10
/// Desc: 导回诊断信息
/// w ##class(BILL.CES.BL.Import).ReturnMrDiagnos()
ClassMethod ReturnMrDiagnos(seqNo, expStr, mrdiagObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=mrdiagObj."MRDIA_RowId"
	set diagDate=mrdiagObj."MRDIA_Date"
	set diagTime=mrdiagObj."MRDIA_Time"
	set diagDate=##class(websys.Conversions).DateHtmlToLogical(diagDate)
	set diagTime=##class(websys.Conversions).TimeHtmlToLogical(diagTime, 1)
	set timeStamp=$zd(diagDate,8)_$tr($zt(diagTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("mr_diagnos",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set mradm=##class(BILL.CES.COM.Log).GetHisIdByCESId("mr_adm",terminalNo,mrdiagObj."MRDIA_MRADM_DR")
		set ICDCodeDR=mrdiagObj."MRDIA_ICDCode_DR"
		set docCodeDR=mrdiagObj."MRDIA_DocCode_DR"
		set diagDesc=mrdiagObj."MRDIA_Desc"		
		set diagSignSymDR=mrdiagObj."MRDIA_SignSym_DR"
		set createUser=mrdiagObj."MRDIA_UserCreated_DR"
		ts
		&sql(INSERT INTO sqluser.MR_Diagnos
			set MRDIA_MRADM_ParRef=:mradm,MRDIA_ICDCode_DR=:ICDCodeDR,MRDIA_DocCode_DR=:docCodeDR,MRDIA_Date=:diagDate,
				MRDIA_Time=:diagTime,MRDIA_UpdateUser_DR=:createUser,MRDIA_UserCreated_DR=:createUser,MRDIA_OnsetDate=:diagDate,
				MRDIA_OnsetTime=:diagTime
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		
		if (rtnCode=0){
			set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.MRDiagnos"_$c(2)_rtnValue)
	  		set ret=##class(web.DHCDocDataChangeLog).SaveLog("MR_Diagnos","User.MRDiagnos","诊断信息","User.MRDiagnos_"_rtnValue,rtnValue,"A",NewDataJson,"",createUser)
			if (ret'=0){
				set rtnCode=-1
				set rtnMsg=ret
			}
		}
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	
	if (+rtnCode=0){
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"mr_diagnos", rtnValue, cesId,globalNo,uploadUser,mrdiagObj.%ToJSON())
	}
	quit myrtn
}

/// Creator：	xiongwang
/// CreatDate：	2020-11-10
/// Desc:		导回诊断类型信息
/// w ##class(BILL.CES.BL.Import).ReturnMrAdm()
ClassMethod ReturnMrDiagType(seqNo, expStr, mrdiagtypeObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=mrdiagtypeObj."TYP_RowId"
	set diagDR=##class(BILL.CES.COM.Log).GetHisIdByCESId("mr_diagnos",terminalNo,mrdiagtypeObj."TYP_MRDiagnos_DR")
	set diagDate=$p(^MR(+diagDR,"DIA",+$P(diagDR,"||",2)),"^",7)
	set diagTime=$p(^MR(+diagDR,"DIA",+$P(diagDR,"||",2)),"^",7)
	set timeStamp=$zd(diagDate,8)_$tr($zt(diagTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	
	set globalNo=terminalNo_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("mr_diagtype",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		//set diagDR=##class(BILL.CES.COM.Log).GetHisIdByCESId("mr_diagnos",terminalNo,mrdiagtypeObj."TYP_MRDiagnos_DR")
		set diagType=mrdiagtypeObj."TYP_MRCDiagType"
		ts
		&sql(INSERT INTO MR_DiagType(TYP_ParRef,TYP_MRCDiagTyp) values(:diagDR,:diagType)) 
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"mr_diagtype", rtnValue, cesId,globalNo,uploadUser,mrdiagtypeObj.%ToJSON())
	}
	quit myrtn
}

/// Creator：	xiongwang
/// CreatDate：	2020-11-10
/// Desc:		导回医嘱信息
/// Table:		BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnMrAdm()
ClassMethod ReturnOEOrder(seqNo, expStr, orderObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=orderObj."OEORD_RowId"
	set ordDate=orderObj."OEORD_Date"
	set ordTime=orderObj."OEORD_Time"
	set ordDate=##class(websys.Conversions).DateHtmlToLogical(ordDate)
	set ordTime=##class(websys.Conversions).TimeHtmlToLogical(ordTime, 1)
	set timeStamp=$zd(ordDate,8)_$tr($zt(ordTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("oe_order",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set admId=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_adm",terminalNo,orderObj."OEORD_Adm_DR")
		if (+admId>0){
			set rtnValue=$o(^OEORD(0,"Adm",admId,""))		
		}
		
		if (+rtnValue>0){
			//就诊存在则不新建
			set rtnCode=0
			set rtnMsg="成功"
			set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
		}else{
			
			set docDR=orderObj."OEORD_Doctor_DR"
			set arcopDR=orderObj."OEORD_ARCOP_DR"
			set oeotcDR=orderObj."OEORD_OEOTC_DR"
			set sundryDebtorDR=orderObj."OEORD_SundryDebtor_DR"
			ts
			&sql(INSERT INTO SQLUser.OE_Order(OEORD_Adm_DR, OEORD_Date, OEORD_Time, OEORD_Doctor_DR, OEORD_ARCOP_DR, OEORD_OEOTC_DR, OEORD_SundryDebtor_DR)
				values(:admId,:ordDate,:ordTime,:docDR,:arcopDR,:oeotcDR,:sundryDebtorDR)) 
			set rtnCode=SQLCODE
			set rtnValue=$g(%ROWID)
			
			if (rtnCode=0){
				tc
			}else{
				tro
			}
			set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
		}
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"oe_order", rtnValue, cesId,globalNo, uploadUser,orderObj.%ToJSON())
	}
		
	quit myrtn
}

/// Creator：xiongwang
/// CreatDate： 2020-11-10
/// Desc: 导回医嘱明细信息
/// Table: BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnMrAdm()
ClassMethod ReturnOrdItem(seqNo, expStr, orditemObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=orditemObj."OEORI_RowId"
	set globalNo=orditemObj."OEORI_Global_No"
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("oe_orditem",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set orderId=##class(BILL.CES.COM.Log).GetHisIdByCESId("oe_order",terminalNo,orditemObj."OEORI_OEORD_DR")
		set admId=$p(^OEORD(orderId),"^",1)
		set arcim=orditemObj."OEORI_ItmMast_DR"
		//set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim)
		set HerbRange=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr()	//中草药子类
		set itmCatSub=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
		set orderType=$p($g(^ARC("IC",+itmCatSub)),"^",7) 
		set HerbRangeFlag="N"
		if (("^"_HerbRange_"^")[("^"_itmCatSub_"^")) set HerbRangeFlag="Y"
		set userId = orditemObj."OEORI_UserAdd"
		set locId = orditemObj."OEORI_OrdDept_DR"
		set docDR = orditemObj."OEORI_Doctor_DR"
		
		set priorityDR = orditemObj."OEORI_Priority_DR"
		set ordStDate = orditemObj."OEORI_SttDat"
		set ordStTime = orditemObj."OEORI_SttTim"
		
		set ordPackQty= orditemObj."OEORI_QtyPackUOM"
		
		set ordPrice= orditemObj."OEORI_Price"
		set ordRecDepDR = orditemObj."OEORI_RecDep_DR"
		set ordInsType = orditemObj."OEORI_BBExtCode"
		set ordDrugFormRowid = ""		//药学关联指针(PHC_DrgForm)	
		set ordBilled=orditemObj."OEORI_Billed"		//只存在B或P
		set procNotes = ""	//备注
		set ordDoseQty= orditemObj."OEORI_DoseQty"
		set ordDoseUOMRowid= orditemObj."OEORI_Unit_DR"
		set ordQtySum= orditemObj."OEORI_PhQtyOrd"
		set ordFreqRowid= orditemObj."OEORI_PHFreq_DR"
		
		set ordDurRowid = orditemObj."OEORI_Durat_DR"	//疗程
		set ordInstrRowid= orditemObj."OEORI_Instr_DR"
		set ordPrescNo= orditemObj."OEORI_PrescNo"		//处方号
		set ordLabEpisodeNo= orditemObj."OEORI_LabEpisodeNo"		//检验条码
		set PHPrescType=""
		set ordMasterSeqNo=""
		set ordSeqNo= 1		//医嘱序号
		
		set ordSkinTest="N" //是否皮试（Y/N）
		set ordPhSpecInstr=""
		set ordCoverMainIns=""
		set ordActionRowid=""
		set ordARCOSRowid=""
		
		set ordEndDate=""
		set ordEndTime=""
		set ordLabSpecRowid=""
		set ordINCItmDR=orditemObj."OEORI_INCItm_DR"
		set ordItmLocBat=orditemObj."OEORI_ItmLocBat_DR"
		set ordQty=orditemObj."OEORI_Qty"
		set ordPackUomDR=orditemObj."OEORI_PackUOM_DR"

		set expStr="",errMsg=""
		ts
		set ret=""
		if (HerbRangeFlag="N"){
			set ordItemStr=arcim_"^"_orderType_"^"_priorityDR_"^"_ordStDate_"^"_ordStTime	;1-5
			set ordItemStr=ordItemStr_"^"_ordPackQty_"^"_ordPrice_"^"_ordRecDepDR_"^"_ordInsType_"^"_ordDrugFormRowid	;6-10
			set ordItemStr=ordItemStr_"^"_procNotes_"^"_ordDoseQty_"^"_ordDoseUOMRowid_"^"_ordQtySum_"^"_ordFreqRowid	;11-15
			set ordItemStr=ordItemStr_"^"_ordDurRowid_"^"_ordInstrRowid_"^"_PHPrescType_"^"_ordMasterSeqNo_"^"_ordSeqNo	;16-20
			set ordItemStr=ordItemStr_"^"_ordSkinTest_"^"_ordPhSpecInstr_"^"_ordCoverMainIns_"^"_ordActionRowid_"^"_ordARCOSRowid	;21-25
			set ordItemStr=ordItemStr_"^"_ordEndDate_"^"_ordEndTime_"^"_ordLabSpecRowid	;26-28
			set $p(ordItemStr,"^",33)=ordQty
			set $p(ordItemStr,"^",55)=ordPackUomDR
			set $p(ordItemStr,"^",38)=ordLabEpisodeNo
			set $p(ordItemStr,"^",88)=ordPrescNo
			
			set $p(ordItemStr,"^",75)="Y"
 			set $p(ordItemStr,"^",76)=ordItmLocBat
			set $p(ordItemStr,"^",77)=ordINCItmDR
 
			;set ret=##class(web.DHCOEOrdItem).SaveOrderItems(admId,ordItemStr,userId,locId,docDR,"",expStr,errMsg)
			;set ret=##class(web.DHCOEOrdItem).SaveOrderItems(admId,ordItemStr,userId,locId,docDR,"",expStr)
			;set ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(admId,ordItemStr,userId,locId,docDR,"",expStr,.errMsg)
			set ret=##class(DHCDoc.Interface.StandAlone.Import).SaveOrderItem(admId,ordItemStr,userId,locId,docDR,"",expStr,.errMsg)
			
			;b ;insert orditem
		}else{
			set Phcdf=$p($g(^ARCIM(+arcim,$P(arcim,"||",2),1)),"^",12)
			set billuomDr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			set ConFac=##class(web.DHCSTINTERFACE).UOMFac(ordDoseUOMRowid, billuomDr)
			set SumQty=ordDoseQty*ConFac
			set INCIPackCombStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(admId, arcim, ordRecDepDR, SumQty)
			set INCIPackCombStr=$p(INCIPackCombStr,$c(2),2)
			
			set prescCookMode="01"	//煎药方式(01 自煎, 02 代煎),传01或02
			set prescEmergency=""		//加急
			set OrderInfoStr=priorityDR_"^"_ordDurRowid_"^"_ordInstrRowid_"^"_ordFreqRowid_"^"_prescCookMode
			set OrderInfoStr=OrderInfoStr_"^"_ordDoseQty_"^"_ordRecDepDR_"^"_ordInsType_"^"_procNotes_"^"_prescEmergency	;6-10
			set OrderInfoStr=OrderInfoStr_"^"_ordStDate_"^"_ordStTime_"^"_ordARCOSRowid
			
			set ordPhSpecInstr=""		//草药用法备注
			set SingleOrderItemStr=arcim_"^"_ordDoseQty_"^"_ordDoseUOMRowid_"^"_ordPhSpecInstr_"^^^"_INCIPackCombStr_"^^^^Y^"_ordItmLocBat_"^"_ordINCItmDR
			set ordItemStr=OrderInfoStr_$CHAR(2)_SingleOrderItemStr
			
			;set ret=##class(web.DHCOEOrdItem).SaveOrderItemsCM(admId,ordItemStr,userId,locId,docDR,"",expStr,errMsg)
			;set ret=##class(web.DHCOEOrdItem).SaveOrderItemsCM(admId,ordItemStr,userId,locId,docDR)
			;set ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItemsCM(admId,ordItemStr,userId,locId,docDR,"","",errMsg)
			set ret=##class(DHCDoc.Interface.StandAlone.Import).SaveOrderItemCM(admId,ordItemStr,userId,locId,docDR,"","",errMsg)
			;b ;insert orditem
		}
		
		if (ret=100){
			set rtnCode=-1
			set rtnMsg="医嘱插入失败:"_errMsg
		}else{
			set rtnCode=0
			set rtnValue=$p(ret,"*",2)
		}
		if (+rtnCode=0){
			set ordBilled=$case(ordBilled,"P":"P",:"TB")		// 只存在P已结算，B未结算(改成TB可去his结算)？
			&sql(update SQLUSER.OE_OrdItem set OEORI_Billed=:ordBilled where OEORI_RowId=:rtnValue )
			set rtnCode=SQLCODE

		}
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"oe_orditem", rtnValue, cesId,globalNo,uploadUser,orditemObj.%ToJSON())
	
	}
	quit myrtn
}

/// Creator：xiongwang
/// CreatDate：2020-11-10
/// Desc: 导回账单信息
/// Table: BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnPB()
ClassMethod ReturnPB(seqNo, expStr, pbObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=pbObj."PB_RowId"
	set updateDate=pbObj."PB_UpdateDate"
	set updateTime=pbObj."PB_UpdateTime"
	set updateDate=##class(websys.Conversions).DateHtmlToLogical(updateDate)
	set updateTime=##class(websys.Conversions).TimeHtmlToLogical(updateTime, 1)
	set timeStamp=$zd(updateDate,8)_$tr($zt(updateTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_patientbill",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set admId=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_adm",terminalNo,pbObj."PB_Adm_Dr")
		set pbDate=pbObj."PB_AdmDate"
		set discDate=pbObj."PB_DisChargeDate"
		set pbDate=##class(websys.Conversions).DateHtmlToLogical(pbDate)
		set insTypeDR=pbObj."PB_PatInsType_DR"
		set admTypeDR=pbObj."PB_PatAdmType_DR"
		set dateFrom=pbObj."PB_DateFrom"
		set dateTo=pbObj."PB_DateTo"
		set dateFrom=##class(websys.Conversions).DateHtmlToLogical(dateFrom)
		set dateTo=##class(websys.Conversions).DateHtmlToLogical(dateTo)
		set totalAmt=pbObj."PB_TotalAmount"
		set discType=pbObj."PB_DiscType"
		set payorShare=pbObj."PB_PayorShare"
		set patientShare=pbObj."PB_PatientShare"
		set amountPaid=pbObj."PB_AmountPaid"
		set amountToPay=pbObj."PB_AmountToPay"
		set billType=pbObj."PB_BillType"
		set payedFlag=pbObj."PB_PayedFlag"
		set refundFlag=pbObj."PB_RefundFlag"
		//set originalBillDR=pbObj."PB_OriginalBill_DR"
		set originalBillDR=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_patientbill",terminalNo,pbObj."PB_OriginalBill_DR")
		
		set updateUser=pbObj."PB_UpdateUser"
		ts
		&sql(INSERT INTO SQLUSER.DHC_PatientBill
			set PB_Adm_Dr=:admId,PB_AdmDate=:pbDate,PB_DisChargeDate=:discDate,PB_PatInsType_DR=:insTypeDR,
				PB_PatAdmType_DR=:admTypeDR,PB_DateFrom=:dateFrom,PB_DateTo=:dateTo,PB_TotalAmount=:totalAmt,
				PB_DiscType=:discType,PB_PayorShare=:payorShare,PB_PatientShare=:patientShare,PB_AmountPaid=:amountPaid,
				PB_AmountToPay=:amountToPay,PB_BillType=:billType,PB_PayedFlag=:payedFlag,PB_RefundFlag=:refundFlag,
				PB_OriginalBill_DR=:originalBillDR,PB_UpdateDate=:updateDate,PB_UpdateTime=:updateTime,PB_UpdateUser=:updateUser	
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"dhc_patientbill", rtnValue, cesId,globalNo,uploadUser,pbObj.%ToJSON())
	}
		
	quit myrtn
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Desc: 导回账单医嘱信息
/// Table: BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnPBO()
ClassMethod ReturnPBO(seqNo, expStr, pboObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=pboObj."PBO_RowId"
	set orderDate=pboObj."PBO_OrderDate"
	set orderTime=pboObj."PBO_OrderTime"
	set orderDate=##class(websys.Conversions).DateHtmlToLogical(orderDate)
	set orderTime=##class(websys.Conversions).TimeHtmlToLogical(orderTime, 1)
	set timeStamp=$zd(orderDate,8)_$tr($zt(orderTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_patbillorder",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set pb=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_patientbill",terminalNo,pboObj."PBO_PB_DR")
		set arcim=pboObj."PBO_ARCIM_DR"
		;set ordItem=pboObj."PBO_OEORI_DR"
		set ordItem=##class(BILL.CES.COM.Log).GetHisIdByCESId("oe_orditem",terminalNo,pboObj."PBO_OEORI_DR")
		set unPrice=pboObj."PBO_UnitPrice"
		set billQty=pboObj."PBO_BillQty"
		set refundQty=pboObj."PBO_RefundQty"
		set totalAmt=pboObj."PBO_ToTalAmount"
		set discAmt=pboObj."PBO_DiscAmount"
		set payorShare=pboObj."PBO_PayorShare"
		set patientShare=pboObj."PBO_PatientShare"
		
		set refundFlag=pboObj."PBO_RefundFlag"
		set originalBillDR=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_patbillorder",terminalNo,pboObj."PBO_OriginalBill_DR")
		set billStatus=pboObj."PBO_BillStatus"
		set discPrice=pboObj."PBO_DiscPrice"
		set insPrice=pboObj."PBO_InsPrice"
		set patPrice=pboObj."PBO_PatPrice"
		
		ts
		&sql(INSERT INTO SQLUSER.DHC_PatBillOrder
			set PBO_PB_ParRef=:pb,PBO_ARCIM_DR=:arcim,PBO_OEORI_DR=:ordItem,PBO_UnitPrice=:unPrice,
				PBO_BillQty=:billQty,PBO_RefundQty=:refundQty,PBO_ToTalAmount=:totalAmt,PBO_DiscAmount=:discAmt,
				PBO_PayorShare=:payorShare,PBO_PatientShare=:patientShare,PBO_OrderDate=:orderDate,PBO_OrderTime=:orderTime,
				PBO_RefundFlag=:refundFlag,PBO_OriginalBill_DR=:originalBillDR,PBO_BillStatus=:billStatus,PBO_DiscPrice=:discPrice,
				PBO_InsPrice=:insPrice,PBO_PatPrice=:patPrice			
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"dhc_patbillorder", rtnValue, cesId,globalNo,uploadUser,pboObj.%ToJSON())
	}
	
	quit myrtn
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Desc: 导回账单明细信息
/// Table: BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnPB()
ClassMethod ReturnPBD(seqNo, expStr, pbdObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=pbdObj."PBD_RowId"
	set createDate=pbdObj."PBD_CreateDate"
	set createTime=pbdObj."PBD_CreateTime"
	set createDate=##class(websys.Conversions).DateHtmlToLogical(createDate)
	set createTime=##class(websys.Conversions).TimeHtmlToLogical(createTime, 1)
	set timeStamp=$zd(createDate,8)_$tr($zt(createTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_patbilldetails",globalNo)

	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else {
		set pbo=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_patbillorder",terminalNo,pbdObj."PBD_PBO_DR")

		set tariDR=pbdObj."PBD_TARI_DR"
		set unPrice=pbdObj."PBD_UnitPrice"
		set billQty=pbdObj."PBD_BillQty"
		
		set discPerc=pbdObj."PBD_DiscPerc"
		set totalAmt=pbdObj."PBD_TotalAmount"
		set discAmt=pbdObj."PBD_DiscAmount"
		set payorShare=pbdObj."PBD_PayorShare"
		
		set patientShare=pbdObj."PBD_PatientShare"
		set billDate=pbdObj."PBD_BillDate"
		set billTime=pbdObj."PBD_BillTime"
		set billStatus  =pbdObj."PBD_BillStatus"
		set billDate=##class(websys.Conversions).DateHtmlToLogical(billDate)
		set billTime=##class(websys.Conversions).TimeHtmlToLogical(billTime, 1)

		set billUser=pbdObj."PBD_BillUser"
		set discPrice=pbdObj."PBD_DiscPrice"
			
		set insPrice=pbdObj."PBD_InsPrice"
		set patPrice=pbdObj."PBD_PatPrice"
		set discPrice=pbdObj."PBD_DiscPrice"
		set NewOEORIDR=$p(^DHCPB(+pbo,"O",$p(pbo,"||",2)),"^",4)
		set dspbDr=""
		set dspDr=$o(^DHCOEDISQTY(0,"OEORI",NewOEORIDR,"0"))
		if (dspDr'="") do
		.set dspbSub=$o(^DHCOEDISQTY(dspDr,"I","0"))
		.quit:(dspbSub="")
		.set dspbDr=dspDr_"||"_dspbSub
		
		ts
		
		&sql(INSERT INTO SQLUSER.DHC_PatBillDetails
			set PBD_PBO_ParRef=:pbo,PBD_TARI_DR=:tariDR,PBD_UnitPrice=:unPrice,PBD_BillQty=:billQty,
				PBD_DiscPerc=:discPerc,PBD_TotalAmount=:totalAmt,PBD_DiscAmount=:discAmt,PBD_PayorShare=:payorShare,
				PBD_PatientShare=:patientShare,PBD_BillDate=:billDate,PBD_BillTime=:billTime,PBD_BillStatus=:billStatus,
				PBD_CreateDate=:createDate,PBD_CreateTime=:createTime,PBD_BillUser=:billUser,PBD_DiscPrice=:discPrice,
				PBD_InsPrice=:insPrice,PBD_PatPrice=:patPrice,PBD_DSPB_DR=:dspbDr
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"dhc_patbilldetails", rtnValue, cesId,globalNo,uploadUser,pbdObj.%ToJSON())
	}
	quit myrtn
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Desc: 导回发票信息
/// Table: BILL_CES_PO.DHC_ImportLog，
/// w ##class(BILL.CES.BL.Import).ReturnInvPrt()
ClassMethod ReturnInvPrt(seqNo, expStr, invprtObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=invprtObj."PRT_Rowid"
	set invDate=invprtObj."PRT_Date"
	set invTime=invprtObj."PRT_Time"
	set invDate=##class(websys.Conversions).DateHtmlToLogical(invDate)
	set invTime=##class(websys.Conversions).TimeHtmlToLogical(invTime, 1)
	set timeStamp=$zd(invDate,8)_$tr($zt(invTime,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_invprt",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set invNo=invprtObj."PRT_inv"
			
		set acount=invprtObj."PRT_Acount"
		set invUser=invprtObj."PRT_Usr"
		set invFlag=invprtObj."PRT_Flag"
		set invType=invprtObj."PRT_UseINVType"
		set handin=invprtObj."PRT_Handin"
		set handDate=invprtObj."PRT_HandinDate"
		set handTime=invprtObj."PRT_HandinTime"
		set handDate=##class(websys.Conversions).DateHtmlToLogical(handDate)
		set handTime=##class(websys.Conversions).TimeHtmlToLogical(handTime, 1)
		set papmi=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_patmas",terminalNo,invprtObj."PRT_PAPMI_DR")
		set initInvDR=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_invprt",terminalNo,invprtObj."PRT_initInv_DR")
		set patientShare=invprtObj."PRT_PatientShare"
		set payorShare=invprtObj."PRT_PayorShare"
		set discAmount=invprtObj."PRT_DiscAmount"
		set roundErr=invprtObj."PRT_OPCRoundErr"
		set printFlag=invprtObj."PRT_INVPrintFlag"
		set insTypeDR=invprtObj."PRT_InsType_DR"
		set preSum=invprtObj."PRT_OPPreSum"
		set fairType=invprtObj."PRT_FairType"
		set fairType="F"
		set backChange=invprtObj."PRT_OPBackChange"
		set hospDR=invprtObj."PRT_Hospital_DR"
		set admId=##class(BILL.CES.COM.Log).GetHisIdByCESId("pa_adm",terminalNo,invprtObj."PRT_Adm_DR")
		ts
		//插发票表
		&sql(INSERT INTO SQLUSER.DHC_INVPRT 
			set PRT_inv=:invNo,PRT_Date=:invDate,PRT_Time=:invTime,PRT_Acount=:acount,
				PRT_Usr=:invUser,PRT_Flag=:invFlag,PRT_UseINVType=:invType,PRT_Handin=:handin,
				PRT_HandinDate=:handDate,PRT_HandinTime=:handTime,PRT_PAPMI_DR=:papmi,PRT_initInv_DR=:initInvDR,
				PRT_PatientShare=:patientShare,PRT_PayorShare=:payorShare,PRT_DiscAmount=:discAmount,PRT_OPCRoundErr=:roundErr,
				PRT_INVPrintFlag=:printFlag,PRT_InsType_DR=:insTypeDR,PRT_OPPreSum=:preSum,PRT_FairType=:fairType,
				PRT_OPBackChange=:backChange,PRT_Hospital_DR=:hospDR
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		//插关联表
		if (+rtnCode=0){
			set pb=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_patientbill",terminalNo,invprtObj."PRT_ARPBL_DR")
			&sql(INSERT INTO dhc_billconinv (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
				values(:admId,:rtnValue,:pb))
			set rtnCode=SQLCODE
		}
		
		//插入药房中间表
		if ((+rtnCode=0)&&(invFlag="N")){
			set myrtn=##class(PHA.FACE.OUT.Com).InsertPharWinByPrt(rtnValue)
			set rtnCode=$p(myrtn,"^",1)
			set rtnMsg=$p(myrtn,"^",2)
		}
		//调用物资接口减库存
		if ((+rtnCode=0)&&(invFlag="N")){
			set myOEORIStr=##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByINVPRTStr(rtnValue, "0")
			set sendInfo=myOEORIStr_"@"_rtnValue
			set isMatFlag=##class(web.DHCOPBillSendService).IsContainsMat(myOEORIStr)
			if (isMatFlag=1) do
			.job ##class(BILL.Interface.Inside.Invoke).BILLDisp(sendInfo)	   //收费后，调用物资组程序减库存  
		}
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"dhc_invprt", rtnValue, cesId,globalNo, uploadUser, invprtObj.%ToJSON())
	}
	quit myrtn
}

/// Creator: xiongwang
/// CreatDate: 2020-11-10
/// Desc: 导回发票信息
/// Table: BILL_CES_PO.DHC_ImportLog
/// w ##class(BILL.CES.BL.Import).ReturnInvPayMode()
ClassMethod ReturnInvPayMode(seqNo, expStr, invpaymodeObj As %DynamicObject)
{
	set rtnCode=-1, rtnValue="", rtnMsg=""
	set myrtn=""
	set terminalNo=$p(expStr,"^",1)
	set uploadUser=$p(expStr,"^",2)
	
	set cesId=invpaymodeObj."IPM_RowID"
	set date=invpaymodeObj."IPM_Date"
	set time=invpaymodeObj."IPM_Time"
	set date=##class(websys.Conversions).DateHtmlToLogical(date)
	set time=##class(websys.Conversions).TimeHtmlToLogical(time, 1)
	set timeStamp=$zd(date,8)_$tr($zt(time,1),":","")
	set globalNo=terminalNo_"@"_timeStamp_"@"_cesId
	set hisId=##class(BILL.CES.COM.Log).GetHisIdByGlobalNo("dhc_invpaymode",globalNo)
	if (hisId'=""){
		set rtnCode=0
		set rtnValue=hisId
		set rtnMsg="成功"
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}else{
		set invPrt=##class(BILL.CES.COM.Log).GetHisIdByCESId("dhc_invprt",terminalNo,invpaymodeObj."IPM_PRT_DR")
		set payMDR=invpaymodeObj."IPM_PayMode_DR"
		set CMBankDR=invpaymodeObj."IPM_CMBank_DR"
		set payAmt=invpaymodeObj."IPM_Amt"
		
		set chequeNo=invpaymodeObj."IPM_CardChequeNo"
		set cardDR=invpaymodeObj."IPM_Card_DR"
			
		set unit=invpaymodeObj."IPM_Unit"
		set payAccNo=invpaymodeObj."IPM_PayAccNO"
		set chequeDate=invpaymodeObj."IPM_ChequeDate"
		set chequeDate=##class(websys.Conversions).DateHtmlToLogical(chequeDate)
		set note3=invpaymodeObj."IPM_Note3"

		ts
		
		&sql(INSERT INTO SQLUSER.DHC_INVPaymode SET IPM_PRT_ParRef=:invPrt,IPM_PayMode_DR=:payMDR,IPM_CMBank_DR=:CMBankDR,IPM_Amt=:payAmt,
				IPM_CardChequeNo=:chequeNo,IPM_Card_DR=:cardDR,IPM_Date=:date,IPM_Time=:time,
				IPM_Unit_DR=:unit,IPM_PayAccNO=:payAccNo,IPM_ChequeDate=:chequeDate,IPM_Note3=:note3
		)
		set rtnCode=SQLCODE
		set rtnValue=$g(%ROWID)
		
		if (rtnCode=0){
			tc
		}else{
			tro
		}
		set myrtn=rtnCode_"^"_rtnValue_"^"_rtnMsg
	}
	if (+rtnCode=0){
		//保存日志
		set rtnCode=##class(BILL.CES.COM.Log).InsImportLog(seqNo,terminalNo,"dhc_invpaymode", rtnValue, cesId,globalNo,uploadUser,invpaymodeObj.%ToJSON())
	}
	quit myrtn
}

}
