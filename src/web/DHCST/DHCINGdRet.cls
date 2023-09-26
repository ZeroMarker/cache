Import sqluser

Class web.DHCST.DHCINGdRet Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTRETURN";

/// Descript:   保存/更新退货单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-10-24
/// Table:DHC_InGdRet,DHC_INGRTITM
/// Input:退货主表id;
/// 退货科室RowId^供应商id^退货人RowId^类组RowId^调价换票标志,
/// 退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因,
/// ，退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因
/// Output:     
/// Return：成功：退货主表id；
/// 失败：ErrCode，<0
/// 
ClassMethod Save(RetId As %String, MainInfo As %String, ListData As %String) As %Library.String
{
    n (RetId,MainInfo,ListData)
    s LocId=$p(MainInfo,"^",1)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s VenId=$p(MainInfo,"^",2)
    s UserId=$p(MainInfo,"^",3)
    s StkGrp=$p(MainInfo,"^",4)
    s AdjChequeFlag=$p(MainInfo,"^",5)
    s StkGrpType=..sssCode()
    q:LocId="" -1
    q:VenId="" -2
    q:(RetId'="")&&($p($g(^INGRT(RetId)),"^",6)="Y") -8
    q:(RetId'="")&&($p($g(^INGRT(RetId)),"^",15)="Y") -9
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s MainId=""
    i RetId=""  d   ;新生成单号
    .s IngrtNo=##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),StkGrp,LocId) 
    e  d
    .s IngrtNo=$p(^INGRT(RetId),"^",1) 
    i IngrtNo="" d  trollback
    q:IngrtNo="" -3   ;生成退货单号失败 
    i MainId="" d
    s Ret=..Update(RetId,LocId,IngrtNo,VenId,UserId,StkGrp,StkGrpType,AdjChequeFlag)
    ;b ;ret
    i +Ret>0  d
    .s MainId=Ret
    ;b ;1
    i MainId="" trollback
    q:MainId="" -4   ;保存退货单失败
    ;
    s Err=0
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    i ListData="" s Len=0
    e  s Len=$l(ListData,rowDelim)
    //w Len,!
    ;
    f i=1:1:Len  q:Err'=0  d
    .s Detail=$p(ListData,rowDelim,i)
    .s Ingrti=$p(Detail,"^",1)
    .s Ingri=$p(Detail,"^",2)
    .s:Ingri="" Err=-5
    .q:Ingri=""
    .s Qty=$p(Detail,"^",3)
    .s UomId=$p(Detail,"^",4)
    .s Rp=$p(Detail,"^",5)
    .s Sp=$p(Detail,"^",6)
    .s InvNo=$p(Detail,"^",7)
    .s InvDate=$p(Detail,"^",8)
    .s InvAmt=$p(Detail,"^",9)
    .s SxNo=$p(Detail,"^",10)
    .s RetReasonId=$p(Detail,"^",11)
    .i UomId=""  d
    ..s Err=-11  ;退货单位不能为空
    .q:Err'=0
    .i Rp=""  d
    ..s Err=-12  ;退货价格不能为空
    .q:Err'=0
    .i +Qty=0  d
    ..s Err=-13   ;退货数量需大于零
    .q:Err'=0
    .
    .s RpAmt=Rp*Qty
    .s SpAmt=Sp*Qty
    .s Inclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)
    .s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
    .i (AvaQty-Qty)<0  d
    ..s Err=-10      ;可用库存不足于退货
    .q:Err'=0
    .
    .s OldSp=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",32)
    .s SpUom=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",10)
    .s BUom=$p(^INCI(+Inclb,1),"^",10)
    .s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUom)
    .s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(SpUom,BUom)
    .s OldSp=OldSp/Fac2*Fac1   ;转换成退货单位对应的售价
    .s OldSpAmt=OldSp*Qty
    .s RetAspAmt=(Sp-OldSp)*Qty
    .//i UomId=BUom d
    .//.s Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,2)
    .//.s OldSp=##class(web.DHCST.Common.AppCommon).FormatSp(OldSp,HospId,2)
    .//.s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,2)
    .//e  d
    .//.s Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1)
    .//.s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1)
    .//.s OldSp=##class(web.DHCST.Common.AppCommon).FormatSp(OldSp,HospId,1)
    
    .s Rp=##class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,+Inclb,UomId)
    .s Sp=##class(web.DHCST.Common.AppCommon).FormatInciSp(Sp,HospId,+Inclb,UomId)
    .s OldSp=##class(web.DHCST.Common.AppCommon).FormatInciSp(Sp,OldSp,+Inclb,UomId)
    .s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    .s OldSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(OldSpAmt,HospId)
    .s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    .s InvAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(InvAmt,HospId)
    .s Pp=Rp
    .s PpAmt=RpAmt
    .
    .s Data=Ingri_"^"_Qty_"^"_UomId_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt_"^"_Pp_"^"_PpAmt_"^"_OldSp_"^"_OldSpAmt_"^"_InvNo_"^"_InvDate_"^"_InvAmt_"^"_SxNo_"^"_RetReasonId
    .s Ret=##class(web.DHCST.DHCINGrtItm).Update(Ingrti,MainId,Data)  ;保存退货明细
    .;b ;1
    .i +Ret<=0  s Err=-6
    .q:Err'=0
    .
    i Err'=0 trollback   ;明细保存失败
    q:Err'=0 Err   
    tcommit    ;保存成功，则提交事务
    ;
    q MainId
}

/// 取退货主表记录的数据信息串
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  ret - 退货主表rowid
/// Return：
///  返回记录数据串
///  w ##class(web.DHCST.DHCINGdRet).Select(696)
ClassMethod Select(ret As %String) As %String
{
 q:ret="" ""
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_INGDRET where %ID=:ret)
 q:SQLCODE ""
 s cnt=$o(PLIST(""),-1)
 s cnt=27  //如新增字段,则在最下方result处增加
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 s Venid=$g(PLIST(2))
 s:Venid'="" VenDesc=$p(^APC("APCVM",Venid),"^",3)
 s Locid=$g(PLIST(8))
 s:Locid'="" LocDesc=$p(^CTLOC(Locid),"^",2)
 s ingrtdate=$g(PLIST(3))
 s:ingrtdate'="" ingrtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ingrtdate,"ST")
 s ingrtUser=$g(PLIST(6))
 s:ingrtUser'="" ingrtUser=$p(^SSU("SSUSR",ingrtUser),"^",2)
 s result=result_"^"_$g(VenDesc)_"^"_$g(LocDesc)_"^"_$g(ingrtdate)_"^"_ingrtUser
 q result
}

