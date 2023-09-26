/// Description:配液类别维护查询相关
/// Creator:    hulihua
/// CreateDate: 2016-12-16
/// Table:      PIVA_OrderLink、PIVA_OrderLinkInstruc、PIVA_OrderLinkItm、PIVA_OrderLinkOrder
Class web.DHCSTPIVASETPIVACAT Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询所有药品药品的收费项医嘱列表
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      ARC_Alias 
/// Input:		
/// Output:		
/// Return：	所有药品的收费项医嘱列表   
/// w ##class(web.DHCSTPIVASETPIVACAT).GetAllDrugOrderList()
ClassMethod GetAllDrugOrderList(params = "")
{
	s inputalias=$p(params,"^",1)
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s n=0
	s aliasid=0 
	f  s aliasid=$o(^ARC("ALIAS",aliasid)) q:(aliasid="")||(n>100)  d
	.s arcimdr=$p(^ARC("ALIAS",aliasid),"^",1)
	.q:+arcimdr=0
	.s arcdesc=$p(^ARC("ALIAS",aliasid),"^",3)
	.s arcalias=$p(^ARC("ALIAS",aliasid),"^",6)
	.q:(inputalias'="")&&($zcvt(arcalias,"U")'[$zcvt(inputalias,"U"))
	.//q:(arcdesc'["抗肿瘤化学药物")&&(arcdesc'["静脉高营养")
	.q:$d(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllDrugOrderList",pid,arcimdr))
	.s n=n+1
	.s data=$g(arcimdr)_"^"_$g(arcdesc)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllDrugOrderList",pid,arcimdr)=data
	q:n=0 "[]" //输出空的json串
	w "["
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllDrugOrderList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllDrugOrderList",pid,h)
	.s count = count+1
	.s Title="value^text"
	.I count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	w "]"
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:查询所有用法列表
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PHC_Instruc 
/// Input:		
/// Output:		
/// Return：	所有用法列表    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetAllInstrucList()
ClassMethod GetAllInstrucList() As %Integer
{
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s n=0
	s phcinid="" 
	f  s phcinid=$o(^PHCIN(phcinid)) q:phcinid=""  d
	.s Instruc=$p(^PHCIN(phcinid),"^",2) 
	.s n=n+1
	.s data=$g(phcinid)_"^"_$g(Instruc)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllInstrucList",pid,n)=data
	q:n=0 "[]" //输出空的json串
	w "["
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllInstrucList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllInstrucList",pid,h)
	.s count = count+1
	.s Title="value^text"
	.I count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	w "]"
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:查询所有药品配液分类列表
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      DHC_PHCPivaCat 
/// Input:		
/// Output:		
/// Return：	所有药品配液分类列表    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetAllPHCPivaCatList()
ClassMethod GetAllPHCPivaCatList() As %Integer
{
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s n=0
	s pivacatid=0 
	f  s pivacatid=$o(^PHCPIVACAT(pivacatid)) q:pivacatid=""  d
	.s PivaCat=$p(^PHCPIVACAT(pivacatid),"^",2) 
	.s n=n+1
	.s data=$g(pivacatid)_"^"_$g(PivaCat)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllPHCPivaCatList",pid,n)=data
	q:n=0 "[]" //输出空的json串
	w "["
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllPHCPivaCatList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetAllPHCPivaCatList",pid,h)
	.s count = count+1
	.s Title="value^text"
	.I count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	w "]"
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:查询所有配液类别列表信息
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLink 
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPHCPivaCatList("10","1")
ClassMethod GetPHCPivaCatList(rows, page) As %Integer
{
	 n (rows, page)
     i $g(page)="" s page=1
     i $g(rows)="" s rows=10
     
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 S pid=..NewPid()
	 d ..ClearAllTmp(pid)
	 s n=0
	 s polid=0 
	 f  s polid=$o(^POLI(polid)) q:polid=""  d
	 .s poldesc=$p(^POLI(polid),"^",1)
	 .s polminvolume=$p(^POLI(polid),"^",2)
	 .s polmaxvolume=$p(^POLI(polid),"^",3) 
	 .s n=n+1
	 .s data=$g(polid)_"^"_$g(poldesc)_"^"_$g(polminvolume)_"^"_$g(polmaxvolume)
	 .s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaCatList",pid,n)=data
     q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaCatList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaCatList",pid,h)
     .s count = count+1
	 .s Title="PolId^PolDesc^POLMinVolume^POLMaxVolume"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	 d ..ClearAllTmp(pid)
     q ""
}

/// Description:查询配液类别所对应的容量信息
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLink 
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPHCPivaCatList("10","1")
ClassMethod GetPHCPivaCatLiquid(rows, page, params) As %Integer
{
	 n (rows, page, params)
     i $g(page)="" s page=1
     i $g(rows)="" s rows=10
     
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 S pid=..NewPid()
	 d ..ClearAllTmp(pid)
	 s n=0
	 s polid=params
	 s polminvolume=$p(^POLI(polid),"^",2)
	 s polmaxvolume=$p(^POLI(polid),"^",3) 
	 s n=n+1
	 s data=$g(polid)_"^"_$g(poldesc)_"^"_$g(polminvolume)_"^"_$g(polmaxvolume)
	 s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaCatLiquid",pid,n)=data
     q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s h=1
     s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaCatLiquid",pid,h)
     s count = count+1
	 s Title="POLID^PolDesc^POLMinVolume^POLMaxVolume"
	 q:(count<Start)||(count>End)
	 I count=Start d
	 .w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	 e  d
	 .w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	 d ..ClearAllTmp(pid)
     q ""
}

/// Description:根据配液类别的ID查询液体最大和最小量
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLink 
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPivaCatLiquid("10","1")
ClassMethod GetPivaCatLiquid(polid) As %Integer
{
	n (polid)
	q:polid="" ""
	s polminvolume=$p(^POLI(polid),"^",2)
	s polmaxvolume=$p(^POLI(polid),"^",3) 
	q:(polminvolume="")&&(polmaxvolume="") ""
	s data=$g(polminvolume)_"^"_$g(polmaxvolume)
	q data
}

/// Description:查询配液分类关联用法信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkInstruc
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPHCPivaCatList("10","1")
ClassMethod GetPHCPivaLinkInstruc(rows, page, params) As %Integer
{
	n (rows, page, params)
	//s ^hlh($h)=$lb(rows, page, params)
	i $g(page)="" s page=1
	i $g(rows)="" s rows=10

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s pols=params
	s n=0
	s polsch=""
	f  s polsch=$o(^POLI(pols,"S",polsch)) q:polsch=""  d
	.s polsid=pols_"||"_polsch
	.s InstrucDr=$p(^POLI(pols,"S",polsch),"^",3)
	.s Instruc=$p(^PHCIN(InstrucDr),"^",2)
	.s n=n+1
	.s data=$g(polsid)_"^"_$g(InstrucDr)_"^"_$g(Instruc)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkInstruc",pid,n)=data
	q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkInstruc",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkInstruc",pid,h)
	.s count = count+1
	.s Title="ID^InstrucDr^Instruc"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:查询配液分类关联药品配液类别信息
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkItm
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPHCPivaLinkItm("10","1")
ClassMethod GetPHCPivaLinkItm(rows, page, params = "") As %String
{
	n (rows, page, params)
	//s ^hlh($h)=$lb(rows, page, params)
	i $g(page)="" s page=1
	i $g(rows)="" s rows=10

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s poli=params
	s n=0
	s polich=""
	f  s polich=$o(^POLI(poli,"G",polich)) q:polich=""  d
	.s poliid=poli_"||"_polich
	.s PivaCatDr=$p(^POLI(poli,"G",polich),"^",4)
	.s PivaCat=$p(^PHCPIVACAT(PivaCatDr),"^",2)
	.s RelationDr=$p(^POLI(poli,"G",polich),"^",5)
	.s RelationFlag=$s(RelationDr=1:"并且",RelationDr=2:"或者",1:"")
	.s n=n+1
	.s data=$g(poliid)_"^"_$g(PivaCatDr)_"^"_$g(PivaCat)_"^"_$g(RelationFlag)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkItm",pid,n)=data
	q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkItm",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkItm",pid,h)
	.s count = count+1
	.s Title="ID^PivaCatDr^PivaCat^RelationFlag"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:查询配液分类关联收费项医嘱信息
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLinkOrder
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCSTPIVASETPIVACAT).GetPHCPivaLinkOrder("10","1","34")
ClassMethod GetPHCPivaLinkOrder(rows, page, params) As %Integer
{
	n (rows, page, params)
	//s ^hlh($h)=$lb(rows, page, params)
	i $g(page)="" s page=1
	i $g(rows)="" s rows=10

	s End = page*rows
	s Start=(page-1)*rows+1
	S pid=..NewPid()
	d ..ClearAllTmp(pid)
	s polo=params
	s n=0
	s poloch=""
	f  s poloch=$o(^POLI(polo,"M",poloch)) q:poloch=""  d
	.s poloid=polo_"||"_poloch
	.s ArcimDr=$p(^POLI(polo,"M",poloch),"^",1)
	.s ArcimDesc=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	.s AddQty=$p(^POLI(polo,"M",poloch),"^",4)
	.s n=n+1
	.s data=$g(poloid)_"^"_$g(ArcimDr)_"^"_$g(ArcimDesc)_"^"_$g(AddQty)
	.s ^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkOrder",pid,n)=data
	q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkOrder",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCST","web.DHCSTPIVASETPIVACAT","GetPHCPivaLinkOrder",pid,h)
	.s count = count+1
	.s Title="ID^OrderDescDr^OrderDesc^OrderQty"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	.
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	d ..ClearAllTmp(pid)
	q ""
}

/// Description:保存/更新配液类别主表
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLink
/// Input:		配液类别主表ID^配液类别描述
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVAOrderLink("0","85","")
ClassMethod SavePIVAOrderLink(params As %String, savetype As %String) As %String
{
	n (params,savetype)
  	TStart
  	s $ZT="Error^DHCSTERROR" 
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdate(str,savetype)
	i ret<0 TRollback
	TCOMMIT
	q ret
}

/// Description:删除配液类别主表
/// Creator:	yunhaibao
/// CreateDate:	2017-02-08
/// Table:      PIVA_OrderLink
/// Input:		配液类别主表ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).DeletePIVAOrderLink()
ClassMethod DeletePIVAOrderLink(params As %String) As %String
{
	n (params)
	q:params="" -1
  	s $ZT="Error^DHCSTERROR" 
  	s ret=##class(web.DHCSTPIVASETPIVACATSQL).DeletePIVAOrderLink(params)
	q ret
}

/// Description:保存/更新配液类别关联用法子表
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLinkInstruc
/// Input:		配液类别主表ID^关联用法子表ID^需关联用法ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkInstruc("0","85","")
ClassMethod SavePIVALinkInstruc(params As %String) As %String
{
	n (params)
  	TStart
  	s $ZT="Error^DHCSTERROR" 
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkIns(str)
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
}

/// Description:删除配液类别关联用法子表
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLinkInstruc
/// Input:		配液类别关联用法子表ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkInstruc("0","85","")
ClassMethod DeletePIVALinkInstruc(params As %String) As %String
{
	n (params)
	q:params="" -1
  	s $ZT="Error^DHCSTERROR" 
  	s ret=##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkIns(params)
	q ret
}

/// Description:保存/更新配液类别关联药品配液类别子表
/// Creator:	hulihua
/// CreateDate:	2016-12-19
/// Table:      PIVA_OrderLinkItm
/// Input:		配液类别主表ID^关联药品配液类别子表ID^需关联药品配液分类ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkItm("33^^1")
ClassMethod SavePIVALinkItm(params As %String) As %String
{
	n (params)
  	TStart
  	s $ZT="Error^DHCSTERROR" 
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkItm(str)
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
}

/// Description:删除配液类别关联药品配液分类子表
/// Creator:	hulihua
/// CreateDate:	2016-12-16
/// Table:      PIVA_OrderLinkItm
/// Input:		配液类别关联药品配液分类子表ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkInstruc("0","85","")
ClassMethod DeletePIVALinkItm(params As %String) As %String
{
	n (params)
	q:params="" -1
  	s $ZT="Error^DHCSTERROR" 
  	s ret=##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkItm(params)
	q ret
}

/// Description:保存/更新配液类别关联收费项医嘱子表
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLinkOrder
/// Input:		配液类别主表ID^关联收费项医嘱子表ID^需关联收费项医嘱ID^需关联收费项医嘱数量
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkItm("33^^1")
ClassMethod SavePIVALinkOrder(params As %String) As %String
{
	n (params)
  	TStart
  	s $ZT="Error^DHCSTERROR" 
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=##class(web.DHCSTPIVASETPIVACATSQL).SaveOrUpdateLinkOrder(str)
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
}

/// Description:删除配液类别关联关联收费项医嘱子表
/// Creator:	hulihua
/// CreateDate:	2016-12-20
/// Table:      PIVA_OrderLinkOrder
/// Input:		配液类别关联关联收费项医嘱子表ID
/// Output:	
/// Return：	0-成功    
/// Others:
/// w ##class(web.DHCSTPIVASETPIVACAT).SavePIVALinkOrder("34||1")
ClassMethod DeletePIVALinkOrder(params As %String) As %String
{
	n (params)
	q:params="" -1
  	s $ZT="Error^DHCSTERROR" 
  	s ret=##class(web.DHCSTPIVASETPIVACATSQL).DeleteLinkOrder(params)
	q ret
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
ClassMethod NewPid() As %String
{
  q $I(^DHCSTPIVA("DHCST","web.DHCSTPIVASETPIVACAT"))
}

/// Description:Kill临时global
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：	
ClassMethod ClearAllTmp(pid As %String) As %String
{
	N (pid)
	D ..CLEARTMP("GetPHCPivaCatList",pid,"")
	D ..CLEARTMP("GetPHCPivaCatLiquid",pid,"")
	D ..CLEARTMP("GetAllInstrucList",pid,"")
	D ..CLEARTMP("GetPHCPivaLinkInstruc",pid,"")
	D ..CLEARTMP("GetAllPHCPivaCatList",pid,"")
	D ..CLEARTMP("GetPHCPivaLinkItm",pid,"")
	D ..CLEARTMP("GetAllDrugOrderList",pid,"")
	D ..CLEARTMP("GetPHCPivaLinkOrder",pid,"")
	Q ""
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
ClassMethod CLEARTMP(MethodName As %String, pid As %String, PAR As %String) As %String
{
	N (MethodName,pid,PAR)
	K ^TMP("DHCST","web.DHCSTPIVASETPIVACAT",MethodName,pid)
}

Storage Default
{
<Data name="DHCSTPIVASETPIVACATDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPIVASETPIVACATD</DataLocation>
<DefaultData>DHCSTPIVASETPIVACATDefaultData</DefaultData>
<IdLocation>^web.DHCSTPIVASETPIVACATD</IdLocation>
<IndexLocation>^web.DHCSTPIVASETPIVACATI</IndexLocation>
<StreamLocation>^web.DHCSTPIVASETPIVACATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
