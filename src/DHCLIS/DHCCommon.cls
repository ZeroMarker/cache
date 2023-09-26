Class DHCLIS.DHCCommon Extends %RegisteredObject
{

/// 通过外部代码获取缺省标本容器	
/// w ##Class(DHCLIS.DHCCommon).GetTestsetDefSpecCon(Testsetcode,HospitalCode)
ClassMethod GetTestsetDefSpecCon(Testsetcode, HospitalCode, Languages)
{
	;根据检验套取标本 
	;PLIST:标本代码,$c(2),标本名称,$c(2),容器代码,容器名称
	;return:默认标本代码,$c(1),标本名称,$c(1),容器代码,$c(1),容器名称
	s Testsetcode=$g(Testsetcode),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	k PLIST
	Quit:$g(Testsetcode)="" ""
	s ret="",retDef="",HospitalDR=""
	//HospitalDR 医院代码的问题？
	i $l(HospitalCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(Testsetcode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalD(""))  ///获取唯一医院代码
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Testsetcode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(Testsetcode),""))
	i '$l(TestSetDR) q ""
	s SpecimenDR="" f  s SpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR)) q:SpecimenDR=""  d
	.s TSSpecDR="" f  s TSSpecDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,TSSpecDR)) q:TSSpecDR=""  d
	..s (speccode,specdesc,concode,condesc)=""
	..s SpecimenDR=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecDR)),3)
	..s ContainerDR=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecDR)),4)
	..s IsDefault=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecDR)),6)
	..//s Sequence=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecDR)),7)
	..i IsDefault=1 s IsDefault="Y"
	..e  s IsDefault="N"
	..i $l(SpecimenDR) s speccode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2),specdesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	..i $l(ContainerDR) s concode=$lg($g(^dbo.BTContainerD(ContainerDR)),2),condesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	..s specdesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,specdesc)
	..s condesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTContainer","CName",Languages,condesc)
	..i IsDefault="Y" s retDef=speccode_$c(3)_specdesc_$c(3)_concode_$c(3)_condesc_$c(3)_IsDefault_$c(2)
	..e  s ret=ret_speccode_$c(3)_specdesc_$c(3)_concode_$c(3)_condesc_$c(3)_IsDefault_$c(2)
    i $l(retDef) s ret=retDef_ret
    i $l(ret) s ret=$p(ret,$c(2),1,$l(ret,$c(2))-1)
    //获取缺省标本和窗器
    i ret="" d
    .s SpecimenDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),10)
	.s ContainerDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),11)
	.s (DefSpecCode,DefSpecDesc,DefConCode,DefConDesc)=""
	.i $l(SpecimenDR) s DefSpecCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2),DefSpecDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	.i $l(ContainerDR) s DefConCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2),DefConDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	.s DefSpecDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,DefSpecDesc)
	.s DefConDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTContainer","CName",Languages,DefConDesc)
	.i $l(DefSpecCode) s ret=DefSpecCode_$c(3)_DefSpecDesc_$c(3)_DefConCode_$c(3)_DefConDesc_$c(3)_"Y"_$c(2)
	q ret
}

/// 通过外部代码获取缺省标本代码	
/// w ##Class(DHCLIS.DHCCommon).GetTestSetSpecimen("A001","BJDTYY")
ClassMethod GetTestSetSpecimen(TSCode, HospitalCode) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode)
	
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q ""
	s SpecimenDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),10)
	i '$l(SpecimenDR) q ""
	s FirstSpecimen=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
	Quit FirstSpecimen
}

/// 通过医嘱代码以及标本类型代码，医院代码获取缺省标本采集部位	
/// w ##Class(DHCLIS.DHCCommon).GetTestSetSpecimen("A001","SP001""BJDTYY")
ClassMethod GetTestSetSpecimenSite(TSCode, SpecimenCode, HospitalCode, Languages) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode),SpecimenCode=$g(SpecimenCode),Languages=$g(Languages)
	
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s retList=""
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q ""
	s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
	i '$l(SpecimenDR) q ""
	s TestSetSpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,""))
	i '$l(TestSetSpecimenDR) q ""
	s AnatomicalSiteDR=""
	f  s AnatomicalSiteDR=$o(^dbo.BTTestSetSpecimenSiteI("IndexMaster",TestSetSpecimenDR,AnatomicalSiteDR)) q:AnatomicalSiteDR=""  d
	.s AnatomicalSiteName=$lg($g(^dbo.BTAnatomicalSiteD(AnatomicalSiteDR)),3)
	.s AnatomicalSiteCode=$lg($g(^dbo.BTAnatomicalSiteD(AnatomicalSiteDR)),2)
	.s AnatomicalSiteName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTAnatomicalSite","CName",Languages,AnatomicalSiteName)
	.i retList="" s retList=AnatomicalSiteCode_$c(2)_AnatomicalSiteName
	.e  s retList=retList_$c(3)_AnatomicalSiteCode_$c(2)_AnatomicalSiteName
	Quit retList
}

/// 通过采集部位代码获取描述
/// w ##Class(DHCLIS.DHCCommon).GetAnatomicalSite("A001","SP001""BJDTYY")
ClassMethod GetAnatomicalSite(AnatomicalSiteCode, HospitalCode, Languages) As %String
{
	s HospitalCode=$g(HospitalCode),AnatomicalSiteCode=$g(AnatomicalSiteCode),Languages=$g(Languages)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s AnatomicalSiteDR=""
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s AnatomicalSiteDR=$o(^dbo.BTAnatomicalSiteI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(AnatomicalSiteCode),""))
	i $l(LnkHospDR),'$l(AnatomicalSiteDR) s AnatomicalSiteDR=$o(^dbo.BTAnatomicalSiteI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(AnatomicalSiteCode),""))
	i '$l(AnatomicalSiteDR) q ""
	s AnatomicalSiteName=$lg($g(^dbo.BTAnatomicalSiteD(AnatomicalSiteDR)),3)
	s AnatomicalSiteName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTAnatomicalSite","CName",Languages,AnatomicalSiteName)
	s AnatomicalSiteCode=$lg($g(^dbo.BTAnatomicalSiteD(AnatomicalSiteDR)),2)
	Q AnatomicalSiteName
}

/// 通过外部代码获取缺省容器代码	
/// w ##Class(DHCLIS.DHCCommon).GetTestSetContainer("A001","BJDTYY")
ClassMethod GetTestSetContainer(TSCode, HospitalCode) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q ""
	s ContainerDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),11)
	i '$l(ContainerDR) q "" 
	s FirstContainer=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
	Quit FirstContainer
}

/// 通过代码获取标本信息	
/// w ##Class(DHCLIS.DHCCommon).GetSpecimen("SP52","BJDTYY")
ClassMethod GetSpecimen(SpecCode, HospitalCode, Languages) As %String
{
	s SpecCode=$g(SpecCode),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	
	i '$l(SpecCode) q ""
	i '$d(^DHCLISBSVersion(1)) quit SpecCode_$c(2)_$p($G(^TTAB("SPEC",SpecCode)),"\",1)
	s HospitalDR=$o(^dbo.BTSpecimenI("IndexCodeHosp",$c(32)_SpecCode,""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i $l(LnkHospDR),'$l(SpecimenDR) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i '$l(SpecimenDR) q ""
	s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	s XName=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),4)
	s SpecimenDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,SpecimenDesc)
	s XName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,XName)
	s SpecimenGroupDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),9)
	s SpecimenGroupCode="",SpecimenGroupDesc=""
	i $l(SpecimenGroupDR) s SpecimenGroupCode=$lg($g(^dbo.BTSpecimenGroupD(SpecimenGroupDR)),2),SpecimenGroupDesc=$lg($g(^dbo.BTSpecimenGroupD(SpecimenGroupDR)),3)
	s SpecimenDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,SpecimenDesc)
	s XName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName",Languages,XName)
	s SpecimenGroupDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimenGroup","CName",Languages,SpecimenGroupDesc)
	q SpecimenDR_$c(2)_SpecimenDesc_$c(2)_SpecimenGroupCode_$c(2)_SpecimenGroupDesc_$c(2)_XName
}

/// 通过代码获取采集信息	
/// w ##Class(DHCLIS.DHCCommon).GetContainer("CO1","DHSZHYYFY")
ClassMethod GetContainer(ConCode, HospitalCode, Languages) As %String
{
	s ConCode=$g(ConCode),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	i '$l(ConCode) q ""
    s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	i $l(LnkHospDR) s HospitalDR=LnkHospDR
	//获取容器主键
	s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(ConCode),""))
	i '$l(ContainerDR) q ""
	s ContainerCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
	s ContainerDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	s Volumn=$lg($g(^dbo.BTContainerD(ContainerDR)),5)
	s Color=$lg($g(^dbo.BTContainerD(ContainerDR)),6)
	s Notes=$lg($g(^dbo.BTContainerD(ContainerDR)),7)
	s ContainerDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTContainer","CName",Languages,ContainerDesc)
	q ContainerDR_$c(2)_ContainerCode_$c(2)_ContainerDesc_$c(2)_Volumn_$c(2)_Color_$c(2)_Notes
}

/// 通过代码获取标本信息	缺省激活
/// w ##Class(DHCLIS.DHCCommon).GetTSActive("A001","BJDTYY")
ClassMethod GetTSActive(TSCode, HospitalCode) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode)
	i '$l(TSCode) q "Y"
	i '$l(HospitalCode) q "Y"
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) q "Y"
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q "Y"
	s Active=$lg($g(^dbo.BTTestSetD(TestSetDR)),18)
	s TSActive="N"
	i Active=1 s TSActive="Y"
	q TSActive
}

/// 通过外部代码，标本代码获取标本容器信息	
/// 输出：容器ID，容器代码，容器描述，采集容量，容器颜色，容器描述，打印条码数量（默认0）
/// w ##Class(DHCLIS.DHCCommon).GetTSContainer("A001","SP52","BJDTYY")
ClassMethod GetTSContainer(TSCode, SpecCode, HospitalCode, Languages) As %String
{
	s SpecCode=$g(SpecCode),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	i '$l(SpecCode) q ""
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i $l(LnkHospDR),'$l(SpecimenDR) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i '$l(SpecimenDR) q ""
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) {
		s HospID=""
		for {
			s HospID = $o(^dbo.BTHospitalD(HospID))
			q:HospID=""
			i $d(^dbo.BTTestSetI("IndexCode",HospID,##Class(LIS.Util.Common).IndexData(TSCode))) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospID,##Class(LIS.Util.Common).IndexData(TSCode),""))
		}		
	}
	i '$l(TestSetDR) q ""
	s TSSpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,""))
	i '$l(TSSpecimenDR) q ""
	s ContainerDR=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecimenDR)),4)
	i '$l(ContainerDR) q ""
	s BarCodeNumber=+$lg($g(^dbo.BTTestSetSpecimenD(TSSpecimenDR)),5)
	s ContainerCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
	s ContainerDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	s Volumn=$lg($g(^dbo.BTContainerD(ContainerDR)),5)
	s Color=$lg($g(^dbo.BTContainerD(ContainerDR)),6)
	s Notes=$lg($g(^dbo.BTContainerD(ContainerDR)),7)
	s ContainerDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTContainer","CName",Languages,ContainerDesc)
	q ContainerDR_$c(2)_ContainerCode_$c(2)_ContainerDesc_$c(2)_Volumn_$c(2)_Color_$c(2)_Notes_$c(2)_BarCodeNumber
}

/// 通过外部代码获取医嘱采集提示	
/// w ##Class(DHCLIS.DHCCommon).GetTestSetCollectPrompt("F001","BJDTYY")
ClassMethod GetTestSetCollectPrompt(TSCode, HospitalCode, AdmissionTypeCode, InputDate, InputTime) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode)
	s AdmissionTypeCode=$g(AdmissionTypeCode),InputDate=$g(InputDate),InputTime=$g(InputTime)
	s retList=##class(DHCLIS.DHCCommon).GetRecTip(TSCode, AdmissionTypeCode, InputDate, InputTime, HospitalCode) 
	i $l($p(retList,"^",1)) q $p(retList,"^",1) //优先取新的采集提示
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q ""
	s CollectPromptDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),15)
	i '$l(CollectPromptDR) q "" 
	s CollectPrompt=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)
	Quit CollectPrompt
}

