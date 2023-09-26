Import SQLUSER

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   配送申请
Class web.DHCDISGoodsRequest Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/*/// Description:  拆分保存配送申请
/// Creator:      zhaowuqiang
/// CreatDate:    2017-05-05
/// Input:        任务数据串,项目数据串
/// Output:       SQLCODE
/// Other:   w ##class(web.DHCDISGoodsRequest).saveReqString("4839^77^416^^22/03/2018^13:23:29^2018-03-22^13:23:32^14^N","36^1",1)
ClassMethod saveReqString(mainStrings, subStr, flag = "")
{
	n (mainStrings, subStr,flag)
	s ^tempsufan(3)=mainStrings_"#"_subStr_"#"_flag
	s ret=0
	s locDrString=$p(mainStrings,"^",3)
	s locLength=$l(locDrString,",")
	f i=1:1:locLength q:ret'=0  d
	.s recLocDr=$p(locDrString,",",i)
	.s mainStr=$p(mainStrings,"^",1)_"^"_$p(mainStrings,"^",2)_"^"_recLocDr_"^"_$p(mainStrings,"^",4)_"^"_$p(mainStrings,"^",5)_"^"_$p(mainStrings,"^",6)
	.s mainStr=mainStr_"^"_$p(mainStrings,"^",7)_"^"_$p(mainStrings,"^",8)_"^"_$p(mainStrings,"^",9)_"^"_$p(mainStrings,"^",10)
	.s ret=..save(mainStr, subStr,flag)
	
	q ret
}

/// Description:  保存配送申请
/// Creator:      zhaowuqiang
/// CreatDate:    2017-04-13
/// Input:        任务数据串,项目数据串
/// Output:       SQLCODE
/// Other:        w ##class(web.DHCDISGoodsRequest).save("4^100^1^ss^04/05/2017^14:31:11^2017-05-04^14:31:21^1^Y", "39^1")
ClassMethod save(mainStr, subStr, flag)
{
	n (mainStr, subStr,flag)
	TS	
	
	s ReqType=$p(mainStr,"^",9)
	s EmFlag=$p(mainStr,"^",10)
	s code=##class(web.DHCDISGoodsRequest).getVerfiyCode()
	s obj=##class(User.DHCDisGoodsRequest).%New()
	s obj.REQCreateUser=##class(User.SSUser).%OpenId($p(mainStr,"^",1))
	s obj.REQLocDr=##class(User.CTLoc).%OpenId($p(mainStr,"^",2))
	s obj.REQRecLocDr=##class(User.CTLoc).%OpenId($p(mainStr,"^",3))
	s obj.REQRemarks=$p(mainStr,"^",4)
	s obj.REQExeDate=##class(web.DHCDISCommonDS).DateHtmlToLogical($p(mainStr,"^",5))
	s obj.REQExeTime=$zth($p(mainStr,"^",6),1)
	s obj.REQCreateDate=##class(web.DHCDISCommonDS).DateHtmlToLogical($p(mainStr,"^",7))
	s obj.REQCreateTime=$zth($p(mainStr,"^",8),1)
	s obj.REQNo=code
	s obj.REQBarCode=##class(web.DHCDISGoodsRequest).createBarCode("")
	s obj.REQTypeAddDr=##class(User.DHCDisTypeAdd).%OpenId($p(mainStr,"^",9))
	s obj.REQEmFlag=$p(mainStr,"^",10)
	s sc=obj.%Save()
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  TRollBack
 	  q -1
 	}
 	
 	//保存配送申请子表
 	s mainId=obj.%Id()
 	s newObj=##class(User.DHCDisGoodsRequest).%OpenId(mainId)
 	s err=0
 	s length=$l(subStr,"$$")
 	f i=1:1:length  d
 	.s str=$p(subStr,"$$",i)
 	.s subobj=##class(User.DHCDisGoodsReqItm).%New()
 	.s subobj.REQItem=##class(User.DHCDisLocItem).%OpenId($p(str,"^",1))
 	.;s subobj.REQExeLocDr=##class(User.CTLoc).%OpenId($p(str,"^",2))
 	.s subobj.REQQty=$p(str,"^",2)
 	.s subobj.REQParRefDr=newObj
	.s subobj.REQChildSub=$o(^DHCDISGRE(mainId,"ITM",""),-1)+1
	.s sc=subobj.%Save()
	.If $$$ISERR(sc) s err=-2
	.s sub=subobj.REQChildSub
	.s reqi=mainId_"||"_sub
	.s itm=$p(^DHCDISGRE(mainId,"ITM",sub),"^",3)
	.s err=..autoSaveUser($p(^DHCDISGRE(mainId),"^",2),reqi,itm)
	i err'=0 {
		TRollBack
		q err
	}
	
	//保存验证码明细
	s Code = $p(^DHCDISGRE(mainId),"^",1)
	s CreateDate = $p(^DHCDISGRE(mainId),"^",7)
	s CreateTime = $p(^DHCDISGRE(mainId),"^",8)
	s CreateUser = $p(^DHCDISGRE(mainId),"^",9)
	s object=##class(User.DHCDisRequestCode).%New()
	s object.RCPointer=mainId
	s object.RCCode=Code
	s object.RCReqType=ReqType
	;s object.RCReqType=obj.REQTypeAddDr
	s object.RCCreateDate=CreateDate
	s object.RCCreateTime=CreateTime
	s object.RCCreateUser=##class(User.SSUser).%OpenId(CreateUser)
	s sc=object.%Save()
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  TRollBack
 	  q -1
 	}
	b   //mainId ,ReqType,EmFlag,flag
 	s nextStatsu=##class(web.DHCDISRequestCom).getNextStatus(mainId,ReqType,EmFlag,flag)
 	b   //nextStatsu
 	q:nextStatsu="" -1
 	s nexStatusCode=$p(^DHCDISSA(nextStatsu),"^",1)
	s ret=##class(web.DHCDISRequestCom).updateStatus(mainId,ReqType,nexStatusCode,obj.REQCreateUser,EmFlag,flag)
 	i ret'=0 TRollBack
 	q:ret'=0 ret 
	TC
	
	q 0
}
*/
/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存配送申请
/// Table：     User.DHCDisGoodsRequest,User.DHCDisGoodsReqItm,User.DHCDisRequestCode
/// Return:		申请单ID串
/// w ##class(web.DHCDISGoodsRequest).Save("38^1^216^14#3084^216^^17/08/2018^12:00:08^17/08/2018^12:00:13^14^N^216^1","1")
ClassMethod Save(ListData As %String, flag As %String = "") As %String
{
	n (ListData,flag)
	
	s ^tempsufan("temp")=$lb(ListData,flag)
	s ListData=##Class(web.DHCDISGoodsRequest).dealInsListData(ListData)
	s Len = $l(ListData,"$$")
	s ReqIdstr=""
	s Err = 0
	TS
	for i=1:1:Len  q:Err<0  d
	.s InsListData=$p(ListData,"$$",i)
	.s MainListData=$p(InsListData,"#",1)
	.s ItmListData=$p(InsListData,"#",2)
	.s ReqDisID=..InsertReq(MainListData,ItmListData,flag)
	.i ReqDisID<0  s Err=ReqDisID
	.q:ReqDisID<0
	.s ReqIdstr=$s(ReqIdstr'="":ReqIdstr_"^"_ReqDisID,1:ReqDisID)  ///配送申请表ID串
	i Err'=0 tro
	q:Err'=0 Err
	TC
	d ##class(web.DHCDISGoodsRequest).SenDisInfoNew(ReqIdstr,flag)
	Q ReqIdstr
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存配送申请
/// Table：     User.DHCDisGoodsRequest,User.DHCDisGoodsReqItm,User.DHCDisRequestCode
/// Return:		申请单ID串
/// w ##class(web.DHCDISGoodsRequest).InsertReq("30","1","283")
ClassMethod InsertReq(ListData As %String, ItmListData As %String, flag) As %String
{
	n (ListData,ItmListData,flag)
	s Err=0
	TS
	/// 配送申请表
	s ReqDisID=..InsDisRep(ListData)
	i ReqDisID<0 tro
	q:ReqDisID<0 ReqDisID
	
	/// 配送项目
	f i=1:1:$L(ItmListData,"&&") q:Err'=0  d
	.s DisListData=$p(ItmListData,"&&",i)
	.s Err=..InsRepItm(ReqDisID,DisListData)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 保存验证码信息
	s Err=..InsDisCode(ReqDisID)
	i Err<0 tro
	q:Err<0 "-12"
	

	/// 更新申请状态
	s Err=..UpdateReqStatus(ReqDisID,flag)
	i Err<0 tro
	q:Err<0 "-13"
	
	///更新配送护工表
	/*s Err=..InsReqPeople(ReqDisID,flag)
	i Err<0 tro
	q:Err<0 Err*/
	TC
	q ReqDisID
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存配送申请
/// Table：     User.DHCDisGoodsRequest
/// Return:		申请单ID串
/// w ##class(web.DHCDISGoodsRequest).InsDisRep("38^1^185^14^ZX20180902061#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1",1)
ClassMethod InsDisRep(ListData As %String) As %String
{
	n (ListData)
	s ^tempsufan("ListData")=ListData
	s CreatUser=$p(ListData,"^",1)			// 创建人
	s ReqCtLoc=$p(ListData,"^",2)			// 申请科室
	s Remarks=$p(ListData,"^",3)			// 备注
	s ReqDisDate=$p(ListData,"^",4)			// 配送日期
	i ReqDisDate'="" s ReqDisDate=$zdh(ReqDisDate,4)
	s ReqDisTime=$p(ListData,"^",5)			// 配送时间
	i ReqDisTime'="" s ReqDisTime=$zth(ReqDisTime,3)
	s ReqCreatDate=$p(ListData,"^",6)   	// 创建日期
	i ReqCreatDate'="" s ReqCreatDate=$zdh(ReqCreatDate,4)
	s ReqCreatTime=$p(ListData,"^",7)   	// 创建时间
	i ReqCreatTime'="" s ReqCreatTime=$zth(ReqCreatTime,3)
	s ReqType=$p(ListData,"^",8)   			// 配送类型
	s EmFlag=$p(ListData,"^",9)				// 加急标志
	s Location=$p(ListData,"^",10)			// 申请单位置
	s LocationFlag=$p(ListData,"^",11)		// 位置标识
	s ReqRecLoc=$p(ListData,"^",12)			// 接收科室
	s ReqBarCode=##class(web.DHCDISGoodsRequest).createBarCode("")	// 验证码
	s ReqCode=##class(web.DHCDISGoodsRequest).getVerfiyCode() 
	s ReqExtBarCode=$p(ListData,"^",13)			// 外部条码 
	s PhBoxNum=$p(ListData,"^",14)				// 数量
	&sql(insert into DHC_DisGoodsRequest (REQ_No,REQ_Loc_Dr,REQ_RecLoc_Dr,REQ_ExeDate,REQ_ExeTime,REQ_Remarks,REQ_CreateDate,REQ_CreateTime,REQ_CreateUser,REQ_BarCode,REQ_TypeAdd_Dr,REQ_EmFlag,REQ_Loction,REQ_LoctionFlag,REQ_ExtBarCode,REQ_ExtNum)
		values (:ReqCode,:ReqCtLoc,:ReqRecLoc,:ReqDisDate,:ReqDisTime,:Remarks,:ReqCreatDate,:ReqCreatTime,:CreatUser,:ReqBarCode,:ReqType,:EmFlag,:Location,:LocationFlag,:ReqExtBarCode,:PhBoxNum))
	i SQLCODE'=0  q SQLCODE
	q +%ROWID
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存配送申请
/// Table：     User.DHCDisGoodsReqItm
/// Return:		申请单ID串
/// w ##class(web.DHCDISGoodsRequest).InsRepItm("133","29^87^1")
ClassMethod InsRepItm(ReqDisID As %String, ListData As %String) As %String
{
	n (ReqDisID,ListData)
	s DisItmID=$p(ListData,"^",1)     		///配送项目ID
	s DisExeLoc=$p(ListData,"^",2)          ///接收科室
	s DisItmQty=$p(ListData,"^",3)	    	///项目数量
	s ChildSub=$o(^DHCDISGRE(ReqDisID,"ITM",""),-1)+1
	&sql(insert into DHC_DisGoodsReqItm (REQ_ParRef_Dr,REQ_ChildSub,REQ_Item,REQ_ExeLoc_Dr,REQ_Qty)
		values (:ReqDisID,:ChildSub,:DisItmID,:DisExeLoc,:DisItmQty))
	q SQLCODE
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存验证码
/// Table：     DHC_DisRequestCode
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).InsDisCode("")
ClassMethod InsDisCode(ReqDisID As %String) As %String
{
	n (ReqDisID)
	s Code=$p(^DHCDISGRE(ReqDisID),"^",1)		   ///申请单ID
	s CreateDate=$p(^DHCDISGRE(ReqDisID),"^",7)    ///创建日期
	s CreateTime=$p(^DHCDISGRE(ReqDisID),"^",8)	   ///创建时间
	s CreateUser=$p(^DHCDISGRE(ReqDisID),"^",9)	   ///创建人
	s ReqType=$p(^DHCDISGRE(ReqDisID),"^",12)	   ///配送类型
	
	&sql(insert into DHC_DisRequestCode (RC_ReqType,RC_Pointer,RC_Code,RC_CreateDate,RC_CreateTime,RC_CreateUser,RC_ActiveFlag)
		values (:ReqType,:ReqDisID,:Code,:CreateDate,:CreateTime,:CreateUser,"Y"))
		
	q SQLCODE
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   保存验证码
/// Table：     DHC_DisRequestCode
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).UpdateReqStatus("71",1)
ClassMethod UpdateReqStatus(ReqDisID As %String, flag) As %String
{
	n (ReqDisID,flag)
	s ^tempsufan("ceshi")=ReqDisID_"%"_flag
	s CreatUser=$p(^DHCDISGRE(ReqDisID),"^",9)			// 创建人
	s ReqType=$p(^DHCDISGRE(ReqDisID),"^",12)   		// 配送类型
	s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			// 加急标志
	s Relation=$p(^DHCDISGRE(ReqDisID),"^",14)			// 当前位置
	s RelaFlag=$p(^DHCDISGRE(ReqDisID),"^",15)			// 当前位置标识
	s nextState=##class(web.DHCDISRequestCom).getNextStatus(ReqDisID,ReqType,EmFlag,flag)
 	q:nextState="" -1
 	s nexStatusCode=$p(^DHCDISSA(nextState),"^",1)
	s ret=##class(web.DHCDISRequestCom).updateStatus(ReqDisID,ReqType,nexStatusCode,CreatUser,EmFlag,flag,"",Relation,RelaFlag)
 	q ret
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   插入配送护工人员
/// Table：     DHC_DisPeople
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).InsReqPeople("16")
ClassMethod InsReqPeople(ReqDisID As %String, flag As %String = "") As %String
{
	n (ReqDisID,flag)

	s Err=0
	s TypeDr=$p(^DHCDISGRE(ReqDisID),"^",12)			/// 配送类型
	s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			/// 加急标志
	s isRelFlag=..isLinkRel(ReqDisID)					/// 判断业务科室是否关联中转站
	i (EmFlag="Y")||(isRelFlag'="Y") d					/// 加急申请或者业务科室不管联中转站，则取直达岗
	.s UserList=..getDirectUserId(ReqDisID)
	e  d
	.s UserList=..getDisUserId(ReqDisID,flag)					/// 护工Id
	q:+UserList="0" "-15"
	s Len=$l(UserList,"^")
	for i=1:1:Len  q:Err'=0  d
	.s UserId=$p(UserList,"^",i)
	.s obj=##class(User.DHCDisPeople).%New()
	.s obj.DPReqType=TypeDr
	.s obj.DPUserDr=##class(User.SSUser).%OpenId(UserId)
	.s obj.DPPointer=ReqDisID
	.s sc=obj.%Save()
	.If $$$ISERR(sc) s Err=-2
	
	q Err
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   判断业务科室是否关联中转站
/// Table：     DHC_DisScheduleType,DHC_DisSchedule
/// w ##class(web.DHCDISGoodsRequest).isLinkRel()
ClassMethod isLinkRel(ReqDisID)
{
	n (ReqDisID)
	s Flag="N"
	s RecLocDr=$p(^DHCDISGRE(ReqDisID),"^",3)   		/// 接收科室
	s RepLocDr=$p(^DHCDISGRE(ReqDisID),"^",2)   		/// 申请科室
	i $d(^PAWARD(0,"WARD_LocationDR",RecLocDr)) d		/// 判断业务科室是否关联病区
	.q:'$d(^DHCDISNLL(0,"NodeLoc",RecLocDr))			
	.s Flag="Y"
	e  d
	.q:'$d(^DHCDISNLL(0,"NodeLoc",RepLocDr))
	.s Flag="Y"
	q Flag
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   插入配送护工人员
/// Table：     DHC_DisScheduleType,DHC_DisSchedule
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).getDisUserId("")
ClassMethod getDisUserId(ReqDisID As %String, flag As %String) As %String
{
	n (ReqDisID,flag)
	s UserIdList=""
	s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			/// 加急标志
	s TypeDr=$p(^DHCDISGRE(ReqDisID),"^",12)			/// 配送类型
	s RecLocDr=$p(^DHCDISGRE(ReqDisID),"^",3)   		/// 接收科室
	s RepLocDr=$p(^DHCDISGRE(ReqDisID),"^",2)   		/// 申请科室
	s NodeLocId=$o(^DHCDISNLL(0,"NodeLoc",RepLocDr,""))
	q:NodeLocId="" ""
	s NodeId=""
	for  s NodeId=$o(^DHCDISWN(0,"Locpoint",NodeLocId,"0",NodeId))	q:NodeId=""  d /// 取岗位Id  中转站和岗位关联
	.q:..isHavePermisson(NodeId,TypeDr)'="1"				/// 先判断有没有权限
	.s RetFlag=..isScheReasonable(ReqDisID,NodeId,TypeDr)	/// 判断排班
	.q:$p(RetFlag,"^",1)'="1"
	.s LocaList=..getLocationStr(NodeId)				/// 取岗位关联的所有工作位置
	.;q:(flag'="")&&(LocaList'[RepLocDr)					/// 发送时按照发起科室关联的岗位取护工
	.;q:(flag="")&&(LocaList'[RecLocDr)					/// 安排时按照接收科室关联的岗位取护工
	.s SchRowId=$p(RetFlag,"^",2)						/// 排班类型Id
	.s SchtRowId=""
	.for  s SchtRowId=$o(^DHCDISSCH(0,"point",SchRowId,SchtRowId)) q:SchtRowId=""  d
	..s SchtTypeDr=$p(^DHCDISSCH(SchtRowId),"^",2)		/// 类型
	..q:SchtTypeDr'=TypeDr
	..s NodeDr=$p(^DHCDISSCH(SchtRowId),"^",3)			/// 岗位Id
	..q:NodeId'=NodeDr
	..s LinkUserId=""
	..for  s LinkUserId=$o(^DHCDISWLU(0,"Node",NodeDr,LinkUserId)) q:LinkUserId=""  d
	...s UserId=$p(^DHCDISWLU(LinkUserId),"^",1)			/// 护工Id
	...i UserIdList="" s UserIdList=UserId
	...e  s UserIdList=UserIdList_"^"_UserId
	q UserIdList
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   取岗位对应的位置信息
/// Input:		岗位Id
/// w ##class(web.DHCDISGoodsRequest).getLocationStr()
ClassMethod getLocationStr(NodeId As %String) As %String
{
	n (NodeId)
	s LocaList=""
	s CH=""
	for  s CH=$o(^DHCDISWN(NodeId,"I",CH))	q:CH=""  d
	.s Location=$p(^DHCDISWN(NodeId,"I",CH),"^",1)			// 位置Id,中转站或者科室
	.s LocationFlag=$p(^DHCDISWN(NodeId,"I",CH),"^",2)		// 位置标识
	.q:LocationFlag'="1"
	.i LocaList="" s LocaList=Location
	.e  s LocaList=LocaList_"^"_Location
	q LocaList
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   判断是否有配送权限
/// Input:		岗位Id,配送类型
/// Table：     DHC_DisWorkNodeType
/// w ##class(web.DHCDISGoodsRequest).isHavePermisson()
ClassMethod isHavePermisson(NodeId As %String, TypeDr As %String) As %String
{
	n (NodeId,TypeDr)
	q:NodeId="" "岗位不存在"
	s FlagCode=0
	s WorTypeId=""
	for  s WorTypeId=$o(^DHCDISWNT(0,"Node",NodeId,WorTypeId))	q:(WorTypeId="")||(FlagCode="1")  d
	.s DisTypeId=$p(^DHCDISWNT(WorTypeId),"^",1)		/// 配送类型
	.q:DisTypeId'=TypeDr
	.s FlagCode="1"
	q FlagCode
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   判断排班时间
/// Input:		申请单Id,类型Id,岗位Id
/// Table：     DHC_DisScheduleType,DHC_DisSchedule
/// w ##class(web.DHCDISGoodsRequest).isScheReasonable("115","8","14")
ClassMethod isScheReasonable(ReqDisID As %String, NodeId As %String, TypeDr As %String) As %String
{
	n (ReqDisID,NodeId,TypeDr)
	s FlagList=""
	s FlagCode="0"
	s DisDate=$p(^DHCDISGRE(ReqDisID),"^",4)		/// 配送日期
	s DisTime=$p(^DHCDISGRE(ReqDisID),"^",5)		/// 配送时间
	s SchRowId="",SchTypeId="",DisShift=""
	q:NodeId="" "此岗位岗位不存在"
	q:'$d(^DHCDISSCH(0,"Nodepoint",NodeId)) "0_此岗位没有排班"
	for  s SchRowId=$o(^DHCDISSCH(0,"Nodepoint",NodeId,SchRowId)) 	q:(SchRowId="")||(FlagCode="1")  d
	.s DisTypeId=$p(^DHCDISSCH(SchRowId),"^",2)		/// 配送类型Id
	.q:DisTypeId'=TypeDr							/// 班次类型过滤
	.q:'$d(^DHCDISWNT(0,"Typepoint",NodeId,TypeDr))	/// 过滤配送类型
	.s SchTypeId=$p(^DHCDISSCH(SchRowId),"^",1)		/// 排班类型Id
	.s SchStDate=$p(^DHCDISSCHT(SchTypeId),"^",5)	/// 班次开始日期
	.s SchStTime=$p(^DHCDISSCHT(SchTypeId),"^",6)	/// 班次开始时间
	.s SchEndDate=$p(^DHCDISSCHT(SchTypeId),"^",3)	/// 班次结束日期
	.s SchEndTime=$p(^DHCDISSCHT(SchTypeId),"^",4)	/// 班次结束时间
	.q:(SchStDate'="")&&(SchStDate>DisDate)			/// 配送日期是否在开始日期范围之内
	.q:(SchEndDate'="")&&(SchEndDate<DisDate)		/// 配送日期是否大于结束日期
	.s SchStTime=$zth(SchStTime_":"_"00",1)			/// 转换排班时间
	.s SchEndTime=$zth(SchEndTime_":"_"00",1)
	.q:(SchStTime'="")&&(SchStTime>DisTime)			/// 配送时间是否在开始时间范围之内
	.q:(SchEndTime'="")&&(SchEndTime<DisTime)		/// 配送时间是否大于结束时间
	.s FlagCode="1"
	.s DisShift=SchRowId
	s FlagList=FlagCode_"^"_DisShift
	q FlagList
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   获取直达岗护工
/// Return:		数据串
/// w ##class(web.DHCDISGoodsRequest).getDirectUserId()
ClassMethod getDirectUserId(ReqDisID As %String) As %String
{
	n (ReqDisID)
	s UserIdList=""
	s DisTypeId=$p(^DHCDISGRE(ReqDisID),"^",12)		/// 配送类型
	s NodeId=$o(^DHCDISWN(0,"Code",$$ALPHAUP^SSUTIL4("药品配送岗[直达岗]"),""))
	q:..isHavePermisson(NodeId,DisTypeId)'="1" "有没有权限"		/// 先判断有没有权限
	s RetFlag=..isScheReasonable(ReqDisID,NodeId,DisTypeId)	/// 判断排班
	q:$p(RetFlag,"^",1)'="1" "无排班信息"						/// 无排班信息
	s SchRowId=$p(RetFlag,"^",2)						/// 排班类型Id
	s SchtRowId=""
	for  s SchtRowId=$o(^DHCDISSCH(0,"point",SchRowId,SchtRowId)) q:SchtRowId=""  d
	.s SchtTypeDr=$p(^DHCDISSCH(SchtRowId),"^",2)		/// 类型
	.q:SchtTypeDr'=DisTypeId
	.s NodeDr=$p(^DHCDISSCH(SchtRowId),"^",3)			/// 岗位Id
	.q:NodeId'=NodeDr
	.s LinkUserId=""
	.for  s LinkUserId=$o(^DHCDISWLU(0,"Node",NodeDr,LinkUserId)) q:LinkUserId=""  d
	..s UserId=$p(^DHCDISWLU(LinkUserId),"^",1)			/// 护工Id
	..i UserIdList="" s UserIdList=UserId
	..e  s UserIdList=UserIdList_"^"_UserId
	q UserIdList
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   按接收科室组织申请数据
/// Return:		数据串
/// w ##class(web.DHCDISGoodsRequest).dealInsListData("38^4^185^14^ZX201809020611#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1$$38^4^185^14^ZX201809020612#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1$$38^4^185^14^ZX201809020613#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1$$38^4^185^14^ZX201809020614#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1")
ClassMethod dealInsListData(ListData As %String) As %String
{
	n (ListData)
	s pid=##Class(web.DHCDISCommonDS).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s Len = $L(ListData,"$$")   		 	/// 申请数量
	f i=1:1:Len  d
	.s InsListData=$p(ListData,"$$",i)
	.s ItmListData=$p(InsListData,"#",1)   /// 配送项目信息
	.s mainListData=$p(InsListData,"#",2)  /// 申请主表信息
	.s itemDisID=$p(ItmListData,"^",1)     /// 配送项目
	.s DisQty=$p(ItmListData,"^",2)        /// 项目数量
	.s ExecLocID=$p(ItmListData,"^",3)     /// 接收科室
	.s DisType=$p(ItmListData,"^",4)       /// 配送类型
	.s index=ExecLocID 					   /// 分单规则(按接收科室)
	.s index2=itemDisID_"^"_ExecLocID_"^"_DisQty   		/// 分单项目
	.s ^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid,index)=mainListData_"^"_ExecLocID_"^"_$p(ItmListData,"^",5)_"^"_$p(ItmListData,"^",2)
	.s ^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid,index,index2)=""
 
	s ListData=""
	s index=""
	f  s index=$o(^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid,index)) Q:index=""  D
	.s ReqItmIDList=""
	.s mListData=$g(^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid,index))
	.s index2=""
	.f  s index2=$o(^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid,index,index2)) Q:index2=""  D
	..s ReqItmID=$p(index2,"^",1)    		/// 配送项目ID
	..s ItmExeLocID=$p(index2,"^",2) 		/// 接收科室
	..s ItmQty=$p(index2,"^",3) 		    /// 数量
	..s ReqItmList=ReqItmID_"^"_ItmExeLocID_"^"_ItmQty
	..
	..i ReqItmIDList="" s ReqItmIDList=ReqItmList
	..E  s ReqItmIDList=ReqItmIDList_"&&"_ReqItmList
	.
	.i ListData="" s ListData=mListData_"#"_ReqItmIDList 
	.E  s ListData=ListData_"$$"_mListData_"#"_ReqItmIDList
	.
	d ..killTmpGlobal(pid) //k掉临时global
	Q ListData
}

/// CreateDate: 2017-02-27
/// Descript:   查询验证码明细
/// Table：     DHC_DisRequestCode
/// Input：     
/// Return
/// w ##class(web.DHCDISGoodsRequest).QueryCodeDetail("30","1","283")
ClassMethod QueryCodeDetail(rows As %String, page As %String, StrParam As %String)
{
	n (rows,page,StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	S QuitFlag=0
	S Num=0
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	S ReqID=$p(StrParam,"^",1)
	S TypeID=$p(StrParam,"^",2)
	
	s id=""
	f  s id=$o(^DHCDISRC(0,"TypePointer",TypeID,ReqID,id)) q:id=""  d
	.s DisRCCode=$p(^DHCDISRC(id),"^",3)
	.s DisRCCreateDate=$p(^DHCDISRC(id),"^",4)
	.s DisRCCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(DisRCCreateDate) //hxy 2017-03-29 $zd(DisRCCreateDate,3)
	.s DisRCCreateTime=$p(^DHCDISRC(id),"^",5)
	.s DisRCCreateTime=$zt(DisRCCreateTime,2)
	.s DisRCCreateUserDr=$p(^DHCDISRC(id),"^",6)
	.s DisRCCreateUser=$p(^SSU("SSUSR",DisRCCreateUserDr),"^",2)
	.s DisRCActiveFlag=$p(^DHCDISRC(id),"^",7)
	.
	.S ListData=DisRCCode_"^"_DisRCCreateDate_"^"_DisRCCreateTime_"^"_DisRCCreateUser_"^"_DisRCActiveFlag
	.S Num=Num+1
	.S ^TMP("DHCDIS","web.DHCDISGoodsRequest","QueryCodeDetail",pid,Num)=ListData
	
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCDIS","web.DHCDISGoodsRequest","QueryCodeDetail",pid,index),-1) Q:(index="")||(quitflag=1)  D //wangxuejian 2016-10-09  逆序取值
	.S mdata=^TMP("DHCDIS","web.DHCDISGoodsRequest","QueryCodeDetail",pid,index)
	.S Title="DisRCCode^DisRCCreateDate^DisRCCreateTime^DisRCCreateUser^DisRCActiveFlag"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

ClassMethod autoSaveUser(loc, reqi, itm)
{
	n (loc,reqi,itm)
	s user=0,err=0
	s lsu="" f  s lsu=$o(^DHCDISLU("0","Loc",loc,lsu)) q:(lsu="")||(user'=0)  d
	.q:$p(^DHCDISLU(lsu),"^",4)=1
	.s lsui=""  f  s lsui=$o(^DHCDISLU(lsu,"LinkItm",lsui)) q:(lsui="")||(user'=0)  d
	..s tmpitm=$p(^DHCDISLU(lsu,"LinkItm",lsui),"^",3)
	..q:itm'=tmpitm
	..s user=$p(^DHCDISLU(lsu),"^",2)
	q:user=0 0
	
	s obj=##class(User.DHCDisPeople).%New()
	s obj.DPReqType=1
	s obj.DPUserDr=##class(User.SSUser).%OpenId(user)
	s obj.DPPointer=reqi
	s sc=obj.%Save()
	If $$$ISERR(sc) s err=-2
	q err
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   直接分配配送人员
/// w ##class(web.DHCDISGoodsRequest).saveUser("73||1!!3^73||2!!^73||3!!^73||4!!^73||5!!")
ClassMethod saveUser(mainStr)
{
	n (mainStr)
	TS	
	s reqType=1
	s err=0
	f i=1:1:$l(mainStr,"^") d
	.q:err'=0
	.s str=$p(mainStr,"^",i)
	.s reqi=$p(str,"!!",1)
	.s user=$p(str,"!!",2)
	.q:+reqi=0
	.&sql(delete from DHC_DisPeople where DP_Pointer=:reqi and DP_ReqType=:reqType)
	.q:+user=0
	.s obj=##class(User.DHCDisPeople).%New()
	.s obj.DPReqType=reqType
	.s obj.DPUserDr=##class(User.SSUser).%OpenId(user)
	.s obj.DPPointer=reqi
	.s sc=obj.%Save()
	.If $$$ISERR(sc) s err=-2
	i err'=0 {
		TRollBack
		q err
	} 
	TC
	q 0
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   自动分配配送人员
ClassMethod saveDisPeople(loc, mainid)
{
	n (loc, mainid)
	s user=##class(web.DHCDISGoodsRequest).getLocDefUser(loc)
	q:user=0 0
	s dispeople=##class(User.DHCDisPeople).%New()
	s dispeople.DPReqType=1
	s dispeople.DPPointer=mainid
	s dispeople.DPUserDr=##class(User.SSUser).%OpenId(user)
	s sc=subobj.%Save()
	q:$$$ISERR(sc) -2
	q 0
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   根据科室获取默认配送人员
ClassMethod getLocDefUser(loc)
{
	n (loc)
	s usr=0
	s lu=""  f  s lu=$o(^DHCDISLU(0,"Loc",loc,lu)) q:(lu="")||(usr'=0)  d
	.s active=$p(^DHCDISLU(lu),"^",3)
	.q:active'="Y"
	.s status=$p(^DHCDISLU(lu),"^",4)
	.q:status'=1
	.s usr=$p(^DHCDISLU(lu),"^",2)
	q usr
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   获取配送下个状态
/// DO ##class(User.DHCDisStatusAdd).%BuildIndices()
/// w ##class(web.DHCDISGoodsRequest).getNextStatus(0)
ClassMethod getNextStatus(id)
{
	n (id)
	s currstatdr=0
	s:+id'=0 currstatdr=+$p(^DHCDISGRE(id),"^",10)
	s currcode=0
	s:+currstatdr'=0 currcode=$p(^DHCDISSA(currstatdr),"^",1)
	s nextcode=""
	s nextcode=$o(^DHCDISSA("0","TypeCode",1,"Y","Y",currcode))
	q:nextcode="" 0
	s next=$o(^DHCDISSA("0","TypeCode",1,"Y","Y",nextcode,""))
	q next
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   获取配送验证码
/// DO ##class(User.DHCDisRequestCode).%BuildIndices()
/// w ##class(web.DHCDISGoodsRequest).getVerfiyCode("")
ClassMethod getVerfiyCode(type)
{
	n (type)
	s text=""
	while text=""{
		s code=$r(999999)
		s code=$j(code,6)
		s code=$REPLACE(code," ",0)
		i $d(^DHCDISRC(0,"CreateDate",+$h,code))=0{
			s text=code	
		}	
	}
	q text
}

/// Creator:    zhouxin
/// CreateDate: 2017-04-14
/// Descript:   生成条码
/// DO ##class(User.DHCDisRequestCode).%BuildIndices()
/// w ##class(web.DHCDISGoodsRequest).createBarCode("")
ClassMethod createBarCode(type)
{
	n (type)
	s no=""
	s no=$i(^DHCDISBARCODE(+$h))
	s no=$tr($j(no,5)," ",0)
	s date=$tr($zd(+$h,3),"-","")
	q "DIS"_date_no_$r(99)
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   查询配送列表
/// w ##class(web.DHCDISGoodsRequest).listGoodsRequest(1,30,"15/08/2018^15/08/2018^^^^")
ClassMethod listGoodsRequest(page = 1, rows = 10, param = "")
{
	n (page,rows,param)
	s End = page*rows
	s Start=(page-1)*rows+1
	s st=$p(param,"^",1)
	s ed=$p(param,"^",2)
	s taskID=$p(param,"^",3)
	s reqLoc=+$p(param,"^",5)
	s recLoc=+$p(param,"^",4)
	s status=$p(param,"^",6)
	s st=$case(+st,0:+$h-100,:##class(web.DHCDISCommonDS).DateHtmlToLogical(st)) //$zdh(st,3)
	s ed=$case(+ed,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(ed)) //$zdh(ed,3))
	s count=0
	w "{""rows"":["
	f date=ed:-1:st d
	.s req=""
	.f  s req=$o(^DHCDISGRE("0","CreateDate",date,req)) q:req=""  d
	..q:req=0
	..s tmpReqLoc=+$p(^DHCDISGRE(req),"^",2)
	..s tmpRecLoc=+$p(^DHCDISGRE(req),"^",3)
	..s tmpStatus=$p(^DHCDISGRE(req),"^",10)
	..s tmpTaskID=$p(^DHCDISGRE(req),"^",1)
	..s tmpTypeID=+$p(^DHCDISGRE(req),"^",12)   //2017-04-22  zhaowuqiang   任务类型
	..s tmpEmFlag=$p(^DHCDISGRE(req),"^",13)    //2017-05-04  zhaowuqiang   加急标志
	..q:(reqLoc'=0)&&(reqLoc'=tmpReqLoc)
	..q:(recLoc'=0)&&(recLoc'=tmpRecLoc)
	..q:(taskID'="")&&(taskID'=tmpTaskID)
	..q:(status'="")&&(status'=tmpStatus)
	..s reqSraId=$o(^DHCDISRS(0,"TypePointer",tmpTypeID,req,""),-1)
	..s OpUserId=$p(^DHCDISRS(reqSraId),"^",6)
	..s OpUserName=$p(^SSU("SSUSR",OpUserId),"^",2)   //操作人
	..s Status=""
	..s:tmpStatus'="" Status=$p($g(^DHCDISSA(tmpStatus)),"^",2)
	..i Status'="待处理"  d
	...s DPRowid="",DisREQLocUser="",PeoplePhone="",DPPeopleDr=""  //待处理的申请单默认护工 zwq
	...f  s DPRowid=$o(^DHCDISPE("0","TypePointer",tmpTypeID,req,DPRowid)) q:DPRowid=""  d
	....s DPPeopleStatus=$p(^DHCDISPE(DPRowid),"^",4)
	....q:DPPeopleStatus=-1   //过滤掉撤销安排的人员
	....s DPPeopleDr=$p(^DHCDISPE(DPRowid),"^",3)
	....s DisREQLocUser=""
	....s:DPPeopleDr'="" DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	....s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	....s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	....
	...
	..e  d
	...s UserBack=..GetThisLocUser(tmpReqLoc)
	...i UserBack'=""  d
	....s DPPeopleDr=UserBack
	....s DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	....s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	....s PeoplePhone=""
	....s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	...e  d
	....s DPPeopleDr=""
	....s DisREQLocUser=""
	....s PeoplePhone=""
	...
    ..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	..d jsonObj.Put("REQPeople",DisREQLocUser)
	..d jsonObj.Put("REQPeopleDr",DPPeopleDr)
	..d jsonObj.Put("Phone",PeoplePhone)
	..d jsonObj.Put("REQ",req)
	..d jsonObj.Put("REQNo",tmpTaskID)
	..d jsonObj.Put("TypeID",tmpTypeID)
	..d jsonObj.Put("REQEmFlag",tmpEmFlag)
	..d jsonObj.Put("REQLoc", $p(^CTLOC(+tmpReqLoc),"^",2))
	..d jsonObj.Put("REQRecLoc",$p(^CTLOC(tmpRecLoc),"^",2))
	..d jsonObj.Put("REQExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",4))) //$zd($p(^DHCDISGRE(req),"^",4),3)
	..d jsonObj.Put("REQExeTime",$zt($p(^DHCDISGRE(req),"^",5)))
	..d jsonObj.Put("REQRemarks",$p(^DHCDISGRE(req),"^",6))
	..d jsonObj.Put("REQCreateDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",7))) //$zd($p(^DHCDISGRE(req),"^",7),3)
	..d jsonObj.Put("REQCreateTime",$zt($p(^DHCDISGRE(req),"^",8)))
	..d jsonObj.Put("REQCreateUser",$p(^SSU("SSUSR",+$p(^DHCDISGRE(req),"^",9)),"^",2))
	..d jsonObj.Put("tmpRecLoc",tmpRecLoc)
	..d jsonObj.Put("OpUserName",OpUserName)
	..i +tmpStatus'=0 d jsonObj.Put("REQCurStatus",$p($g(^DHCDISSA(tmpStatus)),"^",2))
	..w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Others:		w ##class(web.DHCDISGoodsRequest).GetThisLocUser("114")
ClassMethod GetThisLocUser(DisReqLoc)
{
	n (DisReqLoc)
	
	s LUWorkload="",UserDr="",Flag=""
	f  s LUWorkload=$o(^DHCDISLU(0,"Workload",LUWorkload))  q:(LUWorkload="")||(Flag=1)  d
	.s LocUserID=""
	.f  s LocUserID=$o(^DHCDISLU(0,"Workload",LUWorkload,LocUserID)) q:(LocUserID="")||(Flag=1)  d
	..q:LocUserID=0
	..s ReqLoc=$p(^DHCDISLU(LocUserID),"^",1)
	..q:ReqLoc'=DisReqLoc
	..s UserDr=$p(^DHCDISLU(LocUserID),"^",2)
	..s Flag=1
	
	q UserDr
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   查询配送列表明细
/// w ##class(web.DHCDISGoodsRequest).listGoodsRequestItm(1,10,161)
ClassMethod listGoodsRequestItm(page = 1, rows = 10, req)
{
	n (%session,page,rows,req)
	s End = page*rows
	s Start=(page-1)*rows+1


	s count=0
	w "{""rows"":["
	s reqi=""
	f  s reqi=$o(^DHCDISGRE(req,"ITM",reqi)) q:reqi=""  d
	.
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.s itmdr=$p(^DHCDISGRE(req,"ITM",reqi),"^",1)
	.s recloc=$p(^DHCDISGRE(req,"ITM",reqi),"^",2)
	.i recloc'=""  d
	..s LocDesc=$p(^CTLOC(recloc),"^",2)
	..s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.e  s LocDesc=""
	.s dispeo=$o(^DHCDISPE("0","TypePointer",1,req_"||"_reqi,""))
	.s username="",user=""
	.i +dispeo'=0 d
	..s user=$p(^DHCDISPE(dispeo),"^",3)
	..s username=$p(^SSU("SSUSR",user),"^",2)
	.d jsonObj.Put("ITMDR",itmdr)
	.d jsonObj.Put("RECLOCDR",recloc)
	.d jsonObj.Put("REQI",req_"||"_reqi)
	.d jsonObj.Put("ITM",$p(^DHCDISLI(itmdr),"^",2))
	.d jsonObj.Put("RECLOC",LocDesc)
	.d jsonObj.Put("QTY",$p(^DHCDISGRE(req,"ITM",reqi),"^",3))
	.d jsonObj.Put("USERID",user)
	.d jsonObj.Put("USERNAME",username)
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCDIS","web.DHCDISGoodsRequest","QueryCodeDetail",pid)
	k ^TMP("DHCDIS","web.DHCDISGoodsRequest","dealInsListData",pid)
	k ^TMP("DHCDIS","web.DHCDISGoodsRequest","SaveBarCode",1)
}

/// Descript:  配送申请单拒绝操作
/// Creator:   zhaowuqiang
/// Creadate:  2017-05-03
/// Table:     DHC_DisPeople、DHC_DisLocUser、DHC_DisGoodsRequest、DHC_DisRequestSta
/// Input:     申请单ID^配送类型^状态代码^操作人员^原因
/// Output:    return
/// Other:     w ##Class(web.DHCDISGoodsRequest).refuse()
ClassMethod refuse(reqID, type, statuscode, lgUser, reason)
{
	n (reqID,type,statuscode,lgUser,reason)
	
	s curStatusID=$p(^DHCDISGRE(reqID),"^",10)
	s curStatusCode=$p(^DHCDISSA(curStatusID),"^",1)
	q:curStatusCode'=11 "只有已安排的申请单方可进行此操作!"
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,type)
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(reqID,type,status,lgUser,reason)
	q:ret'=0 "-1^保存操作流水表失败"
	s ret=##class(web.DHCDISRequestCom).updateRequestStatus(reqID,type,status)
	q:ret'=0 "-2^更新配送配送表状态失败"
	s ret=..updatePeopleStatus(reqID,type)
	q:ret'=0 "-3^更新人员状态失败"
	
	q 0
}

ClassMethod updatePeopleStatus(reqID, type)
{
	n (reqID,type)
	
	s refuseFlag=-1,userStatus=0,ret=0
	s peopleID=""
	f  s peopleID=$o(^DHCDISPE(0,"TypePointer",type,reqID,peopleID)) q:(peopleID="")||(ret'=0)  d
	.q:peopleID=0
	.&sql(update DHC_DisPeople set DP_Status=:refuseFlag where DP_RowID=:peopleID)
	.s ret=SQLCODE
	.q:ret'=0
	.s userDr=$p(^DHCDISPE(peopleID),"^",3)
	.s locUserID=""
	.s locUserID=$o(^DHCDISLU(0,"User",userDr,locUserID))
	.&sql(update DHC_DisLocUser set LU_Status=:userStatus where LU_RowId=:locUserID)
	.s ret=SQLCODE
	.q:ret'=0
	
	q ret
}

/// Descript:	护工combobox
/// Creator:    zwq
/// CreateDate: 2017-06-20
/// Table: 		DHC_DisLocUser
/// Input:  	
/// Return：    护工ID^护工姓名
/// w ##class(web.DHCDISGoodsRequest).SelectUser()
ClassMethod SelectUser()
{
	s End = 10
	s Start=1
	s Count=0
	w "["
	s LuID=""
	f  s LuID=$o(^DHCDISLU(LuID)) q:LuID=""  d
	.q:LuID=0
	.s UserDr=$p(^DHCDISLU(LuID),"^",2)
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)
	.s DpType="",Num=0
	.f  s DpType=$o(^DHCDISPE("0","TypePointer",DpType)) q:DpType=""  d
	..s ReqID=""
	..f  s ReqID=$o(^DHCDISPE("0","TypePointer",DpType,ReqID)) q:ReqID=""  d
	...s DpID=""
	...f  s DpID=$o(^DHCDISPE("0","TypePointer",DpType,ReqID,DpID)) q:DpID=""  d
	....s DpUser=$p(^DHCDISPE(DpID),"^",3)
	....q:DpUser'=UserDr
	....s DpStatus=$p(^DHCDISPE(DpID),"^",4)
	....q:DpStatus=-1
	....q:'$d(^DHCDISGRE(ReqID))
	....s CurStatusID=$p($g(^DHCDISGRE(ReqID)),"^",10)
	....q:'$d(^DHCDISSA(CurStatusID))
	....s CurStatusCode=$p($g(^DHCDISSA(CurStatusID)),"^",1)
	....q:(CurStatusCode="完成确认")||(CurStatusCode="空趟")||(CurStatusCode="撤销安排")||(CurStatusCode="已撤销")
	....s Num=Num+1
	.s:Num'=0 UserName=UserName_"("_Num_"个)"
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",UserDr_"^"_UserName)
	w "]"
	q ""
}

/// Descript:	申请单安排护工
/// Creator:    zwq
/// CreateDate: 2017-05-31
/// Table: 		DHC_DisLocUser、DHC_DisRequest、DHC_DisPeople、DHC_DisRequestSta
/// Input:  	申请单ID,任务类型,护工ID,状态代码,操作人
/// Return：    107^14^173^11^575
/// w ##class(web.DHCDISGoodsRequest).ArrangeToo("148","15","5925","已安排","3084")
ClassMethod ArrangeToo(pointer, typeid, user, statuscode, lgUser)
{
	n (pointer,typeid,user,statuscode,lgUser)
	
	TS
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,typeid)
	i status="" tro  q "获取状态ID失败!"
	i '$d(^DHCDISPE(0,"TypePointer",typeid,pointer))  d
	.s ret=..insertDpUser(pointer, typeid, user, status, lgUser)
	e  d
	.s ret=..updateDpUser(pointer, typeid, user, status, lgUser)
	i ret'=0 TRO
	TC
	
	q ret
}

ClassMethod updateDpUser(pointer, typeid, user, status, lgUser)
{
	s DpID="",ret=0,DPstatus=0
	f  s DpID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,DpID)) q:(DpID="")||(ret'=0)  d
	.q:DpID=0
	.&SQL(update DHC_DisPeople set DP_User_Dr=:user,DP_Status=:DPstatus where DP_RowID=:DpID)
	.s ret=SQLCODE
	q:ret'=0 ret
	s ret=..AddUserWork(user)
	q:ret'=0 "更新陪送人员工作量失败!"
	s ret=..UpdateReqStatue(pointer,status,typeid)
	q:ret'=0 "更新申请主表状态失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	q:ret'=0 "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	q:ret'=0 "插入流水表失败"
	
	q ret
}

ClassMethod insertDpUser(pointer, typeid, user, status, lgUser)
{
	s DpID=0,ret=0,DPstatus=0
	f  s DpID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,DpID)) q:(DpID="")||(ret'=0)  d
	&SQL(INSERT INTO DHC_DisPeople(DP_ReqType,DP_Pointer,DP_User_Dr,DP_Status) VALUES(:typeid,:pointer,:user,:DPstatus))
	s ret=SQLCODE
	q:ret'=0 ret
	s ret=..UpdateReqStatue(pointer,status,typeid)
	q:ret'=0 "更新申请主表状态失败!"
	s ret=..AddUserWork(user)
	q:ret'=0 "更新陪送人员工作量失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	q:ret'=0 "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	q:ret'=0 "插入流水表失败"
	
	q ret
}

ClassMethod UpdateReqStatue(pointer, status, typeid)
{
	s err=0
	&sql(update DHC_DisGoodsRequest set REQ_CurStatus=:status where REQ_RowID=:pointer)
	s err=SQLCODE
	
	q err
}

ClassMethod AddUserWork(User)
{
	s LuUserID="",err=0
	f  s LuUserID=$o(^DHCDISLU(LuUserID)) q:(LuUserID="")||(err'=0)  d
	.q:LuUserID=0
	.s UserID=$p(^DHCDISLU(LuUserID),"^",2)
	.s UserWork=$p(^DHCDISLU(LuUserID),"^",5)
	.q:UserID'=User
	.s UserWork=UserWork+1
	.&sql(update DHC_DisLocUser set LU_Workload=:UserWork where LU_RowId=:LuUserID)
	.s err=SQLCODE
	
	q err
}

/// Descript:	申请单撤销安排
/// Creator:    zwq
/// CreateDate: 2017-06-20
/// Table: 		DHC_DisRequest
/// Input:  	
/// Return： 	109^14^17^575
/// Others:		w ##class(web.DHCDISGoodsRequest).CancelArrange("109","14","17","575")
ClassMethod CancelArrange(pointer, typeid, statuscode, lgUser)
{
	TS
	s status=##class(web.DHCDISRequestCom).GetStatusID(statuscode,typeid)
	i status="" tro  q "获取状态ID失败!"
	s ret=..UpdateDpPeopleStatue(pointer,typeid)
	i ret'=0 tro  q "更新陪送人员表状态失败!"
	s ret=..UpdateReqStatue(pointer,status,typeid)
	i ret'=0 tro  q "更新申请主表状态失败!"
	s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(pointer,typeid,status)
	i ret'=0 tro  q "更新人员状态失败"
	s ret=##class(web.DHCDISRequestCom).saveRequestSta(pointer,typeid,status,lgUser)
	i ret'=0 tro  q "插入流水表失败"
	TC
	
	q 0
}

ClassMethod UpdateDpPeopleStatue(pointer, typeid)
{
	s PeopleID="",CancelStatue=-1,err=0
	f  s PeopleID=$o(^DHCDISPE(0,"TypePointer",typeid,pointer,PeopleID)) q:(PeopleID="")||(err'=0)  d
	.q:PeopleID=0
	.&sql(update DHC_DisPeople set DP_Status=:CancelStatue where DP_RowID=:PeopleID)
	.s err=SQLCODE
	
	q err
}

/// Creator:    sufan 
/// CreateDate: 2018-04-08
/// Descript:   发送消息
/// Table：     
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).SenDisInfo()
ClassMethod SenDisInfo(ReqDisIdStr As %String, flag As %String = "") As %String
{
	n (ReqDisIdStr,flag)
	s Len=$l(ReqDisIdStr,"^")
	for i=1:1:Len d
	.s ReqDisID=$p(ReqDisIdStr,"^",i)					// 循环取Id
	.s ReqLocId=$p(^DHCDISGRE(ReqDisID),"^",2)			//  申请科室
	.s ReqLocDesc=""
	.i ReqLocId'=""  s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2) 
	.s RecLocId=$p(^DHCDISGRE(ReqDisID),"^",3)			//  接收科室
	.s RecLocDesc=""
	.i RecLocId'=""  s RecLocDesc=$p(^CTLOC(RecLocId),"^",2) 
	.s TypeDr=$p(^DHCDISGRE(ReqDisID),"^",12)			/// 配送类型
	.s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			/// 加急标志
	.s isRelFlag=..isLinkRel(ReqDisID)					/// 判断业务科室是否关联中转
	.i (EmFlag="Y")||(isRelFlag'="Y") d					/// 加急申请或者业务科室不管联中转站，则取直达岗
	..s UserList=..getDirectUserId(ReqDisID)
	.e  d
	..s UserList=..getDisUserId(ReqDisID,flag)					/// 护工Id
	.q:+UserList="0"
	.s Len=$l(UserList,"^")
	.for i=1:1:Len d
	.s HisUserID=$p(UserList,"^",i)
	.q:'$d(^DHCDISWEIXINUSER(0,"UserId",HisUserID))							/// 通过hisUserId取微信userID
	.s HisGroupID=$o(^DHCDISWEIXINUSER(0,"UserId",HisUserID,""))			/// 安全组ID
	.s WeixinID=$o(^DHCDISWEIXINUSER(0,"UserId",HisUserID,HisGroupID,""))	/// 微信登记ID
	.s WXUserID=$p(^DHCDISWEIXINUSER(WeixinID),"^",2)						/// 微信用户ID
	.s RemindInfo="请将物品从"_ReqLocDesc_"送到"_RecLocDesc
	.d ##class(web.DHCDISSOAP.SendMessage).SendDisMessageByUserId(WXUserID,RemindInfo)
	q 0
}

/// Creator：      sufan
/// CreatDate：    2018-04-09
/// Description：  当前位置
/// w ##class(web.DHCDISGoodsRequest).GetSchedule()
ClassMethod GetCurrLoca()
{
	s Count=0
	w "["
	s LocaID=0
	f  s LocaID=$o(^DHCDISNL(LocaID)) q:LocaID=""  d
	.s LocaDesc=$p(^DHCDISNL(LocaID),"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",LocaID_"^"_LocaDesc)
	w "]"
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-05-10
/// table:		   
/// Description：  通过护工ID取护工所在岗位
/// w ##class(web.DHCDISGoodsRequest).GetNodeByUserId()
ClassMethod GetNodeByUserId(UserID)
{
	n (UserID)
	q:UserID="" "护工ID为空"
	q:'$d(^DHCDISWLU(0,"User",UserID)) "护工无关联岗位"
	s NodeLinkId=$o(^DHCDISWLU(0,"User",UserID,""))
	s NodeId=$p(^DHCDISWLU(NodeLinkId),"^",2)		//岗位ID
	s NodeDesc=$p(^DHCDISWN(NodeId),"^",2)			//岗位描述
	q NodeDesc
}

/// Creator：      sufan
/// CreatDate：    2018-05-10
/// table:		   
/// Description：  通过护工ID取护工所在岗位的位置
/// w ##class(web.DHCDISGoodsRequest).GetNodeLocaByUserId()
ClassMethod GetNodeLocaByUserId(UserID)
{
	n (UserID)
	q:UserID="" "护工ID为空"
	q:'$d(^DHCDISWLU(0,"User",UserID)) "护工无关联岗位"
	s NodeLinkId=$o(^DHCDISWLU(0,"User",UserID,""))
	s NodeId=$p(^DHCDISWLU(NodeLinkId),"^",2)		//岗位ID
	q:'$d(^DHCDISWN(NodeId,"I",NodeId)) "护工所在岗位没有维护位置信息"
	s CH=$o(^DHCDISWN(NodeId,"I",""))			    //位置Childsub
	s Location=$p(^DHCDISWN(NodeId,"I",CH),"^",1)   //位置ID
	s LocaFlag=$p(^DHCDISWN(NodeId,"I",CH),"^",2)	//位置标识0:中转站;1:科室
	s LocDesc=$s(LocaFlag=0:$p(^DHCDISNL(Location),"^",2),LocaFlag=1:$p(^CTLOC(Location),"^",2),1:"")
	q LocDesc_"^"_LocaFlag
}

/// Creator：      sufan
/// CreatDate：    2018-05-11
/// table:
/// Description:   护工任务确认
/// w ##class(web.DHCDISGoodsRequest).DisTaskConfirm("38^1^102^359^N^^6^1^1006")
ClassMethod DisTaskConfirm(ListData)
{
	n (ListData)
	s Len=$l(ListData,"&&")
	s ret=0
	for i=1:1:Len  q:ret'=0  d
	.s TempStr=$p(ListData,"&&",i)
	.s pointer=$p(TempStr,"^",1)		//申请单Id
	.s type=$p(TempStr,"^",2)			//申请类型
	.s statuscode=$p(TempStr,"^",3)		//状态代码
	.s lgUser=$p(TempStr,"^",4)			//操作者
	.s EmFlag=$p(TempStr,"^",5)			//加急标志
	.s flag=""							//标识保存或者更新
	.s reason=$p(TempStr,"^",6)			//原因
	.s Relation=$p(TempStr,"^",7)		//当前位置ID
	.s RelaFlag=$p(TempStr,"^",8)		//位置标识
	.s DisUserID=$p(TempStr,"^",9)		//确人护工
    .s ret=..updateStatus(pointer, type, statuscode, lgUser, EmFlag, flag , reason , Relation , RelaFlag ,DisUserID)
    .q:ret'=0
    q ret
}

/// Creator：      sufan
/// CreatDate：    2018-05-11
/// table:		   
/// Description：  更新流水表和人员状态，确认完成时需要选择最后送达的护工[电脑端，微信端在扫码时已经确定]
/// w ##class(web.DHCDISGoodsRequest).updateStatus()
ClassMethod updateStatus(pointer, type, statuscode, lgUser, EmFlag, flag = "", reason = "", Relation = "", RelaFlag = "", DisUserID = "")
{
	n (pointer,type,statuscode,lgUser,reason,EmFlag,flag,Relation, RelaFlag,DisUserID)
	s ret=0
	s ret=##class(web.DHCDISRequestCom).updateStatus(pointer,type,statuscode,lgUser,reason,EmFlag,flag,Relation, RelaFlag)
	//s ret=..UpdDisPeople(pointer,type,DisUserID)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2018-05-11
/// table:		   DHC_DisPeople
/// Description：  插入最后送达的护工的信息
/// w ##class(web.DHCDISGoodsRequest).UpdDisPeople(42,1,21)
ClassMethod UpdDisPeople(pointer, type, userId)
{
	n (pointer, type,userId)
	b   //11
	s ret=0
	/*s status=-1
	&sql(update DHC_DisPeople set DP_Status=:status where DP_Pointer=:pointer and DP_ReqType=:type)
	s ret=SQLCODE
	q:ret'=0 ret
	s status=""*/
	q:$d(^DHCDISPE("0","TypePointer",type,pointer)) 0   ///已保存的不需要再次保存
	&sql(insert into  DHC_DisPeople (DP_ReqType,DP_Pointer,DP_User_Dr,DP_Status) values(:type,:pointer,:userId,:status))
	s ret=SQLCODE
	q:ret'=0 ret
	q 0
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   查询配送列表
/// w ##class(web.DHCDISGoodsRequest).QueryDisList(1,30,"")
ClassMethod QueryDisList(page = 1, rows = 10, params = "")
{
	n (page,rows,params)
	s ^temptest("11")=params
	s End = page*rows
	s Start=(page-1)*rows+1
	s count=0
	w "{""rows"":["
	s ReqdisCode=""
	i $d(^TMP("DHCDIS","web.DHCDISGoodsRequest","SaveBarCode"))  d
	.f  s ReqdisCode=$o(^TMP("DHCDIS","web.DHCDISGoodsRequest","SaveBarCode",1,ReqdisCode)) q:ReqdisCode=""  d
	..b   //ReqdisCode
	..i ReqdisCode'["DIS" d
	...q:'$d(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqdisCode,1,11)))
	...s ReqDisId=$o(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqdisCode,1,11),""))
	...s ReqdisCode=$p(^DHCDISGRE(ReqDisId),"^",11)    //配送码 
	...s req=""
	...s req=$o(^DHCDISGRE(0,"BarCode",ReqdisCode,req))
	...q:req=0
	...s tmpReqLoc=+$p(^DHCDISGRE(req),"^",2)
	...s tmpRecLoc=+$p(^DHCDISGRE(req),"^",3)
	...s tmpStatus=$p(^DHCDISGRE(req),"^",10)
	...s tmpTaskID=$p(^DHCDISGRE(req),"^",1)
	...s tmpTypeID=+$p(^DHCDISGRE(req),"^",12)   //2017-04-22  zhaowuqiang   任务类型
	...s tmpEmFlag=$p(^DHCDISGRE(req),"^",13)    //2017-05-04  zhaowuqiang   加急标志
	...s reqSraId=$o(^DHCDISRS(0,"TypePointer",tmpTypeID,req,""),-1)
	...s OpUserId=$p(^DHCDISRS(reqSraId),"^",6)
	...s OpUserName=""
	...i OpUserId'="" s OpUserName=$p(^SSU("SSUSR",OpUserId),"^",2)   //操作人
	...s ExeDate=$p(^DHCDISRS(reqSraId),"^",4)						//更新日期
	...s ExeTime=$p(^DHCDISRS(reqSraId),"^",5)						//更新时间
	...s Status=""	
	...s:tmpStatus'="" Status=$p($g(^DHCDISSA(tmpStatus)),"^",2)
	...;b 
	...;q:Status'="102"
	...i Status'="申请"  d
	....s DPRowid="",DisREQLocUser="",PeoplePhone="",DPPeopleDr=""  //待处理的申请单默认护工 zwq
	....f  s DPRowid=$o(^DHCDISPE("0","TypePointer",tmpTypeID,req,DPRowid)) q:DPRowid=""  d
	.....s DPPeopleStatus=$p(^DHCDISPE(DPRowid),"^",4)
	.....q:DPPeopleStatus=-1   //过滤掉撤销安排的人员
	.....s DPPeopleDr=$p(^DHCDISPE(DPRowid),"^",3)
	.....s DisREQLocUser=""
	.....s:DPPeopleDr'="" DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	.....s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	.....s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	...e  d
	....s UserBack=..GetThisLocUser(tmpReqLoc)
	....i UserBack'=""  d
	.....s DPPeopleDr=UserBack
	.....s DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	.....s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	.....s PeoplePhone=""
	.....s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	....e  d
	.....s DPPeopleDr=""
	.....s DisREQLocUser=""
	.....s PeoplePhone=""
	...
    ...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...s jsonObj=##class(web.DHCAPPJsonObject).%New()
	...d jsonObj.Put("REQPeople",DisREQLocUser)
	...d jsonObj.Put("REQPeopleDr",DPPeopleDr)
	...d jsonObj.Put("Phone",PeoplePhone)
	...d jsonObj.Put("REQ",req)
	...d jsonObj.Put("REQNo",tmpTaskID)
	...d jsonObj.Put("TypeID",tmpTypeID)
	...d jsonObj.Put("REQEmFlag",tmpEmFlag)
	...d jsonObj.Put("REQLoc", $p(^CTLOC(+tmpReqLoc),"^",2))
	...d jsonObj.Put("REQRecLoc",$p(^CTLOC(tmpRecLoc),"^",2))
	...d jsonObj.Put("REQExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",4))) //$zd($p(^DHCDISGRE(req),"^",4),3)
	...d jsonObj.Put("REQExeTime",$zt($p(^DHCDISGRE(req),"^",5)))
	...d jsonObj.Put("REQRemarks",$p(^DHCDISGRE(req),"^",6))
	...d jsonObj.Put("REQCreateDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",7))) //$zd($p(^DHCDISGRE(req),"^",7),3)
	...d jsonObj.Put("REQCreateTime",$zt($p(^DHCDISGRE(req),"^",8)))
	...d jsonObj.Put("REQCreateUser",$p(^SSU("SSUSR",+$p(^DHCDISGRE(req),"^",9)),"^",2))
	...d jsonObj.Put("tmpRecLoc",tmpRecLoc)
	...d jsonObj.Put("OpUserName",OpUserName)
	...d jsonObj.Put("ExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml(ExeDate))
	...d jsonObj.Put("ExeTime",$zt(ExeTime,1))
	...i +tmpStatus'=0 d jsonObj.Put("REQCurStatus",$p($g(^DHCDISSA(tmpStatus)),"^",2))
	...w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

ClassMethod getDisLabel(page = 1, rows = 10, params = "")
{
	n (page,rows,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s ReqdisCode=params
	s BarCode="" 
	i ReqdisCode'["DIS" d
	.q:'$d(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqdisCode,1,11)))
	.s ReqDisId=$o(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqdisCode,1,11),""))
	.s ReqdisCode=$p(^DHCDISGRE(ReqDisId),"^",11)    //配送码 
	s count=0
	w "{""rows"":["
	s req=""
	f  s req=$o(^DHCDISGRE(0,"BarCode",ReqdisCode,req)) q:req=""  d
	.q:req=0
	.s tmpReqLoc=+$p(^DHCDISGRE(req),"^",2)
	.s tmpRecLoc=+$p(^DHCDISGRE(req),"^",3)
	.s tmpStatus=$p(^DHCDISGRE(req),"^",10)
	.s tmpTaskID=$p(^DHCDISGRE(req),"^",1)
	.s tmpTypeID=+$p(^DHCDISGRE(req),"^",12)   //2017-04-22  zhaowuqiang   任务类型
	.s tmpEmFlag=$p(^DHCDISGRE(req),"^",13)    //2017-05-04  zhaowuqiang   加急标志
	.s reqSraId=$o(^DHCDISRS(0,"TypePointer",tmpTypeID,req,""),-1)
	.s OpUserId=$p(^DHCDISRS(reqSraId),"^",6)
	.s OpUserName=""
	.i OpUserId'="" s OpUserName=$p(^SSU("SSUSR",OpUserId),"^",2)   //操作人
	.s ExeDate=$p(^DHCDISRS(reqSraId),"^",4)						//更新日期
	.s ExeTime=$p(^DHCDISRS(reqSraId),"^",5)						//更新时间
	.s Status=""	
	.s:tmpStatus'="" Status=$p($g(^DHCDISSA(tmpStatus)),"^",2)
	.i Status'="申请"  d
	..s DPRowid="",DisREQLocUser="",PeoplePhone="",DPPeopleDr=""  //待处理的申请单默认护工 zwq
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",tmpTypeID,req,DPRowid)) q:DPRowid=""  d
	...s DPPeopleStatus=$p(^DHCDISPE(DPRowid),"^",4)
	...q:DPPeopleStatus=-1   //过滤掉撤销安排的人员
	...s DPPeopleDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s DisREQLocUser=""
	...s:DPPeopleDr'="" DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	...s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	...s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	.e  d
	..s UserBack=..GetThisLocUser(tmpReqLoc)
	..i UserBack'=""  d
	...s DPPeopleDr=UserBack
	...s DisREQLocUser=$p(^SSU("SSUSR",DPPeopleDr),"^",2)  //陪送人员
	...s CareProvDR=$p(^SSU("SSUSR",DPPeopleDr),"^",14)
	...s PeoplePhone=""
	...s:CareProvDR'="" PeoplePhone=$p(^CTPCP(CareProvDR,3),"^",6)      //陪送人员电话
	..e  d
	...s DPPeopleDr=""
	...s DisREQLocUser=""
	...s PeoplePhone=""
	..
    .s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.d jsonObj.Put("REQPeople",DisREQLocUser)
	.d jsonObj.Put("REQPeopleDr",DPPeopleDr)
	.d jsonObj.Put("Phone",PeoplePhone)
	.d jsonObj.Put("REQ",req)
	.d jsonObj.Put("REQNo",tmpTaskID)
	.d jsonObj.Put("TypeID",tmpTypeID)
	.d jsonObj.Put("REQEmFlag",tmpEmFlag)
	.d jsonObj.Put("REQLoc", $p(^CTLOC(+tmpReqLoc),"^",2))
	.d jsonObj.Put("REQRecLoc",$p(^CTLOC(tmpRecLoc),"^",2))
	.d jsonObj.Put("REQExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",4))) //$zd($p(^DHCDISGRE(req),"^",4),3)
	.d jsonObj.Put("REQExeTime",$zt($p(^DHCDISGRE(req),"^",5)))
	.d jsonObj.Put("REQRemarks",$p(^DHCDISGRE(req),"^",6))
	.d jsonObj.Put("REQCreateDate",##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISGRE(req),"^",7))) //$zd($p(^DHCDISGRE(req),"^",7),3)
	.d jsonObj.Put("REQCreateTime",$zt($p(^DHCDISGRE(req),"^",8)))
	.d jsonObj.Put("REQCreateUser",$p(^SSU("SSUSR",+$p(^DHCDISGRE(req),"^",9)),"^",2))
	.d jsonObj.Put("tmpRecLoc",tmpRecLoc)
	.d jsonObj.Put("OpUserName",OpUserName)
	.d jsonObj.Put("ExeDate",##class(web.DHCDISCommonDS).DateLogicalToHtml(ExeDate))
	.d jsonObj.Put("ExeTime",$zt(ExeTime,1))
	.i +tmpStatus'=0 d jsonObj.Put("REQCurStatus",$p($g(^DHCDISSA(tmpStatus)),"^",2))
	.w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript：查询之前校验物品是否已签收，物品码是否合理
/// Input:    物品条码
/// w ##class(web.DHCDISGoodsRequest).CheckReqBarCode("DIS201808150000381")
ClassMethod CheckReqBarCode(ReqDisCode)
{
	n (ReqDisCode)
	q:ReqDisCode="" -1
	s ReqDisId=""
	i ReqDisCode["DIS" d
	.q:'$d(^DHCDISGRE(0,"BarCode",ReqDisCode))
	.s ReqDisId=$o(^DHCDISGRE(0,"BarCode",ReqDisCode,ReqDisId))
	e  d
	.q:'$d(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqDisCode,1,11)))
	.s ReqDisId=$o(^DHCDISGRE(0,"ExtBarCode","ZX"_$E(ReqDisCode,1,11),ReqDisId))
	q:ReqDisId="" "-5"
	s Status=$p(^DHCDISGRE(ReqDisId),"^",10)       //状态ID
	s StaText=$p(^DHCDISSA(Status),"^",2)		   //状态描述
	q:StaText="申请" "-3"
	q:StaText="确认完成" "-4"
	q 0
}

/// Descript：查询操作人员名称
/// Input:    护工条码标
ClassMethod getExeUser(userLoginID)
{
	n (userLoginID)
	q:'$d(^SSU("SSUSR",0,"SSUSR_LoginID",$$ALPHAUP^SSUTIL4(userLoginID))) "-1"
	s userID=$o(^SSU("SSUSR",0,"SSUSR_LoginID",$$ALPHAUP^SSUTIL4(userLoginID),""))
	s userName=$p(^SSU("SSUSR",userID),"^",2)        //操作人员姓名
	q userID_"^"_userName
}

/// Descript：提供给药房接口[撤销申请时，同时撤销配送申请]
/// Input:	 药箱条码
/// Others:  w ##class(web.DHCDISGoodsRequest).RevDisReq("ZX20180817078","5943")
ClassMethod RevDisReq(PHboxCode, UserId)
{
	n (PHboxCode,UserId)
	q:PHboxCode="" -1
	s DisReqId=+$o(^DHCDISGRE(0,"ExtBarCode",PHboxCode,""))
	q:DisReqId=0 -2
	s CurStatusId=$p(^DHCDISGRE(DisReqId),"^",10)    //状态ID
	s CurStaCode=$p(^DHCDISSA(CurStatusId),"^",1)    //状态Code
	s typeId=$p(^DHCDISGRE(DisReqId),"^",12)		 //任务类型
	q:CurStaCode="102" -3    						 //护工已接收，不能撤销
	q:CurStaCode="104" -4   						 //任务已完成
	d ##Class(web.DHCDISRequestCom).CancelApplicaion(DisReqId,"105",typeId,UserId)
	q 0
}

ClassMethod SaveBarCode(pid, BarCode)
{
	n (pid,BarCode)
	s ^TMP("DHCDIS","web.DHCDISGoodsRequest","SaveBarCode",pid,BarCode)=BarCode
}

/// Creator:    sufan 
/// CreateDate: 2018-08-27
/// Descript:   发送消息
/// Table：     
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).SenDisInfoNew(550,1)
ClassMethod SenDisInfoNew(ReqDisIdStr As %String, flag As %String = "") As %String
{
	n (ReqDisIdStr,flag)
	s Len=$l(ReqDisIdStr,"^")
	for i=1:1:Len d
	.s ReqDisID=$p(ReqDisIdStr,"^",i)					// 循环取Id
	.s ReqLocId=$p(^DHCDISGRE(ReqDisID),"^",2)			//  申请科室
	.s ReqLocDesc=""
	.i ReqLocId'=""  s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2) 
	.s RecLocId=$p(^DHCDISGRE(ReqDisID),"^",3)			//  接收科室
	.s RecLocDesc=""
	.i RecLocId'=""  s RecLocDesc=$p(^CTLOC(RecLocId),"^",2) 
	.s TypeDr=$p(^DHCDISGRE(ReqDisID),"^",12)			/// 配送类型
	.s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			/// 加急标志
	.s UserList=..getDisUserIdNew(ReqDisID,flag)		/// 护工Id
	.b    //UserList
	.i +UserList=0   d			/// 给管理岗发消息
	..s retStr=..getManageUserId()
	..s UserId=$p(retStr,"^",1)
	..q:UserId=""
	..;s NodeDesc=$p(retStr,"^",2)
	..q:'$d(^DHCDISWEIXINUSER(0,"UserId",UserId))							/// 通过hisUserId取微信userID
	..s HisGroupID=$o(^DHCDISWEIXINUSER(0,"UserId",UserId,""))			/// 安全组ID
	..s WeixinID=$o(^DHCDISWEIXINUSER(0,"UserId",UserId,HisGroupID,""))	/// 微信登记ID
	..s WXUserID=$p(^DHCDISWEIXINUSER(WeixinID),"^",2)						/// 微信用户ID
	..;s RemindInfo="请将物品从"_ReqLocDesc_"送到"_RecLocDesc
	..s RemindInfo="无人上岗，请尽快安排！"
	..d ##class(web.DHCDISSOAP.SendMessage).SendDisMessageByUserId(WXUserID,RemindInfo)
	.e  d						/// 正常护工发消息
	..s Len=$l(UserList,"^")
	..for i=1:1:Len d
	..s HisUserID=$p(UserList,"^",i)
	..q:'$d(^DHCDISWEIXINUSER(0,"UserId",HisUserID))							/// 通过hisUserId取微信userID
	..s HisGroupID=$o(^DHCDISWEIXINUSER(0,"UserId",HisUserID,""))			/// 安全组ID
	..s WeixinID=$o(^DHCDISWEIXINUSER(0,"UserId",HisUserID,HisGroupID,""))	/// 微信登记ID
	..s WXUserID=$p(^DHCDISWEIXINUSER(WeixinID),"^",2)						/// 微信用户ID
	..s RemindInfo="请将物品从"_ReqLocDesc_"送到"_RecLocDesc
	..d ##class(web.DHCDISSOAP.SendMessage).SendDisMessageByUserId(WXUserID,RemindInfo)
	q 0
}

/// Creator:    sufan 
/// CreateDate: 2018-08-27
/// Descript:   插入配送护工人员
/// Table：     DHC_DisScheduleType,DHC_DisSchedule
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).getDisUserIdNew("550",1)
ClassMethod getDisUserIdNew(ReqDisID As %String, flag As %String) As %String
{
	n (ReqDisID,flag)
	s UserIdList=""
	s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			/// 加急标志
	s TypeDr=$p(^DHCDISGRE(ReqDisID),"^",12)			/// 配送类型
	s RecLocDr=$p(^DHCDISGRE(ReqDisID),"^",3)   		/// 接收科室
	s RepLocDr=$p(^DHCDISGRE(ReqDisID),"^",2)   		/// 申请科室
	s GroLocId=""  										/// 科室服务组Id
	for  s GroLocId=$o(^DHCDISSGLL(0,"Loc",RecLocDr,GroLocId)) q:GroLocId=""  d   //DHCDisSerGroLinkLoc
	.s GroupId=$p(^DHCDISSGLL(GroLocId),"^",1)			/// 服务组Id
	.s NodeGroId=""
	.for  s NodeGroId=$o(^DHCDISWNLG(0,"SerGro",GroupId,NodeGroId))  q:NodeGroId=""  d  //DHCDisWorkNodeLinkGroup
	..s NodeId=$p(^DHCDISWNLG(NodeGroId),"^",2)				/// 岗位Id	
	..q:..isHavePermisson(NodeId,TypeDr)'="1"				/// 先判断有没有权限
	..s RetFlag=..isScheReasonable(ReqDisID,NodeId,TypeDr)	/// 判断排班
	..q:$p(RetFlag,"^",1)'="1"
	..s UnsRowId=""
	..for  s UnsRowId=$o(^DHCDISUNS(0,"SchDateStatus",NodeId,UnsRowId)) q:UnsRowId=""  d			/// DHC_DisUserNodeSel
	...s status=$p(^DHCDISUNS(UnsRowId),"^",8)
	...q:status'="Y"
	...s UserId=$p(^DHCDISUNS(UnsRowId),"^",2)				/// UserId
	...i UserIdList="" s UserIdList=UserId
	...e  s UserIdList=UserIdList_"^"_UserId
	q UserIdList
}

/// Creator:    sufan 
/// CreateDate: 2018-08-27
/// Descript:   取管理岗人员,操作步骤(1.新建一个管理服务组,服务组关联的科室为'后勤管理配送组'.2.岗位和服务关联组关联.
/// 3.按照岗位配班取岗位人员.4.管理岗可以不维护配送权限 因此，此处科室写死，后勤管理配送组=77)
/// Table：     
/// Return:		申请单ID
/// w ##class(web.DHCDISGoodsRequest).getManageUserId()
ClassMethod getManageUserId()
{
	s RecLocDr="77",UserIdList="",NodeDesc="",GroLocId=""
	for  s GroLocId=$o(^DHCDISSGLL(0,"Loc",RecLocDr,GroLocId)) q:GroLocId=""  d   //DHCDisSerGroLinkLoc
	.s GroupId=$p(^DHCDISSGLL(GroLocId),"^",1)			/// 服务组Id
	.s NodeGroId=""
	.for  s NodeGroId=$o(^DHCDISWNLG(0,"SerGro",GroupId,NodeGroId))  q:NodeGroId=""  d  //DHCDisWorkNodeLinkGroup
	..s NodeId=$p(^DHCDISWNLG(NodeGroId),"^",2)				/// 岗位Id
	..;q:..isHavePermisson(NodeId,TypeDr)'="1"				/// 先判断有没有权限  
	..s RetFlag=..isJurManageNode(NodeId)	/// 判断排班
	..q:$p(RetFlag,"^",1)'="1"
	..s UnsRowId=""
	..for  s UnsRowId=$o(^DHCDISUNS(0,"SchDateStatus",NodeId,UnsRowId)) q:UnsRowId=""  d			/// DHC_DisUserNodeSel
	...s status=$p(^DHCDISUNS(UnsRowId),"^",8)
	...q:status'="Y"
	...s UserId=$p(^DHCDISUNS(UnsRowId),"^",2)				/// UserId
	...i UserIdList="" s UserIdList=UserId
	...e  s UserIdList=UserIdList_"^"_UserId
	q UserIdList
}

/// 判断管理岗是否有排班
/// w ##class(web.DHCDISGoodsRequest).isJurManageNode()
ClassMethod isJurManageNode(NodeId)
{
	n (NodeId)
	q:NodeId="" "此岗位岗位不存在"
	q:'$d(^DHCDISSCH(0,"Nodepoint",NodeId)) "0_此岗位没有排班"
	s SchRowId="",FlagCode="",DisShift=""
	for  s SchRowId=$o(^DHCDISSCH(0,"Nodepoint",NodeId,SchRowId)) 	q:(SchRowId="")||(FlagCode="1")  d
	.s SchTypeId=$p(^DHCDISSCH(SchRowId),"^",1)		/// 排班班次Id
	.s SchStDate=$p(^DHCDISSCHT(SchTypeId),"^",5)	/// 班次开始日期
	.s SchStTime=$p(^DHCDISSCHT(SchTypeId),"^",6)	/// 班次开始时间
	.s SchEndDate=$p(^DHCDISSCHT(SchTypeId),"^",3)	/// 班次结束日期
	.s SchEndTime=$p(^DHCDISSCHT(SchTypeId),"^",4)	/// 班次结束时间
	.q:(SchStDate'="")&&(SchStDate>+$H)				/// 配送日期是否在开始日期范围之内
	.q:(SchEndDate'="")&&(SchEndDate<+$H)			/// 配送日期是否大于结束日期
	.s SchStTime=$zth(SchStTime_":"_"00",1)			/// 转换排班时间
	.s SchEndTime=$zth(SchEndTime_":"_"00",1)
	.q:(SchStTime'="")&&(SchStTime>$p($h,",",2))			/// 配送时间是否在开始时间范围之内
	.q:(SchEndTime'="")&&(SchEndTime<$p($h,",",2))		/// 配送时间是否大于结束时间
	.s FlagCode="1"
	.s DisShift=SchRowId
	s FlagList=FlagCode_"^"_DisShift
	q FlagList
}

/// 取有排班，但没有上岗的岗位信息
ClassMethod getNotlaidNode()
{
}

/// 扫描多条，扫码确认报错
/// w ##class(web.DHCDISGoodsRequest).dellDHCDistribution("^CODE_128,201808290011^CODE_128,201808290101,12229,7")
ClassMethod dellDHCDistribution(ListData)
{
	n (ListData)
	s retStr="",CoderetStr="",DisretStr=""
	s Len=$l(ListData,"^")
	s retStr=$p(ListData,"^",Len)
	if Len>2  d
	.f i=2:1:Len-1 d
	..s CodeStr=$p(ListData,"^",i)
	..s CoderetStr="^"_CodeStr_","_$p(retStr,",",3,4)
	..i DisretStr="" s DisretStr=CoderetStr
	..e  s DisretStr=DisretStr_"$"_CoderetStr
	..s DisretStr=DisretStr_"$"_"^"_retStr
	e  s DisretStr=retStr
	q DisretStr
}

/// 判断该任务是否是登录岗位的
/// w ##class(web.DHCDISGoodsRequest).isWorkMatchNode(4892,553)
ClassMethod isWorkMatchNode(userId, RepDisId)
{
	n (userId,RepDisId)
	s RecLoc=$p(^DHCDISGRE(RepDisId),"^",3)    		 ///接收科室
	s ReqDisType=$p(^DHCDISGRE(RepDisId),"^",12) 	 ///任务类型
	s NodeSelId="",QuitFlag=0									 //DHCDisUserNodeSel
	for  s NodeSelId=$o(^DHCDISUNS(0,"DateUser",+$h,userId,NodeSelId))	q:(NodeSelId="")||(QuitFlag=1)  d
	.s NodeId=$p(^DHCDISUNS(NodeSelId),"^",1)        ///岗位
	.s ScheId=$p(^DHCDISUNS(NodeSelId),"^",3)		 ///班次Id
	.s NodeTypeId=""
	.for  s NodeTypeId=$o(^DHCDISWNT(0,"Node",NodeId,NodeTypeId))	q:NodeTypeId=""  d   //DHCDisWorkNodeType
	..s TypeId=$p(^DHCDISWNT(NodeTypeId),"^",1)     ///类型Id
	..q:TypeId'=ReqDisType
	..s LocList=..getCtLocIdstr(NodeId)
	..b   //LocList
	..q:LocList'[RecLoc
	..s QuitFlag=1
	q QuitFlag
}

/// 取岗位下所有服务组关联的科室串
/// Input:岗位Id
ClassMethod getCtLocIdstr(NodeId)
{
	n (NodeId)
	s CtLocList=""
	s NodeGroId=""
	for  s NodeGroId=$o(^DHCDISWNLG(0,"Node",NodeId,NodeGroId))  q:NodeGroId=""  d		///DHCDisWorkNodeLinkGroup
	.s GroupId=$p(^DHCDISWNLG(NodeGroId),"^",1)     ///服务组Id
	.s LocId=""
	.for  s LocId=$o(^DHCDISSGLL(0,"SGLoc",GroupId,LocId))  q:LocId=""  d
	..i CtLocList="" s CtLocList=LocId
	..e  s CtLocList=CtLocList_"^"_LocId
	q CtLocList
}

/// 判断是否是当前班次的任务
ClassMethod isWorkMatchSchel(userId, RepDisId)
{
	n (userId,RepDisId)
	s QuitFlag=0
	s reqDate=$p(^DHCDISGRE(RepDisId),"^",7)
	s reqTime=$p(^DHCDISGRE(RepDisId),"^",8)    	 ///接收科室
	s ReqDisType=$p(^DHCDISGRE(RepDisId),"^",12) 	 ///任务类型
	s NodeSelId="",QuitFlag=0									 //DHCDisUserNodeSel
	for  s NodeSelId=$o(^DHCDISUNS(0,"DateUser",+$h,userId,NodeSelId))	q:(NodeSelId="")||(QuitFlag=1)  d
	.s NodeId=$p(^DHCDISUNS(NodeSelId),"^",1)        ///岗位
	.s ScheId=$p(^DHCDISUNS(NodeSelId),"^",3)		 ///班次Id
	.s NodeTypeId=""
	.for  s NodeTypeId=$o(^DHCDISWNT(0,"Node",NodeId,NodeTypeId))	q:NodeTypeId=""  d   //DHCDisWorkNodeType
	..s TypeId=$p(^DHCDISWNT(NodeTypeId),"^",1)     ///类型Id
	..q:TypeId'=ReqDisType
	..s SchStDate=$p(^DHCDISSCHT(ScheId),"^",5)			/// 班次开始日期
	..s SchStTime=$p(^DHCDISSCHT(ScheId),"^",6)			/// 班次开始时间
	..s SchEndDate=$p(^DHCDISSCHT(ScheId),"^",3)		/// 班次结束日期
	..s SchEndTime=$p(^DHCDISSCHT(ScheId),"^",4)		/// 班次结束时间
	..q:(SchStDate'="")&&(SchStDate>reqDate)			/// 配送日期是否在开始日期范围之内
	..q:(SchEndDate'="")&&(SchEndDate<reqDate)			/// 配送日期是否大于结束日期
	..s SchStTime=$zth(SchStTime_":"_"00",1)			/// 转换排班时间
	..s SchEndTime=$zth(SchEndTime_":"_"00",1)
	..q:(SchStTime'="")&&(SchStTime>reqTime)			/// 配送时间是否在开始时间范围之内
	..q:(SchEndTime'="")&&(SchEndTime<reqTime)			/// 配送时间是否大于结束时间
	..s QuitFlag=1
	q QuitFlag
}

/// 判断登录岗位个服务组的关联关系
/// Input:UserId
/// 申请单Id
/// w ##class(web.DHCDISGoodsRequest).IsMatchNode()
ClassMethod IsMatchNode(NodeId)
{
	n (NodeId)
	q:NodeId="" "此岗位岗位不存在"
	q:'$d(^DHCDISSCH(0,"Nodepoint",NodeId)) "0_此岗位没有排班"
	s SchRowId="",FlagCode="",DisShift=""
	for  s SchRowId=$o(^DHCDISSCH(0,"Nodepoint",NodeId,SchRowId)) 	q:(SchRowId="")||(FlagCode="1")  d
	.s SchTypeId=$p(^DHCDISSCH(SchRowId),"^",1)		/// 排班班次Id
	.s SchStDate=$p(^DHCDISSCHT(SchTypeId),"^",5)	/// 班次开始日期
	.s SchStTime=$p(^DHCDISSCHT(SchTypeId),"^",6)	/// 班次开始时间
	.s SchEndDate=$p(^DHCDISSCHT(SchTypeId),"^",3)	/// 班次结束日期
	.s SchEndTime=$p(^DHCDISSCHT(SchTypeId),"^",4)	/// 班次结束时间
	.s dateFlag=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate($zd(+$h,3),"","")
	.s nodeType=$p(^DHCDISSCH(SchTypeId),"^",2)
	.s lastNodeType=$p(^DHCDISSCHT(nodeType),"^",7)
	.s lastNodeTypeDesc=$p(^DHCDISSCHT(lastNodeType),"^",2)
	.q:(dateFlag=2)&&(lastNodeTypeDesc'="假日班") //"-1^请选假日班"
	.q:(dateFlag=1)&&(lastNodeTypeDesc'="周末班") //"-1^请选周末班"
	.q:(dateFlag=0)&&(lastNodeTypeDesc'="正常班") //"-1^请选正常班"
	.q:(SchStDate'="")&&(SchStDate>+$H)				/// 配送日期是否在开始日期范围之内
	.q:(SchEndDate'="")&&(SchEndDate<+$H)			/// 配送日期是否大于结束日期
	.s SchStTime=$zth(SchStTime_":"_"00",1)			/// 转换排班时间
	.s SchEndTime=$zth(SchEndTime_":"_"00",1)
	.q:(SchStTime'="")&&(SchStTime>$p($h,",",2))		/// 配送时间是否在开始时间范围之内
	.q:(SchEndTime'="")&&(SchEndTime<$p($h,",",2))		/// 配送时间是否大于结束时间
	.s FlagCode="1"
	q FlagCode
}

/// Creator:    sufan 
/// CreateDate: 2018-09-04
/// Descript:   药房护士接收药品时，更新申请表ID(提供给药房)
/// W ##Class(web.DHCDISGoodsRequest).UpdReqStatus("20180903066","")
ClassMethod UpdReqStatus(PhBoxCode As %String, UserId As %String, flag As %String = "") As %String
{
	n (PhBoxCode,UserId,flag)
	s ReqDisID=$o(^DHCDISGRE(0,"ExtBarCode","ZX"_$e(PhBoxCode,1,11),""))
	s CreatUser=UserId									// 接收人
	s ReqType=$p(^DHCDISGRE(ReqDisID),"^",12)   		// 配送类型
	s EmFlag=$p(^DHCDISGRE(ReqDisID),"^",13)			// 加急标志
	s Relation=$p(^DHCDISGRE(ReqDisID),"^",14)			// 当前位置
	s RelaFlag=$p(^DHCDISGRE(ReqDisID),"^",15)			// 当前位置标识
	s nextState=##class(web.DHCDISRequestCom).getNextStatus(ReqDisID,ReqType,EmFlag,flag)
 	q:nextState="" -1
 	s nexStatusCode=$p(^DHCDISSA(nextState),"^",1)
	s ret=##class(web.DHCDISRequestCom).updateStatus(ReqDisID,ReqType,nexStatusCode,CreatUser,EmFlag,flag,"",Relation,RelaFlag)
 	q ret
}

/// 调药房接口，扫码时存入接收人信息
/// w ##Class(web.DHCDISGoodsRequest).InsertRecInfoToPha("20180903066","4892")
ClassMethod InsertRecInfoToPha(PhBoxCode, UserId)
{
	n (PhBoxCode,UserId)
	s ret=0
	s ReqDisID=$o(^DHCDISGRE(0,"ExtBarCode","ZX"_PhBoxCode,""))    /// 申请单Id
	s CurStatus=$p(^DHCDISGRE(ReqDisID),"^",10)								/// 状态
	s StatusCode=$p(^DHCDISSA(CurStatus),"^",1)
	q:StatusCode'="102" "0"
	s PhBoxId=$o(^DHCPHBOXi("No","ZX"_$e(PhBoxCode,1,11),""))				/// 药箱ID
	s RepLocId=$p(^DHCDISGRE(ReqDisID),"^",2)   							/// 申请科室
	s ret=##Class(web.DHCINPHA.MobilePHA).HandOutMethod(PhBoxId,RepLocId,"2754",UserId)
	q ret
}

/// 配送申请接口  【药房】
/// w ##class(web.DHCDISGoodsRequest).SaveDisRep("38^4^185^14^ZX20180902061#5782^102^^03/09/2018^11:17:35^02/09/2018^17:14:46^14^N^102^1",1)
ClassMethod SaveDisRep(ListData As %String, flag As %String = "")
{
	n (ListData,flag)
	s MainListData=""
	s PhboxNum=$p(ListData,"^",2)		///条码数
	s mListData=$p(ListData,"#",1)		///主表数据
	s sListData=$p(ListData,"#",2)		///子表数据
	if PhboxNum>1 d
	.for i=1:1:PhboxNum  d
	..s $p(mListData,"^",5)=$E($p(mListData,"^",5),1,13)_i
	..s hListData=mListData_"#"_sListData
	..s MainListData=mListData_"#"_sListData
	..d ..Save(MainListData,flag)
	e  d
	.s $p(mListData,"^",5)=$p(mListData,"^",5)_1
	.s MainListData=mListData_"#"_sListData
	.d ..Save(MainListData,flag)
	q 0
}

}
