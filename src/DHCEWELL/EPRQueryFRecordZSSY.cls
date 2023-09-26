Class DHCEWELL.EPRQueryFRecordZSSY Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		住院病案首页第一部分
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("DHCEWELL.EPRQueryTemDatasSDYT","DIHAIAPRNOTINFOMR",58)
Query DIHAIAPRNOTINFOMR(DateFrom As %String, DateTo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CT04_50_001_01:%String,WS04_50_001_01:%String,CT04_50_010_01:%String,WS04_50_010_01:%String,WS02_01_039_086:%String,WS01_00_004_01:%String,WS02_01_013_01:%String,WS02_01_005_01_01:%String,WS01_00_019_03:%String,WS08_10_025_13:%String,CT08_10_025_13:%String,WS06_00_016_02:%String,WS02_01_010_17:%String,WS02_01_901_08:%String,WS02_01_010_14:%String,WS02_01_047_05:%String,CT02_01_015_01:%String,WS02_01_015_01:%String,WS05_01_022_02:%String,WS06_00_901_02:%String,WS02_01_901_05:%String,WS02_01_009_05_05:%String,WS02_01_009_06_05:%String,WS02_01_009_01_05:%String,WS02_01_009_02_05:%String,WS02_01_009_03_05:%String,WS02_01_009_04_05:%String,WS02_01_047_04:%String,WS02_01_018_01:%String,CT02_01_018_01:%String,WS02_01_901_01:%String,WS01_00_021_01:%String,WS02_01_039_047:%String,WS02_01_039_034:%String,WS06_00_223_01:%String,CT06_00_223_01:%String,WS02_01_901_13:%String,WS02_01_010_02:%String,WS02_01_039_011:%String,WS05_10_138_01_02:%String,WS05_10_138_01_01:%String,WS02_01_025_01:%String,CT02_01_025_01:%String,WS08_10_052_06:%String,CT08_10_052_06:%String,WS05_01_034_01:%String,WS01_00_019_02:%String,WS08_10_025_07:%String,CT08_10_025_07:%String,WS06_00_092_01:%String,WS06_00_339_01:%String,CT06_00_339_01:%String,WS02_01_906_01:%String,WS02_01_039_059:%String,WS06_00_194_01:%String,WS05_01_902_01:%String,WS09_00_108_01:%String,WS05_10_006_02:%String,WS05_01_024_22:%String,WS02_01_901_06:%String,WS02_01_009_05_06:%String,WS02_01_009_11:%String,WS02_01_009_06_06:%String,WS02_01_009_01_06:%String,WS02_01_009_02_06:%String,WS02_01_009_03_06:%String,WS02_01_009_04_06:%String,WS02_01_047_03:%String,WS04_10_019_02:%String,WS04_10_019_03:%String,CT02_01_040_01:%String,WS02_01_040_01:%String,WS02_01_039_001:%String,WS02_10_023_02:%String,CT07_00_006_01:%String,WS07_00_006_01:%String,WS08_10_052_01:%String,WS02_10_024_02:%String,WS06_00_195_01:%String,WS02_01_039_067:%String,WS02_01_052_01:%String,CT02_01_052_01:%String,WS02_01_039_052:%String,WS09_00_120_01:%String,WS02_01_039_053:%String,WS06_00_304_01:%String,CT06_00_304_01:%String,WS02_01_039_033:%String,WS02_01_039_030:%String,WS09_00_103_01:%String,CT09_00_103_01:%String,WS01_00_014_01:%String,WS05_01_903_01:%String,WS02_10_090_01:%String,WS06_00_310_01:%String,WS02_01_039_029:%String,WS08_10_025_06:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
}

