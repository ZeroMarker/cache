Import sqluser

Class web.DHCCKBPrescTest Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:导入处方数目
/// 批量测试需要传入和161上相同的医院描述
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","C:\Users\Administrator\Desktop\新知识库\哈医大\CKB_Excel20200730(201909datanew).txt") 
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\prescdata.txt","Y","dhcc^主管药师^呼吸内科门诊^安全用药智能决策(开发)^德令哈医共体")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\expexcelopmed.txt","Y","dhcc^主管药师^呼吸内科门诊^安全用药智能决策(开发)^德令哈医共体")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\WuhanPresc05.txt","Y")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\CFdata\jzyxkmz0622.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^四川宜宾三院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\CKBExcel20220307.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^珠海市人民医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\byeycf06.txt","Y","dhcc^主管药师^呼吸内科门诊^安全用药智能决策(开发)^包医二附院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\WuHanPrescDeau.txt","Y")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","C:\Users\Administrator\Desktop\新知识库\CKB_ExcelOrder(all_盐城去除空剂型_去饮片).txt","Y","qnp^主管药师^药学部^安全用药智能决策(开发)^江苏盐城中医")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\增城中医处方.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^广州增城中医New")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\知识图谱\测试数据\赛罕二院处方数据2021010120210415.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^内蒙赛罕二院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\知识图谱\测试数据\CKB_Excel20210608(20210602-20210616data).txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^包医二附院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\包医二附院处方数据2021060220210616.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^包医二附院第二批")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\CKB_Excel20200730(20200801-20200815data).txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^榆林市第二医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\知识图谱\测试数据\CKB_Excel20210716(20210601-20210615data).txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^南京医科大学第四附属医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\临时数据\CKB_Excel20200730(201907-202007data).txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^泰安市中心医院高新院区")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\tests.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^临夏市民族医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\CKB_Excel皖南二院(20211115_1130data).txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^皖南医学院第二附属医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\榆林二院10月份历史处方.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^榆林市第二医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\CKB_Excel00120221108.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^甘肃合水第一人民")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\临时数据\吉林国文处方数据.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^吉林国文医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\临时数据\滇东北历史处方test163.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^云南省滇东北区域中心医院")
ClassMethod ImportOrder(autoFlag, filepath As %String, exportFlag = "Y", userInfo = "") As %String
{

	N (autoFlag,filepath,exportFlag,userInfo)
	q:userInfo="" "用户信息不能为空"	// 2021/12/02
	s hosp = $p(userInfo,"^",5) 
	s hsopId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	q:hsopId="" "请使用系统中已经对照的真实医院的名称,否则会导致计算不准确！"
	
	if autoFlag="Y" d
	.//d ##Class(web.DHCCKBPrescTest).AutoSetCommonRule()
	.//d ##Class(web.DHCCKBPrescTest).AutoSetBaseRule()
	
	// 导入数据 pid=(17729381(4w),17729382(60w),18576418(4w),18580088(20w)) 19008068,19009555(20w)
 	// last 20614843
	//s lastPid=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",""),-1)
	//i lastPid'="" k ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",lastPid)
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	s allergy=""
	s title=""
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.s impDataList=$tr(impDataList,$c(10),"")
	.s impDataList=$tr(impDataList,$c(10,13),"")
	.s impDataList=$tr(impDataList,$c(13),"")
	.//s impDataList=$tr(impDataList," ","")
	.s impDataList=$tr(impDataList,"""","")
	.
	.i hCount=1 s title=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","title")=title
	.s Err=""
	.q:hCount=1
	.s valueObj=..GetOrderObj(title,impDataList)
	.s prescNo=valueObj.%Get("prescNo")
	.s drugName=valueObj.%Get("drug")
	.;b ;err
	.d ..SaveAllDiag(valueObj.%Get("diag"))				// 记录诊断
	.d ..TmpSaveDrug(drugName)							// 记录药品(需要清除掉之前的记录)
	.
	.q:prescNo=""
	.q:drugName=""
	.s ^TMP("DHCCKB","web.DHCCKBPrescTestSave","ImportOrder",pid,prescNo,drugName,hCount)=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,hCount)=impDataList
	
	c filepath 

	//q pid
	w ..CheckAllItem(pid,title,exportFlag,userInfo)
	k ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid)
	quit ""
}

/// w ##class(web.DHCCKBPrescTest).CheckAllItem(40297316,"","Y")
ClassMethod CheckAllItem(pid, title = "", exportFlag, userInfo)
{
	 n (pid,title,exportFlag,userInfo)

	s:title="" title=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","title"))
	;B  //11
	// 处理数据,并调用审查类,输出excel
	s count=0
	s prescNo=""
	f  s prescNo=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo))	q:prescNo=""  d
	.s prescCount=0
	.k TmpPrescArr
	.s drugName="",paramObj={},allergy=""
	.f  s drugName=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName))  q:drugName=""  d
	..s index=""
	..f  s index=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,index))  q:index=""  d
	...s count=count+1
	...s TmpPrescArr(prescNo,count)=drugName_"^"_index	// 记录一组处方的药,用于标记一组处方的结果
	...s prescCount=prescCount+1
	...s valueStr=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,index))
	...s aloneAllergy=$p(valueStr,"^",5)
	...s aloneAllergy=$tr(aloneAllergy,";",",")
	...s aloneAllergy=$tr(aloneAllergy,"；",",")
	...i aloneAllergy'=""  d
	....s allergy=$case(allergy'="",1:allergy_","_aloneAllergy,:aloneAllergy)
	...//s drugNameID=##Class(web.DHCCKBPassNew).GetComDicIdNew(drugName,"Drug")
	...//s isContrast=..IsContrast(drugName)	 // 是否对照
	...//s isHaveRuleFlag=$case(##class(web.DHCCKBCommon).IsExistRule(drugNameID),1:"Y",:"N")
	...//s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,index)=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,index))_"^"_isContrast_"^"_isHaveRuleFlag	
	...s paramObj=..GetParamObj(pid,prescNo,title,valueStr,paramObj,allergy,index)
	.
	.k ^TMP("DHCCKB","web.DHCCKBPrescTest","GetParamObj",pid,prescNo)
	.q:(paramObj="")||(paramObj={})||(paramObj.%ToJSON()="{}")
	.d paramObj.%Set("Action","CheckRule")
	.d paramObj.%Set("DocUser",$p(userInfo,"^",1))
	.d paramObj.%Set("Profess",$p(userInfo,"^",2))
	.d paramObj.%Set("PatLoc",$p(userInfo,"^",3)) 
	.d paramObj.%Set("Group",$p(userInfo,"^",4))  	
	.d paramObj.%Set("Hospital",$p(userInfo,"^",5))  

	.s startTime=$zts
	.s retStr=""
	.s accFlag = "N" // 不需要授权
	.d ##Class(web.DHCCKBPassNew).IntMakPolPass(paramObj.%ToJSON(),.retStr,accFlag)
	.s endTime=$zts
	.s calcTime=$p(endTime,",",2)-$p(startTime,",",2)	//一个处方的计算时间
	.q:retStr=""
	.//s retObj=##class(%DynamicArray).%FromJSON(retStr).%Get(0)
	.s retObj=##class(%DynamicArray).%FromJSON(retStr)
	.q:retObj.items.%Size()=0	// 没有返回值,则不记录
	.s ProblemList=""
	.d GetRetMsgNew	
	
	k ^TMP("DHCCKB","web.DHCCKBPrescTest","GetParamObj",pid)
	w !
	
	i exportFlag="Y"  d
	.w ##Class(websys.Query).ToExcel("CKB_Excel测试结果"_$zts,"web.DHCCKBPrescTest","ExportOrderMsg",pid)
	.w !
	
	q pid_","_"成功"_","_$h
	
GetRetMsgNew
	set itemsObj=retObj.%Get("items")
	set iterator=itemsObj.%GetIterator()
 while iterator.%GetNext(.key,.val) {
		s msgArr=val.%Get("warns")
		s iterRule=msgArr.%GetIterator()
		s msg=""
		s itmmsg=""	
		while iterRule.%GetNext(.rulekey,.ruleval) {
			
				s itmArr=ruleval.%Get("itms") //{"key":"成分相互作用测试","keyname":"成分相互作用测试","val":"","manLev                el":"warn","manLev":"警示","itms"
				s labelname=ruleval.%Get("keyname")
				s iteritm=itmArr.%GetIterator()					
				s infomsg=""
				while iteritm.%GetNext(.itmkey,.itmval) {
					s infoArr=itmval.%Get("itms") 
					s iterinfo=infoArr.%GetIterator()						
					while(iterinfo.%GetNext(.infokey,.infoval)){
						s warnMsg=infoval.%Get("val")
						s warnMsg=$tr(warnMsg,$c(10),"")
						s warnMsg=$tr(warnMsg,$c(10,13),"")
						s warnMsg=$tr(warnMsg,",","、")
						i infomsg= "" d  s infomsg=warnMsg		
						e  d  s infomsg=infomsg_";"_warnMsg	
					}			 
				}
				i itmmsg= ""  s itmmsg=labelname_":"_infomsg	
				e  s itmmsg=itmmsg_$c(11)_labelname_":"_infomsg	//$c(11)垂直制表符号		
				s itmmsg=$tr(itmmsg,",","、")						
			}
			s msg=itmmsg
			s msg=$tr(msg,",","")
			s checkItm=val.%Get("item")
			//s realCheckItm=..GetConstrast(checkItm)	//走了对照，需要通过知识库的药品名称找到对照的名称，进行数据回写
			//s checkItm=$case(realCheckItm'="",1:realCheckItm,:checkItm)
			s seqno=val.%Get("seqno")
			s tmpCheckStr=checkItm_"^"_seqno
			s $list(ProblemList,*+1)=tmpCheckStr		// 记录有问题的药品			
			i $d(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,checkItm,seqno))  d
			.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,checkItm,seqno)=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,checkItm,seqno))_"^"_prescCount_"^"_calcTime_"^"_"N"_"^"_msg		
		}
	 d SetPresNoFlag
	 q ""
	 
SetPresNoFlag
		s tmpIndex=""
		f  s tmpIndex=$o(TmpPrescArr(prescNo,tmpIndex))	q:tmpIndex=""  d	//=drugName_"^"_index
		.s tmpStr=$g(TmpPrescArr(prescNo,tmpIndex))
		.q:$listfind(ProblemList,tmpStr)'=0
		.s tmpDrugName=$p(tmpStr,"^",1)
		.s tmpSeqNo=$p(tmpStr,"^",2)
		.q:'$d(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,tmpDrugName,tmpSeqNo))
		.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,tmpDrugName,tmpSeqNo)=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,tmpDrugName,tmpSeqNo))_"^"_prescCount_"^"_calcTime_"^"_"N"_"^"_""	
		q ""
}

/// w ##class(web.DHCCKBPrescTest).GetOrderObj()
ClassMethod GetOrderObj(keyStr, valueStr) As %String
{
	n (keyStr,valueStr)

	s orderObj={}
	f i=1:1:$l(keyStr,"^")  d
	.s key=$p(keyStr,"^",i)
	.s value=$p(valueStr,"^",i)
	.s key=..GetKeyObj(key)
	.q:key=""
	.s value=$tr(value,"""","")
	.//i key'="stDate" s value=$tr(value," ","")
	.d orderObj.%Set(key,value)

	q orderObj
}

/// w ##class(web.DHCCKBCommonUtil).test()
ClassMethod GetKeyObj(key) As %String
{
	n (key)
	s keyObj={}

	d keyObj.%Set("处方号","prescNo").%Set("身份识别码","cardID").%Set("就诊号","adm").%Set("年龄","age").%Set("性别","sex")
	d keyObj.%Set("患者过敏信息","allergy").%Set("过敏药物","allergy").%Set("患者过敏信息","allergy").%Set("体重","weight").%Set("身高","height")
	d keyObj.%Set("诊断","diag").%Set("药品种数","drugnum").%Set("处方上药品数量","drugnum").%Set("药品名称","drug")
	d keyObj.%Set("药学名称","drug").%Set("药品剂型","drugForm").%Set("规格","drugSpec").%Set("最小包装","minpack").%Set("发药数量","packNum").%Set("单次剂量","qty")
	d keyObj.%Set("剂量单位","qtyUom").%Set("频次","freq").%Set("服药途径","use").%Set("服药天数","treatNum").%Set("疗程","treatNum")
	d keyObj.%Set("分组号","groupNum").%Set("关联医嘱组号","groupNum").%Set("开方时间","stDate")
	d keyObj.%Set("医嘱类型","orderPriority").%Set("类型","patType")

	q keyObj.%Get(key)
}

/// w ##class(web.DHCCKBPrescTest).GetParamObj()
ClassMethod GetParamObj(pid, prescNo, title, valueStr, paramObj, allergy, index) As %String
{
	n (pid,prescNo,title,valueStr,paramObj,allergy,index)
	
	q:(prescNo="")||(title="")||(valueStr="")||(index="") ""
	s dataObj=..GetOrderObj(title,valueStr)
	d dataObj.%Set("allergy",allergy)

	i $d(^TMP("DHCCKB","web.DHCCKBPrescTest","GetParamObj",pid,prescNo))  d
	.s itemOrderObj={}
	.//d itemOrderObj.%Set("Warn",seqNo).%Set("SeqNo",seqNo).%Set("LinkSeqNo",dataObj.%Get("groupNum")_"."_seqNo).%Set("PhDesc",dataObj.%Get("drug")).%Set("PForm",dataObj.%Get("drugForm"))
	.d itemOrderObj.%Set("Warn",index).%Set("SeqNo",index).%Set("LinkSeqNo",dataObj.%Get("groupNum")).%Set("PhDesc",dataObj.%Get("drug")).%Set("PForm",dataObj.%Get("drugForm"))
	.d itemOrderObj.%Set("DosQty",dataObj.%Get("qty")).%Set("DosUom",dataObj.%Get("qtyUom")).%Set("Instr",dataObj.%Get("use"))
	.d itemOrderObj.%Set("Freq",dataObj.%Get("freq")).%Set("Duration",dataObj.%Get("treatNum")).%Set("Freq",dataObj.%Get("freq"))
	.d itemOrderObj.%Set("id","itemOrder")
	.d itemOrderObj.%Set("OrderPriority",dataObj.%Get("orderPriority"))
	.s itemOrder=paramObj.%Get("itemOrder").%Push(itemOrderObj)
	.d paramObj.%Set("itemOrder",itemOrder)
	e  d
	.s age=dataObj.%Get("age")
	.s age=..changeAge(age)
	.//s age=$zd(($h-(age*365)),3)
	.d paramObj.%Set("PatName",dataObj.%Get("cardID")).%Set("PatSex",dataObj.%Get("sex")).%Set("PatBDay",age).%Set("Weight",dataObj.%Get("weight"))
	.d paramObj.%Set("PatType",dataObj.%Get("patType"))
	.
	.	
	.s itemAygArr=[]	// 过敏药物
	.f i=1:1:$length(dataObj.%Get("allergy"),",") d	
	..s item=$p(dataObj.%Get("allergy"),",",i)
	..q:item=""
	..s itemAygObj={}
	..d itemAygObj.%Set("Warn",i).%Set("Item","").%Set("id","itemAyg").%Set("item",item)
	..d itemAygArr.%Push(itemAygObj)
	.d paramObj.%Set("itemAyg",itemAygArr)	
	.
	.s itemDisArr=[]	// 诊断
	.s itemStr=..ChangeDisStr(dataObj.%Get("diag"))
	.f i=1:1:$length(itemStr,",") d
	..s item=$p(itemStr,",",i)
	..q:item=""
	..s itemDisObj={}	
	..d itemDisObj.%Set("Warn",i).%Set("Item","").%Set("id","itemDis").%Set("item",item)
	..d itemDisArr.%Push(itemDisObj)
	.d paramObj.%Set("itemDis",itemDisArr)	
	.
	.s itemOrderObj={}			// 药物
	.d itemOrderObj.%Set("Warn",index).%Set("SeqNo",index).%Set("LinkSeqNo",dataObj.%Get("groupNum")).%Set("PhDesc",dataObj.%Get("drug")).%Set("PForm",dataObj.%Get("drugForm"))
	.d itemOrderObj.%Set("DosQty",dataObj.%Get("qty")).%Set("DosUom",dataObj.%Get("qtyUom")).%Set("Instr",dataObj.%Get("use"))
	.d itemOrderObj.%Set("Freq",dataObj.%Get("freq")).%Set("Duration",dataObj.%Get("treatNum")).%Set("Freq",dataObj.%Get("freq"))
	.d itemOrderObj.%Set("OrderPriority",dataObj.%Get("orderPriority"))
	.d itemOrderObj.%Set("id","itemOrder")
	.d paramObj.%Set("itemOrder",[].%Push(itemOrderObj))
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","GetParamObj",pid,prescNo)=""
	
	q paramObj
}

/// w ##class(web.DHCCKBPrescTest).GetOrderPid()
ClassMethod GetOrderPid() As %String
{
	s pid=""
	s pid=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid),-1)
	q +pid
}

/// 导出审查后的处方数据
/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportOrderMsg",39545439) 
/// w ##Class(websys.Query).ToExcel("CKB_Excel测试结果65642,45691.181","web.DHCCKBPrescTest","ExportOrderMsg","39545439")
/// Query ExportOrderMsg(pid) As websys.Query(ROWSPEC = "f1:%String:处方号,f2:%String:就诊号,f3:%String:年龄,f4:%String:性别,f5:%String:患者过敏信息,f6:%String:体重,f7:%String:身高,f8:%String:诊断,f9:%String:处方上药品数量,f10:%String:药学名称,f11:%String:药品剂型,f12:%String:规格,f13:%String:最小包装,f14:%String:发药数量,f15:%String:单次剂量,f16:%String:剂量单位,f17:%String:频次,f18:%String:服药途径,f19:%String:疗程,f20:%String:关联医嘱组号,f21:%String:开方时间,f22:%String:是否有规则,f23:%String:东华审核结果,f24:%String:审核原因")
/// Query ExportOrderMsg(pid) As websys.Query(ROWSPEC = "f1:%String:类型,f2:%String:就诊号,f3:%String:年龄,f4:%String:性别,f5:%String:患者过敏信息,f6:%String:体重,f7:%String:身高,f8:%String:诊断,f9:%String:特殊人群,f10:%String:处方号,f11:%String:处方上药品数量,f12:%String:药学名称,f13:%String:药品剂型,f14:%String:规格,f15:%String:最小包装,f16:%String:发药数量,f17:%String:单次剂量,f18:%String:剂量单位,f19:%String:频次,f20:%String:服药途径,f21:%String:疗程,f22:%String:关联医嘱组号,f23:%String:开方时间,f24:%String:医嘱备注,f25:%String:是否对照,f26:%String:是否有规则,f27:%String:审核结果,f28:%String:审核原因")
Query ExportOrderMsg(pid) As websys.Query(ROWSPEC = "f1:%String:类型,f2:%String:就诊号,f3:%String:年龄,f4:%String:性别,f5:%String:患者过敏信息,f6:%String:体重,f7:%String:身高,f8:%String:诊断,f9:%String:特殊人群,f10:%String:处方号,f11:%String:处方上药品数量,f12:%String:药学名称,f13:%String:药品剂型,f14:%String:规格,f15:%String:最小包装,f16:%String:发药数量,f17:%String:单次剂量,f18:%String:剂量单位,f19:%String:频次,f20:%String:服药途径,f21:%String:疗程,f22:%String:关联医嘱组号,f23:%String:开方时间,f24:%String:医嘱备注,f25:%String:医嘱类型,f26:%String:不明列2,f27:%String:不明列3,f28:%String:不明列4,f29:%String:处方医嘱个数,f30:%String:计算时间,f31:%String:审核结果,f32:%String:审核原因")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportOrderMsg",18812640) 
/// @param: pid 进程号
ClassMethod ExportOrderMsgExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)
	//S pid=1
	//"f1:%String:处方号,f2:%String:身份识别码,f3:%String:年龄,f4:%String:性别,f5:%String:过敏药物,f6:%String:体重,f7:%String:诊断,f8:%String:药品种类,f9:%String:药学名称,:f10:%String:药品剂型,f11::%String:规则,f12:%String:最小包装,f13:%String:发药数量,f14:%String:单次剂量,f15:%String:剂量单位,,f16:%String:频次,f17:%String:服药途径,f18:%String:服药天数,f19:%String:分组号,f20:%String:开方时间,f21:%String:药品审核结果,f22:%String:审核原因"
	// f1:%String:类型,f2:%String,就诊号,f3:%String:年龄,f4:%String:性别,f5:%String:患者过敏信息,f6:%String:体重,f7:%String:身高,f8:%String:诊断,f9:%String:特殊人群,f10:%String:处方号,f11:%String:处方上药品数量,f12:%String:药学名称,f13:%String:药品剂型,f14:%String:规格,f15:%String:最小包装,f16:%String:发药数量,f17:%String:单次剂量,f18:%String:剂量单位,f19:%String:频次,f20:%String:服药途径,f21:%String:疗程,f22:%String:关联医嘱组号,f23:%String:开方时间,f24:%String:医嘱备注


	Set repid=$I(^CacheTemp)	
	Set ind=1
	//s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",1,1,1)="11^2"_$c(11)_"22^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18^19^20^21^22"
	set prescNo=""	
	for  set prescNo=$order(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo)) quit:prescNo=""  do
	.set item=""	
	.for  set item=$order(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,item)) quit:item=""  do
	..set index=""
	..for  set index=$order(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,item,index)) quit:index=""  do
	...set listData=$get(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,item,index))
	...set itemID=##class(web.DHCCKBCommon).GetDicIdByDesc(item)
	...//set isHaveRuleFlag=$case(##class(web.DHCCKBCommon).IsExistRule(itemID),1:"Y",:"N")
	...set listData=$tr(listData,",","、")	// 逗号会影响list
	...//b:(ind=348)||(ind=349)||(ind=350)||(ind=351)||(ind=352)
	...set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	...set ind=ind+1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	用法用量自动生成普适规则
