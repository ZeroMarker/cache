Class web.DHCDISLocItemEs Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      yuliping
/// CreatDate：    2017-01-12
/// Description:   分页显示 陪送其它项目字典维护
/// Table：        DHC_DisLocItem
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISLocItemEs).ListLocItem("1","10","","")
ClassMethod ListLocItem(page = 1, rows = 10, LICode, LIDesc)
{
	
	 n (page,rows,LICode,LIDesc)
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s liid=""
	 f  s liid=$o(^DHCDISLI(liid))  q:liid=""  d
	 .q:liid=0
	 .s msg=$g(^DHCDISLI(liid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .s locdr=$p(msg,"^",3)
	 .i ((locdr="")||(locdr=0)) s locdesc=""
	 .i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",1)
	 .s type=$p(msg,"^",4)
	 .q:type=0
	 .s avtiveflag=$p(msg,"^",5)
	 .s HosptId=$p(msg,"^",6)
	 .S LITypeAddDr=+$p(msg,"^",7)
	 .s LITypeAddDesc=""
	 .i ($d(^DHCDISTA(LITypeAddDr))&(LITypeAddDr>0)) s LITypeAddDesc=$p(^DHCDISTA(LITypeAddDr),"^",2)
	 .s HosptDesc=""
	 .i HosptId '="" s HosptDesc=$P(^CT("HOSP",HosptId),"^",2)
	 .s tmp=liid_"^"_code_"^"_desc_"^"_locdr_"^"_type_"^"_avtiveflag_"^"_HosptId_"^"_HosptDesc_"^"_locdesc_"^"_LITypeAddDr_"^"_LITypeAddDesc
	 .q:(LICode'="")&(code'[$$ALPHAUP^SSUTIL4(LICode))
	 .q:(LIDesc'="")&(desc'[$$ALPHAUP^SSUTIL4(LIDesc))
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LICode^LIDesc^LIlorDr^LIType^LIActiveFlag^LIHospDrID^LIHospDr^LIRecLocDr^LITypeAddDr^LITypeAddDesc",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

ClassMethod SaveUpdLevReson(params)
{
    n (params)
    s ^tempsufan(1)=params
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
/// CreatDate：    2017-01-09
/// Description:   保存或者新增 陪送其它项目字典
/// Table：        DHC_DisLocItem
/// Input：	       AICode：代码
///                AIDesc：描述
///                AIActiveFlag：是否可用             
///                AIHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败 
/// d ##class(web.DHCDISLocItemEs).SaveOrUpdate("测试2^测试222^0^Y^北京地坛医院^1^2^^10")
ClassMethod SaveOrUpdate(str)
{
		 n (str)
		 s ValueFlag=0,isIN=0
  		 s LICode=$p(str,"^",1)		
		 s LIDesc=$p(str,"^",2)
		 s LIRecLocDr=$p(str,"^",3)
		 s LIType=$p(str,"^",3)
		 s LIActiveFlag=$p(str,"^",4)
		 s LIHospDr=$p(str,"^",5)
		 s LITypeAddDr=$p(str,"^",8)
		 s LIHospDrID=$p(str,"^",7)
		 s LIlorDr=$p(str,"^",8)
		 s ID=$p(str,"^",10)
		 
		 i ((+LIRecLocDr=0)&&(LIRecLocDr'[0)) s LIRecLocDr=LIlorDr
		 i LIRecLocDr=0 s LIRecLocDr=""
		 i +ID=0  d
		 .s obj=##class(User.DHCDisLocItem).%New()
		 .s obj.LIHospDr=##class(User.CTHospital).%OpenId(LIHospDr)
		 .i $d(^DHCDISLI(0,"Code",LICode)) s ValueFlag=1
		 q:(ValueFlag=1) 1
		 e  d
		 .s obj=##class(User.DHCDisLocItem).%OpenId(ID)
		 .i +LIHospDr=0 d
		 ..s obj.LIHospDr=##class(User.CTHospital).%OpenId(LIHospDrID)
		 .e  d
		 ..s obj.LIHospDr=##class(User.CTHospital).%OpenId(LIHospDr)
		 .s isIN=0
		 .i $d(^DHCDISLI(0,"Code",LICode)) d
		 ..s newid=$o(^DHCDISLI(0,"Code",LICode,""))
		 ..q:newid=ID
		 ..s isIN=1
		 
		 q:(isIN=1) 1
		 
		
		 s obj.LICode=LICode
		 
		 s obj.LIDesc=LIDesc
		 s obj.LIRecLocDr=""
		
	 	 s obj.LIType=LIType
	 	 s obj.LIActiveFlag=LIActiveFlag
	 	 s obj.LITypeAddDr=##class(User.DHCDisTypeAdd).%OpenId(LITypeAddDr)
	     s sc=obj.%Save()  
	     b 
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-12
/// Description:： 下拉列表显示 陪送/配送
/// Return
/// d ##class(web.DHCDISLocItemEs).ListStatActive()
ClassMethod ListStatActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","1").Put("text","配送"))
	  
	  w jsonObj.ListToJson(listObj)	
	  ;s mystr="{'value':'0','text':陪送'}"
	 
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-12
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISLocItemEs).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Description:获得科室列表
/// Creator:     yuliping
/// CreateDate:  2017-01-12
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocItemEs).GetLoc("2","")   
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
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-12
/// Description:： 配送人员关联科室字典
/// Table：       DHC_DisLocItem
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  	  n (Id)
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisLocItem).%DeleteId(Id)
	  q 0
}

/// d ##class(web.DHCDISLocItemEs).ListItem()
ClassMethod ListItem()
{
	
	 s liid="",Count=0
	 f  s liid=$o(^DHCDISLI(liid))  q:liid=""  d
	 .q:liid=0
	 .s msg=$g(^DHCDISLI(liid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s type=$p(msg,"^",4)
	 .q:type=1
	 .s Count=Count+1
	.s tmp = liid_"^"_code
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Description:点击陪送人员，查找陪送项目
/// Creator:     yuliping
/// CreateDate:  2017-01-12
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocItem).getItemByUser("2","") 
ClassMethod getItemByUser(LocUser, itemName)
{
	n (LocUser,itemName)
	s linkitem="",count=0,itemLocDesc="",itemdr="",linkitem="",itemDesc=""
	q:LocUser="" ""
	w "{""rows"":["
	f  s linkitem=$o(^DHCDISLU(LocUser,"LinkItm",linkitem)) q:linkitem=""  d
	.s msg=""
	.s msg=^DHCDISLU(LocUser,"LinkItm",linkitem)
	.i msg'="" s itemdr=$p(msg,"^",3)
	.s itemmsg=""
	.s itemmsg=$g(^DHCDISLI(itemdr))
	.i itemmsg'="" d
	..s itemDesc=$p(itemmsg,"^",1)
	..s itemLoc=$p(itemmsg,"^",3)
	..i itemLoc'="" s itemLocDesc=$p(^CTLOC(itemLoc),"^",1)
	..q:((itemName'="")&&(itemdr'=itemName))
	..s tmp=itemDesc_"^"_itemLocDesc_"^"_itemdr_"^"_linkitem
	..s count=count+1
	..w $case(count,1:"",:",") 
	..w ##class(web.DHCAPPJsonCommon).getJsonData("ItemDesc^ItemLoc^IDd^linkitem",tmp)
	
	 w "],""total"":"_count_"}"
	 q ""
}

/// Description:关联查询，选择陪送项目，得到接收科室
/// Creator:     yuliping
/// CreateDate:  2017-01-18
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISLocItem).getLocByItemid("11") 
ClassMethod getLocByItemid(itemid)
{
	n (itemid)
	q:itemid="" ""
	s msg="",LocDr="",LocDesc=""
	s msg=$g(^DHCDISLI(itemid))
	i msg'="" s LocDr=$p(msg,"^",3)
	i LocDr'="" s LocDesc=$p(^CTLOC(LocDr),"^",1)
	q LocDesc
}

/// Creator:    yuliping
/// CreateDate: 2017-05-02
/// Descript: combox中转点
/// w ##class(web.DHCDISLocItem).TypeAddLocCombo()
ClassMethod TypeAddLocCombo()
{
	
	s End = 10
	s Start=1
	s Count=0
	w "["
	s type=0
	f  s type = $o(^DHCDISTA(type)) q:type=""  d
	.s name=$p(^DHCDISTA(type),"^",2)
	.s flag=$p(^DHCDISTA(type),"^",3)
	.q:flag'="Y"
	.s Hosp=$p(^DHCDISTA(type),"^",4)
	.s name=$ZCONVERT(name,"U")
	.q:type=9
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",type_"^"_name)
	w "]"
	q ""
}

}
