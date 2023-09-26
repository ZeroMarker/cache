Import sqluser

/// 临床药学管理002197
/// clinical pharmacy manage
Class web.DHCSTPHCMFUNLIB Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取函数库
/// w ##class(web.DHCSTPHCMFUNLIB).QueryFuntionLib("100","1","")
ClassMethod QueryFuntionLib(rows, page, input) As %String
{
		
		s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	    s init=##class(web.DHCSTPHCMFUNLIB).InitFuntionLib()
	    
	    s endpage=page*rows  //结束行
	    s stpage=((page-1)*rows)+1 //开始行
		
		/*
		s h=0
		f i=0:1:5 d
		.s parentId=""
		.i i=0 d
		..s code="0"
		..s desc="函数库"
		.i i=1 d
		..s code="1"
		..s desc="1.每日两次 2.每日三次"
		..s parentId="0" 
		.i i=2 d
		..s code="2"
		..s desc="治疗方法限制"
		..s parentId="1"
		.i i=3 d
		..s code="3"
		..s desc="1.每日服药3次,单次10mg"
		..s parentId="1" 
		.i i=4 d
		..s code="4"
		..s desc="1.遮光测试数据折行"
		..s parentId="0"
		.i i=5 d
		..s code="5"
		..s desc="1.配合饮食控制,用于2型糖尿病"
		..s parentId="4"
		.s h=h+1
	    .s data=code_"^"_desc_"^"_parentId
	    .s ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFuntionLib",pid,h)=data
	    */
	    
	    s h=0
	    s phflr=0
	    f  s phflr=$o(^DHCPHFULIB(phflr)) q:(phflr="")||(phflr=0)  d
	    .s code=$p(^DHCPHFULIB(phflr),"^",1)
	    .s desc=$p(^DHCPHFULIB(phflr),"^",2)
	    .s functions=$p(^DHCPHFULIB(phflr),"^",3)
	    .s return=$p(^DHCPHFULIB(phflr),"^",4)
	    .s remark=$p(^DHCPHFULIB(phflr),"^",5)
	    .s active=$p(^DHCPHFULIB(phflr),"^",6)
	    .s parentId=$p(^DHCPHFULIB(phflr),"^",7)
	    .s rowid=phflr
	    .s h=h+1
	    .s data=code_"^"_desc_"^"_functions_"^"_return_"^"_remark_"^"_active_"^"_parentId_"^"_rowid
	    .s ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFuntionLib",pid,h)=data
	    
	    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    s maxrow=h
    
	    s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFuntionLib",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFuntionLib",pid,h)
	    .s code=$p(data,"^",1)
	    .s desc=$p(data,"^",2)
	    .s functions=$p(data,"^",3)
	    .s returnval=$p(data,"^",4)
	    .s remark=$p(data,"^",5)
	    .s active=$p(data,"^",6)
	    .s parentId=$p(data,"^",7)
	    .s rowid=$p(data,"^",8)
	    .
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s funtions=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("funtions",functions)
	    .s returnval=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("returnval",returnval)
	    .s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark) 
	    .s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active) 
	    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid) 
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("_parentId",parentId)
		.
		.s tmpstr=code_desc_funtions_returnval_remark_active_rowid_parentId
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.s count=count+1
		.i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow
		.
		k ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFuntionLib",pid)
		q ""
}

/// 初始化函数库
ClassMethod InitFuntionLib() As %String
{

	q:$D(^DHCPHFULIB(0,"Code","funlib")) 0
	k PLIST
	s PLIST(2)="funlib"
	s PLIST(3)="函数库"
	s PLIST(7)="Y"
	
	&sql(INSERT INTO DHC_PHFunLibrary VALUES :PLIST())
	q SQLCODE
}

