Import sqluser

/// Descript:药品信息等Store的取法
/// 在dhcst.drugutil.csp,dhcst.phaorderwindow.csp中调用
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-07
Class web.DHCST.Util.DrugUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:   取符合条件的库存项信息
/// Creater:    zhangyong
/// CreateDate: 2010-11-04
/// Input:      input-库存项别名,StkGrpRowId-类组RowId,StkGrpType-类组类型,Locdr-Ctloc_rowid,NotUseFlag("N"或"Y"),QtyFlag("1"则只显示正库存),HospID,Start,Limit 
/// Output:     Return
/// Return：
/// Modify by:zdm,2012-02-04,优化查询速度,不用表连接
/// w ##class(web.DHCST.Util.DrugUtil).GetPhaOrderItemInfo("wss","3","G","","N","0","2","0","15",13609,"","")
ClassMethod GetPhaOrderItemInfo(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Start, Limit, User, ReqLocDr = "", AllCatGrpFlag = "") As %Library.String
{
    n (Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Start, Limit,User,ReqLocDr,AllCatGrpFlag,%session)
    q:Input="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:StkGrpType="" ##class(web.DHCSTEXTCOMMON).GetNoJson()   ;类组类型不能为空
    ;
    s json = ##class(Code.JsonObj).%New()
    s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
    s count=0 
    s resultString = ""
    s end = Start+Limit
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = ""
    ;类组代码
    IF StkGrpRowId'="" 
    {
        s sqlStr ="select distinct inca_inci_dr from inc_alias " _
            "where %ALPHAUP(inca_text) like '"_Input_"' and inca_inci_dr->inci_incsc_dr in "_ 
             "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref='"_StkGrpRowId_"')"
    }
    ELSE  
    {
        ;类组类型
        s sqlStr ="select distinct inca_inci_dr from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_Input_"' and inca_inci_dr->inci_incsc_dr in "_ 
       "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
   	   // s UserCatGrpStr=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(User,StkGrpType)
   	    s UserCatGrpStr=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,StkGrpType)
   	    
  	 } 
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    While(result.Next())
    {   
        s TInci = result.Data("INCA_INCI_DR")
        CONTINUE:'$D(^INCI(TInci))
        i BDPHospAut="Y"
        {
			continue:(HospID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",TInci,HospID)="N")
	        //continue:(HospID'="")&&('$d(^ITMADDHOP(0,"HospInc",HospID,TInci))) //医院级别授权
	    }
        ;科室
        I Locdr'="" 
        {
            CONTINUE:'$D(^INCI("IL_LOC",Locdr,TInci))
        }
        ;b ;1
        ;是否使用
        I NotUseFlag'="" 
        {
            CONTINUE:NotUseFlag'=$P(^INCI(TInci,2),"^",9)
        }
        I (StkGrpRowId="")&&(AllCatGrpFlag'="Y")
    	{
	    	s inccat=$p(^INCI(TInci,2),"^",2)
			CONTINUE:inccat=""
			s scg=$o(^DHCSCG("STKCAT",inccat,""))
	    	CONTINUE:("^"_$G(UserCatGrpStr)_"^")'[("^"_scg_"^")
	    }
	     
        ;b ;2
        ;取当前库存量
        s stkQty = 0
        if Locdr '= "" d
        .s stkQty=##Class(web.DHCST.Common.DrugStkCommon).IL(TInci,Locdr,+$h)
        CONTINUE:(QtyFlag="1")&(stkQty'>0)
        s count = count+1
        S InciDr= TInci
        S InciItem=$P(^INCI(InciDr,1),"^",3)                //编号
        S InciCode=$P(^INCI(InciDr,1),"^",1)                //代码
        S InciDesc=$P(^INCI(InciDr,1),"^",2)                //名称
        s InciDesc=##class(web.DHCSTEXTCOMMON).GetValue(InciDesc)
        S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciDr)      //规格
        S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(InciDr)      //厂家
        S Manfdr=$P(ManfStr,"^",1)                                  //厂家ID
        S ManfCode=$P(ManfStr,"^",2)                                    //厂家代码
        S ManfName=$P(ManfStr,"^",3)                                    //厂家名称
        S PuomDr=$P(^INCI(InciDr,3),"^",6)                                  //入库单位ID
        s PuomDesc=""
        CONTINUE:'$d(^CT("UOM",PuomDr))
        S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)                                   //入库单位描述
        //S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,PuomDr,HospID,StkGrpType)            //入库单位进价
        //S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID,StkGrpType)  //入库单位售价
        S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,PuomDr,HospID,StkGrpType,"")            //入库单位进价
        S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID,StkGrpType,"")  //入库单位售价
        S BuomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(InciDr)                   //基本单位串
        S BuomDr=$P(BuomStr,"^",1)                                  //基本单位ID
        S BuomDesc=$P(BuomStr,"^",2)                                    //基本单位描述
        //S bRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BuomDr,HospID,StkGrpType)            //基本单位进价
        //S bSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID,StkGrpType)  //基本单位售价
        S bRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,BuomDr,HospID,StkGrpType,"")            //基本单位进价
        S bSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID,StkGrpType,"")  //基本单位售价
        S BillUomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetArcBuomByInc(InciDr)           //计价单位串
        S BillUomDr=$P(BillUomStr,"^",1)                                //计价单位ID
        S BillUomDesc=$P(BillUomStr,"^",2)                          //计价单位描述
        //S BillRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BillUomDr,HospID,StkGrpType)      //计价单位进价
        //S BillSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID,StkGrpType)    //计价单位售价
        S BillRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,BillUomDr,HospID,StkGrpType,"")      //计价单位进价
        S BillSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID,StkGrpType,"")    //计价单位售价
        S PhcFormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)                   //剂型串
        S PhcFormCode=$P(PhcFormStr,"^",1)                          //剂型代码
        S PhcFormDesc=$P(PhcFormStr,"^",2)                          //剂型描述
        S GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(InciDr)                 //商品名
        S GeneStr=##Class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(InciDr)                      //通用名
        //S GeneCode=$P(GeneStr,"^",1)                                    //通用名代码
        S GeneName=$P(GeneStr,"^",2)                                    //通用名描述
        S BuomQty = 0
        if Locdr '= "" d
        .S BuomQty=##Class(web.DHCST.Common.DrugStkCommon).IL(InciDr,Locdr,+$H)                 //基本单位数量
        S PFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        S PuomQty=0
        I PFac'=0 S PuomQty=BuomQty/PFac                                //入库单位数量
        S BillFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        S BillUomQty=0
        I BillFac'="" S BillUomQty=BuomQty/BillFac                  //计价单位数量
        S NotUse=$P(^INCI(InciDr,2),"^",9)                      //是否使用  
        i NotUse="Y"  d
        .s NotUse=1
        e  d
        .s NotUse=0
        s HVFlag=##class(web.DHCST.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
        i ReqLocDr'="" s ReqStockQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(InciDr,ReqLocDr,PuomDr,"")
        e  s ReqStockQty=""
        s StkBin=""
        i Locdr'="" d
        .s InciCh=$o(^INCI("IL_LOC",Locdr,InciDr,""),-1)
        .q:InciCh=""
        .s IncilRowId=InciDr_"||"_InciCh
        .s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(IncilRowId,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
   		.s stkchkflag=$p(stkbinret,":",1)
   		.s stkbinstr=$p(stkbinret,":",2)
    	.s StkBin=stkbinstr
    	d ##Class(PHA.COM.Number).FormatPriceAndAmt(HospID,InciDr,PuomDr,.pRp,.pSp)
    	d ##Class(PHA.COM.Number).FormatPriceAndAmt(HospID,InciDr,BuomDr,.bRp,.bSp)
    	d ##Class(PHA.COM.Number).FormatPriceAndAmt(HospID,InciDr,PuomDr,.BillRp,.BillSp)
    	s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(InciDr, HospID)
    	s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(InciDr, HospID)
        s tmp=InciDr_"^"_InciItem_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_ManfName_"^"_PuomDr_"^"_PuomDesc_"^"_pRp_"^"_pSp_"^"_PuomQty_"^"_BuomDr_"^"_BuomDesc_"^"_bRp_"^"_bSp_"^"_BuomQty_"^"_BillUomDesc_"^"_BillRp_"^"_BillSp_"^"_BillUomQty_"^"_PhcFormDesc_"^"_GoodName_"^"_GeneName_"^"_NotUse_"^"_PuomDr_"^"_PFac_"^"_HVFlag_"^"_ReqStockQty_"^"_StkBin_"^"_InsuCode_"^"_InsuDesc
        s tmp=##class(web.DHCST.Common.JsonObj).GetData(tmp)
		i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    if count>0 d
   .s resultString = json.getJsonData("InciDr^InciItem^InciCode^InciDesc^Spec^ManfName^PuomDr^PuomDesc^pRp^pSp^PuomQty^BuomDr^BuomDesc^bRp^bSp^BuomQty^BillUomDesc^BillRp^BillSp^BillUomQty^PhcFormDesc^GoodName^GeneName^NotUseFlag^PuomDr^PFac^HVFlag^ReqStockQty^StkBin^InsuCode^InsuDesc",count)
    k json
    q resultString
}

