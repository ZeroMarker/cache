Import sqluser

/// Descript:临床药学服务平台  药品信息工具类
Class web.DHCSTPHCMStkOrgUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:产地
/// W ##Class(web.DHCSTPHCMStkOrgUtil).GetPhManufacturer("M")
ClassMethod GetPhManufacturer(Input As %String) As %String
{
	n (Input)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select a.PHMNF_RowId,a.PHMNF_Name from ph_manufacturer a left join DHC_Manf_AddionInfo b "_
    "on a.phMnf_rowid=b.MANF_PhcManf_DR where b.MANF_Type="_"'"_"G"_"'"_" and b.MANF_Active='Y' and a.PHMNF_Name like '%"_Input_"%' ORDER BY PHMNF_RowId"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s manfId = result.Data("PHMNF_RowId")
		s manfDesc = result.Data("PHMNF_Name")
		s tmp=manfId_"^"_manfDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:单位
/// W ##Class(web.DHCSTPHCMStkOrgUtil).GetItmUom("")
ClassMethod GetItmUom(ItmRowid As %String) As %String
{
	n (ItmRowid)
    q:ItmRowid="" ""
    q:'$d(^INCI(ItmRowid)) ""
    s BUomId=$p(^INCI(ItmRowid,1),"^",10)
    s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
    s PurUomId=$p(^INCI(ItmRowid,3),"^",6)
    s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
    ;
    w "["
    s ListData=BUomId_"^"_BUomDesc
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",ListData)
	s ListData=PurUomId_"^"_PurUomDesc
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",ListData)
	w "]"
	q ""
}

/// Descript:批次效期
/// W ##Class(web.DHCSTPHCMStkOrgUtil).QueryBatExp("")
ClassMethod QueryBatExp(LocID As %String, Inci As %String) As %String
{
	n (LocID, Inci)
	
	q:LocID="" ""
    q:Inci="" ""
    q:'$d(^INCI(Inci)) ""
  	s ch=$o(^INCI("IL_LOC",LocID,Inci,""))
  	q:ch="" ""
  	w "["
  	s count = 0
   	s lb=0
 	f  s lb=$o(^INCI(Inci,"IL",ch,"LB",lb)) q:lb=""  d
  	.s phyqty=$P(^INCI(Inci,"IL",ch,"LB",lb),"^",2)
  	.q:phyqty<=0
  	.s incib=$p(^INCI(Inci,"IL",ch,"LB",lb),"^",1)
    .s BatNo=$p(^INCI(Inci,"IB",$p(incib,"||",2)),"^",1)
    .s ExpDate=$p(^INCI(Inci,"IB",$p(incib,"||",2)),"^",2)
    .s:ExpDate'="" ExpDate=$zd(ExpDate,3)
    .s BatExp=BatNo_"~"_ExpDate
  	.s inclb=Inci_"||"_ch_"||"_lb
	.s tmp=inclb_"^"_BatExp
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
	/*
	q:Inci="" ""
    q:'$d(^INCI(Inci)) ""
  	w "["
  	s count = 0
   	s ch=0
 	f  s ch=$o(^INCI(Inci,"IB",ch)) q:(ch="")||(count>9)  d
    .s BatNo=$p(^INCI(Inci,"IB",ch),"^",1)
    .s ExpDate=$p(^INCI(Inci,"IB",ch),"^",2)
    .s:ExpDate'="" ExpDate=$zd(ExpDate,3)
    .s BatExp=BatNo_"~"_ExpDate
  	.s incib=Inci_"||"_ch
	.s tmp=incib_"^"_BatExp
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
	*/
}

}
