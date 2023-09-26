Class DHCDoc.Interface.Outside.HLYYHZYY.Methods Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 干预-处方保存前调用
Parameter CheckCode = "GY_V4_FLEXIBLE";

/// 保存-HIS插入医嘱成功后调用
Parameter SaveCode = "GY_SF_V4";

/// 已保存处方进行数据修改(住院停止,撤销;门诊停止一张处方部分医嘱)
Parameter StopCode = "GY_SF_V4";

/// 删除已保存处方(住院作废;门诊停止一张处方全部医嘱)
Parameter DeleteCode = "CANCEL_GROUP_DRUG_V4";

/// 处方保存后,发送给审方系统,若第三方自动提取则可不用
Parameter ExamCode = "SF_V4_AUDIT_CENTER";

/// 打回处方双签处理
Parameter SignCode = "SF_V4_DOUBLE_SIGN";

/// 院内患者教育系统
Parameter PrintCode = "HJ_V4_TO_V3";

/// 院区编码,此处为空取HIS维护,多院区以HIS为准,不知道为啥单院区不一样
Parameter HospitalCode;

/// 集中处理干预,保存,停止,审方接口
ClassMethod CheckHLYYInfo(EpisodeID As %String, OrderItemStr As %String, OrderStr As %String, ExpStr As %String, ServiceMode As %String) As %String
{
	s $zt="CheckHLYYInfoErr"
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I"){
		;医嘱信息标签 草药暂时决定按照西药结构传输
		if (OrderStr="") {
			s MainObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetOrdersObj(EpisodeID,OrderItemStr,ExpStr)
		}else{
			s MainObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetVerifiedOrdersObj(EpisodeID,OrderStr,ExpStr)
		}
	}else{
		;处方及明细信息标签
		if (OrderStr="") {
			s MainObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetPrescObj(EpisodeID,OrderItemStr,ExpStr)
		}else{
			s MainObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetVerifiedPrescObj(EpisodeID,OrderStr,ExpStr)
		}
	}
	Q:MainObj="" ""
	;基础标签
	s BaseObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetBaseObj(EpisodeID)
	;就诊信息标签
	s PatientObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetPatientObj(EpisodeID)
	;诊断信息标签
	s DiagnosesObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetDiagnosesObj(EpisodeID)
	;过敏信息标签
    s AllergiesObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetAllergiesObj(EpisodeID)
    ;手术信息标签
    s OperationsObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetOperationsObj(EpisodeID)
    ;
	s InputObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.RootRq).%New()
	if (AdmType="I") {
		s InputObj.base=BaseObj
		s InputObj.iptpatient=PatientObj
		s InputObj.iptdiagnoses=DiagnosesObj
		s InputObj.iptallergies=AllergiesObj
		s InputObj.iptoperations=OperationsObj
		s InputObj.orders=MainObj
	}else{
		s InputObj.base=BaseObj
		s InputObj.optpatient=PatientObj
		s InputObj.optdiagnoses=DiagnosesObj
		s InputObj.optallergies=AllergiesObj
		s InputObj.optoperations=OperationsObj
		s InputObj.optprescriptions=MainObj
	}
	s InputStream=""
	d InputObj.XMLExportToStream(.InputStream,"root")
	b ;InputStream
    s OutputInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckMain(InputStream,ServiceMode)
    b ;OutputInfo
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DealWithHLYYInfo(OutputInfo,ServiceMode)
	Q HLYYInfo
CheckHLYYInfoErr
	Q "-2^接口调用报错:"_$replace($replace($ze,"^","#"),"<","!")
}

