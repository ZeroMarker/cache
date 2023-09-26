/// Creator:      tanjishan
/// CreatDate:    2021.08.31
/// Description:  用于对接卫宁医保监管平台
/// 对接：东软和卫宁
/// 调试前需按项目修改 DHCDoc.Interface.YiBaoJianGuan.LocalData.cls 中本地参数
/// 依赖的医保组接口：
/// 	1.【根据医嘱Rowid和项目编码获取三目信息的query】：##class(%ResultSet).RunQuery("web.DHCINSUPort","GetTarItemInfoByOrdId")
/// 	2.【医保审核分析接口】##class(INSU.OFFBIZ.BL.BIZ00A).InsuDocDetailedAuditService
/// 	3.【根据医嘱项ID获取医保目录对照收费信息-重庆】##class(web.DHCINSUPort).ArcimLinkInsuListN
/// 依赖的临床组接口：
/// 	查询手术数据接口：注意版本(数据对不上，请找对应产品组调整)
/// 	Query:web.DHCANAdaptor.cls FindOperationDTO
/// 本组接口方法：
/// 		##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:QryOeoriCommon")
/// 	##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
Class DHCDoc.Interface.YiBaoJianGuan.Business Extends (DHCDoc.Interface.YiBaoJianGuan.LocalData, DHCDoc.Util.RegisteredObject) [ ProcedureBlock ]
{

/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).CheckBusinessData("7289298","9","3102","1")
/// creator:	fuxiaonan
/// date:		2022.4.19
/// desc:		医保监管事前提醒、事中警醒的入参json串
/// input:		EpisodeID:就诊号
///             SceneType:
///             	事前场景：1:门诊挂号,2:门诊收费登记,3:住院登记,4:住院收费登记,5:住院执行医嘱
///             	事中场景：6	门诊结算;7	门诊预结算;8	住院结算;9	住院预结算;10	购药划卡
///             Type:3101或3102   【3101】明细审核事前分析服务;【3102】明细审核事中分析服务
/// 			UserID:登陆用户id
/// w ##class(DHCDoc.Interface.YiBaoJianGuan.Business).CheckBusinessData("935785","5","3102","11983","2","17790||1^R^3^2022-07-06^15:19:32^1^1.5000^83^32^3487||1^^10^65^30^21^1^75^1^^1^N^^Y^^^^^^^N^^^3^^^^undefined^^^^^^^^^2022-07-06^15:19:32^N^^^^^N^^14^^N^^^^^^^^N^1^^N")
/// w ##class(DHCDoc.Interface.YiBaoJianGuan.Business).CheckBusinessData("2819","2","3101","18881","60","")
ClassMethod CheckBusinessData(EpisodeID As %String, SceneType As %String, Type As %String, UserID As %String, CTLocID As %String, OrdStr As %String = "") As %String
{
	s ^templog("CheckBusinessData")=$lb(EpisodeID,SceneType,Type,UserID,CTLocID,OrdStr)
	s $ZT="CheckBusinessDataErr"
	;20220510 做了医保登记的患者就诊才进行国家医保监管系统的调用 
	s InsuAdmInfo=##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID) 
	q:InsuAdmInfo="" "0^"
	
	s AdmReason=$P(^PAADM(EpisodeID,1),"^",7)
	q:AdmReason="" "100^患者就诊费别信息为空"
	s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReason)),"^",2)
	if (AdmReason=1){
		;q "100^"
	}
	s ParamObj=..GetParamObj(EpisodeID, Type, AdmReason, UserID) 
	s DataObj=..GetDataDTO(EpisodeID,SceneType,Type,"",UserID,CTLocID,OrdStr)
	;走医保封装的报文以及http请求
	S Rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDocDetailedAuditService(ParamObj,DataObj)	
	b ;Rtn
	i $p(Rtn,"^",1)=1{
		;调http成功
		s CheckStr=$p(Rtn,"^",2)
		q:CheckStr="" "101^"
		;{"infcode":"0","inf_refmsgid":"410000202204121025121147467849","refmsg_time":"20220412102511984","respond_time":"20220412102512204","enctype":"","signtype":"","err_msg":null,"output":{"result":[{"judge_result_detail_dtos":[{"vola_item_type":"1","mdtrt_id":"20220408170927677270","jrd_id":"58f0952b-3e4a-4af3-8571-058ead35e016","patn_id":"82121456303798152","rx_id":"","vola_amt":null}],"rule_id":"410000202112311644461000093054","vola_evid":"部分地市医保部门日常管理要求","mdtrt_id":"20220408170927677270","rule_name":"男性患者就诊妇产科_事前","vola_amt_stas":"1","jr_id":"1a77ae7b-4e58-41dc-9e01-9d37cf96eaaf","patn_id":"82121456303798152","sev_deg":"2","vola_amt":0.0,"vola_bhvr_type":"1","vola_cont":"根据参保人信息显示为【男】，但挂了【妇产科】"},{"judge_result_detail_dtos":[{"vola_item_type":"1","mdtrt_id":"20220408170927677270","jrd_id":"c4bba387-c44f-40c3-ac46-12a2feb35b96","patn_id":"82121456303798152","rx_id":"","vola_amt":null}],"rule_id":"JA00000001030070000","vola_evid":"基本临床诊疗规范","mdtrt_id":"20220408170927677270","rule_name":"男性患者就诊妇产科_事前","vola_amt_stas":"1","jr_id":"a638a47c-1a00-4760-ac8f-5d38b6cf321b","patn_id":"82121456303798152","sev_deg":"2","vola_amt":0.0,"vola_bhvr_type":"1","vola_cont":"根据参保人信息显示为【男】，但挂了【妇产科】"},{"judge_result_detail_dtos":[{"vola_item_type":"1","mdtrt_id":"20220408170927677270","jrd_id":"a528ea13-6900-4ca8-8955-e9e064ba02fb","patn_id":"82121456303798152","rx_id":"","vola_amt":null}],"rule_id":"410000202109162313391000044038","vola_evid":"部分地市医保部门日常管理要求","mdtrt_id":"20220408170927677270","rule_name":"男性患者就诊妇产科_事前","vola_amt_stas":"1","jr_id":"4bd07e4f-7ee0-46f6-bfbe-e30e72bd47b5","patn_id":"82121456303798152","sev_deg":"2","vola_amt":0.0,"vola_bhvr_type":"1","vola_cont":"根据参保人信息显示为【男】，但挂了【妇产科】"}]}}
		s Arr=##Class(DHCDoc.Util.FromXML).Json2Arr(CheckStr)
		q:'$IsObject(Arr) "102^医保监管平台返回数据解析失败"
		if (Arr.Data("infcode")'=0){
			q "-100^调用医保监管平台失败:"_Arr.Data("err_msg")
		}else{
			/*s RuleStr=""
			s result=Arr.Data("output").Data("result")
			i result.Size>0{
				;有违规信息提醒
				for ii=1:1:result.Size{
					s OneData=result.GetAt(ii)
					continue:'$IsObject(OneData)
					s RuleName=OneData.Data("rule_name")
					s volacont=OneData.Data("vola_cont")
					i volacont'="" s RuleName=RuleName_":"_volacont
					s resultdetail=OneData.Data("judge_result_detail_dtos")
					s RuleStr=$s(RuleStr'="":RuleStr_"<br>"_RuleName,1:RuleName)
				}
			}else{
				;无违规信息 
			}*/
			s ArrayObj=Arr.Data("output").Data("result")
			s AdviceJsonStr=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj).Read()
			q "0^"_AdviceJsonStr
		}
	}else{
		b ;调http失败
	}
	quit Rtn
CheckBusinessDataErr
	b ;err
	Q "-100^调用医保监管平台失败:"_$replace($ZE,"^","#")
}

/// creator:	fuxiaonan
/// date:		2022.4.19
/// desc:		获取参保人信息串
/// input:		EpisodeID:就诊号
///             SceneType:
///             	事前场景：1:门诊挂号,2:门诊收费登记,3:住院登记,4:住院收费登记,5:住院执行医嘱
///             	事中场景：6	门诊结算;7	门诊预结算;8	住院结算;9	住院预结算;10	购药划卡
///             Type:3101或3102   【3101】明细审核事前分析服务;【3102】明细审核事中分析服务
/// output:		json串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetDataDTO(7275037,"2","3101",1)
ClassMethod GetDataDTO(EpisodeID As %String, SceneType As %String, Type As %String, Json As %String = "", UserID As %String = "", CTLocID As %String = "", OrdStr As %String = "") As DHCDoc.Util.ArrayData
{

	s Obj=##class(DHCDoc.Util.ArrayData).%New()
	s PatDTO=..GetPatDTO(EpisodeID,"",UserID,CTLocID,OrdStr)
	d Obj.SetAt(PatDTO,"patient_dtos")					///参保人信息
	s ruleids=##class(DHCDoc.Util.ListData).%New()
	d Obj.SetAt(ruleids,"rule_ids")				///规则标识集合
	s trigscen=SceneType
	d Obj.SetAt(trigscen,"trig_scen")				///触发场景
	s syscode=..GetConfig("syscode")
	d Obj.SetAt(syscode,"syscode")				///syscode
	
	s DataObj=##class(DHCDoc.Util.ArrayData).%New()
	d DataObj.SetAt(Obj,"data")	
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(DataObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetDataDTO
		q JsonStr
	}
	q DataObj
}

/// debugger: w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetParamObj(7275037,"3101",41,1)
ClassMethod GetParamObj(EpisodeID As %String, Type As %String, AdmReasonDr As %String, UserId As %String, Json As %String = "") As DHCDoc.Util.ArrayData
{
	s Obj=##class(DHCDoc.Util.ArrayData).%New()
	Q:EpisodeID="" Obj
	s HospitalId=..GetAdmHospitalId(EpisodeID) 
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6)
	s ParamObj=##class(DHCDoc.Util.ArrayData).%New()
	d ParamObj.SetAt(Type,"INFNO")
	d ParamObj.SetAt(EpisodeID,"EpisodeID")
	d ParamObj.SetAt(HospitalId,"HOSPID")
	d ParamObj.SetAt(UserId,"UserId")
	d ParamObj.SetAt(InsuType,"InsuType")
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ParamObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetDataDTO
		q JsonStr
	}

	q ParamObj
}