/// Creator:		QuNianpeng
/// CreateDate:		2020-03-06
/// Input:			
/// return:			
/// other:			
/// 	生成规则：1.不包含前提条件,且没有同时出现四个普适项目（普适项目：给药途径、每日用药量、用药频率、单次用药量）
/// 			  2. 生成规则时，遇到没有值的，项目不需要生成改项目值
/// 生成时的规则注意事项：	1. 备注中进行标注：系统生成规则
/// 		  				 	2. 提示依据进行标注：系统生成规则
/// 		   					3.对于匹配到的四个项目的普适规则，记录下来药品，规则序号
/// w ##Class(web.DHCCKBPrescTest).AutoSetCommonRule()
ClassMethod AutoSetCommonRule(queryDrugId As %String = "") As %String
{
	n (queryDrugId)
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()
	q:(+drugData=0)&(+chineseDrugData=0) ""
	s drugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()
	s drugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()
	s dayMax=##class(web.DHCCKBCommon).GetDayDoseProp()
	//s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")
	s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")
	s loginInfo="11874^9^1^290^2"
	s userId=11874
	set $ZT="ERROR" // 设置一个异常
	s err=0
	Ts
	
	//s comlist=$lb(drugPreMet,drugFreq,onceDose,dayMax)	// 普适项目
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:drugId'=89419
	.q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.k PreMetList,FreqList,OnceDoseList,DayMaxList
	.s (PreMetList,FreqList,OnceDoseList,DayMaxList)=""
	.s isExistFlag=0,count=0	// 药品是否存在普适规则
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")||(isExistFlag=1)  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法用量"
	..q:..IsSetCommonRule(drugId)=1 // 判断药品是否已经生成过规则
	..// 判断规则是否是普适规则 1 是 0 不是
	..s flag=..IsCommonRule(drugId,rule,.PreMetList,.FreqList,.OnceDoseList,.DayMaxList)
	..i flag=1 s isExistFlag=1,count=count+1	// 存在普适规则
	..
	.
	.i count=0	d	// 药品不存在普适规则
	..// 生成规则
	..s ruleObj=..SetRuleObj(PreMetList, FreqList, OnceDoseList,DayMaxList)
	..q:ruleObj=""
	..k root
	..q:ruleObj.%Get("if").%Size()=0
	..s root={}
	..d root.%Set("rule",ruleObj)
	..s status=""	// 保存
	..s ret=##class(web.DHCCKBRuleSave).save(0,"Release",root.%ToJSON(),userId,drugId_"^"_usageId,loginInfo)	// save方法中,root是json字符串,不成直接传json对象
	..i ret<0 s err=1
	..i ret<0 tro
	..q:+ret<0
	..// 发布
	..//s ret=##class(web.DHCCKBRuleSave).save(ret,"Release",root.%ToJSON(),userId,drugId_"^"_usageId)	// save方法中,root是json字符串,不成直接传json对象
	..//i ret<0 s err=1
	..//i ret<0 tro
	..s ^TMP("DHCCKB","web.DHCCKBPrescTest","AutoSetCommonRule",drugId,ret)=""
	
	i err=1 tro
	e  TCOMMIT
	
	q "完成"
	
ERROR
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	k ^TMP("DHCCKB","web.DHCCKBPrescTest","AutoSetCommonRule")
	Quit ErrorMsg		             //返回错误信息
}

///  Descript:  当前规则是否是普适规则,并记录下来普适项目的值 和 无前提条件的规则
///  Output:    0 - 不是、1-是
///  w ##Class(web.DHCCKBPassNew).TakPreConditions("1831",TmpPreConsArr)
ClassMethod IsCommonRule(DrugId, RulID As %String, PreMetList, FreqList, OnceDoseList, DayMaxList) As %String
{
	n (DrugId,RulID,PreMetList,FreqList,OnceDoseList,DayMaxList)
	
	s DrugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()
	s DrugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()
	s OnceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()
	s DayMax=##class(web.DHCCKBCommon).GetDayDoseProp()
	s ComList=$lb(DrugPreMet,DrugFreq,OnceDose,DayMax) 
	
	s Libary=0
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	//判断规则中是否有目录
	s Dic="" f  s Dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",RulID,Dic)) q:Dic=""  d
	.s DicParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(Dic)),4)
	.s:DicParef=DrugLibary Libary=Dic	//目录

	q:Libary="" 0
	s PreList=""	// 记录所有的前提条件
	s Count=0
	s Parent=""
	f  s Parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"if",Parent))  q:Parent=""   d  
	.s Node=""
	.f  s Node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,"if",Parent,Node))  q:Node=""   d  
	..q:Node=0
	..s RulDataID=""
	..f  s RulDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",Node,RulDataID))  q:RulDataID=""   d
	...q:RulDataID=0
	...s LeftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(RulDataID)),4)	// 实体/属性（前提条件的项目代码）
	...i LeftDic=DrugFreq d		// 记录普适项目的值
	....s Value=..GetValue(RulDataID)
	....s:(Value'="")&($listfind(FreqList,Value)=0) $list(FreqList,$listlength(FreqList)+1)=Value
	...e  i LeftDic=DrugPreMet d
	....s Value=..GetValue(RulDataID)
	....s:(Value'="")&($listfind(PreMetList,Value)=0) $list(PreMetList,$listlength(PreMetList)+1)=Value
	...e  i LeftDic=OnceDose  d
	....s Value=..GetValue(RulDataID)
	....s:(Value'="")&($listfind(OnceDoseList,Value)=0) $list(OnceDoseList,$listlength(OnceDoseList)+1)=Value
	...e  i LeftDic=DayMax	d
	....s Value=..GetValue(RulDataID)
	....s:(Value'="")&($listfind(DayMaxList,Value)=0) $list(DayMaxList,$listlength(DayMaxList)+1)=Value
	...
	...s flag=..IsPreCondtion(Libary,LeftDic)	// 判断项目是不是前提条件
	...i flag=1 d
	....s Count=Count+1	// 一条规则中有多个分支项目,只要出现过前提项目,则计数器加一
	...i (flag=0)&(Count=0) d 	// 记录不是前提条件的项目
	....i $listfind(PreList,LeftDic)=0 s $list(PreList,$listlength(PreList)+1)=LeftDic
	
	s Equal=##class(web.DHCCKBCommonUtil).CompareEqualList(PreList,ComList)
		
	s Ret=0
	i (Count=0)	d
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","TakPreConditions",DrugId,RulID)=""	// 记录没有前提条件的项目
	.i Equal=1 s Ret=1	// 改规则中无前提条件,且是普适规则
	
	q Ret
}

/// 项目是否是前提条件
/// 1 是   0 不是
ClassMethod IsPreCondtion(Libary, LeftDic)
{
	n (Libary,LeftDic)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Libary,LeftDic)) 0
	
	s ret=0
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Libary,LeftDic,LinkID)) q:LinkID=""  d	// 前提条件好像存储的不对 03/05
	.s Attr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:+Attr=0
	.q:Attr'=##class(web.DHCCKBCommon).GetPreconditions()	//前提条件
	.q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)'="Y"		// 用法用量 病症 前提条件  Y
	.s ret=1
	
	q ret
}

/// 返回值: 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位/// 
ClassMethod GetValue(ID)
{
	n (ID)
	s RetStr=""
	q:'$d(^CT.CKB.PDSS.RuleDataD(+ID)) ""
	s Op=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),7)
	s RightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),10)	
	if RightType="Constant"		d 	// 数据集	 
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)
	.s RetStr=RightType_$c(1)_Op_$c(1)_Value
	else  if RightType="Input"	d 	// 输入值	
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	.s RetStr=RightType_$c(1)_Op_$c(1)_Value
	else  if RightType="InputUom" d // 带单位的输入值    
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	.s ValueUom=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)
	.s RetStr=RightType_$c(1)_Op_$c(1)_Value_$c(1)_""_$c(1)_ValueUom
	else  if RightType="InputLimit"	d // 区间,带单位
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	.s ValueMax=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)
	.s ValueUom=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)
	.s RetStr=RightType_$c(1)_Op_$c(1)_Value_$c(1)_ValueMax_$c(1)_ValueUom
	
	q RetStr
}

/// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
/// s preMetList=$lb("Constant"_$c(1)_"Equals"_3925_$c(1)_$c(1))
/// w ##Class(web.DHCCKBPrescTest).SetRuleObj("","","","","")
ClassMethod SetRuleObj(preMetList, freqList, onceDoseList, dayMaxList)
{
	n (preMetList, freqList, onceDoseList, dayMaxList)
	q:(preMetList="")&(freqList="")&(onceDoseList="")&(dayMaxList="") ""
	//s freqList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3925_$c(1)_$c(1),"Constant"_$c(1)_"Equals"_$C(1)_3926_$c(1)_$c(1))
	//s freqList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3925_$c(1)_$c(1))
	//s preMetList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3922_$c(1)_$c(1),"Constant"_$c(1)_"Equals"_$C(1)_3927_$c(1)_$c(1))
	//s preMetList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3922_$c(1)_$c(1))
	//s onceDoseList=$lb("InputLimit"_$c(1)_"Equals"_$C(1)_1_$c(1)_2_$c(1)_3924)
	s ruleObj={}
	d ruleObj.%Set("_name","普适规则")
	d ruleObj.%Set("remark","系统生成")
	d ruleObj.%Set("then","")
	// else 
	s outProp=##class(web.DHCCKBCommon).GetDicIdByCode("OutPrint")
	s sourceMsg=##class(web.DHCCKBCommon).GetDicIdByCode("SourceMsg")
	s valueObj={}
	d valueObj.%Set("_ruleData","0").%Set("_content","系统生成").%Set("_type","Input")
	s assign={}
	d assign.%Set("_varCategory",$case(+outProp'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(outProp)),3),:"")).%Set("_ruleData","0").%Set("_varCategoryId",outProp).%Set("_var",sourceMsg)
	d assign.%Set("_varLabel",$case(+sourceMsg'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(sourceMsg)),3),:"")).%Set("_datatype","String").%Set("_type","variable")
	d assign.%Set("value",valueObj)
	s elseObj={}.%Set("var-assign",assign)
	d ruleObj.%Set("else",elseObj)
	
	//if 
	s drugProp=##class(web.DHCCKBCommon).GetDicIdByCode("Drug")
	s atomArr=[]
	s orArr=[]
	s count=0
	// 给药途径
	s ptr=0	// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	s drugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()
	s premetAtomArr=[]
	if ($listlength(preMetList)>1) {
		d ..SetAtomArr(.premetAtomArr,preMetList,drugProp,drugPreMet)	
		d orArr.%Push({}.%Set("atom",premetAtomArr))
		
	}elseif ($listlength(preMetList)=1){
		d ..SetAtomArr(.atomArr,preMetList,drugProp,drugPreMet)
	}
	
	// 用药频率
	s drugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()
	s freqAtomArr=[]
	if ($listlength(freqList)>1) {
		d ..SetAtomArr(.freqAtomArr,freqList,drugProp,drugFreq)
		d orArr.%Push({}.%Set("atom",freqAtomArr))

	}elseif ($listlength(freqList)=1){
		d ..SetAtomArr(.atomArr,freqList,drugProp,drugFreq)	
	}
	
	// 单次剂量
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()
	s onceAtomArr=[]
	if ($listlength(onceDoseList)>1) {
		d ..SetAtomArr(.onceAtomArr,onceDoseList,drugProp,onceDose)
		d orArr.%Push({}.%Set("atom",onceAtomArr))

	}elseif ($listlength(onceDoseList)=1){
		d ..SetAtomArr(.atomArr,onceDoseList,drugProp,onceDose)
	}
	
	// 每日最大量
	s dayMax=##class(web.DHCCKBCommon).GetDayDoseProp()
	s dayAtomArr=[]
	if ($listlength(dayMaxList)>1) {
		d ..SetAtomArr(.dayAtomArr,dayMaxList,drugProp,dayMax)
		d orArr.%Push({}.%Set("atom",dayAtomArr))

	}elseif ($listlength(dayMaxList)=1){
		d ..SetAtomArr(.atomArr,dayMaxList,drugProp,dayMax)
	}
	
	
	s ifObj={}
	if (atomArr.%Size()'=0){
		s andObj={}
		if (atomArr.%Size()=1){
			d andObj.%Set("atom",atomArr.%Get(0))				
		}
		else{			
			d andObj.%Set("atom",atomArr)		
		}		
		if (orArr.%Size()=1){		
			d andObj.%Set("or",orArr.%Get(0))
		}elseif(orArr.%Size()>1){
			d andObj.%Set("or",orArr)
		}			
		d ifObj.%Set("and",andObj)		
	}else{	
		if (orArr.%Size()=1){
			d ifObj.%Set("or",orArr.%Get(0))			
		}elseif (orArr.%Size()>1){
			s andObj={}
			d andObj.%Set("or",orArr)
			d ifObj.%Set("and",andObj)				
		}
	
	}
	
	if ifObj.%Size()'=0 d ruleObj.%Set("if",ifObj)

	
	q ruleObj
}

ClassMethod SetAtomArr(atomArr, dataList, left, leftValue)
{
	n (atomArr,dataList,left,leftValue)

	s ptr=0	// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	while $LISTNEXT(dataList,ptr,val){
		k atomObj
		s atomObj={}
		s type=$p(val,$c(1),1)
		s op=$p(val,$c(1),2)
		s result=$p(val,$c(1),3)
		k leftObj
		s leftObj={}
		d leftObj.%Set("_varCategory","药品").%Set("_ruleData","0").%Set("_varCategoryId",left).%Set("_type","variable")
		d leftObj.%Set("_varLabel",$case(leftValue'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3),:"")).%Set("_var",leftValue).%Set("_datatype","String")
		
		k valueObj
		s valueObj={}
		if (type="Constant"){	// 字典		
			s dicName=$case(result'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(result)),3),:"")
			d valueObj.%Set("_ruleData","0").%Set("_const-category",result).%Set("_const",result)
			d valueObj.%Set("_const-label",dicName).%Set("_type",type)		

		}elseif (type="Input"){			
			d valueObj.%Set("_ruleData","0").%Set("_content",result).%Set("_type",type)
		}elseif (type="InputLimit"){
			s limit=$p(val,$c(1),4)
			s uom=$p(val,$c(1),5)
			d valueObj.%Set("_ruleData","0").%Set("_content",result).%Set("_uom",uom)
			d valueObj.%Set("_limit",limit).%Set("_type",type)	
		}elseif (type="InputUom"){
			s uom=$p(val,$c(1),5)
			d valueObj.%Set("_ruleData","0").%Set("_content",result).%Set("_uom",uom)
			d valueObj.%Set("_type",type)
		}
		d atomObj.%Set("left",leftObj)
		d atomObj.%Set("value",valueObj)
		d atomObj.%Set("_op",op)
		if (atomObj.%Size()'=0)	d atomArr.%Push(atomObj)
	}
}

/// 导出系统生成的普适规则
Query ExportComRule() As websys.Query(ROWSPEC = "f1:%String:药品数量,f2:%String:规则数量")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportComRule") 
/// @param: pid 进程号
ClassMethod ExportComRuleExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s drugCount=0,ruleCount=0
	s drug=""
	f  s drug=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","AutoSetCommonRule",drug)) q:drug=""  d
	.s drugCount=drugCount+1
	.s rule=""
	.f  s rule=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","AutoSetCommonRule",drug,rule)) q:rule=""  d
	..s ruleCount=ruleCount+1
	
	set ^CacheTemp(repid,ind)=$lb(drugCount,ruleCount)
	set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 导出审查后的处方数据
Query ExportDrugCat() As websys.Query(ROWSPEC = "desc:%String,status:%String,time:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportDrugCat") 
/// @param: pid 进程号
ClassMethod ExportDrugCatExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	//S pid=1
	//desc_"^"_status_"^"_time

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k DataArry
	s id="" 
	for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",106,id)) q:id=""  d
	.s DataArry(id)=id
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(id,.DataArry)
	b  //11
	s index="" 
	for  s index=$o(DataArry(index)) q:(index="")  d
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(index)),3)
	.s status="",time=""
	.i $d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",index,"stop"))  d
	..s logid=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",index,"stop",""))
	..s status="停用" 
	..s date=$lg(^CKB.PDSS.DicLogD(logid),6)
	..s:date'="" date=$zd(date,3)
	..s time=$lg(^CKB.PDSS.DicLogD(logid),7)
	..s:time'="" time=$zt(time,1)
	..s time=date_" "_time
	.s listData=desc_"^"_status_"^"_time
	.set ^CacheTemp(repid,ind)=$lb(desc,status,time)
	.set ind=ind+1
	k DataArry
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QuerySubItm(Parref, DataArry)
{
	n (Parref, DataArry)
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
   	.s DataArry(SubId)=SubId
   	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,.DataArry)
}

/// Description:	药品是否已经生成过普适规则
/// Creator:		QuNianpeng
/// CreateDate:		2020-03-06
/// Input:			药品id
/// return:			1 是 0 否
/// other:			 w ##Class(web.DHCCKBPrescTest).IsSetCommonRule(171)
ClassMethod IsSetCommonRule(DicId, ChildFlag = 0)
{
	n (DicId,ChildFlag)
	
	s Code="ComDosage"
	s ComDosage=##class(web.DHCCKBCommon).GetDicIdByCode(Code)
	s ExistFlag=0
	s ManRuleFlag=0
	
	s RuleDic=""
	f  s RuleDic=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RuleDic))  q:(RuleDic="")||(ExistFlag=1)  d
	.s RuleID=$lg($g(^CT.CKB.PDSS.RuleDicD(RuleDic)),2)	
	.s ReMark = $lg($g(^CT.CKB.PDSS.RuleD(+RuleID)),2)
	.s ReName = $lg($g(^CT.CKB.PDSS.RuleD(+RuleID)),3)
	.//((ReMark["儿童")||(ReName["儿童"))	// // 过滤非成人的兜底规则
	.//i ((ReMark'["儿童")&&(ReName'["儿童")) s ManRuleFlag=1
	.//i ($lg($g(^CT.CKB.PDSS.RuleD(RuleID)),2)="系统生成")||($lg($g(^CT.CKB.PDSS.RuleD(RuleID)),3)="普适规则") s ManRuleFlag=1
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleID,ComDosage)) d
	..i ((ReMark'["儿童")&&(ReName'["儿童")) s ManRuleFlag=1
	..i ((ReMark["儿童")||(ReName["儿童")) s ManRuleFlag=0
	..i (ManRuleFlag=1)&(ChildFlag=0) s ExistFlag=1
	..i (ManRuleFlag=0)&(ChildFlag=1) s ExistFlag=1
	.//i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleID,ComDosage))&&(ManRuleFlag=1)  s ExistFlag=1
	.q:ExistFlag=1
	.s ID=""
	.f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Link",ComDosage,ID)) q:(ID="")||(ExistFlag=1)  d
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleID,ID))&&(ManRuleFlag=1) s ExistFlag=1
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",RuleID,ID))&&(ManRuleFlag=0)&&(ChildFlag=1) s ExistFlag=1
	..q:ExistFlag=1
	
	q ExistFlag
}

/// Description: 统一诊断字符串中的分隔符
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-13
/// Input:		 诊断串
/// w ##class(web.DHCCKBPrescTest).ChangeDisStr("矮小症")
ClassMethod ChangeDisStr(disStr) As %String
{
	n (disStr)
	
	s disStr=$tr(disStr,"；",",")
	s disStr=$tr(disStr,";",",")
	
	q:disStr'["." disStr
	
	s retStr=""
	f i=1:1:$length(disStr,",")  d	//1.矮小症；2.性早熟
	.s tmpStr=$p(disStr,",",i)
	.i tmpStr["." s realStr=$p(tmpStr,".",2)
	.e  s realStr=tmpStr
	.i retStr="" s retStr=realStr
	.e  s retStr=retStr_","_realStr	
	
	q retStr
}

/// Description: 判断药品是否对照
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-10
/// Input:		 药品名称
/// w ##class(web.DHCCKBPrescTest).CheckContrast(drugName)
ClassMethod CheckContrast(drugName) As %String
{
}

/// Description: 保存处方中的诊断
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-10
/// Input:		 诊断
/// w ##class(web.DHCCKBPrescTest).CheckContrast(drugName)
ClassMethod SaveAllDiag(diagStr) As %String
{
	n (diagStr)
	
	s diagStr=..ChangeDisStr(diagStr)
	
	f i=1:1:$length(diagStr,",")  d
	.s diag=$p(diagStr,",",i)
	.q:diag=""
	.s ^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","diag",diag)=""
	
	q ""
}

/// Description: 判断药品是否对照
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-10
/// Input:		 药品名称
/// w ##class(web.DHCCKBPrescTest).IsContrast("胰岛素(诺和锐30特充)3ml300IU")
ClassMethod IsContrast(HisItmCode) As %String
{
	n (HisItmCode)
	
	Q:$d(^CKB.PDSS.ComContrastI("HisCode",HisItmCode))||($d(^CKB.PDSS.ComContrastI("HisDesc",HisItmCode))) "Y"  //若无对照关系，先返回code，以便在线演示方便
	q:$d(^CKB.PDSS.ComContrastI("HisCode",$zcvt(HisItmCode,"U")))||($d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"U")))) "Y" 
	//q:$d(^CKB.PDSS.ComContrastI("HisCode",$zcvt(HisItmCode,"L")))||($d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"L")))) "Y"
	q "N"
}

/// Description:使用知识库代码，通过对照获取his对应的代码
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-10
/// Input:		 药品名称
/// w ##class(web.DHCCKBPrescTest).GetConstrast("匹伐他汀钙片2mg(KowaCompany,Ltd,NagoyaFactory(日本))")
/// w ##class(web.DHCCKBPrescTest).GetConstrast("匹伐他汀钙片2MG(KOWACOMPANY,LTD,NAGOYAFACTORY(日本))")
ClassMethod GetConstrast(LibItmDesc) As %String
{
	n (LibItmDesc)

	//q:('$d(^CKB.PDSS.ComContrastI("LibDesc",LibItmDesc)))&('$d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"))))&('$d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"L")))) ""
	//q:$d(^CKB.PDSS.ComContrastI("LibDesc",LibItmDesc)) $o(^CKB.PDSS.ComContrastI("LibDesc",LibItmDesc,""))
	//q:$d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"))) $o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"),""))
	//q:$d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"L"))) $o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"L"),""))
	q:'$d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"))) ""
	s ExistFlag=0
	s HisDesc="",MarkConstID=""
	f  s HisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"),HisDesc))  q:(HisDesc="")||(ExistFlag=1)  d
	.s ConstID=""
	.f  s ConstID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(LibItmDesc,"U"),HisDesc,ConstID))  q:(ConstID="")||(ExistFlag=1)  d
	..s MarkConstID=ConstID
	..s ExistFlag=1
	
	q $lg(^CKB.PDSS.ComContrastD(+MarkConstID),5)
}

