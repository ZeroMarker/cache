Import SQLUser

/// 用于设置操作
Class web.DHCCLNURSET Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 101;

ClassMethod SetQueryPara(code, disposeStatStr, orcatStr, oecprStr, ordStatStr, phcinStr, specCodeStr = "", recLoc = "", HospitalRowId = "")
{
	q:(code="")!(HospitalRowId="") -1
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"DisposeStat")=disposeStatStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"OrCat")=orcatStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"OecPr")=oecprStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"OrdStat")=ordStatStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"PhcIn")=phcinStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"Spec")=specCodeStr
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"RecLoc")=recLoc
	q 0
}

Query FindQueryType(HospitalRowId As %String = "", TypeCode As %String = "") As %Query(ROWSPEC = "code,name,filename,byadm,prnframe,prechkdays,tHospitalName,tHospitalRowId")
{
}

ClassMethod FindQueryTypeExecute(ByRef qHandle As %Binary, HospitalRowId As %String = "", TypeCode As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s HospRowId=""
	f  s HospRowId=$o(^DHCCLNurseExec("VarDef",HospRowId)) q:HospRowId=""  d
	.q:(HospitalRowId'="")&(HospRowId'=HospitalRowId)
	.s queryTypeCode=0
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode)) q:queryTypeCode=""  d
	..q:(TypeCode'="")&(TypeCode'=queryTypeCode)
	..s code=queryTypeCode
	..s name=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",1)
    ..s filename=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",2)
    ..s byadm=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",3)
    ..s prnframe=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",4)
    ..s prechkdays=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",5)
	..i HospRowId'=0 s tHospitalName=$p($G(^CT("HOSP",HospRowId)),"^",2)
	..e  s tHospitalName=""
	..s tHospitalRowId=HospRowId
    ..d OutRowtyp1
    s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp1
	s Data=$lb(code,name,filename,byadm,prnframe,prechkdays,tHospitalName,tHospitalRowId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod FindQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FindDispose() As %Query(ROWSPEC = "code,name")
{
}

ClassMethod FindDisposeExecute(ByRef qHandle As %Binary) As %Status
{

 	s repid=$i(^CacheTemp)
 	s ind=1
	s disposeStatId=0
	f  s disposeStatId=$o(^DHCCLNurseExec("DisposeStat",disposeStatId)) q:disposeStatId=""  d
	    .s varStr=$p(^DHCCLNurseExec("DisposeStat",disposeStatId),"^",1)
        .//&js<alert("here  "+"#(varStr)#");>
        .d Outdispose
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outdispose
	s Data=$lb(disposeStatId,varStr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// 根据设置选择医嘱分类(大类或子类)
Query FindOrdCatExt() As %Query(ROWSPEC = "desc:%String,rowId:%String")
{
}

ClassMethod FindOrdCatExtExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i $g(^DHCCLSet("Exec","OrderSubCat"))="Y" d
 		.k ^TMP($j,"ArcicDesc")
 		.s arcicDesc=""
 		.f  s arcicDesc=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(arcicDesc))) q:arcicDesc=""  d
 			..s arcicId=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(arcicDesc),""))
 			..q:arcicId=""
 			..s orcatDesc=$p(^OEC("ORCAT",+$p(^ARC("IC",arcicId),"^",8)),"^",2)
 			..q:orcatDesc=""
 			..s ^TMP($j,"ArcicDesc",orcatDesc_"-"_arcicDesc)=arcicId
 		.s desc=""
 		.f  s desc=$o(^TMP($j,"ArcicDesc",desc)) q:desc=""  d
 			..s rowId=^TMP($j,"ArcicDesc",desc)
 			..d OutputCatExt
 		.k ^TMP($j,"ArcicDesc")
 	e  d
 		.s rowId=0  f  s rowId=$o(^OEC("ORCAT",rowId))  q:rowId=""  d
 			..s desc=$p(^OEC("ORCAT",rowId),"^",2)
 			..d OutputCatExt
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputCatExt
	s Data=$lb(rowId,desc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOrdCatExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdCatExtExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" { // if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOrdCatExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdCatExtExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod FindDisposeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDisposeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindDisposeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDisposeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 插入变量数据
ClassMethod SetDefVar(code As %String, valStr As %String, HospitalRowId As %String)
{
	q:(code="")!(HospitalRowId="") -1
	s ^DHCCLNurseExec("VarDef",HospitalRowId,code,"VarId")=valStr
	q 0
}

Query FindTypeVar(queryTypeCode As %String) As %Query(ROWSPEC = "varId,varName")
{
}

ClassMethod FindTypeVarExecute(ByRef qHandle As %Binary, queryTypeCode As %String) As %Status
{
	//获得显示项
	//^DHCCLNurseExec("Var",1)=打印标记^prtFlag
	s repid=$i(^CacheTemp)
 	s ind=1
 	i queryTypeCode="" s qHandle=$lb(0,repid,0) q $$$OK
	s num=$l($g(^DHCCLNurseExec("VarDef",queryTypeCode,"VarId")))
	s tm=$g(^DHCCLNurseExec("VarDef",queryTypeCode,"VarId"))
	f i=1:1:num
	{
		s varId=$p(tm,"^",i)
		q:varId=""
		s varName=$p(^DHCCLNurseExec("Var",varId),"^",1)
    	d Outvar1
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outvar1
	s Data=$lb(varId,varName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTypeVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeVarExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {	// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else{			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTypeVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeVarExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod AddWardLoc(wardId, LocId) As %String
{
  //病区与科室对应
	n (wardId,LocId)
	s i=$i(^DHCNURWARDLOC("wardloc"))
	q:$D(^DHCNURWARDLOC("wardlocI",wardId,LocId)) 1 
	s ^DHCNURWARDLOC("wardloc",i)=wardId_"^"_LocId
	s ^DHCNURWARDLOC("wardlocI",wardId,LocId,i)=""
	q 0
}

ClassMethod DelWardLoc(rw, wardId, LocId) As %String
{
 //病区与科室对应
	n (rw, wardId, LocId)
	s ^T(1)=wardId_"^"_LocId
	k ^DHCNURWARDLOC("wardloc",rw)
	k ^DHCNURWARDLOC("wardlocI",wardId,LocId)
	q 0
}

ClassMethod UpWardLoc(rw, wardId, LocId) As %String
{
  //病区与科室对应
	n (rw,wardId,LocId)
	s ^DHCNURWARDLOC("wardloc",rw)=wardId_"^"_LocId
	s ^DHCNURWARDLOC("wardlocI",wardId,LocId,rw)=""

	q 0
}

ClassMethod GetWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardLocExecute ]
{
  //病区与科室对应
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

ClassMethod GetWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardLocExecute(ByRef qHandle As %Binary, ward As %String) As %Status
{
  //病区与科室对应
	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw="" f  s rw=$O(^DHCNURWARDLOC("wardloc",rw))  q:rw=""  d
    .s WardId=$P(^DHCNURWARDLOC("wardloc",rw),"^")
    .q:WardId=""
    .q:(WardId'=ward)&(ward'="")
    .s LocId=$P(^DHCNURWARDLOC("wardloc",rw),"^",2)
    .s WardDes=$P($G(^PAWARD(WardId)),"^",2)
    .s LocDes=$p(^CTLOC(LocId),"^",2)
    .d OutPutWard
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutWard
	set Data=$lb(WardDes,LocDes,rw,WardId,LocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SetRollOrdCheck(Flag)
{
}

Query GetWardLoc(ward As %String) As %Query(ROWSPEC = "WardDes,LocDes,rw,WardId,LocId")
{
}

ClassMethod GetQueryPara(hospitalRowId As %String, code As %String)
{
	q:code="" ""
    s resStr=$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"DisposeStat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"OrCat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"OecPr"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"OrdStat"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"PhcIn"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"Spec"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"RecLoc"))
    s resStr=resStr_"!"_$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"VarId"))
    q resStr
}

/// 增加类别
ClassMethod TypeAdd(code As %String, typeStr As %String, hospitalRowId As %String)
{
	q:(code="")!(hospitalRowId="") -2
	i $d(^DHCCLNurseExec("VarDef",hospitalRowId,code))>0 q -1
	s ^DHCCLNurseExec("VarDef",hospitalRowId,code)=typeStr q 0
}

ClassMethod GetCodeVar(hospitalRowId, code) As %String
{
 	//按类型获得显示数据
	s num=$l($g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"VarId")),"^")
   	//&js<alert("here  "+"#(num)#");>
    q:num=1 ""

	s tem=$g(^DHCCLNurseExec("VarDef",hospitalRowId,code,"VarId"))
	f i=1:1:num
	{
		s id=$p(tem,"^",i)
		s restr=$g(restr)_"!"_id_"^"_$p(^DHCCLNurseExec("Var",id),"^",1)
	}
	q $g(restr)
}

ClassMethod TypeUpdate(oldCode As %String, code As %String, typeStr As %String, oldHospitalRowId As %String, HospitalRowId As %String)
{
	q:(code="")!(HospitalRowId="") -2
	q:(oldCode="")!(oldHospitalRowId="") -1
	i oldHospitalRowId=HospitalRowId d
	.i oldCode'=code d
	..m ^DHCCLNurseExec("VarDef",oldHospitalRowId,code)=^DHCCLNurseExec("VarDef",oldHospitalRowId,oldCode)
	..k ^DHCCLNurseExec("VarDef",oldHospitalRowId,oldCode)
	.s ^DHCCLNurseExec("VarDef",oldHospitalRowId,code)=typeStr 
	e  d
	.m ^DHCCLNurseExec("VarDef",HospitalRowId,oldCode)=^DHCCLNurseExec("VarDef",oldHospitalRowId,oldCode)
	.k ^DHCCLNurseExec("VarDef",oldHospitalRowId,oldCode)
	.i oldCode'=code d
	..m ^DHCCLNurseExec("VarDef",HospitalRowId,code)=^DHCCLNurseExec("VarDef",HospitalRowId,oldCode)
	..k ^DHCCLNurseExec("VarDef",HospitalRowId,oldCode)
	.s ^DHCCLNurseExec("VarDef",HospitalRowId,code)=typeStr 
	q 0
}

/// 删除类别
ClassMethod TypeDel(code As %String, HospitalRowId As %String)
{
	q:(code="")!(HospitalRowId="") -2
	k ^DHCCLNurseExec("VarDef",HospitalRowId,code)
	q 0
}

Query FindAllVar() As %Query(ROWSPEC = "desc,name")
{
}

ClassMethod FindAllVarExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
	s var=0
	f  s var=$o(^DHCCLNurseExec("Var",var)) q:var=""  d
	    .s varStr=$p(^DHCCLNurseExec("Var",var),"^",1)
        .d Outvar
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outvar
	s Data=$lb(var,varStr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAllVarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllVarExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAllVarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllVarExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Query GetSpecCode() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SPEC_Code:%String,SPEC_Desc:%String")
/// {
/// 	select SPEC_Code,SPEC_Desc from CT_Specimen
/// }
/// 新检验标本集
/// d ##class(%ResultSet).RunQuery("web.DHCCLNURSET","GetSpecCode")
Query GetSpecCode() As %Query(ROWSPEC = "SPEC_Code:%String,SPEC_Desc:%String")
{
}

ClassMethod GetSpecCodeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    set ind=1
    Set retStr=##Class(DHCLIS.DHCCommon).getSpeciamenList()
    Set retLen=$L(retStr,$c(1))
    for i=1:1:retLen
    {
	    Set strInfo=$p(retStr,$c(1),i)
	    Set strInfoLen=$L(strInfo,$c(2))
	    continue:(strInfoLen<4)
	    Set SPECCode=$P(strInfo,$c(2),1)
	    Set SPECDesc=$P(strInfo,$c(2),2)
	    continue:(SPECCode="")||(SPECDesc="")
	    d OutRowSpecCode
	}
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutRowSpecCode
    set Data=$lb(SPECCode,SPECDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSpecCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSpecCodeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetSpecCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSpecCodeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-20
/// Description: 取医院名称
/// Table：CT_Hospital
/// Input：
/// Return：返回医院的RowId与Desc
Query GetHospital() As %SQLQuery(CONTAINID = 1, ROWSPEC = "HOSP_Desc:%String,HOSP_RowId:%String")
{
	select HOSP_Desc,HOSP_RowId from CT_Hospital
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-20
/// Description: 取所用单据
/// Table：^DHCCLNurseExec
/// Input：医院RowId: HospRowId, 单据代码: TypeCode
/// Return：返回 HospRowId!Desc, 医院名称!单据名称
Query FindAllType(HospRowId As %String = "", TypeCode As %String = "", sheetType = "") As %Query(ROWSPEC = "HospCode,HospName")
{
}

ClassMethod FindAllTypeExecute(ByRef qHandle As %Binary, HospRowId As %String = "", TypeCode As %String = "", sheetType = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	s ind=1
	s HospitalRowId=""
	f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
	.q:(HospRowId'="")&(HospRowId'=HospitalRowId)
	.s queryTypeCode=0
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) q:queryTypeCode=""  d
	..q:(TypeCode'="")&(TypeCode'=queryTypeCode)
	..s code=queryTypeCode
	..s name=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
	..i HospitalRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
	..e  s HospitalName=""
	..s HospCode=HospitalRowId_"@"_code
	..s HospName=HospitalName_" "_name
    ..d OutRowtyp2
    
    
    s sheetID=0
    f  s sheetID=$o(^Nur.NurseSheetSetD(sheetID)) q:sheetID=""  d
	.s recore = ^Nur.NurseSheetSetD(sheetID)
	.q:recore="" 
	.s code=$lg(recore,2)_"(new)"
	.s hospitalDR =  $lg(recore,11)
	.s sheetDesc = $lg(recore,3)
	.s sheetDesc=sheetDesc_"(新)"
	.i hospitalDR'=0 s HospitalName=$p($G(^CT("HOSP",hospitalDR)),"^",2)
	.e  s HospitalName=""
	.s HospCode=hospitalDR_"@"_code
	.s HospName=HospitalName_" "_sheetDesc
	.d OutRowtyp2
    
    s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp2
	s Data=$lb(HospCode,HospName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod SaveUserGroupAccess(ssgrp, type, defType, canCancel, typeS = "", HospID) As %String
{
	//
	s ^tempsc("SaveUserGroupAccess")=$lb(ssgrp,type,defType,canCancel,typeS)
	q:typeS="" "请选择单据类型"
	if typeS="oldSheet"
	{
		s ^DHCCLNurseExec("UserGroupAccess","Type",ssgrp)=type
		s ^DHCCLNurseExec("UserGroupAccess","DefaultType",ssgrp)=defType
		s ^DHCCLNurseExec("UserGroupAccess","CanCancel",ssgrp)=canCancel
	}
	if typeS="newSheet"
	{
		s ^tempsc("SaveUserGroupAccess",1)=$lb(ssgrp,type,defType,canCancel,typeS)
		s ^DHCCLNurseExec("NewSheet","UserGroupAccess","Type",HospID,ssgrp)=type
		s ^DHCCLNurseExec("NewSheet","UserGroupAccess","DefaultType",HospID,ssgrp)=defType
		s ^DHCCLNurseExec("NewSheet","UserGroupAccess","CanCancel",HospID,ssgrp)=canCancel
	}
	if typeS="byLoc"
	{
		s ^DHCCLNurseExec("ByLoc","UserGroupAccess","Type",ssgrp)=type
		s ^DHCCLNurseExec("ByLoc","UserGroupAccess","DefaultType",ssgrp)=defType
		s ^DHCCLNurseExec("ByLoc","UserGroupAccess","CanCancel",ssgrp)=canCancel
	}
	q "保存成功!"
}

ClassMethod getAllType(type, HospRowId = "") As %String
{
	s ^tempsc("getAllType")=$lb(type,HospRowId)
	//n (type,HospRowId)	##class(web.DHCCLNURSET).getAllType("newSheet")
	s retStr =""
	if type="oldSheet" 
	{
		s HospitalRowId=""
		f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
		.q:(HospRowId'="")&(HospRowId'=HospitalRowId)
		.s queryTypeCode=0
		.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) q:queryTypeCode=""  d
		..s code=queryTypeCode
		..s name=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
		..i HospitalRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
		..e  s HospitalName=""
		..s HospCode=HospitalRowId_"@"_code
		..s HospName=name_" "_HospitalName
		..s retStr=$s(retStr="":HospName_"|"_HospCode,1:retStr_"^"_HospName_"|"_HospCode)
   
	}
	else 
	{
		s hospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_ExecuteSheet",HospRowId,"")
		s rowid=""
		for
		{
			s rowid=$o(^CF.NUR.NIS.NurseSheetSetI("HospId",hospId,rowid))   
			q:rowid=""
			s data=$g(^CF.NUR.NIS.NurseSheetSetD(rowid))
			continue:data=""
			s execRecordFlag=$lg(data,5)
			continue:execRecordFlag="Y"
			s sheetCode=$lg(data,2)
			continue:sheetCode="DefaultSee"
			s sheetName=$lg(data,3)
			s HospitalName=$p($G(^CT("HOSP",hospId)),"^",2)
			s HospCode=hospId_"@"_sheetCode
			s HospName=sheetName_" "_HospitalName
			s retStr=$s(retStr="":HospName_"|"_HospCode,1:retStr_"^"_HospName_"|"_HospCode)
		}
		
#;    	s sheetID=0
#;   	 	f  s sheetID=$o(^Nur.NurseSheetSetD(sheetID)) q:sheetID=""  d
#;		.s recore = ^Nur.NurseSheetSetD(sheetID)
#;		.q:recore="" 
#;		.s exeRecordFlag=$lg(recore,22)
#;		.q:exeRecordFlag="Y"
#;		.s code=$lg(recore,2)
#;		.s hospitalDR =  $lg(recore,11)
#;		.s defHospId=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCCLNurseExec",HospRowId)
#;		.q:(+defHospId<0)
#;		.q:(HospRowId'="")&(defHospId'=hospitalDR)
#;		.s sheetDesc = $lg(recore,3)
#;		.i hospitalDR'=0 s HospitalName=$p($G(^CT("HOSP",hospitalDR)),"^",2)
#;		.e  s HospitalName=""
#;		.s HospCode=hospitalDR_"@"_code
#;		.s HospName=sheetDesc_" "_HospitalName
#;		.s retStr=$s(retStr="":HospName_"|"_HospCode,1:retStr_"^"_HospName_"|"_HospCode)
	}
	
	q retStr
}

ClassMethod GetUserGroupAccess(ssgrp, userId, sheetType = "", setWay = "", ctloc = "", HospRowId = "") As %String
{
 	//门诊护士安全设置##class(web.DHCCLNURSET).GetUserGroupAccess("23","","newSheet","byAccess","","3")
 	n (ssgrp,userId,sheetType,setWay,ctloc,HospRowId)
 	s ^tempsc("GetUserGroupAccess")=$lb(ssgrp,userId,sheetType,setWay,ctloc,HospRowId)
    i ssgrp="" 
    {
		s ssgrp=$p(^SSU("SSUSR",userId),"^",5)
	}
	i ctloc'="" d
	.s typeCTLoc=$g(^DHCCLNurseExec("ByLoc","UserGroupAccess","Type",ctloc))
	.i typeCTLoc'="" d
	..s setWay="byLoc"
	..s ssgrp=ctloc
	
	if ((sheetType="oldSheet")!(sheetType=""))&&((setWay="")!(setWay="byAccess"))
	{
		s type=$g(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))	
		s defType=$g(^DHCCLNurseExec("UserGroupAccess","DefaultType",ssgrp))
		s canCancel=$g(^DHCCLNurseExec("UserGroupAccess","CanCancel",ssgrp))
		d getOldSheet
	}
	if (sheetType="newSheet")&&((setWay="")!(setWay="byAccess")){
   		s typeNew=$g(^DHCCLNurseExec("NewSheet","UserGroupAccess","Type",HospRowId,ssgrp))	
		s defType=$g(^DHCCLNurseExec("NewSheet","UserGroupAccess","DefaultType",HospRowId,ssgrp))
		s canCancel=$g(^DHCCLNurseExec("NewSheet","UserGroupAccess","CanCancel",HospRowId,ssgrp))
   		d getNewSheet
	}
	if (setWay="byLoc"){
   		s typeNew=$g(^DHCCLNurseExec("ByLoc","UserGroupAccess","Type",ssgrp))	
		s defType=$g(^DHCCLNurseExec("ByLoc","UserGroupAccess","DefaultType",ssgrp))
		s canCancel=$g(^DHCCLNurseExec("ByLoc","UserGroupAccess","CanCancel",ssgrp))		
		s type=typeNew
		i sheetType="oldSheet"  d getOldSheet   
		i sheetType="newSheet"  d getNewSheet
		i sheetType=""	d 
		.d getOldSheet   
		.d getNewSheet
	}   	
	q typeCode_"!"_defType_"!"_canCancel
getOldSheet
	s typeLen=$L(type,"^")
	s typeCode=""
	for i=1:1:typeLen
	{
		s tmpType=$p(type,"^",i)
		s HospitalRowId=$p(tmpType,"@",1)
		s queryTypeCode=$p(tmpType,"@",2)
		s HospitalName=""
		s queryTypeName=""
		s HospName=""
		i HospitalRowId'="",queryTypeCode'="" d
		.i '$d(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) d
		..i HospitalRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
		..e  s HospitalName=""
		..s HospName=HospitalName_" "_queryTypeCode_"已做修改,请重新设置安全组"
		.e  d
		..s queryTypeName=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
		..i HospitalRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
		..e  s HospitalName=""
		..s HospName=HospitalName_" "_queryTypeName	    
		i typeCode="" s typeCode=tmpType_"|"_HospName
		e  s typeCode=$G(typeCode)_"^"_tmpType_"|"_HospName
	}
	q
getNewSheet
	s typeNewLen=$L(typeNew,"^")
	s typeCode=""
	for i=1:1:typeNewLen
	{
		s tmpTypeNew=$p(typeNew,"^",i)
		s hosNew=$p(tmpTypeNew,"@",1)
		s sheetCode=$p(tmpTypeNew,"@",2)
		s hosNew=$zcvt(hosNew,"u")
		s oldSheetCode=sheetCode
		s sheetCode=$zcvt(sheetCode,"u")
		s sheetID=$O(^Nur.NurseSheetSetI("CODE"," "_hosNew," "_sheetCode,""))
		continue:sheetID=""
		s recore = ^Nur.NurseSheetSetD(sheetID)
		continue:recore=""		
		s hospitalDR =  $lg(recore,11)
		s defHospId=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCCLNurseExec",hospitalDR)
		continue:(+defHospId<0)
		continue:(HospRowId'="")&&(defHospId'=HospRowId)
		s sheetDesc = $lg(recore,3)
		i hosNew'=0 s HospitalName=$p($G(^CT("HOSP",hosNew)),"^",2)
		e  s HospitalName=""
		s HospName=sheetDesc_" "_HospitalName			
		i typeCode="" s typeCode=hosNew_"@"_oldSheetCode_"|"_HospName
		e  s typeCode=$g(typeCode)_"^"_hosNew_"@"_oldSheetCode_"|"_HospName		
	}
	q
}

ClassMethod FindAllTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAllTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-23
/// Description: 取单据的描述
/// Table：^DHCCLNurseExec
/// Input：tmpType: 医院RowId@单据代码
/// Return：返回单据描述
ClassMethod GetTypeName(tmpType = "")
{
	s HospitalRowId=$p(tmpType,"@",1)
	s TypeCode=$p(tmpType,"@",2)
	q:(HospitalRowId="")!(TypeCode="") -1
	s TypeName=$p(^DHCCLNurseExec("VarDef",HospitalRowId,TypeCode),"^",1)
	q TypeName
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-23
/// Description: 取单据默认查询的天数
/// Table：^DHCCLNurseExec
/// Input：tmpType: 医院RowId@单据代码
/// Return：返回单据描述
ClassMethod GetDate(tmpType = "") As %String
{
	s HospitalRowId=$p(tmpType,"@",1)
	s TypeCode=$p(tmpType,"@",2)
	q:(HospitalRowId="")!(TypeCode="") -1
	s DefaultDays=$p(^DHCCLNurseExec("VarDef",HospitalRowId,TypeCode),"^",5)
	s curDate=+$h
	s DefaultStDate=curDate-(+$g(DefaultDays))
	s DefaultStDate=$zd(DefaultStDate,4)
	q $G(DefaultStDate)
}

/// Creator: lvxin
/// CreatDate: 2014-04-14
/// Description: 取单据项目
/// Table：^DHCCLNurseExec
/// Input：
/// Return：返回单据项目(json)
/// d ##class(web.DHCCLNURSET).getVars()
ClassMethod getVars() As %String
{
	w "{rowData:[",!
	s varId=0
	f  s varId=$o(^Nur.NurExcuteColumnsD(varId))  q:varId=""  d
	.s dataList= ^Nur.NurExcuteColumnsD(varId)
	.s varDesc=$lg(dataList,2)
	.s varCode=$lg(dataList,3)
	.s columnWidth=$lg(dataList,4)
	.s funCode=$zcvt($lg(dataList,5),"O","JS")
	.w "{ID:"""_varId_""",varDesc:"""_varDesc_""",varCode:"""_varCode_""",columnWidth:"""_columnWidth_""",funCode:"""_funCode_"""}"
	.i ($o(^Nur.NurExcuteColumnsD(varId))'="")  w ",",!
	w "]}"
	q ""
}

/// Creator: lvxin
/// CreatDate: 2014-04-14
/// Description: 修改单据项目
/// Table：^DHCCLNurseExec
/// Input：
/// Return：成功返回0  否则返回错误代码
/// d ##class(web.DHCCLNURSET).saveVars()
ClassMethod saveVars(saveStr As %String) As %String
{
	s errStr = ""
	q:saveStr="" "没有要保存的数据"
	s saveStr=$zcvt(saveStr,"I","JS")
	s length = $l(saveStr,$c(135))
	f i=1:1:length  d
	.s rowStr= $p(saveStr,$c(135),i)
	.s ID = $P(rowStr,$c(129),1)
	.s varDesc = $P(rowStr,$c(129),2)
	.s varCode=$P(rowStr,$c(129),3)
	.s columnWidth=$P(rowStr,$c(129),4)
	.s funCode=$P(rowStr,$c(129),5)
	.i ID="" d
	..i ##class(Nur.NurExcuteColumns).exitCode(varCode)'=1 d
	...d ##class(Nur.NurExcuteColumns).save(ID,varDesc,varCode,columnWidth,funCode)
	..e  s errStr=errStr_$zcvt("<","O","XML")_varDesc_$zcvt(">","O","XML")_"  数据代码已经存在！</br>"
	.e  d
	..d ##class(Nur.NurExcuteColumns).save(ID,varDesc,varCode,columnWidth,funCode)
	q errStr
}

/// Creator: lvxin
/// CreatDate: 2014-04-14
/// Description: 修改单据项目
/// Table：^DHCCLNurseExec
/// Input：
/// Return：成功返回0  否则返回错误代码
ClassMethod editVars(index As %String, varDesc As %String, varCode As %String, columnWidth As %String, dataBindCode As %String) As %String
{
	q:index="" "获取项目ID失败！"
	q:varDesc="" "描述不能为空！"
	q:varCode="" "代码不能为空！"
	q:'$d(^DHCCLNurseExec("Var",index)) "项目ID错误"
	s ^DHCCLNurseExec("Var",index)=varDesc_"^"_varCode_"^"_columnWidth_"^"_dataBindCode
	q 0
}

/// Creator: lvxin
/// CreatDate: 2014-04-14
/// Description: 添加单据项目
/// Table：^DHCCLNurseExec
/// Input：
/// Return：成功返回0  否则返回错误代码
ClassMethod addVars(varDesc As %String, varCode As %String, columnWidth As %String, dataBindCode As %String) As %String
{
	q:varDesc="" "项目描述不能为空！"
	q:varCode="" "项目代码不能为空！"
	s currentMaxID=$G(^DHCCLNurseExec("Var",0))
	q:currentMaxID="" "获取ID出错"
	s flag=0
	s varId=0
	f  s varId=$o(^DHCCLNurseExec("Var",varId))  q:(varId="")!(flag=1)  d
	.i $p($g(^DHCCLNurseExec("Var",varId)),"^",2)=varCode  s flag=1
	q:flag=1 "代码已经存在！"
	s ^DHCCLNurseExec("Var",currentMaxID+1)=varDesc_"^"_varCode_"^"_columnWidth_"^"_dataBindCode
	s ^DHCCLNurseExec("Var",0)=currentMaxID+1
	q 0
}

/**
  新执行单设置
*/
/// w ##class(web.DHCCLNURSET).getHospital()
/// Creator: lvxin
/// CreatDate: 2014-06-19
/// Description: 获取医院信息
/// Input：
/// Return  返回二维数组串
ClassMethod getHospital()
{
	//^CT("HOSP",)
	s ret="["
	s hospitalId=0 
	f  s hospitalId=$o(^CT("HOSP",hospitalId)) q:hospitalId=""  d
	.s hopitalDesc = $p(^CT("HOSP",hospitalId),"^",2)
	.s ret=ret_"["_hospitalId_","""_hopitalDesc_"""],"
	s ret=$e(ret,1,($l(ret)-1))
	s ret=ret_"]"
	q ret
}

/// Test:w ##class(web.DHCCLNURSET).getSheets()
/// Creator: lvxin
/// CreatDate: 2014-06-19
/// Description: 获取单据配置列表 json
/// Input：单据代码   医院ID
/// Return  ""
ClassMethod getSheets(queryCode As %String = "", hospital As %String = "") As %String
{
 	
    s HospRowId=""
    w "{rowData:[",!
    s firstFlag=1
	f  s HospRowId=$o(^DHCCLNurseExec("VarDef",HospRowId)) q:HospRowId=""  d
	.q:(hospital'="")&(HospRowId'=hospital)
	.s queryTypeCode=0
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode)) q:queryTypeCode=""  d
	..q:(queryCode'="")&(queryTypeCode'[$$ALPHAUP^SSUTIL4(queryCode))
	..s code=queryTypeCode
	..s name=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",1)
    ..s filename=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",2)
    ..s byadm=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",3)
    ..s prnframe=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",4)
    ..s startDate=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",5)
    ..s startTime = $p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",6)
    ..s endDate = $p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",7)
    ..s endTime  = $p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",8)
	..i HospRowId'=0 s tHospitalName=$p($G(^CT("HOSP",HospRowId)),"^",2)
	..e  s tHospitalName=""
	..s tHospitalRowId=HospRowId
	..i firstFlag=1  d
	...w "{code:"""_code_""",name:"""_name_""",fileName:"""_filename_""",pat:"""_byadm_""",printLine:"""_prnframe_""",startDate:"""_startDate_""",startTime:"""_startTime_""",endDate:"""_endDate_""",endTime:"""_endTime_""",hospitalName:"""_tHospitalName_""",tHospitalRowId:"""_tHospitalRowId_"""}",!
	...s firstFlag=0
	..e  d
	...w ",{code:"""_code_""",name:"""_name_""",fileName:"""_filename_""",pat:"""_byadm_""",printLine:"""_prnframe_""",startDate:"""_startDate_""",startTime:"""_startTime_""",endDate:"""_endDate_""",endTime:"""_endTime_""",hospitalName:"""_tHospitalName_""",tHospitalRowId:"""_tHospitalRowId_"""}",!
	w "]}"
	q ""
}

/// Test:w ##class(web.DHCCLNURSET).saveSheetsSet()
/// Creator: lvxin
/// CreatDate: 2014-06-19
/// Description: 保存单据设置
/// Input：修改过的行字符串
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod saveSheetsSet(saveStr As %String = "") As %String
{
	q:saveStr="" "saveStr=null"
	s length = $l(saveStr,"|")
	s retStr=0
	f strIndex = 1:1:length  d
	.s str = $p(saveStr,"|",strIndex)
	.q:str=""
	.s varCode = $p(str,"^",1)
	.i (varCode="")  s retStr=retStr_"   保存代码不能为空！"
	.q:(varCode="")
	.s varDesc = $p(str,"^",2)
	.s fileName = $p(str,"^",3)
	.s byPat = $p(str,"^",4)
	.s printFram = $p(str,"^",5)
	.s startDate = $p(str,"^",6)
	.s startTime = $p(str,"^",7)
	.s endDate = $p(str,"^",8)
	.s endTime = $p(str,"^",9)
	.s hospitalID = $p(str,"^",11)
	.i hospitalID="" s hospitalID=0
	.s ^DHCCLNurseExec("VarDef",hospitalID,varCode)=varDesc_"^"_fileName_"^"_byPat_"^"_printFram_"^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime
	q retStr
}

/// Test:w ##class(web.DHCCLNURSET).deleteSheetsSet()
/// Creator: lvxin
/// CreatDate: 2014-06-19
/// Description: 删除单据设置
/// Input：医院ID  单据代码串(^分割)
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod deleteSheetsSet(hospitalID As %String = "", varCodeStr As %String = "") As %String
{
	q:varCodeStr="" "获取单据代码出错！"
	i hospitalID="" s hospitalID=0
	s retStr= 0
	s varLength = $l(varCodeStr,"^")
	f varIndex=1:1:varLength  d
	.s varCode= $p(varCodeStr,"^",varIndex)
	.q:varCode=""
	.i $d(^DHCCLNurseExec("VarDef",hospitalID,varCode))   k ^DHCCLNurseExec("VarDef",hospitalID,varCode)
	.e  s retStr=retStr_" "_varCode_"单据不存在！"
	q retStr
}

/// Test:w ##class(web.DHCCLNURSET).saveSheetButtons()
/// Creator: lvxin
/// CreatDate: 2014-06-20
/// Description: 保存单据对应的按钮设置
/// ^DHCCLNurseExec("VarDef",hospitalID,varCode,"ButtonSets")=按钮ID@显示顺序^按钮ID@显示顺序.....
/// Input：单据代码   医院ID
/// Return  ""
ClassMethod saveSheetButtons(queryCode As %String = "", hospital As %String = "", buttonSets As %String = "") As %String
{
	q:queryCode="" "获取单据代码失败！"
	//q:buttonSets="" "获取按钮数据失败！"
	i hospital="" s hospital=0
	i $d(^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets")) k ^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets")
	s buttonLength = $l(buttonSets,"|")
	f buttonIndex =1:1:buttonLength  d 
	.s buttonSetStr= $p(buttonSets,"|",buttonIndex)
	.q:buttonSetStr=""
	.s buttonID=$p(buttonSetStr,"^",8)
	.s shortNum=$p(buttonSetStr,"^",1)
	.i '$d(^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets"))  s ^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets")=buttonID_"@"_shortNum
	.e  s ^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets")=^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets")_"^"_buttonID_"@"_shortNum
	q 0
}

/// Test:w ##class(web.DHCCLNURSET).getSheetButtons()
/// Creator: lvxin
/// CreatDate: 2014-06-20
/// Description: 获取单据对应的按钮列表 json
/// Input：单据代码   医院ID
/// Return  ""
ClassMethod getSheetButtons(queryCode As %String = "", hospital As %String = "") As %String
{
	q:queryCode="" ""
	i hospital="" s hospital=0
	i '$d(^DHCCLNurseExec("buttonDefine",hospital))  q ""
	s firstFlag=1
	w "{rowData:[",!
	s buttonId = 0
	f  s buttonId=$o(^DHCCLNurseExec("buttonDefine",hospital,buttonId)) q:buttonId=""  d
	.s buttonCode= $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",1)
	.s buttonName = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",2)
	.s jsFunction =$p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",3)
	.s ifSign = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",4)
	.s ifDoubleSign = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",5)
	.s operationTypeID = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",6)
	.i operationTypeID'="" s operationType=$p($g(^DHCCLNurseExec("OperationType",hospital,operationTypeID)),"^",1)
	.e  s operationType=""
	.s shortNum=""
	.s checkFlag=0
	.i $d(^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets"))  d
	..f index=1:1:$l(^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets"),"^")  d
	...s butSetStr=$p(^DHCCLNurseExec("VarDef",hospital,queryCode,"ButtonSets"),"^",index)
	...i $p(butSetStr,"@",1)=buttonId  d
	....s shortNum = $p(butSetStr,"@",2)
	....s checkFlag=1
	.i firstFlag=1  d
	..w "{shortNum:"""_shortNum_""",buttonCode:"""_buttonCode_""",buttonName:"""_buttonName_""",jsFunction:"""_jsFunction_""",ifSign:"""_ifSign_""",ifDoubleSign:"""_ifDoubleSign_""",operationType:"""_operationType_""",buttonID:"""_buttonId_""",checked:"""_checkFlag_"""}"
	..s firstFlag=0
	.e  d
	..w ",{shortNum:"""_shortNum_""",buttonCode:"""_buttonCode_""",buttonName:"""_buttonName_""",jsFunction:"""_jsFunction_""",ifSign:"""_ifSign_""",ifDoubleSign:"""_ifDoubleSign_""",operationType:"""_operationType_""",buttonID:"""_buttonId_""",checked:"""_checkFlag_"""}"
	w "]}"
	q ""
}

/// Test:w ##class(web.DHCCLNURSET).getButtonDefine()
/// Creator: lvxin
/// CreatDate: 2014-06-20
/// Description: 获取医院按钮定义 json
/// Input：医院ID
/// Return  ""
ClassMethod getButtonDefine(hospital As %String = "") As %String
{
	i hospital="" s hospital=0
	i '$d(^DHCCLNurseExec("buttonDefine",hospital))  q ""
	s firstFlag=1
	w "{rowData:[",!
	s buttonId = 0
	f  s buttonId=$o(^DHCCLNurseExec("buttonDefine",hospital,buttonId)) q:buttonId=""  d
	.s buttonCode= $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",1)
	.s buttonName = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",2)
	.s jsFunction =$p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",3)
	.s ifSign = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",4)
	.s ifDoubleSign = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",5)
	.s operationTypeID = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",6)
	.i operationTypeID'="" s operationType=$p($g(^DHCCLNurseExec("OperationType",hospital,operationTypeID)),"^",2)
	.e  s operationType=""
	.i firstFlag=1  d
	..w "{buttonCode:"""_buttonCode_""",buttonName:"""_buttonName_""",jsFunction:"""_jsFunction_""",ifSign:"""_ifSign_""",ifDoubleSign:"""_ifDoubleSign_""",operationType:"""_operationType_""",buttonID:"""_buttonId_"""}"
	..s firstFlag=0
	.e  d
	..w ",{buttonCode:"""_buttonCode_""",buttonName:"""_buttonName_""",jsFunction:"""_jsFunction_""",ifSign:"""_ifSign_""",ifDoubleSign:"""_ifDoubleSign_""",operationType:"""_operationType_""",buttonID:"""_buttonId_"""}"
	w "]}"
	q ""
}

/// Test:w ##class(web.DHCCLNURSET).addButtonDefine()
/// Creator: lvxin
/// CreatDate: 2014-06-20
/// Description: 增加按钮定义 
/// golabel:^DHCCLNurseExec("VarDef",HospRowId,"buttonDefine")
/// ^DHCCLNurseExec("buttonDefine",hospital,buttonID)=按钮代码^按钮名字^js函数
/// Input：医院ID, 数据串
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod addButtonDefine(hospital As %String = "", saveStr As %String = "") As %String
{
	i hospital="" s hospital=0
	q:saveStr="" "获取数据失败！"
	s strLength=$l(saveStr,"|")
	f strIndex=1:1:strLength  d
	.s dataStr = $p(saveStr,"|",strIndex) 
	.s buttonCode = $p(dataStr,"^",1)
	.s buttonName = $p(dataStr,"^",2)
	.s jsFunction = $p(dataStr,"^",3)
	.s ifSign = $p(dataStr,"^",4)
	.s ifDoubleSign = $p(dataStr,"^",5)
	.s operationType = $p(dataStr,"^",6)
	.s buttonID=$p(dataStr,"^",7)
	.i buttonID'="" d
	..s ^DHCCLNurseExec("buttonDefine",hospital,buttonID)=buttonCode_"^"_buttonName_"^"_jsFunction_"^"_ifSign_"^"_ifDoubleSign_"^"_operationType
	.e   d
	..i '$d(^DHCCLNurseExec("buttonDefine",hospital,0))   s ^DHCCLNurseExec("buttonDefine",hospital,0)=0
	..s buttonID=^DHCCLNurseExec("buttonDefine",hospital,0)+1
	..s ^DHCCLNurseExec("buttonDefine",hospital,buttonID)=buttonCode_"^"_buttonName_"^"_jsFunction_"^"_ifSign_"^"_ifDoubleSign_"^"_operationType
	..s ^DHCCLNurseExec("buttonDefine",hospital,0)=buttonID
	q 0
}

/// 未完
/// Test:w ##class(web.DHCCLNURSET).deleteButtonDefine()
/// Creator: lvxin
/// CreatDate: 2014-06-20
/// Description: 删除按钮定义 
/// Input：医院ID, 按钮ID串
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod deleteButtonDefine(hospital As %String = "", buttonIdStr As %String = "") As %String
{
	i hospital="" s hospital=0
	q:buttonIdStr="" "按钮ID失败！"
	q:hospital="" "获取医院Id失败！"

	s strLength = $l(buttonIdStr,"^")
	f index=1:1:strLength  d
	.s buttonId= $p(buttonIdStr,"^",index)
	.q:buttonId="" 
	.i $d(^DHCCLNurseExec("buttonDefine",hospital,buttonId))  d
	..k ^DHCCLNurseExec("buttonDefine",hospital,buttonId)
	
	//删除单据设置里相关的数据
	s varCode = ""                              
	f   s varCode=$o(^DHCCLNurseExec("VarDef",hospital,varCode)) q:varCode=""  d
	.q:'$d(^DHCCLNurseExec("VarDef",hospital,varCode,"ButtonSets"))
	.s buttonSetStr = ^DHCCLNurseExec("VarDef",hospital,varCode,"ButtonSets")
	.q:buttonSetStr=""
	.s buttonLength = $l(buttonSetStr,"^")
	.s newButtonSetStr=""
	.f btIndex =1:1:buttonLength  d
	..s buttonSetBtID = $P($P(buttonSetStr,"^",btIndex),"@",1)
	..q:("^"_buttonIdStr_"^")[("^"_buttonSetBtID_"^")
	..i newButtonSetStr="" s newButtonSetStr=$P(buttonSetStr,"^",btIndex)
	..e  s newButtonSetStr=newButtonSetStr_"^"_$P(buttonSetStr,"^",btIndex)
	.i newButtonSetStr'="" s ^DHCCLNurseExec("VarDef",hospital,varCode,"ButtonSets")=newButtonSetStr	
	q 0
}

/// Test:w ##class(web.DHCCLNURSET).saveOperationTypeDefine()
/// Creator: lvxin
/// CreatDate: 2014-06-26
/// Description: 保存操作类型定义
/// golabel:^DHCCLNurseExec("OperationType",hospital)
/// ^DHCCLNurseExec("OperationType",OperationTypeID)=操作类型^描述
/// Input：医院ID, 数据串
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod saveOperationTypeDefine(hospital As %String = "", saveStr As %String = "") As %String
{
	i hospital="" s hospital=0
	q:saveStr="" "获取保存数据失败！"
	s strLength  = $l(saveStr,"|")
	f strIndex=1:1:strLength   d
	.s saveData = $p(saveStr,"|",strIndex)
	.q:saveData=""
	.s operationType= $p(saveData,"^",1)
	.s operationDesc= $p(saveData,"^",2)
	.s operationTypeID = $p(saveData,"^",3)
	.i operationTypeID="" d
	..i '$d(^DHCCLNurseExec("OperationType",hospital,0))  s ^DHCCLNurseExec("OperationType",hospital,0)=0
	..s operationTypeID=+^DHCCLNurseExec("OperationType",hospital,0)+1
	..s ^DHCCLNurseExec("OperationType",hospital,operationTypeID)=operationType_"^"_operationDesc
	..s ^DHCCLNurseExec("OperationType",hospital,0)=operationTypeID
	.e  d
	..i $d(^DHCCLNurseExec("OperationType",hospital,operationTypeID)) s ^DHCCLNurseExec("OperationType",hospital,operationTypeID)=operationType_"^"_operationDesc
	q 0
}

/// Test:w ##class(web.DHCCLNURSET).getOperationType()
/// Creator: lvxin
/// CreatDate: 2014-06-26
/// golabel:^DHCCLNurseExec("OperationType",hospital)
/// Description: 获取操作类型定义 json
/// Input：医院ID
/// Return  ""
ClassMethod getOperationType(hospital As %String = "") As %String
{
	i hospital="" s hospital=0
	s firstRow = 1
	w "{rowData:["
	s operationTypeID=0
	f  s operationTypeID=$o(^DHCCLNurseExec("OperationType",hospital,operationTypeID)) q:operationTypeID=""  d
	.s operationType = $p($g(^DHCCLNurseExec("OperationType",hospital,operationTypeID)),"^",1)
	.s operationDesc = $p($g(^DHCCLNurseExec("OperationType",hospital,operationTypeID)),"^",2)
	.i firstRow=1  d
	..w "{opertionType:"""_operationType_""",opertionDesc:"""_operationDesc_""",opertionID:"""_operationTypeID_"""}"
	..s firstRow=0
	.e  d
	..w ",{opertionType:"""_operationType_""",opertionDesc:"""_operationDesc_""",opertionID:"""_operationTypeID_"""}"
 	w "]}"
 	q ""
}

/// Test:w ##class(web.DHCCLNURSET).deleteOperationType()
/// Creator: lvxin
/// CreatDate: 2014-06-26
/// Description: 删除操作类型定义 
/// Input：医院ID, 操作类型ID串
/// Return  成功:返回 0  错误:返回错误代码
ClassMethod deleteOperationType(hospital As %String = "", operationTypeIdStr As %String = "") As %String
{
	q:operationTypeIdStr="" "没有要删除的数据！"
	i hospital="" s hospital=0
	s idLength = $l(operationTypeIdStr,"^")
	f index=1:1:idLength  d
	.s operationTypeId=$p(operationTypeIdStr,"^",index)
	.q:operationTypeId=""
	.i $d(^DHCCLNurseExec("OperationType",hospital,operationTypeId))  k ^DHCCLNurseExec("OperationType",hospital,operationTypeId)
	
	//删除按钮定义里面的关联数据
	s buttonId = 0
	f  s buttonId=$o(^DHCCLNurseExec("buttonDefine",hospital,buttonId)) q:buttonId=""  d
	.s buttonCode= $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",1)
	.s operationTypeID = $p($g(^DHCCLNurseExec("buttonDefine",hospital,buttonId)),"^",6)
	.q:operationTypeID=""
	.i ("^"_operationTypeIdStr_"^")[("^"_operationTypeID_"^")  s $p(^DHCCLNurseExec("buttonDefine",hospital,buttonId),"^",6)=""
	q 0
}

}
