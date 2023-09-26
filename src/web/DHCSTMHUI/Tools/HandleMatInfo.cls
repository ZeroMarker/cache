Import sqluser

/// 
/// 物资导入程序
///   Author:zhwh
///   Date:
Class web.DHCSTMHUI.Tools.HandleMatInfo Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCSTMHUI.Tools.HandleMatInfo).AddInciForArcim("D:\tmp\AddInci.txt")		;仅库存项
/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符)
/// 处理有医嘱项但无库存项的已有材料基础数据20170407
ClassMethod AddInciForArcim(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  s AdjSpNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTADJSPM","","")
  
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  ;q 0
  s cnt=0
  s successCnt=0
  ;
  s i=2		//excel第一行英文表头,第二行中文表头
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s cnt=cnt+1
  .tstart
  .s msg=""
  .s ret1=..InputIncItm(rowStr,AdjSpNo,.msg)
  .w ret1,!
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  ..tro
  ..w msg,!
  ..d ..SetErr(i,msg)
  .w !
  k ^zTSA(p,sub)  //删除临时global
  q cnt_"^"_successCnt
}

/// 处理一行数据 *备注一行改为医嘱代码*
ClassMethod InputIncItm(rowStr As %String, AdjSpNo As %String, msg As %String) As %String
{
  n (rowStr,AdjSpNo,msg)
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  s ret=0
  s del="^"
  s code=$p(rowStr,del,..Col("code"))		;代码
  s desc=$p(rowStr,del,..Col("desc"))		;描述
  q:desc="" ret  //if description is null then quit 
  s alias=$p(rowStr,del,..Col("alias"))		;别名
  s spec=$p(rowStr,del,..Col("spec"))		;规格
  s model=$p(rowStr,del,..Col("model"))		;型号
  s brand=$p(rowStr,del,..Col("brand"))		;品牌
  s buom=$p(rowStr,del,..Col("buom"))		;基本单位
  s arccode=$p(rowStr,del,..Col("remarks"))		;医嘱代码
  ;判断医嘱是否存在
  s arcid=..IFArimByCode(arccode)
  if arcid="" s msg="医嘱项不存在" s ret=-29 q ret
  ;判断医嘱是否作废
  s ret=..IFArcimNotUse(arccode)
  if ret<0 s msg="医嘱无效" s ret=-31 q ret
  ;判断医嘱是否存在库存项
  s exitInci=..IFInci(arcid)
  if exitInci'="" s msg=arccode_"存在库存项" s ret=-30 q ret
  
  i buom="" s msg="基本单位"_"为空" s ret=-20 q ret
  s buom=..validUom(buom)
  i buom="" s msg="基本单位"_"为空" s ret=-21 q ret
  ;
  s puom=$p(rowStr,del,..Col("puom"))		;整包装单位
  i puom="" s msg="整包装单位"_"为空" s ret=-22 q ret
  s puom=..validUom(puom)
  i puom="" s msg="整包装单位"_"为空" s ret=-23 q ret
  ;
  s factor=$p(rowStr,del,..Col("factor"))	;换算系数
  s ctcf=..validConFac(puom,buom,factor)
  i ctcf="" s msg="入库单位和基本单位无对应换算" s ret=-24 q ret
  ;  
  s catgrp=$p(rowStr,del,..Col("catgrp"))	;类组(大类)
  i catgrp="" s msg="类组"_"为空" s ret=-25 q ret
  s scg=..validScg(catgrp)
  i scg=""   s msg="无法取得类组" s ret=-26 q ret
  
  s stkcat=$p(rowStr,del,..Col("stkcat"))	;库存分类(子类)
  i stkcat="" s msg="分类"_"为空" s ret=-27 q ret
  s sc=..validStkCat(stkcat)
  i sc=""   s msg="无法取得分类"  s ret=-28 q ret
  ;类组和分类建立关联
  s rela=..validStkGrpRelation(scg,sc)
  i rela="" s msg="类组和分类无法建立关联" s ret=-29 q ret
  
  ;s stktkcat=stkcat						;盘点分类
  s vendor=$p(rowStr,del,..Col("vendor"))	;供应商
  s v=..validVendor(vendor)
  
  i v'="" d 
  . //   **    供应商其他信息 Start  **
  .s businesslicense=..getVal(rowStr,"businesslicense")  ;营业执照号
  .s businesscertificate=..getVal(rowStr,"businesscertificate") ;经营许可证号
  .s businesscertificateExpDate=..getVal(rowStr,"businesscertificateexpdate") ;经营许可证效期
  .s contactperson=..getVal(rowStr,"contactperson")   ;联系人
  .s authorizationdate=..getVal(rowStr,"authorizationdate")  ;授权到期
  .s contacttel=..getVal(rowStr,"contacttel")    ;电话
  .
  .s info=businesslicense
  .s info=info_"^"_businesscertificate
  .s info=info_"^"_businesscertificateExpDate
  .s info=info_"^"_contactperson
  .s info=info_"^"_authorizationdate
  .s info=info_"^"_contacttel
  .
  .s ret=..updVendorInfo(v,info) 
  . //   **    供应商其他信息 End  **
  . 
  q:ret<0 ret
  
  ;生产厂家
  s manf=$p(rowStr,del,..Col("manf"))  
  s m=..validManf(manf)  
  i m<0 s msg="生产厂家插入错误"  s ret=-400 q ret
  ;
  i m>0 d
  .s productionlicense=..getVal(rowStr,"productionlicense")  ;生产许可证号
  .s productionlicenseexpdate=..getVal(rowStr,"productionlicenseexpdate")  ;生产许可证效期
  .s info=productionlicense 
  .s info=info_"^"_productionlicenseexpdate
  .s ret=..updManfInfo(m,info)  //生产厂家附加信息
  . 
  q:ret<0 ret
  ;
  s rp=$p(rowStr,del,..Col("rp"))				;进价(整包装单位)
  s sp=$p(rowStr,del,..Col("sp"))				;售价(整包装单位)
  s rp=+rp
  s sp=+sp
  s priceinformation=$p(rowStr,del,..Col("priceinformation"))  //价格信息
  s barcode=$p(rowStr,del,..Col("barcode"))		;条码
  s charge= $p(rowStr,del,..Col("charge"))		;收费标志
  s ybcode= $p(rowStr,del,..Col("ybcode"))		;医保编码
  ;s remarks=$p(rowStr,del,..Col("remarks"))		;备注
  ;s remarksList=$lfs(remarks,$c(13,10))
  s batReq=..getVal(rowStr,"batrequired")		;批号要求
  s:batReq="Y" batReq="R"
  s expReq=..getVal(rowStr,"expdaterequired")	;效期要求
  s:expReq="Y" expReq="R"
  //自动生成代码
  ;i code="" s code=..createCode(scg,sc)
  i code="" s code=##class(web.DHCSTMHUI.DrugInfoMaintain).NewCode(sc)
  i code="" s msg="自动生成代码错误" s ret=-5 q ret
  
  s notuse="N"
  s d=+$h			//日期
  s t=$p($h,",",2)	//时间
  s user=..User()
  
  s xiehe=$p(rowStr,del,..Col("xiehe"))
  &sql(Insert into INC_Itm(INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,INCI_CTUOM_Purch_DR,
		INCI_NotUseFlag,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
		inci_reportingdays,inci_remarks,INCI_BatchReq,INCI_ExpReq
    ) values (:code,:desc,:buom,:sc,:puom,
			:notuse,:d,:t,:user,:barcode,
			:ybcode,:remarksList,:batReq,:expReq
	)
  )
  
  i SQLCODE'=0 d 
  .s msg="插入主表错误:"_SQLCODE
  .s ret=-1
  e  d
  .s inci=$g(%ROWID)
  q:ret<0 ret
  
  ;更新协和码
  i inci>0  d
  .&sql(update inc_itm set inci_reportingdays=:xiehe where inci_rowid=:inci)
  .i SQLCODE'=0 s ret=-111,msg="更新协和码失败:"_SQLCODE
  q:ret<0 ret
  
  s hv=$p(rowStr,del,..Col("highvalue"))					//高值标志 : "Y"或者"N"
  s carrier=..validCarrier($p(rowStr,del,..Col("carrier")))	//配送商
  s abbr=$p(rowStr,del,..Col("abbr"))						//简称

  &sql(Insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_Spec,INFO_Model,INFO_Brand,INFO_HighPrice,
  INFO_MaxSp,INFO_PbRp,INFO_PbVendor_DR,
    INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_ChargeFlag,INFO_AbbRev)
    values (:inci,:spec,:model,:brand,:hv,:sp,:rp,:v,:m,:carrier,:charge,:abbr) )
  ;b
  i SQLCODE'=0 d
  .s msg="插入附加表错误:"_SQLCODE
  .s ret=-2
  .
  q:ret<0 ret
  ;
  s err=..createAlias(inci,alias)  //生成别名
  i err<0 d
  .s msg="插入别名错误"
  .s ret=-10
  .
  q:ret<0 ret
  ;
  s err=..createAsp(inci,..User(),rp,sp,..Hosp(""),priceinformation,AdjSpNo)  //生成调价表记录
  i err<0 d
  .s msg="生成价格数据错误"
  .s ret=-11
  q:ret<0 ret
  
  i inci'="",m'="" d
  .s registerno="",registerexpdate=""
  .s c=..Col("registerno")				//器械注册证
  .i c>0 d
  ..s registerno=$p(rowStr,del,c) 
  .s c=..Col("registerexpdate")			//器械注册证效期
  .i c>0 d
  ..s registerexpdate=$p(rowStr,del,c) 
  .
  .s ret=..validIR(inci,m,registerno,registerexpdate)
  .
  q:ret<0 ret
  
  i inci'="",v'="" d
  .s ret=..validIV(inci,v,m,carrier,rp,sp)
  q:ret<0 ret
  
  ;关联库存项跟医嘱项
  &sql(UPDATE INC_Itm SET INCI_OriginalARCIM_DR=:arcid WHERE INCI_RowId=:inci)
  i SQLCODE'=0 d
  .s ret=-31
  .s msg=arccode_"关联"_code_"库存项失败"
  q:ret<0 ret
  
  q ret
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
ClassMethod validScg(catgrp As %String) As %String
{
 n (catgrp)
 s type=..sssCode(),prefix=..prefix()
 s rowid=""
 &sql(select scg_rowid into :scg from dhc_stkcatgroup where scg_desc=:catgrp and scg_type=:type)
 i SQLCODE d
 .s code=..getScgCode(prefix)
 .&sql(insert into  dhc_stkcatgroup(scg_code,scg_desc,scg_type) values (:code,:catgrp,:type))
 .i SQLCODE'=0 q 
 .s rowid=$p($g(%ROWID),$c(1))
 e  d
 .s rowid=+scg
 q rowid
}

