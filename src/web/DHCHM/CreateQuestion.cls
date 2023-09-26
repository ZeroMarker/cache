Class web.DHCHM.CreateQuestion Extends web.DHCHM.Abstract [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(web.DHCHM.CreateQuestion).CreateQuestion("24||43","Q24||43")

ClassMethod CreateQuestion(CurID, ID)
{
	w:CurID="" "return ''"
	s obj=##class(User.DHCHMOQEQuestion).GetObj(CurID)
	s Desc=obj.QEQCQuestionnaireDR.QDesc
	w "var QuestionPanel = new Ext.form.FormPanel({",!
    w " title: '"_Desc_"',",!
    w "	frame: true,",!
    w "	autoScroll: true,",!
    w "	id: 'P"_ID_"',",!
    w "	items: [],",!
	w "	closable:true",!
    w "});",!
    s subjectsub=0
	s OEID=+CurID
	s OESub=$p(CurID,"||",2)
	s collapsed="false"
	s i=0
	k ^TempDHCHM("OERSubject",$J)
	f  s subjectsub=$o(^User.DHCHMOQEQuestionD(OEID,OESub,"DHCHMOQResult",subjectsub)) q:subjectsub=""  d
	.s QRID=CurID_"||"_subjectsub
	.s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	.s subjectID=QRObj.QRQuestionSubjectDR.%Id()
	.q:$D(^TempDHCHM("OERSubject",$J,subjectID))
	.s subjectDesc=QRObj.QRQuestionSubjectDR.QSDesc
	.s ^TempDHCHM("OERSubject",$J,subjectID)=""
	.s i=i+1
	.w "var TitlePanel = new Ext.form.FieldSet({",!
    .w " title: '<h1><BIG><BIG>" _ subjectDesc _ "</BIG></BIG>',",!
    .w " frame: true,",!
    .w " autoHeight: true,",!
    .w " layout: 'column',",!
    .w " //layout:'table',",!
    .w " collapsed: "_collapsed_",",!
    .w " collapsible: true,",! 
    .w " collapseFirst: true,",!
    .w " id: '"_ID_ "^" _ subjectID_"'",!
    .w "});",!
    .w "TitlePanel.on('beforeexpand',function(){Ext.MessageBox.wait('Loadng...........', '数据载入，请等待');Ext.MessageBox.updateProgress(1); });",!
    
    .//'"_ID _ "^" _ subjectID_"'"
    .w "TitlePanel.on('expand',function(){setTimeout('Ext.MessageBox.hide();', 1)});",!
    .//s collapsed="true"
    .d ..CreateDetailInfo(CurID, subjectID,ID)
	.w "QuestionPanel.add(TitlePanel);",!
	w "return QuestionPanel;"
}

ClassMethod CreateDetailInfo(Id, SubjectId, ID)
{
   
	s detailSub=0
	s InputInfo="请录入..."
	s DefaultNum=1/3
	k ^TempDHCHM("OERDetail",$J)
	f  s detailSub=$o(^User.DHCHMOQResultI("Subject",+Id,$P(Id,"||",2),SubjectId,detailSub)) q:detailSub=""  d
	.s QRID=Id_"||"_detailSub
	.s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	.s DetailID=QRObj.QRCQuestionsDetailDR.%Id()
	.q:$D(^TempDHCHM("OERDetail",$J,DetailID))
	.s ^TempDHCHM("OERDetail",$J,DetailID)=""
	.s DetailDesc=QRObj.QRCQuestionsDetailDR.QDDesc
	.s DetailType=QRObj.QRCQuestionsDetailDR.QDType
	.s DetailUnit=QRObj.QRCQuestionsDetailDR.QDUnit
	.s DetailRequired=QRObj.QRCQuestionsDetailDR.QDRequired
	.i DetailRequired="Y" d
	..s DetailRequired="false"
	..s DetailDesc="<font color=""#FF0000""><b>*</b></font>"_DetailDesc
	.e  d
	..s DetailRequired="true"
	.i DetailUnit'="" s DetailDesc=DetailDesc_"("_DetailUnit_")"
	.s DetailNum=+QRObj.QRCQuestionsDetailDR.QDElementNum
	.i DetailNum'=0 d
	..s DetailNum=1/DetailNum
	.e  d
	..s DetailNum=DefaultNum
	.s value=QRObj.QRResult
	.i DetailType="T" d
	..s DetailID=QRID
	..w "Field = new Ext.form.TextField({",!
    ..w " allowBlank:"_ DetailRequired_",",!
    ..w " emptyText: '"_InputInfo_"',",!
    ..w " fieldLabel:'"_ DetailDesc_"',",!
    ..w " id:'"_ID_"^"_DetailID_"',",!
    ..w " name:'"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " //vtypeText:'请输入',",!
    ..w " value:'"_value_"'",!
    ..w "});",!
    ..w "var FieldPanel = new Ext.Panel({",!
    ..w " layout: 'form',",!
    ..w " items: Field,",!
    ..w " id: 'P"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " columnWidth: "_DetailNum,!
    ..w "})",!
    ..w "TitlePanel.add(FieldPanel);",!
	.i DetailType="N" d
	..s DetailID=QRID
	..w "Field = new Ext.form.NumberField({",!
    ..w " allowBlank:"_ DetailRequired_",",!
    ..w " emptyText: '"_InputInfo_"',",!
    ..w " fieldLabel:'"_ DetailDesc_"',",!
    ..w " id:'"_ID_"^"_DetailID_"',",!
    ..w " name:'"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " //vtypeText:'请输入',",!
    ..w " value:'"_value_"'",!
    ..w "});",!
    ..w "var FieldPanel = new Ext.Panel({",!
    ..w " layout: 'form',",!
    ..w " items: Field,",!
    ..w " id: 'P"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " columnWidth: "_DetailNum,!
    ..w "})",!
    ..w "TitlePanel.add(FieldPanel);",!
    .i DetailType="D" d
	..s DetailID=QRID
	..w "Field = new Ext.form.DateField({",!
    ..w " allowBlank:"_ DetailRequired_",",!
    ..w " emptyText: '"_InputInfo_"',",!
    ..w " fieldLabel:'"_ DetailDesc_"',",!
    ..w " format: ExtToolSetting.DateFormatString,",!
    ..w " name:'"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " //vtypeText:'请输入',",!
    ..w " value:'"_value_"'",!
    ..w "});",!
    ..w "var FieldPanel = new Ext.Panel({",!
    ..w " layout: 'form',",!
    ..w " items: Field,",!
    ..w " id: 'P"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " columnWidth: "_DetailNum,!
    ..w "})",!
    ..w "TitlePanel.add(FieldPanel);",!
	.else  if (DetailType="M")||(DetailType="S") d
	..w "var DetailFieldSets = new Ext.form.FieldSet({",!
    ..w " title: '<BIG>"_DetailDesc_"</BIG>',",!
    ..w " layout: 'column',",!
    ..w " id: 'FS"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ..w " columnWidth: 1,",!
    ..w " border: false,",!
    ..w " frame: true,",!
    ..w " autoHeight: true,",!
    ..w " //collapsed:false,",!
    ..w " //collapsible:true,",!
    ..w " collapseFirst: true",!
    ..w "});",!
	..s optSub=0
	..f  s optSub=$o(^User.DHCHMOQResultI("Detail",+Id,$P(Id,"||",2),SubjectId,DetailID,optSub)) q:optSub=""  d
	...s QRID=Id_"||"_optSub
	...s QRObj=##class(User.DHCHMOQResult).GetObj(QRID)
	...q:'$ISOBJECT(QRObj.QRCQDOptionsDR)
	...s OID=QRObj.QRCQDOptionsDR.%Id()
	...s Desc=QRObj.QRCQDOptionsDR.QDODesc
	...s Sex=QRObj.QRCQDOptionsDR.QDOSex
	...s Active=QRObj.QRCQDOptionsDR.QDOActive
	...s Default=QRObj.QRResult
	...s SelectFlag="false"
	...if (Default = "Y") d
    ....s SelectFlag = "true"
    ...i DetailType="M" d
    ....w "Field = new Ext.form.Checkbox({",!
    ...e  d
    ....w "Field = new Ext.form.Radio({",!
    ...w " id: '"_ID_"^"_QRID_"',",!
    ...w " boxLabel:'"_Desc_"',",!
    ...w " checked: "_SelectFlag_",",!
    ...w " hideLabel: true,",!
    ...w " name:'"_ID_"^"_SubjectId_"^"_DetailID_"',",!
    ...w " inputValue:'"_QRID_"'",!
    ...w " //,fieldLabel :SelectDesc",!
    ...w " //,labelSeparator:''",!
                                
    ...w "});",!
    ...w "var FieldPanel = new Ext.Panel({",!
    ...w " layout: 'form',",!
    ...w " items: Field,",!
    ...w " id: 'P"_ID_"^"_SubjectId_"^"_DetailID_"^"_QRID_"',",!
    ...w " autoHeight: true,",!
    ...w " columnWidth: "_DetailNum_",",!
    ...w " style: ' padding:0px 0px  0px  10px;'",!
    ...w "})",!
    ...w "DetailFieldSets.add(FieldPanel);",!
	..w "TitlePanel.add(DetailFieldSets);",!
	//.b //
	k ^TempDHCHM("OERDetail",$J)
}

}
