Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmtransactionInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取转科记录表(ACC0005)
/// Table：pa_adm PA_AdmTransaction
/// Input：TRANSid：转移表id
/// Output：
/// Return：数据中心pa_admtransaction转科记录表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmtransactionInfo).paadmtransactionByAdm("1||1")
ClassMethod paadmtransactionByAdm(TRANSid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmTransaction).%New()
	set admRowId=+TRANSid
	set TRANSsub=$p(TRANSid,"||",2)
	if (TRANSid="")||($d(^PAADM(admRowId,"TRANS",TRANSsub))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..GettransactionInfo(TRANSid)
	d obj.PAAdmTransactionList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmInfo).GettransactionInfo(22)
ClassMethod GettransactionInfo(TRANSid) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmTransaction
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmTransaction).%New()
	set admRowId=+TRANSid
	set TRANSsub=$p(TRANSid,"||",2)
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId   //全局就诊id
	set subObj.paadmthostransid=TRANSid    //院内转科记录id
	set subObj.paadmtreltransid=businessfieldcode_"_"_TRANSid  //全局转科记录id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set paadmtdeptcode=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",6)
	set subObj.paadmtdeptcode=paadmtdeptcode
	set paadmtwardcode=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",9)
	set subObj.paadmtwardcode=paadmtwardcode
	set paadmtbedcod=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",8)
	set subObj.paadmtbedcode=paadmtbedcod
	set careprov=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",5)
	set subObj.paadmtdoccode=careprov
	set strdate=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",1)
	set strtime=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",2)
	set:strdate'="" strdate=$zd(strdate,3)  
	set:strtime'="" strtime=$zt(strtime) 
	set:(strdate'="")&&(strtime'="") subObj.paadmtstartdate=strdate_" "_strtime	//开始日期
	set enddate=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",3)
	set endtime=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",4)
	set:enddate'="" enddate=$zd(enddate,3)  
	set:endtime'="" endtime=$zt(endtime) 
	set:(enddate'="")&&(endtime'="") subObj.paadmtenddate=enddate_" "_endtime	//结束日期
	set:subObj.paadmtstartdate="" subObj.paadmtstartdate=subObj.paadmtenddate
	set paadmttypecode=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",12)
	set subObj.paadmttypecode=paadmttypecode
	set paadmtupdatedate=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",14)
	set:paadmtupdatedate'="" subObj.paadmtupdatedate=$zd(paadmtupdatedate,3)  //最后更新日期
	set paadmtupdatetime=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",15)
	set:paadmtupdatetime'="" subObj.paadmtupdatetime=$zt(paadmtupdatetime)    //最后更新时间
	set paadmtupdateusercode=$p($g(^PAADM(admRowId,"TRANS",TRANSsub)),"^",16)
	set subObj.paadmtupdateusercode=paadmtupdateusercode
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取转科记录表(ACC0005)历史数据Global
/// Table：pa_adm PA_AdmTransaction
/// Input：TRANSid：转移表id
/// Output：
/// Return：数据中心pa_admtransaction转科记录表(Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmtransactionInfo).paadmtransactionByAdmhistoryGlobal("1","6314734")
ClassMethod paadmtransactionByAdmhistoryGlobal(stradmRowId As %String, endadmRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("paadmtransaction")=$lb("院内转科记录id","科室代码","病区代码","床位代码","医生代码","开始日期","结束日期","转移类型","最后更新日期","最后更新时间","最后更新人编码","时间戳","时间戳","全局就诊id","全局患者id","业务域")
	if (stradmRowId="")||(endadmRowId="") {
	quit "-1^id不能为空"
	}
	set sum=endadmRowId-stradmRowId+1
	set admRowId="",con=0,strtime=$zt($p($now(),",",2))
	for admRowId=stradmRowId:1:endadmRowId{
		continue:$d(^PAADM(admRowId))=0
		set TRANSsub=0
		for {
			set TRANSsub=$o(^PAADM(admRowId,"TRANS",TRANSsub))
			quit:TRANSsub=""
			set TRANSid=admRowId_"||"_TRANSsub
			set subObj=..GettransactionInfo(TRANSid)
			set ^ExportHistoryData("paadmtransaction",TRANSid)=$lb(TRANSid,subObj.paadmtdeptcode,subObj.paadmtwardcode,subObj.paadmtbedcode,subObj.paadmtdoccode,
																   subObj.paadmtstartdate,subObj.paadmtenddate,subObj.paadmttypecode,subObj.paadmtupdatedate,
																   subObj.paadmtupdatetime,subObj.paadmtupdateusercode,subObj.updatedate,subObj.updatetime,
																   subObj.paadmrelvisitnumber,subObj.papatrelpatientid,subObj.paadmtreltransid,subObj.businessfieldcode)
			set con=con+1
			set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, admRowId)		
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
