Import SQLUser

Class web.DHCSTCOMMONSRV Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 48;

ClassMethod GetSysDate() As %String
{
 s sysdate=$p($h,",",1)
 s sysdate=$zd(sysdate,3)
 s P0=sysdate
 q P0
}

ClassMethod GetSysTime() As %String
{
 s systime=$p($h,",",2)
 s P0=$zt(systime)
 q P0
}

ClassMethod GetDate(dd As %String, x As %Integer) As %String
{
    s da=$zdh(dd,3)
    q:da="" ""
    s da=da+x
    q $zd(da,3)
}

ClassMethod GetDateStream() As %String
{
    s sysdate=$p($h,",",1)
    s P0=$zd(sysdate,8)
    q P0
}

ClassMethod GetBillNoStream(fix As %String) As %String
{
    s datestr=..GetDateStream()
    s fix=fix_datestr
    s P0=fix
    q P0
}

// >>> Other

ClassMethod GetStreqNo(prefix As %String) As %String
{
                  
 s prefix=..GetBillNoStream(prefix)
 &sql(select MAX(inrq_no) into :inno
    from in_request where %ALPHAUP(inrq_no) %STARTSWITH :prefix)
 i inno=""  s inno=prefix_"_01",P0=inno q P0        
 s stream=$e(inno,12,13)
 s stream=stream+1
 s inno=$e(inno,1,11)_stream
 i $l(inno)<13 d         
 .s innotail=$e(inno,12,12) 
 .s inno=$e(inno,1,11)_"0"_innotail        
 s P0=inno
 q P0
}

ClassMethod GetGdNo(prefix As %String) As %String
{
    s prefix=..GetBillNoStream(prefix)
    &sql( select MAX(ingr_no) into :inno
    from in_gdrec  where  %ALPHAUP(ingr_no) %STARTSWITH :prefix)
    i inno=""  s inno=prefix_"_001",P0=inno q P0        
    s stream=$p(inno,"_",2)       
    s stream=stream+1
    i $l(stream)=1 d
    .s stream="00"_stream
    e  i $l(stream)=2  d
    .s stream="0"_stream
    s inno=$p(inno,"_",1)_"_"_stream
    s P0=inno
    q P0
}

ClassMethod GetSttrNo(prefix As %String) As %String
{
                       
 s prefix=..GetBillNoStream(prefix)
 &sql( select MAX(init_no) into :inno
    from in_istrf  where  %ALPHAUP(init_no) %STARTSWITH :prefix)
 i inno=""  s inno=prefix_"_001",P0=inno q P0        
 s stream=$p(inno,"_",2)       
 s stream=stream+1
 i $l(stream)=1 d
 .s stream="00"_stream
 e  i $l(stream)=2  d
 .s stream="0"_stream
 s inno=$p(inno,"_",1)_"_"_stream
 s P0=inno
 q P0
}

ClassMethod ItemCodeToCat(IC As %String) As %String
{

 s STK=""     
 &sql(select inci_incsc_dr->incsc_desc into :STK from inc_itm  where inci_code=:IC)
 q $g(STK)
}

ClassMethod ItemCodeToID(Tmp As %String) As %String
{
 &sql(SELECT INCI_ROWID INTO :QQ FROM INC_ITM WHERE INCI_CODE=:Tmp)
 q $g(QQ)
}

ClassMethod ItemDescToID(Tmp) As %String
{
          
  &sql(SELECT INCI_ROWID INTO :QQ FROM INC_ITM WHERE INCI_Desc=:Tmp)
  q QQ
}

ClassMethod GetItmDrugForm(itmcode As %String) As %String
{
    q:itmcode="" ""
    s inci=..ItemCodeToID(itmcode) q:inci="" ""
    s phcform=""
    &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_PHCF_DR->phcf_desc 
       into :phcform  from inc_itm where inci_rowid=:inci)
    q $g(phcform)
}

ClassMethod INCIBNoToID(ITEMDesc As %String, CTLOCDESC As %String, INCIBNo As %String) As %String
{
    &sql(SELECT INCLB_ROWID into :RR FROM INC_ITMLCBT 
                    WHERE INCLB_INCIL_PARREF->INCIL_INCI_PARREF->INCI_Desc=:ITEMDesc
                    AND INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_DESC=:CTLOCDESC
                    AND INCLB_INCIB_DR->INCIB_NO=:INCIBNo) 
    q:SQLCODE -1
    q RR
}

ClassMethod GetItmAllMnfs(itmcode As %String) As %String
{
                     
    k PLIST     s i=0
  s manfname=""
  s manfname=$$GetManfName^DHCSTITMDESC(itmcode)       
  i manfname'=""  d
        .s i=i+1 
        .s PLIST(i)=manfname                           
  s PLIST=$o(PLIST(""),-1)
  q i
}

ClassMethod CTUOMToID(MP As %String) As %String
{
          
 &sql(select ctuom_rowid into :LL From ct_uom where ctuom_desc=:MP)
 q $p($g(LL),$c(1))
}

ClassMethod CTUOMFactor(CTUOMFRDESC As %String, CTUOMTODESC As %String) As %String
{
                  
 k P9
 s NM=0
 i CTUOMFRDESC=CTUOMTODESC  q 1
 &sql(SELECT CTCF_FACTOR INTO :NM FROM CT_CONFAC
       WHERE CTCF_FRUOM_DR->CTUOM_DESC=:CTUOMFRDESC
       AND CTCF_TOUOM_DR->CTUOM_DESC=:CTUOMTODESC)
 i '$f(NM,$c(1)) q NM
 s P9=$p(NM,$c(1),2)
 q P9   
                         //
}

ClassMethod UOMFac(fr As %String, to As %String) As %String
{
    q:fr=to 1    //if from-uom is as same as to-uom then return 1
    s rowid=""
    s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
    i rowid'="" d       
    .s fac=$p(^CT("CTCF",rowid),"^",3)
    .s fac=$p(fac,$c(1))
    e  d
    .s fac=1
    q $g(fac)
    //
}

ClassMethod GetItmUOConFac(itemcode As %String, uo As %String) As %String
{
 q:itemcode="" ""
 q:uo="" ""                         
 s baseuo=$$GetBaseUoDescByCode^DHCSTITMDESC(itemcode)  //
 s confac=..CTUOMFactor(uo,baseuo)       //
 q confac
}

ClassMethod VendorToRowid(x As %String) As %String
{
                           
 s QQQ=""      
 &sql(select apcvm_rowid into :QQQ from apc_vendor where apcvm_name=:x)
 s P9=$p(QQQ,$c(1))
 q $p(QQQ,$c(1))
}

ClassMethod VendorCodeToRowid(vendorcode As %String) As %String
{
 s id=""            
 &sql(select apcvm_rowid into :id from apc_vendor where apcvm_code = :vendorcode)                
 q $g(id)
}

ClassMethod GetVendors() As %String
{

 &sql(declare curvendor cursor for select apcvm_code,apcvm_name from apc_vendor)
 &sql(open curvendor)
 s num=1
 f  &sql(fetch curvendor into :vencode(num),:venname(num) )   q:SQLCODE  d 
         .s num=num+1
 &sql(close curvendor)
 s P9=num-1
 q ""
}

ClassMethod ListVendors(i As %String) As %String
{

 k PLIST
 s PLIST(1)=vencode(i)
 s PLIST(2)=venname(i)
 s PLIST=$o(PLIST(""),-1)
 q 0
}