/// Description: 使用his代码，通过对照获取his对应的id
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-10
/// Input:		 药品名称
/// w ##class(web.DHCCKBPrescTest).GetLibIDByConstrast("胰岛素(诺和锐30特充)3ml300IU")
ClassMethod GetLibIDByConstrast(HisItmCode) As %String
{
		n (HisItmCode)
	
	s LibCode="",constID=""
	//i $d(^CKB.PDSS.ComContrastI("HisDesc",HisItmCode))  d
	//.s constID=$o(^CKB.PDSS.ComContrastI("HisDesc",HisItmCode,""))
	
	i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"U"))) d
	.s constID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"U"),""))
	
	//i $d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"L"))) d
	//.s constID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(HisItmCode,"L"),""))
	
	s LibCode =$lg(^CKB.PDSS.ComContrastD(+constID),3)
	q:LibCode="" ""
	
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()
	s chineseDrugDatatID=##class(web.DHCCKBCommon).GetChineseDrugData()
	s libID="",tmpLibID="",flag=0
	f  s tmpLibID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(LibCode),tmpLibID))  q:(tmpLibID="")||(flag=1)  d
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpLibID)),4)
	.q:(parref'=drugDataID)&(parref'=chineseDrugDatatID)
	.s libID=tmpLibID
	.s flag=1	
		
	q libID
}

/// Description: 年龄转日期
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-14
/// Input:		 年龄
/// w ##class(web.DHCCKBPrescTest).changeAge("7岁6个月")
ClassMethod changeAge(ageStr) As %String
{
	n (ageStr)
	s year="",curstr=""
	i ageStr["年" d
	.s year = +$p(ageStr,"年",1)
	.s curstr=$p(ageStr,"年",2)
	i ageStr["岁" d
	.s year = +$p(ageStr,"岁",1)
	.s curstr=$p(ageStr,"岁",2)

	s month = +$p(curstr,"月",1)
	s monCurstr=$p(curstr,"月",2)
	
	s day=""
	i monCurstr["日" d
	.s day=+$p(monCurstr,"日",1)
	i monCurstr["天" d
	.s day=+$p(monCurstr,"天",1)

	s age=year*365+(month*30)+day
	
	s age=$zd($h-age,3)
	q age
}

/// Description: 匹配诊断 可以覆盖多少
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-14
/// Input:		 年龄
/// w ##class(web.DHCCKBPrescTest).MatchDiag()
ClassMethod MatchDiag(TmpArr) As %String
{
	n (TmpArr)
	s diag=""
	f  s diag=$o(^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","diag",diag))  q:diag=""  d
	.d ..CheckDiag(diag,.TmpArr)
	
	q ""
}

/// Description: 匹配诊断 
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-14
/// Input:		 诊断
/// w ##class(web.DHCCKBPrescTest).CheckDiag("呼吸道感染",TmpArr)
ClassMethod CheckDiag(hisDiag, TmpArr) As %String
{
	n (hisDiag,TmpArr)
	
	s disData=##class(web.DHCCKBCommon).GetDiseaseData()
	
	i $d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(hisDiag)))  d	// 疾病
	.s flag=0,libID=""
	.f  s libID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(hisDiag),libID))  q:(libID="")||(flag=1)   d
	..s secondName=##class(web.DHCCKBCommon).GetDicSecondName(libID)
	..s secondName=$listtostring(secondName,";")		
	..s TmpArr(hisDiag)=$lb($tr(hisDiag,",",""),libID,$tr(hisDiag,",",""),secondName)
	..s flag =1	
	e  d
	.s TmpArr(hisDiag)=$lb(hisDiag)
	
	/*e  d 
	.s libID="",flag=0
	.f  s libID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",disData,libID))  q:(libID="")||(flag=1)   d // 疾病别名
	..s secondName=##class(web.DHCCKBCommon).GetDicSecondName(libID)
	..q:$listfind(secondName,hisDiag)<=0
	..s libDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),3)
	..s secondName=$listtostring(secondName,";")
	..s hisDiag=$tr(hisDiag,",","")	
	..s TmpArr(hisDiag)=$lb($tr(hisDiag,",",""),libID,$tr(libDesc,",",""),secondName)
	..s flag =1
	*/
	q ""
}

/// Description: 匹配诊断(模糊匹配)
ClassMethod FuzzyMatchDiag(TmpArr) As %String
{
		n (TmpArr)
		s disData=##class(web.DHCCKBCommon).GetDiseaseData()

		s diag=""
		f  s diag=$o(^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","diag",diag))  q:diag=""  d
		.s libID="",flag=0
		.f  s libID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",disData,libID))  q:(libID="")||(flag=1)   d // 疾病别名
		..s secondName=""
		..//s secondName=##class(web.DHCCKBCommon).GetDicSecondName(libID)
		..//q:$listfind(secondName,hisDiag)<=0	
		..s libDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),3)
		..q:$l(libDesc)<=1	// 过滤掉只有一个字符的串
		..q:diag'[libDesc	
		..s TmpArr(diag)=$lb($tr(diag,",",""),libID,$tr(libDesc,",",""),secondName)
		..s flag =1
		.i flag=0 d
		..s TmpArr(diag)=$lb($tr(diag,",",""))
		
		q ""
}

/// 导出诊断匹配结果
/// w ##Class(websys.Query).ToExcel("诊断对照结果（模糊匹配3）","web.DHCCKBPrescTest","ExportMatchDiag")
Query ExportMatchDiag() As websys.Query(ROWSPEC = "f1:%String:his诊断,f2:%String:知识库诊断id,f3:%String:知识库诊断描述,f4:%String:知识库别名")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportMatchDiag") 
/// @param: pid 进程号
ClassMethod ExportMatchDiagExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	//d ..MatchDiag(.TmpArr) // 精准匹配
		d ..FuzzyMatchDiag(.TmpArr) // 模糊匹配
	

	set index=""
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 记录药品
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-14
/// w ##class(web.DHCCKBPrescTest).mpSaveDrug()
ClassMethod TmpSaveDrug(drug) As %String
{
	n (drug)
	q:drug=""
	s ^Tmp("DHCCKB","web.DHCCKBPrescTest","TmpSaveDrug","drug",drug)=""
	
	q ""
}

/// Description: 匹配药品
/// Creator:     QuNianpeng
/// CreateDate:  2020-07-14
/// w ##class(web.DHCCKBPrescTest).MatchDrugList()
ClassMethod MatchDrugList(TmpArr) As %String
{
	n (TmpArr)
	//s ^Tmp("DHCCKB","web.DHCCKBPrescTest","TmpSaveDrug","drug","注射用A型肉毒毒素(保妥适)50iU")=""
	//s ^Tmp("DHCCKB","web.DHCCKBPrescTest","TmpSaveDrug","drug","注射用A型肉毒毒素(保妥适)50iUqq")=""
	s drug=""
	f  s drug=$o(^Tmp("DHCCKB","web.DHCCKBPrescTest","TmpSaveDrug","drug",drug))  q:drug=""  d
	.s isHaveRuleFlag="",libDrugID="",libDrugName=""
	.s isContrast=..IsContrast(drug)	 // 是否对照
	.i isContrast="N" s isHaveRuleFlag="N"
	.e  d
	..//s libDrugID=##Class(web.DHCCKBPassNew).GetComDicIdNew(drug,"Drug")
	..s libDrugID=..GetLibIDByConstrast(drug)
	..s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+libDrugID)),3)
	..s isHaveRuleFlag=$case(##class(web.DHCCKBCommon).IsExistRule(libDrugID),1:"Y",:"N")
	.
	.s TmpArr(drug)=$lb(drug,isContrast,isHaveRuleFlag,libDrugID,libDrugName)
	
	q ""
}

/// 导出药品匹配结果，是否有规则
/// w ##Class(websys.Query).ToExcel("药品匹配结果","web.DHCCKBPrescTest","ExportMatchDrugList")
Query ExportMatchDrugList() As websys.Query(ROWSPEC = "f1:%String:his药品,f2:%String:是否对照,f3:%String:是否有规则,f4:%String:知识库药品id,f5:%String:知识库药品描述")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportMatchDrugList") 
/// @param: pid 进程号
ClassMethod ExportMatchDrugListExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	d ..MatchDrugList(.TmpArr)  // 精准匹配
	
	set index=""
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod test()
{
	
	s diag=""
	f  s diag=$o(^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","17200301",diag))  q:diag=""  d
	.s ^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","diag",diag)=""
}

/// Descript:导出his诊断和知识库未匹配诊断
/// CreateDate:2020-07-16
/// Creator:sufan
/// w ##Class(websys.Query).ToExcel("his诊断和知识库未匹配数据11","web.DHCCKBPrescTest","ExportNotMatDiag","17729381^17729382")
/// w ##Class(websys.Query).ToExcel("his诊断和知识库未匹配数据2","web.DHCCKBPrescTest","ExportNotMatDiag","17729381")
Query ExportNotMatDiag(pidlist) As websys.Query(ROWSPEC = "hisDrug:%String:his药品,libDrug:%String:知识库药品,hisDiag:%String:his诊断,hisTimes:%String:his诊断出现次数")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportNotMatDiag",1) 
/// @param: pid 进程号
ClassMethod ExportNotMatDiagExecute(ByRef qHandle As %Binary, pidlist) As %Status
{
	n (qHandle,pidlist)
	
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200153","芬太尼透皮贴剂(多瑞吉)4.2MG/贴",106213)="门诊^20703262^62岁^男^^^^1.口腔恶性肿瘤^^MJ19081200153^2^芬太尼透皮贴剂(多瑞吉)4.2mg/贴^贴剂^4.2mg^贴^7^8.4^mg^72小时外用^外用^^1^2019/8/12^^N^"                                                     
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200155","枸橼酸舒芬太尼注射液(宜昌)1ML50UG",98341)="门诊^20680204^27岁^女^^^^1.便秘^^MJ19081200155^1^枸橼酸舒芬太尼注射液(宜昌)1ml50ug^注射液^1ml50ug^支^1^1^ml^St^静脉注射^1天^5^2019/8/12^"                                                                 
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200157","艾司唑仑片(山东)1MG*20",110216)="门诊^20878139^59岁^女^注射用头孢哌酮钠舒巴坦钠(舒普深)1.5g^^^^^MJ19081200157^1^艾司唑仑片(山东)1mg*20^片剂^1mg*20^片^14^2^mg^Qn^口服^1天^3^2019/8/12^^N^"                                             
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200159","枸橼酸舒芬太尼注射液(宜昌)1ML50UG",107193)="门诊^20909764^74岁^男^^^^1.排便困难^^MJ19081200159^1^枸橼酸舒芬太尼注射液(宜昌)1ml50ug^注射液^1ml50ug^支^1^1^ml^St^静脉注射^1天^12^2019/8/12^"                                                            
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200160","艾司唑仑片(山东)1MG*20",110272)="门诊^20878222^66岁^男^^^^1.失眠症^^MJ19081200160^1^艾司唑仑片(山东)1mg*20^片剂^1mg*20^片^14^2^mg^Qn^口服^1天^3^2019/8/12^^N^"                        
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200175","右佐匹克隆片(文飞)3MG*6",108341)="门诊^20895267^61岁^女^^^^1.睡眠障碍^^MJ19081200175^1^右佐匹克隆片(文飞)3mg*6^片剂^3mg*6^片^6^3^mg^Qn^口服^1天^3^2019/8/12^"                     
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200179","枸橼酸芬太尼注射液0.1MG2ML",110293)="门诊^20889263^27岁^女^^^^1.早期人工流产^^MJ19081200179^1^枸橼酸芬太尼注射液0.1mg2ml^注射液^0.1mg2ml^支^2^0.2^mg^St^ivgtt^1天^12^2019/8/12^"                                                                    
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200235","枸橼酸舒芬太尼注射液(宜昌)1ML50UG",106153)="门诊^20907141^54岁^女^^^^1.消化系统的疾病^^MJ19081200235^1^枸橼酸舒芬太尼注射液(宜昌)1ml50ug^注射液^1ml50ug^支^1^1^ml^St^静脉注射^1天^9^2019/8/12^"                                                         
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200236","枸橼酸舒芬太尼注射液(宜昌)1ML50UG",104832)="门诊^20903393^65岁^男^^^^1.消化系统的疾病^^MJ19081200236^1^枸橼酸舒芬太尼注射液(宜昌)1ml50ug^注射液^1ml50ug^支^1^1^ml^St^静脉注射^1天^5^2019/8/12^"                                                         
 ;s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder1",1,"MJ19081200237","枸橼 酸舒芬太尼注射液(宜昌)1ML50UG",107738)="门诊^20459089^63岁^女^^^^1.消化系统的疾病^^MJ19081200237^1^枸橼酸舒芬太尼注射液(宜昌)1ml50ug^注射液^1ml50ug^支^1^1^ml^St^静脉注射^1天^11^2019/8/12^" 	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k matchArr
	s pidlen = $l(pidlist,"^")
	for i=1:1:pidlen  d
	.s pid = $p(pidlist,"^",i)
	.s preNo = "" 
	.for  s preNo = $o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,preNo))  Q:preNo=""  d
	..s drug = ""
	..for  s drug = $o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,preNo,drug))  Q:drug=""  d
	...s index = ""
	...for  s index = $o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,preNo,drug,index))  Q:index=""  d
	....s madata = ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,preNo,drug,index)
	....s drugDesc = $p(madata,"^",12)					//his药品
	....s diagList = $p(madata,"^",8)					//诊断
	....s changeDiagList = ##class(web.DHCCKBPrescTest).ChangeDisStr(diagList)
	....Q:changeDiagList=""
	....s length = $l(changeDiagList,",")
	....for i=1:1:length  d
	.....s Diag = $p(changeDiagList,",",i)
	.....s flag = ..IsMatchWithHisDiag(Diag)
	.....Q:flag=1
	.....s index = drugDesc_"^"_Diag
	.....i $d(matchArr(index))  d
	......s $p(matchArr(index),"^",3) = $p(matchArr(index),"^",3)+1 
	.....e  d
	......s matchArr(index) = drugDesc_"^"_Diag_"^"_1
	
	set index   =""
	for  set index = $o(matchArr(index)) quit:index=""  do
	.set listData = $get(matchArr(index))
	.s hisDrug = $p(listData,"^",1)
	.s libDrug = ..GetMatchLibDrug(hisDrug)
	.s hisDiag = $p(listData,"^",2)
	.s hisTimes = $p(listData,"^",3)
	.set ^CacheTemp(repid,ind) = $lb(hisDrug,libDrug,hisDiag,hisTimes)
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:模糊匹配诊断:his诊断是否包含知识库诊断
/// Input:his诊断
/// Output:1：匹配，0：未匹配
ClassMethod IsMatchWithHisDiag(hisDiag)
{
		n (hisDiag)
		s disData=##class(web.DHCCKBCommon).GetDiseaseData()
		s libDesId="",flag=0
		f  s libDesId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",disData,libDesId))  q:(libDesId="")||(flag=1)   d // 疾病别名
		.s libDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+libDesId)),3)
		.q:$l(libDesc)<=1	
		.q:hisDiag'[libDesc	
		.s flag =1
		Q flag
}

/// 取his对照的知识库数据
/// w ##class(web.DHCCKBPrescTest).GetMatchLibDrug("枸橼酸舒芬太尼注射液(宜昌)1ml50ug")
ClassMethod GetMatchLibDrug(hisDrug)
{
		n (hisDrug)
		s Id = $o(^CKB.PDSS.ComContrastI("HisDesc",hisDrug,""))
		s libDrug = ""
		s:Id'="" libDrug = $lg(^CKB.PDSS.ComContrastD(Id),3)
		Q libDrug
}

/// w ##Class(web.DHCCKBPrescTest).Testagain()
ClassMethod Testagain()
{
	// ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",18814376,"O200403000016")
	s pid="18814376"
	s prescNo="O200403000016" //"MJ19082900028"
	s title="类型^就诊号^年龄^性别^患者过敏信息^体重^身高^诊断^特殊人群^处方号^处方上药品数量^药学名称^药品剂型^规格^最小包装^发药数量^单次剂量^剂量单位^频次^服药途径^疗程^关联医嘱组号^开方时间^医嘱备注"
	s allergy="" 
	s index=1633 //162322	//MJ19083000068 
	s paramObj={}	//"艾司唑仑片(山东)1MG*20",162322)"
	s valueStr="门诊^20067645^73岁^女^^^^1.失眠^^MJ19082900028^1^艾司唑仑片(山东)1mg*20^片剂^1mg*20^片^14^2^mg^Qn^口服^7天^2^2019/8/29^^N^适应症:超 适应症用药主要用于抗焦虑、失眠，也用于紧张、恐惧及抗癫痫和抗惊厥"
	s valueStr="门诊^20826828^13岁3月^男^^^^1.屈光不正^^O200403000016^1^复方托吡卡胺滴眼液(沈阳)1ml^滴眼剂^1ml^ml^1^1^ml^Bid^外用^^3^2020/4/3^"
	s paramObj=..GetParamObj(pid,prescNo,title,valueStr,paramObj,allergy,index)
	
	k ^TMP("DHCCKB","web.DHCCKBPrescTest","GetParamObj",pid,prescNo)
	q:(paramObj="")||(paramObj={})||(paramObj.%ToJSON()="{}")
	d paramObj.%Set("Action","CheckRule") 
	s retStr=""
	d ##Class(web.DHCCKBPassNew).IntMakPolPass(paramObj.%ToJSON(),.retStr)
	q:retStr="" ""
	
	s retObj=##class(%DynamicArray).%FromJSON(retStr)
	q ""
}

ClassMethod testtest(TmpArr)
{
	n (TmpArr)
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionD(id)) q:id=""  d
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),5)
 .q:id'=linkDr
 .s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),2)
 .s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)
 .s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),4)
 .s parrefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
 .s parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
 .s TmpArr(id)=id_"^"_code_"^"_desc_"^"_parref_"^"_parrefCode_"^"_parrefDesc_"^"_linkDr
}

/// Descript:导出id和link相同的数据
/// CreateDate:2020-07-16
/// w ##Class(websys.Query).ToExcel("id和link相同","web.DHCCKBPrescTest","ExportSameId")
Query ExportSameId() As websys.Query(ROWSPEC = "id:%String:id,code:%String:代码,desc:%String:描述,parref:%String:上级id,parrefCode:%String:上级code,parrefDesc:%String:上级描述,linkdr:%String:linkdr")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportNotMatDiag",1) 
ClassMethod ExportSameIdExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k TmpArr
	d ..testtest(.TmpArr)
	
	set index   =""
	for  set index = $o(TmpArr(index)) quit:index=""  do
	.set listData = $get(TmpArr(index))
	.set ^CacheTemp(repid,ind) = $listfromstring(listData,"^")
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:导出his诊断和特殊人群模糊匹配数据
/// CreateDate:2020-07-16
/// Creator:sufan
/// w ##Class(websys.Query).ToExcel("处方和妊娠期匹配","web.DHCCKBPrescTest","ExportDiagWithSpegroup","C:\Users\Administrator\Desktop\诊断.txt")
Query ExportDiagWithSpegroup(filepath) As websys.Query(ROWSPEC = "hisDiag:%String:外部诊断,speDiag:%String:HIS诊断")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportDiagWithSpegroup",1) 
/// @param: pid 进程号
ClassMethod ExportDiagWithSpegroupExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k diseArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
	.s diagDesc=$p(listData,"^",4)
 .s diseArr(count)=diagDesc
	c filepath
	
	k hisDiagArr
	s num=0
	s diag = "" 
	for  s diag = $o(^Tmp("DHCCKB","web.DHCCKBPrescTest","SaveAllDiag","diag",diag))  Q:diag=""  d
	.s num=num+1
	.Q:(diag'["妊娠")
	.s hisDiagArr(num)=diag
	B   //33
	s index  = ""
	for  s index = $o(hisDiagArr(index))  	Q:index=""  d
	.s speDiag = hisDiagArr(index)
	.s hisIndex = ""
	.for  s hisIndex = $o(diseArr(hisIndex))  Q:hisIndex=""   d
	..s hisDiag = diseArr(hisIndex)
	..Q:hisDiag'[speDiag
	..set ^CacheTemp(repid,ind) = $lb(hisDiag,speDiag)
	..set ind=ind+1
	Set qHandle=$lb(0,repid,0)

	Quit $$$OK
}

/// Descript:导出知识库诊断和hsi的icd未匹配的数据
/// CreateDate:2020-07-16
/// Creator:sufan
/// w ##Class(websys.Query).ToExcel("icd和知识库未匹配数据","web.DHCCKBPrescTest","ExportLibNotMatDiag","C:\Users\Administrator\Desktop\ICD诊断.txt")
/// w ##Class(websys.Query).ToExcel("icd和知识库未匹配数据","web.DHCCKBPrescTest","ExportLibNotMatDiag","C:\Users\Administrator\Desktop\ICD测试.txt")
Query ExportLibNotMatDiag(filepath) As websys.Query(ROWSPEC = "libDiag:%String:诊断")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportLibNotMatDiag","C:\Users\Administrator\Desktop\ICD诊断.txt") 
ClassMethod ExportLibNotMatDiagExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)
	

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k icdArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
	.s diagDesc=$p(listData,"^",4)
 .s icdArr(count)=diagDesc
	c filepath


	
 k extArr
 s num = 0
	s diagDictionId = ##class(web.DHCCKBCommon).GetDiseaseData()
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",diagDictionId,Id))  Q:Id=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s text = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.s extflag=0
	.s icdIndex = ""
	.for  s icdIndex = $O(icdArr(icdIndex))  Q:(icdIndex="")||(extflag=1)  d
	..s icdDiag = $p(icdArr(icdIndex),"^",1)
	..Q:icdDiag'[text
	..s extflag=1
	.s num = num+1
	.i extflag=0 s extArr(num)=text
	

	
	
	set index   =""
	for  set index = $o(extArr(index)) quit:index=""  do
	.set listData = $get(extArr(index))
	.s libDiag = $p(listData,"^",1)
	.set ^CacheTemp(repid,ind) = $lb(libDiag)
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:组织未匹配的诊断串
/// Creator:Sufan
/// CreateDate:2020-09-02
/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","GetOrgMatchDiag") 
/// w ##class(web.DHCCKBPrescTest).GetOrgMatchDiag("C:\Users\Administrator\Desktop\知识库未匹配的诊断.txt")
/// w ##Class(websys.Query).ToExcel("icd和知识库匹配数据","web.DHCCKBPrescTest","GetOrgMatchDiag")
Query GetOrgMatchDiag() As websys.Query(ROWSPEC = "libDiag:%String:诊断,icdCode:%String:ICD诊断代码,icdDiag:%String:ICD诊断")
{
}