/// Descript:   取符合条件的所有库存项信息
/// Creater:    zhangyong
/// CreateDate: 2010-11-04
/// Input:      input-库存项别名,StkGrpRowId-类组RowId,StkGrpType-类组类型,NotUseFlag("N"或"Y"),HospID,Start,Limit 
/// Output:     Return
/// Return：
/// Modify by:zdm,2012-02-04,优化查询速度,不用表连接
/// w ##class(web.DHCST.Util.DrugUtil).GetPhaOrderItemInfoAll("123",1,"G","N","",0,"15")  
ClassMethod GetPhaOrderItemInfoAll(Input, StkGrpRowId, StkGrpType, NotUseFlag, HospID, Start, Limit, User) As %Library.String
{
    n (Input, StkGrpRowId, StkGrpType,NotUseFlag, HospID, Start, Limit,User)
    //s ^ZXXTMP(2)=Input_","_StkGrpRowId_","_StkGrpType_","_NotUseFlag_","_HospID_","_Start_","_Limit_","_User
    q:Input="" ""
    q:StkGrpType="" ""   ;类组类型不能为空
    ;
    s json = ##class(Code.JsonObj).%New()
    s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
    s count=0
    s resultString = ""
    s end = Start+Limit
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = ""
    ;类组代码
    IF StkGrpRowId'="" 
    {
        s sqlStr ="select distinct inca_inci_dr from inc_alias " _
            "where %ALPHAUP(inca_text) like '"_Input_"' and inca_inci_dr->inci_incsc_dr in "_ 
             "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref='"_StkGrpRowId_"')"
    }
    ELSE  
    {
        ;类组类型
        s sqlStr ="select distinct inca_inci_dr from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_Input_"' and inca_inci_dr->inci_incsc_dr in "_ 
       "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
   	    s UserCatGrpStr=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(User,StkGrpType)
  	 } 
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    While(result.Next())
    {   
        s TInci = result.Data("INCA_INCI_DR")
        CONTINUE:'$D(^INCI(TInci))
        i BDPHospAut="Y"
        {
			continue:(HospID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",TInci,HospID)="N")    
	    	//continue:'$d(^ITMADDHOP(0,"HospInc",HospID,TInci)) //医院级别授权
		}
        ;是否使用
        I NotUseFlag'="" 
        {
            CONTINUE:NotUseFlag'=$P(^INCI(TInci,2),"^",9)
        }
        
        I StkGrpRowId=""
    	{
	    	s inccat=$p(^INCI(TInci,2),"^",2)
			CONTINUE:inccat=""
			s scg=$o(^DHCSCG("STKCAT",inccat,""))
	    	CONTINUE:("^"_$G(UserCatGrpStr)_"^")'[("^"_scg_"^")
	    }
        
        ;b ;2

        s count = count+1
        ;b ;3
        S InciDr= TInci
        S InciItem=$P(^INCI(InciDr,1),"^",3)                //编号
        S InciCode=$P(^INCI(InciDr,1),"^",1)                //代码
        S InciDesc=$P(^INCI(InciDr,1),"^",2)                //名称
        S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciDr)      //规格
        S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(InciDr)      //厂家
        S Manfdr=$P(ManfStr,"^",1)                                  //厂家ID
        S ManfCode=$P(ManfStr,"^",2)                                    //厂家代码
        S ManfName=$P(ManfStr,"^",3)                                    //厂家名称
        S PuomDr=$P(^INCI(InciDr,3),"^",6)                                  //入库单位ID
        s PuomDesc=""
        S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)                                   //入库单位描述
        S BuomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(InciDr)                   //基本单位串
        S BuomDr=$P(BuomStr,"^",1)                                  //基本单位ID
        S BuomDesc=$P(BuomStr,"^",2)                                    //基本单位描述
        S BillUomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetArcBuomByInc(InciDr)           //计价单位串
        S BillUomDr=$P(BillUomStr,"^",1)                                //计价单位ID
        S BillUomDesc=$P(BillUomStr,"^",2)                          //计价单位描述
        S PhcFormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)                   //剂型串
        S PhcFormCode=$P(PhcFormStr,"^",1)                          //剂型代码
        S PhcFormDesc=$P(PhcFormStr,"^",2)                          //剂型描述
        S GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(InciDr)                 //商品名
        S GeneStr=##Class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(InciDr)                      //通用名
        //S GeneCode=$P(GeneStr,"^",1)                                    //通用名代码
        S GeneName=$P(GeneStr,"^",2)                                    //通用名描述
        S PFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        S BillFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        
        S NotUse=$P(^INCI(InciDr,2),"^",9)                      //是否使用  
        i NotUse="Y"  d
        .s NotUse=1
        e  d
        .s NotUse=0
        s HVFlag=##class(web.DHCST.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
        s tmp=InciDr_"^"_InciItem_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_ManfName_"^"_PuomDr_"^"_PuomDesc_"^"_BuomDr_"^"_BuomDesc_"^"_BillUomDesc_"^"_PhcFormDesc_"^"_GoodName_"^"_GeneName_"^"_NotUse_"^"_PuomDr_"^"_PFac_"^"_HVFlag
        
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    if count>0 d
   .s resultString = json.getJsonData("InciDr^InciItem^InciCode^InciDesc^Spec^ManfName^PuomDr^PuomDesc^BuomDr^BuomDesc^BillUomDesc^PhcFormDesc^GoodName^GeneName^NotUseFlag^PuomDr^PFac^HVFlag",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-11-14
/// description: 单位ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetCTUom(CTUomDesc, Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select CTUOM_RowID AS RowId, CTUOM_DESC AS Description from CT_UOM where CTUOM_DESC like '%"_CTUomDesc_"%' order by CTUOM_RowID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:wyx
/// date:2013-11-28
/// description:批号效期ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetBatExDate(ItmRowid, LocId, Desc, Start, Limit)
{
    s endpage=Start+Limit  //结束行
    s stpage=Start+1 //开始行
    s h=0
    s pid=..NewPid()
    Set $ZT="ERRORGetBatExDate"
    s locincch=""
    f  s locincch=$o(^INCI("IL_LOC",LocId,ItmRowid,locincch)) q:locincch=""  d
    .s locincsub="0"
    .f  s locincsub=$o(^INCI(ItmRowid,"IL",locincch,"LB",locincsub)) q:locincsub=""  d
    ..s incibatdr=$p(^INCI(ItmRowid,"IL",locincch,"LB", locincsub),"^",1)
    ..s BatNo=$p(^INCI(+incibatdr,"IB",$p(incibatdr,"||",2)),"^",1) 
    ..s ExpDate=$p(^INCI(+incibatdr,"IB",$p(incibatdr,"||",2)),"^",2)
    ..i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    ..s rowid=ItmRowid_"||"_locincch_"||"_locincsub
    ..s data=rowid_"^"_BatNo_"~"_ExpDate
    ..s h=h+1
    ..s index="Sort^"_ItmRowid_"^"_h  //排序
    ..s ^TMP("DHCST","DrugUtil","GetBatExDate",pid,"index",index)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    
    f  s h=$o(^TMP("DHCST","DrugUtil","GetBatExDate",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","DrugUtil","GetBatExDate",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s batExp=$p(data,"^",2)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s RowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RowId",rowid)
    .s Description=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Description",batExp)
    .s tmpstr=RowId_Description
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    k ^TMP("DHCST","DrugUtil","GetBatExDate",pid)
    q ""
    
ERRORGetBatExDate
    //遇报错,则先kill TMP
    Set Method= "##class(web.DHCST.INCItmLoc).GetBatExDate"
	Set ErrorMsg=Method_"("_$LTS($LB(ItmRowid, LocId, Desc, Start, Limit))_")"_","_$ZE
	k ^TMP("DHCST","DrugUtil","GetBatExDate",pid) 
    q ""
}

/// creator:zhangdongmei
/// date:2012-01-13
/// description: 取和已知单位存在转换关系的单位
/// input: 已知单位id, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetConUom(UomId, Start, Limit) As %String
{
    q:UomId="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    ;
    s FrUomId=0
    f  s FrUomId=$o(^CT("CTCF",0,"UOM",FrUomId)) q:FrUomId=""  d
    .q:'$d(^CT("CTCF",0,"UOM",FrUomId,UomId))
    .q:'$d(^CT("UOM",FrUomId))
    .s UomDesc=$p(^CT("UOM",FrUomId),"^",2)
    .s Data=FrUomId_"^"_UomDesc
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)
    .
    i '$d(^CT("CTCF",0,"UOM",UomId,UomId)) d   //自身不存在转换时,把该单位自身加到结果集中
    .s Data=UomId_"^"_$p($G(^CT("UOM",UomId)),"^",2)
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)

    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description: 单位ComboBox
/// input:  库存项rowid
/// output: String "RowId^Description"
/// others:
ClassMethod GetItmUom(ItmRowid)
{
   
    q:ItmRowid="" ""
    q:'$d(^INCI(ItmRowid)) ""
    s BUomId=$p(^INCI(ItmRowid,1),"^",10)
    s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
    s PurUomId=$p(^INCI(ItmRowid,3),"^",6)
    s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
    ;
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s tmp=BUomId_"^"_$g(BUomDesc)
    d json.InsertRowData(tmp)
    i PurUomId'=BUomId  d
    .s tmp=PurUomId_"^"_$g(PurUomDesc)
    .d json.InsertRowData(tmp)
    .s count = 2
    e  d
    .s count=1
    ;
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-12-13
/// description: 科室能访问的类组ComboBox
/// input:  类组类型(G,M),科室id,人员id
/// output: String "RowId^Description"
/// others:  w ##class(web.DHCST.Util.DrugUtil).GetLocStkCatGroup("G","257","10213")
ClassMethod GetLocStkCatGroup(Type As %String, LocId As %String, UserId As %String)
{
    n (Type,LocId,UserId)
    s count = 0
    q:Type="" ""
    q:LocId="" ""
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s Slcg=0
    f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,Type,Slcg)) q:Slcg=""  d
    .s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    .s Default=$p(^DHCSLCG(Slcg),"^",4)
    .s chl=""
    .i UserId'=""  d
    ..s chl=$o(^DHCSLCG(0,"USER",UserId,Slcg,0))
    .s activeUseFlag=0,AllChl=""  //如果该类组下没有维护人员，则此类组所有人员都有权限 2020-02-21 yangsj
    .f  s AllChl=$o(^DHCSLCG(Slcg,"I",AllChl)) q:AllChl=""  d
    ..s tmpActive=$P(^DHCSLCG(Slcg,"I",AllChl),"^",2)
    ..i tmpActive="Y" s activeUseFlag=1
    .
    .q:(UserId'="")&(chl="")&(activeUseFlag=1)    ;检索某人员限定下的类组  //
    .s active=""
    .i chl'=""  d
    ..s Default=$p(^DHCSLCG(Slcg,"I",chl),"^",3)
    ..s active=$p(^DHCSLCG(Slcg,"I",chl),"^",2)
    .q:active="N"
    .s StkCatGrpDesc=$p($g(^DHCSCG(StkCatGrp)),"^",2)
	.q:StkCatGrpDesc=""
    .s tmp=StkCatGrp_"^"_StkCatGrpDesc_"^"_Default
    .s count = count+1
    .d json.InsertRowData(tmp)
    .
    i count=0 d
    .s Slcg=0
    .f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,Type,Slcg)) q:Slcg=""  d
    ..q:'$d(^DHCSLCG(Slcg))
	..s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    ..s Default=$p(^DHCSLCG(Slcg),"^",4)
    ..q:'$d(^DHCSCG(StkCatGrp))
    ..s StkCatGrpDesc=$p(^DHCSCG(StkCatGrp),"^",2)
    ..s tmp=StkCatGrp_"^"_StkCatGrpDesc_"^"_Default
    ..s count = count+1
    ..d json.InsertRowData(tmp)
    .
    ;
    s resultString = json.getJsonData("RowId^Description^Default",count)
    k json
    Q resultString
}

