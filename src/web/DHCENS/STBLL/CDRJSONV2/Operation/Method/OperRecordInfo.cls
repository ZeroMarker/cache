Class web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:liyan
/// CreateDate: 2021-1-4
/// Description: 手术记录信息 //获取OR_Anaest_Operation表手术记录信息
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfo).OperRecord("6283606||1||1").Read()
ClassMethod OperRecord(operlistid As %String = "") As %GlobalCharacterStream
{
	set $ZT="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	set subObj=..GetOperRecordORAnaestOperation(operlistid) //获取OR_Anaest_Operation表手术记录信息
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
/// Description: 手术记录信息 历史数据Global  OR_Anaest_Operation表
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Method.OperRecordInfo).ORAnOpOperRecordGlobalhistory("1","6314734")
ClassMethod ORAnOpOperRecordGlobalhistory(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("paoperationrecord")=$lb("院内手术id","手术开始日期","手术开始时间","手术结束日期","手术结束时间","手术代码","手术名称","术者工号","手术状态代码","手术级别","手术部位","手术体位","一助工号","二助工号","三助工号","器械护士工号","巡回护士工号","时间戳日期","时间戳时间","业务域_院内申请id","业务域_院内患者id","业务域_院内就诊号","术者姓名","手术状态描述","一助姓名","二助姓名","三助姓名","器械护士姓名","巡回护士姓名")
	set sum=endRowId-strRowId+1
	set EpisodeID="",con=0,strtime=$zt($p($now(),",",2))
	for EpisodeID=strRowId:1:endRowId
	{
		continue:$d(^OR(EpisodeID))=0
		set anaSub=0
		for {
			s anaSub=$o(^OR(EpisodeID,"ANA",anaSub))
			quit:anaSub=""
			set anaopSub=0
			for {
				set operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
				set anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub))
				quit:anaopSub=""
				set operlistid=EpisodeID_"||"_anaSub_"||"_anaopSub
				set operrecordjson=..GetOperRecordORAnaestOperation(operlistid)  //获取OR_Anaest_Operation表下手术记录信息
				;continue:operrecordjson.err="Y"
				set ^ExportHistoryData("paoperationrecord",operlistid)=$lb(operlistid,operrecordjson.paoroperstartdate,operrecordjson.paoroperstarttime,operrecordjson.paoroperenddate,operrecordjson.paoroperendtime,
																		operrecordjson.paoroperationcode,operrecordjson.paoroperationdesc,operrecordjson.paoroperdoccode,operrecordjson.paoroperstatuscode,operrecordjson.paoroperationlevel,
																		operrecordjson.paoroperationposition,operrecordjson.paoroperationposture,operrecordjson.paoroperfirassicode,operrecordjson.paoropersecassicode,operrecordjson.paoroperthirassicode,
																		operrecordjson.paorscrubnurcode,operrecordjson.paorcirculnurcode,operrecordjson.updatedate,operrecordjson.updatetime,operrecordjson.paoareloperappid,
																		operrecordjson.papatrelpatientid,operrecordjson.paadmrelvisitnumber,operrecordjson.paoroperdocname,operrecordjson.paoroperstatusdesc,operrecordjson.paoroperfirassiname,
																		operrecordjson.paoropersecassiname,operrecordjson.paoroperthirassiname,operrecordjson.paorscrubnurname,operrecordjson.paorcirculnurname,operrecordjson.businessfieldcode,
																		operrecordjson.paorreloperationid)
				set con=con+1
				set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, operlistid)
			}
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.OperRecordInfo).GetOperRecordORAnaestOperation("1||1||1")
ClassMethod GetOperRecordORAnaestOperation(operlistid) As web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord
{
	s operrecordjson=##class(web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord).%New()
	s operrecordjson.paorhosoperationid=operlistid
	s businessfieldcode=operrecordjson.businessfieldcode
	s EpisodeID=+operlistid
	s anaSub=$p(operlistid,"||",2)
	s anaopSub=$p(operlistid,"||",3)
	s ANARowId=EpisodeID_"||"_anaSub
	set opRowId=""
	&sql(select OPA_RowId into:opRowId from SQLUser.DHC_AN_OPArrange where OPA_Anaest_Dr =:ANARowId)
	quit:opRowId="" operrecordjson ;operrecordjson.err="Y"
	s operrecordjson.paoroperstartdate=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",13) //手术开始日期
	s operrecordjson.paoroperstarttime=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",2)  //手术开始时间
	s operrecordjson.paoroperenddate=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",16) //手术结束日期
	s operrecordjson.paoroperendtime=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",3) //手术结束时间
	s operationdr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",6)
	s operrecordjson.paoroperationcode=""
	s operrecordjson.paoroperationdesc=""
	if (+operationdr'=0) {
#;		s operrecordjson.paoroperationcode=$P($g(^ORC("OPER",operationdr)),"^",1)   //手术代码
		s operrecordjson.paoroperationcode=operationdr
		s operrecordjson.paoroperationdesc=$P($g(^ORC("OPER",operationdr)),"^",2)
	}
	s:operrecordjson.paoroperationdesc="" operrecordjson.paoroperationdesc=$G(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub,"REM",2))  //手术名称
	s operdocdr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",8)
	s operrecordjson.paoroperdoccode=""
	s operrecordjson.paoroperdocname=""
	if +operdocdr'=0 {
#;		s operrecordjson.paoroperdoccode=$p($g(^CTPCP(operdocdr,1)),"^",1)
		s operrecordjson.paoroperdoccode=operdocdr
		s operrecordjson.paoroperdocname=$p($g(^CTPCP(operdocdr,1)),"^",2)
	}
	s operrecordjson.paoroperstatuscode=$P(^DHCANOPArrange(opRowId),"^",27)  //手术状态代码
	s operrecordjson.paoroperationlevel=""
	s paoroperationlevel=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub,"DHC")),"^",1) 
