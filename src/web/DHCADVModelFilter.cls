/// zhouxin
/// 2019-06-12
/// 不良事件统计用到的过滤器
Class web.DHCADVModelFilter Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 判断表单是否填写某字典
/// w ##class(web.DHCADVModelFilter).CheckIncludeDic(1)
ClassMethod CheckIncludeDic(recordId, dicCodeStr)
{
    n (recordId, dicCodeStr)
	s ret=0
	
	f i=1:1:$l(dicCodeStr,"^") d
	.s dicCode=$p(dicCodeStr,"^",i)
	.q:dicCode=""
	.s dic=+$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCAdvAction).ALPHAUP(dicCode),""))
	.q:dic=0 
	.s formid="" f  s formid=$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid)) q:formid=""  d
	..s:+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,dic,""))'=0 ret=1
 	q ret
}

/// 过滤不是跌倒数据统计
/// w ##class(web.DHCADVModelFilter).CheckFall(1)
ClassMethod CheckFall(recordId)
{
	n (recordId)
	s fallCode="NurEventType-93967"
 	q ##class(web.DHCADVModelFilter).CheckIncludeDic(recordId,fallCode)
}

/// 过滤报表里维护的报表过滤条件
/// w ##class(web.DHCADVModelFilter).CheckModelFilter(1)
ClassMethod CheckModelFilter(model, recordId)
{
	n (model, recordId)
	s FilterClass=$p(^DHCADVMODEL(model),"^",4)
    s FilterFunc=$p(^DHCADVMODEL(model),"^",5)
    q:FilterClass="" 1
    q:FilterFunc="" 1
    s filterFlag=$classmethod(FilterClass,FilterFunc,recordId)
	q filterFlag
}

}
