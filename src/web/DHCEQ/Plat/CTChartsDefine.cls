/// Add By DJ 2019-11-15
/// 图表定义
Class web.DHCEQ.Plat.CTChartsDefine Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.Plat.CTChartsDefine).GetChartsInfo("LocEquipNums^StatCatEquipAmount^ItemBenefitInfo^LocBenefitInfo^EquipOutFeeInfo","3528,2020-08,2020-08,12214,202,85")
/// w ##Class(web.DHCEQ.Plat.CTChartsDefine).GetChartsInfo("EQNumAmount")
ClassMethod GetChartsInfo(ChartsNameStr As %String = "", ChartsPars As %String = "")
{
	s ChartsDefineInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ChartsDataInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	i ChartsNameStr="" q ChartsDataInfo
	
	i ChartsPars'=""		//czf 20200807
	{
		s ParsNum=$L(ChartsPars,",")
		f j=1:1:ParsNum  d
		.s $p(ChartsPars,",",j)=""""_$p(ChartsPars,",",j)_""""
	}
	s Count=$L(ChartsNameStr,"^")
	f i=1:1:Count
	{
		s ChartName=$p(ChartsNameStr,"^",i)
		s ChartPars=ChartsPars		//$p(ChartsPars,"^",i)
		s CDRowID=$o(^DHCEQCCode("DHCEQCChartsDefine",0,"Code",ChartName,0))
		i CDRowID'=""
		{
			s ObjChartsInfo=##Class(User.DHCEQCChartsDefine).%OpenId(CDRowID)
			s OneChartsInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjChartsInfo)
			d ChartsDataInfo.%Set(ChartName_"_D",OneChartsInfo)
			//根据配置代码获取结果XECUTE
			
			i ChartsDataInfo.%Get(ChartName_"_S")=""
			{
				i $p(OneChartsInfo.CDQueryMethod,"_",1)="M"
				{ 	
					XECUTE "s ChartsData=##Class("_OneChartsInfo.CDWebCls_")."_$p(OneChartsInfo.CDQueryMethod,"_",2)_"("_ChartPars_")"
				}
				else
				{
					//执行查询
				}
				s key=""	//CZF0131 2020-01-20
				For
				{
					s value=ChartsData.GetNext(.key)
					q:key=""
					s ChartName=value.Name
					s LegendDataDR=value.LegendDataDR
					s LegendData=value.LegendData
					s XYDataDR=value.XYDataDR
					s XYData=value.XYData
					s SeriesData=value.SeriesData
					d ChartsDataInfo.%Set(ChartName_"_ColorScheme",..GetChartsColorScheme(ChartName))
					d ChartsDataInfo.%Set(ChartName_"_LDR",LegendDataDR)
					d ChartsDataInfo.%Set(ChartName_"_L",LegendData)
					d ChartsDataInfo.%Set(ChartName_"_XYDR",XYDataDR)
					d ChartsDataInfo.%Set(ChartName_"_XY",XYData)
					d ChartsDataInfo.%Set(ChartName_"_S",SeriesData)
				}
				/*
				s EQGroupInfo=ChartsData.%GetIterator()
				while EQGroupInfo.%GetNext(.key, .value)
				{
					s ChartName=value.Name
					s LegendDataDR=value.LegendDataDR
					s LegendData=value.LegendData
					s XYDataDR=value.XYDataDR
					s XYData=value.XYData
					s SeriesData=value.SeriesData
					d ChartsDataInfo.%Set(ChartName_"_ColorScheme",..GetChartsColorScheme(ChartName))
					d ChartsDataInfo.%Set(ChartName_"_LDR",LegendDataDR)
					d ChartsDataInfo.%Set(ChartName_"_L",LegendData)
					d ChartsDataInfo.%Set(ChartName_"_XYDR",XYDataDR)
					d ChartsDataInfo.%Set(ChartName_"_XY",XYData)
					d ChartsDataInfo.%Set(ChartName_"_S",SeriesData)
				}
				*/
			}
		}
	}
	q ChartsDataInfo.%ToJSON()
}

ClassMethod GetChartsColorScheme(ChartName)
{
	i ChartName="" q ""
	
	s ColorStr=""
	s CDRowID=$o(^DHCEQCCode("DHCEQCChartsDefine",0,"Code",ChartName,0))
	if CDRowID'=""
	{
		s ColorSchemeName=$p($g(^DHCEQCCode("DHCEQCChartsDefine",CDRowID)),"^",33)
		if ColorSchemeName'=""
		{
			s CCSSort=0
			f  s CCSSort=$o(^DHCEQCCode("DHCEQCChartsColorScheme",0,"NameSort",ColorSchemeName,CCSSort))  q:CCSSort=""  d
			.s CCSRowID=0
			.f  s CCSRowID=$o(^DHCEQCCode("DHCEQCChartsColorScheme",0,"NameSort",ColorSchemeName,CCSSort,CCSRowID))  q:CCSRowID=""  d
			..s CCSColor=$p($g(^DHCEQCCode("DHCEQCChartsColorScheme",CCSRowID)),"^",3)
			..i ColorStr'="" s ColorStr=ColorStr_"^"
			..s ColorStr=ColorStr_CCSColor
		}
		else
		{
			//UI组提供统一标准配色
			s ColorStr="#40a2de^#91CD76^#EF6667^#7D69E6^#5F7CEB^#FAC958^#48AAEB^#199CF1^#FC9D49^#FF7E6A"
			//"#40a2de^#f16e57^#30b947^#0fbac0^#fb7293^#2f7ffd^#ffbd2e^#72aaff^#ff9228^#d795e7^#8096ce"
			i ##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")="lite" d
			.s ColorStr="#339eff^#35c9bc^#fac958^#ef5f54^#ffa260^#b776d1^#5f7ceb^#22c58b^#816de6^#ff7777"
		}
	}
	q ColorStr
}

ClassMethod CreateChartsData(Name As %String = "", LegendDataDR As %String = "", LegendData As %String = "", XYDataDR As %String = "", XYData As %String = "", SeriesData, ChartsObj)
{
	s ChartsData=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	d ChartsData.%Set("Name",Name)	
	d ChartsData.%Set("LegendDataDR",LegendDataDR)
	d ChartsData.%Set("LegendData",LegendData)
	d ChartsData.%Set("XYDataDR",XYDataDR)
	d ChartsData.%Set("XYData",XYData)
	d ChartsData.%Set("SeriesData",SeriesData)
	d ChartsObj.%Set(Name,ChartsData)
}

