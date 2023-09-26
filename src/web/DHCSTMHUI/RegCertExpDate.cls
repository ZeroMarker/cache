Import sqluser

Class web.DHCSTMHUI.RegCertExpDate Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Inheritance = right, Not ProcedureBlock ]
{

/// 取注册证效期报警的库存项目列表 (json)
/// Author:
/// Date:2016-04-26
/// Argu:
///  Start -
///  Limit-
///  Sort-
///  Dir-
///  StrPar-
/// d ##class(web.DHCSTMHUI.RegCertExpDate).jsRegCertOfExp("1","15","","","{""PhaLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""EndDate"":""2020-09-07"",""StkGrpId"":"""",""StkCat"":"""",""ZeroFlag"":"""",""NotUseFlag"":"""",""ZeroMonth"":""Y"",""OneMonth"":"""",""TwoMonth"":"""",""ThreeMonth"":"""",""FourMonth"":"""",""FiveMonth"":"""",""SixMonth"":"""",""SevenMonth"":"""",""EightMonth"":"""",""NineMonth"":"""",""TenMonth"":"""",""ElevenMonth"":"""",""TwelveMonth"":"""",""Normal"":"""",""Zeromonth"":"""",""Onemonth"":"""",""Twomonth"":"""",""Threemonth"":"""",""Fourmonth"":"""",""Fivemonth"":"""",""Sixmonth"":"""",""Sevenmonth"":"""",""Eightmonth"":"""",""Ninemonth"":"""",""Tenmonth"":"""",""Elevenmonth"":"""",""Twelvemonth"":""""}","","0")
ClassMethod jsRegCertOfExp(page As %String, rows As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "", RestMon As %String) As %String
{
 n (page, rows, Sort, Dir, StrPar, User,RestMon)
 s Start=(page-1)*rows
 s Limit=rows
 s RtnObj=##class(RtnObj).%New()
 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 s Sc=PJObj.%FromJSON(StrPar)
 i Sc'=0 d
 .s Sc=RtnObj.Err(-1,"","入参解析失败!")
 q:RtnObj.success'=0 RtnObj.Json()  
 s Loc=PJObj.%Get("PhaLoc")
 s refDate=PJObj.%Get("EndDate")  //效期参照日期(一般是当前日期)
 s:refDate'="" refDate=..DH2L(refDate)
 s RestMonth=RestMon  //相对于参照日期之后的月数(就是说即将RestMonth月后过期)
 ;s ZeroStkFlag=$p(StrPar,"^",4)   //包含零库存标志
 s INCSC=PJObj.%Get("StkCat")  //库存分类rowid
 s IncludeNotUseFlag=PJObj.%Get("NotUseFlag")   //是否排除"不可用"项
 s StkGrpId=PJObj.%Get("StkGrpId")
 s gHospId=..sssHospId(Loc)
 s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),Loc,StkGrpId,gHospId)
 s result=##class(%Library.ResultSet).%New("web.DHCSTMHUI.RegCertExpDate:RegCertOfExp")
 s sc=result.Execute(Loc,refDate,RestMonth,INCSC,IncludeNotUseFlag,StkGrpId)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end   
  d json.InsertRowData(tmp)
 }
 d result.Close()
 d json.getJsonData(colNameStr,count)
 k json
 Q ""
}

/// 检索效期查看要求的科室库存项目列表
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Loc      -  科室RowId
///  refDate - 效期参照日期(一般是当前日期)
///  RestMonth - 相对于参照日期之后的月数(即即将RestMonth月后过期)
///  ZeroStkFlag - 零库存批次标志
///  INCSC  - 分类
///  IncludeNotUseFlag -  包含不可用
/// ROWSPEC = "inci:%String,code:%String,desc:%String,spec:%String,incsc:%String,incscDesc:%String,RegCertNo:%String,expDate:%String,warnDays:%String,month:%String")
Query RegCertOfExp(Loc As %String, refDate As %String, RestMonth As %String, INCSC As %String, IncludeNotUseFlag As %String, StkGrpId As %String) As Query(ROWSPEC = "inci:%String,InciCode:%String,InciDesc:%String,Spec:%String,incsc:%String,IncscDesc:%String,RegCertNo:%String,ExpDate:%String,WarnDays:%String,month:%String")
{
}