/// 增加函数库        wangxuejian 2016-09-12
/// w ##class(web.DHCSTPHCMFUNLIB).AddFunLib("funlib^函数库^Y^function^2^次饭www^1^1")
ClassMethod AddFunLib(input) As %String
{
 	s temp=0                                        
	s phflr=0                                        //将表里面的数据取出来拼接成字符串，然后进行比较能否插入
	f  s phflr=$o(^DHCPHFULIB(phflr)) q:(phflr="")||(phflr=0)  d
	.s data=""
	.s code=$p(^DHCPHFULIB(phflr),"^",1)
	.s desc=$p(^DHCPHFULIB(phflr),"^",2)
	.s functions=$p(^DHCPHFULIB(phflr),"^",3)
	.s return=$p(^DHCPHFULIB(phflr),"^",4)
	.s remark=$p(^DHCPHFULIB(phflr),"^",5)
    .s active1=$p(^DHCPHFULIB(phflr),"^",6)   //表里面已经存在的active
    .s active=$p(input,"^",3)        //传参进去的active
    .s patrentid=$p(input,"^",7)
	.;s parentId=$p(^DHCPHFULIB(phflr),"^",7)
	.s rowid=$p(input,"^",8)
	.s data=code_"^"_desc_"^"_active_"^" _functions_ "^"_return_"^"_remark_"^"_patrentid_"^"_rowid
    .i (input=data) d
	..s temp=1
	..i ((active'=active1)&(rowid'="")&(rowid=phflr)) s temp=0     //对active进行更新
	.q:temp=1
	
    i temp'=1 d
	.s code=$p(input,"^",1)
	.s desc=$p(input,"^",2)
	.s active=$p(input,"^",3)
	.s funtions=$p(input,"^",4)
	.s returnvalue=$p(input,"^",5)
	.s remark=$p(input,"^",6)
	.s patrentid=$p(input,"^",7)
	.i patrentid="" s patrentid=+$o(^DHCPHFULIB(0,"Code","funlib",""))
	.s rowid=$p(input,"^",8)
	.//q:$D(^DHCPHFULIB(0,"Code",code)) 0
	.i rowid'="" s ret=..UpdFunLib(input)  //更新
	.q:rowid'="" 
	.i rowid="" d
	..k PLIST
	..s PLIST(2)=code
	..s PLIST(3)=desc
	..s PLIST(4)=funtions
	..s PLIST(5)=returnvalue
	..s PLIST(6)=remark
	..s PLIST(7)=active
	..s PLIST(8)=patrentid
	..&sql(INSERT INTO DHC_PHFunLibrary VALUES :PLIST())
	q temp
}

ClassMethod UpdFunLib(input) As %String
{
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s funtions=$p(input,"^",4)
	s returnvalue=$p(input,"^",5)
	s remark=$p(input,"^",6)
	s rowid=$p(input,"^",8)
	&sql(update DHC_PHFunLibrary set PHFL_Code=:code,PHFL_Desc=:desc,PHFL_Funtions=:funtions
	,PHFL_Retrun=:returnvalue,PHFL_Remark=:remark,PHFL_ActiveFlag=:active
	 where  PHFL_RowID =:rowid  )
	 q SQLCODE
}

/// 获取函数项目
/// w ##class(web.DHCSTPHCMFUNLIB).QueryFuntionLibItm("100","1","")
ClassMethod QueryFuntionLibItm(rows, page, input) As %String
{
		
		s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	    s init=##class(web.DHCSTPHCMFUNLIB).InitFuntionLib()
	    
	    s endpage=page*rows  //结束行
	    s stpage=((page-1)*rows)+1 //开始行
		

	    
	    s h=0
	    s phflr=0
	    f  s phflr=$o(^DHCPHFULITM(phflr)) q:(phflr="")||(phflr=0)  d
	    .s code=$p(^DHCPHFULITM(phflr),"^",1)
	    .s desc=$p(^DHCPHFULITM(phflr),"^",2)
	    .s fundr=$p(^DHCPHFULITM(phflr),"^",3)
	    .s functions=$p($g(^DHCPHFULIB(fundr)),"^",3)
	    .s type=$p(^DHCPHFULITM(phflr),"^",4)                   //wangxuejian 2016-09-21
	    .s remark=$p(^DHCPHFULITM(phflr),"^",5)
	    .s active=$p(^DHCPHFULITM(phflr),"^",6)
	    .s theme=""
	    .s themedr=$p(^DHCPHFULITM(phflr),"^",7)
	    .i themedr'="" s theme=$p(^DHCPHFUTHE($p(themedr,"||",1),"I",$p(themedr,"||",2)),"^",2)
	    .s rowid=phflr
	    .s h=h+1
	    .s data=code_"^"_desc_"^"_functions_"^"_type_"^"_remark_"^"_active_"^"_rowid_"^"_fundr_"^"_theme_"^"_themedr
	    .s ^TMP("DHCST","DHCSTPHCMFUNLIB",".QueryFuntionLibItm",pid,h)=data
	    
	    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    s maxrow=h
    
	    s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB",".QueryFuntionLibItm",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMFUNLIB",".QueryFuntionLibItm",pid,h)
	    .s code=$p(data,"^",1)
	    .s desc=$p(data,"^",2)
	    .s functions=$p(data,"^",3)
	    .s type=$p(data,"^",4)
	    .s remark=$p(data,"^",5)
	    .s active=$p(data,"^",6)
	    .s rowid=$p(data,"^",7)
	    .s fundr=$p(data,"^",8)
	    .s theme=$p(data,"^",9)
	    .s themedr=$p(data,"^",10)
	    .
	    .s code=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	    .s funtions=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("funtions",functions)
	    .s type=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("type",type)
	    .s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark) 
	    .s active=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active) 
	    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid) 
	    .s fundr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("fundr",fundr)
	    .s theme=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("theme",theme) 
	    .s themedr=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("themedr",themedr) 
		.
		.
		.s tmpstr=code_desc_funtions_type_remark_active_rowid_fundr_theme_themedr
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.s count=count+1
		.i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow
		.
		k ^TMP("DHCST","DHCSTPHCMFUNLIB",".QueryFuntionLibItm",pid)
		q ""
}

