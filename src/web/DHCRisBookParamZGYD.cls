Import SQLUser

Class web.DHCRisBookParamZGYD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询名称：QueryOrderCategory
/// 功能：查询医嘱大类
/// 参数：
/// 返回：大类列表 
/// 作者：龚平
/// 日期：2011-08-17
Query QueryOrderCategory() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryOrderCategoryExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryOrderCategory") 
 //^OEC("ORCAT",{ORCAT_RowId})=ORCAT_Code^ORCAT_Desc
 s ind=1
 Set repid=$I(^CacheTemp)
 s OrdCatDr=31  //此参数需要通过另外一途径来取得，因为各个医院都不一样
 s Rowid=0 f  s Rowid=$O(^OEC("ORCAT",Rowid)) q:(Rowid="")  d
 .s Desc=$p(^OEC("ORCAT",Rowid),"^",2)
 .Do OutOrderCategory
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutOrderCategory
 set Data=$lb(Rowid,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryOrderCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderCategoryExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryOrderCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderCategoryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryARCItemCat
/// 功能：查询医嘱子类
/// 参数：大类ROWID
/// 返回：子类列表 
/// 作者：龚平
/// 日期：2011-08-17
Query QueryARCItemCat(OrdCatDr As %String) As %Query(ROWSPEC = "Rowid:%String,OrdCatDr:%String")
{
}

ClassMethod QueryARCItemCatExecute(ByRef qHandle As %Binary, OrdCatDr As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryARCItemCat") 
 //^ARC("IC",0,"OrdCat",{ARCIC_OrdCat_DR},{ARCIC_RowId}) 取子类
 s ind=1 
 Set repid=$I(^CacheTemp)
 //s OrdCatDr=31  //此参数需要通过另外一途径来取得，因为各个医院都不一样
 if OrdCatDr'="" d
 .s Rowid="" f  s Rowid=$O(^ARC("IC",0,"OrdCat",OrdCatDr,Rowid)) q:(Rowid="")  d
 ..s ItmCat=$p(^ARC("IC",Rowid),"^",2)
 ..Do OutItmCat
 e  d
 .f  s OrdCatDr=$O(^ARC("IC",0,"OrdCat",OrdCatDr)) q:(OrdCatDr="")  d
 ..s Rowid="" f  s Rowid=$O(^ARC("IC",0,"OrdCat",OrdCatDr,Rowid)) q:(Rowid="")  d
 ...s ItmCat=$p(^ARC("IC",Rowid),"^",2)
 ...Do OutItmCat
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutItmCat
 set Data=$lb(Rowid,ItmCat)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryARCItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryARCItemMastByCat
/// 功能：查询医嘱项目名称
/// 参数：子类ROWID,医嘱名称
/// 返回：医嘱列表类列表 
/// 作者：龚平
/// 日期：2011-08-17
Query QueryARCItemMastByCat(OrdSubCatId As %String, InputOrdName As %String = "") As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String,AppointMethod:%String,Empty:%String,InputFee:%String,Location:%String,Memo:%String,AppointMethodId:%String,AppLocation:%String,Telephone:%String,ServiceGroupName:%String,ServiceGroupID:%String")
{
}

ClassMethod QueryARCItemMastByCatExecute(ByRef qHandle As %Binary, OrdSubCatId As %String, InputOrdName As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCodeTable","QueryARCItemMastByCat",1294) 
 //^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version} 取指定子类下的医嘱项
 s ind=1 
 Set repid=$I(^CacheTemp)
 s ^TMP111=InputOrdName
 i OrdSubCatId'="" d
 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip)) q:(Subscrip="")  d
 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip,Version)) q:(Version="")  d
 ...s ItemRowid=Subscrip_"||"_Version
 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
 ...q:(InputOrdName'="")&&(ItemDesc'[InputOrdName) 
 ...;if $p(^ARCIM(Subscrip,Version,7),"^",6)="S" 
 ...Do OutItmMast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutItmMast
 s (AppointMethod,AppointMethodId,InputFee,Empty,Location,Memo)=""
 s IPRowid=$o(^DHCRBCItemBookProperTypei(ItemRowid,0)) 
 i IPRowid'="" d 
 .s AppointMethodId=$p(^DHCRBCItemBookProperty(IPRowid),"^",2)
 .i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)  
 .s InputFee=$p(^DHCRBCItemBookProperty(IPRowid),"^",3)
 .s Empty=$p(^DHCRBCItemBookProperty(IPRowid),"^",4)
 .s Location=$p(^DHCRBCItemBookProperty(IPRowid),"^",5)
 .s Telephone=$p(^DHCRBCItemBookProperty(IPRowid),"^",6)
 .s AppLocation=$p(^DHCRBCItemBookProperty(IPRowid),"^",7)

 s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ItemRowid,0))
 i DMRowid'="" d
 .s Memo=$p(^DHCRBApp("Memo",DMRowid),"^",2)
 s ServiceGroupId=$p(^ARCIM(Subscrip,Version,8),"^",7)
 s GroupName=""
 i ServiceGroupId'="" d
 .s GroupName=$p(^RBC("SG",ServiceGroupId),"^",2)

 set Data=$lb(ItemRowid,ItemDesc,AppointMethod,InputFee,Empty,Location,Memo,AppointMethodId,AppLocation,Telephone,GroupName,ServiceGroupId)

 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCItemMastByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemMastByCatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryARCItemMastByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemMastByCatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryBookMethod
/// 功能：查询预约方法
/// 参数：
/// 返回：
/// 作者：龚平
/// 日期：2011-08-17
Query QueryBookMethod() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryBookMethodExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryBookMethod") 
 s ind=1
 Set repid=$I(^CacheTemp)
 s Rowid=0 f  s Rowid=$O(^DHCRBCAppointMethod(Rowid)) q:(Rowid="")  d
 .;i (DateTo="")!((DateTo'="")&(DateTo>+$h))
 .s Desc=$p(^DHCRBCAppointMethod(Rowid),"^",2)
 .s Code=$p(^DHCRBCAppointMethod(Rowid),"^",1)
 .Do OutMethod
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutMethod
 set Data=$lb(Rowid,Desc,Code)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryBookMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookMethodExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryBookMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookMethodExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数  UpdateItemInfo
/// 功能：更新检查预约属性的信息
/// 参数：
/// 返回：SQLCODE
/// 作者：龚平
/// 日期：2011-08-17
ClassMethod UpdateItemInfo(Info As %String) As %String
{
	//var Info=ArcItemId+"^"+AppointMethodId+"^"+IsEmpty+"^"+InputFee+"^"+Location+"^"+Note;
	s ArcItemId=$p(Info,"^",1)
	s AppointMethodId=$p(Info,"^",2)
	s Empty=$p(Info,"^",3)
	s InputFee=$p(Info,"^",4)
	s Location=$p(Info,"^",5)
	s Note=$p(Info,"^",6)
	s AppLocation=$p(Info,"^",7)
	s Telphone=$p(Info,"^",8)
	s ServiceGroupId=$p(Info,"^",9)
	
	s ^TMP0=Info
	
	q:ArcItemId="" 100
	
	s ItemBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,0))
	i ItemBPRowid'=""  d
	.&sql(Update DHCRBC_ItemBookProperty (DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIPB_AppLocation,DIPB_Telphone) 
	   values(:AppointMethodId,:InputFee,:Empty,:Location,:AppLocation,:Telphone) where DIBP_RowID=:ItemBPRowid)
	else  d
	.&sql(Insert into DHCRBC_ItemBookProperty (DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIBP_ARCItmMast_DR,DIPB_AppLocation,DIPB_Telphone) 
	   values(:AppointMethodId,:InputFee,:Empty,:Location,:ArcItemId,:AppLocation,:Telphone))
	
	; 插入备注信息（检查须知）   
	s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemId,0))
	if DMRowid'="" d
	.&sql(Update DHCRB_Memo (DM_Memo)values (:Note) where DM_RowID=:DMRowid)
	else  d 
	.&sql(insert into DHCRB_Memo(DM_Memo,DM_ARCItmMast_DR) values (:Note,:ArcItemId))
	
	; 更新服务组信息
	i ServiceGroupId'="" d
	.&sql(update  ARC_ItmMast(ARCIM_ServiceGroup_DR) values (:ServiceGroupId) where  ARCIM_RowId=:ArcItemId)
	
	q SQLCODE
}

/// 函数：AutoBooked 
/// 功能：自动预约，返回预约日期、时间以及注意事项 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）,UserID用户ID
/// 返回：(flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述^OrditemRowid@OrditemRowid)&.... flag-0:自动预约失败，1 自动预约成功  
/// 作者：gongping 
/// 日期：2011-08-22 
/// s ret=##class(web.DHCRisBookParam).AutoBooked("1567||30",+$h,$p($h,",",2),"","")
/// s ret=##class(web.DHCRisBookParamZGYD).AutoBooked("20017||3899@77006||1","63405","35919","","687")
/// s ret=##class(web.DHCRisBookParamZGYD).AutoBooked("20017||3899@76304||6@20017||3900","63405","51462","","687")
/// s ret=##class(web.DHCRisBookParamZGYD).AutoBooked("20017||3892","63511","47985","","687") //20017||3893
ClassMethod AutoBooked(OrditemRowid As %String, ChargeDate As %Integer, ChargeTime As %Integer, OherParam As %String = "", UserID As %String = "") As %String
{

    i UserID="" s UserID="71"
    s ItemGroup="",GetInfo=""
    s ItemGroup=..SameItemGroup(OrditemRowid,UserID)
    ;w !,"ItemGroup="_ItemGroup
    q:(ItemGroup="") "NoParam"
    s Itmcount=0
    s Itmcount=$l(ItemGroup,"^")
    s ChargeTime=ChargeTime+5400
    ;w !,"Itmcount="_Itmcount
    for k=1:1:Itmcount 
    {  
         ;w !,"k="_k
	     s perItmGroup=$p(ItemGroup,"^",k)
	     ;w !,"perItmGroup="_perItmGroup
	     s pertItmGroupCount=0
	     s pertItmGroupCount=$l(perItmGroup,"@")
	     ;w !,"pertItmGroupCount="_pertItmGroupCount
	     i (pertItmGroupCount'=0)
	     {
		     ;w !,"perItmGroup="_perItmGroup
		     s Request=""
		     s Request=..RequestAutoBooked(perItmGroup,ChargeDate,ChargeTime,OherParam)
		     ;w !,"Request="_Request
		     if (Request'="")
		     {
			     i GetInfo="" s GetInfo=Request
			     e  d
			     .s GetInfo=GetInfo_"&"_Request
		     }
		 }
    }
    q GetInfo
}

/// 函数：RequestAutoBooked 
/// 功能：自动预约，返回预约日期、时间以及注意事项 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）
/// 返回：(flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述^OrditemRowid@OrditemRowid) flag-0:自动预约失败，1 自动预约成功  
/// 作者：gongping 
/// 日期：2011-08-22 
/// s ret=##class(web.DHCRisBookParam).RequestAutoBooked("20017||3899@20017||3900","63405","35919","","687")
ClassMethod RequestAutoBooked(OrditemRowidGroup As %String, ChargeDate As %Integer, ChargeTime As %Integer, OherParam As %String = "") As %String
{
   s ResInfo="",Info=""
   s BookedFlag=0
   s (ServiceName,GetResCode,GetResDesc,ArriveDate,ArriveTime,BookedNote,RecLocName)=""
   
   s ^t=OrditemRowidGroup_"^"_ChargeDate_"^"_ChargeTime_"^"_OherParam
  
   s GetperOrditemRowid=""
   s GetperOrditemRowid=$p(OrditemRowidGroup,"@",1)
   
   s OrderRowid=$p(GetperOrditemRowid,"||",1)
   s ItemRowid=$p(GetperOrditemRowid,"||",2)
   s RecLocId=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)       ; 执行科室
   i RecLocId'="" d 
   .s RecLocName=$p(^CTLOC(RecLocId),"^",2)
   .i $l(RecLocName,"-")>1 s RecLocName=$p(RecLocName,"-",2)

   s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
   
   s Subscript=$p(ItemMastRowid,"||",1)
   s Version=$p(ItemMastRowid,"||",2)
   
   s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
   q:BPRowid="" "0^^^^^系统没有设置预约信息,请联系信息中心$^"_OrditemRowidGroup
   
   s AppMethod="不需预约"
   
   s Location=$p(^DHCRBCItemBookProperty(BPRowid),"^",5)  ; 科室的物理位置
   s AppLocation=$p(^DHCRBCItemBookProperty(BPRowid),"^",7)  ; 预约位置 
   
   //xiachunrong add
   s orddeptRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",3) ;医嘱科室
   s orddeptdesc=$p(^CTLOC(orddeptRowid),"^",2) ;医嘱科室
   s Info="1^^^^^请您立即到"_RecLocName_"做检查。$地点:"_Location_"^"_OrditemRowidGroup
   //q:orddeptdesc'["门诊" Info    ;暂时加，只有门诊的才预约 
   //xiachunrong 2012.11.27 add end
   
   
   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
   i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
   i (AppMethod="不需预约")!(AppMethod="无需预约") d
   .s Info="1^^^^^请您立即到"_RecLocName_"做检查。$地点:"_Location_"^"_OrditemRowidGroup
   q:(AppMethod="不需预约")!(AppMethod="无需预约") Info
   
   if AppMethod="自动预约" 
   {
	   s ServiceGroupId=$p(^ARCIM(Subscript,Version,8),"^",7)
	   i ServiceGroupId'="" d
	   .s ServiceName=$p(^RBC("SG",ServiceGroupId),"^",2)
	   
	   .i ServiceName="CTA组"   d 
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,"",RecLocId,GetperOrditemRowid)   //返回可预约信息
	   .else  if (ServiceName="CTB组")  d
	   ..s ret=..GetEmpty(OrditemRowidGroup)
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,ret,RecLocId,GetperOrditemRowid)   //返回可预约信息
	   .else  d
	   ..; 其他的需要自动预约的项目
	   ..s ret=..GetEmpty(OrditemRowidGroup)
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,$g(ret),RecLocId,GetperOrditemRowid)   //返回可预约信息
	   
	   i ResInfo'="" d
	   .; 插入预约表
	   .s SchRowid=$p(ResInfo,"^",1)
	   .s ArriveDate=$p(ResInfo,"^",2)
	   .s strArriveDate=$zd(ArriveDate,3)
	   .s ArriveTime=$p(ResInfo,"^",3)
	   .s strArriveTime=$zt(ArriveTime,1)
	   .s BookeInfo=OrditemRowidGroup_"^"_SchRowid_"^2^"_OherParam
	   .s SQLCODEInfo=##class(web.DHCRisResourceApptSchudleZGYD).InsertBookedInfo(BookeInfo)
	   .s SQLCODE=$p(SQLCODEInfo,"^",1)
	   .i SQLCODE=0  D
	   ..s resourceId=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
	   ..i resourceId'="" d
	   ...s BookedFlag=1
	   ...s CTCPDR=$p($g(^RB("RES",resourceId)),"^",2)
	   ...s CTCPDR=$p(CTCPDR,$c(0))
	   ...i CTCPDR'="" d
	   ....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",1)
	   ....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	   ...else  d
	   ....s EQDR=$p($g(^RB("RES",resourceId)),"^",3)
	   ....s GetResCode=$p($g(^RBC("EQ",EQDR)),"^",1)
	   ....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	   ..s BookedNote=..GetBookNote(ArriveDate,strArriveTime,ServiceName,ItemMastRowid, RecLocName,ChargeDate,strArriveDate)
	   ..s Info=BookedFlag_"^"_GetResCode_"^"_GetResDesc_"^"_strArriveDate_"^"_strArriveTime_"^"_BookedNote_"^"_OrditemRowidGroup
	   ..s ^DHCRISTAUTOTEMP(GetperOrditemRowid)=Info
	   .else  d
	   ..s Info="0^^^^^请您立即到"_RecLocName_"就诊。$地点:"_AppLocation_"^"_OrditemRowidGroup      ;"0^^^^^请您立即到"_RecLocName_"("_AppLocation_")预约检查。"
	   else  d
	   .s Info="0^^^^^请您立即到"_RecLocName_"就诊。$地点:"_AppLocation_"^"_OrditemRowidGroup
  }
  else
  { 
      ; 其他的预约方式 都是通过服务台预约的方式
	  s Info="1^^^^^请您立即到"_RecLocName_"预约。$地点:"_AppLocation_"^"_OrditemRowidGroup
  }
   q Info
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPan(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, Empty As %String, LocId As %String, OeorditemRowid As %String = "") As %String
{
		
	s bFind=0
	s Day=ChargeDate
	s UseResInfo=""
	s ServiceName=""
	
	i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
    .;w !,ServiceName
    //i (Empty'="Y")&(ServiceName="CTB组") d            ; 未空腹的CTB组第二天进行预约
    i (Empty="Y") d   
    .s Day=Day+1  
   
	//查找可使用的预约资源
	while(bFind<1)
	{	
	    //w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
		s UseResInfo=..GetDayUseBookInfo(Day,ChargeDate,ChargeTime,ServiceGroupId,LocId,OeorditemRowid)
		;w !,"UseResInfo"_UseResInfo
		if (UseResInfo="")
		{
		    s Day=Day+1
		    i (Day-ChargeDate)>50  s bFind=1   ; 如果超过50天没有，可能是系统没有设置排版，则退出循环
		   
		}	
		else    ; 找到可用的计划
		{   
			s bFind=1
		}
	}
	
	q UseResInfo
}

