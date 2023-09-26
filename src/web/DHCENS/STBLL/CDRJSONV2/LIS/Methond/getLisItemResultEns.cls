Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResultEns Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日	
/// creator:zhibao
/// desc: 根据检验项目的明细id获取检验报告明细结果信息
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResultEns).getLisItemResult("1")
ClassMethod getLisItemResult(ReportResultDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
	try{
		set subobj=..getLisItemResultinfoEns(ReportResultDr)
		d main.LisItemResultList.Insert(subobj)
	}catch{ 
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d stream.Write(JsonString)
	Quit stream
}

/// 取EnsLISItemResult表信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisItemResult).getLisItemResultinfoEns("1")
ClassMethod getLisItemResultinfoEns(ID) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult
{
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()	
	s businessfieldcode=subobj.businessfieldcode
	s LisItemResultinfo=^Busi.ENS.EnsLISItemResultD(ID)
	s subobj.lisirhositemid=ID  //序列ID
	s subobj.lissrrellisreportid=businessfieldcode_"_"_$lg(LisItemResultinfo,3)  //报告ID
	s subobj.papatrelpatientid=businessfieldcode_"_"_$lg(LisItemResultinfo,4)  //患者ID
	s subobj.paadmrelvisitnumber=businessfieldcode_"_"_$lg(LisItemResultinfo,5)  //就诊号
	s subobj.lisiritemcode=$lg(LisItemResultinfo,6)  //化验项目代码
	s subobj.lisiritemdesc=$lg(LisItemResultinfo,7)  //化验项目名称
	s subobj.lisirresult=$lg(LisItemResultinfo,8)  //结果
	s subobj.lisirunit=$lg(LisItemResultinfo,9)  //单位
	s subobj.lisirtextresult=$lg(LisItemResultinfo,10)  //定性结果
	s subobj.lisirextraresult=$lg(LisItemResultinfo,11)  //扩展结果
	s subobj.lisirresultexplain=$lg(LisItemResultinfo,12)  //结果说明
	s subobj.lisirabnormalflags=$lg(LisItemResultinfo,13)  //异常标志
	s subobj.lisirranges=$lg(LisItemResultinfo,14)  //参考范围
	s subobj.lisirtestmethod=$lg(LisItemResultinfo,15)  //检测方法
	s subobj.lisirtestmachine=$lg(LisItemResultinfo,16)  //检测仪器
	s subobj.lisirtestusercode=$lg(LisItemResultinfo,17)  //检测人代码
	s subobj.lisirtestusername=$lg(LisItemResultinfo,18)  //检测人描述
	s subobj.lisirshowseq=$lg(LisItemResultinfo,19)  //显示序号（在同一报告ID下自增）
	s subobj.lisirtestdate=$lg(LisItemResultinfo,20)  //检测日期
	s:subobj.lisirtestdate'="" subobj.lisirtestdate=$zd(subobj.lisirtestdate,3)
	s subobj.lisirtesttime=$lg(LisItemResultinfo,21)  //检测时间
	s:subobj.lisirtesttime'="" subobj.lisirtesttime=$zt(subobj.lisirtesttime)
	s subobj.lisircount=$lg(LisItemResultinfo,22)  //细菌计数
	s subobj.lisirrule=$lg(LisItemResultinfo,23)  //专家规则
	s subobj.lisirremark=$lg(LisItemResultinfo,24)  //备注
	s subobj.lisirintercode=$lg(LisItemResultinfo,27)  //国际代码
	s subobj.oeorirelorderitemid=businessfieldcode_"_"_$lg(LisItemResultinfo,28)  //医嘱号
	s subobj.lisirrelitemid=businessfieldcode_"_"_subobj.lisirhositemid  //全局检验结果id
	s subobj.lisiritemabbrcode=""     //化验项目缩写
	s subobj.updatedate=$zd(+$h,3)
	s subobj.updatetime=$zt($p($h," ",2))
	quit subobj
}

/// /// 检验明细结果信息历史数据
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResultEns).getLisItemResulthistoryglobal("1","2952750")
ClassMethod getLisItemResulthistoryglobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("lisitemresult")=$lb("院内检验结果id","化验项目代码","化验项目描述","结果","单位","定性结果","扩展结果","结果说明","异常标志","参考范围","检测方法","检测仪器","检测人代码","显示序号（在同一报告id下自增）","检测日期","检测时间","细菌计数","专家规则","备注","时间戳","时间戳","检测人描述","国际代码","全局患者id","全局就诊id","全局检验报告号","业务域","院内检验结果id","全局医嘱明细id","化验项目缩写")
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set sum=endRowId-strRowId+1
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	for ReportResultDr=strRowId:1:endRowId{
		continue:$d(^Busi.ENS.EnsLISItemResultD(ReportResultDr))=0
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
		set subobj=..getLisItemResultinfoEns(ReportResultDr)
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

}
