Import sqluser

Class web.DHCST.DHCPay Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPAY";

/// Descript:   保存/生成付款单信息
/// Creater:    gwj
/// CreateDate: 2012-10-8
/// Table:DHC_Pay,DHC_PayItm
/// Input:付款单号,供应商id^付款科室id^建单人^毒麻标志,
/// 明细id^库存项^入库/退货RowId^库存项RowId^入库金额^付款金额^已付款金额^折扣率^结清标志^类型,
/// 明细id^库存项^入库/退货RowId^库存项RowId^入库金额^付款金额^已付款金额^折扣率^结清标志^类型,
/// Output:     
/// Return：成功：入库主表id；
/// -99  ;加锁失败
/// -2   ;生成入库单号失败
/// -3    ;保存入库单失败
/// -4   ;保存付款单主信息失败
/// -5:保存入库单明细失败
/// -7其它：部分明细保存不成功，提示不成功的药品
/// 
ClassMethod Save(MainInfo As %String, StoreId As %String) As %Library.String
{
    n (MainInfo,StoreId)
    
    s appName=..%GetParameter("AppName")
    s dataBlockNum=$o(^TMP(appName,StoreId,""),-1)
    q:+dataBlockNum=0 -100  //没有明细
    //
    tstart
    s $ZT="Error^DHCSTERROR"      ;增加错误处理
    s payven=$p(MainInfo,"^",1)
    s payloc=$p(MainInfo,"^",2) 
    s payusr=$p(MainInfo,"^",3) 
    s poiflg=$p(MainInfo,"^",4)                     
    s PayId=..Update("",payloc,payven,payusr,poiflg)  ;更新付款主表信息
    s:+PayId<0 IngrId=-4   ;
    i +PayId<=0   trollback  k ^TMP(appName,StoreId)
    q:+PayId<=0 IngrId
    
    s Ret=0
    f i=1:1:dataBlockNum  q:Ret'=0  d
    .s ListData=$G(^TMP(appName,StoreId,i))
    .s Ret=##class(web.DHCST.DHCPayItm).Save(PayId,ListData)
    .i Ret'=0 trollback q 
    .
    k ^TMP(appName,StoreId)  //清除临时global
    q:Ret'=0 Ret   ;存在保存失败的明细
    tcommit    ;只要有明细保存成功，则提交事务
    q PayId
}

/// 插入或更新付款单主表记录
/// Author:zhwh 
/// Date:2012-08-27
/// Argu:
///   pay -付款主表rowid
///   loc-科室RowId
///   vendor-供应商RowId
///   user-制单人RowId
/// Return:
///    付款主表记录rowid
///  
ClassMethod Update(pay As %String, loc As %String, vendor As %String, user As %String, poison As %String)
{
 i pay="" d
 .s obj=##class(User.DHCPay).%New()
 e  d
 .s obj=##class(User.DHCPay).%OpenId(pay)
 .d obj.%Reload()
 .
 D obj.PAYAPCVMDRSetObjectId(vendor)
 d obj.PAYCTLOCDRSetObjectId(loc)
 d obj.PAYSSUSRDRSetObjectId(user)
 s obj.PAYPoisonFlag=poison
 s obj.PAYDate=+$H
 s obj.PAYTime=$P($h,",",2)
 s payNo=##class(web.DHCST.Common.AppCommon).GetAppNo(##class(web.DHCST.DHCPay).%GetParameter("AppName"),"",loc)
 s obj.PAYNo=payNo
 
 s sc=obj.%Save()
 s rowid= obj.%Id() 
 q rowid
}

/// 付款主表记录数据串
/// Author:zhwh 
/// Date:2012-08-27
/// Argu:
///   pay-付款主表rowid
/// Return:
///   主表记录数据串("^"分隔)
ClassMethod Select(pay As %String) As %String
{
 
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_Pay where %ID=:pay )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 s userName="",ack1UserName="",ack2UserName=""
 f i=1:1:cnt d
 .
 .i i=5,PLIST(i)'="" s PLIST(i)=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(i),"ST")
 .i i=12,PLIST(i)'="" s PLIST(i)=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(i),"ST")
 .i i=14,PLIST(i)'="" s PLIST(i)=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(i),"ST")
 .i i=15,PLIST(i)'="" s PLIST(i)=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(i),"ST")
 .i i=6,PLIST(i)'="" s PLIST(i)=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(PLIST(i),"ST")
 .
 .i i=7,PLIST(i)'="" s userName=$p($G(^SSU("SSUSR",PLIST(i))),"^",2)
 .i i=16,PLIST(i)'="" s ack1UserName=$p($G(^SSU("SSUSR",PLIST(i))),"^",2)
 .i i=17,PLIST(i)'="" s ack2UserName=$p($G(^SSU("SSUSR",PLIST(i))),"^",2)
 .
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 s result=result_"^"_userName
 s result=result_"^"_ack1UserName
 s result=result_"^"_ack2UserName
 
 ;
 q result
}

/// 返回json格式的一行的记录的值
/// Author:zhwh
/// Date:2012-11-28
/// Argu:
///     pay - 付款单主表rowid
/// Return:
///  付款单记录值串(json格式)
ClassMethod jsSelect(pay As %String) As %String
{
 n (pay)
 s sql="select *,"
 s sql=sql_"pay_ssusr_dr->ssusr_name userName," 
 s sql=sql_"pay_ssusr_ack1->ssusr_name ack1UserName," 
 s sql=sql_"pay_ssusr_ack2->ssusr_name ack2UserName,"
 s sql=sql_"pay_apcvm_dr->apcvm_name vendorName"
 s sql=sql_" from DHC_Pay where %ID="_pay 
 //w sql,!
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s colNameStr=""
 s count=0
 s resultString=""
 s colNum=xrs.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=xrs.GetColumnName(i)  //(xrs.GetColumnName(i),"_")
 .e  s colNameStr=colNameStr_"^"_xrs.GetColumnName(i)
 s json = ##class(Code.JsonObj).%New()
 while (xrs.Next())
 {
   s ret=""
   f i=1:1:colNum d
   .s df=xrs.%GetData(i)
   . 
   .i xrs.GetColumnName(i)="PAY_Date",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="PAY_CheckDate",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="PAY_Date_Ack1",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="PAY_Date_Ack2",df'="" s df=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(df,"ST")
   .i xrs.GetColumnName(i)="PAY_Time",df'="" s df=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(df,"ST")
   .
   .i ret="" s ret=df
   .e   s ret=ret_"^"_df
   .
   s tmp=ret
   s count = count+1
   d json.InsertRowData(tmp)
 }
 s resultString = json.getJsonData(colNameStr,count)
 k json
 d xrs.Close()
 q resultString
}