/// 函数：GetEmpty
/// 功能：判断是否空腹
/// 参数：医嘱ROWID 
/// 返回：Y/N
/// 作者：gongping 
/// 日期：2011-08-22 
/// w ##class(web.DHCRisBookParamZGYD).GetEmpty("20017||3903")
ClassMethod GetEmpty(OrditemRowid) As %String
{
	s Empty="N"
	/*s AppRowid=$o(^DHCRBAppOrdi(0,OrditemRowid,0))
	i AppRowid'="" d
	.s ItemInfo=^DHCRBApp("Bill",AppRowid,"ItemInfo")
	.s count=$l(ItemInfo,"^")
	.for i=1:count:1 d
	..s pItemInfo=$p(ItemInfo,"^",i)
	..s ItemName=$p(pItemInfo,$c(2),1)  
	..s ItemResult=$p(pItemInfo,$c(2),2)
	..i (ItemName="空腹")!(ItemName="是否空腹")  d
	...i ItemResult="是"  s Empty="Y"*/
	s Emptycount=0
	s Emptycount=$l(OrditemRowid,"@")
	for t=1:1:Emptycount 
    {  
         s getarcimid="",OrderID="",itemsubID="",IPRowid="",getEmpty=""
         q:(Empty="Y")
	     s perRowid=$p(OrditemRowid,"@",t)
	     s OrderID=$p(perRowid,"||",1)
	     s itemsubID=$p(perRowid,"||",2)
	     s getarcimid=$p($g(^OEORD(OrderID,"I",itemsubID,1)),"^",2) 
	     i getarcimid'="" s IPRowid=$o(^DHCRBCItemBookProperTypei(getarcimid,0)) 
         i IPRowid'="" s getEmpty=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",4)
         i getEmpty="Y" s Empty="Y"
    }
	
	q Empty
}

