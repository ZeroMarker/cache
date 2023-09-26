Import sqluser

/// 物资系统上线前的科室类组批量授权等准备性质工作
Class web.DHCSTMHUI.Tools.BasicData Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	为某个安全组人员登陆科室分配类组权限
/// 			比如"住院护士"安全组人员对应多个登陆科室,给这些科室均进行类组授权
/// Creator:	wangjiabin
/// CreateDate:	2014-08-31
/// Table:		dhc_stkloccatgroup
/// Input:		安全组描述, 类组描述串(^隔开)
/// Output:		
/// Return：	
/// w ##class(web.DHCSTMHUI.Tools.BasicData).InitStkLocCatGroup("Material Manager","代管器材^无菌卫生材料")
ClassMethod InitStkLocCatGroup(GrpDesc, ScgDescStr) As %String
{
	n (GrpDesc,ScgDescStr)
	q:GrpDesc="" -1
	q:ScgDescStr="" -2
	s Type=..sssCode(),DefaultFlag="Y"
	;获取类组id串
	s ScgDescLen=$l(ScgDescStr,"^")
	s ScgStr=""
	f i=1:1:ScgDescLen d
	.s ScgDesc=$p(ScgDescStr,"^",i)
	.s Scg=$o(^DHCSCG(0,"TYPE",Type,ScgDesc,""))
	.q:Scg=""
	.i ScgStr="" d
	..s ScgStr=Scg
	.e  d
	..s ScgStr=ScgStr_"^"_Scg
	
	
	s ScgLen=$l(ScgStr,"^")
	&sql(declare locCursor cursor for
		select distinct(ssusr_defaultdept_dr) from ss_user where ssusr_group->ssgrp_desc=:GrpDesc)
	&sql(open locCursor)
	f  &sql(fetch locCursor into :LocId) q:SQLCODE  d
	.f j=1:1:ScgLen d
	..s Scg=$p(ScgStr,"^",j)
	..&sql(select * from DHC_StkLocCatGroup where SLCG_CTLoc_Dr=:LocId and SLCG_StkCatGrp_Dr=:Scg)
	..i SQLCODE d
	...&sql(insert into DHC_StkLocCatGroup (SLCG_CTLoc_Dr,SLCG_StkCatGrp_Dr,SLCG_Type,SLCG_Default)
		values (:LocId,:Scg,:Type,:DefaultFlag))
	&sql(close locCursor)
	
	q "成功!"
}

/// Descript:	为某个安全组所属的Stock Location科室分配类组权限
/// Creator:	wangjiabin
/// CreateDate:	2014-09-29
/// Table:		dhc_stkloccatgroup
/// Input:		安全组描述, 类组描述串(^隔开)
/// Output:		
/// Return：	
/// w ##class(web.DHCSTMHUI.Tools.BasicData).StockLocationCatGroup("Material Manager","代管器材^无菌卫生材料")
ClassMethod StockLocationCatGroup(GrpDesc, ScgDescStr) As %String
{
	n (GrpDesc,ScgDescStr)
	q:GrpDesc="" -1
	q:ScgDescStr="" -2
	
	&sql(select %id into :GroupId from SS_Group where SSGRP_Desc=:GrpDesc)
	q:SQLCODE "该安全组不存在!"
	
	s Type=..sssCode(),DefaultFlag="Y"
	;获取类组id串
	s ScgDescLen=$l(ScgDescStr,"^")
	s ScgStr=""
	f i=1:1:ScgDescLen d
	.s ScgDesc=$p(ScgDescStr,"^",i)
	.s Scg=$o(^DHCSCG(0,"TYPE",Type,ScgDesc,""))
	.q:Scg=""
	.i ScgStr="" d
	..s ScgStr=Scg
	.e  d
	..s ScgStr=ScgStr_"^"_Scg
	
	s ScgLen=$l(ScgStr,"^")
	&sql(declare StockLocationCursor cursor for
		select ST_CTLOC_DR,ST_CTLOC_DR->CTLOC_DESC from SS_GroupStockLocations where ST_ParRef=:GroupId)
	&sql(open StockLocationCursor)
	f  &sql(fetch StockLocationCursor into :LocId,:LocDesc) q:SQLCODE  d
	.f j=1:1:ScgLen d
	..s Scg=$p(ScgStr,"^",j)
	..&sql(select * from DHC_StkLocCatGroup where SLCG_CTLoc_Dr=:LocId and SLCG_StkCatGrp_Dr=:Scg)
	..i SQLCODE d
	...&sql(insert into DHC_StkLocCatGroup (SLCG_CTLoc_Dr,SLCG_StkCatGrp_Dr,SLCG_Type,SLCG_Default)
		values (:LocId,:Scg,:Type,:DefaultFlag))
	&sql(close StockLocationCursor)
	
	q "成功!"
}

