/// Description：体检调查问卷处理类
/// Creator：wangguoying
Class web.DHCPE.HM.ExamSurveyHandler Extends %RegisteredObject
{

Parameter SurveyStationID = 1;

/// Descript:获取调查问卷内容
/// Input:
/// 				QuesID:问卷ID
/// Return: $Job
/// Creater:	wangguoying
/// CreateDate:	2019-03-12
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).QuerySurveyDetail("7","AM8699213","","","1332||1332","Y")
ClassMethod QuerySurveyDetail(QuesID, PatientRegNo = "", CertificateNo = "", CertificateType = "", EQID = "", DocFlag = "N")
{
	s:EQID="1332||1332" ^tmpwgy("QuerySurveyDetail")=$lb(QuesID, PatientRegNo , CertificateNo, CertificateType, EQID,DocFlag)
	s Job=$J_"a"_$Replace(EQID,"||","a")
	k ^TMPDHCPEHMQuestion(Job)
	s QuesObj=##class(User.DHCHMCQuestionnaire).%OpenId(QuesID)
	s Active=QuesObj.QActive
	q:Active'="Y"
	s Pid=##class(HS.BL.ExamSurvey).CollectQuestionLastResult(QuesID,PatientRegNo_"^"_CertificateType_"^"_CertificateNo,EQID)
	b ;Pid
	s SexCode=""  ;BI_CSex_DR  DHC_HM_CCodeTable
	s Age=""  //年龄
	i EQID'="" d
	.s EvaluationObj=##class(User.DHCHMOEvaluationRecord).%OpenId(+EQID)
	.s SexCode=EvaluationObj.QOBaseInfoDR.BICSexDR.CTCode
	.s:PatientRegNo="" PatientRegNo=EvaluationObj.QOBaseInfoDR.BIPAPMINo
	.s PreIADM=$G(^DHCPEDataNewEx("HMToPreIADM",+EQID))
	.i PreIADM'=""  d
	.s ^TMPDHCPEHMQuestion(Job,"PreIADM")=PreIADM
	.s LocID = $P(^DHCPEPreIADM(PreIADM),"^",26)
	
	i $G(LocID)=""
	{
		s LocID = %session.Get("LOGON.CTLOCID")
	}
	
	i PatientRegNo'=""  d
	.s PIBI=$O(^DHCPEPreIBI(0,"PAPMINo",PatientRegNo,""))
	.i PIBI'=""  d
	..s SexDr=$P(^DHCPEPreIBI(PIBI),"^",3)
	..s:SexDr="1" SexCode="M"
	..s:SexDr="2" SexCode="F"
	
	.s patId = $O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientRegNo),""))
	.i patId'=""  d
	..s Age=+##class(web.DHCBillInterface).GetPapmiAge(patId,"",2)
	s Order=""
	f  s Order=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesID,Order)) q:Order=""  d
	.s Child=0
	.f  s Child=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesID,Order,Child)) q:Child=""  d
	..s SubjectActive=$lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),2)
	..q:SubjectActive'="Y"
	..s SubjectSex=$lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),7)
	..s:SubjectSex="" SubjectSex="N"
	..;w "SubjectSex="_SubjectSex_"  SexCode="_SexCode,!
	..q:(SubjectSex'="N")&&(SexCode'="N")&&(SubjectSex'=SexCode)
	..s doctorFlag = $lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),8)
	..q:(DocFlag="N")&&(doctorFlag="Y")
	
	..s minAge = $lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),9)
	..s maxAge = $lg(^User.DHCHMCQuestionnaireD(QuesID,"QSubject",Child),10)
	..q:(Age'="")&&(((minAge'="")&&(Age<minAge))||((maxAge'="")&&(Age>maxAge)))
	
	..s SubjectID=QuesID_"||"_Child
	..s SubjectObj=##class(User.DHCHMCQuestionSubject).%OpenId(SubjectID)
	..s SubjectDesc=SubjectObj.QSDesc
	..s SubjectRemark=SubjectObj.QSRemark
	..s ^TMPDHCPEHMQuestion(Job,"Subject",QuesID,Order,SubjectID)=SubjectDesc_"^"_SubjectRemark
	..d ..SetDetailGlobalBySubject(Job,SubjectID,Pid,SexCode,LocID)
	i Pid'=""
	{
		k ^TEMPMHCHS("QuestionResult",Pid)
	}
	q Job
}

ClassMethod SetDetailGlobalBySubject(Job, SubjectID, Pid, BISexCode = "", LocID As %String = "")
{
	s QuesID=+SubjectID
	s Child=$P(SubjectID,"||",2)	
	s DetailOrder=""
	f  s DetailOrder=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",QuesID,Child,DetailOrder)) q:DetailOrder=""  d
	.s LinkChild=0
	.f  s LinkChild=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",QuesID,Child,DetailOrder,LinkChild)) q:LinkChild=""  d
	..s LinkId=QuesID_"||"_Child_"||"_LinkChild
	..s LinkObj=##class(User.DHCHMCSDLink).%OpenId(LinkId)
 	..q:LinkObj="" 
 
 	..q:LinkObj.SDLActive'="Y" 
	..s DetailId=LinkObj.SDLQuestionsDetailDR.%Id()
	..q:DetailId="" 
	..s DetailActive=LinkObj.SDLQuestionsDetailDR.QDActive
	..q:DetailActive'="Y" 
	..q:(LocID'="")&&($D(^User.DHCHMCQDetailLocI("IndexLoc",DetailId)))&&('$D(^User.DHCHMCQDetailLocI("IndexLoc",DetailId,LocID)))
	..s ^TMPDHCPEHMQuestion(Job,"LinkDetail",QuesID,Child,DetailOrder,LinkChild)=""  ;暂时不用
	..s DetailRemark="" ;LinkObj.SDLQuestionsDetailDR.QDRemark
	..s DetailDesc=LinkObj.SDLQuestionsDetailDR.QDDesc
	..s DetailNote=LinkObj.SDLQuestionsDetailDR.QDNote
	..s DetailNoteType=LinkObj.SDLQuestionsDetailDR.QDNoteType
	..s DetailUnit=LinkObj.SDLQuestionsDetailDR.QDUnit
	..s DetailEleNum=LinkObj.SDLQuestionsDetailDR.QDElementNum
	..s DetailLinkCode=LinkObj.SDLQuestionsDetailDR.QDLinkCode
	
	..s YYFlag =1 //眼压标记
	..i (DetailLinkCode="PE040016")||(DetailLinkCode="PE040017")  d
	...s PreIADM = $G(^TMPDHCPEHMQuestion(Job,"PreIADM"))
	...i PreIADM'=""  d
	....s YYFlag = ..IsContainYY(PreIADM)
	
	..q:YYFlag=0
		
	..s DetailRequired=LinkObj.SDLQuestionsDetailDR.QDRequired
	..s DetailSex=LinkObj.SDLQuestionsDetailDR.QDSex

	..q:(BISexCode'="")&&(DetailSex'="")&&(DetailSex'="N")&&(BISexCode'=DetailSex)  ;性别过滤
	..s DetailType=LinkObj.SDLQuestionsDetailDR.QDType
	..s ShowFlag=1
	..i $o(^User.DHCHMCQDOLinkDetailI("CSDLinkID",LinkId,0))'=""  d
	...s ShowFlag=0	//被关联了
	...i Pid'=""  d
	....s linkDetail = $O(^User.DHCHMCQDOLinkDetailI("CSDLinkID",LinkId,""))  //只能被一个选项所关联
	....s linkOptionSub = $O(^User.DHCHMCQDOLinkDetailI("CSDLinkID",LinkId,linkDetail,""))
	
	....s resultInfo = $g(^TEMPMHCHS("QuestionResult",Pid,linkDetail,linkDetail_"||"_linkOptionSub))
	....s:$P(resultInfo,"^",1)'="" ShowFlag=1  //关联选项存在答案
	
	
	..;s:DetailRemark="" DetailRemark="000"
	..b:DetailId=218  //218																	1ID			2描述		  3类型			4必选				5提示			6提示类型		7单位			8 性别			9关联外部代码		10显示列数		11 备注           12是否显示 13结果值
	..s ^TMPDHCPEHMQuestion(Job,"Detail",QuesID,Child,DetailOrder,LinkChild)=DetailId_"^"_DetailDesc_"^"_DetailType_"^"_DetailRequired_"^"_DetailNote_"^"_DetailNoteType_"^"_DetailUnit_"^"_DetailSex_"^"_DetailLinkCode_"^"_DetailEleNum_"^"_DetailRemark_"^"_ShowFlag_"^"
	..d ..SetOptionGlobalByDetail(Job,Pid,LinkId,DetailOrder,DetailId,BISexCode)
}

ClassMethod SetOptionGlobalByDetail(Job, Pid, LinkId, DetailOrder, DetailId, BISexCode = "")
{
	s TxtFlag=1
	s ResultFlag=0   //是否已填写答案标记  已填写答案时，默认值无效
	s OptionOrder=""
	f  s OptionOrder=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder)) q:OptionOrder=""  d
	.s OptionChild=0
	.f  s OptionChild=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder,OptionChild)) q:OptionChild=""  d
	..s OptionId=DetailId_"||"_OptionChild
	..s TxtFlag=0
	..s OptionObj=##class(User.DHCHMCQDOptions).%OpenId(OptionId)
	..s OptionDesc=OptionObj.QDODesc
	..s OptionActive=OptionObj.QDOActive
	..q:OptionActive'="Y"
	..s OptionDefaultValue=OptionObj.QDODefault
	..s OptionSex=OptionObj.QDOSex
	..q:(BISexCode'="")&&(BISexCode'="N")&&(OptionSex'="")&&(OptionSex'="N")&&(BISexCode'=OptionSex)  ;性别过滤
	
	..s LinkDetailId=##class(HS.BL.ExamSurvey).GetOptionLinkedQuestion(OptionId)
	..s ExclusiveDetailId=##class(HS.BL.ExamSurvey).GetOptionNoLinkedQuestion(OptionId,LinkDetailId)
	..s InputFlag=OptionObj.QDONote
	..s ResultValue=""
	..s ResultNote=""
	..i Pid'=""  d
	...s ResultInfo=$g(^TEMPMHCHS("QuestionResult",Pid,DetailId,OptionId))
	...s ResultNote=$p(ResultInfo,"^",2)
	...s ResultValue=$p(ResultInfo,"^",1) 
	...i $p(ResultInfo,"^",1)'="" d
	....s ResultFlag=1
	....s $P(^TMPDHCPEHMQuestion(Job,"Detail",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3)),"^",12)=1		;有结果的项目显示
	..//																														1 描述			2 默认值				3 性别		4 结果          5 备注			6 关联问题ID 	7 互斥问题ID  8 InputFlag   9 已填写答案标记
	..s ^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId)=OptionDesc_"^"_OptionDefaultValue_"^"_OptionSex_"^"_ResultValue_"^"_ResultNote_"^"_LinkDetailId_"^"_ExclusiveDetailId_"^"_InputFlag_"^"_ResultFlag

	i ResultFlag=1  d
	.f  s OptionOrder=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder)) q:OptionOrder=""  d
	..s OptionChild=0
	..f  s OptionChild=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder,OptionChild)) q:OptionChild=""  d
	...s OptionId=DetailId_"||"_OptionChild
	...i $D(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId))  d  
	....s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId),"^",9)=ResultFlag
	
	b:DetailId=219 //10
	i (TxtFlag=1)&&(Pid'="") d
	.s TxtValue=$g(^TEMPMHCHS("QuestionResult",Pid,DetailId,"text"))
	.i TxtValue'="" d 
	..s $P(^TMPDHCPEHMQuestion(Job,"Detail",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3)),"^",12)=1
	..s $P(^TMPDHCPEHMQuestion(Job,"Detail",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3)),"^",13)=$P(TxtValue,"^",1)
	..b:DetailId=219 //12
}

