/// 名称: DHCMA.CPW.SDS.QCInterface
/// 描述: 单病种接口服务
/// 编写者：fuchengzhi
/// 编写日期: 2018-11-20
Class DHCMA.CPW.SDS.QCInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     fuchengzhi
/// CreatDate：   2018-11-26
/// Description:  单病种上报
/// w ##Class(DHCMA.CPW.SDS.QCInterface).Upload(14)
ClassMethod Upload(aMRListID As %String) As %String
{
	new (aMRListID)
	set objMR=##class(DHCMA.CPW.SD.QCMrList).GetObjById(aMRListID)
	// 取执行结果
	set rs=##class(%ResultSet).%New("DHCMA.CPW.SDS.QCItemExecSrv:QryQCItemExec")
	do rs.Execute(aMRListID)
	
	// 病种数据json
	//set dataToJSON="" ;##class(%DynamicObject).%New()
	set dataStream=##class(%Stream.GlobalCharacter).%New()
	do dataStream.Rewind()
	do dataStream.Write("{")
	set count=0
	while (rs.Next())
	{
		set code=rs.Get("BTCode")
		set value=rs.Get("ExecResult")		
		Set:value="tmp" value="" //替代项目赋空值
		Set ItemType=rs.Get("BTTypeDesc")
		Set ItemUpType=rs.Get("BTUpTypeDesc")
		Set IsNeeded=rs.Get("BTIsNeeded")
		continue:(value="")
		Set:(ItemType["日期") $P(value," ",1)=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat($P(value," ",1),3)		
		if (ItemType["多选")||(ItemUpType["数组") {
			Set values=""
			For ind=1:1:$l(value,",") {
				Set xvalue=$p(value,",",ind)
				Set values=values_","""_xvalue_""""
			}
			Set:values'="" values=$e(values,2,$l(values))
			Set value="["_values_"]"
		}elseif (ItemType["数值")||(ItemType["整型") {
			Set value=value    //这里不能用$number 0.45会转化为.45导致json报错
			Set:$e(value,1,1)="." value=$fn(value,"",2)	//点开头的数值会导致json数据格式错误，修正为浮点数
		}elseif (ItemType["日期时间") {   //日期时间类型只上传到分钟
			If (ItemUpType["(时)"){
				Set value=""""_$e(value,0,13)_""""
			}elseif(ItemUpType["(秒)") {
				Set value=""""_value_""""
			}else{
				//大多数情况精确到分，分作为默认精确度
				Set value=""""_$e(value,0,16)_""""
			}
		}else{
			Set value=$tr(value," ","")
			Set value=""""_value_""""
			}
		continue:rs.Get("EditPower")=0
		d:count>0 dataStream.Write(",")
		set jsonData=""""_code_""":"_value_""
		do dataStream.Write(jsonData)
		set count=count+1
	}
	do dataStream.Write("}")
	// Get Config ip info
	set server=##class(DHCMA.Util.BT.Config).GetValueByCode("SDserver")

	// 根据病种获取对应的接口地址
	set sdUrl=objMR.QCEntityDr.BTURL
	set ip=$p(server,":",1)
	set port=$p(server,":",2)
	// 调接口上报数据
	set httprequest=##class(%Net.HttpRequest).%New()
	;set httprequest.ContentType="application/json;charset:utf-8"   //默认格式上传。编码不支持时使用该行转码
    set httprequest.Server=ip
    set httprequest.Port=port
    set data=dataStream.Read(30000)
	do httprequest.EntityBody.Write(data)
	do dataStream.%Close()
    set tSc=httprequest.Post(sdUrl)	
	set response=httprequest.HttpResponse
	quit:response="" "未检测到单病种前置机网络端口！"
	set OutStream=##class(%Stream.GlobalCharacter).%New()
	set streamSize=response.Data.Size
	while 'response.Data.AtEnd {
		d OutStream.Write(response.Data.Read(streamSize))   //如果提示信息乱码请转码：$ZCVT(response.Data.Read(streamSize),"I","UTF8")
		set str=OutStream.Read(streamSize)
	}
	// json转对象
	do ##class(ext.util.JsonObject).ParseJSON(str,"",.InputObj)
	set retCode=InputObj.code
	set retMessage=InputObj.message
	//将请求内容中的代码进行翻译
	Set turnMessage=""
	do ##class(ext.util.JsonObject).ParseJSON(retMessage,"",.MessageObj)
	If ($IsObject(MessageObj)) {
		Set ErrorMessage=MessageObj.errorMessage
		If (ErrorMessage'="")&&($IsObject(ErrorMessage)) {
			Do ErrorMessage.%CopyToArray(.Errarray)	
		}elseif(ErrorMessage'=""){
			Set Errarray("caseId")=ErrorMessage
		}else{
			Do MessageObj.%CopyToArray(.Errarray)
			}
		Set xItemCode=""
		For {
			Set xItemCode=$o(Errarray(xItemCode))
			Quit:xItemCode=""
			Set:turnMessage="" turnMessage="上传错误明细：<br>"
			Set xItemDesc=##class(DHCMA.CPW.SDS.QCEntityItemSrv).getItemDescByCode(xItemCode,objMR.QCEntityDr.%Id(),objMR.QCEntityDr.BTVersion.%Id())
			Set xErrInfo=$g(Errarray(xItemCode))
			Set turnMessage=turnMessage_xItemCode_"("_xItemDesc_"):<span style="_"color:red"_">"_xErrInfo_"</span><br>"
		}
	}
	Set:turnMessage'="" retMessage=turnMessage
	Set return=retCode_"^"_retMessage
	quit return
}

/// w ##Class(DHCMA.CPW.SDS.QCInterface).test()
ClassMethod test() As %String
{
	Set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{")
	d stream.Write("""STK-0-1-1-4"":""张强强"",")
	d stream.Write("""STK-0-1-1-5"":""NICU""")
	d stream.Write("}")
	
	
#;	Set filestream.Filename="F:\1.txt"
#;	Set PublicKeyStr=filestream.Read(.len)

#;	Set Ciphertext=##class(%SYSTEM.Encryption).RSAEncrypt("hadjahdjkahdkadsa",PublicKeyStr)
#;	Set Ciphertext=##class(%SYSTEM.Encryption).Base64Encode(Ciphertext)
#;	b ;121

	set httprequest=##class(%Net.HttpRequest).%New()
	
#;	set httprequest.SSLConfiguration="QCSSL"
#;	set httprequest.Https=1
	//set httprequest.ContentType="application/json"
	
    set httprequest.Server="localhost"
    set httprequest.Port=8080

    do httprequest.InsertFormData("data",stream)
    do httprequest.InsertFormData("url","https://qapi.ncis.cn:8085/01/010102/3/1.2/put/")
    do httprequest.InsertFormData("isOldData",0)
    do httprequest.InsertFormData("license","66116165361040413A1002")
    do httprequest.InsertFormData("token","3u2z1LyDgBSmDaZCTCj4ZQ==_13087681722")
    
    b ;009
    set tSc=httprequest.Post("/sdupload/")
 	
	set response=httprequest.HttpResponse
	while 'response.Data.AtEnd {
		set str=response.Data.ReadLine()
	}
	do ##class(ext.util.JsonObject).ParseJSON(str,"",.InputObj)
	set retCode=InputObj.code
	set retMessage=InputObj.message		
	b ;3	

    quit retCode_"^"_retMessage
}

/// w ##Class(DHCMA.CPW.SDS.QCInterface).ReUpLoad(9)
ClassMethod ReUpLoad(aEntityID) As %String
{
	n (aEntityID)
	Quit:(aEntityID="") ""
	Set xEpisodeID="",return=0
	For{
			Set xEpisodeID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",xEpisodeID))
			Quit:xEpisodeID=""
			Set xID=$o(^DHCMA.CPW.SD.QCMrListI("IndexEpisodeID",xEpisodeID,""),-1)
			Continue:xID=""
			Set obj=##class(DHCMA.CPW.SD.QCMrList).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set QCState=obj.QCState
			
			Continue:QCState'="Up"
			
			Set QCEntity=obj.QCEntityDr.%Id()
			Continue:(aEntityID'="")&&(aEntityID'=QCEntity)
			set ret = ##Class(DHCMA.CPW.SDS.QCInterface).Upload(xID)
			w xID_":"_ret,!
			if (ret'["错误") {
				Set return=return+1
			}
	}
	q return
}

}