/// 获取患者个人信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetPatDTO(7275037,1)
ClassMethod GetPatDTO(EpisodeID As %String, Json As %String = "", UserID As %String = "", CTLocID As %String = "", OrdStr As %String = "") As DHCDoc.Util.ArrayData
{
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s PatSexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	s PatSexCode=$s(PatSexDr'="":$p($g(^CT("SEX",PatSexDr)),"^",1),1:"") ;性别
	
	s PatBirth=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s PatBirth=$s(PatBirth'="":$zd(PatBirth,3),1:"")
	s poolarea=+..GetINADMInfo(EpisodeID)    //////////////////待传
	s Obj=##class(DHCDoc.Util.ArrayData).%New()
	d Obj.SetAt(PatientID,"patn_id")				///参保人标识
	d Obj.SetAt(PatName,"patn_name")				///就诊流水号
	d Obj.SetAt(PatSexCode,"gend")					///gend	性别
	d Obj.SetAt(PatBirth,"brdy")					///brdy	出生日期
	d Obj.SetAt(poolarea,"poolarea")				///poolarea	统筹区编码
	d Obj.SetAt(EpisodeID,"curr_mdtrt_id")			////curr_mdtrt_id	当前就诊标识
	
	s AdmDTO=..GetAdmDTO(EpisodeID,"",UserID,CTLocID,OrdStr)
	d Obj.SetAt(AdmDTO,"fsi_encounter_dtos")				///就诊信息集合
	s HospDTO=##class(DHCDoc.Util.ListData).%New()
	d Obj.SetAt(HospDTO,"fsi_his_data_dto")				///医院信息集合
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(Obj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetPatDTO
		w JsonStr,!
	}
	
	q Obj
}

/// 获取就诊信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetAdmDTO(7275037,1)
ClassMethod GetAdmDTO(EpisodeID As %String, Json As %String = "", UserID As %String = "", CTLocID As %String = "", OrdStr As %String = "") As DHCDoc.Util.ListData
{
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospitalId=..GetAdmHospitalId(EpisodeID) ;##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=$P(^CT("HOSP",HospitalId),"^",1)
	s HospitalName=$P(^CT("HOSP",HospitalId),"^",2)
	s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)
	s AdmDateStr=$ZD(AdmDate,3)_" "_$ZT(AdmTime)
	if (AdmType="I"){
		s DisChangeDateInfo=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
		//出院日期
		s DischgeDateSys=$p(DisChangeDateInfo,"^",1)
		s DischgeTimeSys=$p(DisChangeDateInfo,"^",1)
		s DischgeDateStr=$ZD(AdmDate,3)_" "_$ZT(AdmTime)
	}else{
		s DischgeDateStr=AdmDateStr
	}
	s mradm=##Class(web.DHCPAADM).GetMRAdmID(EpisodeID)
	s (dscgMainDiseCodg,dscgMainDiseName,FirstDiagCode,FirstDiagDesc)=""
	Set rsObj=##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	If rsObj.QueryIsValid() { 
		Set Status=rsObj.Execute(mradm,"","")
		If 'Status Quit
		While rsObj.Next() {
			Set MainDiagFlag=rsObj.GetData(11)
			Set DiagnosICDCode=rsObj.GetData(5)
			continue:(DiagnosICDCode="")
			Set DiagnosDesc=rsObj.GetData(1)
			continue:(DiagnosDesc="")
			s FirstDiagCode=DiagnosICDCode
			s FirstDiagDesc=DiagnosDesc
			continue:(MainDiagFlag'="Y")   //ceshi
			Set dscgMainDiseCodg=DiagnosICDCode
			Set dscgMainDiseName=DiagnosDesc
			quit
		}
	}
	s dscgMainDiseCodg=$s(dscgMainDiseCodg="":FirstDiagCode,1:dscgMainDiseCodg)
	s dscgMainDiseName=$s(dscgMainDiseName="":FirstDiagDesc,1:dscgMainDiseName)
	s DocName=""
	Set Doctor=$P($g(^PAADM(EpisodeID)),"^",9)
	If Doctor'="" Set DocName=$P($g(^CTPCP(Doctor,1)),"^",2)
	s (AdmDeptDr,AdmDeptCode,AdmDeptDesc,DischgeLocDr,DischgeLocCode,DischgeLocDesc)=""
	if (AdmType="I"){
		s AdmDeptStr=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(EpisodeID,HospitalId)
		s AdmDeptDr=$P(AdmDeptStr,"^",1)
		
		If AdmDeptDr'=""{
			Set AdmDeptDesc=$P($g(^CTLOC(AdmDeptDr)),"^",2)
			s AdmDeptCode=$P($g(^CTLOC(AdmDeptDr)),"^",1)
		}
		s DischgeLocDr=$P($g(^PAADM(EpisodeID)),"^",4)
		If DischgeLocDr'="" Set DischgeLocDesc=$P($g(^CTLOC(DischgeLocDr)),"^",2)
		
	}else{
		s AdmDeptDr=$P($g(^PAADM(EpisodeID)),"^",4)
		If AdmDeptDr'=""{
			Set AdmDeptDesc=$P($g(^CTLOC(AdmDeptDr)),"^",2)
			s AdmDeptCode=$P($g(^CTLOC(AdmDeptDr)),"^",1)
		}
		s DischgeLocDr=AdmDeptDr
		s DischgeLocDesc=AdmDeptDesc
	}
	s DischgeLocCode=$s(DischgeLocDr'="":$P($g(^CTLOC(DischgeLocDr)),"^",1),1:"")
	s AdmDeptStr=..GetCountryData(EpisodeID,AdmDeptCode,HospitalId)
	s AdmDeptCode=$p(AdmDeptStr,"^",1)
	s AdmDeptDesc=$p(AdmDeptStr,"^",2)
	s DischgeLocStr=..GetCountryData(EpisodeID,AdmDeptCode,HospitalId)
	s DischgeLocCode=$p(DischgeLocStr,"^",1)
	s DischgeLocDesc=$p(DischgeLocStr,"^",2)
	s (WardCode,WardDesc,BEDRoomCode,PAAdmBedNO)=""
	Set WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	if (WardDr'=""){
		s WardCode = $P($g(^PAWARD(WardDr)),"^",1)
		s WardDesc = $P($g(^PAWARD(WardDr)),"^",2)
	}
	s WardStr=..GetCountryData(EpisodeID,AdmDeptCode,HospitalId)
	s WardCode=$p(WardStr,"^",1)
	s WardDesc=$p(WardStr,"^",2)
	s PAADMBedDR = $p($g(^PAADM(EpisodeID)),"^",73)
	if (PAADMBedDR '= ""){
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		if (BEDRoomDR'=""){
			s BEDRoomCode = $p($g(^PAROOM(BEDRoomDR)),"^",1)
		}
		s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}else{
		s PAAdmWard = ""
		s PAAdmBedNO = ""
	}
	s AdmReason=$P(^PAADM(EpisodeID,1),"^",7)
	s AdmReasonDesc=$p($g(^PAC("ADMREA",AdmReason)),"^",2)
	s AdmLocName=""
	Set AdmLocDr=$P($g(^PAADM(EpisodeID)),"^",4)
	If AdmLocDr'="" Set AdmLocName=$P($g(^CTLOC(AdmLocDr)),"^",2)
	//1门诊  2住院  3购药   4其他
	s medMdtrtType=$CASE(AdmType,"O":1,"E":4,"I":2,:4)
	s medType=..GetMedType(EpisodeID)
	
	///处方(医嘱)信息，OrderD
	if OrdStr'=""{
		s orderDtos=..GetOrdSDTO(EpisodeID,"",UserID,CTLocID,OrdStr)
	}else{
		s orderDtos=..GetAllOrdSDTO(EpisodeID)	
	}
	///诊断信息DTO
	s diagnoseDtos=..GetDiagnoseDTO(EpisodeID)
	 //手术操作DTO
	s operationDtos=..GetANAdaptorDTO(EpisodeID)
	
	
	///TODO
	s matnStas="0"		///生育状态，[0=其他, 1=妊娠期, 2=哺乳期]
	s medfeeSumamt="0"		///总费用
	s ownpayAmt="0"		///自费金额
	s seIfpayAmt="0"		///自付金额
	s acctPayamt="0"		///个人账户支付金额
	s maAmt="0"			///救助金支付金额
	s hifpPayamt="0"		///统筹金支付金额
	s setlTotlnum=1					///结算总次数
	s insutype=$p(##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID),"^",36) ;险种  ..GetINSUTYPE(EpisodeID)		///险种，参考字典表-险种类型
	s reimFlag=0 ;		///报销标志,参考字典表-支付地点类别[PAY_LOC],    ceshi
	s outSetlFlag=$p(##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(EpisodeID),"^",51) ;异地结算标志
	s remoteTask=""		///异地任务
	s specialCaseDesc=""		///特殊情况说明
	s diseaseNum=""		///病种编号
	s diseaseName=""		///病种名称
	s villageDoc=""		///村医
	s personType=""		///村医
	s inHisPerson=""		///（截至到前一天12点没出院的就诊次数）
	s upponInHisPerson=""		///当日入院人数
	s upponOutHisPerson=""		///（就诊当天出院的就诊次数）
	s MedinsAdmdvs=##class(LocalData).GetConfig("MedinsAdmdvs")
	s MedinsType=##class(LocalData).GetConfig("MedinsType")
	s MedinsLv=##class(LocalData).GetConfig("MedinsLv")
	s MedinsId=##class(LocalData).GetConfig("MedinsId")
	S medinsname=##class(LocalData).GetConfig("medinsname")
	
	s ArrayObj=##class(DHCDoc.Util.ListData).%New()
	s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
	d ArraySubObj.SetAt(EpisodeID,"mdtrt_id")					///就诊记录唯一ID
	d ArraySubObj.SetAt(MedinsId,"medins_id")					///定点医疗机构ID
	d ArraySubObj.SetAt(medinsname,"medins_name")				///医疗机构名称
	d ArraySubObj.SetAt(MedinsAdmdvs,"medins_admdvs")			///医疗机构行政区划编码
	d ArraySubObj.SetAt(MedinsType,"medins_type")				///医疗服务机构类型
	d ArraySubObj.SetAt(MedinsLv,"medins_lv")					///医疗机构等级
	
	d ArraySubObj.SetAt(AdmDateStr,"adm_date")					///入院日期、门诊的就诊日期，格式:yyyy-MM-dd HH:mm:ss
	d ArraySubObj.SetAt(DischgeDateStr,"dscg_date")				///出院日期、门诊的就诊日期
	d ArraySubObj.SetAt(dscgMainDiseCodg,"dscg_main_dise_codg")	///主诊断编码，例如: 163. 9
	d ArraySubObj.SetAt(dscgMainDiseName,"dscg_main_dise_name")	///主诊断名称，例如:脑梗塞
	d ArraySubObj.SetAt(Doctor,"dr_codg")						///医师标识，医生唯一ID
	d ArraySubObj.SetAt(AdmDeptCode,"adm_dept_codg")				///入院科室唯一ID
	d ArraySubObj.SetAt(AdmDeptDesc,"adm_dept_name")				///入院科室名称
	
	d ArraySubObj.SetAt(WardCode,"wardarea_codg")				///病区标识
	d ArraySubObj.SetAt(BEDRoomCode,"wardno")				///病房号
	d ArraySubObj.SetAt(PAAdmBedNO,"bedno")				///病床号
	
	d ArraySubObj.SetAt(DischgeLocCode,"dscg_dept_codg")			///出院科室唯一ID
	d ArraySubObj.SetAt(DischgeLocDesc,"dscg_dept_codg")			///出院科室名称
	d ArraySubObj.SetAt(medMdtrtType,"med_mdtrt_type")			///就诊类型，参考字典表-医疗就诊类型
	d ArraySubObj.SetAt(medType,"med_type")				///医疗类别，参考字典表-医疗类别
	
	d ArraySubObj.SetAt(matnStas,"matn_stas")				///生育状态，[0=其他, 1=非妊娠期或哺乳期, 2=近期有生育计划,3-妊娠期,4-哺乳期]//[0=其他, 1=妊娠期, 2=哺乳期]
	d ArraySubObj.SetAt(medfeeSumamt,"medfee_sumamt")			///总费用
	d ArraySubObj.SetAt(ownpayAmt,"ownpay_amt")				///自费金额
	d ArraySubObj.SetAt(seIfpayAmt,"selfpayAmt")				///自付金额
	d ArraySubObj.SetAt(acctPayamt,"acct_payamt")				///个人账户支付金额
	d ArraySubObj.SetAt(maAmt,"ma_amt")				///救助金支付金额
	d ArraySubObj.SetAt(hifpPayamt,"hifp_payamt")				///统筹金支付金额
	d ArraySubObj.SetAt(setlTotlnum,"setl_totlnum")				///结算总次数
	
	d ArraySubObj.SetAt(insutype,"insutype")				///险种，参考字典表-险种类型
	d ArraySubObj.SetAt(reimFlag,"reim_flag")				///报销标志,参考字典表-支付地点类别[PAY_LOC],
	d ArraySubObj.SetAt(outSetlFlag,"out_setl_flag")			///异地结算标志，参考字典表-支付地点类别[PAY_LOC]
	/*
	d ArraySubObj.SetAt(remoteTask,"remoteTask")				///异地任务
	d ArraySubObj.SetAt(specialCaseDesc,"specialCaseDesc")		///特殊情况说明
	d ArraySubObj.SetAt(diseaseNum,"diseaseNum")				///病种编号
	d ArraySubObj.SetAt(diseaseName,"diseaseName")				///病种名称
	d ArraySubObj.SetAt(villageDoc,"villageDoc")				///村医
	d ArraySubObj.SetAt(personType,"personType")				///村医
	d ArraySubObj.SetAt(inHisPerson,"inHisPerson")				///（截至到前一天12点没出院的就诊次数）
	d ArraySubObj.SetAt(upponInHisPerson,"upponInHisPerson")				///当日入院人数
	d ArraySubObj.SetAt(upponOutHisPerson,"upponOutHisPerson")				///（就诊当天出院的就诊次数）
	*/
	
	d ArraySubObj.SetAt(operationDtos,"fsi_operation_dtos")			///手术操作集合
	d ArraySubObj.SetAt(diagnoseDtos,"fsi_diagnose_dtos")			///诊断信息fsi_diagnose_dtos
	d ArraySubObj.SetAt(orderDtos,"fsi_order_dtos")				///处方(医嘱)信息，OrderD
	d ArrayObj.Insert(ArraySubObj)
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetAdmDTO
		w JsonStr,!
	}
	q ArrayObj
	//s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
	//s JsonStr=JsonStream.Read()
	//q JsonStr
}

