Class web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfoDHCAN Extends (%RegisteredObject, %XML.Adaptor)
{

// Creator:liyan

/// CreateDate: 2021-1-4
/// Description: 手术记录信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OperRecordInfo).OperRecordJson(2).Read()
ClassMethod OperRecordJson(operlistid As %String = "") As %GlobalCharacterStream
{
	set $ZT="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	set subObj=..GetDHCANOperRecord(operlistid)  //获取DHCAN包下手术记录信息
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
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OperRecordInfo).CISANOperRecordGlobalhistory("2","10").Read()
ClassMethod OperRecordGlobalhistory(strRowId As %String, endRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("paoperationrecord")=$lb("院内手术id","手术开始日期","手术开始时间","手术结束日期","手术结束时间","手术代码","手术名称","术者工号","手术状态代码","手术级别","手术部位","手术体位","一助工号","二助工号","三助工号","器械护士工号","巡回护士工号","时间戳日期","时间戳时间","业务域_院内申请id","业务域_院内患者id","业务域_院内就诊号","术者姓名","手术状态描述","一助姓名","二助姓名","三助姓名","器械护士姓名","巡回护士姓名")
	set sum=endRowId-strRowId+1
	set operlistid="",con=0,strtime=$zt($p($now(),",",2))
	for operlistid=strRowId:1:endRowId
	{
		set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
		set operrecordjson=..GetDHCANOperRecord(operlistid)  //获取DHCAN包下手术记录信息
		set ^ExportHistoryData("paoperationrecord",operlistid)=$lb(operlistid,operrecordjson.paoroperstartdate,operrecordjson.paoroperstarttime,operrecordjson.paoroperenddate,operrecordjson.paoroperendtime,
																		operrecordjson.paoroperationcode,operrecordjson.paoroperationdesc,operrecordjson.paoroperdoccode,operrecordjson.paoroperstatuscode,operrecordjson.paoroperationlevel,
																		operrecordjson.paoroperationposition,operrecordjson.paoroperationposture,operrecordjson.paoroperfirassicode,operrecordjson.paoropersecassicode,operrecordjson.paoroperthirassicode,
																		operrecordjson.paorscrubnurcode,operrecordjson.paorcirculnurcode,operrecordjson.updatedate,operrecordjson.updatetime,operrecordjson.paoareloperappid,
																		operrecordjson.papatrelpatientid,operrecordjson.paadmrelvisitnumber,operrecordjson.paoroperdocname,operrecordjson.paoroperstatusdesc,operrecordjson.paoroperfirassiname,
																		operrecordjson.paoropersecassiname,operrecordjson.paoroperthirassiname,operrecordjson.paorscrubnurname,operrecordjson.paorcirculnurname,operrecordjson.businessfieldcode)
		set con=con+1
		set now=endRowId-operlistid
		set percentage=$fn((1-(now/sum))*100,"",2)_"%"
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, operlistid)
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod GetDHCANOperRecord(operlistid As %String = "") As web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord
{
	set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	s sql="select b.operstartdt as paoroperstartdt,b.operfinishdt as paoroperenddt, a.operation as operation,a.opernote as opernote,"
	s sql=sql_"a.surgeon as surgeon,b.status as operstatus,a.operclass as operclass,a.bodysite as bodysite,b.operposition as operpostion,"
	s sql=sql_"a.assistant as assitant,b.scrubnurse as scrubnurse,b.circualnurse as circualnurse,b.rowid as operrowid,b.episodeid as paadmvisitnumber"
	s sql=sql_" from dhcan_model.operlist a left join dhcan_model.operschedule b on a.operschedule = b.rowid where a.rowid='"_operlistid_"'"
	s rset=##class(%Library.ResultSet).%New()
	d rset.Prepare(sql)
	s rset.RuntimeMode=1
	s sc=rset.Execute()
	while rset.Next() {
		s operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.paoperationrecord).%New()
		s operrecordjson.paorhosoperationid=operlistid
		s businessfieldcode=operrecordjson.businessfieldcode
		s operrecordjson.paoroperstartdate=$p(rset.Data("paoroperstartdt")," ",1)
		s operrecordjson.paoroperstarttime=$p(rset.Data("paoroperstartdt")," ",2)
		s operrecordjson.paoroperenddate=$p(rset.Data("paoroperenddt")," ",1)
		s operrecordjson.paoroperendtime=$p(rset.Data("paoroperenddt")," ",2)
		s operationdr=rset.Data("operation")
		if (+operationdr'=0)&&($D(^DHCAN.Code.OperationD(operationdr))) {
#;			s operrecordjson.paoroperationcode=$LG(^DHCAN.Code.OperationD(operationdr),10)
			s operrecordjson.paoroperationcode=operationdr
			s operationdesc=$LG(^DHCAN.Code.OperationD(operationdr),1)
			if operationdesc="" s operationdesc=rset.Data("opernote")
			if operrecordjson.paoroperationdesc=operationdesc
			}
		s operdocdr=rset.Data("surgeon")
		if +operdocdr'=0 {
#;			s operrecordjson.paoroperdoccode=$p($g(^CTPCP(operdocdr,1)),"^",1)
			s operrecordjson.paoroperdoccode=operdocdr
			s operrecordjson.paoroperdocname=$p($g(^CTPCP(operdocdr,1)),"^",2)
		}
		s operstatusdr=rset.Data("operstatus")
		if +operstatusdr'=0 {
#;			s operrecordjson.paoroperstatuscode=$LG(^DHCAN.Code.OperStatusD(operstatusdr),1)
			s operrecordjson.paoroperstatuscode=operstatusdr
			s operrecordjson.paoroperstatusdesc=$LG(^DHCAN.Code.OperStatusD(operstatusdr),2)
		}
		s operleveldr=rset.Data("operclass")
#;		if +operleveldr'=0 s operrecordjson.paoroperationlevel=$LG(^DHCAN.Code.OperClassD(operleveldr),2)
		s operrecordjson.paoroperationlevel=operleveldr
		s operpositiondr=rset.Data("bodysite")
#;		if +operpositiondr'=0 s operrecordjson.paoroperationposition=$LG(^DHCAN.Code.BodySiteD(operpositiondr),2)
		s operrecordjson.paoroperationposition=operpositiondr
		s operationposturedrs=rset.Data("operpostion")
		s operationposturedescs="",operationposturedesc=""
		if +operationposturedrs'=0 {
			s len=$length(operationposturedrs,",")
			f i=1:1:len {
				s operationposturedr=$p(operationposturedrs,",",i)
				continue:+operationposturedr=0
				s operationposturedesc=$LG(^DHCAN.Code.OperPositionD(operpositiondr),2)
				if operationposturedescs'="" s operationposturedescs=operationposturedescs_","_operationposturedesc
				else  s operationposturedescs=operationposturedesc
			}
			s operrecordjson.paoroperationposture=operationposturedescs
		}
		s operfirassidr=rset.Data("assitant")
		if +operfirassidr'=0 {
