/// 名称:	EMR.OP.TOOL.InitStandardDataTool
/// 描述:	门诊病历 初始化工具类
/// 编写者:	yejian
/// 编写日期: 	2021-7-26
/// 产品组：	电子病历产品组
Class EMR.OP.TOOL.InitStandardDataTool Extends %RegisteredObject
{

/// Desc:       初始化项目
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.OP.TOOL.InitStandardDataTool).InitAll()
ClassMethod InitAll()
{
	//初始化系统参数（DOC）
	d ##Class(EMR.OP.TOOL.InitStandardDataTool).InitDocSysOption("D:\07_DocSysOption.txt")
}

/// Desc:       初始化门诊系统参数
/// Creator:    yejian
/// CreateDate: 2021-7-23
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMR.OP.TOOL.InitStandardDataTool).InitOPSysOption("D:\07_OPSysOption.txt")
ClassMethod InitOPSysOption(argFile As %String)
{
	k ^CF.EMR.OP.SysOptionI
	k ^CF.EMR.OP.SysOptionD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s totCount=0,okCount=0,failCount=0
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		s obj = ##Class(CF.EMR.OP.SysOption).%New()
		//Description	IsVisible	IsEditor	Name	OptionValue
		s obj.Description = $p(sRec, $c(9), 2)
 		s obj.IsVisible = $p(sRec, $c(9), 3)
 		s obj.Name = $p(sRec, $c(9), 4)
		s obj.OptionValue = $p(sRec, $c(9), 5)

		s isOK = obj.%Save()
	    
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	}
	w !,"06_Summary: "_totCount_" okCount"_okCount_" failCount"_failCount
	quit
}

}
