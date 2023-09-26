Class web.DHCPE.CRM.Gateway Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod GetGatewayClassName()
{
	
	new className
	s className=$g(^DHCPESetting("DHCPE","ClassName of CRMGateWay"))
	q className
}

/// Description: 检测是否已经超过预约日期
/// Input： 	    crmAdm(预约ID),admType("I":个人Adm,"G":团体Adm),curDate(预约日期)
/// Return: 		-1：尚未到体检日期  0：正常在预约日期范围内  1：超过预约日期
/// Debug: d ##class(web.DHCPE.CRM.Gateway).CheckPEDate()
ClassMethod CheckPEDate(crmAdm, admType, curDate)
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"CheckPEDate",crmAdm,admType,curDate)
	q result
}

/// Description: 检测是否符合登记到达的条件
/// Input： 	    crmAdm(预约ID),admType("I":个人Adm,"G":团体Adm)
/// Return: 		0：符合可以到达  其它：不符
/// Debug: d ##class(web.DHCPE.CRM.Gateway).CheckCanArrive()
ClassMethod CheckCanArrive(crmAdm, admType)
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"CheckCanArrive",crmAdm,admType)
	q result
}

/// Description: 	体检过程变更通知, 由his通知CRM系统
/// Input： 	    RegType(RegId的类型，"PERSON"-个人　"GROUP"-团体,RegId: 个人或团体的RegId(AdmId))
/// 				NewStatus(新状态:PREREG-预挂号;REGISTERED-登记;ARRIVED-审批;CHARGED-收费;COMPLETED-完成(报告完成))
/// 				AddtionInfo:(附加信息.一般情况下为"")
/// Return: 		"0"  成功;  “ERROR: XXX” 失败
/// Debug: d ##class(web.DHCPE.CRM.Gateway).ExamStatusNotify()
ClassMethod ExamStatusNotify(QueryType, QueryValue, NewStatus, AdditionInfo = "") As %String
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"ExamStatusNotify",QueryType, QueryValue, NewStatus, AdditionInfo)
	q result
}

/// Description: 获取用户体检登记记录
/// Input： 	    QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 			QueryValue: 具体的查询值
/// 			Flag:    "ALL"-客人的所有记录;  
/// 					"UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
/// 					Else: 其他具体的状态
/// Return: 		***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// Debug: d ##class(web.DHCPE.CRM.Gateway).GetRegListByPatInf()
ClassMethod GetRegListByPatInf(QueryType, QueryValue, Flag = "ALL", job = "aaa") As %String
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"GetRegListByPatInf",QueryType, QueryValue, Flag,job)
	q result
}

/// Description: 获取用户体检登记记录
/// Return: 	 ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// Input:       QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”,"REGID","PATNAME"
/// 		     QueryValue: 具体的查询值
/// 		     Flag:  "ALL"-客人的所有记录;  
/// 				    "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。及各状态。
/// 				    Else: 其他具体的状态
/// Debug:  w ##class(web.DHCPE.CRM.Gateway).GetRegListByPatInf("PATNAME","","UNCOMPLETED")
ClassMethod GetRegIADM(QueryType, QueryValue, Flag = "ALL", job = "aaa") As %String
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"GetRegIADM",QueryType, QueryValue, Flag,job)
	q result
}

/// Description: 获取用户信息
/// Input： 	    QueryType(paraValue的类型,“HISCARDID”,“MID”、“CERTID”, “MOBILE”, "PATNAME")
/// 				QueryValue(具体的查询值)
/// Return: 		...$C(1)patId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level
/// 			^Marital^Email^Zip^BloodType^Profession^Title^Race$C(1)...
/// Debug: d ##class(web.DHCPE.CRM.Gateway).GetMemberByID()
ClassMethod GetMemberByID(QueryType, QueryValue) As %String
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"GetMemberByID",QueryType, QueryValue)
	q result
}

/// Description: 获取个人体检项目明细
/// Input： 	    RegId(个人预约ID)
/// Return: 		***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
/// Debug: d ##class(web.DHCPE.CRM.Gateway).GetExamItemsByRegId()	
ClassMethod GetExamItemsByRegId(RegId) As %String
{
	new className,result
	s className=..GetGatewayClassName()
	S LocID=$P($g(^DHCPEPreIADM(RegId)),"^",26)
	//Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode",LocID))	
	Set MothodName="GetExamItemsByRegId"
	If HospitalCode="AZ" Do
	.Set MothodName="GetExamItemsByRegIdAZ"
	Else  Do
	.Set MothodName="GetExamItemsByRegId"	
	s result=$zobjclassmethod(className,MothodName,RegId)
	q result
}

