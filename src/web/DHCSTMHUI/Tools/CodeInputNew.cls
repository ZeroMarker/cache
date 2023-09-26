Import sqluser

/// 物资导入程序
///   Author:zhwh
///   Date:2013-11-19  
///   增加院区 维护新供应商资质 生产厂家资质 lihui20200416  
Class web.DHCSTMHUI.Tools.CodeInputNew Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 处理一行数据
ClassMethod InputIncItm(RowObj, AdjSpNo) As %String
{
	n (RowObj,AdjSpNo,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()  
	s gHospId=$p(..sssParamStr(),"^",4)
	s Hospital=RowObj.%Get("医院")
	s HospId=""
	i Hospital'="" d
	.&sql(SELECT HOSP_RowId INTO:HospId FROM CT_Hospital WHERE HOSP_Desc=:Hospital)
	s:HospId="" HospId=gHospId
	i AdjSpNo="" d
	.s AdjSpNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTADJSPM","","",HospId)
	s code=RowObj.%Get("物资代码")
	s desc=RowObj.%Get("物资名称")
	i desc="" d RtnObj.Err(-1,"",desc_"物资名称为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s TmpId=""
	i code'="" d
	.s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"INC_Itm",HospId,"") 
	i (TmpId'="") q RtnObj.Err(-1,"","库存项代码已经存在，不能重复!","",0)
	s alias=RowObj.%Get("别名")
	s spec=RowObj.%Get("规格")		;规格
	s model=RowObj.%Get("型号")		;型号
	s brand=RowObj.%Get("品牌")		;品牌
	s buom=RowObj.%Get("最小单位")		;基本单位
	i buom="" d RtnObj.Err(-1,"",desc_"最小单位为空","",0)
	q:RtnObj.success'=0 RtnObj
	s buom=..validUom(buom)
	i buom="" d RtnObj.Err(-1,"",desc_"最小单位为空","",0)
	q:RtnObj.success'=0 RtnObj
	s puom=RowObj.%Get("整包装单位")		;整包装单位
	i puom="" d RtnObj.Err(-1,"",desc_"整包装单位为空","",0)
	q:RtnObj.success'=0 RtnObj
	s puom=..validUom(puom)
	i puom="" d RtnObj.Err(-1,"",desc_"整包装单位为空","",0)
	q:RtnObj.success'=0 RtnObj
	s factor=RowObj.%Get("整包转换系数")	;换算系数
	s ctcf=..validConFac(puom,buom,factor)
	i ctcf="" d RtnObj.Err(-1,"",desc_"入库单位和基本单位无对应换算","",0)
	q:RtnObj.success'=0 RtnObj
	s catgrp=RowObj.%Get("库存大类名称")	;类组(大类)
	i catgrp="" d RtnObj.Err(-1,"",desc_"类组为空","",0)
	q:RtnObj.success'=0 RtnObj
	s scg=..validScg(catgrp,HospId)
	i scg="" d RtnObj.Err(-1,"",desc_"无法取得类组","",0)
	q:RtnObj.success'=0 RtnObj

	s stkcat=RowObj.%Get("库存子类名称")	;库存分类(子类)
	i stkcat="" d RtnObj.Err(-1,"",desc_"库存子类为空","",0)
	q:RtnObj.success'=0 RtnObj
	s sc=..validStkCat(stkcat,HospId)
	i sc=""   d RtnObj.Err(-1,"",desc_"无法取得子类","",0)
	q:RtnObj.success'=0 RtnObj
	;类组和分类建立关联
	s rela=..validStkGrpRelation(scg,sc)
	i rela="" d RtnObj.Err(-1,"",desc_"类组和分类无法建立关联","",0)
	q:RtnObj.success'=0 RtnObj
	s vendor=RowObj.%Get("供应商名称")	;供应商
	s v=..validVendor(vendor,HospId)
	i v<0 d RtnObj.Err(-1,"","供应商插入失败")
	q:RtnObj.success'=0 RtnObj
	i v>0 d 
	. //   **    供应商其他信息 Start  **
	.s businesslicense=RowObj.%Get("供应商营业执照号")
	.s businesslicensedate=RowObj.%Get("供应商营业执照有效期")
	.i businesslicensedate'="" s businesslicensedate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(businesslicensedate)
	.i +businesslicensedate<0 d RtnObj.Err(-2,"","供应商营业执照有效期格式不正确!","",0)
	.q:RtnObj.success'=0
	.s businesscertificate=RowObj.%Get("供应商经营许可证号")
	.s businesscertificateExpDate=RowObj.%Get("供应商经营许可证效期")
	.i businesscertificateExpDate'="" s businesscertificateExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(businesscertificateExpDate)
	.i +businesscertificateExpDate<0 d RtnObj.Err(-2,"","供应商经营许可证效期格式不正确!","",0)
	.q:RtnObj.success'=0
	.s contactperson=RowObj.%Get("授权联系人")   ;联系人
	.s authorizationdate=RowObj.%Get("授权到期")  ;授权到期
	.i authorizationdate'="" s authorizationdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(authorizationdate)
	.i +authorizationdate<0 d RtnObj.Err(-2,"","授权到期日期格式不正确!","",0)
	.q:RtnObj.success'=0
	.s contacttel=RowObj.%Get("授权联系人电话")
	.s revreg=RowObj.%Get("供应商税务登记证号")
	.s orgcode=RowObj.%Get("供应商组织机构代码")
	.s orgcodedate=RowObj.%Get("供应商组织机构代码有效期")
	.i orgcodedate'="" s orgcodedate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(orgcodedate)
	.i +orgcodedate<0 d RtnObj.Err(-2,"","供应商组织机构代码有效期格式不正确!","",0)
	.q:RtnObj.success'=0
	.s Title="CERTType^CERTText^CERTDateTo^CERTIssuedDept^CERTIssuedDate^HospId"
	.s qualityinfo=""
	.;工商执照
	.s comLicType="comLic"
	.s comLicText=businesslicense
	.s comLicDateTo=businesslicensedate
	.s comLicIssuedDept=""
	.s comLicIssuedDate=""
	.s comLicData=comLicType_"^"_comLicText_"^"_comLicDateTo_"^"_comLicIssuedDept_"^"_comLicIssuedDate_"^"_HospId
	.s comLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(comLicData,Title)
	.s qualityinfo=comLicObj
	.;器械经营许可证
	.s insBusLicType="insBusLic"
	.s insBusLicText=businesscertificate
	.s insBusLicDateTo=businesscertificateExpDate
	.s insBusLicIssuedDept=""
	.s insBusLicIssuedDate=""
	.s insBusLicData=insBusLicType_"^"_insBusLicText_"^"_insBusLicDateTo_"^"_insBusLicIssuedDept_"^"_insBusLicIssuedDate_"^"_HospId
	.s insBusLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insBusLicData,Title)
	.s qualityinfo=qualityinfo_","_insBusLicObj
	.;税务执照
	.s taxLicType="taxLic"
	.s taxLicText=revreg
	.s taxLicDateTo=""
	.s taxLicIssuedDept=""
	.s taxLicIssuedDate=""
	.s taxLicData=taxLicType_"^"_taxLicText_"^"_taxLicDateTo_"^"_taxLicIssuedDept_"^"_taxLicIssuedDate_"^"_HospId
	.s taxLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(taxLicData,Title)
	.s qualityinfo=qualityinfo_","_taxLicObj
	.;机构代码
	.s orgCodeType="orgCode"
	.s orgCodeText=orgcode
	.s orgCodeDateTo=orgcodedate
	.s orgCodeIssuedDept=""
	.s orgCodeIssuedDate=""
	.s orgCodeData=orgCodeType_"^"_orgCodeText_"^"_orgCodeDateTo_"^"_orgCodeIssuedDept_"^"_orgCodeIssuedDate_"^"_HospId
	.s orgCodeObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(orgCodeData,Title)
	.s qualityinfo=qualityinfo_","_orgCodeObj
	.
	.s qualityinfo="["_qualityinfo_"]" ;新版资质维护
	.
  	.s info=contactperson
  	.s info=info_"^"_authorizationdate
  	.s info=info_"^"_contacttel
	.s info=info_"^"_revreg
  .
	.s RtnObj=..updVendorInfo(v,info,qualityinfo)
	. //   **    供应商其他信息 End  **
	q:RtnObj.success'=0 RtnObj

	;生产厂家
	s manf=RowObj.%Get("生产厂家名称")  
	s m=..validManf(manf,HospId)
	i m<0 d RtnObj.Err(-1,"",desc_"生成生产厂家插入失败")
	q:RtnObj.success'=0 RtnObj
	i m>0 d
	.s productionlicense=RowObj.%Get("生产许可证号")
	.s productionlicenseexpdate=RowObj.%Get("生产许可证效期")
	.i productionlicenseexpdate'="" s productionlicenseexpdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(productionlicenseexpdate)
	.i +productionlicenseexpdate<0 d RtnObj.Err(-2,"","生产许可证效期格式不正确!","",0)
	.q:RtnObj.success'=0
	.s info=""
	.
	.s ManfTitle="CERTType^CERTText^CERTDateTo^CERTIssuedDept^CERTIssuedDate^HospId"
	.s ManfQualityinfo=""
	.;器械生产许可证
	.s insProLicType="insProLic"
	.s insProLicText=productionlicense
	.s insProLicDateTo=productionlicenseexpdate
	.s insProLicIssuedDept=""
	.s insProLicIssuedDate=""
	.s insProLicData=insProLicType_"^"_insProLicText_"^"_insProLicDateTo_"^"_insProLicIssuedDept_"^"_insProLicIssuedDate_"^"_HospId
	.s insProLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insProLicData,ManfTitle)
	.s ManfQualityinfo=insProLicObj
	.
	.s ManfQualityinfo="["_ManfQualityinfo_"]"
	.
	.
	.s RtnObj=..updManfInfo(m,info,ManfQualityinfo)  //生产厂家附加信息
	q:RtnObj.success'=0 RtnObj
	
	;s carried=RowObj.%Get("招标配送商名称")
	s rp=RowObj.%Get("进价")				;进价(整包装单位)
	s sp=RowObj.%Get("售价")				;售价(整包装单位)
	s rp=+rp
	s sp=+sp
	s priceinformation=RowObj.%Get("价格信息")  //价格信息
	s barcode=RowObj.%Get("条码")		;条码
	s charge= RowObj.%Get("收费标志")		;收费标志
	s remarks=RowObj.%Get("备注")		;备注
	s remarksList=$lfs(remarks,$c(13,10))
	s batReq=RowObj.%Get("批号要求")		;批号要求
	s:batReq="Y" batReq="R"
	s expReq=RowObj.%Get("效期要求")	;效期要求
	s:expReq="Y" expReq="R"
	//自动生成代码
	i code="" s code=..createCode(scg,sc)
	i code="" d RtnObj.Err(-1,"",desc_"自动生成代码错误")
	q:RtnObj.success'=0 RtnObj
	s notuse="N"
	s d=+$h			//日期
	s t=$p($h,",",2)	//时间
	s user=..User()

	s xiehe=RowObj.%Get("协和码")
	&sql(Insert into INC_Itm(INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,INCI_CTUOM_Purch_DR,
		INCI_NotUseFlag,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
		inci_reportingdays,inci_remarks,INCI_BatchReq,INCI_ExpReq
	) values (:code,:desc,:buom,:sc,:puom,
			:notuse,:d,:t,:user,:barcode,
			:xiehe,:remarksList,:batReq,:expReq
	)
	)

	i SQLCODE'=0 d 
	.d RtnObj.Err(-1,"",desc_"插入主表错误:"_SQLCODE)
	e  d
	.s inci=$g(%ROWID)
	q:RtnObj.success'=0 RtnObj

	s hv=RowObj.%Get("是否高值")					//高值标志 : "Y"或者"N"
	s carrier=..validCarrier(RowObj.%Get("招标配送商名称"),HospId)	//配送商
	s abbr=RowObj.%Get("简称")						//简称

	&sql(Insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_Spec,INFO_Model,INFO_Brand,INFO_HighPrice,
	INFO_MaxSp,INFO_PbRp,INFO_PbVendor_DR,
	INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_ChargeFlag,INFO_AbbRev)
	values (:inci,:spec,:model,:brand,:hv,:sp,:rp,:v,:m,:carrier,:charge,:abbr) )
	i SQLCODE'=0 d
	.d RtnObj.Err(-1,"",desc_"插入附加表错误:"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	s SpecList=RowObj.%Get("具体规格")
	s lenSpec=$l(SpecList,"|")
	f ind=1:1:lenSpec d
	.s SpecItm=$p(SpecList,"|",ind)
	.q:SpecItm=""
	.s SpecNo=""
	.&sql(select nvl(max(SPEC_SeqNo),0)+1 into :SpecNo from SQLUser.DHC_ItmSpecList where SPEC_INCI_DR=:inci)
	.&sql(INSERT INTO DHC_ItmSpecList (SPEC_INCI_DR,SPEC_Desc,SPEC_SeqNo) VALUES (:inci,:SpecItm,:SpecNo))
	.i SQLCODE'=0  d
 	..d RtnObj.Err(-1,"",desc_"插入具体规格失败"_SQLCODE)
	s RtnObj=..createAlias(inci,alias)  //生成别名
	q:RtnObj.success'=0 RtnObj
	s RtnObj=..createAsp(inci,..User(),rp,sp,..Hosp(""),priceinformation,AdjSpNo)  //生成调价表记录
	q:RtnObj.success'=0 RtnObj

	i inci'="",m'="" d
	.s registerno="",registerexpdate=""
	.s registerno=RowObj.%Get("器械注册证号") 
	.s registerexpdate=RowObj.%Get("器械注册证效期") 
	.s ret=..validIR(inci,m,registerno,registerexpdate)
	.i ret<0 d RtnObj.Err(-1,"",desc_"更新注册证号失败")
	q:RtnObj.success'=0 RtnObj

	i inci'="",v'="" d
	.s ret=..validIV(inci,v,m,carrier,rp,sp)
	.i ret<0 d RtnObj.Err(-1,"",desc_"更新Ven失败")	
	q:RtnObj.success'=0 RtnObj
	s err=##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(inci,HospId)
	i err'=0 d RtnObj.Err(-1,"",desc_"维护院区失败")	
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=inci
	q RtnObj
}