/// 获取诊断信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetDiagnoseDTO(7275037,1)
ClassMethod GetDiagnoseDTO(EpisodeID As %String, Json As %String = "") As DHCDoc.Util.ListData
{
	s mradm=##Class(web.DHCPAADM).GetMRAdmID(EpisodeID)
	s ArrayObj=##class(DHCDoc.Util.ListData).%New()
	s SortNum=0
	Set rsObj=##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	If rsObj.QueryIsValid() { 
		Set Status=rsObj.Execute(mradm,"","")
		If 'Status Quit
		While rsObj.Next() {
			s DiagnosDesc=rsObj.GetData(1)
			s DiagnosValue=rsObj.GetData(2)
			s DiagnosCodeRowid=rsObj.GetData(3)
			s DiagnosMRDesc=rsObj.GetData(4)
			s DiagnosICDCode=rsObj.GetData(5)
			s DiagnosType=rsObj.GetData(6)
			s DiagnosDate=rsObj.GetData(7)
			s DiagnosOnsetDate=rsObj.GetData(8)
			s DiagStat=rsObj.GetData(9)
			s DiagnosLeavel=rsObj.GetData(10)
			s MainDiagFlag=rsObj.GetData(11)
			s MainDiagFlag=$CASE(MainDiagFlag,"Y":1,:0)
			s SortNum=SortNum+1
			//1:入院，2：出院
			s inoutDiseType=$CASE(DiagnosType,"出院诊断":2,"DIS":2,"入院诊断":1,"C008":1,:1)
			s InsertDate=$P(^MR(+DiagnosValue,"DIA",$P(DiagnosValue,"||",2)),"^",7)
			s InsertTime=$P(^MR(+DiagnosValue,"DIA",$P(DiagnosValue,"||",2)),"^",8)
			s InsertDateStr=$ZD(InsertDate,3)_" "_$ZT(InsertTime)
			s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
			d ArraySubObj.SetAt(DiagnosValue,"dise_id")					///诊断标识  诊断记录唯一标识
			d ArraySubObj.SetAt(inoutDiseType,"inout_dise_type")			///出入诊断类别,参考字典表-出入院诊断类别
			d ArraySubObj.SetAt(MainDiagFlag,"maindise_flag")		///主诊断标志[1=是, 0=否]
			d ArraySubObj.SetAt(SortNum,"dias_srt_no")				///诊断排序号,例如: 1, 2, 3...
			d ArraySubObj.SetAt(DiagnosICDCode,"dise_codg")				///诊断(疾病)编码
			d ArraySubObj.SetAt(DiagnosDesc,"dise_name")				///诊断(疾病)名称
			d ArraySubObj.SetAt(InsertDateStr,"dise_date")				///诊断日期yyyy-MM-dd HH:mm:ss
			d ArrayObj.Insert(ArraySubObj)
		}
	}
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetDiagnoseDTO
		w JsonStr,!
	}
	q ArrayObj
	
	//s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
	//s JsonStr=JsonStream.Read()
	//q JsonStr
}

