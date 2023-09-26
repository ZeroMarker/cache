Class web.DHCEMLevFunLib Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:   保存或者新增 分级指标函数库
/// Table：        DHC_EmLevFunLib
/// Input：	       LFLCode：代码
///                LFLDesc：描述
///                LFLActiveFlag：是否可用
///                LFLRemark:备注            
///                LFLHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
		 
  		 s LFLCode=$p(str,"^",1)
		 s LFLDesc=$p(str,"^",2)
		 s LFLMedthod=$p(str,"^",3)
		 s LFLRetVal=$p(str,"^",4)
		 s LFLActiveFlag=$p(str,"^",5)
		 s LFLRemark=$p(str,"^",6)
		 s LFLHospDr=$p(str,"^",7)
		 s LFLCatDr=$p(str,"^",8)
		 s LFLHospDrID=$p(str,"^",9)
		 s LFLCatDrID=$p(str,"^",10)
		 s ID=$p(str,"^",11)

		 i +ID=0 
		 {
			  s obj=##class(User.DHCEmLevFunLib).%New()
			  s obj.LFLHospDr=##class(User.CTHospital).%OpenId(LFLHospDr,0)
			  s obj.LFLCatDr=##class(User.DHCEmLevFunCat).%OpenId(LFLCatDr,0)
		 	  ;Q:$d(^DHCEMLFL(0,"Code",LFLCode)) 1
		 	  
		 	  s isIN=0
			  i $d(^DHCEMLFL(0,"Code",LFLCode)) d
			  .s LFLID=$O(^DHCEMLFL(0,"Code",LFLCode,""))
			  .s HospDr=$p(^DHCEMLFL(LFLID),"^",7)
			  .q:HospDr'=LFLHospDr
			  .s isIN=1
			  q:isIN=1 1
		 }else{  
		      s obj=##class(User.DHCEmLevFunLib).%OpenId(ID)
		      i +LFLHospDr=0 d
		      .s obj.LFLHospDr=##class(User.CTHospital).%OpenId(LFLHospDrID,0)
		      e  d
		      .s obj.LFLHospDr=##class(User.CTHospital).%OpenId(LFLHospDr,0)
		      i +LFLCatDr=0 d
		      .s obj.LFLCatDr=##class(User.DHCEmLevFunCat).%OpenId(LFLCatDrID,0)
		      e  d
		      .s obj.LFLCatDr=##class(User.DHCEmLevFunCat).%OpenId(LFLCatDr,0)
		      
		      s isIN=0
			  i $d(^DHCEMLFL(0,"Code",LFLCode)) d
			  .s rowID=$O(^DHCEMLFL(0,"Code",LFLCode,""))
			  .s HospDrUP=$p(^DHCEMLFL(rowID),"^",7)
			  .i +LFLHospDr=0 d
		      ..q:HospDrUP'=LFLHospDrID
		      ..q:rowID=ID
		      ..s isIN=1 
		      .e  d
			  ..q:HospDrUP'=LFLHospDr
			  ..q:rowID=ID
			  ..s isIN=1
			  q:isIN=1 1
		 }
		 
		 s obj.LFLCode=LFLCode
		 s obj.LFLDesc=LFLDesc
		 s obj.LFLMedthod=LFLMedthod
		 s obj.LFLRetVal=LFLRetVal
		 s obj.LFLActiveFlag=LFLActiveFlag
		 s obj.LFLRemark=LFLRemark
	 	 
	 
		 s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveLevFunLib(params)
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
/// Description：  分页显示分级指标函数库
/// Table：        DHC_EmLevFunLib
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMLevFunLib).ListLevFunLib(,,"","","")
ClassMethod ListLevFunLib(page = 1, rows = 10, LFLCode, LFLDesc, hospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMLFL(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMLFL(phId),"^",1)
		.s desc=$p(^DHCEMLFL(phId),"^",2)
		.s LFLMedthod=$p(^DHCEMLFL(phId),"^",3)
		.s LFLRetVal=$p(^DHCEMLFL(phId),"^",4)
		.s LFLActiveFlag=$p(^DHCEMLFL(phId),"^",5)
		.s LFLRemark=$p(^DHCEMLFL(phId),"^",6)
		.s LFLHospDr=$p(^DHCEMLFL(phId),"^",7)
		.q:(hospDr'="")&(hospDr'=LFLHospDr)  //hxy 2019-07-21
		.s LFLHospDesc=$P(^CT("HOSP",LFLHospDr),"^",2)
        .s LFLCatDr=$p(^DHCEMLFL(phId),"^",8)
        .//q:LFLCatDr="0"
        .s:LFLCatDr'=0 LFLCatDesc=$p(^DHCEMLFC(LFLCatDr),"^",2)
        .s tmp=phId_"^"_code_"^"_desc_"^"_LFLMedthod_"^"_LFLRetVal_"^"_LFLActiveFlag_"^"_LFLRemark_"^"_LFLHospDesc_"^"_LFLCatDesc_"^"_LFLHospDr_"^"_LFLCatDr
		.q:(LFLCode'="")&(LFLCode'=code)
		.q:(LFLDesc'="")&(LFLDesc'=desc)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmLevFunLib).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LFLCode^LFLDesc^LFLMedthod^LFLRetVal^LFLActiveFlag^LFLRemark^LFLHospDr^LFLCatDr^LFLHospDrID^LFLCatDrID",tmp)
		.
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description:： 查找一条分级指标函数库,以json形式返回
/// Table：        DHC_EmLevFunLib
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMLevFunLib).FindLevFunLib(1)
ClassMethod FindLevFunLib(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmLevFunLib).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description：  删除分级指标函数库
/// Table：        DHC_EmLevFunLib
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveLevFunLib(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmLevFunLib).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMLevFunLib).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-26
/// Description：  GetLFLCatDr(分类下拉)
/// Table：        DHC_EmLevFunCat
/// d ##class(web.DHCEMLevFunLib).GetLFLCatDr()
ClassMethod GetLFLCatDr(type)
{
  w "["
  set RowID=0,count=0 
  f  s RowID=$o(^DHCEMLFC(RowID)) q:RowID=""  d
  .s Desc=$p(^DHCEMLFC(RowID),"^",2)
  .s Hosp=$p(^DHCEMLFC(RowID),"^",5)
  .q:$p(^DHCEMLFC(RowID),"^",3)'="Y"
  .;q:Hosp'=type //hxy 2020-12-25 改公有
  .s tmp=RowID_"^"_Desc
  .i count>0 d
  ..w ","
  .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
  .s count=count+1
  w "]"
  q ""
}

}