/// Descript:	批量修改某一类组下的物资,利用简称生成相应别名
/// Creator:	wangjiabin
/// CreateDate:	2014-08-31
/// Table:		inc_alias
/// Input:		类组描述串(^隔开)
/// Output:		
/// Return
ClassMethod ChangeAlias(scgDescStr) As %String
{
	n (scgDescStr)
	
	s ret=""
	s len=$l(scgDescStr,"^")
	f i=1:1:len  d
	.s scgDesc=$p(scgDescStr,"^",i)
	.s result=..ChangeAliasByAbbrev(scgDesc)
	.i result'="" d
	..s ret=ret_" "_result
	..w result,!
	
	w:ret="" "成功!"
}

/// 修改简称对应别名
ClassMethod ChangeAliasByAbbrev(scgDesc) As %String
{
	n (scgDesc)
	s scg=""
	&sql(select %id into :scg from dhc_stkcatgroup where scg_desc=:scgDesc)
	q:scg="" "类组"_scgDesc_"不存在"
	
	&sql(declare stkcatCursor cursor for 
		select scgr_stkcat_dr From dhc_stkcatgrprelations where scgr_scg_parref=:scg)
	&sql(open stkcatCursor)
	
	s Err=""
	f  &sql(fetch stkcatCursor into :stkcat) q:SQLCODE  d
	.s inci=0
	.f  s inci=$o(^INCI(0,"StkCat",stkcat,inci)) q:inci=""  d
	..s inciDesc=$p(^INCI(inci,1),"^",2)
	..s Abbrev=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetAbbrev(inci)
	..q:Abbrev=""
	..s AbbrevAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Abbrev)
	..q:AbbrevAlias=""
	..s CheckAlias=##class(web.DHCSTMHUI.INCALIAS).CheckAlias(inci,AbbrevAlias)
	..q:+CheckAlias=1
	..s aliasId=$p(CheckAlias,"^",2)
	..s aliasStr=aliasId_"^"_AbbrevAlias
	..s ret=##class(web.DHCSTMHUI.INCALIAS).Save(inci,aliasStr)
	..i ret<0 d
	...s Err=Err_"^"_inciDesc
	
	&sql(close stkcatCursor)
	
	q Err
}

/// Description:为所有科室设置补货科室
/// Creator:	wangjiabin
/// CreateDate:	2014-10-22
/// Table:		inc_alias
/// Input:		补货科室描述
/// Output:		
/// Return
/// w ##class(web.DHCSTMHUI.Tools.BasicData).SetTransferLoc("ZHFWB-综合服务部")
ClassMethod SetTransferLoc(LocDesc) As %String
{
	n (LocDesc)
	q:LocDesc="" -1
	s frLoc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),""))
	q:frLoc="" -2
	s loc=0
	f  s loc=$o(^CTLOC(loc)) q:loc=""  d
	.q:loc=frLoc
	.&sql(select * from DHC_StockTransferLocConf
		where STLOC_CTLOC_DR=:loc and STLOC_FrLoc_DR=:frLoc)
	.i SQLCODE d
	..&sql(insert into DHC_StockTransferLocConf
		(STLOC_CTLOC_DR,STLOC_FrLoc_DR) values (:loc,:frLoc))
	
	q 0
}

