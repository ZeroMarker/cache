Import sqluser

Class web.DHCST.INRequest Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINREQ";

/// 插入或更新转移请求单主表记录
/// Author:zhwh
/// Date:2011-07-11
/// Argu: 
///   req - 主表记录rowid值
///   data
/// Return:
///   0 - success
///   <0 -failure
ClassMethod Update(req As %String, data As %String) As %String
{
 ;s req="3485",data="102^99^1^1^O^sssxxxddd"
 s frLoc=$p(data,"^",1) q:frLoc="" -1  //供应科室
 s toLoc=$p(data,"^",2) q:toLoc="" -2 //请求科室
 i frLoc=toLoc q -22   //供应科室 不可与 请求科室相同
 s user=$p(data,"^",3)   //请求人
 s scg=$p(data,"^",4)  //类组分类
 s status=$p(data,"^",5)  //状态(C,O,X)
 s remark=$p(data,"^",6)  //备注内容
 //
 i status="" s status="O"
 s scgCode=""
 i scg'="" &Sql(select scg_code into :scgCode from dhc_stkcatgroup where %ID=:scg)
 s dd=+$h
 s tt=$p($h,",",2)
 
 s err=0
 i req'="" q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_req)<0 -99  //锁定
 i req="" d   //插入
 .;ts
 .&sql(insert into IN_Request(inrq_recLoc_dr,inrq_reqloc_dr,inrq_date,inrq_time,inrq_ssusr_dr,inrq_status)
  values (:toLoc,:frLoc,:dd,:tt,:user,:status) )
 .i SQLCODE'=0  s err=-3 q
 .s req=%ROWID
 .&sql(insert into DHC_INRequest(INRQ_Type,INRQ_INRQ_DR,INRQ_SCG_DR)values(:status,:req,:scg) )
 .s reqNo=##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),scg,toLoc)  //取单号
 .i reqNo'="" d
 ..&sql(update IN_Request set inrq_no=:reqNo where %ID=:req)
 ..i SQLCODE'=0 s err=-4 q
 .q:err<0
 .;tc
 e  d   //更新
 .;ts
 .s obj=##class(User.INRequest).%OpenId(req)
 .d obj.%Reload()
 .s obj.INRQRecLocDR=##class(User.CTLoc).%OpenId(toLoc,0)
 .s obj.INRQReqLocDR=##class(User.CTLoc).%OpenId(frLoc,0)
 .s obj.INRQSSUSRDR=##class(User.SSUser).%OpenId(user,0)
 .//s obj.INRQDate=dd
 .//s obj.INRQTime=tt
 .s obj.INRQStatus=status
 .s sc=obj.%Save()
 .i $$$ISERR(sc) s err=-5  q
 .
 .s dhcReq=$o(^DHCINRQ(0,"INRQ",req,0))
 .i dhcReq'="" d
 ..s obj1=##class(User.DHCINRequest).%OpenId(dhcReq)
 ..d obj1.%Reload()
 ..s obj1.INRQType=status
 ..s sc=obj1.%Save()
 ..i $$$ISERR(sc) s err=-7
 .e  d
 ..s obj2=##class(User.DHCINRequest).%New()
 ..s obj2.INRQINRQDR=req
 ..s obj2.INRQType=status
 ..s obj2.INRQSCGDR=scg
 ..s sc=obj2.%Save()
 ..i $$$ISERR(sc) s err=-8
 ..
 .
 i err<0  d ..uLock(req) q err
 ;b ;update
 //更新备注字段
 i req'="" d
 .
 .s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
 .s obj=##class(User.INRequest).%OpenId(req)
 .d obj.%Reload()
 .s remark=$LFS(remark,memoDelim) //将备注串( $c(3)分隔 )转换为list
 .d obj.INRQRemarks.Clear()
 .d obj.INRQRemarks.InsertList(remark)
 .
 .s sc=obj.%Save()
 .i $$$ISERR(sc) s err=-6
 d ..uLock(req)
 q:err<0 err
 q req
}