/// 取医院rowid
ClassMethod Hosp(loc) As %String
{
	n (loc)
	//s loc="KQK-口腔科"
	//&sql(select ctloc_hospital_dr into :h from ct_loc where ctloc_desc=:loc  )   
	&sql(select min(%id) into :h from ct_hospital )
	q $G(h)
}

/// 自动生成代码
ClassMethod createCode(scg, sc) As %String
{
 n (scg,sc)
 q:scg="" ""
 q:sc="" ""
 &sql(select scg_code into :scgCode from dhc_stkcatgroup where scg_rowid=:scg)
 &sql(select incsc_code into :scCode from inc_stkcat where incsc_rowid=:sc) 
 q:scgCode="" ""
 q:scCode="" ""
 
 s:$f(scCode,"CL") scCode=$p(scCode,..prefix(),2)
 s seq=$i(^INCIx("AUTOCODE",scgCode,scCode)) 
 s inciCode=scgCode_scCode_$tr($j(seq,4)," ","0")
 q inciCode
}

/// 验证类组(大类)
ClassMethod validScg(catgrp As %String, HospId As %String) As %String
{
 n (catgrp,HospId)
 s type=..sssCode(),prefix=..prefix()
 s scg=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",catgrp,"DHC_StkCatGroup",HospId)
 s rowid=""
 i +scg'>0 d
 .s code=..getScgCode(prefix)
 .&sql(insert into  dhc_stkcatgroup(scg_code,scg_desc,scg_type) values (:code,:catgrp,:type))
 .i SQLCODE'=0 q 
 .s rowid=$p($g(%ROWID),$c(1))
 e  d
 .s rowid=+scg
 q rowid
}

