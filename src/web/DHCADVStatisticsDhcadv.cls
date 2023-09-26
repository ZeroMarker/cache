Import SQLUser

/// Creator: 	Qiaoqingao
/// CreateDate: 2017-12-14
/// Descript: 	不良事件统计
Class web.DHCADVStatisticsDhcadv Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 报告类型combobox数据获取(DHC_MedAdrRepEvent表)
/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetRepotType()
ClassMethod JsonGetRepotType(HospId = "")
{
	n (HospId,%session)
	s Pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid)
	;s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid,1)="0^全部"
	s AdrEvtDr=0,Count=0
	f  s AdrEvtDr = $o(^DHCMEDADREVT(AdrEvtDr)) q:AdrEvtDr=""  d
	.s Sub=0 
	.f  s Sub = $o(^DHCMEDADREVTI(AdrEvtDr,"MADREVI",Sub)) q:Sub=""  d
	..s ReportTypeCode = $p(^DHCMEDADREVTI(AdrEvtDr,"MADREVI",Sub),"^",1)
	..Q:(ReportTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(ReportTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..s Count=Count+1
	..s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid,Count)= ReportTypeCode
	.i '$d(^DHCMEDADREVTI(AdrEvtDr,"MADREVI")) d
	..s ReportTypeCode = $P($g(^DHCMEDADREVT(AdrEvtDr)),"^",1)
	..s Count=Count+1
	..s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid,Count)= ReportTypeCode
	
	s Count=0
	w "["
	S AllType=##class(websys.Translation).Get("dhcadv.statisticsdhcadv.csp","全部")
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","0^"_AllType)
	s Index=""
	f  s Index = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid,Index)) q:Index=""  d
	.s ReportTypeCode = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid,Index)	
	.q:ReportTypeCode'["adv"
	.Q:(ReportTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(ReportTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	.s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(ReportTypeCode),""))
	.q:+FormNameDr=0
	.s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	.q:ForNameType'="Y"
	.s ForNameDesc = $lg(^User.DHCAdvFormNameD(FormNameDr),3)
	.s ForNameDesc = ##class(web.DHCADVCOMMONPART).GetReportEasyName(ForNameDesc)
	.S ForNameDesc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormName","name","",ForNameDesc)
	.s RsDate = FormNameDr_"^"_ForNameDesc
	.s Count = Count+1
	.w $case(Count,0:"",:",")
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	w "]"
	
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetRepotType",Pid)
	q ""
}

/// 报告类型combobox数据获取(DHC_MedAdrRepEvent表)
/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetRepotType()
ClassMethod JsonGetRepotTypeAnZhen()
{
	s AdrEvtDr=0,Count=0
	w "["
	w $case(Count,0:"",:",")
	s Count = Count+1
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","0^全部")
	f  s AdrEvtDr = $o(^DHCMEDADREVT(AdrEvtDr)) q:AdrEvtDr=""  d
	.s ReportTypeID = AdrEvtDr
	.s ReportTypeCode = $P($g(^DHCMEDADREVT(AdrEvtDr)),"^",1)
	.q:ReportTypeCode'["adv"
	.s ReportTypeName = $P($g(^DHCMEDADREVT(AdrEvtDr)),"^",2)
	.s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(ReportTypeCode),""))
	.q:+FormNameDr=0
	.s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	.q:ForNameType'="Y"
	.s ForNameDesc = $lg(^User.DHCAdvFormNameD(FormNameDr),3)
	.s ForNameDesc = ##class(web.DHCADVCOMMONPART).GetReportEasyName(ForNameDesc)
	.s RsDate = FormNameDr_"^"_ForNameDesc
	.w $case(Count,0:"",:",")
	.s Count = Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	.i ForNameDesc["压疮" d
	..s RsDate = FormNameDr_"*1"_"^"_ForNameDesc_"(院内发生)"
	..w $case(Count,0:"",:",")
	..s Count = Count+1
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	..s RsDate = FormNameDr_"*2"_"^"_ForNameDesc_"(院外带入)"
	..w $case(Count,0:"",:",")
	..s Count = Count+1
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
    .i ForNameDesc["跌倒" d
	..s RsDate = FormNameDr_"*1"_"^"_ForNameDesc_"(跌倒类型)"
	..w $case(Count,0:"",:",")
	..s Count = Count+1
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	..s RsDate = FormNameDr_"*2"_"^"_ForNameDesc_"(坠床类型)"
	..w $case(Count,0:"",:",")
	..s Count = Count+1
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	w "]"
	q ""
}

/// 报告类型combobox数据获取(DHC_AdvFormName)
/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetFormNameType()
ClassMethod JsonGetFormNameType()
{
	s FormCatDr=0,Count=0
	
	s FormCatDr = $o(^User.DHCAdvFormCatI("IndexCode","DHCADV",FormCatDr))   //不良事件类型的ID
	s Count=0
	w "["
	s FormNameDr=0
	f  s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCat",FormCatDr,FormNameDr)) q:FormNameDr=""  d
	.s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	.q:ForNameType'="Y"
	.s ForNameDesc = $lg(^User.DHCAdvFormNameD(FormNameDr),3)
	.s RsDate = FormNameDr_"^"_ForNameDesc
	.w $case(Count,0:"",:",")
	.s Count = Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsDate)
	w "]"
	q ""
}

// 	^DHCADVSTF(0,"FormNameDic",{STF_FormName_Dr},{STF_FormDic_Dr},{STF_RowID})

/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetComboDataForStatField(982)
ClassMethod JsonGetComboDataForStatField(FormNameID)
{
	n (FormNameID)
	q:FormNameID="" "[]"
	///当为全部的时候XY过滤方法不相同
	i FormNameID=0 d
	.d ##class(web.DHCADVStatisticsDhcadv).JsonAllDataCombo()
	
	q:FormNameID=0 ""
	
	s Count=0
	w "["
	s FormDicID =""
	f  s FormDicID = $o(^DHCADVSTF(0,"FormNameDic",FormNameID,FormDicID)) q:FormDicID=""  d  //获取FormName下所有元素
	.s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicID),4)	   //元素描述
	.s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicID),6)   //父元素ID
	.s IsTableFlag =##class(web.DHCADVSetAdvStatFied).GetIsTableItm(FormDicID)
	.s:IsTableFlag'=0 DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)_":"_DicDesc
	.s:(+DicParef'=0)&&(IsTableFlag=0) DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.s RsData = FormDicID_"^"_DicDesc
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsData)
	
	s STFVID=""
	f  s STFVID = $o(^DHCADVSTFV(0,"FormName",FormNameID,STFVID)) q:STFVID=""  d
	.s DicDesc =$p(^DHCADVSTFV(STFVID),"^",3)
	.s FormDicID =$p(^DHCADVSTFV(STFVID),"^",2)
	.s RsData = FormDicID_"^"_STFVID_"#"_DicDesc
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value#text",RsData,"#")	
	
	w "]"
	q ""
}

