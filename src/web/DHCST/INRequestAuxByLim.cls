Import sqluser

/// 根据库存上下限辅助制作库存转移请求单
Class web.DHCST.INRequestAuxByLim Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 库存转移请求单项目列表(json)
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///   Start
///   Limit
///   Sort
///   Dir
///   sPar - 其他查询参数串("^"分隔)
/// Return：
///   请求单项目列表串(json) 
///  w ##class(web.DHCST.INRequestAuxByLim).jsLocItmForReq("0","30","code","desc","257^246^29^0^N^^0^",11643)
ClassMethod jsLocItmForReq(Start As %String, Limit As %String, Sort As %String, Dir As %String, sPar As %String, User As %String) As %String
{
 //s ^YSJTMP("jsLocItmForReq")=$LB(Start, Limit , Sort , Dir, sPar, User )
 s qPar=Sort_"^"_Dir
 s RecLoc =$p(sPar,"^",1)  //请求科室rowid
 s ReqLoc =$p(sPar,"^",2)  //供应科室rowid
 s SCG = $p(sPar,"^",3)   // 类组rowid
 s Man =$p(sPar,"^",4)  //管理组rowid
 s Round =$p(sPar,"^",5)  //取整系数
 s Pid=$p(sPar,"^",6)  //上次查询的pid
 s Flag=$p(sPar,"^",7) //1:翻页查询;0:重新查询
 s StkCatId=$p(sPar,"^",8) //库存分类
 i (Flag=1)&(Pid'="")  q ..QueryLocItmForReq(Start,Limit,Pid)    //如果是翻页查询的话从临时global里取数据
 i Pid'="" d ..KillTmpGlobal(Pid)    //重新查询需要kill上次查询生成的临时global
 ;
 s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
 s result=##class(%Library.ResultSet).%New("web.DHCST.INRequestAuxByLim:LocItmForReq")
 s sc=result.Execute(qPar,RecLoc,ReqLoc,SCG,Man,Round,StkCatId)  
 q:$$$ISERR(sc) ""  
 
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

/// 请求科室RowId，供应科室RowId，类组RowId=””，要求取整=””
/// 检索需要请求的库存项目明细列表
/// Author:zhwh
/// Date:2012-07-17
/// Argu:
///   qPar  - 
///   RecLoc - 请求科室rowid
///   ReqLoc -供方科室rowid
///   SCG  - 类组rowid
///   Man  - 管理药标志(0,1)
///   Round  -取整标志(Y/N)
Query LocItmForReq(qPar As %String, RecLoc As %String, ReqLoc As %String, SCG As %String, Man As %String, Round As %String, StkCatId As %String) As %Query(ROWSPEC = "inci:%String,code:%String,desc:%String,uom:%String,qty:%String,minQty:%String,maxQty:%String,repQty:%String,incil:%String,pUom:%String,pUomDesc:%String,sbdesc:%String,reqQty:%String,realReqQty:%String,pid:%String,ind:%String,stkCatDesc:%String,prvoqty:%String")
{
}

ClassMethod LocItmForReqExecute(ByRef qHandle As %Binary, qPar As %String, RecLoc As %String, ReqLoc As %String, SCG As %String, Man As %String, Round As %String, StkCatId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s pid=..NewPid()  ;zdm,2012-10-10,临时保存检索出的数据，生成请求单用
 s ind=1
 s qHandle=$lb(0,repid,0)

 s sql="select incil_inci_parref inci,"
 s sql=sql_"incil_inci_parref->inci_code code,"
  s sql=sql_"incil_inci_parref->inci_desc incdesc,"
  s sql=sql_"incil_inci_parref->inci_ctuom_dr uom,"
  s sql=sql_"incil_availqty avaQty , "   
  s sql=sql_"incil_minQty minQty," 
  s sql=sql_"incil_maxQty maxQty,"
  s sql=sql_"incil_repQty repQty,"
  s sql=sql_"incil_rowid incil,"
  s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
  s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
  s sql=sql_"incil_incsb_dr->incsb_desc sbDesc"
  s sql=sql_" From inc_itmloc where incil_ctloc_dr="_RecLoc

 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)

 s orderFieldName=""
 s:Sort="code" orderFieldName="code"   //代码
 s:Sort="desc" orderFieldName="desc"  //描述
 s:Sort="sbDesc" orderFieldName="sbDesc"   //货位
 
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i orderFieldName'="" d
 . s sql=sql_" order by "_orderFieldName_" "_Dir
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
	s inci=xrs.Data("inci")
	//continue:$P(^INCI(inci,2),"^",9)="Y"
	s code=xrs.Data("code")
	s desc=xrs.Data("incdesc")
	s uom=xrs.Data("uom")
	s avaQty=xrs.Data("avaQty")
	s minQty=xrs.Data("minQty")
	s maxQty=xrs.Data("maxQty")
	s repQty=xrs.Data("repQty")	;标准库存
	s incil=xrs.Data("incil")
	s pUom=xrs.Data("pUom")
	s pUomDesc=xrs.Data("pUomDesc")
	s sbDesc=xrs.Data("sbDesc")
	//continue:minQty=""   //下限未定义
	//continue:maxQty=""   //上限未定义
	continue:(repQty="")&&((minQty="")||(maxQty=""))
	;s levelQty=""
	s:repQty="" repQty=minQty+((maxQty-minQty)/2)   //计算标准库存
	s stkqty=""
	s stkqty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,RecLoc,+$h)
	s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s StkCatIdItm=$p(^INCI(inci,2),"^",2) //库存分类
	s stkCatDesc=""
	s:StkCatIdItm'="" stkCatDesc=$p(^INC("SC",StkCatIdItm),"^",2)
	continue:(StkCatId'="")&(StkCatIdItm'=StkCatId) 
	s ScgType=$p(StkGrpInfo,"^",3)
	s Scg=$p(StkGrpInfo,"^",5)
	continue:ScgType'=..sssCode()
	continue:(SCG'="")&(("^"_SCG_"^")'[("^"_Scg_"^"))
	;
	continue:(Man="1")&(##class(web.DHCST.Common.DrugStkCommon).UseFlag(inci,RecLoc)'="Y")   ; if managed requested then filter by manage attibute
	//continue:(Man="0")&(##class(web.DHCST.Common.DrugStkCommon).UseFlag(inci,RecLoc)=1 )    ; if not managed requested then filter the managed drugs
	continue:(ReqLoc'="")&($o(^INCI("IL_LOC",ReqLoc,inci,""))="")  //过滤掉"供方没有"的库存项目
	continue:stkqty'<repQty
	s prvoqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,ReqLoc,uom,+$h)  //供方库存
	s reqQty=repQty-stkqty   //请求数量
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,uom)
	s minQty=$fn(minQty/fac,"",2)
	s maxQty=$fn(maxQty/fac,"",2)
	s repQty=$fn(repQty/fac,"",2)
	s avaQty=$fn(avaQty/fac,"",2)
	s reqQty=$fn(reqQty/fac,"",2)
	s prvoqty=$fn(prvoqty/fac,"",2)
	s stkqty=$fn(stkqty/fac,"",2)
	s:Round="Y" reqQty=$fn(reqQty,"",0)
	s realReqQty=reqQty   //实际请求量  
	d OutPutRow1   
 }
 Q $$$OK
OutPutRow1
 s Data=$lb(inci,code,desc,uom,stkqty,minQty,maxQty,repQty,incil,pUom,pUomDesc,sbDesc,reqQty,realReqQty,pid,ind,stkCatDesc,prvoqty)   
 s ^CacheTemp(repid,ind)=Data
 s DataStr=inci_"^"_code_"^"_desc_"^"_uom_"^"_stkqty_"^"_minQty_"^"_maxQty_"^"_repQty_"^"_incil_"^"_pUom_"^"_pUomDesc_"^"_sbDesc_"^"_reqQty_"^"_realReqQty_"^"_pid_"^"_ind_"^"_stkCatDesc_"^"_prvoqty
 s ^DHCSTTMP("ReqByLimit",pid,ind)=DataStr
 s ind=ind+1
 q
}