/// CreatDate:		20220902
/// Description:	根据传入医嘱代码与病人就诊类型代码,采集时间(不传默认取当前时间),医院Code返回优先级最高(规则表BTTATTimeTSGroupRule序号最小的)的提示信息
/// Table：        
/// Input： 医嘱代码:ITestSetCodes  多个医嘱外部代码以"^"分隔。合管的有可能不同医嘱对应的时间不一样
/// 		病人类型:IAdmTypeCode(非急诊的默认全部归属门诊O,急诊的归属急诊E)	
/// 		日期:ICollectDate:格式与$p($h,",",1)相同(如64444),不传取当前日期
/// 		时间:ICollectTime:格式与$p($h,",",2)相同(如60665),不传取当前时间
/// 			是否加急:IUrgent:1加急 0不加急(加急统一归属病人类型为急诊的)
/// Output:	格式: $lb("医嘱Codes1@R@采集提示@I@医嘱Codes2^采集提示",医嘱Codes1@R@取报告提示@I@医嘱Codes2^取报告提示)=====>医嘱Codes1@R@取报告提示@I@医嘱Codes2^取报告提示(医嘱codes和取报告结果的分隔符@R@ ; 不同取报告结果之间分割符@I@ )
/// Others： w ##class(DHCLIS.DHCCommon).GetRecTip("D0001^D0002", "O", "", "", "DHSZHYYZY", "") 
ClassMethod GetRecTip(TestSetCodes, AdmissionTypeCode, InputDate, InputTime, HospitalCode, Urgent) As %String
{
	s TestSetCodes=$g(TestSetCodes), AdmissionTypeCode=$g(AdmissionTypeCode), InputDate=$g(InputDate), InputTime=$g(InputTime), HospitalCode=$g(HospitalCode), Urgent=$g(Urgent)
    SET $ZTRAP="ERR"
    NEW $NAMESPACE 
	s $NAMESPACE= "DHC-LISDATA"
    s ret=##class(LIS.WS.BLL.DHCBTTATTimeTSGroupRule).GetReportTipMTHD(TestSetCodes, AdmissionTypeCode, InputDate, InputTime, HospitalCode,Urgent) 
    s $NAMESPACE= "DHC-APP"
    q ret
    
ERR
    s $NAMESPACE= "DHC-APP"
 	s ret=$lb("","")
 	q ret
}

/// Creator:		HWS 
/// CreatDate:		20161214/修改日期: 20200709 sun yuan wei
/// Description:	根据传入医嘱代码与病人就诊类型代码,根据优先级传出取回执单时间,
/// 				其中日期与时间可不传,要传就要一起传(传入时间写死,就可以利用传入时间给出固定的取单提示)
/// Table：        
/// Input： 医嘱代码:TestSetCodes  多个医嘱外部代码以"^"分隔
/// 		病人类型:  AdmissionTypeCode  例如:(I住院,O门诊)	
/// 		日期:InputDate,	格式与$p($h,",",1)相同(如64444)
/// 		时间:InputTime:格式与$p($h,",",2)相同(如60665)
/// Output:	采集提示:CollectRemark,取报告提示:GetRepRemark,取报告时间(如果有维护):GetRecTime,是否加急Urgent
/// 			$lb(CollectRemark,GetRepRemark,GetRecTime,Urgent)
/// Return：       
/// Others： w ##class(DHCLIS.DHCCommon).GetRecTip("S0021","O","","") 
ClassMethod GetRecTipOld(TestSetCodes, AdmissionTypeCode, InputDate, InputTime, HospitalCode) As %String
{
	s TestSetCodes=$g(TestSetCodes), AdmissionTypeCode=$g(AdmissionTypeCode), InputDate=$g(InputDate), InputTime=$g(InputTime), HospitalCode=$g(HospitalCode)
    
    SET $ZTRAP="ERR"
	//医院代码 暂不考虑多医院,如果有多医院,可使用通过写死传入时间的方式来维护数据
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""

	//设置一个优先级的初始值,在输出前可以比较
	s Urgent=0
	s Priority=0
	s CollectRemark=""
	s GetRepRemark=""
	s GetRecTip=""
	s GetRecTime=""
	s GetTimeNum=""
	s WeekName=""
	s TestSetCodes=$g(TestSetCodes)
	s AdmissionTypeCode=$g(AdmissionTypeCode)
	s InputDate=$g(InputDate)
	s InputTime=$g(InputTime)
	i ($l(InputDate))&&('$l(InputTime)) q
	i ($l(InputTime))&&('$l(InputDate)) q
	//获得就诊类型ID
	s AdmissionTypeDR=$o(^dbo.BTAdmissionTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(AdmissionTypeCode),""))
	f i=1:1:$l(TestSetCodes,"^") d
	.s TestSetCode=$p(TestSetCodes,"^",i)
	.s TestSetDR="" f  s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),TestSetDR)) q:TestSetDR=""  d
	..// 存在节假日的话优先取WeekName为节假日,未传入日期默认取当天
	..i ('$l(InputDate))&&('$l(InputTime)) s Today=$p($h,",",1)
	..s WeekName=..GetFestival(Today)
	..i $l(WeekName),($d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekName),AdmissionTypeDR))) d
	...d getInfo
	..else  d
	...i ($l(InputDate))&&($l(InputTime)) s WeekName=$zd(InputDate,10)  //$zd(64444,12)
	...i ('$l(InputDate))&&('$l(InputTime)) s WeekName=$zd($p($h,",",1),10)
	...i WeekName="0" s WeekName="7"
	...s WeekName=..GetWeek(WeekName)
	...i '$l(WeekName) q
	...d getInfo
	
	s Ret=CollectRemark_"^"_GetRepRemark_"^"_GetRecTip_"^"_Urgent
	Quit Ret
	
getInfo
	i '$d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR)) s GetRepRemark="",Data=$lb(CollectRemark,GetRepRemark,GetRecTip)  
	i '$d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekName))) s GetRepRemark="",Data=$lb(CollectRemark,GetRepRemark,GetRecTip)  
	i '$d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekName),AdmissionTypeDR)) s GetRepRemark="",Data=$lb(CollectRemark,GetRepRemark,GetRecTip) 
	// 兼容老版本后台日期存数字的数据
	s WeekNum=..WeekToNum(WeekName)
	i '$d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekName),AdmissionTypeDR)),$d(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekNum),AdmissionTypeDR)) s WeekName=WeekNum
	b ;1
	s ReceiptDR="" f  s ReceiptDR=$o(^dbo.BTTestSetReceiptI("IndexTestSetDR",TestSetDR,##Class(LIS.Util.Common).IndexData(WeekName),AdmissionTypeDR,ReceiptDR)) q:ReceiptDR=""  d
	.s ReceiptData=$g(^dbo.BTTestSetReceiptD(ReceiptDR))
	.//先取优先级高的
	.s CurPriority=$lg(ReceiptData,4)
	.//w CurPriority,",",Priority,!
	.i CurPriority>Priority d
	..;b ;tt1
	..i $l(InputTime) s NowTime=InputTime
	..i '$l(InputTime) s NowTime=$p($h,",",2)
	..//该时间段有维护数据
	..i ($lg(ReceiptData,5)<NowTime)&&(NowTime<$lg(ReceiptData,6)) d
	...;b ;tt2
	...s CollectRemark=$lg(ReceiptData,9)
	...s GetRepRemark=$lg(ReceiptData,10)
	...s Urgent=$lg(ReceiptData,11)
	...//如果维护了取报告时间,就计算
	...s GetTimeNum=$lg(ReceiptData,7)
	...i $l(GetTimeNum) d
	....;b ;tt3
	....//后台存的是分钟,自动计算,先判断分钟小于1440表示就在今明天,
	....i GetTimeNum<=1440 d
	.....s GetRecTime=NowTime+(GetTimeNum*60)
	.....//如果小于86399表示还在今天
	.....i GetRecTime<86399 d
	......s GetRecTip="请于今日"_$p($zt(GetRecTime),":",1,2)_"后来取报告"
	.....i GetRecTime>86399 d
	......s GetRecTip="请于明日"_$p($zt(GetRecTime-86400),":",1,2)_"后来取报告"
	....//如果大于1440表示至少在明天或明天后
	....i GetTimeNum>1440 d
	.....;b //获得取报告日期
	.....s NowDate=$p($h,",",1)
	.....s DayNum=NowDate+$p((GetTimeNum/1440),".",1)
	.....s GetDate=$p($zd(DayNum,3),"-",2,3)
	.....//获得取报告时间 
	.....//s GetRecTip="请于"_GetDate_"的"_($p($zt((GetTimeNum*60)-(1440*DayNum)),":",1,2))_"后取报告"
	.....//单位为天的直接改为多少天后
	.....s GetRecTip="请于"_GetDate_"后来取报告"
	.....s Priority=CurPriority
	.//如果优先级相同,就判断取报告时间是否存在,存在就取时间迟的
	.i CurPriority=Priority d
	..;b ;Priority2
	..s NowTime=$p($h,",",2)
	..//该时间段有维护数据,并且维护的时间长于上一条医嘱
	..i ($lg(ReceiptData,5)<NowTime)&&(NowTime<$lg(ReceiptData,6)) d
	...i GetTimeNum<$lg(ReceiptData,7) q
	...s GetTimeNum=$lg(ReceiptData,7)
	...s CollectRemark=$lg(ReceiptData,9)
	...s GetRepRemark=$lg(ReceiptData,10)
	...s Urgent=$lg(ReceiptData,11)
	...//后台存的是分钟,自动计算,先判断分钟小于1440表示就在今明天,
	...i GetTimeNum<=1440 d
	....s GetRecTime=NowTime+(GetTimeNum*60)
	....//如果小于86399表示还在今天
	....i GetRecTime<86399 d
	.....s GetRecTip="请于今日"_$p($zt(GetRecTime),":",1,2)_"后来取报告"
	....i GetRecTime>86399 d
	.....s GetRecTip="请于明日"_$p($zt(GetRecTime-86400),":",1,2)_"后来取报告"
	...//如果大于1440表示至少在明天或明天后
	...i GetTimeNum>1440 d
	....//获得取报告日期
	....s NowDate=$p($h,",",1)
	....s DayNum=NowDate+$p((GetTimeNum/1440),".",1)
	....s GetDate=$p($zd(DayNum,3),"-",2,3)
	....//获得取报告时间 
	....//s GetRecTip="请于"_GetDate_"的"_($p($zt(GetTimeNum-(1440*DayNum)),":",1,2))_"后取报告"
	....s GetRecTip="请于"_GetDate_"天后来取报告"
	Set Data=$lb(CollectRemark,GetRepRemark,GetRecTip,Urgent)
	Quit Data
	
ERR
 s ret=" "
 q ret
}

// 数字星期转换

ClassMethod GetWeek(WeekNum) As %String
{
	i '$l(WeekNum) q ""
	i WeekNum=1 q "星期一"
	i WeekNum=2 q "星期二"
	i WeekNum=3 q "星期三"
	i WeekNum=4 q "星期四"
	i WeekNum=5 q "星期五"
	i WeekNum=6 q "星期六"
	i WeekNum=7 q "星期天"
	q ""
}

// 日期节假日准换

/// w ##class(DHCLIS.DHCCommon).GetFestival("65195")
ClassMethod GetFestival(InputDate) As %String
{
	i '$l(InputDate) q ""
	s Name=""
	s Date=$Extract($zd(InputDate,8),5,8)
	s FestivalDR="" f  s FestivalDR=$o(^dbo.SYSFestivalD(FestivalDR)) q:FestivalDR=""  d
	.s FestivalDate=$lg($g(^dbo.SYSFestivalD(FestivalDR)),4)
	.s FestivalName=$lg($g(^dbo.SYSFestivalD(FestivalDR)),3)
	.s FestivalDate=$Extract(FestivalDate,5,8)
	.i Date=FestivalDate s Name=FestivalName q
	q Name
}

// 星期数字转换

ClassMethod WeekToNum(Week) As %String
{
	i '$l(Week) q ""
	i Week="星期一" q 1
	i Week="星期二" q 2
	i Week="星期三" q 3
	i Week="星期四" q 4
	i Week="星期五" q 5
	i Week="星期六" q 6
	i Week="星期天" q 7
	q Week
}

/// 通过外部代码获取取报告提示地点_$c(2)_取报告提示内容	
/// w ##Class(DHCLIS.DHCCommon).GetTestSetReportPrompt("A001","")
ClassMethod GetTestSetReportPrompt(TSCode, HospitalCode) As %String
{
	s TSCode=$g(TSCode),HospitalCode=$g(HospitalCode)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	b //根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) q ""
	b
	s (ReportPromptPlace,ReportPromptRemark)=""
	s ReportPromptDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),16)
	i $l(ReportPromptDR) d
	.s ReportPromptPlace=$lg($g(^dbo.BTReportPromptD(ReportPromptDR)),6)
	.s ReportPromptRemark=$lg($g(^dbo.BTReportPromptD(ReportPromptDR)),7)
	Quit ReportPromptPlace_$c(2)_ReportPromptRemark
}