/// Description: 获取用户信息
/// Input： 	    patientNo(登记号)
/// Debug: d ##class(web.DHCPE.CRM.Gateway).GetPatientInfoByNo()
ClassMethod GetPatientInfoByNo(patientNo) As web.DHCPE.Patient
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"GetPatientInfoByNo",patientNo)
	q result
}

/// Description: 根据个人体检登记号，生成医瞩套相关信息
/// Input： 	    iAdmId()
/// Debug: d ##class(web.DHCPE.CRM.Gateway).InsertOEEnt()
ClassMethod InsertOEEnt(iAdmId)
{
	new className,result
	s className=..GetGatewayClassName()
	s result=$zobjclassmethod(className,"InsertOEEnt",iAdmId)
	q result
}

// w ##class(web.DHCPE.CRM.Gateway).UpdatePEResult("2752||10","demo","demo","aaaaaaaa","bbbbbbb","CCCCCCC")

// d $zobjclassmethod("web.DHCPE.CRM.Gateway","InsertOEEnt",OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult)

ClassMethod UpdatePEResult(OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult, NormalFlag)
{
	n (OEORIID,ReportUser,AuditUser,ClinicInfo,ExamDesc,ExamResult,NormalFlag)
	s $zt="GetErr"
	s SQLCODE=0
	i ReportUser'="" d
	.s ReportUser=$ZCVT(ReportUser,"U")
	.s ReportUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",ReportUser,0))
	i AuditUser'="" d
	.s AuditUser=$ZCVT(AuditUser,"U")
	.s AuditUser=$o(^SSU("SSUSR",0,"SSUSR_Initials",AuditUser,0))
	
	s paadm=$p(^OEORD(+OEORIID),"^",1)
	s peIAdmId=$o(^DHCPEIADM(0,"PAADM",paadm,"0"))
	q:peIAdmId="" SQLCODE
	s crmOrderId=$o(^DHCPECRMO(0,"OEORI",OEORIID,0))
	q:crmOrderId="" SQLCODE
	
	s paadm=$p(^OEORD(+OEORIID),"^",1)
	s arcimId=$p(^OEORD(+OEORIID,"I",$p(OEORIID,"||",2),1),"^",2)
	s ODRID=$o(^DHCPEODR(0,"ARCIM",arcimId,0))
	s ODID=""
	i ODRID'="" s ODID=$p(^DHCPEODR(ODRID),"^",2)
	s ResultStr="临床诊断:"_ClinicInfo
	s ResultStr=ResultStr_";检查所见:"_ExamDesc
	s ResultStr=ResultStr_";诊断意见:"_ExamResult
	S ResultStr=##class(web.DHCPE.ReportGetInfor).Replace(ResultStr,$c(0)," ")
	s date=+$h
	s time=$p($h,",",2)
	s PLIST(2)=paadm
	s PLIST(3)=arcimId
	s PLIST(4)=ODID
	s PLIST(5)="" //Str
	s PLIST(6)=AuditUser
	s PLIST(7)=date
	;s Flag=0
	;s ExamResult=..SplitRisResult(ResultStr,3)
	;i ExamResult["未见异常" s Flag=1
	s PLIST(8)=NormalFlag
	s PLIST(11)=OEORIID
	s PLIST(13)=time
	s RLTID=$o(^DHCPERLT(0,"OEORI",OEORIID,0))
	i RLTID="" d
	.&SQL(insert into sqluser.DHC_PE_Result values :PLIST() )
	.q:SQLCODE'=0
	.s RLTID=%ROWID
	e  d
	.&SQL(update sqluser.DHC_PE_Result values :PLIST() where RLT_RowId=:RLTID)
	.s RLTID=%ROWID
	q:SQLCODE'=0 SQLCODE
	s $p(^DHCPERLT(RLTID),"^",4)=ResultStr
	s ^DHCPEData("DHCPEResult","RIS","ReportUser",OEORIID)=ReportUser
	q SQLCODE
GetErr
	q -1
}

/// Description: 验证卡号是否存在,余额是否够用
/// Input： 	 DJCardNo（代金卡号）,Amount（消费金额）
/// Return:      0:可用，非0：不可用
/// Debug: d ##class(web.DHCPE.CRM.Gateway).CheckCard()
ClassMethod CheckCard(DJCardNo, Amount)
{
	s PayCode="TJDJK"
	s APID=##class(web.DHCPE.AdvancePayment).GetUseID(DJCardNo,PayCode,"N")
	q:APID="" "-1^对应帐户不存在"
	s APAmount=$P($G(^DHCPEAP(APID)),"^",4)
	i (APAmount-Amount)<0 q "-2^卡余额不足^"_APAmount
	q 0_"^可用^"_APAmount
}

/// Description: 更新卡金额
/// Input：      DJCardNo（代金卡号）,Amount（消费金额）,ExpStr（账单ID）,UserExp（操作员ID）
/// Return:      0:扣款成功，非0:失败
/// Debug: d ##class(web.DHCPE.CRM.Gateway).UpdateAPAmount()
ClassMethod UpdateAPAmount(DJCardNo, Amount, ExpStr, UserExp As %String = "")
{
	;q "0^扣款成功^"_0
	//s ^tempdhcpe("UpdateAP",DJCardNo)=DJCardNo_","_Amount_","_ExpStr
	s PayCode="TJDJK"
	i ExpStr="" q "-4^帐单ID不能为空"
	i Amount<0 d
	.s APID=$O(^DHCPEAP(0,"SourceNo","C",ExpStr,0))
	e  d
	.s APID=##class(web.DHCPE.AdvancePayment).GetUseID(DJCardNo,PayCode,"N")
	q:APID="" "-1^对应帐户不存在"
	s APAmount=$P($G(^DHCPEAP(APID)),"^",4)
	i (APAmount-Amount)<0 q "-2^卡余额不足^"_APAmount
	i Amount>0 d
	.s strings=APID_"^"_(-Amount)_"^"_ExpStr_"^^"
	.s AppType="C"
	e  d
	.s strings=APID_"^"_(-Amount)_"^"_ExpStr_"^^"
	.s AppType="CF"
	s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,AppType,UserExp,"","Y")
	i errs'="" q "-3^"_errs
	s APACID=%ROWID
	q "0^扣款成功^"_APACID
}