/*ClassMethod GetDayUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "") As %String
{
	s MaxRemainNumber=0    ; 最大的剩余数
	s SelSchuldRowid=0
	
	s Info="",ServiceName=""
	
	// 是否是奥抗病人
	s IsAK=..GetAokangPatient(OEorditem)

	i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)

    ; 按时间段索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
    s TPRowid=0 f  s TPRowid=$o(^DHCRBCTimePeriodSet(TPRowid)) q:TPRowid=""  d
    .s TimeDuration=$p(^DHCRBCTimePeriodSet(TPRowid),"^",1)
    .q:(Info'="")
    .s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Date-Time-Res",LocId,Day,ServiceGroupId,TimeDuration,SchRowid)) q:SchRowid=""  d
    ..q:(Info'="")
    ..s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1) 
    ..q:(RessourceID="")
    ..s BK=""
    ..s BK=..GetAppResParam(OEorditem,RessourceID)
    ..q:(BK="N")
 	..s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
	..i AutoUseNumber="" s AutoUseNumber=0
	..s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
	..s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	..s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	..i RemainNum="" s RemainNum=MaxNumber
	..s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	..i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	..s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	..s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	..s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
	..i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
	..i (Day=InChargeDate)&(ServiceName="CTA组")  d           ; 当天预约情况，判断缴费时间点，如果是下一天则不用判断
    ...i (InChargeTime<StartTime)&(AutoRemainNum>MaxRemainNumber)  d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime 
	..else  i (Day=InChargeDate)&(ServiceName="CTB组")  d 
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d 
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime 
	..else  d
	...i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber)) d 
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime 
	
	..if (Day>InChargeDate)&(IsAK'="Y")  d
	...i (AutoRemainNum>MaxRemainNumber) d    ; 下一个工作日的预约，只考虑限额
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..else  if (Day>InChargeDate)&(IsAK="Y") d
	...i (AutoRemainNum>0)  d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_EndTime

	.; 找到这个时间段的最大剩余的资源，且不是奥抗阳性的病人则退出，否则取最后一个可以预约的时间段
	.i (MaxRemainNumber>0)&(IsAK'="Y") d 
	..s TPRowid=100

	q Info
}*/
/// 函数：GetDayUseBookNum
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetBookNote(ArriveDate As %String, ArriveTime As %String, ServiceName As %String, ItemMastRowid As %String, RecLocName As %String, ChargeDate As %String, strArriveDate As %String) As %String
{

   s Info=""
   s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
   s Location=$p(^DHCRBCItemBookProperty(BPRowid),"^",5)  ; 科室的物理位置
   s AppLocation=$p(^DHCRBCItemBookProperty(BPRowid),"^",7)  ; 预约位置 
   if ServiceName="CTB组" d
    .i (ChargeDate=ArriveDate) d
    ..s Info="请您空腹立即或者今天"_ArriveTime_"之前,到"_RecLocName_"报到.$地点："_Location
    .else  d
    ..s Info="请您需要空腹(或者至少空腹四小时),并于"_strArriveDate_" "_ArriveTime_"到"_RecLocName_"报到.$地点："_Location
   else  d
     .i (ChargeDate=ArriveDate) d
     ..s Info="请您立即或者今天"_ArriveTime_"之前,到"_RecLocName_"报到.$地点："_Location
     .else  d 
     ..s Info="请您"_strArriveDate_" "_ArriveTime_"之前,到"_RecLocName_"报到.$地点："_Location
  	q Info
}

/// 函数：GetUseResPanbyOrdItem
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：预约日期^预约时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPanbyOrdItem(ChargeDate As %Integer, ChargeTime As %Integer, OrditemRowid As %String) As %String
{
}

/// 函数：GetDayResSchudle
/// 功能：获取服务组是否生成了资源计划
/// 参数：日期，服务组
/// 返回：TRUE/FALSE
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetDayResSchudle(Day As %Integer, ServiceGroupId As %String) As %Boolean
{
	S Rowid=$o(^DHCRBCResSchdulei("SericeGroup",ServiceGroupId,Day,0))
    q:Rowid="" 0
    q 1
}

/// 查询名称：QueryOrderCategory
/// 功能：查询医嘱大类
/// 参数：
/// 返回：大类列表 
/// 作者：龚平
/// 日期：2011-08-17
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryBookTimeDuration","")
Query QueryBookTimeDuration(TimeCode As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargTime:%String")
{
}

ClassMethod QueryBookTimeDurationExecute(ByRef qHandle As %Binary, TimeCode As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^TMP1111=TimeCode
 i TimeCode'="" d
 .s TimeRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeCode,0))
 .i TimeRowid'="" d
 ..d OutTime
 else  d
 .s TimeRowid=0  f  s TimeRowid=$o(^DHCRBCTimePeriodSet(TimeRowid)) q:TimeRowid=""  d
 ..d OutTime 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutTime
 s TimeCode=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",1)
 s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",2)
 s StartTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",3)
 i StartTime'="" d
 .s StartTime=$zt(StartTime)
 s EndTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",4)
 i EndTime'="" d 
 .s EndTime=$zt(EndTime)
 s EndChargeTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",5)
 i EndChargeTime'="" d
 .s EndChargeTime=$zt(EndChargeTime)
 
 set Data=$lb(TimeRowid,TimeCode,TimeDesc,StartTime,EndTime,EndChargeTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryBookTimeDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookTimeDurationExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryBookTimeDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookTimeDurationExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数：InsertTimePeriod
/// 功能： 插入或者是修改预约时间段
/// s ret=##class(web.DHCRisResourceApptSchudle).InsertResoucePlan(^TMP)
ClassMethod InsertTimePeriod(Info As %String) As %String
{
	s Rowid=$p(Info,"^",1)
	s Code=$p(Info,"^",2)
	s Desc=$p(Info,"^",3)
	s StartTime=$p(Info,"^",4)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(Info,"^",5)
	s EndTime=$zth(EndTime,3)
	s ChargTime=$p(Info,"^",6)
    s ChargTime=$zth(ChargTime,3)

    i Rowid="" d
    . &sql(insert into DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime )
         values ( :Code,:Desc,:StartTime,:EndTime,:ChargTime))
    else  d
    .&sql(update DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime )
         values (:Code,:Desc,:StartTime,:EndTime,:ChargTime) where DTPS_Rowid=:Rowid)
    
    q SQLCODE
}

/// 函数：DeleteTimePeriod
/// 功能： 删除预约时间段
/// s ret=##class(web.DHCRisBookParam).DeleteTimePeriod(^TMP)
ClassMethod DeleteTimePeriod(Rowid As %String) As %String
{
	s SQLCODE=0
    if Rowid'="" d
	.s Code=$p(^DHCRBCTimePeriodSet(Rowid),"^",1)
    .s ret=..FindUseTime(Code)
    .i ret="N"  d
	..&sql(delete from DHCRBC_TimePeriodSet where DTPS_Rowid=:Rowid) 
	q SQLCODE
}

//查找此时间段是否被使用

ClassMethod FindUseTime(Code As %String) As %String
{
   s Find="N"
   s TimeCode=""
   s RPRowid=0 f  s RPRowid=$o(^DHCRBCResourcePlan(RPRowid)) q:(RPRowid="")!(TimeCode=Code)  d
   .s TimeCode=$p(^DHCRBCResourcePlan(RPRowid),"^",4)
   .i TimeCode=Code  s Find="Y"
   q Find
}

