/// Description:	编辑器
/// Creator:		hxy 
/// CreateDate:		2020-10-20
Class web.DHCCKBRuleEditor Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod displayForm(num)
{
	w "<div style='height: 330px; position: relative;'>"
	w " <svg height='100%' version='1.1' width='100%' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' style='overflow: hidden; position: relative; left: -0.997159px; top: -0.0880647px;'>"
	w " <desc style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'>Created with Raphaël 2.2.0</desc>"
	w " <defs style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></defs>"
	;d ..displayFormPath(num) //画线1
 d ..displayPath(1,1,1) //画线5 st
 d ..displayPath(1,1,3)
 d ..displayPath(1,1,8)
 d ..displayPath(2,3,3)
 d ..displayPath(2,3,4)
 d ..displayPath(2,3,5)
 d ..displayPath(2,3,7)
 d ..displayPathXY(2,1,2)
 d ..displayPathXY(2,8,3)
 d ..displayPathXY(3,5,2)
 d ..displayPathSpan(1, 1, "并且")
 d ..displayPathSpan(2, 1, "或者")
 d ..displayPathSpan(2, 3, "联合")
 d ..displayPathSpan(3, 5, "或者")
 d ..displayPathSpan(2, 8, "或者")
	w " </svg>"
	w "</div>"
	q ""
}

/// Description:	画出四条线(弃用)
/// other:		w ##class(web.DHCCKBRuleEditor).displayFormPath("4")
ClassMethod displayFormPath(num)
{
	f i=1:1:num d
	.s site=i-1*30+16
	.s d="M45,16C45,"_site_",45,"_site_",80,"_site
	.w " <path fill='none' stroke='#777777' d='"_d_"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>"
	q ""
}

/// Description:	画出该线(弃用)
/// Input:  lev(x轴位置), ySt(y轴开始位置), yEd(y轴结束位置)
/// other:		w ##class(web.DHCCKBRuleEditor).displayPath(1,1,1)
ClassMethod displayPath(lev, ySt, yEd)
{
	s stX=lev-1*75+45
	s stY=ySt-1*30+16 
	s edX=stX+35
	s site=yEd-ySt*30+stY
	s d="M"_stX_","_stY_"C"_stX_","_site_","_stX_","_site_","_edX_","_site
	w " <path fill='none' stroke='#777777' d='"_d_"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>"
	q ""
}

/// Description:	取起始坐标（然后画出该层所有线）(弃用)
/// input: (x第几层，y第几层,分支数)
/// other:		w ##class(web.DHCCKBRuleEditor).displayPathXY("4")
ClassMethod displayPathXY(xLev, yLev, num)
{
	;s x=45,y=16
	s stX=xLev-1*75+45
	s stY=yLev-1*30+16 //lev-1*33+16
	d ..displayPathAll(stX, stY, num)
}

/// Description:	画出该层所有线(弃用)
/// Input:  起始坐标(stX, stY)和分支数num
/// other:		w ##class(web.DHCCKBRuleEditor).displayPath("45","16","4")
ClassMethod displayPathAll(stX, stY, num)
{
	s edX=stX+35
	f i=1:1:num d
	.s site=i-1*30+stY
	.s d="M"_stX_","_stY_"C"_stX_","_site_","_stX_","_site_","_edX_","_site
	.w " <path fill='none' stroke='#777777' d='"_d_"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>"
	q ""
}

/// Description:	画出层逻辑span(弃用)
/// Input:  起始坐标(stX, stY)和分支数num
/// other:		w ##class(web.DHCCKBRuleEditor).displayPathSan("45","16","4")
ClassMethod displayPathSpan(xLev, yLev, type)
{
	;s x=5,y=5
	s left=xLev-1*75+5
	s top=yLev-1*30+5
	w "<span class='btn btn-default dropdown-toggle rule-join-container' style='position: absolute; left: "_left_"px; top: "_top_"px;'>"
	w " <span style='font-size: 11pt'>"_type_"</span><i class='glyphicon glyphicon-chevron-down rule-join-node'></i></span>"
}

