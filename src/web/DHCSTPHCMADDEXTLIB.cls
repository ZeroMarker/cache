Import sqluser

/// 知识库规则维护
/// 
Class web.DHCSTPHCMADDEXTLIB Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:	计数器
/// ##class(web.DHCSTPHCMADDEXTLIB).NewPid()
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("DHCSTPHCMPASSComUtil"))
}

/// 增加知识库函数字典
ClassMethod AddFuncatFeild(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s rowid=$p(input,"^",4)
   
   
    q:rowid'="" ..UpdFuncatFeild(input)
    q:$d(^DHCPHFUNCAT(0,"Code",code)) -99 
	k PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active 
	&sql(INSERT INTO DHC_PHFunCatFeild  VALUES :PLIST())
    q:SQLCODE'=0 -1
    
	q 0
}

ClassMethod UpdFuncatFeild(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s rowid=$p(input,"^",4)
	&sql(update DHC_PHFunCatFeild set FLC_Code=:code,FLC_Desc=:desc,FLC_ActiveFlag=:active
	where FLC_RowId=:rowid
	)
	q:SQLCODE'=0 -1
	q 0
}

/// 查询知识库函数分类字典
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryFunCatList("180","1")
ClassMethod QueryFunCatList(rows, page) As %String
{
        
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s h=0
        s flcdr=0
		f  s flcdr=$o(^DHCPHFUNCAT(flcdr)) q:(flcdr="")||(flcdr=0)  d
		.s code=$p(^DHCPHFUNCAT(flcdr),"^",1)
		.s desc=$p(^DHCPHFUNCAT(flcdr),"^",2)
		.s active=$p(^DHCPHFUNCAT(flcdr),"^",3)
	    .s rowid=flcdr
	    .s data=code_"^"_desc_"^"_active_"^"_rowid
	    .
		.s h=h+1
		.s index=code_"^"_h
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunCatList",pid,index)=data
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunCatList",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunCatList",pid,h)
	    .s code=$p(data,"^",1)
	    .s desc=$p(data,"^",2)
	    .s active=$p(data,"^",3)
	    .s active=$case(active,"N":"否","Y":"是",:"")
	    .s rowid=$p(data,"^",4)
	    .
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
		.
		.s tmpstr=code_desc_active_rowid
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunCatList",pid)
	    
	    q ""
}

/// 增加函数库
ClassMethod AddPhFuns(input) As %String
{
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s funtions=$p(input,"^",4)
	s returnvalue=$p(input,"^",5)
	s remark=$p(input,"^",6)
	s catdr=$p(input,"^",7)
	s rowid=$p(input,"^",8)
	
	i rowid'="" s ret=..UpdFunLib(input)  //更新
	q:rowid'="" $G(ret)
	q:$D(^DHCPHLFUNS(0,"Code",code)) 0
	
	
	k PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=funtions
	s PLIST(5)=returnvalue
	s PLIST(6)=remark
	s PLIST(7)=active
	s PLIST(8)=catdr
	
	&sql(INSERT INTO DHC_PHLibFuntions VALUES :PLIST())
	q SQLCODE
}

