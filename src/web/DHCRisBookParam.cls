Import SQLUser

Class web.DHCRisBookParam Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
/// 修改: 2014-12-26 sunyi
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryARCItemMastByCat","19","")
Query QueryARCItemMastByCat(OrdSubCatId As %String, InputOrdName As %String = "") As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String,AppointMethod:%String,InputFee:%String,Empty:%String,Location:%String,Memo:%String,AppointMethodId:%String,AppLocation:%String,Telephone:%String,ServiceGroupName:%String,ServiceGroupID:%String,Exclusion:%String,DMRowid:%String,UseTime:%String,IPRowid:%String,SetSer:%String,SetApp,AutoSendApp:%String,OrdBody:%String")
{
}

ClassMethod QueryARCItemMastByCatExecute(ByRef qHandle As %Binary, OrdSubCatId As %String, InputOrdName As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryARCItemMastByCat","235") 
 //^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version} 取指定子类下的医嘱项
 s ind=1 
 s CurrentDate=+$h
 Set repid=$I(^CacheTemp)
 s ^TMP111=OrdSubCatId_"^"_InputOrdName
 i (OrdSubCatId'="") d
 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip)) q:(Subscrip="")  d
 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip,Version)) q:(Version="")  d
 ...s ItemRowid=Subscrip_"||"_Version
 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
 ...s OrderOnItsOwn=$p(^ARCIM(Subscrip,Version,7),"^",13)  ;20160420  LEI
 ...q:(OrderOnItsOwn="N")   ;判断是否是独立医嘱，非独立过滤
 ...s StarDay=$p(^ARCIM(Subscrip,Version,1),"^",13)
 ...s StarDate=$p(StarDay,"Z",1)
 ...Q:(StarDate>CurrentDate)
 ...s EffDateTo=$p(^ARCIM(Subscrip,Version,7),"^",1)
 ...q:((EffDateTo'="")&&(EffDateTo<CurrentDate))   ;;判断医嘱截止日期是否填了，有截止日期的也需要过滤
 ...;s itemCode=$p(^ARCIM(Subscrip,Version,1),"^",1)
 ...;w !,ItemDesc_"*"_itemCode
 ...q:(InputOrdName'="")&&(ItemDesc'[InputOrdName) 
 ...;if $p(^ARCIM(Subscrip,Version,7),"^",6)="S" 
 ...Do OutItmMast
 e  d
 .i (InputOrdName'="") d
 ..s Subscrip=0 f  s Subscrip=$O(^ARCIM(Subscrip))  q:(Subscrip="")  d
 ...;w !,"Subscrip="_Subscrip
 ...s Version=0 f  s Version=$o(^ARCIM(Subscrip,Version))  q:(Version="")  d
 ....;w !,"Version="_Version
 ....s ItemRowid=Subscrip_"||"_Version
 ....;s OrderOnItsOwn=$p(^ARCIM(Subscrip,Version,7),"^",13)  ;20160420  LEI
 ....;s ServiceMed=$p(^ARCIM(Subscrip,Version,7),"^",6)   ;
 ....s ItemDesc=$p($g(^ARCIM(Subscrip,Version,1)),"^",2)
 ....s EffDateTo=$p(^ARCIM(Subscrip,Version,7),"^",1)
 ....q:(EffDateTo<CurrentDate)   ;;判断医嘱截止日期是否填了，有截止日期的也需要过滤
 ....;q:(OrderOnItsOwn="N")||(ServiceMed'="S")   ;判断是否是独立医嘱，非独立过滤  没有service标识过滤
 ....q:(InputOrdName'="")&&(ItemDesc'[InputOrdName) 
 ....Do OutItmMast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutItmMast
 s (AppointMethod,AppointMethodId,InputFee,Empty,Location,Memo,Exclusion,UseTime,SetService)=""
 ;s SetApp="编辑"
 s SetApp=""
 s OrdBody="关联部位"
 s IPRowid=$o(^DHCRBCItemBookProperTypei(ItemRowid,0)) 
 i IPRowid'="" d 
 .s AppointMethodId=$p(^DHCRBCItemBookProperty(IPRowid),"^",2)
 .//修复检查核医学报错
 .//2019/10/28
 .//hwb
 .i AppointMethodId '= "" s AppointMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)  
 .s InputFee=$p(^DHCRBCItemBookProperty(IPRowid),"^",3)
 .s Empty=$p(^DHCRBCItemBookProperty(IPRowid),"^",4)
 .s Location=$p(^DHCRBCItemBookProperty(IPRowid),"^",5)
 .s Telephone=$p(^DHCRBCItemBookProperty(IPRowid),"^",6)
 .s AppLocation=$p(^DHCRBCItemBookProperty(IPRowid),"^",7)
 .s Exclusion=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",8)
 .s UseTime=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",9)
 .s AutoSendApp=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",10)
 s SetService="关联服务组"
 s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ItemRowid,0))
 ;q:(DMRowid="")
 i DMRowid'="" d
 .s Memo=$p(^DHCRBApp("Memo",DMRowid),"^",2)
 s ServiceGroupId=$p(^ARCIM(Subscrip,Version,8),"^",7)
 s GroupName=""
 i ServiceGroupId'="" d
 .s GroupName=$p(^RBC("SG",ServiceGroupId),"^",2)

 set Data=$lb(ItemRowid,ItemDesc,AppointMethod,InputFee,Empty,Location,Memo,AppointMethodId,AppLocation,Telephone,GroupName,ServiceGroupId,Exclusion,DMRowid,UseTime,$g(IPRowid),SetService,SetApp,AutoSendApp,OrdBody)

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
/// 参数：var Info=ArcItemId+"^"+AppointMethodId+"^"+IsEmpty+"^"+InputFee+"^"+Location+"^"+Note;
/// 返回：SQLCODE
/// 作者：龚平
/// 日期：2011-08-17
ClassMethod UpdateItemInfo(Info As %String) As %String
{
	s ArcItemId=$p(Info,"^",1)
	s AppointMethodId=$p(Info,"^",2)
	s Empty=$p(Info,"^",3)
	s InputFee=$p(Info,"^",4)
	s Location=$p(Info,"^",5)
	s Note=$p(Info,"^",6)
	s AppLocation=$p(Info,"^",7)
	s Telphone=$p(Info,"^",8)
	s ServiceGroupId=$p(Info,"^",9)
	s Exclusion=$p($g(Info),"^",10)
	s UseTime=$p($g(Info),"^",11)
	
	s ^TMP0=Info
	q:ArcItemId="" 100
	
	s ItemBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,0))
	i ItemBPRowid'=""  d
	.&sql(Update DHCRBC_ItemBookProperty (DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIPB_AppLocation,DIPB_Telphone,DIPB_Exclusion,DIPB_Time) 
	   values(:AppointMethodId,:InputFee,:Empty,:Location,:AppLocation,:Telphone,:Exclusion,:UseTime) where DIBP_RowID=:ItemBPRowid)
	else  d
	.&sql(Insert into DHCRBC_ItemBookProperty (DIBP_AppointMethod_ID,DIBP_AutoInputFee,DIBP_IsEmpty,DIBP_Location,DIBP_ARCItmMast_DR,DIPB_AppLocation,DIPB_Telphone,DIPB_Exclusion,DIPB_Time) 
	   values(:AppointMethodId,:InputFee,:Empty,:Location,:ArcItemId,:AppLocation,:Telphone,:Exclusion,:UseTime))
	
	;插入备注信息（检查须知）   
	s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemId,0))
	if DMRowid'="" d
	.s $p(^DHCRBApp("Memo",DMRowid),"^",2)=Note
	.s SQLCODE="0"
	else  d 
	.&sql(insert into DHCRB_Memo(DM_ARCItmMast_DR) values (:ArcItemId))
	.s srowid=$p(%ROWID,$c(1))
	.i srowid'="" d
	..s $p(^DHCRBApp("Memo",srowid),"^",2)=Note
	
	;更新服务组信息
	i ServiceGroupId'="" d
	.&sql(update  ARC_ItmMast(ARCIM_ServiceGroup_DR) values (:ServiceGroupId) where  ARCIM_RowId=:ArcItemId)
	
	q SQLCODE
}

