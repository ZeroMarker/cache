Import SQLUser

Class web.DHCVISVoiceCall Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod UpdateVoiceQueueState(queueId As %String = "", serverIP As %String = "") As %String
{
	s retStr=""
	q:((queueId="")||(serverIP="")) retStr
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverId)
	&SQL(update DHC_VIS_VoiceQueue set VIS_State='Y',VIS_UpdateServerID=:serverId,VIS_UpdateDate=:nowDate,VIS_UpdateTime=:nowTime where VIS_QueueID=:queueId)
	s retStr=SQLCODE
	q retStr
}

/// w ##class(web.DHCVISVoiceCall).GetVoiceQueueServer("10.1.41.15")
ClassMethod GetVoiceQueueServer(serverIP As %String = "") As %String
{
	//q "10.1.41.100*administrator*1*/vis/voice/#280ID10141101.wav*<rate speed='-5'>请<silence msec='100'/>1号<silence msec='100'/>程杨<silence msec='100'/>到<silence msec='100'/>测试客户端<silence msec='100'/>就诊</rate>#280ID11141101.wav*<rate speed='-5'>请<silence msec='100'/>1号<silence msec='100'/>程杨<silence msec='100'/>到<silence msec='100'/>测试客户端<silence msec='100'/>就诊,请<silence msec='100'/>2号<silence msec='100'/>杨佳<silence msec='100'/>等候</rate>^10.1.41.101*msg=callnumber&count=1&url=/vis/voice/280ID10141101.wav&session_id=1014110179608#11.1.41.101*msg=callnumber&count=1&url=/vis/voice/280ID11141101.wav&session_id=1114110179608&areaid=l&areatype=lua&dataid=79608&action=addnew&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="_"""请到测试客户端就诊,请2号杨佳等候"""_";PatInfo="_"""1号 程杨"""_";</script></areadata>&areaid=notify&areatype=queue&dataid=79608&data=请1号程杨到测试客户端就诊,请2号杨佳等候^10.1.41.101*msg=dataupdate&areaid=notify&areatype=queue&dataid=79608&action=addnew&data=请1号程杨到测试客户端就诊&areaid=l&areatype=lua&dataid=79608&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="_"""请1号程杨到测试客户端就诊"""_";PatInfo="_"""1号 程杨"""_";Docpicture="_"""298.jpg"""_";</script></areadata>&areaid=windowinfo&areatype=queue&dataid=79608&data=测试客户端&areaid=queueinfo&areatype=queue&dataid=79608&data=<br/><br/><br/><br/><br/>2号-杨佳<br/>1号-程杨<br/><br/>副主任医师<br/>蒋荣猛&areaid=windowinfo&areatype=queue&dataid=79608&data=测试客户端&areaid=l&areatype=lua&dataid=79608"
	//q "10.1.61.10*administrator*sea*/vis/voice/#111ID1016115.wav*<rate speed='-5'>请<silence msec='100'/>5号<silence msec='100'/>刘自喜<silence msec='100'/>到<silencemsec='100'/>01诊室<silence msec='100'/>等候</rate>^10.1.61.15*msg=callnumber&count=1&url=/vis/voice/111ID1016115.wav&session_id=101611551068^10.1.61.15*msg=dataupdate&areaid=notify&areatype=queue&dataid=51068&data=请到01诊室等候&areaid=l&areatype=lua&dataid=51068&action=addnew&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_"请到01诊室等候"""_";PatInfo="""_"5号 刘自喜"""_";</script></areadata>#10.1.61.15*msg=dataupdate&areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室&areaid=windowinfo&areatype=queue&dataid=51068&data=传染科候诊区"
	//q "10.1.61.10*administrator*sea*/vis/voice/#177ID1016115.wav*<rate speed='-5'>请<silence msec='100'/>1号<silence msec='100'/>东华医疗<silence msec='100'/>等候</rate>^10.1.61.15*msg=callnumber&count=1&url=/vis/voice/177ID1016115.wav&session_id=101611539992&areaid=notify&areatype=queue&dataid=39991&data=请到01诊室就诊,请1号东华医疗等候&areaid=l&areatype=lua&dataid=39991&action=addnew&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_"请到01诊室就诊,请1号东华医疗等候"""_";PatInfo="""_"2号 刘自喜"""_";</script></areadata>^10.1.61.15*msg=dataupdate&areaid=queueinfo&areatype=queue&dataid=39992&data=<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> 4号,6号<br/>2号-刘＊喜<br/>蒋荣猛<br/>01诊室<br/>准备就诊<br/>当前就诊<br/>号别<br/>科室-诊室"
	s retStr=""
	i serverIP="" s serverIP=$ZUTIL(67,15,$JOB)
	i serverIP'="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	.q:serverId=""
	.s nowDate=+$H,nowTime=$P($H,",",2)
	.&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverId)
	s serverId=""
	f  s serverId=$O(^DHCVISServer(serverId)) q:((serverId="")||(retStr'=""))  d
	.s LastDate=$P($G(^DHCVISServer(serverId)),"^",11)
	.s LastTime=$P($G(^DHCVISServer(serverId)),"^",12)
	.q:(LastDate=+$H)&&($P($H,",",2)-LastTime<5)
	.s ServerShowTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	.q:ServerShowTopIP=""
	.s ServerVoiceTopIP=$P($G(^DHCVISServer(serverId)),"^",15)
	.q:ServerVoiceTopIP=""
	.s ServerIP=$P($G(^DHCVISServer(serverId)),"^")
	.q:ServerIP=""
	.s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	.q:serverActive'="Y"
	.s retStr=..GetVoiceQueueShow(ServerIP)
	q retStr
}

//w ##class(web.DHCVISVoiceCall).TopScreenRefreshServer()

ClassMethod TopScreenRefreshServer() As %String
{
	s retStr=""
	s serverId=""
	f  s serverId=$O(^DHCVISServer(serverId)) q:((serverId="")||(retStr'=""))  d
	.s ServerIP=$P($G(^DHCVISServer(serverId)),"^")
	.q:ServerIP=""
	.s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	.q:serverActive'="Y"
	.s LastDate=$P($G(^DHCVISServer(serverId)),"^",11)
	.s LastTime=$P($G(^DHCVISServer(serverId)),"^",12)
	.q:(LastDate=+$H)&&($P($H,",",2)-LastTime<30)
	.s retTopStr=..GetScreenTopInfo(ServerIP)
	.q:retTopStr=""
	.i retStr="" s retStr=retTopStr
	.e  s retStr=retStr_"#"_retTopStr
	q retStr
}

/// w ##class(web.DHCVISVoiceCall).GetVoiceQueueShowOld()
/// 部分老库 ^TempVIS(+$H,serverId,clientId)=queueId_"*"_zhContent
ClassMethod GetVoiceQueueShowOld(serverIP) As %String
{
	s retStr=""
	s hostname=$ZU(54,0)
	s dabaseIP=$P($ZU(54,13,hostname),",")
	s VoiceServerDir="\\"_dabaseIP_"\voice\"
	s FtpServerIP=$G(^DHCVISSet("Ftp","ServerIP"))
	i FtpServerIP="" s FtpServerIP=dabaseIP
	s FtpServerDir=$G(^DHCVISSet("Ftp","Voice"))
	i FtpServerDir="" s FtpServerDir="/voice/"
	s FtpUser=$G(^DHCVISSet("Ftp","User"))
	i FtpUser="" s FtpUser="administrator"
	s FtpPassword=$G(^DHCVISSet("Ftp","Password"))
	i FtpPassword="" s FtpPassword="123456"
	s FtpParm=FtpServerIP_"*"_FtpUser_"*"_FtpPassword_"*"_FtpServerDir
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	s num=0
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerShowState",nowDate,serverId,"N",queueId)) q:(queueId="")||(num>0)  d
	.&SQL(update DHC_VIS_VoiceQueue set VIS_ShowState='Y' where VIS_QueueID=:queueId)
	.s queueStr=$G(^DHCVISQueue(queueId))
	.s clientId=$P(queueStr,"^",1)
	.s queueNo=$P(queueStr,"^",3)
	.s content=$P(queueStr,"^",4)
	.s type=$P(queueStr,"^",5)
	.s sound=$P(queueStr,"^",6)
	.s repeat=$P(queueStr,"^",7)
	.s zhContent=$P(queueStr,"^",17)
	.s ckContent=$P(queueStr,"^",18)
	.s waitList=$P(queueStr,"^",19)
	.s note=$P(queueStr,"^",20)
	.s ClientTopIP=$P($G(^DHCVISClient(clientId)),"^",16)
	.s LocTopIP=$P($G(^DHCVISClient(clientId)),"^",18)
	.s ClientVoiceTopIP=$P($G(^DHCVISClient(clientId)),"^",20)
	.s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	.s ServerVoiceTopIP=$P($G(^DHCVISServer(serverId)),"^",15)
	.s ckTopStr=""
	.s locTopStr=""
	.s zhTopStr=""
	.s screenTopInfo=""
	.i $P(zhContent,"*",2)'="" d
	..s QueRowId=+zhContent
	..s zhContent=$P(zhContent,"*",2)
	.i $P(waitList,"*",2)'="" d
	..s waitList=..GetWaitList(waitList)
	..i waitList'="" s zhContent=zhContent_waitList
	.s ^TempVIS(+$H,serverId,clientId)=queueId_"*"_zhContent
	.s ckContent=content
	.s zkContent=content
	.i $P(content,",",2)'="" d
	..s ckContent=$P(content,",",1)
	..s zkContent=$P(content,",",2)
	.i ClientTopIP'="" s ckTopStr=..GetWindowTopStr(ClientTopIP,ckContent)
	.i LocTopIP'="" s locTopStr=..GetZHWindowTopStr(LocTopIP,ckContent)
	.//i (LocTopIP'="")&&(ServerTopIP'="") s ServerTopIP=ServerTopIP_","_LocTopIP
	.//i (LocTopIP'="")&&(ServerTopIP="") s ServerTopIP=LocTopIP
	.i ServerTopIP'="" s zhTopStr=..GetZHWindowTopStr(ServerTopIP,zkContent)
	.i (LocTopIP'="")||(ckTopStr'="")||(zhTopStr'="")  s screenTopInfo=..GetScreenTopInfo(serverIP)
	.//s screenTopInfo=""
	.i ckTopStr'="" s retStr=ckTopStr
	.i (retStr'="")&&(locTopStr'="") s retStr=retStr_"#"_locTopStr
	.i (retStr="")&&(locTopStr'="") s retStr=locTopStr
	.i (retStr'="")&&(zhTopStr'="") s retStr=retStr_"#"_zhTopStr
	.i (retStr="")&&(zhTopStr'="") s retStr=zhTopStr
	.i (retStr'="")&&(screenTopInfo'="") s retStr=retStr_"#"_screenTopInfo
	.i (retStr="")&&(screenTopInfo'="") s retStr=screenTopInfo
	.//分发声音文件
	.s VoiceHeaderFile=$G(^DHCVISSet("Ftp","VoiceHeader"))
	.s VoiceFile=$G(^DHCVISSet("Ftp","Voice"))
	.i (ClientVoiceTopIP'="")&&(VoiceFile'="") d
	..s ClientFileName=..GetSoundFileName(ClientVoiceTopIP,queueId)
	..q:ClientFileName=""
	..f ClientVoiceIndex=1:1:$L(ClientVoiceTopIP,",") d
	...s ClientUDPMess=$P(ClientVoiceTopIP,",",ClientVoiceIndex)_"*msg=callnumber&url="_VoiceFile_ClientFileName
	...s VoiceHeader=$P(ClientVoiceTopIP,",",ClientVoiceIndex)_"*msg=callnumber&url="_VoiceHeaderFile
	...i VoiceHeaderFile="" d
	....i $G(SoundUDP)="" s SoundUDP=ClientUDPMess
	....e  s SoundUDP=SoundUDP_"#"_ClientUDPMess
	...e  d
	....i $G(SoundUDP)="" s SoundUDP=VoiceHeader_"#"_ClientUDPMess
	....e  s SoundUDP=SoundUDP_"#"_VoiceHeader_"#"_ClientUDPMess
	..i (type="R")||(type="P")||(type="U") s ClientVoice=..FormatSound(content_","_content)
	..e  s ClientVoice=..FormatSound($P(content,","))
	..q:ClientVoice=""
	..s SoundStr=ClientFileName_"*"_ClientVoice
	.i (ServerVoiceTopIP'="")&&(VoiceFile'="") d
	..s ServerFileName=..GetSoundFileName($P(ServerVoiceTopIP,","),queueId)
	..q:ServerFileName=""
	..f ServerVoiceIndex=1:1:$L(ServerVoiceTopIP,",") d
	...s ServerUDPMess=$P(ServerVoiceTopIP,",",ServerVoiceIndex)_"*msg=callnumber&url="_VoiceFile_ServerFileName
	...q:ServerUDPMess=""
	...s VoiceHeader=$P(ServerVoiceTopIP,",",ServerVoiceIndex)_"*msg=callnumber&url="_VoiceHeaderFile
	...i VoiceHeaderFile="" d
	....i $G(SoundUDP)'="" s SoundUDP=SoundUDP_"#"_ServerUDPMess
	....e  s SoundUDP=ServerUDPMess
	...e  d
	....i $G(SoundUDP)'="" s SoundUDP=SoundUDP_"#"_VoiceHeader_"#"_ServerUDPMess
	....e  s SoundUDP=VoiceHeader_"#"_ServerUDPMess
	..i (type="R")||(type="P")||(type="U") s ServerVoice=..FormatSound(content_","_content)
	..e  d
	...//i $P(content,",",2)'="" s ServerVoice=..FormatSound($P(content,",",2))
	...//e  s ServerVoice=..FormatSound(content)
	...s ServerVoice=..FormatSound(content_","_content)
	..q:ServerVoice=""
	..i $G(SoundStr)'="" s SoundStr=SoundStr_"#"_ServerFileName_"*"_ServerVoice
	..e  s SoundStr=ServerFileName_"*"_ServerVoice
	.i $G(SoundStr)'="" s SoundStr=FtpParm_"#"_SoundStr
	.s retStr=$G(SoundStr)_"^"_$G(SoundUDP)_"^"_retStr
	.//&SQL(update DHC_VIS_VoiceQueue set VIS_ShowState='Y' where VIS_QueueID=:queueId)
	.s num=num+1
	q retStr
}

/// w ##class(web.DHCVISVoiceCall).GetVoiceQueueShow("10.1.41.15")
ClassMethod GetVoiceQueueShow(serverIP) As %String
{
	//q "10.1.41.101*administrator*sea*/vis/voice/#277ID10141101.wav*<rate speed='-5'>请<silence msec='100'/>1号<silence msec='100'/>东华医疗<silence msec='100'/>等候</rate>^10.1.41.101*msg=callnumber&count=1&url=/vis/voice/177ID1016115.wav&session_id=101611539992^10.1.41.101*msg=dataupdate&areaid=notify&areatype=queue&dataid=39991&data=请到01诊室就诊,请1号东华医疗等候&areaid=l&areatype=lua&dataid=39991&action=addnew&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_"请到01诊室就诊,请1号东华医疗等候"""_";PatInfo="""_"2号 刘自喜"""_";</script></areadata>"
	//&areaid=queueinfo&areatype=queue&dataid=39992&data=<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> 4号,6号<br/>2号-刘＊喜<br/>蒋荣猛<br/>01诊室<br/>准备就诊<br/>当前就诊<br/>号别<br/>科室-诊室&areaid=waitinfo&areatype=queue&dataid=39992&data= 9 刘＊一(等候)<br/> 8刘＊十(等候)<br/> 7 刘＊芳(等候)<br/> 6 刘＊虹(等候)<br/> 5 刘＊枫(等候)<br/> 4柳＊红(等候)<br/> 3 柳＊红(等候)<br/> 2 刘＊喜(等候)<br/> 1 东华＊疗(等候)<br/>蒋荣猛(副主任)&color=0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff&areaid=partinfo&areatype=queue&dataid=39992&data=请保持安静,等候医生呼叫,过号患者请到分诊台报到!&areaid=windowinfo&areatype=queue&dataid=39992&data=传染科候诊区"
    //q "10.1.61.10*administrator*sea*/vis/voice/#287ID1016115.wav*<rate speed='-5'>请<silence msec='100'/>6号<silence msec='100'/>刘虹<silence msec='100'/>等候</rate>^10.1.61.15*msg=callnumber&count=1&url=/vis/voice/287ID1016115.wav&session_id=101611560575^10.1.61.15*msg=dataupdate&areaid=notify&areatype=queue&dataid=60575&data=请到01诊室就诊,请6号刘虹等候&areaid=l&areatype=lua&dataid=60575&action=addnew&data=<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_"请到01诊室就诊,请6号刘虹等候"""_";PatInfo="""_"5号 刘枫"";</script></areadata>"
	s retStr=""
	s hostname=$ZU(54,0)
	s dabaseIP=$P($ZU(54,13,hostname),",")
	s VoiceServerDir="\\"_dabaseIP_"\voice\"
	s FtpServerIP=$G(^DHCVISSet("Ftp","ServerIP"))
	i FtpServerIP="" s FtpServerIP=dabaseIP
	s FtpServerDir=$G(^DHCVISSet("Ftp","Voice"))
	i FtpServerDir="" s FtpServerDir="/voice/"
	s FtpUser=$G(^DHCVISSet("Ftp","User"))
	i FtpUser="" s FtpUser="administrator"
	s FtpPassword=$G(^DHCVISSet("Ftp","Password"))
	i FtpPassword="" s FtpPassword="123456"
	s FtpParm=FtpServerIP_"*"_FtpUser_"*"_FtpPassword_"*"_FtpServerDir
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	s num=0
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerShowState",nowDate,serverId,"N",queueId)) q:(queueId="")||(num>0)  d
	.d  &SQL(update DHC_VIS_VoiceQueue set VIS_ShowState='Y' where VIS_QueueID=:queueId)
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s clientId=$P(queueStr,"^",1)
	.s queueNo=$P(queueStr,"^",3)
	.s content=$P(queueStr,"^",4)
	.s type=$P(queueStr,"^",5)
	.s sound=$P(queueStr,"^",6)
	.s repeat=$P(queueStr,"^",7)
	.s zhContent=$P(queueStr,"^",17)
	.s ckContent=$P(queueStr,"^",18)
	.s waitList=$P(queueStr,"^",19)
	.s note=$P(queueStr,"^",20)
	.s docInfo=$P(queueStr,"^",22)
	.s ClientTopIP=$P($G(^DHCVISClient(clientId)),"^",16)
	.s LocTopIP=$P($G(^DHCVISClient(clientId)),"^",18)
	.s ClientVoiceTopIP=$P($G(^DHCVISClient(clientId)),"^",20)
	.s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	.s ServerVoiceTopIP=$P($G(^DHCVISServer(serverId)),"^",15)
	.i (type="D") d
	..s PrescNo=$P(ckContent,",",4)
	..i PrescNo'="" d
	...s UpdateFlag=..UpdatePrescState(PrescNo,"S")
	...i UpdateFlag<0 s ^DHCVISLedLog(queueId)=$G(^DHCVISLedLog(queueId))_ckContent_"错误:"_UpdateFlag
	.s ckTopStr=""
	.s locTopStr=""
	.s zhTopStr=""
	.s screenTopInfo=""
	.i $P(zhContent,"*",2)'="" d
	..s QueRowId=+zhContent
	..s zhContent=$P(zhContent,"*",2)
	.i $P(waitList,"*",2)'="" d
	..s waitList=..GetWaitList(waitList)
	..i waitList'="" s zhContent=zhContent_waitList

	.s ^DHCTempVIS(+$H,serverId,clientId)=queueId_"*"_zhContent
	.s ckContent=content
	.s zkContent=content
	.i $P(content,",",2)'="" d
	..s ckContent=$P(content,",",1)
	..//s zkContent=$P(content,",",2)
	.i ClientTopIP'="" s ckTopStr=..GetWindowTopStr(ClientTopIP,ckContent,docInfo)
	.i (LocTopIP'="")&&(ServerVoiceTopIP'="") s locTopStr=..GetZHWindowTopStr(LocTopIP,ckContent)
	.//i (LocTopIP'="")&&(ServerTopIP'="") s ServerTopIP=ServerTopIP_","_LocTopIP
	.//i (LocTopIP'="")&&(ServerTopIP="") s ServerTopIP=LocTopIP

	.i (ServerTopIP'="")&&(ServerVoiceTopIP'="") s zhTopStr=..GetZHWindowTopStr(ServerTopIP,zkContent)
	.//i (LocTopIP'="")||(ckTopStr'="")||(zhTopStr'="")  s screenTopInfo=..GetScreenTopInfo(serverIP)
	.s screenTopInfo=""
	.i ckTopStr'="" s retStr=ckTopStr
	.i (retStr'="")&&(locTopStr'="") s retStr=retStr_"#"_locTopStr
	.i (retStr="")&&(locTopStr'="") s retStr=locTopStr
	.i (retStr'="")&&(zhTopStr'="") s retStr=retStr_"#"_zhTopStr  //Ding  声音跟文字提示同步   注释
	.i (retStr="")&&(zhTopStr'="") s retStr=zhTopStr              //Ding  声音跟文字提示同步   注释
	.i (retStr'="")&&(screenTopInfo'="") s retStr=retStr_"#"_screenTopInfo
	.i (retStr="")&&(screenTopInfo'="") s retStr=screenTopInfo
	
	.//分发声音文件
	.s VoiceHeaderFile=$G(^DHCVISSet("Ftp","VoiceHeader"))
	.s VoiceFile=$G(^DHCVISSet("Ftp","Voice"))
	.i (ClientVoiceTopIP'="")&&(VoiceFile'="") d
	..s ClientFileName=..GetSoundFileName(ClientVoiceTopIP,queueId)
	..q:ClientFileName=""
	..s VoiceCount=+$G(^DHCVISSet("Voice","VoiceCount"))
	..i VoiceCount<1 s VoiceCount=1
	..f ClientVoiceIndex=1:1:$L(ClientVoiceTopIP,",") d
	...s RemoteIP=$P(ClientVoiceTopIP,",",ClientVoiceIndex)
	...s SessionID=$TR(RemoteIP,".")_$P($H,",",2)
	
	...s ClientUDPMess=RemoteIP_"*msg=callnumber&count="_VoiceCount_"&url="_VoiceFile_ClientFileName_"&session_id="_SessionID
	...//s ClientUDPMess=RemoteIP_"*msg=callnumber&url="_VoiceFile_ClientFileName
	...s InsertUDPMessage=..InsertUDPMessage(serverId,SessionID, RemoteIP, ClientUDPMess)
	...s VoiceHeader=RemoteIP_"*msg=callnumber&url="_VoiceHeaderFile
	...i VoiceHeaderFile="" d
	....i $G(SoundUDP)="" s SoundUDP=ClientUDPMess
	....e  s SoundUDP=SoundUDP_"#"_ClientUDPMess
	...e  d
	....i $G(SoundUDP)="" s SoundUDP=VoiceHeader_"#"_ClientUDPMess
	....e  s SoundUDP=SoundUDP_"#"_VoiceHeader_"#"_ClientUDPMess
	..i (type="R")||(type="P")||(type="T") s ClientVoice=..FormatSound(content)
	..e  s ClientVoice=..FormatSound($P(content,","))
	..q:ClientVoice=""
	..s SoundStr=ClientFileName_"*"_ClientVoice
	.i (ServerVoiceTopIP'="")&&(VoiceFile'="") d
	..s ServerFileName=..GetSoundFileName($P(ServerVoiceTopIP,","),queueId)
	..q:ServerFileName=""
	..s VoiceCount=+$G(^DHCVISSet("Voice","VoiceCount"))
	..i VoiceCount<1 s VoiceCount=1
	..f ServerVoiceIndex=1:1:$L(ServerVoiceTopIP,",") d
	...s RemoteIP=$P(ServerVoiceTopIP,",",ServerVoiceIndex)
	...s SessionID=$TR(RemoteIP,".")_$P($H,",",2)
	...//s SynCallStr=$P(zhTopStr,"&",2,15)     //Ding  声音跟文字提示同步  add 
	...//s ServerUDPMess=RemoteIP_"*msg=callnumber&count="_VoiceCount_"&url="_VoiceFile_ServerFileName_"&session_id="_SessionID_zhTopStr  //Ding  声音跟文字提示同步   edit
	...s ServerUDPMess=RemoteIP_"*msg=callnumber&url="_VoiceFile_ServerFileName_"&session_id="_SessionID
	...q:ServerUDPMess=""
	...s InsertUDPMessage=..InsertUDPMessage(serverId,SessionID, RemoteIP, ServerUDPMess)
	...s VoiceHeader=RemoteIP_"*msg=callnumber&url="_VoiceHeaderFile
	...i VoiceHeaderFile="" d
	....i $G(SoundUDP)'="" s SoundUDP=SoundUDP_"#"_ServerUDPMess
	....e  s SoundUDP=ServerUDPMess
	...e  d
	....i $G(SoundUDP)'="" s SoundUDP=SoundUDP_"#"_VoiceHeader_"#"_ServerUDPMess
	....e  s SoundUDP=VoiceHeader_"#"_ServerUDPMess
	..//i (type="R")||(type="P")||(type="T") s ServerVoice=..FormatSound(content)
	..//e  d
	...//i $P(content,",",2)'="" s ServerVoice=..FormatSound($P(content,",",2))
	...//e  s ServerVoice=..FormatSound(content)
	..s ServerVoice=..FormatSound(content)
	..q:ServerVoice=""
	..i $G(SoundStr)'="" s SoundStr=SoundStr_"#"_ServerFileName_"*"_ServerVoice
	..e  s SoundStr=ServerFileName_"*"_ServerVoice
	.i $G(SoundStr)'="" s SoundStr=FtpParm_"#"_SoundStr
	.s retStr=$G(SoundStr)_"^"_$G(SoundUDP)_"^"_retStr
	.//s retStr=$G(SoundStr)_"^"_"^"_retStr
	.//&SQL(update DHC_VIS_VoiceQueue set VIS_ShowState='Y' where VIS_QueueID=:queueId)
	.s num=num+1
	q retStr
}

ClassMethod InsertUDPMessage(ServerID As %String = "", SessionID As %String = "", RemoteIP As %String = "", Content As %String = "", Note As %String = "") As %String
{
	s State="New",CreateDate=+$H,CreateTime=+$P($H,",",2)
	&SQL(Insert into DHC_VIS_UDPMessages (ServerID,SessionID,RemoteIP,Content,Note,State,CreateDate,CreateTime) values (:ServerID,:SessionID,:RemoteIP,:Content,:Note,:State,:CreateDate,:CreateTime))
	q 0
}

ClassMethod UpdateUDPMessageState(SessionID As %String = "") As %String
{
	s State="Success",UpdateDate=+$H
	&SQL(Update DHC_VIS_UDPMessages set State=:State where CreateDate=:UpdateDate and SessionID=:SessionID)
	q 0
}

/// w ##Class(web.DHCVISVoiceCall).GetFailUDPMessage("10.72.24.136")
ClassMethod GetFailUDPMessage(SessionIP As %String = "") As %String
{
	s RetStr=""
	//s ServerId=$O(^DHCVISServeri(0,"ServerIP",SessionIP,""))
	//q:ServerId="" RetStr
	s NowDate=+$H,NowTime=+$P($H,",",2)
	s ServerId=""
	f  s ServerId=$O(^DHCVISUDPMi(0,"DateServerState",NowDate,ServerId)) q:ServerId=""  d
	.s MessageId=""
	.f  s MessageId=$O(^DHCVISUDPMi(0,"DateServerState",NowDate,ServerId,"New",MessageId)) q:MessageId=""  d
	..s MessageStr=$G(^DHCVISUDPM(MessageId))
	..q:MessageStr=""
	..s CreateTime=$P(MessageStr,"^",7)
	..i NowTime-CreateTime>10 &SQL(Update DHC_VIS_UDPMessages set State='Invalid' where ID=:MessageId)
	..q:NowTime-CreateTime<5
	..&SQL(Update DHC_VIS_UDPMessages set State='Failure' where ID=:MessageId)
	..s Content=$P(MessageStr,"^",2)
	..q:Content=""
	..i RetStr="" s RetStr=Content
	..e  s RetStr=RetStr_"#"_Content
	q RetStr
}

ClassMethod GetSoundFileName(TopIP As %String = "", QueueID As %String = "") As %String
{
	s RetFileName=""
	s IPLen=$L(TopIP,".")
	f i=1:1:IPLen d
	.s IPList=$P(TopIP,".",i)
	.i RetFileName="" s RetFileName=IPList
	.e  s RetFileName=RetFileName_IPList
	i RetFileName'="" s RetFileName=RetFileName_".wav"
	s RetFileName=$TR(RetFileName,",")
	i QueueID'="" s RetFileName=QueueID_"ID"_RetFileName
	q RetFileName
}

/// w ##class(web.DHCVISVoiceCall).FormatSound("请 1号 连春英 到 01诊室 就诊")
ClassMethod FormatSound(ContentStr As %String = "") As %String
{
	s RetSoundStr=""
	s soundContent=""
	s SilenceTime=+$G(^DHCVISSet("Voice","Silence"))
	i SilenceTime=0 s SilenceTime=100
	s contentLen=$L(ContentStr," ")
	f i=1:1:contentLen d
	.i RetSoundStr="" s RetSoundStr=$P(ContentStr," ",i)
	.e  s RetSoundStr=RetSoundStr_"<silence msec='"_SilenceTime_"'/>"_$P(ContentStr," ",i)
	s RetSoundStr=$TR(RetSoundStr,"+","加")
	s VoiceRate=+$G(^DHCVISSet("Voice","Rate"))
	i VoiceRate'=0 d
	.s RetSoundStr="<rate speed='"_VoiceRate_"'>"_RetSoundStr_"</rate>"
	q RetSoundStr
}

/// w ##class(web.DHCVISVoiceCall).FormatSound("请 连春英 连春英 到 基数 号窗口取药")
ClassMethod FormatDrugSound(ContentStr As %String = "") As %String
{
	s RetSoundStr=""
	s soundContent=""
	s contentLen=$L(ContentStr," ")
	f i=1:1:contentLen d
	.i RetSoundStr="" s RetSoundStr=$P(ContentStr," ",i)
	.e  s RetSoundStr=RetSoundStr_"<silence msec='100'/>"_$P(ContentStr," ",i)
	s VoiceRate=+$G(^DHCVISSet("Voice","Rate"))
	i VoiceRate'=0 d
	.s RetSoundStr="<rate speed='"_VoiceRate_"'>"_RetSoundStr_"</rate>"
	q RetSoundStr
}

/// w ##class(web.DHCVISVoiceCall).GetVoiceQueue("10.128.25.98")
ClassMethod GetVoiceQueue(serverIP) As %String
{
	s retStr=""
	s hostname=$ZU(54,0)
	s dabaseIP=$P($ZU(54,13,hostname),",")
	s VoiceServerDir="\\"_dabaseIP_"\voice\"
	s FtpServerIP=$G(^DHCVISSet("Ftp","ServerIP"))
	i FtpServerIP="" s FtpServerIP=dabaseIP
	s FtpServerDir=$G(^DHCVISSet("Ftp","Voice"))
	i FtpServerDir="" s FtpServerDir="/voice/"
	s FtpUser=$G(^DHCVISSet("Ftp","User"))
	i FtpUser="" s FtpUser="administrator"
	s FtpPassword=$G(^DHCVISSet("Ftp","Password"))
	i FtpPassword="" s FtpPassword="123456"
	s FtpParm=FtpServerIP_"*"_FtpUser_"*"_FtpPassword_"*"_FtpServerDir
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverId)
	s num=0
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerState",nowDate,serverId,"N",queueId)) q:(queueId="")||(num>0)  d
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s clientId=$P(queueStr,"^",1)
	.s queueNo=$P(queueStr,"^",3)
	.s content=$P(queueStr,"^",4)
	.s type=$P(queueStr,"^",5)
	.s sound=$P(queueStr,"^",6)
	.s repeat=$P(queueStr,"^",7)
	.s zhContent=$P(queueStr,"^",17)
	.s ckContent=$P(queueStr,"^",18)
	.s waitList=$P(queueStr,"^",19)
	.s note=$P(queueStr,"^",20)
	.s ClientTopIP=$P($G(^DHCVISClient(clientId)),"^",16)
	.s LocTopIP=$P($G(^DHCVISClient(clientId)),"^",18)
	.s ClientVoiceTopIP=$P($G(^DHCVISClient(clientId)),"^",20)
	.s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	.s ServerVoiceTopIP=$P($G(^DHCVISServer(serverId)),"^",15)
	.s ckScreenStr=""
	.s ckTopStr=""
	.s locTopStr=""
	.s zhTopStr=""
	.s screenTopInfo=""
	.i $P(zhContent,"*",2)'="" d
	..s QueRowId=+zhContent
	..s zhContent=$P(zhContent,"*",2)
	.i $P(waitList,"*",2)'="" d
	..s waitList=..GetWaitList(waitList)
	..i waitList'="" s zhContent=zhContent_waitList
	.s ^DHCTempVIS(+$H,serverId,clientId)=queueId_"*"_zhContent
	.i clientId'="" d 
	..s clientName=$P($G(^DHCVISClient(clientId)),"^",3)
	..s comPort=+$P($G(^DHCVISClient(clientId)),"^",4)
	..//i comPort=0 s comPort=1
	..s ledNum=+$P($G(^DHCVISClient(clientId)),"^",5)
	..//i ledNum=0 s ledNum=1
	..s ledColorNo=+$P($G(^DHCVISClient(clientId)),"^",6)
	..i ledColorNo=0 s ledColorNo=17
	..s ledShowMode=+$P($G(^DHCVISClient(clientId)),"^",7)
	..i ledShowMode=0 s ledShowMode=0
	..s ledShowSpeed=+$P($G(^DHCVISClient(clientId)),"^",8)
	..i ledShowSpeed=0 s ledShowSpeed=0
	..s ledShowTime=+$P($G(^DHCVISClient(clientId)),"^",9)
	..i ledShowTime=0 s ledShowTime=0
	..s clientIP=$P($G(^DHCVISClient(clientId)),"^",2)
	..s shareFlag=$P($G(^DHCVISClient(clientId)),"^",12)
	..s ClientTopIP=$P($G(^DHCVISClient(clientId)),"^",16)
	..s ClientTopDesc=$P($G(^DHCVISClient(clientId)),"^",17)
	..s LocTopIP=$P($G(^DHCVISClient(clientId)),"^",18)
	..s LocTopDesc=$P($G(^DHCVISClient(clientId)),"^",19)
	.e  d
	..s clientName=$P(queueStr,"^",9)
	..s comPort=0
	..s ledNum=0
	..s ledColorNo=0
	..s ledShowMode=0
	..s ledShowSpeed=0
	..s ledShowTime=0
	..s clientIP=""
	..s ClientTopIP=""
	..s ClientTopDesc=""
	..s LocTopIP=""
	..s LocTopDesc=""
	.i serverId'=""  d
	..s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	..s serverComPort=+$P($G(^DHCVISServer(serverId)),"^",4)
	..//i serverComPort=0 s serverComPort=1
	..s serverLedNum=+$P($G(^DHCVISServer(serverId)),"^",5)
	..//i serverLedNum=0 s serverLedNum=1
	..s serverLedColorNo=+$P($G(^DHCVISServer(serverId)),"^",6)
	..//i serverLedColorNo=0 s serverLedColorNo=17
	..s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	..s ServerTopDesc=$P($G(^DHCVISServer(serverId)),"^",14)
	.e  d
	..s serverName=$P(queueStr,"^",10)
	..s serverComPort=0
	..s serverLedNum=0
	..s serverLedColorNo=0
	..s ServerTopIP=""
	..s ServerTopDesc=""
	.i queueNo#2=0  d
	..s serverLedColorNo=serverLedColorNo+17
	..i serverLedColorNo>51 s serverLedColorNo=serverLedColorNo-34
	.q:(type="")!(content="")!(clientName="")!(serverName="")
	.s ledScreenStr=content
	.s typeDesc=""
	.i $G(screenStr)="" s screenStr=content  //queueNo_"."_content           //LED 显示模式
	.//i type="D" d
	..//s PrescNo=$P(ckContent,",",4)
	..//s UpdateFlag=..UpdatePrescState(PrescNo,"S")
	..//i UpdateFlag<0 s ^DHCVISLedLog(queueId)=$G(^DHCVISLedLog(queueId))_ckContent_"错误:"_UpdateFlag
	
	.i type="D" d
	..s soundContent=..FormatSound(content)
	..//i $P(soundContent,"06",2)'="" s soundContent=$P(soundContent,"06",1)_"<silence msec='100'/>06"_$P(soundContent,"06",2)
	..s serverComPort=0
	..//i $P(ckContent,"中药房",2)'="" s ckContent=$P(ckContent,"中药房",2)
	..s ledNum=+$P(ckContent,",")
	..i ledNum=0 s ledNum=1
	..//s InsertFlag=..InsertLedInfo(ckContent)
	..//i InsertFlag<0 s ^DHCVISLedLog(queueId)=ckContent_"错误:"_InsertFlag
	..////插入药房大屏滚动信息
	..s PrescNo=$P(ckContent,",",4)
	..s UpdateFlag=..UpdatePrescState(PrescNo,"S")
	..i UpdateFlag<0 s ^DHCVISLedLog(queueId)=$G(^DHCVISLedLog(queueId))_ckContent_"错误:"_UpdateFlag
	..s screenStr=$P(ckContent,",",2)
	..//s ckContent="请"_$P(ckContent,",",2)_"取药"
	..i ClientTopIP'="" s ckTopStr=..GetDurgCKTopStr(ClientTopIP,content)
	..e  s ckTopStr=""
	..s contentStr=sound_"!"_repeat_"!"_soundContent
	..i ckContent'="" s ledScreenStr=$P(ckContent,",",2)
	..//s ledScreenStr=ledScreenStr_"!"_comPort_"!"_ledNum_"!"_ledColorNo_"!"_ledShowMode_"!"_ledShowSpeed_"!"_ledShowTime
	..s synScreen=""
	..s ckScreenStr=ckContent
	
	
	
	.s soundContent=""
	.s screenStr=""
	.s serverLedColorNo=17
	.s VoiceCount=+$G(^DHCVISSet("Voice","VoiceCount"))
	.i (VoiceCount>1)&&(type'="D") d
	..s soundContent=..FormatSound(content_"."_content)
	..i $P(content,",",2)'="" s soundContent=..FormatSound($P(content,",",2)_"."_$P(content,",",2))
	.e  d
	..s soundContent=..FormatSound(content)
	..i $P(content,",",2)'="" s soundContent=..FormatSound($P(content,",",2))
	.i type="U" d
	..s soundContent=$TR(content," ")
	..s soundContent=..FormatSound(content)
	..i $P(content,",",2)'="" s soundContent=..FormatSound($P(content,",",2))
	.i type="D" d
	..s soundContent=..FormatDrugSound(content)
	.s zkContent=content
	.s ckContent=content
	.i $P(content,",",2)'="" d
	..s ckContent=$P(content,",",1)
	..s zkContent=$P(content,",",2)
	.i ClientTopIP'="" d
	..s ckTopStr=..GetWindowTopStr(ClientTopIP,ckContent)
	.e  d
	..i clientIP'="" s ckScreenStr=clientIP_"!"_ckContent
	.i LocTopIP'="" s locTopStr=..GetZHWindowTopStr(LocTopIP,zkContent)
	.i (ckTopStr'="")&&(locTopStr'="") s ckTopStr=ckTopStr_"#"_locTopStr
	.i ServerTopIP'="" s zhTopStr=..GetZHWindowTopStr(ServerTopIP,zkContent)
	.i (LocTopIP'="")||(ckTopStr'="")||(zhTopStr'="")  s screenTopInfo=..GetScreenTopInfo(serverIP)
	.i (zhTopStr'="")&&(locTopStr'="") s zhTopStr=zhTopStr_"#"_locTopStr
	.i (zhTopStr="")&&(locTopStr'="") s zhTopStr=locTopStr
	.i (zhTopStr'="")&&(screenTopInfo'="") s zhTopStr=zhTopStr_"#"_screenTopInfo
	.i (zhTopStr="")&&(screenTopInfo'="") s zhTopStr=screenTopInfo
	.i (content'="")&&(screenStr="") s screenStr=content
	.i (ckContent'="")&&(type'="D") s ledScreenStr=$P(ckContent,"!",5)
	.s screenParm=serverComPort_"!"_serverLedNum_"!"_serverLedColorNo
	.s contentStr=sound_"!"_repeat_"!"_soundContent
	.s screenStr=screenStr_"!"_screenParm
	.i $L(ledScreenStr,"!")>2 s ledScreenStr=""
	.e  s ledScreenStr=ledScreenStr_"!"_comPort_"!"_ledNum_"!"_ledColorNo_"!"_ledShowMode_"!"_ledShowSpeed_"!"_ledShowTime
	.i ckTopStr'="" s ledScreenStr=""
	.s synScreen=note
	.d ..UpdateVoiceQueue(queueId,clientId,serverId,soundContent)
	.s waitList=""
	.s retStr=contentStr_"^"_screenStr_"^"_ledScreenStr_"^"_ckScreenStr_"^"_synScreen_"^"_waitList_"^"_ckTopStr_"^"_zhTopStr
	.//e  s retStr=retStr_contentStr_"^"_screenStr_"^"_ledScreenStr_"^"_ckScreenStr_"^"_synScreen_"^"_waitList_"^"_ckTopStr_"^"_zhTopStr
	.s num=num+1
	.s ^DHCTempDHCVIS(+$H,serverId,clientId)=$H_"*"_zhContent
	q retStr
}

/// w ##class(web.DHCVISVoiceCall).GetWaitList("228*2,229*3,230*4,231*5")
ClassMethod GetWaitList(waitListStr As %String = "", QueRowId As %String = "") As %String
{
	s QueRowId=+QueRowId
	s DocDr=""
	i QueRowId>0 d
	.s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.q:QueObj=""
	.s DocDr=QueObj.QueDocDr
	s RetWaitStr=""
	q:waitListStr="" RetWaitStr
	s listLen=$L(waitListStr,",")
	f j=1:1:listLen d
	.s waitListOne=$P(waitListStr,",",j)
	.q:waitListOne=""
	.q:$P(waitListOne,"*",2)=""
	.s waitQueueId=$P(waitListOne,"*",1)
	.s Status=..GetAdmStatus(waitQueueId)
	.q:(Status="到达")!(Status="过号")!(Status="退号")
	.s QueObj=##Class(User.DHCQueue).%OpenId(waitQueueId)
	.q:QueObj=""
	.q:QueObj.QueCompDr="1"
	.q:(DocDr'="")&&(QueObj.QueDocDr'="")&&(DocDr'=QueObj.QueDocDr)
	.s QueName=QueObj.QueName
	.s QueName=$$ALPHAUP^SSUTIL4(QueName)
	.s waitQueueNo=$P(waitListOne,"*",2)
	.q:$L(RetWaitStr,",")>1
	.//i RetWaitStr="" s RetWaitStr=waitQueueNo_"号"_QueName
	.//e  s RetWaitStr=RetWaitStr_","_waitQueueNo_"号"_QueName
	.i RetWaitStr="" s RetWaitStr=waitQueueNo_"号"
	.e  s RetWaitStr=RetWaitStr_","_waitQueueNo_"号"
	i RetWaitStr'="" s RetWaitStr=""_RetWaitStr
	q RetWaitStr
}

ClassMethod GetAdmStatus(QueRowId As %String = "") As %String
{
	s Status=""
	s oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	i oref'="" d
	.s Status=oref.QueStateDr.PersName
	.d oref.%Close()
	q Status
}

ClassMethod UpdateVoiceQueue(queueId As %String = "", clientId As %String = "", serverId As %String = "", contentStr As %String = "") As %String
{
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceQueue set VIS_State='Y',VIS_UpdateServerID=:serverId,VIS_UpdateDate=:nowDate,VIS_UpdateTime=:nowTime where VIS_QueueID=:queueId)
	&SQL(Insert into DHC_VIS_VoiceLog (VIS_VoiceContent,VIS_ClientID,VIS_ServerID,VIS_UpdateDate,VIS_UpdateTime,VIS_QueueID) values (:contentStr,:clientId,:serverId,:nowDate,:nowTime,:queueId))
}

ClassMethod DoMethod() As %String
{
	w ##class(web.DHCVISVoiceCall).InsertVoiceQueue("请 05号 郭石宝 到 男科 05诊室 就诊","1","10.193.18.82","A","LR","N","男科01诊室     郭宝平   05号  郭石宝")
}

/// w ##class(web.DHCVISVoiceCall).InsertVoiceQueue("请 郭石宝 郭石宝 到 2号窗口取药","1","172.18.6.56","D","LR","N","1,郭石宝,40000889,O12101800063,","2号窗口,郭石宝 ,40000889,O12101800063,","","")
/// w ##class(web.DHCVISVoiceCall).InsertVoiceQueue("请 屈洪量 到 1号发药窗口 取药","48","192.168.22.88","D","LR","N,1号发药窗口,屈洪量,0000074553,OPT16030300014,1号发药窗口,屈洪量,0000074553,OPT16030300014,,,,")
ClassMethod InsertVoiceQueue(voiceContent As %String, userId As %String, clientIP As %String = "", type As %String = "A", sound As %String = "LR", repeat As %String = "N", ZHScreenStr As %String = "", CKScreenStr As %String = "", WaitList As %String = "", Note As %String = "", DocInfo As %String = "", PatInfo As %String = "") As %String
{
	//i type="D" s ^zyl("InsertVoiceQueue",+$h)=voiceContent_","_userId_","_clientIP_","_type_","_sound_","_repeat_","_ZHScreenStr_","_CKScreenStr_","_WaitList_","_Note_","_DocInfo_","_PatInfo
	//i $G(clientIP)="" s clientIP=$ZUTIL(67,15,$JOB)
	//i type="D" s ^ding($h)=voiceContent_"**"_clientIP_"**"_CKScreenStr
	i $G(clientIP)="" d
	.i $D(%session) s clientIP=%session.Data("REMOTE_ADDR")
	i $G(clientIP)="" s clientIP=$ZUTIL(67,15,$JOB)
	s userId=+userId
	//i (type="D") s userId=%session.Get("LOGON.USERID")
	i (type="D") d
	.i clientIP[".p" s clientIP=$p(clientIP,".p")
	.i $P(CKScreenStr,"中药房",2)'="" s CKScreenStr=$P(CKScreenStr,"中药房",2)
	.s InsertFlag=..InsertLedInfo(CKScreenStr,clientIP)
	.i InsertFlag'=0 d
	..s LogId=$O(^DHCVISLedWaitLog(""),-1)+1
	..i LogId="" s LogId=1
	..s ^DHCVISLedWaitLog(LogId)=CKScreenStr_"错误:"_InsertFlag_"IP:"_clientIP
	q:(type="D")&&(voiceContent="") 0
	//q:(type="D")
	q:(clientIP="")!(userId=0)!(voiceContent="") "叫号信息不完整!"
	q:$G(^SSU("SSUSR",userId))="" "用户不存在!"
	s clientId=$O(^DHCVISClienti(0,"ClientIP",clientIP,""))
	q:clientId="" "电脑没有叫号权限,请联系信息科!"
	s serverId=$P($G(^DHCVISClient(clientId)),"^",1)
	s clientName=$P($G(^DHCVISClient(clientId)),"^",3)
	//i (type="D") d
	//.s $p(CKScreenStr,",",1)=+clientName
	//.s voiceContent=voiceContent_clientName_"取药"
	q:serverId="" "叫号终端未设置叫号服务!"
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" "叫号服务不可用!"
	s nowDate=+$H,nowTime=$P($H,",",2)
	i $L(Note," ")<4 s Note=Note_"    "
	
	s waitNum1=0,exitFlag1=0,waitNum2=0,exitFlag2=0
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerState",nowDate,serverId,"N",queueId)) q:queueId=""  d
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.i ((clientId=$P(queueStr,"^",1))&&(voiceContent=$P(queueStr,"^",4))) s exitFlag1=exitFlag1+1
	.s waitNum1=waitNum1+1
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerShowState",nowDate,serverId,"N",queueId)) q:(queueId="")  d
	.s queueStr=$G(^DHCVISQueue(queueId))
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.i ((clientId=$P(queueStr,"^",1))&&(voiceContent=$P(queueStr,"^",4))) s exitFlag2=exitFlag2+1
	.s waitNum2=waitNum2+1
	q:(exitFlag1>1)&(exitFlag2>1) "呼叫任务未处理,请稍候再试!"
	q:(waitNum1>100)&(waitNum2>100) "呼叫队列未处理任务过多,请稍候再试!"	
	
	i repeat="N" s queueNo=+$O(^DHCVISQueuei(0,"DateServerNo",nowDate,serverId,""),-1)+1
	e  s queueNo=+$O(^DHCVISQueuei(0,"DateServerNo",nowDate,serverId,""),-1)
	i ZHScreenStr'="" d
	.&SQL(insert into DHC_VIS_VoiceQueue (VIS_ClientID,VIS_ServerID,VIS_QueueNo,VIS_ClientName,VIS_ServerName,VIS_VoiceContent,VIS_State,VIS_Type,VIS_Sound,VIS_Repeat,VIS_CreatDate,VIS_CreatTime,VIS_CreatUser,VIS_ZHScreenStr,VIS_CKScreenStr,VIS_WaitList,VIS_Note,VIS_ShowState,VIS_DocInfo,VIS_PatID) values (:clientId,:serverId,:queueNo,:clientName,:serverName,:voiceContent,'N',:type,:sound,:repeat,:nowDate,:nowTime,:userId,:ZHScreenStr,:CKScreenStr,:WaitList,:Note,'N',:DocInfo,:PatInfo))
	e  d
	.&SQL(insert into DHC_VIS_VoiceQueue (VIS_ClientID,VIS_ServerID,VIS_QueueNo,VIS_ClientName,VIS_ServerName,VIS_VoiceContent,VIS_State,VIS_Type,VIS_Sound,VIS_Repeat,VIS_CreatDate,VIS_CreatTime,VIS_CreatUser) values (:clientId,:serverId,:queueNo,:clientName,:serverName,:voiceContent,'N',:type,:sound,:repeat,:nowDate,:nowTime,:userId))
	i SQLCODE'=0 q "叫号队列更新失败!"
	q SQLCODE
}

/// w ##class(web.DHCVISVoiceCall).Call("董禄宁","1","127.22.132.200","A","LR","Y")
ClassMethod Call(voiceContent As %String, userId As %String, clientIP As %String = "", type As %String = "A", sound As %String = "LR", repeat As %String = "N") As %String
{
	s ret=##class(web.DHCVISVoiceCall).InsertVoiceQueue(voiceContent,userId,clientIP,type,sound,repeat)
	q ret
}

/// w ##class(web.DHCVISVoiceCall).ReplaceCall("董禄宁","1",45,"A","LR","Y")
/// 诊区分诊护士代替呼叫
ClassMethod ReplaceCall(voiceContent As %String, userId As %String, exaRoomId As %String, type As %String = "A", sound As %String = "LR", repeat As %String = "N") As %String
{
	q:exaRoomId="" "诊室不存在!"
	s clientId=$O(^DHCVISClienti(0,"ExaRoomId",exaRoomId,""))
	q:clientId="" "该诊室没有对应的呼叫服务!"
	s clientIP=$P($G(^DHCVISClient(clientId)),"^",2)
	q:clientIP="" "该诊室没有对应的呼叫服务!"
	s retStr=##class(web.DHCVISVoiceCall).InsertVoiceQueue(voiceContent,userId,clientIP,type,sound,repeat)
	q retStr
}

ClassMethod GetServerContent(serverIP As %String) As %String
{
	s retStr=""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" retStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	s retStr="服务IP:"_serverIP_";名称:"_serverName_";端口:1972"
	q retStr
}

/// w ##class(web.DHCVISVoiceCall).GetServerComPort("192.168.0.104")
ClassMethod GetServerComPort(serverIP As %String) As %String
{
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" 0
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" 0
	s serverComPort=+$P($G(^DHCVISServer(serverId)),"^",4)
	s serverScreenNo=+$P($G(^DHCVISServer(serverId)),"^",5)
	//q:serverScreenNo>100 0
	q serverComPort
}

ClassMethod InsertLedInfo(CKScreenStr As %String = "", ClientIP As %String = "") As %String
{
	q:CKScreenStr="" 0	
	s WindowDesc=$P(CKScreenStr,",",1)
	s PatNo=$P(CKScreenStr,",",3)
	s PatName=$P(CKScreenStr,",",2)
	s PrescNo=$P(CKScreenStr,",",4)
	s InsertUser=1
	q:(PatNo="")!(PatName="")!(PrescNo="")!(WindowDesc="")!(InsertUser="") 0
	s WindowNo=+WindowDesc
	//i ClientIP'="" s TopIP=..GetTopIPByClientIP(ClientIP,WindowDesc)
	//e  s TopIP=""
	s ClientID=$O(^DHCVISClienti(0,"ClientIP",ClientIP,""))
	q:ClientID="" "客户端未授权"
	s serverID=+$P($G(^DHCVISClient(ClientID)),"^")
	q:serverID=0 "客户端未授权"
	s PrescState="W"
	s VisWindowNo=+$P($G(^DHCVISClient(ClientID)),"^",5)
	i VisWindowNo>0 s WindowNo=VisWindowNo
	s serverName=$P($G(^DHCVISServer(serverID)),"^",2)
	i serverName["西院区" s WindowNo=+$P($G(^DHCVISClient(ClientID)),"^",3)
	i serverName["西院区" s WindowDesc=WindowNo
	i WindowNo=0 s WindowNo=1
	//i serverName["西院区" s ^DHCVISDing($h)=WindowNo_"**"_PatName_"**"_WindowDesc_"**"_ClientIP
	s TopIP=..GetTopIPByClientIP(ClientIP,WindowDesc)
	s ActiveFlag="Y"
	s InsertDate=+$H
	s InsertTime=$P($H,",",2)
	s GetRetSult=""
	s GetRetPres=""
	s SQLCODE=0
	s ListRowD=$O(^DHCVISDurgListi(0,"PrescNo",PrescNo,""))
	i ListRowD'="" d
	.s InsertDate=$P($G(^DHCVISDurgList(ListRowD)),"^",8)
	.i InsertDate<(+$H) d
	..&SQL(delete from DHC_VIS_DurgLedList where RowID=:ListRowD)
	i ListRowD="" d
	.&SQL(insert into DHC_VIS_DurgLedList (PatNo,PatName,PrescNo,WindowDesc,WindowNo,ActiveFlag,InsertDate,InsertTime,InsertUser,TopIP,PrescState,ServerID) values (:PatNo,:PatName,:PrescNo,:WindowDesc,:WindowNo,:ActiveFlag,:InsertDate,:InsertTime,:InsertUser,:TopIP,:PrescState,:serverID))
	q SQLCODE
	//&SQL(select PatNo into :GetRetSult from  DHC_VIS_DurgLedList where InsertDate=:InsertDate and ActiveFlag='Y' and PrescNo=:PrescNo)
	//&SQL(select PrescNo into :GetRetPres from  DHC_VIS_DurgLedList where InsertDate=:InsertDate and ServerID=:serverID and WindowNo=:WindowNo and ActiveFlag='Y' and PatNo=:PatNo and (WindowDesc=:WindowDesc or PrescNo=:PrescNo) and PrescState='W')
	&SQL(select PrescNo into :GetRetPres from  DHC_VIS_DurgLedList where InsertDate=:InsertDate and ServerID=:serverID and WindowNo=:WindowNo and ActiveFlag='Y' and PrescNo=:PrescNo)
	//i (GetRetSult="")!(GetRetPres="") d
	i (GetRetPres="") d
	.&SQL(insert into DHC_VIS_DurgLedList (PatNo,PatName,PrescNo,WindowDesc,WindowNo,ActiveFlag,InsertDate,InsertTime,InsertUser,TopIP,PrescState,ServerID) values (:PatNo,:PatName,:PrescNo,:WindowDesc,:WindowNo,:ActiveFlag,:InsertDate,:InsertTime,:InsertUser,:TopIP,:PrescState,:serverID))
	q SQLCODE
}

ClassMethod UpdatePrescState(PrescNo As %String = "", PrescState As %String = "W") As %String
{
	q:PrescNo="" 0
	s NowDate=+$H
	&SQL(Update DHC_VIS_DurgLedList set PrescState=:PrescState where InsertDate=:NowDate and PrescNo=:PrescNo)
	q SQLCODE
}

/// w ##class(web.DHCVISVoiceCall).GetTopIPByClientIP("172.16.20.47","七号窗口")
ClassMethod GetTopIPByClientIP(ClientIP As %String = "", WindowDesc As %String = "") As %String
{
	s RetTopIP=""
	i WindowDesc="" d
	.s PreClientIP=ClientIP
	.s ClientID=$O(^DHCVISClienti(0,"ClientIP",PreClientIP,""))
	e  d
	.s ClientID=$O(^DHCVISClienti(0,"ClientName",WindowDesc,""))
	q:ClientID="" RetTopIP
	s RetTopIP=$P($G(^DHCVISClient(ClientID)),"^",16)
	q RetTopIP
}

ClassMethod DeleteLedInfo(CKScreenStr As %String) As %String
{
	q:CKScreenStr="" 0
	s PrescNo=$P(CKScreenStr,",",4)
	s NowDate=+$H
	&SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	q SQLCODE
}

/// w ##class(web.DHCVISVoiceCall).GetZHInfo()
ClassMethod GetZHInfo() As %String
{
	s RetStr=""
	q RetStr
	s WindowNo=""
	s RowID=""
	s LedColorNo=17
	s ScreenNo=128
	s num=0
	i $G(^DHCVISTemp(+$H,"ZH"))'="" d
	.s WindowNo=$P(^DHCVISTemp(+$H,"ZH"),",",1)
	.s RowID=$P(^DHCVISTemp(+$H,"ZH"),",",2)
	.s LedColorNo=$P(^DHCVISTemp(+$H,"ZH"),",",3)
	.i LedColorNo=51 s LedColorNo=17
	.e  s LedColorNo=LedColorNo+17
	i WindowNo="" d
	.s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo))
	.s RowID=""
	q:WindowNo="" ""
	s WindowDesc="                "
	//q:$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",""))="" ""
	i $O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID))="" d
	.s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo))
	.i WindowNo="" s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo))
	.s WindowDesc=""
	.s RowID=""
	.s ^DHCVISTemp(+$H,"ZH")=WindowNo_","_RowID_","_LedColorNo
	q:WindowNo="" ""
	f  s RowID=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID)) q:((RowID="")||(num>2)||($L(RetStr,"&")>1))  d
	.i RowID=""  d
	..i $L(RetStr,"&")>1 s num=100
	..q:$L(RetStr,"&")>1
	..s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo))
	..i WindowNo="" s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo))
	..q:WindowNo=""
	..s RowID=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID))
	..q:RowID=""
	..i LedColorNo=51 s LedColorNo=17
	..e  s LedColorNo=LedColorNo+17
	..s WindowDesc=$P($G(^DHCVISDurgList(RowID)),"^",6)
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..q:PatName=""
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..s WindowDesc=$P($G(^DHCVISDurgList(RowID)),"^",6)
	..s WindowDesc="请到"_WindowDesc_"取药: "
	..i $L(WindowDesc)>10 s WindowDesc=$E(WindowDesc,1,10)
	..i RetStr="" s RetStr=ScreenNo_","_LedColorNo_","_WindowDesc
	..e  s RetStr=RetStr_"&"_ScreenNo_","_LedColorNo_","_WindowDesc
	..s num=0
	..s RowID=""
	.e  d
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...i FYFlag="1" d
	....s NowDate=+$H
	....&SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..q:FYFlag="1"
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..q:PatName=""
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..i WindowDesc="" d
	...s WindowDesc=$P($G(^DHCVISDurgList(RowID)),"^",6)
	...s WindowDesc="请到"_WindowDesc_"取药: "
	...i $L(WindowDesc)>10 s WindowDesc=$E(WindowDesc,1,10)
	..//i RetStr="" s WindowDesc="                "
	..i RetStr="" s RetStr=ScreenNo_","_LedColorNo_","_WindowDesc_PatName
	..e  s RetStr=RetStr_PatName
	..s num=num+1
	i $O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID))'="" s RowID=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID),-1)
	s ^DHCVISTemp(+$H,"ZH")=WindowNo_","_RowID_","_LedColorNo
	i num=0 s RetStr=""
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetCKInfo()
ClassMethod GetCKInfo() As %String
{
	s RetStr=""
	q RetStr
	s WindowNo=""
	f  s WindowNo=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo)) q:WindowNo=""  d
	.s CKStr=""
	.s num=0
	.s RowID=$P($G(^DHCVISTemp(+$H,"CK",WindowNo)),",",1)
	.s LedColorNo=+$P($G(^DHCVISTemp(+$H,"CK",WindowNo)),",",2)
	.i LedColorNo=51 s LedColorNo=17
	.e  s LedColorNo=LedColorNo+17
	.q:$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",""))=""
	.i $O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID))="" s RowID=""
	.f  s RowID=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID)) q:(RowID="")||(num>1)  d
	..q:+RowID=0
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...i FYFlag="1" d
	....s NowDate=+$H
	....&SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..q:FYFlag="1"
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..i CKStr="" s CKStr=PatName
	..e  d
	...i PatName'=CKStr s CKStr=CKStr_$TR(PatName,"  ")
	..s num=num+1
	.i CKStr'="" d
	..i $L(CKStr)<8 s CKStr=$TR(CKStr," ")
	..i RetStr="" s RetStr=WindowNo_","_LedColorNo_",请"_CKStr_"取药"
	..e  s RetStr=RetStr_"&"_WindowNo_","_LedColorNo_",请"_CKStr_"取药"
	.s RowID=$O(^DHCVISDurgListi(0,"WindowNo",+$H,WindowNo,"Y",RowID),-1)
	.s ^DHCVISTemp(+$H,"CK",WindowNo)=RowID_","_LedColorNo
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetNKInfo()
ClassMethod GetNKInfo() As %String
{
	s RetStr=""
	s QueueDate=+$H
	s BorDr=7
	s Sum=0
	s NextIndex=$O(^DHCVISTemp(+$H,"NK",""))
	i +NextIndex>0 d 
	.s RetStr=^DHCVISTemp(+$H,"NK",NextIndex)
	.k ^DHCVISTemp(+$H,"NK",NextIndex)
	.i RetStr'="" s RetStr="110,17,"_RetStr
	q:RetStr'="" RetStr
	s QueDr=""
	f  s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr)) q:QueDr=""   d
	.s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
	.q:(QueExaBor'=BorDr) 
	.s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
	.q:QueStateDr=""
 	.s MarkDr=$List(^User.DHCQueueD(QueDr),8)
 	.q:MarkDr=""
 	.s MarkName=$p($G(^CTPCP(MarkDr,1)),"^",2)
 	.s MarkName=$E(MarkName,1,6)
 	.s MarkLen=$L(MarkName)
 	.f i=1:1:6-MarkLen d
 	..s MarkName=MarkName_"  "
	.s SeqNo=$List(^User.DHCQueueD(QueDr),10)
	.i $L(SeqNo)=1 s SeqNo=" "_SeqNo
	.s SeqNo=SeqNo_"号"
	.s status=$List(^User.DHCPerStateD(QueStateDr),4)
	.q:(status'="过号")
	.s PatName=$List(^User.DHCQueueD(QueDr),9)
	.s PatName=$$ALPHAUP^SSUTIL4(PatName)
	.s PatName=$E(PatName,1,4)
	.q:PatName=""
	.s Sum=Sum+1
	.i PatName="谢徳明" s PatName="谢德明"
	.i $L(PatName)=2 s PatName=PatName_"    "
	.i $L(PatName)=3 s PatName=PatName_"  "
	.i Sum<2 d
	..i RetStr="" s RetStr=PatName_MarkName_SeqNo
	..e  s RetStr=RetStr_PatName_MarkName_SeqNo
	.e  d
	..s inedx=(Sum-1)\1
	..i $G(^DHCVISTemp(+$H,"NK",inedx))="" s ^DHCVISTemp(+$H,"NK",inedx)=PatName_MarkName_SeqNo
	..e  s ^DHCVISTemp(+$H,"NK",inedx)=^DHCVISTemp(+$H,"NK",inedx)_PatName_MarkName_SeqNo
	///i RetStr'="" s RetStr="110,17,  内科诊区过号病人列表  "_RetStr
	i RetStr'="" s RetStr="110,17,"_RetStr
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetTopPassInfomation("172.16.48.103")
ClassMethod GetTopPassInfomation(serverIP As %String = "") As %String
{
	s RetPassStr=""
	s passStr=""
	s newFlag=0
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetPassStr
	s dataIndex=$P($H,",",2)
	s RetPassStrHead="areaid=partinfo&areatype=queue&dataid="_dataIndex_"&data="
	s BorDr=$P($G(^DHCVISServer(serverId)),"^",7)
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	s serverType=$P($G(^DHCVISServer(serverId)),"^",9)
	//k TempVISPass($h,serverName)
	q:BorDr="" RetPassStr
	i $d(^DHCTempVISPass(+$h,serverName))'=0  s newFlag=0
	e  s newFlag=1
	s QueueDate=+$H
	s QueDr=""
	f  s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr)) q:(QueDr="")||(newFlag=0)   d
	.//q:$d(^DHCTempVISPass(+$h,serverName))
	.s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
	.q:(QueExaBor'=BorDr) 
	.s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
	.q:QueStateDr=""
 	.s MarkDr=$List(^User.DHCQueueD(QueDr),8)
 	.q:MarkDr=""
 	.s MarkName=$p($G(^CTPCP(MarkDr,1)),"^",2)
 	.s MarkName=$E(MarkName,1,6)
 	.s MarkLen=$L(MarkName)
	.s SeqNo=$List(^User.DHCQueueD(QueDr),10)
	.//i $L(SeqNo)=1 s SeqNo=" "_SeqNo
	.s SeqNo=SeqNo_"号"
	.s status=$List(^User.DHCPerStateD(QueStateDr),4)
	.q:(status'="过号")
	.s PatName=$List(^User.DHCQueueD(QueDr),9)
	.s PatName=$$ALPHAUP^SSUTIL4(PatName)
	.s PatName=$E(PatName,1,4)
	.q:PatName=""
	.//i RetStr="" s RetStr=PatName_MarkName_SeqNo
	.//e  s RetStr=RetStr_PatName_MarkName_SeqNo
	.s ^DHCTempVISPass(+$h,serverName,SeqNo)=SeqNo_PatName
	.//i RetPassStr="" s RetPassStr=SeqNo_PatName_" "
	.//e  s RetPassStr=RetPassStr_SeqNo_PatName_" "
	s passNum=0
	s passMax=2
	s SeqNo="" f  s SeqNo=$o(^DHCTempVISPass(+$h,serverName,SeqNo)) q:(SeqNo="")||(passNum>passMax)   d
	.q:'$d(^DHCTempVISPass(+$h,serverName,SeqNo))
	.s passedPat=^DHCTempVISPass(+$h,serverName,SeqNo)
	.q:passedPat=""
	.k ^DHCTempVISPass(+$h,serverName,SeqNo)
	.s passNum=passNum+1
	.i RetPassStr=""  s RetPassStr=passedPat_" "
	.e  s RetPassStr=RetPassStr_passedPat_" "
	i serverName["急诊" d
	.i RetPassStr'="" s RetPassStr="过号:"_RetPassStr_"请直接到诊室就诊!"
	.i RetPassStr="" s RetPassStr="请保持安静,等候医生呼叫,过号患者请直接到诊室就诊!"
	e  d
	.i RetPassStr'="" s RetPassStr="过号:"_RetPassStr_"请到分诊台报到"
	.i RetPassStr="" s RetPassStr="请保持安静,等候医生呼叫,过号患者请到分诊台报到!"
	i serverType="P" s RetPassStr="请保持安静,等候医生呼叫!"
	i ($G(^DHCVISSet("Broad",serverId))'="")  s RetPassStr=$G(^DHCVISSet("Broad",serverId))
	q RetPassStrHead_RetPassStr
}

/// w ##class(web.DHCVISVoiceCall).GetPassInfo("172.16.48.103")
ClassMethod GetPassInfo(serverIP As %String = "") As %String
{
	s RetPassStr=""
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetPassStr
	s BorDr=$P($G(^DHCVISServer(serverId)),"^",7)
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	q:BorDr="" RetPassStr
	s QueueDate=+$H
	s QueDr=""
	f  s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr)) q:QueDr=""   d
	.s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
	.q:(QueExaBor'=BorDr) 
	.s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
	.q:QueStateDr=""
 	.s MarkDr=$List(^User.DHCQueueD(QueDr),8)
 	.q:MarkDr=""
 	.s MarkName=$p($G(^CTPCP(MarkDr,1)),"^",2)
 	.s MarkName=$E(MarkName,1,6)
 	.s MarkLen=$L(MarkName)
	.s SeqNo=$List(^User.DHCQueueD(QueDr),10)
	.//i $L(SeqNo)=1 s SeqNo=" "_SeqNo
	.s SeqNo=SeqNo_"号"
	.s status=$List(^User.DHCPerStateD(QueStateDr),4)
	.q:(status'="过号")
	.s PatName=$List(^User.DHCQueueD(QueDr),9)
	.s PatName=$$ALPHAUP^SSUTIL4(PatName)
	.s PatName=$E(PatName,1,4)
	.q:PatName=""
	.//i RetStr="" s RetStr=PatName_MarkName_SeqNo
	.//e  s RetStr=RetStr_PatName_MarkName_SeqNo
	.i RetPassStr="" s RetPassStr=SeqNo_PatName_" "
	.e  s RetPassStr=RetPassStr_SeqNo_PatName_" "
	i serverName["急诊" d
	.i RetPassStr'="" s RetPassStr="过号病人:"_RetPassStr_"请直接到诊室就诊!  "
	.i RetPassStr="" s RetPassStr="请保持安静,等候医生呼叫,过号病人请直接到诊室就诊!  "
	e  d
	.i RetPassStr'="" s RetPassStr="过号病人:"_RetPassStr_"请到分诊台报到!  "
	.i RetPassStr="" s RetPassStr="请保持安静,等候医生呼叫,过号病人请到分诊台报到!  "
	q RetPassStr
}

/// w ##class(web.DHCVISVoiceCall).GetCKInitParam("172.16.1.25")
ClassMethod GetCKInitParam(serverIP As %String) As %String
{
	s RetStr=""
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" RetStr
	s clientId=""
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	.q:+clientId=0 
	.s comPort=+$P($G(^DHCVISClient(clientId)),"^",4)
	.q:comPort=0
	.s ScreenNo=+$P($G(^DHCVISClient(clientId)),"^",5)
	.q:ScreenNo=0
	.s ColorNo=+$P($G(^DHCVISClient(clientId)),"^",6)
	.i ColorNo=0 s ColorNo=1
	.s ShowMode=+$P($G(^DHCVISClient(clientId)),"^",7)
	.i ShowMode=0 s ShowMode=1
	.s ShowSpeed=+$P($G(^DHCVISClient(clientId)),"^",8)
	.i ShowSpeed=0 s ShowSpeed=1
	.s ShowTime=+$P($G(^DHCVISClient(clientId)),"^",9)
	.i ShowTime=0 s ShowTime=1
	.s TestContent="参数加载成功!"
	.s TestContent=$P($G(^DHCVISClient(clientId)),"^",3)
	.s ScreenParam=comPort_"^"_ScreenNo_"^"_ColorNo_"^"_ShowMode_"^"_ShowSpeed_"^"_ShowTime_"^"_TestContent
	.i RetStr="" s RetStr=ScreenParam
	.e  s RetStr=RetStr_"&"_ScreenParam
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenRo("10.1.30.166")
ClassMethod GetScreenRo(serverIP As %String = "") As %String
{
	//q "科室-诊室!医生!当前就诊!准备就诊^01诊室!杨龙!10号-杨佳!11号-哈哈^科室-诊室!医生!当前就诊!准备就诊^科室-诊室!医生!当前就诊!准备就诊^科室-诊室!医生!当前就诊!准备就诊^科室-诊室!医生!当前就诊!准备就诊"
	s RetWaitTopStr="^!!!^!!!^!!!^!!!^!!!", RetWaitInfo=""
	s maxRow=5
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	//s Time=3600
	i $G(^DHCVISSet("Voice","ShowTime"))'=0 s Time=^DHCVISSet("Voice","ShowTime")
	e  s Time=3600
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	s QueType=$P($G(^DHCVISServer(serverId)),"^",9)
	s clientId=$G(^DHCTempVISL(+$H,serverId))
	s VisType="A"
	s num=0
	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.w "clientId "_clientId,!
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.i $P(zhContent,"*",2)'="" d
	..s queueId=+$P(zhContent,"*")
	..s queueStr=$G(^DHCVISQueue(queueId))
	..q:queueStr=""
	..s VisType=$P(queueStr,"^",5)
	..s creatTime=$P(queueStr,"^",13)
	..i ($P($H,",",2)-creatTime)>Time s zhContent=""
	..q:zhContent=""                                                                                                                  
	..s zhContent=$P(queueStr,"^",17)
	..s CKScreenStr=$P(queueStr,"^",18)
	..q:CKScreenStr=""  
	..s DocInfoStr=$P(queueStr,"^",22)
	..s patTip=$P(queueStr,"^",24)                                                                                                           
	..s waitList=$P(queueStr,"^",19)                                                                                                                    
	..s QueRowId=+zhContent                                                                                                                            
	..s Status=..GetAdmStatus(QueRowId)                                                                                                               
	..//i (Status="过号")!(Status="退号") s zhContent=""                                                                                               
	..s zhContent=$P(zhContent,"*",2)                                                                                                              
	..q:zhContent=""                                                                                                                                    
	..s docUserId=$p(DocInfoStr,"!",3)   
	..s docLocId=$p(DocInfoStr,"!",4)      
	..s waitList=..GetCurrentWaiter(docLocId,docUserId)                                                                                      
	..s QueueRoomName=$P(CKScreenStr,"!",2)     //诊室名字
	..s QueueRegDocDesc=$P(CKScreenStr,"!",3)     //号别
	..s CurPatNo=$P(CKScreenStr,"!",5)
	..s CurPatName=$P(CKScreenStr,"!",6)
	..i (CurPatName'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s CurPatName=..PrivateName(CurPatName)
	..i +CurPatNo=0 s CurPat=CurPatName
	..e  s CurPat=CurPatNo_CurPatName    //当前就诊
	..s $P(RetWaitInfo,"!",1)=QueueRoomName
	..s $P(RetWaitInfo,"!",2)=QueueRegDocDesc
	..s $P(RetWaitInfo,"!",3)=CurPat
	..s $P(RetWaitInfo,"!",4)=waitList
	..s $P(RetWaitTopStr,"^",i+1)=RetWaitInfo
	.q:zhContent=""                                                                                                                                      
	.s i=i+1                                                                                                                                             
	.s ^DHCTempVISL(+$H,serverId)=clientId                                                                                                                  
	.s num=num+1                                                                                                                                         
	i num'=0 s RetWaitTopStr="科室-诊室!医生!当前就诊!准备就诊"_RetWaitTopStr
	e  s ^DHCTempVISL(+$H,serverId)="",RetWaitTopStr="!!!^!!!^!!!^!!!^!!!^!!!"                                                                                                                                         
	s clientId=^DHCTempVISL(+$H,serverId)
	s Flag=..ScreenWaitInfoFlag(serverIP,Time)
	i Flag="N" s ^DHCTempVISL(+$H,serverId)=""
	i num<maxRow s ^DHCTempVISL(+$H,serverId)=""
	q RetWaitTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenRoBAK("192.168.33.74","06诊室")
ClassMethod GetScreenRoBAK(serverIP As %String = "", room As %String = "", screenNo As %String = "0") As %String
{
	s RetStr=""
	s screenNo=+screenNo
	i room'="" s clientId=""
	i +room<6 s clientId=""
	i (+room>5)&&(+room<11) d
	.s roomDesc="05诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	i (+room>10)&&(+room<16) d
	.s roomDesc="10诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	i +room>16 d
	.s roomDesc="15诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	s VisType="A"
	s maxRow=5
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr
	s TopIPStr=$P($G(^DHCVISServer(serverId)),"^",13)  ///北京中医院有此bug,注意更新
	q:TopIPStr'="" RetStr
	i room="" s clientId=$G(^DHCTempVISL(+$H,serverId,screenNo))
	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.s clientScreenNo=$P($G(^DHCVISClient(clientId)),"^",5)
	.q:(screenNo>0)&&(clientScreenNo'[screenNo)
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.i zhContent="" d
	..s zhContent=+$P($G(^DHCVISClient(clientId)),"^",3)
	..i +zhContent<10 s zhContent="0"_zhContent
	..s zhContent=" "_zhContent
	.e  d
	..i $P(zhContent,"*",2)'="" d
	...s queueId=+$P(zhContent,"*")
	...s queueStr=$G(^DHCVISQueue(queueId))
	...q:queueStr=""
	...s VisType=$P(queueStr,"^",5)
	...s creatTime=$P(queueStr,"^",13)
	...i ($P($H,",",2)-creatTime)>1500 s zhContent=""
	...q:($P($H,",",2)-creatTime)>1500
	...s zhContent=$P(queueStr,"^",17)
	...s waitList=$P(queueStr,"^",19)
	...i $P(zhContent,"*",2)'="" d
	....s QueRowId=+zhContent
	....s Status=..GetAdmStatus(QueRowId)
	....//i (Status="过号")!(Status="退号") s zhContent=""
	....i (Status="退号") s zhContent=""
	....e  s zhContent=$P(zhContent,"*",2)
	...q:zhContent=""
	...i $P(waitList,"*",2)'="" d
	....s waitList=..GetWaitList(waitList)
	....i waitList'="" s zhContent=zhContent_waitList
	.q:zhContent=""
	.s i=i+1
	.i RetStr="" s RetStr=zhContent
	.e  s RetStr=RetStr_"^"_zhContent
	.s ^DHCTempVISL(+$H,serverId,screenNo)=clientId
	/*f  s clientId=$O(^DHCTempVIS(+$H,serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.s ckContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:ckContent=""
	.s i=i+1
	.i RetStr="" s RetStr=ckContent
	.e  s RetStr=RetStr_"^"_ckContent
	.s ^DHCTempVISL(+$H,serverId)=clientId*/
	i RetStr="" s ^DHCTempVISL(+$H,serverId,screenNo)=""
	q:RetStr="" RetStr
	//s RetStr="呼吸内科专家诊室张力帆 10号 丁学好  呼吸内科专家诊室张力帆 10号 丁学好"
	s RLen=$L(RetStr,"^")
	f i=1:1:(maxRow-RLen) d
	.s RetStr=RetStr_"^"
	.s ^DHCTempVISL(+$H,serverId,screenNo)=""
	s passStr=..GetPassInfo(serverIP)
	s RetStr=RetStr_"^"_passStr
	i VisType="A" d
	.s RetStr=RetStr_"^"_"  科室-诊室          医生      类别 序号    就诊者      等候号"
	i (VisType="R")||(VisType="P") d
	.s RetStr=RetStr_"^"_"    当前诊室         序号    就诊者      等候号"
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenRoNFYY("ADMIN-27838F23A")
ClassMethod GetScreenRoNFYY(serverIP As %String = "") As %String
{
	s RetStr1="^^^^^^&^^^^^^^^^^"
	s RetStr=""
	s Time=$g(^DHCVISSet("Voice","ShowTime"))
	i Time="" s Time=3600
	s VisType="A"
	s maxRow=8
	s Index=$I(^DHCVISRisTest(+$H,"GetScreenRoNFYY"))
	s ^DHCVISRisTest(+$H,"GetScreenRoNFYY",Index)=serverIP_"^"_$H
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverIP=$$upper^SSUTIL4(serverIP)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr1
	s TopIPStr=$P($G(^DHCVISServer(serverId)),"^",13)  ///北京中医院有此bug,注意更新
	q:TopIPStr'="" RetStr1
	s clientId=$G(^DHCTempVISL(+$H,serverId))

	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.s outTimeFlag="0"
	.i zhContent="" d
	..s zhContent=+$P($G(^DHCVISClient(clientId)),"^",3)
	..i +zhContent<10 s zhContent="0"_zhContent
	..s zhContent=" "_zhContent
	.e  d
	..i $P(zhContent,"*",2)'="" d
	...s queueId=+$P(zhContent,"*")
	...s queueStr=$G(^DHCVISQueue(queueId))
	...q:queueStr=""
	...s creatTime=$P(queueStr,"^",13)
	...i ($P($H,",",2)-creatTime)>Time s outTimeFlag="1"
	...s CKScreenStr=$p(queueStr,"^",18)
	...s LocDesc=$p(CKScreenStr,"!",1)
	...s RoomDesc=+$p(CKScreenStr,"!",2)
	...i ((RoomDesc=0)&&($p(CKScreenStr,"!",2)'=""))  s RoomDesc=$p(CKScreenStr,"!",2)
	...//s DocDesc=$p($p($p(CKScreenStr,"!",3),"(",2),")",1)
	...s DocDesc=$p(CKScreenStr,"!",3)
	...s CurrentPatNoDesc="",NextPatNoDesc=""
	...s CurrentPatNo=$p(CKScreenStr,"!",5)
	...i CurrentPatNo'="" s CurrentPatNoDesc="("_CurrentPatNo_")"
	...s CurrentPatName=$p(CKScreenStr,"!",6)
	...s NextPatNo=$p(CKScreenStr,"!",7)
	...i NextPatNo'=""  s NextPatNoDesc="("_NextPatNo_")"
	...s NextPatName=$p(CKScreenStr,"!",8)
	...i CurrentPatName'="" s CurrentPatName=..EncryptName(CurrentPatName)  //ding 1230
	...i NextPatName'="" d
	....s NextPatName=..EncryptName(NextPatName)  //ding 1230
	....s RetContent=RoomDesc_"^"_LocDesc_"^"_DocDesc_"^"_CurrentPatNoDesc_CurrentPatName_"^"_NextPatNoDesc_NextPatName
	...e  s RetContent=RoomDesc_"^"_LocDesc_"^"_DocDesc_"^"_CurrentPatNoDesc_CurrentPatName_"^"_NextPatNoDesc_NextPatName
	.q:(outTimeFlag="1")
	.s i=i+1
	.i RetStr="" s RetStr=RetContent
	.e  s RetStr=RetStr_"%"_RetContent
	.s ^DHCTempVISL(+$H,serverId)=clientId
	i RetStr="" s ^DHCTempVISL(+$H,serverId)=""
	i (i<maxRow) s ^DHCTempVISL(+$H,serverId)=""
	s clientId=$G(^DHCTempVISL(+$H,serverId))
	s DateFlag="N"
	i clientId'="" d
	.f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:(clientId="")||(DateFlag="Y")  d
	..s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	..q:zhContent=""
	..s DateFlag="Y"
	i DateFlag="N" s ^DHCTempVISL(+$H,serverId)=""
	s ZHInstruction=""
	s ZHInstruction=$P($G(^DHCVISServer(serverId)),"^",9)
    i $tr($g(^DHCVISSet("Broad",serverId))," ","")'="" s ZHInstruction=^DHCVISSet("Broad",serverId)
	s RLen=$L(RetStr,"%")
	i (RetStr'="") s RLen=RLen+1
	f i=RLen:1:8 d
	.s $p(RetStr,"%",i)="^^^^"
	s $p(RetStr,"%",9)="诊室^科室^医生^正在就诊^门口等候"
	i VisType="A" d
	.s $p(RetStr,"%",9)="诊室^科室^医生^正在就诊^门口等候"
	i (VisType="R")||(VisType="P") d
	.s RetStr=RetStr_"^"_"    当前诊室         序号    就诊者      等候号"
	s RightDesc=""
	i $G(^DHCVISSet("WaitPaitList"))'=0 s RightDesc=..GetBordMarksyn(serverIP)
	s RetStr=RetStr_"&"_RightDesc_"&"_ZHInstruction
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetBordMarksyn("LZX-PC")
ClassMethod GetBordMarksyn(serverIP As %String = "") As %String
{
	s docStr=""
	s nowDate=+$h,nowTime=$p($h,",",2)
	q:serverIP="" ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" ""
	s BorId=$P($G(^DHCVISServer(serverId)),"^",7)
	q:BorId="" "&^^^^^^^^^&^^^^^^^^^&"
	S RetStr="",m=1,markDesc=""
	
	k ^DHCVISBorTemp(+$h,serverIP)
	s BorMarkId=""  //诊区号别
	f  s BorMarkId=$o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))  q:(BorMarkId="")  d	
    .s si=$List(^User.DHCDepMarkD(BorMarkId),5)
    .s depStat=$List(^User.DHCDepMarkD(BorMarkId),6)
    .q:((si="N")||(depStat'=1))  ;非当前、可用的不统计
    .s depDr=$List(^User.DHCDepMarkD(BorMarkId),8)  ;科室
	.s markDr=$List(^User.DHCDepMarkD(BorMarkId),3)  ;号别
	.q:(markDr="")||(depDr="")
	.s:markDr'="" markDesc=$P($G(^CTPCP(markDr,1)),"^",2)
    .s depSub =""_depDr
	.s patInfo=""
    .s QueRowId=0
	.f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,depSub,QueRowId))  q:QueRowId=""  d
    ..q:$ListLength(^User.DHCQueueD(QueRowId))<1
    ..s markId=$List(^User.DHCQueueD(QueRowId),8)  
    ..s docDr=$List(^User.DHCQueueD(QueRowId),5) 
    ..s patStateDr=$List(^User.DHCQueueD(QueRowId),14)
    ..s patNumber=$List(^User.DHCQueueD(QueRowId),10) 
    ..q:patNumber=""
    ..q:(patStateDr'=1)&&(patStateDr'=2)&&(patStateDr'=3)&&(patStateDr'=7) // 1回诊 2等候 3过号 7未报到
    ..q:markDr'=markId
    ..//w "markDr:",markDr,!
    ..q:($o(^SSU("SSUSR",0,"CTPCP",markId,""))="")&&(docDr="") // 专科号未指定医生
    ..i $o(^SSU("SSUSR",0,"CTPCP",markId,""))=""  s markId=docDr
    ..i (docDr'="")&&(docDr'=markId) s markId=docDr  //专家号 指定医生
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",markId,""))
	..s ^DHCVISBorTemp(+$h,serverIP,UserID)=depDr_"!"_UserID //_"!"_markId

	s AllPatient="",PatientNo="",SurName="",ArrivedQue=""
	s markNum=1
	i $d(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP))=0{
	s UserID=$g(^DHCVISBorTempIndex(+$h,serverIP))
	i $O(^DHCVISBorTemp(+$h,serverIP,UserID))="" s UserID=""
	f  s UserID=$O(^DHCVISBorTemp(+$h,serverIP,UserID)) q:(UserID="")||(markNum>1)  d
	.s LocID=$p(^DHCVISBorTemp(+$h,serverIP,UserID),"!")
	.s ^DHCVISBorTempPage(+$h,serverIP)=0
	.d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","FindLocDocCurrentAdm",LocID,UserID,serverIP,AllPatient,PatientNo,SurName,nowDate,nowDate,ArrivedQue,"on")
	.s markNum=markNum+1
	}
	s maxShow=9,T=0
	s User="",patFirStr="",patStr="",typeFlag=0,pageNum=0
	f  s User=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User)) q:User=""  d
	.s Callindexnow=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,""))
	.s LocDr=$p(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,Callindexnow),"^",8)
	.s docDr=##Class(web.SSUser).GetDefaultCareProvider(User)
	.i docDr'="" s docDesc=$P($G(^CTPCP(docDr,1)),"^",2)
	.s DocTypeDesc=##class(web.DHCAlloc).GetOneDocTypeSession(LocDr,docDr)
	.s patIndex="",I=1
	.f  s patIndex=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)) q:(patIndex="")||(I>maxShow)  d
	..s ReStr=^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	..s patName=$p(ReStr,"^",4)
	..s patNum=$p(ReStr,"^",3)
	..s patState=$p(ReStr,"^",2)
	..i patState="未报到" s patState="未报"
	..//i patState="优先" s patState="等候"
	..s patInfo=patNum_" "_patName_"("_patState_")"
	..s I=I+1
	..i patStr="" s patStr=patInfo
	..e  s patStr=patStr_"^"_patInfo
	..k ^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	.s docStr=docDesc_"  "_DocTypeDesc
	.i $o(^DHCVISBorTemp(+$h,serverIP,User))="" s ^DHCVISBorTempIndex(+$h,serverIP)="",^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	.e  s ^DHCVISBorTempIndex(+$h,serverIP)=User,^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	s patStrlen=$l(patStr,"^")
	i patStrlen<maxShow s $p(patStrlen,"^",maxShow)=""
	
	i ($d(^DHCVISBorTempPage(+$h,serverIP))=0) s ^DHCVISBorTempPage(+$h,serverIP)=""
	s patStr=docStr_"&"_patStr_"&"_^DHCVISBorTempPage(+$h,serverIP)
	q patStr
}

ClassMethod EncryptName(name As %String) As %String
{
	q:name=""
	s name=$tr(name," ")
	i $l(name)=2 s name=$e(name,1)_"＊"_$e(name,2)
	i $l(name)=3 s name=$e(name,1)_"＊"_$e(name,3,8)
	i $l(name)>3 s name=$e(name,1,2)_"＊"_$e(name,4,8)
	q name
}

/// w ##class(web.DHCVISVoiceCall).GetSynScreen("192.168.253.174","06诊室")
ClassMethod GetSynScreen(serverIP As %String = "", room As %String = "") As %String
{
	s RetStr=""
	s maxRow=5
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr
	i room'="" d
	.s clientId=..GetClientByName(serverIP,room)
	s TopIPStr=$P($G(^DHCVISServer(serverId)),"^",13)
	q:TopIPStr'="" RetStr
	i room="" s clientId=$G(^DHCTempVISL(+$H,"Syn",serverId))
	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.s queueId=+$P(zhContent,"*")
	.s Status=..GetAdmStatus(queueId)
	.q:(Status="退号")
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s creatTime=$P(queueStr,"^",13)
	.q:($P($H,",",2)-creatTime)>1500
	.s SynContent=$P(queueStr,"^",20)
	.q:SynContent=""
	.s i=i+1
	.i RetStr="" s RetStr=SynContent
	.e  s RetStr=RetStr_"^"_SynContent
	.s ^DHCTempVISL(+$H,"Syn",serverId)=clientId
	i RetStr="" s ^DHCTempVISL(+$H,"Syn",serverId)=""
	//q:RetStr="" RetStr
	i RetStr="" s RetStr="    "
	s RLen=$L(RetStr,"^")
	f i=1:1:(maxRow-RLen) d
	.s RetStr=RetStr_"^    "
	.s ^DHCTempVISL(+$H,"Syn",serverId)=""
	//s RetStr=RetStr_"^"_" 科室-诊室      医生    类别 序号 就诊者  准备就诊患者"
	s RetStr="序号 患者 诊室 医生^"_RetStr
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetClientByName("10.10.1.159","01诊室")
ClassMethod GetClientByName(serverIP As %String = "", roomDesc As %String = "") As %String
{
	s retClientId=""
	q:(serverIP="")!(roomDesc="") ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" ""
	s clientId=""
	f  s clientId=$O(^DHCVISClienti(0,"ClientName",roomDesc,clientId)) q:clientId=""  d
	.q:($P($G(^DHCVISClient(clientId)),"^",1)'=serverId)
	.s retClientId=clientId
	q retClientId
}

ClassMethod GetZHLedScreen(serverIP As %String = "") As %String
{
	s RetStr=""
	s Simulated=""
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
    q:serverId="" 
    s time=0
	f time=25200:1:66600  d   //07:00 till 18:30
	.s clientId=""
	.f  s clientId=$O(^DHCTempDHCVIS(+$H,time,serverId,clientId)) q:clientId=""  d
	..q:$G(^DHCTempDHCVIS(+$H,time,serverId,clientId))=""
	..s oldTime=$P(^DHCTempDHCVIS(+$H,time,serverId,clientId),"*")
	..s ^DHCTempVISClear(serverId,oldTime)=$P(^DHCTempDHCVIS(+$H,time,serverId,clientId),"*",2)
	s index=0
	s oldTime=""
	f  s oldTime=$O(^DHCTempVISClear(serverId,oldTime),-1) q:oldTime=""  d
	.q:$G(^DHCTempVISClear(serverId,oldTime))=""
	.s index=index+1
	.i index=1 s pos="`2000000112"
	.i index=2 s pos="`2000000096"
	.i index=3 s pos="`2000000080"
	.i index=4 s pos="`2000000064"
	.i index=5 s pos="`2000000048"
	.i index=6 s pos="`2000000032"
	.i index=7 s pos="`2000000016"
	.i RetStr="" s RetStr=pos_^DHCTempVISClear(serverId,oldTime)
	.e  i index<8 s RetStr=RetStr_pos_^DHCTempVISClear(serverId,oldTime)
	.i index=1 s Simulated=^DHCTempVISClear(serverId,oldTime)
	.//e  i index<8 s Simulated=Simulated_^DHCTempVISClear(serverId,oldTime)
	s RetStr=RetStr_"#"_Simulated
	s Info="`2000000000诊室     科室-医生    序号  候诊者"
	s RetStr=Info_RetStr
	k ^DHCTempVISClear(serverId)
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetDurgTopInfo("172.16.20.42")
ClassMethod GetDurgTopInfo(serverIP As %String = "") As %String
{
	s RetStr=""
	s dataIndex=+$P($H,",",2)
	//s RetStr="172.18.6.42*msg=dataupdate&areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data=6叫号队列测试<br/>5叫号队列测试<br/>4叫号队列测试<br/>3叫号队列测试<br/>2叫号队列测试<br/>1叫号队列测试"
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	s TopIP=""
	f  s TopIP=$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP)) q:TopIP=""  d
	.s CKStr=""
	.s WindowStr=..GetWindowInfo(serverIP,TopIP)
	.s WaitStr=..GetDurgWaitInfo(TopIP)
	.s SkipStr=..GetDurgSkipInfo(TopIP)
	.q:(WaitStr="")&&(SkipStr="")
	.i RetStr="" s RetStr=TopIP_"*msg=dataupdate&"_WaitStr_"&"_SkipStr_"&"_WindowStr
	.e  s RetStr=RetStr_"#"_TopIP_"*msg=dataupdate&"_WaitStr_"&"_SkipStr_"&"_WindowStr
	q RetStr
}

ClassMethod GetWindowInfo(ServerIP As %String = "", TopIP As %String = "") As %String
{
	s dataIndex=$P($H,",",2)
	s RetWindowStr="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="
	q:TopIP="" RetWindowStr_" "
	s serverId=$O(^DHCVISServeri(0,"ServerIP",ServerIP,""))
	q:serverId="" RetWindowStr_" "
	s ClientId=$O(^DHCVISClienti(0,"ServerTop",serverId,TopIP,""))
	s TopDesc=$P($G(^DHCVISClient(ClientId)),"^",17)
	q:TopDesc="" RetWindowStr_" "
	q RetWindowStr_TopDesc
}

ClassMethod GetDurgWaitInfo(TopIP As %String = "") As %String
{
	s dataIndex=$P($H,",",2)
	s RetStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetWaitStr="<br/><br/><br/><br/>"
	q:TopIP="" RetStr1_RetWaitStr
	s num=0
	s RowID=$P($G(^DHCVISTemp(+$H,"TopW",TopIP)),",",1)
	q:$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"W",""))="" ""
	i $O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"W",RowID))="" s RowID=""
	f  s RowID=$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"W",RowID)) q:(RowID="")||(num>4)  d
	.q:+RowID=0
	.s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	.q:PrescNo=""
	.s FYFlag=""
	.s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	.i PhdRow'="" d
	..s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	..i FYFlag="1" d
	...s NowDate=+$H
	...s UpdateFlag=..UpdatePrescState(PrescNo,"D")
	.q:FYFlag="1"
	.s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	.i $L(PatName)=2 s PatName=PatName_"  "
	.s WindowDesc=$P($G(^DHCVISDurgList(RowID)),"^",6)
	.s num=num+1
	.s $P(RetWaitStr,"<br/>",6-num)=PatName_" "_WindowDesc_"等候"
	s RowID=$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"W",RowID),-1)
	s ^DHCVISTemp(+$H,"TopW",TopIP)=RowID
	s RetStr1=RetStr1_RetWaitStr
	q RetStr1
}

