Import SQLUser

Class web.DHCICUPrintProject Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：        王枭啸
/// CreatDate：      2020-7-20
/// Description：    获取模板列表
/// Table：          DHC_ICU_PrintTemplate
/// Return：         打印设计模板信息
/// w ##Class(web.DHCICUPrintProject).FindTemplates()
ClassMethod FindTemplates() As %String
{
	s templateInfo=""
	s tmpId=""
	f  s tmpId=$o(^DHCICUPrintTemplate(tmpId)) q:tmpId=""  d
	.q:tmpId=0
	.s template=$g(^DHCICUPrintTemplate(tmpId))
	.i templateInfo="" s templateInfo=template_"^"_tmpId
	.e  s templateInfo=templateInfo_";"_template_"^"_tmpId
	
	q templateInfo
}

/// Creator：        王枭啸
/// CreatDate：      2020-7-20
/// Description：    新增模板
/// Table：          DHC_ICU_PrintTemplate
/// Input:           Code:模板代码,Desc:模板名称,Type:模板类型,PageSize:模板纸张
/// Return：         SQLCODE	
ClassMethod AddTemplate(Code As %String, Desc As %String, Type As %String, PageSize As %String) As %String
{
	q:Code="" "代码不能为空!"
	q:Desc="" "名称不能为空!"
	q:Type="" "类型不能为空!"
	q:PageSize="" "纸张大小不能为空!"
	k PLIST
	s PLIST(2)=Code        //ICUPT_Code
	s PLIST(3)=Desc        //ICUPT_Desc
	s PLIST(4)=Type        //ICUPT_Type
	s PLIST(5)=PageSize    //ICUPT_PageSize
	s PLIST(6)="Y"         //ICUPT_Flag
	
	&sql(insert into sqluser.DHC_ICU_PrintTemplate Values :PLIST())
	
	q SQLCODE
}

/// Creator：        王枭啸
/// CreatDate：      2020-7-20
/// Description：    修改模板
/// Table：          DHC_ICU_PrintTemplate
/// Input:           Code:模板代码,Desc:模板名称,Type:模板类型,PageSize:模板纸张
/// Return：         SQLCODE	
ClassMethod EditTemplate(RowId As %String, Code As %String, Desc As %String, Type As %String, PageSize As %String) As %String
{
	q:RowId="" "请选择模板"
	q:Code="" "代码不能为空!"
	q:Desc="" "名称不能为空!"
	q:Type="" "类型不能为空!"
	q:PageSize="" "纸张大小不能为空!"
	
	&sql(update sqluser.DHC_ICU_PrintTemplate set ICUPT_Code=:Code,ICUPT_Desc=:Desc,ICUPT_Type=:Type,ICUPT_PageSize=:PageSize where ICUPT_RowId=:RowId)

	
	q SQLCODE
}

/// Creator：        王枭啸
/// CreatDate：      2020-7-20
/// Description：    设置模板状态
/// Table：          DHC_ICU_PrintTemplate
/// Input:           RowId:模板id,Flag:模板标志
/// Return：         SQLCODE	
ClassMethod ChangeTemplateFlag(RowId As %String, Flag As %String) As %String
{
	q:RowId="" "请选择模板"
	&sql(update sqluser.DHC_ICU_PrintTemplate set ICUPT_Flag=:Flag where ICUPT_RowId=:RowId)

	
	q SQLCODE
}