#;			s operrecordjson.paoroperfirassicode=$p($g(^CTPCP(operfirassidr,1)),"^",1)
			s operrecordjson.paoroperfirassicode=operfirassidr
			s operrecordjson.paoroperfirassiname=$p($g(^CTPCP(operfirassidr,1)),"^",2)
		}
		s operrecordjson.paoropersecassicode=""
		s operrecordjson.paoropersecassiname=""
		s operrecordjson.paoroperthirassicode=""
		s operrecordjson.paoroperthirassiname=""
		s scrubnurdr=rset.Data("scrubnurse")
		if +scrubnurdr'=0 {
#;			s operrecordjson.paorscrubnurcode=$p($g(^CTPCP(scrubnurdr,1)),"^",1)
			s operrecordjson.paorscrubnurcode=scrubnurdr
			s operrecordjson.paorscrubnurname=$p($g(^CTPCP(scrubnurdr,1)),"^",2)
		}	
		s circualnursedr=rset.Data("circualnurse")
		if +circualnursedr'=0 {
#;			s operrecordjson.paorcirculnurcode=$p($g(^CTPCP(circualnursedr,1)),"^",1)
			s operrecordjson.paorcirculnurcode=circualnursedr
			s operrecordjson.paorcirculnurname=$p($g(^CTPCP(circualnursedr,1)),"^",2)
		}
		s operrecordjson.updatedate=$zd(+$h,3)
		s operrecordjson.updatetime=$zt($p($h,",",2),1)
		s operrecordjson.paorreloperationid=businessfieldcode_"_"_operlistid
		s operrecordjson.paoareloperappid=businessfieldcode_"_"_rset.Data("operrowid")
		s paadmvisitnumber=rset.Data("paadmvisitnumber")
		s operrecordjson.paadmrelvisitnumber=businessfieldcode_"_"_paadmvisitnumber
		if +paadmvisitnumber'=0 s operrecordjson.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAADM(paadmvisitnumber)),"^",1)
	}
	q operrecordjson
}

}