/**********************************************************************************************/
/// w ##Class(web.DHCEQ.Plat.CTChartsDefine).GetEQNumAmount()
ClassMethod GetEQNumAmount(QXType As %String = "", FacilityFlag As %String = "0")
{
	s EQGroupInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (EQCount,EQAmount,EQOLCount,EQOLAmount,EQUsedCount,EQUsedAmount,Amount,AmountFee)=0
	s (EQYearNum,EQYearAmount,EQOriginNum,EQOriginAmount)=0
	k ^Temp("Charts",$J)
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		//add by czf 2020-05-20
	k ^Temp("ChartsEQSummary",$J,user)
	s LoginLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR))  q:StoreLocDR=""  d
	.q:(QXType'="")&&(StoreLocDR'=LoginLocDR)
	.s (LocCount,LocAmount)=0
	.s EquipTypeDR=0
	.f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,"","",FacilityFlag)=1
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	...s EQOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27))
	...s EQStatCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",75)
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",59)="Y"
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",60)=0		//过滤验收未入库设备
	...; MZY0127	2642092,2642237		2022-06-15
	...q:($p($g(^DHCEQEquip(EQRowID)),"^",38)=3)||($p($g(^DHCEQEquip(EQRowID)),"^",38)=4)
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",60)=3
	...q:$p($g(^DHCEQEquip(EQRowID,"OtherInfo")),"^",24)'=""
	...s EQCount=EQCount+1
	...s EQAmount=EQAmount+EQOriginalFee
	...s LocCount=LocCount+1
	...s LocAmount=LocAmount+EQOriginalFee
	...s EQTransAssetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	...q:EQTransAssetDate=""
	...s EQTransYear=$p($zd(EQTransAssetDate,3),"-",1)
	...s EQLimitYearsNum=$p($g(^DHCEQEquip(EQRowID)),"^",31)
	...s UsedMonths=##Class(web.DHCEQCommon).DateDiffInt("m",EQTransAssetDate,+$H)
	...s EQCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)		//add by czf 2020-05-20
	...s EQItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	...s EQModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	...s EQProviderDR=$p($g(^DHCEQEquip(EQRowID)),"^",25)
	...s EQOriginDR=$p($g(^DHCEQEquip(EQRowID)),"^",20)		//czf 2021-04-25 1874218
	...i (UsedMonths>(EQLimitYearsNum*12))  d
	....s EQOLCount=EQOLCount+1
	....s EQOLAmount=EQOLAmount+EQOriginalFee
	...e  d
	....s EQUsedCount=EQUsedCount+1
	....s EQUsedAmount=EQUsedAmount+EQOriginalFee
	...s ^Temp("Charts",$J,"Charts_ETInfo",EquipTypeDR,1)=$g(^Temp("Charts",$J,"Charts_ETInfo",EquipTypeDR,1))+1
	...s ^Temp("Charts",$J,"Charts_ETInfo",EquipTypeDR,2)=$g(^Temp("Charts",$J,"Charts_ETInfo",EquipTypeDR,2))+EQOriginalFee
	...i EQStatCatDR'=""  d
	....s ^Temp("Charts",$J,"Charts_SCInfo",EQStatCatDR,1)=$g(^Temp("Charts",$J,"Charts_SCInfo",EQStatCatDR,1))+1
	....s ^Temp("Charts",$J,"Charts_SCInfo",EQStatCatDR,2)=$g(^Temp("Charts",$J,"Charts_SCInfo",EQStatCatDR,2))+EQOriginalFee
	...i EQCatDR="" s EQCatDR=0
	...i EQModelDR="" s EQModelDR=0
	...i EQProviderDR="" s EQProviderDR=0
	...i EQOriginalFee="" s EQOriginalFee=0
	...i EQOriginDR="" s EQOriginDR=0		//czf 2021-04-25 1874218
	...s Amount=1
	...s AmountFee=EQOriginalFee
	...i $d(^Temp("ChartsEQSummary",$J,user,StoreLocDR,EquipTypeDR,EQStatCatDR,EQCatDR,EQItemDR,EQModelDR,EQProviderDR,EQOriginalFee)) d
	....s Amount=$p($g(^Temp("ChartsEQSummary",$J,user,StoreLocDR,EquipTypeDR,EQStatCatDR,EQCatDR,EQItemDR,EQModelDR,EQProviderDR,EQOriginalFee)),"^",1)+1
	....s AmountFee=$p($g(^Temp("ChartsEQSummary",$J,user,StoreLocDR,EquipTypeDR,EQStatCatDR,EQCatDR,EQItemDR,EQModelDR,EQProviderDR,EQOriginalFee)),"^",2)+EQOriginalFee
	...s ^Temp("ChartsEQSummary",$J,user,StoreLocDR,EquipTypeDR,EQStatCatDR,EQCatDR,EQItemDR,EQModelDR,EQProviderDR,EQOriginalFee)=Amount_"^"_AmountFee
	...s EQYearNum=1				//czf 2021-04-09 begin
	...s EQYearAmount=EQOriginalFee
	...i $d(^Temp("Charts",$J,"Charts_YearInfo",EQTransYear)) d
	....s EQYearNum=$p($g(^Temp("Charts",$J,"Charts_YearInfo",EQTransYear)),"^",1)+1
	....s EQYearAmount=$p($g(^Temp("Charts",$J,"Charts_YearInfo",EQTransYear)),"^",2)+EQOriginalFee
	...s ^Temp("Charts",$J,"Charts_YearInfo",EQTransYear)=EQYearNum_"^"_EQYearAmount		//czf 2021-04-09 end
	...s facilityEquipTypes=##class(web.DHCEQCommon).GetSysInfo("990053")	//czf 2021-04-25 1874218 简易设备 begin
	...i (","_facilityEquipTypes_",")[(","_EquipTypeDR_",") d
	....s EQOriginNum=1
	....s EQOriginAmount=EQOriginalFee
	....i $d(^Temp("Charts",$J,"FacilityOriginal",EQOriginDR)) d
	.....s EQOriginNum=$p($g(^Temp("Charts",$J,"FacilityOriginal",EQOriginDR)),"^",1)+1
	.....s EQOriginAmount=$p($g(^Temp("Charts",$J,"FacilityOriginal",EQOriginDR)),"^",2)+EQOriginalFee
	....s ^Temp("Charts",$J,"FacilityOriginal",EQOriginDR)=EQOriginNum_"^"_EQOriginAmount		//czf 2021-04-25 1874218 简易设备 end
	.s ^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,1)=LocCount
	.s ^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,2)=LocAmount
	.s ^Temp("Charts",$J,"Charts_LocNumInfo",LocCount,StoreLocDR)=""
	.s ^Temp("Charts",$J,"Charts_LocAmountInfo",LocAmount,StoreLocDR)=""
	
	//资产总数量
	d ..CreateChartsData("EQNum","","","","","<p>资产数量</p>"_EQCount_"<span>台</span>",EQGroupInfo)
	
	//资产总金额
	d ..CreateChartsData("EQAmount","","","","","<p>资产金额</p>"_##Class(web.DHCEQCommon).FormatNumber(EQAmount/10000)_"<span>万元</span>",EQGroupInfo)
	
	//资产总数量,金额
	//d ..CreateChartsData("EQNumAmount","","","","","<p>资产数量,金额</p>"_EQCount_"<span>台</span><p>"_##Class(web.DHCEQCommon).FormatNumber(EQAmount/10000)_"万元</p>",EQGroupInfo)
	s EQNumAmountStr="<div><span>资产数量</span><span>"_EQCount_"</span><span>台</span></div><div><span>资产金额</span><span>"_##Class(web.DHCEQCommon).FormatNumber(EQAmount/10000)_"</span><span>万元</span></div>"
	d ..CreateChartsData("EQNumAmount","","","","",EQNumAmountStr,EQGroupInfo)
	
	//逾龄设备数量
	d ..CreateChartsData("EQOverNum","","","","","<p>逾龄资产数量</p>"_EQOLCount_"<span>台</span>",EQGroupInfo)
	
	//逾龄设备金额
	d ..CreateChartsData("EQOverAmount","","","","","<p>逾龄资产金额</p>"_##Class(web.DHCEQCommon).FormatNumber(EQOLAmount/10000)_"<span>万元</span>",EQGroupInfo)
	
	//逾龄设备数量,金额
	//d ..CreateChartsData("EQOverNumAmount","","","","","<p>逾龄资产数量,金额</p>"_EQOLCount_"<span>台</span><p>"_##Class(web.DHCEQCommon).FormatNumber(EQOLAmount/10000)_"万元</p>",EQGroupInfo)
	s EQOverNumAmountStr="<div><span>逾龄资产数量</span><span>"_EQOLCount_"</span><span>台</span></div><div><span>逾龄资产金额</span><span>"_##Class(web.DHCEQCommon).FormatNumber(EQOLAmount/10000)_"</span><span>万元</span></div>"
	d ..CreateChartsData("EQOverNumAmount","","","","",EQOverNumAmountStr,EQGroupInfo)
	
	
	//资产类组分类数量,金额占比
	s (ETDRStr,ETDescStr)=""
	s (OneNumInfo,OneAmountInfo,OneETNum,OnetETAmount,OnetETNumAmount)=""
	s (OneNumInfo,OneAmountInfo,OneETNum,OnetETAmount,OnetETNumAmount)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ETRowID=0
	f  s ETRowID=$o(^Temp("Charts",$J,"Charts_ETInfo",ETRowID))  q:ETRowID=""  d
	.i ETDRStr'="" s ETDRStr=ETDRStr_"^"
	.s ETDRStr=ETDRStr_ETRowID
	.s ETDesc=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",ETRowID)
	.i ETDescStr'="" s ETDescStr=ETDescStr_"^"
	.s ETDescStr=ETDescStr_ETDesc
	.d OneNumInfo.%Set(ETRowID_"-"_1,$g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,1)))
	.d OneAmountInfo.%Set(ETRowID_"-"_2,$g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,2)))
	.d OneETNum.%Set("1-"_ETRowID,$g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,1)))
	.d OnetETAmount.%Set("2-"_ETRowID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,2))/10000))
	.d OnetETNumAmount.%Set("1-"_ETRowID,$g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,1)))
	.d OnetETNumAmount.%Set("2-"_ETRowID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_ETInfo",ETRowID,2))/10000))
	
	d ..CreateChartsData("EQEquipTypeNumPercent",ETDRStr,ETDescStr,"1","资产分类数量占比",OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQEquipTypeAmountPercent",ETDRStr,ETDescStr,"2","资产分类金额占比",OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQEquipTypeNum","1","数量",ETDRStr,ETDescStr,OneETNum,EQGroupInfo)
	
	d ..CreateChartsData("EQEquipTypeAmount","2","金额",ETDRStr,ETDescStr,OnetETAmount,EQGroupInfo)
	
	d ..CreateChartsData("EQEquipTypeNumAmount","1^2","数量^金额",ETDRStr,ETDescStr,OnetETNumAmount,EQGroupInfo)
	
	//资产类型分类数量,金额占比
	s (SCDRStr,SCDescStr)=""
	s (OneNumInfo,OneAmountInfo,OneSCNum,OnetSCAmount,OnetSCNumAmount)=""
	s (OneNumInfo,OneAmountInfo,OneSCNum,OnetSCAmount,OnetSCNumAmount)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s SCRowID=0
	f  s SCRowID=$o(^Temp("Charts",$J,"Charts_SCInfo",SCRowID))  q:SCRowID=""  d
	.i SCDRStr'="" s SCDRStr=SCDRStr_"^"
	.s SCDRStr=SCDRStr_SCRowID
	.s SCDesc=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",SCRowID)
	.i SCDescStr'="" s SCDescStr=SCDescStr_"^"
	.s SCDescStr=SCDescStr_SCDesc
	.d OneNumInfo.%Set(SCRowID_"-"_1,$g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,1)))
	.d OneAmountInfo.%Set(SCRowID_"-"_2,$g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,2)))
	.d OneSCNum.%Set("1-"_SCRowID,$g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,1)))
	.d OnetSCAmount.%Set("2-"_SCRowID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,2))/10000))
	.d OnetSCNumAmount.%Set("1-"_SCRowID,$g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,1)))
	.d OnetSCNumAmount.%Set("2-"_SCRowID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_SCInfo",SCRowID,2))/10000))
	
	d ..CreateChartsData("EQStatCatNumPercent",SCDRStr,SCDescStr,"1","资产分类数量占比",OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQStatCatAmountPercent",SCDRStr,SCDescStr,"2","资产分类金额占比",OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQStatCatNum","1","数量",SCDRStr,SCDescStr,OneSCNum,EQGroupInfo)
	
	d ..CreateChartsData("EQStatCatAmount","2","金额",SCDRStr,SCDescStr,OnetSCAmount,EQGroupInfo)
	
	d ..CreateChartsData("EQStatCatNumAmount","1^2","数量^金额",SCDRStr,SCDescStr,OnetSCNumAmount,EQGroupInfo)
	
	//科室资产数量,金额(数量排序默认显示前10)
	s (LocDRStr,LocDescStr)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s DefaultCount=10
	s LocNum=""
	f  s LocNum=$o(^Temp("Charts",$J,"Charts_LocNumInfo",LocNum),-1)  q:(LocNum="")||(DefaultCount=0)  d
	.s StoreLocDR=""
	.f  s StoreLocDR=$o(^Temp("Charts",$J,"Charts_LocNumInfo",LocNum,StoreLocDR))  q:(StoreLocDR="")||(DefaultCount=0)  d
	..s DefaultCount=DefaultCount-1
	..i LocDRStr'="" s LocDRStr=LocDRStr_"^"
	..s LocDRStr=LocDRStr_StoreLocDR
	..s LocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	..i LocDescStr'="" s LocDescStr=LocDescStr_"^"
	..s LocDescStr=LocDescStr_LocDesc
	..s LocQuantity=$g(^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,1))
	..s LocAmountFee=##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,2))/10000)
	..d OneNumInfo.%Set("1-"_StoreLocDR,LocQuantity)	//数量
	..d OneAmountInfo.%Set("2-"_StoreLocDR,LocAmountFee)	//金额
	..d OneNumAmountInfo.%Set("1-"_StoreLocDR,LocQuantity)
	..d OneNumAmountInfo.%Set("2-"_StoreLocDR,LocAmountFee)
	
	
	d ..CreateChartsData("EQLocEquipNum1","1","数量",LocDRStr,LocDescStr,OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQLocEquipAmount1","2","金额",LocDRStr,LocDescStr,OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQLocEquipNumAmount1","1^2","数量^金额",LocDRStr,LocDescStr,OneNumAmountInfo,EQGroupInfo)
	
	//科室资产数量,金额(金额排序默认显示前10)
	s (LocDRStr,LocDescStr)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s DefaultCount=10
	s LocAmount=""
	f  s LocAmount=$o(^Temp("Charts",$J,"Charts_LocAmountInfo",LocAmount),-1)  q:(LocAmount="")||(DefaultCount=0)  d
	.s StoreLocDR=""
	.f  s StoreLocDR=$o(^Temp("Charts",$J,"Charts_LocAmountInfo",LocAmount,StoreLocDR))  q:(StoreLocDR="")||(DefaultCount=0)  d
	..s DefaultCount=DefaultCount-1
	..i LocDRStr'="" s LocDRStr=LocDRStr_"^"
	..s LocDRStr=LocDRStr_StoreLocDR
	..s LocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	..i LocDescStr'="" s LocDescStr=LocDescStr_"^"
	..s LocDescStr=LocDescStr_LocDesc
	..s LocQuantity=$g(^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,1))
	..s LocAmountFee=##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_LocInfo",StoreLocDR,2))/10000)
	..d OneNumInfo.%Set("1-"_StoreLocDR,LocQuantity)	//数量
	..d OneAmountInfo.%Set("2-"_StoreLocDR,LocAmountFee)	//金额
	..d OneNumAmountInfo.%Set("1-"_StoreLocDR,LocQuantity)
	..d OneNumAmountInfo.%Set("2-"_StoreLocDR,LocAmountFee)
	
	d ..CreateChartsData("EQLocEquipNum2","1","数量",LocDRStr,LocDescStr,OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQLocEquipAmount2","2","金额",LocDRStr,LocDescStr,OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQLocEquipNumAmount2","1^2","数量^金额",LocDRStr,LocDescStr,OneNumAmountInfo,EQGroupInfo)
	
	;add by czf 2021-04-09 begin
	//资产入账年份数量,金额(排序默认显示前20)
	s (YearIDs)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s DefaultCount=20
	s Year=""
	f  s Year=$o(^Temp("Charts",$J,"Charts_YearInfo",Year))  q:(Year="")||(DefaultCount=0)  d
	.s DefaultCount=DefaultCount-1
	.i YearIDs'="" s YearIDs=YearIDs_"^"
	.s YearIDs=YearIDs_Year
	.s YearInfo=$g(^Temp("Charts",$J,"Charts_YearInfo",Year))
	.s EQYearNum=$p(YearInfo,"^",1)
	.s EQYearAmount=##Class(web.DHCEQCommon).FormatNumber($p(YearInfo,"^",2)/10000)
	.d OneNumInfo.%Set("1-"_Year,EQYearNum)	//数量
	.d OneAmountInfo.%Set("2-"_Year,EQYearAmount)	//金额
	.d OneNumAmountInfo.%Set("1-"_Year,EQYearNum)
	.d OneNumAmountInfo.%Set("2-"_Year,EQYearAmount)
	
	d ..CreateChartsData("EQYearNum","1","数量",YearIDs,YearIDs,OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQYearAmount","2","金额",YearIDs,YearIDs,OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQYearNumAmount","1^2","数量^金额",YearIDs,YearIDs,OneNumAmountInfo,EQGroupInfo)
	
	;add by czf 2021-04-09 end
	
	;czf 2021-04-25 1874218 简易设备 begin
	s (OriginDRs,Origins)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo,OneNumS,OneAmountS)=""
	s (OneNumInfo,OneAmountInfo,OneNumAmountInfo,OneNumS,OneAmountS)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s OriginDR=""
	f  s OriginDR=$o(^Temp("Charts",$J,"FacilityOriginal",OriginDR),-1)  q:(OriginDR="")  d
	.i OriginDRs'="" s OriginDRs=OriginDRs_"^"
	.s OriginDRs=OriginDRs_OriginDR
	.s Origin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",OriginDR)
	.i Origin="" s Origin="无"
	.i Origins'="" s Origins=Origins_"^"
	.s Origins=Origins_Origin
	.s OriginInfo=$g(^Temp("Charts",$J,"FacilityOriginal",OriginDR))
	.s EQOriginNum=$p(OriginInfo,"^",1)
	.s EQOriginAmount=##Class(web.DHCEQCommon).FormatNumber($p(OriginInfo,"^",2)/10000)
	.d OneNumS.%Set(OriginDR_"-"_1,EQOriginNum)
	.d OneAmountS.%Set(OriginDR_"-"_2,EQOriginAmount)
	.d OneNumInfo.%Set("1-"_OriginDR,EQOriginNum)	//数量
	.d OneAmountInfo.%Set("2-"_OriginDR,EQOriginAmount)	//金额
	.d OneNumAmountInfo.%Set("1-"_OriginDR,EQOriginNum)
	.d OneNumAmountInfo.%Set("2-"_OriginDR,EQOriginAmount)
	
	d ..CreateChartsData("EQOriginNumPercent",OriginDRs,Origins,"1","简易台账来源数量占比",OneNumS,EQGroupInfo)
	
	d ..CreateChartsData("EQOriginAmountPercent",OriginDRs,Origins,"2","简易台账来源金额占比",OneAmountS,EQGroupInfo)
	
	d ..CreateChartsData("EQOriginNum","1","数量",OriginDRs,Origins,OneNumInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQOriginAmount","2","金额",OriginDRs,Origins,OneAmountInfo,EQGroupInfo)
	
	d ..CreateChartsData("EQOriginNumAmount","1^2","数量^金额",OriginDRs,Origins,OneNumAmountInfo,EQGroupInfo)
	;czf 2021-04-25 1874218 简易设备 end
	
	k ^Temp("Charts",$J)
	q EQGroupInfo
}

