Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-01-04
/// Descript: 	病理申请
Class web.DHCAppPisMasterQuery Extends DHCDoc.Util.RegisteredObject [ ClassType = "" ]
{

/// Descript:取病理申请标本内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonQryPisSpec("")
ClassMethod JsonQryPisSpec(PisID As %String, Arcimid As %String = "", HospID As %String = "") As %String
{
	k TMPPisSpecArr
	s CH="",Num=0
	i PisID'="" D
	.F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	..s No=$p(^DHCAPPPM(PisID,"S",CH),"^",1)      /// 标本序号
	..s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	..s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)    /// 标本名称
	..s Explain=$p(^DHCAPPPM(PisID,"S",CH),"^",4) /// 标本说明
	..s Part=$p(^DHCAPPPM(PisID,"S",CH),"^",5)    /// 标本部位
	..s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	..s Remark=$p(^DHCAPPPM(PisID,"S",CH),"^",7)  /// 标本备注
	..s SliType=$p(^DHCAPPPM(PisID,"S",CH),"^",8) /// 玻片/蜡片
	..s PisNo=$p(^DHCAPPPM(PisID,"S",CH),"^",9)   /// 原病理号
	..s SepDate=""
	..s FixDate=""
	..s ListData=No_"^"_ID_"^"_Name_"^"_Explain_"^"_Part_"^"_Qty_"^"_Remark_"^"_SliType_"^"_PisNo_"^"_SepDate_"^"_FixDate
	
	..s Num=Num+1
	..s TMPPisSpecArr(PisID_"S"_CH)=ListData
	if (Arcimid'="")&&(PisID=""){
		s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
		s ID=0
		f  s ID=$o(^DHCAPPTS(ID)) Q:ID=""  D
		.
		.s Code=$p(^DHCAPPTS(ID),"^",1)    /// 代码
		.s Desc=$p(^DHCAPPTS(ID),"^",2)    /// 描述
		.//s Desc=##class(User.DHCAppTestSpec).GetTranByDesc("ATSDesc",Desc,langid)
		.Q:HospID'=$p(^DHCAPPTS(ID),"^",4)
		.s MulFlag=$p(^DHCAPPTS(ID),"^",6) /// 是否支持多选
		.Q:$p(^DHCAPPTS(ID),"^",5)'="Y"
		.q:##class(web.DHCAPPTestSpec).CheckForArcitem(Arcimid,ID)'=1
		.s No=Num+1       /// 标本序号
		.      /// 标本标识
		.s Name=Desc     /// 标本名称
		.s Explain=""  /// 标本说明
		.s Part=""     /// 标本部位
		.s Qty=""      /// 标本数量
		.s Remark=""   /// 标本备注
		.s SliType=""  /// 玻片/蜡片
		.s PisNo=""   /// 原病理号
		.s SepDate="" ///标本离体时间
		.s FixDate="" ///标本固定时间
		.s ListData=No_"^"_""_"^"_Name_"^"_Explain_"^"_Part_"^"_Qty_"^"_Remark_"^"_SliType_"^"_PisNo_"^"_SepDate_"^"_FixDate
		.s Num=Num+1
		.s TMPPisSpecArr("S"_Num)=ListData
	}
	i 4>Num d
	.s Len=4-Num
	.f i=1:1:Len d
	..s Num=Num+1
	..s TMPPisSpecArr("Z"_i)=Num

	s ListTitle="No^ID^Name^Explain^Part^Qty^Remark^SliType^PisNo^SepDate^FixDate"
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TMPPisSpecArr(index)) Q:index=""  D
	.s ListData=$g(TMPPisSpecArr(index))
	.//Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.E  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))

	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	q Stream.Read()
}

/// Descritp:	取材类型字典
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPisCutBasList()
ClassMethod JsonGetPisCutBasList(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"取材类型"))
	d Stream.Write(",""items"":")
	;D ..JsonGetPisCutBas(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("取材类型",HospID,"CutBas"))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 取材类型字典
