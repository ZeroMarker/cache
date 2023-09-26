Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PaidentifierInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取患者证件表(ACC0002)
/// Table：PA_PatMas pa_person dhc_person
/// Input：patRowId：患者ID
/// Output：
/// Return：数据中心pa_identifier患者证件表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PaidentifierInfo).paidentifierById("10480000")
ClassMethod paidentifierById(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paidentifier).%New()
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		d stream.Write("{""theme"":""theme001"",""error""patRowId病人id不能为空"":"",""data"":[]}")
		quit stream	
	}
	set subObj=..getSubpaidentifier(patRowId)
	d obj.PaidentifierList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream

Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo).getSubpaidentifier(10).XMLExport()
ClassMethod getSubpaidentifier(patRowId) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paidentifier
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paidentifier).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
	set papatidno=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	set subObj.papatidtypecode="",subObj.papatidno="",subObj.papatidupdateusercode="",subObj.papatidupdatedate="",subObj.papatidupdatetime=""
	if papatidno'="" {
		set:CredentialTypeRowID="" subObj.papatidtypecode=1
		if CredentialTypeRowID'="" {
#;			set subObj.papatidtypecode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)  //证件类型
			set subObj.papatidtypecode=CredentialTypeRowID
			set subObj.papatidno=papatidno   //证件号码
		}
	}
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)      //最后更新人编码
#;	set:UpdateUserDr'="" subObj.papatidupdateusercode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)  //最后更新人编码
	set subObj.papatidupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatidupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatidupdatetime=$zt(UpdateTime,1) //最后更新时间
	set subObj.papatidphotourl=$p($g(^PAPER(patRowId,"PER",6)),"^",39)   	//患者照片链接
	set subObj.papatidphoto=$p($g(^PAPER(patRowId,"PER",6)),"^",5)   	     //患者证件
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取患者证件表历史数据(ACC0002) Global
/// Table：PA_PatMas pa_person dhc_person
/// Input：patRowId：患者ID
/// Output：
/// Return：数据中心pa_identifier患者证件表(Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PaidentifierInfo).paidentifierGlobal("1","1486515")
ClassMethod paidentifierGlobal(strpatRowId As %String, endpatRowId As %String) As %String
{
	set $zt="Exception"
	if (strpatRowId="")||(endpatRowId="") {
		quit "-1^patRowId病人id不能为空"
	}
	set ^ExportHistoryData("paidentifier")=$lb("全局患者id","证件类型","证件号码","最后更新人编码","最后更新日期","最后更新时间","患者照片链接","时间戳","时间戳","患者证件")
	set patRowId="",con=0,strtime=$zt($p($now(),",",2))
	for patRowId=strpatRowId:1:endpatRowId
	{
		continue:$d(^PAPER(patRowId))=0
		continue:$p($g(^PAPER(patRowId,"PAT",1)),"^",1)=""
		continue:$p($g(^PAPER(patRowId,"PAT",3)),"^",6)=""
		set subObj=..getSubpaidentifier(patRowId)
		set ^ExportHistoryData("paidentifier",patRowId)=$lb(subObj.papatrelpatientid,subObj.papatidtypecode,subObj.papatidno,subObj.papatidupdateusercode,
															subObj.papatidupdatedate,subObj.papatidupdatetime,subObj.papatidphotourl,subObj.updatedate,
															subObj.updatetime,subObj.papatidphoto,subObj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strpatRowId, endpatRowId, con, patRowId)
		}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