/// d ##Class(web.DHCEQ.Plat.CTChartsDefine).GetMonthReportList()
ClassMethod GetMonthReportList(QXType As %String = "")
{
	k ^Temp("Charts",$J)
	s EQGroupInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s LoginLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s DefaultCount=12
	s MRLYear=""
	f  s MRLYear=$o(^DHCEQMonthReportList(0,"ReportType",0,MRLYear),-1)  q:(MRLYear="")||(DefaultCount=0)  d
	.s MRLMonth=""
	.f  s MRLMonth=$o(^DHCEQMonthReportList(0,"ReportType",0,MRLYear,MRLMonth),-1)  q:(MRLMonth="")||(DefaultCount=0)  d
	..;s DefaultCount=DefaultCount-1
	..s MonthStr=MRLMonth
	..i MRLMonth<10 s MonthStr="0"_MRLMonth
	..s MRLETRowID=0
	..f  s MRLETRowID=$o(^DHCEQMonthReportList(0,"ReportType",0,MRLYear,MRLMonth,MRLETRowID))  q:MRLETRowID=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(MRLETRowID)=1
	...s MRLRowID=0
	...f  s MRLRowID=$o(^DHCEQMonthReportList(0,"ReportType",0,MRLYear,MRLMonth,MRLETRowID,MRLRowID))  q:MRLRowID=""  d
	....s MRLLocDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",3)
	....q:(QXType'="")&&(MRLLocDR'=LoginLocDR)
	....s MRLInStock=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",7)
	....s MRLDepre=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",29)
	....s MRLUsedIn=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",14)
	....s MRLEndOriginalFee=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",12)+$p($g(^DHCEQMonthReportList(MRLRowID)),"^",19)
	....s MRLEndNetFee=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",33)
	....i MRLEndNetFee=0 s MRLEndNetFee=MRLEndOriginalFee-$p($g(^DHCEQMonthReportList(MRLRowID)),"^",28)	// MZY0127	2642092,2642237		2022-06-15
	....s ^Temp("Charts",$J,"MRInSotck",MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MRInSotck",MRLYear_"-"_MonthStr))+MRLInStock
	....s ^Temp("Charts",$J,"MRUsedIn",MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MRUsedIn",MRLYear_"-"_MonthStr))+MRLUsedIn
	....s ^Temp("Charts",$J,"MRDepre",MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MRDepre",MRLYear_"-"_MonthStr))+MRLDepre
	....s ^Temp("Charts",$J,"MREndOriginalFee",MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MREndOriginalFee",MRLYear_"-"_MonthStr))+MRLEndOriginalFee
	....s ^Temp("Charts",$J,"MREndNetFee",MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MREndNetFee",MRLYear_"-"_MonthStr))+MRLEndNetFee
	....i QXType=""  d
	.....s ^Temp("Charts",$J,"MRETMonth",MRLETRowID,MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MRETMonth",MRLETRowID,MRLYear_"-"_MonthStr))+MRLInStock
	.....s ^Temp("Charts",$J,"MRETYear",MRLETRowID,MRLYear)=$g(^Temp("Charts",$J,"MRETYear",MRLETRowID,MRLYear))+MRLInStock		//czf 2021-05-12 begin 1918434
	....e  d
	.....s ^Temp("Charts",$J,"MRETMonth",MRLETRowID,MRLYear_"-"_MonthStr)=$g(^Temp("Charts",$J,"MRETMonth",MRLETRowID,MRLYear_"-"_MonthStr))+MRLUsedIn
	.....s ^Temp("Charts",$J,"MRETYear",MRLETRowID,MRLYear)=$g(^Temp("Charts",$J,"MRETYear",MRLETRowID,MRLYear))+MRLUsedIn	//czf 2021-05-12 end 1918434
	
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s PreYearMonth=##Class(web.DHCEQReport).GetPreMonth(CurMonth)
	s (PreMonthAdd,PreMonthDepre)=0.00
	s (PreMonthAddCount,PreMonthDepreCount)=0
	i PreYearMonth'=""  d
	.s PreMonthAdd=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MRInSotck",PreYearMonth))/10000)
	.i (QXType'="")  d
	..s PreMonthAdd=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MRUsedIn",PreYearMonth))/10000)
	.s PreMonthDepre=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MRDepre",PreYearMonth))/10000)
	.//上月新增数量
	.i QXType=""  d
	..s ISEquipTypeDR=0
	..f  s ISEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR))  q:ISEquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(ISEquipTypeDR)=1
	...s PreMonthSDate=##Class(web.DHCEQReport).GetReportDate(PreYearMonth,"1","")
	...s PreMonthEDate=##Class(web.DHCEQReport).GetReportDate(PreYearMonth,"2","")
	...s ISAuditDate=PreMonthSDate-1
	...f  s ISAuditDate=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISAuditDate))  q:(ISAuditDate="")||(ISAuditDate>PreMonthEDate)  d
	....s ISRowID=0
	....f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISAuditDate,ISRowID))  q:ISRowID=""  d
	.....s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	.....q:ISInvalidFlag="Y"
	.....s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.....q:ISStatus'=2
	.....q:$p($g(^DHCEQInStock(ISRowID)),"^",14)=""
	.....s ISLRowID=0
	.....f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	......s PreMonthAddCount=PreMonthAddCount+$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	.e  d
	..//上月新增数量科室
	..s SMEquipTypeDR=0
	..f  s SMEquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR))  q:SMEquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(SMEquipTypeDR)=1
	...s PreMonthSDate=##Class(web.DHCEQReport).GetReportDate(PreYearMonth,"1","")
	...s PreMonthEDate=##Class(web.DHCEQReport).GetReportDate(PreYearMonth,"2","")
	...s SMAuditDate=PreMonthSDate-1
	...f  s SMAuditDate=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate))  q:(SMAuditDate="")||(SMAuditDate>PreMonthEDate)  d
	....s SMRowID=0
	....f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate,SMRowID))  q:SMRowID=""  d
	.....s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.....q:SMInvalidFlag="Y"
	.....s SMStatus=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
	.....q:SMStatus'=2
	.....s SMMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	.....q:SMMoveType'=0
	.....s SMToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	.....q:(QXType'="")&&(SMToLocDR'=LoginLocDR)
	.....s SMLRowID=0
	.....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
	......s PreMonthAddCount=PreMonthAddCount+$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.//上月折旧数量
	.s MDRowID=0
	.f  s MDRowID=$o(^DHCEQMonthDepre(0,"Month",PreYearMonth,MDRowID))  q:MDRowID=""  d
	..s MDMainFlag=$p($g(^DHCEQMonthDepre(MDRowID)),"^",3)
	..q:MDMainFlag'="Y"
	..s MDLocDR=$p($g(^DHCEQMonthDepre(MDRowID)),"^",33)
	..s MDEquipID=$p($g(^DHCEQMonthDepre(MDRowID)),"^",1)
	..s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreYearMonth)
	..i PreSnapID'=""  d
	...s PreEquipTypeDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",MDEquipID)),"^",63)
	..e  d
	...s PreEquipTypeDR=$p($g(^DHCEQEquip(MDEquipID)),"^",63)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(PreEquipTypeDR)=1
	..q:(QXType'="")&&(MDLocDR'=LoginLocDR)
	..s PreMonthDepreCount=PreMonthDepreCount+1
	
	
	//上月新增
	//d ..CreateChartsData("BYPreMonthAdd","","","","","<p>上月新增数量,金额</p>"_PreMonthAddCount_"<span>台</span><p>"_PreMonthAdd_"万元</p>",EQGroupInfo)
	s BYPreMonthAddStr="<div><span>上月新增数量</span><span>"_PreMonthAddCount_"</span><span>台</span></div><div><span>上月新增金额</span><span>"_PreMonthAdd_"</span><span>万元</span></div>"
	d ..CreateChartsData("BYPreMonthAdd","","","","",BYPreMonthAddStr,EQGroupInfo)
	
	//上月折旧
	//d ..CreateChartsData("DPPreMonthDepre","","","","","<p>上月折旧数量,金额</p>"_PreMonthDepreCount_"<span>台</span><p>"_PreMonthDepre_"万元</p>",EQGroupInfo)
	s DPPreMonthDepreStr="<div><span>上月折旧数量</span><span>"_PreMonthDepreCount_"</span><span>台</span></div><div><span>上月折旧金额</span><span>"_PreMonthDepre_"</span><span>万元</span></div>"
	d ..CreateChartsData("DPPreMonthDepre","","","","",DPPreMonthDepreStr,EQGroupInfo)
	
	//期末原值变动
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s (OneEndOriginalFee,OneEndNetFee,OneAmountInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s DefaultCount=6
	s MonthIDStr=""
	s MonthStr=""
	for i=DefaultCount:-1:1
	{
		s PreMonth=##Class(web.DHCEQReport).GetPreMonth(CurMonth)
		i MonthIDStr'="" s MonthIDStr="^"_MonthIDStr
		s MonthIDStr=i_MonthIDStr
		i MonthStr'="" s MonthStr="^"_MonthStr
		s MonthStr=PreMonth_MonthStr
		s EndOriginalFee=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MREndOriginalFee",PreMonth))/10000)
		s EndNetFee=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MREndNetFee",PreMonth))/10000)
		d OneEndOriginalFee.%Set("1-"_i,EndOriginalFee)
		d OneEndNetFee.%Set("2-"_i,EndNetFee)
		d OneAmountInfo.%Set("1-"_i,EndOriginalFee)
		d OneAmountInfo.%Set("2-"_i,EndNetFee)
		s CurMonth=PreMonth
	}
	
	d ..CreateChartsData("EQEndOriginalFee","1","期末原值",MonthIDStr,MonthStr,OneEndOriginalFee,EQGroupInfo)
	
	d ..CreateChartsData("EQEndNetFee","2","期末净值",MonthIDStr,MonthStr,OneEndNetFee,EQGroupInfo)
	
	d ..CreateChartsData("EQEndOriginalNet","1^2","期末原值^期末净值",MonthIDStr,MonthStr,OneAmountInfo,EQGroupInfo)
	
	//近一年采购量(每月金额)
	s OneAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ETIDStr,ETStr,MonthIDStr,MonthStr)=""
	s ETRowID=""
	f  s ETRowID=$o(^Temp("Charts",$J,"MRETMonth",ETRowID))  q:ETRowID=""  d
	.s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	.s MonthIDStr=""
	.s MonthStr=""
	.s DefaultCount=12
	.f i=DefaultCount:-1:1  d
	..s PreMonth=##Class(web.DHCEQReport).GetPreMonth(CurMonth)
	..i MonthIDStr'="" s MonthIDStr="^"_MonthIDStr
	..s MonthIDStr=i_MonthIDStr
	..i MonthStr'="" s MonthStr="^"_MonthStr
	..s MonthStr=PreMonth_MonthStr
	..s MRLInStock=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MRETMonth",ETRowID,PreMonth))/10000)
	..d OneAmountInfo.%Set(ETRowID_"-"_i,MRLInStock)
	..s CurMonth=PreMonth
	.i ETIDStr'="" s ETIDStr=ETIDStr_"^"
	.s ETIDStr=ETIDStr_ETRowID
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",ETRowID)
	.i ETStr'="" s ETStr=ETStr_"^"
	.s ETStr=ETStr_EquipType
	
	d ..CreateChartsData("EQLastYearInStock",ETIDStr,ETStr,MonthIDStr,MonthStr,OneAmountInfo,EQGroupInfo)
	
	//历年采购量
	s OneAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ETIDStr,ETStr,YearIDStr,YearStr)=""
	s ETRowID=0
	f  s ETRowID=$o(^Temp("Charts",$J,"MRETMonth",ETRowID))  q:ETRowID=""  d
	.s YearIDStr=""
	.s YearStr=""
	.s DefaultCount=12
	.s CurYear=+$ZD(+$H,3)
	.i +$p($ZD(+$H,3),"-",2)=1 s CurYear=CurYear-1
	.f i=DefaultCount:-1:1  d
	..i YearIDStr'="" s YearIDStr="^"_YearIDStr
	..s YearIDStr=i_YearIDStr
	..i YearStr'="" s YearStr="^"_YearStr
	..s YearStr=CurYear_YearStr
	..s MRLInStock=##Class(web.DHCEQCommon).FormatNumber(+$g(^Temp("Charts",$J,"MRETYear",ETRowID,CurYear))/10000)
	..d OneAmountInfo.%Set(ETRowID_"-"_i,MRLInStock)
	..s CurYear=CurYear-1
	.i ETIDStr'="" s ETIDStr=ETIDStr_"^"
	.s ETIDStr=ETIDStr_ETRowID
	.s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",ETRowID)
	.i ETStr'="" s ETStr=ETStr_"^"
	.s ETStr=ETStr_EquipType
	
	d ..CreateChartsData("EQOverYearInStock",ETIDStr,ETStr,YearIDStr,YearStr,OneAmountInfo,EQGroupInfo)
	
	k ^Temp("Charts",$J)
	q EQGroupInfo
}

