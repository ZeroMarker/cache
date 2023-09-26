Import SQLUser

Class web.DHCMedCustomControl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

/// 控件使用例子
ClassMethod SetDicData(Type) As %String
{
	s Type="1"
	s itmName="ITEMVALUE"_rs.GetDataByName("Rowid")
	s DataType=rs.GetDataByName("Rowid")
	i DataType="ID1" d
    .d ..SetRedio(itmName,"2","1","Education")
    i DataType="ID2" d
    .d ..SetText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","")
    i DataType="ID3" d
    .d ..SetTextarea(itmName,"","","WIDTH: 200px;","")
    i DataType="ID4" d
    .d ..SetDateText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","")
    i DataType="ID5" d
    .d ..SetTimeText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","")
    i DataType="ID6" d
    .d ..SetNumberText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","")
    i DataType="ID7" d
    .d ..SetIntegerText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","")
    i DataType="ID8" d
    .d ..SetQueryText(itmName,"","","WIDTH: 200px; HEIGHT: 24px","","web.DHCMedWMRPUBLIC:QueryLoctionByDesc","")
    i DataType="ID9" d
    .d ..SetCheckBox(itmName,"","Y","","")
    i DataType="ID10" d
    .d ..SetComboBox(itmName,"","Y","WIDTH: 200px; HEIGHT: 24px","","InfectionOpeCutType","S")
    i DataType="ID11" d
    .d ..SetListBox(itmName,"","","WIDTH: 200px;","","Marriage","")
    
 	q ""
}

/// 普通文本框
ClassMethod SetText(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<INPUT ID='"_ElementName_"' NAME='"_ElementName_"' "
	w "STYLE='"_Style_"' "_STR_" "
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w "VALUE='"_Value_"' >"
	q
}

/// 多行文本框
ClassMethod SetTextarea(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<TEXTAREA ID='"_ElementName_"' NAME='"_ElementName_"' "
	w "STYLE='"_Style_"' "_STR_">"
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
    w Value
    w "</TEXTAREA>"
    q
}

/// 日期文本框
ClassMethod SetDateText(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<input id='"_ElementName_"' name='"_ElementName_"' "
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w "value='"_Value_"' "
	w "STYLE='"_Style_"' "_STR_" "
	w "onchange='txtDate_changehandler()' "
	w "onkeydown='txtDate_keydownhandler()' >"
	w "<IMG id='ld51032i"_ElementName_"' name='ld51032i"_ElementName_"' src='../images/websys/lookupdate.gif' onclick='"_ElementName_"_DateEvent()'>"
	w "<script>"
	w "function "_ElementName_"_DateEvent() {"
	w "		var url='websys.lookupdate.csp?ID="_ElementName_"&STARTVAL=&DATEVAL=';"
	w "		var tmp=url.split('%');"
	w "		url=tmp.join('%25');"
	w "		websys_lu(url,1,'top=200,left=200,width=370,height=230');"
	w "		return websys_cancel();"
	w "}"
	w "function "_ElementName_"_lookupSelect(dateval) {"
	w "	var obj=document.getElementById('"_ElementName_"');"
	w "	obj.value=dateval;"
	w "}"
	w "</script>"
	q
}

/// 时间文本框
ClassMethod SetTimeText(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<input id='"_ElementName_"' name='"_ElementName_"' "
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w "value='"_Value_"' "
	w "STYLE='"_Style_"' "_STR_" "
	w "onchange='txtTime_changehandler()' "
	w "onkeydown='txtTime_keydownhandler()' >"
	q
}

/// 数字文本框
ClassMethod SetNumberText(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<input id='"_ElementName_"' name='"_ElementName_"' "
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w "value='"_Value_"' "
	w "STYLE='"_Style_"' "_STR_" "
	w "onchange='txtNumber_changehandler()' "
	w "onkeydown='txtNumber_keydownhandler()' >"
	q
}

/// 整数文本框
ClassMethod SetIntegerText(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName,RealValue,DefaultValue,Style,STR)
	q:ElementName=""
	w "<input id='"_ElementName_"' name='"_ElementName_"' "
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w "value='"_Value_"' "
	w "STYLE='"_Style_"' "_STR_" "
	w "onchange='txtInteger_changehandler()' "
	w "onkeydown='txtInteger_keydownhandler()' >"
	q
}