ClassMethod AddVendortoItmVen(itemcode As %String, vendorcode As %String) As %String
{
                             
 s rowid=""
 &sql(select incv_parref into :rowid from inc_itmven
  where incv_parref->inci_code=:itemcode and incv_apcvm_dr->apcvm_code=:vendorcode)
 i rowid'=""  q rowid
 //&sql(insert into inc_itmven() values () )
 q 0
}

ClassMethod LocToRowID(TmpLoc As %String) As %String
{

 s PP=""
 &sql( SELECT CTLOC_ROWID INTO :PP FROM CT_LOC WHERE CTLOC_DESC=:TmpLoc)
 q $g(PP)
}

ClassMethod GetLoc() As %String
{
                          
 k PLIST
 &sql(declare curx cursor for select ctloc_desc from ct_loc order by ctloc_desc)
 s i=1
 &sql(open curx)
 f  &sql(fetch curx into :loc(i))  q:SQLCODE  d
   .//s PLIST=i
   .s PLIST(i)=loc(i)
   .s i=i+1
                             s PLIST=$o(PLIST(""),-1)
 &sql(close curx)
 q i-1
}

ClassMethod GetGroupLoc(group As %String) As %String
{
                 
                     k PLIST     
 &sql(declare curxxx cursor for 
          select st_ctloc_dr->ctloc_desc From ss_groupstocklocations 
          where st_parref=:group order by st_ctloc_dr->ctloc_desc                 )
 s i=1                  //st_ctloc->ctloc_desc,
 &sql(open curxxx)
 f  &sql(fetch curxxx into :loc)  q:SQLCODE  d
         .i loc'="" d
         ..s PLIST(i)=loc
         ..s i=i+1
 s PLIST=$o(PLIST(""),-1)
 &sql(close curxxx)
 q i-1
}

ClassMethod GetTypeLoc(stype As %String) As %Integer
{
    k PLIST       
    s stype=$g(stype),i=1,loc=""
    &sql(declare curt cursor for select ctloc_desc from ct_loc where ctloc_type=:stype)
    &sql(open curt)
    f  &sql(fetch curt  into :loc )  q:SQLCODE  d
      .s PLIST(i)=loc
      .s i=i+1
    s PLIST=$o(PLIST(""),-1)                                            
    &sql(close curt)
    q i-1
}

ClassMethod ListLoc(n As %Integer) As %String
{
    q PLIST(n)
}

ClassMethod GetUserRowid(usercode As %String) As %String
{
 &sql(select ssusr_rowid into :xx From ss_user where ssusr_initials=:usercode )        
 s xx=$p($g(xx),$c(1),1)
 q $g(xx)        
 //user rowidusercode
}

ClassMethod GetUserCodeByRowid(id As %String) As %String
{

 s usercode=""
 &sql(select ssusr_initials into :usercode From ss_user where ssusr_rowid=:id)
 q usercode
}

ClassMethod GetUserDefaultLoc(userid As %String) As %String
{
 s loc=""
 &sql(select ssusr_defaultdept_dr->ctloc_desc into :loc
           from ss_user where ssusr_rowid=:userid)
 q loc
}

ClassMethod GetItmLocQty(itmcode As %String, loc As %String) As %String
{

 s qty=""
 //&sql(select incil_availqty into :qty From inc_itmloc
 //        where incil_inci_parref->inci_code=:itmcode and incil_ctloc_dr->ctloc_desc=:loc)
 //        
 s qty=$$CurQty^DHCSTSTKQTY(itmcode,loc)            // zhwh 2004-08-20
 s qty=$p(qty,$c(1))
 q qty
}

ClassMethod GetItmLocQtyUO(itmcode As %String, loc As %String, uo As %String) As %String
{
          
 s qty=0          
 s qty=..GetItmLocQty(itmcode,loc)  //
 //s qty=$p(qty,$c(1))
 s baseuo=$$GetBaseUoDescByCode^DHCSTITMDESC(itmcode)  //
 s confac=..CTUOMFactor(uo,baseuo)       //
 s qty=$fn(qty/confac,"",2)                        //
 q qty
}

ClassMethod GetItmLocMNRQtyUO(itmcode As %String, loc As %String, uo As %String) As %String
{
                        
 &sql(select  incil_minqty,incil_maxqty,incil_repqty  
                 into :minqty,:maxqty,:repqty
         from inc_itmloc where incil_ctloc_dr->ctloc_desc=:loc
           and incil_inci_parref->inci_code=:itmcode)
 i SQLCODE=100 q ""
 s minqty=+$g(minqty),maxqty=+$g(maxqty),repqty=+$g(repqty)
 s baseuo=$$GetBaseUoDescByCode^DHCSTITMDESC(itmcode)
 s confac=$p(..CTUOMFactor(uo,baseuo),$c(1))       //uo must be the description
 s minqty=$fn(minqty/confac,"",2)
 s maxqty=$fn(maxqty/confac,"",2)
 s repqty=$fn(repqty/confac,"",2)
 q minqty_"^"_maxqty_"^"_repqty
}

ClassMethod GetItmLocBatQty(inclb As %String, uodesc As %String) As %String
{
  s qty=""                                                                                      // zhwh 2004-08-20
  s qty=$$CurQtyINCLBU^DHCSTSTKQTY(inclb,uodesc)        // zhwh 2004-08-20       
  q qty
}

ClassMethod GetItemSp(code As %String, HospID = "") As %String
{
  
     s itemcode=$p(code,"^",1)   
     s ibdr=$p(code,"^",2)       
     s uom=$p(code,"^",3)      
     s itemcode=$g(itemcode)
     s ibdr=$g(ibdr)
     i uom'="" d
     .s uom=..CTUOMToID(uom),uom=$p($g(uom),$c(1))  
     s inciid=$p(..ItemCodeToID(itemcode),$c(1))
     s stdate=+$h
     i ibdr'="" d            
     .//s sp=..GetPriceLF(inciid,stdate,uom,ibdr)      
     e  d
     .s sp=##Class(web.DHCSTPRICE).GetSp(inciid,stdate,uom,HospID,"")   //zhouyg 20150113 //..GetPriceElse(inciid,stdate,uom,HospID)              
     s P9=$p(sp,"^",1)
     s P8=$p(sp,"^",2)
     s P7=$p(sp,"^",3)
     q sp
}

ClassMethod GetItemSpUO(itemcode As %String, uo As %String, HospID = "") As %String
{
    
 s x1=$p(itemcode,"^",1)
 s x2=$p(itemcode,"^",2)
 s itemcode=x1_"^"_x2_"^"_uo
 s sp=..GetItemSp(itemcode,HospID="")
 q sp
}

ClassMethod GetPrice(inciid As %String, stdate As %String, uom As %String, ibt As %String, HospID = "") As %String
{
        
 k customer
 k price
 s price=##Class(web.DHCSTPRICE).GetSp(inciid,stdate,uom,HospID,"") //zhouyg 20150113
 i price="" s price=0
 q price
}

/// 修改,zhouyg 20150113
ClassMethod GetPriceElse(inciid, stdate, uom, HospID = "", timeh = "", exStr = "") As %String
{
  s price =##Class(web.DHCSTPRICE).GetSp(inciid, stdate, uom, HospID,timeh,exStr)
  q price
}

ClassMethod GetItmSPWithDate(itmcode As %String, spdate As %String, uomdesc As %String) As %String
{
                                    
   //fixed mode price method
   s itmrowid=..ItemCodeToID(itmcode)
   s uom=..CTUOMToID(uomdesc)
   s spdate=$zdh(spdate,3)  // the argument "spdate" must be "3" format
   q ..GetPrice(itmrowid,spdate,uom,"")
}

