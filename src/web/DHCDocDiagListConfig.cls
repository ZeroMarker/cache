Class web.DHCDocDiagListConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Id(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",key:true"_",align:'center'"
	s Str=Str_",formoptions:{rowpos:19,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod MRDIAMRDIADR(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

// 诊断表ID

ClassMethod MRCIDRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

// ICD表ID

ClassMethod MRDIARowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

// 诊断分类

ClassMethod DiagnosCat(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s DiagnosCatStr=$p(ExpStr,"^",1)
	i DiagnosCatStr="" s DiagnosCatStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(DiagnosCatStr)_"',dataEvents:[{type:'change',fn:DiagnosCatChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 诊断类型

ClassMethod DiagnosType(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s DiagnosTypeStr=$p(ExpStr,"^",1)
	i DiagnosTypeStr="" s DiagnosTypeStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(DiagnosTypeStr)_"',dataEvents:[{type:'change',fn:DiagnosTypeChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 诊断级别 

ClassMethod DiagnosLeavel(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"
	s Str=Str_",formoptions:{rowpos:10,colpos:1}"
	s Str=Str_"}"
	q Str
}

// ICD描述

ClassMethod DiagnosICDDesc(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	//s Str=Str_"formatter:DiagDescTooltip,"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");$(elem).height("_"26"_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:DiagnosICDDesc_keydown}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 主诊断

ClassMethod MainDiagFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s MainDiagFlagStr=$p(ExpStr,"^",1)
	i MainDiagFlagStr="" s MainDiagFlagStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(MainDiagFlagStr)_"',dataEvents:[],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 诊断注释

ClassMethod DiagnosNotes(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:DiagnosNotes_keydown}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

// ICD代码

ClassMethod MRCIDCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:5,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 诊断状态

ClassMethod DiagnosStatus(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s DiagnosStatusStr=$p(ExpStr,"^",1)
	i DiagnosStatusStr="" s DiagnosStatusStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_DiagnosStatusStr_"',"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:DiagnosStatusChange}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 发病日期

ClassMethod DiagnosOnsetDate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "")
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions: {dataEvents:[{type:'click',fn:InitDatePicker}]}"
	s Str=Str_",formoptions:{rowpos:11,colpos:2}"
	s Str=Str_"}"
	q Str
	//,{type:'change',fn:DiagnosOnsetDateChange}
}

// 诊断日期

ClassMethod DiagnosDate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "")
{
	/*s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:11,colpos:2}"
	s Str=Str_"}"
	q Str*/
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions: {dataEvents:[{type:'click',fn:InitDatePicker}]}"
	s Str=Str_",formoptions:{rowpos:11,colpos:2}"
	s Str=Str_"}"
	q Str
}

// 诊断状态

ClassMethod DiagnosStatusRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_"}"
	q Str
}

// 诊断类型

ClassMethod DiagnosTypeRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_"}"
	q Str
}

// 诊断分类

ClassMethod DiagnosCatRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_"}"
	q Str
}

// 证型

ClassMethod SyndromeDesc(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	/*s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");$(elem).height("_"26"_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:SyndromeDesc_keydown}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str*/
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",formoptions:{rowpos:2,colpos:1},formatter:SyndromeDescFormatter"
	s Str=Str_"}"
	q Str
	/*s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:11,colpos:2}"
	s Str=Str_"}"
	q Str*/
}

// 证型ID

ClassMethod SyndromeRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

// 部位

ClassMethod DiagnosBodyPart(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s BodyPartStr=$p(ExpStr,"^",1)
	i BodyPartStr="" s BodyPartStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(BodyPartStr)_"',dataEvents:[{type:'change',fn:DiagnosBodyPartChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 部位

ClassMethod DiagnosBodyPartId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod DiagnosDoctor(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 长效诊断

ClassMethod LongDiagnosFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s DiagnosStatusStr=$p(ExpStr,"^",1)
	i DiagnosStatusStr="" s DiagnosStatusStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",align:'center'"_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_DiagnosStatusStr_"',"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:LongDiagnosFlagChange}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 长效诊断

ClassMethod LongDiagnosFlagRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

// 诊断前缀

ClassMethod DiagnosPrefix(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	Q:##class(web.DHCDocDiagnosEntryV8).GetSDSDiagEntryFlag(%session.Data("LOGON.CTLOCID")) ""
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:DiagnosPrefix_keydown}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 结构化诊断信息
ClassMethod SDSInfo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 结构化诊断描述
ClassMethod SDSDesc(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	Q:'##class(web.DHCDocDiagnosEntryV8).GetSDSDiagEntryFlag(%session.Data("LOGON.CTLOCID")) ""
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 国家医保诊断名称

ClassMethod DiagInsuName(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:5,colpos:1}"
	s Str=Str_"}"
	q Str
}

// 国家医保诊断编码

ClassMethod DiagInsuCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:5,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod TCMTreatmentID(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod TCMTreatment(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");$(elem).height("_"26"_");}"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod AddUserDr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod DiagnosUserDr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

}