/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetComboDataForStatField(982)
ClassMethod JsonGetComboDataForStatFieldNoDate(FormNameID)
{
	n (FormNameID)
	q:FormNameID="" "[]"
	
	///当为全部的时候XY过滤方法不相同
	i FormNameID=0 d
	.d ##class(web.DHCADVStatisticsDhcadv).JsonAllDataCombo()
	
	q:FormNameID=0 ""
	
	s Count=0
	w "["
	s FormDicID =""
	f  s FormDicID = $o(^DHCADVSTF(0,"FormNameDic",FormNameID,FormDicID)) q:FormDicID=""  d  //获取FormName下所有元素
	.s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicID),4)	   //元素描述
	.s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicID),6)   //父元素ID
	.s IsTableFlag =##class(web.DHCADVSetAdvStatFied).GetIsTableItm(FormDicID)
	.s:IsTableFlag'=0 DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)_":"_DicDesc
	.s:(+DicParef'=0)&&(IsTableFlag=0) DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.s DicStyle = $lg(^User.DHCAdvFormDicD(FormDicID),3)
	.s RsData = FormDicID_"^"_DicDesc
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsData)
	
	w "]"
	q ""
}

/// 初始化Column的数据
/// w ##class(web.DHCADVStatisticsDhcadv).InitColumnData()
ClassMethod InitColumnData()
{
	s Pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData")      //存放columns
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid)
	s AdrEvtDr=0,Count=0
	f  s AdrEvtDr = $o(^DHCMEDADREVT(AdrEvtDr)) q:AdrEvtDr=""  d
	.s Sub=0 
	.f  s Sub = $o(^DHCMEDADREVTI(AdrEvtDr,"MADREVI",Sub)) q:Sub=""  d
	..s ReportTypeCode = $p(^DHCMEDADREVTI(AdrEvtDr,"MADREVI",Sub),"^",1)
	..s Count=Count+1
	..s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid,Count)= ReportTypeCode
	.i '$d(^DHCMEDADREVTI(AdrEvtDr,"MADREVI")) d
	..s ReportTypeCode = $P($g(^DHCMEDADREVT(AdrEvtDr)),"^",1)
	..s Count=Count+1
	..s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid,Count)= ReportTypeCode
	
	s Index="",Count=0
	f  s Index = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid,Index)) q:Index=""  d
	.s ReportTypeCode = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid,Index)	
	.q:ReportTypeCode'["adv"
	.s FormNameDr = $o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(ReportTypeCode),""))
	.q:+FormNameDr=0
	.s ForNameType = $lg(^User.DHCAdvFormNameD(FormNameDr),6)  //type
	.q:ForNameType'="Y"
	.d ##class(web.DHCADVStatisticsDhcadv).JsonGetAllItmByFormID(FormNameDr)
	
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","InitColumnData",Pid)
	q "Columns加载完毕"
}

