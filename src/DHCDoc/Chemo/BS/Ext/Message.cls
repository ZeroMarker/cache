/// CTOR: QP
/// DATE: 2020-07-07
/// DESC: 化疗方案审核消息提示类
Class DHCDoc.Chemo.BS.Ext.Message Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-17
/// DESC: 发送化疗方案审核消息
/// 
/// OUT : 成功返回1
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Message).Send()
ClassMethod Send(Type, PDAID, UserID, LocID, Status = "", InHosp = "")
{
	//s $ZT="Err"
	s ^BS.DOC.Chemo.Temp("Send","InPara")=$lb(Type,PDAID,UserID,LocID,Status,InHosp)
	//配置数据检测
	S isCheck=..CheckConfigData()
	Q:isCheck'=1 isCheck
	
	//参数处理
	Q:(PDAID="")||(Type="")||(UserID="")||(LocID="") -1_"^参数出错！"
	s PDID=+PDAID
	s Sub=$p(PDAID,"||",2)
	i InHosp="" s InHosp=##class(DHCDoc.Chemo.COM.Func2).GetDepHosp(LocID)
	
	i Status="" s Status=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",3)
	Q:Status="" -2_"^审核状态为空！"
	
	//消息字段处理
	s ApplyUser=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",1)
	s linkParam=""
	s BizObjId=PDAID_"-"_Status
	s Context=""
	s FromUserRowId=UserID
	s EpisodeId=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",4)
	s OrdItemId=""	//
	s EffectiveDays=""
	i Type="APP" {
		s ToUserRowId=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",6)
		Q:ToUserRowId="" "-2^审核为空！"
		//不做科室的处理，已经指定了接受用户
		s ToLocRowId=""	//$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",34)
		;Q:ToLocRowId="" "-2^审核科室为空！"
		;s ToLocRowId=ToLocRowId_"|OnlyFlag"
		s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","AppAudit")
		s linkParam="PDAID="_PDAID_"&Type=KS"
		s Context=..BuildContext(Type,PDAID,Status,UserID)
	} elseif (Type="KS") {
		s ToUserRowId=##class(DHCDoc.Chemo.BS.Data).GetData("BD","YJKDoc",InHosp)
		s ToUserRowId=##class(DHCDoc.Chemo.COM.Func).LinkString(ToUserRowId,",","^")
		s ToLocRowId=""
		s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","Audit")
		i Status="RS" {
			s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","AuditResult")
			s ToUserRowId=ApplyUser
		}
		s linkParam="PDAID="_PDAID_"&Type=YJK"
		s Context=..BuildContext(Type,PDAID,Status,UserID)
		
	} elseif (Type="YJK") {
		s ToUserRowId=ApplyUser
		s ToLocRowId=""
		s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","AuditResult")
		s Context=..BuildContext(Type,PDAID,Status,UserID)
	} else {}
	
	i ActionType'="1193" {	
		s OtherInfoJson="{""BizObjId"":"""_BizObjId_"""}"
	} else {
		s OtherInfoJson="{""linkParam"":"""_linkParam_""",""BizObjId"":"""_BizObjId_"""}"
	}
	s CreateLoc=LocID
	
	s rtn=##class(websys.DHCMessageInterface).Send(Context,ActionType,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
	s ^BS.DOC.Chemo.Temp("Send","Result")=rtn
	s ^BS.DOC.Chemo.Temp("Send","SendPara")=$lb(ActionType,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
	s ^BS.DOC.Chemo.Temp("Send","Context")=Context
	
	Q:rtn<=0 rtn
	
	//执行消息
	s rtn=..Exec(Type,PDAID,UserID,InHosp)
	Q:rtn<=0 rtn
	
	Q 1
	
Err
	Q -1_"^程序解释出错！"
}

/// CTOR: QP
/// DATE: 2020-07-17
/// DESC: 执行化疗方案审核消息
/// 
/// OUT : 1 成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Message).Exec()
ClassMethod Exec(Type, PDAID, UserID, InHosp = "")
{
	//配置数据检测
	S isCheck=..CheckConfigData()
	Q:isCheck'=1 isCheck
	S ActionType=""
	//参数处理
	Q:(PDAID="")||(Type="")||(UserID="") -1_"^参数出错！"
	s PDID=+PDAID
	s Sub=$p(PDAID,"||",2)
	s ApplyUser=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",1)
	//执行消息
	i (Type="APP") {
		Q 1
	} elseif (Type="KS") {
		//执行PDID-A的消息
		//s ToUserId=ApplyUser
		s ObjectId=PDAID_"-A"
		s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","AppAudit")
		
	} elseif (Type="YJK") {
		//执行PDID-S的消息
		//s ToUserId=ApplyUser
		s ObjectId=PDAID_"-S"
		s ActionType=##class(DHCDoc.Chemo.BS.Data).GetData("OS","Audit")
	} else {}
	s ToUserId=""
	s EpisodeId=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",4)
	s OEOrdItemId=""
	s ExecUserDr=UserID
	s ExecDate=+$H
	s ExecTime=$p($h,",",2)
	s OtherParams=""
	s rtn=##class(websys.DHCMessageInterface).Exec(ToUserId,ActionType,EpisodeId,OEOrdItemId,ObjectId,ExecUserDr ,ExecDate ,ExecTime,OtherParams)
	i rtn=-102 s rtn=1	//若消息执行过，则也表示成功
	q rtn
}

/// CTOR: QP
/// DATE: 2020-07-20
/// DESC: 组织数据内容
/// 
/// OUT : >0 成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Message).BuildContext()
ClassMethod BuildContext(Type, PDAID, Status, UserID)
{
	s mRtn=""
	S PDID=+PDAID
	S Sub=$p(PDAID,"||",2)
	s ApplyUser=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",1)
	s Reason=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",12)
	s ApplyUser=$P(^SSU("SSUSR",ApplyUser),"^",2)
	s ExecUser=$P(^SSU("SSUSR",UserID),"^",2)
	i Type="APP" {
		s mRtn=ApplyUser_"申请的化疗方案，需要您审核！"
	} elseif (Type="KS") {
		s mRtn=ApplyUser_"申请的化疗方案，需要您审核！"
		i Status="RS" {
			s mRtn="您申请的化疗方案，被"_ExecUser_"拒绝了,拒绝原因："_Reason_"！"
		}
	} elseif (Type="YJK") {
		s mRtn="的化疗方案，被"_ExecUser_"通过了！"
		i Status="RY" {
			s mRtn="您申请的化疗方案，被"_ExecUser_"拒绝了,拒绝原因："_Reason_"！"
		}
	} else {}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-20
/// DESC: 配置数据检测
/// 
/// OUT : >0 成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Message).CheckConfigData()
ClassMethod CheckConfigData()
{
	
	;Q:$g(^CF.DOC.Chemo.Local("BD","AuditLoc"))="" "-3^审核科室未配置！"
	Q:$g(^CF.DOC.Chemo.Local("BD","AuditDoc"))="" "-3^审核医生未配置！"
	;Q:$g(^CF.DOC.Chemo.Local("BD","YJKLoc"))="" "-3^药剂科未配置！"
	Q:$g(^CF.DOC.Chemo.Local("BD","YJKDoc"))="" "-3^药剂科有审核权限的医生未配置！"
	Q:$g(^CF.DOC.Chemo.Local("OS","AppAudit"))="" "-3^化疗方案审核消息代码未配置！"
	Q:$g(^CF.DOC.Chemo.Local("OS","Audit"))="" "-3^化疗方案审核消息代码未配置！"
	Q:$g(^CF.DOC.Chemo.Local("OS","AuditResult"))="" "-3^化疗方案审核结果消息代码未配置！"
	
	Q 1
}

}
