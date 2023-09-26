/// 名称:EMRservice.BL.SDHDSD000301
/// 描述:共享文档门急诊病历业务类
/// 编写者：Guozongtao
/// 编写日期: 2016-11-05
Class EMRservice.BL.SDHDSD000301 Extends (%RegisteredObject, %XML.Adaptor)
{

//使用范围

Property realmCode As %String;

//文档类型

Property typeId As %String;

//模板ID及版本号

Property template As %String;

//文档流水号

Property Instanceid As %String;

//标题

Property title As %String;

//文档生成时间

Property effectiveTime As %String;

//保密级别

Property confidentiality As %String;

//文档版本号

Property versionNumber As %String;

//文档创作者

Property authorid As %String;

Property authorName As %String;

//保管机构

Property custodian As %String;

//住院号

Property medicareNo As %String;

//就诊号

Property admvisitNo As %String;

//病案号

Property medRecordNo As %String;

//健康卡号

Property healthCardNo As %String;

//证件类型代码

Property certificateCode As %String;

//证件名称

Property certificateDesc As %String;

//证件号码

Property certificateValue As %String;

//现住址完整地址

Property addrText As %String;

//现住址xx号xx小区xx栋xx单元

Property houseNumber As %String;

//现住址xx大道

Property streetName As %String;

//现住址xx乡镇

Property township As %String;

//现住址xx区

Property county As %String;

//现住址xx市

Property city As %String;

//现住址xx市

Property state As %String;

//现住址邮编

Property postalCode As %String;

//患者姓名

Property name As %String;

//患者电话号码

Property telecom As %String;

//患者性别编码

Property administrativeGenderCode As %String;

//患者性别描述

Property administrativeGenderValue As %String;

//患者婚姻状况

Property maritalStatusCode As %String;

Property maritalStatusValue As %String;

//患者民族

Property ethnicGroupCode As %String;

Property ethnicGroupValue As %String;

//患者年龄

Property age As %String;

//患者年龄-岁

Property year As %String;

//患者年龄-月

Property month As %String;

//患者年龄-天

Property day As %String;

//患者年龄-小时

Property hour As %String;

//联系人编码

Property participantCode As %String;

//家庭关系描述

Property participantValue As %String;

//联系人完整地址

Property participantAddrText As %String;

//联系人xx号

Property participantAddrhouseNumber As %String;

//联系人xx大道

Property participantAddrstreetName As %String;

//联系人xx乡镇

Property participantAddrtownship As %String;

//联系人xx区

Property participantAddrcounty As %String;

//联系人xx市

Property participantAddrcity As %String;

//联系人xx省

Property participantAddrstate As %String;

//联系人邮编

Property participantAddrpostalCode As %String;

//联系人电话

Property participanttelecom As %String;

//联系人姓名

Property participantName As %String;

//患者姓名

Property E0004 As %String;

//患者性别代码

Property E0005 As %String;

//患者性别描述

Property E0006 As %String;

//患者出生日期

Property E0007 As %String;

//患者年龄

Property E0008 As %String;

//患者民族代码

Property E0023 As %String;

//患者民族描述

Property E0024 As %String;

//患者职业类别代码

Property E0028 As %String;

//患者职业类别描述

Property E0029 As %String;

//患者婚姻代码

Property E0030 As %String;

//患者婚姻描述

Property E0031 As %String;

//患者患者住址（全）

Property E0032 As %String;

//患者现住址-门牌号码

Property E0033 As %String;

//患者现住地址-村（街、路、弄等）

Property E0034 As %String;

//患者现住址-乡（镇、街道办事处）

Property E0035 As %String;

//患者现住址-县（区）

Property E0036 As %String;

//患者现住址-市（地区）

Property E0037 As %String;

//患者现住址-省（自治区、直辖市）

Property E0038 As %String;

//患者现住址邮政编码

Property E0039 As %String;

//患者工作单位名称

Property E0050 As %String;

//患者门诊号

Property E0000 As %String;

//患者门诊类型代码

Property E0152 As %String;

//患者门诊类型名称

Property E0153 As %String;

//患者科室id

Property E0156 As %String;

//患者科室

Property E0077 As %String;

//患者医生签名日期

Property E0158 As %String;

//患者医生签名时间

Property E0159 As %String;

//患者签名医生代码

Property E0160 As %String;

//患者签名医生姓名

Property E0161 As %String;

//患者卡号

Property E0183 As %String;

//患者入院时情况

Property E0081 As %String;

//患者入院情况代码

Property E0184 As %String;

//患者入院途径代码

Property E0185 As %String;

//患者入院途径名称

Property E0186 As %String;

//病人ID

Property E0201 As %String;

//费别代码

Property E0150 As %String;

//费别名称

Property E0151 As %String;

//患者入院日期

Property E0082 As %String;

//门诊次数

Property E0220 As %String;

//主诉

Property S0001Text As %String;

//现病史

Property S0002Text As %String;

//现病史的详细信息 临床症状

Property S0002E01 As %String;

//现病史的详细信息 体征

Property S0002E02 As %String;

//现病史的详细信息 特殊病种

Property S0002E03 As %String;

//既往史

Property S0003Text As %String;

//食物或药物过敏史

Property S0019Text As %String;

//体格检查

Property S0020Text As %String;

//体格检查的详细信息 体温（℃）

Property S0020E01 As %String;

//体格检查的详细信息 脉率（次/min）

Property S0020E02 As %String;

//体格检查的详细信息 呼吸频率（次/min）

Property S0020E03 As %String;

//体格检查的详细信息 收缩压（mmHg）

Property S0020E04 As %String;

//体格检查的详细信息 舒张压(mmHg)

Property S0020E05 As %String;

//体格检查的详细信息 身高（cm）

Property S0020E06 As %String;

//体格检查的详细信息 体重（kg）

Property S0020E07 As %String;

//体格检查的详细信息 BP（mmHg）

Property S0020E08 As %String;

//辅助检查

Property S0041Text As %String;

//门诊诊断

Property S0149 As EMRservice.entity.EDiagnosInfo;

//诊断

Property S0048Text As %String;

//诊断的详细信息 诊断名称

Property S0048E01 As %String;

//诊断的详细信息 诊断代码

Property S0048E02 As %String;

//诊断的详细信息 医生填写的诊断

Property S0048E07 As %String;

//意见

Property S0072Text As %String;

//处理

Property S0073Text As %String;

//门急诊医嘱

Property S0158Text As %ArrayOfDataTypes;

//门急诊医嘱

Property S0067Text As list Of EMRservice.entity.EOrderInfo;

//门急诊医嘱-检查化验治疗

Property CZText As %ArrayOfDataTypes;

//门急诊医嘱-西药

Property CF As %ArrayOfDataTypes;

//门急诊医嘱-中草药

Property ZCY As %ArrayOfDataTypes;

//医嘱开始日期

Property S0067E01 As %String;

//医嘱开始时间

Property S0067E02 As %String;

//医嘱代码

Property S0067E03 As %String;

//医嘱名称

Property S0067E04 As %String;

//医嘱频次名称

Property S0067E06 As %String;

//医嘱单次剂量

Property S0067E07 As %String;

//医嘱单次剂量单位描述

Property S0067E09 As %String;

//医嘱用法描述

Property S0067E11 As %String;

//医嘱开立医师代码

Property S0067E12 As %String;

//医嘱开立医师姓名

Property S0067E13 As %String;

//医嘱审核日期

Property S0067E14 As %String;

//医嘱审核时间

Property S0067E15 As %String;

//药品规格

Property S0067E25 As %String;

//药品总量

Property S0067E26 As %String;

//药品总量单位描述

Property S0067E28 As %String;

//医嘱大类代码

Property S0067E29 As %String;

//医嘱大类描述

Property S0067E30 As %String;

//处方号

Property S0067E31 As %String;

/// Desc:       查询门诊病历信息，创建急诊病历实例
/// Creator:    guozongtao	
/// CreateDate: 2016-11-05
/// Input:      argArray  命令参数
/// OutPut:     
///             d ##Class(EMRservice.BL.SDHDSD000301).CreateInstace(argArray)	
ClassMethod CreateInstace(argArray As %ArrayOfDataTypes) As EMRservice.BL.SDHDSD000301
{
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s InternalID = argArray.GetAt("params").GetAt("InternalID")
    s InstanceID = argArray.GetAt("params").GetAt("InstanceID")

	q:(EpisodeID="")||(InternalID="")||(InstanceID="") "-1"

	
	s obj=##Class(EMRservice.BL.SDHDSD000301).%New()
	
	s obj.realmCode="门急诊病历"
	s obj.typeId="Single"
	s obj.Instanceid=InstanceID
	s objInstance=##Class(EMRinstance.InstanceData).%OpenId(obj.Instanceid)
	s obj.title=objInstance.Title
	s obj.template=objInstance.RealTemplateID
	s obj.effectiveTime=$zd(objInstance.HappenDate,8)_$tr($zt(objInstance.HappenTime,1),":","")
	s obj.certificateCode="N"
	s obj.certificateDesc="正常"
	s obj.versionNumber=objInstance.TemplateVersion
	s obj.authorid=objInstance.CreateUser
	s:objInstance.CreateUser'="" obj.authorName=$p($g(^SSU("SSUSR",objInstance.CreateUser)),"^",2)
	s obj.custodian=..HospitalName(EpisodeID)
	s PapmiDr=+$g(^PAADM(EpisodeID))
	s obj.medicareNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDr)
	s obj.admvisitNo=EpisodeID
	s obj.medRecordNo=##Class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNo(PapmiDr)
	//健康卡号默认为身份证号
	s obj.healthCardNo=##Class(EMRservice.HISInterface.PatientInfoAssist).IDCard(PapmiDr)
	s obj.certificateCode=##Class(EMRservice.HISInterface.PatientInfoAssist).CardType(PapmiDr)
	s CardInfo=..CardType(PapmiDr)
	s obj.certificateCode=$p(CardInfo,"^",1)
	s obj.certificateDesc=$p(CardInfo,"^",2)
	s obj.certificateValue=..CardNumber(PapmiDr)
	s obj.addrText=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(PapmiDr)
	s obj.houseNumber=""
	s obj.streetName=""
	s obj.township=..AddressArea(PapmiDr)
	s obj.county=..AddressRegion(PapmiDr)
	s obj.city=..CityAreaAddress(PapmiDr)
	s obj.state=..Province(PapmiDr)
	s obj.postalCode=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentPostCodeNew(PapmiDr)
	s obj.name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDr)
	s obj.telecom=##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(PapmiDr)
	s GenderInfo=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDr)
	s obj.administrativeGenderCode=$p(GenderInfo,"^",2)
	s obj.administrativeGenderValue=$p(GenderInfo,"^",3)
	s maritalInfo=..MaritalStatus(PapmiDr)
	s obj.maritalStatusCode=$p(maritalInfo,"^",2)
	s obj.maritalStatusValue=$p(maritalInfo,"^",3)
	s NationInfo=##Class(EMRservice.HISInterface.PatientInfoAssist).Nation(PapmiDr)
	s obj.ethnicGroupCode=$p(NationInfo,"^",2)
	s obj.ethnicGroupValue=$p(NationInfo,"^",3)
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID,"")
	if AdmDateTime'="" 
	{ 
		   // 入院日期内部格式
		   s AdmDate = $P($G(AdmDateTime),",",1)
		   // 入院时间内部格式 
		   s AdmTime = $P($G(AdmDateTime),",",2)
	}

	
	s strAge=..Age(PapmiDr,EpisodeID,AdmDate,AdmTime)
	s obj.age=$p(strAge,"^",5)
	s obj.year=$p(strAge,"^",1)
	s obj.month=$p(strAge,"^",2)
	s obj.day=$p(strAge,"^",3)
	s obj.hour=$p(strAge,"^",4)
	
	s LinkmanRelationInfo=##Class(EMRservice.HISInterface.PatientInfoAssist).LinkmanRelation(PapmiDr)
	s obj.participantCode=$p(LinkmanRelationInfo,"^",2)
	s obj.participantAddrText=..LinkmanAddressNew(PapmiDr)
	s obj.participantAddrcity=""
	s obj.participantAddrcounty=""
	s obj.participantAddrhouseNumber=""
	s obj.participantAddrpostalCode=""
	s obj.participantAddrstate=""
	s obj.participantAddrstreetName=""
	s obj.participantAddrtownship=""
	s obj.participanttelecom=##Class(EMRservice.HISInterface.PatientInfoAssist).LinkmanPhone(PapmiDr)
	s obj.participantName=##Class(EMRservice.HISInterface.PatientInfoAssist).LinkmanName(PapmiDr)
	
	s objArray=##Class(%ArrayOfDataTypes).%New()
	s objArray=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.03")
	s obj.E0004=objArray.GetAt("HDSD00.03.017") //姓名
	s obj.E0005=objArray.GetAt("HDSD00.03.039") //性别代码
	s obj.E0005=objArray.GetAt("HDSD00.03.506") // 新术语 性别描述
	s obj.E0007=objArray.GetAt("HDSD00.03.003") //出生日期
	s obj.E0008=objArray.GetAt("HDSD00.03.026") //年龄  (门诊病历患者年龄统一使用HDSD00.03.026编码，术语集对照时注意)

	//与平台组商议是否保留
	//s obj.E0023="" //民族代码
	//s obj.E0024="" //民族描述
	//s obj.E0028="" //职业类别代码
	//s obj.E0029="" //职业类别描述
	//s obj.E0030="" //婚姻代码
	//s obj.E0031="" //婚姻描述
	//s obj.E0032="" //患者住址（全）
	//s obj.E0033="" //现住址-门牌号码
	//s obj.E0034="" //现住地址-村（街、路、弄等）
	//s obj.E0035="" //现住址-乡（镇、街道办事处）
	//s obj.E0036="" //现住址-县（区）
	//s obj.E0037="" //现住址-市（地区）
	//s obj.E0038="" //现住址-省（自治区、直辖市）
	//s obj.E0039="" //现住址邮政编码
	//s obj.E0050="" //工作单位名称
	
	s obj.E0000=objArray.GetAt("HDSD00.03.025") //门诊号
	
	//与平台组商议是否保留
	//s obj.E0152="" //门诊类型代码
	//s obj.E0153="" //门诊类型名称
	s CurrentDept=""
	s CurrentDept=..CurrentDept(EpisodeID,"")  
	s obj.E0156= $p(CurrentDept,"^",1) //新术语 科室id
	
	s obj.E0077=$p(CurrentDept,"^",3)  //科室
	
	s SignDate="",SignTime="",SignUserName=""
	s Signarray= ##Class(EMRservice.BL.BLEMRSign).GetLastSignInfo(InstanceID)
	s:Signarray.GetAt("SignDate")'="" SignDate=$zd(Signarray.GetAt("SignDate"),3)
	s:Signarray.GetAt("SignTime")'="" SignTime=$zt(Signarray.GetAt("SignTime"))
	s:Signarray.GetAt("UserID")'="" SignUserName=$p($g(^SSU("SSUSR",Signarray.GetAt("UserID"))),"^",2)
	
	s obj.E0158=SignDate 					//医生签名日期
	s obj.E0159=SignTime  					//新术语 医生签名时间
	s obj.E0160=Signarray.GetAt("UserID")   //新术语 签名医生代码
	s obj.E0161=SignUserName                //签名医生姓名
	
	//与平台组商议是否保留
	//s obj.E0183="" //卡号
	//s obj.E0081="" //入院时情况
	//s obj.E0184="" //入院情况代码
	//s obj.E0185="" //入院途径代码
	//s obj.E0186="" //入院途径名称
	
	s obj.E0201=PapmiDr
	s obj.E0201=$P(^PAPER(PapmiDr,"PAT",1),"^",2)
	
	s PayType=""
	s PayTye=..PayType(EpisodeID,"ALL")
	s obj.E0150=$p(PayTye,"^",1)
	s obj.E0151=$p(PayTye,"^",3)
	s obj.E0082=$zd(AdmDate,3)_" "_$zt(AdmTime)
	s obj.E0220=..GetAdmtimes(PapmiDr)
	s obj.S0001Text=objArray.GetAt("HDSD00.03.038") //主诉 南方医院主诉为临床症状
	s obj.S0002Text=objArray.GetAt("HDSD00.03.380") //现病史 南方医院门诊病历不写现病史
	
	////与平台组商议是否保留
	//s obj.S0002E01="" //临床症状
	//s obj.S0002E02="" //体征
	//s obj.S0002E03="" //特殊病种
	
	s obj.S0003Text=objArray.GetAt("HDSD00.03.021") //既往史
	s obj.S0019Text=objArray.GetAt("HDSD00.03.014") //过敏史
	s obj.S0020Text=objArray.GetAt("HDSD00.03.037") //体格检查
	
	//与平台组商议是否保留
	/*
	s obj.S0020E01=""  //体温（℃）
	s obj.S0020E02=""  //脉率（次/min）
	s obj.S0020E03=""  //呼吸频率（次/min）
	s obj.S0020E04=""  //收缩压（mmHg）
	s obj.S0020E05=""  //舒张压(mmHg)
	s obj.S0020E06=""  //身高（cm）
	s obj.S0020E07=""  //体重（kg）
	s obj.S0020E08=""  //BP（mmHg）
	*/
	
	s Diagnose=""
	s obj.S0041Text=objArray.GetAt("HDSD00.03.511")  //新术语 辅助检查
	//s obj.S0149=objArray.GetAt("HDSD00.03.512")      //新术语 门诊诊断
	//s Diagnose= ##class(EMRservice.HISInterface.PatientInfoAssist).GetDiagnosforOPEMRInfo(EpisodeID)
	//s Diagnose=$e(Diagnose,1,$l(Diagnose)-1)
	s obj.S0149=..GetDiagnosforOPEMRInfo(EpisodeID)
	//s obj.S0048Text=Diagnose
	s obj.S0072Text=objArray.GetAt("HDSD00.03.513")	 //新术语 意见
	s obj.S0073Text=objArray.GetAt("HDSD00.03.514")  //新术语 处置
		
	s obj.S0158Text=##Class(%ArrayOfDataTypes).%New()
	
	//检查检验
		
	s MZBL="",ret1="",mark1="",mark2="",mark3=""
	s retBL = ##Class(%ResultSet).%New("web.DHCFOrdGet:FindAdmOrderItems")
	
	s columns = retBL.GetColumnCount()
	s sc = retBL.Execute(EpisodeID,"","","","","","")	
	While (retBL.Next()) 
	{
		s OrderStatus=retBL.Data("OrderStatus")
		continue:(OrderStatus="停止")
		
		s MZBL=	retBL.Data("TypeClass")_"  "_retBL.Data("OrderName")
		if "检验"[retBL.Data("TypeClass")
		{s mark1=mark1_MZBL_$c(10)_$c(13)}
		if "检查"[retBL.Data("TypeClass")
		{s mark2=mark2_MZBL_$c(10)_$c(13)}
		if "治疗"[retBL.Data("TypeClass")
		{s mark3=mark3_MZBL_$c(10)_$c(13)}
		s ret1=mark1_mark2_mark3
		
		
		if ("检验"[retBL.Data("TypeClass"))||("检查"[retBL.Data("TypeClass"))||("治疗"[retBL.Data("TypeClass"))
		{
			s OrderInfo=##Class(EMRservice.entity.EOrderInfo).%New()
			s OrderInfo.Text=retBL.Data("OrderName")
			s OrderInfo.E01=retBL.Data("OrderStartDate")  //医嘱开始日期	
			s OrderInfo.E02=retBL.Data("OrderStartTime")  //医嘱开始时间
			s OrderInfo.E03=retBL.Data("OrderARCIMRowid")  //医嘱代码
			s OrderInfo.E04=retBL.Data("OrderName")  //医嘱名称
			s OrderInfo.E06=retBL.Data("OrderFreq")  //医嘱频次名称
			s OrderInfo.E07=retBL.Data("OrderDoseQty")  //医嘱单次剂量
			s OrderInfo.E09=retBL.Data("OrderDoseUOM")  //医嘱单次剂量单位描述
			s OrderInfo.E11=retBL.Data("OrderInstr")  //医嘱用法描述
			s OrderInfo.E12=retBL.Data("OrderDocRowid")  //医嘱开立医师代码
			s OrderInfo.E13=retBL.Data("OrderDoc")      //医嘱开立医师姓名
			//s OrderInfo.E14=retBL.Data("")  //医嘱审核日期
			//s OrderInfo.E15=retBL.Data("")  //医嘱审核时间
			//s OrderInfo.E25=retBL.Data("")  //药品规格
			//s OrderInfo.E26=retBL.Data("")  //药品总量
			//s OrderInfo.E28=retBL.Data("")  //药品总量单位描述
			//s OrderInfo.E29=retBL.Data("OrderBillTypeRowId")  
			//s OrderInfo.E29=retBL.Data("TypeClass") //医嘱大类代码
			s OrderInfo.E30=retBL.Data("TypeClass")  //医嘱大类描述
			s OrderInfo.E31=retBL.Data("OrderPrescNo")	 //处方号
			d obj.S0067Text.Insert(OrderInfo)
		}	
				
	}
	Do retBL.Close()
	d obj.S0158Text.SetAt(mark1,"化验")
	d obj.S0158Text.SetAt(mark2,"检查")
	d obj.S0158Text.SetAt(mark3,"治疗")
	
	//西药
	s PrcseCF="",ret2="",retPrcseCFSpecifications="",retPrcseCFSpecifications="",retPrcseCFPrescOrderDoseUOM="",Specifications="",PrescOrderDoseUOM="",PrescOrdername="",PrescOrderInstr="",PrescOrderFreq="",OrderBillTypeRowid="",count=0
	Set retPrcseCF = ##Class(%ResultSet).%New("web.DHCFOrdGet:FindAdmOrderItems")
	Set columns = retPrcseCF.GetColumnCount()
	Set sc = retPrcseCF.Execute(EpisodeID,"","","","","","")
	While (retPrcseCF.Next()) 
	{
		s OrderStatus=retPrcseCF.Data("OrderStatus")
		continue:(OrderStatus="停止")
		
		s OrderFreq=retPrcseCF.Data("OrderFreq")
		s OrderFreq=$$ALPHAUP^SSUTIL4(OrderFreq)
		S OrderFreq=$tr(OrderFreq,"-")
		S OrderFreq=$tr(OrderFreq,"/")
		S OrderFreq=$tr(OrderFreq,"[")
		S OrderFreq=$tr(OrderFreq,"]")
		s:(OrderFreq'="") OrderFreq=$o(^PHCFR(0,"Desc1",OrderFreq,""))
		s:(OrderFreq'="") OrderFreq=$p(^PHCFR(OrderFreq),"^",4)
		if ("西药"[retPrcseCF.Data("TypeClass")) 
		{
			//b  // 特殊处理子医嘱	
		    s PrescOrdername=$p(retPrcseCF.Data("OrderName"),"[",1)
		    S PrescOrderOrderSeqNo=retPrcseCF.Data("OrderSeqNo")
		    if (PrescOrderOrderSeqNo[".")
			{
				s PrescOrdername="  "_PrescOrdername
			}
			else
			{
				s count=count+1
				s PrescOrdername=count_" "_PrescOrdername
			}
		    s PrescOrderPackQty=retPrcseCF.Data("OrderPackQty")
		    s PrescOrderPackUOM=retPrcseCF.Data("OrderPackUOM")
		    s Specifications="["_$p(retPrcseCF.Data("OrderName"),"[",2)_"×"_PrescOrderPackQty_PrescOrderPackUOM
		    s PrescOrderDoseQty=retPrcseCF.Data("OrderDoseQty")
		    s PrescOrderDoseUOM=retPrcseCF.Data("OrderDoseUOM")
		    s PrescOrderDoseUOM=PrescOrderDoseQty_PrescOrderDoseUOM
			
		    s PrescOrderInstr=retPrcseCF.Data("OrderInstr")
		    s PrescOrderFreq=OrderFreq
	
	
			s retPrcseCFSpecification=$p(Specifications,"[",2)
			s retPrcseCFSpecifications=$p(Specifications,"*",1)_$p(Specifications,"]",2)_"]"
			//s retPrcseCFPrescOrderDoseUOM="每次"_PrescOrderDoseUOM
			s:PrescOrderDoseUOM'="" PrescOrderDoseUOMretPrcseCFPrescOrderDoseUOM="每次"_PrescOrderDoseUOM
			s PrcseCF=PrescOrdername_"  "_retPrcseCFSpecifications_"  "_retPrcseCFPrescOrderDoseUOM_" "_PrescOrderInstr_" "_PrescOrderFreq
			s ret2=ret2_PrcseCF_$c(10)_$c(13)
		
			s OrderInfo=##Class(EMRservice.entity.EOrderInfo).%New()
			//s OrderInfo.Text=retPrcseCF.Data("OrderName")
			s OrderInfo.Text=retPrcseCF.Data("OrderName")_"每次"_retPrcseCF.Data("OrderDoseQty")_retPrcseCF.Data("OrderDoseUOM")_" "_retPrcseCF.Data("OrderInstr")_" "_OrderFreq
			s OrderInfo.E01=retPrcseCF.Data("OrderStartDate")  //医嘱开始日期	
			s OrderInfo.E02=retPrcseCF.Data("OrderStartTime")  //医嘱开始时间
			s OrderInfo.E03=retPrcseCF.Data("OrderARCIMRowid")  //医嘱代码
			s OrderInfo.E04=retPrcseCF.Data("OrderName")  //医嘱名称
			//s OrderInfo.E06=retPrcseCF.Data("OrderFreq")  //医嘱频次名称
			s OrderInfo.E06=OrderFreq  //医嘱频次名称
			s OrderInfo.E07=retPrcseCF.Data("OrderDoseQty")  //医嘱单次剂量
			s OrderInfo.E09=retPrcseCF.Data("OrderDoseUOM")  //医嘱单次剂量单位描述
			s OrderInfo.E11=retPrcseCF.Data("OrderInstr")  //医嘱用法描述
			s OrderInfo.E12=retPrcseCF.Data("OrderDocRowid")  //医嘱开立医师代码
			s OrderInfo.E13=retPrcseCF.Data("OrderDoc")      //医嘱开立医师姓名
			//s OrderInfo.E14=retPrcseCF.Data("")  //医嘱审核日期
			//s OrderInfo.E15=retPrcseCF.Data("")  //医嘱审核时间
			s OrderInfo.E25="["_$p(retPrcseCF.Data("OrderName"),"[",2)  //药品规格
			s OrderInfo.E26=retPrcseCF.Data("OrderDoseQty")  //药品总量
			s OrderInfo.E28=retPrcseCF.Data("OrderDoseUOM")  //药品总量单位描述
			//s OrderInfo.E29=retPrcseCF.Data("TypeClass")  //医嘱大类代码
			s OrderInfo.E30=retPrcseCF.Data("TypeClass")  //医嘱大类描述
			s OrderInfo.E31=retPrcseCF.Data("OrderPrescNo")	 //处方号
			
			d obj.S0067Text.Insert(OrderInfo)
		}		
		
	}
	Do retPrcseCF.Close()
	d obj.S0158Text.SetAt(ret2,"西药")
	
	//中草药
	s retZCYOerd="",ZCYOerd="",ret3=""
	Set retZCYOerd = ##Class(%ResultSet).%New("web.DHCDocPrtnfyyMZBL:FindMZBLPrcseZCY")
	Set columns = retZCYOerd.GetColumnCount()
	Set sc = retZCYOerd.Execute(EpisodeID)
	While (retZCYOerd.Next()) 
	{
		s ZCYOerd=retZCYOerd.list
		s ret3=ret3_ZCYOerd_$c(10)_$c(13)		
	}
	Do retZCYOerd.Close()
	d obj.S0158Text.SetAt(ret3,"中草药")
	
	
	//取中草药医嘱逐条明细
	//job:进程号，用以确定中草药医嘱所在Global位置
	s job = ##class(web.UDHCPrescriptQueryCM).allprint(EpisodeID)
	//医嘱总条数
	s totNum = ##class(web.UDHCPrescriptQueryCM).getnum(job)
	
	for num = 1:1:totNum
	{

		//一条医嘱
		s orderStr = ##class(web.UDHCPrescriptQueryCM).getallinfo(job,num)
	
		s itemStr = $P(orderStr,"^",15)
		//数量
		s qty = $P(orderStr,"^",19)
		//处方号
		s prescno=$P(orderStr,"^",3)
		//用法
		s method = $P(orderStr,"^",32)
		//频次
		s frequence = $P(orderStr,"^",23)
		//每次剂量
		s eachMake = $P(orderStr,"^",24)
		//总剂量
		s allMake = $P(orderStr,"^",25)
		//备注,去掉备注俩字
		s remark= $tr($tr($tr($P(orderStr,"^",22),"备注",""),":",""),"：","")
		//w remark_"*"
		//该条医嘱包含的草药数目
		s itemNum = $Length(itemStr,"|")
		s flag = 0
		for I = 1:1:itemNum-1
		{	
			s OrderInfo=##Class(EMRservice.entity.EOrderInfo).%New()
			//一种草药信息
			s item = $P(itemStr,"|",I)
			//取名称、剂量、单位
			s itembak=$p(item,"%",3)
			s item = $p(item,"%",1)			
			//取医嘱数量及单位
			s quatity=$p(item," ",$L(item," "))			
			//取医嘱名称
			s oeordname=$p(item,"  ",1)
			//处理医嘱名称格式
			if oeordname[" " {s oeordname=$p(oeordname," ",$l(oeordname," "))}			
			//取医嘱单位
			s unit=$e(quatity,$l(quatity),$l(quatity))
			s OrderInfo.E09=unit
			
			//取医嘱数量
			s quatity=$p(quatity,unit,1)
			//医嘱数量转换格式
			s quatity=$p(quatity,"*",1)*$p(quatity,"*",2)
			if quatity["." {s quatity=$fn(quatity,"",1)}
			s OrderInfo.E07=quatity
						
			//取医嘱备注
			s itembak2=$p($g(itembak),"/",1)
			//医嘱名称=医嘱名称(备注)
			if (itembak2'[" ")  s oeordname=oeordname_"("_itembak2_")"
			s OrderInfo.E04=oeordname
			s OrderInfo.E30="中草药"
			s OrderInfo.E31=prescno
			s OrderInfo.E33=I
			s OrderInfo.E34=itemNum-1
			s OrderInfo.Text=OrderInfo.E04_" "_OrderInfo.E07_OrderInfo.E09
			
			if itemStr'=""  //医嘱作废时不显示用法
			{
				if $l(method)>30   //判断用了最长那个用法的时候，不显示用法，只显示备注
				{s OrderInfo.E32="共"_qty_"付"_""_remark_$c(13,10)}
				else
				{s OrderInfo.E32="共"_qty_"付"_" "_$P(frequence," ",1)_" "_allMake_" "_method_" "_$P(frequence," ",2)_" "_"每次"_eachMake_$c(13,10)_$c(13,10)}
			}
			d obj.S0067Text.Insert(OrderInfo)		
		}	
	}
	Quit obj
}

/// Desc:       生成门急诊病历的临床数据中心共享文档
/// Creator:    guozongtao	
/// CreateDate: 2016-11-05
/// Input:      argArray  命令参数
/// OutPut:     
///             d ##Class(EMRservice.BL.SDHDSD000301).XMLSerialize()	
ClassMethod XMLSerialize(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s ReturnValue=##Class(%GlobalBinaryStream).%New()
	
	//s obj=##Class(EMRservice.BL.SDHDSD000301).%New()
	s obj=..CreateInstace(argArray)
    	
	d argOutData.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	;d argOutData.Write("<?xml-stylesheet type=""text/xsl"" href=""../南方医院门急诊病历.xslt""?>")
	d argOutData.Write("<?xml-stylesheet type=""text/xsl"" href=""/hip/emrviewdoctor/resources/南方医院门急诊病历.xslt""?>")
	d argOutData.Write("<clinicalDocument xmlns=""urn:hl7-org:v3"" xmlns:mif=""urn:hl7-org:v3/mif"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">")
	d argOutData.Write("<documentHeader>")
	d argOutData.Write("<realmCode></realmCode>")
	d argOutData.Write("<typeId>"_obj.typeId_"</typeId>")
	d argOutData.Write("<template>"_obj.template_"</template>")
	d argOutData.Write("<id>"_obj.Instanceid_"</id>")
	d argOutData.Write("<title>"_obj.title_"</title>")
	d argOutData.Write("<effectiveTime>"_obj.effectiveTime_"</effectiveTime>")
	
	d argOutData.Write("<confidentiality code=""级别代码"">"_obj.confidentiality_"</confidentiality>")
	d argOutData.Write("<versionNumber>"_obj.versionNumber_"</versionNumber>")
	d argOutData.Write("<author id="""_obj.authorid_""">"_obj.authorName_"</author>")
	
	d argOutData.Write("<custodian>"_obj.custodian_"</custodian>")
	d argOutData.Write("<patient>")
	d argOutData.Write("<medicareNo>"_obj.medicareNo_"</medicareNo>") 
	d argOutData.Write("<admvisitNo>"_obj.admvisitNo_"</admvisitNo>")	
	d argOutData.Write("<medRecordNo>"_obj.medRecordNo_"</medRecordNo>")
	d argOutData.Write("<healthCardNo>"_obj.healthCardNo_"</healthCardNo>")
	
	d argOutData.Write("<certificate>")
	d argOutData.Write("<name code="""_obj.certificateCode_""">"_obj.certificateDesc_"</name>")
	d argOutData.Write("<value>"_obj.certificateValue_"</value>")
	d argOutData.Write("</certificate>")
		
	d argOutData.Write("<addr desc=""现住址"">")
	d argOutData.Write("<text>"_obj.addrText_"</text>")
	d argOutData.Write("<houseNumber>"_obj.houseNumber_"</houseNumber>")
	d argOutData.Write("<streetName>"_obj.streetName_"</streetName>")
	d argOutData.Write("<township>"_obj.township_"</township>")
	d argOutData.Write("<county>"_obj.county_"</county>")
	d argOutData.Write("<city>"_obj.city_"</city>")
	d argOutData.Write("<state>"_obj.state_"</state>")
	d argOutData.Write("<postalCode>"_obj.postalCode_"</postalCode>")
	d argOutData.Write("</addr>")
	
	d argOutData.Write("<name>"_obj.name_"</name>")
	d argOutData.Write("<telecom>"_obj.telecom_"</telecom>")
	d argOutData.Write("<administrativeGender code="""_obj.administrativeGenderCode_""">"_obj.administrativeGenderValue_"</administrativeGender>")
	d argOutData.Write("<maritalStatus code="""_obj.maritalStatusCode_""">"_obj.maritalStatusValue_"</maritalStatus>")
	d argOutData.Write("<ethnicGroup code="""_obj.ethnicGroupCode_""">"_obj.ethnicGroupValue_"</ethnicGroup>")
	d argOutData.Write("<age year="""_obj.year_""" month="""_obj.month_""" day="""_obj.day_""" hour="""_obj.hour_""">"_obj.age_"</age>")
	d argOutData.Write("</patient>")
	
	d argOutData.Write("<participant>")
	d argOutData.Write("<code code="""_obj.participantCode_""">"_obj.participantValue_"</code>")
	d argOutData.Write("<addr desc=""联系人地址"">")
	d argOutData.Write("<text>"_obj.participantAddrText_"</text>")
	d argOutData.Write("<houseNumber>"_obj.participantAddrhouseNumber_"</houseNumber>")
	d argOutData.Write("<streetName>"_obj.participantAddrstreetName_"</streetName>")
	d argOutData.Write("<township>"_obj.participantAddrtownship_"</township>")
	d argOutData.Write("<county>"_obj.participantAddrcounty_"</county>")
	d argOutData.Write("<city>"_obj.participantAddrcity_"</city>")
	d argOutData.Write("<state>"_obj.participantAddrstate_"</state>")
	d argOutData.Write("<postalCode>"_obj.participantAddrpostalCode_"</postalCode>")
	d argOutData.Write("</addr>")
	d argOutData.Write("<telecom>"_obj.participanttelecom_"</telecom>")
	d argOutData.Write("<name>"_obj.participantName_"</name>")	
	d argOutData.Write("</participant>")
	d argOutData.Write("</documentHeader>")
	
	d argOutData.Write("<structuredBody>")
	d argOutData.Write("<E0004 desc=""姓名"">"_obj.E0004_"</E0004>")
	d argOutData.Write("<E0005 desc=""性别代码"">"_obj.E0005_"</E0005>")
	d argOutData.Write("<E0006 desc=""性别描述"">"_obj.E0006_"</E0006>")
	d argOutData.Write("<E0007 desc=""出生日期"">"_obj.E0007_"</E0007>")
	d argOutData.Write("<E0008 desc=""年龄"">"_obj.E0008_"</E0008>")
	d argOutData.Write("<E0023 desc=""民族代码"">"_obj.E0023_"</E0023>")
	d argOutData.Write("<E0024 desc=""民族描述"">"_obj.E0024_"</E0024>")
	d argOutData.Write("<E0028 desc=""职业类别代码"">"_obj.E0029_"</E0028>")
	d argOutData.Write("<E0029 desc=""职业类别描述"">"_obj.E0030_"</E0029>")
	d argOutData.Write("<E0030 desc=""婚姻代码"">"_obj.E0030_"</E0030>")
	d argOutData.Write("<E0031 desc=""婚姻描述"">"_obj.E0031_"</E0031>")
	d argOutData.Write("<E0032 desc=""患者住址（全）"">"_obj.E0032_"</E0032>")
	d argOutData.Write("<E0033 desc=""现住址-门牌号码"">"_obj.E0033_"</E0033>")
	d argOutData.Write("<E0034 desc=""现住地址-村（街、路、弄等）"">"_obj.E0034_"</E0034>")
	d argOutData.Write("<E0035 desc=""现住址-乡（镇、街道办事处）"">"_obj.E0035_"</E0035>")

	d argOutData.Write("<E0036 desc=""现住址-县（区）"">"_obj.E0036_"</E0036>")
	d argOutData.Write("<E0037 desc=""现住址-市（地区）"">"_obj.E0037_"</E0037>")
	d argOutData.Write("<E0038 desc=""现住址-省（自治区、直辖市）"">"_obj.E0038_"</E0038>")
	d argOutData.Write("<E0039 desc=""现住址邮政编码"">"_obj.E0039_"</E0039>")
	d argOutData.Write("<E0050 desc=""工作单位名称"">"_obj.E0050_"</E0050>")
	d argOutData.Write("<E0000 desc=""门诊号"">"_obj.E0000_"</E0000>")
	d argOutData.Write("<E0152 desc=""门诊类型代码"">"_obj.E0152_"</E0152>")
	d argOutData.Write("<E0153 desc=""门诊类型名称"">"_obj.E0153_"</E0153>")
	d argOutData.Write("<E0156 desc=""科室id"">"_obj.E0156_"</E0156>")
	d argOutData.Write("<E0077 desc=""科室"">"_obj.E0077_"</E0077>")
	d argOutData.Write("<E0158 desc=""医生签名日期"">"_obj.E0158_"</E0158>")
	d argOutData.Write("<E0159 desc=""医生签名时间"">"_obj.E0159_"</E0159>")
	d argOutData.Write("<E0160 desc=""签名医生代码"">"_obj.E0160_"</E0160>")
	d argOutData.Write("<E0161 desc=""签名医生姓名"">"_obj.E0161_"</E0161>")
	d argOutData.Write("<E0183 desc=""卡号"">"_obj.E0183_"</E0183>")
	d argOutData.Write("<E0081 desc=""入院时情况"">"_obj.E0081_"</E0081>")
	d argOutData.Write("<E0184 desc=""入院情况代码"">"_obj.E0184_"</E0184>")
	d argOutData.Write("<E0185 desc=""入院途径代码"">"_obj.E0185_"</E0185>")
	d argOutData.Write("<E0186 desc=""入院途径名称"">"_obj.E0186_"</E0186>")
	//b "s"
	d argOutData.Write("<E0201 desc=""病人ID"">"_obj.E0201_"</E0201>")
	d argOutData.Write("<E0150 desc=""费别代码"">"_obj.E0150_"</E0150>")
	d argOutData.Write("<E0151 desc=""费别名称"">"_obj.E0151_"</E0151>")
	d argOutData.Write("<E0082 desc=""患者入院日期"">"_obj.E0082_"</E0082>")
	d argOutData.Write("<E0220 desc=""门诊次数"">"_obj.E0220_"</E0220>")

	d argOutData.Write("<section code=""S0001"" desc=""主诉"">")
	s zhusu = ..replaceSBCcase(obj.S0001Text)
	d argOutData.Write("<text>"_zhusu_"</text>")
	d argOutData.Write("</section>")


	d argOutData.Write("<section code=""S0002"" desc=""现病史"">")
	s xianbingshi = ..replaceSBCcase(obj.S0002Text)
	d argOutData.Write("<text>"_xianbingshi_"</text>")
	//d argOutData.Write("<E01 desc=""临床症状"">"_obj.S0002E01_"</E01>")
	d argOutData.Write("<E01 desc=""临床症状"">"_zhusu_"</E01>")
	//d argOutData.Write("<E02 desc=""体征"">"_obj.S0002E02_"</E02>")
	s tizheng = ..replaceSBCcase(obj.S0020Text)
	d argOutData.Write("<E02 desc=""体征"">"_tizheng_"</E02>")
	d argOutData.Write("<E03 desc=""特殊病种"">"_obj.S0002E03_"</E03>")
	d argOutData.Write("</section>")
	
	d argOutData.Write("<section code=""S0003"" desc=""既往史"">")
	s jiwangshi = ..replaceSBCcase(obj.S0003Text)
	d argOutData.Write("<text>"_jiwangshi_"</text>")
	d argOutData.Write("</section>")

	d argOutData.Write("<section code=""S0019"" desc=""食物或药物过敏史"">")
	s guominshi = ..replaceSBCcase(obj.S0019Text)
	d argOutData.Write("<text>"_guominshi_"</text>")
	d argOutData.Write("</section>")

	d argOutData.Write("<section code=""S0020"" desc=""体格检查"">")
	s tigejiancha = ..replaceSBCcase(obj.S0020Text)
	d argOutData.Write("<text>"_tigejiancha_"</text>")
	d argOutData.Write("<E01 desc=""体温（℃）"">"_obj.S0020E01_"</E01>")
	d argOutData.Write("<E02 desc=""脉率（次/min）"">"_obj.S0020E02_"</E02>")
	d argOutData.Write("<E03 desc=""呼吸频率（次/min）"">"_obj.S0020E03_"</E03>")
	d argOutData.Write("<E04 desc=""收缩压（mmHg）"">"_obj.S0020E04_"</E04>")
	d argOutData.Write("<E05 desc=""舒张压(mmHg)"">"_obj.S0020E05_"</E05>")
	d argOutData.Write("<E06 desc=""身高（cm）"">"_obj.S0020E06_"</E06>")
	d argOutData.Write("<E07 desc=""体重（kg）"">"_obj.S0020E07_"</E07>")
	d argOutData.Write("<E08 desc=""BP（mmHg）"">"_obj.S0020E08_"</E08>")
	d argOutData.Write("</section>")

	d argOutData.Write("<section code=""S0149"" desc=""门诊诊断"">")
	s diagop = ..replaceSBCcase(obj.S0149.Text)
	d argOutData.Write("<text>"_diagop_"</text>")
	
	if (""'=obj.S0149.diagitems) {
	for i=1:1:obj.S0149.diagitems.Count()
	{
		d argOutData.Write("<section code=""S0048"" desc=""诊断"">")
		s diag = ..replaceSBCcase(obj.S0149.diagitems.GetAt(i).Text)
		d argOutData.Write("<text>"_diag_"</text>")
		s diagName=..replaceSBCcase(obj.S0149.diagitems.GetAt(i).E01)
		d argOutData.Write("<E01 desc=""诊断名称"">"_diagName_"</E01>")
		d argOutData.Write("<E02 desc=""诊断代码"">"_obj.S0149.diagitems.GetAt(i).E02_"</E02>")
		s docDiag=..replaceSBCcase(obj.S0149.diagitems.GetAt(i).E07)
		d argOutData.Write("<E07 desc=""医生填写的诊断"">"_docDiag_"</E07>")
		d argOutData.Write("<E09 desc=""诊断序号"">"_obj.S0149.diagitems.GetAt(i).E09_"</E09>")		
		d argOutData.Write("</section>")
	}
	}
	
	d argOutData.Write("</section>")
	
	d argOutData.Write("<section code=""S0072"" desc=""意见"">")
	s yijian = ..replaceSBCcase(obj.S0072Text)
	d argOutData.Write("<text>"_yijian_"</text>")
	d argOutData.Write("</section>")

	d argOutData.Write("<section code=""S0073"" desc=""处置"">")
	s chuzhi = ..replaceSBCcase(obj.S0073Text)
	d argOutData.Write("<text>"_chuzhi_"</text>")
	d argOutData.Write("</section>")

	d argOutData.Write("<section code=""S0158"" desc=""门急诊医嘱"">")
	d argOutData.Write("<text>")
	if (obj.S0158Text.GetAt("化验")'="")||(obj.S0158Text.GetAt("检查")'="")||(obj.S0158Text.GetAt("治疗")'="")
	{
		d argOutData.Write("处置:")
		d argOutData.Write(obj.S0158Text.GetAt("化验"))
		d argOutData.Write(obj.S0158Text.GetAt("检查"))
		d argOutData.Write(obj.S0158Text.GetAt("治疗"))
	}
	if (obj.S0158Text.GetAt("西药")'="")
	{
		d argOutData.Write("处方:")
		d argOutData.Write(obj.S0158Text.GetAt("西药"))	
	}
	if (obj.S0158Text.GetAt("中草药")'="")
	{
		d argOutData.Write("中草药:")
		d argOutData.Write(obj.S0158Text.GetAt("中草药"))
	}
	d argOutData.Write("</text>")
	
	for i=1:1:obj.S0067Text.Count()
	{
		d argOutData.Write("<section code=""S0067"" desc=""医嘱"">")
		d argOutData.Write("<text>")
		d argOutData.Write(obj.S0067Text.GetAt(i).Text)
		d argOutData.Write("</text>")

		d argOutData.Write("<E01 desc=""医嘱开始日期"">"_obj.S0067Text.GetAt(i).E01_"</E01>")
		d argOutData.Write("<E02 desc=""医嘱开始时间"">"_obj.S0067Text.GetAt(i).E02_"</E02>")
		d argOutData.Write("<E03 desc=""医嘱代码"">"_obj.S0067Text.GetAt(i).E03_"</E03>")
		d argOutData.Write("<E04 desc=""医嘱名称"">"_obj.S0067Text.GetAt(i).E04_"</E04>")
		d argOutData.Write("<E06 desc=""医嘱频次名称"">"_obj.S0067Text.GetAt(i).E06_"</E06>")
		d argOutData.Write("<E07 desc=""医嘱单次剂量"">"_obj.S0067Text.GetAt(i).E07_"</E07>")
		d argOutData.Write("<E09 desc=""医嘱单次剂量单位描述"">"_obj.S0067Text.GetAt(i).E09_"</E09>")
		d argOutData.Write("<E11 desc=""医嘱用法描述"">"_obj.S0067Text.GetAt(i).E11_"</E11>")
		d argOutData.Write("<E12 desc=""医嘱开立医师代码"">"_obj.S0067Text.GetAt(i).E12_"</E12>")
		d argOutData.Write("<E13 desc=""医嘱开立医师姓名"">"_obj.S0067Text.GetAt(i).E13_"</E13>")
		d argOutData.Write("<E14 desc=""医嘱审核日期"">"_obj.S0067Text.GetAt(i).E14_"</E14>")
		d argOutData.Write("<E15 desc=""医嘱审核时间"">"_obj.S0067Text.GetAt(i).E15_"</E15>")
		d argOutData.Write("<E25 desc=""药品规格"">"_obj.S0067Text.GetAt(i).E25_"</E25>")
		d argOutData.Write("<E26 desc=""药品总量"">"_obj.S0067Text.GetAt(i).E26_"</E26>")
		d argOutData.Write("<E28 desc=""药品总量单位描述"">"_obj.S0067Text.GetAt(i).E28_"</E28>")
		d argOutData.Write("<E29 desc=""医嘱大类代码"">"_obj.S0067Text.GetAt(i).E29_"</E29>")
		d argOutData.Write("<E30 desc=""医嘱大类描述"">"_obj.S0067Text.GetAt(i).E30_"</E30>")
		d argOutData.Write("<E31 desc=""处方号"">"_obj.S0067Text.GetAt(i).E31_"</E31>")
		d argOutData.Write("<E32 desc=""中草药服用方式"">"_obj.S0067Text.GetAt(i).E32_"</E32>")
		d argOutData.Write("<E33 desc=""本处方内的排序"">"_obj.S0067Text.GetAt(i).E33_"</E33>")
		d argOutData.Write("<E34 desc=""本处方医嘱总量"">"_obj.S0067Text.GetAt(i).E34_"</E34>")
		d argOutData.Write("</section>")
	}
	d argOutData.Write("</section>")
	
	d argOutData.Write("</structuredBody>")
	d argOutData.Write("</clinicalDocument>")
	
	Quit "1"
}

/// W ##Class(EMRservice.BL.SDHDSD000301).HospitalName("811")
ClassMethod HospitalName(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s HOSPDesc=""
	
	s PAADMDepCodeDR=$P($g(^PAADM(argAdmId)),"^",4)
	q:PAADMDepCodeDR="" ""
	s CTLOCHospitalDR=$P($g(^CTLOC(PAADMDepCodeDR)),"^",22)
	q:CTLOCHospitalDR="" ""
	s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)
	q HOSPDesc
}

ClassMethod CardType(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardTypeDR="",CARDDesc="",ReturnValue="",CARDCode=""
	
	s CardTypeDR=$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",7)
	if (CardTypeDR'="") 
	{
		s CARDCode = $p($g(^PAC("CARD",CardTypeDR)),"^",1)
		s CARDDesc = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	}
	s ReturnValue=CARDCode_"^"_CARDDesc
			
	q ReturnValue
}

ClassMethod CardNumber(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardNumber=""
	
	s CardNumber =$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",6)
			
	q CardNumber
}

ClassMethod Province(argPaperDR As %String) As %String
{
	//新现住址字段
	//PAPER_CT_Province_DR
	s curProvinceDesc=""
	s curprovinceDR = $p($g(^PAPER(argPaperDR,"PER",4)),"^",2)

	if (curprovinceDR'="")
	{	
		s curProvinceDesc = $p($g(^CT("PROV",curprovinceDR)),"^",2)
		i $l(curProvinceDesc,"-")'=1 {s curProvinceDesc=$p($g(curProvinceDesc),"-",2)} 
	}
	
	q curProvinceDesc
}

Query FindMZBLPrcseCZ(EpisodeID As %String) As %Query(ROWSPEC = "type:%String,name:%String") [ SqlProc ]
{
}

ClassMethod FindMZBLPrcseCZExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
  	q:EpisodeID="" ""
  	Set rset = ##Class(%ResultSet).%New("web.DHCFOrdGet:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	d rset.Execute(EpisodeID,"","","","","","")
	While (rset.Next())	{
		s OrderStatus=rset.Data("OrderStatus")
		continue:(OrderStatus="停止")
		s OrderFreq=rset.Data("OrderFreq")
		s type=""
		s name=""
		s OrderFreq=$$ALPHAUP^SSUTIL4(OrderFreq)
		s:(OrderFreq'="") OrderFreq=$o(^PHCFR(0,"Code",OrderFreq,""))
		s:(OrderFreq'="") OrderFreq=$p(^PHCFR(OrderFreq),"^",4)
		if ("检查"[rset.Data("TypeClass")) { 
			s type="检查"
			s name=rset.Data("OrderName")
			d OutputRow2
		} elseif ("检验"[rset.Data("TypeClass")) {
			s type="化验"
			s name=rset.Data("OrderName")
			d OutputRow2
			
		} elseif ("治疗"[rset.Data("TypeClass")) {
			Set managemenlistObj=##Class(DHCExternalService.RegInterface.Entity.SelfReg.List.managemenlist).%New()
			s type="治疗"
			//b ;type
			s name=rset.Data("OrderName")
			d OutputRow2	
	    }
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(type,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMZBLPrcseCZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMZBLPrcseCZExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMZBLPrcseCZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMZBLPrcseCZExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 	现住址街道乡镇
/// Table:	CT_HealthCareArea
ClassMethod AddressArea(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",20)
	if dr'=""
	{
		//CT_HealthCareArea
		s code = $p($g(^CT("HCA",dr)),"^",1)
	  	s desc = $p($g(^CT("HCA",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Desc: 	现住址区县
/// Table:	CT_HealthCareRegion
ClassMethod AddressRegion(argPaperID As %String) As %String
{
	q:(argPaperID="") ""
	
	s (retValue,dr,code,desc) = ""
	
	s dr = $P($G(^PAPER(argPaperID,"DHC")),"^",19)
	if dr'=""
	{
		//CT_HealthCareRegion
		s code = $p($g(^CT("HCR",dr)),"^",1)
	  	s desc = $p($g(^CT("HCR",dr)),"^",2)
	  	//过滤拼音码
	  	s:($l(desc,"-")>1) desc=$p(desc,"-",2)
		s retValue = dr_"^"_code_"^"_desc
	}
	
	q retValue
}

/// Creator:	wangwentao
/// CreatDate:	20130715 wangwentao add bjfcyy
/// Desc:	获取城区地址
/// Table:	DHC_Person.PAPER_CityFlag
/// Debug:	##class(EPRservice.HISInterface.PatientInfoAssist).CityAreaAddress(argPaperDR)
ClassMethod CityAreaAddress(argPaperDR As %String) As %String
{
	q:(argPaperDR="") ""
	
	s retValue = ""
	
	s (DHCPersonDR,CAAddressDR)=""
	s DHCPersonDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,DHCPersonDR))

	s:(DHCPersonDR'="") CAAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",12)
	
	if CAAddressDR'=""
	{
		s CAAddressDesc = $p($g(^CT("CITAREA",CAAddressDR)),"^",2)
		i $l(CAAddressDesc,"-")'=1 {s CAAddressDesc=$p($g(CAAddressDesc),"-",2)} 
		s CAAddressCode = $p($g(^CT("CITAREA",CAAddressDR)),"^",1)
		s retValue = CAAddressDR_"^"_CAAddressCode_"^"_CAAddressDesc
	}
	
	q retValue
}

/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod MaritalStatus(argPaperDR As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	q ..Marriage(argPaperDR)
}

/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod Marriage(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s maritalDR="",marital=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	if argHospital="BJJSTYY"	//北京积水潭
	{	s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)}
	else
	{
		s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",3)
	}
	
	if maritalDR'=""  
	{
		s code = $p($g(^CT("MAR",maritalDR)),"^",1)
		s desc = $p($g(^CT("MAR",maritalDR)),"^",2)
		s:($l(desc,"-")>1) desc=$tr($p($g(desc),"-",2)," ","")	//处理例如格式"4 - 丧偶"

		s marital=maritalDR_"^"_code_"^"_desc
	}
	
	q marital
}

/// Creator:	wangwentao
/// CreatDate:	20120418
/// Desc:	联系人地址
/// Table:	PA_Person.PAPER_ForeignNotes
/// Others:	/
ClassMethod LinkmanAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s (address,addressNum)=""

	s addressNum=$o(^PAPER(argPaperDR,"FNOTES",""),-1)
	
	q:(addressNum="") ""
	q:(($d(^PAPER(argPaperDR,"FNOTES",addressNum))'=1)&&($d(^PAPER(argPaperDR,"FNOTES",addressNum))'=11)) ""
 
	s address=$g(^PAPER(argPaperDR,"FNOTES",addressNum))
 
	q address
}

/// Create:	guozongtao 
/// Input:	argPapmiDr:	Pa_PatMas.Papmi_RowId
/// 		argAdmId:	Pa_Adm.PAADM_RowId
/// 		argAdmDate: Pa_Adm.PAADM_AdmDate
/// 		argAdmTime: Pa_Adm.PAADM_AdmTime
/// Output: 共享文档中的年、月、日、小时 年龄信息
/// Desc:	根据病人ID和就诊ID获取病人年龄
/// Debug:	w ##class(EMRservice.BL.SDHDSD000301).Age(219,191,64104,34498)
ClassMethod Age(argPapmiDr As %String, argAdmId As %String, argAdmDate As %String, argAdmTime As %String) As %String
{
	s ReturnValue="",StrGetPapmiAge="",year="",month="",day="",hour=""
	
	//调用年龄统一接口
	s StrGetPapmiAge = ##class(web.DHCBillInterface).GetPapmiAge(argPapmiDr,argAdmId,argAdmDate,argAdmTime)
	//20岁 3月9天  9天 1岁2月9天 23小时
	//s StrGetPapmiAge="23小时"
	if (StrGetPapmiAge["岁")
	{
		s year=$p(StrGetPapmiAge,"岁",1)
	}	
	
	if (StrGetPapmiAge["月")&&(StrGetPapmiAge["天")
	{
		s month=$p(StrGetPapmiAge,"月",1)
		s tmpday=$p(StrGetPapmiAge,"月",2)
		s day=$p(tmpday,"天",1)
	}	
	if (StrGetPapmiAge["天")&&($l(StrGetPapmiAge)<=3)
	{
		s day=$p(StrGetPapmiAge,"天",1)
	}	
	
	if (StrGetPapmiAge["岁")&&(StrGetPapmiAge["月")&&(StrGetPapmiAge["天")
	{
		s year=$p(StrGetPapmiAge,"岁",1)
		
		s tmpyear=$p(StrGetPapmiAge,"岁",2)
		s month=$p(tmpyear,"月",1)
		
		s tmpmonth=$p(StrGetPapmiAge,"月",2)
		s day=$p(tmpmonth,"天",1)
	}	
	if (StrGetPapmiAge["小时")&&($l(StrGetPapmiAge)<=4)
	{
		s hour=$p(StrGetPapmiAge,"小时",1)
	}	
	
	s ReturnValue=year_"^"_month_"^"_day_"^"_hour_"^"_StrGetPapmiAge
	
	q ReturnValue
}

/// Desc:	当前科室(即出院科室)
/// Return：RowId^Code^Desc
/// Others：被下列模块引用
ClassMethod CurrentDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s CurrentDept=""
	
	s DeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if DeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(DeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(DeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s CurrentDept=DeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q CurrentDept
}

/// Desc:	病人费用类型
/// Input:	argType {"D":Desc,"C":Code,"ALL":PayTypeDR_"^"_PayTypeCode_"^"_PayTypeDesc}
/// debug:  w ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(1)
ClassMethod PayType(argAdmId As %String, argType As %String = "D") As %String
{
	//病人费用类型
	//SQL:PAC_AdmReason

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argType)=0)||(argType="") ""
	
	s (PayTypeCode,PayTypeDesc,PayTypeDR)=""
	
	s PayTypeDR=$p($g(^PAADM(argAdmId,1)),"^",7)
	q:(PayTypeDR="") ""
	
	if (argType ="C")
	{
		s PayType = $p($g(^PAC("ADMREA",PayTypeDR)),"^",1)
	}
	elseif (argType ="D")
	{
		s PayType=$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}
	elseif (argType ="ALL")
	{
		s PayType = PayTypeDR_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",1)_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}

	q PayType
}

/// d ##Class(EMRservice.BL.SDHDSD000301).GetDiagnosforOPEMRInfo(761)
ClassMethod GetDiagnosforOPEMRInfo(argAdmId As %String, argTypeId As %String = "", argDiagCode As %String = "ICD10") As EMRservice.entity.EDiagnosInfo
{
	//通过argAdmId 取PAADM_MainMRADM_DR
	s MRAdmId="" 
	s MRAdmId=$p($g(^PAADM(argAdmId)),"^",61)

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:(MRAdmId="") ""
	q:($d(^MR(MRAdmId,"DIA"))'=10) ""
	
	s ReturnValue=##Class(EMRservice.entity.EDiagnosInfo).%New()
	s diagarr=##Class(%ArrayOfDataTypes).%New()

	s diagstr="",diagstr2="",diagstr3="",diag="",diagdesc="",diagcode="",diagnote="",diagDR="",diagsub="0",diagflag="",diagsymDR=""
	s count=0
	f  s diagsub=$o(^MR(MRAdmId,"DIA",diagsub)) q:diagsub=""  d
	. s diagDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",1)
	. s diagsymDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",10)
	. //兼容仅写诊断备注不选择诊断库的情况 并修改diagdesc diagflag取值
	. //q:(diagDR="")
	. //兼容diagcode取ICD10或RowID
	. s:($ZCVT(argDiagCode,"U")="ICD10") diagcode=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",4),1:"")
	. s:($ZCVT(argDiagCode,"U")="ROWID") diagcode=$s(diagDR'="":diagDR,1:"")
	. s diagdesc=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",2),1:"")
	. s diagflag=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",15),1:"")
	. s diagnote=$g(^MR(MRAdmId,"DIA",diagsub,"DES",1))
	. s count=count+1
	. i (diagnote'="")&&(diagdesc'="") d
	. . s diag=count_"."_diagdesc_"("_diagnote_")"_","
	. . s diagitem=##Class(EMRservice.entity.DiagItems).%New()
	. . b
	. . s diagitem.E01=diagdesc
	. . s diagitem.E02=diagcode
	. . s diagitem.E07=diagnote
	. . s diagitem.E09=diagsub
	. . s diagitem.Text=count_"."_diagdesc_"("_diagnote_")"
	. . d diagarr.SetAt(diagitem,count)
	. e  d  
	. . s diag=count_"."_diagdesc_diagnote_","
	. . s diagitem=##Class(EMRservice.entity.DiagItems).%New()
	. . b
	. . s diagitem.E01=diagdesc
	. . s diagitem.E02=diagcode
	. . s diagitem.E07=diagnote
	. . s diagitem.E09=diagsub
	. . s diagitem.Text=count_"."_diagdesc_"("_diagnote_")"
	. . d diagarr.SetAt(diagitem,count)
	. s diagstr=diagstr_diag
	
	s ReturnValue.Text=	diagstr
	s ReturnValue.diagitems=diagarr
	
	q ReturnValue
}

ClassMethod GetAdmtimes(papmi As %String)
{
	s rtn=0
    s rowidtype="" f  s rowidtype=$o(^PAPERdr(papmi,"ADM",rowidtype)) q:rowidtype=""  d
    .s rowid=""  f  s rowid=$o(^PAPERdr(papmi,"ADM",rowidtype,rowid)) q:rowid=""  d
    ..s arrive=$p(^PAADM(rowid),"^",20)
    ..i arrive="A"  s rtn=rtn+1
    
    q rtn
}

ClassMethod replaceSBCcase(value As %String) As %String
{
	q:(value="") ""
	
	s value = $Replace(value,"<","＜")
	s value = $Replace(value,">","＞")
	s value = $Replace(value,"=","＝")
	
	q value
}

/// *****************************************************************
/// **                                                             **
/// **                测试   代码   段落   Begin                   **
/// **                                                             **
/// *****************************************************************
/// d ##Class(EMRservice.BL.SDHDSD000301).testorderInfo(8273)
ClassMethod testorderInfo(EpisodeID)
{
	 // Create a Result object for the Sample.Person:ByName query
	 Set rset = ##class(%ResultSet).%New("web.DHCFOrdGet:FindAdmOrderItems")
	 Set columns = rset.GetColumnCount()
	
	 // Execute the query
	 Set sc = rset.Execute(EpisodeID,"","","","","","")
	
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

}
