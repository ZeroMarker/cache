Import sqluser

Class web.DHCST.INStkTk Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINSTKTK";

/// 空货位的排序值
Parameter NullStkBin [ Final ] = "ｚｚｚｚｚ";

/// 插入或更新盘点主表的一条记录
/// Author: zhwh
/// Date:2012-08-01
/// Argu:
///   inst -    盘点主表rowid
///   data -盘点主表数据串
/// Return:
///   >0 - 盘点主表rowid
///   <0 - 失败
ClassMethod Update(inst As %String, data As %String, TmpFlag As %String = "") As %String
{
 ;s inst="177",data="100^1^0^^^^^^^^^KKKKKKKKK"_$C(3)_"JJJJJJ"
 s loc=$P(data,"^",1)   //盘点科室RowId(不可为空)
 q:loc="" -1
 s user=$P(data,"^",2)   //帐盘人RowId(不可为空)
 q:user="" -2
 s uomType=$P(data,"^",3)   //帐盘单位类型 (0,1)
 s manGrpStr=$P(data,"^",4)   //管理组RowId串
 s scg=$P(data,"^",5)   //类组RowId
 s incsc=$P(data,"^",6)   //分类RowId
 s manFlag=$P(data,"^",7)   //管理药标志(此值为Y,则仅对管理药做帐盘)
 s includeNotUse=$P(data,"^",8)   //是否包括"不可用"(此值若不等于Y，则帐盘自动滤除不可用项目)
 s onlyNotUse=$P(data,"^",9)   //仅不可用项目(该值与includeNotUse互斥)
 s frStkBin=$P(data,"^",10)   //起始货位号
 s toStkBin=$P(data,"^",11)   //截止货位号
 s remarks=$P(data,"^",12)   //备注
 s dd=+$h
 s tt=$p($h,",",2)
 s err=0
 i inst=""  d
 .s obj=##class(User.DHCInStkTk).%New()
 .i TmpFlag="Y" s instno="临时查询数据"
 .e  s instno=##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),scg,loc)  //取盘点号
 .;b ;instno
 .i instno="" s err=-4 q
 .s obj.INSTNo=instno
 .
 e   d
 .s obj=##class(User.DHCInStkTk).%OpenId(inst)
 .d obj.%Reload()
 .
 i err'=0 q err
 ;
 s obj.INSTDate=dd
 s obj.INSTTime=tt
 s obj.INSTSSUSRDR=##class(User.SSUser).%OpenId(user,0)
 s obj.INSTCTLOCDR=##class(User.CTLoc).%OpenId(loc,0)
 s obj.INSTFreezeUom=uomType
 s obj.INSTManaFlag=manFlag
 s obj.INSTIncludeNotUse=includeNotUse
 s obj.INSTOnlyNotUse=onlyNotUse
 s obj.INSTINCSCDR=##class(User.INCStkCat).%OpenId(incsc,0)
 s obj.INSTSCGDR=##class(User.DHCStkCatGroup).%OpenId(scg,0)
 s obj.INSTFrStkBin=frStkBin
 s obj.INSTToStkBin=toStkBin
 
 //备注信息
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
 d obj.INSTRemarks.Clear()
 f i=1:1:$l(remarks,memoDelim) d
 .s rem1=$p(remarks,memoDelim,i)
 .d obj.INSTRemarks.Insert(rem1)
 //备注信息
 
 s sc=obj.%Save()
 //i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
 //b ;11
 i $$$ISERR(sc) q -3
 i inst="" s inst=obj.%Id()
 q inst
}

/// 删除盘点主表的一条记录
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
/// w ##class(web.DHCST.INStkTk).AllowDel(773,"")
ClassMethod Delete(inst As %String, instcomplete As %String = "") As %String
{
	//加锁
	q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inst)<0 -99
	s allowdel=0
	s allowdel=..AllowDel(inst,instcomplete)
	i allowdel<0 d ..uLock(..%GetParameter("AppName")_inst) q allowdel
	&sql(delete from dhc_instktk where %ID=:inst)
	s err=0
	i SQLCODE'=0 s err=-4
	d ..uLock(..%GetParameter("AppName")_inst) 
	q err
}

/// 删除盘点主表的一条记录
/// Author:wyx
/// Date:2013-11-25
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  
ClassMethod DeleteInstwd(inst As %String, phwindow As %String) As %String
{
 //加锁
 q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inst)<0 -99
 i ((..AllowDel(inst)<0)&(..AllowDel(inst)<"-3")) d ..uLock(..%GetParameter("AppName")_inst) q -100
 i phwindow="" d
 .&sql(delete from dhc_instktkitmwd where INSTW_INSTI_Parref->INSTI_INST_Parref=:inst and INSTW_PHW_DR IS NULL)
 e  d
 .&sql(delete from dhc_instktkitmwd where INSTW_INSTI_Parref->INSTI_INST_Parref=:inst and INSTW_PHW_DR=:phwindow)
 s err=0
 i SQLCODE'=0 s err=-1
 d ..uLock(..%GetParameter("AppName")_inst) 
 q err
}