/// 检索库存转移请求单主表记录数据
/// Author:zhwh
/// Date:2012-07-11
/// Argu:
/// req - 转移请求单主表Rowid
/// Return:请求单主表记录数据串
/// w ##class(web.DHCST.INRequest).Select(11)
ClassMethod Select(req As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from IN_Request where %ID=:req)
 q:SQLCODE result
 s cnt=$o(PLIST(""),-1)
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim() //备注分隔符
 f i=1:1:cnt d
 .i i=11 s PLIST(i)=$LTS(PLIST(i),memoDelim)  //处理一下备注字段的值
 .i i=10 s PLIST(i)=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(PLIST(i),"ST")
 .i i=7  s PLIST(i)=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PLIST(i),"ST")
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 s ReqLocId=$p(^INRQ(req),"^",5)
 s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2)
 s RecLocId=$p(^INRQ(req),"^",6)
 s RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
 s SSUSRDR=$p(^INRQ(req),"^",4)
 s SSUSR=$P(^SSU("SSUSR",SSUSRDR),"^",2)
 s INRQRowId="",inrqtype="",stkcg="",inrqtype=""
 s INRQRowId=$o(^DHCINRQ(0,"INRQ",req,INRQRowId))
 i INRQRowId'="" d
 .s INRQSCGDR=$p(^DHCINRQ(INRQRowId),"^",10)
 .s inrqtype=$p(^DHCINRQ(INRQRowId),"^",1)
 .i INRQSCGDR'="" s stkcg=$p($G(^DHCSCG(INRQSCGDR)),"^",2)

 q result_"^"_ReqLocDesc_"^"_RecLocDesc_"^"_SSUSR_"^"_$g(INRQSCGDR)_"^"_stkcg_"^"_inrqtype
}

/// 删除库存转移请求单主表
/// Author:zhwh
/// Date:2012-07-11
/// Argu:
///  req - 转移请求单主表Rowid/
/// Return:
///  0 - success
///  <0 -failure
///  
ClassMethod Delete(req As %String) As %String
{
 q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_req)<0 -99
 i ..AllowDel(req)<0 d ..uLock(req) q -1
 s dhcinreqdr=$o(^DHCINRQ(0,"INRQ",req,""))
 i dhcinreqdr'="" d
 .&sql(delete from DHC_INRequest where INRQ_RowId=:dhcinreqdr)
 .q:SQLCODE'=0 
 q:SQLCODE'=0 -3
 &sql(delete from in_request where %ID=:req)
 q:SQLCODE'=0 -2
 
 q 0
}

/// 检查是否允许删除
/// Author:zhwh
/// Date:2012-07-11
/// Argu:
///  req - 转移请求单主表Rowid///
/// Return:
///   0 - success
///   <0  -failure (-1,-2,-3)
///   
ClassMethod AllowDel(req As %String) As %String
{
 s obj=##class(User.INRequest).%OpenId(req,0)
 d obj.%Reload()
 s comp=obj.INRQUserCompleted
 i comp="Y" q -1   //已经"完成"
 &sql(select %ID into :init from dhc_inistrf where init_inrq_dr=:req)   
 i +$G(init)>0 q -2  //已经被转移
 
 //检查请求明细内容是否已经转采购计划明细
 s ch=0
 s inpp=0
 f  s ch=$o(^INRQ(req,"RQI",ch))  q:(ch="")!(+inpp>0)  d
 .s reqi=req_"||"_ch
 .s inpp=$O(^INPP(0,"RQI",reqi,""))
 .q:+inpp>0   
 i +inpp>0 q -3
 q 0
}

/// 请求单解锁
/// Author:zhwh
/// Date:2012-07-11
/// Argu:
///  req - 转移请求单主表Rowid///
/// Return:
/// 
ClassMethod uLock(req As %String)
{
 q:req=""
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_req)
 q
}

