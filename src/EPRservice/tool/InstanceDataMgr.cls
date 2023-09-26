/// 名称：EPRservice.tool.InstanceDataMgr
/// 描述：实例数据管理器，提供几种修改实例数据的小工具
/// 		1、DelListDataByPrtDocID 按照PrintDocID删除某次就诊实例数据
/// 		2、RefreshInstanceData 刷新实例数据为对应模板的初始化数据
/// 	创建者：houj
/// 	创建日期：2010-02-22
Class EPRservice.tool.InstanceDataMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 按照PrintDocID删除某次就诊的实例数据
/// Debug：d ##class(EPRservice.tool.InstanceDataMgr).DelListDataByPrtDocID("55","47")
/// Usage:
/// argAdmId 为病人就诊rowid
/// argPrintDocID 为打印模板展现结构ID，即EPRmeta.EPRTemplateCategory中CategoryType字段值为PrtTemplate的记录的rowid
///               也可以打开电子病历界面，直接找到病历列表（注意要在点了头菜单之后，直接去找病历列表，不要操作其他病历），
///               右键查看源文件，找到 var _ProfileID = "ML24"; 其中的 24就是要找的值。
ClassMethod DelListDataByPrtDocID(argAdmId As %String, argPrintDocID As %String)
{
	if ($d(argAdmId)=0)||(argAdmId="")||(argPrintDocID="")
	{
		w "病人就诊rowid不存在!",!
		q "删除失败!"
	}
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	//if isOK="0" quit
	
	s chartItemID = "ML"_argPrintDocID
	s printDocID = argPrintDocID 
	
	w "开始删除病人打散数据:",!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的主表数据
	k SQLCODE
	&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ECRecord表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打散数据
	k SQLCODE
	&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegment表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegmentSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDesc表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDescSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITableSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IAnnotate表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IFigure表数据:"_SQLCODE,!
	
	////////////////////////////////////////////////
	//删除日志
	k SQLCODE
	&SQL(delete from EPRinstance.EPRLogs where EpisodeID = :argAdmId and EPRDocID=:printDocID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRLogs表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打印日志数据
	/*
	k SQLCODE
	&SQL(delete from EPRinstance.InstancePrintRecord 
			where  EpisodePrintRecordID in (select distinct ID from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除InstancePrintRecord表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EpisodePrintRecord表数据:"_SQLCODE,!
	*/
}

/// Desc:	刷新实例数据为对应模板的初始化数据
/// HowToUse:
/// 1. 查找病历ID
///   对于唯一病历：
///   1.1 在病历界面单击鼠标右键，选择查看源文件，找到病历对应的 EpisodeID 和 ProfileID(即ChartItemID)
///   1.2 使用下面的sql语句找到需要刷新的实例数据的ID，参数为 EpisodeID 和 ChartItemID
///       直接显示的病历：只有一个ID，即要刷新的ID
///       横排子项的病历：会有多个ID，从中选择对应的ID
///       select ID from EPRinstance.InstanceData where TheECRecord = (select ID from EPRinstance.ECRecord where EpisodeID = "56" and ChartItemID = "85")
///   对于历次病历：
///   在病历界面单击鼠标右键，选择查看源文件，直接找到要修改病历对应的ID即可。
/// 2. 在Terminal中执行下面语句
/// 	   w ##class(EPRservice.tool.BOInstanceData).RefreshInstanceData(ID)
/// 	   输出 "1", 表明刷新成功
ClassMethod RefreshInstanceData(argInstanceId As %String) As %String
{
	q:($d(argInstanceId)=0) "0"
	
 	//取原实例数据
	s objInstanceData= ##class(EPRinstance.InstanceData).%OpenId(argInstanceId)
 	q:(objInstanceData="") "0"
 	
 	s templateId = objInstanceData.TemplateID
 	s templateVersion= objInstanceData.TemplateVersion
 	q:((templateId="")||(templateVersion="")) "0"
 	
 	//刷新实例数据为对应模板的初始化数据
 	d objInstanceData.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(templateId,templateVersion))
 	if objInstanceData.%Save()
 	{	q "1"}
 	else
 	{	q "0"}
}

