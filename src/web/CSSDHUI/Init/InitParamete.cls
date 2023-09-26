Import sqluser

Class web.CSSDHUI.Init.InitParamete Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// d ##class(web.CSSDHUI.Init.InitParamete).InitBaseCodeType()
ClassMethod InitBaseCodeType()
{
	//系统模块
	i ..getpar("消毒包信息")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDPACKAGE','消毒包信息','C'))
	i ..getpar("回收申请")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDAPPLAY','回收申请','C'))
	i ..getpar("回收")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDCALLBACK','回收','C'))
	i ..getpar("清洗")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDCLEAN','清洗','C'))
	i ..getpar("打包")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDPACK','打包','C'))
	i ..getpar("灭菌")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDSTERILIZE','灭菌','C'))
	i ..getpar("发放")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDDISP','发放','C'))
	i ..getpar("ftp上传配置")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDFTPFILEM','ftp上传配置','C'))
	i ..getpar("工作台配置")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDTIPSWIN','工作台配置','C'))
	i ..getpar("机器数据存储FTP")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDMACHINEFTP','机器数据存储FTP','C'))
	i ..getpar("公共")="" d
	.&sql(insert CSSD_BaseDataType(CSSDBDT_Code,CSSDBDT_Name,CSSDBDT_Remark)values('CSSDCOMMON','公共','C'))
}