/// 重复项目判断
/// w ##Class(DHCLIS.DHCCommon).CheckRepeatLabSpec("A059","C062","BJDTYY")
ClassMethod CheckRepeatLabSpec(TSList, TSCode, HospitalCode) As %String
{
	s TSList=$g(TSList),TS=$g(TS),HospitalCode=$g(HospitalCode)
	k ^TMP($zn,$i,$j)
 	s TestCode=$p($p(TSCode,$c(1),2),"@",1)
 	s TSCode=$p(TSCode,$c(1),1)
 	s flag=0

	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q flag
	///获取判断项目
 	i $l(TestCode),$d(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestCode))) d   //医嘱合并
 	.s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestCode),""))
 	.i $l(TestCodeDR) d
 	..s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),14)   ///标准码 判断
 	..i $l(SCode) s ^TMP($zn,$i,$j,"TC",SCode)=""
 	e  d
 	.s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	.i $l(TestSetDR) d
	..s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR, WorkGroupDR)) q:WorkGroupDR=""  d
	...s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR, WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
	....s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),14)   ///标准码 判断
	....i '$l(SCode) s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),2) 
	....i $l(SCode) s ^TMP($zn,$i,$j,"TC",SCode)=""
 	///判断项目是否已经存在
 	f temi=1:1:$l(TSList,"^") d  i flag=1 q
 	.s temTS=$p(TSList,"^",temi)
 	.s temtc=$p($p(temTS,$c(1),2),"@",1)
 	.s temTS=$p(temTS,$c(1),1)
 	.s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(temtc),""))
 	..i $l(TestCodeDR) d
 	...s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),14)   ///标准码 判断
 	...i SCode["9999" q   //备注退出
 	...i $l(SCode),$d(^TMP($zn,$i,$j,"TC",SCode)) s flag=1 q
 	.i flag=1 q
 	.///医嘱判断
 	.s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(temTS),""))
 	.i '$l(TestSetDR) q
	.s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR, WorkGroupDR)) q:WorkGroupDR=""  d
	..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR, WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
 	...s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),14)   ///标准码 判断
 	...i '$l(SCode) s SCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),2) 
 	...i SCode["9999" q   //备注退出
 	...i $l(SCode),$d(^TMP($zn,$i,$j,"TC",SCode)) s flag=1 q
 	k ^TMP($zn,$i,$j)
 	q flag
}

/// Creator:      huangll
/// CreatDate:    20100408
/// Description:  获取医嘱默认工作小组信息
/// Table:        
/// Input:        检验组合套代码（外部代码）,医院代码
/// Output:       
/// Return:       工作小组主键^^^工作小组代码^^^工作小组名称
/// Others:   
ClassMethod GetTSDefaultWGM(TestSetCode As %String, HospitalCode As %String, Languages) As %String
{
	s TestSetCode=$g(TestSetCode),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	s retVal=""
	i '$l(TestSetCode) q retVal
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q retVal
	///获取判断项目
 	i $l(TestSetCode),$d(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode))) d 
 	.S TSDR=$O(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
 	.S WGMDR=$lg($g(^dbo.BTTestSetD(TSDR)),13)
 	.s WGMCName=$LG($G(^dbo.BTWorkGroupMachineD(WGMDR)),3)
 	.s WGMCName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTWorkGroupMachine","CName",Languages,WGMCName)
 	.I $L(WGMDR) S retVal=$LG($G(^dbo.BTWorkGroupMachineD(WGMDR)),1)_"^^^"_$LG($G(^dbo.BTWorkGroupMachineD(WGMDR)),2)_"^^^"_WGMCName
    q retVal
}

/// Creator:      liuzf
/// CreatDate:    20100408
/// Description:  判断医嘱结果状态是否异常
/// Table:        
/// Input:        检验RowID
/// Output:       
/// Return:       0：无异常结果；1：有异常结果
/// Others:   
ClassMethod checkTSResultStatus(VisitNumberReportDR As %String) As %String
{
  s VisitNumberReportDR=$g(VisitNumberReportDR)
  s TSAbFlag=0
  i '$l(VisitNumberReportDR) q TSAbFlag
  
  s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR)) q:TestCodeDR=""  d
  .s VisitNumberReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",VisitNumberReportDR,TestCodeDR,""))
  .s Result = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),5)
  .s ResultDR=$lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),4)
  .s AbFlag = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),9)
  .s TestCodeDR = $lg(^dbo.RPVisitNumberReportResultD(VisitNumberReportResultDR),3)
  .s ResultFormat = $lg(^dbo.BTTestCodeD(TestCodeDR),9)
  .i '$l(Result) q
  .i $l(TestCodeDR),(ResultFormat="M") d
  ..s Positive=""
  ..i $l(ResultDR),$d(^dbo.BTOrganismD(ResultDR)) s Positive=$lg($g(^dbo.BTOrganismD(ResultDR)),16)
  ..i Positive="N" s Result=""
  ..i $l(Result) s TSAbFlag=1
  .i TSAbFlag=0,AbFlag="L" s TSAbFlag=1
  .i TSAbFlag=0,AbFlag="H" s TSAbFlag=1
  .i TSAbFlag=0,AbFlag="A" s TSAbFlag=1
  .i TSAbFlag<2,AbFlag="PL" s TSAbFlag=2 ///危机值
  .i TSAbFlag<2,AbFlag="PH" s TSAbFlag=2 
  .i TSAbFlag<2,AbFlag="S" s TSAbFlag=2 
  .i TSAbFlag<3,AbFlag="UL" s TSAbFlag=3  ///荒诞值
  .i TSAbFlag<3,AbFlag="UH" s TSAbFlag=3  ///荒诞值
  q TSAbFlag
}

/// Creator：      liuzf
/// CreatDate：    20140421
/// Description：  保存仪器小组最新流水号
/// Table：        dbo.RPWorkGroupMachineEpis
/// Input：        Epis：流水号  1-12,2-23...
/// Output：       无
/// Return：       流水号列表
ClassMethod SaveWorkGroupMachineEpis(WorkGroupMachineDR, AddDate, EpisNo) As %String
{
	s WorkGroupMachineDR=$g(WorkGroupMachineDR),AddDate=$g(AddDate),EpisNo=$g(EpisNo)
	i $d(^dbo.RPWorkGroupMachineEpisI("IndexMaster",WorkGroupMachineDR, AddDate)) d
	.s RowID=$o(^dbo.RPWorkGroupMachineEpisI("IndexMaster",WorkGroupMachineDR, AddDate,""))
	.s objWGMEpis=##Class(dbo.RPWorkGroupMachineEpis).%OpenId(RowID)
	e  d
	.s objWGMEpis=##Class(dbo.RPWorkGroupMachineEpis).%New()
	s objWGMEpis.WorkGroupMachineDR=WorkGroupMachineDR
	s objWGMEpis.AddDate=AddDate
	s objWGMEpis.EpisNo=EpisNo
    s sc=objWGMEpis.%Save()
	If ($SYSTEM.Status.IsOK(sc)) {s ret=1}
	Else { s ret=$SYSTEM.Status.GetErrorText(sc) }
	q ret
}

/// Creator：      liuzf
/// CreatDate：    20131127
/// Description：  保存标本登记记录
/// Table：        dbo.RP_VisitNumberRecord
/// Input：        标本ID,操作时间,操作者,操作说明,操作类型,工作组,标本拒收类型
/// Output：       无
/// Return：       保存结果 
/// Others
ClassMethod SaveRecord(VisitNumberDR, OperateDate, OperateTime, UserID, OperateNotes, OperateTypeCode, WorkGroupMachineDR, RejectTypeDR) As %String
{
    s VisitNumberDR=$g(VisitNumberDR),UserID=$g(UserID),OperateDate=$g(OperateDate),OperateTime=$g(OperateTime),OperateNotes=$g(OperateNotes)
    s OperateTypeCode=$g(OperateTypeCode),WorkGroupMachineDR=$g(WorkGroupMachineDR),RejectTypeDR=$g(RejectTypeDR)
 	s OperateTypeDR=""
 	i $l(OperateTypeCode) s OperateTypeDR=$o(^dbo.BTOperatorTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(OperateTypeCode),""))
    i '$l(OperateTypeDR) q "100^记录状态为空"
    
    i '$l(OperateDate) s OperateDate=$tr($zd(+$h,3),"-")
    i '$l(OperateTime) s OperateTime=$p($h,",",2)
    
	s objRecord=##class(dbo.RPVisitNumberRecord).%New()
	s objRecord.VisitNumberDR=VisitNumberDR
	s objRecord.OperateDate=OperateDate
	s objRecord.OperateTime=OperateTime
	s objRecord.OperateUserDR=UserID
	s objRecord.OperateNotes=OperateNotes
	s objRecord.OperateTypeDR=OperateTypeDR  ///操作类型
	s objRecord.WorkGroupMachineDR=WorkGroupMachineDR
	s objRecord.RejectTypeDR=RejectTypeDR
	s sc=objRecord.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {q 1}
 	else {q $SYSTEM.Status.GetErrorText(sc)}
}

/// 获取报告危机值提示
ClassMethod GetPanicMsg(VisitNumberDR) As %String
{
	i '$l(VisitNumberDR) q ""
	s AddDate=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,""),-1)
	i '$l(AddDate) q ""
	s AddTime=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,""),-1)
	i '$l(AddTime) q ""
	s VisitNumberPanicReportDR=$o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime,""))
	i '$l(VisitNumberPanicReportDR) q ""
	s retVal=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberPanicReportDR)),13)
	q retVal
}

/// 医生站配置标本采集关联医嘱
/// w ##Class(DHCLIS.DHCCommon).getSpeciamenList()
ClassMethod getSpeciamenList(HospitalCode) As %String
{
	s HospitalCode=$g(HospitalCode)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	s SPECstr=""
	s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
	.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
	.s Active=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),11)
	.i Active'=1 q
	.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
	.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	.s BloodFlag=$p($g(^TTAB("SPEC",SPECCode,"DHC")),"\",1)
	.s BloodFlagDesc=""
	.i BloodFlag=1 s BloodFlagDesc="统一取血"
	.i BloodFlag=2 s BloodFlagDesc="按标本取血"
	.s SPECDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName","",SPECDesc)
	.i SPECstr="" s SPECstr=SPECCode_$c(2)_SPECDesc_$C(2)_BloodFlag_$C(2)_BloodFlagDesc
	.e  s SPECstr=SPECstr_$c(1)_SPECCode_$c(2)_SPECDesc_$C(2)_BloodFlag_$C(2)_BloodFlagDesc
	q SPECstr
}

/// 医生站配置标本采集容器关联医嘱
/// w ##Class(DHCLIS.DHCCommon).getContainerList()
ClassMethod getContainerList(HospitalCode, Languages) As %String
{
	s HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""

	s Constr=""
	s Con="" f  s Con=$o(^dbo.BTContainerI("IndexCode",HospitalDR,Con)) q:Con=""  d
	.s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,Con,""))
	.s ConCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
	.s ConDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	.s ConDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTContainer","CName",Languages,ConDesc)
	.s BloodFlag=$p($g(^TTAB("CON",ConCode,"DHC")),"\",1)
	.s BloodFlagDesc=""
	.if BloodFlag=1 s BloodFlagDesc="统一取血"
	.if BloodFlag=2 s BloodFlagDesc="按容器取血"
	.i Constr="" s Constr=ConCode_$c(2)_ConDesc_$C(2)_BloodFlag_$C(2)_BloodFlagDesc
	.e  s Constr=Constr_$c(1)_ConCode_$c(2)_ConDesc_$C(2)_BloodFlag_$C(2)_BloodFlagDesc
	q Constr
}

/// 医生站配置标本采集容器关联医嘱
/// w ##Class(DHCLIS.DHCCommon).getClinicalConditions()
ClassMethod getClinicalConditions(Languages) As %String
{
	s Languages=$g(Languages)
    s Constr=""
	s Seq="" f  s Seq=$o(^dbo.BTClinicalConditionsI("IndexSequence",Seq)) q:Seq=""  d
	.s ConditionDR=""
	.f  s ConditionDR=$o(^dbo.BTClinicalConditionsI("IndexSequence",Seq,ConditionDR)) q:ConditionDR=""  d
	..s Code=$lg($g(^dbo.BTClinicalConditionsD(ConditionDR)),2)
	..s CName=$lg($g(^dbo.BTClinicalConditionsD(ConditionDR)),3)
	..i $lg($g(^dbo.BTClinicalConditionsD(ConditionDR)),5)'=1 q
	..s CName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTClinicalConditions","CName",Languages,CName)
	..i Constr="" s Constr=Code_$c(2)_CName
	..e  s Constr=Constr_$c(1)_Code_$c(2)_CName
	q Constr
}

/// 根据检验号获取拒收标记 1:有  其它：无
/// w ##Class(DHCLIS.DHCCommon).GetRejectSpecFlag(检验号)
ClassMethod GetRejectSpecFlag(Labno) As %String
{
	s Labno=$g(Labno)
	s RetVal=100	
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(Labno),""))
	i '$l(VisitNumberDR) q RetVal
	s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
	i '$l(AdmNo) q RetVal
	i $d(^dbo.RPVisitNumberRejectSpecI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),VisitNumberDR)) s RetVal=1
	q RetVal
}