/// 盘点完成
/// Author:zhangdongmei
/// Date:2012-08-29
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  
ClassMethod SetComplete(inst As %String) As %String
{
    n (inst)
    //加锁
    q:inst="" -1
    q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inst)<0 -99
    s CompleteFlag=$p(^DHCINST(inst),"^",12)
    i CompleteFlag="Y" d ..uLock(..%GetParameter("AppName")_inst) q -2
    ;
    &sql(update dhc_instktk set INST_Completed='Y' where %ID=:inst)
    s err=0
    i SQLCODE'=0 s err=-3
    d ..uLock(..%GetParameter("AppName")_inst) 
    q err
}

/// 盘点实盘完成
/// Author:zhangdongmei
/// Date:2012-09-11
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  
ClassMethod SetTkComplete(inst As %String) As %String
{
    n (inst)
    //加锁
    q:inst="" -1
    q:##class(web.DHCST.Common.AppCommon).Lock(..%GetParameter("AppName")_inst)<0 -99
    s CompleteFlag=$p(^DHCINST(inst),"^",13)
    i CompleteFlag="Y" d ..uLock(..%GetParameter("AppName")_inst) q -2
    ;
    &sql(update dhc_instktk set INST_StockTakeComplete='Y',INST_Status='E' where %ID=:inst)
    s err=0
    i SQLCODE'=0 s err=-3
    d ..uLock(..%GetParameter("AppName")_inst) 
    q err
}

/// 判断是否允许删除一条盘点主表记录
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 -  可以删除
///  <0 - 不可以
ClassMethod AllowDel(inst As %String, instcomplete As %String = "") As %String
{
  n (inst,instcomplete)
  q:inst=""
  s obj=##class(User.DHCInStkTk).%OpenId(inst,0)
  d obj.%Reload()
  s comp=obj.INSTCompleted
  i (instcomplete="")&&(comp="Y") q -3  //控制账盘完成可删,yunhaibao20151120
  s inadjid=obj.INSTINADDRGetObjectId()  // 已经产生了库存调整单，不允许删除盘点单  yangsj2019-12-06
  q:inadjid'="" -5
  s adj=obj.INSTStockTakeComplete
  i adj="Y" q -1
  s adj=obj.INSTAdjustmentComplete
  i adj="Y" q -2
  q 0
}

/// 取一条记录的数据串(属性之间用"^"分隔)
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///   记录数据串
/// w ##class(web.DHCST.INStkTk).Select(832)
ClassMethod Select(inst As %String) As %String
{
 n (inst)
 q:inst="" ""
 ;
 s result=""
 &sql(select INST_No,INST_Date,INST_SSUSR_DR,INST_CTLOC_DR,INST_Status,INST_Time,
 INST_Remarks,INST_Completed,INST_StockTakeComplete,INST_AdjustmentComplete,
 INST_INAD_DR,INST_ManaFlag,INST_FreezeUom,INST_IncludeNotUse,INST_OnlyNotUse,
 INST_SCG_DR,INST_INCSC_DR,INST_FrStkBin,INST_ToStkBin into :InstNo,
 :InstDate,:UserId,:LocId,:Status,:InstTime,:Remarks,:Comp,:StkTakeComp,:AdjComp,:Inad,
 :ManFlag,:TkUom,:IncludeNotUse,:OnlyNotUse,:StkGrpId,:StkCatId,:FrStkBin,:ToStkBin  
 from DHC_InStkTk where %ID=:inst)
 q:SQLCODE ""
 s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
 s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
 s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
 s:FrStkBin'="" FrStkBinDesc=$p(^INC("SB",FrStkBin),"^",2)
 s:ToStkBin'="" ToStkBinDesc=$p(^INC("SB",ToStkBin),"^",2)
 s:InstDate'="" InstDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InstDate,"ST")
 s:InstTime'="" InstTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(InstTime,"ST")
 s memoDelim=##class(web.DHCST.Common.UtilCommon).MemoDelim()  //备注内容分隔符
 s Remarks=$lts(Remarks,memoDelim)   //备注内容转换为字符串
 s data1=InstNo_"^"_InstDate_"^"_InstTime_"^"_UserId_"^"_$g(UserName)_"^"_LocId_"^"_$g(LocDesc)
 s data2=Status_"^"_Remarks_"^"_Comp_"^"_StkTakeComp_"^"_AdjComp_"^"_Inad_"^"_ManFlag_"^"_TkUom
 s data3=IncludeNotUse_"^"_OnlyNotUse_"^"_StkGrpId_"^"_StkCatId_"^"_$g(StkCatDesc)_"^"_FrStkBin
 s data4=$g(FrStkBinDesc)_"^"_ToStkBin_"^"_$g(ToStkBinDesc)
 q data1_"^"_data2_"^"_data3_"^"_data4
}