/// w ##class(web.DHCVISVoiceCall).GetDurgSkipInfo("172.16.20.42")
ClassMethod GetDurgSkipInfo(TopIP As %String = "") As %String
{
	s dataIndex=$P($H,",",2)
	s RetString="areaid=skipinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetSkipStr="<br/><br/><br/><br/>"
	q:TopIP="" RetString_RetSkipStr
	s num=0
	s RowID=$P($G(^DHCVISTemp(+$H,"TopS",TopIP)),",",1)
	q:$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"S",""))="" ""
	i $O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"S",RowID))="" s RowID=""
	f  s RowID=$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"S",RowID)) q:(RowID="")||(num>4)  d
	.q:+RowID=0
	.s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	.q:PrescNo=""
	.s FYFlag=""
	.s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	.i PhdRow'="" d
	..s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	..i FYFlag="1" d
	...s NowDate=+$H
	...s UpdateFlag=..UpdatePrescState(PrescNo,"D")
	.q:FYFlag="1"
	.s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	.s WindowDesc=$P($G(^DHCVISDurgList(RowID)),"^",6)
	.s WindowDesc=$TR(WindowDesc,"窗口")
	.s num=num+1
	.s $P(RetSkipStr,"<br/>",6-num)=PatName_WindowDesc
	s RowID=$O(^DHCVISDurgListi(0,"TopIP",+$H,TopIP,"S",RowID),-1)
	s ^DHCVISTemp(+$H,"TopS",TopIP)=RowID
	s RetString=RetString_RetSkipStr
	q RetString
}

