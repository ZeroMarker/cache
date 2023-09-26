Import SQLUSER

Class web.DHCAPPOtherOpt Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增其它项目字典
/// Table：        DHC_AppOtherOpt
/// Input：	      AOCode：代码
///               AODesc：描述
///               AOType：内容类型
///               AORequired：是否必填
///               ID：rowid
///               AOHospDr:医院id 
/// Return：       保存成功 0，其他 失败
ClassMethod saveOrUpdate(str, HospID)
{
  		 
  		 s AOCode=$p(str,"^",1)
		 s AODesc=$p(str,"^",2)
		 s AOType=$p(str,"^",3)
		 s AORequired=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 s rtn=..checkSame(ID,AOCode,HospID)
		 i rtn=1 q -10  ;代码重复
		 i +ID=0 d
		 .s obj=##class(User.DHCAppOtherOpt).%New()
		 .
		 e  d
		 .s obj=##class(User.DHCAppOtherOpt).%OpenId(ID)
		 .d obj.%Reload()
		 s obj.AOCode=AOCode
		 s obj.AODesc=AODesc
		 s obj.AOType=AOType
		 s obj.AORequired=AORequired
	 	 s obj.AOHospDr=##class(User.CTHospital).%OpenId(HospID)
		 s sc=obj.%Save()
		 i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod checkSame(ID, AOCode, HospID)
{
	s rtn=0
	s opId=""
	f  s opId=$o(^DHCAPOTHO(opId)) q:opId=""  d
	.s code=$p(^DHCAPOTHO(opId),"^",1)
	.s desc=$p(^DHCAPOTHO(opId),"^",2)
	.s HospDr=$p(^DHCAPOTHO(opId),"^",5)
	.q:ID=opId
	.q:(HospID'="")&(HospID'=HospDr) 
	.if code=AOCode s rtn=1
	q rtn
}

/// w ##class(web.DHCAPPOtherOpt).save("01^22^Input^Y^0","2")
ClassMethod save(params, HospID)
{
  
	;s $Zt="Err"
	s ^tempqujian("save")=params_","_HospID
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len {
	  	q:ret<0
	  	s str=$p(params,"$$",i)
	  	s ret=..saveOrUpdate(str,HospID)
  	}
	i (ret<0) {
		TRollback
	}else{ TCOMMIT}
	q ret
Err
	TRollback
	q -1
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 分页显示其它项目字典
/// Table：        DHC_AppOtherOpt
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCAPPOtherOpt).list()
ClassMethod list(page = 1, rows = 10, AOCode, AODesc, q, HospId As %String = "")
{
		if (HospId="")&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
		s ^tempqujina("list")=page_","_rows_","_AOCode_","_AODesc_","_q_","_HospId
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s opId=""
		f  s opId=$o(^DHCAPOTHO(opId)) q:opId=""  d
		.s code=$p(^DHCAPOTHO(opId),"^",1)
		.s desc=$p(^DHCAPOTHO(opId),"^",2)
		.s HospDr=$p(^DHCAPOTHO(opId),"^",5)
		.q:(HospId'="")&(HospId'=HospDr)     //sufan  2017-02-13 通过医院过滤信息
		.q:(AOCode'="")&(code'[AOCode)
		.q:(AODesc'="")&(desc'[AODesc)		 /// sufan  2017-02-23  实现模糊查询
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.w jsonObj.FromObject(##class(User.DHCAppOtherOpt).%OpenId(opId)).Json()
		.
		w "],""total"":"_count_"}"
		q ""
}

/// Creator:       huaxiaoying
/// CreatDate：    2016-05-24
/// Description:： 分页显示未维护其它项目字典
/// Table：        DHC_AppOtherOpt
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCAPPOtherOpt).list1(,,"","","","")
ClassMethod list1(page = 1, rows = 10, AOCode, AODesc, q, CatRowId)
{
	   s start=(page-1)*rows+1
	   s end=page*rows
	   s count=0
	   s jsonObj=##class(web.DHCAPPJsonObject).%New()
	   w "{""rows"":["
	   s opId=""
	   for{
		 s opId=$o(^DHCAPOTHO(opId))
		 q:opId="" 
		  
		 set isIn=0
		 s ACOchild=""
         for{ 
            s ACOchild=$o(^DHCAPCATO(CatRowId,"O",ACOchild))
            q:ACOchild="" 
            s OptDr=$p(^DHCAPCATO(CatRowId,"O",ACOchild),"^",1)
            continue:OptDr'=opId 
			set isIn=1
         }
        
         if (isIn=0)
		 {
		  s code=$p(^DHCAPOTHO(opId),"^",1)
		  s desc=$p(^DHCAPOTHO(opId),"^",2)
		  q:(AOCode'="")&(AOCode'=code)
		  q:(AODesc'="")&(AODesc'=desc)
		  q:(q'="")&(desc'[q)
		  s count=count+1
		  q:count<start
		  q:count>end
	      w $case(count,start:"",:",") 
		  w jsonObj.FromObject(##class(User.DHCAppOtherOpt).%OpenId(opId)).Json()
		 }
	   }
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 查找一条其它项目字典,已json形式返回
/// Table：        DHC_AppOtherOpt
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCAPPOtherOpt).find(12)
ClassMethod find(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCAppOtherOpt).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 删除其它项目字典
/// Table：        DHC_AppOtherOpt
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod remove(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCAppOtherOpt).%DeleteId(Id)
	  q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增其它项目内容
/// Table：        DHC_AppOtherOptItm
/// Input：	      AOICode：代码
///               AOIDesc：描述
///               AOIOptParRef：其他项目字典Id
///               ID：rowid
///               AOHospDr:医院id 
/// Return：       保存成功 0，其他 失败
ClassMethod saveOrUpdateSub(str)
{
  		s AOIOptParRef=$p(str,"^",1)
  		s ID=$p(str,"^",2) 
  		s ATPType=$p(^DHCAPOTHO(AOIOptParRef),"^",3)
  		s AOIArcim=$p(str,"^",5)
  		s AOICode=$p(str,"^",3)
  		s checksame=..Checksubsame(AOIOptParRef,ID,AOICode,ATPType,AOIArcim)
  		if checksame=1 q -10
  		if (+ID=0) {
			 s obj=##class(User.DHCAppOtherOptItm).%New()
			 s obj.AOIOptParRef=##class(User.DHCAppOtherOpt).%OpenId(AOIOptParRef)
	 		 s ch=$o(^DHCAPOTHO(AOIOptParRef,"I",""),-1)+1
	 		 s obj.AOIChildSub=ch	
			}else{
			 s obj=##class(User.DHCAppOtherOptItm).%OpenId(ID)
			 d obj.%Reload()	 
			}
  		if (ATPType="Order"){
	  		s AOIArcim=$p(str,"^",5)
	  		s AOiArcimNum=$p(str,"^",4)
	  		s obj.AOIArcimNumber=AOiArcimNum
	  		Do obj.AOIArcimSetObjectId(AOIArcim)
	  		s obj.AOICode=""
			s obj.AOIDesc=""
			s sc=obj.%Save()
			i $$$ISERR(sc) q -2
			q 0 
	  	}else{
	  		 s AOICode=$p(str,"^",3)
		 	 s AOIDesc=$p(str,"^",4) 
			 s obj.AOICode=AOICode
			 s obj.AOIDesc=AOIDesc

			 s sc=obj.%Save()
			 i $$$ISERR(sc) q -2
			 q 0	
	  		} 
  		 /*s AOICode=$p(str,"^",1)
		 s AOIDesc=$p(str,"^",2)
		 s AOIOptParRef=$p(str,"^",3)
		 s ID=$p(str,"^",4) 	
		 i +ID=0 d
		 .s obj=##class(User.DHCAppOtherOptItm).%New()
		 .s obj.AOIOptParRef=##class(User.DHCAppOtherOpt).%OpenId(AOIOptParRef)
 		 .s ch=$o(^DHCAPOTHO(AOIOptParRef,"I",""),-1)+1
 		 .s obj.AOIChildSub=ch
		 e  d
		 .s obj=##class(User.DHCAppOtherOptItm).%OpenId(ID)
		 .d obj.%Reload()
		 s obj.AOICode=AOICode
		 s obj.AOIDesc=AOIDesc

		 s sc=obj.%Save()
		 i $$$ISERR(sc) q -2
		 q 0*/
}

ClassMethod Checksubsame(AOIOptParRef, ID, AOICode, ATPType, AOIArcim)
{
	s subId=""
	s rtn=0
	f  {
		s subId=$o(^DHCAPOTHO(AOIOptParRef,"I",subId)) 
		q:subId=""  
		s code=$p(^DHCAPOTHO(AOIOptParRef,"I",subId),"^",1)
		s desc=$p(^DHCAPOTHO(AOIOptParRef,"I",subId),"^",2)
		continue:((AOIOptParRef_"||"_subId)=ID)
		if (ATPType="Order"){
			s ArcIM=$p(^DHCAPOTHO(AOIOptParRef,"I",subId),"^",3)
			if (AOIArcim=ArcIM) s rtn=1
		}else{
			if (AOICode=code) s rtn=1
		}
	}
	q rtn
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增其它项目内容
/// Table：        DHC_AppOtherOptItm
/// Input：	      AOICode：代码
///               AOIDesc：描述
///               AOIOptParRef：其他项目字典Id
///               ID：rowid
///               AOHospDr:医院id 
/// Return：       保存成功 0，其他 失败
ClassMethod saveSub(params)
{
  		 
  		s ^tempqujian("saveSub")= params
		;s $Zt="Err"
	  	TStart
	  	s ret=0
	  	s len=$l(params,"$$")
	  	for i=1:1:len d
	  	.q:ret<0
	  	.s str=$p(params,"$$",i)
	  	.s ret=..saveOrUpdateSub(str)
		i ret<0 {
			TRollback
		}else{
			TCOMMIT
		}
		q ret
Err
	TRollback
	q -1
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 分页显示其它项目内容
/// Table：        DHC_AppOtherOpt
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCAPPOtherOpt).listSub(listSub)
ClassMethod listSub(page = 1, rows = 10, AOIOptParRef, AOICode, AOIDesc)
{
	
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    s jsonObj.ContainNullValue=1
	    w "{""rows"":["
		s opId=""
		f  s opId=$o(^DHCAPOTHO(opId)) q:opId=""  d
		.//q:(+AOIOptParRef'=0)&(AOIOptParRef'=opId)
		.q:(AOIOptParRef'=opId)
		.s subId=""
		.f  s subId=$o(^DHCAPOTHO(opId,"I",subId)) q:subId=""  d
		..
		..s code=$p(^DHCAPOTHO(opId,"I",subId),"^",1)
		..s desc=$p(^DHCAPOTHO(opId,"I",subId),"^",2)
		..q:(AOICode'="")&(code'[AOICode)
		..q:(AOIDesc'="")&(desc'[AOIDesc)
		..s count=count+1
		..q:count<start
		..q:count>end
	    ..i count'=start d  w ","
	    ..s obj={}
	    ..s obj.AOICode=code
	    ..s obj.AOIDesc=desc
	    ..s obj.AOIOptParRef=AOIOptParRef
	    ..s obj.ID=opId_"||"_subId
	    ..s ArcIM=$p(^DHCAPOTHO(opId,"I",subId),"^",3)
	    ..s Number=$p(^DHCAPOTHO(opId,"I",subId),"^",4)
	    ..s obj.ARCIMDesc=""
	    ..s obj.ARCIMRowid=ArcIM
	    ..s obj.Number=Number
	    ..if ArcIM'="" d
	    ...s obj.ARCIMDesc=$P(^ARCIM(+ArcIM,$P(ArcIM,"||",2),1),"^",2)
	    ..;b ;0934
	    ..w obj.%ToJSON()
		..;w jsonObj.FromObject(##class(User.DHCAppOtherOptItm).%OpenId(opId_"||"_subId)).Json()
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 删除其它项目内容
/// Table：        DHC_AppOtherOpt
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod removeSub(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCAppOtherOptItm).%DeleteId(Id)
	  q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 查找一条其它项目内容,已json形式返回
/// Table：        DHC_AppOtherOpt
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCAPPOtherOpt).find(12)
ClassMethod findSub(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCAppOtherOptItm).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 下拉列表显示是否必填
/// Return
/// d ##class(web.DHCAPPOtherOpt).listIsRequired()
ClassMethod listIsRequired()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 下拉列表显其他项目字典
/// Return
/// d ##class(web.DHCAPPOtherOpt).listOtherOpt()
ClassMethod listOtherOpt()
{
  	  s count=0
	  w "["
		s opId=""
		f  s opId=$o(^DHCAPOTHO(opId)) q:opId=""  d
		.s desc=$p(^DHCAPOTHO(opId),"^",2)
	    .w $case(count,0:"",:",")
	    .w ##class(web.DHCAPPJsonObject).%New().Put("value",opId).Put("text",desc).Json() 
		.s count=count+1
	  w "]"	
	  q ""
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 下拉列表显示是否必填
/// Return
/// d ##class(web.DHCAPPOtherOpt).listType()
ClassMethod listType()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Input").Put("text","Input"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Check").Put("text","Check"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Combox").Put("text","Combox"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Order").Put("text","Order"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator     ： sufan
/// CreatDate   ： 2017-02-22
/// Description ： 保存检查分类和打印模板关联表
/// Input       ： 打印模板表ID^检查分类ID^模板描述
/// Return      ： 0:保存成功，其他:保存失败
/// Table       ： DHC_AppPrtTemp
/// Others      ： w ##class(web.DHCAPPOtherOpt).SavePrint("^1^ff")
ClassMethod SavePrint(params As %String) As %String
{
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.;s ret=..isExistSamePrt(tmpstr)		/// 调用判断的函数
	.;q:ret'=0
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdPrintTemp(tmpstr)
	.e  d
	..s ret=..SavePrintTemp(tmpstr)
	q ret
}

/// Descript    : 保存检查分类和打印模板关联
/// Input       ： 打印模板表ID^检查分类ID^模板描述
/// Return      ： 0:保存成功，其他:保存失败
/// Table       ： DHC_AppPrtTemp
/// Others      ： w ##class(web.DHCAPPOtherOpt).SavePrintTemp()
ClassMethod SavePrintTemp(params As %String) As %String
{
	s CatDr=$p(params,"^",2)		/// 分类ID
	s APTTemp=$p(params,"^",3)		/// 模板描述
	s ATPType=$p(params,"^",4)	
	s ATPType=$case(ATPType,"住院":"I","门诊":"O","急诊":"E","体检":"H","新生儿":"N",:ATPType)
	s APTSex=$p(params,"^",5)
	s APTSex=$case(APTSex,"男":"1","女":"O","未知性别":"3","未说明性别":"4",:APTSex)
	s APTInfomation=$p(params,"^",6)
	&sql(insert into DHC_AppPrtTemp (APT_Cat_Dr,APT_TempText,APT_Type,APT_Sex,APT_Infomation) values(:CatDr,:APTTemp,:ATPType,:APTSex,:APTInfomation))
	q SQLCODE
}

/// Descript    :  更新检查分类和打印模板关联
/// Input       ： 打印模板表ID^检查分类ID^模板描述
/// Return      ： 0:保存成功，其他:保存失败
/// Table       ： DHC_AppPrtTemp
/// Others      ： w ##class(web.DHCAPPOtherOpt).UpdPrintTemp()
ClassMethod UpdPrintTemp(params As %String) As %String
{
	s APTRowID=$p(params,"^",1)		/// 模板表ID
	s CatDr=$p(params,"^",2)		/// 分类ID
	s APTTemp=$p(params,"^",3)		/// 模板描述
	s ATPType=$p(params,"^",4)	
	s ATPType=$case(ATPType,"住院":"I","门诊":"O","急诊":"E","体检":"H","新生儿":"N",:ATPType)
	s APTSex=$p(params,"^",5)
	s APTSex=$case(APTSex,"男":"1","女":"O","未知性别":"3","未说明性别":"4",:APTSex)
	s APTInfomation=$p(params,"^",6)
	&sql(update DHC_AppPrtTemp set APT_Cat_Dr=:CatDr,APT_TempText=:APTTemp,APT_Type=:ATPType,
	 APT_Sex=:APTSex,APT_Infomation=:APTInfomation where APT_RowID=:APTRowID )
	q SQLCODE
}

/// Descript    :  判断相同的分类是否关联相同的模板
/// Input       ： 打印模板表ID^检查分类ID^模板描述
/// Return      ： 0:不存在，其他:存在
/// Table       ： DHC_AppPrtTemp
/// Others      ： w ##class(web.DHCAPPOtherOpt).SavePrintTemp()
ClassMethod isExistSamePrt(params As %String) As %String
{
	s ret=0
	s CatDr=$p(params,"^",2)		/// 分类ID
	s APTTemp=$p(params,"^",3)		/// 模板描述
	s APTRowID=""
	f  s APTRowID=$o(^DHCAPPPRT(0,"Arc",CatDr,APTRowID))  q:(APTRowID="")||(ret'=0)  d
	.s TempDesc=$p(^DHCAPPPRT(APTRowID),"^",2)
	.q:APTTemp'=TempDesc
	.s ret="-12"
	q ret
}

/// Descript    :  删除模板关联表
/// Input       ： 模板关联表ID
/// Table       ： DHC_AppPrtTemp
/// Others      ： w ##class(web.DHCAPPOtherOpt).DeletePrtTemp()
ClassMethod DeletePrtTemp(APTRowID)
{
	&sql(delete from DHC_AppPrtTemp where APT_RowID=:APTRowID)
	q SQLCODE
}

/// Creator		 ： sufan
/// CreatDate	 ： 2017-02-22
/// Description	 ： 查询打印模板数据
/// Input        ： rows，page，检查分类ID
/// Table        ： DHC_AppPrtTemp
/// Others       ： w ##class(web.DHCAPPOtherOpt).QueryPrintTemp(10,1,1)
ClassMethod QueryPrintTemp(rows, page, ItmID) As %String
{
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()		
	d ##class(web.DHCAPPArcCat).killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s APTRowId=""
	f  s APTRowId=$o(^DHCAPPPRT(0,"Arc",ItmID,APTRowId)) q:APTRowId=""  d  /// 去模板关联表ID
	.s APTTemp=$p(^DHCAPPPRT(APTRowId),"^",2)		/// 模板描述	
	.s CatDr=$p(^DHCAPPPRT(APTRowId),"^",1)			/// 分类ID
	.s ATPType=$p(^DHCAPPPRT(APTRowId),"^",3)
	.s ATPType=$case(ATPType,"I":"住院","O":"门诊","E":"急诊","H":"体检","N":"新生儿",:"")
	.s APTSex=$p(^DHCAPPPRT(APTRowId),"^",4)
	.if APTSex'="" s APTSex=$P(^CT("SEX",APTSex),"^",2)
	.s APTInfomation=$p(^DHCAPPPRT(APTRowId),"^",5)
	.s h=h+1
	.s tempstr=APTRowId_"^"_APTTemp_"^"_CatDr_"^"_ATPType_"^"_APTSex_"^"_APTInfomation
	.s ^TMP("DHCST","web.DHCAPPOtherOpt","QueryPrintTemp",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="APTRowId^APTTemp^CatDr^ATPType^APTSex^APTInfomation"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPOtherOpt","QueryPrintTemp",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPOtherOpt","QueryPrintTemp",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCAPPArcCat).killTmpGlobal(pid) //k掉临时global
	q ""
}

}
