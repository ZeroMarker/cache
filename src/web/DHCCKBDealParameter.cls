/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-31
/// Descript: 		表达式--参数取值处理类
Class web.DHCCKBDealParameter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		判断公式的执行时机
/// Input:			属性代码
/// OutPut:			1 初始化执行  2 计算时执行
/// w ##Class(web.DHCCKBDealParameter).CheckExeTime("OnceDose")
ClassMethod CheckExeTime(PropCode)
{
	n (PropCode)
	
	s PropID=##class(web.DHCCKBCommon).GetDicIdByCode(PropCode)
	
	// 判断公式的调用时机,是在计算时调用，还是入参初始化时调用
	s ExecuteTime=##class(web.DHCCKBCommon).GetExecuteTime()
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+PropID,ExecuteTime)) ""
	
	s ExeTime=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+PropID,ExecuteTime,LinkID))  q:LinkID=""  d
	.s AttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),4)
	.s AttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+AttrDr)),2)
	.s ExeTime=AttrCode
	
	q:ExeTime="InitExe" 1
	q:ExeTime="CalcExe" 2
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		入参调用公式初始化处理
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).DealParam("OnceDose")
ClassMethod DealParam(PropCode)
{
	n (PropCode)
	
	s ExeTimeFlag=..CheckExeTime(PropCode)	// 调用时机判断
	q:ExeTimeFlag'=1 ""
	
	s Value=##Class(web.DHCCKBComplexArith).CalcExpression(PropCode)	// 公式计算得到结果
		
	q Value
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始用户和登录信息
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitLogin("OnceDose")
ClassMethod InitLogin(arrsObj, TmpArr)
{
	n (arrsObj, TmpArr)
	
	s TmpArr("CarePrvID")=arrsObj.%Get("DocUser")	/// 医生(描述)
	s:$g(TmpArr("CarePrvID"))="" TmpArr("CarePrvID")=arrsObj.%Get("DocUser")
	s:$g(TmpArr("CarePrvID"))="" TmpArr("CarePrvID")=arrsObj.%Get("MainDoc")
	s TmpArr("DocLocID")=arrsObj.%Get("PatLoc")   	/// 科室
	s:$g(TmpArr("DocLocID"))="" TmpArr("DocLocID")=arrsObj.%Get("LgCtloc")
	s:$g(TmpArr("DocLocID"))="" TmpArr("DocLocID")=arrsObj.%Get("PatLoc")   	/// 科室
	s TmpArr("GroupID")=arrsObj.%Get("Group")		/// 安全组
	s TmpArr("ProfessID")=arrsObj.%Get("Profess")	/// 职称
	s TmpArr("HospitalID")=arrsObj.%Get("Hospital")	/// 医院id
	s TmpArr("UserInfo")=TmpArr("CarePrvID")_"^"_TmpArr("ProfessID")_"^"_TmpArr("DocLocID")_"^"_TmpArr("GroupID")_"^"_TmpArr("HospitalID")
	s TmpArr("ClientIP")=arrsObj.%Get("ClientIP")	/// 客户端IP
	s TmpArr("Office")="" //$lb(arrsObj.%Get("PatLoc"))  	/// 科室  sufan 2020-12-14
	s TmpArr("Office","Ext")=$lb(arrsObj.%Get("PatLoc"))  	/// 科室  sufan 2020-12-14	
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始患者信息
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitPatient("OnceDose")
ClassMethod InitPatient(arrsObj, TmpArr)
{
	n (arrsObj, TmpArr)
	
	s $list(TmpArr("PatName"))=arrsObj.%Get("PatName")	// 姓名
	s TmpArr("SexProp")=##class(web.DHCCKBPassNew).GetComDicIdNew(arrsObj.%Get("SexProp"),"SexProp")	// 性别
	s $list(TmpArr("SexProp","Ext"))=arrsObj.%Get("SexProp")
	s age=arrsObj.%Get("AgeProp")					// AgeProp 年龄	
	i age'="" d
	.s age=##class(web.DHCCKBCommon).ClacAge(age)
	.s $list(TmpArr("AgeProp"))=+age
	.s $list(TmpArr("AgeProp","Ext"))=age
	.s TmpArr("AgeProp","Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew($p(age,+age,2),"")
	.s $list(TmpArr("AgeProp","Unit","Ext"))=$p(age,+age,2)
	
	s $list(TmpArr("Weight"))=+arrsObj.%Get("Weight")	// 体重
	s $list(TmpArr("Weight","Ext"))=+arrsObj.%Get("Weight")_"kg"
	s TmpArr("Weight","Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew("kg","")
	s $list(TmpArr("Weight","Unit","Ext"))="kg"
	
	s $list(TmpArr("Height"))=+arrsObj.%Get("Height")	// 身高
	s $list(TmpArr("Height","Ext"))=arrsObj.%Get("Height")_"cm"
	s TmpArr("Height","Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew("cm","")
	s $list(TmpArr("Height","Unit","Ext"))="cm"
	
	s TmpArr("ProfessProp")=##class(web.DHCCKBPassNew).GetComDicIdNew(arrsObj.%Get("ProfessProp"),"ProfessProp")	// 职业
	s $list(TmpArr("ProfessProp","Ext"))=arrsObj.%Get("ProfessProp")
	
	s BodyArea= 0.0061*(+arrsObj.%Get("Height")) + (0.0124 * (+arrsObj.%Get("Height")) ) - 0.0099 // 体表面积" m2  =  0.0061 * {患者.身高} + ( 0.0124 * {患者.体重}) - 0.0099 }
	s:BodyArea<=0 BodyArea=""
	s:BodyArea=0 BodyArea=""
	s TmpArr("BodyArea")=$lb(BodyArea)
	 
	// 患者类别(门诊,急诊,住院) 2022-05-10 qnp
	s PatType = arrsObj.%Get("PatType")
	s PatType = $s(PatType["门诊":"门诊患者",PatType["急诊":"急诊患者",PatType["住院":"住院患者",1:"")
	s $list(TmpArr("PatType"))=PatType
	s $list(TmpArr("PatType","Ext"))=PatType	
	
	s TmpArr("EpisodeID")=arrsObj.%Get("EpisodeID")
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始化入参字符数组格式属性（如：特殊人群）
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitSpecial("OnceDose")
ClassMethod InitStrArr(arrsObj, TmpArr, Key, Node)
{
	n (arrsObj, TmpArr,Key,Node)
	
	s strArr=arrsObj.%Get(Key)
	q:strArr="" ""
	
	s listData="",listDataExt=""
	f index=0:1:strArr.%Size()-1  d
	.s value=strArr.%Get(index)
	.q:value=""
	.i $listfind(listDataExt,value)=0 s $list(listDataExt,*+1)=value	// his中的值
	.s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(value,Key)	// 返回值是list
	.s listData=##Class(web.DHCCKBCommonUtil).GetUnionList(listData,libvalue)	
	.//i (+libvalue'=0)&($listfind(listData,libvalue)=0) s $List(listData,*+1)=libvalue	// 知识库的id	
	
	s TmpArr(Node)=listData
	s TmpArr(Node,"Ext")=listDataExt

	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始化入参对象数组格式属性（如：疾病，检验）
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitObjArr("OnceDose")
ClassMethod InitObjArr(arrsObj, TmpArr, Key, Node)
{
	n (arrsObj, TmpArr,Key,Node)

	
	s objArr=arrsObj.%Get(Key)
	q:(objArr="")||(objArr.%Size()=0) ""
	
	s listData="",listDataExt=""
	f index=1:1:objArr.%Size()  d
	.s obj=objArr.%Get(index-1)
	.q:obj.%Size()=0
	.s value=obj.item
	.q:value=""
	.i $listfind(listDataExt,value)=0	s $list(listDataExt,*+1)=value
	.s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(value,Node)
	.s listData=##Class(web.DHCCKBCommonUtil).GetUnionList(listData,libvalue)	
	.//q:libvalue=""
	.//i (+libvalue'=0)&&($listfind(listData,libvalue)=0) s $List(listData,*+1)=libvalue

	s TmpArr(Node)=listData
	s TmpArr(Node,"Ext")=listDataExt
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始化过敏信息
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitHisAllergy("OnceDose")
ClassMethod InitHisAllergy(arrsObj, TmpArr, Key, Node)
{
	n (arrsObj,TmpArr)

	s allergy=arrsObj.%Get("HisAllergy")
	q:(allergy="")||(allergy=0) ""
	
	s allergyStr="",listDataExt=""
	f i=1:1:allergy.%Size()  d
	.s obj=allergy.%Get(i-1)
	.q:obj.%Size()=0
	.s value=obj.item
	.q:value=""
	.i $listfind(listDataExt,value)=0 s $List(listDataExt,*+1)=value
	.s libvalue=##class(web.DHCCKBPassNew).GetAllergyByHisValue(value) //..GetComDicIdNew(value,"HisAllergy")
	.q:libvalue=""
	.i allergyStr="" s allergyStr=libvalue
	.e  s allergyStr=allergyStr_"^"_libvalue
	
	i allergyStr'="" s TmpArr("HisAllergy")=$listfromstring(allergyStr,"^")
	s TmpArr("HisAllergy","Ext")=listDataExt
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始化过敏信息
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitLabItm("OnceDose")
ClassMethod InitLabItm(arrsObj, TmpArr)
{
	n (arrsObj,TmpArr)
	s labItm=arrsObj.%Get("labItm")
	q:labItm="" ""

	s listData="",listDataExt=""
	f i=1:1:labItm.%Size()  d
	.s obj=labItm.%Get(i-1)
	.q:obj.%Size()=0
	.s value=obj.item
	.q:value=""
	.i $listfind(listDataExt,value)=0 s $List(listDataExt,*+1)=value
	.s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(value,"LabItm")
	.q:libvalue=""
	.s listData=##Class(web.DHCCKBCommonUtil).GetUnionList(listData,libvalue)	
	.//i (+libvalue'=0)&&($lf(listData,libvalue)=0) s $List(listData,*+1)=libvalue
	.s $list(TmpArr("LabItmValueLimitProp"_$c(1)_$list(libvalue)))=obj.Val							// 指标值
	.s $list(TmpArr("LabItmValueLimitProp"_$c(1)_$list(libvalue),"Ext"))=obj.Val_obj.Unit
	.s TmpArr("LabItmValueLimitProp"_$c(1)_$list(libvalue),"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.Unit)	// 指标单位
	.s $list(TmpArr("LabItmValueLimitProp"_$c(1)_$list(libvalue),"Unit","Ext"))=obj.Unit
	
	s TmpArr("LabItm")=listData
	s TmpArr("LabItm","Ext")=listDataExt
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-26
/// Descript: 		初始化信息药品
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitDrug("OnceDose")
ClassMethod InitDrug(arrsObj, TmpArr)
{
	n (arrsObj,TmpArr)
	
	s listData="",listDataExt=""
	s hospId = ""
	//i ##class(web.DHCCKBConfig).SysUser()'[$g(TmpArr("HospitalID")) d
	s hospId=##class(web.DHCCKBCommon).GetHospIdByDesc($g(TmpArr("HospitalID")))
	
	s drug=arrsObj.%Get("Drug")	
	f i=1:1:drug.%Size()  d
	.s obj=drug.%Get(i-1)
	.q:obj.%Size()=0
	.s value=obj.item
	.q:value=""
	.s drugType = obj.DrugType
	.i drugType="ZYYP" s drugType="ChineseHerbalMedicine"
	.e  s drugType="Drug"
	.s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(value,drugType,hospId)	//(Drug,Ext) 记录的是没有对照的药品
	.s libvalue=$listget(libvalue)	 // 药品只能对照一个
	.q:libvalue=""
	.i (libvalue'=0)&&($lf(listDataExt,value)=0) s $List(listDataExt,*+1)=value
	.s libvalue=libvalue_$c(2)_i
	.s arciId = obj.ArciMastId
	.s arciId=$replace(arciId,"||","_")	
	.s seqNo = obj.SeqNo	// 序号
	.s:arciId="" arciId=seqNo
	.s unique = arciId_"_"_seqNo 
	
	.s $list(TmpArr("ArciMastId"_$c(1)_libvalue)) = arciId
	.i (+libvalue'=0)&&($listfind(listData,libvalue)=0) d
	..s $List(listData,*+1)=libvalue		// 所有对照的药品
	..s TmpArr("Drug",libvalue)=$listfromstring(value)	// 对照的药品描述	
	..s TmpArr("HisDrug",unique) = libvalue
	.
	.// 剂型
	.s TmpArr("FormProp"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.FormProp,"FromProp")	
	.s $list(TmpArr("FormProp"_$c(1)_libvalue,"Ext"))=obj.FormProp
	.// 给药途径
	.s TmpArr("DrugPreMet"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugPreMet,"DrugPreMet",hospId)	
	.s $list(TmpArr("DrugPreMet"_$c(1)_libvalue,"Ext"))=obj.DrugPreMet
	.// 单次剂量
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue))=obj.OnceDose						
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue,"Ext"))=$fn(obj.OnceDose,"N")_obj.Unit
	.//s onceDoseUnit = $case(obj.Unit["/"=1,1:$p(obj.Unit,"/",1),:obj.Unit) 
	.s TmpArr("OnceDose"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.Unit,"") // 单次剂量单位		
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue,"Unit","Ext"))=obj.Unit
	.// 日剂量(2023-05-19 增加日剂量, his端的日剂量根据频次可设置每次剂量, 不在等于频次*单次剂量)
	.s $list(TmpArr("DayDose"_$c(1)_libvalue))=$case(obj.DayDose="undefined",1:"",:obj.DayDose)					
	.s $list(TmpArr("DayDose"_$c(1)_libvalue,"Ext"))=$fn(obj.DayDose,"N")_obj.Unit
	.s TmpArr("DayDose"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.Unit,"") // 日剂量单位		
	.s $list(TmpArr("DayDose"_$c(1)_libvalue,"Unit","Ext"))=obj.Unit
	.// 频率
	.s TmpArr("DrugFreq"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugFreq,"DrugFreq",hospId)		
	.s $list(TmpArr("DrugFreq"_$c(1)_libvalue,"Ext"))=obj.DrugFreq	
	.
	.s FreqList=##Class(web.DHCCKBPassNew).GetFreqFacUom(obj.DrugFreq)	
	.s $list(TmpArr("DrugFreq.FreqFactorProp"_$c(1)_libvalue))=$listGet(FreqList) // 频率转换系数
	.// 疗程		
	.s $list(TmpArr("Treatment"_$c(1)_libvalue))=$case(+obj.Treatment=0,1:"",:+obj.Treatment)				
	.s $list(TmpArr("Treatment"_$c(1)_libvalue,"Ext"))=obj.Treatment	
	.s TreatUnit = $p(obj.Treatment,+obj.Treatment,2)
	.s:TreatUnit="" TreatUnit="天"
	.s TmpArr("Treatment"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(TreatUnit,"") // 疗程单位
	.s $list(TmpArr("Treatment"_$c(1)_libvalue,"Unit","Ext"))=TreatUnit	// 疗程默认是天.
	.// 成组序号
	.s $list(TmpArr("LinkSeqNo"_$c(1)_libvalue))=$case(obj.LinkSeqNo="",1:obj.SeqNo,:obj.LinkSeqNo)
	.s $list(TmpArr("SeqNo"_$c(1)_libvalue))=obj.SeqNo	// 序号
	.s $list(TmpArr("IsFirstUseProp"_$c(1)_libvalue))=obj.FirstMark
	.s $list(TmpArr("OrdDate"_$c(1)_libvalue))=obj.OrdDate //医嘱日期
	.// 给药速度
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue))=+obj.DrugSpeedProp	
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Ext"))=obj.DrugSpeedProp_obj.DrugSpeedPropUnit 
	.s TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugSpeedPropUnit,"")	//给药速度
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Unit","Ext"))=obj.DrugSpeedPropUnit
	.//月度使用量
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue))=obj.MonthUsageProp						
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue,"Ext"))=obj.MonthUsageProp_obj.MonthUsagePropUnit
	.s TmpArr("MonthUsageProp"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.MonthUsagePropUnit,"") // 月度使用量	
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue,"Unit","Ext"))=obj.MonthUsagePropUnit
	.
	.// 皮试结果 2022-05-19
	.s $list(TmpArr("SkinResult"_$c(1)_libvalue))=$select(obj.SkinTest="Y":"阳性",obj.SkinTest="N":"阴性",1:"")
	.s $list(TmpArr("SkinResult"_$c(1)_libvalue,"Ext"))=$select(obj.SkinTest="Y":"阳性",obj.SkinTest="N":"阴性",1:"")
	.
	.// 初始化忽略配置 2022-06-21
	.d ##Class(web.DHCCKBDealParameter).InitIgnoreList(.TmpArr,libvalue)
	.d ##Class(web.DHCCKBDealParameter).InitIgnoreListByExt(.TmpArr,libvalue,$g(TmpArr("DrugPreMet"_$c(1)_libvalue)))
	.d ##Class(web.DHCCKBDealParameter).InitIgnoreListByExt(.TmpArr,libvalue,$g(TmpArr("DrugFreq"_$c(1)_libvalue)))
	.
	.// 获取并记录同源药品 2022-07-01
	.s conOrigDrug = ##Class(web.DHCCKBCommon).GetComOriginDrug(+libvalue)	// 有则返回同源药品,无则返回药品本身id
	.s $list(TmpArr("ComOriginDrug"_$c(1)_libvalue))=conOrigDrug
	.
	.// 医嘱优先级 2022-07-18 (即刻医嘱、PRN、临时医嘱、取药医嘱、长期医嘱、自备药即刻、出院带药、自备药长期、长期嘱托、临时嘱托)
	.s $list(TmpArr("OrderPriority"_$c(1)_libvalue))=obj.OrderPriority
	.s $list(TmpArr("OrderPriority"_$c(1)_libvalue,"Ext"))=obj.OrderPriority
	.
		
	s TmpArr("Drug")=listData
	s TmpArr("Drug","Ext")=listDataExt
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-29
/// Descript: 		初始化应用场景
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitRequestAction(arrsObj,TmpArr)
ClassMethod InitRequestAction(arrsObj, TmpArr) As %String
{
	n (arrsObj,TmpArr)
	
	s TmpArr("Action") = arrsObj.%Get("Action")
	s TmpArr("UseType") = arrsObj.%Get("UseType")
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		获取药品的属性值(入参)
/// Input:			单次给药量Code
/// w ##Class(web.DHCCKBDealParameter).GetDurgPropValue()
ClassMethod GetDurgPropValue(DrugId, TmpArr, Prop) As %String
{
	n (DrugId,TmpArr,Prop)
	
	// 如单次剂量
	
	s Value=$g(TmpArr(DrugId_$c(1)_Prop))
	
	q Value
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		获取单次给药剂量
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).GetDurgPropValue(.TmpArr)
ClassMethod GetOnceDose(TmpArr) As %String
{
	n (TmpArr)
	
	s CalcDrug=$g(TmpArr("ClacDrug"))	// 需要取值的药品
	s Value=$g(TmpArr("OnceDose"_$c(1)_CalcDrug))
	i $listvalid(Value)=1 s Value=$listtostring(Value)
	
	q Value
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		药品的频率的转换系数
/// Input:			单次给药量Code
/// w ##Class(web.DHCCKBComplexArith).GetDrugFreqNum(TmpArr)
ClassMethod GetDrugFreqNum(TmpArr) As %String
{
	n (TmpArr)
	
	s CalcDrug=$g(TmpArr("ClacDrug"))	// 需要取值的药品
	
	s FreqID=$g(TmpArr("DrugFreq"_$c(1)_CalcDrug))
	i $listvalid(FreqID)=1 s FreqID=$listtostring(FreqID)
	
	s FreqFacUnitProp=##class(web.DHCCKBCommon).GetFreqFactorUnitProp()   // 用药频次转换因子单位
	s FreqFacProp=##class(web.DHCCKBCommon).GetFreqFactorProp()			  // 用药频次转换因子
	
	s FreqNum=1
	
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",FreqID,FreqFacUnitProp,LinkID))  q:LinkID=""  d
	.s FreqUnit=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(FreqUnit)),5)
	.q:FreqUnit=""
	.s FreqUnitDesc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(FreqUnit)),3))
	.q:FreqUnitDesc'="次/日"
	.s Group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),6)	
	.
	.s FreqLinkID=""
	.f  s FreqLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",FreqID,FreqFacProp,FreqLinkID))  q:FreqLinkID=""  d
	..q:Group'=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(FreqLinkID)),6)	
	..s FreqNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
	b ;shy
	q FreqNum
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		药品的溶媒体积
/// Input:			
/// w ##Class(web.DHCCKBComplexArith).GetSolventvolume(TmpArr,CalcItm)
ClassMethod GetSolventvolume(TmpArr, CalcItm) As %String
{
	
	n (TmpArr,CalcItm)
	// 先判断有没有溶媒药品，在判断检测药品是不是和溶媒药品成组,之后再计算体积
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s RulID=TmpArr("RulID")
	s ID=TmpArr("ID")
	
	s TmpDicID="",IsExistFlag=0,solutionItmID=""
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList) q:(IsExistFlag=1)  d
	.s TmpDicID=$list(DrugList,Num)
	.q:CheckDicID=TmpDicID
	.s FindItm=$select(CalcItm="Solventvolume":"SolventProp",CalcItm="SolutionVolume":"SolutionProp",1:"")
	.q:FindItm=""
	.s LinkItmID=##Class(web.DHCCKBPassNew).GetLinkItm(RulID,ID,FindItm)	// 需要找到规则中溶媒/溶液药品
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,+TmpDicID)			// 找到入参中的溶媒/溶液药品
	.s HisGroupFlag=##Class(web.DHCCKBPassNew).ISGroup(CheckDicID,TmpDicID,.TmpArr)		// 判断找到的his入参中的溶媒,是否和检测药品成组,非成组则不计算
	.q:HisGroupFlag=0
	.s IsExistFlag=1
	.s SolutionItmID=TmpDicID

	q:IsExistFlag=0 ""
	
	s HisQty=$g(TmpArr("OnceDose"_$c(1)_SolutionItmID))	// his体积
	s HisQtyUom=$g(TmpArr("OnceDose"_$c(1)_SolutionItmID,"Unit"))
	s HisQtyUomExt=$g(TmpArr("OnceDose"_$c(1)_SolutionItmID,"Unit","Ext"))
	
	s TmpArr(CalcItm_$c(1)_CheckDicID)=HisQty
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Ext")=HisQty_HisQtyUomExt
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit")=HisQtyUom
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit","Ext")=HisQtyUomExt

	q 1
}