/// 查询知识库函数字典
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryFunLibList("180","1")
ClassMethod QueryFunLibList(rows, page) As %String
{
        
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()

		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

        s x=0
		s h=0
        s phfundr=0
		f  s phfundr=$o(^DHCPHLFUNS(phfundr)) q:(phfundr="")||(phfundr=0)  d
		.s code=$p(^DHCPHLFUNS(phfundr),"^",1)
		.s desc=$p(^DHCPHLFUNS(phfundr),"^",2)
		.s fun=$p(^DHCPHLFUNS(phfundr),"^",3)
		.s retval=$p(^DHCPHLFUNS(phfundr),"^",4)
		.s remark=$p(^DHCPHLFUNS(phfundr),"^",5)
		.s active=$p(^DHCPHLFUNS(phfundr),"^",6)
		.s active=$case(active,"N":"否","Y":"是",:"")
		.s catdr=$p(^DHCPHLFUNS(phfundr),"^",7)
		.s parentid=""
	    .s rowid=phfundr
	    .s data=code_"^"_desc_"^"_fun_"^"_retval_"^"_remark_"^"_active_"^"_rowid_"^"_catdr
	    .
		.s h=h+1
		.s index=code_"^"_h
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Data",catdr,index)=data
		.i '$d(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Cat",catdr)) d
		..s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Cat",catdr)=""
		..s x=x+1
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()

		s maxrow=h+x
		i endpage>maxrow s endpage=maxrow
		s count=0
		
		s catdr=""
		f  s catdr=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Cat",catdr)) q:catdr=""  d
		.s catcode=$p(^DHCPHFUNCAT(catdr),"^",1)
		.s catdesc=$p(^DHCPHFUNCAT(catdr),"^",2)
		.s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",catcode)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",catdesc)
	    .s fun=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fun","")
	    .s retval=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("returnval","")
	    .s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark","")
	    .s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active","")
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",catcode)
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("_parentId","")
		.s catid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("catdr",catdr)
		.
		.s tmpstr=code_desc_fun_retval_remark_active_rowid_parentId_catid
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
	    .
		.s h=""
	    .f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Data",catdr,h)) q:h=""  d
	    ..s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid,"Data",catdr,h)
	    ..s code=$p(data,"^",1)
	    ..s desc=$p(data,"^",2)
	    ..s fun=$p(data,"^",3)
	    ..s retval=$p(data,"^",4)
	    ..s remark=$p(data,"^",5)
	    ..s active=$p(data,"^",6)
	    ..s rowid=$p(data,"^",7)
	    ..
	    ..
	    ..s catcode=$p(^DHCPHFUNCAT(catdr),"^",1)
	    ..s parentId=catcode
	    ..
	    ..s count=count+1
	    ..q:count<stpage
	    ..q:count>endpage
	    ..
	    ..s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    ..s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    ..s fun=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("funtions",fun)
	    ..s retval=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("returnval",retval)
	    ..s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	    ..s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active)
		..s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
		..s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("_parentId",parentId)
		..s catid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("catdr",catdr)
		..
		..s tmpstr=code_desc_fun_retval_remark_active_rowid_parentId_catid
		..
	    ..s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    ..s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    ..s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		..
	    ..i count=stpage w startString
	    ..i count<endpage w firstrow
	    ..i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryFunLibList",pid)
	    
	    q ""
}

ClassMethod UpdFunLib(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s funtions=$p(input,"^",4)
	s returnvalue=$p(input,"^",5)
	s remark=$p(input,"^",6)
	s catdr=$p(input,"^",7)
	s rowid=$p(input,"^",8)
	
	&sql(update DHC_PHLibFuntions set PLF_Code=:code,PLF_Desc=:desc,PLF_Funtions=:funtions,PLF_Return=:returnvalue,PLF_Remark=:remark,PLF_ActiveFlag=:active,
	PLF_Cat_Dr=:catdr
	where PLF_RowId=:rowid
	)
	q:SQLCODE'=0 -1
	q 0
}

/// 增加函数项目
ClassMethod AddLibItem(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s funtions=$p(input,"^",3)
	s remark=$p(input,"^",4)
	s active=$p(input,"^",5)
	s catdr=$p(input,"^",6)
	s rowid=$p(input,"^",7)
	s val=$p(input,"^",8)
	s arguments=$p(input,"^",9)
	s parentid=$p(input,"^",10)
	s relation=$p(input,"^",11)
	

	i rowid'="" s ret=..UpdFunLibItem(input)  //更新
	q:rowid'="" $G(ret)
	
	q:$D(^DHCLIBITMF(0,"Code",code)) 0
	
	k PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=funtions
	s PLIST(5)=remark
	s PLIST(6)=active
	s PLIST(7)=catdr
	s PLIST(8)=parentid
	s PLIST(9)=arguments
	s PLIST(10)=val
	s PLIST(11)=relation
	
	&sql(INSERT INTO DHC_PHLibItemFeild VALUES :PLIST())
	q SQLCODE
}

ClassMethod UpdFunLibItem(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s fun=$p(input,"^",3)
	s remark=$p(input,"^",4)
	s active=$p(input,"^",5)
	s catdr=$p(input,"^",6)
	s rowid=$p(input,"^",7)
	s val=$p(input,"^",8)
	s arguments=$p(input,"^",9)
	s relation=$p(input,"^",11)
	
	&sql(update DHC_PHLibItemFeild set PLIF_Code=:code,PLIF_Desc=:desc,PLIF_Fun_Dr=:fun,PLIF_Remark=:remark,PLIF_ActiveFlag=:active,PLIF_CatDr=:catdr,
	PLIF_Arguments=:arguments,PLIF_Val=:val,PLIF_Relation=:relation
	where PLIF_RowId=:rowid
	)
	q:SQLCODE'=0 -1
	q 0
}

