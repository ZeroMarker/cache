Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResult Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日	
/// creator:zhibao
/// desc: 根据检验项目的明细id获取检验报告明细结果信息
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResult).getLisItemResult("81761117")
ClassMethod getLisItemResult(ReportResultDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
	try{
		set subobj=..getLisItemResultinfo(ReportResultDr)
		d main.LisItemResultList.Insert(subobj)
	}catch{ 
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d stream.Write(JsonString)
	Quit stream
}

/// 获取RPVisitNumberReportResult检验数据
ClassMethod getLisItemResultinfo(ReportResultDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult
{
	try{
		set ResultData=$g(^dbo.RPVisitNumberReportResultD(ReportResultDr))
		set ReportId=$lg(ResultData,2)
		set TestCodeDR=$lg(ResultData,3)
		s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
		s TestCodeCode=$lg(TestCodeData,2)
		s TestCodeName=$lg(TestCodeData,3)
		//微生物
		s ResultFormat=$lg(TestCodeData,9)
		s:$e(TestCodeCode)="W" ResultFormat="M"
		set AntResFlag=0
		i ResultFormat="M" s AntResFlag=1
		//结果
		s Result=$lg(ResultData,4)
		//文本结果
		s TextRes=$lg(ResultData,5)
		//单位
		s Unit=$lg(ResultData,11)
		//范围
		s RefRanges=$lg(ResultData,12)
		//异常标识
		s AbFlag=$lg(ResultData,9)
		s warnFlag=AbFlag
		//检测方法
		s MethodDR=$lg(ResultData,13)
		set TestMethodDesc=""
		i MethodDR'=""{
			s TestMethodDesc=$lg($g(^dbo.BTTestMethodD(MethodDR)),3)
		}else{
			s TestMethodDesc=""
		}
		//序号
		s Sequence=$lg(ResultData,18)
		set AdmNo=$lg(ResultData,23)
		set RegNo=$lg(ResultData,22)
		set:AdmNo'="" PatientId=$p($g(^PAADM(AdmNo)),"^",1)
		set:AdmNo="" PatientId=""
		set AssayDate=$lg(ResultData,16)
		set AssayDate=..FormatDate(AssayDate)
		set AssayTime=$lg(ResultData,17)
		set AssayTime=..FormatTime(AssayTime)
		set lisirremark=$lg(ResultData,8)
		set lisirresultexplain=$lg(ResultData,7)
		set machineDr=$lg(ResultData,14)
		set machineDesc=""
		if machineDr'=""{
			set machineData=$g(^dbo.BTWorkGroupMachineD(machineDr))
			set machineDesc=$lg(machineData,3)
		}
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
		set businessfieldcode=subobj.businessfieldcode
		set subobj.lisirabnormalflags=AbFlag
		set subobj.lisircount=""
		set subobj.lisirextraresult=TextRes
		set subobj.lisirhositemid=ReportResultDr
		//国际代码
		set subobj.lisirintercode=""
		set subobj.lisiritemabbrcode=""
		set subobj.lisiritemcode=TestCodeCode
		set subobj.lisiritemdesc=TestCodeName
		set subobj.lisirranges=RefRanges
		set subobj.lisirrelitemid=businessfieldcode_"_"_ReportResultDr
		set subobj.lisirremark=lisirremark
		set subobj.lisirresult=Result
		set subobj.lisirresultexplain=lisirresultexplain
		set subobj.lisirrule=""
		set subobj.lisirshowseq=Sequence
		set subobj.lisirtestdate=AssayDate
		set subobj.lisirtestmachine=machineDesc
		set subobj.lisirtestmethod=TestMethodDesc
		set subobj.lisirtesttime=AssayTime
		set subobj.lisirtestusercode=""
		set subobj.lisirtestusername=""
		set subobj.lisirtextresult=TextRes
		set subobj.lisirunit=Unit
		set subobj.lissrrellisreportid=businessfieldcode_"_"_ReportId
		set subobj.oeorirelorderitemid=""
		set subobj.paadmrelvisitnumber=businessfieldcode_"_"_AdmNo
		set subobj.papatrelpatientid=businessfieldcode_"_"_PatientId
		set subobj.updatedate=$zd(+$h,3)
		set subobj.updatetime=$zt($p($h,",",2))
	}
	catch{
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
	}
	quit subobj
}

/// 检验明细结果信息历史数据
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResult).getLisItemResultglobal("1","81961158")
ClassMethod getLisItemResultglobal(strRowId As %String, endRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("lisitemresult")=$lb("院内检验结果id","化验项目代码","化验项目描述","结果","单位","定性结果","扩展结果","结果说明","异常标志","参考范围","检测方法","检测仪器","检测人代码","显示序号（在同一报告id下自增）","检测日期","检测时间","细菌计数","专家规则","备注","时间戳","时间戳","检测人描述","国际代码","全局患者id","全局就诊id","全局检验报告号","业务域","院内检验结果id","全局医嘱明细id","化验项目缩写")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	for ReportResultDr=strRowId:1:endRowId
	{
		continue:$d(^dbo.RPVisitNumberReportResultD(ReportResultDr))=0
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
		set subobj=..getLisItemResultinfo(ReportResultDr)
		set ^ExportHistoryData("lisitemresult",ReportResultDr)=$lb(ReportResultDr,subobj.lisiritemcode,subobj.lisiritemdesc,subobj.lisirresult,subobj.lisirunit,
															subobj.lisirtextresult,subobj.lisirextraresult,subobj.lisirresultexplain,subobj.lisirabnormalflags,subobj.lisirranges,
															subobj.lisirtestmethod,subobj.lisirtestmachine,subobj.lisirtestusercode,subobj.lisirshowseq,subobj.lisirtestdate,
															subobj.lisirtesttime,subobj.lisircount,subobj.lisirrule,subobj.lisirremark,subobj.updatedate,
															subobj.updatetime,subobj.lisirtestusername,subobj.lisirintercode,subobj.papatrelpatientid,subobj.paadmrelvisitnumber,
															subobj.lissrrellisreportid,subobj.oeorirelorderitemid,subobj.lisiritemabbrcode,subobj.businessfieldcode,subobj.lisirrelitemid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, ReportResultDr)
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod FormatDate(Input As %String) As %String
{
	s $zt = "Error"
	q:Input="" ""
	s date=$zd($zdh(Input,8),3)
	q date
Error
	q ""
}

ClassMethod FormatTime(Time As %String) As %String
{
	s $zt = "Error"
	q:Time="" ""
	q:$l(Time)>5 ""
	q:'$ISVALIDNUM(Time) ""
	s Time=$zt(Time)
	q Time	
Error
	q ""
}

}