/// 具体服务编码在类最上方，不一致可以自行修改
/// 因为平台组没有统一的杭州逸曜接口，所以此处的接口类方法及入参需要根据项目修改
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckMain("","Save")
ClassMethod CheckMain(InputStream As %String, ServiceMode As %String) As %String [ ProcedureBlock = 0 ]
{
	s ExecMothod="set ServiceCode=..#"_ServiceMode_"Code"
	x ExecMothod
	s SoapObj=##class(web.DHCENS.EnsHISService).%New()
	s OutputInfo=SoapObj.DHCHisInterface(ServiceCode,InputStream)
	Q OutputInfo
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DealWithHLYYInfo($p(^jm("DealWithHLYYInfo"),",",1),"SF_V4_AUDIT_CENTER")
ClassMethod DealWithHLYYInfo(OutputInfo, ServiceMode) As %String
{
	if $ISObject(OutputInfo) s OutputInfo=OutputInfo.Read()
	s ^jm("DealWithHLYYInfo")=OutputInfo_","_ServiceMode
	s OutputInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).FormatXML(OutputInfo)
	b ;解析调用结果
	s InvokeFlag=0,InvokeInfo=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(OutputInfo)
	do reader.Correlate("invoke_result","DHCDoc.Interface.Outside.HLYYHZYY.Entity.InvokeResult")
	while reader.Next(.dataobj,.sc) {
		if (dataobj){
			;1 调用成功,0 调用失败
			s invokestatus=dataobj.invokestatus
			if (invokestatus=0) s InvokeFlag=-1
			s InvokeInfo=dataobj.invokemessage
		}
	}
	Q:InvokeFlag'=0 "-2^接口调用失败:"_InvokeInfo
	s HLYYInfo="0^"
	;干预解析提示信息
	if (ServiceMode="Check") {
		s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetAdvice(OutputInfo)
	}
	Q HLYYInfo
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetAdvice(^jm("GetAdvice"))
ClassMethod GetAdvice(OutputInfo As %String) As %String
{
	s ^jm("GetAdvice")=OutputInfo
	s AdviceFlag=0,AdviceInfo=""
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(OutputInfo)
	do reader.Correlate("info","DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Info")
	while reader.Next(.dataobj,.sc) {
		if (dataobj){
			s drugname=dataobj.drugname
			s errorinfo=dataobj.errorinfo
			s advice=dataobj.advice
			s severity=dataobj.severity
			if (severity>=8) s AdviceFlag="-1"
			s OneAdvice=drugname_"("_severity_")"_errorinfo_advice
			s OneAdvice=$replace(OneAdvice,$c(0),"")
			if (AdviceInfo="") s AdviceInfo=OneAdvice
			else  s AdviceInfo=AdviceInfo_"<br>"_OneAdvice
		}
	}
	Q AdviceFlag_"^"_AdviceInfo
}

/// 回写审方信息
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SaveExamResult(^jm("SaveExamResult"))
ClassMethod SaveExamResult(OutputInfo As %String) As %String
{
	s ^jm("SaveExamResult")=OutputInfo
	s rtn=0
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(OutputInfo)
	do reader.Correlate("result","DHCDoc.Interface.Outside.HLYYHZYY.Entity.RootRp")
	While reader.Next(.dataobj,.sc) {
		k PLIST
		;审核药师工号
		s pharmchkid=dataobj.checkpharmid
		;审核药师名称
		s pharmchkname=dataobj.checkpharmname
		;就诊流水号
		s AdmRowid=dataobj.base.eventno
		;来源
		s source=dataobj.base.source
		;
		s PLIST(2)=pharmchkid
		s PLIST(3)=pharmchkname
		s PLIST(4)=AdmRowid
		s PLIST(16)=+$h
		s PLIST(17)=$p($h,",",2)
		;TStart
		s MessageCount=dataobj.message.Count()
		b	;MessageCount
		for i=1:1:MessageCount {
			s MessageObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Message).%New()
			s MessageObj=dataobj.message.GetAt(i)
			continue:'$IsObject(MessageObj)
			;处方号
			s recipeid=MessageObj.recipeid
			;组号
			s groupno=MessageObj.groupno
			;成功标识 0:审核不通过,1:审核通过,2:超时通过,3:自动通过,5:失效药嘱通过,6:进行待审
			s issuccess=MessageObj.issuccess
			;状态 1:可双签名或修改,0:必须修改,2:审核通过不做处理
			s status=MessageObj.status
			;
			s PLIST(5)=recipeid
			s PLIST(6)=groupno
			s PLIST(7)=issuccess
			s PLIST(8)=status
			s InfoCount=MessageObj.infos.Count()
			b	;如果不存在infos标签,直接进行保存
			if (InfoCount=0) {
				&sql(Insert into SQLUser.DHC_DocHZYYExamResult values :PLIST())
				s rtn=rtn+SQLCODE
			}
			for j=1:1:InfoCount {
				s InfoObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Info).%New()
				s InfoObj=MessageObj.infos.GetAt(j)
				continue:'$IsObject(InfoObj)
				;一条警示信息的唯一id
				s infoid=$replace(InfoObj.infoid,$c(0),"")
				;医嘱id
				if (source="住院") s orderid=InfoObj.orderid
				else  s orderid=InfoObj.recipeitemid
				s orderid=$replace(orderid,$c(0),"")
				;错误等级
				s severity=$replace(InfoObj.severity,$c(0),"")
				;错误信息
				s errorinfo=$replace(InfoObj.errorinfo,$c(0),"")
				;建议
				s advice=$replace(InfoObj.advice,$c(0),"")
				;
				s PLIST(9)=infoid
				s PLIST(10)=orderid
				s PLIST(11)=severity
				s PLIST(12)=errorinfo
				s PLIST(13)=advice
				&sql(Insert into SQLUser.DHC_DocHZYYExamResult values :PLIST())
				s rtn=rtn+SQLCODE
				;Q:rtn'=0
			}
			;Q:rtn'=0
		}
		;if (rtn'=0) TRollback
		;TCommit	
	}
	Q rtn
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetBaseObj("2").XMLExport()
ClassMethod GetBaseObj(EpisodeID As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base
{
	s BaseObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base).%New()
	;医院Code
	s hospitalInfo=##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID)
	s hospitalId=$p(hospitalInfo,"^",1),hospitalcode=$p(hospitalInfo,"^",2)
	if (..#HospitalCode'="") s hospitalcode=..#HospitalCode
	s BaseObj.hospitalcode=hospitalcode
	;就诊流水号
	s BaseObj.eventno=EpisodeID
	;患者号(院内病人唯一ID)
	s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	s patientid=$p($g(^PAPER(PAPMIRowid,"PAT",1)),"^",1)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,PAPMIRowid,"I",hospitalId)
		if (MrNo'="") s patientid=MrNo	;新生儿可能没有住院号
	}
	s BaseObj.patientid=patientid
	;来源
	s BaseObj.source=$case(AdmType,"O":"门诊","E":"急诊","H":"体检","I":"住院")
	;审核接口 是否使用此节点取决于平台组对接模式
	;s BaseObj.posttype="1"
	Q BaseObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetPatientObj("2").XMLExport()
ClassMethod GetPatientObj(EpisodeID As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Patient
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	s PatObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Patient).%New()
	;性别
	s PatSexDesc=""
	s PatSexDr=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",7)
	if (PatSexDr'="") s PatSexDesc=$p($g(^CT("SEX",PatSexDr)),"^",2)
	s PatObj.sex=PatSexDesc
	;患者姓名
	s PatObj.name=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",1)
	;患者证件类型
	s CredTypeDesc=""
	s CredTypeDr=$p($g(^PAPER(PAPMIRowid,"PAT",3)),"^",7)
	if (CredTypeDr'="") s CredTypeDesc=$p($g(^PAC("CARD",CredTypeDr)),"^",2)
	s PatObj.idtype=CredTypeDesc
	;患者证件号码
	s PatObj.idno=$p($g(^PAPER(PAPMIRowid,"PAT",3)),"^",6)
	;出生时体重
	s PatObj.birthweight=""
	;出生日期
	s PatDob=$p($g(^PAPER(PAPMIRowid,"ALL")),"^",6)
	if (PatDob'="") s PatDob=$zd(PatDob,3)
	s PatObj.birthday=PatDob
	;;就诊卡号
	s PatientNo=$p($g(^PAPER(PAPMIRowid,"PAT",1)),"^",1)
	s CardNo=$p(##class(web.DHCOPAdmReg).GetCardNoByPatientNo(PatientNo),"^",1)
	s PatObj.medcardno=CardNo
	;费用类型
	s AdmReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	s PatObj.paytype=AdmReasonDesc
	;是否怀孕
	s PatObj.pregnancy="0"
	;孕期
	s PatObj.timeofpreg=""
	;是否哺乳
	s PatObj.breastfeeding="0"
	;身高
	s PatObj.height=""
	;体重
	s PatObj.weight=""
	;是否透析
	s PatObj.dialysis="0"
	;病人地址
	s PatAddr=""
	s PatAddrDr=$o(^PAPER(PAPMIRowid,"PER","ADD",0))
	if (PatAddrDr'="") s PatAddr=$g(^PAPER(PAPMIRowid,"PER","ADD",PatAddrDr))
	s PatObj.address=PatAddr
	;病人电话
	s PatObj.phoneno=$p($g(^PAPER(PAPMIRowid,"PER",1)),"^",11)
	;患者状态
	s PatObj.patientcondition="普通病人"
	;科室/病区
	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDepDesc=$p($g(^CTLOC(AdmDepDr)),"^",2)
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
	if (AdmType="I") {
		s PatObj.indeptid=AdmDepDr		;入院科室id
		s PatObj.indeptname=AdmDepDesc	;科室名称
		s PatObj.hospitalizedtime=$zd(AdmDate,3)_" "_..%ZT(AdmTime,1)	;入院时间
		s AdmWardDr=$p($g(^PAADM(EpisodeID)),"^",70)
		s PatObj.inwardid=AdmWardDr		;入院病区id
		s AdmWardDesc=$p($g(^PAWARD(AdmWardDr)),"^",2)
		s PatObj.inwardname=AdmWardDesc	;入院病区名称
		s AdmBedNo=""
		s AdmBedDr=$p($g(^PAADM(EpisodeID)),"^",73)
		if (AdmBedDr'="") s AdmBedNo=$p($g(^PAWARD(+AdmBedDr,"BED",$p(AdmBedDr,"||",2))),"^",1)
		s PatObj.inwardbedno=AdmBedNo	;入院病床号
		s PatObj.weightofbaby=""		;新生儿入院体重
	}else{
		s PatObj.deptid=AdmDepDr		;挂号科室id
		s PatObj.deptname=AdmDepDesc	;挂号科室名称
		s PatObj.eventtime=$zd(AdmDate,3)_" "_..%ZT(AdmTime,1)	;就诊时间
		s visittype="门诊"
		if (AdmType="E") s visittype="急诊"
		s PatObj.visittype=visittype	;就诊类别
	}
	Q PatObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetOrdersObj("","","").XMLExport()
ClassMethod GetOrdersObj(EpisodeID As %String, OrderItemStr As %String, ExpStr As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders
{
	s OrdersObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders).%New()
	s DrugItemNum=0
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s ARCIMRowid=$p(OrderItemOne,"^",1)
		s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
		continue:DrugFlag'="Y"
		s DrugItemNum=DrugItemNum+1
		;
		s MedicalOrderObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.MedicalOrderItem).%New()
		do ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetItemObj(.MedicalOrderObj,EpisodeID,OrderItemOne,"",ExpStr)
		do OrdersObj.MedicalOrderItem.Insert(MedicalOrderObj)
		do MedicalOrderObj.%Close()
	}
	Q:DrugItemNum<1 ""
	Q OrdersObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods)。GetVerifiedOrdersObj("","","").XMLExport()
ClassMethod GetVerifiedOrdersObj(EpisodeID As %String, OrderStr As %String, ExpStr As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders
{
	s OrdersObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders).%New()
	s DrugItemNum=0
	for i=1:1:$l(OrderStr,"^") {
		s OrderOne=$p(OrderStr,"^",i)
		continue:OrderOne=""
		if (OrderOne["*"){
			s ARCIMRowid=$p(OrderOne,"*",1)
			s OEORIRowId=$p(OrderOne,"*",2)
		}else{
			s OEORIRowId=OrderOne
			s ARCIMRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
		}
		continue:ARCIMRowid=""
		s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
		continue:DrugFlag'="Y"
		s DrugItemNum=DrugItemNum+1
		;
		s MedicalOrderObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.MedicalOrderItem).%New()
		do ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetItemObj(.MedicalOrderObj,EpisodeID,"",OEORIRowId,ExpStr)
		do OrdersObj.MedicalOrderItem.Insert(MedicalOrderObj)
		do MedicalOrderObj.%Close()
	}
	Q:DrugItemNum<1 ""
	Q OrdersObj
}

ClassMethod SetItemObj(ByRef object As %ObjectHandle, EpisodeID As %String, OrderItemOne As %String, OEORIRowId As %String, ExpStr As %String)
{
	s UserID=$p(ExpStr,"^",1)
	s DeptID=$p(ExpStr,"^",2)
	s IPAddress=$p(ExpStr,"^",3)
	if (OrderItemOne'="") {
		s OrderDate=$p(OrderItemOne,"^",46)
		s OrderTime=$p(OrderItemOne,"^",47)		;医嘱时间
		s PriorRowid=$p(OrderItemOne,"^",3)		;医嘱类型
		s ARCIMRowid=$p(OrderItemOne,"^",1)		;药品ID
		s DoseQty=$p(OrderItemOne,"^",12)		;单次剂量
		s DoseUOMRowid=$p(OrderItemOne,"^",13)	;剂量单位
		s InstrRowid=$p(OrderItemOne,"^",17)	;给药途径
		s FreqRowid=$p(OrderItemOne,"^",15)		;给药频率
		s PackQty=$p(OrderItemOne,"^",6)		;发药数量
		s OrderPackUOMRowid=$p(OrderItemOne,"^",55)	;发药数量单位
		s unitprice=$p(OrderItemOne,"^",7)		;单价
		s OrderStDate=$p(OrderItemOne,"^",4)
		s OrderStTime=$p(OrderItemOne,"^",5)	;医嘱生效时间
		s EndDate=$p(OrderItemOne,"^",26)
		s EndTime=$p(OrderItemOne,"^",27)		;医嘱失效时间
		s DurRowid=$p(OrderItemOne,"^",16)		;疗程
		s NotifyClinician=$p(OrderItemOne,"^",30)	;紧急标志
		s OrderNeedPIVAFlag=$p(OrderItemOne,"^",48)	;静配标志
		s SkinTest=$p(OrderItemOne,"^",21)		;皮试标志
		s SpeedFlowRate=$p(OrderItemOne,"^",36)
		s FlowRateUnitDR=$p(OrderItemOne,"^",45)	;给药速度
		s orderid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;医嘱id
		s groupno=$p(OrderItemOne,"^",19)
		if (groupno="") s groupno=$p(OrderItemOne,"^",20)	;组号
		s recipeid=EpisodeID_"^"_UserID_"^"_+$h_"^"_$p($h,",",2)	;处方ID
		s recipeitemid=EpisodeID_"^"_UserID_"^"_OrderStDate_"^"_OrderStTime_"^"_ARCIMRowid	;处方明细编号
		s specialprompt=$p(OrderItemOne,"^",11)		;备注
	}else{
		s OrderRowid=+OEORIRowId,ChildSub=$p(OEORIRowId,"||",2)
		s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
		if (OrderDate="") s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",17)
		if (OrderTime="") s OrderTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱时间
		s PriorRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8)	;医嘱类型
		s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)	;药品ID
		s DoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
		s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;每次给药剂量
		s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)	;给药途径
		s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)	;给药频率
		s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)	;发药数量
		s OrderPackUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",13)
		if (OrderPackUOMRowid="") s OrderPackUOMRowid=DoseUOMRowid	;发药数量单位
		;根据医嘱ID获取医嘱数量信息
		s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEORIRowId)
		if (PackQty'="") {
			if (+$p(OrdPackQtyInfo,"^",1)'=0){
				s PackQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",1))
			}
		}else{
			if (+$p(OrdPackQtyInfo,"^",4)'=0){
				s PackQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",4))
			}
		}
		s OrderStDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
		s unitprice=$p(##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,OrderStDate,"","","","","",""),"^",4)	;单价
		s OrderStTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",10)	;医嘱生效时间
		s EndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
		s EndTime=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",15)	;医嘱失效时间
		s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)	;疗程
		s NotifyClinician=$p(^OEORD(OrderRowid,"I",ChildSub,11),"^",55)	;紧急标志
		s OrderNeedPIVAFlag=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",16)	;住院静配标志
		s SkinTest=$p($g(^OEORD(OrderRowid,"I",ChildSub,5)),"^",2)	;皮试标志
		s SpeedFlowRate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",17)
		s FlowRateUnitDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,6)),"^",8)	;给药速度
		s orderid=OEORIRowId	;医嘱id
		s groupno=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
		if (groupno="") s groupno=OEORIRowId	;组号
		s recipeid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",14)	;处方ID
		s recipeitemid=OEORIRowId	;处方明细编号
		s specialprompt=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1)) ;备注
	}
	;药品ID
	s ARCIMCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)
	s object.drugid=ARCIMCode
	;药品名称
	s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	s object.drugname=ARCIMDesc
	;规格
	s specification=""
	s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	if (InciRowid'="") s specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	s object.specification=specification
	;生产厂家名称
	s manufacturername=""
	if (InciRowid'="") s manufacturername=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciRowid),"^",3)
	s object.manufacturername=manufacturername
	;每次给药剂量
	s DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
	s object.drugdose=DoseQty_DoseUOMDesc
	;给药途径
	s drugadminroutename=$p($g(^PHCIN(InstrRowid)),"^",2)
	s object.drugadminroutename=drugadminroutename
	;给药频率
	s drugusingfreq=$p(^PHCFR(FreqRowid),"^",3)
	s object.drugusingfreq=drugusingfreq
	;发药数量
	if (PackQty="") s PackQty="1"
	s object.despensingnum=PackQty
	;发药数量单位
	s packunit=""
	if (OrderPackUOMRowid'="") s packunit=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
	s object.packunit=packunit
	;包装规格数量
	s countunit=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).GetCountUnit(ARCIMRowid,InciRowid,OrderPackUOMRowid)
	s object.countunit=countunit
	;单价
	s object.unitprice=$fn(unitprice,"N")
	;总价
	s feetotal=unitprice*PackQty
	s object.feetotal=$fn(feetotal,"N")
	;给药时机
	s object.drugusingtimepoint=""
	;给药目的
	s object.drugusingaim=""
	;给药部位
	s object.drugusingarea=""
	;疗程
	s duration=""
	if (DurRowid'="") s duration=$p($g(^PHCDU(DurRowid)),"^",3)
	s object.duration=duration
	;剂型
	s preparation=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
	s object.preparation=preparation
	;特殊要求
	s object.specialprompt=specialprompt
	;是否退药标志
	s object.drugreturnflag="0"
	;皮试标志
	s skintestflag="0"
	if (SkinTest="Y") s skintestflag="1"
	s object.skintestflag=skintestflag
	;皮试结果
	s object.skintestresult=""
	;紧急标志
	s urgentflag="0"
	if (NotifyClinician="Y") s urgentflag="1"
	s object.urgentflag=urgentflag
	;给药速度
	s infusionspeed="",FlowRateUnit=""
	if (FlowRateUnitDR'="") s FlowRateUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
	if (SpeedFlowRate'="") s infusionspeed=SpeedFlowRate_FlowRateUnit
	s object.infusionspeed=infusionspeed
	;结算方式
	s object.medicaretype=""
	;组号
	s object.groupno=groupno
	;私有参数
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I"){
		;医嘱时间
		s OrderDate=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransDateFormat(OrderDate)
		s OrderTime=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransTimeFormat(OrderTime)
		s object.ordertime=OrderDate_" "_OrderTime
		;医嘱科室id
		s object.orderdeptid=DeptID
		;医嘱科室名称
		s orderdeptname=$p($g(^CTLOC(DeptID)),"^",2)
		if (orderdeptname["-") s orderdeptname=$p(orderdeptname,"-",2)
		s object.orderdeptname=orderdeptname
		;医嘱医疗组名称
		s object.docgroup=""
		;医嘱医生工号
		s orderdocid=$p($g(^SSU("SSUSR",UserID)),"^",1)
		s object.orderdocid=orderdocid
		;医嘱医生姓名
		s orderdocname=$p($g(^SSU("SSUSR",UserID)),"^",2)
		s object.orderdocname=orderdocname
		;医嘱医生职称
		s orderdoctitle=""
		s DoctorDR=$p($g(^SSU("SSUSR",UserID)),"^",14)
		if (DoctorDR'="") {
			s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
			if (CareProvTypeDR'="") s orderdoctitle=$p($g(^CT("CPT",CareProvTypeDR)),"^",2)
		}
		s object.orderdoctitle=orderdoctitle
		;医嘱类型
		s ordertype="临时医嘱"
		s LongFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		if (LongFlag=1) s ordertype="长期医嘱"
		s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
		if (PriorCode="OUT") s ordertype="出院带药"
		s object.ordertype=ordertype
		;复核时间
		s object.checktime=""
		;复核护士工号
		s object.checknurseid=""
		;复核护士姓名
		s object.checknursename=""
		;医嘱生效时间
		s OrderStDate=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransDateFormat(OrderStDate)
		s OrderStTime=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransTimeFormat(OrderStTime)
		s object.ordervalidtime=OrderStDate_" "_OrderStTime
		;医嘱失效时间
		s orderinvalidtime=""
		s EndDate=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransDateFormat(EndDate)
		s EndTime=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransTimeFormat(EndTime)
		if ((EndDate'="")&&(EndTime'="")) s orderinvalidtime=EndDate_" "_EndTime
		s object.orderinvalidtime=orderinvalidtime
		;医嘱停止标志
		s object.stopflag="0"
		if (EndDate'="") s object.stopflag="1"
		;住院静配标志
		s pivasflag="0"
		if (OrderNeedPIVAFlag="Y") s pivasflag="1"
		s object.pivasflag=pivasflag
		;特殊返回标志
		s object.specialreturnflag="0"
		;是否草药方
		s isherb=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).IsCNMedItem(EpisodeID,ARCIMRowid)
		s object.isherb=isherb
		;医嘱id
		s object.orderid=orderid
	}else{
		;门诊静配标志
		s ouvasflag="0"
		if (OrderNeedPIVAFlag="Y") s ouvasflag="1"
		s object.ouvasflag=ouvasflag
		;药品窗口
		s object.dispensingwindow=IPAddress
		;商品货架号
		s object.drugstorearea=""
		;开始使用时间
		s OrderStDate=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransDateFormat(OrderStDate)
		s OrderStTime=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).TransTimeFormat(OrderStTime)
		s object.starttime=OrderStDate_" "_OrderStTime
		;停止使用时间
		s object.endtime=""
		;处方id
		s object.recipeid=recipeid
		;处方明细编号
		s object.recipeitemid=recipeitemid
	}
	Q 0
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetPrescObj("","","").XMLExport()
ClassMethod GetPrescObj(EpisodeID As %String, OrderItemStr As %String, ExpStr As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions
{
	s PrescObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions).%New()
	s OptPrescriptionObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescription).%New()
	s OptPrescriptionInfoObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionInfo).%New()
	;赋值公共信息
	d ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetPrescObj(.OptPrescriptionInfoObj,EpisodeID,"",ExpStr)
	;处方类型
	s recipetype="西药方"
	;处方金额
	s recipefeetotal=0
	;饮片单帖价格
	s herbunitprice=""
	;饮片帖数
	s herbpacketcount=""
	s DrugItemNum=0
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s ARCIMRowid=$p(OrderItemOne,"^",1)
		s DrugFlag=##class(web.DHCDocHLYYHZYY).CheckIsDrugItem(ARCIMRowid)
		continue:DrugFlag'="Y"
		s DrugItemNum=DrugItemNum+1
		s CNMedItemFlag=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).IsCNMedItem(EpisodeID,ARCIMRowid)
		if (CNMedItemFlag=1) s recipetype="草药方"
		s unitprice=$p(OrderItemOne,"^",7)	;单价
		s PackQty=$p(OrderItemOne,"^",6)	;发药数量
		if (PackQty="") s PackQty=1
		s recipefeetotal=recipefeetotal+(unitprice*PackQty)
		if (recipetype="草药方") {
			s DoseQty=$p(OrderItemOne,"^",12)	;单次剂量
			s herbunitprice=herbunitprice+(unitprice*DoseQty)
			s DurRowid=$p(OrderItemOne,"^",16)
			s herbpacketcount=$p($g(^PHCDU(DurRowid)),"^",3)
		}
		;
		s OptPrescriptionItemObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionItem).%New()
		do ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetItemObj(.OptPrescriptionItemObj,EpisodeID,OrderItemOne,"",ExpStr)
		do OptPrescriptionObj.OptPrescriptionItem.Insert(OptPrescriptionItemObj)
		do OptPrescriptionItemObj.%Close()
	}
	Q:DrugItemNum<1 ""
	s OptPrescriptionInfoObj.recipetype=recipetype
	s OptPrescriptionInfoObj.recipefeetotal=$fn(recipefeetotal,"N")
	s OptPrescriptionInfoObj.herbunitprice=$fn(herbunitprice,"N")
	s OptPrescriptionInfoObj.herbpacketcount=herbpacketcount
	s OptPrescriptionObj.OptPrescriptionInfo=OptPrescriptionInfoObj
	;
	d PrescObj.OptPrescriptions.Insert(OptPrescriptionObj)
	Q PrescObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetVerifiedPrescObj("","","").XMLExport()
ClassMethod GetVerifiedPrescObj(EpisodeID As %String, OrderStr As %String, ExpStr As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions
{
	;获取本次审核所有的处方号
	s PrescNoStr=##class(web.DHCDocHLYYHZYY).GetPrescNoStrByOrder(OrderStr)
	Q:PrescNoStr="" ""
	;循环输出
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	s PrescObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions).%New()
	f i=1:1:$l(PrescNoStr,"^") {
		s PrescNo=$p(PrescNoStr,"^",i)
		continue:PrescNo=""
		s QueRowid=$o(^PAQUE1(0,"PrescNo",PrescNo,0))
		continue:QueRowid=""
		s OptPrescriptionObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescription).%New()
		s OptPrescriptionInfoObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionInfo).%New()
		;赋值公共信息
		d ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetPrescObj(.OptPrescriptionInfoObj,EpisodeID,PrescNo,ExpStr)
		;处方类型
		s recipetype="西药方"
		if ($d(^PAQUE1(QueRowid,"DHC"))) s recipetype="草药方"
		s OptPrescriptionInfoObj.recipetype=recipetype
		;处方金额
		s recipefeetotal=0
		;饮片单帖价格
		s herbunitprice=""
		;饮片帖数
		s herbpacketcount=""
		s ChildSub=0 for {
			s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowid,ChildSub))
			Q:ChildSub=""
			;判断医嘱状态
			s StatCode=""
			s ItemStatDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
			if (ItemStatDr'="") s StatCode=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
			continue:(StatCode'="V")&&(StatCode'="E")
			s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
			s CNMedItemFlag=##class(DHCDoc.Interface.Outside.HLYYHZYY.Public).IsCNMedItem(EpisodeID,ARCIMRowid)
			if (CNMedItemFlag=1) s recipetype="草药方"
			s OrderStDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
			s unitprice=$p(##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,OrderStDate,"","","","","",""),"^",4)	;单价
			s PackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)	;发药数量
			if (PackQty="") s PackQty=1
			s recipefeetotal=recipefeetotal+(unitprice*PackQty)
			if (recipetype="草药方") {
				s DoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)	;单次剂量
				s herbunitprice=herbunitprice+(unitprice*DoseQty)
				s DurRowid=$p(^OEORD(OrderRowid,"I",ChildSub,2),"^",6)
				s herbpacketcount=$p($g(^PHCDU(DurRowid)),"^",3)
			}
			;
			s OptPrescriptionItemObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionItem).%New()
			do ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SetItemObj(.OptPrescriptionItemObj,EpisodeID,"",OrderRowid_"||"_ChildSub,ExpStr)
			do OptPrescriptionObj.OptPrescriptionItem.Insert(OptPrescriptionItemObj)
			do OptPrescriptionItemObj.%Close()
		}
		s OptPrescriptionInfoObj.recipefeetotal=$fn(recipefeetotal,"N")
		s OptPrescriptionInfoObj.herbunitprice=$fn(herbunitprice,"N")
		s OptPrescriptionInfoObj.herbpacketcount=herbpacketcount
		s OptPrescriptionObj.OptPrescriptionInfo=OptPrescriptionInfoObj
		d PrescObj.OptPrescriptions.Insert(OptPrescriptionObj)
		do OptPrescriptionObj.%Close()
	}
	Q PrescObj
}

