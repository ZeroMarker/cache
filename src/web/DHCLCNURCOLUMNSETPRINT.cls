/// 程序名DHCLCNURCOLUMNSETPRINT,护士执行打印设置
Class web.DHCLCNURCOLUMNSETPRINT Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Query FindAllVarLink() As %Query(ROWSPEC = "desc,ID")
{
}

ClassMethod FindAllVarLinkExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	
 	s rowid=""
 	for
 	{
	 	s rowid=$o(^CT.NUR.NIS.NurseBasicDataD(rowid))   
	    q:rowid=""
	    s data=$g(^CT.NUR.NIS.NurseBasicDataD(rowid))
	    continue:data=""
	    s NBDDeleteFlag=$lg(data,7)
	    continue:NBDDeleteFlag'="0"
	    s NBDType=$lg(data,3)
	    continue:NBDType="0"
	    s NBDNote=$lg(data,5)
	    s NBDCode=$lg(data,2)
	    s titleName=NBDNote_"/"_NBDCode
	    d Outvar
	}
    
	q $$$OK

Outvar
	//s Data=$lb(var,varStr)
	//s Data=$lb(varStr,var)
	s Data=$lb(titleName,rowid)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

Query FindAllVarLinkOld() As %Query(ROWSPEC = "desc,ID")
{
}

ClassMethod FindAllVarLinkOldExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
	s var=0
	f  s var=$o(^DHCCLNurseExec("Var",var)) q:var=""  d
	    .s varStr=$p(^DHCCLNurseExec("Var",var),"^",1)
	    .s varAlp=$p(^DHCCLNurseExec("Var",var),"^",2)
        .d Outvar
    s qHandle=$lb(0,repid,0)
	q $$$OK

Outvar
	//s Data=$lb(var,varStr)
	//s Data=$lb(varStr,var)
	s Data=$lb(varStr,varAlp)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAllVarLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
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

ClassMethod FindAllVarLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllVarLinkExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod setIfPrintJYHZD(value)
{
	s ^DHCCLNurseExec("IfPrintJYHZD")=value
	q 0
}

ClassMethod getIfPrintJYHZD()
{
	q $g(^DHCCLNurseExec("IfPrintJYHZD"))
}

/// 取查询类别
ClassMethod GetTypeSet() As %String
{
	s queryTypeCode=0,num=0
	f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",queryTypeCode)) q:queryTypeCode=""  d
	    .s num=num+1
	    .s typeStr=queryTypeCode_"^"_^DHCCLNurseExec("VarDef",queryTypeCode)
	    .s $p(resStr,"!",num)=typeStr
	q $g(resStr)
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-20
/// Description: 取所用单据
/// Table：^DHCCLNurseExec
/// Input:
/// Return：返回 HospRowId!Desc, 医院名称!单据名称
Query GetTypeSetPrint() As %Query(ROWSPEC = "HospCode,HospName")
{
}

ClassMethod GetTypeSetPrintExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s HospitalRowId=""
	f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
	.s queryTypeCode=0
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) q:queryTypeCode=""  d
	..s code=queryTypeCode
	..s name=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
	..i HospitalRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
	..e  s HospitalName=""
	..s HospCode=HospitalRowId_"@"_code
	..s HospName=HospitalName_" "_name
    ..d OutRowtyp2
    s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp2
	s Data=$lb(HospCode,HospName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod GetTypeSetPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeSetPrintExecute ]
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