/// 查询知识库项目
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryLibItemDs("180","1")
ClassMethod QueryLibItemDs(rows, page) As %String
{
        
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

        s x=0
		s h=0
        s phfundr=0
		f  s phfundr=$o(^DHCLIBITMF(phfundr)) q:(phfundr="")||(phfundr=0)  d
		.s code=$p(^DHCLIBITMF(phfundr),"^",1)
		.s desc=$p(^DHCLIBITMF(phfundr),"^",2)
		.s fun=""
		.s fundr=$p(^DHCLIBITMF(phfundr),"^",3)
        .i fundr'="" s fun=$p(^DHCPHLFUNS(fundr),"^",3)
		.s remark=$p(^DHCLIBITMF(phfundr),"^",4)
		.s active=$p(^DHCLIBITMF(phfundr),"^",5)
		.s active=$case(active,"N":"否","Y":"是",:"")
		.s catdr=$p(^DHCLIBITMF(phfundr),"^",6)
		.s parentid=$p(^DHCLIBITMF(phfundr),"^",7)
	    .s arguments=$p(^DHCLIBITMF(phfundr),"^",8)
	    .s val=$p(^DHCLIBITMF(phfundr),"^",9)
	    .s relation=$p(^DHCLIBITMF(phfundr),"^",10)
	    .s rowid=phfundr
	    .s data=code_"^"_desc_"^"_fun_"^"_remark_"^"_active_"^"_catdr_"^"_rowid_"^"_parentid_"^"_fundr_"^"_arguments_"^"_val_"^"_relation
	    .
	    .
		.s h=h+1
		.s index=h_"^"_code
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Data",catdr,index)=data
		.i '$d(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Cat",catdr)) d
		..s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Cat",catdr)=""
		..s x=x+1
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
        
		s maxrow=h+x
		i endpage>maxrow s endpage=maxrow
		s count=0
		
		s catdr=""
		f  s catdr=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Cat",catdr)) q:catdr=""  d
		.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Cat",catdr)
		.s code=$p(^DHCPHFUNCAT(catdr),"^",1)
		.s desc=$p(^DHCPHFUNCAT(catdr),"^",2)
		.s mainlevel=code
		.s fun=$p(data,"^",3)
		.s remark=$p(data,"^",4)
		.s active=$p(data,"^",5)
		.s catdr=catdr
		.s rowid=$p(data,"^",7)
		.s parentId=""
		.s fundr=$p(data,"^",9)
		.s arguments=$p(data,"^",10)
		.s val=$p(data,"^",11)
		.s relation=$p(data,"^",12)
		.
		.s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s fun=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fun","")
	    .s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark","")
	    .s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active","")
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",mainlevel)
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("_parentId",parentId)
		.s catid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("catdr",catdr)
		.s fundr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fundr",fundr)
		.s arguments=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("arguments",arguments)
		.s val=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("val",val)
		.s relation=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("relation",relation)
		
		.s tmpstr=code_desc_fun_fundr_remark_active_rowid_parentId_catid_arguments_val_relation
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
	    .
		.s h=""
	    .f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Data",catdr,h)) q:h=""  d
	    ..s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid,"Data",catdr,h)
		..s code=$p(data,"^",1)
		..s desc=$p(data,"^",2)
		..s fun=$p(data,"^",3)
		..s remark=$p(data,"^",4)
		..s active=$p(data,"^",5)
		..s catdr=$p(data,"^",6)
		..s rowid=$p(data,"^",7)
		..s parentId=$p(data,"^",8)
	    ..i parentId="" s parentId=mainlevel
	    ..s fundr=$p(data,"^",9)
	    ..s arguments=$p(data,"^",10)
		..s val=$p(data,"^",11)
		..s relation=$p(data,"^",12)
	    ..
	    ..s count=count+1
	    ..q:count<stpage
	    ..q:count>endpage
	    ..
	    ..s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    ..s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    ..s fun=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fun",fun)
	    ..s fundr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fundr",fundr)
	    ..s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	    ..s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active)
		..s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
		..s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("_parentId",parentId)

		..s catid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("catdr",catdr)
		..s arguments=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("arguments",arguments)
		..s val=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("val",val)
		..s relation=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("relation",relation)
		..
		..s tmpstr=code_desc_fun_fundr_remark_active_rowid_parentId_catid_arguments_val_relation
		..
	    ..s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    ..s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    ..s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		..
	    ..i count=stpage w startString
	    ..i count<endpage w firstrow
	    ..i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibItemDs",pid)
	    
	    q ""
}