/// 取转移请求单主表记录数据串(json)
/// Author:zhwh
/// Date:2011-07-11
/// Argu:
///   Start - 起始行号
///   Limit - 行数
///   Sort - 排序字段
///   Dir   - 排序方向
///   StrPar -  query参数
/// Return:
///   记录数据串(json)
/// Other:w ##class(web.DHCST.INRequest).jsINReqM("0","20","","desc","2020-07-29^2020-08-13^165^^Y^部分作废")
ClassMethod jsINReqM(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String) As %String
{
 //s ^YSJTMP("jsINReqM")=$LB(Start , Limit , Sort , Dir , StrPar)
 s qPar=Sort_"^"_Dir
 s StartDate=$P(StrPar,"^",1)  //起始日期
 s EndDate=$P(StrPar,"^",2)  //截止日期
 s ToLoc=$P(StrPar,"^",3) //申请部门 
 s FrLoc=$P(StrPar,"^",4) //供给部门
 s Comp=$P(StrPar,"^",5)  //包含完成的
 //s TranStatus=$P(StrPar,"^",6)  //包含的转移状态(包含"未转移"，包含"部分转移"，包含"已转移")
 s ReqStatus=$P(StrPar,"^",6)  //请求单转移状态串
 
 s result=##class(%Library.ResultSet).%New("web.DHCST.INRequest:INReqM")
 s sc=result.Execute(qPar,StartDate,EndDate,ToLoc,FrLoc,Comp,ReqStatus)
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
  .i i=1 s ret=result.%GetData(i)
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

/// 库存转移请求单主记录查询
/// Author:zhwh
/// Date:2011-07-11
/// Argu:
///    qPar - 排序和排序方向
///    StartDate -  起始日期
///    EndDate  -截止日期
///    ToLoc - 入方科室rowid
///    Comp   -包含已完成
///    Transfered  -包含已经转移
///    
Query INReqM(qPar As %String, StartDate As %String, EndDate As %String, ToLoc As %String, FrLoc As %String, Comp As %String = "", TransStatus As %String = "") As %Query(ROWSPEC = "req:%String,toLoc:%String,toLocDesc:%String,frLoc:%String,frLocDesc:%String,reqUser:%String,userName:%String,date:%String,time:%String,status:%String,comp:%String,reqNo:%String,remark:%String")
{
}

ClassMethod INReqMExecute(ByRef qHandle As %Binary, qPar As %String, StartDate As %String, EndDate As %String, ToLoc As %String, FrLoc As %String, Comp As %String, TransStatus As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
    
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:ToLoc="" $$$OK
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 
 s orderFieldName=""
 s:Sort="Date" orderFieldName="d"
 s:Sort="frLoc" orderFieldName="frLocDesc"
 s:Sort="toLoc" orderFieldName="toLocDesc"
 s:Sort="comp" orderFieldName="comp"
 s:Sort="User" orderFieldName="userName"
 
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 
 s sql="select %ID req,"
 s sql=sql_"inrq_recloc_dr toLoc,"
 s sql=sql_"inrq_recloc_dr->ctloc_Desc toLocDesc,"
 s sql=sql_"inrq_reqloc_dr frLoc,"
 s sql=sql_"inrq_reqloc_dr->ctloc_desc frLocDesc,"
 s sql=sql_"inrq_ssusr_dr reqUser,"
 s sql=sql_"inrq_ssusr_dr->ssusr_name userName,"
 s sql=sql_"inrq_date d,"
 s sql=sql_"inrq_time t,"
 s sql=sql_"inrq_status reqStatus,"
 s sql=sql_"inrq_usercompleted comp,"
 s sql=sql_"INRQ_No reqNo, "
 
 s sql=sql_"INRQ_Remarks remark "
 s sql=sql_" from in_request"
 s sql=sql_" where inrq_date between "_StartDate_" and "_EndDate

 i orderFieldName'="" d
 . s sql=sql_" order by "_orderFieldName_" "_Dir
 
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 
 while (xrs.Next())
 {
 
  s req=xrs.Data("req")  
  s toLoc=xrs.Data("toLoc")
  continue:toLoc'=ToLoc
  s toLocDesc=xrs.Data("toLocDesc")
  s frLoc=xrs.Data("frLoc")
  i FrLoc'="" continue:frLoc'=FrLoc
  s frLocDesc=xrs.Data("frLocDesc")
  s reqUser=xrs.Data("reqUser")  
  s userName=xrs.Data("userName")
  s date=xrs.Data("d")
  i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
  s time=xrs.Data("t")
  i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"ST")
  s status=xrs.Data("reqStatus") 
  s comp=xrs.Data("comp")
  s reqNo=xrs.Data("reqNo")
  s remark=xrs.Data("remark")  //备注
  s dhcinreq=$o(^DHCINRQ(0,"INRQ",req,""),-1)
  i dhcinreq'="" s dhcinreqtype=$p($g(^DHCINRQ(dhcinreq)),"^",1)
  e  s dhcinreqtype=""
  continue:(dhcinreqtype'="O")&&(dhcinreqtype'="C")
  s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
  s remark=$LTS(remark,memoDelim)
  s reqitm=$o(^INRQ(req,"RQI",""),-1)
  i reqitm'="" d
  .s reqitminci=$p(^INRQ(req,"RQI",reqitm),"^",4)
  .s StkType=$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(reqitminci),"^",3)
  e  d
  .s StkTypeDr=$p($g(^DHCINRQ(dhcinreq)),"^",10) 
  .s StkType=$p($g(^DHCSCG(StkTypeDr)),"^",3)
  continue:StkType'="G"
  /*
  s status=##class(web.DHCST.DHCINIsTrf).TransferStatus(req) //0,1,2
  i status="0" continue:$P(TransStatus,"%",1)'="1"
  i status="1" continue:$P(TransStatus,"%",2)'="1"
  i status="2" continue:$P(TransStatus,"%",3)'="1"
  i comp="" s comp="N"
  continue:Comp'=comp //add wyx 过滤作废全部明细的请求单 2014-06-24
  s itm=0
  s cnt=0
  f  s itm=$o(^INRQ(req,"RQI",itm)) q:(itm="")||(cnt'=0)  d
  .s refuse=$p(^INRQ(req,"RQI",itm),"^",6)
  .i refuse'="Y" s cnt=cnt+1
  .
  //continue:cnt=0
  */
  //新状态过滤
  s status=..GetInReqStatus(req)
  s ExistFlag=..CheckReqStatus(req, TransStatus)
  continue:ExistFlag="N"
  d OutPutRow1   
 }
 Quit $$$OK
 