/// 验证分类
ClassMethod validStkCat(stkcat As %String) As %String
{
 n (stkcat)
 s type=..sssCode(),prefix=..prefix()
 s rowid=""
 &sql(select incsc_rowid into :sc from inc_stkcat where incsc_desc=:stkcat)
 i SQLCODE d
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
ClassMethod validVendor(vendor As %String) As %String
{
 n (vendor)
 q:vendor="" ""
 s type=..sssCode()
 s rowid=""
 &sql(select apcvm_rowid into :v from apc_vendor where apcvm_name=:vendor)
 i SQLCODE d
 .
 .&sql(insert into APC_Vendor(apcvm_code,apcvm_name,apcvm_type) values (:vendor,:vendor,:type))
 .;b
 .i SQLCODE'=0 q 
 .s rowid=$G(%ROWID)
 .
 .i rowid'="" d
 ..&sql(insert into dhc_stvendor (STV_Vendor_DR) values (:rowid))
 .
 e  d
 .s rowid=+v
 
 q rowid
}

/// 验证生产厂家
/// return:
///   >0 - ok 
///   <0 - 失败
///   "" - ""
ClassMethod validManf(manf As %String) As %String
{
 n (manf)
 q:manf="" ""
 s type=..sssCode()
 s rowid=""

 s ret=0
 &sql(select phmnf_rowid into :m from ph_manufacturer where phmnf_name=:manf)
 i SQLCODE d
 .&sql(insert into  ph_manufacturer(phmnf_code,phmnf_name) values (:manf,:manf))
 .i SQLCODE'=0 s ret=-1  q 
 .s rowid=+$G(%ROWID)
 e  d
 .s rowid=+m
 .
 q:ret<0 ret
 q:rowid<1 -1
 &sql(select manf_rowid into :ma from  dhc_manf_addioninfo where manf_phcmanf_dr=:rowid)
 i SQLCODE d
 .s active="Y"   //激活状态缺省为"Y"
 .&sql(insert into dhc_manf_addioninfo (manf_phcmanf_dr,manf_type,manf_active) values (:rowid,:type,:active))
 .i SQLCODE'=0 s ret=-2  q 
 
 q:ret<0 ret
 ;tcommit
 q rowid
}

/// 验证配送商
ClassMethod validCarrier(carrier As %String) As %String
{
 n (carrier)
  q:carrier="" ""
  s ca=""
  &sql(select ca_rowid into :ca from dhc_carrier where ca_desc=:carrier)     
  i SQLCODE d
  . s type=..sssCode()
  . &sql(insert into dhc_carrier(ca_code,ca_desc,ca_type) values (:carrier,:carrier,:type))
  . i SQLCODE'=0 s ret=-121 q 
  . s ca=$g(%ROWID)
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

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：  HANZI:汉字
///             FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
///             SPLIT:分割符(可以为空)
/// Output：
///     非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
///     0：未找到编码信息
/// CreatDate:2011-06-08
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
    s Rtnstr="0"
    q:$g(HANZIS)="" Rtnstr
    s Rtnstr=""
    f i=1:1:$l(HANZIS) d
    .s HANZI=$EXTRACT(HANZIS,i)
    .s ASCIICODE=$ASCII(HANZI)
    .i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
    ..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
    ..s tmpstr=""
    ..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
    ..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
    ..i Rtnstr=""  d
    ...s Rtnstr=tmpstr
    ..e  d
    ...s Rtnstr=Rtnstr_SPLIT_tmpstr
    .e  d
    ..s:Rtnstr="" Rtnstr="?"
    ..s Rtnstr=Rtnstr_SPLIT_"?"
    q Rtnstr
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
 s ret=0
 &sql(select inci_code,inci_desc,INCI_ReportingDays into :code,:desc,:xiehe from inc_itm where inci_rowid=:inci)
 ;
 s py=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(desc,4,"")  ;别名一:描述的拼音首字符
 s py=$$ALPHAUP^SSUTIL4(py)
 &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)
   values (:py,:code,:desc,:inci)  )
   //b
 i SQLCODE'=0 q -1
 ;
  ;别名二:代码
 &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
   values (:code,:code,:desc,:inci)  )
   //b
 i SQLCODE'=0 q -2
 ; 
  ;别名三:五笔码
  s five=##class(web.DHCSTMHUI.Tools.CommonInput).GetCNCODE(desc,6,"")
  s five=$e(five,1,30) // 取前30个字符  
  &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr)   
   values (:five,:code,:desc,:inci)  )
   i SQLCODE'=0 q -3

  ;别名四:协和码
  i $g(xiehe)'="" d
  . &sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:xiehe,:code,:desc,:inci)  )
  . i SQLCODE'=0 s ret= -4
  q:ret<0 ret
 ;
 i alias'="" d
 .&sql(insert into inc_alias (inca_text,inca_code,inca_desc,inca_inci_dr) values (:alias,:code,:desc,:inci)  )
 .i SQLCODE'=0 s ret=-5
  ;
 q ret
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
  
  s AdjDate=+$h
  s PreExecuteDate=AdjDate
  s ExecuteDate=AdjDate
   s ItmRowid=inci
   
   s ret=0
   &sql(select inci_incsc_dr,inci_ctuom_dr,inci_ctuom_purch_dr into :StkCatId,:uom,:puom from inc_itm where inci_rowid=:inci)
   i SQLCODE s ret= -1
   q:ret<0 ret
   
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
  i SQLCODE'=0  s ret=-2
  q ret
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
  ;&sql(select ir_rowid into :ir from dhc_itmremark where ir_inci_dr=:inci and ir_phmanf_dr=:m ) 
  &sql(select ir_rowid into :ir from dhc_itmremark where ir_inci_dr=:inci  ) 
  i SQLCODE d
  .&sql(insert into dhc_itmremark(ir_inci_dr) values (:inci) )
  .i SQLCODE'=0 d
  ..s msg="插入dhc_itmremark错误:"_SQLCODE
  ..s ret=-12
  .q:ret<0
  .s ir=$p($g(%ROWID),$c(1))
  q:ret<0 ret
  
  
  i ir'="" d
  .;&sql(update dhc_itmremark set ir_newtext=:registerno where ir_rowid=:ir  )  
  .&sql(update dhc_itmremark set ir_phmanf_dr=:m,ir_regcertno=:registerno where ir_rowid=:ir  ) 
  .i SQLCODE'=0 d
  ..s msg="更新器械注册证号错误:"_SQLCODE
  ..s ret=-110
  q:ret<0 ret
  ;
  i ir'="" d  
  .s registerexpdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(registerexpdate)
  .;&sql(update dhc_itmremark set ir_textexpdate=:registerexpdate where ir_rowid=:ir  )  
  .&sql(update dhc_itmremark set ir_regcertexpdate=:registerexpdate where ir_rowid=:ir  )  
  .i SQLCODE'=0 d
  ..s msg="更新器械注册证效期错误:"_SQLCODE
  ..s ret=-111
  q:ret<0 ret
  ;
  
  q ret
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
    n (colname)
    s cols=..cols()
   //s cols=..colsBJXH()  ;;北京协和
   //s cols=..colsSHGL()  ;;上海公利
    s cnt=$l(cols,"^")
    s ret=0
    f i=1:1:cnt q:ret>0  d
    .i $p(cols,"^",i)=colname s ret=i q
    q ret
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

