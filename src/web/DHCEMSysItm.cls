Class web.DHCEMSysItm Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description:   保存或者新增  产品功能表
/// Table：        DHC_EmSysItm
/// Input：	       SYCode：代码
///                SYDesc：描述
///                SYGroupName:标识
///                SYActiveFlag：是否可用             
///                SYHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
         
  		 s SYParRefDr=$p(str,"^",1)
  		 s SYCode=$p(str,"^",2)
		 s SYDesc=$p(str,"^",3)
		 s SYRemark=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 s SYLabel=$p(str,"^",6)
		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmSysItm).%New()
			 Q:$d(^DHCEMS(0,"SYCode",SYParRefDr,SYCode)) 1
			 
		 }else{
			 s obj=##class(User.DHCEmSysItm).%OpenId(ID)
			 
			 s isIN=0
			 i $d(^DHCEMS(0,"SYCode",SYParRefDr,SYCode)) d
			 .s PHIDUP=$O(^DHCEMS(0,"SYCode",SYParRefDr,SYCode,""))
			 .q:SYParRefDr_"||"_PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1
			 }
    
         i +ID=0 
		 {
		 s SYChildSub=$o(^DHCEMS(SYParRefDr,"I",""),-1)+1	 
		 }else{
			 s SYChildSub=$p(ID,"||",2)
			 }
			 
         s obj.SYParRefDr=##class(User.DHCEmSys).%OpenId(SYParRefDr)
         s obj.SYChildSub=SYChildSub
		 s obj.SYCode=SYCode
		 s obj.SYDesc=SYDesc
		 s obj.SYRemark=SYRemark
		 s obj.SYLabel=SYLabel
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      liyarong
/// CreatDate：    2017-03-29
/// Description:   更新产品功能表
/// w ##class(web.DHCEMSysItm).updFlag("L#U#D$5||7$G")
ClassMethod updFlag(params)
{
	s str=0
    s secflags=$p(params,"$",1)
    s said=$p(params,"$",2)
    s outFlags=$p(params,"$",3)
    ts
    
    i said'="" d
    .s obj=##class(User.DHCEmSysItm).%OpenId(said)
	.s obj.SYSecFlag=secflags	 
    .s sc=obj.%Save()
    .i $$$ISERR(sc) 
    ..s str=-1
    .e  s str=0  
   
    tro:str'=0 
    q:str'=0 str
    
    i outFlags'="" d
    .s id=+said,itm=$p(said,"||",2)
    .s sub=0
    .f  s sub=$o(^DHCEMS(id,"I",itm,"A",sub)) q:(sub="")||(str'=0)  d
    ..s type=$p(^DHCEMS(id,"I",itm,"A",sub),"^",1)
    ..q:outFlags'[type
    ..s syaid=id_"||"_itm_"||"_sub
    ..s sc =##class(User.DHCEmSysItmAut).%DeleteId(syaid)
    ..i $$$ISERR(sc) 
    ...s str=-1
    ..e  s str=0  
    tro:str'=0 
    q:str'=0 str
    
    tc
    
    q str
}

ClassMethod SaveSysItm(params)
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
/// CreatDate：    2016-06-07
/// Description：  分页显示 产品功能表
/// Table：        DHC_EmSysItm
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMSysItm).ListSysItm(,,"","","1","")
ClassMethod ListSysItm(page = 1, rows = 10, SYICode, SYIDesc, SAId, LabelDesc = "", q)
{
	   
	    s start=(page-1)*rows+1
	    s end=page*rows
	    w:+SAId=0 "{""rows"":[],""total"":0}"
	    q:+SAId=0 ""
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMS(phId)) q:phId=""  d
		.q:phId=0
		.q:SAId'=phId&SAId'=0
		.s child=""
		.f  s child=$o(^DHCEMS(phId,"I",child)) quit:child=""  d 
		..s code=$p(^DHCEMS(phId,"I",child),"^",1)
		..s desc=$p(^DHCEMS(phId,"I",child),"^",2)
		..s SYRemark=$p(^DHCEMS(phId,"I",child),"^",3)
		..s SecFlag=$p(^DHCEMS(phId,"I",child),"^",4)  //lyr
		..s SYLabel=$p(^DHCEMS(phId,"I",child),"^",5)
		..s SYLabelDesc=SYLabel
		..s:SYLabel="" SYLabelDesc="无标签"
		..s:$d(TMPData(SYLabelDesc)) TMPData(SYLabelDesc)=TMPData(SYLabelDesc)+1
		..s:'$d(TMPData(SYLabelDesc)) TMPData(SYLabelDesc)=1
		..q:(LabelDesc'="")&&(LabelDesc'=SYLabelDesc)
		..q:(SYICode'="")&(code'[$$ALPHAUP^SSUTIL4(SYICode))
		..q:(SYIDesc'="")&(desc'[$$ALPHAUP^SSUTIL4(SYIDesc))
		..q:(q'="")&(desc'[q)
		..s Id=phId_"||"_child
		..s count=count+1
		..q:count<start
		..q:count>end
		..s tmp=Id_"^"_code_"^"_desc_"^"_SYRemark_"^"_phId_"^"_SecFlag_"^"_SYLabel
	    ..w $case(count,start:"",:",")
	    ..w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SYCode^SYDesc^SYRemark^SYParRefDr^SecFlag^SYLabel",tmp)
	    ..;w jsonObj.FromObject(##class(User.DHCEmSysItm).%OpenId(Id)).Json() 
		w "],"
		w """labelList"":["
		s Count=0
		s SYLabel=""
		f  s SYLabel=$o(TMPData(SYLabel)) q:SYLabel=""  d
		.s LabelNumber=TMPData(SYLabel)
		.s TmpData=SYLabel_"^"_LabelNumber
		.s Count=Count+1
		.w $case(Count,1:"",:",")
		.w ##class(web.DHCAPPJsonCommon).getJsonData("SYLabel^LabelNumber",TmpData)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description：  删除 产品功能表
/// Table：        DHC_EmSysItm
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSysItm(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmSysItm).%DeleteId(Id)
	  s phId=$p(Id,"||",1)
	  s child=$p(Id,"||",2)
	  s childsub=""
	  f  s childsub=$o(^DHCEMS(phId,"I",child,"A",childsub)) quit:childsub=""  d 
	  .s childId=Id_"||"_childsub
	  .s obj=##class(User.DHCEmSysItmAut).%DeleteId(childId)
	  q 0
}

}