/// CreateDate: 	2020-04-23
/// Descript: 		药品的溶媒浓度
/// Input:			
/// w ##Class(web.DHCCKBComplexArith).SetSolutionDensity(TmpArr,CalcItm)
ClassMethod GetSolutionDensity(TmpArr, CalcItm) As %String
{
	n (TmpArr,CalcItm)
			
	// 先判断有没有溶媒药品，在判断检测药品是不是和溶媒药品成组,之后再计算浓度
	s CheckDicID=TmpArr("CheckDicID")	/// 审查项目(药品)
	s RulID=TmpArr("RulID")
	s ID=TmpArr("ID")
	
	s TmpDicID="",IsExistFlag=0,SolVolume=0,solutionItmID=""
	s DrugList=$g(TmpArr("Drug"))
	f Num=1:1:$listlength(DrugList) q:(IsExistFlag=1)  d
	.s TmpDicID=$list(DrugList,Num)
	.q:CheckDicID=TmpDicID
	.s FindItm=$select(CalcItm="SolventDensity":"SolventProp",CalcItm="SolutionDensity":"SolutionProp",1:"")
	.q:FindItm=""
	.s LinkItmID=##Class(web.DHCCKBPassNew).GetLinkItm(RulID,ID,FindItm)	// 需要找到规则中溶媒/溶液药品
	.q:LinkItmID=""
	.q:'$LISTFIND(LinkItmID,+TmpDicID)			// 找到入参中的溶媒/溶液药品
	.s HisGroupFlag=##Class(web.DHCCKBPassNew).ISGroup(CheckDicID,TmpDicID,.TmpArr)		// 判断找到的his入参中的溶媒,是否和检测药品成组,非成组则不计算
	.q:HisGroupFlag=0
	.s IsExistFlag=1
	.s solutionItmID=TmpDicID
	q:IsExistFlag=0 0
	
	// 计算浓度
	s HisSoluteQty=$g(TmpArr("OnceDose"_$c(1)_CheckDicID))	// his溶质剂量
	s HisSoluteUom=$g(TmpArr("OnceDose"_$c(1)_CheckDicID,"Unit"))
	s HisSoluteUomDesc=$case(HisSoluteUom="",1:"",:$lg(^CT.CKB.PDSS.CommonDictionD($listGet(HisSoluteUom)),3))		
	s HisSolventQty=$g(TmpArr("OnceDose"_$c(1)_solutionItmID))	// his溶媒
	s HisSolventUom=$g(TmpArr("OnceDose"_$c(1)_solutionItmID,"Unit"))
	s HisSolventUomDesc=$case(HisSolventUom="",1:"",:$lg(^CT.CKB.PDSS.CommonDictionD($listget(HisSolventUom)),3))
	
	s HisDensity=$listGet(HisSoluteQty)/$listget(HisSolventQty)		// his浓度
	s HisDensityUomExt=HisSoluteUomDesc_"/"_HisSolventUomDesc
	s HisDensityUom=##Class(web.DHCCKBPassNew).GetComDicIdNew(HisDensityUomExt,"")

	// 入参赋值
	s TmpArr(CalcItm_$c(1)_CheckDicID)=$lb(HisDensity)
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Ext")=$lb(HisDensity_HisDensityUomExt)
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit")=HisDensityUom
	s TmpArr(CalcItm_$c(1)_CheckDicID,"Unit","Ext")=$lb(HisDensityUomExt)

	q 1
}