/// 缺省的文件标题名称字符串("^"分隔)
ClassMethod cols() As %String
{
  s cols="catgrp^stkcat^code^desc^spec^brand^abbr^alias^buom^puom^factor^sp^rp^charge^highvalue^batrequired^expdaterequired^vendor^manf^registerno^registerexpdate^businesslicense^businesscertificate^businesscertificateexpdate^productionlicense^productionlicenseexpdate^authorizationdate^contactperson^contacttel^remarks^xiehe"
  
  q cols
}

/// 北京协和
ClassMethod colsBJXH() As %String
{
    s cols="code^desc^alias^brand^spec^model^buom^puom^factor^rp^sp^catgrp^stkcat^stktkgrp^batrequired^expdaterequired^vendor^manf^packphotoname^barcode"
    q cols
}

/// 上海公利    
ClassMethod colsSHGL() As %String
{
  
  s cols="code^ybcode^catgrp^stkcat^stktkgrp^charge^desc^alias^spec^brand^buom^puom^factor^rp^sp^batrequired^expdaterequired^vendorx^vendor^manf^registerno^registerexpdate^businesslicense^businesscertificate^productionlicense^authorizationdate^contactperson^contacttel^priceinformation^useloc^stklevel^remarks"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
   q cols
}

ClassMethod ErrId() As %String
{
 s NowDate=$zd(+$h,3)
 s i=$o(^TMP("input_incitm",NowDate,""),-1)+1
 q i
}

