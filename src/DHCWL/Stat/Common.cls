Class DHCWL.Stat.Common Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ycm
/// CreatDate：    2017-12-28
/// Description:   统计室手术模块报表条件的描述解析
/// Other:         DataType:A--完整描述,B---简略描述
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Common","GetOpfilterDesc","")
Query GetOpfilterDesc(DataType As %String = "", PatTypeList As %Text = "", HospList As %Text = "", REAList As %Text = "", isGrpLoc As %String = "", CTLOCID As %String = "", PatLocList As %Text = "") As %Query(ROWSPEC = "PatTypeDescStr,HospDescStr,READescStr,isGrpLocDescStr,CTLOCDESC,PatLocDescStr") [ SqlProc ]
{
}

ClassMethod GetOpfilterDescExecute(ByRef qHandle As %Binary, DataType As %String = "", PatTypeList As %Text = "", HospList As %Text = "", REAList As %Text = "", isGrpLoc As %String = "", CTLOCID As %String = "", PatLocList As %Text = "") As %Status
{
	n (qHandle,DataType,PatTypeList,HospList,REAList,isGrpLoc,CTLOCID,PatLocList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    s PatTypeDescStr="",HospDescStr="",READescStr="",isGrpLocDescStr="",CTLOCDESC="",PatLocDescStr=""
    
    
    
    i $L(PatTypeList,",")=4 s PatTypeDescStr="全部"
    else  i PatTypeList="" s PatTypeDescStr="全部" 
    else  d
    .q:PatTypeList=""
    .i PatTypeList["I" s PatTypeDescStr=PatTypeDescStr_",住院"
    .i PatTypeList["O" s PatTypeDescStr=PatTypeDescStr_",门诊"
    .i PatTypeList["E" s PatTypeDescStr=PatTypeDescStr_",急诊"
    .i PatTypeList["H" s PatTypeDescStr=PatTypeDescStr_",体检"
    .s PatTypeDescStr=$P(PatTypeDescStr,",",2,$l(PatTypeDescStr,","))
    
    ///院区
    s HospId=0,count=0
    f  s HospId=$O(^CT("HOSP",HospId)) q:HospId=""  d
    .s count=count+1
    
	i count=$l(HospList,",") d
	.s HospDescStr="全部"
    else  i HospList'="" d
    .s len=$L(HospList,",")
    .f i=1:1:len d
    ..s HospId=$P(HospList,",",i)
    ..s HospDesc=$P($g(^CT("HOSP",HospId)),"^",2)
    ..s HospDescStr=HospDescStr_","_HospDesc
    .s HospDescStr=$P(HospDescStr,",",2,$l(HospDescStr,","))
    else  d
    .s HospDescStr="全部"
    
    ///病人身份
    s REARowid=0,count=0
    f  s REARowid=$O(^PAC("ADMREA",REARowid)) q:REARowid=""  d
    .s count=count+1
    
    i count=$l(REAList,",") d
    .s READescStr="全部"
    else  i REAList'="" d
    .s len=$L(REAList,",")
    .f i=1:1:len d
    ..s REARowid=$P(REAList,",",i)
    ..s READesc=$P($g(^PAC("ADMREA",REARowid)),"^",2)
    ..s READescStr=READescStr_","_READesc
    .s READescStr=$P(READescStr,",",2,$l(READescStr,","))
    else  d
    .s READescStr="全部"
    
    s isGrpLocDescStr=$Case(isGrpLoc,"Loc":"病人科室","Ward":"病人病区","PatType":"就诊类型","OpGrpLoc":"科室组","REA":"病人身份",:"病人科室")
 	
 	i CTLOCID'="" d
 	.q:'$d(^CTLOC(+CTLOCID))
 	.s CTLOCDESC=$P($g(^CTLOC(+CTLOCID)),"^",2)
 	.i CTLOCDESC["-" s CTLOCDESC=$P(CTLOCDESC,"-",2)
 	
    i PatLocList'="" d
    .s len=$L(PatLocList,",")
    .f i=1:1:len d
    ..s LocId=$P(PatLocList,",",i)
    ..s LocDesc=$P($g(^CTLOC(+LocId)),"^",2)
    ..i LocDesc["-" s LocDesc=$P(LocDesc,"-",2)
    ..s PatLocDescStr=PatLocDescStr_","_LocDesc
    .s PatLocDescStr=$P(PatLocDescStr,",",2,$l(PatLocDescStr,","))
    else  d
    .s PatLocDescStr="全部"
 	
 	i DataType="B" d
 	.i $l(READescStr,",")>2 d
 	..s READescStr=$P(READescStr,",",1,2)_"等"
 	.i $l(HospDescStr,",")>2 d
 	..s HospDescStr=$P(HospDescStr,",",1,2)_"等"
 	.i $l(PatLocDescStr,",")>2 d
 	..s PatLocDescStr=$P(PatLocDescStr,",",1,2)_"等"
 	
 	
 	
 	
    s Data=$lb(PatTypeDescStr,HospDescStr,READescStr,isGrpLocDescStr,CTLOCDESC,PatLocDescStr)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetOpfilterDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpfilterDescExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOpfilterDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpfilterDescExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator：      ycm
/// CreatDate：    2017-12-28
/// Description:   输出科室 ^PAADMi("DepDateTime"
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Common","GetAdmLoc")
Query GetAdmLoc() As %Query(ROWSPEC = "LocId,LocCode,LocDesc") [ SqlProc ]
{
}

ClassMethod GetAdmLocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    s LocId=0
    f  s LocId=$O(^PAADMi("DepDateTime",LocId)) q:LocId=""  d
    .s LocCode=$P($g(^CTLOC(LocId)),"^",1)
    .s LocDesc=$P($g(^CTLOC(LocId)),"^",2)
    .i LocDesc["-" s LocDesc=$P(LocDesc,"-",2)
    .s Data=$lb(LocId,LocCode,LocDesc)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	.q
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetAdmLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAdmLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmLocExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator：      ycm
/// CreatDate：    2017-12-28
/// Description:   输出病人身份 PAC_AdmReason
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Common","GetREA")
Query GetREA() As %Query(ROWSPEC = "REARowid,REACode,READesc") [ SqlProc ]
{
}

ClassMethod GetREAExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    s REARowid=0
    f  s REARowid=$O(^PAC("ADMREA",REARowid)) q:REARowid=""  d
    .s REACode=$P(^PAC("ADMREA",REARowid),"^",1)
    .s READesc=$P(^PAC("ADMREA",REARowid),"^",2)
    .s Data=$lb(REARowid,REACode,READesc)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	.q
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetREAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetREAExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetREAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetREAExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Creator：      ycm
/// CreatDate：    2017-12-28  CT_Hospital
/// Description:   输出院区描述
/// d ##class(%ResultSet).RunQuery("DHCWL.Stat.Common","GetHosp")
Query GetHosp() As %Query(ROWSPEC = "HospId,HospCode,HospDesc") [ SqlProc ]
{
}

ClassMethod GetHospExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    s HospId=0
    f  s HospId=$O(^CT("HOSP",HospId)) q:HospId=""  d
    .s HospCode=$P(^CT("HOSP",HospId),"^",1)
    .s HospDesc=$P(^CT("HOSP",HospId),"^",2)
    .s Data=$lb(HospId,HospCode,HospDesc)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	.q
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// 拆分字符串 Str:字符串,splitV:拆分节点,DataV：存储节点
/// 拆分后的数据存在临时global：^TEMPDHCWL("S",$j)
ClassMethod split(Str As %Text, splitV As %String = ",", DataV As %String) As %String
{
	new (Str,splitV,DataV)
	quit:Str="" "0"
	quit:DataV="" "0"
	
	i splitV="" s splitV=","
	
	i Str'="" d
	.s len=$L(Str,splitV)
	.f i=1:1:len d
	..s v=$P(Str,splitV,i)
	..q:v=""
	..s ^TEMPDHCWL("S",$j,DataV,v)=""
	
	q "1"
}

/// 获取科室的描述
ClassMethod GetLocDesc(LocId As %String) As %String
{
	n (LocId)
	s ret=""
	q:+LocId=0 ret
	q:'$d(^CTLOC(+LocId)) ret
	
	s ret=$P($g(^CTLOC(+LocId)),"^",2)
	
	i ret["-" s ret=$P(ret,"-",2)
	
	q ret
}

/// 获取医生的描述
ClassMethod GetCTPCPDesc(CTPCPRowid As %String) As %String
{
	n (CTPCPRowid)
	s ret=""
	q:+CTPCPRowid=0 ret
	q:'$d(^CTPCP(+CTPCPRowid,1)) ret
	i CTPCPRowid'["|" d
	.s ret=$P($g(^CTPCP(+CTPCPRowid,1)),"^",2)
	e  d  //器械护士和巡回护士这里会同时传入多个医生id,格式为"id1|id2"
	.s ret=""
	.s ln=$l(CTPCPRowid,"|")
	.f i=1:1:ln d
	..s id=$p(CTPCPRowid,"|",i)
	..s desc=$P($g(^CTPCP(+id,1)),"^",2)
	..i ret="" s ret=desc
	..e  s ret=ret_" "_desc
		
	q ret
}

}
