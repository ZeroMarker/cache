/// CTOR: QP
/// DATE: 2017-09-08
/// DESC: 抗菌药物对外公共接口类（KSS-V4.0.0 ++）
Class DHCAnt.Serve.ComOut Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// CTOR: QP
/// SENO: F0001
/// DATE: 2017-09-08
/// DESC: 获取预防用药时间代码
/// IN  : 医嘱项ID
/// OUT : 0:非预防	1：术前2小时之前	2：术前0.5-2小时	3：术中
/// 		  4：术后24小时内		5：术后48小时内		6：术后72小时内
/// 		  7：术后72小时后		8：术前0.5-1小时
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetYFDrugTimeCode("650||202")
ClassMethod GetYFDrugTimeCode(oeori As %String)
{
	s yfCode=0
 	q:oeori="" yfCode
 	s daupId=$O(^DAUP("OEORI",oeori,"")) 
 	q:daupId="" yfCode
 	s yfTimeId=$p(^DAUP("DAUP",daupId),"^",22)
 	q:yfTimeId="" yfCode
 	s yfCode=$p(^DHCAntBasePurposeDataConfigD(yfTimeId),"^",4)
 	q yfCode
}

/// CTOR: QP
/// SENO: F0002
/// DATE: 2017-09-08
/// DESC: 获取使用目的代码
/// IN  : 医嘱项ID
/// OUT : 1-1-1：治疗-感染手术-药敏			1-1-2：治疗-感染手术-经验	
/// 	  1-2-1: 治疗-内科-药敏				1-2-2: 治疗-内科-经验
/// 	  1-3-1：治疗-外科-药敏				1-3-2：治疗-外科-经验
/// 	  1-4-1：治疗-其它-其它
/// 	  2-1-1：预防-手术-清洁手术			2-1-2：预防-手术-清洁-感染
/// 	  2-1-3：预防-手术-污染手术			2-1-4：预防-手术-介入手术
/// 	  2-2-1：预防-非手术-MRSA			2-2-2：预防-非手术-其它
/// 	  2-3-1：预防-其它-其它
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetUsePurposeCode("650||202")
ClassMethod GetUsePurposeCode(oeori As %String)
{
	s usePurposeCode=""
 	q:oeori="" usePurposeCode
 	s daupid=$O(^DAUP("OEORI",oeori,"")) 
 	q:daupid="" usePurposeCode
 	s usePurposeId=$p(^DAUP("DAUP",daupid),"^",20)
 	q:usePurposeId="" usePurposeCode
 	s usePurposeCode=$p(^DHCAntBasePurposeDataConfigD(usePurposeId),"^",4)
 	q usePurposeCode
}

/// CTOR: QP
/// SENO: F0003
/// DATE: 2017-09-08
/// DESC: 获取使用目的子类代码
/// IN  : 医嘱项ID
/// OUT : 1-1：感染手术		1-2：内科		1-3: 外科			1-4: 其它
/// 	  2-1：手术			2-2：非手术		2-3：其它
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetUsePurposeItemCode("650||202")
ClassMethod GetUsePurposeItemCode(oeori As %String)
{
	s itemCode=""
 	q:oeori="" itemCode
 	s daupid=$O(^DAUP("OEORI",oeori,"")) 
 	q:daupid="" itemCode 
 	s usePurposeId=$p(^DAUP("DAUP",daupid),"^",20)
 	q:usePurposeId="" itemCode
 	s itemId=$p(^DHCAntBasePurposeDataConfigD(usePurposeId),"^",7)
 	q:itemId="" itemCode
 	s itemCode=$p(^DHCAntBasePurposeDataConfigD(itemId),"^",4)
 	q itemCode
}