ClassMethod InsertLibRuleDs() As %String
{
	/*
	s libdr=""
	f  s libdr=$o(^DHCPHPINL(0,"Lib",libdr)) q:libdr=""  d
	.s labdr=""
	.f  s labdr=$o(^DHCPHPINL(0,"Lib",libdr,labdr)) q:labdr=""  d
	..q:$D(^DHCPHLIBRULE(0,"Label",libdr,labdr))
	..k PLIST
	..s PLIST(2)=libdr
	..s PLIST(3)=labdr
	..s PLIST(4)=+$o(^DHCPHLIBRULE(0,"OrdNum",libdr,""),-1)+1
	..&sql(INSERT INTO DHC_PHLibRule VALUES :PLIST())
	..
	q 0
	
	*/
	
	s rowid=0
	f  s rowid=$o(^DHCPHPINL(rowid))  q:(rowid="")||(rowid=0)  d
	.s libdr=$p(^DHCPHPINL(rowid),"^",5)
	.q:libdr=""
	.q:$D(^DHCPHLIBRULE(0,"Label",libdr,rowid))
	.k PLIST
	.s PLIST(2)=libdr
	.s PLIST(3)=rowid
	.s PLIST(4)=+$o(^DHCPHLIBRULE(0,"OrdNum",libdr,""),-1)+1
	.&sql(INSERT INTO DHC_PHLibRule VALUES :PLIST())
	
	q 0
}

ClassMethod UpdLibRuleItm(input) As %String
{
	s rowid=$p(input,"^",1)
	s relation=$p(input,"^",2)
	s condition=$p(input,"^",3) //qnp 前提条件 17/4/10
	s condition=$case(condition,"是":"Y","否":"N",:"N")
	&sql(update DHC_PHLibRuleItm set PHLRI_Relation=:relation, PHLRI_Conditon=:condition where PHLRI_RowId=:rowid)
	q SQLCODE
}

ClassMethod UpdLibRule(input) As %String
{
	s rowid=$p(input,"^")
	s relation=$p(input,"^",2)
	&sql(update DHC_PHLibRule set PHLR_Relation=:relation where PHLR_RowId=:rowid)
	q SQLCODE
}

