Import sqluser

/// Descript:临床药学服务平台  药品信息工具类
Class web.DHCSTPHCMStkDrgUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// W ##Class(web.DHCSTPHCMStkDrgUtil).QueryStockDetail("100","1","WSS","",1)
ClassMethod QueryStockDetail(rows As %String, page As %String, Input As %String, StkGrpType As %String, HospID As %String) As %String
{
	N (rows, page, Input, StkGrpType, HospID)
	
	I Input="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Input="" ""
	
	S Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr ="select distinct inca_inci_dr from inc_alias "_
    	"where %ALPHAUP(inca_text) like '"_Input_"' and inca_inci_dr->inci_incsc_dr in "_ 
    	"(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_"G"_"')"
       
    D result.Prepare(sqlStr)
    S sc=result.Execute()
    S err=$$$ISERR(sc)
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q ""
    
    S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    S Num = 0
     While(result.Next()){
	    S InciDr = result.Data("INCA_INCI_DR")
        CONTINUE:'$D(^INCI(InciDr))
         i BDPHospAut="Y"
        {
	        continue:(HospID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciDr,HospID)="N")
	    }
        //CONTINUE:$P(^INCI(TInci,2),"^",9)="Y"
        CONTINUE:..GetItmHospNoUseFlag(InciDr,HospID)="Y"
        s Arcim=##Class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciDr)
        S ArcimDesc=$p(^ARCIM($p(Arcim,"||",1),$p(Arcim,"||",2),1),"^",2)  //lbb  2018.12.3 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
        s DrgFormId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(Arcim)
        CONTINUE:$d(^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid,Arcim))
        S PuomDr=$P(^INCI(InciDr,3),"^",6)            //入库单位ID
        s flag=..JudgeArcimInci(InciDr) //lbb 判断医嘱项和库存项是否一对多
        i flag=1  s Spec="",PuomDesc=""
        e  d
        .S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciDr) //规格
        .S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)               //入库单位描述
        s instru=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(DrgFormId) 
        s instru=$p(instru,"^",2)                           /// 用法
		s duration=""
        s durId=$p($g(^PHCD($p(DrgFormId,"||",1),"DF",$p(DrgFormId,"||",2),1)),"^",8) 
        s:durId'="" duration=$p($g(^PHCDU(durId)),"^",3)			/// 用药疗程
        S InciItem=$P(^INCI(InciDr,1),"^",3)                //编号
        S InciCode=$P(^INCI(InciDr,1),"^",1)                //代码
        S InciDesc=$P(^INCI(InciDr,1),"^",2)                //名称
        S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(InciDr)      //厂家
        S Manfdr=$P(ManfStr,"^",1)                                      //厂家ID
        S ManfCode=$P(ManfStr,"^",2)                                    //厂家代码
        S ManfName=$P(ManfStr,"^",3)                                    //厂家名称
        //S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)                                   //入库单位描述
        S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,PuomDr,HospID,StkGrpType)            //入库单位进价
        S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID,StkGrpType)  //入库单位售价
        S BuomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(InciDr)                   //基本单位串
        S BuomDr=$P(BuomStr,"^",1)                                  //基本单位ID
        i flag=1  S BuomDesc=""                                    //基本单位描述
        e  s BuomDesc=$P(BuomStr,"^",2)
        S bRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BuomDr,HospID,StkGrpType)            //基本单位进价
        S bSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID,StkGrpType)  //基本单位售价
        S BillUomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetArcBuomByInc(InciDr)           //计价单位串
        S BillUomDr=$P(BillUomStr,"^",1)                                //计价单位ID
        i flag=1 S BillUomDesc=""                          //计价单位描述
        e  s BillUomDesc=$P(BillUomStr,"^",2)
        S BillRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BillUomDr,HospID,StkGrpType)      //计价单位进价
        S BillSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID,StkGrpType)    //计价单位售价
        S PhcFormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)                   //剂型串
        S PhcFormCode=$P(PhcFormStr,"^",1)                          //剂型代码
        S PhcFormDesc=$P(PhcFormStr,"^",2)                          //剂型描述
        S GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(InciDr)                 //商品名
        S GeneStr=##Class(web.DHCST.Common.DrugInfoCommon).GetGene(InciDr)                      //通用名
        S GeneCode=$P(GeneStr,"^",1)                                    //通用名代码
        S GeneName=$P(GeneStr,"^",2)                                    //通用名描述
        S PFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)       
        S ListData = InciDr_"^"_InciItem_"^"_InciCode_"^"_ArcimDesc_"^"_Spec_"^"_ManfName_"^"_PuomDesc_"^"_pRp_"^"_pSp_"^"_BuomDesc_"^"_bRp_"^"_bSp_"^"_BillUomDesc_"^"_BillRp_"^"_BillSp_"^"_PhcFormDesc_"^"_GoodName_"^"_GeneName_"^"_PuomDr_"^"_BuomDr_"^"_PFac_"^"_instru_"^"_duration 
        S Num=Num+1
		S ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid,Arcim,Num)=ListData  ////lbb  2018.12.3 增加医嘱id节点，因为医嘱项和库存项存在一对多关系 
    }
    
  	I Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Num="0" ""

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="InciDr^InciItem^InciCode^InciDesc^Spec^Manf^PuomDesc^pRp^pSp^BuomDesc^bRp^bSp^BillUomDesc^BillRp^BillSp^Form^GoodName^GeneName^PuomDr^BuomDr^PFac^instru^duration"
	W ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串

	S quitflag=0
	S Num=0
	s Arcim=""
	F  S Arcim=$o(^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid,Arcim)) Q:(Arcim="")||(quitflag=1)  D
	.S index=""
	.F  S index=$o(^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid,Arcim,index)) Q:(index="")||(quitflag=1)  D
	..S ListData=^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid,Arcim,index)
	..S Num=Num+1
	..Q:Num<StPage
	..S:Num=EndPage quitflag=1
	..I Num=StPage D
	...W ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	..Else  D
	...W ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	W ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// 判断医嘱项和库存项是一对多还是一对一 