ClassMethod RecvTypeToRowid(RECVTYPE As %String) As %String
{
                               
 s LL=""
 &sql(select incgr_rowid into :LL from inc_gdrectype where incgr_desc = :RECVTYPE)       
 q LL
}

ClassMethod MnfToRowid(mnf As %String) As %String
{

 s mnfrd=""      
 &sql(select phmnf_rowid into :mnfrd from ph_manufacturer where phmnf_name=:mnf)
 s P9=$p(mnfrd,$c(1))
 q $p(mnfrd,$c(1))
}

ClassMethod GetStkCat() As %String
{

 &sql(DECLARE SelStkCat CURSOR FOR
           Select INCSC_Desc 
           From INC_StkCat)                                 
 &sql(OPEN SelStkCat)
 s num=0
 s SQLCODE=0
 k PLIST
 f  &sql(FETCH SelStkCat INTO :StkCat) q:SQLCODE  d 
          . s num=num+1
  . s PLIST(num)=StkCat
  . s StkCat=""
 s PLIST=$o(PLIST(""),-1)
 s P2=num
 &SQL(CLOSE SelStkCat)
 q ""
}

ClassMethod GetAllMnfs() As %String
{

     &sql(declare mnfs cursor for select phmnf_name from ph_manufacturer)
     &sql(open mnfs)
     s i=1
     k PLIST
     f  &sql(fetch mnfs into :mnf) q:SQLCODE  d 
             .s PLIST=i
             .s PLIST(i)=mnf
     s PLIST=$o(PLIST(""),-1)
     &sql(close mnfs)
     q i-1
}

ClassMethod GetBachRD(code As %String, batno As %String, exp As %String) As %String
{
   
      s itmrd=..ItemCodeToID(code)
      s exp=$zdh(exp,3)
      &sql(select incib_rowid into :batchrd from inc_itmbat
           where incib_inci_parref=:itmrd and incib_no=:batno and incib_expdate=:exp)
      s batchrd=$p($g(batchrd),$c(1))
      q batchrd
}

ClassMethod GetDhcGdRetNo(prefix As %String) As %String
{
    
     s inno=""       
     s prefix=..GetBillNoStream(prefix)
    ; &sql(select MAX(ingrt_no) into :inno
     ;         from dhc_ingdret where  %ALPHAUP(ingrt_no) %STARTSWITH :prefix)
     
     i inno=""  s inno=prefix_"_01",P0=inno q P0        
     s stream=$e(inno,12,13)
     s stream=stream+1
     s inno=$e(inno,1,11)_stream
     i $l(inno)<13 d         
     .s innotail=$e(inno,12,12) 
     .s inno=$e(inno,1,11)_"0"_innotail        
     s P0=inno
     q P0
}

ClassMethod GetForm(inci As %String) As %String
{
    q $p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2)
}

ClassMethod getGeneric(inci) As %String
{
  q:inci="" ""
  s arcim=$p($g(^INCI(inci,1)),"^",3)
  q:arcim="" ""
  s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
  s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12) q:phcdf="" ""
  s phcd=+phcdf
  s gene=$p($g(^PHCD(phcd,4)),"^",1) q:gene="" ""
  s genedesc=$p($g(^PHCGE("GE",gene)),"^",2)
  q genedesc
}

ClassMethod getBarcode(inci) As %String
{
 ;取规格,2007-07-23,zdm
    q:inci="" ""
    s inci=+inci
    
    //***规格取法一
    s info=$O(^DHCITMINFO(0,"INCI",inci,"")) q:info="" ""
    s spec=$p($g(^DHCITMINFO(info)),"^",27)
    q spec
    
    //***规格取法二
    q $p($g(^INCI(inci,3)),"^",9)
}

ClassMethod getIncStk(incil) As %String
{
  ;取货位,2007-07-23,zdm
  q:incil="" ""
  s inci=+incil
  s incsbStr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
  s incsb=$p(incsbStr,":",2)
  q incsb
}

ClassMethod getOrdDoctor(oeori) As %String
{
  ;开单医生,2007-07-23,zdm
  q:oeori="" ""
  
  s docdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11) //ct_careprov
  q:docdr="" ""
  s doctor=$p(^CTPCP(docdr,1),"^",2)
  q doctor
}

ClassMethod getPoisonByInci(inci) As %String
{
  ;取管制分类,2007-8-2,zdm
  q:inci="" ""
  s arcim=$p($g(^INCI(inci,1)),"^",3)
  q:arcim="" ""
  s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
  s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12) q:phcdf="" ""
  s phcd=+phcdf
  s poisondr=$p($g(^PHCD(phcd,1)),"^",4) q:poisondr="" ""
  s desc=$p($g(^PHCPO(poisondr)),"^",2)
  s code=$p($g(^PHCPO(poisondr)),"^",1)
  q poisondr_"^"_code_"^"_desc
}

/// ;取滚医嘱标志
/// 2009-04-21
/// zhouyg
/// Input:oeori-医嘱RowID
/// Output:滚医嘱置的值 第一条医嘱rowid!!上一条医嘱Rowid
ClassMethod getOrdFillerNo(oeori As %String) As %String
{
  q:oeori="" ""
  s fillno=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),9)),"^",12)
  q fillno
}

/// Creator:Liang Qiang
/// CreatDate:2009-06-25
/// Description:根据inci获取医嘱停用日期
/// Input:Inc_itmRowid
/// Ouput:医嘱停用日期
/// Return:医嘱停用日期
/// Others:
ClassMethod GetarcEndDate(orditmRowid) As %String
{
 s ord=$p(orditmRowid,"||",1)
 s itm=$p(orditmRowid,"||",2)
 s arciim=$p(^OEORD(ord,"I",itm,1),"^",2 )
 ;s arciim=$p(^INCI(inciid,1),"^",3)  ;ARC_ItmMast医嘱项ID
 q:arciim="" ""
 s arcii=$p(arciim,"||",1)
 s arciisub=$p(arciim,"||",2)
 q:'$d(^ARCIM(arcii,arciisub,7)) "" ;2007-01-05
 s ordenddate=$p(^ARCIM(arcii,arciisub,7),"^",1) ;医嘱截止日期
 q $g(ordenddate)
}

/// Creator:Liang Qiang
/// CreatDate:2009-07-30
/// Description:根据设置冲抵功能的药品类别
/// Input:库存项Rowid
/// Output:返回值  0 ;未设置   >0 设置
ClassMethod GetCatReserve(inci) As %String
{
    s arcimid=$p(^INCI(inci,1),"^",3)                                
    s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        
    s catcode=$p(^ARC("IC",arccatid),"^",1)                       
    s cat=..GetCat(catcode)
    s packedCat=..getReservedCat()
    s ret=$f(packedCat,cat)
    q ret
}

/// Creator:Liang Qiang
/// CreatDate:2009-07-30
/// Description:获取保留药类别的设置
/// Input:
/// Output:保留药类别
ClassMethod getReservedCat()
{
 s result=""
 s rowid="0"
 f  s rowid=$o(^DHCSTDRUGGRP(rowid)) q:rowid=""  d
 .q:'$d(^DHCSTDRUGGRP(rowid))
 .s code=$p(^DHCSTDRUGGRP(rowid),"^",1)
 .s ispack=$p(^DHCSTDRUGGRP(rowid),"^",5)
 .i ispack="1" d
 ..i result="" d
 ...s result=code
 ..e  d
 ...s result=result_"^"_code 
 q result
}

