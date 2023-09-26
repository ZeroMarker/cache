/// lixu
/// 2021-10-13
/// 魔点人脸认证相关类
Class DHCDoc.GetInfo.Service.FaceAuthentication Extends %Persistent
{

/// 服务地址
Parameter IP = "82.156.2.141";

/// 端口
Parameter Port = 8022;

/// 超时时间
Parameter Timeout = 2;

/// 机构码
Parameter OrgCode = "153707CABAAC49307137D5FA81472233";

/// appkey
Parameter AppKey = "YjAzODA0N2QtM2JkYy00N2YzLWI4YjctOTM4NTQxM2M1Y2I0";

/// 1.3. 生成AppToken v2
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).GenToken()
ClassMethod GenToken() As %String
{
	s Token="",Code=0,Desc="成功"
	
	s Obj={}
	s Obj."orgCode"=..#OrgCode
	s Obj."appKey"=..#AppKey
	s JsonStr=Obj.%ToJSON()
	s OutObj=..PublicPost("/account/member/getOpenApiToken/v2",JsonStr)
	s Code=OutObj."code"
	i Code=0{
		s Token=OutObj."data"."appToken"
	}else{
		s Desc=OutObj."message"
	}
	q Code_"^"_Token_"^"_Desc
}

/// 2.8. 通过工号查询成员信息
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).FindMemberInfo("20160701")
ClassMethod FindMemberInfo(JobNum) As %String
{
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s Obj={}
	s Obj."memberJobNum"=JobNum	
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/member/getMemberDetailsByJobNum",JsonStr,.Header)
	s Code=OutObj."code"
	i Code=0{
		s Token=OutObj."data"."appToken"
	}else{
		s Desc=OutObj."message"
	}
	q ""
}

/// 4.1. 获取识别记录列表
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).FindIdentifyList()
ClassMethod FindIdentifyList() As %String
{
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s StDate=$zdth("2021-10-13 01:11:00",3,1)
	s EndDate=$zdth("2021-10-13 10:11:00",3,1)
	s StTimestamp=##class(DHCDoc.Util.System).GetTimeStamp(StDate)
	s EndTimestamp=##class(DHCDoc.Util.System).GetTimeStamp(EndDate)
	
	s Obj={}
	s Obj."startTimeStr"=""				;拉取列表开始时间(v1.5.7版本后将废弃,请及时用startTimestamp替代.)
	s Obj."endTimeStr"=""				;拉取列表结束时间(v1.5.7版本后将废弃,请及时用startTimestamp替代.)
	s Obj."startTimestamp"=StTimestamp	;拉取列表开始时间戳(毫秒).时间查询结果：包含查询开始时间,不包含查询结束时间,例：1586500125121(v1.5.7版本新增)
	s Obj."endTimestamp"=EndTimestamp	;拉取列表结束时间戳(毫秒).时间查询结果：包含查询开始时间,不包含查询结束时间,例：1586500125121(v1.5.7版本新增)
	s Obj."startDate"=""				;和startTimestamp必填其中一项
	s Obj."endDate"=""					;和endTimestamp必填其中一项
	s Obj."deptId"=""                  	;非必填，部门id
  	s Obj."deviceSn"=""         		;非必填，设备sn，多个之间逗号隔开
  	s Obj."memberName"=""           	;非必填，成员名称或工号，模糊匹配（1.5.7移除，改用keyWords）
  	s Obj."keyWords"="" 				;非必填，成员名称或工号，模糊匹配（1.5.7新增）
  	s Obj."authFlag"=0             		;非必填，记录类型： 0：全部:1：有权限:2：无权限
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/record/verify/recordList",JsonStr,.Header)
	s Code=OutObj."code"
	i Code=0{
		f len=1:1:OutObj."data"."list".%Size() {
			s OneObj=OutObj."data"."list".%Get(len-1)
			s verifyRecordId=OneObj."verifyRecordId"	;识别记录id
		}
	}else{
		s Desc=OutObj."message"
	}
	q ""
}

