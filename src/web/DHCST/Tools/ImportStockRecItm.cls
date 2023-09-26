Import sqluser

/// description:库存信息导入生成待审核入库单(2015-07-10)
/// columns:代码^名称^科室名称^数量^单位^进价^批号^效期(YYYY-MM-DD)^厂商描述(厂商必须是系统内的描述)^售价^货位(多个货位以"\"分隔)^医院名称
/// others:文件需为制表符的txt格式
/// windows路径:w ##class(web.DHCST.Tools.ImportStockRecItm).StartInput("D:\importstock.txt","")
/// 小机路径:w ##class(web.DHCST.Tools.ImportStockRecItm).StartInput("/tmp/stockrec.txt","")
/// 进价按入库进价,售价按统一价时:售价列设为空,取系统售价(前提系统价格已经核对完毕)
/// 进售价均按统一进价时:售价列设为空,取系统售价(前提系统价格已经核对完毕)
/// 批次价:进售价必须有值,且为核对无误的信息
Class web.DHCST.Tools.ImportStockRecItm Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符
ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="StockRec"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ingdrec=""
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s cnt=cnt+1
  .tstart
  .s msg=""
  .i Ingdrec="" d
  ..s Ingdrec=..CreateDHCINGR(rowStr,.msg)
  .i Ingdrec>0 w "入库单RowID:"_Ingdrec,!
  .e  d
  ..w Ingdrec,!
  ..q
  .s ret1=..InputIncItm(rowStr,.msg,Ingdrec)
  .w "第"_cnt_"条记录,"_msg,!
  .i ret1=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  .. tro
  .. //d ..SetErr(i,msg)
  w "入库明细总记录数:"_cnt_",成功记录数:"_successCnt_", 入库单号:"_$p($g(^DHCINGR(Ingdrec)),"^", 1),!
  /* 货位在货位码维护界面直接导入
  w "开始插入货位",!
  s successCnt=0,cnt=0
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s inciCode=$p(rowStr,del,..Col("Code")) 
  .s inciDesc=$p(rowStr,del,..Col("Desc")) 
  .s locDesc=$p(rowStr,del,..Col("LocDesc")) 
  .s stkBin=$p(rowStr,del,..Col("StkBin")) 
  .q:stkBin=""
  .s stkBinData=inciCode_"^"_inciDesc_"^"_""_"^"_locDesc
  .s skiBinI=0
  .s stkBinLen=$l(stkBin,"\")
  .f skiBinI=1:1:stkBinLen d
  ..s stkBinICode=$p(stkBin,"\",skiBinI)
  ..q:stkBinICode=""
  ..s $p(stkBinData,"^",3)=stkBinICode
  ..s ret=##class(web.DHCST.Tools.InputStkBin).InsertStkBin(stkBinData,2)
  ..i ret=0 s successCnt=successCnt+1
  ..s cnt=cnt+1
  w "货位总记录数:"_cnt_",成功记录数:"_successCnt,!
  */
  k ^zTSA(p,sub)  //删除临时global
  q ""
}