// w ##class(web.DHCSTPHCMFUNLIB).AddFunLibItem("ceshi^1^Y^3^快点干活^测试2^46^1||1")

/// 增加函数项目
ClassMethod AddFunLibItem(input) As %String
{
             
	s temp=0                          //wangxuejian 2016-09-12
	 s phflr=0                       //将表里面的数据取出来拼接成字符串，然后进行比较能否插入
	    f  s phflr=$o(^DHCPHFULITM(phflr)) q:(phflr="")||(phflr=0)  d
	    .s data=""
	    .s code=$p(^DHCPHFULITM(phflr),"^",1)
	    .s desc=$p(^DHCPHFULITM(phflr),"^",2)
	    .s fundr=$p(^DHCPHFULITM(phflr),"^",3)
	    .s type=$p(^DHCPHFULITM(phflr),"^",4)
	    .s remark=$p(^DHCPHFULITM(phflr),"^",5)
	    .s active1=$p(^DHCPHFULITM(phflr),"^",6)  //表里面有的active 
	    .s active=$p(input,"^",3)          //传参进去的active
	    .s theme=""
	    .s themedr=$p(^DHCPHFULITM(phflr),"^",7)
	    .s rowid=$p(input,"^",7)
	    .s data=code_"^"_desc_"^"_active_"^" _fundr_ "^"_type_"^"_remark_"^"_rowid_"^"_themedr
	    .i input=data d
	    ..s temp=1 
	    ..i ((active'=active1)&(rowid'="")&(rowid=phflr)) s temp=0     //对active进行更新，如果有ID的话使他不能进行插入
	    . q:temp=1
	   	
	i temp'=1 d                               //项目不相同则增加新项
	.s code=$p(input,"^",1)
	.s desc=$p(input,"^",2)                        
	.s active=$p(input,"^",3)
	.s funtions=$p(input,"^",4)
	.s type=$p(input,"^",5)
	.s remark=$p(input,"^",6)
	.s rowid=$p(input,"^",7)
	.s theme=$p(input,"^",8)
	.//q:$D(^DHCPHFULITM(0,"Code",code))       
	.i rowid'="" s ret=..UpdFunLibItem(input)  //更新
	.q:rowid'=""
	.i rowid="" d
	..k PLIST
	..s PLIST(2)=code
	..s PLIST(3)=desc
	..s PLIST(4)=funtions
	..s PLIST(7)=type
	..s PLIST(5)=remark
	..s PLIST(6)=active
	..s PLIST(8)=theme
	..&sql(INSERT INTO DHC_PHFunLibItem VALUES :PLIST())
	q temp
}

ClassMethod UpdFunLibItem(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s active=$p(input,"^",3)
	s funtions=$p(input,"^",4)
	s arguments=$p(input,"^",5)
	s remark=$p(input,"^",6)
	s rowid=$p(input,"^",7)
	s theme=$p(input,"^",8)

	&sql(update DHC_PHFunLibItem set PHFLI_Code=:code,PHFLI_Desc=:desc,PHFLI_Funtions=:funtions,PHFLI_ActiveFlag=:active
	,PHFLI_Arguments=:arguments,PHFLI_Remark=:remark,PHFLI_ThemeItm_Dr=:theme
	 where  PHFLI_RowID =:rowid  )
	 
	q SQLCODE
}