/// 插入或更新退货主表
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///    ret - 退货主表rowid (DHC_INGDRET)
///    loc - 科室rowid
///    retNo  -退货单号
///    vendor - 供应商rowid
///    user - 用户rowid
///    scg   - 类组rowid
///    stkType  -分类
///    AdjChequeFlag -调价换票标志
/// Return:
///   >0 - Success
///   <0 - failure
///          
ClassMethod Update(ret As %String, loc As %String, retNo As %String, vendor As %String, user As %String, scg As %String, stkType As %String, AdjChequeFlag As %String = "") As %String
{
  n (ret,loc,retNo,vendor,user,scg,stkType,AdjChequeFlag) 
  i ret="" d
  .s obj=##class(User.DHCINGDRET).%New()
  e  d
  .s obj=##class(User.DHCINGDRET).%OpenId(ret)
  s obj.INGRTAPCVMDR=##class(User.APCVendor).%OpenId(vendor,0)
  s obj.INGRTCTLOCDR=##class(User.CTLoc).%OpenId(loc,0)
  s obj.INGRTDate=+$h
  s obj.INGRTTime=$p($h,",",2)
  s obj.INGRTSSUSRDR=##class(User.SSUser).%OpenId(user,0)
  s obj.INGRTNO=retNo        ;##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),stkType,loc)
  s obj.INGRTSCGDR=##class(User.DHCStkCatGroup).%OpenId(scg,0)

  s obj.INGRTStkType=stkType
  s obj.INGRTAdjCheque=$G(AdjChequeFlag)
  s result=obj.%Save()
  if $$$ISERR(result) q -1
    q obj.%Id()
    
   ///  退货主表RowId，退货科室RowId，退货单号，供应商RowId，制单人RowId，制单日期，制单时间
}

/// 删除退货单
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///   ret - 退货单rowid
/// Return:
///   0  - success
///   <0 - failure
ClassMethod Delete(ret As %String) As %String
{
  n (ret)
  //加锁
  s lok=##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_+ret)
  q:lok'=0 -98
  
  //判断状态
  s allow=##class(web.DHCST.DHCINGdRet).AllowDel(ret)
  i allow'=0  d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_+ret)   //去锁
  q:allow'=0 -99
  b
  //删除
  &sql(delete from DHC_INGDRET Where %ID=:ret)
  d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_+ret)   //去锁
  q:SQLCODE'=0 -1 
  q 0
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  ret - 退货主表RowId
/// return:
///   0 - 允许
///   <0 -禁止
///   
ClassMethod AllowDel(ret As %String) As %String
{
 n (ret)
 s obj=##class(User.DHCINGDRET).%OpenId(ret,0)
 if obj.INGRTAuditFlag="Y" q -1
 if obj.INGRTCompleted="Y" q -2
 q 0
}

/// 退货单审核
/// Author:zhwh
/// Date:2012-07-03
/// Arg:
///  ret -退货单主表rowid
/// Return:
///   0  - Sucess
///   <0 - failure
ClassMethod Audit(ret As %String, usr As %String) As %String
{
 n (ret,usr)   
 s status=..AllowAudit(ret)
 q:status<0 status   //-1:已经审核 -2:未完成
 
 s result=##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_ret)
 q:result<0 -99  //加锁失败
 
 s errMsg=..ChkGdRetItmData(ret)
 i errMsg'="" d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ret) q -100_"^"_errMsg
  
 tstart
 s dd=+$h
 s tt=$p($h,",",2)
 s yes="Y"
 &sql(update Dhc_Ingdret set INGRT_AuditDate=:dd,INGRT_AuditTime=:tt,INGRT_SSUSR_Audit_DR=:usr,
    ingrt_auditflag=:yes  where %ID=:ret)
 i SQLCODE tro 
 i SQLCODE d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ret)
 i SQLCODE q -100
 s err=0,result=0
 &sql(declare curdhcret cursor for select ingrti_ingri_dr,ingrti_retqty,ingrti_retuom_dr,
   ingrti_retreas_dr,ingrti_rowid,ingrti_ingrt_parref->ingrt_no from Dhc_InGrtitm where ingrti_ingrt_parref=:ret)
 &sql(open curdhcret)
 
 f  &sql(fetch curdhcret into :INGRI,:qty,:RetUom,:RetReason,:DHCINGRTI,:dhcretno)  q:(SQLCODE)!(err<0)   d  
 .s INGR=+$g(INGRI) i INGR<1 q  ; INGR Parref 
 .q:DHCINGRTI="" 
 .s INGRT=+DHCINGRTI q:INGRT="" 
 .s CH=$P(DHCINGRTI,"||",2) q:CH="" 
 .s INGR=+INGRI,GRCH=$P(INGRI,"||",2)  ; Rec  .
 .s uom=+$P(^INGRT(INGRT,"DHCGRR",CH),"^",3)  ; uom  
 .s INCLB=$P(^DHCINGR(INGR,"GRI",GRCH),"^",1)
 .s locdr=+$p(^INCI(+INCLB,"IL",$p(INCLB,"||",2)),"^",1) q:locdr="" 
 .s rp=$p(^INGRT(INGRT,"DHCGRR",CH),"^",7)
 .s rpAmt=$p(^INGRT(INGRT,"DHCGRR",CH),"^",4)
 .s sprice=$p(^INGRT(INGRT,"DHCGRR",CH),"^",8)
 .s spAmt=$p(^INGRT(INGRT,"DHCGRR",CH),"^",9)
 .s pointer=DHCINGRTI
 .s intrno=dhcretno
 .s user=$p(^INGRT(INGRT),"^",8)
 .s type="R"
 .s BUom=$p(^INCI(+INCLB,1),"^",10)
 .s Factor=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,BUom)
 .s rpAmt=-rpAmt
 .s spAmt=-spAmt
 .s retQty=qty  //记录退货数量(正)
 .//=========
 .s nowqty=$p(^INCI($p(INCLB,"||",1),"IL",$p(INCLB,"||",2),"LB",$p(INCLB,"||",3)),"^",2)
 .i nowqty<qty  s result=-14 q
 .//=========
 .s qty=-qty
 .s qtyB=qty*Factor
 .q:$o(^DHCINTR(0,"TypePointer",type,pointer,""))   ;已经处理
 .
 .//处理库存
 .s err=##class(web.DHCST.Common.StockHandle).UpdateStock(INCLB,qtyB)
 .;w INCLB,!
 .;w qty,!
 .i err<0 trollback  s result=-10  q 
 .//处理台帐
 .s lstData=type_"^"_intrno_"^"_INCLB_"^"_qty_"^"_uom_"^"_sprice_"^"_user_"^"_pointer_"^"_rp_"^"_rpAmt_"^"_spAmt
 .s err=##class(web.DHCST.Common.StockHandle).IntoTrans(lstData)
 .i err<0 trollback   s result=-11  q
 .
 .s err=0	;将err置零,因IntoTrans返回值为rowid
 .//必要时生成调价损益
 .s HospId=..sssHospId(locdr)
 .//s currentSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(+INCLB,+$h,uom,HospId,..sssCode())  // 当前售价
 .//s currentRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(INCLB,uom,..sssHospId(locdr),..sssCode()) //批次进价
 .s currentSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCLB,+$h,uom,HospId,..sssCode(),"")  // 当前售价
 .s currentRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(INCLB,uom,..sssHospId(locdr),..sssCode(),+$h,"") //批次进价
 .//s currentRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(+INCLB,+$h,uom,HospId,..sssCode()) // 当前进价
 .i (+sprice'=+currentSp)!(+rp'=+currentRp) d
 ..s spdiff=sprice-currentSp
 ..s spamtdiff=spdiff*retQty  //售价差额
 ..s rpdiff=rp-currentRp
 ..s rpamtdiff=rpdiff*retQty  //进价差额
 ..s data=INCLB_"^"_retQty_"^"_spdiff_"^"_spamtdiff_"^"_rpdiff_"^"_rpamtdiff_"^"_user_"^"_pointer_"^"_type_"^"_uom
 ..s err=##class(web.DHCST.DHCRetAspAmount).Insert(data)
 ..
 .i err'=0 trollback  s result=-12  q
 .s err = ##Class(PHA.IN.InvNoManage.Save).SaveINGD(DHCINGRTI,"R")   //更新发票信息
 .i err'=0 trollback  s result=-13  q
 .
 &sql(close curdhcret)
 i result=-14 tro 
 i result=-14 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ret)
 
 i result=-14 q -14 
 
 tcommit
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ret)
 //job ##class(web.DHCST.HERP).SendData(ret,"R","")  //插入HERP中间表 add by liangjiaquan 2018-11-27
 q result
}