/// / w ##Class(DHCLIS.DHCCommon).CombineTestSetMTHD("7^10^11","","","","","","","","","","","","","","1^^1^^1")
ClassMethod CombineTestSetMTHD(FTestSetDR As %String, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
    s FTestSetDR=$g(FTestSetDR)
	s HospitalDR=$p(Sessions,"^",5),WorkGroupDR=$p(Sessions,"^",2)
	s UserDR=$p(Sessions,"^",1)
	k ^TMP($zn,$i,$j)
	s repid=$i(^CacheTemp)
 	s ind=1
    s RowCount=0
    //每个索引下标对应的组合套
    s AlreadyString=""
    f i=1:1:$l(FTestSetDR,"^") d
    .s TestSetArray(i)=$p(FTestSetDR,"^",i)
    //遍历出所有可以直接合管的医嘱
    f i=1:1:$l(FTestSetDR,"^") d
    .;s TestSetDRi=$p(FTestSetDR,"^",i)
    .i (("@"_AlreadyString_"@")[("@"_i_"@"))  q 
    .f j=i+1:1:$l(FTestSetDR,"^") d
    ..i (("@"_AlreadyString_"@")[("@"_j_"@"))  q
    ..s ret=##Class(LISSP.DHCRPVisitNumber).CheckContent(TestSetArray(i),TestSetArray(j))
    ..i $p(ret,"@",1)=1   d
    ...i (("@"_AlreadyString_"@")[("@"_j_"@"))  q 
    ...i '$l($g(^TMP($zn,$i,$j,i))) s ^TMP($zn,$i,$j,i)=j    
    ...e  s ^TMP($zn,$i,$j,i)=$g(^TMP($zn,$i,$j,i))_"@"_j   
    ...i '$l(AlreadyString) s AlreadyString=i_"@"_j 
    ...e  s AlreadyString=AlreadyString_"@"_i_"@"_j
    zw ^TMP($zn,$i,$j)  
    f k=1:1:$l(FTestSetDR,"^") d  
    .i '$D(^TMP($zn,$i,$j,k))  d
    ..i (("@"_AlreadyString_"@")'[("@"_k_"@"))  d
    ...i '$l($g(retTestSetDR))  s retTestSetDR=TestSetArray(k) 
    ...e  s retTestSetDR=TestSetArray(k)_"|"_retTestSetDR
    .i $D(^TMP($zn,$i,$j,k))  d
    ..s ^TMP($zn,$i,$j,k)=k_"@"_^TMP($zn,$i,$j,k)
    ..s TestSetlist=""
    ..f s=1:1:$l(^TMP($zn,$i,$j,k),"@")  d
    ...s num=$p(^TMP($zn,$i,$j,k),"@",s) 
    ...i '$l($g(TestSetlist)) s TestSetlist=TestSetArray(num) 
    ...e  s TestSetlist=TestSetlist_"@"_TestSetArray(num) 
    ..i '$l($g(retTestSetDR))  s retTestSetDR=TestSetlist
    ..e  s retTestSetDR=TestSetlist _"|"_retTestSetDR
    q retTestSetDR
}

ClassMethod CheckContent(TestSetA, TestSetB)
{
	s ret=0
	s TestSetGroupDRA="" f  s TestSetGroupDRA=$o(^dbo.BTTestSetGroupLinksI("IndexTestSet",TestSetA,TestSetGroupDRA)) q:TestSetGroupDRA=""  d
	.I $d(^dbo.BTTestSetGroupLinksI("IndexTestSet",TestSetB,TestSetGroupDRA)) s ret=1 Q
	Q ret
}

/// s ##Class(DHCLIS.DHCCommon).GetTestSetGroup()
ClassMethod GetTestSetGroup(TestSetCode As %String, HospitalCode As %String) As %String
{
	s HospitalCode=$g(HospitalCode) S TestSetCode=$G(TestSetCode)
	i '$l(TestSetCode) q ""
	s TestSetCode=$zcvt(TestSetCode,"U")
	s HospitalCode=$zcvt(HospitalCode,"U")
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TestSetCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20200805 hll
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	i $l(LnkHospDR) s HospitalDR=LnkHospDR 
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
	i '$l(TestSetDR) q ""
	s TestSetGroupDR=$o(^dbo.BTTestSetGroupLinksI("IndexTestSet",TestSetDR,""),-1) 
	i (($L(TestSetGroupDR))&&($lg($G(^dbo.BTTestSetGroupD(TestSetGroupDR)),6)=0)) q ""
	Q TestSetGroupDR
}

/// w ##Class(DHCLIS.DHCCommon).GetRecLocByArcim("2087||1")
/// 获取检验科室工作组
/// 入参：医嘱项目ID 
ClassMethod GetRecLocByArcim(arcimDr, HospitalCode, Languages) As %String
{
	s arcimDr=$g(arcimDr),HospitalCode=$g(HospitalCode),Languages=$g(Languages)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	s TSCode=..GetTSExtCode(arcimDr)
	s ret=""
	i $l(TSCode) d
	.i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	.i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	.i '$l(HospitalDR) q
	.//根据医院获取基础数据关联医院 20181020 huhm
	.s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	.s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	.i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	.i '$l(TestSetDR) q
	.s WorkGroupDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),22)
	.i $l(WorkGroupDR) s ret=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)
	s ret=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTWorkGroup","CName",Languages,ret)
	q ret
}

/// 获取外部代码
ClassMethod GetTSExtCode(arcimDr) As %String
{
	Quit:$g(arcimDr)="" ""
	Quit:'$d(^ARCIM(+arcimDr,1,"EXT")) ""
	Set Ext=$o(^ARCIM(+arcimDr,1,"EXT",0))
	Quit:$g(Ext)="" ""
	Set ExtCode=$p(^ARCIM(+arcimDr,1,"EXT",Ext),"^",4)
	Quit ExtCode
}

/// Function: 查询医嘱项外部代码数据
/// CreateDate: 2014/11/18
/// Table:     ARC_ItmMast
/// P1代码,P2描述,P3药物查找,P4别名,P5记账组,P6记账子组,P7医嘱子类,P8服务组,P9收费规定
/// Debugs:    d ##class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QryItmMastExtCode","","","","","","","xcg","","","")
Query QryItmMastExtCode(ID As %String, date As %String = "", P1 As %String, P2 As %String, P3 As %String, P4 As %String, P5 As %String, P6 As %String, P7 As %String, P8 As %String, P9 As %String = "") As %Query(ROWSPEC = "ItemCatRowId,code,desc,phcdCode,billGroup,billSub,itemCat, billUnit, itemCat , ServMaterial,billUnit,priority, serviceGroup, orderAbbrev , OrderOnItsOwn,  AllowStockCheck, EffDate ,EffDateTo,rowid,BillGroupRowid,billSubRowid,billunitRowid,serviceGroupRowid,priorityRowId,ARCICRowId,ARCIMSensitive,OEMessage,ARCIMDerFeeRulesDR,DerFeeRulesDRRowId,INFOSpec,orderprice,ARCIMChgOrderPerHour,ARCIMDeceasedPatientsOnly,ARCIMDisplayCumulative,ARCIMUseODBCforWord,ARCIMRestrictEM,ARCIMRestrictIP,ARCIMRestrictOP,ARCIMRestrictHP,ARCIMSensitive,ARCIMSensitiveOrder,ARCIMBillDescription,ARCIMInsCoDesc,ARCIMConsultDept,ARCIMDentalStateDR,ARCIMDaysCheckDuplicate,ARCIMResultGroup,ARCIMResultDisplayGroupDR,ARCIMWordTemplate,ARCIMRBNotes,ARCIMProcessingNotes,ARCIMConsultDeptRowid,ARCIMDentalStateRowid,ResultDisplayGroupRowid")
{
}

ClassMethod QryItmMastExtCodeExecute(ByRef qHandle As %Binary, ID As %String, date As %String = "", P1 As %String, P2 As %String, P3 As %String, P4 As %String, P5 As %String, P6 As %String, P7 As %String, P8 As %String, P9 As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s:date'="" date=$zdh(date,15)
 s AliasText=""
 
 s paramnum=8 //##class(web.DHCBL.CT.ARCItmMast).GetCMInParaNum("web.UDHCJFPRICE","GetOrderPrice")
 //获取授权Json
 s AuHospStr="" //##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
 s AuStr=""  //##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
 if ($l(AuStr,"#")=1) {
  s Limited=0
  s AutBit=""
 }
 elseif ($l(AuStr,"#")=2) {
  s Limited=$p(AuStr,"#",1)
  s AutBit=$p(AuStr,"#",2)
 }
	s serviceGroupRowid="",serviceGroup="",ItemCatRowId="",itemCat="", EffDateTo=""
	s ARCIMSubscript=0 for  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=0 for  s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s ItemCatRowId=ARCIMSubscript_"||"_ARCIMVersion
	..s ARCRowid=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
	..s OrderType=""
	..i ARCRowid'="" s OrderType=$P(^ARC("IC",ARCRowid),"^",7)
	..Q:OrderType'="L"
	..; 遍历 医院子表，查询医院dr 进行筛选
	..//s HospChildsub=0,AuHospFlag=1 
	..//s strHospitalID=""
	..//for
	..//{
	..//s HospChildsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
	..//s HOSPHospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",HospChildsub)),"^",1)  
	..//s strHospitalID = "{ID:"_HOSPHospitalDR_"}"
	..//if (AuHospStr[strHospitalID) s AuHospFlag=1
	..//}
	..s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
	..s desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	..s orderAbbrev =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",3)
	..s orderAbbrev =$tr(orderAbbrev,"""","")
	..s code =$tr(code,"""","")
	..s desc =$tr(desc,"""","")
	..s orderAbbrev =$p(orderAbbrev,$c(13,10),1)
	..s code =$p(code,$c(13,10),1)
	..s desc =$p(desc,$c(13,10),1)
	..s ARCIMPHCDFDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)       ;药物   
	..s:ARCIMPHCDFDR'="" ARCIMPHCDFDR11=$p(ARCIMPHCDFDR,"||",1)   
	..s:ARCIMPHCDFDR'="" phcdCode= $p($g(^PHCD(ARCIMPHCDFDR11,1)),"^",1)
	..s:ARCIMPHCDFDR="" phcdCode=""
	..s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)     ; 医嘱子分类
	..s (ItemCatRowId,itemCat)=""
	..if (ARCIMItemCatDR'="") s ItemCatRowId=ARCIMItemCatDR,itemCat=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)  
	..s ARCIMBillSubDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)       ; 账单组与 账单子组
	..s:ARCIMBillSubDR'="" billGrp=$p(ARCIMBillSubDR,"||",1)                     ; 账单组DR
	..s:ARCIMBillSubDR'="" billGroup=$p($g(^ARCBG($p(ARCIMBillSubDR,"||",1))),"^",2) 
	..s:ARCIMBillSubDR'="" billSub=$P($g(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2))),"^",2)    
	..s:billGrp'="" BillGroupRowid=billGrp
	..s:ARCIMBillSubDR'="" billSubRowid=ARCIMBillSubDR
	..s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)    ;计帐单位 
	..s:ARCIMBillingUOMDR'="" billunitRowid=ARCIMBillingUOMDR
	..s:ARCIMBillingUOMDR'="" billUnit=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
	..s ARCIMDefPriorityDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",22)   ; 医嘱优先级(默认优先级)
	..s priorityRowId=ARCIMDefPriorityDR
	..s:ARCIMDefPriorityDR'="" priority=$p($g(^OECPR(ARCIMDefPriorityDR)),"^",2)
	..s OrderOnItsOwn = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",13)      ; 独立医嘱
	..s:OrderOnItsOwn="" OrderOnItsOwn="N"    
	..s AllowStockCheck = $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",11)    ; 无库存医嘱
	..s:AllowStockCheck="" AllowStockCheck="N"
	..s ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18)       ;加急医嘱
	..s:ARCIMSensitive="" ARCIMSensitive="N"
	..s ARCIMServiceGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",7)   ;服务资源组
    ..s serviceGroup ="",serviceGroupRowid=""
    ..if (ARCIMServiceGroupDR'="") s serviceGroup =$p($g(^RBC("SG",ARCIMServiceGroupDR)),"^",2),serviceGroupRowid=ARCIMServiceGroupDR
    ..s ServMaterial=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",6)        ;服务/材料
    ..s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ;开始日期
    ..s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
    ..s:ARCIMEffDate'="" EffDate =$zd(ARCIMEffDate,1)  
    ..s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期
    ..s EffDateTo=""
    ..if (ARCIMEffDateTo'="") s EffDateTo=$zd(ARCIMEffDateTo,1)
    ..s OEMessage=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))                ; 医嘱备注  
    ..s ARCIMUpdateUser=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",3)      ; 修改人
    ..s ARCIMSensitiveOrder= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",22)   
    ..s ARCIMSensitiveOrder=  $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)
    ..s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)  ;收费规定
    ..s DerFeeRulesDRRowId=ARCIMDerFeeRulesDR
    ..s:ARCIMDerFeeRulesDR'="" ARCIMDerFeeRulesDR=$p($g(^ARC("DFR",ARCIMDerFeeRulesDR)),"^",2)
    ..s ARCIMDerFeeRulesDR =$p(ARCIMDerFeeRulesDR,$c(13,10),1)
    ..s ARCIMChgOrderPerHour=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",25) 
    ..s:ARCIMChgOrderPerHour="" ARCIMChgOrderPerHour="N"
    ..s ARCIMDeceasedPatientsOnly=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",29) 
    ..s:ARCIMDeceasedPatientsOnly="" ARCIMDeceasedPatientsOnly="N"
    ..s ARCIMDisplayCumulative=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",23) 
    ..s:ARCIMDisplayCumulative="" ARCIMDisplayCumulative="N"
    ..s ARCIMUseODBCforWord=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",6) 
    ..s:ARCIMUseODBCforWord="" ARCIMUseODBCforWord="N"
    ..s ARCIMRestrictEM=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",12) 
    ..s:ARCIMRestrictEM="" ARCIMRestrictEM="N"
    ..s ARCIMRestrictIP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",13) 
    ..s:ARCIMRestrictIP="" ARCIMRestrictIP="N"
    ..s ARCIMRestrictOP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",14) 
    ..s:ARCIMRestrictOP="" ARCIMRestrictOP="N"
    ..s ARCIMRestrictHP=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,10)),"^",15) 
    ..s:ARCIMRestrictHP="" ARCIMRestrictHP="N"
    ..s ARCIMSensitive=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",18) 
    ..s:ARCIMSensitive="" ARCIMSensitive="N"
    ..s ARCIMSensitiveOrder=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",22) 
    ..s:ARCIMSensitiveOrder="" ARCIMSensitiveOrder="N" 
    ..s ARCIMBillDescription=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",12)     ;账单描述
    ..s ARCIMInsCoDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",3)            ;二选一描述
    ..s ARCIMConsultDept=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",4)          ;consulationDepartment
    ..s:ARCIMConsultDept'="" ARCIMConsultDeptRowid=ARCIMConsultDept  
    ..s:ARCIMConsultDept="" ARCIMConsultDeptRowid=""
    ..s:ARCIMConsultDept'="" ARCIMConsultDept=$p($g(^CTLOC(ARCIMConsultDept)),"^",2)  ; 科室名
    ..s:ARCIMConsultDept="" ARCIMConsultDept=""
    ..s ARCIMDentalStateDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",28)       ;DentalState
    ..s:ARCIMDentalStateDR'="" ARCIMDentalStateRowid=ARCIMDentalStateDR
    ..s:ARCIMDentalStateDR="" ARCIMDentalStateRowid=""
    ..s:ARCIMDentalStateDR'="" ARCIMDentalStateDR= $p($g(^OEC("DENST",ARCIMDentalStateDR)),"^",2)
    ..s:ARCIMDentalStateDR="" ARCIMDentalStateDR=""
    ..s ARCIMDaysCheckDuplicate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",8)  ;核实医嘱复制天数
    ..s ARCIMResultGroup=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",3)   ;Result Group  
    ..s ARCIMResultDisplayGroupDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",24)  ;Result Display Group
    ..s:ARCIMResultDisplayGroupDR'="" ResultDisplayGroupRowid=ARCIMResultDisplayGroupDR
    ..s:ARCIMResultDisplayGroupDR="" ARCIMResultDisplayGroupDR=""
    ..s:ARCIMResultDisplayGroupDR'="" ARCIMResultDisplayGroupDR=$p($g(^OEC("RESDGRP",ARCIMResultDisplayGroupDR)),"^",2)
    ..s:ARCIMResultDisplayGroupDR="" ARCIMResultDisplayGroupDR=""
    ..s ARCIMWordTemplate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",15)        ;模板
    ..s ARCIMRBNotes=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"RB",1))                   ;Booking Notes
    ..s ARCIMProcessingNotes=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,9)),"^",14)     ;Processing Notes
    ..; 规格
    ..s INFOSpec=""
    ..s INCIRowid=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0)) 
    ..if (INCIRowid'="") d
    ...s INFOSpecRowId=$O(^DHCITMINFO(0,"INCI",INCIRowid,0))
    ...if (INFOSpecRowId'="") s INFOSpec=$p($g(^DHCITMINFO(INFOSpecRowId)),"^",27)
    ..; 医嘱项价格
    ..s orderprice=""
    ..if (paramnum=10) d
    ...s:date'="" orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,date,"","","","",HOSPtalID,"")
    ...s:date="" orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,+$h,"","","","",HOSPtalID,"")
    ..if (paramnum=8) d
    ...s:date'="" orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,date,"","","","")
    ...s:date="" orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,+$h,"","","","")
    ..s orderprice=$p(orderprice,"^",1)
    ..Set P3=$ZCONVERT(P3,"U")  ; 药物
    ..s AliasFlag=0
    ..if (P4'="") d
    ...S P4=$ZCVT(P4,"U")
    ...s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
    ...s ALIASRowId=0 for  s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId)) q:ALIASRowId=""  d
	....s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
	....IF ($ZCONVERT(ALIASText,"U")[P4) s AliasFlag=1
	..if (P4'=""),AliasFlag=0 q
	..if (P1'=""),($zcvt(code,"U")'[$zcvt(P1,"U")) q
	..if (P2'=""),($zcvt(desc,"U")'[$zcvt(P2,"U")) q
	..if (P5'=""),(billGrp'=P5) q
	..if (P6'=""),(ARCIMBillSubDR'=P6) q 
	..if (P7'=""),(ARCIMItemCatDR'=P7) q
	..if (P8'=""),(ARCIMServiceGroupDR'=P8) q 
	..if (P9'=""),(DerFeeRulesDRRowId'=P9) q
    ..d OutputRow

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ItemCatRowId,code,desc,phcdCode,billGroup,billSub,itemCat,billUnit,itemCat,ServMaterial,billUnit,priority, serviceGroup,orderAbbrev,OrderOnItsOwn,AllowStockCheck,EffDate,EffDateTo,rowid,BillGroupRowid,billSubRowid,billunitRowid,serviceGroupRowid,priorityRowId,ARCICRowId,ARCIMSensitive,OEMessage,ARCIMDerFeeRulesDR,DerFeeRulesDRRowId,INFOSpec,orderprice,ARCIMChgOrderPerHour,ARCIMDeceasedPatientsOnly,ARCIMDisplayCumulative,ARCIMUseODBCforWord,ARCIMRestrictEM,ARCIMRestrictIP,ARCIMRestrictOP,ARCIMRestrictHP,ARCIMSensitive,ARCIMSensitiveOrder,ARCIMBillDescription,ARCIMInsCoDesc,ARCIMConsultDept,ARCIMDentalStateDR,ARCIMDaysCheckDuplicate,ARCIMResultGroup,ARCIMResultDisplayGroupDR,ARCIMWordTemplate,ARCIMRBNotes,ARCIMProcessingNotes,ARCIMConsultDeptRowid,ARCIMDentalStateRowid,ResultDisplayGroupRowid)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryItmMastExtCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItmMastExtCodeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QryItmMastExtCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItmMastExtCodeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator：      liuzf
/// CreatDate：    
/// Description:： 保存危机值处理信息 危机值报告ID 提供危机消息接口用
/// Table：        
/// Other: w ##Class(DHCLIS.DHCCommon).SaveTransPanicNotice(37,"01697","^fasf^231312^afdafsa","")
ClassMethod SaveTransPanicNotice(VisitNumberReportPanicDR, UserCode As %String, TransStr, Status) As %String
{
	Set $ZTrap = "ErrorHandle"
	s ^TMPLIS("DHCLIS.DHCCommon","SaveTransPanicNotice")=$lb(VisitNumberReportPanicDR, UserCode , TransStr, Status)
	s VisitNumberReportPanicDR=+$g(VisitNumberReportPanicDR),UserCode=$g(UserCode)
	//s NoticeTime=$p(TransStr,"^",1)
  	//s MedicalStaff=$p(TransStr,"^",2)
  	s NoticePhone=$p(TransStr,"^",3)
  	s NoticeNotes=$p(TransStr,"^",4)
	s NoticeDate=$tr($zd($p($h,",",1),3),"-")
	s NoticeTime=$p($h,",",2)
	
	s User=""
 	Set UserCode=$zcvt(UserCode,"U")
 	Set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	i $l(UserId) s User=$P($g(^SSU("SSUSR",UserId)),"^",2)
	s HasOut=0
	s obj=##Class(dbo.RPVisitNumberPanicReport).%OpenId(VisitNumberReportPanicDR)
	s obj.Readed=1
	s obj.Notice=1
	s obj.DoctorRecDate=NoticeDate
	s obj.DoctorRecRemark=NoticeNotes
	s obj.DoctorRecTime=NoticeTime 
	i obj.IsSendBackToLIS=1 s HasOut=1
	s obj.IsSendBackToLIS=1
	S obj.ReceiveDoctor=User
	s WorkGroupMachineDR = obj.WorkGroupMachineDR
	s sc=obj.%Save()
	If ($SYSTEM.Status.IsOK(sc))
	{
		//网络加电话上报的更新下电话通知记录
		i (obj.SendMode="B")
		{
		   &Sql(Update dbo.RP_VisitNumberPanicNotice Set NoticeDate=:NoticeDate,NoticeTime=:NoticeTime,NoticePatient=:User,NoticePhone=:NoticePhone,NoticeNotes=:NoticeNotes,Finish=1 Where VisitNumberReportPanicDR=:VisitNumberReportPanicDR)
		}
		
	}
	
	//向检验科发送已处理消息
	/*  默认停用回复消息，意义不大
	s VisitNumberDR = obj.VisitNumberDR
	i $l(VisitNumberDR),(HasOut=0)  {
		s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
		s SurName=$lg(RPVisitNumberData,13)
		s VisitNumber = $lg(RPVisitNumberData,2)
		
		s $NameSpace="dhc-lisdata"
	    s retObj=##Class(wbsLisMsgAsyncHandler.LISMsg.wbsLisMsgAsyncHandlerSoap).%New()
	    s perUser = "WG-"_$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	    s ret=retObj.SendMsg("dhcc","{ ""type"": ""危急结果已处理"", ""info"": ""标本号为"_VisitNumber_"的标本【"_SurName_"】的危急值已经被【"_User_"】处理"", ""dealurl"": """" }", "Crisis", perUser)
	    s $NameSpace="DHC-APP"
	}*/
	q 0
ErrorHandle
	q 1
}

Query QueryPanicResult(VisitNumberReportDR As %String) As %Query(ROWSPEC = "TestCodeName,VisitNumberReportPanicDR,TestCodeDR,Result,TextRes,ExtraRes,OtherRes,ResNoes,AbFlag,RefRanges,MethodDR,MachineParameterDR,AssayDate,AssayTime,Sequence,Unit")
{
}

/// Creator：      liuzf
/// CreatDate：    
/// Description:： 根据检验报告ID获取危机结果 提供危机消息接口用
/// Table：        
/// Input：        
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QueryPanicResult","631")     
ClassMethod QueryPanicResultExecute(ByRef qHandle As %Binary, VisitNumberReportPanicDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	Set qHandle=$lb(0,repid,0)
	s VisitNumberReportPanicDR=$g(VisitNumberReportPanicDR)
	i '$l(VisitNumberReportPanicDR) Quit $$$OK
	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR)) Quit:TestCodeDR=""  d
	.s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR,""))
	.s Data=$li($g(^dbo.RPVisitNumberPanicResultD(PanicResultDR)),1,15)
	.s TestCodeName="",Unit=""
	.i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3),Unit=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),8)
	.s $li(Data,1)=TestCodeName 
	.s $li(Data,16)=Unit
	.d OutputRow

	Quit $$$OK
	
