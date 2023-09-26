Class web.DHCEMSignVerify Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:      panshuai
/// Date:         2012-07-13
/// Description:  获取执行信息主要信息
/// w ##class(web.DHCEMSignVerify).GetItemXML("86||2","MDT","F","")
ClassMethod GetItemXML(DataRowId As %String, ModuleMark As %String, OperationType = "", OtherParams = "") As %String
{
	n (DataRowId,ModuleMark,OperationType,OtherParams)
	q:DataRowId="" ""
	
	d:ModuleMark="EXEC" ..GetOrdDataXML(DataRowId,OperationType,OtherParams,.RetXML)
	d:ModuleMark="MDT" ..GetMdtDataXML(DataRowId,OperationType,OtherParams,.RetXML)
	q RetXML
}

/// creator:      qqa
/// Date:         2021-06-03
/// Description:  执行信息主要信息转换XML格式
/// w ##class(web.DHCNurSignVerify).GetOEOREMainXML()
ClassMethod GetOrdDataXML(OrdExecId As %String, OperationType As %String = "", OtherParams = "", ByRef OEOREMainXML As %String = "") As %String
{
	n (OrdExecId,OperationType,OtherParams,OEOREMainXML)
	
	
	s OeordId=$P(OrdExecId,"||",1)
	s OeoriSub=$P(OrdExecId,"||",2)
	s OeoreSub=$P(OrdExecId,"||",3)	
	s ordstr1=$g(^OEORD(OeordId,"I",OeoriSub,1))
	s ordstr2=$g(^OEORD(OeordId,"I",OeoriSub,2))
	s ordstr3=$g(^OEORD(OeordId,"I",OeoriSub,3))
	s ordstr5=$g(^OEORD(OeordId,"I",OeoriSub,5))
	s ordstr7=$g(^OEORD(OeordId,"I",OeoriSub,7))
	s ordstr9=$g(^OEORD(OeordId,"I",OeoriSub,9))
	s ordstr11=$g(^OEORD(OeordId,"I",OeoriSub,11))
	s ExecType=$p(OtherParams,"^",1)
	s ExecStatusId=$p($g(^OEORD(OeordId,"I",OeoriSub,"X",OeoreSub)),"^",16) //执行状态
	s ExecStatDesc=$p($g(^OEC("STAT",+ExecStatusId)),"^",2)  ;执行状态
	s ExecNotes=$g(^OEORD(OeordId,"I",OeoriSub,"SKINPC",1))
	s ExecDate=$p($g(^OEORD(OeordId,"I",OeoriSub,"X",OeoreSub)),"^",19) ;执行日期
	s ExecTime=$p($g(^OEORD(OeordId,"I",OeoriSub,"X",OeoreSub)),"^",20) ;执行时间
	s:ExecDate="" ExecDate=+$H
	s:ExecTime="" ExecTime=$p($H,",",2)
	s ExecDate=$zd(ExecDate,3)
	s ExecTime=$zt(ExecTime,2)
	s ExecCTPCP=$p($g(^OEORD(OeordId,"I",OeoriSub,"X",OeoreSub)),"^",15)
	s ExecUser=$p($g(^CTPCP(+ExecCTPCP,1)),"^",2)	;执行人
	
	;主要信息
	s Priority=$p(ordstr1,"^",8)	     ;医嘱优先级
	s:Priority'="" Priority=$p($G(^OECPR(Priority)),"^",2)
	s ArcimId=$p(ordstr1,"^",2)		     ;医嘱名称
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	s ArcimDesc=$p($G(^ARCIM(ArcimId1,ArcimId2,1)),"^",2)
	s DoseQty=$p(ordstr2,"^",1)		     ;单次剂量
	s DoseUnit=$p(ordstr2,"^",3)	     ;单次剂量单位
	s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),"^",2)
	s Freq=$p(ordstr2,"^",4)	         ;频次
	s:Freq'="" Freq=$P($G(^PHCFR(Freq)),"^",2)
	s Instr=$p(ordstr2,"^",7)			 ;用法
	s:Instr'="" Instr=$P($G(^PHCIN(Instr)),"^",2)
	
	s PrescNo=$p(ordstr1,"^",14)	     ;处方号
	s OrdStatus=$p(ordstr1,"^",13)       ;医嘱状态
	s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",2)
	s UserDepartment=$p(ordstr7,"^",2)	 ;开单科室
	s:UserDepartment'="" UserDepartment=$p(^CTLOC(UserDepartment),"^",2)
	s RecDep=$p(ordstr3,"^",6)			 ;接收科室
	s:RecDep'="" RecDep=$p(^CTLOC(RecDep),"^",2)
	s Doctor=$p(ordstr1,"^",11)		     ;下医嘱医生
	s:Doctor'="" Doctor=$p($g(^CTPCP(Doctor,1)),"^",1)
	;备注
	f Rnum=1:1:$g(^OEORD(OeordId,"I",OeoriSub,"DEP",0))  d
	.s Notes=$g(Notes)_$g(^OEORD(OeordId,"I",OeoriSub,"DEP",Rnum))
	
	s PhQtyOrd=$p(ordstr1,"^",12)	 ;总量
	s BillUOM=$p($g(^ARCIM(ArcimId1,ArcimId2,8)),"^",14) ; 整包娤单位
	s:BillUOM'="" BillUOM=$p($g(^CT("UOM",BillUOM)),"^",2)
	
	s Dura=$p(ordstr2,"^",6)			 ;疗程
	s:Dura'="" Dura=$p($G(^PHCDU(Dura)),"^",2)
	s LabEpisodeNo=$p(ordstr3,"^",20) 	;标本号
	s OrdSkinTest=$p(ordstr5,"^",2)	  	;皮试

	s UseAdd=$p(ordstr7,"^",1)		;下医嘱用户
	s:UseAdd'="" UseAdd=$p($g(^SSU("SSUSR",UseAdd)),"^",1)
	s OrdCreateDate=$p(ordstr3,"^",7)    ;下医嘱日期
	s:OrdCreateDate'="" OrdCreateDate=$zd(OrdCreateDate,3)
	s OrdCreateTime=$p(ordstr1,"^",17)   ;下医嘱时间
	s:OrdCreateTime'="" OrdCreateTime=$zt(OrdCreateTime,2)
	
	s StopDoctor=$p(ordstr3,"^",29)		;停医嘱人
	s:StopDoctor'="" StopDoctor=$p($g(^CTPCP(StopDoctor,1)),"^",1)
	s StopDate=$p(ordstr3,"^",34) 		;停医嘱日期
	s:StopDate'="" StopDate=$zd(StopDate,3)
	s StopTime=$p(ordstr2,"^",15) 		;停医嘱时间
	s:StopTime'="" StopTime=$zt(StopTime,2)
	
	s OrdStartDate=$p(ordstr1,"^",9)     ;医嘱开始日期
	s:OrdStartDate'="" OrdStartDate=$zd(OrdStartDate,3)
	s OrdStartTime=$p(ordstr1,"^",10)    ;医嘱开始时间
	s:OrdStartTime'="" OrdStartTime=$zt(OrdStartTime,2)
	
	i OeoreSub'="" d 
	.s oreStr=^OEORD(OeordId,"I",OeoriSub,"X",OeoreSub)
	.s OrdStartDate=$p(oreStr,"^",1)
	.i OrdStartDate'="" s OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(oreStr,"^",2)
	.i OrdStartTime'="" s OrdStartTime=$zt(OrdStartTime,2)
	
	s OEOREMainXML=""
	s Object=##class(web.DHCEMEntityExecInfo).%New()
	s Object.Priority=Priority
	s Object.ArcimDesc=ArcimDesc
	s Object.DoseQty=DoseQty
	s Object.DoseUnit=DoseUnit
	s Object.Freq=Freq
	s Object.Instr=Instr
	s Object.PrescNo=PrescNo
	s Object.OrdStatus=OrdStatus
	s Object.UserDepartment=UserDepartment
	s Object.RecDep=RecDep
	s Object.Doctor=Doctor
	s Object.Notes=$g(Notes)
	s Object.PhQtyOrd=PhQtyOrd
	s Object.BillUOM=BillUOM
	s Object.Dura=Dura
	s Object.LabEpisodeNo=LabEpisodeNo
	s Object.OrdSkinTest=OrdSkinTest
	s Object.UseAdd=UseAdd
	s Object.OrdCreateDate=OrdCreateDate
	s Object.OrdCreateTime=OrdCreateTime
	s Object.StopDoctor=StopDoctor
	s Object.StopDate=StopDate
	s Object.StopTime=StopTime
	s Object.OrdStartDate=OrdStartDate
	s Object.OrdStartTime=OrdStartTime
	s Object.ExecStatDesc=ExecStatDesc
	s Object.ExecNotes=ExecNotes
	s Object.ExecDat=ExecDate
	s Object.ExecTim=ExecTime
	s Object.ExecUser=ExecUser
	s Object.ExecType=ExecType
	d Object.XMLExportToString(.OEOREMainXML)	
	q OEOREMainXML
}

