Import SQLUser

/// 主要功能：站点和体检大项（医嘱）对照 操作插入 删除 更改 
Class web.DHCPE.StationOrder Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 341;

/// 提供给Web页面 显示给定站点的体检大项(医嘱) 给DHCPEStationOrderCom组件用
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.StationOrder","QueryAll","8","222")
Query QueryAll(ParRef As %Library.String = "", ParRefNameBox As %Library.String = "", ARCIMDesc As %Library.String = "", HadLocFlag As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = " STORD_ParRef:%String:站点ID, STORD_ParRef_Name:%String:站点名称, STORD_RowId:%String:项目ID, STORD_Childsub:%String:项目子节点, STORD_ARCIM_DR:%String:医嘱项ID, STORD_ARCIM_Code:%String:编码, STORD_ARCIM_Desc:%String:描述, STORD_Diet:%String:就餐, STORD_ARCOS_DR:%String:医嘱套ID, STORD_ARCOS_DR_Name:%String:医嘱餐名称, STORD_ReportFormat:%String:报告格式, STORD_Notice:%String:注意事项, STORD_IsHaveChilud:%String:是否有医嘱子项,TAutoReturn:%String:自动回传,TPatItemName:%String:导诊单类别,TPatItemNameID:%String:导诊单类别ID,TReportItemName:%String:报告类别,TReportItemNameId:%String:报告类别ID,TSort:%String:顺序,TPatPrintOrder:%String:打印医嘱名称,TIFPrint:%String:是否打印,TVIPLevel:%String:VIP等级, TVIPLevelId:%String:VIP等级ID,TPISCode:%String:病理标本,TPISCodeID:%String,TAlowAddFlag:%String:允许重复,TAgeMax:%String:年龄上限,TAgeMin:%String:年龄下限,TMarried:%String,TMarryDesc:%String:婚姻,TSex:%String,TPhotoItem:%String,TSignItem:%String,TExtendItem:%String,TShowOrHide:%String,TTempName:%String,TPreNum:%String,TBaseBar:%String,TYGFlag:%String,TPrintName:%String,TBarPrintNum:%String,TIFReprotPrint:%String")
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, ParRef As %Library.String, ParRefNameBox As %Library.String = "", ARCIMDesc As %Library.String = "", HadLocFlag As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s curLoc=%session.Get("LOGON.CTLOCID")
 	i ""=ParRef {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ARCIMDesc=$g(ARCIMDesc)
	s ARCIMDesc=##class(web.DHCPE.DHCPECommon).UnEscape(ARCIMDesc)
	s ARCIMDesc=$ZCVT(ARCIMDesc,"U")
	s ind=1
 	s id="0" 	
	f  s id=$O(^DHCPEST(ParRef,"O",id)) q:id=""  d
	.s CurData=$g(^DHCPEST(ParRef,"O",id))
	
	.s iParRef=ParRef
	.s iChildsub=id
	.s iRowId=iParRef_"||"_id
	.// 医嘱编码 医嘱名称
	.s iARCIMDR=$p(CurData,"^",1)
	
	.Q:(""=iARCIMDR)
	.s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	.i EffDate="" s EffDate=+$H+1
	.q:EffDate<+$H
	.q:(HadLocFlag'="")&&($D(^DHCPEStationOrder("Loc",iARCIMDR)))
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
	.q:(HOSPshowFlag="N")

	.s iSTORDDiet=$p(CurData,"^",2)
	.i iSTORDDiet="PRE" S iSTORDDiet="餐前"
	.E  i iSTORDDiet="POST" S iSTORDDiet="餐后"
	.e  S iSTORDDiet="不限"
	
	.// STORD_ARCOS_DR -> ARC_OrdSets
	.s iARCOSDR=$p(CurData,"^",3)
	.s iARCOSDRName=""
	.s:(""'=iARCOSDR) iARCOSDRName=$P($G(^ARCOS(iARCOSDR)),"^",2)
	.s TAutoReturn=$p(CurData,"^",6)
	.i TAutoReturn'="N" d
	..s TAutoReturn="1"
	.e  d
	..s TAutoReturn="0"
	.I TAutoReturn="1" s TAutoReturn="是"
	.e  s TAutoReturn="否"
	.// STORD_ReportFormat
    .s iReportFormat=$p(CurData,"^",4)
	.i iReportFormat'="" s iReportFormat=..GetReportFormat(iReportFormat)
	.//STORD_Notice
	.s iNotice=$p(CurData,"^",5)
	.s iNotice=$G(^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",iARCIMDR,curLoc))
	.s TSort=$p(CurData,"^",7)
	
	.// ARC_ItmMast
	.s iARCIMCode=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",1)
	
	.s iARCIMDesc=$p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
	.//q:(iARCIMDesc'[ARCIMDesc)&&(ARCIMDesc'="")
	.s AliasId=0
	.s Alias=""
	.f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d
	..s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)
	..i EffDate="" s EffDate=+$h+1
	..q:EffDate<+$h
	..s Alia=$p(^ARC("ALIAS",AliasId),"^",6)
	..s Alia=$ZCVT(Alia,"U")
	..s Alias=Alias_"^"_Alia
	.q:(($ZCVT(iARCIMDesc,"U")'[ARCIMDesc)&&(Alias'[ARCIMDesc))
	.// DHC_PE_OrderDetail 查看医嘱项目是否有子项
	.s odRowId=0
	.s odRowId=$O(^DHCPEODR(0,"ARCIM",iARCIMDR,odRowId))
	.i ""=odRowId d
	..s IsHaveChilud="N"
	.e  d
	..s IsHaveChilud="Y"
	.
	.//取得站点名称
	.s CurData=$g(^DHCPEST(ParRef))
	.s iParRefName=$p(CurData,"^",2)
    .s PatItemName=""
    .s PatItemNameID=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",1)
    .s patprintorder=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",2)
    .s ifprint=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",3)
    .i ifprint="" s ifprint="Y"
    .i ifprint="Y" S ifprint="是"
    .e  s ifprint="否"
    .s PrintName=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",4)
    .i PatItemNameID'="" s PatItemName=$p($G(^DHCPECTDataEx("PatItem",PatItemNameID)),"^",1)
    .//报告类别
    .s ReportItemName=""
    .s ReportItemNameId=$G(^DHCPECTDataEx("ReportItemSort",iARCIMDR))
    .i ReportItemNameId'="" s ReportItemName=$p($G(^DHCPECTDataEx("ReportItem",ReportItemNameId)),"^",1)
    .
    .//VIP等级
    .s VIPLevel=""
    .s VIPLevelId=$G(^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",iARCIMDR))
    .i VIPLevelId'="" s VIPLevel=$p($G(^DHCPEVIPLevel("VIP",VIPLevelId)),"^",2)
   
    .//标本类型
     .s PISType=""
    .;i $g(^DHCPESetting("DHCPE","SendPisInterface"))'="Y" d
    .i $g(^DHCPESetting("DHCPE","SendPisInterface",LocID))'="Y" d
    ..s PISTypeCode=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",iARCIMDR))
    ..i PISTypeCode="20" s PISType="细胞"
    ..i PISTypeCode="23" s PISType="TCT"
    .;i $g(^DHCPESetting("DHCPE","SendPisInterface"))="Y" d
    .i $g(^DHCPESetting("DHCPE","SendPisInterface",LocID))'="Y" d
    ..s PISTypeCode=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",iARCIMDR))
    ..i PISTypeCode'="" s PISType=$P($G(^DHCAPPTS(PISTypeCode)),"^",2)

    .//允许重复
    .s AlowAddFlag=""
    .s AlowAddFlag=$g(^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",iARCIMDR))
  	.i AlowAddFlag="1" s AlowAddFlag="是"
  	.e  s AlowAddFlag="否"
  	
  	.//年龄上限、年龄下限、婚姻
    .s AgeMax="",AgeMin="",MarryDesc=""
    .s AgeMax=$P($G(^DHCPECTDataEx("DHCPEStationOrder","Age",iARCIMDR)),"^",2)
    .s AgeMin=$P($G(^DHCPECTDataEx("DHCPEStationOrder","Age",iARCIMDR)),"^",1)
    .//婚姻
    .s Married=$G(^DHCPECTDataEx("DHCPEStationOrder","Married",iARCIMDR))
    .i Married'="" s MarryDesc=$p($g(^CT("MAR",Married)),"^",2)
    .//性别
    .S Sex=""
    .s SexDR=$G(^DHCPECTDataEx("DHCPEStationOrder","Sex",iARCIMDR))
    .i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
    .//是否有片子 
    .S PhotoItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Photo",iARCIMDR))
    .i PhotoItem="Y" S PhotoItem="是"
    .e  s PhotoItem="否"
    .//特殊检查
    .s SignItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Sign",iRowId))
    .i SignItem="Y" s SignItem="是"
    .e  S SignItem="否"
    .//继承
    .s ExtendItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Extend",iARCIMDR))
   	.i ExtendItem="Y" s ExtendItem="是"
    .e  S ExtendItem="否"
    .//禁用
    .s ShowOrHide=$G(^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",iARCIMDR))
    .i ShowOrHide="Y" s ShowOrHide="是"
    .e  S ShowOrHide="否"
    .//模板名称
    .s TempName=$G(^DHCPECTDataEx("DHCPEStationOrder","TempName",iARCIMDR))
    .//预约数量
    .S PreNum=$G(^DHCPECTDataEx("DHCPEStationOrder","PreNum",iARCIMDR))
    .//基本信息条码,
    .s BaseBar=$G(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",iARCIMDR))
    .i BaseBar="1" s BaseBar="是"
    .e  S BaseBar="否"
	.s YGFlag=$g(^DHCPECTDataEx("YGFlag",iARCIMDR))
    .i YGFlag="Y" s YGFlag="是"
    .e  S YGFlag="否"
    .s BarPrintNum=$g(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",iARCIMDR))
     . //是否打印（报告）
    .s IFReprotPrint=$g(^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",iARCIMDR))
    .i IFReprotPrint="" s IFReprotPrint="Y"
    .i IFReprotPrint="Y" s IFReprotPrint="是"
    .e  S IFReprotPrint="否"
   
    .d QueryOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOut      
	set Data=$lb(iParRef, iParRefName, iRowId, iChildsub, iARCIMDR, iARCIMCode, iARCIMDesc, iSTORDDiet, iARCOSDR, iARCOSDRName, iReportFormat, iNotice, IsHaveChilud,TAutoReturn,PatItemName,PatItemNameID,ReportItemName,ReportItemNameId,TSort,patprintorder,ifprint,VIPLevel,VIPLevelId,PISType,PISTypeCode,AlowAddFlag,AgeMax,AgeMin,Married,MarryDesc,Sex,PhotoItem,SignItem,ExtendItem,ShowOrHide,TempName,PreNum,BaseBar,YGFlag,PrintName,BarPrintNum,IFReprotPrint)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据医嘱项目获取其对应站点
ClassMethod FromARCIMToStation(ARICM As %String)
{
	&sql(select STORD_ParRef->ST_Desc into :STation from DHC_PE_StationOrder where STORD_ARCIM_DR=:ARICM)
	Q:(SQLCODE=100) ""
	Q STation
}

/// 提供给Web页面 查询给定站点的检验医嘱
/// 
Query SearchStationOrder(ParRef As %Library.String = "", ParRefNameBox As %Library.String = "") As %SQLQuery(ROWSPEC = "STORD_ParRef:%String,STORD_RowId:%String, STORD_Childsub:%String, STORD_ARCIM_DR:%String, STORD_Diet:%String, STORD_ARCIM_Code:%String, STORD_ARCIM_Desc:%String, STORD_ParRef_Name:%String")
{
 select so.STORD_ParRef,so.STORD_RowId,so.STORD_Childsub,so.STORD_ARCIM_DR,so.STORD_Diet,
        ai.ARCIM_Code,ai.ARCIM_Desc,s.ST_Desc as STORD_ParRef_Name 
 from DHC_PE_StationOrder as so
 inner join sqluser.arc_itmmast as ai on ai.ARCIM_RowId=so.STORD_ARCIM_DR
 inner join sqluser.DHC_PE_Station as s on s.ST_RowId=so.STORD_ParRef
 where so.STORD_ParRef=:ParRef
}

/// d ##class(web.DHCPE.StationOrder).ARCOrdSetList1("3998||1")
ClassMethod ARCOrdSetList(ARCIMDR As %Library.String = "")
{
	k ^xwmTemp("ARCOrdSetList")
	&SQL(
		declare OSCursor CURSOR FOR
		select ITM_ParRef->DATE_ParRef->ARCOS_RowId,
				ITM_ParRef->DATE_ParRef->ARCOS_Code,
				ITM_ParRef->DATE_ParRef->ARCOS_desc,
				ITM_ParRef->DATE_ParRef->ARCOS_LabTrakTestSet,
				ITM_ParRef->DATE_DateFrom,
				ITM_ParRef->DATE_DateTo
		from ARC_OrdSetDateItem
		where ITM_ARCIM_DR=:ARCIMDR
	)
	&SQL(open OSCursor)
	s CurDate=+$H
	For {
		&SQL(fetch OSCursor into :ARCOSRowId, :ARCOSCode, :ARCOSDesc, :ARCOLabTrakTestSet, :DateFrom, :DateTo) 
		Q:SQLCODE
		i 0=SQLCODE d
		.Q:(""'=DateFrom)&(DateFrom>CurDate)
		.Q:(""'=DateTo)&(DateTo<CurDate)
		.s ^xwmTemp("ARCOrdSetList",ARCOSRowId)=ARCOSCode_"^"_ARCOSDesc_"^"_ARCOLabTrakTestSet
	}
	
	&SQL(close OSCursor)
	Q 1
}

/// 显示医嘱项目关联的医嘱项，以便查看、添加医嘱项目 DHCPEStationOrderCom
/// 只对旧版本的Medtrak起作用
/// d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","ARCOrdSetList","3870||1")
Query ARCOrdSetList(ARCIMDR As %String = "") As %Query(ROWSPEC = "ARCOS_Code:%String:编码, ARCOS_Desc:%String:名称, ARCOS_RowId:%String:ID, ARCOS_LabTrakTestSet:%String:套餐设置")
{
}

ClassMethod ARCOrdSetListExecute(ByRef qHandle As %Binary, ARCIMDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	if (""=ARCIMDR) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	d ..ARCOrdSetList(ARCIMDR)
	
	s id="0"
	s ind=1
	f  s id=$O(^xwmTemp("ARCOrdSetList",id)) Q:(""=id)  d
	.s Code=$P($G(^xwmTemp("ARCOrdSetList",id)),"^",1)
	.s Desc=$P($G(^xwmTemp("ARCOrdSetList",id)),"^",2)
	.s LabTrakTestSet=$P($G(^xwmTemp("ARCOrdSetList",id)),"^",3)
	.d ARCOrdSetListBuild

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ARCOrdSetListBuild      
	set Data=$lb(Code, Desc, $G(id),LabTrakTestSet)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ARCOrdSetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ARCOrdSetListExecute ]
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

ClassMethod ARCOrdSetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ARCOrdSetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// ************************************************************************8

/// 首先设置好对应科室导入医嘱的类别;ArcCatDetail   161||1  记帐子类   595  ItemCat
/// ^renzwangImportStationOrder(StationID,"ArcCat","LIS")=29,RF_LIS
/// ^renzwangImportStationOrder(StationID,"ArcCatDetail","RIS")=10,RF_RIS^11,RF_RIS
/// ^renzwangImportStationOrder(StationID,"ArcCatDetail","NOR")=10,RF_RIS^11,RF_RIS
/// w ##class(web.DHCPE.StationOrder).ImportStationArcItem(8)
/// 导入科室对应的遗嘱项目  StationID:站点ID
/// 30  检验
ClassMethod ImportStationArcItem(StationID)
{
   S ^zl("ImportStationArcItem",StationID)=1
	s OneCat=0
	s SQLCODE=0
	s ArcCatType=$o(^renzwangImportStationOrder(StationID,""))   //ArcCat,ArcCatDetail
	q:ArcCatType=""
	s StationType=$o(^renzwangImportStationOrder(StationID,ArcCatType,""))
	s ArcCatIDs=$G(^renzwangImportStationOrder(StationID,ArcCatType,StationType))
	q:ArcCatIDs=""
	s i=$l(ArcCatIDs,"^")
	s Sequence=0
	S ^zl("ImportStationArcItem",StationID,1)=ArcCatIDs_"$$"_ArcCatType

	&SQL(select max(od_sequence) into :Sequence  from DHC_PE_OrderDetail where od_parref=:StationID)	
	if Sequence="" s Sequence=0
	
	i ArcCatType="ArcCat"
	{
		f j=1:1:i d
		.s String=$p(ArcCatIDs,"^",j)
		.s ArcCatID=+String
		.s ReportFormat=$p(String,",",2)
		.s Diet=$p(String,",",3)
		.s OneCat=0
		.f  s OneCat=$o(^ARCBG(ArcCatID,"SG",OneCat)) q:(OneCat="")  d
		..s OneCatID=ArcCatID_"||"_OneCat
		..s SQLCODE=..ImportStationArcItemByOneCat(StationID,OneCat,StationType,ReportFormat,Diet,.Sequence)
	}
	i ArcCatType="ArcCatDetail"
	{
		f j=1:1:i d
		.s String=$p(ArcCatIDs,"^",j)
		.s OneCat=$p(String,",",1)
		.s ReportFormat=$p(String,",",2)
		.s Diet=$p(String,",",3)
		.s SQLCODE=..ImportStationArcItemByOneCat(StationID,OneCat,StationType,ReportFormat,Diet,.Sequence)
		
	}
	q SQLCODE
}

/// 具体的一个医嘱类别  OneCat:明细ARC_BillSub
ClassMethod ImportStationArcItemByOneCat(StationID, OneCat, StationType, ReportFormat, Diet, Sequence)
{
	s ARCSub=0
	s SQLCODE=0
	//s Diet="PRE"   //POST，N
	s ReportFormat=ReportFormat  //RF_Cat,RF_LIS,RF_NOR,RF_RIS
	s i=$l(OneCat,"||")
	i i=2 d
	.f  s ARCSub=$o(^ARCIM(0,"ARCSG_DR",OneCat,ARCSub)) q:(ARCSub="")  d
	..s Version=0
	..f  s Version=$o(^ARCIM(0,"ARCSG_DR",OneCat,ARCSub,Version)) q:(Version="")  d
	...d InsertOneARC
	e  d
	.f  s ARCSub=$o(^ARCIM(0,"ARCIC_DR",OneCat,ARCSub)) q:(ARCSub="")  d
	..s Version=0
	..f  s Version=$o(^ARCIM(0,"ARCIC_DR",OneCat,ARCSub,Version)) q:(Version="")  d
	...d InsertOneARC
	/*..
	..s ARCID=ARCSub_"||"_Version
	..s EffDate=$p(^ARCIM(ARCSub,Version,7),"^",1)
	..//s EffDate=$p(^ARCIM(ARCSub,Version,1),"^","Z",13,2)
	..//&SQL(select ARCIM_EffDateTo into :EffDate from sqluser.arc_itmmast where ARCIM_RowID=:ARCID)
	..s Date=+$H
	..s Flag=0
	..i EffDate'=""  d
	...i Date>EffDate s Flag=1
	..q:Flag=1
	..s HadStation=0
	..f  s HadStation=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,HadStation)) q:HadStation=""  d
	...i HadStation'="" s Flag=1
	..q:Flag=1
	..&sql(insert into DHC_PE_StationOrder(STORD_ParRef, STORD_ARCIM_DR, STORD_Diet,STORD_ReportFormat,STORD_AutoReturn)
	     values(:StationID, :ARCID, :Diet,:ReportFormat,'Y'))
	..i SQLCODE'=0 s ^renzwangImport("Main",StationID,ARCID)=SQLCODE
	..q:SQLCODE
	..///插入明细
	..s SQLCODE=..InsertArcDetail(ARCID, StationID, StationType, .Sequence)
	..i SQLCODE="" s SQLCODE=0
	..i SQLCODE'=0 s ^renzwangImport("Detail",StationID,ARCID)=SQLCODE*/
	q SQLCODE
	
	
InsertOneARC
	s ARCID=ARCSub_"||"_Version
	s EffDate=$p(^ARCIM(ARCSub,Version,7),"^",1)
	//s EffDate=$p(^ARCIM(ARCSub,Version,1),"^","Z",13,2)
	//&SQL(select ARCIM_EffDateTo into :EffDate from sqluser.arc_itmmast where ARCIM_RowID=:ARCID)
	s Date=+$H
	s Flag=0
	i EffDate'=""  d
	.i Date>EffDate s Flag=1
	q:Flag=1
	
	s Exsit=0
	s SQLCODE=0
	
	s HadStation=0
	f  s HadStation=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,HadStation)) q:HadStation=""  d
	;i HadStation'="" s Flag=1
	.i HadStation'="" s Exsit=1
	i Exsit=0 d
	.&sql(insert into DHC_PE_StationOrder(STORD_ParRef, STORD_ARCIM_DR, STORD_Diet,STORD_ReportFormat,STORD_AutoReturn)
	     values(:StationID, :ARCID, :Diet,:ReportFormat,'Y'))
	/*q:Flag=1
	&sql(insert into DHC_PE_StationOrder(STORD_ParRef, STORD_ARCIM_DR, STORD_Diet,STORD_ReportFormat,STORD_AutoReturn)
	     values(:StationID, :ARCID, :Diet,:ReportFormat,'Y'))
	     */

	i SQLCODE'=0 s ^renzwangImport("Main",StationID,ARCID)=SQLCODE
	q:SQLCODE
	s $P(^DHCPECTDataEx("PatItemSort",ARCID),"^",3)="Y"
	///插入明细
	s SQLCODE=..InsertArcDetail(ARCID, StationID, StationType, .Sequence)
	i SQLCODE="" s SQLCODE=0
	i SQLCODE'=0 s ^renzwangImport("Detail",StationID,ARCID)=SQLCODE
	quit
}

/// w ##class(web.DHCPE.StationOrder).ImportOneARCItm()
/// 导入单个遗嘱项目
ClassMethod ImportOneARCItm()
{
	s StationID=9
	s ARCID="4308||1"
	s Diet="N"
	s ReportFormat="RF_RIS"
	s Sequence=1
	s StationType="RIS"
	TSTART
	&sql(insert into DHC_PE_StationOrder(STORD_ParRef, STORD_ARCIM_DR, STORD_Diet,STORD_ReportFormat,STORD_AutoReturn)
	     values(:StationID, :ARCID, :Diet,:ReportFormat,'Y'))
	TROLLBACK:SQLCODE'=0
	i SQLCODE'=0 q SQLCODE
	///插入明细
	s SQLCODE=..InsertArcDetail(ARCID, StationID, StationType, .Sequence)
	TROLLBACK:SQLCODE'=0
	i SQLCODE'=0 q SQLCODE
	TCOMMIT
	q SQLCODE
}

ClassMethod InsertArcDetail(ARCID, StationID, StationType, Sequence)
{
	s SQLCODE=0
	i StationType="LIS" d
	.s SQLCODE=##class(web.DHCPE.TransOrderDetail).Main(ARCID,StationID)
	i StationType="RIS" d
	.s Sequence=""
	.&SQL(SELECT max(OD_Sequence) into :Sequence FROM Sqluser.DHC_PE_Orderdetail WHERE OD_ParRef=:StationID)
	.;s:+Sequence=0 Sequence=1
	.i +Sequence=0 s Sequence=1
	.e  s Sequence=Sequence+1
	.S Station=$e("00",1,2-$l(StationID))_StationID
	.s SequenceStr=$e("00000",1,5-$l(Sequence))_Sequence
	.s SequenceStr=Station_SequenceStr
	.s ARCName=$p(^ARCIM(+ARCID,$p(ARCID,"||",2),1),"^",2)_"-检查结果"
	.s Value="T"
	.s DetailSex="N"
	.s Submit="Y"
	.s ArcDetailID=""
	.&sql(select OD_RowId into :ArcDetailID from SQLUSER.DHC_PE_OrderDetail where OD_Desc=:ARCName)
	.i ArcDetailID="" d
	..&sql(insert into sqluser.DHC_PE_OrderDetail (OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Summary,OD_Advice,OD_Sequence,OD_Sex) values (:StationID,:SequenceStr,:ARCName,:Value,:Submit,:Submit,:Sequence,:DetailSex))
	..i SQLCODE'=0 s SQLCODE=SQLCODE_"Detail"
	..q:SQLCODE'=0
	..s ArcDetailID=%ROWID
	.;&SQL(insert into sqluser.DHC_PE_OrderDetailRelate (ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required) values (:ARCID,:ArcDetailID,:Sequence,'Y'))
	.s ODRRowId=""
	.&SQL(SELECT ODR_RowId into :ODRRowId FROM SQLUSER.DHC_PE_OrderDetailRelate WHERE ODR_OD_DR=:ArcDetailID)
	.i (ODRRowId="")&&(ArcDetailID'="") d	
	..&SQL(insert into sqluser.DHC_PE_OrderDetailRelate (ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required) values (:ARCID,:ArcDetailID,:Sequence,'Y'))

	q SQLCODE
}

/*
/// 查找体检系统的医嘱项目
/// 		DHCPEPreItemList.QryItm
/// 		d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","StationOrderList","","Item")
Query StationOrderList(Item As %Library.String = "", Type As %Library.String = "", TargetFrame As %String = "", PreIADMID As %String = "", StationID As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "STORD_ARCIM_Code:%String:编码, STORD_ARCIM_Desc:%String:名称, STORD_ARCIM_DR:%String:ID, STORD_ARCIM_Price:%String:价格,TUOM:%String:单位,TLocDesc:%String:科室")
{
}

ClassMethod StationOrderListExecute(ByRef qHandle As %Binary, Item As %String = "", Type As %Library.String = "", TargetFrame As %String = "", PreIADMID As %String = "", StationID As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
 	//Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
 	Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID))

 	s LabCode=$P(^DHCPEST(LabStation),"^",1)
 	//Set OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
 	//Set MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical"))
 	Set OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
 	Set MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))

 	if (Type="NoShow") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s vVIPID="",vPatFeeType=""
 	s vPatFeeType=##class(web.DHCPE.VIPLevel).GetPatFeeType(vVIPID)
 	s PreIADMID=$P(PreIADMID,"^",1)
 	i PreIADMID'="" d
 	.i $L(PreIADMID,"||")>1 d
 	..s vVIPID=$g(^DHCPECBVIPLevel("PGT",PreIADMID))
	..s vPatFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",PreIADMID))
 	.e  d
 	..s vVIPID=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADMID)
 	..s vVIPID=$P(vVIPID,"^",1)
 	..s vPatFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PreIADMID))
 	e  d
 	.s vVIPID=""
 	.s vPatFeeType=""
 	s Job=$J
 	k ^DHCPETemp("StationOrderList",$j)
 	k ^TempDHCPEStationOrder(Job)
 	s ind=1
 	
 	s:$d(%session) CurLoc=%session.Get("LOGON.CTLOCID")
	s:'$d(%session) CurLoc=572
 	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Item)
 	s Desc=$ZCVT(Desc,"U")
	
 	//查找全部
 	i ""=Desc {
 	
 	//i Type="" s Type="Item"
 	s ParRef=0
 	f  s ParRef=$O(^DHCPEST(ParRef)) q:ParRef=""  d
 	.Quit:(TrakVerison="MedTrak")&&(ParRef=LabStation)
 	.Quit:(Type="Lab")&&(ParRef'=LabStation)
 	.Quit:(Type="Item")&&(ParRef=LabStation)
 	.;Quit:(Type="Item")&&((ParRef=LabStation)||(ParRef=OtherStation)||(ParRef=MedicalStation))
 	.Quit:(Type="Other")&&(ParRef'=OtherStation)
 	.Quit:(Type="Medical")&&(ParRef'=MedicalStation)
 	.Set id="0"
 	.f  s id=$O(^DHCPEST(ParRef,"O",id)) q:id=""  d
	..s CurData=$g(^DHCPEST(ParRef,"O",id))
	..// 医嘱编码 医嘱名称
	..s iARCIMDR=$p(CurData,"^",1)
	..Q:(""=iARCIMDR)
	..s iSTORDDiet=$p(CurData,"^",2)
	..// STORD_ARCOS_DR -> ARC_OrdSets
	..s iARCOSDR=$p(CurData,"^",3)
	..s iARCOSDRName=""
	..s:(""'=iARCOSDR) iARCOSDRName=$P($G(^ARCOS(iARCOSDR)),"^",2)
	..// STORD_ReportFormat
    ..s iReportFormat=$p(CurData,"^",4)
	..s ST=+ParRef
	..s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	..;q:CurSort'=""
	..d GetOneInfo
	
 	}
 	// 按别名查
 	if (""'=Desc) {
 	s ALIASText=$O(^ARC("ALIAS",0,"Desc",Desc),-1)
	f  s ALIASText=$O(^ARC("ALIAS",0,"Desc",ALIASText)) Q:(""=ALIASText)||(ALIASText'[Desc)  d
	.s ALIASDesc=""  //ALIAS_Desc
	.f  s ALIASDesc=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc)) Q:(""=ALIASDesc)  d
	..s ALIASRowId=""
	..f  s ALIASRowId=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc, ALIASRowId)) Q:(""=ALIASRowId)  d
	...s CurData=$G(^ARC("ALIAS", 0, "Desc", ALIASText, ALIASDesc, ALIASRowId,1))
	...// ALIAS_Type
	...s ALIASType=$P(CurData,"^",2)
	...// ALIAS_Row_Calc
	...s ALIASRowCalc=$P(CurData,"^",1)
	...s iARCIMDR=""
	...//w ALIASText_"  "_ALIASDesc_"  "_ALIASRowCalc_"   :"_ALIASType_":",!
	...
	...i ("ARCIM"=ALIASType) d
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc,""))
	....Q:(""=STRowId)
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....q:(Type="Item")&&(STRowId=LabStation)
 	....Q:(Type="Other")&&(STRowId'=OtherStation)
 	....Q:(Type="Medical")&&(STRowId'=MedicalStation)
	....s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	....Q:(""=Childsub)
	....s iARCIMDR=ALIASRowCalc
	...i "ARCOS"=ALIASType d
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCOS",ALIASRowCalc,""))
	....
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....Q:(""=STRowId)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....q:(Type="Item")&&(STRowId=LabStation)
 	....Q:(Type="Other")&&(STRowId'=OtherStation)
 	....Q:(Type="Medical")&&(STRowId'=MedicalStation)
	....s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	....Q:(""=Childsub)
	....
	....s iARCIMDR=$P($G(^DHCPEST(STRowId,"O",Childsub)),"^",1)
	...
	...Q:(""=iARCIMDR)
	...s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	...;q:CurSort'=""
	...q:$D(^DHCPETemp("StationOrderList",$j,iARCIMDR))
	...s ST=STRowId
	...d GetOneInfo
 	}
 	s STSort=""
 	f  s STSort=$O(^TempDHCPEStationOrder(Job,STSort)) q:STSort=""  d
 	.s StationID=""
 	.f  s StationID=$O(^TempDHCPEStationOrder(Job,STSort,StationID)) q:StationID=""  d
 	..s STCode=$P(^DHCPEST(LabStation),"^",1)
 	..s STLocSort=""
 	..f  s STLocSort=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort)) q:STLocSort=""  d
 	...s STLocID=""
 	...f  s STLocID=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID)) q:STLocID=""  d
 	....i $L(STLocID,"||")>1 d
 	.....s STDesc=$P($G(^DHCPEST(+STLocID,"STLOC",$P(STLocID,"||",2))),"^",1)
 	....e  d
 	.....s STDesc=$P(^DHCPEST(StationID),"^",2)
 	....s i=0
 	....s ItemSort=""
 	....f  s ItemSort=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort)) q:ItemSort=""  d
 	.....s ItemSub=""
 	.....f  s ItemSub=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort,ItemSub)) q:ItemSub=""  d
 	......s:i>0 STDesc=""
 	......s i=i+1
 	
 	......s Data=$G(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort,ItemSub))
 	......d OutList
 	;:(i=1)||(STCode>=LabCode)
	k ^TempDHCPEStationOrder(Job)
    k ^DHCPETemp("StationOrderList",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
	s CurStationID=$O(^DHCPEST(0,"STORD_ARCIM",iARCIMDR,0))                            //Add
	q:CurStationID=""
	q:(StationID'="")&&(StationID'=CurStationID)
	s ItemSub=$O(^DHCPEST(0,"STORD_ARCIM",iARCIMDR,CurStationID,0))                    //Add
	s ItemRowID=CurStationID_"||"_ItemSub                                               //Add
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("ITEM",ItemRowID)              //Add
	q:LocFlag=1                       
	;q:(Type="Item")&&('$D(^DHCPEODR(0,"ARCIM",iARCIMDR)))
	s ^DHCPETemp("StationOrderList",$j,iARCIMDR)=""
	s iARCIMCode=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",1)
	s iARCIMDesc=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",2)
	Q:$G(^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",iARCIMDR))="Y"
	s TUOM=$p($g(^ARCIM(iARCIMDR,1,8)),"^",14)     ;ARCIM_BillingUOM_DR
	i TUOM'="" s TUOM=$p($g(^CT("UOM",TUOM)),"^",2)
	
	//q:((Desc'="")&&(iARCIMDesc'[Desc)) //&&(iARCIMCode'[Desc)
	s OwnFlag=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",13)
	;q:OwnFlag'="Y"
	s Flag=0
	i ST=LabStation d
	.s ItemCatDR=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",10)
	.i ItemCatDR'="" d
	..s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	..i OrderType'="L" s Flag=1
	q:Flag=1
	s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	//s DateFrom=$p($p($G(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",13),"Z",1)
	//Q:(DateFrom'="")&&(DateFrom>+$H) 
	//i EffDate="" s EffDate=+$H+1
	//q:EffDate<+$H
	s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,BType,LocID)
    q:DateShowFlag="Y"
    s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
	q:(HOSPshowFlag="N")

	s VIPLevel=$G(^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",iARCIMDR))
	;i VIPLevel'="" s VIPLevel=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	;w:(VIPLevel'="")&&(vVIPID'="")&&(vVIPID'=VIPLevel) iARCIMDesc_VIPLevel_"a"_vVIPID,!
	;w vVIPID
	q:(VIPLevel'="")&&(vVIPID'="")&&(vVIPID'[VIPLevel)
	
	s PatFeeType=$G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",iARCIMDR,CurLoc))
	i PatFeeType="" s PatFeeType=vPatFeeType
	s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR,"","","","","","","","",PatFeeType)
    i ARCIMPrice="" s ARCIMPrice=0
    i $p(ARCIMPrice,".",1)="" s ARCIMPrice=0_ARCIMPrice
    s STActive=$P(^DHCPEST(CurStationID),"^",5)
    q:STActive'="Y"

    s STSort=$P(^DHCPEST(CurStationID),"^",9)
    s:STSort="" STSort="999999999"
    s STLocInfo=$G(^DHCPEStationOrder("Loc",iARCIMDR))
    i STLocInfo="" d
    .s STLocID="999999999"
    .s STLocSort="999999999"
    .s ItemSort=$P($G(^DHCPEST(CurStationID,"O",ItemSub)),"^",7)
    .i ItemSort="" s ItemSort="999999999"
    e  d
    .s STLocID=$P(STLocInfo,"^",1)
    .s STLocSort=$P($G(^DHCPEST(+STLocID,"STLOC",$P(STLocID,"||",2))),"^",2)
    .s ItemSort=$P(STLocInfo,"^",2)
    .i STLocSort="" s STLocSort="999999999"
    .i ItemSort="" s ItemSort="999999999"
    
    d StationOrderList
    q 
StationOrderList      
	set Data=$lb(iARCIMCode, iARCIMDesc, iARCIMDR, $j(ARCIMPrice,"",2),TUOM)
 	s ^TempDHCPEStationOrder(Job,STSort,CurStationID,STLocSort,STLocID,ItemSort,ItemSub)=Data
    q
OutList
	s Code=$LG(Data,1)
	s Desc=$LG(Data,2)
	s DR=$LG(Data,3)
	s Price=$LG(Data,4)
	s Uom=$LG(Data,5)
	s Data=$LB(Code,Desc,DR,Price,Uom,STDesc)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
/// Creator：	  xy
/// CreatDate：	  20210823
/// Description:  查找体检系统的医嘱项目
/// Table：       站点字典表 DHC_PE_Station,科室站点详情表  DHC_PE_StationSet
/// Input:        Item,Type,TargetFrame,PreIADMID,StationID,BType,LocID,hospId
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","StationOrderList","","Item","PreItemList","","1","B","152","2")
Query StationOrderList(Item As %Library.String = "", Type As %Library.String = "", TargetFrame As %String = "", PreIADMID As %String = "", StationID As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "", ItemID As %String = "") As %Query(ROWSPEC = "STORD_ARCIM_Code:%String:编码, STORD_ARCIM_Desc:%String:名称, STORD_ARCIM_DR:%String:ID, STORD_ARCIM_Price:%String:价格,TUOM:%String:单位,TLocDesc:%String:科室")
{
}

ClassMethod StationOrderListExecute(ByRef qHandle As %Binary, Item As %String = "", Type As %Library.String = "", TargetFrame As %String = "", PreIADMID As %String = "", StationID As %String = "", BType As %String = "", LocID As %String = "", hospId As %String = "", ItemID As %String = "") As %Status
{
	
	//s ^tempdhcpe("StationOrderList",Type,LocID,hospId)=$lb(Item,Type,TargetFrame,PreIADMID,StationID,BType,LocID,hospId)
	
	Set repid=$I(^CacheTemp)
	if (Type="NoShow") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
 	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",LocID)) //检验站点
 	s LabCode=$P($g(^DHCPEST(LabStation)),"^",1)
 	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID)) //其他站点
 	s MedicalStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))  //药品站点
 
 	s vVIPID="",vPatFeeType=""
 	s vPatFeeType=##class(web.DHCPE.VIPLevel).GetPatFeeType(vVIPID,LocID)
 	
 	s PreIADMID=$P(PreIADMID,"^",1)
 	i PreIADMID'="" d
 	.i $L(PreIADMID,"||")>1 d
 	..s vVIPID=$g(^DHCPECBVIPLevel("PGT",PreIADMID))
	..s vPatFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",PreIADMID))
 	.e  d
 	..s vVIPID=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADMID)
 	..s vVIPID=$P(vVIPID,"^",1)
 	..s vPatFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PreIADMID))
 	e  d
 	.s vVIPID=""
 	.s vPatFeeType=""
 	
 	s Job=$J
 	k ^TEMP("DHCPE","StationOrderList",$j)
 	k ^TempDHCPEStationOrder(Job)
 	
 	s ind=1
 	
 	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Item)
 	s Desc=$ZCVT(Desc,"U")
	
 	//查找全部
 	i ""=Desc {
 	s ParRef=0
 	f  s ParRef=$O(^DHCPEST(ParRef)) q:ParRef=""  d
 	.s LocShowDFlag = ##class(User.DHCPEStation).GetLocShowDataFlag(ParRef,LocID)
	.q:LocShowDFlag'="Y"  //过滤——未授权的站点
	.s StatSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,ParRef,0))
	.s Active=""
    .I StatSetID'="" s Active=$lg($g(^CF.PE.StationSetD(StatSetID)),11) 
	.q:Active'="Y" //过滤——未激活的站点
 	.q:(TrakVerison="MedTrak")&&(ParRef=LabStation)
 	.q:(Type="Lab")&&(ParRef'=LabStation)
 	.;q:(Type="Item")&&(ParRef=LabStation)
 	.q:(Type="Item")&&((ParRef=LabStation)||(ParRef=MedicalStation)||(ParRef=OtherStation))
 	.q:(Type="Other")&&(ParRef'=OtherStation)
 	.q:(Type="Medical")&&(ParRef'=MedicalStation)	
 	.s id="0"
 	.f  s id=$o(^DHCPEST(ParRef,"O",id)) q:id=""  d
	..s CurData=$g(^DHCPEST(ParRef,"O",id))
	..//医嘱项ID
	..s iARCIMDR=$p(CurData,"^",1)
	..q:iARCIMDR=""
	..q:iARCIMDR'["||"
	..q:(ItemID'="")&&(iARCIMDR'=ItemID)
	..s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(ParRef_"||"_id,LocID)
    ..q:LocShowDFlag="N"
	..s SOSID=$O(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ParRef_"||"_id,0))
	..q:SOSID=""
	..//就餐
	..s iSTORDDiet=$lg($g(^CF.PE.StationOrderSetD(SOSID)),4)
	..//医嘱套ID
	..s iARCOSDR=$p(CurData,"^",3)
	..s iARCOSDRName=""
	..s:(""'=iARCOSDR) iARCOSDRName=$P($G(^ARCOS(iARCOSDR)),"^",2)
	..//报告格式
    ..s iReportFormats=$lg($g(^CF.PE.StationOrderSetD(SOSID)),5)
	..s ST=+ParRef
	..s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	..;q:CurSort'=""
	..d GetOneInfo
	
 	}
 	// 按别名查
 	if (""'=Desc) {
	 	
	 //模糊查询
	 s ALIASID=0
	 f  s ALIASID=$O(^ARC("ALIAS",ALIASID))  q:ALIASID=""  d
	 .s ALIASText=$p($g(^ARC("ALIAS",ALIASID)),"^",6)
	 .s ALIASDesc=$p(^ARC("ALIAS",ALIASID),"^",3)
	 .q:(ALIASText'[Desc)&&(ALIASDesc'[Desc)
	 .s ALIASType=$P(^ARC("ALIAS",ALIASID),"^",5)
	 .s iARCIMDR=""
	 .s ALIASRowCalc=$P(^ARC("ALIAS",ALIASID),"^",1)
	.i ("ARCIM"=ALIASType) d
	..// 根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ALIASRowCalc,LocID)
	..s STRowId=$p(StatOrderID,"||",1)
	..q:STRowId=""
	..s Childsub=$p(StatOrderID,"||",2)
	..q:(""=Childsub)
	..q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	..q:(Type="Lab")&&(STRowId'=LabStation)
 	..;q:(Type="Item")&&(STRowId=LabStation)
 	..q:(Type="Item")&&((STRowId=LabStation)||(STRowId=MedicalStation)||(STRowId=OtherStation))
 	..q:(Type="Other")&&(STRowId'=OtherStation)
 	..q:(Type="Medical")&&(STRowId'=MedicalStation)
	..s iARCIMDR=ALIASRowCalc
	.i "ARCOS"=ALIASType d
	..s STRowId=$O(^DHCPEST(0,"STORD_ARCOS",ALIASRowCalc,""))
	..q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	..q:(""=STRowId)
	..q:(Type="Lab")&&(STRowId'=LabStation)
 	..;q:(Type="Item")&&(STRowId=LabStation)
 	..q:(Type="Item")&&((STRowId=LabStation)||(STRowId=MedicalStation)||(STRowId=OtherStation))
 	..q:(Type="Other")&&(STRowId'=OtherStation)
 	..q:(Type="Medical")&&(STRowId'=MedicalStation)
	..s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	..q:(""=Childsub)
	..s iARCIMDR=$P($G(^DHCPEST(STRowId,"O",Childsub)),"^",1)
	..
	.q:(""=iARCIMDR)
	.q:(ItemID'="")&&(iARCIMDR'=ItemID)
	.s SOSID=$O(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,STRowId_"||"_Childsub,0))
	.q:SOSID=""
	.s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(STRowId_"||"_Childsub,LocID)
    .q:LocShowDFlag="N"
	.s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	.;q:CurSort'=""
	.q:$D(^TEMP("DHCPE","StationOrderList",$j,iARCIMDR))
	.s ST=STRowId
	.d GetOneInfo	
	 /*
 	s ALIASText=$O(^ARC("ALIAS",0,"Desc",Desc),-1)
	f  s ALIASText=$O(^ARC("ALIAS",0,"Desc",ALIASText)) Q:(""=ALIASText)||(ALIASText'[Desc)  d
	.s ALIASDesc=""  
	.f  s ALIASDesc=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc)) Q:(""=ALIASDesc)  d
	..s ALIASRowId=""
	..f  s ALIASRowId=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc, ALIASRowId)) Q:(""=ALIASRowId)  d
	...s CurData=$G(^ARC("ALIAS", 0, "Desc", ALIASText, ALIASDesc, ALIASRowId,1))
	...// ALIAS_Type
	...s ALIASType=$P(CurData,"^",2)
	...// ALIAS_Row_Calc
	...s ALIASRowCalc=$P(CurData,"^",1)
	...s iARCIMDR=""
	...i ("ARCIM"=ALIASType) d
	....// 根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	....s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ALIASRowCalc,LocID)
	....s STRowId=$p(StatOrderID,"||",1)
	....q:STRowId=""
	....s Childsub=$p(StatOrderID,"||",2)
	....q:(""=Childsub)
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....;q:(Type="Item")&&(STRowId=LabStation)
 	....q:(Type="Item")&&((STRowId=LabStation)||(STRowId=MedicalStation)||(STRowId=OtherStation))
 	....q:(Type="Other")&&(STRowId'=OtherStation)
 	....q:(Type="Medical")&&(STRowId'=MedicalStation)
	....s iARCIMDR=ALIASRowCalc
	...i "ARCOS"=ALIASType d
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCOS",ALIASRowCalc,""))
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....q:(""=STRowId)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....;q:(Type="Item")&&(STRowId=LabStation)
 	....q:(Type="Item")&&((STRowId=LabStation)||(STRowId=MedicalStation)||(STRowId=OtherStation))
 	....q:(Type="Other")&&(STRowId'=OtherStation)
 	....q:(Type="Medical")&&(STRowId'=MedicalStation)
	....s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	....q:(""=Childsub)
	....s iARCIMDR=$P($G(^DHCPEST(STRowId,"O",Childsub)),"^",1)
	...
	...q:(""=iARCIMDR)
	...q:(ItemID'="")&&(iARCIMDR'=ItemID)
	...s SOSID=$O(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,STRowId_"||"_Childsub,0))
	...q:SOSID=""
	...s LocShowDFlag=##class(User.DHCPEStationOrder).GetLocShowDataFlag(STRowId_"||"_Childsub,LocID)
    ...q:LocShowDFlag="N"
	...s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	...;q:CurSort'=""
	...q:$D(^TEMP("DHCPE","StationOrderList",$j,iARCIMDR))
	...s ST=STRowId
	...d GetOneInfo
	*/
	
 	}
 	
 	s STSort=""
 	f  s STSort=$O(^TempDHCPEStationOrder(Job,STSort)) q:STSort=""  d
 	.s StationID=""
 	.f  s StationID=$O(^TempDHCPEStationOrder(Job,STSort,StationID)) q:StationID=""  d
 	..s STCode=$P(^DHCPEST(LabStation),"^",1)
 	..s STLocSort=""
 	..f  s STLocSort=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort)) q:STLocSort=""  d
 	...s STLocID=""
 	...f  s STLocID=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID)) q:STLocID=""  d
 	....i $L(STLocID,"||")>1 d
 	.....s STDesc=$P($G(^DHCPEST(+STLocID,"STLOC",$P(STLocID,"||",2))),"^",1)
 	....e  d
 	.....s STDesc=$P(^DHCPEST(StationID),"^",2)
 	....s i=0
 	....s ItemSort=""
 	....f  s ItemSort=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort)) q:ItemSort=""  d
 	.....s ItemSub=""
 	.....f  s ItemSub=$O(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort,ItemSub)) q:ItemSub=""  d
 	......s:i>0 STDesc=""
 	......s i=i+1
 	......s Data=$G(^TempDHCPEStationOrder(Job,STSort,StationID,STLocSort,STLocID,ItemSort,ItemSub))
 	......d OutList
 	
	k ^TempDHCPEStationOrder(Job)
    k ^TEMP("DHCPE","StationOrderList",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    //s Data=$LB(Code,Desc,DR,Price,Uom,STDesc)


GetOneInfo
	
	// 根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	s ItemRowID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(iARCIMDR,LocID)
	q:ItemRowID=""
	s ItemActive=$p($g(^DHCPEST(+ItemRowID,"O",$p(ItemRowID,"||",2))),"^",9)
	q:ItemActive'="Y"
	s CurStationID=$p(ItemRowID,"||",1)
	s ItemSub=$p(ItemRowID,"||",2)
	q:(StationID'="")&&(StationID'=CurStationID)                                      
	s LocPowerFlg = ##class(User.DHCPEStation).GetLocShowDataFlag(CurStationID,LocID)
    q:LocPowerFlg'="Y"                      
	s ^TEMP("DHCPE","StationOrderList",$j,iARCIMDR)=""
	s iARCIMCode=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",1)
	s iARCIMDesc=$p($g(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1)),"^",2)
	s ShowOrHide=$lg($g(^CF.PE.StationOrderSetD(SOSID)),21)
	q:ShowOrHide="Y"     //禁用 
	//药品单位  ARCIM_BillingUOM_DR
	s TUOM=$p($g(^ARCIM(iARCIMDR,1,8)),"^",14)     
	i TUOM'="" s TUOM=$p($g(^CT("UOM",TUOM)),"^",2)
	
    //是否独立医嘱
	s OwnFlag=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",13)
	;q:OwnFlag'="Y"
	
	s Flag=0
	i ST=LabStation d
	.s ItemCatDR=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",10)
	.i ItemCatDR'="" d
	..s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	..i OrderType'="L" s Flag=1
	q:Flag=1
	
	s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",iARCIMDR,BType,LocID)
    q:DateShowFlag="Y"
    s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",iARCIMDR,hospId)
	q:(HOSPshowFlag="N")

	//vip等级
	s VIPLevel=$lg($g(^CF.PE.StationOrderSetD(SOSID)),13)
	q:(VIPLevel'="")&&(vVIPID'="")&&(vVIPID'[VIPLevel)
	
	//特殊项目
	s PatFeeType=$lg($g(^CF.PE.StationOrderSetD(SOSID)),20)
	i PatFeeType="" s PatFeeType=vPatFeeType
	
	//医嘱价格
	s ARCIMPrice=0
	s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR,"","","","","","","","",PatFeeType,LocID)
    i ARCIMPrice="" s ARCIMPrice=0
    i $p(ARCIMPrice,".",1)="" s ARCIMPrice=0_ARCIMPrice
    
    //站点激活状态
    s STActive="N"
    i CurStationID'="" d
    .s SSID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,CurStationID,0))
    .s STActive=$lg($g(^CF.PE.StationSetD(SSID)),11)
    q:STActive'="Y"

    
    //站点报告顺序
    s STSort=$lg($g(^CF.PE.StationSetD(SSID)),9)
    s:STSort="" STSort="999999999"
    
    //站点分类项目序号（DHC_PE_StationOrderSort）
    //顺序显示：站点顺序——站点分类顺序——项目顺序
    s STLocPowerFlag="Y"
    s STLocInfo="",SortID=""
    s STOrdCatSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",ItemRowID,0))
    i STOrdCatSortID'="" d
    .s STLocID=$lg($g(^CF.PE.StationOrdSortD(STOrdCatSortID)),2) 
    .s STLocPowerFlag = ##class(User.DHCPEStationLoc).GetLocShowDataFlag(STLocID,LocID)
    .s STOrdSortID=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",ItemRowID,STOrdCatSortID,0))
    .s SortID=STOrdCatSortID_"||"_STOrdSortID
    //站点分类显示有效授权的
    q:STLocPowerFlag'="Y"
    
    //SortID(站点分类项目序号表ID——DHC_PE_StationOrderSort)
    s SOSLocPowerFlag="Y"
    i SortID'="" d
    .s STLocInfo=$g(^CF.PE.StationOrdSortD($p(SortID,"||",1),"ORD",$p(SortID,"||",2)))
    .s SOSLocPowerFlag = ##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(SortID,LocID)  
    //站点分类项目显示有效授权的
    q:SOSLocPowerFlag'="Y" 
    
    i STLocInfo="" d
    .s STLocID="999999999"
    .s STLocSort="999999999"
    .//项目顺序(站点项目组合扩展表——DHC_PE_StationOrderSet)
    .s ItemSort=$lg($g(^CF.PE.StationOrderSetD(SOSID)),8) 
    .i ItemSort="" s ItemSort="999999999"
    e  d
    .//站点分类ID
    .s STLocID=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),2) 
    .//站点分类顺序
    .s STLocSort=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1))),3)   
    .//站点分类项目顺序 
    .s ItemSort=$lg($g(^CF.PE.StationOrdSortD($p(SortID,"||",1),"ORD",$p(SortID,"||",2))),3)
    .i STLocSort="" s STLocSort="999999999"
    .i ItemSort="" s ItemSort="999999999"
   
    d StationOrderList
    q 