/// CTOR: QP
/// SENO: F0004
/// DATE: 2017-09-08
/// DESC: 获取使用目的大类代码
/// IN  : 医嘱项ID
/// OUT : ZL：治疗		YF：预防		PS: 皮试
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetUsePurposeMainCode("650||202")
ClassMethod GetUsePurposeMainCode(oeori As %String)
{
	s mainCode=""
 	q:oeori="" mainCode
 	s daupid=$O(^DAUP("OEORI",oeori,"")) 
 	q:daupid="" mainCode 
 	s usePurposeId=$p(^DAUP("DAUP",daupid),"^",20)
 	q:usePurposeId="" mainCode
 	s mainId=$p(^DHCAntBasePurposeDataConfigD(usePurposeId),"^",6)
 	q:mainId="" mainCode
 	s mainCode=$p(^DHCAntBasePurposeDataConfigD(mainId),"^",4)
 	q mainCode
}

/// CTOR: QP
/// SENO: F0005
/// DATE: 2018-08-10
/// DESC: 变更医师开具抗菌药物权限 【医师资质系统】
/// IN  : "医师工号^抗菌药code^开立权限!医师工号^抗菌药code^开立权限"
/// OUT : 1:更新成功   其他：更新失败
/// EXEC: w ##class(DHCAnt.Serve.ComOut).ChangeDocAuthority("4829^KSS1^N")
ClassMethod ChangeDocAuthority(input As %String)
{
	s Err=0
	q:input="" Err
	s len=$l(input,"!")
	TSTART
	f i=1:1:len {
		q:Err'=0
		s curRecord=$p(input,"!",i)
		S DocCode=$p(curRecord,"^",1)		;医生工号 SS_User表的SSUSR_Initials
		continue:DocCode=""
		s PoisonCode=$p(curRecord,"^",2)
		s KSSAuthority=$p(curRecord,"^",3)
		s ControlType="A"            ;默认权限：允许
		s ChkVerify="N"				 ;默认审核权限：无
		i ((KSSAuthority="Y")&&(PoisonCode="KSS3"))  s ControlType="P"   ;能开特殊级，权限：申请单
		i (KSSAuthority="N") s ControlType="F"							 ;权限禁止
		i ((ControlType="P")||(ControlType="A")) s ChkVerify="Y"		 ;开药权限为申请单或者允许，审核权限：有
		s poisonid=$o(^PHCPO(0,"Code",PoisonCode,0))				 ;管制分类表id	
		s DocCode=$zcvt(DocCode,"U")
		s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",DocCode,0))		 ;SS_User表rowid
		q:Userid="" 
		s CPRowid=$p(^SSU("SSUSR",Userid),"^",9)					 ;CT_CareProv表rowid
		i CPRowid=""  s CPRowid=$p(^SSU("SSUSR",Userid),"^",14)
		continue:CPRowid=""
		s CTPCPid=$p(^CTPCP(CPRowid,1),"^",4)						 ;CT_CarPrvTp 职称表id
		s TPPSub=0
		//遍历寻找该条记录是否存在，存在则更新，否则插入
		f  s TPPSub=$o(^CT("CPT",CTPCPid,"PHPO",TPPSub)) q:(TPPSub="")||(Err'=0)  d
		.s PoisonId=$p(^CT("CPT",CTPCPid,"PHPO",TPPSub),"^",1)
		.q:PoisonId'=poisonid
		.&SQL(Select Count(*) into :Count From SQLUser.DHC_CarPrvTpPHPCp 
			where TCP_ParRef=:CTPCPid And TCP_ParRef2=:TPPSub and TCP_CarPrvDR=:CPRowid )
		.i Count>0 d	//子表有记录
		..&sql(update SQLUser.DHC_CarPrvTpPHPCp set TCP_ControlType=:ControlType,TCP_ChkVerify=:ChkVerify
        	where TCP_ParRef=:CTPCPid And TCP_ParRef2=:TPPSub and TCP_CarPrvDR=:CPRowid )
    	..i SQLCODE s Err="-100"
    	.e  d
    	..&sql(insert into SQLUser.DHC_CarPrvTpPHPCp(TCP_ParRef,TCP_ParRef2,TCP_CarPrvDR,TCP_Active,TCP_ReMark,TCP_ControlType,TCP_ChkVerify) 
	 		values(:CTPCPid,:TPPSub,:CPRowid,"Y","",:ControlType,:ChkVerify))
    	..i SQLCODE s Err="-101"
	}
	i Err'=0 {
		TROLLBACK 
		q Err 
	}
	TCOMMIT
	q 1
}