/// creator:wyx 
/// date:2012-12-13
/// description: 科室能访问的类组ComboBox
/// input:  类组类型(G,M),科室id,人员id
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.DrugUtil).GetGrantStkGrp(142,102,590)
/// w ##class(web.DHCST.Util.DrugUtil).GetGrantStkGrp(142,320,6423)
/// yunhaibao20161206当不按人员维护时,返回科室类组串
ClassMethod GetGrantStkGrp(GroupId As %String, LocId As %String, UserId As %String)
{
    n (GroupId,LocId,UserId)
    //s ^tmpdhy("GetGrantStkGrp")=GroupId_","_LocId_","_UserId
    s count = 0
    s Type="G"
    q:LocId="" ""
    s stkgrpstr=""
    s Slcg=0
    f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,Type,Slcg)) q:Slcg=""  d
	.q:'$d(^DHCSLCG(Slcg))
    .s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    .s Default=$p(^DHCSLCG(Slcg),"^",4)
    .s chl=""  ;检索某人员限定下的类组
    .i $d(^DHCSLCG(0,"USER")) d
    ..i UserId'=""  d
    ...f  s chl=$o(^DHCSLCG(0,"USER",UserId,Slcg,chl)) q:chl=""  d
    ....s active=$p(^DHCSLCG(Slcg,"I",chl),"^",2)
    ....q:active="N"
    ..s StkCatGrpDesc=$p(^DHCSCG(StkCatGrp),"^",2)
    ..i stkgrpstr=""  s stkgrpstr=StkCatGrp
    ..e  s stkgrpstr=stkgrpstr_"^"_StkCatGrp
    .e  d
    ..s StkCatGrpDesc=$p(^DHCSCG(StkCatGrp),"^",2)
    ..i stkgrpstr="" s stkgrpstr=StkCatGrp
    ..e  s stkgrpstr=stkgrpstr_"^"_StkCatGrp
    .
    q stkgrpstr
}

/// creator:zhangyong
/// date:2011-10-18
/// description: 药品类组ComboBox
/// input:  Start(起始数值)  Limit(增长数值),类组类型(G,M)
/// output: String "RowId^Description"
/// others:
/// Modify:zdm,2012-04-10,增加参数：Type
ClassMethod GetStkCatGroup(Start, Limit, Type, HospId = "")
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SCG_ROWID AS RowId, SCG_DESC AS Description FROM DHC_StkCatGroup WHERE SCG_Type ='"_Type_"' ORDER BY SCG_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkCatGroup",Rowid,HospId) //医院级别授权
    continue:flag="N"
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-10-23
/// description: 库存类组ComboBox
/// input:  stktype  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetINCSCStkGrp(stktype, Start, Limit, Hosp = "")
{
 n (stktype, Start, Limit,Hosp)
 s num=0
 s incsc=0
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 f  s incsc=$o(^INC("SC",incsc)) q:+incsc'>0  d 
 .q:'$d(^DHCSCG("STKCAT",incsc))
 .s scg=$o(^DHCSCG("STKCAT",incsc,"")) 
 .q:scg=""
 .s tmpstktype=$p(^DHCSCG(scg),"^",3)
 .q:tmpstktype'=stktype
 .q:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",incsc,Hosp)="N")
 .s incsccode=$p(^INC("SC",incsc),"^",1)
 .s incscdesc=$p(^INC("SC",incsc),"^",2)
 .s num=num+1
 .s tmp=incsc_"^"_incscdesc
 .i (num>Start)&(num<=end) d
 ..d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",num)
 k json
 Q resultString
}

/// creator:zhangyong
/// date:2011-10-23
/// description: 取得出入库的操作类别
/// input:  type(入库出库类型：I,O)
/// output: String "RowId^Description"
/// others:
ClassMethod GetOperateType(type)
{
 s i=0 
 s json = ##class(Code.JsonObj).%New()
 s resultString = ""
 s id=0
 f  s id=$o(^DHCOPTYPE(0,"TYPE",type,id)) q:+id'>0  d
 .s code=$p(^DHCOPTYPE(id),"^",1)
 .s desc=$p(^DHCOPTYPE(id),"^",2)
 .s i=i+1
 .s tmp=id_"^"_desc
 .d json.InsertRowData(tmp)
 s resultString = json.getJsonData("RowId^Description",i)
 k json
 q resultString
}

