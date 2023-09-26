/// CTOR: QP
/// DATE: 2016-08-7
/// VERN: V4.1.4
/// DESC: 抗菌主业务类
Class DHCAnt.KSS.MainBusiness Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 保存抗菌药物保存主方法
/// IN  : order："BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult"
/// 		  para: order对应的信息串
/// 		  saveType: base/apply/consult
/// OUT : 1^useAimId^AARowid		
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBsave("consult","BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult","63^746^883||1^4^7^1^^1^1,2^!!!!1^Hello^9^ProcessType!0^1^6^180^^^^")
ClassMethod DBsave(saveType As %String, order As %String, valueStr As %String, extendPara As %String, ModePrjInfo As %String) As %String
{
	n (saveType,order,valueStr,extendPara,ModePrjInfo,%session,%request,%response)
	
	//init 
	s (base,apply,consult)=""
	i saveType="base" s base=1
	i saveType="apply" s (base,apply)=1
	i saveType="consult" s (base,apply,consult)=1
	s baseInfo=$p(valueStr,"!",1)
	s ssuid=$p(baseInfo,"^",2)
	s applyInfo=$p(valueStr,"!",5)
   	s consultInfo=$p(valueStr,"!",6)
    s useAimId="",AARowid="",saveStatus=1
    s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s curProcess=""
	
    //开启事务
    TS
    if (base'=""){
        S useAimResult=##class(DHCAnt.KSS.MainBusiness).DBInsertBaseInfo(order,valueStr)
        s useAimRtn=$p(useAimResult,"^",1)
        s useAimId=$p(useAimResult,"^",2)
        if ((useAimRtn'=1)||useAimId="") {
            TRO
            Q "-201^^"	//使用目的保存失败
    	}
    }
    if (apply'=""){
		s applyResult=##class(DHCAnt.KSS.MainBusiness).DBInsertApplyInfo(order,valueStr,useAimId)
	    s applyRtn=$p(applyResult,"^",1)
	    s AARowid=$p(applyResult,"^",2)
       	if ((applyRtn'=1)||(AARowid="")) {
        	TRO
           	Q "-202^^"	//申请信息保存失败
        }
        s logPara=AARowid_"^"_ssuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"A"
        s logResult=..DBInsertKSSLog("ADD",logPara)
        //保存扩展信息
        if (ModePrjInfo'="") {
	      s mResult=##class(DHCAnt.KSS.Extend.ModePrj).SaveModePrjInfo(useAimId,AARowid,ModePrjInfo)
	      if mResult'=0 { 
              TRO
              q "-206^^"	//扩展信息保存失败
          }
	    }
     	if (consult'=""){
	     	//保存扩展信息
	     	s ^DHCDAA("ANT","ExtendPara",AARowid)=extendPara
	     	s curProcess = $P(applyInfo,"^",5)
	     	s defaultDepId=$P(consultInfo,"^",1),consultNums=$P(consultInfo,"^",2)
            s dep1=$P(consultInfo,"^",3),doc1=$P(consultInfo,"^",4)
            s dep2=$P(consultInfo,"^",5),doc2=$P(consultInfo,"^",6)
            s dep3=$P(consultInfo,"^",7),doc3=$P(consultInfo,"^",8)
            s defaultConDoc=$P(consultInfo,"^",9)
            if ((defaultDepId'=0)&&(defaultDepId'="")){	//指定默认会诊科室,且会诊科室个数为1
            	&sql(Update SQLUser.DHC_Doc_AntibioticApply 
	            	set AA_ConsultationDep_DR=:defaultDepId,AA_ConsultationDoc_DR=:defaultConDoc,
	            		AA_DefaultDepFlag=1,AA_ConsultationDepNums=1,AA_Process=:curProcess
	            	where AA_Rowid=:AARowid)
            } else {
	            i (consultNums=""||consultNums=0) s consultNums=1
	            &sql(Update SQLUser.DHC_Doc_AntibioticApply 
            		set AA_ConsultationDep_DR=:dep1,AA_ConsultationDoc_DR=:doc1,
            			AA_ConsultationDepTwo=:dep2,AA_ConsultationDocTwo=:doc2,
            			AA_ConsultationDepThree=:dep3,AA_ConsultationDocThree=:doc3,
            			AA_ConsultationDepNums=:consultNums,AA_Process=:curProcess
            		where AA_Rowid=:AARowid)
	        }
            i ('SQLCODE)  {
	            s msgFlag=##class(DHCAnt.KSS.Common.Method).GetSendMsgType(AARowid)
	            i ((curProcess'["F")&&(msgFlag'=2)) {
                	s consultResult=##class(DHCAnt.KSS.MainBusiness).DBCreateConsultationApply(AARowid,consultNums)
                	s consultStatus=$p(consultResult,"^",1)
                	s ConsultID1=$p(consultResult,"^",2)
                	s ConsultID2=$p(consultResult,"^",3)
                	s ConsultID3=$p(consultResult,"^",4)
                	
                	if ConsultID1="" { 
                    	TRO
                    	q "-203^^"	//会诊表记录插入失败
                	}
                	&SQL(update SQLUser.DHC_Doc_AntibioticApply 
                		set AA_DHCConsult_DR =:ConsultID1,AA_DHCConsultTwo_DR =:ConsultID2,
                			AA_DHCConsultThree_DR =:ConsultID3 
                		where AA_Rowid=:AARowid)

                	if (SQLCODE) {
                    	TRO
                    	Q "-204^^"	//更新会诊信息失败
                	} 
	            }
             } else {
	         	TRO
                Q "-205^^"	//更新申请表会诊科室失败
	         }
        }
    }
	TC	//事务提交
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip(%session.Get("LOGON.HOSPID"))
	s msgFlag=##class(DHCAnt.KSS.Common.Method).GetSendMsgType(AARowid)
	i ((enableMsgTip=1)&&(msgFlag'=2)) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AARowid,curProcess,"A",%session.Get("LOGON.USERID"),%session.Get("LOGON.HOSPID"))
    Q saveStatus_"^"_useAimId_"^"_AARowid
}

/// CTOR: QP
/// DATE: 2017-08-14
/// DESC: 保存越级使用的抗菌药物会诊信息
/// IN  : 
/// OUT : 成功返回1
/// EXEC: w ##class(DHCAnt.KSS.MainBusiness).DBSaveEmergencyConsult("12")
ClassMethod DBSaveEmergencyConsult(AARowid As %String) As %String
{
	n (AARowid,%session,%request,%response)
	s mRtn=1
	q:AARowid="" mRtn
	s consultNums=$p(^DHCDAA("ANT",AARowid,1),"^",35)
	q:consultNums=""||consultNums=0 mRtn
	s msgFlag=##class(DHCAnt.KSS.Common.Method).GetSendMsgType(AARowid)
	q:msgFlag'=2 mRtn
	;s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	;s curProcess=$p(^DHCDAA("ANT",AARowid,1),"^",36)
	
    //开启事务
    TS
    s consultResult=##class(DHCAnt.KSS.MainBusiness).DBCreateConsultationApply(AARowid,consultNums)
    s consultStatus=$p(consultResult,"^",1)
    s ConsultID1=$p(consultResult,"^",2)
    s ConsultID2=$p(consultResult,"^",3)
    s ConsultID3=$p(consultResult,"^",4)
                	
    if ConsultID1="" {
    	TRO
    	q "-203"	//会诊表记录插入失败
    }
    &SQL(update SQLUser.DHC_Doc_AntibioticApply 
    	set AA_DHCConsult_DR =:ConsultID1,AA_DHCConsultTwo_DR =:ConsultID2,
           	AA_DHCConsultThree_DR =:ConsultID3 
        where AA_Rowid=:AARowid)

   	if (SQLCODE) {
    	TRO
        Q "-204"	//更新会诊信息失败
    }
    
	TC	//事务提交
	;i enableMsgTip=1 s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AARowid,curProcess,"A",%session.Get("LOGON.USERID"))
    
    Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 生成基本信息
/// IN  : order："BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult"
/// 	  para:   order对应的信息串
/// OUT : 1^UseAimRowid
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBInsertBaseInfo("BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult","63^746^883||1^4^7^1^^1^1,2^!!!!1^Hello^9^ProcessType!0^1^6^180^^^^")
ClassMethod DBInsertBaseInfo(order As %String, para As %String) As %String
{
	n (order, para)
	
	//init
	s (admId,ssuserId,arcimId,useReasonId,useDrugIndication,antBodyPart)=""
	s (ssYFTimeDR,submission,antSuscept,antOperation,kss3Ind,zBacterium)=""
	s (extendUseReason,preUseDrugTime,patientId,orderType,orderValue)=""
	
	//analysis order and para
	s orderLen=$length(order,",")
	f i=1:1:orderLen d
	.s orderType=$p(order,",",i)
	.s orderValue=$p(para,"!",i)
	.i orderType="BaseInfo" d
	..s admId=$p(orderValue,"^",1)   			//就诊ID
	..s ssuserId=$p(orderValue,"^",2) 			//医生
	..s arcimId=$p(orderValue,"^",3)    		//药品ID
	..s useReasonId=$p(orderValue,"^",4)		//使用目的ID
	..s useDrugIndication=$p(orderValue,"^",5)  //用药指征
	..s antBodyPart=$p(orderValue,"^",6)    	//感染部位
	..s ssYFTimeDR=$p(orderValue,"^",7)     	//用药时机
	..s submission=$p(orderValue,"^",8)   		//是否送检
	..s antSuscept=$p(orderValue,"^",9)    		//药敏记录
	..s antOperation=$p(orderValue,"^",10)     	//手术记录
	..s patientId=$p(^PAADM(admId),"^",1) 		//病人ID
	.i orderType="Kss3Indication" d
    ..s kss3Ind=$p(orderValue,"^",1)    		//特抗药指征
    .i orderType="Zbj" d
    ..s zBacterium=$p(orderValue,"^",1) 		//致病菌
    .i orderType="UsedrugTime" d
    ..s preUseDrugTime=$p(orderValue,"^",1)  	//预计用药天数
    ..s extendUseReason=$p(orderValue,"^",2)  	//延长用药原因
	
	//save data
	s Obj=##class(User.DHCAntUsePurpose).%New()
	s myRtn=0,UseAimRowid=""
	i $ISObject(Obj){
		TS
		d Obj.DAUPAdmdrSetObjectId(admId)
		d Obj.DAUPUserSetObjectId(ssuserId)
		d Obj.DAUPLastUpdateUserSetObjectId(ssuserId)
		d Obj.DAUPItmMastDRSetObjectId(arcimId)
		s Obj.DAUPDTAUPDR=useReasonId		//使用目的ID
		s Obj.DAUPOPerInd=useDrugIndication	//用药指征
		s Obj.DAUPBodyPart=antBodyPart		//感染部位
		s Obj.DAUPOperaYFTimeDR=ssYFTimeDR	//预防用药时间
		s Obj.DAUPSubmission=submission		//是否送检 
		S Obj.DAUPSusceptDR=antSuscept		//药敏记录
		S Obj.DAUPOperationDR=antOperation	//手术记录
		d Obj.DAUPPatDRSetObjectId(patientId) //病人ID
		s Obj.DAUPKSS3Indication=kss3Ind   	//新增特抗药指征
		s Obj.DAUPZBJ=zBacterium    		//新增致病菌
		s Obj.DAUPPreUseDrugTime=preUseDrugTime  	//新增预防用药天数
		s Obj.DAUPExtendUseReason=extendUseReason  //新增延长用药原因
		S Obj.DAUPDate=+$H
		S Obj.DAUPTime=$p($h,",",2)
		S Obj.DAUPLastUpdateDate=+$H
		S Obj.DAUPLastUpdateTime=$p($h,",",2)
		
		Set sc = Obj.%Save()
		If $$$ISERR(sc) {
			///d $system.OBJ.DisplayError(sc) 
			TRollback
			Quit -100_"^"
		}
		Set UseAimRowid=Obj.%Id()
		TC
		s myRtn=1
	}
	Q myRtn_"^"_UseAimRowid
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 生成申请记录信息
/// IN  : order："BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult"
/// 		  para: order对应的信息串
/// 		  useAimId: 使用目的表Id
/// OUT : 1^AARowid
/// EXEC: w ##class(DHCAnt.KSS.MainBusiness).DBInsertApplyInfo("BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult","63^746^883||1^4^7^1^^1^1,2^!!!!1^Hello^9^ProcessType!0^1^6^180^^^^",1)
ClassMethod DBInsertApplyInfo(order As %String, para As %String, useAimId As %String) As %String
{
	n (order,para,useAimId)
	
	//init
	Q:useAimId="" -119_"^"
	s (admId,arcimId,ssuserId,isEmergency,applyLoc,processType,emergencyReason)=""
	
	//analysis order and para
	s orderLen=$length(order,",")
	f i=1:1:orderLen d
	.s orderType=$p(order,",",i)
	.s orderValue=$p(para,"!",i)
	.i orderType="BaseInfo" d
	..s admId=$p(orderValue,"^",1)   			//就诊ID
	..s ssuserId=$p(orderValue,"^",2) 			//医生
	..s arcimId=$p(orderValue,"^",3)    		//药品ID
	.i orderType="Apply" d
    ..s isEmergency=$p(orderValue,"^",1)    	//是否越级
    ..s emergencyReason=$p(orderValue,"^",2)    //越级原因
    ..s applyLoc=$p(orderValue,"^",3)    		//申请科室
    ..s processType=$p(orderValue,"^",4)    	//流程类型
   	..s processInfo=$p(orderValue,"^",5)
   	..s lastAuditUser=$p(orderValue,"^",6)
	
   	//save data
	s myRtn=0,AARowid=""
	s Obj=##class(User.DHCDocAntibioticApply).%New()
	if $ISObject(Obj) {
		TS
		d Obj.AAAdmDRSetObjectId(admId)
		d Obj.AAArcimDRSetObjectId(arcimId)
		if ssuserId'="" d Obj.AAApplyUserDRSetObjectId(ssuserId)	//申请人
		
		s Obj.AAApplyDate=+$H			//申请日期
		s Obj.AAApplyTime=$P($H,",",2)	//申请时间
		s Obj.AAApplyStatus="A"			//申请状态
		d Obj.AAUserAddDRSetObjectId(ssuserId)		//添加人
		s Obj.AADateAdd=+$H
		s Obj.AATimeAdd=$p($h,",",2)
		s Obj.AAApplyTypeControl="P"
		d Obj.AALastUpdateUserSetObjectId(ssuserId)	//修改人
		s Obj.AALastUpdateDate=+$H				//修改日期
		s Obj.AALastUpdateTime=$p($h,",",2)		//修改时间
		d Obj.AAPurposeDRSetObjectId(useAimId)	//使用目的业务表ID
		s Obj.AAisEmergency=isEmergency			//是否越级
		s Obj.AALocDR=applyLoc					//申请科室
		s Obj.AAProcessType=processType			//流程类型
		s Obj.AAProcess=processInfo
		s Obj.AALastAuditUser=lastAuditUser
		s Obj.AAEmergecyReason=emergencyReason	//越级原因
		s sc = Obj.%Save()
		If $$$ISERR(sc) {
			///d $system.OBJ.DisplayError(sc) 
			Trollback
			Quit -100_"^"	//保存失败
		}
		Set AARowid=Obj.%Id()
		TC
		s myRtn=1
	}	
	Q myRtn_"^"_AARowid
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据配置来生成会诊申请单
/// IN  : 申请表Id、会诊科室个数
/// OUT : 1^consultId1^consultId2^consultId3^saveSuccess
/// NOTE: ConDestination  会诊理由   会诊申请时，构造描述=医嘱项+使用目的/指征/用法/使用时间
/// 	  DocGrade  医生级别:主任医师--D 副主任医师--A  普通医师--C
/// 	
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBCreateConsultationApply("646","1")
ClassMethod DBCreateConsultationApply(AppRowid As %String, consultNums As %String)
{
	n (AppRowid,consultNums,%session,%request,%response)
	q:AppRowid="" -1
	s mRtn=1,saveSuccess=1
	s ConsultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",4)	//会诊科室1	
	q:ConsultDep="" 0
	s defaultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",34)	//是否指定默认会诊科室
	s RequestConDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",5)	//要求会诊医生1
	q:(RequestConDoc="")&&(defaultDep'=1) 0				//没有指定会诊科室，需判断会诊医生是否为空
	
	s simpleBL=$g(^DHCDAA("ANT","ExtendPara",AppRowid))
	s AppDate=$zd(+$h,3)		//申请日期
	s AppTime=$zt($p($h,",",2))	//申请时间
	s ConType="E"				//类别：一般|C 急|E
	s InOut="I"					//院内(I)|院外(O)  
	s EpisdeID=$p(^DHCDAA("ANT",AppRowid),"^",1)		//病人Adm
	s ArcIM=$p(^DHCDAA("ANT",AppRowid),"^",2)			//医嘱项ID
	s arcimDesc=$p(^ARCIM(+ArcIM,$p(ArcIM,"||",2),1),"^",2)
	s UseReasonID=$p(^DHCDAA("ANT",AppRowid,1),"^",20)	//使用目的表ID
	s UsePurpseDesc="",OPerIndDesc="",ModeInfo=""
	i UseReasonID'=""  d
	.s ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)	//指向表DHC_CT_AntUsePurpose
	.s UsePurpseDesc=$p(^DHCAntBasePurposeDataConfigD(ReasonID),"^",3)	//使用目的：治疗-感染手术-药敏
	.s OPerIndDr=$P(^DAUP("DAUP",UseReasonID),"^",10)	//指向 DHC_Ant_Indications
	.s OPerIndDesc=$p(^DHCAntBasePurposeDataConfigD(OPerIndDr),"^",3)	//指征
	s ModePrjID=$O(^BS.ANT.DHCAntModePrjI("ApplyDr",AppRowid,""))
	i ModePrjID'="" d
	.s ModePrjInfo=$g(^BS.ANT.DHCAntModePrjD(ModePrjID))
	.s (DosQtyDesc,DosQtyUom,Priority,FreqDesc,InstrDesc)=""
	.s DosQty=$p(ModePrjInfo,"^",19)
	.s FreqID=$p(ModePrjInfo,"^",20)
	.s:FreqID'="" FreqDesc=$p($g(^PHCFR(FreqID)),"^",3)
	.s InstrID=$p(ModePrjInfo,"^",22)
	.s:InstrID'="" InstrDesc=$p($g(^PHCIN(InstrID)),"^",2)
	.s DosQtyUomID=$p(ModePrjInfo,"^",23)
	.s:DosQtyUomID'="" DosQtyUom=$p($g(^CT("UOM",DosQtyUomID)),"^",2)
	.s:DosQty'="" DosQtyDesc=DosQty_DosQtyUom
	.s PriorityID=$p(ModePrjInfo,"^",24)
	.s:PriorityID'="" Priority=$p(^OECPR(PriorityID),"^",2)
	.s ModeInfo="，使用方法有：单次剂量:"_DosQtyDesc_"、医嘱类型:"_Priority_"、频次:"_FreqDesc_"、用法:"_InstrDesc
	s ConDestination="本病人建议使用【"_arcimDesc_"】，使用目的为："_UsePurpseDesc_"，指征："_OPerIndDesc_ModeInfo
	s Specordid=$p(ArcIM,"||",1)_"_"_$p(ArcIM,"||",2)
	s ConDocType=$p(^CTPCP(RequestConDoc,1),"^",4)
	s ConDocTypeDesc=$p(^CT("CPT",ConDocType),"^",2)
	;s DocGrade="C"
	;i ConDocTypeDesc="主任医师" Set DocGrade="D"
	;i ConDocTypeDesc="副主任医师" Set DocGrade="A"
	s AppDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",7)	//申请医生
	s AppDep=$p(^DHCDAA("ANT",AppRowid,1),"^",25)	//申请科室 
	s Status ="V"									//申请状态(V)
 	
	f j=1:1:consultNums {
		i j=3 {
			s ConsultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",30)
			s RequestConDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",31)
			s DocGrade=$p(^CTPCP(RequestConDoc,1),"^",4)
		} elseif j=2 {
			s ConsultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",27)
			s RequestConDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",28)
			s DocGrade=$p(^CTPCP(RequestConDoc,1),"^",4)
		} else {
			s ConsultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",4)
			s RequestConDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",5)
			s DocGrade=$p(^CTPCP(RequestConDoc,1),"^",4)
		}
		/* 护理组会诊接口 Remove By QP 2019-01-14
		Set parr="ConsultDep"_"|"_ConsultDep_"^"_"AppDate"_"|"_AppDate_"^"_"AppTime"_"|"_AppTime_"^"_"ConType"_"|"_ConType_"^"_"InOut"_"|"_InOut
 		Set parr=parr_"^"_"ConDestination"_"|"_ConDestination_"^"_"EpisdeID"_"|"_EpisdeID_"^"_"Status"_"|"_Status_"^"_"AppDep"_"|"_AppDep
 		Set parr=parr_"^"_"AppDoc"_"|"_AppDoc_"^"_"id|"_"^"_"RequestConDoc"_"|"_RequestConDoc_"^"_"DocGrade"_"|"_DocGrade_"^"_"Specordid"_"|"_Specordid
 		Set flag=##class(web.DHCConsult).savetskjy(parr)
 		i $p(flag,"^",1)'=1 {
	 		s saveSuccess=0
	 		s mRtn=mRtn_"^"
	 		quit
	 	}
 		s mRtn=mRtn_"^"_$p(flag,"^",2)
 		*/
 		//就诊ID^申请医生ID^申请科室^简要病历^会诊目的^^^^会诊日期^会诊时间^
		//加急(Y/N)^是否外院(Y/N) ^外院名称^外院医师^会诊备注^联系人^联系电话^是否共享^
		//&会诊科室ID^会诊医生ID^职称ID
		//s simpleBL=ConDestination,conAim=""
		s conAim=ConDestination
		s conDate=$zd(+$h,3),conTime=$zt(($p($h,",",2)+120),2)
		s isEm="Y",isWY="N",WYName="",WYDoc="",conNote="",ContactPerson="",ContactPhone="",isShare=""
		//s hospId=%session.Get("LOGON.HOSPID"),groupId=%session.Get("LOGON.GROUPID")
		//医院ID^科室ID^人员ID^安全组ID
		//set Params=hospId_"^"_AppDep_"^"_AppDoc_"^"_groupId
		Set mListData=EpisdeID_"^"_AppDoc_"^"_AppDep_"^"_simpleBL_"^"_conAim_"^DOC01^^DOCA^"_conDate_"^"_conTime
		Set mListData=mListData_"^"_isEm_"^"_isWY_"^"_WYName_"^"_WYDoc_"^"_conNote_"^"_ContactPerson_"^"_ContactPhone_"^"_isShare_"^N"
		Set mListData=mListData_$C(2)_ConsultDep_"^"_RequestConDoc_"^"_DocGrade
		
 		Set mResult=##Class(web.DHCEMConsInterface).Insert(mListData)
 		set flag=$p(mResult,"^",1),mConsultId=$p(mResult,"^",2)
 		i flag'=0 {	//会诊插入失败
	 		s saveSuccess=0
	 		s mRtn=mRtn_"^"
	 		quit
	 	}else{
 			s mRtn=mRtn_"^"_mConsultId
	 	}
 		
	}
	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 生成基本信息
/// IN  : order："BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult"
/// 	  para:   order对应的信息串
/// OUT : 1^UseAimRowid
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBInsertBaseInfo("BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult","63^746^883||1^4^7^1^^1^1,2^!!!!1^Hello^9^ProcessType!0^1^6^180^^^^")
ClassMethod DBInsertKSSLog(action As %String, para As %String) As %String
{
	n (action,para)
	s AppRowid=$P(para,"^",1)
	s UserID=$P(para,"^",2)
	s CurrentDate=$P(para,"^",3)
	s CurrentTime=$P(para,"^",4)
	s updatestatus=$P(para,"^",5)
	s curAction=$P(para,"^",6)
	s conStatusCode=$P(para,"^",7)
	i curAction="" s curAction=action
	s Err=0
	
	TSTART
	i action="ADD" d
	.&sql(insert into DHCAnt_Base.MainLog(MLOG_Type,MLOG_Desc,MLOG_Code,
 					MLOG_ParentCode,MLOG_QuoteDR,MLOG_User,MLOG_UpdateDate,
 					MLOG_UpdateTime,MLOG_Status,MLOG_Action,MLOG_Value,MLOG_NoteA) 
 			values ("KSS","抗菌医生站日志","KSSPROCESS","PROCESS",:AppRowid,:UserID,
 					:CurrentDate,:CurrentTime,"SUCCESS",:curAction,:updatestatus,:conStatusCode))
 	.i SQLCODE'=0 s Err=SQLCODE
 	i Err'=0 {
		TROLLBACK
		q "-501"	//插入日志失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-22
/// DESC: 变更审核状态
/// IN  : action: normal/finally
/// 	  para:   AppRowid^UserID^CurrentDate^CurrentTime^updatestatus
/// OUT : 
/// NOTE:  AppRowid,UserID,CurrentDate,CurrentTime,updatestatus
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBUpdateAuditStatus()
ClassMethod DBUpdateAuditStatus(action As %String, para As %String) As %String
{
	n (action,para)
	s AppRowid=$P(para,"^",1)
	s UserID=$P(para,"^",2)
	s CurrentDate=$P(para,"^",3)
	s CurrentTime=$P(para,"^",4)
	s updatestatus=$P(para,"^",5)
	s Err=0
	
	TSTART
	
	i action="normal" d
	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus=:updatestatus,
 					AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,
 					AA_LastUpdateTime=:CurrentTime
 	    	where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE
 	
 	i action="finally" d	
	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus=:updatestatus,
				AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
 				AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,
 				AA_LastUpdateDate=:CurrentDate,
 				AA_LastUpdateTime=:CurrentTime
 	    where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE
 	
 	i action="cancel" d	
	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus=:updatestatus,
				AA_AuditUser_DR=NULL,AA_AuditDate=NULL,
 				AA_AuditTime=NULL,AA_LastUpdateUser=:UserID,
 				AA_LastUpdateDate=:CurrentDate,
 				AA_LastUpdateTime=:CurrentTime
 	    where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE
 	
 	i Err'=0 {
		TROLLBACK
		q "-500"	//更新申请表失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 会诊状态变更【护理组】
/// IN  : action: normal/finally
/// 	  para:   
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatus()
ClassMethod DBChangeConsultStatus(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	s mRtn=0
	//为了兼容Portal，DBUpdateConsultStatus 变更为：DBUpdateConsultStatusNew
	i statusCode="E" s mRtn=..DBUpdateConsultStatusNew(consultId,consuid,statusCode)
	i statusCode="CE" s mRtn=..DBUpdateConsultStatusCE(consultId,consuid,statusCode)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-14
/// DESC: 会诊状态变更【新产品组】
/// IN  :    
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBChangeConsultStatusNew(consultId,consuid,"E")
ClassMethod DBChangeConsultStatusNew(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	s mRtn=0
	i statusCode="E" s mRtn=..DBUpdateConsultStatusNew(consultId,consuid,statusCode)
	i statusCode="CE" s mRtn=..DBUpdateConsultStatusCE(consultId,consuid,statusCode)
	//会诊拒绝
	i statusCode="R" s mRtn=..RefuseConsult(consultId,consuid,statusCode)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 会诊撤销
/// IN  : action: normal/finally
/// 	  para:   
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBUpdateConsultStatusCE()
ClassMethod DBUpdateConsultStatusCE(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	s Err=0
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	q:(consultId="")||(consuid="") Err
	q:'$d(^DHCDAAi("Consult",consultId)) Err
	s aaRowid=$o(^DHCDAAi("Consult",consultId,""))
	q:aaRowid="" Err
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	
	TSTART
	
	s consultId1="",consultId2="",consultId3=""
	s consultDepNums=$p(^DHCDAA("ANT",aaRowid,1),"^",35)
	s Err=0,resultStatus=0,logStatus=0,auditDoc=""
	s curProcess=$p(^DHCDAA("ANT",aaRowid,1),"^",36)	//当前流程
	s curApplyStatus=$p(^DHCDAA("ANT",aaRowid),"^",12)	//当前状态
	s prevStatus=##class(DHCAnt.KSS.Common.Method).GetConPrevStatus(aaRowid)
	
	
	//1个会诊科室
	i (consultDepNums'=2)&&(consultDepNums'=3) d
	.s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_prevStatus_"^"_"Cancel"_"^"_statusCode
	.s logAction="normal"
	.i (curApplyStatus="R")||(curApplyStatus="U") s logAction="cancel"
	.s resultStatus=..DBUpdateAuditStatus(logAction,logPara)
	.i resultStatus'=0 s Err=resultStatus
	.i logStatus=..DBInsertKSSLog("ADD",logPara)
	.i logStatus'=0 s Err=logStatus
	
	//多科室会诊
	i (consultDepNums=2)||(consultDepNums=3) d
	.i (curApplyStatus'="A")&&(curApplyStatus'="F")	d
	..s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_prevStatus_"^"_"Cancel"_"^"_statusCode
	..s logAction="normal"
	..i (curApplyStatus="R")||(curApplyStatus="U") s logAction="cancel"
	..s resultStatus=..DBUpdateAuditStatus(logAction,logPara)
	..i resultStatus'=0 s Err=resultStatus
	..i logStatus=..DBInsertKSSLog("ADD",logPara)
	..i logStatus'=0 s Err=logStatus
	
	/*
	s prevStatus="C"
	s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_prevStatus_"^"_"Cancel"_"^"_statusCode
	s logAction="cancel"
	s resultStatus=..DBUpdateAuditStatus(logAction,logPara)
	i resultStatus'=0 s Err=resultStatus
	i logStatus=..DBInsertKSSLog("ADD",logPara)
	i logStatus'=0 s Err=logStatus
	*/
	i Err'=0 {
		TROLLBACK
		q "-503"	//更新会诊状态失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-22
/// DESC: 给护理组提供的会诊执行接口
/// IN  : action: normal/finally
/// 	  para:   
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBUpdateConsultStatus()
ClassMethod DBUpdateConsultStatus(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	
	s Err=0
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	q:(consultId="")||(consuid="") Err
	q:'$d(^DHCDAAi("Consult",consultId)) Err
	s aaRowid=$o(^DHCDAAi("Consult",consultId,""))
	q:aaRowid="" Err
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	i $d(%session) s currUserId=%session.Get("LOGON.USERID")	//处理Portal无法获取Session
	e  s currUserId=consuid
	TSTART
	
	s consultId1="",consultId2="",consultId3=""
	s consultDepNums=$p(^DHCDAA("ANT",aaRowid,1),"^",35)
	s Err=0,resultStatus=0,logStatus=0,auditDoc=""
	s curProcess=$p(^DHCDAA("ANT",aaRowid,1),"^",36)	//当前流程
	i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).ComExecConsultMsg(aaRowid,consuid,statusCode)
	
	//1个会诊科室
	i (consultDepNums'=2)&&(consultDepNums'=3) d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s consultObj1=##class(User.DHCConsultation).%OpenId(consultId1)
	.s consultDoc1=consultObj1.ConsultDoc
	.s consultResult1=consultObj1.attitudetsy		//1同 2拒
	.s:consultDoc1'="" consultDoc1=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc1)
	
	.i ((curProcess["S")||(curProcess["U"))  d
	..i consultResult1=1  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	.e  d
	..i consultResult1=1  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	//2个会诊科室
	i consultDepNums=2 d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s consultId2=$p(^DHCDAA("ANT",aaRowid,1),"^",26)
	
	.s consultObj1=##class(User.DHCConsultation).%OpenId(consultId1)
	.s consultDoc1=consultObj1.ConsultDoc
	.s consultResult1=consultObj1.attitudetsy		//1同 2拒
	
	.s consultObj2=##class(User.DHCConsultation).%OpenId(consultId2)
	.s consultDoc2=consultObj2.ConsultDoc
	.s consultResult2=consultObj2.attitudetsy	//1同 2拒
	.s:consultDoc1'="" consultDoc1=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc1)
	.s:consultDoc2'="" consultDoc2=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc2)
	
	.i (consultResult1="2")||(consultResult2="2") d	//拒绝
	..i consultResult1=2 s auditDoc=consultDoc1
	..i consultResult2=2 s auditDoc=consultDoc2
	..s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	..s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	..i resultStatus'=0 s Err=resultStatus
	..i logStatus=..DBInsertKSSLog("ADD",logPara)
	..i logStatus'=0 s Err=logStatus
	..i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	.i ((consultResult1="1")&&(consultResult2="1")) d		//都同意的情况
	..i ((curProcess["S")||(curProcess["U"))  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
		
	//3个会诊科室
	i consultDepNums=3 d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s consultId2=$p(^DHCDAA("ANT",aaRowid,1),"^",26)
	.s consultId3=$p(^DHCDAA("ANT",aaRowid,1),"^",29)
	
	.s consultObj1=##class(User.DHCConsultation).%OpenId(consultId1)
	.s consultDoc1=consultObj1.ConsultDoc
	.s consultResult1=consultObj1.attitudetsy		//1同 2拒
	
	.s consultId2=$p(^DHCDAA("ANT",aaRowid,1),"^",26)
	.s consultObj2=##class(User.DHCConsultation).%OpenId(consultId2)
	.s consultDoc2=consultObj2.ConsultDoc
	.s consultResult2=consultObj2.attitudetsy	//1同 2拒
	
	.s consultObj3=##class(User.DHCConsultation).%OpenId(consultId3)
	.s consultDoc3=consultObj3.ConsultDoc
	.s consultResult3=consultObj3.attitudetsy		//1同 2拒
	
	.s:consultDoc1'="" consultDoc1=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc1)
	.s:consultDoc2'="" consultDoc2=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc2)
	.s:consultDoc3'="" consultDoc3=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc3)
	
	.i (consultResult1="2")||(consultResult2="2")||(consultResult3="2") d	//拒绝
	..i consultResult1=2 s auditDoc=consultDoc1
	..i consultResult2=2 s auditDoc=consultDoc2
	..i consultResult3=2 s auditDoc=consultDoc3
	..s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	..s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	..i resultStatus'=0 s Err=resultStatus
	..i logStatus=..DBInsertKSSLog("ADD",logPara)
	..i logStatus'=0 s Err=logStatus
	..i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	.i ((consultResult1="1")&&(consultResult2="1")&&(consultResult3="1")) d		//都同意的情况
	..i ((curProcess["S")||(curProcess["U"))  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
 	
 	i Err'=0 {
		TROLLBACK
		q "-503"	//更新会诊状态失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2019-01-14
/// DESC: 给【新产品组】会诊执行接口
/// IN  : action: normal/finally
/// 	  para:   
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBUpdateConsultStatus()
ClassMethod DBUpdateConsultStatusNew(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	
	s Err=0
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	q:(consultId="")||(consuid="") Err
	q:'$d(^DHCDAAi("Consult",consultId)) Err
	s aaRowid=$o(^DHCDAAi("Consult",consultId,""))
	q:aaRowid="" Err
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	i $d(%session) s currUserId=%session.Get("LOGON.USERID")	//处理Portal无法获取Session
	e  s currUserId=consuid
	TSTART
	
	s consultId1="",consultId2="",consultId3=""
	s consultDepNums=$p(^DHCDAA("ANT",aaRowid,1),"^",35)
	s Err=0,resultStatus=0,logStatus=0,auditDoc=""
	s curProcess=$p(^DHCDAA("ANT",aaRowid,1),"^",36)	//当前流程
	i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).ComExecConsultMsg(aaRowid,consuid,statusCode)
	
	//1个会诊科室
	i (consultDepNums'=2)&&(consultDepNums'=3) d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId1)
	.s consultDoc1=$p(conInfo,"^",2)
	.s consultResult1=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId1)		//1同 2拒
	.i consultResult1="Y" s consultResult1=1
	.i consultResult1="N" s consultResult1=2
	.i ((curProcess["S")||(curProcess["U"))  d
	..i consultResult1=1  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	.e  d
	..i consultResult1=1  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	//2个会诊科室
	i consultDepNums=2 d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s consultId2=$p(^DHCDAA("ANT",aaRowid,1),"^",26)
	
	.s consultObj1=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId1)
	.s consultDoc1=$p(consultObj1,"^",2)
	.s consultResult1=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId1)
	.i consultResult1="Y" s consultResult1=1
	.i consultResult1="N" s consultResult1=2
	
	.s consultObj2=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId2)
	.s consultDoc2=$p(consultObj2,"^",2)
	.s consultResult2=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId2)
	.i consultResult2="Y" s consultResult2=1
	.i consultResult2="N" s consultResult2=2
	
	.i (consultResult1="2")||(consultResult2="2") d	//拒绝
	..i consultResult1=2 s auditDoc=consultDoc1
	..i consultResult2=2 s auditDoc=consultDoc2
	..s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	..s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	..i resultStatus'=0 s Err=resultStatus
	..i logStatus=..DBInsertKSSLog("ADD",logPara)
	..i logStatus'=0 s Err=logStatus
	..i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	.i ((consultResult1="1")&&(consultResult2="1")) d		//都同意的情况
	..i ((curProcess["S")||(curProcess["U"))  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)	//normal
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
		
	//3个会诊科室
	i consultDepNums=3 d
	.s consultId1=$p(^DHCDAA("ANT",aaRowid,1),"^",22)
	.s consultId2=$p(^DHCDAA("ANT",aaRowid,1),"^",26)
	.s consultId3=$p(^DHCDAA("ANT",aaRowid,1),"^",29)
	
	.s consultObj1=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId1)
	.s consultDoc1=$p(consultObj1,"^",2)
	.s consultResult1=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId1)
	.i consultResult1="Y" s consultResult1=1
	.i consultResult1="N" s consultResult1=2
	
	.s consultObj2=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId2)
	.s consultDoc2=$p(consultObj2,"^",2)
	.s consultResult2=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId2)
	.i consultResult2="Y" s consultResult2=1
	.i consultResult2="N" s consultResult2=2
	
	.s consultObj3=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(consultId3)
	.s consultDoc3=$p(consultObj3,"^",2)
	.s consultResult3=##Class(web.DHCEMConsInterface).GetConsentAnti(consultId3)
	.i consultResult3="Y" s consultResult3=1
	.i consultResult3="N" s consultResult3=2
	
	.i (consultResult1="2")||(consultResult2="2")||(consultResult3="2") d	//拒绝
	..i consultResult1=2 s auditDoc=consultDoc1
	..i consultResult2=2 s auditDoc=consultDoc2
	..i consultResult3=2 s auditDoc=consultDoc3
	..s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	..s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	..i resultStatus'=0 s Err=resultStatus
	..i logStatus=..DBInsertKSSLog("ADD",logPara)
	..i logStatus'=0 s Err=logStatus
	..i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
	.i ((consultResult1="1")&&(consultResult2="1")&&(consultResult3="1")) d		//都同意的情况
	..i ((curProcess["S")||(curProcess["U"))  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"H"
	...s resultStatus=..DBUpdateAuditStatus("normal",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"H",currUserId)
	..e  d
	...s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"U"
	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	...i resultStatus'=0 s Err=resultStatus
	...i logStatus=..DBInsertKSSLog("ADD",logPara)
	...i logStatus'=0 s Err=logStatus
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"U",currUserId)
 	
 	i Err'=0 {
		TROLLBACK
		q "-503"	//更新会诊状态失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-22
/// DESC: 变更申请表中相关会诊科室的指针
/// IN  : para: ConsultID1^ConsultID2^ConsultID3^AARowid
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).DBUpdateConsultDR()
ClassMethod DBUpdateConsultDR(para As %String) As %String
{
	n (para)
	s ConsultID1=$P(para,"^",1)
	s ConsultID2=$P(para,"^",2)
	s ConsultID3=$P(para,"^",3)
	s AARowid=$P(para,"^",4)
	s Err=0
	
	TSTART
	
	&SQL(update SQLUser.DHC_Doc_AntibioticApply 
    	set AA_DHCConsult_DR =:ConsultID1,AA_DHCConsultTwo_DR =:ConsultID2,
        AA_DHCConsultThree_DR =:ConsultID3 
        where AA_Rowid=:AARowid)
 	i SQLCODE'=0 s Err=SQLCODE
 	
 	i Err'=0 {
		TROLLBACK
		q "-500"	//更新申请表失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 抗菌药物审核列表    
/// In   ：StDate:开始日期，  EndDate：结束日期，Poisonjb：管制分类级别，AuditStatus：审核状态（选择已审核还是未审核），ProcessType：流程类型（指科室预审或科室审核）
/// NOTE：增加了权限判断, Quinn: 会诊表中ConsultDoc-会诊医生在会诊完成之后，才会存储会诊医生的字段
/// processTypeStr: 科室预审,科室审核,最终审核,已审核
/// EXEC: D ##class(%ResultSet).RunQuery("DHCAnt.KSS.MainBusiness","QryAntApplyInfor","2019-07-02","2019-07-03","","","","1,0,0,0")
Query QryAntApplyInfor(StDate As %String, EndDate As %String, Poisonjb As %String, AuditStatus As %String, ProcessType As %String, processTypeStr As %String = "", InHosp = "") As %Query(ROWSPEC = "id:%String,ApplyStatus:%String,ApplyStatusDesc:%String,PatName:%String,kssjb:%String,arcimDesc:%String,ApplyLoc:%String,AppUser:%String,Appdate:%String,UsePurpseDesc:%String,OPerIndDesc:%String,BodyPartdesc:%String,YFtime:%String,Conresult1:%String,ConSuggestion1:%String,Consultdep1:%String,Consultdoc1:%String,Conresult2:%String,ConSuggestion2:%String,Consultdep2:%String,Consultdoc2:%String,Conresult3:%String,ConSuggestion3:%String,Consultdep3:%String,Consultdoc3:%String,Emergency:%String,EmergecyReason:%String,Predictdays:%String,ExtendEason:%String,process:%String,AuditDT,AuditUserName,KssCode,ApplyAdmDR,arcim,PAAdmType")
{
}

ClassMethod QryAntApplyInforExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Poisonjb As %String, AuditStatus As %String, ProcessType As %String, processTypeStr As %String = "", InHosp = "") As %Status
{
	n (qHandle,StDate,EndDate,Poisonjb,AuditStatus,ProcessType,%session,%request,processTypeStr,InHosp)
	//s ^TEMP("dhcant",111)=StDate_"^"_EndDate_"^"_Poisonjb_"^"_AuditStatus_"^"_ProcessType_"^"_processTypeStr
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i (StDate="")||(EndDate="") {
		Set qHandle=$lb(0,repid,0)
		Q $$$OK
	}
	
	s preAudit=$p(processTypeStr,",",1)
	s ksAudit=$p(processTypeStr,",",2)
	s lastAudit=$p(processTypeStr,",",3)
	s hasAudit=$p(processTypeStr,",",4)
	i ProcessType="" d	//兼容KSS-V4.0
	.i preAudit=1 s ProcessType="KSF"	;审核类型
	.i ksAudit=1 s ProcessType="KS"
	.i lastAudit=1 s ProcessType="LAST"
	i AuditStatus="" s AuditStatus=hasAudit
	
	i ProcessType="" {
		Set qHandle=$lb(0,repid,0)
		Q $$$OK
	}
 	s LongonDepDR=%session.Get("LOGON.CTLOCID")
 	s curLogonUser=%session.Get("LOGON.USERID")
 	s langid=..%LanguageID()
 	s curLogonHosp=InHosp
 	i curLogonHosp="" s curLogonHosp=%session.Get("LOGON.HOSPID")
 	s doctorId=##class(web.SSUser).GetDefaultCareProvider(curLogonUser)
	s StDate=##class(DHCAnt.KSS.Common.Method).DateHtmlToLogical(StDate)	//$zdh(StDate,3)
	s EndDate=##class(DHCAnt.KSS.Common.Method).DateHtmlToLogical(EndDate)	//$zdh(EndDate,3)
	
	f ApplyDate=StDate:1:EndDate  d
	.s AppRowid=0
	.f  s AppRowid=$o(^DHCDAAi("ApplyDate",ApplyDate,AppRowid))  q:AppRowid=""  d
	..s kssjb=""
	..s ApplyStatus=$p($g(^DHCDAA("ANT",AppRowid)),"^",12)
	..q:ApplyStatus="C"	//过滤撤销
	..s ApplyStatusDesc=##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PSTATUS"_ApplyStatus)
	..s ApplyStatusDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",ApplyStatusDesc,langid)
	..s processCode=$p($g(^DHCDAA("ANT",AppRowid),1),"^",33)	;流程类型
	..s process=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)	;当前流程
	..s aaLastAuditLoc=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",37)	;最终审核科室
	..q:(process["U")&&(ProcessType="LAST")&&(LongonDepDR'=aaLastAuditLoc)
	..s exitFlag=$$IsExit(AuditStatus,ProcessType,ApplyStatus,process,AppRowid)
	..q:exitFlag=1	;退出标志
	..s arcim=$p(^DHCDAA("ANT",AppRowid),"^",2)
	..s KssCode=##class(DHCAnt.KSS.Common.Method).GetKssCate(arcim)
	..;s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcim)  
	..s PoisonRowid=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(arcim)              
	..q:(Poisonjb'="")&&(KssCode'=Poisonjb)       ;判断是否是所选择的抗菌药物级别。
	..i KssCode="KSS2"   s kssjb="限制级"
	..i KssCode="KSS3"   s kssjb="特殊级"
	..i KssCode="KSS1"   s kssjb="非限制级"
	..s kssjb=##class(websys.Translation).Get("dhcant.kss.business.audit.hui.csp",kssjb)
	..s ApplyLocID=$p(^DHCDAA("ANT",AppRowid,1),"^",25)  
	..q:(ApplyLocID'=LongonDepDR)&&(ProcessType'="LAST")	;过滤科室，只显示本科室的申请信息
	..s ApplyLoc=$p(^CTLOC(ApplyLocID),"^",2)	;申请科室 
	..s ApplyLoc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ApplyLoc,langid)
	..s AppUserDr=$p(^DHCDAA("ANT",AppRowid),"^",9)   
	..s AppUser=$p(^SSU("SSUSR",AppUserDr),"^",2)	;申请医生
	..s AppUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AppUser,langid)
	..s ApplyAdmDR=$p(^DHCDAA("ANT",AppRowid),"^",1)
	..s AuditDT="",AuditUserName=""
	..s AuditUserId=$p(^DHCDAA("ANT",AppRowid,1),"^",10)     //审核人
	..i AuditUserId'="" d
	...s AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
	...s AuditUserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AuditUserName,langid)
	..s AuditDate=$p(^DHCDAA("ANT",AppRowid,1),"^",11)       //审核日期
	..s AuditTime=$p(^DHCDAA("ANT",AppRowid,1),"^",12)       //时间
	..s currentAuditInfo=##class(DHCAnt.KSS.Common.Method).GetCurrentAuditInfo(AppRowid)
	..i AuditDate'="" s AuditD=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(AuditDate)	//$zd(AuditDate,3)
	..i AuditTime'="" s AuditT=$zt(AuditTime,2)
	..i AuditDate'="" s AuditDT=AuditD_" "_AuditT  //审核时间
	..i AuditUserName="" d
	...s curAuditStatus=$p(currentAuditInfo,"^",4)
	...q:curAuditStatus="A"
	...s curAuditUser=$p(currentAuditInfo,"^",1),curAuditDate=$p(currentAuditInfo,"^",2)
	...s curAuditTime=$zt($p(currentAuditInfo,"^",3),2)
	...s curAuditDate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(curAuditDate)
	...s AuditUserName=$p(^SSU("SSUSR",curAuditUser),"^",2)
	...s AuditUserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AuditUserName,langid)
	...s AuditDT=curAuditDate_" "_curAuditTime
	..s PAAdmType=##class(DHCAnt.KSS.Common.Method).GetPAAdmType(ApplyAdmDR)
	..s authFlag=##class(DHCAnt.KSS.Common.Method).GetDoctorTypePoisonFlag(doctorId,PAAdmType,PoisonRowid,curLogonHosp)
	..q:authFlag'=1
	..s PapmiDR=$P($G(^PAADM(ApplyAdmDR)),"^",1)
	..s PatName=$p($G(^PAPER(PapmiDR,"ALL")),"^",1)	;病人姓名
	..s IsEmergency=$p(^DHCDAA("ANT",AppRowid,1),"^",23)  ;是否紧急
	..i IsEmergency=1  s Emergency="是"
	..e  s Emergency="否"
	..s Emergency=##class(websys.Translation).Get("dhcant.kss.main.hui.csp",Emergency)
	..s cOeori=$p(^DHCDAA("ANT",AppRowid,1),"^",6)  ;医嘱ID
	..q:(cOeori="")&&(IsEmergency=1)
	..s oeoriStatusDr="",oeoriStatus=""
	..i cOeori'="" s oeoriStatusDr=$p(^OEORD(+cOeori,"I",$p(cOeori,"||",2),1),"^",13)	//OEC_OrderStatus
	..i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	..;q:((oeoriStatus="U")||(oeoriStatus="C"))&&(IsEmergency=1)	;医嘱状态为撤销
	..s EmergecyReason=$p(^DHCDAA("ANT",AppRowid,1),"^",32)	;越级使用原因
	..s Appdate=$P(^DHCDAA("ANT",AppRowid),"^",10)  ;申请日期
	..s AppTime=$P(^DHCDAA("ANT",AppRowid),"^",11)  ;申请时间
	..s Appdate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(Appdate)	//$zd(Appdate,3)
	..s AppTime=$zt(AppTime,2)
	..s Appdate=Appdate_" "_AppTime
	..s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)	;药品名称
	..s arcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,langid)
	..s UseReasonID=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",20)  ;使用目的业务表id
	..s ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)
	..s UsePurpseDesc=$p(^DHCAntBasePurposeDataConfigD(ReasonID),"^",3)  ;使用目的
	..s UsePurpseDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",UsePurpseDesc,langid)
	..s OPerIndDr=$P($g(^DAUP("DAUP",UseReasonID)),"^",10)
	..s OPerIndDesc=$p(^DHCAntBasePurposeDataConfigD(OPerIndDr),"^",3)  ;指征
	..s OPerIndDesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",OPerIndDesc,langid)
	..s BodyPartDr=$p($g(^DAUP("DAUP",UseReasonID)),"^",6)      
	..s BodyPartdesc=$p(^DHCAntBasePurposeDataConfigD(BodyPartDr),"^",3) ;身体部位
	..s BodyPartdesc= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",BodyPartdesc,langid)
	..s YFtimedr=$p($g(^DAUP("DAUP",UseReasonID)),"^",22),YFtime="" 
	..i YFtimedr'="" d
	...s YFtime=$p($g(^DHCAntBasePurposeDataConfigD(YFtimedr)),"^",3)     ;预防用药时间
	...s YFtime= ##class(DHCAnt.Base.PurposeDataConfig).GetTranByDesc("PDCValue",YFtime,langid)
	..s Predictdays=$p($G(^DAUP("DAUP",UseReasonID)),"^",24)	;预计用药天数
	..s ExtendEason=$p($G(^DAUP("DAUP",UseReasonID)),"^",25)	;延长用药原因
	..;下面是会诊信息 ---->  不能省略..,否则程序不往下执行了
	..s Conresult1=""  ,ConSuggestion1=""  ,Conresult2="",ConSuggestion2="",Conresult3="",ConSuggestion3=""
	..;s Consultdep1="", Consultdep2=""     ,Consultdep3="",Consultdoc1="",Consultdoc2="",Consultdoc3=""
	..s Consultdep1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",4)
	..s Consultdep2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",27)
	..s Consultdep3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",30)
	..s Consultdoc1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",5)
	..s Consultdoc2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",28)
	..s Consultdoc3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",31)
	..i Consultdep1'="" d 
	...s Consultdep1=$p(^CTLOC(Consultdep1),"^",2)
	...i Consultdep1["-" s Consultdep1=$p(Consultdep1,"-",2)
	...s Consultdep1= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Consultdep1,langid)
	..i Consultdep2'="" d
	...s Consultdep2=$p(^CTLOC(Consultdep2),"^",2)
	...i Consultdep2["-" s Consultdep2=$p(Consultdep2,"-",2)
	...s Consultdep2= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Consultdep2,langid)
	..i Consultdep3'="" d
	...s Consultdep3=$p(^CTLOC(Consultdep3),"^",2)
	...i Consultdep3["-" s Consultdep3=$p(Consultdep3,"-",2)
	...s Consultdep3= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Consultdep3,langid)
	..i Consultdoc1'="" d
	...s Consultdoc1=$p(^CTPCP(Consultdoc1,1),"^",2)
	...s Consultdoc1= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Consultdoc1,langid)
	..i Consultdoc2'="" d
	...s Consultdoc2=$p(^CTPCP(Consultdoc2,1),"^",2)
	...s Consultdoc2= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Consultdoc2,langid)
	..i Consultdoc3'="" d
	...s Consultdoc3=$p(^CTPCP(Consultdoc3,1),"^",2)
	...s Consultdoc3= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Consultdoc3,langid)
	..i process["H"   d          ;判断审批流程中是否需要会诊
	...s ConsultationID1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",22)
	...i ConsultationID1'=""    d
	....s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID1)
	....s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	....q:conInfoDoc=""
	....s ConSuggestion1=conInfoNote
	....s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID1)
	....i agreeInfo="Y" s Conresult1="同意"
	....i agreeInfo="N" s Conresult1="拒绝"
	
	...s ConsultationID2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",26)
	...i ConsultationID2'=""    d
	....s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID2)
	....s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	....q:conInfoDoc=""
	....s ConSuggestion2=conInfoNote
	....s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID2)
	....i agreeInfo="Y" s Conresult2="同意"
	....i agreeInfo="N" s Conresult2="拒绝"
	
	...s ConsultationID3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",29)
	...i ConsultationID3'=""    d
	....s conInfo=##Class(web.DHCEMConsInterface).GetAntiConsultInfo(ConsultationID3)
	....s conInfoDoc=$p(conInfo,"^",2),conInfoDep=$p(conInfo,"^",1),conInfoNote=$p(conInfo,"^",3)
	....q:conInfoDoc=""
	....s ConSuggestion3=conInfoNote
	....s agreeInfo=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID3)
	....i agreeInfo="Y" s Conresult3="同意"
	....i agreeInfo="N" s Conresult3="拒绝"
	
	..d OutputRow2
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IsExit(auditStatus,processType,applyStatus,process,appRowid)
	n (auditStatus,processType,applyStatus,process,appRowid)
	s rtn=1	;退出标志,默认退出
	s rStep=##class(DHCAnt.KSS.Common.Method).GetRefuseStep(appRowid)	;拒绝步骤
	
	i (auditStatus="")||(auditStatus=0)  d 	;未审核
	.i processType="KSF" d
	..i (applyStatus="A")&&(process["F") s rtn=0
	.i processType="KS"   d
	..i process["S" d
	...i process["H" d
	....i applyStatus="H" s rtn=0	; A F H S 、A H S 
	...e  i process["F" d 			
	....i applyStatus="F" s rtn=0	; A F S、A S 
	...e  d
	....i applyStatus="A" s rtn=0
	.i processType="LAST"   d
	..i process["U" d
	...i process["S" d
	....i applyStatus="S" s rtn=0
	...e  i process["H" d
	....i applyStatus="H" s rtn=0
	...e  i process["F" d
	....i applyStatus="F" s rtn=0
	...e  d
	....i applyStatus="A" s rtn=0
	
	e  d	;已审核
	.i processType="KSF" d
	..i (applyStatus'="A")&&(process["F")  s rtn=0
	.i processType="KS"  d
	..i process["S"	d	//A S 、
	...i (applyStatus="S")||(applyStatus="U") s rtn=0	//||(applyStatus="R")
	...i (applyStatus="R") d
	....i (rStep="SR")||(rStep="UR") s rtn=0
	.i processType="LAST"  d
	..i process["U"	d	//A S 、
	...i (applyStatus="U") s rtn=0	//||(applyStatus="R")
	...i (applyStatus="R") d
	....i rStep="UR" s rtn=0
	
	q rtn

OutputRow2
	s Data=$ListBuild(AppRowid,ApplyStatus,ApplyStatusDesc,PatName,kssjb,arcimDesc,ApplyLoc,AppUser,Appdate,UsePurpseDesc,OPerIndDesc,BodyPartdesc,YFtime,Conresult1,ConSuggestion1,Consultdep1,Consultdoc1,Conresult2,ConSuggestion2,Consultdep2,Consultdoc2,Conresult3,ConSuggestion3,Consultdep3,Consultdoc3,Emergency,EmergecyReason,Predictdays,ExtendEason,process,AuditDT,AuditUserName,KssCode,ApplyAdmDR,arcim,PAAdmType)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1	
	q
}

ClassMethod QryAntApplyInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntApplyInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntApplyInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntApplyInforExecute ]
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

/// CTOR: QP
/// DATE: 2016-08-22
/// DESC: 抗生素审核
/// IN  : processtype:KSF/KS
/// 		action: SH/RU (审核/拒绝)
/// 			execUser:用于portal中
/// OUT : 成功返回0
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).VerifyApply("1103","KSF","SH")
ClassMethod VerifyApply(appItemStr As %String, processtype As %String, action As %String, execUser As %String = "") As %String
{
	n (appItemStr,processtype,action,execUser,%session)
	s ^TEMP("DHCAnt","Quinn",11)=appItemStr_": "_processtype_": "_action
	q:processtype="" -100
	i execUser'="" s UserID=execUser
	e  s UserID=%session.Get("LOGON.USERID")
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	s Err=0
	
	TSTART
 	s Len=$l(appItemStr,"^")
 	f i=1:1:Len q:Err'=0  d
 	.s AppRowid=$p(appItemStr,"^",i)
 	.s appstatu=$p(^DHCDAA("ANT",AppRowid),"^",12)	//当前状态
 	.s Process=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)	;当前流程
 	.s processLen=$l(Process,",")	;流程长度
 	.;s Procode=$p(Process,"^",3)
 	
 	.;初始化
 	.s resultStatus=0,logStatus=0,consultStatus=0,updatestatus="",logPara="",consultNums=0
 	.i action="SH"    D
 	..i processtype="KSF"  d
 	...q:Process'["F"
 	...q:appstatu'="A"
 	...i (Process["H")||(Process["S")||(Process["U") d
 	....s updatestatus="F",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	....s resultStatus=..DBUpdateAuditStatus("normal",logPara)
 	....i resultStatus'=0 s Err=resultStatus Q 	//
 	....s logStatus=..DBInsertKSSLog("ADD",logPara)
 	....i logStatus'=0 s Err=logStatus Q
 	....i Process["H" d
 	.....s consultNums=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",35)	;会诊科室个数
 	.....q:(consultNums="")||(consultNums=0)
 	.....s consultResult=##class(DHCAnt.KSS.MainBusiness).DBCreateConsultationApply(AppRowid,consultNums)
    .....;s consultStatus=$p(consultResult,"^",1)
    .....s ConsultID1=$p(consultResult,"^",2)
    .....s ConsultID2=$p(consultResult,"^",3)
    .....s ConsultID3=$p(consultResult,"^",4)
    .....i (ConsultID1="") s Err="-101"	//会诊表记录插入失败
   	.....q:Err'=0
   	.....s consultPara=ConsultID1_"^"_ConsultID2_"^"_ConsultID3_"^"_AppRowid
   	.....s consultStatus=..DBUpdateConsultDR(consultPara)
    .....i consultStatus'=0 s Err=consultStatus Q
    ....i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"F",UserID)
 	...e  d
 	....s updatestatus="U",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	....s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	....i resultStatus'=0 s Err=resultStatus Q 	//
 	....s logStatus=..DBInsertKSSLog("ADD",logPara)
 	....i logStatus'=0 s Err=logStatus Q 
 	....i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"U",UserID)
 	
 	..i processtype="KS"  d 
 	...q:(appstatu="U")||(Process'["S")
 	...q:(Process["H")&&(appstatu'="H")
 	...q:(Process["F")&&(Process'["H")&&(appstatu'="F")	; A F S 
 	...q:(Process'["F")&&(Process'["H")&&(appstatu'="A") ; A S
 	...i (Process'["U") d
  	....s updatestatus="U",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	....s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	....i resultStatus'=0 s Err=resultStatus Q 	//
 	....s logStatus=..DBInsertKSSLog("ADD",logPara)
 	....i logStatus'=0 s Err=logStatus Q 
 	....i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"U",UserID)
 	...e  d
 	....s updatestatus="S",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	....s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	....i resultStatus'=0 s Err=resultStatus Q 	//
 	....s logStatus=..DBInsertKSSLog("ADD",logPara)
 	....i logStatus'=0 s Err=logStatus Q 
 	....i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"S",UserID)
 	
 	..i processtype="LAST"  d
 	...q:(Process'["U")
 	...q:(Process["S")&&(appstatu'="S")
 	...q:(Process["H")&&(Process'["S")&&(appstatu'="H")
 	...q:(Process["F")&&(Process'["S")&&(Process'["H")&&(appstatu'="F")
 	...q:(Process["A")&&(Process'["S")&&(Process'["H")&&(Process'["F")&&(appstatu'="A")
 	...s updatestatus="U",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	...i resultStatus'=0 s Err=resultStatus Q 	//
 	...s logStatus=..DBInsertKSSLog("ADD",logPara)
 	...i logStatus'=0 s Err=logStatus Q 
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"U",UserID)
 	
 	.i action="RU"    d
 	..i processtype="KSF"  d
 	...q:Process'["F"
 	...q:appstatu'="A"
 	...s updatestatus="R",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	...i resultStatus'=0 s Err=resultStatus Q 	//
 	...s logStatus=..DBInsertKSSLog("ADD",logPara)
 	...i logStatus'=0 s Err=logStatus Q 
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"R",UserID)
 	
 	..i processtype="KS"  d
 	...q:(appstatu="U")||(Process'["S")||(appstatu="R")
 	...q:(Process["H")&&(appstatu'="H")
 	...q:(Process["F")&&(Process'["H")&&(appstatu'="F")
 	...q:(Process'["F")&&(Process'["H")&&(appstatu'="A")
 	...s updatestatus="R",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	...i resultStatus'=0 s Err=resultStatus Q 	//
 	...s logStatus=..DBInsertKSSLog("ADD",logPara)
 	...i logStatus'=0 s Err=logStatus Q 
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"R",UserID)
 	
 	..i processtype="LAST"  d
 	...q:(appstatu="U")||(Process'["U")||(appstatu="R")
 	...q:(Process["S")&&(appstatu'="S")
 	...q:(Process["H")&&(Process'["S")&&(appstatu'="H")
 	...q:(Process["F")&&(Process'["H")&&(Process'["S")&&(appstatu'="F")
 	...q:(Process'["F")&&(Process'["H")&&(Process'["S")&&(appstatu'="A")
 	...s updatestatus="R",logPara=AppRowid_"^"_UserID_"^"_CurrentDate_"^"_CurrentTime_"^"_updatestatus
 	...s resultStatus=..DBUpdateAuditStatus("finally",logPara)
 	...i resultStatus'=0 s Err=resultStatus Q 	//
 	...s logStatus=..DBInsertKSSLog("ADD",logPara)
 	...i logStatus'=0 s Err=logStatus Q 
 	...i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AppRowid,Process,"R",UserID)
	
 	i Err'=0 {
		TROLLBACK 	
		q Err
	}
 	TCOMMIT
 	
 	q Err
}

/// QP FIX 
/// 2017-03-15
/// 从web.DHCDocAntiCommon迁移
/// Description:  得到医护类型。
/// w ##class(DHCAnt.KSS.MainBusiness).GetCareType(162)
ClassMethod GetCareType(Userid As %String)
{
	n (Userid)
	s find=0
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(Userid)
	s CareProvType=$zcvt(CareProvType,"U")
	i (CareProvType="DOCTOR") s find=1
	q find
}

/// QP FIX 
/// 2017-03-15
/// 从 web.DHCDocAntibioticReason 迁移
/// 得到审核后24小时内的医嘱
/// debug:  w ##class(DHCAnt.KSS.MainBusiness).GetAuditApplyInfo("25","")
ClassMethod GetAuditApplyInfo(episodeid As %String, userid As %String) As %String
{
	Q:$G(episodeid)="" ""
	S ret=""
	S AARowid=0,seqno=0
	for  s AARowid=$o(^DHCDAAi("AdmDR",episodeid,AARowid))  q:AARowid=""  d
	.s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
	.s ArcImName=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)  //医嘱名称
	.s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
	.s IsEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
	.q:IsEmergency=1 //no tip
	.s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
	.;q:AppDate'=+$h
	.s AppUserDr=$p(^DHCDAA("ANT",AARowid),"^",9)
	.q:AppUserDr'=userid
	.s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
	.s OeorderID=$p(^DHCDAA("ANT",AARowid,1),"^",6)
	.q:OeorderID'=""
	.S curdate=+$H,curtime=$P($h,",",2)
	.s curTime=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	.s applyTime=##class(DHCAnt.KSS.Common.Method).GetAbsTime(AppDate_","_AppTime)
	.s LimTime=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("APPTIME")
	.q:(curTime>(applyTime+(3600*LimTime)))            
	.if ConsultDR'=""  d
	..Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,episodeid,curdate,curtime)
	..Q:ConResult'=1         ;未同意的会诊 退出
	.s AppStatus=$p(^DHCDAA("ANT",AARowid),"^",12)
	.q:AppStatus'="U"
	.s seqno=seqno+1
	.if ret="" d
	..s ret=ArcImName_"^"_arcim_"^"_seqno
	.e  d  
	..s ret=ret_"&"_ArcImName_"^"_arcim_"^"_seqno
	q ret
}

/// QP FIX 
/// 2017-03-15
/// oeorder.oplistcustom.new.csp 中 DeleteAntibApplyMethod
/// 从web.DHCDocOrderCommon 迁移 
/// desc:删除管制药品申请
/// table:
ClassMethod DeleteAntibApply(AntibApplyRowid As %String) As %String
{
	&sql(Delete From SQLUser.DHC_Doc_AntibioticApply where AA_Rowid=:AntibApplyRowid)
	Q SQLCODE
}

/// QP FIX 
/// 2017-03-15
/// 从web.DHCDocOrderCommon迁移
/// oeorder.oplistcustom.new.csp 中 DeleteAntReasonMethod
/// desc:删除管制药品使用目的
/// table:
ClassMethod DeleteAntReason(AntReasonId As %String) As %String
{
	&sql(Delete From SQLUser.DHC_AntUsePurpose where DAUP_Rowid=:AntReasonId)
	Q SQLCODE
}

/// QP FIX 
/// 2017-03-15
/// 从web.DHCDocAntiCommon迁移 
/// oeorder.oplistcustom.new.csp 中 CheckSusceptMethod
/// 检查病人是否对【arcim】该药品耐药
/// return：'0'或"" 否，'1' 是
/// debug :  w ##class(DHCAnt.KSS.MainBusiness).CheckIsSuscept("25","614||1")
ClassMethod CheckIsSuscept(Episodeid As %String, Arcim As %String)
{
	Q:$g(Episodeid)="" ""
	s find=0
	Set SusceptStr=##class(web.DHCLabGerm).GetAllSenResbyEpisID(Episodeid)
	Set len=$l(SusceptStr,"!")
	for i=1:1:len do
	.s Suscept=$p(SusceptStr,"!",i)
	.s code=$p(Suscept,"^",12)
	.s SenDesc=$p(Suscept,"^",8)
	.q:SenDesc'["耐药"
	.s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(Arcim)
	.if DrgformRowid'="" d
	..s whonet=$p(^PHCD(+DrgformRowid,"DF",$P(DrgformRowid,"||",2),"DHC"),"^",10)
	..q:whonet'=code
	..s find=1
	q find
}

/// QP FIX 
/// 2017-03-15
/// 从web.DHCDocAntiCommon迁移 
/// oeorder.oplistcustom.new.csp 中 CheckInDurSameIMMethod
/// 在疗程内的抗菌药物不在弹出登记表 同时建立使用目的
/// debug : w ##class(DHCAnt.KSS.MainBusiness).CheckInDurSameIM("25","870||1")
ClassMethod CheckInDurSameIM(Episodeid As %String, Arcim As %String)
{
	Q:$g(Episodeid)="" 0_"^"
	s flag=0_"^"
	s AArowid=""
	f  s AArowid=$O(^DHCDAAi("AdmDR",Episodeid,AArowid))  Q:AArowid=""  D
	.s OrderDays=$p(^DHCDAA("ANT",AArowid,1),"^",21)    ;预计疗程
	.s IMRowid=$p(^DHCDAA("ANT",AArowid),"^",2)
	.q:IMRowid'=Arcim
	.s oeori=$p(^DHCDAA("ANT",AArowid,1),"^",6) 
	.i oeori=""  s flag=1_"^"
	.if (oeori'="")  d
	..s OrderDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",7)    
	..s date=OrderDate+OrderDays
	..s curdate=+$h
	..;s OrderTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",15) 
	..if curdate<date  s flag=2
	..if flag=2  d 
	...s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose(oeori)
	...s flag=2_"^"_$p(ret,"^",2)
	q flag
}

/// QP FIX 
/// 2017-03-15
/// 从web.DHCDocAntiCommon迁移 
/// oeorder.oplistcustom.new.csp 中 ReasonCanBeDeletedMethod
/// DATE  :2012-12-27
/// OUTPUT: "1"可以     "0"不可以
ClassMethod ReasonCanBeDeleted(UserReasonID As %String)
{
	n (UserReasonID)
	s DelFlag=1
	s Episodeid=$p(^DAUP("DAUP",UserReasonID),"^",2)
	Q:Episodeid="" DelFlag
	S AArowid=""
	f  s AArowid=$o(^DHCDAAi("AdmDR",Episodeid,AArowid))  Q:AArowid=""  D
	.S reasonid=$p(^DHCDAA("ANT",AArowid,1),"^",20)
	.;I reasonid=UserReasonID  S DelFlag=0
	Q DelFlag
}

/// Creator:      zsz
/// CreatDate:    2017.03.13
/// Description:: 得到医护人员可以操作的管制级别
/// Table:        CT_CareProv,CT_CarPrvTp,CarPrvTpPHPoison
/// Input:        
/// Output:         
/// Return:       以"^"分隔的管制分类指针字符串
/// Example        w ##class(DHCAnt.KSS.MainBusiness).GetDoctorTypePoisonStrNew("1","I","2")
ClassMethod GetDoctorTypePoisonStrNew(DoctorID As %String, PAAdmType As %String, InHosp = "") As %String
{
	n (DoctorID,PAAdmType,InHosp,%session)
	s ^TEMP("GetDoctorTypePoisonStrNew",111)=$LB(DoctorID,PAAdmType,InHosp)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	if (DoctorID="")||(InHosp="") Q ""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	;处理处方权
	s MCGCode="F"_DoctorID
	s MCGID=""
	;s MCGID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	s MCGID=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",InHosp,MCGCode,""))
	s MCGvalue=1
	i MCGID'="" d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.i MCGactive=1 d
	..s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    ..s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    ..q:(DateTo<+$h)||(DateFrom>+$h)
	..s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	q:MCGvalue=0 ""
	
    s AUTHTODOC=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC",InHosp)
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:Child=""  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s HospId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",5)
	.;q:(HospId'=InHosp)&&(InHosp'="")
	.q:HospId'=InHosp
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)
	.q:TPPEpisodeType'=PAAdmType
	.i AUTHTODOC=1 s AntPrescBility="N"
	.e  s AntPrescBility="Y"
	.i $d(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child)) d
	..s rowid=$o(^CT(0,"CPDR",DoctorID,DoctorTypeRowId,Child,""))
	..s AntPrescBility=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",5)
	..s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child,"CP",rowid),"^",8)
	.q:AntPrescBility'="Y"
	.i ret="" s ret=PoisonRowId_$C(1)_ControlType
	.e  s ret=ret_"^"_PoisonRowId_$C(1)_ControlType 
	Q ret
}

/// CTOR: QP
/// DATE: 2017-08-14
/// DESC: 发送抗菌药物越级消息信息
/// IN  : order："BaseInfo,Kss3Indication,Zbj,UsedrugTime,Apply,Consult"
/// 	  para:   order对应的信息串
/// OUT : 1^UseAimRowid
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).ComSendEmergencyMsg("")
ClassMethod ComSendEmergencyMsg(aaidStr As %String, InHosp = "") As %String
{
	n (aaidStr,InHosp,%session,%request,%response)
	s mRtn=0
	q:aaidStr="" mRtn
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip(InHosp)
	
	s aaLen=$l(aaidStr,"^") d
	f i=1:1:aaLen d
	.s AARowid=$p(aaidStr,"^",i)
	.s msgFlag=##class(DHCAnt.KSS.Common.Method).GetSendMsgType(AARowid)
	.q:msgFlag'=2
	.s curProcess=$p(^DHCDAA("ANT",AARowid,1),"^",36)
	.i (curProcess'["F") s result=..DBSaveEmergencyConsult(AARowid)
	.//下版进行日志记录,暂时不进行日志记录 QP
	.i enableMsgTip=1 s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(AARowid,curProcess,"A",%session.Get("LOGON.USERID"))
    
    Q 1
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 得到抗菌素申请单的状态
/// 	  1  申请状态  0 已审核  -1  此医嘱没有对应的申请单
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetAntStatusForNurse("1110")
ClassMethod GetAntStatusForNurse(ConsultDR As %String)
{
	n (ConsultDR)
	q:ConsultDR="" -1
	s AppRowid=$o(^DHCDAAi("Consult",ConsultDR,0))
	q:AppRowid="" -1
	s Process=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)
	q:Process'["H" -1
	s mRtn=1
	s Status=$p(^DHCDAA("ANT",AppRowid),"^",12)
	q:(Status'="U")&&(Status'="R")&&(Status'="S") 1	//此时允许撤销
	s oeori=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",6)
	q:oeori'="" 0	//形成医嘱不让撤销
	s refuseStep=""
	i Status="R" {
		s refuseStep=##class(DHCAnt.KSS.Common.Method).GetRefuseStep(AppRowid)	
	}
	i (Process["S")||(Process["U") d 
	.Q:refuseStep="HR"	//会诊步骤拒绝是可以撤销得
	.s mRtn=0	//会诊得下一步骤不允许撤销
	
	;i (Status="U")||(Status="R")||(Status="S") s mRtn=0
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-01-14
/// DESC: 给【新产品组】会诊执行接口
/// IN  : action: normal/finally
/// 	  para:   
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).RefuseConsult()
ClassMethod RefuseConsult(consultId As %String, consuid As %String, statusCode As %String) As %String
{
	n (consultId,consuid,statusCode,%session,%request,%response)
	
	s Err=0
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	q:(consultId="")||(consuid="") Err
	q:'$d(^DHCDAAi("Consult",consultId)) Err
	s aaRowid=$o(^DHCDAAi("Consult",consultId,""))
	q:aaRowid="" Err
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	i $d(%session) s currUserId=%session.Get("LOGON.USERID")	//处理Portal无法获取Session
	e  s currUserId=consuid
	TSTART
	
	s consultId1="",consultId2="",consultId3=""
	s consultDepNums=$p(^DHCDAA("ANT",aaRowid,1),"^",35)
	s Err=0,resultStatus=0,logStatus=0,auditDoc=""
	s curProcess=$p(^DHCDAA("ANT",aaRowid,1),"^",36)	//当前流程
	i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).ComExecConsultMsg(aaRowid,consuid,statusCode)
	
	s logPara=aaRowid_"^"_consuid_"^"_CurrentDate_"^"_CurrentTime_"^"_"R"
	s resultStatus=..DBUpdateAuditStatus("finally",logPara)
	i resultStatus'=0 s Err=resultStatus
	i logStatus=..DBInsertKSSLog("ADD",logPara)
	i logStatus'=0 s Err=logStatus
	i (Err=0)&&(enableMsgTip=1) s msgTipFlag=##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip(aaRowid,curProcess,"R",currUserId)
	
 	i Err'=0 {
		TROLLBACK
		q "-503"	//更新会诊状态失败
	}
 	TCOMMIT
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2020-05-21
/// DESC: 有无抗菌药物权限【包含功能配置和权限管理部分】
/// IN  : 
/// OUT : 0:没有权限，1：有权限，2：没有权限但已完申请流程，且申请流程在有效时间内，3：权限为越级，4：权限为申请单
/// 	  格式：0_$C(1)_msg
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).HasAntAuth()
ClassMethod HasAntAuth(UserID, ArcimID, PAAdmType, InHosp, EpisodeID, AuditFlag) As %String
{
	n (UserID,ArcimID,PAAdmType,InHosp,EpisodeID,AuditFlag)
	
	s noMsg="0",okMsg="1",auMsg="2",emMsg="3",appMsg="4"
	;开关判断
	s Phpo=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(ArcimID)
	q:Phpo="" okMsg_$C(1)_""
	s PhpoCode=$p(^PHCPO(Phpo),"^",1)
	s PhpoCode=$zcvt(PhpoCode,"U") 
	q:PhpoCode'["KSS" okMsg_$C(1)_""		;不为抗菌药物不做控制，默认Y
	s NoControl=##class(DHCAnt.KSS.Config.PoisonSet).ValidatePhpo(InHosp,Phpo,PAAdmType)
	q:NoControl=1 okMsg_$C(1)_""			;抗菌药物开关没有开启/没有纳入管控范围，不做控制，默认Y
	
	;权限判断
	s InDocId=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare(UserID)
	Q:InDocId="" noMsg_$C(1)_"医护人员ID不存在！"					;医护人员ID不存在，默认N
	s UserAuthStr=##class(DHCAnt.KSS.MainBusiness).GetDoctorTypePoisonStrNew(InDocId,PAAdmType,InHosp)
	
	s UserAuth=##class(DHCAnt.KSS.Common.Method).GetArrayItem(UserAuthStr,"^",Phpo)

	q:UserAuth="" noMsg_$C(1)_"医生抗菌药物权限没有配置！"		;医生权限没有配置, 默认为禁止，应为N
	s UserAuth=$p(UserAuth,$C(1),2)
	
	i (UserAuth="F") {
		q noMsg_$C(1)_"抗菌药物权限为禁止！"			;权限为禁止
	} elseif (UserAuth="A") {
		q okMsg_$C(1)_""								;权限为提示
	} elseif (UserAuth="E") {
		s isE=##class(DHCAnt.KSS.FunctionExtend).EMNumsControl(EpisodeID,ArcimID,UserID,InHosp)	
		q:isE=0 noMsg_$C(1)_"抗菌药物越级次数超过，不能再次越级！"		;越级次数超过，不能越级
		;s hasAudit=..HasAudit(UserID, ArcimID, InHosp, EpisodeID)
		;q:hasAudit=1 auMsg_$C(1)_"审核通过，且申请流程在有效时间内"	
		;审核标志判断(从申请列表里选择)
		if (AuditFlag=1) {
			q auMsg_$C(1)_"审核通过！"
		}
		q emMsg_$C(1)_"权限为越级"
		
	} elseif (UserAuth="P") {
		;审核标志判断(从申请列表里选择)
		if (AuditFlag=1) {
			q auMsg_$C(1)_"审核通过！"
		}
		;s hasAudit=..HasAudit(UserID, ArcimID, InHosp, EpisodeID)
		;q:hasAudit=1 auMsg_$C(1)_"审核通过，且申请流程在有效时间内"
		q appMsg_$C(1)_"权限为申请单"
		
		
	} else {
		Q noMsg_$C(1)_"无权限"
	}
	
	;二次申请，暂时不做判断
	Q noMsg_$C(1)_"无权限"
}

/// CTOR: QP
/// DATE: 2020-05-21
/// DESC: 判断某个抗菌药物是否已经审核通过
/// IN  : 
/// OUT : 1/0
/// EXEC:  w ##class(DHCAnt.KSS.MainBusiness).HasAntAuth()
ClassMethod HasAudit(UserID, ArcimID, InHosp, EpisodeID) As %String
{
	n (UserID,ArcimID,InHosp,EpisodeID)
	
	s AARowid="",TempFlag=0,TempDaupid=""
	;有效时间(h)
	s APPTIME=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("APPTIME")
	;越级是否可以从申请列表中选择, 0 - 不让，1 - 让
	s EmAgain=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EMAGAIN",InHosp)
	for {
		s AARowid=$o(^DHCDAAi("ApplyUser",UserID,AARowid))
		q:(AARowid="")||(TempFlag=1)
		s admid=$p(^DHCDAA("ANT",AARowid),"^",1)
		continue:EpisodeID'=admid
		s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
		continue:ArcimID'=arcim
		s oeori=$p(^DHCDAA("ANT",AARowid,1),"^",6)
		s IsEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
		s status=$p(^DHCDAA("ANT",AARowid),"^",12)
		continue:status'="U"
		s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",11)
		s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",12)
		continue:AuditDate=""
		s AuditFinisDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(AuditDate_","_AuditTime)
		s CurDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h) 
		;超时
		continue:((CurDT-AuditFinisDT) > (APPTIME*3600))
		;越级未超时，但是EMAGAIN配置的为0
		continue:((CurDT-AuditFinisDT) < (APPTIME*3600))&&(IsEmergency=1)&&(EmAgain=0)
		s TempDaupid=$p(^DHCDAA("ANT",AARowid,1),"^",20)
		s TempFlag=1
	
	}
	
	Q TempFlag
}

}