/// 是否允许审核
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///  ret - 退货单主表rowid
/// Return:
///   0-  allow
///   <0 - not allow
///   
ClassMethod AllowAudit(ret As %String) As %String
{
 n (ret)
 s obj=##class(User.DHCINGDRET).%OpenId(ret,0)
 i obj.INGRTAuditFlag="Y" q -1  //已审核
 i obj.INGRTCompleted'="Y" q -2  //未完成
 q 0
}

/// 将退货单主表(DHC_INGDRET)查询结果以json串的方式返回
/// Author:zhwh
/// Date:2012-07-09
/// Argu:
///   StartDate:起始日期
///   EndDate:截止日期
///   Loc：科室rowid
///   Vendor : 供应商rowid
ClassMethod jsDHCINGdRet(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
  ;s ^zhwh(123)=StrParam
  s StartDate=$p(StrParam,"^",1)  //起始日期
  s EndDate=$p(StrParam,"^",2)  //截止日期
  s Loc=$p(StrParam,"^",3)   //科室rowid
  s Vendor=$p(StrParam,"^",4) //供应商rowid
  s AuditFlag=$p(StrParam,"^",5) //审核标志
  s Completed=$p(StrParam,"^",6)  //完成标志
  
  s qParm=Sort_"^"_Dir
  
  n rs
  
  s result=##class(%ResultSet).%New("web.DHCST.DHCINGdRet:DHCINGdRet")
  s sc=result.Execute(qParm,StartDate,EndDate,Loc,Vendor,AuditFlag)

  s err=$$$ISERR(sc)
  ;
  If err  q ""

 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
       s ingrt=result.Data("ingrt")
       s vendor=result.Data("vendor")
       s vendorName=result.Data("vendorName")
       s loc=result.Data("loc")
       s locDesc=result.Data("locDesc")
       s ingrtNo=result.Data("ingrtNo")
       s retDate=result.Data("retDate")
       s retTime=result.Data("retTime")
       s retUser=result.Data("retUser")
       s retUserName=result.Data("retUserName")
       s auditDate=result.Data("auditDate")
       s auditTime=result.Data("auditTime")
       s auditUser=result.Data("auditUser")
       s auditUserName=result.Data("auditUserName")
       s auditFlag=result.Data("auditFlag")
       s completed=result.Data("completed")
       s adjCheque=result.Data("adjCheque")
       s scg=result.Data("scg")
       s scgDesc=result.Data("scgDesc")
       s rpAmt=result.Data("rpAmt")
       s spAmt=result.Data("spAmt")
       s magIn=result.Data("magIn")
        continue:(Completed'="")&(completed'=Completed)  //完成标志
        s tmp=ingrt_"^"_vendor_"^"_vendorName_"^"_loc_"^"_locDesc_"^"_ingrtNo_"^"_retDate_"^"_retTime_"^"_retUser_"^"_retUserName_"^"_auditDate_"^"_auditTime_"^"_auditUser_"^"_auditUserName_"^"_auditFlag_"^"_completed_"^"_adjCheque_"^"_scg_"^"_scgDesc_"^"_rpAmt_"^"_spAmt_"^"_magIn
        s count = count+1
        
        CONTINUE:count<(Start+1)
        CONTINUE:count>end          
                
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("ingrt^vendor^vendorName^loc^locDesc^ingrtNo^retDate^retTime^retUser^retUserName^auditDate^auditTime^auditUser^auditUserName^auditFlag^completed^adjCheque^scg^scgDesc^rpAmt^spAmt^magIn",count)
    k json
    Q resultString
}

/// 查找退货单主记录
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///   StartDate:起始日期
///   EndDate:截止日期
///   Loc：科室rowid
///   Vendor : 供应商rowid
///   AuditFlag：审核标志
Query DHCINGdRet(qParm As %String, StartDate As %String, EndDate As %String, Loc As %String, Vendor As %String = "", AuditFlag As %String = "") As %Query(ROWSPEC = "ingrt:%String,vendor:%String,vendorName:%String,loc:%String,locDesc:%String,ingrtNo:%String,retDate:%String,retTime:%String,retUser:%String,retUserName:%String,auditDate:%String,auditTime:%String,auditUser:%String, auditUserName:%String,auditFlag:%String,completed:%String,adjCheque:%String,scg:%String,scgDesc:%String,rpAmt:%Float,spAmt:%Float,magIn:%Float")
{
}