/// 函数：AutoBooked (协和)
/// 功能：自动预约，返回预约日期、时间以及注意事项 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）
/// 返回：(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点) flag-0:自动预约失败，1 自动预约成功   
/// BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
/// 作者：gongping 
/// 日期：2011-08-22 
/// s ret=##class(web.DHCRisBookParam).AutoBooked("20017||3877",+$h,$p($h,",",2),"","","","")
ClassMethod AutoBooked(OrditemRowid As %String, ChargeDate As %Integer, ChargeTime As %Integer, OherParam As %String = "", UserRowid As %String = "", GetEqDR As %String = "", InStudyNo As %String = "") As %String
{
   n (OrditemRowid,ChargeDate,ChargeTime,OherParam,UserRowid,GetEqDR)
   s ResInfo="",Info="",AddressInfo=""
   s BookedFlag=0
   s (ServiceName,GetResCode,GetResDesc,ArriveDate,ArriveTime,BookedNote,RecLocName)=""
   s (Paadmdr,PatType)=""
   s (AppMemo,rets,Location,AppLocation,InputFee,EQLocation,DetailRowid)=""
   s Desc="就诊",AutoInputFee="",EndInputFee="",hasBooked="",Param=""
   s (StudyNumber,IsUpdate,GroupDR,Upret,CAFlag,BKStudyNo)=""

   s ^t=OrditemRowid_"^"_ChargeDate_"^"_ChargeTime_"^"_OherParam_"^"_UserRowid_"^"_GetEqDR
   
   s OrderRowid=$p(OrditemRowid,"||",1)
   s ItemRowid=$p(OrditemRowid,"||",2)
   s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
   i Paadmdr'="" s PatType=$p($g(^PAADM(Paadmdr)),"^",2)
   s RecLocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)       ; 执行科室
   i RecLocId'="" d 
   .s RecLocName=$p(^CTLOC(RecLocId),"^",2)
   .i $l(RecLocName,"-")>1 s RecLocName=$p(RecLocName,"-",2)
   .s AddressInfo=..GetAddress(RecLocId)
   .i AddressInfo'="" d
   ..s Location=$p(AddressInfo,"^",1)   ; 科室的物理位置
   ..s AppLocation=$p(AddressInfo,"^",2)  ;预约位置
   ..s InputFee=$p(AddressInfo,"^",3)   ;划价位置

   s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
   s AutoInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",25) ;"需要另划价标志"
   s EndInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",26)  ;"已另划价标识"
   i (PatType="O")
   {
	  i ((AutoInputFee="Y")&((EndInputFee="")!(EndInputFee="N")))
	  {
	     s Desc="划价"
	  }    
   }
   
   s bookUseType="1"
   s locParamDr="",examTime=""
   ;根据科室rowid查询预约方式 1 为最大数 2为检查时间
   s locParamDr=$o(^DHCRBC("Loc",RecLocId,locParamDr))
   i locParamDr'="" s bookUseType=$p(^DHCRBC("LocParam",locParamDr),"^",23)
   ;检查时间预约根据医嘱查询检查需要时间
   ;if bookUseType="2" d
   ;.s examTime=##class(web.DHCRisResourceApptSchudleEx).getExamTime(OrditemRowid)
   
   
   
   s Subscript=$p(ItemMastRowid,"||",1)
   s Version=$p(ItemMastRowid,"||",2)
   
   s AppMemo=..GetAppMemo(ItemMastRowid)  ;N-提示到服务台打须知 
   ;s AppMemo="检查须知:"_AppMemo
   
   s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
   q:BPRowid="" "^0^^^^^系统没有设置预约信息,请联系信息中心$$^^^"
   
   s AppMethod="不需预约"
   
   ;s Location=$p(^DHCRBCItemBookProperty(BPRowid),"^",5)  ; 科室的物理位置
   ;s AppLocation=$p(^DHCRBCItemBookProperty(BPRowid),"^",7)  ; 预约位置 
   
   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
   i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
   ;w !,"AppMethod="_AppMethod
   i (AppMethod="不需预约")!(AppMethod="无需预约") d
   .s Info="3^1^^^^^请您立即到"_RecLocName_"做检查。$"_Location_"$"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation
   q:(AppMethod="不需预约")!(AppMethod="无需预约") Info
   
   s rets=..IsAutoBooked(OrditemRowid,PatType,AppMethod)
   ;w !,"rets="_rets
   if (rets="Y")
   {
	   s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0))
	   i (DetailRowid'="")
	   {   ;b //001
		   s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
		   if (CAFlag'="Cancel")
		   {
			   ;b //002
			   if ($d(^DHCRISTAUTOTEMP(OrditemRowid)))
			   {
				   b //003
				   s hasBooked=$g(^DHCRISTAUTOTEMP(OrditemRowid))
				   q hasBooked
			   }
			   else
			   {
				   q "1^0^^^^^[补打导诊单]项目预约信息,请到医技科室咨询$$^^^"
			   }
		   }
	   }
	   ;b //ok
	   //q
	   s ServiceGroupId=$p(^ARCIM(Subscript,Version,8),"^",7)
	   i ServiceGroupId'="" d
	   .s ServiceName=$p(^RBC("SG",ServiceGroupId),"^",2)
   
	   .i ServiceName="CTA组"   d 
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,"",RecLocId,OrditemRowid,$g(GetEqDR))   //返回可预约信息
	   .else  if (ServiceName="CTB组")  d
	   ..s ret=..GetEmpty(OrditemRowid)
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,ret,RecLocId,OrditemRowid,$g(GetEqDR))   //返回可预约信息
	   .else  d
	   ..; 其他的需要自动预约的项目
	   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,$g(ret),RecLocId,OrditemRowid,$g(GetEqDR),bookUseType)   //返回可预约信息
       ;w !,"ResInfo="_ResInfo
	   i ResInfo'="" d
	   .; 插入预约表 
	   .s SchRowid=$p(ResInfo,"^",1)
	   .s ArriveDate=$p(ResInfo,"^",2)
	   .s strArriveDate=$zd(ArriveDate,3)
	   .s ArriveTime=$p(ResInfo,"^",3)
	   .s strArriveTime=$zt(ArriveTime,1)
	   .s BookeInfo=OrditemRowid_"^"_SchRowid_"^2^"_OherParam
	   .s Param=##class(web.DHCRisResourceApptSchudleEx).InitAutoBookedData(SchRowid,OrditemRowid,ArriveDate,$g(InStudyNo))
	   .;w !,"Param="_Param
	   .i Param'="" d
	   ..s BKStudyNo=$p(Param,"^",1)
	   ..s GroupDR=$p(Param,"^",6)
	   ..s StudyNumber=$p(Param,"^",11) 
	   ..s IsUpdate=$p(Param,"^",12)
	   ..s BookeInfo=BookeInfo_"^"_$p($g(Param),"^",1,10)_"^"_UserRowid_"^"_$g(InStudyNo)
	   .i Param'="" d
	   ..s SQLCODEInfo=##class(web.DHCRisResourceApptSchudleEx).InsertBookedInfo(BookeInfo)
	   ..;w !,"SQLCODEInfo="_SQLCODEInfo
	   ..s SQLCODE=$p(SQLCODEInfo,"^",1)
	   .i SQLCODE=0  D
	   ..i bookUseType="2" d  ;按检查时间预约需要查询出开始时间
	   ...s scheduleDetailDr=""
	   ...s scheduleDetailDr=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,scheduleDetailDr))
	   ...i scheduleDetailDr'="" d
	   ....s strArriveTime=$zt($p(^DHCRBCResSchduleDetail("Detail",scheduleDetailDr),"^",18),1)
	   ..i IsUpdate="1" d
	   ...s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(RecLocId, GroupDR, StudyNumber,strArriveDate)
	   ..s resourceId=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
	   ..i resourceId'="" d
	   ...s EQLocation=..GetEqAddress(resourceId)
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
	   ..s BookedNote=..GetBookNote(ArriveDate,strArriveTime,ServiceName,ItemMastRowid, RecLocName,ChargeDate,strArriveDate,RecLocId,Desc)
	   ..s Info="1"_"^"_BookedFlag_"^"_GetResCode_"^"_GetResDesc_"^"_strArriveDate_"^"_strArriveTime_"^"_BookedNote_"^"_AppMemo_"^"_InputFee_"^"_EQLocation
	   ..s ^DHCRISTAUTOTEMP(OrditemRowid)=Info
	   .else  d
	   ..s Info="1^0^^^^^请您到"_RecLocName_Desc_"。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation
	   else  d
	   .s Info="1^0^^^^^请您到"_RecLocName_"服务台预约_。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation
  }
   else
   {
	   if Desc'="划价" s Desc="预约"
	  ; 其他的预约方式 都是通过服务台预约的方式
	  s Info="2^1^^^^^请您到"_RecLocName_Desc_"。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation
   
   }
   q Info
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPan(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, Empty As %String, LocId As %String, OeorditemRowid As %String = "", GetEqDR As %String = "", bookUseType As %String = "1") As %String
{
		
	s bFind=0
	s Day=ChargeDate
	s UseResInfo=""
	s ServiceName=""
	
	i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
    .;w !,ServiceName
    i (Empty'="Y")&(ServiceName="CTB组") d            ; 未空腹的CTB组第二天进行预约
    .s Day=Day+1  
   
	//查找可使用的预约资源
	while(bFind<1)
	{	
	    ;w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
		s UseResInfo=..GetDayUseBookInfo(Day,ChargeDate,ChargeTime,ServiceGroupId,LocId,OeorditemRowid,GetEqDR,bookUseType)
		;w !,"UseResInfo"_UseResInfo
		if (UseResInfo="")
		{
		    s Day=Day+1
		    i (Day-ChargeDate)>50  s bFind=1   ;如果超过50天没有，可能是系统没有设置排版，则退出循环
		   
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
ClassMethod GetEmpty(OrditemRowid) As %String
{
	s Empty="N"
	s AppRowid=$o(^DHCRBAppOrdi(0,OrditemRowid,0))
	i AppRowid'="" d
	.s ItemInfo=^DHCRBApp("Bill",AppRowid,"ItemInfo")
	.s count=$l(ItemInfo,"^")
	.for i=1:count:1 d
	..s pItemInfo=$p(ItemInfo,"^",i)
	..s ItemName=$p(pItemInfo,$c(2),1)  
	..s ItemResult=$p(pItemInfo,$c(2),2)
	..i (ItemName="空腹")!(ItemName="是否空腹")  d
	...i ItemResult="是"  s Empty="Y"
	q Empty
}

/// 函数：GetDayUseBookNum
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetDayUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "", GetEqDR As %String = "", bookUseType As %String = "1") As %String
{
	s MaxRemainNumber=0    ; 最大的剩余数
	s SelSchuldRowid=0
	
	s Info="",ServiceName=""
	s CurrentTime=$p($h,",",2)
	s CurrentDate=+$h
	
	// 是否是奥抗病人
	s IsAK=..GetAokangPatient(OEorditem)    
       
	i ServiceGroupId'="" d
    .s ServiceName=$p(^RBC("SG",ServiceGroupId),"^",2)

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
	..q:(GetEqDR'="")&(GetEqDR'=RessourceID)
	..s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	..s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	..q:((Day=CurrentDate)&(EndTime<CurrentTime))   ;当天需要判断当前时间
	..i bookUseType="2" d  ;检查时间预约
	...s remainTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",18)
	...i remainTime>0 d
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..e  d   ;最大数预约
 	...s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
	...i AutoUseNumber="" s AutoUseNumber=0
	...s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
	...q:(AutoNumber="0")
	...s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	...s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	...i (RemainNum="")!(RemainNum=0) s RemainNum=MaxNumber
	...s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	...i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	...s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
	...i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
	...i (Day=InChargeDate)&(ServiceName="CTA组")  d           ; 当天预约情况，判断缴费时间点，如果是下一天则不用判断
    ....i (InChargeTime<StartTime)&(AutoRemainNum>MaxRemainNumber)  d
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime
	....i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	...else  i (Day=InChargeDate)&(ServiceName="CTB组")  d 
	....i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d 
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	...else  d
	....i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber)) d 
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	...if (Day>InChargeDate)&(IsAK'="Y")  d
	....i (AutoRemainNum>MaxRemainNumber) d    ; 下一个工作日的预约，只考虑限额
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime
	...else  if (Day>InChargeDate)&(IsAK="Y") d
	....i (AutoRemainNum>0)  d
	.....s MaxRemainNumber=AutoRemainNum
	.....s Info=SchRowid_"^"_Day_"^"_StartTime  //EndTime

	.; 找到这个时间段的最大剩余的资源，且不是奥抗阳性的病人则退出，否则取最后一个可以预约的时间段
	.i (MaxRemainNumber>0)&(IsAK'="Y") d 
	..s TPRowid=100

	q Info
}

ClassMethod GetBookNote(ArriveDate As %String, ArriveTime As %String, ServiceName As %String, ItemMastRowid As %String, RecLocName As %String, ChargeDate As %String, strArriveDate As %String, RecLocId As %String = "", Desc As %String = "") As %String
{

   s Info="",Address="",AppLocation=""
   s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
   s FsDesc="等候报到"
   
   i (Desc'="划价") s Desc=FsDesc
   i RecLocId'="" d
   .s Address=..GetAddress(RecLocId)
   .i Address'="" d
   ..s Location=$p(Address,"^",1)   ; 科室的物理位置
   ..s AppLocation=$p(Address,"^",2)  ;预约位置
   ..s InputFee=$p(Address,"^",3)   ;划价位置 
   
   if ServiceName="CTB组" d
    .i (ChargeDate=ArriveDate) d
    ..s Info="请您空腹今天"_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
    .else  d
    ..s Info="请您需要空腹(或者至少空腹四小时),并于"_strArriveDate_" "_ArriveTime_"到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
   else  d
     .i (ChargeDate=ArriveDate) d
     ..s Info="请您今天"_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
     .else  d 
     ..s Info="请您"_strArriveDate_" "_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
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
Query QueryBookTimeDuration(TimeCode As %String, FindNotAvail As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargTime:%String,NotAvailable:%String")
{
}

ClassMethod QueryBookTimeDurationExecute(ByRef qHandle As %Binary, TimeCode As %String, FindNotAvail As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryBookTimeDuration")=TimeCode_"^"_FindNotAvail
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
 ;s isAvailable="Y"
 s NotAvailable=$p(^DHCRBCTimePeriodSet(TimeRowid),"^",6)
 q:((NotAvailable="Y")&&(FindNotAvail'="Y"))
 
 set Data=$lb(TimeRowid,TimeCode,TimeDesc,StartTime,EndTime,EndChargeTime,NotAvailable)
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
	s ^DHCRis("TempTime")=Info
	s Rowid=$p(Info,"^",1)
	s Code=$p(Info,"^",2)
	s Desc=$p(Info,"^",3)
	s StartTime=$p(Info,"^",4)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(Info,"^",5)
	s EndTime=$zth(EndTime,3)
	s ChargTime=$p(Info,"^",6)
	if (ChargTime'="")
	{
    	s ChargTime=$zth(ChargTime,3)
	}
	s notAvail=$p(Info,"^",7)
	
	q:(Code="") "200"
	s isCodeSame="N"
	//查找code是否存在
	s timeRowidGet="" f  s timeRowidGet=$o(^DHCRBCTimePeriodSeti("Code",Code,timeRowidGet)) q:(timeRowidGet="")  d
	.s codeGet=$p(^DHCRBCTimePeriodSet(timeRowidGet),"^",1)
	.i ((Rowid="")||(Rowid'=timeRowidGet)) d
	..s isCodeSame="Y"

	q:(isCodeSame="Y") "300"
	/*
    s bWrite=0
    &sql(select count(*) into:bWrite from DHCRBC_TimePeriodSet where (DTPS_Code=:Code and DTPS_Desc=:Desc))
    
    i (Rowid="")&(bWrite=0) d
    . &sql(insert into DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime )
         values ( :Code,:Desc,:StartTime,:EndTime,:ChargTime))
    else  d
    .&sql(update DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime )
         values (:Code,:Desc,:StartTime,:EndTime,:ChargTime) where DTPS_Rowid=:Rowid)
    */
   
         
    i (Rowid="") d 
    . &sql(insert into DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime ,DTPS_NotAvailable)
         values ( :Code,:Desc,:StartTime,:EndTime,:ChargTime,:notAvail))
    else  d
    .&sql(update DHCRBC_TimePeriodSet(DTPS_Code,DTPS_Desc,DTPS_StartTime,DTPS_EndTime,DTPS_EndChargeTime,DTPS_NotAvailable )
         values (:Code,:Desc,:StartTime,:EndTime,:ChargTime,:notAvail) where DTPS_Rowid=:Rowid)
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
	.e  s SQLCODE="400"
	q SQLCODE
}

// 查找此时间段是否被使用

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

/// 清理预约数据
/// w ##class(web.DHCRisBookParam).ClearAppointmentData()
ClassMethod ClearAppointmentData()
{
	//系统配置
	//&sql(delete from DHCRBC_TimePeriodSet)
    //&sql(delete from DHCRBC_ResPlan)
    //&sql(delete from DHCRBC_ResSchdule)
    
    //业务数据
    &sql(delete from DHCRBC_ResSchduleDetail)
    
    q SQLCODE
}

// do ##class(web.DHCRisBookParam).ClearRISAppData()

ClassMethod ClearRISAppData()
{
  //系统配置
  //&sql(delete from DHCRBC_TimePeriodSet)
  //&sql(delete from DHCRBC_ResPlan)
  //&sql(delete from DHCRBC_ResSchdule)
    
  //业务数据
  &sql(delete from DHCRBC_ResSchduleDetail)
  &sql(delete from DHCRB_RegInfo_BodyParts)
  &sql(delete from DHCRB_RegInfo)
  &sql(delete from DHCRB_Report)
  &sql(delete from DHCRB_Report_Unit)
  &sql(delete from DHCRB_Report_Files)
  &sql(delete from DHCRB_ReturnFee)
  &sql(delete from DHCRB_CallQueue)
  
  //申请单表
  &sql(delete from DHCRB_ApplicationBill_OrdItem)
  k ^DHCRBAppOrd
  k ^DHCRBAppOrdi
  &sql(delete from DHCRB_ApplicationBill)
  &sql(delete from DHCRB_RejectApplication)
  
  //申请检查目的表
  &sql(delete from DHCRBC_Goal)
  
  //病人病情表
  &sql(delete from DHCRBC_IllStatus)
  
  //外部预约表
  &sql(delete from DHCRBC_ExternalBookInfo)
  
  //发送申请单时存放信息变量
  k ^DHCRISAPPINFOS("APPLICATIONBILL")
  
  //获取检查号变量 
  k ^DHCRISSTUDYINFOTMEP
  
  //RISService接口存放信息变量
  k ^DHCRISBOOKEDINFO
  
  //预约流水号
  //(天)
  k ^DHCRisLocBookIndex
  k ^DHCRisBookRoomIndex
  k ^DHCRisBookGroupIndex
  //(预约保留号-天)
  k ^DHCRisBookLocCancel
  k ^DHCRisBookRoomCancel
  k ^DHCRisBookGroupCancel
  //(时段)
  k ^DHCRisResLocBKIndex
  k ^DHCRisResBookRoomIndex
  k ^DHCRisResBookGroupIndex
  //(预约保留号-时段)
  k ^DHCRisBookTimeLocCancel
  k ^DHCRisBookTimeRoomCancel
  k ^DHCRisBookTimeGroupCancel
  
  //登记流水号
  k ^DHCRisRegIndex
  k ^DHCRisCheckRoomIndex
  k ^DHCRisCheckGroupIndex
  
  q SQLCODE
}

/// 以下函数为协和修改
/// w ##class(web.DHCRisBookParam).IsAutoBooked("8476||6","O","自动预约")
ClassMethod IsAutoBooked(OrditemRowid As %String, PatType As %String, AppMethod As %String) As %String
{
	s IsAB="Y"
	s HopeDate="",Doctor="", Info="",AutoInputFee="",EndInputFee=""
	
	s OrderRowid=$p($g(OrditemRowid),"||",1)
	s itemsub=$p($g(OrditemRowid),"||",2)
	
	s AutoInputFee=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",25) ;"需要另划价标志"
    s EndInputFee=$P($g(^OEORD(OrderRowid,"I",itemsub,"DHC")),"^",26)  ;"已另划价标识"
	s Info=$g(^DHCRISAPPINFOS("APPLICATIONBILL",OrditemRowid))
	
	i Info'="" d
	.s Doctor=$p($g(Info),"^",1)
	.s HopeDate=$p($g(Info),"^",3)
	
	i (AppMethod'="自动预约")
	{
		s IsAB="N"
	} 
	/*else
	{
		//if ((PatType="I")!(PatType="E"))
		if (PatType="E")
		{
		  s IsAB="N"
		}
		/*if ((Doctor'="")&(HopeDate'=""))
		{
		  s IsAB="N"
		}*/
	/*}*/
	
	/*i (PatType="O")&(AutoInputFee="Y")&(EndInputFee="Y")
	{
	   s IsAB="N"
	}*/
	
	q IsAB
}

/// do ##class(web.DHCRisBookParam).GetAddress("632")
ClassMethod GetAddress(LocDR As %String) As %String
{
	q:(LocDR="") ""
	
	s (Location ,AppLocation,InputFee,Rowid)=""
	s (Info)=""
	
	s Rowid=$o(^DHCRBCLocationi("Rec-LocDR",LocDR,0))
	i Rowid'="" d
	.s Location=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",2)
    .s AppLocation=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",3)
    .s InputFee=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",4)
    .s Info=Location_"^"_AppLocation_"^"_InputFee
    
    q Info
}

ClassMethod GetEqAddress(resourceId As %String) As %String
{
	s RoomID="",RoomDesc=""
	s EqRowid=$p($g(^RB("RES",resourceId)),"^",3)
	i (EqRowid'="")
	{
		s RoomID=$o(^DHCRBC("EQDR-ROOM",EqRowid,RoomID))
		i RoomID'="" d
		.s RoomDesc= $p($g(^DHCRBC("Room",RoomID)),"^",2)
	}
	
	q RoomDesc
}

ClassMethod GetAppMemo(ArcItemRowid As %String) As %String
{
	s Memo="",DMRowid="",UMCode=""
	s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemRowid,0))
	i DMRowid'="" d
	.s MTRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",4)
	.q:(MTRowid="")
	.s UMRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",5)
	.i (UMRowid'="") d
	..s UMCode=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",1)
	..i UMCode="NP" d
	...s Memo="到综合服务台拿检查须知"
	..e  d
	...i MTRowid'="" s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	q Memo
}

/// 对于门诊病人医嘱没有发送申请单不允许预约
/// sunyi 2012-091-01
/// w ##class(web.DHCRisBookParam).IsSendApp("9517||20")
ClassMethod IsSendApp(OrditemRowid As %String) As %String
{
   s IsSend="Y"
   s Paadmdr="",PatType="",AppRowid=""
   
   s OrderRowid=$p($g(OrditemRowid),"||",1)
   s ItemRowid=$p($g(OrditemRowid),"||",2)
   
   s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
   i Paadmdr'="" d 
   .s PatType=$p($g(^PAADM(Paadmdr)),"^",2)
   
   i (PatType="O")
   {
	   s AppRowid=$o(^DHCRBAppi("OrdRowid",OrditemRowid,0)) 
       i AppRowid=""  s IsSend="N"
   }
   
   q IsSend
}

///  对于门诊病人医嘱没有收费不允许预约
/// w ##class(web.DHCRisBookParam).AllowBookedNotPaid("11847||65")
ClassMethod AllowBookedNotPaid(OrditemRowid As %String) As %String
{
   s Allow="Y",billed="",AutoInputFee="",EndInputFee=""
   s PatType=""
   s OrderRowid=$p($g(OrditemRowid),"||",1)
   s ItemRowid=$p($g(OrditemRowid),"||",2) 
   
   i (OrderRowid'="")&(ItemRowid'="")
   {
	   s AutoInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",25) ;"需要另划价标志"
	   s EndInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",26)  ;"已另划价标识"
   }
   
   s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
   i Paadmdr'="" s PatType=$p($g(^PAADM(Paadmdr)),"^",2)
    
   i (PatType="O")
   {
	   i ((AutoInputFee="Y")&((EndInputFee="")!(EndInputFee="N")))
	   {
		    s Allow="N"
	   }
	   else
	   {
		    s billed=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",5)
	        i billed="P" d
	        .s Allow="Y"
	        e  d
	        .s Allow="N"
	   }
	   
   }  
    
   q Allow
}

/// do ##class(web.DHCRisBookParam).SetAutoBooked("73754||285")
ClassMethod GetAutoBooked(OrditemRowid As %String) As %String
{
	s (AppointMethodId,AppMethod,OrderRowid,ItemRowid,ItemMastRowid,Subscript,Version)=""
	s (ServiceGroupId,RecLocId,value,ArriveDate,strArriveTime)=""
	
	s ChargeDate=+$h
	s ChargeTime=$p($h,",",2)
	
	s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    
    s ItemMastRowid=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
    q:(ItemMastRowid="")
    s Subscript=$p(ItemMastRowid,"||",1)
    s Version=$p(ItemMastRowid,"||",2)
    s RecLocId=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)       ; 执行科室
	
	s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
	q:(BPRowid="")
	
    s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
    i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
    
    if (AppMethod="自动预约") 
    {
	     s ResInfo=""
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

/// w ##class(web.DHCRisBookParam).IsBK("76984||4")
/// 功能:是否预约
/// 返回值: 是:Y  否:N
ClassMethod IsBK(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") "N"
	
	s BookedDR="",Flags=""
	s BookedDR=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0))
	i BookedDR'="" s Flags=$p($g(^DHCRBCResSchduleDetail("Detail",BookedDR)),"^",7)
	q:((BookedDR'="")&(Flags'="Cancel")) "Y"
}

/// s RET=##class(web.DHCRisBookParam).CancelBKInterface("68631||412")
ClassMethod CancelBKInterface(OrditemRowid As %String) As %String
{
	
	s SQLCODE="100",BK=""
	
	s Count=$l(OrditemRowid,"^")
	for i=1:1:Count 
	{
	  s perOrditemRowid=$p(OrditemRowid,"^",i)
	  i perOrditemRowid'="" d
	  s BK=..IsBK(perOrditemRowid)
	  
	  i (BK="Y")
	  {
	     s SQLCODE=##class(web.DHCRisResourceApptSchudleEx).CancelBookedInfo(perOrditemRowid)
	  }
	
	}
	q SQLCODE
}

// 入参说明: InOrditemRowid--医嘱ID 3||4

///           InChargeDate--预约日期 63214
///           InChargeTime--预约时间 40884
///           InOherParam--可为空
///           InUserRowid--ss_user id 
///           InGetEqDR--资源ID RB_Resource Id
/// s Result=##class(web.DHCRisBookParam).BKInterface("20017||3870",+$h,$p($h,",",2),"","687","1383")
/// s Result=##class(web.DHCRisBookParam).BKInterface("577||4@577||5","63227" ,"43288","","462","2194","U20140208001")
/// s Result=##class(web.DHCRisBookParam).BKInterface("20017||3890@20017||3891","63228","43288","","687","1383","U20140210001")
ClassMethod BKInterface(InOrditemRowid As %String, InChargeDate As %Integer, InChargeTime As %Integer, InOherParam As %String = "", InUserRowid As %String = "", InGetEqDR As %String = "", InStudyNo As %String = "") As %String
{
	     
	 s Result="",DeRowid="",Flag=""
     s perOrditemRowid=$p($g(InOrditemRowid),"@",1)
	 s DeRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
	 i DeRowid'="" s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DeRowid)),"^",7)
     i ((DeRowid="")!(Flag="Cancel"))
     {
       s Result=..InsertBKInterface(InOrditemRowid,InChargeDate,InChargeTime,InOherParam,InUserRowid,InGetEqDR,InStudyNo)
     }
     else
     {
       s Result=..ReBkInterface(InOrditemRowid,InChargeDate,InChargeTime,InOherParam,InUserRowid,InGetEqDR,InStudyNo)
     }
     
     q Result
}

/// s RET=##class(web.DHCRisBookParam).InsertBKInterface("323||61^63211^59044^^687^918")
/// 返回值: 0--预约成功  -1 --失败 
///         NSET--没有配置医嘱预约方式-001  NBK--不需预约医嘱-002
///         NSER--医嘱没有配置服务组-003    EXIST--已预约不能重复预约-004  
///         NORDID-没有医嘱ID-005           NRES--没有可预约资源-006
ClassMethod InsertBKInterface(InOrditemRowid As %String, InChargeDate As %Integer, InChargeTime As %Integer, InOherParam As %String = "", InUserRowid As %String = "", InGetEqDR As %String = "", InStudyNo As %String = "") As %String
{
	 //Set $ZT="ERROR"
     s perOrditemRowid=$p(InOrditemRowid,"@",1)
  
	 s (OrderRowid,ItemRowid,Paadmdr,ItemMastRowid,AppointMethodId,AppMethod,ServiceGroupId)=""
	 s (Subscript,Version,DetailRowid,CAFlag,UseResInfo,LocId,BPRowid)=""
	 s (SchRowid,ArriveDate,ArriveTime,BookeInfo,BkType,Param)=""
	 s SQLCODE="-1"
 
	 i (perOrditemRowid="")  s SQLCODE="-005"
     q:(perOrditemRowid="") SQLCODE
 
	 s OrderRowid=$p(perOrditemRowid,"||",1)
     s ItemRowid=$p(perOrditemRowid,"||",2)
     s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)

     s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
     s LocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)
     s Subscript=$p(ItemMastRowid,"||",1)
     s Version=$p(ItemMastRowid,"||",2)
 
     s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
     i BPRowid="" s SQLCODE="-001"
	 q:(BPRowid="") SQLCODE
	 
 
     s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
     i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
     i ((AppMethod="不需预约")!(AppMethod="无需预约")) s SQLCODE="-002"
	 q:(SQLCODE="-002") SQLCODE
	 

     s ServiceGroupId=$p(^ARCIM(Subscript,Version,8),"^",7)
     i (ServiceGroupId="") s SQLCODE="-003"
	 q:(ServiceGroupId="") SQLCODE
	 
 
     s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
     i DetailRowid'="" s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
	 i ((DetailRowid'="")&(CAFlag'="Cancel")) s SQLCODE="-004"
	 q:(SQLCODE="-004") SQLCODE
	 

     if (AppMethod="自动预约")
     {
	     s UseResInfo=..GetDayUseBookInfo(InChargeDate,InChargeDate,InChargeTime,ServiceGroupId,LocId,perOrditemRowid,InGetEqDR)
	     s BkType="2"
	 }else
	 {
		 s UseResInfo=..GetDayLocBKUseInfo(InChargeDate,InChargeDate,InChargeTime,ServiceGroupId,LocId,perOrditemRowid,InGetEqDR)
		 s BkType="1"
	 }
 
	 i (UseResInfo="") s SQLCODE="-006"
	 q:(UseResInfo="") SQLCODE
	
     //TSTART
     
	 s SchRowid=$p(UseResInfo,"^",1)
	 s ArriveDate=$p(UseResInfo,"^",2)
	 s strArriveDate=$zd(ArriveDate,3)
	 s ArriveTime=$p(UseResInfo,"^",3)
	 s strArriveTime=$zt(ArriveTime,1)
	 s BookeInfo=InOrditemRowid_"^"_SchRowid_"^"_BkType_"^"_InOherParam
     
	 s Param=##class(web.DHCRisResourceApptSchudleEx).InitAutoBookedData(SchRowid,perOrditemRowid,ArriveDate,InStudyNo)
	 i Param'="" d
	 .s BKStudyNo=$p(Param,"^",1)
	 .s GroupDR=$p(Param,"^",6)
	 .s StudyNumber=$p(Param,"^",11) 
	 .s IsUpdate=$p(Param,"^",12)
	 .s BookeInfo=BookeInfo_"^"_$p($g(Param),"^",1,10)_"^"_InUserRowid_"^"_InStudyNo
	 s SQLCODEInfo=""
	 i Param'="" d 
	 .s SQLCODEInfo=##class(web.DHCRisResourceApptSchudleEx).InsertBookedInfo(BookeInfo)
	 .s SQLCODE=$p(SQLCODEInfo,"^",1)
	 i SQLCODE=0  d
	 .i IsUpdate="1" d
	 ..s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(LocId, GroupDR, StudyNumber,strArriveDate)
	 
	 /*I SQLCODE TRollback  
     I SQLCODE q 
     TCOMMIT*/
   
     //w !,"SQLCODE="_SQLCODE
	 q SQLCODE
 /*ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE*/
}

ClassMethod GetDayLocBKUseInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "", GetEqDR As %String = "")
{
	 ; 按时间段索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
	s Info=""
	
	s CurrentTime=$p($h,",",2)
	s CurrentDate=+$h
	
    s TPRowid=0 f  s TPRowid=$o(^DHCRBCTimePeriodSet(TPRowid)) q:TPRowid=""  d
    .s TimeDuration=$p(^DHCRBCTimePeriodSet(TPRowid),"^",1)
    .q:(Info'="")
    .s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Date-Time-Res",LocId,Day,ServiceGroupId,TimeDuration,SchRowid)) q:SchRowid=""  d
    ..q:(Info'="")
	..s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
	..q:(GetEqDR'="")&(GetEqDR'=RessourceID)
	..;w !,"SchRowid="_SchRowid
	..s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	..s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	..i (RemainNum="")!(RemainNum=0) s RemainNum=MaxNumber
	..s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	..i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	..s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	..s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	..q:((Day=CurrentDate)&(EndTime<CurrentTime))
    ..i (Day=InChargeDate)&(InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(RemainNum'=0) d
    ...s Info=SchRowid_"^"_Day_"^"_StartTime

	q Info
}

/// test
/// s RET=##class(web.DHCRisBookParam).ReBkInterface("20017||3874",+$h,$p($h,",",2),"DTPACS","687","1383")
/// s RET=##class(web.DHCRisBookParam).ReBkInterface("20017||3857","63165","47954","DTPACS","687","1383")
/// s RET=##class(web.DHCRisBookParam).ReBkInterface("323||61","63211","59044","","687","918")
/// 函数：ReBkInterface 重预约
/// InGetEqDR : RB_Rource Id 
ClassMethod ReBkInterface(InOrditemRowid As %String, InChargeDate As %Integer, InChargeTime As %Integer, InOherParam As %String = "", InUserRowid As %String = "", InGetEqDR As %String = "", InStudyNo As %String = "") As %String
{
   s perOrditemRowid=$p(InOrditemRowid,"@",1)
   q:(perOrditemRowid="") "-005"
   
   s (ResDetailRowid,Date,ResSchduleID,ItemMastRowid,LocId)=""
   s (OrderRowid,ItemRowid,ServiceGroupId,ItemMastRowid,UseResInfo)=""
   s (GetSchduleID,ArriveDate,Upret,strArriveDate,Param)=""
  
   s (BKStudyNo,GroupDR,StudyNumber,IsUpdate,Index,GroupIndex)=""
   s (RoomIndex,GetRoomDR,GetTypeRowid,StudyNumber,paadmdr)=""
   s UseInfo="",UpType="",AppDateType=""
   
   Set $ZT="ERROR"	
   TSTART
   s SQLCODE=100
   
   s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
   s OrderRowid=$p(perOrditemRowid,"||",1)
   s ItemRowid=$p(perOrditemRowid,"||",2)
   s LocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6) 
   
   i ResDetailRowid'="" d
   .s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
   .i ResSchduleID'=""  s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2) 
   i ((InChargeDate<Date)&(InChargeDate'=""))
   {
      s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
      s ServiceGroupId=$p(^ARCIM($p(ItemMastRowid,"||",1),$p(ItemMastRowid,"||",2),8),"^",7)
      s UseResInfo=..GetDayLocBKUseInfo(InChargeDate,InChargeDate,InChargeTime,ServiceGroupId,LocId,perOrditemRowid,InGetEqDR)
   }
   //b //001
   i UseResInfo'=""
   {
	   //b //002
	   s GetSchduleID=$p(UseResInfo,"^",1)
	   s ArriveDate=$p(UseResInfo,"^",2)
	   s strArriveDate=$zd(ArriveDate,3)
	   i (GetSchduleID'="")
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
		  
	      s Param=..InitData(GetSchduleID,perOrditemRowid,ArriveDate,InStudyNo)
	      
	      q:(Param="") "-003" 
	      s OperateDate=+$h
	      s OperateTime=$p($h,",",2)
	      s BKStudyNo=$p(Param,"^",1)
	      s Index=$p(Param,"^",2)
	      s GroupIndex=$p(Param,"^",3)
	      s RoomIndex=$p(Param,"^",4)
	      s GetEQDR=$p(Param,"^",5)
	      s GroupDR=$p(Param,"^",6)
	      s GetRoomDR=$p(Param,"^",7)
	      s paadmdr=$p(Param,"^",8)
	      s GetTypeRowid=$p(Param,"^",9)
	      s StudyNumber=$p(Param,"^",11)
	      //b //003
		  s UseInfo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(LocId)
		
		  i (UseInfo'="")
		  {
			 s UpType=$p(UseInfo,"^",1)
			 s AppDateType=$p(UseInfo,"^",2)
		  }
		  if (UpType="I")
		  {
			  s RoomIndex=""
			  s GroupIndex=""
			  s Index=""
		  } 
		  
		  s value=""
		  s value=Index_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDR_"^"_GetRoomDR_"^"_AppDateType_"^"_strArriveDate
		
	      s IsUpdate=$p(Param,"^",12)
	      i IsUpdate="1" s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(LocId,GroupDR,StudyNumber,strArriveDate)
	      i (UpType="B")&(InStudyNo="")  do ##class(web.DHCRisPatRegisterDoEx).UpdateIndexcls(LocId,value,GetSchduleID)
	               
	      s NewUseNumber=$p($g(^DHCRBCResourceSchdule(GetSchduleID)),"^",9)
	      i NewUseNumber="" s NewUseNumber=0 
	      s MaxNumber=$p($g(^DHCRBCResourceSchdule(GetSchduleID)),"^",7)
	      s NewRemainNumber=$p($g(^DHCRBCResourceSchdule(GetSchduleID)),"^",10)
	      i NewRemainNumber="" s NewRemainNumber=MaxNumber
	      //b //004
	      i (NewRemainNumber'=0)
	      {   b //005
		      s NewUseNumber=NewUseNumber+1
		      s NewRemainNumber=NewRemainNumber-1
		      s $p(^DHCRBCResourceSchdule(GetSchduleID),"^",9)=NewUseNumber
		      s $p(^DHCRBCResourceSchdule(GetSchduleID),"^",10)=NewRemainNumber
		      
		      s Counts=$l(InOrditemRowid,"@")
		      //w !,"Counts="_Counts
		      for j=1:1:Counts 
              {
	  
                s perOrdItmRowid=$p(InOrditemRowid,"@",j)
		        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time)
		                           values (:GetSchduleID,:paadmdr,:BKStudyNo,:Index,:GroupIndex,:RoomIndex,'Booked',:GetEQDR,:GroupDR,:GetRoomDR,:GetTypeRowid,:InUserRowid,:OperateDate,:OperateTime) where  DRPD_OrderItem_ID=:perOrdItmRowid)       
              }           
	      } 
	      I SQLCODE TRollback  
          I SQLCODE q 
  	      TCOMMIT                   
	   }
   }
   
    q SQLCODE //_"^"_BKStudyNo
    
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE //_"^"_BKStudyNo
}

/// w ##class(web.DHCRisBookParam).InitData("5037","58460||1782","63042")
ClassMethod InitData(SchudleRowid As %String, oeorditemrowid, SelectDate As %String = "", InStudyNo As %String = "") As %String
{
	s (Infos,ResourcesInfo,GetEQDR,GetRoomDR,GroupDescDR,GetResDesc,GetRoomDesc,GroupDesc)=""
	s (IndexclsInfo,GetLocDR,Param,GetIndex,GetNoRuleCode,GetTypeDesc,GetAppDateType,GetTypeRowid)=""
	s (Index,GroupIndex,RoomIndex,paadmdr,IsCStudyNo,IsCIndex,StudyNo)=""
	s (StudyInfo,IsUpdate,StudyNumber)=""
	
	q:(SchudleRowid="") Infos
	q:(oeorditemrowid="") Infos
	
	
	i SelectDate="" s SelectDate=+$h
	s SelectDate=$zd(SelectDate,"3")
  
	s ResourcesInfo=##class(web.DHCRisResourceApptSchudleEx).SetSelResources(SchudleRowid)
	i ResourcesInfo'="" d
	.s GetEQDR=$p($g(ResourcesInfo),"^",1)
	.s GetRoomDR=$p($g(ResourcesInfo),"^",2)
	.s GroupDescDR=$p($g(ResourcesInfo),"^",3)
	.s GetResDesc=$p($g(ResourcesInfo),"^",4)
	.s GetRoomDesc=$p($g(ResourcesInfo),"^",5)
	.s GroupDesc=$p($g(ResourcesInfo),"^",6)
	.s GetLocDR=$p(^OEORD($p(oeorditemrowid,"||",1),"I",$p(oeorditemrowid,"||",2),3),"^",6)
	.s paadmdr=$p(^OEORD($p(oeorditemrowid,"||",1)),"^",1)
	.s Param=GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_GetLocDR_"^"_oeorditemrowid_"^"_SchudleRowid_"^"_SelectDate_"^"_"RE"
	.s IsCIndex=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(GetLocDR)
	.i IsCIndex'="" s IsCIndex=$p(IsCIndex,"^",1)
	.s IsCStudyNo=##class(web.DHCRisResourceApptSchudleEx).IsCreateStudyNo(GetLocDR)
	.i InStudyNo="" d
	..i IsCIndex="B" d
	...s IndexclsInfo=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)
	...i IndexclsInfo'="" d
	....s GetIndex=$p(IndexclsInfo,"^",1)
	....s GetNoRuleCode=$p(IndexclsInfo,"^",2)
	....s GetTypeDesc=$p(IndexclsInfo,"^",3)
	....s GetAppDateType=$p(IndexclsInfo,"^",4)
	....s GetTypeRowid=$p(IndexclsInfo,"^",5)
	....i GetNoRuleCode="L" s Index=GetIndex
	....i GetNoRuleCode="Z" s GroupIndex=GetIndex
	....i GetNoRuleCode="R" s RoomIndex=GetIndex
	..i IsCStudyNo="B" d
	...s StudyInfo=..GetStudyNo(oeorditemrowid,GroupDesc,GetLocDR,SelectDate)
	...i StudyInfo'="" d
	....s StudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	....s StudyNumber=$p($g(StudyInfo),"^",2)
	....s IsUpdate=$p($g(StudyInfo),"^",3)
	.e  d
	..s StudyNo=InStudyNo
	.s Infos=StudyNo_"^"_Index_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_paadmdr_"^"_GetTypeRowid_"^"_SelectDate_"^"_StudyNumber_"^"_IsUpdate
	q Infos
}

ClassMethod GetStudyNo(orditmrowid, EQGoup, LocDr, SelectDate = "") As %String
{
	s ^t=orditmrowid_"^"_EQGoup_"^"_LocDr_"^"_SelectDate
	n (orditmrowid, EQGoup, LocDr,SelectDate)
	s rowid=0,StudyNo="^^"
	q:orditmrowid="" StudyNo
	s EQGoupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGoup)
	s rowid="",AppType="",ItmCatRowid=""
	s ItmCatRowid=##class(web.DHCRisCodeTableAdd).GetItmCatDR(orditmrowid)
	
    i EQGoupDr'="" d 
	.s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGoupDr,rowid))
	.i rowid'="" s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	i ((ItmCatRowid'="")&(rowid="")) d
	.s rowid=$o(^DHCPACRegInfoCRi("SubOrderCat",ItmCatRowid,rowid))
	.i rowid'="" s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
    if rowid="" d
	.s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	.i rowid'="" s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	
	
	//查找已经登记的检查号
	s regrowid=$o(^DHCPACRegInfoi("OEORI",orditmrowid,0))
	i (regrowid'="")&(regrowid'=0) d
	.s Info=^DHCPACRegInfo(regrowid)
	.s StudyNo=$p(Info,"^",2)
	.i rowid'="" d   ; ----------------------按规则生成
	..s PreFix=$p(StudyNo,"-",1)
	..s StudyNo=$p(StudyNo,"-",2)
	..s StudyNo=PreFix_"-^"_StudyNo_"^0"
	.else  d
	..s StudyNo="^"_StudyNo_"^"_0 
    q:(regrowid'="")&(regrowid'=0)&(StudyNo'="") StudyNo
   
    //找默认的检查号 ACCESSION NUMBER 
	s Oeordrowid=$p(orditmrowid,"||",1)
	s childsub=$p(orditmrowid,"||",2)
	//s StudyNo=$p(^OEORD(Oeordrowid,"I",childsub,8),"^",19)
	//s StudyNo=$TR(StudyNo,"/","-")
	s StudyNo=Oeordrowid_"-"_childsub
	s StudyNo="^"_StudyNo_"^0"
	q:(EQGoupDr="")&(LocDr="") StudyNo 
	q:(rowid="")!(rowid=0)!(AppType=0) StudyNo

    //新增一个检查号
    //例如前缀为：XX+t 或者是 XX+T 的话：生成的 XX+当前日期（20080130）+加当前的流水号
	//否则是 前缀+顺序号
	/*i rowid'="" d
	.s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
	.s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
	.if (Number="t")!(Number="T") d
	..i SelectDate="" d
	...s currentdate=$zd(+$h,8)
	..else  d
	...s currentdatedigital=$zdh(SelectDate,3)
	...s currentdate=$zd(currentdatedigital,8) 
	..i $g(^DHCRisStudyNoDate(LocDr,currentdate))="" s ^DHCRisStudyNoDate(LocDr,currentdate)=0
	..s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
	..s Number=Number+1
	..s Number=##class(web.DHCRisRegisterPatientDoEx).Out3Number(Number)
	..s Prefix=Prefix_currentdate
    .else  d
	..s Number=Number+1
	.s StudyNo=Prefix_"-^"_Number_"^1"*/
	if (rowid'="") 
	{
		s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
		s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
		if (Number="t")!(Number="T") 
		{
			if (SelectDate="")
			{
				s currentdate=$zd(+$h,8)
			}
			else 
			{
				s currentdatedigital=$zdh(SelectDate,3)
				s currentdate=$zd(currentdatedigital,8)
			} 
			if $g(^DHCRisStudyNoDate(LocDr,currentdate))=""  s ^DHCRisStudyNoDate(LocDr,currentdate)=0
			s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
			s Number=Number+1
			
			s Prefix=Prefix_currentdate
			;判断是否已经使用，找到一个未使用的检查号
			
			s isFind="N"
			
			while(isFind'="Y")
			{
				s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
				s studyNoFind=Prefix_"-"_Number
				s detailDrFind=""
				s regInfoDrFind=""
				s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
				s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
				if ((detailDrFind="")&&(regInfoDrFind=""))
				{
					s isFind="Y"
				}
				else
				{
					s Number=Number+1
				}
			}
			
		}
		else 
		{
			s Number=Number+1
		}
		
		s StudyNo=Prefix_"-^"_Number_"^1"
	}

	q StudyNo
}

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
    s ResAppRowid=""
    i ResAppFind=1 s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",AppLocDR,RessourceID,ResAppRowid))
    i ResAppRowid'="" s ResAppSetFind="Y"
    q:(ResAppFind=1)&(ResAppSetFind="N") "N"
    q:(ResAppSetFind="Y") "Y"
    
    ;按病人类型查询可用资源
    s ResCodeRowid=0 f  s ResCodeRowid=$o(^DHCRBCPatTypeUseResource(ResCodeRowid)) q:(ResCodeRowid="")  d
    .q:(PatTypeFind=1)
    .s GetPatType=$p($g(^DHCRBCPatTypeUseResource(ResCodeRowid)),"^",1)
    .i patienttype=GetPatType s PatTypeFind=1
    s ResCodeRowid=""
    i PatTypeFind=1 s ResCodeRowid=$o(^DHCRBCPatTypeUseResourcei("TYPECODE",patienttype,RessourceID,ResCodeRowid))
    i ResCodeRowid'="" s PatTypeSetFind="Y"
    q:(PatTypeFind=1)&(PatTypeSetFind="N") "N"
    q:(PatTypeSetFind="Y") "Y"
    
    q:(ResAppFind=0)&(PatTypeFind=0) "Y"
}

ClassMethod GetAppItemInfo(OeOrditemID As %String) As %String
{
	//BC取部位
	s BodyDesc=""
	s ARCIMRowId=$p($g(^OEORD(+OeOrditemID,"I",$P(OeOrditemID,"||",2),1)),"^",2)
	;if $o(^DHCRISBODY("ARCIM",ARCIMRowId,-1))="" q ""
	;s RisBodyRowid=$o(^DHCRISBODY("ARCIM",ARCIMRowId,-1))
	s RisBodyRowid=$o(^DHCRISBODY("ARCIM",ARCIMRowId,""),-1)
	q:RisBodyRowid="" ""
	s BodyDesc=$P(^DHCRISBODY(RisBodyRowid),"^",3)
	q BodyDesc
}

/// w ##class(web.DHCRisBookParam).GetBookInfoInterface("20017||3880")
/// 函数名称:GetBookInfoInterface
/// 入参:医嘱ID
/// 返回值:OrditemRowid_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_Memo_"^"_otherInfo
ClassMethod GetBookInfoInterface(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") ""
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid)=""
	s (MemoTMRowid,RecLocdr,RecLocDesc,UserID,UserCode,UserDesc,Memo)=""
	
	s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)

    if (ArcItemId'="")
    {
	  s (MRowid,TMRowid)="" 
	  
	  s MRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemId,0))
	  i MRowid'="" d
	  .s TMRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	  .i TMRowid'="" d
	  ..s Memo=$p($g(^DHCRBCApp("Memo-Template",TMRowid)),"^",3)
	  .i Memo="" d
	  ..s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
	  
	}
	
	s RecLocdr=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
    if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
	
	s otherInfo=""
	s otherInfo=..GetAppItemInfo(OrditemRowid)
	
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	i (ResDetailRowid'="")
	{  
	   s UserID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",15)
	   i UserID'="" d
	   .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	   .s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	   .s ResourceDesc="",ResourceCode=""
	   .i ResouceId'="" d
	   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	   ..i EqId'="" d
	   ...s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
	   ...s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
	   ..i CareProvId'="" d
	   ...s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	   ...s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
	   ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
	   ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=$zd(Date,3)
	   .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
	   .i StartTime'="" s BooketTime=$zt(StartTime)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	   .s Info="" 
	   .s Info=OrditemRowid_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_Memo_"^"_otherInfo
	   
	}
	
	q Info
}

/// ////////////////////////////////////青医附院增加////////////////////////////////////////////
/// 功能:增加医嘱项目关联的服务组
/// sunyi 2014-12-25
/// do ##class(web.DHCRisBookParam).SetArcItmSer("^7^8866||1^6","I")
ClassMethod SetArcItmSer(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,ParentRefRowid,ArcItemRowid,ServiceGroupRowid)=""
	
	s Rowid=$P(AllInfo,"^",1)
	s ParentRefRowid=$P(AllInfo,"^",2)
	s ArcItemRowid=$P(AllInfo,"^",3) 
	s ServiceGroupRowid=$P(AllInfo,"^",4)

	s SameCount=0	
	i (ArcItemRowid'="")&(ServiceGroupRowid'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_ItemBookProperty_ServiceG 
	         where DIPS_ArcItem_DR=:ArcItemRowid And DIPS_ServiceGroup_DR=:ServiceGroupRowid) 
	              
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_ItemBookProperty_ServiceG(DIPS_ParentRef,DIPS_ArcItem_DR,DIPS_ServiceGroup_DR) values(:ParentRefRowid,:ArcItemRowid,:ServiceGroupRowid))
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_ItemBookProperty_ServiceG where DIPS_Rowid=:Rowid)
	
    q SQLCODE
}

/// 函数名称:QueryItmSer
/// 功能:查询医嘱项目关联的服务组
/// 输入参数:"预约项目属性表Rowid:ParentRef"
/// 返回:"ServiceGroupDR:%String,ServiceGroup:%String,Rowid:%String"
/// 作者:孙毅
/// 日期:2014-12-26
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryItmSer","7")
Query QueryItmSer(ParentRef As %String = "") As %Query(ROWSPEC = "ServiceGroupDR:%String,ServiceGroup:%String,Rowid:%String")
{
}

ClassMethod QueryItmSerExecute(ByRef qHandle As %Binary, ParentRef As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (Rowid,ServiceGroupDR,ServiceGroup)=""
	
	i (ParentRef="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}

	s SubRowid="" f  s SubRowid=$o(^DHCRBCItemBookPropertySG("ServiceGroup",ParentRef,SubRowid)) q:(SubRowid="")  d
	.s (Rowid,ServiceGroupDR,ServiceGroup)=""
	.s Rowid=ParentRef_"||"_SubRowid
	.s ServiceGroupDR=$p($g(^DHCRBCItemBookPropertySG("ServiceGroup",ParentRef,SubRowid)),"^",4)
	.i ServiceGroupDR'="" s ServiceGroup=$p($g(^RBC("SG",ServiceGroupDR)),"^",2)
	.Do ItmSerGroup
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ItmSerGroup
	set Data=$lb(ServiceGroupDR,ServiceGroup,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItmSerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmSerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItmSerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmSerExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据调度员查询关注科室 
/// do ##class(web.DHCRisBookParam).GetItmServiceGroup("7")
ClassMethod GetItmServiceGroup(ParentRef As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisBookParam:QueryItmSer")
	s ret=""
	do rset.Execute(ParentRef)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

// 获取预约信息 orderlist 【医嘱rowid$bodydr,bodydr@医嘱rowid】

// w ##class(web.DHCRisBookParam).GetBookedInfo("60||290")

ClassMethod GetBookedInfo(OrderList) As %String
{
	s ^TempDHCRis("getbookInfo")=OrderList
	s ret="^^^^^^^^^^^^^"
	q:(OrderList="") ret
	
	s Info=""
	s orderLen=$l(OrderList,"@")
	for len=1:1:orderLen
	{
		q:(Info'="")
		s orderBody=$p(OrderList,"@",len)
		;w !,"orderBody="_orderBody
		if (orderBody'="")
		{
			s Oeorditemdr=$p(orderBody,"$",1)
			;w !,"Oeorditemdr="_Oeorditemdr
			if (Oeorditemdr'="")
			{
				s RecLocdr=$p(^OEORD($p(Oeorditemdr,"||",1),"I",$p(Oeorditemdr,"||",2),3),"^",6)
				//预约数据
				s GroupDescDR="",GroupDesc="",RoomDesc="",RoomDR=""
				s GetPatientStatusCode="B"
				s ResourceId=""
				s bodyList=$p(orderBody,"$",2)
				s body=$p(bodyList,",",1)
				s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(Oeorditemdr_"^"_body)
				//s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
				;w !,"BookedRowid="_BookedRowid
				b //02
				if ( BookedRowid'="")
				{
					
				    s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
				    i SchudleRowid'="" d
				    .s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
				    .s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
				    .s AppointDate=$zd(RppDate,3)
				    .s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
				    .s AppointstTime=$zt(RppTime,1)
				}
				else
				{
					s exterBookRowid=##class(web.DHCRisWorkBenchDoEx).HasExternalBK(Oeorditemdr,body)
					b //01
					if (exterBookRowid'="")
					{
						s RppDate=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",5)
						i RppDate'="" s AppointDate=##class(websys.Conversions).DateLogicalToHtml(RppDate)  ;$zd(AppointDate,3)
						s RppTime=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",6)
						i RppTime'="" s AppointstTime=##class(websys.Conversions).TimeLogicalToHtml(RppTime)   ;$zt(AppointstTime,1)
						s resouceCode=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",3)
						;s equipmentRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(resouceCode),""))
						;i equipmentRowid'="" d
						;.s ResourceId=$o(^RB("RES",0,"EQ",equipmentRowid,RecLocdr,""))
					}
					
				}
				i ResourceId'="" d
			    .s ResDesc=""
			 	.s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
			    .s CTCPDR=$p(CTCPDR,$c(0))
			    .i CTCPDR'="" d
			    ..s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
			    .else  d
			    ..s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
			    ..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
			    ..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
			    ..i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
			    ..s GroupDescDR=$p($g(^RBC("EQ",EQDR)),"^",3)
			    ..i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2)
				    
				s OrderRowid=$p(Oeorditemdr,"||",1)
				s itemsub=$p(Oeorditemdr,"||",2)
				s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
				s papatmasmdr=$p(^PAADM(paadmdr),"^",1)   
				s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
			    s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
			    s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
			    s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
			    s SexDesc=$p(^CT("SEX",SexDr),"^",2)
			    s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
			    s Locdr=$p(^PAADM(paadmdr),"^",4)
			    s LocName=$p(^CTLOC(Locdr),"^",2) 
  
			    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
			  	s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
				s Info=RegNo_"^"_Name_"^"_SexDesc_"^"_DOB_"^"_LocName_"^"_strOrderName_"^"_$g(ResDesc)_"^"_$g(AppointDate)_"^"_$g(AppointstTime)_"^"_$g(GroupDescDR)_"^"_$g(GroupDesc)_"^"_$g(RoomDR)_"^"_$g(RoomDesc)_"^"_$g(EQDR)
				s ret=Info
			}
		}
	}

	q ret
}

/// 查询名称：QueryBodyPart
/// 功能：查询部位
/// 参数：
/// 潘
/// 返回：部位表:DHC_AppPart
/// Descript:  部位字典 
/// D ##Class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryPart","11207||1")
Query QueryPart(ArcItemRowid As %String = "") As %Query(ROWSPEC = "TPartID:%String,TPartCode:%String,TPartDesc:%String")
{
}

ClassMethod QueryPartExecute(ByRef qHandle As %Binary, ArcItemRowid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
    if (ArcItemRowid="")
    {
	    Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	    
    }
	s PartID=""
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",ArcItemRowid,TraID)) q:TraID=""  d
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",ArcItemRowid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..q:(PartID="")
	..Q:'$D(^DHCAPPART(PartID))
	..;s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	..s PartCode=$p(^DHCAPPART(PartID),"^",1)  /// 部位代码
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)  /// 部位描述
	..s mdata=PartID_"^"_PartCode_"^"_PartDesc
	..S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	..Set ^CacheTemp(repid,ind)=ListData	
	..Set ind=ind+1
	
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPartExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:QueryItmSer
/// 功能:查询医嘱项目+部位所关联的服务组
/// 输入参数:"预约项目属性表Rowid:ParentRef"
/// 返回:"ServiceGroupDR:%String,ServiceGroup:%String,Rowid:%String"
/// 潘
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryItmBodyPartSer","181^12658||1^2608")
Query QueryItmBodyPartSer(ParentRef As %String = "") As %Query(ROWSPEC = "BookParamSGID:%String,BodyPartSerDR:%String,BodyPartSerID:%String")
{
}

ClassMethod QueryItmBodyPartSerExecute(ByRef qHandle As %Binary, ParentRef As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s (BodyPartSerDR,BodyPartSerID,BookParamSGID)=""
	
	i (ParentRef="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s IPRowid=$p(ParentRef,"^",1)
	s ArcItemRowid=$p(ParentRef,"^",2)
	s BODYID=$p(ParentRef,"^",3)
    ;s ArcItemRowid=$p(^DHCRBCItemBookProperty(IPRowid),"^",1)
    ;w !,"ArcItemRowid="_ArcItemRowid
    s BookParamID=$o(^User.DHCRBCBookParamI("IndexItemBody",ArcItemRowid,BODYID,""))
   
    s BookParamSGID="" F  s BookParamSGID=$o(^User.DHCRBCBookParamD(BookParamID,"BPChild",BookParamSGID))  q:BookParamSGID=""  d               
	.;w !,"BookParamSGID="_BookParamSGID 
	.Do ItmBodyGroup
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ItmBodyGroup
    s BodyPartSerInfo=^User.DHCRBCBookParamD(BookParamID,"BPChild",BookParamSGID)
	s BodyPartSerDR=$listget(BodyPartSerInfo,3)
	s BodyPartSerID=$listget(BodyPartSerInfo,2) 
	
	set Data=$lb(BookParamSGID,BodyPartSerDR,BodyPartSerID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItmBodyPartSerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmBodyPartSerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryItmBodyPartSerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmBodyPartSerExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询科室医嘱部位关联的服务组
/// do ##class(web.DHCRisBookParam).GetOrdItmBodyPart("181^12658||1^2608")
ClassMethod GetOrdItmBodyPart(ParentRef As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisBookParam:QueryItmBodyPartSer")
	s ret=""
	do rset.Execute(ParentRef)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 功能:增加医嘱项目关联的部位
/// 潘
/// w ##class(web.DHCRisBookParam).SetArcItmBody("^181^12658||1^2336^（颈+胸+全腹+盆腔）","I")
/// w ##class(web.DHCRisBookParam).SetArcItmBody("12658||1^4^Y^17^2347^颈、胸","I")
ClassMethod SetArcItmBody(AllInfo As %String, OperateCode As %String) As %String
{
	s (Rowid,DIBPRowID,ArcItemRowid,BodyRowid,BodyDesc,AppointMethodID)=""
	s ^DHCRisTemp("SetArcItmBody")=AllInfo_"%"_OperateCode
	
	s ArcItemRowid=$P(AllInfo,"^",1)
	s AppointMethodID=$P(AllInfo,"^",2)
	s IsEmpty=$P(AllInfo,"^",3)
	s ArcItemBodyTime=$P(AllInfo,"^",4)
	s BodyRowid=$P(AllInfo,"^",5)
	s BodyCode=$p(AllInfo,"^",6)
    
  
	s SameCount=0	
	i (ArcItemRowid'="")&(BodyRowid'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_Bookparam 
	         where ArcItmMastRowid=:ArcItemRowid And BodyRowid=:BodyRowid) 
	         
	if ( (OperateCode="I") &&(SameCount>0))
	{
		q "200"   //不能重复添加
	}
	
	if ( (OperateCode="U") &&(SameCount=0))
	{
		q "300"   //先选择记录
	}
	   
	if ( (OperateCode="D") &&(SameCount=0))
	{
		q "300"   //先选择记录
	} 
	          
	i OperateCode="I" d
	.i SameCount=0 d
	..&sql(Insert into DHCRBC_Bookparam(BodyCode,ArcItmMastRowid,BodyRowid,AppointMethodID,ExamTime,IsEmpty)values(:BodyCode,:ArcItemRowid,:BodyRowid,:AppointMethodID,:ArcItemBodyTime,:IsEmpty))
	
	
	i OperateCode="U" d
	.&sql(Update DHCRBC_Bookparam set AppointMethodID=:AppointMethodID,ExamTime=:ArcItemBodyTime,IsEmpty=:IsEmpty where ArcItmMastRowid=:ArcItemRowid And BodyRowid=:BodyRowid)
	
	i OperateCode="D" d
	.&sql(Delete from DHCRBC_Bookparam where ArcItmMastRowid=:ArcItemRowid And BodyRowid=:BodyRowid)
	
    q SQLCODE
}

/// 查询医嘱项目的名称
/// w ##class(web.DHCRisBookParam).GetOrdItmName("12658||1")
ClassMethod GetOrdItmName(ArcItemRowid As %String) As %String
{
	s Subscrip=$P(ArcItemRowid,"||",1)
	s Version=$p(ArcItemRowid,"||",2)
    s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
    q ItemDesc
}

/// 查询部位的Code
/// w ##class(web.DHCRisBookParam).GetBodyCody("2347")
ClassMethod GetBodyCody(BodyRowid As %String) As %String
{
	i BodyRowid'=""
	s BodyCode=$p($g(^DHCAPPART(BodyRowid)),"^",1) 
    q BodyCode
}

/// 查询名称：QueryARCItemMastBody
/// 功能：查询医嘱项目名称
/// 参数：医嘱名称，ArcItemRowid
/// 返回：医嘱部位列表
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryARCItemMastBody","12658||1")
Query QueryARCItemMastBody(ArcItemRowid As %String) As %Query(ROWSPEC = "ItemRowid:%String,ItemDesc:%String,AppointMethodId:%String,AppointMethod:%String,Empty:%String,UseTime:%String,IPRowid:%String,OrdBodyPartID:%String,BodyPart:%String,SetService:%String,bookParamRowid:%String")
{
}

ClassMethod QueryARCItemMastBodyExecute(ByRef qHandle As %Binary, ArcItemRowid As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisBookParam","QueryARCItemMastByCat","235") 
 //^ARCIM(0,"ARCIC_DR",{ARCIM_ItemCat_DR},{ARCIM_Subscript},{ARCIM_Version} 取指定子类下的医嘱项
 s ind=1 
 s CurrentDate=+$h
 Set repid=$I(^CacheTemp)
 s ^TMP111=ArcItemRowid
 i (ArcItemRowid'="") d
 .s BodyPartID="" F  s BodyPartID=$o(^User.DHCRBCBookParamI("IndexItemBody",ArcItemRowid,BodyPartID)) q:BodyPartID=""  d	 
 ..s BookparamID="" F  s BookparamID=$o(^User.DHCRBCBookParamI("IndexItemBody",ArcItemRowid,BodyPartID,BookparamID)) q:BookparamID=""  d	
 ...s ItemRowid=ArcItemRowid
 ...s ItemDesc=##class(web.DHCRisBookParam).GetOrdItmName(ItemRowid)
 ...Do OutItmMastBody
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutItmMastBody
 
 s BookparamInfo=^User.DHCRBCBookParamD(BookparamID)
 s AppointMethodId=$listget(BookparamInfo,5)
 s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
 s Empty=$listget(BookparamInfo,6)
 s UseTime=$listget(BookparamInfo,7)
 s OrdBodyPartID=$listget(BookparamInfo,3)
 s BodyPart=$p($g(^DHCAPPART(OrdBodyPartID)),"^",2)
 s IPRowid=$o(^DHCRBCItemBookProperTypei(ItemRowid,0))
 S SetService="部位服务组"
 set Data=$lb(ItemRowid,ItemDesc,AppointMethodId,AppointMethod,Empty,UseTime,IPRowid,OrdBodyPartID,BodyPart,SetService,BookparamID)

 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryARCItemMastBodyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCItemMastBodyExecute ]
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

ClassMethod QueryARCItemMastBodyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCItemMastBodyExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 插入医嘱项目+部位的关联服务组
/// w ##class(web.DHCRisBookParam).SetArcItmBodySer("^181^12658||1^40^2608","I")
ClassMethod SetArcItmBodySer(AllInfo As %String, OperateCode As %String) As %String
{
	s ^TempDHCRis("SetArcItmBodySer")=$lb(AllInfo,OperateCode)
	
	s IPRowid=$P(AllInfo,"^",2)
	s ArcItemRowid=$P(AllInfo,"^",3)
	s ItmBodyPartSer=$P(AllInfo,"^",4)
	s BodyRowid=$P(AllInfo,"^",5)
	
    s ItmBodyPartSerDesc=$p($g(^RBC("SG",ItmBodyPartSer)),"^",2)
    s BookParamID=$o(^User.DHCRBCBookParamI("IndexItemBody",ArcItemRowid,BodyRowid,""))
	;w !,IPRowid_" "_ArcItemRowid_" "_ItmBodyPartSer_" "_BodyRowid_" "_ItmBodyPartSerDesc_" "_BookParamID

	s SameCount=0	
	i (BookParamID'="") d
	.&sql(select count(*) into :SameCount from DHCRBC_BookParamSG
	         where BPParref=:BookParamID and ServiceGroupID=:ItmBodyPartSer) 
	         
	if ((OperateCode="I")&&(SameCount'=0))
	{
		q "100"
	}
	         
	i OperateCode="I" d
	.;i SameCount=0 d
	.&sql(Insert into DHCRBC_BookParamSG(BPParref,ServiceGroupCode,ServiceGroupID)values(:BookParamID,:ItmBodyPartSerDesc,:ItmBodyPartSer))

	i OperateCode="D" d
	.&sql(Delete from  DHCRBC_BookParamSG where(ServiceGroupID=:ItmBodyPartSer and 	BPParref=:BookParamID))
	
	 q SQLCODE
}

/// 查询医嘱项目下的部位
/// do ##class(web.DHCRisBookParam).GetOrdItmBody("11207||1")
ClassMethod GetOrdItmBody(ArcItemRowid As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisBookParam:QueryPart")
	s ret=""
	do rset.Execute(ArcItemRowid)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_":"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

// 获取检查项目预约参数设置表rowid

ClassMethod getItemBookProperRowid(ItemMastRowid As %String) As %String
{
	n (ItemMastRowid)
	q:(ItemMastRowid="") ""
	s itemBookProperRowid=""
	s itemBookProperRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
	q itemBookProperRowid
}

}