/// Descript:取药品属性  动态输出下拉面板
/// Creator:sufan
/// CreateDate:2020-11-13
/// d ##class(web.DHCCKBRuleEditor).QueryDrugAttr()
ClassMethod QueryDrugAttr()
{
	s modelId = ##class(web.DHCCKBCommon).GetDicIdByCode("ModelFlag")		//属性
	s linkPropId = ##class(web.DHCCKBCommon).GetLinkProp()
	s html = "",htmlstring = ""
	s modelAttrId = ""
	for  s modelAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",modelId,modelAttrId))  Q:modelAttrId=""  d
	.s modelDicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(modelAttrId)),2)			//实体Id
	.Q:##class(web.DHCCKBCommon).IsEnabled(modelDicId)'=1
	.s modelDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(modelDicId)),3)	
	.s linkParId = ""
	.s:linkPropId'="" linkParId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",modelDicId,linkPropId,""))
	.i (linkParId'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Parref",linkParId)))  d
	..s html = "<li style='cursor:default' class='dropdown-submenu'><a href='javascript:void(0)' onClick='selItems(this)' data="_modelDicId_">"_modelDesc_"</a>"
	.e  d
	..s html = "<li><a href='javascript:void(0)'  onClick='selItems(this)' par_data='' data="_modelDicId_">"_modelDesc_"</a>"
	.b:modelDesc["症状" 
	.s html = ..QueryNextHtml(linkParId,html,modelDesc,modelDicId) //hxy add modelDesc 为了选择变量时显示 例如“西药的”  sufan 新增上级变量
	.i htmlstring = "" d
	..s htmlstring = html
	.e  d
	..s htmlstring = htmlstring_html
	w htmlstring 
	Q "" //htmlstring //hxy 2022-05-24 改js动态加载后输出两遍注释
}

ClassMethod QueryNextHtml(parId, html, modelDesc, modelDicId)
{
	n (parId,html,modelDesc,modelDicId)
	Q:(+parId=0)||(parId="-100000000000000") html_"</li>"
	s subId="sub"_modelDicId //hxy 2022-05-24 st
	s htmlstr = "<ul class='dropdown-menu dropdown-context dropdown-context-sub' id='"_subId_"'>"
	;s htmlstr = "<ul class='dropdown-menu dropdown-context dropdown-context-sub' style='min-width:420px' id='"_subId_"'>" //请选择变量sub显示两列
	;s htmlstr = "<ul class='dropdown-menu dropdown-context dropdown-context-sub'>"
	
	s htmlstr = htmlstr_"<div style='margin-left: 6px;margin-right: 2px'>"
	s htmlstr = htmlstr_"<i class='glyphicon glyphicon-filter' style='color:#006600;margin-left: 2px;margin-right: 2px'></i>"
	s htmlstr = htmlstr_"<input type='text' onkeydown='if(event.keyCode==13) enterVarFind(this)' data='"_subId_"' dataDesc='"_modelDesc_"' dataPar='"_parId_"' class='textbox' placeholder='输入值后回车查询' style='width: calc(100% - 25px);display: inline-block;height: 26px;padding-left: 10px;'>"
	s htmlstr = htmlstr_"</div>" //ed
	
	s dicId = "",count = 0
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parId,dicId))  Q:dicId=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.q:dicId=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(dicId))
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)				//描述
	.s htmlstr = htmlstr_"<li style='cursor:default;float:left;width:180px;'><a href='javascript:void(0)'  onClick='selItems(this)' par_data="_modelDicId_" data="_dicId_" name="_modelDesc_">"_dicDesc_"</a></li>"
	.s count = count+1
	Q:count>0 html_htmlstr_"</ul></li>"
	Q:count=0 html_"</li>"
}

/// w ##class(web.DHCCKBRuleEditor).QueryNextHtmlq("19","西药","5","成分")
ClassMethod QueryNextHtmlq(parId, modelDesc, modelDicId, q = "")
{
	n (parId,modelDesc,modelDicId,q)
	Q:(+parId=0)||(modelDesc="")||(+modelDicId=0) ""
	s subId="sub"_modelDicId
	s htmlstr = "<div style='margin-left: 2px;margin-right: 2px'>"
	s htmlstr = htmlstr_"<i class='glyphicon glyphicon-filter' style='color:#006600;margin-left: 2px;margin-right: 2px'></i>"
	s htmlstr = htmlstr_"<input type='text' onkeydown='if(event.keyCode==13) enterVarFind(this)' data='"_subId_"' dataDesc='"_modelDesc_"' dataPar='"_parId_"' class='textbox' placeholder='输入值后回车查询' style='width: 85%;display: inline-block;height: 26px;padding: 1px;font-size: 12px;'>"
	s htmlstr = htmlstr_"</div>"		

	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parId,dicId))  Q:dicId=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.q:dicId=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(dicId))
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)				//描述
	.q:(q'="")&(dicDesc'[q)
	.s htmlstr = htmlstr_"<li style='cursor:default'><a href='javascript:void(0)' onClick='selItems(this)' par_data="_modelDicId_" data="_dicId_" name="_modelDesc_">"_dicDesc_"</a></li>"
	w htmlstr
	q ""
}

