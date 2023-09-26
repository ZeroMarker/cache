Import sqluser

/// 不良事件案例共享
Class web.DHCADVCASESHARE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[案例共享数据] 
/// Creator:     CongYue
/// CreateDate:  2018-01-24  
/// Table:	     DHC_AdvCaseShare 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCASESHARE).SaveCaseShare("^10^advFallDownFill^2^Y^10277^10500^88")
ClassMethod SaveCaseShare(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len Q:Err'=0    D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdCaseShare(TmpStr)
	.E  D
	..S Err=..InsCaseShare(TmpStr)

	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-30
/// Table:		 DHC_MedAdrRepEvent
/// Others:		 w ##class(web.DHCADVCASESHARE).CheckRepeatDeal("^10^advFallDownFill^2^Y^10277^10361^111")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s ret=0
	S CaseShareID=$p(TmpStr,"^",1)   		///ID
	S RepDr=$p(TmpStr,"^",2)   			///报告指向
	S RepTypeCode=$p(TmpStr,"^",3)   	///报告类型指向
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	s eventparref="",eventsub="" ;2018-08-29
	i RepTypeDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	
	S CaseShareLocDr=$p(TmpStr,"^",4)   	///报告类型指向
	s CaseShareUser=$p(TmpStr,"^",7)   	///报告类型指向
	b   ///333
	/// 新记录
	if CaseShareID=""  d
	.i $d(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr))   d
	..s ShareId=""
	..for  s ShareId=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr,ShareId)) q:(ShareId="")||(ret'=0)  d
	...s ShareUser=$p(^DHCADVCASHARE(ShareId),"^",11)
	...q:CaseShareUser'=ShareUser
	...s ret=-1
	/// 修改记录
	else  d
	.S ShareLocDr=$p($g(^DHCADVCASHARE(CaseShareID)),"^",3)    //科室指向
	.i (ShareLocDr'=CaseShareLocDr)&($d(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr)))  d
	..s ShareId=""
	..f  s ShareId=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr,ShareId)) q:(ShareId="")||(ret'=0)  d
	...s ShareUser=$p(^DHCADVCASHARE(ShareId),"^",11)
	...q:CaseShareUser'=ShareUser
	...s ret=-2
	..
	.
	Q ret
}

/// Description: 增加[案例共享数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-24  
/// Table:	     DHC_AdvCaseShare 
/// Input:  	 DataList:以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCASESHARE).InsCaseShare("")
ClassMethod InsCaseShare(DataList As %String) As %String
{
	N (DataList)
	S CaseShareID=$p(DataList,"^",1)   		///ID
	S RepID=$p(DataList,"^",2)   	///报告指向
	S RepTypeCode=$p(DataList,"^",3)   	///报告类型指向
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	s eventparref="",eventsub="" ;2018-08-29
	i RepTypeDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	S CaseShareLocDr=$p(DataList,"^",4)   	///科室指向
	S CASHAREIfShare=$p(DataList,"^",5)   ///共享
	S CASHAREUser=$p(DataList,"^",6) //案例共享人
	S CaseShareUserDr=$p(DataList,"^",7) //报告人员指向
	S CaseShareAdvice=$p(DataList,"^",8) //共享意见

	S CASHAREDate=+$h  ;案例共享日期
	S CASHARETime=$p($h,",",2)  ;案例共享时间

 	&SQL(INSERT INTO DHC_AdvCaseShare(CASHARE_RepDr,CASHARE_RepType,CASHARE_LocDr,CASHARE_IfShare,CASHARE_User,CASHARE_Date,CASHARE_Time,CASHARE_UserDr,CASHARE_Advice) 
 		VALUES(:RepID,:RepTypeDr,:CaseShareLocDr,:CASHAREIfShare,:CASHAREUser,:CASHAREDate,:CASHARETime,:CaseShareUserDr,:CaseShareAdvice))
 	Q SQLCODE
}

