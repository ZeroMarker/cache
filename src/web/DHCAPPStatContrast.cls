/// Descript: 病理申请单状态对照维护
/// Creator : qunianpeng
/// Date    : 2017-11-16
Class web.DHCAPPStatContrast Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取His病理状态
/// Creator:		QuNianpeng
/// CreateDate:		2017-11-16
/// Input:			
/// return:			
/// table:			oec_resultstatus / DHC_AppTestStatus
/// Other:			w ##class(web.DHCAPPStatContrast).GetStatus()
ClassMethod GetStatus() As %String
{
	s count=0
	w "["
	s statusId=""
	//f  s statusId=$o(^OEC("RESST",statusId)) q:statusId=""  d  从病理系统中获取状态
	//.q:statusId=0
	//.s statusDesc=$p(^OEC("RESST",statusId),"^",2) 
	f  s statusId=$o(^DHCAPPTST(statusId)) q:statusId=""  d  // 从病理申请状态表获取状态（新产品）
	.q:+statusId=0
	.s statusCode=$p(^DHCAPPTST(statusId),"^",1)      		// 状态代码
	.s statusDesc=$p(^DHCAPPTST(statusId),"^",2)	  		// 状态描述
	.s tmp=statusId_"^"_statusDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description:	保存或更新对照状态
/// Creator:		QuNianpeng
/// CreateDate:		2017-11-16
/// Input:			
/// return:			
/// table:			DHC_APPStatContrast
/// Other:			w
ClassMethod SaveUpdStatus(params)
{
    n (params)

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

/// Description:   保存或者新增 病理申请单状态对照表
/// Creator：      qunianpeng
/// CreatDate：    2017-11-16
/// Table：        DHC_APPStatContrast
/// Input：	      
/// Return：       保存成功 0，其他 失败 
/// Other:		   w ##class(web.DHCAPPStatContrast).SaveOrUpdate("3^ces2^测试1^Awaiting")
ClassMethod SaveOrUpdate(str)
{
		 n (str)
		 s valueFlag=0,isIN=0,isINC=0
		 s apscRowId = $p(str,"^",1)		//对照表id  		
  		 s pisCode = $zcvt($p(str,"^",2),"U")			//pis状态代码
  		 s pisDesc = $zcvt($p(str,"^",3),"U")			//pis状态描述
		 s hisStatId = $p(str,"^",4)		//检查状态id
		 s RowId=0
		 for {
			 s RowId=$o(^DHCAPPSC(RowId)) Q:RowId=""
			 continue:(+apscRowId'=0)&&(RowId=apscRowId)
			 s APPisCode=$p(^DHCAPPSC(RowId),"^",2)
			 s APPisCode=$zcvt(APPisCode,"U")
			 if (APPisCode=pisCode) s valueFlag=1 Q
			 s APPisDesc=$p(^DHCAPPSC(RowId),"^",3)
			 s APPisDesc=$zcvt(APPisDesc,"U")
			 if (APPisDesc=pisDesc) s valueFlag=2 Q
			 s APStatusDr=$p(^DHCAPPSC(RowId),"^",1)
			 if (APStatusDr=hisStatId) s valueFlag=3 Q
		 }
		 Q:(valueFlag>0) valueFlag
		 
		 if (+apscRowId=0) {
			 s obj=##class(User.DHCAPPStatContrast).%New()
		 }else{
			 s obj=##class(User.DHCAPPStatContrast).%OpenId(apscRowId)	
		 }
		 s:+hisStatId'=0 obj.APStatusDr=+hisStatId //##class(User.DHCAppTestStatus).%OpenId(+hisStatId)
		 s obj.APPisCode=pisCode
		 s obj.APPisDesc=pisDesc
		 s sc=obj.%Save()  		 
		 Q 0
		 
		 /*
		 i +apscRowId=0  d					//新增
		 .s obj=##class(User.DHCAPPStatContrast).%New()	
		 .i $d(^DHCAPPSC(0,"Code",$$ALPHAUP^SSUTIL4(pisCode))) s valueFlag = 1		//判断代码或描述是否存在
		 .i $d(^DHCAPPSC(0,"Desc",$$ALPHAUP^SSUTIL4(pisDesc))) s valueFlag = 2
		 .i $d(^DHCAPPSC(0,"HisStatus",hisStatId)) s valueFlag = 3					//his状态已经被对照过
		 q:(valueFlag>0) valueFlag
		 e  d								//修改
		 .s obj=##class(User.DHCAPPStatContrast).%OpenId(apscRowId)	
		 .i +hisStatId=0 d					//修改pis代码或者pis描述
		 ..i $d(^DHCAPPSC(0,"Code",$$ALPHAUP^SSUTIL4(pisCode))) d
		 ...s tmpStatId=$o(^DHCAPPSC(0,"Code",$$ALPHAUP^SSUTIL4(pisCode),"")) 
		 ...s:$p(^DHCAPPTST(tmpStatId),"^",1)=hisStatId isIN=1						//代码未修改
		 ..
		 ..i $d(^DHCAPPSC(0,"Desc",$$ALPHAUP^SSUTIL4(pisDesc))) d
		 ...s tmpStatId=$o(^DHCAPPSC(0,"Desc",$$ALPHAUP^SSUTIL4(pisDesc),"")) 
		 ...s:$p(^DHCAPPTST(tmpStatId),"^",2)=hisStatId isINC=1						//描述未修改
		 .q:(isIN=1)&(isINC=1)	 
		 .e  d
		 ..i $d(^DHCAPPSC(0,"HisStatus",hisStatId)) s valueFlag = 1					//his的id已经被对照
		 ..i $d(^DHCAPPSC(0,"Code",$$ALPHAUP^SSUTIL4(pisCode))) s valueFlag = 2	 	//pis的代码已经存在
		 ..i $d(^DHCAPPSC(0,"Desc",$$ALPHAUP^SSUTIL4(pisDesc)))	s valueFlag = 3		//pis的描述已经存在

		 q:(+apscRowId'=0)&(+hisStatId=0)&(isIN=0)&valueFlag 1								//代码重复
		 q:(+apscRowId'=0)&(+hisStatId=0)&(isINC=0)&valueFlag 2								//描述重复
		 q:valueFlag>0 valueFlag		 
		 
		 //s obj.APStatusDr=##class(User.OECResultStatus).%OpenId(+hisStatId)	    //病理组
		 s:+hisStatId'=0 obj.APStatusDr=+hisStatId //##class(User.DHCAppTestStatus).%OpenId(+hisStatId)
		 s obj.APPisCode=$zcvt(pisCode,"U")
		 s obj.APPisDesc=$zcvt(pisDesc,"U")

		 s sc=obj.%Save()  		 
		
		 ;i $$$ISERR(sc) q -2
		 q 0*/
}

/// Description:   删除 病理申请单状态对照表
/// Creator：      qunianpeng
/// CreatDate：    2017-11-22
/// Input：	 	   表id
/// Table：        DHC_APPStatContrast     
/// Return：       删除成功 0，其他 失败 
/// Other:			w ##class(web.DHCAPPStatContrast).RemoveStat(14)
ClassMethod RemoveStat(id)
{
	n (id)  
	q:+id=0 -1
	s obj=##class(User.DHCAPPStatContrast).%DeleteId(id)
	q 0
}

/// Description:   查询病理申请单状态对照表
/// Creator：      qunianpeng
/// CreatDate：    2017-11-20 
/// Input：	       Pis代码，pis描述
/// Table：        DHC_APPStatContrast
/// Return：       
/// Other:			w ##class(web.DHCAPPStatContrast).ListStatContrast(1,20,"cs1","")
ClassMethod ListStatContrast(page, rows, pisStatCode, pisStatDesc)
{
	
	n (page,rows,pisStatCode,pisStatDesc)
             
	s pisStatCode=$zcvt(pisStatCode,"U"),pisStatDesc=$zcvt(pisStatDesc,"U")   
	s start=(page-1)*rows+1
	s end=page*rows
	s count=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	w "{""rows"":["
	 
	s contrastId=""
	f  s contrastId=$o(^DHCAPPSC(contrastId))  q:contrastId=""  d
	.q:contrastId=0
	.s msg=$g(^DHCAPPSC(contrastId))
	.q:msg=""
	.s statId=$p(msg,"^",1)				//his检查状态
	.s code=$p(msg,"^",2)				//pis状态代码
	.s desc=$p(msg,"^",3)				//pis状态描述
	.//s statCode=$p(^OEC("RESST",statId),"^",1)  //病理
	.//s statDesc=$p(^OEC("RESST",statId),"^",2) 
	.s statCode=$p(^DHCAPPTST(statId),"^",1) 
	.s statDesc=$p(^DHCAPPTST(statId),"^",2) 	
	.q:(pisStatCode'="")&(code'[pisStatCode)
	.q:(pisStatDesc'="")&(desc'[pisStatDesc)
	.s tmp=contrastId_"^"_code_"^"_desc_"^"_statDesc	
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("contrastId^pisStatCode^pisStatDesc^statDesc",tmp)

	w "],""total"":"_count_"}"
	q ""
}

}