ClassMethod GetTypeSetPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeSetPrintExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query GetQueryType(ssgrp As %String, userId As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetQueryTypeExecute(ByRef qHandle As %Binary, ssgrp As %String = "", userId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s queryTypeStr=""
	i ssgrp="" d  //ypz 061103
    	.i (userId'="") s ssgrp=$p(^SSU("SSUSR",userId),"^",5)
	
	i $g(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))'="" s queryTypeStr=$g(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))
	i $g(queryTypeStr)="" s num=0
	e  s num=$l($g(queryTypeStr),"^")
	
	f i=1:1:num
	{
		s str=$p(queryTypeStr,"^",i)
		s queryTypeCode=$p(str,"|")
		s typeStr=$p(str,"|",2)
		d OutRowtyp
	}
	i (userId="")
	{
	    s queryTypeCode=0
	    f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",queryTypeCode)) q:queryTypeCode=""  d
	        .s typeStr=$p(^DHCCLNurseExec("VarDef",queryTypeCode),"^",1)
            .d OutRowtyp
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK
  
OutRowtyp
	s Data=$lb(typeStr,queryTypeCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryTypeExecute ]
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

ClassMethod GetQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FinTypeSetPrint(HospitalRowId As %String = "", queryTypeCode As %String = "") As %Query(ROWSPEC = "seqno,name,code,ordlink,ordlinkID,rw")
{
}

ClassMethod FinTypeSetPrintExecute(ByRef qHandle As %Binary, HospitalRowId As %String = "", queryTypeCode As %String = "") As %Status
{
 	//"CQSYD"
 	s repid=$i(^CacheTemp)
 	s ind=1
	s TypeCode=queryTypeCode
	i (HospitalRowId="")!(TypeCode="") s qHandle=$lb(0,repid,0) q $$$OK
	s rw=0
	//seqno:%String,name:%String,code:%String,ordlink:%String,ordlinkID:%String")
	//s queryTypeCo
	//de="CQSYD"
	i (queryTypeCode'="")
	{
	f  s rw=$o(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw)) q:rw=""  d
	    .s name=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw),"|",1)
	    .s code=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw),"|",2)
	    .s ordlink=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw),"|",3)
	    .s ordlinkID=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw),"|",4)
        .s seqno=$p(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw),"|",5)
        .s tem(seqno,rw)=$lb(seqno,name,code,ordlink,ordlinkID,rw)
	}
	s i=0
    s seqno=""  f  s seqno=$O(tem(seqno))  q:seqno=""  d
    .s rw=0 f  s rw=$O(tem(seqno,rw)) q:rw=""  d
    ..s name=$List(tem(seqno,rw),2)
    ..s code=$List(tem(seqno,rw),3)
    ..s code=$Fn(code/56.7,"",1)_"mm"
    ..s ordlink=$List(tem(seqno,rw),4)
    ..s ordlinkID=$List(tem(seqno,rw),5)
    ..//s rw=$List(tem(seqno,rw),6)
    ..s i=i+1
    ..d OutRowtyp1
    if (i=0)&(queryTypeCode'="") k ^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode)
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRowtyp1
	//s Data=$lb(code,name,filename,byadm,prnframe)
	s Data=$lb(seqno,name,code,ordlink,ordlinkID,rw)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FinTypeSetPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
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

ClassMethod FinTypeSetPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod TypeAddSetPrint(code As %String, seqno As %String, typeStr As %String)
{
	q:(code="") -2
	s HospitalRowId=$p(code,"@",1)
	s TypeCode=$p(code,"@",2)
	i (HospitalRowId="")!(TypeCode="") q -2
	s rw=$I(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode))
	s ^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw)=typeStr
}

ClassMethod DelTitl(Typ, rw) As %String
{
	//n (Typ,seq)
	s HospitalRowId=$p(Typ,"@",1)
	s TypeCode=$p(Typ,"@",2)
	i (HospitalRowId="")!(TypeCode="") q -2
	k ^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw)
	q 0
}

ClassMethod UpdateTitl(rw, TypStr, Typ) As %String
{
	s HospitalRowId=$p(Typ,"@",1)
	s TypeCode=$p(Typ,"@",2)
	i (HospitalRowId="")!(TypeCode="") q -2
	s ^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,rw)=TypStr
	q 0
}

