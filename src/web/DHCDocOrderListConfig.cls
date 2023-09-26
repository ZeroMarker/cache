Class web.DHCDocOrderListConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Id(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_",key:true"
	s Str=Str_",sortable:false,multiboxonly:false"
	s Str=Str_",formoptions:{rowpos:19,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod StyleConfigStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderItemRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderARCIMRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderPriorRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderPrior(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPriorStr=$p(ExpStr,"^",1)
	i OrderPriorStr="" s OrderPriorStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{value:'"_$g(OrderPriorStr)_"',dataEvents:[{type:'change',fn:OrderPriorChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderMasterSeqNo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderMasterChangeHandler},{type:'keypress',fn:OrderSeqNokeydownhandler}]" 
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:1,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderName(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'keyup',fn:xItem_lookuphandler},{type:'dblclick',fn:xItem_lookuphandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderType(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	//s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderDoseQtykeydownhandler},{type:'keyup',fn:OrderDoseQtykeyuphandler},{type:'change',fn:OrderDoseQtychangehandler},{type:'focus',fn:OrdDoseQtyFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:2,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDoseUOMRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 剂量单位
ClassMethod OrderDoseUOM(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderDoseUOMchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:3,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod idoseqtystr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFreqRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 频次
ClassMethod OrderFreq(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:PHCFRDesc_lookuphandler},{type:'dblclick',fn:PHCFRDesc_lookuphandler},{type:'change',fn:FrequencyChangeHandler},{type:'focus',fn:FrequencyFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:3,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFreqFactor(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFreqInterval(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFreqDispTimeStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderInstrRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 用法
ClassMethod OrderInstr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:PHCINDesc_lookuphandler},{type:'dblclick',fn:PHCINDesc_lookuphandler},{type:'change',fn:InstrChangeHandler},{type:'focus',fn:InstrFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:4,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDurRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 疗程
ClassMethod OrderDur(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:PHCDUDesc_lookuphandler},{type:'dblclick',fn:PHCDUDesc_lookuphandler},{type:'change',fn:DurationChangeHandler},{type:'focus',fn:DurationFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:4,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDurFactor(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 单价
ClassMethod OrderPrice(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	/*s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:5,colpos:1}"
	s Str=Str_"}"
	q Str*/
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",editoptions:{"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPricechangehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:5,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// web.DHCDocOrderListConfig  数量
ClassMethod OrderPackQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderPackQtykeydownhandler},{type:'change',fn:OrderPackQtychangehandler},{type:'focus',fn:OrderPackQtyFocusHandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:5,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 数量单位
ClassMethod OrderPackUOMRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 数量单位
ClassMethod OrderPackUOM(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	/*
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",formoptions:{rowpos:6,colpos:1}"
	s Str=Str_"}"
	q Str
	*/
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPackUOMchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:6,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPackUOMStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 皮试
ClassMethod OrderSkinTest(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editoptions:{value:'Y:N',"
	s Str=Str_"dataEvents:[{type:'click',fn:OrderSkinTestChangehandler}]}"
	s Str=Str_",formoptions:{rowpos:6,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 附加说明
ClassMethod OrderPriorRemarks(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPriorRemarksStr=$p(ExpStr,"^",1)
	i OrderPriorRemarksStr="" s OrderPriorRemarksStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderPriorRemarksStr_"',"
	s Str=Str_"dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderPriorRemarkschangehandler}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderRecDepRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 接收科室
ClassMethod OrderRecDep(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	//s Str=Str_"sortable:false,"
	//s Str=Str_"edittype:'select',"
	s Str=Str_"edittype:'custom',"
	s Str=Str_"editoptions: {custom_element:CustomElement,custom_value:CustomValue,value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}"
	//s Str=Str_",dataEvents:[{type:'change',fn:OrderRecDepchangehandler}]
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:7,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod CurrentRecLocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 金额
ClassMethod OrderSum(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:8,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 处方号
ClassMethod OrderPrescNo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:8,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 备注
ClassMethod OrderDepProcNote(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:9,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 开医嘱人
ClassMethod OrderDoc(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	/*s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:9,colpos:2}"
	s Str=Str_"}"
	q Str*/
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderDocchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 录入人
ClassMethod OrderUserAdd(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:10,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 开医嘱科室
ClassMethod OrderUserDep(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:10,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 费别
ClassMethod OrderBillType(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s PrescriptTypeStr=$p(ExpStr,"^",1)
	i PrescriptTypeStr="" s PrescriptTypeStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_PrescriptTypeStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderBillTypechangehandler}]}"
	s Str=Str_",formoptions:{rowpos:11,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderBillTypeRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 开始日期 时间
ClassMethod OrderStartDate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions: {dataEvents:[{type:'click',fn:InitDatePicker},{type:'change',fn:OEORISttDatchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:11,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderEndDate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions: {dataEvents:[{type:'click',fn:InitDatePicker},{type:'change',fn:OrderEndDate_changehandler}]}"
	s Str=Str_",formoptions:{rowpos:12,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 首日次数
ClassMethod OrderFirstDayTimesOld(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderFirstDayTimeskeypresshandler},{type:'change',fn:OrderFirstDayTimeschangehandler},{type:'focus',fn:OrderFirstDayTimesFocusHandler}]"
	s Str=Str_"}"	
	s Str=Str_",formoptions:{rowpos:12,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 首日次数
ClassMethod OrderFirstDayTimes(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 首日次数字符串
ClassMethod OrderFirstDayTimesStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 首日次数
ClassMethod OrderFirstDayTimesCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	;s Str=Str_"dataEvents:[{type:'keypress',fn:OrderFirstDayTimeskeypresshandler},{type:'change',fn:OrderFirstDayTimeschangehandler},{type:'focus',fn:OrderFirstDayTimesFocusHandler}]"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderFirstDayTimeschangehandler}]"
	s Str=Str_"}"	
	s Str=Str_",formoptions:{rowpos:12,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 标本
ClassMethod OrderLabSpecRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 标本
ClassMethod OrderLabSpec(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderLabSpecchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:13,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 标本号
ClassMethod OrderLabEpisodeNo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"sortable:false,"
	s Str=Str_"editable:false,"
	s Str=Str_"formoptions:{rowpos:13,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 自动计算
ClassMethod OrderAutoCalculate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N'}"
	s Str=Str_",formoptions:{rowpos:14,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 医保
ClassMethod OrderCoverMainIns(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N'}"
	s Str=Str_",formoptions:{rowpos:14,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderInsurCatRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 医保分类
ClassMethod OrderInsurCat(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderInsurchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 医保分类串隐藏
ClassMethod OrderInsurCatHideen(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderActionRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 皮试备注
ClassMethod OrderAction(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderActionStr=$p(ExpStr,"^",1)
	if OrderActionStr="" s OrderActionStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderActionStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderActionchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:15,colpos:2}"	
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDIACatRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 诊断类别	
ClassMethod OrderDIACat(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderDIACatchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:16,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 部位说明
ClassMethod OrderBodyPart(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	
	s OrderBodyPartStr=$p(ExpStr,"^",1)
	if OrderBodyPartStr="" s OrderBodyPartStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderBodyPartStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderBodyPartchangehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:16,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderBodyPartID(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 输液流速
ClassMethod OrderSpeedFlowRate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:keypressisnumhandler},{type:'change',fn:OrderSpeedFlowRate_changehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:17,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFlowRateUnitRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 输液流速单位
ClassMethod OrderFlowRateUnit(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderFlowRateUnitStr=$p(ExpStr,"^",1)
	i OrderFlowRateUnitStr="" s OrderFlowRateUnitStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderFlowRateUnitStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderFlowRateUnitchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:17,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 需要配液
ClassMethod OrderNeedPIVAFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N',"
	s Str=Str_"dataEvents:[{type:'click',fn:OrderNeedPIVAFlagChangehandler}]"
	s Str=Str_"}"
	
	s Str=Str_",formoptions:{rowpos:18,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 抗生素用药原因
ClassMethod AntUseReason(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s AntUseReasonStr=$p(ExpStr,"^",1)
	if AntUseReasonStr="" s AntUseReasonStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_AntUseReasonStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:AntUseReasonchangehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:18,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod AntUseReasonRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 开医嘱日期
ClassMethod OrderDate(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions: {dataEvents:[{type:'click',fn:InitDatePicker},{type:'change',fn:OrderDate_changehandler}]}"
	s Str=Str_",formoptions:{rowpos:19,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderRecLocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderOutPriorRecLocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderOnePriorRecLocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderConFac(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPHForm(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPHPrescType(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderDrugFormRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderBaseQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderARCOSRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderMaxDurFactor(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderMaxQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderBaseQtySum(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFile1(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFile2(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFile3(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderLabExCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderAlertStockQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPoisonCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHiddenPara(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderGenericName(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderLabSpecStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod idiagnoscatstr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod RowDisableStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderPriorRemarksRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPriorStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 疗程超量原因
ClassMethod ExceedReasonID(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 疗程超量原因
ClassMethod ExceedReason(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s ExceedStr=$p(ExpStr,"^",1)
	i ExceedStr="" s ExceedStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(ExceedStr)_"',dataEvents:[{type:'change',fn:ExceedReasonChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:20,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 可用天数
ClassMethod OrderUsableDays(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text'"
	s Str=Str_",formoptions:{rowpos:20,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 输液次数
ClassMethod OrderLocalInfusionQty(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:keypressisnumhandler},{type:'change',fn:OrderLocalInfusionQty_changehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:21,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 医嘱阶段
ClassMethod OrderStage(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderStageStr=$p(ExpStr,"^",1)
	if OrderStageStr="" s OrderStageStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:'"_OrderStageStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderStagechangehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:21,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderStageCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 高值材料条码
ClassMethod OrderMaterialBarcode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"editoptions:{"
	s Str=Str_"dataEvents:[{type:'keypress',fn:OrderMaterialBarcode_Keypresshandler},{type:'change',fn:OrderMaterialBarcode_changehandler}]"
	s Str=Str_"}"
	s Str=Str_",formoptions:{rowpos:22,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderMaterialBarcodeHiden(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// LinkedMasterOrderRowid  
ClassMethod LinkedMasterOrderRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// LinkedMasterOrderSeqNo
ClassMethod LinkedMasterOrderSeqNo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// ShowTabStr
ClassMethod ShowTabStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
    s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
    q Str
}

/// UserReasonId  抗生素使用目的ID
ClassMethod UserReasonId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
    s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
    q Str
}

/// OrderAntibApplyRowid   抗生素申请单ID
ClassMethod OrderAntibApplyRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
    s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
    q Str
}

/// 加急
ClassMethod OrderUrgent(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N',dataEvents:[{type:'change',fn:OrderUrgentchangehandler}]},"
	s Str=Str_"formoptions:{rowpos:6,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 科研列表
ClassMethod OrderPilotPro(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrderPilotProStr=$p(ExpStr,"^",1)
	if OrderPilotProStr="" s OrderPilotProStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {"
	s Str=Str_"value:'"_OrderPilotProStr_"',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}"
	;s Str=Str_"dataEvents:[{type:'change',fn:OrderStagechangehandler}]"
	s Str=Str_"},"
	s Str=Str_"formoptions:{rowpos:22,colpos:1}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPilotProRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
    q Str
}

/// OrderSelfOMFlag 患者自备
ClassMethod OrderSelfOMFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N',"
	s Str=Str_"dataEvents:[{type:'click',fn:OrderSelfOMFlagChangehandler}]}"
	s Str=Str_",formoptions:{rowpos:6,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 药品外购标识
ClassMethod OrderOutsourcingFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N'}"
	s Str=Str_",formoptions:{rowpos:6,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// SpecialAction 抗菌药物特殊动作 update by shp
ClassMethod SpecialAction(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
    s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
    q Str
}

ClassMethod OrderBindSource(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrdCateGoryRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrdCateGory(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s OrdCateGoryStr=$p(ExpStr,"^",1)
	i OrdCateGoryStr="" s OrdCateGoryStr=":"
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions:{value:'"_$g(OrdCateGoryStr)_"',dataEvents:[{type:'change',fn:OrdCateGoryChange}],dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");}}"
	s Str=Str_",formoptions:{rowpos:1,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 手术列表 
ClassMethod OrderOperation(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderOperationchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderOperationCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPoisonRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderMKMsg(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:false,"
	s Str=Str_"edittype:'text',"
	s Str=Str_"formoptions:{rowpos:22,colpos:1},formatter:OrderMKLightShow"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderMonitorId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderNurseLinkOrderRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderBodyPartLabel(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderCPWStepItemRowId(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderItemCongeries(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

/// 开医嘱科室
ClassMethod OrderLogDep(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",sortable:false"
	s Str=Str_",formoptions:{rowpos:10,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod AnaesthesiaID(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderOperationStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderFreqTimeDoseStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderPkgOrderNo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderHolidayRecLocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 开医嘱医生
ClassMethod OrderDocRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 开医嘱医生串
ClassMethod OrderDocStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 虚拟长期
ClassMethod OrderVirtualtLong(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"align:'center',"
	s Str=Str_"sortable:false,"
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'checkbox',"
	s Str=Str_"editoptions:{value:'Y:N',"
	s Str=Str_"dataEvents:[{type:'click',fn:OrderVirtualtLongClickhandler}]}"
	s Str=Str_",formoptions:{rowpos:6,colpos:2}"
	s Str=Str_"}"
	q Str
}

/// 慢病病种
ClassMethod OrderChronicDiag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderChronicDiagchangehandler}]}"
	s Str=Str_",formoptions:{rowpos:7,colpos:2}"
	s Str=Str_"}"
	q Str
}

ClassMethod OrderChronicDiagCode(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderChronicDiagStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

/// 标本采集部位
ClassMethod OrderLabSpecCollectionSite(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_","
	s Str=Str_"editable:true,"
	s Str=Str_"sortable:false,"
	s Str=Str_"edittype:'select',"
	s Str=Str_"editoptions: {value:' : ',dataInit: function(elem) {$(elem).width("_$g(ColCFAry("wid"))_");},"
	s Str=Str_"dataEvents:[{type:'change',fn:OrderLabSpecCollectionSitechangehandler}]}"
	s Str=Str_",formoptions:{rowpos:13,colpos:1}"
	s Str=Str_"}"
	q Str
}

/// 标本采集部位
ClassMethod OrderLabSpecCollectionSiteRowid(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderLabSpecCollectionSiteStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderNurseExecLinkDispTimeStr(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_"}"
	q Str
}

ClassMethod OrderSerialNum(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderAppendInfo(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",align:'center'}"
	q Str
}

ClassMethod OrderSignFlag(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))_"}"
	q Str
}

ClassMethod OrderOperatBtn(SessionStr As %String, ByRef ColCFAry As %String, ExpStr As %String = "") As %String
{
	s Str="{name:'"_$g(ColCFAry("name"))_"',index:'"_$g(ColCFAry("name"))_"', width:"_$g(ColCFAry("wid"))_",hidden:"_$g(ColCFAry("isHidden"))
	s Str=Str_",align:'left'}"
	q Str
}

}