/// 验证分类
ClassMethod validStkCat(stkcat As %String, HospId As %String) As %String
{
 n (stkcat,HospId)
 s type=..sssCode(),prefix=..prefix()
 s sc=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",stkcat,"INC_StkCat",HospId)
 s rowid=""
 i +sc'>0 d
 .s code=..getScCode(prefix)
 .&sql(insert into  inc_stkcat(incsc_code,incsc_desc,incsc_stktype) values (:code,:stkcat,:type))
 .i SQLCODE'=0 q 
 .s rowid=$G(%ROWID)
 e  d
 .s rowid=+sc
 q rowid
}

/// 验证类组和分类之间的对应关联关系
/// scg:类组rowid
/// incsc:类rowid
ClassMethod validStkGrpRelation(scg As %String, sc As %String) As %String
{
 n (scg,sc)
 s rowid=""
 &sql(select scgr_rowid into :scgr From dhc_stkcatgrprelations  where scgr_scg_parref=:scg and scgr_stkcat_dr=:sc and scgr_scg_parref->scg_Type='M')
 i SQLCODE d
 .&sql(select scgr_rowid into :scgr from dhc_stkcatgrprelations where scgr_stkcat_dr=:sc)
 .i 'SQLCODE q   ;该分类已经对应
 .
 .s ch=$o(^DHCSCG(scg,"RE",""),-1)+1
 .&sql(insert into dhc_stkcatgrprelations(scgr_scg_parref,scgr_childsub,scgr_stkcat_dr) values (:scg,:ch,:sc) )
 .i SQLCODE'=0 q
 .s rowid=$G(%ROWID)
 e  d
 .s rowid=$G(scgr)
 .
 q rowid
}

/// 验证单位
ClassMethod validUom(uom As %String) As %String
{
 n (uom)
 s rowid=""
 &sql(select ctuom_rowid into :u from ct_uom where ctuom_desc=:uom)
 i SQLCODE d
 .&sql(insert into  ct_uom(ctuom_code,ctuom_desc,ctuom_foreigndesc) values (:uom,:uom,:uom))
 .i SQLCODE'=0 q 
 .s rowid=$G(%ROWID)
 e  d
 .s rowid=+u
 q rowid
}

/// uom: from-uom rowid
/// buom :  to-uom rowid
ClassMethod validConFac(uom As %String, buom As %String, fac As %String) As %String
{
 n (uom,buom,fac)
 i uom=buom q 0
 s active="Y"
 s rowid=""
 &sql(select %id,ctcf_factor into :conf,:factor from ct_confac where ctcf_fruom_dr=:uom and ctcf_touom_dr=:buom)
 i SQLCODE d
 .&sql(insert into ct_confac (ctcf_fruom_dr,ctcf_touom_dr,ctcf_factor,ctcf_activeflag) 
  values (:uom,:buom,:fac,:active ) )
 .i SQLCODE'=0 q 
 .s rowid=+$G(%ROWID)
 e  d
 .i +factor=+fac s rowid=conf
 .
 q rowid
}

/// 验证供应商
/// return:
///   >0 - ok 
///   <0 - 失败
///   "" - ""
ClassMethod validVendor(vendor As %String, HospId As %String) As %String
{
 n (vendor,HospId)
 q:vendor="" ""
 s type=..sssCode()
 s rowid=""
 //&sql(select apcvm_rowid into :v from apc_vendor where apcvm_name=:vendor)
 s v=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",vendor,"APC_Vendor",HospId)
 
 i +v'>0 d
 .&sql(insert into APC_Vendor(apcvm_code,apcvm_name,apcvm_type) values (:vendor,:vendor,:type))
 .i SQLCODE'=0 q 
 .s rowid=$G(%ROWID)
 .i rowid'="" d
 ..&sql(insert into dhc_stvendor (STV_Vendor_DR,STV_Hospital_DR) values (:rowid,:HospId))
 e  d
 .s rowid=+v
 s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",rowid,HospId)
 q:ret'=0 ""
 q rowid
}

/// 验证生产厂家
/// return:
///   >0 - ok 
///   <0 - 失败
///   "" - ""
ClassMethod validManf(manf As %String, HospId As %String) As %String
{
 n (manf,HospId)
 q:manf="" ""
 s type=..sssCode()
 s rowid=""

 s ret=0
 //&sql(select phmnf_rowid into :m from ph_manufacturer where phmnf_name=:manf)
 s m=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",manf,"PH_Manufacturer",HospId)
 i +m'>0 d
 .&sql(insert into  ph_manufacturer(phmnf_code,phmnf_name,PHMNF_Hospital_DR) values (:manf,:manf,:HospId))
 .i SQLCODE'=0 s ret=-1  q 
 .s rowid=+$G(%ROWID)
 e  d
 .s rowid=+m
 q:ret<0 ret
 q:rowid<1 -1
 &sql(select manf_rowid into :ma from  dhc_manf_addioninfo where manf_phcmanf_dr=:rowid)
 i SQLCODE d
 .s active="Y"   //激活状态缺省为"Y"
 .&sql(insert into dhc_manf_addioninfo (manf_phcmanf_dr,manf_type,manf_active) values (:rowid,:type,:active))
 .i SQLCODE'=0 s ret=-2  q 
 
 q:ret<0 ret
 s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",rowid,HospId)
 q:ret'=0 ""
 ;tcommit
 q rowid
}

/// 验证配送商
ClassMethod validCarrier(carrier As %String, HospId As %String) As %String
{
 n (carrier,HospId)
  q:carrier="" ""
  s ca=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",carrier,"DHC_Carrier",HospId)
  //&sql(select ca_rowid into :ca from dhc_carrier where ca_desc=:carrier)     
  i +ca'>0 d
  . s type=..sssCode()
  . &sql(insert into dhc_carrier(ca_code,ca_desc,ca_type,CA_Hospital_DR) values (:carrier,:carrier,:type,:HospId))
  . i SQLCODE'=0 s ret=-121 q 
  . s ca=$g(%ROWID)
  s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_Carrier",ca,HospId)
  q:ret'=0 ""
  q ca
}

/// 自动算出类组代码
ClassMethod getScgCode(prefix) As %String
{
 n (prefix)
 s scgCodeWidth=..ScgCodeWidth()
 s SerialNo=""
 f i=1,i<=scgCodeWidth,i=i+1 d
 .s SerialNo=SerialNo_"[0-9]"		;避免scg_code可能出现的重复
 s qcon=prefix_SerialNo
 &sql(select max(scg_code) into :x from dhc_stkcatgroup where scg_code %MATCHES :qcon)
 s x=$g(x)
 i x="" d
 .;s code="001"
 .s code=$tr($j(1,scgCodeWidth)," ","0")
 e  d
 .s serial=$p(x,prefix,2)
 .s code=$tr($j(+serial+1,scgCodeWidth)," ","0")
 q prefix_code
}

/// 自动算出分类代码
ClassMethod getScCode(prefix) As %String
{
 n (prefix)
 s scCodeWidth=..ScCodeWidth()
 s SerialNo=""
 f i=1,i<=scCodeWidth,i=i+1 d
 .s SerialNo=SerialNo_"[0-9]"		;避免scg_code可能出现的重复
 s qcon=prefix_SerialNo
 &sql(select max(incsc_code) into :x from inc_stkcat where incsc_code %MATCHES :qcon)
 s x=$g(x)
 i x="" d
 .;s code="001"
 .s code=$tr($j(1,scCodeWidth)," ","0")
 e  d
 .s serial=$p(x,prefix,2)
 .s code=$tr($j(+serial+1,scCodeWidth)," ","0")
 q prefix_code
}