ClassMethod LocItmForReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmForReqExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmForReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmForReqExecute ]
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

/// 从^DHCSTTMP("ReqByLimit")检索数据,分页显示用
/// Author:zhangdongmei
/// Date:2012-10-10
/// Argu: Start,Limit,Pid
/// Return：
///   请求单项目列表串(json) 
ClassMethod QueryLocItmForReq(Start As %String, Limit As %String, Pid As %String) As %String
{
    n (Start,Limit,Pid)
    q:Pid="" ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s i=0
    f  s i=$o(^DHCSTTMP("ReqByLimit",Pid,i))  q:i=""  d
    .s data=^DHCSTTMP("ReqByLimit",Pid,i)
    .s count = count+1
    .q:count<(Start+1)
    .q:count>end
    .;b ;f
    .d json.InsertRowData(data)
    .
    s Title="inci^code^desc^uom^qty^minQty^maxQty^repQty^incil^pUom^pUomDesc^sbdesc^reqQty^realReqQty^pid^ind"
    s resultString = json.getJsonData(Title,count)
    k json
    Q resultString
}

/// Descript:将用户修改的实际请求数量更新到临时global
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-10
/// Table:^DHCSTTMP("ReqByLimit")
/// Input:Pid;ind^qty,ind^qty
/// Output:     
/// Return：0:成功  
ClassMethod Save(Pid As %String, ListData As %String) As %String
{
    n (Pid,ListData)
    q:Pid="" -1    
    q:ListData="" -2
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    f i=1:1:Len  d
    .s Detail=$p(ListData,rowDelim,i)
    .s Ind=$p(Detail,"^",1)
    .s Qty=+$p(Detail,"^",2)
    .q:Ind=""
    .q:Qty<=0
    .;s data=^DHCSTTMP("ReqByLimit",Pid,Ind)
    .;s $LI(data,14)=Qty
    .s $p(^DHCSTTMP("ReqByLimit",Pid,Ind),"^",14)=Qty
    .
    q 0
}