ClassMethod SetErr(row As %String, errinfo As %String)
{
	n (row,errinfo)
	s NowDate=$zd(+$h,3),NowTime=..TL2H($p($h,",",2))
	s ^TMP("input_incitm",NowDate,..ErrId(),NowTime)="第"_row_"行错误:"_errinfo
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
    .//b
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
/// w ##class(wweb.DHCSTMHUI.Tools.HandleMatInfo).updVendorInfo()
ClassMethod updVendorInfo(v As %String, info As %String) As %String
{
  n (v,info)
  s ret=0	
  
  s businesslicense=$P(info,"^",1)   //营业执照(工商执照)
  s businesscertificate=$P(info,"^",2) //经营许可
  s businesscertificateExpDate=$P(info,"^",3)  //经营许可证效期
  s contactperson=$P(info,"^",4)   //业务联系人
  s authorizationdate=$P(info,"^",5) //业务授权截止期
  s contacttel=$P(info,"^",6) //业务联系人电话
  s businesslicensedate=$P(info,"^",7)			//供应商营业执照有效期
  s revreg=$P(info,"^",8)						//供应商税务登记证号
  s orgcode=$P(info,"^",9)						//供应商组织机构代码
  s orgcodedate=$P(info,"^",10)					//供应商组织机构代码有效期
  &sql(update dhc_stvendor set stv_comlic=:businesslicense where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="营业执照(工商执照)更新错误:"_SQLCODE
  .s ret=-300
  q:ret<0 ret	

  &sql(update dhc_stvendor set stv_matmanlic=:businesscertificate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="经营许可证更新错误:"_SQLCODE
  .s ret=-301
  q:ret<0 ret	

  s businesscertificateExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(businesscertificateExpDate)
  i +businesscertificateExpDate<0 d
  .s msg="经营许可证效期格式错误!"
  .s ret=-309
  q:ret<0 ret
  &sql(update dhc_stvendor set STV_MatManLicDate=:businesscertificateExpDate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="经营许可证效期更新错误:"_SQLCODE
  .s ret=-3011
  q:ret<0 ret	
  
  &sql(update dhc_stvendor set stv_salesname=:contactperson where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="业务联系人更新错误:"_SQLCODE
  .s ret=-302
  q:ret<0 ret	
  
  s authorizationdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(authorizationdate)
  i +authorizationdate<0 d
  .s msg="业务授权截止期格式错误!"
  .s ret=-310
  q:ret<0 ret
  &sql(update dhc_stvendor set stv_salesdate=:authorizationdate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="业务授权截止期更新错误:"_SQLCODE
  .s ret=-303
  q:ret<0 ret	
  
  &sql(update dhc_stvendor set stv_salestel=:contacttel where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="业务联系人电话更新错误:"_SQLCODE
  .s ret=-304
  q:ret<0 ret	
  
  s businesslicensedate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(businesslicensedate)
  i +businesslicensedate<0 d
  .s msg="营业执照(工商执照)有效期格式错误!"
  .s ret=-311
  q:ret<0 ret
  &sql(update dhc_stvendor set STV_ComLicDate=:businesslicensedate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="营业执照(工商执照)有效期更新错误:"_SQLCODE
  .s ret=-305
  q:ret<0 ret
  
  &sql(update dhc_stvendor set STV_RevReg=:revreg where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="供应商税务登记号更新错误:"_SQLCODE
  .s ret=-312
  q:ret<0 ret
  
  &sql(update dhc_stvendor set STV_OrgCode=:orgcode where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="供应商组织机构代码更新错误:"_SQLCODE
  .s ret=-307
  q:ret<0 ret
  
  s orgcodedate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(orgcodedate)
  i +orgcodedate<0 d
  .s msg="供应商组织机构代码有效期格式错误!"
  .s ret=-313
  q:ret<0 ret
  &sql(update dhc_stvendor set STV_OrgCodeDate=:orgcodedate where stv_vendor_dr=:v )
  i SQLCODE'=0 d
  .s msg="供应商组织机构代码有效期更新错误:"_SQLCODE
  .s ret=-308
  q:ret<0 ret
  	
  q ret
}

/// 更新厂家信息	
/// w ##class(web.DHCSTMHUI.Tools.HandleMatInfo)updManfInfo()
ClassMethod updManfInfo(m As %String, info As %String) As %String
{
  n (m,info)

  s ret=0	
  s productionlicense=$P(info,"^",1)
  s productionlicenseexpdate=$P(info,"^",2)
	
  &sql(update dhc_manf_addioninfo set manf_matproduct_permit=:productionlicense where manf_phcmanf_dr=:m  ) 
  i SQLCODE'=0 d
  .s msg="生产许可证更新错误"_"^"_productionlicense_"^"_m_"^"_SQLCODE
  .s ret=-401
  .
  q:ret<0 ret
  
  s productionlicenseexpdate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(productionlicenseexpdate)
  i +productionlicenseexpdate<0 d
  .s msg="生产许可证效期格式错误!"
  .s ret=-21
  q:ret<0 ret
  &sql(update dhc_manf_addioninfo set manf_matproduct_expdate=:productionlicenseexpdate where manf_phcmanf_dr=:m  ) 
  i SQLCODE'=0 d
  .s msg="生产许可证效期更新错误"_"^"_productionlicenseexpdate_"^"_m_"^"_SQLCODE
  .s ret=-4011
  .
  q:ret<0 ret
  q ret
}

/// 取出行串中某列所在位置的值	
ClassMethod getVal(rowStr As %String, colName As %String) As %String
{
	n (rowStr,colName)
	s tmp=""
	s c=..Col(colName)
	i c>0 d
	.s tmp=$p(rowStr,"^",c)
	q tmp
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

/// /根据医嘱代码判断是否存在2017040407
ClassMethod IFArimByCode(arccode As %String) As %String
{
	n (arccode)
	s arimid=""
	&SQL(SELECT %ID INTO:ID FROM ARC_ItmMast WHERE ARCIM_Code=:arccode)
	I SQLCODE=0 d  
	.s arimid=ID
	q arimid
}

/// 根据名称判断医嘱项存在与否 
ClassMethod IFArim(OrdDesc As %String) As %String
{
	n (OrdDesc)
	s arimid=""
	&SQL(SELECT %ID INTO:ID FROM ARC_ItmMast WHERE ARCIM_Desc=:OrdDesc)
	I SQLCODE=0 d  
	.s arimid=ID
	q arimid
}

/// 根据医嘱项判断是否有对应库存项
ClassMethod IFInci(arimid As %String) As %String
{
	n (arimid)
	s inci=""
	&SQL(SELECT %ID INTO:ID FROM Inc_itm WHERE INCI_OriginalARCIM_DR=:arimid)
	i SQLCODE=0 d 
	.s inci=ID
	q inci
}

/// 根据库存项项判断是否有对应附加表
ClassMethod IFIncinfo(inci As %String) As %String
{
	n (inci)
	s incinfo=""
	&SQL(SELECT %ID INTO:ID FROM DHC_ItmAddionInfo WHERE INFO_INCI_DR=:inci)
	i SQLCODE=0 d 
	.s incinfo=ID
	q incinfo
}

/// 插入inc_itm
ClassMethod InsertInc(code, desc, buom, sc, puom, notuse, d, t, user, barcode, ybcode, remarksList, batReq, expReq) As %String
{
	s inci=""
	&sql(Insert into INC_Itm(INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,INCI_CTUOM_Purch_DR,
			INCI_NotUseFlag,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
			inci_reportingdays,inci_remarks,INCI_BatchReq,INCI_ExpReq) 
		values(:code,:desc,:buom,:sc,:puom,
			:notuse,:d,:t,:user,:barcode,
			:ybcode,:remarksList,:batReq,:expReq))
    i SQLCODE=0 d  
    .s inci=%ROWID
    q inci
}

/// 插入库存项附加表
ClassMethod InsertIncInfo(inci, spec, model, brand, hv, sp, rp, v, m, carrier, charge, abbr)
{
	s incinfo=""
	&sql(Insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_Spec,INFO_Model,INFO_Brand,INFO_HighPrice,
        INFO_MaxSp,INFO_PbRp,INFO_PbVendor_DR,INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_ChargeFlag,INFO_AbbRev)
         values (:inci,:spec,:model,:brand,:hv,:sp,:rp,:v,:m,:carrier,:charge,:abbr) )
    i SQLCODE=0 d  
    .s incinfo=%ROWID
    q incinfo
}

/// /判断医嘱是否作废
/// w ##class(web.DHCSTMHUI.Tools.HandleMatInfo).IFNotUse("A00N001")
ClassMethod IFArcimNotUse(arccode As %String) As %String
{
	n (arccode)
	s EffDateTo="",ret=0,OrderOnItsOwn=""
	&SQL(SELECT ARCIM_EffDateTo,ARCIM_OrderOnItsOwn into:EffDateTo,:OrderOnItsOwn FROM ARC_ItmMast WHERE ARCIM_Code=:arccode)
	s tdate=$p($h,",",1)
	i (((+EffDateTo>0)&&(+EffDateTo'>tdate))||(OrderOnItsOwn'="Y")) d 
	.s ret=-1
	q ret
}

/// Descript:	过滤非物资医嘱信息
/// Creater:lihui
/// CreateDate:	2017-04-13
/// Input:医嘱id
/// Return:1:物资;0:非物资
ClassMethod IsMaterialArc(arcid As %String) As %Library.String
{
	n (arcid)
	q:arcid="" 0
	&sql(SELECT ARCIM_ItemCat_DR->ARCIC_OrderType into :OrdType 
    FROM ARC_ItmMast WHERE ARCIM_RowId=:arcid)
    q:$G(OrdType)="M" 1
    q 0
}

/// Descript:	导出没有库存项的医嘱项信息(根据医嘱子类类型为M的判断是否材料医嘱)
/// Table:	ARC_ItmMast,OEC_OrderCategory,ARC_ItemCat
/// Input:  医嘱大类id串
/// Return: 医嘱id^医嘱代码^医嘱名称^账单单位id^账单单位^(收费项)售价(只供参考)
/// d ##class(web.DHCSTMHUI.Tools.HandleMatInfo).ExportArcInfoToExcel(10)
ClassMethod ExportArcInfoToExcel(OrderCateidStr As %String) As %Library.String
{
	n (OrderCateidStr)
	q:OrderCateidStr="" ""
	s File="E:\有医嘱项无库存项数据.xls"
	o File:"WNS"
	u File
	w "医嘱id	医嘱代码	医嘱名称	账单单位id	账单单位	(收费项)售价",!
	
	s del="^"
	s len=$l(OrderCateidStr,del)
    f i=1:1:len  d
	.s OrderCateid=$p(OrderCateidStr,del,i)
	.s arccatdr=""
	.f  s arccatdr=$o(^ARC("IC",0,"OrdCat",OrderCateid,arccatdr)) q:arccatdr=""  d
	..s Subscript=""
	..f  s Subscript=$o(^ARCIM(0,"ARCIC_DR",arccatdr,Subscript))  q:Subscript=""  d
	...s Version=""
	...f  s Version=$o(^ARCIM(0,"ARCIC_DR",arccatdr,Subscript,Version)) q:Version=""  d
	....s Arcid=Subscript_"||"_Version
	....s ifmat=..IsMaterialArc(Arcid)            ;过滤非耗材医嘱
	....q:ifmat'=1
	....s iflinkinci=..IFInci(Arcid)        ;判断是否已经关联过库存项
	....q:iflinkinci'=""
	....s ArcCode=$p(^ARCIM(Subscript,Version,1),"^",1) ;医嘱代码
	....s ArcDesc=$p(^ARCIM(Subscript,Version,1),"^",2) ;医嘱名称
	....s BillUomid=$p(^ARCIM(Subscript,Version,8),"^",14) 
	....s:BillUomid'="" BillUom=$p(^CT("UOM",BillUomid),"^",2) ;账单单位
	....s Sp=##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).GetTarPrice(Arcid)  ;(收费项)售价
	....w Arcid_"	"_ArcCode_"	"_ArcDesc_"	"_BillUomid_"	"_BillUom_"	"_Sp,!
	c File	
		
	q ""
}

}