ClassMethod DIHAIAPRNOTINFOMRExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(AEpisodeID) = "") $$$OK
	
	s AGlossaryCategoryID = "HDSD00.12"
	
	s StartDate	= $g(DateFrom)
	s EndDate	= $g(DateTo)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for {
		s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
		q:(AEpisodeID = "")
		
		s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
		s (CT045000101,WS045000101,CT045001001,WS045001001,WS0201039086,WS010000401,WS020101301,WS02010050101,WS010001903,WS081002513,CT081002513,WS060001602,WS020101017,WS020190108,WS020101014,WS020104705,CT020101501,WS020101501,WS050102202,WS060090102,WS020190105,WS02010090505,WS02010090605,WS02010090105,WS02010090205,WS02010090305,WS02010090405,WS020104704,WS020101801,CT020101801,WS020190101,WS010002101,WS0201039047,WS0201039034,WS060022301,CT060022301,WS020190113,WS020101002,WS0201039011,WS05101380102,WS05101380101,WS020102501,CT020102501,WS081005206,CT081005206,WS050103401,WS010001902,WS081002507,CT081002507,WS060009201,WS060033901,CT060033901,WS020190601,WS0201039059,WS060019401,WS050190201,WS090010801,WS051000602,WS050102422,WS020190106)=""
		s (WS02010090506,WS020100911,WS02010090606,WS02010090106,WS02010090206,WS02010090306,WS02010090406,WS020104703,WS041001902,WS041001903,CT020104001,WS020104001,WS0201039001,WS021002302,CT070000601,WS070000601,WS081005201,WS021002402,WS060019501,WS0201039067,WS020105201,CT020105201,WS0201039052,WS090012001,WS0201039053,WS060030401,CT060030401,WS0201039033,WS0201039030,WS090010301,CT090010301,WS010001401,WS050190301,WS021009001,WS060031001,WS0201039029,WS081002506)=""
	
		s CT045000101= StandDataArry.GetAt("HDSD00.11.597") //ABO血型
		s WS045000101= StandDataArry.GetAt("HDSD00.11.003") //ABO血型代码
		s CT045001001= StandDataArry.GetAt("HDSD00.11.598") //RH血型
		s WS045001001= StandDataArry.GetAt("HDSD00.11.004") //Rh血型代码
		s WS0201039086= StandDataArry.GetAt("HDSD00.11.005") //编码员姓名
		s WS010000401= StandDataArry.GetAt("HDSD00.11.006") //病案号
		s WS020101301= StandDataArry.GetAt("HDSD00.11.011") //出生地
		s WS02010050101= StandDataArry.GetAt("HDSD00.11.014") //出生日期
		s WS010001903= StandDataArry.GetAt("HDSD00.11.017") //出院病房
		s WS081002513= StandDataArry.GetAt("HDSD00.11.018") //出院科别代码
		s CT081002513= StandDataArry.GetAt("HDSD00.11.1005") //出院科别名称
		s WS060001602= StandDataArry.GetAt("HDSD00.11.019") //出院日期
		s WS020101017= StandDataArry.GetAt("HDSD00.11.026") //个人联系电话号码
		s WS020190108= StandDataArry.GetAt("HDSD00.11.029") //工作单位及地址
		s WS020101014= StandDataArry.GetAt("HDSD00.11.034") //工作单位联系电话
		s WS020104705= StandDataArry.GetAt("HDSD00.11.033") //工作单位-邮政编码
		s CT020101501= StandDataArry.GetAt("HDSD00.11.563") //国籍
		s WS020101501= StandDataArry.GetAt("HDSD00.11.036") //国籍代码
		s WS050102202= StandDataArry.GetAt("HDSD00.11.037") //过敏药物名称
		s WS060090102= StandDataArry.GetAt("HDSD00.11.555") //呼吸机使用时间
		s WS020190105= StandDataArry.GetAt("HDSD00.11.041") //户口地址
		s WS02010090505= StandDataArry.GetAt("HDSD00.11.041") //户口地址-村（街、路、弄等）
		s WS02010090605= StandDataArry.GetAt("HDSD00.11.042") //户口地址-门牌号码
		s WS02010090105= StandDataArry.GetAt("HDSD00.11.043") //户口地址-省（自治区、直辖市）
		s WS02010090205= StandDataArry.GetAt("HDSD00.11.044") //户口地址-市（地区）
		s WS02010090305= StandDataArry.GetAt("HDSD00.11.045") //户口地址-县（区）
		s WS02010090405= StandDataArry.GetAt("HDSD00.11.046") //户口地址-乡（镇、街道办事处）
		s WS020104704= StandDataArry.GetAt("HDSD00.11.047") //户口地址-邮政编码
		s WS020101801= StandDataArry.GetAt("HDSD00.11.050") //婚姻状况类别代码
		s CT020101801= StandDataArry.GetAt("HDSD00.11.587") //婚姻状况类别名称
		s WS020190101= StandDataArry.GetAt("HDSD00.11.051") //籍贯
		s WS010002101= StandDataArry.GetAt("HDSD00.11.053") //健康卡号
		s WS0201039047= StandDataArry.GetAt("HDSD00.11.054") //进修医师姓名
		s WS0201039034= StandDataArry.GetAt("HDSD00.11.056") //科主任姓名
		s WS060022301= StandDataArry.GetAt("HDSD00.11.603") //离院方式代码
		s CT060022301= StandDataArry.GetAt("HDSD00.11.057") //离院方式名称
		s WS020190113= StandDataArry.GetAt("HDSD00.11.060") //联系人地址
		s WS020101002= StandDataArry.GetAt("HDSD00.11.064") //联系人电话-号码
		s WS0201039011= StandDataArry.GetAt("HDSD00.11.065") //联系人姓名
		s WS05101380102= StandDataArry.GetAt("HDSD00.11.067") //颅脑损伤患者入院后昏迷时间
		s WS05101380101= StandDataArry.GetAt("HDSD00.11.070") //颅脑损伤患者入院前昏迷时间
		s WS020102501= StandDataArry.GetAt("HDSD00.11.077") //民族代码
		s CT020102501= StandDataArry.GetAt("HDSD00.11.590") //民族名称
		s WS081005206= StandDataArry.GetAt("HDSD00.11.545") //拟接收医疗机构代码
		s CT081005206= StandDataArry.GetAt("HDSD00.11.078") //拟接收医疗机构名称
		s WS050103401= StandDataArry.GetAt("HDSD00.11.876") //确诊日期
		s WS010001902= StandDataArry.GetAt("HDSD00.11.083") //入院病房
		s WS081002507= StandDataArry.GetAt("HDSD00.11.1004") //入院科别代码
		s CT081002507= StandDataArry.GetAt("HDSD00.11.084") //入院科别名名称
		s WS060009201= StandDataArry.GetAt("HDSD00.11.085") //入院日期
		s WS060033901= StandDataArry.GetAt("HDSD00.11.086") //入院途径代码
		s CT060033901= StandDataArry.GetAt("HDSD00.11.591") //入院途径名称
		s WS020190601= StandDataArry.GetAt("HDSD00.11.048") //身份证号
		s WS0201039059= StandDataArry.GetAt("HDSD00.11.088") //实习医师姓名
		s WS060019401= StandDataArry.GetAt("HDSD00.11.604") //是否有出院31天内再住院计划
		s WS050190201= StandDataArry.GetAt("HDSD00.11.596") //死亡标识
		s WS090010801= StandDataArry.GetAt("HDSD00.11.095") //死亡患者尸检标志
		s WS051000602= StandDataArry.GetAt("HDSD00.11.096") //损伤、中毒的外部原因
		s WS050102422= StandDataArry.GetAt("HDSD00.11.097") //损伤、中毒的外部原因疾病编码
		s WS020190106= StandDataArry.GetAt("HDSD00.11.100") //现住址
		s WS02010090506= StandDataArry.GetAt("HDSD00.11.100") //现住址-村（街、路、弄等）
		s WS020100911= "" //现住址-行政区划代码
		s WS02010090606= StandDataArry.GetAt("HDSD00.11.101") //现住址-门牌号码
		s WS02010090106= StandDataArry.GetAt("HDSD00.11.102") //现住址-省（自治区、直辖市）
		s WS02010090206= StandDataArry.GetAt("HDSD00.11.103") //现住址-市（地区）
		s WS02010090306= StandDataArry.GetAt("HDSD00.11.104") //现住址-县（区）
		s WS02010090406= StandDataArry.GetAt("HDSD00.11.105") //现住址-乡（镇、街道办事处）
		s WS020104703= StandDataArry.GetAt("HDSD00.11.106") //现住址-邮政编码
		s WS041001902= StandDataArry.GetAt("HDSD00.11.107") //新生儿出生体重（g）
		s WS041001903= StandDataArry.GetAt("HDSD00.11.108") //新生儿入院体重（g）
		s CT020104001= StandDataArry.GetAt("HDSD00.11.586") //性别
		s WS020104001= StandDataArry.GetAt("HDSD00.11.109") //性别代码
		s WS0201039001= StandDataArry.GetAt("HDSD00.11.110") //姓名
		s WS021002302= StandDataArry.GetAt("HDSD00.11.116") //药物过敏标志
		s CT070000601= StandDataArry.GetAt("HDSD00.11.585") //医疗费用支付方式
		s WS070000601= StandDataArry.GetAt("HDSD00.11.117") //医疗费用支付方式代码
		s WS081005201= StandDataArry.GetAt("HDSD00.11.119") //医疗机构组织机构代码
		s WS021002402= StandDataArry.GetAt("HDSD00.11.066") //与联系人关系代码
		s WS060019501= StandDataArry.GetAt("HDSD00.11.016") //再住院计划目的
		s WS0201039067= StandDataArry.GetAt("HDSD00.11.126") //责任护士姓名
		s WS020105201= StandDataArry.GetAt("HDSD00.11.125") //职业类别代码
		s CT020105201= StandDataArry.GetAt("HDSD00.11.564") //职业名称
		s WS0201039052= StandDataArry.GetAt("HDSD00.11.973") //质控护士姓名
		s WS090012001= StandDataArry.GetAt("HDSD00.11.127") //质控日期
		s WS0201039053= StandDataArry.GetAt("HDSD00.11.128") //质控医师姓名
		s WS060030401= "" //治疗类别代码
		s CT060030401= "" //治疗类别名称
		s WS0201039033= StandDataArry.GetAt("HDSD00.11.137") //主任(副主任)医师姓名
		s WS0201039030= StandDataArry.GetAt("HDSD00.11.138") //主治医生姓名
		s WS090010301= StandDataArry.GetAt("HDSD00.11.007") //住院病例病案质量代码
		s CT090010301= StandDataArry.GetAt("HDSD00.11.899") //住院病例病案质量名称
		s WS010001401= StandDataArry.GetAt("HDSD00.11.140") //住院号
		s WS050190301= StandDataArry.GetAt("HDSD00.11.023") //住院患者疾病诊断对照代码
		s WS021009001= StandDataArry.GetAt("HDSD00.11.139") //住院患者住院次数
		s WS060031001= StandDataArry.GetAt("HDSD00.11.087") //住院患者住院天数
		s WS0201039029= StandDataArry.GetAt("HDSD00.11.141") //住院医师姓名
		s WS081002506= StandDataArry.GetAt("HDSD00.11.144") //转科科别名称


    
		s Data = $lb(CT045000101,WS045000101,CT045001001,WS045001001,WS0201039086,WS010000401,WS020101301,WS02010050101,WS010001903,WS081002513,
				CT081002513,WS060001602,WS020101017,WS020190108,WS020101014,WS020104705,CT020101501,WS020101501,WS050102202,WS060090102,
				WS020190105,WS02010090505,WS02010090605,WS02010090105,WS02010090205,WS02010090305,WS02010090405,WS020104704,WS020101801,CT020101801,
				WS020190101,WS010002101,WS0201039047,WS0201039034,WS060022301,CT060022301,WS020190113,WS020101002,WS0201039011,WS05101380102,
				WS05101380101,WS020102501,CT020102501,WS081005206,CT081005206,WS050103401,WS010001902,WS081002507,CT081002507,WS060009201,
				WS060033901,CT060033901,WS020190601,WS0201039059,WS060019401,WS050190201,WS090010801,WS051000602,WS050102422,WS020190106,
				WS02010090506,WS020100911,WS02010090606,WS02010090106,WS02010090206,WS02010090306,WS02010090406,WS020104703,WS041001902,WS041001903,
				CT020104001,WS020104001,WS0201039001,WS021002302,CT070000601,WS070000601,WS081005201,WS021002402,WS060019501,WS0201039067,
				WS020105201,CT020105201,WS0201039052,WS090012001,WS0201039053,WS060030401,CT060030401,WS0201039033,WS0201039030,WS090010301,
				CT090010301,WS010001401,WS050190301,WS021009001,WS060031001,WS0201039029,WS081002506)
	
	s ^CacheTemp(repid,ind) = Data
	s ind = ind + 1
	}
	}
	q $$$OK
}

