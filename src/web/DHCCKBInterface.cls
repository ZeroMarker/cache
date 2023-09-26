Import SQLUSER

/// Creator: 	qunianpeng
/// CreateDate: 2019-01-09
/// Descript: 	知识库接口类
Class web.DHCCKBInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	bianshuai
/// CreateDate: 2019-01-07
/// Descript: 	cdss http后台访问康夫子
/// W ##Class(web.DHCCKBInterface).getSerContent("")
ClassMethod getSerContent(Input As %String) As %String
{
	n (Input)
	Set httprequest=##class(%Net.HttpRequest).%New()
	//s newstream=##class(%FileCharacterStream).%New()
	//s newstream.Filename = "D:\basejson.txt"
	//do httprequest.EntityBody.CopyFrom(newstream)
    do httprequest.EntityBody.Write(Input)

	//s url="http://demo.kangfuzi.com:9113/"		// 更换实际地址
	s url="http://192.168.9.16:7708/bridge"			// 北京监狱管理局医院
	do httprequest.Post(url)
	
	s retStr=httprequest.HttpResponse.Data.Read()
	
	q retStr
}

/// Descript: 其他组后台调用cdss接口
/// Input:    mEmrObj - cdss emr_content 对象
/// w ##Class(web.DHCCKBInterface).InvokeCdss(mEmrObj)
ClassMethod InvokeCdss(mEmrObj As web.DHCAPPJsonObject) As %String
{
	n (mEmrObj)
	s $zt="ErrMsg"
	s mainObj = ##class(web.DHCAPPJsonObject).%New()
	/// 基础信息
	d mainObj.Put("action","update_cdss_info")
	d mainObj.Put("user_name","donghua")
	d mainObj.Put("user_id","kfz0")
	d mainObj.Put("pwd","donghua2018")
	d mainObj.Put("oeori","donghua2018")
	d mainObj.Put("emr_content",mEmrObj.Json())
	s retJson=..getSerContent(mainObj.Json())
	s Err=0
	s Err=##class(web.DHCCKBConfigLog).SaveConfigLog(mainObj.Json(),retJson)
	Q Err
ErrMsg
	Q "-99"
}

/// Descript: CDSS 示例代码(提供给其他产品组后台传参示例)
/// w ##Class(web.DHCCKBInterface).GetCKBJson()
ClassMethod GetCKBJson() As web.DHCAPPJsonObject
{
	
	s mEmrObj = ##class(web.DHCAPPJsonObject).%New()
	/// 病人信息
	s mPatObj = ##class(web.DHCAPPJsonObject).%New()
	d mPatObj.Put("Patient_id","00000001")
	d mPatObj.Put("Patient_name","Ty01")
	d mPatObj.Put("Patient_age","23")
	d mPatObj.Put("Patient_age_unit","岁")
	d mPatObj.Put("Patient_gender","女")
	d mPatObj.Put("Pregnant_status","0")
	d mPatObj.Put("Patient_phone","18092126666")
	d mPatObj.Put("Patient_address","陕西省西安市环普产业园E座204室")
	d mPatObj.Put("OeOriStr","医嘱id串")
	d mEmrObj.Put("Patient_info",mPatObj.Json())
	
	/// 诊断信息
	s mDiagObj = ##class(web.DHCAPPJsonObject).%New()
	d mDiagObj.Put("diagnosis_first","怀孕")
	d mDiagObj.Put("diagnosis_add","")
	d mDiagObj.Put("diagnosis_diff","")
	d mDiagObj.Put("diagnosis_confirm","")
	d mEmrObj.Put("diagnosis",mDiagObj.Json())
	
	/// 主诉症状
	d mEmrObj.Put("record_time","")
	d mEmrObj.Put("template_type","首次病程记录")
	d mEmrObj.Put("raw_emr","")
	d mEmrObj.Put("chief_complaint","")
	d mEmrObj.Put("HPI","")
	d mEmrObj.Put("PMH","久居本地，无疫区、疫情接触史")
	d mEmrObj.Put("PRH","")
	d mEmrObj.Put("FH","母亲患有高血压，父亲糖尿病")
	d mEmrObj.Put("AH","双嘧达莫片过敏，有头孢过敏史")
	d mEmrObj.Put("MRH","")
	d mEmrObj.Put("MH","")
	d mEmrObj.Put("PE","")
	
	/// 检查检验
	s LabObj={}
	s LabObj.names=[]
	s LabObj.result=""
	s mExaLabObj = ##class(web.DHCAPPJsonObject).%New()
	d mExaLabObj.Put("exam_items",LabObj.%ToJSON())
	d mExaLabObj.Put("lab_items",LabObj.%ToJSON())
	d mEmrObj.Put("EXAM",mExaLabObj.Json())
	
	/// 手术
	d mEmrObj.Put("operation",[])
	d mEmrObj.Put("physical_therapy",[])
	
	/// 药品列表
	s itemObj = ##class(web.DHCAPPJsonObject).%New()
	s combination=[]
	s itemObj1={}		// 此处示例itemObj1写了两个，实际中根据药品有多少组，循环实现
	s itemObj1.prescription=[]
	s itemObj2={}
	s itemObj2.prescription=[]
	d combination.%Push(itemObj1)
	d combination.%Push(itemObj2)
	d itemObj.Put("combination_drug",combination.%ToJSON())
	d mEmrObj.Put("treatment",itemObj.Json())
	
	Q mEmrObj
}

/// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// *****************所有需要用到his(东华)数据的地方，通过接口类的方式进行调用获取*************************************
/// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Creator: 	qunianpeng
/// CreateDate: 2019-01-09
/// Descript: 	通过code获取his医嘱项id
ClassMethod GetArciByCode(code) As %String
{
	n (code)
	
	//^ARCIM(0,"Code",$$ALPHAUP({ARCIM_Code}),{ARCIM_Subscript},{ARCIM_Version})
}

/// Creator: 	qunianpeng
/// CreateDate: 2019-01-09
/// Descript: 	通过code获取his医嘱项id
ClassMethod GetArciByCode1(code) As %String
{
	n (code)
}

/// Creator: 	qunianpeng
/// CreateDate: 2019-01-09
/// Descript: 	获取his转换系数(等效数量)
/// Input:		医嘱项id,单位
/// OutPut:		大于0是系数, 否则是转换不了
/// w ##class(web.DHCCKBInterface).GetUomFactor("1817||1","ml")
ClassMethod GetUomFactor(arci, uom)
{
	
	n (arci,uom)
	s sub=$p(arci,"||",1)
	q:sub="" 0
	s ver=$p(arci,"||",2)
	q:ver="" 0
	
	s phcdf=$P(^ARCIM(sub,ver,1),"^",12) //药学项
	s phc=$P(phcdf,"||",1)
	q:phc="" 0
	s formsub=$P(phcdf,"||",2)			//药学剂型
	q:formsub="" 0
	
	s eqsub=0,eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d  // PHC_FormDoseEquiv ?
	.s equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)  
	.s equom=$P($G(^CT("UOM",equomdr)),"^",2)				 //	等效单位描述
	.q:equom=""
	.q:equom'=uom
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) 	// 等效数量

	q +eqqty
}

/// Creator: 	qunianpeng
/// CreateDate: 2019-11-20
/// Descript:	获取单位转换系数(his)
/// Table:		CT_ConFac（单位转换 -demo->基础数据->库存->单位转换） // 单位转换系数只能维护大于1的整数,貌似不可用
ClassMethod GetUomChangeFac(frUom, toUom)
{
	n (frUom,toUom)
	q:(frUom="")||(toUom="") ""
	
	s frUomID=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(frUom),""),-1)
	s toUomID=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(toUom),""),-1)
	
	q:(frUomID="")||(toUomID="") ""
	
	s conID="",exitFlag=0,fac=""
	f  s conID=$o(^CT("CTCF",0,"UOM",frUomID,toUomID,conID)) q:(conID="")||(exitFlag=1)  d
	.s activeFlag=$p(^CT("CTCF",conID),"^",4)
	.q:activeFlag'="Y"
	.s fac=$p(^CT("CTCF",conID),"^",3)
	.s exitFlag=1
	
	q fac
}

