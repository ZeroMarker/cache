Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PAAllergy Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-24
/// Description：根据id取患者历次过敏记录表(ACC0006)
/// Table：pa_adm pa_allergy
/// Input：ALGRowID：过敏表id
/// Output：
/// Return：数据中心pa_allergy患者过敏记录表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AllergyInfo).paallergyByALGid("9408365||1")
ClassMethod paallergyByALGid(ALGRowID As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAllergyInfo).%New()
	if (ALGRowID="") {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..getpaallerginfo(ALGRowID)
	d obj.PAAllergyInfoList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// Creator：wl
/// CreatDate：2020-12-24
/// Description：根据id取患者历次过敏记录表(ACC0006)历史数据 global
/// Table：pa_adm pa_allergy
/// Input：ALGRowID：过敏表id
/// Output：
/// Return：数据中心pa_allergy患者过敏记录表(global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PAAllergy).paallergyglobal("1","1486515")
ClassMethod paallergyglobal(strpatRowId As %String, endpatRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("paallergy")=$lb("医院内部过敏记录id","过敏源描述","过敏类别","过敏反应描述","严重级别","发病日期","状态","最后更新人编码","最后更新日期","最后更新时间","时间戳","时间戳","全局患者id")
	if (strpatRowId="")||(endpatRowId="") {
		quit "-1^id不能为空"
	}
	set patRowId="",con=0,strtime=$zt($p($now(),",",2))
	for patRowId=strpatRowId:1:endpatRowId
	{	
		continue:$d(^PAPER(patRowId))=0
		set ALGRowsub=0		
		for {
		set ALGRowsub=$o(^PAPER(patRowId,"ALG",ALGRowsub))
		q:ALGRowsub=""
		set ALGRowID=patRowId_"||"_ALGRowsub
		set subObj=..getpaallerginfo(ALGRowID)
		set ^ExportHistoryData("paallergy",ALGRowID)=$lb(ALGRowID,subObj.paallsourcedesc,subObj.paallcategorycode,subObj.paallreactiondesc,
														 subObj.paallseveritycode,subObj.paalldate,subObj.paallstatus,subObj.paallupdateusercode,
														 subObj.paallupdatedate,subObj.paallupdatetime,subObj.updatedate,subObj.updatetime,
														 subObj.paallrelallergyid,subObj.papatrelpatientid,
														 subObj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strpatRowId, endpatRowId, con, patRowId)
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod getpaallerginfo(ALGRowID) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAllergyInfo
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAllergyInfo).%New()
	set patRowId=+ALGRowID
	set ALGRowsub=$p(ALGRowID,"||",2)
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.paallhosallergyid=ALGRowID    //医院内部过敏记录id
	set subObj.paallrelallergyid=businessfieldcode_"_"_subObj.paallhosallergyid  //全局过敏记录id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	s (tag,ALGCode,ALGDesc,Mralgid,MralgCode,MralgDesc,ALRGSEVDesc)=""
	;自定义过敏分类
	set ALGTypeDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",9)
	if ALGTypeDR'="" {
		set ALGCode=$p($g(^PAC("ALG",ALGTypeDR)),"^",1)  //过敏源代码
		set ALGDesc=$p($g(^PAC("ALG",ALGTypeDR)),"^",2)  //过敏源描述	
		set Mralgid=$p($g(^PAC("ALG",ALGTypeDR)),"^",3)
		set MralgCode=$P($g(^MRC("AT",Mralgid)),"^",1)     //过敏分类代码
		set MralgDesc=$P($g(^MRC("AT",Mralgid)),"^",2)     //过敏分类描述
		set tag=$P($g(^MRC("AT",Mralgid)),"^",2)   
	}
	;通用项过敏源\
	set ALGPHCGEDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",4)
	if ALGPHCGEDR'="" {
		set ALGCode=$p($g(^PHCGE("GE",ALGPHCGEDR)),"^",1)  //过敏源代码
		set ALGDesc=$p($g(^PHCGE("GE",ALGPHCGEDR)),"^",2)  //过敏源描述	
		set tag="G"  
	}
	;药学过敏源
	set ALGPHCDMDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",27)
	if ALGPHCDMDR'="" {
		set ALGCode=$p($g(^PHCD(ALGPHCDMDR)),"^",1)  //过敏源代码
		set ALGDesc=$p($g(^PHCD(ALGPHCDMDR)),"^",2)  //过敏源描述
		set tag="P" 		
	}
	set ALGIngredDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",32)
	if ALGIngredDR'="" {
		set ALGCode=$p($g(^PHC("INGR",ALGIngredDR)),"^",1)  //过敏源代码
		set ALGDesc=$p($g(^PHC("INGR",ALGIngredDR)),"^",2)  //过敏源描述
		set tag="I" 		
	}
	;医嘱项ID
	if ALGDesc="" {
	set ALGExternalID=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",30)
	if (ALGExternalID'="")&&(ALGExternalID["||") set ALGDesc=$p($g(^ARCIM(+ALGExternalID,$p(ALGExternalID,"||",2),1)),"^",2)
	else  if (ALGExternalID'="") set ALGDesc=ALGExternalID
	}
	set subObj.paallsourcedesc=ALGDesc   //过敏源描述
	if MralgDesc="" {
		set ALGMRCAllTypeDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",29)
		set:ALGMRCAllTypeDR'="" MralgDesc=$P($g(^MRC("AT",ALGMRCAllTypeDR)),"^",2)     //过敏分类描述
		set:(tag="P")!(tag="G")!(tag="I") tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
		}
	set subObj.paallcategorycode=MralgDesc  //过敏类别
	;严重
	set ALGSeverityDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",21)
#;	set:ALGSeverityDR'="" ALRGSEVDesc=$p($g(^PAC("ALRGSEV",ALGSeverityDR)),"^",2)
#;	set subObj.paallseveritycode=ALRGSEVDesc  //严重级别
	set subObj.paallseveritycode=ALGSeverityDR
	;发作日期描述
	set OnsetDate=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",14)
	set:OnsetDate'="" OnsetDate=$zd(OnsetDate,3)
	set OnsetDateFreeText=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",22)
	set:OnsetDate'="" subObj.paalldate=OnsetDate   //发作日期
	set:subObj.paalldate="" subObj.paalldate=$zd($p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",10),3)
	;状态
	s subObj.paallstatus=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",8)
	;未激活标志
	s InActive=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",19)
	;皮试标志？
	set ALGSkinTestFlag=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",39)	
	set ALGUpdateUserDR=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",16)
#;	set:ALGUpdateUserDR'="" subObj.paallupdateusercode=$p($g(^SSU("SSUSR",ALGUpdateUserDR)),"^",1)  //最后更新人编码
	set subObj.paallupdateusercode=ALGUpdateUserDR
	set ALGLastUpdateDate=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",23)
	set:ALGLastUpdateDate'="" subObj.paallupdatedate=$zd(ALGLastUpdateDate,3) //最后更新日期
	set ALGLastUpdateTime=$p($g(^PAPER(patRowId,"ALG",ALGRowsub)),"^",24)
	set:ALGLastUpdateTime'="" subObj.paallupdatetime=$zt(ALGLastUpdateTime) //最后更新日期
	set:$d(^PAPER(patRowId,"ALG",ALGRowsub,"CMT",1)) subObj.paallreactiondesc=^PAPER(patRowId,"ALG",ALGRowsub,"CMT",1)  //过敏反应描述
	quit subObj
}

}