/// Descript:根据属性动态取字典数据
/// d ##class(web.DHCCKBRuleEditor).QueryDataHtmlByAttr(6,"")
ClassMethod QueryDataHtmlByAttr(attrId, q)
{
	n (attrId,q)
	q:+attrId=0 "请选择变量" //hxy 2022-06-01 
	s ret = ""
	s dataSouId = ##class(web.DHCCKBCommon).GetDataSource()
	s link=""
	for  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrId,dataSouId,link))  Q:link=""  d
	.q:+link=0
	.s parentId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.q:+parentId=0
	.d ..QueryDictonHtml(parentId,q)
	Q ret
}

/// Descript:动态取字典数据
/// Input:dicTionId:字典id
/// Output:字典数据html
/// d ##class(web.DHCCKBRuleEditor).QueryDictonHtml("127","包")
ClassMethod QueryDictonHtml(dicTionId, q = "")
{
	n (dicTionId,q)
	s htmlstr = "<div style='margin-left: 6px;margin-right: 2px'>"
	s htmlstr = htmlstr _"<i class='glyphicon glyphicon-filter' style='color:#006600;margin-left: 2px;margin-right: 2px'></i>"
	s htmlstr = htmlstr_"<input type='text' onkeydown='if(event.keyCode==13) enterFind()' class='textbox' placeholder='输入值后回车查询' style='width: calc(100% - 25px);display: inline-block;height: 26px;padding-left: 10px;'>" //hxy 2020-12-02 add onkeydown=
	s htmlstr = htmlstr_"</div>"			
		 
	s count = 0
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicTionId,dicId))  Q:dicId=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)				//描述
	.d ..QuerySubItmHtml(dicId,.count,.htmlstr,q)
	.Q:dicDesc'[q
	.Q:(q="")&&(count>100)
	.s count = count+1
	.i htmlstr = "" s htmlstr = "<li style='cursor:default;float:left;width:180px;'><a class='li-a' href='javascript:void(0)' onclick='selItems(this)' data="_dicId_" >"_dicDesc_"</a></li>"
	.e  s htmlstr = htmlstr_"<li style='cursor:default;float:left;width:180px;'><a class='li-a' href='javascript:void(0)'  onclick='selItems(this)' data="_dicId_" >"_dicDesc_"</a></li>"
	
	w htmlstr
	Q "" //Q htmlstr //hxy 2020-12-02 单位输出双份修改
}

/// Creator:qunianepng
/// DateTime: 2021/1/23
/// Descript:查询子层数据
/// Input:Parref:字典id,计数器count,htmlstr串
/// Output:字典数据html
/// w ##class(web.DHCCKBRuleEditor).QueryDataHtmlByAttrFlag("13")
ClassMethod QuerySubItmHtml(Parref, count, htmlstr, q = "")
{
	n (Parref,count,htmlstr,q)
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
    .Q:##class(web.DHCCKBCommon).IsEnabled(SubId)'=1
    .i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItmHtml(SubId,.count,.htmlstr,q)
    .s DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(SubId)),3)				//描述
	.Q:DicDesc'[q
	.Q:(q="")&&(count>100)
	.s count = count+1
	.i htmlstr = "" s htmlstr = "<li style='cursor:default;float:left;width:180px;'><a class='li-a' href='javascript:void(0)' onclick='selItems(this)' data="_SubId_" >"_DicDesc_"</a></li>"
	.e  s htmlstr = htmlstr_"<li style='cursor:default;float:left;width:180px;'><a class='li-a' href='javascript:void(0)'  onclick='selItems(this)' data="_SubId_" >"_DicDesc_"</a></li>"
	  
    q ""
}

/// Descript:根据属性动态取是否有字典数据
/// Input:dicTionId:字典id
/// Output:"":无;非空：有
/// w ##class(web.DHCCKBRuleEditor).QueryDataHtmlByAttrFlag("13")
ClassMethod QueryDataHtmlByAttrFlag(attrId)
{
	n (attrId)
	s ret = ""
	s dataSouId = ##class(web.DHCCKBCommon).GetDataSource()
	s link=""
	for  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrId,dataSouId,link))  Q:link=""  d
	.q:+link=0
	.s parentId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.q:+parentId=0
	.s flag=..QueryDictonHtmlFlag(parentId)
	.s:flag>0 ret=1
	Q ret
}