/// Creator: 	qunianpeng
/// CreateDate: 2019-11-20
/// Descript: 	将his剂量转成知识库的剂量(同单位)
/// w ##class(web.DHCCKBInterface).GetFactorToLib()
ClassMethod GetFactorToLib(arciDesc, arci As %String, hisUomDesc As %String, libUomDesc As %String) As %String
{
	n (arciDesc,arci,hisUomDesc,libUomDesc) 
	
	s fac=""
	s fac=..GetUomChangeFac(hisUomDesc,libUomDesc)
	q:fac'="" fac
		
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFac(hisUomDesc,libUomDesc)
	q:fac'="" fac
	
	s fac=##class(web.DHCCKBCommonUtil).GetUomChangeFacNew(hisUomDesc,libUomDesc)
	q:fac'="" fac
		
	i arci="" d
	.s arci=$o(ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(arciDesc),""),-1)
	.s arci=arci_"||"_1

	s sub=$P(arci,"||",1)
	q:sub="" ""
	s ver=$P(arci,"||",2)
	q:ver="" ""
	s incidr=$O(^INCI(0,"ARCIM_DR",sub,""))
	q:incidr="" ""
	q:'$D(^INCI(incidr,1)) ""
	q:'$D(^INCI(incidr,3)) ""
	s buom=$P(^INCI(incidr,1),"^",10)  //基本单位
	s puom=$P(^INCI(incidr,3),"^",6)   //入库单位
	q:'$D(^ARCIM(sub,ver,1)) ""
	s phcdf=$P(^ARCIM(sub,ver,1),"^",12) //药学项
	s phc=$P(phcdf,"||",1)
	q:phc="" ""
	s formsub=$P(phcdf,"||",2)
	q:formsub="" ""
	
	s eqsub="",libFlag=0,hisFlag=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d  //qnp PHC_FormDoseEquiv ?
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)  
	.s equom=$P($G(^CT("UOM",equomdr)),"^",2)				  //等效单位描述
	.q:equom=""
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) 	//等效数量
	.
	.i equom=libUomDesc  d
	..s mlqty=eqqty,libFlag=1
	.//i equom=hisUomDesc d
	.//.s otherqty=eqqty,hisFlag=1

	q:libFlag=0 ""
	
	// 知识库单位和等效单位一致时,将his剂量转成等效单位数量
	i (libFlag=1)  d 
	.s:+$g(mlqty)=0 mlqty=1
	.s fac=mlqty
	
	q fac
}