/// 删除付款主表记录 
/// Author:zhwh 
/// Date:2012-08-27
/// Argu:
///   pay-付款主表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod Delete(pay As %String)
{
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)<0 -99   //锁定
  q:..AllowDel(pay)<0 -100  //检查是否满足删除条件
  s ret=0
  &sql(delete from dhc_pay where %id=:pay)
  i SQLCODE'=0 s ret=-1
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)
  q ret
}

/// 是否允许删除
/// Authro:zhwh 
/// Date:2012-08-27
/// Argu:
/// pay -付款主表rowid
/// Return:
/// 0 - 可以
/// <0 - 不可以
ClassMethod AllowDel(pay As %String)
{
 n (pay)
 &sql(select pay_ack1,pay_ack2,pay_completed into :ack1,:ack2,:comp from dhc_pay where %id=:pay)
 s ack1=$G(ack1),ack2=$G(ack2),comp=$G(comp)
 i ack1="Y" q -1
 i ack2="Y" q -2
 i comp="Y" q -3  //已经完成
 q 0
}

/// 取付款单记录数据串(json)
/// Author:zhwh
/// Date:2012-08-30
/// Argu:
///   Start
///   Limit
///   Sort
///   Dir
///   Data
/// Return:
///  付款单记录数据串(json)
ClassMethod jsDHCPay(Start As %String, Limit As %String, Sort As %String, Dir As %String, Data As %String)
{
 s qPar=Sort_"^"_Dir
 s StartDate=$P(Data,"^",1) //起始日期
 s EndDate=$P(Data,"^",2)  //截止日期
 s Loc=$P(Data,"^",3)   //入库科室rowid
 s Vendor =$P(Data,"^",4)  //供应商rowid
 s Completed=$P(Data,"^",5)   //完成标志
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:DHCPay")
 s sc=result.Execute(qPar,StartDate,EndDate,Loc,Vendor,Completed)
 i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
 d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
 Q ""
}

/// 
/// 检索付款单主记录信息
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///  qPar
///  StartDate -起始日期
///  EndDate-截止日期
///  Loc-科室rowid
///  Vendor-供应商rowid
///  Completed-完成标志
/// Return:
/// 付款记录(付款单主表RowId,付款单号,科室RowId,科室名称,供应商RowId,供应商名称,制单人,制单日期,总金额,采购确认标志,会计确认标志)
Query DHCPay(qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, Vendor As %String, Completed As %String = "") As %Query(ROWSPEC = "pay:%String,payNo:%String,loc:%String,locDesc:%String,vendor:%String,vendorName:%String,payUserName:%String,payDate:%String,payTime:%String,payAmt:%String,ack1:%String,ack1UserName:%String,ack1Date:%String,ack2:%String,ack2UserName:%String,ack2Date:%String,payComp:%String,payMode:%String,checkNo:%String,checkDate:%String,checkAmt:%String,PoisonFlag:%String")
{
}

ClassMethod DHCPayExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, EndDate As %String, Loc As %String, Vendor As %String, Completed As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s Completed=$G(Completed)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:Loc="" $$$OK
 
 s Sort=$P(qPar,"^",1)
 s Dir=$P(qPar,"^",2)
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s orderFieldName=""
 s:Sort="DATE" orderFieldName="payDate"
 s:Sort="VENDOR" orderFieldName="vendorName"
 s:Sort="NO" orderFieldName="payNo"
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"

 s sql="select %ID pay," 
 s sql=sql_"pay_No payNo,"
 s sql=sql_"pay_ctloc_dr loc,"
 s sql=sql_"pay_ctloc_dr->ctloc_desc locDesc,"
 s sql=sql_"pay_apcvm_dr vendor,"
 s sql=sql_"pay_apcvm_dr->apcvm_name vendorName,"
 s sql=sql_"pay_date payDate,"
 s sql=sql_"pay_time payTime,"
 s sql=sql_"pay_ssusr_dr->ssusr_name payUserName,"
 s sql=sql_"pay_ack1 ack1,"
 s sql=sql_"pay_date_ack1 ack1Date,"
 s sql=sql_"pay_ssusr_ack1->ssusr_name ack1UserName,"
 s sql=sql_"pay_ack2 ack2,"
 s sql=sql_"pay_date_ack2 ack2Date,"
 s sql=sql_"pay_ssusr_ack2->ssusr_name ack2UserName,"
 s sql=sql_"pay_completed payComp,"
 s sql=sql_"pay_mode payMode,"
 s sql=sql_"pay_checkno checkNo,"
 s sql=sql_"pay_checkdate checkDate,"
 s sql=sql_"pay_checkamt checkAmt,"
 s sql=sql_"pay_poisonflag poisonflag"
 s sql=sql_ " from dhc_pay where pay_date between "_StartDate_" and "_EndDate
 s sql=sql_" and pay_ctloc_dr="_Loc
 i Vendor'="" d
 .s sql=sql_" and pay_apcvm_dr="_Vendor
 i Completed'="" d
 .s sql=sql_" and nvl(pay_completed,'N')="_"'"_Completed_"'"  //2012-12-16
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 
 s ^xuantmp("aaa")=sql
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) d $System.Status.DisplayError(sc)
 
 i $$$ISERR(sc) q $$$OK
 
 while (xrs.Next())
 {
 s pay=xrs.Data("pay")
 s payNo=xrs.Data("payNo")
 s loc=xrs.Data("loc")
 s locDesc=xrs.Data("locDesc")
 s vendor=xrs.Data("vendor")
 s vendorName=xrs.Data("vendorName")
 s payUserName=xrs.Data("payUserName")
 s payDate=xrs.Data("payDate")
 i payDate'="" s payDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(payDate,"ST")
 
 s payTime=xrs.Data("payTime")
 i payTime'="" s payTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(payTime,"ST")
 s payAmt=..PayAmt(pay)
 s payAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(payAmt,$P(^CTLOC(loc),"^",22))
 s ack1=xrs.Data("ack1")
 s ack1UserName=xrs.Data("ack1UserName")
 s ack1Date=xrs.Data("ack1Date")
 i ack1Date'="" s ack1Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ack1Date,"ST")
 s ack2=xrs.Data("ack2")
 s ack2UserName=xrs.Data("ack2UserName")
 s ack2Date=xrs.Data("ack2Date")
 i ack2Date'="" s ack2Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ack2Date,"ST")
 s payComp   =xrs.Data("payComp")
     
 s payMode=xrs.Data("payMode")
 i payMode'="" &sql(select CTPM_Desc into :payMode From CT_PayMode where %id=:payMode)

 s checkNo=xrs.Data("checkNo")
 s checkAmt=xrs.Data("checkAmt")
 s checkDate=xrs.Data("checkDate")
 i checkDate'="" s checkDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(checkDate,"ST")
 s poisonflag=xrs.Data("poisonflag")
 s ^xuantmp("dad",payNo)=poisonflag
 d OutPutRow1 
 }
 d xrs.Close()
 
 Quit $$$OK
