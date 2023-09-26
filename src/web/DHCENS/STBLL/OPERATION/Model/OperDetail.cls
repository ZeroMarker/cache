Class web.DHCENS.STBLL.OPERATION.Model.OperDetail Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OPERATIONS";

/// 手术编号
Property OPERATIONNO As %Library.String(MAXLEN = 20, XMLNAME = "OPERATION_NO");

/// 手术名称
Property OPERATION As %Library.String(MAXLEN = 50, XMLNAME = "OPERATION_Name");

/// 手术代码
Property OPERATIONCODE As %Library.String(MAXLEN = 20, XMLNAME = "OPERATION_CODE");

/// 手术级别
Property OPERATIONSCALE As %Library.String(MAXLEN = 20, XMLNAME = "OPERATION_SCALE");

/// 手术部位
Property OPERATIONPositionCode As %Library.String(MAXLEN = 20, XMLNAME = "OPERATION_PositionCode");

/// 手术切口  OPERATION_CutType
Property OPERATIONCutType As %Library.String(MAXLEN = 20, XMLNAME = "OPERATION_CutType");

}