ClassMethod SetPrescObj(ByRef object As %ObjectHandle, EpisodeID As %String, PrescNo As %String, ExpStr As %String)
{
	s UserID=$p(ExpStr,"^",1)
	s DeptID=$p(ExpStr,"^",2)
	if (PrescNo="") {
		s recipeid=EpisodeID_"^"_UserID_"^"_+$h_"^"_$p($h,",",2)
		s recipetime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	}else{
		s recipeid=PrescNo
		s QueRowid=$o(^PAQUE1(0,"PrescNo",PrescNo,0))
		s TransDate=$p($g(^PAQUE1(QueRowid)),"^",7)
		s TransTime=$p($g(^PAQUE1(QueRowid)),"^",8)
		s recipetime=$zd(TransDate,3)_" "_$zt(TransTime,1)
	}
	;处方ID
	s object.recipeid=recipeid
	;处方号
	s object.recipeno=recipeid
	;处方来源
	s recipesource="其他"
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="O") s recipesource="门诊"
	if (AdmType="E") s recipesource="急诊"
	s object.recipesource=recipesource
	;开方科室ID
	s object.deptid=DeptID		
	;开方科室名称
	s deptname=$p($g(^CTLOC(DeptID)),"^",2)
	if (deptname["-") s deptname=$p(deptname,"-",2)
	s object.deptname=deptname
	;开方医生职称
	s recipedoctitle=""
	s DoctorDR=$p($g(^SSU("SSUSR",UserID)),"^",14)
	if (DoctorDR'="") {
		s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
		if (CareProvTypeDR'="") s recipedoctitle=$p($g(^CT("CPT",CareProvTypeDR)),"^",2)
	}
	s object.recipedoctitle=recipedoctitle
	;开方医生工号
	s recipedocid=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s object.recipedocid=recipedocid
	;开方医生姓名
	s recipedocname=$p($g(^SSU("SSUSR",UserID)),"^",2)
	s object.recipedocname=recipedocname
	;处方状态
	s object.recipestatus="0"
	;原始处方号
	s object.originalrecipeid=""
	;开方时间
	s object.recipetime=recipetime
	Q 0
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetDiagnosesObj("2").XMLExport()
ClassMethod GetDiagnosesObj(EpisodeID As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Diagnoses
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s DiagnosesObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Diagnoses).%New()
	s ChildSub=0 for {
		s ChildSub=$o(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s ICDCodeDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		continue:ICDCodeDr=""
		;诊断流水号
		s diagid=MRAdmRowid_"||"_ChildSub
		;诊断时间
		s UpdateDate=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",19)
		s UpdateTime=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",20)
		s diagdate=$zd(UpdateDate,3)_" "_..%ZT(UpdateTime,1)
		;诊断名称
		s diagname=$p($g(^MRC("ID",ICDCodeDr)),"^",2)
		;诊断编码
		s diagcode=$p($g(^MRC("ID",ICDCodeDr)),"^",1)
		;诊断状态
		s diagstatus="0"
		;诊断医生姓名
		s DiagUserID=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,1)),"^",18)
		s diagdocname=$p($g(^SSU("SSUSR",DiagUserID)),"^",2)
		;诊断类别
		s diagcategory="普通诊断"
		s MainDiagFlag=$p($g(^MR(MRAdmRowid,"DIA",ChildSub,1)),"^",20)
		if (MainDiagFlag="Y") s diagcategory="主要诊断"
		;诊断类型
		s diagtype=""
		s SubRowId=$o(^MR(MRAdmRowid,"DIA",ChildSub,"TYP",0))
		if (SubRowId'="") s DiagTypeDr=$g(^MR(MRAdmRowid,"DIA",ChildSub,"TYP",SubRowId))
		if ($g(DiagTypeDr)'="") s diagtype=$p($g(^MRC("DTYP",DiagTypeDr)),"^",2)
		;诊断编码类型
		s diagcodetype="1"
		s BillFlag3=$p($g(^MRC("ID",ICDCodeDr)),"^",15)
		if (BillFlag3="Y") s diagcodetype="2"
		;
		s OneDiagObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Diagnose).%New()
		s OneDiagObj.diagid=diagid
		s OneDiagObj.diagdate=diagdate
		s OneDiagObj.diagname=diagname
		s OneDiagObj.diagcode=diagcode
		s OneDiagObj.diagstatus=diagstatus
		s OneDiagObj.diagdocname=diagdocname
		s OneDiagObj.diagcategory=diagcategory
		s OneDiagObj.diagtype=diagtype
		s OneDiagObj.diagcodetype=diagcodetype
		if (AdmType="I") {
			d DiagnosesObj.IptDiagnosis.Insert(OneDiagObj)
		}else{
			d DiagnosesObj.OptDiagnosis.Insert(OneDiagObj)
		}
		d OneDiagObj.%Close()
	}
	Q DiagnosesObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetAllergiesObj("2").XMLExport()
ClassMethod GetAllergiesObj(EpisodeID As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Allergies
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
	s AllergiesObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Allergies).%New()
	s ChildSub=0 for {
		s ChildSub=$o(^PAPER(PAPMIRowid,"ALG",ChildSub))
		Q:ChildSub=""
		;过敏信息id
		s allergyid=PAPMIRowid_"||"_ChildSub
		;过敏物名称
		s allergydrug=""
		s DrgMastDr=$p($g(^PAPER(PAPMIRowid,"ALG",ChildSub)),"^",27)
		if (+DrgMastDr'=0) s allergydrug=$p($g(^PHCGE("GE",DrgMastDr)),"^",2)
		s ARCIMRowid=$p($g(^PAPER(PAPMIRowid,"ALG",ChildSub)),"^",30)
		if (+ARCIMRowid'=0)&&(allergydrug="") s allergydrug=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		s ALGTypeDR=$p($g(^PAPER(PAPMIRowid,"ALG",ChildSub)),"^",9)
		if (+ALGTypeDR'=0)&&(allergydrug="") s allergydrug=$p($g(^PAC("ALG",ALGTypeDR)),"^",2)		
		;continue:allergydrug=""
		;过敏信息状态
		s allergystatus="0"
		;记录时间
		s ALGDate=$p($g(^PAPER(PAPMIRowid,"ALG",ChildSub)),"^",10)
		s ALGTime=$p($g(^PAPER(PAPMIRowid,"ALG",ChildSub)),"^",15)
		s recordtime=$zd(ALGDate,3)_" "_$zt(ALGTime,1)
		;过敏反应
		s anaphylaxis=""
		;
		s OneAllergyObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Allergy).%New()
		s OneAllergyObj.allergyid=allergyid
		s OneAllergyObj.allergydrug=allergydrug
		s OneAllergyObj.allergystatus=allergystatus
		s OneAllergyObj.recordtime=recordtime
		s OneAllergyObj.anaphylaxis=anaphylaxis
		if (AdmType="I") {
			d AllergiesObj.IptAllergy.Insert(OneAllergyObj)
		}else{
			d AllergiesObj.OptAllergy.Insert(OneAllergyObj)
		}
		d OneAllergyObj.%Close()
	}
	Q AllergiesObj
}

/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetOperationsObj("2").XMLExport()
ClassMethod GetOperationsObj(EpisodeID As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Operations
{
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s OperationsObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Operations).%New()
	s opaRowid=0 for {
		s opaRowid=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaRowid))
		Q:opaRowid=""
		s opaStatus=$p($g(^DHCANOPArrange(opaRowid)),"^",27)
		continue:(opaStatus="D")||(opaStatus="C")
		s anaRowid=$p($g(^DHCANOPArrange(opaRowid)),"^",2)	;手术麻醉Id
		continue:anaRowid=""
		s anaopSub=0 for {
			s anaopSub=$o(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub))
			Q:anaopSub=""
			s curOperId=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub)),"^",6)	;手术表id
			continue:curOperId=""
			;手术id
			s operationid=anaRowid_"||"_anaopSub
			;手术编码
			s operationcode=$p($g(^ORC("OPER",curOperId)),"^",14)
			;手术名称
			s operationname=$p($g(^ORC("OPER",curOperId)),"^",2)
			;手术开始时间
			s opStartDate=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2))),"^",39)
			if (opStartDate="") s opStartDate=$p($g(^DHCANOPArrange(opaRowid)),"^",14)
			s opStartTime=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2))),"^",40)
			if (opStartTime="") s opStartTime=$p($g(^DHCANOPArrange(opaRowid)),"^",15)
			s operationstarttime=$zd(opStartDate,3)_" "_..%ZT(opStartTime,1)
			;手术结束时间
			s operationendtime=""
			s opEndDate=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2))),"^",41)
			if (opEndDate="") s opEndDate=$p($g(^DHCANOPArrange(opaRowid)),"^",16)
			s opEndTime=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2))),"^",42)
			if (opEndTime="") s opEndTime=$p($g(^DHCANOPArrange(opaRowid)),"^",17)
			if (opEndDate'="")&&(opEndTime'="") s operationendtime=$zd(opEndDate,3)_" "_..%ZT(opEndTime,1)
			;切口类型
			s operationincisiontype=""
			s opBladeTypeDr=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub)),"^",9)
			if (opBladeTypeDr'="") s operationincisiontype=$p($g(^ORC("BLDTP",opBladeTypeDr)),"^",2)
			;是否有植入物
			s isimplant="0"
			;
			s OneOperationObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Operation).%New()
			s OneOperationObj.operationid=operationid
			s OneOperationObj.operationcode=operationcode
			s OneOperationObj.operationname=operationname
			s OneOperationObj.operationstarttime=operationstarttime
			s OneOperationObj.operationendtime=operationendtime
			s OneOperationObj.operationincisiontype=operationincisiontype
			s OneOperationObj.isimplant=isimplant
			if (AdmType="I") {
				d OperationsObj.IptOperation.Insert(OneOperationObj)
			}else{
				d OperationsObj.OptOperation.Insert(OneOperationObj)
			}
			d OneOperationObj.%Close()
		}
	}
	Q OperationsObj
}

