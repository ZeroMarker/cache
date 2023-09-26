Import sqluser

Class web.DHCINSUTarConTar Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// change by yjz  20081022

Parameter BUILD = 1;

ClassMethod Update(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %Library.String
{
	q:InString="" -100
	s flag=$$SaveCont^DHCINSUTarConTar(InString)
	s Update=flag
	q Update
}

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", ContId As %Library.String = "")
{
	s flag=$$DeleteCont^DHCINSUTarConTar(ContId)
	q flag
}

// 根据虚拟收费项ID删除对照关系

ClassMethod DeleteAllCon(vsTarId As %Library.String = "")
{
	s flag=$$DeleteContAll^DHCINSUTarConTar(vsTarId)
	q flag
}

ClassMethod GetTarCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarCateExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetTarCateExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid="0"
	f  s rowid=$o(^DHCTarC("CC",rowid)) q:rowid=""  d
	.s s=$g(^DHCTarC("CC",rowid))
	.s code=$p(s,"^",1)
	.s desc=$p(s,"^",2)
	.d BuildTarCate
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCate      
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetTarCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarCateExecute ]
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

Query GetTarCate() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod DhcTarQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DhcTarQuery1Execute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DhcTarQuery1Execute(ByRef qHandle As %Binary, sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String, ActDate, HospDr) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	;i Type="" goto L1 
	s vsStr=""  
	;s ^AAA(1)=sKeyWord_"  - "_Class_"  - "_Type_"  - "_ConType_"  - "_TarCate
	;s:ActDate'="" ActDate=$zd(ActDate,3)
	s:($g(%session)'="")&&(+$g(HospDr)=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s:ActDate'="" ActDate=##class(websys.Conversions).DateLogicalToHtml(ActDate)	;Zhan 20170313
	s flag=$$QueryAll^DHCINSUTarConTar(sKeyWord,Class,Type,TarCate,ActDate,HospDr)
	s xcode=""
	f  s xcode=$o(^CacheTemp("TAR",flag,xcode)) q:xcode=""  d
	.s TarId="",HisCode="",HisDesc="",DW="",SubCate="",Price="",ConId="",vsId="",vsHisCode="",vsHisDesc="",conActDate=""
	.s s=$g(^CacheTemp("TAR",flag,xcode))
	.s TarId=$p(s,"^",1)
	.s s=$g(^DHCTARI(+TarId))
	.s HisCode=$p(s,"^",1)
	.s HisDesc=$p(s,"^",2)
	.s TarUom=$p(s,"^",3)
	.s TarSubcate=$p(s,"^",4)
	.s:TarUom'="" DW=$p($g(^CT("UOM",TarUom)),"^",2)
	.s:TarSubcate'="" SubCate=$p($g(^DHCTarC("SC",TarSubcate)),"^",2)
	.s Price=##class(web.UDHCJFPRICE).GetItmPrice(TarId,$h,"","","",HospDr)
	.s Price=$p(Price,"^",1)
	.;若查询未对照，则在对照表有内容的情况下推出循环 
	.i ($d(^DHCITCT("0","TarDr",TarId))=0) d
	..i ((ConType="A")!(ConType="N"))  d
	...d Build
	.e   d
	..f  s vsId=$o(^DHCITCT("0","TarDr",TarId,vsId),-1)  q:vsId=""  d
	...q:(ConType="N")
	...s vsStr=$g(^DHCITCT(vsId))
	...s ConId=$p(vsStr,"^",3)
	...s vsHisCode=$p(vsStr,"^",4)
	...s vsType=$p(vsStr,"^",5)
	...s conActDate=$p(vsStr,"^",6)
	...s vsHisDesc=$p($g(^DHCTARI(ConId)),"^",2)
	...q:((vsType'=Type)&(Type'=""))
	...d Build
	k ^CacheTemp("TAR",flag)
L1	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	;+2019-7-30 tangzf 医院授权判断 start
	s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarItem",TarId,HospDr,"","Y")
	q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	;+2019-7-30 tangzf 医院授权判断 end
	set Data=$lb(TarId,HisCode,HisDesc,DW,SubCate,Price,ConId,vsId,vsHisCode,vsHisDesc,conActDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DhcTarQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DhcTarQuery1Execute ]
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

Query DhcTarQuery1(sKeyWord As %String, Class As %String, Type As %String, ConType As %String, TarCate As %String, ActDate) As %Query(ROWSPEC = "TarId:%String,HisCode:%String,HisDesc:%String,DW:%String,SubCate:%String,Price:%String,ConId:%String,vsId:%String,vsHisCode:%String,vsHisDesc:%String,conActDate:%String")
{
}

ClassMethod QueryallClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryallExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryallExecute(ByRef qHandle As %Binary, vsQuery As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0
	s vsQuery=$$ALPHAUP^SSUTIL4(vsQuery)
	i vsQuery=""  d
	.f  s rowid=$o(^DHCTARI(rowid))  q:rowid=""  d
	..s code=$p(^DHCTARI(+rowid),"^",1)
	..s desc=$p(^DHCTARI(+rowid),"^",2)
	..d BuildTarCate1
	e  d
	.f  s rowid=$o(^DHCTARAL("A",0,"Desc",vsQuery,rowid))  q:rowid=""  d
	..s s=$g(^DHCTARI(+rowid))
	..s code=$p(s,"^",1)
	..s desc=$p(s,"^",2)
	..d BuildTarCate1
	.s Desc=vsQuery
	.s rowid=0
	.f  s Desc=$o(^DHCTARAL("A",0,"Desc",Desc)) q:(Desc="")!(Desc'[vsQuery)  d
	..f  s rowid=$o(^DHCTARAL("A",0,"Desc",Desc,rowid)) q:rowid=""  d
	...s s=$g(^DHCTARI(+rowid))
	...s code=$p(s,"^",1)
	...s desc=$p(s,"^",2)
	...d BuildTarCate1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCate1     
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryallFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryallExecute ]
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

Query Queryall(vsQuery As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

/// 将本地医保和自费项插入收费项目表
/// InString =Tarid^Type  Tarid 项目code  ，Type 项目类型
/// 正确返回0
/// w ##class(web.DHCINSUTarConTar).TarChange("","","ZZS000002^3^LLL^北京市医保",2)
ClassMethod TarChange(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", HospDr) As %Library.String
{
   
	s Tarid=$p(InString,"^",1)
	s Type=$p(InString,"^",2)
	s newcode=$p(InString,"^",3)
	s INSUType=$p(InString,"^",4)
	s ^CacheTemp("TarChange")=$lb(InString,HospDr)
	s:($g(%session)'="")&&(+$g(HospDr)=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	;q:'((Type="02")!(Type="03")!(Type="04")!(Type="05")!(Type="06")) -100
	q:Tarid="" -100
	;s flag=$$InsertTarItem^DHCINSUTarConTar(Tarid,Type)
	s ExpStr=HospDr_"^"_INSUType //tangzf 2020-5-28
	s flag=$$InsertTarItem^DHCINSUTarConTar(Tarid,Type,newcode,ExpStr)
	q flag
}

/// 取本地对照ROWID
/// TarId：dhc_taritem的rowid; Type：对照类别：基本医疗 01 限制用药 02 自费 03 
/// 对照的rowid
/// w ##class(web.DHCINSUTarConTar).QueryTarConId("7799", "01")
ClassMethod QueryTarConId(TarId As %String, Type As %String, HospDr) As %String
{
	q:TarId="" ""
	q:Type="" TarId
	q:Type="01" TarId
	s Outstr=""
	s Rowid=""
	s:($g(%session)'="")&&(+$g(HospDr)=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSUTarConTar",HospDr) //tangzf 2020-5-28
	q:$d(^DHCITCT("0","TarDr",TarId))=0 ""   ;当自费处理
	b ;//s ^liusf(TarId)=Rowid
	f  s Rowid=$o(^DHCITCT("0","TarDr",TarId,Rowid))  q:Rowid=""  d
	.s s=^DHCITCT(+Rowid)
	.s DataHospDr=$p(s,"^",9)
	.q:DataHospDr'=GroupHospDr
	.s Contype=$p(s,"^",5)
	.q:Contype'=Type
	.s Outstr=$p(s,"^",3)
	q Outstr
}

/// 删除收费项目表中数据  add by yjz_20081105
/// InString =Tarid 
/// 正确返回0
/// w ##class(web.DHCINSUTarConTar).TarDelete("","","10110211")
ClassMethod TarDelete(itmjs As %Library.String = "", itmjsex As %Library.String = "", TarId As %Library.String = "", HospDr) As %Library.String
{
	q:TarId="" -100
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSUTarConTar",HospDr) //tangzf 2020-5-28
	s flag=$$DeleteTarItem^DHCINSUTarConTar(TarId,GroupHospDr)
	q flag
}

/// 目录对照数据导入
/// w ##class(web.DHCINSUTarConTar).SaveInCont("") 
ClassMethod SaveInCont(Instring As %Library.String) As %Library.String
{
	n (Instring)
	q:Instring="" -1
	s hiscode=$p(Instring,"^",2)
	s TShiscode=$p(Instring,"^",3)
	s type=$p(Instring,"^",4)
	s HospDr=$p(Instring,"^",5)
	s:($g(%session)'="")&&(+$g(HospDr)=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSUTarConTar",HospDr) //tangzf 2020-5-28
	s ActiveDate=+$h
	q:hiscode="" -1011
	q:TShiscode="" -1021
	s hiscode2=$$ALPHAUP^SSUTIL4(hiscode) ;去掉数字字母之外的字符 2008 10 15
	s TShiscode2=$$ALPHAUP^SSUTIL4(TShiscode) ;去掉数字字母之外的字符 2008 10 15
	q:($d(^DHCTARI(0,"Code",hiscode))=0)&($d(^DHCTARI(0,"Code",hiscode2))=0) -1012
	q:($O(^DHCTARI("0","CODE",TShiscode))=0)&($O(^DHCTARI("0","CODE",TShiscode2))=0) -1022
	s Tarid=""
	s TmpTarid=""
	f  s TmpTarid=$o(^DHCTARI(0,"Code",hiscode2,TmpTarid)) q:TmpTarid=""  d
	.s TarDesc=$p($g(^DHCTARI(TmpTarid)),"^",2)
	.s TarCode=$p($g(^DHCTARI(TmpTarid)),"^",1)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarItem",TmpTarid,HospDr,"","Y")
	.q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.i TarCode=hiscode d
	..s Tarid=TmpTarid
	q:Tarid="" -1013
	s TSTarid=""
	s TmpTarid=""
	f  s TmpTarid=$o(^DHCTARI(0,"Code",TShiscode2,TmpTarid)) q:TmpTarid=""  d
	.s TarDesc=$p($g(^DHCTARI(TmpTarid)),"^",2)
	.s TarCode=$p($g(^DHCTARI(TmpTarid)),"^",1)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s CheckHosipitalSession=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("DHC_TarItem",TmpTarid,HospDr,"","Y")
	.q:(CheckHosipitalSession'="Y") ; 该院区无权查看该数据
	.;+2019-7-30 tangzf 医院授权判断 end
	.i TarCode=TShiscode d
	..s TSTarid=TmpTarid
	q:TSTarid="" -1013
	s XString=""
	s $p(XString,"^",1)=""
	s $p(XString,"^",2)=Tarid
	s $p(XString,"^",3)=hiscode
	s $p(XString,"^",4)=TSTarid
	s $p(XString,"^",5)=TShiscode
	s $p(XString,"^",6)=type
	s $p(XString,"^",7)="" ;ActiveDate
	s $p(XString,"^",8)=""
	s $p(XString,"^",9)=""
	s $p(XString,"^",10)=HospDr //tangzf 2020-5-28
	s flag=..Update("","",XString)
	s CheckInCont=flag
	q CheckInCont
}

Query QueryTarInfo(InArgs As %String) As websys.Query(ROWSPEC = "code,desc,TarUomDesc,TarPrice,TarActiveFlag,TarSubCateDesc,TarAcctCateDesc,TarInpatCateDesc,TarOutpatCateDesc,TarEMCCateDesc,TarMRCateDesc,TarNewMRCateDesc,TarSpecialFlag,TarExternalCode,TarChargeBasis,TarInsuIPName,TarInsuOPName,TarEngName,rowid,SubCate,AccCate,IcCate,OcCate,EcCate,MrCate,NewMrCate")
{
}

/// 查询HIS收费项目
/// d ##class(%ResultSet).RunQuery("web.DHCINSUTarConTar","QueryTarInfo","")
ClassMethod QueryTarInfoExecute(ByRef qHandle As %Binary, InArgs As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s sKeyWord=$p(InArgs,"@",1)
	s Class=$p(InArgs,"@",2)
	s Type=$p(InArgs,"@",3) // 项目类型
	s ConType=$p(InArgs,"@",4)
	s spFlag=$p(InArgs,"@",5)	//虚拟收费项标志Y
	s InsuType=$p(InArgs,"@",6)
	s HospDr=$p(InArgs,"@",7) //tangzf 2020-5-28 add //收费项查询 调用平台组接口判断
	s TypeDesc=$p(InArgs,"@",8) //DingSH 2020-8-26 add 
	//s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSUTarConTar",HospDr)
	s ^CacheTemp("SpecialQueryTarInfo")=$lb(InArgs)
	s:"YN"'[spFlag spFlag="N"
	//s:ActDate'="" ActDate=$zdh(ActDate,3)
	s ActDate=+$h
	s (code,desc,alias,str)=""
	s:Class=1 alias=sKeyWord
	s:Class=2 code=sKeyWord
	s:Class=3 desc=sKeyWord
    set ^CacheTemp("INSUDHCTarQuery")=$p($h,",",2)
    // 使用对照的查询  提高查询效率
    s flag=$$QueryAll^DHCINSUTarContrast(sKeyWord,Class,InsuType,"A","",ActDate,HospDr) //此处对照类型写死，在后边程序中过滤
	s:Class="4" sKeyWord=##class(websys.Conversions).DateLogicalToHtml(sKeyWord) ;Zhan 20170309	
	s id=""
	b ;w "查询出的数据在:^CacheTemp(TAR,"_flag_",  临时globla节点下。",!
	f  s id=$o(^CacheTemp("TAR",flag,id)) q:id=""  d
	.s s=$g(^CacheTemp("TAR",flag,id))
    .d selectRow(id)
    .d GetTariInfo(HospDr)
    k ^CacheTemp("TAR",flag)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
selectRow(row)
	k PLIST
	s s=$g(^DHCTARI(+row))
	s code1=$p(s,"^",1),desc1=$p(s,"^",2),uom1=$p(s,"^",3)
	i uom1'="" d  s uom1=$p(^CT("UOM",uom1),"^",2)
	s sfcate1=$p(s,"^",4)
	i sfcate1'="" d  s sfcate1=$p($g(^DHCTarC("SC",sfcate1)),"^",2)
	s kjcate1=$p(s,"^",5) 
	i kjcate1'="" d  s kjcate1=$p($g(^DHCTarC("AC",kjcate1)),"^",2)
	s zycate1=$p(s,"^",14)
	i zycate1'="" d  s zycate1=$p($g(^DHCTarC("IC",zycate1)),"^",2)
	s mzcate1=$p(s,"^",15)
	i mzcate1'="" d  s mzcate1=$p($g(^DHCTarC("OC",mzcate1)),"^",2)
	s hscate1=$p(s,"^",16)
	i hscate1'="" d  s hscate1=$p($g(^DHCTarC("EC",hscate1)),"^",2)
	s blcate1=$p(s,"^",6)
	i blcate1'="" d  s blcate1=$p($g(^DHCTarC("MC",blcate1)),"^",2)
	s blcatenew=$p(s,"^",30)
	i blcatenew'="" d  s blcatenew=$p($g(^DHCTarC("MCNew",blcatenew)),"^",2)  ;新病案首页分类

	i row'="" s TICSubRowid=$o(^DHCTARITEMCATSUBi(0,"TARI",row,"")) //2009-3-3 add by wanghuicai
	i $g(TICSubRowid)'="" s insuIP1=$p(^DHCTARITEMCATSUB(TICSubRowid,"IP"),"^",1)  
	i $g(insuIP1)'="" s insuIPdesc=$p(^DHCTarC("IIC",insuIP1),"^",2)
	i $g(TICSubRowid)'="" s insuOP1=$p(^DHCTARITEMCATSUB(TICSubRowid,"OP"),"^",1)  
	i $g(insuOP1)'="" s insuOPdesc=$p(^DHCTarC("IOC",insuOP1),"^",2)

	s specialflag=$p(s,"^",17)
	s activeflag=$p(s,"^",7),externalcode=$p(s,"^",13),rowid=row
	s curprice=+##class(web.UDHCJFPRICE).GetItmPrice(row,+$h,"","","",HospDr)
	s engname=$p(s,"^",19)
	s chargebasis1=$p(s,"^",20)
	s PLIST(1)=code1
	s PLIST(2)=desc1
	s PLIST(3)=uom1
	s PLIST(4)=$g(curprice)

	s PLIST(5)=sfcate1
	s PLIST(6)=kjcate1
	s PLIST(7)=zycate1
	s PLIST(8)=mzcate1
	s PLIST(9)=hscate1
	s PLIST(10)=blcate1
	s PLIST(11)=specialflag
	s PLIST(12)=activeflag
	s PLIST(13)=externalcode
	s PLIST(14)=rowid
	s PLIST(15)=ind
	s PLIST(16)=$G(chargebasis1)
	s PLIST(17)=$G(engname)
	s PLIST(18)= $g(insuIPdesc)    ;2009-3-3 add by wanghuicai
	s PLIST(19)= $g(insuOPdesc)
	s PLIST(20)=$G(blcatenew) ;新病案首页分类
	s PLIST=$o(PLIST(""),-1)
	q 0   
       	
GetTariInfo(HospDr)
	Set (code1,desc1,TarUomDesc,TarPrice,TarActiveFlag,TarSubCateDesc,TarAcctCateDesc,TarInpatCateDesc,TarOutpatCateDesc,TarEMCCateDesc,TarMRCateDesc,TarNewMRCateDesc,TarSpecialFlag,TarExternalCode,TarChargeBasis,TarInsuIPName,TarInsuOPName,TarEngName,rowid,SubCate,AccCate,IcCate,OcCate,EcCate,MrCate,NewMrCate)=""
	Quit:$d(PLIST)=0
	Set code1=PLIST(1)
	Set desc1=PLIST(2)
	q:(desc1'[TypeDesc)&&(TypeDesc'="")
	Set TarUomDesc=PLIST(3)
	Set TarPrice=PLIST(4)
	Set TarPrice=$fn(TarPrice,"",2)
	Set TarActiveFlag=PLIST(12)
	Set TarSubCateDesc=PLIST(5)
	Set TarAcctCateDesc=PLIST(6)
	Set TarInpatCateDesc=PLIST(7)
	Set TarOutpatCateDesc=PLIST(8)
	Set TarEMCCateDesc=PLIST(9)
	Set TarMRCateDesc=PLIST(10)
	Set TarNewMRCateDesc=PLIST(20)
	Set TarSpecialFlag=PLIST(11)
	q:(TarSpecialFlag'=spFlag)&&(spFlag'="")
	Set TarExternalCode=PLIST(13)
	Set TarChargeBasis=PLIST(16)
	Set TarInsuIPName=PLIST(18)
	Set TarInsuOPName=PLIST(19)
	Set TarEngName=PLIST(17)
	Set rowid=PLIST(14)
	i ConType'="A" 
	{
		s vsId="",tmpcontype=""
		f  s vsId=$o(^DHCITCT("0","TarDr",rowid,vsId),-1)  q:vsId=""  d
		.s vsStr=$g(^DHCITCT(vsId))
		.s vsType=$p(vsStr,"^",5)
		.b ;s ^zmc(88)=vsStr_"_"_InArgs
		.q:((vsType'=Type)&(Type'=""))
		.s coninsutype=$p(vsStr,"^",7)
		.q:(coninsutype'="")&(coninsutype'=InsuType)
		.s tmpcontype="Y"
		q:(ConType="N")&(tmpcontype="Y")
		q:(ConType="Y")&(tmpcontype'="Y")
	}
	If TarSubCateDesc'="" Set SubCate=$o(^DHCTarC("SC",0,"Desc",TarSubCateDesc,""))
	If TarAcctCateDesc'="" Set AccCate=$o(^DHCTarC("AC",0,"Desc",TarAcctCateDesc,""))
	If TarInpatCateDesc'="" Set IcCate=$o(^DHCTarC("IC",0,"Desc",TarInpatCateDesc,""))
	If TarOutpatCateDesc'="" Set OcCate=$o(^DHCTarC("OC",0,"Desc",TarOutpatCateDesc,""))
	If TarEMCCateDesc'="" Set EcCate=$o(^DHCTarC("EC",0,"Desc",TarEMCCateDesc,""))
	If TarMRCateDesc'="" Set MrCate=$o(^DHCTarC("MC",0,"Desc",TarMRCateDesc,""))
	Set NewMrRowid="",NewMrCate=""
	For  Set NewMrRowid=$o(^DHCTarC("MCNew",NewMrRowid)) Quit:NewMrRowid=""  d
	.Set NewMrDesc=$p(^DHCTarC("MCNew",NewMrRowid),"^",2)
	.Quit:NewMrDesc'=TarNewMRCateDesc
	.Set NewMrCate=NewMrRowid
	Set Conf=$o(^DHCTarC("CF",""))
	;Quit:Conf=""
	Set InsType=$p(^DHCTarC("CF",Conf),"^",3)
	Set ExeDate=""
	If HospDr'="" Set ExeDate=$o(^DHCTARIi("HospInsType",rowid,InsType,HospDr,+$h),-1)

	set Data=$lb(code1,desc1,TarUomDesc,TarPrice,TarActiveFlag,TarSubCateDesc,TarAcctCateDesc,TarInpatCateDesc,TarOutpatCateDesc,TarEMCCateDesc,TarMRCateDesc,TarNewMRCateDesc,TarSpecialFlag,TarExternalCode,TarChargeBasis,TarInsuIPName,TarInsuOPName,TarEngName,rowid,SubCate,AccCate,IcCate,OcCate,EcCate,MrCate,NewMrCate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

Query QueryTarConInfo(InArgs As %String) As websys.Query(ROWSPEC = "TarId,HisCode,HisDesc,DW,SubCate,ConId,vsId,vsHisCode,vsHisDesc,conActDate,typedesc,coninsutype")
{
}

/// 查询特殊收费项目对照
/// d ##class(%ResultSet).RunQuery("web.DHCINSUTarConTar","QueryTarConInfo","")
ClassMethod QueryTarConInfoExecute(ByRef qHandle As %Binary, InArgs As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s TarId=$p(InArgs,"@",1)
	s qclass=$p(InArgs,"@",2)
	s Type=$p(InArgs,"@",3)
	s ConType=$p(InArgs,"@",4)
	s InsuType=$p(InArgs,"@",5)
	s HospDr = $p(InArgs,"@",6) // 2020-5-28 add tangzf  
	s:($g(%session)'="")&&(+$g(HospDr)=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSUTarConTar",HospDr)
	s ^zmc(66)=InArgs
	s vsId=""
	f  s vsId=$o(^DHCITCT("0","TarDr",TarId,vsId),-1)  q:vsId=""  d
	.q:(ConType="N")
	.b // tangzf 2020-5-28 add
	.s ConTarHospDr = $p($g(^DHCITCT(vsId)),"^",9)
	.q:GroupHospDr'=ConTarHospDr
	.// tangzf 2020-5-28 add
	.s Tarinfo=$g(^DHCTARI(+TarId))
	.s HisCode=$p(Tarinfo,"^",1)
	.s HisDesc=$p(Tarinfo,"^",2)
	.s DW=$p(Tarinfo,"^",3)
	.s:DW='"" DW=$p(^CT("UOM",DW),"^",2)
	.s SubCate=$p(Tarinfo,"^",5)
	.s vsStr=$g(^DHCITCT(vsId))
	.s ConId=$p(vsStr,"^",3)
	.s vsHisCode=$p(vsStr,"^",4)
	.s vsType=$p(vsStr,"^",5)
	.s typedesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SpeItmType",vsType,4,HospDr)
	.s conActDate=$p(vsStr,"^",6)
	.;s:conActDate'="" conActDate=$zd(conActDate,3)
	.s:conActDate'="" conActDate=##class(websys.Conversions).DateLogicalToHtml(conActDate)
	.s vsHisDesc=$p($g(^DHCTARI(ConId)),"^",2)
	.b ;1234
	.q:((vsType'=Type)&(Type'=""))
	.s coninsutype=$p(vsStr,"^",7)
	.q:(coninsutype'="")&(coninsutype'=InsuType)
	.d Buildcon
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Buildcon
	s:coninsutype'="" coninsutype=##class(web.INSUDicDataCom).GetDicByCodeAndInd("TariType",coninsutype,4,HospDr)
	Set Data=$lb(TarId,HisCode,HisDesc,DW,SubCate,ConId,vsId,vsHisCode,vsHisDesc,conActDate,typedesc,coninsutype)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 将配置的日期 转换成系统配置日期 
/// d ##class(web.DHCINSUTarConTar).getConfigDate()
ClassMethod getConfigDate(HospDr) As %String
{
	s:($g(%session)'="")&&(+HospDr=0) HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s configDate=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","INSUCONACTDATE",6,HospDr)
	s:configDate'="" configDate=##class(websys.Conversions).DateHtmlToLogical(configDate) 
	s:configDate'="" configDate=##class(websys.Conversions).DateLogicalToHtml(configDate) 
	q configDate
}

/// 根据虚拟收费项Dr获取关联的收费项目Dr
/// w ##class(web.DHCINSUTarConTar).GetTarDrByTarConDr("13498","2","00A",2)
/// + 20221121
ClassMethod GetTarDrByTarConDr(TarConDr, TariType, HiType, HospDr)
{
	
	set TarDr=""
	set DITCTRowid="",Flag="N"
	for {
	 set DITCTRowid=$O(^DHCITCT("0","TarConDr",TarConDr,DITCTRowid),-1)
	 quit:(DITCTRowid="")||(Flag="Y")
	 set tmpHospDr=$P(^DHCITCT(DITCTRowid),"^",9)
	 continue:tmpHospDr'=HospDr
	 set tmpTariType=$P(^DHCITCT(DITCTRowid),"^",5)
	 continue:tmpTariType'=TariType
	 set tmpHiType=$P(^DHCITCT(DITCTRowid),"^",7)
	 continue:tmpHiType'=HiType
     set Flag="Y"
	 set TarDr=$P(^DHCITCT(DITCTRowid),"^",1)
	}
	q TarDr
}

}
