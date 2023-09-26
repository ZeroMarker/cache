Import sqluser

Class web.DHCADVREPSHARE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 添加采纳日期  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-9
/// Table: 		 DHC_AdvRepShare 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPSHARE).InsRepShareDate("7")
ClassMethod InsRepShareDate(shareId As %String) As %String
{
   N (shareId)
	S rshCompleteDate=+$h  //结束日期
	S rshCompleteTime=$p($h,",",2) //结束时间
	&SQL(Update DHC_AdvRepShare Set RSH_CompleteDate=:rshCompleteDate, RSH_CompleteTime=:rshCompleteTime Where RSH_RowID=:shareId)
	Q SQLCODE
}

/// Description: 添加分享信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-4
/// Table: 		 DHC_AdvRepShare 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPSHARE).InsRepShare("33^12175^113^29^advMedical^17||1^未分享")
ClassMethod InsRepShare(params As %String) As %String
{
   
	N (params)	
	S rshPointer=+$p(params,"^",1)       //不良反应报告ID   //指针  报告ROWID  rshPointer
	S rshCreatorID=+$p(params,"^",2)     //用户ID
	S LgCtLocID=+$p(params,"^",3)     //科室ID
	S LgGroupID=+$p(params,"^",4)     //安全组ID 
	
	S typecode=$p(params,"^",5) // 报告类型代码
	S rshTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //类别指向
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I rshTypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") rshTypeDr=RepTypeParref_"||"_RepTypeSub
	
	S StatusID=$p(params,"^",6) // 当前状态
	
	S rshCreateDate=+$h  //创建日期
	S rshCreateTime=$p($h,",",2) //创建时间
	S rshCompleteDate=""   //结束日期
	S rshCompleteTime=""   //结束时间  //rshTypeDr
	S Err=0 //2016-11-02 congyue
	S RshID=$o(^DHCADVRSH(0,"TypePointer",rshTypeDr,rshPointer,"")) //2016-11-02 congyue
	I (RshID'="") D //2016-11-02 congyue
	.S Err=..DelRepShare(RshID) //2016-11-02 congyue
	E  &SQL(Insert Into DHC_AdvRepShare(RSH_Type_Dr, RSH_Pointer, RSH_Creator, RSH_CreateDate, 
	    RSH_CreateTime, RSH_CompleteDate, RSH_CompleteTime 
	   ) Values(:rshTypeDr,:rshPointer,:rshCreatorID,:rshCreateDate,:rshCreateTime,:rshCompleteDate,:rshCompleteTime	
	))
	.S:SQLCODE'=0 Err=SQLCODE //2016-11-02 congyue
	i Err<0  Q Err //2016-11-02 congyue
	Q Err //2016-11-02 congyue
}

/// Description: 删除分享信息  
/// Creator:     yangyongtao congyue修改
/// CreateDate:  2016-08-17  2016-11-02
/// Table: 		 DHC_AdvRepShare 
/// Input: 		 报告表的id , params:
/// Return： 	 通过报告的ID删除分享的信息
/// Others:		 w ##class(web.DHCADVREPSHARE).DelRepShare("19")
ClassMethod DelRepShare(RshID As %String) As %String
{
	N (RshID)
	S flag=0,Err=0
	TS
	I (RshID'="") D
	.&SQL(Delete From DHC_AdvRepShare Where RSH_RowID=:RshID)
	.S:SQLCODE'=0 Err=SQLCODE
	I (Err'=0) tro
	Q:(Err'=0) -3
	
	//删除相关表  
	I $d(^DHCADVRON(0,"SHA",RshID)) D
	.S onlneID=""
	.F  S onlneID=$o(^DHCADVRON(0,"SHA",RshID,onlneID)) Q:onlneID=""  D
	..I $d(^DHCADVROA(0,"User",onlneID)) D
	...&SQL(DELETE DHC_AdvRepOnlineAcc WHERE  ROA_Online_Dr=:onlneID)
	...S:SQLCODE'=0 flag=SQLCODE
	..
	.&SQL(DELETE DHC_AdvRepOnline WHERE  RON_Share_Dr=:RshID)
	.S:SQLCODE'=0 Err=SQLCODE
	I (Err'=0)||(flag'=0) tro
	Q:(Err'=0)||(flag'=0) -4
	TC
	Q 0
}

/// Description: 通过ID获取分享信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-6-13
/// Table: 		 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据  rshPointer  rshTypeDr
/// Others:		 w ##class(web.DHCADVREPSHARE).getRepShareByID("12","1","advMedical^33")
ClassMethod getRepShareByID(rows As %String, page As %String, params As %String) As %String
{
    N (rows,page,params,%session)
    s End = page*rows
    s Start = (page-1)*rows+1
    S TypeCode=$p(params,"^",1)
    Q:TypeCode=""
    S rshPointer=$p(params,"^",2)
    s h=0,count=0
    s rshID=""
    S typeId=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
    F  S rshID=$o(^DHCADVRSH(0,"TypePointer",typeId,rshPointer,rshID))  Q:rshID=""  d
	.s rshTypeDr=$p(^DHCADVRSH(rshID),"^",1) //报告类型ID
	.s reportDr=$p(^DHCADVRSH(rshID),"^",2) //报告ID
	.// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	.S TypeCode="",typeEvent=""
	.S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(reportDr)
	.S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	.S TypeCode=$p(RepTypeString,"^",2)
	.S typeEvent=$p(RepTypeString,"^",3)
	.S RepTypeDr=$p(RepTypeString,"^",4)
	.S RepTypeCode=$p(RepTypeString,"^",5)
	.S recordID="",RepStausDr="",RepStaus=""
	.I $d(^DHCADVMASTER(reportDr))  D
	..S recordID=$p(^DHCADVMASTER(reportDr),"^",1)
	..S RepStausDr=$p(^DHCADVMASTER(reportDr),"^",3)
	..S:RepStausDr'="" RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	.s rshCreateDate=$p(^DHCADVRSH(rshID),"^",4) //分享日期
	.s:rshCreateDate'="" rshCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(rshCreateDate)
	.s rshCreateTime=$p(^DHCADVRSH(rshID),"^",5) //分享时间
	.S:rshCreateTime'="" rshCreateTime=$zt(rshCreateTime,1)
	.s rshCompleteDate=$p(^DHCADVRSH(rshID),"^",6) //结束日期
	.S statusFinsh=""
	.I rshCompleteDate="" S statusFinsh="N"
	.I rshCompleteDate'="" S statusFinsh="Y"
	.s TempStr=rshID_"^"_typeEvent_"^"_rshCreateDate_"^"_rshCreateTime_"^"_statusFinsh_"^"_TypeCode_"^"_reportDr_"^"_recordID_"^"_RepStaus_"^"_rshTypeDr
	.S h=h+1
	.s ^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareByID",h)=TempStr
	
	q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^typeEvent^rshCreateDate^rshCreateTime^FinshStatus^TypeCode^reportDr^recordID^RepStaus^rshTypeDr"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareByID",index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareByID",index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareByID") //k掉临时global
	q ""
}

/// Description: 获取分享信息  
/// Creator:     yangyongtao
/// CreateDate:  2016-5-5
/// Table: 		 
/// Input: 		 分享表id , params:
/// Return： 	 报告表数据
/// Others:		 w ##class(web.DHCADVREPSHARE).getRepShareList("30","1","2016-05-05^2016-06-09^")
ClassMethod getRepShareList(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期 
	s statFinsh=$p(params,"^",3) //完成状态
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	s h=0,count=0
	f dd=StDate:1:EndDate d
	
    .s rshID="0"
	.f  s rshID=$o(^DHCADVRSH(0,"CreateDate",dd,rshID)) q:rshID=""  d  //获取报告ID
	..s rshTypeDr=$p(^DHCADVRSH(rshID),"^",1) //报告类型ID
	..s reportDr=$p(^DHCADVRSH(rshID),"^",2) //报告ID
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S TypeCode="",typeEvent=""
	..S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(reportDr)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S typeEvent=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..S recordID="",RepStausDr="",RepStaus=""
	..I $d(^DHCADVMASTER(reportDr))  D
	...S recordID=$p(^DHCADVMASTER(reportDr),"^",1)
	...S RepStausDr=$p(^DHCADVMASTER(reportDr),"^",3)
	...S:RepStausDr'="" RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	
	..s rshCreateDate=$p(^DHCADVRSH(rshID),"^",4) //分享日期
	..s:rshCreateDate'="" rshCreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(rshCreateDate)
	..s rshCreateTime=$p(^DHCADVRSH(rshID),"^",5) //分享时间
	..S:rshCreateTime'="" rshCreateTime=$zt(rshCreateTime,1)
	..s rshCompleteDate=$p(^DHCADVRSH(rshID),"^",6) //结束日期
	..S statusFinsh=""
	..;I rshCompleteDate="" S statusFinsh="N" //hxy 2018-02-06 st
	..;I rshCompleteDate'="" S statusFinsh="Y"
	..s statusFinsh=..CheckShreStatus(rshID) //hxy ed 一条分享记录对应的所有的评论记录 当所有的评论记录的状态都不为Y时，认为没有采纳
	..Q:(statFinsh'="")&&(statusFinsh'="")&&(statFinsh'=statusFinsh)
	..s h=h+1
	..s TempStr=rshID_"^"_typeEvent_"^"_rshCreateDate_"^"_rshCreateTime_"^"_statusFinsh_"^"_TypeCode_"^"_reportDr_"^"_recordID_"^"_RepStaus_"^"_rshTypeDr
	..s ^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareList",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^typeEvent^rshCreateDate^rshCreateTime^FinshStatus^TypeCode^reportDr^recordID^RepStaus^rshTypeDr"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareList",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCADV","web.DHCADVREPSHARE","getRepShareList",pid)
}

/// Description: 根据分享记录对应的所有的评论记录 当所有的评论报告的状态都不为Y时，认为没有采纳
/// Creator:     QuNianpeng
/// CreateDate:  2018-1-8
/// Table: 		 
/// Input: 		 分享表id
/// Return： 	 分享完成状态 Y完成 N未完成
/// Others:		 w ##class(web.DHCADVREPSHARE).CheckShreStatus(174)
ClassMethod CheckShreStatus(rshID) As %String
{
	n (rshID)
	q:rshID="" "N"
	s statusFinsh="N"
	s ronID=""
	f  s ronID=$o(^DHCADVRON(0,"SHA",rshID,ronID))  q:(ronID="")||(statusFinsh="Y")  d
	.s accFlag=$p(^DHCADVRON(ronID),"^",6)
	.s statusFinsh=$CASE(accFlag,"Y":"Y","N":"N","":"N")  //将默认的状态为kong 的也认为是未完成	

	q $g(statusFinsh)
}

}
