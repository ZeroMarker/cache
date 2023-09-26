Import sqluser

Class web.DHCST.IncItmRcp Extends (%RegisteredObject, %XML.Adaptor, StkTypeG)
{

Parameter AppName [ Final ] = "DHCSTInManuOrder";

/// creator: 	zhaozhiduan
/// createdate: 2018-07-21
/// description:获取制剂药品信息表格,仅显示
/// w ##class(web.DHCST.IncItmRcp).JsGetIncItm("50",1,"^^12312312312312321321323232^Y")
ClassMethod JsGetIncItm(rows, page, inputStr, logLoc = "")
{
	s getRet=..GetIncItm(rows, page, inputStr,logLoc)
	s pid=$p(getRet,"^",1)
	s total=$p(getRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   	s title1="Inci^InciCode^InciDesc^Spec^Manf"
    s title2="Sp^Rp^Uom^Form^GenName"
    s title3="StkCat"
    s title=title1_"^"_title2_"^"_title3
    s count=0
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItmData",pid,outputI)) q:outputI=""  d
	.s outputData=^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItmData",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	k ^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItmData",pid)
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"DHCST")
}

ClassMethod GetIncItm(rows, page, inputStr, logLoc = "")
{
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1
	s Inci=$p(inputStr,"^",1)
	s StkCatId=$p(inputStr,"^",2)
	s incAlias=$p(inputStr,"^",3)
	s InManuFlag=$p(inputStr,"^",4)
	s hospId=""
	i logLoc'="" s hospId=$p(^CTLOC(logLoc),"^",22)
	s pid=..NewPid()
	s num=0
	i +Inci'=0 d
	.d GetIncItmData
	e  d
	.s Inci=0
	.f  s Inci=$o(^INCI(Inci)) q:+Inci=0  d
	..d GetIncItmData
	..
	
	s count=0
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItm",pid,outputI)) q:outputI=""  d
	.s count=count+1
	.q:count<StartRow
    .q:count>EndRow
    .s tmpData=^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItm",pid,outputI)
    .s ^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItmData",pid,outputI)=tmpData
    k ^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItm")
	q pid_"^"_num
GetIncItmData
	s incStkCat=$p(^INCI(Inci,2),"^",2)
	q:(StkCatId'="")&&(StkCatId'=incStkCat)
	s stkCatType=$p($g(^INC("SC",+incStkCat)),"^",3)
	s GrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s stkCatType=$p(GrpStr,"^",3)
	q:stkCatType'="G"
	s StkCatDesc=##class(PHA.COM.Data.Base).StkCatDesc(incStkCat)  
	q:(incAlias'="")&&(+##class(web.DHCST.INCALIAS).CheckIncAliasExist(Inci,incAlias)<0)
	q:(InManuFlag="Y")&('$d(^INCI(Inci,"REC")))
	s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",Inci,hospId) //医院级别授权
	q:flag="N"
	s incDesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
    s incCode=##class(PHA.COM.Data.Base).InciCode(Inci)
    s incSpec=##class(PHA.COM.Drug).GetSpec(Inci)
	s arcItm=$p(^INCI(Inci,1),"^",3)
	q:+arcItm=0
	s NotUse=$p(^INCI(Inci,2),"^",9)
	q:NotUse="Y"
	s puom=$p(^INCI(Inci,3),"^",6)
	s puomdesc=##class(PHA.COM.Data.Base).UomDesc(puom)
	s arcSub=+arcItm,arcVer=+$p(arcItm,"||",2)
	s phcdRowId=$p(^ARCIM(arcSub,arcVer,1),"^",12) 
	s manfStr=##class(PHA.COM.Drug).GetManf(+Inci)
    s manfDesc=$lg(manfStr,3)
	s SalePrice=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,+$h,puom,hospId,"G","")
	s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,+$h,puom,hospId,"G","")
	s GeneInfo =##class(PHA.COM.Drug).GetGeneric(Inci)
	s Gene=$lg(GeneInfo,3)
	s FormInfo=##class(PHA.COM.Drug).GetForm(Inci)
	s FormDr=$lg(FormInfo,1)
	s Form=$lg(FormInfo,3)
	s num=num+1
	s SalePrice=..ChangVal(SalePrice,"FmtSP")
	s LastReailPrice=..ChangVal(LastReailPrice,"FmtRP")
	s ^TMP("DHCST","web.DHCST.IncItmRcp","GetIncItm",pid,Inci)=Inci_"^"_incCode_"^"_incDesc_"^"_incSpec_"^"_manfDesc_"^"_SalePrice_"^"_LastReailPrice_"^"_puomdesc_"^"_Form_"^"_Gene_"^"_StkCatDesc
}