/// Descript:输出问卷内容
/// Input:
/// 					Job:进程号
/// 					SubjectOrder:问题ID
/// 					SubjectOrder:主题序号
/// 					Flag: 0 翻页  1 不翻页，不可编辑
/// 					SizeJSON：面板宽高  {"height":500,"width":500}
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-03-12
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).OutSurveyToWeb("30116",1,1,"0","")
ClassMethod OutSurveyToWeb(Job, QuesID, SubjectOrder, Flag = "0", SizeJSON = "", DocFlag = "N")
{

	s ^tmpwgy("OutSurveyToWeb")=$lb(Job, QuesID, SubjectOrder, Flag, SizeJSON)
	;w "<a id='tt1' href='#' title='这是提示信息' class='hisui-tooltip' >鼠标移动到这(点击试试)</a>"
	q:SubjectOrder="" ""
	s SubjectId=$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,SubjectOrder,""))
	s SubjectDesc=$P(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,SubjectOrder,SubjectId),"^",1)
	s SubjectRemark=$P(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,SubjectOrder,SubjectId),"^",2)
	s Title=SubjectDesc			//_"  进程号："_Job
	//s Title="<div style=""font-size:18px;font-weight:bold;float:left;"">"_SubjectDesc_"</div>"
	//i //SubjectRemark'="" d
	//.s Title=Title_"<a id=""tip"" href=""#"" title="""_SubjectRemark_""" class=""hisui-tooltip"" style=""float:left;margin-left:10px;margin-top:3px;""> <img  src=""../scripts_lib/hisui-0.1.0/dist/css/icons/help.png"" /></a>"
	
	s SizeCss=""
	i SizeJSON'=""
	{
		s SizeObj={}.%FromJSON(SizeJSON)	
		i SizeObj.height'=""   s SizeCss=SizeCss_"height:"_SizeObj.height_";"
		i SizeObj.width'=""    s SizeCss=SizeCss_"width:"_SizeObj.width_";"
	}
	w "<div id='QuesSubjectPanel' class='hisui-panel' data-options='headerCls:""panel-header-gray "",tools:""#SubjectTool"", collapsible:false,' style='padding:5px;"_SizeCss_" '"
	w " title='"_Title_"' >"

	d ..OutDetailToWeb(Job, QuesID, SubjectId,Flag)
	
	w "</div>"
	i (Flag="0")&&(DocFlag="N")
	{
		//w Job,!
		w "<div style='text-align:center' class='mt15'>"
		s PreOrder=$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,SubjectOrder),-1)
		s NextOrder=$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,SubjectOrder))
		i PreOrder'="" d
		.w "<a style='margin:0px 40px;width:110px;' id='PrePage' href='#' onclick='page_OnClick("_QuesID_","_PreOrder_","""_Job_""","_SubjectOrder_ ",-1)'  data-options=""iconCls:'icon-w-arrow-left'"" class='hisui-linkbutton'>上一页</a>"
		i NextOrder'="" d
		.w "<a style='margin:0px 40px;width:110px;' id='NextPage' href='#' onclick='page_OnClick("_QuesID_","_NextOrder_","""_Job_""","_SubjectOrder_",1)' data-options=""iconCls:'icon-w-arrow-right'"" class='hisui-linkbutton'>下一页</a>"
		e  d
		.w "<a style='margin:0px 40px;width:110px;' id='Save' href='#' onclick='page_OnClick("_QuesID_","""_NextOrder_""","""_Job_""","_SubjectOrder_",2)' data-options=""iconCls:'icon-w-save'"" class='hisui-linkbutton'>保存</a>"
		w "</div>"
	}
}

ClassMethod OutDetailToWeb(Job, QuesID, SubjectID, Flag = "0")
{
	s Child=$P(SubjectID,"||",2)
	
	s i=0
	
	s CurRemark=""
	s PFlag=0  ;备注标记
	s DetailOrder=""
	f  s DetailOrder=$O(^TMPDHCPEHMQuestion(Job,"Detail",QuesID,Child,DetailOrder)) q:DetailOrder=""  d
	.s LinkChild=""
	.f  s LinkChild=$O(^TMPDHCPEHMQuestion(Job,"Detail",QuesID,Child,DetailOrder,LinkChild))  q:LinkChild=""  d
	..s DetailData=$G(^TMPDHCPEHMQuestion(Job,"Detail",QuesID,Child,DetailOrder,LinkChild))
	..s DetailRemark=$P(DetailData,"^",11)
	
	..i (DetailRemark'="")&&(DetailRemark'=CurRemark) d
	...w:PFlag=1 "</div>"
	...s CurRemark=DetailRemark
	...w "<div class='hisui-panel detail_remark' data-options='headerCls:""panel-header-card-gray""'  title='"_DetailRemark_"'>"
	...s PFlag=1
	
	..i (DetailRemark="")&&(CurRemark'="") d
	...s CurRemark=""
	...w "</div>"
	...s PFlag=0 
	
	..s i=i+1
	..s Display="block"
	..s ShowFlag=$P(DetailData,"^",12)
	..s:ShowFlag=0 Display="none"
	..s DetailId=$P(DetailData,"^",1)
	..s DetailMinVal = $lg(^User.DHCHMCQuestionsDetailD(DetailId),18)
	..s DetailMaxVal = $lg(^User.DHCHMCQuestionsDetailD(DetailId),17)
	..s DetailRangeMax = $lg(^User.DHCHMCQuestionsDetailD(DetailId),19)
	..s DetailRangeMin = $lg(^User.DHCHMCQuestionsDetailD(DetailId),20)
	..s colsNum = $lg(^User.DHCHMCQuestionsDetailD(DetailId),20)
	..s DetailDesc=$P(DetailData,"^",2)
	..s DetailType=$P(DetailData,"^",3)
	..s Required=$P(DetailData,"^",4)
	..s RequiredStr=""
	..s:Required="Y" RequiredStr="data-options='required:true'"
	..s DetailUnit=$P(DetailData,"^",7)
	..s TextValue=$P(DetailData,"^",13)
	..s LinkId=QuesID_"||"_Child_"||"_LinkChild
	..s AreaText=TextValue
	..s:TextValue'="" TextValue="value='"_TextValue_"'"
	
	..w "<div style='margin-top:2px;' >"  ;每个问题外层DIV
	..w "<table id='tab_"_DetailId_"' style='margin-top: 2px;display:"_Display_";'>"
	..;第一行
	..w "<tr>"
	..w "<td style='text-align: left; font-weight: bold;  width: 500px;'>"
	..w:Required="Y" "<label style='color:red'>*&nbsp;</label>"
	..w DetailDesc_"</td>"
	..w "<td style='width: 140px;'><span id='spn_"_DetailId_"' title='"_i_"' style='display:none; float: left;color: red;'>请选择相应答案</span>"
	..w "<input type='hidden' id='queAnswerFlag_"_DetailId_"' name='queAnswerFlag' value='"_Required_"' style='width: 45px;'/>"
	..w "<input type='hidden' id='detailType_"_DetailId_"' name='detailType' value='"_DetailType_"' style='width: 45px;'/>"
	..w "</td></tr>"	         								
	..;第二行
	..w "<tr>"
	..w "<td colspan='2'>"
	..w "<table style='word-break:break-all; border: 0px solid red;width:100%'>"
	..w "<tr style='height: 25px;'>" ;内容区域tr
	
	..s ReadOnly=""
	..s:Flag=1 ReadOnly="readonly"
	
	..s Disabled=""
	..s:Flag=1 Disabled="disabled"
	
	..i DetailType="T"  d ;说明型
	...i DetailDesc["视力"  d
	....w "<td><input name='"_LinkId_"' style='width:140px' "_ReadOnly_" class='hisyui-validatebox textbox' id='input_"_DetailId_"' "_TextValue
	....w " onblur='txt_onblur("""_DetailId_""");'/>"
	....w "</td>"
	...e  d
	....w "<td><textarea rows='4' name='"_LinkId_"' style='width:100%' "_ReadOnly_" class='hisyui-validatebox textbox' id='input_"_DetailId_"'"
	....w " onblur='txt_onblur("""_DetailId_""");'>"_AreaText
	....w "</textarea></td>"
	
	..else  if DetailType="N"  d ;数值型 
	...i DetailDesc["视力" d
	....w "<td ><input type='text' name='"_LinkId_"' class='hisui-numberbox textbox' data-options='min:0,precision:2,formatter:sl_formatter' "_RequiredStr_" "_Disabled_"  "_TextValue_" id='input_"_DetailId_"'"
	...e  d
	....w "<td ><input type='text' name='"_LinkId_"' class='hisui-numberbox textbox' data-options='min:0,precision:2,formatter:function(value){if(value!=""""){value = parseFloat(value);}return value;}' "_RequiredStr_" "_Disabled_"  "_TextValue_" id='input_"_DetailId_"'"
	
	...w " onblur='txt_onblur("""_DetailId_""");'"
	...w "/><span style='margin-left:5px;'>"_DetailUnit_ "</span>"
	...w "<span id='min_"_DetailId_"' style='display:none'>"_DetailMinVal_ "</span>"
	...w "<span id='max_"_DetailId_"' style='display:none'>"_DetailMaxVal_ "</span>"
	...s rangeDisplay = "none"
	...i (DetailRangeMin'="")||(DetailRangeMax'="")  d
	....w "<span style='margin-left:10px;color:red;'>参考范围：</span>"
	....s rangeDisplay = "inline"
	...w "<label id='range_"_DetailId_"' style='display:"_rangeDisplay_"'>"_DetailRangeMin_"-"_DetailRangeMax_ "</label>"
	...w "</td>"
	
	..else  if DetailType="D"  d ;日期型
	...w "<td><input type='text' class='hisui-datebox textbox' "_Disabled_" " _TextValue_" name='"_LinkId_"' id='input_"_DetailId_"'"
	...w " onblur='txt_onblur("""_DetailId_""");'"
	...w "data-options='onChange:function() { onChangeDateTime("""_DetailId_""");}'"
	...w "/></td>"
	
	
	
	..else  d ;选择型 单选/多选
	...s RadioNum=0
	...s CheckNum=0
	...s OPOrder=""
	...f  s OPOrder=$O(^TMPDHCPEHMQuestion(Job,"Option",QuesID,Child,DetailOrder,LinkChild,OPOrder)) q:OPOrder=""  d
	....s OptionId=""
	....f  s OptionId=$O(^TMPDHCPEHMQuestion(Job,"Option",QuesID,Child,DetailOrder,LinkChild,OPOrder,OptionId)) q:OptionId=""  d
	.....s:DetailType="S" RadioNum=RadioNum+1
	.....s:DetailType="M" CheckNum=CheckNum+1
	
	.....s OptionData=$G(^TMPDHCPEHMQuestion(Job,"Option",QuesID,Child,DetailOrder,LinkChild,OPOrder,OptionId))
	.....s OptionDesc=$P(OptionData,"^",1)
	.....//s OptionDesc=##class(web.DHCPE.ReportGetInfor).Replace(OptionDesc,"；","")
	.....s OptionDefalVal=$P(OptionData,"^",2)
	.....s OptionResult=$P(OptionData,"^",4)
	.....s OptionNote=$P(OptionData,"^",5)
	.....s LinkDetailId=$P(OptionData,"^",6)
	.....s ExclusiveDetailId=$P(OptionData,"^",7)
	.....s InputFlag=$P(OptionData,"^",8)
	.....s ResultFlag=$P(OptionData,"^",9)
	.....s Checked="",CheckedAtrr=""
	.....i ((OptionResult'="")&&(OptionResult'="N"))||((OptionDefalVal="Y")&&(ResultFlag=0)) d
	......i DetailType="S"  s Checked=",checked:true"  
	......s:DetailType="M" Checked="Checked='Checked'"
	
	.....w "<td><div style='width: 180px; border: 0px solid red; margin-left: 5px;'>"
	.....;w:DetailType'="M" "<label style='cursor:pointer;'>"
	.....i DetailType="S"  d ;单选型
	......w "<input type='radio' class='hisui-radio'  "_Disabled_" name='rad_"_DetailId_"' id='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'" 
	......w " value='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~' "
	......w "data-options='onCheckChange:function(event,value){radQuestion_onclick(this, """_LinkDetailId_""", """_ExclusiveDetailId_""", """_DetailId_""");} "_Checked_ " ' "
	......w " />"
	......w "<label for='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'>"_OptionDesc_"</label>"
	......i InputFlag="Y"  d ;允许备注
	.......w "<input type='text' class='hisui-validatebox textbox' "_Disabled_" id='optionNote_"_LinkId_"~"_OptionId_"' name='resultNote' value='"_OptionNote_"'style='width: 70px;margin-left:10px;"
	.......i Checked'=""  w "display:inline;'"
	.......e  w "display:none;'"
	.......w "/>"

	
	.....e  i DetailType="M"  d ;多选型
	......w "<input type='checkbox' class='hisui-checkbox' "_Disabled_" name='chk_"_DetailId_"' id='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'" 
	......w " value='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'"
	......w "data-options='onCheckChange:function(event,value){chkQustion_onclick(this,"""_DetailId_""","""_LinkDetailId_""" );}'"
	......w Checked_" />"
	......w "<label for='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'>"_OptionDesc_"</label>"
	......i InputFlag="Y"  d ;允许备注
	.......w "<input type='text' class='hisui-validatebox textbox' "_Disabled_" id='optionNote_"_LinkId_"~"_OptionId_"' name='resultNote' value='"_OptionNote_"'style='width: 70px;margin-left:10px;"
	.......i Checked'=""  w "display:inline;'"
	.......e  w "display:none;'"
	.......w "/>"
	
	.....i Checked'=""  d 	
	......w "<script type='text/javascript'>"
	......w "addQueAnswerFlagValue("""_LinkId_"~"_OptionId_"~"_OptionDesc_"~"","""_DetailId_""");"
	......//w:DetailType="S" "radQuestion_onclick(this, """_LinkDetailId_""", """_ExclusiveDetailId_""", """_DetailId_""");"
	......w "</script>"
	
	.....w "</div></td>"
	.....i (((RadioNum#5=0)&&(RadioNum'=0))||((CheckNum#5=0)&&(CheckNum'=0)))&&($O(^TMPDHCPEHMQuestion(Job,"Option",QuesID,Child,DetailOrder,LinkChild,OPOrder))'="") d
	......w "</tr><tr height='25px'>"
	.....e  i (((RadioNum#5'=0))||((CheckNum#5'=0)))&&($O(^TMPDHCPEHMQuestion(Job,"Option",QuesID,Child,DetailOrder,LinkChild,OPOrder))="") d  
	......s tdNum=0
	......s:DetailType="S" tdNum=5-(RadioNum#5)
	......s:DetailType="M" tdNum=5-(CheckNum#5)
	......f k=1:1:tdNum  d
	.......w "<td><div style='width: 160px; border: 0px solid red; margin-left: 5px;'></div></td>"  ;补齐
	
	..w "</tr>"  ;内容区域tr
	..w "</table>"	
	..w "</td>"
	
	..w "</tr>"  ;第二行的tr				          									
	..w "</table>"				          									
	..w "</td>"
	..w "</tr>"
	..w "</table>"
	..W "</DIV>"
	w:PFlag=1 "</div>"
}

/// Descript:设置当前页面选择的问卷答案
/// Input:
/// 				Job:进程ID
/// 				QuesID:问卷ID
/// 				SubjectOrder:主题序号
/// 				ResulList:答案集合  （主题与内容关联id~结果选项ID~结果值~备注@主题与内容关联id~结果选项ID~结果值~备注）
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-03-12
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).SetCurResultGlobal(1)
ClassMethod SetCurResultGlobal(Job, QuesID, SubjectOrder, ResulList)
{
	s ^TMPDHCPEHMQuestion(Job,"Result",QuesID,SubjectOrder)=ResulList
	s Delimter="~"
	s RowDel="@"
	s Len=$l(ResulList,RowDel)
	s LinkList=""  //需要修改答案标记的问题
	f i=1:1:Len  d
	.s StrResult=$p(ResulList,RowDel,i)
	.s LinkId=$p(StrResult,Delimter,1)
	.s LinkObj=##class(User.DHCHMCSDLink).%OpenId(LinkId)
	.q:LinkObj=""
	.s DetailOrder=LinkObj.SDLOrder
	.s OptionId=$p(StrResult,Delimter,2)
	.s Result=$p(StrResult,Delimter,3)
	.s ResultNote=$p(StrResult,Delimter,4)
	
	
	.//先把原来的结果都置成空
	.s detailType = LinkObj.SDLQuestionsDetailDR.QDType
	.i (detailType="S")||(detailType="M")  d
	..s tmpOOrder = ""
	..f  s tmpOOrder=$O(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),tmpOOrder))  q:tmpOOrder=""  d
	...s tmpOOpId = ""
	...f  s tmpOOpId=$O(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),tmpOOrder,tmpOOpId))  q:tmpOOpId=""  d
	....s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),tmpOOrder,tmpOOpId),"^",4)=""
	....s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),tmpOOrder,tmpOOpId),"^",5)=""
	....s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),tmpOOrder,tmpOOpId),"^",9)="1"
	
	.i OptionId'=""  d
	..s OptionObj=##class(User.DHCHMCQDOptions).%OpenId(OptionId)
	..q:OptionObj=""
	..s OptionOrder=OptionObj.QDOOrder
	..s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId),"^",4)=Result
	..s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId),"^",5)=ResultNote
	..s LinkList=LinkList_"^"_LinkId_"#"_DetailOrder
	.e   d
	..s $P(^TMPDHCPEHMQuestion(Job,"Detail",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3)),"^",13)=Result
	
	f i=2:1:$L(LinkList,"^")  d
	.s LinkInfo=$P(LinkList,"^",i)
	.s LinkId=$P(LinkInfo,"#",1)
	.s DetailOrder=$P(LinkInfo,"#",2)
	.s LinkObj=##class(User.DHCHMCSDLink).%OpenId(LinkId)
	.s DetailId=LinkObj.SDLQuestionsDetailDR.%Id()
	.s OptionOrder=""
	.f  s OptionOrder=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder)) q:OptionOrder=""  d
	..s OptionChild=0
	..f  s OptionChild=$o(^User.DHCHMCQDOptionsI("QDOOrderIndex",DetailId,OptionOrder,OptionChild)) q:OptionChild=""  d
	...s OptionId=DetailId_"||"_OptionChild
	...s $P(^TMPDHCPEHMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),DetailOrder,$P(LinkId,"||",3),OptionOrder,OptionId),"^",9)=1

	q 0
}

/// Descript:保存问卷结果
/// Input:
/// 				Job:进程ID
/// 				QuesID:问卷ID
/// 				RegNo:登记号
/// 				PreIADM:体检系统预约ID
/// 				NetPreID:网上预约ID
/// Return: 0^评估记录ID  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2019-03-27
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).SaveSurveyResult("54632","7","AK6788043",0,"")
ClassMethod SaveSurveyResult(Job, QuesID, RegNo, PreIADM = "", NetPreID = "")
{
	s ^tmpwgy("SaveSurveyResult")=$lb(Job, QuesID, RegNo, PreIADM = "", NetPreID)
	q:'$D(^TMPDHCPEHMQuestion(Job,"Result")) "-1^进程无效"
	q:(QuesID="")||('$D(^TMPDHCPEHMQuestion(Job,"Result",QuesID))) "-2^问题ID无效"
	q:RegNo="" "-3^登记号不能为空"
	s ResultList=""
	s SubjectCount=0
	s SubOrder=""
	f  s SubOrder=$O(^TMPDHCPEHMQuestion(Job,"Result",QuesID,SubOrder))  q:SubOrder=""  d
	.s SubjectCount=SubjectCount+1
	.s ResultStr=$G(^TMPDHCPEHMQuestion(Job,"Result",QuesID,SubOrder))
	.q:ResultStr=""
	.s:ResultList'="" ResultList=ResultList_"@"_ResultStr
	.s:ResultList="" ResultList=ResultStr
	q:ResultList="" "0^"
	i (NetPreID="")&&(PreIADM'="")  s NetPreID=..GetNetPreIDByPreIADM(PreIADM)
	s LocID = ""
	i PreIADM'=""
	{
		s LocID = $P(^DHCPEPreIADM(PreIADM),"^",26)
	}
	i NetPreID'=""
	{
		s LocID = $lg(^User.DHCPENetPreRecordD(NetPreID),17)
	}
	i LocID = ""
	{
		s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	}
		
	s ParamObj=##class(HS.Entity.ExamQuestionRequest).%New()
	s ParamObj.QuesId=QuesID
	s ParamObj.PatientRegNo=RegNo
	s ParamObj.PreIADM=PreIADM
	s ParamObj.NetPreID=NetPreID
	s ParamObj.ListResult=ResultList
	s ParamObj.NoVaild="SingleSub"
	s ParamObj.LocID = LocID
	s ParamObj.UserCode=%session.Get("LOGON.USERCODE")
	s:SubjectCount=1 ParamObj.SubjectId=$P(ResultList,"||",1,2)
	s sc=ParamObj.XMLExportToString(.ParamXml, "Request")
	q:$$$ISERR(sc) "-5^"_$System.Status.GetErrorText(sc)
	//记录当前结果集
	s:SubjectCount=1 oldArr = ..GetCurResults(PreIADM,$P(ResultList,"||",1,2))
	s ^tmpwgy("ParamXml")=ParamXml
	s Ret=##class(HS.BL.ExamSurvey).SaveExamQuestionRecord(ParamXml)
	q:+Ret'=0 Ret
	
	i SubjectCount=1
	{
		s newArr = ..GetCurResults(PreIADM,$P(ResultList,"||",1,2))
		s modifyContent = ..GetModifyContent(oldArr,newArr)
		s ^tmpwgy("1")=$LB(PreIADM, modifyContent)
		i modifyContent'=$C(0) d
		.s remark = "修改前："_$P(modifyContent,$C(0),1)_"<br>修改后："_$P(modifyContent,$C(0),2)
		.d ##class(web.DHCPE.AdmRecordManager).Insert(PreIADM,"P","UpdateEvaluation",%session.Get("LOGON.USERID"),remark)
		
		s ^DHCPEDataEx("SaveSurveyResult",PreIADM,$P(ResultList,"||",1,2))="DOCTOR"   
	}
	
	k ^TMPDHCPEHMQuestion(Job,"Result")
	q "0^"_$Replace($Replace(Ret,"<EvaluationId>",""),"</EvaluationId>","")
}

/// Descript:获取当前主题修改的内容
/// Input:
/// 				OldResultArr：修改前的答案集合
/// 				NewResultArr：修改后的答案集合
/// Creater:	wangguoying
/// CreateDate:	2021-04-26
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetModifyContent(^tmpwgy("OldArr"),^tmpwgy("NewArr"))
ClassMethod GetModifyContent(OldResultArr As %ListOfObjects, NewResultArr As %ListOfObjects)
{
	s oldRet = ""
	s newRet = ""
	s tmpNewStr = "^"  //用于记录已经对比过的记录
	s tmpOldArr = ##class(%ListOfObjects).%New()  //记录取消的问题集合
	f i=1:1:OldResultArr.Size
	{
		s flag = 0  //存在相同id
		s oldObj = OldResultArr.GetAt(i)
		f n=1:1:NewResultArr.Size  
		{
			s newObj = NewResultArr.GetAt(n)
			i newObj.DetailId = oldObj.DetailId  d
			.s flag=1
			.s newJson = newObj.%ToJSON()
			.s oldJson = oldObj.%ToJSON()
			.i oldJson '= newJson  d
			..s:oldRet'="" oldRet = oldRet_";"_ oldObj.Result
			..s:oldRet="" oldRet = oldObj.Result
			..s:newRet'="" newRet = newRet_";"_ newObj.Result
			..s:newRet="" newRet = newObj.Result
			.s tmpNewStr=tmpNewStr_newObj.DetailId_"^"
			continue:flag=1
		}
		
		d:flag=0 tmpOldArr.Insert(newObj) 
	}
	i tmpOldArr.Size>0
	{
		f i=1:1:tmpOldArr.Size
		{
			s obj = tmpOldArr.GetAt(i)
			s:oldRet'="" oldRet = oldRet_";"_ obj.Result
			s:oldRet="" oldRet = obj.Result
		}
	}
	f i=1:1:NewResultArr.Size  
	{
		s obj = NewResultArr.GetAt(i)
		i tmpNewStr'[("^"_obj.DetailId_"^") d
		.s:newRet'="" newRet = newRet_";"_ obj.Result
		.s:newRet="" newRet = obj.Result
	}
	
	q oldRet_$C(0)_newRet
}

/// Descript:获取当前主题的结果集
/// Input:
/// 				PreIADM：体检预约ID
/// 				SubjectID：主题ID
/// Creater:	wangguoying
/// CreateDate:	2021-04-26
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetCurResults("2860","7||37")
ClassMethod GetCurResults(PreIADM, SubjectID) As %ListOfObjects
{
	s ^tmpwgy("GetCurResults")=$lb(PreIADM, SubjectID)
	s resultArr = ##class(%ListOfObjects).%New()
	s evaluationID=$G(^DHCPEDataNewEx("PreIADMToHM",PreIADM))
	q:evaluationID="" resultArr
	s questionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",+SubjectID,evaluationID,""),-1)
	q:questionChl="" resultArr
	s detailId = ""
	f  s detailId = $O(^User.DHCHMOQResultI("DetailOption",evaluationID,questionChl,detailId))  q:detailId=""  d
	.s obj={}
	.s obj.DetailId = detailId
	.s linkDesc = $lg(^User.DHCHMCQuestionsDetailD(detailId),14)
	.s:linkDesc="" linkDesc = $lg(^User.DHCHMCQuestionsDetailD(detailId),4)
	.s linkUnit = $lg(^User.DHCHMCQuestionsDetailD(detailId),15)
	.s linkBreak = $lg(^User.DHCHMCQuestionsDetailD(detailId),16)
	.s resultList = ""
	.s optionId=""
	.f  s optionId = $O(^User.DHCHMOQResultI("DetailOption",evaluationID,questionChl,detailId,optionId))  q:optionId=""  d
	..s resultSub = ""
	..f  s resultSub = $O(^User.DHCHMOQResultI("DetailOption",evaluationID,questionChl,detailId,optionId,resultSub))  q:resultSub=""  d
	...s resultObj = ##class(User.DHCHMOQResult).%OpenId(evaluationID_"||"_questionChl_"||"_resultSub)
	...s result = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),5)
	...s remark = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),4)
	...s:remark'="" result = result_":"_remark
	...s result = "【"_linkDesc_"】"_result_linkUnit_linkBreak
	...i resultList'=""  s resultList=resultList_result
	...e  s resultList=result
	.s obj.Result = resultList
	.d resultArr.Insert(obj)
	q resultArr
}

/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetNetPreIDByPreIADM(9588)
ClassMethod GetNetPreIDByPreIADM(PreIADM)
{
	s Ret=""
	s ID=""
	f  s ID=$O(^User.DHCPENetPreRecordI("NPRPreIADMIndex",$C(32)_PreIADM,ID)) q:(ID="")||(Ret'="")  d
	.s Status=$lg(^User.DHCPENetPreRecordD(ID),7)
	.q:(Status=2)||(Status=3)||(Status=6)
	.s Ret=ID
	q Ret
}

/// Descript:获取推荐套餐
/// Input:
/// 				QuestionnaireId:问卷ID
/// 				EvaluationId:评估记录ID
/// Return: Json
/// Creater:	wangguoying
/// CreateDate:	2019-04-11
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetRecommendItems(1,36)
ClassMethod GetRecommendItems(QuestionnaireId, EvaluationId)
{
	q:(QuestionnaireId="")||(EvaluationId="") ""
	s QuestionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",QuestionnaireId,EvaluationId,""),-1)
	q:QuestionChl="" ""
	s Job=$J
	k ^TEMPDHCHMQDNS(Job)
	
	s ResultChl=0
	f  s ResultChl=$o(^User.DHCHMOQEQuestionD(EvaluationId,QuestionChl,"DHCHMOQResult",ResultChl)) q:ResultChl=""  d
	.s ResultId=EvaluationId_"||"_QuestionChl_"||"_ResultChl
	.s ResultObj=##class(User.DHCHMOQResult).%OpenId(ResultId)
	.q:ResultObj=""
	.s DetailId=ResultObj.QRCQuestionsDetailDR.%Id()
	
	.;文本类型问题optionId为空，以text替代optionId
	.s OptionId="text"
	.i ResultObj.QRCQDOptionsDR'=""  do
	..s OptionId=ResultObj.QRCQDOptionsDR.%Id()
	
	.s Result=ResultObj.QRResult
	.s Remark=ResultObj.QRRemark

	.i OptionId'="text" d
	..s QDONOSetsDR=""
	..f  s QDONOSetsDR=$O(^User.DHCHMCQDOLinkOrdSetsI("OrdSetsDRIndex",DetailId,$p(OptionId,"||",2),QDONOSetsDR)) q:QDONOSetsDR=""  d
	...;b ;1
	...s QDONOSSub=$O(^User.DHCHMCQDOLinkOrdSetsI("OrdSetsDRIndex",DetailId,$p(OptionId,"||",2),QDONOSetsDR,""))
	...s currData=^User.DHCHMCQuestionsDetailD(DetailId,"QDOptions",$p(OptionId,"||",2),"QDOLSOrdSets",QDONOSSub)
	...s QDONOSActive=$lg(currData,4)
	...q:QDONOSActive'="Y"
	...s QDONOSRelevance=$lg(currData,3)
	...i $D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDONOSetsDR)) d
	....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDONOSetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDONOSetsDR))+QDONOSRelevance
	...e  d
	....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDONOSetsDR)=QDONOSRelevance
	.e  d
	..s QDLSetsDR=""
	..f  s QDLSetsDR=$O(^User.DHCHMCQDLinkOrdSetsI("OrdSetsDRIndex",DetailId,QDLSetsDR))  q:QDLSetsDR=""  d
	...s QDLSub=""
	...f  s QDLSub=$O(^User.DHCHMCQDLinkOrdSetsI("OrdSetsDRIndex",DetailId,QDLSetsDR,QDLSub))  q:QDLSub=""  d
	....s QDLRelevance=$lg(^User.DHCHMCQuestionsDetailD(DetailId,"OrdSetsLink",QDLSub),3)
	....s QDLExpression=$lg(^User.DHCHMCQuestionsDetailD(DetailId,"OrdSetsLink",QDLSub),4)
	
	....s ExpressionRet=##class(web.DHCPE.PreCommon).CalcExpression(Result,QDLExpression)
	....q:ExpressionRet'=1
	....i $D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDLSetsDR)) d
	.....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDLSetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDLSetsDR))+QDLRelevance
	....e  d
	.....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,QDLSetsDR)=QDLRelevance
	q:'$D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId)) ""
	
	
	;按照套餐ID先排好编号
	s OrdSetsNum=0   ;套餐数量
	s SetsDR=""
	f  s SetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,SetsDR))  q:SetsDR=""  d
	.s OrdSetsNum=OrdSetsNum+1
	.s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,OrdSetsNum,SetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,SetsDR))
	
	
	;冒泡法排序	
	f i=1:1:OrdSetsNum-1  
	{
		f j=1:1:OrdSetsNum-i
		{
			s CurSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,""))
			s NextSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,""))
			s CurScore=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,CurSetsDR))
			s NextScore=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,NextSetsDR))
			i CurScore>NextScore
			{
				s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,NextSetsDR)=NextScore
				s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,CurSetsDR)=CurScore
				k ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,CurSetsDR)
				k ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,NextSetsDR)
			}
		}
	}
	b ;wgy
	
	s JosonObj=##class(web.DHCPE.HM.Entity.RecommendItemJson).%New()
	s Count=0
	s Sort=""
	f  s Sort=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort),-1) q:Sort=""  d
	.s OrdSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort,""))
	.s Relevance=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort,OrdSetsDR))
	.s OrdSetsDesc=$P(^ARCOS(OrdSetsDR),"^",2)
	.s DetailIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(OrdSetsDR)
	.s Count=Count+1
	.s ItemObj=##class(web.DHCPE.HM.Entity.RecommendItem).%New()
	.s ItemObj.Seq=Count
	.s ItemObj.OrdSetsDR=OrdSetsDR
	.s ItemObj.OrdSetsDesc=OrdSetsDesc
	.s ItemObj.Relevance=Relevance
	.s ItemObj.DetailIds=$Replace(DetailIds,"^",",")
	.d JosonObj.rows.Insert(ItemObj)
	s JosonObj.total=Count
	s JosonStr=##class(ext.util.JsonObject).ObjToJson(JosonObj)
	d JosonObj.%Close()
	k ^TEMPDHCHMQDNS(Job)
	q JosonStr
}

/// Descript:输出主题关键字列表
/// Input:
/// 					Job:进程号
/// 					QuesID:问题ID
/// 					SubjectOrder:主题序号
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-05-14
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).OutSubjectKeys(7656,1)
ClassMethod OutSubjectKeys(Job, QuesID)
{
	s preiadm = $G(^TMPDHCPEHMQuestion(Job,"PreIADM"))
	s firtOrder=""
	w "<div id='SubjectKeys'  class='hisui-pekeywords' data-options='{"
	w "singleSelect:true,"
	//w "labelCls:""red"","
	w "items:["
	s num=0
	s Order=""
	f  s Order=$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,Order)) q:Order=""  d
	.s SubjectId=$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,Order,""))
	.s labelCls="red"
	.i preiadm'=""  d
	.s:$G(^DHCPEDataEx("SaveSurveyResult",preiadm,SubjectId))="DOCTOR" labelCls="green"  //护士已保存的
	.s:$G(^DHCPEDataEx("SaveSurveyResult",preiadm,SubjectId))="PATIENT" labelCls="yellow"  //护士已保存的
	.s SubjectDesc=$P(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,Order,SubjectId),"^",1)
	.s num=num+1
	.w:num=1 "{text:"""_SubjectDesc_""",id:"""_Order_""","_"labelCls:"""_labelCls_""", selected:true}"
	.s:num=1 firtOrder=Order
	.w:num'=1 "{text:"""_SubjectDesc_""",id:"""_Order_""","_"labelCls:"""_labelCls_"""}"
	.w:$O(^TMPDHCPEHMQuestion(Job,"Subject",QuesID,Order))'="" ","
	w "],"
    w "onClick:function(v){ShowDetailPanel(v.id);}"	
	w " }'>" 
	w "</div>"
	q firtOrder
}

/// Descript:获取推荐套餐
/// Input:
/// 				QuestionnaireId:问卷ID
/// 				EvaluationId:评估记录ID
/// 					RetType: XML(默认) JSON  
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetRecommendOrdSets(1,36)
ClassMethod GetRecommendOrdSets(QuestionnaireId, EvaluationId, RetType = "XML", XMLRootName = "")
{
	q:(QuestionnaireId="")||(EvaluationId="") ""
	s HBDR=$LG(^User.DHCHMOEvaluationRecordD(EvaluationId),10)
	
	s QuestionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",QuestionnaireId,EvaluationId,""),-1)
	q:QuestionChl="" ""
	s Job=$J
	k ^TEMPDHCHMQDNS(Job)
	;默认的关联度  当关联套餐不匹配任何问卷时，性别、年龄范围、婚姻状况符合条件时，关联度取默认值，有匹配的问卷时，在此基础上累加
	s DefRelevance=1   
	;先把推荐套餐循环一遍，取出基础信息匹配的套餐
	s OrdSetsId=""
	f  s OrdSetsId=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsId))  q:OrdSetsId=""  d
	.s linkId=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsId,""))
	.s matchFlag=..IsMatched(HBDR,linkId)
	.q:matchFlag'=1
	.s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsId)=DefRelevance
	
	b ;begin
	s ResultChl=0
	f  s ResultChl=$o(^User.DHCHMOQEQuestionD(EvaluationId,QuestionChl,"DHCHMOQResult",ResultChl)) q:ResultChl=""  d
	.s ResultId=EvaluationId_"||"_QuestionChl_"||"_ResultChl
	.s ResultObj=##class(User.DHCHMOQResult).%OpenId(ResultId)
	.q:ResultObj=""
	.s DetailId=ResultObj.QRCQuestionsDetailDR.%Id()
	.s DetailActive=ResultObj.QRCQuestionsDetailDR.QDActive
	.q:DetailActive'="Y"  ;未激活的问题
	
	.;文本类型问题optionId为空，以text替代optionId
	.s OptionId="text"
	.i ResultObj.QRCQDOptionsDR'=""  do
	..s OptionId=ResultObj.QRCQDOptionsDR.%Id()
	
	.s Result=ResultObj.QRResult
	.s Remark=ResultObj.QRRemark

	.i OptionId'="text" d  ;选择型问题
	..s optionActive=ResultObj.QRCQDOptionsDR.QDOActive
	..q:optionActive'="Y"  ;未激活的选项
	..s ordLinkId=0
	..f  s ordLinkId=$O(^User.DHCHMOrdSetsQDOptionI("OptionParRefIndex",OptionId,ordLinkId))  q:ordLinkId=""  d
	...s matchFlag=..IsMatched(HBDR,ordLinkId)
	...q:matchFlag'=1
	...s ordLinkDetailSub=0
	...f  s ordLinkDetailSub=$O(^User.DHCHMOrdSetsQDOptionI("OptionParRefIndex",OptionId,ordLinkId,ordLinkDetailSub))  q:ordLinkDetailSub=""  d
	....s ordLinkDOptionSub=0
	....f  s ordLinkDOptionSub=$O(^User.DHCHMOrdSetsQDOptionI("OptionParRefIndex",OptionId,ordLinkId,ordLinkDetailSub,ordLinkDOptionSub))  q:ordLinkDOptionSub=""  d
	.....s OrdSetsDR=$LG(^User.DHCHMOrdSetsLinkD(ordLinkId),2)
	.....s Relevance=$LG(^User.DHCHMOrdSetsLinkD(ordLinkId,"OLDetail",ordLinkDetailSub,"OLOption",ordLinkDOptionSub),3)
	.....i $D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)) d
	......s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR))+Relevance
	.....e  d
	......s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)=Relevance
	
	.e  d  ;说明型问题
	..s ordLinkId=0
	..f  s ordLinkId=$O(^User.DHCHMOrdSetsQDetailI("DetailParRefIndex",DetailId,ordLinkId))  q:ordLinkId=""  d
	...s matchFlag=..IsMatched(HBDR,ordLinkId)
	...q:matchFlag'=1
	...s ordLinkDetailSub=0
	...f  s ordLinkDetailSub=$O(^User.DHCHMOrdSetsQDetailI("DetailParRefIndex",DetailId,ordLinkId,ordLinkDetailSub))  q:ordLinkDetailSub=""  d
	....s OrdSetsDR=$LG(^User.DHCHMOrdSetsLinkD(ordLinkId),2)
	....s Relevance=$LG(^User.DHCHMOrdSetsLinkD(ordLinkId,"OLDetail",ordLinkDetailSub),3)
	....s Expression=$LG(^User.DHCHMOrdSetsLinkD(ordLinkId,"OLDetail",ordLinkDetailSub),4)
	....s ExpressionRet=##class(web.DHCPE.PreCommon).CalcExpression(Result,Expression)
	....q:ExpressionRet'=1
	....i $D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)) d
	.....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR))+Relevance
	....e  d
	.....s ^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,OrdSetsDR)=Relevance
	

	q:'$D(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId)) ""  ;不存在可推荐的套餐
	;按照套餐ID先排好编号
	s OrdSetsNum=0   ;套餐数量
	s SetsDR=""
	f  s SetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,SetsDR))  q:SetsDR=""  d
	.s OrdSetsNum=OrdSetsNum+1
	.s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,OrdSetsNum,SetsDR)=$G(^TEMPDHCHMQDNS(Job,"HMQDNSScore",QuestionnaireId,SetsDR))
	
	
	;冒泡法排序	
	f i=1:1:OrdSetsNum-1  
	{
		f j=1:1:OrdSetsNum-i
		{
			s CurSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,""))
			s NextSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,""))
			s CurScore=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,CurSetsDR))
			s NextScore=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,NextSetsDR))
			i CurScore>NextScore
			{
				s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,NextSetsDR)=NextScore
				s ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,CurSetsDR)=CurScore
				k ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j,CurSetsDR)
				k ^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,j+1,NextSetsDR)
			}
		}
	}
	s JosonObj=##class(web.DHCPE.HM.Entity.RecommendItemJson).%New()
	s Count=0
	s Sort=""
	f  s Sort=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort),-1) q:Sort=""  d
	.s OrdSetsDR=$O(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort,""))
	.s Relevance=$G(^TEMPDHCHMQDNS(Job,"HMQDNSSort",QuestionnaireId,Sort,OrdSetsDR))
	.s OrdSetsDesc=$P(^ARCOS(OrdSetsDR),"^",2)
	.s linkId=$O(^User.DHCHMOrdSetsLinkI("OrdSetsIndex",OrdSetsDR,""))
	.q:linkId=""
	.s ordsetsType=$lg(^User.DHCHMOrdSetsLinkD(linkId),11)
	.s DetailIds=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(OrdSetsDR)
	.s Count=Count+1
	.s ItemObj=##class(web.DHCPE.HM.Entity.RecommendItem).%New()
	.s ItemObj.Seq=Count
	.s ItemObj.OrdSetsDR=OrdSetsDR
	.s ItemObj.OrdSetsDesc=OrdSetsDesc
	.s ItemObj.OrdSetsType=ordsetsType
	.s ItemObj.Relevance=Relevance
	.s ItemObj.DetailIds=$Replace(DetailIds,"^",",")
	.s ItemObj.OrdSetsPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(OrdSetsDR)
	.d JosonObj.rows.Insert(ItemObj)
	s JosonObj.total=Count
	k ^TEMPDHCHMQDNS(Job)
	s ret=""
	if RetType="JSON"
	{
		s ret=##class(ext.util.JsonObject).ObjToJson(JosonObj)
	}else{
		s sc=JosonObj.XMLExportToString(.ret,XMLRootName)
	}
	
	d JosonObj.%Close()
	q ret
}

/// Descript:获取推荐套餐 
/// Input:
/// 				HBDR:评估人员基本信息ID
/// 				OrdLinkDR:套餐关联ID
/// Return: 0 不匹配  1  匹配
/// Creater:	wangguoying
/// CreateDate:	2020-04-23
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).IsMatched(1,36)
ClassMethod IsMatched(HBDR, OrdLinkDR)
{
	s hbObj=##class(User.DHCHMOBaseInfo).%OpenId(HBDR)
	s linkObj=##class(User.DHCHMOrdSetsLink).%OpenId(OrdLinkDR) 
	q:(linkObj.OLSexDR'="")&&(linkObj.OLSexDR.CTSEXCode'=hbObj.BICSexDR.CTCode) 0
	q:(linkObj.OLMaritalDR'="")&&(linkObj.OLMaritalDR.CTMARCode'=hbObj.BICMaritalDR.CTCode) 0
	s dob=hbObj.BIDOB
	s age=##class(web.DHCDocCommon).GetAgeDescNew($zd(dob,3),"")
	s age=$P(age,"岁",1)
	s minAge=linkObj.OLMinAge
	s maxAge=linkObj.OLMaxAge
	s:minAge="" minAge=0
	s:maxAge="" maxAge=999
	q:(age<minAge)||(age>maxAge) 0
	q 1
}

/// Descript:根据体检预约ID和细项编码取结果
/// Input:
/// 				PreIADM：DHC_PE_PreIADM
/// 				ODCode：细项编码
/// 				QuestionnaireId：问卷ID
/// Return: 细项结果  多选问题用$C(0)分割
/// Creater:	wangguoying
/// CreateDate:	2021-03-06
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetODResult(2675,"PE030010",7)
ClassMethod GetODResult(PreIADM, ODCode, QuestionnaireId)
{
	s evaluationID=$G(^DHCPEDataNewEx("PreIADMToHM",PreIADM))
	q:evaluationID="" ""
	s questionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",QuestionnaireId,evaluationID,""),-1)
	q:questionChl="" ""
	s resultList=""
	s quesDetailId=""
	f  s quesDetailId=$O(^User.DHCHMCQuestionsDetailI("QDLinkCodeIndex",$C(32)_ODCode,quesDetailId))  q:quesDetailId=""  d
	.s detailActive=$lg(^User.DHCHMCQuestionsDetailD(quesDetailId),2)
	.q:detailActive'="Y"  //问题不激活的  不再取值
	.s linkDesc = $lg(^User.DHCHMCQuestionsDetailD(quesDetailId),14)
	.s linkUnit = $lg(^User.DHCHMCQuestionsDetailD(quesDetailId),15)
	.s linkBreak = $lg(^User.DHCHMCQuestionsDetailD(quesDetailId),16)
	.s descFlag=0  //拼接描述标记  多选型只拼接一次
	.s subjectSub=""
	.f  s subjectSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub))  q:subjectSub=""  d
	..s subjectActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub),2)
	..q:subjectActive'="Y"	//主题未激活
	..s subjectId=QuestionnaireId_"||"_subjectSub
	..s sdlSub=""
	..f  s sdlSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub,sdlSub))  q:sdlSub=""  d
	...q:$D(^User.DHCHMCQDOLinkDetailI("CSDLinkID",QuestionnaireId_"||"_subjectSub_"||"_sdlSub))  //该问题被关联  不再提取
	...s sdlActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub,"QSDLink",sdlSub),2)
	...q:sdlActive'="Y"	//关联关系未激活
	...s resultSub=""
	...f  s resultSub=$O(^User.DHCHMOQResultI("Detail",evaluationID,questionChl,subjectId,quesDetailId,resultSub))  q:resultSub=""  d
	....s optionId = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),2)
	....s result=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),5)
	....s remark=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),4)
	....q:(result="无")||(result="有")
	....s:remark'="" result=result_":"_remark
	....i descFlag=0  d
	.....s result = linkDesc_result_linkUnit_linkBreak
	.....s descFlag=1
	....e  d
	.....s result = result_linkUnit_linkBreak
	....i resultList'=""  s resultList=resultList_result
	....e  s resultList=result
	....b ;resultList
	....i optionId'=""  d
	.....s linkResult = ..GetLinkDetailResult(optionId,evaluationID_"||"_questionChl)
	.....s:linkResult'="" resultList= resultList_linkResult  //选项与关联问题之间不需要分隔符
	.....b ;linkResult
	
	i resultList=""  d  //问题没有取到值，去检查评估内容是否存在
	.s evaluationDetail = $O(^User.DHCHMCEvaluationDetailI("RelateCodeIndex",$C(32)_ODCode,""),-1)
	.i evaluationDetail'=""  d
	..s evalSub = $O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",evaluationID,questionChl,evaluationDetail,""),-1)
	..i evalSub'="" d
	...s resultList = $lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQEvaluation",evalSub),4)
	q resultList
}

/// Descript:获取选项关联问题的结果
/// Input:
/// 				OptionId：选项ID
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2021-04-13
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetLinkDetailResult("243||768","80||80")
ClassMethod GetLinkDetailResult(OptionId, EQID)
{
	s linkDetailIds = ##class(HS.BL.ExamSurvey).GetOptionLinkedQuestion(OptionId)  //选项关联的问题
	q:linkDetailIds="" ""
	s resultList = ""
	f i=1:1:$L(linkDetailIds,",")
	{
		s detailId = $P(linkDetailIds,",",i)
		s linkDesc = $lg(^User.DHCHMCQuestionsDetailD(detailId),14)
		s linkUnit = $lg(^User.DHCHMCQuestionsDetailD(detailId),15)
		s linkBreak = $lg(^User.DHCHMCQuestionsDetailD(detailId),16)
		s descFlag=0
		s opid=""
		f  s opid=$O(^User.DHCHMOQResultI("DetailOption",+EQID,$P(EQID,"||",2),detailId, opid))  q:opid=""  d
		.s sub = "" 
		.f  s sub=$O(^User.DHCHMOQResultI("DetailOption",+EQID,$P(EQID,"||",2),detailId, opid,sub))  q:sub=""  d
		..s result=$lg(^User.DHCHMOQEQuestionD(+EQID,$P(EQID,"||",2),"DHCHMOQResult",sub),5)
		..q:(result="无")||(result="有")
		..s remark=$lg(^User.DHCHMOQEQuestionD(+EQID,$P(EQID,"||",2),"DHCHMOQResult",sub),4)
		..s optionId = $lg(^User.DHCHMOQEQuestionD(+EQID,$P(EQID,"||",2),"DHCHMOQResult",sub),2)
		..s:remark'="" result=result_":"_remark
		
		..i descFlag=0  d
		...s result = linkDesc_result_linkUnit_linkBreak
		...s descFlag=1
		..e  d
		...s result = result_linkUnit_linkBreak
		..i resultList'=""  s resultList=resultList_result
		..e  s resultList=result
		..i optionId'="" d
		...s linkResult = ..GetLinkDetailResult(optionId,EQID)
		...s:linkResult'="" resultList= resultList_linkResult  //选项与关联问题之间不需要分隔符
	}
	q resultList
}

/// Descript:根据体检预约ID和问题编码获取结果（打印量表时使用）
/// Input:
/// 				PreIADM：DHC_PE_PreIADM
/// 				QuestionCode: 问题编码
/// 				QuestionnaireId：问卷ID
/// Return: 选项ID~选项描述（录入型问题为录入值）~备注@
/// Creater:	wangguoying
/// CreateDate:	2021-03-06
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(2331,"gd0062-1",7)
ClassMethod GetQuestionResult(PreIADM, QuestionCode, QuestionnaireId)
{
	s evaluationID=$G(^DHCPEDataNewEx("PreIADMToHM",PreIADM))
	q:evaluationID="" ""
	s questionChl=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",QuestionnaireId,evaluationID,""),-1)
	q:questionChl="" ""
	s resultList=""
	s quesDetailId=""
	f  s quesDetailId=$O(^User.DHCHMCQuestionsDetailI("QDCodeIndex",$C(32)_$ZCVT(QuestionCode,"U"),quesDetailId))  q:quesDetailId=""  d
	.s detailActive=$lg(^User.DHCHMCQuestionsDetailD(quesDetailId),2)
	.q:detailActive'="Y"  //问题不激活的  不再取值
	.s subjectSub=""
	.f  s subjectSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub))  q:subjectSub=""  d
	..s subjectActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub),2)
	..q:subjectActive'="Y"	//主题未激活
	..s subjectId=QuestionnaireId_"||"_subjectSub
	..s sdlSub=""
	..f  s sdlSub=$O(^User.DHCHMCSDLinkI("SDLDetailIndex",quesDetailId,QuestionnaireId,subjectSub,sdlSub))  q:sdlSub=""  d
	...s sdlActive=$lg(^User.DHCHMCQuestionnaireD(QuestionnaireId,"QSubject",subjectSub,"QSDLink",sdlSub),2)
	...q:sdlActive'="Y"	//关联关系未激活
	...s resultSub=""
	...f  s resultSub=$O(^User.DHCHMOQResultI("Detail",evaluationID,questionChl,subjectId,quesDetailId,resultSub))  q:resultSub=""  d
	....s optionId=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),2)
	....s result=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),5)
	....s remark=$lg(^User.DHCHMOQEQuestionD(evaluationID,questionChl,"DHCHMOQResult",resultSub),4)
	....i resultList'=""  s resultList=resultList_"@"_optionId_"~"_result_"~"_remark
	....e  s resultList=optionId_"~"_result_"~"_remark
	q resultList
}

/// Descript:根据问卷结果更新体检结果表
/// Input:
/// 				QEQID：DHC_HM_OQEQuestion
/// Return: 0^成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-04-13
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).UpdatePEResultBySurvey("80||80",13811)
ClassMethod UpdatePEResultBySurvey(QEQID, UserID)
{
	s piadm = $G(^DHCPEDataNewEx("HMToPreIADM",+QEQID))
	q:piadm="" 0
	s iadm = $O(^DHCPEIADM(0,"CRMADM",piadm,""))
	q:iadm="" 0
	s paadm = $P(^DHCPEIADM(iadm),"^",1)
	TS
	s $ZT="UpdatePEResultErr"
	s err=""
	s QuesId = $LG(^User.DHCHMOQEQuestionD(+QEQID,$P(QEQID,"||",2)),6)
	s hadODList="^"
	b ;QuesId
	s Order=""
	f  s Order=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesId,Order)) q:(Order="")||(err'="")  d
	.s Child=0
	.f  s Child=$o(^User.DHCHMCQuestionSubjectI("QSOrderIndex",QuesId,Order,Child)) q:(Child="")||(err'="")  d
	..s SubjectActive=$lg(^User.DHCHMCQuestionnaireD(QuesId,"QSubject",Child),2)
	..q:SubjectActive'="Y"
	..s DetailOrder=""
	..f  s DetailOrder=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",QuesId,Child,DetailOrder)) q:(DetailOrder="")||(err'="")  d
	...s LinkChild=0
	...f  s LinkChild=$o(^User.DHCHMCSDLinkI("SDLOrderIndex",QuesId,Child,DetailOrder,LinkChild)) q:(LinkChild="")||(err'="")  d
	....s LinkId=QuesId_"||"_Child_"||"_LinkChild
	....s LinkObj=##class(User.DHCHMCSDLink).%OpenId(LinkId)
 	....q:LinkObj="" 
 	....q:LinkObj.SDLActive'="Y" 
 	....q:LinkObj.SDLQuestionsDetailDR.QDActive'="Y"
 	....s ODCode = LinkObj.SDLQuestionsDetailDR.QDLinkCode
 	....q:ODCode=""
 	
 	....q:hadODList[("^"_ODCode_"^")  //已记录
 	....s hadODList=hadODList_ODCode_"^"
 	....s result = ..GetODResult(piadm,ODCode,QuesId)
 	....b:ODCode="PE030010" ;result
 	....q:result=""
 	....s ret = ..SavePEResult(paadm,ODCode,result,UserID)
  	....i +ret'=0  s err=ret
 	i err'=""  tro  q err
 	//保存评估记录结果到体检结果表
 	s oqeSub = ""
 	f  s oqeSub=$O(^User.DHCHMOQEQuestionD(+QEQID,$P(QEQID,"||",2),"DHCHMOQEvaluation",oqeSub))  q:(oqeSub="")||(err'="")  d
 	.s evaluationDetail = $lg(^User.DHCHMOQEQuestionD(+QEQID,$P(QEQID,"||",2),"DHCHMOQEvaluation",oqeSub),2)
 	.s ODCode = $lg(^User.DHCHMCEvaluationDetailD(evaluationDetail),10)
 	.q:ODCode=""
 	.s result = $lg(^User.DHCHMOQEQuestionD(+QEQID,$P(QEQID,"||",2),"DHCHMOQEvaluation",oqeSub),4)
 	.q:result=""
 	.s ret = ..SavePEResult(paadm,ODCode,result,UserID)
 	.i +ret'=0  s err=ret
 	
 	i err'=""  tro  q err
 	TC
 	q 0
UpdatePEResultErr
	s $zt=""
	tro
	q "-100^"_$ZE
}

/// Descript:保存结果表  直接覆盖
/// Input:
/// 				
/// Return: 	0^成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-04-13
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).SavePEResult()
ClassMethod SavePEResult(PAADM, ODCode, Result, UserID = "")
{
	s ^tmpwgy(1)=$lb(PAADM, ODCode, Result, UserID)
	i UserID="" 
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s OEOrder = $O(^OEORD(0,"Adm",PAADM,0))
	q:OEOrder="" 0
	
	s stId = $O(^DHCPEST(0,"OD_Code",$$ALPHAUP^SSUTIL4(ODCode),""))
 	q:stId="" 0
 	s err=""
 	s expStr=+$H_"^"_UserID
 	s odSub = $O(^DHCPEST(0,"OD_Code",$$ALPHAUP^SSUTIL4(ODCode),stId,""))
 	s odRelate = ""
	f  s odRelate = $O(^DHCPEODR(0,"OD",stId_"||"_odSub,odRelate))  q:(odRelate="")||(err'="")  d
	.s arcim = $P(^DHCPEODR(odRelate),"^",1)
	.q:arcim=""
	.s sttDate = ""
	.f  s sttDate = $O(^OEORDi(0,"ARCIM",OEOrder,arcim,sttDate),-1) q:(sttDate="")||(err'="")  d
	..s sub = ""
	..f  s sub = $O(^OEORDi(0,"ARCIM",OEOrder,arcim,sttDate,sub),-1) q:(sub="")||(err'="")  d
	...s stat = $P(^OEORD(OEOrder,"I",sub,1),"^",13)
	...q:stat="4"
	...s oeori = OEOrder_"||"_sub
	...q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",oeori)) //弃检项目不保存
	...s result=oeori_"^"_stId_"||"_odSub_"^"_Result
	...s SaveUserFlag="0"
	...s CurSTID=$O(^DHCPEST(0,"STORD_ARCIM",arcim,0))
	...s:CurSTID="3" SaveUserFlag="1"
	...s ret = ##class(web.DHCPE.ResultNew).SaveResult(result,UserID,"",expStr,SaveUserFlag)
	...i +ret'=0  s err=ret
	q:err'="" err
	q 0
}

/// Descript:创建评估记录
/// Input:
/// 				
/// Return: 	0^ID  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-04-13
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).CreateEvaluationRecord("2680","7","")
ClassMethod CreateEvaluationRecord(PreIADM, QuesId = "7", UserID = "")
{
	s ^tmpwgy("ctr")=$lb(PreIADM, QuesId, UserID)
	s $zt="EvaluationRecordErr"
	i UserID="" 
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=13811
	}
	TS
	s OBPreIBI=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s PatientRegNo=$p(^DHCPEPreIBI(OBPreIBI),"^",1)
	s PatientName=$p(^DHCPEPreIBI(OBPreIBI),"^",2)
	s Sex=$p(^DHCPEPreIBI(OBPreIBI),"^",3)
	s SexCode ="M"
	s:Sex=2 SexCode="F"
	s PatientDOB= $p(^DHCPEPreIBI(OBPreIBI),"^",4)
	s CertificateType="01" 
	s CertificateNo=$p(^DHCPEPreIBI(OBPreIBI),"^",9)
	s TelephoneNo= $p(^DHCPEPreIBI(OBPreIBI),"^",8)
	
	s HBInfo=PatientRegNo_"^"_CertificateType_"^"_CertificateNo_"^"_PatientName_"^"_SexCode_"^"_$ZD(PatientDOB,3)_"^"_TelephoneNo
	s evaluationId=##class(HS.BL.PECommon).GetCurEvaluationRecordID(HBInfo,PreIADM,"")
	;不存在有效评估记录就创建新的
	i evaluationId="" d
	.s evaluationId=##class(HS.BL.ExamSurvey).CreateValuationRecord(HBInfo,UserID)
	i +evaluationId<=0  tro  q evaluationId

	
	
	;创建评估记录子表
	s qeqID=$o(^User.DHCHMOQEQuestionI("QEQCQuestionnaireDRIndex",QuesId,evaluationId,""))
	i qeqID=""
	{
		s qeqID=##class(HS.BL.ExamSurvey).SaveQuestion(evaluationId_"^"_QuesId,UserID)
		i +qeqID<=0  tro  q qeqID
	}else{
		s qeqID=evaluationId_"||"_qeqID
	}
	;当前评估记录是否与体检预约记录关联
	i (PreIADM'="")&&($D(^DHCPEDataNewEx("HMToPreIADM",evaluationId)))&&(PreIADM'=$G(^DHCPEDataNewEx("HMToPreIADM",evaluationId)))   q "-8^评估记录与体检记录关联错误" 
	i (PreIADM'="")&&('$D(^DHCPEDataNewEx("HMToPreIADM",evaluationId))) d
	.s ^DHCPEDataNewEx("HMToPreIADM",evaluationId)=PreIADM
	.s ^DHCPEDataNewEx("PreIADMToHM",PreIADM)=evaluationId
	TC
	q 0_"^"_qeqID
EvaluationRecordErr
	s $ZT=""
	Tro
	S ^tmpwgy("EvaluationRecordErr")=$ze
	q "-10^"_$ZE
}

ClassMethod IsCharged(PreIADM)
{
	q 1
	s ret =0
	s item = ##class(HS.BL.PECommon).GetPEOrdItemByPreIADM(PreIADM,"32348||1")
	i item'="" d
	.s payFlag = $P(item,"^",9)
	.s:payFlag="P" ret=1
	q ret
}

/// Descript:获取评估单 生育史信息
/// Input:			
/// 				EpisodeID：PA_Adm				
/// Return: 	末次月经时间$C(0)初潮年龄$C(0)每次月经天数$C(0)每次月经间隔$C(0)怀孕次数$C(0)生育胎数$C(0)绝经年龄$C(0)避孕措施  1-8
/// Creater:	wangguoying
/// CreateDate:	2021-04-27
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetMenstrualHistory(2680)
ClassMethod GetMenstrualHistory(EpisodeID)
{
	s type = $P(^PAADM(EpisodeID),"^",2)
	q:type'="H" ""
	s iadm = $O(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	q:iadm="" ""
	s piadm = $P(^DHCPEIADM(iadm),"^",4)
	//末次月经时间
	s lmp = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gd0053",7)
	s:lmp'="" lmp=$P(lmp,"~",2)
	//初潮年龄
	s aam = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-1",7)
	s:aam'="" aam=$P(aam,"~",2)
	//每次月经天数
	s dpm = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-2",7)
	s:dpm'="" dpm=$P(dpm,"~",2)
	//每次月经间隔
	s emi = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-3",7)
	s:emi'="" emi=$P(emi,"~",2)
	//怀孕次数
	s nop = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-4",7)
	s:nop'="" nop=$P(nop,"~",2)
	//生育胎数
	s nob = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-5",7)
	s:nob'="" nob=$P(nob,"~",2)
	//绝经年龄
	s aom = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-7",7)
	s:aom'="" aom=$P(aom,"~",2)
	//避孕措施
	s contraception = ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionResult(piadm,"gb0053-6",7)
	i contraception'=""
	{
		s tmp=""
		f i=1:1:$l(contraception,"@")  d
		.s cur = $P(contraception,"@",i)
		.s result = $P(cur,"~",2)
		.s remark = $P(cur,"~",3)
		.s:remark'="" result = remark
		.s:tmp'="" tmp = tmp_"、"_result
		.s:tmp="" tmp = result
		s contraception = tmp
	}
	//末次月经时间$C(0)初潮年龄$C(0)每次月经天数$C(0)每次月经间隔$C(0)怀孕次数$C(0)生育胎数$C(0)绝经年龄$C(0)避孕措施  1-8
	q lmp_$C(0)_aam_$C(0)_dpm_$C(0)_emi_$C(0)_nop_$C(0)_nob_$C(0)_aom_$C(0)_contraception
}

ClassMethod IsContainYY(PreIADM)
{
	s ret = 0
	s iadm=$O(^DHCPEIADM(0,"CRMADM",PreIADM,""))
	q:iadm="" 0
	s paadm = $P(^DHCPEIADM(iadm),"^",1)
	s OEOrder = $O(^OEORD(0,"Adm",paadm,0))
	q:OEOrder="" 0
	s ODCodeS="PE040016^PE040017"  //眼压细项
	f i=1:1:$L(ODCodeS,"^")  q:ret=1  d
	.s ODCode = $P(ODCodeS,"^",i)
	.s stId = $O(^DHCPEST(0,"OD_Code",$$ALPHAUP^SSUTIL4(ODCode),""))
 	.q:stId=""
 	.s odSub = $O(^DHCPEST(0,"OD_Code",$$ALPHAUP^SSUTIL4(ODCode),stId,""))
 	.s odRelate = ""
	.f  s odRelate = $O(^DHCPEODR(0,"OD",stId_"||"_odSub,odRelate))  q:(odRelate="")||(ret=1)  d
	..s arcim = $P(^DHCPEODR(odRelate),"^",1)
	..q:arcim=""
	..s sttDate = ""
	..f  s sttDate = $O(^OEORDi(0,"ARCIM",OEOrder,arcim,sttDate),-1) q:(sttDate="")||(ret=1)  d
	...s sub = ""
	...f  s sub = $O(^OEORDi(0,"ARCIM",OEOrder,arcim,sttDate,sub),-1) q:(sub="")||(ret=1)  d
	....s stat = $P(^OEORD(OEOrder,"I",sub,1),"^",13)
	....q:stat="4"
	....s ret=1
	q ret
}

/// Descript:提交评估记录
/// Input:			
/// 			QEQID：DHC_HM_OQEQuestion			
/// Return: 	0^成功  1^失败
/// Creater:	wangguoying
/// CreateDate:	2021-05-23
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).SubmitSurvey(2680)
ClassMethod SubmitSurvey(EQID, Type = "SUBMIT", UserID As %String = "", GROUPDESC As %String = "")
{
	i UserID=""
	{
		s:$D(%session) UserID = %session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	i GROUPDESC=""
	{
		s:$D(%session) GROUPDESC = %session.Get("LOGON.GROUPDESC")
		//s:GROUPDESC="" GROUPDESC=""
	}
	s piadm = $G(^DHCPEDataNewEx("HMToPreIADM",+EQID))
	i piadm=""  q "-1^未找到关联的就诊记录"
	s iadm = $o(^DHCPEIADM(0,"CRMADM",piadm,""))
	s paadm = $P(^DHCPEIADM(iadm),"^",1)
	TS
	s $ZT="SubmitErr"
	i Type = "SUBMIT"
	{
		s QEQObj = ##class(User.DHCHMOQEQuestion).%OpenId(EQID)
		i QEQObj.QEQStatus="ES"  tro  q "-1^已提交，请勿重复提交"
		s QEQObj.QEQStatus= "ES"  //评估提交
		d QEQObj.QEQESubmitUserDRSetObjectId(UserID)
		s QEQObj.QEQESubmitDate=+$H
		s QEQObj.QEQESubmitTime=$P($H,",",2)
		s sc= QEQObj.%Save()
		i $$$ISERR(sc) tro  q err="-10^"_$System.Status.GetErrorText(sc)
		
		//提交健康评估站点
		s submitRet =  ##class(web.DHCPE.ResultEdit).AuditStationS(paadm, ..#SurveyStationID, "Submit", UserID)
		s ^tmpwgy("submitRet")=submitRet
		i $P(submitRet,"^",1)="NoApp"
		{
			s submitRet="存在未执行的项目:"_$P(submitRet,"^",2)
			tro  q "-10^站点提交失败："_submitRet
		}
		d ##class(web.DHCPE.AdmRecordManager).Insert(piadm,"P","SubmitEvaluation",UserID,EQID)
	}else{
		s QEQObj = ##class(User.DHCHMOQEQuestion).%OpenId(EQID)
		i QEQObj.QEQStatus="S"  tro  q "-1^未提交，无须撤销"
		s oldUserID = QEQObj.QEQESubmitUserDR.%Id()
		i (UserID'=oldUserID)&&(GROUPDESC'="体检评估核对")  tro  q "-1^非本人提交不允许撤销"
		s QEQObj.QEQStatus= "S"  //评估提交
		s QEQObj.QEQESubmitUserDR=""
		s QEQObj.QEQESubmitDate=""
		s QEQObj.QEQESubmitTime=""
		s sc= QEQObj.%Save()
		i $$$ISERR(sc) tro  q err="-10^"_$System.Status.GetErrorText(sc)
		
		//提交健康评估站点
		s submitRet =  ##class(web.DHCPE.ResultEdit).AuditStationS(paadm, ..#SurveyStationID, "Cancel", UserID)
		s ^tmpwgy("cancelsubmitRet")=submitRet
		//i submitRet'=0  tro  q "-10^站点撤销提交失败："_submitRet
		d ##class(web.DHCPE.AdmRecordManager).Insert(piadm,"P","CancelSubmitEvaluation",UserID,EQID)
	}
	TC
	q 0
SubmitErr
	s $zt=""
	tro 
	q "-100^"_$ZE
}

/// Descript:根据PreIADM 获取关联问卷
/// Input:			
/// 			PreIADM：DHC_PE_PreIADM
/// Return: 	DHC_HM_CQuestionnaire.RowID
/// Creater:	wangguoying
/// CreateDate:	2021-07-20
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).GetQuestionnaireByPreIADM(21630)
ClassMethod GetQuestionnaireByPreIADM(PreIADM)
{
	s locId = $p(^DHCPEPreIADM(PreIADM),"^",26)
	s level = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	s level = $p(level,"^",1)
	s locVip = $O(^CF.PE.LocVIPLevelI("IdxOfLocVIP",$C(32)_locId,level,""))
	q:locVip="" ""
	s hmServie = $lg(^CF.PE.LocVIPLevelD(locVip),12)
	s hmQues = ""
	i hmServie '= ""
	{
		s active = $lg(^User.DHCHMCServiceClassD(hmServie),2)
		q:active'="Y" ""
		s powerFLag = ##class(User.DHCHMCServiceClass).GetLocShowDataFlag(hmServie,locId)
		q:powerFLag'="Y" ""  //服务级别无权限
		s order = ""
		b ;1
		f  s order = $O(^User.DHCHMCSCQLinkI("SCQLOrderIndex",hmServie,order)) q:(order="")  d
		.s sub = ""
		.f  s sub = $O(^User.DHCHMCSCQLinkI("SCQLOrderIndex",hmServie,order,sub)) q:(sub="")  d
		..b ;2
		..s curQues = $lg(^User.DHCHMCServiceClassD(hmServie,"DHCHMCSCQLink",sub),5)
		..s quesActive = $lg(^User.DHCHMCQuestionnaireD(curQues),2)
		..q:quesActive'="Y"
		..s powerFLag = ##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(curQues,locId)
		..q:powerFLag'="Y"  //主问卷无权限
		..s:hmQues'="" hmQues = hmQues_"^"_curQues
		..s:hmQues="" hmQues=curQues
	}
	q hmQues
}

/// Descript:根据PreIADM 创建问卷评估记录
/// Input:			
/// 			PreIADM：DHC_PE_PreIADM
/// Return: 	0：成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-08-17
/// Debug: w ##class(web.DHCPE.HM.ExamSurveyHandler).CreateEvluationByPreIADM(21630)
ClassMethod CreateEvluationByPreIADM(PreIADM, UserID = "")
{
	s quesIds = ..GetQuestionnaireByPreIADM(PreIADM)
	q:quesIds="" 0
	TS
	s $zt = "CreateEvluationSErr"
	s err= ""
	f i=1:1:$L(quesIds,"^")  q:err'=""  d
	.s quesId = $p(quesIds,"^",i)
	.s ret = ..CreateEvaluationRecord(PreIADM,quesId,UserID)
	.i +ret'=0  s err = ret
	i err'="" tro   q err
	TC
	q 0
CreateEvluationSErr
	s $zt=""
	Tro
	q "-100^"_$ZE
}

}