OutputRow 
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPanicResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPanicResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPanicResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPanicResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryPanicResultByLabNo(VisitNumber As %String) As %Query(ROWSPEC = "TestCodeName,VisitNumberReportPanicDR,TestCodeDR,Result,TextRes,ExtraRes,OtherRes,ResNoes,AbFlag,Unit,RefRanges,MethodDR,MachineParameterDR,AssayDate,AssayTime,Sequence")
{
}

/// Creator：      liuzf
/// CreatDate：    
/// Description:： 根据检验号获取危机结果 提供危机消息接口用
/// Table：        
/// Input：        
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QueryPanicResult","631")     
ClassMethod QueryPanicResultByLabNoExecute(ByRef qHandle As %Binary, VisitNumber As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	Set qHandle=$lb(0,repid,0)
	s VisitNumber=$g(VisitNumber)
	
	i '$l(VisitNumber) Quit $$$OK
	s VisitnumberDR = $o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(VisitNumber),""))
	i '$l(VisitnumberDR) Quit $$$OK
	s AddDate="" f  s AddDate=^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitnumberDR,AddDate) q:AddDate=""  d
	.s AddTime="" f  s AddTime=^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitnumberDR,AddDate,AddTime) q:AddTime=""  d
	..s VisitNumberReportPanicDR = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitnumberDR,AddDate,AddTime,""))
	..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR)) Quit:TestCodeDR=""  d
	...s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR,""))
	...s Data=$g(^dbo.RPVisitNumberPanicResultD(PanicResultDR)),TestCodeName=""
	...i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3),Unit=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),8)
	...s $li(Data,1)=TestCodeName 
	...d OutputRow

	Quit $$$OK
	