OutPutRow1
 s Data=$lb(pay,payNo,loc,locDesc,vendor,vendorName,payUserName,payDate,payTime,payAmt,ack1,ack1UserName,ack1Date,ack2,ack2UserName,ack2Date,payComp,payMode,checkNo,checkDate,checkAmt,poisonflag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPayExecute ]
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

/// 取付款单的应付金额(总)
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///   pay - 付款主表rowid
/// Return:
///   付款单应付总金额
ClassMethod PayAmt(pay As %String) As %String
{
 n (pay)
 &sql( select sum(payi_payamt) into :amt from dhc_payitm where payi_pay_parref=:pay)
 q $G(amt)
}

/// 取入库明细记录数据串(json)
/// Author:zhwh
/// Date:2012-08-30
/// Argu:
///  Start
///  Limit
///  Sort
///  Dir
///  Data
/// Return:
///  入库明细记录数据串(json)
ClassMethod jsGdRecItmToPay(Start As %String, Limit As %String, Sort As %String, Dir As %String, Data As %String) As %String
{
 s qPar=Sort_"^"_Dir
 s Loc=$P(Data,"^",1)  //科室rowid
 s Vendor=$P(Data,"^",2)  //供应商rowid
 s StartDate=$P(Data,"^",3)  //起始日期
 s EndDate=$P(Data,"^",4)   //截止日期
 s ApprovalReq=$P(Data,"^",5)     //要求批示
 s InvReq=$P(Data,"^",6)  // 要求发票
 
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:GdRecItmToPay")
 s ^zhwh(111)=qPar_"||"_Loc_"||"_Vendor_"||"_StartDate_"||"_EndDate_"||"_ApprovalReq_"||"_InvReq
 s sc=result.Execute(qPar,Loc,Vendor,StartDate,EndDate,ApprovalReq,InvReq)
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取退货明细记录数据串(json)
/// Author:zhwh
/// Date:2012-08-30
/// Argu:
///  Start
///  Limit
///  Sort
///  Dir
///  Data
/// Return:
///   退货明细记录数据串(json)
ClassMethod jsGdRetItmToPay(Start As %String, Limit As %String, Sort As %String, Dir As %String, Data As %String) As %String
{
 s qPar=Sort_"^"_Dir
 s Loc=$P(Data,"^",1)  //科室rowid
 s Vendor=$P(Data,"^",2)  //供应商rowid
 s StartDate=$P(Data,"^",3)  //起始日期
 s EndDate=$P(Data,"^",4)   //截止日期
 s ApprovalReq=$P(Data,"^",5)     //要求批示
 s InvReq=$P(Data,"^",6)  // 要求发票
 
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:GdRetItmToPay")
 s sc=result.Execute(qPar,Loc,Vendor,StartDate,EndDate,ApprovalReq,InvReq)
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 
/// 检索入库明细记录用来制作付款单据
/// Author:zhw h
/// Date:2012-08-29
/// Argu:
///   qPar-排序与排序方向("^")
///   Loc-科室(Not Null)
///   Vendor-供应商(Not Null)
///   StartDate-起始日期(Not Null)
///   EndDate-截止日期(Not Null)
///   ApprovalReq-要求审批
///   InvReq-要求发票
/// Return:
///  入库明细记录(入库单号,入库审核日期,入库审核时间,入库审核人,入库明细RowId,选择,库存批次RowId,药品代码,药品名称,规格,厂商,单位,数量,进价,进价金额,已付款金额,余额 ,本次付款金额,发票号,发票金额,发票日期,随行单号,售价,售价金额,批号,效期
///  d ##Class(%ResultSet).RunQuery("web.DHCST.DHCPay","GdRecItmToPay","^","257","27","20/12/2019","19/1/2020","1","")
Query GdRecItmToPay(qPar As %String, Loc As %String, Vendor As %String, StartDate As %String, EndDate As %String, ApprovalReq As %String, InvReq As %String) As %Query(ROWSPEC = "RowId:%String,No:%String,gdDate:%String,gdTime:%String,gdAuditUserName:%String,ingri:%String,inclb:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,uomDesc:%String,qty:%String,rp:%String,rpAmt:%String,sp:%String,spAmt:%String,payedAmt:%String,restAmt:%String,amt:%String,invNo:%String,invAmt:%String,invDate:%String,sxNo:%String,batNo:%String,expDate:%String,type:%String,poison:%String")
{
}

ClassMethod GdRecItmToPayExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, Vendor As %String, StartDate As %String, EndDate As %String, ApprovalReq As %String, InvReq As %String) As %Status
{
  //s ^YSJTMP("GdRecItmToPay")=$LB(qPar , Loc , Vendor , StartDate , EndDate , ApprovalReq , InvReq)
  s repid=$I(^CacheTemp)
  s ind=1
  s qHandle=$lb(0,repid,0)
  q:Loc="" $$$OK 
  q:StartDate="" $$$OK
  q:EndDate="" $$$OK
  q:Vendor="" $$$OK
  i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate) 
  i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate) 
  s Sort=$p(qPar,"^",1)
  s Dir=$p(qPar,"^",2)
  s Sort=$$ALPHAUP^SSUTIL4(Sort)
  s Dir=$$ALPHAUP^SSUTIL4(Dir)
  s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
  //
  s orderFieldName=""
  s:Sort="VENDOR" orderFieldName="venName"   //供应商
  s:Sort="CODE" orderFieldName="inciCode"  //代码
  s:Sort="NO" orderFieldName="gdNo"  //单据号
  s:Sort="MANF" orderFieldName="manf"  //厂商
  s:Sort="INVNO" orderFieldName="invNo"  //发票号
  //
  s sql="select ingri_ingr_parref ingr,"
  s sql=sql_"ingri_ingr_parref->ingr_no gdNo,"  
  s sql=sql_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name venName," 
  s sql=sql_"ingri_ingr_parref->ingr_date gdDate,"  
  s sql=sql_"ingri_ingr_parref->ingr_time gdTime,"  
  s sql=sql_"ingri_ingr_parref->ingr_ssusr_dr->ssusr_name gdUserName,"  
  s sql=sql_"ingri_rowid ingri,"    
  s sql=sql_"ingri_inclb_dr inclb," 
  s sql=sql_"ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code inciCode,"    
  s sql=sql_"ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc inciDesc,"    
  s sql=sql_"initm_inci_dr inci,"   
  s sql=sql_"initm_phmnf_dr->phmnf_name manf,"  
  s sql=sql_"ingri_inclb_dr->inclb_incib_dr->incib_no batNo,"   
  s sql=sql_"ingri_inclb_dr->inclb_incib_dr->incib_expdate expDate,"    
  s sql=sql_"ingri_ctuom_dr->ctuom_desc uomDesc,"   
  s sql=sql_"ingri_recqty qty,"  
  s sql=sql_"initm_realprice rp,"   
  s sql=sql_"initm_realtotal rpAmt,"    
  s sql=sql_"initm_saleprice sp,"   
  s sql=sql_"initm_spamt spAmt,"    
  s sql=sql_"initm_invno invNo,"    
  s sql=sql_"initm_invdate invDate,"    
  s sql=sql_"initm_invmoney invAmt,"    
  s sql=sql_"initm_sxno sxNo"   
  s sql=sql_" From dhc_ingdrecitm"  
  s sql=sql_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate    
  s sql=sql_" and ingri_ingr_parref->ingr_loc_dr="_Loc  
  s sql=sql_" and ingri_ingr_parref->ingr_apcvm_dr="_Vendor 
  
  i ApprovalReq="1" d
  .s sql=sql_" and ingri_ingr_parref->ingr_payallowed="_"'"_"Y"_"'"
  i InvReq="1" d
  .s sql=sql_" and initm_invno is not null"
  i orderFieldName'="" d
  .s sql=sql_" Order by "_orderFieldName_" "_Dir
  s xrs=##class(%ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute()
  i $$$ISERR(sc) d $System.Status.DisplayError(sc)
  i $$$ISERR(sc) q $$$OK
  
  while (xrs.Next())
  {
  s ingr=xrs.Data("ingr")
  s gdNo=xrs.Data("gdNo")
  s gdDate=xrs.Data("gdDate")
  i gdDate'="" s gdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(gdDate,"ST")
  s gdTime=xrs.Data("gdTime")
  i gdTime'="" s gdTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(gdTime,"ST")
  s gdAuditUserName=xrs.Data("gdUserName")
  s ingri=xrs.Data("ingri")
  continue:..PayOver("G",ingri)   //滤除结清的记录
  s inclb=xrs.Data("inclb")
  s inci=xrs.Data("inci")
  s inciCode=xrs.Data("inciCode")
  s inciDesc=xrs.Data("inciDesc")
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=xrs.Data("manf")
  s uomDesc=xrs.Data("uomDesc")
  s qty=xrs.Data("qty")
  s rp=xrs.Data("rp")
  s rpAmt=xrs.Data("rpAmt")
  s sp=xrs.Data("sp")
  s spAmt=xrs.Data("spAmt")
  s payedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRecItm(ingri)
  s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inci)
  s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
  s restAmt=rpAmt-payedAmt   //当前入库记录剩余应付金额
  continue:(freeDrugFlag'="Y")&&(restAmt'>0)    //待付金额为0
  s amt=""   //本次付款金额
  s invNo=xrs.Data("invNo")
  s invAmt=xrs.Data("invAmt")
  s invDate=xrs.Data("invDate")
  i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
  s sxNo=xrs.Data("sxNo")
  s batNo=xrs.Data("batNo")
  s expDate=xrs.Data("expDate")
  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")   
   
  s poisonstr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
  s poisondesc=$p(poisonstr,"^",1)
  i (poisondesc["毒")||(poisondesc["麻") s poisonmark="Y"
  e  s poisonmark="N"
  d OutPutRow2    
  }
  //========退货查询===================
  d xrs.Close()
  s sql="select ingrti_ingrt_parref ingrt,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_no gdNo,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_apcvm_dr vendor,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name vendorName,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_date createDate,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_time createTime,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_ssusr_dr->ssusr_name createUserName,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_auditdate gdDate ,"
  s sql=sql_" ingrti_ingrt_parref->ingrt_audittime gdTime,"
  s sql=sql_" ingrti_ingrt_parref->INGRT_SSUSR_Audit_DR->ssusr_name gdAuditUserName,"
  s sql=sql_" ingrti_rowid ingrti,"
  s sql=sql_" ingrti_ingri_dr ingri,"
  s sql=sql_" ingrti_retqty retqty," 
  s sql=sql_" ingrti_realprice rp,"
  s sql=sql_" ingrti_saleprice sp,"
  s sql=sql_" ingrti_retuom_dr->ctuom_desc uomDesc,"
  s sql=sql_" ingrti_retamount retamount,"
  s sql=sql_" ingrti_invno invNo,"
  s sql=sql_" ingrti_invamt invAmt,"
  s sql=sql_" ingrti_invdate invDate,"
  s sql=sql_" ingrti_sxno sxNo,"
  s sql=sql_" ingrti_spamt spamt"
  s sql=sql_" From dhc_ingrtitm" 
  s sql=sql_" where ingrti_ingrt_parref->ingrt_date between "_StartDate_" and "_EndDate
  s sql=sql_" and ingrti_ingrt_parref->ingrt_ctloc_dr="_Loc 
  s sql=sql_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_Vendor 
  i ApprovalReq="1" d
  .s sql=sql_" and ingrti_ingrt_parref->ingrt_payallowed="_"'"_"Y"_"'"
  i InvReq="1" d
  .s sql=sql_" and ingrti_invno is not null"
  i orderFieldName'="" d
  .s sql=sql_" Order by "_orderFieldName_" "_Dir
  s xrs=##class(%ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute()
  i $$$ISERR(sc) d $System.Status.DisplayError(sc)
  i $$$ISERR(sc) q $$$OK
  
  while (xrs.Next()){
	  s ingrt=xrs.Data("ingrt")
	  s gdNo=xrs.Data("gdNo")
	  s createDate=xrs.Data("createDate")
	  i createDate'="" s createDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(createDate,"ST")
	  s createTime=xrs.Data("createTime")
	  i createTime'="" s createTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(createTime,"ST")
	  s createUserName=xrs.Data("createUserName")
	  s sxNo=xrs.Data("sxNo")
	  s ingrti=xrs.Data("ingrti")
	  continue:..PayOver("R",ingrti)   //滤除结清的记录
	  s ingri=xrs.Data("ingri")
	  &sql(select ingri_inclb_dr,ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code,
	   ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc,initm_inci_dr,
	   initm_phmnf_dr->phmnf_name,ingri_inclb_dr->inclb_incib_dr->incib_no,
	   ingri_inclb_dr->inclb_incib_dr->incib_expdate into:inclb,:inciCode,:inciDesc,:inci,:manf,
	    :batNo,:expDate  from DHC_INGdRecItm where ingri_rowid=:ingri)  
	  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	  s retqty=xrs.Data("retqty")
	  s rp=xrs.Data("rp")
	  //s rpAmt=rp*retqty
	  s rpAmt=xrs.Data("retamount")
	  s sp=xrs.Data("sp")
	  s spAmt=xrs.Data("spamt")
	  //s spAmt=sp*retqty
	  s payedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRetItm(ingrti)
	  
	  s uomDesc=xrs.Data("uomDesc")
	  s retamount=xrs.Data("retamount")  //退货金额进价
	  s restAmt=retamount-payedAmt   //当前退货记录剩余应付金额
	  s amt=""   //本次付款金额
	  s invNo=xrs.Data("invNo")
	  s invAmt=xrs.Data("invAmt")
	  s invDate=xrs.Data("invDate")  
	  i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
	  s poisonstr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
	  s poisondesc=$p(poisonstr,"^",1)
	  i (poisondesc["毒")||(poisondesc["麻") s poisonmark="Y"
	  e  s poisonmark="N"
	  d OutPutRowRet1
	}
  //========退货查询===================
  Quit $$$OK
OutPutRow2
 d ##Class(PHA.COM.Number).AddZero(.qty,.rp,.rpAmt,.sp,.spAmt,.payedAmt,.restAmt,.amt,.invAmt)
 s Data=$lb(ingr,gdNo,gdDate,gdTime,gdAuditUserName,ingri,inclb,inci,inciCode,inciDesc,spec,manf,uomDesc,qty,rp,rpAmt,sp,spAmt,payedAmt,restAmt,amt,invNo,invAmt,invDate,sxNo,batNo,expDate,"入库",poisonmark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
 
OutPutRowRet1
 
 d ##Class(PHA.COM.Number).OperaAll("*",-1,.rpAmt,.spAmt,.payedAmt,.restAmt,.amt)
 d ##Class(PHA.COM.Number).AddZero(.retqty,.rp,.sp)
 s Data=$lb(ingrt,gdNo,createDate,createTime,gdAuditUserName,ingrti,inclb,inci,inciCode,inciDesc,spec,manf,uomDesc,retqty,rp,rpAmt,sp,spAmt,payedAmt,restAmt,amt,invNo,invAmt,invDate,sxNo,batNo,expDate,"退货",poisonmark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GdRecItmToPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GdRecItmToPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GdRecItmToPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GdRecItmToPayExecute ]
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

/// 设置付款单"完成"标志
/// Author:zhwh
/// Date:2012-08-31
/// Argu:
///  pay - 付款单rowid
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod SetCompleted(pay As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)<0 -99
 s ret=0
 &sql(select pay_completed,pay_ack1,pay_ack2  into :comp,:ack1,:ack2 from dhc_pay where %ID=:pay )
 i SQLCODE'=0 d
 . s ret= -1
 e  d
 . i comp="Y" d
 . . s ret= -2
 . e  d
 . .s yes="Y"
 . . &sql(update dhc_pay set pay_completed=:yes where %ID=:pay)
 . . i SQLCODE'=0 s ret= -3
  
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)
 q ret
}

/// 取消付款单"完成"标志
/// Author:gwj
/// Date:2012-10-08
/// Argu:
///  pay - 付款单rowid
/// Return:
/// 0 - success
/// <0 - failure
ClassMethod CnclCompleted(pay As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)<0 -99
 s ret=0
 &sql(select pay_completed,pay_ack1,pay_ack2  into :comp,:ack1,:ack2 from dhc_pay where %ID=:pay )
 i SQLCODE'=0 d
 . s ret= -1
 e  d
 .i (ack1="Y")!(ack2="Y")  d
 . . s ret=-2 //检查是否有确认信息
 .e  d
 . . s no="N"
 . . &sql(update dhc_pay set pay_completed=:no where %ID=:pay)
 . . i SQLCODE'=0 s ret= -3
  
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)
 q ret
}