ClassMethod GetHead(Typ = "0@CQSYD") As %String
{
	//w Typ
	s HospitalRowId=$p(Typ,"@",1)
    s TypeCode=$p(Typ,"@",2)
    i (HospitalRowId="")!(TypeCode="") q -2
	s valStr=""
	if '$D(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode)) {
		b
		if $D(^DHCCLNurseExec("VarSetColumnPrtDefTyp")) 
		{
		  	s Typ=^DHCCLNurseExec("VarSetColumnPrtDefTyp")
		  	s HospitalRowId=$p(Typ,"@",1)
    		s TypeCode=$p(Typ,"@",2)
    		i (HospitalRowId="")!(TypeCode="") q -2 
		}
		else{
		q "           医嘱|4000^剂量|1000^操作时间|1500^护士签字|1500^病人或家属签字|2000^备注|2000"	
			}
	 } 
	s no=""  f  s no=$O(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no)) q:no=""  d
	.s caption=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|")
	.s len=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",2)
	.s seqno=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",5)
	.s $P(valStr,"^",seqno)=caption_"|"_len
	s $P(valStr,"!",2)=$G(^DHCCLNurseExec("VarSetColumnPrtLeftW"))
	//w valStr
	q valStr
	//q "           医嘱|4000^剂量|1000^操作时间|1500^护士签字|1500^病人或家属签字|2000^备注|2000"
}

ClassMethod SaveDefaultTyp(Typ, leftwidth) As %String
{
 k ^DHCCLNurseExec("VarSetColumnPrtDefTyp")
 s HospitalRowId=$p(Typ,"@",1)
 s TypeCode=$p(Typ,"@",2)
 i (HospitalRowId="")!(TypeCode="") q -2
 s ^DHCCLNurseExec("VarSetColumnPrtDefTyp",HospitalRowId,TypeCode)=""
 s ^DHCCLNurseExec("VarSetColumnPrtDefTyp")=Typ
 s ^DHCCLNurseExec("VarSetColumnPrtLeftW")=leftwidth
 q 0
}

ClassMethod GetDefaultTyp(Typ) As %String
{
	s HospitalRowId=$p(Typ,"@",1)
 	s TypeCode=$p(Typ,"@",2)
 	i (HospitalRowId="")!(TypeCode="") q -2
	if $D(^DHCCLNurseExec("VarSetColumnPrtDefTyp",HospitalRowId,TypeCode)) s ret=1
	else  s ret=0
	s LeftWidth=$G(^DHCCLNurseExec("VarSetColumnPrtLeftW"))
	if LeftWidth'="" s LeftWidth=LeftWidth/56.7
	e  s LeftWidth=0
	q ret_"^"_(LeftWidth)
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-24
/// Description: 取选择医院的单据
/// Table：^DHCCLNurseExec
/// Input:
/// Return：返回 HospCode_"|"_HospName_"^"_HospCode_"|"_HospName
///              单据代码|医院名称^单据代码|医院名称 
ClassMethod GetSelHospTyp(HospitalRowId As %String = "", TypeCode As %String = "") As %String
{
	s retStr=""
	s HospRowId=""
	f  s HospRowId=$o(^DHCCLNurseExec("VarDef",HospRowId)) q:HospRowId=""  d
	.q:(HospitalRowId'="")&(HospitalRowId'=HospRowId)
	.s queryTypeCode=0
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode)) q:queryTypeCode=""  d
	..q:(TypeCode'="")&(TypeCode'=queryTypeCode)
	..s code=queryTypeCode
	..s name=$p(^DHCCLNurseExec("VarDef",HospRowId,queryTypeCode),"^",1)
	..i HospRowId'=0 s HospitalName=$p($G(^CT("HOSP",HospRowId)),"^",2)
	..e  s HospitalName=""
	..s HospCode=HospRowId_"@"_code
	..s HospName=HospitalName_" "_name
	..i retStr="" s retStr=HospCode_"|"_HospName
	..e  s retStr=$G(retStr)_"^"_HospCode_"|"_HospName
	q retStr
}

Storage Default
{
<Data name="DHCLCNURCOLUMNSETPRINTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLCNURCOLUMNSETPRINTD</DataLocation>
<DefaultData>DHCLCNURCOLUMNSETPRINTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLCNURCOLUMNSETPRINTD</IdLocation>
<IndexLocation>^web.DHCLCNURCOLUMNSETPRINTI</IndexLocation>
<StreamLocation>^web.DHCLCNURCOLUMNSETPRINTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