/// Description: 更新体检卡金额（体检卡、体检预缴金,适用体检卡消费和消费退费业务场景）
/// Input：      CardType(卡类型：R 体检预缴金，C 体检代金卡),CardNo（卡号：卡类型=R，卡号=登记号；卡类型=C，卡号=体检代金卡卡号）,Amount（金额）,
///              ExpStr（收费账单ID）,RefundExpStr(退费账单ID),UserExp（操作员ID^科室ID^院区ID）
/// Return:      0:扣款成功，非0:失败
/// Debug: d ##class(web.DHCPE.CRM.Gateway).UpdateAPAmountNew(31,"12345","10","")
ClassMethod UpdateAPAmountNew(CardType, CardNo, Amount, ExpStr, RefundExpStr As %String = "", UserExp As %String = "")
{
	//s ^tempdhcpe("UpdateAPAmount",CardType,CardNo)=$lb(CardType,CardNo,Amount,ExpStr,UserExp)
	
	i CardType="R" s PayCode="TJYJJ"
    i CardType="C" s PayCode="TJDJK"
    
	i ExpStr="" q "-4^帐单ID不能为空"
	i (RefundExpStr="")&&(Amount<0) q "-5^退费帐单ID不能为空"
	s UserID=$p(UserExp,"^",1)
	s LocID=$p(UserExp,"^",2)
    S HospID=$p(UserExp,"^",3)
    
	i (Amount<0){ //消费退费
		s APID=$O(^DHCPEAP(0,"SourceNo","C",ExpStr,0))
		
	}else{  //消费
		s APID=##class(web.DHCPE.CRM.Gateway).GetUseID(CardNo,PayCode,"N")
	}
	
	q:APID="" "-1^对应帐户不存在"
	
	s APAmount=$p($g(^DHCPEAP(APID)),"^",4)
	i (APAmount-Amount)<0 q "-2^卡余额不足^"_APAmount
	i (Amount>0){
		s strings=APID_"^"_(-Amount)_"^"_ExpStr_"^^"
		s AppType="C" //消费
	}else{
		s strings=APID_"^"_(-Amount)_"^"_RefundExpStr_"^^"
		s AppType="CF" //消费退费
	}
	
	s errs=##class(web.DHCPE.AdvancePayment).InsertAPAC(strings,AppType,UserID,LocID,"N",HospID)
	i errs'="" q "-3^"_errs
	s APACID=%ROWID
	q "0^扣款成功^"_APACID
}

