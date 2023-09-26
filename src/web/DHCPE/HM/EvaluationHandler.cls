/// Description：体检问卷评估处理类
/// Creator：wangguoying
Class web.DHCPE.HM.EvaluationHandler Extends %RegisteredObject
{

/// Descript:输出评估内容
/// Input:
/// 				EQID:DHC_HM_OQEQuestion
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-05-05
/// Debug: d ##class(web.DHCPE.HM.EvaluationHandler).OutEvaluationToWeb("55||90")
ClassMethod OutEvaluationToWeb(EQID)
{
	s EQObj=##class(User.DHCHMOQEQuestion).%OpenId(EQID)
	q:EQObj="" 
	s QuestionID=EQObj.QEQCQuestionnaireDR.%Id()
	;先计算再显示
	s Job=$J
	k ^TMPDHCHMCQED(Job)
	d ..SetDHCHMCQEDGlobal(Job,QuestionID)
	q:'$D(^TMPDHCHMCQED(Job))
	w "<table class='hisui-table' >"
	w "<tr>"
	s Count=0
	s ColIndex=0			
	s Sort=""
	f  s Sort=$O(^TMPDHCHMCQED(Job,QuestionID,"Order",Sort))  q:Sort=""  d
	.s Sub=""
	.f  s Sub=$O(^TMPDHCHMCQED(Job,QuestionID,"Order",Sort,Sub))  q:Sub=""  d
	..s LinkID=QuestionID_"||"_Sub
	..s CQEDLinkObj=##class(User.DHCHMCQEDLink).%OpenId(QuestionID_"||"_Sub)
	..s EDetailObj=CQEDLinkObj.QEDLEvaluationDetailDR ;评估内容
	..q:EDetailObj.EDActive'="Y"
	..s EDID=EDetailObj.%Id()
	..s EDDesc=EDetailObj.EDDesc
	..s EDType=EDetailObj.EDType
	..s EDResult=""
	..s EDResultSub=$O(^User.DHCHMOQEvaluationI("QECEvaluationDetailDRIndex",+EQID,$P(EQID,"||",2),EDID,""))
	..s EDResultID=""
	..i EDResultSub'=""  d
	...s EDResultID=EQID_"||"_EDResultSub
	...s EDResultObj=##class(User.DHCHMOQEvaluation).%OpenId(EDResultID)
	...s EDResult=EDResultObj.QEResult
	..s Count=Count+1
	..s ColIndex=ColIndex+1
	..s ClassName="labelTd"
	..s:ColIndex'=1 ClassName="labelTd2"
	..w "<td class='"_ClassName_"'>"_EDDesc_"</td>"
	..w "<td>"
	..w "<input id='"_EDID_"' type='hidden' name='EDResultDR' value='"_EDResultID_"'>"
	..w "<input id='T_"_EDID_"' type='hidden' name='EDType' value='"_EDType_"'>"
	..i EDType="T" d ;说明型
	...w "<input type='text' name='EDInput' class='hisui-validatebox textbox' value='"_EDResult _"' id='I_"_EDID_"' style='width:175px;'>"
	
	..i EDType="N" d ;数值型
	...w "<input type='text' name='EDInput' class='hisui-numberbox textbox' value='"_EDResult _"' id='I_"_EDID_"' style='width:180px;'>"
	
	..i EDType="D" d ;日期型
	...w "<input type='text' name='EDInput' class='hisui-datebox ' value='"_EDResult _"' id='I_"_EDID_"' style='width:180px;'>"
	
	..i EDType="C" d ;下拉列表型
	...s DataSource=EDetailObj.EDDataSource
	...d:DataSource'="" ..OutCombobox(EDID,EDResult,DataSource)
	
	..w "</td>"
	..b ;0
	..i (Count#3=0)&&($O(^TMPDHCHMCQED(Job,QuestionID,"Order",Sort))'="") d
	...w "</tr><tr>"
	...s ColIndex=0
	...b ;1
	w "</tr>"
	w "</table>"
	;w "</div>"
	k ^TMPDHCHMCQED(Job)
}

/// Descript:设置问卷与评估内容关联GLobal
/// Input:
/// 				Job:进程号
/// 				QuestionID:问题ID
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-05-05
/// Debug: d ##class(web.DHCPE.HM.EvaluationHandler).SetDHCHMCQEDGlobal()
ClassMethod SetDHCHMCQEDGlobal(Job, QuestionID)
{
	s Sub=""
	f  s Sub=$O(^User.DHCHMCQuestionnaireD(QuestionID,"QEDLink",Sub)) q:Sub=""  d
	.s CQEDLinkObj=##class(User.DHCHMCQEDLink).%OpenId(QuestionID_"||"_Sub)
	.q:CQEDLinkObj.QEDLActive'="Y"
	.s Sort=CQEDLinkObj.QEDLOrder
	.s:Sort="" Sort=99999
	.s ^TMPDHCHMCQED(Job,QuestionID,"Order",Sort,Sub)=""
}

/// Descript:输出下拉列表
/// Input:
/// 				EDID：评估内容ID
/// 				EDResult：评估结果
/// 				DataSource：数据来源
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2019-05-05
/// Debug: d ##class(web.DHCPE.HM.EvaluationHandler).OutCombobox(1,2,"web.DHCHM.GetComboxInfo,GetCClassLevel,10030010")
ClassMethod OutCombobox(EDID, EDResult, DataSource)
{
	
	s ClassName=$P(DataSource,",",1)
	s MethodName=$P(DataSource,",",2)
	s Arg=$P(DataSource,",",3)
	s Data=$ZOBJCLASSMETHOD(ClassName,MethodName,Arg)  ;[['1','是'],['2','倾向是'],['3','否']]
	i Data'="" d
	.w "<select id='I_"_EDID_"' class='hisui-combobox' name='EDInput' style='width:180px;' data-options='enterNullValueClear:false,blurValidValue:true'>"
	.s Data=$e(Data,3,$L(Data)-2)  ;'1','是'],['2','倾向是'],['3','否'
	.s Data=$Replace(Data,"'","") ;1,是],[2,倾向是],[3,否
	.s OptionNum=$L(Data,"],[")
	.f i=1:1:OptionNum  d
	..s Option=$P(Data,"],[",i)
	..s OptionId=$P(Option,",",1)
	..s OptionDesc=$P(Option,",",2)
	..s Selected=""
	..s:(EDResult'="")&&(OptionId=EDResult) Selected="Selected"
	..w "<option value='"_OptionId_"' "_Selected_" >"_OptionDesc_"</option>"
	.w "</select>"
}

}