/// Creator: 	qunianpeng
/// CreateDate: 2020-06-17
/// Descript: 	获取知识库数据信息
/// Input：		类型(带剂型的通用名)
/// w ##class(web.DHCCKBInterface).GetDataList("GeneralFromData")
ClassMethod GetDataList(type As %String, loginInfo As %String) As %String
{
	n (type,loginInfo)
	
	s parref=##class(web.DHCCKBCommon).GetDicIdByCode(type)
	q:+parref=0 "[]"
	
	s DrugCatID=##class(web.DHCCKBCommon).GetDrugCategoryData() 	
	if parref=##class(web.DHCCKBCommon).GetDrugCategoryData() d	
	.w ##class(web.DHCCKBQueryDic).GetTreeJsonData("",DrugCatID)	
	q:parref=DrugCatID ""
	
	d ##class(web.DHCCKBQueryDic).GetDataListByParref(.TmpArr,parref,loginInfo)
		
	s count=0	
	s listTitle="id^code^text"
	//w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	W "["
	s index=""	  
	f  s index=$o(TmpArr(index)) q:(index="")  d
	.s listData=$g(TmpArr(index))
	.s count=count+1
	.i count=1 D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	W "]"
	//w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符	
	
	k TmpArr
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2020-06-17
/// Descript: 	暂存cdss结构化的数据
/// Input：		知识信息json串
/// w ##class(web.DHCCKBInterface).SaveCdssDataTmp(dataObj)
ClassMethod SaveCdssDataTmp(dataObj As %String) As %String
{
	n (dataObj)
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s ^TMP("DHCCKB","web.DHCCKBInterface","SaveCdssDataTmp",pid)=dataObj
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2020-11-30
/// Descript: 	安全用药的交互
/// Input：		知识信息json串
/// w ##class(web.DHCCKBInterface).FeedBack()
ClassMethod FeedBack(msgID, user, date, time, ordItemStr, userType, reasonStr) As %String
{
	n (msgID,user,date,time,ordItemStr,userType,reasonStr)
	
	q:(+msgID=0)||(+user=0) -1	
	
	// 将医嘱id串和界面的录入信息 关联起来
	s input = ..DealOrdItemNote(msgID,ordItemStr,reasonStr)

	// 调用药房接口,自动审核
	s str = $p(ordItemStr,"&&",1)
	s ordItem = $p(str,"^",1)		// 医嘱id
	s admType = ..GetAdmTypeByOeord(ordItem)
	//i admType'="O" d		// 门诊暂时不走审方(因为药房门诊审方需要处方号)
	//.d ..AutoAudit(input)	// 正式库先不调用药房程序,等流程确认后药房修改后，在放开注释(20210330 qnp)
	
	// 存储交互信息
	s ret=..SaveFeedBackData(msgID,user,date,time,userType,input)
	
	q ret
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	将医嘱id和医生备注信息关联上
/// Input：		ordItemStr(医嘱id串),reasonStr(备注信息串)
/// w ##class(web.DHCCKBInterface).DealOrdItemNote
ClassMethod DealOrdItemNote(msgID, ordItemStr, reasonStr) As %String
{
	n (msgID,ordItemStr,reasonStr)
	
	s reasonObj = ##class(DHCNewPro.COM.Object).FromJSON(reasonStr)

	s input = ""
	s len = $length(ordItemStr,"&&")
	f k = 1:1:len  d
	.s str = $p(ordItemStr,"&&",k)
	.s ordItem = $p(str,"^",1)	// 医嘱id
	.s status = $p(str,"^",2)	// 交互状态
	.s reaLen = reasonObj.Size()
	.s markObj = ##class(DHCNewPro.COM.Object).%New()
	.f j = 0:1:reaLen-1  d
	..s itmObj = reasonObj.Get(j)
	..s item = itmObj.item
	..s seqno = itmObj.seqno
	..s ret = ..ComporeOrdItem(ordItem,item,seqno)
	..s:ret=1 markObj = itmObj	
	.
	.//q:markObj="" 
	.s manlevel = markObj.manlevel
	.//s manlevel = ##class(web.DHCCKBCommon).GetManLevelNum(manlevel)
	.s unique = markObj.unique
	.s note = markObj.val
	.s selReason = markObj.selectReason
	.i manlevel="" s status="P"
	.i input = "" s input = ordItem_"^"_msgID_"^"_manlevel_"^"_status_"^"_note_"^"_selReason_"^"_unique
	.e  s input = input _"$$$"_ordItem_"^"_msgID_"^"_manlevel_"^"_status_"^"_note_"^"_selReason_"^"_unique	
	
	q input
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	比较生成的医嘱id和消息弹窗中录入的备注是否是同一条记录(序号和药品名称相同,认为是同一个)
/// Input：		ordItemStr(医嘱id串),reasonStr(备注信息串)
/// return:		1 是 0 不是
/// w ##class(web.DHCCKBInterface).ComporeOrdItem("2258390||160","维生素C注射液(天津金耀)5ml:1g",1)
ClassMethod ComporeOrdItem(ordItem, queryItem, querySeqno) As %String
{
	n (ordItem,queryItem,querySeqno)
	
	// 通过医嘱id获取医嘱项名称,序号
	s order = +ordItem
	s ordSub = $p(ordItem,"||",2)
	s seqno = $p($g(^OEORD(order,"I",ordSub,3)),"^",4)
	q:seqno="" 0
	//q:(querySeqno'="")&(querySeqno'=seqno) 0
	s arciDr = $p($g(^OEORD(order,"I",ordSub,1)),"^",2)
	q:arciDr="" 0
	
	s sub = +arciDr
	s ver = $p(arciDr,"||",2)
	s itemMastDesc = $p(^ARCIM(sub,ver,1),"^",2)
	q:itemMastDesc="" 0
	q:(queryItem'="")&(queryItem'=itemMastDesc) 0
	
	q 1
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	调用药房住院医嘱自动审核
/// Input：		input: 医嘱ID^msgID^level^强制审核$$$医嘱ID^msgID^level^强制审核
/// return:		1 是 0 不是
/// w ##class(web.DHCCKBInterface).AutoAudit()
ClassMethod AutoAudit(input, admType) As %String
{
	n (input,admType)
	s $ZT="ErrMsgAuto"
	
	i (admType="O")||(admType="E")  d
	.s ret = ##class(web.DHCSTCNTSOUTMONITOR).AutoAudit(input)	// 门诊
	e  d
	.//s ret = ##class(web.DHCSTCNTSIPMONITOR).AutoAudit(input) // 住院
	.s ret = ##class(web.DHCSTINTERFACE).AutoAudit(input)	// 住院
	
	q ""
ErrMsgAuto
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	安全用药的强制审核原因
/// Input：		知识信息json串
/// w ##class(web.DHCCKBInterface).SaveFeedBackData("7014","17526","2021-03-29","09:41:09","Pha","2059600||548^7014^warn^Y^")
ClassMethod SaveFeedBackData(msgID, user, date, time, userType, input) As %String
{
	n (msgID, user, date, time, userType, input)
	
	Ts
	//ordItemStr: oeordItem_"^"_status_"^"_notes&&
	//		 医嘱id		 日志id		级别					   交互状态   备注     批注勾选(!!分割)      唯一标识 $$$
	//input: ordItem_"^"_msgID_"^"_manlevel_"^"_status_"^"_note_"^"_selReason			_"^"_unique
	s date = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(date)	
	s time = ##class(web.DHCCKBCommonUtil).TimeHtmlToLogical(time)
	
	s ret = 0
	s len = $length(input,"$$$")
	f k = 1:1:len  q:ret'=0  d
	.s str = $p(input,"$$$",k)
	.s ordItem = $p(str,"^",1)
	.s level = $p(str,"^",3)
	.//s level = ##class(web.DHCCKBCommon).GetManLevelCodeByNum(level)
	.s status = $p(str,"^",4)
	.s notes = $p(str,"^",5)
	.s reason = $p(str,"^",6)
	.s unique = $p(str,"^",7)	
	.&sql(insert into CKB_PDSS.FeedBack (FB_MsgID,FB_User,FB_Date,FB_Time,FB_OrdItem_Dr,FB_Status,FB_UserType,FB_Notes,FB_Reason,FB_Level,FB_Unique) values (:msgID,:user,:date,:time,:ordItem,:status,:userType,:notes,:reason,:level,:unique))
	.s ret = SQLCODE

	i ret'=0 tro
	e  tc
	
	q ret
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	通过医嘱id获取msgID和level级别
/// Input：		oeorItem医嘱id, type
/// w ##class(web.DHCCKBInterface).GetMsgByOeorItem()
ClassMethod GetMsgByOeorItem(oeorItem, type = "Doc") As %String
{
	n (oeorItem,type)
	
	q:(oeorItem="")||(type="") ""
	
	s str = ""
	s flag = 0
	s feedID = ""
	f  s feedID = $o(^CKB.PDSS.FeedBackI("OeorItem",oeorItem,type,feedID),-1)  q:(feedID="")||(flag = 1)  d
	.s feedData = $g(^CKB.PDSS.FeedBackD(feedID))
	.s msgID = $lg(feedData,2) 
	.s level = $lg(feedData,11) 
	.//s level = ##class(web.DHCCKBCommon).GetManLevelNum(level)
	.s str = msgID_"^"_level
	.s flag = 1
	
	q str
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-27
/// Descript: 	通过医嘱id获取就诊类型(门诊,住院,急诊等)
/// Input：		oeorItem医嘱id
/// w ##class(web.DHCCKBInterface).GetAdmTypeByOeord("2258390||171")
ClassMethod GetAdmTypeByOeord(oeorItem) As %String
{
	n (oeorItem)
	
	s oeorder = +oeorItem
	q:oeorder=0 ""
	
	s adm = $p($g(^OEORD(oeorder)),"^",1)
	q:+adm=0 ""
	s admType = $p($g(^PAADM(adm)),"^",2)
	
	q admType
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-04-28
/// Descript: 	通过医嘱id获取是否是静配医嘱标志
/// Input：		oeorItem医嘱id
/// w ##class(web.DHCCKBInterface).GetNeedPIVAFlag("93||466")
ClassMethod GetNeedPIVAFlag(oeorItem) As %String
{
	n (oeorItem)
	
	s ret = "N"
	q:oeorItem="" ret
	s oeord = +oeorItem
	s sub = $p(oeorItem,"||",2)
	s flag = $p(^OEORD(oeord,"I",sub,"DHC"),"^",16)
	s flag = $zcvt(flag,"U")
	s ret = $case(flag="Y",1:flag,:ret)

	q ret
}

/// Creator: 	qunianpeng
/// CreateDate: 2021-03-28
/// Descript: 	保存医嘱后,调用接口保存医嘱信息
/// Input：		oeordItemStr(医嘱id^药品唯一标识^药品通过标识)
/// return:		msgID^级别
/// w ##class(web.DHCCKBInterface).SaveOeordFeedBack("3193||174^73100^Y!!3193||175^73099^N")
ClassMethod SaveOeordFeedBack(oeordItemStr) As %String
{
	n (oeordItemStr)
	
	s msgID = "", passType ="P", ret = 0
	
	s admTye = ""
	Ts
	s input = ""
	s len = $length(oeordItemStr,"!!")
	f i=1:1:len  q:ret'=0  d 
	.s itemStr = $p(oeordItemStr,"!!",i)
	.s oeordItemDr = $p(itemStr,"^",1)
	.i admTye="" s admTye = ..GetAdmTypeByOeord(oeordItemDr)
	.s fbRowID = $p(itemStr,"^",2)
	.s drugPassFlag = $p(itemStr,"^",3)
	.s feedData = $g(^CKB.PDSS.FeedBackD(fbRowID))
	.s msgID = $lg(feedData,2) 
	.s passStatus = $select(drugPassFlag="N":"R",1:"P")
	.i passStatus="R" s passType=passStatus
	.s prescFlag = "Y"
	.s ret= ##Class(web.DHCCKBFeedBack).UpdateOeordFeedBack(fbRowID,oeordItemDr,passStatus)
	.q:ret'=0
	.s level = $lg(feedData,11)
	.q:level="forbid"	
	.s auditMsg = oeordItemDr_"^"_msgID_"^"_level_"^"_passStatus
	.i input = "" s input = auditMsg
	.e  s input = input _"$$$"_auditMsg
	
	q:ret'=0 
	s ret= ##Class(web.DHCCKBMonitor).UpdateMonMaster(msgID,passType,prescFlag)
	

	// 调用药房接口,自动审核 医嘱ID^msgID^level^强制审核$$$医嘱ID^msgID^level^强制审核
	s autoRet = ##class(web.DHCCKBInterface).AutoAudit(input,admTye)
		
	i ret=0 tc
	e  tro
			
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2022-04-12
/// Descript: 	获取知识库数据信息并暂存
/// Input：		类型
/// w ##class(web.DHCCKBInterface).GetDataListForCdss("GeneralFromData")
ClassMethod GetDataListForCdss(type As %String, loginInfo As %String = "") As %String
{
	n (type,loginInfo)
	
	q:'$d(^TMP("DHCCKB","web.DHCCKBConfig","SetDataListForCdss",type)) ""
	s dataArr = []
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBConfig","SetDataListForCdss",type,index)) q:(index="")  d
	.s data = $g(^TMP("DHCCKB","web.DHCCKBConfig","SetDataListForCdss",type,index))
	.s dataObj  = {}
	.s dataObj.id = $p(data,"^",1)
	.s dataObj.code = $p(data,"^",2)
	.s dataObj.text = $p(data,"^",3)
	.d dataArr.%Push(dataObj)
	
	w dataArr.%ToJSON()
	
	k TmpArr
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2022-11-24
/// Descript: 	药品模糊检索(医院再用药品)
/// Input：		药品名称,医院id
/// w ##class(web.DHCCKBInterface).SearchDrugList("盐酸胺","110")
ClassMethod SearchDrugList(input As %String, hospId As %String = "") As %String
{
	s resObj = {}
	s resObj.state = 200
    s resObj.msg = "查询成功"
    
    i hospId="" s hospId=2
   	i (input="")||(hospId="") s resObj.msg="查询失败",resObj.state = 403
   	q:(input="")||(hospId="") resObj.%ToJSON()
   	
   	s $ZT = "ErrSearchDrugList"
   	s drugParrefList =$lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")	
	
	s dataArr = []
	f i=1:1:$ll(drugParrefList)  d
	.s parref = $lg(drugParrefList,i)
	.s parrefId = ##class(web.DHCCKBCommon).GetDicIdByCode(parref)
	.s id = ""
	.f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefId,id)) q:id=""  d
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),2)
	..s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)
	..q:(input'="")&&(name'[input) //&&(pinName'[$zcvt(input,"U"))
	..// 暂不支持首拼检索,需要增加字段，存储首拼音
	..q:##class(web.DHCCKBCommon).IsEnabled(id)=0
	..q:0=##class(web.DHCCKBComContrast).IsSysContrast(id,hospId)
	..q:(name="")||(name["停用")||(name["作废")
	..s dataObj = {}
	..s dataObj.id = id
	..s dataObj.code = code
	..s dataObj.name = name	
	..d dataArr.%Push(dataObj)
	..k dataObj
	
	i dataArr.%Size()=0 d
	.s resObj.msg = "没有查询到数据"
	.s resObj.state = 204
	
	s resObj.data = dataArr
	
	q resObj.%ToJSON()
	
ErrSearchDrugList
	s resObj.state = -104
	s resObj.msg = "系统错误"_":"_$ze
	q resObj.%ToJSON()
}

/// Creator: 	qunianpeng
/// CreateDate: 2022-11-24
/// Descript: 	药品明细数据查询
/// Input：		药品id,药品名称
/// w ##class(web.DHCCKBInterface).QueryDrugInstrDetail("","注射用青霉素钠80万U(华北制药股份有限公司)")
ClassMethod QueryDrugInstrDetail(drugId As %String, drugName As %String = "") As %String
{
	n (drugId,drugName)
	
	s resObj= {}
	s resObj.state = 200
    s resObj.msg = "查询成功"
    
   	i (drugId="")&&(drugName="") s resObj.msg="查询失败",resObj.state = 403
   	q:(drugId="")&&(drugName="") resObj.%ToJSON()
   	
   	s $ZT = "ErrQueryDrugInstrDetail"
	s drugParrefList =$lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")	
	i drugId="" d	
	.f i=1:1:$ll(drugParrefList) q:drugId'=""  d
	..s parref = $lg(drugParrefList,i)
	..s parrefId = ##class(web.DHCCKBCommon).GetDicIdByCode(parref)
	..s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugName,parrefId)
	..
	q:+drugId=0 resObj.%ToJSON()
	
	// 通过药品id获取本药药品id
	s orginDrugId = ##Class(web.DHCCKBCommon).GetComOriginDrug(drugId) // 返回值：若有本源药品id则返回本源id,否则返回自身id. 有本源则展示本药药品的说明书,若没有则展示自己的说明书
	// 通过 知识浏览附加属性, 获取到只需要在浏览器中展示的属性,按照序号排序
	k propArr	
	s instruPorpList = ##class(web.DHCCKBPdssIndex).GetInstruPropList(.propArr,orginDrugId)		
	s orginPropList= $lb("SpecificationProp","ApprovalNumberProp")
		
	s instruObj = {},titleObj = {},dataObj={}
	s index = ""
	f  s index = $o(propArr(index))  q:index=""  d
	.s str = $g(propArr(index))
	.s propId = $p(str,"^",1)
	.s propCode = $p(str,"^",2)
	.s propDesc = $p(str,"^",3)
	.q:(+propId=0)||(propDesc="")
	.s value=""
	.i $lf(orginPropList,propCode)'=0 s value = ##class(web.DHCCKBEditProp).QueryAttrValue(drugId,+propId)	// 药品的规格、批准文号按照自己的展示
	.e  s value = ##class(web.DHCCKBEditProp).QueryAttrValue(orginDrugId,+propId)
	.q:value=""
	.d instruObj.%Set(propCode,value)
	.d titleObj.%Set(propCode,propDesc)
	
	d dataObj.%Set("instru",instruObj)
	d dataObj.%Set("title",titleObj)	

	s resObj.data = dataObj
	q resObj.%ToJSON()
	
ErrQueryDrugInstrDetail

	s resObj.state = -104
	s resObj.msg = "系统错误"_":"_$ze
	q resObj.%ToJSON()
}

}
