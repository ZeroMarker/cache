Class web.DHCEMLevFunCat Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:   保存或者新增 分级指标函数分类库
/// Table：        DHC_EmLevFunCat
/// Input：	       LFCCode：代码
///                LFCDesc：描述
///                LFCActiveFlag：是否可用
///                LFCRemark:备注            
///                LFCHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// d ##class(web.DHCEMLevFunCat).SaveOrUpdate("收缩压^收缩压1^Y^收缩压^东华标准版数字化医院[总院]^2^27")
ClassMethod SaveOrUpdate(str)
{
        
  		 s LFCCode=$p(str,"^",1)
		 s LFCDesc=$p(str,"^",2)
		 s LFCActiveFlag=$p(str,"^",3)
		 s LFCRemark=$p(str,"^",4)
		 s LFCHospDr=$p(str,"^",5)
		 s LFCHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 s:+LFCHospDr=0 LFCHospDr=LFCHospDrID
		 s HasLFCHospID=""
		 s LFCRowID = $O(^DHCEMLFC(0,"Code",LFCCode,""))
		 s:LFCRowID'="" HasLFCHospID=$p(^DHCEMLFC(LFCRowID),"^",5)
		 b ;err
		 Q:(LFCRowID'="")&&(LFCRowID'=ID)&&(HasLFCHospID=LFCHospDr) 1
		 
		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmLevFunCat).%New()
		 } else{
			 s obj=##class(User.DHCEmLevFunCat).%OpenId(ID)
		 }
		 s obj.LFCHospDr=##class(User.CTHospital).%OpenId(LFCHospDr,0)
		 s obj.LFCCode=LFCCode
		 s obj.LFCDesc=LFCDesc
		 s obj.LFCActiveFlag=LFCActiveFlag
		 s obj.LFCRemark=LFCRemark
	 	
	     s sc=obj.%Save()   
	     
		 q 0
}

ClassMethod SaveLevFunCat(params)
{
  
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:： 分页显示分级指标函数分类库
/// Table：        DHC_EmLevFunCat
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMLevFunCat).ListLevFunCat(,,"","","")
ClassMethod ListLevFunCat(page = 1, rows = 10, LFCCode, LFCDesc, hospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMLFC(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMLFC(phId),"^",1)
		.s desc=$p(^DHCEMLFC(phId),"^",2)
		.s LFCActiveFlag=$p(^DHCEMLFC(phId),"^",3)
		.s LFCRemark=$p(^DHCEMLFC(phId),"^",4)
		.s LFCHospDr=$p(^DHCEMLFC(phId),"^",5)
		.s HOSPDesc=$p(^CT("HOSP",LFCHospDr),"^",2)
		.q:(LFCCode'="")&(LFCCode'=code)
		.q:(LFCDesc'="")&(LFCDesc'=desc)
		.q:(hospDrID'="")&(hospDrID'=LFCHospDr) //hxy 2019-07-21
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
		.s tmp=phId_"^"_code_"^"_desc_"^"_LFCActiveFlag_"^"_LFCRemark_"^"_HOSPDesc_"^"_LFCHospDr
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmLevFunCat).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LFCCode^LFCDesc^LFCActiveFlag^LFCRemark^LFCHospDr^LFCHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:： 查找一条分级指标函数分类库,以json形式返回
/// Table：        DHC_EmLevFunCat
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMLevFunCat).FindLevFunCat(1)
ClassMethod FindLevFunCat(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmLevFunCat).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:： 删除分级指标函数分类库
/// Table：        DHC_EmLevFunCat
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveLevFunCat(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmLevFunCat).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMLevFunCat).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// d ##class(web.DHCEMLevFunCat).ListCatLibTree()
ClassMethod ListCatLibTree()
{
	 w "["
	 s FunCatid=0,count=0
     for{
	      set FunCatid=$o(^DHCEMLFC(FunCatid)) 
	      q:FunCatid="" 
	      
	      s ret=""
	      i count>0 d
	      .s ret=ret_","
		  s ret= ret_"{"
		  s ret= ret_"""id"":"_1_","
		  s ret= ret_"""text"":"""_$p(^DHCEMLFC(FunCatid),"^",2)_""""
		  s ret= ret_",""children"":["
		  w ret
		  set FunLibid=0, i=0
	      for{
		      set FunLibid=$o(^DHCEMLFL(FunLibid)) 
	          q:FunLibid="" 
	          
		      s CatDr=$p(^DHCEMLFL(FunLibid),"^",8)
		      continue:CatDr'=FunCatid
		      i i>0 d
			  .w ","
		      w "{"
			  w """id"":"_2_","
			  w """text"":"""_$p(^DHCEMLFL(FunLibid),"^",2)_""""
			  w "}"
			  s i=i+1
		     }
		  w "]"
		  w "}"
		  s count=count+1  
	     }
	     
    w "]"
    q ""
}

}
