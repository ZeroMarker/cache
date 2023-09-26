Class web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatusLog Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2020—07-01
/// Description：获取状态信息
/// Table：
/// Input：状态ID
/// Return：状态数据
/// Others: 
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatusLog).EnsStatusLog("7")
ClassMethod EnsStatusLog(StatusLogID As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatuslog).%New()
	if (StatusLogID="")||($d(^Busi.ENS.EnsStatusLogD(StatusLogID))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GetEnsStatusLog(StatusLogID)
	d obj.ensstatuslogList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetEnsStatusLog(StatusLogID) As web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatuslog
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatuslog).%New()
	set ESOrdItemID=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),2)
	set ESOrdID=$p(ESOrdItemID,"||",1)
	set AdmDr=$p($g(^OEORD(ESOrdID)),"^",1)
	set PatDr=""
	set:AdmDr'="" PatDr=$p($g(^PAADM(AdmDr)),"^",1)
	set subObj.eshosstatuslogid=StatusLogID
	set subObj.esexamid=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),3) //检查号/检验条码号/病理条码号
	set subObj.esexampart=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),4) //检查部位描述
	set subObj.esoperatorid=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),5) //操作员工号
	set subObj.esoperatorname=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),6) //操作员描述
	set ESOperateDate=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),7)
	set:ESOperateDate'="" subObj.esoperatedate=$zd(ESOperateDate,3) //操作日期
	set ESOperateTime=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),8)
	set:ESOperateTime'="" subObj.esoperatetime=$zt(ESOperateTime) //操作时间
	set ESStatusCode=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),9)
	set subObj.esoperatecode=ESStatusCode //当前状态代码
	set subObj.esstatuscode=ESStatusCode
	set:ESStatusCode'="" ESStatusDr=$o(^Code.ENS.EnsStatusCodeI("IndexESCCode",ESStatusCode,""))
	set:ESStatusDr'="" subObj.esoperatedesc=$lg($g(^Code.ENS.EnsStatusCodeD(ESStatusDr)),9) //当前状态描述
	set subObj.essystemcode=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),10) //系统代码
	set subObj.esstatuscode=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),11) //变更后状态代码
	set subObj.esprestatuscode=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),12) //当前状态代码
	set subObj.esexampartid=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),13) //部位id
	set subObj.esnote=$lg($g(^Busi.ENS.EnsStatusLogD(StatusLogID)),14) //备注
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode //业务域代码
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmDr //全局就诊id
	set subObj.papatrelpatientid=businessfieldcode_"_"_PatDr
	else  set subObj.papatrelpatientid=""
	set subObj.oeorsupdatedate=$zd(+$h,3)
	set subObj.oeorsupdatetime=$zt($p($h," ",2))
	set subObj.oeorirelorderitemid=businessfieldcode_"_"_ESOrdItemID
	quit subObj
}

/// Creator：ZhangXinying
/// CreatDate：2020—07-01
/// Description：获取状态信息历史数据Global
/// Table：
/// Input：状态ID
/// Return：状态数据JSON
/// Others: 
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.ENS.Method.EnsStatusLog).GetEnsStatusLogGlobal("1","2166878")
ClassMethod GetEnsStatusLogGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("EnsStatusLog")=$lb("ID","检查/检验/病理条码号","检查部位描述","操作员工号","操作员描述","操作日期","操作时间","操作代码","操作描述","系统代码","变更后状态代码","当前状态代码","部位id","备注","业务域_院内患者id","业务域_院内就诊号","全局医嘱明细id","时间戳日期","时间戳时间")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set StatusLogID="",con=0,strtime=$zt($p($now(),",",2))
	set sum=endRowId-strRowId+1
	for StatusLogID=strRowId:1:endRowId{
		continue:$d(^Busi.ENS.EnsStatusLogD(StatusLogID))=0
		set subObj=..GetEnsStatusLog(StatusLogID)
		set paadmrelvisitnumber= $p(subObj.paadmrelvisitnumber,"_",2)
		set ^ExportHistoryData("EnsStatusLog",StatusLogID)=$lb(StatusLogID,subObj.esexamid,subObj.esexampart,subObj.esoperatorid,subObj.esoperatorname,
														subObj.esoperatedate,subObj.esoperatetime, subObj.esoperatecode,subObj.esoperatedesc,subObj.essystemcode,
														subObj.esstatuscode,subObj.esprestatuscode,subObj.esexampartid,subObj.esnote,subObj.papatrelpatientid,
														subObj.paadmrelvisitnumber,subObj.oeorirelorderitemid,subObj.businessfieldcode)
		set con=con+1
		set now=endRowId-StatusLogID
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, StatusLogID)		

		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