/// Description: 修改某一类组所有物资生产厂家(药学项-->库存项) ps:CS版本切换到BS后,"生产厂家"字段的处理
/// d ##class(web.DHCSTMHUI.Tools.BasicData).ChangeManfBySCG("牙周专业材料")
/// 入参:类组desc
ClassMethod ChangeManfBySCG(scgDesc) As %String
{
	n (scgDesc)
	s scg=""
	&sql(select %id,scg_type into :scg,:scgType from dhc_stkcatgroup where scg_desc=:scgDesc)
	w:scg="" "类组 '"_scgDesc_"' 不存在"
	q:scg=""
	
	&sql(declare ManfCursor cursor for 
		select scgr_stkcat_dr From dhc_stkcatgrprelations where scgr_scg_parref=:scg)
	&sql(open ManfCursor)
	
	s Err="",successCount=0,count=0
	f  &sql(fetch ManfCursor into :stkcat) q:SQLCODE  d
	.s inci=0
	.f  s inci=$o(^INCI(0,"StkCat",stkcat,inci)) q:inci=""  d
	..s inciDesc=$p(^INCI(inci,1),"^",2)
	..s manf=""
	..&sql(select inci_originalarcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr into :manf from inc_itm
		where inci_rowid=:inci)
	..q:manf=""
	..
	..s mr=""
	..&sql(select manf_rowid into :mr from dhc_manf_addioninfo where manf_phcmanf_dr=:manf)
	..i mr="" d
	...&sql(insert into dhc_manf_addioninfo(manf_phcmanf_dr) values (:manf) )
	..
	..&sql(select manf_rowid into :mr from dhc_manf_addioninfo where manf_phcmanf_dr=:manf)
	..i mr>0 d
	...&sql(update dhc_manf_addioninfo set manf_type=:scgType where manf_rowid=:mr )
	..
	..s count=count+1
	..s addinfo=$o(^DHCITMINFO(0,"INCI",inci,0))
	..i addinfo="" d
	...&sql(insert into dhc_itmaddioninfo (INFO_INCI_DR,INFO_PbManf_DR) values (:inci,:manf))
	..e  d
	...&sql(update dhc_itmaddioninfo set INFO_PbManf_DR=:manf where %id=:addinfo)
	..i SQLCODE d
	...w inciDesc_"^"_SQLCODE,!
	..e  d
	...s successCount=successCount+1
	&sql(close ManfCursor)
	
	w !,"共"_count_"个, 成功"_successCount_"个"
}

/// Descript:	根据入库子表信息补充dhc_incitmbat(仅处理物资)
/// 			(北京中医院等2008年左右老库会用到)
/// CreateDate:	2016-01-26
/// Table:		dhc_ingdrecitm, dhc_incitmbat
/// Input:
/// Output:
/// Return:
/// w ##class(web.DHCSTMHUI.Tools.BasicData).CreateIncib()
ClassMethod CreateIncib()
{
	new
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'="M"
	.s ib=0
	.f  s ib=$o(^INCI(inci,"IB",ib)) q:ib=""  d
	..s incib=inci_"||"_ib
	..s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,0))
	..q:dhcIncib'=""			;已有的不处理
	..
	..s ingr=$o(^DHCINGR(0,"GRI_INCIB",incib,0))
	..q:ingr=""
	..s ingriCh=$o(^DHCINGR(0,"GRI_INCIB",incib,ingr,0))
	..q:ingriCh=""
	..s ingri=ingr_"||"_ingriCh
	..&sql(select ingri_rowid,ingri_inclb_dr,ingri_ctuom_dr,ingri_ingr_parref->ingr_apcvm_dr,ingri_ingr_parref->ingr_date,
			ingri_ingr_parref->ingr_time,initm_realprice,initm_saleprice,initm_phmnf_dr
		into :ingri,:inclb,:uom,:ven,:dd,
			:tt,:rp,:sp,:mnf
		From dhc_ingdrecitm where %id=:ingri)
	..s inci=$p(inclb,"||",1),il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	..q:(inci="")||(il="")||(lb="")
	..
	..s buom=$p(^INCI(inci,1),"^",10)
	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	..s brp=rp/fac
	..s bsp=sp/fac
	..
	..&sql(insert into dhc_incitmbat (incib_incib_dr,incib_rp,incib_rppuruom,incib_sp,incib_sppuruom,
		incib_phmnf_dr,incib_apcvm_dr,incib_dateadd,incib_timeadd)
		values
		(:incib,:brp,:rp,:bsp,:sp,
		:mnf,:ven,:dd,:tt))
	
	q 0
}