/// CTOR: QP
/// SENO: F0006
/// DATE: 2018-08-10
/// DESC: 推送抗菌药使用信息 【医师资质系统】
/// IN  : 开始日期，结束日期
/// OUT : 单个记录！单个记录！单个记录   
///       单个记录：医师工号^患者姓名^就诊id^抗菌药通用名^医嘱日期^抗菌药标志(AS)^other^管制分类code	
/// EXEC: w ##class(DHCAnt.Serve.ComOut).ChangeDocAuthority("2018-02-06","2018-02-06")
ClassMethod SendAntUseInfo(stdate As %String, enddate As %String) As %String
{
	s mRtn=0
	q:(stdate="")||(enddate="") mRtn
	s stdate=$zdh(stdate,3),enddate=$zdh(enddate,3)
	s RetStr=""
	s KSSFlag="AS"
	f Date=stdate:1:enddate d
	.s TStDate=$zd(Date,3)
	.s DAUPRowid=0
	.f  s DAUPRowid=$o(^DAUP("Date",Date,DAUPRowid)) q:DAUPRowid=""  d
	..s other="NULL"
	..s Oeori=$P(^DAUP("DAUP",DAUPRowid),"^",3)   ;医嘱id
	..q:Oeori=""
	..s oeoriStatusDr=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",13)
	..q:oeoriStatusDr=""
	..s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	..q:(oeoriStatus="U")||(oeoriStatus="C")   	;过滤掉作废或撤销的医嘱
	..s Userid=$P(^DAUP("DAUP",DAUPRowid),"^",5)  ;ss_user表id
	..q:Userid=""
	..s UserCode=$p(^SSU("SSUSR",Userid),"^",1) 		;医师工号
	..s Admid=$P(^DAUP("DAUP",DAUPRowid),"^",2)			;就诊id
	..s Papmirowid=$p(^PAADM(Admid),"^",1)
	..s PatiName=$p(^PAPER(Papmirowid,"ALL"),"^",1)		;患者姓名
	..s ArcimRowid=$P(^DAUP("DAUP",DAUPRowid),"^",21)	
	..q:ArcimRowid=""
	..s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
	..q:PoisonRowid=""
	..s PoisonCode=$p(^PHCPO(PoisonRowid),"^",1)		;抗菌药级别
	..s phcdf=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",12)
	..q:$g(phcdf)=""
	..s gen=$p(^PHCD(+phcdf,4),"^",1)
	..q:gen=""
	..s ARCIMAbbrev=$p(^PHCGE("GE",gen),"^",2) ;通用名
	..s date=$P(^DAUP("DAUP",DAUPRowid),"^",4)
	..s time=$P(^DAUP("DAUP",DAUPRowid),"^",14)
	..s OeoriDate=$zdt((date_","_time),3)		;医嘱日期
	..s list=UserCode_"^"_PatiName_"^"_Admid_"^"_ARCIMAbbrev_"^"_OeoriDate_"^"_KSSFlag_"^"_other_"^"_PoisonCode
	..i RetStr="" s RetStr=list
	..e  s RetStr=RetStr_"!"_list
	;s RetStr=$p(RetStr,"!",1,$l(RetStr,"!")-1)	//去掉最后一个!后面的
	s KSSSoap=##class(CommonService.CommonServiceHttpPort).%New()
	s Ret=KSSSoap.saveRecord(RetStr)
	
	q 1
}