/// w ##Class(web.DHCEQ.Plat.CTChartsDefine).GetCurMonthWorkLoad()
ClassMethod GetCurMonthWorkLoad(QXType As %String = "")
{
	k ^Temp("Charts",$J)
	s LoginLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s EQGroupInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20		
	s MTTypeDR=0
 	f  s MTTypeDR=$o(^DHCEQMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	.q:((MTTypeDR'="1")&&(MTTypeDR'="2"))
	.s SourceID=""
	.f  s SourceID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID))  q:SourceID=""  d
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID))  q:EQRowID=""  d
	...s MTRowID=0
	...f  s MTRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	....s MTInvalidFlag=$p($g(^DHCEQMaint(MTRowID)),"^",39)
	....q:MTInvalidFlag="Y"
	....s MTStatus=$p($g(^DHCEQMaint(MTRowID)),"^",13)
	....q:MTStatus'="2"
	....s MTUseLocDR=$p($g(^DHCEQMaint(MTRowID)),"^",12)
	....q:(QXType'="")&&(MTUseLocDR'=LoginLocDR)
	....s MTEquipID=$p($g(^DHCEQMaint(MTRowID)),"^",1)
	....s MTAuditDate=$p($g(^DHCEQMaint(MTRowID)),"^",19)
	....s MTMonth=##Class(web.DHCEQReport).GetReportMonthByDate(MTAuditDate)
	....s MTMaintType=$p($g(^DHCEQMaint(MTRowID)),"^",4)		//4巡检,5计量
	....s MTFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(MTRowID)),"^",9))
	....s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MTMonth)
	....i PreSnapID'=""  d
	.....s PreEquipTypeDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",MTEquipID)),"^",63)
	....e  d
	.....s PreEquipTypeDR=$p($g(^DHCEQEquip(MTEquipID)),"^",63)
	....q:##Class(web.DHCEQCommon).EquipTypeIsIn(PreEquipTypeDR)=1
	....s CurMaintType=MTTypeDR									//1保养,2检查
	....i MTTypeDR=2  s CurMaintType=MTMaintType
	....s ^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,1)=$g(^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,1))+1
	....s ^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,2)=$g(^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,2))+MTFee
	
	s MTTypeDR=0
 	f  s MTTypeDR=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	.q:MTTypeDR'="3"
	.s SourceID=""
	.f  s SourceID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,SourceID))  q:SourceID=""  d
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID))  q:EQRowID=""  d
	...s MTRowID=0
	...f  s MTRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	....s MTInvalidFlag=$p($g(^DHCEQMMaint(MTRowID)),"^",39)
	....q:MTInvalidFlag="Y"
	....s MTStatus=$p($g(^DHCEQMMaint(MTRowID)),"^",13)
	....q:MTStatus'="2"
	....s MTUseLocDR=$p($g(^DHCEQMMaint(MTRowID)),"^",12)
	....q:(QXType'="")&&(MTUseLocDR'=LoginLocDR)
	....s MTEquipID=$p($g(^DHCEQMMaint(MTRowID)),"^",1)
	....;modify by lmm 2020-04-03
	....s MTAuditDate=$p($g(^DHCEQMMaint(MTRowID)),"^",19)
	....s MTMonth=##Class(web.DHCEQReport).GetReportMonthByDate(MTAuditDate)
	....s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MTMonth)
	....i PreSnapID'=""  d
	.....s PreEquipTypeDR=$p($g(^DHCEQSnapShot(PreSnapID,"Equip",MTEquipID)),"^",63)
	....e  d
	.....s PreEquipTypeDR=$p($g(^DHCEQEquip(MTEquipID)),"^",63)
	....q:##Class(web.DHCEQCommon).EquipTypeIsIn(PreEquipTypeDR)=1
	....s MTAuditDate=$p($g(^DHCEQMMaint(MTRowID)),"^",19)
	....s MTMonth=##Class(web.DHCEQReport).GetReportMonthByDate(MTAuditDate)
	....s MTFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMMaint(MTRowID)),"^",9))
	....s CurMaintType=MTTypeDR
	....s ^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,1)=$g(^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,1))+1
	....s ^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,2)=$g(^Temp("Charts",$J,"MonthWorkLoad",MTMonth,CurMaintType,2))+MTFee
	
	
	//上月维修
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s PreMonth=##Class(web.DHCEQReport).GetPreMonth(CurMonth)
	s PreMonthMaintCount=+$g(^Temp("Charts",$J,"MonthWorkLoad",PreMonth,3,1))
	s PreMonthMaintFee=##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"MonthWorkLoad",PreMonth,3,2)))
	//d ..CreateChartsData("MAPreMonthMaint","","","","","<p>上月维修台次,金额</p>"_PreMonthMaintCount_"<span>台次</span><p>"_PreMonthMaintFee_"元</p>",EQGroupInfo)
	s MAPreMonthMaintStr="<div><span>上月维修台次</span><span>"_PreMonthMaintCount_"</span><span>台次</span></div><div><span>上月维修金额</span><span>"_PreMonthMaintFee_"</span><span>元</span></div>"
	d ..CreateChartsData("MAPreMonthMaint","","","","",MAPreMonthMaintStr,EQGroupInfo)
	
	//当月工作量汇总
	s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s MStartDate=$p(##Class(web.DHCEQReport).GetReportDate(CurMonth,"",""),"^",1)
	s MEndDate=$p(##Class(web.DHCEQReport).GetReportDate(CurMonth,"",""),"^",2)
	s WorkLoadColor=""	//..GetChartsColorScheme("MPCurMonthWorkLoad")
	s OneWorkLoadInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	//当月验收工作量
	s (OCRCount,OCLCount)=0
	s OCRETRowID=0
	f  s OCRETRowID=$o(^DHCEQOpenCheckRequest(0,"Status",0,OCRETRowID))  q:OCRETRowID=""  d
	.s OCRRowID=0
	.f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",0,OCRETRowID,2,OCRRowID))  q:OCRRowID=""  d
	..s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	..q:OCRInvalidFlag="Y"
	..s OCREquipTypeDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(OCREquipTypeDR)=1
	..s OCRAuditDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26)
	..q:((OCRAuditDate<MStartDate)||(OCRAuditDate>MEndDate))
	..s OCRCount=OCRCount+1
	..s OCLRowID=0
	..f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID))  q:OCLRowID=""  d
	...s OCLQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	...s OCLCount=OCLCount+OCLQuantity
	i QXType="" s ^Temp("Charts",$J,"MonthWorkLoad",CurMonth,99,1)=OCRCount_":验收总单数量^"_OCLCount_":验收明细数量"
	
	s ColorCount=0	
	s MaintTypeDR=0
	f  s MaintTypeDR=$o(^Temp("Charts",$J,"MonthWorkLoad",CurMonth,MaintTypeDR))  q:MaintTypeDR=""  d
	.s TDesc=$Case(MaintTypeDR,1:"保养",3:"维修",4:"巡检",5:"计量",99:"验收",:"其他")_"设备量"
	.s ColorCount=ColorCount+1
	.i WorkLoadColor'=""  d		//配色方案缺少时,默认为
	..s CurColor=$p(WorkLoadColor,"^",ColorCount)
	..i CurColor="" s CurColor="#ffd7d7"
	.e  d	//无配色方案
	..s CurColor="#ffd7d7"
	.s TWorkLoad=$g(^Temp("Charts",$J,"MonthWorkLoad",CurMonth,MaintTypeDR,1))
	.s WorkLoadNum=$L(TWorkLoad,"^")
	.s WorkLoadStr=""
	.s i=0
	.f i=1:1:WorkLoadNum  d
	..s CurInfo=$p(TWorkLoad,"^",i)
	..s CurNum=$p(CurInfo,":",1)
	..s CurTooltip=$p(CurInfo,":",2)
	..s WorkLoadStr="<span class='eq_radius' id='eqradius"_MaintTypeDR_"-"_i_"' value='"_CurTooltip_"' style='background:"_CurColor_";'>"_CurNum_"</span>"_WorkLoadStr
	.d OneWorkLoadInfo.%Set(MaintTypeDR,"<li>"_TDesc_WorkLoadStr_"</li>")
	
	d ..CreateChartsData("MPCurMonthWorkLoad","","","","",OneWorkLoadInfo,EQGroupInfo)
	k ^Temp("Charts",$J)
	q EQGroupInfo
}