/// Output: 1：一对多 0：一对一
/// w ##class(web.DHCSTPHCMStkDrgUtil).JudgeArcimInci(4559) 
ClassMethod JudgeArcimInci(InciId As %String)
{
	n (InciId)
	s Arcim=##Class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
	s inci="",inciStr="",flag=0
	f  s inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),inci)) q:inci=""  d
	.i inciStr="" s inciStr=inci
	.e  s inciStr=inciStr_"^"_inci
	s len=$l(inciStr,"^")
	i len>1 s flag=1
	e  s flag=0
	q flag
}

/// Descript:	根据院区取药品停用标志
/// Creater:    bianshuai
/// CreateDate: 2015-11-11
/// Table:		DHC_ItmAddHosp
ClassMethod GetItmHospNoUseFlag(InciId As %String, HospID As %String) As %String
{
	N (InciId, HospID)
	Q:InciId="" ""
	Q:HospID="" ""
	S ItmInfoID=$o(^DHCITMINFO(0,"INCI",InciId,0))
    Q:ItmInfoID="" ""
	S ItmAddHospID=$o(^ITMADDHOP(0,"HospInc",HospID,ItmInfoID,""))
	Q:ItmAddHospID="" ""
	S NoUseFlag=$p(^ITMADDHOP(ItmAddHospID),"^",5)
	Q NoUseFlag
}

/// Descript:	根据院区取医嘱项目数据
/// W ##Class(web.DHCSTPHCMStkDrgUtil).QueryArcItmDetail("100","1","WSS",1)
ClassMethod QueryArcItmDetail(rows As %String, page As %String, Input As %String, HospID As %String) As %String
{
	N (rows, page, Input , HospID,%session)
	I Input="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Input="" ""
	
	S Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	
	S result = ##class(%Library.ResultSet).%New()
    s sqlStr ="select distinct inca_inci_dr from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_Input_"'"
         
    D result.Prepare(sqlStr)
    S sc=result.Execute()
    S err=$$$ISERR(sc)
    If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q ""
    
    S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Num = 0
    While(result.Next())
    {   
        s TInci = result.Data("INCA_INCI_DR")
        CONTINUE:'$D(^INCI(TInci))
        i BDPHospAut="Y"
        {
	        continue:(HospID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",TInci,HospID)="N")
	    }
	    s arcitemId=$p(^INCI(TInci,1),"^",3)
	    s itmmastid=$p(arcitemId,"||",1)
	    s itmmastver=$p(arcitemId,"||",2)
	    continue:+itmmastver=0
        CONTINUE:'$D(^ARCIM(itmmastid,itmmastver))
		s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
		s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
		s ItemCatDR=$p(^ARCIM(itmmastid,itmmastver,1),"^",10) //医嘱子类
		s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)            //医嘱类型
		continue:OrderType'="R"           //lbb  2019/6/21  增加过滤非药品的医嘱
		s arcitmdesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",arcitmdesc)
        s ListData = arcitemId_"^"_arcitmcode_"^"_arcitmdesc
        s Num=Num+1
		s ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryArcItmDetail",pid,Num)=ListData
    }
    
  	I Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Num="0" ""

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	S ListTitle="itmID^itmCode^itmDesc"
	W ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串

	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryArcItmDetail",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryArcItmDetail",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.Else  D
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	W ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:	根据院区取检验项目数据
/// W ##Class(web.DHCSTPHCMStkDrgUtil).QueryLabItmDetail("100","1","环孢素",1)
/// W ##Class(web.DHCSTPHCMStkDrgUtil).QueryLabItmDetail("15","1","tjh","")
ClassMethod QueryLabItmDetail(rows As %String, page As %String, Intsdesc As %String, HospID As %String) As %String
{
	n (rows,page,Intsdesc,HospID)
	i Intsdesc="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Intsdesc="" ""
    s Intsdesc=$zcvt(Intsdesc,"U")
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s Num=0
 	s SCode=""
    f  s SCode=$o(^dbo.BTTestCodeI("IndexSCode",SCode)) Q:SCode=""  D //qunianpeng 取检验指标信息
	.s ID=""
	.f  s ID=$o(^dbo.BTTestCodeI("IndexSCode",SCode,ID)) q:ID=""  d
    ..s tsCode=$LIST(^dbo.BTTestCodeD(ID),2)  //代码
    ..s tsDesc=$LIST(^dbo.BTTestCodeD(ID),3)	//描述
    ..s pin=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(tsDesc))
    ..Q:(tsDesc'[Intsdesc)&&(pin'[Intsdesc)
	..s ListData=ID_"^"_tsCode_"^"_tsDesc
		
	..s Num=Num+1
	..s index=tsCode
	..s ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryLabItmDetail",pid,index)=ListData
	.
    
  	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:Num="0" ""

	s maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	
	s ListTitle="itmID^itmCode^itmDesc"
	W ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串

	S quitflag=0
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryLabItmDetail",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryLabItmDetail",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.E  D
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryStockDetail",pid)
	k ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryArcItmDetail",pid)
	k ^TMP("DHCST","web.DHCSTPHCMStkDrgUtil","QueryLabItmDetail",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMStkDrgUtil"))
}

}