/// 6.1. 新增回调服务
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).AddedCallback()
ClassMethod AddedCallback() As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s BackTag="REC_SUCCESS"
	;s BackUrl="http://49.7.215.31/imedical/web/csp/dhc.logon.csp"
	;s BackUrl="http://49.7.215.31:1880/imedical/web/csp/dhcmdt.broker.csp?ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"
	;s BackUrl="http://49.7.215.31:1880/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"
	;s BackUrl="https://114.251.235.22:1443/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"
	;s BackUrl="https://49.7.215.31:1443/imedical/web/csp/dhcmdt.broker.csp?ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"
	
	
	s BackUrl="http://49.7.215.31:1880/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"_
				",http://114.251.235.22:8080/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"_
				",http://82.157.186.213:8080/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"_
				",https://49.7.112.107:1443/imedical/web/csp/dhcmdt.broker.csp?CacheNoRedirect=1&CacheUserName=_system&CachePassword=v4dwFQ#9H&ClassName=web.DHCMDTWebSocketServer&MethodName=faceAdoptCall"
	
	
	s SerialNo=""
	
	s Obj={}
	s Obj."callbackTag"=BackTag			;回调服务类型标签,如："REC_SUCCESS"——识别记录推送
	s Obj."callbackUrl"=BackUrl			;回调服务通知地址(要求带上"http://"或"https://"),多个逗号隔开
	s Obj."deviceSn"=SerialNo			;设备串号,多台设备SN中间逗号隔开
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/server/callback/save",JsonStr,.Header)
	s Code=OutObj."code"
	s Desc=OutObj."message"
	w Code,Desc
	q ""
}

/// 6.2. 删除回调服务
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).DeleteCallback()
ClassMethod DeleteCallback() As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s BackTag="REC_SUCCESS"
	s SerialNo=""
	
	s Obj={}
	s Obj."callbackTag"=BackTag			;回调服务类型标签,如："REC_SUCCESS"——识别记录推送
	s Obj."deviceSn"=SerialNo			;设备串号,多台设备SN中间逗号隔开
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/server/callback/delete",JsonStr,.Header)
	s Code=OutObj."code"
	s Desc=OutObj."message"
	
	q ""
}

/// 6.4. 查询已注册回调服务列表
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).FindCallbackList()
ClassMethod FindCallbackList() As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s BackTag="REC_SUCCESS"
	s BackUrl="http://49.7.215.31:1880/imedical/web/csp/dhc.logon.csp"
	s SerialNo=""
	
	s Obj={}
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/server/callback/listCallbackServers",JsonStr,.Header)
	s Code=OutObj."code"
	i Code=0{
		f len=1:1:OutObj."data"."list".%Size() {
			s OneObj=OutObj."data"."list".%Get(len-1)
			s callbackTag=OneObj."callbackTag"		;回调服务TAG
			s callbackUrl=OneObj."callbackUrl"  	;回调服务通知地址
			w callbackTag_":"_callbackUrl ,!
		}
	}else{
		s Desc=OutObj."message"
	}
	
	q ""
}

/// 2.12. 通知设备进行拍照录脸
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).ExtractNotice()
ClassMethod ExtractNotice(JobNum) As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	s DeviceSn="110205201224KN0363"
	s Expires="30"
	
	s SerialNo=""
	
	s Obj={}
	s Obj."deviceSn"=DeviceSn		;必填，需要通知开启拍照录脸的设备序列号
	s Obj."jobNum"=JobNum			;必填，任务批次号，用于查询设备是否录脸成功
	s Obj."expires"=Expires			;选填填，指定时间不录脸，设备退出录脸界面，单位：秒，默认30秒
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/member/extractNotice",JsonStr,.Header)
	s Ret=OutObj.%ToJSON()
	q Ret
}

/// 2.10. 查询人脸录入结果
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).QueryExtractFeatureResult(12273)
ClassMethod QueryExtractFeatureResult(JobNum) As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	
	s SerialNo=""
	
	s Obj={}
	s Obj."jobNum"=JobNum			;必填，任务批次号，用于查询设备是否录脸成功
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/member/queryExtractFeatureResult",JsonStr,.Header)
	s Code=OutObj."code"
	s Ret=OutObj.%ToJSON()
	q Ret
}

/// 2.10. 删除人脸
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).DeleteByJobNum(12273)
ClassMethod DeleteByJobNum(UserId) As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	s MemberJobNum="JobNum"_UserId
	
	s SerialNo=""
	
	s Obj={}
	s Obj."memberJobNum"=MemberJobNum			;必填，成员工号列表，30位以下数字和字母组合，不能重复
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/face/deleteByJobNum",JsonStr,.Header)
	s Code=OutObj."code"
	s Ret=OutObj.%ToJSON()
	q Ret
}