ClassMethod DHCINGdRetExecute(ByRef qHandle As %Binary, qParm As %String, StartDate As %String, EndDate As %String, Loc As %String, Vendor As %String = "", AuditFlag As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 //s ^xuantmp("aa")=qParm_","_StartDate_","_EndDate_","_Loc_","_Vendor_","_AuditFlag  
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:Loc="" $$$OK
 s Vendor=$g(Vendor)
 
 s Sort=$p(qParm,"^",1)
 s Dir=$p(qParm,"^",2)
 
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 
 s orderFieldName=""
 //s:Sort="" orderFieldName="rowid" 
 s:Sort="No" orderFieldName="ingrtNo"
 s:Sort="Date" orderFieldName="retDate"
 s:Sort="Vendor" orderFieldName="vendorName"
 s:Sort="User" orderFieldName="retUser"
 
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 
 s sql="select %ID rowid,"
 s sql=sql_"ingrt_apcvm_dr vendor,"
 s sql=sql_"ingrt_apcvm_dr->apcvm_name vendorName,"
  s sql=sql_"ingrt_ctloc_dr loc,"
  s sql=sql_"ingrt_ctloc_dr->ctloc_desc locDesc,"
  s sql=sql_"ingrt_no ingrtNo,"
  s sql=sql_"ingrt_date retDate,"
  s sql=sql_"ingrt_time retTime,"
  s sql=sql_"ingrt_ssusr_dr retUser,"
  s sql=sql_"ingrt_ssusr_dr->ssusr_name retUserName,"
  s sql=sql_"ingrt_auditdate auditDate,"
  s sql=sql_"ingrt_audittime auditTime,"
  s sql=sql_"ingrt_ssusr_audit_dr auditUser,"
  s sql=sql_"ingrt_ssusr_audit_dr->ssusr_name auditUserName,"
  s sql=sql_"ingrt_auditflag auditFlag,"
  s sql=sql_"ingrt_completed completed,"
  s sql=sql_"ingrt_adjcheque adjCheque,"
  s sql=sql_"ingrt_scg_dr scg,"
  s sql=sql_"ingrt_scg_dr->scg_desc scgDesc "
  s sql=sql_" from DHC_INGDRET "
  s sql=sql_" where INGRT_Date between "_StartDate_" and "_EndDate 
  i orderFieldName'="" d
  . s sql=sql_" order by "_orderFieldName_" "_Dir 

  n xrs
  s xrs=##class(%Library.ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute()
 
  //s ret=$$$ISERR(sc) 
  //i ret q $$$OK
  
  WHILE (xrs.Next())
  {
        s loc=xrs.Data("loc")
        //w loc,!
        continue:loc'=Loc
    
        s vendor=xrs.Data("vendor")
        i Vendor'="" continue:vendor'=Vendor
    
        s ingrt=xrs.Data("rowid")
        //w ingrt,!
        s vendorName=xrs.Data("vendorName")
        s locDesc=xrs.Data("locDesc")
        s ingrtNo=xrs.Data("ingrtNo")
        s retDate=xrs.Data("retDate")
        s retTime=xrs.Data("retTime")
        s retUser=xrs.Data("retUser")
        s retUserName=xrs.Data("retUserName")
        s auditDate=xrs.Data("auditDate")
        s auditTime=xrs.Data("auditTime")
        s auditUser=xrs.Data("auditUser")
        s auditUserName=xrs.Data("auditUserName")
        s auditFlag=xrs.Data("auditFlag")
        s completed=xrs.Data("completed")
        s adjCheque=xrs.Data("adjCheque")
        s scg=xrs.Data("scg")
        s scgDesc=xrs.Data("scgDesc")  
        continue:(AuditFlag="Y")&(auditFlag'="Y")
        continue:(AuditFlag="N")&(auditFlag="Y")
        i retDate'="" s retDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate,"ST")
        i retTime'="" s retTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime,"ST")
        i auditDate'="" s auditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(auditDate,"ST")
        i auditTime'="" s auditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(auditTime,"ST")
        //总金额
        &sql(select sum(ingrti_retamount),sum(ingrti_spamt) 
        into :rpAmt,:spAmt from DHC_INGRTITM where INGRTI_INGRT_Parref=:ingrt)
        s magIn=spAmt-rpAmt
        
        d OutPutRow1  
    }
       
 Quit $$$OK
OutPutRow1
 s xData=$lb(ingrt,vendor,vendorName,loc,locDesc,ingrtNo,retDate,retTime,retUser,retUserName,auditDate,auditTime,auditUser,auditUserName,auditFlag,completed,adjCheque,scg,scgDesc,rpAmt,spAmt,magIn)   
 s ^CacheTemp(repid,ind)=xData
 s ind=ind+1
 q
}

ClassMethod DHCINGdRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINGdRetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINGdRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINGdRetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryGDRET(StartDate As %String, EndDate As %String, Loc As %String, Vendor As %String = "") As %String
{
}

/// 将查询入库明细的结果以json串的方式返回
/// Author:zhwh
/// Date:2012-07-09
/// Argu:
///   strPar:参数串
///   Start:记录位置
///   Limit:返回记录数
/// w ##class(web.DHCST.DHCINGdRet).jsGdRecItmToRet("165^2080^^0","0","15","idate","DESC")
ClassMethod jsGdRecItmToRet(strPar As %String, Start As %String, Limit As %String, Sort As %String = "", Dir As %String) As %String
{
	//s ^YSJTMP("jsGdRecItmToRet") =  $LB(strPar , Start , Limit , Sort , Dir)
	s Loc=$p(strPar,"^",1) //科室rowid
	s hospId = $P(^CTLOC(Loc), "^", 22)
	s INCI=$p(strPar,"^",2)  //库存项 rowid
	s Vendor=$p(strPar,"^",3)  //供应商rowid
	s ZeroFlag=$p(strPar,"^",4)  ;不显示库存为零项标志  
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINGdRet:GdRecItmToRet") 
	s sc=result.Execute(Loc,INCI,Vendor,ZeroFlag)
	q:$$$ISERR(sc) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Pid=..NewPid()
	s $zt="ErrorjsGdRecItmToRet"
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	s End=Start+Limit
	s Start=Start+1
	s CountRecords=0  
    While(result.Next())
    {   
	    s code=result.Data("code")   		//代码
	    s desc=result.Data("desc")  		//描述
	    s mnf=result.Data("mnf")    		//厂家
	    s batch=result.Data("batch")  		//批号
	    s expdate=result.Data("expdate")  	//效期
	    s recqty=result.Data("recqty")  	//入库数
	    s uom=result.Data("uom")  			//单位rowid
	    s uomDesc=result.Data("uomDesc")  	//单位
	    s stkqty=result.Data("stkqty")  	//现库存数
	    s INGRI=result.Data("INGRI")  		//入库明细表rowid(DHC_INGdRecItm)
	    s pp=result.Data("pp")  			//批价
	    s sven=result.Data("sven")  		//供应商名称
	    s idate=result.Data("idate")  		//入库日期(入库审核日期)
	    s rp=result.Data("rp")  			//进价
	    s sp=result.Data("sp")  			//售价
	    s INCLB=result.Data("INCLB")  		//批次DR(INC_ItmLcBt)
	    s inci = +INCLB
	    s iniflag=result.Data("iniflag")  	//初始化标志
	    s Drugform=result.Data("Drugform")  //剂型
	    s invNo=result.Data("invNo")   		//发票号
	    s invDate=result.Data("invDate")  	//发票日期
	    s invAmt=result.Data("invAmt")   	//发票金额
	    s venid=result.Data("venid")   		//供应商id
	    s CurRp =result.Data("CurRp")   	//当前进价
	    s CurRp =result.Data("CurRp")   	//当前售价
	    s buom = $P(^INCI(+INCLB,1),"^",10)
	    s puom = $P(^INCI(+INCLB,3),"^",6)
	    s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	    s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inci, hospId)
	    s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inci, hospId)
	    s CountRecords=CountRecords+1
	    s tmpbatchdata=code_"^"_desc_"^"_mnf_"^"_batch_"^"_expdate_"^"_recqty_"^"_uom_"^"_uomDesc_"^"_stkqty_"^"_INGRI_"^"_pp_"^"_sven_"^"_idate_"^"_rp_"^"_sp_"^"_INCLB_"^"_iniflag_"^"_Drugform_"^"_invNo_"^"_invDate_"^"_invAmt_"^"_venid_"^"_buom_"^"_confac_"^"_CurRp_"^"_CurSp_"^"_InsuCode_"^"_InsuDesc
    	s Index="1"
    	i Sort="idate" s Index=idate
    	e  i Sort="code" s Index=code
    	e  i Sort="desc" s Index=desc
    	e  i Sort="batch" s Index=batch
    	e  i Sort="expdate" s Index=expdate
    	e  i Sort="recqty" s Index=recqty
    	e  i Sort="stkqty" s Index=stkqty
    	i Index="" s Index="1"
    	s ^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid,Index,CountRecords)=tmpbatchdata
    }
    q:CountRecords=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s Title="code^desc^mnf^batch^expdate^recqty^uom^uomDesc^stkqty^INGRI^pp^sven^idate^rp^sp^INCLB^iniflag^Drugform^invNo^invDate^invAmt^venid^buom^confac^CurRp^CurSp^InsuCode^InsuDesc"
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
    i End>CountRecords s End=CountRecords
    s count=0
    s outputi=""
    f  s outputi=$o(^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid,outputi),orderflag) q:outputi=""  d 
    .s outputj=""
    .f  s outputj=$o(^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid,outputi,outputj),orderflag) q:outputj=""  d 
    ..s count=count+1
	..q:count<Start
	..q:count>End
    ..s outputdata=^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid,outputi,outputj)
	..i count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(CountRecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
	k ^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid)
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	w "]}"
	q ""
