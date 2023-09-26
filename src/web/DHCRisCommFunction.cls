Import SQLUser

/// TRAKCARE RIS Common Function
/// 类 web.DHCRisCommFunction
/// 功能说明：封装RIS的代码设置，获取的基础类，包括科室，资源等等
/// 作者：龚平
/// 日期：2007-03-02
/// 
Class web.DHCRisCommFunction Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 68;

/// 查询名称：QueryResource
/// 功能：查询本科室可以预约的资源
/// 参数：LocID:科室ROWID
/// 返回：资源列表 
/// 作者：龚平
/// 日期：2007-03-08
/// d ##class(%ResultSet).RunQuery("web.DHCRisCommFunction","QueryResource","20")
Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=2
	s Today=+$h s ResEndDate=""
	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s EQDR=$p(^RB("RES",RowId),"^",3)
	.Q:(EQDR="")
	.s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	.s ResStarDate=$p(^RBC("EQ",EQDR),"^",4)
	.s ResEndDate=$p(^RBC("EQ",EQDR),"^",5)
	.Q:(ResEndDate'="")
	
    .Do OutputResRow
    
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputResRow
	set Data=$lb($g(ResDesc),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	;Set ^CacheTemp(repid,1)=$lb("所有","")
 	
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
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

ClassMethod QueryResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询名称：GetCareProv
/// 功能：获得科室医护人员的信息
/// 参数：Locrowid:科室ROWID
/// 返回：医护人员信息 
/// 作者：龚平
/// 日期：2007-03-02
Query GetCareProv(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetCareProvExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
	s ind=1
	
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.i CareProvrowid'=""  d
	..i ^DHCRisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
 	..Do OutCareProv 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCareProv
	set Data=$lb(CareProvDesc,CareProvrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareProvExecute ]
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

ClassMethod GetCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称：GetCareProvRowid
/// 功能：根据医护人员的名称 获得ROWID
/// 参数：医护人员的名称
/// 返回：医护人员的ROWID
/// 作者：龚平
/// 日期：2007-03-06
ClassMethod GetCareProvDR(Locrowid, Desc) As %String
{
	s GetCareRowid=""
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.i CareProvrowid'=""  d
	..i ^DHCRisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3)
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
 	..i CareProvDesc=Desc s GetCareRowid=CareProvrowid
 	q GetCareRowid
}

/// 函数名称：GetEQGroupDR
/// 功能：根据科室ROWID，检查组的描述，获得检查组（检查室）ROWID
/// 参数：科室ROWID，检查组的描述，
/// 返回：获得检查组（检查室）ROWID
/// 作者：龚平
/// 日期：2007-03-06
ClassMethod GetEQGroupDR(Locrowid, Desc) As %String
{
	s EQGroupDR=""
    s resrowid=0 f  s resrowid=$O(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s Equipmentrowid=$p(ResInfo,"^",3)
 	.i Equipmentrowid'="" d 
 	..s ResourceDesc=$p(^RBC("EQ",Equipmentrowid) ,"^",2)
 	..s EQDr=$p(^RBC("EQ",Equipmentrowid) ,"^",3)
 	..i EQDr'="" d
 	...s ^tmpRISEQDesc(EQDr)=$p(^RBC("GRP",EQDr),"^",2)
    s Dr=0 f  s Dr=$o(^tmpRISEQDesc(Dr)) q:Dr=""  d
    .i ^tmpRISEQDesc(Dr)=Desc s EQGroupDR=Dr
    q EQGroupDR
}

/// 函数名称：GetRoomDR
/// 功能：根据科室,房间名称 取得ROWID
/// 参数：科室ROWID,房间名
/// 返回：房间的ROWID
/// 作者：龚平
/// 日期：2007-03-06
/// 
ClassMethod GetRoomDR(LocDR, Desc) As %String
{
	s roomdr=""
   	s roomrowid=0 f  s roomrowid=$O(^DHCRBCi(0,"LocDR",LocDR,roomrowid)) q:(roomrowid="")  d
	.s roomname=$p(^DHCRBC("Room",roomrowid),"^",2)
	.b
	.i roomname=Desc s roomdr=roomrowid
  q roomdr
}

/// 函数名称：GetEQDR
/// 功能：根据科室,设备名称取得ROWID
/// 参数：科室ROWID,设备名称
/// 返回：设备ROWID
/// 作者：龚平
/// 日期：2007-03-06
/// ##class(web.DHCRisCommFunction).GetEQDR(LocDR,Desc)
ClassMethod GetEQDR(LocDR, Desc) As %String
{
	s GetEQDr=""
	s LocDR=$tr(LocDR,$c(0))
	s resrowid=0 f  s resrowid=$O(^RB("RES",0,"CTLOC",LocDR,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s EQDR=$p(ResInfo,"^",3)
 	.i EQDR'="" d 
 	..q:'$d(^RBC("EQ",EQDR))
	..s EQDesc=$p(^RBC("EQ",EQDR) ,"^",2)
 	..i EQDesc=Desc s GetEQDr=EQDR
 	q GetEQDr
}

/// 查询名称：QueryPadmType
/// 功能：查询病人类型
/// 参数：空
/// 返回：病人类型，ROWID 
/// 作者：龚平
/// 日期：2007-03-02
Query QueryPadmType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPadmTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("门诊病人","O")
 	Set ^CacheTemp(repid,2)=$lb("住院病人","I")
 	Set ^CacheTemp(repid,3)=$lb("急诊病人","E")
    Set ^CacheTemp(repid,4)=$lb("体检病人","H")
    Set ^CacheTemp(repid,5)=$lb("其他病人","N")
    Set ^CacheTemp(repid,6)=$lb("所有","")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPadmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
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

ClassMethod QueryPadmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询名称：QueryOtherLogLoc
/// 功能：获得该用户可以登陆的其他科室
/// 参数：USERDR：ss_user.rowid
/// 返回：科室名称，科室Rowid
/// 作者：龚平
/// 日期：2007-03-02
/// d ##class(%ResultSet).RunQuery("web.DHCRisCommFunction","QueryOtherLogLoc","4815")
Query QueryOtherLogLoc(USERDR As %String, docType As %String = "") As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod QueryOtherLogLocExecute(ByRef qHandle As %Binary, USERDR As %String, docType As %String = "") As %Status
{
	s ^TMP1110=USERDR
	Set repid=$I(^CacheTemp)
	s ind=1
	
	if ( docType="ClinicalDoc")
	{
		// 临床大夫查询从当天开始有可预约资源的检查科室
		s LocDR=""
		for
		{
			s LocDR=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocDR))
			q:(LocDR="")
			s dateNearest=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocDR,+$h))
			if (dateNearest'="")
			{
				s LocDesc=$p(^CTLOC(LocDR),"^",2)
				do OutOtherLoc
			}
			
		}
	}
	else
	{
		set LocDR=$p(^SSU("SSUSR",USERDR),"^",4)
	 	i LocDR'=""  d
	 	.s LocDesc=$p(^CTLOC(LocDR),"^",2)
	 	.d OutOtherLoc
	 	
		s ochildsub=0 f  s ochildsub=$o(^SSU("SSUSR",USERDR,"OTHLL",ochildsub)) q:(ochildsub="")  d
		.s LocDR=$p(^SSU("SSUSR",USERDR,"OTHLL",ochildsub),"^",1)
		.i LocDR'="" d
		..s LocDesc=$p(^CTLOC(LocDR),"^",2)
		..Do OutOtherLoc
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOtherLoc

	quit:($d(existLoc(LocDR)))
	set Data=$lb(LocDesc,LocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	s existLoc(LocDR)=""
	quit
}

ClassMethod QueryOtherLogLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOtherLogLocExecute ]
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

ClassMethod QueryOtherLogLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOtherLogLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：FindexeLoc
/// 功能：获得该用户可以登陆的其他科室
/// 参数：USERDR：ss_user.rowid
/// 返回：科室名称，科室Rowid
/// 作者：龚平
/// 日期：2007-03-02
Query QueryExeLoc(Desc As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod QueryExeLocExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	/*s LocType="E"
	Set RowId=0	f  s RowId=$o(^CTLOC(0,"LocType",LocType,RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2) 
	.i (GetDesc[Desc) d
	..Do OutputRow*/

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s LocType="E"
 	s Desc=$ZCONVERT(Desc,"U") 
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2)
	.s Gettype=$p(^CTLOC(RowId),"^",13)
	.q:(LocType'="")&(Gettype'=LocType)
	.i (GetDesc[Desc) d
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryExeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExeLocExecute ]
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

ClassMethod QueryExeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// s itemprice=##class(web.DHCRisCommFunction).GetItemPrice(oeorditemrowid)

Query QueryLocInfo(Desc As %String, LocType As %String = "E") As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod QueryLocInfoExecute(ByRef qHandle As %Binary, Desc As %String, LocType As %String) As %Status
{
	s Desc=$tr(Desc,$c(0))
	s LocType=$tr(LocType,$c(0))
	s Desc=$ZCONVERT(Desc,"U")
	
	s ^tmp111=Desc_"^"_Desc
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2)
	.s Gettype=$p(^CTLOC(RowId),"^",13)
	.q:(LocType'="")&(Gettype'=LocType)
	.i (GetDesc[Desc) d
	..Do OutLocRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutLocRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInfoExecute ]
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

ClassMethod QueryLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询名称：QuerySystemPatientStatus
/// 功能：查询系统的病人状态
/// 参数：空
/// 返回：状态ROWID，状态代码，状态描述
/// 作者：龚平
/// 日期：2007-03-02
/// d ##class(%ResultSet).RunQuery("web.DHCRisCommFunction","QuerySystemPatientStatus")
Query QuerySystemPatientStatus() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QuerySystemPatientStatusExecute(ByRef qHandle As %Binary, USERDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^DHCRBCStatus("PatientStatus",rowid)) q:(rowid="")  d
	.s code=$p(^DHCRBCStatus("PatientStatus",rowid),"^",1)
	.s desc=$p(^DHCRBCStatus("PatientStatus",rowid),"^",2)
	.q:((code="RJ")||(code="E"))
	.Do OutSystmStatus 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSystmStatus
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuerySystemPatientStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
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

ClassMethod QuerySystemPatientStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryReportStatus
/// 功能：查询报告状态
/// 参数：空
/// 返回：状态ROWID，状态代码，状态描述
/// 作者：龚平
/// 日期：2007-03-02
Query QueryReportStatus() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QueryReportStatusExecute(ByRef qHandle As %Binary, USERDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^DHCRBCStatus("ReportStatus",rowid)) q:(rowid="")  d
	.s code=$p(^DHCRBCStatus("ReportStatus",rowid),"^",1)
	.s desc=$p(^DHCRBCStatus("ReportStatus",rowid),"^",2)
	.Do OutStatus
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStatus
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportStatusExecute ]
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

ClassMethod QueryReportStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryEQGroup
/// 功能：查询设备组
/// 参数：科室ROWID
/// 返回：设备组描述，ROWID
/// 作者：龚平
/// 日期：2007-03-02
Query QueryEQGroup(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod QueryEQGroupExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^tmpRISEQDesc
	s resrowid=0 f  s resrowid=$O(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s Equipmentrowid=$p(ResInfo,"^",3)
 	.i Equipmentrowid'="" d 
 	..s ResourceDesc=$p(^RBC("EQ",Equipmentrowid) ,"^",2)
 	..s EQDr=$p(^RBC("EQ",Equipmentrowid) ,"^",3)
 	..i EQDr'="" d
 	...s ^tmpRISEQDesc(EQDr)=$p(^RBC("GRP",EQDr),"^",2)
    s Dr=0 f  s Dr=$o(^tmpRISEQDesc(Dr)) q:Dr=""  d
    .set Data=$lb(^tmpRISEQDesc(Dr),Dr)
 	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	
 	set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryEQGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQGroupExecute ]
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

ClassMethod QueryEQGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryRoom
/// 功能：查询房间
/// 参数：科室ROWID
/// 返回：ROWID，房间描述
/// 作者：龚平
/// 日期：2007-03-02
Query QueryRoom(LocDR As %String) As %Query(ROWSPEC = "roomrowid:%String,roomcode:%String,roomname:%String")
{
}

ClassMethod QueryRoomExecute(ByRef qHandle As %Binary, LocDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s roomrowid=0 f  s roomrowid=$O(^DHCRBCi(0,"LocDR",LocDR,roomrowid)) q:(roomrowid="")  d
	.s roomcode=$p(^DHCRBC("Room",roomrowid),"^",1)
	.s roomname=$p(^DHCRBC("Room",roomrowid),"^",2) 
	.Do OutRoom 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRoom
	set Data=$lb(roomrowid,roomcode,roomname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRoomExecute ]
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

ClassMethod QueryRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryEQ
/// 功能：根据科室和房间查询设备
/// 参数：科室ROWID，房间ROWID
/// 返回：设备ROWID，设备代码，设备描述
/// 作者：龚平
/// 日期：2007-03-02
Query QueryEQ(LocDR As %String, RoomDR As %String) As %Query(ROWSPEC = "rw:%String,code:%String,desc:%String")
{
}

ClassMethod QueryEQExecute(ByRef qHandle As %Binary, LocDR As %String, RoomDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s LocDR=$tr(LocDR,$c(0))
	s RoomDR=$tr(RoomDR,$c(0))
	S ^lxs(0)=LocDR_"^"_RoomDR
	i RoomDR'="" d
	.s EQrowid=0 f  s EQrowid=$O(^DHCRBC(0,"RoomEquipment",RoomDR,EQrowid)) q:(EQrowid="")  d
	..s EQDR=$p(^DHCRBC(0,"RoomEquipment",RoomDR,EQrowid),"^",1)  
	..i EQDR'="" d 
	...s EQCode=$p(^RBC("EQ",EQDR),"^",1)
	...s EQDesc=$p(^RBC("EQ",EQDR),"^",2) 
	...Do OutEQ
	e  i LocDR'=""  d
	.s resrowid=0 f  s resrowid=$O(^RB("RES",0,"CTLOC",LocDR,resrowid)) q:(resrowid="")  d
	..s ResInfo=^RB("RES",resrowid)
	..s EQDR=$p(ResInfo,"^",3)
 	..i EQDR'="" d 
 	...s ^EQDR(0)=EQDR
 	...q:'$d(^RBC("EQ",EQDR))
 	...s EQCode=$p(^RBC("EQ",EQDR),"^",1)
 	...s EQDesc=$p(^RBC("EQ",EQDR) ,"^",2)
 	...Do OutEQ 
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutEQ
	set Data=$lb(EQDR,EQCode,EQDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryEQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQExecute ]
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

ClassMethod QueryEQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryBodyPart
/// 功能：根据科室查找对应的部位
/// 参数：科室ROWID
/// 返回：部位的信息
/// 作者：龚平
/// 日期：2007-03-02
Query QueryBodyPart(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String,code:%String")
{
}

ClassMethod QueryBodyPartExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s bodyrowid=0 f  s bodyrowid=$o(^MRC("BODP",bodyrowid)) q:(bodyrowid="")  d
	.s bodyInfo=^MRC("BODP",bodyrowid)
	.s bodycode=$p(bodyInfo,"^",1)
	.s bodydesc=$p(bodyInfo,"^",2)
	.s getlocrowid=$p(bodyInfo,"^",3)
	.i Locrowid=getlocrowid  d
	..Do OutBodyPart 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutBodyPart
	set Data=$lb(bodydesc,bodyrowid,bodycode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBodyPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBodyPartExecute ]
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

ClassMethod QueryBodyPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBodyPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称： GetTypeDesc
/// 功能：获得病人类型的描述
/// 参数：输入病人类型的代码
/// 返回：描述
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetTypeDesc(type)
{
	s Desc=""
	I type="I" d
	.s Desc="住院病人"
	else  i type="O" d 
	.s Desc="门诊病人"
	else  i type="E" d 
	.s Desc="急诊病人"
	else  i type="H" d
	.s Desc="体检病人" d
	else  d
	.s Desc="其他病人"
   q Desc
}

/// 函数名称： GetPaadmTypeCode
/// 功能：获得病人类型的代码
/// 参数：输入病人类型的描述
/// 返回：代码
/// 作者：龚平
/// 日期：2007-03-02
/// ##class(web.DHCRisCommFunction).GetPaadmTypeCode
ClassMethod GetPaadmTypeCode(Desc)
{
	s Code=""
	I Desc="住院病人" d
	.s Code="I"
	else  i Desc="门诊病人" d 
	.s Code="O"
	else  i Desc="急诊病人" d 
	.s Code="E"
	else  i Desc="体检病人" d
	.s Code="H" d
	else
	.s Code=""
   q Code
}

/// 函数名称： GetPatientStatusCode
/// 功能：获得病人状态代码
/// 参数：输入病人状态描述
/// 返回：代码
/// 作者：龚平
/// 日期：2007-03-08
/// ##class(web.DHCRisCommFunction).GetPatientStatusCode
ClassMethod GetPatientStatusCode(Desc) As %String
{
	s GetCode=""
	s rowidP="" f  s rowidP=$o(^DHCRBCStatus("PatientStatus",rowidP)) q:rowidP=""  d
	.s GetDesc=$p(^DHCRBCStatus("PatientStatus",rowidP),"^",2)
	.i GetDesc=Desc s GetCode=$p(^DHCRBCStatus("PatientStatus",rowidP),"^",1)
	q GetCode
}

/// 函数名称： GetResourceID
/// 功能：根据科室LocID和资源描述获得 资源的ROWID
/// 参数：科室ROWID，描述
/// 返回：资源ROWID
/// 作者：龚平
/// 日期：2007-03-08
/// ##class(web.DHCRisCommFunction).GetResourceID
ClassMethod GetResourceID(Desc, LocID) As %String
{
	s GetResourceID=""
	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s CTCPDR=$p(^RB("RES",RowId),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	..i ResDesc=Desc  s GetResourceID=CTCPDR 
	.else  d
	..s EQDR=$p(^RB("RES",RowId),"^",3)
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	..i ResDesc=Desc  s GetResourceID=EQDR
    q GetResourceID
}

/// 函数名称： CalAge
/// 功能：计算年龄
/// 参数：出生日期，日期
/// 返回：指定日期的年龄
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod CalAge(Birth, Today)
{
 ; pass in date of birth in internal format
 ;
 n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 s Birth=$g(Birth),Today=$g(Today)
 s reage=""
 q:(Birth="")
 s IBirth="",IToday=""
 s IBirth=$zdh(Birth,3)
 s IToday=$zdh(Today,3)
  ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
  ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1

 s $P(AgeYr,"|",12)=AgeYear
 i $P(AgeYr,"|",12)=0 d
 .i AgeMth=0 s reage=AgeDay_"天"
 .e  s reage=AgeMth_"月"
 e  s reage=$p(AgeYr,"|",12)_"岁"
  ;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
 q reage
}

/// 函数名称：GetLocName
/// 功能：获得科室的名称
/// 输入参数：LOCID
/// 返回:科室名称
/// 作者：龚平
/// 日期：2007-03-19
ClassMethod GetLocName(LocID) As %String
{
	s LocName=""
	if (LocID'="") d 
	.s LocName=$p(^CTLOC(LocID),"^",2)
	q LocName
}

/// 函数名称：SetSession
/// 功能：设置当前选择的科室的Session
/// 输入参数：Session的名称，Session值
/// 返回：空
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod SetSession(Name As %Library.String, Value As %Library.String)
{
	//if %session.Data(Name)="" s %session.Data(Name)=%session.Get("LOGON.CTLOCID")	
	s %session.Data(Name)=Value
}

/// 函数名称：GetSession
/// 功能：获得当前指定名称Session 值
/// 输入参数：Session的名称
/// 返回：Session的值
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetSession(Name As %Library.String)
{
   
    s val=""
    q:(Name="") val
	if $Get(%session.Data(Name))=""
	{
		s val=""
	}
	else
	{
		s val=%session.Get(Name)
	}  
	q val
}

/// 函数名称：CalDays
/// 功能：计算两个日期的天数差
/// 输入参数：开始日期，结束日期
/// 返回：天数
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod CalDays(Stday As %String, Edday As %String)
{
	s stday=$zdh(Stday,4)
	s edday=$zdh(Edday,4)
	s days=edday-stday
	q days
}

/// 函数名称：GetRoomByEQ
/// 功能：根据设备获得房间名称
/// 输入参数：设备ROWID
/// 返回：设备名称
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetRoomByEQ(EQDr) As %String
{
	s RoomDR="",RoomDesc=""
	s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDr,0))
	i RoomDR'=""  s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
	q RoomDesc_"^"_RoomDR
}

/// 函数名称：GetEQGroup
/// 功能：根据设备获得设备组名称（检查室）
/// 输入参数：设备ROWID
/// 返回：设备组（检查室）
/// 作者：龚平
/// 日期：2007-03-02
/// s EQGroupInfo=##class(web.DHCRisCommFunction).GetEQGroup(EQDr)
/// s EQGroupDesc=$p(EQGroupInfo,"^",1)
ClassMethod GetEQGroup(EQDr) As %String
{
	s EQGroupDR="",EQGroupDesc=""
	s EQGroupDR=$p(^RBC("EQ",EQDr),"^",3)
	i EQGroupDR'="" s EQGroupDesc=$p(^RBC("GRP",EQGroupDR),"^",2)
	q EQGroupDesc_"^"_EQGroupDR
}

/// 函数名称：GetSystemParam
/// 功能：获得系统参数信息，包括版本设置信息等
/// 输入参数：
/// 返回：系统参数信息
/// 作者：龚平
/// 日期：2007-03-02
/// s SystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
/// s DHCRisVersion=$p(SystemInfo,"^",14)
///  
ClassMethod GetSystemParam() As %String
{
	
	s ItemMoreReport="N"
	s MoreItemReport="N"
	s SendApptoLoc="Y"
	s SendInPtoLoc="Y"
	s SendOutPtoLoc="Y"
	s SendEmPtoLoc="N"
	s SayAppCfl="Y"
	s DSPAppointmentInterval="30"
	s QueryonlyExam="N"
	s AllowOpRegNotPaid="Y"
	s AllowIpRegNotPaid="Y"
	s AllowHPRegNotPaid="N"
	s AllowEMRegNotPaid="Y"
	s SendHPtoLoc="Y"
	s DHCRisVersion="BJ_JST"
	s rowid=0
	s rowid=$o(^DHCRBC("SystemParam",rowid))
	i rowid'="" d 
	.s ItemMoreReport=$p(^DHCRBC("SystemParam",rowid),"^",1)
	.s MoreItemReport=$p(^DHCRBC("SystemParam",rowid),"^",2)
	.s SendApptoLoc=$p(^DHCRBC("SystemParam",rowid),"^",3)
	.s SendEmPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",4)
	.s SendInPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",5)
	.s SendOutPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",6)
	.s SayAppCfl=$p(^DHCRBC("SystemParam",rowid),"^",7)	
	.s DSPAppointmentInterval=$p(^DHCRBC("SystemParam",rowid),"^",8)	
	.s QueryonlyExam=$p(^DHCRBC("SystemParam",rowid),"^",9)
	.s SendHPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",10)
	.s AllowOpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",11)
	.s AllowIpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",12)
	.s AllowHPRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",13)
	.s AllowEMRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",14)
	.s ^DHCRisVersion=$p(^DHCRBC("SystemParam",rowid),"^",15)
	s Info=ItemMoreReport_"^"_MoreItemReport_"^"_SendApptoLoc_"^"_SendInPtoLoc_"^"_SendOutPtoLoc_"^"_SendEmPtoLoc_"^"_SayAppCfl_"^"_DSPAppointmentInterval_"^"_QueryonlyExam_"^"_SendHPtoLoc_"^"_AllowOpRegNotPaid_"^"_	AllowIpRegNotPaid_"^"_AllowHPRegNotPaid_"^"_AllowEMRegNotPaid_"^"_^DHCRisVersion
	q Info
}

/// 函数名称：GetReportStatusDesc
/// 功能：根据报告的状态代码获得报告状态的描述
/// 输入参数：报告代码
/// 返回：报告状态的描述
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetReportStatusDesc(Code As %String) As %String
{
	s Desc=""
	s rowid=$o(^DHCRBCStatusi("RCode",Code,0))
	i rowid'="" s Desc=$p(^DHCRBCStatus("ReportStatus",rowid),"^",2) 
	q Desc
}

/// 函数名称：GetPatientStatusDesc
/// 功能：根据病人的状态代码获得病人状态的描述
/// 输入参数：病人状态代码
/// 返回：病人状态的描述
/// 作者：龚平
/// 日期：2007-03-02
ClassMethod GetPatientStatusDesc(Code) As %String
{
	
	s Desc=""
	s rowidP=$o(^DHCRBCStatusi("Code",Code,0))
	i rowidP'="" s Desc=$p(^DHCRBCStatus("PatientStatus",rowidP),"^",2) 
	q Desc
}

ClassMethod SetMedTrakNameSpace()
{
	;zn "MEDDATA"
	zn "DHC-DATA"
}

ClassMethod SetWebsourceNameSpace()
{
	;zn "WEBSRC"
	 zn "DHC-APP"
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

/// 查询名称：QueryOccuption
/// 功能：根据科室查找对应的部位
/// 参数：科室ROWID
/// 返回：部位的信息
/// 作者：龚平
/// 日期：2007-03-02
Query QueryOccuption() As %Query(ROWSPEC = "desc:%String,code:%String,rw:%String")
{
}

ClassMethod QueryOccuptionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^CT("OCC",rowid)) q:(rowid="")  d
	.s desc=$p(^CT("OCC",rowid),"^",2)
	.s code=$p(^CT("OCC",rowid),"^",1)
	.Do OutQueryOccuption 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQueryOccuption
	set Data=$lb(desc,code,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOccuptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOccuptionExecute ]
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

ClassMethod QueryOccuptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOccuptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询名称：QueryHospital
/// 功能：根据科室查找对应的部位
/// 参数：科室ROWID
/// 返回：部位的信息
/// 作者：龚平
/// 日期：2007-03-02
/// 龚平
Query QueryHospital() As %Query(ROWSPEC = "desc:%String,code:%String,rw:%String")
{
}

ClassMethod QueryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^CT("HOSP",rowid)) q:(rowid="")  d
	.s desc=$p(^CT("HOSP",rowid),"^",2)
	.s code=$p(^CT("HOSP",rowid),"^",1)
	.Do OutQueryHosp 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQueryHosp
	set Data=$lb(desc,code,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospitalExecute ]
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

ClassMethod QueryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取医嘱的价格
/// /w ##class(web.DHCRisCommFunction).GetItemPrice("3||100")
ClassMethod GetItemPrice(oeorditemrowid)
{
	n (oeorditemrowid)
	q:oeorditemrowid="" ""
	s ItemPrice="",HospitalDR="",GetRecLocdr=""
	s OrderRowid=$p(oeorditemrowid,"||",1) 
	s itemsub=$p(oeorditemrowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)  
	s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	s GetRecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	i GetRecLocdr'=""  s HospitalDR=$p($g(^CTLOC(GetRecLocdr)),"^",22)
	
	s Type=$p(^PAADM(paadmdr),"^",2)
  	;q:Type="H" OEPrice
 	if (Type="H")
 	{
	 	if ( ##class(websys.Conversions).IsValidMethodName("web.DHCPE.HandlerPreOrds","GetArcimFactAmountByOEORIDR") )
	 	{
			s ItemPrice=##class(web.DHCPE.HandlerPreOrds).GetArcimFactAmountByOEORIDR(oeorditemrowid)
			q ItemPrice
	 	}
 	}


  
	s SystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(SystemInfo,"^",15)
    if (DHCRisVersion="BJ_AZ") 
    {
	    s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemrowid,0))
	    if (regrowid'="")
	    {
		    s ItemPrice=$p($g(^DHCPACRegInfo(regrowid)),"^",18)
		    if ((ItemPrice="")!(ItemPrice=0))
		    { 
		       d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
		       ;s ItemPrice=$$getMasterOrderFee^CHOPOrderEntry(orditemrowid) //sunyi 20091204
    		   d ##class(web.DHCRisCommFunction).SetWebsourceNameSpace()
		    }
	    }
    }
    elseif (DHCRisVersion="HRB_HYD")
    {
	  	d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
	    s priceinfo=$$GetOrderPrice^DHCPRICE("","",arcimid,SttDate,"","","","") 
	    d ##class(web.DHCRisCommFunction).SetWebsourceNameSpace()
	    s ItemPrice=$p(priceinfo,"^",1)
    }
    else 
    {
	    b //03
	  	s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice,HospitalDR)
	  	s ItemPrice=$p(priceinfo,"^",1)
    }
	q ItemPrice
}

ClassMethod StopOrder(OEOrdItemRowid, UserRowid) As %String
{
 n (OEOrdItemRowid, UserRowid)
 s ^tmpRIS=OEOrdItemRowid_"^"_UserRowid
 k PLIST
 s err=$$select^MVBOEITM(OEOrdItemRowid)
 s CareProviderRowid=""
 i UserRowid'="" s CareProviderRowid=$p(^SSU("SSUSR",UserRowid),"^",14)
 s newstat=$o(^OEC("OSTAT",0,"Code","D",""))
 s PLIST(10)=newstat
 s PLIST(34) = +$h
 s PLIST(48) = $p($h,",",2)
 s PLIST(84) = ""
 s PLIST(94) = CareProviderRowid 
 s PLIST(141) = UserRowid
 s err=$$update^MVBOEITM(OEOrdItemRowid)
 q err
}

/// w ##class(web.DHCRisCommFunction).GetAppBillInfo("2011-12-15","2011-12-21","","","","")
ClassMethod GetAppBillInfo(StDate As %String, EndDate As %String, AppLocID As %String, RecLocID As %String, AppItemName As %String, AppValue As %String)
{
	i StDate="" d 
    .s StDate=+$h
    e  d
    .s StDate=$zdh(StDate,3)
    
    i EndDate="" d 
    .s EndDate=+$h
    e  d
    .s EndDate=$zdh(EndDate,3)
    
    s f="C:/AppInfo.txt"
    o f:"WNS"
    u f
    s num=0
    w !,"申请日期"_"^"_"申请科室"_"^"_"申请医生"_"^"_"接收科室"_"^"_"登记号"_"^"_"姓名"_"^"_"性别"_"^"_"病人类型"_"^"_"医嘱名称"_"^"_"医嘱Rowid"
   	for date=StDate:1:EndDate d
    .s approwid=0 f  s approwid=$o(^DHCRBAppi("AppDate",date,approwid)) q:(approwid="")  d
    ..s AppLocDesc="",RecLocDesc="",requestdoc=""
    ..s AppDate=$zd(date,3)
    ..s OeorditemID=$p(^DHCRBApp("Bill",approwid),"^",6)
    ..i OeorditemID'=""  d
    ...s OrderRowid=$p(OeorditemID,"||",1)
    ...s itemsub=$p(OeorditemID,"||",2)
    ...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    ...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
   	...s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
   	...q:(RecLocID'="")&(RecLocdr'=RecLocID)
	...if RecLocdr'="" d
	....s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	....i $f(RecLocDesc,"-")>0 d
	.....s RecLocDesc=$p(RecLocDesc,"-",2)
	...s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1) ;下医嘱医生
	...if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2) 
	...s GetAppLocID=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",2)
	...q:(AppLocID'="")&(GetAppLocID'=AppLocID) 
	...i GetAppLocID'="" d
	....s AppLocDesc=$p(^CTLOC(GetAppLocID),"^",2)
	....i $f(AppLocDesc,"-")>0 d
	.....s AppLocDesc=$p(AppLocDesc,"-",2)
    ...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    ...s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
    ...s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
    ...s Name1=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
    ...s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
    ...s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    ...s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    ...s typedesc=##class(web.DHCRisCommFunction).GetTypeDesc(patienttype)
    ...s num=num+1
    ...w !,AppDate_"^"_AppLocDesc_"^"_requestdoc_"^"_RecLocDesc_"^"_RegNo_"^"_Name1_"^"_SexDesc_"^"_typedesc_"^"_strOrderName_"^"_OeorditemID
    w !,"总记录数="_num
	c f
	
    q num
}

/// 根据科室ID获取所有设备ID
/// sunyi 2012-01-10  
/// w ##class(web.DHCRisCommFunction).GetResIdByLocRowid("83")
ClassMethod GetResIdByLocRowid(LocID As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryResource")
	s ret=""
	do rset.Execute(LocID)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)
	    e  s ret=ret_"@"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

Query QueryRBCEquipmentGroup() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod QueryRBCEquipmentGroupExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisCommFunction","QueryRBCEquipmentGroup") 
 s ind=1
 Set repid=$I(^CacheTemp)
 s Rowid=0 f  s Rowid=$O(^RBC("GRP",Rowid)) q:(Rowid="")  d
 .s Code=$p(^RBC("GRP",Rowid),"^",1)
 .S Desc=$p(^RBC("GRP",Rowid),"^",2)
 .S DateFrom=$p(^RBC("GRP",Rowid),"^",3)
 .s DateTo=$p(^RBC("GRP",Rowid),"^",4)
 .Do OutEquipmentGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutEquipmentGroup
 set Data=$lb(Rowid,Code,Desc,DateFrom,DateTo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryRBCEquipmentGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBCEquipmentGroupExecute ]
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

ClassMethod QueryRBCEquipmentGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBCEquipmentGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DHCRisCommFunction).getHospitalDesc("83")

ClassMethod getHospitalDesc(locRowid As %String) As %String
{
	q:(locRowid="") ""
	s hospitalRowid=$p(^CTLOC(locRowid),"^",22)
	q:(hospitalRowid="") ""
	s desc=$p(^CT("HOSP",hospitalRowid),"^",2)
	q desc
}

// w ##class(web.DHCRisCommFunction).getHospitalDescByOrder("")

ClassMethod getHospitalDescByOrder(orderList As %String) As %String
{
	s orderRowid=$p(orderList,"@",1)
	q:(orderRowid="") ""
	s recLocRowid=$p(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),3),"^",6)
	s ret=..getHospitalDesc(recLocRowid)
	q ret
}

// w ##class(web.DHCRisCommFunction).changeDateToString()

ClassMethod changeDateToString(dateChange, fromatChange As %String = "3") As %String
{
	s ^DHCRisTemp("changeDateToString")=$g(dateChange)
	s $ZT="ErrorDateString"
	 
	s dateString=""
	if ( ##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateLogicalToHtml"))
	{
		s dateString=##class(websys.Conversions).DateLogicalToHtml(dateChange)
	}
	else
	{
		s dateString=$zd(dateChange,fromatChange)
	}
	 
	q dateString
ErrorDateString
	q ""
}

// w ##class(web.DHCRisCommFunction).changeDateToLogical()

ClassMethod changeDateToLogical(dateChange) As %String
{
	s $ZT="ErrorDateLogical"
	 
	s dateLogical=""
	if ( ##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateHtmlToLogical"))
	{
		s dateLogical=##class(websys.Conversions).DateHtmlToLogical(dateChange)
	}
	else
	{
		//s dateString=$zdh(dateLogical,3)
		if dateChange["-" s dateLogical=$zdh(dateChange,3)
		if dateChange["/" s dateLogical=$zdh(dateChange,4)
	}
	 
	q dateLogical
ErrorDateLogical
	q ""
}

}