/// Creator:Liang Qiang
/// CreatDate:2009-07-30
/// Description:根据库存项Code获取药类别
/// Input:库存项Code
/// Output:药类别
ClassMethod GetCat(CATCODE As %String) As %String
{
 s CATCODE=$$ALPHAUP^SSUTIL4(CATCODE)
 s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
 s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
 s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
 q dispcat
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:根据申请单号查找该单剩余未退数量：
/// Input:申请单Rowid
/// Return:剩余未退数量
ClassMethod GetReqSurplus(reqrowid) As %String
{
    s reqqty=$p(^RETRQ(reqrowid),"^",11)
    q:'$d(^PHARET(0,"REQUEST",reqrowid)) reqqty
    s phaci=$p(^RETRQ(reqrowid),"^",24)
    s sumretqty=0
    s pharrowid=""
    f  s pharrowid=$o(^PHARET(0,"REQUEST",reqrowid,pharrowid)) q:pharrowid=""  d
    .s retqty=$p(^PHARET(pharrowid),"^",12)
    .s sumretqty=sumretqty+retqty
    s surqty=reqqty-sumretqty
    q surqty
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:获取发药科室保留药标志
/// Input:科室Rowid
/// Return:保留药标志
ClassMethod ReserveRetFlag(loc) As %String
{
  q:loc="" ""
  s dhcpl=$o(^DHCPL(0,"Loc",loc,""))
  q:dhcpl="" ""
  s ResRetFlag=$p(^DHCPL(dhcpl),"^",16)
  q $g(ResRetFlag)
}

ClassMethod GetItemDateRp(code, stdate, HospID = "") As %String
{
  s itemcode=$p(code,"^",1)   ;get item code from referenced variable
  s uom=$p(code,"^",2)        ;get item uom desc from referenced variable
  i uom'="" d
  .s uom=..CTUOMToID(uom)
  .S uom=$p(uom,$c(1))
  s inciid=$p(..ItemCodeToID(itemcode),$c(1))
  s rp=..GetInciBasicRp(inciid,stdate,uom,HospID)
  q rp
}

ClassMethod GetInciBasicRp(inciid, stdate, uom, HospID = "") As %String
{
 s buom=$p(^INCI(inciid,1),"^",10)
 i uom="" s uom=buom
 s retrp=0,adjrow=""
 s excudate=stdate+1
 I HospID="" D
 .s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
 .Q:excudate=""
 .s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
 E  D
 .s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
 .Q:excudate=""
 .s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
 Q:adjrow="" 0
 s price=$p(^INASP(adjrow),"^",16)
 s adjuom=$p(^INASP(adjrow),"^",10)
 s ctuomprice=$p(^INASP(adjrow),"^",14)
 i uom=adjuom  d
 .s retrp=ctuomprice
 e  d
 .s factor=..UOMFac(uom,buom)
 .s retrp=price*factor
 s retrp=+$j(retrp,7,6)
 q retrp
}

/// Description:根据ss_user的ID找CT_Hospital的信息
/// Creator:zhouyg
/// CreatDate:2009-08-11
/// Table:ss_user,Ct_loc,Ct_Hospital
/// Input:用户ss_user表RowID
/// Return:医院ID_"^"_医院代码_"^"_医院描述
ClassMethod GetUserHosp(userid) As %String
{
 Q:userid="" ""
 Q:'$D(^SSU("SSUSR",userid)) ""
 S deflocdr=$P(^SSU("SSUSR",userid),"^",4)
 Q:deflocdr="" ""
 Q:'$D(^CTLOC(deflocdr)) ""
 S hospdr=$P(^CTLOC(deflocdr),"^",22)
 Q:hospdr="" ""
 Q:'$D(^CT("HOSP",hospdr)) ""
 S hospcode=$P(^CT("HOSP",hospdr),"^",1)
 S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
 S retstr=hospdr_"^"_hospcode_"^"_hospdesc
 Q retstr
}

ClassMethod GetLocHosp(deflocdr) As %String
{
 Q:deflocdr="" ""
 Q:'$D(^CTLOC(deflocdr)) ""
 S hospdr=$P(^CTLOC(deflocdr),"^",22)
 Q:hospdr="" ""
 Q:'$D(^CT("HOSP",hospdr)) ""
 S hospcode=$zcvt($P(^CT("HOSP",hospdr),"^",1),"U")
 S hospdesc=$P(^CT("HOSP",hospdr),"^",2)
 S retstr=hospdr_"^"_hospcode_"^"_hospdesc
 Q retstr
}

/// w ##class(web.DHCSTCOMMONSRV).GetFeePoint("3^NORM^2458||28")
ClassMethod GetFeePoint(orditmcat As %String) As %String
{
     s cat=$p(orditmcat,"^",1)
     s priority=$p(orditmcat,"^",2)
     s oeori=$p(orditmcat,"^",3)
     s DspByDocLoc=##Class(web.DHCSTKUTIL).Linked(oeori)    //zhouyg 2013-05-15
     q:DspByDocLoc=1 0
     s orditmcat=cat
     s recloc=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",6) 
     s hospid=$p($g(^CTLOC(+recloc)),"^",22)
     s config=##class(web.DHCSTInterfaceFromElse).IGetIPParamConfig(hospid, "OutPhBillCondition") // 出院带药是否按计费点计费,yunhaibao,20191127
     q:(priority="OUT")&(config'="Y") "0"
     s bc=""
     s bcID=0
     f  s bcID=$o(^DHCTarC("BC",0,orditmcat,bcID)) q:(bcID="")||(bc'="")  d
     .s bcHosp=$p(^DHCTarC("BC",bcID),"^",3)
     .q:bcHosp'=hospid
     .s bc=bcID
     q:bc="" ""
     s condition=$p(^DHCTarC("BC",bc),"^",2) ;本行正式上线时放开
     i condition="OD" q "0"  ;开医嘱计费
     i condition="CR" q "1"  ;发药计费
     q 1
}

/// 是否允许发药,此处根据住院状态和计费点设置判断
/// returnvalue : 0  - 不允许，1 - 允许
ClassMethod IfCollectDrugAllowed(adm As %String, orditmcat As %String) As %String
{
    
    s result=1
    s feepoint=..GetFeePoint(orditmcat) //0-开医嘱计费 1-发药计费
    q:(feepoint="")!(feepoint=0) result
    s status=..GetCurrentAdmStatus(adm)
    i status=0 d
    .s result=0
    q result
}

/// Creator:Zhouyg
/// CreatDate:2010-07-14
/// Description:取科室库存项加锁标志
/// Table:INC_ItmLoc,DHC_IncItmLoc
/// Input:科室rowid，库存项rowid
///        add: AdmType 如果病人类型为 I住院，则取住院加锁标致，否则取门诊加锁标致 2020-10-29 yangsj
/// Return:加锁标志：Y/N
/// w ##Class(web.DHCSTCOMMONSRV).GetIncItmLockFlag(165,3728,"")
ClassMethod GetIncItmLockFlag(locdr As %String, incid As %String, AdmType As %String = "") As %String
{
 q:locdr="" ""
 q:incid="" ""
 s lockNode=$S(AdmType="I":46,1:1)
 s chl=$o(^INCI("IL_LOC",locdr,incid,"")) 
 q:chl="" ""
 s incil=incid_"||"_chl
 s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
 q:dhcincil="" ""
 s lockflag=$p(^DHCINCIL(dhcincil),"^",lockNode)
 q lockflag
}

/// w ##class(web.DHCSTCOMMONSRV).DHCGetSttrNo("TTT")
ClassMethod DHCGetSttrNo(prefix) As %String
{
   s prefix=..GetBillNoStream(prefix)
   &sql( select max(init_no) into :inno
      from DHC_InIsTrf  where  %ALPHAUP(init_no) %STARTSWITH :prefix)
   i inno=""  s inno=prefix_"_001",P0=inno q P0
   s lno1=$l(inno)   ;length of inno
   s stream=$e(inno,lno1-2,lno1)                 
   s stream=stream+1
   //s inno=prefix_"_"_stream
   s inno=prefix_"_"_$tr($j(stream,3)," ","0")
   s lno2=$l(inno)
   i lno2<lno1 d
   .s innotail=$e(inno,$f(inno,"_"),lno2)
   .s lnoc=lno1-lno2
   .f i=1:1:lnoc d
   ..s innotail="0"_innotail
   .s inno=prefix_"_"_innotail      
   s P0=inno
   q P0
}

/// Descriprtion:判断是否医特殊科室
/// Input:phaloc -药房科室, doctorloc -医生科室
/// Output: 1:拒绝的医生科室 0:非拒绝的医生科室
/// Table:CT_LocLinkLocation
/// Creator:Liang Qiang
/// CreatDate:2008-11-03
ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 &sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
 q:'SQLCODE 1
 q 0
}

/// Description:获取医嘱发药状态,新版医嘱规则
/// Input:医嘱执行表ID
/// Output:医嘱发药状态代码
/// CreatDate:2012-02-23
/// Creator:LiangQiang
ClassMethod GetOrdDispType(OrdExeRowid As %String) As %String
{
 q:OrdExeRowid="" ""
 s ord=$p(OrdExeRowid,"||",1) q:ord="" ""
 s itm=$p(OrdExeRowid,"||",2) q:itm="" ""
 q:'$d(^OEORD(ord,"I",itm)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 q:'$d(^ARCIM(sub,ver,1)) ""
 s ordcat=$p(^ARCIM(sub,ver,1),"^",10)
 q:ordcat="" ""
 s catcode=$p(^ARC("IC",ordcat),"^",1)
 s catcode=$$ALPHAUP^SSUTIL4(catcode)
 s ordcatdr=$o(^ARC("IC",0,"Code",catcode,"")) q:ordcatdr="" ""
 s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
 s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
 q dispcat
}

/// Description:获取医嘱状态,判断是否可以配药,药房,配液通用,适用于新版医嘱规则
/// Input:医嘱执行表ID
/// Output:0 不可配  1 可配
/// CreatDate:2012-02-23
/// Creator:LiangQiang
ClassMethod GetOrdState(OrdExeRowid) As %String
{
    s Ord=$p(OrdExeRowid,"||",1)
    s Chl=$p(OrdExeRowid,"||",2)
    s Sub=$p(OrdExeRowid,"||",3)
    s ret=0
    q:Ord="" ret
    q:Chl="" ret
    q:'$d(^OEORD(Ord)) ret
    q:'$d(^OEORD(Ord,"I",Chl,"X",Sub,"BILL")) ret
    s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub,"BILL"),"^",1)  ;医嘱状态
    q:OrderStatusDr="" ret
    s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          ;医嘱核实、未核实、停止状态 
    i (OeFlag'="V")&(OeFlag'="E")  Q ret                ;执行记录的医嘱状态为停止的不发药
    s OreStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub),"^",16)  ;护士执行状态
    q:OreStatusDr="" 1      ;zdm,2012-03-02,护士执行状态为空认为可配药？
    s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
    //i (AdminStatus="D")!(AdminStatus="C") Q ret
    i AdminStatus="D" Q ret
    Q 1
}