/// add by czf 2020-05-20
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTChartsDefine","EquipSummary","3172")
Query EquipSummary(EJob, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "") As %Query(ROWSPEC = "TStoreLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TName:%String,TModel:%String,TProvider:%String,TEQOriginalFee:%String,TAmount:%String,TAmountFee:%String") [ SqlProc ]
{
}

ClassMethod EquipSummaryExecute(ByRef qHandle As %Binary, EJob, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", UseLocDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EquipCatDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	i EJob="" q $$$OK
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//add by czf 2020-08-21 1468062
	
	s TStoreLocDR=""
	f  s TStoreLocDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR))  quit:TStoreLocDR=""  d
	.s TEquipTypeDR=""
	.f  s TEquipTypeDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR))  quit:TEquipTypeDR=""  d
	..s TStatCatDR=""
	..f  s TStatCatDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR))  quit:TStatCatDR=""  d
	...s TEQCatDR=""
	...f  s TEQCatDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR))  quit:TEQCatDR=""  d
	....s TItemDR=""
	....f  s TItemDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR,TItemDR))  quit:TItemDR=""  d
	.....s TModelDR=""
	.....f  s TModelDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR,TItemDR,TModelDR))  quit:TModelDR=""  d
	......s TProviderDR=""
	......f  s TProviderDR=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR,TItemDR,TModelDR,TProviderDR))  quit:TProviderDR=""  d
	.......s TEQOriginalFee=""
	.......f  s TEQOriginalFee=$o(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR,TItemDR,TModelDR,TProviderDR,TEQOriginalFee))  quit:TEQOriginalFee=""  d
	........d ResetVariablesEquipSummary
	........s TEquipSummaryInfo=$g(^Temp("ChartsEQSummary",EJob,CurUserID,TStoreLocDR,TEquipTypeDR,TStatCatDR,TEQCatDR,TItemDR,TModelDR,TProviderDR,TEQOriginalFee))
	........s TAmount=$p(TEquipSummaryInfo,"^",1)
	........s TAmountFee=$p(TEquipSummaryInfo,"^",2)
	........s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	........s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	........s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	........s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEQCatDR)
	........s TName=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
	........s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	........s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	........d OutputRowEquipSummary
    quit $$$OK