/// CreateDate: 	2020-05-06
/// Creator:		sufan 
/// Descript: 		累计用药时长计算  本次疗程+历次未完的疗程（疗程-（医嘱时间-历次医嘱时间）)
/// Input:			入参串
/// w ##Class(web.DHCCKBDealParameter).CumulatMedDurat(TmpArr,Key) 
ClassMethod CumulatMedDurat(TmpArr, Key)
{
	n (TmpArr,Key)
	s CheckID=TmpArr("CheckDicID")														//审查项目(药品)
	s Treat=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID)))						//疗程值
	s TreatUnit=$listtostring($g(TmpArr("Treatment"_$c(1)_CheckID,"Unit")))   			//疗程单位
	s OrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_CheckID)))						//医嘱时间
	s:OrdDate'="" OrdDate=$zdh(OrdDate,3)
	s:OrdDate="" OrdDate=+$h
	s ItmList=$g(TmpArr("Drug"))
	f i=1:1:$listlength(ItmList) d
	.s Itmid=$list(ItmList,i)
	.q:+Itmid=0
	.i +Itmid=+CheckID d
	..s ItmOrdDate=$listtostring($g(TmpArr("OrdDate"_$c(1)_Itmid)))						//医嘱时间
	..q:ItmOrdDate=""
	..s ItmOrdDate=$zdh(ItmOrdDate,3)
	..q:ItmOrdDate'<OrdDate
	..s $list(TmpArr(Key_$c(1)_CheckID))=(Treat+($listtostring($g(TmpArr("Treatment"_$c(1)_Itmid)))-(OrdDate-ItmOrdDate)))
	..s $list(TmpArr(Key_$c(1)_CheckID,"Unit"))=TreatUnit   //疗程单位
	..s $list(TmpArr(Key_$c(1)_CheckID,"Unit","Ext"))=(Treat+($listtostring($g(TmpArr("Treatment"_$c(1)_Itmid)))-(OrdDate-ItmOrdDate)))_TreatUnit			//疗程值
	Q ""
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		疗程（计算整包装数）   整包装数*规格/（频次*单次剂量）   
/// Input:			入参串
/// w ##Class(web.DHCCKBDealParameter).CumulatMedDurat(TmpArr,Key)
ClassMethod GetPackageNum(TmpArr)
{
	n (TmpArr)
	/*
	 *整包装数：PackNum
	 *规格：Specificat
	 *
	*/
	Q TmpArr("PackNum")*TmpArr("Specificat")
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		处方里药品数量
/// Input:			临时数组，节点(drug),属性值
/// w ##Class(web.DHCCKBDealParameter).CumulatMedDurat(TmpArr,Key)
ClassMethod Count(TmpArr, Node, TempCode)
{
	n (TmpArr,Node,TempCode)
	/*
	 *处方号：PresNo
	 *
	*/
	s CheckID=TmpArr("CheckDicID")	
	s PresNo=TmpArr(TempCode_$c(1)_CheckID)
	s count=0
	s ItmList=$g(TmpArr(Node))
	f i=1:1:$listlength(ItmList) d
	.s Itmid=$list(ItmList,i)
	.q:+Itmid=0
	.s ItmPresNo=$listtostring($g(TmpArr(TempCode_$c(1)_Itmid)))
	.Q:PresNo'=ItmPresNo
	.s count=count+1
	Q count
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		肌酐清楚率 
/// Input:			数据源列表，查找项目列表(如果多个，是且的关系)
/// w ##Class(web.DHCCKBDealParameter).getRenalInsu(TmpArr,"")
ClassMethod getRenalInsu(TmpArr, Node, TempCode, LabItem)
{
	n (TmpArr, Node,TempCode,LabItem)
 	//Q (140-..getPropValue("AgeProp"))*..getPropValue("Weight")/(0.818*..getScr(.TmpArr,Node,LabItem))
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		取血肌酐
/// Input:			数据源列表，节点(drug等)，属性code，检验项目
/// w ##Class(web.DHCCKBDealParameter).getScr(TmpArr,"")
ClassMethod getScr(TmpArr, Node, TempCode, LabItem)
{
	n (TmpArr,Node,TempCode,LabItem)
	/*
	 *检验指标：LabItmValueLimitProp
	 *
	*/
	s InspectList=$g(TmpArr(Node))							//数据列表
	f i=1:1:$listlength(InspectList) d						//循环检验项目，取出血肌酐值进行计算
	.s LabitmId=$list(InspectList,i)
	.Q:LabitmId=""
	.s LabDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LabitmId)),3)			//检验项目rop
	.Q:LabDesc'=LabItem			
	.s LabValue=$g(TmpArr(TempCode_$c(1)_LabitmId))			// 指标值
	.s:$listvalid(LabValue)=1 LabValue=$listget(LabValue)
	Q LabValue
}

