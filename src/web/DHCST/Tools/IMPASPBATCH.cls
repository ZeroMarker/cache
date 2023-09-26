Import sqluser

/// Description:    统一价升级批次价时生成批次价格表数据（曲江韶关）
/// Creator:        hulihua
/// CreteDate:  2015-06-12
Class web.DHCST.Tools.IMPASPBATCH Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:补IN_AdjPriceBatch表没有记录的incib
/// Creator:    hulihua
/// CreateDate: 2015-06-12
/// Table:      
/// Input:      医院ID，用户ID
/// Output:
/// Return：    成功——完毕！
/// w ##class(web.DHCST.Tools.IMPASPBATCH).AddAPB("2","1")
ClassMethod AddAPB(HospID, userID)
{
    
 n (HospID,userID)
 s inci=""
 f  s inci=$o(^INCI(inci)) q:inci=""  d
 .q:(+inci = 0)
 .q:'$D(^INCI(inci))
 .s StkGrpInfo=..GetIncStkCatGrp(inci)
 .s ScgType=$p(StkGrpInfo,"^",3)
 .q:ScgType'="G"
 .s sub=""
 .f  s sub=$o(^INCI(inci,"IL",sub)) q:sub=""  d
 ..q:'$D(^INCI(inci,"IL",sub))
 ..s locdr=$p(^INCI(inci,"IL",sub),"^",1)
 ..q:locdr=""
 ..q:'$D(^CTLOC(locdr))
 ..s hospdr=$p(^CTLOC(locdr),"^",22)
 ..q:hospdr'=HospID
 ..s chs=""
 ..f  s chs=$o(^INCI(inci,"IL",sub,"LB",chs)) q:chs=""  d
 ...q:'$D(^INCI(inci,"IL",sub,"LB",chs))
 ...s inclb=inci_"||"_sub_"||"_chs 
 ...s curqty=##class(web.DHCSTSTKQTY).CurQtyINCLB(inclb)
 ...q:curqty=0
 ...s incib=$p(^INCI(inci,"IL",sub,"LB",chs),"^",1)
 ...s hasflag=..HasAPBRecord(hospdr,incib)
 ...q:hasflag=1
 ...s ret=..CreatByIncib(incib,HospID,userID)
 q "完毕"
}

ClassMethod HasAPBRecord(HospID, incib)
{
 n (HospID,incib)
 s dd="",findflag=0
 f  s dd=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dd)) q:((dd="")||(findflag=1))  d
 .s tt=""
 .f  s tt=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dd,tt)) q:((tt="")||(findflag=1))  d
 ..s apbdr=""
 ..f  s apbdr=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dd,tt,apbdr)) q:((apbdr="")||(findflag=1))  d
 ...q:'$D(^DHCSTINAPB(apbdr))
 ...s findflag=1
 ...
  q findflag
}

