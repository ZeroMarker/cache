Import sqluser

/// Descript:依据转移请求生成采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
Class web.DHCST.INPurPlanAuxByReq Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:根据选择的请求记录生成采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
/// Table:IN_Purplan,IN_PurplanItm
/// Input:科室Id,操作人Id,请求明细rowid^请求明细rowid,类组id
/// Output:     
/// Return：计划单id：成功，
/// -1:科室或人员为空
/// -99  ;加锁失败
/// -2   ;生成计划单号失败
/// -3   ;生成计划单失败
/// -4   ;生成计划单明细失败
ClassMethod Create(LocId As %String, UserId As %String, ListReqId As %String, StkGrpId As %String = "") As %Library.String
{
    n (LocId,UserId,ListReqId,StkGrpId)
    s Pid=..NewPid()
    d CollectData
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s PurId=##class(web.DHCST.INPurPlan).Insert(LocId,UserId,StkGrpId)     ;保存采购计划主表
    i +PurId<=0 trollback
    q:+PurId<=0 PurId
    ;
    s Err=0
    s Sub=""
    f  s Sub=$o(^TMPPURPLAN(Pid,"PurPlan",Sub))  q:(Sub="")!(Err'=0)  d
    .s IncId=$p(^TMPPURPLAN(Pid,"PurPlan",Sub),"^",1)
    .s notUseFlag=$P(^INCI(IncId,2),"^",9)
    .i notUseFlag="Y" s Err=-99_"^"_$p(^INCI(IncId,1),"^",2)_" 不可用"
    .q:notUseFlag="Y"
    .s Qty=$p(^TMPPURPLAN(Pid,"PurPlan",Sub),"^",2)
    .s UomId=$p(^TMPPURPLAN(Pid,"PurPlan",Sub),"^",3)
    .s ReqLocId=$p(^TMPPURPLAN(Pid,"PurPlan",Sub),"^",4)
    .s ReqIdStr=$p(^TMPPURPLAN(Pid,"PurPlan",Sub),"^",5)
    .s ItmInfo=##class(web.DHCST.INPurPlan).GetItmInfo(IncId, "^"_LocId)
    .s VendorId=$p(ItmInfo,"^",1)
    .s ManfId=$p(ItmInfo,"^",3)
    .s CarrierId=$p(ItmInfo,"^",5)
    .s Rp=$p(ItmInfo,"^",9)
    .s Detail=IncId_"^"_Qty_"^"_UomId_"^"_VendorId_"^"_Rp_"^"_ManfId_"^"_CarrierId_"^"_ReqLocId
    .;b ;1
    .s Ret=##class(web.DHCST.INPurPlanItm).Insert(PurId,Detail)
    .;b ;2
    .s:+Ret<=0 Err=-4
    .q:Err'=0
    .s PutItmId=Ret
    .s Ret=..Insert(PutItmId,ReqIdStr)
    .s:Ret'=0 Err=-5
    .q:Err'=0
    .
    i Err'=0 trollback
    q:Err'=0 Err
    tcommit    
    q PurId
CollectData
    s Len=$l(ListReqId,"^")
    f i=1:1:Len d
    .s ReqId=$p(ListReqId,"^",i)
    .q:ReqId=""
    .s Parref=+ReqId
    .s Chl=$p(ReqId,"||",2)
    .s IncId=$p(^INRQ(Parref,"RQI",Chl),"^",4)
    .q:IncId=""
    .s Qty=$p(^INRQ(Parref,"RQI",Chl),"^",3)
    .s UomId=$p(^INRQ(Parref,"RQI",Chl),"^",5)
    .s ReqLocId=$p(^INRQ(Parref),"^",6) // 请求科室,对应字段INRQ_RecLoc_DR(接受库存科室)
    .s:ReqLocId="" ReqLocId="*"
    .s BUomId=$p(^INCI(IncId,1),"^",10)
    .s PurUomId=$p(^INCI(IncId,3),"^",6)
    .s ConFac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
    .s ConFac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s PurQty=Qty*ConFac1/ConFac2
    .s SubStr=IncId_"^"_ReqLocId
    .i '$d(^TMPPURPLAN(Pid,"PurPlan",SubStr))  d
    ..s ^TMPPURPLAN(Pid,"PurPlan",SubStr)=IncId_"^"_PurQty_"^"_PurUomId_"^"_ReqLocId_"^"_ReqId
    .e  d
    ..s $p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",2)=PurQty+$p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",2)
    ..s $p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",5)=$p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",5)_","_ReqId
    ..
    .
    q
}

