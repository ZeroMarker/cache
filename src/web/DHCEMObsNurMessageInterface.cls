Class web.DHCEMObsNurMessageInterface Extends %Persistent
{

/// Creator: 		hxy
/// CreateDate: 	2022-10-27
/// Descript: 		不良-ADR advDrug、跌倒advFallDownFill、压疮advSkinUlcer、管路滑脱advPipeOff事件当日该用户填写保存事件
/// w ##class(web.DHCEMObsNurMessageInterface).AdvMessageNumber("jzhs01","advPipeOff")
ClassMethod AdvMessageNumber(userCode = "", messageCode = "")
{
	s code=200,data=0,msg=""
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) 
	s:+userId=0 code=500,msg=userCode_"未找到对应用户!"
	i +userId'=0 {
		s RepID=""
		f  s RepID=$o(^DHCADVMASTER(0,"RepDate",+$h,RepID)) Q:RepID=""  D
		.s RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
		.q:RepUserDr'=userId
		.s RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(RepID)
		.s TypeCode=$p(RepTypeString,"^",2)
		.q:TypeCode=""
		.s:(messageCode'="")&&(messageCode=TypeCode) data=data+1
	}
#;	s:messageCode="advDrug" data=1
#;	s:messageCode="advFallDownFill" data=2
#;	s:messageCode="advSkinUlcer" data=3
#;	s:messageCode="advPipeOff" data=1
    q ##class(web.DHCEMDocMessageInterface).hosMessageResponse(code,data,msg)
}

Storage Default
{
<Data name="DHCEMObsNurMessageInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMObsNur60A4D</DataLocation>
<DefaultData>DHCEMObsNurMessageInterfaceDefaultData</DefaultData>
<IdLocation>^web.DHCEMObsNur60A4D</IdLocation>
<IndexLocation>^web.DHCEMObsNur60A4I</IndexLocation>
<StreamLocation>^web.DHCEMObsNur60A4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
