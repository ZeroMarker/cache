/// 打印表单
/// zhouxin
/// 2017-09-28
Class web.DHCADVFormPrint Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description:页面输出打印页面的html
/// Author:zhouxin
ClassMethod printHtml(recordId As %String) As %String
{


	s pid=##Class(web.DHCADVCOMMON).NewPid()
	k ^TMP("web.DHCADVFormPrint","printHtml",pid)
	d ##class(web.DHCADVFormPrint).PrintForm(recordId,"",pid)
}

/// Description:打印输出form的html
/// Author:zhouxin
ClassMethod PrintForm(recordId, code = "", pid, panelKey = "")
{
	
	s version="",formId=""
	i recordId'="" d
	.s data=^User.DHCAdvFormRecordD(recordId)
	.s version=$ListGet(data,3)
	.s formId=$ListGet(data,2)
	i code'="" d
	.s formId=$o(^User.DHCAdvFormNameI("IndexCode",##class(web.DHCADVAction).ALPHAUP(code),""))
	.q:formId=0
	.s formVersion=$o(^User.DHCAdvFormRecordVersionI("IndexRecordForm",recordId,formId,""))
	.i +formVersion'=0 d
	..s version=$ListGet(^User.DHCAdvFormRecordVersionD(formVersion),3)
	.e  d
	..s version=$ListGet(^User.DHCAdvFormNameD(formId),4)
	q:version=""
	
	s type=$ListGet(^User.DHCAdvFormNameD(formId),6)
	s name=$ListGet(^User.DHCAdvFormNameD(formId),3)
	i type="Y"{
		w "<div style='text-align: center'><h1>"_name_"</h1></div>"	
	}
	s formItm=""
	f  s formItm=$o(^User.DHCAdvFormI("IndexNameVersionParef",formId," "_version," "_0,formItm)) q:formItm=""  d
	.s formObj=##class(User.DHCAdvForm).%OpenId(formItm)
	.d formObj.PrintGrid(recordId,pid,panelKey,version)
	.w "<div style='height:1px'></div> "
	q ""
}

}