/// 统计数据获取Columns(新)
/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetAllItmByFormID(982)
ClassMethod JsonGetAllItmByFormID(ForNameID)
{
	n (ForNameID)
	s Number=0
	w:ForNameID="" "[]"
	q:ForNameID="" ""
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid)
	s Version = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,""),-1)  //获取最后一个版本号
	s Del="""",Count=0
	s FormID=0
	f  s FormID = $o(^User.DHCAdvFormI("IndexNameVersion",ForNameID,Version,FormID)) q:FormID=""  d
	.s FormType = $lg(^User.DHCAdvFormD(FormID),7)
	.q:FormType'="element"
	.s FormDicDr = $lg(^User.DHCAdvFormD(FormID),4)
	.;b:FormDicDr=93374 ;err
	.q:FormDicDr="" 
	.s HasChild = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(FormDicDr)  
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicDr)   
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型  
	.q:(DicStyle="panel")   		//panel 元素不显示                            
	.q:(DicStyle="label")&&(HasChild=0)    //过滤掉label,并且没有子元素
	.i (DicStyle="label")&&(HasChild'=0) d //有子元素,获取子元素信息
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.i (DicStyle="table")&&(HasChild'=0) d //table元素中获取子元素
	..d ##class(web.DHCADVSetAdvStatFied).JsonChildDic(pid,FormDicDr)  //临时globle存储数据
	.;b:FormDicDr=93374 ;err1
	.s ^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicDr)=""
	//循环获取数据
	s Count=0
	s FormDicID=""
	f  s FormDicID = $o(^TMP("DHCADV","web.DHCADVSetAdvStatFied","JsonListGetAllItmByFormID",pid,FormDicID)) q:FormDicID=""  d
	.;b:FormDicID=93374 ;err2
	.;q:$d(^DHCADVSTF(0,"FormNameDic",ForNameID,FormDicID))'=0   //公共部分 qqa 2018-12-12
	.s DicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(FormDicID)
	.s DicField = $p(DicInfo,"^",2)   //唯一标示
	.s DicStyle= $p(DicInfo,"^",3)	   //元素类型
	.s DicDesc= $p(DicInfo,"^",4)	   //元素描述
	.s DicUrl= $p(DicInfo,"^",5)	   //元素路径
	.s DicParef  = $p(DicInfo,"^",6)  //父元素ID
	.;b:FormDicID=93374 ;err3
	.;q:(DicStyle="radio")&&(+DicParef'=0)   //MMP,radio子项目是否显示
	.q:$$ALPHAUP^SSUTIL4(DicDesc)=""
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="1"
	.q:$$ALPHAUP^SSUTIL4(DicDesc)="2"
	.q:DicField["UlcerPart"
	.s IsTableFlag =##class(web.DHCADVSetAdvStatFied).GetIsTableItm(FormDicID)
	.;描述是否带父元素
	.s:IsTableFlag'=0 DicDesc = ##class(web.DHCADVEXPFIELD).GetTableDicParef(FormDicID)_":"_DicDesc	   //描述是父元素+子元素的格式
	.s:(+DicParef'=0)&&(IsTableFlag=0) DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc     //描述是父元素+子元素的格式
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	..b:FormDicID=93374 ;err4
	.s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),DicField) = DicDesc	
	.
	s FormNameDesc = $lg(^User.DHCAdvFormNameD(ForNameID),3)
	q:FormNameDesc'["压疮报告单"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerOccurReason-94948") = "患者因素"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerOccurReason-94949") = "病情因素"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerOccurReason-94950") = "护理人员因素"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerOccurReason-94951") = "其他因素"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerPart-95158-95162") = "压疮部位:发现日期"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerPart-95158-95166") = "压疮部位:部位"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerPart-95158-95163") = "压疮部位:病人来源"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerPart-95158-95169") = "压疮部位:分期"
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,$i(Number),"UlcerPart-95158-95189") = "压疮部位:面积"

	q ""
}

/// w ##class(web.DHCADVStatisticsDhcadv).GetColumnsByFormNameID(993)
/// UpdateLog:
/// 	2018-11-20:增加返回一个类型
ClassMethod GetColumnsByFormNameID(ForNameID)
{
	n (ForNameID)
	s ForNameID=+ForNameID
	w "["
	s Count=0
	s Number=0
	f  s Number = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,Number)) q:Number=""  d
	.s DicField=""
	.f  s DicField = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,Number,DicField)) q:DicField=""  d
	..s DicDesc = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonGetAllItmByFormID","ColumnData",ForNameID,Number,DicField)
	..s FormDicID = $o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(DicField),""))
	..s Type = ""
	..s ItmList = ##class(web.DHCADVStatisticsDhcadv).GetItmList(FormDicID) 
	..s:DicDesc["日期" Type="dateTime"   //日期格式：全部类型没有走后台，需在js中判断
	..s:ItmList'="" Type="radioParef"
	..w $case(Count,0:"",Count:",")
	..s DymObj={}
	..
	..s DymObj.field = DicField
	..s DymObj.title = DicDesc
	..s DymObj.align = "left"
	..s DymObj.type = Type
	..s DymObj.itmList = ItmList
	..w DymObj.%ToJSON()
	..s Count=Count+1
	w "]"
	q ""
}

/// Descript:这个方法用于获取radio的统计，在选取x/y时将所有子项都显示出来
/// w ##class(web.DHCADVStatisticsDhcadv).GetItmList(93425)
ClassMethod GetItmList(ParRefID)
{
	n (ParRefID)
	s Ret=""
	q:+ParRefID=0 ""
	s ParRefIDField=$lg(^User.DHCAdvFormDicD(ParRefID),2)
	;q:ParRefIDField="UlcerPart-95158-95166" "枕部^耳廓^耳廓(左)^耳廓(右)^肩胛部^肩胛部(左)^肩胛部(右)^肘部^肘部(左)^肘部(右)^髂前上棘^髂前上棘(左)^髂前上棘(右)^髋部^髋部(左)^髋部(右)^骶尾部^骶尾部(左)^骶尾部(右)^膝部^膝部(左)^膝部(右)^踝部^踝部(左)^踝部(右)^足跟部^足跟部(左)^足跟部(右)"
	q:ParRefIDField="UlcerPart-95158-95166" "枕部^骶尾部^耳廓(左)^耳廓(右)^肩胛部(左)^肩胛部(右)^肘部(左)^肘部(右)^髂前上棘(左)^髂前上棘(右)^髋部(左)^髋部(右)^膝部(左)^膝部(右)^踝部(左)^踝部(右)^足跟部(左)^足跟部(右)^其他"
	q:ParRefIDField="UlcerPart-95158-95163" "院内发生^院外带入(家庭)^院外带入(其他医疗机构)^院外带入(养老院)^院外带入(其它)"
	
	s FormDicID=""
	b ;err
	f  s FormDicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_ParRefID,FormDicID)) q:FormDicID=""  d
	.s Style=$lg(^User.DHCAdvFormDicD(FormDicID),3)
	.s HidValue = $lg(^User.DHCAdvFormDicD(FormDicID),4)
	.q:(Style'["radio")&&(Style'["checkbox")  //存在radio-input情况
	.s:Ret'="" Ret=Ret_"^"_HidValue
	.s:Ret="" Ret=HidValue
	q Ret
}

///  占时写死
/// w ##class(web.DHCADVStatisticsDhcadv).JsonAllDataCombo()
ClassMethod JsonAllDataCombo()
{
	w "["
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","1^报告状态")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","2^报告日期")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","3^病案号")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","4^姓名")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","5^性别")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","6^年龄")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","7^报告类型")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","8^发生日期")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","9^发生科室")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","10^报告科室")
	w ","
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text","11^报告人")
	w "]"
	q ""
}

/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetComboData(982)
ClassMethod JsonGetComboData(FormNameID)
{
	n (FormNameID)
	q:FormNameID="" "[]"
	///当为全部的时候XY过滤方法不相同
	i FormNameID=0 d
	.d ##class(web.DHCADVStatisticsDhcadv).JsonAllDataCombo()
	q:FormNameID=0 ""
	s Count=0
	w "["
	s FormDicID =""
	f  s FormDicID = $o(^DHCADVSTF(0,"FormNameDic",FormNameID,FormDicID)) q:FormDicID=""  d  //获取FormName下所有元素
	.s DicDesc= $lg(^User.DHCAdvFormDicD(FormDicID),4)	   //元素描述
	.s DicParef  = $lg(^User.DHCAdvFormDicD(FormDicID),6)   //父元素ID
	.s:+DicParef'=0 DicDesc = $lg(^User.DHCAdvFormDicD(DicParef),4)_":"_DicDesc
	.s:$p(DicDesc,":",1)="1" DicDesc = "压疮部位:"_$p(DicDesc,":",2)
	.s RsData = FormDicID_"^"_DicDesc
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value^text",RsData)
	
	s STFVID=""
	f  s STFVID = $o(^DHCADVSTFV(0,"FormName",FormNameID,STFVID)) q:STFVID=""  d

	
	w "]"
	q ""
}

/// 获取列头
/// w ##class(web.DHCADVStatisticsDhcadv).GetColumn(93392)
ClassMethod GetColumn(FormDicID)
{
	n (FormDicID)
	q:+FormDicID=0 ""
	s ColumObj = {}   //这个对象
	s ColumStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(FormDicID)   //DicID串串
	s ColumLen = $l(ColumStr,"^")
	s Count=0
	w "[["
	s ColumObj.title=""
	s ColumObj.field="first"   ;这个位置预留出来
	s ColumObj.width="100"
	w ColumObj.%ToJSON()
	s Count = Count+1
	f i=1:1:ColumLen d
	.s ColumObj={}
	.s ColumDicID = $p(ColumStr,"^",i)
	.s ColumDicInfo = ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(ColumDicID)
    .s ColumObj.title=$p(ColumDicInfo,"^",4)
    .q:$$ALPHAUP^SSUTIL4(ColumObj.title)=""    //名称不可能为空
    .s ColumObj.field=$p(ColumDicInfo,"^",2)
	.w $case(Count,0:"",:",")
	.s Count = Count+1
	.w ColumObj.%ToJSON()
	w "]]"
	q ""
}

/// ret:元素ID^元素ID^元素ID^元素ID...(有子元素返回子元素串串，没有返回自己)
/// 获取子元素内容(只取子元素,不管孙子元素)
/// w ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(93908)
ClassMethod GetChildInfo(FormDicID)
{
	n (FormDicID)
	;w ##class(web.DHCADVSetAdvStatFied).GetDicItmInfo(94247)  获取子元素的信息
	
	s FormParefDic= $lg(^User.DHCAdvFormDicD(FormDicID),6)  
	i +FormParefDic'=0 d
	.s FormParefParefDic = $lg(^User.DHCAdvFormDicD(FormParefDic),6) 
	.i +FormParefParefDic'=0 d
	..s DicType = $lg(^User.DHCAdvFormDicD(FormParefParefDic),3)
	..i DicType="table" d
	...s FormDicID = ##class(web.DHCADVStatisticsDhcadv).GetTableDic(FormParefParefDic,FormDicID)
	
	q:FormDicID="" ""
	s HasChild = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(FormDicID)
	q:+HasChild=0 FormDicID     //没有子元素
	
	s ret=""
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s:ret'="" ret= ret_"^"_DicID
	.s:ret="" ret = DicID
	
	q ret
}

/// ret:元素ID^元素ID^元素ID^元素ID...(返回值包括自己)
/// 获取子元素内容(只取子元素,不管孙子元素)
/// w ##class(web.DHCADVStatisticsDhcadv).GetChildInfoHasI(93392)
ClassMethod GetChildInfoHasI(FormDicID)
{
	n (FormDicID)
	
	s FormParefDic= $lg(^User.DHCAdvFormDicD(FormDicID),6)  
	i +FormParefDic'=0 d
	.s FormParefParefDic = $lg(^User.DHCAdvFormDicD(FormParefDic),6) 
	.i +FormParefParefDic'=0 d
	..s DicType = $lg(^User.DHCAdvFormDicD(FormParefParefDic),3)
	..i DicType="table" d
	...s FormDicID = ##class(web.DHCADVStatisticsDhcadv).GetTableDic(FormParefParefDic,FormDicID)
	
	q:FormDicID="" ""
	s ret=""
	s ret = FormDicID
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s ret= ret_"^"_DicID
	q ret
}

/// 判断报告中是否包含某个Dic元素
/// w ##class(web.DHCADVStatisticsDhcadv).HasDicInFormRec(1,89178)
ClassMethod HasDicInFormRec(FormRecDr, FormDicDr)
{
	n (FormRecDr,FormDicDr)
	s ret=0

	s FormRecItmID=""
	f  s FormRecItmID = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",FormRecDr,FormRecItmID)) q:(FormRecItmID="")!(ret'=0)  d
	.s FormDicID =  $lg(^User.DHCAdvFormRecordItmD(FormRecItmID),3)
	.q:FormDicDr'[FormDicID
	.s ret=1
	
	q ret
}

/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetComboDataType(93399)
ClassMethod JsonGetComboDataType(FormDicID)
{
	n (FormDicID)
	w:FormDicID="" "["
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","-1^1&人次","&")
	w:FormDicID="" ","
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","-1^2&率","&")
	w:FormDicID="" ","
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","-1^3&人次+率","&")
	w:FormDicID="" "]"
	q:FormDicID="" ""
	s DicChildStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(FormDicID)
	s:FormDicID'=DicChildStr DicChildStr=FormDicID_"^"_DicChildStr
	s Len = $l(DicChildStr,"^")
	w "["
	s Count=0
	s ParName=""
	f i=1:1:Len d
	.s DicDr = $p(DicChildStr,"^",i)
	.s:i=1 ParName = $lg(^User.DHCAdvFormDicD(DicDr),4)
	.s Name = $lg(^User.DHCAdvFormDicD(DicDr),4)
	.q:$$ALPHAUP^SSUTIL4(Name)=""
	.s:i'=1 Name = ParName_":"_Name
	.;s NameType= Name
	.;s NameType= Name
	.;w $case(Count,0:"",:",")
	.;s Count=Count+1
	.;s Data = DicDr_"^1"_"&"_NameType
	.;w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text",Data,"&")
	.f j=1:1:3 d
	..s NameType= Name_"("_$case(j,1:"次",2:"率",3:"次和率",:"")_")"
	..w $case(Count,0:"",:",")
	..s Count=Count+1
	..s Data = DicDr_"^"_j_"&"_NameType
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text",Data,"&")
	w "]"
	
	q ""
}

/// w ##class(web.DHCADVStatisticsDhcadv).JsonGetComboDataTypeByField("")
ClassMethod JsonGetComboDataTypeByField(FieldName)
{
	n (FieldName)
	s FormDicID=""
	s:FieldName'="" FormDicID = $o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(FieldName),""))
	w:FormDicID="" "["
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","^1&人次","&")
	w:FormDicID="" ","
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","^2&率","&")
	w:FormDicID="" ","
	w:FormDicID="" ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text","^3&人次+率","&")
	w:FormDicID="" "]"
	q:FormDicID="" ""
	s DicChildStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(FormDicID)
	
	s:FormDicID'=DicChildStr DicChildStr=FormDicID_"^"_DicChildStr
	s Len = $l(DicChildStr,"^")
	w "["	
	s Count=0
	s ParName=""
	f i=1:1:Len d
	.s DicDr = $p(DicChildStr,"^",i)
	.s:i=1 ParName = $lg(^User.DHCAdvFormDicD(DicDr),4)
	.s Name = $lg(^User.DHCAdvFormDicD(DicDr),4)
	.s field=""
	.i (i=1)&(FormDicID'=DicChildStr) d
	..f j=2:1:$l(DicChildStr,"^") d
	...s DicID = $P(DicChildStr,"^",j)
	...s:field'="" field=field_"#"_$lg(^User.DHCAdvFormDicD(DicID),2)
	...s:field="" field=$lg(^User.DHCAdvFormDicD(DicID),2)
	.e  d
	..s field = $lg(^User.DHCAdvFormDicD(DicDr),2)
	.q:$$ALPHAUP^SSUTIL4(Name)=""
	.s:i'=1 Name = ParName_":"_Name
	.f j=1:1:3 d
	..s NameType= Name_"("_$case(j,1:"次",2:"率",3:"次和率",:"")_")"
	..w $case(Count,0:"",:",")
	..s Count=Count+1
	..s Data = field_"^"_j_"&"_NameType
	..w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("value&text",Data,"&")
	w "]"
	
	q ""
}

/// 获取table
/// w ##class(web.DHCADVStatisticsDhcadv).JsonListDataTable("2017-01-12#2018-01-12#undefined#93910#987#-1^1")
ClassMethod JsonListDataTable(Params)
{
	n (Params)
	s StDate = $p(Params,"#",1)
	s EndDate = $p(Params,"#",2)
	s StatTypeY = $p(Params,"#",3)   	//Y坐标显示列
	s StatTypeYDate = $p(StatTypeY,"^",2)   
	s StatTypeY = $p(StatTypeY,"^",1)  
	s StatTypeX = $p(Params,"#",4)   	//X轴显示列
	s StatTypeXDate = $p(StatTypeX,"^",2)   
	s StatTypeX = $p(StatTypeX,"^",1) 
	s FormNameDr = $p(Params,"#",5)  	//FormNameID:这个ID有可能为全部
	s DataTypeDicInfo = $p(Params,"#",6)	 	 //
	;s DataTypeDic = $p(Params,"#",7)	 	 	 //
	s DataTypeDic = $p(DataTypeDicInfo,"^",1)	 //统计的数据
	s DataTypeNum = $p(DataTypeDicInfo,"^",2)    //1:次 2:率 3:次加率
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StatTypeY'="" StatTypeYName = $lg(^User.DHCAdvFormDicD(StatTypeY),4)
	s:StatTypeY="" StatTypeYName = "合计"   //这个是只选X不选Y时候统计合计的值
	q:DataTypeDic="" ""                     //对应界面的第四个格子
	
	s:DataTypeDic'="-1" DataTypeDicStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfoHasI(DataTypeDic)
	s:DataTypeDic="-1" DataTypeDicStr = "-1"                                                               //这里-1标示所有
	
	s:StatTypeY'="" FormDicYStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(StatTypeY)   //获取元素子元素串串
	s:StatTypeY="" FormDicYStr="合计"
	s FormDicXStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(StatTypeX)   //获取元素子元素串串
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid)
	
	//第一遍：获取轴数据以及X轴colum
	s XColum=""         //记录X列元素
	f Date=StDate:1:EndDate d
	.s FormRecordId =""
	.f  s FormRecordId = $o(^User.DHCAdvFormRecordI("IndexDate",Date,FormRecordId)) q:FormRecordId=""  d   // 一条数据对应一个
	..s FormNameID = $lg(^User.DHCAdvFormRecordD(FormRecordId),2)
	..q:FormNameID'=FormNameDr   //类型过滤
	..s FormRecItmID=""
	..f  s FormRecItmID = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",FormRecordId,FormRecItmID)) q:FormRecItmID=""  d  //对应一条条存储的数据
	...s FormDicXID = $lg(^User.DHCAdvFormRecordItmD(FormRecItmID),3)
	...s FormRecItmXVal = $lg(^User.DHCAdvFormRecordItmD(FormRecItmID),4)
	...q:FormDicXStr'[FormDicXID
	...s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"X",FormRecItmXVal,FormRecordId)=""   //第一个节点：元素ID;第二个节点：报告ID;
	...s:(XColum'="")&&(XColum'[FormRecItmXVal) XColum=XColum_"^"_FormRecItmXVal
	...s:XColum="" XColum = FormRecItmXVal
	
	b ;1
	//第二遍：获取X轴数据以及列数据
	s YColum=""         //记录Y轴元素
	i FormDicYStr'="合计" d
	.s FormRecItmXVal=""
	.f  s FormRecItmXVal = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"X",FormRecItmXVal)) q:FormRecItmXVal=""  d
	..s FormRecordId="" 
	..f  s FormRecordId = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"X",FormRecItmXVal,FormRecordId))  q:FormRecordId=""  d
	...s FormRecItmID=""
	...f  s FormRecItmID = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",FormRecordId,FormRecItmID)) q:FormRecItmID=""  d  //对应一条条存储的数据
	....s FormDicYID = $lg(^User.DHCAdvFormRecordItmD(FormRecItmID),3)
	....s FormRecItmYVal = $lg(^User.DHCAdvFormRecordItmD(FormRecItmID),4)
	....q:FormDicYStr'[FormDicYID
	....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormRecItmYVal,FormRecItmXVal,FormRecordId)=""
	....s:(YColum'="")&&(YColum'[FormRecItmYVal) YColum=YColum_"^"_FormRecItmYVal
	....s:YColum="" YColum = FormRecItmYVal
	i FormDicYStr="合计" d
	.s YColum="合计"
	.s FormRecItmXVal=""
	.f  s FormRecItmXVal = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"X",FormRecItmXVal)) q:FormRecItmXVal=""  d
	..s FormRecordId="" 
	..f  s FormRecordId = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"X",FormRecItmXVal,FormRecordId))  q:FormRecordId=""  d
	...s FormRecItmYVal="合计"
	...s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormRecItmYVal,FormRecItmXVal,FormRecordId)=""
	
	
	q:(YColum="")!(XColum="") pid_"^"_0    //没有数据就不用循环
	
	b ;2
	//第三遍：判断节点是否为时间节点
	i StatTypeYDate'="" d
	.s YColum = ##class(web.DHCADVStatisticsDhcadv).FormatterDataY(pid,Params,StatTypeYDate)   //格式化Y
	i StatTypeXDate'="" d
	.s XColum = ##class(web.DHCADVStatisticsDhcadv).FormatterDataX(pid,Params,StatTypeXDate)   //格式化X
	
	//第四遍：设置数据值
	s AllNum=0,YesNum=0,NoNum=0
	s LenX = $l(XColum,"^")
	s LenY = $l(YColum,"^")
	b ;AllHasNum
	s AllHasNum=0    //记录下当前数据的总条数
	f i=1:1:LenY d
	.s FormDicYID = $p(YColum,"^",i)
	.q:$d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID))=0
	.;这个位置记录Y轴的数据轴
	.s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicYID)=FormDicYID
	.f j=1:1:LenX d
	..s FormDicXID = $p(XColum,"^",j)
	..s ItmYesNum=0,ItmNoNum=0  //记录每一个XY对应位置的数据
	..i $d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID))=0  d
	...s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicYID)=^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicYID)_"^"_ItmYesNum   //增加一个0
	..q:$d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID))=0
	..s FormRecordId=""
	..f  s FormRecordId= $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID,FormRecordId)) q:FormRecordId=""  d
	...;这里判断增加人次选项
	...s:DataTypeDicStr'="-1" HasFlag = ##class(web.DHCADVStatisticsDhcadv).HasDicInFormRec(FormRecordId,DataTypeDicStr)  //获取是否包含
	...s:DataTypeDicStr="-1" HasFlag=1
	...
	...s AllNum=AllNum+1
	...s:HasFlag'=0 ItmYesNum = ItmYesNum+1
	...s:HasFlag=0 ItmNoNum = ItmNoNum+1
	...d ##class(web.DHCADVStatisticsDhcadv).SetXNumber(HasFlag,FormDicXID,pid)   ///记录X方向值的数值
	..s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicYID)=^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicYID)_"^"_ItmYesNum
	..d ##class(web.DHCADVStatisticsDhcadv).SetYNumber(ItmYesNum,FormDicYID,pid)   ///记录Y方向值的数值
	..s AllHasNum = AllHasNum+ItmYesNum     //数据总条数，计算率
	b ;qqa
	s NoDataY=""
	f i=1:1:LenX d
	.s:NoDataY'="" NoDataY = NoDataY_"^"_0
	.s:NoDataY="" NoDataY=0
	
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnX")=StatTypeYName_"^"_XColum
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnY")=YColum
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NoDataY")=NoDataY
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"AllNum")=AllHasNum
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"SetVal")=DataTypeNum
	/**
	 *^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data") 存放数据
	 *^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Column") 存放列内容 
	 */
	q pid_"^"_(LenX+1)
}

/// 用于记录X方向值
ClassMethod SetXNumber(HasFlag, FormDicXID, pid)
{
	n (HasFlag,FormDicXID,pid)	
	
	q:+HasFlag=0
	s HasFlag = $d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",FormDicXID))
	s:HasFlag'=0 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",FormDicXID)=^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",FormDicXID)+1
	s:HasFlag=0 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",FormDicXID)=1
	q ""
}

/// 用于记录Y方向值
ClassMethod SetYNumber(ItmYesNum, FormDicYID, pid)
{
	n (ItmYesNum,FormDicYID,pid)	
	s Flag = $d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",FormDicYID))
	s:Flag'=0 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",FormDicYID) = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",FormDicYID) + ItmYesNum
	s:Flag=0 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",FormDicYID) = ItmYesNum
	q ""
}

/// w ##class(web.DHCADVStatisticsDhcadv).GetTabeData(76282)
ClassMethod GetTabeData(pid)
{
	n (pid)
	s del=""""
	s ColumnX = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnX"))
	s ColumnY = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnY"))
	w:(ColumnY="")!(ColumnX="") ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:(ColumnY="")!(ColumnX="") ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:(ColumnY="")!(ColumnX="") ""
	
	s AllHasNum = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"AllNum")
	s SetVal =  ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"SetVal")
	
	s XLen = $l(ColumnX,"^")
	s YLen = $l(ColumnY,"^")
	s RetStr=""
	f i=1:1:XLen d
	.s:RetStr'="" RetStr=RetStr_"^field"_i
	.s:RetStr="" RetStr="field"_i

	s Count=0
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RetStr,$replace(ColumnX," ",""))
	s Count=Count+1
	f j=1:1:YLen d
	.s FormDicY = $p(ColumnY,"^",j)
	.s HasFlag=$d(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicY))
	.s:HasFlag=0 Data=FormDicY_"^"_^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NoDataY")
	.s:HasFlag'=0 Data = ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"Data",FormDicY)  //这里遍历的时候计算率
	.s DataLen = $l(Data,"^")
	.f k=2:1:DataLen d
	..i SetVal=2 d 
	...s $p(Data,"^",k) = $case(AllHasNum,0:0,AllHasNum:$j($p(Data,"^",k)/AllHasNum,0,2))*100_"%"
	..i SetVal=3 d
	...b ;1
	...s $p(Data,"^",k) = $p(Data,"^",k)_"/"_($case(AllHasNum,0:0,AllHasNum:$j($p(Data,"^",k)/AllHasNum,0,2))*100)_"%"
	...b ;2
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RetStr,Data)
	;w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
	w "],"_del_"total"_del_":"_Count_","
	w del_"allNum"_del_":"_AllHasNum_"}"
	q ""
}