/// 处理一行数据
ClassMethod InputIncItm(rowStr As %String, msg As %String, Ingdrec As %String) As %String
{
  n (rowStr,msg,Ingdrec)

  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  //s rowStr=$tr(rowStr," ","") //药品名称中可能有空格，不能去掉
  s ret=0
  s del="^"
  ///插入子表信息
  s Code=$p(rowStr,del,..Col("Code") ) ;物资代码 
  s Desc=$p(rowStr,del,..Col("Desc") ) ;物资名称
  s Qty=$p(rowStr,del,..Col("Qty") )   ;数量
  i Qty'>0 d
  .s ret=-12  
  .s msg="数量为空"
  q:ret<0 ret
  s Uom=$p(rowStr,del,..Col("Uom") )   ;入库单位
  s Rp=$p(rowStr,del,..Col("Rp") )      ;进价
  s BatchNo=$p(rowStr,del,..Col("BatchNo") ) ;批号
  s ExpDate=$p(rowStr,del,..Col("ExpDate") ) ;效期
  i ExpDate'="" s ExpDate=..vDate(ExpDate)  ;
  s Phmanf=$p(rowStr,del,..Col("Phmanf") ) ;厂商
  s Sp=$p(rowStr,del,..Col("Sp")) //售价
  s LocId=""
  s LocDesc=$p(rowStr,del,..Col("LocDesc") ) ;科室名称
  i LocDesc="" 
  .s ret=-1 ;科室名称为空
  .s msg = "科室名称为空"
  q:ret<0 ret
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
  i +LocId>0 d
  .s ret=0
  e  d
  .s ret=-2  ;此科室在系统中不存在
  .s msg = "此科室在系统中不存在:"_LocDesc_ "("  _ Desc _ ")"
  q:ret<0 ret
  s hosp=$p(^CTLOC(LocId),"^",22)
  s IncId=##class(PHA.IN.COM.Method).GetInciByCode(Code,hosp)
  i IncId="" d
  .s ret=-7 ;此代码无效
  .s msg = "此代码在系统中不存在:"_Code _ "("  _ Desc _ ")"
  q:ret<0 ret
  s inciDesc = $p(^INCI(IncId, 1), "^", 2)
  i (inciDesc '= Desc) d
  .s ret=-8 ;此代码无效
  .s msg = "药品代码和名称不匹配:" _ Code _ "("  _ Desc _ ")"
  q:ret<0 ret
  s Chl=1+$o(^DHCINGR(Ingdrec,"GRI",""),-1)
  s UomId=""
  i Uom'="" d
  . &SQL(SELECT ctuom_rowid into :UomId FROM CT_UOM WHERE CTUOM_Desc=:Uom)
  e  d
  . s UomId=$p(^INCI(IncId,3),"^",6)
  i UomId="" s UomId=$p(^INCI(IncId,3),"^",6)  
  i +UomId=0 d
  .s ret=-9  ;单位不存在
  .s msg = "药品单位未维护" _ "("  _ Desc _ ")"
  q:ret<0 ret  
  s BUomId=$p(^INCI(IncId,1),"^",10)
  s PUomId=$p(^INCI(IncId,3),"^",6)
  s confac = ##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
  i UomId'=BUomId,UomId'=PUomId  d
  .s msg="单位:" _ Uom _ "不是基本/入库单位" _ "("  _ Desc _ ")"
  .s ret=-11  ;单位不存在
  q:ret<0 ret  
  i Qty*confac["." d
  .s ret=-13  
  .s msg="数量转化为基本单位包含小数"  _ "("  _ Desc _ ")"
  q:ret<0 ret    
  i Rp="" d  
  .s Rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(IncId,+$h,UomId,hosp)  ;获取物资当前售价，lihui
  s Margin=""
  s InvAmt=""
  s InvNo=""
  s ManfId=""
  i Phmanf'="" d
  .s ManfId=##class(PHA.IN.COM.Method).GetManfByName(Phmanf,hosp)
  //厂商为空
  i ManfId="" d
  .s ManfId=##class(web.DHCST.Common.DrugInfoCommon).GetManf(IncId) //厂家为空取三大项厂家
  .s ManfId=$p(ManfId,"^",1)
  s RpAmt=Rp*Qty
  i Sp="" d
  .s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,hosp)  ;格式化后的售价
  s InvDate=""
  s SxNo=""
  s SpAmt=Sp*Qty
  s NewSp=Sp
  s NewSpAmt=SpAmt
  s PoItmId=""
  s Remark=""
  s QualityNo=""
  &sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
    INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
    initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
    initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,INGRI_Remarks,initm_QualityNo)
    VALUES(:Ingdrec, :Chl, :BatchNo, :LocId,:UomId,:ExpDate,:Margin,:Qty,:Desc,
    :IncId,:InvAmt,:InvNo,:ManfId,:Rp,:RpAmt,:Sp,:InvDate,:Rp,:SxNo,:NewSp,:NewSpAmt,:SpAmt,:PoItmId,:Remark,:Remarks,:QualityNo))
   i SQLCODE'=0  d
   .s ret=-8  ;插入子表失败
   .s msg="保存明细失败," _ $tr($g(%msg),"^","~") _ "("  _ Desc _ ")"
   q:ret<0 ret 
  q ret
}