/// 处理删除接口
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DeleteHLYYInfo("")
ClassMethod DeleteHLYYInfo(EpisodeID As %String, OEORIRowId As %String) As %String
{
	s $zt="DeleteHLYYInfoErr"
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		;医嘱信息标签
		s OrdersObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders).%New()
		s MedicalOrderObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.MedicalOrderItem).%New()
		s MedicalOrderObj.orderid=OEORIRowId	;医嘱id
		s groupno=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),11)),"^",39)
		if (groupno="") s groupno=OEORIRowId
		s MedicalOrderObj.groupno=groupno	;组号
		do OrdersObj.MedicalOrderItem.Insert(MedicalOrderObj)
	}else{
		;处方信息标签
		s PrescObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions).%New()
		s OptPrescriptionObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescription).%New()
		s OptPrescriptionInfoObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionInfo).%New()
		s PrescNo=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",14)
		s OptPrescriptionInfoObj.recipeid=PrescNo
		s OptPrescriptionInfoObj.recipeno=PrescNo
		s OptPrescriptionObj.OptPrescriptionInfo=OptPrescriptionInfoObj
		do PrescObj.OptPrescriptions.Insert(OptPrescriptionObj)
	}
	;基础标签
	s BaseObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetBaseObj(EpisodeID)
	;医生信息
	s CTPCPRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",29)
	s docid=$p($g(^CTPCP(CTPCPRowid,1)),"^",1)
	s docname=$p($g(^CTPCP(CTPCPRowid,1)),"^",2)
	;
	s InputObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.DeleteRq).%New()
	s InputObj.base=BaseObj
	s InputObj.docid=docid
	s InputObj.docname=docname
	if (AdmType="I") {
		s InputObj.orders=OrdersObj
	}else{
		s InputObj.optprescriptions=PrescObj
	}
	s InputStream=""
	do InputObj.XMLExportToStream(.InputStream,"root")
	b	;InputStream.Read()
	s ServiceMode="Delete"
    s OutputInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckMain(InputStream,ServiceMode)
    b	;OutputInfo.Read()
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DealWithHLYYInfo(OutputInfo,ServiceMode)
	Q HLYYInfo