/// Descript:根据库存上下限临时global生成请求单
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-10
/// Table:^DHCSTTMP("ReqByLimit")
/// Input:Pid;供应科室^请求科室^操作人id^类组id;
/// Output:     
/// Return：请求主表id:成功  
ClassMethod CreateReq(Pid As %String, ReqInfo As %String) As %String
{
    n (Pid,ReqInfo)
    q:Pid="" -11
    s FrLoc=$p(ReqInfo,"^",1)   //供应科室
    s ToLoc=$p(ReqInfo,"^",2)   //请领科室
    q:FrLoc="" -21
    q:ToLoc="" -31
    s UserId=$p(ReqInfo,"^",3)  //操作人id
    s StkGrp=$p(ReqInfo,"^",4)  //类组id
    s Status="O"    			//请领单
    s Remark="辅助请求(依据库存上下限)"
    s MainInfo=FrLoc_"^"_ToLoc_"^"_UserId_"^"_StkGrp_"^"_Status_"^"_Remark
    s reqParams=##class(web.DHCST.INRequest).GetParamProp("",FrLoc,"")
    s RQtyOverFlag=$p(reqParams,"^",1)
    s ListDetail=""
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()  
    s ind=0
    f  s ind=$o(^DHCSTTMP("ReqByLimit",Pid,ind))  q:ind=""  d
    .s Data=^DHCSTTMP("ReqByLimit",Pid,ind)
    .s IncId=$p(Data,"^",1)
    .s UomId=$p(Data,"^",10)
    .s Qty=$p(Data,"^",14)
    .s PrvoQty=$p(Data,"^",18) //wyx add 生成请求单时过滤
    .q:Qty<=0
    .q:(RQtyOverFlag'="Y")&&(PrvoQty<=0)
    .s ProReqQty=$p(Data,"^",13)	// 建议申请量 
    .s ReqItmId=""
    .i ListDetail=""  d
    ..s ListDetail=ReqItmId_"^"_IncId_"^"_UomId_"^"_Qty_"^^"_StkGrp_"^"_ProReqQty
    .e  d
    ..s ListDetail=ListDetail_rowDelim_ReqItmId_"^"_IncId_"^"_UomId_"^"_Qty_"^^"_StkGrp_"^"_ProReqQty
    .
    q:ListDetail="" -41
    s Ret=##class(web.DHCST.INRequest).Save("",MainInfo,ListDetail)
    i +Ret>0  d
    .d ..KillTmpGlobal(Pid)
    
    //q Ret
    s ReqNo=""
    i Ret>0 s ReqNo=$p($G(^INRQ(Ret)),"^",1)
    q Ret_"^"_ReqNo
}

/// 清除临时global数据(执行时机:清空页面、保存成功等)
/// 
ClassMethod KillTmpGlobal(Pid As %String) As %String
{
    q:Pid="" 0
    k ^DHCSTTMP("ReqByLimit",Pid)
    q 0
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

}