ClassMethod GetOrgMatchDiagExecute(ByRef params As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s filepath="C:\Users\Administrator\Desktop\知识库未匹配的诊断.txt"
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k matchArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
	.s diagDesc=$p(listData,"^",1)
 .s matchArr(count)=diagDesc
	c filepath
	
	s obj= ##class(%DynamicObject).%New()
	s source = []
	d source.%Push("LC")
	s obj.source = source
	s obj.dbname = "zhenduan"
	s obj.size = 1
	
	
	s index = "",num=0
	for  s index = $o(matchArr(index))  Q:index=""  d
	.s num=num+1
	.;Q:num>10
	.s match=[]
	.s libDiag = $p(matchArr(index),"^",1)
	.d match.%Push(libDiag)
	.s obj.terms = match
	.s data=obj.%ToJSON()
	.s result=..matchIcdDiag(data)
	.s dealresult=..DealResult(result)
	.set ^CacheTemp(repid,ind) = $lb(dealresult)
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBPrescTest).matchIcdDiag()
ClassMethod matchIcdDiag(data)
{
	n (data)
	/*s obj= ##class(%DynamicObject).%New()
	s match=[]
	d match.%Push("无症状的菌尿")
	s source = []
	d source.%Push("LC")
	s obj.source = source
	s obj.dbname = "zhenduan"
	s obj.size = 1
	s obj.terms = match
	s obj.terms = match
	

	
	s data=obj.%ToJSON()
*/
	//s data=##class(web.DHCCKBPrescTest).GetOrgMatchDiag("C:\Users\Administrator\Desktop\知识库未匹配的诊断.txt") 
 
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server="172.19.19.90"
	Set httprequest.Port=8003
	Set stream=##class(%CSP.BinaryStream).%New()
	Do stream.Write(data)
	Set httprequest.EntityBody=stream
	Do httprequest.EntityBody.SetAttribute("CONTENT-TYPE","application/json; charset=UTF-8")
	Do httprequest.Post("/match_icd")
	
	Set response=httprequest.HttpResponse
	if response {
		set StatusCode=response.StatusCode
		Set Data=response.Data
		
		if $IsObject(Data){
			if $CLASSNAME(Data)["Binary" { //字节流   
				//还是会有1个bug 比如流比较长 一次读不完 当一个字符的两个字节刚好被截断在两边  就会转化错误
				//所以暂时就当作返回的是个比较短的 一次可以处理玩的
				Set strData=Data.Read(30000)
				;b ;2
				if ##class(ext.util.String).IsUTF8ByteString(strData) { //满足utf8编码格式的 按utf8转成字符串
					s strData=$zcvt(strData,"I","UTF8")
				}else{ //按GB18030转
					s strData=$zcvt(strData,"I","GB18030")
				}
				q strData
			}else{
				Set strData=Data.Read(30000)
				if Data.AtEnd {
					q strData
				}else{
					s stream=##class(%GlobalCharacterStream).%New()
					d stream.CopyFrom(Data)
					q stream
				}
			}
		}else{
			q Data
		}
	}
	q ""
}

ClassMethod DealResult(res)
{
	n (res)
	s hisDiag=$p($p(res,"[[",2),",",1)
	s icdDiag=$p($p(res,"[[",3),",",1)
	
	s icdCode=$p($p(res,"[[",3),",",2)
	q hisDiag_","_icdCode_","_icdDiag
}

/// Descript:结构化数据匹配
/// Creator:QQA&sufan
/// CreateDate:2020-09-16
/// w ##class(web.DHCCKBPrescTest).matchStructData("非计划二次手术")
ClassMethod matchStructData(data)
{
	
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server="111.205.6.207"
	Set httprequest.Port=3001
	Set stream=##class(%CSP.BinaryStream).%New()
	Do stream.Write(data)
	Set httprequest.EntityBody=stream
	Do httprequest.EntityBody.SetAttribute("CONTENT-TYPE","application/json; charset=UTF-8")
	Do httprequest.Post("/tag")
	
	Set response=httprequest.HttpResponse
	if response {
		set StatusCode=response.StatusCode
		Set Data=response.Data
		
		if $IsObject(Data){
			if $CLASSNAME(Data)["Binary" { //字节流   
				//还是会有1个bug 比如流比较长 一次读不完 当一个字符的两个字节刚好被截断在两边  就会转化错误
				//所以暂时就当作返回的是个比较短的 一次可以处理玩的
				Set strData=Data.Read(30000)
				;b ;2
				if ##class(ext.util.String).IsUTF8ByteString(strData) { //满足utf8编码格式的 按utf8转成字符串
					s strData=$zcvt(strData,"I","UTF8")
				}else{ //按GB18030转
					s strData=$zcvt(strData,"I","GB18030")
				}
				q strData
			}else{
				Set strData=Data.Read(30000)
				if Data.AtEnd {
					q strData
				}else{
					s stream=##class(%GlobalCharacterStream).%New()
					d stream.CopyFrom(Data)
					q stream
				}
			}
		}else{
			q Data
		}
	}
	q ""
}

/// Descript:获取病历数据敏感词
/// Creator:sufan
/// CreateDate:2020-09-25
/// Input:病历文本
/// Output:敏感词条，对应不良事件的csp？
/// w ##class(web.DHCCKBPrescTest).GetSensWordsList("非计划二次手术")
ClassMethod GetSensWordsList(data)
{
	n (data)
	s strList = ""
	s jsonStr = ##class(web.DHCCKBPrescTest).matchStructData(data)				//获取病历数据
	s jsonObj = ##class(DHCNewPro.COM.Object).FromJSON(jsonStr)
	s len = jsonObj.Size()
 for i=0:1:len-1  d
 .s itmeObj = jsonObj.Get(i)
 .s itemDesc = itmeObj.name
 .i strList= "" s strList = itemDesc
 .e  s strList = strList_"^"_itemDesc
 Q strList
}

/// Description:	用法用量自动生成普适(兜底)规则(新生成规则)
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
/// input: queryDrugId（单个药品生产）, queryFlag(是否记录非儿童的且含有体重、体表等用量的规则),setFlag(已有兜底规则，是否生成多条)
/// other:			(普适项目：给药途径、日用药量、单次用药量、用药频率)
/// 生成规则:	1. 删除旧的普适(兜底)规则
/// 			2. 遍历用法用量下的每一条规则,根据剂量的优先级,取到剂量(去掉优先级，找最大值即可2020-11-12)
/// 					2.1 单次生成的优先级：单次剂量<单次最大量<单次极限量
/// 					2.2 每日生成的优先级：每日剂量<每日最大量<每日极限量
/// 			3. 生成的新规则，次剂量和日剂量(只有一条分支)，在同一个节点下，是或者关系
/// 			4. 同一个计算项目存在多条规则，则使用其中量最大的那条规则，如：用法用量里面的规则1设置：单次剂量2mg,规则2设置：单次剂量4mg,则兜底规则使用单次剂量4mg
/// 			5. 同一个计算项目存在多条规则，且单位不一致，则通过单位转换比较，使用量大的那条规则。如：规则1：单次剂量2mg。规则2：单次剂量4ml,使用等效单位比较2mg和4ml,使用量大的。若没有等效单位，无法比较的，进行标记	
/// 			6. 备注中进行标注：系统生成规则
/// 			7. 提示依据进行标注：系统生成规则
///             8. 认为 = 等同于<=，大于，大于等于的忽略
/// 			9. 遇到kg/m2 这种带斜杠的单位，忽略掉(规则无法比较的情况下)
/// 			10. 遇到kg,m2这种带斜杠的单位,生成兜底规则时需要忽略掉,但是要标记出来（非儿童,且有斜杠单位 2020-11-12）
///             11. 中药饮片的用法用量规则取消发布，兜底规则中增加了 一个外用。且只使用兜底规则进行管控 2021/9/26
/// w ##Class(web.DHCCKBPrescTest).AutoSetBaseRule("","N","N")
ClassMethod AutoSetBaseRule(queryDrugId As %String = "", queryFlag = "N", setFlag = "N") As %String
{
	n (queryDrugId,queryFlag,setFlag)
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s chinaHMDrugData=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片字典
	q:(+drugData=0)&(+chineseDrugData=0)&(chinaHMDrugData=0) ""
	s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")		// 用法目录
	K ^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg")
	s loginInfo="11877^8^1^289^2"
	s userId=11877
	//set $ZT="ERROR" // 设置一个异常
	s err=0
	//Ts
	s count=0
	//s comlist=$lb(drugPreMet,drugFreq,onceDose,dayMax)	// 普适项目
	// TmpArr("PreMet") TmpArr("FreqList") TmpArr("onceDose") TmpArr("onceDoseMax") TmpArr("onceDoseLimit")  TmpArr("dayDose") TmpArr("dayDoseMax") TmpArr("dayDOseLimit")
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:drugId'=81646
	.q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.//q:parref'=chinaHMDrugData
	.k TmpArr
	.// 遍历所有的用法用量规则,记录下非儿童的且含有体重、体表等用量的规则(人群是儿童等,或年龄小于18岁)
	.i queryFlag= "Y" d ..MarkNotChildDoseRule(.TmpArr,drugId)

	.q:$g(TmpArr("exitFlag"))=1
	.s err=..CleanBaseRule(drugId)	// 	清除药品的普适规则
	.q:err=1
	.s exitFlag=0	// 药品是否存在普适规则
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")||(exitFlag=1)  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..q:ruleStauts'="Release"
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法用量"
	..s exitFlag=..GetBaseItmValue(.TmpArr,drugId,rule)
	..i exitFlag=1 d
	...d ..MarkErrMsg(.TmpArr)	// 记录不能生成的原因
	..q:exitFlag=1
	.
	.i exitFlag=1 k TmpArr
	.q:exitFlag=1	
	.q:(setFlag="N")&(##Class(web.DHCCKBPrescTest).IsSetCommonRule(drugId)=1) // 已经有兜底规则，是否生成多条
	.s ruleObj=..SetBaseRuleObj(.TmpArr)
	.q:ruleObj=""
	.k root
	.q:ruleObj.%Get("if").%Size()=0
	.s root={}
	.d root.%Set("rule",ruleObj)
	.s status=""	// 保存
	.//s ret=##class(web.DHCCKBRuleSave).save(0,"Add",root.%ToJSON(),userId,drugId_"^"_usageId,loginInfo)	// save方法中,root是json字符串,不成直接传json对象
	.//s ret=##class(web.DHCCKBRuleSave).save(0,"Release",root.%ToJSON(),userId,drugId_"^"_usageId,loginInfo)	// save方法中,root是json字符串,不成直接传json对象
	.s ret = ..SubmitRule(root.%ToJSON(),userId,drugId_"^"_usageId,loginInfo)
	.i ret<0 s err=1
	.//i ret<0 tro
	.q:+ret<0
	.s count=count+1
	.w count,!
	
	//i err=1 tro
	//e  TCOMMIT
	
	q "完成:"_count_"个药品"
	
ERROR11
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	//TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	Quit ErrorMsg		             //返回错误信息
}

///  Descript:  	获取兜底规则的项目值
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
///  Output:    
ClassMethod GetBaseItmValue(TmpArr, drugId As %String, ruleId As %String, childFlag = 0) As %String
{
	n (TmpArr,drugId,ruleId,childFlag)

	q:$g(TmpArr("exitFlag"))=1 ""
	s drugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()		// 给药途径属性
	s drugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()		// 用药频率属性
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()		// 单次剂量属性
	s onceDoseMax=##class(web.DHCCKBCommon).GetOnceDoseMaxProp() // 单次最大量属性
	s onceDoseLimit=##class(web.DHCCKBCommon).GetOnceDoseLimitProp() // 单次极限量
	s dayDose=##class(web.DHCCKBCommon).GetDayDoseProp()			// 日剂量属性
	s dayDoseMax=##class(web.DHCCKBCommon).GetDayDoseMaxProp()		// 日最大量
	s dayDOseLimit=##class(web.DHCCKBCommon).GetDayDoseLimitProp()	// 日极限量
	
	s markList = $lb(drugPreMet,drugFreq,onceDose,onceDoseMax,onceDoseLimit,dayDose,dayDoseMax,dayDOseLimit)

	s libary=0
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	//判断规则中是否有目录
	s dic="" 
	f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dic)) q:dic=""  d
	.s dicParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)
	.s:dicParef=drugLibary libary=dic	//目录
	q:+libary=0 0

	s exitFlag = 0
	s parent=""
	f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent))  q:(parent="")||(exitFlag=1)   d  
	.s node=""
	.f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent,node))  q:(node="")||(exitFlag=1)   d  
	..q:node=0
	..s ruleDataID=""
	..f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,ruleDataID))  q:(ruleDataID="")||(exitFlag=1)   d
	...q:ruleDataID=0
	...q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	...s value=..GetValue(ruleDataID)	// 记录普适项目的值： 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)	// 实体/属性（前提条件的项目代码）
	...//s calcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),2)
	...q:'$lf(markList,leftDic)
	...i leftDic=drugFreq d			// 用药频率
	....s:(value'="")&($listfind($g(TmpArr("FreqList")),value)=0) $list(TmpArr("FreqList"),*+1)=value
	...e  i leftDic=drugPreMet d	// 给药途径
	....s:(value'="")&($listfind($g(TmpArr("PreMet")),value)=0) $list(TmpArr("PreMet"),*+1)=value
	...e  d	// 用药量
	....q:(childFlag=1)&&($d(TmpArr("childRule")))&&('$d(TmpArr("childRule",ruleId))) // 儿童剂量只用儿童规则生成 2022/04/25
	....s exitFlag=..CompareDose(.TmpArr,drugId,ruleId,ruleDataID)
	...
	...q:exitFlag=1
	
	q exitFlag
	
	q ""
}

/// Descript:  		清除兜底规则
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
///  Output: 
ClassMethod CleanBaseRule(drugId As %String, childFlag = 0) As %String
{
	n (drugId,childFlag)
	
	s ret=0
	s ruleDicId=""
	f  s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicId)) q:(ruleDicId="")||(ret=1)  d
	.s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicId)),2)
	.q:+ruleId=0
	.s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(ruleId)
	.s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")		// 用法目录
	.q:labelDesc'=$lg($g(^CT.CKB.PDSS.CommonDictionD(+usageId)),3)
	.s reMark = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)
	.s reName = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)
	.q:(childFlag=1)&&((reMark'["儿童")&&(reName'["儿童"))  // 过滤非儿童的兜底规则 qnp 2022-04-26
	.q:(childFlag'=1)&&((reMark["儿童")||(reName["儿童"))	// // 过滤非成人的兜底规则
	.//q:(childFlag=1)&&('(($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)="系统生成(儿童)")||($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)="普适规则(儿童)")))  // 过滤非儿童的兜底规则
	.//q:(childFlag'=1)&&('(($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)="系统生成")||($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)="普适规则")))	// // 过滤非成人的兜底规则
	.s count = 0 
	.s ruleLogId=""	// 兜底规则修改过的不能删除
	.f  s ruleLogId=$o(^CKB.PDSS.RuleLogI("Rule",ruleId,ruleLogId))  q:(ruleLogId="")||(count>2)  d
	..s count = count + 1
	..q:count>2
	.
	.q:count>2
	.
	.&sql(delete from CT_CKB_PDSS.RuleData where RD_Rule=:ruleId)
	.i SQLCODE'=0 s ret=1
	.q:ret=1
	.&sql(delete from CT_CKB_PDSS.RuleDic where RD_Rule=:ruleId)
	.i SQLCODE'=0 s ret=1
	.q:ret=1
	.&sql(delete from CT_CKB_PDSS.Rule where R_RowId=:ruleId)
	.i SQLCODE'=0 s ret=1
	.q:ret=1
	.//&sql(delete from CKB_PDSS.RuleLog where RL_Rule=:ruleId)
	.//i SQLCODE'=0 s ret=1
	.&sql(delete from CT_CKB_PDSS.RuleNode where RN_Rule=:ruleId)
	
	q ret
}

/// Descript:  		经过比较选择剂量最大的
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
///  Output: 
ClassMethod CompareDose(TmpArr, drugId As %String, ruleId, ruleDataID, calcItm) As %String
{
	n (TmpArr,drugId,ruleId,ruleDataID,calcItm)	
	
	s exitFlag=0 
	q:+drugId=0 ""
	q:'$d(^CT.CKB.PDSS.CommonDictionD(+drugId)) ""
	s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s parrefData = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s parrefDataName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parrefData)),3)
	s value=..GetValue(ruleDataID)	// 记录普适项目的值： 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)	// 实体/属性（前提条件的项目代码）	
	s calcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(+leftDic)),2)
	s op=$p(value,$c(1),2)
	s minValue=$p(value,$c(1),3)
	s maxValue=$p(value,$c(1),4)
	s unit=$p(value,$c(1),5)
	s:((minValue="")&(maxValue=""))||(unit="") exitFlag=1 // 数值为空,或者单位为空,则退出
	//i exitFlag=1 s TmpArr("nullValue")=$lb(drugId,drugName,ruleId,"数值或单位为空,不能自动生成,请核对",parrefData,parrefDataName,"")
	q:exitFlag=1 exitFlag
		
	s opValue = $select(op="GreaterThenEquals":2,op="GreaterThen":2,op="LessThenEquals":3,op="LessThen":3,op="Between":3,op="Equals":3,op="NotEquals":4,1:0)
	q:opValue'=3 0
	//i '$d(TmpArr(calcItm,"sign")) s TmpArr(calcItm,"sign")=opValue
	//s:opValue'=$g(TmpArr(calcItm,"sign")) exitFlag=1	
	//i exitFlag=1 s TmpArr("nullValue")=$lb(drugId,drugName,ruleId,"比值符号存在冲突,不能自动生成,请核对",parrefData,parrefDataName)
	//q:exitFlag=1 exitFlag
	s realItm = ""
	s:(calcItm="OnceDoseLimit")||(calcItm="OnceDoseMax")||(calcItm="OnceDose") realItm="once"
	s:(calcItm="DayDoseLimit")||(calcItm="DayDoseMax")||(calcItm="DayDose") realItm="day"

	i $g(TmpArr(realItm,"value"))="" d
	.s TmpArr(realItm,"value")=$case(maxValue>minValue,1:maxValue,:minValue)
	.s TmpArr(realItm,"unit")=unit	
	.s TmpArr(realItm,"calcItm")=leftDic
	
	// 先比较单位,单位不一致的,根据系数转换,计算。转换不成功的则进行
	s markUnit=$g(TmpArr(realItm,"unit"))
	i markUnit=unit d	// 单位相同比较值
	.s:$g(TmpArr(realItm,"value"))<minValue TmpArr(realItm,"value")=minValue,TmpArr(realItm,"calcItm")=leftDic
	.s:$g(TmpArr(realItm,"value"))<maxValue TmpArr(realItm,"value")=maxValue,TmpArr(realItm,"calcItm")=leftDic
	e  d  // 单位不同 // 单位是否可以转换
	.q:(+markUnit=0)||(+unit=0)
	.q:('$d(^CT.CKB.PDSS.CommonDictionD(+markUnit)))||('$d(^CT.CKB.PDSS.CommonDictionD(+unit)))
	.s isExitFlag = 0
	.i ($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/") & ('($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/")) d	// 单位不一致时,是否包含/的形式
	..s TmpArr(realItm,"unit")=unit
	..s TmpArr(realItm,"value")=$case(maxValue>minValue,1:maxValue,:minValue)
	..s isExitFlag = 1
	.i ($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/")&(($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/")) d
	..s isExitFlag = 1
	.i ('($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/"))&($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/") d
	..s isExitFlag = 1
	.
	.q:isExitFlag=1
	.s fac=##class(web.DHCCKBCommonUtil).GetFactorToLib($lg($g(^CT.CKB.PDSS.CommonDictionD(markUnit)),3),$lg($g(^CT.CKB.PDSS.CommonDictionD(unit)),3),drugId)
	.i fac="" s exitFlag=1
	.i exitFlag=1 s TmpArr("nullValue")=$lb(drugId,drugName,ruleId,"单位不相同,且无法转换,请核对",parrefData,parrefDataName,"")	
	.q:exitFlag=1
	.s newValue=$g(TmpArr(realItm,"value"))*fac
	.s:newValue<minValue TmpArr(realItm,"value")=minValue,TmpArr(realItm,"unit")=unit,TmpArr(realItm,"calcItm")=leftDic
	.s:newValue<maxValue TmpArr(realItm,"value")=maxValue,TmpArr(realItm,"unit")=unit,TmpArr(realItm,"calcItm")=leftDic

	s TmpArr("exitFlag")=exitFlag
	s TmpArr(realItm)=$lb("InputUom"_$c(1)_"LessThenEquals"_$c(1)_$g(TmpArr(realItm,"value"))_$c(1)_""_$c(1)_$g(TmpArr(realItm,"unit")))

	// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	i exitFlag=1 d
	.k TmpArr(realItm,"sign")
	.k TmpArr(realItm,"unit")
	.k TmpArr(realItm,"value")
	.k TmpArr(realItm,"calcItm")

	q exitFlag
}

/// Descript:  		记录不能生成兜底规则的药品和规则序号
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
///  Output: 
ClassMethod MarkErrMsg(TmpArr)
{
	n (TmpArr)
	
	s num = $i(^TmpMarkErr("num"))
	s ^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg",num)=$g(TmpArr("nullValue"))

	q ""
}