/// 2.10. 新建/修改成员
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).SaveMember("^223^334^445^2^^^^/faceimg/2021101616343787211891357-image.png")
ClassMethod SaveMember(Params) As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)
	s ID=$p(Params,"^",1)
	s Name=$p(Params,"^",2)
	s Code=$p(Params,"^",3)
	s Pos=$p(Params,"^",4)
	s Gender=$p(Params,"^",5)
	s CardNum=$p(Params,"^",6)
	s Mobile=$p(Params,"^",7)
	s IdenCard=$p(Params,"^",8)
	s VerifyFaceUrl=$p(Params,"^",9)
	s JobNum=$p(Params,"^",10)
	s SerialNo=""
	
	s Obj={}
	s Obj."memberId"=ID        		;成员id，新增时不填，修改时必填
	s Obj."deptId"="12345678967"   	;必填，部门编号列表，支持一个成员归属于多个部门，列表中各部门ID用英文逗号隔开。此参数默认传递0时将成员归属到根部门
	s Obj."verifyFaceUrl"=VerifyFaceUrl   ;底库照片URL
	s Obj."memberName"=Name    		;必填， 姓名
	s Obj."memberMobilePre"="+86"	;手机号前缀，默认+86(v1.5.5新增)
	s Obj."memberMobile"=Mobile		;手机号
	s Obj."memberEmail"=""			;邮箱账号
	s Obj."memberTelphone"=""		;分机号
	s Obj."memberPosition"=Pos		;职位
	s Obj."memberJobNum"=Code		;必填，工号，30位以下数字和字母组合，不能重复
	s Obj."memberJoinTime"=""		;入职日期 YYYY-MM-DD
	s Obj."remark"=""				;备注信息
	s Obj."jobNum"=JobNum			;任务序列号
	s Obj."memberGender"=Gender		;性别
	s Obj."identityCard"=IdenCard	;身份证
	s Obj."memberCardNum"=CardNum  	;卡号
	
	s JsonStr=Obj.%ToJSON()
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/member/saveMember",JsonStr,.Header)
	
	s Code=OutObj."code"
	
	s Ret=OutObj.%ToJSON()
	q Ret
}

/// 2.8. 查询成员信息
/// w ##class(DHCDoc.GetInfo.Service.FaceAuthentication).GetMemberDetailsByJobNum("ys01")
ClassMethod GetMemberDetailsByJobNum(MemberJobNum) As %String
{
	
	s Code=0,Desc="成功"
	s TokenInfo=..GenToken()
	s Token=$p(TokenInfo,"^",2)
	q:Token="" "-1^"_$p(TokenInfo,"^",3)

	s SerialNo=""
	
	s Obj={}
	s Obj."memberJobNum"=MemberJobNum        		;必填，工号，30位以下数字和字母组合，不能重复
	
	s JsonStr=Obj.%ToJSON()
	b ;err
	s Header("Auth-Token")=Token
	s OutObj=..PublicPost("/member/member/getMemberDetailsByJobNum",JsonStr,.Header)
	
	s Code=OutObj."code"
	
	s Ret=OutObj.%ToJSON()
	q Ret
}

/// 通过post的方式向第三方上传数据
ClassMethod PublicPost(Path, JsonStr, ByRef Header = "")
{
	s $zt="PublicPostErr"
	s dataStr=""
	s httprequest=##class(%Net.HttpRequest).%New()
	s httprequest.Server=..#IP
	s httprequest.Port=..#Port
	s httprequest.Timeout=..#Timeout
	s httprequest.ReadRawMode=1	; 跨域调用	
	d httprequest.SetHeader("Content-Type","application/json;charset=UTF-8")
	d httprequest.SetHeader("Accept","*/*")
	i $d(Header)=11{
		s key=""
		f {
			s key=$o(Header(key))
			q:key=""
			s val=$g(Header(key))
			d httprequest.SetHeader(key,val)
		}
	}	
	d httprequest.EntityBody.Write(JsonStr)  ;也可写入流
	d httprequest.Post(Path)
	s contentInfo=httprequest.HttpResponse.ContentInfo
 	s statusCode=httprequest.HttpResponse.StatusCode
	s dataStream=httprequest.HttpResponse.Data
	s:dataStream'="" dataStr=httprequest.HttpResponse.Data.ReadLine()
	s dataStr=$zcvt(dataStr,"I","UTF8")
	s Obj={}.%FromJSON(dataStr)
	q Obj

PublicPostErr
	s $zt=""
	s Obj={}
	s Obj."code"="-1"
	s Obj."message"=$ze
	q Obj
}

Storage Default
{
<Data name="FaceAuthenticationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Get89FD.FaceAuthent320CD</DataLocation>
<DefaultData>FaceAuthenticationDefaultData</DefaultData>
<IdLocation>^DHCDoc.Get89FD.FaceAuthent320CD</IdLocation>
<IndexLocation>^DHCDoc.Get89FD.FaceAuthent320CI</IndexLocation>
<StreamLocation>^DHCDoc.Get89FD.FaceAuthent320CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
