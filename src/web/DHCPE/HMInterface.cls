Class web.DHCPE.HMInterface Extends %Persistent
{

/// 体检自动插入问卷
/// w ##class(web.DHCPE.HMInterface).InsertHM(10707)
/// 问卷主表ID配置
/// s ^DHCPESetting("DHCPE","Questionnaire")=1
ClassMethod InsertHM(PreIADM)
{
	S ^tempdhcpe("InsertHM")=PreIADM
	s CurUserID=%session.Get("LOGON.USERID")
	q:($d(^DHCPEDataNewEx("PreIADMToHM",PreIADM))) 0
	s OBPreIBI=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s VIPLevel=$P($g(^DHCPEPreIADM(PreIADM)),"^",18)
	q:(VIPLevel="") "-1^vip为空"
	s HMServiceCode=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",14)
	q:(HMServiceCode="") "-1^VIP未关联服务级别"
	s HMService=HMServiceCode
	q:(HMService="") "-1^VIP关联的服务级别错误"
	s Reg=$p(^DHCPEPreIBI(OBPreIBI),"^",1)
	s OBID=$o(^User.DHCHMOBaseInfoI("BIPAPMINoIndex"," "_Reg,0))
	s OBCode=""
	i OBID'="" d
	.s OBCode=$lg(^User.DHCHMOBaseInfoD(OBID),27)
	s Name=$p(^DHCPEPreIBI(OBPreIBI),"^",2)
	s Sex=$p(^DHCPEPreIBI(OBPreIBI),"^",3)
	s CurDate=$zd(+$H,3)              

	
	s ServiceSub=0,Questionnaire=""
	f  s ServiceSub=$o(^User.DHCHMCServiceClassD(HMService,"DHCHMCSCQLink",ServiceSub)) q:(ServiceSub="")  d
	.s CurQuestionnaire=$lg(^User.DHCHMCServiceClassD(HMService,"DHCHMCSCQLink",ServiceSub),5)
	.s:(Questionnaire'="") Questionnaire=Questionnaire_"$"_CurQuestionnaire_"^N"
	.s:(Questionnaire="") Questionnaire=CurQuestionnaire_"^N"
	
	q:(Questionnaire="") "-1^服务级别未关联问卷"
	s Str=OBCode_"^"_Reg_"^"_Sex_"^"_CurDate_"^^^"_HMService_"^^"_Name_"^^^^^^^  ^^^^^^^^^^"
	s ret=##class(web.DHCHM.BaseDataSet).OBaseInfoSave(OBID,Str,"BICode^BIPAPMINo^BICSexDR^BIDOB^BITel^BICOccupationDR^BICServiceClassDR^BIHMDR^BIName^BICCertificateTypeDR^BIInputCode^BICNationDR^BICity^BICEducationDR^BICUserGroupDR^BIDocDR^BIIDCard^BIPassWord^BIMobilePhone^BIPostCode^BICUserTypeDR^BIEmail^BICMaritalDR^BICompany^BIAddress^BIRemark")

	//7^^^^1^^^^
	//QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR
	///1 服务级别 没用 写死1
	////1^NU$2^N   DHC_HM_CQuestionnaire表id NU 否  N 是
	//s Questionnaire=$g(^DHCPESetting("DHCPE","Questionnaire"))
	s ^TMPDHCHM("t1")=Questionnaire
	///"","10^^^^3^^^^","QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR","3^N",1)
	s ^TMPDHCHM("t2")=$lb("",+ret_"^^^^"_HMService_"^^^^","QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR",Questionnaire,CurUserID)
	///("","12^^^^3^^^^","QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR","3^N$1^N",7058)
	s qret=##class(web.DHCHM.OEvaluationRecord).SaveEvaluationRecord("",+ret_"^^^^"_HMService_"^^^^","QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR",Questionnaire,CurUserID)
	///返回DHC_HM_OEvaluationRecord表ID
	///体检记录和评估记录对照
	s ^DHCPEDataNewEx("PreIADMToHM",PreIADM)=qret
	s ^DHCPEDataNewEx("HMToPreIADM",qret)=PreIADM
	
	q qret
}

Storage Default
{
<Data name="HMInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.HMInterfaceD</DataLocation>
<DefaultData>HMInterfaceDefaultData</DefaultData>
<IdLocation>^web.DHCPE.HMInterfaceD</IdLocation>
<IndexLocation>^web.DHCPE.HMInterfaceI</IndexLocation>
<StreamLocation>^web.DHCPE.HMInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
