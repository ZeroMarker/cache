Class web.DHCDISLocItemLinkRec Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      yuliping
/// CreatDate：    2017-05-02
/// Description:   分页显示 配送项目关联接收科室
/// Table：        DHC_DisLocItemLinkRec
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISLocItemLinkRec).ListLocItemLinkRec("1","10","","")
ClassMethod ListLocItemLinkRec(page = 1, rows = 10, LICode, LIDesc, Item = "")
{
	
	 n (page,rows,LICode,LIDesc,Item)
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s liid=""
	 f  s liid=$o(^DHCDISLRE(0,"Item",Item,liid))  q:liid=""  d
	 .q:liid=0
	 .s msg=$g(^DHCDISLRE(liid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s code=$p($g(^DHCDISLI(code)),"^",1)
	 .s locdr=$p(msg,"^",2)
	 .i ((locdr="")||(locdr=0)) s locdesc=""
	 .i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",2)
	 .s tmp=liid_"^"_code_"^"_locdr_"^"_locdesc
	 .q:(LICode'="")&(code'[$$ALPHAUP^SSUTIL4(LICode))
	 .q:(LIDesc'="")&(locdesc'[$$ALPHAUP^SSUTIL4(LIDesc))
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LREItemDr^LILoc^LRELocDr",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

ClassMethod SaveUpdLevReson(params)
{
    n (params)
    k ^yyy
    s ^yyy=params
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      yuliping
/// CreatDate：    2017-05-02
/// Description:   更新或保存 配送项目关联接收科室
/// Table：        DHC_DisLocItemLinkRec
/// Input：	       LREItemDr：项目
///                LRELocDr：科室
///                
/// Return：       保存成功 0，其他 失败 
/// d ##class(web.DHCDISLocItemLinkRec).SaveOrUpdate("31^1^0")
ClassMethod SaveOrUpdate(str)
{
		 n (str)
		 s ValueFlag=0,isIN=0
  		 s LREItemDr=$p(str,"^",1)
		 s LRELocDr=$p(str,"^",2)
		 s ID=$p(str,"^",3)
		 
		 i +ID=0  d
		 .s obj=##class(User.DHCDisLocItemLinkRec).%New()
		 .s obj.LREItemDr=##class(User.DHCDisLocItem).%OpenId(LREItemDr)
		 .s obj.LRELocDr=##class(User.CTLoc).%OpenId(LRELocDr)
		 .s ValueFlag=..isAleradyIn(LREItemDr,LRELocDr)
		 ;i $d(^DHCDISLI(0,"Code",LICode)) s ValueFlag=1
		 q:(ValueFlag=1) 1
		 e  d
		 .s obj=##class(User.DHCDisLocItem).%OpenId(ID)
		 .s obj.LREItemDr=##class(User.DHCDisLocItem).%OpenId(LREItemDr)
		 .s obj.LRELocDr=##class(User.CTLoc).%OpenId(LRELocDr)
		 
		 .i $d(^DHCDISLRE(ID)) d
		 ..s item=$p(^DHCDISLRE(ID),"^",1)
		 ..s locid=$p(^DHCDISLRE(ID),"^",2)
		 ..i ((item=LREItemDr)&(locid=LRELocDr)) s isIN=1
		 
		 q:(isIN=1) 1
		 
	     s sc=obj.%Save()  
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-12
/// Description:： 配送项目关联接收科室字典
/// Table：       DHC_DisLocItemLinkRec
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  	  n (Id)
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisLocItemLinkRec).%DeleteId(Id)
	  q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-05-02
/// Description:   判断配送项目关联接收科室是否已存在
/// Table：        DHC_DisLocItemLinkRec
/// Input：	       LREItemDr：项目
///                LRELocDr：科室
///                
/// Return：       保存成功 0，其他 失败 
/// w ##class(web.DHCDISLocItemLinkRec).isAleradyIn("30","1")
ClassMethod isAleradyIn(LREItemDr As %String, LRELocDr As %String)
{
	n (LREItemDr,LRELocDr)
	s liid="",flag=0
	f  s liid=$o(^DHCDISLRE(liid))  q:liid=""  d
	.q:liid=0
	.s msg=$g(^DHCDISLRE(liid))
	.s code=$p(msg,"^",1)
	.s locdr=$p(msg,"^",2)
	.i ((code=LREItemDr)&(locdr=LRELocDr)) s flag=1

	q flag
}

/// Creator：      yuliping
/// CreatDate：    2017-05-02
/// Description:   获取配送项目
/// Table：        DHC_DisLocItem
/// Input：	       
///                
/// Return：       json
/// d ##class(web.DHCDISLocItemLinkRec).getDisLocItem()
ClassMethod getDisLocItem()
{
	s Count=0
	s liid=""
	f  s liid=$o(^DHCDISLI(liid))  q:liid=""  d
	.q:liid=0
	.s msg=$g(^DHCDISLI(liid))
	.q:msg=""
	.s code=$p(msg,"^",1)

	.s Count=Count+1
	.s tmp = liid_"^"_code
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description:获得科室列表
/// Creator:     yuliping
/// CreateDate:  2017-01-12
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocItemLinkRec).GetLoc("2","")   
ClassMethod GetLoc(HospID As %String, search As %String)
{
	n (HospID,search)
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.q:(search'="")&(LocDesc'[$$ALPHAUP^SSUTIL4(search))
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

}
