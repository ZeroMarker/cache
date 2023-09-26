Class web.DHCCAbFeeConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 初始化病区科室医嘱明细等
ClassMethod Init(flag As %String) As %String
{
   //w ##class(web.DHCCAbFeeConfig).Init()
   k ^DHCCAbFeeConfig("WardConfig")
   s wardid=0 f  s wardid=$o(^PAWARD(wardid)) q:wardid=""  d
   .q:+wardid=0
   .s warddesc=$p(^PAWARD(wardid),"^",2)
   .q:warddesc["停用"
   .q:warddesc["作废"
   .s ^DHCCAbFeeConfig("WardConfig",wardid)=0
   i flag="on" d
   .k ^DHCCAbFeeConfig("Details")
   .k ^DHCCAbFeeConfig("YCFeeCheck")
   .s ^DHCCAbFeeConfig("YCFeeCheck",1) = "web.DHCCAbFeeCheck^GetCheckFeeGE^床位费收费天数与实际住院天数是否相符^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",2) = "web.DHCCAbFeeCheck^GetCheckFeeGE^级别护理收费天数与实际住院天数是否相符^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",3) = "web.DHCCAbFeeCheck^GetCheckStop^非本病区身份违规停本病区开立的医嘱(不包含某些项目例如检查)^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",4) = "web.DHCCAbFeeCheck^GetCheckFeeLisRis^检验检查已下医嘱已收费但相关医技科室未执行^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",5) = "web.DHCCAbFeeCheck^GetCheckFeeGE^住院诊查收费天数与实际住院天数是否相符^1" 
   
   .s ^DHCCAbFeeConfig("YCFeeCheck",6) = "web.DHCCAbFeeCheck^GetCheckFeeGE^伙食费收费天数与实际包伙天数是否相符^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",7) = "web.DHCCAbFeeCheck^GetCheckFeeGE^空调费收费天数与实际空调开放天数是否相符|2013-11-15|2014-3-1^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",8) = "web.DHCCAbFeeCheck^GetCheckDrugFee^实际发药数量与收费是否相符(例如静配的按频次发药计费)^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",9) = "web.DHCCAbFeeCheck^GetCheckFeeOP^已做手术申请但是没有手术室计费^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",10) = "web.DHCCAbFeeCheck^GetCheckFeeExec^有需执行计费的医嘱尚未执行,请执行或停医嘱^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",11) = "web.DHCCAbFeeCheck^GetCheckFeeOPAS^已做手术申请但是没有麻醉科计费^1" 
   .s ^DHCCAbFeeConfig("YCFeeCheck",12) = "web.DHCCAbFeeCheck^GetCheckIDCard^患者出院前需要补入身份证号^1"
 q 0
}

ClassMethod insdetails(arctype As %String, ind As %String, details As %String) As %String
{
   s ^DHCCAbFeeConfig("Details",ind,arctype,details)=0
   q 0
}

ClassMethod insfun(clas As %String, func As %String, desc As %String) As %String
{
	s ret=""
   s node=0
   s ind="" f  s ind=$o(^DHCCAbFeeConfig("YCFeeCheck",ind)) q:ind=""  d
   .s node=ind
   s node=node+1
   
   s ^DHCCAbFeeConfig("YCFeeCheck",node)=clas_"^"_func_"^"_desc_"^"_0
   q ret
}

ClassMethod upfun(ind As %String, clas As %String, func As %String, desc As %String) As %String
{
	s ret=""
   s $p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",1)=clas
   s $p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",2)=func
   s $p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3)=desc
   q ret
}

ClassMethod insward(wardid As %String) As %String
{
	s ret=""
	if $d(^DHCCAbFeeConfig("WardConfig",wardid)) d
	.s ret="该病区已经添加过 不需要再添加"
	e  d
    .s ^DHCCAbFeeConfig("WardConfig",wardid)=0
   q ret
}

ClassMethod deldetails(arctype As %String, ind As %String, details As %String) As %String
{
   k ^DHCCAbFeeConfig("Details",ind,arctype,details)
   q 0
}