/// CreateDate: 	2020-05-08
/// Creator:		sufan 
/// Descript: 		重复用药 
/// Input:			数据源列表，查找项目列表(如果多个，是且的关系)
/// w ##Class(web.DHCCKBDealParameter).Distinct("","Drug","")
ClassMethod Distinct(TmpArr, Node, KeyArr)
{
	n (TmpArr, Node,KeyArr)
	s TmpArr = ..GetTempParam(.TmpArr)
	s KeyArr = $lb("FormProp")
	k ItemArr
	s checkID=TmpArr("CheckDicID")							//当前药品
	s ItemList=$g(TmpArr(Node))								//数据列表
	f i=1:1:$listlength(ItemList) d							//循环数据列表
	.s ItemId=+$list(ItemList,i)
	.Q:ItemId=""
	.s attrLength = $listlength(KeyArr)						//属性数量
	.for j=1:1:attrLength  d
	..s attrCode = $list(KeyArr,j)							//属性code
	..s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	..s attrValList = ..GetSysItemValue(ItemId,attrId)		//取值
	..s ItemArr(ItemId,attrId) = attrValList
	
	s ret = 0
	s count = 0
	s comAttrlength = $listlength(KeyArr)					//属性数量
	for i=1:1:comAttrlength  d
	.s attrCode = $list(KeyArr,i)							//属性code
	.s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	.s comAttrValList = ItemArr(checkID,attrId)
	.s index = ""
	.for  s index = $o(ItemArr(index))  Q:index=""  d
	..Q:index=checkID
	..s curAttrValList = ItemArr(index,attrId)	
	..s ret = ..Compare(comAttrValList,curAttrValList)
	..i ret '= "" d
	...s count = count+1 
	...s QuitArr(index,attrId) = ret
	.Q:count=0
	.
	Q count
}

