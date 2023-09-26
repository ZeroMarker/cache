Import sqluser

/// Creator:lxt
/// Description：机器数据上传及解析(清洗机、灭菌器)
/// Date：2022-01-07
Class web.CSSDHUI.MachineData.DataDeal Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:按照灭菌主表ID\类型自动匹配机器文件
/// Table:CSSD_SterilizeRecord
/// Input:RowId：灭菌主表的dr,Type：类型
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).jsFileMatch("{""RowIdStr"":""325"",""Type"":""sterilizer"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod jsFileMatch(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..FileMatch(Params)
	q RtnObj.Json()
}

/// Descript:	自动匹配机器文件
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
/// w ##class(web.CSSDHUI.MachineData.DataDeal).FileMatch()
ClassMethod FileMatch(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s RowIdStr=PJObj.%Get("RowIdStr")
	q:RowIdStr="" RtnObj.Err(-2,"","未选择要处理的数据")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_gHospId
	s ParamTitle="gUserId^gLocId^gGroupId^gHospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	s Type=PJObj.%Get("Type")
	//s date=+$h
	//s date=$zd(date,3)
	
	s Pid=..NewPid()
	k ^CSSDTMPID("MachineFileName",Pid)
	
	s len=$l(RowIdStr,","),count=0,countset=0,suc=0,num=0
	i Type="sterilizer" d
	.f i=1:1:len  d
	..s count=count+1
	..s RowId=$p(RowIdStr,",",i)
	..s RecordData=^User.CSSDSterilizeRecordD(RowId)
	..s date=$lg(RecordData,2)
	..s date=$zd(date,3)
	..s Num=$lg(RecordData,52)
	..q:Num=""
	..s MachineDr=$lg(RecordData,35)
	..s MachineData=^User.CSSDMachineConfigD(MachineDr)
	..s MachineNo=$lg(MachineData,3)
	..s MachinePre=$lg(MachineData,7)
	..q:MachinePre=""
	..s DataStr=$e($p(date,"-",1),3,4)_$p(date,"-",2)_$p(date,"-",3)
	..s FilePre=MachinePre_DataStr_"-"_Num_"-"
	..s ^CSSDTMPID("MachineFileName",Pid,FilePre)=RowId
	..s countset=countset+1
	e  i Type="washer" d
	.f i=1:1:len d
	..s count=count+1
	..s RowId=$p(RowIdStr,",",i)
	..s RecordData=^User.CSSDCleanD(RowId)
	..s date=$lg(RecordData,3)
	..s date=$zd(date,3)
	..s Num=$lg(RecordData,26)
	..q:Num=""
	..s MachineDr=$lg(RecordData,19)
	..q:MachineDr=""
	..s MachineData=^User.CSSDMachineConfigD(MachineDr)
	..s MachineNo=$lg(MachineData,3)
	..s MachinePre=$lg(MachineData,7)
	..q:MachinePre=""
	..s DataStr=$e($p(date,"-",1),3,4)_$p(date,"-",2)_$p(date,"-",3)
	..s FilePre=MachinePre_DataStr_"-"_Num_"-"
	..s ^CSSDTMPID("MachineFileName",Pid,FilePre)=RowId
	..s countset=countset+1
	
	i countset=0 d
	.s RtnObj.msg="未匹配到所关联的机器存储文件！"
	.k ^CSSDTMPID("MachineFileName",Pid)
	q:countset=0 RtnObj
	
	//循环机器存储ftp上传到服务器的ftp
	s FtpRtnObj=..GetFtpFileData(Pid,Param,countset)
	i FtpRtnObj.success=100 q RtnObj		;未配置ftp服务时,不进行报错
	e  s RtnObj=FtpRtnObj
	
	i RtnObj.success<0 k ^CSSDTMPID("MachineFileName",Pid) q RtnObj
	s num=RtnObj.rowid
	
	i +num=0 d
	.s RtnObj.msg="单据:"_count_",匹配:"_num_",关联:"_suc
	.k ^CSSDTMPID("MachineFileName",Pid)
	q:+num=0 RtnObj
	
	i Type="sterilizer" d
	.s FilePre=""
	.f  s FilePre=$o(^CSSDTMPID("MachineFileName",Pid,FilePre)) q:(FilePre="")  d
	..s RowId=$p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",1)
	..s FileName=$p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",2)
	..q:FileName=""
	..&sql(update CSSD_SterilizeRecord set CSSDSR_FileName=:FileName where CSSDSR_Rowid=:RowId)
	..i SQLCODE=0 s suc=suc+1
	e  i Type="washer" d
	.s FilePre=""
	.f  s FilePre=$o(^CSSDTMPID("MachineFileName",Pid,FilePre)) q:(FilePre="")  d
	..s RowId=$p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",1)
	..s FileName=$p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",2)
	..q:FileName=""
	..&sql(update CSSD_Clean set CSSDC_FileName=:FileName where ID=:RowId)
	..i SQLCODE'=0 s suc=suc+1
	
	s RtnObj.msg="单据:"_count_",匹配:"_num_",关联:"_suc
	k ^CSSDTMPID("MachineFileName",Pid)
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:循环机器存储ftp上传到服务器的ftp
/// Table:
/// Input:
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).GetFtpFileData()
ClassMethod GetFtpFileData(Pid, Param, count) As web.CSSDHUI.RtnObj
{
	n (Pid, Param, count)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Param)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_gHospId
	s ParamTitle="UserId^LocId^GroupId^HospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	
	s DataFtpList=..GetDataFtp(Param)
	s DataServerIP=$p(DataFtpList,"^",1)
	s DataUser=$p(DataFtpList,"^",2)
	s DataPassWord=$p(DataFtpList,"^",3)
	s DataDirectory=$p(DataFtpList,"^",4)
	s DataPort=$p(DataFtpList,"^",5)
	i DataServerIP="" q RtnObj.Err(100,"","未配置机器存储FTP","",0)

	s ftp=##class(%Net.FtpSession).%New()
	i 'ftp.Connect(DataServerIP,DataUser,DataPassWord,DataPort)  q RtnObj.Err(-4,"","连接保存机器数据ftp失败")
	s NameArray=##class(%ArrayOfDataTypes).%New()
	i 'ftp.NameList(DataDirectory,NameArray) q RtnObj.Err(-5,"","未获取到存放机器数据的文件")
	s ArrayLength=NameArray.Count()
	s ret="",num=0
	f i=ArrayLength:-1:1 q:(num=count)  d
	.s OneName=NameArray.GetAt(i)
	.s Src=$p(OneName,"/",1)
	.s FileName=$p(OneName,"/",2)
	.s FilePre=$p(FileName,"-",1,2)_"-"
	.i $d(^CSSDTMPID("MachineFileName",Pid,FilePre)) d
	..s RecordFileName=$p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",2)
	..i RecordFileName="" d
	...s stream=##class(%GlobalCharacterStream).%New()
	...q:'ftp.Retrieve(OneName,stream)
	...s result=##class(web.CSSDHUI.Common.FtpFile).UpFile(stream,FileName,Param)
	...q:result'=0
	...s $p(^CSSDTMPID("MachineFileName",Pid,FilePre),"^",2)=FileName
	...s num=num+1
	
	s RtnObj.rowid=num
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:按照灭菌主表ID、文件名（界面手工选择的文件名）重新匹配机器文件
/// Table:CSSD_SterilizeRecord
/// Input:RowId：灭菌主表的dr,Type：类型
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).jsReFileMatch(^templxt("2222"))
ClassMethod jsReFileMatch(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..ReFileMatch(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:判断目录下的文件是否存在，存在转换成文件流上传存储服务器,并重新绑定文件名
/// Table:
/// Input:
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).ReFileMatch("")
ClassMethod ReFileMatch(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s RowId=PJObj.%Get("RowId")
	q:RowId="" RtnObj.Err(-2,"","未选择要处理的数据")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s FileName=PJObj.%Get("FileName")
	s Type=PJObj.%Get("Type")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_gHospId
	s ParamTitle="UserId^LocId^GroupId^HospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	s RtnObj=..GetFtpFileDataByFileName(FileName,Param)
	i RtnObj.success'=0  q RtnObj
	;读取到匹配的文件，按照机器类型进行文件名更正
	i Type="sterilizer" d
	.&sql(update CSSD_SterilizeRecord set CSSDSR_FileName=:FileName where CSSDSR_Rowid=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","关联机器数据文件失败")
	e  i Type="washer" d
	.&sql(update CSSD_Clean set CSSDC_FileName=:FileName where ID=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","关联机器数据文件失败")

	q RtnObj
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:判断目录下的文件是否存在，存在转换成文件流上传存储服务器
/// Table:
/// Input:
/// Output:
/// Return:日志信息
/// Descript:	重新匹配机器文件
/// w ##class(web.CSSDHUI.MachineData.DataDeal).GetFtpFileDataByFileName("2ST220121-1-8912","2")
ClassMethod GetFtpFileDataByFileName(FileName, Param) As web.CSSDHUI.RtnObj
{
	n (FileName,Param)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s DataFtpList=..GetDataFtp(Param)	//获取系统配置机器存储ftp的信息
	s DataServerIP=$p(DataFtpList,"^",1)
	s DataUser=$p(DataFtpList,"^",2)
	s DataPassWord=$p(DataFtpList,"^",3)
	s DataDirectory=$p(DataFtpList,"^",4)
	s DataPort=$p(DataFtpList,"^",5)
	
	s ftp=##class(%Net.FtpSession).%New()
	i 'ftp.Connect(DataServerIP,DataUser,DataPassWord,DataPort)  q RtnObj.Err(-4,"","连接保存机器数据ftp失败")
	s stream=##class(%GlobalCharacterStream).%New()
	;判断目录下的文件是否存在，存在转换成文件流，便于读取喽
	q:'ftp.Retrieve(DataDirectory_FileName,stream) RtnObj.Err(-4,"","获取文件失败")
	;根据机器存储的ftp，上传文件到存储服务器上
	s result=##class(web.CSSDHUI.Common.FtpFile).UpFile(stream,FileName,Param)
	i result'=0  q RtnObj.Err(-4,"","上传文件失败")
	
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:获取该批次对应的机器型号的机器数据
/// Table:CSSD_SterilizeRecord
/// Input:RowId：灭菌主表的dr,Type：类型
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).GetFileData("{""Type"":""sterilizer"",""RowId"":""10"",""HospId"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetFileData(Params)
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s JsonObj=##class(%DynamicObject).%New()
	s Type=PJObj.%Get("Type")
	s RowId=PJObj.%Get("RowId")
	s HospId=PJObj.%Get("HospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_HospId
	s ParamTitle="UserId^LocId^GroupId^HospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	s (MachineModel,FileName)=""
	//获取机器存储文件名以及机器型号
	i Type="sterilizer" d
	.s RecordData=^User.CSSDSterilizeRecordD(RowId)
	.s FileName=$lg(RecordData,3)
	.s MachineDr=$lg(RecordData,35)
	.s MachineData=^User.CSSDMachineConfigD(MachineDr)
	.s MachineModel=$lg(MachineData,22)
	e  d
	.s RecordData=^User.CSSDCleanD(RowId)
	.s FileName=$lg(RecordData,25)
	.s MachineDr=$lg(RecordData,19)
	.s MachineData=^User.CSSDMachineConfigD(MachineDr)
	.s MachineModel=$lg(MachineData,22)
	q:MachineModel="" RtnObj.Err(-4,"","未获取到机器型号").Json()
	
	s (timest,timeed,pressst,pressed,tempst,temped,A0st,A0ed)=""
	//按照不同的机器型号，获取时间、压力、温度的截取位置
	i (MachineModel="MJ-SHINVA4000")||(MachineModel="MJ-SHINVA5000") d
	.s timest=23,timeed=28
	.s pressst=29,pressed=33
	.s tempst=34,temped=38
	e  i MachineModel="MJ-SHINVAPS" d
	.s timest=23,timeed=28
	.s pressst=29,pressed=34
	.s tempst=35,temped=39
	e  i MachineModel="MJ-SHINVAEO" d
	.s timest=23,timeed=28
	.s pressst=29,pressed=34
	.s tempst=35,temped=39
	e  i MachineModel="QX-SHINVAWS" d
	.s timest=23,timeed=28
	.s pressst=34,pressed=38
	.s tempst=29,temped=33
	.s A0st=49,A0ed=53
	e  i MachineModel="QX-SHINVASB" d
	.s timest=23,timeed=28
	.s tempst=29,temped=33
	.s A0st=49,A0ed=53
	e  i MachineModel="QX-SHINVAMB" d
	.s timest=23,timeed=28
	.s tempst=29,temped=33
	.s A0st=49,A0ed=53
	e  i MachineModel="QX-SHINVAOC" d
	.s timest=23,timeed=28
	.s tempst=29,temped=33
	.s A0st=49,A0ed=53
	q:(timest="")||(timeed="") RtnObj.Err(-4,"","时间解析规则不准确").Json()
	
	s ftpconfig=##class(web.CSSDHUI.Common.FtpFile).GetFtpConfig(Param)
	s ftpip=$p(ftpconfig,"^",1)
	s ftpuser=$p(ftpconfig,"^",2)
	s ftppass=$p(ftpconfig,"^",3)
	s ftpsrc=$p(ftpconfig,"^",4)
	s ftpport=$p(ftpconfig,"^",5)
	s ftpssl=$p(ftpconfig,"^",7)
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.SSLConfiguration=ftpssl
	i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q RtnObj.Err(-4,"","获取文件失败，请重新匹配！").Json()
	s stream=##class(%GlobalCharacterStream).%New()
	q:'ftp.Retrieve(ftpsrc_FileName,stream) RtnObj.Err(-4,"","获取文件失败，请重新匹配！").Json()	//判断ftp是否能读取到文件
	
	s RowDelim=$c(10)
	d stream.LineTerminatorSet(RowDelim)
	
	s (dateTimeData,tempData,pressData,A0Data)=""
	s rtn=0
	while ('stream.AtEnd)&&(rtn'="end") {
		s Info=stream.ReadLine()	//按行读取文件
		s Info = $tr(Info,$c(13),"")
		s len=$l(Info,">")
		continue:+len=0
		//按照截取位置截取数据中的时间刻度值
		s timestr=$e(Info,timest,timeed)
		continue:timestr=""	//部分机器数据会有空白行（首行）
		s time=$e(timestr,1,2)_":"_$e(timestr,3,4)_":"_$e(timestr,5,6)
		i dateTimeData="" s dateTimeData=time
		e  s dateTimeData=dateTimeData_","_time
		//按照截取位置截取数据中的压力刻度值
		i (pressst'="")&&(pressed'="") d
		.s presss=$e(Info,pressst,pressed)
		.i pressData="" s pressData= presss
		.e  s pressData=pressData_","_presss
		//按照截取位置截取数据中的温度刻度值
		i (tempst'="")&&(temped'="") d
		.s temp=$e(Info,tempst,temped)
		.i tempData="" s tempData= temp
		.e  s tempData=tempData_","_temp
		//按照截取位置截取数据中的A0值
		i (A0st'="")&&(A0ed'="") d
		.s A0=$e(Info,A0st,A0ed)
		.i A0Data="" s A0Data= A0
		.e  s A0Data=A0Data_","_A0
	}
	
	s Data=dateTimeData_"^"_pressData_"^"_tempData_"^"_A0Data
	s Title="dateTimeData^pressData^tempData^humData^A0Data"
	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	q Rtn
}

/// Creator:lxt
/// CreatDate:2022.1.7
/// Description:获取科室机器存储对应的FTP信息
/// Table:
/// Input:HospId：医院号
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.MachineData.DataDeal).GetDataFtp(2)
ClassMethod GetDataFtp(Params)
{
	n (Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"
	s gHospId = PJObj.%Get("HospId")
	s gLocId = PJObj.%Get("LocId")
	s gUserId=PJObj.%Get("UserId")
	s gGroupId=PJObj.%Get("GroupId")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName="CSSDMACHINEFTP"
	s ftpip=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpIp",Param)
	s ftpuser=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpUser",Param)
	s ftppass=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPassword",Param)
	s ftppass=##class(web.CSSDHUI.Common.UtilCommon).DecryptPW(ftppass)
	s ftpsrc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPicSrc",Param)
	s ftphttpsrc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpHttpSrc",Param)
	s ftpport=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPort",Param)
	s ftpssl=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpSSL",Param)
	s:ftpport="" ftpport=21
	s:ftpssl'="FTPS" ftpssl=""
	s FtpDataList=ftpip_"^"_ftpuser_"^"_ftppass_"^"_ftpsrc_"^"_ftpport_"^"_ftphttpsrc_"^"_ftpssl
	q FtpDataList
}

}