OutputRow 
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
	i $d(Unit) s $LI(Data,9)=Unit 
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPanicResultByLabNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPanicResultExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPanicResultByLabNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPanicResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(DHCLIS.DHCCommon).UPPER("f001,")
ClassMethod UPPER(val) As %String
{
	set val=$tr(val,"-_#*()@!~%^&,")
	set lower = "abcdefghijklmnopqrstuvwxyz"
	set upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	q $translate( val, lower,  upper )
}

/// 获取用户DR
/// w ##Class(DHCLIS.DHCCommon).GetUserDR("med","med manager","1")
ClassMethod GetUserDR(Code, CName, HospitalDR, UserType) As %String
{
	s ^QQA = $lb(Code, CName, HospitalDR, UserType)
	s Code=$g(Code),CName=$g(CName),HospitalDR=$g(HospitalDR),UserType=$g(UserType)
	i '$l(UserType) s UserType="DOC"  ///默认同步为医生类型
	s Code=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s RowID=""
	i $d(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	.s Userobj=##Class(dbo.SYSUser).%OpenId(RowID)
	e  d
	.s Userobj=##Class(dbo.SYSUser).%New()
	.s Userobj.Code=Code
	.s Userobj.CName=CName
	.s Userobj.HospitalDR=HospitalDR
	.s Userobj.Active=1
	.s Userobj.UserType=UserType
	
  
 	//处理用户职称的问题 ADD BY SZW 20170417
 	s PositionTitleRowID=""
 	s HisDocID = $O(^CTPCP(0,"Code",Code,0))
 	i $l(HisDocID) d
 	.s TypeID = $p($g(^CTPCP(HisDocID,3)),"^",29)
 	.i $l(TypeID) d
 	..s TypeData =  $g(^CT("TTL",TypeID))
 	..s TypeCode = $p(TypeData,"^",1)
	..s TypeName = $p(TypeData,"^",2)
	..//判断是否有此code的职称
	..i $d(^dbo.BTPositionTitleI("IndexCode",##Class(LIS.Util.Common).IndexData(TypeCode))) d
	...s PositionTitleRowID = $o(^dbo.BTPositionTitleI("IndexCode",##Class(LIS.Util.Common).IndexData(TypeCode),""))
	...s PositionTitleObj = ##class(dbo.BTPositionTitle).%OpenId(PositionTitleRowID)
	..e  d
	...s PositionTitleObj = ##class(dbo.BTPositionTitle).%New()
	...s PositionTitleObj.Code = TypeCode
	...//默认申请用血量
	...s PositionTitleObj.Volumn=1600
	..s PositionTitleObj.Active = 1
	..s PositionTitleObj.CName = TypeName
	..i PositionTitleObj.Sequence="" s PositionTitleObj.Sequence=1
	..s sc=PositionTitleObj.%Save()
	..i ($SYSTEM.Status.IsOK(sc)) s PositionTitleRowID=PositionTitleObj.RowID
	
	i $l(PositionTitleRowID) d
	.s Userobj.PositionTitleDR = PositionTitleRowID 
	s sc=Userobj.%Save()
 	i ($SYSTEM.Status.IsOK(sc)) s RowID=Userobj.RowID
 	q RowID
}

/// //入参就诊号AdmNo
/// 判断是否含可打印报告
ClassMethod GetIsContainLisReport(AdmNo) As %String
{

    s quitflag=0
    s RequestDate="" f  s RequestDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),RequestDate))  q:((RequestDate="")||(quitflag=1))  d
    .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),RequestDate,VisitNumberDR))  q:((VisitNumberDR="")||(quitflag=1))  d
    ..s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) q:((WorkGroupMachineDR="")||(quitflag=1))  d
    ...s OrderNo="" f  s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo)) q:((OrderNo="")||(quitflag=1))  d
    ....s ReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,"")) 
    ....i $lG($g(^dbo.RPVisitNumberReportD(ReportDR)),22)=3 s quitflag=1 q
    q quitflag
}

// w ##Class(DHCLIS.DHCCommon)GetDoctorDR("001","aa",1)

/// 获取医生DR Do ##class(dbo.BTDoctor).%BuildIndices($ListBuild("IndexCode"))
ClassMethod GetDoctorDR(Code, CName, HospCode) As %String
{
	s Code=$g(Code),HospCode=$g(HospCode)
	s RowID=""
	s Code=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s HospCode=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i $d(^dbo.BTDoctorI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTDoctorI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	.s DoctorObj=##Class(dbo.BTDoctor).%OpenId(RowID)
	e  d
	.s DoctorObj=##Class(dbo.BTDoctor).%New()
	s DoctorObj.Code=Code
	s DoctorObj.CName=CName
	s DoctorObj.HospitalDR=HospitalDR
	s DoctorObj.Active=1
	
 	
 	//处理医生职称的问题 ADD BY SZW 20170417
 	s PositionTitleRowID=""
 	s HisDocID = $O(^CTPCP(0,"Code",Code,0))
 	i $l(HisDocID) d
 	.s TypeID = $p($g(^CTPCP(HisDocID,3)),"^",29)
 	.i $l(TypeID) d
    ..s TypeData =  $g(^CT("TTL",TypeID))
 	..s TypeCode = $p(TypeData,"^",1)
	..s TypeName = $p(TypeData,"^",2)
	..//判断是否有此code的职称
	..i $d(^dbo.BTPositionTitleI("IndexCode",##Class(LIS.Util.Common).IndexData(TypeCode))) d
	...s PositionTitleRowID = $o(^dbo.BTPositionTitleI("IndexCode",##Class(LIS.Util.Common).IndexData(TypeCode),""))
	...s PositionTitleObj = ##class(dbo.BTPositionTitle).%OpenId(PositionTitleRowID)
	..e  d
	...s PositionTitleObj = ##class(dbo.BTPositionTitle).%New()
	...s PositionTitleObj.Code = TypeCode
	...//默认申请用血量
	...s PositionTitleObj.Volumn=1600
	..s PositionTitleObj.Active = 1
	..s PositionTitleObj.CName = TypeName
	..s sc=PositionTitleObj.%Save()
	..i ($SYSTEM.Status.IsOK(sc)) s PositionTitleRowID=PositionTitleObj.RowID
	
	i $l(PositionTitleRowID) d
	.s DoctorObj.PositionTitleDR = PositionTitleRowID
	
	s sc=DoctorObj.%Save()
 	i ($SYSTEM.Status.IsOK(sc)) s RowID=DoctorObj.RowID
	
 	q RowID
}

/// 获取就诊医院DR
ClassMethod GetHospitalDR(Code, CName) As %String
{
	s Code=$g(Code)
	s Code=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s RowID=""
	i $d(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	e  d
	.s obj=##Class(dbo.BTHospital).%New()
	.s obj.Code=Code
	.s obj.CName=CName
	.s obj.FullDesc=CName
	.s obj.Active=1
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

/// 获取就诊科室DR
ClassMethod GetLocationDR(LocID, LocCode, CName, HospitalDR) As %String
{
	s LocID=$g(LocID)
	s LocID=##Class(DHCLIS.DHCCommon).UPPER(LocID)
	s LocCode=##Class(DHCLIS.DHCCommon).UPPER(LocCode)
	s RowID=""
	i $d(^dbo.BTLocationI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(LocCode))) d
	.s RowID=$o(^dbo.BTLocationI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(LocCode),""))
	e  d
	.s obj=##Class(dbo.BTLocation).%New()
	.s obj.Code=LocCode
	.s obj.CName=CName
	.s obj.HISCode=LocID
	.s obj.HospitalDR=HospitalDR
	.s obj.Active=1
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

/// 获取病区DR
ClassMethod GetWardDR(Code, HISCode, CName, LocationDR) As %String
{
	s Code=$g(Code)
	s Code=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s RowID=""
	i $d(^dbo.BTWardI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTWardI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	e  d
	.s obj=##Class(dbo.BTWard).%New()
	.s obj.Code=Code
	.s obj.CName=CName
	.s obj.HISCode=HISCode
	.s obj.LocationDR=LocationDR
	.s obj.Active=1
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

/// 获取就诊类型DR
ClassMethod GetAdmissionTypeDR(Code) As %String
{
	s Code=$g(Code)
	s Code=##Class(DHCLIS.DHCCommon).UPPER(Code)
	s RowID=""
	i $d(^dbo.BTAdmissionTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTAdmissionTypeI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	e  d
	.s obj=##Class(dbo.BTAdmissionType).%New()
	.s obj.Code=Code
	.s obj.AdmType=Code
	.i Code="I" s obj.CName="住院"
	.i Code="O" s obj.CName="门诊"
	.i Code="E" s obj.CName="急诊"
	.i Code="P" s obj.CName="体检"
	.i Code="N" s obj.CName="新生儿"
	.i Code="R" s obj.CName="科研"
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

/// 获取性别DR
ClassMethod GetSpeciesDR(Code) As %String
{
	s Code=$g(Code)
	s RowID=""
	i $d(^dbo.BTSpeciesI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTSpeciesI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	e  d
	.i Code'="M",Code'="F" s Code="O"
	.s obj=##Class(dbo.BTSpecies).%New()
	.s obj.Code=Code
	.i Code="M" s obj.CName="男"
	.e  i Code="F" s obj.CName="女"
	.e  s obj.CName="未知"
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

/// 获取年龄单位DR
ClassMethod GetAgeUnitDR(Code) As %String
{
	s Code=$g(Code)
	s RowID=""
	i $d(^dbo.BTAgeUnitI("IndexCode",##Class(LIS.Util.Common).IndexData(Code))) d
	.s RowID=$o(^dbo.BTAgeUnitI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	e  d
	.s obj=##Class(dbo.BTAgeUnit).%New()
	.s obj.Code=Code
	.s obj.Sequence=1
	.s obj.Active=1
	.i Code="Y" s obj.CName="岁"
	.i Code="M" s obj.CName="月"
	.i Code="D" s obj.CName="天"
	.i Code="H" s obj.CName="小时"
	.s sc=obj.%Save()
 	.i ($SYSTEM.Status.IsOK(sc)) s RowID=obj.RowID
 	q RowID
}

// 报告查询调用

/// 参数说明：入参检验项目代码
/// 输出说明：SpecimenDesc（性别）,AgeRange（年龄参考范围）,ValueLow（数字型参考范围低值）,ValueHigh（数字型参考范围高值）,PanicLow（数字型危机参考范围低值）,PanicHigh（数字型危机参考范围高值）,UnacceptLow（数字型慌淡低值）,UnacceptHigh（数字型慌淡高值）,txtRanges1（检验项目文本参考范围常用与打印）,txtRanges2（检验项目文本型列表型结果标识跟描素）
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QryTCRanges","A0001","","","","","","","","","","","","","","114^10^0^12^1")
Query QryTCRanges(TestCode, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Query(ROWSPEC = "SpecimenDesc,AgeRange,ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh,txtRanges1,txtRanges2")
{
}

ClassMethod QryTCRangesExecute(ByRef qHandle As %Binary, TestCode, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Status
{
	  set TestCode=$g(TestCode)
	
	  Set repid=$i(^CacheTemp)
 	  Set ind=1

	  s RowCount=0
  
	  s RetRanges="",RetDefRanges=""
	  s hospitaldr=$o(^dbo.BTTestCodeI("IndexCode",""))
	  s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",hospitaldr,##Class(LIS.Util.Common).IndexData(TestCode),""))
	  i '$l(TestCodeDR)  Quit $$$OK
	  s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
	  i (ResultFormat="N") d   ///数据类型
	  .s OrderNo="" f  s OrderNo=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo)) q:OrderNo=""  d
	  ..s RowID="" f  s RowID=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo,RowID)) q:RowID=""  d
	  ...s TCRangesData=$g(^dbo.BTTestCodeRangesD(RowID))
	  ...s Ranges=$li(TCRangesData,10,15)
	  ...s ValueLow=$lg(TCRangesData,10)
	  ...s ValueHigh=$lg(TCRangesData,11)
	  ...s PanicLow=$lg(TCRangesData,12)
	  ...s PanicHigh=$lg(TCRangesData,13)
	  ...s UnacceptLow=$lg(TCRangesData,14) 
	  ...s UnacceptHigh=$lg(TCRangesData,15) 
	  ...s SpeciesDR=$lg(TCRangesData,4)
	  ...s AgeLow=$lg(TCRangesData,5)
	  ...s AgeHigh=$lg(TCRangesData,6)
	  ...s AgeRange=AgeLow_"-"_AgeHigh
	  ...s SpecimenDR=$lg(TCRangesData,7)
	  ...S SpecimenDesc=""
	  ...i $L(SpecimenDR) s SpecimenDesc=$LG($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	  ...s ClinicalConditionsDR=$lg(TCRangesData,8)
	  ...s LocationDR=$lg(TCRangesData,9)
	  ...s txtRanges1=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),27)
	  ...s txtRanges2=""
	  ...s RowCount=RowCount+1
	  ...d OutPut
	  ///文本和标准备注参考范围
	  i (ResultFormat="X")||(ResultFormat="S") d
	  .s Code="" f  s Code=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code)) q:Code=""  d
	  ..s txtRanges1=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),27)
	  ..s TCCmtDR="" f  s TCCmtDR=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code,TCCmtDR)) q:TCCmtDR=""  d
	  ...s (SpecimenDesc,AgeRange,ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh,txtRanges2)=""
	  ...s TCCmtData=$g(^dbo.BTTestCodeCommentsD(TCCmtDR))
	  ...s TCCmtDesc=$lg(TCCmtData,4)						
	  ...s TCCmtFlag=$lg(TCCmtData,5)
	  ...s txtRanges2=TCCmtFlag_":"_TCCmtDesc
	  ...s RowCount=RowCount+1
	  ...d OutPut
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
    Set Data=$lb(SpecimenDesc,AgeRange,ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh,txtRanges1,txtRanges2)
	set ColFields="SpecimenDesc,AgeRange,ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh,txtRanges1,txtRanges2"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTCRangesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTCRangesExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTCRangesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTCRangesExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 参数说明：入参检验外部代码
/// 输出说明：SpeciesDesc（性别）,AgeRange（年龄参考范围）,ValueLow（数字型参考范围低值）,ValueHigh（数字型参考范围高值）,PanicLow（数字型危机参考范围低值）,PanicHigh（数字型危机参考范围高值）,UnacceptLow（数字型慌淡低值）,UnacceptHigh（数字型慌淡高值）,txtRanges（检验项目文本型列表型结果标识跟描素）
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QryTestSetRanges","A001","","","","","","","","","","","","","","114^10^0^12^1")
Query QryTestSetRanges(TestSetCode, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Query(ROWSPEC = "TestCode,TestCodeName,Synonym,SpeciesDesc,AgeRange,ValueLow,ValueHigh,txtRanges")
{
}

ClassMethod QryTestSetRangesExecute(ByRef qHandle As %Binary, TestSetCode, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Status
{
	  set TestSetCode=$g(TestSetCode)
	
	  Set repid=$i(^CacheTemp)
 	  Set ind=1

	  s RowCount=0
  
	  s RetRanges="",RetDefRanges=""
	  s hospitaldr=$o(^dbo.BTTestSetI("IndexCode",""))
	  s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",hospitaldr,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
	  i '$l(TestSetDR)  Quit $$$OK
	  s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR)) Q:WorkGroupDR=""  D
	  .s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) Q:TestCodeDR=""  D
	  ..d GetInfo(TestCodeDR)
	  Set qHandle=$lb(0,repid,0)
	  Quit $$$OK
	  
GetInfo(TestCodeDR)
	  s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
	  s TestCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),2)
	  s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
	  s Synonym=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),7)
	  i (ResultFormat="N") d   ///数据类型
	  .s OrderNo="" f  s OrderNo=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo)) q:OrderNo=""  d
	  ..s RowID="" f  s RowID=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo,RowID)) q:RowID=""  d
	  ...s TCRangesData=$g(^dbo.BTTestCodeRangesD(RowID))
	  ...s Ranges=$li(TCRangesData,10,15)
	  ...s ValueLow=$lg(TCRangesData,10)
	  ...s ValueHigh=$lg(TCRangesData,11)
	  ...s SpeciesDR=$lg(TCRangesData,4)
	  ...s AgeLow=$lg(TCRangesData,5)
	  ...s AgeHigh=$lg(TCRangesData,6)
	  ...s AgeRange=AgeLow_"-"_AgeHigh
	  ...s SpecimenDR=$lg(TCRangesData,7)
	  ...S SpecimenDesc=""
	  ...i $L(SpecimenDR) s SpecimenDesc=$LG($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	  ...s SpeciesDesc="" i $l(SpeciesDR) s SpeciesDesc=$LG($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	  ...s ClinicalConditionsDR=$lg(TCRangesData,8)
	  ...s LocationDR=$lg(TCRangesData,9)
	  ...s txtRanges=""
	  ...s RowCount=RowCount+1
	  ...d OutPut
	  ///文本和标准备注参考范围
	  i (ResultFormat="X")||(ResultFormat="S") d
	  .s (SpecimenDesc,AgeRange,ValueLow,ValueHigh,txtRanges)="" 
	  .s Code="" f  s Code=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code)) q:Code=""  d
	  ..s TCCmtDR="" f  s TCCmtDR=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code,TCCmtDR)) q:TCCmtDR=""  d
	  ...s (SpecimenDesc,AgeRange,ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh,txtRanges2)=""
	  ...s TCCmtData=$g(^dbo.BTTestCodeCommentsD(TCCmtDR))
	  ...s TCCmtDesc=$lg(TCCmtData,4)						
	  ...s TCCmtFlag=$lg(TCCmtData,5)
	  ...s txtRanges=""
	  ...i TCCmtFlag ="N",'$l(txtRanges) s txtRanges=TCCmtDesc
	  ...i TCCmtFlag ="N",$l(txtRanges) s txtRanges=txtRanges_","_TCCmtDesc
	  .s RowCount=RowCount+1
	  .d OutPut
	  quit
 	