/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryLibRuleDs("180","1")
ClassMethod QueryLibRuleDs(rows, page) As %String
{
        
        s ret=..InsertLibRuleDs()
        s ret=##class(web.DHCSTPHCMADDEXTLIB).InsertLibRuleDs()
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

        s x=0
		s h=0
        s ruledr=0
		f  s ruledr=$o(^DHCPHLIBRULE(ruledr)) q:(ruledr="")||(ruledr=0)  d
		.s libdr=$p(^DHCPHLIBRULE(ruledr),"^",1)
		.q:'$d(^DHCPHLIBL(libdr))
		.s lib=$p(^DHCPHLIBL(libdr),"^",2)
		.//q:lib'="药品"
		.s labdr=$p(^DHCPHLIBRULE(ruledr),"^",2)
		.q:'$D(^DHCPHPINL(labdr))
		.s lab=$p(^DHCPHPINL(labdr),"^",2)
		.s ordnum=$p(^DHCPHLIBRULE(ruledr),"^",3)
		.s ordnum=ordnum+10
        .s relat=$p(^DHCPHLIBRULE(ruledr),"^",4)
        .s parentid=""
	    .s rowid=ruledr
	    .s data=lib_"^"_lab_"^"_ordnum_"^"_relat_"^"_rowid_"^"_parentid
	    .
		.s h=h+1
		.s index=lib_"^"_ordnum_"^"_h
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibRuleDs",pid,"Data",index)=data
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
        
		s maxrow=h+x
		i endpage>maxrow s endpage=maxrow
		s count=0
		
		s index=""
		f  s index=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibRuleDs",pid,"Data",index)) q:index=""  d
		.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibRuleDs",pid,"Data",index)
		.s code=$p(data,"^",1)
		.s desc=$p(data,"^",2)
		.s ordnum=$p(data,"^",3)
		.s relat=$p(data,"^",4)
		.s rowid=$p(data,"^",5)
		.s parentid=$p(data,"^",6)
		.s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .s lib=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("lib",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s ordnum=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ordnum",ordnum)
	    .s relat=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("relat",relat)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("_parentId","")
		.
		.s tmpstr=lib_desc_ordnum_relat_rowid_parentId
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
	    .
		
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibRuleDs",pid)
	    
	    q ""
}

/// 查询医生列表
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryAccDocList("180","1","298")
ClassMethod QueryAccDocList(rows, page, input) As %String
{
	
   s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
   
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   
   s doccode=$p(input,"^",1)
   s h=0
   s cartpdr=""
   f  s cartpdr=$o(^CTPCP(0,"CareProvType",cartpdr)) q:cartpdr=""  d
   .s type=$p(^CT("CPT",cartpdr),"^",4)
   .q:type'="DOCTOR"
   .s ctpcpdr=""
   .f  s ctpcpdr=$o(^CTPCP(0,"CareProvType",cartpdr,ctpcpdr)) q:ctpcpdr=""  d
   ..s ssusr=$o(^SSU("SSUSR",0,"CTPCP",ctpcpdr,"")) 
   ..q:ssusr=""
   ..s code=$p(^SSU("SSUSR",ssusr),"^",1)
   ..q:(doccode'=code)&(doccode'="")
   ..s desc=$p(^SSU("SSUSR",ssusr),"^",2)
   ..s h=h+1 
   ..s rowid=ssusr
   ..s data=code_"^"_desc_"^"_rowid
   ..
   ..s index=h
   ..s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryAccDocList",pid,"Data",index)=data
   q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryAccDocList",pid,"Data",index)) q:index=""  d
	.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryAccDocList",pid,"Data",index)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    .
	
	.
 
	k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryAccDocList",pid)
	q ""
}

/// 查询科室列表
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryDocLocList("180","1","")
ClassMethod QueryDocLocList(rows, page, input) As %String
{
   s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
   
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   s locDesc=input	//qunianpeng 2017/4/17
   s locDesc=$zcvt(locDesc,"U") 
   s len=$l(locDesc)	//前匹配用  qunianpeng  2017/10/9
   s h=0
   s locdr=""
   //f  s locdr=$o(^CTLOC(0,"LocType","E",locdr)) q:locdr=""  d
   f  s locdr=$o(^CTLOC(locdr)) q:locdr=""  d	//不过滤护理单元 qunianpeng 2018/4/13
   .q:locdr=0
   .s code=$p(^CTLOC(locdr),"^",1)
   .s desc=$p(^CTLOC(locdr),"^",2)
   .s desc=$zcvt(desc,"U")  //qunianpeng 2017/4/17
   .s tmpContactName="",tmpDesc=""
   .i len'=0 s tmpDesc=$e(desc,1,len)	//前匹配用  qunianpeng  2017/10/9
   .s contactName=$p(^CTLOC(locdr),"^",43)
   .s contactName=$zcvt(contactName,"U")  //qunianpeng 2017/10/9
   .i len'=0 s tmpContactName=$e(contactName,1,len) //前匹配用  qunianpeng  2017/10/9
   .//q:(locDesc'="")&((desc'[locDesc)&(contactName'[locDesc))
   .q:(locDesc'="")&((tmpDesc'=locDesc)&(tmpContactName'=locDesc))
   .//q:'(desc[locDesc)
   .s rowid=locdr
   .s data=code_"^"_desc_"^"_rowid
   .
   .s h=h+1
   .s index=h
   .s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryDocLocList",pid,"Data",index)=data
   q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryDocLocList",pid,"Data",index)) q:index=""  d
	.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryDocLocList",pid,"Data",index)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    .
	
	.
	
	
 
	k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryDocLocList",pid)
	q ""
}

/// 查询医院列表
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryHospList("180","1")
ClassMethod QueryHospList(rows, page) As %String
{
   s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
   
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   s h=0
   s hospdr=0
   f  s hospdr=$o(^CT("HOSP",hospdr) ) q:(hospdr="")||(hospdr=0)  d
   .s code=$p(^CT("HOSP",hospdr),"^",1)
   .s desc=$p(^CT("HOSP",hospdr),"^",2)
   .s rowid=hospdr
   .s data=code_"^"_desc_"^"_rowid
   .
   .s h=h+1
   .s index=h
   .s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryHospList",pid,"Data",index)=data
   q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryHospList",pid,"Data",index)) q:index=""  d
	.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryHospList",pid,"Data",index)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.i count=90 b
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    .
	
	.
	
	
 
	k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryHospList",pid)
	q ""
}

/// 查询职称列表
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryCtCptList("180","1")
ClassMethod QueryCtCptList(rows, page) As %String
{
   s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
   
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   s h=0
   s ctcptdr=0
   f  s ctcptdr=$o(^CT("CPT",ctcptdr)) q:(ctcptdr="")||(ctcptdr=0)  d
   .s desc=$p(^CT("CPT",ctcptdr),"^",2)
   .s rowid=ctcptdr
   .s data=desc_"^"_rowid
   .
   .s h=h+1
   .s index=h
   .s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryCtCptList",pid,"Data",index)=data
   q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryCtCptList",pid,"Data",index)) q:index=""  d
	.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryCtCptList",pid,"Data",index)
	.
	.s desc=$p(data,"^",1)
	.s rowid=$p(data,"^",2)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    .
	
	.
	
	
 
	k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryCtCptList",pid)
	q ""
}

/// 增加规则明细
ClassMethod AddRuleItm(input) As %String
{
	s main=$p(input,"^",1)
	s itmrowid=$p(input,"^",2)
	s exist=0
    s sub=""
	f  s sub=$o(^DHCPHLIBRULE(main,"I",sub)) q:sub=""  d
	.s itmdr=$p(^DHCPHLIBRULE(main,"I",sub),"^",3)
	.i itmdr=itmrowid s exist=1
	q:exist=1 0
	
	k PLIST
	s PLIST(0)=main
	s PLIST(2)=+$o(^DHCPHLIBRULE(main,"I",""),-1)+1
	s PLIST(3)=+$o(^DHCPHLIBRULE(0,"OrdNum",main,""),-1)+1
	s PLIST(5)=itmrowid
	&sql(INSERT INTO DHC_PHLibRuleItm VALUES :PLIST())
	
	q SQLCODE
}

ClassMethod DelRuleItm(input) As %String
{
	s rowid=$p(input,"^",1)
	&sql(delete from  DHC_PHLibRuleItm where PHLRI_RowId=:rowid)
	q SQLCODE
}

/// 查询知识库规则明细
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryRuleItmDs("180","1","41")
ClassMethod QueryRuleItmDs(rows, page, input) As %String
{
        
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行
		s main=+$p(input,"^",1)    ///过滤为空的情况

		s h=0
        s sub=""
		f  s sub=$o(^DHCPHLIBRULE(main,"I",sub)) q:(sub="")||(sub=0)  d
		.s ordnum=$p(^DHCPHLIBRULE(main,"I",sub),"^",1)
		.s relation=$p(^DHCPHLIBRULE(main,"I",sub),"^",2)
		.s itmdr=$p(^DHCPHLIBRULE(main,"I",sub),"^",3)
		.s condition=$p(^DHCPHLIBRULE(main,"I",sub),"^",4)  //qnp add 前提条件
		.s condition=$case(condition,"Y":"是","N":"否",:"")
		.q:'$d(^DHCLIBITMF(itmdr))
		.
	    .s rowid=main_"||"_sub
	    .s desc=$p(^DHCLIBITMF(itmdr),"^",2)	    
	    .s data=ordnum_"^"_relation_"^"_desc_"^"_rowid_"^"_condition
	    .s ordnum=ordnum+10
		.s h=h+1
		.s index=ordnum_"^"_h
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryRuleItmDs",pid,index)=data
		
		
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryRuleItmDs",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryRuleItmDs",pid,h)
	    .s ordnum=$p(data,"^",1)
	    .s relation=$p(data,"^",2)
	    .s desc=$p(data,"^",3)
	    .s rowid=$p(data,"^",4)
	    .s condition=$p(data,"^",5) //qnp add 前提条件
	    .//s condition=$case(condition,"And":"是","Or":"否",:"")
	    .
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s ordnum=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ordnum",ordnum)
	    .s relation=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("relation",relation)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
		.s condition=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("condition",condition) //qnp add 前提条件
		.
		.s tmpstr=ordnum_relation_desc_rowid_condition
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryRuleItmDs",pid)
	    
	    q ""
}

/// 查询知识库函数字典
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryLibAccMenu("180","1","36^2^hosp")
ClassMethod QueryLibAccMenu(rows, page, input) As %String
{
	
	    q:input="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    
	    s libdr=$p(input,"^",1)   
        s pointer=$p(input,"^",2) //"2"
        s type=$p(input,"^",3)  //"hosp"
       
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行
		
		
		//排序
		s h=0
		s main=0
		f  s main=$o(^DHCPHLIBRULE(main)) q:(main="")||(main=0)  d
		.q:$p(^DHCPHLIBRULE(main),"^",1)'=libdr
		.s h=h+1
		.s ordnum=$p(^DHCPHLIBRULE(main),"^",3)
		.s ordnum=ordnum+10
		.s indexm=ordnum_","_main
		.q:'$d(^DHCPHLIBRULE(main,"I"))
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",indexm)=""
	    .s sub=""
		.f  s sub=$o(^DHCPHLIBRULE(main,"I",sub)) q:sub=""  d
		..s ordnum=$p(^DHCPHLIBRULE(main,"I",sub),"^",1)
		..s ordnum=ordnum+10
		..s indexs=ordnum_","_main_"||"_sub
		..s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",indexm,indexs)=""
	      
		s h=0
        s indexm=""
		f  s indexm=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",indexm)) q:indexm=""  d
		.s main=$p(indexm,",",2)
		.q:$p(^DHCPHLIBRULE(main),"^",1)'=libdr
		.s lib=$p(^DHCPHLIBL(libdr),"^",2)
        .s labdr=$p(^DHCPHLIBRULE(main),"^",2)
        .s chk="Y"
        .i $D(^DHCPHLIBACC(0,"Pointer",libdr,type,pointer,labdr)) s chk="Y"
        .s desc=$p(^DHCPHPINL(labdr),"^",2)
        .//q:(desc["注意事项")||(desc["不良反应")||(desc["成分含量(g)")||(desc["炮制作用")||(desc["滴速")
		.s ordnum=$p(^DHCPHLIBRULE(main),"^",3)
		.s ralation=$p(^DHCPHLIBRULE(main),"^",4)
		.s parentid=""
	    .s rowid=main
		.s h=h+1
		.s id=h
		.s data=libdr_"^"_desc_"^"_ordnum_"^"_ralation_"^"_rowid_"^"_id_"^"_parentid_"^"_chk_"^"_lib
		.
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Data",h)=data
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",main)=h 
		.
		.s indexs=""
		.f  s indexs=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",indexm,indexs)) q:indexs=""  d
		..s subrowid=$p(indexs,",",2)
		..s sub=$p(subrowid,"||",2)
		..s data=^DHCPHLIBRULE(main,"I",sub)
		..s ordnum=$p(data,"^",1)
		..s ralation=$p(data,"^",2)
		..s itmdr=$p(data,"^",3)
		..s chk="N"
		..i $D(^DHCPHLIBACC(0,"Pointer",libdr,type,pointer,labdr,itmdr)) s chk="Y"
		..q:'$D(^DHCLIBITMF(itmdr))
        ..s desc=$p(^DHCLIBITMF(itmdr),"^",2)
		..s rowid=main_"||"_sub
		..s h=h+1
		..s id=h
		..s lib=$p(^DHCPHLIBL(libdr),"^",2)
		..s parentid=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Main",main)
		..s data=libdr_"^"_desc_"^"_ordnum_"^"_ralation_"^"_rowid_"^"_id_"^"_parentid_"^"_chk_"^"_lib
		..s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Data",h)=data

		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
		s h=""
		f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Data",h)) q:h=""  d
		.s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid,"Data",h)	
		.s libdr=$p(data,"^",1)
		.s desc=$p(data,"^",2)
		.s ordnum=$p(data,"^",3)
		.s ralation=$p(data,"^",4)
		.s rowid=$p(data,"^",5)
		.s id=$p(data,"^",6)
		.s parentid=$p(data,"^",7)
		.s chk=$p(data,"^",8)
		.s lib=$p(data,"^",9)
		.
		.s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .s libdr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("libdr",libdr)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s ordnum=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ordnum",ordnum)
	    .s ralation=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ralation",ralation)
	    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid)
	    .s id=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("id",id)
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("_parentId",parentid)
		.s chk=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("chk",chk)
		.s lib=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("lib",lib)
		.
		.s tmpstr=libdr_desc_ordnum_ralation_rowid_id_parentId_chk_lib
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
	    .
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibAccMenu",pid)
	    
	    q ""
}

