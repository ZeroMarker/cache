Class DHCWL.ST.WL.GetGroupListInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 医技工作量初始化配置
/// d ##Class(DHCWL.ST.WL.GetGroupListInfo).Init()
ClassMethod Init() As %String
{
	n 
	k data
	k ^DHCWLWLFromI
	k ^DHCWLWLFromD
	k ^DHCWLDFTypeD
	k ^DHCWLDFTypeI
	/// 设置BS过滤规则
	s ^DHCWLSTWLYJGroupBS("Code")="WLST"

	/// 设置口径的数量
	/// 如：有住院、门诊、急诊口径 、体检口径则为4
	s ^DHCWLSTWLYJGroupBS("RouteNum")="4"
	
	/// 医嘱明细设置显示条数
	s ^DHCWLSTWLYJGroupBS("Num")=100
	
	/// DHCWL_ST_WL.DHCWLSTWLDataFromType  统计口径维护
	/// DFT_Code,DFT_Desc,DFT_ExCode,DFT_KPICode,DFT_Other
	s data(1)="JF^计费^GetJFMRData^KPSTWLJF^"
	s data(2)="EXE^执行^GetEXEMRData^KPSTWLEXE^"
	s data(3)="JYInter^检验接口^GetJYInterMRData^KPSTWLJYInter^"
	s data(4)="JCInter^检查接口^GetJCInterMRData^KPSTWLJCInter^"
	s data(5)="HSZX^护士执行^GetHSZXMRData^KPSTWLHSZX^"
	s Id=0
	f  s Id=$O(data(Id)) Q:+Id=0  d
	.s Code=$P(data(Id),"^",1)
	.Q:Code=""
	.Q:$D(^DHCWLDFTypeI("DFTCode"," "_$ZCVT(Code,"U")))
	.s Desc=$P(data(Id),"^",2)
	.s ExCode=$P(data(Id),"^",3)
	.s KPICode=$P(data(Id),"^",4)
	.s Other=$P(data(Id),"^",5)
	.&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLDataFromType(DFT_Code,DFT_Desc,DFT_ExCode,DFT_KPICode,DFT_Other) VALUES(:Code,:Desc,:ExCode,:KPICode,:Other))
	k data
	
	/// BS 代码维护程序
	
	s DimTypeDr=$O(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI","ARCIM",""))
	s CfgTypeDr=$O(^DHCWL.CodeCfg.TypeI("Code"," ARCIM","")) 
	q:(+CfgTypeDr=0)&&(+DimTypeDr=0) "初始化失败....."
	i (1)  d
	.s data(1)="WLSTJC^检查"
	.s data(2)="WLSTJY^检验"
	.s data(3)="WLSTZL^治疗"
	.s data(4)="WLSTHL^护理"
	.s Id=0
	.f  s Id=$O(data(Id)) Q:+Id=0  d
	..s GroupCode=$P(data(Id),"^",1)
	..s GroupDesc=$P(data(Id),"^",2)
	..Q:GroupCode=""
	..Q:$D(^DHCWL.CodeCfg.GroupI("Code"," "_GroupCode))||($D(^DHCWL.CodeCfg.GroupI("Code",GroupCode)))
	..s GrpDate=+$h
	..i (+DimTypeDr'=0) d
	...&SQL(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup (Grp_Code,Grp_Desc,Grp_Dim_Dr,Grp_CreateDate) VALUES(:GroupCode,:GroupDesc,:DimTypeDr,:GrpDate))
	..else  i (+CfgTypeDr'=0) d
	...&SQL(INSERT INTO DHCWL_CodeCfg.DHCWLCodeCfgGroup (Grp_Code,Grp_Desc,Grp_Type_Dr,Grp_CreateDate) VALUES(:GroupCode,:GroupDesc,:CfgTypeDr,:GrpDate))
	k data
	
	/// 初始化大类的口径为：计费方式
	s DFTId=$O(^DHCWLDFTypeI("DFTCode"," JF",""))
	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
	i +DFTId'=0 d
	.Q:YJCode=""
	.s GrpId=0 
	.f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	..s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	..s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	..Q:GrpCode'[YJCode
	..s ^TEMPDHCWLCode($j,GrpId)=GrpCode_"^"_GrpDesc
	..f DateType="I","O","E","H" d
	...s WLFFlag="B"
	...s WLFDate=+$H
	...Q:$D(^DHCWLWLFromI("StatDrDataType"," "_GrpId," "_DateType))
	...s SQLCODE=0
	...TStart
	...&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpId,:DateType,:DFTId,:WLFFlag,:WLFDate))
	...i SQLCODE=0 TCOMMIT
	...else  TROLLBACK
	q 1
}