OutPut
    Set Data=$lb(TestCode,TestCodeName,Synonym,SpeciesDesc,AgeRange,ValueLow,ValueHigh,txtRanges)
	set ColFields="TestCode,TestCodeName,Synonym,SpeciesDesc,AgeRange,ValueLow,ValueHigh,txtRanges"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestSetRangesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetRangesExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetRangesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetRangesExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别F代表女 M代表男,Specimen:标本类型,PatientType:病人类型,Cond:临床条件,Loc,mi
/// 输出ValueLow（数字型参考范围低值）,ValueHigh（数字型参考范围高值）,PanicLow（数字型危机参考范围低值）,PanicHigh（数字型危机参考范围高值）,UnacceptLow（数字型慌淡低值）,UnacceptHigh（数字型慌淡高值）,
/// w ##Class(LISSP.BLL.DHCCommonInterface).GetTCRanges("2",2,1,2,"","","","")
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Specimen As %String = "", PatientType As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "") As %String
{
  Set TestCode=$g(TestCode),Age=$g(Age),Species=$g(Species),Specimen=$g(Specimen),PatientType=$g(PatientType),Cond=$g(Cond),Loc=$g(Loc),mi=$g(mi)
  s hospitaldr=$o(^dbo.BTTestCodeI("IndexCode",""))
  s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",hospitaldr,##Class(LIS.Util.Common).IndexData(TestCode),""))
  s Species=$o(^dbo.BTSpeciesI("IndexCode",Species,"")) //转换成性别主键 
  s RetRanges="",RetDefRanges=""
  i '$l(TestCodeDR) q RetRanges
  s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
  ;if '$l(Age) Set Age=20
  ;If '$l(Species) Set Species="M"
  i (ResultFormat="N") d   ///数据类型
  .s OrderNo="" f  s OrderNo=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo)) q:OrderNo=""  d
  ..s RowID="" f  s RowID=$o(^dbo.BTTestCodeRangesI("IndexMaster",TestCodeDR,OrderNo,RowID)) q:RowID=""  d
  ...s TCRangesData=$g(^dbo.BTTestCodeRangesD(RowID))
  ...s Ranges=$li(TCRangesData,10,15)
  ...s IsDefault=$lg(TCRangesData,16)
  ...i IsDefault,'$l(Age) s RetDefRanges=Ranges
  ...i IsDefault,'$l(Species) s RetDefRanges=Ranges
  ...i '$l(Age) Q
  ...i '$l(Species) Q
  ...s SpeciesDR=$lg(TCRangesData,4)
  ...s AgeLow=$lg(TCRangesData,5)
  ...s AgeHigh=$lg(TCRangesData,6)
  ...s SpecimenDR=$lg(TCRangesData,7)
  ...s ClinicalConditionsDR=$lg(TCRangesData,8)
  ...s LocationDR=$lg(TCRangesData,9)
  ...i $l(SpeciesDR),Species'=SpeciesDR Q
  ...i $l(AgeLow),Age<AgeLow Q
  ...i $l(AgeHigh),Age>AgeHigh Q
  ...i $l(Specimen),$l(SpecimenDR),Specimen'=SpecimenDR Q
  ...i $l(Cond),$l(ClinicalConditionsDR),Cond'=ClinicalConditionsDR Q
  ...i $l(Loc),$l(LocationDR),Loc'=LocationDR Q
  ...s RetRanges=Ranges
  i '$l(RetRanges),$l(RetDefRanges) s RetRanges=RetDefRanges  //返回缺省参考范围
  i (ResultFormat="N") q RetRanges
  
  ///文本和标准备注参考范围
  s (ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)=""
  i (ResultFormat="X")||(ResultFormat="S") d
  .s Code="" f  s Code=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code)) q:Code=""  d
  ..s TCCmtDR="" f  s TCCmtDR=$o(^dbo.BTTestCodeCommentsI("IndexCode",TestCodeDR,Code,TCCmtDR)) q:TCCmtDR=""  d
  ...s TCCmtData=$g(^dbo.BTTestCodeCommentsD(TCCmtDR))
  ...s TCCmtDesc=$lg(TCCmtData,4)						
  ...s TCCmtFlag=$lg(TCCmtData,5)
  ...i TCCmtFlag="N" s ValueLow=TCCmtDesc   ///除去正常范围显示及打印
  ...i TCCmtFlag="A" s PanicLow=PanicLow_TCCmtDesc_"|"
  ...i TCCmtFlag="S" s UnacceptLow=UnacceptLow_TCCmtDesc_"|"
  .s RetRanges=$lb(ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)
  Q RetRanges
}

/// Function: 根据登记号查报告信息
/// CreateDate: 2014/11/18
/// Table:     ARC_ItmMast
/// P1代码,P2描述,P3药物查找,P4别名,P5记账组,P6记账子组,P7医嘱子类,P8服务组,P9收费规定
/// Debugs:    d ##class(%ResultSet).RunQuery("DHCLIS.DHCOrderListSearch","QryItmByRegNo","123")
Query QryItmByRegNo(RegNo As %String) As %Query(ROWSPEC = "test_type,grbh,test_id,test_name,test_time,reviewer")
{
}

ClassMethod QryItmByRegNoExecute(ByRef qHandle As %Binary, RegNo As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1

 s ReqDate="" f  s ReqDate=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),ReqDate)) q:ReqDate=""  d
 .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),ReqDate,VisitNumberDR)) q:VisitNumberDR=""  d 
 ..d GetInfoFast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
GetInfoFast
    s gdata=$g(^dbo.RPVisitNumberD(VisitNumberDR)) 
    s Labno=$lg(gdata,2)
    s RegNo=$lg(gdata,3)	 
    s TestSetDesc=""
	s fTestSetDR="" f  s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,fTestSetDR)) q:(fTestSetDR="")  d
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(fTestSetDR),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(fTestSetDR),3)	
    s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	.s WorkGroupMachine=$LG($G(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)
	.s RptOrder=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGroupMachineDR,""),-1) 
	.i '$l(RptOrder) Quit  ///只查询本工作组医嘱
	.s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGroupMachineDR,RptOrder,""))
	.s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	.s EpisodeNo=$lg(ReportData,8)
	.s Status=$lg(ReportData,22)
	.q:Status'=3
 	.s AuthDate=$lg(ReportData,19)
 	.s AuthTime=$lg(ReportData,20)
 	.s AuthUserDR=$lg(ReportData,21) s AuthUser=""
 	.i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
 	.i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)	
 	.d OutputRow
 	Quit
 	
OutputRow
    set Data=$lb(1,RegNo,Labno,TestSetDesc,AuthDate,AuthUser)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryItmByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItmByRegNoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QryItmByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItmByRegNoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 根据申请单号获取血液信息