ClassMethod JsonGetPisCutBas(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPCB(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPCB(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPCB(ID),"^",2)    /// 描述
	.Q:$p(^DHCAPPCB(ID),"^",3)'=HospID
	.Q:$p(^DHCAPPCB(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^CutBas"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	标本字典
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPisSpec()
ClassMethod JsonGetPisSpecList(HospID As %String, Arcim As %String = "") As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"标本字典"))
	d Stream.Write(",""items"":")
	d Stream.Write(..JsonGetPisSpec(HospID,Arcim))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 标本字典
ClassMethod JsonGetPisSpec(HospID As %String, Arcim As %String = "") As %String
{

	s count = 0
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPTS(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPTS(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPTS(ID),"^",2)    /// 描述
	.s Desc=##class(User.DHCAppTestSpec).GetTranByDesc("ATSDesc",Desc,langid)
	.Q:HospID'=$p(^DHCAPPTS(ID),"^",4)
	.s MulFlag=$p(^DHCAPPTS(ID),"^",6) /// 是否支持多选
	.Q:$p(^DHCAPPTS(ID),"^",5)'="Y"
	.s Check=1
	.if Arcim'="" d
	..s Check=##class(web.DHCAPPTestSpec).CheckForArcitem(Arcim,ID)
	.q:Check'=1
	.s Insertflag=$p(^DHCAPPTS(ID),"^",7) 
	.s ListData=ID_"^"_Desc_"^PisSpec"_MulFlag_"^"_Insertflag
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name^InsertCell",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name^InsertCell",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	HPV病人病历内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonItemList()
ClassMethod JsonItemList(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"检测方法"))
	d Stream.Write(",""items"":")
	;D ..JsonGetTesItmMet(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("检测方法",HospID,"TesItmMet"))
	d Stream.Write("}")
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(2,"临床诊断"))
	d Stream.Write(",""items"":")
	;D ..JsonGetTesDiag(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("临床诊断",HospID,"TesDiag"))
	d Stream.Write("}")
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(3,"治疗方式"))
	d Stream.Write(",""items"":")
	;D ..JsonGetTreMet(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("治疗方法",HospID,"TreMet"))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	检测方法
ClassMethod JsonTesItmMet(HospID As %String)
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"检测方法"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("检测方法",HospID,"TesItmMet"))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	治疗方式
ClassMethod JsonTreMet(HospID As %String)
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"治疗方式"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("治疗方式",HospID,"TreMet"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp: 病理基础字典数据
/// w ##class(web.DHCAppPisMasterQuery).JsonBaseItemList("JsonBaseItemList","setplist",1,2)
ClassMethod JsonBaseItemList(Title, Name, Type As %String = "", HospID As %String)
{
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s TitleText=##class(User.DHCAppPisDicType).GetTranByDesc("APDesc",Title,langid)
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,TitleText))
	d Stream.Write(",""items"":")
	b ;093323
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew(Title,HospID,Name,Type))
	b ;09334
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	妇科TCT病人病历内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonPatRecList()
ClassMethod JsonPatRecList(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"病人病历"))
	d Stream.Write(",""items"":")
	;D ..JsonGetPatRec(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("病人病历",HospID,"PatRec"))
	d Stream.Write("}")
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(2,"临床诊断"))
	d Stream.Write(",""items"":")
	;D ..JsonGetTesDiag(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("临床诊断",HospID,"TesDiag"))
	d Stream.Write("}")
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(3,"标本采集部位"))
	d Stream.Write(",""items"":")
	;D ..JsonGetTesDiag(HospID)
	d Stream.Write(..JsonGetPisDicTypeNew("标本采集部位",HospID,"CureSelect"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	病人病历
ClassMethod JsonPatRec(HospID As %String)
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"病人病历"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("病人病历",HospID,"PatRec"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	临床诊断
ClassMethod JsonTesDiag(HospID As %String)
{
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"临床诊断"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("临床诊断",HospID,"TesDiag"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	标本采集部位
ClassMethod JsonCureSelect(HospID As %String)
{
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Text=##class(User.DHCAppPisDicType).GetTranByDesc("APDesc","标本采集部位",langid)
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,Text))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("标本采集部位",HospID,"CureSelect"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	传染病史内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonPatInfDisList()
ClassMethod JsonPatInfDisList(HospID As %String) As %String
{
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"传染病史"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("传染病史",HospID,"TestItem"))
	d Stream.Write("}")
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(2,"固定方式"))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("固定方式",HospID,"FixItem"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	传染病史
ClassMethod JsonInfectDis(HospID As %String)
{
	
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Text=##class(User.DHCAppPisDicType).GetTranByDesc("APDesc","传染病史",langid)
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,Text))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("传染病史",HospID,"InfectDis"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	固定方式
ClassMethod JsonFixDis(HospID As %String)
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Text=##class(User.DHCAppPisDicType).GetTranByDesc("APDesc","固定方式",langid)
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,Text))
	d Stream.Write(",""items"":")
	d Stream.Write(##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("固定方式",HospID,"FixItem"))
	d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	固定方式
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPatFixMode()
ClassMethod JsonGetPatFixMode(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count=0
	s fix=""
	f  s fix=$o(^DHCAPPFIX(fix)) q:fix=""  d
	.q:+fix=0
	.s fixway=$p(^DHCAPPFIX(fix),"^",2)
	.Q:HospID'=$p(^DHCAPPFIX(fix),"^",3) /// 医院ID
	.Q:$p(^DHCAPPFIX(fix),"^",4)'="Y"
	.i count'=0 d
	..d Stream.Write(",")
	.s count=count+1
	.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",fix_"^"_fixway_"^FixItem"))
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	传染病史内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPatInfDis()
ClassMethod JsonGetPatInfDis(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPID(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPID(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPID(ID),"^",2)    /// 描述
	.Q:HospID'=$p(^DHCAPPID(ID),"^",3) /// 医院ID
	.Q:$p(^DHCAPPID(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^TestItem"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	传染病史内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPisDicTypeNew("传染病史",2,"TestItem")
ClassMethod JsonGetPisDicTypeNew(Desc As %String, HospID As %String, Name As %String, Type As %String = "") As %String
{
	s count = 0
	Set langid=..%LanguageID()
	s StreamSub=##class(%Stream.GlobalCharacter).%New()
	d StreamSub.Write("[")
	s TypeRowid=$O(^DHCAPPPDT(0,"Desc",Desc,2,"")) //字典类型为公有数据,医院为2
	if (TypeRowid'=""){
		s APPPDIRowid=""
		for {
			s APPPDIRowid=$O(^DHCAPPPDI(0,"Type",TypeRowid,APPPDIRowid))
			q:APPPDIRowid=""
			s AppCode=$P(^DHCAPPPDI(APPPDIRowid),"^",1)
			s AppName=$P(^DHCAPPPDI(APPPDIRowid),"^",2)
			continue:($P(^DHCAPPPDI(APPPDIRowid),"^",4)'=HospID)
			if (Type'=""){
				s PisBLmap=$O(^DHCDocAppBLMapi("MapCode",Type,""))
				s ActMapCode=$p(^DHCAPPPDT(TypeRowid),"^",5) //可用标志
				s ActOne=##class(web.DHCAppPisDicRelationBLMap).CheckForOneItem(APPPDIRowid,PisBLmap)
				Continue:((ActMapCode="Y")&&(ActOne=0))
				}
			s AppName=##class(User.DHCAppPisDicItem).GetTranByDesc("APDesc",AppName,langid)
			s ListData=APPPDIRowid_"^"_AppName_"^"_Name
			s count = count+1
			I count=1 d
			.d StreamSub.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
			e  d
			.d StreamSub.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
		}
	}
	d StreamSub.Write("]")
	q StreamSub.Read()
}

/// Descritp:	分子病理检测项目内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonTestItemList()
ClassMethod JsonTestItemList(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"检测项目"))
	d Stream.Write(",""items"":")
	d Stream.Write(..JsonGetTestItem(HospID))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	分子病理检测项目新
/// w ##Class(web.DHCAppPisMasterQuery).JsonTestItemListNew("")
ClassMethod JsonTestItemListNew(HospID As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(1,"检测项目"))
	d Stream.Write(",""items"":")
	s Item=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("CellShowType")
	if Item="" s Item=14
	s ID="0"
	s MastCount=0
	F {
		s ID=$o(^DHCAPPPDI(0,"Type",Item,ID)) 
		Q:ID="" 
		s Code=$p(^DHCAPPPDI(ID),"^",1)    //代码
		s Desc=$p(^DHCAPPPDI(ID),"^",2)    //描述
		continue:$p(^DHCAPPPDI(ID),"^",4)'=HospID
		s MastCount=MastCount+1
		if MastCount=1 {d Stream.Write("[") }else{d Stream.Write("," )}
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Desc))
		d Stream.Write(",""items"":")
		s ItemRowID=""
		s count = 0
		d Stream.Write("[")
		 for {
		    s ItemRowID=$O(^DHCAPPCellItemLinki("Mast",ID,ItemRowID))
		    q:ItemRowID=""
		    s DescRowID=$P(^DHCAPPCellItemLink(ItemRowID),"^",2)
		    s Desc=$p(^DHCAPPPDI(DescRowID),"^",2)    //描述
		    continue:$p(^DHCAPPPDI(DescRowID),"^",4)'=HospID
		    s ListData=ItemRowID_"^"_Desc_"^TestItem"
		    s count = count+1
			I count=1 d
			.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
			e  d
			.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
		
		}
		d Stream.Write("]}")
	}
	//D ..JsonGetTestItem(HospID)
	d Stream.Write("]}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 临床诊断
ClassMethod JsonGetTesDiag(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPTD(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPTD(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPTD(ID),"^",2)    /// 描述
	.Q:$p(^DHCAPPTD(ID),"^",3)'=HospID
	.Q:$p(^DHCAPPTD(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^TesDiag"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 检测方法
ClassMethod JsonGetTesItmMet(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPTIM(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPTIM(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPTIM(ID),"^",2)    /// 描述
	.Q:$p(^DHCAPPTIM(ID),"^",3)'=HospID
	.Q:$p(^DHCAPPTIM(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^TesItmMet"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 治疗方式
ClassMethod JsonGetTreMet(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPTM(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPTM(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPTM(ID),"^",2)    /// 描述
	.Q:$p(^DHCAPPTM(ID),"^",3)'=HospID
	.Q:$p(^DHCAPPTM(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^TreMet"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	病人病历内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetPatRec()
ClassMethod JsonGetPatRec(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPPR(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPPR(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPPR(ID),"^",2)    /// 描述
	.Q:HospID'=$p(^DHCAPPPR(ID),"^",3)
	.Q:$p(^DHCAPPPR(ID),"^",4)'="Y"
	.s ListData=ID_"^"_Desc_"^PatRec"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	检测项目内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetTestItem()
ClassMethod JsonGetTestItem(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=0
	F  s ID=$o(^DHCAPPTI(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPTI(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCAPPTI(ID),"^",2)    /// 描述
	.Q:$p(^DHCAPPTI(ID),"^",4)'=HospID
	.Q:$p(^DHCAPPTI(ID),"^",5)'="Y"
	.s ListData=ID_"^"_Desc_"^TestItem"
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	HPV病人病历内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonPisItemList("47","LIV")
ClassMethod JsonPisItemList(PisID As %String, Type As %String = "") As %String
{
	s Num=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	i Type="TCT" d
	.d Stream.Write(..JsGetPisPatRec(PisID, .Num))
	.d Stream.Write(..JsGetPisTesDiag(PisID, .Num))
	i Type="MOL" d Stream.Write(..JsGetPisTesItm(PisID, .Num))
	i Type="CYT" D
	.d Stream.Write(..JsGetPisSpec(PisID, .Num))
	.d Stream.Write(..JsGetPisInfDis(PisID, .Num))
	.d Stream.Write(..JsGetPisFixActive(PisID, .Num))
	i Type="LIV" d Stream.Write(..JsGetPisInfDis(PisID, .Num))
	i Type="HPV" D
	.d Stream.Write(..JsGetPisTreMet(PisID, .Num))
	.d Stream.Write(..JsGetPisTesItmMet(PisID, .Num))
	.d Stream.Write(..JsGetPisTesDiag(PisID, .Num))
	.d Stream.Write(..JsGetPisSpec(PisID, .Num))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	固定方式
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisFixActive("47")
ClassMethod JsGetPisFixActive(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s CH=""
	F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	.s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",11)      /// 固定方式
	.s ListData=ID_"^FixItem"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descritp:	传染病史
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisInfDis("47")
ClassMethod JsGetPisInfDis(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPID(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TmpID=$p(^DHCAPPPID(ID),"^",2)
	.s TmpDesc=$p(^DHCAPPPID(ID),"^",3)
	.s ListData=TmpID_"^"_TmpDesc_"^TestItem"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^name",ListData))
	.
	q Stream.Read()
}

/// Descritp:	标本内容
/// w ##Class(web.DHCAppPisMasterQuery).JsonPisItemList("47")
ClassMethod JsGetPisSpec(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s CH=""
	F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	.s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	.s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	.s ListData=ID_"^PisSpec^"_Qty
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name^Qty",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name^Qty",ListData))
	.
	q Stream.Read()
}

/// Descript: 取HPV申请治疗方式数据
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisTreMet("")
ClassMethod JsGetPisTreMet(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPTM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTM(ID),"^",2)
	.s ListData=TreMetID_"^TreMet"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descript: 取HPV申请检测方法数据
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisTesItmMet("")
ClassMethod JsGetPisTesItmMet(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPTIM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTIM(ID),"^",2)
	.s ListData=TreMetID_"^TesItmMet"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descript: 取HPV申请临床诊断数据
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisTesDiag("")
ClassMethod JsGetPisTesDiag(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPTD(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTD(ID),"^",2)
	.s ListData=TreMetID_"^TesDiag"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descript: 取病人病历
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisPatRec("47",1)
ClassMethod JsGetPisPatRec(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPPR(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPPR(ID),"^",2)
	.s ListData=TreMetID_"^PatRec"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descript: 取检测方法
/// w ##Class(web.DHCAppPisMasterQuery).JsGetPisTesItm("47",1)
ClassMethod JsGetPisTesItm(PisID As %String, Num As %String) As %String
{

	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ID=""
	F  s ID=$o(^DHCAPPPTI(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTI(ID),"^",2)
	.s ListData=TreMetID_"^TestItem"
	.s Num = Num+1
	.I Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^name",ListData))
	.
	q Stream.Read()
}

/// Descript: 取标本类型
/// w ##Class(web.DHCAppPisMasterQuery).JsonGetSpecType()
ClassMethod JsonGetSpecType(HospID As %String) As %String
{

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s TypeRowid=$O(^DHCAPPPDT(0,"Desc","标本玻片类型",2,""))
	if (TypeRowid'=""){
	s APPPDIRowid=""
	for {
		s APPPDIRowid=$O(^DHCAPPPDI(0,"Type",TypeRowid,APPPDIRowid))
		q:APPPDIRowid=""
		s AppCode=$P(^DHCAPPPDI(APPPDIRowid),"^",1)
		s AppName=$P(^DHCAPPPDI(APPPDIRowid),"^",2)
		continue:($P(^DHCAPPPDI(APPPDIRowid),"^",4)'=HospID)
		s ListData=APPPDIRowid_"^"_AppName
		s count = count+1
		I count=1 d
		.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
		e  d
		.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
		}
	}
	/*s ID=0
	f  s ID=$o(^DHCAPPSST(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPSST(ID),"^",1)  ///体位代码
	.s Desc=$p(^DHCAPPSST(ID),"^",2)  ///体位描述
	.Q:$p(^DHCAPPSST(ID),"^",3)'=HospID
	.Q:$p(^DHCAPPSST(ID),"^",4)'="Y"
	.s tmp=Code_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.*/
	d Stream.Write( "]")
	q Stream.Read()
}

/// Descript:   是否允许填写妇科TCT
/// w ##Class(web.DHCAppPisMasterQuery).GetIsWriteFlagTCT()
ClassMethod GetIsWriteFlagTCT(EpisodeID As %String) As %String
{

	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s sexId=+$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	Q:$p(^CT("SEX",sexId),"^",2)'["女" "-1"
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	Q:+PatAge<18 "-2"
	Q 0
}

/// Descript:  判断病人是否死亡
/// OutPut：   N：未死亡；Y：死亡
/// W ##class(web.DHCAppPisMasterQuery).isPatDeadFlag(172)
ClassMethod isPatDeadFlag(EpisodeID As %String) As %String
{

	Q:EpisodeID="" ""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s DeathDate = $p($g(^PAPER(PatientID,"ALL")),"^",13)
	s DeathTime = $p($g(^PAPER(PatientID,"ALL")),"^",8)
	Q:(DeathDate="")&(DeathTime="") "N"
	Q "Y"
}

/// Descript:  判断病人是否死亡
/// OutPut：   N：未死亡；Y：死亡
/// W ##class(web.DHCAppPisMasterQuery).GetPisNoSysTime(172)
ClassMethod GetPisNoSysTime(PisID As %String) As %String
{

	s PisDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:PisDate'="" PisDate=$zd(PisDate,3)
	Q PisDate
}

/// Descript:  取病人是否允许填写申请单
/// OutPut：   空：允许；其他：不允许原因
/// W ##class(web.DHCAppPisMasterQuery).GetIsWritePisFlag(29,10209,95,1922)
ClassMethod GetIsWritePisFlag(LgGroupID, LgUserID, LgLocID, EpisodeID As %String, EmConsultItm As %String = "") As %String
{
	Q:EpisodeID="" ""
	s TakOrdMsg = ##Class(web.DHCAPPExaReport).GetPatNotTakOrdMsg(LgGroupID, LgUserID, LgLocID, EpisodeID, EmConsultItm)
	Q TakOrdMsg
}

/// Descript:  取申请单日志明细
/// W ##class(web.DHCAppPisMasterQuery).GetAppLogList(50,"L")
ClassMethod GetAppLogList(AppID As %String, TraType As %String) As %String
{

	Set langid=..%LanguageID()
	i AppID="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:AppID="" ""
	k TMPLogList
	if TraType="P" {
		s OEOrdRowid=$p(^DHCAPPPM(AppID,"A",1),"^",3)
		if ((OEOrdRowid="")||($p(^DHCAPPPM(AppID),"^",9)'="Y")) {
			d GetLogByApp
		}else{
			d GetOperateLog(OEOrdRowid)
		}
	}else{
		s arSendFlag=$p(^DHCAPREP(AppID),"^",17) 
		Q:arSendFlag="I" ""
		s arChildSub=0
		for {
			s arChildSub=$o(^DHCAPREP(AppID,"AR",arChildSub)) q:arChildSub=""
			s OEOrdRowid=$p(^DHCAPREP(AppID,"AR",arChildSub),"^",3)
			if (OEOrdRowid'="") {
				d GetOperateLog(OEOrdRowid)
			}else{
				d GetLogByApp
			}
		}
	}
	///转换数据为Json格式
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="ItmDate^ItmTime^ItmUser^ItmID^ItmStatus^ItmReason^ItemDesc"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()) //输出json前缀串
	s index=""
	f  s index=$o(TMPLogList(index)) q:index=""  d
	.s ListData=$g(TMPLogList(index))
	.s count=count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)) //输出json结尾符

	q Stream.Read()
GetOperateLog(OEOrdRowid)
	s str1 = ^OEORD(+OEOrdRowid,"I",$p(OEOrdRowid,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s id=0
	
	for {
		s id=$o(^Busi.ENS.EnsStatusLogI("IndexESOrdItemID"," "_OEOrdRowid,id)) Q:id=""
		s ESOperateDate=$lg(^Busi.ENS.EnsStatusLogD(id),7)
		s ESOperateDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(ESOperateDate)
		s ESOperateTime=$lg(^Busi.ENS.EnsStatusLogD(id),8)
		s ESOperateTime=..%ZT(ESOperateTime,1)
		s ESOperatorName=$lg(^Busi.ENS.EnsStatusLogD(id),6)
		s ESStatusCode=$lg(^Busi.ENS.EnsStatusLogD(id),11)
		s StatusId=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESStatusCode,""))
		s ESStatus=$lg(^Code.ENS.EnsStatusCodeD(StatusId),9)
		s ESExamPart=$lg(^Busi.ENS.EnsStatusLogD(id),4) //部位信息
		s PartStr=""
		for i=1:1:$l(ESExamPart,"@@") {
			i PartStr="" s PartStr=$p(ESExamPart,"@@",i)
			e  s PartStr=PartStr_","_$p(ESExamPart,"@@",i)
			s $p(ESExamPart,"@@",i)=##class(User.DHCAppPart).GetTranByDesc("APDesc",$p(ESExamPart,"@@",i),langid)
		}
		s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
		s ESStatus=##class(websys.Translation).Get("dhcapp.mainframe.csp",ESStatus)
		s TMPLogList($o(TMPLogList(""),-1)+1)=ESOperateDate_"^"_ESOperateTime_"^"_ESOperatorName_"^"_AppID_"^"_ESStatus_"^"_ESExamPart_"^"_ARCIMDesc
    }
    Q
GetLogByApp
 	/// 申请表
	i TraType="P" D
	.s ItmDate=$p(^DHCAPPPM(AppID),"^",6)		/// 申请日期
	.s:ItmDate'="" ItmDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItmDate) 
	.s ItmTime=$p(^DHCAPPPM(AppID),"^",7)		/// 申请时间
	.s:ItmTime'="" ItmTime=..%ZT(ItmTime,2)
	.s UserID=$p(^DHCAPPPM(AppID),"^",5)	    /// 申请人
	.s ItmUser=$p(^SSU("SSUSR",UserID),"^",2)
	.s TMPLogList(1)=ItmDate_"^"_ItmTime_"^"_ItmUser_"^"_AppID_"^"_"申请"
	.s ItmDate=$p(^DHCAPPPM(AppID),"^",11)		/// 申请日期
	.s:ItmDate'="" ItmDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItmDate) 
	.s ItmTime=$p(^DHCAPPPM(AppID),"^",12)		/// 申请时间
	.s:ItmTime'="" ItmTime=..%ZT(ItmTime,2)
	.s UserID=$p(^DHCAPPPM(AppID),"^",10)	    /// 申请人
	.s ItmUser=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	.i ItmUser'="" s TMPLogList(2)=ItmDate_"^"_ItmTime_"^"_ItmUser_"^"_AppID_"^"_"取消申请"
	E  D
	.s ItmDate=$p(^DHCAPREP(AppID),"^",2)		/// 申请日期
	.s:ItmDate'="" ItmDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItmDate)
	.s ItmTime=$p(^DHCAPREP(AppID),"^",3)		/// 申请时间
	.s:ItmTime'="" ItmTime=..%ZT(ItmTime,2)
	.s UserID=$p(^DHCAPREP(AppID),"^",4)        /// 申请人
	.s ItmUser=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	.s PartStr=""
	.s archildSub=0
	.f  s archildSub=$o(^DHCAPREP(AppID,"AR",archildSub)) q:archildSub=""  d
	..s ARChildSub=0
	..f  s ARChildSub=$o(^DHCAPREP(AppID,"AR",archildSub,"PA",ARChildSub)) q:ARChildSub=""  d
	...s ARPartDr=$p(^DHCAPREP(AppID,"AR",archildSub,"PA",ARChildSub),"^",1)
	...s PartDesc=$p($g(^DHCAPPART(ARPartDr)),"^",2)
	...s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	...i PartStr="" s PartStr=PartDesc
	...e  s PartStr=PartStr_","_PartDesc
	.s archildSub=$o(^DHCAPPPM(AppID,"A",0))
	.s ARCIMDesc=""
	.if archildSub'="" d
	..s ItmMastDR=$P(^DHCAPPPM(AppID,"A",archildSub),"^",1)
	..s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
	..s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)	
	.s ESStatus="申请"
	.s ESStatus=##class(websys.Translation).Get("dhcapp.mainframe.csp",ESStatus)
	.s TMPLogList(1)=ItmDate_"^"_ItmTime_"^"_ItmUser_"^"_AppID_"^"_ESStatus_"^"_PartStr_"^"_ARCIMDesc
	
	
	/*/// 日志表内容
	s ItmID=""
	F  s ItmID=$o(^DHCAPPRL(0,"TypePointer",TraType,AppID,ItmID)) Q:ItmID=""  D
	.s ItmUser=$p(^DHCAPPRL(ItmID),"^",5)   /// 操作人
	.s ID=$p(^DHCAPPRL(ItmID),"^",6)        /// 操作状态
	.//s ItmStatus=$p($g(^OEC("RESST",+ID)),"^",2) /// 状态描述
	.s ItmStatus=$p($g(^DHCAPPTST(+ID)),"^",2) /// 状态描述
	.s ItmDate=$p(^DHCAPPRL(ItmID),"^",7)   /// 操作日期
	.i ItmDate'="" s ItmDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItmDate)
	.s ItmTime=$p(^DHCAPPRL(ItmID),"^",8)   /// 操作时间
	.s:ItmTime'="" ItmTime=..%ZT(ItmTime,2)
	.s reason=$p(^DHCAPPRL(ItmID),"^",9)    /// 操作原因
	.s TMPLogList($o(TMPLogList(""),-1)+1)=ItmDate_"^"_ItmTime_"^"_ItmUser_"^"_AppID_"^"_ItmStatus_"^"_reason*/
	Q
}

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCAppPisMasterQuery).GetPatEssInfo("9706","6509","110","4634")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String, LocID As %String, UserID As %String) As %String
{
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)

	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s LgLocDesc=$p(^CTLOC(LocID),"^",2)
	i (UserID'="")&&$d(^SSU("SSUSR",UserID)) s UserDesc=$p(^SSU("SSUSR",UserID),"^",2)		//默认为登陆人员(取材医生)
	s AdmLocId=$p(^PAADM(EpisodeID),"^",4) 		/// 申请科室(默认就诊科室)
	s:AdmLocId'="" AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
	s CareProv=$p(^PAADM(EpisodeID),"^",9) 		/// 申请医生(默认就诊医生) // ct_careprov	医护人员表
	s:+CareProv'=0 AdmUserId=$o(^SSU("SSUSR",0,"CTPCP",CareProv,""))
	s:$g(AdmUserId)'="" AdmUserDesc=$p(^SSU("SSUSR",AdmUserId),"^",2)
	
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_LgLocDesc_"^"_$g(UserDesc)_"^"_AdmLocId_"^"_$g(AdmLocDesc)_"^"_$g(AdmUserId)_"^"_$g(AdmUserDesc)
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^LgLocDesc^UserDesc^AdmLocId^AdmLocDesc^AdmUserId^AdmUserDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:  病理申请单是否可发送
///            病理申请单在未登记前、取消、拒收时才可进行再次发送
/// OutPut:    0-允许再次发送，1-不允许发送
/// W ##Class(web.DHCAppPisMasterQuery).GetSendPisFlag("","2")
ClassMethod GetSendPisFlag(PisID) As %String
{
    /// 申请单状态
	Q:$p(^DHCAPPPM(PisID),"^",9)="D" 1
 	s ID=$p(^DHCAPPPM(PisID),"^",21)   /// 结果状态ID
 	/// 申请状态
	Q:(ID="")&($p(^DHCAPPPM(PisID),"^",9)="Y") 2
	Q:ID="" 0
	s res=$p($g(^DHCAPPTST(ID)),"^",2) /// 状态描述
	Q:(res["拒收")||(res["取消") 2
	Q 1
}

/// Creator：      sufan
/// CreatDate：    2018-02-01
/// Description：  获取检查申请现病史和体征
/// Input：		   EpisodeID:就诊号
/// Output：       现病史和体征串
/// Others：       w ##Class(web.DHCAppPisMasterQuery).GetPatClinicalRec("^33^33^65^Y")
ClassMethod GetPatClinicalRec(EpisodeID As %String) As %String
{
	s arExaReqHis="",arExaReqSig="",arExaReqSym=""
	s PatType=$p(^PAADM(EpisodeID),"^",2)  /// 病人类型
	i PatType="I" D  	/// 住院
	.//主诉
	.i arExaReqSym="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	..i obj'="" s arExaReqSym = obj.GetAt("HDSD00.13.114")
	.//现病史
	.i arExaReqHis="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	..i obj'="" s arExaReqHis = obj.GetAt("HDSD00.13.095")  
	.//体格检查
	.i arExaReqSig="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	..i obj'="" s arExaReqSig = obj.GetAt("HDSD00.13.094") 
	E  D	/// 门急诊
	.//现病史
	.i arExaReqHis="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
	..i obj'="" s arExaReqHis = obj.GetAt("HDSD00.03.038") 
	.//体格检查
	.i arExaReqSig="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
	..i obj'="" s arExaReqSig = obj.GetAt("HDSD00.03.037") 
	.//主诉
	.i arExaReqSym="" D
	..s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
	..i obj'="" s arExaReqSym = obj.GetAt("HDSD00.03.057") 
	
	s ListData=arExaReqHis_"^"_arExaReqSig_"^"_arExaReqSym
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="arExaReqHis^arExaReqSig^arExaReqSym"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	q Stream.Read()
}

/// Description:	取材科室 
/// Creator:		QuNianpeng
/// CreateDate:		2018-02-02
/// Input:			
/// return:			
/// other:			d ##class(web.DHCAppPisMasterQuery).SelAllLoc()
ClassMethod SelAllLoc(q As %String = "", hospId As %String = "") As %String
{
	s input=q 
	s input=$ZCVT(input,"U")
	Set langid=..%LanguageID()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DateActiveTo as DateActiveTo,CTLOC_DESC as locDesc,CTLOC_Hospital_DR as HospitalId FROM CT_LOC"
	i input'=""  d
	.//s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s curDate=$p(($h),",",1)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		continue:##class(web.DHCOPAdmReg).CheckLocDesc(locDr,input)'=1
		s locDesc = result.Data("locDesc")
		s locDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locDesc,langid)
		s HospitalId =  result.Data("HospitalId") 
		continue:(hospId'="")&(HospitalId'=hospId)		// 过滤医院id
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出
		continue:(hospId'="")&(hospId'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
		e  d
		.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	}
	d Stream.Write("]")
	q Stream.Read()
}

/// Description:	取材医生(根据科室取出所有可以登录该科室的医生)
/// Creator:		QuNianpeng
/// CreateDate:		2018-02-02
/// Input:			
/// return:			
/// other:			d ##class(web.DHCAppPisMasterQuery).QueryDoc()
ClassMethod QueryDoc(LocID = "") As %String
{
	k LocUserArr
	Set langid=..%LanguageID()
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s rtn="["
	i LocID'=""  d
	.s RESRowId=""
	.f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	..s RESCtPcpDR=$p($g(^RB("RES",RESRowId)),"^",2)       //医护人员ID
	..q:RESCtPcpDR=""
	..s DateActiveFrom=$p($g(^RB("RES",RESRowId)),"^",22)
	..q:(DateActiveFrom'="")&&(DateActiveFrom>+$H)
	..s DateActiveTo=$p($g(^RB("RES",RESRowId)),"^",23)
	..q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	..s UserID="" 
	..f  s UserID=$o(^SSU("SSUSR",0,"CTPCP",RESCtPcpDR,UserID)) q:UserID=""  d
	...Q:$d(LocUserArr(UserID))
	...s userName=$p(^SSU("SSUSR",UserID),"^",2)
	...s userName =##class(User.SSUser).GetTranByDesc("SSUSRName",userName,langid)
	...s LocUserArr(UserID)=1
	...S tmp=UserID_"^"_userName
	...s count = count+1
	...i count=1 d
	....s rtn=rtn _##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	...e  d
	....s rtn=rtn _","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.
	e   d
	.s LocID="" 
	.f  s LocID=$o(^RB("RES",0,"CTLOC",LocID))  q:LocID=""  d
	..s RESRowId=""
	..f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	...s RESCtPcpDR=$p($g(^RB("RES",RESRowId)),"^",2)       //医护人员ID
	...q:RESCtPcpDR=""
	...s DateActiveFrom=$p($g(^RB("RES",RESRowId)),"^",22)
	...q:(DateActiveFrom'="")&&(DateActiveFrom>+$H)
	...s DateActiveTo=$p($g(^RB("RES",RESRowId)),"^",23)
	...q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	...s UserID="" 
	...f  s UserID=$o(^SSU("SSUSR",0,"CTPCP",RESCtPcpDR,UserID)) q:UserID=""  d
	....Q:$d(LocUserArr(UserID))
	....q:UserID=""
	....s userName=$p(^SSU("SSUSR",UserID),"^",2)
	....S tmp=UserID_"^"_userName
	....s LocUserArr(UserID)=1
	....s count = count+1
	....i count=1 d
	.....s rtn=rtn _##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	....e  d
	.....s rtn=rtn _","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	k LocUserArr
	s rtn=rtn _("]")
	q rtn
}

/// Descript:   获取标本
/// W ##Class(web.DHCAppPisMasterQuery).GetPisSpec()
ClassMethod GetPisSpec(PisID) As %String
{
	s CH=$o(^DHCAPPPM(PisID,"S",""))
	Q:CH="" ""
	s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)      /// 标本名称
	s TypeID=$p(^DHCAPPPM(PisID,"S",CH),"^",10)   /// 标本类型
	Q Name_"^"_TypeID
}

/// Descript:   获取标本
/// W ##Class(web.DHCAppPisMasterQuery).isCompare("08/02/2018","01/03/2018")
ClassMethod isCompare(FriDate As %String, SecDate As %String) As %String
{
	s FriDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(FriDate)
	s SecDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(SecDate)
	Q:FriDate'>SecDate 0
	Q 1
}

/// Descritp:	检查方法
/// W ##Class(web.DHCAppPisMasterQuery).jsonExaItemListDoc("N^345^2018-03-19^11542||1^3@N^323^2018-03-19^11542||1^5")
ClassMethod jsonExaItemListDoc(arcItemList As %String) As %String
{
	s count = 0
	s del=""""
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len=$L(arcItemList,"@")
	f i=1:1:Len D
	.s itmmaststr=$p(arcItemList,"@",i)
	.s rLocID=$p(itmmaststr,"^",2)  /// 接收科室
	.s arcimid=$p(itmmaststr,"^",4)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)  //sufan 2018-11-21 判断医嘱是否可用
	.Q:(arcEndDate'="")&&(arcEndDate<+$H)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	.s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	.s itmmaststr=$REPLACE(itmmaststr,"^","*")
	.s itmmaststr=$REPLACE(itmmaststr,"||","_")
	.s rLocDesc=""
	.i rLocID'="" s rLocDesc=$p(^CTLOC(rLocID),"^",2)
	.s rLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",rLocDesc,langid)
	.s ListData=itmmaststr_"^"_arcitmdesc_"^"_rLocDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^desc",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^desc",ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	检查方法
/// W ##Class(web.DHCAppPisMasterQuery).GetPisNoFlag("N^345^2018-04-02^5434||1^1")
ClassMethod GetPisNoFlag(arcItemList As %String) As %String
{
	s EmFlag="",FrostFlag=""
	s Len=$L(arcItemList,"@")
	f i=1:1:Len D
	.s itmmaststr=$p(arcItemList,"@",i)
	.s arcimid=$p(itmmaststr,"^",4)
	.i EmFlag'="Y" D
	..s EmFlag=##Class(web.DHCAPPExaReportQuery).GetItmEmFlag(arcimid)
	.i FrostFlag'="Y" s FrostFlag=..GetItmFrostFlag(arcimid)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("EmgFlag^FrostFlag",EmFlag_"^"_FrostFlag))
	q Stream.Read()
}

/// Descript: 取医嘱项冰冻标志
/// w ##Class(web.DHCAppPisMasterQuery).GetItmFrostFlag("5429||1")
ClassMethod GetItmFrostFlag(arcimid As %String) As %String
{
	Q:arcimid="" ""
	s TraID=$o(^DHCAPARCCA(0,"Arc",arcimid,""))
	Q:TraID="" ""
	s CH=$o(^DHCAPARCCA(0,"Arc",arcimid,TraID,""))
	Q:CH="" ""
	s FrostFlag=$p(^DHCAPARCCA(TraID,"ArcItm",CH),"^",2)  /// 冰冻
	Q FrostFlag
}

/// Descript:院外会诊取病理申请标本内容
/// Author:  qunianpeng
/// Date:    2018/8/29
/// w ##Class(web.DHCAppPisMasterQuery).JsonQryPisSpecByOut("")
ClassMethod JsonQryPisSpecByOut(PisID As %String) As %String
{
	k TMPPisSpecArrOut
	s CH="",Num=0
	i PisID'="" D
	.F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	..s No=$p(^DHCAPPPM(PisID,"S",CH),"^",1)      /// 标本序号
	..s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	..s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)    /// 标本名称
	..s Explain=$p(^DHCAPPPM(PisID,"S",CH),"^",4) /// 标本说明
	..s Part=$p(^DHCAPPPM(PisID,"S",CH),"^",5)    /// 标本部位
	..s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	..s Remark=$p(^DHCAPPPM(PisID,"S",CH),"^",7)  /// 标本备注
	..s SliType=$p(^DHCAPPPM(PisID,"S",CH),"^",8) /// 玻片/蜡片
	..s PisNo=$p(^DHCAPPPM(PisID,"S",CH),"^",9)   /// 原病理号
	..s ApType=$p(^DHCAPPPM(PisID,"S",CH),"^",10)   /// 取材类型 add lp 180808
	..s:ApType'="" ApType=$p(^DHCAPPCB(ApType),"^",2) 
	..s Size=$p(^DHCAPPPM(PisID,"S",CH),"^",12)   /// 大小 add lp 180808
	..s ApTrait=$p(^DHCAPPPM(PisID,"S",CH),"^",13)   /// 标本性状 add lp 180808
	..s ApTrait=$s(ApTrait="1":"血性",ApTrait="2":"澄清",ApTrait="3":"浑浊",ApTrait="4":"脓性",ApTrait="5":"其他",ApTrait="":"")
	..s ListData=No_"^"_ID_"^"_Name_"^"_Explain_"^"_Part_"^"_Qty_"^"_Remark_"^"_SliType_"^"_PisNo_"^"_ApType_"^"_Size_"^"_ApTrait
	..s Num=Num+1
	..s TMPPisSpecArrOut(PisID_"S"_CH)=ListData
	
#;	i 5>Num d
#;	.s Len=5-Num
#;	.f i=1:1:Len d
#;	..s Num=Num+1
#;	..s TMPPisSpecArrOut("Z"_i)=Num
    i PisID="" D
	.s TMPPisSpecArrOut("Z"_1)=1_"^"_""_"^"_##class(websys.Translation).Get("docapp.blmapshow.hui.csp","切片")
	.s TMPPisSpecArrOut("Z"_2)=2_"^"_""_"^"_##class(websys.Translation).Get("docapp.blmapshow.hui.csp","蜡块")
	.s TMPPisSpecArrOut("Z"_3)=3_"^"_""_"^"_##class(websys.Translation).Get("docapp.blmapshow.hui.csp","影像学材料")
	.s TMPPisSpecArrOut("Z"_4)=4_"^"_""_"^"_##class(websys.Translation).Get("docapp.blmapshow.hui.csp","临床资料")
	.s TMPPisSpecArrOut("Z"_5)=5_"^"_""_"^"_##class(websys.Translation).Get("docapp.blmapshow.hui.csp","原单位病理诊断报告单")
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="No^ID^Name^Explain^Part^Qty^Remark^SliType^PisNo^ApType^Size^ApTrait"
	d Stream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TMPPisSpecArrOut(index)) Q:index=""  D
	.s ListData=$g(TMPPisSpecArrOut(index))
	.//Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.E  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))

	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	q Stream.Read()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAppPisMasterQuery","PisMasterQuery",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PisMasterQuery"))
}

/// w ##Class(web.DHCAppPisMasterQuery).GetOperName("279")
ClassMethod GetOperName(EpisodeID)
{
	s JsonObj=[]
	s objList=##class(CIS.AN.SRV.OperService).GetOperInfoByEpisode(EpisodeID,"")
	for i=objList.Size:-1:1 {
		s OneJsonData={}
		continue:(objList.GetAt(i).OperDesc="")
        d OneJsonData.%Set("OPSID",objList.GetAt(i).OPSID)
        d OneJsonData.%Set("OperDesc",objList.GetAt(i).OperDesc)
        d OneJsonData.%Set("OperDateTime",objList.GetAt(i).OperDateTime)
        d OneJsonData.%Set("AppCareProvDesc",objList.GetAt(i).AppCareProvDesc)
        d OneJsonData.%Set("AppDateTime",objList.GetAt(i).AppDateTime)
        d OneJsonData.%Set("BodySiteDesc",objList.GetAt(i).BodySiteDesc)
		do JsonObj.%Push(OneJsonData,"")
	
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
}

}
