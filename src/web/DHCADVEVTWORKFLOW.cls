Import sqluser

Class web.DHCADVEVTWORKFLOW Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存[工作流定义]
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SaveAdrEvtworkFlow("^sd^器械填报^器械^Y")
ClassMethod SaveAdrEvtworkFlow(DataList As %String, HospDr As %String) As %String
{
	N (DataList,HospDr)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDeal(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdrEvtworkFlow(TmpStr)
	.E  D
	..S Err=..InsAdrEvtworkFlow(TmpStr,HospDr)

	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Table:		 DHC_AdrEvtWorkFlow
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).CheckRepeatDeal("^sd1^器械填报^器械^Y")
ClassMethod CheckRepeatDeal(TmpStr As %String) As %String
{
	N (TmpStr)
	s AdreWID=$p(TmpStr,"^",1)   		///ID
	s AdreWCode=$p(TmpStr,"^",2)   	///代码
	/// 新记录
	q:(AdreWID="")&($d(^DHCADREVTWF(0,"Code",$$ALPHAUP^SSUTIL4(AdreWCode)))) "-1"
	q:AdreWID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADREVTWF(AdreWID)),"^",1)    //代码
	q:(AdreWCode'=Code)&($d(^DHCADREVTWF(0,"Code",$$ALPHAUP^SSUTIL4(AdreWCode)))) "-2"
	q 0
}

/// Description: 更新[工作流定义]
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdAdrEvtworkFlow("1^器械填报^器械填报^器械^Y")
ClassMethod UpdAdrEvtworkFlow(DataList As %String) As %String
{
	N (DataList)
	S AdreWID=$p(DataList,"^",1)
	S AdreWCode=$p(DataList,"^",2)
	S AdreWDesc=$p(DataList,"^",3)
	S AdreWEventTypeDr=$p(DataList,"^",4)
	S AdreWActive=$p(DataList,"^",5)
	&SQL(Update DHC_AdrEvtWorkFlow Set ADREW_Code=:AdreWCode, ADREW_Desc=:AdreWDesc,ADREW_Event_Dr=:AdreWEventTypeDr, ADREW_Active=:AdreWActive WHERE ADREW_RowID=:AdreWID)
 	Q SQLCODE
}

/// Description: 增加[工作流定义]
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Table:	 	 DHC_AdrEvtWorkFlow
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).InsAdrEvtworkFlow("^器械填报^器械填报^器械^Y")
ClassMethod InsAdrEvtworkFlow(DataList As %String, HospDr As %String) As %String
{
	N (DataList,HospDr)
	S AdreWCode=$p(DataList,"^",2)
	S AdreWDesc=$p(DataList,"^",3)
	S AdreWEventTypeDr=$p(DataList,"^",4)
	S AdreWActive=$p(DataList,"^",5)
 	&SQL(INSERT INTO DHC_AdrEvtWorkFlow(ADREW_Code,ADREW_Desc,ADREW_Event_Dr,ADREW_Active) VALUES(:AdreWCode,:AdreWDesc,:AdreWEventTypeDr,:AdreWActive))
	Q:SQLCODE'=0 SQLCODE
 	S hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdrEvtWorkFlow",+%ROWID,HospDr)
 	Q:hospflag'=0 -3
	Q SQLCODE
}