/// w ##class(web.DHCSTPHCMFUNLIB).GetLabItemDs("100","1","环")
ClassMethod GetLabItemDs(rows, page, input) As %String
{
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
	q:input="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
   
    s endpage=page*rows  //结束行
    s stpage=((page-1)*rows)+1 //开始行
    
	s h=0
	//s tscode=""
	//f  s tscode=$o(^TTAB("TS",tscode)) q:tscode=""  d
	//.s desc=$p(^TTAB("TS",tscode),"\",1)
	//.q:desc'[input 
	//.s rowid=tscode
	//.s h=h+1
    //.s data=desc_"^"_rowid
    //.s ^TMP("DHCST","DHCSTPHCMFUNLIB","GetLabItemDs",pid,h)=data
    
    s arcic=""
    f  s arcic=$o(^ARC("IC",0,"OrderType","L",arcic)) q:arcic=""  d
    .s sub=""
    .f  s sub=$o(^ARCIM(0,"ARCIC_DR",arcic,sub)) q:sub=""  d
    ..s ver=""
    ..f  s ver=$o(^ARCIM(0,"ARCIC_DR",arcic,sub,ver)) q:ver=""  d
    ...s desc=$p(^ARCIM(sub,ver,1),"^",2)
    ...q:desc'[input
    ...s rowid=sub_"||"_ver
	...s h=h+1
    ...s data=desc_"^"_rowid
    ...s ^TMP("DHCST","DHCSTPHCMFUNLIB","GetLabItemDs",pid,h)=data
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h

    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB","GetLabItemDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMFUNLIB","GetLabItemDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc) 
    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid) 
	.
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("DHCST","DHCSTPHCMFUNLIB","GetLabItemDs",pid)
	q ""
}

/// 获取函数项目药品列表
/// w ##class(web.DHCSTPHCMFUNLIB).QueryFunItmDrugList("5")
ClassMethod QueryFunItmDrugList(rows, page, itmdr) As %String
{
	q:+itmdr=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s h=0
	s str=""
	s args=$p(^DHCPHFULITM(itmdr),"^",4)
	s rows=$l(args,",")
	s maxrow=rows
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	f i=1:1:rows d
	.s drgid=$p(args,",",i)
	.s desc=$p(^PHCD(+drgid,1),"^",2)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s drgid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("drgid",drgid)
	.
	.s tmpstr=desc_drgid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow

	q ""
}

/// w ##class(web.DHCSTPHCMFUNLIB).QueryFunItmLabList("500","1","6")
ClassMethod QueryFunItmLabList(rows, page, itmdr) As %String
{
	q:+itmdr=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s h=0
	s str=""
	s args=$p(^DHCPHFULITM(itmdr),"^",4)
	s rows=$l(args,",")
	s maxrow=rows
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	f i=1:1:rows d
	.s str=$p(args,",",i)
	.s arc=$p(str,":",1)
	.s min=$p(str,":",2) 
	.s max=$p(str,":",3) 
	.s desc=$p(^ARCIM($p(arc,"||",1),$p(arc,"||",2),1),"^",2)
	.s labid=arc
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s min=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("min",min)
	.s max=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("max",max)
	.s drgid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("labid",labid)
	.
	.s tmpstr=desc_min_max_drgid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow

	q ""
}

/// 增加函数主题
ClassMethod AddFunLibTheme(input) As %String
{
	s ret=2
	s cnt=$l(input,"%")
	f i=1:1:cnt d
	.s row=$p(input,"%",i)
	.s code=$p(row,"^",1)
	.s desc=$p(row,"^",2)
	.s rowid=$p(row,"^",3)
	.i rowid'="" s ret=..UpdFunLibTheme(row)  //更新
	.q:$d(^DHCPHFUTHE(0,"Code",code))
	.k PLIST
	.s PLIST(3)=code
	.s PLIST(4)=desc
	.s PLIST(6)="Y"
	.&sql(INSERT INTO DHC_PHFunTheme VALUES :PLIST())
	.s ret=SQLCODE
	q ret
}