/// creator:      qqa
/// Date:         2022-11-15
/// Description:  执行信息主要信息转换XML格式
/// w ##class(web.DHCEMSignVerify).GetMdtDataXML("1||1","","F")
ClassMethod GetMdtDataXML(MdtConsItemId As %String, OperationType As %String = "", OtherParams = "", ByRef MDTMainXML As %String = "") As %String
{
	n (MdtConsItemId,OperationType,OtherParams,MDTMainXML)
	
	s ID=$P(MdtConsItemId,"||",1)
	s CH=$P(MdtConsItemId,"||",2)
	s ExecType=$p(OtherParams,"^",1)
	
	s IsCstUser = "",IsCsUser=""
	s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex) 					/// 多语言支持
	s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 			///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  											/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  					/// 多语言支持
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    									/// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
   	s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      									/// 床号
	i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 									/// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 									/// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         									/// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  				/// 病案号
	s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   	/// 诊断
	s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   												/// 申请科室
	s HospitalID=$p(^CTLOC(CstRLocID),"^",22)
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  				/// 多语言支持
	s CstRDate=$p(^DHCMDTCON(ID),"^",3)    												/// 申请日期
	s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	s CstRTime=$p(^DHCMDTCON(ID),"^",4)    												/// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRTime=CstRDate_" "_CstRTime
	s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  												/// 申请医生
	s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  			/// 多语言支持
	s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    											/// 病情及诊疗经过
	s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   											/// 会诊的理由和目的
	s CstNDate=$p(^DHCMDTCON(ID),"^",8)     											/// 会诊日期
	s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	s AppScDr = $p(^DHCMDTCON(ID),"^",18)   											/// 资源表ID 
	s IDS="" ,CHS="" ,MakResDate=""
	i AppScDr'="" s IDS=+AppScDr, CHS=$p(AppScDr,"||",2)
	i IDS'="" s MakResDate=$p($g(^RBAS(IDS,CHS)),"^",1) 								///预约日期
	s prtime=$p($h,",",1) 																///当前日期
	s PreTime=""
	s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) 							/// 预约时间
	s CstNTime=$p(^DHCMDTCON(ID),"^",9)     											/// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   											/// 会诊地点
	s TreMeasures=$p(^DHCMDTCON(ID),"^",11) 											/// 最终治疗措施
	s CstStatus=$p(^DHCMDTCON(ID),"^",12)   											/// 状态ID
	s CstStatusCode=$P(^DHCMDTS(CstStatus),"^",1)
	s:CstStatus'="" CstStatus=$P(^DHCMDTS(CstStatus),"^",2)
	s CstUser=$p(^DHCMDTCON(ID),"^",13)     				/// 联系人
	s CstPhone=$p(^DHCMDTCON(ID),"^",14)    				/// 联系电话
	s McNotes=$p(^DHCMDTCON(ID),"^",24)     				/// 备注yzy
	s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   				/// 打印标志
	s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    				/// 疑难病种
	s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	s RBResID=$p(^DHCMDTCON(ID),"^",17)       				/// 资源ID
	s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   				/// 预约资源ID
	s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	s PrvID=$p($g(^RB("RES",+RBResID)),"^",2)
	s PrvDesc="",PrvLoc=""
	s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	s:PrvLocID'="" PrvLoc=$p($g(^CTLOC(PrvLocID)),"^",2)
	s AppAdmID = $p(^DHCMDTCON(ID),"^",20)
	s LgNode=##Class(web.DHCMDTCom).GetCsNodeTime(ID,"80") 
	s CstCUser=$p(LgNode,"^",2)   							/// 完成医师
	s:CstStatusCode<80 CstCUser=""							/// 完成状态之前的完成医生为空
	s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       		/// 会诊科室
	s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       		/// 职称
	i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)   			/// 会诊医生
	s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	
	s MDTMainXML=""
	s Object=##class(web.DHCMDTEntityCompInfo).%New()
	s Object.ID=ID
	s Object.EpisodeID=EpisodeID
	s Object.PatNo=PatNo
	s Object.PatName=PatName
	s Object.PatSex=PatSex
	s Object.PatAge=PatAge
	s Object.PatLoc=PatLoc
	s Object.PatTelH=PatTelH
	s Object.PatBod=PatBod
	s Object.PatAddr=PatAddr
	s Object.BillType=BillType
	s Object.MedicareNo=MedicareNo
	s Object.PatDiagDesc=PatDiagDesc
	s Object.CstRDate=CstRDate
	s Object.CstRTime=CstRTime
	s Object.CstRUser=CstRUser
	s Object.CstTrePro=CstTrePro
	s Object.CstPurpose=CstPurpose
	s Object.CstNDate=CstNDate
	s Object.CstNTime=CstNTime
	s Object.CstNPlace=CstNPlace
	s Object.CstUser=CstUser
	s Object.CstPhone=CstPhone
	s Object.DisGroup=DisGroup
	s Object.PrvDesc=PrvDesc
	s Object.CstStatus=CstStatus
	s Object.PreTime=PreTime
	s Object.AppAdmID=AppAdmID
	s Object.MakResDate=MakResDate
	s Object.McNotes=McNotes
	s Object.CstCUser=CstCUser
	s Object.ExecType=ExecType
	d Object.XMLExportToString(.MDTMainXML)	
	q MDTMainXML
}