ErrorjsGdRecItmToRet
	k ^TMP("DHCST","DHCINGdRet","jsGdRecItmToRet",Pid)
	q $ze
}

/// 查找库存项目可退项
/// Author:zhwh
/// Date:2012-07-03
/// Argu:
///  Loc    -科室rowid
///  INCI   -库存项目rowid
///  Vendor - 供应商rowid
///  
Query GdRecItmToRet(Loc As %String, INCI As %String, Vendor As %String, ZeroFlag As %String) As %Query(ROWSPEC = "code:%String,desc:%String,mnf:%String,batch:%String,expdate:%String,recqty:%String,uom:%String,uomDesc:%String,stkqty:%String,INGRI:%String,pp:%String,sven:%String,idate:%String,rp:%String,sp:%String,INCLB:%String,iniflag:%String,Drugform:%String,invNo:%String,invDate:%String,invAmt:%String,venid:%String, CurRp, CurSp")
{
}

ClassMethod GdRecItmToRetExecute(ByRef qHandle As %Binary, Loc As %String, INCI As %String, Vendor As %String, ZeroFlag As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:Loc="" $$$OK
 q:INCI="" $$$OK
 ;q:Vendor="" $$$OK
 
 s n=0  
 s DHCINGR=""
 
 f  s DHCINGR=$o(^DHCINGR(0,"INCI",INCI,DHCINGR)) q:DHCINGR=""  d
 . q:($d(^DHCINGR(DHCINGR))=0)!($d(^DHCINGR(DHCINGR))=10)
 . 
 . s obj=##class(User.DHCINGdRec).%OpenId(DHCINGR,0)
 . s tmpLoc=obj.INGRLocDr.%Id() 
 . s HospId = $P(^CTLOC(tmpLoc), "^", 22)
 . q:tmpLoc'=Loc
 . s tmpVen=$p(^DHCINGR(DHCINGR),"^",3)   //obj.INGRAPCVMDR.%Id()
 . q:(Vendor'="")&(tmpVen'=Vendor)
 . s VenDesc=obj.INGRAPCVMDR.APCVMName
 . s auditFlag=obj.INGRAuditFlag q:auditFlag'="Y"   //未审核　
 . 
 . s DHCINGRCH=""
 . f  s DHCINGRCH=$o(^DHCINGR(0,"INCI",INCI,DHCINGR,DHCINGRCH)) q:DHCINGRCH=""  d
 . . s INGRI=DHCINGR_"||"_DHCINGRCH
 . . 
 . . s objItm=##class(User.DHCINGdRecItm).%OpenId(INGRI,0)
 . . s INCLB=objItm.INGRIINCLBDR.%Id() q:INCLB=""
 . . s code=$p(^INCI(INCI,1),"^",1) ; code of item
 . . s desc=$p(^INCI(INCI,1),"^",2) ; desc of item  
 . . s curqty=##class(web.DHCST.Common.DrugStkCommon).IL(INCI,Loc,+$h)  
 . . s recqty=objItm.INGRIRecQty
 . . s uom=objItm.INGRICTUOMDR.%Id()
 . . i uom="" s uom=+$p($g(^INCI(+INCLB,1)),"^",10) ; if rec uom is null then set it with basic uom
 . . s uomDesc=objItm.INGRICTUOMDR.CTUOMDesc
 . . s stkqty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(INCLB,uom)    //.QtyINCLBUom(INCLB,uom,+$h)  
 . . q:(ZeroFlag="Y")&(stkqty'>0)  //不显示零批次
 . . s idate=obj.INGRDate i idate'="" s idate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(idate,"ST") ; 审核日期
 . . s iniflag="0"
 . . s rp=objItm.initmrealprice
 . . s sp=objItm.initmsaleprice
 . . s pp=objItm.initmBatPrice
 . . s mnf=objItm.initmphmnfdr.PHMNFName
 . . s invNo=objItm.initminvno
 . . s invDate=objItm.initminvdate
 . . i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
 . . s invAmt=objItm.initminvmoney
 . . 
 . . s tmp=##class(web.DHCST.Common.DrugStkCommon).Bat(INCLB)
 . . s batch=$p(tmp,"^",1),expdate=$p(tmp,"^",2)
 . .
 . . s sven=$p(^APC("APCVM",tmpVen),"^",3)  ; name of vendor
 . . s Drugform=##class(web.DHCST.Common.DrugInfoCommon).GetForm(+INCLB)
 . . s Drugform=$p(Drugform,"^",2)
 . . // 获取批次当前价格
 . . s CurRp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(INCLB,uom,HospId,"G",+$h,"")
 . . s CurSp = ##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCLB,+$h,uom,HospId,"G","") 
 . . d OutPutRow2
 Quit $$$OK
OutPutRow2
 s Data=$lb(code,desc,mnf,batch,expdate,recqty,uom,uomDesc,stkqty,INGRI,pp,sven,$g(idate),+$g(rp),+$g(sp),INCLB,iniflag,Drugform,invNo,invDate,invAmt,tmpVen, CurRp, CurSp)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GdRecItmToRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GdRecItmToRetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GdRecItmToRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GdRecItmToRetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 取库存项目的供应商列表数据(json)
/// Author:zhwh
/// Date:2012-07-09
/// Argu:
/// strPar - 参数串(库存项目rowid^科室rowid^不包括0库存的供应商(Y/N))
/// Return:
/// 供应商列表json数据
///  
ClassMethod jsVendorForLocItm(strPar As %String) As %String
{
  s INCI=$p(strPar,"^",1)
  s Loc=$p(strPar,"^",2)
  s ExcludeZeroQtyVendor=$p(strPar,"^",3)
  
 s count = 0
 s resultString = ""

 s json = ##class(Code.JsonObj).%New()
 
  s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINGdRet:VendorForLocItm") 
  s sc=result.Execute(INCI,Loc,ExcludeZeroQtyVendor)
  s err=$$$ISERR(sc)
  ;
  If err  q ""
  
    While(result.Next())
    {   
    s vendor=result.Data("vendor")
    s vendorName=result.Data("vendorName")
    s latestRecDate=result.Data("latestRecDate")
    s venStkQty=result.Data("venStkQty")
    s puomDesc=result.Data("puomDesc")

    s tmp=vendor_"^"_vendorName_"^"_latestRecDate_"^"_venStkQty_"^"_puomDesc
    s count = count+1

    ;CONTINUE:count<(Start+1)
    ;CONTINUE:count>end         
        
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("vendor^vendorName^latestRecDate^venStkQty^puomDesc",count)
    k json
    Q resultString
}

/// 检索库存项目的历史供应商(入过库)
/// Author:zhwh
/// Date:2012-07-04
/// Argu:
///   INCI -库存项目rowid
///   Loc  - 退货科室rowid
///   ExcludeZeroQtyVendor - 排除0库存的供应商(Y/N)
///   
Query VendorForLocItm(INCI As %String, Loc As %String, ExcludeZeroQtyVendor As %String = "") As %Query(ROWSPEC = "vendor:%String,vendorName:%String,latestRecDate:%String,venStkQty:%String,puomDesc:%String")
{
}

ClassMethod VendorForLocItmExecute(ByRef qHandle As %Binary, INCI As %String, Loc As %String, ExcludeZeroQtyVendor As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 q:INCI="" $$$OK
 q:Loc="" $$$OK
 s ExcludeZeroQtyVendor=$G(ExcludeZeroQtyVendor)
 
 s incilsub=$o(^INCI("IL_LOC",Loc,INCI,"")) q:incilsub="" ""
 s incil=INCI_"||"_incilsub
 s i=0,dah=""
 f  s dah=$o(^DHCINTR(0,"ILTYPEDATE",incil,"G",dah),-1) q:dah=""  d
 .s intr=""
 .f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,"G",dah,intr),-1) q:intr=""  d
 ..s dhcingri=$p(^DHCINTR(intr),"^",9)
 ..s dhcingr=$p(dhcingri,"||",1) q:dhcingr=""
 ..q:'$d(^DHCINGR(dhcingr))
 ..s inclb=$p(^DHCINTR(intr),"^",7)
 ..s ven=$p(^DHCINGR(dhcingr),"^",3)
 ..s indate=$p(^DHCINGR(dhcingr),"^",4) ;入库时间
 ..s inclbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
 ..
 ..i '$d(^TMP("VendorForLocItm",$j,ven,indate,inclb)) d
 ...s ^TMP("VendorForLocItm",$j,ven,indate,inclb)=inclbQty
 ..e  d
 ...s $p(^TMP("VendorForLocItm",$j,ven,indate,inclb),"^",1)=$p(^TMP("VendorForLocItm",$j,ven,indate,inclb),"^",1)+inclbQty
 ..
 s tmpven=""
 f  s tmpven=$o(^TMP("VendorForLocItm",$j,tmpven)) q:tmpven=""  d
 .s venStkQty=0
 .s latestRecDate=$O(^TMP("VendorForLocItm",$j,tmpven,""),-1)
 .
 .s recDate=""
 .f  s recDate=$O(^TMP("VendorForLocItm",$j,tmpven,recDate)) q:recDate=""  d
 ..s inclb=""
 ..f  s inclb=$O(^TMP("VendorForLocItm",$j,tmpven,recDate,inclb)) q:inclb=""  d
 ...s venStkQty=venStkQty+$p(^TMP("VendorForLocItm",$j,tmpven,recDate,inclb),"^",1)
 .
 .i ExcludeZeroQtyVendor="Y" q:venStkQty'>0  //供应商库存的判断
 .
 .s buom=$p(^INCI(INCI,1),"^",10)
 .s puom=$p(^INCI(INCI,3),"^",6)
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
 .s venStkQty=venStkQty/fac
 .d OutPutRow3
 
 k ^TMP("VendorForLocItm",$j)
  
 Quit $$$OK
 
OutPutRow3
 s vendorName=$p(^APC("APCVM",tmpven),"^",3)
 i latestRecDate'=""  s latestRecDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(latestRecDate,"ST")
 s puomDesc=$p(^CT("UOM",puom),"^",2)
 
 s Data=$lb(tmpven,vendorName,latestRecDate,venStkQty,puomDesc)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod VendorForLocItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VendorForLocItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod VendorForLocItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VendorForLocItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 设置退货单完成状态 
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///  ingrt - 退货单主表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod SetCompleted(ingrt As %String) As %String
{
 n (ingrt)
 q:ingrt="" -1
 q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_ingrt)<0 -99  //lock
 s obj=##class(User.DHCINGDRET).%OpenId(ingrt)
 d obj.%Reload()
 s comp=obj.INGRTCompleted
 i comp="Y" d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ingrt)  q -2  //not allow to set 
 
 s obj.INGRTCompleted="Y"
 s sc=obj.%Save()
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ingrt)
 i $$$ISERR(sc) q -3
 q 0
}