/// 查询文本框
ClassMethod SetQueryText(ElementName, RealValue, DefaultValue, Style, STR, CONTEXT, TLUJSF)
{
	n (ElementName,RealValue,DefaultValue,Style,STR,CONTEXT,TLUJSF)
	q:(ElementName="")||(CONTEXT="")
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	s ValueId=$p(Value,"/",1)
	s ValueDesc=$p(Value,"/",2)
	w "<input id='"_ElementName_"Desc' name='"_ElementName_"Desc' "
	w "value='"_ValueDesc_"' "
	w "STYLE='"_Style_"' "_STR_" "
	w ">"
	w "<input id='"_ElementName_"' name='"_ElementName_"' type='hidden' value='"_ValueId_"'>"
	w "<IMG id='ld51032i"_ElementName_"' name='ld51032i"_ElementName_"' src='../images/websys/lookup.gif' onclick='"_ElementName_"Desc_queryhandler()'>"
	
	s LookUpSelect=$s(TLUJSF'="":TLUJSF,1:ElementName_"Desc_LookUpSelect")
	w "<script>"
	w "function "_ElementName_"Desc_queryhandler() {"
	w "     var objDesc=document.getElementById('"_ElementName_"Desc');"
	w "  	var url='websys.lookup.csp?ID="_ElementName_"Desc&CONTEXT=K"_CONTEXT_"&TLUJSF="_LookUpSelect_"&P1=' + objDesc.value + '&P2=326&P3=&P4=&P8=1';"
	w " 	websys_lu(url,1,'');"
	w " 	return websys_cancel();"
	w "}"
	w "function "_ElementName_"Desc_LookUpSelect(val) {"
	w "     var objDesc=document.getElementById('"_ElementName_"Desc');"
	w "     var obj=document.getElementById('"_ElementName_"');"
	w "     var tmp=val.split('^');"
	w "	    objDesc.value=tmp[1];"
	w "	    obj.value=tmp[0];"
	w "}"
	w "</script>"
	q
}

/// 复选框
ClassMethod SetCheckBox(ElementName, RealValue, DefaultValue, Style, STR)
{
	n (ElementName, RealValue, DefaultValue, Style, STR)
	q:ElementName=""
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	s:Value["Y" ValCheck="CHECKED"
	w "<input TYPE=checkbox id='"_ElementName_"' name='"_ElementName_"' "_ValCheck
	w "STYLE='"_Style_"' "_STR_" "
	w ">"
	q
}

/// 下拉框
ClassMethod SetComboBox(ElementName, RealValue, DefaultValue, Style, STR, DicType, Requre)
{
	n (ElementName, RealValue, DefaultValue, Style, STR, DicType, Requre)
	q:(ElementName="")||(DicType="")
    w "<select id='"_ElementName_"' name='"_ElementName_"' size=1 "
	w "STYLE='"_Style_"' "_STR_" "
	w ">"
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w:(Requre="S")&&(Value="") "<option  value='' selected></option>"
	w:(Requre="S")&&(Value'="") "<option  value='' ></option>"
	s temp=##class(web.DHCMedDictoryCtl).GetByType(DicType,"Y")
	f Index=1:1:($l(temp,$c(1))-1) d
	.s s=$p(temp,$c(1),Index)
	.s code=$p(s,"^",2)
	.s desc=$p(s,"^",3)
	.i code=Value d
	..w "<option value="_code_" selected>"_desc_"</option>"
	.e  d
	..w "<option value="_code_">"_desc_"</option>"
	w:(Requre="E")&&(Value="") "<option  value='' selected></option>"
	w:(Requre="E")&&(Value'="") "<option  value='' ></option>"
	w "</select>"
	q
}

/// 多选框
ClassMethod SetListBox(ElementName, RealValue, DefaultValue, Style, STR, DicType, Requre)
{
	n (ElementName, RealValue, DefaultValue, Style, STR, DicType, Requre)
	q:(ElementName="")||(DicType="")
    w "<select id='"_ElementName_"' name='"_ElementName_"' multiple "
	w "STYLE='"_Style_"' "_STR_" "
	w ">"
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	w:(Requre="S")&&(Value="") "<option  value='' selected></option>"
	w:(Requre="S")&&(Value'="") "<option  value='' ></option>"
	s temp=##class(web.DHCMedDictoryCtl).GetByType(DicType,"Y")
	f Index=1:1:($l(temp,$c(1))-1) d
	.s s=$p(temp,$c(1),Index)
	.s code=$p(s,"^",2)
	.s desc=$p(s,"^",3)
	.i code=Value d
	..w "<option value="_code_" selected>"_desc_"</option>"
	.e  d
	..w "<option value="_code_">"_desc_"</option>"
	w:(Requre="E")&&(Value="") "<option  value='' selected></option>"
	w:(Requre="E")&&(Value'="") "<option  value='' ></option>"
	w "</select>"
	q
}

/// 单选钮
ClassMethod SetRedio(ElementName, RealValue, DefaultValue, DicType)
{
	n (ElementName, RealValue, DefaultValue, DicType)
	q:ElementName=""
	s Value=$s(RealValue'="":RealValue,1:DefaultValue)
	s temp=##class(web.DHCMedDictoryCtl).GetByType(DicType,"Y")
	f Index=1:1:($l(temp,$c(1))-1) d
	.s s=$p(temp,$c(1),Index)
	.s code=$p(s,"^",2)
	.s desc=$p(s,"^",3)
	.i code=Value d
	..w "<INPUT type=radio name='"_ElementName_"' CHECKED>"_desc
	.e  d
	..w "<INPUT type=radio name='"_ElementName_"' >"_desc
    q
}

}