#;	s:+paoroperationlevel'=0 operrecordjson.paoroperationlevel=$p($g(^DHCANC("OPLevel",paoroperationlevel)),"^",2) //手术级别
	s operrecordjson.paoroperationlevel=paoroperationlevel
	s operpositiondr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub)),"^",24)  
#;	if +operpositiondr'=0 s operrecordjson.paoroperationposition=$p($g(^OEC("BODS",operpositiondr)),"^",2) //手术部位
	s operrecordjson.paoroperationposition=operpositiondr
	s OPPOSChildsub="",operationposturedescs="",operationposturedesc=""
	s operrecordjson.paoroperationposture=""
	for { 
		s OPPOSChildsub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",OPPOSChildsub))
		q:OPPOSChildsub=""
		s operationposturedrs=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"POS",OPPOSChildsub)),"^",1)
		if +operationposturedrs'=0 {
			s operationposturedesc=$p($g(^ORC("OPPOS",operationposturedrs)),"^",2)
			if operationposturedescs'="" s operationposturedescs=operationposturedescs_","_operationposturedesc
			else  s operationposturedescs=operationposturedesc 
		}		
	}
	s operrecordjson.paoroperationposture=operationposturedescs  //手术体位	
	s operrecordjson.paoroperfirassicode=""
	s operrecordjson.paoroperfirassiname=""
	s operrecordjson.paoropersecassicode=""
	s operrecordjson.paoropersecassiname=""
	s operrecordjson.paoroperthirassicode=""
	s operrecordjson.paoroperthirassiname=""
	if $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",1)){
		s operfirassidr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",1)),"^",1)
#;		s operrecordjson.paoroperfirassicode=$p($g(^CTPCP(operfirassidr,1)),"^",1)
		s operrecordjson.paoroperfirassicode=operfirassidr
		s:operfirassidr'="" operrecordjson.paoroperfirassiname=$p($g(^CTPCP(operfirassidr,1)),"^",2)
		}
	if $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",2)){
		s opersecassidr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",2)),"^",1)
#;		s operrecordjson.paoropersecassicode=$p($g(^CTPCP(opersecassidr,1)),"^",1)
		s operrecordjson.paoropersecassicode=opersecassidr
		s:opersecassidr'="" operrecordjson.paoropersecassiname=$p($g(^CTPCP(opersecassidr,1)),"^",2)
		}
	if $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",3)){
		s perthirassidr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",3)),"^",1)
#;		s operrecordjson.paoroperthirassicode=$p($g(^CTPCP(perthirassidr,1)),"^",1)
		s operrecordjson.paoroperthirassicode=perthirassidr
		s:perthirassidr'="" operrecordjson.paoroperthirassiname=$p($g(^CTPCP(perthirassidr,1)),"^",2)
		}
	s qx=0 ,paorscrubnurcode="" ,paorscrubnurcodes="" ,paorscrubnurname="" ,paorscrubnurnames=""
	for {
		s qx=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",qx))
		quit:qx=""
		if qx'=""{
#;			s paorscrubnurcode=$p($g(^CTPCP(qx,1)),"^",1)
			S paorscrubnurcode=qx
			s paorscrubnurname=$p($g(^CTPCP(qx,1)),"^",2)
			if paorscrubnurcodes'="" s paorscrubnurcodes=paorscrubnurcodes_","_paorscrubnurcode
			else  s paorscrubnurcodes=paorscrubnurcode
			if paorscrubnurnames'="" s paorscrubnurnames=paorscrubnurnames_","_paorscrubnurname
			else  s paorscrubnurnames=paorscrubnurname
		}
	}
	s operrecordjson.paorscrubnurcode=paorscrubnurcodes  //器械护士工号
	s operrecordjson.paorscrubnurname=paorscrubnurnames  //器械护士
	s xc=0 ,paorcirculnurcode="" ,paorcirculnurcodes="" ,paorcirculnurname="" ,paorcirculnurnames=""
	for {
		s xc=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc))
		quit:xc=""
		if xc'=""{
#;			s paorcirculnurcode=$p($g(^CTPCP(xc,1)),"^",1)
			s paorcirculnurcode=xc
			s paorcirculnurname=$p($g(^CTPCP(xc,1)),"^",2)
			if paorcirculnurcodes'="" s paorcirculnurcodes=paorcirculnurcodes_","_paorcirculnurcode
			else  s paorcirculnurcodes=paorcirculnurcode
			if paorcirculnurnames'="" s paorcirculnurnames=paorcirculnurnames_","_paorcirculnurname
			else  s paorcirculnurnames=paorcirculnurname
		}
	}
	s operrecordjson.paorcirculnurcode=paorcirculnurcodes  //巡回护士工号
	s operrecordjson.paorcirculnurname=paorcirculnurnames  //巡回护士
	s operrecordjson.updatedate=$zd(+$h,3)
	s operrecordjson.updatetime=$zt($p($h,",",2),1)
	s operrecordjson.paorreloperationid=businessfieldcode_"_"_operlistid
	s operrecordjson.paoareloperappid=businessfieldcode_"_"_opRowId
	s operrecordjson.paadmrelvisitnumber=businessfieldcode_"_"_EpisodeID
	if +EpisodeID'=0 s operrecordjson.papatrelpatientid=businessfieldcode_"_"_$p($g(^PAADM(EpisodeID)),"^",1)
	q operrecordjson
}

}