/// 取消退货单完成状态 
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///  ingrt - 退货单主表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod CancelCompleted(ingrt As %String) As %String
{
 n (ingrt)
 q:ingrt="" -1
 q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_ingrt)<0 -99  //lock
 s obj=##class(User.DHCINGDRET).%OpenId(ingrt)
 d obj.%Reload()
 //
 s auditFlag=obj.INGRTAuditFlag 
 s comp=obj.INGRTCompleted
 i auditFlag="Y"  d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ingrt) q -10  //已经审核
 i comp'="Y" d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ingrt)  q -2  //not allow to set 
 s obj.INGRTCompleted="N"
 s sc=obj.%Save()
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_ingrt)
 i $$$ISERR(sc) q -3
 q 0
}

/// Descript:取退货界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-11-02
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：默认查找起始日期^默认查找截止日期^打印显示“负值”^允许修改退货批次进价^允许修改退货批次售价
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    //s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=..%GetParameter("AppName")
    ;b ;1
    s DefaStartDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefStartDate",Param)
    s DefaEndDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefEndDate",Param)
    s PrintNegative=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PrintNegative",Param)
    s AllowModifyRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowModifyRp",Param)
    s AllowModifySp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowModifySp",Param)
    ;
    s Data=DefaStartDate_"^"_DefaEndDate_"^"_PrintNegative_"^"_AllowModifyRp_"^"_AllowModifySp
    q Data
}

