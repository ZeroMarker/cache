Class web.DHCEMCheckHtml Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ToHTML(table = "", idField = "", descField = "", hopField = "", activeField = "", type = "checkbox", name, scoreField = "", expandType = "", configFlag = "", userName = "", fieldName = "")
{
	n (table, idField, descField, hopField, activeField, type, name,scoreField,%session,expandType,configFlag,userName,fieldName)
	s HospID=""
	s:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	s:(table="DHC_EmPatHistoryMore") HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatHistoryMore",HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT "
	s sqlStr =sqlStr_idField
	s sqlStr =sqlStr_" ,"_descField
	s:scoreField'="" sqlStr=sqlStr_" ,"_scoreField
	s sqlStr =sqlStr_" from "
	s sqlStr =sqlStr_" "_table
	s sqlStr =sqlStr_" where 1=1 "
	
	s:(+HospID'=0)&&(hopField'="")&&(configFlag="Y") sqlStr = sqlStr_"  and "_hopField_"="_HospID //hxy 2020-05-26 &&(configFlag="Y") 产品配置界面传“Y”;基础数据传空或不传即可
	s:activeField'="" sqlStr = sqlStr_"  and "_activeField_"='Y'"
	s:expandType'="" sqlStr = sqlStr_"  and PHIM_Type='"_expandType_"'" //hxy 2019-09-07
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	While(result.Next())
	{	
		s id = result.Data(idField)
		s text = result.Data(descField)
		s score=""
		s:scoreField'="" score=result.Data(scoreField)
		continue:text=""
		continue:(configFlag="")&&(##class(web.DHCEMCommonUtil).GetHospShowDataFlag(table,id,HospID)'="Y") //hxy 2020-05-26 基础数据 走基础数据平台接口
		s:userName'="" text=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(userName,fieldName,"",text)
		i (type="btn"){
			w "<button class='dhcc-btn-gray' id='"_id_"' name='"_name_"' style='margin-right:6px' score='"_score_"'>"_text_"</button>"
		}else{
			s class=$case(type,"radio":"hisui-radio",:"hisui-checkbox")
			s inputType=$case(type,"radio":"radio",:"checkbox")
			w "<input class='"_class_"' type='"_inputType_"' label='"_text_"' id='"_table_id_"' name='"_name_"' data-label='"_text_"' value='"_id_"' score='"_score_"'>"
		}

	}
	q ""
}

/// 输出哥斯拉的html
/// d ##class(web.DHCEMCheckHtml).ToGCSHTML()
ClassMethod ToGCSHTML1(LgHospID = "")
{
	
	n (LgHospID,%session)
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")	
	S gcsId="0"
	F  S gcsId=$o(^DHCEMGCS(gcsId)) Q:gcsId=""  d
	.Q:$p(^DHCEMGCS(gcsId),"^",3)'="Y"
	.;Q:$p(^DHCEMGCS(gcsId),"^",4)'=LgHospID //hxy 2019-12-26 云his公有，不区分医院

	.w "<div class='hisui-panel' title='"_$p(^DHCEMGCS(gcsId),"^",2)_"'" 
	.w " style='height:68px;width:1100px;padding:10px 10px 5px 30px'"
	.w " data-options='headerCls:""panel-header-card""' "
	.w " >"
	.s gcsiSub="0"
	.f  s gcsiSub=$o(^DHCEMGCS(gcsId,"I",gcsiSub))  q:gcsiSub=""  d
	..s gcsiId=gcsId_"||"_gcsiSub
	..Q:$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",6)'="Y"
	..s GlasgowName=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",4)
	..s GlasgowSc=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",5)
	..w "<input class='hisui-radio' type='radio' label='"_GlasgowName_"("_GlasgowSc_"分)' name='REMS_GCS_"_gcsId_"' value="_GlasgowSc_" data-id='"_gcsiId_"'>"
	.w "</div>"
}

ClassMethod ToGCSHTML(LgHospID = "")
{
	
	n (LgHospID,%session)
	s Grade=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patchecklev.hisui.csp","分") //hxy 2023-02-09
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")	
	S gcsId="0"
	F  S gcsId=$o(^DHCEMGCS(gcsId)) Q:gcsId=""  d
	.Q:$p(^DHCEMGCS(gcsId),"^",3)'="Y"
	.;Q:$p(^DHCEMGCS(gcsId),"^",4)'=LgHospID //hxy 2019-12-26 云his公有，不区分医院

	.w "<tr>"
	.w "<td width=100><div class='tblabel'>"_##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmGCS","GCSItmDesc","",$p(^DHCEMGCS(gcsId),"^",1))_"</div></td>"
	.w "<td>"
	.s gcsiSub="0"
	.f  s gcsiSub=$o(^DHCEMGCS(gcsId,"I",gcsiSub))  q:gcsiSub=""  d
	..s gcsiId=gcsId_"||"_gcsiSub
	..Q:$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",6)'="Y"
	..s GlasgowName=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",4)
	..s GlasgowName=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmGCSItem","GCSItmDesc","",GlasgowName) //hxy 2023-02-09
	..s GlasgowSc=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",5)
	..;w "<input class='hisui-radio' type='radio' label='"_GlasgowName_"("_GlasgowSc_"分)' name='REMS_GCS_"_gcsId_"' value="_GlasgowSc_" data-id='"_gcsiId_"'>"
	
	..w "<div class='tddiv'><input class='hisui-radio' type='radio' label='"_GlasgowName_"("_GlasgowSc_Grade_")' name='REMS_GCS_"_gcsId_"' value="_GlasgowSc_" data-id='"_gcsiId_"'></div>"
	.w "</td>"
	.w "</tr>"
}

/// 输出创伤的html
/// d ##class(web.DHCEMCheckHtml).ToAISHTML()
ClassMethod ToAISHTML(LgHospID = "")
{
	
	n (LgHospID,%session)
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")	
	S gcsId="0"
	s AISRowId ="0",AISdataStr=""
    f  s AISRowId= $o(^DHCEMAIS(AISRowId)) Q:AISRowId=""  d
    .Q:$p(^DHCEMAIS(AISRowId),"^",3)'="Y"
    .;Q:$p(^DHCEMAIS(AISRowId),"^",4)'=LgHospID //hxy 2019-12-26 云his公有，不区分医院
	.w "<tr>"
	.w "<td width=100><div class='tblabel'>"_$p(^DHCEMAIS(AISRowId),"^",2)_"</div></td>"
	.w "<td>"
    .s AISRowSubId="0"
    .f  s AISRowSubId=$o(^DHCEMAIS(AISRowId,AISRowSubId))  q:AISRowSubId=""  d
	..s AISSubId=AISRowId_"||"_AISRowSubId
	..Q:$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",6)'="Y"
	..s AISName=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",3)
	..s AISSc=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",5)
    ..;w "<input class='hisui-radio' type='radio' label='"_AISName_"("_AISSc_"分)' name='HURTLEV_"_AISRowId_"' value="_AISSc_" data-id='"_AISSubId_"' id='"_AISSubId_"'>"
	..w "<div class='tddiv'><input class='hisui-radio' type='radio' label='"_AISName_"("_AISSc_"分)' name='HURTLEV_"_AISRowId_"' value="_AISSc_" data-id='"_AISSubId_"' id='"_AISSubId_"'></div>"
	.w "</td>"
	.w "</tr>"
}

/// 输出创伤的html
/// d ##class(web.DHCEMCheckHtml).ToAISHTML()
ClassMethod ToAISHTML1(LgHospID = "")
{
	
	n (LgHospID,%session)
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")	
	S gcsId="0"
	s AISRowId ="0",AISdataStr=""
    f  s AISRowId= $o(^DHCEMAIS(AISRowId)) Q:AISRowId=""  d
    .Q:$p(^DHCEMAIS(AISRowId),"^",3)'="Y"
    .;Q:$p(^DHCEMAIS(AISRowId),"^",4)'=LgHospID //hxy 2019-12-26 云his公有，不区分医院
    .w "<div class='hisui-panel' title='"_$p(^DHCEMAIS(AISRowId),"^",2)_"'" 
	.w " style='height:68px;width:1000px;padding:10px 10px 5px 30px'"
	.w " data-options='headerCls:""panel-header-card""' "
	.w " >"
    .s AISRowSubId="0"
    .f  s AISRowSubId=$o(^DHCEMAIS(AISRowId,AISRowSubId))  q:AISRowSubId=""  d
	..s AISSubId=AISRowId_"||"_AISRowSubId
	..Q:$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",6)'="Y"
	..s AISName=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",3)
	..s AISSc=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",5)
    ..w "<input class='hisui-radio' type='radio' label='"_AISName_"("_AISSc_"分)' name='HURTLEV_"_AISRowId_"' value="_AISSc_" data-id='"_AISSubId_"' id='"_AISSubId_"'>"
	.w "</div>"
}

/// 输出坠床的html
/// d ##class(web.DHCEMCheckHtml).ToFALLHTML()
ClassMethod ToFALLHTML(LgHospID = "")
{
	
	n (LgHospID,%session)
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")	
	S FALLRowId="0"
    f  s FALLRowId= $o(^DHCEMFALL(FALLRowId)) Q:FALLRowId=""  d
    .Q:$p(^DHCEMFALL(FALLRowId),"^",3)'="Y"
    .Q:$p(^DHCEMFALL(FALLRowId),"^",4)'=LgHospID

    .w "<div class='hisui-panel' title='"_$p(^DHCEMFALL(FALLRowId),"^",2)_"'" 
	.w " style='height:68px;width:1000px;padding:10px 10px 5px 30px'"
	.w " data-options='headerCls:""panel-header-card""' "
	.w " >"
	.s FALLRowSubId="0"
    .f  s FALLRowSubId=$o(^DHCEMFALL(FALLRowId,FALLRowSubId))  q:FALLRowSubId=""  d
	..s FALLSubId=FALLRowId_"||"_FALLRowSubId
	..Q:$p(^DHCEMFALL(FALLRowId,FALLRowSubId),"^",5)'="Y"
	..s FALLName=$p(^DHCEMFALL(FALLRowId,FALLRowSubId),"^",3)
	..s FALLSc=$p(^DHCEMFALL(FALLRowId,FALLRowSubId),"^",7)
    ..w "<input class='hisui-radio' type='radio' label='"_FALLName_"("_FALLSc_"分)' name='FALL_"_FALLRowId_"' value="_FALLSc_" data-id='"_FALLSubId_"'>"
	.w "</div>"
}

}