ClassMethod prefix() As %String
{
 q "CL"
}

ClassMethod User() As %String
{
 s user=""
 &sql(select %id into :user from ss_user where ssusr_initials='demo')
  q $G(user)
}

/// 生成别名数据，缺省可以生成如下别名：
///   1.物资名称描述拼音首字符
///   2.物资代码
///   3.五笔
///   4.协和码
///   5.指定的别名
ClassMethod createAlias(inci As %String, alias As %String) As %String
{
 n (inci,alias)
 s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
 &sql(select inci_code,inci_desc,INCI_ReportingDays into :code,:desc,:xiehe from inc_itm where inci_rowid=:inci)
 s py=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(desc,4,"")  ;别名一:描述的拼音首字符
 s py=$$ALPHAUP^SSUTIL4(py)
 &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)
   values (:py,:code,:desc,:inci)  )
 i SQLCODE'=0 q RtnObj.Err(-1,"","别名插入失败")
  ;别名二:代码
 &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
   values (:code,:code,:desc,:inci)  )
   //b
 i SQLCODE'=0 q RtnObj.Err(-1,"","代码别名插入失败")
 ; 
  ;别名三:五笔码
  s five=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(desc,6,"")
  s five=$e(five,1,30) // 取前30个字符  
  &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
   values (:five,:code,:desc,:inci)  )
   i SQLCODE'=0 q RtnObj.Err(-1,"","五笔码别名插入失败")

  ;别名四:协和码
  i $g(xiehe)'="" d
  . &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:xiehe,:code,:desc,:inci)  )
  . i SQLCODE'=0 d RtnObj.Err(-1,"","别名插入失败")
 q:RtnObj.success'=0 RtnObj
 i alias'="" d
 .&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:alias,:code,:desc,:inci)  )
 .i SQLCODE'=0 d RtnObj.Err(-1,"","别名插入失败")
 q:RtnObj.success'=0 RtnObj
 q RtnObj
}

/// 生成调价记录
/// inci -库存项目rowid
/// user -用户
/// rp -进价
/// sp -售价
/// hosp -医院rowid
/// 
ClassMethod createAsp(inci, user, rp, sp, hosp, priceinformation, AdjSpNo) As %String
{
  n (inci, user, rp, sp, hosp,priceinformation,AdjSpNo)
  s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
  s AdjDate=+$h
  s PreExecuteDate=AdjDate
  s ExecuteDate=AdjDate
  s ItmRowid=inci
   &sql(select inci_incsc_dr,inci_ctuom_dr,inci_ctuom_purch_dr into :StkCatId,:uom,:puom from inc_itm where inci_rowid=:inci)
   i SQLCODE d RtnObj.Err(-1,"","查询基础信息失败")
   q:RtnObj.success'=0 RtnObj
   
   s User=..User()
   s HospId=hosp
   s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,uom)
   s ResultSp=sp
   s ResultRp=rp
   s AdjUomId=puom
   
   s BResultSp=ResultSp/fac
   s BResultRp=ResultRp/fac
   s BPriorRp=0
   s BPriorSp=0
   
   s AdjUserId=user
   s Status="Yes"
   s Remark="初始化数据"
   
  &sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,
    inasp_resultsp,inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,inasp_ctuom_price,
    INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,
    INASP_PreExeDate,INASP_Remark,INASP_WarrentNo) 
    values(:AdjDate,:ItmRowid,:StkCatId,:BPriorSp,:BResultSp,:AdjUserId,:Status,:AdjSpNo,:ExecuteDate,
    :AdjUomId,:ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,
    :PreExecuteDate,:Remark,:priceinformation) )
  i SQLCODE'=0  d RtnObj.Err(-1,"","插入调价表失败")
   q:RtnObj.success'=0 RtnObj
  q RtnObj
}

/// dhc_itmven
ClassMethod validIV(inci As %String, v As %String, m As %String, ca As %String, rp As %String, sp As %String) As %String
{
 n (inci,v,m,ca,rp,sp)
  s ret=0
  &sql(select dhciv_rowid into :iv from dhc_itmven where dhciv_inci_dr=:inci and dhciv_apcvm_dr=:v )
  i SQLCODE  d
  .s type=..sssCode()
  . &sql(insert into dhc_itmven(dhciv_inci_dr,dhciv_apcvm_dr,dhciv_manf_dr,dhciv_carrier_dr,dhciv_purprice,dhciv_saleprice,dhciv_itmtype)
     values(:inci,:v,:m,:ca,:rp,:sp,:type))
  .i SQLCODE'=0 s ret=-131 q
  e  d
  .s type=..sssCode()
  .&sql(update dhc_itmven set dhciv_manf_dr=:m,dhciv_carrier_dr=:ca,dhciv_purprice=:rp,dhciv_saleprice=:sp,dhciv_itmtype=:type where dhciv_rowid=:iv)
  .i SQLCODE'=0 s ret=-132 q
    
  q ret
}

/// dhc_itmremark
ClassMethod validIR(inci As %String, m As %String, registerno As %String, registerexpdate As %String) As %String
{
	n (inci,m,registerno,registerexpdate)
	
	s ret=0
	;获取注册证Id
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s regTitle="MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc^MRCValidExtend^MRCMCDR"
	s regData=registerno_"^"_""_"^"_registerexpdate_"^"_""_"^"_""_"^"_""
	s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	s paramstr=inci_"^"_m
	s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(regObj,paramstr)
	q:RtnObj.success<0 -110
	
	q ret
}

/// 重新生成别名(按类组)
/// 注意：适用于别名因故未能正确生成的情况
/// arguments:
///   scgDesc  -类组名称
///  
ClassMethod reCreateAlias(scgDesc) As %String
{
	&sql(declare xx cursor for
	SELECT inci_rowid,inci_desc,inci_code 
	  FROM inc_itm WHERE INCI_incsc_dr IN (
     SELECT scgr_stkcat_dr FROM dhc_stkcatgrprelations WHERE SCGR_SCG_Parref->scg_desc=:scgDesc   ) 
   )
   
    s n=0
    &sql(open xx)
    f  &sql(fetch xx into :inci,:desc,:code) q:SQLCODE     d
    .
    . s code=$g(code)
    . s desc=$g(desc)
    . s py=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(desc,4,"")  ;别名一:描述的拼音首字符
    . s py=$$ALPHAUP^SSUTIL4(py)
    . &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)
       values (:py,:code,:desc,:inci)  )
    . i SQLCODE'=0 w "Error:"_desc,!
    . s n=n+1
    .  
	
	&sql(close xx)
	 q n
}

/// 库存类组代码序号宽度(缺省为3)
/// 
ClassMethod ScgCodeWidth() As %String
{
	q 3
}

/// 库存分类代码序号宽度(缺省为3)
/// 
ClassMethod ScCodeWidth() As %String
{
	q 3
}

/// 更新标准库存
/// author:zhwh
/// date:2014-03-20
ClassMethod updStkLevel(loc As %String, inci As %String, stklevel As %String) As %String
{
	n (loc,inci,stklevel)
	s rowid=""
	q:loc="" -1
	q:inci="" -2
	s err=0
	&sql(select %id into :rowid from inc_itmloc where incil_inci_parref=:inci and incil_ctloc_dr=:loc)
	i rowid="" d
	.  &sql(insert into inc_itmloc(incil_inci_parref,incil_ctloc_dr) values (:inci,:loc)     )
	.i SQLCODE'=0 d
	..s err=-3 q
	.e  d
	..s rowid=$G(%ROWID)
    q:err<0 err
    i rowid'="" d
    .s stklevel=+stklevel
    .&sql(update inc_itmloc set incil_repqty=:stklevel where incil_rowid=:rowid)
   	.i SQLCODE'=0 s err=-4 q
   	q:err<0 err
    q err
}