/// 根据入库明细取入库的进价和售价
/// Author:zhwh
/// Date:2013-01-05
/// Arguments:
///   ingri - 入库明细表rowid
///   uom -单位rowid
ClassMethod IngriPrice(ingri As %String, uom As %String) As %String
{
   n (ingri,uom)
    s inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
   	 ///格式化
	 S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	 s CustStr=##class(web.DHCSTCOMMO).GetLocCust(LocID)
	 s CustID=$p(CustStr,"^",1)
	 s HospID=$p(CustStr,"^",5)
	 S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	 S StkTypeDesc=$P(CatGrpStr,"^",4)
	 S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
  
   &sql( select initm_inci_dr,initm_realprice,initm_saleprice,ingri_ctuom_dr 
    into :inci,:rp,:sp,:recUom   from dhc_ingdrecitm where %id=:ingri)
    s data="^"
    q:SQLCODE data
    s inci=+inci
    i +uom=+recUom d
    .s data=rp_"^"_sp
    e  d
    .s buom=$p($G(^INCI(inci,1)),"^",10)
    .s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(+recUom,buom)
    .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(+uom,buom)
    .s rp=(rp/fac1)*fac
    .s sp=(sp/fac1)*fac
    .s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",2)
    .s sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(sp,Perv,"FmtSP",2)
    .s data=rp_"^"_sp
    q data
}

/// 检查退货单单数据(一般在"审核"前执行该操作)
/// Author:LiangQiang
/// Date:2014-01-16
/// Argu:
/// 退货主表主表rowid
/// Return:
///    "" -数据合法
///    非空 -  错误信息
ClassMethod ChkGdRetItmData(ret As %String) As %String
{
	 n (ret)
	 s errMsg=""
	 s ch=0
	 f  s ch=$O(^INGRT(ret,"DHCGRR",ch)) q:(ch="")!(errMsg'="")  d
	 .s ingri=$P(^INGRT(ret,"DHCGRR",ch),"^",1)
	 .s inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	 .s qty=$P(^INGRT(ret,"DHCGRR",ch),"^",2)
	 .s sp=$P(^INGRT(ret,"DHCGRR",ch),"^",8)
	 .s uom=$P(^INGRT(ret,"DHCGRR",ch),"^",3)
	 .s rp=$P(^INGRT(ret,"DHCGRR",ch),"^",7)
	 .s inci=+inclb
	 .s code=$p(^INCI(inci,1),"^",1)
	 .s desc=$p(^INCI(inci,1),"^",2)
	 .s buom=$p(^INCI(inci,1),"^",10)
	 .i uom'=buom d
	 ..&sql( select %ID into :fac from  ct_confac where ctcf_frUOm_dr=:uom and ctcf_touom_dr=:buom)
	 ..i SQLCODE s errMsg="库存项：<"_desc_"> 单位换算错误"
	 .q:errMsg'=""
	 .
	 .s loc=$$LOC^ST01(inclb)
	 .s hospid=$p(^CTLOC(loc),"^",22)
	 .
	 .s StkType = "G"
	 .i uom=buom d
	 ..s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,hospid,2,StkType)
	 .e  d
	 ..s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,hospid,1,StkType)
	 .//s currentSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,uom,hospid)
	 .//s currentSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,hospid,"G","")
	 .//i sp'=currentSp s errMsg="库存项：<"_desc_"> 售价已发生变化"
	 .//q:errMsg'=""
	 .//检查库存
	 .s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,buom)
	 .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	 .s qty=qty*Fac
	 .i AvaQty-qty<0 s errMsg="库存项：<"_desc_"> 可用库存数小于调整数"
	 .q:errMsg'=""
	 .
	 q errMsg
}

/// Creator:yunhaibao
/// CreatDate:20151126
/// Description:判断该退货库单是否已经生成月报
/// InPut：退货主表id
/// Return:0,未生成；1,已生成
ClassMethod IfMakeMon(ingrt As %String)
{
	n (ingrt)
	q:ingrt="" 0
	s loc=$p(^INGRT(ingrt),"^",7)
	s date=$p(^INGRT(ingrt),"^",9) ;审核日期
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE 1
	q 0
}