/// Descript:动态取字典数据个数
/// Input:dicTionId:字典id
/// Output:0:无;非0:有
/// w ##class(web.DHCCKBRuleEditor).QueryDictonHtmlFlag("126")
ClassMethod QueryDictonHtmlFlag(dicTionId)
{
	n (dicTionId)
	s count = 0
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicTionId,dicId))  Q:(dicId="")||(count>0)  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s count=count+1
	Q count
}

/// Creator: 	hxy
/// CreateDate: 2021-03-24
/// Descript:根据属性动态取字典数据ID
/// w ##class(web.DHCCKBRuleEditor).QueryDataByAttr("80","不通过")
/// w ##class(web.DHCCKBRuleEditor).QueryDataByAttr("81","提醒")
/// w ##class(web.DHCCKBRuleEditor).QueryDataByAttr("74698","Y")
ClassMethod QueryDataByAttr(attrId, q)
{
	n (attrId,q)
	q:q="" ""
	s ret = ""
	s dataSouId = ##class(web.DHCCKBCommon).GetDataSource()
	s link=""
	for  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrId,dataSouId,link))  Q:link=""  d
	.q:+link=0
	.s parentId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.q:+parentId=0
	.s ret=..QueryDicton(parentId,q)
	Q ret
}

/// Creator: 	hxy
/// CreateDate: 2021-03-24
/// Descript:动态取字典数据ID
/// Input:dicTionId:字典id
/// Output:字典数据ID
/// d ##class(web.DHCCKBRuleEditor).QueryDicton("5","")
ClassMethod QueryDicton(dicTionId, q)
{
	n (dicTionId,q)
	s ret=""
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicTionId,dicId))  Q:(dicId="")||(ret'="")  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)				//描述
	.s subId=..QuerySubItm(dicId,q)
	.;b
	.s:subId'="" ret=subId
	.Q:dicDesc'=q
	.s ret=dicId
	Q ret
}

ClassMethod QuerySubItm(Parref, q)
{
	n (Parref,q)
	s ret=""
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")||(ret'="")  d
    .q:+SubId=0
    .i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d //取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,q)
    .s DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(SubId)),3)	//描述
	.Q:DicDesc'=q
	.s ret=SubId
    q ret
}

/// Creator: 	hxy
/// CreateDate: 2021-03-25
/// Descript:   药品输出的所有变量选择默认
/// w ##class(web.DHCCKBRuleEditor).QueryDrugOutputAttr()
ClassMethod QueryDrugOutputAttr()
{
	s modelId = ##class(web.DHCCKBCommon).GetDicIdByCode("ModelFlag")		//属性
	s linkPropId = ##class(web.DHCCKBCommon).GetLinkProp()
	s ret=""
	s modelAttrId = ""
	for  s modelAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",modelId,modelAttrId))  Q:modelAttrId=""  d
	.s modelDicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(modelAttrId)),2)			//实体Id
	.Q:##class(web.DHCCKBCommon).IsEnabled(modelDicId)'=1
	.s modelDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(modelDicId)),3)
	.Q:modelDesc'="药品输出"
	.s linkParId = ""
	.s:linkPropId'="" linkParId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",modelDicId,linkPropId,""))
	.i (linkParId'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Parref",linkParId)))  d
	.;s ret=..QueryNext(linkParId,modelDesc,modelDicId)
	.s ret=..GetNextHtml(linkParId,modelDesc,modelDicId)
	Q ret
}

ClassMethod QueryNext(parId, modelDesc, modelDicId)
{
	n (parId,modelDesc,modelDicId)
	Q:+parId=0 ""
	s ret=""
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parId,dicId))  Q:dicId=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3) //描述
	.s str=modelDesc_"的"_dicDesc_"^"_modelDicId_"^"_dicId
	.i ret="" d
	..s ret=str
	.e  d
	..s ret=ret_"#"_str
	q ret
}