/// 更新函数主题
ClassMethod UpdFunLibTheme(input) As %String
{
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s rowid=$p(input,"^",3)
	&sql(update DHC_PHFunTheme set PHTHE_Code=:code,PHTHE_Desc=:desc where PHTHE_Rowid=:rowid  )
	q SQLCODE
}

/// 停用函数主题   wangxuejian 2016-09-22
ClassMethod StopFunLibTheme(input) As %String
{
	s rowid=$p(input,"^",1)
	s activeFlag=$p(input,"^",2)
	&sql(update DHC_PHFunTheme set PHTHE_ActiveFlag=:activeFlag where PHTHE_Rowid=:rowid  )
	q SQLCODE
}

/// 增加主题项目
ClassMethod AddItmTheme(input) As %String
{

	s ret=0
	s main=$p(input,"@",1)
	s substr=$p(input,"@",2)
	s cnt=$l(substr,"%")
	f i=1:1:cnt d
	.s tmp=0
	.s row=$p(substr,"%",i)
	.s code=$p(row,"^",1)
	.s desc=$p(row,"^",2)
	.s rowid=$p(row,"^",3)
	.i rowid'="" s ret=..UpdThemeItm(row)  //更新
	.q:rowid'=""
	.s ChildSub=""
	.f  s ChildSub=$o(^DHCPHFUTHE(main,"I",ChildSub)) q:ChildSub=""  d
	..s phcode=$p(^DHCPHFUTHE(main,"I",ChildSub),"^",1)
    ..i (phcode=code)&&(rowid'=(main_"||"_ChildSub)) d
    ...s tmp=1
    .i tmp=0 d
	..k PLIST
	..s PLIST(0)=main
	..s PLIST(5)=+$o(^DHCPHFUTHE(main,"I",""),-1)+1
	..s PLIST(6)=code
	..s PLIST(7)=desc
	..&sql(INSERT INTO DHC_PHFunTheItem VALUES :PLIST())
	q tmp
}

/// 更新函数主题
ClassMethod UpdThemeItm(input) As %String
{
	
	s code=$p(input,"^",1)
	s desc=$p(input,"^",2)
	s rowid=$p(input,"^",3)
	&sql(update DHC_PHFunTheItem set PHTHEI_Code=:code,PHTHEI_Desc=:desc where PHTHEI_Rowid=:rowid  )
	q SQLCODE
}

/// 查询函数主题项目
/// w ##class(web.DHCSTPHCMFUNLIB).QueryThemeItmDs("150","1")
ClassMethod QueryThemeItmDs(rows, page) As %String
{
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phther=0
    f  s phther=$o(^DHCPHFUTHE(phther)) q:(phther="")||(phther=0)  d
    .s code=$p(^DHCPHFUTHE(phther),"^",2)
    .s desc=$p(^DHCPHFUTHE(phther),"^",3)
    .s active=$p(^DHCPHFUTHE(phther),"^",5)
	.q:active="N"
    .s sub=""
    .f  s sub=$o(^DHCPHFUTHE(phther,"I",sub)) q:(sub="")||(sub=0)  d
    ..s h=h+1
    ..s itmdesc=$p(^DHCPHFUTHE(phther,"I",sub),"^",2)
    ..s rowid=phther_"||"_sub
    ..s data=desc_"^"_itmdesc_"^"_rowid
    ..s ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItmDs",pid,h)=data
    .
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItmDs",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItmDs",pid,h)
	.s desc=$p(data,"^",1)
	.s itmdesc=$p(data,"^",2)
	.s rowid=$p(data,"^",3) 
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s itmdesc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("itmdesc",itmdesc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_itmdesc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItmDs",pid)
	q ""
}

ClassMethod QueryFunLibTheme(rows, page) As %String
{
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s phther=0
    f  s phther=$o(^DHCPHFUTHE(phther)) q:(phther="")||(phther=0)  d
    .s h=h+1
    .s code=$p(^DHCPHFUTHE(phther),"^",2)
    .s desc=$p(^DHCPHFUTHE(phther),"^",3)
    .s active=$p(^DHCPHFUTHE(phther),"^",5)
    .s rowid=phther
    .s data=code_"^"_desc_"^"_active_"^"_rowid
    .s ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFunLibTheme",pid,h)=data
    .
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFunLibTheme",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFunLibTheme",pid,h)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s active=$p(data,"^",3)
	.s rowid=$p(data,"^",4) 
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s code=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s active=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("active",active)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_active_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryFunLibTheme",pid)
	q ""
}

