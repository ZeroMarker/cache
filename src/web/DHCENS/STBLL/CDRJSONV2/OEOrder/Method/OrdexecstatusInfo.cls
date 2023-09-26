Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecstatusInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-01-14
/// Description：根据id取医嘱执行记录状态变更表(ACC0010)
/// Table：OE_OrdExecStatus
/// Input：医嘱执行记录zhuangt rowid
/// Output：
/// Return：数据中心oe_ordexecstatus 医嘱执行记录状态变更表(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecstatusInfo).GetOrdExecStatus("	30389800||443||1||1")
ClassMethod GetOrdExecStatus(STCHRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus).%New()
	set ordID=$p(STCHRowId,"||",1),ordSub=$p(STCHRowId,"||",2),ordExec=$p(STCHRowId,"||",3),STCHsub=$p(STCHRowId,"||",3)
	set ordRowId=ordID_"||"_ordSub
	set ordexecId=ordID_"||"_ordSub_"||"_ordExec
	if (STCHRowId="") {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	//执行状态 
	set subObj=..GetordexeSTcinfo(STCHRowId)
	d obj.oeordexecstatusList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

ClassMethod GetordexeSTcinfo(STCHRowId) As web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus
{
	
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus).%New()
	set businessfieldcode=subObj.businessfieldcode
	set ordID=$p(STCHRowId,"||",1),ordSub=$p(STCHRowId,"||",2),ordExec=$p(STCHRowId,"||",3),STCHsub=$p(STCHRowId,"||",3)
	set ordRowId=ordID_"||"_ordSub
	set ordexecId=ordID_"||"_ordSub_"||"_ordExec
	set STCHAdminStatusDR=$p($g(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",STCHsub)),"^",1)
	set:STCHAdminStatusDR'="" subObj.oeoesadminstatuscode=$p($g(^OEC("STAT",STCHAdminStatusDR)),"^",1)
	set subObj.oeoesreasoncode=$p($g(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",STCHsub)),"^",2)  //修改原因
	set STCHUserDR=$p($g(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",STCHsub)),"^",5)
	set subObj.oeoesupdateusercode=STCHUserDR
	set oeoesupdatedate=$p($g(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",STCHsub)),"^",3)
	set:oeoesupdatedate'="" subObj.oeoesupdatedate=$zd(oeoesupdatedate,3) //最后更新日期
	set oeoesupdatetime=$p($g(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",STCHsub)),"^",4)
	set:oeoesupdatetime'="" subObj.oeoesupdatetime=$zt(oeoesupdatetime) // 最后更新时间
	set admRowId=$p($g(^OEORD(ordID)),"^",1) 
	set patID=$p($g(^PAADM(admRowId)),"^",1)
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set subObj.oeoeshosexecstatusid=STCHRowId //院内执行记录状态变更id
	set subObj.oeoesrelexecstatusid=businessfieldcode_"_"_STCHRowId //全局执行记录状态变更id
	set subObj.oeorerelexecid=businessfieldcode_"_"_ordexecId    //业务域_院内医嘱执行记录id
	set subObj.papatrelpatientid=businessfieldcode_"_"_patID //业务域_院内患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId         //业务域_院内就诊号
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-01-14
/// Description：根据id取医嘱执行记录状态变更表(ACC0010)历史数据Global
/// Table：OE_OrdExecStatus
/// Input：医嘱执行记录zhuangt rowid
/// Output：
/// Return：数据中心oe_ordexecstatus 医嘱执行记录状态变更表(Global)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Method.OrdexecstatusInfo).GetOrdExecStatusGlobal("2017-08-31","2022-02-25")
ClassMethod GetOrdExecStatusGlobal(strdate As %String, enddate As %String) As %String
{
	set $zt="Exception" 
	set ^ExportHistoryData("OEOrdExecStatus")=$lb("院内执行记录状态变更id","执行状态","修改原因","最后更新人编码","最后更新日期","最后更新时间","时间戳","时间戳","院内医嘱执行记录id","院内患者id","院内就诊号")
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus).%New()
	if (strdate="")||(enddate="") {
		quit "-1^入参不能为空"
	}
	set:strdate["-" strdate=$zdh(strdate,3)
	set:enddate["-" enddate=$zdh(enddate,3)
	set con=0,strtime=$zt($p($now(),",",2))
	set OEORIDate=""
	for OEORIDate=strdate:1:enddate{	
		set ordID=""
		for{
			set ordID=$o(^OEORDi(0,"ItemDate",OEORIDate,ordID)) 
			quit:ordID=""
			continue:$d(^OEORD(ordID))=0
			set ordSub=""
			for {
				set ordSub=$o(^OEORDi(0,"ItemDate",OEORIDate,ordID,ordSub))
				quit:ordSub=""
				continue:$d(^OEORD(ordID,"I",ordSub))=0
				set ordExec=0
				for {
					set ordExec=$o(^OEORD(ordID,"I",ordSub,"X",ordExec))
					quit:ordExec=""
					continue:$d(^OEORD(ordID,"I",ordSub,"X",ordExec))=0
					set OrdSTCH=0
					for{
						set OrdSTCH=$o(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",OrdSTCH))
						quit:OrdSTCH=""
						continue:$d(^OEORD(ordID,"I",ordSub,"X",ordExec,"STCH",OrdSTCH))=0
						set STCHRowId=ordID_"||"_ordSub_"||"_ordExec_"||"_OrdSTCH
						set con=con+1
						set subObj=..GetordexeSTcinfo(STCHRowId)
						set ^ExportHistoryData("OEOrdExecStatus",STCHRowId)=$lb(STCHRowId,subObj.oeoesadminstatuscode,subObj.oeoesreasoncode,subObj.oeoesupdateusercode,
																				subObj.oeoesupdatedate,subObj.oeoesupdatetime,subObj.updatedate,subObj.updatetime,
																				subObj.oeoesrelexecstatusid,subObj.oeorerelexecid,
																				subObj.paadmrelvisitnumber,subObj.papatrelpatientid,subObj.businessfieldcode)
						set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strdate, enddate, con, OEORIDate)
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
