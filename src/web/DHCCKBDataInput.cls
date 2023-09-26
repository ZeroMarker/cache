Import sqluser

Class web.DHCCKBDataInput Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:提交规则
/// Creator:wangxin
/// CreateDate:2020-12-10
/// w ##class(web.DHCCKBDataInput).SubmitRule("")
ClassMethod SubmitRule(GroupNo, LoginInfo)
{
	n (GroupNo,LoginInfo)
	s baseObj={}
	s ruleObj={}		//规则
	s outPutObj={}		//输出
	s labGenObj={}
	s linkDoseobj={}
	s emRuleObj={}      //空规则key记录
	s ExlanMsg=""
	s MainId=""
	s Temp=""
	s Err=0
	s count=0
	//导入^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId)数据
	
	for  s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId))   Q:(MainId="")||(Err'=0)  d
	.s Temp=""
	.s TempId=$p(^DHCCKBRULEMAINTAIN(MainId),"^",4)     //获取要导入的global的RM_Temp
	.s:TempId'="" Temp=$lg($g(^CT.CKB.PDSS.CommonDictionD(TempId)),3)		    //CD_Desc   属性描述
	.s AttrId=$p(^DHCCKBRULEMAINTAIN(MainId),"^",1)     //属性
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)				            	//CD_Code   属性code
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),5)               //CD_Link_Dr   引用id  
	.s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)   //如果code为空且引用不为空,给code赋值为所引用的code
	.s Value=$p(^DHCCKBRULEMAINTAIN(MainId),"^",2)      //获取要导入的global的RM_Desc
	.s count=count+1
	.s:(count=1)&&((Code="MedDrugNameProp")||(Code="ChineseDrugNameProp"))&&(Value="") Err=-1
	.Q:Err'=0
	.i (Code="MedDrugNameProp")||(Code="ChineseDrugNameProp") d 					//通用名作为药品名称
	..s generID=..getGenerID(AttrId,Value)       //获取药品id
	..d labGenObj.%Set("generID",generID)								
	.i (count>1)&&(Code="MedDrugNameProp") d 				//记录西药   code为西药名称
	..d labGenObj.%Set("MedDrugName",Value)					
	.i (count>1)&&(Code="ChineseDrugNameProp") d //记录中药   code为中成药名称
	..d labGenObj.%Set("ChineseDrugName",Value)		
	.i Code="GenerNameFormProp"  d						         //记录通用名
	..d ruleObj.%Set("linkGeneName",Value)       
	.i Code="GenerNameProp"  d							            //通用名
	..d ruleObj.%Set("linkGeneNoDos",Value)
	.s ParentId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),4)      //获取CD_Parref_Dr
	.i ##class(web.DHCCKBDrugRuleMaintain).GetDrugCatDiction(AttrId)=1  d    //判断是否是药品目录字典，并返回目录字典id
	..d labGenObj.%Set("labelID",AttrId)								 
	.i Code="DrugCategory"  d                    //药学分类
	..i Value ["!"  d ruleObj.%Set("outLinkCat",$tr(Value,"!",""))		//除外的药品类型
	..e  d ruleObj.%Set("linkCat",Value)								
	.i Code="Ingredient"   d																     //成分
	..i Value ["!" d ruleObj.%Set("outLinkIngre",Value)					//除外的药品成分
	..e   d ruleObj.%Set("linkIngre",Value)							
	.i Code="环境因素" d ruleObj.%Set("outDrugAsaveOrUpdateDatallergy",Value)			//过敏
	.i Code="LabItmtemp" d ruleObj.%Set("linkLabItm",Value)				//检验指标
	.i Code="LabItmValueLimitProp" d ruleObj.%Set("linkLabValue",Value)	//检验指标值  范围值
	.i Code="AgeProp" d ruleObj.%Set("linkAge",Value)					//年龄
	.i Code="Weight" d ruleObj.%Set("linkWeight",Value)					//体重
	.i Code="SexProp" d ruleObj.%Set("linkSex",Value)					//性别
	.i Code="ProfessProp" d ruleObj.%Set("lilnkProfess",Value)			//职业
	.i Code="DrugPreMet" d ruleObj.%Set("linkPreMet",Value)				//给药途径
	.i Code="SolventProp" d ruleObj.%Set("linkSolvent",Value)			//溶媒（带剂型的通用名）
	.i Code="SolventDensity" d ruleObj.%Set("linkSolDens",Value)		//溶媒浓度
	.i Code="Solventvolume" d ruleObj.%Set("linkSolVolume",Value)		//溶媒体积
	.i Code="SolutionProp" d ruleObj.%Set("linkSolution",Value)			//溶液（带剂型的通用名）
	.i Code="SolutionDensity" d ruleObj.%Set("linkSolutionDens",Value)	//溶液浓度
	.i Code="SolutionVolume" d ruleObj.%Set("linkSolutionVolume",Value)	//溶液体积
	.i Code="DurgSpeedProp" d ruleObj.%Set("linkSpeed",Value)			//给药速度     --暂时数据库没有
	.i Code="DrugUseTime" d ruleObj.%Set("linkDrugUseTime",Value)		//给药时间
	.
	./*频次剂量用药时长拼串*/												//
	.i Code="OnceDose"  d linkDoseobj.%Set(Code,Value)					//单次给药剂量
	.i Code="DayDose"   d linkDoseobj.%Set(Code,Value)					//每日用药量
	.i Code="DrugFreq"  d linkDoseobj.%Set(Code,Value)					//用药频率
	.i Code="TreatDayNUm"  d linkDoseobj.%Set(Code,Value)				//疗程内用药时长
	./*频次剂量用药时长拼串*/
 .
	.i Code="IsFirstUseProp" d ruleObj.%Set("isFirst",Value)			//是否首次给药
	.i Code="DayDoseMax" d                                     
	..i Value'="" d ruleObj.%Set("linkDoseMax",Value_"/日")				//单日最大量
	.i Code="OnceDoseMax" d
	..i Value'="" d ruleObj.%Set("linkDoseMax",Value_"/次")				//单次最大量
	.i Code="DayDoseLimit"  d
	..i Value'="" d ruleObj.%Set("linkDoseLimit",Value_"/日")			//单日极量
	.i Code="OnceDoseLimit"  d
	..i Value'="" d ruleObj.%Set("linkDoseLimit",Value_"/次")			//单次极量
	.i Code="Treatment" d ruleObj.%Set("linkTreat",Value)				   //疗程
	.i Code="TreatBettenDayNum" d ruleObj.%Set("linkSpaceTreat",Value)	//疗程间间隔时长
	.i Code="carryUseDrugTime" d ruleObj.%Set("carryUseDrug",Value)		//连续用药时长
	.i Code="TogetherProp" d ruleObj.%Set("togetherType",Value)			//合用类别
	.i Code="SpecialPop" d ruleObj.%Set("linkPeople",Value)				//特殊人群
	.i Code="DiseaseDesc"   d
	..i Value["!" d ruleObj.%Set("outLinkDis",Value)				      	//除外病症
	..e  d ruleObj.%Set("linkDisease",Value) 							           //西医疾病名称
	.i Code="ChineseDiseaseName"	d									
	..i Value["!" d ruleObj.%Set("outCHNLinkDis",Value)					   //除外中医疾病
	..e  d ruleObj.%Set("linkCHNDisease",Value) 						         //中医疾病名称
	.i Code="BacteriaDesc"  d
	..i Value["!" d ruleObj.%Set("outLinkVirus",Value)					    //除外病原体
	..e  d ruleObj.%Set("linkVirus",Value) 							            	//细菌名称
	.i Code="BacteriaCaDesc"  d
	..d ruleObj.%Set("linkVirusCat",Value)								             //菌属名称
	.i Code="SymptomDesc"  d
	..i Value["!" d ruleObj.%Set("outLinkSym",Value)					      //除外症状
	..e  d ruleObj.%Set("linkSym",Value) 								              //症状名称
	.i Code="ProNameProp"  d											                        
	..d ruleObj.%Set("linkProName",Value)                      //商品名
	.//输出信息
	.i Code="ControlLevel"	 d
	..i Temp["过敏" d outPutObj.%Set("alertCat",Value_"(过敏)")		//警戒类型（慎用）
	..e  d outPutObj.%Set("alertCat",Value)                      //管制力度
	.i Code="WarnMessage"  d 
	..d outPutObj.%Set("linkErrMsg",Value)							               	//提示信息
	.s:(Code="LevelFlag")&&(Value="") Err=-2                         
	.Q:Err<0
	.i Code="LevelFlag"  d 
	..s Value=..GetLevByDesc(Value)                              //当code为LevelFlag时调用   
	..d outPutObj.%Set("levelMsg",Value)								                 //管理级别
	.i Code="SourceMsg"  d outPutObj.%Set("msgSource",Value)			  //提示依据
	.i Code="OutMsgTipsFlag"  d outPutObj.%Set("OutMsgTips",Value)	//消息提示标记
	.i Code="ExcipientProp" d ruleObj.%Set("itmExcipient",Value)   //辅料
	./**溶媒溶液**/
	.i Code="SingleSolMass" d ruleObj.%Set("sinSoluMass",Value)			 //单支溶质量
	.i Code="NeceSolMed" d ruleObj.%Set("isNeceSolMed",Value)			   //是否必用溶媒药品
	.i Code="SingleOrdVehVol" d ruleObj.%Set("sinOrdVehVol",Value)	//单次医嘱对应溶媒量
	.i Code="NeceSolDrug" d ruleObj.%Set("isNeceSolDrug",Value)			 //是否必用溶液药品
	.i Code="SingleOrdCorQua" d ruleObj.%Set("sinOrdCor",Value)			 //单次医嘱对应溶液量
	.i Code="AuxDrugsNum" d ruleObj.%Set("auxDrugsNum",Value)			   //辅助用药个数
	.i Code="BodySurAreaProp" d ruleObj.%Set("bodySurArea",Value)		//体表面积
	
	/***溶媒溶液key设置**/
	//单支溶质量 sinSoluMass,是否必用溶媒药品 isNeceSolMed,单次医嘱对应溶媒量 sinOrdVehVol
	//是否必用溶液药品 isNeceSolDrug,单次医嘱对应溶液量 sinOrdCor,辅助用药个数 auxDrugsNum
	
	s DayDos=""
	i linkDoseobj.%Get("OnceDose")'=""	s DayDos=linkDoseobj.%Get("OnceDose")	//单次给药剂量
	e  i (linkDoseobj.%Get("DayDose")'="")&&(DayDos="")  d
	.d linkDoseobj.%Set("DayDose",linkDoseobj.%Get("DayDose")_"/日")
	.s DayDos=linkDoseobj.%Get("DayDose")								//每日用药量
	
	s linkDose=DayDos_","_linkDoseobj.%Get("DrugFreq")_","_linkDoseobj.%Get("TreatDayNUm")   //DrugFreq  用药频率
	d ruleObj.%Set("linkDose",linkDose)									//剂量,频次,疗程内用药时长  给ruleobj对象赋值

	//空规则key设置
	s emRuleObj={}                                     //空规则key记录
	i Temp["用药指导(西药)" d                          //如果Temp包含"用药指导(西药)"
	.d emRuleObj.%Set("empRuletip","MedGuidRemProp")
	e  i Temp["用药指导(中成药）"  d                   //如果Temp包含"用药指导(中成药)"
	.d emRuleObj.%Set("empRuletip","ChnGuidRemProp")
	e  d 
	.d emRuleObj.%Set("empRuletip","TipsAtOnceProp")    
	
	//病原体,病原体组,病原体除外
	//与适应症相关的不明确列,特别推荐,手术时段
	s Str="商品名:"_ruleObj.%Get("linkProName")_"^通用名带剂型:"_ruleObj.%Get("linkGeneName")_"^药学分类:"_ruleObj.%Get("linkCat")
	s Str=Str_"^成分:"_ruleObj.%Get("linkIngre")_"^过敏:"_ruleObj.%Get("outDrugAllergy")_"^年龄:"_ruleObj.%Get("linkAge")
	s Str=Str_"^体重:"_ruleObj.%Get("linkWeight")_"^性别:"_ruleObj.%Get("linkSex")_"^职业:"_ruleObj.%Get("lilnkProfess")
	s Str=Str_"^给药途径:"_ruleObj.%Get("linkPreMet")_"^溶媒:"_ruleObj.%Get("linkSolvent")_"^溶媒浓度:"_ruleObj.%Get("linkSolDens")
	s Str=Str_"^溶媒体积:"_ruleObj.%Get("linkSolVolume")_"^溶液:"_ruleObj.%Get("linkSolution")_"^溶液浓度:"_ruleObj.%Get("linkSolutionDens")
	s Str=Str_"^溶液体积:"_ruleObj.%Get("linkSolutionVolume")_"^给药速度:"_ruleObj.%Get("linkSpeed")_"^给药时间:"_ruleObj.%Get("linkDrugUseTime")
	s Str=Str_"^剂量,频次,疗程内用药时长:"_ruleObj.%Get("linkDose")_"^是否首次:"_ruleObj.%Get("isFirst")_"^最大量:"_ruleObj.%Get("linkDoseMax")
	s Str=Str_"^极量:"_ruleObj.%Get("linkDoseLimit")_"^疗程:"_ruleObj.%Get("linkTreat")_"^疗程间间隔:"_ruleObj.%Get("linkSpaceTreat")
	s Str=Str_"^连续用药:"_ruleObj.%Get("carryUseDrug")_"^合用类别:"_ruleObj.%Get("togetherType")_"^人群:"_ruleObj.%Get("linkPeople")
	s Str=Str_"^病症:"_ruleObj.%Get("linkDisease")_"^除外病症:"_ruleObj.%Get("outLinkDis")_"^病原体:"_ruleObj.%Get("linkVirus")
	s Str=Str_"^病原体组:"_ruleObj.%Get("linkVirusCat")_"^症状:"_ruleObj.%Get("linkSym")_"^除外症状:"_ruleObj.%Get("outLinkSym")
	s Str=Str_"^警戒类型（慎用）:"_outPutObj.%Get("alertCat")_"^提示信息:"_outPutObj.%Get("linkErrMsg")_"^提示级别:"_outPutObj.%Get("levelMsg")
	s Str=Str_"^提示依据:"_outPutObj.%Get("msgSource")_"^药品:"_labGenObj.%Get("generID")_"^目录："_labGenObj.%Get("labelID")
	s Str=Str_"^检验指标:"_ruleObj.%Get("linkLabItm")_"^检验指标值:"_ruleObj.%Get("linkLabValue")_"^提醒标记:"_outPutObj.%Get("OutMsgTips")
	s Str=Str_"^过敏:"_outPutObj.%Get("alertCat")_"^通用名:"_outPutObj.%Get("linkGeneNoDos")      
	
	Q:Err'=0 Err					
	TS            //开启事务
	s Jsonstr=##class(web.DHCCKBRuleImport).ImportNew(baseObj,ruleObj,outPutObj,1,0,1,labGenObj,"",LoginInfo,emRuleObj)
	s JsonObj=##class(%DynamicAbstractObject).%FromJSON(Jsonstr)
	i JsonObj.code="err" TRO			///提交不成功 ，回滚
	Q:JsonObj.code="err" Jsonstr		///返回错误数据	
	i JsonObj.code="success" d			///更新提价标识	
	.s Err=..UpdSubFlag(GroupNo,1,JsonObj)	
	i Err'=0 TRO	
	Q:Err'=0 Err
	TC
	q Jsonstr
}

/// Descript:更新提交标识
/// return:0:成功，其他：失败
/// w ##class(web.DHCCKBDataInput).UpdSubFlag()
ClassMethod UpdSubFlag(GroupNo, Flag, JsonObj = "", rule = "")
{
	n (GroupNo,Flag,JsonObj,rule)
	s Err=0
	TS                      //开启事务
	///删除之前的规则
	s RuleId=""
	i JsonObj'=""  d
	.s RuleId=JsonObj.rule			//规则ID
	.s RuleMainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,""))   
	.s DicRuleId=$p(^DHCCKBRULEMAINTAIN(RuleMainId),"^",6)            //RM_Rule_Dr
	.i (DicRuleId'="")&&($d(^CT.CKB.PDSS.RuleD(DicRuleId)))  d               
	..s Err=##class(web.DHCCKBRuleSave).RemoveRule(DicRuleId)
	i Err'=0 tro            //回滚事务
	Q:Err'=0 Err
	
	i rule'=""  d           
	.s Err=##class(web.DHCCKBRuleSave).RemoveRule(rule)    //删除之前的规则
	i Err'=0 tro
	Q:Err'=0 Err
	
#;	///更新新的规则
#;	s MainId=""
#;	for  s MainId=$o(^DHCCKBRULEMAINTAIN(0,"GroupNo",GroupNo,MainId)) Q:(MainId="")||(Err'=0)  d
#;	.s Err=..UpdRuleMain(MainId,Flag,RuleId)     //更新之前的规则
#;	.Q:Err'=0
#;	i Err'=0 tro
#;	Q:Err'=0 Er
	//添加新的规则
	s Err= ..InsRuleMain(flag, ruleid)
	i Err'=0 tro
	Q:Err'=0 Er
	
	
	
	TC
	Q Err
}

/// Descript:添加规则维护表
/// return:0:成功，其他：失败  
/// w ##class(web.DHCCKBRuleMaintain).InsRuleMain()
ClassMethod InsRuleMain(flag, ruleid)
{
	n (flag,ruleid)
	//&sql(INSERT INTO DHC_CKBRuleMaintain VALUES (:flag,:ruleid))
	Q SQLCODE
}

/// Descript:更新规则维护表提交标识和规则id
/// Input:维护表ID，提交标识，规则提交返回对象
/// return:0:成功，其他：失败  
/// w ##class(web.DHCCKBRuleMaintain).UpdRuleMain(52471,1,1)
ClassMethod UpdRuleMain(MainId, Flag, RuleId = "")
{
	n (MainId, Flag, RuleId)
	&sql(update DHC_CKBRuleMaintain set RM_Flag=:Flag,RM_Rule_Dr=:RuleId where RM_RowId=:MainId)
	Q SQLCODE
}

/// Descript:取药品id
/// w ##class(web.DHCCKBDataInput).getGenerID(81224,"")
ClassMethod getGenerID(AttrId, DrugDesc)
{
	n (AttrId,DrugDesc)
	s SourceId=##class(web.DHCCKBCommon).GetDataSource()
	s DlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,SourceId,""))
	s SouDicId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DlaRowId)),4)
	s Ret=""
	s Id="" 
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(DrugDesc),Id)) Q:Id=""  d
	.s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),4)
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.Q:Parref'=SouDicId
	.s Ret=Id
	Q Ret
}