/// CTOR: QP
/// SENO: F0007
/// DATE: 2018-08-10
/// DESC: 推送抗菌药使用信息（自动任务） 【医师资质系统】
/// IN  : 开始日期，结束日期
/// OUT : 
/// 
/// EXEC: w d ##class(DHCAnt.Serve.ComOut).AutoTaskToOA()
ClassMethod AutoTaskToOA()
{
    s sysdate=$p($h,",",1)  
    s startDate=$zd((sysdate-1),3)
    s endDate=$zd(sysdate-1,3)
    d ..SendAntUseInfo(startDate,endDate)
    q 1
}

/// CTOR: QP
/// SENO: F0008
/// DATE: 2018-08-27
/// DESC: 是否抗菌药物
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.Serve.ComOut).IsAntiDrug("1||12")
ClassMethod IsAntiDrug(oeori As %String)
{
	s mRtn=0
	q:oeori="" mRtn
	s ord=+oeori,ordSub=$p(oeori,"||",2)
	q:'$d(^OEORD(ord,"I",ordSub,1)) mRtn
    s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	q:arcim="" mRtn
	s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	q:phcdf="" mRtn
	s phcm=+phcdf
	s phcpo=$p(^PHCD(phcm,1),"^",4) 
	q:phcpo="" mRtn 
	s phcpoCode=$zcvt($p($g(^PHCPO(phcpo)),"^",1),"U")  
    i phcpoCode["KSS" s mRtn=1 
 	
	q mRtn
}

/// CTOR: QP
/// SENO: F0009
/// DATE: 2019-12-24
/// DESC: 根据医嘱ID,获取抗菌药物会诊ID
/// IN  : 
/// OUT : 55,56
/// 
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetConidByOeori("258||9")
ClassMethod GetConidByOeori(oeori As %String)
{
	s mRtn=""
	
	q:'$d(^DHCDAAi(0,"OEORI",oeori)) mRtn
	s aaid=$o(^DHCDAAi(0,"OEORI",oeori,0))
	q:aaid="" mRtn
	
	s oneConid=$p($g(^DHCDAA("ANT",aaid,1)),"^",22)
	s twoConid=$p($g(^DHCDAA("ANT",aaid,1)),"^",26)
 	s threeConid=$p($g(^DHCDAA("ANT",aaid,1)),"^",29)
 	i oneConid'="" {
		s mRtn=oneConid
	}
	i twoConid'="" {
		i mRtn'="" s mRtn=mRtn_","_twoConid
		e  s mRtn=twoConid
	}
	i threeConid'="" {
		i mRtn'="" s mRtn=mRtn_","_threeConid
		e  s mRtn=threeConid
	}
	
	q mRtn
}

/// CTOR: QP
/// SENO: F0010
/// DATE: 2020-03-23
/// DESC: 根据医嘱项判断是否为，碳青霉烯类抗菌药物或替加环素类
/// IN  : 医嘱项ID, mode: 1 2 3
/// 	  mode=1 代表 碳青霉烯类抗菌药物
/// 		  mode=2 代表 替加环素类
/// 		  mode=3 代表 碳青霉烯类抗菌药物 和 替加环素类
/// OUT : 1：是 /  0：否
/// EXEC: w ##class(DHCAnt.Serve.ComOut).ComIsCqmxOrTgc("1565||1", 1,2)
ClassMethod ComIsCqmxOrTgc(arcim As %String = "", mode As %String = "", inHosp = "")
{
	s mRtn=0
	s id=$o(^CF.ANT.ItmMastI("HospArcim",inHosp,arcim,0))
	q:id="" mRtn
	s isCqmx=$p(^CF.ANT.ItmMastD(id),"^",2)
	s isTgc=$p(^CF.ANT.ItmMastD(id),"^",3)
	s isCqmx=$p(^CF.ANT.ItmMastD(id),"^",2)
	if mode=1 {
		i isCqmx="Y" s mRtn=1
	} elseif mode=2 {
		i isTgc="Y" s mRtn=1
	} else {
		i (isCqmx="Y")||(isTgc="Y") s mRtn=1
	}
	
	q mRtn
}