/// Descript:   查询请求单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
/// Table:IN_Request
/// Input:开始行，一页显示记录数,排序字段,排序方向,
/// 供应科室RowId^起始日期^截止日期^请求单类型(选中为"I",不选为空)
/// Output: 102^2016-05-25^2016-05-25^C^590    
/// Return：请求主表ROwid，请求单号，请求科室，制单日期，制单时间，制单人
/// w ##class(web.DHCST.INPurPlanAuxByReq).INReqM(0,20,"","","102^2016-05-25^2016-05-25^C^590")
ClassMethod INReqM(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
    n (StrParam,Start,Limit,Sort,Dir,%session)
    //s ^zdm("Query")=StrParam_","_Start_","_Limit_","_Sort_","_Dir
    s LocId=$p(StrParam,"^",1)
    s StartDate=$p(StrParam,"^",2)
    s EndDate=$p(StrParam,"^",3)
    s userId=$p(StrParam,"^",5)
    q:StartDate="" ""
    q:EndDate="" ""
    q:LocId="" ""
    s stk=""
    s stk=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(userId,..sssCode())  //若类组为空，则传递User类组串
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s ReqType=$p(StrParam,"^",4)
    ;
    s StrSql="select INRQ_Rowid as Rowid,INRQ_No,INRQ_RecLoc_DR,INRQ_RecLoc_DR->CTLOC_Desc as LocDesc,"_
    "INRQ_Date,INRQ_Time,INRQ_SSUSR_DR->SSUSR_Name as UserName"_
    " from IN_Request where INRQ_ReqLoc_DR='"_LocId_"' and (INRQ_Date between "_StartDate_" and "_EndDate_") and INRQ_UserCompleted='Y'"
    s OrderField="Rowid"
    i ReqType'=""  d
    .s StrSql=StrSql_" and INRQ_Status='"_ReqType_"'"
    ;
    s:Sort="ReqNo" OrderField="INRQ_No"
    s:Sort="ReqLoc" OrderField="LocDesc"
    s:Sort="Date" OrderField="INRQ_Date"
    s:Sort="Time" OrderField="INRQ_Time"
    s:Sort="User" OrderField="UserName"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        CONTINUE:..CheckPur(Rowid)=1   ;该请求单明细已经全部采购
        s status="",StkGrpId="",inrqrowid=""
        s inrqrowid =$o(^DHCINRQ(0,"INRQ",Rowid,inrqrowid)) 
        i inrqrowid'=""  d
        .s status=$P(^DHCINRQ(inrqrowid),"^",1)
        .s StkGrpId=$P(^DHCINRQ(inrqrowid),"^",10)
        continue:(stk'="")&&(StkGrpId'="")&&(("^"_stk_"^")'[("^"_StkGrpId_"^"))
        s ReqNo = result.Data("INRQ_No")
        s ReqLocId = result.Data("INRQ_RecLoc_DR")
        s ReqLoc = result.Data("LocDesc")
        s Date = result.Data("INRQ_Date")
        s:+Date'=0 Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"ST")
        s Time = result.Data("INRQ_Time")
        s:+Time'=0 Time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(Time,"ST")
        s User = result.Data("UserName")
        s StkGrp=""
        s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
        s Data=Rowid_"^"_ReqNo_"^"_ReqLocId_"^"_ReqLoc_"^"_Date_"^"_Time_"^"_User_"^"_StkGrpId_"^"_$g(StkGrp)
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^ReqNo^ReqLocId^ReqLoc^Date^Time^User^StkGrpId^StkGrp",count)
    k json
    Q resultString
}

/// Descript:   查询请求单明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-25
/// Table:IN_ReqItm
/// Input:开始行，一页显示记录数,排序字段,排序方向,
/// 主表rowid
/// Output:     
/// Return：子表Rowid，药品代码，名称，请求数量，请求单位
ClassMethod INReqD(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Parref As %String, LocId As %String) As %String
{
    n (Parref,Start,Limit,Sort,Dir,LocId)
    q:Parref="" ""
    s HospId=$p($g(^CTLOC(LocId)),"^",22)
    s StrSql="select INRQI_Rowid as Rowid,INRQI_INCI_DR,INRQI_INCI_DR->INCI_Code as IncCode,"_
    "INRQI_INCI_DR->INCI_Desc as IncDesc,INRQI_ReqQty,INRQI_CTUOM_DR,INRQI_CTUOM_DR->CTUOM_Desc as ReqUom"_
    " from IN_ReqItm where INRQI_INRQ_ParRef='"_Parref_"'"
    s OrderField="Rowid"
    s:Sort="IncCode" OrderField="IncCode"
    s:Sort="IncDesc" OrderField="IncDesc"
    s:Sort="ReqQty" OrderField="INRQI_ReqQty"
    s:Sort="ReqUom" OrderField="ReqUom"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s TitleStr="RowId^IncId^IncCode^IncDesc^ReqQty^ReqUomId^ReqUom^Locqty^TransQty"
    w "{rows:["
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        CONTINUE:$d(^INPP(0,"RQI",Rowid))   ;已经生成采购计划
        s IncId = result.Data("INRQI_INCI_DR")
        s Locqty=##class(web.DHCST.Common.DrugStkCommon).IL(IncId,LocId,+$h)
        s IncCode = result.Data("IncCode")
        s IncDesc = result.Data("IncDesc")
        s ReqQty = result.Data("INRQI_ReqQty")
        s ReqUomId = result.Data("INRQI_CTUOM_DR")
        s ReqUom = result.Data("ReqUom")
        s TransQty = ..TransQty(Rowid)
        s buom=$p(^INCI(IncId,1),"^",10)
        s puom=$p(^INCI(IncId,3),"^",6)
        s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(ReqUomId,buom)
        s pbfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
        s ReqQty=ReqQty*confac/pbfac
        s ReqUomId=puom
        s ReqUom=$p(^CT("UOM",ReqUomId),"^",2)
        s TransQty=TransQty/pbfac
        s Locqty=Locqty/pbfac      
        s TransQty=##class(web.DHCST.Common.AppCommon).FormatSq(TransQty,HospId,1,..sssCode())
        s Locqty=##class(web.DHCST.Common.AppCommon).FormatSq(Locqty,HospId,1,..sssCode())
        s Data=Rowid_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_ReqQty_"^"_ReqUomId_"^"_ReqUom_"^"_Locqty_"^"_TransQty
        s count = count+1   
        i count=1 d
        .w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,TitleStr)
        e  d
        .w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,TitleStr)
    }
    w "],results:"_count_"}"
    d result.Close()
    q ""
}