/// 
/// 检索退货明细记录用来制作付款单据
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///   qPar-排序与排序方向("^")
///   Loc-科室(Not Null)
///   Vendor-供应商(Not Null)
///   StartDate-起始日期(Not Null)
///   EndDate-截止日期(Not Null)
///   ApprovalReq-要求审批
///   InvReq-要求发票
/// Return:
///  退货明细记录(退货单号,退货审核日期,退货审核时间,退货审核人,退货明细RowId,选择,库存批次RowId,药品代码,药品名称,规格,厂商,单位,数量,进价,进价金额,已付款金额,余额 ,本次付款金额,发票号,发票金额,发票日期,随行单号,售价,售价金额,批号,效期
Query GdRetItmToPay(qPar As %String, Loc As %String, Vendor As %String, StartDate As %String, EndDate As %String, ApprovalReq As %String, InvReq As %String) As %Query(ROWSPEC = "RowId:%String,No:%String,retDate:%String,retTime:%String,retUserName:%String,ingrti:%String,inclb:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,uomDesc:%String,qty:%String,rp:%String,rpAmt:%String,sp:%String,spAmt:%String,payedAmt:%String,restAmt:%String,amt:%String,invNo:%String,invAmt:%String,invDate:%String,sxNo:%String,batNo:%String,expDate:%String,type:%String")
{
}