OutPutRow1
 s Data=$lb(req,toLoc,toLocDesc,frLoc,frLocDesc,reqUser,userName,date,time,status,comp,reqNo,remark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INReqMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INReqMExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INReqMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INReqMExecute ]
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

/// 请求单明细的科室库存情况查询
/// Author:zhwh
/// Date:2011-07-12
/// Argu:
///   reqItm - 请求单明细rowid
/// Return:
///     请求方库存情况数据串("^"分隔)
///     
ClassMethod ReqLocItmStk(reqItm As %String) As %String
{
 &sql(select inrqi_inrq_parref->inrq_recloc_dr,
    inrqi_inrq_parref->inrq_reqloc_dr,
    inrqi_inci_dr,
    inrqi_ctuom_dr 
     into :toLoc,:frLoc,:inci,:uom
    from IN_ReqItm where %ID=:reqItm)
 i SQLCODE'=0 q ""
 s toLocStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,toLoc,uom,+$h)
 s frLocStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,frLoc,uom,+$h)
 s str=##class(web.DHCST.Common.DrugStkCommon).GetItmLocMNRQtyUO(inci,toLoc,uom)
 s toLocMaxQty=$p(str,"^",1)
 s toLocMinQty=$p(str,"^",2)
 s toLocRepQty=$p(str,"^",3)
 q toLocStkQty_"^"_frLocStkQty_"^"_toLocMaxQty_"^"_toLocMinQty_"^"_toLocRepQty
}