/// 按新规则生成供应商别名
/// d ##class(web.DHCSTMHUI.Tools.BasicData).CreateVendorAlias()
ClassMethod CreateVendorAlias()
{
	new
	&sql(declare VendorAliasCur cursor for
		select %id from apc_vendor where apcvm_type='M'
	)
	&sql(open VendorAliasCur)
	f  &sql(fetch VendorAliasCur into :VendorId) q:SQLCODE  d
	.s STV=$o(^DHCSTV(0,VendorId,""))
	.q:STV=""
	.s OldAlias=$p(^DHCSTV(STV),"^",46)
	.q:OldAlias'=""
	.s Code=$p(^APC("APCVM",VendorId),"^",2)
	.s Name=$p(^APC("APCVM",VendorId),"^",3)
	.s QuanPinAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,3,"",50)
	.s Alias=Code_"/"_Name_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,4)_"/"_QuanPinAlias
	.&sql(update dhc_stvendor set stv_alias=:Alias where %id=:STV)
	.i SQLCODE B  w STV,!,Code,!!
	&sql(close VendorAliasCur)
}

/// d ##class(web.DHCSTMHUI.Tools.BasicData).CreateManfAlias()
ClassMethod CreateManfAlias()
{
	new
	&sql(declare ManfAliasCur cursor for
		select %id,MANF_PhcManf_DR from dhc_manf_addioninfo
		where manf_type='M' and Manf_Alias is null
	)
	&sql(open ManfAliasCur)
	f  &sql(fetch ManfAliasCur into :Info,:ManfId) q:SQLCODE  d
	.q:'$d(^PHMNF(ManfId))
	.
	.s Code=$p(^PHMNF(ManfId),"^",1)
	.s Name=$p(^PHMNF(ManfId),"^",2)
	.s QuanPinAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,3,"",50)
	.s Alias=Code_"/"_Name_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,4)_"/"_QuanPinAlias
	.&sql(update dhc_manf_addioninfo set manf_alias=:Alias where %id=:Info)
	.i SQLCODE B  w Info,!,Name,!!
	&sql(close ManfAliasCur)
}

/// Description:自动为GroupDesc安全组下的人员, 添加其他登录权限
/// 			处理默认登录科室,关联科室
/// Input:		GroupDesc:已有权限的安全组,如护士长,
/// 			NewGroupDesc:需要增加权限的安全组(比如请领安全组)
/// d ##class(web.DHCSTMHUI.Tools.BasicData).SetOtherLogLoc("住院护士长","物资总务库存请求")
ClassMethod SetOtherLogLoc(GroupDesc, NewGroupDesc) As %String
{
	n (GroupDesc, NewGroupDesc)
	q:(GroupDesc="")||(NewGroupDesc="") -1
	s NewGroupId=""
	&sql(select %id into :NewGroupId from ss_group where ssgrp_desc=:NewGroupDesc)
	q:NewGroupId="" -1
	
	&sql(declare UserCursor cursor for
		SELECT %id,SSUSR_DefaultDept_DR,SSUSR_Name,SSUSR_Initials FROM ss_user WHERE SSUSR_Group->ssgrp_desc=:GroupDesc)
	&sql(open UserCursor)
	for  &sql(fetch UserCursor into :UserId,:DefaDept,:UserName,:UserInitial) q:SQLCODE  d
	.s HospId=$p(^CTLOC(DefaDept),"^",22)
	.
	.w UserName_"  "_UserInitial,!
	.s Ret=$$SetNewOtherLogLoc(UserId,DefaDept,NewGroupId,HospId)
	.s DefaDeptDesc=$p(^CTLOC(DefaDept),"^",2)
	.i Ret=0 w DefaDeptDesc,!
	.
	.s LinkLoc=0
	.f  s LinkLoc=$o(^CTLOC(DefaDept,"LINK",0,"Loc",LinkLoc)) q:LinkLoc=""  d
	..s Ret=$$SetNewOtherLogLoc(UserId,LinkLoc,NewGroupId,HospId)
	..s LinkLocDesc=$p(^CTLOC(LinkLoc),"^",2)
	..i Ret=0 w LinkLocDesc,!
	.
	.w !
	&sql(close UserCursor)
	
SetNewOtherLogLoc(UserId,LocId,NewGroupId,HospId)
	n (UserId,LocId,NewGroupId,HospId)
	&sql(select %id from SS_UserOtherLogonLoc
		where OTHLL_UserGroup_DR=:NewGroupId and OTHLL_CTLOC_DR=:LocId)
	q:SQLCODE=0 -1
	s Ch=1+$o(^SSU("SSUSR",UserId,"OTHLL",""),-1)
	s obj=##class(User.SSUserOtherLogonLoc).%New(UserId)
	d obj.OTHLLParRefSetObjectId(UserId)
	s obj.OTHLLChildsub=Ch
	d obj.OTHLLCTLOCDRSetObjectId(LocId)
	d obj.OTHLLUserGroupDRSetObjectId(NewGroupId)
	d obj.OTHLLHospitalDRSetObjectId(HospId)
	s obj.OTHLLStartDate=+$h
	s sc=obj.%Save()
	i $$$ISERR(sc) s Err=-10 q Err
	q 0
}

