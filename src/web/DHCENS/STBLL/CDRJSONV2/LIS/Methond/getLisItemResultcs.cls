Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisItemResultcs Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日	
/// creator:zhibao
/// desc: 根据检验项目的明细id获取检验报告明细结果信息
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisItemResult).getLisItemResult("1")
ClassMethod getLisItemResult(LisItemDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()
	try{
		
		set subobj=..getLisItemResultinfoCS(LisItemDr)
		d main.LisItemResultList.Insert(subobj)
	}catch{ 
		///将来会在cache中做一些标记用于数据中心删除数据
		
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d stream.Write(JsonString)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisItemResult).getLisItemResultinfoCS("23154381||K092||1")
ClassMethod getLisItemResultinfoCS(LisItemDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult
{
	s LabNo=$p(LisItemDr,"||",1)
	s labTSCode=$p(LisItemDr,"||",2)
	s labTSId=$p(LisItemDr,"||",3)
	s itemCode=$p(LisItemDr,"||",4)
	
	set resultStr=$G(^TEPI(LabNo,"1",labTSCode,labTSId,"DATA",itemCode))
	// 序号
	set serialNo=$P(resultStr,"\",9)
	// 结果	
	set Result=$P(resultStr,"\",1)
  	/// 检验方法名称
  	set TestMethodDesc=""
  	set TestMethodDr=$p(^TTAB("TC",itemCode),"\",11)
  	set:TestMethodDr'="" TestMethodDesc=$p(^TTAB("METHOD",TestMethodDr),"\",1)  	
	//判断是否有药敏结果
	set AntResFlag=0
	if $d(^TEPI(LabNo,1,labTSCode,labTSId,"DATA",itemCode,"ANT")) set AntResFlag=1		 //微生物
	set receiveDate=$P($G(^TEPI(LabNo,1,labTSCode,labTSId)),"\",21)
	set resultStr=##Class(web.DHCLabTestCode).GetTestCodeResult(LabNo,itemCode,Result,receiveDate)
	Quit:resultStr=""
 	/// 检验结果项目描述
 	set itemDesc=$P(resultStr,$C(2),2)
 	/// 缩写
 	set abbreviation=$P(resultStr,$C(2),7)
 	/// 结果值
 	set TextRes=$P(resultStr,$C(2),3)
 	/// 单位
 	set Unit=$P(resultStr,$C(2),4)
 	/// 高低标识
 	set flagUpDown=$P(resultStr,$C(2),5)
 	/// 正常范围
 	set RefRanges=$P(resultStr,$C(2),6)
 	set warnFlag=$P(resultStr,$C(2),8) 
 	s Sequence=""
	if $d(^TTAB("TC",itemCode,1,labTSCode)) d
	.set itemOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",1)
 	.Quit:itemOrder=""
 	.set layOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",2)
 	.Quit:layOrder=""
  	.Quit:$G(^TTAB("TS",labTSCode,layOrder,itemOrder))=""  	
  	./// 检验结果项目序号
 	.set Sequence=$p(^TTAB("TS",labTSCode,layOrder,itemOrder),"\",15) 
 	
 	
 	s TestCodeCode=itemCode
 	s TestCodeName=itemDesc
	s ReportId=LabNo_"||"_labTSCode_"||"_labTSId									//条码号
	s OEORDRowId=$o(^OEORD(0,"EpisNo",LabNo,""))
	s AdmNo=$p($g(^OEORD(OEORDRowId)),"^",1)	 				//就诊号
	s PatientId=$p($g(^PAADM(AdmNo)),"^",1)		  	
	s RegNo=$p($g(^PAPER(PatientId,"PAT",1)),"^",1)  // 登记号
		
	s AssayDate=$p(^TEPI(LabNo,1,labTSCode,labTSId),"\",1)
	s AssayTime=$p(^TEPI(LabNo,1,labTSCode,labTSId),"\",2)
	s:AssayDate'="" AssayDate=$zd(AssayDate,3)    // 检验日期
	s:AssayTime'="" AssayTime=$zt(AssayTime*60)   // 检验时间
	set lisirremark=""
	set lisirresultexplain=""
	// 仪器代码、仪器名称 
	s MachineCode=$p(^TEPI(LabNo,1,labTSCode,labTSId),"\",27)  
	s machineDesc=""
	i $l(MachineCode) s machineDesc=$p($g(^TMIF(MachineCode)),"\",1)  
	
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()	
	s businessfieldcode=subobj.businessfieldcode
	s subobj.lisirabnormalflags=flagUpDown
	s subobj.lisircount=""
	s subobj.lisirextraresult=TextRes
	s subobj.lisirhositemid=LisItemDr
	//国际代码 
	s subobj.lisirintercode=""
	s subobj.lisiritemabbrcode=""
	s subobj.lisiritemcode=TestCodeCode
	s subobj.lisiritemdesc=TestCodeName
	s subobj.lisirranges=RefRanges
	s subobj.lisirrelitemid=businessfieldcode_"_"_LisItemDr
	s subobj.lisirremark=lisirremark
	s subobj.lisirresult=Result
	s subobj.lisirresultexplain=lisirresultexplain
	s subobj.lisirrule=""
	s subobj.lisirshowseq=Sequence
	s subobj.lisirtestdate=AssayDate
	s subobj.lisirtestmachine=machineDesc
	s subobj.lisirtestmethod=TestMethodDesc
	s subobj.lisirtesttime=AssayTime
	s subobj.lisirtestusercode=""
	s subobj.lisirtestusername=""
	s subobj.lisirtextresult=TextRes
	s subobj.lisirunit=Unit
	s subobj.lissrrellisreportid=businessfieldcode_"_"_ReportId
	s subobj.oeorirelorderitemid=""
	s subobj.paadmrelvisitnumber=businessfieldcode_"_"_AdmNo
	s subobj.papatrelpatientid=businessfieldcode_"_"_PatientId
	s subobj.updatedate=$zd(+$h,3)
	s subobj.updatetime=$zt($p($h," ",2))
	quit subobj
}

/// 检验明细结果信息历史数据
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisItemResult).getLisItemResulthistoryglobal("2018-12-10","2019-02-01")
ClassMethod getLisItemResulthistoryglobal(startNo = "", endNo = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("lisitemresult")=$lb("院内检验结果id","化验项目代码","化验项目描述","结果","单位","定性结果","扩展结果","结果说明","异常标志","参考范围","检测方法","检测仪器","检测人代码","显示序号（在同一报告id下自增）","检测日期","检测时间","细菌计数","专家规则","备注","时间戳","时间戳","检测人描述","国际代码","全局患者id","全局就诊id","全局检验报告号","业务域","院内检验结果id","全局医嘱明细id","化验项目缩写")
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	quit:(startNo'="")||($d(^OEORD(0,"EpisNo",startNo))) "startNo"
	quit:(endNo'="")||($d(^OEORD(0,"EpisNo",endNo))) "endNo"
	set LabNo=startNo
	for{  
		set LabNo=$O(^OEORD(0,"EpisNo",LabNo)) 
	    q:LabNo=""
	    q:LabNo=endNo
		set OEORDRowId=""
		for{
			set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId))
			q:OEORDRowId=""
			set OEORIChildsub=""
			for	
			{
				set OEORIChildsub=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId,OEORIChildsub)) 
				q:OEORIChildsub=""
				// 报告Id
				set labRelatId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",35)
				continue:labRelatId=""
				s labNo=$p(labRelatId,"||",1)
				s labTSCode=$p(labRelatId,"||",2)
				s labTSId=$p(labRelatId,"||",3)
				set itemCode=""
				for{
					s itemCode=$o(^TEPI(labNo,"1",labTSCode,labTSId,"DATA",itemCode))
					q:itemCode=""
					set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult).%New()	
					set subObj=..getLisItemResultinfoCS(labRelatId_"||"_itemCode)
		set ^ExportHistoryData("lisitemresult",ReportResultDr)=$lb(ReportResultDr,subobj.lisiritemcode,subobj.lisiritemdesc,subobj.lisirresult,subobj.lisirunit,
															subobj.lisirtextresult,subobj.lisirextraresult,subobj.lisirresultexplain,subobj.lisirabnormalflags,subobj.lisirranges,
															subobj.lisirtestmethod,subobj.lisirtestmachine,subobj.lisirtestusercode,subobj.lisirshowseq,subobj.lisirtestdate,
															subobj.lisirtesttime,subobj.lisircount,subobj.lisirrule,subobj.lisirremark,subobj.updatedate,
															subobj.updatetime,subobj.lisirtestusername,subobj.lisirintercode,subobj.papatrelpatientid,subobj.paadmrelvisitnumber,
															subobj.lissrrellisreportid,subobj.oeorirelorderitemid,subobj.lisiritemabbrcode,subobj.businessfieldcode,subobj.lisirrelitemid)
					set con=con+1
					i con#100=0 w "count:"_con_"    id:"_labRelatId_"||"_itemCode ,!
				}
			}
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