ClassMethod GetNextHtml(parId, modelDesc, modelDicId)
{
	n (parId,modelDesc,modelDicId)
	Q:+parId=0 ""
	s ret=""
    ;s descStr="通过标记^管理级别^消息提示标记^提示信息^" //管制力度提示依据
    s descStr="管理级别^提示信息^提示依据^消息提示标记^知识来源^" //2022-05-17
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parId,dicId))  Q:dicId=""  d
	.Q:##class(web.DHCCKBCommon).IsEnabled(dicId)'=1
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3) //描述
	.q:descStr'[dicDesc
	.s datacateDesc=""
	.s:dicDesc="通过标记" datacateDesc="不通过"
	.s:dicDesc="管理级别" datacateDesc="提醒"
	.s:dicDesc="消息提示标记" datacateDesc="Y"
	.;s:dicDesc="管制力度" datacateDesc="慎用"
	.s datacate=##class(web.DHCCKBRuleEditor).QueryDataByAttr(dicId,datacateDesc) //取值'不通过'、"提醒"、"Y"的id
	.s datatype="Constant"
	.s:dicDesc="提示信息" datatype="Input"
	.s:dicDesc="提示依据" datatype="Input" //2022-05-17
	.s html="<div class='rule-action' id='0' data_type='"_datatype_"' data_cate='"_modelDicId_"' data_name='"_dicId_"'>"
	.;s html=html_"	<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
	.s html=html_"	<span class='icon rule-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
	.i (dicDesc="提示信息")||(dicDesc="管理级别")||(dicDesc="提示依据") d //2022-05-17
	..s html=html_"	<span>"
	.e  d
	..s html=html_"	<span data_cate="_datacate_">"
	.s html=html_"		<span class='line-green'>变量赋值:</span>"
	.s html=html_"		<span class='blank'>.</span>"
	.s html=html_"		<span class='line-darkcyan-zero' par_data="_modelDicId_" data_id="_dicId_" onclick='chooseVar(this)'>"_modelDesc_"的"_dicDesc_"</span>	"
	.s html=html_"		<span style='color: red;'>=</span>"
	.s html=html_"		<span class='blank' onclick='chooseType(this,1)'>.</span>"
	.s html=html_"		<span>"
	.i datatype="Input" d
	..s html=html_"			<span class='line-brown' onclick='viewInput(this)' style='display: none;'>请输入值</span>"
	..s html=html_"			<input class='hisui-validatebox textbox result-input' data-options='' ondblclick='inputHide(this)' value='' style='display: inline;'>"
	.e  d
	..i (dicDesc="管理级别")!(dicDesc="知识来源") d
	...s html=html_"			<span onmouseover='chooseDataset(this)' data_id='1' class='line-blue'>请选择数据集</span>"
	..e  d
	...s html=html_"		<span onclick='' data_id="_datacate_" class='line-blue'>"_datacateDesc_"</span>" //chooseDataset(this) 通过标记和消息提示标记能把等号后面的内容定死，不允许修改
	.s html=html_"		</span>"
	.s html=html_"	</span>"
	.s html=html_"</div>"
	.s ret=ret_html
	q ret
}

/// Descript:	分支扩展取管理级别属性  动态输出下拉面板
/// Creator:	qunianpeng
/// CreateDate:	2022-04-21
/// d ##class(web.DHCCKBRuleEditor).QueryLevelAttr()
ClassMethod QueryLevelAttr()
{
	s levelPropId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")		//属性	
	s levelPropDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+levelPropId)),3)
	s html = ""
	//s html = "<li style='cursor:default' class='dropdown-submenu'><a href='#' onClick='selExtItems(this)' data="_levelPropId_">"_levelPropDesc_"</a>"
	s html = "<li style='cursor:default' ><a href='javascript:void(0)'  onClick='selExtItems(this)' par_data='' data="_levelPropId_">"_levelPropDesc_"</a></li>"
	s html = html_"<li><a href='javascript:void(0)'  onClick='selExtItems(this)' par_data='' data="_-100_">删除</a></li>"

	w html
	Q html
}

/// Creator: 	hxy
/// CreateDate: 2022-05-17
/// Descript:   小铅笔默认管理级别
/// w ##class(web.DHCCKBRuleEditor).GetLevelId()
ClassMethod GetLevelId()
{
	s levelPropId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")		//属性	
	Q levelPropId
}

/// Creator: 	qunianpeng
/// CreateDate: 2022-09-21
/// Descript:   根据药品类型默认级别(药品:默认小铅笔级别【适宜配伍】，通用名小铅笔级别：【可配伍】)
/// Input:		drugstr：目录id^药品id(可能是通用名,成分,药品)
/// w ##class(web.DHCCKBRuleEditor).GetDefaultLevel("72^81646")
ClassMethod GetDefaultLevel(drugstr)
{
	s levelCode = "suited"	// 适宜配伍
	s drugId = $p(drugstr,"^",2)
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)		
	i parrefCode="GeneralFromData" s levelCode="passable"	//可配
	s levelFlagData = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlagData")
	s levelId = ##class(web.DHCCKBCommon).GetDicIdByCode(levelCode,levelFlagData)
	s ret = ##class(web.DHCCKBCommon).GetDicIdByCode(levelCode,levelFlagData)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+levelId)),3)
	
	q ret
}

}