/// w ##Class(DHCLIS.DHCCommon).GetBloodInfoByReqNo("20161115001")
/// return: 血制品Code^血制品Name^数量^单位^是否辐照(0或1)^备注^用血信息RowID@……
ClassMethod GetBloodInfoByReqNo(ReqFromNo)
{
	s ReqFromNo=$g(ReqFromNo)
	i '$l(ReqFromNo) q ""
	s ReqformDR = $o(^dbo.BDReqFormI("IndexReqFormNo",##Class(LIS.Util.Common).IndexData(ReqFromNo),""))
	i '$l(ReqformDR) q ""
	s RetStr=""
	s ReqProductDR = ""
	for {
		s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqformDR,ReqProductDR))
		q:ReqProductDR=""
		s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",ReqformDR,ReqProductDR,""))
		s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
		s Volumn = $lg(ReqFormProductData,5)
		s Unit = $lg(ReqFormProductData,6)
		s SpecialNeed = $lg(ReqFormProductData,7)
		s IsIrradiation = 0
		i SpecialNeed["辐照" s IsIrradiation=1
		s ReqProductCode = $lg($g(^dbo.BBReqProductD(ReqProductDR)),2)
		s ReqProductName = $lg($g(^dbo.BBReqProductD(ReqProductDR)),3)
		s OneItemStr=ReqProductCode_"^"_ReqProductName_"^"_Volumn_"^"_Unit_"^"_IsIrradiation_"^"_""_"^"_ReqFormProductDR
		s RetStr = $s($l(RetStr):RetStr_"@"_OneItemStr,1:OneItemStr)
	}
	q RetStr
}

/// ADD BY SZW
/// 查询lis微生物手工计费的arc_itmmast的RowID
/// 输出格式ID1^ID2^ID3……
/// w ##Class(DHCLIS.DHCCommon).GetMICManualOrder("6")
ClassMethod GetMICManualOrder(WorkGroupDR)
{
	i $l(WorkGroupDR)
	s ParameterDR = $o(^dbo.SYSParameterI("IndexCode"," HISTESTSET"," WG"," "_WorkGroupDR,""))
	s ParameterData = $g(^dbo.SYSParameterD(ParameterDR))
	s OrderStr= $lg(ParameterData,6)
	s i =1
	s RetStr=""
	for {
		q:i>$l(OrderStr,"},{")
		s OneItemStr=$p(OrderStr,"},{",i)
		s i = i+1
		i '$l(OneItemStr) continue
		s OrderID = $P(OneItemStr,"""",4)
		s RetStr = $s($l(RetStr):RetStr_"^"_OrderID,1:OrderID)
	}
	q RetStr
}

/// 入参:检验号
/// 出参是否存在未审核报告
/// w ##Class(DHCLIS.DHCCommon).GetIsExsistUnAuthReport("1704140001")
ClassMethod GetIsExsistUnAuthReport(Labno As %String)
{
	s ret=0 //默认全部审核
	i '$l(Labno) q "检验号不存在"
	s OrdId=$o(^OEORD(0,"EpisNo",Labno,""))
	i '$l(OrdId) q "检验号不存在"
    s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(Labno),"")) 
    i VisitNumberDR="" q "1"
    s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:((TestSetDR="")||(ret=1))  d
	.s LabTestSetRow=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	.i WorkGroupMachineDR="" s ret=1 q
	.s orderno=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	.s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,orderno,""))
	.S Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
	.i Status'=3 s ret=1 q //未审核可打印
	q ret
}

/// Creator：      liuzf
/// CreatDate：    20170605
/// Description:： 根据外部代码返回是否是微生物医嘱
/// Table：        
/// Input：        外部代码，医院代码
/// Return：       0：不是，1：微生物医嘱
/// Other:  w ##Class(DHCLIS.DHCCommon).CheckBugTS("E015")
ClassMethod CheckBugTS(TestSetCode, HospitalCode)
{
	s TestSetCode=$g(TestSetCode),HospitalCode=$g(HospitalCode)
	s ret=0
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ret
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
	i '$l(TestSetDR) q ret

	s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR)) q:(WorkGroupDR="")||(ret=1)  d
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) q:(TestCodeDR="")||(ret=1)  d
	..s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
	..i ResultFormat="M" s ret=1 q
	q ret
}

/// 入参就诊号AdmNo
/// 获取危机值标记Flag：1有 其它无
/// ##Class(DHCLIS.DHCCommon).GetIsPanicFlag(492)
ClassMethod GetIsPanicFlag(AdmNo) As %String
{
    s Flag=0
    s ReqtDate="" f  s ReqtDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqtDate))  q:((ReqtDate="")||(Flag=1))  d
    .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqtDate,VisitNumberDR))  q:((VisitNumberDR="")||(Flag=1))  d
    ..i $d(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR)) s Flag=1 q
    q Flag
}

/// 通过外部代码获取采集容器代码和所属工作组
/// d ##Class(DHCLIS.DHCCommon).GetContainerAndWG("S0022","SP004","DHSZHYYZY")
/// 返回：容器DR_"^"_容器Code_"^"_容器Desc_"^"_容量_"^"_颜色_"^"_说明_"^"_工作组DR_"^"_工作组Name
ClassMethod GetContainerAndWG(TSCode, SpecCode, HospitalCode) As %String
{
	s SpecCode=$g(SpecCode),HospitalCode=$g(HospitalCode)
	i '$l(SpecCode) q ""
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	i '$l(HospitalDR) q ""
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i $l(LnkHospDR),'$l(SpecimenDR) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",LnkHospDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	i '$l(SpecimenDR) q ""
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TSCode),""))
	i '$l(TestSetDR) {
		s HospID=""
		for {
			s HospID = $o(^dbo.BTHospitalD(HospID))
			q:HospID=""
			i $d(^dbo.BTTestSetI("IndexCode",HospID,##Class(LIS.Util.Common).IndexData(TSCode))) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospID,##Class(LIS.Util.Common).IndexData(TSCode),""))
		}		
	}
	i '$l(TestSetDR) q ""
	s WorkGroupMachineDR =$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR,""))
	i '$l(WorkGroupMachineDR) q ""
	s WGMData=$g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR))
	s WGDR=$lg(WGMData,4)
	s WGName=$lg($g(^dbo.BTWorkGroupD(WGDR)),3)
	s TSSpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,""))
	i '$l(TSSpecimenDR) q ""
	s ContainerDR=$lg($g(^dbo.BTTestSetSpecimenD(TSSpecimenDR)),4)
	i '$l(ContainerDR) q ""
	s BarCodeNumber=+$lg($g(^dbo.BTTestSetSpecimenD(TSSpecimenDR)),5)
	s ContainerCode=$lg($g(^dbo.BTContainerD(ContainerDR)),2)
	s ContainerDesc=$lg($g(^dbo.BTContainerD(ContainerDR)),3)
	s Volumn=$lg($g(^dbo.BTContainerD(ContainerDR)),5)
	s Color=$lg($g(^dbo.BTContainerD(ContainerDR)),6)
	s Notes=$lg($g(^dbo.BTContainerD(ContainerDR)),7)
	q ContainerDR_"^"_ContainerCode_"^"_ContainerDesc_"^"_Volumn_"^"_Color_"^"_Notes_"^"_WGDR_"^"_WGName
}

/// 通过外部代码获取采集容器代码和所属工作组
/// d ##Class(DHCLIS.DHCCommon).GetReportAuthDate("1222||11")
ClassMethod GetReportAuthDate(HISOrderID) As %String
{
 	  
    S HISOrderID=$G(HISOrderID)
    s RetVal=""
    I '$L(HISOrderID)  Q RetVal
    s OrdID=$P(HISOrderID,"||",1)
    s OrdSubID=$P(HISOrderID,"||",2)
    Set temstr=$G(^OEORD(ORDID,"I",ORDSUB,3))
 	Set VisitNumberTestSetDR=$Piece(temstr,"^",35)
 	Set VisitNumberTestSetDR=$tr(VisitNumberTestSetDR,$c(0))
	If '$l(VisitNumberTestSetDR)  Quit RetVal
	s ReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),11)
	If '$l(ReportDR)  Quit RetVal
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
	i $l(AuthTime) s AuthTime=$zt(AuthTime,1)
	i $l(AuthDate) s RetVal=AuthDate_"^"_AuthTime
	q RetVal
}

/// 入参报告ID：ReportDR
/// 获取报告备注
/// ##Class(DHCLIS.DHCCommon).GetReportRemark(492)
ClassMethod GetReportRemark(ReportDR) As %String
{
	i '$l(ReportDR) q ""
	s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	i '$l(ReportData)	q ""
	s MajorConclusion=$lg(ReportData,40)
    q MajorConclusion
}

/// 入参报告ID：ReportDR
/// 获取报告打印状态 1 已打印 其他未打印
/// ##Class(DHCLIS.DHCCommon).GetReportPrintStatus(492)
ClassMethod GetReportPrintStatus(ReportDR) As %String
{
	i '$l(ReportDR) q ""
	s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	i '$l(ReportData)	q ""
	s Printed=$lg(ReportData,30)
    q Printed
}

/// 获取临床输血serverIP,可配置http,考虑维护https情况
ClassMethod GetCTSServer() As %String
{
    s ParaValue=""
    s ParameterDR = $o(^dbo.SYSParameterI("IndexCode"," CTSSERVER"," SYS"," DHCC",""))
	i $l(ParameterDR)  d
	.s ParameterData = $g(^dbo.SYSParameterD(ParameterDR))
	.s ParaValue= $lg(ParameterData,5)
	q ParaValue
}

/// 获取临床输血电子病历知情同意书模板id
ClassMethod GetDocIDMTHD(HospitalCode, AdmNo) As %String
{
    s ParaValue="",HospitalCode=$g(HospitalCode),AdmNo=$G(AdmNo),AdmType="",HospitalDR=""
    I HospitalCode="" Q ""
    s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
    i $L(AdmNo) S AdmType=$P($G(^PAADM(AdmNo)),"^",2)
    //分院区及就诊类型 新版本维护
    i $L(HospitalDR),$L(AdmType) d
    .i AdmType="E" S AdmType="O"
    .s ParameterDR = $o(^dbo.SYSParameterI("IndexCode"," DOCID"_AdmType," HOS"," "_HospitalDR,""))
	.i $l(ParameterDR)  d
	..s ParameterData = $g(^dbo.SYSParameterD(ParameterDR))
	..s ParaValue= $lg(ParameterData,5)
    //兼容老版本维护
    i ParaValue="" d
    .s THospitalCode=$zcvt(HospitalCode,"U")
    .s ParameterDR = $o(^dbo.SYSParameterI("IndexCode"," DOCID"," SYS"," "_HospitalCode,""))
	.i $l(ParameterDR)  d
	..s ParameterData = $g(^dbo.SYSParameterD(ParameterDR))
	..s ParaValue= $lg(ParameterData,5)
	//若未从维护取到值，则依据病历接口获取
	i ParaValue="" s ParaValue=##Class(EMRservice.HISInterface.Event.BloodTransfusion).GetInformedConsentDocID()	
	q ParaValue
}

/// 参数说明：入参检验外部代码,医院代码
/// 输出说明：项目代码、项目名称、项目缩写、标准码
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCCommon","QryTestSetTC","A001","","","","","","","","","","","","","","")
Query QryTestSetTC(TestSetCode, HospitalCode, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Query(ROWSPEC = "TestCode,TestCodeName,Synonym,SCode")
{
}

ClassMethod QryTestSetTCExecute(ByRef qHandle As %Binary, TestSetCode, HospitalCode, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, Output RowCount As %String) As %Status
{
	set TestSetCode=$g(TestSetCode),HospitalCode=$g(HospitalCode)

	Set repid=$i(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	s RowCount=0
	s TestSetCode=##Class(LIS.Util.Common).IndexData(TestSetCode)
	s HospitalCode=##Class(LIS.Util.Common).IndexData(HospitalCode)
  	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",HospitalCode,""))
	i '$l(HospitalDR) s HospitalDR=$o(^dbo.BTTestSetI("IndexCodeHosp",TestSetCode,""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	//根据医院获取基础数据关联医院 20181020 huhm
	s LnkHospDR=$lg(^dbo.BTHospitalD(HospitalDR),12)
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,TestSetCode,""))
	i $l(LnkHospDR),'$l(TestSetDR) s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",LnkHospDR,TestSetCode,""))

	i '$l(TestSetDR)  Quit $$$OK
	s WorkGroupDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),22) //取默认工作组  默认没有，取关联第一个
	i '$l(WorkGroupDR) s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,""))
	i '$l(WorkGroupDR)  Quit $$$OK

	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) Q:TestCodeDR=""  D
	.s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	.s ResultFormat=$lg(TestCodeData,9)
	.s TestCode=$lg(TestCodeData,2)
	.s TestCodeName=$lg(TestCodeData,3)
	.s Synonym=$lg(TestCodeData,7)
	.s SCode=$lg(TestCodeData,14)
	.d OutPut
	Quit $$$OK
 	
OutPut
    Set Data=$lb(TestCode,TestCodeName,Synonym,SCode)
	set ColFields="TestCode,TestCodeName,Synonym,SCode"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestSetTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetTCExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetTCExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
