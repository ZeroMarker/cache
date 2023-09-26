Import sqluser

Class web.DHCSTMHUI.DHCUDI Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	条码信息解析
/// Input:		Code(主条码,支持GS1不分段), SCode(次条码)
/// Return：	json格式返回值
/// w ##class(web.DHCSTMHUI.DHCUDI).UDIInfo("01123456789012341723010510ABCD|3010|2106")
/// w ##class(web.DHCSTMHUI.DHCUDI).UDIInfo("0112345678901234","1723010510ABCD|3010|2106")
/// w ##class(web.DHCSTMHUI.DHCUDI).UDIInfo("0112345678901234","+$$4950928223C001LP")
/// w ##class(web.DHCSTMHUI.DHCUDI).UDIInfo("+3456yiop[","+$$4950928223C001LP")
ClassMethod UDIInfo(Code, SCode = "")
{
	n (Code,SCode)
	q:Code="" "{}"
	s FCode=$tr(Code,"（）()","")		;主条码
	s SCode=$tr(SCode,"（）()","")		;次条码
	
	;HIBC不分段的情况
	/*
	i ($e(FCode,1)="+")&&(FCode["/") d
	.i SCode="" s SCode="+"_$p(FCode,"/",2)
	.s FCode=$p(FCode,"/",1)
	*/
	
	;第2段为空的,默认按第1段处理
	s:SCode="" SCode=FCode
	
	i FCode'=SCode d
	.s OrgBarCode=FCode_SCode
	e  d
	.s OrgBarCode=FCode
	s OrgBarCode=$tr(OrgBarCode,"|")
	
	s (InciBarCode,Inci,BatchNo,ExpDate,ProduceDate,SerialNo)=""

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()

	;主条码: 1.如果是HIBC或EAN13,则直接后台取值; 2.否则,按GS1解析
	s Inci=$o(^INCI(0,"BarCode",$$ALPHAUP^SSUTIL4(FCode),""))
	i Inci'="" d
	.s InciBarCode=FCode
	e  d
	.s SplitId=$o(^DHCSPLIT(0,"BarCode",FCode,0))
	.i SplitId'="" d
	..s InciBarCode=FCode
	..s Inci=$p(^DHCSPLIT(SplitId),"^",1)
	.e  d
	..s FCodeObjStr=..GS1Info(FCode)
	..d PJObj.%FromJSON(FCodeObjStr)
	..;s OrgBarCode=PJObj.%Get("OrgBarCode")
	..s InciBarCode=PJObj.%Get("InciBarCode")
	..s Inci=PJObj.%Get("Inci")
	..s ProduceDate=PJObj.%Get("ProduceDate")
	..s SerialNo=PJObj.%Get("SerialNo")
	
	;次条码:
	i $e(SCode,1)="+" d
	.s SCodeStr=..HIBCInfo(SCode)
	.s BatchNo=$p(SCodeStr,"^",1)
	.s ExpDate=$p(SCodeStr,"^",2)
	e  d
	.s SCodeObjStr=..GS1Info(SCode)
	.s Sc=PJObj.%FromJSON(SCodeObjStr)
	.q:Sc'=0
	.s BatchNo=PJObj.%Get("BatchNo")
	.s ExpDate=PJObj.%Get("ExpDate")
	
	s (InciCode,InciDesc)=""
	i Inci'="" d
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	s dataStr=OrgBarCode_"^"_InciBarCode_"^"_Inci_"^"_InciCode_"^"_InciDesc
		_"^"_BatchNo_"^"_ExpDate_"^"_ProduceDate_"^"_SerialNo
	s titleStr="OrgBarCode^InciBarCode^Inci^InciCode^InciDesc"
		_"^BatchNo^ExpDate^ProduceDate^SerialNo"
	s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(dataStr,titleStr)
	q result
}