/// 获取右侧图表数据X轴
/// w ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataX(72222)
ClassMethod GetTabeImgDataX(pid, DicXDesc)
{
	n (pid,DicXDesc)  
	;DicXDesc 这个名字为group的名字
	s ColumnX = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnX"))

	w:(ColumnX="")!(ColumnX="") ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:(ColumnX="")!(ColumnX="") ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:(ColumnX="")!(ColumnX="") ""
	s XLen = $l(ColumnX,"^")
	
	w "["
	s Count=0
	f i=2:1:XLen d
	.s Column = $p(ColumnX,"^",i)
	.s Value=0
	.s Value = +($g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",Column)))
	.s Name = Column
	.s Group = DicXDesc
	.s Data = Name_"^"_Group_"^"_Value
	.w $case(Count,0:"",:",")
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("name^group^value",Data)
	.s Count= Count+1
	w "]"
	q ""
}

/// 获取右侧图表数据Y轴
/// w ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataY(72396,"dsf")
ClassMethod GetTabeImgDataY(pid, DicYDesc)
{
	n (pid,DicYDesc)  
	;DicXDesc 这个名字为group的名字
	s ColumnY = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnY"))

	w:(ColumnY="")!(ColumnY="") ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:(ColumnY="")!(ColumnY="") ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:(ColumnY="")!(ColumnY="") ""
	s YLen = $l(ColumnY,"^")
	
	w "["
	s Count=0
	f i=1:1:YLen d
	.s Column = $p(ColumnY,"^",i)
	.s Value=0
	.s Value = +($g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",Column)))
	.s Name = Column
	.s Group = DicYDesc
	.s Data = Name_"^"_Group_"^"_Value
	.w $case(Count,0:"",:",")
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("name^group^value",Data)
	.s Count= Count+1
	w "]"
	q ""
}

/// 获取右侧图表数据X轴
/// w ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataX(72222)
ClassMethod GetTabeImgData(pid, DicXDesc, DicYDesc)
{
	n (pid,DicXDesc,DicYDesc)  
	;DicXDesc 这个名字为group的名字
	s ColumnX = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnX"))
	s ColumnY = $g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"ColumnY"))
	w:(ColumnX="")!(ColumnY="") ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:(ColumnX="")!(ColumnY="") ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:(ColumnX="")!(ColumnY="") ""
	s YLen = $l(ColumnY,"^")
	s XLen = $l(ColumnX,"^")
	
	w "["
	s Count=0
	f i=2:1:XLen d
	.s Column = $p(ColumnX,"^",i)
	.s Value=0
	.s Value = +($g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberX",Column)))
	.s Name = Column
	.s Group = DicXDesc
	.s Data = Name_"^"_Group_"^"_Value
	.w $case(Count,0:"",:",")
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("name^group^value",Data)
	.s Count= Count+1
	
	f i=1:1:YLen d
	.s Column = $p(ColumnY,"^",i)
	.s Value=0
	.s Value = +($g(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"NumberY",Column)))
	.s Name = Column
	.s Group = DicYDesc
	.s Data = Name_"^"_Group_"^"_Value
	.w $case(Count,0:"",:",")
	.w ##class(web.DHCADVJSONCOMMON).getJsonDataPort("name^group^value",Data)
	.s Count= Count+1
	w "]"
	q ""
}