/// w ##Class(web.DHCEMSignVerify).InsertSignBatchSignRecord("F"_$c(1)_"412||728||1^F"_$c(1)_"412||729||1^F"_$c(1)_"412||730||1","12177","F","uSQpvffNMbjynnBygha+wgMM4b4&&&&&&&&&&tGPzTRxk4g7y8ZLRPgsqSvX6hmU&&&&&&&&&&blatu7xSOj6REAFnbhTG+SSmOm8&&&&&&&&&&","SF22345678901234567X","sT9BiFrijsbo2ZQ/R1s++97GmIc&&&&&&&&&&mNh/8d0ag/u48OaOIty2wWP6xgA&&&&&&&&&&5R6zjJNZ2ZFG/t36Q1vxTmeGGJs&&&&&&&&&&","","A8B9D7A20C12A401","EXEC")
ClassMethod InsertSignBatchSignRecord(CurrDataStr As %String, UserID As %String, OperationType As %String = "", ItemsHashVal As %String, MainSignCertCode As %String, MainSignValue As %String, ExpStr As %String = "", MainSignCertNo As %String = "", ModuleMark As %String = "")
{
	s ^qqa("InsertSignBatchSignRecord")=$lb(CurrDataStr, UserID, OperationType, ItemsHashVal, MainSignCertCode, MainSignValue, ExpStr, MainSignCertNo, ModuleMark)
	s ret=0
	f i=1:1:$l(CurrDataStr,"^") q:ret'=0  d
	.s DataIdStr=$p(CurrDataStr,"^",i)
	.s OperationType=$p(DataIdStr,$c(1))
	.s DataId=$p(DataIdStr,$c(1),2)
	.q:(DataId="")||(OperationType="") 
	.s ItemHashVal=$p(ItemsHashVal,"&&&&&&&&&&",i)
	.s ItemMainSignValue=$p(MainSignValue,"&&&&&&&&&&",i)
	.s ret=..Insert(DataId,UserID,OperationType,ItemHashVal,MainSignCertCode,ItemMainSignValue,ExpStr,MainSignCertNo,ModuleMark)
	q ret
}