/// UDI截取信息(GS1规则)
/// Author:XuChao
/// Date:2019-12-3
/// Return:
/// w ##class(web.DHCSTMHUI.DHCUDI).GS1Info("0106921944000021172101101020190111-01210006")
ClassMethod GS1Info(Code) As %String
{
	n (Code)
	;标志符的标准长度,具体代码中可能有出入,但不超过这个长度(比如21序列号,最长是20位)
	s UDI("00")="18"			;器械识别码(DI)
	s UDI("01")="14"			;器械识别码(DI)
	s UDI("10")="20"			;批号
	s UDI("11")="6"				;生产日期
	s UDI("13")="6"				;包装日期(生产日期)
	s UDI("17")="6"				;有效期
	s UDI("21")="20"			;序列号
	s UDI("30")="8"				;整包装数量
	
	//(01)代表器械识别码(DI)、(11)代表生产日期、(17)代表效期、(10)代表批号、(21)代表序列号、(13)包装日期(生产日期)。
	s (OrgBarCode,InciBarCode,Inci,InciCode,InciDesc,BatchNo,ExpDate,ProduceDate,SerialNo,ProduceDate11,ProduceDate13)=""
	s OrgBarCode=$tr(Code,"|")
	while($l(Code)){
		s:$e(Code,1)="|" Code=$e(Code,2,$l(Code))
		s Pre=$e(Code,1,2)
		s Code=$e(Code,3,$l(Code))
		i '$d(UDI(Pre)) q		;如果有标识符识别不到,直接quit,切记不能continue
		
		s ConLen=UDI(Pre)
		s TmpLen=$l($p(Code,"|"))
		i ConLen>TmpLen s ConLen=TmpLen
		s Content=$e(Code,1,ConLen)
		s Code=$e(Code,ConLen+1,$l(Code))
		
		i (Pre="00")||(Pre="01") d
		.s InciBarCode=Pre_Content
		.s SplitId=$o(^DHCSPLIT(0,"BarCode",InciBarCode,""))
		.q:SplitId=""
		.s Inci=$p(^DHCSPLIT(SplitId),"^",1)
		.q:Inci=""
		.s InciCode=$p(^INCI(Inci,1),"^",1)
		.s InciDesc=$p(^INCI(Inci,1),"^",2)
		e  i Pre="11" d
		.s ProduceDate="20"_Content
		.s ProduceDate=$zdh(ProduceDate,5)
		.s ProduceDate=..DL2H(ProduceDate)
		e  i Pre="13" d
		.s ProduceDate13="20"_Content
		.s ProduceDate13=$zdh(ProduceDate13,5)
		.s ProduceDate13=..DL2H(ProduceDate13)
		e  i Pre="17" d
		.s ExpDate="20"_Content
		.s ExpDate=$zdh(ExpDate,5)
		.s ExpDate=..DL2H(ExpDate)
		e  i Pre="10" d
		.s BatchNo=Content
		e  i Pre="21" d
		.s SerialNo=Content
	}
	i (BatchNo'="")&&(SerialNo'="") s BatchNo=BatchNo_"-"_SerialNo
	e  i (BatchNo="")&&(SerialNo'="") s BatchNo=SerialNo
	
	//若(11)和(13)同时出现生产日期以(11)为准
	i (ProduceDate11'="") s ProduceDate=ProduceDate11
	e  i (ProduceDate13'="") s ProduceDate=ProduceDate13
	
	s dataStr=OrgBarCode_"^"_InciBarCode_"^"_Inci
		_"^"_BatchNo_"^"_ExpDate_"^"_ProduceDate_"^"_SerialNo
	s titleStr="OrgBarCode^InciBarCode^Inci"
		_"^BatchNo^ExpDate^ProduceDate^SerialNo"
	s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(dataStr,titleStr)
	q result
}

/// Description:解析HIBC条码
/// Input:		批号效期部分的HIBC条码
/// OutPut:		批号^效期
/// w ##Class(web.DHCSTMHUI.DHCUDI).HIBCInfo("+$$09953C001L7")
ClassMethod HIBCInfo(BatCode As %String) As %String
{
	n (BatCode)
	s FFlag=$e(BatCode,1)
	s SFlag=$e(BatCode,1,2)
	s TFlag=$e(BatCode,1,3)
	s DateStr="",BatchNo=""
	
	s CodeStr=$e(BatCode,1,*-2)
	i TFlag="+$$" {
		s CodeStr=$e(CodeStr,4,*)
		s QtyChar=$e(CodeStr,1)
		i QtyChar=8 d
		.s CodeStr=$e(CodeStr,4,*)
		e  i QtyChar=9 d
		.s CodeStr=$e(CodeStr,7,*)
		
		s ExpFlag=$e(CodeStr,1)
		i ExpFlag=7 d
		.s BatchNo=$e(CodeStr,2,*)
		e  i ExpFlag=6 d
		.;YYJJJHH
		.s CodeStr=$e(CodeStr,2,*)
		.s YYJJJHH=$e(CodeStr,1,7)
		.s BatchNo=$e(CodeStr,8,*)
		.s DateStr=..FormatYYJJJ(YYJJJHH)
		e  i ExpFlag=5 d
		.;YYJJJ
		.s CodeStr=$e(CodeStr,2,*)
		.s YYJJJ=$e(CodeStr,1,5)
		.s BatchNo=$e(CodeStr,6,*)
		.s DateStr=..FormatYYJJJ(YYJJJ)
		e  i ExpFlag=4 d
		.;YYMMDDHH
		.s CodeStr=$e(CodeStr,2,*)
		.s YYMMDDHH=$e(CodeStr,1,8)
		.s BatchNo=$e(CodeStr,9,*)
		.s DateStr=$e(YYMMDDHH,1,2)_"-"_$e(YYMMDDHH,3,4)_"-"_$e(YYMMDDHH,5,6)
		e  i ExpFlag=3 d
		.;YYMMDD
		.s CodeStr=$e(CodeStr,2,*)
		.s YYMMDD=$e(CodeStr,1,6)
		.s BatchNo=$e(CodeStr,7,*)
		.s DateStr=$e(YYMMDD,1,2)_"-"_$e(YYMMDD,3,4)_"-"_$e(YYMMDD,5,6)
		e  i ExpFlag=2 d
		.;MMDDYY
		.s CodeStr=$e(CodeStr,2,*)
		.s MMDDYY=$e(CodeStr,1,6)
		.s BatchNo=$e(CodeStr,7,*)
		.s DateStr=$e(MMDDYY,5,6)_"-"_$e(MMDDYY,1,2)_"-"_$e(MMDDYY,3,4)
		e  d
		.;MMYY
		.q:CodeStr=""				;存在空和非空两种情况
		.s MMYY=$e(CodeStr,1,4)
		.s BatchNo=$e(CodeStr,5,*)
		.s YYMM=$e(MMYY,3,4)_"-"_$e(MMYY,1,2)
		.s DateStr=$e($zd($SYSTEM.SQL.LASTDAY("20"_YYMM_"-01"),3),3,10)
	} elseif (SFlag="+$") {
		s CodeStr=$e(CodeStr,3,*)
		s BatchNo=CodeStr
	} elseif (FFlag="+") {
		;YYJJJ
		s YYJJJ=$e(CodeStr,2,6)
		s BatchNo=$e(CodeStr,7,*)
		s DateStr=..FormatYYJJJ(YYJJJ)
	}

	i DateStr'="" d
	.s DateStr="20"_DateStr

	q BatchNo_"^"_DateStr
}

/// JJJ表示一年中的第几天
/// w ##class(web.DHCSTMHUI.DHCUDI).FormatYYJJJ("05003")
ClassMethod FormatYYJJJ(YYJJJ)
{
	n (YYJJJ)
	s yy=$e(YYJJJ,0,2)
	q:yy="" ""
	s day=$e(YYJJJ,3,5)
	q:day="" ""
	s lastyear = yy - 1
	i $l(lastyear)=1 d
	.s lastyear="0"_lastyear
	s lastYMD="20"_lastyear_"-12-31"
    
	s lastYMD=$zdh(lastYMD,3)+day
	s result=$zd(lastYMD,3)
	s result=$e(result,3,$l(result))
	q result
}

ClassMethod SaveInciMainBarCode(ListData As %String) As %String
{
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	s RtnObj=##class(RtnObj).%New()
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Err=""
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		s SciRowid=ItmObj.%Get("SCIRowid")
		i SciRowid="" d
		.s Sc=RtnObj.Err(-1,"","SCIRowid不允许为空!","",0) 
		q:RtnObj.success'=0 
		s IncId=ItmObj.%Get("IncId")
		s Barcode=ItmObj.%Get("barcode")   /// 自带条码
		i IncId="" d
		.s Sc=RtnObj.Err(-1,"","物资耗材对照失败!") 
		q:RtnObj.success'=0
		i Barcode="" d
		.s Sc=RtnObj.Err(-1,"","自带条码不允许为空!","",0) 
		q:RtnObj.success'=0
		s rowid=$o(^DHCSPLIT(0,"BarCode",Barcode,""))
		q:rowid'=""
		&sql(select SPLIT_RowId into :splitrowid from DHC_BarCodeSplitInfo where SPLIT_SciDr=:SciRowid)
		i SQLCODE||(splitrowid="") d
		.;charu
		.&sql(insert into DHC_BarCodeSplitInfo(SPLIT_BarCode,SPLIT_SciDr) values (:Barcode,:SciRowid))
		.i SQLCODE'=0 d
		..s Sc=RtnObj.Err(-1,"","自带条码插入失败!") 
		e  d
		.&sql(update DHC_BarCodeSplitInfo set SPLIT_BarCode=:Barcode where SPLIT_SciDr=:SciRowid)
		.i SQLCODE'=0 d
		..s Sc=RtnObj.Err(-1,"","自带条码更新失败!") 
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro 
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	q RtnObj.Json()
}

}