ClassMethod GdRetItmToPayExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, Vendor As %String, StartDate As %String, EndDate As %String, ApprovalReq As %String, InvReq As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)

 q:Loc="" $$$OK 
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:Vendor="" $$$OK
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate) 
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
  s Sort=$p(qPar,"^",1)
  s Dir=$p(qPar,"^",2)
  s Sort=$$ALPHAUP^SSUTIL4(Sort)
  s Dir=$$ALPHAUP^SSUTIL4(Dir)
  s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
  //
  s orderFieldName=""
  s:Sort="VENDOR" orderFieldName="venName"   //供应商
  s:Sort="CODE" orderFieldName="inciCode"  //代码
  s:Sort="NO" orderFieldName="retNo"  //单据号
  s:Sort="MANF" orderFieldName="manf"  //厂商
  s:Sort="INVNO" orderFieldName="invNo"  //发票号
  //
  
    s sql=" select ingrti_ingrt_parref ingrt,"
    s sql=sql_"ingrti_ingrt_parref->ingrt_no retNo,"
    s sql=sql_"ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name venName,"
    s sql=sql_"ingrti_ingrt_parref->ingrt_auditdate retDate,"
    s sql=sql_"ingrti_ingrt_parref->ingrt_audittime retTime,"
    s sql=sql_"ingrti_ingrt_parref->ingrt_ssusr_audit_dr->ssusr_name retUserName,"
    s sql=sql_"ingrti_rowid ingrti,"
    s sql=sql_"ingrti_ingri_dr->ingri_inclb_dr inclb,"
    s sql=sql_"ingrti_ingri_dr->ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code inciCode,"
    s sql=sql_"ingrti_ingri_dr->ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_desc inciDesc,"
    s sql=sql_"ingrti_ingri_dr->initm_phmnf_dr->phmnf_name manf,"
    s sql=sql_"ingrti_ingri_dr->ingri_inclb_dr->inclb_incib_dr->incib_no batNo,"
    s sql=sql_"ingrti_ingri_dr->ingri_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
    s sql=sql_"ingrti_retuom_dr->ctuom_desc uomDesc,"
    s sql=sql_"ingrti_retqty qty,"
    s sql=sql_"ingrti_realprice rp,"
    s sql=sql_"ingrti_retamount rpAmt,"
    s sql=sql_"ingrti_saleprice sp,"
    s sql=sql_"ingrti_spamt spAmt,"
    s sql=sql_"ingrti_invno invNo,"
    s sql=sql_"ingrti_invdate invDate,"
    s sql=sql_"ingrti_invamt invAmt,"
    s sql=sql_"ingrti_sxno sxNo"
    s sql=sql_" from dhc_ingrtitm "
    s sql=sql_" where ingrti_ingrt_parref->ingrt_auditdate between "_StartDate_" and "_EndDate
    s sql=sql_" and ingrti_ingrt_parref->ingrt_ctloc_dr="_Loc
      s sql=sql_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_Vendor  


   i ApprovalReq="1" d
  .s sql=sql_" and ingrti_ingrt_parref->ingrt_payallowed="_"'"_"Y"_"'"
  i InvReq="1" d
  .s sql=sql_" and ingrti_sxno is not null"
  i orderFieldName'="" d
  .s sql=sql_" Order by "_orderFieldName_" "_Dir

  ;w sql,!
  s xrs=##class(%ResultSet).%New()
  d xrs.Prepare(sql)
  s sc=xrs.Execute()
  i $$$ISERR(sc) d $System.Status.DisplayError(sc)
  i $$$ISERR(sc) q $$$OK
  
  while (xrs.Next())
  {
  s ingrt=xrs.Data("ingrt")
  s retNo=xrs.Data("retNo")
  s retDate=xrs.Data("retDate")
  i retDate'="" s retDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate,"ST")
  s retTime=xrs.Data("retTime")
  i retTime'="" s retTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime,"ST")
  s retUserName=xrs.Data("retUserName")
  s ingrti=xrs.Data("ingrti")
  continue:..PayOver("R",ingrti) 
  s inclb=xrs.Data("inclb")
  s inci=+inclb
  s inciCode=xrs.Data("inciCode")
  s inciDesc=xrs.Data("inciDesc")
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=xrs.Data("manf")
  s uomDesc=xrs.Data("uomDesc")
  s qty=-xrs.Data("qty")  //取负值
  s rp=xrs.Data("rp")
  s rpAmt=-xrs.Data("rpAmt")  //取负值
  s sp=xrs.Data("sp")
  s spAmt=-xrs.Data("spAmt")   //取负值
  s payedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRetItm(ingrti)
  s restAmt=rpAmt-payedAmt   //当前入库记录剩余应付金额
  s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inci)
  s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
  continue:(freeDrugFlag'="Y")&&(restAmt'>0)
  s amt=""   //本次付款金额
  s invNo=xrs.Data("invNo")
  s invAmt=xrs.Data("invAmt")   
  s invDate=xrs.Data("invDate")
  i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
  s sxNo=xrs.Data("sxNo")
  s batNo=xrs.Data("batNo")
  s expDate=xrs.Data("expDate")
  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")      
 
  d OutPutRowRet      
  }
  
  Quit $$$OK