/// Description:检查医嘱是否需要审核,药房,配液通用,适用于新版医嘱规则
/// Input:医嘱执行表ID
/// Output:0 不可发药  1 可发药
/// CreatDate:2012-02-23
/// Creator:LiangQiang
/// w ##class(web.DHCSTCOMMONSRV).IfAuditByPriority(31852)
ClassMethod IfAuditByPriority(DspId As %String) As %String
{
    q:DspId="" 0
    s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
    s Ord=$p(OrdExeRowid,"||",1)
    s Chl=$p(OrdExeRowid,"||",2)
    s Sub=$p(OrdExeRowid,"||",3)
    q:Ord="" 0
    q:Chl="" 0
    q:'$d(^OEORD(Ord)) 0
    s oeori=Ord_"||"_Chl
    S ret=1
    s recloc=$p(^DHCOEDISQTY(DspId),"^",24) //zhouyg 20150108
    s plrowid=$o(^DHCPL(0,"Loc",recloc,""))
    q:plrowid="" 0
    s priorCode=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori),"^",2)
    q:$ZCVT(priorCode,"U")["OM" ret
    s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
    //出院医嘱单独审核
    i priorCode="OUT" d
    .s HospId=$p(^CTLOC(recloc),"^",22)
    .s Params="^"_recloc_"^^"_HospId
    .//s outAuditFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","OUTAUDITFLAG",Params)
    .s outAuditFlag=$p(^DHCPL(plrowid),"^",40) // 配置修改到住院发药科室维护, 2023-03-02, yunhaibao
    .i outAuditFlag'="Y" s ret=1
    .e  i ConfirmFlag'="Y" s ret=0
    q:priorCode="OUT" ret
    s AuditNeed=$p(^DHCPL(plrowid),"^",14)
    q:(AuditNeed'="Y") ret 
    s passAudit=""
    i $d(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",recloc)) d  
    .s arcItmId=$p(^OEORD(Ord,"I",Chl,1),"^",2)
    .s arcItmCatId=$p(^ARCIM(+arcItmId,1,1),"^",10)
    .q:arcItmCatId=""
    .s plac=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",recloc,arcItmCatId,""))
    .q:plac=""
    .s passAudit=$p($g(^CF.PHA.IP.LOCARCCAT(plac)),"^",3)
    q:passAudit="Y" 1   // 不需要领药审核的子类
    ///q:..GetOrdDispType(OrdExeRowid)="ZCY" ret  //(药房),20181211,yunhaibao,应交付中心需求
    s doctorloc=$p(^OEORD(Ord,"I",Chl,7),"^",2)
    //q:..DoctorLocRefuse(recloc,doctorloc)=1 ret   //医生科室不需审核(药房)
    q:($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(oeori),1) = "BASEDISP") ret       // 住院基数药、医生科室都不需要审核 MaYuqiang 20220527
    q:ConfirmFlag'="Y" 0
    Q ret
}

/// Descript：   取护士审核的结果
/// Creater:    zhouyg
/// CreateDate: 20141220
/// Input:      DHC_OEDispensing的ID
/// Return： 审核人ID^审核日期^审核时间^审核标志(Y或"")
ClassMethod GetNurAuditStr(dhcDspId As %String) As %String
{
    s auditStr=""
    s auditUserId=$p($G(^DHCOEDISQTY(dhcDspId)),"^",12)
    s auditDate=$p($G(^DHCOEDISQTY(dhcDspId)),"^",18)
    s auditTime=$p($G(^DHCOEDISQTY(dhcDspId)),"^",19)
    s auditFlag=$p($G(^DHCOEDISQTY(dhcDspId)),"^",17)
    i auditFlag="Y" s auditStr=$G(auditUserId)_"^"_$G(auditDate)_"^"_$G(auditTime)_"^"_$G(auditFlag)
    q auditStr
}

/// 检查优先级是否合格
/// 过滤不需要发药的优先级
/// Creator:Liang Qiang
/// CreatDate:2011-03-04
/// Input:医嘱ID
/// Output: 0 - 非法  1 - 正常
ClassMethod ChkOrdPriority(oeori) As %String
{
    S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
    S pricode=$P(pri,"^",2)
    S pricode=$ZCVT(pricode,"U")
    Q:pricode["OM" 0
    Q 1
}

/// 取某发药记录的批次
/// Creator:zhangdongmei
/// CreatDate:2011-03-16
/// Input:发药子表id
/// Output:批号
ClassMethod GetDspBat(phaci) As %String
{
    q:phaci="" ""
    s batstr=""
    s pha=+phaci
    s chl=$p(phaci,"||",2)
    s phalb=""
    f  s phalb=$o(^DHCPHAC(pha,"I",chl,"B",phalb)) q:phalb=""  d
    .s inclb=$p(^DHCPHAC(pha,"I",chl,"B",phalb),"^",1)
    .s inci=+inclb
    .s incil=$p(inclb,"||",2)  ;INCIL_ChildSub
    .s inclb=$p(inclb,"||",3)  ;INCLB_ChildSub
    .s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)   ;INCIB_RowId
    .s incib=$p(incibdr,"||",2)  ;INCIB_ChildSub   
    .s batno=$p(^INCI(inci,"IB",incib),"^",1)
    .i batstr=""  d
    ..s batstr=batno
    .e  d
    ..s batstr=batstr_","_batno
    .
    q batstr
}

/// 检查某医嘱是否为取药医嘱
/// Creator:zhangdongmei
/// CreatDate:2012-03-21
/// Input:配药ID
/// Output: 0 - 不是  1 - 是
ClassMethod ChkIfONE(dodis) As %String
{
    q:dodis="" 0
    s ret=0
    s oeori=$p(^DHCOEDISQTY(dodis),"^",1) 
    S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
    S pricode=$P(pri,"^",2)
    s:(pricode="ONE")!(pricode="OUT") ret=1
    Q ret
}

/// 检查某医嘱是否为取药医嘱和出院带药
/// Creator:zhangdongmei
/// CreatDate:2012-03-21
/// Input:申请明细id
/// Output: 0 - 不是  1 - 是
ClassMethod ChkIfONEbyReq(reqitmid) As %String
{
    q:reqitmid="" 0
    s req=+reqitmid
    s chl=$p(reqitmid,"||",2)
    s dodis=$p(^RETRQ(req,"I",chl),"^",11)
    q:dodis="" 0
    s ret=0
    s oeori=$p(^DHCOEDISQTY(dodis),"^",1) 
    S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
    S pricode=$P(pri,"^",2)
    s:(pricode="ONE")!(pricode="OUT") ret=1
    Q ret
}

ClassMethod GetNotes(moeori As %String) As %String
{
    Q:moeori="" ""
    s Notes=""
    S ord=$P(moeori,"||",1) Q:ord="" ""
    S itm=$P(moeori,"||",2) Q:itm="" ""
    s rnum=""
    f  s rnum=$o(^OEORD(ord,"I",itm,"DEP",rnum)) q:rnum=""  d
    .s Notes=Notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i $G(Notes)="" s Notes=""
    ;w "Notes"_Notes
    Q Notes
}

/// 根据医嘱rowid取对应的发药类别
/// Creator:zhangdongmei
/// CreatDate:2011-03-29
/// Input:医嘱id,是否配液(是：Y),接收科室ID
/// Output:成功：发药类别id；异常：其它
/// w ##class(web.DHCSTCOMMONSRV).GetDspCatId("11||376","N","246")
ClassMethod GetDspCatId(oeori As %String, pivaflag As %String = "", RecLocID As %String = "") As %String
{
    s Ord=+oeori
    s Chl=$p(oeori,"||",2)
    q:Ord="" ""
    q:Chl="" ""
    q:'$d(^OEORD(Ord)) ""
    q:pivaflag="Y" 0
    s HospId=""
    s:RecLocID'="" HospId=$p($g(^CTLOC(RecLocID)),"^",22)
    s Param=""_"^"_RecLocID_"^"_""_"^"_$g(HospId)
    s OnlyPIVALocFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA","OnlyPIVALoc",Param)    //zhouyg 20150624 仅仅是配液中心科室
    q:OnlyPIVALocFlag="Y" 0
    s arcim=$p(^OEORD(Ord,"I",Chl,1),"^",2)
    s sub=$p(arcim,"||",1)
    s ver=$p(arcim,"||",2)
    s arcimcat=$P(^ARCIM(sub,ver,1),"^",10)
    s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
    s Priority=$p(^OECPR(PriorDr),"^",1)            ;医嘱优先级代码
    i Priority="OUT"  d
    .s SDG="OUT"                        ;需定义出院带药类别的代码为OUT
    e  d
    .q:arcimcat=""
    .s SdgId=##class(web.DHCSTCOMMONSRV).GetDispCatByArcCat(arcimcat, HospId)  
    .s:SdgId'="" SDG=$p(^DHCSTDRUGGRP(SdgId),"^",1)
    i $g(SDG)=""  d
    .s SDG="QT"         ;需定义"其它"的代码为QT              
    q SDG
}

/// 执行记录rowid
/// Creator:zhangdongmei
/// CreatDate:2011-04-11
/// Input:执行记录id
/// Output:0：未发药；1：发药;2:部分退药;3:全部退药
/// ##class(web.DHCSTCOMMONSRV).GetOreStatus(OrdExeRowid)
ClassMethod GetOreStatus(OrdExeRowid As %String) As %String
{
    s ret=0
    q:OrdExeRowid="" ""
    ;
    s retqty=0 
    s dspqty=0
    s dodis=""
    f  s dodis=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,dodis))  q:dodis=""  d
    .s type=$p(^DHCOEDISQTY(dodis),"^",13)
    .s status=$p(^DHCOEDISQTY(dodis),"^",7)
    .i (type="P")&(status="C")  d
    ..s ret=1                       ;已发药
    ..s dspqty=dspqty+$p(^DHCOEDISQTY(dodis),"^",11)
    .i (type="Y")&(status="R")  d
    ..s retqty=retqty+$p(^DHCOEDISQTY(dodis),"^",11)
    .
    q:ret'=1 0  ;未发药
    i retqty>0  d
    .i retqty<dspqty  d
    ..s ret=2       ;部分退药
    .e  d
    ..s ret=3       ;全部退药
    e  d
    .s ret=1    ;已发药
    .
    q ret
}