ClassMethod setstat(type As %String, ind As %String, details As %String, flag As %String) As %String
{
   i type="YCFeeCheck" d
   .s $p(^DHCCAbFeeConfig(type,ind),"^",4)=flag
   i type="WardConfig" d
   .s $p(^DHCCAbFeeConfig(type,details),"^",1)=flag
   q 0
}

ClassMethod getOECCAT(No As %String)
{
	s ORCATID=0
	s ORCATCode=""
	s ORCATDesc=""
	s InStr=""
	s i=0
	f  s ORCATID=$o(^OEC("ORCAT",ORCATID))  q:ORCATID=""  d
	.s ORCATCode=$p(^OEC("ORCAT",ORCATID),"^",1)
	.s ORCATDesc=$p(^OEC("ORCAT",ORCATID),"^",2)
	.i InStr'="" s InStr=InStr_","_ORCATID_"^"_ORCATCode_"^"_ORCATDesc
	.e  s InStr=ORCATID_"^"_ORCATCode_"^"_ORCATDesc
	q InStr
}

ClassMethod getARCIC(OrderCate As %String)
{
   i OrderCate="" q
   s ARCIC=0
   s ARCICCode=""
   s ARCICDesc=""
   s InStr=""
   f  s ARCIC=$o(^ARC("IC",0,"OrdCat",OrderCate,ARCIC)) q:ARCIC=""  d
   .s ARCICCode=$p(^ARC("IC",ARCIC),"^",1)
   .s ARCICDesc=$p(^ARC("IC",ARCIC),"^",2)
   .i InStr'="" s InStr=InStr_","_ARCIC_"^"_ARCICCode_"^"_ARCICDesc
   .e  s InStr=ARCIC_"^"_ARCICCode_"^"_ARCICDesc

   q InStr
}