/// w ##class(web.DHCSTPHCMADDEXTLIB).SaveAccItm("4^2^hosp@1:Y^1||1:Y^1||2:N!2:N")
ClassMethod SaveAccItm(input) As %String
{
	//s input="4^2^hosp@1:Y^1||1:Y^1||2:N!2:N"

	s str=$p(input,"@",1)
	s libdr=$p(str,"^",1)
	s pointer=$p(str,"^",2)
	s type=$p(str,"^",3)

	s del=0
	i $d(^DHCPHLIBACC(0,"Pointer",libdr,type,pointer)) d
	.&sql(delete from DHC_PHLibAcc where PHLAC_Pointer=:pointer and PHLAC_Lib_Dr=:libdr and PHLAC_Type=:type)
	.i SQLCODE'=0 s del=1
	q:del=1 -98
	
	s substr=$p(input,"@",2)
	s len=$l(substr,"!")
	
	f i=1:1:len d
	.s str=$p(substr,"!",i)
	.s strlen=$l(str,"^")
	.s labelstr=$p(str,"^",1)
	.s ruledr=$p(labelstr,":",1)  //规则主表id
	.s labeldr=$p(^DHCPHLIBRULE(ruledr),"^",2) //目录id
	.s labelval=$p(labelstr,":",2)
	.q:labelval'="Y"
	.f h=1:1:strlen d
	..q:h=1 //过掉第一个是目录的id
	..s itmstr=$p(str,"^",h)
	..s itmid=$p(itmstr,":",1)  //规则子表id
	..s itmval=$p(itmstr,":",2)
	..q:itmval'="Y"
	..;w !,labeldr_"&&&&"_itmid_"&&&&"_itmval
	..s itmrowid=$p(^DHCPHLIBRULE($p(itmid,"||",1),"I",$p(itmid,"||",2)),"^",3) //项目id
	..
	..k PLIST
	..s PLIST(2)=pointer
	..s PLIST(3)=type
	..s PLIST(4)=libdr
	..s PLIST(5)=labeldr
	..s PLIST(6)=itmrowid
	..
	..&sql(INSERT INTO DHC_PHLibAcc VALUES :PLIST())
	
	q SQLCODE
}