OutputRowEquipSummary
	Set Data=$lb(TStoreLoc,TEquipType,TStatCat,TEquipCat,TName,TModel,TProvider,TEQOriginalFee,TAmount,TAmountFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesEquipSummary
	s (TStoreLoc,TEquipType,TStatCat,TEquipCat,TName,TModel,TProvider,TAmount,TAmountFee)=""
	quit
}

ClassMethod EquipSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod EquipSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipSummaryExecute ]
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

/************************************************************************************/

/*
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQNum','资产数量','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQAmount','资产金额','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('DPPreMonthDepre','上月折旧','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('MAPreMonthMaint','上月维修','web.DHCEQ.Plat.CTChartsDefine','M_GetCurMonthWorkLoad','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('BYPreMonthAdd','上月新增','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('MPCurMonthWorkLoad','当月工作量汇总','web.DHCEQ.Plat.CTChartsDefine','M_GetCurMonthWorkLoad','eqgrid')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQLocEquipNum1','科室资产数量及金额分布','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','line')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQLocEquipAmount1','科室资产数量及金额分布','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','bar')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQEquipTypeNumPercent','资产分类占比','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','pie')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQEndOriginalFee','期末原值变动','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','line')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQLastYearInStock','近一年采购量','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','bar')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQStatCatNumPercent','资产分类占比(类型)','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','pie')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQOverYearInStock','历年采购量','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','bar')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQEquipTypeAmount','资产分类金额','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','bar')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQNumAmount','资产数量金额','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQOverNumAmount','逾龄资产数量金额','web.DHCEQ.Plat.CTChartsDefine','M_GetEQNumAmount','eqblock')
INSERT INTO DHC_EQCChartsDefine(cd_code,cd_desc,cd_webcls,cd_querymethod,cd_seriestype) VALUES('EQEndOriginalNet','期末原值净值变动','web.DHCEQ.Plat.CTChartsDefine','M_GetMonthReportList','line')

INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',1,'#40a2de')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',2,'#f16e57')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',3,'#30b947')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',4,'#0fbac0')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',5,'#fb7293')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',6,'#2f7ffd')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',7,'#ffbd2e')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',8,'#72aaff')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',9,'#ff9228')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',10,'#d795e7')
INSERT INTO DHC_EQCChartsColorScheme(ccs_name,ccs_sort,ccs_color) VALUES('SColor',11,'#8096ce')
*/
ClassMethod GetChartsInfoNew(ChartsNameStr As %String = "")
{
	s ChartsDataInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	i ChartsNameStr="" q ChartsDataInfo.%ToJSON()
	
	s Count=$L(ChartsNameStr,"^")
	f i=1:1:Count
	{
		s ChartName=$p(ChartsNameStr,"^",i)
		s CDRowID=$o(^DHCEQCCode("DHCEQCChartsDefine",0,"Code",ChartName,0))
		i CDRowID'=""
		{
			s ObjChartsInfo=##Class(User.DHCEQCChartsDefine).%OpenId(CDRowID)
			s ChartsDataInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjChartsInfo)
		}
	}
	q ChartsDataInfo.%ToJSON()
}

