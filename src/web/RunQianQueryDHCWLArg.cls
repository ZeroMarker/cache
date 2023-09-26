Import SQLUser

Class web.RunQianQueryDHCWLArg Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query GetReaSon() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select "医保类型",REA_ROWID,REA_DESC from pac_admreason
where REA_nationalcode is not null
}

Query Getdoc(user As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select  SSUSR_CareProv_DR  from ss_user 
 where ssusr_rowid=:user
}

//医嘱大类

//d ##class(%ResultSet).RunQuery("web.DhznQueryDHCWLArg","GetOrCate","静脉注射")	

Query GetOrCate() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select orcat_rowid,orcat_desc from OEC_OrderCategory
}

//医嘱状态

//d ##class(%ResultSet).RunQuery("web.DhznQueryDHCWLArg","GetOrCate","静脉注射")	

Query GetOeStatus() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select ostat_rowid,ostat_desc from  OEC_OrderStatus
}

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetDep","3901")	

ClassMethod GetDepExecute(ByRef qHandle As %Binary, useId As %String) As %Status
{
	n (qHandle,useId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    q:useId="" $$$OK
   
    s outdata=$$GetUserLoginLoc^DHCWLGetCurrentPatFee(useId,.data)
    ;s outdata=$$GetUserLoginLoc^RunQianQueryDHCWL(useId,.data)
    s num=""
    f num=0:1:outdata-1 d
    .s loc=$p(data(num),"^",1)
    .s desc=$p(data(num),"^",2) q:desc["药"
    .d OutputRow1
 	q $$$OK	

OutputRow1
  
    s Data=$lb(loc,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDep(useId As %String) As %Query(ROWSPEC = "loc:%Integer,desc:%String") [ SqlProc ]
{
}

Query Hospital() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select hosp_rowid,hosp_code,hosp_desc from CT_Hospital
}

//患者信息就诊记录

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetMedPatAdm","105001")	

ClassMethod GetMedPatAdmExecute(ByRef qHandle As %Binary, Medicare As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:Medicare="" $$$OK
    s iPatNo="",ADMRowID=""
    
    s Medicare=$$ALPHAUP^SSUTIL4(Medicare)
	
    f  s iPatNo=$o(^PAPERi("Medicare1",Medicare,iPatNo)) q:iPatNo=""  d
    .s 姓名=$$GetPapmiName^DHCWLCommon(iPatNo)  //通过PA_PatMas.PAPMI_RowId得到病人姓名
    .f  s ADMRowID=$o(^PAPERdr(iPatNo,"ADM","I",ADMRowID)) q:ADMRowID=""  d
    ..s ADMNO=$p(^PAADM(ADMRowID),"^",81) //就诊号
	..s ADMDate=$p(^PAADM(ADMRowID),"^",6) //入院日期
	..s:ADMDate'="" ADMDate=$zd(ADMDate,3)
	..s ADMTime=$p(^PAADM(ADMRowID),"^",7) //入院时间
	..s:ADMTime'="" ADMTime=$zt(ADMTime,1)
	..s 就诊日期=ADMDate_"&"_ADMTime
	..s Type=$p(^PAADM(ADMRowID),"^",2)  q:Type'="I" //类型
	..s DepID=$p(^PAADM(ADMRowID),"^",4) //
	..i (DepID="")    d
	...s Depcode=""
	...s DepDesc=""
	..e            d
	...i ('$d(^CTLOC(DepID)))  d
	....s Depcode=""
	....s DepDesc=""
	...e    d
	....s Depcode=$p(^CTLOC(DepID),"^",1) //科室编号
	....s DepDesc1=$p(^CTLOC(DepID),"^",2) //科室
	....i DepDesc1 [ "-" s DepDesc=$p(DepDesc1,"-",2)
    ..s DischgDate=$p(^PAADM(ADMRowID),"^",17) //护士结算出院日期
	..s:DischgDate'="" DischgDate=$zd(DischgDate,3)
	..s DischgTime=$p(^PAADM(ADMRowID),"^",18) //
	..s:DischgTime'="" DischgTime=$zt(DischgTime,1)
	..s 出院日期=DischgDate_"&"_DischgTime
	..s VisitStatus=$p(^PAADM(ADMRowID),"^",20) //adm 状态
	..s Estdate=$p(^PAADM(ADMRowID),"^",59) //医生结算日期	 
	..s:Estdate'="" Estdate=$zd(Estdate,3)
	..s Esttime=$p(^PAADM(ADMRowID),"^",60) //医生结算时间	Add By lxc 2012-03-19
	..s:Esttime'="" Esttime=$zt(Esttime,1)
	..s CreateUser=$p(^PAADM(ADMRowID),"^",43) //登记人
	..s BillFlag=$p(^PAADM(ADMRowID),"^",45) //结算状态
	..s RoomID=""
	..s RoomID=$p(^PAADM(ADMRowID),"^",69) //病房
	..i (RoomID="") d
	...s RoomCode="" 
	...s RoomDesc="" 
	..e        d
	...i $d(^PAROOM(RoomID))   d
	....s RoomCode=$p(^PAROOM(RoomID),"^",1)
	....s RoomDesc=$p(^PAROOM(RoomID),"^",2)
	...e  s RoomCode="",RoomDesc=""
	..s WardID=$p(^PAADM(ADMRowID),"^",70) //病区
	..i (WardID="") d
	...s WardCode="" 
	...s WardDesc="" 
	..e          d
	...i ('$d(^PAWARD(WardID)))    d
	....s WardCode=""
	....s WardDesc=""
	...e       d
	....s WardCode=$p(^PAWARD(WardID),"^",1)
	....s WardDesc1=$p(^PAWARD(WardID),"^",2)
	....i WardDesc1 [ "-" s WardDesc=$p(WardDesc1,"-",2)
	..s BedID=$p(^PAADM(ADMRowID),"^",73) //床位
	..s BedRowid=$P(BedID,"||",1)
    ..s BedSub=$P(BedID,"||",2)
	..i (BedID="")!(WardID="") d
	...s BedCode=""
	..e       d
	...i ('$d(^PAWARD(WardID,"BED",BedSub)))  d
	....s BedCode=""   d
	...e        d
    ....s BedCode=$P($G(^PAWARD(WardID,"BED",BedSub)),"^",1) 
	..d OutputRow2
 	q $$$OK	
OutputRow2
    i Type="I" s 就诊类型="住院"
    i Type="O" s 就诊类型="门诊"
    i Type="E" s 就诊类型="急诊"
    i Type="H" s 就诊类型="体检"
    s Data=$lb(就诊日期,姓名,就诊类型,ADMRowID,出院日期,DepDesc,WardDesc,BedCode)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMedPatAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedPatAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMedPatAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedPatAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMedPatAdm(Medicare As %String) As %Query(ROWSPEC = "就诊日期:%String,姓名:%String,就诊类型:%String,ADMRowID:%Integer,出院日期:%String,DepDesc:%String,WardDesc:%String,BedCode:%String") [ SqlProc ]
{
}

//科室信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCtlocXX")	

ClassMethod GetCtlocXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s loc=0
    f  s loc=$o(^PAC("ADMLOC",0,"AdmType","I",loc))  q:loc=""   d 
    .i $d(^CTLOC(loc)) d
    ..s desc=$P($G(^CTLOC(loc)),"^",2)  
    ..i desc [ "-" s depDesc=$p(desc,"-",2)
    ..e  s depDesc=desc
    ..d OutputRow3
   
 	q $$$OK	

OutputRow3
    s type="住院科室"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtlocXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtlocXX() As %Query(ROWSPEC = "type:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

//病房信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCtWardXX")	

ClassMethod GetCtWardXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    s loc=0  f  s loc=$o(^CTLOC(0,"LocType","W",loc)) q:loc=""   d 
    .i $d(^CTLOC(loc)) d
    ..s desc=$p($g(^CTLOC(loc)),"^",2)
    ..i desc [ "-" s depDesc=$p(desc,"-",2)
    ..e  s depDesc=desc   
    ..d OutputRow4
 	q $$$OK	

OutputRow4
    s type="病区"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtWardXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtWardXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtWardXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtWardXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtWardXX() As %Query(ROWSPEC = "type:%String,loc:%Integer,depDesc:%String") [ SqlProc ]
{
}

//病区信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetPacWardXX")	

ClassMethod GetPacWardXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

    s loc=0  f  s loc=$o(^PAWARD(loc)) q:loc=""   d 
    .q:((loc="BED_BedType_DR") || (loc="BED_Room_DR"))
    .s active=$p($g(^PAWARD(loc)),"^",6) q:active="N"
    .s desc=$p($g(^PAWARD(loc)),"^",2)
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .e  s depDesc=desc   
    .d OutputRow12
 	q $$$OK	

OutputRow12
    s type="病区"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPacWardXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPacWardXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPacWardXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPacWardXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPacWardXX() As %Query(ROWSPEC = "type:%String,loc:%Integer,depDesc:%String") [ SqlProc ]
{
}

//单病种分类信息

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetDiagFlxx")	

ClassMethod GetDiagFlxxExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k dicData
	s str="LimPat2,LimPat3"
    s dicRowid=""
    f  s dicRowid=$o(^DHCINDID(dicRowid)) q:dicRowid=""  d
    .q:dicRowid=0
    .s type=$p(^DHCINDID(dicRowid),"^",1)
    .q:$F(","_str_",",","_type_",")=0
    .s dicDesc=$p(^DHCINDID(dicRowid),"^",3)
    .s dicDemo=$p(^DHCINDID(dicRowid),"^",6) q:dicDemo=""
    .d OutputRow5
    
 	q $$$OK	

OutputRow5
    ;s bz="全部单病种"
    i type="LimPat2" s typedesc="[生育病种]"
    i type="LimPat3" s typedesc="[单病种]"
    ;s dicfl="'"_dicDemo_"'"
    s dicDemo=dicDemo_""_typedesc
    s Data=$lb(dicRowid,dicDemo,dicDesc,type,typedesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDiagFlxxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagFlxxExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDiagFlxxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagFlxxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDiagFlxx() As %Query(ROWSPEC = "dicRowid:%String,dicDemo:%String,dicDesc:%String,type:%String,typedesc:%String") [ SqlProc ]
{
}

//单病种信息另种写法

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetDiagDesc")	

ClassMethod GetDiagDescExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
    k dicData
    f insuDicType="LimPat2","LimPat3" d
    .s dicRowid=0
    .f  s dicRowid=$o(^DHCINDID(0,"IType",insuDicType,dicRowid)) q:dicRowid=""  d
    ..s dicDesc=$p(^DHCINDID(dicRowid),"^",3)
    ..q:dicDesc=""
    ..i '$d(dicData(dicDesc,insuDicType)) s dicData(dicDesc,insuDicType)=dicRowid
    ..e  s dicData(dicDesc,insuDicType)=dicData(dicDesc,insuDicType)_"^"_dicRowid
    
    s nod=""
    f  s nod=$o(dicData(nod)) q:nod=""  d
    .s insuDicType="" 
    .f  s insuDicType=$o(dicData(nod,insuDicType)) q:insuDicType=""  d
    ..s insuDicTypeDesc=$s(insuDicType="LimPat2":"生育病种",1:"单病种")
    ..d OutputRow6
    
 	q $$$OK	

OutputRow6
    s Data=$lb(insuDicTypeDesc,$g(dicData(nod,insuDicType)),nod)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDiagDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDiagDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDiagDesc() As %Query(ROWSPEC = "type:%String,LimitPatId:%String,LimitPatCatDesc:%String") [ SqlProc ]
{
}

//手术名称获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetOpName","by")	

ClassMethod GetOpNameExecute(ByRef qHandle As %Binary, operStr As %Text) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:operStr="" $$$OK
	
	d ##class(web.RunQianQueryDHCWLArg).GetOperation(operStr)
	s Tid="" f  s Tid=$o(^TMP("ANCom",$j,Tid)) q:Tid=""  d
	.s OpId=$p(^TMP("ANCom",$j,Tid),"^",1)
	.s OpNa=$p(^TMP("ANCom",$j,Tid),"^",2)
    .d OutputRow7
    k ^TMP("ANCom",$j)
 	q $$$OK	

OutputRow7
    s Data=$lb(OpNa,OpId)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetOpNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOpNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOpName(operStr As %String) As %Query(ROWSPEC = "OpNa:%Text,OpId:%String") [ SqlProc ]
{
}

//d ##class(web.RunQianQueryDHCWLArg).GetOperation("by")

//根据别名查询手术

ClassMethod GetOperation(operStr)
{
	k ^TMP("ANCom",$j)
	s i=0 //ypz 060811
	//^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
	s operStr=$$ALPHAUP^SSUTIL4(operStr) //$ZCONVERT(operStr,"U")  ypz 070313
    q:operStr="" 0
    if (operStr'="")
    {
	s flag="N"
	s OpDes=$O(^ORC("OPER",0,"ALIAS",operStr),-1)  //ypz 070313 open
    f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
    	.i $p(OpDes,operStr)'="" s flag="Y" q
    	.s operId=""
    	.f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
    		..s operDesc=$p(^ORC("OPER",operId),"^",2)
    		..s ^TMP("ANCom",$j,i)=operId_"^"_operDesc
    		..//w ^TMP("ANCom",$j,i)
    		..s i=i+1
    }
    if i>0 q i
  	s operId=0
	f  s operId=$o(^ORC("OPER",operId)) q:operId=""  d
		.s operDesc=$p(^ORC("OPER",operId),"^",2)
		.q:$$ALPHAUP^SSUTIL4(operDesc)'[operStr //q:$$UPPER^SSUTIL4(operDesc)'[operStr
    	.s ^TMP("ANCom",$j,i)=operId_"^"_operDesc
    	.//w ^TMP("ANCom",$j,i)
    	.s i=i+1
 	q i
}

//根据别名查询收费项目

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetItmName","xd")	

ClassMethod GetItmNameExecute(ByRef qHandle As %Binary, AliStr As %Text) As %Status
{
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:AliStr="" $$$OK
	s outData=$$GetTarItemForAlise(AliStr)
    s num=""
    
    f num=0:1:outData-1 d
    .s desc=$p(mPLIST(num),"^",1)
    .s tar=$p(mPLIST(num),"^",2)
    .d OutputRow8
 	q $$$OK	

OutputRow8
    ;i desc [ "[" s desc=$tr(desc,"[","")
    ;i desc [ "]" s desc=$tr(desc,"]","")
    ;i desc [ "/" s desc=$tr(desc,"/","(")
    i desc [ " " s desc=$tr(desc," ","")
    s Data=$lb(desc,tar)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
GetTarItemForAlise(Alise) ;根据别名查询收费项目
 n (Alise,mPLIST)
 s Alise=$$ALPHAUP^SSUTIL4(Alise)        ;ALPHAUP
 s Num=0
 s TarAlise=""
 f  s TarAlise=$o(^DHCTARAL("A",0,"Desc",TarAlise)) q:TarAlise=""  d
 .q:TarAlise'[Alise      ;模糊查询
 .s TariRowid=0
 .f  s TariRowid=$o(^DHCTARAL("A",0,"Desc",TarAlise,TariRowid)) q:TariRowid=""  d
 ..q:'$d(^DHCTARI(TariRowid))
 ..s Desc=$p(^DHCTARI(TariRowid),"^",2) 
 ..s mPLIST(Num)=""_$g(Desc)_"^"_+TariRowid
 ..s Num=Num+1
 q Num
}

ClassMethod GetItmNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetItmNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItmName(AliStr As %String) As %Query(ROWSPEC = "desc:%Text,tar:%String") [ SqlProc ]
{
}

//模糊查询收费项目

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetItmNameByDesc","彩色多普勒超声检查")	

ClassMethod GetItmNameByDescExecute(ByRef qHandle As %Binary, AliStrna As %Text) As %Status
{
    ;n (AliStrna)
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:AliStrna="" $$$OK
 	s TariRowid=""
    f  s TariRowid=$o(^DHCTARI(TariRowid)) q:TariRowid=""  d
    .q:TariRowid=0
    .s desc=$p($g(^DHCTARI(TariRowid)),"^",2) q:desc="" 
    .q:desc'[AliStrna
    .d OutputRow13
 
	Quit $$$OK
OutputRow13
	set Data=$lb(desc,TariRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItmNameByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmNameByDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetItmNameByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmNameByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItmNameByDesc(AliStrna As %String) As %Query(ROWSPEC = "desc:%Text,TariRowid:%String") [ SqlProc ]
{
}

//根据别名查询医嘱项目

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetArcName","","纯音")	

Query GetArcName(Cate As %Text, ARCIMDesc As %Text) As %Query(ROWSPEC = "ArcimDR:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod GetArcNameExecute(ByRef qHandle As %Binary, Cate As %Text, ARCIMDesc As %Text) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	d SplitMulitData5(Cate,,.CateData)
 	;q:Cate="" $$$OK
 	q:ARCIMDesc="" $$$OK
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ItemCate=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",10)
	..s OrCate=$p($g(^ARC("IC",ItemCate)),"^",8) 
	..;q:$F(","_Cate_",",","_OrCate_",")=0
	...//判断类型是否为所选分类
	...q:(Cate'="")&&(OrCate="") 
	...q:(Cate'="")&&('$d(CateData(OrCate)))    
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s Desc=ArcimDesc
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..q:ArcimDesc'[ARCIMDesc
	..//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	..Do OutputRow9
 
	Quit $$$OK
OutputRow9
	set Data=$lb(ArcimDR,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SplitMulitData5(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetArcNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcNameExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArcNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//区间选择查询

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetKPIMonth")	

ClassMethod GetKPIMonthExecute(ByRef qHandle As %Binary) As %Status
{
	
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s sectionId=""
    f  s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId)) q:sectionId=""  d
    .s secName=$LIST(^DHCWL.MKPI.SectionD(sectionId),4)
    .s monthId=""
    .f  s monthId=$o(^DHCWL.MKPI.MonthsI("SectionFlag",sectionId,monthId)) q:monthId=""  d
    ..s monDesc=$LIST(^DHCWL.MKPI.MonthsD(monthId),3)
	..d OutputRow10
 	q $$$OK	
OutputRow10
    s fl=$E(monDesc,1,4)
    s Data=$lb(fl,sectionId,secName,monthId,monDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetKPIMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPIMonth() As %Query(ROWSPEC = "fl:%String,sectionId:%Integer,secName:%String,monthId:%Integer,monDesc:%String") [ SqlProc ]
{
}

//指标选择查询

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetKPI")	

ClassMethod GetKPIExecute(ByRef qHandle As %Binary, Medicare As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s mkpiId=""
    f  s mkpiId=$o(^DHCWL.MKPI.MKPIFLD(mkpiId)) q:mkpiId=""  d
    .s mkpiName=$LIST(^DHCWL.MKPI.MKPIFLD(mkpiId),3)
    .s kpiId=""
    .f  s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICate",mkpiId,kpiId)) q:kpiId=""  d
    ..s kpiDesc=$LIST(^DHCWL.MKPI.MKPID(kpiId),3)
	..d OutputRow11
 	q $$$OK	
OutputRow11
    s Data=$lb(mkpiId,mkpiName,kpiId,kpiDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPI() As %Query(ROWSPEC = "mkpiId:%Integer,mkpiName:%String,kpiId:%Integer,kpiDesc:%String") [ SqlProc ]
{
}

//执行科室信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCtloc")	

ClassMethod GetCtlocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s loc=""
    f  s loc=$o(^CTLOC(loc))  q:loc=""   d 
    .s loctype=$P($G(^CTLOC(loc)),"^",13)  
    .q:((loctype'="E") && (loctype'="OP"))
    .s desc=$P($G(^CTLOC(loc)),"^",2)  
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .q:depDesc["停用"
    .e  s depDesc=desc
    .d OutputRow14
   
 	q $$$OK	

OutputRow14
    s type="执行科室"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtloc() As %Query(ROWSPEC = "type:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetSfxmZflCFG")	

ClassMethod GetSfxmZflCFGExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    
    //统计项目(子分类)配置
    s RowidXm="",RowidXmsub="",RowidXmsubDetsub=""
    f  s RowidXm=$o(^DHCWLSTAT(RowidXm)) q:RowidXm=""  d
    .q:RowidXm=0
    .s fl1xm="xm"
    .s fl2xm=$p(^DHCWLSTAT(RowidXm),"^",2) ;门诊分类
    .s fl3xm="dat"
    .s fl4xm=$p(^DHCWLSTAT(RowidXm),"^",4) ;"TOC"
   
    .i fl4xm="TAC" d
    ..s fl4nm="会计子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TarCid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",6)
    ....s TarCDesc=$p(^DHCTarC("AC",TarCid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TarCid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TarCid_"^"_TarCDesc
    
    .i fl4xm="TSC" d  
    ..s fl4nm="收费项目子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TSCid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",11)
    ....s TSCDesc=$p(^DHCTarC("SC",TSCid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TSCid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TSCid_"^"_TSCDesc
    
    .i fl4xm="TOC" d
    ..s fl4nm="门诊子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TOCid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",10)
    ....s TOCDesc=$p(^DHCTarC("OC",TOCid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TOCid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TOCid_"^"_TOCDesc
    
    .i fl4xm="TEC" d
    ..s fl4nm="核算子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TECid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",7)
    ....s TECDesc=$p(^DHCTarC("EC",TECid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TECid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TECid_"^"_TECDesc
    
    .i fl4xm="TIC" d  
    ..s fl4nm="住院子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TICid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",8)
    ....s TICDesc=$p(^DHCTarC("IC",TICid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TICid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TICid_"^"_TICDesc
    
    .i fl4xm="TMC" d 
    ..s fl4nm="病历首页子分类"
    ..s fl2nm=fl2xm_"["_fl4nm_"]"
    ..f  s RowidXmsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)) q:RowidXmsub=""  d
    ...q:RowidXmsub=0
    ...s DKName=$P($G(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub)),"^",2)
    ...f  s RowidXmsubDetsub=$o(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)) q:RowidXmsubDetsub=""  d
    ....q:RowidXmsubDetsub=0
    ....s TMCid=$p($g(^DHCWLSTAT(RowidXm,"ITEM",RowidXmsub,"DETAIL",RowidXmsubDetsub)),"^",9)
    ....s TMCDesc=$p(^DHCTarC("MC",TMCid),"^",2)  
    ....s ^temp($j,fl1xm,fl3xm,fl4xm,DKName,TMCid)=RowidXm_"^"_fl2nm_"^"_RowidXmsub_"^"_DKName_"^"_TMCid_"^"_TMCDesc
    
    s flcode=0 f  s flcode=$o(^temp($j,flcode)) q:flcode=""  d
    .s flb=0 f  s flb=$o(^temp($j,flcode,flb)) q:flb=""  d
    ..s flbz=0 f  s flbz=$o(^temp($j,flcode,flb,flbz)) q:flbz=""  d
    ...s dks=0 f  s dks=$o(^temp($j,flcode,flb,flbz,dks)) q:dks=""  d
    ....s loc=0 f  s loc=$o(^temp($j,flcode,flb,flbz,dks,loc)) q:loc=""  d
    .....s flm=$g(^temp($j,flcode,flb,flbz,dks,loc))
    .....s mcid=$p(flm,"^",1)
    .....s pzmc=$p(flm,"^",2)
    .....s pzid=$p(flm,"^",3)
    .....s pzks=$p(flm,"^",4)
    .....s dpdr=$p(flm,"^",5)
    .....s dpna=$p(flm,"^",6)
    .....d OutputRow15
    k ^temp($j)
 	q $$$OK	
 	  	
OutputRow15 
    i ((flbz="TAC") || (flbz="TSC")||(flbz="TOC") ||(flbz="TEC") ||(flbz="TMC") ||(flbz="TIC")) d
    .s flbz1="5" 
    .s flname="统计子项配置"  
  	;s Data=$lb(Rowid,flname,Rowidsub,DKName,CTLOCDR,DepName)
    s Data=$lb(flbz1,flbz,flname,mcid,pzmc,pzid,pzks,dpdr,dpna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetSfxmZflCFGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSfxmZflCFGExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSfxmZflCFGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSfxmZflCFGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSfxmZflCFG() As %Query(ROWSPEC = "flbz1:%String,flbz:%String,flname:%String,mcid:%Integer,pzmc:%String,pzid:%String,pzks:%String,dpdr:%String,dpna:%String")
{
}

//挂号配置科室信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetRegPZDepXX")	

ClassMethod GetRegPZDepXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    s Dkloc=0  f  s Dkloc=$o(^DHCCTLoc(Dkloc)) q:Dkloc=""   d 
    .s Dkcode=$p(^DHCCTLoc(Dkloc),"^",1)
    .s sub="" f  s sub=$o(^DHCCTLoc(Dkloc,"MINOR",sub)) q:sub=""  d
    ..s active=$p(^DHCCTLoc(Dkloc,"MINOR",sub),"^",2) ;q:(active'=1)
    ..s loc=$p(^DHCCTLoc(Dkloc,"MINOR",sub),"^",1)
    ..q:(active'=1)&(loc'=41)
    ..s hosp=$P($G(^CTLOC(loc)),"^",22)
	..i hosp=""  s hosp=3
	..s hospna=$p(^CT("HOSP",hosp),"^",2) 
	..s desc=$P($G(^CTLOC(loc)),"^",2)  
    ..i desc [ "-" s depDesc=$p(desc,"-",2)
    ..q:depDesc["停用"
    ..e  s depDesc=desc
    ..i loc=41 s loc=2158,depDesc="国际医疗部急诊留观"
    ..d OutputRow16
    k ^temp($j)
 	q $$$OK	

OutputRow16
    
    s Data=$lb(hosp,hospna,Dkloc,Dkcode,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetRegPZDepXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegPZDepXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRegPZDepXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegPZDepXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRegPZDepXX() As %Query(ROWSPEC = "hosp:%String,hospna:%String,Dkloc:%String,Dkcode:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

//医护人员信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCtpcp","yy")	

ClassMethod GetCtpcpExecute(ByRef qHandle As %Binary, bm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:bm="" $$$OK
 	
    s bm=$zcvt(bm,"U")
    s ctprowid=0 f  s ctprowid=$o(^CTPCP(ctprowid)) q:ctprowid=""  d
    .s othername=$p($g(^CTPCP(ctprowid,3)),"^",28) q:othername=""
    .q:$zcvt(othername,"U")'[bm
    .s code=$p(^CTPCP(ctprowid,1),"^",1) 
    .s desc=$p(^CTPCP(ctprowid,1),"^",2) 
    .d OutputRow17

 	q $$$OK	

OutputRow17
    
    s Data=$lb(ctprowid,code,desc,othername)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtpcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtpcpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtpcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtpcpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtpcp(bm As %String) As %Query(ROWSPEC = "ctprowid:%Integer,code:%String,desc:%String,othername:%String") [ SqlProc ]
{
}

//用户科室权限信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetRegPZDepXX2","7","03066")	

ClassMethod GetRegPZDepXX2Execute(ByRef qHandle As %Binary, mbflId As %String, user As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    s loc="",code=""
	s Dayrowid=0 f  s Dayrowid=$o(^DHCWL.MKPI.DayI("KPIMDCalFlag",mbflId,Dayrowid))  q:Dayrowid=""  d
	.s code=$li(^DHCWL.MKPI.DayD(Dayrowid),2) q:code'=user
	.s flag=$li(^DHCWL.MKPI.DayD(Dayrowid),7) q:flag'="Y"
	.s loc=$li(^DHCWL.MKPI.DayD(Dayrowid),12) 
	
	s multiLen=$l(loc,",")
	f len=1:1:multiLen d
	.s dep=$p(loc,",",len)
	.q:dep=""
    .s hosp=$P($G(^CTLOC(dep)),"^",22)
	.i hosp=""  s hosp=3
	.s hospna=$p(^CT("HOSP",hosp),"^",2) 
	.s desc=$P($G(^CTLOC(dep)),"^",2)  
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .e  s depDesc=desc
    .d OutputRow18
    k ^temp($j)
 	q $$$OK	

OutputRow18
    
    s Data=$lb(hosp,hospna,dep,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

ClassMethod GetRegPZDepXX2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegPZDepXX2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRegPZDepXX2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegPZDepXX2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRegPZDepXX2(mbflId As %String, user As %String) As %Query(ROWSPEC = "hosp:%String,hospna:%String,dep:%String,depDesc:%String") [ SqlProc ]
{
}

//用户科室权限信息获取(获取国际特需科室)

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetRegPZDepXX3","7","03066")	

ClassMethod GetRegPZDepXX3Execute(ByRef qHandle As %Binary, mbflId As %String, user As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    s loc="",code=""
	s Dayrowid=0 f  s Dayrowid=$o(^DHCWL.MKPI.DayI("KPIMDCalFlag",mbflId,Dayrowid))  q:Dayrowid=""  d
	.s code=$li(^DHCWL.MKPI.DayD(Dayrowid),2) q:code'=user
	.s flag=$li(^DHCWL.MKPI.DayD(Dayrowid),7) q:flag'="Y"
	.s loc=$li(^DHCWL.MKPI.DayD(Dayrowid),12) 
	
	s multiLen=$l(loc,",")
	f len=1:1:multiLen d
	.s dep=$p(loc,",",len)
	.q:dep=""
	.s desc=$P($G(^CTLOC(dep)),"^",2)  
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .e  s depDesc=desc
    .i depDesc["国际" s DKna="国际",DKId=1
    .i depDesc["特需" s DKna="特需",DKId=2
    .d OutputRow181
    k ^temp($j)
 	q $$$OK	

OutputRow181
    
    s Data=$lb(DKId,DKna,dep,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

ClassMethod GetRegPZDepXX3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegPZDepXX3Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRegPZDepXX3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegPZDepXX3Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRegPZDepXX3(mbflId As %String, user As %String) As %Query(ROWSPEC = "DKId:%String,DKna:%String,dep:%String,depDesc:%String") [ SqlProc ]
{
}

//床位维护科室信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCwWhDepXX")	

ClassMethod GetCwWhDepXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    s locid=0  f  s locid=$o(^PAC("ADMLOC",0,"AdmType","I",locid)) q:locid=""   d 
	.s desc=$P($G(^CTLOC(locid)),"^",2)  
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .q:depDesc["停用"
    .e  s depDesc=desc
    .d OutputRow1666
    k ^temp($j)
 	q $$$OK	

OutputRow1666
    
    s Data=$lb(locid,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhDepXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhDepXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhDepXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhDepXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhDepXX() As %Query(ROWSPEC = "locid:%String,depDesc:%String") [ SqlProc ]
{
}

//床位维护病区信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCwWhwardXX")	

ClassMethod GetCwWhwardXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    s wardid=0  f  s wardid=$o(^PAWARD(wardid)) q:wardid=""   d 
	.s desc=$P($G(^PAWARD(wardid)),"^",2)  
    .i desc [ "-" s WardDesc=$p(desc,"-",2)
    .q:WardDesc["停用"
    .e  s WardDesc=desc
    .q:(wardid["BED")||(WardDesc["test")
    .d OutputRow1667
    k ^temp($j)
 	q $$$OK	

OutputRow1667
    
    s Data=$lb(wardid,WardDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhwardXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhwardXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhwardXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhwardXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhwardXX() As %Query(ROWSPEC = "wardid:%String,WardDesc:%String") [ SqlProc ]
{
}

//科室信息获取

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetPyCtloc","yy")	

ClassMethod GetPyCtlocExecute(ByRef qHandle As %Binary, bm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:bm="" $$$OK
 	
    s bm=$zcvt(bm,"U")
    s ctprowid=0 f  s ctprowid=$o(^CTLOC(ctprowid)) q:ctprowid=""  d
    .s othername=$p($g(^CTLOC(ctprowid)),"^",43) q:othername=""
    .q:$zcvt(othername,"U")'=bm
    .s code=$p(^CTLOC(ctprowid),"^",1) 
    .s desc=$p(^CTLOC(ctprowid),"^",2) 
    .d OutputRowLoc17

 	q $$$OK	

OutputRowLoc17
    
    s Data=$lb(ctprowid,code,desc,othername)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPyCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPyCtlocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPyCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPyCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPyCtloc(bm As %String) As %Query(ROWSPEC = "ctprowid:%Integer,code:%String,desc:%String,othername:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunQianQueryDHCWLArg","GetCtlocXX11")	

ClassMethod GetCtlocXX11Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
    .s c=$P(^CTLOC(rw),"^",2)
 	.s locTyp=$P(^CTLOC(rw),"^",13)
	.q:c["停用"
	.q:c=""
	.q:locTyp="W"
	.s ADMLOCI=$O(^PAC("ADMLOC",0,"AdmType","I",rw,""))
	.s ADMLOCH=$O(^PAC("ADMLOC",0,"AdmType","H",rw,""))
	.q:((ADMLOCI="")&&(ADMLOCH=""))
	.s ContactName=$P(^CTLOC(rw),"^",43)
	.q:ContactName=""
    .i $d(^CTLOC(rw)) d
    ..s DepName1=$P($G(^CTLOC(rw)),"^",2)  
    ..i DepName1 [ "-" s DepName=$p(DepName1,"-",2)
    ..e  s DepName=DepName1
    ..d OutputRow311
   
 	q $$$OK	

OutputRow311
    s Data=$lb(rw,DepName)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocXX11Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocXX11Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtlocXX11Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocXX11Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtlocXX11() As %Query(ROWSPEC = "rw:%String,DepName:%String") [ SqlProc ]
{
}

//科室信息获取

//d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtlocXX2")	

ClassMethod GetCtlocXX2Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s flag=0
    f  s flag=$o(^PAC("ADMLOC",0,"AdmType",flag))  q:flag=""   d 
    .s loc=0
    .f  s loc=$o(^PAC("ADMLOC",0,"AdmType",flag,loc))  q:loc=""   d 
    ..i $d(^CTLOC(loc)) d
    ...s desc=$P($G(^CTLOC(loc)),"^",2)  
    ...i desc [ "-" s depDesc=$p(desc,"-",2)
    ...e  s depDesc=desc
    ...d OutputRow19
   
 	q $$$OK	

OutputRow19
    i flag="I" s type="住院科室"
    i flag="O" s type="门诊科室"
    i flag="E" s type="急诊科室"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocXX2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocXX2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCtlocXX2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocXX2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtlocXX2() As %Query(ROWSPEC = "type:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

}
