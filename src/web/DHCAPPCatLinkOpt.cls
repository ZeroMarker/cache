Class web.DHCAPPCatLinkOpt Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增医嘱子类与其它项目关联模块
/// Table：        DHC_AppCatLinkOpt
/// Input：	       
/// Return：       保存成功 0，其他 失败
/// 
ClassMethod saveOrUpdateSub(str)
{
  		 s ret=0
  		 s ret=..isExistSameOpt(str)
  		 q:ret'=0 ret
  		 s ID=$p(str,"^",1) 
  		 s ALOOptParRef=$p(str,"^",2)
		 s ALOOptDr=$p(str,"^",3)
		 
		 i ALOOptDr="0" q 1
		 	
		 i +ID=0 d
		 .s obj=##class(User.DHCAppCatLinkOpt).%New()
		 .s obj.ALOOptParRef=##class(User.DHCAppArcCat).%OpenId(ALOOptParRef)
 		 .s ch=$o(^DHCAPCATO(ALOOptParRef,"O",""),-1)+1
 		 .s obj.ALOChildSub=ch
		 e  d
		 .s obj=##class(User.DHCAppCatLinkOpt).%OpenId(ID)
		 .d obj.%Reload()
		 //w "obj.ALOOptDr.AODesc:"_obj.ALOOptDr.AODesc,!
		 s obj.ALOOptDr=##class(User.DHCAppOtherOpt).%OpenId(ALOOptDr)
		 //w "obj.ALOOptDr.AODesc:"_obj.ALOOptDr.AODesc,!
		 s sc=obj.%Save()
		 i $$$ISERR(sc) q -2
		 q ret
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增其它项目内容
/// Table：        DHC_AppCatLinkOpt
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCAPPCatLinkOpt).save("^1^4^123132")
ClassMethod save(params)
{
  		 

  	 	
		s $Zt="Err"
	  	TStart
	  	s ret=0
	  	s len=$l(params,"$$")
	  	for i=1:1:len d
	  	.q:ret<0
	  	.s str=$p(params,"$$",i)
	  	.s ret=..saveOrUpdateSub(str)
		i ret<0 TRollback
		TCOMMIT
		q ret
Err
	TRollback
	q -1
}

/// Creator：      sufan
/// CreatDate：    2017-02-24
/// Description:： 判断是否重复
/// Table：        DHC_AppCatLinkOpt
/// Return：       0:不存在  其他：存在
/// w ##class(web.DHCAPPCatLinkOpt).isExistSameOpt()
ClassMethod isExistSameOpt(params)
{
	s ret=0
	s CatrRowID=$p(params,"^",2)
	s ALOOptDr=$p(params,"^",3)
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPCATO(CatrRowID,"O",ChildSub))  q:(ChildSub="")||(ret'=0)  d
	.s OptDr=$p(^DHCAPCATO(CatrRowID,"O",ChildSub),"^",1)
	.q:ALOOptDr'=OptDr
	.s ret=2
	q ret
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 分页显示其它项目内容
/// Table：        DHC_AppOtherOpt
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCAPPCatLinkOpt).list()
ClassMethod list(page = 1, rows = 10, ALOOptParRef = "")
{
	
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0

	    s CatOptType=""	 //lvpeng 2016-7-14 
	    w "{""rows"":["
		s cat=""
		f  s cat=$o(^DHCAPCATO(cat)) q:cat=""  d
		.q:(+ALOOptParRef'=0)&(ALOOptParRef'=cat)
		.s catitm=""
		.f  s catitm=$o(^DHCAPCATO(cat,"O",catitm)) q:catitm=""  d
		..s opt=$p(^DHCAPCATO(cat,"O",catitm),"^",1)
		..I $d(CatOptType(opt))	 D 
		...
		..E   D	
		...S CatOptType(opt)=opt  //lvpeng 2016-7-14 去除重复项	
		...s count=count+1
		...q:count<start
		...q:count>end
		...i count'=start d  w ","
		...s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    ...s jsonObj.ContainNullValue=1
	    ...d jsonObj.Put("OptDesc",$p(^DHCAPOTHO(+opt),"^",2))
	    ...d jsonObj.Put("ALOOptDr",opt)
	    ...d jsonObj.Put("ALOOptParRef",cat)
	    ...d jsonObj.Put("ID",cat_"||"_catitm)
		...w jsonObj.Json()
		w "],""total"":"_count_"}"
		q ""
}

ClassMethod remove(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCAppCatLinkOpt).%DeleteId(Id)
	  q 0
}

}
