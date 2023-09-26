Import sqluser

Class web.DHCST.INCStkBin Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 批量保存货位码记录
/// Author:zhangdongmei
/// Date:2012-08-20
/// Argu:科室rowid,货位id^货位名称,货位id^货位名称
/// Return ：
///  0 - 成功
///  <0 - 插入或更新失败
///  w ##class(web.DHCST.INCStkBin).Save("257","^A")
ClassMethod Save(Loc As %String, ListDetail As %String) As %String
{
    n (Loc,ListDetail)
    q:Loc="" -1   ;科室不能为空
    q:ListDetail="" -2   ;没有要保存的明细
    s Err=""
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListDetail,rowDelim)
    s msg=0
    f i=1:1:Len q:msg'=0  d
    .s Detail=$p(ListDetail,rowDelim,i)
    .s Rowid=$p(Detail,"^",1)
    .s Desc=$p(Detail,"^",2)
    .//s stkBinId=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),""))
    .s stkBinId="",flag=0
    .f  s stkBinId=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),stkBinId)) q:(stkBinId="")||(flag'=0)  d
    ..;---------------------------add by myq 20141127
    ..i +stkBinId>0 d
    ...s tmpDesc=$P(^INC("SB",stkBinId),"^",2)
    ...q:tmpDesc'=Desc   //区分大小写 
    ...s incsbCodeLoc=""
    ...s incsbCode=$p(^INC("SB",stkBinId),"^",1)
    ...s:incsbCode["P" incsbCodeLoc=$p(incsbCode,"P",1)
    ...s:incsbCodeLoc=Loc flag=-4   ;货位名称重复
    ...s msg=flag
    .;-------------------------add by myq 20141127
    .s:flag'=0 msg=-4   ;货位名称重复
    .q:msg'=0
    .s ret=..Update(Rowid,Loc,Desc)
    .i +ret<0  d
    ..i Err=""  d
    ...s Err=Desc
    ..e  d
    ...s Err=Err_","_Desc
    ..
    .
    q:msg'=0 msg
    q:Err="" 0   ;保存成功
    q "-3"_":"_Err  ;保存失败的明细
}

/// 插入或更新1条货位代码记录
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
///   Loc - 科室rowid
///   sbDesc -货位名称
/// Return ：
///  >0 - 货位码记录rowid
///  <0 - 插入或更新失败
///  
ClassMethod Update(sb As %String, Loc As %String, sbDesc As %String) As %String
{
  q:Loc="" -100   //科室rowid不可为空
  s err=0
  //s id=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(sbDesc),0))
  s id="",msg=0
  f  s id=$o(^INC("SB",0,"Desc",$$ALPHAUP^SSUTIL4(sbDesc),id)) q:(id="")||(msg'=0)  d
  .;----------add by myq 20141127-
  .;s msg=0
  .i id'="" d
  ..s tmpDesc=$P(^INC("SB",id),"^",2)
  ..q:tmpDesc'=sbDesc   //区分大小写 
  ..s incsbCodeLoc=""
  ..s incsbCode=$p(^INC("SB",id),"^",1)
  ..s:incsbCode["P" incsbCodeLoc=$p(incsbCode,"P",1)
  ..s:incsbCodeLoc=Loc msg=-4  
  q:msg'=0 -101  ;货位码重复
  ;------------add by myq 20141127
  ;q:(id'="")&(id'=sb) -101   ;货位码重复 modified by myq 20141127
  i ##class(web.DHCST.Common.AppCommon).Lock("User.INCStkBin")<0 s err=-99
  ts
  i sb="" d
  .s sbCode=..GetNextCode(Loc)  //自动生成代码(代码包含“科室”信息)
  .i sbCode="" tro  s err=-101  q
  .&sql(insert into inc_stkbin (incsb_code,incsb_desc) values (:sbCode,:sbDesc))
  .i SQLCODE'=0  tro  s err=-1  q
  .s sb=%ROWID
  e   d
  .&sql(update inc_stkbin set incsb_desc=:sbDesc where %ID=:sb  )
  .i SQLCODE'=0 tro  s err=-2  q
  .
  i err=0 tc
  d ##class(web.DHCST.Common.AppCommon).UnLock("User.INCStkBin") 
  q:err<0 err
  q sb
}

/// 取1条货位代码记录值
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
/// Return ：
/// 货位代码记录值串("^"分隔)
ClassMethod Select(sb As %String) As %String
{
}

/// 删除一条货位代码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
/// Return
///  0 - success
///  <0 - failure
ClassMethod Delete(sb As %String) As %String
{
    
   q:##class(web.DHCST.Common.AppCommon).Lock("User.INCStkBin"_sb)<0 -1
  
   i ..AllowDel(sb)<0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.INCStkBin"_sb) q -2
   ts
   &sql(delete from inc_stkbin where %ID=:sb)
   i SQLCODE'=0 tro  d ##class(web.DHCST.Common.AppCommon).UnLock("User.INCStkBin"_sb) q -3  
   tc
   d ##class(web.DHCST.Common.AppCommon).UnLock("User.INCStkBin"_sb) 
   q 0
}

/// Decription	: 删除多条货位明细
/// Debugger    : w ##class(web.DHCST.INCStkBin).DeleteItms("698,191")
ClassMethod DeleteItms(sbIdStr As %String)
{
   #dim result As %String = 0
   
   ts
   s len = $l(sbIdStr, ",")
   for i = 1:1:len {
	   s sbId = $p(sbIdStr, ",", i)
	   s isAllowDel = ..AllowDel(sbId)
	   s incilSbId = $o(^DHCINCILB(0, "Bin", sbId, ""))
	   s sbDesc = $p(^INC("SB", sbId), "^", 2)
	   if (incilSbId '= "") s result = "-1^货位码已维护药品"_sbDesc q
	   &SQL(DELETE FROM INC_StkBin  WHERE INCSB_RowId =:sbId )
	   if (SQLCODE '= 0) s result = "-1^货位码删除失败"_sbDesc_" "_SQLCODE q
   }
   if (result '= 0) tro  q result
   
   b ;tc
   tc
   
   q result
}

/// 检测是否允许删除
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
/// Return
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(sb As %String) As %String
{
    n (sb)
    q:sb="" -1
    s cnt=0
    &sql(select count(*) into :cnt from DHC_IncItmLocBin where INCILB_StkBin_Dr=:sb )
    q:cnt>0 -2
    q 0
}

/// 科室货位码列表数据(json)
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///  Loc - 科室rowid
///  sbDesc - 货位名称
/// Return:
///  货位码列表数据(json)
///  
ClassMethod jsLocINCStkBin(Start As %String, Limit As %String, Loc As %String, sbDesc As %String = "") As %String
{
 n (Start,Limit,Loc,sbDesc)
 q:Loc="" ""
 s result=##class(%Library.ResultSet).%New("web.DHCST.INCStkBin:LocINCStkBin")
 
 s sc=result.Execute(Loc,sbDesc)
 i $$$ISERR(sc) q ""

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
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 检索某科室的所有货位码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///  Loc - 科室rowid
///  sbDesc - 货位名称
///  
Query LocINCStkBin(Loc As %String, sbDesc As %String = "") As %Query(ROWSPEC = "sb:%String,code:%String,desc:%String")
{
}

ClassMethod LocINCStkBinExecute(ByRef qHandle As %Binary, Loc As %String, sbDesc As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 //
 q:Loc="" $$$OK
 s sbDesc =$g(sbDesc)
 //
 s xcode=Loc_"P"_"%"
 s sql="select %ID sb,incsb_code code,incsb_desc description from inc_stkbin where incsb_code like "_"'"_xcode_"'"
 i sbDesc'="" d
 .s sql=sql_" and incsb_desc like "_"'%"_sbDesc_"%"_"'"
 s sql=sql_" order by incsb_desc"
 //w sql,!
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
    s sb=xrs.Data("sb")
    s code=xrs.Data("code")
    s desc=xrs.Data("description")
    d OutPutRow
 }
 
 Quit $$$OK
OutPutRow
 s Data=$lb(sb,code,desc)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocINCStkBinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocINCStkBinExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocINCStkBinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocINCStkBinExecute ]
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

/// 自动生成某科室新的货位代码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Loc  - 科室rowid
/// Return:  
///   货位代码字符串 
ClassMethod GetNextCode(Loc As %String) As %String
{
 n (Loc)
 s ch=+Loc_"P"
 &sql(select  max(to_number($PIECE(incsb_code,:ch,2))) into :max from inc_stkbin  where incsb_code %STARTSWITH :ch)
 s max=$g(max)+1
 q ch_max
}

/// 批量保存货位码记录
/// Author:zhangdongmei
/// Date:2012-08-20
/// Argu:科室rowid,货位id^货位名称,货位id^货位名称
/// Return ：
///  0 - 成功
///  <0 - 插入或更新失败
///  
ClassMethod SaveLocItmBin(savestr) As %String
{
    n (savestr)
    s incil=$p(savestr,"^",1)
    s stkbindr=$p(savestr,"^",2)
    q:'$d(^INC("SB",stkbindr)) "-1"_":"_"该货位已不存在" 
    s exist=0
    s incilb=""
    f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
    .s stkbin=$p(^DHCINCILB(incilb),"^",2)
    .i stkbin=stkbindr d
    ..s exist=1
    q:exist=1 "-2"_":"_"已存在,不能重复操作"
  
    &sql(Insert into DHC_IncItmLocBin(INCILB_ItmLoc_Dr,INCILB_StkBin_Dr)
    values(:incil,:stkbindr))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_ItmLocBin",code,SQLCODE_":"_%msg)
    q:SQLCODE'=0 "-3"_":"_SQLCODE  ;保存失败的明细
    q 0
}

/// Descript:取科室库存项集合
/// Creater:	LiangQaing
/// CreateDate:	2013-11-13
/// Table:
/// Input:开始行,限制数,入参串
/// Output:		
/// Return：
ClassMethod jsLocIncStkBinDs(Start, Limit, StrPar)
{
	n (Start, Limit, StrPar)
	
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
    s incil=$p(StrPar,"^",1)

    s h=0
	s pid=..NewPid()

	Set $ZT="ERRORjsLocIncStkBinDs"
	s incilb=""
	f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
	.s stkbindr=$p(^DHCINCILB(incilb),"^",2)
	.s code=$p(^INC("SB",stkbindr),"^",1)
	.s desc=$p(^INC("SB",stkbindr),"^",2)
	.s rowid=incilb
    .s data=rowid_"^"_code_"^"_desc
    .s h=h+1
    .s index="Sort^"_code_"^"_h  //排序
    .s ^TMP("DHCST","INCStkBin","jsLocIncStkBinDs",pid,"index",index)=data
    .

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INCStkBin","jsLocIncStkBinDs",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INCStkBin","jsLocIncStkBinDs",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s rowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowid",rowid)
	.s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("desc",desc)
    .s tmpstr=rowid_code_desc
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","INCStkBin","jsLocIncStkBinDs",pid)

    q ""
    
ERRORjsLocIncStkBinDs
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.INCStkBin).jsLocIncStkBinDs"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INCStkBin","jsLocIncStkBinDs",pid)    
    q ErrorMsg
}

ClassMethod NewPid() As %String
{
  	q $I(^DHCSTPID("INCStkBin"))
}

/// Descript:取科室库存项集合
/// Creater:	LiangQaing
/// CreateDate:	2013-11-13
/// Table:
/// Input:开始行,限制数,入参串
/// Output:		
/// Return：
/// w ##class(web.DHCST.INCStkBin).jsLocLocBinIncDs("0","9999","194")
ClassMethod jsLocLocBinIncDs(Start, Limit, StrPar)
{
	n (Start, Limit, StrPar)
	//s ^PHATMP("MYQ",$this,"jsLocLocBinIncDs")=$lb(Start, Limit, StrPar)
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
    s stkbindr=$p(StrPar,"^",1)
    
    s h=0
	s pid=..NewPid()

	Set $ZT="ERRORjsLocLocBinIncDs"
	s incilb=""
	f  s incilb=$o(^DHCINCILB(0,"Bin",stkbindr,incilb)) q:incilb=""  d
	.s incil=$p(^DHCINCILB(incilb),"^",1)
	.s inci = +incil
	.s il = +$p(incil, "||", 2)
	.q:'$d(^INCI(inci, "IL", il))
	.s code=$p(^INCI(inci,1),"^",1)
	.s desc=$p(^INCI(inci,1),"^",2)
	.s rowid=incilb
    .s data=rowid_"^"_code_"^"_desc
    .s h=h+1
    .s index="Sort^"_code_"^"_h  //排序
    .s ^TMP("DHCST","INCStkBin","jsLocLocBinIncDs",pid,"index",index)=data
    .

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INCStkBin","jsLocLocBinIncDs",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INCStkBin","jsLocLocBinIncDs",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s rowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowid",rowid)
	.s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
	.s desc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("desc",desc)
    .s tmpstr=rowid_code_desc
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","INCStkBin","jsLocLocBinIncDs",pid)

    q ""
    
ERRORjsLocLocBinIncDs
    //遇报错,则先kill TMP
    Set Method=	"##class(web.DHCST.INCStkBin)jsLocLocBinIncDs"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrPar_")"_","_$ZE
	k ^TMP("DHCST","INCStkBin","jsLocLocBinIncDs",pid)    
    q ErrorMsg
}

/// Descript:删除科室库存项货位
/// Creater:	LiangQaing
/// CreateDate:	2013-11-13
/// Table:
/// Input:科室库存项ID
/// Output:		
/// Return
ClassMethod DelBinInci(ParStr)
{
	n (ParStr)
	s incilb=$p(ParStr,"^",1)
	&sql(delete from DHC_IncItmLocBin where INCILB_ROWID=:incilb )
	q:SQLCODE'=0 "-1"_":"_SQLCODE  ;删除失败
	q 0
}

/// Descript:取科室药品所维护的货位
/// Creater:	LiangQaing
/// CreateDate:	2013-11-19
/// Table:
/// Input:科室库存项ID
/// Output:		
/// Return:货位串
ClassMethod GetInciBinStr(incil, sbrowid = "", desc = "")
{
	n (incil,sbrowid,desc)
	q ##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",",sbrowid,desc)
}

}
