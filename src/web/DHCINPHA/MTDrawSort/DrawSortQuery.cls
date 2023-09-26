/// Description:备药规则查询相关
/// Creator:    hulihua
/// CreateDate: 2016-10-07
/// Table:      DHC_PHDrawSort、DHC_PHDrawSortItm
Class web.DHCINPHA.MTDrawSort.DrawSortQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:保存或者更新备药规则信息
/// Creator:	hulihua
/// CreateDate:	2016-10-07
/// Table:      DHC_PHDrawSort
/// Input:		备药规则主表ID^药房科室ID^规则代码^规则描述
/// Output:
/// Return：    0,成功
/// 			-1,	药房科室、规则代码或者规则描述为空
/// 			-2,	操作表失败
/// w ##class(web.DHCINPHA.MTDrawSort.DrawSortQuery).Save("0^94^01^备药路线一")
ClassMethod Save(params As %String) As %Library.String
{
	n (params)
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.s str=$p(params,"$$",i)
  	.s ret=##class(web.DHCINPHA.MTDrawSort.SqlDbDrawSort).SaveOrUpdate(str)
	q ret
}

/// Description:保存或者更新备药规则明细信息
/// Creator:	hulihua
/// CreateDate:	2016-10-14
/// Table:      DHC_PHDrawSort、DHC_PHDrawSortItm、INC_StkBin
/// Input:		备药规则主表ID^备药规则明细ID^SN^货位码ID
/// Output:
/// Return：    0,成功
/// 			空,	SN为空
/// 			-1,	主表ID或者货位码ID为空
/// 			-2,	操作表失败
/// 			-3,	SN重复
/// w ##class(web.DHCINPHA.MTDrawSort.DrawSortQuery).SaveDeatil("2^^1^262")
ClassMethod SaveDeatil(detaildata As %String) As %Library.String
{
	n (detaildata)
	//s ^hlh($h)=$lb(detaildata)
	s ID=$p(detaildata,"^",1)
	s DSiId=$p(detaildata,"^",2)
	s DSiSN=$p(detaildata,"^",3)
	s DSiSBId=$p(detaildata,"^",4)
	q:DSiSN="" ""
	q:(ID=0)||(DSiSBId="") -1
	s ret=0
	s DSiCh="0"
	f  s DSiCh=$o(^DHCPHDWSORT(ID,"I",DSiCh)) q:(DSiCh="")||(ret'=0)  d
	.s phdsSN=$p(^DHCPHDWSORT(ID,"I",DSiCh),"^",1)
	.s:phdsSN=DSiSN ret=-3
	q:ret'=0 ret
 	s ret=##class(web.DHCINPHA.MTDrawSort.SqlDbDrawSort).SaveOrUpdateDeatil(detaildata)
	q ret
}

/// Description:查询某药房科室备药规则信息
/// Creator:	hulihua
/// CreateDate:	2016-10-08
/// Table:      DHC_PHDrawSort
/// Input:		每页行数、页数、药房科室ID
/// Output:		备药规则ID、备药规则代码、备药规则描述、药房科室ID
/// Return：    
/// w ##class(web.DHCINPHA.MTDrawSort.DrawSortQuery).GetDrawSortList("10","1","94")
ClassMethod GetDrawSortList(rows, page, PhLoc) As %Integer
{
	 n (rows, page, PhLoc)
	 //s ^hlh($h)=$lb(rows, page, PhLoc)
     i $g(page)="" s page=1
     i $g(rows)="" s rows=50
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTDrawSort.DrawSortQuery")
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortList",pid)
	 s n=0
	 s phdwsid="" 
	 f  s phdwsid=$o(^DHCPHDWSORTi("PHLoc",PhLoc,phdwsid)) q:phdwsid=""  d
	 .s DSDesc=$p(^DHCPHDWSORT(phdwsid),"^",1)
	 .s DSCode=$p(^DHCPHDWSORT(phdwsid),"^",2) 
	 .s n=n+1
	 .s data=$g(phdwsid)_"^"_$g(DSCode)_"^"_$g(DSDesc)_"^"_$g(PhLoc)
	 .s ^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortList",pid,n)=data
     q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortList",pid,h)
     .s count = count+1
	 .s Title="ID^DSCode^DSDesc^PhLocId"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	
	 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortList",pid)
     q ""
}

/// Description:查询某备药规则对应的明细信息
/// Creator:	hulihua
/// CreateDate:	2016-10-14
/// Table:      DHC_PHDrawSort、DHC_PHDrawSortItm、INC_StkBin
/// Input:		每页行数、页数、药房科室ID^备药规则ID^检索货位描述
/// Output:		货位码ID、货位代码、货位描述、备药子表ID、SN、备药表ID
/// Return：    
/// w ##class(web.DHCINPHA.MTDrawSort.DrawSortQuery).GetDrawSortDetailList("50","1","94^1^")
ClassMethod GetDrawSortDetailList(rows, page, params) As %Integer
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTDrawSort.DrawSortQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN")
	 
	s result=##class(%Library.ResultSet).%New("web.DHCINPHA.MTDrawSort.DrawSortQuery:LocINCStkBin")
	s sc=result.Execute(params)
	i $$$ISERR(sc) q ""
	s colNum=result.GetColumnCount()
	s n=0
	While(result.Next())
	{ 
		s data=""
		f i=1:1:colNum d
		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
		s index=$p(data,"^",5)
		s:index="" index="9999999"
	 	s n=n+1
	 	s ^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN",index,n)=data
	}
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串

	s maxrow=n
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN",index))  q:index=""  d
	.s h=""
	.f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN",index,h)) q:h=""  d
	..s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN",index,h)
	..s count = count+1
	..s Title="TSBID^TSBCode^TSBDesc^TDSiId^TDSiSN^TDSId"
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..e  d
	...w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTDrawSort.DrawSortQuery","GetDrawSortDetailList",pid,"SN")
	q ""
}

