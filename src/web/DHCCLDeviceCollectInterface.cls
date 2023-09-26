Import SQLUser

Class web.DHCCLDeviceCollectInterface Extends %RegisteredObject
{

/// 临床组体检设备数据采集外部接口
/// 输入：设备连接参数，输出：上一次从设备中采集到的数据
/// 
/// 参数
/// equipId：设备的编号(同一种类型设备唯一标识符)
/// devIP：设备所在网络上的确切地址，接MOXA的以moxa地址为准
/// devPort：设备对应采集端口，接MOXA的以moxa端口为准，port1为950，port2为951，以此类推
/// interfaceProgram：设备对应采集代码，临床组提供，用于解析程序标识
/// anoSource：体检为"PE"，急诊为"EM"
/// 
/// 如，体检身高体重仪，调用如下：
/// w ##class(web.DHCCLDeviceCollectInterface).GetPEDevInfo(101,"129.60.132.217",950,"SKCL")
/// 常见问题：
/// 1.调用返回错误->查看是否采集服务未开启，采集服务器地址：129.60.132.165/oaicuservice/webpages/oaicumonitor.aspx
/// 2.返回空数据->查看MOXA是否开启，设备和MOXA、MOXA和内网间连接线是否松动或脱落，MOXA地址：129.60.132.217，
ClassMethod GetPEDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String) As %String
{
    s res=..GetDevInfo(equipId,devIP,devPort,interfaceProgram,"PE")
	q res
}

/// 临床组急诊设备数据采集外部接口
/// 输入：设备连接参数，输出：上一次从设备中采集到的数据
/// 
/// 参数
/// equipId：设备的编号(同一种类型设备唯一标识符)
/// devIP：设备所在网络上的确切地址，接MOXA的以moxa地址为准
/// devPort：设备对应采集端口，接MOXA的以moxa端口为准，port1为950，port2为951，以此类推
/// interfaceProgram：设备对应采集代码，临床组提供，用于解析程序标识
/// anoSource：体检为"PE"，急诊为"EM"
/// 如，监护仪
/// ##class(web.DHCCLDeviceCollectInterface).GetDevInfo(1,"129.60.132.217",24105,"PhilipMP","EM")
/// 
/// 常见问题：
/// 1.调用返回错误->查看是否采集服务未开启，采集服务器地址：129.60.132.165/oaicuservice/webpages/oaicumonitor.aspx
/// 2.返回空数据->查看MOXA是否开启，设备和MOXA、MOXA和内网间连接线是否松动或脱落，MOXA地址：129.60.132.217，
ClassMethod GetEMDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String) As %String
{
    s res=..GetDevInfo(equipId,devIP,devPort,interfaceProgram,"EM")
	q res
}

ClassMethod GetDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String = "SKCK", source As %String = "PE") As %String
{
    s objDeviceServer=##class(web.DHCCLDevSoapInferface).%New() 
    //使用配置的IP
    s mIP=$g(^DHCCLSet("MSrvIP"))
    i mIP'="" d
    .s mIP=$p(mIP,"|",1)
    .s locStr=objDeviceServer.Location
    .s $p(locStr,"/",3)=mIP ;
    .s objDeviceServer.Location=locStr
    
	s para=""
 	s res=objDeviceServer.GetDevInfo(source,equipId,"")
 	
	i res["FAILED^" d
	.s res=objDeviceServer.StartTask(source,equipId,"",devIP,.devPort,"50000",interfaceProgram,"")  // !!!!!!!!!!!!!旧版采集需要修改！！！！！！！！！
	.s res=objDeviceServer.GetDevInfo(source,equipId,"")
	.;s res=objDeviceServer.Start("","",equipId,source,"",devIP,devPort,60000,interfaceProgram)
	.;s res=objDeviceServer.GetDevInfo(equipId,source,"") 
	.w res,!
	q res
}

/// 护理组血气分析仪数据推送
ClassMethod AddData(source, equipId, dataPara)
{
	if dataPara'["PatientID" 
	{
		// 查找病人ID
		s pId=..GetValue(dataPara,"PatientID")
		s dateTime=..GetValue(dataPara,"DateTime")
		if dateTime="" quit "DateTime is Null"
		s actDate=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime,"~",1))
		if dateTime["~" d
		.set actTime=$zth($p(dateTime,"~",2))
		if pId="" quit "1:NoPatInfo"
		// 通过病人ID查找就诊Id
		set admId=$$FindAdmId(pId)
		quit:admId="" "病人ID不取在:"_pId
		set retStr="" 
		set itemNum=$L(dataPara,"^")	
		for i=1:1:itemNum d
		.;查找对应常用医嘱项
		.quit:retStr'=0
		.set itemStr=$P(dataPara,"^",i)
		.set name=$P(itemStr,"#",1)
		.quit:name=""
		.set value=$P(itemStr,"#",5)
		.;将数据插入表中
		.set rowId=..InsertBloodGasData(admId,name,value)
		.if retStr="" set retStr=name_":"_value
		.else  set retStr=retStr_","_name_":"_value
		if retStr'="" set retStr="0 "_retStr
	}
	quit retStr
FindAdmId(pId)
    set admId=""
	&sql(SELECT PAADM_PAPMI_DR->PAPMI_No into :admId FROM PA_Adm where PAADM_PAPMI_DR->PAPMI_No=:pId)
	quit admId
}

ClassMethod GetValue(dataPara As %String, itemName As %String) As %String
{
	s itemValue=""
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum q:itemValue'=""  d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s chNo=$P(itemStr,"#",1)
	.i chNo=itemName s itemValue=$P(itemStr,"#",5) s i=itemNum	
	q itemValue
}

ClassMethod InsertBloodGasData(admId, name, value)
{
	return "rowId"
}

ClassMethod GetPEData(equipId As %String) As %String
{
	s equipIdTime=$g(^PEDeviceData(equipId,"Time"))
	i (equipIdTime'="")&&((($p($h,",",2)-equipIdTime)>15))  q ""	
	q $g(^PEDeviceData(equipId))
}

/// /"DateTime#2020-07-22#17:35:25#V#2020/07/16/17:01#PE#15011##^SYS#2020-07-22#17:35:25#V#114#PE#15011##^DIA#2020-07-22#17:35:25#V#64#PE#15011##^PR#2020-07-22#17:35:25#V#72#PE#15011##"
ClassMethod cleanPEData(equipId As %String) As %String
{
	s ^PEDeviceData(equipId)=""
	s ^PEDeviceData(equipId,"Time")=""
	q ""
}

ClassMethod InsertPEData(equipId As %String, dataPara As %String) As %String
{
	s res=""
	
    s ^PEDeviceData(equipId)=dataPara
	s ^PEDeviceData(equipId,"Time")=$p($h,",",2)
	q res
}

}