/// w ##class(web.DHCVISVoiceCall).GetScreenFlag("192.168.33.74")
ClassMethod GetScreenFlag(serverIP As %String = "") As %String
{
	s RetScreenFlag=0
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" 0
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" 0
	s ComPortNo=+$P($G(^DHCVISServer(serverId)),"^",4)
	s ScreenNo=$P($G(^DHCVISServer(serverId)),"^",5)
	s RetScreenFlag=+ScreenNo
	i (ComPortNo=0)&&(ScreenNo=1) s RetScreenFlag=1
	i (ComPortNo=0)&&(ScreenNo=2) s RetScreenFlag=2
	i (ComPortNo=0)&&(ScreenNo<20) s RetScreenFlag=ScreenNo
	s RetScreenFlag=+RetScreenFlag
	s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)   ///VIS_ServerTopIP
	i ServerTopIP'="" s RetScreenFlag=100   ///通过UDP通讯
	i (ComPortNo=0)&&(ScreenNo=88) s RetScreenFlag=88
	q RetScreenFlag
}

/// 药房窗口显示内容
/// w ##class(web.DHCVISVoiceCall).GetDurgCKTopStr("192.168.33.74","请生活到02窗口取药")
ClassMethod GetDurgCKTopStr(HostIP As %String = "", ContentStr As %String = "") As %String
{
	s RetTopStr=""
	q:(HostIP="")!(ContentStr="") RetTopStr
	s dataIndex=+$P($H,",",2)
	//s ContentStr=$TR(ContentStr,"请")
	s RetTopStr=HostIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStr
	s NoticePop=$G(^DHCVISSet("NoticePop"))
	i NoticePop="1" s RetTopStr=RetTopStr_"&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_ContentStr_"""</script></areadata>"
	q RetTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetWindowTopStr("172.26.10.199","请 王涛 到 1号发药窗口 取药")
ClassMethod GetWindowTopStr(HostIP As %String = "", ContentStr As %String = "", docInfo As %String = "") As %String
{
	
	s RetTopStr="",docCode=""
	//q:(HostIP="")!(ContentStr="") RetTopStr
	q:(HostIP="") RetTopStr
	s dataIndex=+$P($H,",",2)
	//隐私信息
	i (ContentStr'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) d
	.s $p(ContentStr," ",3)=..PrivateName($p(ContentStr," ",3))
	s PatInfo=$P(ContentStr," ",2)_" "_$P(ContentStr," ",3)
	s ContentStr=$P(ContentStr,PatInfo,1)_PatInfo_$P(ContentStr,PatInfo,2)
	s ContentStr=$TR(ContentStr," ")
	//s ContentStr=$TR(ContentStr,"请")
	//s RetTopStr=HostIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStr
	s RetTopStr="*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&action=addnew&data="_ContentStr
	i docInfo'="" s docCode=$p($g(docInfo),"!",2)
	s Docpicture=docCode_".jpg"
	s NoticePop=$G(^DHCVISSet("NoticePop"))
	k ^DHCVISTemp(+$h,"GetWindowTopStr")
	s ^DHCVISTemp(+$h,"GetWindowTopStr")=$p($h,",",2)
	i NoticePop="1" s RetTopStr=RetTopStr_"&areaid=l&areatype=lua&dataid="_dataIndex_"&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_ContentStr_""";PatInfo="""_PatInfo_""";Docpicture="""_Docpicture_""";</script></areadata>"
	s ClientId=$O(^DHCVISClienti(0,"ClientTopIP",HostIP,""))
	q:ClientId="" HostIP_RetTopStr
	s WindowDesc=$P($G(^DHCVISClient(ClientId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i WindowDesc'="" s RetTopStr=RetTopStr_"&"_WindowDesc
	//多诊室共用一个屏显示最后每个诊室的呼叫信息
	//s CKShowInfo=..GetCKShowInfo(HostIP)
	s CKShowInfo=..GetOneDocRoomInfo(HostIP)
	i CKShowInfo'="" s RetTopStr=RetTopStr_"&"_CKShowInfo
	f index=1:1:$L(HostIP,",") d
	.i $G(RetStr)="" s RetStr=$P(HostIP,",",index)_RetTopStr
	.e  s RetStr=RetStr_"#"_$P(HostIP,",",index)_RetTopStr
	q $G(RetStr)
}

/// w ##class(web.DHCVISVoiceCall).GetCKShowInfo("172.16.23.211")
ClassMethod GetCKShowInfo(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s ShowMax=5
	s RetShowInfo="<br/><br/><br/><br/><br/>"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	q:ServerRowId=0 ""
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:((ClientRowId="")||(ShowIndex>(ShowMax-1)))  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s ckContent=$P(QueueStr,"^",18)
	.s creatTime=$P(QueueStr,"^",13)
	.s waitList= $P(QueueStr,"^",19)
	.i ($P($H,",",2)-creatTime)>1500 s ckContent=""
	.q:ckContent=""
	.s curRoom=$tr($p($g(ckContent),"!",2),"诊室","")
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curSeqNo=$p($g(ckContent),"!",6)
	.s curLocDesc=$p($g(ckContent),"!",1)
	.s patientName=$p($g(ckContent),"!",5)
	.i $l(curDocDesc)>4 s curDocDesc=$E(curDocDesc,1,4)
	.//i $l(curDocDesc)=3 s curDocDesc=curDocDesc_" "
	.//i $l(curDocDesc)=2 s curDocDesc=curDocDesc_"   "
	.s curInfo=curLocDesc_curDocDesc
	.i $l(curInfo)>7 s curInfo=$E(curDocDesc,1,7)
	.i $l(curInfo)=7 s curInfo=curInfo_" "
	.i $l(curInfo)=6 s curInfo=curInfo_"   "
	.i $l(curInfo)=5 s curInfo=curInfo_"     "
	.i $l(curInfo)=4 s curInfo=curInfo_"       "
	.s curSeqNo=+curSeqNo
	.//i $l(curSeqNo)>3 s curSeqNo=$E(curSeqNo,1,4)
	.//i $l(curSeqNo)=3 s curSeqNo=curSeqNo  
	.//i $l(curSeqNo)=2 s curSeqNo=" "_curSeqNo
	.i curSeqNo<10 s curSeqNo=" "_curSeqNo_"号 "
	.i (curSeqNo>9)&&(curSeqNo<100) s curSeqNo=curSeqNo_"号 "
	.i $l(patientName)>3 s patientName=$E(patientName,1,4)
	.i $l(patientName)=3 s patientName=patientName_" "
	.i $l(patientName)=2 s patientName=patientName_"   "
	.s ClientShowInfo=curRoom_" "_curInfo_curSeqNo_patientName
	.i $P(waitList,"*",2)'="" d
	..s waitList=..GetWaitList(waitList)
	..i waitList'="" s ClientShowInfo=ClientShowInfo_waitList
	.//s ClientShowInfo=$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:ClientShowInfo=""
	.s $P(RetShowInfo,"<br/>",ShowMax-ShowIndex)=ClientShowInfo //$P(ClientShowInfo,"*",2)
	.s ShowIndex=ShowIndex+1
	s $P(RetShowInfo,"<br/>",6)="诊室科室(医生)     序号 就诊者 等候号"
	s ^DHCTempVISL(+$H,ClientTopIP)=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId),-1)
	i ShowIndex=0 s ^DHCTempVISL(+$H,ClientTopIP)=""
	//q:ShowIndex=0 ""
	s ClientRowId=^DHCTempVISL(+$H,ClientTopIP)
	i $O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId))="" s ^DHCTempVISL(+$H,ClientTopIP)=""
	s RetShowInfo=ShowInfoHead_RetShowInfo
	
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	i ShowIndex=0 s RetShowInfo=RetShowInfo_notifydata
	q RetShowInfo
}

/// w ##class(web.DHCVISVoiceCall).GetOneDocRoomInfo("10.1.41.101")
ClassMethod GetOneDocRoomInfo(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo="<br/><br/><br/><br/><br/>"
	s VisType="A"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	s WindowName=$P(ClientStr,"^",3)
	q:ServerRowId=0 ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	s ClientRetStr=""
	s nowTime=$p($h,",",2)
	s Broadcast=0
	i $G(^DHCVISSet("Broadcast")) d
	.s Broadcast="1"
	.s IntervalTime=$G(^DHCVISSet("Voice","BroadcastTime"))*60
	e  d
	.s Broadcast="0"
	.s IntervalTime=600
	q:((Broadcast="1")&&((nowTime#IntervalTime)<10)&&(dataIndex'=^DHCVISTemp(+$h,"GetWindowTopStr"))) "&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data=<areadata areaid='l'areatype='lua'><script language='lua'>Broadcastpicture="_"""Broadcast.jpg"""_";</script></areadata>"

	//用于采血数据显示，以&号分割不同的窗口，窗口号为WindowNo，数据存在data中，采一等候二
	i QueType="B" d
	.s (firstPat,secondPat,thirdPat)=""
	.s WindowNow="采血"
	.s WindosWait="等候"
	.s ClientRowId=""
	.f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	..s (firstPat,secondPat,thirdPat)=""
	..s ClientStr=$G(^DHCVISClient(ClientRowId))
	..s WindowNo=$P(ClientStr,"^",5)
	..s ShowInfoHead="areaid=window"_WindowNo_"&areatype=queue&dataid="_dataIndex_"&data="
	..s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	..i QueueId>0 d
	...s QueueStr=$G(^DHCVISQueue(QueueId))
	...q:QueueStr=""
	...s ckContent=$P(QueueStr,"^",18)
	...s creatTime=$P(QueueStr,"^",13)
	...q:($P($H,",",2)-creatTime)>1500
	...s firstPat=$P(ckContent,";",1)
	...s waitList=$P(ckContent,";",2)
	...s secondPat=$P(waitList,",",1)
	...s thirdPat=$P(waitList,",",2)
	..s $P(RetShowInfo,"<br/>",1)=$p(thirdPat,"*",2)
	..s $P(RetShowInfo,"<br/>",2)=$p(secondPat,"*",2)
	..s $P(RetShowInfo,"<br/>",3)=WindosWait
	..s $P(RetShowInfo,"<br/>",4)=$p(firstPat,"*",2)
	..s $P(RetShowInfo,"<br/>",5)=WindowNow
	..i ClientRetStr="" s ClientRetStr=ShowInfoHead_RetShowInfo
	..e  s ClientRetStr=ClientRetStr_"&"_ShowInfoHead_RetShowInfo
	q:((QueType="B")&&(ClientRetStr'="")) ClientRetStr
	
	//用于药房显示
	i QueType="D" d
	.s ClientRetStr=##Class(web.DHCVISRelation).GetDurgWindowInfoByClient(ClientRowId,ServerRowId)
	q:((QueType="D")) ClientRetStr
	
	//用于收费处显示
	i QueType="C" d
	.s ClientRetStr=##Class(web.DHCVISRelation).GetRegInfoByClient(ClientRowId)
	q:((QueType="C")) ClientRetStr
	
	s docCode=" "
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s ckContent=$P(QueueStr,"^",18)
	.s creatTime=$P(QueueStr,"^",13)
	.s docInfoStr=$P(QueueStr,"^",22)
	.i ($P($H,",",2)-creatTime)>15000 d
	..s ckContent=""
	.q:ckContent=""
	.//VisType用于区分不同的叫号类型，R/U/P
	.s VisType=$P(QueueStr,"^",5)
	
	.i (VisType="R")||(VisType="U") d
	..s (firstPat,secondPat,thirdPat,fourthPat,fifthPat)=""
	..s firstPat=$P(ckContent,";",1)
	..i firstPat="" s RetShowInfo="" q
	..s waitList=$P(QueueStr,"^",19)
	..s secondPat=$P(waitList,",",1)
	..s thirdPat=$P(waitList,",",2)
	..s $P(RetShowInfo,"<br/>",1)=$P(thirdPat,"*",2)
	..s $P(RetShowInfo,"<br/>",2)=$P(thirdPat,"*",1)
	..s $P(RetShowInfo,"<br/>",3)=$P(secondPat,"*",2)
	..s $P(RetShowInfo,"<br/>",4)=$P(secondPat,"*",1)
	..s $P(RetShowInfo,"<br/>",5)=$P(firstPat,"*",2)
	..s $P(RetShowInfo,"<br/>",6)=$P(firstPat,"*",1)
	.q:((VisType="R")||(VisType="U"))
	
	.i VisType="P" d
	..s VisitPat=$P(ckContent,";",1)
	..s WaitPat=$P(ckContent,";",2)
	..s SkipPat=$P(ckContent,";",3)
	..s DoctorInfo=$P(ckContent,";",4)
	..s Dept=$P(DoctorInfo,",",1)
	..s Doctor=$P(DoctorInfo,",",2)
	..s DocPro=$P(DoctorInfo,",",3)
	..s $P(RetShowInfo,"<br/>",10)=WindowName
	..s $P(RetShowInfo,"<br/>",9)=""  //Doctor
	..s $P(RetShowInfo,"<br/>",8)=""   //DocPro
	..q:WaitPat=""
	..s WaitPat1=$P($P(WaitPat,",",1),"*",2)
	..s WaitPat2=$P($P(WaitPat,",",2),"*",2)
	..s WaitPat3=$P($P(WaitPat,",",3),"*",2)
	..s WaitPat4=$P($P(WaitPat,",",4),"*",2)
	..s WaitPat5=$P($P(WaitPat,",",5),"*",2)
	..s WaitPat6=$P($P(WaitPat,",",6),"*",2)
	..s WaitPat7=$P($P(WaitPat,",",7),"*",2)
	..i WaitPat1'="" s $P(RetShowInfo,"<br/>",7)="1，"_WaitPat1
	..i WaitPat2'="" s $P(RetShowInfo,"<br/>",6)="2，"_WaitPat2
	..i WaitPat3'="" s $P(RetShowInfo,"<br/>",5)="3，"_WaitPat3
	..i WaitPat4'="" s $P(RetShowInfo,"<br/>",4)="4，"_WaitPat4
	..i WaitPat5'="" s $P(RetShowInfo,"<br/>",3)="5，"_WaitPat5
	..i WaitPat6'="" s $P(RetShowInfo,"<br/>",2)="6，"_WaitPat6
	..i WaitPat7'="" s $P(RetShowInfo,"<br/>",1)="7，"_WaitPat7
	.q:VisType="P"
	
	.//门诊医生叫号取数据，单双医生
	.s curLoc=$p($g(ckContent),"!",1)
	.s curRoom=$p($g(ckContent),"!",2)
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curDocPro=$p($g(ckContent),"!",4)
	.s curPatName=$p($g(ckContent),"!",6)
	.i (curPatName'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s curPatName=..PrivateName(curPatName)
	.s curSeqNo=+$p($g(ckContent),"!",5)
	.s secondPat=$p($g(ckContent),"!",7)
	.i (secondPat'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s secondPat=$P(secondPat,"号")_"号-"_..PrivateName($P(secondPat,"号",2))
	.s thridPat=$p($g(ckContent),"!",8)
	.i (thridPat'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s thridPat=$P(thridPat,"号")_"号-"_..PrivateName($P(thridPat,"号",2))
	.s docCode=$p(docInfoStr,"!",2)
	.q:docCode=""
	.s ctpcpRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(docCode),""))
	.s docIntr=$p($g(^CTPCP(ctpcpRowId,3)),"^",11)
	.i ShowIndex=0 d
	..s $P(RetShowInfo,"<br/>",6)=secondPat
	..i secondPat'="" s $P(RetShowInfo,"<br/>",6)=secondPat
	..//zyl201602271535 叫一等一，外加医生特长
	..s $P(RetShowInfo,"<br/>",7)=curPatName
	..i curSeqNo>0 s $P(RetShowInfo,"<br/>",7)=curSeqNo_"号-"_curPatName
	..s $P(RetShowInfo,"<br/>",8)=docIntr
	..//s $P(RetShowInfo,"<br/>",8)=curPatName
	..//i curSeqNo>0 s $P(RetShowInfo,"<br/>",8)=curSeqNo_"号-"_curPatName
	..i $L(curDocDesc)=2 s curDocDesc=$E(curDocDesc,1)_"   "_$E(curDocDesc,2)
	..s $P(RetShowInfo,"<br/>",9)=curDocPro
	..s $P(RetShowInfo,"<br/>",10)=curDocDesc
	.e  d
	..s $P(RetShowInfo,"<br/>",1)=secondPat
	..i thridPat'="" s $P(RetShowInfo,"<br/>",1)=secondPat
	..s $P(RetShowInfo,"<br/>",2)=curPatName
	..i secondPat'="" s $P(RetShowInfo,"<br/>",2)=$P(curPatName,"号")_"号-"_$P(curPatName,"号",2)
	..s $P(RetShowInfo,"<br/>",3)=docIntr
	..//s $P(RetShowInfo,"<br/>",3)=curPatName
	..//i curSeqNo>0 s $P(RetShowInfo,"<br/>",3)=curSeqNo_"号-"_curPatName
	..i $L(curDocDesc)=2 s curDocDesc=$E(curDocDesc,1)_"   "_$E(curDocDesc,2)
	..s $P(RetShowInfo,"<br/>",4)=curDocPro
	..s $P(RetShowInfo,"<br/>",5)=curDocDesc
	.s ShowIndex=ShowIndex+1
	
	i RetShowInfo'="" s RetShowInfo=ShowInfoHead_RetShowInfo
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s Docpicture=docCode_".jpg"

	//s NotStr=##Class(web.DHCVISRelation).GetNoteInfobyObjectId(ClientRowId,"C")
	//s pictureData="&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>Docpicture="""_Docpicture_"""</script></areadata>"
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	//i $G(ckContent)="" s RetShowInfo=RetShowInfo_notifydata
	
	q RetShowInfo //_pictureData  //_NotStr
}

/// w ##class(web.DHCVISVoiceCall).GetOneDocRoomInfoBak("10.1.41.101")
ClassMethod GetOneDocRoomInfoBak(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo="<br/><br/><br/><br/><br/>"
	s VisType="A"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	s WindowName=$P(ClientStr,"^",3)
	q:ServerRowId=0 ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	s ClientRetStr=""
	s nowTime=$p($h,",",2)
	s Broadcast=0
	i $G(^DHCVISSet("Broadcast")) d
	.s Broadcast="1"
	.s IntervalTime=$G(^DHCVISSet("Voice","BroadcastTime"))*60
	e  d
	.s Broadcast="0"
	.s IntervalTime=600
	q:((Broadcast="1")&&((nowTime#IntervalTime)<10)&&(dataIndex'=^DHCVISTemp(+$h,"GetWindowTopStr"))) "&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data=<areadata areaid='l'areatype='lua'><script language='lua'>Broadcastpicture="_"""Broadcast.jpg"""_";</script></areadata>"

	//用于采血数据显示，以&号分割不同的窗口，窗口号为WindowNo，数据存在data中，采一等候二
	i QueType="B" d
	.s (firstPat,secondPat,thirdPat)=""
	.s WindowNow="采血"
	.s WindosWait="等候"
	.s ClientRowId=""
	.f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	..s (firstPat,secondPat,thirdPat)=""
	..s ClientStr=$G(^DHCVISClient(ClientRowId))
	..s WindowNo=$P(ClientStr,"^",5)
	..s ShowInfoHead="areaid=window"_WindowNo_"&areatype=queue&dataid="_dataIndex_"&data="
	..s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	..i QueueId>0 d
	...s QueueStr=$G(^DHCVISQueue(QueueId))
	...q:QueueStr=""
	...s ckContent=$P(QueueStr,"^",18)
	...s creatTime=$P(QueueStr,"^",13)
	...q:($P($H,",",2)-creatTime)>1500
	...s firstPat=$P(ckContent,";",1)
	...s waitList=$P(ckContent,";",2)
	...s secondPat=$P(waitList,",",1)
	...s thirdPat=$P(waitList,",",2)
	..s $P(RetShowInfo,"<br/>",1)=$p(thirdPat,"*",2)
	..s $P(RetShowInfo,"<br/>",2)=$p(secondPat,"*",2)
	..s $P(RetShowInfo,"<br/>",3)=WindosWait
	..s $P(RetShowInfo,"<br/>",4)=$p(firstPat,"*",2)
	..s $P(RetShowInfo,"<br/>",5)=WindowNow
	..i ClientRetStr="" s ClientRetStr=ShowInfoHead_RetShowInfo
	..e  s ClientRetStr=ClientRetStr_"&"_ShowInfoHead_RetShowInfo
	q:((QueType="B")&&(ClientRetStr'="")) ClientRetStr
	
	
	//用于收费处显示
	i QueType="C" d
	.s ClientRetStr=##Class(web.DHCVISRelation).GetRegInfoByClient(ClientRowId)
	q:((QueType="C")) ClientRetStr
	
	s docCode=" "
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s ckContent=$P(QueueStr,"^",18)
	.s creatTime=$P(QueueStr,"^",13)
	.s docInfoStr=$P(QueueStr,"^",22)
	.i ($P($H,",",2)-creatTime)>15000 d
	..s ckContent=""
	.q:ckContent=""
	.//VisType用于区分不同的叫号类型，R/U/P
	.s VisType=$P(QueueStr,"^",5)
	
	.i (VisType="R")||(VisType="U") d
	..s (firstPat,secondPat,thirdPat,fourthPat,fifthPat)=""
	..s firstPat=$P(ckContent,";",1)
	..i firstPat="" s RetShowInfo="" q
	..s waitList=$P(QueueStr,"^",19)
	..s secondPat=$P(waitList,",",1)
	..s thirdPat=$P(waitList,",",2)
	..s $P(RetShowInfo,"<br/>",1)=$P(thirdPat,"*",2)
	..s $P(RetShowInfo,"<br/>",2)=$P(thirdPat,"*",1)
	..s $P(RetShowInfo,"<br/>",3)=$P(secondPat,"*",2)
	..s $P(RetShowInfo,"<br/>",4)=$P(secondPat,"*",1)
	..s $P(RetShowInfo,"<br/>",5)=$P(firstPat,"*",2)
	..s $P(RetShowInfo,"<br/>",6)=$P(firstPat,"*",1)
	.q:((VisType="R")||(VisType="U"))
	
	.i VisType="P" d
	..s VisitPat=$P(ckContent,";",1)
	..s WaitPat=$P(ckContent,";",2)
	..s SkipPat=$P(ckContent,";",3)
	..s DoctorInfo=$P(ckContent,";",4)
	..s Dept=$P(DoctorInfo,",",1)
	..s Doctor=$P(DoctorInfo,",",2)
	..s DocPro=$P(DoctorInfo,",",3)
	..s $P(RetShowInfo,"<br/>",10)=WindowName
	..s $P(RetShowInfo,"<br/>",9)=""  //Doctor
	..s $P(RetShowInfo,"<br/>",8)=""   //DocPro
	..q:WaitPat=""
	..s WaitPat1=$P($P(WaitPat,",",1),"*",2)
	..s WaitPat2=$P($P(WaitPat,",",2),"*",2)
	..s WaitPat3=$P($P(WaitPat,",",3),"*",2)
	..s WaitPat4=$P($P(WaitPat,",",4),"*",2)
	..s WaitPat5=$P($P(WaitPat,",",5),"*",2)
	..s WaitPat6=$P($P(WaitPat,",",6),"*",2)
	..s WaitPat7=$P($P(WaitPat,",",7),"*",2)
	..i WaitPat1'="" s $P(RetShowInfo,"<br/>",7)="1，"_WaitPat1
	..i WaitPat2'="" s $P(RetShowInfo,"<br/>",6)="2，"_WaitPat2
	..i WaitPat3'="" s $P(RetShowInfo,"<br/>",5)="3，"_WaitPat3
	..i WaitPat4'="" s $P(RetShowInfo,"<br/>",4)="4，"_WaitPat4
	..i WaitPat5'="" s $P(RetShowInfo,"<br/>",3)="5，"_WaitPat5
	..i WaitPat6'="" s $P(RetShowInfo,"<br/>",2)="6，"_WaitPat6
	..i WaitPat7'="" s $P(RetShowInfo,"<br/>",1)="7，"_WaitPat7
	.q:VisType="P"
	
	.//门诊医生叫号取数据，单双医生
	.s curLoc=$p($g(ckContent),"!",1)
	.s curRoom=$p($g(ckContent),"!",2)
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curDocPro=$p($g(ckContent),"!",4)
	.s curPatName=$p($g(ckContent),"!",6)
	.s curPatName=..PrivateName(curPatName)
	.s curSeqNo=+$p($g(ckContent),"!",5)
	.s secondPat=$p($g(ckContent),"!",7)
	.s thridPat=$p($g(ckContent),"!",8)
	.s docCode=$p(docInfoStr,"!",2)
	.q:docCode=""
	.s ctpcpRowId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(docCode),""))
	.s docIntr=$p($g(^CTPCP(ctpcpRowId,3)),"^",11)
	.i ShowIndex=0 d
	..s $P(RetShowInfo,"<br/>",6)=secondPat
	..i secondPat'="" s $P(RetShowInfo,"<br/>",6)=$P(secondPat,"号")_"号-"_..PrivateName($P(secondPat,"号",2))
	..//zyl201602271535 叫一等一，外加医生特长
	..s $P(RetShowInfo,"<br/>",7)=curPatName
	..i curSeqNo>0 s $P(RetShowInfo,"<br/>",7)=curSeqNo_"号-"_curPatName
	..s $P(RetShowInfo,"<br/>",8)=docIntr
	..//s $P(RetShowInfo,"<br/>",8)=curPatName
	..//i curSeqNo>0 s $P(RetShowInfo,"<br/>",8)=curSeqNo_"号-"_curPatName
	..i $L(curDocDesc)=2 s curDocDesc=$E(curDocDesc,1)_"   "_$E(curDocDesc,2)
	..s $P(RetShowInfo,"<br/>",9)=curDocPro
	..s $P(RetShowInfo,"<br/>",10)=curDocDesc
	.e  d
	..s $P(RetShowInfo,"<br/>",1)=secondPat
	..i thridPat'="" s $P(RetShowInfo,"<br/>",1)=$P(secondPat,"号")_"号-"_..PrivateName($P(secondPat,"号",2))
	..s $P(RetShowInfo,"<br/>",2)=curPatName
	..i secondPat'="" s $P(RetShowInfo,"<br/>",2)=$P(curPatName,"号")_"号-"_$P(curPatName,"号",2)
	..s $P(RetShowInfo,"<br/>",3)=docIntr
	..//s $P(RetShowInfo,"<br/>",3)=curPatName
	..//i curSeqNo>0 s $P(RetShowInfo,"<br/>",3)=curSeqNo_"号-"_curPatName
	..i $L(curDocDesc)=2 s curDocDesc=$E(curDocDesc,1)_"   "_$E(curDocDesc,2)
	..s $P(RetShowInfo,"<br/>",4)=curDocPro
	..s $P(RetShowInfo,"<br/>",5)=curDocDesc
	.s ShowIndex=ShowIndex+1
	
	i RetShowInfo'="" s RetShowInfo=ShowInfoHead_RetShowInfo
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s Docpicture=docCode_".jpg"

	//s NotStr=##Class(web.DHCVISRelation).GetNoteInfobyObjectId(ClientRowId,"C")
	//s pictureData="&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>Docpicture="""_Docpicture_"""</script></areadata>"
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	//i $G(ckContent)="" s RetShowInfo=RetShowInfo_notifydata
	
	q RetShowInfo //_pictureData  //_NotStr
}

/// w ##class(web.DHCVISVoiceCall).GetOneDocRoomInfoFC("192.168.7.216")
ClassMethod GetOneDocRoomInfoFC(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo=""
	s VisType="A"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	q:ServerRowId=0 ""
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s VisType=$P(QueueStr,"^",5)
	.s ckContent=$P(QueueStr,"^",18)
	.s waitList=$P(QueueStr,"^",19)
	.s creatTime=$P(QueueStr,"^",13)
	.i ($P($H,",",2)-creatTime)>1500 s ckContent=""
	.i ckContent="" s $P(RetShowInfo,"<br/>",27)=""
	.q:ckContent=""
	.s curRoom=$p($g(ckContent),"!",2)
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curDocPro=$p($g(ckContent),"!",4)
	.s curPatName=$p($g(ckContent),"!",5)
	.s curSeqNo=$p($g(ckContent),"!",6)
	.s secondPat=$p($g(ckContent),"!",7)
	.s thridPat=$p($g(ckContent),"!",8)
	.s UserID=$P(QueueStr,"^",11)
	.s docDr=##Class(web.SSUser).GetDefaultCareProvider(UserID)
    .i docDr'="" s curDocDesc=$P($G(^CTPCP(docDr,1)),"^",2)
    .e  s curDocDesc=""
    .i curSeqNo'["号" s curSeqNo=curSeqNo_"号"
    .s curSeqNo=$TR(curSeqNo," ","")
	.s $P(RetShowInfo,"<br/>",1)=curSeqNo_"-"_curPatName
	.s $P(RetShowInfo,"<br/>",2)=curDocDesc
	.s WaitInfo=""
	.i waitList'="" s WaitInfo=..GetWaitListInfoBr(waitList)
	.e  s $P(WaitInfo,"<br/>",25)=""
	.//f i=1:1:25 d
	.//.s $P(WaitInfo,"<br/>",i)=i
	.i WaitInfo'="" s RetShowInfo=RetShowInfo_"<br/>"_WaitInfo
	i RetShowInfo'="" s RetShowInfo=ShowInfoHead_RetShowInfo
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	i $G(ckContent)="" s RetShowInfo=RetShowInfo_notifydata
	q RetShowInfo
}

/// w ##class(web.DHCVISVoiceCall).GetWaitListInfoBr("228*2,229*3,230*4,231*5")
ClassMethod GetWaitListInfoBr(waitListStr As %String = "", QueRowId As %String = "") As %String
{
	s QueRowId=+QueRowId
	s DocDr="",RetWaitStr=""
	i QueRowId>0 d
	.s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.q:QueObj=""
	.s DocDr=QueObj.QueDocDr
	s RetWaitStr=""
	q:waitListStr="" RetWaitStr
	s Index=1
	s listLen=$L(waitListStr,",")
	f j=1:1:listLen d
	.s waitListOne=$P(waitListStr,",",j)
	.q:waitListOne=""
	.q:$P(waitListOne,"*",2)=""
	.s waitQueueId=$P(waitListOne,"*",1)
	.s Status=..GetAdmStatus(waitQueueId)
	.q:(Status="到达")!(Status="过号")!(Status="退号")
	.s QueObj=##Class(User.DHCQueue).%OpenId(waitQueueId)
	.q:QueObj=""
	.q:QueObj.QueCompDr="1"
	.q:(DocDr'="")&&(QueObj.QueDocDr'="")&&(DocDr'=QueObj.QueDocDr)
	.s QueName=QueObj.QueName
	.s QueName=$$ALPHAUP^SSUTIL4(QueName)
	.s waitQueueNo=$P(waitListOne,"*",2)
	.q:Index>25
	.s $P(RetWaitStr,"<br/>",Index)=waitQueueNo_"号-"_QueName
	.s Index=Index+1
	i Index<25 s $P(RetWaitStr,"<br/>",25)=""
	//f i=1:1:25 d
	//.s $P(RetWaitStr,"<br/>",i)=i
	//.
	q RetWaitStr
}

/// w ##class(web.DHCVISVoiceCall).GetTwoDocRoomInfo("172.16.23.211")
ClassMethod GetTwoDocRoomInfo(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead1="areaid=queueinfo1&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo1="<br/><br/><br/><br/>"
	s ShowInfoHead2="areaid=queueinfo2&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo2="<br/><br/><br/><br/>"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	q:ServerRowId=0 ""
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s ckContent=$P(QueueStr,"^",18)
	.s creatTime=$P(QueueStr,"^",13)
	.i ($P($H,",",2)-creatTime)>1500 s ckContent=""
	.q:ckContent=""
	.s curRoom=$p($g(ckContent),"!",2)
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curDocPro=$p($g(ckContent),"!",4)
	.s curPatName=$p($g(ckContent),"!",5)
	.s curSeqNo=+$p($g(ckContent),"!",6)
	.s secondPat=$p($g(ckContent),"!",7)
	.s thridPat=$p($g(ckContent),"!",8)
	.i ShowIndex=0 d
	..s $P(RetShowInfo1,"<br/>",1)=thridPat
	..s $P(RetShowInfo1,"<br/>",2)=secondPat
	..s $P(RetShowInfo1,"<br/>",3)=curSeqNo_"号"_curPatName
	..s $P(RetShowInfo1,"<br/>",4)=curDocPro
	..s $P(RetShowInfo1,"<br/>",5)=curDocDesc
	.e  d
	..s $P(RetShowInfo2,"<br/>",1)=thridPat
	..s $P(RetShowInfo2,"<br/>",2)=secondPat
	..s $P(RetShowInfo2,"<br/>",3)=curSeqNo_"号"_curPatName
	..s $P(RetShowInfo2,"<br/>",4)=curDocPro
	..s $P(RetShowInfo2,"<br/>",5)=curDocDesc
	.s ShowIndex=ShowIndex+1
	s RetShowInfo=ShowInfoHead1_RetShowInfo1_"&"_ShowInfoHead2_RetShowInfo2
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	i $G(ckContent)="" s RetShowInfo=RetShowInfo_notifydata
	q RetShowInfo
}

/// w ##class(web.DHCVISVoiceCall).GetTwoDocRoomInfoNN("172.16.23.211")
ClassMethod GetTwoDocRoomInfoNN(ClientTopIP As %String = "") As %String
{
	q:ClientTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead1="areaid=queueinfo1&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo1="<br/><br/>"
	s ShowInfoHead2="areaid=queueinfo2&areatype=queue&dataid="_dataIndex_"&data="
	s RetShowInfo2="<br/><br/>"
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	q:ServerRowId=0 ""
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,ClientTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,ClientRowId)) q:(ClientRowId="")  d
	.s QueueId=+$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:QueueId=0
	.s QueueStr=$G(^DHCVISQueue(QueueId))
	.q:QueueStr=""
	.s ckContent=$P(QueueStr,"^",18)
	.s creatTime=$P(QueueStr,"^",13)
	.i ($P($H,",",2)-creatTime)>1500 s ckContent=""
	.q:ckContent=""
	.s curRoom=$p($g(ckContent),"!",2)
	.s curDocDesc=$p($g(ckContent),"!",3)
	.s curDocPro=$p($g(ckContent),"!",4)
	.s curPatName=$p($g(ckContent),"!",5)
	.s curSeqNo=+$p($g(ckContent),"!",6)
	.s secondPat=$p($g(ckContent),"!",7)
	.s thridPat=$p($g(ckContent),"!",8)
	.i $p(secondPat,"号",2)'="" s secondPat=$p(secondPat,"号",2)
	.i $p(thridPat,"号",2)'="" s thridPat=$p(thridPat,"号",2)
	.s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	.i ShowIndex=0 d
	..s $P(RetShowInfo1,"<br/>",1)="2. "_thridPat_"候诊"
	..s $P(RetShowInfo1,"<br/>",2)="1. "_secondPat_"候诊"
	..s $P(RetShowInfo1,"<br/>",3)="请"_curPatName_"到"_WindowDesc_"就诊"
	.e  d
	..s $P(RetShowInfo2,"<br/>",1)="2. "_thridPat_"候诊"
	..s $P(RetShowInfo2,"<br/>",2)="1. "_secondPat_"候诊"
	..s $P(RetShowInfo2,"<br/>",3)="请"_curPatName_"到"_WindowDesc_"就诊"
	.s ShowIndex=ShowIndex+1
	s RetShowInfo=ShowInfoHead1_RetShowInfo1_"&"_ShowInfoHead2_RetShowInfo2
	s ClientRowId=$O(^DHCVISClienti(0,"ClientTopIP",ClientTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",17)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	//s notifydata="&areaid=notify1&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	//i $G(ckContent)="" s RetShowInfo=RetShowInfo_notifydata
	q RetShowInfo
}

/// w ##class(web.DHCVISVoiceCall).GetZHWindowTopStr("11.1.30.162","请 1号 zl测试01 到 测试01诊室 就诊,请 1号 MIC测试1 等候")
ClassMethod GetZHWindowTopStrBak(ZHTopIPStr As %String = "", ContentStr As %String = "") As %String
{
	//s ^lzx($h)=ZHTopIPStr_"^"_ContentStr
	s RetZHTopStr=""
	q:(ContentStr="") ""
	s ContentStrOne=$TR(ContentStr," ")
	s dataIndex=+$P($H,",",2)
	s NoticePop=$G(^DHCVISSet("NoticePop"))
	i NoticePop=1 d 
	.s PatInfo=$P(ContentStr," ",2)_" "_$P(ContentStr," ",3)
	.s ContentStr=$P(ContentStr,PatInfo,1)_$P(ContentStr,PatInfo,2)
	.s ContentStr=$TR(ContentStr," ")
	.s RetZHTopStr="&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_ContentStr_""";PatInfo="""_PatInfo_""";</script></areadata>"
	.s ContentStr=$TR(ContentStr," ")
	.s RetZHTopStr=RetZHTopStr_"&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStrOne
	e  d
	.s ContentStr=$TR(ContentStr," ")
	.s RetZHTopStr="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStrOne
	q RetZHTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetZHWindowTopStr("10.6.8.2","请 3号 柳红 到 02诊室 就诊,请 4号 刘枫 等候")
ClassMethod GetZHWindowTopStrBak1(ZHTopIPStr As %String = "", ContentStr As %String = "") As %String
{
	s RetZHTopStr=""
	s VoiceContent=ContentStr
	s PatInfo=$P(ContentStr," ",2)_" "_$P(ContentStr," ",3)
	s ContentStr=$P(ContentStr,PatInfo,1)_$P(ContentStr,PatInfo,2)
	s ContentStr=$TR(ContentStr," ")
	s ZHTopLen=$L(ZHTopIPStr,",")
	f zhtopi=1:1:ZHTopLen d
	.s ZHTopIP=$P(ZHTopIPStr,",",zhtopi)
	.q:(ZHTopIP="")!(ContentStr="")
	.s dataIndex=+$P($H,",",2)
	.//s ContentStr=$TR(ContentStr,"请")
	.//s msgContent=ZHTopIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStr
	.s msgContent=ZHTopIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_VoiceContent
	.s NoticePop=$G(^DHCVISSet("NoticePop"))
	.i NoticePop="1" s msgContent=msgContent_"&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_ContentStr_""";PatInfo="""_PatInfo_""";</script></areadata>"
	.i RetZHTopStr="" s RetZHTopStr=msgContent
	.e  s RetZHTopStr=RetZHTopStr_"#"_msgContent
	q RetZHTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetZHWindowTopStr("10.6.8.2","请 3号 柳红 到 02诊室 就诊,请 4号 刘枫 等候")
ClassMethod GetZHWindowTopStr(ZHTopIPStr As %String = "", ContentStr As %String = "") As %String
{
	s patname=""
	s RetZHTopStr=""
	s VoiceContent=ContentStr
	i (ContentStr'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) d
	.s $p(ContentStr," ",3)=..PrivateName($p(ContentStr," ",3))
	.i $p(ContentStr," ",9)'="" s $p(ContentStr," ",9)=..PrivateName($p(ContentStr," ",9))
	s PatInfo=$P(ContentStr," ",2)_" "_$P(ContentStr," ",3)
	s ContentStr=$P(ContentStr,PatInfo,1)_$P(ContentStr,PatInfo,2)
	s ContentStr=$TR(ContentStr," ")
	//s patname=$P(PatInfo," ",2)
	//s patname=..PrivateName(patname)
	//s PatInfo=$P(PatInfo," ",1)_" "_patname
	s ZHTopLen=$L(ZHTopIPStr,",")
	f zhtopi=1:1:ZHTopLen d
	.s ZHTopIP=$P(ZHTopIPStr,",",zhtopi)
	.q:(ZHTopIP="")!(ContentStr="")
	.s dataIndex=+$P($H,",",2)
	.//s ContentStr=$TR(ContentStr,"请")
	.//s msgContent=ZHTopIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_ContentStr
	.s msgContent=ZHTopIP_"*msg=dataupdate&areaid=notify&areatype=queue&dataid="_dataIndex_"&data="_VoiceContent
	.s NoticePop=$G(^DHCVISSet("NoticePop"))
	.i NoticePop="1" s msgContent=msgContent_"&areaid=l&areatype=lua&dataid="_dataIndex_"&action=addnew&data="_"<areadata areaid='l' areatype='lua'><script language='lua'>VoiceContent="""_ContentStr_""";PatInfo="""_PatInfo_""";</script></areadata>"
	.i RetZHTopStr="" s RetZHTopStr=msgContent
	.e  s RetZHTopStr=RetZHTopStr_"#"_msgContent
	q RetZHTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenTopInfo("10.1.30.162")
ClassMethod GetScreenTopInfo(serverIP As %String = "") As %String
{
	s AreaRefresh=+$G(^DHCVISSet("AreaRefresh"))
	i AreaRefresh=0 s AreaRefresh=5
	s NowTime=$P($H,",",2)
	i $G(^DHCVISTemp("AreaRefresh",serverIP))="" s ^DHCVISTemp("AreaRefresh",serverIP)=$P($H,",",2)
	s Interval=NowTime-$G(^DHCVISTemp("AreaRefresh",serverIP))
	i Interval<0 s Interval=-Interval
	q:(Interval<AreaRefresh) ""
	s ^DHCVISTemp("AreaRefresh",serverIP)=$P($H,",",2)
	s RetStr="" 
	s dataIndex=+$P($H,",",2)
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr
	s WindowStr=$P($G(^DHCVISServer(serverId)),"^",14)
	i WindowStr'="" s WindowStr="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowStr
	s TopIPStr=$P($G(^DHCVISServer(serverId)),"^",13)
	s TopLen=$L(TopIPStr,",")
	f topi=1:1:TopLen d
	.s TopIP=$P(TopIPStr,",",topi)
	.q:TopIP=""
	.i topi=1 s WaitStr=..GetScreenWaitInfo(serverIP)
	.//q:(WaitStr="")
	.s ServerWaitInfo=..GetServerMarkWaitInfo(serverIP)
	.i ServerWaitInfo'="" s WaitStr=WaitStr_"&"_ServerWaitInfo
	
	.s PassInfo=..GetTopPassInfomation(serverIP)
	.i PassInfo'="" s WaitStr=WaitStr_"&"_PassInfo
	.i RetStr="" d
	..i WindowStr'="" s RetStr=TopIP_"*msg=dataupdate&"_WaitStr_"&"_WindowStr
	..e  s RetStr=TopIP_"*msg=dataupdate&"_WaitStr
	.e  d
	..i WindowStr'="" s RetStr=RetStr_"#"_TopIP_"*msg=dataupdate&"_WaitStr_"&"_WindowStr
	..e  s RetStr=RetStr_"#"_TopIP_"*msg=dataupdate&"_WaitStr
	//q:RetStr="" RetStr
	//刷新诊室屏幕信息
	s clientTopIP=""
	f  s clientTopIP=$O(^DHCVISClienti(0,"ServerTop",serverId,clientTopIP)) q:clientTopIP=""  d
	.q:clientTopIP=""
	.//s CKShowQueueInfo=..GetCKShowInfo(clientTopIP)
	.s CKShowQueueInfo=..GetOneDocRoomInfo(clientTopIP)
	.i CKShowQueueInfo'="" d
	..s clientTopLen=$L(clientTopIP,",")
	..f topi=1:1:clientTopLen d
	...s TopIP=$P(clientTopIP,",",topi)
	...i RetStr="" s RetStr=TopIP_"*msg=dataupdate&"_CKShowQueueInfo
	...e  s RetStr=RetStr_"#"_TopIP_"*msg=dataupdate&"_CKShowQueueInfo
	//刷新科室屏幕信息
	s locTopIP=""
	f  s locTopIP=$O(^DHCVISClienti(0,"SeverLocTop",serverId,locTopIP)) q:locTopIP=""  d
	.q:locTopIP=""
	.s locShowQueueInfo=..GetLocShowInfo(locTopIP)
	.q:locShowQueueInfo=""
	.s PartInfo=..GetPartWaitInfo(serverIP)
	.i PartInfo'="" s locShowQueueInfo=locShowQueueInfo_"&"_PartInfo
	.i locShowQueueInfo'="" s RetStr=RetStr_"#"_locTopIP_"*msg=dataupdate&"_locShowQueueInfo
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetServerMarkWaitInfo("10.1.61.15")
/// w ##class(web.DHCVISVoiceCall).GetServerMarkWaitInfo("COFFEE-PC")
ClassMethod GetServerMarkWaitInfo111(serverIP As %String = "") As %String
{
	s dataIndex=$P($H,",",2)
	s max=10,t=1
	s colorStr="<br/><br/><br/><br/><br/><br/><br/><br/>"
	s RetString="areaid=waitinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetWaitStr="<br/><br/><br/><br/><br/><br/><br/><br/>"
	q:serverIP="" RetString_RetWaitStr
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId=""
	s QueType=$P($G(^DHCVISServer(serverId)),"^",9)
    s RetMarkDesc=""

	i $d(^DHCVISMark(+$h,serverId))=0 d
    .s RetMarkDesc=..GetBordMark(serverIP)
    s MarkID=""  f  s MarkID=$o(^DHCVISMark(+$h,serverId,MarkID))  q:(MarkID="")  d
    .s queNo=""  f  s queNo=$o(^DHCVISMark(+$h,serverId,MarkID,queNo)) q:(queNo="")||(t>(max-1))  d	
	..s $P(RetWaitStr,"<br/>",max-t)=^DHCVISMark(+$h,serverId,MarkID,queNo)
	..s t=t+1
	..k ^DHCVISMark(+$h,serverId,MarkID,queNo)
	.s RetMarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
	.s $P(RetWaitStr,"<br/>",max)=RetMarkDesc
	f n=1:1:max d
	.i $p(RetWaitStr,"<br/>",n)="" s $p(RetWaitStr,"<br/>",n)=" "
	.s colorCode="0xffffffff"
	.//i $l($p(RetWaitStr,"<br/>",n),"等候")>1 s colorCode=""
	.i $l($p(RetWaitStr,"<br/>",n),"过号")>1 s colorCode="0xffffcc00"
	.i $l($p(RetWaitStr,"<br/>",n),"复诊")>1 s colorCode="0xff00fff2"
	.s $p(colorStr,"<br/>",n)=colorCode
   // s RetWaitStr="10-董富强 等候 <br/>9-董富强 等候<br/>8-董富强 过号<br/>7-董富强 过号<br/>6-董富强 复诊<br/>5-董富强 过号<br/>4-董富强 过号<br/>3-董富强 过号<br/>2-董富强 过号<br/>1-董富强 过号"	 
	s RetString=RetString_RetWaitStr_"&color="_colorStr
	q RetString
}

// w ##class(web.DHCVISVoiceCall).GetBordMark("10.1.30.162")

ClassMethod GetBordMark(serverIP As %String = "") As %String
{

	//s Index=$I(^LF(+$h,"GetBordMark"))
	//s ^LF(+$h,"GetBordMark",Index)=serverIP
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" ""
	s BorId=$P($G(^DHCVISServer(serverId)),"^",7)
	q:BorId="" ""
	//s Str=..GetBordMarkFlag(serverIP,BorId)
	S RetStr="",m=1,markDesc=""
	i $d(^DHCVISMark(+$h,serverId))=0 {
	s BorMarkId=$g(^DHCVISMarkIndex(+$h,serverId)) 
	f  s BorMarkId=$o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))  q:(BorMarkId="")||(m>1)  d	
    .//q:$G(^DHCVISMark("GetBordMarkFlag",+$h,serverId,BorMarkId))'=""    //判断科室号别是否重复
    .s si=$List(^User.DHCDepMarkD(BorMarkId),5)
    .s depStat=$List(^User.DHCDepMarkD(BorMarkId),6)
    .q:((si="N")||(depStat'=1))  ;非当前、可用的不统计
    .s depDr=$List(^User.DHCDepMarkD(BorMarkId),8)  ;科室
	.s markDr=$List(^User.DHCDepMarkD(BorMarkId),3)  ;号别
	.;诊区所对应的号别
	.q:(markDr="")||(depDr="")
	.//s:markDr'="" markDesc=$P($G(^CTPCP(markDr,1)),"^",2)
    .s depSub =""_depDr
	.s num=0
     .//w markDr_"**"_markDesc,!
	.s patInfo=""
    .s QueRowId=0
	.f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,depSub,QueRowId))  q:QueRowId=""  d
    ..q:$ListLength(^User.DHCQueueD(QueRowId))<1
    ..s patNo=$List(^User.DHCQueueD(QueRowId),10)
    ..s patName=$List(^User.DHCQueueD(QueRowId),9)
    ..i +$g(^DHCVISSet("NamePrivacy"))=1 s patName=..PrivateName(patName)                 //ding 1230
    ..s markId=$List(^User.DHCQueueD(QueRowId),8)   //科室ID
    ..//w markDr_"--"_markId,!
    ..q:markDr'=markId
    ..s markDesc=$P($G(^CTPCP(markId,1)),"^",2)
    ..s patStateDr=$List(^User.DHCQueueD(QueRowId),14)
    ..s patState=$List(^User.DHCPerStateD(patStateDr),4)
    ..i patStateDr=7 s patState="未报"
    ..q:(patStateDr'=1)&&(patStateDr'=2)&&(patStateDr'=3)&&(patStateDr'=7)  // 1hz 2dh 3gh 7wb  ding1230 
    ..i $L(patNo)=1 s patNo=" "_patNo
    ..s patInfo=patNo_" "_patName_"("_patState_")"
    ..s num=num+1
    ..s ^DHCVISMark(+$h,serverId,markDr,num)=patInfo
    .s ^DHCVISMarkIndex(+$h,serverId)=BorMarkId
    .i $o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))="" s ^DHCVISMarkIndex(+$h,serverId)=""
    .q:patInfo=""
    .s m=m+1
    
    s Flag=0 
    q:$g(^DHCVISMarkIndex(+$h,serverId))="" ""
    s BorMarkId=$g(^DHCVISMarkIndex(+$h,serverId)) 
	f  s BorMarkId=$o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))  q:(BorMarkId="")||(Flag=1)  d	
    .//q:$G(^DHCVISMark("GetBordMarkFlag",+$h,serverId,BorMarkId))'=""    //判断科室号别是否重复
    .s si=$List(^User.DHCDepMarkD(BorMarkId),5)
    .s depStat=$List(^User.DHCDepMarkD(BorMarkId),6)
    .q:((si="N")||(depStat'=1))  ;非当前、可用的不统计
    .s depDr=$List(^User.DHCDepMarkD(BorMarkId),8)  ;科室
	.s markDr=$List(^User.DHCDepMarkD(BorMarkId),3)  ;号别
	.;诊区所对应的号别
	.q:(markDr="")||(depDr="")
	.//s:markDr'="" markDesc=$P($G(^CTPCP(markDr,1)),"^",2)
    .s depSub =""_depDr
	.s num=0
   
	.s patInfo=""
    .s QueRowId=0
	.f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,depSub,QueRowId))  q:QueRowId=""  d
    ..q:$ListLength(^User.DHCQueueD(QueRowId))<1
    ..s patNo=$List(^User.DHCQueueD(QueRowId),10)
    ..s patName=$List(^User.DHCQueueD(QueRowId),9)
    ..i +$g(^DHCVISSet("NamePrivacy"))=1 s patName=..PrivateName(patName)                 //ding 1230
    ..s markId=$List(^User.DHCQueueD(QueRowId),8)   //科室ID
    ..q:markDr'=markId
    ..s patStateDr=$List(^User.DHCQueueD(QueRowId),14)
    ..s patState=$List(^User.DHCPerStateD(patStateDr),4)
    ..i patStateDr=7 s patState="未报"
    ..q:(patStateDr'=1)&&(patStateDr'=2)&&(patStateDr'=3)&&(patStateDr'=7)  // 1hz 2dh 3gh 7wb  ding1230 
    ..i $L(patNo)=1 s patNo=" "_patNo
    ..s patInfo=patNo_" "_patName_"("_patState_")"
    ..s num=num+1
    ..i patInfo'=""  s Flag=1
    i Flag=0 s ^DHCVISMarkIndex(+$h,serverId)=""  
	}
	
	q markDesc
}

// w ##class(web.DHCVISVoiceCall).GetBordMark1111("10.1.30.162")

ClassMethod GetBordMark1111(serverIP As %String = "") As %String
{
	s docStr=""
	q:serverIP="" ""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" ""
	s BorId=$P($G(^DHCVISServer(serverId)),"^",7)
	q:BorId="" "&^^^^^^^^^&^^^^^^^^^&"
	S RetStr="",m=1,markDesc=""
	k ^DHCVISBorTemp(+$h,serverIP)
	s BorMarkId=""  //诊区号别
	f  s BorMarkId=$o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))  q:(BorMarkId="")  d	
    .s si=$List(^User.DHCDepMarkD(BorMarkId),5)
    .s depStat=$List(^User.DHCDepMarkD(BorMarkId),6)
    .q:((si="N")||(depStat'=1))  ;非当前、可用的不统计
    .s depDr=$List(^User.DHCDepMarkD(BorMarkId),8)  ;科室
	.s markDr=$List(^User.DHCDepMarkD(BorMarkId),3)  ;号别
	.;诊区所对应的号别
	.q:(markDr="")||(depDr="")
	.s:markDr'="" markDesc=$P($G(^CTPCP(markDr,1)),"^",2)
    .s depSub =""_depDr

	.s patInfo=""
    .s QueRowId=0
	.f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,depSub,QueRowId))  q:QueRowId=""  d
    ..q:$ListLength(^User.DHCQueueD(QueRowId))<1
    ..s markId=$List(^User.DHCQueueD(QueRowId),8)  
    ..s docDr=$List(^User.DHCQueueD(QueRowId),5) 
    ..s patStateDr=$List(^User.DHCQueueD(QueRowId),14)
    ..s patNumber=$List(^User.DHCQueueD(QueRowId),10) 
    ..q:patNumber=""
    ..q:(patStateDr'=1)&&(patStateDr'=2)&&(patStateDr'=3)&&(patStateDr'=7) // 1回诊 2等候 3过号 7未报到
    ..q:markDr'=markId
    ..//w "markId:",markId,"  ","docDr",docDr,!
    ..q:($o(^SSU("SSUSR",0,"CTPCP",markId,""))="")&&(docDr="") // 专科号未指定医生
    ..i $o(^SSU("SSUSR",0,"CTPCP",markId,""))=""  s markId=docDr
    ..i (docDr'="")&&(docDr'=markId) s markId=docDr  //专家号 指定医生
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",markId,""))
	..s ^DHCVISBorTemp(+$h,serverIP,UserID)=depDr_"!"_UserID //_"!"_markId

	s AllPatient="",PatientNo="",SurName="",ArrivedQue=""
	s markNum=1
	i $d(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP))=0{
	s UserID=$g(^DHCVISBorTempIndex(+$h,serverIP))
	i $O(^DHCVISBorTemp(+$h,serverIP,UserID))="" s UserID=""
	f  s UserID=$O(^DHCVISBorTemp(+$h,serverIP,UserID)) q:(UserID="")||(markNum>1)  d
	.s LocID=$p(^DHCVISBorTemp(+$h,serverIP,UserID),"!")
	.s ^DHCVISBorTempPage(+$h,serverIP)=0
	.d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","FindLocDocCurrentAdm",LocID,UserID,serverIP,AllPatient,PatientNo,SurName,nowDate,nowDate,ArrivedQue,"on")
	.s markNum=markNum+1
	}
	s maxShow=10,T=0
	s User="",patFirStr="",patStr="",typeFlag=0,pageNum=0
	f  s User=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User)) q:User=""  d
	.s patIndex="",I=1
	.f  s patIndex=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)) q:(patIndex="")||(I>maxShow)  d
	..s ReStr=^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	..s patName=$p(ReStr,"^",4)
	..s patNum=$p(ReStr,"^",3)
	..s patState=$p(ReStr,"^",2)
	..i patState="未报到" s patState="未报"
	..//i patState="优先" s patState="等候"
	..s patInfo=patNum_" "_patName_"("_patState_")"
	..s I=I+1
	..i patStr="" s patStr=patInfo
	..e  s patStr=patStr_"^"_patInfo
	..k ^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	.i patFirStr="" s patFirStr=patStr
	.e  s patFirStr=patFirStr_"&"_patStr
	.s docStr=docDesc_"  "_DocTypeDesc
	.i $o(^DHCVISBorTemp(+$h,serverIP,User))="" s ^DHCVISBorTempIndex(+$h,serverIP)="",^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	.e  s ^DHCVISBorTempIndex(+$h,serverIP)=User,^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	//w "patFirStr"_patFirStr,!
	s HZStr=$p(patFirStr,"&"),DHStr=$p(patFirStr,"&",2)
	s HZlen=$l(HZStr,"^"), DHlen=$l(DHStr,"^")
	i HZlen<maxShow s $p(HZStr,"^",maxShow)=""
	i DHlen<maxShow s $p(DHStr,"^",maxShow)=""
	s patFirStr=DHStr_"&"_HZStr
	i ($d(^DHCVISBorTempPage(+$h,serverIP))=0) s ^DHCVISBorTempPage(+$h,serverIP)=""
	s patFirStr=docStr_"&"_patFirStr_"&"_^DHCVISBorTempPage(+$h,serverIP)
    
	q patFirStr
}

/// w ##class(web.DHCVISVoiceCall).GetLocShowInfo("172.16.38.47")
ClassMethod GetLocShowInfo(LocTopIP As %String = "") As %String
{
	q:LocTopIP="" ""
	s dataIndex=$P($H,",",2)
	s ShowInfoHead="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="
	s ShowMax=6
	s RetShowInfo="<br/><br/><br/><br/><br/>"
	s ClientRowId=$O(^DHCVISClienti(0,"LocTopIP",LocTopIP,""))
	q:ClientRowId="" ""
	s ClientStr=$G(^DHCVISClient(ClientRowId))
	s ServerRowId=+$P(ClientStr,"^",1)
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	q:ServerRowId=0 ""
	s VisType="A"
	s ShowIndex=0
	s ClientRowId=$G(^DHCTempVISL(+$H,LocTopIP))
	f  s ClientRowId=$O(^DHCVISClienti(0,"LocTopIP",LocTopIP,ClientRowId)) q:((ClientRowId="")||(ShowIndex>(ShowMax-2)))  d
	.s zhContent=$G(^DHCTempVIS(+$H,ServerRowId,ClientRowId))
	.q:zhContent=""
	.q:+zhContent=0
	.i $P(zhContent,"*",2)'="" d
	..s queueId=+$P(zhContent,"*")
	..s queueStr=$G(^DHCVISQueue(queueId))
	..q:queueStr=""
	..s VisType=$P(queueStr,"^",5)
	..i VisType="R" d
	...s ShowMax=11
	...i $L(RetShowInfo,"<br/>")=6 s RetShowInfo=RetShowInfo_"<br/><br/><br/><br/><br/>"
	..s creatTime=$P(queueStr,"^",13)
	..i ($P($H,",",2)-creatTime)>1500 s zhContent=""
	..q:($P($H,",",2)-creatTime)>1500
	..s zhContent=$P(queueStr,"^",17)
	..s waitList=$P(queueStr,"^",19)
	..i $P(zhContent,"*",2)'="" d
	...s QueRowId=+zhContent
	...s Status=..GetAdmStatus(QueRowId)
	...//i (Status="过号")!(Status="退号") s zhContent=""
	...i (Status="退号") s zhContent=""
	...e  s zhContent=$P(zhContent,"*",2)
	..q:zhContent=""
	..i $P(waitList,"*",2)'="" d
	...s waitList=..GetWaitList(waitList)
	...i QueType="0" s waitList="" 
	...i waitList'="" s zhContent=zhContent_waitList
	.q:zhContent=""
	.s ShowIndex=ShowIndex+1
	.s ^DHCTempVISL(+$H,LocTopIP)=ClientRowId
	.s $P(RetShowInfo,"<br/>",ShowMax-ShowIndex)=zhContent
	//s $P(RetShowInfo,"<br/>",ShowMax)="诊室医生       序号 就诊者 等候号"
	s $P(RetShowInfo,"<br/>",ShowMax)="  科室-诊室               医生         序号     当前就诊     准备就诊"
	i VisType="R" d
	.s $P(RetShowInfo,"<br/>",ShowMax)="诊室    当前就诊者        诊室    当前就诊者"
	s ^DHCTempVISL(+$H,LocTopIP)=$O(^DHCVISClienti(0,"LocTopIP",LocTopIP,ClientRowId),-1)
	i ShowIndex=0 s ^DHCTempVISL(+$H,LocTopIP)=""
	q:ShowIndex=0 ""
	s ClientRowId=^DHCTempVISL(+$H,LocTopIP)
	i $O(^DHCVISClienti(0,"LocTopIP",LocTopIP,ClientRowId))="" s ^DHCTempVISL(+$H,LocTopIP)=""
	s RetShowInfo=ShowInfoHead_RetShowInfo
	
	s ClientRowId=$O(^DHCVISClienti(0,"LocTopIP",LocTopIP,""))
	s WindowDesc=$P($G(^DHCVISClient(ClientRowId)),"^",19)
	i WindowDesc'="" s WindowDesc="areaid=windowinfo&areatype=queue&dataid="_dataIndex_"&data="_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo'="") s RetShowInfo=RetShowInfo_"&"_WindowDesc
	i (WindowDesc'="")&&(RetShowInfo="") s RetShowInfo=WindowDesc
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"
	i ShowIndex=0 s RetShowInfo=RetShowInfo_notifydata
	q RetShowInfo
}

// w ##class(web.DHCVISVoiceCall).GetEveryWaitInfo("AdultStr",273,12) 

ClassMethod GetEveryWaitInfo(codeStr As %String = "", LocId As %String = "", codeRows As %String = "", code As %String = "") As %String
{
	s RetShowStr=""
	s $p(RetShowStr,"<br/>",codeRows)=""
	i $d(^DHCVISShowTemp(+$h,codeStr))=0 {
	
		//s showStr="1测试数据,2测试数据,3测试数据,4测试数据,5测试数据,6测试数据,7测试数据,8测试数据,9测试数据,10测试数据,11测试数据,12测试数据" 
		s showStr=##class(web.DHCNurCom).GetInfusionDate(LocId,code)  
		s showStrLen=$l(showStr,",")

		f i=1:1:showStrLen  d
		.s patItem=$p(showStr,",",i)
		.i codeStr'="ZhuSheStr" s patItem=$p(patItem,"(")
		.i (+$g(^DHCVISSet("NamePrivacy"))=1)  d
		..i $l(patItem,"-")>1 s patItem=..PrivateName($p(patItem,"-",2))
		..e  s patItem=..PrivateName(patItem)
		.s ^DHCVISShowTemp(+$h,codeStr,i)=patItem
	}
	s i=0
	s index=""  f  s index=$o(^DHCVISShowTemp(+$h,codeStr,index))  q:(index="")||(i+1>codeRows)  d
	.s $p(RetShowStr,"<br/>",codeRows-i)=^DHCVISShowTemp(+$h,codeStr,index)
	.k ^DHCVISShowTemp(+$h,codeStr,index)
	.s i=i+1
	q RetShowStr
}

// w ##class(web.DHCVISVoiceCall).GetChildAndSkinWaitInfo("194.2.100.220") 

// 儿科 配药与皮试

ClassMethod GetChildAndSkinWaitInfo(serverIP As %String = "", LocId As %String = "", Rows As %String = "", code As %String = "") As %String
{
    //q "areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室"                                                                                                                                          
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=Rows
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	s Time=17500                                                                                                                                          
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)                                                                                                             
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetChildStr="",RetSkinStr=""  
	s RetChildStr=..GetEveryWaitInfo("ChildStr",LocId,Rows,code)
	s $p(RetChildStr,"<br/>",maxRow+1)="",$p(RetChildStr,"<br/>",maxRow+2)="配液中 " 
	s RetSkinStr=..GetEveryWaitInfo("SkinStr",LocId,Rows)
	s $p(RetSkinStr,"<br/>",maxRow+1)="",$p(RetSkinStr,"<br/>",maxRow+2)="请到配液室看皮试结果" 
    s RetWaitTopStr=RetWaitTopStr1_RetSkinStr_"<br/>"_RetChildStr

    q RetWaitTopStr
}

// 儿科 输液 

ClassMethod GetErShuWaitInfo(serverIP As %String = "", LocId As %String = "", Rows As %String = "", code As %String = "") As %String
{
    //q "areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室"                                                                                                                                          
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=Rows
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	s Time=17500                                                                                                                                          
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)                                                                                                             
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetErShuStr=""
	
	s RetErShuStr=..GetEveryWaitInfo("ErShuStr",LocId,Rows,code)
	s $p(RetErShuStr,"<br/>",maxRow+1)="",$p(RetErShuStr,"<br/>",maxRow+2)="",$p(RetErShuStr,"<br/>",maxRow+3)=""
	s $p(RetErShuStr,"<br/>",maxRow+4)="请到小儿输液室输液" 
    s RetWaitTopStr=RetWaitTopStr1_RetErShuStr
    q RetWaitTopStr
}

// 注射皮试

ClassMethod GetZhuSheSkinWaitInfo(serverIP As %String = "", LocId As %String = "", Rows As %String = "") As %String
{
    //q "areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室"                                                                                                                                          
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=Rows
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	s Time=17500                                                                                                                                          
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)                                                                                                             
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetZhuSheStr=""
	
	s RetZhuSheStr=..GetEveryWaitInfo("ZhuSheStr",LocId,Rows)
	s $p(RetZhuSheStr,"<br/>",maxRow+1)="",$p(RetZhuSheStr,"<br/>",maxRow+2)="",$p(RetZhuSheStr,"<br/>",maxRow+3)=""
	s $p(RetZhuSheStr,"<br/>",maxRow+4)="请以下患者到对应诊台看皮试结果" 
    s RetWaitTopStr=RetWaitTopStr1_RetZhuSheStr
    q RetWaitTopStr
}

// w ##class(web.DHCVISVoiceCall).GetAdultAndSkinWaitInfo("194.2.100.232",273,12,2) 

// 成人输液  皮试

ClassMethod GetAdultAndSkinWaitInfo(serverIP As %String = "", LocId As %String = "", Rows As %String = "", code As %String = "") As %String
{
    //q "areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室"                                                                                                                                          
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=12
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	s Time=17500                                                                                                                                          
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)                                                                                                             
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetAdultStr="",RetAdultSkinStr=""

	s RetAdultStr=..GetEveryWaitInfo("AdultStr",LocId,Rows,code)

	s $p(RetAdultStr,"<br/>",maxRow+1)="",$p(RetAdultStr,"<br/>",maxRow+2)="请以下患者速到成人输液室" 
	s RetAdultSkinStr=..GetEveryWaitInfo("AdultSkinStr",LocId,Rows)
	s $p(RetAdultSkinStr,"<br/>",maxRow+1)="",$p(RetAdultSkinStr,"<br/>",maxRow+2)="请以下患者来看皮试结果" 
    s RetWaitTopStr=RetWaitTopStr1_RetAdultSkinStr_"<br/>"_RetAdultStr

    q RetWaitTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenWaitInfo("10.1.41.101")                                                                                 
ClassMethod GetScreenWaitInfo(serverIP As %String = "") As %String
{
    //q "areaid=queueinfo&areatype=queue&dataid=41790&data=5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>5号,6号<br/>4号-东华医疗<br/>蒋荣猛<br/>测试01诊室<br/>准备就诊<br/>当前就诊 <br/>号别<br/>科室-诊室"                                                                                                                                          
	//q "areaid=queueinfo&areatype=queue&dataid=67708&data=20<br/>19<br/>18<br/>17<br/>16<br/>15<br/>14<br/>13<br/>12<br/>11<br/>10<br/>9<br/>8<br/>7<br/>6<br/>5<br/>4<br/>3<br/>2<br/>1<br/>4号,5号<br/>100号-当前当前就诊<br/>蒋荣蒋荣猛<br/>测试01诊室室室<br/>准备就诊<br/>当前就诊<br/>号别<br/>科室-诊室"
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=$g(^DHCVISSet("Voice","MaxshowNum"))
	i maxRow="" s maxRow=5
	//w maxRow,!
	//设置显示时间，如果XX秒后没有新数据，则不显示。
	s Time=$g(^DHCVISSet("Voice","ShowTime"))
	i Time="" s Time=3600
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)                                                                                                             
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetWaitTopStr="<br/>"
	s QueType=$P($G(^DHCVISServer(serverId)),"^",9)
	s LocId=$P($G(^DHCVISServer(serverId)),"^",8)
	//C 儿配/皮试  皮试不需要传code           IP   loc  rows  code
	i QueType="P" d
	.s RetWaitTopStr=..GetChildAndSkinWaitInfo(serverIP,LocId,12,1)
	q:QueType="P" RetWaitTopStr
	
	//C 儿输
	i QueType="E" d
	.s RetWaitTopStr=..GetErShuWaitInfo(serverIP,LocId,24,2)
	q:QueType="E" RetWaitTopStr
	
	//DEL 产房
	i QueType="DEL" d
	.s RetWaitTopStr=##class(web.DHCVISDeliveryInfo).GetDeliveryInfo(serverId)
	q:QueType="DEL" RetWaitTopStr
	
	//OPER 手术室
	i QueType="OPER" d
	.s RetWaitTopStr=##class(web.DHCVISInfoShow).NewOper()
	q:QueType="OPER" RetWaitTopStr
	
		//S 成输 皮试
	i QueType="S" d
	.s RetWaitTopStr=..GetAdultAndSkinWaitInfo(serverIP,LocId,12,2)
	q:QueType="S" RetWaitTopStr
	
	//Z 注射皮试
	i QueType="Z" d
	.s RetWaitTopStr=..GetZhuSheSkinWaitInfo(serverIP,LocId,12)
	q:QueType="Z" RetWaitTopStr
	
	
	i QueType="Pacs" d
	.s RetWaitTopStr=..GetPacsInfoByServer(serverId)
	q:QueType="Pacs" RetWaitTopStr

	//D 药房
	i QueType="D" d
	.s RetWaitTopStr=..GetDurgClientSynInfo(serverIP)
	.i $tr($p(RetWaitTopStr,"<br/>",24)," ")="" s $p(RetWaitTopStr,"<br/>",24)=""
	
	.s RetWaitTopStr=RetWaitTopStr1_RetWaitTopStr
	q:QueType="D" RetWaitTopStr
	
	s clientId=$G(^DHCTempVISL(+$H,serverId)) 
	s VisType="A"
	s num=0
	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d                                                
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.q:$P(zhContent,"*",2)=""
	.i $P(zhContent,"*",2)'="" d
	..s queueId=+$P(zhContent,"*")
	..s queueStr=$G(^DHCVISQueue(queueId))
	..q:queueStr=""
	..s VisType=$P(queueStr,"^",5)
	..s creatTime=$P(queueStr,"^",13)                                                                                                                 
	..s zhContent=$P(queueStr,"^",17)
	..s CKScreenStr=$P(queueStr,"^",18)
	..q:CKScreenStr=""  
	..s DocInfoStr=$P(queueStr,"^",22)
	..s patTip=$P(queueStr,"^",24)                                                                                                           
	..s waitList=$P(queueStr,"^",19)                                                                                                                    
	..s QueRowId=+zhContent                                                                                                                            
	..s Status=..GetAdmStatus(QueRowId)                                                                                                               
	..i (Status="过号")!(Status="退号") s zhContent=""                                                                                               
	..e  s zhContent=$P(zhContent,"*",2)
	..q:zhContent=""
	..s docUserId=$p(DocInfoStr,"!",3)
	..s docLocId=$p(DocInfoStr,"!",4)
	..i ((docLocId'="")&&(docUserId'="")) d
	...s waitList=..GetCurrentWaiter(docLocId,docUserId)
	..e  d
	...i $P(waitList,"*",2)'="" d                                                                                                                        
	....s waitList=..GetWaitList(waitList)
	....i QueType="0" s waitList="" 
	...e  s waitList="" 
	..s QueueRoomName=$P(CKScreenStr,"!",2)     //诊室名字
	..s QueueRegDocDesc=$P(CKScreenStr,"!",3)     //号别
	..s CurPatNo=$P(CKScreenStr,"!",5)
	..s CurPatName=$P(CKScreenStr,"!",6)
	..i (CurPatName'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s CurPatName=..PrivateName(CurPatName)
	..i +CurPatNo=0 s CurPat=CurPatName
	..e  s CurPat=CurPatNo_"-"_CurPatName    //当前就诊
	..i patTip'="" s CurPat=CurPat_"("_patTip_")"
	..s $P(RetWaitTopStr,"<br/>",4*(maxRow-i+1))=QueueRoomName
	..s $P(RetWaitTopStr,"<br/>",4*(maxRow-i+1)-1)=QueueRegDocDesc
	..s $P(RetWaitTopStr,"<br/>",4*(maxRow-i+1)-2)=CurPat
	..s $P(RetWaitTopStr,"<br/>",4*(maxRow-i+1)-3)=waitList
	.q:zhContent=""
	.s i=i+1
	.s ^DHCTempVISL(+$H,serverId)=clientId
	.s num=num+1
	i num'=0 d
	.s $P(RetWaitTopStr,"<br/>",(4*maxRow+1))="准备就诊"
	.s $P(RetWaitTopStr,"<br/>",(4*maxRow+2))="当前就诊"
	.s $P(RetWaitTopStr,"<br/>",(4*maxRow+3))="号别"
	.s $P(RetWaitTopStr,"<br/>",(4*maxRow+4))="科室-诊室"
	e  s $P(RetWaitTopStr,"<br/>",(4*(maxRow+1)))=""

	s clientId=$g(^DHCTempVISL(+$H,serverId))
	//判断后面是否有可用数据    liufei                                                                                                                  
	s Flag=..ScreenWaitInfoFlag(serverIP,Time)
	i Flag="N" s ^DHCTempVISL(+$H,serverId)=""
	//i $O(^DHCVISClienti(0,"ServerID",serverId,clientId))="" s ^DHCTempVISL(+$H,serverId)=""                                                                 
	s RetWaitTopStr=RetWaitTopStr1_RetWaitTopStr                                                                                                         
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请保持安静,耐心等候医生呼叫!"                                                  
	i num=0 s RetWaitTopStr=RetWaitTopStr_notifydata                                                                                                     
	i num<maxRow s ^DHCTempVISL(+$H,serverId)=""
	//s NotStr=##Class(web.DHCVISRelation).GetNoteInfobyObjectId(serverId,"S")
	s RetWaitTopStr=RetWaitTopStr  //_NotStr
	q RetWaitTopStr
}

/// liufei
/// 20160202
/// 判断诊区显示是否有可用数据
/// w ##class(web.DHCVISVoiceCall).GetScreenWaitInfoFlag("172.16.48.103")                                                                                  
ClassMethod ScreenWaitInfoFlag(serverIP As %String = "", Time As %String = "") As %String
{
    i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,"")) 
    q:serverId="" "N"
    s Flag="N"
    s clientId=$g(^DHCTempVISL(+$H,serverId))
    f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(Flag="Y"))  d                                                
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))                                                                                                     
	.q:zhContent=""                                                                                                                                                                                                                                                                               
	.i $P(zhContent,"*",2)'="" d                                                                                                                        
	..s queueId=+$P(zhContent,"*")                                                                                                                      
	..s queueStr=$G(^DHCVISQueue(queueId))                                                                                                              
	..q:queueStr=""                                                                                                                                     
	..s VisType=$P(queueStr,"^",5)                                                                                                                                                                               
	..s creatTime=$P(queueStr,"^",13)                                                                                                                   
	..i ($P($H,",",2)-creatTime-5)>Time s zhContent=""                                                                                                    
	..q:zhContent=""                                                                                                                   
	..s zhContent=$P(queueStr,"^",17)
	..s CKScreenStr=$P(queueStr,"^",18)
	..q:CKScreenStr=""                                                                                                            
	..s waitList=$P(queueStr,"^",19)                                                                                                                    
	..s QueRowId=+zhContent                                                                                                                            
	..s Status=..GetAdmStatus(QueRowId)                                                                                                                
	..i (Status="过号")!(Status="退号") s zhContent=""                                                                                               
	..e  s zhContent=$P(zhContent,"*",2)                                                                                                               
	..q:zhContent=""
	..s Flag="Y"
	..s ^DHCTempVISL(+$H,serverId)=$O(^DHCVISClienti(0,"ServerID",serverId,clientId),-1)
	q Flag
}

/// w ##class(web.DHCVISVoiceCall).GetScreenWaitInfoFC("172.16.48.103")                                                                                  
ClassMethod GetScreenWaitInfoFC(serverIP As %String = "") As %String
{
                                                                                                                                                  
	s RetWaitTopStr=""                                                                                                                                   
	s maxRow=8                                                                                                                                           
	s dataIndex=$P($H,",",2)                                                                                                                             
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)                                                                                                      
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")                                                                                          
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))                                                                                              
	q:serverId="" RetWaitTopStr                                                                                                                          
	s RetWaitTopStr1="areaid=queueinfo&areatype=queue&dataid="_dataIndex_"&data="                                                                        
	s RetWaitTopStr="<br/><br/><br/><br/><br/><br/><br/>"                                                                                                          
	s clientId=$G(^DHCTempVISL(+$H,serverId))                                                                                                               
	s VisType="A"                                                                                                                                        
	s num=0                                                                                                                                              
	s i=1                                                                                                                                                
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>(maxRow-1)))  d                                                
	.s roomDesc=$P($G(^DHCVISClient(clientId)),"^",3)
	.s WindowDesc=$P($G(^DHCVISClient(clientId)),"^",17)
	.i WindowDesc'="" s roomDesc=WindowDesc
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))                                                                                                                                                                                                                                          
	.i zhContent="" d                                                                                                                                    
	..s zhContent=roomDesc                                                                                                                                                                                                                          
	.e  d                                                                                                                                                
	..i $P(zhContent,"*",2)'="" d                                                                                                                        
	...s queueId=+$P(zhContent,"*")                                                                                                                      
	...s queueStr=$G(^DHCVISQueue(queueId))                                                                                                              
	...q:queueStr=""                                                                                                                                     
	...s VisType=$P(queueStr,"^",5)                                                        
	...s creatTime=$P(queueStr,"^",13)
	...//s roomDesc=$P(queueStr,"^",9)                                                                                                     
	...s zhContent=$P(queueStr,"^",17)                                                                                                                   
	...s waitList=$P(queueStr,"^",19)
	...s zhContent=roomDesc                                                                                                                                
	...i $P(waitList,"*",2)'="" d                                                                                                                        
	....s waitList=..GetWaitListFC(waitList)                                                                                                               
	....i waitList'="" s zhContent=zhContent_" "_waitList                                                                                              
	.q:zhContent=""                                                                                                                                      
	.s i=i+1                                                                                                                                             
	.s ^DHCTempVISL(+$H,serverId)=clientId                                                                                                                  
	.s num=num+1                                                                                                                                         
	.s $P(RetWaitTopStr,"<br/>",maxRow-num)=zhContent                                                                                                    
	s $P(RetWaitTopStr,"<br/>",maxRow)="  诊室          请以下患者到诊室门口等候"                                                                                                          
	i num=0 s ^DHCTempVISL(+$H,serverId)=""                                                                                                                 
	q:num=0 ""                                                                                                                                           
	s clientId=$g(^DHCTempVISL(+$H,serverId))                                                                     
	i $O(^DHCVISClienti(0,"ServerID",serverId,clientId))="" s ^DHCTempVISL(+$H,serverId)=""                                                                 
	s RetWaitTopStr=RetWaitTopStr1_RetWaitTopStr                                                                                                         
	s notifydata="&areaid=notify&areatype=queue&dataid="_dataIndex_"&data=请显示名字的患者到相应诊室门口等候,其他患者在诊室大厅耐心等候!"                                                  
	//i num=0 
	s RetWaitTopStr=RetWaitTopStr_notifydata                                                                                                     
	i num<5 s ^DHCTempVISL(+$H,serverId)=""                                                                                                                 
	q RetWaitTopStr
}

/// w ##class(web.DHCVISVoiceCall).GetWaitListFC("228*2,229*3,230*4,231*5")
ClassMethod GetWaitListFC(waitListStr As %String = "", QueRowId As %String = "") As %String
{
	s QueRowId=+QueRowId
	s DocDr=""
	i QueRowId>0 d
	.s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.q:QueObj=""
	.s DocDr=QueObj.QueDocDr
	s RetWaitStr=""
	q:waitListStr="" RetWaitStr
	s listLen=$L(waitListStr,",")
	s startIndex=1
	i $L(waitListStr,",")>5 s startIndex=6
	f j=startIndex:1:listLen d
	.s waitListOne=$P(waitListStr,",",j)
	.q:waitListOne=""
	.q:$P(waitListOne,"*",2)=""
	.s waitQueueId=$P(waitListOne,"*",1)
	.s Status=..GetAdmStatus(waitQueueId)
	.q:(Status="到达")!(Status="过号")!(Status="退号")
	.s QueObj=##Class(User.DHCQueue).%OpenId(waitQueueId)
	.q:QueObj=""
	.q:QueObj.QueCompDr="1"
	.q:(DocDr'="")&&(QueObj.QueDocDr'="")&&(DocDr'=QueObj.QueDocDr)
	.s QueName=QueObj.QueName
	.s QueName=$$ALPHAUP^SSUTIL4(QueName)
	.s waitQueueNo=$P(waitListOne,"*",2)
	.q:$L(RetWaitStr,",")>4
	.i RetWaitStr="" s RetWaitStr=waitQueueNo_"号"_QueName
	.e  s RetWaitStr=RetWaitStr_","_waitQueueNo_"号"_QueName
	i RetWaitStr'="" s RetWaitStr=" "_RetWaitStr
	q RetWaitStr
}

/// w ##Class(web.DHCVISVoiceCall).GetPacsInfoByServer(3)
ClassMethod GetPacsInfoByServer(serverId As %String = "") As %String
{
}

/// w ##class(web.DHCVISVoiceCall).GetDurgSynInfo("10.1.44.22")
ClassMethod GetDurgSynInfo(serverIP As %String = "") As %String
{
	//q "1,李珊    刘自喜  杨佳    刘自喜  杨佳    刘自喜&2,程杨    老丁    老张    &3,陈扬    刘非    "
	s RetStr=""
	s serverID=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverID="" RetStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverID)
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispen(serverIP)
	//下方 为 直接发药方法
	//s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispenNew(serverIP)
	s ShowMax=11
	s WindowNo=""
	f  s WindowNo=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo)) q:WindowNo=""  d
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))="" d
	..i RetStr="" s RetStr=WindowNo_", "
	..e  s RetStr=RetStr_"&"_WindowNo_", "
	.q:$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))=""
	.s CKStr=" "
	.s num=1
	.s RowID=$P($G(^DHCVISTemp(+$H,"CK",serverID,WindowNo)),",",1)
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID))="" s RowID=""
	.f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1) q:(RowID="")||(num>ShowMax)  d
	..q:+RowID=0
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag="",BillState=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...s NowDate=+$H
	...i FYFlag="1" &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	...e  d
	....s OrdId=$O(^OEORD(0,"PrescNo",PrescNo,""))
	....q:OrdId=""
	....s OrdSubId=$O(^OEORD(0,"PrescNo",PrescNo,OrdId,""))
	....q:OrdSubId=""
	....s OrderStateDr=$P($G(^OEORD(OrdId,"I",OrdSubId,1)),"^",13)
	....s BillState=$P($G(^OEORD(OrdId,"I",OrdSubId,3)),"^",5)
	....i (BillState'="P")||((OrderStateDr'=1)&&(OrderStateDr'=6)) &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..//若 结算上屏 则 PhdRow 为空
	..e  d
	...s FYFlag=2,BillState="P"
	...// 直接赋值 是否有问题？？？
	..q:((FYFlag="1")||(BillState'="P"))
	..s PrescStat=$P($G(^DHCVISDurgList(RowID)),"^",11)
	..//q:PrescStat'="S"
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..i CKStr=" " s CKStr=PatName
	..e  d
	...i CKStr'[PatName d
	....s CKStr=CKStr_PatName
	....s num=num+1
	.//i $P($H,",",2)>82800 s CKStr=" "
	.i CKStr'="" d
	..//i $L(CKStr)<8 s CKStr=$TR(CKStr," ")
	..i RetStr="" s RetStr=WindowNo_","_CKStr
	..e  s RetStr=RetStr_"&"_WindowNo_","_CKStr
	.s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1)
	.i num>ShowMax s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=RowID
	.e  s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=""
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).GetDurgClientSynInfo("XIYUAN-YAOFANG")
ClassMethod GetDurgClientSynInfo(serverIP As %String = "") As %String
{
	s RetStr="",CKStr=""
	s serverID=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverID="" RetStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverID)
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispen(serverIP)
	// 收费上屏
	//s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispenNew(serverIP)
	s ShowMax=24
	s WindowNo=""
	f  s WindowNo=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo)) q:WindowNo=""  d
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))="" d
	..//i RetStr="" s RetStr=WindowNo_", "
	..//e  s RetStr=RetStr_"&"_WindowNo_", "
	.q:$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))=""
	.s CKStr=""
	.s num=1
	.s RowID=$P($G(^DHCVISTemp(+$H,"CK",serverID,WindowNo)),",",1)
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID))="" s RowID=""
	.f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1) q:(RowID="")||(num>ShowMax)  d
	..q:+RowID=0
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag="",BillState=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...s NowDate=+$H
	...i FYFlag="1" &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	...e  d
	....s OrdId=$O(^OEORD(0,"PrescNo",PrescNo,""))
	....q:OrdId=""
	....s OrdSubId=$O(^OEORD(0,"PrescNo",PrescNo,OrdId,""))
	....q:OrdSubId=""
	....s OrderStateDr=$P($G(^OEORD(OrdId,"I",OrdSubId,1)),"^",13)
	....s BillState=$P($G(^OEORD(OrdId,"I",OrdSubId,3)),"^",5)
	....i (BillState'="P")||((OrderStateDr'=1)&&(OrderStateDr'=6)) &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..q:((FYFlag="1")||(BillState'="P"))
	..s PrescStat=$P($G(^DHCVISDurgList(RowID)),"^",11)
	..//q:PrescStat'="S"
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..//i $L(PatName)>4 s PatName=$E(PatName,1,5)
	..//e  s PatName=PatName
	..i CKStr="" s $p(CKStr,"<br/>",ShowMax)=PatName
	..e  d
	...i CKStr'[PatName d
	....s $p(CKStr,"<br/>",ShowMax-num)=PatName
	....s num=num+1
	.//i $P($H,",",2)>82800 s CKStr=" "
	.//i CKStr'="" d
	..//i $L(CKStr)<8 s CKStr=$TR(CKStr," ")
	..//i RetStr="" s RetStr=WindowNo_","_CKStr
	..//e  s RetStr=RetStr_"&"_WindowNo_","_CKStr
	.s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1)
	.i num>ShowMax s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=RowID
	.e  s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=""
	s RetStr=CKStr
	s $p(RetStr,"<br/>",ShowMax+1)="",$p(RetStr,"<br/>",ShowMax+2)="",$p(RetStr,"<br/>",ShowMax+3)=""
	s $p(RetStr,"<br/>",ShowMax+4)="请以下患者到该窗口取药" 
	q RetStr
}

/// 取分诊过的病人信息
/// w ##class(web.DHCVISVoiceCall).GetPartWaitInfo("172.16.21.64")
ClassMethod GetPartWaitInfo(serverIP As %String = "") As %String
{
	s RetPartStr=""
	s maxRow=6
	s dataIndex=$P($H,",",2)
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetPartStr
	s QueExaBor=$P($G(^DHCVISServer(serverId)),"^",7)
	s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	q:QueExaBor="" RetPartStr
	s RetPartStrHead="areaid=partinfo&areatype=queue&dataid="_dataIndex_"&data="
	s QueId=$P($G(^DHCTempVISL(+$H,"Part",serverId)),",",1)
	s QueMarkDr=$P($G(^DHCTempVISL(+$H,"Part",serverId)),",",2)
	i QueMarkDr'="" s QueMarkDr=QueMarkDr
	s num=0
	s i=1
	s QueueDate=+$H
	s QueStateDr=2
	f  s QueMarkDr=$O(^User.DHCQueueI("QueComDate",QueueDate,QueExaBor,QueMarkDr)) q:((QueMarkDr="")||(i>maxRow))  d
	.f  s QueId=$O(^User.DHCQueueI("QueComDate",QueueDate,QueExaBor,QueMarkDr,QueStateDr,QueId)) q:((QueId="")||(i>maxRow))  d
	..s oref=##Class(User.DHCQueue).%OpenId(QueId)
	..s DocDr=oref.QueDocDr
	..s QueCompDr=oref.QueCompDr
	..s QueCompDr=$$ALPHAUP^SSUTIL4(QueCompDr)
	..s patName=oref.QueName
	..s SeqNo=oref.QueNo
	..i QueMarkDr'="" d
	...s QueMarkDr1=QueMarkDr
	...i $P(QueMarkDr," ",2)'="" s QueMarkDr1=$P(QueMarkDr," ",2)
	...s MarkName=$P($g(^CTPCP(+QueMarkDr1,1)),"^",2)
	..q:$G(MarkName)=""
	..i MarkName'="" s MarkName=$P(MarkName,"(")
	..i $P(MarkName,"门诊",2)'="" s MarkName=$P(MarkName,"门诊",2)
    ..d oref.%Close()
    ..q:DocDr=""
    ..s CllentInfoID=$O(^DHCVISClientInfoi(0,"DocDr",DocDr,""))
    ..q:CllentInfoID=""
    ..s ClientIP=$P($G(^DHCVISClientInfo(CllentInfoID)),"^",1)
    ..q:ClientIP=""
    ..s VoiceClientId=$O(^DHCVISClienti(0,"ClientIP",ClientIP,""))
    ..q:VoiceClientId=""
    ..s Room=$P($G(^DHCVISClient(VoiceClientId)),"^",3)
	..q:((DocDr="")||(Room=""))
	..q:((QueCompDr=1)||(QueCompDr=2))
	..s ShowStr=MarkName_":"_SeqNo_"号-->"_Room
	..i RetPartStr="" s RetPartStr=ShowStr
	..e  s RetPartStr=RetPartStr_" "_ShowStr
	..s i=i+1
	..s ^DHCTempVISL(+$H,"Part",serverId)=QueId_","_QueMarkDr
	..
	i (RetPartStr="")||(i<5) s ^DHCTempVISL(+$H,"Part",serverId)=""
	//q:RetPartStr="" RetPartStr
	i RetPartStr="" s RetPartStr="请保持安静,耐心等候医生呼叫!"
	q RetPartStrHead_RetPartStr
}

/// w ##class(web.DHCVISVoiceCall).GetScreenHP("172.24.2.35")
ClassMethod GetScreenHP(serverIP As %String = "", room As %String = "", nowQueueId As %String = "") As %String
{
	s RetStr=""
	i room'="" s clientId=""
	i +room<6 s clientId=""
	i (+room>5)&&(+room<11) d
	.s roomDesc="05诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	i (+room>10)&&(+room<16) d
	.s roomDesc="10诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	i +room>16 d
	.s roomDesc="15诊室"
	.s clientId=..GetClientByName(serverIP,roomDesc)
	s maxRow=5
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" RetStr
	s TopIPStr=$P($G(^DHCVISServer(serverId)),"^",13)
	q:TopIPStr="" RetStr
	i nowQueueId'="" d
	.s queueStr=$G(^DHCVISQueue(nowQueueId))
	.q:queueStr=""
	.s ckContent=$P(queueStr,"^",18)
	.q:ckContent=""
	.s clinic=$P(ckContent,"!",2)
	.s departments=$P(ckContent,"!",1)
	.s doctors=$P(ckContent,"!",3)
	.s title=$P(ckContent,"!",4)
	.s no=$P(ckContent,"!",6)
	.s attenders=$P(ckContent,"!",5)
	.s waitList=$P(queueStr,"^",19)
	.s waitno=..GetWaitList(waitList)
	.s waitno=$TR(waitno," ")
	.s type="<type>0</type>"
	.s status="<status>now</status>"
	.s clinic="<clinic>"_clinic_"</clinic>"
	.s departments="<departments>"_departments_"</departments>"
	.s doctors="<doctors>"_doctors_"</doctors>"
	.s title="<title>"_title_"</title>"
	.s no="<no>"_no_"</no>"
	.s attenders="<attenders>"_attenders_"</attenders>"
	.s waitno="<waitno>"_waitno_"</waitno>"
	.s RetStr="<Row>"_type_status_clinic_departments_doctors_title_no_attenders_waitno_"</Row>"
	
	i room="" s clientId=$G(^DHCTempVISHP(+$H,serverId))
	s i=1
	f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:((clientId="")||(i>maxRow))  d
	.s (type,status,clinic,departments,doctors,title,no,attenders,waitno)=""
	.s zhContent=$G(^DHCTempVIS(+$H,serverId,clientId))
	.q:zhContent=""
	.q:$P(zhContent,"*",2)=""
	.s queueId=+$P(zhContent,"*")
	.s Status=..GetAdmStatus(queueId)
	.q:Status="退号"
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s creatTime=$P(queueStr,"^",13)
	.q:($P($H,",",2)-creatTime)>1500
	.s zhContent=$P(queueStr,"^",17)
	.s zhContent=$P(zhContent,"*",2)
	.q:zhContent=""
	.s ckContent=$P(queueStr,"^",18)
	.q:ckContent=""
	.s clinic=$P(ckContent,"!",2)
	.s departments=$P(ckContent,"!",1)
	.s doctors=$P(ckContent,"!",3)
	.s title=$P(ckContent,"!",4)
	.s no=$P(ckContent,"!",6)
	.s attenders=$P(ckContent,"!",5)
	.s waitList=$P(queueStr,"^",19)
	.s waitno=..GetWaitList(waitList)
	.s waitno=$TR(waitno," ")
	.s type="<type>0</type>"
	.s status="<status>wait</status>"
	.s clinic="<clinic>"_clinic_"</clinic>"
	.s departments="<departments>"_departments_"</departments>"
	.s doctors="<doctors>"_doctors_"</doctors>"
	.s title="<title>"_title_"</title>"
	.s no="<no>"_no_"</no>"
	.s attenders="<attenders>"_attenders_"</attenders>"
	.s waitno="<waitno>"_waitno_"</waitno>"
	.s zhContent="<Row>"_type_status_clinic_departments_doctors_title_no_attenders_waitno_"</Row>"
	.s i=i+1
	.s RetStr=RetStr_zhContent
	.s ^DHCTempVISHP(+$H,serverId)=clientId
	i RetStr="" s ^DHCTempVISHP(+$H,serverId)=""
	q:RetStr="" RetStr
	i RetStr'="" s RetStr="<?xml version=""1.0"" encoding=""utf-8""?><Data PassWord=""ebanswers"">"_RetStr_"</Data>"
	i i<5 s ^DHCTempVISHP(+$H,serverId)=""
	i RetStr'="" s RetStr=TopIPStr_"*"_RetStr
	q RetStr
}

ClassMethod CanceledVoiceState(queueId As %String = "") As %String
{
	&SQL(update DHC_VIS_VoiceQueue set VIS_ShowState='N' where VIS_QueueID=:queueId)
	q 0
}

///  w ##class(web.DHCVISVoiceCall).GetVoiceQueueBak("PC-20121007CRES")
ClassMethod GetVoiceQueueBak(serverIP) As %String
{
	s retStr=""
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	//i $G(serverIP)="" s serverIP=%session.Data("REMOTE_ADDR")
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" retStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverId)
	s num=0
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"DateServerState",nowDate,serverId,"N",queueId)) q:(queueId="")||(num>0)  d
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s clientId=$P(queueStr,"^",1)
	.s queueNo=$P(queueStr,"^",3)
	.s content=$P(queueStr,"^",4)
	.i $P(content,"门诊",2)'="" s content=$P(content,"门诊",1)_$P(content,"门诊",2)
	.s type=$P(queueStr,"^",5)
	.s sound=$P(queueStr,"^",6)
	.s repeat=$P(queueStr,"^",7)
	.s zhContent=$P(queueStr,"^",17)
	.s ckContent=$P(queueStr,"^",18)
	.s waitList=$P(queueStr,"^",19)
	.s note=$P(queueStr,"^",20)
	.s ckScreenStr=""
	.s ckTopStr=""
	.s locTopStr=""
	.s zhTopStr=""
	.i $P(zhContent,"*",2)'="" d
	..s QueRowId=+zhContent
	..s zhContent=$P(zhContent,"*",2)
	.i $P(waitList,"*",2)'="" d
	..s waitList=..GetWaitList(waitList)
	..i waitList'="" s zhContent=zhContent_waitList
	.s regDocDesc=$p(zhContent,"*",2)
	.s ^DHCTempVIS(+$H,serverId,clientId)=queueId_"*"_zhContent
	.i clientId'="" d 
	..s clientName=$P($G(^DHCVISClient(clientId)),"^",3)
	..s comPort=+$P($G(^DHCVISClient(clientId)),"^",4)
	..//i comPort=0 s comPort=1
	..s ledNum=+$P($G(^DHCVISClient(clientId)),"^",5)
	..//i ledNum=0 s ledNum=1
	..s ledColorNo=+$P($G(^DHCVISClient(clientId)),"^",6)
	..i ledColorNo=0 s ledColorNo=17
	..s ledShowMode=+$P($G(^DHCVISClient(clientId)),"^",7)
	..i ledShowMode=0 s ledShowMode=0
	..s ledShowSpeed=+$P($G(^DHCVISClient(clientId)),"^",8)
	..i ledShowSpeed=0 s ledShowSpeed=0
	..s ledShowTime=+$P($G(^DHCVISClient(clientId)),"^",9)
	..i ledShowTime=0 s ledShowTime=0
	..s clientIP=$P($G(^DHCVISClient(clientId)),"^",2)
	..s shareFlag=$P($G(^DHCVISClient(clientId)),"^",12)
	..s ClientTopIP=$P($G(^DHCVISClient(clientId)),"^",16)
	..s ClientTopDesc=$P($G(^DHCVISClient(clientId)),"^",17)
	..s LocTopIP=$P($G(^DHCVISClient(clientId)),"^",18)
	..s LocTopDesc=$P($G(^DHCVISClient(clientId)),"^",19)
	.e  d
	..s clientName=$P(queueStr,"^",9)
	..s comPort=0
	..s ledNum=0
	..s ledColorNo=0
	..s ledShowMode=0
	..s ledShowSpeed=0
	..s ledShowTime=0
	..s clientIP=""
	..s ClientTopIP=""
	..s ClientTopDesc=""
	..s LocTopIP=""
	..s LocTopDesc=""
	.i serverId'=""  d
	..s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
	..s serverComPort=+$P($G(^DHCVISServer(serverId)),"^",4)
	..//i serverComPort=0 s serverComPort=1
	..s serverLedNum=+$P($G(^DHCVISServer(serverId)),"^",5)
	..//i serverLedNum=0 s serverLedNum=1
	..s serverLedColorNo=+$P($G(^DHCVISServer(serverId)),"^",6)
	..//i serverLedColorNo=0 s serverLedColorNo=17
	..s ServerTopIP=$P($G(^DHCVISServer(serverId)),"^",13)
	..s ServerTopDesc=$P($G(^DHCVISServer(serverId)),"^",14)
	.e  d
	..s serverName=$P(queueStr,"^",10)
	..s serverComPort=0
	..s serverLedNum=0
	..s serverLedColorNo=0
	..s ServerTopIP=""
	..s ServerTopDesc=""
	.i queueNo#2=0  d
	..s serverLedColorNo=serverLedColorNo+17
	..i serverLedColorNo>51 s serverLedColorNo=serverLedColorNo-34
	.q:(type="")!(content="")!(clientName="")!(serverName="")
	.s ledScreenStr=content
	.s typeDesc=""
	.i type="B" d     //门诊护士采血
	..s typeDesc="采血"
	..s ledScreenStr=content
	.i type="D" d     //门诊摆药 Durg
	..s typeDesc="取药"
	..s screenStr=clientName_":"_$P(content," ",2)_$P(content," ",3)_"候药"
	..s space=""
	..i $L($P(content," ",1))=2 s space="     "
	..i $L($P(content," ",1))=3 s space="   "
	..i $L($P(content," ",1))=4 s space=""
	..s ledScreenStr=clientName_":"_$P(content," ",1)_"取药"_space_$P(content," ",2)_"  "_$P(content," ",3)_"候药"
	..s content=$P(content," ")
	.i type="P" d 
	..s typeDesc="检查"
	..s screenStr=content
	..s soundContent=content
	.s soundContent=content_"请到"_clientName_typeDesc_" "_content_"请到"_clientName_typeDesc
	.i $G(screenStr)="" s screenStr=content  //queueNo_"."_content           //LED 显示模式
	.i (type="T")||(type="R")||(type="P") d
	..s screenStr=""
	..s soundContent=..FormatSound(content_" "_content)
	.i type="D" d
	..s soundContent=content
	..//i $P(soundContent,"06",2)'="" s soundContent=$P(soundContent,"06",1)_"<silence msec='100'/>06"_$P(soundContent,"06",2)
	..s serverComPort=0
	..//i $P(ckContent,"中药房",2)'="" s ckContent=$P(ckContent,"中药房",2)
	..s ledNum=+$P(ckContent,",")
	..i ledNum=0 s ledNum=1
	..//s InsertFlag=..InsertLedInfo(ckContent)
	..//i InsertFlag<0 s ^DHCVISLedLog(queueId)=ckContent_"错误:"_InsertFlag
	..////插入药房大屏滚动信息
	..s PrescNo=$P(ckContent,",",4)
	..s UpdateFlag=..UpdatePrescState(PrescNo,"S")
	..i UpdateFlag<0 s ^DHCVISLedLog(queueId)=$G(^DHCVISLedLog(queueId))_ckContent_"错误:"_UpdateFlag
	..s screenStr=$P(ckContent,",",2)
	..//s ckContent="请"_$P(ckContent,",",2)_"取药"
	..i ClientTopIP'="" s ckTopStr=..GetDurgCKTopStr(ClientTopIP,content)
	..e  s ckTopStr=""
	..s contentStr=sound_"!"_repeat_"!"_soundContent
	..i ckContent'="" s ledScreenStr=$P(ckContent,",",2)
	..s ledScreenStr=ledScreenStr_"!"_comPort_"!"_ledNum_"!"_ledColorNo_"!"_ledShowMode_"!"_ledShowSpeed_"!"_ledShowTime
	..s synScreen=""
	..s ckScreenStr=ckContent
	.///门诊医生叫号
	.i type="A" d
	..//s content=$TR(content,"医疗单元")
	..s soundContent=""
	..s screenStr=""
	..s serverLedColorNo=17
	..s soundContent=..FormatSound(content)
	..i $P(content,",",2)'="" s soundContent=..FormatSound($P(content,",",2))
	..s zkContent=content
	..s ckContent=content
	..i $P(content,",",2)'="" d
	...s ckContent=$P(content,",",1)
	...s zkContent=$P(content,",",2)
	..i ClientTopIP'="" s ckTopStr=..GetWindowTopStr(ClientTopIP,ckContent)
	..e  d
	...i clientIP'="" s ckScreenStr=clientIP_"!"_ckContent
	..i LocTopIP'="" s locTopStr=..GetZHWindowTopStr(LocTopIP,zkContent)
	..i (ckTopStr'="")&&(locTopStr'="") s ckTopStr=ckTopStr_"#"_locTopStr
	..//i (LocTopIP'="")&&(ServerTopIP'="") s ServerTopIP=ServerTopIP_","_LocTopIP
	..//i (LocTopIP'="")&&(ServerTopIP="") s ServerTopIP=LocTopIP
	..i ServerTopIP'="" s zhTopStr=..GetZHWindowTopStr(ServerTopIP,zkContent)
	..//i ServerTopIP'="" s zhTopStr=..GetScreenHP(serverIP,clientName,queueId)   //秦皇岛HP接口
	.i (content'="")&&(screenStr="") s screenStr=content
	.i (ckContent'="")&&(type'="D") s ledScreenStr=$P(ckContent,"!",5)
	.s screenParm=serverComPort_"!"_serverLedNum_"!"_serverLedColorNo
	.s contentStr=sound_"!"_repeat_"!"_soundContent
	.s screenStr=screenStr_"!"_screenParm
	.i $L(ledScreenStr,"!")>2 s ledScreenStr=""
	.e  s ledScreenStr=ledScreenStr_"!"_comPort_"!"_ledNum_"!"_ledColorNo_"!"_ledShowMode_"!"_ledShowSpeed_"!"_ledShowTime
	.i ckTopStr'="" s ledScreenStr=""
	.s synScreen=note
	.d ..UpdateVoiceQueue(queueId,clientId,serverId,soundContent)
	.s waitList=""
	.s retStr=contentStr_"^"_screenStr_"^"_ledScreenStr_"^"_ckScreenStr_"^"_synScreen_"^"_waitList_"^"_ckTopStr_"^"_zhTopStr
	.//e  s retStr=retStr_contentStr_"^"_screenStr_"^"_ledScreenStr_"^"_ckScreenStr_"^"_synScreen_"^"_waitList_"^"_ckTopStr_"^"_zhTopStr
	.s num=num+1
	.s ^DHCTempDHCVIS(+$H,serverId,clientId)=$H_"*"_zhContent
	q retStr
}

///  w ##class(web.DHCVISVoiceCall).PrivateName("发奋发顺")
ClassMethod PrivateName(patName As %String = "") As %String
{
	s name=""
	s patName=$$ALPHAUP^SSUTIL4(patName)
	s patName=$TR(patName,$C(0,10,13))
	s patName=$TR(patName,"0123456789")
	i $l(patName)=2 s name=$E(patName,1)_"＊"_$E(patName,2)
	i $l(patName)=3 s name=$E(patName,1)_"＊"_$E(patName,3)
	i $l(patName)>3 s name=$E(patName,1,2)_"＊"_$E(patName,4,10)
	q name
}

/// 入参：就诊号  
/// w ##class(web.DHCVISVoiceCall).GetCalledTime(603)
ClassMethod GetCalledTime(EpisodeID As %String = "") As %String
{
	s callTime="",nowDate=+$h,num=0,QueRowid=""
	q:EpisodeID="" callTime
	s QueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	q:QueRowid="" callTime
	s queueId=""
	f  s queueId=$O(^DHCVISQueuei(0,"CreateDate",nowDate,queueId)) q:(queueId="")||(num>0)  d
	.s queueStr=$G(^DHCVISQueue(queueId))
	.q:queueStr=""
	.s showState=$P(queueStr,"^",21)
	.q:showState="N"
	.s zhContent=$P(queueStr,"^",17)
	.w queueId_"   "_QueRowid_"   "_zhContent,!
	.q:QueRowid'=+zhContent
	.s num=num+1
	.s callTime=$P(queueStr,"^",16)
	q callTime
}

/// /W ##Class(web.DHCVISQueueManage).GetCurrentWaiter(261,2735)
ClassMethod GetCurrentWaiter(LocID As %String = "", UserID As %String = "", IPAddress As %String = "", AllPatient As %String = "", PatientNo As %String = "", SurName As %String = "", StartDate As %Date = "", EndDate As %Date = "", ArrivedQue As %String = "", RegQue As %String = "") As %String
{
	s IPAddress="",AllPatient="",PatientNo="",SurName="",ArrivedQue=""
    s StartDate=$P($h,",")
    s EndDate=$P($h,",")
    s RegQue="on"
    s Consultation="on"
    s waitIndex=0
    s waitStr="",waiter=""
    s waitPersons=+$G(^DHCVISSet("DHCVISWaiting"))
    s rs=##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	i rs.QueryIsValid() {
		Set Status=rs.Execute(LocID,UserID,IPAddress,AllPatient,PatientNo,SurName,StartDate,EndDate,ArrivedQue,RegQue)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s walkStatus=rs.GetData(30) 
			s docArrive=rs.GetData(12)
			q:(walkStatus'="等候")&&(walkStatus'="回诊")&&(walkStatus'="复诊")&&(walkStatus'="续诊")
			s calledFlag=rs.GetData(37)
			i calledFlag=1 continue
			i waitIndex<waitPersons d
			.s EpisodeID=rs.GetData(2)
			.s patName=rs.GetData(5)
			.s patRegNo=rs.GetData(4)       
			.s PAAdmDepCodeDR=rs.GetData(11)
			.i $P(PAAdmDepCodeDR,"-",2)'="" s PAAdmDepCodeDR=$P(PAAdmDepCodeDR,"-",2)
			.s PAAdmDepCodeDR=$P(PAAdmDepCodeDR,"门诊",1)_$P(PAAdmDepCodeDR,"门诊",2)
			.s locSeqNo=rs.GetData(28)        
			.i +locSeqNo=0 s waiter=patName
			.e  s waiter=locSeqNo_"号"_patName
			.s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
			.q:QueRowId=""
			.i waitStr=""  s waitStr=waiter
			.e  s waitStr=waitStr_","_waiter
			.s waitIndex=waitIndex+1	
		}
     }
     q waitStr
}

/// w ##class(web.DHCVISVoiceCall).GetDurgSynInfoSG("192.168.19.120")
ClassMethod GetDurgSynInfoSG(serverIP As %String = "") As %String
{
	//这里如果不为3个姓名,则增加空格补齐
	//q "1,李珊    刘自喜  杨佳    &2,程杨    老丁    老张    &3,陈扬    刘非    "
	s RetStr=""
	s serverID=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverID="" RetStr
	s nowDate=+$H,nowTime=$P($H,",",2)
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime where VIS_ServerID=:serverID)
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s AutoSynPh=##Class(web.DHCVISPharmacy).SynPhDispen(serverIP)
	s ShowMax=20
	s WindowNo=""
	f  s WindowNo=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo)) q:WindowNo=""  d
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))="" d
	..i RetStr="" s RetStr=WindowNo_", "
	..e  s RetStr=RetStr_"&"_WindowNo_", "
	.q:$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",""))=""
	.s CKStr=" "
	.s num=1
	.s RowID=$P($G(^DHCVISTemp(+$H,"CK",serverID,WindowNo)),",",1)
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID))="" s RowID=""
	.//f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1) q:(RowID="")  d
	.f  s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1) q:(RowID="")||(num>ShowMax)  d
	..q:+RowID=0
	..s PrescNo=$P($G(^DHCVISDurgList(RowID)),"^",1)
	..q:PrescNo=""
	..s FYFlag="",BillState=""
	..s PhdRow=$O(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	..i PhdRow'="" d
	...s FYFlag=$p($G(^DHCPHDISP(PhdRow)),"^",4)
	...s NowDate=+$H
	...//i FYFlag="1" &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	...e  d
	....s OrdId=$O(^OEORD(0,"PrescNo",PrescNo,""))
	....q:OrdId=""
	....s OrdSubId=$O(^OEORD(0,"PrescNo",PrescNo,OrdId,""))
	....//b ;003
	....q:OrdSubId=""
	....s OrderStateDr=$P($G(^OEORD(OrdId,"I",OrdSubId,1)),"^",13)
	....s BillState=$P($G(^OEORD(OrdId,"I",OrdSubId,3)),"^",5)
	....i (BillState'="P")||((OrderStateDr'=1)&&(OrderStateDr'=6)) &SQL(Update DHC_VIS_DurgLedList set ActiveFlag='N' where InsertDate=:NowDate and PrescNo=:PrescNo)
	..//q:((FYFlag="1")||(BillState'="P"))
	..s PrescStat=$P($G(^DHCVISDurgList(RowID)),"^",11)
	..s PatName=$P($G(^DHCVISDurgList(RowID)),"^",3)
	..s PatName=$tr(PatName," ")
	..i $L(PatName)>4 s PatName=$E(PatName,1,4)
	..i $L(PatName)=2 s PatName=PatName_"    "
	..i $L(PatName)=3 s PatName=PatName_"  "
	..//b //此处增加空格对其不管用
	..i CKStr=" " s CKStr="︱"_PatName
	..e  d
	...i CKStr'[PatName d
	....//s CKStr=CKStr_"!"_PatName
	....//s num=num+1
	....//s CKStr=CKStr_"!"_PatName
	
	....i num#3'=0 s CKStr=CKStr_"!"_PatName
	....e  s CKStr=CKStr_"#︱"_PatName
	....s num=num+1
	....//b //w num,!
	.i $tr(CKStr,"!#")'="" d
	..b //123
	..s CKStrLenJ=$l(CKStr,"#")
	..s CKStrLast=$p(CKStr,"#",CKStrLenJ)
	..i $l(CKStrLast,"!")'=3 d
	...b ///!不够
	...s CKStrMaxRowJ=3
	...s CKStrLenJ=$l(CKStrLast,"!")
	...f j=1:1:(CKStrMaxRowJ-CKStrLenJ) d
	....s CKStr=CKStr_"!        "
	.i $tr(CKStr,"!#")'="" d
	..b //456
	..s CKStrLenK=$l(CKStr,"#")
	..i CKStrLenK'=7 d
	...s CKStrMaxRowJ=7
	...f k=1:1:(CKStrMaxRowJ-CKStrLenK) d
	....s CKStr=CKStr_"#︱        !        !        "
	.b //CKStrEnd
	.i CKStr'="" d
	..//i $L(CKStr)<8 s CKStr=$TR(CKStr," ")
	..i RetStr="" s RetStr=WindowNo_","_CKStr
	..e  s RetStr=RetStr_"&"_WindowNo_","_CKStr
	..//w "1RowID "_RowID,!
	..//b //1
	.//s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1)
	.s RowID=$O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID))
	.i num>ShowMax s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=RowID
	.//e  s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=""
	.//w "2RowID "_RowID,!
	.i $O(^DHCVISDurgListi(0,"ServerWindowNo",+$H,serverID,WindowNo,"Y",RowID),-1)="" s ^DHCVISTemp(+$H,"CK",serverID,WindowNo)=""
	//是否再次去除"!"分隔符
	s RetStr=$tr(RetStr,"!")
	//所有药房都出现在返回值中，同时若有空，补齐
	//s MaxRowEnd=5
	//s RetStrEndLen=$l(RetStr,"&")
	//i RetStrEndLen'=5 d
	.//f Endi=1:1:(5-RetStrEndLen) d
	b //RetStr
	s RetStr=..FotmatDurgRetStr(RetStr)
	b //RetStrChange
	//s RetStr="1,&2,&3,&4,&5,"
	q RetStr
}

/// w ##class(web.DHCVISVoiceCall).FotmatDurgRetStr("")
ClassMethod FotmatDurgRetStr(Txt As %String = "") As %String
{
	//仅有一个窗口的时候不存在 "&"
	s RetStr=""
	s TxtSure=$tr(Txt," ")
	s DurgStr1="1,",DurgStr2="2,",DurgStr3="3,",DurgStr4="4,",DurgStr5="5,"
	i TxtSure="" s RetStr="1,&2,&3,&4,&5,"
	e  d
	.//马丹，直接从分解再拼一个！
	.s TxtLen=$l(Txt,"&")
	.i TxtLen=1 d 
	..s WindowNo=+Txt
	..i WindowNo=1 s DurgStr1=Txt
	..i WindowNo=2 s DurgStr2=Txt
	..i WindowNo=3 s DurgStr3=Txt
	..i WindowNo=4 s DurgStr4=Txt
	..i WindowNo=5 s DurgStr5=Txt
	.e  d
	..f TxtI=1:1:TxtLen d
	...s TxtPart=$p(Txt,"&",TxtI)
	...s WindowNoPart=+TxtPart
	...i WindowNoPart=1 s DurgStr1=TxtPart
	...i WindowNoPart=2 s DurgStr2=TxtPart
	...i WindowNoPart=3 s DurgStr3=TxtPart
	...i WindowNoPart=4 s DurgStr4=TxtPart
	...i WindowNoPart=5 s DurgStr5=TxtPart
	s RetStr=DurgStr1_"&"_DurgStr2_"&"_DurgStr3_"&"_DurgStr4_"&"_DurgStr5
	//s RetStr=Txt
	q RetStr
}

/// W ##Class(web.DHCVISVoiceCall).PatInfoRrivatForVB("请 3号 吉书春 到 第35诊室2 就诊!0!0!17")
ClassMethod PatInfoRrivatForVB(PatInfoStr As %String = "") As %String
{
	s RetStr=""
	s PatInfoStr=$p(PatInfoStr,"!")
	s $p(PatInfoStr," ",3)=..PrivateName($p(PatInfoStr," ",3))
	s PatNo=$p(PatInfoStr," ",2)
	s PatName=$p(PatInfoStr," ",3)
	i (PatName'="")&&(+$g(^DHCVISSet("NamePrivacy"))=1) s PatName=..PrivateName(PatName)
	s NotifyStr=$tr(PatInfoStr," ")
	s RetStr=PatNo_"^"_PatName_"^"_NotifyStr
	q RetStr
}

/// w ##Class(web.DHCVISVoiceCall).GetTxtNameByServer("192.168.19.116")
ClassMethod GetTxtNameByServer(ServerIP As %String = "") As %String
{
	//直接在备注加入路径选择
	s serverId=$o(^DHCVISServeri(0,"ServerIP",ServerIP,""))
	q:serverId="" ""
	s TxtName=$p(^DHCVISServer(serverId),"^",9)
	q:TxtName="" 6666
	q TxtName
}

/// w ##Class(web.DHCVISVoiceCall).GetServerMarkWaitInfo("10.1.30.162")
ClassMethod GetServerMarkWaitInfo(serverIP As %String = "") As %String
{
	s dataIndex=$P($H,",",2)
	s max=10,t=1
	s colorStr="0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff<br/>0xffffffff"
	s RetString="areaid=waitinfo&areatype=queue&dataid="_dataIndex_"&data="
	s RetWaitStr="<br/><br/><br/><br/><br/><br/><br/><br/><br/>"
	q:serverIP="" RetString_RetWaitStr
	
	s docStr=""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId="" ""
	s BorId=$P($G(^DHCVISServer(serverId)),"^",7)
	q:BorId="" RetString_RetWaitStr
	k ^DHCVISBorTemp(+$h,serverIP)
	s BorMarkId=""  //诊区号别
	f  s BorMarkId=$o(^User.DHCDepMarkI("DepmBorDrIndex",BorId,BorMarkId))  q:(BorMarkId="")  d	
    .s si=$List(^User.DHCDepMarkD(BorMarkId),5)
    .s depStat=$List(^User.DHCDepMarkD(BorMarkId),6)
    .q:((si="N")||(depStat'=1))  ;非当前、可用的不统计
    .s depDr=$List(^User.DHCDepMarkD(BorMarkId),8)  ;科室
	.s markDr=$List(^User.DHCDepMarkD(BorMarkId),3)  ;号别
	.q:(markDr="")||(depDr="")
	.s:markDr'="" markDesc=$P($G(^CTPCP(markDr,1)),"^",2)
    .s depSub =""_depDr
	.s patInfo=""
    .s QueRowId=0
	.f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,depSub,QueRowId))  q:QueRowId=""  d
    ..q:$ListLength(^User.DHCQueueD(QueRowId))<1
    ..s markId=$List(^User.DHCQueueD(QueRowId),8)  
    ..s docDr=$List(^User.DHCQueueD(QueRowId),5) 
    ..s patStateDr=$List(^User.DHCQueueD(QueRowId),14)
    ..s patNumber=$List(^User.DHCQueueD(QueRowId),10) 
    ..q:patNumber=""
    ..q:(patStateDr'=1)&&(patStateDr'=2)&&(patStateDr'=3)&&(patStateDr'=7) // 1回诊 2等候 3过号 7未报到
    ..q:markDr'=markId
    ..w "markDr:",markDr,!
    ..q:($o(^SSU("SSUSR",0,"CTPCP",markId,""))="")&&(docDr="") // 专科号未指定医生
    ..i $o(^SSU("SSUSR",0,"CTPCP",markId,""))=""  s markId=docDr
    ..i (docDr'="")&&(docDr'=markId) s markId=docDr  //专家号 指定医生
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",markId,""))
	..s ^DHCVISBorTemp(+$h,serverIP,UserID)=depDr_"!"_UserID //_"!"_markId

	s AllPatient="",PatientNo="",SurName="",ArrivedQue=""
	s markNum=1
	i $d(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP))=0{
	s UserID=$g(^DHCVISBorTempIndex(+$h,serverIP))
	i $O(^DHCVISBorTemp(+$h,serverIP,UserID))="" s UserID=""
	f  s UserID=$O(^DHCVISBorTemp(+$h,serverIP,UserID)) q:(UserID="")||(markNum>1)  d
	.s LocID=$p(^DHCVISBorTemp(+$h,serverIP,UserID),"!")
	.s ^DHCVISBorTempPage(+$h,serverIP)=0
	.d ##class(%ResultSet).RunQuery("web.DHCDocOutPatientList","FindLocDocCurrentAdm",LocID,UserID,serverIP,AllPatient,PatientNo,SurName,nowDate,nowDate,ArrivedQue,"on")
	.s markNum=markNum+1
	}
	s maxShow=9,T=0
	s User="",patFirStr="",patStr="",typeFlag=0,pageNum=0
	f  s User=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User)) q:User=""  d
	.s Callindexnow=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,""))
	.s LocDr=$p(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,Callindexnow),"^",8)
	.s docDr=##Class(web.SSUser).GetDefaultCareProvider(User)
	.i docDr'="" s docDesc=$P($G(^CTPCP(docDr,1)),"^",2)
	.s DocTypeDesc=##class(web.DHCAlloc).GetOneDocTypeSession(LocDr,docDr)
	.//s DocTypeDesc="##class"
	.s patIndex="",I=1
	.f  s patIndex=$o(^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)) q:(patIndex="")||(I>maxShow)  d
	..s ReStr=^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	..s patName=$p(ReStr,"^",4)
	..s patNum=$p(ReStr,"^",3)
	..s patState=$p(ReStr,"^",2)
	..i patState="未报到" s patState="未报"
	..//i patState="优先" s patState="等候"
	..s patInfo=patNum_" "_patName_"("_patState_")"
	
	..s $p(RetWaitStr,"<br/>",maxShow-I+1)=patInfo
	..s colorCode="0xffffffff"
	..i patState="过号" s colorCode="0xffffcc00"
	..i patState="复诊" s colorCode="0xff00fff2"
	..i patState="过号" s colorCode="0xffffcc00"
	..s $p(colorStr,"<br/>",maxShow-I+1)=colorCode
	..s I=I+1
	..k ^DHCVISTemp(+$h,"FindLocDocCurrentAdm",serverIP,User,patIndex)
	.s docStr=docDesc_"  "_DocTypeDesc
	.s $p(RetWaitStr,"<br/>",maxShow+1)=docStr
	.s $p(colorStr,"<br/>",maxShow+1)="0xffffffff"
	.i $o(^DHCVISBorTemp(+$h,serverIP,User))="" s ^DHCVISBorTempIndex(+$h,serverIP)="",^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	.e  s ^DHCVISBorTempIndex(+$h,serverIP)=User,^DHCVISBorTempPage(+$h,serverIP)=$I(^DHCVISBorTempPage(+$h,serverIP))
	i ($d(^DHCVISBorTempPage(+$h,serverIP))=0) s ^DHCVISBorTempPage(+$h,serverIP)=""
	//s $p(RetWaitStr,"<br/>",1)=^DHCVISBorTempPage(+$h,serverIP)
	s RetString=RetString_RetWaitStr_"&color="_colorStr
	q RetString
}

//chenyang

/// 感染科B超-cy20161110
/// 一个诊室怎么获取数据等候部分-cy20161110
/// w ##class(web.DHCVISVoiceCall).SaveAllGRKOnePatient("63","285")
ClassMethod SaveAllGRKOnePatient(ServerRowId As %String = "", clientRowId As %String = "") As %String
{
	q:ServerRowId="" ""
	q:clientRowId="" ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	q:QueType'="GRK" ""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s CreateTime=""
	s retStrS="",retStrd="",retStrdS=""
	s Num=0,GetNo=0
	s Num=$g(^Num(+$h,ServerRowId,clientRowId))
	s QueueTypeID=$P($G(^DHCVISClient(clientRowId)),"^",12)
	s ClientTopIP=$P($G(^DHCVISClient(clientRowId)),"^",16)
	q:$TR(QueueTypeID," ")="" ""
	s QueueTypeDesc=$List(^User.DHCVISLinkQueueTypeD(QueueTypeID),2)
	s QueueTypeDesc=$$ALPHAUP^SSUTIL4(QueueTypeDesc)
	//等候
	s CreateTime=$g(^CreateTime(+$h,ServerRowId,clientRowId))
 	s RegQueueID=$g(^RegQueueID(+$h,ServerRowId,clientRowId))
	f  s CreateTime=$O(^DHCVISRegQueuei(0,"DateState",nowDate,"W",CreateTime)) q:(CreateTime="")||(GetNo>8)  d
 	.f  s RegQueueID=$O(^DHCVISRegQueuei(0,"DateState",nowDate,"W",CreateTime,RegQueueID)) q:(RegQueueID="")||(GetNo>8)  d
 	..s QueueStr=$G(^DHCVISRegQueue(RegQueueID))
 	..q:QueueStr=""
 	..s QueueType=$P(QueueStr,"^",20)  //队列类型
 	..s QueueType=$$ALPHAUP^SSUTIL4(QueueType)
 	..q:QueueTypeDesc'=QueueType
 	..s PatName=$P(QueueStr,"^",2)   //取姓名
 	..s PatName=$TR(PatName," ")
 	..s PatName=$TR(PatName,"0123456789")
 	..s Num=Num+1
 	..s GetNo=GetNo+1
 	..s PatName=Num_"-"_PatName
	..i retStrd=""  s retStrd=PatName
	..e  s retStrd=retStrd_"^"_PatName
	..i $O(^DHCVISRegQueuei(0,"DateState",nowDate,"W",CreateTime,RegQueueID))="" s ^RegQueueID(+$h,ServerRowId,clientRowId)="" 
	..e  s ^RegQueueID(+$h,ServerRowId,clientRowId)=RegQueueID //,^CreateTime(+$h,ServerRowId,clientRowId)=CreateTime
	.i $O(^DHCVISRegQueuei(0,"DateState",nowDate,"W",CreateTime))="" s ^CreateTime(+$h,ServerRowId,clientRowId)="",^Num(+$h,ServerRowId,clientRowId)=0
	.e  s ^CreateTime(+$h,ServerRowId,clientRowId)=CreateTime,^Num(+$h,ServerRowId,clientRowId)=Num
	.s retStrdS=QueueTypeDesc_"^"_retStrd
	q retStrdS
}

/// 
/// GRK通过ServerIP获得ServerRowId和clientRowId在循环调去得到数据-cy20161110
/// w ##class(web.DHCVISVoiceCall).GetSynScreenWaitGRKInfo("192.168.36.57")
ClassMethod GetSynScreenWaitGRKInfo(serverIP As %String = "") As %String
{
	q:serverIP="" ""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s ServerRowId=$o(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:ServerRowId="" ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	q:QueType'="GRK" ""
	s clientRowId=""
	s retStr=""
	f  s clientRowId=$o(^DHCVISClienti(0,"ServerID",ServerRowId,clientRowId)) q:clientRowId=""  d
   .s oneRoomInfo=..SaveAllGRKOnePatient(ServerRowId,clientRowId)
   .q:oneRoomInfo=""
   .i retStr=""  s retStr=oneRoomInfo
   .e  s retStr=retStr_"!"_oneRoomInfo
   q retStr
}

/// 感染科B超-cy20161110
/// 一个诊室怎么获取数据过号部分-cy20161110
/// w ##class(web.DHCVISVoiceCall).SaveAllGRKOnePatient("63","285")
ClassMethod SaveAllGRKGOnePatient(ServerRowId As %String = "", clientRowId As %String = "") As %String
{
	q:ServerRowId="" ""
	q:clientRowId="" ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	q:QueType'="GRK" ""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s CreateTime=""
	s retStrS="",retStrd="",retStrdS=""
	s Num=0,GetNo=0
	s Num=$g(^NumG(+$h,ServerRowId,clientRowId))
	s QueueTypeID=$P($G(^DHCVISClient(clientRowId)),"^",12)
	s ClientTopIP=$P($G(^DHCVISClient(clientRowId)),"^",16)
	q:$TR(QueueTypeID," ")="" ""
	s QueueTypeDesc=$List(^User.DHCVISLinkQueueTypeD(QueueTypeID),2)
	s QueueTypeDesc=$$ALPHAUP^SSUTIL4(QueueTypeDesc)
	//过号
	s CreateTime=$g(^CreateTimeG(+$h,ServerRowId,clientRowId))
 	s RegQueueID=$g(^RegQueueIDG(+$h,ServerRowId,clientRowId))
	f  s CreateTime=$O(^DHCVISRegQueuei(0,"DateState",nowDate,"S",CreateTime)) q:(CreateTime="")||(GetNo>3)  d
 	.f  s RegQueueID=$O(^DHCVISRegQueuei(0,"DateState",nowDate,"S",CreateTime,RegQueueID)) q:(RegQueueID="")||(GetNo>3)  d
 	..s QueueStr=$G(^DHCVISRegQueue(RegQueueID))
 	..q:QueueStr=""
 	..s QueueType=$P(QueueStr,"^",20)  //队列类型
 	..s QueueType=$$ALPHAUP^SSUTIL4(QueueType)
 	..q:QueueTypeDesc'=QueueType
 	..s PatName=$P(QueueStr,"^",2)   //取姓名
 	..s PatName=$TR(PatName," ")
 	..s PatName=$TR(PatName,"0123456789")
 	..s Num=Num+1
 	..s GetNo=GetNo+1
 	..s PatName=Num_"-"_PatName
	..i retStrd=""  s retStrd=PatName
	..e  s retStrd=retStrd_"^"_PatName
	..i $O(^DHCVISRegQueuei(0,"DateState",nowDate,"S",CreateTime,RegQueueID))="" s ^RegQueueIDG(+$h,ServerRowId,clientRowId)="" 
	..e  s ^RegQueueIDG(+$h,ServerRowId,clientRowId)=RegQueueID //,^CreateTimeG(+$h,ServerRowId,clientRowId)=CreateTime
	.i $O(^DHCVISRegQueuei(0,"DateState",nowDate,"S",CreateTime))="" s ^CreateTimeG(+$h,ServerRowId,clientRowId)="",^NumG(+$h,ServerRowId,clientRowId)=0
	.e  s ^CreateTimeG(+$h,ServerRowId,clientRowId)=CreateTime,^NumG(+$h,ServerRowId,clientRowId)=Num
	.s retStrdS=QueueTypeDesc_":"_retStrd
	s retStrdS=$tr(retStrdS,"^"," ") 
	q retStrdS
}

/// 
/// GRK通过ServerIP获得ServerRowId和clientRowId在循环调去得到数据-cy20161110
/// w ##class(web.DHCVISVoiceCall).GetSynScreenWaitGRKGInfo("192.168.3.62")
ClassMethod GetSynScreenWaitGRKGInfo(serverIP As %String = "") As %String
{
	q:serverIP="" ""
	s nowDate=+$h,nowTime=$p($h,",",2)
	s ServerRowId=$o(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:ServerRowId="" ""
	s QueType=$P($G(^DHCVISServer(ServerRowId)),"^",9)
	q:QueType'="GRK" ""
	s clientRowId=""
	s retStr=""
	f  s clientRowId=$o(^DHCVISClienti(0,"ServerID",ServerRowId,clientRowId)) q:clientRowId=""  d
   .s oneRoomInfo=..SaveAllGRKGOnePatient(ServerRowId,clientRowId)
   .q:oneRoomInfo=""
   .i retStr=""  s retStr=oneRoomInfo
   .e  s retStr=retStr_"  "_oneRoomInfo
   q retStr
}

}