/// CTOR: QP
/// SENO: F0011
/// DATE: 2021-08-04
/// DESC: 变更医师开具抗菌药物权限 【医师资质系统】
/// IN  : XML 当type=1时，为医师工号；当type=0时，为级别编码
/// OUT : >0:更新成功   其他：更新失败
/// EXEC: w ##class(DHCAnt.Serve.ComOut).SaveKSSAuthByXML("")
ClassMethod SaveKSSAuthByXML(InXML As %String = "")
{
	s mRtn=1
	;s InXML="<Request><Header><SourceSystem/><MessageID/></Header><Body><SynAntiRt><type>1</type><phyNum>2411</phyNum><permissionsNum>KSS2</permissionsNum><visittype>E</visittype><permissiontype>A</permissiontype><ischeck>1</ischeck><hospitalcode>DHSZHYYZY</hospitalcode></SynAntiRt></Body></Request>"
	s ^TEMP("QP","DS",1)=InXML
	//s InXML="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><SynAntiRt><phyNum>YS01</phyNum><permissionsNum>KSS1</permissionsNum><visittype>I</visittype><permissiontype>A</permissiontype><ischeck>Y</ischeck><type>1</type><hospitalcode>DHSZHYYZY</hospitalcode></SynAntiRt></Body></Request> "
	//s InXML="<Request><Header><SourceSystem/><MessageID/></Header><Body><SynAntiRt><type>0</type><phyNum>231</phyNum><permissionsNum>KSS1</permissionsNum><visittype>E</visittype><permissiontype>F</permissiontype><ischeck>1</ischeck><hospitalcode>DHSZHYYZY</hospitalcode><OperateUser>YS01</OperateUser></SynAntiRt></Body></Request>"
	Q:InXML="" ..DoXML("-1^参数为空")
	
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	s ReturnObj=##class(DHCAnt.Serve.Model.ARoot).%New()
	d ReturnStream.Write(InXML)
	;b ;ReturnStream
	d ReturnStream.Rewind()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(ReturnStream)
	d reader.Correlate("Request","DHCAnt.Serve.Model.ARoot")
	while reader.Next(.obj,.sc)
	{
		s ReturnObj=obj
	}
	
	s BodyList=ReturnObj.BodyList
	s BodyCount=BodyList.Count()
	s mRtn="",Exit=0
	TS
	f i=1:1:BodyCount {
		Q:Exit=1
		s SynAntiRtList=BodyList.GetAt(i).SynAntiRtList
		s SynAntiRtCount=SynAntiRtList.Count()
		f j=1:1:SynAntiRtCount {
			Q:Exit=1
			s SynAntiRtObj=SynAntiRtList.GetAt(j)	
			s phyNum=SynAntiRtObj.phyNum
			s permissionsNum=SynAntiRtObj.permissionsNum
			s visittype=SynAntiRtObj.visittype
			s permissiontype=SynAntiRtObj.permissiontype
			s ischeck=SynAntiRtObj.ischeck
			s type=SynAntiRtObj.type
			s hospitalcode=SynAntiRtObj.hospitalcode
			s OperateUser=SynAntiRtObj.OperateUser
			s InPara=type_"^"_phyNum_"^"_permissionsNum_"^"_visittype_"^"_permissiontype_"^"_ischeck_"^"_hospitalcode_"^"_OperateUser
			s mRtn=..SaveKSSAuth(InPara)
			i +mRtn<0 {
				s Exit=1
				Q
			}
		}
		
	}
	i Exit=1 {
		TRO
		Q ..DoXML("-101^"_$p(mRtn,"^",2))
		;Q "-101^"_$p(mRtn,"^",2)	
	}
	TC
	Q ..DoXML("1^")
	;Q "1^"
}