Method DelDataByChartItemID(argAdmId As %String, argChartItemID As %String) As %String
{
	if ($d(argAdmId)=0)||(argAdmId="")
	{
		w "病人就诊rowid不存在!",!
		q "删除失败!"
	}
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	if isOK="0" quit
	
	//s allChartItemID 
	
	w "开始删除病人打散数据:",!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的主表数据
	k SQLCODE
	&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ECRecord表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打散数据
	k SQLCODE
	&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegment表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegmentSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDesc表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDescSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITableSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IAnnotate表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IFigure表数据:"_SQLCODE,!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打印日志数据
	/*
	k SQLCODE
	&SQL(delete from EPRinstance.InstancePrintRecord 
			where  EpisodePrintRecordID in (select distinct ID from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除InstancePrintRecord表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EpisodePrintRecord表数据:"_SQLCODE,!
	*/
}

/// d ##class(EPRservice.tool.InstanceDataMgr).DelInstAndSimpByADMID("201871","")
ClassMethod DelInstAndSimpByADMID(argAdmId As %String, argChartItemID As %String) As %String
{
	
	if ($d(argAdmId)=0)||(argAdmId="")
	{
		w "病人就诊rowid不存在!",!
		q "删除失败!"
	}
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	//if isOK="0" quit
	
	w "开始删除病人打散数据:",!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的主表数据
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ECRecord表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打散数据
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegment表数据:"_SQLCODE,!

	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegmentSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDesc表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDescSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITableSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IAnnotate表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IFigure表数据:"_SQLCODE,!
	
	//q
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打印日志数据
	k SQLCODE
	&SQL(delete from EPRinstance.InstancePrintRecord 
			where  EpisodePrintRecordID in (select distinct ID from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除InstancePrintRecord表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EpisodePrintRecord表数据:"_SQLCODE,!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的新框架数据
	
	k SQLCODE
	&SQL(delete from EPRinstance.AdmPatType where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除AdmPatType表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPImagePage 
			where  EPImageID in (select distinct ID from EPRinstance.EPImage where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPImagePage表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EPImage where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPImage表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPRDept where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRDept表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPRLogs where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRLogs表数据:"_SQLCODE,!
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	//if isOK="0" quit
}

/// Desc: 按照TemplateDocID删除某次就诊的实例数据
/// Debug：d ##class(EPRservice.tool.InstanceDataMgr).DelSingleDataByTemplateDocID("55","47")
/// Usage:
/// argAdmId 为病人就诊rowid
/// argTemplateDocID 为打印模板展现结构ID，即EPRmeta.EPRTemplate中记录的rowid
///               可以打开电子病历界面，直接找到病历（注意要在点了头菜单之后，直接去找病历，不要操作其他病历），
///               右键查看源文件，找到 var templateDocId = '4';   其中的 4 就是要找的值。
ClassMethod DelSingleDataByTemplateDocID(argAdmId As %String, argTemplateDocID As %String)
{
	if ($d(argAdmId)=0)||(argAdmId="")||(argTemplateDocID="")
	{
		w "病人就诊rowid不存在!",!
		q "删除失败!"
	}
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	//if isOK="0" quit
	
	s objEPRTemplate = ##class(EPRmeta.EPRTemplate).%OpenId(argTemplateDocID)
	if (objEPRTemplate = "")
	{
		w "指定病历不存在",!
		w "删除失败"
	}
	
	s templateID = objEPRTemplate.BindTemplateID
	if (templateID = "")
	{
		w "指定病历未绑定界面模板",!
		w "删除失败"
	}
	
	s chartItemID = "CG"_templateID
	//s printDocID = argPrintDocID 
	
	w "开始删除病人打散数据:",!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的主表数据
	k SQLCODE
	&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ECRecord表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打散数据
	k SQLCODE
	&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegment表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegmentSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDesc表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDescSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITableSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IAnnotate表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId and ChartItemID=:chartItemID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IFigure表数据:"_SQLCODE,!
	
	////////////////////////////////////////////////
	//删除日志
	/*
	k SQLCODE
	&SQL(delete from EPRinstance.EPRLogs where EpisodeID = :argAdmId and EPRDocID=:printDocID)
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRLogs表数据:"_SQLCODE,!
	*/
}

}