/// Descript:   插入采购计划明细和请求明细关联
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-03
/// Table:DHC_INPPReqItm
/// Input:代码,描述
/// Output:     
/// Return：成功:0
/// -1:信息为空
/// -3   ;保存失败
ClassMethod Insert(Parref As %String, ListReqId As %String) As %Library.String
{
    n (Parref,ListReqId)
    q:Parref="" -1
    q:ListReqId="" -1
    ;
    s Len=$l(ListReqId,",")
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"
    f i=1:1:Len  q:Err'=0  d
    .s ReqId=$p(ListReqId,",",i)
    .q:ReqId=""
    .s Chl=1+$o(^INPP(+Parref,"PPI",$p(Parref,"||",2),"RQI",""),-1)
    .&sql(insert into DHC_INPPReqItm(PPREQI_INPPI_Parref,PPREQI_ChildSub,PPREQI_REQITM_DR) 
    values (:Parref,:Chl,:ReqId))
    .i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("Insert:DHC_INPPReqItm",Parref,SQLCODE_":"_%msg)
    ..s Err=-3
    .
    i Err'=0 trollback
    q:Err'=0 Err    ;保存失败
    tcommit
    ;
    q 0
}

/// Descript:判断某请求单明细是否全部被采购
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-03
/// Table:DHC_INPPReqItm
/// Input:请求单id
/// Output:     
/// Return:1:全部采购;0:存在未采购项目
ClassMethod CheckPur(ReqId As %String) As %Library.String
{
    n (ReqId)
    q:ReqId="" 1
    s Flag=1
    s Chl=0
    f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
    .s ReqItmId=ReqId_"||"_Chl
    .i '$d(^INPP(0,"RQI",ReqItmId))  d
    ..s Flag=0
    ;
    q Flag
}

ClassMethod NewPid() As %String
{
  q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

/// 查找请求单明细的转移数
/// Author:zhwh
/// Date:2012-07-18
/// Argu:
///  INRQI - 请求单明细rowid
/// Return:
///  转移数
///  w ##class(web.DHCST.INPurPlanAuxByReq).TransQty("5468||1")
ClassMethod TransQty(INRQI As %String) As %String
{
 n (INRQI)
 s sumQty=0
 s init=""
 f  s init=$O(^DHCINIT(0,"RQI",INRQI,init)) q:init=""  d
 .s ch=0
 .f  s ch=$O(^DHCINIT(0,"RQI",INRQI,init,ch)) q:ch=""  d
 ..s inclb=$P(^DHCINIT(init,"ITI",ch),"^",3)
 ..s qty=$P(^DHCINIT(init,"ITI",ch),"^",1)
 ..s uom=$P(^DHCINIT(init,"ITI",ch),"^",7)
 ..s buom=$P(^INCI(+inclb,1),"^",10)
 ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 ..s qty=qty*fac
 ..s sumQty=sumQty+qty
 q sumQty
}

}
