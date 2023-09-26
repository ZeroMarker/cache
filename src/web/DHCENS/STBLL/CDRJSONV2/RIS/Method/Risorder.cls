Class web.DHCENS.STBLL.CDRJSONV2.RIS.Method.Risorder Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:	2020年12月29日
/// creator:	zhibao
/// desc: 		获取检查登记信息
/// table:		DHCRB_RegInfo
/// outout:
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.getRisorder).getRisOrder("444")
ClassMethod getRisOrder(studyRegId As %String) As %GlobalCharacterStream
{
	set outStream=##class(%GlobalCharacterStream).%New()
	try{
		set mainobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set tSC=..getRisOrderinfo(studyRegId,.mainobj)
		set outputStream=##class(%GlobalCharacterStream).%New()
		set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(mainobj,"")
		d outStream.Write(JsonString)		
	}catch{
		set mainobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(mainobj,"")
		d outStream.Write(JsonString)	
	}
	Quit outStream
}

ClassMethod getRisOrderinfo(studyRegId As %String, Output data As web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data) As %Status
{
	set StudyNo=$p(^DHCPACRegInfo(studyRegId),"^",2)
	set ordItemRowid=$p(^DHCPACRegInfo(studyRegId),"^",11)
	set admRowId=$p($g(^OEORD(+ordItemRowid)),"^",1)
	set PapmiDr=$P($g(^PAADM(admRowId)),"^",1)
	set PatientId=$p($g(^PAPER(PapmiDr,"PAT",1)),"^",1)
	set childId=""
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risorder).%New()
	set businessfieldcode=obj.businessfieldcode
	if $d(^DHCPACRegInfoBD("BODYPARTS",0,studyRegId))="10"{
		for {
			set childId=$o(^DHCPACRegInfoBD("BODYPARTS",0,studyRegId,childId))
			Quit:childId=""
			set bodyPartInfo=$g(^DHCPACRegInfoBD("BODYPARTS",0,studyRegId,childId))
			set RISRPositionCode=$p(bodyPartInfo,"^",2)
			set RISRPositionDesc=$p(bodyPartInfo,"^",3)
			set obj.oeorirelorderitemid=businessfieldcode_"_"_ordItemRowid
			set obj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId
			set obj.papatrelpatientid=businessfieldcode_"_"_PatientId
			set obj.risobacode=RISRPositionCode
			set obj.risobadesc=RISRPositionDesc
			set obj.risohosrisexamid=StudyNo
			set obj.risorelrisexamid=businessfieldcode_"_"_StudyNo
			set obj.updatedate=$zd(+$h,3)
			set obj.updatetime=$zt($p($h,",",2))
			d data.risorderList.Insert(obj)
			}
		}
		else {
			
			set obj.oeorirelorderitemid=businessfieldcode_"_"_ordItemRowid
			set obj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId
			set obj.papatrelpatientid=businessfieldcode_"_"_PatientId
			set obj.risobacode=""
			set obj.risobadesc=""
			set obj.risohosrisexamid=StudyNo
			set obj.risorelrisexamid=businessfieldcode_"_"_StudyNo
			set obj.updatedate=$zd(+$h,3)
			set obj.updatetime=$zt($p($h,",",2))
			d data.risorderList.Insert(obj)
			}
	quit 1
}

/// creator:	zhibao
/// desc: 		获取检查登记信息历史数据(global)
/// table:		DHCRB_RegInfo
/// outout:   ris_order
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.Risorder).getRisOrderglobal("1","3741755")
ClassMethod getRisOrderglobal(strpatRowId As %String, endpatRowId As %String)
{
	set $zt="Exception"
	if (strpatRowId="")||(endpatRowId="") quit "-1^id不能为空"
	set ^ExportHistoryData("risorder")=$lb("全局医嘱明细id","检查部位代码","时间戳","时间戳","检查部位描述","院内检查号","业务域_院内患者id","业务域_院内就诊号")
	set studyRegId="",con=0,strtime=$zt($p($now(),",",2))
	for studyRegId=strpatRowId:1:endpatRowId{
		set data=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		continue:$d(^DHCPACRegInfo(studyRegId))=0
		set tSC=..getRisOrderinfo(studyRegId,.data)
		set Size = data.risorderList.Count()
		for i=1:1:Size{
			set obj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risorder).%New()
			set obj=data.risorderList.GetAt(i)
			set ^ExportHistoryData("risorder",obj.oeorirelorderitemid_obj.risohosrisexamid)=$lb(obj.oeorirelorderitemid,obj.risobacode,obj.updatedate,obj.updatetime,obj.risobadesc,
																			obj.risohosrisexamid,obj.papatrelpatientid,obj.paadmrelvisitnumber,obj.risorelrisexamid,obj.businessfieldcode)
																						
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strpatRowId, endpatRowId, con, studyRegId)		
		;if con#100=0 w con _"   "_obj.oeorirelorderitemid_obj.risobacode
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