/// 更新供应商信息
/// w ##class(web.DHCSTMHUI.Tools.CodeInputNew).updVendorInfo()
ClassMethod updVendorInfo(v As %String, info As %String, qualityinfo As %String) As %String
{
  n (v,info,qualityinfo,%session)
  s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()  
  
  s contactperson=$P(info,"^",1)   //业务联系人(业务员)
  s authorizationdate=$P(info,"^",2) //业务授权截止期(业务员)
  s contacttel=$P(info,"^",3) //业务联系人电话(业务员)	
  
  &sql(update dhc_stvendor set stv_salesname=:contactperson where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .d RtnObj.Err(-1,"","业务联系人更新错误:"_SQLCODE)
  q:RtnObj.success'=0 RtnObj
  
  s authorizationdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(authorizationdate)
  i +authorizationdate<0 d RtnObj.Err(-2,"","业务授权截止期格式不正确!","",0)
  q:RtnObj.success'=0 RtnObj
  &sql(update dhc_stvendor set stv_salesdate=:authorizationdate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .d RtnObj.Err(-1,"","业务授权截止期更新错误:"_SQLCODE)
  q:RtnObj.success'=0 RtnObj
  
  &sql(update dhc_stvendor set stv_salestel=:contacttel where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .d RtnObj.Err(-1,"","业务联系人电话更新错误:"_SQLCODE)
  q:RtnObj.success'=0 RtnObj
  
  s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetailList("Vendor",v,qualityinfo)
  q:RtnObj.success'=0 RtnObj
  q RtnObj
}

/// 更新生产厂家信息	
/// w ##class(web.DHCSTMHUI.Tools.CodeInputNew)updManfInfo()
ClassMethod updManfInfo(m As %String, info As %String, ManfQualityinfo As %String) As %String
{
  n (m,info,ManfQualityinfo)
  s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
  s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetailList("Manf",m,ManfQualityinfo)
  q:RtnObj.success'=0 RtnObj
  q RtnObj
}

/// 处理一行数据(医用)
/// 
ClassMethod InputIncItmA(RowObj, AdjSpNo) As %String
{
  n (RowObj,AdjSpNo,%session)
  s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New() 
  s RtnObj=..InputIncItm(RowObj,AdjSpNo)
  q:RtnObj.success'=0 RtnObj
  s Inci=RtnObj.rowid
  
  //插入医嘱项
  s RtnObj=..impArcim(Inci,RowObj)
  q:RtnObj.success'=0 RtnObj
  s charge="Y"
  &sql(UPDATE DHC_ItmAddionInfo SET INFO_ChargeFlag=:charge WHERE INFO_INCI_DR=:Inci)
  q RtnObj
}

/// 插入医嘱项目、收费项目数据
///  code - 库存项代码
///  row - 数据行(字符串)
///  
ClassMethod impArcim(inci, RowObj) As %String
{
 n (inci,RowObj,%session)
 s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
 s gHospId=$p(..sssParamStr(),"^",4)
 s Hospital=RowObj.%Get("医院")
 s HospId=""
 i Hospital'="" d
 .&sql(SELECT HOSP_RowId INTO:HospId FROM CT_Hospital WHERE HOSP_Desc=:Hospital)
 .s:HospId="" HospId=gHospId
 s incicode=""
 &sql(SELECT INCI_Code INTO:incicode FROM INC_Itm WHERE INCI_RowId=:inci)
 s TarCode=RowObj.%Get("收费代码")
 s:TarCode="" TarCode=incicode
 i TarCode="" s TarCode=RowObj.%Get("物资代码")  //收费名称采用库存项目名称
 s TarDesc=RowObj.%Get("收费名称")
 i TarDesc="" s TarDesc=RowObj.%Get("物资名称")
 s Param="^^^"_HospId
 s ArcimDescAutoMode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAINM","ArcimDescAutoMode",Param)
 s spec=RowObj.%Get("规格")
 i (ArcimDescAutoMode=1)&&(spec'="") s TarDesc=TarDesc_"("_spec_")" 
 s OrdCode=TarCode  //医嘱项代码=收费项代码
 s OrdDesc=TarDesc   //医嘱项名称=收费项名称
 s traSp=RowObj.%Get("售价")
 s bUom=RowObj.%Get("最小单位")		//基本单位
 s feeUom=bUom	//账单单位
 ///将医嘱项、收费项的数据变量拼串
 s RowStr=""
 s $P(RowStr,"^",1)=TarCode
 s $P(RowStr,"^",2)=TarDesc
 s $P(RowStr,"^",3)=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(TarDesc,4)
 s $P(RowStr,"^",4)=traSp
 s $P(RowStr,"^",7)=OrdCode
 s $P(RowStr,"^",8)=OrdDesc
 s $p(RowStr,"^",5)=feeUom			//账单单位
 s $p(RowStr,"^",10)=bUom
 
 s ordcat=RowObj.%Get("医嘱大类")	
 s ordsubcat=RowObj.%Get("医嘱子类")		//医嘱子类	
 s billcat=RowObj.%Get("账单大类")
 s billsubcat=RowObj.%Get("账单子类")	//费用子类	
 s tarcat=RowObj.%Get("收费大类")
 s tarsubcat=RowObj.%Get("收费子类")		//收费子类	
 s inpacat=RowObj.%Get("住院大类")
 s inpasubcat=RowObj.%Get("住院子类")	//住院子类  
 s outpacat=RowObj.%Get("门诊大类")
 s outpasubcat=RowObj.%Get("门诊子类")	//门诊子类
 s emcat=RowObj.%Get("核算大类")
 s emsubcat=RowObj.%Get("核算子类")		//核算子类
 s acctcat=RowObj.%Get("会计大类")
 s acctsubcat=RowObj.%Get("会计子类")	//会计子类	
 s mrcat=RowObj.%Get("病案大类")
 s mrsubcat=RowObj.%Get("病案子类")		//病案子类
 s mrsubcatnew=RowObj.%Get("新病案首页子类")	//新病案首页子类
 s $P(RowStr,"^",11)=ordcat
 s $P(RowStr,"^",12)=ordsubcat
 s $P(RowStr,"^",13)=billcat
 s $P(RowStr,"^",14)=billsubcat
 //
 s $P(RowStr,"^",15)=tarcat
 s $P(RowStr,"^",16)=tarsubcat
 s $P(RowStr,"^",17)=inpacat
 s $P(RowStr,"^",18)=inpasubcat
 s $P(RowStr,"^",19)=outpacat
 s $P(RowStr,"^",20)=outpasubcat
 s $P(RowStr,"^",21)=emcat
 s $P(RowStr,"^",22)=emsubcat
 s $P(RowStr,"^",23)=acctcat
 s $P(RowStr,"^",24)=acctsubcat
 s $P(RowStr,"^",25)=mrcat
 s $P(RowStr,"^",26)=mrsubcat
 
 s $P(RowStr,"^",28)=RowObj.%Get("独立医嘱")	
 s $P(RowStr,"^",29)=RowObj.%Get("医嘱优先级")
 s $P(RowStr,"^",35)=OrdDesc	//abbr
 s $p(RowStr,"^",36)=RowObj.%Get("无库存医嘱")
 s $p(RowStr,"^",37)=mrsubcatnew	//新病案首页子类
 s insucode=RowObj.%Get("医保编码")	;医保编码
 s insudesc=RowObj.%Get("医保描述")	;医保描述
 s $p(RowStr,"^",38)=insucode
 s $p(RowStr,"^",39)=insudesc
 s msg=..ArcimData("",RowStr,HospId)  //处理医嘱、收费项等
 i +msg>0 d
 .s arcim=msg
 .&sql(update inc_itm set INCI_OriginalARCIM_DR=:arcim where %id=:inci)
 .i SQLCODE'=0 d RtnObj.Err(-1,"","更新库存项医嘱指针失败")
 e   d
 .d RtnObj.Err(-1,"","处理医嘱,收费项失败")
 
 q RtnObj
}

/// 医嘱数据
/// 此方法是从web.DHCFHQ.DHCFFHQ.cls摘录并整理而来
/// Arguments:
///    ChangeType  - 为空
///    RowStr - 一行数据
/// Return:
///   rowid - 处理成功(+ret>0) ;  错误信息(错误:....)
ClassMethod ArcimData(ChangeType As %String = "", RowStr As %String = "", HospId = "") As %String
{
	//	1	       2	       3	     4	      5      	6	     7	         8	         9	          10	    
	//收费代码	收费名称	收费拼音	单价	单位	收费依据	医嘱代码	医嘱项名称	医嘱拼音	医嘱单位	
	//11		12			13			14			15			16			17			18			19			   20
	//医嘱大类	医嘱子类	帐单大类	帐单子类	收费大类	收费子类	住院发票	住院子类	门诊发票	门诊子类
	// 21		   	22	    	23		24		25	  	26			27		 28		      29	30	
	// 核算类	核算子类	会计类	会计子类	病案类	病案子类	开展	独立医嘱	优先级	结果
	//  31       32			33		34			35				36			37			38			39
	//次数	医嘱提示	设备名称	急诊标识	医嘱项简称  无库存医嘱	新病案首页子类	医保编码	医保描述
 n (ChangeType,RowStr,HospId) 
 s del="^"
 s RetStr=""
 SET RowStr=$tr(RowStr," ","")
 SET TarCode=$$ALPHAUP^SSUTIL4($P(RowStr,del,1)),TarDesc=$P(RowStr,del,2),OrdCode=$$ALPHAUP^SSUTIL4($P(RowStr,del,7)),OrdDesc=$P(RowStr,del,8)
 if ((OrdCode="") & (OrdDesc="")) d
 else  d
 .if OrdCode="" s RetStr=..RetErrorValue(RetStr,"医嘱代码为空:")
 .if OrdDesc="" s RetStr=..RetErrorValue(RetStr,"医嘱名称为空:")
 if ((TarCode="") & (TarDesc="")) d
 else  d
 .if TarCode="" s RetStr=..RetErrorValue(RetStr,"收费项代码为空:")
 .if TarDesc="" s RetStr=..RetErrorValue(RetStr,"收费项名称为空:")
 if (($g(OrdDesc)'="")&($g(OrdCode)'="")) d
 .s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",OrdCode,"ARC_ItmMast",HospId)	
 .i (TmpId'="") s RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
 .s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",OrdDesc,"ARC_ItmMast",HospId)	
 .i (TmpId'="") s RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
 .;s:($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
 .;s:($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode)))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
 if (($g(TarCode)'="")&($g(TarDesc)'="")) d
 .s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",TarCode,"DHC_TarItem",HospId)	
 .i (TmpId'="") s RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",TarDesc,"DHC_TarItem",HospId)	
 .i (TmpId'="") s RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)
 .;s:($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode)))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .;s:($D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc)))&('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)

 s UserDr=$o(^SSU("SSUSR",0))
 s BaseUom=$p(RowStr,del,10),BaseUomDr="" //基本单位
 if BaseUom="" s RetStr=..RetErrorValue(RetStr,"基本单位为空"_OrdCode) 
 i BaseUom'=""  d
 .s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
 if BaseUomDr="" s RetStr=..RetErrorValue(RetStr,"医嘱单位指针出错"_OrdCode_":"_BaseUom) q RetStr
 
 s TarUom=$p(RowStr,del,5),TarUomDr="" //账单单位
 if TarUom="" s RetStr=..RetErrorValue(RetStr,"账单单位为空"_OrdCode) 
 i TarUom'=""  d
 .s TarUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(TarUom),""))
 if TarUomDr="" s RetStr=..RetErrorValue(RetStr,"账单单位指针出错"_TarCode_":"_BaseUom) 

 s OrdMsg=$P(RowStr,del,32),Equipment=$P(RowStr,del,33)
 s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,28))
 s qty=$P(RowStr,del,31)
 s WoStock=$p(RowStr,del,36)
 if $g(qty)="" s qty=1
 s:OnItsOwn="" OnItsOwn="Y"
 s:WoStock="" WoStock="Y"
 //医嘱项
 s ArcimRowid=""
 s TmpArcCodeId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",OrdCode,"ARC_ItmMast",HospId)
 s TmpArcDescId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",OrdDesc,"ARC_ItmMast",HospId)
 if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
 .;if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 .if (TmpArcCodeId="")&&(TmpArcDescId="")  d
 ..S abbr=$p(RowStr,del,35)
 ..s ArcCat=$p(RowStr,del,11)
 ..s ArcSubCat=$p(RowStr,del,12),ArcSubCatDr=""
 ..if ArcSubCat="" s RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_OrdCode) q  
 ..;s ArcSubCatTmp=ArcSubCat_ArcCat
 ..;s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
 ..;s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCatTmp),""))
 ..s ArcSubCatDr=..CodeDescGetId(ArcSubCat,"ARC_ItemCat",HospId)
 ..if ArcSubCatDr="" s RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_OrdCode_","_ArcSubCat) q
 ..i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
 ..s BillGrp=$p(RowStr,del,13)
 ..s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_OrdCode)
 ..q:BillGrp=""
 ..;s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
 ..s BillGrpDr=..CodeDescGetId(BillGrp,"ARC_BillGrp",HospId)
 ..s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_OrdCode_","_BillGrp)
 ..q:BillGrpDr=""
 ..s BillSubGrp=$p(RowStr,del,14)
 ..s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_OrdCode_","_BillSubGrp)
 ..q:BillSubGrp=""
 ..;s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
 ..;s BillSubGrpDr=..CodeDescGetId(BillSubGrp,"ARC_BillSub",HospId)
 ..;s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_OrdCode_","_BillSubGrp)
 ..;q:BillSubGrpDr=""
 ..;s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
 ..s BillSubGrpDr=..CodeDescGetId(BillSubGrp,"ARC_BillSub",HospId)
 ..s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_OrdCode_","_BillSubGrp)
 ..
 ..s Priority=$p(RowStr,del,29)
 ..s Priority=$tr(Priority," ","")
 ..s:$g(Priority)'="" PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
 ..if (($g(PrioDr)="")&($g(Priority)'="")) s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_OrdCode)
 ..s:$g(PrioDr)="" PrioDr=""
 ..s resGrp=$p(RowStr,del,30)
 ..s ServiceGroupDr=""
 ..if $g(Equipment)'="" d
 ...s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ArcCat),""))
 ...if $g(ServiceGroupDr)="" s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4("检查"),""))
 ..S Sentive=$p(RowStr,del,34)
 ..if ChangeType'="Test" d
 ...k PLIST 
 ...IF $G(Sentive)'="" S PLIST(133)="Y"
 ...if $g(ServiceGroupDr)'="" s PLIST(97)=ServiceGroupDr,PLIST(76)="S"
 ...if ArcCat["材料" s PLIST(76)="M"
 ...s PLIST(2)=OrdCode,PLIST(3)=OrdDesc,PLIST(4)=abbr,PLIST(105)=BaseUomDr
 ...s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn,PLIST(102)=WoStock
 ...s PLIST(113)=PrioDr,PLIST(117)=resGrp
 ...&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcimRowid=$p($g(%ROWID),$c(1))
 ...;院区处理
 ...s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(ArcimRowid,HospId)
 ...i ret'=0 s RetStr=..RetErrorValue(RetStr,"关联医院医嘱项失败"_OrdCode)
 ...s ArcimId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",OrdCode,"ARC_ItmMast",HospId)
 ...s:(ArcimId="")||(ArcimRowid'=ArcimId) RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ...q:ArcimId=""
 ...s ArcimId1=+ArcimId
 ...q:ArcimId1=""
 ...s ArcimId2=$p(ArcimId,"||",2)
 ...q:ArcimId2=""
 ...;s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ...;s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ...;q:ArcimId1=""
 ...;s ArcimId2=$o(^ARCIM(0,"Code",OrdCode,ArcimId1,""))
 ...;q:ArcimId2=""
 ...;s ArcimId=ArcimId1_"||"_ArcimId2
 ...//医嘱提示信息
 ...IF $g(OrdMsg)'="" d 
 ....IF $D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ....IF '$D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",0)=1,^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ...//价格
 ...s Price=$tr($p(RowStr,del,7)," ")
 ...i Price'="" s Price=+Price
 ...else  s RetStr=..RetErrorValue(RetStr,"价格为空")
 ...q:Price=""
 ...if ChangeType'="Test" d
 ....k PLIST
 ....s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
 ....;&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
 ....;s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 
 //医嘱别名
 s TmpArcCodeId1=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",OrdCode,"ARC_ItmMast",HospId)
 s TmpArcDescId1=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",OrdDesc,"ARC_ItmMast",HospId)
 ;if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
 if (TmpArcCodeId1'="")&(TmpArcDescId1'="") d
 .;if (($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 .s Alias=$P(RowStr,del,9)
 .
 .;2015-09-09 按医嘱项代码,名称生成别名
 .s DescAlias=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(OrdDesc,4,"")
 .s tmpAlias=OrdCode_"/"_DescAlias
 .i Alias'="" s tmpAlias=tmpAlias_"/"_Alias
 .s Alias=tmpAlias
 .
 .i Alias'="" d
 ..;s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ..;s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"别名取医嘱针出错:"_OrdCode)
 ..;q:ArcimId1=""
 ..;s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ..;q:ArcimId2=""
 ..;s ArcimId=ArcimId1_"||"_ArcimId2
 ..s ArcimId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",OrdCode,"ARC_ItmMast",HospId)
 ..s:(ArcimId="")||(ArcimRowid'=ArcimId) RetStr=..RetErrorValue(RetStr,"别名取医嘱针出错:"_OrdCode)
 ..q:ArcimId=""
 ..s ArcimId1=+ArcimId
 ..q:ArcimId1=""
 ..s ArcimId2=$p(ArcimId,"||",2)
 ..q:ArcimId2=""
 ..
 ..s ArcCatDr=""
 ..s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 ..if $g(ArcSubCatDr) s ArcCatDr=$p($g(^ARC("IC",ArcSubCatDr)),del,8)
 ..set I=0
 ..s num=$l(Alias,"/")
 ..s ALI=""
 ..FOR  S I=I+1 q:I>num  d
 ...s ALI=$p(Alias,"/",I)
 ...q:$g(ALI)=""
 ...;q:$d(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc)))
 ...S AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc),0))
 ...if $g(AliaId)'="" s ArcimIdTmp=$p(^ARC("ALIAS",AliaId),del,1)
 ...q:(($g(ArcimId)=$g(ArcimIdTmp))&($g(AliaId)'=""))
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...if ChangeType'="Test" d
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ....set PLIST(4)=ALI
 ....if $g(AliaId)'="" d
 .....&SQL(Update SQLUser.ARC_Alias Set ALIAS_ARCIM_DR=:ArcimId where ALIAS_RowId=:AliaId) 
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ....q:$g(SQLCODE)
 ....s ArcKeyId=0,CircleFlag=1
 ....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 .....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 .....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ....;q:(CircleFlag=0)
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_OrdDesc,PLIST(6)=$g(ArcSubCatDr),PLIST(7)=$g(ArcCatDr)
 ....set PLIST(4)=ALI_"Z"
 ....if CircleFlag=0 d
 .....&SQL(Update SQLUser.ARC_ItemKeywords set KEYW_ARCIM_DR=:ArcimId where KEYW_RowId=:ArcKeyIdTmp)
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 
 //医嘱对应设备的服务
 if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(Equipment)'="")) d
 .;if (($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($g(Equipment)'="")) d
 .if (TmpArcCodeId1'="")&(TmpArcDescId1'="") d
 ..s ArcimId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OrdDesc,"ARC_ItmMast",HospId)
 ..s:(ArcimId="")||(ArcimRowid'=ArcimId) RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"__OrdDesc)
 ..q:ArcimId=""
 ..s ArcimId1=+ArcimId
 ..q:ArcimId1=""
 ..s ArcimId2=$p(ArcimId,"||",2)
 ..q:ArcimId2=""
 ..;s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),""))
 ..;s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_OrdDesc)
 ..;q:ArcimId1=""
 ..;s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),ArcimId1,""))
 ..
 ..
 ..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
 ..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_OrdDesc)
 ..q:((Service="")!(Equipment="S"))
 ..s ServiceId=0
 ..s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
 ..;s:EqId="" RetStr=..RetErrorValue(RetStr,"取设备指针指针出错:"_Equipment)
 ..q:EqId=""
 ..s CircleFlag=1
 ..f  s ServiceId=$o(^RBC("SER",0,"EQ",EqId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
 ...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
 ...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
 ..q:CircleFlag=0
 ..if ChangeType'="Test" d
 ...k PLIST
 ...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(6)=EqId,PLIST(7)=$g(OrdDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
 ...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
 ...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 
 //收费项目
 s TmpTarCodeId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",TarCode,"DHC_TarItem",HospId)
 s TmpTarDescId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",TarDesc,"DHC_TarItem",HospId)
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .;if (('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) d
 .if (TmpTarCodeId="")&&(TmpTarDescId="") d
 ..s TarSubCatDr="",OUTPDR="",INPDR="",EMCDR="",ACCTDR="",ACCTDR="",MRDR="",MRDRNew=""
 ..s TarSubCat=$P(RowStr,del,16)
 ..s TarChargeBasis=$P(RowStr,del,6)
 ..SET INP=$P(RowStr,del,18),OUTP=$P(RowStr,del,20),EMC=$P(RowStr,del,22),ACCT=$P(RowStr,del,24),MR=$P(RowStr,del,26),MRNew=$P(RowStr,del,37)
 ..q:TarUomDr=""
 ..s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_TarCode)
 ..;q:TarSubCat=""
 ..;SET:TarSubCat'="" TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
 ..SET:TarSubCat'="" TarSubCatDr=..CodeDescGetId(TarSubCat,"DHC_TarSubCate",HospId)
 ..s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_TarCode_","_TarSubCat)
 ..
 ..;Q:TarSubCatDr=""
 ..if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_TarCode) 
 ..;SET:OUTP'="" OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
 ..SET:OUTP'="" OUTPDR=..CodeDescGetId(OUTP,"DHC_TarOutpatCate",HospId)
 ..if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_TarCode_","_OUTP) 
 ..if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_TarCode) 
 ..;SET:INP'="" INPDR=$O(^DHCTarC("IC",0,"Desc",INP,""))
 ..SET:INP'="" INPDR=..CodeDescGetId(INP,"DHC_TarInpatCate",HospId)
 ..if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_TarCode_","_INP) 
 ..if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_TarCode) 
 ..;SET:EMC'="" EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
 ..SET:EMC'="" EMCDR=..CodeDescGetId(EMC,"DHC_TarEMCCate",HospId)
 ..if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_TarCode_","_EMC) 
 ..if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_TarCode) 
 ..;SET:ACCT'="" ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
 ..SET:ACCT'="" ACCTDR=..CodeDescGetId(ACCT,"DHC_TarAcctCate",HospId)
 ..if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_TarCode_","_ACCT) 
 ..if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_TarCode) 
 ..;SET:MR'="" MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
 ..SET:MR'="" MRDR=..CodeDescGetId(MR,"DHC_TarMRCate",HospId)
 ..if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_TarCode_","_MRDR) 
 ..if MRNew="" s RetStr=..RetErrorValue(RetStr,"新病案子类为空:"_TarCode)
 ..SET:MRNew'="" MRDRNew=..CodeDescGetId(MRNew,"DHC_TarMCCateNew",HospId)
 ..if MRDRNew="" s RetStr=..RetErrorValue(RetStr,"新病案指针出错:"_TarCode_","_MRDRNew)
 ..
 ..if ChangeType'="Test" d
 ...SET INSUCode=$p(RowStr,del,38),INSUDesc=$p(RowStr,del,39)
 ...K PLIST
 ...SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
 ...SET PLIST(2)=TarCode,PLIST(3)=TarDesc,PLIST(4)=BaseUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
 ...SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR,PLIST(21)=TarChargeBasis,PLIST(22)=MRDRNew
 ...SET PLIST(17)=INSUCode,PLIST(19)=INSUDesc
 ...&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s TarId=$p($g(%ROWID),$c(1))
 ...;院区处理
 ...s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_TarItem",TarId,HospId)
 ...i ret'=0 s RetStr=..RetErrorValue(RetStr,"关联医院收费项失败"_TarCode)
 ...;S ^DHCTARI(0)=^mdata("DHCTARITEM")
 ...;s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),""))
 ...s TarId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",TarCode,"DHC_TarItem",HospId)
 ...if TarId="" s RetStr=..RetErrorValue(RetStr,"收费项指针出错"_TarCode)
 ...q:TarId=""
 ...s $p(^DHCTARI(TarId),"^",30)=MRDRNew		;设置新病案首页
 ...set I=1
 ...k PLIST 
 ...s PLIST(2)=TarId,PLIST(3)=TarDesc
 ...s Alias=$p(RowStr,del,3)
 ...if Alias="" s RetStr=..RetErrorValue(RetStr,"收费项别名空"_TarCode)
 ...FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
 ....S ALI=$E(ALI,1,9)
 ....s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....set PLIST(4)=ALI
 ....SET I=I+1
 ....s TiaId=0,CircleFlag=1
 ....f  s TiaId=$o(^DHCTARAL("A",TarId,TiaId)) q:((TiaId="")!(CircleFlag=0))  d
 .....s AliaTmp=$p(^DHCTARAL(TiaId),del,3)
 .....if $$ALPHAUP^SSUTIL4(AliaTmp)=$$ALPHAUP^SSUTIL4(ALI) s CircleFlag=0
 ....if ((CircleFlag=1)&(ChangeType'="Test")) d
 .....&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .....;s ^DHCTARAL(0)=^mdata("DHCTARITEMALIAS")
 ...s Price=$tr($p(RowStr,del,4)," ","")
 ...s:Price'="" Price=+Price
 ...s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_TarCode)
 ...k PLIST 
 ...s PLIST(0)=TarId,PLIST(3)=+$H,PLIST(5)=Price,PLIST(8)=UserDr,PLIST(13)="1"
 ...q:(ChangeType="Test")
 ...&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 
 //医嘱与收费项目对照
 q:(($g(OrdCode)="")&($g(OrdDesc)="")) RetStr
 q:(($g(TarCode)="")&($g(TarDesc)="")) RetStr
 q:(($g(OrdCode)="")!($g(OrdDesc)="")) ..RetErrorValue(RetStr,"医嘱项目名称或代码为空")
 q:(($g(TarCode)="")!($g(TarDesc)="")) ..RetErrorValue(RetStr,"收费项目名称或代码为空")
 s TmpTarCodeId1=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",TarCode,"DHC_TarItem",HospId)
 s TmpArcCodeId1=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",OrdCode,"ARC_ItmMast",HospId)
 
 if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(TarCode)'="")!($g(TarDesc)'="")) d
 .;if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($d(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) d
 .if (TmpTarCodeId1'="")&&(TmpArcCodeId1'="") d
 ..;SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ..;if ArcimId1="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
 ..;q:ArcimId1=""
 ..;SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ..SET ArcimId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",OrdCode,"ARC_ItmMast",HospId)
 ..if ArcimId="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
 ..;SET TarId=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),""))
 ..SET TarId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",TarCode,"DHC_TarItem",HospId)
 ..if TarId="" s RetStr=..RetErrorValue(RetStr,"对照时收费项目id出错"_TarCode)
 ..q:TarId="" 
 ..q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId))
 ..if ChangeType'="Test" d
 ...K PLIST
 ...SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=qty,PLIST(5)=+$H-1
 ...&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...Q:$g(SQLCODE)
 ...;S ^DHCOLT(0)=^mdata("DHCORDERLINKTAR")
 
 ;院区处理
 ;s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(ArcimRowid,HospId)
 ;i ret'=0 s RetStr=..RetErrorValue(RetStr,"关联医院医嘱项失败"_OrdCode)
 ;s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_TarItem",TarId,HospId)
 ;i ret'=0 s RetStr=..RetErrorValue(RetStr,"关联医院收费项失败"_TarCode)
 q:RetStr="" ArcimRowid
 q "错误:"_RetStr
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