/// Descript:  		生成兜底规则的后台对象
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-04
///  Output: 
ClassMethod SetBaseRuleObj(TmpArr, childFlag = 0)
{
	n (TmpArr,childFlag)
	// TmpArr("PreMet") TmpArr("FreqList") TmpArr("onceDose") TmpArr("onceDoseMax") TmpArr("onceDoseLimit") TmpArr("dayDose") TmpArr("dayDoseMax") TmpArr("dayDOseLimit")
	
	s preMetList = $g(TmpArr("PreMet"))
	s freqList = $g(TmpArr("FreqList"))	
	s onceDoseList = $select($d(TmpArr("once")):TmpArr("once"),1:"")
	s dayDoseList = $select($d(TmpArr("day")):TmpArr("day"),1:"")

	// 次剂量/日剂量 按照最大的取,不按照优先级去取了
	q:(preMetList="")&(freqList="")&(onceDoseList="")&(dayDoseList="") ""
	//s freqList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3925_$c(1)_$c(1))
	//s preMetList=$lb("Constant"_$c(1)_"Equals"_$C(1)_3922_$c(1)_$c(1))
	//s onceDoseList=$lb("InputLimit"_$c(1)_"Equals"_$C(1)_1_$c(1)_2_$c(1)_3924)
	//s dayMaxList("InputLimit"_$c(1)_"Equals"_$C(1)_1_$c(1)_2_$c(1)_3924)

	s drugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()		// 给药途径属性
	s drugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()		// 用药频率属性
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()		// 单次剂量属性
	s onceDoseMax=##class(web.DHCCKBCommon).GetOnceDoseMaxProp() // 单次最大量属性
	s onceDoseLimit=##class(web.DHCCKBCommon).GetOnceDoseLimitProp() // 单次极限量
	s dayDose=##class(web.DHCCKBCommon).GetDayDoseProp()			// 日剂量属性
	s dayDoseMax=##class(web.DHCCKBCommon).GetDayDoseMaxProp()		// 日最大量
	s dayDoseLimit=##class(web.DHCCKBCommon).GetDayDoseLimitProp()	// 日极限量
	
	s ruleObj={}
	i childFlag = 1 d
	.d ruleObj.%Set("_name","普适规则(儿童)")
	.d ruleObj.%Set("remark","系统生成(儿童)")
	e  d
	.d ruleObj.%Set("_name","普适规则")
	.d ruleObj.%Set("remark","系统生成")
	
	d ruleObj.%Set("then","")
	// else 
	s outProp=##class(web.DHCCKBCommon).GetDicIdByCode("OutPrint")
	s sourceMsg=##class(web.DHCCKBCommon).GetDicIdByCode("SourceMsg")
	s valueObj={}
	d valueObj.%Set("_ruleData","0").%Set("_content","系统生成").%Set("_type","Input")
	s assign={}
	d assign.%Set("_varCategory",$case(+outProp'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(outProp)),3),:"")).%Set("_ruleData","0").%Set("_varCategoryId",outProp).%Set("_var",sourceMsg)
	d assign.%Set("_varLabel",$case(+sourceMsg'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(sourceMsg)),3),:"")).%Set("_datatype","String").%Set("_type","variable")
	d assign.%Set("value",valueObj)
	s elseObj={}.%Set("var-assign",assign)
	d ruleObj.%Set("else",elseObj)
	
	//if 
	s drugProp=##class(web.DHCCKBCommon).GetDrug()
	s atomArr=[]
	s orArr=[]
	s count=0
	// 给药途径
	s ptr=0	// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	s drugPreMet=##class(web.DHCCKBCommon).GetDrugPreMet()
	//s $list(preMetList,*+1) = "Constant"_$c(1)_"Equals"_$c(1)_"4353" 中药饮片的兜底规则中增加外用 途径 2021/9/26
	s premetAtomArr=[]
	if ($listlength(preMetList)>1) {
		d ..SetAtomArr(.premetAtomArr,preMetList,drugProp,drugPreMet)	
		d orArr.%Push({}.%Set("atom",premetAtomArr))
		
	}elseif ($listlength(preMetList)=1){
		d ..SetAtomArr(.atomArr,preMetList,drugProp,drugPreMet)
	}
	
	// 用药频率
	s drugFreq=##class(web.DHCCKBCommon).GetDrugFreqProp()
	s freqAtomArr=[]
	if ($listlength(freqList)>1) {
		d ..SetAtomArr(.freqAtomArr,freqList,drugProp,drugFreq)
		d orArr.%Push({}.%Set("atom",freqAtomArr))

	}elseif ($listlength(freqList)=1){
		d ..SetAtomArr(.atomArr,freqList,drugProp,drugFreq)	
	}

	// 次剂量/日剂量 
	s onceProp = $select($d(TmpArr("once","calcItm")):TmpArr("once","calcItm"),1:"")
	s dayProp = $select($d(TmpArr("day","calcItm")):TmpArr("day","calcItm"),1:"")

	i (onceDoseList'="")&(dayDoseList="") d	
	.d ..SetAtomArr(.atomArr,onceDoseList,drugProp,onceProp)
	i (onceDoseList="")&(dayDoseList'="") d
	.d ..SetAtomArr(.atomArr,dayDoseList,drugProp,dayProp)
	i (onceDoseList'="")&(dayDoseList'="") d
	.s doseAtomArr=[]
	.//d ..SetAtomArr(.doseAtomArr,onceDoseList,drugProp,onceProp)  // 次剂量/日剂量 节点关系是or
	.//d ..SetAtomArr(.doseAtomArr,dayDoseList,drugProp,dayProp)
	.//d orArr.%Push({}.%Set("atom",doseAtomArr))
	.d ..SetAtomArr(.atomArr,onceDoseList,drugProp,onceProp)	 // 次剂量/日剂量 节点关系是and  2022-03-29
	.d ..SetAtomArr(.atomArr,dayDoseList,drugProp,dayProp)
	
	s ifObj={}
	if (atomArr.%Size()'=0){
		s andObj={}
		if (atomArr.%Size()=1){
			d andObj.%Set("atom",atomArr.%Get(0))				
		}
		else{			
			d andObj.%Set("atom",atomArr)		
		}		
		if (orArr.%Size()=1){		
			d andObj.%Set("or",orArr.%Get(0))
		}elseif(orArr.%Size()>1){
			d andObj.%Set("or",orArr)
		}			
		d ifObj.%Set("and",andObj)		
	}else{	
		if (orArr.%Size()=1){
			d ifObj.%Set("or",orArr.%Get(0))			
		}elseif (orArr.%Size()>1){
			s andObj={}
			d andObj.%Set("or",orArr)
			d ifObj.%Set("and",andObj)				
		}
	
	}
	
	if ifObj.%Size()'=0 d ruleObj.%Set("if",ifObj)

	
	q ruleObj
}

/// Descript:  		查询生成兜底规则失败的药品及原因
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-05
///  Output: 		w ##Class(web.DHCCKBPrescTest).QueryErrBaseRuleMsg()
ClassMethod QueryErrBaseRuleMsg(rows = 30, page = 1, params = "")
{
	n (rows, page,params)
	
	s queryResult=$p(params,"^",1)
	s queryDrugName=$p(params,"^",2)
	s end = page*rows
	s start=(page-1)*rows+1
	s title = "drugId^drugName^ruleId^result^dataId^dataName^soulce"	// soulce:query 是查询列表, 空是兜底规则
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s count=0	
	s num=""
	f  s num=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg",num))	q:num=""  d
	.s data=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg",num))
	.s result=$listget(data,4)
	.s resultFlag=$select(result["单位不相同":1,result["比值符号存在冲突":2,result["数值或单位为空":3,result["非儿童特殊剂量":4,1:"")
	.q:(queryResult'="")&(queryResult'=resultFlag)
	.s drugName = $listget(data,2)
	.q:(queryDrugName'="")&(drugName'[queryDrugName)
	.s data=$listtostring(data,"^")
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,data)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符
	q ""
}

/// Descript:  		标记出用法用量中,非儿童且含有体表体重等的剂量(非儿童：人群是儿童等,或年龄是18岁以下)
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-05
///  Output: 		w ##Class(web.DHCCKBPrescTest).QueryErrBaseRuleMsg()
ClassMethod MarkNotChildDoseRule(TmpArr, drugId)
{
	n (TmpArr,drugId)
	
	s childList=$lb("小儿","婴儿","儿童","新生儿","青少年","婴幼儿","幼儿","新生儿（足月产）","学龄前儿童","学龄儿童","新生儿（早产儿）","新生儿（低体重儿）","早产儿")
	s specProp = ##class(web.DHCCKBCommon).GetSpecialPopProp()	// 特殊人群属性
	s ageProp = ##class(web.DHCCKBCommon).GetAgeProp()	// 年龄属性
	
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()		// 单次剂量属性
	s onceDoseMax=##class(web.DHCCKBCommon).GetOnceDoseMaxProp() // 单次最大量属性
	s onceDoseLimit=##class(web.DHCCKBCommon).GetOnceDoseLimitProp() // 单次极限量
	s dayDose=##class(web.DHCCKBCommon).GetDayDoseProp()			// 日剂量属性
	s dayDoseMax=##class(web.DHCCKBCommon).GetDayDoseMaxProp()		// 日最大量
	s dayDoseLimit=##class(web.DHCCKBCommon).GetDayDoseLimitProp()	// 日极限量	
	s markList = $lb(onceDose,onceDoseMax,onceDoseLimit,dayDose,dayDoseMax,dayDoseLimit)
	
	s exitFlag = 0
		
	s ruleDicID=""
	f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")||(exitFlag=1)  d
	.k TmpArr("nullValue")
	.s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	.s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),4)
	.q:ruleStauts'="Release"
	.s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(ruleId)
	.q:labelDesc'="用法用量"
	.s ageFlag = 0,doseFlag = 0,nullFlag =0
	.s parent=""
	.f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent))  q:(parent="")||(exitFlag=1)   d  
	..s node=""
	..f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent,node))  q:(node="")||(exitFlag=1)   d  
	...q:node=0
	...s ruleDataID=""
	...f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,ruleDataID))  q:(ruleDataID="")||(exitFlag=1)   d
	....q:ruleDataID=0
	....q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	....s value=..GetValue(ruleDataID)	// 记录普适项目的值： 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	....s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)	// 实体/属性（前提条件的项目代码）
	....//s calcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),2)
	....// 如果规则中含有单位且有斜杠,则标记规则
	....i $lf(markList,leftDic)	d
	.....s unit = $p(value,$c(1),5)
	.....s unitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)
	.....i unitDesc["/" s doseFlag = 1
	.....i ($p(value,$c(1),5)="")||($p(value,$c(1),3)="") s nullFlag=1
 	....
	....i leftDic = specProp d // 人群 // 如果规则中有儿童标记,则进行标记
	.....s valueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+$p(value,$c(1),3))),3)
	.....s:(valueDesc'="")&($lf(childList,valueDesc)) ageFlag = 1
	....
	....i leftDic = ageProp	d	// 年龄
	.....s:($p(value,$c(1),3)'="")&($p(value,$c(1),3)<=18) ageFlag = 1	
	.....s:($p(value,$c(1),4)'="")&($p(value,$c(1),4)<=18) ageFlag = 1
	....
	..
	.
	.
	.s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.s parrefData = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.s parrefDataName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parrefData)),3)
	.i doseFlag = 1 d
	..i ageFlag = 0 d
	...s TmpArr("nullValue")=$lb(drugId,drugName,ruleId,"非儿童特殊剂量",parrefData,parrefDataName,"query")	
	...d ..MarkErrMsg(.TmpArr)	// 记录不能生成的原因
	.
	.i nullFlag = 1 d		// 规则为空
	..s TmpArr("nullValue")=$lb(drugId,drugName,ruleId,"数值或单位为空,请核对",parrefData,parrefDataName,"query")	
	..d ..MarkErrMsg(.TmpArr)	// 记录不能生成的原因
		
	q ""
}

/// 导出兜底规则中查找出来的药品种类
Query ExportErrBaseRuleDrug() As websys.Query(ROWSPEC = "drugName:%String:药品名称")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportErrBaseRuleDrug") 
/// w ##Class(websys.Query).ToExcel("用法用量规则问题药品","web.DHCCKBPrescTest","ExportErrBaseRuleDrug")
ClassMethod ExportErrBaseRuleDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	d ..QueryErrDrug(.TmpArr)
	

	set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$g(TmpArr(index))
	.set ^CacheTemp(repid,ind)=$listfromstring(listData)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryErrDrug(TmpArr)
{
		n (TmpArr)
		s num=""
		f  s num=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg",num))	q:num=""  d
		.s data=$g(^TMP("DHCCKB","web.DHCCKBPrescTest","MarkErrMsg",num))
		.s drugName = $listget(data,2)
		.q:drugName=""
		.s TmpArr(drugName)=drugName
		q ""
}

/// Descript:  		寻找多条兜底规则
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-05
///  Output: 		w ##Class(web.DHCCKBPrescTest).GetBaseRule()
ClassMethod GetBaseRule()
{
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:drugId'=111055
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.s count = 0
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法"
	..s count = count +1
	..
	.
	.i count>1 d
	..w $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)_","_$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3),!
	
	q ""
}

/// Descript:  		遍历日志中的入参,重新进行第二次处方的测试
/// Creator:		QuNianpeng
/// CreateDate:		2020-12-15
///  Output: 		w ##Class(web.DHCCKBPrescTest).CheckPrecTest("2020-11-01","2020-11-30","哈尔滨医科大学第一附属医院(20201203)")
ClassMethod CheckPrecTest(stDate, endDate, hosp) As %String
{
	n (stDate,endDate,hosp)
	
	s stDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(stDate)
	s endDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(endDate)
	s ctLocList = $lb("ICU-ICU","bfnkzjyj-病房内科针剂药局","bfwkzjyj-病房外科针剂药局","gcwk-肛肠外科","gkyk-骨科一科","jczcwk-结肠直肠外科","mnwkek-泌尿外科二科","mnwksk-泌尿外科三科") 
	s $list(ctLocList,*+1)="mnwkyk-泌尿外科一科"	
	s $list(ctLocList,*+1)="rxwk-乳腺外科"
	s $list(ctLocList,*+1)="sjnkek-神经内科二科"
	s $list(ctLocList,*+1)="sjwksk-神经外科四科"
	s $list(ctLocList,*+1)="wcddwk-微创胆道外科"
	s $list(ctLocList,*+1)="wpmmgywk-胃脾门脉高压外科"
	s $list(ctLocList,*+1)="xxgnkwk-心血管内科五科"
	s $list(ctLocList,*+1)="xgjrwk-血管介入外科"
	s $list(ctLocList,*+1)="xgwk-血管外科"
	s $list(ctLocList,*+1)="yxb-药学部"
	s $list(ctLocList,*+1)="ydwk-胰胆外科"
	s $list(ctLocList,*+1)="zlqjwk-肿瘤腔镜外科"
	// //哈尔滨医科大学第一附属医院(20201203)
	s count = 0
	f date=stDate:1:endDate  d
	.s monID = ""
	.f  s monID = $o(^DHCCKBMM(0,"HospDate",hosp,date,monID))  q:monID=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monID))
	..s ctLoc = $lg(monData,6)
	..q:$listfind(ctLocList,ctLoc)=0 // 11-01  11/30
	..s params = $lg(monData,9)
	..s params = $tr(params,"\")
	..s paramsObj=##class(DHCNewPro.COM.Object).FromJSON(params)
	..s paramsObj.Hospital = "哈尔滨医科大学第一附属医院(20201224)"
	..s retStr=""
	..d ##Class(web.DHCCKBPassNew).IntMakPolPass(paramsObj.ToJSON(),.retStr)
	..s count = count +1
	
	q count
}

/// Descript:  		查询有标记的规则(有争议),导入数据1w条数据,提供给大通
/// Creator:		QuNianpeng
/// CreateDate:		2020-12-28
///  Output: 		w ##Class(web.DHCCKBPrescTest).ExportPrescToDT()
/// .s TmpArr(count)=$lb(num,"",age,sex,hisAllergy,weight,height,diseaseStr,drugName,drugForm,drugDose,drugDoseUnit,drugFreq,drugPreMet,treatment,drugSeqNo,linkSeqNo,ordDate)
Query ExportPrescToDT() As websys.Query(ROWSPEC = "num:%String:处方号,adm:%String:就诊号,age:%String:年龄,sex:%String:性别,hisAllergy:%String:过敏信息,weight:%String:体重,height:%String:身高,diseaseStr:%String:诊断,drugName:%String:药品名称,drugForm:%String:剂型,drugDose:%String:单次剂量,drugDoseUnit:%String:单次剂量单位,drugFreq:%String:频率,drugPreMet:%String:给药途径,treatment:%String:疗程,drugSeqNo:%String:序号,linkSeqNo:%String:关联序号,ordDate:%String:医嘱日期")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportPrescToDT") 
/// w ##Class(websys.Query).ToExcel("test1","web.DHCCKBPrescTest","ExportPrescToDT")
ClassMethod ExportPrescToDTExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	//d ..QueryPrescMark(.TmpArr)
	d ..QueryPresc(.TmpArr)

	set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$g(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBPrescTest).QueryPrescMark()
ClassMethod QueryPrescMark(TmpArr)
{
	n (TmpArr)
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT DISTINCT CM_ExaParam FROM CKB_PDSS.MonMaster WHERE CM_RowID IN (SELECT DISTINCT CM_Parrf_Dr  FROM CKB_PDSS.MonQueList WHERE CM_Sings IN (""verifycorrect"",""affirmcorrect""))"
	
	//S sqlStr = "SELECT DISTINCT TOP 6585 CM_ExaParam  FROM CKB_PDSS.MonMaster WHERE CM_CreateDate BETWEEN ""2020/11/01"" AND  ""2020/11/30"" "
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0

	While(result.Next())
	{	
		s exaParam = result.Data("CM_ExaParam")
		s exaObj = ##class(DHCNewPro.COM.Object).FromJSON(exaParam)
		
		// 患者信息
		s diseaseStr = ""	// 诊断
		s diseaseArr = exaObj.Disease
		i diseaseArr'= "" d
		.s len = diseaseArr.Size()
		.f m = 0:1:len-1  d 
		..s diseaseObj = diseaseArr.Get(m)
		..s $list(diseaseStr,*+1) = diseaseObj.item
		s:diseaseStr'="" diseaseStr=$listtostring(diseaseStr,";")
		// 过敏史		
		s hisAllergy = ""	
		s hisAllergyArr = exaObj.HisAllergy
		i hisAllergyArr'="" d
		.s len = hisAllergyArr.Size()
		.f m = 0:1:len-1  d 
		..s hisAllergyObj = hisAllergyArr.Get(m)
		..s $list(hisAllergyArr,*+1) = hisAllergyObj.item
		s:hisAllergy'="" hisAllergy=$listtostring(hisAllergy,";")
		s height = exaObj.Height // 身高
		s weight = exaObj.Weight // 体重
		s sex = exaObj.SexProp	 // 性别
		s age = exaObj.AgeProp	 // 出生日期
		s num = $Now()
		s num = $tr(num,",",".")
		// 药品信息
		s drugArr = exaObj.Drug
		continue:drugArr="" 
		s exitFlag = 0
		s len = drugArr.Size()
		f k = 0:1:len-1  d
		.s drugObj = drugArr.Get(k)
		.s drugName = drugObj.item		// 药品名称
		.q:drugName=""
		.s drugSeqNo = drugObj.SeqNo	// 序号
		.s drugForm = drugObj.FormProp	// 剂型
		.s drugDose = drugObj.OnceDose	// 单次剂量
		.s drugDoseUnit = drugObj.Unit	// 剂量单位
		.s drugPreMet = drugObj.DrugPreMet	// 给药途径
		.s drugFreq = drugObj.DrugFreq	// 用药频率
		.s:drugFreq="" drugFreq=drugObj.DrugDrugFreq
		.s:drugFreq="" drugFreq=drugObj.DrugFreqFreq
		.s treatment = drugObj.Treatment	// 疗程
		.s linkSeqNo = drugObj.LinkSeqNo	// 关联序号
		.s ordDate = drugObj.OrdDate	// 医嘱日期
		.s isFirstUse = drugObj.IsFirstUseProp	// 是否首次
		.s count = count +1 
 		.s TmpArr(count)=$lb(num,"",age,sex,hisAllergy,weight,height,diseaseStr,drugName,drugForm,drugDose,drugDoseUnit,drugFreq,drugPreMet,treatment,drugSeqNo,linkSeqNo,ordDate)
				
	}
	
	q ""
}

