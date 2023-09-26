Class web.DHCAPPPartItm Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：   zhouxin
/// CreatDate：    2016-05-19
/// Description:： 保存或者新增部位关联
/// Table：        DHC_AppPartItm
/// Input：	      
/// Return：       保存成功 0，其他 失败
ClassMethod saveOrUpdate(str)
{
  

 s part=$p(str,"^",2) 
 s ID=$p(str,"^",3) 
 s ParRefDr=$p(str,"^",4) 
 q:part=ParRefDr 0
 i +ID=0 d
 .s obj=##class(User.DHCAppPartItm).%New()
 .s obj.APIParRefDr=##class(User.DHCAppPart).%OpenId(ParRefDr)
 .s ch=$o(^DHCAPPART(ParRefDr,"I",""),-1)+1
 .s obj.APIChildSub=ch
 e  d
 .s obj=##class(User.DHCAppPartItm).%OpenId(ID)
 .d obj.%Reload()
 s obj.APIPartDr=##class(User.DHCAppPart).%OpenId(part)
 s sc=obj.%Save()
 i $$$ISERR(sc) q -2
 q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增部位关联
/// Table：        DHC_AppPartItm
/// Input：	       部位描述^部位代码^使用状态^部位表ID$$部位描述^部位代码^使用状态^部位表ID
/// Return：       保存成功 0，其他 失败
ClassMethod save(params)
{
  
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
	.s ret=..CheckRepeatDeal(str)   /// 重复性判断
	.q:ret'=0  	
	.s ret=..saveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// d ##class(web.DHCAPPPart).list()
ClassMethod list(partId = "")
{
  
  w "{""rows"":["
  s sub=0,count=0
  f  s sub=$o(^DHCAPPART(partId,"I",sub)) q:sub=""  d
  .q:+sub=0
  .s part=$p(^DHCAPPART(partId,"I",sub),"^",1)
  .w $case(count,0:"",:",")
  .s jsonObj=##class(web.DHCAPPJsonObject).%New()
  .d jsonObj.Put("APDesc",$p(^DHCAPPART(part),"^",2))
  .d jsonObj.Put("APCode",$p(^DHCAPPART(part),"^",1))
  .d jsonObj.Put("ID",partId_"||"_sub)
  .d jsonObj.Put("ParRefDr",partId)
  .w jsonObj.Json()
  .s count=count+1
  w "],""total"":"_count_"}"
  q ""
}

/// Creator:     CongYue
/// CreateDate:  2016-06-23
/// Description: 保存或者新增部位关联[检查代码是否重复]
/// Table:		 DHC_AppPartItm
/// Return: 	 无重复 0,重复 非0
/// Others:		 w ##class(web.DHCAPPPartItm).CheckRepeatDeal("6^0^5")
ClassMethod CheckRepeatDeal(str)
{
	s part=$p(str,"^",2)  
	s ID=$p(str,"^",3) 
	s ParRefDr=$p(str,"^",4) 
	s sub=""
	s flag=0
	f  s sub=$o(^DHCAPPART(ParRefDr,"I",sub)) q:sub=""  d
  	.q:+sub=0
  	.s partdr=$p(^DHCAPPART(ParRefDr,"I",sub),"^",1)
	.s:partdr=part flag=-10
	.q:flag=-10
	q flag
}

}