/// 生成入库主表
ClassMethod CreateDHCINGR(rowStr As %String, msg As %String) As %String
{
  n (rowStr,msg)
  s colNoStr=""
  s rowStr=$tr(rowStr,$c(13,10))
  s rowStr=$tr(rowStr," ","")
  s ret=0
  s del="^"
  ///生成入库主表
  s LocId=""
  s LocDesc=$p(rowStr,del,..Col("LocDesc") ) ;科室名称
  i LocDesc="" s ret="科室名称为空"
  q:ret'=0 ret
  s LocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
  i +LocId>0 d
  .s ret=0
  e  d
  .s ret="此科室在系统中不存在"
  q:ret'=0 ret
  s HospDesc = $p(rowStr,del,..Col("HospDesc") ) ;医院名称
  i (HospDesc = "") s ret="医院名称为空"
  q:ret'=0 ret
  &SQL(SELECT HOSP_RowId INTO :HospId FROM CT_Hospital WHERE HOSP_Desc = :HospDesc)
  i +$g(HospId)>0 d
  .s ret=0
  e  d
  .s ret="此医院在系统中不存在"
  s locHospId = $p(^CTLOC(LocId), "^", 22)
  q:(locHospId '= HospId) "科室和医院不匹配"
  
  q:ret'=0 ret
  s VendorId=""
  s VendorId=..GetDefaultVendor(HospId) ;获取初始化供应商
  i +VendorId<=0 d
  .s ret="没有取到供应商id"
  
  q:ret'=0 ret
  s UserId=""
  s UserName="demo"
  &sql(select ssusr_rowid into :UserID from ss_user where ssusr_initials=:UserName)
  s UserId=$g(UserID)
  i +UserId=0 d
  .s ret="没有取到userid"
  q:ret'=0 ret
  s AppName=##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
  s IngrNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",LocId)
  q:IngrNo="" "生成单号失败"  
  s Complete="Y"
  s ExchangeFlag="N"
  s PresentFlag="N"
  s IngrTypeId=""
  s StkType=..sssCode()
  s PurUserId=""
  s StkGrpId=""
  s AuditFlag="N"
  s PoId=""
  s h=+$h
  s t=$p($h,",",2)
  &sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
         INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
         INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
         INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR) 
         values (:VendorId,:Complete,1,1,0,:IngrNo,:LocId,:UserId,:h,:t,
         :ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:StkGrpId,:AuditFlag,:StkType,:PoId))
   i SQLCODE'=0  d
   .s ret=-6   ;主表插入失败
   e  d
   .s Ingdrec=$g(%ROWID)
   q:ret<0 ret
    // 执行接口
    if ($d(^oddDEF("PHA.IN.REC.Face","m","HandleStatus"))){
        s statusRet = ##class(PHA.IN.REC.Face).HandleStatus(Ingdrec, "SAVE", UserId, "Save")
        if (+statusRet < 0) {
            s msg = statusRet
            q -66
        }
        s statusRet = ##class(PHA.IN.REC.Face).HandleStatus(Ingdrec, "COMP", UserId, "Save")
        if (+statusRet < 0) {
            s msg = statusRet
            q -67
        }
    }
   q Ingdrec
}

/// 取出列在串中的位置
ClassMethod Col(colname As %String) As %String
{
    n (colname)
    //此处为导入数据的排列顺序
    //"代码^名称^科室名称^数量^单位^进价^批号^效期(YYYY-MM-DD)^厂商描述(厂商必须是系统内的描述)^售价^货位"
    s cols="Code^Desc^LocDesc^Qty^Uom^Rp^BatchNo^ExpDate^Phmanf^Sp^HospDesc"
    s cnt=$l(cols,"^")
    s ret=0
    f i=1:1:cnt q:ret>0  d
    .i $p(cols,"^",i)=colname s ret=i q
    q ret
}

/// 日期处理函数
ClassMethod vDate(d As %String) As %String
{
 n (d)
 q:d="" ""
 i d["-" s d=$zdh(d,3) q d
 i d["/" s d=$zdh(d,4) q d
 i $l(d)=8 s d=$zdh(d,8) q d
 q ""
}

/// Descript:获取初始化供应商
/// Creater: zhangxiao
/// CreateDate: 2013-12-27
/// Table:apc_vendor
/// Input:
/// Output:     
/// Return：供应商id
/// w ##class(web.DHCST.Tools.ImportStockRecItm).GetDefaultVendor(2)
ClassMethod GetDefaultVendor(HospId)
{
    n (ven ,vendor, HospId)
    s ven=""
    s vendor="初始化药品供应商"
    
    //s ven=$O(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(vendor),""))
    s ven = ##Class(PHA.IN.Vendor.Save).GetIdByDesc(vendor, HospId)
    q:ven>0 ven
    s Type=..sssCode()
    s Status="A"
    ///没有初始化供应商则新建
    ;&sql(insert into apc_vendor (apcvm_code,apcvm_name,APCVM_Tel) values (:vendor,:vendor) )
    &sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Tel,APCVM_ContPerson,
    APCVM_Type,APCVM_CtrlAcct_DR,APCVM_CrLimit,APCVM_Category_DR,APCVM_CrAvail,
    APCVM_LstPoDate,APCVM_Fax,APCVM_President,APCVM_RcFlag,APCVM_ShName,APCVM_Status)
    values(:vendor,:vendor,:Tel,:ConPerson,:Type,:CtrlAcct,:CrLimit,:CategoryId,:CrAvail,
    :LstPoDate,:Fax,:President,:RCFlag,:Desc,:Status))
    i SQLCODE'=0 d
    . s ven=""
    . &sql(select max(apcvm_rowid) into :ven from apc_vendor)
    e  d
    .s ven=$g(%ROWID)
    
    s retinfo = ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("APC_Vendor", ven, HospId)
    i +retinfo<0 tro  q +retinfo
    
    q $g(ven)
}

}