/// w ##class(web.DHCCKBPrescTest).QueryPresc()
ClassMethod QueryPrescSql(TmpArr)
{
	n (TmpArr)
	S result = ##class(%Library.ResultSet).%New()
	//S sqlStr = "SELECT DISTINCT TOP 6585 CM_ExaParam  FROM CKB_PDSS.MonMaster WHERE CM_CreateDate>=65684 AND CM_CreateDate<=65713 and CM_Hosp=""哈尔滨医科大学第一附属医院(20201203)"" "
    S sqlStr = "SELECT DISTINCT  CM_ExaParam  FROM CKB_PDSS.MonMaster WHERE CM_Hosp=""哈尔滨医科大学第一附属医院(20201203)"" "
  
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	s tmpNum = 0

	While(result.Next())
	{	
		s exaParam = result.Data("CM_ExaParam")
		s exaObj = ##class(DHCNewPro.COM.Object).FromJSON(exaParam)
		
		// 患者信息
		s diseaseStr = ""	// 诊断
		s diseaseArr = exaObj.Disease
		i diseaseArr'= "" d
		.s len = diseaseArr.Size()
		.f m = 0:1:len-1  d 
		..s diseaseObj = diseaseArr.Get(m)
		..s $list(diseaseStr,*+1) = diseaseObj.item
		s:diseaseStr'="" diseaseStr=$listtostring(diseaseStr,";")
		// 过敏史		
		s hisAllergy = ""	
		s hisAllergyArr = exaObj.HisAllergy
		i hisAllergyArr'="" d
		.s len = hisAllergyArr.Size()
		.f m = 0:1:len-1  d 
		..s hisAllergyObj = hisAllergyArr.Get(m)
		..s $list(hisAllergyArr,*+1) = hisAllergyObj.item
		s:hisAllergy'="" hisAllergy=$listtostring(hisAllergy,";")
		s height = exaObj.Height // 身高
		s weight = exaObj.Weight // 体重
		s sex = exaObj.SexProp	 // 性别
		s age = exaObj.AgeProp	 // 出生日期
		s num = $Now()
		s num = $tr(num,",",".")
		// 药品信息
		s drugArr = exaObj.Drug
		continue:drugArr="" 
		s tmpNum = tmpNum +1
		q:tmpNum>6585
		s exitFlag = 0
		s len = drugArr.Size()
		f k = 0:1:len-1  d
		.s drugObj = drugArr.Get(k)
		.s drugName = drugObj.item		// 药品名称
		.q:drugName=""
		.s drugSeqNo = drugObj.SeqNo	// 序号
		.s drugForm = drugObj.FormProp	// 剂型
		.s drugDose = drugObj.OnceDose	// 单次剂量
		.s drugDoseUnit = drugObj.Unit	// 剂量单位
		.s drugPreMet = drugObj.DrugPreMet	// 给药途径
		.s drugFreq = drugObj.DrugFreq	// 用药频率
		.s:drugFreq="" drugFreq=drugObj.DrugDrugFreq
		.s:drugFreq="" drugFreq=drugObj.DrugFreqFreq
		.s treatment = drugObj.Treatment	// 疗程
		.s linkSeqNo = drugObj.LinkSeqNo	// 关联序号
		.s ordDate = drugObj.OrdDate	// 医嘱日期
		.s isFirstUse = drugObj.IsFirstUseProp	// 是否首次
		.s count = count +1 
 		.s TmpArr(count)=$lb(num,"",age,sex,hisAllergy,weight,height,diseaseStr,drugName,drugForm,drugDose,drugDoseUnit,drugFreq,drugPreMet,treatment,drugSeqNo,linkSeqNo,ordDate)
				
	}
	
	q tmpNum
}

/// w ##class(web.DHCCKBPrescTest).QueryPresc()
ClassMethod QueryPresc(TmpArr)
{
	n (TmpArr)
	s hosp = "哈尔滨医科大学第一附属医院(20201203)"
	s stDate = "2020-11-01"
	s stDate = $zdh(stDate,3)
	s endDate = "2020-11-30"
	s endDate = $zdh(endDate,3)
	
	s tmpNum = 0,count = 0 
	s date = ""
	f date=stDate:1:endDate q:(tmpNum>6585)  d
	.s masterID = ""
	.f  s masterID = $o(^DHCCKBMM(0,"HospDate",hosp,date,masterID))	q:(masterID="")||(tmpNum>6585)  d
	..s exaParam = $lg(^CKB.PDSS.MonMasterD(+masterID),9)
	..s exaObj = ##class(DHCNewPro.COM.Object).FromJSON(exaParam)	
	..// 患者信息
	..s diseaseStr = ""	// 诊断
	..s diseaseArr = exaObj.Disease
	..i diseaseArr'= "" d
	...s len = diseaseArr.Size()
	...f m = 0:1:len-1  d 
	....s diseaseObj = diseaseArr.Get(m)
	....s $list(diseaseStr,*+1) = diseaseObj.item
	..s:diseaseStr'="" diseaseStr=$listtostring(diseaseStr,";")
	..// 过敏史		
	..s hisAllergy = ""	
	..s hisAllergyArr = exaObj.HisAllergy
	..i hisAllergyArr'="" d
	...s len = hisAllergyArr.Size()
	...f m = 0:1:len-1  d 
	....s hisAllergyObj = hisAllergyArr.Get(m)
	....s $list(hisAllergyArr,*+1) = hisAllergyObj.item
	..s:hisAllergy'="" hisAllergy=$listtostring(hisAllergy,";")
	..s height = exaObj.Height // 身高
	..s weight = exaObj.Weight // 体重
	..s sex = exaObj.SexProp	 // 性别
	..s age = exaObj.AgeProp	 // 出生日期
	..s num = $Now()
	..s num = $tr(num,",",".")
	..// 药品信息
	..s drugArr = exaObj.Drug
	..q:drugArr="" 
	..s tmpNum = tmpNum +1
	..s exitFlag = 0
	..s len = drugArr.Size()
	..f k = 0:1:len-1  d
	...s drugObj = drugArr.Get(k)
	...s drugName = drugObj.item		// 药品名称
	...q:drugName=""
	...s drugSeqNo = drugObj.SeqNo	// 序号
	...s drugForm = drugObj.FormProp	// 剂型
	...s drugDose = drugObj.OnceDose	// 单次剂量
	...s drugDoseUnit = drugObj.Unit	// 剂量单位
	...s drugPreMet = drugObj.DrugPreMet	// 给药途径
	...s drugFreq = drugObj.DrugFreq	// 用药频率
	...s:drugFreq="" drugFreq=drugObj.DrugDrugFreq
	...s:drugFreq="" drugFreq=drugObj.DrugFreqFreq
	...s treatment = drugObj.Treatment	// 疗程
	...s linkSeqNo = drugObj.LinkSeqNo	// 关联序号
	...s ordDate = drugObj.OrdDate	// 医嘱日期
	...s isFirstUse = drugObj.IsFirstUseProp	// 是否首次
	...s count = count +1 
	...s TmpArr(count)=$lb(num,"",age,sex,hisAllergy,weight,height,diseaseStr,drugName,drugForm,drugDose,drugDoseUnit,drugFreq,drugPreMet,treatment,drugSeqNo,linkSeqNo,ordDate)

	q tmpNum
}

/// Descript:  		统计有核实标记的药品数量(规则:药品被打上标记,或者药品的某一条规则被打上标记,都算)
/// Creator:		QuNianpeng
/// CreateDate:		2021-1-26 
Query QueryConfirmDrugList() As websys.Query(ROWSPEC = "drugID:%String:药品id,drugCode:%String:代码,drugDesc:%String:描述,drugType:%String:字典,flag:%String:标记")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","QueryConfirmDrugList") 
/// w ##Class(websys.Query).ToExcel("核实标记药品列表","web.DHCCKBPrescTest","QueryConfirmDrugList")
ClassMethod QueryConfirmDrugListExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	s parref = ##class(DHCCKBCommon).GetDrugData()	// 西药
	s drugCount = ..QueryConfirmDrugNum(.TmpArr,parref)
	
	s parref = ##class(DHCCKBCommon).GetChineseDrugData()	// 中成药
	s ChdrugCount = ..QueryConfirmDrugNum(.TmpArr,parref)
	
	set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData = $g(TmpArr(index))
	.set listData = $listfromstring(listData,"^")
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	w "西药共:"_$p(drugCount,",",1)_"个"_",已核实:"_$p(drugCount,",",2)_"个.",!
	w "中成药共:"_$p(ChdrugCount,",",1)_"个"_",已核实:"_$p(ChdrugCount,",",2)_"个.",!

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	统计有核实标记的药品数量(规则:药品被打上标记,或者药品的某一条规则被打上标记,都算)
/// Creator:		QuNianpeng 
/// CreateDate:		2021-1-26
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBPrescTest).QueryConfirmDrugNum()
ClassMethod QueryConfirmDrugNum(TmpArr, parref) As %String
{
	// 遍历药品,判断是否有标记,或者规则有标记,就计数
	n (TmpArr,parref)
	s count = 0, total = 0
	s drugId = ""
	f  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,drugId))  q:drugId=""  d
	.s total = total + 1
	.s drugFirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugId,"confirm"))	// 药品核实
	.s:drugFirmFlag>0 count = count + 1,TmpArr(drugId)=drugId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)_"^"_"药品核实"
	.q:drugFirmFlag>0
	.s ruleFirmFlag = ..isConfirmByRule(drugId)	// 规则核实
	.s:ruleFirmFlag=1 count = count + 1,TmpArr(drugId)=drugId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)_"^"_"规则核实"
	
	q total_","_count
}

/// Description:	判断药品规则是否有核实标记
/// Creator:		QuNianpeng 
/// CreateDate:		2021-1-26
/// Input:			药品id
/// return:			1 核实 0 未核实
/// other:			w ##class(web.DHCCKBPrescTest).isConfirmByRule()
ClassMethod isConfirmByRule(drugId) As %String
{
	n (drugId)
	q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) ""
	
	s exitFlag = 0
	s ruleDicID = ""
	f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID))  q:(ruleDicID="")||(exitFlag=1)  d
	.s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	.q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",rule,"confirm"))	// 规则核实
	.s exitFlag = 1

	q exitFlag
}

// Description:	药品去重(规则:带剂型的通用名+规格/等效单位)相同,优先展示审核过的(药品有审核标记或规则有审核标记),修订日期靠前,厂家比较大,靠前(厂家列表),优先国外

/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBPrescTest).UniqueAllDrug()
ClassMethod UniqueAllDrug() As %String
{
	//1. 遍历所有的药品,获取药品通用名,等效单位,剂型
	//2. 相同的药品记录一次,获取修订日期,厂家,比较
	
	k ^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug")
	//d ..UniqueDrug()	// 西药
	//d ..UniqueChinaDrug()	// 中成药
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s listTitle="id^code^desc^parref"
	s id = "",count = 0
	f  s id=$o(^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug",id))  q:id=""  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref =$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s:+parref'=0 parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s listData=id_"^"_code_"^"_desc_"^"_parref
	.s count=count + 1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	
	q ""
}

/// 导出诊断匹配结果
/// w ##Class(websys.Query).ToExcel("诊断对照结果（模糊匹配3）","web.DHCCKBPrescTest","ExportMatchDiag")
Query ExportUniqueAllDrug() As websys.Query(ROWSPEC = "f1:%String:his诊断,f2:%String:知识库诊断id,f3:%String:知识库诊断描述,f4:%String:知识库别名")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportMatchDiag") 
/// @param: pid 进程号
ClassMethod ExportUniqueAllDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	//d ..MatchDiag(.TmpArr) // 精准匹配
	d ..FuzzyMatchDiag(.TmpArr) // 模糊匹配
	

	set index=""
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	药品去重(规则:带剂型的通用名+规格/等效单位)相同,优先展示审核过的(药品有审核标记或规则有审核标记),修订日期靠前,厂家比较大,靠前(厂家列表),优先国外
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBPrescTest).UniqueDrug()
ClassMethod UniqueDrug() As %String
{
	k TmpArr
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s id = "",count=0
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,id))	q:id=""  d
	.q:0=##class(web.DHCCKBCommon).IsEnabled(id)
	.q:$d(TmpArr("mark",id))
	.s count = count + 1
	.w count,!
	.s generalFromList=##class(web.DHCCKBCommon).GetGeneralFrom(id,0)	// 带剂型的通用名
	.s contrastId=id,isEqualFlag=0
	.f  s contrastId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,contrastId))	q:(contrastId="")  d
	..q:0=##class(web.DHCCKBCommon).IsEnabled(contrastId)
	..q:$d(TmpArr("mark",contrastId))
	..q:contrastId=id
	..// 带剂型的通用名比较
	..s conGeneralFromList=##class(web.DHCCKBCommon).GetGeneralFrom(contrastId,0) // 带剂型的通用名
	..s generalFlag=##class(web.DHCCKBCommonUtil).CompareBothList(generalFromList,conGeneralFromList)	// 求交集
	..q:generalFlag=0
	..// 等效单位比较
	..k unitArr1,unitArr2
	..d ..GetEqFactorList(id,.unitArr1)
	..d ..GetEqFactorList(contrastId,.unitArr2)
	..s unitFlag = ..CompareEqFactor(.unitArr1,.unitArr2)
	..q:unitFlag=0
	..s TmpArr("mark",contrastId)=""	// 到这里时,带剂型的通用名+规格,等效单位相同.记录下此类数据
	..s isEqualFlag = 1 
	..s $list(TmpArr("group",count),*+1)=contrastId
	.
	.i $d(TmpArr("group",count))&&($listlength(TmpArr("group",count))>0) d
	..s $list(TmpArr("group",count),*+1)=id
	..s TmpArr("mark",id)=""
	.
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug",id)="" // 这里记录的是不能去重的数据
	
	
	s index=""
	s tmpId="",exitFlag = 0
	f  s tmpId=$o(TmpArr("group",index)) q:index=""  d
	.s drugList=$g(TmpArr("group",index))
	.q:drugList=""
	.s tmpId=""
	.f k=1:1:$listlength(drugList) q:exitFlag=1  d
	..s tmpId=$listget(drugList,k)
	..s isConfirmFlag = ..isConfirm(tmpId) // 药品审核标记
	..i isConfirmFlag=1 s ^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug",tmpId)=drugList,exitFlag=1
	..q:exitFlag=1
	..s drugManfPropId=##class(web.DHCCKBCommon).GetDrugManf()
	..s factory = ##class(web.DHCCKBEditProp).QueryAttrValue(tmpId,drugManfPropId)
	..i $d(^TMP("DHCCKB","Factory",factory))  s ^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug",tmpId)=drugList,exitFlag=1
	..q:exitFlag=1
	.// 没有按照优先级输出时,输出第一个
	.i exitFlag=0 d
	..s tmpId=$listget(TmpArr("group",index))
	..s ^TMP("DHCCKB","web.DHCCKBPrescTest","UniqueAllDrug",tmpId)=drugList
	
		
	q ""
}

/// Description:	药品是否有核实标记(规则:药品被打上标记,或者药品的某一条规则被打上标记,都算)
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			1 标记 0 未标记
/// other:			w ##class(web.DHCCKBPrescTest)isConfirm()
ClassMethod isConfirm(drugId) As %String
{
	n (drugId)
	s ret = 0
	s drugFirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugId,"confirm"))	// 药品核实
	s:drugFirmFlag>0 ret=1
	q:ret>0 ret
	s ruleFirmFlag = ..isConfirmByRule(drugId)	// 规则核实
	s:ruleFirmFlag=1 ret=1
	
	q ret
}

/// Description:	比较等效单位是否相同
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			等效单位数组
/// return:			1相等 0 不相等
/// other:			w ##class(web.DHCCKBPrescTest).CompareEqFactor()
ClassMethod CompareEqFactor(unitArr1, unitArr2) As %String
{
	n (unitArr1,unitArr2)
	s flag = 0
	s fUnit =""
	f  s fUnit=$o(unitArr1(fUnit))	q:(fUnit="")||(flag=1)  d
	.s tUnit=""
	.f  s tUnit=$o(unitArr1(fUnit,tUnit))  q:(tUnit="")||(flag=1)  d
	..q:('$d(unitArr2(fUnit,tUnit)))&('$d(unitArr2(tUnit,fUnit)))	
	..s factor=$g(unitArr1(fUnit,tUnit))
	..s factorTmp1=$g(unitArr2(fUnit,tUnit))
	..s factorTmp2=$g(unitArr2(tUnit,fUnit))
	..q:(factor'="")&(factor'=factorTmp1)&(factor'=factorTmp2)
	..s flag = 1
	
	q flag
}

/// Description:	获取药品的等效单位
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBPrescTest).GetEqFactorList()
ClassMethod GetEqFactorList(drugId, unitArr) As %String
{
	n (drugId,unitArr)
	s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位属性
	s linkProp=##class(web.DHCCKBCommon).GetLinkProp()			// 属性关联
	s linkAttr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",eqUnitProp,linkProp,""))	// 单位转换系数关联的属性（模板）
	s frUomProp=##class(web.DHCCKBCommon).GetEqFromUnitProp()
	s toUomProp=##class(web.DHCCKBCommon).GetEqToUnitProp()
	s facProp=##class(web.DHCCKBCommon).GetEqFactorProp()
	
	s unitChangeTemp=linkAttr		// 单位转换模板	
	k tmpUnitArr
	s childProp=""
	f  s childProp=$o(^CT.CKB.PDSS.CommonDictionI("Parref",unitChangeTemp,childProp))  q:childProp=""  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp))
	.s attrId=""
	.f  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp,attrId))  q:attrId=""   d
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	..i childProp=frUomProp s $p(tmpUnitArr(group),"^",1)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=toUomProp s $p(tmpUnitArr(group),"^",2)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=facProp s $p(tmpUnitArr(group),"^",3)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5),:"")

	s index=""
	f   s index=$o(tmpUnitArr(index))  q:index=""  d
	.s fUnit=$p(tmpUnitArr(index),"^",1)
	.s tUnit=$p(tmpUnitArr(index),"^",2)
	.s num=$p(tmpUnitArr(index),"^",3)
	.q:(fUnit="")||(tUnit="")
	.s unitArr(fUnit,tUnit)=$case(+num=0,1:"",:+num)
	.s unitArr(tUnit,fUnit)=$case(+num=0,1:"",:(1/num))

	q ""
}

/// Description:	获取药品的等效单位
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBPrescTest).SetFactory()
ClassMethod SetFactory(drugId) As %String
{
	//s ^TMP("DHCCKB","Factory",)=""
	s ^TMP("DHCCKB","Factory","江苏恒瑞医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","正大天晴药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","齐鲁制药有限公司")=""
	s ^TMP("DHCCKB","Factory","扬子江药业集团有限公司")=""
	s ^TMP("DHCCKB","Factory","百济神州")=""
	s ^TMP("DHCCKB","Factory","上海复星医药（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","东阳光药业")=""
	s ^TMP("DHCCKB","Factory","四川科伦药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏豪森药业集团有限公司")=""
	s ^TMP("DHCCKB","Factory","上海医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","人福医药集团股份公司")=""
	s ^TMP("DHCCKB","Factory","海思科医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江海正药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","和记黄埔医药（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳信立泰药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","贝达药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华东医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","健康元药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天士力医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东罗欣药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州信诺维医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","四环医药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","上海现代制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州泽璟生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄以岭药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江华海药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东步长制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","福建广生堂药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广州白云山医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都倍特药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","迪哲（江苏）医药有限公司")=""
	s ^TMP("DHCCKB","Factory","广州必贝特医药技术有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄四药有限公司")=""
	s ^TMP("DHCCKB","Factory","瑞石生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江同源康医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄智康弘仁新药开发有限公司")=""
	s ^TMP("DHCCKB","Factory","杭州三因泰医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","上海拓臻生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","山东齐都药业有限公司")=""
	s ^TMP("DHCCKB","Factory","中国医药健康产业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏恩华药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","青峰医药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","乐普医疗")=""
	s ^TMP("DHCCKB","Factory","华润双鹤药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","基石药业")=""
	s ^TMP("DHCCKB","Factory","苏州开拓药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天津红日药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都康弘药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都苑东生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","中国科学院上海药物研究所")=""
	s ^TMP("DHCCKB","Factory","南京圣和药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华北制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","绿叶制药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","鲁南制药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","亿帆医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏艾迪药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东新华制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","南京健友生化制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","普洛药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东金城医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","常州千红生化制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","福安药业（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江康恩贝制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华中药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","湖南景峰医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州亚盛药业有限公司")=""
	s ^TMP("DHCCKB","Factory","上海绿谷制药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京诺诚健华医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","再鼎医药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","瑞阳制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","歌礼生物科技（杭州）有限公司")=""
	s ^TMP("DHCCKB","Factory","北京福元医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江京新药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海同联制药有限公司")=""
	s ^TMP("DHCCKB","Factory","无锡合全药业有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏艾力斯生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京加科思新药研发有限公司")=""
	s ^TMP("DHCCKB","Factory","广州领晟医疗科技有限公司")=""
	s ^TMP("DHCCKB","Factory","华润三九医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东鲁抗医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","武汉恒信源药业有限公司")=""
	s ^TMP("DHCCKB","Factory","丹诺医药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","湖南华纳大药厂股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江新和成股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广东众生睿创生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳艾欣达伟医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","天津市医药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","南昌弘益药业有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏亚盛医药开发有限公司")=""
	s ^TMP("DHCCKB","Factory","北京硕佰医药科技有限责任公司")=""
	s ^TMP("DHCCKB","Factory","杭州和正医药有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江劲方药业有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州韬略生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","再鼎医药（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","广州南鑫药业有限公司")=""
	s ^TMP("DHCCKB","Factory","天津天药药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广东众生药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天津尚德药缘科技股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海复星医药（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏恒瑞医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","信达生物制药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","百奥泰生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海君实生物医药科技股份有限公司")=""
	s ^TMP("DHCCKB","Factory","三生国健药业（上海）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","神州细胞工程有限公司")=""
	s ^TMP("DHCCKB","Factory","齐鲁制药有限公司")=""
	s ^TMP("DHCCKB","Factory","上海生物制品研究所有限责任公司")=""
	s ^TMP("DHCCKB","Factory","百济神州")=""
	s ^TMP("DHCCKB","Factory","丽珠医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","荣昌生物制药（烟台）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天境生物科技（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","安徽安科生物工程（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳信立泰药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","舒泰神（北京）生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","康希诺生物股份公司")=""
	s ^TMP("DHCCKB","Factory","四川百利药业有限责任公司")=""
	s ^TMP("DHCCKB","Factory","鸿运华宁（杭州）生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","宜明昂科生物医药技术（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","成都康弘药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","武汉生物制品研究所有限责任公司")=""
	s ^TMP("DHCCKB","Factory","重庆智飞生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海泽生制药有限公司")=""
	s ^TMP("DHCCKB","Factory","勃林格殷格翰生物药业（中国）有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州康宁杰瑞生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","基石药业")=""
	s ^TMP("DHCCKB","Factory","四川三叶草生物制药有限公司")=""
	s ^TMP("DHCCKB","Factory","石药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏金迪克生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","康立泰药业有限公司")=""
	s ^TMP("DHCCKB","Factory","重庆智翔金泰生物制药有限公司")=""
	s ^TMP("DHCCKB","Factory","天台银康生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","海口奇力制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","四川科伦药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","长春高新技术产业（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","四川远大蜀阳药业有限责任公司")=""
	s ^TMP("DHCCKB","Factory","北京科兴生物制品有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江海正药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东博安生物技术有限公司")=""
	s ^TMP("DHCCKB","Factory","厦门特宝生物工程股份有限公司")=""
	s ^TMP("DHCCKB","Factory","北京天坛生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏荃信生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京天广实生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳康泰生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","中山康方生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京绿竹生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海爱萨尔生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","上海细胞治疗集团有限公司")=""
	s ^TMP("DHCCKB","Factory","杭州翰思生物医药有限公司")=""
}