/// w ##class(web.DHCDocSignVerify).Insert($lg(^Templx("Insert"),1),$lg(^Templx("Insert"),2),$lg(^Templx("Insert"),3),$lg(^Templx("Insert"),4),$lg(^Templx("Insert"),5),$lg(^Templx("Insert"),6),$lg(^Templx("Insert"),7),$lg(^Templx("Insert"),8)) 
ClassMethod Insert(DataId As %String, UserID As %String, OperationType As %String = "", ItemHash As %String = "", MainSignCertCode As %String = "", MainSignValue As %String = "", ExpStr As %String = "", MainSignCertNo As %String = "", ModuleMark As %String = "") As %String
{
	s $ZT="ERROR^DHCSSERR"
    s myrtn=0
	TS
	;NEWPRO 是新产品标识
	s ret=##Class(CA.DigitalSignatureService).Sign(MainSignCertCode,"NEWPRO",ItemHash,MainSignValue,MainSignCertNo)
	s retcode=$p(ret,"^")
	if (+retcode'=1)
	{
		tro 
		q "-100"
	}
	s signID=$p(ret,"^",2)
	;在医嘱状态表保存签名表CA.DigitalSignature 的外键 和 操作类型
	s Object=##class(User.DHCEmSignVerify).%New()
	s Object.SVPointerDr=DataId
	s Object.SVMainInfo=ItemHash
	s Object.SVMainSignCert=MainSignCertCode
	s Object.SVMainSignValue=MainSignValue
	s Object.SVMainSignTimeStamp=""
	s Object.SVCreateUserDr=UserID
	s Object.SVOperationType=OperationType
	Do Object.SVDigitalSignatureDrSetObjectId(signID)
	s Object.SVCreateDate=+$H
	s Object.SVCreateTime=$p($h,",",2)
	s Object.SVModuleMark=ModuleMark
	
	s sc=Object.%Save()
	If ($System.Status.IsError(sc)){
		TRO
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-100"
	}else{
		TC
	}
	Q myrtn
}

}
