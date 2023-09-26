Import SQLUser

Class web.DHCMDTFolUpTimes Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 保存MDT反馈次数维护
/// Table：        DHC_MDTFolUpTimes 
/// Input：	       ID^父表id^次数^间隔时间
/// Return：       保存成功:0，其他:失败
/// w ##class(web.DHCMDTFolUpTimes).saveOrUpdate("^1^1^1^5^Y")
ClassMethod saveOrUpdate(str)
{
	n (str)
	q:str="" 0
 	s ID=$p(str,"^",1)
 	s MDGroupDr=$p(str,"^",2)		//关联表ID
 	s MDTimes=$p(str,"^",3)			//次数
 	s MDInterval=$p(str,"^",4)			//间隔时间	 
	 i +ID=0 d
	 .s obj=##class(User.DHCMDTFolUpTimes).%New()
	 e  d
	 .s obj=##class(User.DHCMDTFolUpTimes).%OpenId(ID)
	 d obj.MDGroupDrSetObjectId(MDGroupDr)
	 s obj.MDTimes=MDTimes
	 s obj.MDInterval=MDInterval

	 s sc=obj.%Save()
	 s code=0,msg=""
	 i $SYSTEM.Status.IsError(sc) d
	 .s code=$SYSTEM.Status.GetErrorCodes(sc)
	 .s msg=$SYSTEM.Status.GetErrorText(sc)
	 q code
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 批量保存或者修改MDT反馈次数
/// Table：        DHC_MDTFolUpTimes
/// Input：	       ID^父表id^次数^间隔时间$$ID^父表id^次数^间隔时间
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCMDTFolUpTimes).save("^3^13^13^53^Y$$^15^15^15^55^Y")
ClassMethod save(mParam)
{
  	n (mParam)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(mParam,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s ret=##class(web.DHCMDTFolUpTimes).saveOrUpdate($p(mParam,"$$",i))
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
Err
	TRollback
	q -999
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 删除MDT反馈次数维护
/// Table：        DHC_MDTFolUpTimes 
/// Others：       w ##class(web.DHCMDTFolUpTimes).remove("1")
ClassMethod remove(ID As %String)
{
  
	n (ID)
	s code=0,msg="success"
	s sc=##class(User.DHCMDTFolUpTimes).%DeleteId(ID)
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	.s msg=$SYSTEM.Status.GetErrorText(sc)
	d ##class(web.DHCPUECommon).R(code,msg)
	q ""
}

/// Creator：      xiaowenwu
/// CreatDate：    2020-03-05
/// Description:： 查询MDT反馈次数维护
/// Table：        DHC_MDTFolUpTimes 
/// Others：       w ##class(web.DHCMDTFolUpTimes).QryFolUpTimes(10,1,3)
ClassMethod QryFolUpTimes(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTFUT(0,"Group",mID,ID)) Q:ID=""  D
	.s MDTimes=$p(^DHCMDTFUT(ID),"^",2)    	//次数
	.s MDInterval=$p(^DHCMDTFUT(ID),"^",3)    	//间隔时间
	.s mID=$p(^DHCMDTFUT(ID),"^",1)    		//类型ID
	.s h=h+1
	.s ListData=ID_"^"_MDTimes_"^"_MDInterval_"^"_mID
	.s TmpItemDet(h)=ListData	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""	
	///转换数据为Json格式
	s ListTitle="ID^MDTimes^MDInterval^mID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 	  //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() 		   //输出json结尾符
	Q ""
}

}