/// CTOR: QP
/// SENO: F0012
/// DATE: 2018-08-10
/// DESC: 变更医师开具抗菌药物权限 【医师资质系统】
/// IN  : type_"^"_phyNum_"^"_permissionsNum_"^"_visittype_"^"_permissiontype_"^"_ischeck_"^"_hospitalcode
///       当type=1时，为医师工号；当type=0时，为级别编码
/// OUT : 1:更新成功   其他：更新失败
/// EXEC: w ##class(DHCAnt.Serve.ComOut).ChangeDocAuthority()
ClassMethod SaveKSSAuth(InPara As %String)
{
	;参数解析
	s Type=$p(InPara,"^",1)
	S DocCode=$p(InPara,"^",2)	
	s PoisonCode=$p(InPara,"^",3)
	s PAAdmType=$p(InPara,"^",4) 
	s ControlType=$p(InPara,"^",5)
	s ChkVerify=$p(InPara,"^",6) 
	i ChkVerify="Y" s ChkVerify=1
	e   s ChkVerify=0
	s HospCode=$p(InPara,"^",7) 
	s OperateUser=$p(InPara,"^",8) 
	;参数检验
	Q:HospCode="" "-1^院区代码为空！"
	Q:Type="" "-1^医生标志为空！"
	Q:PoisonCode="" "-1^抗菌药物代码为空！"
	Q:PAAdmType="" "-1^就诊类型为空！"
	Q:ControlType="" "-1^允许类型为空！"
	Q:DocCode="" "-1^医生工号为空！"
	;HIS验证
	s HospId=$o(^CT("HOSP",0,"Code",HospCode,""))
	Q:HospId="" "-1^医院在HIS中不存在！"
	s PoisonDR=$O(^PHCPO(0,"Code",PoisonCode,""))
	Q:PoisonDR="" "-1^管制分类代码不存在！"
	s OperateUser=$zcvt(OperateUser,"U")
	s OperateUser=$O(^SSU("SSUSR",0,"SSUSR_Initials",OperateUser,0))
	q:OperateUser="" "-1^操作人工号在HIS中不存在！"
	i Type=1 {
		//医生权限
		s DocCode=$zcvt(DocCode,"U")
		s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",DocCode,0))
		q:Userid="" "-1^医生工号在HIS中不存在！"
		s CPRowid=$p(^SSU("SSUSR",Userid),"^",14)
		q:CPRowid="" "-1^医护人员中不存在该用户！"
		s CTPCPid=$p(^CTPCP(CPRowid,1),"^",4)
		Q:CTPCPid="" "-1^医生级别在HIS中不存在！"
		
		//DHCAnt.KSS.Config.Authority DBUpdateAuthItemNew						
		s ID=""
		s itemId=##class(DHCAnt.KSS.Config.Authority).GetmainID(CTPCPid,PoisonDR,PAAdmType,HospId)
		q:itemId="" "-1^HIS该职称权限数据没有维护，请通知HIS相关人员！"
		S rw=+itemId
    	s chl=$p(itemId,"||",2)
		s sub=$o(^CT(0,"CPDR",CPRowid,rw,chl,""))
		i sub'="" s ID=itemId_"||"_sub
    	s InPara=ID_"^"_CPRowid_"^"_CTPCPid_"^"_PoisonCode_"^"_ControlType_"^"_PAAdmType_"^"_ChkVerify_"^"_itemId_"^"_HospId_"^"_OperateUser
		s mRtn=##class(DHCAnt.KSS.Config.Authority).DBUpdateAuthItemNew(InPara)
		Q:mRtn'=0 "-1^保存失败！"
		
	} else {
		//级别权限
		s CTPCPid=$O(^CT("CPT",0,"Code",DocCode,"")) 
		Q:CTPCPid="" "-1^医生级别在HIS中不存在！"
		s mRtn=##class(DHCAnt.KSS.Config.Authority).SaveLevelAuth(CTPCPid,PoisonDR,ControlType,PAAdmType,ChkVerify,HospId,OperateUser)
		Q:mRtn'=0 "-1^保存失败！"
		
		
	}
	
	Q "1^"
}