/// Descript:比较是否重复
/// Creator:sufan
/// CreateDate:2020-05-27
/// Input:属性值列表，比较属性值列表
/// w ##class(web.DHCCKBDealParameter).Compare("123,321,231","123,321")
ClassMethod Compare(comAttrValList, curAttrValList)
{
	n (comAttrValList,curAttrValList)
	s ret = ""
	Q:(comAttrValList="")||(curAttrValList="") ret
	s valLength = $l(curAttrValList,",")
	
	i valLength = 1 d
	.s:comAttrValList[curAttrValList ret=curAttrValList
	e  d
	.for i=1:1:valLength  d
	..s attrVal = $p(curAttrValList,",",i)
	..i comAttrValList[attrVal  d
	...i ret = "" s ret = attrVal
	...e  s ret = ret _","_ attrVal
	Q ret
}

/// Descript：取知识库属性值
/// Creator:sufan
/// CreateDate:2020-05-27
/// Input:药品，药品属性
ClassMethod GetSysItemValue(drugId, drugAttrId)
{
	n (drugId,drugAttrId)
	s valList = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,drugAttrId,attrId)) Q:attrId=""  d
	.s propId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)			//属性值
	.s propVal = $lg($g(^CT.CKB.PDSS.CommonDictionD(propId)),3)			//描述
	.i valList = "" s valList = propVal
	.e  s valList = valList _","_ propVal
	Q valList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-04-25