/// 获取右侧图表数据X轴
/// w ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataAll("76141","压疮部位:部位","")
ClassMethod GetTabeImgDataAll(pid, DicXDesc, DicYDesc)
{
	n (pid,DicXDesc,DicYDesc)  

	w:(pid="")!(DicXDesc="") ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:(pid="")!(DicXDesc="") ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(0)
	q:(pid="")!(DicXDesc="") ""

	s Del=""""
	w "{"
	w Del_"DataX"_Del_":"
	d ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataX(pid,DicXDesc)
	w ","
	w Del_"DataY"_Del_":"
	d ##class(web.DHCADVStatisticsDhcadv).GetTabeImgDataY(pid,DicYDesc)
	w ","
	w Del_"Data"_Del_":"
	d ##class(web.DHCADVStatisticsDhcadv).GetTabeImgData(pid,DicXDesc,DicYDesc)
	w "}"
	q ""
}

ClassMethod FormatterDataY(pid, Params, STFVID)
{
	n (pid,Params,STFVID)
	s Num= $p(^DHCADVSTFV(STFVID),"^",4)
	s Uom= $p(^DHCADVSTFV(STFVID),"^",5)
	s StDate = $p(Params,"#",1)
	s EndDate = $p(Params,"#",2)
	s DateStr=""
	i Uom=1 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByD(StDate,EndDate,Num)
	i Uom=2 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByM(StDate,EndDate,Num)
	i Uom=3 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByY(StDate,EndDate,Num)
	
	s Len = $l(DateStr,"^")
	f i=1:1:Len d
	.s Date = $p(DateStr,"^",i)
	.s FormDicYID=""
	.f  s FormDicYID=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID)) q:FormDicYID=""  d
	..s FormDicXID=""
	..f  s FormDicXID=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID)) q:FormDicXID=""  d
	...s FormRecordId="" 
	...f  s FormRecordId=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID,FormRecordId)) q:FormRecordId=""  d
	....s Ret = ##class(web.DHCADVStatisticsDhcadv).IsCurItm(Uom,Num,Date,FormDicYID)
	....q:Ret'=1 
	....i Uom=1 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",Date,FormDicXID,FormRecordId)=""
	....i Uom=2 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",+Date_"-"_$p(Date,"-",2),FormDicXID,FormRecordId)=""
	....i Uom=3 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",+Date,FormDicXID,FormRecordId)=""
	....k:Ret=1 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID,FormRecordId)
	q DateStr
}

ClassMethod FormatterDataX(pid, Params, STFVID)
{
	n (pid,Params,STFVID)
	s Num= $p(^DHCADVSTFV(STFVID),"^",4)
	s Uom= $p(^DHCADVSTFV(STFVID),"^",5)
	s StDate = $p(Params,"#",1)
	s EndDate = $p(Params,"#",2)
	s DateStr=""
	i Uom=1 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByD(StDate,EndDate,Num)
	i Uom=2 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByM(StDate,EndDate,Num)
	i Uom=3 d
	.s DateStr = ##class(web.MyInterfaceMethod).GetDateStrByY(StDate,EndDate,Num)
	
	s Len = $l(DateStr,"^")
	f i=1:1:Len d
	.s Date = $p(DateStr,"^",i)
	.s FormDicYID=""
	.f  s FormDicYID=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID)) q:FormDicYID=""  d
	..s FormDicXID=""
	..f  s FormDicXID=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID)) q:FormDicXID=""  d
	...s FormRecordId="" 
	...f  s FormRecordId=$o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID,FormRecordId)) q:FormRecordId=""  d
	....s Ret = ##class(web.DHCADVStatisticsDhcadv).IsCurItm(Uom,Num,Date,FormDicXID)
	....q:Ret'=1 
	....i Uom=1 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,Date,FormRecordId)=""
	....i Uom=2 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,Date,FormRecordId)=""
	....i Uom=3 d
	.....s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,Date,FormRecordId)=""
	....k:Ret=1 ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","JsonListDataTable",pid,"XY",FormDicYID,FormDicXID,FormRecordId)
	q DateStr
}

/// 第三个参数:是否为当前时间，Date:验证日期
/// w ##class(web.DHCADVStatisticsDhcadv).IsCurItm(1,1,"2017-01-01","2017-01-01")
ClassMethod IsCurItm(Uom, Num, CurDate, Date)
{
	n (Uom,Num,CurDate,Date)

	s:$l(CurDate,"-")=1 CurDate=CurDate_"01-01"
	s:$l(CurDate,"-")=2 CurDate=CurDate_"-01"
	s:$l(Date,"-")=1 Date=Date_"01-01"
	s:$l(Date,"-")=2 Date=Date_"-01"
	s CurYear = +CurDate
	s CurMonth = $p(CurDate,"-",2)

	s Year = +Date
	s Month = $p(Date,"-",2)
	s CurDate = $zdh(CurDate,3)
	s CurEndDate = CurDate+Num
	s Date = $zdh(Date,3)
	s Ret=0
	
	//年
	i Uom=3 d
	.i Num=1 d
	..s:CurYear=Year Ret=1
	.i Num>1 d
	..s:(Year<=CurDate)&&(Year<CurYear+Num) Ret=1
	
	//月
	i Uom=2 d
	.i Num=1 d
	..s:(CurYear=Year)&&(CurMonth=Month) Ret=1
	.i Num>1 d
	..s EndDate = ##class(web.MyInterfaceMethod).GetDateNextM(CurYear_"-"_CurMonth_"-01",Num)
	..s EndDate = $zdh(EndDate,3)
	..s:(CurDate<=Date)&&(Date<EndDate) Ret =1
	
	//天
	i Uom=1 d
	.i Num=1 d
	..s:CurDate=Date Ret=1
	.i Num>1 d
	..s:(CurDate<=Date)&&(Date<CurEndDate) Ret=1
	
	q Ret
}

/// 获取表格元素1
/// w ##class(web.DHCADVStatisticsDhcadv).GetTableDic(93906,93915)
ClassMethod GetTableDic(TabDicID, InptLabDicDr)
{
	n (TabDicID,InptLabDicDr)
	s DicStyle= $lg(^User.DHCAdvFormDicD(TabDicID),3)
	q:DicStyle'="table" ""  //元素类型为table
	s RetData=""
	s FirstLabStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(TabDicID)
	s Len = $l(FirstLabStr,"^")  //table 类型格式一定为2
	q:Len'=2 "维护表格格式不正确"
	s FirstLabDic = $p(FirstLabStr,"^",1)
	s LableNameDicStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(FirstLabDic)   //这是lab元素
	s FirstDataDic = $p(FirstLabStr,"^",2)
	s LableDataDicStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(FirstDataDic)   //这是lab元素
	s Ret =""
	s Len = $l(LableNameDicStr,"^")
	s DataLen = $l(LableDataDicStr,"^")
	q:Len'=DataLen "表格列与内容列未正确对照"
	
	f i=1:1:Len q:Ret'=""  d
	.s LabDicDr = $p(LableNameDicStr,"^",i)  
	.s DataDicDr = $p(LableDataDicStr,"^",i)
	.s:InptLabDicDr=LabDicDr Ret =DataDicDr
	
	q Ret
	/*
	s pid = ##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid)
	
	f i=1:1:Len d
	.s LabDicDr = $p(LableNameDicStr,"^",i)  
	.s DataDicDr = $p(LableDataDicStr,"^",i)
	.d ##class(web.DHCADVStatisticsDhcadv).JsonChildDic(pid,DataDicDr)
	
	s DataDicDr=""
	f  s DataDicDr = $o(^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid,DataDicDr)) q:DataDicDr=""  d
	.f i=1:1:Len d
	..s LabDicDr = $p(LableNameDicStr,"^",i) 
	..s DataDicDr = $p(LableDataDicStr,"^",i) 
	..s:^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid,DataDicDr)=DataDicDr ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid,DataDicDr)=LabDicDr
	
	
	
	/*
	.s DataLabDicDrStr = ##class(web.DHCADVStatisticsDhcadv).GetChildInfo(DataDicDr)  //一定是只有一个
	.s DataLabDicLen=$l(DataLabDicDrStr,"^")
	.f j=1:1:DataLabDicLen d
	..s DataLabDicDr = $p(DataLabDicDrStr,"^",j)
	..s Data = LabDicDr_"^"_DataLabDicDr
	..s:RetData'="" RetData = RetData_"&"_Data
	..s:RetData="" RetData = Data
	*/
}

/// w ##class(web.DHCADVStatisticsDhcadv).JsonChildDic(1,93906)
ClassMethod JsonChildDic(pid, FormDicID)
{
	n (pid,FormDicID)
	q:FormDicID="" ""
	s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid,FormDicID)=""
	s DicID =0
	f  s DicID = $o(^User.DHCAdvFormDicI("IndexParef"," "_FormDicID,DicID)) q:DicID=""  d   //子元素
	.s ^TMP("DHCADV","web.DHCADVStatisticsDhcadv","GetTableDic",pid,DicID)=FormDicID
	.s HasFlag = ##class(web.DHCADVSetAdvStatFied).IsHasChildDic(DicID)
	.d:+HasFlag'=0 ##class(web.DHCADVStatisticsDhcadv).JsonChildDic(pid,DicID)   //递归:注意容易出死循环
	q ""
}

}