/// Creator：      ycm
/// CreatDate：    2014-11-24
/// Description:： 从BS代码维护获得以WLST开头的医技工作量统计分类维护以及统计分类相关联的口径
/// Table：       DHCWL.CodeCfg.Group
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ST.WL.GetGroupListInfo","GetGroupList")
Query GetGroupList() As %Query(ROWSPEC = "GrpId:%String,GrpCode:%String,GrpDesc:%String") [ SqlProc ]
{
}

ClassMethod GetGroupListExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	k data
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	Q:YJCode="" $$$OK
	s GrpId=0 
	f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	.s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	.s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	.Q:GrpCode'[YJCode
	.s ^TEMPDHCWLCode($j,GrpId)=GrpCode_"^"_GrpDesc
	s GrpId=0 
	f  s GrpId=$o(^TEMPDHCWLCode($j,GrpId)) q:GrpId=""  d
	.s GrpCode=$p($g(^TEMPDHCWLCode($j,GrpId)),"^",1)
	.s GrpDesc=$p($g(^TEMPDHCWLCode($j,GrpId)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(GrpId,GrpCode,GrpDesc)
	.s ind=ind+1
	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupListExecute ]
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

/// 根据分类Id获得DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom 相关联的统计口径
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetWLFByGrpId(5,.data)
ClassMethod GetWLFByGrpId(Id As %String, ByRef data) As %String
{
	n (Id,data)
	k data
	Q:+Id=0 ""
	s WLFId=0
	f  s WLFId=$O(^DHCWLWLFromI("StatDr"," "_Id,WLFId)) Q:WLFId=""  d
	.s WLFObj=##class(DHCWL.ST.WL.DHCWLSTWLWorkLoadFrom).%OpenId(WLFId)
	.s WLFDataType=WLFObj.WLFDataType
	.s WLFFromType=$li(^DHCWLWLFromD(WLFId),4)
	.s WLFFlag=WLFObj.WLFFlag
	.s WLFDate=WLFObj.WLFDate
	.s WLFUser=WLFObj.WLFUser
	.s WLFOther=WLFObj.WLFOther
	.s data(Id,WLFDataType)=WLFId_"^"_WLFDataType_"^"_WLFFromType_"^"_WLFFlag_"^"_WLFDate_"^"_WLFUser_"^"_WLFOther
	q 1
}

/// 根据分类Id获得DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom 相关联的统计口径
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(5)
ClassMethod GetDFTInfoByDFTId(DFTId As %String) As %String
{
	n (DFTId)
	Q:+DFTId=0 ""
	s DFTObj=##class(DHCWL.ST.WL.DHCWLSTWLDataFromType).%OpenId(DFTId)
	Q:DFTObj="" ""
	s DFTCode=DFTObj.DateFromTypeCode
	s DFTDesc=DFTObj.DateFromTypeDesc
	s DFTExCode=DFTObj.DateFromTypeExCode
	s DFTKPICode=DFTObj.DateFromTypeKPICode
	s DFTOther=DFTObj.DateFromTypeOther
	q DFTId_"^"_DFTCode_"^"_DFTDesc_"^"_DFTExCode_"^"_DFTKPICode_"^"_DFTOther
}

/// 根据分类Id获得分类下面的明细
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetSubGrpListByGrpId(5)
ClassMethod GetSubGrpListByGrpId(GrpId As %String, ByRef Paradata) As %String
{
	n (GrpId,Paradata)
	set IDPara=+$g(data("ID"))
	set SubGrpCodePara=$g(Paradata("subGrpCode")) 
	set SubGrpDescPara=$g(Paradata("subGrpDesc"))
	set SubGrpDFTIPara=$g(Paradata("subGrpDFTI")) 
	set SubGrpDFTOPara=$g(Paradata("subGrpDFTO"))
	set SubGrpDFTEPara=$g(Paradata("subGrpDFTE"))
	set SubGrpDFTHPara=$g(Paradata("subGrpDFTH"))
	s subGrpList="",count=0
	s subGrpId=0 f  s subGrpId=$O(^DHCWL.CodeCfg.SubGroupI("GrpDr",GrpId,subGrpId)) q:subGrpId=""  d
	.s count=count+1
	.s SubGrpObj=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subGrpId)
	.s subgrpDesc=SubGrpObj.SGrpDesc
	.s subgrpCode=SubGrpObj.SGrpCode
	.k data
	.s GrpSubGrp=GrpId_"||"_subGrpId
	.d ##Class(DHCWL.ST.WL.GetGroupListInfo).GetWLFByGrpId(GrpSubGrp,.data)
	.s WLFI=$P($g(data(GrpSubGrp,"I")),"^",3)
	.s WLFO=$P($g(data(GrpSubGrp,"O")),"^",3)
	.s WLFE=$P($g(data(GrpSubGrp,"E")),"^",3)
	.s WLFH=$P($g(data(GrpSubGrp,"H")),"^",3)
	.s DFTI=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFI)
	.s DFTO=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFO)
	.s DFTE=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFE)
	.s DFTH=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFH)
	.Q:(+IDPara'=0)&&(IDPara'=subGrpId)
	.Q:(SubGrpCodePara'="")&&(subgrpCode'[SubGrpCodePara)
	.Q:(SubGrpDescPara'="")&&(subgrpDesc'[SubGrpDescPara)
	.Q:(SubGrpDFTIPara'="")&&($P(DFTI,"^",3)'[SubGrpDFTIPara)
	.Q:(SubGrpDFTOPara'="")&&($P(DFTO,"^",3)'[SubGrpDFTOPara)
	.Q:(SubGrpDFTEPara'="")&&($P(DFTE,"^",3)'[SubGrpDFTEPara)
	.Q:(SubGrpDFTHPara'="")&&($P(DFTH,"^",3)'[SubGrpDFTHPara)
	.s subGrpList=subGrpList_"{subGrpId:"_subGrpId_",subgrpCode:'"_subgrpCode_"',subgrpDesc:'"_subgrpDesc_"',DFTI:'"_$P(DFTI,"^",3)_"',DFTO:'"_$P(DFTO,"^",3)_"',DFTE:'"_$P(DFTE,"^",3)_"',DFTH:'"_$P(DFTH,"^",3)_"'},"
	q subGrpList_"^"_count
}

/// 根据子分类Id获得子分类下面的医嘱明细  
/// input:6||2
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetGrpItemBySubGrpId(5)
ClassMethod GetGrpItemBySubGrpId(Id As %String) As %String
{
	n (Id)
	k ^||TEMPDHCWL($j)
	s GrpId=+Id
	s SubGrpId=$P(Id,"||",2)
	Q:(+GrpId=0)||(+SubGrpId=0) $$$OK
	s subGrpList="",count=0
	s IMItemDr=0 f  s IMItemDr=$O(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",SubGrpId,IMItemDr)) q:IMItemDr=""  d
	.s GrpItemRowid=0
	.f  s GrpItemRowid=$O(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",SubGrpId,IMItemDr,GrpItemRowid)) Q:GrpItemRowid=""  d
	..s ^||TEMPDHCWL($j,"Details",GrpItemRowid)=SubGrpId_"^"_IMItemDr_"^"_GrpItemRowid  ///解决排序问题
	
	s GrpItemRowid="" 
	f  s GrpItemRowid=$O(^||TEMPDHCWL($j,"Details",GrpItemRowid)) Q:GrpItemRowid=""  d 
	.s ret=$g(^||TEMPDHCWL($j,"Details",GrpItemRowid))
	.s IMItemDr=$P(ret,"^",2)
	.s GrpGoupId=Id_"||"_GrpItemRowid  
	.s count=count+1
	.s ArcimDr=$TR(IMItemDr," ","")
	.s ArcimCode=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",1)
	.s ArcimDesc=$P(^ARCIM(+ArcimDr,$P(ArcimDr,"||",2),1),"^",2)
	.k data
	.d ##Class(DHCWL.ST.WL.GetGroupListInfo).GetWLFByGrpId(GrpGoupId,.data)
	.s WLFI=$P($g(data(GrpGoupId,"I")),"^",3)
	.s WLFO=$P($g(data(GrpGoupId,"O")),"^",3)
	.s WLFE=$P($g(data(GrpGoupId,"E")),"^",3)
	.s WLFH=$P($g(data(GrpGoupId,"H")),"^",3)	
	.s DFTI=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFI)
	.s DFTO=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFO)
	.s DFTE=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFE)
	.s DFTH=##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfoByDFTId(WLFH)
	.s subGrpList=subGrpList_"{GrpItemId:"_GrpItemRowid_",ArcimCode:'"_ArcimCode_"',ArcimDesc:'"_ArcimDesc_"',DFTI:'"_$P(DFTI,"^",3)_"',DFTO:'"_$P(DFTO,"^",3)_"',DFTE:'"_$P(DFTE,"^",3)_"',DFTH:'"_$P(DFTH,"^",3)_"'},"
	k ^||TEMPDHCWL($j)
	q subGrpList_"^"_count
}

/// Creator：      ycm
/// CreatDate：    2014-11-24
/// Description:： 获得所有医嘱，以及医嘱在医技维护中的归属分类
/// Table：       
/// Input：       searcheType,searcheValue  查找类型 ，查找值,checkDataType 是否过滤已添加分类
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.ST.WL.GetGroupListInfo","GetAllArcimDetail","","")
Query GetAllArcimDetail(searcheType As %String, searcheValue As %String, checkDataType As %String) As %Query(ROWSPEC = "ArcimId:%String,ArcimCode:%String,ArcimDesc:%String,SubGrp:%String") [ SqlProc ]
{
}

ClassMethod GetAllArcimDetailExecute(ByRef qHandle As %Binary, searcheType As %String, searcheValue As %String, checkDataType As %String) As %Status
{
	n (qHandle,searcheType,searcheValue,checkDataType)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	k ^TEMPDHCWLYJAllDetail($j)
 	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	Q:YJCode="" $$$OK
 	s IndNum=+$g(^DHCWLSTWLYJGroupBS("Num"))
	s GrpId=0    ///记录BS代码明细表中医嘱明细属于统计子类，分类
	f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	.s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	.s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	.Q:GrpCode'[YJCode
	.s ItemDr=0
	.f  s ItemDr=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr)) Q:ItemDr=""  d
	..s Id=0
	..f  s Id=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr,Id)) Q:Id=""  d
	...s SubGrp=$li(^DHCWL.CodeCfg.SubGroupItemD(Id),3)
	...s SubGrpDesc=$li(^DHCWL.CodeCfg.SubGroupD(SubGrp),3)
	...s ArcimDr=$TR(ItemDr," ","")
	...s ^TEMPDHCWLYJAllDetail($j,"Detail",ArcimDr)=SubGrp_"^"_SubGrpDesc_"^"_GrpId_"^"_GrpDesc

	s mArcItemDrF=0 
	f  s mArcItemDrF=$o(^ARCIM(mArcItemDrF)) q:mArcItemDrF=""  d
	.s mArcItemDrS=0 f  s mArcItemDrS=$o(^ARCIM(mArcItemDrF,mArcItemDrS)) q:mArcItemDrS=""  d
	..q:(+IndNum'=0)&&(ind>IndNum)
	..s ArcItemDesc=$p($g(^ARCIM(mArcItemDrF,mArcItemDrS,1)),"^",2)
	..s ArcItemCode=$p($g(^ARCIM(mArcItemDrF,mArcItemDrS,1)),"^",1)
	..s ItemCatdr=$p($g(^ARCIM(mArcItemDrF,mArcItemDrS,1)),"^",10)
	..q:ItemCatdr=""
	..s ItemCatDesc=$P(^ARC("IC",ItemCatdr),"^",2)
	..s ArcimId=mArcItemDrF_"||"_mArcItemDrS
	..Q:(searcheType="Code")&&(ArcItemCode'[searcheValue)
	..Q:(searcheType="Name")&&(ArcItemDesc'[searcheValue)
	..Q:(searcheType="ItemCat")&&(ItemCatDesc'[searcheValue)
	..s SubGrp=$P($g(^TEMPDHCWLYJAllDetail($j,"Detail",ArcimId)),"^",2)
	..Q:(checkDataType="Y")&&(SubGrp'="")
	..s ^CacheTemp(repid,ind)=$lb(ArcimId,$p(ArcItemCode,$c(13,10)),$p(ArcItemDesc,$c(13,10)),SubGrp)
	..s ind=ind+1
	k ^TEMPDHCWLYJAllDetail($j)
	Quit $$$OK
}

ClassMethod GetAllArcimDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllArcimDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetAllArcimDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllArcimDetailExecute ]
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

/// 根据描述找到统计口径的Id
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTIdByDesc()
ClassMethod GetDFTIdByDesc(Desc As %String) As %String
{
	n (Desc)
	s Id=$O(^DHCWLDFTypeI("DFTCode"," JF",""))
	Q:Desc="" +Id
	s Id=$O(^DHCWLDFTypeI("DFTDesc"," "_Desc,""))
	i +Id=0 s Id=$O(^DHCWLDFTypeI("DFTDesc",Desc,""))
	i +Id=0 s Id=$O(^DHCWLDFTypeI("DFTCode"," JF",""))
	q +Id
}

/// 显示统计口径
/// w ##Class(DHCWL.ST.WL.GetGroupListInfo).GetDFTInfo()
ClassMethod GetDFTInfo() As %String
{
	n 
	s DFTRowid=0
	s AllDFTList="['','','',''],",count=0
	f  s DFTRowid=$O(^DHCWLDFTypeD(DFTRowid)) Q:DFTRowid=""  d
	.s DFTCode=$li(^DHCWLDFTypeD(DFTRowid),2)
	.s DFTDesc=$li(^DHCWLDFTypeD(DFTRowid),3)
	.s DFTExeCode=$li(^DHCWLDFTypeD(DFTRowid),4)
	.s DFTKPICode=$li(^DHCWLDFTypeD(DFTRowid),5)
	.s count=count+1
	.i count=1 s AllDFTList="['"_DFTCode_"','"_DFTDesc_"','"_DFTExeCode_"','"_DFTKPICode_"'],"
	.else  s AllDFTList=AllDFTList_"['"_DFTCode_"','"_DFTDesc_"','"_DFTExeCode_"','"_DFTKPICode_"'],"
	q "["_$e(AllDFTList,1,$l(AllDFTList)-1)_"]"
}

/// 初始化明细的所有口径
/// d ##Class(DHCWL.ST.WL.GetGroupListInfo).InitDetailsFromType()
ClassMethod InitDetailsFromType() As %String
{
	k ^TEMPDHCWLYJAllDetail($j,"Detail")
	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	Q:YJCode="" $$$OK
 	s IndNum=+$g(^DHCWLSTWLYJGroupBS("Num"))
	s GrpId=0    ///记录BS代码明细表中医嘱明细属于统计子类，分类
	f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	.s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	.s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	.Q:GrpCode'[YJCode
	.s ItemDr=0
	.f  s ItemDr=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr)) Q:ItemDr=""  d
	..s Id=0
	..f  s Id=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr,Id)) Q:Id=""  d
	...s SubGrp=$li(^DHCWL.CodeCfg.SubGroupItemD(Id),3)
	...s SubGrpDesc=$li(^DHCWL.CodeCfg.SubGroupD(SubGrp),3)
	...s ArcimDr=$TR(ItemDr," ","")
	...s GrpSubId=GrpId_"||"_SubGrp_"||"_Id
	...s ^TEMPDHCWLYJAllDetail($j,"Detail",GrpSubId)=""
	
	
	s GrpSubId=""
	f  s GrpSubId=$O(^TEMPDHCWLYJAllDetail($j,"Detail",GrpSubId)) q:GrpSubId=""  d
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," E")) d
	..s DataType="E",DFTId="1",FlagType="L",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," O")) d
	..s DataType="O",DFTId="1",FlagType="L",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," I")) d
	..s DataType="I",DFTId="1",FlagType="L",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	.i '$D(^DHCWLWLFromI("StatDrDataType"," "_GrpSubId," H")) d
	..s DataType="H",DFTId="1",FlagType="L",InDate=+$h
	..&SQL(INSERT INTO DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom (WLF_StatDr,WLF_DataType,WLF_FromType,WLF_Flag,WLF_Date) VALUES(:GrpSubId,:DataType,:DFTId,:FlagType,:InDate))
	q 1
}

}