/// 获取模板明细	
/// Table:DHC_ICU_PrintTemplateDetails
/// w ##Class(web.DHCICUPrintProject).GetTemplateDetails(1)
ClassMethod GetTemplateDetails(RowId As %String) As %String
{
	q:RowId="" "模板ID为空!"
	s Lines="",Strings=""
	s chlsub=""
	f  s chlsub=$o(^DHCICUPrintTemplate(RowId,"Details",chlsub)) q:chlsub=""  d
	.q:chlsub=0
	.s type=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",1)
	.;直线
	.i type="L" d
	..s Line=""
	..s startPoint=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",2)
	..s endPoint=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",3)
	..s quality=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",5)
	..i (startPoint'="")&&(endPoint'="") s Line=startPoint_"^"_endPoint_"^"_quality
	..q:Line=""
	..i Lines="" s Lines=Line
	..e  s Lines=Lines_";"_Line
	.;文本
	.i type="S" d
	..s String=""
	..s startPoint=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",2)
	..s note=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",4)
	..s style=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",5)
	..s data=$p($g(^DHCICUPrintTemplate(RowId,"Details",chlsub)),"^",6)
	..i (startPoint'="") s String=note_"^"_style_"^"_startPoint_"^"_data
	..q:String=""
	..s String=$replace(String,"#","^")
	..i Strings="" s Strings=String
	..e  s Strings=Strings_";"_String
	
	q Lines_"#"_Strings
}

/// 保存模板明细	
/// Table:DHC_ICU_PrintTemplateDetails
ClassMethod SaveTemplateDetails(RowId As %String, Lines As %String, Strings As %String) As %String
{
	q:RowId="" "模板ID为空!"
	
	;清除之前的记录
	
	&sql(delete sqluser.DHC_ICU_PrintTemplateDetails where ICUPTD_ICUPTId=:RowId)
	
	;保存直线
	f l=1:1:$length(Lines,";") d
	.s Line=$p(Lines,";",l)
	.s startPoint=$p(Line,"#",1)
	.s endPoint=$p(Line,"#",2)
	.s quality=$p(Line,"#",3)
	.k PLIST
	.s PLIST(0)=RowId       //ICUPTD_ICUPTId
	.s PLIST(3)="L"         //ICUPTD_Type
	.s PLIST(4)=startPoint  //ICUPTD_StartPoint
	.s PLIST(5)=endPoint    //ICUPTD_EndPoint
	.s PLIST(7)=quality     //ICUPTD_Style
	.&sql(insert into sqluser.DHC_ICU_PrintTemplateDetails values :PLIST())
	
	;保存文本
	f s=1:1:$length(Strings,";") d
	.s String=$p(Strings,";",s)
    .s Note=$p(String,"#",1)
	.s startPoint=$p(String,"#",6)
	.s style=$p(String,"#",2)_"#"_$p(String,"#",3)_"#"_$p(String,"#",4)_"#"_$p(String,"#",5)
	.s data=$p(String,"#",7)
	.k PLIST
	.s PLIST(0)=RowId       //ICUPTD_ICUPTId
	.s PLIST(3)="S"         //ICUPTD_Type
	.s PLIST(4)=startPoint  //ICUPTD_StartPoint
	.s PLIST(6)=Note        //ICUPTD_Note
	.s PLIST(7)=style       //ICUPTD_Style
	.s PLIST(8)=data        //ICUPTD_Data
	.&sql(insert into sqluser.DHC_ICU_PrintTemplateDetails values :PLIST())

	
	q SQLCODE
}

/// 批量移动模板位置
/// Table:DHC_ICU_PrintTemplateDetails
/// w ##Class(web.DHCICUPrintProject).UpdatePrintTemplate(10,10,0)
ClassMethod UpdatePrintTemplate(RowId As %String, Y As %String, X As %String) As %String
{
	q:RowId="" "模板ID为空!"
	i Y="" s Y=0
	i X="" s X=0
	q:(Y'=+Y)||(X'=+X) "请输入有效的数字！"
	
	s detailId=""
	f  s detailId=$o(^DHCICUPrintTemplate(RowId,"Details",detailId)) q:detailId=""  d
	.s point1=$p($g(^DHCICUPrintTemplate(RowId,"Details",detailId)),"^",2)
	.i point1'=""  d
	..s X1=$p(point1,",",1)+X
	..s Y1=$p(point1,",",2)+Y
	..s newPoint1=X1_","_Y1
	..;b //1
	..s $p(^DHCICUPrintTemplate(RowId,"Details",detailId),"^",2)=newPoint1
	.s point2=$p($g(^DHCICUPrintTemplate(RowId,"Details",detailId)),"^",3)
	.i point2'=""  d
	..s X2=$p(point2,",",1)+X
	..s Y2=$p(point2,",",2)+Y
	..s newPoint2=X2_","_Y2
	..s $p(^DHCICUPrintTemplate(RowId,"Details",detailId),"^",3)=newPoint2


	
	q 0
}

/// 批量画直线
/// Table:DHC_ICU_PrintTemplateDetails
/// w ##Class(web.DHCICUPrintProject).drawLines(2,10,100,10,200,5,3,5)
ClassMethod drawLines(RowId As %String, sX As %String, sY As %String, eX As %String, eY As %String, betweenX As %String, betweenY As %String, count As %String) As %String
{
	q:RowId="" "模板ID为空!"
	i betweenX="" s betweenX=0
	i betweenY="" s betweenY=0
	q:(sX'=+sX)||(sY'=+sY)||(eX'=+eX)||(eY'=+eY)||(betweenX'=+betweenX)||(betweenY'=+betweenY)||(count'=+count) "请输入有效的数字！"
	
	f i=1:1:count d
	.s sPonit=(sX+((i-1)*betweenX))_","_(sY+((i-1)*betweenY))
	.s ePonit=(eX+((i-1)*betweenX))_","_(eY+((i-1)*betweenY))
	.;b //1
	.k PLIST
	.s PLIST(0)=RowId       //ICUPTD_ICUPTId
	.s PLIST(3)="L"         //ICUPTD_Type
	.s PLIST(4)=sPonit  //ICUPTD_StartPoint
	.s PLIST(5)=ePonit    //ICUPTD_EndPoint
	.s PLIST(7)=""     //ICUPTD_Style
	.&sql(insert into sqluser.DHC_ICU_PrintTemplateDetails values :PLIST())


	
	q 0
}

/// 复制模板
/// Table:DHC_ICU_PrintTemplateDetails
/// w ##Class(web.DHCICUPrintProject).drawLines(2,10,100,10,200,5,3,5)
ClassMethod copyTemplateDetails(RowId As %String) As %String
{
	q:RowId="" "模板ID为空!"
	s lastRowId="",ptId=""
	f  s ptId=$o(^DHCICUPrintTemplate(ptId)) q:ptId=""  d
	.s lastRowId=ptId
	q:lastRowId="" "获取模板ID失败"
	s needId=lastRowId+1
	m ^DHCICUPrintTemplate(needId)=^DHCICUPrintTemplate(RowId)


	
	q 0
}

/// 模板缩放
/// Table:DHC_ICU_PrintTemplateDetails
/// w ##Class(web.DHCICUPrintProject).ChangePrintTemplateSize(12,1.4,"")
ClassMethod ChangePrintTemplateSize(RowId As %String, Y As %String = 1, X As %String = 1) As %String
{
	q:RowId="" "模板ID为空!"
	i (Y="")||(Y=0) s Y=1
	i (X="")||(X=0) s X=1
	q:(Y'=+Y)||(X'=+X) "请输入有效的数字！"
	
	s detailId=""
	f  s detailId=$o(^DHCICUPrintTemplate(RowId,"Details",detailId)) q:detailId=""  d
	.s point1=$p($g(^DHCICUPrintTemplate(RowId,"Details",detailId)),"^",2)
	.i point1'=""  d
	..s X1=$p(point1,",",1)*X
	..s Y1=$p(point1,",",2)*Y
	..s newPoint1=X1_","_Y1
	..;b //1
	..s $p(^DHCICUPrintTemplate(RowId,"Details",detailId),"^",2)=newPoint1
	.s point2=$p($g(^DHCICUPrintTemplate(RowId,"Details",detailId)),"^",3)
	.i point2'=""  d
	..s X2=$p(point2,",",1)*X
	..s Y2=$p(point2,",",2)*Y
	..s newPoint2=X2_","_Y2
	..s $p(^DHCICUPrintTemplate(RowId,"Details",detailId),"^",3)=newPoint2


	
	q 0
}

}
