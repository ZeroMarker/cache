/// 辅助表单输出的类
Class User.DHCADVFormHelp Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 查找元素中的panel和fieldset元素
ClassMethod checkPanel(formName, formId, version, recordId = "")
{
	n (formName, formId,recordId,version)
	s ret=0,subform="",count=0,width="100%",key="",style=""
	f  s subform=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_formId,subform)) q:(subform="")||(ret'=0)  d
	.s dic=$LIST(^User.DHCAdvFormD(subform),4)
	.q:+dic=0
	.q:'$d(^User.DHCAdvFormDicD(dic))
	.s dicdata=^User.DHCAdvFormDicD(dic)
	.s:$List(dicdata,3)="panel" ret=$List(dicdata,4),key=$List(dicdata,2),style=$List(dicdata,3)
	.s:$List(dicdata,3)="fieldset" ret=$List(dicdata,4),key=$List(dicdata,2),style=$List(dicdata,3)
	.i recordId'="" d 
	..s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,subform,dic,""))
	..s:recordItmId'=0 count=count+1
	s:count>0 width=1/count*100_"%"
	q ret_"^"_width_"^"_key_"^"_style
}

/// 检查子元素中是否有父元素同级的
ClassMethod checkSameLevel(formName, formId, version)
{
	n (formName,formId,version)
	s ret=0,columform=""
	f  s columform=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_formId,columform)) q:columform=""  d
	.q:ret'=0
	.s subform=""
	.f  s subform=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_columform,subform)) q:subform=""  d
	..q:ret'=0
	..s dic=$LIST(^User.DHCAdvFormD(subform),4)
	..q:+dic=0
	..q:'$d(^User.DHCAdvFormDicD(dic))
	..s dicdata=^User.DHCAdvFormDicD(dic)
	..q:$List(dicdata,3)'="select-change"
	..q:$List(dicdata,15)'="Y"
	..s ret=dic_"^"_subform
	q ret
}

/// 吧url里的json转成html
ClassMethod WriteUrlRadioCheckbox(dicId, formid, recordId = "")
{
	n (dicId, formid, recordId)
	s dicData=^User.DHCAdvFormDicD(dicId)
	s url=$LIST(dicData,5)
	s style=$LIST(dicData,3)
	s par=$p(url,"?",2)
	s ClassName=$p($p(par,"&",1),"=",2)
	s MethodName=$p($p(par,"&",2),"=",2)

	Q:'##class(websys.Conversions).IsValidClassName(ClassName)
	Q:'##class(websys.Conversions).IsValidMethodName(ClassName,MethodName)
	set myobj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName,0)
	Q:'$IsObject(myobj)
	set FormalSpecParsed = myobj.FormalSpecParsed
	set paramStr = ""
	for tmp=1:1:$ll(FormalSpecParsed) d
	.set paramName = $lg($lg(FormalSpecParsed,tmp),1)
	.set paramStr = paramStr_$case(paramStr,"":"",:",")_..GetParValueByKey(paramName,par)
	w "<div id='"_$List(^User.DHCAdvFormDicD(dicId),2)_"'>"
	w "<div style='margin-top: 5px;'>"
	Set code="Set rs=##class("_ClassName_")."_MethodName_"("_paramStr_")"
	XECUTE code
	s arry=[].%FromJSON(rs)
	set iter = arry.%GetIterator()
	s rowWidth=+..GetParValueByKey("rowWidth",par)
	s:rowWidth=0 rowWidth=4
	s witdh=1/rowWidth*100_"%"
	
	s tmpcount=0,title=""   
   	while iter.%GetNext(.key, .value) {
	   	
	   	i rowWidth=tmpcount d
	   	.s tmpcount=  0
	   	.w "</div><div style='margin-top: 5px;'>"
	  
   		w "<label style='margin: 0px;padding: 0px;display:inline-block;width:"_witdh_"'>"
		w "<input " 
		w "	type='"_style_"'  "
		w " id="_value.%Get("id")
		w "	value='"_value.%Get("id")_"' "	
		
		
		i (style="radio"){
			w "	data-id='"_formid_"."_dicId_"' "
			w "	name='"_formid_"' "
		}else{
			w "	name='"_formid_"."_dicId_"' "	
		}
		i recordId'="" d
		.i $d(^User.DHCAdvFormRecordItmI("IndexFormDicValue",recordId,formid,dicId,$$ALPHAUP^SSUTIL4(value.%Get("id")))) d
		..w " checked='checked' "
		w "   />"
		w "<label "
		w "for='"_value.%Get("id")_"'"
		w " style='margin-top=:-3px' "
		w " >"
		w value.%Get("text")
		w "</label>"
		w "</label>"
		
		s tmpcount=tmpcount+1		
   	}
	w "</div>"
	w "</div>"
}

ClassMethod GetParValueByKey(key, par)
{
	n (key, par)
	s ret=""
	f i=3:1:$l(par,"&") d 
	.
	.s tmp=$p(par,"&",i)
	.i $p(tmp,"=",1)=key d
	..s ret=$p(tmp,"=",2)
	q ret
}

// 输出datagrid行html

ClassMethod getSubDatagrid(formId, id, row = "", recordid = "")
{
	n (id,formId,row,recordid,%session)
	s:row="" row=$i(^DHCADVCOMMON("FORMDIC","DATAGRID",formId,id))  
	w "<tr>"
	;s itm=""
	;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
	;.
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s itm=""
	.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
	
	..s dicdata=^User.DHCAdvFormDicD(itm)
	..s style=$LIST(dicdata,3)
	..s dicField=$LIST(dicdata,2)
	..s field=formId_"."_itm_"."_row
	..s url=$LIST(dicdata,5)
	..s title=$LIST(dicdata,4)
	..s title=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",title)  ;2020-06-28 cy
	..s value=$LIST(dicdata,7)
	..s dicWidth=$LIST(dicdata,10)
	..s dicHeight=$LIST(dicdata,11)
	..s dicWidth=$case(dicWidth,"":171,:dicWidth)
	..s dicHeight=$case(dicHeight,"":20,:dicHeight)
	..s hiddenDic=$LIST(dicdata,23)
	..q:hiddenDic="Y" //元素是否隐藏 cy 2019-11-21
	..i recordid'="" d
	...s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordid,formId,$LIST(dicdata,6),row,itm,""))
	...i recordItmId'=0 d
	....s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	..s requried=""
	..s attr=+$o(^User.DHCAdvFormAttrI("IndexItmDic",formId,itm,""))
	..i attr'=0 d
	...s:$LIST(^User.DHCAdvFormAttrD(attr),4)="on" requried="Y"
	..w "<td >"
	..d ##class(User.DHCAdvForm).WriteTableTdHtml(itm, formId,recordid,row)
	..w "</td>"
	w "<td><a class='easyui-linkbutton' data-options=""iconCls:'icon-remove',plain:true"" onclick='javascript:removeRow(this)' >"_##class(websys.Translation).Get("dhcadv.layoutform.csp","删除")_"</a></td>"
	w "</tr>"
    q ""
}

}