ClassMethod RegCertOfExpExecute(ByRef qHandle As %Binary, Loc As %String, refDate As %String, RestMonth As %String, INCSC As %String, IncludeNotUseFlag As %String, StkGrpId As %String) As %Status
{
 n (qHandle,Loc,refDate,RestMonth,INCSC,IncludeNotUseFlag,StkGrpId)
  s repid=$I(^CacheTemp)
  s ind=1
  s qHandle=$lb(0,repid,0)
 
 i refDate["-" s refDate=$zdh(refDate,3)
 i refDate["/" s refDate=$zdh(refDate,4)
 
 s sql=" SELECT info_rowid RowID,INFO_INCI_DR inci,INFO_INCI_DR->INCI_Code code,INFO_INCI_DR->INCI_Desc descx,"
 	_"INFO_INCI_DR->INCI_INCSC_DR incsc,INFO_INCI_DR->INCI_INCSC_DR->INCSC_Desc incscDesc,"
 	_"INFO_INCI_DR->INCI_NotUseFlag NotUseFlag,INFO_MatRegCert_DR RegCertId "
 	_" FROM DHC_ItmAddionInfo  "
 
 i INCSC'="" d
 .s sql=sql_" where INFO_INCI_DR->INCI_INCSC_DR"_INCSC
 
 s xrs=##class(%Library.ResultSet).%New()
 s xrs.RuntimeMode=0
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
  s RowID=xrs.Data("RowID")
  s inci=xrs.Data("inci")
  s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
  s RegCertId=xrs.Data("RegCertId")
  s (RegCertNo,expDate)=""
  i RegCertId'="" d
  .s Certinfo=^DHCMRCT(RegCertId)
  .s RegCertNo=$p(Certinfo,"^",12)
  .s expDate=$p(Certinfo,"^",20)
  continue:expDate=""   ;2014-03-24 添加
  s NotUseFlag=xrs.Data("NotUseFlag")
  i IncludeNotUseFlag="Y" continue:NotUseFlag="Y"  
  
  s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s ScgType=$p(StkGrpInfo,"^",3)
  s Scg=$p(StkGrpInfo,"^",5)
  continue:ScgType'=..sssCode()
  
  continue:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
  //continue:expDate<FirstDate
  s dateRange=..GetDateRange(refDate,expDate)
  s flag=##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RestMonth,dateRange,",")
  continue:flag=0   //效期不在要求的日期范围内
  ;continue:expDate>toExpDate   //效期在要求的截止期之后
  
  s warnDays=expDate-refDate   //预警天数(即参照日期n天后到期)，负值表示相对参照日期，已经过期
  //w warnDays,!
  
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s incsc=xrs.Data("incsc")
  s incscDesc=xrs.Data("incscDesc")
  i expDate'="" s expDate=..DL2H(expDate)
  d OutPutRow
 }

 
 Quit $$$OK
OutPutRow
  s Data=$lb(inci,code,desc,spec,incsc,incscDesc,RegCertNo,expDate,warnDays,dateRange)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 判断该效期是属于哪个过期段
/// Author:zhangdongmei
/// Date:2012-08-13
/// Argu:
///  参考日期，效期 
/// Return:过期段（0：相对于参考日期已经过期；1：相对于参考日期还有一个月过期；）
ClassMethod GetDateRange(RefDate As %String, ExpDate As %String) As %String
{
  n (RefDate,ExpDate)
  q:ExpDate<RefDate 0   ;已经过期
  s DateRange=13        ;距离过期至少在12个月以上
  s Flag=0              ;未找到过期段
  f MonthFlag=1:1:12  q:Flag=1  d
  .
  .s NewRefDate=$p($SYSTEM.SQL.DATEADD("mm",MonthFlag,RefDate)," ")
  .i NewRefDate["-" s NewRefDate=$zdh(NewRefDate,3)
  .i ExpDate<NewRefDate  d
  ..s Flag=1
  ..s DateRange=MonthFlag
  ..
  .
  q DateRange
}

}
