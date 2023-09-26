/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗单
Class DHCDoc.Chemo.BS.Apply Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetTreeByType("USER","12175","113","2","157","280","ce"_$c(1,1,1)_"0","","")
ClassMethod GetTreeByType(InType = "", InUser = "", InDep = "", InHosp = "", InPatientID = "", InAdm = "", InExt = "", IsView = "", DefualtDay = "") As %String
{
	s InTypeDesc=""
	s ^QP("GetTreeByType",1)=$LB(InType,InUser,InDep,InHosp,InPatientID,InAdm,InExt,IsView,DefualtDay)
	//初始化参数
	d ##class(DHCDoc.Chemo.BS.Data).DoInit()
	//
	i InType="USER" s InTypeDesc=InUser
	i InType="DEP" s InTypeDesc=InDep
	i InType="HOSP" s InTypeDesc=InHosp
	i InType="CUR" s InTypeDesc=InPatientID
	i InType="HIS" s InTypeDesc=InPatientID
	s CDate=+$h
	
	s InSContent=$P(InExt,$C(1),1)
	s InPDAID=$P(InExt,$C(1),2)
	s InPLID=$P(InExt,$C(1),3)
	s InPSID=""
	i InPDAID'="" {
		s InPDID=+InPDAID
		s InPSID=$p(^BS.DOC.Chemo.PlanDateD(InPDID),"^",2)
	}
	s DefualtDay=##class(websys.Conversions).DateHtmlToLogical(DefualtDay)
	s langid=..%LanguageID()
	s ^QP("Tree")=$lb(InPDAID,InPLID,InPSID)
	I (InType="CUR")||(InType="HIS") {
		w "["
		s PLID=""
		s j=0
		for{
			s PLID=$O(^BS.DOC.Chemo.PlanI("ChemoPlan","PatientDR",InTypeDesc,PLID))
			q:PLID=""
			s name=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)	//化疗方案名称
			s OrderDep=$p(^BS.DOC.Chemo.PlanD(PLID),"^",4)
			s OrderHosp=$p(^CTLOC(OrderDep),"^",22)
			continue:OrderHosp'=InHosp
			s TempFlag=##class(DHCDoc.Chemo.COM.Func2).FilterTree(InType,PLID,InExt,IsView)
			continue:TempFlag=1
			s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
			s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
			;continue:(Status'="Y")&&(InType="CUR")
			;continue:(Status="Y")&&(InType="HIS")
			continue:('$d(^CF.DOC.Chemo.TemplateD(TPID)))
			s TPName=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",3)
			s name=##class(User.ChemoTemplate).GetTranByDesc("TPName",name,langid)
			s name=name	//_" ("_TPName_")"
			s stagenum=+$p(^CF.DOC.Chemo.TemplateD(TPID),"^",4)
			s active=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",5)
			;q:(active'="Y")||(stagenum=0)
			s j=j+1
			s count=0
			//i j=1 w "{""id"":"_PLID_",""text"":"""_name_"",""",""children"":["
			i j=1 w "{""id"":"_PLID_",""code"":""Plan"",""text"":"""_name_"",""",""children"":["
			e  w ",{""id"":"_PLID_",""code"":""Plan"",""text"":"""_name_"",""",""children"":["
			for i=1:1:stagenum {
				s stage=i
				continue:'$d(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,stage))
				s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,stage,""))
				s text=$p(^BS.DOC.Chemo.PlanD(PLID,sub),"^",2)
				s text=##class(User.ChemoTemplateStage).GetTranByDesc("TSDesc",text,langid)
				s PSID=PLID_"||"_sub
				s id=PSID_"-"_i
				s count=count+1
				//i count=1 w "{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"	
				//e  w ",{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"	
				//i count=1 w "{""id"":"""_id_""",""text"":"""_text_"",""",""children"":["
				i count=1 w "{""id"":"""_id_""",""code"":""Stage"",""text"":"""_text_"",""",""children"":["
				e  w ",{""id"":"""_id_""",""code"":""Stage"",""text"":"""_text_"",""",""children"":["
				s dateApply=##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage(PSID,IsView,InExt)
				s tempNum=0
				s hasCheck=0
				for j=1:1:$l(dateApply,"^") {
					s record=$p(dateApply,"^",j)
					s displayText=$p(record,",",4)
					s PDID=$p(record,",",3)
					i PDID="" s PDID=id_"-NO" //未开立状态自动跳转下一个
					e  s PDID=id_"-"_PDID
					//s PDStatus=""
					//i PDID'="" s PDStatus=$P(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
					s PDStatus=$p(record,",",2)
					i PDStatus="R" {	//拒绝状态自动跳转下一个
						s PDID=id_"-R"
					} 
					s disDate=$p(record,",",1)
					s checked="false"
					i disDate=CDate {
						i IsView'=1 {
							i hasCheck=0 s checked="true"
						}
					}
					i IsView=1 {
						i PDID=+InPDAID	s checked="true"
						s hasCheck=1
					}
					i (DefualtDay=disDate)&&(InPSID=PSID) {
						i hasCheck=1 s checked="true"
					}
					
					s disDate2=##class(websys.Conversions).DateLogicalToHtml(disDate)
					s formatDate=$zd(disDate,3)
					s Ext=disDate2_"^"_formatDate
					s tempNum=tempNum+1
					s ^QP("TEMP",formatDate)=$LB(formatDate,checked)
					//i tempNum=1 w "{""id"":"""_PDID_""",""Ext"":"""_Ext_""",""text"":"""_displayText_""",""checked"":"_checked_"}"	
					i tempNum=1 w "{""id"":"""_PDID_""",""code"":""Day"",""Ext"":"""_Ext_""",""text"":"""_displayText_""",""checked"":"_checked_"}"	
					e  w ",{""id"":"""_PDID_""",""code"":""Day"",""Ext"":"""_Ext_""",""text"":"""_displayText_""",""checked"":"_checked_"}"	
				}
				w "]}"
				
			}
			w "]}"
		}
	
		w "]"
		Q ""
	}
	w "["
	s TPID=""
	s j=0
	//^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPOtherDesc","HOSP","2,3",260)=""
	for{
		s TPID=$O(^CF.DOC.Chemo.TemplateD(TPID))
		;s TPID=$O(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDesc",InType,InTypeDesc,TPID))
		q:TPID=""
		s CType=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",1)
		s CDesc=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",2)
		s OtherDesc=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",15)
		s OtherLoc=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",16)
		s HospID=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",17)
		continue:(InHosp'="")&&(InHosp'=HospID)
		continue:InType'=CType
		i InType="HOSP" {
			//if ((CDesc'=InTypeDesc)&&(##class(DHCDoc.Chemo.COM.Func).InArray(OtherDesc,InTypeDesc)'=1)) {
			if (CDesc'=InTypeDesc) {
				continue	
			}
		} elseif (InType="DEP") {
			//if ((CDesc'=InTypeDesc)&&(##class(DHCDoc.Chemo.COM.Func).InArray(OtherLoc,InTypeDesc)'=1)) {
			if (CDesc'=InTypeDesc) {
				continue	
			}
		} else {
			//if ((CDesc'=InTypeDesc)&&(##class(DHCDoc.Chemo.COM.Func).InArray(OtherDesc,InTypeDesc)'=1)) {
			if (CDesc'=InTypeDesc) {
				continue	
			}
		}
		s name=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",3)
		s name=##class(User.ChemoTemplate).GetTranByDesc("TPName",name,langid)
		s TempFlag=##class(DHCDoc.Chemo.COM.Func2).FilterTree(InType,TPID,InExt,IsView,InPatientID)
		continue:TempFlag=1
		s stagenum=+$p(^CF.DOC.Chemo.TemplateD(TPID),"^",4)
		s active=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",5)
		;continue:(active'="Y")||(stagenum=0)
		s j=j+1
		s count=0
		i j=1 w "{""id"":"_TPID_",""text"":"""_name_"",""",""children"":["
		e  w ",{""id"":"_TPID_",""text"":"""_name_"",""",""children"":["
		for i=1:1:stagenum {
			s stage=i
			continue:'$d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage))
			s sub=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,stage,""))
			s text=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",2)
			s text=##class(User.ChemoTemplateStage).GetTranByDesc("TSDesc",text,langid)
			s TSID=TPID_"||"_sub
			s checked="false"
			//没有维护任何化疗组的退出
			continue:(##class(DHCDoc.Chemo.COM.Func).GetTPLStageGroups(TSID,InType)=0)
			s id=TSID_"-"_i
			s count=count+1
			i count=1 w "{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"	
			e  w ",{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"	
		}
		w "]}"
	}
	w "]"
	
	Q ""
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : IsView: 是否查看
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).BuildGroupShow("919||1","CUR","0","")
ClassMethod BuildGroupShow(TSID = "", InType = "", IsView = "0", SelectDate = "") As %String
{
	q:(TSID="")||(InType="") ""
	s ^QP("BuildGroupShow")=$LB(TSID , InType , IsView , SelectDate )
	s mRtn=""
	s code=""
	s TPID=$p(TSID,"||",1)
	s SID=$p(TSID,"||",2)
	s gDescStr=""
	k gDescArr
	i (InType="CUR")||(InType="HIS"){
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(SelectDate,TSID)
		i PDID'="" {
			s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)	
			i PDStatus="U" s IsView=1
			
		}
		s sub=""
		f  s sub=$o(^BS.DOC.Chemo.PlanD(TPID,SID,sub)) q:sub=""  d
		.s gDesc=$p(^BS.DOC.Chemo.PlanD(TPID,SID,sub),"^",2)
		.s df=$p(gDesc,"||",1),ch=$p(gDesc,"||",2)
		.s gCode=$p(^DHCDocCT("DefineData",df,"D",ch),"^",1)
		.s gText=$p(^DHCDocCT("DefineData",df,"D",ch),"^",2)
		.s gDescStr=gDescStr_","_gCode
		.s gDescArr(gCode)=gDesc_"^"_gText
		
		d GetHtml
	} else {
		s IsView=1
		d GetHtml
	}
	i gDescStr'="" s gDescStr=gDescStr_","
	Q mRtn
GetHtml
	//s descU=$zcvt(desc,"U")
	s mRtn=mRtn_"<div class='table-row'>"
	s mRtn=mRtn_"<table class='search-table' style='width:100%;'>"
	s mRtn=mRtn_	"<tr>"
	s mRtn=mRtn_		"<td colspan='3'>"
	s mRtn=mRtn_			"<div class='note-head'>"
	s mRtn=mRtn_				"<div class='c-label'></div>"
	s mRtn=mRtn_				"<div class='c-title'></div>"
	s mRtn=mRtn_				"<span id='chemoDrug' class='c-span strong'>"_##class(websys.Translation).Get("chemo.bs.apply.csp","化疗用药")_"</span>"
	s mRtn=mRtn_			"</div>"
	s mRtn=mRtn_		"</td>"
	s mRtn=mRtn_	"</tr>"
	s mRtn=mRtn_"</table>"
	i IsView'=1 {
	s mRtn=mRtn_"<div class='toolbar-div' style='border:1px solid #ccc;border-bottom:0;border-radius:4px 4px 0px 0px;'>"
	s mRtn=mRtn_	"<div class='datagrid-toolbar' style='border-bottom:0;'>"
	s mRtn=mRtn_		"<table cellspacing='0' cellpadding='0'>"
	s mRtn=mRtn_			"<tbody>"
	s mRtn=mRtn_				"<tr>"
	s mRtn=mRtn_					"<td>"
	s mRtn=mRtn_				    	"<a id='Add_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-add',plain:true"_""""">新增</a>"
	s mRtn=mRtn_				    "</td>"
	
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='Del_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-cancel',plain:true"_""""">删除</a>"
	s mRtn=mRtn_				    "</td>"
	
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='Link_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-write-order',plain:true"_""""">开始关联</a>"
	s mRtn=mRtn_				    "</td>"
	/*
	i gDescStr["PRE" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='PRE_btn' value='"_$p(gDescArr("PRE"),"^",1)_"' desc='"_$p(gDescArr("PRE"),"^",2)_"' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug-clock',plain:true"_""""">化疗前药</a>"
	s mRtn=mRtn_				    "</td>"
	}
	i gDescStr["POST" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='POST_btn' value='"_$p(gDescArr("POST"),"^",1)_"' desc='"_$p(gDescArr("POST"),"^",2)_"'  class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-blue-drug-ok',plain:true"_""""">化疗后医嘱</a>"
	s mRtn=mRtn_				    "</td>"
	}
	i gDescStr["OTHER" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='OTHER_btn' value='"_$p(gDescArr("OTHER"),"^",1)_"' desc='"_$p(gDescArr("OTHER"),"^",2)_"' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug-clock',plain:true"_""""">其他医嘱</a>"
	s mRtn=mRtn_				    "</td>"
	}
	i gDescStr["PRNGM" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='PRNGM_btn' value='"_$p(gDescArr("PRNGM"),"^",1)_"' desc='"_$p(gDescArr("PRNGM"),"^",2)_"'  class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug-link',plain:true"_""""">PRN过敏用药</a>"
	s mRtn=mRtn_				    "</td>"
	}
	i gDescStr["PRNS" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='PRES_btn' value='"_$p(gDescArr("PRNS"),"^",1)_"' desc='"_$p(gDescArr("PRNS"),"^",2)_"' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug-clock',plain:true"_""""">PRN用药</a>"
	s mRtn=mRtn_				    "</td>"
	}
	i gDescStr["PRNCOM" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='PRNCOM_btn' value='"_$p(gDescArr("PRNCOM"),"^",1)_"' desc='"_$p(gDescArr("PRNCOM"),"^",2)_"'  class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug',plain:true"_""""">PRN普通用药</a>"
	s mRtn=mRtn_				    "</td>"
	}
	
	i gDescStr["OUT" {
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='OutDrug_btn' value='"_$p(gDescArr("OUT"),"^",1)_"' desc='"_$p(gDescArr("OUT"),"^",2)_"'  class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug',plain:true"_""""">出院带药</a>"
	s mRtn=mRtn_				    "</td>"
	}
	*/
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='Up_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-up',plain:true"_"""""></a>"
	s mRtn=mRtn_				    "</td>"
	
	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='Down_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-down',plain:true"_"""""></a>"
	s mRtn=mRtn_				    "</td>"
	

	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='Adj_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-write-order',plain:true"_""""">调整</a>"
	s mRtn=mRtn_				    "</td>"

	s mRtn=mRtn_				    "<td>"
	s mRtn=mRtn_				    	"<a id='ComDate_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-cal-pen',plain:true"_""""">常用日期</a>"
	s mRtn=mRtn_				    "</td>"
	
	;s mRtn=mRtn_				    "<td>"
	;s mRtn=mRtn_				    	"<a id='DrugNote_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-drug-link',plain:true"_""""">药品说明书</a>"
	;s mRtn=mRtn_				    "</td>"
		
	;s mRtn=mRtn_				    "<td>"
	;s mRtn=mRtn_				    	"<a id='StopOrder_btn' class='hisui-linkbutton m-button' data-options="_""""_"iconCls:'icon-write-order',plain:true"_""""">中止</a>"
	;s mRtn=mRtn_				    "</td>"
	

	
	
	s mRtn=mRtn_				 "</tr>"
	s mRtn=mRtn_			"</body>"
	s mRtn=mRtn_		"</table>"
	s mRtn=mRtn_	"</div>"
	s mRtn=mRtn_"</div>"
	}
	s DefaultHieht="600"
	i IsView'=1 {
		s mRtn=mRtn_"<div class='hisui-panel m-panel'  style='border:1px solid #ccc;border-radius:0 0 4px 4px;'>"
	} else {
		s mRtn=mRtn_"<div class='hisui-panel m-panel'  style='border:1px solid #ccc;border-radius:4px'>"
	}
	//s mRtn=mRtn_"<div class='hisui-panel m-panel'  style='height:"_DefaultHieht_"px;border:1px solid #ccc;border-radius:0 0 4px 4px;'>"
	s mRtn=mRtn_	"<table id='GroupGrid' style='width:100%;border:0'></table>"
	s mRtn=mRtn_"</div>"
	s mRtn=mRtn_"</div>"
	
	
	
	Quit
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).FindGroupItem("416||1","CUR","2022-01-04","879","2021","12175^134^15^2^^20")
ClassMethod FindGroupItem(TSID = "", InType = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %String
{
	s TPID=$p(TSID,"||",1)
	s SID=$p(TSID,"||",2)
	s TPLFlag=0
	i (InType="CUR")||(InType="HIS") {
		s rset=##Class(%ResultSet).%New("DHCDoc.Chemo.BS.Item:QryAllItem")
	} else {
		s rset=##Class(%ResultSet).%New("DHCDoc.Chemo.CFG.Item:QryAllItem")
		s TPLFlag=1
	}
	s ^QP("DHC",1)=$LB(TSID,InType,SelectDate,PatientID,EpisodeID,SessionStr)
	s page=1,total=0,records=0,data=""
	w "{""page"":"""_page_""",""total"":"""_total_""",""records"":"""_records_""",""data"":["
	
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(TSID,SelectDate,PatientID,EpisodeID,SessionStr)
		If 'Status {
			w "]}"
			Quit ""
		}
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s total=total+1
			s rowid=total
			s OrderGridRowAry("OLD",rowid,"PGIId")=rset.Data("PGIID")
			s TPGIID=rset.Data("TPGIID")
			s OrderGridRowAry("OLD",rowid,"TplGroupItemId")=TPGIID
			s OrderGridRowAry("OLD",rowid,"id")=rowid
			if (TPLFlag=1) {	//模板
				s OrderGridRowAry("Index","TPGIID",TPGIID)=rowid
			}
			//
			s OrderGridRowAry("OLD",rowid,"OrderDoseQtyNurese")=rset.Data("OrderDoseQtyNurese")
			s OrderGridRowAry("OLD",rowid,"InitDosage")=rset.Data("initdosage")
			s OrderGridRowAry("OLD",rowid,"HDID")=rset.Data("HDID")
			s OrderGridRowAry("OLD",rowid,"BSAUnit")=rset.Data("BSAUnit")
			s OrderGridRowAry("OLD",rowid,"BSAUnitSTD")=rset.Data("BSAUnitSTD")
			s OrderGridRowAry("OLD",rowid,"HospDose")=rset.Data("HospDose")
			s OrderGridRowAry("OLD",rowid,"Formula")=rset.Data("formula")
			s OrderGridRowAry("OLD",rowid,"OrderMasterSeqNo")=rset.Data("linkItem")
			s OrderGridRowAry("OLD",rowid,"LinkSymbol")=rset.Data("LinkSymbol")
			s OrderGridRowAry("OLD",rowid,"GroupType")=rset.Data("GroupType")
			s OrderGridRowAry("OLD",rowid,"GroupTypeId")=rset.Data("GroupTypeId")
			s OrderGridRowAry("OLD",rowid,"MainDrug")=rset.Data("mainDrug")
			s OrderGridRowAry("OLD",rowid,"ChemoDays")=rset.Data("ShowDate")
			s OrderGridRowAry("OLD",rowid,"OeoriDR")=rset.Data("OeoriDR")
			
			s OrderGridRowAry("OLD",rowid,"OrderPrior")=rset.Data("priorDesc")
			s OrderGridRowAry("OLD",rowid,"OrderName")=rset.Data("arcimDesc")
			s OrderGridRowAry("OLD",rowid,"OrderDoseQty")=rset.Data("dosage")
			s OrderGridRowAry("OLD",rowid,"OrderDoseUOM")=rset.Data("dosageUomDesc")
			s OrderGridRowAry("OLD",rowid,"OrderDoseUOMRowid")=rset.Data("dosageUomDR")
			s OrderGridRowAry("OLD",rowid,"OrderARCIMRowid")=rset.Data("arcim")
			s OrderARCIMRowid=rset.Data("arcim")
			s OrderGridRowAry("OLD",rowid,"OrderPHPrescType")=""
			
			s OrderGridRowAry("OLD",rowid,"ManuFactor")=rset.Data("ManuFactor")
			s OrderGridRowAry("OLD",rowid,"idoseqtystr")=""
			s OrderGridRowAry("OLD",rowid,"OrderPackUOMStr")=""
			s OrderGridRowAry("OLD",rowid,"CurrentRecLocStr")=""
			s OrderGridRowAry("OLD",rowid,"OrderRecLocStr")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderFreq")=rset.Data("freqDesc")
			s OrderGridRowAry("OLD",rowid,"OrderFreqRowid")=rset.Data("freqDR")
			
			if (rset.Data("freqDesc")'=""){
				s OrderGridRowAry("OLD",rowid,"OrderFreqFactor")=$P(^PHCFR(rset.Data("freqDR")),"^",2)
				s OrderGridRowAry("OLD",rowid,"OrderFreqInterval")=$P(^PHCFR(rset.Data("freqDR")),"^",5)
			}
			s OrderGridRowAry("OLD",rowid,"OrderInstr")=rset.Data("instrucDesc")
			s OrderGridRowAry("OLD",rowid,"OrderInstrRowid")=rset.Data("instrucDR")
			s OrderGridRowAry("OLD",rowid,"OrderInstrRowid")=rset.Data("instrucDR")
			
			s OrderGridRowAry("OLD",rowid,"OrderDur")=rset.Data("duratDesc")
			s OrderGridRowAry("OLD",rowid,"OrderDurRowid")=rset.Data("duratDR")
			
			if (rset.Data("duratDR")'=""){
				s OrderGridRowAry("OLD",rowid,"OrderDurFactor")=$P(^PHCDU(rset.Data("duratDR")),"^",2)
			}
			
			s OrderGridRowAry("OLD",rowid,"OrderConFac")=1
			
			s OrderGridRowAry("OLD",rowid,"OrderPrice")=""
			s OrderGridRowAry("OLD",rowid,"OrderPackQty")=rset.Data("qty")
			s OrderGridRowAry("OLD",rowid,"OrderPackUOM")=rset.Data("uomDesc")
			s OrderGridRowAry("OLD",rowid,"OrderPackUOMRowid")=rset.Data("uomDR")
			
			s OrderGridRowAry("OLD",rowid,"OrderSkinTest")=rset.Data("skinTest")
			//
			s OrderGridRowAry("OLD",rowid,"OrderPriorRemarks")=rset.Data("remark")
			s OrderGridRowAry("OLD",rowid,"OrderPriorRemarksRowId")=rset.Data("remarkDr")
			//
			s OrderGridRowAry("OLD",rowid,"OrderRecDep")=rset.Data("recLocDesc")
			s OrderGridRowAry("OLD",rowid,"OrderRecDepRowid")=rset.Data("recLoc")
			
			s OrderGridRowAry("OLD",rowid,"OrderSum")=""
			s OrderGridRowAry("OLD",rowid,"OrderPrescNo")=""
			s OrderGridRowAry("OLD",rowid,"OrderDepProcNote")=rset.Data("note")
			
			s OrderGridRowAry("OLD",rowid,"OrderBodyPartID")=""
			s OrderGridRowAry("OLD",rowid,"OrderDoc")=""
			s OrderGridRowAry("OLD",rowid,"OrderUserAdd")=""
			s OrderGridRowAry("OLD",rowid,"OrderUserDep")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderLogDep")=""
			s OrderGridRowAry("OLD",rowid,"OrderBillType")=""
			s OrderGridRowAry("OLD",rowid,"OrderStartDate")=""
			s OrderGridRowAry("OLD",rowid,"OrderFirstDayTimes")=""
			s OrderGridRowAry("OLD",rowid,"OrderLabSpec")=rset.Data("simpleDR")
			s OrderGridRowAry("OLD",rowid,"OrderLabEpisodeNo")=""
			s OrderGridRowAry("OLD",rowid,"OrderLabSpecRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderAutoCalculate")="N"
			s OrderGridRowAry("OLD",rowid,"OrderCoverMainIns")=""
			s OrderGridRowAry("OLD",rowid,"OrderInsurCat")=""
			s OrderGridRowAry("OLD",rowid,"OrderAction")=rset.Data("skinAction")
			s OrderGridRowAry("OLD",rowid,"OrderActionRowid")=rset.Data("skinActionId")
			
			s OrderGridRowAry("OLD",rowid,"OrderEndDate")=""
			s OrderGridRowAry("OLD",rowid,"OrderDIACat")=""
			s OrderGridRowAry("OLD",rowid,"OrderDIACatRowId")=""
			s OrderGridRowAry("OLD",rowid,"OrderBodyPart")=""
			s OrderGridRowAry("OLD",rowid,"OrderSpeedFlowRate")=rset.Data("flowRate")
			s OrderGridRowAry("OLD",rowid,"OrderFlowRateUnit")=rset.Data("flowRateDR")
			s OrderGridRowAry("OLD",rowid,"OrderNeedPIVAFlag")=""
			s OrderGridRowAry("OLD",rowid,"AntUseReason")=""
		
			s OrderGridRowAry("OLD",rowid,"OrderDate")=""	
			s OrderGridRowAry("OLD",rowid,"OrderItemRowid")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderPriorRowid")=rset.Data("priorDR")
			s OrderGridRowAry("OLD",rowid,"OrderType")=""
			//IDS
			s OrderGridRowAry("OLD",rowid,"OrderInstrRowid")=rset.Data("instrucDR")
			s OrderGridRowAry("OLD",rowid,"OrderDurRowid")=rset.Data("duratDR")
			s OrderGridRowAry("OrderPackUOMRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderRecDepRowid")=rset.Data("recLoc")
			s OrderGridRowAry("OLD",rowid,"OrderStatusRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderBaseUOMRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderDocRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderUserAddRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderLinkTo")=""
			s OrderGridRowAry("OLD",rowid,"OrderARCOSRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderDrugFormRowid")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderBillTypeRowid")=""
			s OrderGridRowAry("OLD",rowid,"OrderDoseUOMRowid")=rset.Data("dosageUomDR")
			s OrderGridRowAry("OLD",rowid,"OrderFreqRowid")=rset.Data("freqDR")
			s OrderGridRowAry("OLD",rowid,"OrderFlowRateUnit")=rset.Data("flowRateDR")
			s OrderGridRowAry("OLD",rowid,"OrderFlowRateUnitRowId")=rset.Data("flowRateID")
			s OrderGridRowAry("OLD",rowid,"ExceedReasonID")=""
			s OrderGridRowAry("OLD",rowid,"ExceedReason")=""
			s OrderGridRowAry("OLD",rowid,"OrderPilotProRowid")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderPilotPro")=""
			s OrderGridRowAry("OLD",rowid,"OrderUsableDays")=""
			s OrderGridRowAry("OLD",rowid,"Urgent")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderMasterSeqNo")=rset.Data("linkItem")
			s OrderGridRowAry("OLD",rowid,"OrderMaterialBarcode")=""
			s OrderGridRowAry("OLD",rowid,"OrderLocalInfusionQty")=""
			s OrderGridRowAry("OLD",rowid,"OrderStage")=rset.Data("stage")
			s OrderGridRowAry("OLD",rowid,"OrderStageCode")=rset.Data("stageCode")
			s OrderGridRowAry("OLD",rowid,"OrderPilotPro")=""
			s OrderGridRowAry("OLD",rowid,"OrderSelfOMFlag")=""
			s OrderGridRowAry("OLD",rowid,"OrderOutsourcingFlag")=""
			s OrderGridRowAry("OLD",rowid,"OrderBindSource")=""
			s OrderGridRowAry("OLD",rowid,"OrderHiddenPara")=""
			
			s OrderGridRowAry("OLD",rowid,"idiagnoscatstr")=""
			
			s OrderGridRowAry("OLD",rowid,"OrderOperation")=""
			s OrderGridRowAry("OLD",rowid,"OrderOperationCode")=""
			
			s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(rset.Data("arcim"))
		    s PoisonCode=""
		    i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	  		s OrderGridRowAry("OLD",rowid,"OrderPoisonRowid")=PoisonRowid
			s OrderGridRowAry("OLD",rowid,"OrderPoisonCode")=PoisonCode
			s OrderGridRowAry("OLD",rowid,"OrderFreqDispTimeStr")=""
			s OrderGridRowAry("OLD",rowid,"OrderBodyPartLabel")=""
			
			s records=+records+1
			/*s onedata=..GetOrderJSONStr(.OrderGridRowAry,TPLFlag)
			i onedata="" continue
			
			
			if (data=""){
				s data=onedata
			}else{
				s data=","_onedata
			}
			w data
			*/
		}	
		d rset.Close()
	}
	//d ..DoRowAry(.OrderGridRowAry,TPLFlag)
	s rowid=""
	f  s rowid=$o(OrderGridRowAry("OLD",rowid)) q:rowid=""  d
	.s onedata=..GetOrderJSONStr(.OrderGridRowAry,rowid)
	.q:onedata=""
	.i data="" s data=onedata
	.e  s data=","_onedata
	.w data
	
	w "]}"
	
	q ""
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).BuildGroupShow("3","1")
ClassMethod DoRowAry(ByRef OrderGridRowAry As %String, TPLFlag As %String)
{
	s rowid=""
	f  s rowid=$o(OrderGridRowAry("OLD",rowid)) q:rowid=""  d
	.i TPLFlag=1 d
	..s OrderMasterSeqNo=OrderGridRowAry("OLD",rowid,"OrderMasterSeqNo")
	..i OrderMasterSeqNo'="" d
	...s OrderMasterSeqNo=OrderGridRowAry("Index","TPGIID",OrderMasterSeqNo)
	...s OrderGridRowAry("OLD",rowid,"OrderMasterSeqNo")=OrderMasterSeqNo
	Q ""
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).BuildGroupShow("3","1")
ClassMethod GetOrderJSONStr(ByRef OrderGridRowAry As %String, rowid As %String)
{
	s ret=""
	s Field=""
	f  s Field=$o(OrderGridRowAry("OLD",rowid,Field)) q:Field=""  d
	.s key=Field
	.s value=OrderGridRowAry("OLD",rowid,Field)
	.i ret="" d
	..s ret=""""_key_""":"""_##class(web.DHCDocUtil).EvalJSON(value)_""""
	.else  d
	..s ret=ret_","_""""_key_""":"""_##class(web.DHCDocUtil).EvalJSON(value)_""""
	i ret'="" s ret="{"_ret_"}" 
	k OrderGridRowAry("OLD",rowid)
	q ret
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取当前化疗方案
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetCurrentPlan("8")
ClassMethod GetCurrentPlan(PatientID = "", EpisodeID = "") As %String
{
	s mRtn=""
	s currentDate=+$h
	s PLID="",findFlag=0
	
	f  s PLID=$o(^BS.DOC.Chemo.PlanI("ChemoPlan","PatientDR",PatientID,PLID)) q:(PLID="")||(findFlag=1)  d	
	.d GetPlanInfo
	/*
	if (EpisodeID="") {
		f  s PLID=$o(^BS.DOC.Chemo.PlanI("ChemoPlan","Adm",EpisodeID,PLID)) q:(PLID="")||(findFlag=1)  d
		.d GetPlanInfo
	} else {
		f  s PLID=$o(^BS.DOC.Chemo.PlanI("ChemoPlan","PatientDR",PatientID,PLID)) q:(PLID="")||(findFlag=1)  d	
		.d GetPlanInfo
	}*/
	
	Q mRtn
GetPlanInfo
	s status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
	s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	s totalNum=##class(DHCDoc.Chemo.COM.Func).GetTPLStage(TPID)
	q:status'="Y"
	;s startDate=##class(DHCDoc.Chemo.COM.Func).GetPlanStartDate(PLID,"2")
	;s endDate=##class(DHCDoc.Chemo.COM.Func).GetPlanEndDate(PLID,"2")
	;i (startDate<=currentDate)&&(currentDate<=endDate) s findFlag=1,mRtn=PLID
	;i (currentDate<=endDate) s findFlag=1,mRtn=PLID
	;同一阶段内可以同时存在两个以上的方案
	i mRtn="" s mRtn=PLID
	e  s mRtn=mRtn_","_PLID
	
	Q
}

/// CTOR: QP
/// DATE: 2020-11-30
/// DESC: 化疗确定后加载到医嘱录入的方法
/// IN  :   itmjs: AddCopyItemToList  	
/// 			itmjsex: ''
/// 			EpisodeId - PA_Adm表Id
/// 			AARowidStr - DHC_Doc_AntibioticApply表ID
/// OUT : 
/// Note: 以前: web.DHCDocAntibioticReason.GetAddToListArcimInfo AddCopyItemToList
/// EXEC: d ##class(DHCDoc.Chemo.BS.Apply).GetAddToListArcimInfo("20||1","2021-04-16","AddCopyItemToList","I","0"_$c(1)_"16"_$c(1)_"113"_$c(1)_"12175^29^113^2^undefined^20")
ClassMethod GetAddToListArcimInfo(PSID = "", PlanDate = "", itmjs = "", AdmType = "", ExtPara = "") As %String
{
	s ^TEMP("QP",1)=$LB(PSID,PlanDate,itmjs,AdmType,ExtPara)
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s EpisodeID="",SessionStr=""
	i ExtPara'="" {
		s InFlag=$p(ExtPara,$C(1),1)	;判断库存标志
		s EpisodeID=$p(ExtPara,$C(1),2)	
		s InLoc=$p(ExtPara,$C(1),3)
		s SessionStr=$p(ExtPara,$C(1),4)
	}
	s jsval=""
	s code=""
	s total=0
	s ret=0
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	;
	;得到周期所有暂存状态的天数
	;s days=##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage(PSID,"","","N",2)
	;得到
	s days=##class(websys.Conversions).DateHtmlToLogical(PlanDate)
	q:days="" 0	
	k RList
	s days=##class(DHCDoc.Chemo.COM.Func2).SortNum(days,"ASC",.RList)
	q:$o(RList(""))="" 0
	
	s PatientDR=$P(^BS.DOC.Chemo.PlanD(PLID),"^",1)
	
	k ^BS.DOC.Chemo.Temp("AddToList",$j)
	for {
		s code=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SID,code))
		q:(code="")||(ret'=0)
		s sub=""
		for {
			s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SID,code,sub))	
			q:(sub="")||(ret'=0)
			s id="",cdate=""
			for {
			  	s cdate=$o(RList(cdate)) 
			  	q:cdate=""
				s time=($p($h,",",2)+60)
				s currentTime=$zt(time,1)
				s currentStartDateVal=cdate
				s currentPlanDate=##class(websys.Conversions).DateLogicalToHtml(cdate)
				s currentPlanDate=currentPlanDate_" "_currentTime
				s ContainDay=""
				q:ret'=0
				for{
					s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id))
					q:(id="")||(ret'=0)
					s PGIID=PSID_"||"_sub_"||"_id
					s arcim=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",1)
					S ARC=+arcim,VER=$P(arcim,"||",2)
					S ArcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
					
					s dosage=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",2)
					s dosageUom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",3)
					s freq=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",4)
					s instrucDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",5)
					s duratDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",6)
					
					s qty=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",7)
					s uom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",8)
					s linkItem=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",9)

					s note=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",10)
					s priorDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",11)
					s priorCode=$P(^OECPR(priorDR),"^",1)
					continue:priorCode="OUT"
					s simple=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",12)
					s remark=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",13)
					s recLoc=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",14)
					s stage=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",15)
					s flowRate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",16)
					s flowRateUom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",17)
					s skinTest=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",18)
					s skinAction=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",19)
					s tplGroupItem=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",20)
					s bsaUnit=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",21)
					s bsa=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",22)
					s ShowDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",28)
					s IsExit=##class(DHCDoc.Chemo.BS.Ext.Process).FiletrShowDate(ShowDate,cdate)
					continue:IsExit=1
					s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
					s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
					s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
					//s HasOverLifeDose=..HasOverLifeDose(arcim,bsaUnit,PatientDR)
					//i HasOverLifeDose=1 s ret2=-1	//超过终身剂量
					s PHCDRowid=$P(DrgformRowid,"||",1)
				  	s ChildSub=$P(DrgformRowid,"||",2)
					//s FormDoseQty=dosage
					s FormDoseQty=##class(DHCDoc.Chemo.COM.Func2).ComDealToNum(dosage)
				  	s FormDoseUOMRowid=dosageUom
				  	s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
				  	;疗程
				  	s FormDurRowid=duratDR
				  	i FormDurRowid'=""  d
					.s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
					.s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
					;频率
				  	s FormFreqRowid=freq
				    i FormFreqRowid'=""  d
					.s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
					.s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
					.s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
					
					;用法
					s Instruc=""
					i instrucDR'="" s Instruc=$p(^PHCIN(instrucDR),"^",2) 
					s OrderSkinTest=skinTest
					s OrderActionRowid=skinAction
					s OrderAction=skinAction
					;
					s OrderPackQty=qty
					s OrderPackUOMRowid=uom
					s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(uom)
					;医嘱类型
					s OrderPriorRowid=priorDR
					s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
					;流速
					s OrdSpeedFlowRate=flowRate
					s OrderFlowRateUnit=flowRateUom
					s OrderFlowRateUnitdesc=""
					i OrderFlowRateUnit'="" s OrderFlowRateUnitdesc=$p(^OEC("SFR",OrderFlowRateUnit),"^",2)
					
					s OrderNotifyClinician="",OrderBodyPartLabel=""
					s AARowid="",UseReasonID=""
					s CurrentOrderEndDate="",OrderEndDate=""
					
					/*i AdmType="O" {
						s QTYList("EpisodeID")=EpisodeID
						s QTYList("SessionStr")=SessionStr
						s QTYList("OrderPriorRowid")=OrderPriorRowid
						s QTYList("OrderARCIMRowid")=arcim
						s QTYList("OrderDoseQty")=dosage
						s QTYList("OrderDoseUOMRowid")=dosageUom
						s QTYList("OrderFreqRowid")=FormFreqRowid
						s QTYList("OrderDurRowid")=""
						s QTYList("OrderPackQty")=OrderPackQty
						s QTYList("OrderPackUOMRowid")=OrderPackUOMRowid
						s QTYList("OrderRecDepRowid")=recLoc
						s BNum=##class(DHCDoc.Chemo.BS.Ext.Process).GetBNum(cdate,orderDur,qty,.ShowDateList,.BList,.QTYList)
					}*/
					
					s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
					s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
					s ItemData=ItemData_"^"_Instruc_$C(1)_instrucDR
					s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
					s ItemData=ItemData_"^"_OrderPackQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMRowid
					s ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorRowid_$C(1)_""
					s ItemData=ItemData_"^^^^"_note_"^"_remark
					s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID	//12
					s ItemData=ItemData_"^"_OrderNotifyClinician_"^^^^"_OrdSpeedFlowRate_$C(1)_OrderFlowRateUnitdesc_$C(1)_OrderFlowRateUnit_"^"_OrderBodyPartLabel
					s ItemData=ItemData_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest	//21	
					s ItemData=ItemData_"^^^^^^^"_currentPlanDate_"^"_PGIID_"^"_OrderEndDate_"^"_ContainDay
					s OrderType="",OrderSeqNo=linkItem,ID=""
					s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
					if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
					s total=total+1
					s ^BS.DOC.Chemo.Temp("AddToList",$j,currentStartDateVal,total)=arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType
					s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_""_""";"
					
				}
			}
			
		}
	}

	if (itmjs'="")&&(jsval'="") {
		
		s jsval=""
		s cdate=""
		f  s cdate=$o(^BS.DOC.Chemo.Temp("AddToList",$j,cdate)) q:cdate=""  d
		.s seqno=""
		.f  s seqno=$o(^BS.DOC.Chemo.Temp("AddToList",$j,cdate,seqno)) q:seqno=""  d
		..s cval=$g(^BS.DOC.Chemo.Temp("AddToList",$j,cdate,seqno))
		..s arcim=$p(cval,"!",1)
		..s OrderSeqNo=$p(cval,"!",2)
		..s ItemData=$p(cval,"!",3)
		..s OrderType=$p(cval,"!",4)
		..s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_""_""";"
	
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary,1);"
	
		&javascript<#(jsval)#>
	} else {
		s StockFlag=1,msg=""
		i InFlag=1 {	//判断库存
			s cdate=""
			f  s cdate=$o(^BS.DOC.Chemo.Temp("AddToList",$j,cdate)) q:(cdate="")||(StockFlag=0)  d
			.s seqno=""
			.f  s seqno=$o(^BS.DOC.Chemo.Temp("AddToList",$j,cdate,seqno)) q:(seqno="")||(StockFlag=0)  d
			..s cval=$g(^BS.DOC.Chemo.Temp("AddToList",$j,cdate,seqno))
			..s arcim=$p(cval,"!",1)
			..s RecLoc=##class(DHCDoc.Chemo.COM.CallMethod).GetDefaultRecLoc(EpisodeID,arcim)
			..s RecLocName=$P(^CTLOC(RecLoc),"^",2)
			..s OrderSeqNo=$p(cval,"!",2)
			..s ItemData=$p(cval,"!",3)
			..s OrderType=$p(cval,"!",4)
			..s PackQtyInfo=$p(ItemData,"^",5)
			..s remark=$p(ItemData,"^",11)
			..q:remark="OM"	;过滤自备药
			..s PackQty=$p(PackQtyInfo,$C(1),1)
			..s ExpStr=EpisodeID_"^"_InLoc	//_"^"_0
			..s StockRtn=##class(DHCDoc.Chemo.COM.CallMethod).CheckStockEnough(arcim,PackQty,RecLoc,EpisodeID,ExpStr)
			..s StockFlag=$p(StockRtn,"^",1)
			..s ARC=+arcim,VER=$P(arcim,"||",2)
			..s arcimName=$p(^ARCIM(ARC,VER,1),"^",2)
			..s ^QP("StockInfo")=$lb(arcim,PackQty,RecLoc,EpisodeID,ExpStr)
			..i StockFlag=0 s msg=arcimName_RecLocName_"库存不足！"
			
			k ^BS.DOC.Chemo.Temp("AddToList",$j)
			Q StockFlag_"^"_msg
		}
		
	}
	
	k ^BS.DOC.Chemo.Temp("AddToList",$j)
	q ret
}

/// CTOR: QP
/// DATE: 2016-08-14
/// DESC: 化疗确定后加载到医嘱录入的方法
/// IN  :   itmjs: AddCopyItemToList  	
/// 			itmjsex: ''
/// 			EpisodeId - PA_Adm表Id
/// 			AARowidStr - DHC_Doc_AntibioticApply表ID
/// OUT : 
/// Note: 以前: web.DHCDocAntibioticReason.GetAddToListArcimInfo AddCopyItemToList
/// EXEC: d ##class(DHCDoc.Chemo.BS.Apply).GetAddToListArcimInfo("287||1","2020-10-23","AddCopyItemToList")
ClassMethod GetAddToListArcimInfoOld(PSID = "", PlanDate = "", itmjs = "", AdmType = "") As %String
{
	s ^TEMP("QP",1)=$LB(PSID,PlanDate,itmjs,AdmType)
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s jsval=""
	s code=""
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	;
	s days=##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage(PSID,"","","N",2)
	s orderRule=##class(DHCDoc.Chemo.COM.Func2).BuildNumAsc(SDate,days,AdmType)
	q:PlanDate="" 0
	s PatientDR=$P(^BS.DOC.Chemo.PlanD(PLID),"^",1)
	s ret=0
	for {
		s code=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SID,code))
		q:(code="")||(ret'=0)
		s sub=""
		for {
			s sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","Code",PLID,SID,code,sub))	
			q:(sub="")||(ret'=0)
			s id=""
			for i=1:1:$l(PlanDate,",") {
				s currentPlanDate=$p(PlanDate,",",i)
				s time=$p($h,",",2)
				s currentTime=$zt(time,1)
				s currentPlanDate=currentPlanDate_" "_currentTime
				q:ret'=0
				for{
					s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id))
					q:(id="")||(ret'=0)
					s PGIID=PSID_"||"_sub_"||"_id
					s arcim=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",1)
					s dosage=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",2)
					s dosageUom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",3)
					s freq=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",4)
					s instrucDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",5)
					s duratDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",6)
					s qty=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",7)
					s uom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",8)
					s linkItem=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",9)
					s note=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",10)
					s priorDR=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",11)
					s priorCode=$P(^OECPR(priorDR),"^",1)
					continue:priorCode="OUT"
					s simple=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",12)
					s remark=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",13)
					s recLoc=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",14)
					s stage=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",15)
					s flowRate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",16)
					s flowRateUom=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",17)
					s skinTest=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",18)
					s skinAction=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",19)
					s tplGroupItem=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",20)
					s bsaUnit=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",21)
					s bsa=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id),"^",22)
					s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
					s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
					s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
					s HasOverLifeDose=..HasOverLifeDose(arcim,bsaUnit,PatientDR)
					i HasOverLifeDose=1 s ret2=-1	//超过终身剂量
					s PHCDRowid=$P(DrgformRowid,"||",1)
				  	s ChildSub=$P(DrgformRowid,"||",2)
					s FormDoseQty=dosage
				  	s FormDoseUOMRowid=dosageUom
				  	s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
				  	;添加默认疗程
				  	s FormDurRowid=duratDR
				  	i FormDurRowid'=""  d
					.s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
					.s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
					;频率
				  	s FormFreqRowid=freq
				    i FormFreqRowid'=""  d
					.s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
					.s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
					.s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
					;用法
					s Instruc=$p(^PHCIN(instrucDR),"^",2) 
					s OrderSkinTest=skinTest
					s OrderActionRowid=skinAction
					s OrderAction=skinAction
					;
					s OrderPackQty=qty
					s OrderPackUOMRowid=uom
					s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(uom)
					;频次
					s OrderPriorRowid=priorDR
					s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
					;流速
					s OrdSpeedFlowRate=flowRate
					s OrderFlowRateUnit=flowRateUom
					s OrderFlowRateUnitdesc=""
					i OrderFlowRateUnit'="" s OrderFlowRateUnitdesc=$p(^OEC("SFR",OrderFlowRateUnit),"^",2)
					
					s OrderNotifyClinician="",OrderBodyPartLabel=""
					s AARowid="",UseReasonID=""
					s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
					s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
					s ItemData=ItemData_"^"_Instruc_$C(1)_instrucDR
					s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
					s ItemData=ItemData_"^"_OrderPackQty_$C(1)_OrderPackUOM_$C(1)_OrderPackUOMRowid
					s ItemData=ItemData_"^"_OrderPrior_$C(1)_OrderPriorRowid_$C(1)_""
					s ItemData=ItemData_"^^^^^"_remark
					s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID	//12
					s ItemData=ItemData_"^"_OrderNotifyClinician_"^^^^"_OrdSpeedFlowRate_$C(1)_OrderFlowRateUnitdesc_$C(1)_OrderFlowRateUnit_"^"_OrderBodyPartLabel
					s ItemData=ItemData_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest	//21	
					s ItemData=ItemData_"^^^^^^"_currentPlanDate_"^"_PGIID
					s OrderType="",OrderSeqNo=linkItem,ID=""
					s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
					if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
					s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_""_""";"
					
				}
			}
			
		}
	}
	//Q:ret'=0 ret
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary,1);"
		//s jsval="new Promise(function(res,rej){ var Copyary=new Array();"_jsval_itmjs_"(Copyary);"_"  }).then(function(){ Test() })"
		&javascript<#(jsval)#>
	}
	q ret
}

/// CTOR: QP
/// DATE: 2020-05-19
/// DESC: 获取当前化疗方案
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).AdjustOrdDose("8")
ClassMethod AdjustOrdDose(PGIID = "", Dosage = "") As %String
{
	s mRtn=0
	S PLID=$p(PGIID,"||",1)
	S SUB=$p(PGIID,"||",2)
	S CH=$p(PGIID,"||",3)
	s PlanDate=$p(^CF.DOC.THPY.PlanD(PLID,"G",SUB),"^",6)
	s OrderDep=$p(^CF.DOC.THPY.PlanD(PLID),"^",4) 
	s OrderUser=$p(^CF.DOC.THPY.PlanD(PLID),"^",5) 
	q:PlanDate="" mRtn
	for j=1:1:$l(PlanDate,",") {
		q:mRtn'=0
		s CPlanDate=$p(PlanDate,",",j)	
		s CPlanDate=##class(websys.Conversions).DateHtmlToLogical(CPlanDate)
		s PGIOID=$o(^CF.DOC.THPY.PlanGroupItemOrderI("PlanAndDate",PGIID,CPlanDate,""))
		continue:PGIOID=""
		s oeori=$p(^CF.DOC.THPY.PlanGroupItemOrderD(PGIOID),"^",1)
		s result=##class(appcom.OEOrdItem).AdjustOrdDose(oeori,Dosage,OrderDep,OrderUser) 
		i result'=0 s mRtn=result
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-19
/// DESC: 获取周期下次化疗日期
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetNextDay("146||1")
ClassMethod GetNextDay(PSID) As %String
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=$p(PSID,"||",1)
	s SID=$p(PSID,"||",2)
	s PSEndDate=$P(^BS.DOC.Chemo.PlanD(PLID,SID),"^",4)
	s sub=""
	f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) Q:sub=""  d
	.s planDate=$P(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)
	.q:planDate=""
	.i mRtn="" s mRtn=planDate
	.e  d
	..i mRtn'[planDate s mRtn=mRtn_","_planDate
	
	i mRtn="" d
	.i PSEndDate'="" d
	..s mRtn=##class(websys.Conversions).DateLogicalToHtml(PSEndDate+1)
	e  d
	.i PSEndDate'="" d
	..s PSEndDate=##class(websys.Conversions).DateLogicalToHtml(PSEndDate+1)
	..s mRtn=mRtn_","_PSEndDate
	b ;002
	s mRtn=##class(DHCDoc.Chemo.COM.Func).GetMinValue(mRtn,1,+$H)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-18
/// DESC: 获取预计化疗日期串
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetPLDateS("24||1",2)
ClassMethod GetPLDateS(PSID, Format = 1) As %String
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=$p(PSID,"||",1)
	s SID=$p(PSID,"||",2)
	s sub=""
	f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) Q:sub=""  d
	.s planDate=$P(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)
	.q:planDate=""
	.f i=1:1:$l(planDate,",") d
	..s cpDate=$p(planDate,",",i)
	..i Format=2 s cpDate=##class(websys.Conversions).DateHtmlToLogical(cpDate)
	..i mRtn="" d
	...s mRtn=cpDate
	..e  d
	...i mRtn'[cpDate s mRtn=mRtn_","_cpDate
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-25
/// DESC: 获取化疗方案主药信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetMainDrug("18||1","CUR")
ClassMethod GetMainDrug(PSID, InType, isEdit = "") As %String
{
	Q:(PSID="")||(InType="") ""
	s mRtn="<div>"
	s eRtn=""
	s PLID=$p(PSID,"||",1),SUB=$p(PSID,"||",2)
	s ^QP("GetMainDrug",1)=$LB(PSID, InType)
	i (InType="CUR")||(InType="HIS"){
		s TPID=$P(^BS.DOC.Chemo.PlanD(PLID),"^",3)
		s result=$P(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",25)
		i result="" s result=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",12)
		i result'=""{
			s eRtn=result
			s mRtn=mRtn_##class(DHCDoc.Chemo.COM.Func2).FilterToHtml(result)
		}
		
	} else {
		s result=$p(^CF.DOC.Chemo.TemplateD(PLID),"^",12)
		i result'=""{
			s eRtn=result
			s mRtn=mRtn_##class(DHCDoc.Chemo.COM.Func2).FilterToHtml(result)
		}
	}
	s mRtn=mRtn_"</div>"
	Q:isEdit'="" eRtn
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-18
/// DESC: 获取周期主药信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetMainDrug("30||1","DEP")
ClassMethod GetMainDrugOld(PSID, InType) As %String
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=$p(PSID,"||",1)
	s SID=$P(PSID,"||",2)
	
	i (InType="CUR")||(InType="HIS"){
		s Sub=""
		f  s Sub=$o(^BS.DOC.Chemo.PlanI("ChemoPlanGroup","MainDrug",PLID,SID,"Y",Sub)) Q:Sub=""  d
		.s id=""
		.f  s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id)) q:id=""  d
		..s arcim=$P(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id),"^",1)
		..s tplItem=$P(^BS.DOC.Chemo.PlanD(PLID,SID,Sub,id),"^",20)
		..s mainFlag="N"
		..s mainNote=""
		..i tplItem'="" d
		...s tplItemOBJ=##class(User.ChemoTemplateItem).%OpenId(tplItem)
		...s mainFlag=tplItemOBJ.TPGIMainDrug
		...s mainNote=tplItemOBJ.TPGIMainDrugNote
		..Q:mainFlag="N"
		..;Q:mainNote=""
		..s arc=+arcim,ver=$p(arcim,"||",2)
		..s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
		..s li="<li>"_mainNote_"</li>"
		..i mRtn="" s mRtn=li
		..e  s mRtn=mRtn_li
	} else {
		s Sub=""
		f  s Sub=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","MainDrug",PLID,SID,"Y",Sub)) Q:Sub=""  d
		.s id=""
		.f  s id=$o(^CF.DOC.Chemo.TemplateD(PLID,SID,Sub,id)) q:id=""  d
		..s arcim=$P(^CF.DOC.Chemo.TemplateD(PLID,SID,Sub,id),"^",1)
		..s mainFlag=$P(^CF.DOC.Chemo.TemplateD(PLID,SID,Sub,id),"^",20)
		..s mainNote=$P(^CF.DOC.Chemo.TemplateD(PLID,SID,Sub,id),"^",24)
		..Q:mainFlag="N"
		..s arc=+arcim,ver=$p(arcim,"||",2)
		..s arcimDesc=$p(^ARCIM(arc,ver,1),"^",2)
		..s li="<li>"_mainNote_"</li>"
		..i mRtn="" s mRtn=li
		..e  s mRtn=mRtn_li
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-18
/// DESC: 调整化疗日期,每个组都会加上该日期
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).AdjustPlanDate("2020-06-20")
ClassMethod AdjustPlanDate(PSID, AdjDateFrom, AdjDateTo) As %String
{
	s ok=0
	Q:PSID="" mRtn
	s PLID=$p(PSID,"||",1)
	s SID=$p(PSID,"||",2)
	s sub=""
	s PLDateS=..GetPLDateS(PSID)
	q:PLDateS[AdjDateTo ok
	
	f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) Q:sub=""  d
	.s planDate=$P(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)
	.i planDate="" s planDate=AdjDateTo
	.e  d
	..s mPDate=""
	..f i=1:1:$l(planDate,",") d
	...s itemDate=$p(planDate,",",i)
	...q:itemDate=AdjDateFrom
	...i mPDate="" s mPDate=itemDate
	...e  s mPDate=mPDate_","_itemDate
	..i mPDate=AdjDateTo
	..e  s mPDate=mPDate_","_AdjDateTo
	..s mPDate=##class(DHCDoc.Chemo.COM.Func).SortValue(mPDate,"ASC")
	..s $P(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)=mPDate
	
	Q ok
}

/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).InitDateTree("3","14","")
ClassMethod InitDateTree(PatientID = "", EpisodeID = "", PLID = "") As %String
{
	s ^QP("InitDateTree")=$LB(PatientID,EpisodeID,PLID)
	i PLID=""{
		S PLID=..GetCurrentPlan(PatientID,EpisodeID)
		Q:PLID="" ""
	}
	s CDate=+$h
	//^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",{Chemo_Plan.PL_ID},{PS_Stage},{PS_ChildSub})
	w "["
	
	f k=1:1:$l(PLID,",") {
		s CPLID=$P(PLID,",",k)
		s PLName=$p(^BS.DOC.Chemo.PlanD(CPLID),"^",2)	//化疗方案名称
		w "{""id"":"""_CPLID_""",""text"":"""_PLName_"",""",""children"":["
		
		s SID=""
		s j=0
		f  s SID=$O(^BS.DOC.Chemo.PlanD(CPLID,SID)) Q:SID=""  D
		.s stage=$p(^BS.DOC.Chemo.PlanD(CPLID,SID),"^",1)
		.s stageDesc=$p(^BS.DOC.Chemo.PlanD(CPLID,SID),"^",2)
		.s TSID=CPLID_"||"_SID
		.s planDateS=##class(DHCDoc.Chemo.BS.Apply).GetPLDateS(TSID)
		.Q:planDateS=""
		.s j=j+1
		.i j=1 w "{""id"":"""_TSID_""",""text"":"""_stageDesc_"",""",""children"":["
		.e  w ",{""id"":"""_TSID_""",""text"":"""_stageDesc_"",""",""children"":["
		.s count=0
		.f i=1:1:$l(planDateS,",")  d
		..s checked="false"
		..s id=TSID_"-"_i
		..s count=count+1
		..s text=$p(planDateS,",",i)
		..i ##class(DHCDoc.Chemo.BS.Ext.Audit).IsCurrentDate(text)=1 s checked="true"
		..i count=1 w "{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"	
		..e  w ",{""id"":"""_id_""",""text"":"""_text_""",""checked"":"_checked_"}"
		.w "]}"
		
		w "]}"
	}
	
	w "]"
	Q ""
}

/// CTOR: QP
/// DATE: 2020-06-23
/// DESC: 过敏史确认
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GMisOK("1||1")
ClassMethod GMisOK(OKUser, PSID, HasGMis, GMisFill) As %String
{
	s OKDate = +$h
	s OKTime = $p($h,",",2)
	s OKGMis= 1
	&SQL(
		UPDATE 
			SQLUser.Chemo_PlanStage 
		SET 
			PS_GMisOK=:OKGMis,PS_OKUser=:OKUser,
			PS_OKDate=:OKDate,PS_OKTime=:OKTime,
			PS_HasGMis=:HasGMis,PS_GMisFill=:GMisFill
		WHERE PS_ID=:PSID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-06-23
/// DESC: 是否超过终身剂量
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).HasOverLifeDose("403||1","121","133")
ClassMethod HasOverLifeDose(InArcim, BSAUnit, PatientID) As %String
{
	s ^QP("HasOverLifeDose")=$LB(InArcim, BSAUnit, PatientID)
	s over=1,no=0
	s LifeDose=##class(DHCDoc.Chemo.CFG.LifeDose).GetLifeDose(InArcim)
	Q:(LifeDose="")||(LifeDose=0) no	//未配置不做控制
	s ALLBSAUnit=..GetAllBSAUnit(PatientID,InArcim)
	s NewVal=ALLBSAUnit+BSAUnit
	b ;001
	Q:NewVal>LifeDose over
	
	Q no
}

/// CTOR: QP
/// DATE: 2020-06-27
/// DESC: 获取患者累计的剂量值
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetAllBSAUnit(8,"176||1")
ClassMethod GetAllBSAUnit(PatientID, InArcim) As %String
{
	s mRtn=0
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI("PatientArcim",PatientID,InArcim,id)) q:id=""  d
	.s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(id),"^",2)
	.q:(ItemDR="undefined")||(ItemDR="")
	.s a=##class(User.ChemoPlanItem).%OpenId(ItemDR)
	.Q:'$ISObject(a)
	.s formula=a.PGIFormula
	.q:formula'="BSA"
	.s BSAUnit=a.PGIBSAUnit
	.s mRtn=mRtn+BSAUnit
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-23
/// DESC: 获取可开具的化疗日期
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).EnableDate("24||1")
ClassMethod EnableDate(PSID) As %String
{
	S CDate=+$H
	S mRtn=""
	S PlanDateS=..GetPLDateS(PSID,2)
	F i=1:1:$l(PlanDateS,",") {
		S Item=$p(PlanDateS,",",i)
		continue:Item<CDate
		S Item=##class(websys.Conversions).DateLogicalToHtml(Item)
		I mRtn="" s mRtn=Item
		e  s mRtn=mRtn_","_Item
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-13
/// DESC: 获取当前在用模板
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetCurrentTPL("8")
ClassMethod GetCurrentTPL(PatientID = "") As %String
{
	s mRtn=""
	s PLIDS=..GetCurrentPlan(PatientID,"")
	q:PLIDS="" mRtn
	f i=1:1:$l(PLIDS,",") {
		s PLID=$P(PLIDS,",",i)	
		s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
		s Status=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
		continue:(TPID="")||(Status'="Y")
		i mRtn="" s mRtn=TPID
		e  s mRtn=mRtn_","_TPID
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-08
/// DESC: 获取数据总数
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GetGridNum("416||1","CUR","2022-01-04",879,2021,"12175^134^15^2^^20")
ClassMethod GetGridNum(TSID = "", InType = "", SelectDate = "", PatientID = "", EpisodeID = "", SessionStr = "") As %String
{
	s mRtn=0
	s TPID=$p(TSID,"||",1)
	s SID=$p(TSID,"||",2)
	s TPLFlag=0
	i (InType="CUR")||(InType="HIS") {
		s rset=##Class(%ResultSet).%New("DHCDoc.Chemo.BS.Item:QryAllItem")
	} else {
		s rset=##Class(%ResultSet).%New("DHCDoc.Chemo.CFG.Item:QryAllItem")
		s TPLFlag=1
	}
	
	s page=1,total=0,records=0,data=""
	
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(TSID,SelectDate,PatientID,EpisodeID,SessionStr)
		If 'Status Quit total
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s total=total+1
		}
	}
	s mRtn=total
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-12
/// DESC: 更新主药信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).UpdateMainDrugInfo("")
ClassMethod UpdateMainDrugInfo(PSID As %String, MainDrugInfo)
{
	Q:PSID="" 0
	&SQL(UPDATE 
		 SQLUser.Chemo_PlanStage 
		 SET PS_MainDrugInfo=:MainDrugInfo
		 WHERE PS_ID=:PSID)
	Q:SQLCODE'=0 "-166"
	
	Q 0
}

}