/// 设置(取消)完成状态
/// Author:zhwh
/// Date:2011-07-12
/// Argu:
///   req -  请求单主表rowid
///   comp - 完成状态(Y,N)
/// Return:
///    0 - success
///    <0 - failure
ClassMethod SetCompleteStatus(req As %String, comp As %String) As %String
{
   q:req="" 0
   q:"YN"'[comp -10  //状态值不合法
   q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_req)<0 -99

   //检查请求单是否已经使用
   &sql(select %id into :init From dhc_inistrf where init_inrq_Dr=:req  )
   i 'SQLCODE  d ..uLock(req)  q -1   //已经使用,不得修改状态
   //
   &sql(update IN_Request set inrq_usercompleted=:comp where %ID=:req)
   i SQLCODE '=0  d ..uLock(req) q -2
   d ..uLock(req) 
   q 0
}

/// 保存请求单主表和明细表的数据
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
///  req -请求单主表rowid
///  reqInfo - 主表信息串
///  ListData - 明细数据记录串
/// Return： 
///  >0 - 请求单主表rowid
///  <0 - 失败
///  w ##class(web.DHCST.INRequest).Save("","257^246^10213^3^^辅助请求(依据消耗及补货标准)","^684^18^176430^^3^176430")
ClassMethod Save(req As %String, reqInfo As %String, ListData As %String) As %Library.String
{
	//s ^YSJTMP("Save")=$LB(req,reqInfo,ListData)
    i req'="" s allowdel=..AllowDel(req)
    e  s allowdel=0
    q:allowdel=-1 -1001
    q:allowdel=-2 -1002
    q:allowdel=-3 -1003
    q:allowdel<0 -1004
    tstart
    s $zt="ThrowSave" 
    s MainId=""
    s ret=..Update(req,reqInfo)
    i +ret>0  d
    .s MainId=ret
    i MainId="" trollback
    q:MainId="" ret
    s ret=##class(web.DHCST.INReqItm).Save(MainId,ListData)
    i ret'=0 trollback
    q:ret'=0 ret 
    tcommit    ;只要有出库单明细保存成功，则提交事务
    q:+ret'=0 ret   ;存在保存失败的明细
    q MainId
ThrowSave
	 q $$Error^DHCSTERROR
}

/// Descript:取库存转移请求界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：请求数量是否可以大于供应方库存
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.INRequest).%GetParameter("AppName")
    s RQtyOverFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"IfRQtyOver",Param)
    s Data1=RQtyOverFlag
    q Data1
}

/// w ##class(web.DHCST.INRequest).Copy("59","106","165")
ClassMethod Copy(req As %String, reqloc As %String, proloc As %String, transflag = "")
{
 s ^YSJTMP("Copy")=$LB(req , reqloc , proloc)
 s rUserId=$p(^INRQ(req),"^",4)
 s remark=$g(^INRQ(req,"REM",1))
 s status=$p(^INRQ(req),"^",7)
 s reqDate=$zd(+$h,3)
 s dhcinrq=$o(^DHCINRQ(0,"INRQ",req,""))
 s scg=$p(^DHCINRQ(dhcinrq),"^",10)    //类组分类
 s reqInfo=proloc_"^"_reqloc_"^"_rUserId_"^"_scg_"^"_status_"^"_remark
 s ListData=""
 s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	//记录行分隔符设置
 s reqitm=0
 f  s reqitm=$o(^INRQ(req,"RQI",reqitm)) q:reqitm=""  d
 .s rowid=""
 .s inc=$p(^INRQ(req,"RQI",reqitm),"^",4)
 .s uomId=$p(^INRQ(req,"RQI",reqitm),"^",5)
 .s qty=$p(^INRQ(req,"RQI",reqitm),"^",3)
 .s buomid=$p(^INCI(inc,1),"^",10)
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomId,buomid)
 .s buomqty=qty*fac
 .s transqty=##class(web.DHCST.DHCINIsTrf).TransQty(req_"||"_reqitm)  //yunhaibao,21050421,与界面显示统一
 .q:(transqty>=buomqty)&(transflag="1")
 .s colRemark="",ppqty="",scg=""
 .s dhcreqitm=$o(^DHCINRQI(0,"INRQI",req_"||"_reqitm,""))
 .i dhcreqitm'="" d
 ..s colRemark=$p(^DHCINRQI(dhcreqitm),"^",2)
 ..s ppqty=$p(^DHCINRQI(dhcreqitm),"^",4)
 .i ListData="" d
 ..s ListData=rowid_"^"_inc_"^"_uomId_"^"_qty_"^"_colRemark_"^"_scg_"^"_ppqty
 .e  d
 ..s ListData=ListData_rowDelim_rowid_"^"_inc_"^"_uomId_"^"_qty_"^"_colRemark_"^"_scg_"^"_ppqty 
 s ret=..Save("",reqInfo,ListData) 
 q ret
}