/// 查询函数主题项目
/// w ##class(web.DHCSTPHCMFUNLIB).QueryThemeItm("150","1","4")
ClassMethod QueryThemeItm(rows, page, main) As %String
{
	
	q:main="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s sub=""
    f  s sub=$o(^DHCPHFUTHE(main,"I",sub)) q:(sub="")||(sub=0)  d
    .s h=h+1
    .s code=$p(^DHCPHFUTHE(main,"I",sub),"^",1)
    .s desc=$p(^DHCPHFUTHE(main,"I",sub),"^",2)
    .s rowid=main_"||"_sub
    .s data=code_"^"_desc_"^"_rowid
    .s ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItm",pid,h)=data
    .
    
    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s maxrow=h
	i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItm",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItm",pid,h)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3) 
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
	.s code=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("code",code)
	.s desc=##Class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##Class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=code_desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMFUNLIB","QueryThemeItm",pid)

	q ""
}

/// Creator:bianshuai
/// CreateDate:2014-09-19
/// Descript:删除函数主题项目
/// w ##Class(web.DHCSTPHCMFUNLIB).DelFunLibTheItm("1||2")
ClassMethod DelFunLibTheItm(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_PHFunTheItem Where PHTHEI_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询检验项目
ClassMethod jsQueryLabItemDs(rows, page, Intsdesc) As %String
{
	N (rows, page, Intsdesc)
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
    S tscode=""
    F  S tscode=$o(^TTAB("TC",tscode)) Q:tscode=""  D
    .S tsDesc=$p(^TTAB("TC",tscode),"\",1)  //描述
    .Q:tsDesc'[Intsdesc
	.S ListData=tscode_"^"_tsDesc
	.
	.S Num=Num+1
	.S index=tscode
	.S ^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryLabItemDs",pid,index)=ListData
	.

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="tscode^tsDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryLabItemDs",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryLabItemDs",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:函数库检验列表
ClassMethod jsQueryFunItmLabList(rows, page, itmdr) As %String
{
	N (rows, page, itmdr)
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	S Num=0
	s args=$p(^DHCPHFULITM(itmdr),"^",4)
	s Len=$L(args,",")
	s count=0
	f i=1:1:Len d
	.s str=$p(args,",",i)
	.s tscode=$p(str,":",1) //指标代码
	.s min=$p(str,":",2)    //下线
	.s max=$p(str,":",3)    //上线
	.s tsDesc=$p($g(^TTAB("TC",tscode)),"\",1)  //描述
	.S ListData=tscode_"^"_tsDesc_"^"_min_"^"_max
	.
	.S Num=Num+1
	.S index=tscode
	.S ^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryFunItmLabList",pid,index)=ListData
	.

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="labid^desc^min^max"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryFunItmLabList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryFunItmLabList",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:  主题项目参数表
ClassMethod saveFunLibArt(ListData As %String) As %String
{
	n (ListData)
	s len=$L(ListData,"&")
	f i=1:1:len d
	.s TmpStr=$p(ListData,"&",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdFunLibArt(TmpStr)
	.e  d
	..s ret=..InsFunLibArt(TmpStr)
	q 0
}

/// Descript:  增加主题项目参数表
ClassMethod InsFunLibArt(ListData As %String) As %String
{
	n (ListData)
	s itmParref=$p(ListData,"^",2)  /// 主表ID
	s ItmCode=$p(ListData,"^",3)    /// 项目代码
	s itmMinVal=$p(ListData,"^",4)  /// 最小值
	s itmMaxVal=$p(ListData,"^",5)  /// 最大值
	s childSub=$o(^DHCPHFULITM(itmParref,"I",""),-1)+1
 	&SQL(insert into DHC_PHFunLibItmArt(PH_PHFLI_Parref,PH_ChildSub,PH_MonItmCode,PH_MinVal,PH_MaxVal)
 		values(:itmParref,:childSub,:ItmCode,:itmMinVal,:itmMaxVal))
 	Q SQLCODE
}

/// Descript:  更新主题项目参数表
ClassMethod UpdFunLibArt(ListData As %String) As %String
{
	n (ListData)
	s itmID=$p(ListData,"^",1)      /// ID
	s ItmCode=$p(ListData,"^",3)    /// 项目代码
	s itmMinVal=$p(ListData,"^",4)  /// 最小值
	s itmMaxVal=$p(ListData,"^",5)  /// 最大值
	&SQL(update DHC_PHFunLibItmArt set PH_MonItmCode=:ItmCode,PH_MinVal=:itmMinVal,PH_MaxVal=:itmMaxVal WHERE PH_RowId=:itmID)
 	Q SQLCODE
}

/// Descript:删除主题项目参数表
ClassMethod delFunLibArt(itmID As %String) As %String
{
	n (itmID)
	&SQL(delete From DHC_PHFunLibItmArt WHERE PH_RowId=:itmID)
	Q SQLCODE
}

/// Descript:  主题项目参数表
/// w ##class(web.DHCSTPHCMFUNLIB).QueryFunLibArt("50","1","4")
ClassMethod QueryFunLibArt(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
    s pid=..NewPid()
    d ..killTmpGlobal(pid)         //k掉临时global
    s itmID=$p(params,"^",1)
    s itmcode=$p(params,"^",2)
    s itmdesc=$p(params,"^",3)
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCPHFULITM(itmID,"I",CH)) q:CH=""  d
	.s arcitemId=$p(^DHCPHFULITM(itmID,"I",CH),"^",1)     //医嘱项ID
	.s itmmastid=$p(arcitemId,"||",1)
	.s itmmastver=$p(arcitemId,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码、
	.q:(itmcode'="")&(arcitmcode'=itmcode)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	.q:(itmdesc'="")&(arcitmdesc'[itmdesc)
	.s ListData=itmID_"||"_CH_"^"_arcitemId_"^"_arcitmcode_"^"_arcitmdesc
	.s h=h+1
	.s ^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibArt",pid,h)=ListData
	
	//i h="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:h="0" ""

	S ListTitle="itmID^itmmastid^itmCode^itmDesc"
	S maxrow=h
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibArt",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibArt",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:  主题项目参数检验指标
/// w ##Class(web.DHCSTPHCMFUNLIB).QueryFunLibLabArt("30","1","11^0001^")
ClassMethod QueryFunLibLabArt(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s ^PHATMP("MYQ", $this, "QueryFunLibLabArt") = $lb(rows,page,params)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
    s pid=..NewPid()
    d ..killTmpGlobal(pid)         //k掉临时global
    s itmID=$p(params,"^",1)
    s Itmcode=$p(params,"^",2)   //wangxuejian 2016-10-12  
    s Itmdesc=$p(params,"^",3)
	s h=0,count=0

	s CH=""						
	f  s CH=$o(^DHCPHFULITM(itmID,"I",CH)) q:CH=""  d
	.s itmCode=$p(^DHCPHFULITM(itmID,"I",CH),"^",1)     //检验代码	
	.q:(Itmcode'="")&(Itmcode'=itmCode)
	.//s itmCode=" "_itmCode  //存检验代码的表中前面有一个空格
	.s itmMinVal=$p(^DHCPHFULITM(itmID,"I",CH),"^",2)  //最小值
	.s itmMinVal=##class(web.DHCST.Common.UtilCommon).AddZero(itmMinVal)
	.s itmMaxVal=$p(^DHCPHFULITM(itmID,"I",CH),"^",3)  //最大值
	.s itmMaxVal=##class(web.DHCST.Common.UtilCommon).AddZero(itmMaxVal)
	.s itmCode = ##Class(LIS.Util.Common).IndexData(itmCode)
	.s ID=+$o(^dbo.BTTestCodeI("IndexCode",1,itmCode,"")) 	
	.s itmDesc=$lg($g(^dbo.BTTestCodeD(ID)),3)	//描述		//qunianpeng 2016/11/4
	.q:(Itmdesc'="")&(Itmdesc'=itmDesc)
	.s ListData=itmID_"||"_CH_"^"_itmCode_"^"_itmDesc_"^"_itmMinVal_"^"_itmMaxVal
	.s h=h+1
	.s ^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibLabArt",pid,h)=ListData


	i h="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:h="0" ""

	S ListTitle="itmID^itmCode^itmDesc^itmMinVal^itmMaxVal"
	S maxrow=h
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibLabArt",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibLabArt",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMFUNLIB","jsQueryLabItemDs",pid)
	k ^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibArt",pid)
	k ^TMP("DHCST","web.DHCSTPHCMFUNLIB","QueryFunLibLabArt",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("STPHCMFUNLIB"))
}

}
