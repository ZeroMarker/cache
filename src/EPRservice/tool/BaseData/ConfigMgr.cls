/// 电子病历基础数据配置
/// 基础数据配置以此为准
Class EPRservice.tool.BaseData.ConfigMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 主入口
/// d ##Class(EPRservice.tool.BaseData.ConfigMgr).Main()
ClassMethod Main()
{
	s ^CacheTemp("EPRservice.tool.BaseData.ConfigMgr")=""
	s ^CacheTemp("EPRservice.tool.BaseData.ConfigMgr")=..UserConfirm("是否需要程序静默运行？")
	
	//主程序
	d ##Class(EPRservice.tool.BaseData.EPR2).Main()
		
	//查询
	d ##Class(EPRservice.tool.BaseData.Query).Main()
		
	//质控
	d ##Class(EPRservice.tool.BaseData.Quality).Main()
		
	//数字签名
	d ##Class(EPRservice.tool.BaseData.CertAuth).Main()
		
	//一键打印
	d ##Class(EPRservice.tool.BaseData.OneStepPrint).Main()
		
	//病历浏览
	d ##Class(EPRservice.tool.BaseData.Browser).Main()
		
	//编译所有CSP
	s ret=..UserConfirm("开始编译电子病历EPR下所有的CSP文件，确定所有CSP文件都加入到DHCEPR_CSP工程中")
	if ("Y"=ret) { d $System.OBJ.CompileProject("DHCEPR_CSP", "f") }
}

/// 与用户交互，传入需显示的信息
/// 用户确认返回Y，否则为N
ClassMethod UserConfirm(msg As %String) As %String
{
	w msg,!
	q:"Y"=^CacheTemp("EPRservice.tool.BaseData.ConfigMgr") "Y"   
	s ret="n"
	for {
		r "确认请输入 y, 否则请输入 n    ", ret
		s ret=$zcvt(ret,"U")
		q:("Y"=ret)||("N"=ret)
		w !,"输入错误，请输入 y 或者 n",!
	}
	w !	
	q ret
}

/// w ##Class(EPRservice.BOBaseData).CompilePrjFile("D:\garbage\upload\DHC_OneStepPrint.xml")
/// 编译工程文件
ClassMethod CompilePrjFile(prjFile As %String) As %String
{
	S $zt = "ErrorHandlerCompilePrjFile"	
	
 	If ##class(%File).Exists(prjFile) 
 	{
	 	//c代表编译	 u代表只更新有变动的类	k代表保留生成routine的原代码
	 	Do $system.OBJ.Load(prjFile,"ck")
 	}	
	 	
	w !,"编译["_prjFile_" ]成功！",!
ErrorHandlerCompilePrjFile
	q "错误信息："_$ZError
}

}
