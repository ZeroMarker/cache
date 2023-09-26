/// Description:消息管理公用方法
/// Creator:why
/// CreatDate:2020-04-23
/// 
Class web.CSSDHUI.Common.Message Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// @param: Context 		信息文本内容		可为空,通过入参生成相关内容
/// @param: ActionTypeCode  信息的动作类型代码  websys.DHCMessageActionType表的code字段值
/// @param: FormUserRowId   信息发出人	 		SS_User->SSUSR_rowid, 如果消息发出人不在his人员表中,可直接传用户姓名。格式:"^Name"
/// @param: EpisodeId 		患者就诊Id	 		PA_Adm->PAADM_RowId
/// @param: OrdItemId 		医嘱明细表Id        OE_OrdItem->OEORI_RowId
/// @param: ToUserRowId     信息发给人			SS_User->SSUSR_rowid  强制把消息发给该用户
/// @param: OtherInfoJson   其它业务相关对象    Json格式,一些其它信息,如link等{"link":"x.csp?type=a&id=1"}
/// @param: ToLocRowId		指定那个科室收到消息		科室串 1^316
/// 如果成功返回0
ClassMethod Send(Context, ActionTypeCode, FromUserRowId, EpisodeId = "", OrdItemId = "", ToUserRowId As %String(MAXLEN=30000) = "", OtherInfoJson As %String(MAXLEN=30000) = "", ToLocRowId As %String(MAXLEN=30000) = "", EffectiveDays = "", CreateLoc = "")
{
	n (Context, ActionTypeCode, FromUserRowId, EpisodeId, OrdItemId, ToUserRowId, OtherInfoJson, ToLocRowId, EffectiveDays, CreateLoc)
	Set rtn = ##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
	quit rtn
}

/// Creator:ban
/// Date:2020-12-17
/// Description: 声音提示,按照Message在对应的IP电脑上提示声音
/// Input:  IP^Message^VoiceSpeed^WaitFlag^VoiceFileName
/// d ##class(web.CSSDHUI.Common.Message).SendVoice("127.0.0.1","测试123","success")
ClassMethod SendVoice(IP As %String, Message As %String, MsgCode As %String = "") As %Library.String
{
	n (IP,Message,MsgCode)
	s WaitFlag="N"				;是否等待, Y/N
	s Rate=0					;语速, -5到5的数值
	s Message=Message_"。"		;拼接中文标点,避免出现无法播报的情况(单纯数字不会播报)
	s VoiceData=Message_"^"_WaitFlag_"^"_Rate_"^"_MsgCode
	s Title="Message^WaitFlag^Rate^MsgCode"
	s VoiceJson=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(VoiceData,Title)
	
	s UDPClient=##class(%Net.UDP).%New()
	s DestIP=##class(%Net.UDP).GetHostAddr(IP)
	s Port=30001				;当前桌面监听小程序,默认端口
	d UDPClient.Send(VoiceJson,DestIP,Port)
	q
}

}
