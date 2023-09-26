Import SQLUser

Class web.INSUDicDataCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

/// 更新记录
ClassMethod Update(Instring)
{
	n (Instring)
    s id=$p(Instring,"^",1)
    s DicType=$p(Instring,"^",2)
    s DicCode=$p(Instring,"^",3)
    s DicDesc=$p(Instring,"^",4)
    s DicDemo=$p(Instring,"^",5)
    s DicBill1=$p(Instring,"^",6)
    s DicBill2=$p(Instring,"^",7)
    s DicType=$ZCVT(DicType,"U")
    s DicCode=$ZCVT(DicCode,"U")
    i id'=""{
	    s obj=##class(User.INSUDicData).%OpenId(id)
	    }
	else{
		i $d(^DHCINSUDicDataI("ITypeCode",DicType,DicCode)){
			s id=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id))
			s obj=##class(User.INSUDicData).%OpenId(id)
			;q -1 
			}
		else{
			s obj=##class(User.INSUDicData).%New()
			}
		}
	s obj.DicType=DicType
    s obj.DicCode=DicCode
    s obj.DicDesc=DicDesc
    s obj.DicDemo=DicDemo
    s obj.DicBill1=DicBill1
    s obj.DicBill2=DicBill2    
	d obj.%Save()
    s id=obj.%Id()
    d obj.%Close()
    q 0
}

/// 删除记录
ClassMethod Delete(id)
{
	n (id)
	&sql(delete from INSU_DicData where INDID_Rowid=:id)
	q SQLCODE
}

/// 查询
ClassMethod Query(DicType, DicCode)
{
	n (DicType,DicCode)
	k ^CacheTemp("INSUDic",$j)
	s i=0,id=""
	;$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id))
	q:'$d(^DHCINSUDicDataI("ITypeCode",DicType)) 0
	;q:(DicCode'="")&('$d(^DHCINSUDicDataI("ITypeCode",DicType,DicCode))) 0
	i DicCode=""{
		f  s DicCode=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode)) q:DicCode=""  d
		.f  s id=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id)) q:id=""  d
		..d BuildData
		}
	else{
		q:'$d(^DHCINSUDicDataI("ITypeCode",DicType,DicCode)) 0
		s id=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id))
		d BuildData
		}
	q i_"^"_$j
BuildData
    s obj=##class(User.INSUDicData).%OpenId(id)
    s i=i+1
    s DicType=obj.DicType
    s DicCode=obj.DicCode
    s DicDesc=obj.DicDesc
    s DicDemo=obj.DicDemo
    s DicBill1=obj.DicBill1
    s DicBill2=obj.DicBill2
    s ^CacheTemp("INSUDic",$j,i)=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
    q
}

/// 取数据
ClassMethod GetData(JustId, Index)
{
	n (JustId,Index)
	s OutString=$g(^CacheTemp("INSUDic",JustId,Index))
	i $o(^CacheTemp("INSUDic",JustId,""),-1)=Index k ^CacheTemp("INSUDic",JustId)
	q OutString
}

/// 查询
ClassMethod GetSys(DicType, DicCode)
{
	s OutString=""
	s i=0,id="",DicType="SYS"
	;$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id))
	q:'$d(^DHCINSUDicDataI("ITypeCode",DicType)) 0
	f  s DicCode=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode)) q:DicCode=""  d
	.f  s id=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id)) q:id=""  d
	..s OutString=OutString_"!"_$$sBuildData(id)
	q OutString
sBuildData(sid)
    s obj=##class(User.INSUDicData).%OpenId(sid)
    s DicType=obj.DicType
    s DicCode=obj.DicCode
    s DicDesc=obj.DicDesc
    s DicDemo=obj.DicDemo
    s DicBill1=obj.DicBill1
    s DicBill2=obj.DicBill2
    s s=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
    q s
}

/// 查询
ClassMethod QueryByCode(DicType, DicCode) As %String
{
	n (DicType,DicCode)
	s i=0,id=""
	q:'$d(^DHCINSUDicDataI("ITypeCode",DicType)) 0
	q:(DicCode'="")&('$d(^DHCINSUDicDataI("ITypeCode",DicType,DicCode))) 0
	
	s id=$o(^DHCINSUDicDataI("ITypeCode",DicType,DicCode,id))
	s obj=##class(User.INSUDicData).%OpenId(id)
    s DicType=obj.DicType
    s DicCode=obj.DicCode
    s DicDesc=obj.DicDesc
    s DicDemo=obj.DicDemo
    s DicBill1=obj.DicBill1
    s DicBill2=obj.DicBill2
    s outStr=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
    q outStr
}