OutPutRowRet
 s Data=$lb(ingrt,retNo,retDate,retTime,retUserName,ingrti,inclb,inci,inciCode,inciDesc,spec,manf,uomDesc,qty,rp,rpAmt,sp,spAmt,payedAmt,restAmt,amt,invNo,invAmt,invDate,sxNo,batNo,expDate,"退货")   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GdRetItmToPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GdRetItmToPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GdRetItmToPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GdRetItmToPayExecute ]
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

/// 取准备生成付款单的入库/退货 明细记录数据串(json)
/// Author:gwj
/// Date:2012-09-27
/// Argu:
///  Start
///  Limit
///  Sort
///  Dir
///  Data
/// Return:
///  入库明细记录数据串(json)
/// w ##class(web.DHCST.DHCPay).jsGdRItmToPay("0","9999","","","257^27^20/12/2019^19/1/2020^44^10213")
ClassMethod jsGdRItmToPay(Start As %String, Limit As %String, Sort As %String, Dir As %String, Data As %String) As %String
{
 
  //s ^YSJTMP("jsGdRecItmToPay")=$LB(Start , Limit , Sort , Dir , Data)

 s qPar=Sort_"^"_Dir
 s Loc=$P(Data,"^",1)  //科室rowid
 s Vendor=$P(Data,"^",2)  //供应商rowid
 s StartDate=$P(Data,"^",3)  //起始日期
 s EndDate=$P(Data,"^",4)   //截止日期
 s ApprovalReq=""     //要求审批
 s InvReq=""  // 要求发票
 ;s ApprovalReq=$P(Data,"^",5)     //要求审批
 ;s InvReq=$P(Data,"^",6)  // 要求发票
 //======审批配置取出=========
 s groupId=$p(Data,"^",5)    //安全组
 s userId=$p(Data,"^",6)       //用户ID
 s:Loc'="" HospId=$p(^CTLOC(Loc),"^",22)
 s AppName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
 s Param=groupId_"^"_Loc_"^"_userId_"^"_$g(HospId)
 s ApprovalReq=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ApprovalFlag",Param)
 //======审批配置取出=========
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:GdRecItmToPay")
  //s ^zhwh(111)=qPar_"||"_Loc_"||"_Vendor_"||"_StartDate_"||"_EndDate_"||"_ApprovalReq_"||"_InvReq

 s sc=result.Execute(qPar,Loc,Vendor,StartDate,EndDate,ApprovalReq,InvReq)
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 
 s ret=""
 s tmp="",count = 0
 w "{rows:["
 While(result.Next())
 { 
  i tmp'=""  d
  .w "{"_tmp_"},"
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
  .e   s ret=ret_","_result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
  s tmp=ret
  s count = count+1
 }
 
 d result.Close()
 /*
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:GdRetItmToPay")
 s sc=result.Execute(qPar,Loc,Vendor,StartDate,EndDate,ApprovalReq,InvReq)
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 While(result.Next())
 { 
  i tmp'=""  d
  .w "{"_tmp_"},"
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
  .e   s ret=ret_","_result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
  s tmp=ret
  s count = count+1
 }
 d result.Close()
 */
 i tmp'="" w "{"_tmp_"}"
 w "],results:"_count_"}"
 
 q ""
}

