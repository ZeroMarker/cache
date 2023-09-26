Class web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfoCISAN Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术记录信息 //获取CISAN包下手术记录信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OperRecordInfo).OperRecordJson(2).Read()
ClassMethod OperRecordJson(operlistid As %String = "") As %GlobalCharacterStream
{
	set $ZT="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	set subObj=..GetCISANOperRecord(operlistid)  //获取CISAN包下手术记录信息
	d obj.paoperationrecordList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术记录信息 历史数据Global
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfoCISAN).OperRecordGlobalhistory("1","18211")
ClassMethod OperRecordGlobalhistory(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("paoperationrecord")=$lb("院内手术id","手术开始日期","手术开始时间","手术结束日期","手术结束时间","手术代码","手术名称","术者工号","手术状态代码","手术级别","手术部位","手术体位","一助工号","二助工号","三助工号","器械护士工号","巡回护士工号","时间戳日期","时间戳时间","业务域_院内申请id","业务域_院内患者id","业务域_院内就诊号","术者姓名","手术状态描述","一助姓名","二助姓名","三助姓名","器械护士姓名","巡回护士姓名")
	set operlistid="",con=0,strtime=$zt($p($now(),",",2))
	for operlistid=strRowId:1:endRowId
	{
		set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
		continue:$d(^CIS.AN.OperScheduleD(operlistid))=0
		set operrecordjson=..GetCISANOperRecord(operlistid)  //获取CISAN包下手术记录信息
		set ^ExportHistoryData("paoperationrecord",operlistid)=$lb(operlistid,operrecordjson.paoroperstartdate,operrecordjson.paoroperstarttime,operrecordjson.paoroperenddate,operrecordjson.paoroperendtime,
																		operrecordjson.paoroperationcode,operrecordjson.paoroperationdesc,operrecordjson.paoroperdoccode,operrecordjson.paoroperstatuscode,operrecordjson.paoroperationlevel,
																		operrecordjson.paoroperationposition,operrecordjson.paoroperationposture,operrecordjson.paoroperfirassicode,operrecordjson.paoropersecassicode,operrecordjson.paoroperthirassicode,
																		operrecordjson.paorscrubnurcode,operrecordjson.paorcirculnurcode,operrecordjson.updatedate,operrecordjson.updatetime,operrecordjson.paoareloperappid,
																		operrecordjson.papatrelpatientid,operrecordjson.paadmrelvisitnumber,operrecordjson.paoroperdocname,operrecordjson.paoroperstatusdesc,operrecordjson.paoroperfirassiname,
																		operrecordjson.paoropersecassiname,operrecordjson.paoroperthirassiname,operrecordjson.paorscrubnurname,operrecordjson.paorcirculnurname,operrecordjson.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.common.common).point(strRowId, endRowId, con, operlistid)

	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfoCISAN).GetCISANOperRecord(12)
ClassMethod GetCISANOperRecord(operlistid) As web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord
{
	
	set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	set businessfieldcode=operrecordjson.businessfieldcode
	s sql="select b.OperDate as paoroperstartdate,b.OperTime as paoroperstarttime,a.Operation as operation,a.OperNote as opernote,"
	s sql=sql_"a.Surgeon as surgeon,b.Status as operstatus,a.OperClass as operclass,a.BodySite as bodysite,b.OperPosition as operpostion,"
	s sql=sql_"a.Assistant as assitant,b.ScrubNurse as scrubnurse,b.CircualNurse as circualnurse,b.RowId as operrowid,b.EpisodeID as paadmvisitnumber"
	s sql=sql_" from cis_an.operlist a left join cis_an.operschedule b on a.operschedule = b.rowid where a.rowid='"_operlistid_"'"
	s rset=##class(%Library.ResultSet).%New()
	b ;ends
	d rset.Prepare(sql)
	s rset.RuntimeMode=1
	s sc=rset.Execute()
	while rset.Next() {
		s operrecordjson.paorhosoperationid=operlistid
		s operrecordjson.paoroperstartdate=rset.Data("paoroperstartdate")
		s operrecordjson.paoroperstarttime=rset.Data("paoroperstarttime")
		s operrecordjson.paoroperenddate=""
		s operrecordjson.paoroperendtime=""
		s operationdr=rset.Data("operation")
		if (+operationdr'=0)&&($D(^CT.AN.OperationD(operationdr))) {
#;			s operrecordjson.paoroperationcode=$lg(^CT.AN.OperationD(operationdr),1)
			s operrecordjson.paoroperationcode=operationdr
			s operationdesc=$lg(^CT.AN.OperationD(operationdr),2)
			if operationdesc="" s operationdesc=rset.Data("opernote")
			if operrecordjson.paoroperationdesc=operationdesc
			}
		s operdocdrs=rset.Data("surgeon")
		s operdoccodes="",operdocnames=""
		if +operdocdrs'=0 {
			s operdocnums=$length(operdocdrs,",")
			f i=1:1:operdocnums {
				s operdocdr=$p(operdocdrs,",",i)
				continue:+operdocdr=0
#;				s operdoccode=$p($g(^CTPCP(operdocdr,1)),"^",1)
				s operdoccode=operdocdr
				s operdocname=$p($g(^CTPCP(operdocdr,1)),"^",2)
				if operdoccodes'="" s operdoccodes=operdoccodes_","_operdoccode
				else  s operdoccodes=operdoccode
				if operdocnames'="" s operdocnames=operdocnames_","_operdocname
				else  s operdocnames=operdocname
			}
			s operrecordjson.paoroperdoccode=operdoccodes
			s operrecordjson.paoroperdocname=operdocnames
		}
		s operstatusdr=rset.Data("operstatus")
		if +operstatusdr'=0 { 
#;			s operrecordjson.paoroperstatuscode=$lg(^CT.AN.OperStatusD(operstatusdr),1)
			s operrecordjson.paoroperstatuscode=operstatusdr
			s operrecordjson.paoroperstatusdesc=$lg(^CT.AN.OperStatusD(operstatusdr),2)
		}
		s paoroperationleveldr=rset.Data("operclass")
		s operrecordjson.paoroperationlevel=paoroperationleveldr
#;		if (+paoroperationleveldr'=0)&&($D(^CT.AN.OperClassD(paoroperationleveldr))) s operrecordjson.paoroperationlevel=$lg(^CT.AN.OperClassD(paoroperationleveldr),2)
		s paoroperationpositiondr=rset.Data("bodysite")
		s operrecordjson.paoroperationposition=paoroperationpositiondr
#;		if (+paoroperationpositiondr'=0)&&($D(^CT.AN.BodySiteD(paoroperationpositiondr))) s operrecordjson.paoroperationposition=$lg(^CT.AN.BodySiteD(paoroperationpositiondr),2)
		s operposturedr=rset.Data("operpostion")
		s operrecordjson.paoroperationposture=operposturedr
#;		if (+operposturedr'=0)&&($D(^CT.AN.OperPositionD(operposturedr))) s operrecordjson.paoroperationposture=$lg(^CT.AN.OperPositionD(operposturedr),2)
		s operfirassidrs=rset.Data("assitant")
		s operfirassicodes="",operfirassinames=""
		if +operfirassidrs'=0 {
			s operfirassinums=$length(operfirassidrs,",")
			f j=1:1:operfirassinums {
				s operfirassidr=$p(operfirassidrs,",",j)
				continue:+operfirassidr=0
#;				s operfirassicode=$p($g(^CTPCP(operfirassidr,1)),"^",1)
				s operfirassicode=operfirassidr
				s operfirassiname=$p($g(^CTPCP(operfirassidr,1)),"^",2)
				if operfirassicodes'="" s operfirassicodes=operfirassicodes_","_operfirassicode
				else  s operfirassicodes=operfirassicode
				if operfirassinames'="" s operfirassinames=operfirassinames_","_operfirassiname
				else  s operfirassinames=operfirassiname
			}
			s operrecordjson.paoroperfirassicode=operfirassicodes
			s operrecordjson.paoroperfirassiname=operfirassinames
		}
		s operrecordjson.paoropersecassicode=""
		s operrecordjson.paoropersecassiname=""
		s operrecordjson.paoroperthirassicode=""
		s operrecordjson.paoroperthirassiname=""
		s scrubnurdrs=rset.Data("scrubnurse")
		s scrubnurcodes="",scrubnurnames=""
		if +scrubnurdrs'=0 {
			s scrubnurnums=$length(scrubnurdrs,",")
			f k=1:1:scrubnurnums {
				s scrubnurdr=$p(scrubnurdrs,",",k)
				continue:+scrubnurdr=0
#;				s scrubnurcode=$p($g(^CTPCP(scrubnurdr,1)),"^",1)
				s scrubnurcode=scrubnurdr
				s scrubnurname=$p($g(^CTPCP(scrubnurdr,1)),"^",2)
				if scrubnurcodes'="" s scrubnurcodes=scrubnurcodes_","_scrubnurcode
				else  s scrubnurcodes=scrubnurcode
				if scrubnurnames'="" s scrubnurnames=scrubnurnames_","_scrubnurname
				else  s scrubnurnames=scrubnurname
			}
			s operrecordjson.paorscrubnurcode=scrubnurcodes
			s operrecordjson.paorscrubnurname=scrubnurnames
		}
		s circualnursedrs=rset.Data("circualnurse")
		s circualnursecodes="",circualnursenames=""
		if +scrubnurdrs'=0 {
			s circualnursenums=$length(circualnursedrs,",")
			f m=1:1:circualnursenums {
				s circualnursedr=$p(circualnursedrs,",",m)
				continue:+circualnursedr=0
#;				s circualnursecode=$p($g(^CTPCP(circualnursedr,1)),"^",1)
				s circualnursecode=circualnursedr
				s circualnursename=$p($g(^CTPCP(circualnursedr,1)),"^",2)
				if circualnursecodes'="" s circualnursecodes=circualnursecodes_","_circualnursecode
				else  s circualnursecodes=circualnursecode
				if circualnursenames'="" s circualnursenames=circualnursenames_","_circualnursename
				else  s circualnursenames=circualnursename
			}
			s operrecordjson.paorcirculnurcode=circualnursecodes
			s operrecordjson.paorcirculnurname=circualnursenames
		}
		s operrecordjson.updatedate=$zd(+$h,3)
		s operrecordjson.updatetime=$zt($p($h,",",2),1)
		s operrecordjson.paorreloperationid=businessfieldcode_"_"_operlistid
		s operrecordjson.paoareloperappid=businessfieldcode_"_"_rset.Data("operrowid")
		s paadmvisitnumber=rset.Data("paadmvisitnumber")
		s operrecordjson.paadmrelvisitnumber=businessfieldcode_"_"_paadmvisitnumber
		if +paadmvisitnumber'=0 s operrecordjson.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAADM(paadmvisitnumber)),"^",1)
	}
	quit operrecordjson
}

}