ClassMethod QueryByCodeNB(DicType, DicCode) As %String
{
	;n (DicType,DicCode)
	s i=0,id=""
	q:DicCode="" ""
	q:'$d(^DHCINDID("0","ITypeCode",DicType)) ""
	q:(DicCode'="")&('$d(^DHCINDID("0","ITypeCode",DicType,DicCode))) ""
	s id=$o(^DHCINDID("0","ITypeCode",DicType,DicCode,id))
	s obj=##class(User.INSUDicData).%OpenId(id)
    s DicType=obj.INDIDDicType
    s DicCode=obj.INDIDDicCode
    s DicDesc=obj.INDIDDicDesc
    s DicDemo=obj.INDIDDicDemo
    s DicBill1=obj.INDIDDicBill1
    s DicBill2=obj.INDIDDicBill2
    s outStr=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
    q outStr
}

ClassMethod QueryConDate(DicType, hisDataCode) As %String
{
	;n (DicType,hisDataCode)
	s i=0,id="",DicDesc="",DicDemo="",DicBill1="",DicBill2="",outStr=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	;q:'$d(^DHCINDID("0","ITypeCode",DicType)) 0
	s DicCode="0"
	f  s DicCode=$o(^DHCINDID("0","ITypeCode",DicType,DicCode))  q:DicCode=""  d
	.s id="0"
	.f  s id=$o(^DHCINDID("0","ITypeCode",DicType,DicCode,id))  q:id=""  d 
	..s obj=##class(User.INSUDicData).%OpenId(id)
    ..s DicBill1=obj.INDIDDicBill1
    ..q:(DicBill1'=hisDataCode) 
    ..s DicType=obj.INDIDDicType
    ..s DicCode=obj.INDIDDicCode
    ..s DicDesc=obj.INDIDDicDesc
    ..s DicDemo=obj.INDIDDicDemo
    ..s DicBill2=obj.INDIDDicBill2
    s outStr=id_"^"_DicType_"^"_DicCode_"^"_DicDesc_"^"_DicDemo_"^"_DicBill1_"^"_DicBill2
    q outStr
}

ClassMethod QryGetInsuTypeExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s i=0,id="",code="0"
	f  s code=$o(^DHCINDID("0","ITypeCode","INSUTYPE",code)) q:code=""  d
	.s id="0"
	.f  s id=$o(^DHCINDID("0","ITypeCode","INSUTYPE",code,id)) q:id=""  d
	..s obj=##class(User.INSUDicData).%OpenId(id)
    ..s DicType=obj.INDIDDicType
    ..s DicCode=obj.INDIDDicCode
    ..s DicDesc=obj.INDIDDicDesc
    ..s DicDemo=obj.INDIDDicDemo
    ..s DicBill1=obj.INDIDDicBill1
    ..s DicBill2=obj.INDIDDicBill2
	..d BuildInsuTypeTmp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildInsuTypeTmp      
	set Data=$lb(DicDesc,DicCode,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryGetInsuTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetInsuTypeExecute ]
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

Query QryGetInsuType() As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryGetInsuTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetInsuTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryGetDicTypeExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s i=0,id="",code="0"
	f  s code=$o(^DHCINDID("0","ITypeCode","DicType",code)) q:code=""  d
	.s id="0"
	.f  s id=$o(^DHCINDID("0","ITypeCode","DicType",code,id)) q:id=""  d
	..s obj=##class(User.INSUDicData).%OpenId(id)
    ..s DicType=obj.INDIDDicType
    ..s DicCode=obj.INDIDDicCode
    ..s DicDesc=obj.INDIDDicDesc
    ..s DicDemo=obj.INDIDDicDemo
    ..s DicBill1=obj.INDIDDicBill1
    ..s DicBill2=obj.INDIDDicBill2
	..d BuildDicTypeTmp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDicTypeTmp      
	set Data=$lb(DicDesc,DicCode,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryGetDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetInsuTypeExecute ]
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

Query QryGetDicType() As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryGetDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDicDataByDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDicDataByDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据码表类型INSU_DicData.INDID_DICTYPE取码表信息
ClassMethod QueryGetDicDataByDicTypeExecute(ByRef qHandle As %Binary, strDicType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s i=0,id="",code="0"
	f  s code=$o(^DHCINDID("0","ITypeCode",strDicType,code)) q:code=""  d
	.s id="0"
	.f  s id=$o(^DHCINDID("0","ITypeCode",strDicType,code,id)) q:id=""  d
	..s obj=##class(User.INSUDicData).%OpenId(id)
    ..s DicType=obj.INDIDDicType
    ..s DicCode=obj.INDIDDicCode
    ..s DicDesc=obj.INDIDDicDesc
    ..s DicDemo=obj.INDIDDicDemo
    ..s DicBill1=obj.INDIDDicBill1
    ..s DicBill2=obj.INDIDDicBill2
	..d BuildTmpByType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTmpByType      
	set Data=$lb(DicDesc,DicCode,strDicType,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryGetDicDataByDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDicDataByDicTypeExecute ]
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

Query QueryGetDicDataByDicType(strDicType As %String) As %Query(ROWSPEC = "DicDesc:%String,DicCode:%String,DicType:%String,id:%String")
{
}

}