ClassMethod getARCIM(ARCIC As %String)
{
	//w ##class(web.DHCCAbFeeConfig).getARCIM(815)
   i ARCIC="" q
   s arcim=""
   s arcimcode=""
   s arcimdesc=""
   s InStr=""
   f  s arcim=$o(^ARCIM(0,"ARCIC_DR",ARCIC,arcim)) q:arcim=""  d
   .s arcimcode=$p(^ARCIM(arcim,1,1),"^",1)
   .s arcimdesc=$p(^ARCIM(arcim,1,1),"^",2)
   .s effdateto=$p(^ARCIM(arcim,1,7),"^",1)
   .//w effdateto
   .q:(effdateto'="")&&(+effdateto<+$h)    //停用的不显示
   .i InStr'="" d
   ..s InStr=InStr_$c(2)_arcim_"||"_1_"^"_""_"^"_arcimdesc
   .e   d
   ..s InStr=arcim_"||"_1_"^"_""_"^"_arcimdesc
  	//i InStr'="" s InStr=$p(InStr,",",2,$l(InStr,","))
   q InStr
}

Query LookUp() As %Query(ROWSPEC = "TInd,TType,TArcType,TClass,TFunction,TDetails,TCheckDesc,TUseFlag,TDetails2")
{
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCCAbFeeConfig","LookUp")
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
    ///w !,"规则  8、发药与收费不一致; 10、需计费医嘱未停止未计费（所有收费医嘱都要配置上）;  13、7.0后版本医嘱没有执行记录; " 
    ///w !
    ///w !,"      14、查找数据不全的医嘱;  15、查找数据不全的医嘱 不能停用"
    
    s (Ind,Type,ArcType,Class,Function,Details,CheckDesc,UseFlag,Details2)=""
    s Ind="" f  s Ind=$o(^DHCCAbFeeConfig("YCFeeCheck",Ind)) q:Ind=""  d
    .s Type="YCFeeCheck" 
    .s Class=$p(^DHCCAbFeeConfig(Type,Ind),"^",1)
    .s Function=$p(^DHCCAbFeeConfig(Type,Ind),"^",2) 
    .s CheckDesc=$p(^DHCCAbFeeConfig(Type,Ind),"^",3)
    .s UseFlag=$p(^DHCCAbFeeConfig(Type,Ind),"^",4)
    .i UseFlag=1 s UseFlag="启用"
    .e  s UseFlag="停用"
	.d OutputRow
	.s ArcType="" f  s ArcType=$o(^DHCCAbFeeConfig("Details",Ind,ArcType)) q:ArcType=""  d
	..s Type="Details" 
	..s itm="" f  s itm=$o(^DHCCAbFeeConfig("Details",Ind,ArcType,itm)) q:itm=""  d
    ...i ArcType="OECCAT" d
    ....i $d(^OEC("ORCAT",itm)) d
    .....s Details=$p(^OEC("ORCAT",itm),"^",2)
    ...i ArcType="ARCIC" d
    ....i $d(^ARC("IC",itm)) d
    .....s Details=$p(^ARC("IC",itm),"^",2)
    ...i ArcType="ARCIM" d
    ....i $d(^ARCIM(+itm)) d
    .....s Details=$p(^ARCIM(+itm,1,1),"^",2)
    ...s details2=itm
    ...s (Class,Function,CheckDesc,UseFlag)=""
    ...d OutputRow
    .s (Type,ArcType,Class,Function,Details,CheckDesc,UseFlag,details2)=""
    
    s ward="" f  s ward=$o(^DHCCAbFeeConfig("WardConfig",ward)) q:ward=""  d
    .s Type="WardConfig" 
    .s Ind=ward
    .s Details=$p(^PAWARD(ward),"^",2)
    .s UseFlag=$p(^DHCCAbFeeConfig("WardConfig",ward),"^",1)
    .i UseFlag=1 s UseFlag="启用"
    .e  s UseFlag="停用"
    .s details2=ward
    .d OutputRow
 
    
    
 			s qHandle=$lb(0,repid,0)
			q $$$OK
    
OutputRow
		s Data=$lb(Ind,Type,ArcType,Class,Function,Details,CheckDesc,UseFlag,details2)
 		s ^CacheTemp(repid,ind)=Data
 		s ind=ind+1
		q
}

ClassMethod LookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod wardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = wardlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod wardlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=$$ALPHAUP^SSUTIL4(desc)
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=desc_"%"
	&sql(declare ward cursor  for 
	select WARD_rowid,WARD_desc from SQLUser.PAC_WARD where %UPPER(WARD_desc) like :desc)
	&sql(open ward)
	f  &sql(fetch ward into :WARDrowid,:WARDdesc) q:SQLCODE  d
 	.Do OutputRow2 	 	
 	&sql(close ward)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(WARDdesc,WARDrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod wardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = wardlookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query wardlookup(desc As %String) As %Query(ROWSPEC = "ward:%String,wardid:%String")
{
}

ClassMethod getAllFun(No As %String)
{
	s node=0
	s funname=""
	s InStr=""
	s i=0
	f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:node=""  d
	.s funname=$p(^DHCCAbFeeConfig("YCFeeCheck",node),"^",3)
	.
	.i InStr'="" s InStr=InStr_$c(2)_node_"^"_funname
	.e  s InStr=node_"^"_funname
	q InStr
}

ClassMethod getSelFun(user As %String)
{
	s node=0
	s funname=""
	s InStr=""
	s i=0
	
	q:'$d(^DHCCAbFeeConfig("UserSel",user)) ""
	s nodes=^DHCCAbFeeConfig("UserSel",user)
	q:nodes="" ""
	s len=$l(nodes,"^")
    f i=1:1:len
    {
		s usernode=$p(nodes,"^",i)
		s funname=$p(^DHCCAbFeeConfig("YCFeeCheck",usernode),"^",3)
		i InStr'="" s InStr=InStr_$c(2)_usernode_"^"_funname
		e  s InStr=usernode_"^"_funname
    }
	q InStr
}

ClassMethod SaveSelFun(user As %String, nodes As %String)
{
   s ret=""
   s ^DHCCAbFeeConfig("UserSel",user)=nodes
   	q ret
}

Storage Default
{
<Data name="DHCCAbFeeConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCAbFeeConfigD</DataLocation>
<DefaultData>DHCCAbFeeConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCAbFeeConfigD</IdLocation>
<IndexLocation>^web.DHCCAbFeeConfigI</IndexLocation>
<StreamLocation>^web.DHCCAbFeeConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