/// 执行记录rowid
/// Creator:zhangdongmei
/// CreatDate:2011-04-12
/// Input:执行记录id
/// Output:发药数量^退药数量
/// ##class(web.DHCSTCOMMONSRV).GetDispReturnQty(OrdExeRowid)
ClassMethod GetDispReturnQty(OrdExeRowid As %String) As %String
{
    q:OrdExeRowid="" ""
    ;
    s retqty=0 
    s dspqty=0
    s dodis=""
    f  s dodis=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,dodis))  q:dodis=""  d
    .s type=$p(^DHCOEDISQTY(dodis),"^",13)
    .s status=$p(^DHCOEDISQTY(dodis),"^",7)
    .i (type="P")&(status="C")  d
    ..s dspqty=dspqty+$p(^DHCOEDISQTY(dodis),"^",11)
    .i (type="Y")&(status="R")  d
    ..s retqty=retqty+$p(^DHCOEDISQTY(dodis),"^",11)
    .
    .
    q dspqty_"^"_retqty
}

/// liangqiang
/// 2012-08-01
/// 根据Oeori取医嘱备注
/// Input:  ordi-oe_orditem表RowID
/// Return：备注的描述
ClassMethod GetOrdItmRemark(ordi As %String) As %String
{
    s ord=$p(ordi,"||",1)
    s item=$p(ordi,"||",2)
    q:ord="" ""
    q:item="" ""
    q:'$d(^OEORD(ord,"I",item)) ""
    s (num,memo)=""
    s num="0" f  s num=$o(^OEORD(ord,"I",item,"DEP",num)) q:num=""  d
    .s memo=memo_$g(^OEORD(ord,"I",item,"DEP",num))
    q memo
}