StationOrderList      
    d TranslationNew
	set Data=$lb(iARCIMCode, iARCIMDesc, iARCIMDR, $j(ARCIMPrice,"",2),TUOM)
 	s ^TempDHCPEStationOrder(Job,STSort,CurStationID,STLocSort,STLocID,ItemSort,ItemSub)=Data
    q
Translation
    s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",Desc,"ARCIMDesc","cls")
    s STDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationLoc",STDesc,"STLLocDesc","cls")
    Q
TranslationNew
    s iARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",iARCIMDesc,"ARCIMDesc","cls")
    Q
OutList
	s Code=$LG(Data,1)
	s Desc=$LG(Data,2)
	s DR=$LG(Data,3)
	s Price=$LG(Data,4)
	s Uom=$LG(Data,5)
    d Translation
	s Data=$LB(Code,Desc,DR,Price,Uom,STDesc)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod StationOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationOrderListExecute ]
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

ClassMethod StationOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 提供给Web页面 检验医嘱列表 给DHCPEStationOrderCom组件的“项目编码”查询列表输入框用
/// 更新函数 具有跟新（修改）和插入的功能 
/// d ##class(web.DHCPE.StationOrder).Save("","","10^^^3870||1^N^215^")
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	/*
    s ParRef=$p(InString,"^",1)
    //s RowId=$p(InString,"^",2)    //无法传入 特殊处理 位置预留
    s ChildSub=$p(InString,"^",3)    
    s RowId=ParRef_"||"_ChildSub     
    s ARCIM=$p(InString,"^",4)
    s STORDDiet=$p(InString,"^",5)
    */
    s loc=%session.Get("LOGON.CTLOCID")
   
    // STORD_ParRef
    s PLIST(0)=$p(InString,"^",1)
    
    // STORD_RowId
    //s PLIST(1)=$p(InString,"^",2)    //无法传入 特殊处理 位置预留
    
    // STORD_ChildSub
    s PLIST(3)=$p(InString,"^",3)    
    
    s PLIST(1)=PLIST(0)_"||"_PLIST(3)
    
    // STORD_ARCIM_DR
    s PLIST(4)=$p(InString,"^",4)
    
    // STORD_Diet
    s PLIST(5)=$p(InString,"^",5)

    // STORD_ARCOS_DR
    s PLIST(6)=$p(InString,"^",6)
   
    // STORD_ReportFormat
    s PLIST(7)=$p(InString,"^",7)
    
    // 	STORD_Notice
    s PLIST(8)=$p(InString,"^",8)
    
    // 自动回传
    s PLIST(9) =$p(InString,"^",9)
    
     s SignItem =$p(InString,"^",10)
    
    s PhotoItem =$p(InString,"^",11)    //心电图胶片
    
    s TempName =$p(InString,"^",12)    //检查告知单模版
    //导检单打印顺序
    s PatItemName =$p(InString,"^",13)
 	
 	//是否继承上次结果
 	s ExtendItem =$p(InString,"^",14) 
    //是否可以预约项目
    s ShowOrHide =$p(InString,"^",15)
    s YGCheck =$p(InString,"^",16) //乙肝检查
    s SpecialItem =$p(InString,"^",17) //特需项目
    s Minute=$p(InString,"^",18) //检查时间
    
    s Sex=$p(InString,"^",19)
    //报告打印顺序
    s ReportItemName =$p(InString,"^",20)
    // 序号
    s PLIST(10) =$p(InString,"^",21)
   // 基本信息条码
    s BaseInfoBar =$p(InString,"^",22)
    s patprintorder=$p(InString,"^",23)
    s ifprint=$p(InString,"^",24)
    s VIPLevelType=$p(InString,"^",25)  //add by yd20131021
    s PreNum=$p(InString,"^",26)
    s PISCode=$p(InString,"^",27) //病理标本类型
    s AlowAddFlag=$p(InString,"^",28) //允许重复
    s AgeMax=$p(InString,"^",29) //年龄上限
    s AgeMin=$p(InString,"^",30) //年龄下限
    s MarriedDR=$p(InString,"^",31) //婚姻
    s PrintName=$p(InString,"^",32) //打印名称（导诊单）
    s BarPrintNum=$p(InString,"^",33) //条码数量
    s IFReprotPrint=$p(InString,"^",34) //是否打印（报告）
    s ret=..ISave2($G(PLIST(0)),$G(PLIST(3)),$g(SignItem),$g(PhotoItem))
	
	i ret="0" d
 	.s ^DHCPECTDataEx("PatItemSort",PLIST(4))=PatItemName_"^"_patprintorder_"^"_ifprint_"^"_PrintName
	.s ^DHCPECTDataEx("DHCPEStationOrder","TempName",PLIST(4))=TempName
    .s ^DHCPECTDataEx("YGFlag",PLIST(4))=YGCheck  //add by zl0830
	.s ^DHCPECTDataEx("DHCPEStationOrder","Extend",PLIST(4))=ExtendItem
	.s ^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",PLIST(4),loc)=PLIST(8)
	.s ^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",PLIST(4))=ShowOrHide
	.s ^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",PLIST(4),loc)=SpecialItem  //add by zl0830
	.s ^DHCPECTDataEx("DHCPEStationOrder","Minute",PLIST(4),loc)=Minute
	.s ^DHCPECTDataEx("DHCPEStationOrder","Sex",PLIST(4))=Sex
	.s ^DHCPECTDataEx("DHCPEStationOrder","Photo",PLIST(4))=PhotoItem
	.s ^DHCPECTDataEx("DHCPEStationOrder","SignItem",PLIST(4))=SignItem
	.s ^DHCPECTDataEx("ReportItemSort",PLIST(4))=ReportItemName
	.s ^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",PLIST(4))=BaseInfoBar
	.s ^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",PLIST(4))=VIPLevelType     //add by yd20131021
	.S ^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",PLIST(4))=PISCode   //病理标本类型
	.S ^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",PLIST(4))=AlowAddFlag  //允许重复
	.s ^DHCPECTDataEx("DHCPEStationOrder","Age",PLIST(4))=AgeMin_"^"_AgeMax //年龄
	.s ^DHCPECTDataEx("DHCPEStationOrder","Married",PLIST(4))=MarriedDR //婚姻
	.s ^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",PLIST(4))=BarPrintNum //条码数量
	.s ^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",PLIST(4))=IFReprotPrint //是否打印（报告）
	


	.i PreNum="" d
	..k ^DHCPECTDataEx("DHCPEStationOrder","PreNum",PLIST(4))
	.e  d
	..s ^DHCPECTDataEx("DHCPEStationOrder","PreNum",PLIST(4))=PreNum
	q ret
}