/// Descript: 		判断患者是否是儿童
/// Input:			1 是 0 不是
/// w ##Class(web.DHCCKBDealParameter).CheckPatIsChild()
ClassMethod CheckPatIsChild(TmpArr)
{
	n (TmpArr)
	s childFlag = 0 
	s patage = $lts(TmpArr("AgeProp","Ext"))
	i patage["岁" d
	.s patagenum = +patage
	.i patage<=18 s childFlag = 1
	.i childFlag=1 s TmpArr("PatChildFlag")=childFlag
	e  d
	.s childFlag = 1
	.i childFlag=1 s TmpArr("PatChildFlag")=childFlag
	
	q:childFlag=1 1
	
	s childList=$lb("小儿","婴儿","儿童","新生儿","青少年","婴幼儿","幼儿","新生儿（足月产）","学龄前儿童","学龄儿童","新生儿（早产儿）","新生儿（低体重儿）","早产儿")
	s specialList = $g(TmpArr("SpecialPop"))
	f i=1:1:$ll(specialList) q:childFlag=1  d
	.s special = $lg(specialList,i)
	.s value = $lg($g(^CT.CKB.PDSS.CommonDictionD(+special)),3)
	.q:value=""
	.i $lf(childList,value)'=0 s childFlag=1
	
	s TmpArr("PatChildFlag")=childFlag
	
	q childFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-05-11
/// Descript: 		初始化历史医嘱信息
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitHisOrder("OnceDose")
ClassMethod InitHisOrder(arrsObj, TmpArr)
{
	n (arrsObj,TmpArr)
	
	s listData="",listDataExt=""
	s hospId = ""
	//i ##class(web.DHCCKBConfig).SysUser()'[$g(TmpArr("HospitalID")) d
	s hospId=##class(web.DHCCKBCommon).GetHospIdByDesc($g(TmpArr("HospitalID")))
	
	s drug=arrsObj.%Get("ItemHisOrder")	
	q:drug="" ""
	f i=1:1:drug.%Size()  d
	.s obj=drug.%Get(i-1)
	.q:obj.%Size()=0
	.s value=obj.item
	.q:value=""
	.s libvalue=##class(web.DHCCKBPassNew).GetComDicIdNew(value,"Drug")	//(Drug,Ext) 记录的是没有对照的药品
	.s libvalue=$listget(libvalue)	 // 药品只能对照一个
	.q:libvalue=""
	.i (libvalue'=0)&&($lf(listDataExt,value)=0) s $List(listDataExt,*+1)=value
	.s libvalue=libvalue_$c(2)_i_"His"
	.s arciId = obj.ArciMastId
	.s arciId=$replace(arciId,"||","_")	
	.s seqNo = obj.SeqNo	// 序号
	.s:arciId="" arciId=seqNo
	.s unique = arciId_"_"_seqNo 
	
	.s $list(TmpArr("ArciMastId"_$c(1)_libvalue)) = arciId
	.i (+libvalue'=0)&&($listfind(listData,libvalue)=0) d
	..s $List(listData,*+1)=libvalue		// 所有对照的药品
	..s TmpArr("ItemHisOrder",libvalue)=$listfromstring(value)	// 对照的药品描述	
	.
	.// 剂型
	.s TmpArr("FormProp"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.FormProp,"FromProp")	
	.s $list(TmpArr("FormProp"_$c(1)_libvalue,"Ext"))=obj.FormProp
	.// 给药途径
	.s TmpArr("DrugPreMet"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugPreMet,"DrugPreMet",hospId)	
	.s $list(TmpArr("DrugPreMet"_$c(1)_libvalue,"Ext"))=obj.DrugPreMet
	.// 单次剂量
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue))=obj.OnceDose						
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue,"Ext"))=$fn(obj.OnceDose,"N")_obj.Unit
	.//s onceDoseUnit = $case(obj.Unit["/"=1,1:$p(obj.Unit,"/",1),:obj.Unit) 
	.s TmpArr("OnceDose"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.Unit,"") // 单次剂量单位		
	.s $list(TmpArr("OnceDose"_$c(1)_libvalue,"Unit","Ext"))=obj.Unit
	.// 频率
	.s TmpArr("DrugFreq"_$c(1)_libvalue)=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugFreq,"DrugFreq",hospId)		
	.s $list(TmpArr("DrugFreq"_$c(1)_libvalue,"Ext"))=obj.DrugFreq	
	.s FreqList=##Class(web.DHCCKBPassNew).GetFreqFacUom(obj.DrugFreq)	
	.s $list(TmpArr("DrugFreq.FreqFactorProp"_$c(1)_libvalue))=$listGet(FreqList) // 频率转换系数
	.// 疗程		
	.s $list(TmpArr("Treatment"_$c(1)_libvalue))=$case(+obj.Treatment=0,1:"",:+obj.Treatment)				
	.s $list(TmpArr("Treatment"_$c(1)_libvalue,"Ext"))=obj.Treatment	
	.s TreatUnit = $p(obj.Treatment,+obj.Treatment,2)
	.s:TreatUnit="" TreatUnit="天"
	.s TmpArr("Treatment"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(TreatUnit,"") // 疗程单位
	.s $list(TmpArr("Treatment"_$c(1)_libvalue,"Unit","Ext"))=TreatUnit	// 疗程默认是天.
	.// 成组序号
	.s $list(TmpArr("LinkSeqNo"_$c(1)_libvalue))=obj.LinkSeqNo
	.s $list(TmpArr("SeqNo"_$c(1)_libvalue))=obj.SeqNo	// 序号
	.s $list(TmpArr("IsFirstUseProp"_$c(1)_libvalue))=obj.FirstMark
	.s $list(TmpArr("OrdDate"_$c(1)_libvalue))=obj.OrdDate //医嘱日期
	.// 给药速度
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue))=+obj.DrugSpeedProp	
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Ext"))=obj.DrugSpeedProp_obj.DrugSpeedPropUnit 
	.s TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.DrugSpeedPropUnit,"")	//给药速度
	.s $list(TmpArr("DrugSpeedProp"_$c(1)_libvalue,"Unit","Ext"))=obj.DrugSpeedPropUnit
	.//月度使用量
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue))=obj.MonthUsageProp						
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue,"Ext"))=obj.MonthUsageProp_obj.MonthUsagePropUnit
	.s TmpArr("MonthUsageProp"_$c(1)_libvalue,"Unit")=##class(web.DHCCKBPassNew).GetComDicIdNew(obj.MonthUsagePropUnit,"") // 月度使用量	
	.s $list(TmpArr("MonthUsageProp"_$c(1)_libvalue,"Unit","Ext"))=obj.MonthUsagePropUnit
	.
	
	s TmpArr("ItemHisOrder")=listData
	s TmpArr("ItemHisOrder","Ext")=listDataExt
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-06-21
/// Descript: 		根据药品,得到忽略的目录/项目列表
/// Input:			dicID(药品id),给药途径/频率list
/// w ##Class(web.DHCCKBDealParameter).InitIgnoreList(.TmpArr,12)
ClassMethod InitIgnoreList(TmpArr, dicID, valueList = "")
{
	n (TmpArr, dicID,valueList)
	
	s markDicID = dicID
	s dicID = +dicID
	q:('$d(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","Drug",dicID)))&&('$d(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","DrugLink",dicID))) ""
	
	s ignoreLibList = ""	// 忽略目录列表
	s inoreItemList = ""	// 忽略计算项目列表
	s itemFlagList = $lb("D","I")	
	
	// Drug(药品(西药、中药、中药饮片)、分类、通用名、商品名、剂型)
	i $d(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","Drug",dicID)) d	
	.f i=1:1:$ll(itemFlagList)  d
	..s itemFlag = $lg(itemFlagList,i)
	..s itemId = ""
	..f  s itemId = $o(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","Drug",dicID,itemFlag,itemId)) q:itemId=""  d
	...	//忽略目录/项目
	...i itemFlag="D" d
	....q:$lf(ignoreLibList,itemId)'=0
	....s $list(ignoreLibList,*+1)=itemId
	...i itemFlag="I" d
	....q:$lf(inoreItemList,itemId)'=0
	....s $list(inoreItemList,*+1)=itemId

	// DrugLink(2化学名、2成分、2辅料)  先保持和之前的忽略逻辑一样,需要修改。不能直接取药品的忽略
	i $d(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","DrugLink",dicID)) d	
	.f i=1:1:$ll(itemFlagList)  d
	..s itemFlag = $lg(itemFlagList,i)
	..s itemId = ""
	..f  s itemId = $o(^CF.CKB.PDSS.IgnoreDataPoolI("IgnoreType","DrugLink",dicID,itemFlag,itemId)) q:itemId=""  d
	...	//忽略目录/项目
	...i itemFlag="D" d
	....q:$lf(ignoreLibList,itemId)'=0
	....s $list(ignoreLibList,*+1)=itemId
	...i itemFlag="I" d
	....q:$lf(inoreItemList,itemId)'=0
	....s $list(inoreItemList,*+1)=itemId		
	
	s TmpArr("InitIgnore","D",markDicID)=ignoreLibList	// 忽略目录
	s TmpArr("InitIgnore","I",markDicID)=inoreItemList	// 忽略项目
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-06-21
/// Descript: 		根据药品,his参数 得到忽略的目录/项目列表
/// Input:			dicID(药品id),给药途径/频率list
/// w ##Class(web.DHCCKBDealParameter).InitIgnoreListByExt(.TmpArr,12)
ClassMethod InitIgnoreListByExt(TmpArr, dicID, valueList)
{
	n (TmpArr, dicID,valueList)
	
	q:valueList="" ""
	s markDicID = dicID
	s dicID = +dicID
	q:('$d(^CF.CKB.PDSS.IgnoreDataPoolI("IngoreTypeValue","DrugExt",dicID))) ""
		
	s ignoreLibList = $g(TmpArr("InitIgnore","D",markDicID))	// 忽略目录列表
	s inoreItemList = $g(TmpArr("InitIgnore","I",markDicID))	// 忽略计算项目列表
		
	// DrugExt(给药途径、用药频率)
	s itemFlagList = $lb("D","I")
	f i=1:1:$ll(itemFlagList)  d
	.s itemFlag = $lg(itemFlagList,i)	
	.f k=1:1:$ll(valueList) d	// 频率/途径list
	..s value = $lg(valueList,k)
	..q:value=""
	..s itemId = ""
	..f  s itemId = $o(^CF.CKB.PDSS.IgnoreDataPoolI("IngoreTypeValue","DrugExt",dicID,value,itemFlag,itemId)) q:itemId=""  d
	...q:+itemId=0
	...i itemFlag="D" d
	....q:$lf(ignoreLibList,itemId)'=0
	....s $list(ignoreLibList,*+1)=itemId
	...i itemFlag="I" d
	....q:$lf(inoreItemList,itemId)'=0
	....s $list(inoreItemList,*+1)=itemId	
	
	s TmpArr("InitIgnore","D",markDicID)=ignoreLibList	// 忽略目录
	s TmpArr("InitIgnore","I",markDicID)=inoreItemList	// 忽略项目
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-07-07
/// Descript: 		初始化审核权限
/// Input:			
/// w ##Class(web.DHCCKBDealParameter).InitIgnoreListByExt(.TmpArr,12)
ClassMethod InitPermisList(TmpArr)
{
	n (TmpArr)
	s userInfo = $g(TmpArr("UserInfo"))
	q:userInfo="" ""
	s accFlag = $g(TmpArr("AccFlag"))
	q:accFlag="N" ""
		
	s userId=$p(userInfo,"^",1)	// 用户
	s proId=$p(userInfo,"^",2)	// 职称
	s locId=$p(userInfo,"^",3)	// 科室
	s groupId=$p(userInfo,"^",4)	// 安全组
	s hospId=$p(userInfo,"^",5)		// 医院	
	
	// userInfo 入参中传递的是描述,配置存的是id,暂时先转换一下
	s userId=##class(web.DHCCKBCommon).GetUserIdByDesc(userId)
	s proId=##class(web.DHCCKBCommon).GetProfessIdByDesc(proId)
	s locId=##class(web.DHCCKBCommon).GetLocIdByDesc(locId)
	s hospId=##class(web.DHCCKBCommon).GetHospIdByDesc(hospId)
	
	// 医院^职称^科室^人员
	s permisstr = hospId_"^"_proId_"^"_locId_"^"_userId
	d ##Class(web.DHCCKBGrantAuth).GetUserGrantItem(permisstr, .TmpArr)
	
	q ""
}

ClassMethod GetTempParam(TmpArr)
{
	n (TmpArr)
	s TmpArr("Action")=""
	s TmpArr("AgeProp")=$lb(4)
	s TmpArr("AgeProp","Ext")=$lb("4岁")
	s TmpArr("AgeProp","Unit")=$lb("75316")
	s TmpArr("AgeProp","Unit","Ext")=$lb("岁")
	s TmpArr("CarePrvID")="Demo Group"
	s TmpArr("CheckDicID")="152"_$c(2)_"2"
	s TmpArr("ClientIP")=""
	s TmpArr("Disease")=$lb("15516","87313")
	s TmpArr("Disease","Ext")=$lb("高血压","男性促性腺激素功能不足")
	s TmpArr("DocLocID")="呼吸内科门诊"
	s TmpArr("Drug")=$lb("87288"_$c(2)_"1","152"_$c(2)_"2")
	s TmpArr("Drug","152"_$c(2)_"2")=$lb("注射用苄星青霉素")
	s TmpArr("Drug","87288"_$c(2)_"1")=$lb("注射用绒促性素1000U(丽珠集团丽珠制药厂）")
	s TmpArr("Drug","Ext")=$lb("注射用绒促性素1000U(丽珠集团丽珠制药厂）","注射用苄星青霉素")
	s TmpArr("DrugFreq"_$c(1)_"152"_$c(2)_"2")=$lb("5725")
	s TmpArr("DrugFreq"_$c(1)_"152"_$c(2)_"2","Ext")=$lb("qd")
	s TmpArr("DrugFreq"_$c(1)_"87288"_$c(2)_"1")=$lb("5725")
	s TmpArr("DrugFreq"_$c(1)_"87288"_$c(2)_"1","Ext")=$lb("qd")
	s TmpArr("DrugPreMet"_$c(1)_"152"_$c(2)_"2")=$lb("4098")
	s TmpArr("DrugPreMet"_$c(1)_"152"_$c(2)_"2","Ext")=$lb("静脉注射")
	s TmpArr("DrugPreMet"_$c(1)_"87288"_$c(2)_"1")=$lb("3927")
	s TmpArr("DrugPreMet"_$c(1)_"87288"_$c(2)_"1","Ext")=$lb("静脉滴注")
	s TmpArr("DrugSpeedProp"_$c(1)_"152"_$c(2)_"2")=$lb(0)
	s TmpArr("DrugSpeedProp"_$c(1)_"152"_$c(2)_"2","Ext")=$lb("")
	s TmpArr("DrugSpeedProp"_$c(1)_"152"_$c(2)_"2","Unit")=$lb("")
	s TmpArr("DrugSpeedProp"_$c(1)_"152"_$c(2)_"2","Unit","Ext")=$lb("")
	s TmpArr("DrugSpeedProp"_$c(1)_"87288"_$c(2)_"1")=$lb(0)
	s TmpArr("DrugSpeedProp"_$c(1)_"87288"_$c(2)_"1","Ext")=$lb("")
	s TmpArr("DrugSpeedProp"_$c(1)_"87288"_$c(2)_"1","Unit")=$lb("")
	s TmpArr("DrugSpeedProp"_$c(1)_"87288"_$c(2)_"1","Unit","Ext")=$lb("")
	s TmpArr("FormProp"_$c(1)_"152"_$c(2)_"2")=$lb("4118")
	s TmpArr("FormProp"_$c(1)_"152"_$c(2)_"2","Ext")=$lb("注射剂")
	s TmpArr("FormProp"_$c(1)_"87288"_$c(2)_"1")=$lb("4118")
	s TmpArr("FormProp"_$c(1)_"87288"_$c(2)_"1","Ext")=$lb("注射剂")
	s TmpArr("GroupID")="Demo Group"
	s TmpArr("Height")=$lb("70")
	s TmpArr("Height","Ext")=$lb("70cm")
	s TmpArr("Height","Unit")=$lb("85617")
	s TmpArr("Height","Unit","Ext")=$lb("cm")
	s TmpArr("HisAllergy","Ext")=""
	s TmpArr("HospitalID")="东华标准版数字化医院[总院]"
	s TmpArr("ID")=454405
	s TmpArr("IsFirstUseProp"_$c(1)_"87288"_$c(2)_"1")=$lb("")
	s TmpArr("LabItm")=""
	s TmpArr("LabItm","Ext")=""
	s TmpArr("Label")=74540
	s TmpArr("SeqNo"_$c(1)_"152"_$c(2)_"2")=$lb("2")
	s TmpArr("SeqNo"_$c(1)_"87288"_$c(2)_"1")=$lb("1")
	s TmpArr("SexProp")=$lb("146")
	s TmpArr("SexProp","Ext")=$lb("男")
	s TmpArr("SpecialPop")=""
	s TmpArr("SpecialPop","Ext")=$lb("肾功能不全")
	s TmpArr("TipsPath")=0
	s TmpArr("Treatment"_$c(1)_"152"_$c(2)_"2")=$lb(0)
	s TmpArr("Treatment"_$c(1)_"152"_$c(2)_"2","Ext")=$lb("")
	s TmpArr("Treatment"_$c(1)_"152"_$c(2)_"2","Unit")=$lb("")
	s TmpArr("Treatment"_$c(1)_"152"_$c(2)_"2","Unit","Ext")=$lb("")
	s TmpArr("Treatment"_$c(1)_"87288"_$c(2)_"1")=$lb(0)
	s TmpArr("Treatment"_$c(1)_"87288"_$c(2)_"1","Ext")=$lb("")
	s TmpArr("Treatment"_$c(1)_"87288"_$c(2)_"1","Unit")=$lb("")
	s TmpArr("Treatment"_$c(1)_"87288"_$c(2)_"1","Unit","Ext")=$lb("")
	s TmpArr("UserInfo")="Demo Group^主任医师^呼吸内科门诊^Demo Group^东华标准版数字化医院[总院]"  
	s TmpArr("Weight")=$lb("62")
	s TmpArr("Weight","Ext")=$lb("62kg")
	s TmpArr("Weight","Unit")=$lb("4337")
	s TmpArr("Weight","Unit","Ext")=$lb("kg")
	s TmpArr("CheckDicID")=87288
	Q TmpArr
}

}
