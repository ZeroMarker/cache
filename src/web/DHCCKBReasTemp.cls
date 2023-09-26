/// Creator:     	chenzhaobo
/// CreateDate:   	2021-10-27
/// Descript:		审核原因模板操作
Class web.DHCCKBReasTemp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:   保存或者新增 审核原因模板
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Table:		   DHC_CKBReasTemp
/// Input: 		   RowID:id, text：模板内容/描述，type：类型：User/Loc/Common，point：类型指向，activeFlag：是否可用
/// Output:		   // 0 代表成功 -1代表失败 1 代表重复
/// Others:w ##class(web.DHCCKBReasTemp).AddOrUpdate("^test1^测试1^Y^2")
ClassMethod AddOrUpdate(str) As %String
{
	
	n (str)
	s RowID = $p(str,"^",1)
	s text = $p(str,"^",2)
	s type = $p(str,"^",3)
	s point = $p(str,"^",4)
	s activeFlag = $p(str,"^",5)
	i RowID="" d
	.s obj=##class(User.DHCCKBReasTemp).%New()
	e  d
	.s obj=##class(User.DHCCKBReasTemp).%OpenId(RowID)
	i obj d
	.s obj.RTText=text
	.s obj.RTType=type
	.s obj.RTPoint=point
	.s obj.RTActiveFlag=activeFlag
	.s sc=obj.%Save()
	.i sc d
	..s result = 0 
	.e  d
	..s result = -1
	e  d
	.s result = -1
	q result
}

/// Description:   批量保存或者新增 审核原因模板
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Others:		   w ##class(web.DHCCKBReasTemp).Save("^审核原因1^1^1^Y$$")
ClassMethod Save(params) As %String
{
	n (params)
	ts
	s res = 0
	s len = $l(params,"$$")
	f i=1:1:len d
	.q:(res=-1)||(res=1)
	.s str = $p(params,"$$",i)
	.s res = ..AddOrUpdate(str)
	i res=0 d
	.tc
	e  d
	.tro
	q res
}

/// Description:   删除审核原因模板
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Table:		   DHC_CKBReasTemp
/// Input: 		   RowID:  ID
/// Output:		   0：成功，-1：失败
/// Others:		   w ##class(web.DHCCKBReasTemp).Remove("")
ClassMethod Remove(RowID) As %String
{
	n (RowID)
	q:RowID="" -1
	s obj = ##class(User.DHCCKBReasTemp).%DeleteId(RowID)
	q 0
}