/// MZY0149	3076888,3080559		2023-01-09
/// w ##Class(web.DHCEQ.Plat.CTChartsDefine).GetInOutDetail("2022-06","2022-06",202,85)
ClassMethod GetInOutDetail(StartMonth As %String = "", EndMonth As %String = "", CTLocID As %String = "", CurGroupID As %String = "", UseLocDR As %String = "", EquipID As %String = "")
{
	;s ^DHCEQMozy("web.DHCEQ.Plat.CTChartsDefine.InOutDetail")=StartMonth_","_EndMonth_","_CTLocID_","_CurGroupID_","_UseLocDR_","_EquipID
	s EQGroupInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	i (StartMonth="")||(EndMonth="") Quit EQGroupInfo
	i ($ZDH(StartMonth_"-01",3)>$ZDH(EndMonth_"-01",3)) Quit EQGroupInfo
	s SYear=$p(StartMonth,"-",1)
	s SMonth=$p(StartMonth,"-",2)
	s EYear=$p(EndMonth,"-",1)
	s EMonth=$p(EndMonth,"-",2)
	i CTLocID="" s CTLocID=%session.Get("LOGON.CTLOCID")
	k ^Temp("Charts",$J)
	
	; ^DHCEQUseRecordStat(0,"SourceMonth",1,10904,2022,"06",14847)=""
	s SourceID=0
	f  s SourceID=$o(^DHCEQUseRecordStat(0,"SourceMonth","1",SourceID)) q:SourceID=""  d
	.q:(EquipID'="")&&(EquipID'=SourceID)
	.s TUseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.
	.;s TPersonFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","03",CTLocID,CurGroupID)		//人工费
	.;s TWaterFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","02",CTLocID,CurGroupID)		//水费
	.;s TElectricFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","01",CTLocID,CurGroupID)		//电费
	.;s TGasFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","06",CTLocID,CurGroupID)			//燃气费
	.;s THouseFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","04",CTLocID,CurGroupID)		//房屋折旧
	.;s TOfficesFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","08",CTLocID,CurGroupID)		//办公家具折旧
	.;s TPublicFee=##Class(web.DHCEQBenefitAnalyReport).EquipResourceFee(SourceID,StartMonth,EndMonth,"","07",CTLocID,CurGroupID)		//公用支出
	.s TMaintFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,StartMonth,EndMonth,"31", "",CTLocID,CurGroupID)		//维修费
	.;s TMaintainFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,StartMonth,EndMonth,"32", "",CTLocID,CurGroupID)	//保养
	.;s TInSpectFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,StartMonth,EndMonth,"33", "",CTLocID,CurGroupID)	//检查
	.;s TGuaranteeFee=##Class(web.DHCEQBenefitAnalyReport).GetGuaranteeFee(SourceID,StartMonth,EndMonth)	//保修
	.s TDepreFee=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(SourceID,StartMonth,EndMonth,"35", "",CTLocID,CurGroupID)		//折旧
	.s (TInCome,TConsumableFee)=0
	.
	.f CurYear=SYear:1:EYear d
	..s NewEMonth=EMonth
	..i CurYear<EYear s NewEMonth=12
	..f CurMonth=SMonth:1:NewEMonth d
	...i CurMonth<10 s CurMonth="0"_CurMonth
	...s rowid=0
	...f  s rowid=$o(^DHCEQUseRecordStat(0,"SourceMonth","1",SourceID,CurYear,CurMonth,rowid)) q:(rowid="")  d
	....s TUseLocDR=$p($g(^DHCEQUseRecordStat(rowid)),"^",5)
	....q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	....s TInCome=TInCome+$p($g(^DHCEQUseRecordStat(rowid)),"^",7)
	....s ConsumableID=0
	....f  s ConsumableID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",rowid,ConsumableID)) q:ConsumableID=""  d
	.....s TConsumableFee=TConsumableFee+$p($g(^DHCEQUseConsumableStat(ConsumableID)),"^",6)
	.
	.s ^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,1)=$g(^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,1))+TInCome
	.s ^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,2)=$g(^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,2))+TDepreFee+TMaintFee+TConsumableFee
	
	
	s (EQDRStr,EQDescStr)=""
	s OneREChartsInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SourceID=0
	f  s SourceID=$o(^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID)) q:SourceID=""  d
	.i EQDRStr'="" s EQDRStr=EQDRStr_"^"
	.s EQDRStr=EQDRStr_SourceID
	.
	.i EQDescStr'="" s EQDescStr=EQDescStr_"^"
    .///modified by ZY20230320 bug: 3235023
    .s EQDescStr=EQDescStr_$p($g(^DHCEQEquip(SourceID)),"^",1)    //_"("_$p($g(^DHCEQEquip(SourceID)),"^",71)_")"_##class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(SourceID)),"^",3))
	.
	.d OneREChartsInfo.%Set("1-"_SourceID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,1))))
	.d OneREChartsInfo.%Set("2-"_SourceID,##Class(web.DHCEQCommon).FormatNumber($g(^Temp("Charts",$J,"Charts_RevenueExpenditureInfo",SourceID,2))))
	
	d ..CreateChartsData("EQRevenueExpenditure","1^2","收入^支出",EQDRStr,EQDescStr,OneREChartsInfo,EQGroupInfo)
	
	
	k ^Temp("Charts",$J)
	q EQGroupInfo
}

}