/// CTOR: QP
/// SENO: F0013
/// DATE: 2022-04-18
/// DESC: 获取手术预防信息
/// IN  : 就诊id,手术申请id【DHC_AN_OPArrange】
/// OUT : 是否预防使用抗菌药物（使用则传1 未使用 0），预防使用抗菌药物天数
/// 
/// EXEC: w ##class(DHCAnt.Serve.ComOut).F0013(AdmID,OpaId)
ClassMethod F0013(AdmID As %String, OpaId As %String)
{
	Q:(AdmID="")||(OpaId="") "0^0"
	s id="",YFDays=0,IsYF=0
	k TEMPList
	for {
		s id=$o(^DAUP("NEWADM",AdmID,id))
		q:id=""
		s oeori=$p(^DAUP("DAUP",id),"^",3)
		continue:oeori=""
		continue:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(oeori)=1
		s UsePurposeDR=$p(^DAUP("DAUP",id),"^",20)
		i UsePurposeDR'="" {
			s UsePurposeDesc=$p(^DHCAntBasePurposeDataConfigD(UsePurposeDR),"^",3)
			i UsePurposeDesc["预防" s IsYF=1
		}
		s operDR=$p(^DAUP("DAUP",id),"^",9)
		continue:operDR=""
		continue:##class(DHCAnt.KSS.Common.Method).InArray(operDR,OpaId)'=1
		s ord=+oeori,sub=$p(oeori,"||",2)
		s stdate=$p(^OEORD(ord,"I",sub,1),"^",9)
		s PriorRowid=$p(^OEORD(ord,"I",sub,1),"^",8)
		s LongOrder=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		i LongOrder=1 {
			s xdate=$p(^OEORD(ord,"I",sub,3),"^",34)
			d ..DoTMPList(stdate,xdate,.TEMPList)
		}else {
			i stdate'="" s TEMPList(stdate)=""
		}
		s IsYF=1
		
	}
	
	s cdate=""
	for {
		s cdate=$o(TEMPList(cdate))
		q:cdate=""
		s YFDays=YFDays+1	
	}
 	
	q IsYF_"^"_YFDays
}

ClassMethod DoTMPList(stdate, endate, ByRef TEMPList)
{
	Q:stdate=""||endate=""
	for date=stdate:1:endate {
		s TEMPList(date)=""
	}
	
	Q ""
}

ClassMethod DoXML(errInfo)
{
	s errCode=$p(errInfo,"^",1)
	s errMsg=$p(errInfo,"^",2)
	i errCode>=0 {
		s errCode=0,errMsg="成功！"
	} else {
		s errCode=-1	
	}
	s resultXML="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"
	s resultXML=resultXML_"<ResultCode>"_errCode_"</ResultCode><ResultContent>"_errMsg_"</ResultContent></Body></Response>"	
	Q resultXML
}

/// CTOR: QP
/// SENO: F0015
/// DATE: 2023-02-15
/// DESC: 获取抗菌药物名称、抗菌药物开立时间【病历内涵质控】
/// IN  : 就诊ID
/// OUT : 抗菌药物1^2022-01-01 00:00:00\抗菌药物2^2022-02-01 00:00:00
/// EXEC: w ##class(DHCAnt.Serve.ComOut).GetAntUseTimeByAdm("195")
ClassMethod GetAntUseTimeByAdm(admId)
{
	Q:admId="" ""
	s oeori=""
	s mRtn=""
	for {
		s oeori=$o(^DAUP("ADM",admId,oeori))
		q:oeori=""
		continue:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(oeori)=1
		s OEORISttDat=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",9)
		s OEORISttTim=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",10)
		s arcimDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
		s arcimDesc=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",2)
		s OEORISttDat=##class(websys.Conversions).DateLogicalToHtml(OEORISttDat)
		s OEORISttTim=$zt(OEORISttTim,1)
		s row=arcimDesc_"^"_OEORISttDat_" "_OEORISttTim
		i mRtn="" s mRtn=row
		e  s mRtn=mRtn_"\"_row
	}
	Q mRtn
}

}