/// liangqiang
/// 2012-08-01
/// Input:医嘱Rowid
/// Output: 皮试(+)  皮试(-) 或  皮试()  或  皮试(原液)
/// w ##class(web.DHCSTCOMMONSRV).GetSkinTestResult("1166||14")
ClassMethod GetSkinTestResult(oeori As %String) As %String
{
    Q:oeori="" -1
    S ord=$p(oeori,"||",1) Q:ord="" ""
    S itm=$p(oeori,"||",2) Q:itm="" ""
    Q:'$D(^OEORD(ord,"I",itm,5)) ""
    S SkinTestFlag=$P(^OEORD(ord,"I",itm,5),"^",2)
    ;b //                   //去掉这个断点 nisijia 2016-09-09
    I SkinTestFlag'="Y" D
    .S result=""
    E  D
    .S abnormal=$P(^OEORD(ord,"I",itm,11),"^",3)
    .S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
    .I abnormal="N"  S result=1
    .E  D
    ..S result=-6 //未结果 
    ..I actiondr=1 S result=-5 //原液
    ..i abnormal="Y" S result=-1 
    ..I actiondr=2 S result=1  //免试
    i result="" s ret=""
    i result>0 s ret="皮试( - )"
    i result<0 s ret="皮试( + )"
    i result=-6 s ret="皮试(   )"
    i result=-5 s ret="皮试(原液)"
    
    Q ret
}

/// Creator:Liang Qiang
/// CreatDate:2013-04-13
/// Description:判断该医嘱是否属于满整支发药的医嘱子类
/// Input:医嘱Rowid
/// Return:1 - 是 ,非 1 不是
ClassMethod GetWholeDispFlag(oeori) As %String
{
     q:oeori="" ""
     s ord=$p(oeori,"||",1) q:ord="" ""
     s itm=$p(oeori,"||",2) q:itm="" ""
     q:'$d(^OEORD(ord,"I",itm)) ""
     s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
     s sub=$p(arcim,"||",1)
     s ver=$p(arcim,"||",2)
     q:'$d(^ARCIM(sub,ver,1)) ""
     s ordcat=$p(^ARCIM(sub,ver,1),"^",10)
     q:ordcat="" ""
     s catcode=$p(^ARC("IC",ordcat),"^",1)
     s catcode=$$ALPHAUP^SSUTIL4(catcode)
     s ordcatdr=$o(^ARC("IC",0,"Code",catcode,"")) q:ordcatdr="" ""
     s sdgr=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:sdgr="" ""
     s sdgsub=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,sdgr,"")) q:sdgsub="" ""
     s wholeflag=$p(^DHCSTDRUGGRP(sdgr,"I",sdgsub),"^",4)
     q wholeflag
}

/// Creator:Liang Qiang
/// CreatDate:2013-04-13
/// Description:取医嘱是否自动生成退药申请
/// Input:医嘱Rowid
/// Return:1 - 是 ,非 1 不是
/// Modify: 2019-04-15,修改为根据打包表Id判断,yunhaibao
ClassMethod GetOrdAutoReqFlag(DspId) As %String
{
     q:DspId="" ""
     s dspCatCode=$p(^DHCOEDISQTY(DspId),"^",27)
     q:dspCatCode=0 ""
     s recLoc=$p(^DHCOEDISQTY(DspId),"^",24)
     s hosp=$p($g(^CTLOC(+recLoc)),"^",22)
     s dspCatCode=$$ALPHAUP^SSUTIL4(dspCatCode)
     s dspCatId=..GetDrugCatByCode(dspCatCode,hosp)
     q:dspCatId="" ""
     s recLocId=$p(^DHCOEDISQTY(DspId),"^",24)   
     s reqFlag=$p(^DHCSTDRUGGRP(dspCatId),"^",6)
     s canReq=..ChkReqFlagbyPhaCat("",dspCatId,recLocId)
     q:canReq=0 0
     q reqFlag
}

/// Descirpt:验证用户名密码是否正确
/// Return: 错误：-1，正确：用户ID
ClassMethod CheckUserPassWard(code As %String, passward As %String) As %String
{
    s acode=$$ALPHAUP^SSUTIL4(code)
    q:acode="" -1
    s ret=##Class(web.SSUser).IsValidUser(code,passward)
    q:ret="" -1
    q:ret<0 -2
    q ret
}

/// Creator:ZhangDongMei;
/// CreatDate:2009-3-27
/// Description:验证两个单位之间是否存在转换关系
/// Table:CT_ConFac
/// Input:单位from，单位to
/// Return:0,不存在；1，存在
ClassMethod CheckUomFactor(fr, to) As %String
{
 s ret=1
 i fr'=to  d
 .i '$d(^CT("CTCF",0,"UOM",fr)) d
 ..s ret=0
 .e  i '$d(^CT("CTCF",0,"UOM",fr,to)) d
 ..s ret=0 
 .e  d  
 ..s rowid=""
 ..s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 ..i rowid="" d       
 ...s ret=0
 q ret
}

ClassMethod CreateEventLog(ModelCode, Condition, Content, SecretCode) As %String
{
    s eventlogret=##class(web.DHCEventLog).EventLog(ModelCode,Condition,Content,SecretCode)
    q eventlogret
}

ClassMethod ChangeToJson(str1, str2) As %String
{
    s obj = ##class(ext.util.JsonObject).%New()
    s len=$l(str1,"^")
    f ind=1:1:len  d
    .s substr1=$p(str1,"^",ind)
    .s substr2=$p(str2,"^",ind)
    .d obj.Put(substr1,substr2)
    s jsonstr=obj.Json()
    d obj.Clear()
    q jsonstr
}

/// creator:yunhaibao
/// createdate:20160119
/// description:因调用人员密集可能会超长,此处设置每次传的记录数
/// others:因CreateEventLog,ChangeToJson均在此类中,所以本方法放一块
ClassMethod EventLogNum()
{
 q 10
}

/// creator:    zhouyg
/// createdate: 20160310
/// description:根据就诊id取病人是否当前在院状态
/// Return： 1-在院 0-不在院
ClassMethod GetCurrentAdmStatus(EpisodeID As %String) As %String
{
    s status=$p(^PAADM(EpisodeID),"^",20)
    q:status="C" 0
    i $d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed")) d
    .//新入院流程 F:护士办理出院 T:结束费用调整
    .s admstatus=##class(web.DHCSTInterfaceFromElse).GetCurrentDischargeStatus(EpisodeID)
    .i (admstatus="F")!(admstatus="T") d
    ..s result=0
    .e  d
    ..s result=1
    e  d
    .i status="D" d  ;已经做过最终结算
    ..s result=0
    .e  d
    ..s result=1
    q result
}