/// d ##class(web.CSSDHUI.Init.InitParamete).InitParameterData()
ClassMethod InitParameterData()
{
	//回收申请
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","DefStartDate","默认开始日期",-1,"回收申请查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","DefEndDate","默认结束日期",0,"回收申请查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","AutAuditAfterSub","默认自动确认","Y","如果为Y则回收申请单据提交后自动变为确认状态,为N则需要手动确认")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","RequiredCancel","撤销是否提示","Y","主单据撤销是否需要提示,默认Y/是")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","IfCreateApply","是否默认制单","N","是否按照消毒包登记的进行默认制单,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","IfAllLoc","申请科室是否取全院科室","N","缺省按照登录权限取值,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","SetRecLoc","提交是否补充接收科室配置","Y","缺省按N处理，默认Y")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","IfPrintAfterSub","回收申请单是否提交后打印","N","默认N")
	s PARAME($i(PARAME))=$lb("CSSDAPPLAY","IndirPrint","申请单是否预览打印","Y","Y是,默认N/否")
	//回收
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","DefStartDate","默认开始日期",-1,"回收查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","DefEndDate","默认结束日期",0,"回收查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","RequiredCancel","撤销是否提示","Y","主单据撤销是否需要提示,默认Y/是")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","IsCreatDisp","提交时是否自动生成发放单","N","默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","ExtAddType","外来器械新增方式","1","1:按消毒包新增,2:按消毒包明细新增,默认1")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","IsCreatCallBack","回收申请确认后自动生成回收单","N","默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDCALLBACK","IndirPrint","回收单是否预览打印","Y","Y是,默认N/否")
	//发放接收
	//s PARAME($i(PARAME))=$lb("CSSDDISP","ScanLabelForRes","标牌追溯包是否必须扫码接收","Y","")
	s PARAME($i(PARAME))=$lb("CSSDDISP","RequiredDispUser","发放人是否为必须填项","Y","")
	s PARAME($i(PARAME))=$lb("CSSDDISP","RequiredReceiveUser","接收人是否为必须填项","Y","")
	s PARAME($i(PARAME))=$lb("CSSDDISP","DefStartDate","默认开始日期",-1,"发放接收查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDDISP","DefEndDate","默认结束日期",0,"发放接收查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDDISP","RequiredCancel","撤销是否提示","Y","主单据撤销是否需要提示,默认Y/是")
	s PARAME($i(PARAME))=$lb("CSSDDISP","FilterByLoc","接收科室与标签对应接收科室是否需要一致","N","Y是,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IsDispExtAll","外来器械一次全部发放","N","配置分包的外来器械是否一次发放,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDDISP","UseLabelForDisp","普通循环包发放是否需要扫描包外标签","Y","Y/N,缺省为Y")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IfMoreDispQty","普通循环包发放数能否能超过单据未发数","N","Y/N,缺省为N")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IfAutoRec","发放单是否默认自动接收","N","如果为Y则发放提交后自动接收,为N则需要手动接收")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IfComfiredRecLoc","接收科室与包绑定科室是否需要一致","N","Y是,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IndirPrint","发放单是否预览打印","Y","Y是,默认N/否")
	s PARAME($i(PARAME))=$lb("CSSDDISP","IsGetRecUserByLogin","接收界面是否默认取登录人","Y","Y-是,其他-否")
	//清洗
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","DefStartDate","默认开始日期",-1,"清洗查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","DefEndDate","默认结束日期",0,"清洗查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","MinInterval","标牌追溯包清洗间隔时间(分钟)",30,"同一个标牌编码清洗的间隔时间")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","IsMachineBindType","清洗机与清洗方式是一对一绑定","Y","")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","IsGetCleanUserByLogin","清洗人是否取登录人","N","清洗人是否取登录人Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","IsGetCleanCheckUserByLogin","清洗验收人是否取登录人","Y","清洗验收人是否取登录人Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","CleanCheckval","清洗验收时间控制","40","控制多久能进行验收")
	s PARAME($i(PARAME))=$lb("CSSDCLEAN","CleanCheckManualInterval","手工清洗验收时间控制","20","控制多久能进行验收")
	//打包
	s PARAME($i(PARAME))=$lb("CSSDPACK","DefStartDate","默认开始日期",-1,"打包查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDPACK","DefEndDate","默认结束日期",0,"打包查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDPACK","PrintDetailNum","消毒包标签明细默认打印列",1,"打印外标签带明细的需要打印几列")
	s PARAME($i(PARAME))=$lb("CSSDPACK","AfterPrintClearUser","标签打印后是否清空包装人与审核人","N","")
	s PARAME($i(PARAME))=$lb("CSSDPACK","IsPackUser","标签打印是否使用配包人","N","")
	s PARAME($i(PARAME))=$lb("CSSDPACK","IsExpDateInCurDay","消毒包效期是否包含当天","Y","Y为是N为否")
	//灭菌
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","DefStartDate","默认开始日期",-1,"灭菌查询默认开始日期,-1即前一天")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","DefEndDate","默认结束日期",0,"灭菌查询默认结束日期,0即为今天")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","MinInterval","灭菌验收时间间隔(分钟)",55,"控制多久之后才能进行灭菌验收")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsSterFinish","是否需要灭菌完成操作","N","确认灭菌后是否需要先灭菌完成再验收")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsMachineBindCar","灭菌器与灭菌架是一对一绑定","N","可通过扫描灭菌器自动带出灭菌架")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsBioFailReCall","生物验收不合格是否召回","N","是的话生物验收不合格会提示召回")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsGetUserByLogin","灭菌页面灭菌人取登录人","N","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsGetUserCheckByLogin","灭菌验收人是否取登录人","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","BDTime","首次灭菌BD监测的时间设置","6:00","首次灭菌要做BD监测的时间设置")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsPhysicTest","灭菌时是否默认进行物理监测","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsCheTest","灭菌时是否默认进行化学监测","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","BioDoubleCheck","生物监测是否需要双人确认","N","Y:需要,其他:不需要")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsBioTest","灭菌时是否默认生物监测(针对已勾选生物监测的消毒包)","N","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IfAutoCreateDisp","灭菌验收后是否自动生成发放单","N","Y:需要,其他:不需要")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IsLowSterModeMix","不同低温灭菌方式是否可混合使用","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","AtuoPhyCheckOk","验收时是否默认物理监测合格","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","AtuoCheCheckOk","验收时是否默认化学监测合格","Y","Y为是N为否")
	s PARAME($i(PARAME))=$lb("CSSDSTERILIZE","IfOverChkTime","新建灭菌记录时，灭菌时间必须大于前一次的灭菌验收时间","N","Y为是N为否")
	//消毒包信息
	s PARAME($i(PARAME))=$lb("CSSDPACKAGE","Uom","常用单位","个,包,根,把,袋,对,磅,台,套","")
	s PARAME($i(PARAME))=$lb("CSSDPACKAGE","IsCodeSame","导入数据固定标牌是否和老系统一致","N","Y为是N为否")
	///ftp
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpIp","Ftp服务器Ip","127.0.0.1","Ftp服务器Ip")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpUser","服务器用户名","administrator","Ftp用户名")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpPassword","服务器密码","","Ftp密码")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpPicSrc","ftp存放图片目录","/","ftp存放图片目录")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpPort","ftp端口","21","Ftp端口")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpHttpSrc","ftp文件夹的http访问路径","127.0.0.1/cssdimg/","配置IIS上指向图片文件夹的虚拟路径")
	s PARAME($i(PARAME))=$lb("CSSDFTPFILEM","FtpSSL", "FtpSSL配置", "FTPS", "FTP或FTPS", "")
	//工作台配置
	s PARAME($i(PARAME))=$lb("CSSDTIPSWIN","WillExpireDays","有效期提前多少天提醒","7","距离过期几天进行工作台有提醒")
	s PARAME($i(PARAME))=$lb("CSSDTIPSWIN","Minutes","工作台默认刷新时间","10","分钟数:默认为10分钟")
	///机器存储ftp
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpIp","Ftp服务器Ip","","Ftp服务器Ip")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpUser","服务器用户名","","Ftp用户名")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpPassword","服务器密码","","Ftp密码")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpPicSrc","ftp存放图片目录","","ftp存放图片目录")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpPort","ftp端口","","Ftp端口")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpHttpSrc","ftp文件夹的http访问路径","","配置IIS上指向图片文件夹的虚拟路径")
	s PARAME($i(PARAME))=$lb("CSSDMACHINEFTP","FtpSSL", "FtpSSL配置", "", "FTP或FTPS", "")
	//公共
	s PARAME($i(PARAME))=$lb("CSSDCOMMON","ShowAllHospital","科室展示范围","1","1:当前医院组,2:所有医院,其他:当前医院")
	s PARAME($i(PARAME))=$lb("CSSDCOMMON","SelectFirstRow","默认选中表格第一条","N","Y:表格加载后默认选中第一条,N:不选中")
	s PARAME($i(PARAME))=$lb("CSSDCOMMON","IsSupLoc","登录科室是否匹配供应中心","N","Y:供应科室取供应中心和登录科室交集，其他:供应科室取登录科室")
}

ClassMethod getpar(parameterName) As %String
{
	n (parameterName)
	&sql(select %id into :rowid FROM CSSD_BaseDataType WHERE CSSDBDT_Name=:parameterName)  
	q $G(rowid)
}

/// w ##class(web.CSSDHUI.Init.InitParamete).getparF("CSSDAPPLAY")
ClassMethod getparF(appname) As %String
{
	n (appname)
	&sql(select %id into :rowid FROM CSSD_BaseDataType WHERE CSSDBDT_Code=:appname)  
	q $G(rowid)
}

}