/// 查询名称：QueryServiceGroup
/// 功能：查询服务组
/// 参数：
/// 返回：大类列表 
/// 作者：龚平
/// 日期：2011-08-17
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryServiceGroup")
Query QueryServiceGroup() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryServiceGroupExecute(ByRef qHandle As %Binary) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s GroupId=0  f  s GroupId=$o(^RBC("SG",GroupId)) q:GroupId=""  d
 .d OutService 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutService
 s Code=$p(^RBC("SG",GroupId),"^",1)
 s Desc=$p(^RBC("SG",GroupId),"^",2)
 set Data=$lb(GroupId,Desc,Code)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryServiceGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryServiceGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数 GetTimeInfo 
/// 功能 获取时间信息
/// 返回 时间段^开始时间^结束时间^收费时间
ClassMethod GetTimeInfo(TimeCode As %String) As %String
{
	q:TimeCode="" "^^^^"
	s TimeRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeCode,0))
	q:TimeRowid="" "^^^^"  
	s TimeCode=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",1)
 	s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",2)
 	s StartTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",3)
 	i StartTime'="" d
 	.s StartTime=$zt(StartTime)
 	s EndTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",4)
    i EndTime'="" d 
    .s EndTime=$zt(EndTime)
    s EndChargeTime=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",5)
    i EndChargeTime'="" d
    .s EndChargeTime=$zt(EndChargeTime)
    q TimeCode_"^"_TimeDesc_"^"_StartTime_"^"_EndTime_"^"_EndChargeTime
}

/// 查询名称：QueryItemLimitCondtion
/// 功能：查询医嘱的限制条件
/// 参数：
/// 返回：大类列表 
/// 作者：龚平
/// 日期：2011-08-17
/// d ##class(%ResultSet).RunQuery("web.QueryItemLimitCondtion","QueryBookTimeDuration","")
Query QueryItemLimitCondtion(ArcItemMastId As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargTime:%String")
{
}

ClassMethod QueryItemLimitCondtionExecute(ByRef qHandle As %Binary, ArcItemMastId As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ItmCatDR=$p(^ARCIM($p(ArcItemMastId,"||",1),$p(ArcItemMastId,"||",2),1),"^",10)
 s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	
 
 s AppItmrowid=$o(^DHCRBCAppi("ItmMast",ArcItemMastId,0))
 i AppItmrowid'="" d
 .s ShapeDR=$p(^DHCRBCApp("ItmMast",AppItmrowid),"^",2)   
 else  d
 .s AppCatrowid=$o(^DHCRBCAppi("ItmCat",ItmCatDR,0))
 .i AppCatrowid '=""  d
 ..s ShapeDR=$p(^DHCRBCApp("ItmCat",AppCatrowid),"^",2) 
 .e  d
 ..s AppBigCatRowid=$o(^DHCRBCAppi("OrdCat",OrdCatDr,0)) 
 ..i AppBigCatRowid'="" d
 ...s ShapeDR=$p(^DHCRBCApp("OrdCat",AppBigCatRowid),"^",2) 

  q:ShapeDR="" ""
  s FieldRowid=0  f  s FieldRowid=$o(^DHCRBCAppSF("ShapeField",0,ShapeDR, FieldRowid)) q:FieldRowid=""  d 
  .s LimtRowid=$o(^DHCRBCItemLimitCondtioni("ItemMast-Field",ArcItemMastId,FieldRowid,0))
  .i LimtRowid'="" d
  ..s Val=$p(^DHCRBCItemLimitCondtion(LimtRowid),"^",3)
  ..s BookTime=$p(^DHCRBCItemLimitCondtion(LimtRowid),"^",4)
  ..s Require=$p(^DHCRBCItemLimitCondtion(LimtRowid),"^",5)
  ..d OutField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutField
 
 set Data=$lb(ArcItemMastId,FieldRowid,Val,BookTime,Require)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryItemLimitCondtionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemLimitCondtionExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItemLimitCondtionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemLimitCondtionExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 是否是奥抗阳性病人
/// s ret=##class(web.DHCRisBookParam).GetAokangPatient("1567||30")
ClassMethod GetAokangPatient(OeOrdRowid As %String) As %String
{
	 s ret="N"
     s info=##class(web.DHCRisApplicationBill).GetAppItemInfo(OeOrdRowid)
     s len=$l(info,"^")
     for i=1:1:len d
     .s ItemInfo=$p(info,"^",i)
     .s Name=$p(ItemInfo,$c(2))
     .s Value=$p(ItemInfo,$c(2),2)
     .s ItemInfo=Name_Value
     .i ItemInfo="奥抗阳性" d
     ..s ret="Y"
     q ret
}

/// do ##class(web.DHCRisBookParam).GetAutoBooked("9505698||5")
ClassMethod GetAutoBooked(OrditemRowid As %String) As %String
{
	s (AppointMethodId,AppMethod,OrderRowid,ItemRowid,ItemMastRowid,Subscript,Version)=""
	s (ServiceGroupId,RecLocId,value,ArriveDate,strArriveTime)=""
	
	s ChargeDate=+$h
	s ChargeTime=$p($h,",",2)
	
	s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    
    s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
    s Subscript=$p(ItemMastRowid,"||",1)
    s Version=$p(ItemMastRowid,"||",2)
    s RecLocId=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)       ; 执行科室
	
	//xiachunrong add
   s orddeptRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",3) ;医嘱科室
   s orddeptdesc=$p(^CTLOC(orddeptRowid),"^",2) ;医嘱科室
   q:orddeptdesc'["门诊" ""    ;暂时加，只有门诊的才预约 
   //xiachunrong 2012.11.27 add end
   
	s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
	q:(BPRowid="")
	
    s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
    i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
    
    if AppMethod="自动预约" 
    {
	     s ServiceGroupId=$p($g(^ARCIM(Subscript,Version,8)),"^",7) 
	     i ServiceGroupId'="" d
	     .s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,$g(ret),RecLocId,OrditemRowid) //返回可预约信息
	     i ResInfo'="" d
	     .; 插入预约表
	     .s SchRowid=$p(ResInfo,"^",1)
	     .s ArriveDate=$p(ResInfo,"^",2)
	     .s strArriveDate=$zd(ArriveDate,3)
	     .s ArriveTime=$p(ResInfo,"^",3)
	     .s strArriveTime=$zt(ArriveTime,1)
	     
	     
	}
	
	s value=$g(strArriveDate)_" "_$g(strArriveTime)
	
	
	q value
}