/// w ##class(web.DHCCKBDataInput).GetLevByDesc("对用药过程的指导")
ClassMethod GetLevByDesc(LevDesc)
{
	n (LevDesc)
	s LevId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(LevDesc),""))
	Q:LevId="" ""
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LevId)),2)
	s Value=##class(web.DHCCKBCommon).GetManLevelNum(Code)
	Q Value
}

/// 获取未包含的药品
/// d ##class(web.DHCCKBDataInput).QueryPreDrug()
ClassMethod QueryPreDrug()
{
	 k ^tmp("0","ItmDesc")
	 s countnum=0
	 s ItemCat=""
	 f  s ItemCat=$o(^ARC("IC",ItemCat))   Q:ItemCat=""  D  
	 .s ItemCatDr=$g(^ARC("IC",ItemCat))
	 .s OrderCat=$p(ItemCatDr,"^",8)
	 .q:OrderCat="4"	    //去掉检查类医嘱
     .q:OrderCat="5"        //去掉处置治疗类医嘱
     .q:OrderCat="6"        //去掉检验类医嘱
     .q:OrderCat="7"        //去掉嘱托类医嘱
     .q:OrderCat="8"        //去掉手术麻醉类医嘱
     .q:OrderCat="9"        //去掉护理类医嘱
     .q:OrderCat="10"       //去掉其他类医嘱
     .q:OrderCat="11"       //去掉材料类医嘱
     .q:OrderCat="12"       //去掉医嘱套类医嘱
	 .s Subscript=""
	 .f  s Subscript=$o(^ARCIM(0,"ARCIC_DR",ItemCat,Subscript))   Q:Subscript=""  D
	 ..s Version=""
	 ..f  s Version=$o(^ARCIM(0,"ARCIC_DR",ItemCat,Subscript,Version))   Q:Version=""  D
	 ...s ItmMast=$g(^ARCIM(Subscript,Version,1))
	 ...s ItmDesc=$p(ItmMast,"^",2)
	 ...s EDCode=""
	 ...f  s EDCode=$o(^CKB.PDSS.ExtDictionI("Desc","95",EDCode)) Q:EDCode=""  D
	 ....q:ItmDesc[EDCode
	 ...s checknum=$d(^tmp("0","ItmDesc",ItmDesc))
	 ...if checknum=0 d
	 ....s countnum=countnum+1
	 ....s ^tmp("0","ItmDesc",countnum,ItmDesc)=ItmDesc
	 q ""
}

/// 获取未包含的药品(医院未知时使用这个)
/// d ##class(web.DHCCKBDataInput).QueryPreDrugs()
ClassMethod QueryPreDrugs()
{
	 k ^tmp("0","ItmDesc")
	 s countnum=0
	 s ItemCat=""
	 f  s ItemCat=$o(^ARC("IC",ItemCat))   Q:ItemCat=""  D  
	 .s ItemCatDr=$g(^ARC("IC",ItemCat))
	 .s OrderCat=$p(ItemCatDr,"^",8)
	 .q:OrderCat="4"	    //去掉检查类医嘱
     .q:OrderCat="5"        //去掉处置治疗类医嘱
     .q:OrderCat="6"        //去掉检验类医嘱
     .q:OrderCat="7"        //去掉嘱托类医嘱
     .q:OrderCat="8"        //去掉手术麻醉类医嘱
     .q:OrderCat="9"        //去掉护理类医嘱
     .q:OrderCat="10"       //去掉其他类医嘱
     .q:OrderCat="11"       //去掉材料类医嘱
     .q:OrderCat="12"       //去掉医嘱套类医嘱
	 .s Subscript=""
	 .f  s Subscript=$o(^ARCIM(0,"ARCIC_DR",ItemCat,Subscript))   Q:Subscript=""  D
	 ..s Version=""
	 ..f  s Version=$o(^ARCIM(0,"ARCIC_DR",ItemCat,Subscript,Version))   Q:Version=""  D
	 ...s ItmMast=$g(^ARCIM(Subscript,Version,1))
	 ...s ItmDesc=$p(ItmMast,"^",2)
	 ...s Hospid=""
	 ...f  s Hospid=$o(^CKB.PDSS.ExtDictionI("Code",Hospid))   Q:Hospid=""  D
	 ....s EDCode=""
	 ....f  s EDCode=$o(^CKB.PDSS.ExtDictionI("Desc",Hospid,EDCode)) Q:EDCode=""  D
	 .....q:ItmDesc[EDCode
	 ...s checknum=$d(^tmp("0","ItmDesc",ItmDesc))
	 ...if checknum=0 d
	 ....s countnum=countnum+1
	 ....s ^tmp("0","ItmDesc",countnum,ItmDesc)=ItmDesc
	 q ""
}

}