/// 获取医嘱信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetOrdSDTO(7275037,1)
ClassMethod GetAllOrdSDTO(EpisodeID As %String, Json As %String = "") As DHCDoc.Util.ListData
{
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,"","")
	s orderParref=$o(^OEORD(0,"Adm",EpisodeID,0))
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospitalId=..GetAdmHospitalId(EpisodeID) ;##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=$P(^CT("HOSP",HospitalId),"^",1)
	s HospitalName=$P(^CT("HOSP",HospitalId),"^",2)
	
	s ArrayObj=##class(DHCDoc.Util.ListData).%New() ;##class(%ListOfDataTypes).%New()
	Set rsObj=##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:QryOeoriCommon")
	If rsObj.QueryIsValid() { 
		Set Status=rsObj.Execute("{""EpisodeID"":"""_EpisodeID_"""}")
		If 'Status Quit
		While rsObj.Next() {
			s seqno=rsObj.GetDataByName("seqno")
			s OrderName=rsObj.GetDataByName("OrderName")
			s OrderStatus=rsObj.GetDataByName("OrderStatus")
			s OrderStatusRowid=rsObj.GetDataByName("OrderStatusRowid")
			continue:OrderStatusRowid=""
			s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
			continue:(AdmType="I")&&("VDE"'[OrderStatus)
			continue:(AdmType'="I")&&("VE"'[OrderStatus)
			
			s OrderItemRowid=rsObj.GetDataByName("OrderItemRowid")
			s orderParref=+OrderItemRowid
			s orderId=$P(OrderItemRowid,"||",2)
			s OrderARCIMRowid=rsObj.GetDataByName("OrderARCIMRowid")
			s OrderType=rsObj.GetDataByName("OrderType")
			s OrderPrescNo=rsObj.GetDataByName("OrderPrescNo")
			if (OrderType'="R"){
				;continue
				s OrderPrescNo=OrderItemRowid
			}
			s LinkOrderItem=rsObj.GetDataByName("LinkOrderItem")
			s OrderLinkTo=rsObj.GetDataByName("OrderLinkTo")
			s GroupNo=$P(OrderItemRowid,"||",2)
			i LinkOrderItem'="" s GroupNo=$P(LinkOrderItem,"||",2)
			s OrderStartDate=rsObj.GetDataByName("OrderStartDate")
			s OrderStartTime=rsObj.GetDataByName("OrderStartTime")
			s OrderPriorRowid=rsObj.GetDataByName("OrderPriorRowid")
			s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
			if (LongPriorFlag=0)&&(..%ZDH(OrderStartDate)<+$H){
				continue
			}
			
			
			s PriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
			
			s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
			s (FormDesc)=""
			i DrgformRowid'="" {
				s PHCDRowid=$P(DrgformRowid,"||",1)
				s ChildSub=$P(DrgformRowid,"||",2)
				;剂型
				s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
				i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
			}
			s OrderPackQty=rsObj.GetDataByName("OrderPackQty")
			s OrderPackUOM=rsObj.GetDataByName("OrderPackUOM")
			s OrderPrice=rsObj.GetDataByName("OrderPrice")
			s OrderSum=rsObj.GetDataByName("OrderSum")
			s Spec=..Getspec(OrderARCIMRowid)
			
			s OrderStartDateStr=OrderStartDate_" "_OrderStartTime
			s StopDate = $p($G(^OEORD(orderParref,"I",orderId,3)),"^",34)		;XDate
			s StopTime = $p($G(^OEORD(orderParref,"I",orderId,2)),"^",15)
			s OrderStopDateStr=""
			if ("UDC"[OrderStatus)&&(StopDate'=""){
				s OrderStopDateStr=$ZD(StopDate,3)_" "_$ZT(StopTime)
			}
			s OrderOrdDepRowid=rsObj.GetDataByName("OrderOrdDepRowid")
			s OrderUserDepRowid=rsObj.GetDataByName("OrderUserDepRowid")
			s drordDeptName="",drordDeptCode=""
			if (OrderUserDepRowid'=""){
				Set drordDeptName=$P($g(^CTLOC(OrderUserDepRowid)),"^",2)
				Set drordDeptCode=$P($g(^CTLOC(OrderUserDepRowid)),"^",1)
			}
			s drordDeptStr=..GetCountryData(EpisodeID,drordDeptCode,HospitalId)
			s drordDeptCode=$p(drordDeptStr,"^",1)
			s drordDeptName=$p(drordDeptStr,"^",2)
			s OrderDoc=rsObj.GetDataByName("OrderDoc")
			s OrderDocRowid=rsObj.GetDataByName("OrderDocRowid")
			s OrderDurRowid=rsObj.GetDataByName("OrderDurRowid")
			
			s DoctorTypeCode="",ExtDoctorTypeCode=""
			if (OrderDocRowid'=""){
				s DoctorTypeRowId=$P($G(^CTPCP(OrderDocRowid,1)),"^",4)
		 		s DoctorTypeCode=$P(^CT("CPT",DoctorTypeRowId),"^",1)
			}
			s ExtData=0	;..GetExtData("CTCarPrvTp_Insu",DoctorTypeCode)
			if (+ExtData=0){
				s ExtDoctorTypeCode=$P($P(ExtData,"^",2),$c(1),1)
			}
			s ExtDoctorTypeCode=..GetDocTitle(OrderDocRowid)
			s OrderUsableDays="1"
			;实际可用天数
			if (AdmType'="I")&(OrderType="R"){
				if ##class(websys.Conversions).IsValidMethodName("web.DHCDocOrderEntry","CalcDur"){
					s OrderUsableDays=##class(web.DHCDocOrderEntry).CalcDur(OrderItemRowid)
				}elseif (OrderDurRowid'=""){
					s OrderUsableDays=##class(web.DHCDocOrderEntry).GetDurationFactor(OrderDurRowid)
				}
			}
			
			if (OrderType="R"){
				s baseuom=$$baseuom^DHCDocOrderCommonNew(OrderARCIMRowid)
				continue:(baseuom="")
				s UomDessc= $P(^CT("UOM",baseuom),"^",2)
			}else{
				s billuom=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),8),"^",14)
				s UomDessc= $P(^CT("UOM",billuom),"^",2)
			}
			s InsurInfo=..ArcimLinkInsuListN(OrderARCIMRowid)
			s InsuRet=+$p(InsurInfo,"^",1)
			if InsuRet<0{
				s InsurInfo=""	
			}
			b ;InsurInfo
			s InsurLen=$length(InsurInfo,"!")
			s j=0
			for {
				s j=j+1
				q:j>InsurLen
				s OneInsurInfo=$p(InsurInfo,"!",j)
				s hilistType=$P(OneInsurInfo,"^",1)
				s chrgType=$P(OneInsurInfo,"^",2)
				s hilistCode=$P(OneInsurInfo,"^",3)
				s hilistName=$P(OneInsurInfo,"^",4)
				b ;hilistName
				continue:(hilistName="")
				s hilistDosform=$P(OneInsurInfo,"^",5)
				s hilistLv="0"_+$P(OneInsurInfo,"^",6)
				s hilistPric=$P(OneInsurInfo,"^",7)
				s lv1HospItemPric=$P(OneInsurInfo,"^",8)
				s lv2HospItemPric=$P(OneInsurInfo,"^",9)
				s lv3HospItemPric=$P(OneInsurInfo,"^",10)
				s hilistMemo=$P(OneInsurInfo,"^",11)
				s hosplistCode=$P(OneInsurInfo,"^",12)
				s hosplistName=$P(OneInsurInfo,"^",13)
				s ownpayAmt=$P(OneInsurInfo,"^",14)
				s selfpayAmt=$P(OneInsurInfo,"^",15)
				s declaredAmt=""
				s payType=""
				s OrderSum=$FN(OrderSum,"",2)
				s OrderPrice=$FN(OrderPrice,"",2)
				s hilistPric=$FN(hilistPric,"",2)
				s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
				d ArraySubObj.SetAt(OrderSum,"sumamt")					//总费用
				d ArraySubObj.SetAt(OrderPrice,"pric")					//单价
				d ArraySubObj.SetAt(hilistType,"hilist_type")		//医保目录类别,参考字典表-医保目录类别[MED_LIST_TYPE]
				d ArraySubObj.SetAt(chrgType,"chrg_type")			//收费类别,参考字典表-医疗收费项目类别[MED_CHRGITM_TYPE]
				d ArraySubObj.SetAt(hilistCode,"hilist_code")		//医保目录代码,国家统一标准编码
				d ArraySubObj.SetAt(hilistName,"hilist_name")		//医保目录名称,国家统一标准名称
				d ArraySubObj.SetAt(hilistDosform,"hilist_dosform")	//医保目录药品剂型,国家统一标准药品剂型
				d ArraySubObj.SetAt(hilistLv,"hilist_lv")			//医保目录等级,参考字典表医-保目录等级[CHRGITM_LV]
				d ArraySubObj.SetAt(hilistPric,"hilist_pric")		//医保目录价格
				
				d ArraySubObj.SetAt(lv1HospItemPric,"lv1_hosp_item_pric")	//一级医院目录价格　
				d ArraySubObj.SetAt(lv2HospItemPric,"lv2_hosp_item_pric")	//二级医院目录价格　
				d ArraySubObj.SetAt(lv3HospItemPric,"lv3_hosp_item_pric")	//三级医院目录价格　
				d ArraySubObj.SetAt(hilistMemo,"hilist_memo")		//医保目录备注
				d ArraySubObj.SetAt(hosplistCode,"hosplist_code")	//医院目录代码
				d ArraySubObj.SetAt(hosplistName,"hosplist_name")	//医院目录名称
				d ArraySubObj.SetAt(ownpayAmt,"ownpay_amt")			//自费金额　
				d ArraySubObj.SetAt(selfpayAmt,"selfpay_amt")		//自付金额
				
				//w BillQty_","_hilistName_","_hilistPric,!
				d ArraySubObj.SetAt(+OrderPackQty,"cnt")						//数量	
				d ArraySubObj.SetAt(UomDessc,"spec_unt")				//数量单位,例如：盒
				////------------------医嘱信息
				s rxId=OrderItemRowid_"!"_hilistCode
				d ArraySubObj.SetAt(rxId,"rx_id")					//处方医嘱标识,处方医嘱记录唯一ID
				d ArraySubObj.SetAt(OrderPrescNo,"rxno")					//处方号
				d ArraySubObj.SetAt(GroupNo,"grpno")						//组编号
				d ArraySubObj.SetAt(LongPriorFlag,"long_drord_flag")			//是否为长期医嘱,[1=是,0=否]
				d ArraySubObj.SetAt($CASE(PriorCode,"OUT":1,:0),"drord_bhvr") //医嘱行为,[0=其他,1=出院带药]
				d ArraySubObj.SetAt(FormDesc,"hosplist_dosform")				//医院目录药品剂型
				//d ArraySubObj.SetAt(OrderPackQty,"cnt")						//数量	
				//d ArraySubObj.SetAt(OrderPackUOM,"spec_unt")				//数量单位,例如：盒
				
				d ArraySubObj.SetAt(Spec,"spec")					//规格,例如:0.25g×12片/盒
				d ArraySubObj.SetAt(OrderStartDateStr,"drord_begn_date")	//医嘱开始日期,格式：yyyy-MM-dd HH:mm:ss
				d ArraySubObj.SetAt(OrderStopDateStr,"drord_stop_date")	//医嘱停止日期,格式：yyyy-MM-dd HH:mm:ss
				d ArraySubObj.SetAt(drordDeptCode,"drord_dept_codg")	//下达医嘱的科室标识
				d ArraySubObj.SetAt(drordDeptName,"drord_dept_name")	//下达医嘱科室名称
				d ArraySubObj.SetAt(OrderDocRowid,"drord_dr_codg")		//开处方医嘱医生标识
				d ArraySubObj.SetAt(OrderDoc,"drord_dr_name")				//开处方医嘱医生姓名
				d ArraySubObj.SetAt(ExtDoctorTypeCode,"drord_dr_profttl")	//开处方医嘱医职称,参考字典表-医师专业技术职务[DR_PRO_TECH_DUTY]
				d ArraySubObj.SetAt("1","curr_drord_flag")		//是否当前处方医嘱,本次处方医嘱标记[1=是,0=否]
				;d ArraySubObj.SetAt(OrderUsableDays,"medDays")					//上传用药天数	
				;d ArraySubObj.SetAt(OrderUsableDays,"prdDays")					//周期天数
				d ArrayObj.Insert(ArraySubObj)
			}
		}
	}
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetOrdSDTO
		w JsonStr,!
	}
	q ArrayObj
	
	s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj,"")
	s JsonStr=""
	for {
		s str=JsonStream.Read() 
		q:str=""
		s JsonStr=JsonStr_str
	}
	q JsonStr
}

/// 获取医嘱信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetOrdSDTO(7275037,1)
ClassMethod GetOrdSDTO(EpisodeID As %String, Json As %String = "", UserID As %String = "", CTLocID As %String = "", OrdStr As %String = "") As DHCDoc.Util.ListData
{
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,"","")
	s orderParref=$o(^OEORD(0,"Adm",EpisodeID,0))
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospitalId=..GetAdmHospitalId(EpisodeID) ;##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=$P(^CT("HOSP",HospitalId),"^",1)
	s HospitalName=$P(^CT("HOSP",HospitalId),"^",2)
	s ArrayObj=##class(DHCDoc.Util.ListData).%New()
	s DocPrescNo=$I(^DocPrescNo)
	s Length=$length(OrdStr,$C(1))
	s i=0
	for {
		s i=i+1
		q:i>Length
		s OneOrder=$p(OrdStr,$C(1),i)
		s OrderARCIMRowid=$p(OneOrder,"^",1)
		s OrderType=$p(OneOrder,"^",2)
		s PriorRowid=$p(OneOrder,"^",3)
		s OrderStartDate=$p(OneOrder,"^",4)
		s OrderStartTime=$p(OneOrder,"^",5)
		s PackQty=$p(OneOrder,"^",6)
		s OrderPrice=$p(OneOrder,"^",7)
		s RecDepRowid=$p(OneOrder,"^",8)
		s AdmReason=$replace($p(OneOrder,"^",9),$c(10),"")
		s DepProcNotes=$p(OneOrder,"^",11)
		s DoseQty=$p(OneOrder,"^",12)
		s DoseUOMRowid=$p(OneOrder,"^",13)
		s DoseQtySum=$p(OneOrder,"^",14)
		s FreqRowid=$p(OneOrder,"^",15)
		s DurRowid=$p(OneOrder,"^",16)
		s InstrRowid=$p(OneOrder,"^",17)
		s PHPrescType=$p(OneOrder,"^",18)
		s MasterSeqNo=$p(OneOrder,"^",19)
		s OrderSeqNo=$p(OneOrder,"^",20)
		s SkinTest=$p(OneOrder,"^",21)
		s PhSpecInstr=$p(OneOrder,"^",22)
		s OrderCoverMainIns=$p(OneOrder,"^",23)
		s ActionRowid=$p(OneOrder,"^",24)
		s ARCOSRowid=$p(OneOrder,"^",25)
		s EndDate=$p(OneOrder,"^",26)
		s EndTime=$p(OneOrder,"^",27)
		s ExecuteDateStr=$p(OneOrder,"^",29)
		s NotifyClinician=$p(OneOrder,"^",30)
		s DIACatRowId=$p(OneOrder,"^",31)
		s InsurCatRowId=$p(OneOrder,"^",32)
		s FirstDayTimes=$p(OneOrder,"^",33)
		s InsurSignSymptomCode=$p(OneOrder,"^",34)
		s OrderStageCode=$p(OneOrder,"^",35)
		s SpeedFlowRate=$p(OneOrder,"^",36)
		s AnaesthesiaID=$p(OneOrder,"^",37)
		s LabEpisodeNo=$p(OneOrder,"^",38)
		s VerifiedOrderMasterRowid=$p(OneOrder,"^",39)
		s OrderNutritionDrugFlag=$p(OneOrder,"^",40)
		s MaterialBarCode=$p(OneOrder,"^",41)
		s CPWStepItemRowId=$p(OneOrder,"^",43)
		s InsurApproveType=$p(OneOrder,"^",44)
		s OrderFlowRateUnit=$p(OneOrder,"^",45)
		s OrderDate=$p(OneOrder,"^",46)
		s OrderTime=$p(OneOrder,"^",47)
		s OrderNeedPIVAFlag=$p(OneOrder,"^",48)
		s OrderAntibApplyRowid=$p(OneOrder,"^",49)
		s AntUseReason=$p(OneOrder,"^",50)
		s UseReasonId=$p(OneOrder,"^",51)
		s OrderLocalInfusionQty=$p(OneOrder,"^",52)
		s OrderBySelfOMFlag=$p(OneOrder,"^",53)
		s ExceedReasonID=$p(OneOrder,"^",54) 
		s OrderPackUOMRowid=$p(OneOrder,"^",55)
		s PilotProRowId=$p(OneOrder,"^",56)
		s OrderOutsourcingFlag=$p(OneOrder,"^",57)
		s OEORIBindSource=$p(OneOrder,"^",58) //医嘱绑定来源
		s ApplyArcId=$p(OneOrder,"^",59)
		s OrderDHCAADr=$p(OneOrder,"^",60)
		s OperationCode=$p(OneOrder,"^",61)
		s ZSKMonitorLogId=$p(OneOrder,"^",62)
		s CelerType=$p(OneOrder,"^",65)	//快速医嘱套标识
		
		s seqno=OrderSeqNo
		s OrderName=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",2)
		s OrderStatusRowid="1"
		s OrderStatus="V"
		continue:(AdmType="I")&&("VDE"'[OrderStatus)
		continue:(AdmType'="I")&&("VE"'[OrderStatus)
		s OrderItemRowid=""
		s orderParref=+OrderItemRowid
		s orderId=$P(OrderItemRowid,"||",2)
		s OrderARCIMRowid=OrderARCIMRowid
		s OrderPrescNo=DocPrescNo
		s LinkOrderItem=OEORIBindSource
		s OrderLinkTo=""
		s GroupNo=MasterSeqNo
		i LinkOrderItem'="" s GroupNo=$P(LinkOrderItem,"||",2)
		s OrderPriorRowid=PriorRowid
		s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
		if (LongPriorFlag=0)&&(..%ZDH(OrderStartDate)<+$H){
			continue
		}
		s PriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
		s (FormDesc)=""
		i DrgformRowid'="" {
			s PHCDRowid=$P(DrgformRowid,"||",1)
			s ChildSub=$P(DrgformRowid,"||",2)
			;剂型
			s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
			i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
		}
		s OrderPackQty=PackQty
		s OrderPackUOM=OrderPackUOMRowid
		s OrderPrice=OrderPrice
		s OrderSum=OrderPrice*PackQty
		s Spec=..Getspec(OrderARCIMRowid)
		s OrderStartDateStr=OrderStartDate_" "_OrderStartTime
		s StopDate = ""		;XDate
		s StopTime = ""
		s OrderStopDateStr=""
		s OrderOrdDepRowid=CTLocID
		s OrderUserDepRowid=$P(^PAADM(EpisodeID),"^",4)
		s drordDeptName="",drordDeptCode=""
		if (OrderUserDepRowid'=""){
			Set drordDeptName=$P($g(^CTLOC(OrderUserDepRowid)),"^",2)
			Set drordDeptCode=$P($g(^CTLOC(OrderUserDepRowid)),"^",1)
		}
		s drordDeptStr=..GetCountryData(EpisodeID,drordDeptCode,HospitalId)
		s drordDeptCode=$p(drordDeptStr,"^",1)
		s drordDeptName=$p(drordDeptStr,"^",2)
		s OrderDoc=$p(^SSU("SSUSR",UserID),"^",14)
		s OrderDocRowid=OrderDoc
		s OrderDurRowid=DurRowid
		s DoctorTypeCode="",ExtDoctorTypeCode=""
		if (OrderDocRowid'=""){
			s DoctorTypeRowId=$P($G(^CTPCP(OrderDocRowid,1)),"^",4)
	 		s DoctorTypeCode=$P(^CT("CPT",DoctorTypeRowId),"^",1)
		}
		s ExtData=0	;..GetExtData("CTCarPrvTp_Insu",DoctorTypeCode)
		if (+ExtData=0){
			s ExtDoctorTypeCode=$P($P(ExtData,"^",2),$c(1),1)
		}
		s ExtDoctorTypeCode=..GetDocTitle(OrderDocRowid)
		s OrderUsableDays="1"
		;实际可用天数
		if (AdmType'="I")&(OrderType="R"){
			if ##class(websys.Conversions).IsValidMethodName("web.DHCDocOrderEntry","CalcDur"){
			 s OrderUsableDays=##class(web.DHCDocOrderEntry).CalcDur(OrderItemRowid)
			}elseif (OrderDurRowid'=""){
				s OrderUsableDays=##class(web.DHCDocOrderEntry).GetDurationFactor(OrderDurRowid)
			}
		}	
		if (OrderType="R"){
			s baseuom=$$baseuom^DHCDocOrderCommonNew(OrderARCIMRowid)
			continue:(baseuom="")
			s UomDessc= $P(^CT("UOM",baseuom),"^",2)
		}else{
			s billuom=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),8),"^",14)
			s UomDessc= $P(^CT("UOM",billuom),"^",2)
		}
		s InsurInfo=..ArcimLinkInsuListN(OrderARCIMRowid)
		b ;InsurInfo
		s InsurLen=$length(InsurInfo,"!")
		s j=0
		for {
			s j=j+1
			q:j>InsurLen
			s OneInsurInfo=$p(InsurInfo,"!",j)
			s hilistType=$P(OneInsurInfo,"^",1)
			s chrgType=$P(OneInsurInfo,"^",2)
			s hilistCode=$P(OneInsurInfo,"^",3)
			s hilistName=$P(OneInsurInfo,"^",4)
			b ;hilistName
			continue:(hilistName="")
			s hilistDosform=$P(OneInsurInfo,"^",5)
			s hilistLv="0"_+$P(OneInsurInfo,"^",6)
			s hilistPric=$P(OneInsurInfo,"^",7)
			s lv1HospItemPric=$P(OneInsurInfo,"^",8)
			s lv2HospItemPric=$P(OneInsurInfo,"^",9)
			s lv3HospItemPric=$P(OneInsurInfo,"^",10)
			s hilistMemo=$P(OneInsurInfo,"^",11)
			s hosplistCode=$P(OneInsurInfo,"^",12)
			s hosplistName=$P(OneInsurInfo,"^",13)
			s ownpayAmt=$P(OneInsurInfo,"^",14)
			s selfpayAmt=$P(OneInsurInfo,"^",15)
			s declaredAmt=""
			s payType=""
			s OrderSum=$FN(OrderSum,"",2)
			s OrderPrice=$FN(OrderPrice,"",2)
			s hilistPric=$FN(hilistPric,"",2)
			s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
			d ArraySubObj.SetAt(OrderSum,"sumamt")					//总费用
			d ArraySubObj.SetAt(OrderPrice,"pric")					//单价
			d ArraySubObj.SetAt(hilistType,"hilist_type")		//医保目录类别,参考字典表-医保目录类别[MED_LIST_TYPE]
			d ArraySubObj.SetAt(chrgType,"chrg_type")			//收费类别,参考字典表-医疗收费项目类别[MED_CHRGITM_TYPE]
			d ArraySubObj.SetAt(hilistCode,"hilist_code")		//医保目录代码,国家统一标准编码
			d ArraySubObj.SetAt(hilistName,"hilist_name")		//医保目录名称,国家统一标准名称
			d ArraySubObj.SetAt(hilistDosform,"hilist_dosform")	//医保目录药品剂型,国家统一标准药品剂型
			d ArraySubObj.SetAt(hilistLv,"hilist_lv")			//医保目录等级,参考字典表医-保目录等级[CHRGITM_LV]
			d ArraySubObj.SetAt(hilistPric,"hilist_pric")		//医保目录价格
			
			d ArraySubObj.SetAt(lv1HospItemPric,"lv1_hosp_item_pric")	//一级医院目录价格　
			d ArraySubObj.SetAt(lv2HospItemPric,"lv2_hosp_item_pric")	//二级医院目录价格　
			d ArraySubObj.SetAt(lv3HospItemPric,"lv3_hosp_item_pric")	//三级医院目录价格　
			d ArraySubObj.SetAt(hilistMemo,"hilist_memo")		//医保目录备注
			d ArraySubObj.SetAt(hosplistCode,"hosplist_code")	//医院目录代码
			d ArraySubObj.SetAt(hosplistName,"hosplist_name")	//医院目录名称
			d ArraySubObj.SetAt(ownpayAmt,"ownpay_amt")			//自费金额　
			d ArraySubObj.SetAt(selfpayAmt,"selfpay_amt")		//自付金额
			
			//w BillQty_","_hilistName_","_hilistPric,!
			d ArraySubObj.SetAt(+PackQty,"cnt")						//数量	
			d ArraySubObj.SetAt(UomDessc,"spec_unt")				//数量单位,例如：盒
			////------------------医嘱信息
			s rxId=OrderItemRowid_"!"_hilistCode
			d ArraySubObj.SetAt(rxId,"rx_id")					//处方医嘱标识,处方医嘱记录唯一ID
			d ArraySubObj.SetAt(OrderPrescNo,"rxno")					//处方号
			d ArraySubObj.SetAt(GroupNo,"grpno")						//组编号
			d ArraySubObj.SetAt(LongPriorFlag,"long_drord_flag")			//是否为长期医嘱,[1=是,0=否]
			d ArraySubObj.SetAt($CASE(PriorCode,"OUT":1,:0),"drord_bhvr") //医嘱行为,[0=其他,1=出院带药]
			d ArraySubObj.SetAt(FormDesc,"hosplist_dosform")				//医院目录药品剂型
			//d ArraySubObj.SetAt(OrderPackQty,"cnt")						//数量	
			//d ArraySubObj.SetAt(OrderPackUOM,"spec_unt")				//数量单位,例如：盒
			
			d ArraySubObj.SetAt(Spec,"spec")					//规格,例如:0.25g×12片/盒
			d ArraySubObj.SetAt(OrderStartDateStr,"drord_begn_date")	//医嘱开始日期,格式：yyyy-MM-dd HH:mm:ss
			d ArraySubObj.SetAt(OrderStopDateStr,"drord_stop_date")	//医嘱停止日期,格式：yyyy-MM-dd HH:mm:ss
			d ArraySubObj.SetAt(drordDeptCode,"drord_dept_codg")	//下达医嘱的科室标识
			d ArraySubObj.SetAt(drordDeptName,"drord_dept_name")	//下达医嘱科室名称
			d ArraySubObj.SetAt(OrderDocRowid,"drord_dr_codg")		//开处方医嘱医生标识
			d ArraySubObj.SetAt(OrderDoc,"drord_dr_name")				//开处方医嘱医生姓名
			d ArraySubObj.SetAt(ExtDoctorTypeCode,"drord_dr_profttl")	//开处方医嘱医职称,参考字典表-医师专业技术职务[DR_PRO_TECH_DUTY]
			d ArraySubObj.SetAt("1","curr_drord_flag")		//是否当前处方医嘱,本次处方医嘱标记[1=是,0=否]
			;d ArraySubObj.SetAt(OrderUsableDays,"medDays")					//上传用药天数	
			;d ArraySubObj.SetAt(OrderUsableDays,"prdDays")					//周期天数
			d ArrayObj.Insert(ArraySubObj)
		}
	}
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetOrdSDTO
		w JsonStr,!
	}
	q ArrayObj
	s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj,"")
	s JsonStr=""
	for {
		s str=JsonStream.Read() 
		q:str=""
		s JsonStr=JsonStr_str
	}
	q JsonStr
}

ClassMethod GetOrdSDTOBak(EpisodeID As %String, Json As %String = "") As %ListOfDataTypes
{
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,"","")
	s orderParref=$o(^OEORD(0,"Adm",EpisodeID,0))
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospitalId=..GetAdmHospitalId(EpisodeID) ;##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=$P(^CT("HOSP",HospitalId),"^",1)
	s HospitalName=$P(^CT("HOSP",HospitalId),"^",2)
	
	s ArrayObj=##class(%ListOfDataTypes).%New()
	Set rsObj=##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:QryOeoriCommon")
	If rsObj.QueryIsValid() { 
		Set Status=rsObj.Execute("{""EpisodeID"":"""_EpisodeID_"""}")
		If 'Status Quit
		While rsObj.Next() {
			s seqno=rsObj.GetDataByName("seqno")
			s OrderName=rsObj.GetDataByName("OrderName")
			s OrderStatus=rsObj.GetDataByName("OrderStatus")
			s OrderStatusRowid=rsObj.GetDataByName("OrderStatusRowid")
			continue:OrderStatusRowid=""
			s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
			continue:(AdmType="I")&&("VDE"'[OrderStatus)
			continue:(AdmType'="I")&&("VE"'[OrderStatus)
			
			s OrderItemRowid=rsObj.GetDataByName("OrderItemRowid")
			s orderParref=+OrderItemRowid
			s orderId=$P(OrderItemRowid,"||",2)
			s OrderARCIMRowid=rsObj.GetDataByName("OrderARCIMRowid")
			s OrderType=rsObj.GetDataByName("OrderType")
			s OrderPrescNo=rsObj.GetDataByName("OrderPrescNo")
			if (OrderType'="R"){
				;continue
				s OrderPrescNo=OrderItemRowid
			}
			s LinkOrderItem=rsObj.GetDataByName("LinkOrderItem")
			s OrderLinkTo=rsObj.GetDataByName("OrderLinkTo")
			s GroupNo=$P(OrderItemRowid,"||",2)
			i LinkOrderItem'="" s GroupNo=$P(LinkOrderItem,"||",2)
			s OrderStartDate=rsObj.GetDataByName("OrderStartDate")
			s OrderStartTime=rsObj.GetDataByName("OrderStartTime")
			s OrderPriorRowid=rsObj.GetDataByName("OrderPriorRowid")
			s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
			if (LongPriorFlag=0)&&($ZDH(OrderStartDate,3)<+$H){
				continue
			}
			
			
			s PriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
			
			s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
			s (FormDesc)=""
			i DrgformRowid'="" {
				s PHCDRowid=$P(DrgformRowid,"||",1)
				s ChildSub=$P(DrgformRowid,"||",2)
				;剂型
				s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
				i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
			}
			s OrderPackQty=rsObj.GetDataByName("OrderPackQty")
			s OrderPackUOM=rsObj.GetDataByName("OrderPackUOM")
			s OrderPrice=rsObj.GetDataByName("OrderPrice")
			s OrderSum=rsObj.GetDataByName("OrderSum")
			s Spec=..Getspec(OrderARCIMRowid)
			
			s OrderStartDateStr=OrderStartDate_" "_OrderStartTime
			s StopDate = $p($G(^OEORD(orderParref,"I",orderId,3)),"^",34)		;XDate
			s StopTime = $p($G(^OEORD(orderParref,"I",orderId,2)),"^",15)
			s OrderStopDateStr=""
			if ("UDC"[OrderStatus)&&(StopDate'=""){
				s OrderStopDateStr=$ZD(StopDate,3)_" "_$ZT(StopTime)
			}
			s OrderOrdDepRowid=rsObj.GetDataByName("OrderOrdDepRowid")
			s OrderUserDepRowid=rsObj.GetDataByName("OrderUserDepRowid")
			s drordDeptName="",drordDeptCode=""
			if (OrderUserDepRowid'=""){
				Set drordDeptName=$P($g(^CTLOC(OrderUserDepRowid)),"^",2)
				Set drordDeptCode=$P($g(^CTLOC(OrderUserDepRowid)),"^",1)
			}
			s drordDeptStr=..GetCountryData(EpisodeID,drordDeptCode,HospitalId)
			s drordDeptCode=$p(drordDeptStr,"^",1)
			s drordDeptName=$p(drordDeptStr,"^",2)
			s OrderDoc=rsObj.GetDataByName("OrderDoc")
			s OrderDocRowid=rsObj.GetDataByName("OrderDocRowid")
			s OrderDurRowid=rsObj.GetDataByName("OrderDurRowid")
			
			s DoctorTypeCode="",ExtDoctorTypeCode=""
			if (OrderDocRowid'=""){
				s DoctorTypeRowId=$P($G(^CTPCP(OrderDocRowid,1)),"^",4)
		 		s DoctorTypeCode=$P(^CT("CPT",DoctorTypeRowId),"^",1)
			}
			s ExtData=0	;..GetExtData("CTCarPrvTp_Insu",DoctorTypeCode)
			if (+ExtData=0){
				s ExtDoctorTypeCode=$P($P(ExtData,"^",2),$c(1),1)
			}
			s ExtDoctorTypeCode=..GetDocTitle(OrderDocRowid)
			s OrderUsableDays="1"
			;实际可用天数
			if (AdmType'="I")&(OrderType="R"){
				if ##class(websys.Conversions).IsValidMethodName("web.DHCDocOrderEntry","CalcDur"){
				 s OrderUsableDays=##class(web.DHCDocOrderEntry).CalcDur(OrderItemRowid)
				}elseif (OrderDurRowid'=""){
					s OrderUsableDays=##class(web.DHCDocOrderEntry).GetDurationFactor(OrderDurRowid)
				}
			}
			
			if (OrderType="R"){
				s baseuom=$$baseuom^DHCDocOrderCommonNew(OrderARCIMRowid)
				continue:(baseuom="")
				s UomDessc= $P(^CT("UOM",baseuom),"^",2)
			}else{
				s billuom=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),8),"^",14)
				s UomDessc= $P(^CT("UOM",billuom),"^",2)
			}
			;s OrderFreqRowid=rsObj.GetDataByName("OrderFreqRowid")
			;s ExtFreqRowid=..GetExtOrderFreqRowid(OrderFreqRowid)
			//TotalAmount,UnitPrice,HiListType,ChrgType,HiListCode,
			//HiListName,HiListDosForm,HiListLv,HiListPric,Lv1HospItemPric,
			//Lv2HospItemPric,Lv3HospItemPric,HiListMemo,HospListCode,HospListName,
			//OwnPayment,SelfPayment,DeclaredAmt,PayType
			;w "OrderItemRowid:"_OrderItemRowid,!
			Set InsursObj=##Class(%ResultSet).%New("web.DHCINSUPort:GetTarItemInfoByOrdId")
			If InsursObj.QueryIsValid() { 
				Set Status=InsursObj.Execute(OrderItemRowid)
				If 'Status Quit
				While InsursObj.Next() {
					
					s OrderSum=InsursObj.GetDataByName("TotalAmount")
					s OrderPrice=InsursObj.GetDataByName("UnitPrice")
					s BillQty=InsursObj.GetDataByName("BillQty")
					
					
					s hilistType=InsursObj.GetDataByName("HiListType")
					s chrgType=InsursObj.GetDataByName("ChrgType")
					s hilistCode=InsursObj.GetDataByName("HiListCode")
					s hilistName=InsursObj.GetDataByName("HiListName")
					;w "HiListName:"_hilistName,!
					continue:(hilistName="")
					s hilistDosform=InsursObj.GetDataByName("HiListDosForm")
					s hilistLv=InsursObj.GetDataByName("HiListLv")
					s hilistPric=InsursObj.GetDataByName("HiListPric")
					s lv1HospItemPric=InsursObj.GetDataByName("Lv1HospItemPric")
					s lv2HospItemPric=InsursObj.GetDataByName("Lv2HospItemPric")
					s lv3HospItemPric=InsursObj.GetDataByName("Lv3HospItemPric")
					s hilistMemo=InsursObj.GetDataByName("HiListMemo")
					s hosplistCode=InsursObj.GetDataByName("HospListCode")
					s hosplistName=InsursObj.GetDataByName("HospListName")
					s ownpayAmt=InsursObj.GetDataByName("OwnPayment")
					s selfpayAmt=InsursObj.GetDataByName("SelfPayment")
					s declaredAmt=InsursObj.GetDataByName("DeclaredAmt")
					s payType=InsursObj.GetDataByName("PayType")
					s OrderSum=$FN(OrderSum,"",2)
					s OrderPrice=$FN(OrderPrice,"",2)
					s hilistPric=$FN(hilistPric,"",2)
					s ArraySubObj=##class(%ArrayOfDataTypes).%New()
					d ArraySubObj.SetAt(OrderSum,"sumamt")					//总费用
					d ArraySubObj.SetAt(OrderPrice,"pric")					//单价
					
					d ArraySubObj.SetAt(hilistType,"hilist_type")		//医保目录类别,参考字典表-医保目录类别[MED_LIST_TYPE]
					d ArraySubObj.SetAt(chrgType,"chrg_type")			//收费类别,参考字典表-医疗收费项目类别[MED_CHRGITM_TYPE]
					d ArraySubObj.SetAt(hilistCode,"hilist_code")		//医保目录代码,国家统一标准编码
					d ArraySubObj.SetAt(hilistName,"hilist_name")		//医保目录名称,国家统一标准名称
					d ArraySubObj.SetAt(hilistDosform,"hilist_dosform")	//医保目录药品剂型,国家统一标准药品剂型
					d ArraySubObj.SetAt(hilistLv,"hilist_lv")			//医保目录等级,参考字典表医-保目录等级[CHRGITM_LV]
					d ArraySubObj.SetAt(hilistPric,"hilist_pric")		//医保目录价格
					
					d ArraySubObj.SetAt(lv1HospItemPric,"lv1_hosp_item_pric")	//一级医院目录价格　
					d ArraySubObj.SetAt(lv2HospItemPric,"lv2_hosp_item_pric")	//二级医院目录价格　
					d ArraySubObj.SetAt(lv3HospItemPric,"lv3_hosp_item_pric")	//三级医院目录价格　
					d ArraySubObj.SetAt(hilistMemo,"hilist_memo")		//医保目录备注
					d ArraySubObj.SetAt(hosplistCode,"hosplist_code")	//医院目录代码
					d ArraySubObj.SetAt(hosplistName,"hosplist_name")	//医院目录名称
					d ArraySubObj.SetAt(ownpayAmt,"ownpay_amt")			//自费金额　
					d ArraySubObj.SetAt(selfpayAmt,"selfpay_amt")		//自付金额　
					;d ArraySubObj.SetAt(declaredAmt,"declaredAmt")			//申报金额
					;d ArraySubObj.SetAt(payType,"payType")					//支付类别
					//w BillQty_","_hilistName_","_hilistPric,!
					d ArraySubObj.SetAt(+BillQty,"cnt")						//数量	
					d ArraySubObj.SetAt(UomDessc,"spec_unt")				//数量单位,例如：盒
					////------------------医嘱信息
					s rxId=OrderItemRowid_"!"_hilistCode
					d ArraySubObj.SetAt(rxId,"rx_id")					//处方医嘱标识,处方医嘱记录唯一ID
					d ArraySubObj.SetAt(OrderPrescNo,"rxno")					//处方号
					d ArraySubObj.SetAt(GroupNo,"grpno")						//组编号
					d ArraySubObj.SetAt(LongPriorFlag,"long_drord_flag")			//是否为长期医嘱,[1=是,0=否]
					d ArraySubObj.SetAt($CASE(PriorCode,"OUT":1,:0),"drord_bhvr") //医嘱行为,[0=其他,1=出院带药]
					d ArraySubObj.SetAt(FormDesc,"hosplist_dosform")				//医院目录药品剂型
					//d ArraySubObj.SetAt(OrderPackQty,"cnt")						//数量	
					//d ArraySubObj.SetAt(OrderPackUOM,"spec_unt")				//数量单位,例如：盒
					
					d ArraySubObj.SetAt(Spec,"spec")					//规格,例如:0.25g×12片/盒
					d ArraySubObj.SetAt(OrderStartDateStr,"drord_begn_date")	//医嘱开始日期,格式：yyyy-MM-dd HH:mm:ss
					d ArraySubObj.SetAt(OrderStopDateStr,"drord_stop_date")	//医嘱停止日期,格式：yyyy-MM-dd HH:mm:ss
					d ArraySubObj.SetAt(drordDeptCode,"drord_dept_codg")	//下达医嘱的科室标识
					d ArraySubObj.SetAt(drordDeptName,"drord_dept_name")	//下达医嘱科室名称
					d ArraySubObj.SetAt(OrderDocRowid,"drord_dr_codg")		//开处方医嘱医生标识
					d ArraySubObj.SetAt(OrderDoc,"drord_dr_name")				//开处方医嘱医生姓名
					d ArraySubObj.SetAt(ExtDoctorTypeCode,"drord_dr_profttl")	//开处方医嘱医职称,参考字典表-医师专业技术职务[DR_PRO_TECH_DUTY]
					d ArraySubObj.SetAt("1","curr_drord_flag")		//是否当前处方医嘱,本次处方医嘱标记[1=是,0=否]
					;d ArraySubObj.SetAt(OrderUsableDays,"medDays")					//上传用药天数	
					;d ArraySubObj.SetAt(OrderUsableDays,"prdDays")					//周期天数
					
					
					;d ArraySubObj.SetAt(ExtFreqRowid,"usedFrqu")
					//d ArraySubObj.SetAt("","medcWayDscr")					//用药途径描述
					//d ArraySubObj.SetAt(1,"minUnit")					//参考字典表:-用量单位, 填写字典值编码
					
					
					d ArrayObj.Insert(ArraySubObj)
				}
			}
			
			
		}
	}
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetOrdSDTO
		w JsonStr,!
	}
	q ArrayObj
	
	s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj,"")
	s JsonStr=""
	for {
		s str=JsonStream.Read() 
		q:str=""
		s JsonStr=JsonStr_str
	}
	q JsonStr
}

/// 获取手术信息串
/// debugger:	w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetANAdaptorDTO(7275037,1)
ClassMethod GetANAdaptorDTO(EpisodeID As %String, Json As %String = "") As DHCDoc.Util.ListData
{
	s orderParref=$o(^OEORD(0,"Adm",EpisodeID,0))
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospitalId=..GetAdmHospitalId(EpisodeID) ;##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=$P(^CT("HOSP",HospitalId),"^",1)
	s HospitalName=$P(^CT("HOSP",HospitalId),"^",2)
	
	s ArrayObj=##class(DHCDoc.Util.ListData).%New()
	Set rsObj=##Class(%ResultSet).%New("web.DHCANAdaptor:FindOperationDTO")
	If rsObj.QueryIsValid() { 
		Set Status=rsObj.Execute(EpisodeID)
		If 'Status Quit
		While rsObj.Next() {
			s setlListOprnId=rsObj.GetDataByName("setlListOprnId")
			s oprnCode=rsObj.GetDataByName("oprnCode")
			s oprnName=rsObj.GetDataByName("oprnName")
			s mainOprnFlag=rsObj.GetDataByName("mainOprnFlag")
			
			s oprnDate=rsObj.GetDataByName("oprnDate")
			s anstWay=rsObj.GetDataByName("anstWay")
			s operDrName=rsObj.GetDataByName("operDrName")
			s operDrCode=rsObj.GetDataByName("operDrCode")
			s anstDrName=rsObj.GetDataByName("anstDrName")
			s anstDrCode=rsObj.GetDataByName("anstDrCode")
			
			s ArraySubObj=##class(DHCDoc.Util.ArrayData).%New()
			d ArraySubObj.SetAt(setlListOprnId,"setl_list_oprn_id")	//手术操作 ID
			d ArraySubObj.SetAt(oprnCode,"oprn_code")				//手术操作代码
			d ArraySubObj.SetAt(oprnName,"oprn_name")				//手术操作名称
			d ArraySubObj.SetAt(mainOprnFlag,"main_oprn_flag")		//主手术操作标
			d ArraySubObj.SetAt(oprnDate,"oprn_date")				//手术操作日期 yyyy-MM-dd HH:mm:ss
			d ArraySubObj.SetAt(anstWay,"anst_way")					//麻醉方式
			d ArraySubObj.SetAt(operDrName,"oper_dr_name")			//术者医师姓名
			d ArraySubObj.SetAt(operDrCode,"oper_dr_code")			//术者医师代码
			d ArraySubObj.SetAt(anstDrName,"anst_dr_name")			//麻醉医师姓名
			d ArraySubObj.SetAt(anstDrCode,"anst_dr_code")			//麻醉医师代码

			d ArrayObj.Insert(ArraySubObj)
			
			
		}
	}
	i Json=1{
		s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj)
		s JsonStr=JsonStream.Read()
		b ;JsonStr GetANAdaptorDTO
		w JsonStr,!
	}
	q ArrayObj
	/*
	s JsonStream=##Class(DHCDoc.Util.FromXML).Arr2Json(ArrayObj,"")
	s JsonStr=""
	for {
		s str=JsonStream.Read() 
		q:str=""
		s JsonStr=JsonStr_str
	}
	q JsonStr
	*/
}

/// / 医疗类别，参考字典表-医疗类别
ClassMethod GetMedType(EpisodeID As %String) As %String
{
	///11:普通门诊,12:门诊挂号,13:急诊,14:门诊慢特病,21:普通住院,22:外伤住院,
	//23:转外诊治住院,24:急诊转住院,41:定点药店购药,51:生育门诊,52:生育住院,53:计划生育手术费
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	if (AdmType="O"){
		s MedType=11
	}elseif (AdmType="E"){
		s MedType=13
	}elseif (AdmType="I"){
		s MedType=21
		s IPBookDr=$O(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,0))
		if (IPBookDr'=""){
			s EpisodeIDFrom=$P(^DHCDocIPBK(IPBookDr),"^",2)
			if (EpisodeIDFrom'=""){
				s AdmTypeFrom=$p(^PAADM(EpisodeIDFrom),"^",2)
				if (AdmTypeFrom="E"){
					s MedType=24
				}
			}
		}
	}else{
		s MedType=11
	}
	q MedType
}

/// w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetTimeSignature()
/// 13位时间戳
ClassMethod GetTimeSignature(ByRef HeadArr) As %String
{
	
	s curDateTime=(+$h*86400)+$p($h,",",2)
	s comDateTime=($zdh("1970-01-01",3)*86400)+$zth("08:00:00")
	s TimeSignature=curDateTime-comDateTime
	s STRING="0000000000000000"
	s LENGTH=13
	
	q $E(TimeSignature,1,LENGTH-$L(STRING))_$E(STRING,$L(STRING)-LENGTH+1,$L(STRING))
	q $$LPAD2^DHCaOET1(curDateTime-comDateTime,"0",13)
	
	q curDateTime-comDateTime
}

/// desc 获取库存项 规格
/// input 医嘱项ID
ClassMethod Getspec(ArcItemID) As %String
{
	Q:ArcItemID="" ""
	s ArcimS=$p(ArcItemID,"||",1)
	s Inci=$o(^INCI(0,"ARCIM_DR",ArcimS,"")) 
	q:(Inci="") ""
	s info=$O(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:info="" ""
	s spec=$p($g(^DHCITMINFO(info)),"^",27)
	Q spec
}

/// Creator:      fuxiaonan
/// CreatDate:    2022.4.19
/// Description:  获取参保地医保区划   就医地医保区划
/// W ##class(DHCDoc.Interface.YiBaoJianGuan.Business).Getpoolarea(921)
ClassMethod GetINADMInfo(EpisodeID) As %String
{
	Q:EpisodeID="" ""
	s (AdmYBQH,InYBQH)=""
	///INADM_States 就医地医保区划,INADM_Center 参保地医保区划
	&SQL(SELECT INADM_States,INADM_Center into :AdmYBQH, :InYBQH FROM SQLUser.INSU_AdmInfo WHERE INADM_AdmDr=:EpisodeID )
	q InYBQH_"^"_AdmYBQH
}

/// Creator:      fuxiaonan
/// CreatDate:    2022.4.19
/// Description:  获取就诊人的就诊医院信息
/// W ##class(DHCDoc.Interface.YiBaoJianGuan.Business).GetAdmHospitalId(921)
ClassMethod GetAdmHospitalId(EpisodeID) As %String
{
	Q:EpisodeID="" ""
	s AdmDepDR=$P(^PAADM(EpisodeID),"^",4)
	Q:AdmDepDR="" ""
	s AdmHospId=$p($g(^CTLOC(AdmDepDR)),"^",22)
	Q AdmHospId
}

/// Creator:      fuxiaonan
/// CreatDate:    2022.4.19
/// Description:  获取跟医院科室code、科室名称对照过的国家科室code、国家科室名称
/// W ##class(DHCDoc.Interface.YiBaoJianGuan.Business).GetCountryData(EpisodeID,QueryCode,HospData,HospDr)
ClassMethod GetCountryData(EpisodeID As %String, HospData As %String, HospDr As %String) As %String
{
	Q:EpisodeID="" ""
	Q:HospData="" ""
	s AdmReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HospDr)
	s insudepcode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_InsuType,HospData,6,HospDr)
	s insudepdesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon"_InsuType,HospData,7,HospDr) //医保科室名称
	q insudepcode_"^"_insudepdesc
}

/// w ##Class(DHCDoc.Interface.YiBaoJianGuan.Business).GetOrderInfo(1)
ClassMethod GetOrderInfo(OrderItemRowid As %String) As %String
{
	q:OrderItemRowid="" ""
	s ArcimID=$P($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",2)
	q:ArcimID="" ""
	s OrderDesc=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",2)	;医嘱名称
	q OrderDesc
}

/// w ##class(web.DHCINSUPort).ArcimLinkInsuListN("1559||1")
/// Desc:本方法为从重庆拷贝，本组医生站不负责维护，优先获取医保组接口方法
ClassMethod ArcimLinkInsuListN(ArcimRowid) As %String
{
	if ##class(websys.Conversions).IsValidMethodName("web.DHCINSUPort","ArcimLinkInsuListN"){
		Q ##class(web.DHCINSUPort).ArcimLinkInsuListN(ArcimRowid)
	}
	s InsuType="",OutStr="",OutStr1="",TariDrStr=""
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	s InsuType="00A"
	q:InsuType="" "-1^费别和医保目录没有对照"
	s TariDr=""
	;----------Zhan 20181114--------->
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	if (DrugFlag="1"){
	    s TariDrStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	    q:$l(TariDrStr,"^")>1 "-3^医嘱项对应了多个收费项" 
	    s TariDrStr="^"_TariDrStr
	}else{
		s TariDr=""
	    q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	    f  s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr)) q:TariDr=""  d
	    .s TariDrStr=TariDrStr_"^"_TariDr
	    ;q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	}

	q:TariDrStr="" "-2^没有对应的收费项"
    f Num=2:1:$l(TariDrStr,"^")  d
    .s (hilistType,chrgType,hilistCode,hilistName,hilistDosform,hilistLv,hilistPric,lv1HospItemPric,lv2HospItemPric,lv3HospItemPric,hilistMemo,hosplistCode,hosplistName,ownpayAmt,selfpayAmt)=""
    .s TariDr=$p(TariDrStr,"^",Num)
	.s TarString=$$GetTarDetail^DHCINSUTarContrast(TariDr)
	.s hosplistCode=$p(TarString,"^",2)
	.s hosplistName=$p(TarString,"^",3)
	.;s Price=$fn($p(TarString,"^",7),"",4)
	.;s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,"","",2)
	.s hilistCode=$P(TarItemInsuInfo,"^",7)
	.s:hilistCode="" hilistCode=$P(TarItemInsuInfo,"^",3)
	.s hilistName=$P(TarItemInsuInfo,"^",4)
	.s hilistType="101",chrgType="14"
	.s hilistTypet=$P(TarItemInsuInfo,"^",1)
	.s:hilistTypet="1301" hilistType="101",chrgType="09"
	.s:hilistTypet="1302" hilistType="102",chrgType="10"
	.s:hilistTypet="1303" hilistType="103",chrgType="14"
	.s:hilistTypet="1305" hilistType="201",chrgType="07"
	.s:hilistTypet="1306" hilistType="301",chrgType="08"
	.s hilistDosform=""
	.s hilistLv=$p(TarItemInsuInfo,"^",23)
	.s hilistPric=$FN($p(TarItemInsuInfo,"^",15),"",2)	
	.s (ownpayAmt,selfpayAmt)=0
    .i OutStr1="" d
    ..s OutStr1=hilistType_"^"_chrgType_"^"_hilistCode_"^"_hilistName_"^"_hilistDosform_"^"_hilistLv_"^"_hilistPric_"^"_lv1HospItemPric_"^"_lv2HospItemPric_"^"_lv3HospItemPric_"^"_hilistMemo_"^"_hosplistCode_"^"_hosplistName_"^"_ownpayAmt_"^"_selfpayAmt
    .e       d
    ..s OutStr1=OutStr1_"!"_hilistType_"^"_chrgType_"^"_hilistCode_"^"_hilistName_"^"_hilistDosform_"^"_hilistLv_"^"_hilistPric_"^"_lv1HospItemPric_"^"_lv2HospItemPric_"^"_lv3HospItemPric_"^"_hilistMemo_"^"_hosplistCode_"^"_hosplistName_"^"_ownpayAmt_"^"_selfpayAmt
    q OutStr1
}

}