/// 根据请求单号获取请求单id
ClassMethod GetInReqIdByNo(reqno)
{
	q:reqno="" ""
	s inreq=""
	&SQL(SELECT INRQ_RowId into :inreq FROM IN_Request WHERE INRQ_No=:reqno)
	q inreq
}

/// Decription:获取库存转移请求单的状态
/// Creator:yangsj
/// CreateDate:2020-08-11
/// Input:ReqId 请求主表id
/// Output: 状态串   ","表示没有状态
/// Table:
/// Debugger: w ##Class(web.DHCST.INRequest).GetInReqStatus(80)
ClassMethod GetInReqStatus(ReqId)
{
	s StatusStr=","
	q:ReqId="" ""
	s compFlag=$P(^INRQ(ReqId),"^",8)
	i compFlag'="Y" q "保存"
	e  s StatusStr=""
	// 检查转移状态
	
	s count=0
	s refuseNum=0
	s AllTransNum=0
	s partTransNum=0
	s ch=0
	f  s ch=$o(^INRQ(ReqId,"RQI",ch)) q:(ch="")  d
	.s INRQI=ReqId_"||"_ch
	.s inci=$P(^INRQ(ReqId,"RQI",ch),"^",4)
	.s reqQty=$P(^INRQ(ReqId,"RQI",ch),"^",3)
	.s uom=$P(^INRQ(ReqId,"RQI",ch),"^",5)
	.s refuse=$p(^INRQ(ReqId,"RQI",ch),"^",6)
	.i refuse="Y" s refuseNum=refuseNum+1   		   //作废明细数
	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,$p(^INCI(inci,1),"^",10))
	.s reqQty=reqQty*fac
	.s transQty=##Class(web.DHCST.DHCINIsTrf).TransQty(INRQI)
	.i transQty'=0 d
	..i transQty<reqQty s partTransNum=partTransNum+1  //部分转移明细数
	..e  s AllTransNum=AllTransNum+1				   //全部转移明细数
	.s count=count+1
	
	i refuseNum=count s StatusStr=StatusStr_","_"全部作废"
	i (refuseNum'=0)&&(refuseNum<count) s StatusStr=StatusStr_","_"部分作废"
	i partTransNum'=0 s StatusStr=StatusStr_","_"部分转移"
	i AllTransNum=count s StatusStr=StatusStr_","_"全部转移"
	e  i (AllTransNum'=0)&&(StatusStr'["部分转移") s StatusStr=StatusStr_","_"部分转移"
	
	q:StatusStr="" "完成"
	
	s StatusStr=$e(StatusStr,2,$l(StatusStr))
	q StatusStr
}

/// Decription:判断转移单状态否符合转台条件
/// Creator:yangsj
/// CreateDate:2020-08-11
/// Input:ReqId 请求主表id
/// Output: Y 符合  N 不符合
/// Table:
/// Debugger: w ##Class(web.DHCST.INRequest).CheckReqStatus(80,"全作废")
ClassMethod CheckReqStatus(ReqId, StatuStr)
{
	q:StatuStr="" "Y"
	s tmpStatuStr=..GetInReqStatus(ReqId)
	q:tmpStatuStr="," "N"
	s len=$L(tmpStatuStr,",")
	s existFlag="N"
	s StatuStr=","_StatuStr_","
	f i=1:1:len q:existFlag="Y"  d
	.s tmpStatui=$P(tmpStatuStr,",",i)
	.i StatuStr[(","_tmpStatui_",") s existFlag="Y"
	
	q existFlag
}

}