/// creator:zhangdongmei
/// date:2011-12-15
/// description: 库存分类ComboBox
/// input:  StkGrpId  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.DrugUtil).GetStkCat(3,0,20)
ClassMethod GetStkCat(StkGrpId, Start, Limit) As %String
{
	
    q:StkGrpId="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    s HospId=""
    i $D(%session) s HospId=%session.Data("LOGON.HOSPID")
    s Chl=0
    f  s Chl=$o(^DHCSCG(StkGrpId,"RE",Chl)) q:Chl=""  d
    .s StkCatId=$p(^DHCSCG(StkGrpId,"RE",Chl),"^",1)
    .q:'$d(^INC("SC",StkCatId))
    .s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    .s Data=StkCatId_"^"_StkCatDesc
    .q:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",StkCatId,HospId)="N")
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)
    .
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-04-28
/// description: 库存分类ComboBox by Grant
/// input:  StkGrpId  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.DrugUtil).GetStkCatByGrant(1,0,20)
ClassMethod GetStkCatByGrant(StkGrpIdStr, Start, Limit, HospId = "") As %String
{
    q:StkGrpIdStr="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    s len=$l(StkGrpIdStr,"^")
    s Chl=0
    f cnt=1:1:len  d
    .s StkGrpId=$p(StkGrpIdStr,"^",cnt)
    .f  s Chl=$o(^DHCSCG(StkGrpId,"RE",Chl)) q:Chl=""  d
    ..s StkCatId=$p(^DHCSCG(StkGrpId,"RE",Chl),"^",1)
    ..q:'$d(^INC("SC",StkCatId))
	..q:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",StkCatId,HospId)="N")
    ..s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    ..s Data=StkCatId_"^"_StkCatDesc
    ..s Count=Count+1
    ..i (Count>Start)&(Count<=End) d
    ...d json.InsertRowData(Data)
    ..
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2011-12-15
/// description: 药学大类ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcCat(PhccDesc, Start, Limit) As %String
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select PHCC_RowId AS RowId, PHCC_DESC AS Description from PHC_Cat WHERE PHCC_DESC like '%"_PhccDesc_"%' AND PHCC_DESC IS NOT NULL order by PHCC_DESC"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2011-12-15
/// description: 药学子类ComboBox
/// input: 药学大类id, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcSubCat(PhcCatId, Start, Limit) As %String
{
    q:PhcCatId="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    ;
    s Chl=0
    f  s Chl=$o(^PHCC(PhcCatId,"SC",Chl)) q:Chl=""  d
    .s PhcSubCatDesc=$p(^PHCC(PhcCatId,"SC",Chl),"^",2)
    .s Data=PhcCatId_"||"_Chl_"^"_PhcSubCatDesc
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)
    .
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2011-12-15
/// description: 药学小类ComboBox
/// input: 药学子类id, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcMinCat(PhcSubCatId, Start, Limit) As %String
{
    q:PhcSubCatId="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    ;
    s MainId=+PhcSubCatId
    s Sub=$p(PhcSubCatId,"||",2)
    s Chl=0
    f  s Chl=$o(^PHCC(MainId,"SC",Sub,"MIN",Chl)) q:Chl=""  d
    .s PhcMinCatDesc=$p(^PHCC(MainId,"SC",Sub,"MIN",Chl),"^",2)
    .s Data=PhcSubCatId_"||"_Chl_"^"_PhcMinCatDesc
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)
    .
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 处方通用名ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.DrugUtil).GetPhcGeneric("amxl",1,20)
ClassMethod GetPhcGeneric(PhcGeName, Start, Limit)
{
	s pid=..NewPid()
    s $zt="ErrorGetPhcGeneric"
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select phcge_rowid AS RowId, phcge_name AS Description from phc_generic WHERE phcge_name LIKE '%"_PhcGeName_"%' order by phcge_rowid"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s dataend=$p(^PHCGE("GE",Rowid),"^",6)
   		continue:(dataend'="")&&(dataend<+$h)
	    s ^TMP("DHCST","DrugUtil","GetPhcGeneric",pid,Rowid)=""
    } 
    d result.Close()
    i $d(^User.BDPAliasI("DataRef","PHC_Generic")) //20160411,yunhaibao,添加基础平台别名检索
    { 
	    s sqlStr = "select DataReference AS referencedr from BDPAlias WHERE DataAlias LIKE '%"_PhcGeName_"%' and TableName='PHC_Generic'"
	    d result.Prepare(sqlStr)
	    d result.Execute()
	    While(result.Next())
	    {
		    s Rowid = result.Data("referencedr")
		    s dataend=$p(^PHCGE("GE",Rowid),"^",6)
   			continue:(dataend'="")&&(dataend<+$h)
		    s ^TMP("DHCST","DrugUtil","GetPhcGeneric",pid,Rowid)=""
	    }
	    d result.Close() 
	}	
	q:'$d(^TMP("DHCST","DrugUtil","GetPhcGeneric",pid)) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s json = ##class(Code.JsonObj).%New()
	s outputid=""
	f  s outputid=$o(^TMP("DHCST","DrugUtil","GetPhcGeneric",pid,outputid)) q:outputid=""  d
    .q:+outputid=0
    .s rowid=outputid
    .s description=$p(^PHCGE("GE",rowid),"^",2)
    .s outputdata=rowid_"^"_description
    .s count = count+1
    .i (count>Start)&(count<=end) d
    ..d json.InsertRowData(outputdata)   
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    k ^TMP("DHCST","DrugUtil","GetPhcGeneric",pid)
    Q resultString
ErrorGetPhcGeneric
	k ^TMP("DHCST","DrugUtil","GetPhcGeneric",pid)
	q ##class(web.DHCSTEXTCOMMON).GetNoJson()
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 剂型ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcForm(PHCFDesc, Start, Limit)
{
    ;s ^zdm("GetPhcForm")=PHCFDesc
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select PHCF_RowId AS RowId , PHCF_DESC AS Description from PHC_Form WHERE PHCF_DESC LIKE '%"_PHCFDesc_"%' order by PHCF_RowId "
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 用法ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPHCInstruc(PHCInDesc, Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCIN_RowId AS RowId, PHCIN_DESC1 AS Description from PHC_Instruc WHERE PHCIN_DESC1 like '%"_PHCInDesc_"%' order by PHCIN_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 频次ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPHCFreq(PhcFrDesc, Start, Limit)
{
    ;s ^zdm("GetPHCFreq")=PhcFrDesc_"^"_Start_"^"_Limit
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT phcfr_RowId AS RowId, phcfr_desc1 AS Description,phcfr_activeflag AS ActiveFlag  FROM  phc_freq where phcfr_desc1 like '%"_PhcFrDesc_"%' order by phcfr_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s ActiveFlag= result.Data("ActiveFlag") 
    continue:ActiveFlag="N"
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 疗程ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcDuration(PhcDuDesc, Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCDU_RowId AS RowId, PHCDU_DESC1 AS Description from Phc_Duration WHERE PHCDU_DESC1 like '%"_PhcDuDesc_"%' order by PHCDU_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 医保类别-G,批准文号-Gp,处方类别-Gpp,招标级别-Gpbl,质量层次-Gzl ComboBox
/// input:  
/// output: String "RowId^Description"
/// others: w ##class(web.DHCST.Util.DrugUtil).GetOfficeCode("Gpp",0,10)
ClassMethod GetOfficeCode(Type, start, limit)
{
    n (Type,start,limit)
    s resultString = ""
    s end=start+limit
    i $d(^DHCSTOFFICODE(Type)) D
    .S list = ^DHCSTOFFICODE(Type)
    .s json = ##class(Code.JsonObj).%New()
    .s count = 0
    .s i = 1
    .f  s id=$P(list, "^", i) q:id=""  d
    ..s code=id
    ..s desc=id
    ..s i = i+1
    ..s count = count+1
    ..s tmp=id_"^"_desc
    ..q:(count<=start)!(count>end)
    ..d json.InsertRowData(tmp)
    .s resultString = json.getJsonData("RowId^Description",count)
    .k json
    
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 管制分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhcPoison(start, limit)
{
    n (start,limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select PHCPO_RowId AS RowId, PHCPO_DESC AS Description from phc_poison ORDER BY PHCPO_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s end=start+limit
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        s count = count+1
        if (count>start)&(count<=end){
            d json.InsertRowData(tmp)
        }
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 费用大类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetArcBillGrp(start, limit)
{
    n (start,limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ARCBG_RowId AS RowId, ARCBG_DESC AS Description from ARC_BillGrp ORDER BY ARCBG_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s end=start+limit
    While(result.Next())
    {
        s Rowid = result.Data("RowId") 
        s Description = result.Data("Description")
        IF (Description = "")
        {
            CONTINUE
        }
        s tmp=Rowid_"^"_Description
        s count = count+1
        if (count>start)&(count<=end){
            d json.InsertRowData(tmp)
        }
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 费用子类ComboBox
/// input:  ARCBGRowId
/// output: String "RowId^Description"
/// others:
ClassMethod GetArcBillSub(ARCBGRowId)
{
    q:ARCBGRowId="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ARCSG_RowId AS RowId, ARCSG_DESC AS Description from ARC_BillSub WHERE ARCSG_ARCBG_ParRef = "_ARCBGRowId_" ORDER BY ARCSG_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId") 
    s Description = result.Data("Description")
    IF (Description = "")
    {
        CONTINUE
    }
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 医嘱大类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetOrderCategory(StkType, start, limit)
{
    n (StkType,start,limit)
    s result = ##class(%Library.ResultSet).%New()
    i StkType="G" d
    .s sqlStr="select distinct arcic_ordcat_dr->orcat_rowid as RowId,arcic_ordcat_dr->orcat_desc as Description from ARC_ItemCat  where arcic_ordertype="_"'"_"R"_"'"
    i StkType="M" d
    .s sqlStr = "select ORCAT_RowId as RowId, ORCAT_Desc as Description from OEC_OrderCategory where orcat_desc like '%材料%'  ORDER BY ORCAT_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s end=start+limit
    While(result.Next())
    {
        
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    
    i (count>start)&(count<=end)  d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-19
/// description: 医嘱子类ComboBox
/// input:  ARCICOrdCatDR
/// output: String "RowId^Description"
/// others:
ClassMethod GetArcItemCat(OrdCat As %String, Desc As %String, Start As %Integer, Limit As %Integer, StkType As %String)
{
    n (OrdCat,Desc,Start,Limit,StkType,%session)
    s StkType=$g(StkType)  //zhwh 0518 增加 StkType
    s result = ##class(%Library.ResultSet).%New()   
    ;
    s HospId=""
    i $D(%session) s HospId=%session.Data("LOGON.HOSPID")
    i OrdCat'="" d
    .s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where  ARCIC_OrdCat_DR="_OrdCat_" and ARCIC_Desc like'%"_Desc_"%' ORDER BY Description"
    e  d
    .i StkType="G" d
    ..s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where ARCIC_OrderType='R' and ARCIC_Desc like'%"_Desc_"%' ORDER BY Description"
    .i StkType="M" d
    ..s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where ARCIC_OrdCat_DR->orcat_desc='材料' and ARCIC_Desc like'%"_Desc_"%' ORDER BY Description"
    ..
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s end=Start+Limit
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId") 
        continue:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItemCat",Rowid,HospId)="N")
        s Description = result.Data("Description")
        IF (Description = "")
        {
            CONTINUE
        }
        s tmp=Rowid_"^"_Description
        s count = count+1
        if (count>Start)&(count<=end) {
            d json.InsertRowData(tmp)
        }
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 医嘱优先级ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetOECPriority(start, limit)
{
    n (start,limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select OECPR_RowId as RowId, OECPR_Desc as Description from OEC_Priority ORDER BY OECPR_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=start+limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        s count = count+1
        if (count>start)&(count<=end){
            d json.InsertRowData(tmp)
        }
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 定价类型ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetMarkType(HospID = "")
{
    n (HospID)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MT_RowId as RowId,  MT_Desc as Description FROM DHC_MarkType where MT_UseFlag='Y' and MT_Type='G' ORDER BY MT_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_MarkType",Rowid,HospID) //医院级别授权
    continue:flag="N"
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 招标名称ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetPublicBiddingList(Hosp = "")
{
	n (Hosp)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT DHCPBL_RowId as RowId, DHCPBL_Desc as Description , DHCPBL_Desc as Description,DHCPBL_ActiveFlag as ActiveFlag,DHCPBL_EfficDateFrom as EfficStartDate,DHCPBL_EfficDateTo as EfficEndDate FROM DHC_PublicBiddingList where DHCPBL_Desc is not null and DHCPBL_Type='G' order by DHCPBL_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
	continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PublicBiddingList",Rowid,Hosp)="N")
    s Description = result.Data("Description")
    s ActiveFlag=result.Data("ActiveFlag")  continue:ActiveFlag'="Y"
    s EfficStartDate=result.Data("EfficStartDate") 
    s EfficEndDate=result.Data("EfficEndDate") continue:(EfficEndDate'="")&&(EfficEndDate<$h)
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 帐薄分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetBookCat(Hosp = "")
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT BC_RowId as RowId, BC_Desc as Description FROM DHCST_BookCat order by BC_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
	continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCST_BookCat",Rowid,Hosp)="N")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description:取药品相关信息
/// input: 库存项rowid,医院id
/// output: 库存分类^定价类型^物价文件号
/// others:目前调用界面：调价建单，
ClassMethod GetItmInfo(ItmRowid As %String, HospId As %String = "", StkType = "G") As %String
{
    n (ItmRowid,HospId,StkType)
    q:ItmRowid="" ""
    q:'$d(^INCI(ItmRowid)) ""
    ;
    s StkCatId=$p(^INCI(ItmRowid,2),"^",2)
    s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    s InciCode=$p(^INCI(ItmRowid,1),"^",1)
    s InciDesc=$p(^INCI(ItmRowid,1),"^",2)
    s InfoId=$o(^DHCITMINFO(0,"INCI",ItmRowid,0))
    i InfoId'=""  d
    .s MarkTypeId=$p(^DHCITMINFO(InfoId),"^",15)
    .s:MarkTypeId'="" MarkTypeDesc=$p(^DHCINMT(MarkTypeId),"^",2)
    .s PriceFileNo=$p(^DHCITMINFO(InfoId),"^",33)
    .s MaxSp=$p(^DHCITMINFO(InfoId),"^",16)
    .s Spec=$p(^DHCITMINFO(InfoId),"^",27)
    .s Remark=$p(^DHCITMINFO(InfoId),"^",10)
    e  s Spec="",Remark=""
    s NotUseFlag=$p(^INCI(ItmRowid,2),"^",9)
    s BUomId=$p(^INCI(ItmRowid,1),"^",10)
    s PurUomId=$p(^INCI(ItmRowid,3),"^",6)
    s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    //s PurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,PurUomId,HospId,StkType)
    //s PurRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,PurUomId,HospId,StkType)
    s PurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,PurUomId,HospId,StkType,"")
    s PurRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,PurUomId,HospId,StkType,"")
    s ConFacPur=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    s ManfStr=##class(web.DHCST.Common.DrugInfoCommon).GetManf(ItmRowid)
    s ManfId=$p(ManfStr,"^",1)
    s ManfName=$p(ManfStr,"^",3)
    s Data1=InciCode_"^"_InciDesc_"^"_StkCatId_"^"_$g(StkCatDesc)_"^"_$g(MarkTypeId)_"^"_$g(MarkTypeDesc)
    s Data2=BUomId_"^"_$g(BUomDesc)_"^"_PurUomId_"^"_$g(PurUomDesc)_"^"_$g(PriceFileNo)
    s Data3=PurSp_"^"_PurRp_"^"_$g(MaxSp)_"^"_ConFacPur
    s Data4=$g(ItmRowid)_"^"_$G(Spec)_"^"_$G(ManfId)_"^"_$G(ManfName)_"^"_NotUseFlag_"^"_Remark 
    s resultString =Data1_"^"_Data2_"^"_Data3_"^"_Data4
    ;
    q "{""success"":""true"",""info"":"""_resultString_"""}"
}

/// creator:zhangdongmei
/// date:2012-05-28
/// description:质量层次ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetQualityLevel()
{
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT QL_Rowid as RowId, QL_Desc as Description FROM DHC_ItmQualityLevel"_
    "  where QL_DateFrom<="_date_" and QL_DateTo>="_date_" order by RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-28
/// description:医保类别ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetInsuCat()
{
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT IC_Rowid as RowId, IC_Desc as Description FROM DHC_ItmInsuCategory"_
    "  where IC_DateFrom<="_date_" and IC_DateTo>="_date_" order by RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-28
/// description:招标级别ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetPBLevel(Hosp)
{
	n (Hosp)
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT PBL_Rowid as RowId, PBL_Desc as Description FROM DHC_ItmPBLevel"_
    "  where PBL_DateFrom<="_date_" and PBL_DateTo>="_date_" order by RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
	continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_ItmPBLevel",Rowid,Hosp)="N")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-29
/// description:库存项屏蔽原因ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetItmNotUseReason()
{
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT DIUR_Rowid as RowId, DIUR_Desc as Description FROM DHC_ItmNotUseReason"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    continue:+Rowid=0
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-30
/// description:小数规则ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetStkDecimal(HospID = "")
{
    n (HospID)
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT SD_RowID as RowId, SD_Desc as Description FROM DHC_StkDecimal WHERE SD_UseFlag='Y' and SD_Type='G'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkDecimal",Rowid,HospID) //医院级别授权
    continue:flag="N"
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-08-14
/// description:货位码ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetAllStkBin(Desc, Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s sqlStr = "SELECT INCSB_Rowid as RowId, INCSB_Desc as Description FROM INC_StkBin where INCSB_Desc like '%"_Desc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-08-21
/// description:科室货位码ComboBox
/// input:  
/// output: String "RowId^Description"
/// others: w ##Class(web.DHCST.Util.DrugUtil).GetLocStkBin("257","","0","20")
ClassMethod GetLocStkBin(LocId, Desc, Start, Limit)
{
	s ^YSJTMP("GetLocStkBin")=$LB(LocId, Desc, Start, Limit)
    q:LocId="" ""
    s result = ##class(%Library.ResultSet).%New()
    s date=+$h
    s stknull="空"
    s sqlStr = "SELECT INCSB_Rowid as RowId, INCSB_Desc as Description FROM INC_StkBin "_
    " where INCSB_Desc <> '"_stknull_"' and INCSB_Code like '"_LocId_"P%' order by Description"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    k list
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	 
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        continue:(Desc'="")&('$f(Description,Desc))
        s tmp=Rowid_"^"_Description
        ///模糊查询中先将靠前的货位显示出来 2020-06-23 yangsj
        s headLen=0,headIndex=0
        i (Desc'="") d
        .s headIndex=$P(Description,Desc,1)
        .s headLen=$L(headIndex)
        .i headIndex="" s headIndex=" "  //空格ascii码字符排序最靠前
        s count = count+1
        s list(headLen,headIndex,count)=Rowid_"^"_Description
    

    }
    
    s len="",count=0
    f  s len=$O(list(len)) q:len=""  d
    .s index=""
    .f  s index=$O(list(len,index)) q:index=""  d
    ..s num=""
    ..f  s num=$O(list(len,index,num)) q:num=""  d
    ...s count = count+1
    ...i (count>Start)&(count<=end) d
	....s endflag=0
	....s tmp=list(len,index,num)
    ....d json.InsertRowData(tmp)
        
    
    //将”空“货位追加载到下拉列表的最后一个
    if count<=end d
    .&sql( declare nullstkbin cursor for 
         SELECT INCSB_Rowid as RowId, INCSB_Desc as Description FROM INC_StkBin
         where INCSB_Desc =:stknull
            )
    .&sql(open   nullstkbin)
    .f  &sql(fetch nullstkbin into :NRowId,:NDesc) q:SQLCODE  d
    ..s tmp=NRowId_"^"_NDesc
    ..d json.InsertRowData(tmp)
    &sql(close	nullstkbin)
    
    d result.Close()

    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2013-12-11
/// description:科室药品货位码ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.DrugUtil).GetLocStkBinQ(8594,102,"",0,20)
ClassMethod GetLocStkBinQ(ItmRowid, LocId, Desc, Start, Limit)
{
 
    s endpage=Start+Limit  //结束行
    s stpage=Start+1 //开始行
    s h=0
    s pid=..NewPid()
    Set $ZT="ERRORGetLocStkBinQ"
    s locincch=""
    f  s locincch=$o(^INCI("IL_LOC",LocId,ItmRowid,locincch)) q:locincch=""  d
    .s incil=ItmRowid_"||"_locincch
    .s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    .s stkbindesc=$p(stkbinret,":",2)
    .i stkbindesc="" s stkbindesc="空"
    .s cnt=$l(stkbindesc,",")
    .s rowid=ItmRowid_"||"_locincch
    .//f num=1:1:cnt  d
    .//.s stkbin=$p(stkbindesc,",",num)
    .s data=rowid_"^"_stkbindesc
    .s h=h+1
    .s index="Sort^"_rowid_"^"_h  //排序
    .s ^TMP("DHCST","DrugUtil","GetLocStkBinQ",pid,"index",index)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    
    f  s h=$o(^TMP("DHCST","DrugUtil","GetLocStkBinQ",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","DrugUtil","GetLocStkBinQ",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s stkbin=$p(data,"^",2)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s RowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RowId",rowid)
    .s Description=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Description",stkbin)
    .s tmpstr=RowId_Description
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    k ^TMP("DHCST","DrugUtil","GetLocStkBinQ",pid)
    q ""
    
ERRORGetLocStkBinQ
    //遇报错,则先kill TMP
    Set Method= "##class(web.DHCST.INCItmLoc).GetLocStkBinQ"
	Set ErrorMsg=Method_"("_$LTS($LB(ItmRowid, LocId,Desc, Start, Limit))_")"_","_$ZE
	k ^TMP("DHCST","DrugUtil","GetLocStkBinQ",pid) 
    q ""
}

/// creator:LMZ
/// date:2012-07-5
/// description:医院ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.DrugUtil).GetHosp(0,30)
ClassMethod GetHosp(Start, Limit) As %String
{
    n (Start,Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select HOSP_RowId as RowId,HOSP_Desc as Description from CT_Hospital"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s dateFrom=$p(^CT("HOSP",Rowid),"^",9)
        continue:(dateFrom'="")&&(dateFrom>+$h)
        s dateTo=$p(^CT("HOSP",Rowid),"^",10)
        continue:(dateTo'="")&&(dateTo<+$h)
        s tmp=Rowid_"^"_Description
        s count = count+1
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// Descript:根据科室和药品库存项查询药品的批次列表
/// Creater:zhangdongmei
/// CreateDate:2012-07-19
/// Input:库存项id,供应科室id,请求科室id,开始行，一页显示记录数       
/// Output:     
/// Return：批次RowID^批次/效期^厂商^批次库存^包装单位^售价^  
/// 请求数量^基本单位^进价^库位^供应方库存^请求方库存^入库日期
/// 包装单位id^基本单位id^包装单位和基本单位的转换率^批次占用库存^批次可用库存^批次售价
/// Modify:2013-01-22,公共批次窗口调用,添加inclb参数(缺省为空),用于高值材料转移时取特定批次信息
/// LastUpdate:2015-11-26,yunhaibao,修改为write形式,原方法容易超长,且解析速度慢
/// w ##class(web.DHCST.Util.DrugUtil).GetDrugBatInfo("2144","165","","1","0","15","G","","","")
ClassMethod GetDrugBatInfo(InciDr, ProLocId, ReqLocId, QtyFlag, Start, Limit, StkType = "G", Inclb = "", Sort = "", Dir = "") As %Library.String
{
    n (InciDr, ProLocId, ReqLocId,QtyFlag,Start,Limit,StkType,Inclb,Sort,Dir)
    s ^YSJTMP("GetDrugBatInfo")=$LB(InciDr, ProLocId, ReqLocId,QtyFlag,Start,Limit,StkType,Inclb,Sort,Dir)
    q:ProLocId="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:InciDr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
    s End = Start+Limit
    s Start=Start+1
    s CountRecords=0  
    s Pid=..NewPid()
    k ^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid)
    s $zt="ErrorGetDrugBatInfo"
    s chl=0
    f  s chl=$o(^INCI("IL_LOC",ProLocId,InciDr,chl))  q:chl=""  d
    .s lb=0
    .f  s lb=$o(^INCI(InciDr,"IL",chl,"LB",lb))  q:lb=""  d
    ..s RowId =InciDr_"||"_chl_"||"_lb
    ..q:(Inclb'="")&(RowId'=Inclb)
    ..s IncibRowId =$p(^INCI(InciDr,"IL",chl,"LB",lb),"^",1)
    ..s IncilRowId =InciDr_"||"_chl
    ..s BatNo=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",1)
    ..s ExpDate=$p(^INCI(+IncibRowId,"IB",$p(IncibRowId,"||",2)),"^",2)
    ..s ExpDateH=+ExpDate
    ..s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    ..s BatExp = BatNo_"~"_ExpDate
    ..s Manf = ##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(RowId)
    ..s ManfDr=$P(Manf,"^",1)
    ..s ManfName=$P(Manf,"^",2)
    ..s BUomId=$p(^INCI(InciDr,1),"^",10)
    ..s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
    ..s PurUomId=$p(^INCI(InciDr,3),"^",6)
    ..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    ..s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(+PurUomId,+BUomId)
    ..s InclbQty = ##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLBURid(RowId,PurUomId)
    ..q:(QtyFlag=1)&(InclbQty<=0)
    ..S InitQty = 0
    ..s Date = $P($H, ",", 1)
    ..S HospID=$P(^CTLOC(ProLocId),"^",22)
    ..s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(RowId,+$h,PurUomId,HospID,StkType,"")
    ..s BatSp=##class(web.DHCST.Common.PriceCommon).BatSpUom(RowId,PurUomId,HospID,StkType)
    ..S ReqQty = 0
    ..s Rp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(RowId,PurUomId,HospID,StkType,+$h,"")
    ..s Rp=$fn(Rp,"N")
    ..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(IncilRowId,",","","") //改为取新的科室货位表DHCIncItmLocBin（可多货位）add wyx 2013-11-21
    ..s stkchkflag=$p(stkbinret,":",1)
    ..s stkbinstr=$p(stkbinret,":",2)
    ..s StkBin=stkbinstr
    ..s DirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(RowId,PurUomId)
    ..s AvaQty = InclbQty - DirtyQty
    ..s SupplyStockQty = ##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(InciDr,ProLocId,PurUomId,Date)
    ..S:ReqLocId'="" RequrstStockQty = ##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(InciDr,ReqLocId,PurUomId,Date)
    ..s IngrId =  ##class(web.DHCST.Common.DrugStkCommon).GetClbDHCIngr(RowId,+$h)
    ..s IngrDate=""
    ..i IngrId'=""  d
    ...s IngrDate=$p(^DHCINGR(+IngrId),"^",4)
    ...s:IngrDate'="" IngrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(IngrDate,"ST")
    ..s HVFlag=##class(web.DHCST.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
    ..q:'$d(^DHCINCLB(0,"LB",RowId))
    ..s dhcinclb=$o(^DHCINCLB(0,"LB",RowId,""),-1)
    ..s inclbactive=$p($g(^DHCINCLB(dhcinclb)),"^",4)
    ..s InclbWarnFlag=0  //效期警示级别,目前仅控制批次库存颜色变化,yunhaibao20151201
    ..i (ExpDateH'=0)&&(ExpDateH<=+$h) s InclbWarnFlag=1
    ..i inclbactive'="Y" s InclbWarnFlag=2 
    ..s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(InciDr, HospID)
    ..s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(InciDr, HospID)
    ..s CountRecords = CountRecords+1
    ..s tmp1=RowId_"^"_BatExp_"^"_ManfName_"^"_InclbQty
    ..s tmp2=$g(PurUomDesc)_"^"_Sp_"^"_ReqQty_"^"_$g(BUomDesc)_"^"_Rp
    ..s tmp3=StkBin_"^"_SupplyStockQty_"^"_$g(RequrstStockQty)_"^"_IngrDate
    ..s tmp4=PurUomId_"^"_BUomId_"^"_ConFac_"^"_DirtyQty_"^"_AvaQty_"^"_BatSp_"^"_HVFlag_"^"_InclbWarnFlag_"^"_InsuCode_"^"_InsuDesc
    ..s tmp=tmp1_"^"_tmp2_"^"_tmp3_"^"_tmp4
	..s Index="1"
	..i Sort="BatExp" s Index=BatExp
	..e  i Sort="InclbQty" s Index=InclbQty
	..e  i Sort="IngrDate" s Index=IngrDate
	..e  s Index=InclbWarnFlag
	..i Index="" s Index="1"
	..s ^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid,Index,CountRecords)=tmp
	q:CountRecords=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Title1="Inclb^BatExp^Manf^InclbQty^PurUomDesc^Sp^ReqQty"
    s Title2="BUomDesc^Rp^StkBin^SupplyStockQty^RequrstStockQty^IngrDate"
    s Title3="PurUomId^BUomId^ConFac^DirtyQty^AvaQty^BatSp^HVFlag^InclbWarnFlag^InsuCode^InsuDesc"
    s Title=Title1_"^"_Title2_"^"_Title3
	i Dir="DESC" s orderflag="-1"
	e  s orderflag="1"
    i End>CountRecords s End=CountRecords
    s count=0
    s outputi=""
    f  s outputi=$o(^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid,outputi),orderflag) q:outputi=""  d 
    .s outputj=""
    .f  s outputj=$o(^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid,outputi,outputj),orderflag) q:outputj=""  d 
    ..s count=count+1
	..q:count<Start
	..q:count>End
	..s outputdata=^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid,outputi,outputj)
	..i count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(CountRecords)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
	k ^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid)
	q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	w "]}"
	q ""
ErrorGetDrugBatInfo
	k ^TMP("DHCST","Util","DrugUtil","GetDrugBatInfo",Pid)
	q $ze
}

/// Descript:根据药品库存项查询药品的批次列表
/// Creater:zhangdongmei
/// CreateDate:2013-07-19
/// Input:库存项id,开始行，一页显示记录数       
/// Output:     
/// Return：批次RowID^批次/效期^厂商^批次库存^包装单位^售价^基本单位^进价^入库日期^
/// 包装单位id^基本单位id^包装单位和基本单位的转换率
/// modify: wyx 根据库存项id取INC_ItmBat表的药品的批次(与科室库存批次不是一个意思)，批号+效期为一个批次
/// w ##class(web.DHCST.Util.DrugUtil).GetDrugBatInfoAll(805,0,15)
ClassMethod GetDrugBatInfoAll(InciDr, LocId, Start, Limit, StkType = "G") As %Library.String
{
    n (InciDr,LocId,Start,Limit,StkType)
    q:InciDr="" ""
    s end = Start+Limit
    ;
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s chl=0
    f  s chl=$o(^INCI(InciDr,"IB",chl)) q:chl=""  d
    .s Incib =InciDr_"||"_chl
    .
    .S InciCode=$P(^INCI(InciDr,1),"^",1)             //代码
    .S InciDesc=$P(^INCI(InciDr,1),"^",2)             //名称
    .s BatNo=$p(^INCI(InciDr,"IB",chl),"^",1)
    .s ExpDate=$p(^INCI(InciDr,"IB",chl),"^",2)
    .s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    .s BatExp = BatNo_"~"_ExpDate
    .
    .s BUomId=$p(^INCI(InciDr,1),"^",10)
    .s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
    .s PurUomId=$p(^INCI(InciDr,3),"^",6)
    .s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    .
    .s HospID=$p(^CTLOC(LocId),"^",22)
    .
    .s RetStr=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,PurUomId,HospID,"")
    .s Sp=$p(RetStr,"^",2)
    .s Rp=$p(RetStr,"^",1)
    .//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,PurUomId,HospID,StkType,"")
    .//s Rp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,PurUomId,HospID,StkType,+$h,"")
    .s count = count+1
    .
    .s tmp1=Incib_"^"_InciDr_"^"_InciCode_"^"_InciDesc_"^"_BatExp_"^"_PurUomId_"^"_PurUomDesc_"^"_Rp_"^"_Sp_"^"_BUomId_"^"_BUomDesc
    .s tmp=tmp1
    .i (count>Start)&(count<=end) d
    ..d json.InsertRowData(tmp)
    .
  
    s Title1="Incib^InciDr^InciCode^InciDesc^BatExp^PurUomId^PurUomDesc^Rp^Sp^BUomId^BUomDesc"
    s Title=Title1
    if count>0 d
    .s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarSubCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TARSC_RowId as RowId,TARSC_Desc as Description from DHC_TarSubCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:会计子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarAcctCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TARAC_RowId as RowId,TARAC_Desc as Description from DHC_TarAcctCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:住院子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarInpatCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TARIC_RowId as RowId,TARIC_Desc as Description from DHC_TarInpatCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:病历首页子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarMRCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TARMC_RowId as RowId,TARMC_Desc as Description from DHC_TarMRCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:核算子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarEMCCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TAREC_RowId as RowId,TAREC_Desc as Description from DHC_TarEMCCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-04-15
/// description:门诊子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
ClassMethod GetTarOutpatCate(Desc, Start, Limit)
{
    n (Desc, Start, Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select TAROC_RowId as RowId,TAROC_Desc as Description from DHC_TarOutpatCate"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end=Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        continue:(Desc'="")&('$f(Description,Desc))
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// 取某用户的授权类组串
/// Author:zhwh
/// Date:2013-07-12
/// Arguments:
///  userRowId - 用户rowid
///  stktype - 类型
/// Return:类组串
/// LastUpdate:如果用户对应为空,且默认登陆科室没有按人员维护类组时,取科室类组
/// w ##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(11643,"G")
ClassMethod GetUserCatGrpStr(userRowId As %String, stktype As %String) As %String
{
 n (userRowId,stktype)
 q:userRowId="" ""
 s result=""
 &Sql(declare userScg cursor for 
  select u_slcg_parref->slcg_stkcatgrp_dr From sqluser.dhc_stklocusercatgrp
  where u_ssusr_dr=:userRowId and u_slcg_parref->slcg_type=:stktype)	
 &sql(open 	userScg)
 f  &sql(fetch userScg into :scg) q:SQLCODE  d
 .i result="" s result=+scg
 .e  s result=result_"^"_+scg
 &sql(close	userScg)
 i result="" d
 .s LocId=$p($g(^SSU("SSUSR",userRowId)),"^",4)
 .q:LocId=""   
 .s Slcg="",quitflag=""
 .f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,stktype,Slcg)) q:(Slcg="")||(quitflag'="")  d
 ..i $d(^DHCSLCG(Slcg,"I")) s result="",quitflag=1  //科室已按人员维护
 ..q:quitflag'=""
 ..s scg=$p(^DHCSLCG(Slcg),"^",2)
 ..i result="" s result=+scg
 ..e  s result=result_"^"_+scg
 q result
}

/// Description:重写获取科室类组权限默认值
/// Creator:yangsj
/// CreateDate:2020-02-25
/// Input:UserId,LocDr,stktype
/// Output:
/// 
/// w ##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(11643,"G",257)
ClassMethod GetUserCatGrpStrNew(UserId As %String, stktype As %String, loc As %String = "") As %String
{
	n (UserId,stktype,loc,%session)
	q:UserId="" ""
	q:stktype="" ""
	s LocDr=""
	i loc'="" s LocDr=loc
	e  i $D(%session)  s LocDr=%session.Data("LOGON.CTLOCID")
	q:LocDr="" ""
	
	s ScgStr=""
	s Slcg=0
    f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocDr,stktype,Slcg)) q:Slcg=""  d
    .s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    .s chl=""
    .i UserId'=""  d
    ..s chl=$o(^DHCSLCG(0,"USER",UserId,Slcg,0))
    .s activeUseFlag=0,AllChl=""  //如果该类组下没有维护人员，则此类组所有人员都有权限 2020-02-21 yangsj
    .f  s AllChl=$o(^DHCSLCG(Slcg,"I",AllChl)) q:AllChl=""  d
    ..s tmpActive=$P(^DHCSLCG(Slcg,"I",AllChl),"^",2)
    ..i tmpActive="Y" s activeUseFlag=1
    .
    .q:(UserId'="")&(chl="")&(activeUseFlag=1)    ;检索某人员限定下的类组  //
    .s active=""
    .i chl'=""  d
    ..s Default=$p(^DHCSLCG(Slcg,"I",chl),"^",3)
    ..s active=$p(^DHCSLCG(Slcg,"I",chl),"^",2)
    .q:active="N"
    .s StkCatGrpDesc=$p(^DHCSCG(StkCatGrp),"^",2)
    .s ScgStr=$s(ScgStr="":StkCatGrp,1:ScgStr_"^"_StkCatGrp)
    
    q ScgStr
}

/// 取全部科室的库存,标库,上下限
/// Author:LiangQiang
/// Date:2013-11-12
/// Arguments: 开始行,限制行,库存项id
/// Return: 信息串
/// w ##class(web.DHCST.Util.DrugUtil).jsGetAllLocStk(0,30,674)
ClassMethod jsGetAllLocStk(Start As %String, Limit As %String, Inci As %String) As %String
{
 n (Start,Limit,Inci,%session)
 s endpage=Start+Limit  //结束行
 s stpage=Start+1 //开始行
 s h=0
 s pid=..NewPid()
 Set $ZT="ERRORjsGetAllLocStk"
 s incicode=$p(^INCI(Inci,1),"^",1)
 s ctuom=$p(^INCI(Inci,1),"^",10)
 s pctuomdr=$p(^INCI(Inci,3),"^",6)
 //s factor=+##Class(web.DHCSTCOMMONSRV).UOMFac(pctuom,ctuom)
 s pctuom=$p(^CT("UOM",pctuomdr),"^",2)
 s h=0
 s incilsub=""
 f  s incilsub=$o(^INCI(Inci,"IL",incilsub)) q:incilsub=""  d
 .s locdr=$p(^INCI(Inci,"IL",incilsub),"^",1)
 .q:locdr=""
 .q:(%session.Data("LOGON.HOSPID"))'=$P(^CTLOC(locdr),"^",22)
 .s locdesc=$p(^CTLOC(locdr),"^",2)
 .s loctype=$p(^CTLOC(locdr),"^",13)
 .q:loctype'="D"
 .s maxqty=$p(^INCI(Inci,"IL",incilsub),"^",7)
 .s minqty=$p(^INCI(Inci,"IL",incilsub),"^",4)
 .s repqty=$p(^INCI(Inci,"IL",incilsub),"^",6)
 .s qty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,locdr,pctuomdr,+$h)
 .s data=locdesc_"^"_pctuom_"^"_qty_"^"_maxqty_"^"_minqty_"^"_repqty
 .s h=h+1
 .s ^TMP("DHCST","Util.DrugUtil","jsGetAllLocStk",pid,"index",h)=data
 
 q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s maxrow=h
 i endpage>maxrow s endpage=maxrow
 
 s count=0
 s h=""
 f  s h=$o(^TMP("DHCST","Util.DrugUtil","jsGetAllLocStk",pid,"index",h)) q:h=""  d
 .s data=^TMP("DHCST","Util.DrugUtil","jsGetAllLocStk",pid,"index",h)
 .s locdesc=$p(data,"^",1)
 .s pctuom=$p(data,"^",2)
 .s qty=$p(data,"^",3)
 .s maxqty=$p(data,"^",4)
 .s minqty=$p(data,"^",5)
 .s repqty=$p(data,"^",6)
 .s count=count+1
 .q:count<stpage
 .q:count>endpage
 
 .s loc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Loc",locdesc)
 .s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Uom",pctuom)
 .s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkQty",qty)
 .s maxqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MaxQty",maxqty)
 .s minqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("MinQty",minqty)
 .s repqty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("RepQty",repqty)
 .s tmpstr=loc_uom_qty_maxqty_minqty_repqty
 
 .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
 .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
 .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
 
 .i count=stpage w startString
 .i count<endpage w firstrow
 .i count=endpage w lastrow
 k ^TMP("DHCST","Util.DrugUtil","jsGetAllLocStk",pid)
 q ""
 
ERRORjsGetAllLocStk
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.Util.DrugUtil).jsGetAllLocStk"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_Inci_")"_","_$ZE
	k ^TMP("DHCST","Util.DrugUtil","jsGetAllLocStk",pid)    
    q ErrorMsg
}

ClassMethod NewPid() As %String
{
	q $I(^DHCSTPID("DrugUtil"))
}

/// creator:BianShuai
/// date:2013-11-18
/// description:新病案首页ComboBox
/// input:  
/// output: String "RowId^Description"
ClassMethod GetTarNewMRCate(Desc, StPage, Limit)
{
	S EndPage=StPage+Limit  //结束行
	S StPage=StPage+1 //开始行
	S pid=..NewPid()
	
	S RowID=0,Num=0
	F  S RowID=$o(^DHCTarC("MCNew",RowID)) Q:(RowID="")  D
	.S MCDesc=$p(^DHCTarC("MCNew",RowID),"^",2)
	.Q:(Desc'="")&('$f(MCDesc,Desc))
	.S Num=Num+1
	.S ^TMP("DHCST","Util.DrugUtil","GetTarNewMRCate",pid,Num)=MCDesc_"^"_RowID
	
	Q:Num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S Num=0,Cnt=0
	F  S Num=$o(^TMP("DHCST","Util.DrugUtil","GetTarNewMRCate",pid,Num)) Q:Num=""  D
	.S mdate=$g(^TMP("DHCST","Util.DrugUtil","GetTarNewMRCate",pid,Num))
	.S RowId=$P(mdate,"^",2)
	.S MCDesc=$P(mdate,"^",1)
	.s Cnt=Cnt+1
	.q:Cnt<StPage
	.q:Cnt>EndPage
	.S MCDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Description",MCDesc)
	.S RowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("RowId",RowId)
	.S tmpstr=MCDesc_RowId
	.S startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	.S firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	.S lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.i Cnt=StPage w startString
	.i Cnt<EndPage w firstrow
	.i Cnt=EndPage w lastrow
	k ^TMP("DHCST","Util.DrugUtil","GetTarNewMRCate",pid)
	q ""
}

/// 根据科室库存项ID取入库批次信息
/// Author:LiangQiang
/// Date:2013-12-12
/// Arguments: 开始行,限制行,库存项id,科室id
/// Return: 信息串
/// 
ClassMethod jsGetInciRecList(Start As %String, Limit As %String, Inci As %String, LocId) As %String
{
 n (Start,Limit,Inci,LocId)
 s endpage=Start+Limit  //结束行
 s stpage=Start+1 //开始行
 s pid=..NewPid()
 
 Set $ZT="ERRORjsGetInciRecList"
 s LocInciQty=+##class(web.DHCST.Common.DrugStkCommon).IL(Inci,LocId,+$h)
 s LocInciQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,LocInciQty)
 s h=0
 s exit=0
 s ingr=""
 f  s ingr=$o(^DHCINGR(0,"INCI",Inci,ingr),-1) q:(ingr="")||(exit=1)  d
 .s inglocdr=$p(^DHCINGR(ingr),"^",13)
 .//q:inglocdr'=LocId
 .s apcdr=$p(^DHCINGR(ingr),"^",3)
 .s vendor=$p(^APC("APCVM",apcdr),"^",3)
 .i $f(vendor,"-") s vendor=$p(vendor,"-",2)
 .s recdate=$p(^DHCINGR(ingr),"^",4)
 .s recdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(recdate,"ST")
 .s chl=""
 .f  s chl=$o(^DHCINGR(0,"INCI",Inci,ingr,chl)) q:(chl="")||(exit=1)  d
 ..s inclb=$p(^DHCINGR(ingr,"GRI",chl),"^",1) 
 ..q:inclb=""
 ..s rp=$p(^DHCINGR(ingr,"GRI",chl),"^",30)
 ..s manf=""
 ..s manfdr=$p(^DHCINGR(ingr,"GRI",chl),"^",29)
 ..i manfdr'="" s manf=$p(^PHMNF(manfdr),"^",2)
 ..i $f(manf,"-") s manf=$p(manf,"-",2)
 ..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
 ..s batno=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)
 ..s expdate=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",2)
 ..s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
 ..s ingri=ingr_"||"_chl
 ..s data=recdate_"^"_rp_"^"_batno_"^"_expdate_"^"_vendor_"^"_manf_"^"_ingri
 ..s h=h+1
 ..i h=10 s exit=1
 ..s ^TMP("DHCST","Util.DrugUtil","jsGetInciRecList",pid,"index",h)=data
 
 q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s maxrow=h
 i endpage>maxrow s endpage=maxrow
 
 s count=0
 s h=""
 f  s h=$o(^TMP("DHCST","Util.DrugUtil","jsGetInciRecList",pid,"index",h)) q:h=""  d
 .s data=^TMP("DHCST","Util.DrugUtil","jsGetInciRecList",pid,"index",h)
 .s RecDate=$p(data,"^",1)
 .s Rp=$p(data,"^",2)
 .s BatNo=$p(data,"^",3)
 .s ExpDate=$p(data,"^",4)
 .s Vendor=$p(data,"^",5)
 .s Manf=$p(data,"^",6)
 .s Ingri=$p(data,"^",7)
 .s count=count+1
 .q:count<stpage
 .q:count>endpage
 
 .s RecDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RecDate",RecDate)
 .s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
 .s BatNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BatNo",BatNo)
 .s ExpDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ExpDate",ExpDate)
 .s Vendor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Vendor",Vendor)
 .s Manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Manf",Manf)
 .s LocInciQtyUom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("LocInciQtyUom",LocInciQtyUom)
 .s Ingri=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Ingri",Ingri)
 .
 .s tmpstr=RecDate_Rp_BatNo_ExpDate_Vendor_Manf_LocInciQtyUom_Ingri
 
 .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
 .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
 .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
 
 .i count=stpage w startString
 .i count<endpage w firstrow
 .i count=endpage w lastrow
 k ^TMP("DHCST","Util.DrugUtil","jsGetInciRecList",pid)
 q ""
 
ERRORjsGetInciRecList
     //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.Util.DrugUtil).jsGetInciRecList"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_Inci_","_LocId_")"_","_$ZE
	k ^TMP("DHCST","Util.DrugUtil","jsGetInciRecList",pid)    
    q ErrorMsg
}

/// creator:zhangxiao
/// date:2013-12-02
/// description: 库存分类ComboBox
/// input:  StkGrpId  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.DrugUtil).GetLocStkByLoc("M",153,541)
ClassMethod GetLocStkByLoc(stktype, Locid, Userid) As %String
{
    n (stktype, Locid, Userid)
    s Rec=##class(web.DHCST.Util.DrugUtil).GetLocStkCatGroupRowid(stktype,Locid,Userid)
    s Start=0
    s Limit=999
    s num=0
    s incsc=0
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s resultString = ""
    f  s incsc=$o(^INC("SC",incsc)) q:+incsc'>0  d 
    .q:'$d(^DHCSCG("STKCAT",incsc))
    .s scg=$o(^DHCSCG("STKCAT",incsc,"")) 
    .q:scg=""
    .s tmpstktype=$p(^DHCSCG(scg),"^",3)
    .q:tmpstktype'=stktype
    .s stkcatgroup=$o(^DHCSCG("STKCAT",incsc,0))
    .s stkcatgroup="^"_stkcatgroup_"^"
    .q:Rec'[stkcatgroup
    .s incsccode=$p(^INC("SC",incsc),"^",1)
    .s incscdesc=$p(^INC("SC",incsc),"^",2)
    .s num=num+1
    .s tmp=incsc_"^"_incscdesc
    .i (num>Start)&(num<=end) d
    ..d json.InsertRowData(tmp)
    s resultString = json.getJsonData("RowId^Description",num)
    k json
    Q resultString
}

/// creator:zhangxiao
/// date:2013-12-02
/// description: 科室能访问的类组ComboBox
/// input:  类组类型(G,M),科室id,人员id
/// output: String "RowId
/// others:
ClassMethod GetLocStkCatGroupRowid(Type As %String, LocId As %String, UserId As %String)
{
    n (Type,LocId,UserId)
    s count = 0
    q:Type="" ""
    q:LocId="" ""
    s resultString = ""
    s Rowid=""
    s Slcg=0
    f  s Slcg=$o(^DHCSLCG(0,"CTLOC",LocId,Type,Slcg)) q:Slcg=""  d
    .s StkCatGrp=$p(^DHCSLCG(Slcg),"^",2)
    .s Default=$p(^DHCSLCG(Slcg),"^",2)
    .s chl=""
    .i UserId'=""  d
    ..s chl=$o(^DHCSLCG(0,"USER",UserId,Slcg,0))
    .q:(UserId'="")&(chl="")    ;检索某人员限定下的类组
    .i chl'=""  d
    ..s Default=$p(^DHCSLCG(Slcg,"I",chl),"^",3)
    ..s active=$p(^DHCSLCG(Slcg,"I",chl),"^",2)
    .q:active="N"
    .s StkCatGrpDesc=$p(^DHCSCG(StkCatGrp),"^",2)
    .s tmp=StkCatGrp_"^"_StkCatGrpDesc_"^"_Default
    .s Rowid=StkCatGrp_"^"_Rowid
    .
    
    s Rowid="^"_Rowid
    Q Rowid
}

/// creator: hulihua
/// date: 2014-11-24
/// description: 草药备注ComboBox
/// input: Start, Limit
/// output: String "RowId^Description"
/// others: w ##class(web.DHCST.Util.DrugUtil).GetPHCSpecInc("另泡","0","30")
ClassMethod GetPHCSpecInc(PHCInDesc, Start, Limit)
{
    n (PHCInDesc, Start, Limit)
    s resultString = ""
    s End=Start+Limit
    i $d(^DHCDocConfig("CNMedItemPhSpecInstr")) D
    .S list = ^DHCDocConfig("CNMedItemPhSpecInstr")
    .s list = $tr(list,$c(1),"-")
    .s json = ##class(Code.JsonObj).%New()
    .s Count = 0
    .s i = 1
    .f  s id=$P(list, "^", i) q:id=""  d
    ..s desc=$p(id,"-",2)
    ..s id=$p(id,"-",1)
    ..s i = i+1
    ..i PHCInDesc'="" q:desc'[PHCInDesc    
    ..s Count = Count+1
    ..s tmp=id_"^"_desc
    ..q:(Count<=Start)!(Count>End)
    ..d json.InsertRowData(tmp)
    .s resultString = json.getJsonData("RowId^Description",Count)
    .k json
    Q resultString
}

/// creator:wyx
/// date:2014-12-03
/// description: PHCDFWhoDDDUom ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.DrugUtil).PHCDFWhoDDDUom("","H15N010",0,999)
ClassMethod PHCDFWhoDDDUom(PHCDFWhoDDDName, phcdCode, Start, Limit)
{
  n (PHCDFWhoDDDName, phcdCode,Start, Limit)
  s pid=..NewPid()
  s resultString = ""
  s End=Start+Limit
  s phcdCode=$$ALPHAUP^SSUTIL4(phcdCode)
  q:phcdCode="" ""
  s phcdID=$o(^PHCD(0,"Code",phcdCode,""))
  s phcdSub=0,RetList=""
  s json = ##class(Code.JsonObj).%New()
  s number = 0
 f  s phcdSub=$o(^PHCD(phcdID,"DF",phcdSub)) q:(phcdSub="")  d
 .s buomID=$p(^PHCD(phcdID,"DF",phcdSub,2),"^",4)
 .q:buomID=""
 .s buomDesc=$p($g(^CT("UOM",buomID)),"^",2)
 .s number=number+1
 .s ^TMP("web","DHCST","Util","DrugUtil","PHCDFWhoDDDUom",pid,number)=buomID_"^"_buomDesc
 .s eqSub="0"
 .f  s eqSub=$o(^PHCD(phcdID,"DF",phcdSub,"EQ",eqSub)) q:eqSub=""  d
 ..s eqStr=^PHCD(phcdID,"DF",phcdSub,"EQ",eqSub)
 ..s uomID=$p(eqStr,"^",1)
 ..q:uomID=""
 ..s uomDesc=$p($g(^CT("UOM",uomID)),"^",2)
 ..s number=number+1
 ..s ^TMP("web","DHCST","Util","DrugUtil","PHCDFWhoDDDUom",pid,number)=uomID_"^"_uomDesc
 ..
 s Count=0,cnt=""
 f  s cnt=$o(^TMP("web","DHCST","Util","DrugUtil","PHCDFWhoDDDUom",pid,cnt)) q:cnt=""  d
 .s Count = Count+1
 .s tmp=^TMP("web","DHCST","Util","DrugUtil","PHCDFWhoDDDUom",pid,Count)
 .q:(Count<=Start)!(Count>End)
 .d json.InsertRowData(tmp)
 .
 s resultString = json.getJsonData("RowId^Description",Count)
 k json
 Q resultString
}

/// creator:yunhaibao
/// createdate:20160415
/// description:根据药品id获取相关信息
ClassMethod GetItmInfoByCode(IncCode As %String, HospId As %String) As %String
{
	n (IncCode,HospId)
	&sql(select inci_rowid into :inci from inc_itm where inci_code=:IncCode)
	q:SQLCODE ""
	q ..GetItmInfo(inci,HospId,"G")
}

/// Description:获取药品配液分类的下拉框
/// Creator:	hulihua
/// CreateDate:	2016-12-15
/// Table:      DHC_PHAPivaCat 
/// Input:		Input-界面输入值, Start-开始行数, Limit-最大行数
/// Output:		
/// Return：	药品配液分类列表   
/// w ##class(web.DHCST.Util.DrugUtil).GetPHCPivaCat("",0,3)
ClassMethod GetPHCPivaCat(Input, Start, Limit) As %String
{
	n (Input,Limit,Start)
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    ;
    s PivaCatId=0
    f  s PivaCatId=$o(^PHCPIVACAT(PivaCatId)) q:PivaCatId=""  d
    .q:'$d(^PHCPIVACAT(PivaCatId))
    .s PivaCatDesc=$p(^PHCPIVACAT(PivaCatId),"^",2)
    .s Data=PivaCatId_"^"_PivaCatDesc
    .s Count=Count+1
    .i (Count>Start)&(Count<=End) d
    ..d json.InsertRowData(Data)
    .
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// Description: 获取所有可用类组
/// Input:  	 类组类型(G,M)
/// Output: 	 String "RowId
/// w ##class(web.DHCST.Util.DrugUtil).GetStkCatGroupRowId("G")
ClassMethod GetStkCatGroupRowId(Type As %String)
{
    n (Type)
    q:Type="" ""
    s retIdStr=""
    s slcg=0
    f  s slcg=$o(^DHCSCG(slcg)) q:slcg=""  d
	.q:$p($g(^DHCSCG(+slcg)),"^",3)'=Type
	.s retIdStr=$s(retIdStr="":slcg,1:retIdStr_"^"_slcg)
	q retIdStr
}

/// Decription:取药品的科室库存批次信息(只取与单位相关信息，价格，库存)
/// Creator:yangsj
/// CreateDate:2021-04-16
/// Input:incilb , uom
/// Output:
/// Table:
/// Debugger: w ##class(web.DHCST.Util.DrugUtil).GetIncilbInfo("3194||7||1","2")
ClassMethod GetIncilbInfo(inclb, uom)
{
	n (inclb,uom)
	//s ^YSJTMP("GetIncilbInfo")=$LB(inclb,uom)
	q:inclb="" ""
	s InciDr = $P(inclb,"||",1)
	s chl 	 = $P(inclb,"||",2)
	s lb 	 = $P(inclb,"||",3)
    s Incib  = $p(^INCI(InciDr,"IL",chl,"LB",lb),"^",1)
    s Incil  = InciDr_"||"_chl
    s loc 	 = $P(^INCI(InciDr,"IL",chl),"^",1)
    s BUom	 = $p(^INCI(InciDr,1),"^",10)
    s PUom	 = $p(^INCI(InciDr,3),"^",6)
    q:(uom'=BUom)&&(uom'=PUom) ""
    s Date 	 = +$h
    S HospID = $P(^CTLOC(loc),"^",22)
    s Sp	 = ##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,"","")
    s Rp 	 = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,"",+$h,"")
    s Sp	 = $fn(Sp,"N")
    s Rp	 = $fn(Rp,"N")
    s InclbQty = ##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLBURid(inclb,uom)
    s DirtyQty =##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(inclb,uom)
    s AvaQty = InclbQty - DirtyQty
    d ##Class(PHA.COM.Number).FormatSqAll(HospID,.InclbQty,.DirtyQty,.AvaQty)
    s Data   = $LTS($LB(Sp,Rp,InclbQty,DirtyQty,AvaQty),"^")
    
    q Data
}

}
