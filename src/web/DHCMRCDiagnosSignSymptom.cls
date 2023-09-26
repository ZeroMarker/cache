/// 名称?web.DHCMRCDiagnosSignSymptom
/// 描述?症状信息维护类
/// 编写时间?2009-02-19
/// 编写作者?郭宝平
Class web.DHCMRCDiagnosSignSymptom Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 方法名称?RepSignSymptom
/// 功能描述?症状代码验证
/// 入参?DSYMCode?症状代码?
/// 返回值?
/// table:MRC_DiagnosSignSymptom(症状信息表)
/// 编写时间?2009-02-19
/// 编写人?郭宝平
ClassMethod RepSignSymptom(DSYMCode As %String)
{
	s rowid="0"
	s flag="N"
	f  s rowid=$o(^MRC("DSYM",rowid)) q:(rowid="")  d
	.s Code=$p(^MRC("DSYM",rowid),"^",1)
	
	.i (Code=DSYMCode) s flag="Y"
	q flag
}

/// 方法名称?addSignSymptom
/// 功能描述?增加症状信息
/// 入参?DSYMCode?症状代码?
/// DSYMDesc ?症状名称?
/// DSYMCTLOCDR?症状所对应的科室;foreign key?
/// DSYMDateFrom (开始日期)
/// DSYMDateTo ?截止日期?
/// DSYMActiveInActive ?有效标志?
/// 返回值?SQLCODE ?数据库操作验证标志?
/// table:MRC_DiagnosSignSymptom(症状信息表)
/// 编写时间?2009-02-19
/// 编写人?郭宝平
ClassMethod addSignSymptom(DSYMCode As %String, DSYMDesc As %String, DSYMCTLOCDR As %String, DSYMDateFrom As %String, DSYMDateTo As %String, DSYMActiveInActive As %String)
{
	s $ZT="ErrorAdd"
	TSTART
	//s DSYMDateFrom=$zdh(DSYMDateFrom,4)
	//s DSYMDateTo=$zdh(DSYMDateTo,4)
	i ($g(DSYMDateTo)["/")   s DSYMDateTo=$zdh(DSYMDateTo,4)  e  s DSYMDateTo=""
	i DSYMDateFrom'="" s DSYMDateFrom=..%ZDH(DSYMDateFrom)
    i DSYMDateTo'="" s DSYMDateTo=..%ZDH(DSYMDateTo)
    
	&SQL(insert into SQLUser.MRC_DiagnosSignSymptom 
	          values(:DSYMCode,:DSYMDesc,:DSYMCTLOCDR,"",:DSYMDateFrom,:DSYMDateTo,:DSYMActiveInActive))
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ErrorAdd
  	q "-1"
}

/// 方法名称?addSignSymptomAlias
/// 功能描述?增加症状别名
/// 入参?DSYMRowId?症状rowid?
/// aliasU?别名?
/// 返回值?SQLCODE ?数据库操作验证标志?
/// table:DHC_MRCDiagnosSignSymptomAlias(症状别名信息表)
/// 编写时间?2009-02-19
/// 编写人?郭宝平
ClassMethod addSignSymptomAlias(DSYMRowId, aliasU)
{
	
	TSTART
 i (DSYMRowId'="")&&(aliasU'="")
		{s flag=-1
		 &SQL(insert into SQLUser.DHC_MRCDiagnosSignSymptomAlias(DSYMA_ParRef,DSYMA_Alias) Values (:DSYMRowId,:aliasU))
		 i SQLCODE'="0" 
	       { TROLLBACK
 q flag
	       }
	     
			TCOMMIT
			q %ROWID
		}
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	s rowid=0
	/*i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"*/
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_rowid
	              from SQLUser.ct_loc 
	              )  //WHERE (UPPER(ctloc_desc) like :desc)
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
	.q:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1
 .Do OutputRow4	 	
 &sql(close ctloc)
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod delSignSymptom(DSYMRowId As %String)
{
	i DSYMRowId'="" d
	.&sql(delete from SQLUser.MRC_DiagnosSignSymptom 
	             where DSYM_RowId=:DSYMRowId)
	Q SQLCODE
}

/// 方法名称?delSignSymptomAlias
/// 功能描述?删除症状别名
/// 入参?DSYMRowId?症状rowid?
/// AliasID?别名id?
/// 返回值?SQLCODE ?数据库操作验证标志?
/// table:DHC_MRCDiagnosSignSymptomAlias(症状别名信息表)
/// 编写时间?2009-02-19
/// 编写人?郭宝平
ClassMethod delSignSymptomAlias(DSYMRowId, AliasID)
{
	 TSTART
	 i DSYMRowId'=""&&AliasID'="" 
	 	{s DSYMARowId=DSYMRowId_"||"_AliasID
	 	 &SQL(delete from SQLUser.DHC_MRCDiagnosSignSymptomAlias where DSYMA_RowId=:DSYMARowId )
		 i SQLCODE
	 		{TROLLBACK
			 q SQLCODE
	 		}
		TCOMMIT
		q SQLCODE
	 	}
}

/// 方法名称?getAliasByRowid
/// 功能描述?用于根据症状rowid取得对应的别名信息
/// 入参?rowid ?症状rowid?
/// 返回值?str ?别名和别名id?
/// 编写时间?2009-02-19
/// 编写人?郭宝平
ClassMethod getAliasByRowid(rowid)
{
	s alias=""
	s child=""
	q:rowid="" ""
	s Mrowid=rowid
	s childsub="0"
	f  s childsub=$o(^MRC("DSYM",Mrowid,"ALIAS",childsub))  q:childsub=""  d
	 .s DSYMAAlias=$P(^MRC("DSYM",Mrowid,"ALIAS",childsub),"^",1)
	 .i (DSYMAAlias'="")  d
	 ..s alias=alias_"^"_DSYMAAlias  //得到症状对应的所有别名?连成字符串
	 ..s child=child_"^"_childsub    //别名对应的id
	s str=alias_"%"_child         //+<修改日期?2009-02-19><修改人?郭宝平>
	quit str
}

ClassMethod getSignSymptomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getSignSymptomExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getSignSymptomExecute(ByRef qHandle As %Binary, DSYMCode As %String, DSYMDesc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid="0"
 f  s rowid=$o(^MRC("DSYM",rowid))  q:rowid=""  d
 .s CTLOCDesc=""
 .s TDSYMCode=$p(^MRC("DSYM",rowid),"^",1)
 .s TDSYMDesc =$p(^MRC("DSYM",rowid),"^",2)
 .s DSYMDateFrom=$p(^MRC("DSYM",rowid),"^",5)
 .i DSYMDateFrom'="" s DSYMDateFrom=..%ZD(DSYMDateFrom) //$zd($p(^MRC("DSYM",rowid),"^",5),4)
 .s DSYMDateTo=$p(^MRC("DSYM",rowid),"^",6)
 .//s DSYMDateTo=$zd($p(^MRC("DSYM",rowid),"^",6),4)
 .i $g(DSYMDateTo)="" s DSYMDateTo=""
 .i $g(DSYMDateTo)'="" s DSYMDateTo=..%ZD(DSYMDateTo) //$zd(DSYMDateTo,4)
 .s DSYMActiveInActive=$p(^MRC("DSYM",rowid),"^",7)
 .s TDSYMCTLOCDR=$p(^MRC("DSYM",rowid),"^",3)
 .i (TDSYMCTLOCDR'="")  d
 ..s CTLOCDesc=$p(^CTLOC(TDSYMCTLOCDR),"^",2)
 .i (((DSYMCode="")||(TDSYMCode[DSYMCode))&&((DSYMDesc="")||(TDSYMDesc[DSYMDesc))) d  //+ <修改日期?2009-02-19> <修改人?郭宝平> <修改原因?要判断输入参数是否为空>
 ..Do OutputRow																		//+
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
	set Data=$lb(TDSYMCTLOCDR,rowid,TDSYMCode,TDSYMDesc,CTLOCDesc,DSYMDateFrom,DSYMDateTo,DSYMActiveInActive)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod getSignSymptomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getSignSymptomExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {				
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {	//		
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod updateSignSymptom(DSYMRowId As %String, DSYMCode As %String, DSYMDesc As %String, DSYMCTLOCDR As %String, DSYMDateFrom As %String, DSYMDateTo As %String, DSYMActiveInActive As %String)
{
 
 s $ZT="ErrorUpdate"
 i (DSYMRowId'="")  d
 .s DSYMDateto="",DSYMDatefrom=""
 .//i ($g(DSYMDateTo)["/")   s DSYMDateto=$zdh(DSYMDateTo,4)  e  s DSYMDateto=""
 .//i ($g(DSYMDateFrom)'="") s DSYMDatefrom=$zdh(DSYMDateFrom,4)
 .i DSYMDateFrom'="" s DSYMDatefrom=..%ZDH(DSYMDateFrom)
 .i DSYMDateTo'="" s DSYMDateto=..%ZDH(DSYMDateTo)
	.&SQL(update sqluser.MRC_DiagnosSignSymptom 
	        set DSYM_Code=:DSYMCode,
	            DSYM_Desc=:DSYMDesc,
	            DSYM_CTLOC_DR=:DSYMCTLOCDR,
	            DSYM_DateFrom=:DSYMDatefrom,
	            DSYM_DateTo=:DSYMDateto,
	            DSYM_ActiveInActive=:DSYMActiveInActive 
	      where DSYM_RowId=:DSYMRowId)
	
	i SQLCODE
	{
		//TROLLBACK
		q SQLCODE
	}
	
	
	//TCOMMIT
	q SQLCODE
ErrorUpdate
	q "-1"
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "OPRCTLoc:%String,OPRLocID:%String")
{
}

/// 方法名称?getSignSymptom
/// 功能描述?症状查询
/// 入参?DSYMCode?症状代码?
/// DSYMDesc?症状名称?
/// 返回值?
/// table:MRC_DiagnosSignSymptom(症状信息表)
/// 编写时间?2009-02-19
/// 编写人?郭宝平
Query getSignSymptom(DSYMCode As %String, DSYMDesc As %String) As %Query(ROWSPEC = "CTLocid :%String,DSYMARowId:%String,DSYMACode:%String,DSYMADesc:%String,DSYMACTLOCDR:%String,DSYMADateFrom:%String,DSYMADateTo:%String,DSYMAActiveInActive:%String")
{
}

}