/// Description:查询某科室对应的所有货位码
/// Creator:	hulihua
/// CreateDate:	2016-10-15
/// Table:      DHC_PHDrawSort、DHC_PHDrawSortItm、INC_StkBin
/// Input:		药房科室ID^备药规则ID^检索货位描述
/// Output:		货位码ID、货位代码、货位描述、备药子表ID、SN、备药表ID
/// Return：    
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.MTDrawSort.DrawSortQuery","LocINCStkBin","98^12^") 
Query LocINCStkBin(params As %String) As websys.Query(ROWSPEC = "sb:%String,code:%String,desc:%String,phdsid:%String,phdsSN:%Numeric,phds:%String")
{
}

ClassMethod LocINCStkBinExecute(ByRef qHandle As %Binary, params As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s Loc=$p(params,"^",1)
 s phds=$p(params,"^",2)
 s sbDesc=$p(params,"^",3)
 q:Loc="" $$$OK
 s xcode=Loc_"P"_"%"
 s sql="select %ID sb,incsb_code code,incsb_desc description from inc_stkbin where incsb_code like "_"'"_xcode_"'"
 i sbDesc'="" d
 .s sql=sql_" and incsb_desc like "_"'"_sbDesc_"%"_"'"
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
    s sb=xrs.Data("sb")
    s code=xrs.Data("code")
    s desc=xrs.Data("description")
    s phdsid="",phdsSN=""
    i $D(^DHCPHDWSORT(0,"PHDINCSB",sb,phds)) d
    .s phdsch=$o(^DHCPHDWSORT(0,"PHDINCSB",sb,phds,""),-1)
    .s phdsid=phds_"||"_phdsch
    .s phdsSN=$p(^DHCPHDWSORT(phds,"I",phdsch),"^",1)
    d OutPutRow
 }
 Quit $$$OK
OutPutRow
 s Data=$lb(sb,code,desc,phdsid,phdsSN,phds)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