ClassMethod DeleteOther(ARCIMDR)
{
	s loc=%session.Get("LOGON.CTLOCID")
	s PLIST(4)=ARCIMDR
	k ^DHCPECTDataEx("PatItemSort",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","TempName",PLIST(4))
    k ^DHCPECTDataEx("YGFlag",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","Extend",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",PLIST(4),loc)
	k ^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",PLIST(4),loc)
	k ^DHCPECTDataEx("DHCPEStationOrder","Minute",PLIST(4),loc)
	k ^DHCPECTDataEx("DHCPEStationOrder","Sex",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","Photo",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","Sign",PLIST(4))
	k ^DHCPECTDataEx("ReportItemSort",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","SignItem",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",PLIST(4))
	K ^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",PLIST(4))
	K ^DHCPECTDataEx("DHCPEStationOrder","Age",PLIST(4))
	K ^DHCPECTDataEx("DHCPEStationOrder","Married",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",PLIST(4))
	k ^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",PLIST(4))
}

/// 删除函数 
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ParRef As %Library.String = "", ChildSub As %Library.String = "")
{
    
    k ^DHCPECTDataEx("DHCPEStationOrder","Sign",ParRef_"||"_ChildSub)
    
    k ^DHCPECTDataEx("DHCPEStationOrder","Photo",ParRef_"||"_ChildSub)
   

	Q:(""=ParRef)&(""=ChildSub) "Err 01"
	s RowId=ParRef_"||"_ChildSub
	// 删除关联项
	s STORDARCIMDR=$P($G(^DHCPEST(ParRef,"O",ChildSub)),"^",1)
	d ..DeleteOther(STORDARCIMDR)
	/*
	&sql(
	     delete from DHC_PE_OrderDetailRelate 
	     where ODR_ARCIM_DR=:STORDARCIMDR
	     )
	Q:'(("0"=SQLCODE)||("100"=SQLCODE)) "Err 02"
	*/
	//where STORD_ParRef=:ParRef and STORD_Childsub=:ChildSub
	&sql(
		delete from DHC_PE_StationOrder 
		where STORD_RowId=:RowId
	     )
	     
	q SQLCODE
}

/// 更新数据接口（对象）函数 给出RowId 的更改数据 没有RowId传入的将数据插入数据库
ClassMethod ISave(ParRef As %String, RowId As %String, Childsub As %String, ARCIM As %String, STORDDiet As %String)
{

	s ReturnFlag=""
	i ""=Childsub d
	.s ReturnFlag=..Insert(ParRef, RowId, Childsub, ARCIM, STORDDiet)
	e  d
	.s ReturnFlag=..Update(ParRef, RowId, Childsub, ARCIM, STORDDiet)
	q ReturnFlag
}

/// 更新数据接口（对象）函数 给出RowId 的更改数据 没有RowId传入的将数据插入数据库
ClassMethod ISave2(ParRef As %String, Childsub As %String, SignItem As %String, PhotoItem As %String)
{

	s ReturnFlag=""
	k ^ZL
	s ^ZL=PLIST(3)
	i ""=PLIST(3) d
	.s ReturnFlag=..Insert2(ParRef,Childsub,SignItem,PhotoItem)
	e  d
	.//s ReturnFlag="Update2"
	.s ReturnFlag=..Update2(ParRef,Childsub,SignItem,PhotoItem)
	q ReturnFlag
}

/// 插入新的记录
ClassMethod Insert(ParRef As %String, RowId As %String, ChildSub As %String, ARCIM As %String, STORDDiet As %String)
{

	&sql(insert into DHC_PE_StationOrder(STORD_ParRef, STORD_ARCIM_DR, STORD_Diet)
	     values(:ParRef, :ARCIM, :STORDDiet)
	     )	     
	q SQLCODE
}

/// 插入新的记录
ClassMethod Insert2(ParRef, Childsub, SignItem, PhotoItem)
{
	b //Insert2
	k PLIST(1)
	k PLIST(3)
    &sql(select STORD_ARCIM_DR into :id from DHC_PE_StationOrder where STORD_ARCIM_DR=:PLIST(4))
    //if SQLCODE=0 d  &javascript<alert("此项目已经存在！")> q SQLCODE
     if SQLCODE=0 q "此项目已经存在！"
	&sql(insert into DHC_PE_StationOrder
	     values :PLIST())
	i SignItem="Y"  d    
	.s ^DHCPECTDataEx("DHCPEStationOrder","Sign",%ROWID)=SignItem
	i PhotoItem="Y"  d    
	.s ^DHCPECTDataEx("DHCPEStationOrder","Photo",%ROWID)=PhotoItem
	d ..InsertArcDetail(PLIST(4), PLIST(0), $P(PLIST(7),"_",2), "")
	q SQLCODE
}

/// 检查指定的记录是否存在
ClassMethod OrderDetailIsExist(ParRef As %String, ChildSub As %String)
{
	s RecordCount=0
	&sql(
		select count(*) into :RecordCount
		from DHC_PE_StationOrder 
		where STORD_ParRef=:ParRef and STORD_Childsub=:ChildSub
	)
    q RecordCount
}

/// 更改数据
ClassMethod Update(ParRef As %String, RowId As %String, ChildSub As %String, ARCIM As %String, STORDDiet As %String)
{

	&sql(update DHC_PE_StationOrder
	     set STORD_Diet =:STORDDiet
	     where STORD_ParRef=:ParRef and STORD_Childsub=:ChildSub
	     )
	 q SQLCODE
}

/// 更改数据
ClassMethod Update2(ParRef, Childsub, SignItem, PhotoItem)
{
	b // Update2
	s ParRef=PLIST(0)
	s ChildSub=PLIST(3)
	s RowId=ParRef_"||"_ChildSub
	k PLIST(0)
	k PLIST(1)
	k PLIST(3)
	
	//STORD_ParRef=:ParRef and STORD_Childsub=:ChildSub
  s ^DHCPECTDataEx("DHCPEStationOrder","Sign",ParRef_"||"_Childsub)=SignItem
  i SignItem'="Y"  d
  .k ^DHCPECTDataEx("DHCPEStationOrder","Sign",ParRef_"||"_ChildSub)
  s ^DHCPECTDataEx("DHCPEStationOrder","Photo",ParRef_"||"_Childsub)=PhotoItem
  i PhotoItem'="Y"  d
  .k ^DHCPECTDataEx("DHCPEStationOrder","Photo",ParRef_"||"_ChildSub)
  &sql(update DHC_PE_StationOrder
	     values :PLIST()
	     where STORD_Rowid=:RowId
	     )
	     

	q SQLCODE
}

/// 显示打印格式
/// d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","SearchReportFormat")
Query SearchReportFormat() As %Query(ROWSPEC = "ReportFormat:%String:格式, ReportFormat_desc:%String:描述")
{
}

ClassMethod SearchReportFormatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s RFid=""
 	
 	s RF="RF_CAT", RFDesc="打印格式 多层"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
    
 	s RF="RF_LIS", RFDesc="打印格式 检验"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
    
 	s RF="RF_NOR", RFDesc="打印格式 默认"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut

 	s RF="RF_RIS", RFDesc="打印格式 检查"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
    
    s RF="RF_EKG", RFDesc="打印格式 心电"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
	s RF="RF_PIS", RFDesc="打印格式 病理"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
    
    /*
    s RF="RF_AREA", RFDesc="打印格式 区域"
    set Data=$lb(RF, RFDesc)
    d SearchReportFormatOut
    */
    
    
 	/*
	f  s RFid=$O(^DHCPESetting("DHCPE",RFid)) q:(""=RFid)  d
	.Q:(RFid'["RF_")
	.s RF=$G(^DHCPESetting("DHCPE",RFid))
	.s RFDesc=$G(^DHCPESetting("DHCPE",RFid,"Desc"))
	.
    .set Data=$lb(RF, RFDesc)
    .
    .d SearchReportFormatOut
	// 打印格式
	s ^DHCPESetting("DHCPE","RF_Cat")="RF_Cat_NORMAL"
	s ^DHCPESetting("DHCPE","RF_Cat","Desc")="打印格式 多层"
	s ^DHCPESetting("DHCPE","RF_LIS")="RF_LIS_NORNAL"
	s ^DHCPESetting("DHCPE","RF_LIS","Desc")="打印格式 检验"
	s ^DHCPESetting("DHCPE","RF_NOR")="RF_NORMAL"
	s ^DHCPESetting("DHCPE","RF_NOR","Desc")="打印格式 默认"
	s ^DHCPESetting("DHCPE","RF_RIS")="RF_RIS_NORNAL"
	s ^DHCPESetting("DHCPE","RF_RIS","Desc")="打印格式 检查"
	*/
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchReportFormatOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchReportFormatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchReportFormatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchReportFormatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchReportFormatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query ArcItmmastListNew(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", ID As %Library.String = "") As %Query(ROWSPEC = "STORD_ARCIM_Code:%String:编码,STORD_ARCIM_Desc:%String:名称,STORD_ARCIM_DR:%String:ID") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","ArcItmmastListNew")
ClassMethod ArcItmmastListNewExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", ID As %Library.String = "") As %Status
{
	new arcimCode,arcimDesc,arcimRowId,arcimSub,arcimVer,arcimFrom,arcimTo
	new time,tmp,tmpdesc,errs,i
	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1

	s time=$h
	k ^TEMP("DHCPE","ArcItmmastListNew",time,$j)
	
 	s errs=""
 	s i=1
 	i Desc=""  
 	{
	 	s arcimSub=0
	 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:(arcimSub="")  d
	 	.s arcimVer="" 
	 	.f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:(arcimVer="")  d
 		..d OutArcItmmastList
 	} 	
	else
	{
		s tmp=$o(^ARCIM(0,"Code",$ZCONVERT(Desc,"U")),-1)		
		f  s tmp=$o(^ARCIM(0,"Code",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s arcimSub=0
		.f  s arcimSub=$o(^ARCIM(0,"Code",tmp,arcimSub)) q:(arcimSub="")  d
	 	..s arcimVer=""
	 	..f  s arcimVer=$o(^ARCIM(0,"Code",tmp,arcimSub,arcimVer)) q:(arcimVer="")  d
 		...d OutArcItmmastList
 		
 		s tmp=$o(^ARCIM(0,"Desc",$ZCONVERT(Desc,"U")),-1)
 		f  s tmp=$o(^ARCIM(0,"Desc",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s arcimSub=0
		.f  s arcimSub=$o(^ARCIM(0,"Desc",tmp,arcimSub)) q:(arcimSub="")  d
	 	..s arcimVer=""
	 	..f  s arcimVer=$o(^ARCIM(0,"Desc",tmp,arcimSub,arcimVer)) q:(arcimVer="")  d
 		...d OutArcItmmastList
 		
 		s tmp=$o(^ARC("ALIAS",0,"Desc",$ZCONVERT(Desc,"U")),-1)
 		f  s tmp=$o(^ARC("ALIAS",0,"Desc",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s tmpdesc=""
		.f  s tmpdesc=$o(^ARC("ALIAS",0,"Desc",tmp,tmpdesc)) q:(tmpdesc="")  d
		..s aliasId=0
		..f  s aliasId=$o(^ARC("ALIAS",0,"Desc",tmp,tmpdesc,aliasId)) q:(aliasId="")  d
		...s arcimRowId=$p($g(^ARC("ALIAS",aliasId)),"^",1)
		...s arcimSub=$p(arcimRowId,"||",1)
		...s arcimVer=$p(arcimRowId,"||",2)
		...d OutArcItmmastList	 	
	}	
	
	
 	k ^TEMP("DHCPE","ArcItmmastListNew",time,$j)
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutArcItmmastList	
	q:((arcimSub="")||(arcimVer=""))
	s arcimRowId=arcimSub_"||"_arcimVer
	q:(ID'="")&&(arcimRowId'=ID)
	q:$g(^TEMP("DHCPE","ArcItmmastListNew",time,$j,arcimRowId))'=""
	
	s arcimCode=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",1)
	s arcimDesc=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)
	s arcimTo=$p($g(^ARCIM(arcimSub,arcimVer,7)),"^",1)

	s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",arcimRowId,Type,LocID)
    q:DateShowFlag="Y"
    s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",arcimRowId,hospId)
	q:(HOSPshowFlag="N")
	s ^TEMP("DHCPE","ArcItmmastListNew",time,$j,arcimRowId)=1
	
	set Data=$lb(arcimCode,arcimDesc,arcimRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArcItmmastListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcItmmastListNewExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ArcItmmastListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcItmmastListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query ArcItmmastList(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", ID As %Library.String = "") As %Query(ROWSPEC = "STORD_ARCIM_Code:%String:编码,STORD_ARCIM_Desc:%String:名称,STORD_ARCIM_DR:%String:ID,STORD_ARCIM_Price:%String:价格") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.StationOrder","ArcItmmastList","","",105)
ClassMethod ArcItmmastListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "", ID As %Library.String = "") As %Status
{
	new arcimCode,arcimDesc,arcimRowId,arcimSub,arcimVer,arcimFrom,arcimTo
	new time,tmp,tmpdesc,errs,i
	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1

	s time=$h
	k ^TEMP("DHCPE","ArcItmmastList",time,$j)
 	s errs=""
 	s i=1
 	i Desc=""  
 	{
	 	s arcimSub=0
	 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:(arcimSub="")  d
	 	.s arcimVer="" 
	 	.f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:(arcimVer="")  d
 		..d OutInvPrt
 	} 	
	else
	{
		s tmp=$o(^ARCIM(0,"Code",$ZCONVERT(Desc,"U")),-1)		
		f  s tmp=$o(^ARCIM(0,"Code",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s arcimSub=0
		.f  s arcimSub=$o(^ARCIM(0,"Code",tmp,arcimSub)) q:(arcimSub="")  d
	 	..s arcimVer=""
	 	..f  s arcimVer=$o(^ARCIM(0,"Code",tmp,arcimSub,arcimVer)) q:(arcimVer="")  d
 		...d OutInvPrt
 		
 		s tmp=$o(^ARCIM(0,"Desc",$ZCONVERT(Desc,"U")),-1)
 		f  s tmp=$o(^ARCIM(0,"Desc",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s arcimSub=0
		.f  s arcimSub=$o(^ARCIM(0,"Desc",tmp,arcimSub)) q:(arcimSub="")  d
	 	..s arcimVer=""
	 	..f  s arcimVer=$o(^ARCIM(0,"Desc",tmp,arcimSub,arcimVer)) q:(arcimVer="")  d
 		...d OutInvPrt
 		
 		s tmp=$o(^ARC("ALIAS",0,"Desc",$ZCONVERT(Desc,"U")),-1)
 		f  s tmp=$o(^ARC("ALIAS",0,"Desc",tmp)) q:((tmp="")||(tmp'[$ZCONVERT(Desc,"U")))  d
		.s tmpdesc=""
		.f  s tmpdesc=$o(^ARC("ALIAS",0,"Desc",tmp,tmpdesc)) q:(tmpdesc="")  d
		..s aliasId=0
		..f  s aliasId=$o(^ARC("ALIAS",0,"Desc",tmp,tmpdesc,aliasId)) q:(aliasId="")  d
		...s arcimRowId=$p($g(^ARC("ALIAS",aliasId)),"^",1)
		...s arcimSub=$p(arcimRowId,"||",1)
		...s arcimVer=$p(arcimRowId,"||",2)
		...d OutInvPrt	 	
	}	
	
	
 	k ^TEMP("DHCPE","ArcItmmastList",time,$j)
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutInvPrt	
	q:((arcimSub="")||(arcimVer=""))
	s arcimRowId=arcimSub_"||"_arcimVer
	q:(ID'="")&&(arcimRowId'=ID)
	q:$g(^TEMP("DHCPE","ArcItmmastList",time,$j,arcimRowId))'=""
	
	s arcimCode=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",1)
	s arcimDesc=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)
	s arcimTo=$p($g(^ARCIM(arcimSub,arcimVer,7)),"^",1)
	;if arcimTo'=""	q:(arcimTo<+$h)
	s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("ARC_ItmMast",arcimRowId,Type,LocID)
    q:DateShowFlag="Y"
    s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",arcimRowId,hospId)
	q:(HOSPshowFlag="N")
	s arcimPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(arcimRowId,"","","","","","","","","",LocID)
	s ^TEMP("DHCPE","ArcItmmastList",time,$j,arcimRowId)=1
	
	i Type="B" s arcimDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",arcimDesc,"ARCIMDesc","cls")
	set Data=$lb(arcimCode,arcimDesc,arcimRowId,arcimPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArcItmmastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcItmmastListExecute ]
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

ClassMethod ArcItmmastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcItmmastListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///  根据细项以及大项插入对照      
///    
ClassMethod InsertOrderRelate()
{
	s Station=0
	f  s Station=$o(^DHCPEST(Station)) q:Station=""  d
	.s Sub=0
	.f  s Sub=$o(^DHCPEST(Station,"O",Sub)) q:Sub=""  d
	..s ARCIMID=$P(^DHCPEST(Station,"O",Sub),"^",1)
	..q:ARCIMID=""
	..s DSub=0
	..s i=0
	..f  s DSub=$o(^DHCPEST(Station,"OD",DSub)) q:DSub=""  d
	...s i=i+1
	...s Sequence=Station_$E("0000",1,4-$l(i))_i
	...s ODID=Station_"||"_DSub
	...k PLIST
	...s PLIST(2)=ARCIMID
	...s PLIST(3)=ODID
	...s PLIST(4)=Sequence
	...s PLIST(5)="N"
	...&SQL(insert into sqluser.DHC_PE_OrderDetailRelate values :PLIST())
}

/// 更新大项细项对照站点的顺序号
/// w ##class(web.DHCPE.StationOrder).UpdateODRSequence(StationID)
ClassMethod UpdateODRSequence(StationID)
{
	&SQL(update sqluser.DHC_PE_OrderDetailRelate set ODR_Sequence=ODR_RowId where ODR_OD_DR->OD_ParRef=:StationID and ODR_Sequence is null)
	i SQLCODE= 100 s SQLCODE=0
	q SQLCODE
}

/// d ##class(web.DHCPE.StationOrder).UpdateODStarnd(3,2)
/// 根新细项选择
ClassMethod UpdateODStarnd()
{
	s Strings1="5,1#正常&^拒绝检查&^外阴炎&^外阴溃疡&^外阴湿疹&^外阴白色病变&^外阴静脉曲张&^巴氏腺囊肿&^巴氏腺脓肿&^外阴尖锐湿疣&^外阴疣状物&^外阴肿物&^尿道肉阜&%5,2#正常&^拒绝检查&^细菌性阴道炎&^滴虫性阴道炎&^霉菌性阴道炎&^老年性阴道炎&^阴道前壁膨出&^阴道后壁膨出&^阴道横隔&^阴道纵隔&^阴道狭窄&^阴道疣状物&^阴道尖锐湿疣&^阴道赘生物&^阴道肿外物&^阴道囊肿&^阴道断端正常&%5,3#宫颈光滑&^拒绝检查&^宫颈缺如&^宫颈萎缩&^宫颈轻糜&^宫颈中糜&^宫颈重糜&^宫颈单个纳囊&^宫颈多个纳囊&^宫颈肥大&^宫颈息肉&^宫颈裂伤&^宫颈外翻&^宫颈白癍&^宫内环&^宫颈疣状物&^宫颈尖锐湿疣&^宫颈接触出血&^宫颈肿物&%5,4#正常大小&^盆腔空虚&^子宫缺如&^子宫&前位 中位 后位;饱满 萎缩;稍大 稍小 增大&^子宫肌瘤&^子宫黏膜下肌瘤&^子宫浆膜下肌瘤&^子宫肌壁间肌瘤&^子宫多发肌瘤&^子宫后壁结节&^子宫腺肌症&(  )度^子宫脱垂&I度 I度 III度^宫内环&位置:正常 下移 绝经后^触诊不满意&^拒绝检查&%5,5#正常&^左侧缺如&^右侧缺如&^左侧增厚&^右侧增厚&^附件肿物&大小;囊性 实性;活动:不活动;压痛:有 无;左侧 右侧^慢性附件炎&增厚;压痛;左侧 右侧^慢性盆腔炎&^盆腔积液&^卵巢巧克力囊肿&大小:(  )cm;左侧 右侧^触诊不满意&^拒绝检查&%6,1#正常&^红肿&^疥肿&^溃疡&^新生物&%6,2#正常&^红肿&^疥肿&^溃疡&^新生物&%6,3#无充血肿大&^肥大&^苍白&^充血&%6,4#无充血肿大&^肥大&^苍白&^充血&%6,5#正常&^脓性分泌物&^新生物&%6,6#正常&^脓性分泌物&^新生物&%6,7#正常&^息肉样变&^苍白水肿&^反向弯曲&%6,8#正常&^息肉样变&^苍白水肿&^反向弯曲&%6,9#正常&^狭窄&^息肉&^新生物&^异物&^脓性分泌物&%6,10#正常&^狭窄&^息肉&^新生物&^异物&^脓性分泌物&%6,11#正常&^息肉&%6,12#正常&^息肉&%6,13#正常&^肥大&%6,14#正常&^肥大&%6,15#正常&^异物&^息肉&%6,16#正常&^异物&^息肉&%6,17#正常&^鼻中隔偏曲&^鼻中隔嵴&^鼻中隔穿孔&^鼻中隔粘膜糜烂&%6,18#正常&^左后鼻孔狭窄&^右后鼻孔狭窄&^腺样体肥大&^鼻咽部新生物&^鼻咽部粘膜充血水肿&^鼻咽部粘膜隆起&%6,19#正常&^口咽粘膜充血&^口咽粘膜溃疡&^口咽粘膜新生物&^口咽部狭窄&%6,20#正常&^软腭肥厚&%6,21#正常&^侧索组织肥厚&%6,22#正常&^悬雍垂长&^悬雍垂分叉&%6,23#正常&^扁桃体肥大&^扁桃体角化&^扁桃体新生物&^脓性分泌物&%6,24#正常&^扁桃体肥大&^扁桃体角化&^扁桃体新生物&^脓性分泌物&%6,25#正常&^淋巴滤泡增生&^咽后壁隆起&%6,26#正常&^舌根淋巴组织增生&%6,27#正常&^粘膜充血&^水肿&^新生物&%6,28#正常&^未窥见&^声带充血&^声带肥厚&^声带闭合差&^声带小结&^声带息肉&^声带麻痹&^白班&^新生物&%6,29#正常&^未窥见&^声带充血&^声带肥厚&^声带闭合差&^声带小结&^声带息肉&^声带麻痹&^白班&^新生物&%6,30#正常&^肥厚&^新生物&%6,31#正常&^肥厚&^新生物&%6,32#正常&^运动差&%6,33#正常&^运动差&%6,34#正常&^畸形&^瘘管&%6,35#正常&^畸形&^瘘管&%6,36#正常&^耵聍&^红肿&^分泌物&^狭窄&^新生物&%6,37#正常&^耵聍&^红肿&^分泌物&^狭窄&^新生物&%6,38#完整&^鼓膜充血&^鼓膜内陷&^鼓膜穿孔&^蓝鼓膜&%6,39#完整&^鼓膜充血&^鼓膜内陷&^鼓膜穿孔&^蓝鼓膜&%6,40#未见&^鼓室肉芽&^鼓室胆脂瘤&^鼓室积液&%6,41#未见&^鼓室肉芽&^鼓室胆脂瘤&^鼓室积液&%6,42#无红肿&^红肿&%6,43#无红肿&^红肿&%6,44#正常&^下降&%6,45#正常&^下降&"
	s j=$l(Strings1,"%")
	f k=1:1:j
	{
		s Strings2=$p(Strings1,"%",k)
		s Strings3=$p(Strings2,"#",1)
		s Strings=$p(Strings2,"#",2)
		s SID=+Strings3
		s ODSub=$p(Strings3,",",2)
	s Sub=0
	s i=0
	f  s Sub=$o(^DHCPEST(SID,"OD",ODSub,"ODS",Sub)) q:Sub=""  d
	.s i=i+1
	.s String=$p(Strings,"^",i)
	.s Val=$p(String,"&",1)
	.s Temp=$p(String,"&",2)
	.s ID=SID_"||"_ODSub_"||"_Sub
	.&SQL(update DHC_PE_ODStandard set ods_textval=:Val,ods_template=:Temp where ods_rowid=:ID)
}
}

/// s val=##class(web.DHCPE.StationOrder).GetDetailInfl(1)
ClassMethod GetDetailInfo(i)
{
	s DID=%request.Get("ParRef")
	i (DID="")||(DID=0) q ""
	s Info=$G(^DHCPEST(+DID,"OD",$p(DID,"||",2)))
	q $p(Info,"^",i)
}

/// d ##class(web.DHCPE.StationOrder).InsertOneArcDetail()
ClassMethod InsertOneArcDetail()
{
	s ARCIDs="4113||1^4115||1^4116||1^4117||1^4118||1^4119||1^4120||1^4121||1^4122||1^7052||1^4481||1"
	s StationID="10"
	s StationType="RIS"
	s Sequence="99"
	s SQLCODE=0
	s length=$l(ARCIDs,"^")
	TSTART
	;f i=1:1:length
	;{
	;s ARCID=$p(ARCIDs,"^",i)
	s Sub=0
	f  s Sub=$o(^DHCPEST("10","O",Sub)) q:Sub=""  d
	.s ARCID=$p(^DHCPEST("10","O",Sub),"^",1)
	.i StationType="LIS" d
	..s SQLCODE=##class(web.DHCPE.TransOrderDetail).Main(ARCID,StationID)
	.i StationType="RIS" d
	..s Sequence=Sequence+1
	..S Station=$e("00",1,2-$l(StationID))_StationID
	..s SequenceStr=$e("0000",1,4-$l(Sequence))_Sequence
	..s SequenceStr=Station_SequenceStr
	..s ARCName=$p(^ARCIM(+ARCID,$p(ARCID,"||",2),1),"^",2)_"-检查结果"
	..s Value="T"
	..s Sex="N"
	..s Submit="Y"
	..s ArcDetailID=""
	..&SQL(select od_rowid into :ArcDetailID from sqluser.DHC_PE_OrderDetail where od_desc=:ARCName)
	..i ArcDetailID="" d
	...&sql(insert into sqluser.DHC_PE_OrderDetail (OD_ParRef,OD_Code,OD_Desc,OD_Type,OD_Summary,OD_Advice,OD_Sequence,OD_Sex) values (:StationID,:SequenceStr,:ARCName,:Value,:Submit,:Submit,:Sequence,:Sex))
	...i SQLCODE'=0 s SQLCODE=SQLCODE_"Detail"
	...q:SQLCODE'=0
	...s ArcDetailID=%ROWID
	..w ArcDetailID,!
	..&SQL(insert into sqluser.DHC_PE_OrderDetailRelate (ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required) values (:ARCID,:ArcDetailID,:Sequence,'Y'))
	.w ARCID_"^"_SQLCODE,!
	;}
	TCOMMIT
	;TROLLBACK
}

/// d ##class(web.DHCPE.StationOrder).U("内")
ClassMethod U(Desc)
{
	s Desc=$ZCVT(Desc,"U")
 	s ALIASText=$O(^ARC("ALIAS",0,"Desc",Desc),-1)
 	w ALIASText,!
	f  s ALIASText=$O(^ARC("ALIAS",0,"Desc",ALIASText)) Q:(""=ALIASText)||(ALIASText'[Desc)  d
	.s ALIASDesc=""  //ALIAS_Desc
	.f  s ALIASDesc=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc)) Q:(""=ALIASDesc)  d
	..s ALIASRowId=""
	..f  s ALIASRowId=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc, ALIASRowId)) Q:(""=ALIASRowId)  d
	...s CurData=$G(^ARC("ALIAS", 0, "Desc", ALIASText, ALIASDesc, ALIASRowId,1))
	...// ALIAS_Type
	...s ALIASType=$P(CurData,"^",2)
	...// ALIAS_Row_Calc
	...s ALIASRowCalc=$P(CurData,"^",1)
	...w ALIASText_"^"_ALIASDesc_"^"_ALIASRowCalc_"^"_ALIASType,!
}

// 设置导检单

// d ##class(web.DHCPE.StationOrder).SetPatItemSort("7")

ClassMethod SetPatItemSort(STRowId)
{
	s STORDChildSub=0
	f  s STORDChildSub=$o(^DHCPEST(STRowId,"O",STORDChildSub))  q:STORDChildSub=""  d
	.s STORDARCIMDR=$p(^DHCPEST(STRowId,"O",STORDChildSub),"^",1)
	.s ^DHCPECTDataEx("PatItemSort",STORDARCIMDR)="7"
}

ClassMethod SetGroupPrint(arcimID, printFlag)
{
	i printFlag'="1" d
	.k ^DHCPECTDataEx("DHCPEStationOrder","GroupPrint",arcimID)
	e  d
	.s ^DHCPECTDataEx("DHCPEStationOrder","GroupPrint",arcimID)=printFlag
	q 0
}

ClassMethod SetRisExcel(STRowId)
{
	s STORDChildSub=0
	f  s STORDChildSub=$o(^DHCPEST(STRowId,"O",STORDChildSub))  q:STORDChildSub=""  d
	.s STORDARCIMDR=$p(^DHCPEST(STRowId,"O",STORDChildSub),"^",1)
	.s ^DHCPECTDataEx("DHCPEStationOrder","TempName",STORDARCIMDR)=""
	q 0
}

ClassMethod SetRequestPrintType(arcimID, printFlag)
{
	i printFlag'="1" d
	.k ^DHCPECTDataEx("DHCPEStationOrder","RequestPrintType",arcimID)
	e  d
	.s ^DHCPECTDataEx("DHCPEStationOrder","RequestPrintType",arcimID)=printFlag
	q 0
}

/// d ##class(web.DHCPE.StationOrder).GetReportFormat()
ClassMethod GetReportFormat(Format)
{
	 s Desc=""
	 i Format="RF_CAT" s Desc="多层"
	 i Format="RF_NOR" s Desc="默认"
	 i Format="RF_LIS" s Desc="检验"
	 i Format="RF_RIS" s Desc="检查"
	 i Format="RF_EKG" s Desc="心电"
	 i Format="RF_PIS" s Desc="病理"
	 ;s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stationordercom.csp",Desc)
	 q Desc
}

/// function：获取站点和项目组合界面的信息
/// s val=##class(web.DHCPE.StationOrder).GetStionOrderByID()
ClassMethod GetStionOrderByID(ID)
{
	s curLoc=%session.Get("LOGON.CTLOCID")
	i (ID="") q ""
	s Info=$G(^DHCPEST(+ID,"O",$p(ID,"||",2)))
	s iARCIMDR=$p($G(^DHCPEST(+ID,"O",$p(ID,"||",2))),"^",1)
	s ARCIMDesc=$p($g(^ARCIM($P(iARCIMDR,"||",1),$P(iARCIMDR,"||",2),1)),"^",2)
	
	 //模板名称
    s TempName=$G(^DHCPECTDataEx("DHCPEStationOrder","TempName",iARCIMDR))
    
     //继承
    s ExtendItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Extend",iARCIMDR))
	
	//禁用
    s ShowOrHide=$G(^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",iARCIMDR))
    
    //注意事项
    s Notice=$G(^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",iARCIMDR,curLoc))
     
     //特殊检查
    s SignItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Sign",ID))
    
    //性别
    s SexDR=$G(^DHCPECTDataEx("DHCPEStationOrder","Sex",iARCIMDR))
   
     //是否有片子 
    S PhotoItem=$G(^DHCPECTDataEx("DHCPEStationOrder","Photo",iARCIMDR))
    
    //基本信息条码
    s BaseBar=$G(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",iARCIMDR))
	
	//VIP
	s VIPLevel=$G(^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",iARCIMDR))
	
    //允许重复
    s AlowAddFlag=$g(^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",iARCIMDR))
    
  	//年龄上限、年龄下限、
    s Agemin=$p($G(^DHCPECTDataEx("DHCPEStationOrder","Age",iARCIMDR)),"^",1)
    s Agemax=$p($G(^DHCPECTDataEx("DHCPEStationOrder","Age",iARCIMDR)),"^",2)
    
    //婚姻
    s Married=$G(^DHCPECTDataEx("DHCPEStationOrder","Married",iARCIMDR))
    
    //标本类型
    //i $g(^DHCPESetting("DHCPE","SendPisInterface"))'="Y" d
     i $g(^DHCPESetting("DHCPE","SendPisInterface",curLoc))'="Y" d
    .s PISTypeCode=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",iARCIMDR))
    //i $g(^DHCPESetting("DHCPE","SendPisInterface"))="Y" d
     i $g(^DHCPESetting("DHCPE","SendPisInterface",curLoc))="Y" d
    .s PISTypeCode=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",iARCIMDR))
  
    //PatItemName_"^"_patprintorder_"^"_ifprint
    s PatItemName=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",1)
    s PatPrintOrder=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",2)
    S ifprint=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",3)
    i ifprint="" s ifprint="Y"
    S PrintName=$p($G(^DHCPECTDataEx("PatItemSort",iARCIMDR)),"^",4)


    s YGFlag=$g(^DHCPECTDataEx("YGFlag",iARCIMDR))

   //预约数量
    S PreNum=$G(^DHCPECTDataEx("DHCPEStationOrder","PreNum",iARCIMDR))
	
	//条码数量
    S BarPrintNum=$G(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",iARCIMDR))

	   //是否打印（报告）
    S IFReprotPrint=""
    S IFReprotPrint=$G(^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",iARCIMDR))
    i IFReprotPrint=""  S IFReprotPrint="Y"

	q ID_"^"_Info_"^"_TempName_"^"_ExtendItem_"^"_Notice_"^"_ShowOrHide_"^"_SignItem_"^"_SexDR_"^"_PhotoItem_"^"_SignItem_"^"_PreNum_"^"_BaseBar_"^"_VIPLevel_"^^"_AlowAddFlag_"^"_Agemin_"^"_Agemax_"^"_ Married_"^"_PISTypeCode_"^"_PatItemName_"^"_PatPrintOrder_"^"_YGFlag_"^"_ARCIMDesc_"^"_ifprint_"^"_PrintName_"^"_BarPrintNum_"^"_IFReprotPrint
}

}