/// Description: 修改[案例共享数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-24  
/// Table:	     DHC_AdvCaseShare 
/// Input:  	 DataList: 以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVCASESHARE).UpdCaseShare("2^2018-01-16^案例共享")
ClassMethod UpdCaseShare(DataList As %String) As %String
{
	N (DataList)
	S CaseShareID=$p(DataList,"^",1)   		///ID
	;S RepID=$p(DataList,"^",2)   	///报告指向
	;S RepTypeCode=$p(DataList,"^",3)   	///报告类型指向
	;S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	;S CaseShareLocDr=$p(DataList,"^",4)   	///报告类型指向
	S CASHAREIfShare=$p(DataList,"^",5)  ///撤销共享
	;Q:CASHAREIfShare'="N" "0"
	S CASHARERevShareUser=$p(DataList,"^",6) ;撤销人
	S CASHARERevDate=+$h   ;撤销案例共享日期
	S CASHARERevTime=$p($h,",",2)   ;撤销案例共享时间
	S CaseShareUserDr=$p(DataList,"^",7) //报告人员指向
	S CaseShareAdvice=$p(DataList,"^",8) //共享意见
	&SQL(Update DHC_AdvCaseShare Set CASHARE_IfShare=:CASHAREIfShare,CASHARE_RevShareUser=:CASHARERevShareUser,CASHARE_RevDate=:CASHARERevDate,CASHARE_RevTime=:CASHARERevTime,CASHARE_Advice=:CaseShareAdvice,CASHARE_UserDr=:CaseShareUserDr WHERE CASHARE_RowID=:CaseShareID)
 	Q SQLCODE
}

/// Description: 查询[案例共享数据维护]
/// Creator:     CongYue
/// CreateDate:  2018-01-24  
/// Table:		 DHC_AdvCaseShare
/// Input:  	 DataList: 以字符"^"分割,格式为:代码^描述
/// Return: 	 案例共享数据维护信息
/// Others:		 w ##class(web.DHCADVCASESHARE).QueryCaseShare("","","4^advAccidentFill")
ClassMethod QueryCaseShare(rows = 10, page = 1, params As %String) As %String
{
	N (rows,page,params,%session)
	S End = page*rows
	S Start=(page-1)*rows+1
    S pid=##class(web.DHCADVMEDCOMMON).GetPID()
    K ^TMP("DHCADV","web.DHCADVCASESHARE","QueryCaseShare",pid)
    S RepDr=$p(params,"^",1)
	S RepTypeCode=$p(params,"^",2)   	///报告类型指向
	S RepTypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //类别指向
	s eventparref="",eventsub="" ;2018-08-29
	i RepTypeDr=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(RepTypeCode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") RepTypeDr=eventparref_"||"_eventsub
	
	S h=0,count=0
	S CaseShareLocDr=""
	F  S CaseShareLocDr=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr)) Q:CaseShareLocDr=""  D
	.S ID=""
	.F  S ID=$o(^DHCADVCASHARE(0,"RepDrType",RepDr,RepTypeDr,CaseShareLocDr,ID)) Q:ID=""  D
	..Q:+ID=0
	..S CaseShareLocDr=$p(^DHCADVCASHARE(ID),"^",3) ///共享科室指向
	..S ShareLoc=""
	..S:CaseShareLocDr'="" ShareLoc=$p(^CTLOC(CaseShareLocDr),"^",2)
	..S ShareLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",ShareLoc)  
	..S CaseShareUserDr=$p(^DHCADVCASHARE(ID),"^",11) ///共享人员指向
	..S ShareUser=""  
	..S:CaseShareUserDr'="" ShareUser=$p(^SSU("SSUSR",CaseShareUserDr),"^",2)
	..S ShareUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",ShareUser) 
	..S CaseShareAdvice=$p(^DHCADVCASHARE(ID),"^",12) ///共享意见
	..S CASHAREIfShare=$p(^DHCADVCASHARE(ID),"^",4) ///共享标识
	..S h=h+1
	..S TempStr=ID_"^"_RepDr_"^"_RepTypeCode_"^"_CaseShareLocDr_"^"_ShareLoc_"^"_CASHAREIfShare_"^"_CaseShareUserDr_"^"_ShareUser_"^"_CaseShareAdvice
	..S ^TMP("DHCADV","web.DHCADVCASESHARE","QueryCaseShare",pid,h)=TempStr
	
	D:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^RepDr^RepTypeCode^ShareLocDr^ShareLoc^Active^ShareUserDr^ShareUser^ShareAdvice"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVCASESHARE","QueryCaseShare",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVCASESHARE","QueryCaseShare",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVCASESHARE","QueryCaseShare",pid)
	Q ""
}

}
