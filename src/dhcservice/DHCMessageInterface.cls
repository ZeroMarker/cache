/// dhcservice.DHCMessageInterface
Class dhcservice.DHCMessageInterface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCMessageService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Send
Method Send(Context, ActionTypeCode, FromUserRowId, EpisodeId = "", OrdItemId = "", ToUserRowId = "", OtherInfoJson As %String(MAXLEN=1000) = "", LocId = "", EffectiveDays = "", CreateLoc = "") As %String [ WebMethod ]
{
	Set rtn =  ##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId, OrdItemId, ToUserRowId, OtherInfoJson,LocId,EffectiveDays,CreateLoc)
	Quit rtn
}

Method FindByUser(UserId = "", Start, Count) As %String [ WebMethod ]
{
	Set ^Wanghc = UserId_","_Start_","_Count
	;Set ^Wanghc("UserId")=$g(%request.Data("UserId",1))
	;Set rtn = ##class(websys.Query).GetJson("websys.DHCMessageDetailsMgr", "FindInfo", Start, Count,.total)
	Set rtn = ##class(ext.util.JsonObject).ClassQuery2JsonQ("websys.DHCMessageDetailsMgr","FindInfo",Start,Count,.total,UserId)
	Quit "{""total"":"_total_",""rows"":"_rtn_"}"
}

Method Find(Start, Count) As %String [ WebMethod ]
{
	;websys.DHCMessageDetailsMgr
	;FindInfo
	;Set ^Wanghc("Find",1) = Start_","_Count
	Set CN="",MN=""
	If ($g(%request.Data("EncMethod",1))'=""){
		 Set EncMethod = $g(%request.Data("EncMethod",1))
		 Set CN = $p(EncMethod,":")
		 Set MN = $p(EncMethod,":",2)
	}Else{
		Set CN = $g(%request.Data("ClassName",1))
		Set MN = $g(%request.Data("QueryName",1))
	}
	If (CN="") || (MN="") Quit ""
	;Set ^Wanghc("Find",2) = CN_":"_MN_","_Start_","_Count
	Set rtn = ##class(websys.Query).GetJson(CN, MN, Start, Count,.total)
	;Set rtn = ##class(ext.util.JsonObject).ClassQuery2JsonQ("websys.DHCMessageDetailsMgr","FindInfo",Start,Count,.total,159)
	Quit "{""total"":"_total_",""rows"":"_rtn_"}"
}

Method GetCountAndBizIds(UserCode, ActionCodes) As %String [ WebMethod ]
{
	q:UserCode="" "[]"
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),""))
	set rtn=##class(ext.util.JsonObject).ClassQuery2JsonQ("websys.DHCMessageDetailsMgr","FindCountAndBizIds",0,100,.total,UserId,ActionCodes,"N")
	q rtn
}

/// 对于能获取到ContentId消息 对外改变消息的读状态或处理状态的接口 <br>
/// Model 模式 "R" 根据ContentId和UserCode找到消息明细　变成已读 若是读即处理也变成已处理<br>
///            "E" 如果是需处理消息,将根据ContentId处理消息 处理人为后面参数UserCode<br>
/// ContentId 消息内容表Id <br>
/// UserCode 用户代码  Model为R 这个人的这条消息记为已读  Model为E 那么此为处理人code <br>
/// rtn  -1 ContentId不是有效的消息内容表Id <br>
/// rtn  -2 UserCode不是有效的用户Code <br>
/// rtn  -3 该消息并未发送给此用户 <br>
/// rtn  -4 Model不正确 <br>
/// rtn  -102 消息已执行过 <br>
/// rtn  1 成功 <br>
Method ReadOrExec(Model = "R", ContentId = "", UserCode = "") As %String [ WebMethod ]
{
	q:(ContentId'>0)||'$d(^websys.DHCMessageContentD(ContentId)) -1
	q:UserCode="" -2
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),""))
	q:UserId'>0 -2
	set date=+$h,time=$p($h,",",2)
	if Model="R" {
		Set DetailsId = $O(^websys.DHCMessageDetailsI("ContentUser",ContentId,UserId,""))
		q:DetailsId'>0 -3
		set rtn=##class(websys.DHCMessageDetailsMgr).SaveReadInfo(DetailsId,date,time)
		q:rtn=DetailsId 1
		q rtn
	}elseif Model="E" {
		Set rtn = ##class(websys.DHCMessageContentMgr).SaveExecInfo(ContentId,UserId,date,time)
		q:rtn=ContentId 1
		q rtn
	}else{
		q -4
	}
}

/// rtn  -1 ContentId不是有效的消息内容表Id <br>
/// rtn  -2 UserCode不是有效的用户Code <br>
/// rtn  -3 该消息并未发送给此用户 <br>
Method Read(ContentId = "", UserCode = "") As %String [ WebMethod ]
{
	set rtn=..ReadOrExec("R",ContentId,UserCode)
	q rtn
}

Method Exec(ContentId = "", UserCode = "") As %String [ WebMethod ]
{
	set rtn=..ReadOrExec("E",ContentId,UserCode)
	q rtn
}

Method ExecAll(MsgDetailsId, ExecUserDr = "", ExecDate = "", ExecTime = "") As %String [ WebMethod ]
{
	set rtn=##class(websys.DHCMessageInterface).ExecAll(MsgDetailsId,ExecUserDr,ExecDate,ExecTime)
	q rtn
}

}