/// Description: 根据卡号获取体检卡账户
/// Debug: d ##class(web.DHCPE.CRM.Gateway).GetUseID()
ClassMethod GetUseID(CardNo, PayCode As %Library.String = "TJYJJ", vStatus As %String = "N")
{
	s:PayCode="TJYJJ" Type="R"
	s:PayCode="TJDJK" Type="C"
	s APRowID=""
	s APID=0
	i Type="R"
	{
		s RegNo=CardNo
		f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:(APID="")||(APRowID'="")  d
		.s TType=$P($g(^DHCPEAP(APID)),"^",3)
		.q:TType'=Type
		.s Status=$P($g(^DHCPEAP(APID)),"^",5)
		.q:Status'=vStatus
		.s APRowID=APID
	}
	else
	{
		f  s APID=$O(^DHCPEAP(0,"CardNo",CardNo,APID)) q:(APID="")||(APRowID'="")  d
		.s TType=$P($g(^DHCPEAP(APID)),"^",3)
		.q:TType'=Type
		.s Status=$P($g(^DHCPEAP(APID)),"^",5)
		.q:Status'=vStatus
		.s APRowID=APID
	}
	q APRowID
}

/// Creator：    xy 
/// CreatDate：  20220902
/// Description: 根据发票获取除医保外的自付金额（体检组的接口）
/// Input:       PEInvID(体检发票ID)
/// Return：     除医保外的自付金额
/// debug: d ##class(web.DHCPE.CRM.Gateway).GetOwnPayAmt("8677")
ClassMethod GetOwnPayAmt(PEInvID)
{
 	q:PEInvID="" "-1^发票为空"
 	s RefInvID=$P($g(^DHCPEINVPRT(PEInvID)),"^",9)
    s FH=1
    i RefInvID'=""{
		s FH=-1
		s PEInvID=RefInvID
	}
	s InsuID=$P($g(^DHCPEOEITEM(PEInvID)),"^",4)
	q:InsuID="" "-1^医保ID为空"
    s InsuAmt=$P($g(^DHCPEOEITEM(PEInvID)),"^",5)
    s InvAmt=$P($g(^DHCPEINVPRT(PEInvID)),"^",7)
    s OwnPayAmt=$FN((InvAmt-InsuAmt)*FH,"",2)
    q OwnPayAmt
}

ClassMethod GetPatientInfoForHH(PAADM)
{
	;w ##class(web.DHCPE.CRM.Gateway).GetPatientInfoForHH("4331592")
	n (PAADM)
	s $ZT="SendHHErr"
	q:PAADM="" ""
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	s MZH=$P(^DHCPEPreIADM(PIADM),"^",27)
	s PIBI=$P(^DHCPEPreIADM(PIADM),"^",1)
	s XM=$P(^DHCPEPreIBI(PIBI),"^",2)
	s XB=$P(^DHCPEPreIBI(PIBI),"^",3)
	s:XB'="" XB=$P(^CT("SEX",XB),"^",2)
	s Dob=$P(^DHCPEPreIBI(PIBI),"^",4)
	s nl=+$P(##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H),"Y",1)
	s SJDW=$P(^DHCPEPreIADM(PIADM),"^",26)
	s:SJDW'="" SJDW=$P(^CTLOC(SJDW),"^",2)
	s:$L(SJDW,"-")>1 SJDW=$P(SJDW,"-",2,$L(SJDW,"-"))
	s LXXX=$P(^DHCPEPreIBI(PIBI),"^",8)
	s:LXXX="" LXXX=$P(^DHCPEPreIBI(PIBI),"^",6)
	s:LXXX="" LXXX=$P(^DHCPEPreIBI(PIBI),"^",7)
	s mcyj=""
	s bszy=""
	s:MZH="" MZH=$P(^DHCPEPreIBI(PIBI),"^",1)
	s Info=MZH_"^"_XM_"^"_XB_"^"_nl_"^"_SJDW_"^"_LXXX_"^"_mcyj_"^"_bszy
	s ^wrzForHH=Info
	b ;Info
	q ##class(DHCENS.REG.BS.WebREGService).SendPatInfo(Info)	
SendHHErr
	q "-1Err"
}

ClassMethod ReSendForHH(IBaseInfoID)
{
	;d ##class(web.DHCPE.CRM.Gateway).ReSendForHH("61215")
	s PreIADM=""
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PIBI",IBaseInfoID,PreIADM)) q:PreIADM=""  d
	.s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status'="ARRIVED"
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.d ##class(web.DHCPE.CRM.Gateway).GetPatientInfoForHH(PAADM)
}

ClassMethod GetPreRecord(RegNo, LocID, HPNo = "")
{
	;s Info=##class(web.DHCPE.CRM.Gateway).GetPreRecord("TEZT1014","53")
	s IBaseInfoID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:IBaseInfoID="" ""
	s LastPreIADM=""
	s PreIADM=""
	f  s PreIADM=$O(^DHCPEPreIADM(0,"PIBI",IBaseInfoID,PreIADM),-1) q:(PreIADM="")||(PreIADM=0)||(LastPreIADM'="")  d
	.s Status=$P(^DHCPEPreIADM(PreIADM),"^",8)
	.q:Status'="REGISTERED"
	.s Loc=$P(^DHCPEPreIADM(PreIADM),"^",26)
	.q:Loc'=LocID
	
	.s CurHPNo=$P(^DHCPEPreIADM(PreIADM),"^",27)
	.q:(HPNo'="")&&(CurHPNo'=HPNo)
	
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.q:$D(^DHCPERLT(0,"ADM",PAADM))
	.s PaiedFlag=..GetPaiedFlag(PAADM)
	.q:PaiedFlag'="P"
	.s LastPreIADM=PreIADM
	q:LastPreIADM="" ""
	s GIType="I"
	s GID=$P(^DHCPEPreIADM(LastPreIADM),"^",2)
	s:GID'="" GIType="G"
	s BaseInfo=##class(web.DHCPE.PrintNewDirect).GetPatBaseInfo(LastPreIADM,"1")
	s OrderSetsIDs=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(LastPreIADM,"Y")
	;姓名^性别^年龄^电话^体检号^*登记号*^体检日期^套餐描述^单位^VIP类型描述^部门^总金额^早餐描述^出片描述^特殊项目排队号^套餐ID^预约ID
	q BaseInfo_"^"_OrderSetsIDs_"^"_LastPreIADM_"^"_GIType_"^"_GID
}

ClassMethod GetPaiedFlag(PAADM)
{
	s PaiedFlag=""
	s Order=$O(^OEORD(0,"Adm",PAADM,0))
	q:Order="" PaiedFlag
	s Sub=0
	f  s Sub=$O(^OEORD(Order,"I",Sub)) q:(Sub="")||(PaiedFlag'="")  d
	.s Stat=$p($G(^OEORD(Order,"I",Sub,1)),"^",13)
	.q:Stat'="1"
	.s PaiedFlag=$P(^OEORD(Order,"I",Sub,3),"^",5)
	q PaiedFlag
}

/// 提供给第三个方保存体检结果
ClassMethod SavePEResult(ItemInfo As %String, UserInfo As %String, ResultInfo As %String, ReportPath As %String = "")
{
	;w ##class(web.DHCPE.CRM.Gateway).SavePEResult("P000000014^PE002","tjqt^2014-10-28","a|测试^b|结果")
	
	s $ZT="SavePEResultErr"
	s HPNo=$P(ItemInfo,"^",1)
	q:HPNo="" "-1^体检号不能为空"
	s ItemCode=$P(ItemInfo,"^",2)
	q:ItemCode="" "-1^检查项目不能为空"
	s UserCode=$P(UserInfo,"^",1)
	q:UserCode="" "-1^操作员编号不能为空"
	s CheckDate=$P(UserInfo,"^",2)
	q:ResultInfo="" "-1^没有检查结果"
	s PreID=$O(^DHCPEPreIADM(0,"HPNo",HPNo,0))
	q:PreID="" "-1^体检号不存在"
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreID,0))
	q:IADM="" "-1^体检号还未登记"
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	q:OrderID="" "-1^体检号不存在医嘱"
	
	s ArcSub=$O(^ARCIM(0,"Code",ItemCode,0))
	q:ArcSub="" "-1^检查项目编号不存在"
	s ArcID=ArcSub_"||1"
	s STID=$o(^DHCPEST(0,"STORD_ARCIM",ArcID,0))
	q:STID="" "-1^此项目体检没有开展"
	s OrderSub=""
	s SttDate=""
	f  s SttDate=$O(^OEORDi(0,"ARCIM",OrderID,ArcID,SttDate),-1) q:(SttDate="")||(OrderSub'="")  d
	.s Sub=""
	.f  s Sub=$O(^OEORDi(0,"ARCIM",OrderID,ArcID,SttDate,Sub),-1) q:(Sub="")||(OrderSub'="")  d
	..s Stat=$P(^OEORD(OrderID,"I",Sub,1),"^",13)
	..q:Stat="4"
	..s OrderSub=Sub
	q:OrderSub="" "-1^此体检者没有此检查项目"
	s OEID=OrderID_"||"_OrderSub
	b ;OEID
	s ResultStr=..TransResultStr(OEID,ArcID,ResultInfo)
	b ;ResultStr
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	i UserID="" d
	.s UserID="1"
	.s ^DHCPEDataEx("SavePEResult","NoUser",UserCode)=""
	
	i $l(CheckDate,"-")=3 s CheckDate=$zdh(CheckDate,3)
	i $l(CheckDate,"/")=3 s CheckDate=$zdh(CheckDate,4)
	i $g(CheckDate)="" s CheckDate=+$H
	s ExpStr=CheckDate_"^"_UserID
	s ret=##class(web.DHCPE.ResultNew).SaveResult(ResultStr,UserID,"",ExpStr)
	i +ret=0 d
	.i ReportPath="" d
	..k ^DHCPEDataEx("DHCPEResult","ReportPath",OEID)
	.e  d
	..s ^DHCPEDataEx("DHCPEResult","ReportPath",OEID)=ReportPath
	q ret
SavePEResultErr
	q "-1^保存结果异常"
}

ClassMethod TransResultStr(OEID, ArcID, ResultInfo)
{
	;ResultInfo    细项|结果^细项|结果
	s ARCSTID=$o(^DHCPEST(0,"STORD_ARCIM",ArcID,0))
	s RetStr=""
	s ResultLength=$L(ResultInfo,"^")
	f i=1:1:ResultLength d
	.s OneInfo=$P(ResultInfo,"^",i)
	.s DetailDesc=$P(OneInfo,"|",1)
	.s DetailDescIndex=$$ALPHAUP^SSUTIL4(DetailDesc)
	.s Result=$P(OneInfo,"|",2)
	.s DetailSub=$O(^DHCPEST(0,"OD_Desc",DetailDescIndex,ARCSTID,0))
	.i DetailSub="" d
	..&sql(insert into Sqluser.DHC_PE_OrderDetail
	     (OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Expression,OD_Unit,OD_Summary,OD_Advice,OD_Explain,OD_Sequence,OD_Sex)
	     values 
	     (:ARCSTID,:DetailDesc,:DetailDesc,'T','','','Y','Y','','99999999','N')
	     )
	..s ODID=%ROWID
	.e  d
	..s ODID=ARCSTID_"||"_DetailSub
	.s Flag=0
	.s ODRID=""
	.f  s ODRID=$O(^DHCPEODR(0,"OD",ODID,ODRID)) q:(ODRID="")||(Flag=1)  d
	..s CurArcID=$P(^DHCPEODR(ODRID),"^",1)
	..s:CurArcID=ArcID Flag=1
	.i Flag=0 d
	..&sql(insert into Sqluser.DHC_PE_OrderDetailRelate(ODR_ARCIM_DR, ODR_OD_DR, ODR_Sequence, ODR_Required, ODR_Parent_DR, ODR_Cascade)
	     values (:ArcID, :ODID, '99999999', 'N','', '')
	     )
	.s OneStr=OEID_"^"_ODID_"^"_Result
	.i RetStr="" d
	..s RetStr=OneStr
	.e  d
	..s RetStr=RetStr_$C(1)_OneStr
	q RetStr
}

}