/// creator:yunhaibao
/// createdate:20150418
/// description:退货取消审核
/// w ##class(web.DHCST.DHCINGdRet).CancelAudit("553")
ClassMethod CancelAudit(ingrt As %String)
{
	q:+ingrt="0" ..Trans("退货单ID为空!")
	s Ingrt=+ingrt
 	s Complete=$p(^INGRT(Ingrt),"^",6)
 	q:Complete'="Y" ..Trans("退货单未完成!")
 	s Audit=$p(^INGRT(Ingrt),"^",15)
 	q:Audit'="Y" ..Trans("退货单未审核!")
 	q:..IfMakeMon(Ingrt)=1 ..Trans("已经生成月报，不允许取消审核!")
 	q:..IfHaveAdjPrice(Ingrt)>0 "退货审核后,存在已生效调价记录,不允许取消审核!"
 	s result=##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_Ingrt)
 	q:result<0 "加锁失败"
 	s Ret=0
 	s Ch=0
 	tstart
 	s $ZT="Error^DHCSTERROR"  //遇报错此方法已按进程全部解锁
	f  s Ch=$o(^INGRT(Ingrt,"DHCGRR",Ch)) q:(Ch="")!(Ret'=0)  d
	.s Ingrti=Ingrt_"||"_Ch
	.s Ingri=$p(^INGRT(Ingrt,"DHCGRR",Ch),"^",1)
	.s Ingr=+Ingri
	.s IngrItm=$p(Ingri,"||",2)
	.i '$d(^DHCINGR(Ingr,"GRI",IngrItm)) s Ret=Ingrti_..Trans("找不到对应入库记录!")
	.q:Ret'=0
	.;恢复库存数据
	.s Ret=##class(web.DHCST.Common.StockHandle).DelIntrs("R",Ingrti)
	.i Ret'=0 s Ret=Ingrti_..Trans("处理库存数据失败!")  q
	.;删除退货损益数据
	.s AspRet=##class(web.DHCST.DHCRetAspAmount).delete("R",Ingrti)
	.i AspRet'=0 s Ret=Ingrti_..Trans("处理退货损益数据失败!")  q
	.s InvNoRet = ##Class(PHA.IN.InvNoManage.Save).DeleteInvNoItm(Ingrti,"R")  // 删除发票信息
	.i InvNoRet'=0 s Ret = Ingrti_..Trans("删除发票信息失败!")  q
	i Ret'=0 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingrt) 
	i Ret'=0 trollback
	q:Ret'=0 Ret
	&sql(UPDATE DHC_INGDRET SET INGRT_SSUSR_Audit_DR=null,INGRT_AuditDate=null,INGRT_AuditTime=null,INGRT_SSUSR_Purch_DR=null,INGRT_PurchDate=null,INGRT_PurchTime=null,INGRT_SSUSR_Treasurer_DR=null,INGRT_TreasureDate=null,INGRT_TreasureTime=null,INGRT_AuditFlag=null,INGRT_Completed=null where INGRT_RowId=:Ingrt)
	i SQLCODE d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingrt) 
	i SQLCODE trollback
	q:SQLCODE ..Trans("更新退货单状态失败!")
	
	tcommit
	d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingrt) 
	//job ##class(web.DHCST.HERP).CancelData(Ingrt,"G","") //删除HERP中间表 add by liangjiaquan 2018-11-27
	q 0
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCINGdRet"))
}

/// creator:yunhaibao
/// createdate:20151223
/// description:判断退货明细数据是否在审核日期后存在调价
/// input：退货主表id
/// return:>0 存在
/// w ##class(web.DHCST.DHCINGdRet).IfHaveAdjPrice("795")
ClassMethod IfHaveAdjPrice(ingdret As %String) As %Library.String
{
	n (ingdret)
	q:ingdret="" 0
	s priceflag=0
	s ingdretdate=$p(^INGRT(ingdret),"^",9)
	s ingdrettime=$p(^INGRT(ingdret),"^",10)
	s ingdretch=""
	f  s ingdretch=$o(^INGRT(ingdret,"DHCGRR",ingdretch)) q:(ingdretch="")!(priceflag'=0)  d
	.s ingdretrowid=ingdret_"||"_ingdretch
	.s inclb=$p(^INGRT(ingdret,"DHCGRR",ingdretch),"^",6)
	.q:'$d(^DHCINTR(0,"TypePointer","R",ingdretrowid))  //台账记录
	.s priceflag=##class(web.DHCST.DHCRetAspAmount).CheckIfHaveAdjPrice(inclb,ingdretdate,ingdrettime)
	q priceflag
}

/// Descript:	更新退货单中的发票信息
/// Creator:	yangsj
/// CreateDate:	2021-05-19
/// Table:		DHC_INGRTITM
/// Input:		
/// Return：	0 成功，其它失败
/// Debugger:	w ##Class(web.DHCST.DHCINGdRet).UpdateInvNoInfo("13||1^3333^2021-05-12")
ClassMethod UpdateInvNoInfo(ListData)
{
	//s ^YSJTMP("UpdateInvNoInfo")= ListData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	ts 
	s Ret=0
	f i = 1:1:Len  q:Ret'=0  d
	.s Data = $p(ListData,rowDelim,i)
	.s Rowid   = $p(Data,"^",1)
	.s invNo   = $p(Data,"^",2)
	.s invDate = $p(Data,"^",3)
	.s invDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(invDate)
	.s PayFlag = ..IfPay(Rowid)
	.i PayFlag = "Y" s Ret=-1_"^"_..Trans("退货记录已经付款，不允许修改发票信息")  q
	.q:(invNo="")&&(invDate="")
	.i ((invNo="")&&(invDate'=""))||((invNo'="")&&(invDate=""))  s Ret=-1_"^"_..Trans("发票号和发票日期必须同时填写!")  q
	.&SQL(UPDATE DHC_INGRTITM SET INGRTI_InvNo =:invNo,INGRTI_InvDate=:invDate WHERE INGRTI_RowId =:Rowid)
	.i SQLCODE'=0 s Ret=-1_"^"_..Trans("更新退货子表发票信息失败:")_SQLCODE  q
	.s Ret = ##Class(PHA.IN.InvNoManage.Save).SaveINGD(Rowid,"R")
	.i Ret'=0  s Ret=-1_"^"_..Trans("更新发票表发票信息失败:")_Ret  q

	i Ret'=0 tro
	q:Ret'=0 Ret
	b ;tc
	tc
	q 0
}

/// Descript:	判断退货记录是否已经付款
/// Creator:	yangsj
/// CreateDate:	2021-05-19
/// Table:		DHC_PayItm
/// Input:		
/// Return：	Y/N
/// Debugger:	w ##Class(web.DHCST.DHCINGdRet).IfPay("13||1")
ClassMethod IfPay(Ingri As %String) As %Library.String
{
	n (Ingri)
	q:Ingri="" "N"
	s Ret = "N"
	s Pay = 0
	f  s Pay = $o(^DHCPAY(0,"GRI",Ingri,Pay)) q:(Pay="")!(Ret'="N")  d
	.s Itm = $o(^DHCPAY(0,"GRI",Ingri,Pay,0))
	.s RecType = $p(^DHCPAY(Pay,"I",Itm),"^",9)
	.q:RecType'="R"
	.s AckFlag = $p(^DHCPAY(Pay),"^",8)
	.i AckFlag = "Y" s Ret="Y"  ;已经付款
	.
	q Ret
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.ingdretaudit.csp",Text)
}

}