/// 获取新病案首页的rowid
ClassMethod GetMCNewId(MRDesc As %String) As %String
{
	n (MRDesc)
	s MRNew=""
	s rowid=0
	f  s rowid=$o(^DHCTarC("MCNew",rowid)) q:(rowid="")!(MRNew'="")  d
	.s Desc=$p(^DHCTarC("MCNew",rowid),"^",2)
	.i MRDesc=Desc s MRNew=rowid
	q MRNew
}

/// 根据名称获取rowid
/// w ##class(web.DHCSTMHUI.Tools.CodeInputNew).CodeDescGetId("材料费","ARC_BillSub",2)
ClassMethod CodeDescGetId(value, tableName, HospId)
{
	n (value, tableName, HospId)
	q:(value="")||(tableName="")||(HospId="") ""
	
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType(tableName)  //表类型
	s RetRowID=""
	s BDPHospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag() //医院级别授权是否开启
	s tmpvalue=value
	s value=$$ALPHAUP^SSUTIL4(value)
	s RetRowID=""
	;医嘱子类
	i (tableName="ARC_ItemCat") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^ARC("IC",0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;账单大类 ARC_BillGrp
	i (tableName="ARC_BillGrp") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^ARCBG(0,"DESC",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;账单子类 ARC_BillSub
	i (tableName="ARC_BillSub") d
	.s paref=0,count=0,tmpid=""
	.f  s paref=$o(^ARCBG("SG_Desc",value,paref)) q:(+paref=0)||(RetRowID'="")  d
	..s chl=$o(^ARCBG("SG_Desc",value,paref,0))
	..s Rowid=paref_"||"_chl
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;收费子类 DHC_TarSubCate
	i (tableName="DHC_TarSubCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("SC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;门诊子类 DHC_TarOutpatCate
	i (tableName="DHC_TarOutpatCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("OC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;住院子类 DHC_TarInpatCate
	i (tableName="DHC_TarInpatCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("IC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;核算子类 DHC_TarEMCCate
	i (tableName="DHC_TarEMCCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("EC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;会计科目子类 DHC_TarAcctCate
	i (tableName="DHC_TarAcctCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("AC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;病案子类 DHC_TarMRCate
	i (tableName="DHC_TarMRCate") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTarC("MC",0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;新病案子类 DHC_TarMCCateNew
	i (tableName="DHC_TarMCCateNew") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTARMRCATENEW(0,"Desc",tmpvalue,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s flag="N"
	..i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	...s flag =##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(tableName,Rowid,HospId) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...s BDPMapId=$o(^User.BDPMappingHospI("DataRef",tableName,HospId,Rowid,""),-1) 
	...i BDPMapId'="" s RetRowID=Rowid 
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	q RetRowID
}

}