/// 解锁
ClassMethod uLock(inst As %String)
{
 d ##class(web.DHCST.Common.AppCommon).UnLock(..%GetParameter("AppName")_inst)  
 q
}

/// 检索盘点主表明细记录
/// 
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  Loc - 科室RowId
///  StartDate -起始日期
///  EndDate - 截止日期
/// 
Query DHCSTINStkTk(Sort As %String, Dir As %String, Loc As %String, StartDate As %String, EndDate As %String, InstComp As %String, StkTkComp As %String, AdjComp As %String, StartTime As %String, EndTime As %String) As %Query(ROWSPEC = "inst:%String,instNo:%String,date:%String,time:%String,user:%String,userName:%String,status:%String,loc:%String,locDesc:%String,comp:%String,stktkComp:%String,adjComp:%String,adj:%String,manFlag:%String,freezeUom:%String,includeNotUse:%String,onlyNotUse:%String,scg:%String,scgDesc:%String,sc:%String,scDesc:%String,frSb:%String,toSb:%String,InputType:%String")
{
}

ClassMethod DHCSTINStkTkExecute(ByRef qHandle As %Binary, Sort As %String, Dir As %String, Loc As %String, StartDate As %String, EndDate As %String, InstComp As %String, StkTkComp As %String, AdjComp As %String, StartTime As %String, EndTime As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:Loc="" $$$OK
 	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
    s sql=" select %id rowid,"
    s sql=sql_"inst_no instNo,"
    s sql=sql_"inst_date d,"
    s sql=sql_"inst_time t,"
    s sql=sql_"inst_ssusr_dr instUser,"
    s sql=sql_"inst_ssusr_dr->ssusr_name userName,"
    s sql=sql_"inst_ctloc_dr loc,"
    s sql=sql_"inst_ctloc_dr->ctloc_desc locDesc,"
    s sql=sql_"inst_status status,"
    s sql=sql_"inst_completed comp,"
    s sql=sql_"inst_stocktakecomplete stktkComp,"
    s sql=sql_"inst_adjustmentComplete adjComp,"
    s sql=sql_"inst_inad_dr adj,"
    s sql=sql_"inst_manaflag manFlag,"
    s sql=sql_"inst_freezeuom freezeUom,"
    s sql=sql_"inst_includenotuse includeNotUse,"
    s sql=sql_"inst_onlynotuse onlyNotUse,"
    s sql=sql_"inst_scg_dr scg,"
    s sql=sql_"inst_scg_dr->scg_desc scgDesc,"
    s sql=sql_"inst_incsc_dr incsc,"
    s sql=sql_"inst_incsc_dr->incsc_desc incscDesc,"
    s sql=sql_"inst_frstkbin frSb,"
    s sql=sql_"inst_tostkbin toSb,"
    s sql=sql_"INST_InputType pdaInputType"
    s sql=sql_" from dhc_instktk where inst_ctloc_dr="_Loc_" and inst_date between "_StartDate_" and "_EndDate

 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 i Sort'=""  d
 .s sql=sql_" order by "_Sort_" "_Dir
 ;
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
    s inst=xrs.Data("rowid")
    s instNo=xrs.Data("instNo")
    s date=xrs.Data("d")
    s time=xrs.Data("t")
    continue:(time<StartTime)&&(StartTime'="")&&(date=StartDate)
    continue:(time>EndTime)&&(EndTime'="")&&(date=EndDate)
    i date'="" s date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
    i time'="" s time=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time,"ST")
    
    s user=xrs.Data("instUser")
    s userName=xrs.Data("userName")
    s status=xrs.Data("status")
    s loc=xrs.Data("loc")
    s locDesc=xrs.Data("locDesc")
    ;
    s comp=xrs.Data("comp")
    s:comp="" comp="N"
    continue:(InstComp'="")&(comp'=InstComp)
    s stktkComp=xrs.Data("stktkComp")
    s:stktkComp="" stktkComp="N"
    continue:(StkTkComp'="")&(stktkComp'=StkTkComp)
    s adjComp=xrs.Data("adjComp")
    s:adjComp="" adjComp="N"
    continue:(AdjComp'="")&(adjComp'=AdjComp)
    ;
    s adj=xrs.Data("adj")
    s manFlag=xrs.Data("manFlag")
    s freezeUom=xrs.Data("freezeUom")
    s includeNotUse=xrs.Data("includeNotUse")
    s onlyNotUse=xrs.Data("onlyNotUse")
    s scg=xrs.Data("scg")
    s scgDesc=xrs.Data("scgDesc")
    s sc=xrs.Data("incsc")
    s scDesc=xrs.Data("incscDesc")
    s frSb=xrs.Data("frSb")
    i frSb'="" s frSb=$p(^INC("SB",frSb),"^",2)
    s toSb=xrs.Data("toSb")
    i toSb'="" s toSb=$p(^INC("SB",toSb),"^",2)
    s inputType=""
    s pdaInputType=xrs.Data("pdaInputType") 
    i pdaInputType'="" s inputType=pdaInputType   ;本盘点单是移动端盘点方式
    e  d
    .s stp=$o(^DHCINST(inst,"STP",0))
    .i stp'=""  d
    ..s inputType=2      ;本盘点单是按品种进行实盘
    .e  d
    ..s stw=..CheckItmWd(inst)
    ..s:stw=1 inputType=1   ;本盘点单是按批次进行实盘
    ..
    d OutPurRow1
 }
 Quit $$$OK
    
OutPurRow1
 s Data=$lb(inst,instNo,date,time,user,userName,status,loc,locDesc,comp,stktkComp,adjComp,adj,manFlag,freezeUom,includeNotUse,onlyNotUse,scg,scgDesc,sc,scDesc,frSb,toSb,inputType)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 判断某一盘点单是否选择了实盘方式（1：分批次：2：按品种）
/// Author:zhangdongmei
/// Date:2012-09-10
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  1：分批次：2：按品种
/// 
ClassMethod CheckItmWd(inst) As %String
{
    n (inst)
    s flag=0   ;没按批次进行实盘
    
	s stp=$o(^DHCINST(inst,"STP",0))
    q:stp'="" 2
    
    s chl=0
    f  s chl=$o(^DHCINST(inst,"STI",chl))  q:(chl="")!(flag'=0)  d
    .s sub=0
    .f  s sub=$o(^DHCINST(inst,"STI",chl,"STW",sub))  q:(sub="")!(flag'=0)  d
    ..s flag=1
    .
    q flag
}

ClassMethod DHCSTINStkTkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCSTINStkTkExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCSTINStkTkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCSTINStkTkExecute ]
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

/// 取盘点主表记录数据串(json)
/// Author:zhwh
/// Date:2012-08-03
/// Argu:
///  Loc  -科室rowid
///  StartDate -起始日期
///  EndDate - 截止日期
///  InstComp  -帐盘完成
///  StkTkComp - 实盘（汇总）完成
///  AdjComp - 盘点调整完成
/// Return:
///  主表记录数据串(json)
ClassMethod jsDHCSTINStkTk(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Params As %String) As %String
{
	n (Start,Limit,Sort,Dir,Params)
	s Loc=$p(Params,"^",1)
	s StartDate=$p(Params,"^",2)
	s EndDate=$p(Params,"^",3)
	s InstComp=$p(Params,"^",4)
	s StkTkComp=$p(Params,"^",5)
	s AdjComp=$p(Params,"^",6)
	s StartTime=$p(Params,"^",7)
	s EndTime=$p(Params,"^",8)
	q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	i Loc="" q ""

	s result=##class(%Library.ResultSet).%New("web.DHCST.INStkTk:DHCSTINStkTk")   
	s sc=result.Execute(Sort,Dir,Loc,StartDate,EndDate,InstComp,StkTkComp,AdjComp,StartTime,EndTime)
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
		continue:(count<=Start)||(count>end)
		d json.InsertRowData(tmp)
	}
	d result.Close() 
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
}

/// 插入盘点科室管理组(在帐盘时)
/// Author:zhwh
/// Date:2012-08-03
/// Argu:
///  Inst - 盘点主表rowid
///  manGrpStr - 盘点管理组串
/// Return:
///  0 - success
///  <0  - failure
ClassMethod InsStktkManGrp(Inst As %String, manGrpStr As %String, WithOutSelectLMGFlag As %String) As %String
{
 n (Inst,manGrpStr,WithOutSelectLMGFlag)
 q:Inst="" -1
 s err=0
 f i=1:1:$l(manGrpStr,",") q:err<0  d
 .s manGrp=$p(manGrpStr,",",i)
 .s ret=##class(web.DHCST.INStkTkGrp).Update("",Inst,manGrp,WithOutSelectLMGFlag)
 .i ret<0  s err=-2 q   
 q err
}

/// 创建盘点
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
/// data - 盘点数据("^")
/// Return:
/// >0 - 盘点主表rowid
/// <0 - 失败
/// lastupdate:yunhaibao,修正事务,防止数量大时加大量锁
/// w ##class(web.DHCST.INStkTk).CreateInStktk("165^13609^1^^3^^N^N^N^^^N^N","")
ClassMethod CreateInStktk(data As %String, TmpFlag As %String = "") As %String
{
	n (data,TmpFlag)
	s manGrpStr=$P(data,"^",4)   //管理组RowId串
	s inclbzeroflag=$P(data,"^",12) //是否过滤批次库存为0 
	s WithOutSelectLMGFlag=$P(data,"^",13) //是否过滤选中管理组
	s error=0
	ts
	s inst=##class(web.DHCST.INStkTk).Update("",data,TmpFlag)
	i inst<0  tro  s error=inst  //-4,生成盘点单号失败；-1：盘点科室不能为空;-2:盘点人不能为空;-3:主表记录插入失败
	q:error<0 error
	i manGrpStr'="" d
	.s ret=..InsStktkManGrp(inst,manGrpStr,WithOutSelectLMGFlag)
	.i ret<0 tro  s error=-5   //管理组记录插入失败
	q:error<0 error
	tc  
	s ret=..InsInStkTkItm(inst,inclbzeroflag)
	i ret<0  s error=-6  //插入帐盘明细失败
	i ret=0  s error=-7  //没有符合条件的盘点明细
	i error<0 d ..Delete(inst,"") 
	q:error<0 error
	q inst
}

/// 生成并插入帐盘明细记录数据
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///    inst -盘点主表rowid
/// Return:
///  >0 - 行数
///  
ClassMethod InsInStkTkItm(inst As %String, inclbzeroflag As %String = "") As %String
{
	n (inst,inclbzeroflag)   
	k InsInStkTkItmDATA		// 用于按货位排序
	k InsInStkTkItmBinARR	// 记录货位区间
	s obj=##class(User.DHCInStkTk).%OpenId(inst,0)
	d obj.%Reload()
	s loc=obj.INSTCTLOCDRGetObjectId()
	s pManaFlag=obj.INSTManaFlag
	s pScg=obj.INSTSCGDRGetObjectId()
	s pIncsc=obj.INSTINCSCDRGetObjectId()
	s pIncludeNotUse=obj.INSTIncludeNotUse
	s pOnlyNotUse=obj.INSTOnlyNotUse
	s pFrStkBin=obj.INSTFrStkBin
	s pToStkBin=obj.INSTToStkBin
	s pManGrpStr=..GetManGrpStr(inst)
	s IfIncludeLmg=$P(pManGrpStr,"#",1)
	s pManGrpStr=$P(pManGrpStr,"#",2)
	s n=0
	s sbDescStr=""
	i pFrStkBin'="",pToStkBin'="" d
	.//d ..GetStkBinScope(loc,pFrStkBin,pToStkBin,.InsInStkTkItmBinARR)  // 盘点项目货位串,引用来
	.d ..GetStkBinScopeNew(loc,pFrStkBin,pToStkBin,.InsInStkTkItmBinARR)  // 盘点项目货位串,引用来
	// 盘点所有批次  add by zhaoxinlong 2022.06.28
	k ^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB")
	s date = $p(^DHCINST(inst), "^", 2)
	s lastDate = +$h -1
	s inclb = ""
	for {
		s inclb = $o(^DHCBTLOCTOT("0","LocDateINCLB", loc, lastDate, inclb))
		q:(inclb = "")
		s ^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB",inclb) = ""
	}
	// 当天新增批次记录
	s inclb = ""
	for {
		s inclb = $o(^DHCBTLOCTOT("0","LocDateINCLB", loc, date, inclb))
		q:(inclb = "")
		continue:$d(^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB", inclb))
		s ^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB", inclb) = ""
	}
	s err=0
	s inclb=""
	//f  s inclb=$o(^DHCINCLBi("ACSTK","Y",loc,inclb)) q:(inclb="")!(err'=0)  d  //dhc_incitmlcbt
	f  s inclb = $o(^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB", inclb))  q:(inclb="")!(err'=0)  d
	.q:$p(inclb,"||",3)=0
	.s incil=$P(inclb,"||",1,2),inci=$P(inclb,"||",1)
	.s incib=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.q:incib=""
	.q:$p(incib,"||",2)=""
	.s NotUseFlag=$p(^INCI(inci,2),"^",9)  
	.q:..IfInclude(NotUseFlag,pIncludeNotUse,pOnlyNotUse)=0   //2011-03-29 zhwh
	.//过滤批次库存为0,yunhaibao20151203,按此过滤不更新批次可用状态
	.s zeroflag=""
	.i inclbzeroflag="Y" d
	..s curinclbqty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
	..i curinclbqty=0 s zeroflag=1
	.q:zeroflag=1
	.//过滤类组
	.s ret=0
	.i pScg'="" d
	..s scg=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	..s scg=$p(scg,"^",5)
	..i scg'=pScg  s ret=-1
	.q:ret<0
	.//过滤库存分类
	.s incsc=$P(^INCI(inci,2),"^",2) 
	.s incscType = $P(^INC("SC",incsc),"^",3)
	.q:incscType'=..#StkTypeCode
	.i pIncsc'="" q:incsc'=pIncsc
	.s manaFlag="",lmg=""
	.s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	.i dhcincil'="" d
	..s manaFlag=$P(^DHCINCIL(dhcincil),"^",9)  //管理药标志
	..i manaFlag=1 s manaFlag="Y" 
	..s lmg=$P(^DHCINCIL(dhcincil),"^",7)  //管理组rowid
	.//管理药过滤
	.q:(pManaFlag="Y")&(manaFlag'=pManaFlag)
	.q:(IfIncludeLmg="Y")&&(pManGrpStr'="")&(lmg="")
	.i (IfIncludeLmg="Y")&&(pManGrpStr'="") q:pManGrpStr'[("^"_lmg_"^")
	.i (IfIncludeLmg'="Y") q:pManGrpStr[("^"_lmg_"^")   //如果是不包含，则过滤维护的管理组
	
	.//货位过滤
	.s sbDesc=""
	.//取新科室货位表过滤货位
	.s stkBinRet=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
	.s stkBinStr=$p(stkBinRet,":",2)
	.s stkBinExist=1
	.s sbDesc=stkBinStr
	.s chkStkBinRet=""
	.i (sbDesc'="")&&((pFrStkBin'="")||(pFrStkBin'="")) d 
	..s chkStkBinRet=..CheckStkBin("",stkBinStr,.InsInStkTkItmBinARR)
	..s stkBinExist=$p(chkStkBinRet,":",1)
	..s newStkBin=$p(chkStkBinRet,":",2)	// 匹配后的货位
	..s sbDesc=newStkBin
	.q:stkBinExist=0
	.s inactive=..CheckInclbInactive(inclb,inst)
	.i inactive=1  d
	..s ret=##class(web.DHCST.Common.StockHandle).UpdateDhcIncItmLcBt(inclb,"N","N")
	..i +ret<=0 s err=-11
	.q:inactive=1  ;该批次库存项未激活
	.q:err'=0
	.s firstBinDesc=$p(sbDesc,",",1)	// 多货位首个
	.i firstBinDesc="" s firstBinDesc=..#NullStkBin
	.s sortIndex=firstBinDesc
	.s inclbIndex=$j(inci,6)_"||"_$j($p(inclb,"||",2),6)_"||"_$j($p(inclb,"||",3),6)
	.s InsInStkTkItmDATA(sortIndex,inclbIndex)=inclb_"^"_sbDesc
	s sortIndex=""
	f  s sortIndex=$o(InsInStkTkItmDATA(sortIndex)) q:sortIndex=""  d
	.s inclbIndex=""
	.f  s inclbIndex=$o(InsInStkTkItmDATA(sortIndex,inclbIndex)) q:inclbIndex=""  d
	..s data=InsInStkTkItmDATA(sortIndex,inclbIndex)
	..s inclb=$p(data,"^",1)
	..s sbDesc=$p(data,"^",2)
	..ts
	..s insti=##class(web.DHCST.INStkTkItm).Update("",inst,inclb,sbDesc)
	..s:insti="" err=-1
	..i err=-1 tro
	..e  tc
	..s n=n+1
	k ^||TMP("PHA",$classname(),"InsInStkTkItm", "INCLB")
	q:err'=0 err
	q n
}

/// 取盘点的管理组信息串
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///  inst -盘点主表rowid
/// Return:
///   管理组信息串
/// w ##class(web.DHCST.INStkTk).GetManGrpStr(23)
ClassMethod GetManGrpStr(inst As %String) As %String
{
 s tgRs=##class(%ResultSet).%New("web.DHCST.INStkTkGrp:DHCSTInStkTkGrp")
 i tgRs="" q "" 
  
 s sc=tgRs.Execute(inst)
 i $$$ISERR(sc) q ""
 s manaGrpStr=""
 s IFInclud=""
 while (tgRs.Next())
 {
  s tg=tgRs.Data("lmg")
  s IFInclud=tgRs.Data("IFInclud")  
  s manaGrpStr= manaGrpStr_"^"_+tg
 }
 i manaGrpStr'="" s manaGrpStr=manaGrpStr_"^"
 q IFInclud_"#"_manaGrpStr
}

/// Desc:是否应当包括该库存项目
/// Create BY :zhwh
/// CreateDate:2011-03-29
/// return:
///   1- 包括
///   0 - 不包括
ClassMethod IfInclude(notuseFlag, includeNotUse, onlyNotUse)
{
  n (notuseFlag,includeNotUse,onlyNotUse) 
  s ret=""
  i onlyNotUse="Y" d
  .i notuseFlag="Y" s ret=1
  .e  s ret=0
  q:ret'="" ret
  i includeNotUse="Y" d
  . s ret=1
  e  d
  . i notuseFlag="Y" s ret=0
  . e  s ret=1
  q ret
}

/// 取出起始货位和截止货位之间的所有货位
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///  loc - 科室rowid
///  frStkBin- 起始货位名称
///  toStkBin- 截止货位名称
/// Return:
///  货位串
///  w ##class(web.DHCST.INStkTk).GetStkBinScope("257","1","5",.AAA)
ClassMethod GetStkBinScope(loc As %String, frStkBin As %String, toStkBin As %String, ByRef RetStkBinScopeArr) As %String
{
	n (loc,frStkBin,toStkBin,RetStkBinScopeArr)
	s result=""
	q:frStkBin="" result
	q:toStkBin="" result
	s code= loc_"P%"
	s frStkBinDesc=$p(^INC("SB",frStkBin),"^",2)
	s toStkBinDesc=$p(^INC("SB",toStkBin),"^",2)
	s toStkBinDesctmp=$p(^INC("SB",toStkBin),"^",2)
	&sql(
		declare sbend cursor for 
		select incsb_desc From inc_stkbin 
		where 
		incsb_code like :code
		order by incsb_desc desc
	)
	&sql(
		open sbend
	) 
	&sql(
		fetch sbend into :sbEndDesc
	)
	i (frStkBinDesc'="空")&(toStkBinDesctmp="空") s toStkBinDesc=sbEndDesc
	&sql(
		declare sb cursor for 
		select incsb_desc From inc_stkbin 
		where 
		incsb_code like :code
		and incsb_desc between :frStkBinDesc and :toStkBinDesc
		order by incsb_desc 
	)
	&sql(
		open sb
	)    
	f  &sql(fetch sb into :sbDesc) q:SQLCODE  d
	.s result=result_"^"_sbDesc
	.q:sbDesc=""
	.s RetStkBinScopeArr(sbDesc)=""
	&sql(close sb)    
	i result'="" s result=result_"^"
	i (frStkBinDesc'="空")&(toStkBinDesctmp="空") s result=result_"空"_"^" 
	q result
}

/// 取出起始货位和截止货位之间的所有货位
/// Author:yangsj
/// Date:2020-06-22
/// Argu:
///  loc - 科室rowid
///  frStkBin- 起始货位名称
///  toStkBin- 截止货位名称
/// Return:
///  货位串
///  w ##class(web.DHCST.INStkTk).GetStkBinScopeNew("251","40","41",.AAA)
ClassMethod GetStkBinScopeNew(loc As %String, frStkBin As %String, toStkBin As %String, ByRef RetStkBinScopeArr) As %String
{
	n (loc,frStkBin,toStkBin,RetStkBinScopeArr)
	s result=""
	q:frStkBin="" result
	q:toStkBin="" result
	s code= loc_"P"
	s frStkBinDesc=$p(^INC("SB",frStkBin),"^",2)
	s toStkBinDesc=$p(^INC("SB",toStkBin),"^",2)
	
	s tmpstkbin=0
	f  s tmpstkbin=$O(^INC("SB",tmpstkbin)) q:tmpstkbin=""  d
	.s stkbincode=$p(^INC("SB",tmpstkbin),"^",1)
	.q:$P(stkbincode,code,1)'=""
	.s tmpstkbindesc=$p(^INC("SB",tmpstkbin),"^",2)
	.q:tmpstkbindesc<frStkBinDesc
	.q:tmpstkbindesc>toStkBinDesc
	.s result=result_"^"_tmpstkbindesc
	.s RetStkBinScopeArr(tmpstkbindesc)=""
	i result'="" s result=result_"^"

	q result
}

/// 取某药品帐盘批次(实盘录入方式二用)
/// Author:zhangdongmei
/// Date:2012-09-05
/// Argu:
///  Inst - 盘点单rowid
///  Inci- 库存项rowid
/// Return:盘点子表id^批次效期
ClassMethod GetItmFreezeBatch(Inst As %String, Inci As %String) As %String
{
    n (Inst,Inci)
	k GetItmFreezeBatchData
    q:(Inst="")||(Inci="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Chl=""
	f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:Chl=""  d
	.q:+Chl=0
	.s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	.s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	.s SortIndex=+ExpDate
	.s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
    .s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    .s BatExp=BatNo_"~"_ExpDate
	.s Insti=Inst_"||"_Chl
	.s Data=Insti_"^"_BatExp_"^"_FreUom
	.s GetItmFreezeBatchData(SortIndex,Chl)=Data

    s Count=0
    s Result=""
    s Json = ##class(Code.JsonObj).%New()	
	s SortIndex=""
	f  s SortIndex=$o(GetItmFreezeBatchData(SortIndex),-1) q:SortIndex=""  d
	.s Chl=""
	.f  s Chl=$o(GetItmFreezeBatchData(SortIndex,Chl)) q:Chl=""  d
    ..s Count=Count+1
	..s Data=GetItmFreezeBatchData(SortIndex,Chl)
    ..d Json.InsertRowData(Data)
	s Result=Json.getJsonData("RowId^Description",Count)
	q Result
}

/// Description:检查某批次是否可设置为未激活状态（上次盘存为0，且至今盘点未发生过业务）
/// Author:zhangdongmei
/// Date:2013-01-15
/// Argu:
///  Inclb - 批次id
///  Inst- 本次盘点rowid
/// Return:1：可设置为未激活状态；0：保持激活
ClassMethod CheckInclbInactive(Inclb As %String, Inst As %String) As %String
{
    n (Inclb,Inst)
    q:Inclb="" 0
    q:Inst="" 0
    ;
    s Exist=0    ;标识是否找到该项目
    s LastInstId=""
    s LastInst=Inst
    f  s LastInst=$o(^DHCINST(LastInst),-1)  q:(LastInst="")!(Exist=1)  d
    .s AdjCompFlag=$p($g(^DHCINST(LastInst)),"^",14)   ;调整完成标志
    .q:AdjCompFlag'="Y"   ;该盘点单未进行盘点调整，不是有效的盘点单
    .s AdjDr=$p(^DHCINST(LastInst),"^",15)
    .q:AdjDr=""             ;该盘点单未进行盘点调整，不是有效的盘点单
    .s chl=$o(^DHCINST(LastInst,"STI",0,Inclb,""))
    .i chl'=""  d
    ..s Exist=1    ;找到了该药品的最后一次盘点单
    ..s LastInstId=LastInst
    .
    q:LastInstId="" 0  ;该项目从未盘点过
    s LastAdjDr=$p(^DHCINST(LastInstId),"^",15)
    s AdjDate=$p(^DHCINAD(LastAdjDr),"^",8)   ;该批次药最后一次盘点的调整日期
    s InclbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,AdjDate)
    ;
    s result=0
    i InclbQty=0   d   ;上次结存等于0
    .s TrDate=$o(^DHCINTR(0,"INCLB",Inclb,AdjDate))   ;该药品调整后的第一笔业务日期
    .i TrDate=""   d
    ..s result=1 ;上次结存等于0，且至今未发生业务，设置为未激活
    .
    q result
}

/// Description:检查盘点帐盘的开始结束区间的货位串是否存在科室库存货位(可多货位)串
/// Author:wyx
/// Date:2013-11-21
/// Argu:
///  SBStkBin - 盘点帐盘的开始结束区间的货位串
///  ILStkBin 科室库存货位(可多货位)串
/// Return:是否存在盘点货位区间的货位串,chkflag:1为有在区间的货位，0为没有在区间的货位，retstkstr在区间的货物串
ClassMethod CheckStkBin(SBStkBin, ILStkBin, ByRef ILStkBinArr)
{
	n (SBStkBin,ILStkBin,ILStkBinArr)
	s chkflag=0
	s retstkstr=""
	s cnt=$l(ILStkBin,",")
	f i=1:1:cnt d
	.s sbDesc=$p(ILStkBin,",",i)
	.q:(SBStkBin'="")&&(SBStkBin'[("^"_sbDesc_"^")) // 按字符
	.q:(SBStkBin="")&&('$d(ILStkBinArr(sbDesc)))	// 按数组	
	.s chkflag=1
	.i retstkstr="" s retstkstr=sbDesc
	.e  s retstkstr=retstkstr_","_sbDesc	
	q chkflag_":"_retstkstr
}

ClassMethod NewPid()
{
 
   q $I(DHCSTPID("INStkTk"))
}

/// Descript:取盘点帐盘界面参数配置属性
/// Creater:    wyx
/// CreateDate: 2014-03-10
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：未完成单据提示
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    //s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.INStkTk).%GetParameter("AppName")
    s IfCompleted=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"IfCompleted",Param)
    s Data1=IfCompleted
    //s Data2=MarginWarning_"^"_AllowInputRpAmt_"^"_PurchaserNotNull_"^"_ImpTypeNotNull_"^"_ValidateMaxSp_"^"_DefaStartDate_"^"_DefaEndDate
    q Data1
}

/// creator:yunhaibao
/// createdate:20160229
/// description:验证某批次是否存在于某盘点单中
/// input:盘点单id,批次id
/// output:>0存在
ClassMethod CheckInclbExistInInStk(Inst, Inclb)
{
	n (Inclb,Inst)
	q:Inclb="" -1
	q:Inst="" -2
	q:'$d(^DHCINST(Inst,"STI",0)) -3
	q:'$d(^DHCINST(Inst,"STI",0,Inclb)) 0 
	q 1
}

/// creator:yangsj
/// createdate:2021-01-15
/// description:更新盘点主表的盘点录入方式字段
/// input:盘点单id,盘点方式
/// output:0 成功，其他失败
/// w ##class(web.DHCST.INStkTk).UpdateInInStkInputType(158,6)
ClassMethod UpdateInInStkInputType(Inst, InputType)
{
	n (Inst,InputType)
	q:Inst="" -1
	q:InputType="" -2
	q:$P(^DHCINST(Inst),"^",31)'="" -3
	&SQL(UPDATE DHC_InStkTk SET  INST_InputType=:InputType  WHERE INST_RowId =:Inst)
	q SQLCODE
}

}