/// sunyi 2014-07-30
/// w ##class(web.DHCRisBookParam).GetAppResParam("20017||3880","1383")
ClassMethod GetAppResParam(OEorditem As %String, RessourceID As %String) As %String
{
	q:(OEorditem="")
	s (OrderRowid,ItemRowid,paadmdr,AppLocDR,AppResSetRowid,ResPatCodeRowid)=""
	s ResAppFind=0,PatTypeFind=0            ;申请科室或病人类型是否设置资源
	s ResAppSetFind="N",PatTypeSetFind="N"  ;是设置了是否发现可用资源默认"N"
	
    s OrderRowid=$p(OEorditem,"||",1)
    s ItemRowid=$p(OEorditem,"||",2)
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i paadmdr'="" s patienttype=$p($g(^PAADM(paadmdr)),"^",2)  
    s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
    
    ;按申请科室查询可用资源
    s ResAppRowid=0  f  s ResAppRowid=$o(^DHCRBCResourceInAppLoc(ResAppRowid)) q:ResAppRowid=""  d 
    .q:(ResAppFind=1)
    .s GetAppLocDR=$p($g(^DHCRBCResourceInAppLoc(ResAppRowid)),"^",1)
    .i AppLocDR=GetAppLocDR s ResAppFind=1
    .;b //001
    s ResAppRowid=""
    i ResAppFind=1 s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",AppLocDR,RessourceID,ResAppRowid))
    i ResAppRowid'="" s ResAppSetFind="Y"
    ;w !,"ResAppFindA="_ResAppFind_"-----PatTypeFindA="_PatTypeFind
    q:(ResAppFind=1)&(ResAppSetFind="N") "N"
    q:(ResAppSetFind="Y") "Y"
    
    ;按病人类型查询可用资源
    s ResCodeRowid=0 f  s ResCodeRowid=$o(^DHCRBCPatTypeUseResource(ResCodeRowid)) q:(ResCodeRowid="")  d
    .q:(PatTypeFind=1)
    .s GetPatType=$p($g(^DHCRBCPatTypeUseResource(ResCodeRowid)),"^",1)
    .i patienttype=GetPatType s PatTypeFind=1
    .;b //002
    s ResCodeRowid=""
    i PatTypeFind=1 s ResCodeRowid=$o(^DHCRBCPatTypeUseResourcei("TYPECODE",patienttype,RessourceID,ResCodeRowid))
    i ResCodeRowid'="" s PatTypeSetFind="Y"
    ;w !,"PatTypeFindB="_PatTypeFind_"-----PatTypeSetFindB="_PatTypeSetFind
    q:(PatTypeFind=1)&(PatTypeSetFind="N") "N"
    q:(PatTypeSetFind="Y") "Y"
    
    ;w !,"ResAppFind="_ResAppFind_"-----PatTypeFind="_PatTypeFind
    q:(ResAppFind=0)&(PatTypeFind=0) "Y"
}

/// w ##class(web.DHCRisBookParamZGYD).GetHasBookSchudkeID("20017||3874@20017||3863")
/// 入参:医嘱ID@医嘱ID@....
/// 返回值:是否存在已预约的医嘱:N -- Y
///        
ClassMethod GetHasBookSchudkeID(OrditemRowid As %String) As %String
{
	s CountYD=0
	s CountYD=$l(OrditemRowid,"@")
	s Info="",Flag="N"
	
    for j=1:1:CountYD
    {
	  
	   s DetailRowid=""
       s perOrditemRowid=$p(OrditemRowid,"@",j)
	   s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
	   q:(DetailRowid="")
	   s ResSchduleID=""
	   s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",2)
	   i ResSchduleID'="" s Flag="Y"
    }
	
	q Flag
}

/// 根据医嘱查找项目是否能一起预约 Y-是 
/// NSet--没有设置医嘱关联项   NReg--不同登记号   
/// NRec--不同接收科室   NSerGroup--不同服务组
/// sunyi 2012-01-16
/// w ##class(web.DHCRisBookParamZGYD).SameBookItem("20017||3874@20017||3877")
/// w ##class(web.DHCRisBookParamZGYD).SameBookItem("20017||3875@20017||3876")
ClassMethod SameBookItem(OrditemRowid) As %String
{
	s SameCount=0
	s SameCount=$l(OrditemRowid,"@")
	s SGroupRowid=""
	s LastRegNo=""
	s LastRecLocRowid=""
	
	for i=1:1:SameCount 
    {
	    s arcimid="",IsAllow="Y",CurrentRowid="",paadmdr="",papatmasmdr=""
	    s CurrentRegNo="",CurrentRecLocdr=""
	    s perOrditemRowid=$p(OrditemRowid,"@",i)
	    s OrderRowid=$p(perOrditemRowid,"||",1)
	    s itemsub=$p(perOrditemRowid,"||",2)
	    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	    i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	    i papatmasmdr'="" s CurrentRegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    s CurrentRecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	    i arcimid'=""
	    {
		   s BPRowid=""
		   s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		   s SubscriptID=$p(arcimid,"||",1)
		   s VersionID=$p(arcimid,"||",2)
		   s CurrentRowid=$p($g(^ARCIM(SubscriptID,VersionID,8)),"^",7)
		   i (BPRowid="")
		   {
			   s IsAllow="NSet"
		   }
		   q:(IsAllow="NSet")
		   i (LastRegNo'="")&(LastRegNo'=CurrentRegNo)
		   {
			   s IsAllow="NReg"
		   }
		   q:(IsAllow="NReg")
		   i (LastRecLocRowid'="")&(LastRecLocRowid'=CurrentRecLocdr)
		   {
			   s IsAllow="NRec"
		   }
		    q:(IsAllow="NRec")
		   i (SGroupRowid'="")&(SGroupRowid'=CurrentRowid)
		   {
			   s IsAllow="NSerGroup"
		   }
		   q:(IsAllow="NSerGroup")
		   s LastRegNo=CurrentRegNo
	       s LastRecLocRowid=CurrentRecLocdr
		   s SGroupRowid=CurrentRowid
		}
    }
    q IsAllow
}