DeleteHLYYInfoErr
	Q "-2^接口调用报错:"_$replace($replace($ze,"^","#"),"<","!")
}

/// 处理双签接口
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SignHLYYInfo("4498009","4401512||217","","2788")
ClassMethod SignHLYYInfo(EpisodeID As %String, GroupOrPrescNo As %String, SignNotes As %String, UserID As %String) As %String
{
	s $zt="SignHLYYInfoErr"
	;基础标签
	s BaseObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetBaseObj(EpisodeID)
	;医生信息
	s docid=$p($g(^SSU("SSUSR",UserID)),"^",1)
	s docname=$p($g(^SSU("SSUSR",UserID)),"^",1)
	;医生反馈信息
	s FeedBackObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.FeedBack).%New()
	s FeedBackObj.message=SignNotes		;医生留言
	s FeedBackObj.status="1"			;状态
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (AdmType="I") {
		s FeedBackObj.groupno=GroupOrPrescNo	;组号
		s FeedBackObj.isherb="0"		;是否草药医嘱
	}else{
		s FeedBackObj.recipeid=GroupOrPrescNo	;处方id
	}
	s InputObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.SignRq).%New()
	s InputObj.base=BaseObj
	s InputObj.docid=docid
	s InputObj.docname=docname
	s InputObj.feedback=FeedBackObj
	s InputStream=""
	do InputObj.XMLExportToStream(.InputStream,"root")
	b	;InputStream.Read()
	s ServiceMode="Sign"
    s OutputInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).CheckMain(InputStream,ServiceMode)
    b	;OutputInfo.Read()
	s HLYYInfo=##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).DealWithHLYYInfo(OutputInfo,ServiceMode)
	Q HLYYInfo
