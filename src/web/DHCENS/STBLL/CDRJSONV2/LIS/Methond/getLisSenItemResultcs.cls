Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultcs Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisSenItemResult).getLisSenItemResultCS("23130841||""G004""||1||""G0030""||""IPM""").Read()
ClassMethod getLisSenItemResult(lisSenResultRowid As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()	
	try{
		s lisSenResultRowid=$replace(lisSenResultRowid,$c(34),"")
		set subObj=..getLisSenItemResultinfo(lisSenResultRowid)
		d main.LisSenItemResultList.Insert(subObj)
	}
	catch{	
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

ClassMethod getLisSenItemResultinfo(lisSenResultDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult
{
	s labNo=$p(lisSenResultDr,"||",1)
	s labTSCode=$p(lisSenResultDr,"||",2)
	s labTSId=$p(lisSenResultDr,"||",3)
	s itemCode=$p(lisSenResultDr,"||",4)
	s ant=$p(lisSenResultDr,"||",5)
	s antname=""
	s ClsSeq=""
	s OEORDRowId=$o(^OEORD(0,"EpisNo",labNo,""))
	s temstr=^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"ANT",ant)
	// 抗生素名称
	if $d(^TTAB("ANT",ant)) set antname=$p(^TTAB("ANT",ant),"\",1)
	set antEname="",AntClssName=""
	// 英文名称
	if $d(^DHCANTIBIOTICS(ant)) set antEname=$p(^DHCANTIBIOTICS(ant),"\",1)
	if $l(antEname) s antname=antname_"("_antEname_")"
	set AntClass=""
	if $d(^DHCPharmicCategoryi("ANT",ant)) d
	.set AntClass=$o(^DHCPharmicCategoryi("ANT",ant,AntClass))
    .if AntClass'="" d
 	..set AntClssName=$p(^DHCPharmicCategory(AntClass),"\",1)
  	..set ClsSeq=$p(^DHCPharmicCategory(AntClass),"\",3)
  	.else  d
  	..set AntClass="ZOTHERS"
  	..set AntClssName="其它"
  	// 结果
	set temresCode=$p(temstr,"\",1) 
	// 激活标志
	set temreport=$p(temstr,"\",2)  
	// mic结果
	set temmic=$p(temstr,"\",3)   
	if $e(temmic,1)="." set temmic="0"_temmic
	// mm结果等同于KB
	set temmm=$p(temstr,"\",4)  
	if $e(temmm,1)="." set temmm="0"_temmm
	set temresDesc=""
	if temresCode="R" set temresDesc="耐药" 
	if temresCode="S" set temresDesc="敏感" 
	if temresCode="I" set temresDesc="中介"   
	s admNo=$p($g(^OEORD(OEORDRowId)),"^",1)	 				//就诊号
	s PatientId=$p($g(^PAADM(admNo)),"^",1)		  	
	s RegNo=$p($g(^PAPER(PatientId,"PAT",1)),"^",1)  // 登记号
	s reportid=labNo_"||"_labTSCode_"||"_labTSId
	s lisitemid=labNo_"||"_labTSCode_"||"_labTSId_"||"_itemCode
	s SenMethod=""
	s IRanges=""      // I折点
	s RRanges=""		// R折点
	s SRanges=""		// S折点
	s SenValue=""
	s MachSensitivityDR=""
	s MachSensitivityCode="",MachSensitivityDesc=""
	s subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
	set businessfieldcode=subObj.businessfieldcode
	s subObj.lisisrantibioticsclassdesc=AntClssName
	s subObj.lisisrantibioticsclassid=AntClass
	s subObj.lisisrantibioticscode=ant
	s subObj.lisisrantibioticsdesc=antname
	s subObj.lisisrflag="Y"
	s subObj.lisisrhosresultid=reportid
	s subObj.lisisriranges=IRanges
	s subObj.lisisrmethod=SenMethod
	s subObj.lisisrrelresultid=businessfieldcode_"_"_lisitemid
	s subObj.lisisrresult=temresCode
	s subObj.lisisrrranges=RRanges
	s subObj.lisisrsensitivitycode=""
	s subObj.lisisrsensitivitydesc=""
	s subObj.lisisrshowseq=ClsSeq
	s subObj.lisisrsranges=SRanges
	s subObj.lisisrsuggestion=""
	s subObj.lissrrellisreportid=businessfieldcode_"_"_reportid
	s subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
	s subObj.papatrelpatientid=businessfieldcode_"_"_PatientId
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h," ",2))
	quit subObj
}

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果历史数据Global
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultcs).getLisSenItemResulglobal("21012100001","0255156200")
ClassMethod getLisSenItemResulglobal(startid = "", endid = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	s (labRelatId,itemCode,ant)=""
	quit:(startid'="")||($d(^OEORD(0,"EpisNo",startid))) "startNo"
	quit:(endid'="")||($d(^OEORD(0,"EpisNo",endid))) "endNo"
	set LabNo=startid
	for{  
		set LabNo=$O(^OEORD(0,"EpisNo",LabNo)) 
	    q:LabNo=""
		set OEORDRowId=""
		for{
			set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId))
			q:OEORDRowId=""
			q:OEORDRowId=endid
			set OEORIChildsub=""
			for	{
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
					s ant=""
					for
					{
						s ant=$o(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"ANT",ant))
						q:ant=""
						set ReportResSenDr=labRelatId_"||"_itemCode_"||"_ant
						set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
						set subObj=..getLisSenItemResultinfo(ReportResSenDr)
						set ^ExportHistoryData("lisitemsenresult",ReportResSenDr)=$lb(subObj.lisisrhosresultid,subObj.lisisrantibioticscode,subObj.lisisrantibioticsdesc,subObj.lisisrresult,subObj.lisisrsensitivitycode,
																				subObj.lisisrsensitivitydesc,subObj.lisisriranges,subObj.lisisrsranges,subObj.lisisrrranges,subObj.lisisrshowseq,
																				subObj.lisisrmethod,subObj.lisisrsuggestion,subObj.lisisrflag,subObj.lisisrantibioticsclassid,subObj.lisisrantibioticsclassdesc,
																				subObj.updatedate,subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.lissrrellisreportid,
																				subObj.lisirrelitemid,subObj.businessfieldcode,subObj.lisisrrelresultid)
						set con=con+1
						set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(startid, endid, con, ReportResSenDr)
					}
				}
			}
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