ClassMethod DIHAIAPRNOTINFOMRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DIHAIAPRNOTINFOMRExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod DIHAIAPRNOTINFOMRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DIHAIAPRNOTINFOMRExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory("1","1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, instanceDataID As %String = "") As %ArrayOfDataTypes
{
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()

	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
	
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
	
		s internalID = objGlossary.InternalID
		;s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
		//通过注册号，术语rowId获取业务数据
		s strDataValue = ..GetScatterDataByGlossaryID(AEpisodeID,glossaryID,instanceDataID)
		if (strDataValue ="")
		{
			s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		}
		/*S objStandData =  ##Class(EPRservice.entity.EStandDataInfo).%New()
		S objStandData.strInternalID = internalID
		s strValue=$tr(value,"<","(")
		s strValue=$tr(strValue,">",")")
		S objStandData.displayName = strValue
		*/

		d retArray.SetAt(strDataValue, internalID)
	
	}
	q retArray
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BLL.BLDataETranFactory).GetScatterDataByGlossaryID("58","1811","810||2")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, instanceDataID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s ret = ""
			if (instanceDataID = ""){
			s ret = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}else{
			s ret = ##Class(EPRservice.BOScatterData).GetMultipleScatterData(AEpisodeID,templateID,itemCode,instanceDataID,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
			
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//s parItemValue = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			//if (parItemValue = "")
			//{
			//	q
			//}
			s kbRowID = ""
			for {
				s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
				q:(kbRowID = "")
			
				s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
				s curItemCode = objParItem.ItemCode
				s curValueType = objParItem.ValueType
				s kbPartNo = objParItem.KBPartNo
				S KBNodeID = objParItem.KBNodeID
			
				s curTextSimpleRowID= ""
				for
				{
					s curTextSimpleRowID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode," "_KBNodeID," "_kbPartNo," "_curItemCode,curTextSimpleRowID))
					q:(curTextSimpleRowID = "")
					s curItemType = $e($tr(curItemCode," ",""),0,1)
					s curTextSimpleValue = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
					if (curTextSimpleValue '= "")
					{
						s ret = curTextSimpleValue
						q	
					}	
				}	
			}	
		}
	}
	s:(ret="Null") ret = ""
	q ret
}

}
