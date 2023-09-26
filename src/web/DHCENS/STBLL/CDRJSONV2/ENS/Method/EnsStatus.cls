Class web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020—07-01
/// Description：获取状态信息
/// Table：
/// Input：状态ID
/// Return：状态数据
/// Others: 
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatus).EnsStatus("592367").Read()
ClassMethod EnsStatus(StatusID As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatus).%New()
	if (StatusID="")||($d(^Busi.ENS.EnsStatusD(StatusID))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GetEnsStatus(StatusID)
	d obj.ensstatusList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetEnsStatus(StatusID) As web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatus
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatus).%New()
	set ESOrdItemID=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),2)
	set ESOrdID=$p(ESOrdItemID,"||",1)
	set AdmDr=$p($g(^OEORD(ESOrdID)),"^",1)
	set PatDr=""
	set:AdmDr'="" PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set subObj.esexamid=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),3) //检查号/检验条码号/病理条码号
	set subObj.esexampart=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),4) //检查部位描述
	set subObj.esoperatorid=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),5) //操作员工号
	set subObj.esoperatorname=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),6) //操作员描述
	set ESOperateDate=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),7)
	set:ESOperateDate'="" subObj.esoperatedate=$zd(ESOperateDate,3) //操作日期
	set ESOperateTime=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),8)
	set:ESOperateTime'="" subObj.esoperatetime=$zt(ESOperateTime) //操作时间
	set ESStatusCode=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),9)
	set subObj.esoperatecode=ESStatusCode,ESStatusDr="" //当前状态代码
	set:ESStatusCode'="" ESStatusDr=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESStatusCode,""))
	set:ESStatusDr'="" subObj.esoperatedesc=$lg($g(^Code.ENS.EnsStatusCodeD(ESStatusDr)),9) //当前状态描述
	set subObj.esstatuscode=ESStatusCode
	set subObj.esstatusdesc=subObj.esoperatedesc
	set subObj.essystemcode=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),10) //系统代码
	set subObj.esprocess=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),11) //是否正流程
	set subObj.eseffectiveflag=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),12) //有效标志
	set subObj.esnote=$lg($g(^Busi.ENS.EnsStatusD(StatusID)),13) //备注
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode //业务域代码
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr //全局就诊id
	set subObj.papatrelpatientid=businessfieldcode_"_"_PatDr
	set subObj.oeorirelorderitemid=businessfieldcode_"_"_ESOrdItemID
	set subObj.oeorsupdatedate=$zd(+$h,3)
	set subObj.oeorsupdatetime=$zt($p($h," ",2))
	set subObj.eshosstatusid=StatusID
	set subObj.oeorsspecimencode=..GetLabSpec(ESOrdItemID,"2")
	quit subObj
}

ClassMethod GetLabSpec(OrderItemRowid As %String, HospitalId As %String = "") As %String
{
	
	s SpecStr=""
	s OrderRowid=$p(OrderItemRowid,"||",1)
	s Childsub=$p(OrderItemRowid,"||",2)
	if (HospitalId=""){
		s RecDr=$P($G(^OEORD(OrderRowid,"I",Childsub,3)),"^",6)
		s HospitalId=$P($G(^CTLOC(+RecDr)),"^",22)
	}
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
	s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
	. s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
	. i $d(^DHCLISBSVersion(1)) d
	.. s SpecDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,$g(HospitalCode)),$c(2),2) 
	. e  d
	.. s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
	. i SpecStr="" s SpecStr=SpecDesc
	. e  s SpecStr=SpecStr+","+SpecDesc
	Q SpecStr
}

/// / Creator：ZhangXinying
/// CreatDate：2020—07-01
/// Description：获取状态信息历史数据Global
/// Table：
/// Input：状态ID
/// Return：状态数据
/// Others: 
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatus).GetEnsStatusGlobal("1","592769")
ClassMethod GetEnsStatusGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("ensstatus")=$lb("ID","检查/检验/病理条码号","检查部位描述","操作员工号","操作员描述","操作日期","操作时间","当前状态代码","当前状态描述","系统代码","是否正流程","有效标志","备注","业务域_院内患者id","业务域_院内就诊号","全局医嘱明细id","业务域","标本类型")
	set sum=endRowId - strRowId +1
	set StatusID="",con=0,strtime=$zt($p($now(),",",2))
	for StatusID=strRowId:1:endRowId{
		continue:$d(^Busi.ENS.EnsStatusD(StatusID))=0
		set subObj=..GetEnsStatus(StatusID)
		set ^ExportHistoryData("ensstatus",StatusID)=$lb(StatusID,subObj.esexamid,subObj.esexampart,subObj.esoperatorid,subObj.esoperatorname,
														 subObj.esoperatedate,subObj.esoperatetime,subObj.esoperatecode,subObj.esoperatedesc,subObj.essystemcode,
														 subObj.esprocess,subObj.eseffectiveflag,subObj.esnote,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,
														 subObj.oeorirelorderitemid,subObj.businessfieldcode,subObj.oeorsspecimencode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, StatusID)		
		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