/// w ##class(web.DHCSTPHCMADDEXTLIB).UpdRuleOrdNum("6^5^5^6")
ClassMethod UpdRuleOrdNum(input) As %String
{
	
	s currowid=$p(input,"^",1)
	s curordernum=$p(input,"^",2)
	s lastrowid=$p(input,"^",3)
	s lastordernum=$p(input,"^",4)
	
	s curordernum=$p(^DHCPHLIBRULE(lastrowid),"^",3)
	s lastordernum=$p(^DHCPHLIBRULE(currowid),"^",3)
	
	tstart
	&sql(update DHC_PHLibRule  set PHLR_OrdNum=:curordernum where PHLR_RowId=:currowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -1
	&sql(update DHC_PHLibRule  set PHLR_OrdNum=:lastordernum where PHLR_RowId=:lastrowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	tcommit
	
	q 0
}

ClassMethod UpdRuleItmOrdNum(input) As %String
{
	
	s currowid=$p(input,"^",1)
	s curordernum=$p(input,"^",2)
	s lastrowid=$p(input,"^",3)
	s lastordernum=$p(input,"^",4)
    
    s curordernum=$p(^DHCPHLIBRULE(+lastrowid,"I",$p(lastrowid,"||",2)),"^",1)
	s lastordernum=$p(^DHCPHLIBRULE(+currowid,"I",$p(currowid,"||",2)),"^",1)
	
	
	
	tstart
	&sql(update DHC_PHLibRuleItm  set PHLRI_OrdNum=:curordernum where PHLRI_RowId=:currowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -1
	&sql(update DHC_PHLibRuleItm  set PHLRI_OrdNum=:lastordernum where PHLRI_RowId=:lastrowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	tcommit
	
	q 0
}

/// 查询知识库
/// w ##class(web.DHCSTPHCMADDEXTLIB).QueryLibComboList("180","1")
ClassMethod QueryLibComboList(rows, page) As %String
{
        
		s pid=##class(web.DHCSTPHCMADDEXTLIB).NewPid()
	
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s h=0
        s libdr=0
		f  s libdr=$o(^DHCPHLIBL(libdr)) q:(libdr="")||(libdr=0)  d
		.s desc=$p(^DHCPHLIBL(libdr),"^",2)
		.s active=$p(^DHCPHLIBL(libdr),"^",3)
		.q:active'="Y"
	    .s rowid=libdr
	    .s data=desc_"^"_rowid
	    .
		.s h=h+1
		.s index=h
		.s ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibComboList",pid,index)=data
		q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
		
		s maxrow=h
		i endpage>maxrow s endpage=maxrow
		s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibComboList",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibComboList",pid,h)
	    .s desc=$p(data,"^",1)
	    .s rowid=$p(data,"^",2)
	    .
	    .s count=count+1
	    .q:count<stpage
	    .q:count>endpage
	    .
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
		.s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
		.
		.s tmpstr=desc_rowid
		.
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.
	    .i count=stpage w startString
	    .i count<endpage w firstrow
	    .i count=endpage w lastrow
		.
	 
		k ^TMP("DHCST","DHCSTPHCMADDEXTLIB ","QueryLibComboList",pid)
	    
	    q ""
}

/// W ##class(web.DHCSTPHCMADDEXTLIB).QueryLibComboListNew()
ClassMethod QueryLibComboListNew() As %String
{
	w "["
    s libdr=0,count=0
	f  s libdr=$o(^DHCPHLIBL(libdr)) q:(libdr="")||(libdr=0)  d
	.s desc=$p(^DHCPHLIBL(libdr),"^",2)
	.s active=$p(^DHCPHLIBL(libdr),"^",3)
	.q:active'="Y"
	.q:(desc["公共")||(desc["检查项目")||(desc["检验标本")||(desc["病理项目")||(desc["病理标本")
    .s rowid=libdr
    .s data=rowid_"^"_desc
    .s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",data)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",data)
	w "]"
	q ""
}

}