/// Description: 删除[工作流定义]
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Table:	 	 DHC_AdrEvtWorkFlow
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).DelAdrEvtworkFlow("1")
ClassMethod DelAdrEvtworkFlow(AdreWID As %String) As %String
{
	N (AdreWID)
	S TypeDr=$p(^DHCADREVTWF(AdreWID),"^",3)
	S:(TypeDr'="")&&(TypeDr'["||") TypeCode=$p(^DHCMEDADREVT(TypeDr),"^",1)
	S:(TypeDr'="")&&(TypeDr["||") TypeCode=$p(^DHCMEDADREVTI(+TypeDr,"MADREVI",$p(TypeDr,"||",2)),"^",1)
	S AuditID=""
	S flag=0
	;F  S AdrEwiID=$o(^DHCMEDREPADT(0,"TypeSta",TypeDr,AdrEwiID)) Q:AdrEwiID=""  D  ;判断此状态是否存在相应的报告审批记录
	;.S:AdreWID=+AdrEwiID flag=-1
	F  S AuditID=$o(^DHCMEDREPADT(AuditID)) Q:AuditID=""  D  ;判断此状态是否存在相应的报告审批记录
	.Q:+AuditID=0
	.S AuditTypeDr=$p(^DHCMEDREPADT(AuditID),"^",2)
	.S AuditStatusDr=$p(^DHCMEDREPADT(AuditID),"^",3)
	.Q:(AuditTypeDr="")||(AuditStatusDr="")
	.S:(TypeCode="NursingRep")&&(AdreWID=+AuditStatusDr) flag=-1
	.S:AdreWID=+AuditStatusDr flag=-1
	.Q:flag=-1
	Q:flag=-1 -1
	
	TS
	//2021-01-30 cy 新增删除相关表信息
	// 先删除相关表
	S Err=..DelRelatInfo(AdreWID)
	I Err'=0 tro
	Q:Err'=0 Err
	
	// 再删除表信息
	&SQL(Delete From DHC_AdrEvtWorkFlow Where ADREW_RowID=:AdreWID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE
	
	s hospflag=##Class(web.DHCADVCOMMON).DeleteHospitals("DHC_AdrEvtWorkFlow",AdreWID)
	I hospflag'=1 tro
	Q:hospflag'=1 -3

	TC
	Q 0
}

/// Description: 查询[工作流项目定义]
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).QueryAdrEvtworkFlow("12","1","Root")
ClassMethod QueryAdrEvtworkFlow(rows As %String, page As %String, params As %String, HospDr = "") As %String
{
	N (rows,page,params,HospDr)
	S End = page*rows
	S Start = (page-1)*rows+1
	
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0  
    Q:params'="Root" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
    ;S adrEventType=$p(params,"^",1)
	S ID="0"
	F  S ID=$o(^DHCADREVTWF(ID)) Q:ID=""  D
	.S Code=$p(^DHCADREVTWF(ID),"^",1) //代码
	.S Desc=$p(^DHCADREVTWF(ID),"^",2) //描述
	.S EventTypeDr=$p(^DHCADREVTWF(ID),"^",3) //类型
	.S EventType="",EventTypeCode=""
	.S:(EventTypeDr'="")&&(EventTypeDr'["||") EventTypeCode=$p(^DHCMEDADREVT(EventTypeDr),"^",1)
	.Q:(EventTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(EventTypeCode,HospDr)'=1)
	.S:(EventTypeDr'="")&&(EventTypeDr'["||") EventType=$p(^DHCMEDADREVT(EventTypeDr),"^",2)
	.S:(EventTypeDr'="")&&(EventTypeDr["||") EventType=##class(web.DHCADVCOMMONPART).GetEventDesc(EventTypeDr,"",HospDr)
	.S Active=$p(^DHCADREVTWF(ID),"^",4) //是否可用
	.Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdrEvtWorkFlow",ID,HospDr,"")'="Y"
	.S Level=1
	.S Levelrowid="Root"
	.S OrderNo=""
	.S h=h+1
	.S TempStr=ID_"^"_Code_"^"_Desc_"^"_Active_"^"_Level_"^"_Levelrowid_"^"_EventTypeDr_"^"_EventType_"^"_OrderNo
	.S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryAdrEvtworkFlow",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Level^Levelrowid^EventTypeDr^EventType^OrderNo"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryAdrEvtworkFlow",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryAdrEvtworkFlow",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D   //有开始值和结束值
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate) //逗号在这加着呢
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 保存[工作流项目]
/// Creator:     CongYue
/// CreateDate:  2015-11-14
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 adrEvtworkFlowItmDataList:以字符"^"分割,格式为:id^主表id^编码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SaveAdrEvtworkFlowItm("1||1^1^填报^填报")
ClassMethod SaveAdrEvtworkFlowItm(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDealItm(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdrEvtworkFlowItm(TmpStr)
	.E  D
	..S Err=..InsAdrEvtworkFlowItm(TmpStr)
	Q Err
}

/// Description: 保存[检查代码是否重复]
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Creator:     CongYue
/// CreateDate:  2016-05-23
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).CheckRepeatDealItm("^1^填报^填报")
ClassMethod CheckRepeatDealItm(TmpStr As %String) As %String
{
	N (TmpStr)
	S AdrEwiID=$p(TmpStr,"^",1)   		///ID
	S Parref=+$p(TmpStr,"^",2)			///主表ID
	S ChildSub=$p(AdrEwiID,"||",2)
	S AdrEwiCode=$p(TmpStr,"^",3)   	///代码
	/// 新记录
	Q:(AdrEwiID="")&($d(^DHCADREVTWFI(0,"Code",$$ALPHAUP^SSUTIL4(AdrEwiCode),Parref))) "-1"
	Q:AdrEwiID="" 0
	
	/// 修改记录
	S Code=$p(^DHCADREVTWFI(Parref,"ADREWI",ChildSub),"^",1)    //代码
	Q:(AdrEwiCode'=Code)&($d(^DHCADREVTWFI(0,"Code",$$ALPHAUP^SSUTIL4(AdrEwiCode),Parref))) "-2"
	Q 0
}

/// Description: 更新[工作流项目]
/// Creator:     CongYue
/// CreateDate:  2015-11-14
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 adrEvtworkFlowItmDataList:以字符"^"分割,格式为:id^主表id^编码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdAdrEvtworkFlowItm("1||1^1^填报^填报")
ClassMethod UpdAdrEvtworkFlowItm(DataList As %String) As %String
{
	N (DataList)
	S AdrEwiID=$p(DataList,"^",1)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S Active=$p(DataList,"^",5)
	S Level=$p(DataList,"^",6)     //级别    
	S PLevelRowID=$p(DataList,"^",7)   //上一级别 ID
	&SQL(Update DHC_AdrEvtWorkFlowItm Set ADREWI_Code=:Code,ADREWI_Desc=:Desc,ADREWI_ActiveFlag=:Active,ADREWI_Level=:Level,ADREWI_LevelRowID=:PLevelRowID WHERE ADREWI_RowID=:AdrEwiID)
 	Q SQLCODE
}

/// Description: 增加[工作流项目]
/// Creator:     CongYue
/// CreateDate:  2015-11-14
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 adrEvtworkFlowItmDataList:以字符"^"分割,格式为:id^主表id^编码^描述
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).InsAdrEvtworkFlowItm("^1^填报^填报")
ClassMethod InsAdrEvtworkFlowItm(DataList As %String) As %String
{
	N (DataList)	
	S parref=+$p(DataList,"^",2)
	S Code=$p(DataList,"^",3)
	S Desc=$p(DataList,"^",4)
	S childSub=$o(^DHCADREVTWFI(parref,"ADREWI",""),-1)+1
	S Active=$p(DataList,"^",5)
	S Level=$p(DataList,"^",6)     //级别    
	S PLevelRowID=$p(DataList,"^",7)   //上一级别 ID
	S OrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",PLevelRowID,parref,""),-1)+1  ;$o(^DHCADREVTWFI(parref,"ADREWI",""),-1)+1
 	&SQL(INSERT INTO DHC_AdrEvtWorkFlowItm(ADREWI_ADREW_Parref, ADREWI_ChildSub,ADREWI_Code,ADREWI_Desc,ADREWI_OrderNo,ADREWI_ActiveFlag,ADREWI_Level,ADREWI_LevelRowID)
 		 VALUES(:parref,:childSub,:Code,:Desc,:OrderNo,:Active,:Level,:PLevelRowID))
 	Q SQLCODE
}

/// Description: 删除[工作流项目]
/// Creator:     CongYue
/// CreateDate:  2015-11-14
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).DelAdrEvtworkFlowItm("1||4")
ClassMethod DelAdrEvtworkFlowItm(AdrEwiID As %String) As %String
{
	N (AdrEwiID)
	S AdreWID=+AdrEwiID
	S TypeDr=$p(^DHCADREVTWF(AdreWID),"^",3)
	S TypeCode=""
	Q:(TypeDr'="")&&($d(^DHCMEDREPADT(0,"TypeSta",TypeDr,AdrEwiID))) -1  ;判断此状态是否存在相应的报告审批记录
	S:(TypeDr'="")&&(TypeDr'["||") TypeCode=$p(^DHCMEDADREVT(TypeDr),"^",1)
	S:(TypeDr'="")&&(TypeDr["||") TypeCode=$p(^DHCMEDADREVTI(+TypeDr,"MADREVI",$p(TypeDr,"||",2)),"^",1)
	S AuditID=""
	S flag=0
	F  S AuditID=$o(^DHCMEDREPADT(AuditID)) Q:AuditID=""  D  ;判断此状态是否存在相应的报告审批记录
	.Q:+AuditID=0
	.S AuditTypeDr=$p(^DHCMEDREPADT(AuditID),"^",2)
	.S AuditStatusDr=$p(^DHCMEDREPADT(AuditID),"^",3)
	.Q:(AuditTypeDr="")||(AuditStatusDr="")
	.S:(TypeCode="NursingRep")&&(AdrEwiID=AuditStatusDr) flag=-1
	.S:AdrEwiID=AuditStatusDr flag=-1
	.Q:flag=-1
	Q:flag=-1 -1	
		
	TS
	//2021-01-30 cy 新增删除相关表信息
	//删除相关表
	S Err=..DelRelatInfo(AdrEwiID)
	I Err'=0 tro
	Q:Err'=0 Err
	
	// 再删除表信息
	&SQL(Delete From DHC_AdrEvtWorkFlowItm Where ADREWI_RowID=:AdrEwiID)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE
	
	TC
	
	Q SQLCODE
}

/// Description: 查询[工作流项目]
/// Creator:     CongYue
/// CreateDate:  2015-11-15
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:   	 主表id（工作流定义数据id）
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).QueryEventWorkFlowItm("180","1","18||1")
ClassMethod QueryEventWorkFlowItm(rows As %String, page As %String, AdrEwiID As %String) As %String
{
	N (rows,page,AdrEwiID)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0
    Q:AdrEwiID="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符

	S Parref=+AdrEwiID ;上一层级id取+ 为主表id
	S OrderNo=""
	F  S OrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrEwiID,Parref,OrderNo))  Q:OrderNo=""  D
	.S SubID=""
	.F  S SubID=$o(^DHCADREVTWFI(0,"LevOrderNo",AdrEwiID,Parref,OrderNo,SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S Code=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",1) //代码
	..S Desc=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",2) //描述
	..S Active=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",4) //是否可用
	..S Level=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",5) //级别
	..S Levelrowid=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",6) //上一级别的rowid
	..Q:AdrEwiID'=Levelrowid  ; 入参与父元素指向id不相等则退出
	..S data=Parref_"||"_SubID_"^"_Code_"^"_Desc_"^"_Active_"^"_Level_"^"_Levelrowid_"^"_""_"^"_""_"^"_OrderNo
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowItm",pid,h)=data
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="ID^Code^Desc^Active^Level^Levelrowid^EventTypeDr^EventType^OrderNo"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index="",count=0
	F  S index=$o(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowItm",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowItm",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D   //有开始值和结束值
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate) //逗号在这加着呢
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 更新工作流项目序号
/// Creator:     CongYue
/// CreateDate:  2015-11-16
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 input:id^顺序号^id^顺序号
/// Return: 	 更新成功 0,更新失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdEventWorkFlowItmNum("1||2^1^1||1^2")
ClassMethod UpdEventWorkFlowItmNum(input) As %String
{
	N (input)
	S currowid=$p(input,"^",1)
	S curordernum=$p(input,"^",2)
	S lastrowid=$p(input,"^",3)
	S lastordernum=$p(input,"^",4)
	S curordernum=$p(^DHCADREVTWFI(+lastrowid,"ADREWI",$p(lastrowid,"||",2)),"^",3)
	S lastordernum=$p(^DHCADREVTWFI(+currowid,"ADREWI",$p(currowid,"||",2)),"^",3)
	TS
	&sql(update DHC_AdrEvtWorkFlowItm  set ADREWI_OrderNo=:curordernum where ADREWI_RowID=:currowid)
	I SQLCODE'=0 TRO
	Q:SQLCODE'=0 -1
	&sql(update DHC_AdrEvtWorkFlowItm  set ADREWI_OrderNo=:lastordernum where ADREWI_RowID=:lastrowid)
	I SQLCODE'=0 TRO
	Q:SQLCODE'=0 -2
	TC
	
	Q 0
}

/// Description: 保存[工作流授权]
/// Creator:     CongYue
/// CreateDate:  2015-11-23
/// Table:		 DHC_AdrWorkFlowGrant
/// Input:  	 adrWorkFlowGrantDataList:以字符"^"分割,格式为:id^关联表id^类型^指向id^代码（1代表工作流 2代表工作流项目）
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SaveAdrWorkFlowGrant("^2^1||2^1^1")
ClassMethod SaveAdrWorkFlowGrant(adrWorkFlowGrantDataList As %String) As %String
{
	N (adrWorkFlowGrantDataList)
	S Err=0
	S len=$L(adrWorkFlowGrantDataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(adrWorkFlowGrantDataList,"&&",i)
	.S Err=..CheckRepeatDealGrant(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdAdrWorkFlowGrant(TmpStr)
	.E  D
	..S Err=..InsAdrWorkFlowGrant(TmpStr)
	Q Err
}

/// Description: 保存[检查权限是否重复]
/// Table:		 DHC_AdrWorkFlowGrant
/// Creator:     CongYue
/// CreateDate:  2016-06-29
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).CheckRepeatDealGrant("^2^1||2^1^1")
ClassMethod CheckRepeatDealGrant(TmpStr As %String) As %String
{
	N (TmpStr)
	S AdrwfgID=$p(TmpStr,"^",1)
	S parrefdr=$p(TmpStr,"^",5)
	S itmdr=$p(TmpStr,"^",2)
	S type=$p(TmpStr,"^",3)
	S pointerID=$p(TmpStr,"^",4)
	S HospDr=$p(TmpStr,"^",6)
	S ID="",Flag=0
	F  S ID=$o(^DHCADREVTWFGR(0,"TypePointer",type,pointerID,parrefdr,itmdr,ID))  Q:+ID=0  D
	.Q:Flag'=0
	.S wfgHosp=$p(^DHCADREVTWFGR(ID),"^",5)		 // 医院
	.S:(AdrwfgID="")&&(wfgHosp=HospDr) Flag="-1"
	.S:(AdrwfgID'="")&&(AdrwfgID'=ID)&&(wfgHosp=HospDr) Flag="-2"
	.Q:Flag'=0
	
	Q Flag
}

/// Description: 更新[工作流授权]
/// Creator:     CongYue
/// CreateDate:  2015-11-23
/// Table:		 DHC_AdrWorkFlowGrant
/// Input:  	 adrWorkFlowGrantDataList:以字符"^"分割,格式为:id^关联表id^类型^指向id^代码（1代表工作流 2代表工作流项目）
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdAdrWorkFlowGrant("1^2^1||2^1^1")
ClassMethod UpdAdrWorkFlowGrant(adrWorkFlowGrantDataList As %String) As %String
{
	N (adrWorkFlowGrantDataList)
	S AdrwfgID=$p(adrWorkFlowGrantDataList,"^",1)
	S itmdr=$p(adrWorkFlowGrantDataList,"^",2)
	S type=$p(adrWorkFlowGrantDataList,"^",3)
	S pointerID=$p(adrWorkFlowGrantDataList,"^",4)
	S parrefdr=$p(adrWorkFlowGrantDataList,"^",5)
	S HospDr=$p(adrWorkFlowGrantDataList,"^",6)
	&SQL(Update DHC_AdrWorkFlowGrant Set ADRWFG_ParRef_Dr=:parrefdr, ADRWFG_Itm_Dr=:itmdr, ADRWFG_Type=:type,ADRWFG_Pointer=:pointerID,ADRWFG_HospDr=:HospDr WHERE ADRWFG_RowID=:AdrwfgID)
 	Q SQLCODE
}

/// Description: 增加[工作流授权]
/// Creator:     CongYue
/// CreateDate:  2015-11-23
/// Table:		 DHC_AdrWorkFlowGrant
/// Input:  	 adrWorkFlowGrantDataList:以字符"^"分割,格式为:id^关联表id^类型^指向id^代码（1代表工作流 2代表工作流项目）
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).InsAdrWorkFlowGrant("^2^1||2^1^1")
ClassMethod InsAdrWorkFlowGrant(adrWorkFlowGrantDataList As %String) As %String
{
	N (adrWorkFlowGrantDataList)
	S parrefdr=$p(adrWorkFlowGrantDataList,"^",5)
	S itmdr=$p(adrWorkFlowGrantDataList,"^",2)	
	S type=$p(adrWorkFlowGrantDataList,"^",3)
	S pointerID=$p(adrWorkFlowGrantDataList,"^",4)
	S HospDr=$p(adrWorkFlowGrantDataList,"^",6)
 	&SQL(INSERT INTO DHC_AdrWorkFlowGrant(ADRWFG_ParRef_Dr,ADRWFG_Itm_Dr,ADRWFG_Type,ADRWFG_Pointer,ADRWFG_HospDr)
 		 VALUES(:parrefdr,:itmdr,:type,:pointerID,:HospDr))
 	Q SQLCODE
}

/// Description: 删除[工作流授权]
/// Creator:     CongYue
/// CreateDate:  2015-11-23
/// Table:		 DHC_AdrWorkFlowGrant
/// Input:  	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).DelAdrWorkFlowGrant("1")
ClassMethod DelAdrWorkFlowGrant(AdrwfgID As %String) As %String
{
	N (AdrwfgID)
	&SQL(Delete From DHC_AdrWorkFlowGrant Where ADRWFG_RowID=:AdrwfgID)
	Q SQLCODE
}

/// Description: 查询[工作流授权]
/// Creator:     CongYue
/// CreateDate:  2015-11-24
/// Input:  	 数据id
/// Table:		 DHC_AdrWorkFlowGrant
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).QueryEventWorkFlowGrant("1||2")
ClassMethod QueryEventWorkFlowGrant(ItmDr As %String, HospDr = "") As %String
{
	N (ItmDr,HospDr)
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0
    Q:ItmDr="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S AdrwfgID=""
	F  S AdrwfgID=$o(^DHCADREVTWFGR(0,"ItmDr",ItmDr,AdrwfgID)) Q:AdrwfgID=""  D
	.S ParRefDr=$p(^DHCADREVTWFGR(AdrwfgID),"^",1) //
	.S ItmDR=$p(^DHCADREVTWFGR(AdrwfgID),"^",2) //
	.S Type=$p(^DHCADREVTWFGR(AdrwfgID),"^",3) //类型
	.S Pointer=$p(^DHCADREVTWFGR(AdrwfgID),"^",4) //指针
	.S TypeName=$S(Type="1":"安全组",Type="2":"科室",Type="3":"人员",Type="4":"全院",Type="5":"大科室安全组",1:"") //hxy 2017-12-14 Type="5":"科室安全组",
	.S PointerName = ..FindPointer(Pointer,Type)
	.S AdrwfgHospDr=$p(^DHCADREVTWFGR(AdrwfgID),"^",5)			// 医院
	.Q:(HospDr'="")&&(AdrwfgHospDr'="")&&(HospDr'=AdrwfgHospDr)
	.Q:(ItmDr'="")&(ItmDR'[ItmDr)
	.S h=h+1
	.S TempStr=AdrwfgID_"^"_ParRefDr_"^"_ItmDR_"^"_Type_"^"_TypeName_"^"_PointerName_"^"_Pointer_"^"_AdrwfgHospDr
	
	.S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowGrant",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^ParRefDr^ItmDr^TypeID^Type^Pointer^PointID^HospDr"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowGrant",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowGrant",pid,index))
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 权限指向ComboBox
/// Creator:	 CongYue
/// CreatDate:	 2015-11-13
/// W ##class(web.DHCADVEVTWORKFLOW).GetSSPPoint(1,10,"2^1","口腔",2)
ClassMethod GetSSPPoint(Start As %Integer, Limit As %Integer, params As %Integer, input, HospID = "")
{
    N (Start,Limit,params,input,HospID)
    S Type=$p(params,"^",1)
    S Group=$p(params,"^",2)
    S Desc=$p(params,"^",3)
    ;G,L,U
    ;SS_Group,CT_Loc,SS_User
    I Type="1"  D       //按安全组
    .D ..GetGroup(Start,Limit,Desc,input,HospID)
    I Type="2"  D       //按科室
    .D ..GetGroupDept(Start,Limit,Group,Desc,input,"",HospID)
    I Type="3"  D       //按人员
    .D ..GetGroupUserByGroupId(Start,Limit,Group,Desc,input,HospID)
    I Type="4"  D       //按全院
    .W "["
    .W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","DHC^全院")
    .W "]"
    I Type="5"  D       //按大科室安全组 hxy 2017-12-14
    .D ..GetSecuGroup(Start,Limit,Desc,input,HospID)
    Q ""
}

/// description: 科室安全组
/// Creator: 	 huaxiaoying 
/// CreatDate:	 2017-12-14
/// input:  	 Start(起始数值)  Limit(增长数值),科室安全组名称(输入)
ClassMethod GetSecuGroup(Start As %Integer, Limit As %Integer, Desc As %String, input As %String, HospID = "")
{
    N (Start,Limit,Desc,input,HospID)
    S result = ##class(%Library.ResultSet).%New()
    S sqlStr = "SELECT SECUG_RowId,SECU_Desc,SECU_ActiveFlag,SECU_Hosp_Dr FROM DHC_AdvSecuGroup WHERE SECU_Desc like '%"_input_"%'  "
    D result.Prepare(sqlStr)
    D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S RowId = result.Data("SECUG_RowId")
		S Desc = result.Data("SECU_Desc")
		S Active=result.Data("SECU_ActiveFlag") //是否可用
		S SecHospId=result.Data("SECU_Hosp_Dr") // 医院
		S HospList=","_##Class(web.DHCADVCOMMON).GetGroupHospIdsByTableName("DHC_AdvQuerySec",HospID,"")_","
		continue:(Active="N")
		continue:HospList'[(","_SecHospId_",")
		S tmp=RowId_"^"_Desc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// description: 安全组
/// Creator: 	 CongYue 
/// CreatDate:	 2015-11-18
/// input:  	 Start(起始数值)  Limit(增长数值),安全组名称
ClassMethod GetGroup(Start As %Integer, Limit As %Integer, Desc As %String, input, HospID = "")
{
    N (Start,Limit,Desc,input,HospID)
    S result = ##class(%Library.ResultSet).%New()
    S sqlStr = "SELECT SSGRP_RowId,SSGRP_Desc,SSGRP_ActiveFlag FROM SS_Group WHERE SSGRP_Desc like '%"_input_"%'"
    D result.Prepare(sqlStr)
    D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		
		S RowId = result.Data("SSGRP_RowId")
		continue:##class(web.DHCADVCOMMON).GetHospShowDataFlag("SS_Group",RowId,HospID)'="Y" //ed
		S Desc = result.Data("SSGRP_Desc")
		S ActiveFlag= result.Data("SSGRP_ActiveFlag")
		continue:ActiveFlag'="Y"
		S tmp=RowId_"^"_Desc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// description: 安全组能访问的科室ComboBox
/// Creator: 	 CongYue 
/// CreatDate:	 2015-11-18
/// input:  	 Start(起始数值)  Limit(增长数值),安全组id,科室名称
/// W ##class(web.DHCADVEVTWORKFLOW).GetGroupDept("","","","","风湿免疫科护","")
ClassMethod GetGroupDept(Start As %Integer, Limit As %Integer, GroupId As %String, LocDesc As %String, input, Type As %String = "", HospID = "")
{
    N (Start,Limit,GroupId,LocDesc,input,Type,HospID)
    S result = ##class(%Library.ResultSet).%New()
    S Type=$g(Type)
    s input=$zcvt(input,"U") 
    S sqlStr="Select CTLOC_RowID,CTLOC_Desc, CTLOC_ActiveFlag, CTLOC_DateActiveFrom, CTLOC_DateActiveTo  from CT_LOC"
	;i input'=""  d
	;.s input=$zcvt(input,"U") 
	;.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "


    D result.Prepare(sqlStr)
    D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S RowId = result.Data("CTLOC_RowID")
		S Description = result.Data("CTLOC_Desc")
		//, CTLOC_ActiveFlag, CTLOC_DateActiveFrom, CTLOC_DateActiveTo 
		S LocActive=result.Data("CTLOC_ActiveFlag")
		s ContactName=$p(^CTLOC(RowId),"^",43)
		s ContactName=$zcvt(ContactName,"U") 
		continue:(LocActive'="")&&(LocActive="N")
		S LocActiveDateFrom=result.Data("CTLOC_DateActiveFrom") ;生效日期
		S LocActiveDateTo=result.Data("CTLOC_DateActiveTo") ;截止日期
		continue:(LocActiveDateFrom'="")&&(LocActiveDateFrom>+$h)
		continue:(LocActiveDateTo'="")&&(LocActiveDateTo<+$h)
		
		S WardDr=$o(^PAWARD(0,"WARD_LocationDR",RowId,""))
		S WardActive=""
		S:WardDr'="" WardActive=$p(^PAWARD(WardDr),"^",6) // 激活标识
		continue:WardActive="N"
		continue:(input'="")&&(Description_ContactName'[input)
		continue:##class(web.DHCADVCOMMON).GetHospShowDataFlagSpecial("CT_Loc",RowId,HospID,"","DHC_AdvQuerySec")'="Y"
		S tmp=RowId_"^"_Description
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// description: 某安去组下的人(采购员ComboBox)
/// Creator:	 CongYue
/// CreatDate:	 2015-11-18
/// input:  	 Start(起始数值)  Limit(增长数值),"采购员"
/// W ##class(web.DHCADVEVTWORKFLOW).GetGroupUserByGroupId("","","","","innur")
ClassMethod GetGroupUserByGroupId(Start As %Integer, Limit As %Integer, Group As %String, Desc As %String, input, HospID = "") As %String
{
    N (Start,Limit,Group,Desc,input,HospID)
    S result = ##class(%Library.ResultSet).%New()
    S sqlStr = "SELECT SSUSR_RowId,SSUSR_Name,SSUSR_Active,SSUSR_DateFrom, SSUSR_DateTo,SSUSR_Hospital_DR FROM SS_User WHERE SSUSR_Name like '%"_input_"%'"
    D result.Prepare(sqlStr)
    D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S Rowid = result.Data("SSUSR_RowId")
		continue:##class(web.DHCADVCOMMON).GetHospShowDataFlag("SS_User",Rowid,HospID)'="Y" //ed

		S Name = result.Data("SSUSR_Name")
		S UserActive=result.Data("SSUSR_Active")
		continue:(UserActive'="")&&(UserActive="N")
		S UserDateFrom=result.Data("SSUSR_DateFrom") ;生效日期
		S UserDateTo=result.Data("SSUSR_DateTo") ;截止日期
		continue:(UserDateFrom'="")&&(UserDateFrom>+$h)
		continue:(UserDateTo'="")&&(UserDateTo<+$h)
		
		;S SSHospId=result.Data("SSUSR_Hospital_DR") ;医院 
		;S HospList=","_##Class(web.DHCADVCOMMON).GetGroupHospIdsByTableName("DHC_AdvQuerySec",HospID,"")_","
		;continue:HospList'[(","_SSHospId_",")
		
		S tmp=Rowid_"^"_Name
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// Description: 查询类型值
/// Creator:     CongYue
/// CreateDate:  2015-11-18
/// Table:	  	 DHC_StkSysAPropPref
/// Input:		 数据id
/// Return：	 0 – 成功，非0 ：失败
ClassMethod FindPointer(Pointer As %String, Type As %String) As %Library.String
{
    N (Pointer,Type)
 
    Q:Pointer="" ""
    Q:Type="" ""
    
    S PointerName = ""
    S sql = ""
    I Type="1" D
    .S sql = "select SSGRP_Desc AS Name from SS_Group where SSGRP_RowId="_Pointer
    I Type="2" D
    .S sql="select CTLOC_DESC AS Name from CT_Loc WHERE CTLOC_ROWID="_Pointer
    I Type="3" D
    .S sql="select  ssusr_name as Name from SS_user where ssusr_rowid="_Pointer
    I Type="4" D //cy 2019-06-28 添加全院选项
    .S PointerName="全院"
    I Type="5" D //hxy 2017-12-14 大科室安全组（对应新安全小组）
    .S sql="select  SECU_Desc as Name from DHC_AdvSecuGroup where SECUG_RowId="_Pointer
    
    S result = ##class(%Library.ResultSet).%New()
    D result.Prepare(sql)
    D result.Execute()
    While(result.Next())
    {
        S PointerName = result.Data("Name")
    }
    Q PointerName
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryAdrEvtworkFlow",pid)
	K ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowItm",pid)
	K ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEventWorkFlowGrant",pid)
	K ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEvtWorkFlowLink",pid)
}

/// Description: 工作流项目类型
/// Creator:     CongYue
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Output:  	 工作流项目类型描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SelEvtWFItm()
ClassMethod SelEvtWFItm() As %String
{
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT ADREWI_RowID as EvtWFItmDr,ADREWI_Desc as EvtWFItmDesc FROM DHC_AdrEvtWorkFlowItm "
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S EvtWFItmDr = result.Data("EvtWFItmDr")
		S EvtWFItmDesc = result.Data("EvtWFItmDesc")
		S:EvtWFItmDesc["-" EvtWFItmDesc=$p(EvtWFItmDesc,"-",2)
		S tmp=EvtWFItmDr_"^"_EvtWFItmDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
}

/// Description: 工作流与工作流项目  加载树
/// Creator:     CongYue
/// CreateDate:	 2019-07-02
/// Table:		 DHC_AdrEvtWorkFlow DHC_AdrEvtWorkFlowItm DHC_AdrEvtWorkFlowLink
/// Output:  	 工作流与工作流项目  加载树  
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).jsonCheckWorkFlow1("10")
ClassMethod jsonCheckWorkFlow(id, HospDr = "") As %String
{
	n (id,HospDr)
	w "["
	s count=0
	/// 入参为 "Root" ,显示默认根节点 + 父表元素树
	i id="Root" D
	.w ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign("Root","工作流根目录","0")
	.w ","""_"state"_""""_":"_""""_"open"_""","""_"children"_""""_":"
	.d ..jsonCheckWorkFlow(0,HospDr)
	.w "}"
	s ParID=0
	i id=0  d
	
	.F  S ParID=$o(^DHCADREVTWF(ParID)) Q:ParID=""  D
	..Q:+ParID=0
	..Q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_AdrEvtWorkFlow",ParID,HospDr,"")'="Y"
	..S ParCode=$p(^DHCADREVTWF(ParID),"^",1) //代码
	..S ParDesc=$p(^DHCADREVTWF(ParID),"^",2) //描述
	..S ParDesc=ParDesc_"(工作流)"
	..S EventTypeDr=$p(^DHCADREVTWF(ParID),"^",3) //类型
	..S EventType="",EventTypeCode=""
	..S:(EventTypeDr'="")&&(EventTypeDr'["||") EventTypeCode=$p(^DHCMEDADREVT(EventTypeDr),"^",1)
	..Q:(EventTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(EventTypeCode,HospDr)'=1)
	..S:(EventTypeDr'="")&&(EventTypeDr'["||") EventType=$p(^DHCMEDADREVT(EventTypeDr),"^",2)
	..S:(EventTypeDr'="")&&(EventTypeDr["||") EventType=##class(web.DHCADVCOMMONPART).GetEventDesc(EventTypeDr,"",HospDr)
	..S ParActive=$p(^DHCADREVTWF(ParID),"^",4) //是否可用
	..Q:ParActive="N"
	..S ParLevel=1  ; 父表数据默认第一层数据为1级 
	..S Levelrowid=""
	..S ParTempStr=ParID_"^"_ParDesc_"^"_ParLevel_"^"_Levelrowid
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(ParID,ParDesc,ParLevel)
	..e  d
	...w ","_##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(ParID,ParDesc,ParLevel)
    ..///  是否存在孩子节点
	..s SubID=$o(^DHCADREVTWFI(ParID,"ADREWI",""))
	..i SubID'="" D
	...w ","_##class(web.DHCADVJSONCOMMON).getJsonTreeClosedSign()
	..w "}"
	e  d
	.d ..jsonCheckWorkFlowItm(id)  //入参为父表id或子表id，加载子表元素树
	w "]"
  	q ""
}

/// Description: 工作流与工作流项目  加载子元素树
/// Creator:     CongYue
/// CreateDate:	 2019-07-02
/// Table:		 DHC_AdrEvtWorkFlow DHC_AdrEvtWorkFlowItm DHC_AdrEvtWorkFlowLink
/// Output:  	 工作流与工作流项目  加载子元素树  
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).jsonCheckWorkFlowItm("10||3")
ClassMethod jsonCheckWorkFlowItm(ParentID) As %String
{
	n (ParentID)
	s h=0
	
	S Parref=+ParentID ;上一层级id取+ 为主表id
	S OrderNo=""
	F  S OrderNo=$o(^DHCADREVTWFI(0,"LevOrderNo",ParentID,Parref,OrderNo))  Q:OrderNo=""  D
	.S SubID=""
	.F  S SubID=$o(^DHCADREVTWFI(0,"LevOrderNo",ParentID,Parref,OrderNo,SubID)) Q:SubID=""  D
	..Q:+SubID=0
	..S Code=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",1)  //代码
	..S Desc=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",2)  //描述
	..S Level=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",5) //级别
	..S Levelrowid=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",6) //上一级别的rowid
	..S Active=$p(^DHCADREVTWFI(Parref,"ADREWI",SubID),"^",4) //是否可用
	..Q:(ParentID'["||")&&(Level'="2")  ; 入参为父表id，子表数据默认第一层数据为2级
	..Q:ParentID'=Levelrowid  ; 入参与父元素指向id不相等则退出
	..Q:Active="N"
	..s RowId=Parref_"||"_SubID
	..s h = h+1
	..i h=1 d
	...w ##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
	..e  d
	...w ","_##class(web.DHCADVJSONCOMMON).getJsonTreeStartSign(RowId,Desc,Level)
    ..///  是否存在孩子节点
	..s ChildID=$o(^DHCADREVTWFI(0,"ItmLevelDr",RowId,""))
	..i ChildID'="" D
	...w ","_##class(web.DHCADVJSONCOMMON).getJsonTreeClosedSign()
	..w "}"

  	q ""
}

/// Description: 获取[该id树以上的所有父节点]
/// Creator:     CongYue
/// CreateDate:  2019-07-09
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 ItmID:节点id
/// w ##class(web.DHCADVEVTWORKFLOW).GetItmLevCon("20||3")
ClassMethod GetItmLevCon(ItmID As %String) As %String
{
	N (ItmID)
	Q:ItmID'["||" ItmID
	S LastItmID=$p(^DHCADREVTWFI(+ItmID,"ADREWI",$p(ItmID,"||",2)),"^",6)  /// 上一级ID
	Q:LastItmID=0 ItmID
	
	S LastItmID=..GetItmLevCon(LastItmID)
	Q LastItmID_"^"_ItmID
}

/// Description: 保存[工作流 关联 事件等级维护]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:		 DHC_AdrEvtWorkFlowLink
/// Input:  	 DataList:以字符"^"分割,格式为:id^关联表id（工作流主表id或者工作流子表id）^事件等级id（1,2,3,4）
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SaveEvtWorkFlowLink("^10^1")
ClassMethod SaveEvtWorkFlowLink(DataList As %String) As %String
{
	N (DataList)
	S Err=0
	S len=$L(DataList,"&&")
	F i=1:1:len D
	.S TmpStr=$p(DataList,"&&",i)
	.S Err=..CheckRepeatDealLink(TmpStr)   /// 重复性判断
	.Q:Err'=0
	.I $p(TmpStr,"^",1)'="" D
	..S Err=..UpdEvtWorkFlowLink(TmpStr)
	.E  D
	..S Err=..InsEvtWorkFlowLink(TmpStr)
	Q Err
}

/// Description: 保存[检查 事件分级 是否重复]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:		 DHC_AdrEvtWorkFlowLink
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).CheckRepeatDealLink("^sd1^器械填报^器械^Y")
ClassMethod CheckRepeatDealLink(TmpStr As %String) As %String
{
	N (TmpStr)
	S EWLID=$p(TmpStr,"^",1)   	
	S EWLLinkDr=$p(TmpStr,"^",2)   	/// 工作流父子表id
	S EWLLevel=$p(TmpStr,"^",3)   	/// 等级 id
	S EWLHospDr=$p(TmpStr,"^",4) 
	S Flag=0
	S ID=""
	F  S ID=$o(^DHCADREVTWFL(0,"LinkDr",EWLLinkDr,ID))  Q:+ID=0  D
	.S Level=$p(^DHCADREVTWFL(ID),"^",2)
	.S HospDr=$p(^DHCADREVTWFL(ID),"^",3)
	.S:(EWLLevel=Level)&&(EWLHospDr=HospDr) Flag="-1"
	.Q:Flag="-1"
	Q Flag
}

/// Description: 更新[工作流 关联 事件等级维护]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:		 DHC_AdrEvtWorkFlowLink
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdEvtWorkFlowLink("1^器械填报^器械填报^器械^Y")
ClassMethod UpdEvtWorkFlowLink(DataList As %String) As %String
{
	N (DataList)
	S EWLID=$p(DataList,"^",1)   	
	S LinkDr=$p(DataList,"^",2)   	/// 工作流父子表id
	S Level=$p(DataList,"^",3)   	/// 等级 id
	S HospDr=$p(DataList,"^",4)
	&SQL(Update DHC_AdrEvtWorkFlowLink Set ADREWL_LinkDr=:LinkDr, ADREWL_RepLevel=:Level,ADREWL_HospDr=:HospDr WHERE ADREWL_RowID=:EWLID)
 	Q SQLCODE
}

/// Description: 增加[工作流 关联 事件等级维护]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:	 	 DHC_AdrEvtWorkFlowLink
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).InsEvtWorkFlowLink("^器械填报^器械填报^器械^Y")
ClassMethod InsEvtWorkFlowLink(DataList As %String) As %String
{
	N (DataList)
	S EWLID=$p(DataList,"^",1)   	
	S LinkDr=$p(DataList,"^",2)   	/// 工作流父子表id
	S Level=$p(DataList,"^",3)   	/// 等级 id
	S HospDr=$p(DataList,"^",4)
 	&SQL(INSERT INTO DHC_AdrEvtWorkFlowLink(ADREWL_LinkDr,ADREWL_RepLevel,ADREWL_HospDr) VALUES(:LinkDr,:Level,:HospDr))
 	Q SQLCODE
}

/// Description: 删除[工作流 关联 事件等级维护]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:	 	 DHC_AdrEvtWorkFlowLink
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).DelEvtWorkFlowLink("1")
ClassMethod DelEvtWorkFlowLink(EWLID As %String) As %String
{
	N (EWLID)
	&SQL(Delete From DHC_AdrEvtWorkFlowLink Where ADREWL_RowID=:EWLID)
	Q SQLCODE
}

/// Description: 查询[工作流 关联 事件等级维护]
/// Creator:     CongYue
/// CreateDate:  2019-07-03
/// Table:		 DHC_AdrEvtWorkFlowLink
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).QueryEvtWorkFlowLink("12","1","")
ClassMethod QueryEvtWorkFlowLink(LinkDr As %String, HospDr = "") As %String
{
	N (LinkDr,HospDr)
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S h=0,count=0	
    Q:LinkDr="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S ID=""
	F  S ID=$o(^DHCADREVTWFL(0,"LinkDr",LinkDr,ID)) Q:+ID="0"  D
	.S LevelDr=$p(^DHCADREVTWFL(ID),"^",2)
	.S Level=$S(LevelDr="1":"一级",LevelDr="2":"二级",LevelDr="3":"三级",LevelDr="4":"四级",1:"")
	.S LevelHospDr=$p(^DHCADREVTWFL(ID),"^",3) // 医院
	.Q:(HospDr'="")&&(LevelHospDr'="")&&(HospDr'=LevelHospDr)
	.S h=h+1
	.S TempStr=ID_"^"_LinkDr_"^"_LevelDr_"^"_Level_"^"_LevelHospDr
	.S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEvtWorkFlowLink",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	///转换数据为Json格式
	S Title="ID^LinkDr^LevelDr^Level^HospDr"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEvtWorkFlowLink",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","QueryEvtWorkFlowLink",pid,index))
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 不良事件工作流主子表删除公用---删除关联表（获取删除id相关的工作流项目id，所有子数据id）
/// Creator:     CongYue
/// CreateDate:  2021-01-29
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 ID:工作流id或者工作流项目id
/// w ##class(web.DHCADVEVTWORKFLOW).GetDelItmInfo("","")
ClassMethod GetDelItmInfo(ID As %String, List) As %String
{
	N (ID,List)
	S Parref="0"
	F  S Parref=$o(^DHCADREVTWFI(0,"ItmLevelDr",ID,Parref)) Q:+Parref="0"  D
	.S SubID=""
	.F  S SubID=$o(^DHCADREVTWFI(0,"ItmLevelDr",ID,Parref,SubID)) Q:SubID=""  D
	..S ItmID=Parref_"||"_SubID
	..S:(List'="")&&(List'[ItmID) List=List_"^"_ItmID
	..S:List="" List=ItmID
	..I ($D(^DHCADREVTWFI(0,"ItmLevelDr",ItmID)))&&(ItmID["||") D
	...S List=##class(web.DHCADVEVTWORKFLOW).GetDelItmInfo(ItmID,List)
	Q List
}

/// Description: 不良事件工作流主子表删除公用---删除关联表（工作流与工作流项目关联表信息）
/// Creator:     CongYue
/// CreateDate:  2021-01-29
/// Table:		 DHC_AdrEvtWorkFlowItm,DHC_AdrWorkFlowGrant,DHC_AdrEvtWorkFlowLink
/// Input:  	 ID:删除数据id（工作流id或者工作流项目id）
/// w ##class(web.DHCADVEVTWORKFLOW).DelRelatInfo("")
ClassMethod DelRelatInfo(ID As %String) As %String
{
	N (ID)
	S Err=0
	S DataList=ID_"^"_##class(web.DHCADVEVTWORKFLOW).GetDelItmInfo(ID,"")
	S Len=$L(DataList,"^")
	F i=1:1:Len D
	.S DelDr=$p(DataList,"^",i)
	.Q:DelDr=""
	.I (i'=1)&&($d(^DHCADREVTWFI(+DelDr,"ADREWI",$p(DelDr,"||",2))))  D
	..&SQL(Delete From DHC_AdrEvtWorkFlowItm Where ADREWI_RowID=:DelDr)
	..S:+$g(SQLCODE)'=0 Err="-11"
	.Q:Err'=0
	.I $D(^DHCADREVTWFGR(0,"ItmDr",DelDr))  D
	..&SQL(Delete From DHC_AdrWorkFlowGrant Where ADRWFG_Itm_Dr=:DelDr)
	..S:+$g(SQLCODE)'=0 Err="-12"
	.Q:Err'=0
	.I $D(^DHCADREVTWFL(0,"LinkDr",DelDr))  D
	..&SQL(Delete From DHC_AdrEvtWorkFlowLink Where ADREWL_LinkDr=:DelDr)
	..S:+$g(SQLCODE)'=0 Err="-13"
	.Q:Err'=0

	Q Err
}

/// Description: 查询工作流项目对应表单元素
/// Creator:     CongYue
/// CreateDate:  2021-03-25
/// Table:		 DHC_AdrEvtWorkFlow,DHC_AdvFormDic
/// Input:  	 Code:新增工作流代码 , Desc:新增工作流描述 , TypeDr:新增工作流关联报告类型, CopyID:复制工作流ID
/// w ##class(web.DHCADVEVTWORKFLOW).jsonFormDic("21||2","panel")
ClassMethod jsonFormDic(WFIID As %String, DicType As %String) As %String
{
	n (WFIID,DicType)
	S EventTypeDr=$p(^DHCADREVTWF(+WFIID),"^",3) //类型
	S EventTypeCode=""
	S:(EventTypeDr'="")&&(EventTypeDr'["||") EventTypeCode=$p(^DHCMEDADREVT(EventTypeDr),"^",1)
	S:(EventTypeDr'="")&&(EventTypeDr["||") EventTypeCode=$p(^DHCMEDADREVTI(+EventTypeDr,"MADREVI",$p(EventTypeDr,"||",2)),"^",1)
	S FormNameID=""
	S:$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(EventTypeCode))) FormNameID=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(EventTypeCode),""))

	Q:FormNameID="" ""
	s version=$o(^User.DHCAdvFormI("IndexNameVersion",FormNameID,""),-1)

	Q:version="" ""
	s count = 0
	w "["
	s ID=""
	F  s ID=$o(^User.DHCAdvFormI("IndexNameVersion",FormNameID,version,ID)) Q:ID=""  D
	.s itmData=^User.DHCAdvFormD(ID)
	.s FormDicId=$LIST(itmData,4)
	.Q:FormDicId=""
	.Q:'$d(^User.DHCAdvFormDicD(FormDicId))
	.s FormDicData=^User.DHCAdvFormDicD(FormDicId)
	.s itmCode=$LIST(FormDicData,2)     /// 元素代码
	.s itmType=$LIST(FormDicData,3)     /// 元素类型
	.Q:itmType="fieldset"  /// 元素类型
	.Q:(DicType'="")&&(DicType'=itmType)
	.s itmTitle=$LIST(FormDicData,4)    /// 元素描述
	.s:itmTitle["<span" itmTitle=$p(itmTitle,"<span",1)
	.s:itmTitle["&nbsp" itmTitle=$p(itmTitle,"&nbsp",1)
	.s tmp=FormDicId_"^"_itmTitle_"^"_itmCode
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	w "]"
	Q ""
}

/// Description: 保存[工作流 关联 时限维护]
/// Creator:     CongYue
/// CreateDate:  2021-03-23
/// Table:		 DHC_AdvGenericRelation
/// Input:  	 DataList:以字符"^"分割,格式为:id^关联项类型（TIME）^关联表id（工作流子表id）^ 数据（如果类型是TIME  数据则为 时长$$事件等级）^ 属性（如果类型是TIME  属性则为 事件等级）^备注
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).SaveWFUniversal("^TIME^51||1^11^1^")
ClassMethod SaveWFUniversal(DataList As %String) As %String
{
    N (DataList)
  	S $Zt="Err"
  	TStart
  	S Ret=0
  	S Len=$L(DataList,"&&")
  	F i=1:1:Len Q:Ret'=0  D
  	.Q:Ret<0
  	.S Str=$p(DataList,"&&",i)
  	.S Ret=..CheckRepeatWFUniversal(Str)   /// 重复性判断
	.Q:Ret'=0
  	.S Ret=..SaveOrUpdate(Str)
	I Ret'=0 TRollback
	Q:Ret'=0 Ret
	TCOMMIT
	Q Ret
Err
	TRollback
	W $ze
	Q -1
}

/// Description: 保存[检查 时限维护 是否重复]
/// Creator:     CongYue
/// CreateDate:  2021-03-23
/// Table:		 DHC_AdvGenericRelation
/// Return: 	 重复 -1,不重复 0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).CheckRepeatWFUniversal("^TIME^51||1^11^1^")
ClassMethod CheckRepeatWFUniversal(TmpStr As %String) As %String
{
	N (TmpStr)
	S ID=$p(TmpStr,"^",1)   	
	S Type=$p(TmpStr,"^",2)   	
	S LinkDr=$p(TmpStr,"^",3)   	
	S Data=$p(TmpStr,"^",4)
	S Attribute=$p(TmpStr,"^",5)
	S Remark=$p(TmpStr,"^",6)
	S HospDr=$p(TmpStr,"^",7)
	S Flag=0
	S UniID=""
	F  S UniID=$o(^User.DHCAdvGenericRelationI("IndexTypeLink",Type," "_LinkDr,UniID))  Q:(+UniID=0)||(Flag="-1")  D
	.S Datalist=^User.DHCAdvGenericRelationD(UniID)
	.S UniData=$lg(Datalist,4)
	.S UniAttribute=$lg(Datalist,5)
	.S UniHospDr=$lg(Datalist,7) // 医院
	.S:(Type="TIME")&&(UniID'=ID)&&(UniAttribute=Attribute)&&(HospDr=UniHospDr) Flag="-1"
	.S:(Type="FORMDIC")&&(UniID'=ID)&&(UniData=Data)&&(HospDr=UniHospDr) Flag="-1"
	.Q:Flag="-1"

	Q Flag
}

/// Description: 更新[工作流 关联 时限维护]
/// Creator:     CongYue
/// CreateDate:  2021-03-23
/// Table:		 DHC_AdvGenericRelation
/// Input:  	 DataList:以字符"^"分割,格式为:id^代码^描述^类型描述^是否可用
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).UpdWFUniversal("^51||1^TIME^1$$1")
ClassMethod SaveOrUpdate(TmpStr As %String) As %String
{
	N (TmpStr)
	S ID=$p(TmpStr,"^",1)   	
	S Type=$p(TmpStr,"^",2)   	
	S LinkDr=$p(TmpStr,"^",3)   	
	S Data=$p(TmpStr,"^",4)
	S Attribute=$p(TmpStr,"^",5)
	S Remark=$p(TmpStr,"^",6)
	S HospDr=$p(TmpStr,"^",7)
	I +ID=0 D
	.S Obj=##class(User.DHCAdvGenericRelation).%New()
	E  D
	.S Obj=##class(User.DHCAdvGenericRelation).%OpenId(ID)
	.D Obj.%Reload()
	S Obj.Type=Type
	S Obj.LinkDr=LinkDr
	S Obj.Data=Data
	S Obj.Attribute=Attribute
	S Obj.Remark=Remark
	I +HospDr'=0 D
 	.D Obj.HospDrSetObjectId(HospDr)
	S Sc=Obj.%Save()
	I $$$ISERR(Sc) Q -2
	Q 0
}

/// Description: 删除[工作流 关联 时限维护]
/// Creator:     CongYue
/// CreateDate:  2021-03-23
/// Table:	 	 DHC_AdvGenericRelation
/// Input:    	 数据id
/// Return: 	 删除成功 0,删除失败 非0
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).DelWFUniversal("1")
ClassMethod DelWFUniversal(ID As %String) As %String
{
	N (ID)
	S Sc=##class(User.DHCAdvGenericRelation).%DeleteId(ID)
 	I $$$ISERR(Sc) Q Sc
	Q 0
}

/// Description: 查询[工作流 关联 时限维护]
/// Creator:     CongYue
/// CreateDate:  2021-03-23
/// Table:		 DHC_AdvGenericRelation
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVEVTWORKFLOW).QueryWFUniversal("FORMDIC","14||1")
ClassMethod QueryWFUniversal(Type As %String, LinkDr As %String, HospDr = "") As %String
{
	N (Type,LinkDr,HospDr)
    
	S Count=0,Cat=""
	w "{""rows"":["
	S ID=""
	F  S ID=$o(^User.DHCAdvGenericRelationI("IndexTypeLink",Type," "_LinkDr,ID))  Q:+ID=0  D
	.S Datalist=^User.DHCAdvGenericRelationD(ID)
	.S Data=$lg(Datalist,4)
	.S Attribute=$lg(Datalist,5)
	.S Remark=$lg(Datalist,6)
	.S UniHospDr=$lg(Datalist,7) // 医院
	.Q:(HospDr'="")&&(UniHospDr'="")&&(HospDr'=UniHospDr)
	.S Level="",DicCode="",DicDesc="",DicID=""
	.S:(Type="TIME") Level=$S(Attribute="1":"一级",Attribute="2":"二级",Attribute="3":"三级",Attribute="4":"四级",1:"")
	.I Type="FORMDIC" D
	..S DicCode =Data        /// 元素代码
	..S DicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(DicCode),""))  
	..Q:DicID=""
	..S DicData=^User.DHCAdvFormDicD(DicID)
	..S DicDesc=$LIST(DicData,4)          /// 元素描述
	..S:DicDesc["<span" DicDesc=$p(DicDesc,"<span",1)
	..S:DicDesc["&nbsp" DicDesc=$p(DicDesc,"&nbsp",1)
	.S Count=Count+1
	.W $case(Count,1:"",:",")
	.S tmpObj={}
	.S tmpObj.ID=ID
	.S tmpObj.Type=Type
	.S tmpObj.LinkDr=LinkDr
	.S tmpObj.Data=Data
	.S tmpObj.Attribute=Attribute 
	.S tmpObj.Level=Level 
	.S tmpObj.Remark=Remark 
	.S tmpObj.DicID=DicID 
	.S tmpObj.DicCode=DicCode
	.S tmpObj.DicDesc=DicDesc
	.S tmpObj.HospDr=UniHospDr
	.W tmpObj.%ToJSON()
	W "],""total"":"_Count_"}"
	Q ""
}

/// Description: 工作流复制--工作流数据保存（复制工作流及项目及相关权限关联数据）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_AdrEvtWorkFlow,DHC_AdrEvtWorkFlowItm,DHC_AdrWorkFlowGrant,DHC_AdrEvtWorkFlowLink
/// Input:  	 Code:新增工作流代码 , Desc:新增工作流描述 , TypeDr:新增工作流关联报告类型, CopyID:复制工作流ID
/// w ##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlow("2","2","106||2","51")
ClassMethod CopyEvtWorkFlow(Code As %String, Desc As %String, TypeDr As %String, CopyID As %String, HospDr As %String) As %String
{
	N (Code,Desc,TypeDr,CopyID,HospDr)
	
	S $zt="err"
	Q:$D(^DHCADREVTWF(0,"Code",$$ALPHAUP^SSUTIL4(Code))) "1"  ; 判断代码是否存在
	S ret=0
	TStart
	S WFObj=##class(User.DHCAdrEvtWorkFlow).%New()
	S WFObj.ADREWCode=Code
	S WFObj.ADREWDesc=Desc
	S WFObj.ADREWEventDr=TypeDr
	S WFObj.ADREWActive="Y"
	D WFObj.%Save()
	/// 保存权限
 	S Ret=##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlowGrant(WFObj.%Id(),CopyID)
	I Ret'=0 TRollback
	Q:Ret'=0 Ret
	/// 保存工作流项目-工作流子表数据
 	S Ret=##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlowItm(WFObj.%Id(),CopyID)
	I Ret'=0 TRollback
	Q:Ret'=0 Ret
	
 	S hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_AdrEvtWorkFlow",WFObj.%Id(),HospDr)
	I hospflag'=0 TRollback
	Q:hospflag'=0 "管控数据保存失败"
	
	TCOMMIT
	Q Ret
err
	TRollback
	Q -1
}

/// Description: 工作流复制-工作流项目保存（保存工作流子表数据）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:  	 Code:新增工作流代码 , Desc:新增工作流描述 , TypeDr:新增工作流关联报告类型, CopyID:复制工作流ID
/// w ##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlowItm()
ClassMethod CopyEvtWorkFlowItm(WorkFlowID As %String, CopyID As %String) As %String
{
	N (WorkFlowID,CopyID)
	S Flag=0
	S Pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowItm",Pid)
	S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowItm",Pid,CopyID)=WorkFlowID
	S Sub=""
	F  S Sub=$o(^DHCADREVTWFI(CopyID,"ADREWI",Sub))  Q:(Sub="")||(Flag="-1")  D
	.S Code=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",1) //代码
	.S Desc=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",2) //描述
	.S OrderNo=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",3) //顺序号
	.S Active=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",4) //是否可用
	.S Level=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",5) //级别
	.S Levelrowid=$p(^DHCADREVTWFI(CopyID,"ADREWI",Sub),"^",6) //上一级别的rowid
	.S:$d(^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowItm",Pid,Levelrowid)) Levelrowid=^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowOth",pid,Levelrowid)
	.S WFItmObj=##class(User.DHCAdrEvtWorkFlowItm).%New()
	.D WFItmObj.ADREWIADREWParrefSetObjectId(WorkFlowID) 
	.S WFItmObj.ADREWIChildSub=Sub
	.S WFItmObj.ADREWICode=Code
	.S WFItmObj.ADREWIDesc=Desc
	.S WFItmObj.ADREWIOrderNo=OrderNo
	.S WFItmObj.ADREWIActiveFlag="Y"
	.S WFItmObj.ADREWILevel=Level
	.S WFItmObj.ADREWILevelRowID=Levelrowid
	.S Sc=WFItmObj.%Save()
 	.S:$$$ISERR(Sc) Flag="-1"
 	.Q:Flag="-1"
	.S ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowItm",Pid,CopyID_"||"_Sub)=WFItmObj.%Id()
	.S Flag=..CopyEvtWorkFlowGrant(WFItmObj.%Id(),CopyID_"||"_Sub)
	.S:Flag'=0 Flag="-1"
	.Q:Flag="-1"
	.S Flag=..CopyEvtWorkFlowLink(WFItmObj.%Id(),CopyID_"||"_Sub)
	.S:Flag'=0 Flag="-1"
	.Q:Flag="-1"
	k ^TMP("DHCADV","web.DHCADVEVTWORKFLOW","CopyEvtWorkFlowItm",Pid)
	Q Flag
}

/// Description: 工作流复制-权限保存（保存工作流相关权限信息）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_AdrWorkFlowGrant
/// Input:  	 Code:新增工作流代码 , Desc:新增工作流描述 , TypeDr:新增工作流关联报告类型, CopyID:复制工作流ID
/// w ##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlowGrant()
ClassMethod CopyEvtWorkFlowGrant(WorkFlowID As %String, CopyID As %String) As %String
{
	N (WorkFlowID,CopyID)
	S Flag=0
	S Sub=""
	S GrantID=""
	F  S GrantID=$o(^DHCADREVTWFGR(0,"ItmDr",CopyID,GrantID)) Q:(GrantID="")||(Flag="-1")  D
	.S ParRefDr=$p(^DHCADREVTWFGR(GrantID),"^",1) //
	.S ItmDR=$p(^DHCADREVTWFGR(GrantID),"^",2) //
	.S Type=$p(^DHCADREVTWFGR(GrantID),"^",3) //类型
	.S Pointer=$p(^DHCADREVTWFGR(GrantID),"^",4) //指针
	.S WFGrantObj=##class(User.DHCAdrWorkFlowGrant).%New()
	.S WFGrantObj.ADRWFGParRefDr=ParRefDr 
	.S WFGrantObj.ADRWFGItmDr=WorkFlowID
	.S WFGrantObj.ADRWFGType=Type
	.S WFGrantObj.ADRWFGPointer=Pointer
	.S Sc=WFGrantObj.%Save()
 	.S:$$$ISERR(Sc) Flag="-1"
 	.Q:Flag="-1"
	Q Flag
}

/// Description: 工作流复制-绑定等级信息保存（保存工作流关联数据）
/// Creator:     CongYue
/// CreateDate:  2021-03-19
/// Table:		 DHC_AdrEvtWorkFlowLink
/// Input:  	 Code:新增工作流代码 , Desc:新增工作流描述 , TypeDr:新增工作流关联报告类型, CopyID:复制工作流ID
/// w ##class(web.DHCADVEVTWORKFLOW).CopyEvtWorkFlowLink()
ClassMethod CopyEvtWorkFlowLink(WorkFlowID As %String, CopyID As %String) As %String
{
	N (WorkFlowID,CopyID)
	S Flag=0
	S ID=""
	F  S ID=$o(^DHCADREVTWFL(0,"LinkDr",CopyID,ID)) Q:(+ID="0")||(Flag="-1")  D
	.S LevelDr=$p(^DHCADREVTWFL(ID),"^",2)
	.S WFLinkObj=##class(User.DHCAdrEvtWorkFlowLink).%New()
	.S WFLinkObj.ADREWLLinkDr=WorkFlowID
	.S WFLinkObj.ADREWLRepLevel=LevelDr
	.S Sc=WFLinkObj.%Save()
 	.S:$$$ISERR(Sc) Flag="-1"
 	.Q:Flag="-1"
	Q Flag
}

}