/// w ##class(web.DHCST.DHCPay).jsVendorListToPay(0,40,"","","2013-05-20^2013-06-19^102^^72^102^590")
ClassMethod jsVendorListToPay(Start As %String, Limit As %String, Dir As %String, Sort As %String, StrParms As %String)
{
 
 s StartDate=$p(StrParms,"^",1)  //起始日期
 s EndDate=$p(StrParms,"^",2)  //截止日期
 s Loc=$p(StrParms,"^",3)   //科室rowid
 s Vendor=$p(StrParms,"^",4)
 s ApprovalReq=""
 s InvReq=""
 //==================是否先审核验证====
 s groupId=$p(StrParms,"^",5)    //安全组
 ;s locId=$p(StrParms,"^",6)       //科室ID
 s userId=$p(StrParms,"^",6)       //用户ID
 s:Loc'="" HospId=$p(^CTLOC(Loc),"^",22)
 s AppName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
 s Param=groupId_"^"_Loc_"^"_userId_"^"_$g(HospId)
 s ApprovalReq=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ApprovalFlag",Param)
 //==================是否先审核验证====

 ;s ApprovalReq=$p(StrParms,"^",5)  //要求审批
 ;s InvReq=$p(StrParms,"^",6)   //要求发票
 
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:VendorListToPay")
 s sc=result.Execute(Loc,StartDate,EndDate,Vendor,ApprovalReq,InvReq)
 //
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
  d json.InsertRowData(tmp)
 }
 s resultString = json.getJsonData(colNameStr,count)
 k json
 d result.Close()
 Q resultString
}

Query VendorListToPay(Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, ApprovalReq As %String = "", InvReq As %String = "") As %Query(ROWSPEC = "vendor:%String,vendorName:%String")
{
}

ClassMethod VendorListToPayExecute(ByRef qHandle As %Binary, Loc As %String, StartDate As %String, EndDate As %String, Vendor As %String, ApprovalReq As %String = "", InvReq As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Loc="" $$$OK 
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate) 
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s orderFieldName=""
	s sql="select %id ingri,"
	s sql=sql_"ingri_ingr_parref->ingr_apcvm_dr ven, "
	s sql=sql_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name venName " 
	s sql=sql_" From dhc_ingdrecitm"  
	s sql=sql_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate    
	s sql=sql_" and ingri_ingr_parref->ingr_loc_dr="_Loc  

	i Vendor'="" d
	.s sql=sql_" and ingri_ingr_parref->ingr_apcvm_dr="_Vendor
	i ApprovalReq="1" d
	.s sql=sql_" and ingri_ingr_parref->ingr_payallowed="_"'"_"Y"_"'"
	i InvReq="1" d
	.s sql=sql_" and initm_invno is not null"
	s xrs=##class(%ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) d $System.Status.DisplayError(sc)
	i $$$ISERR(sc) q $$$OK
	s pid=..NewPid()
	K ^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid)
	while (xrs.Next()){
		s ingri=xrs.Data("ingri")
		s vendor=xrs.Data("ven")
		s vendorName=xrs.Data("venName")
		s type="G"
		continue:..PayOver(type,ingri)=1  
		//未结清时...
		i '$d(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)) d
		.s ^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)=vendorName
	}
	s vendor="" 
	f  s vendor=$o(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)) q:vendor=""  d
	.S vendorName=$g(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor))
	.d OutPutRow3
	K ^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid) 
	//=======退货供应商列表检索========
	d xrs.Close()
	s Rettype=..sssCode()
	s sql="select %id ingr,"
	s sql=sql_"ingrti_ingrt_parref->ingrt_apcvm_dr vendor,"
	s sql=sql_"ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name vendorName"
	s sql=sql_" From dhc_ingrtitm"
	s sql=sql_" where (ingrti_ingrt_parref->ingrt_auditdate between "_StartDate_" and "_EndDate_")"
	s sql=sql_" and ingrti_ingrt_parref->ingrt_ctloc_Dr="_Loc
	s sql=sql_" and ingrti_ingrt_parref->ingrt_stktype='"_Rettype_"'"
	i Vendor'="" d
	.s sql=sql_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_Vendor
	i ApprovalReq="1" d
	.s sql=sql_" and ingrti_ingrt_parref->ingrt_payallowed="_"'"_"Y"_"'"
	i InvReq="1" d
	.s sql=sql_" and ingrti_invno is not null"
	s xrs=##class(%ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) d $System.Status.DisplayError(sc)
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next()){
		s ingr=xrs.Data("ingr")
		s vendor=xrs.Data("vendor")
		s vendorName=xrs.Data("vendorName")
		s type="R"
		continue:..PayOver(type,ingr)=1
		//未结清时...
		i '$d(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)) d
		.s ^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)=vendorName
	}
	s vendor="" 
	f  s vendor=$o(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor)) q:vendor=""  d
	.S vendorName=$g(^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid,vendor))
	.d OutPutRow4
	k ^TMP("DHCST","web.DHCST.DHCPay","VendorListToPay",pid)
	Q $$$OK
OutPutRow4 
	s Data=$lb(vendor,vendorName)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
 
 //=======退货供应商列表检索========
OutPutRow3 
	s Data=$lb(vendor,vendorName)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod VendorListToPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VendorListToPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod VendorListToPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VendorListToPayExecute ]
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

/// 判断入库/退货记录是否结清
/// Author:zhwh
/// Date:2012-11-30
/// Argu:
/// type - 类型
/// ingri - 入库/退货记录rowid
/// Return:
///  1 -结清
///  0 - 未结清
ClassMethod PayOver(type, ingri As %String) As %String
{
 n (type,ingri)
 s pay=$O(^DHCPAY(0,"TYPEGR",type,ingri,""),-1)
 q:pay="" 0
 s ch=$O(^DHCPAY(0,"TYPEGR",type,ingri,pay,""),-1)  
 q:ch="" 0
 s over=$P(^DHCPAY(pay,"I",ch),"^",7)
 i over="Y" q 1
 q 0
}