SignHLYYInfoErr
	Q "-2^接口调用报错:"_$replace($replace($ze,"^","#"),"<","!")
}

/// 草药按照西药格式传入，也可以返回提示信息，实在不行的话可以参考本接口，按照草药格式传入
/// w ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).GetCMOrdersObj("4498009","","")
ClassMethod GetCMOrdersObj(EpisodeID As %String, OrderItemStr As %String, ExpStr As %String) As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders
{
	s CMOrdersObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders).%New()
	s HerbMedicalOrderObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrder).%New()
	s HerbMedicalOrderInfoObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderInfo).%New()
	;饮片单帖价格
	s herbunitprice=""
	s DrugItemNum=0
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s ARCIMRowid=$p(OrderItemOne,"^",1)
		continue:ARCIMRowid=""
		s DrugItemNum=DrugItemNum+1
		if (DrugItemNum=1) {
			;医嘱时间
			s OrderDate=$p(OrderItemOne,"^",46)
			s OrderTime=$p(OrderItemOne,"^",47)
			s HerbMedicalOrderInfoObj.ordertime=OrderDate_" "_OrderTime
			;医嘱科室id
			s orderdeptid=$p(ExpStr,"^",2)
			s HerbMedicalOrderInfoObj.orderdeptid=orderdeptid
			;医嘱科室名称
			s orderdeptname=$p($g(^CTLOC(orderdeptid)),"^",2)
			if (orderdeptname["-") s orderdeptname=$p(orderdeptname,"-",2)
			s HerbMedicalOrderInfoObj.orderdeptname=orderdeptname
			;医嘱医疗组名称
			s HerbMedicalOrderInfoObj.docgroup=""
			;医嘱医生工号
			s UserID=$p(ExpStr,"^",1)
			s orderdocid=$p($g(^SSU("SSUSR",UserID)),"^",1)
			s HerbMedicalOrderInfoObj.orderdocid=orderdocid
			;医嘱医生姓名
			s orderdocname=$p($g(^SSU("SSUSR",UserID)),"^",2)
			s HerbMedicalOrderInfoObj.orderdocname=orderdocname
			;医嘱医生职称
			s orderdoctitle=""
			s DoctorDR=$p($g(^SSU("SSUSR",UserID)),"^",14)
			if (DoctorDR'="") {
				s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
				if (CareProvTypeDR'="") s orderdoctitle=$p($g(^CT("CPT",CareProvTypeDR)),"^",2)
			}
			s HerbMedicalOrderInfoObj.orderdoctitle=orderdoctitle
			;医嘱类型
			s ordertype="临时医嘱"
			s PriorRowid=$p(OrderItemOne,"^",3)
			s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
			if (PriorCode="OUT") s ordertype="出院带药"
			s HerbMedicalOrderInfoObj.ordertype=ordertype
			;医嘱生效时间
			s OrderStDate=$p(OrderItemOne,"^",4)
			s OrderStTime=$p(OrderItemOne,"^",5)
			s HerbMedicalOrderInfoObj.ordervalidtime=OrderStDate_" "_OrderStTime
			;医嘱失效时间
			s orderinvalidtime=""
			s EndDate=$p(OrderItemOne,"^",26)
			s EndTime=$p(OrderItemOne,"^",27)
			if ((EndDate'="")&&(EndTime'="")) s orderinvalidtime=EndDate_" "_EndTime
			s HerbMedicalOrderInfoObj.orderinvalidtime=orderinvalidtime
			;医嘱停止标志
			s HerbMedicalOrderInfoObj.stopflag="0"
			if (EndDate'="") s HerbMedicalOrderInfoObj.stopflag="1"
			;饮片帖数
			s DurRowid=$p(OrderItemOne,"^",16)
			s herbpacketcount=$p($g(^PHCDU(DurRowid)),"^",2)
			s HerbMedicalOrderInfoObj.herbpacketcount=herbpacketcount
			;医嘱id
    		s HerbMedicalOrderInfoObj.orderid=$p(OrderItemOne,"^",19)
		}
		s HerbMedicalOrderItemObj=##class(DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderItem).%New()
		;医嘱id
		s HerbMedicalOrderItemObj.orderid=$p(OrderItemOne,"^",19)
    	;医嘱明细id
    	s HerbMedicalOrderItemObj.orderitemid=$p(OrderItemOne,"^",20)
    	;组号
    	s HerbMedicalOrderItemObj.groupno="1"
    	;药品ID
		s ARCIMCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)
		s HerbMedicalOrderItemObj.drugid=ARCIMCode
		;药品名称
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		s HerbMedicalOrderItemObj.drugname=ARCIMDesc
		;规格
		s specification=""
		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
		if (InciRowid'="") s specification=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
		s HerbMedicalOrderItemObj.specification=specification
    	;生产厂家名称
		s manufacturername=""
		if (InciRowid'="") s manufacturername=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciRowid),"^",3)
		s HerbMedicalOrderItemObj.manufacturername=manufacturername
		;每次给药剂量
		s DoseQty=$p(OrderItemOne,"^",12)
		s DoseUOMRowid=$p(OrderItemOne,"^",13)
		if (DoseUOMRowid="") s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
		s DoseUOMDesc=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
		s HerbMedicalOrderItemObj.drugdose=DoseQty_DoseUOMDesc
		;给药途径
		s InstrRowid=$p(OrderItemOne,"^",17)
		s drugadminroutename=$p($g(^PHCIN(InstrRowid)),"^",2)
		s HerbMedicalOrderItemObj.drugadminroutename=drugadminroutename
		;给药频率
		s FreqRowid=$p(OrderItemOne,"^",15)
		s drugusingfreq=$p($g(^PHCFR(FreqRowid)),"^",3)
		s HerbMedicalOrderItemObj.drugusingfreq=drugusingfreq
		;发药数量
		s PackQty=$p(OrderItemOne,"^",6)
		s HerbMedicalOrderItemObj.despensingnum=PackQty
		;发药数量单位
		s HerbMedicalOrderItemObj.packunit=DoseUOMDesc
    	;包装规格数量
    	s HerbMedicalOrderItemObj.countunit=PackQty
    	;单价
		s unitprice=$p(OrderItemOne,"^",7)
		s HerbMedicalOrderItemObj.unitprice=$fn(unitprice,"N")
		s herbunitprice=herbunitprice+unitprice
		;总价
		s feetotal=unitprice*PackQty
		s HerbMedicalOrderItemObj.feetotal=$fn(feetotal,"N")
		;剂型
		s preparation=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
		s HerbMedicalOrderItemObj.preparation=preparation
		;特殊要求
		s HerbMedicalOrderItemObj.specialprompt=$p(OrderItemOne,"^",22)
		;结算方式
		s HerbMedicalOrderItemObj.medicaretype=""
		d HerbMedicalOrderObj.HerbMedicalOrderItem.Insert(HerbMedicalOrderItemObj)
	}
	Q:DrugItemNum<1 ""
	s HerbMedicalOrderInfoObj.herbunitprice=$fn(herbunitprice,"N")
	s HerbMedicalOrderObj.HerbMedicalOrderInfo=HerbMedicalOrderInfoObj
	;
    d CMOrdersObj.HerbMedicalOrder.Insert(HerbMedicalOrderObj)
    Q CMOrdersObj
}

}