/// Description:根据新增加的批次INC_ItmBat生成批次调价记录
/// Creator:    hulihua
/// CreateDate: 2015-06-12
/// Table:      
/// Input:      INCIB-INC_ItmBat的ID,HospID-医院ID,userID-用户ID
/// Output:
/// Return：    批次调价表的ID 
ClassMethod CreatByIncib(INCIB, HospID, userID)
{
    n (INCIB,HospID,userID)
    q:INCIB="" -1
    q:HospID="" -11
    s inciID=$p(INCIB,"||",1)
    s IBSub=$p(INCIB,"||",2)
    q:(inciID="")!(IBSub="") -2
    s index=0
    //s dhcincib=$o(^DHCINCIB(0,"INCIB",INCIB,""))
    s bUomID=$p(^INCI(inciID,1),"^",10)
    s pUomID=$p(^INCI(inciID,3),"^",6)
    s inciDesc=$p(^INCI(inciID,1),"^",2)
    s fac1=##class(web.DHCSTCOMMONSRV).UOMFac(pUomID,bUomID)
    i fac1=0 d
    .s wRet = $$Warn("库存项:"_inciDesc_",单位转换系数没有维护")
    q:fac1=0 -3
    s (bRp,pRp,bSp,pSp)=""
    //i dhcincib'="" d
    //.s bRp=$p(^DHCINCIB(dhcincib),"^",3)
    //.s pRp=$p(^DHCINCIB(dhcincib),"^",4)
    //.s bSp=$p(^DHCINCIB(dhcincib),"^",5)
    //.s pSp=$p(^DHCINCIB(dhcincib),"^",6)
    //e  d
    s INGR=$o(^DHCINGR(0,"GRI_INCIB",INCIB,""),-1)
    i INGR d
    .s INGRCH=$o(^DHCINGR(0,"GRI_INCIB",INCIB,INGR,""))
    .s INGRI=INGR_"||"_INGRCH
    .s gUomID=$p(^DHCINGR(INGR,"GRI",INGRCH),"^",10)
    .s gRp=$p(^DHCINGR(INGR,"GRI",INGRCH),"^",30)
    .s gSp=$p(^DHCINGR(INGR,"GRI",INGRCH),"^",32)
    .s fac2=##class(web.DHCSTCOMMONSRV).UOMFac(gUomID,bUomID)
    .i fac2=0 d
    ..s wRet = $$Warn("入库记录:"_INGRI_",单位转换系数没有维护,"_inciDesc)
    .q:fac2=0
    .s bRp=gRp/fac2
    .s bSp=gSp/fac2
    .s pRp=bRp*fac1
    .s pSp=bSp*fac1
    q:(bRp="")!(pRp="")!(bSp="")!(pSp="") -4
    s aspStr=HospID_"^"_INCIB_"^"_pUomID_"^"_pRp_"^"_pSp_"^"_userID_"^"_""_"^"_""
    s RetCode=..SaveExeAPB(aspStr)
    s aspbID = RetCode
    i RetCode'>0 d
    .s wRet = $$Warn("保存批次调价错误:"_aspStr)
    // 执行接口
    if ($d(^oddDEF("PHA.IN.ASPB.Face","m","HandleStatus"))){
        s statusRet = ##class(PHA.IN.ASPB.Face).HandleStatus(aspbID, "SAVE", 1, "Save")
        if (+statusRet < 0) {
            s wRet = $$Warn(statusRet)
            q -66
        }
        s statusRet = ##class(PHA.IN.ASPB.Face).HandleStatus(aspbID, "AUDIT", 1, "Save")
        if (+statusRet < 0) {
            s wRet = $$Warn(statusRet)
            q -67
        }
        s statusRet = ##class(PHA.IN.ASPB.Face).HandleStatus(aspbID, "EXE", 1, "Save")
        if (+statusRet < 0) {
            s wRet = $$Warn(statusRet)
            q -67
        }
    }
    q RetCode
Warn(info)
    s index=$o(^DHCSTERROR($zd(+$h,3),"DHCSTADJPRICE",""),-1)+1
    s ^DHCSTERROR($zd(+$h,3),"DHCSTADJPRICE",index)=info
    w ^DHCSTERROR($zd(+$h,3),"DHCSTADJPRICE",index),!
    q $$$OK
}

