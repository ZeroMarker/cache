/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 表格列配置
Class DHCDoc.Chemo.COM.ColConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 序号
ClassMethod Id(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",key:true,frozen:true"
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:19,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 项目ID
ClassMethod TplGroupItemId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 化疗项目ID
ClassMethod PGIId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 单位体表面积浓度
ClassMethod BSAUnit(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:BSAUnitkeydownhandler},{type:'keyup',fn:BSAUnitkeyuphandler},{type:'change',fn:BSAUnitchangehandler},{type:'focus',fn:BSAUnitFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'keyup',fn:BSAUnitkeyuphandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 计算公式
ClassMethod FormulaOld(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 计算公式
ClassMethod Formula(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderFlowRateUnitStr=$p(ExpStr,"^",1)
	i OrderFlowRateUnitStr="" s OrderFlowRateUnitStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderFlowRateUnitStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:Formulachangehandler}]}"
	s Str=Str_",formoptions:{rowpos:17,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 外院剂量
ClassMethod HospDose(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:BSAUnitkeydownhandler},{type:'keyup',fn:BSAUnitkeyuphandler},{type:'change',fn:BSAUnitchangehandler},{type:'focus',fn:BSAUnitFocusHandler}]"
	//s Str=Str_"dataEvents:[{type:'keyup',fn:BSAUnitkeyuphandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 外院记录ID
ClassMethod HDID(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderDoseQtyOLd(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'keyup',fn:OrderDoseQtykeyuphandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 厂家
ClassMethod ManuFactor(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 标准值
ClassMethod BSAUnitSTD(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 成组符号
ClassMethod LinkSymbol(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 化疗组类型
ClassMethod GroupTypeOld(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderFlowRateUnitStr=$p(ExpStr,"^",1)
	i OrderFlowRateUnitStr="" s OrderFlowRateUnitStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderFlowRateUnitStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:GroupTypechangehandler}]}"
	s Str=Str_",formoptions:{rowpos:17,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod GroupType(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:4,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 组类型ID
ClassMethod GroupTypeId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 是否主药
ClassMethod MainDrug(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderFlowRateUnitStr=$p(ExpStr,"^",1)
	i OrderFlowRateUnitStr="" s OrderFlowRateUnitStr=":;Y:Y"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderFlowRateUnitStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:MainDrugchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:17,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 日期
ClassMethod ChemoDays(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// OeoriDR
ClassMethod OeoriDR(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// OeoriDR
ClassMethod InitDosage(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 单次剂量
ClassMethod OrderDoseQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	//s Str=Str_"formatter:function(cellvalue, options, rowObject){if (rowObject.OrderDoseQty>rowObject.InitDosage) {return ""<span class='red'>""+cellvalue+""</span>""}else if (rowObject.OrderDoseQty<rowObject.InitDosage) { ""<span class='blue'>""+cellvalue+""</span>""} else {return cellvalue};},"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 预览单次剂量
ClassMethod OrderDoseQtyNurese(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"formatter:function(cellvalue, options, rowObject){if (rowObject.InitDosage=='') {return cellvalue} else if (rowObject.OrderDoseQty>rowObject.InitDosage) { return ""<span class='red'>""+cellvalue+""</span>""} else if (rowObject.OrderDoseQty<rowObject.InitDosage) { return ""<span class='blue'>""+cellvalue+""</span>""} else {return cellvalue};},"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 接收科室
ClassMethod OrderRecDep(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderRecDepchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:2}"
	s Str=Str_"}"
	q Str
}

}