/// Description:	导入中药饮片规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			filepath：文件路径,exportFlag是否导出, autoFlag 是否生成兜底规则,userInfo 用户信息
/// return:	
/// w ##Class(web.DHCCKBPrescTest).ImportChinaHMRule("D:\知识图谱\中药饮片\饮片药嘱系统规则-all.txt","N","N","11871^8^1^289^2")
ClassMethod ImportChinaHMRule(filepath As %String, exportFlag = "Y", autoFlag = "N", userInfo = "11871^8^1^289^2") As %String
{

	N (filepath,exportFlag,autoFlag,userInfo)
		
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	s allergy=""
	s title=""
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.s hCount=hCount+1
	.s impDataList=$tr(impDataList,$c(10),"")
	.s impDataList=$tr(impDataList,$c(10,13),"")
	.s impDataList=$tr(impDataList,$c(13),"")
	.s impDataList=$tr(impDataList," ","")
	.s impDataList=$tr(impDataList,"""","")
	.i hCount=1 s title=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRule","title")=title
	.s Err=""
	.q:hCount=1
	.s drugCode = $p(impDataList,"^",1)		// 药品代码
	.s drugDesc = $p(impDataList,"^",2)		// 药品名称
	.i (drugCode="")||(drugCode="无") s drugCode=drugDesc 
	.s useageText = $p(impDataList,"^",3)	// 用法用量描述
	.s preMet = $p(impDataList,"^",4)		// 用法
	.s minDose = $p(impDataList,"^",5)		// 最小量(单次)
	.s maxDose = $p(impDataList,"^",6)		// 最大量(单次)
	.s limitDose = $p(impDataList,"^",7)	// 审核最大剂量(极限量)(单次)
	.s pregnantFo = $p(impDataList,"^",8) 	// 妊娠禁用(0否,1是)
	.s pregnantWarn = $p(impDataList,"^",9) // 妊娠慎用(0否,1是)
	.s breastFeed = $p(impDataList,"^",10) 	// 哺乳期妇女禁用(0否,1是)
	.s menstruation = $p(impDataList,"^",11) // 女性经期慎用(0否,1是)
	.q:drugDesc=""
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRule",pid,hCount)=impDataList
	c filepath 
	
	//q pid
	s errCount=..ImportHMRule(pid,userInfo)
	
	w "共:"_hCount_"个药品,"_"失败:"_errCount_"个药品"
	quit ""
}

/// Description:	导入中药饮片规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			filepath：文件路径,userInfo 用户信息
/// return:	
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("")
ClassMethod ImportHMRule(pid As %String, userInfo As %String) As %String
{
	n (pid,userInfo)
	
	s hCount = "",errCount=0
	f  s hCount = $o(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRule",pid,hCount))	q:hCount=""  d
	.s impDataList = $g(^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRule",pid,hCount))
	.s drugCode = $p(impDataList,"^",1)		// 药品代码
	.s drugName = $p(impDataList,"^",2)	 
	.i (drugCode="")||(drugCode="无") s drugCode=drugName 
	.s usageText = $p(impDataList,"^",3)	// 用法用量描述
	.s preMet = $p(impDataList,"^",4)		// 用法
	.s minDose = $p(impDataList,"^",5)		// 最小量(单次)
	.s maxDose = $p(impDataList,"^",6)		// 最大量(单次)
	.s limitDose = $p(impDataList,"^",7)	// 审核最大剂量(极限量)(单次)
	.s pregnantFo = $p(impDataList,"^",8) 	// 妊娠禁用(0否,1是)
	.s pregnantWarn = $p(impDataList,"^",9) // 妊娠慎用(0否,1是)
	.s breastFeed = $p(impDataList,"^",10) 	// 哺乳期妇女禁用(0否,1是)
	.s menstruation = $p(impDataList,"^",11) // 女性经期慎用(0否,1是)
	.// 获取药品id
	.s parref = ##class(web.DHCCKBCommon).GetChineseHMData() // 中药饮片字典
	.s drugId = ##class(web.DHCCKBRuleImport).CheckDictionExist(drugCode,drugName,parref)
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRuleErr",drugName,"drug")=$lb(drugName,"系统中改药品不存在")	// 记录没有导入的药品
	.q:drugName=""
	.TS
	.// 保存用法用量规则
	.s ret1=..SaveUsageRule(drugName,drugId,usageText,preMet,minDose,maxDose,limitDose,userInfo)
	.// 保存禁忌症规则
	.s ret2=..SaveRuleContrForbid(drugName,drugId,pregnantFo,breastFeed,userInfo)
	.s ret3=..SaveRuleContrWarn(drugName,drugId,pregnantWarn,menstruation,userInfo)
	.i (ret1=0)||(ret2=0)||(ret3=0) s errCount=errCount+1
	.i (ret1=0)||(ret2=0)||(ret3=0) tro
	.e  tc
	
	q errCount
}

/// Description:	保存用法用量的规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			
/// return:	
/// w ##Class(web.DHCCKBPrescTest).SaveUsageRule("")
ClassMethod SaveUsageRule(drugName, drugId, usageText, preMet, minDose, maxDose, limitDose, userInfo) As %String
{
	n (drugName,drugId,usageText,preMet,minDose,maxDose,limitDose,userInfo)
	
	s atomArr=[],orArr=[],exitFlag=0,err=1
	s unitData = ##class(web.DHCCKBCommon).GetUnitData()
	s unitID = ##class(web.DHCCKBCommon).GetDicIdByCode("g",unitData)
	// 单次给药剂量
	i (minDose'="")&(maxDose'="")  d
	.s exitFlag=1
	.s tmpStr="Between"_"@"_minDose_"@"_unitID_"@"_maxDose_"@"_unitID
	.s tmpObj=##class(web.DHCCKBRuleImport).GetCommonObj("onceDose",tmpStr)
	.s:(+tmpObj<=0)||(tmpObj={}) msg=..MarkErrInfo(drugName,"onceDose")
	.q:(+tmpObj<=0)||(tmpObj={}) 
	.i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 	
	
	// 单次极限量
	i limitDose'=""  d
	.s exitFlag=1
	.s tmpStr="<="_"@"_"@"_"@"_limitDose_"@"_unitID
	.s tmpObj=##class(web.DHCCKBRuleImport).GetCommonObj("onceDoseLimit",tmpStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..MarkErrInfo(drugName,"onceDoseLimit")
	.q:(+tmpObj<=0)||(tmpObj={}) 
	.i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 	
	
	// 给药途径
	i (preMet'="")&(exitFlag=1)  d
	.s preMetData = ##class(web.DHCCKBCommon).GetDrugPreMetData()
	.s preMetID = ##class(web.DHCCKBRuleImport).CheckDictionExist(preMet,preMet,preMetData)
	.q:preMetID=0
	.s tmpObj=##class(web.DHCCKBRuleImport).GetCommonObj("linkPreMet",preMetID)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..MarkErrInfo(drugName,"linkPreMet")	
	.q:(+tmpObj<=0)||(tmpObj={})
	.i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 	
	
	// 规则串及导入
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s labelID = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage",drugLibaryData)
	// 规则json串处理	
	s root={},inputRuleObj={},ifObj={},thenObj={},elseObj={}
	d ..SetInputRuleObj(.ifObj,.atomArr,.orArr)
	// 输出信息json串处理	
	s outPutObj={}
	i usageText'="" d outPutObj.%Set("linkErrMsg",usageText)
	d outPutObj.%Set("levelMsg","2").%Set("msgSource","").%Set("alertCat","").%Set("OutMsgTips","Y")
	d ..SetRuleOutPutObj(.outPutObj,.thenObj,.elseObj,labelID)
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)		// 目录描述	
	s tipsFlag=$case((labelDesc["用法用量")||(labelDesc["适应"),1:1,:0) 
	i (tipsFlag=1)&(ifObj.%ToJSON()="{}") s elseObj={}	// 规则为空时,错误输出的提醒不需要
	i (tipsFlag=0)&(ifObj.%ToJSON()="{}") s thenObj={}
	
	i (ifObj.%Size()=0)&(thenObj.%Size()=0)&(elseObj.%Size()=0) s err=0,msg=..MarkErrInfo(drugName,"rule")
	q:err=0 0
	
	d inputRuleObj.%Set("if",ifObj).%Set("then",thenObj).%Set("else",elseObj).%Set("_name","rule").%Set("remark","")
	d root.%Set("rule",inputRuleObj)	// root={rule:{remark:"",if:{and:{atom:{},or:{}}},then:{},else:{},_name:"rule"}}

	s dicStr=drugId_"^"_labelID		// 药品名称id^目录id
	s status="Release"
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root.%ToJSON(),"",dicStr,userInfo)	// save方法中,root是json字符串,不成直接传json对象
	i ret<0 s err=0
	
	k root,inputRuleObj,ifObj,thenObj,elseObj,atomArr,orArr
	
	q err
}

/// Description:	保存禁忌症-禁用的规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			
/// return:	
/// w ##Class(web.DHCCKBPrescTest).SaveRuleContrForbid("")
ClassMethod SaveRuleContrForbid(drugName, drugId, pregnantFo, breastFeed, userInfo) As %String
{
	n (drugName,drugId, pregnantFo,breastFeed,userInfo)
	
	s atomArr=[],orArr=[],exitFlag=0,err=1

	s specialPopData = ##class(web.DHCCKBCommon).GetSpecPopData()
	s dicIDStr = ""
	i pregnantFo=1  d	// 妊娠禁用(0否,1是)
	.s dicID = ##class(web.DHCCKBRuleImport).CheckDictionExist("妊娠期","妊娠期",specialPopData)
	.q:dicID=0
	.s dicIDStr=dicID
	i breastFeed=1 d	// 哺乳期妇女禁用(0否,1是)
	.s dicID = ##class(web.DHCCKBRuleImport).CheckDictionExist("哺乳期","哺乳期",specialPopData)
	.q:dicID=0
	.i dicIDStr="" s dicIDStr=dicID
	.e  s dicIDStr=dicIDStr_"^"_dicID
	q:dicIDStr="" ""
	
	s tmpObj=##class(web.DHCCKBRuleImport).GetCommonObj("linkPeople",dicIDStr)
	s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..MarkErrInfo(drugName,"RuleContr")	
	q:(+tmpObj<=0)||(tmpObj={})
	i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 	
	e  d orArr.%Push(tmpObj)
	
	// 规则串及导入
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s labelID = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr",drugLibaryData)
	// 规则json串处理	
	s root={},inputRuleObj={},ifObj={},thenObj={},elseObj={}
	d ..SetInputRuleObj(.ifObj,.atomArr,orArr)
	// 输出信息json串处理	
	s outPutObj={}
	d outPutObj.%Set("linkErrMsg","").%Set("levelMsg","3").%Set("msgSource","").%Set("alertCat","禁用").%Set("OutMsgTips","")
	d ..SetRuleOutPutObj(.outPutObj,.thenObj,.elseObj,labelID)
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)		// 目录描述	
	s tipsFlag=$case((labelDesc["用法用量")||(labelDesc["适应"),1:1,:0) 
	i (tipsFlag=1)&(ifObj.%ToJSON()="{}") s elseObj={}	// 规则为空时,错误输出的提醒不需要
	i (tipsFlag=0)&(ifObj.%ToJSON()="{}") s thenObj={}
	
	i (ifObj.%Size()=0)&(thenObj.%Size()=0)&(elseObj.%Size()=0) s err=0,msg=..MarkErrInfo(drugName,"rule")
	q:err=0 0
	
	d inputRuleObj.%Set("if",ifObj).%Set("then",thenObj).%Set("else",elseObj).%Set("_name","rule").%Set("remark","")
	d root.%Set("rule",inputRuleObj)	// root={rule:{remark:"",if:{and:{atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	s dicStr=drugId_"^"_labelID		// 药品名称id^目录id
	s status="Release"
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root.%ToJSON(),"",dicStr,userInfo)	// save方法中,root是json字符串,不成直接传json对象
	i ret<0 s err=0
	
	k root,inputRuleObj,ifObj,thenObj,elseObj,atomArr,orArr
	
	q err
}

/// Description:	保存禁忌症-慎用的规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			
/// return:	
/// w ##Class(web.DHCCKBPrescTest).SaveUsageRule("")
ClassMethod SaveRuleContrWarn(drugName, drugId, pregnantWarn, menstruation, userInfo) As %String
{
	n (drugName,drugId,pregnantWarn,menstruation,userInfo)
	
	s atomArr=[],orArr=[],exitFlag=0,err=1
	// 妊娠禁用
	s specialPopData = ##class(web.DHCCKBCommon).GetSpecPopData()
	s dicIDStr = ""
	i pregnantWarn=1  d		// 妊娠慎用(0否,1是)
	.s dicID = ##class(web.DHCCKBRuleImport).CheckDictionExist("妊娠期","妊娠期",specialPopData)
	.q:dicID=0
	.s dicIDStr=dicID
	i menstruation=1 d	//  女性经期慎用(0否,1是)
	.s dicID = ##class(web.DHCCKBRuleImport).CheckDictionExist("经期妇女","经期妇女",specialPopData)
	.q:dicID=0
	.i dicIDStr="" s dicIDStr=dicID
	.e  s dicIDStr=dicIDStr_"^"_dicID
	q:dicIDStr="" ""
	
	s tmpObj=##class(web.DHCCKBRuleImport).GetCommonObj("linkPeople",dicIDStr)
	s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..MarkErrInfo(drugName,"RuleContr")	
	q:(+tmpObj<=0)||(tmpObj={})
	i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 	
	e  d orArr.%Push(tmpObj)
	
	// 规则串及导入
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s labelID = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr",drugLibaryData)
	// 规则json串处理	
	s root={},inputRuleObj={},ifObj={},thenObj={},elseObj={}
	d ..SetInputRuleObj(.ifObj,.atomArr,orArr)
	// 输出信息json串处理	
	s outPutObj={}	
	d outPutObj.%Set("linkErrMsg","").%Set("levelMsg","2").%Set("msgSource","").%Set("alertCat","慎用").%Set("OutMsgTips","")
	d ..SetRuleOutPutObj(.outPutObj,.thenObj,.elseObj,labelID)
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)		// 目录描述	
	s tipsFlag=$case((labelDesc["用法用量")||(labelDesc["适应"),1:1,:0) 
	i (tipsFlag=1)&(ifObj.%ToJSON()="{}") s elseObj={}	// 规则为空时,错误输出的提醒不需要
	i (tipsFlag=0)&(ifObj.%ToJSON()="{}") s thenObj={}
	
	i (ifObj.%Size()=0)&(thenObj.%Size()=0)&(elseObj.%Size()=0) s err=0,msg=..MarkErrInfo(drugName,"rule")
	q:err=0 0
	
	d inputRuleObj.%Set("if",ifObj).%Set("then",thenObj).%Set("else",elseObj).%Set("_name","rule").%Set("remark","")
	d root.%Set("rule",inputRuleObj)	// root={rule:{remark:"",if:{and:{atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	s dicStr=drugId_"^"_labelID		// 药品名称id^目录id
	s status="Release"
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root.%ToJSON(),"",dicStr,userInfo)	// save方法中,root是json字符串,不成直接传json对象
	i ret<0 s err=0
	
	k root,inputRuleObj,ifObj,thenObj,elseObj,atomArr,orArr
	
	q err
}

/// Description:	规则json输出串
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			filepath：文件路径,exportFlag是否导出, autoFlag 是否生成兜底规则,userInfo 用户信息
/// return:	
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("")
ClassMethod SetInputRuleObj(ifObj, atomArr, orArr) As %String
{
	n (ifObj,atomArr,orArr)
	//规则json输出串	
	s andObj={} 
	// and json
	i (atomArr.%Size())=1  d			// atomArr数组中只有一个元素,则需要输出atom:{}. 多个元素则输出atom:[]
	.d andObj.%Set("atom",atomArr.%Get(0))
	i (atomArr.%Size())>1 d
	.d andObj.%Set("atom",atomArr)
	
	i orArr.%Size()=1 d				// orArr数组中只有一个元素,则需要输出or:{}. 多个元素则输出or:[]
	.d andObj.%Set("or",orArr.%Get(0))
	i (orArr.%Size())>1 d
	.d andObj.%Set("or",orArr)	
	
		
	q:andObj.%ToJSON()="{}" ""
	
	i (atomArr.%Size()=0)&(orArr.%Size()=1) d	//root={rule:{remark:"",if:{and:{or:{},atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	.d ifObj.%Set("or",andObj.%Get("or"))		
	e  d
	.d ifObj.%Set("and",andObj)

	d ifObj.%Set("and",andObj)
	
	k andObj

	Quit ""
}

/// Description:	输出信息json串处理
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			filepath：文件路径,exportFlag是否导出, autoFlag 是否生成兜底规则,userInfo 用户信息
/// return:	
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("")
ClassMethod SetRuleOutPutObj(outPutObj, thenObj, elseObj, labelID) As %String
{
	n (outPutObj,thenObj,elseObj,labelID)

	s thenObj={},elseObj={}
	// 输出除了用法用量,适应症(进一步说明的都在then里面),其他的都是满足了给提醒(禁忌证、相互作用、配伍禁忌等)(进一步说明的都在else里面)
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)	// 目录描述		
	i (labelDesc["用法用量")||(labelDesc["适应")  d	// 不通过提醒
	.d elseObj.%Set("var-assign",##class(web.DHCCKBRuleImport).GetAssignObj(0,outPutObj))
	e  d
	.d thenObj.%Set("var-assign",##class(web.DHCCKBRuleImport).GetAssignObj(0,outPutObj))

	Quit
}

/// Description:	记录保存失败的规则
/// Creator:		qunianpeng
/// CreateDate:		2021-03-01
/// Input:			filepath：文件路径,exportFlag是否导出, autoFlag 是否生成兜底规则,userInfo 用户信息
/// return:	
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("")
ClassMethod MarkErrInfo(drugName, type) As %String
{
	n (drugName,type)
	s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportChinaHMRuleErr",drugName,type)=$lb(drugName,type_":保存规则失败")	// 记录没有导入的药品
	q ""
}

/// Description:	批量取消发布中药饮片的用法用量规则（原因：用法用量的规则中有次剂量，极限量,是并且关系，只用极限量控制即可。取消发布，使用兜底规则控制-兜底规则中只有极限量[有毒药品极限量=次最大量，无毒药品=次最大量*3]）
/// Creator:		QuNianpeng
/// CreateDate:		2021-04-27
/// input:			药品id,登录信息,状态
/// w ##Class(web.DHCCKBPrescTest).AutoCancelRelease("","11877^6^1^289^2","CancelRelease") pdssadmin账户
/// w ##Class(web.DHCCKBPrescTest).AutoCancelRelease("","13923^1^1^339^2","CancelRelease")
ClassMethod AutoCancelRelease(queryDrugId As %String = "", loginInfo, status) As %String
{
	n (queryDrugId,loginInfo,status)
	/* 遍历中药饮片的用法用量规则 */
	s drugCount = 0, ruleCount = 0
	s chinaHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s dicID = ""
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",chinaHMData,dicID)) q:dicID=""  d
	.q:(queryDrugId'="")&&(queryDrugId'=dicID)
	.s drugCount = drugCount + 1 
	.s ruleDicID = "",ruleStr = ""
	.f   s ruleDicID = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))  q:ruleDicID=""   d
	..s ruleID=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2) 	// 规则ID
	..q:$lg($g(^CT.CKB.PDSS.RuleD(ruleID)),4)'="Release"  	// 未发布不加算在内
	..s labelDesc=##class(web.DHCCKBPassNew).GetRuleLabelDesc(ruleID) // 审查目录
	..q:labelDesc'="用法用量"
	..s ruleCount = ruleCount + 1
	..i ruleStr="" s ruleStr = ruleID
	..e  s ruleStr  = ruleStr _"^"_ ruleID
	./*取消发布规则 */
	.q:ruleStr=""
	.d ##class(web.DHCCKBRuleSave).ReleaseStatus(ruleStr,loginInfo,status)	
	
	q "药品:"_drugCount_"个"_",规则:"_ruleCount_"条"
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			
/// return:			
/// other:			
ClassMethod SubmitRule(root, userId, dicStr, loginInfo) As %String
{
	n (root, userId, dicStr, loginInfo)	
	
	s opStatus = "add"
	s status = ""
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root,userId,dicStr,loginInfo)

	i ret>0 d	
	.s status = "Release"
	.s opStatus = ""
	.s root = ##class(web.DHCCKBExportRuleManage).GetRuleObj(opStatus,ret)
	.s ret=##class(web.DHCCKBRuleSave).save(ret,status,root,userId,dicStr,loginInfo)
	
	q ret
	
	// ret<=0 失败 新生成的ruleId
}

/// Description:	用法用量自动生成普适(兜底)规则(新生成规则)--生成儿童的的兜底规则(逻辑同AutoSetBaseRule)
/// Creator:		QuNianpeng
/// CreateDate:		2022-04-25
/// input: queryDrugId（单个药品生产）
/// other:			(普适项目：给药途径、日用药量、单次用药量、用药频率)
/// 生成规则:		(逻辑同AutoSetBaseRule)
/// w ##Class(web.DHCCKBPrescTest).AutoSetBaseChildRule("")
ClassMethod AutoSetBaseChildRule(queryDrugId As %String = "") As %String
{
	n (queryDrugId)
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s chinaHMDrugData=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片字典
	q:(+drugData=0)&(+chineseDrugData=0)&(chinaHMDrugData=0) ""
	s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")		// 用法目录

	s loginInfo="11877^8^1^289^2"
	s userId=11877
	//set $ZT="ERRORAutoSetBaseChildRule" // 设置一个异常
	s err=0
	//Ts
	s count=0
	//s comlist=$lb(drugPreMet,drugFreq,onceDose,dayMax)	// 普适项目	
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:drugId'=97763
	.q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.//q:parref'=chinaHMDrugData
	.k TmpArr
	.s exitFlag=0
	.// 遍历所有的用法用量规则,找到儿童的规则(人群是儿童等,或年龄小于18岁)
	.d ..GetChildRule(.TmpArr,drugId)
	.q:$g(TmpArr("exitFlag"))=1	
	.s err=..CleanBaseRule(drugId,1)	// 	清除药品的儿童普适规则
	.q:err=1
	.q:(##Class(web.DHCCKBPrescTest).IsSetCommonRule(drugId,1)=1) // 已经有兜底规则，是否生成多条
	.s ruleDicID = ""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")||(exitFlag=1)  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..q:ruleStauts'="Release"
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法用量"
	..s exitFlag=..GetBaseItmValue(.TmpArr,drugId,rule,1)
	.i exitFlag=1 k TmpArr
	.q:exitFlag=1
	.s ret = ..SaveBaseRule(.TmpArr,drugId,userId,loginInfo,1)
	.s:ret=-1 err = 1
	.q:err=1
	.s count = count + 1
	.w count,!
	
	//i err=1 tro
	//e  TCOMMIT
	
	q "完成:"_count_"个药品"
		
	
ERRORAutoSetBaseChildRule
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	Quit ErrorMsg		             //返回错误信息
}

/// Descript:  		寻找出用法用量中,儿童(儿童：人群是儿童等,或年龄是18岁以下)的规则
/// Creator:		QuNianpeng
/// CreateDate:		2022-04-25
///  Output: 		w ##Class(web.DHCCKBPrescTest).GetChildRule()
ClassMethod GetChildRule(TmpArr, drugId)
{
	n (TmpArr,drugId)
	
	s childList=$lb("小儿","婴儿","儿童","新生儿","青少年","婴幼儿","幼儿","新生儿（足月产）","学龄前儿童","学龄儿童","新生儿（早产儿）","新生儿（低体重儿）","早产儿")
	s specProp = ##class(web.DHCCKBCommon).GetSpecialPopProp()	// 特殊人群属性
	s ageProp = ##class(web.DHCCKBCommon).GetAgeProp()	// 年龄属性

	//s libaryId= ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")
	//^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",DLRDrugDr,DLRLibaryDr,DLRRuleDr,ID)
	
	s ruleDicID=""
	f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) q:(ruleDicID="")  d
	.s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	.s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),4)
	.q:ruleStauts'="Release"
	.s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(ruleId)
	.q:labelDesc'="用法用量"
	.s ageFlag = 0,doseFlag = 0,nullFlag =0
	.s parent=""
	.f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent))  q:(parent="")||(ageFlag=1)   d  
	..s node=""
	..f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent,node))  q:(node="")||(ageFlag=1)   d  
	...q:node=0
	...s ruleDataID=""
	...f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,ruleDataID))  q:(ruleDataID="")||(ageFlag=1)   d
	....q:ruleDataID=0
	....q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	....s value=..GetValue(ruleDataID)	// 记录普适项目的值： 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	....s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)	// 实体/属性（前提条件的项目代码）
	....//s calcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),2)
	....i leftDic = specProp d // 人群 // 如果规则中有儿童标记,则进行标记
	.....s valueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+$p(value,$c(1),3))),3)
	.....s:(valueDesc'="")&($lf(childList,valueDesc)) ageFlag = 1
	....
	....i leftDic = ageProp	d	// 年龄
	.....s:($p(value,$c(1),3)'="")&($p(value,$c(1),3)<=18) ageFlag = 1	
	.....s:($p(value,$c(1),4)'="")&($p(value,$c(1),4)<=18) ageFlag = 1
	....
	..
	.
	.i ageFlag = 1 d
	..s TmpArr("childRule",ruleId)=ruleId	// 记录儿童的规则
		
	q ""
}

/// Descript:  		生成兜底规则方法
/// Creator:		QuNianpeng
/// CreateDate:		2022-04-25
/// Output: 		w ##Class(web.DHCCKBPrescTest).GetChildRule()
ClassMethod SaveBaseRule(TmpArr, drugId, userId, loginInfo, childFlag = 0)
{
	
	n (TmpArr,drugId,userId,loginInfo,childFlag)
	s usageId=##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")		// 用法目录

	s ruleObj=..SetBaseRuleObj(.TmpArr,childFlag)
	
	q:ruleObj="" ""
	k root
	q:ruleObj.%Get("if").%Size()=0 ""
	s root={}
	d root.%Set("rule",ruleObj)
	s status=""	// 保存
	
	s ret = ..SubmitRule(root.%ToJSON(),userId,drugId_"^"_usageId,loginInfo)
	q:+ret<=0 -1
	
	q ret
}

/// Descript:  		从用法用量中获取最低常规量(区分成人、儿童)
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-20
/// Output: 		w ##Class(web.DHCCKBPrescTest).GetLowUseDose()
/// Other:			// 规则的分支和规则存在修改、新增、删除的动作,而存的最低量没有实时更新问题
ClassMethod GetLowUseDose()
{
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s usageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")	//	用法用量目录
	
	s onceDose=##class(web.DHCCKBCommon).GetOnceDoseProp()		// 单次剂量属性
	s onceDoseMax=##class(web.DHCCKBCommon).GetOnceDoseMaxProp() // 单次最大量属性
	s onceDoseLimit=##class(web.DHCCKBCommon).GetOnceDoseLimitProp() // 单次极限量
	s dayDose=##class(web.DHCCKBCommon).GetDayDoseProp()			// 日剂量属性
	s dayDoseMax=##class(web.DHCCKBCommon).GetDayDoseMaxProp()		// 日最大量
	s dayDOseLimit=##class(web.DHCCKBCommon).GetDayDoseLimitProp()	// 日极限量	
	s markList = $lb(onceDose,onceDoseMax,onceDoseLimit,dayDose,dayDoseMax,dayDOseLimit)
	
	
	k TmpArr
	s drugId = ""
	f  s drugId = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId))  q:drugId=""   d
	.//q:drugId'=1884
	.//q:drugId'=81646
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.q:+parref=0
	.q:(parref'=drugData)&&(parref'=chineseDrugData)	// 只找西药和中药的
	.d ..GetChildRule(.TmpArr,drugId)	
	.k TmpArr("child")
	.k TmpArr("aldult")
	.s rule = ""
	.f  s rule = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,usageId,rule)) q:rule=""  d
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..q:ruleStauts'="Release"
	..
	..s childFlag = 0 
	..i $d(TmpArr("childRule",rule)) s childFlag=1 // 有儿童规则
	..s parent=""	
	..f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent))  q:(parent="")  d  
	...s node=""
	...f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent,node))  q:(node="")   d  
	....q:node=0
	....s ruleDataID=""
	....f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,ruleDataID))  q:(ruleDataID="")   d
	.....q:ruleDataID=0
	.....q:'$d(^CT.CKB.PDSS.RuleDataD(+ruleDataID))
	.....s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)	// 实体/属性（前提条件的项目代码）
	.....q:'$lf(markList,leftDic)	
	.....s opArith = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),7)	// 比值符号
	.....q:opArith'="Between"	// 最低量只考虑区间的这种	
	.....s exitFlag=..CompareLowDose(.TmpArr,drugId,rule,ruleDataID,childFlag)
	...
	.
	.// 按照药品记录最低量
	.d ..MarkUseLowDose(.TmpArr,drugId)
	
	q ""
}

/// Descript:  		经过比较选择剂量最小的
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-20
/// Output: 		w ##Class(web.DHCCKBPrescTest).CompareLowDose()
ClassMethod CompareLowDose(TmpArr, drugId As %String, ruleId, ruleDataID, childFlag) As %String
{
	n (TmpArr,drugId,ruleId,ruleDataID,childFlag)	
	
	s manFlag = $case(childFlag=1,1:"child",:"aldult")
	s exitFlag=0 
	q:+drugId=0 ""
	q:'$d(^CT.CKB.PDSS.CommonDictionD(+drugId)) 0
	s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s parrefData = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s parrefDataName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parrefData)),3)
	s value=..GetValue(ruleDataID)	// 记录普适项目的值： 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)	// 实体/属性（前提条件的项目代码）	
	s calcItm=$lg($g(^CT.CKB.PDSS.CommonDictionD(+leftDic)),2)
	s op=$p(value,$c(1),2)
	s minValue=$p(value,$c(1),3)
	s maxValue=$p(value,$c(1),4)
	s unit=$p(value,$c(1),5)
	s:((minValue="")&(maxValue=""))||(unit="") exitFlag=1 // 数值为空,或者单位为空,则退出
	q:exitFlag=1 exitFlag	
	s realItm = ""
	s:(calcItm="OnceDoseLimit")||(calcItm="OnceDoseMax")||(calcItm="OnceDose") realItm="once"
	s:(calcItm="DayDoseLimit")||(calcItm="DayDoseMax")||(calcItm="DayDose") realItm="day"
	q:realItm="" ""
	
	i $g(TmpArr(manFlag,realItm,"value"))="" d
	.s TmpArr(manFlag,realItm,"value")=$case(maxValue>minValue,1:minValue,:maxValue)
	.s TmpArr(manFlag,realItm,"unit")=unit	
	.s TmpArr(manFlag,realItm,"calcItm")=leftDic
	.s TmpArr(manFlag,realItm,"ID")=ruleDataID
	
	
	// 先比较单位,单位不一致的,根据系数转换,计算。转换不成功的则进行
	s markUnit=$g(TmpArr(manFlag,realItm,"unit"))
	i markUnit=unit d	// 单位相同比较值
	.s:$g(TmpArr(manFlag,realItm,"value"))>minValue TmpArr(manFlag,realItm,"value")=minValue,TmpArr(manFlag,realItm,"calcItm")=leftDic,TmpArr(manFlag,realItm,"ID")=ruleDataID
	.s:$g(TmpArr(manFlag,realItm,"value"))>maxValue TmpArr(manFlag,realItm,"value")=maxValue,TmpArr(manFlag,realItm,"calcItm")=leftDic,TmpArr(manFlag,realItm,"ID")=ruleDataID
	e  d  // 单位不同 // 单位是否可以转换
	.q:(+markUnit=0)||(+unit=0)
	.q:('$d(^CT.CKB.PDSS.CommonDictionD(+markUnit)))||('$d(^CT.CKB.PDSS.CommonDictionD(+unit)))
	.s isExitFlag = 0
	.i ($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/") & ('($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/")) d	// 单位不一致时,是否包含/的形式
	..s TmpArr(manFlag,realItm,"unit")=unit
	..s TmpArr(manFlag,realItm,"value")=$case(maxValue>minValue,1:minValue,:maxValue)
	..s isExitFlag = 1
	.i ($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/")&(($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/")) d
	..s isExitFlag = 1
	.i ('($lg($g(^CT.CKB.PDSS.CommonDictionD(+markUnit)),3)["/"))&($lg($g(^CT.CKB.PDSS.CommonDictionD(+unit)),3)["/") d
	..s isExitFlag = 1
	.
	.q:isExitFlag=1
	.s fac=##class(web.DHCCKBCommonUtil).GetFactorToLib($lg($g(^CT.CKB.PDSS.CommonDictionD(markUnit)),3),$lg($g(^CT.CKB.PDSS.CommonDictionD(unit)),3),drugId)
	.i fac="" s exitFlag=1
	.q:exitFlag=1
	.s newValue=$g(TmpArr(manFlag,realItm,"value"))*fac
	.s:newValue>minValue TmpArr(manFlag,realItm,"value")=minValue,TmpArr(manFlag,realItm,"unit")=unit,TmpArr(manFlag,realItm,"calcItm")=leftDic,TmpArr(manFlag,realItm,"ID")=ruleDataID
	.s:newValue>maxValue TmpArr(manFlag,realItm,"value")=maxValue,TmpArr(manFlag,realItm,"unit")=unit,TmpArr(manFlag,realItm,"calcItm")=leftDic,TmpArr(manFlag,realItm,"ID")=ruleDataID

	s TmpArr("exitFlag")=exitFlag
	s TmpArr(manFlag,realItm)=$lb("InputUom"_$c(1)_"LessThenEquals"_$c(1)_$g(TmpArr(manFlag,realItm,"value"))_$c(1)_""_$c(1)_$g(TmpArr(manFlag,realItm,"unit"))_$c(1)_$g(TmpArr(manFlag,realItm,"ID")))

	// 类型_$c1_符号_$c(1)_值_$c(1)_最大值__$c(1)_单位
	i exitFlag=1 d
	.k TmpArr(manFlag,realItm,"sign")
	.k TmpArr(manFlag,realItm,"unit")
	.k TmpArr(manFlag,realItm,"value")
	.k TmpArr(manFlag,realItm,"calcItm")
	.k TmpArr(manFlag,realItm,"ID")
	q exitFlag
}

/// Descript:  		记录用法用量中的最低常规量
/// Creator:		QuNianpeng
/// CreateDate:		2022-05-20
/// Output: 		w ##Class(web.DHCCKBPrescTest).MarkUseLowDose()
ClassMethod MarkUseLowDose(TmpArr, drugId As %String) As %String
{
	
	n (TmpArr,drugId)		

	s childOnceDose = $select($d(TmpArr("child","once")):$g(TmpArr("child","once")),1:"")
	i $listvalid(childOnceDose)=1 s childOnceDose = $lts(childOnceDose)
	
	s aldultOnceDose = $select($d(TmpArr("aldult","once")):$g(TmpArr("aldult","once")),1:"")
	i $listvalid(aldultOnceDose)=1 s aldultOnceDose = $lts(aldultOnceDose)
	
	s childDayDose = $select($d(TmpArr("child","day")):$g(TmpArr("child","day")),1:"") 
	i $listvalid(childDayDose)=1 s childDayDose = $lts(childDayDose)
	
	s aldultDayDose = $select($d(TmpArr("aldult","day")):$g(TmpArr("aldult","day")),1:"")
	i $listvalid(aldultDayDose)=1 s aldultDayDose = $lts(aldultDayDose)

	q:(childOnceDose="")&(aldultOnceDose="")&(childDayDose="")&(aldultDayDose="") ""

	i childOnceDose'=""  d
	.s ^DHCCKBMarkUseLowDose(drugId,"childOnce") = $p(childOnceDose,$c(1),3)_","_$p(childOnceDose,$c(1),5)_","_$p(childOnceDose,$c(1),6)
 	
	i aldultOnceDose'=""  d
	.s ^DHCCKBMarkUseLowDose(drugId,"aldultOnce") = $p(aldultOnceDose,$c(1),3)_","_$p(aldultOnceDose,$c(1),5)_","_$p(aldultOnceDose,$c(1),6)
 	
 	i childDayDose'=""  d
	.s ^DHCCKBMarkUseLowDose(drugId,"childDay") = $p(childDayDose,$c(1),3)_","_$p(childDayDose,$c(1),5)_","_$p(childDayDose,$c(1),6)
 	
 	i aldultDayDose'=""  d
	.s ^DHCCKBMarkUseLowDose(drugId,"aldultDay") = $p(aldultDayDose,$c(1),3)_","_$p(aldultDayDose,$c(1),5)_","_$p(aldultDayDose,$c(1),6)
 	
	q ""
}

/// Descript:  		导出用法用量中有儿童规则的药品
/// Creator:		QuNianpeng
/// CreateDate:		2022-04-25
/// Output: 		w ##Class(web.DHCCKBPrescTest).ExportDrugListHasChildRule()
/// w ##Class(websys.Query).ToExcel("用药用量含有儿童规则药品20220426","web.DHCCKBPrescTest","ExportDrugListHasChildRule")
/// 导出与适应症不明确列相关内容
Query ExportDrugListHasChildRule() As websys.Query(ROWSPEC = "drugId:%String:药品id,drugCode:%String:药品编码,drugDesc:%String:药品名称,type:%String:药品字典,hospital:%String:医院名称")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBPrescTest","ExportDrugListHasChildRule") 
/// @param:
ClassMethod ExportDrugListHasChildRuleExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1

	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	
	/*
	s TmpArr("94") = "哈尔滨医科大学第一附属医院"
	s TmpArr("95") ="武汉市第一医院"
	s TmpArr("96") = "江苏盐城中医"
	s TmpArr("97") = "武汉市第三医院"
	s TmpArr("98") = "北京中医院"
	s TmpArr("99") = "北京惠兰医院"
	s TmpArr("100") = "上海美中嘉和医院"
	s TmpArr("101") = "	赛罕区第二医院"
	s TmpHospArr("102") = "广州增城中医"
	s TmpHospArr("103") = "武汉市第一医院[旧]"
	s TmpHospArr("104") = "武汉市第一医院一"
	s TmpHospArr("105") = "榆林市第二医院"
	s TmpHospArr("106") = "包医二附院"
	s TmpHospArr("107") = "武汉药事云"
	s TmpHospArr("108") = "悦年华南宁康复医院"
	s TmpHospArr("109") = "南京医科大学第四附属医院"
	s TmpHospArr("110") = "安徽蚌埠第四人民医院"
	s TmpHospArr("111") = "佛山和佑美和门诊部"
	s TmpHospArr("112") = "南皮县人民医院"
	s TmpHospArr("113") = "四川北川人医"
	s TmpHospArr("114") = "蚌埠一院"
	s TmpHospArr("115") = "广西壮族自治区南溪山医院"
	s TmpHospArr("116") = "广州市白云区人民医院"
	s TmpHospArr("117") = "安徽蚌埠妇幼"
	s TmpHospArr("118") = "湖北黄冈浠水人民"
	s TmpHospArr("119") = "内蒙清水河"
	s TmpHospArr("121") = "江西宜春丰城人民"
	s TmpHospArr("122") = "珠海市人民医院"
	s TmpHospArr("123") = "马鞍山市中医医院"
	s TmpHospArr("124") = "辽宁锦州口腔医院"
	s TmpHospArr("125") = "四川泸州合江人民"
	s TmpHospArr("126") = "四川宜宾三院"
	s TmpHospArr("127") = "深圳市中医院"
	
	*/
	
	k TmpCKBDataArr
	
	s count = 0
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.//q:parref'=chinaHMDrugData
	.k TmpArr	
	.d ..GetChildRule(.TmpArr,drugId)
	.i $d(TmpArr("childRule"))	d	// 有儿童规则
	..s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..s parrefDesc =  $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	..s hospList = ""
	..s hisDesc = ""
	..f  s hisDesc = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(drugDesc),hisDesc)) q:hisDesc=""  d
	...s conID = ""
	...f  s conID = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(drugDesc),$$UPPER^SSUTIL4(hisDesc),conID)) q:conID=""  d
	....s hospital = $lg(^CKB.PDSS.ComContrastD(conID),7)
	....i +hospital'=0 d
	.....i $d(^CT("HOSP",+hospital)) s hospital = $p($g(^CT("HOSP",+hospital)),"^",2)
	.....//e  s hospital=$g(TmpHospArr(+hospital))
	....
	....i (hospital'="")&&($lf(hospList,hospital))=0 s $list(hospList,*+1) = hospital
	..
	..s hospList = $lts(hospList,"、")
	..s listData = $lb(drugId,drugCode,drugDesc,parrefDesc,hospList)
	..s count = count + 1
	..s TmpCKBDataArr(count)=listData

	set index=""	
	for  set index=$order(TmpCKBDataArr(index)) quit:index=""  do
	.set listData=$get(TmpCKBDataArr(index))
	.//$c(28)文件分隔符 肉眼不可见，为了在Excel中数据开头是0的可以显示	
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript: 单个导入处方吹
/// w ##Class(web.DHCCKBPrescTest).ImportOrder("N","D:\temp\expexcelopchn.txt","Y","dhcc^主管药师^药学部^安全用药智能决策(开发)^马鞍山市中医医院")
/// w ##Class(web.DHCCKBPrescTest).ImportOrderTest("dhcc^主管药师^药学部^安全用药智能决策(开发)^东华标准版数字化医院[总院]")
/// 
ClassMethod ImportOrderTest(userInfo = "") As %String
{

	N (userInfo)
	s exportFlag=""
	q:userInfo="" "用户信息不能为空"	// 2021/12/02
	s hosp = $p(userInfo,"^",5) 
	s hsopId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	q:hsopId="" "请使用系统中已经对照的真实医院的名称,否则会导致计算不准确！"
	

	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	s TmpArr(1) = "类型	就诊号	年龄	性别	患者过敏信息	体重	身高	诊断	特殊人群	处方号	处方上药品数量	药学名称	药品剂型	规格	最小包装	发药数量	单次剂量	剂量单位	频次	服药途径	疗程	关联医嘱组号	开方时间	医嘱备注"
	s TmpArr(2) = "门诊	21036366	69岁	女				神经衰弱		MJ22051600005	1	马来酸咪达唑仑片[15mg*10片]	片剂	[15mg*10片]	片	2	0.5	片	睡前	口服	3天	3	2022-5-16"	
	s TmpArr(3) = "门诊	21036366	69岁	女				神经衰弱		MJ22051600006	1	马来酸咪达唑仑片[15mg*10片]	片剂	[15mg*10片]	片	7	1	片	睡前	口服	7天	5	2022-5-16"
	
	S hCount=0
	s del="^"
	
	s allergy=""
	s title=""
	s index = ""
	f  s index = $o(TmpArr(index)) q:index=""  d
	.s onerow = $g(TmpArr(index))
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.s impDataList=$tr(impDataList,$c(10),"")
	.s impDataList=$tr(impDataList,$c(10,13),"")
	.s impDataList=$tr(impDataList,$c(13),"")
	.//s impDataList=$tr(impDataList," ","")
	.s impDataList=$tr(impDataList,"""","")
	.
	.i hCount=1 s title=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","title")=title
	.s Err=""
	.q:hCount=1
	.s valueObj=..GetOrderObj(title,impDataList)
	.s prescNo=valueObj.%Get("prescNo")
	.s drugName=valueObj.%Get("drug")
	.
	.q:prescNo=""
	.q:drugName=""
	.s ^TMP("DHCCKB","web.DHCCKBPrescTestSave","ImportOrder",pid,prescNo,drugName,hCount)=impDataList
	.s ^TMP("DHCCKB","web.DHCCKBPrescTest","ImportOrder",pid,prescNo,drugName,hCount)=impDataList

	w ..CheckAllItem(pid,title,exportFlag,userInfo)
	quit ""
}

}