/// Description:   初始化查询审核原因模板
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Table:		   DHC_CKBReasTemp
/// Input: 		   page:当前页，rows:行数
/// Output:		   RowID:id, text：模板内容/描述，type：类型：User/Loc/Common，point：类型指向，activeFlag：是否可用
/// Others:d ##class(web.DHCCKBReasTemp).GetList()
ClassMethod GetList(page, rows) As %String
{
	n (page, rows)
	s start=(page-1)*rows+1
	s end = page*rows
	s count = 0
	s strData = "RowID^RTText^RTType^RTPoint^RTPointDesc^RTActiveFlag"
	w "{""rows"":["
	s RowID = ""
	f  s RowID = $o(^User.DHCCKBReasTempD(RowID)) q:RowID=""  d
	.s str = $g(^User.DHCCKBReasTempD(RowID))
	.s RTText = $list($g(str),2)
	.s RTType = $list($g(str),3)
	.s RTPoint = $list($g(str),4)
	.s RTPointDesc=""
	.i RTType="User" d
	..s RTPointDesc=$p(^SSU("SSUSR",RTPoint),"^",2)
	.else  if RTType="Loc"   d
	..s RTPointDesc=$p(^CTLOC(RTPoint),"^",2)
	.s RTActiveFlag = $list($g(str),5)
	.s tmp = RowID_"^"_RTText_"^"_RTType_"^"_RTPoint_"^"_RTPointDesc_"^"_RTActiveFlag
	.s count = count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData(strData,tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// Description:	根据条件查询审核原因模板
/// Creator:		chenzhaobo
/// CreatDate:		2021-10-27
/// Table:			DHC_CKBReasTemp
/// Input: 			params:（UserPoint：人员id，LocPoint:科室id,RTText：描述）
/// Output:		    RowID:id, text：模板内容/描述，type：类型：User/Loc/Common，point：类型指向，activeFlag：是否可用
/// Others:d ##class(web.DHCCKBReasTemp).GetListByCondition(1,10,"1^^")
ClassMethod GetListByCondition(page, rows, params) As %String
{
	n (page, rows, params)
	s start=(page-1)*rows+1
	s end = page*rows
	s count = 0
	s UserPoint = $p(params,"^",1)
	s LocPoint = $p(params,"^",2)
	s text = $p(params,"^",3)
	s strData = "RowID^RTText^RTType^RTPoint^RTPointDesc^RTActiveFlag"
	w "{""rows"":["
	s RowID = ""
	for
	{
		
		s RowID = $o(^User.DHCCKBReasTempD(RowID)) 
		q:RowID=""  
		s str = $g(^User.DHCCKBReasTempD(RowID))
		Continue:(UserPoint'="")&($lg(str,4)'=UserPoint) // 循环匹配人员是否相等
		Continue:(LocPoint'="")&($lg(str,4)'=LocPoint) // 循环匹配科室是否相等
		Continue:(text'="")&($lg(str,2)'[text) // 循环匹配描述是否相同
		s RTText = $lg(str,2)
		s Name = $lg(str,3)
		s RTType = $lg(str,3)
		s RTPoint = $lg(str,4)
		s RTPointDesc=""
		i (RTType="User")&(RTPoint'="") d
		.s RTPointDesc=$p(^SSU("SSUSR",RTPoint),"^",2)
		e  i (RTType="Loc")&(RTPoint'="")   d
		.s RTPointDesc=$p(^CTLOC(RTPoint),"^",2)
		s RTActiveFlag = $lg(str,5)
		s tmp = RowID_"^"_RTText_"^"_RTType_"^"_RTPoint_"^"_RTPointDesc_"^"_RTActiveFlag
		s count = count+1
		q:count<start
		q:count>end
		w $case(count,start:"",:",") 
		w ##class(web.DHCAPPJsonCommon).getJsonData(strData,tmp)
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Description:   初始化获取人员数据
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Table:		   SS_USER
/// Input: 		   
/// Output:		  
/// Others:w ##class(web.DHCCKBReasTemp).JsonUser()
ClassMethod JsonUser() As %String
{
	s UserID = 0
	s count = 0
	w "["
	for
	{
		s UserID=$o(^SSU("SSUSR",UserID))
		q:UserID=""
		s str = $g(^SSU("SSUSR",UserID))
		s User = $p(str,"^",2)
		s tmp=UserID_"^"_User
		s count = count+1
		i count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}  
	w "]"
	Q ""
}

/// Description:   初始化获取科室数据
/// Creator:	   chenzhaobo
/// CreatDate:	   2021-10-27
/// Table:		   CT_Loc
/// Input: 		  
/// Output:		   
/// Others:w ##class(web.DHCCKBReasTemp).JsonLoc()
ClassMethod JsonLoc() As %String
{
	s LocID = 0
	s count = 0
	w "["
	for
	{
		s LocID=$o(^CTLOC(LocID))
		q:LocID=""
		s str = $g(^CTLOC(LocID))
		s Loc = $p(str,"^",2)
		s tmp=LocID_"^"_Loc
		s count = count+1
		i count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}  
	w "]"
	Q ""
}

/// Description:	获取维护的审核原因数据
/// Creator:		xww
/// CreatDate:		2021-12-01
/// Table:			DHC_CKBReasTemp
/// Input: 			UserID：人员id，LocID:科室id
/// Output:		    
/// Others:			w ##class(web.DHCCKBReasTemp).JsonGetReason(1,11882)
ClassMethod JsonGetReason(LocID, UserID) As %String
{
	n (LocID,UserID)
	s count = 0
	w "["
	//先输出个人的
	s RowID = ""
	f  s RowID = $o(^User.DHCCKBReasTempI("IndexRTType"," USER"," "_UserID,RowID)) q:RowID=""  d
 	.s Active = $lg(^User.DHCCKBReasTempD(RowID),5)
	.q:Active'="Y"
	.s RTText = $lg(^User.DHCCKBReasTempD(RowID),2)
	.s tmp=RowID_"^"_RTText
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	
	//再输出科室的
	s RowID = ""
	f  s RowID = $o(^User.DHCCKBReasTempI("IndexRTType"," LOC"," "_LocID,RowID)) q:RowID=""  d
 	.s Active = $lg(^User.DHCCKBReasTempD(RowID),5)
	.q:Active'="Y"
	.s RTText = $lg(^User.DHCCKBReasTempD(RowID),2)
	.s tmp=RowID_"^"_RTText
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	
	//输出全院的
	s RowID = ""
	f  s RowID = $o(^User.DHCCKBReasTempI("IndexRTType"," COMMON"," ",RowID)) q:RowID=""  d
 	.s Active = $lg(^User.DHCCKBReasTempD(RowID),5)
	.q:Active'="Y"
	.s RTText = $lg(^User.DHCCKBReasTempD(RowID),2)
	.s tmp=RowID_"^"_RTText
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

}