/// 获取科室高值材料库存信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.BasicData","OutLocItmStkHv","2019-01-01","2019-05-01")
Query OutLocItmStkHv(StartDate As %String = "", EndDate As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "InciCode::代码,InciDesc::名称,CurrentLoc::科室id,CurrentLocDesc::科室,Qty::数量,PurUomDesc::单位,Rp::进价,BatchNo::批号,ExpDate::效期,ManfDesc::生产厂家,Lable::条码,OriginalCode::自带码,vendorname::供应商,HOSPCode::医院代码,HospDesc::医院名称") [ SqlProc ]
{
}

ClassMethod OutLocItmStkHvExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	q:EndDate<StartDate $$$OK
	s Status="Enable"
	s DHCIT=""
	f  s DHCIT=$O(^DHCIT(0,"Status",Status,DHCIT)) q:DHCIT=""  d
	.q:'$d(^DHCIT(0,"Status",Status,DHCIT))
	.s Inci=$p(^DHCIT(DHCIT),"^",1)		;库存项
	.q:Inci=""
	.s Inclb=$p(^DHCIT(DHCIT),"^",12)
	.q:Inclb=""
	.s CurrentLoc=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1)
	.s CurrentLocDesc=$p(^CTLOC(CurrentLoc),"^",2)
	.s HospId=$p(^CTLOC(CurrentLoc),"^",22)
	.s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	.s HOSPCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	.s Lable=$p(^DHCIT(DHCIT),"^",2)
	.s OriginalCode=$p(^DHCIT(DHCIT),"^",13)	;自带条码
	.s Date=$p(^DHCIT(DHCIT),"^",8)	;条码注册日期
	.q:(StartDate'="")&(Date<StartDate)
	.q:(EndDate'="")&(Date>EndDate)
	.s:Date'="" Date=$zd(Date,3)
	.s VenId=$p(^DHCIT(DHCIT),"^",11)
	.s Vendesc=""
	.s:VenId'="" Vendesc=$p(^APC("APCVM",VenId),"^",3)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",3)
	.s Scg=$p(ScgInfo,"^",5)
	.q:StkType'="M"
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s Incsc=$p(^INCI(Inci,2),"^",2)	;库存分类
	.s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)		;分类代码
	.s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)		
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s PurUomDesc=""
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)
	.s manfinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.s ManfDesc=$p(manfinfo,"^",2)
	.s ImplantationMat=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncImplantationMat(Inci)	;植入标志
	.s Qty=1
	.s Rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	.s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatchNo=$p(BatExp,"^",1)
	.s ExpDate=$p(BatExp,"^",2)
	.s VendorStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.s vendorname=$p($g(VendorStr),"^",2)
	.d OutPutRow
	
	Quit $$$OK