/// 产生一个存储号
/// Author:zhwh
/// Date:2012-12-07
/// Argu:
///  AppName - 应用代码
/// Return:
///  存储号
ClassMethod GetStoreId() As %String
{
  s appName=##class(web.DHCST.DHCPay).%GetParameter("AppName")
  q:appName="" ""
  q $i(^TMP("DHCCStoreId",appName))
}

/// 暂存数据
/// Author:zhwh
/// Date:2012-12-10
/// Argu:
///  id - 存储号
///  data-数据
/// Return:
///    下标号
ClassMethod StoreData(id As %String, dataStr As %String) As %String
{
 n (id,dataStr)
 s appName=..%GetParameter("AppName")
 q:appName="" -1
 q:id="" -2
 //i appName="" s appName=
 s serialNo=$o(^TMP(appName,id,""),-1)+1
 s ^TMP(appName,id,serialNo)=dataStr
 q serialNo
}

Query PayMode() As %SQLQuery(CONTAINID = 1)
{
  SELECT CTPM_RowId rowid,CTPM_Desc payDesc,CTPM_Code payCode,CTPM_DateTo payDateTo FROM CT_PayMode
}

ClassMethod jsPayMode() As %String
{
 s result=##class(%ResultSet).%New("web.DHCST.DHCPay:PayMode")
 s sc=result.Execute()
 
 i $$$ISERR(sc) q ""
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s count = 0
 s resultString = ""
 // s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  s tmp=ret
  s payDateTo=$p(tmp,"^",4)
  continue:(payDateTo'="")&&(payDateTo<$p($h,",",1))
  s count = count+1       
  d json.InsertRowData(tmp)
 }
 s resultString = json.getJsonData(colNameStr,count)
 k json
 d result.Close()
 Q resultString
}

/// 付款主表记录数据串
/// Author:zhangxiao
/// Date:2013-06-15
/// Argu:
///   pay-付款主表rowid
/// Return:
///   主表记录数据串("^"分隔)
///   w ##class(web.DHCST.DHCPay).SelectMain(378)
///   yunhaibao 20161221 ,获取数据不要用PLIST
ClassMethod SelectMain(pay As %String) As %String
{
 n (pay)
 q:pay="" ""
 q:'$d(^DHCPAY(pay)) ""
 s result=""
 s payobj=##class(User.DHCPay).%OpenId(pay,0)
 s PAYNo=payobj.PAYNo //领药审核
 s PAYAPCVMDR=$s(payobj.PAYAPCVMDR'="":payobj.PAYAPCVMDR.%Id(),1:"")
 s PAYAPCVM=$s(PAYAPCVMDR'="":$p($g(^APC("APCVM",PAYAPCVMDR)),"^",3),1:"")
 s PAYCTLOCDR=$s(payobj.PAYCTLOCDR'="":payobj.PAYCTLOCDR.%Id(),1:"")
 s PAYCTLOC=$s(PAYCTLOCDR'="":$p($g(^CTLOC(PAYCTLOCDR)),"^",2),1:"")
 s PAYSSUSRDR=$s(payobj.PAYSSUSRDR'="":payobj.PAYSSUSRDR.%Id(),1:"")
 s PAYSSUSR=$s(PAYSSUSRDR'="":$p($G(^SSU("SSUSR",PAYSSUSRDR)),"^",2),1:"")
 s PAYDate=payobj.PAYDate
 i PAYDate'="" s PAYDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PAYDate,"ST")
 //result1
 s result1=PAYNo_"^"_PAYAPCVM_"^"_PAYCTLOC_"^"_PAYSSUSR_"^"_PAYDate
 s PAYTime=payobj.PAYTime
 i PAYTime'="" s PAYTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(PAYTime,"ST")
 s PAYMode=payobj.PAYMode
 s PAYAck1=payobj.PAYAck1
 s PAYAck2=payobj.PAYAck2
 s PAYCheckNo=payobj.PAYCheckNo
 //result2
 s result2=PAYTime_"^"_PAYMode_"^"_PAYAck1_"^"_PAYAck2_"^"_PAYCheckNo
 s PAYCheckDate=payobj.PAYCheckDate
 i PAYCheckDate'="" s PAYCheckDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PAYCheckDate,"ST")
 s PAYCheckAmt=payobj.PAYCheckAmt
 s PAYDateAck1=payobj.PAYDateAck1
 i PAYDateAck1'="" s PAYDateAck1=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PAYDateAck1,"ST")
 s PAYDateAck2=payobj.PAYDateAck2
 i PAYDateAck2'="" s PAYDateAck2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PAYDateAck2,"ST")
 s PAYSSUSRAck1=payobj.PAYSSUSRAck1
 s PAYSSUSRAck1=$s(PAYSSUSRAck1'="":$p($G(^SSU("SSUSR",PAYSSUSRAck1)),"^",2),1:"")
 //result3
 s result3=PAYCheckDate_"^"_PAYCheckAmt_"^"_PAYDateAck1_"^"_PAYDateAck2_"^"_PAYSSUSRAck1
 s PAYSSUSRAck2=payobj.PAYSSUSRAck2
 s PAYSSUSRAck2=$s(PAYSSUSRAck2'="":$p($G(^SSU("SSUSR",PAYSSUSRAck2)),"^",2),1:"")
 s PAYDateExpected=payobj.PAYDateExpected
 s PAYPoisonFlag=payobj.PAYPoisonFlag
 s PAYCompleted=payobj.PAYCompleted
 s PAYCertifiedNo=payobj.PAYCertifiedNo
 //result4
 s result4=PAYSSUSRAck2_"^"_PAYDateExpected_"^"_PAYPoisonFlag_"^"_PAYCompleted_"^"_PAYCertifiedNo
 s PAYRemarks=payobj.PAYRemarks
 s PAYAck11=payobj.PAYAck11
 s PAYDateAck11=payobj.PAYDateAck11
 s PAYSSUSRAck11=payobj.PAYSSUSRAck11
 //result5
 s result5=PAYRemarks_"^"_PAYAck11_"^"_PAYDateAck11_"^"_PAYSSUSRAck11
 s result=result1_"^"_result2_"^"_result3_"^"_result4_"^"_result5
 q result
}

ClassMethod NewPid()
{
	q $i(^DHCSTPID("web.DHCST.DHCPay"))
}

}