/// 制剂信息查询--------------------------------------------------------------
/// Creator			zhaozhiduan
/// CreatDate		2018-06-27
/// Description		获取制剂信息
/// Table			INC_itmRcp
/// Input			库存项id
/// OutPut 
/// Other			d ##class(web.DHCST.IncItmRcp).GetIncItmRcp(2003)
ClassMethod GetIncItmRcp(Inci) As %Library.String
{
	s Start=1
	s Title="InRec^QtyManuf^UomId^Uom^Creator^UpdUser^CreatDate^UpdDate^InrecDesc^Remark^Ratio^ExpDate^AddCost" 
	s count=0
	s chl=""
	f  s chl=$o(^INCI(Inci,"REC",chl)) q:chl=""  d
	.s count=count+1
	i count=0 w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q:count=0 ""
	s num=0
	s chl=0
	f  s chl=$o(^INCI(Inci,"REC",chl)) q:chl=""  d
	.s data=^INCI(Inci,"REC",chl)
	.s inrec=Inci_"||"_chl
	.s uomdr=$p(data,"^",1)    //单位
	.s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uomdr)
	.s qty=$p(data,"^",2)      //数量
	.s creator=$p(data,"^",5)
	.s upduser=$p(data,"^",8) 
	.i creator'="" s creator=##class(PHA.COM.Data.Base).UserName(creator)	//$p(^SSU("SSUSR",creator),"^",2)
	.i upduser'="" s upduser=##class(PHA.COM.Data.Base).UserName(upduser)	//$p(^SSU("SSUSR",upduser),"^",2) 
	.s upddate=$p(data,"^",9)
	.s creatdate=$p(data,"^",6)
	.i upddate'="" s upddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(upddate)
	.i creatdate'="" s creatdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(creatdate)
	.s InrecDesc=##class(web.DHCST.IncItmRcp).GetIncRcpDesc(inrec) 
	.s Remark=$g(^INCI(Inci,"REC",chl,"REM",1))    //$LTS(^INCI(Inci,"REC",chl,"REM"))
	.s ExpDate=$p(data,"^",14) 
	.s AddCost=$p(data,"^",15) 
	.s dhcinrec=$o(^DHCINREC(0,"INREC",inrec,""))
	.s Ratio=""
	.i dhcinrec'=""  d
	..s Ratio=$p(^DHCINREC(dhcinrec),"^",2)
	.s num=num+1
	.s OutData=inrec_"^"_qty_"^"_uomdr_"^"_uomdesc_"^"_creator_"^"_upduser_"^"_creatdate_"^"_upddate_"^"_InrecDesc_"^"_Remark_"^"_Ratio_"^"_ExpDate_"^"_AddCost
	.i num=Start d	
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(num)
	..s retstring=##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutData,"^")
	..w retstring
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutData,"^")
	q:num=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
 	w "]}"
	q ""
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-27
/// Description		获取制剂原料信息
/// Table			INC_itmRcp，INC_ItmRecIngr
/// Input			INC_itmRcp表id
/// OutPut 
/// Other			w ##class(web.DHCST.IncItmRcp).GetIncItmRecIngr("1922||1")
ClassMethod GetIncItmRecIngr(Inrec) As %Library.String
{
	q:Inrec="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s Inci=+Inrec
	s chl=$p(Inrec,"||",2)
	
	s Start=1
	s Title="InRin^InRinInci^InRinCode^InRinDesc^InRinQty^InRinUomId^InRinUom" 
	s count=0
	s ing=""
	f  s ing=$o(^INCI(Inci,"REC",chl,"ING",ing)) q:ing=""  d
	.s count=count+1
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s num=0
	s ing=0
	f  s ing=$o(^INCI(Inci,"REC",chl,"ING",ing)) q:ing=""  d
	.s data=^INCI(Inci,"REC",chl,"ING",ing)
	.s InRin=Inci_"||"_chl_"||"_ing
	.s InRinInci=$p(data,"^",1)    //库存
	.s Incidesc=##class(PHA.COM.Data.Base).InciDesc(InRinInci)
	.s Incicode=##class(PHA.COM.Data.Base).InciCode(InRinInci)
	.s uomdr=$p(data,"^",3)    
	.s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uomdr)
	.s qty=$p(data,"^",2)      //数量
	.s qty=..ChangVal(qty,"Qty")  //格式化数量
	.s num=num+1
	.s OutData=InRin_"^"_InRinInci_"^"_Incicode_"^"_Incidesc_"^"_qty_"^"_uomdr_"^"_uomdesc
	.i num=Start d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(count)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutData,"^")
	
 	w "]}"
	q ""
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-28
/// Description		保存制剂信息
/// Table			INC_itmRcp
/// Input			库存项id，INC_itmRcp表id^数量^单位^备注，用户id
/// OutPut 
/// Other			更新	w ##class(web.DHCST.IncItmRcp).SaveInRcp(1,"1||1^1^12^0.9%氯化钠注射液(大冢)(500ml/袋)^手套2副，棉球一堆^^6",1)
/// 				插入	w ##class(web.DHCST.IncItmRcp).SaveInRcp(2003,"^2^42^归去来兮辞^田园将芜胡不归",1)
ClassMethod SaveInRcp(Inci, ListData, User)
{
	q:Inci="" -1_"^"_"无库存项！"
	s ErrStr=""
	s num=0
    //s InRcpName=$p(^INCI(Inci,1),"^",2)
	s IncDesc=$p(^INCI(Inci,1),"^",2)
	s Len=$l(ListData,"!!")
	f i=1:1:Len  d
	.s ErrInfo=""
    .s RcpData=$p(ListData,"!!",i)
	.s Inrec=$p(RcpData,"^",1)
	.s InRcpQty=$p(RcpData,"^",2)       //数量
	.s InRcpUom=$p(RcpData,"^",3)		//单位
	.s InRcpName=$p(RcpData,"^",4)	
	.;i InRcpName="" s InRcpName=IncDesc
	.s Remark=$p(RcpData,"^",5)			//备注
	.s Ratio=$p(RcpData,"^",6)			//制剂成本系数
	.s Months=+$p(RcpData,"^",7)			//制剂生成时界面默认时间(yue)
	.s AddCost=+$p(RcpData,"^",8)	    //制剂生成时界面默认附加费用
	.i AddCost=0 s AddCost=""
	.i Months=0 s Months=""
	.s Remark=$lfs(Remark)				//转换成list 的备注                  //lts 解析list
	.i +InRcpQty<=0 s ErrInfo="数量不能为空或者零或者小于零！"
	.e  i InRcpUom="" s ErrInfo="单位不能为空！"
	.i ErrInfo'="" d
	..i ErrStr="" s ErrStr=ErrInfo
	..e  s ErrStr=ErrStr_"$$"_ErrInfo
	.q:ErrInfo'="" 
	.i Inrec'="" d
	..s UpdDate=+$h
	..s UpdTime=$p($h,",",2)
	..&sql(UPDATE INC_ItmRcp SET INREC_CTUOM_DR=:InRcpUom,INREC_Qty_Manuf =:InRcpQty,INREC_Date_Updated =:UpdDate,INREC_Time_Updated =:UpdTime,INREC_User_Updated_DR =:User,INREC_Sterile = :Sterile,INREC_Desc =:InRcpName,
			INREC_Remarks =:Remark,INREC_ExpDateMonth=:Months,INREC_AddCost=:AddCost WHERE INREC_RowId=:Inrec)
	..i SQLCODE'=0  d
	...s ret=$$ErrorRecord^DHCSTERROR("Update:INC_ItmRcp",InRcpName,SQLCODE_":"_%msg)
	...s ErrInfo="保存制剂失败,"_SQLCODE
	.e  d
	..s UpdDate=+$h
	..s UpdTime=$p($h,",",2)
	..s CreatDate=+$h
	..s CreatTime=$p($h,",",2)
	..s Sterile="Y"
	..s Chl=$o(^INCI(Inci,"REC",""),-1)+1
	..&sql(INSERT INTO INC_ItmRcp (INREC_ParRef, INREC_Childsub, INREC_CTUOM_DR, INREC_Qty_Manuf, INREC_Remarks, INREC_Date_Created, INREC_Date_Updated, INREC_Time_Created, INREC_Time_Updated, INREC_UserCreat_DR, INREC_User_Updated_DR, INREC_Sterile, INREC_Desc,INREC_ExpDateMonth,INREC_AddCost)
		VALUES (:Inci,:Chl, :InRcpUom, :InRcpQty, :Remark, :CreatDate, :UpdDate, :CreatTime, :UpdTime, :User, :User, :Sterile, :InRcpName,:Months,:AddCost))
	..i SQLCODE'=0  d
    ...s ret=$$ErrorRecord^DHCSTERROR("Insert:INC_ItmRcp",InRcpName,SQLCODE_":"_%msg)
    ...s ErrInfo="保存制剂失败,"_SQLCODE
    ..e  d
    ...s Inrec=$p($g(%ROWID),$c(1))
    .i ErrInfo'="" d
	..i ErrStr="" s ErrStr=ErrInfo
	..e  s ErrStr=ErrStr_"$$"_ErrInfo
	.q:ErrInfo'=""
	.s Ret=..SaveDHCINRec(Inrec,Ratio)
	.i +Ret'=0 s ErrInfo="保存制剂附加信息失败"
	.i ErrInfo'="" d
	..i ErrStr="" s ErrStr=ErrInfo
	..e  s ErrStr=ErrStr_"$$"_ErrInfo
	.q:ErrInfo'=""
	.s num=num+1
	q:num=0 "-2"_"^"_ErrStr
	q:ErrStr'="" "-3"_"^"_ErrStr
	q 0
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-28
/// Description		保存制剂信息
/// Table			DHC_INCitmRcp
/// Input			制剂id，成本加成率
/// OutPut 
ClassMethod SaveDHCINRec(Inrec, Ratio)
{
	q:Inrec="" 0
	q:+Ratio=0 0
	s err=0
	s dhcinrec=$o(^DHCINREC(0,"INREC",Inrec,""))
	i dhcinrec'=""  d
	.s $p(^DHCINREC(dhcinrec),"^",2)=Ratio
	e  d
	.&sql(INSERT INTO DHC_INCItmRcp (INREC_INREC_Dr, INREC_CProfitRatio) VALUES (:Inrec,:Ratio))
	.i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("Insert:DHC_INCItmRcp",Inrec,SQLCODE_":"_%msg)
    ..s err=-101
	q err
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-28
/// Description		删除制剂信息
/// Table			INC_itmRcp
/// Input			INC_itmRcp表id
/// OutPut	
/// Other			删除	w ##class(web.DHCST.IncItmRcp).DeleteInRcp("2003||2")
ClassMethod DeleteInRcp(InRec)
{
	q:InRec="" "-1"_"^"_"无有制剂信息！"
	s Ret=0
	&sql(DELETE FROM INC_ItmRcp WHERE INREC_RowId =:InRec )
	i SQLCODE=0 d
	.s dhcinrec=$o(^DHCINREC(0,"INREC",InRec,""))
	.i dhcinrec'=""  d
	..&sql(DELETE FROM DHC_INCItmRcp WHERE INREC_INREC_Dr =:InRec )
	..i SQLCODE=0 d 
	...s Ret=SQLCODE_"^"_"删除制剂附加信息失败！"
	e  d
	.s Ret=SQLCODE_"^"_"删除制剂失败！"
	q SQLCODE
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-28
/// Description		保存制剂信息
/// Table			INC_itmRcp,INC_ItmRecIngr
/// Input			制剂(INC_itmRcp)id，INC_ItmRecIngr表id^库存项id^数量^单位，用户id
/// OutPut 
/// Other			更新	w ##class(web.DHCST.IncItmRcp).SaveInRecIngr("707||3","707||3||1^1263^1.6^21^硼酸粉(燕京)(500g/袋)",1)
/// 				插入	w ##class(web.DHCST.IncItmRcp).SaveInRecIngr(2003||1,"^2^42^手套1双",1)
ClassMethod SaveInRecIngr(InRec, ListData, User)
{
	q:InRec="" -1_"^"_"无库存项！"
	s Inci=+InRec
	s Chl=$p(InRec,"||",2)
	s InRecName=$p(^INCI(Inci,"REC",Chl),"^",12)
	s ErrStr=""
	s num=0
	s Len=$l(ListData,"!!")
	f i=1:1:Len  d
	.s ErrInfo=""
    .s RecIngrData=$p(ListData,"!!",i)
    .s InRin=$p(RecIngrData,"^",1)
    .s InRInInci=$p(RecIngrData,"^",2)
    .s Qty=$p(RecIngrData,"^",3)
    .s Uom=$p(RecIngrData,"^",4)
    .s Desc=$p(RecIngrData,"^",5)
    .b ;33
    .i (+InRInInci=0)||('$d(^INCI(+InRInInci,1)))  s ErrInfo="第"_i_"行,原料不存在！"
    .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InRInInci)
    .s StkType=$p(StkGrpInfo,"^",3)
    .s StkType=$lfs(StkType)
    .s UpdDate=+$h
	.s UpdTime=$p($h,",",2)
	.b
	.i +Qty=0 s ErrInfo="第"_i_"行,原料数量不能为空或者零！"
	.i Uom="" s ErrInfo="第"_i_"行,原料单位不能为空！"
	.i ErrInfo'="" d
	..i ErrStr="" s ErrStr=ErrInfo
	..e  s ErrStr=ErrStr_"$$"_ErrInfo
	.q:ErrInfo'="" 
	.i InRin'="" d
	..&sql(UPDATE INC_ItmRecIngr SET INRIN_INCI_DR = :InRInInci, INRIN_UOM_DR =:Uom,INRIN_User_Updated_DR=:User, 
		   INRIN_Date_Updated =:UpdDate, INRIN_Time_Updated =:UpdTime, INRIN_Qty=:Qty,INRIN_Remarks=:StkType WHERE INRIN_RowId=:InRin)
	..i SQLCODE'=0  d
	...s ret=$$ErrorRecord^DHCSTERROR("Update:INC_ItmRecIngr",InRecName,SQLCODE_":"_%msg)
	...s ErrInfo="第"_i_"行,保存原料失败,"_SQLCODE
	.e  d
	..s ing=$o(^INCI(Inci,"REC",Chl,"ING",""),-1)+1
	..&sql(INSERT INTO INC_ItmRecIngr (INRIN_ParRef,INRIN_Childsub,INRIN_INCI_DR,INRIN_UOM_DR,INRIN_User_Updated_DR,INRIN_Date_Updated,INRIN_Time_Updated,INRIN_Qty,INRIN_Remarks)
		 VALUES (:InRec,:ing,:InRInInci,:Uom,:User,:UpdDate,:UpdTime,:Qty,:StkType))
	..i SQLCODE'=0  d
    ...s ret=$$ErrorRecord^DHCSTERROR("Insert:INC_ItmRecIngr",InRecName,SQLCODE_":"_%msg)
    ...s ErrInfo="第"_i_"行,保存制剂失败,"_SQLCODE
    ..e  d
    ...s Inrec=$p($g(%ROWID),$c(1))
    .i ErrInfo'="" d
	..i ErrStr="" s ErrStr=ErrInfo
	..e  s ErrStr=ErrStr_"$$"_ErrInfo
	.q:ErrInfo'=""
	.s num=num+1
	q:num=0 "-2"_"^"_ErrStr
	q:ErrStr'="" "-3"_"^"_ErrStr
	q 0
}

/// Creator			zhaozhiduan
/// CreatDate		2018-06-28
/// Description		删除制剂信息
/// Table			INC_itmRecIngr
/// Input			INC_itmRecIngr表id
/// OutPut	
/// Other			删除	w ##class(web.DHCST.IncItmRcp).DeleteInRecIngr("2003||1||1")
ClassMethod DeleteInRecIngr(InRin)
{
	q:InRin="" "-1"_"^"_"无有制剂原料信息！"
	&sql(DELETE FROM INC_itmRecIngr WHERE INRIN_RowId =:InRin )
	q SQLCODE
}

/// Description		-1~1 之间的补0
/// w ##class(web.DHCST.IncItmRcp).ChangVal(0.1)
ClassMethod ChangVal(val, Type = "")
{
	i Type="" s Type="FmtRP"
	s hospId=""
	s ret=+##class(web.DHCST.Common.AppCommon).DecLenByFmtType(Type,hospId)
	s len=$l($p(val,".",2))
	q:(len>ret)||(Type="Qty") $fn(val,"",len)
	q $fn(val,"",ret)
}

/// w ##class(web.DHCST.IncItmRcp).GetIncRcpDesc()
ClassMethod GetIncRcpDesc(incRcpId)
{
	q:(incRcpId = "") ""
	s inci = +incRcpId
	q ##class(PHA.COM.Data.Base).InciDesc(inci)
	;s desc = $p($g(^INCI(+incRcpId, "REC", $p(incRcpId, "||", 2))), "^", 12)
	;q ##class(PHA.FACE.IN.Com).GetTransDesc("User.INCItm", "INCIDesc", "", desc)
}

}