OutPutRow
	s Data=$lb(InciCode,InciDesc,CurrentLoc,CurrentLocDesc,Qty,PurUomDesc,Rp,BatchNo,ExpDate,ManfDesc,Lable,OriginalCode,vendorname,HOSPCode,HospDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取单个科室高值材料库存信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.BasicData","GetLocEnableBarcodes","459")
Query GetLocEnableBarcodes(LocId As %String) As web.DHCSTMHUI.Query(ROWSPEC = "InciCode::代码,InciDesc::名称,IngrLocDesc::科室,Qty:%Float:数量,PurUomDesc::单位,Rp:%Float:进价,BatchNo::批号,ExpDate::效期,ManfDesc::生产厂家,Lable::条码,OriginalCode::自带码,vendorname::供应商,LocDesc:") [ SqlProc ]
{
}

ClassMethod GetLocEnableBarcodesExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	n (qHandle,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocId="" ""
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	k ^TMP("HVBarCodeInfo",LocDesc)
	
	s inci=0
	f  s inci=$o(^INCI("IL_LOC",LocId,inci)) q:inci=""  d
	.q:'$d(^INCI(inci,1))
	.s il=$o(^INCI("IL_LOC",LocId,inci,0))
	.q:'$d(^INCI(inci,"IL",il))
	.s INCIL=inci_"||"_il
	.s InciCode=$p(^INCI(inci,1),"^",1)
	.s InciDesc=$p(^INCI(inci,1),"^",2)
	.
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.q:BUomId=""
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.
	.s dhcit=0
	.f  s dhcit=$o(^DHCIT(0,"INCI",inci,dhcit)) q:dhcit=""  d
	..s status=$p(^DHCIT(dhcit),"^",5)
	..q:status'="Enable"
	..s inclb=$p(^DHCIT(dhcit),"^",12)
	..s tmpInclb=$p(inclb,"||",1,2)
	..q:tmpInclb'=INCIL
	..s HVBarCode=$p(^DHCIT(dhcit),"^",2)
	..
	..s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..s nowqty=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",2)
	..s BatchNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	..
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,BUomId,HospId)
	..s Qty=1
	..q:nowqty<Qty
	..s ManfDesc=""
	..s OriginalCode=$p(^DHCIT(dhcit),"^",13)
	..s VendorId=$p(^DHCIT(dhcit),"^",11)
	..q:VendorId=""
	..s VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	..;s:VendorDesc["-" VendorDesc=$p(VendorDesc,"-",2)
	..
	..s (Ingri,IngrLoc,IngrLocDesc)=""
	..s DetailId=$o(^DHCITD(dhcit,"I",0))
	..i DetailId'="" d
	...s DetailType=$p(^DHCITD(dhcit,"I",DetailId),"^",2)
	...q:DetailType'="G"
	...s Ingri=$p(^DHCITD(dhcit,"I",DetailId),"^",1)
	...s IngrLoc=$p(^DHCINGR(+Ingri),"^",13)
	...s IngrLocDesc=$p(^CTLOC(IngrLoc),"^",2)
	...s:IngrLocDesc["-" IngrLocDesc=$p(IngrLocDesc,"-",2)
	..s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(inclb)
	..i SpecDesc="" s SpecDesc="*"
	..
	..s rowData1=InciCode_"^"_InciDesc_"^"_IngrLocDesc_"^"_Qty_"^"_BUomDesc
	..s rowData2=Rp_"^"_BatchNo_"^"_ExpDate_"^"_ManfDesc_"^"_HVBarCode
	..s rowData3=OriginalCode_"^"_VendorDesc_"^"_LocDesc
	..s rowData=rowData1_"^"_rowData2_"^"_rowData3
	..s ^TMP("HVBarCodeInfo",LocDesc,IngrLocDesc_"-"_VendorDesc_"-"_InciCode,SpecDesc,HVBarCode)=rowData
	..d OutPutRowGetLocEnableBarcodes
	
	Quit $$$OK
OutPutRowGetLocEnableBarcodes
	s Data=$lb(InciCode,InciDesc,IngrLocDesc,Qty,BUomDesc,Rp,BatchNo,ExpDate,ManfDesc,HVBarCode,OriginalCode,VendorDesc,LocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