/// Description:新增一个有效的批次进价(入库时使用)
/// Creator:    hulihua
/// CreateDate: 2015-06-12
/// Table:      
/// Input:      APStr-调价相关信息字符串
/// Output:
/// Return：    批次调价表的ID 
ClassMethod SaveExeAPB(APStr)
{
    n (APStr,PLIST)
    k PLIST
    s APBID=""
    s INCIB=$p(APStr,"^",2)
    s auomID=$p(APStr,"^",3)
    s HospID=$p(APStr,"^",1)
    s AppName=##class(web.DHCST.INAdjPriceBatch).%GetParameter("AppName")
    s AdjBatNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"","")
    s ResultRpUom=+$p(APStr,"^",4)
    s ResultSpUom=+$p(APStr,"^",5)
    s INCI=$p(INCIB,"||",1)
    s buomID=$p(^INCI(INCI,1),"^",10)
    s fac=##class(web.DHCSTCOMMONSRV).UOMFac(auomID,buomID)
    s ResultRp=ResultRpUom/fac
    s ResultSp=ResultSpUom/fac
    //
    s PriceStr=##class(web.DHCSTPRICE).GetPriceByIncib(INCIB,+$h,buomID,HospID,"")
    s PriorRp=+$p(PriceStr,"^",4)
    s PriorSp=+$p(PriceStr,"^",5)
    s PriceStr=##class(web.DHCSTPRICE).GetPriceByIncib(INCIB,+$h,auomID,HospID,"")
    s PriorRpUom=+$p(PriceStr,"^",4)
    s PriorSpUom=+$p(PriceStr,"^",5)
    //
    s PLIST(1)=APBID                //批次调价ID
    s PLIST(2)=$p(APStr,"^",1)      //医院ID
    s PLIST(3)=AdjBatNo             //单号
    s PLIST(4)="Y"                  //状态
    s PLIST(5)=$p(APStr,"^",2)      //incib
    s PLIST(6)=auomID               //调价单位ID
    s PLIST(7)=PriorRpUom           //调前进价
    s PLIST(8)=+ResultRpUom     //调后进价
    s PLIST(9)=PriorSpUom           //调前售价
    s PLIST(10)=+ResultSpUom        //调后售价  
    s PLIST(11)=PriorRp                 //调前进价(基)
    s PLIST(12)=ResultRp                    //调后进价(基)
    s PLIST(13)=PriorSp                 //调前售价(基)
    s PLIST(14)=ResultSp                    //调后售价(基)
    s PLIST(15)=$p($h,",",1)            //计划生效日期
    s PLIST(16)=$p($h,",",2)            //计划生效时间    
    s PLIST(17)=$p($h,",",1)            //实际生效日期
    s PLIST(18)=$p($h,",",2)            //实际生效时间
    s PLIST(19)=$p(APStr,"^",6)     //制单人
    s PLIST(20)=$p($h,",",1)
    s PLIST(21)=$p($h,",",2)
    s PLIST(22)=$p(APStr,"^",6)     //审核人
    s PLIST(23)=$p($h,",",1)
    s PLIST(24)=$p($h,",",2)
    s PLIST(25)=$p(APStr,"^",6)     //启动生效操作人
    s PLIST(26)=$p($h,",",1)                            
    s PLIST(27)=$p($h,",",2)
    s PLIST(28)=$p(APStr,"^",7)         //调价批准文号
    s PLIST(29)=$p(APStr,"^",8)         //批文日期
    s PLIST(30)=""                          //调价原因
    s PLIST(31)=""
    s PLIST(32)="入库生成"                  //备注
    s RetCode=..Insert()
    s RetID=$p($g(%ROWID),$c(1))
    q RetID
}

/// Description:IN_AdjPriceBatch表的数据处理
/// Creator:    hulihua
/// CreateDate: 2015-06-12
/// Table:      
/// Input:      
/// Output:
/// Return：    0-插入成功，<0-失败！
ClassMethod Insert()
{
 &sql(Insert Into IN_AdjPriceBatch Values :PLIST())
 i SQLCODE'=0 d
 .TRO
 .s lenp=+$o(PLIST(""),-1)
 .s splist=""
 .f ii=1:1:lenp d
 ..i splist="" d
 ...s splist=$g(PLIST(ii))
 ..e  d
 ...s splist=splist_"^"_$g(PLIST(ii))
 .s ret=$$ErrorRecord^DHCSTERROR("Insert^DHCSTMVBADJPRICE",splist,SQLCODE_$g(%msg))
 q SQLCODE
}

/// Creator:    zhouyonggang
/// CreatDate:  2011-03-16
/// Description:获得库存项的类组信息
/// Table:      INC_Itm，DHC_StkCatGrpRelations
/// Input:      库存项ID
/// Return:     类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci) As %Library.String
{
    n (inci)
    Q:inci="" ""
    Q:'$d(^INCI(inci,2)) ""
    s inccat=$p(^INCI(inci,2),"^",2)
    q:inccat="" ""
    s scg=$o(^DHCSCG("STKCAT",inccat,""))
    q:scg="" ""
    s scgdesc=$p(^DHCSCG(scg),"^",2)
    s scgcode=$p(^DHCSCG(scg),"^",1)
    s scgtype=$p(^DHCSCG(scg),"^",3)
    S scgtypeDesc=""
    S scgtypeDesc=..stktypeDesc(scgtype)
    q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc_"^"_scg
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String
{
 n (scgtype)
 I scgtype="G" q "Drug"
 I scgtype="M" q "Material"
 q "Other"
}

}