/// 转预约函数
/// w ##class(web.DHCRisBookParamZGYD).ReBkInterface("20017||3870","7859")
ClassMethod ReBkInterface(InOrditemRowid As %String, SchRowid As %String = "") As %String
{
   s perOrditemRowid=$p(InOrditemRowid,"@",1)
   s (ResDetailRowid,ResSchduleID,ItemMastRowid,LocId)=""
   s (OrderRowid,ItemRowid,ServiceGroupId,ItemMastRowid,ret)=""
  
   s SQLCODE=100
   
   s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
   s OrderRowid=$p(perOrditemRowid,"||",1)
   s ItemRowid=$p(perOrditemRowid,"||",2)
  
   i ResDetailRowid'="" d
   .s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
 
   s ret=##class(web.DHCRisResourceApptSchudleZGYD).IsUpdateSchudle(perOrditemRowid)
   i (SchRowid'="")
   {
	  i (ret="Y")
	  {
	      s CAUseNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",9)
	      s CARemainNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",10)
	      
	      i CAUseNumber="" s CAUseNumber=0
	      i CARemainNumber="" s CARemainNumber=0
	     
	      i (CAUseNumber'=0 )
	      {
		      s CAUseNumber=CAUseNumber-1
		      s $p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)=CAUseNumber
	      }
	      i (CARemainNumber'=0) 
	      {
		      s CARemainNumber=CARemainNumber+1
		      s $p(^DHCRBCResourceSchdule(ResSchduleID),"^",10)=CARemainNumber
		  }
		  
	      s NewUseNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",9)
	      i NewUseNumber="" s NewUseNumber=0 
	      s MaxNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",7)
	      s NewRemainNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",10)
	      i NewRemainNumber="" s NewRemainNumber=MaxNumber
	  }
      i (NewRemainNumber'=0)
      {  
	      s NewUseNumber=NewUseNumber+1
	      s NewRemainNumber=NewRemainNumber-1
	      s $p(^DHCRBCResourceSchdule(SchRowid),"^",9)=NewUseNumber
	      s $p(^DHCRBCResourceSchdule(SchRowid),"^",10)=NewRemainNumber
	      s Counts=0
	      s Counts=$l(InOrditemRowid,"@")
	      //w !,"Counts="_Counts
	      for j=1:1:Counts 
          {
  
            s perOrdItmRowid=$p(InOrditemRowid,"@",j)
	        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID)
	                           values (:SchRowid,:paadmdr) where  DRPD_OrderItem_ID=:perOrdItmRowid)       
          }           
      } 
      I SQLCODE TRollback  
      I SQLCODE q 
  	              
	  
   }
   
    q SQLCODE
}

/// 同病人,同接收科室,同服务组 医嘱在一起 
/// 入参:OrditemRowid=1@2@3@....
/// 返回值:OrditemRowid@OrditemRowid^OrditemRowid@OrditemRowid^........
/// sunyi 2012-01-16
/// w ##class(web.DHCRisBookParamZGYD).SameItemGroup("20017||3874@20017||3877@20017||3878@20017||3898","687")
/// w ##class(web.DHCRisBookParamZGYD).SameItemGroup("20017||3899@76304||6@20017||3900","687")
ClassMethod SameItemGroup(OrditemRowid, UserID) As %String
{
	s SameCount=0
	s SameCount=$l(OrditemRowid,"@")
	s SGroupRowid=""
	s LastRegNo=""
	s LastRecLocRowid=""
	s LastBPRowid=""
	s Info=""
	i UserID="" s UserID="71"
	k ^DHCRISITEMGROUP("GROUP",UserID)
	k ^DHCRISITEMGROUP("GROUP","NOSET",UserID)
	for i=1:1:SameCount 
    {
	    s arcimid="",IsAllow="Y",CurrentRowid="",paadmdr="",papatmasmdr=""
	    s CurrentRegNo="",CurrentRecLocdr=""
	    s perOrditemRowids=$p(OrditemRowid,"@",i)
	    ;w !,"perOrditemRowids="_perOrditemRowids_"--"
	    s OrderRowid=$p(perOrditemRowids,"||",1)
	    s itemsub=$p(perOrditemRowids,"||",2)
	    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	    i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	    i papatmasmdr'="" s CurrentRegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    s CurrentRecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	    i arcimid'=""
	    {
		   s BPRowid=""
		   s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		   s SubscriptID=$p(arcimid,"||",1)
		   s VersionID=$p(arcimid,"||",2)
		   s ServiceGroupId=$p($g(^ARCIM(SubscriptID,VersionID,8)),"^",7)

		   i (BPRowid="")
		   {
			   i '$d(^DHCRISITEMGROUP("GROUP","NOSET",UserID)) 
			   {
				   
				   s ^DHCRISITEMGROUP("GROUP","NOSET",UserID)=perOrditemRowids
				   ;w !,^DHCRISITEMGROUP("GROUP","NOSET",UserID)
			   }else
			   {
				   ;w !,"2"
				   s ^DHCRISITEMGROUP("GROUP","NOSET",UserID)=$g(^DHCRISITEMGROUP("GROUP","NOSET",UserID))_"@"_perOrditemRowids
			   }
		   }
		  
		   i ((CurrentRecLocdr'="")&(CurrentRegNo'="")&(ServiceGroupId'="")&(BPRowid'=""))
		   {
			  
			   i '$d(^DHCRISITEMGROUP("GROUP",UserID,CurrentRegNo,CurrentRecLocdr,ServiceGroupId)) 
			   {
				   ;w !,"A"_perOrditemRowids
				   s ^DHCRISITEMGROUP("GROUP",UserID,CurrentRegNo,CurrentRecLocdr,ServiceGroupId)=perOrditemRowids
				   
			   }else
			   {  
			       ;w !,"B"_perOrditemRowids
				   //i (LastRegNo=CurrentRegNo)&(LastRecLocRowid=CurrentRecLocdr)&(SGroupRowid=ServiceGroupId) d
				   i ($d(^DHCRISITEMGROUP("GROUP",UserID,CurrentRegNo,CurrentRecLocdr,ServiceGroupId))) d
				   .s ^DHCRISITEMGROUP("GROUP",UserID,CurrentRegNo,CurrentRecLocdr,ServiceGroupId)=$g(^DHCRISITEMGROUP("GROUP",UserID,CurrentRegNo,CurrentRecLocdr,ServiceGroupId))_"@"_perOrditemRowids
			   }
		   }
		   
		   s LastRegNo=CurrentRegNo
	       s LastRecLocRowid=CurrentRecLocdr
		   s SGroupRowid=ServiceGroupId
		   s LastBPRowid=BPRowid
		}
    }
   
   s RegNo=""  f  s RegNo=$o(^DHCRISITEMGROUP("GROUP",UserID,RegNo)) q:(RegNo="")  d
   .s RecID=""  f  s RecID=$o(^DHCRISITEMGROUP("GROUP",UserID,RegNo,RecID)) q:(RecID="")  d
   ..s SGID=""  f  s SGID=$o(^DHCRISITEMGROUP("GROUP",UserID,RegNo,RecID,SGID)) q:(SGID="")  d
   ...i Info="" s Info=$g(^DHCRISITEMGROUP("GROUP",UserID,RegNo,RecID,SGID))
   ...e  d
   ....s Info=$g(^DHCRISITEMGROUP("GROUP",UserID,RegNo,RecID,SGID))_"^"_Info
   
   if $d(^DHCRISITEMGROUP("GROUP","NOSET",UserID))
   {
	   s Info=Info_"^"_$g(^DHCRISITEMGROUP("GROUP","NOSET",UserID))
   }
   
   q Info
}

/// 函数：GetDayUseBookNum
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping
/// 修改者: sunyi 
/// 日期：2011-11-20 
/// /////////////////////////////////////////////////////////////////////////////////////
/// w ##class(web.DHCRisBookParamZGYD).GetDayUseBookInfo("63511","63511","50930","4","83","20017||3892")
/// w ##class(web.DHCRisBookParamZGYD).GetDayUseBookInfo("63511","63511","30930","4","83","20017||3893")
ClassMethod GetDayUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "") As %String
{
	s LastRatio=1.0
	s SelSchuldRowid=0	
	s Info="",ServiceName="",LastInfo="" 
	s ^RTMP=Day_"^"_InChargeDate_"^"_InChargeTime_"^"_ServiceGroupId_"^"_LocId_"^"_OEorditem
	
	// 是否是奥抗病人
	s IsAK=..GetAokangPatient(OEorditem)

	i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)

    ; 按时间段索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
    s TPRowid=0 f  s TPRowid=$o(^DHCRBCTimePeriodSet(TPRowid)) q:TPRowid=""  d
    .s TimeDuration=$p(^DHCRBCTimePeriodSet(TPRowid),"^",1)
    .q:(LastInfo'="")
    .s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Date-Time-Res",LocId,Day,ServiceGroupId,TimeDuration,SchRowid)) q:SchRowid=""  d
    ..;q:(Info'="")
    ..s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1) 
    ..q:(RessourceID="")
    ..s BK=""
    ..s BK=..GetAppResParam(OEorditem,RessourceID)
    ..q:(BK="N")
 	..s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
	..i AutoUseNumber="" s AutoUseNumber=0
	..s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
	..s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	..s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	..q:(MaxNumber=0)!(MaxNumber="")
	..s UseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",9)  ;总的预约使用数量
	..i UseNumber="" s UseNumber=0 
	..i RemainNum="" s RemainNum=MaxNumber
	..s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	..i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	..s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	..s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	..s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
	..i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
	..s CurrentRatio=$fn(UseNumber/MaxNumber,"",3) ;占用比率=已使用数/最大预约数
	..s MaxRemainNumber=0
	..;w !,"Day="_$zd(Day,"3")_"--InChargeTime="_InChargeTime_"----"_"ChargeTime="_ChargeTime_"---"_"AutoRemainNum="_AutoRemainNum_"---"_"MaxRemainNumber="_MaxRemainNumber_"******"_SchRowid_"---"_CurrentRatio
	..i (Day=InChargeDate)&(ServiceName="CTA组")  d           ; 当天预约情况，判断缴费时间点，如果是下一天则不用判断
    ...i (InChargeTime<StartTime)&(AutoRemainNum>0)  d
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>0) d
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..else  i (Day=InChargeDate)&(ServiceName="CTB组")  d 
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>0) d 
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..else  d
	...;w !,"Day="_$zd(Day,"3")_"--InChargeTime="_InChargeTime_"----"_"ChargeTime="_ChargeTime_"---"_"AutoRemainNum="_AutoRemainNum_"---"_"MaxRemainNumber="_MaxRemainNumber_"******"_SchRowid_"---"_CurrentRatio
	...i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>0)) d 
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..;w !,"Day="_$zd(Day,"3")_"--InChargeTime="_InChargeTime_"----"_"ChargeTime="_ChargeTime_"---"_"AutoRemainNum="_AutoRemainNum_"******" //_SchRowid_"---"_CurrentRatio
	..if (Day>InChargeDate)&(IsAK'="Y")  d
	...i (AutoRemainNum>0) d    ; 下一个工作日的预约，只考虑限额
	....;w !,"Day="_$zd(Day,"3")_"--InChargeTime="_InChargeTime_"----"_"ChargeTime="_ChargeTime_"---"_"AutoRemainNum="_AutoRemainNum_"---"_"MaxRemainNumber="_MaxRemainNumber_"******"_SchRowid_"---"_CurrentRatio
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	....;w !,"Info="_Info_"&&&&&&&&&"
	..else  if (Day>InChargeDate)&(IsAK="Y") d
	...i (AutoRemainNum>0)  d
	....s Info=SchRowid_"^"_Day_"^"_EndTime
	..if (Info'="")&(CurrentRatio<=LastRatio) d
	...s LastRatio=CurrentRatio
	...s LastInfo=Info
	q LastInfo
}

/// 根据医嘱查询项目是否符合自动预约条件 Y/N
/// 入参:医嘱ID
/// 返回值:Y/N
/// w ##class(web.DHCRisBookParamZGYD).IsAutoBooked("20017||56")
ClassMethod IsAutoBooked(OrditemRowid As %String) As %String
{
	s IsAB="N"
	s arcimid="",BPRowid="",AppointMethodId="",AppMethod="",AppLocDR="",RessourceID=""
	s ServerGroupDR=""
	s FindCount=0
	s OrderRowid=$p($g(OrditemRowid),"||",1)
	s itemsub=$p($g(OrditemRowid),"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s AppLocDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",3)
	s ServerGroupDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
	q:(ServerGroupDR="") IsAB
	i arcimid'="" s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
	i BPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
    i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
    
    ;按申请科室查询可用资源
    &sql(select count(*) into :FindCount from DHCRBC_ResourceInAppLoc
	       where DRIL_AppLoc_DR=:AppLocDR And DRIL_ServiceGroup_DR=:ServerGroupDR)
	//w !,"ServerGroupDR="_ServerGroupDR
	i (AppMethod="自动预约")&(FindCount>0)&(ServerGroupDR'="") s IsAB="Y"
	q IsAB
}

/// w ##class(web.DHCRisBookParam).RequestBKDate("76984||4")
/// 功能:返回预约日期
ClassMethod RequestBKDate(InOrditemRowid As %String) As %String
{
	s BookedDR="",Flags="",BKDate="",ResSchduleID=""
	q:(OrditemRowid="") BKDate
	s BookedDR=$o(^DHCRBCResSchduleDetaili(0,InOrditemRowid,0))
	i BookedDR'="" d
	.s Flags=$p($g(^DHCRBCResSchduleDetail("Detail",BookedDR)),"^",7)
	.s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",BookedDR)),"^",2)
	
	i ((BookedDR'="")&(Flags'="Cancel")&(ResSchduleID'="")) d
	.s BKDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	q BKDate
}

/// s RET=##class(web.DHCRisBookParam).CancelBKbyRegDate("68631||412","")
/// 功能:当登记日期小于预约日期时取消预约释放资源
ClassMethod CancelBKbyRegDate(OrditemRowid As %String, InRegDate As %String) As %String
{
	
	s SQLCODE="100",GetBKDate=""
	
	s Count=$l(OrditemRowid,"@")
	for j=1:1:Count 
	{
	  s CanperOrditemRowid=$p(OrditemRowid,"@",j)
	  i CanperOrditemRowid'="" d
	  s GetBKDate=""
	  s GetBKDate=..RequestBKDate(CanperOrditemRowid)
	  
	  i (GetBKDate'="")&(InRegDate'="")&(InRegDate<GetBKDate)
	  {
	     s SQLCODE=##class(web.DHCRisResourceApptSchudleZGYD).CancelBookedInfo(CanperOrditemRowid)
	  }
	
	}
	;w !,"SQLCODE="_SQLCODE
	q SQLCODE
}

}
