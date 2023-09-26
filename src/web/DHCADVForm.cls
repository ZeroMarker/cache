/// 输出表单布局方法
/// zhouxin
/// 2017-09-27
Class web.DHCADVForm Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCADVForm).displayForm("advBlood","","","Y^15||1")
ClassMethod displayForm(code, recordId = "", displayborder = "", inplist = "", HospId = "")
{
	//n (code,recordId,displayborder)
	i code'="" d
	.s alphaupCode=##class(web.DHCADVAction).ALPHAUP(code)
	.s nameId=+$o(^User.DHCAdvFormNameI("IndexCode",alphaupCode,""))
	.q:nameId=0
	.s version=$LIST(^User.DHCAdvFormNameD(nameId),4)
	.//修改查看当时版本
	.i recordId'="" d
	..s formVersion=$o(^User.DHCAdvFormRecordVersionI("IndexRecordForm",recordId,nameId,""))
	..i +formVersion'=0 d
	...s version=$LIST(^User.DHCAdvFormRecordVersionD(formVersion),3)
	.q:version=""
	.i displayborder="" d
	..d ..IncludeHtml(nameId)
	..w "<input type='hidden' id='formId' value='"_nameId_"'>"
	..w "<input type='hidden' id='formVersion' value='"_version_"'>"
	..w "<input type='hidden' id='recordId' value='"_recordId_"'  >"
	.s form=""
	.f  s form=$o(^User.DHCAdvFormI("IndexNameVersionParef",nameId," "_version," "_0,form)) q:form=""  d
	..s formObj=##class(User.DHCAdvForm).%OpenId(form)
	..d formObj.ToLayoutHtml(recordId,inplist,HospId)
	e  d
	.w "<h1 id='formerrmasage'>表单代码不能为空！</h1><br>"
	q ""
}

ClassMethod IncludeHtml(formId)
{
	
	//n (formId)
	s js=$LIST(^User.DHCAdvFormNameD(formId),5)
	q:js="" ""
	s jsPath="../scripts/dhcadvEvt/skin/js/"_js
	s jscharset="gb2312"
	w "<script type=""text/javascript"" src="""_js_""""_" charset="""_jscharset_"""></script>"
	q ""
}

ClassMethod ToHTML(id) As %String
{
	//n (id)
	q:'$d(^User.DHCAdvFormD(id))
	s formdata=^User.DHCAdvFormD(id)
	s type=$LIST(formdata,7)
	s formName=$LIST(formdata,2)
	s version=$LIST(formdata,9)
	i ((type="row")||(type="column")) d
	.w "<div class='lyrow ui-draggable' style='display: block;'>"
	.w "<a href='#close' class='remove label label-danger'><i class='glyphicon-remove glyphicon'></i> 删除</a>"
	.w "<span class='drag label label-default'><i class='glyphicon glyphicon-move'></i> 拖动</span>"
	.i type="row" d
	..w "<span class='drag label label-success' onclick='copyRow(this)'><i class='glyphicon glyphicon-chevron-down'></i> 复制</span>"
	.w "<div class='preview'><input type='text'  class='form-control'></div>"
	.w "<div class='view'>"
	.w "	<div class='row clearfix'>"
	.s column=""
	.f  s column=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_id,column)) q:column=""  d
	..w "	<div class='"_$LIST(^User.DHCAdvFormD(column),8)_" column ui-sortable'>"
	..s subColumn=""
	..f  s subColumn=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_column,subColumn)) q:subColumn=""  d
	...d ..ToHTML(subColumn)
	..w "	</div>"
	.w "</div>"
	.w "</div>"
	.w "</div>"
	
	i type="element" d
	.q:+$LIST(formdata,4)=0
	.q:'$d(^User.DHCAdvFormDicD($LIST(formdata,4)))
	.s obj=##class(User.DHCAdvFormDic).%OpenId($LIST(formdata,4))
	.d obj.ToHTML(id)
}

/// Description:锚点数据kill
/// Creator:huaxiaoying
/// CreateDate:2017-11-28
ClassMethod KillTmp()
{
	k ^TMP("DHCADV","User.DHCAdvForm","ToLayoutHtml")
}

/// Description:锚点ToHtml
/// Creator:huaxiaoying
/// CreateDate:2017-11-29
/// w ##class(web.DHCADVForm).AnchorToHtml()
ClassMethod AnchorToHtml()
{
	n (%session)
	S advpid="",i=1,js=""
	w "<div id='anchor' style='width:220px;height:410px;position:fixed;right:20px;top:5px;z-index:1;'>"
	w "<ul class='anchor-list'>"
	w "<li style='height:13px'>"
	w " <div class='anchor-circle'></div>"
	w " <span class='anchor-txt'></span>"
	w "</li>"
	
	F  S advpid=$o(^TMP("DHCADV","User.DHCAdvForm","ToLayoutHtml",advpid)) Q:advpid=""  D
	.S mdate=$g(^TMP("DHCADV","User.DHCAdvForm","ToLayoutHtml",advpid))
	.S dicKey=$P(mdate,"^",1)
	.S panelTitle=$P(mdate,"^",2)
	.s id="anchor"_i
	.;s i=i+1
	.;s js=js_"$('#"_id_"').click(function() {"
	.;s js=js_"$(window).scrollTop($('#"_dicKey_"').offset().top);"
	.;s js=js_"});"
	.w "<li>"
	.w " <div class='circle'></div>"
	.;w " <a herf='#' id='"_id_"'>"_panelTitle_"</a>"
	.w " <a herf='#' id='"_id_"' onclick=javascript:document.getElementById('"_dicKey_"').scrollIntoView()>"_panelTitle_"</a>"
	.w "</li>"
	
	s id="anchor"_i  //hxy 2020-03-21 st
	;s i=i+1
	;s js=js_"$('#"_id_"').click(function() {"
	;s js=js_"$(window).scrollTop($('#"_"AuditMessage"_"').offset().top);"
	;s js=js_"});"
	w "<li>"
	w " <div class='circle'></div>"
	;w " <a herf='#' id='"_id_"'>"_"事件处理反馈信息"_"</a>"
	w " <a herf='#' id='"_id_"' onclick=javascript:document.getElementById('AuditMessage').scrollIntoView()>"_##class(websys.Translation).Get("dhcadv.layoutform.csp","事件处理反馈信息")_"</a>"
	w "</li>" //ed

	w "<li>"
	w " <i class='anchor-circle'></i>"
	w "</li>"
	w "</ul>"
    w "</div>"
    
    w "<script type='text/javascript'>"
    w "$(document).ready(function(){"_js_""
	w "  })"
    w "</script>"	
    
	k ^TMP("DHCADV","User.DHCAdvForm","ToLayoutHtml")
	
	Q ""
}

}