/// Author : MaYuqiang
/// CreateDate : 20171222
/// Description : 根据住院发药科室和发药类别判断是否可以退药申请
/// DHC_PhaLocDisType 中的 PLDP_ImPermitReqFlag (Y - 不能退药申请 , 其他 - 可以退药申请)
/// Input : PhaLocID - DHC_PhaLocation 的id , sdgr - 发药类别id , ctlocid - CT_LOC 的 RowID
/// Output : 0 - 不能退药申请 , 1 - 能退药申请
/// w ##class(web.DHCSTCOMMONSRV).ChkReqFlagbyPhaCat("",37,"234")
ClassMethod ChkReqFlagbyPhaCat(PhaLocID, sdgr, ctlocid) As %String
{
    s ret=1
    q:((+PhaLocID="0")&&(+ctlocid="0"))||(+sdgr="0") ret
    i ((+PhaLocID="0")&&(+ctlocid'="0")) d
    .s PhaLocID=$o(^DHCPL(0,"Loc",ctlocid,""))
    q:+PhaLocID="0" ret
    
    s pldpsub="0"
    f  s pldpsub=$o(^DHCPL(PhaLocID,"DIS",pldpsub)) q:((pldpsub="")||(ret'=1))  d
    .q:'$d(^DHCPL(PhaLocID,"DIS",pldpsub))
    .s pldpsdgr=$p(^DHCPL(PhaLocID,"DIS",pldpsub),"^",1)    //发药类别
    .q:pldpsdgr'=sdgr
    .s imreqflag=$p(^DHCPL(PhaLocID,"DIS",pldpsub),"^",6)   //不允许申请退药标记
    .i imreqflag="Y" d
    ..s ret="0"
    
    q ret
}

/// creator:    yunhaibao
/// createdate: 2017-08-28
/// description:根据医嘱id+库存项获取对应的医嘱数量
/// input:      医嘱id
/// output:     
/// others:     w ##class(web.DHCSTCOMMONSRV).GetDspInciQtyByOeori("666",1,3)
ClassMethod GetDspInciQtyByDsp(dspId, incId, rpRule = "")
{
    s dspQty=0
    q:'$D(^DHCOEDISQTY(dspId)) ""
    s dspBatId=""
    f  s dspBatId=$o(^DHCOEDISQTY(dspId,"I",dspBatId)) q:dspBatId=""  d
    .q:+dspBatId=0
    .s dspInci=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",5)
    .s dspInclb=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",1)
    .s dspInci=$s(dspInclb'="":+dspInclb,1:+dspInci)
    .q:dspInci=0
    .q:incId'=+dspInci
    .s dspQty=dspQty+$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",2)
    q dspQty
}

/// description: 基本转换为门诊发药单位数量
/// return:      数量^单位Id^系数
ClassMethod BQtyToOutUomQty(IncId, BQty)
{
    s bUomId=$p($g(^INCI(IncId,1)),"^",10)
    s outUomId=$p($g(^INCI(IncId,1)),"^",12)
    s boFac=..UOMFac(outUomId,bUomId)
    s outUomQty=BQty/boFac
    q outUomQty_"^"_outUomId_"^"_boFac
}

/// description: 基本转换为住院发药单位数量
/// return:      数量^单位Id^单位描述^系数
ClassMethod BQtyToInUomQty(IncId, BQty)
{
    s bUomId=$p($g(^INCI(IncId,1)),"^",10)
    s inUomId=$p($g(^INCI(IncId,1)),"^",13)
    s biFac=..UOMFac(inUomId,bUomId)
    s inUomQty=BQty/biFac
    q inUomQty_"^"_inUomId_"^"_biFac
}

/// description: 转换为指定单位的数量
/// 发药单位维护的单位$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
ClassMethod BQtyToPhaUomQty(IncId, BQty, UomId)
{
    s bUomId=$p($g(^INCI(IncId,1)),"^",10)
    s buFac=..UOMFac(UomId,bUomId)
    s uomQty=BQty/buFac
    q uomQty_"^"_UomId_"^"_buFac
}

/// Description: 是否护士已处理医嘱(接受、完成)
/// Return:      Y(已处理),R(已拒绝)
ClassMethod IfOeoriNurSee(Oeori)
{
    q:Oeori="" ""
    s seeType=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"NUR")),"^",7)
    q:(seeType="A")||(seeType="F") "Y"
    q:seeType="R" "R"
    q ""
}

/// Description: 是否护士已处理医嘱(接受、完成)
/// Return:      ^1:是否允许流程继续(N不允许)-拒绝不允许,如果住院药房科室配置设置需医嘱处理,则需要接受或完成可继续流程
///              ^2:医嘱处理状态(R\A\F\U)-U撤销处理
///              ^3:医嘱处理状态(护士拒绝、护士接受、护士完成)
/// Debug:       w ##class(web.DHCSTCOMMONSRV).GetNurseSeeType("241||23","248")
ClassMethod GetNurseSeeType(Oeori, LocId)
{
    q:Oeori="" ""
    s phaLocId=$o(^DHCPL(0,"Loc",LocId,""))
    s dealOrdFlag=$p($g(^DHCPL(+phaLocId)),"^",37)
    s seeFlag=""
    s seeType=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"NUR")),"^",7)
    i seeType="U" s seeType=""
    s seeTypeDesc=$case(seeType,"A":"护士接受","F":"护士完成","R":"护士拒绝",:"护士未处理医嘱")
    i seeType="R" s seeFlag="N"
    i (dealOrdFlag="Y")&&("AF"'[seeType) s seeFlag="N"
    //s seeFlag="Y"
    q seeFlag_"^"_seeType_"^"_seeTypeDesc
}

/// Description: 根据就诊取急诊留观与抢救室,医生科室发退药用
ClassMethod GetEMLoc(AdmId)
{
    s curWard=$p(^PAADM(+AdmId),"^",70)
    q:curWard="" ""
    q $p($g(^PAWARD(+curWard)),"^",5)
}

/// Description: 判断是否急诊留观押金的医嘱走医生科室发药
/// Return:      Y(是)
/// Debug:       w ##class(web.DHCSTCOMMONSRV).GetPayStayStatus("146||95")
ClassMethod GetPayStayStatus(Oeori)
{
    q ##class(PHA.COM.Method).IfEMOrdDispInIP(Oeori)
}

/// Description: 根据发药类别代码获取ID - 多院区
ClassMethod GetDrugCatByCode(sdgCode, hosp = "")
{
    q:sdgCode="" ""
    s finalSDG=""
    s sdgId = ""
    f  s sdgId=$o(^DHCSTDRUGGRP(0,"Code",sdgCode,sdgId)) q:sdgId=""  d
    .q:+sdgId=0
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",sdgId,hosp)="N"
    .s finalSDG=sdgId
    q finalSDG
}

/// Description: 按院区获取医嘱子类关联的发药类别  
/// CreateDate:  2023-03-17
/// w ##class(web.DHCSTCOMMONSRV).GetDispCatByArcCat(cat, hosp)  
ClassMethod GetDispCatByArcCat(arcCat, hosp)
{
  
    s dispCat = 0  
    for {  
        s dispCat = $o(^DHCSTDRUGGRP(0,"ORDCAT", arcCat, dispCat)) q:(dispCat = "")  
        continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag(##class(PHA.IP.DispCat.Save).#TableName, dispCat, hosp) = "N")  
        return dispCat  
    }  
    q ""
}

}
