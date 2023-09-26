Class web.DHCENS.STBLL.REGISTER.MODEL.RegisteredServiceSOAPFunction Extends (%RegisteredObject, %XML.Adaptor)
{

/// 服务代码
Property ServiceCode As %Library.String(MAXLEN = 20);

/// 方法代码
Property MethodCode As %Library.String(MAXLEN = 20);

/// 参数代码
Property ParameterCode As %Library.String(MAXLEN = 20);

/// 功能代码
Property FunctionCode As %Library.String(MAXLEN = 20);

/// 功能描述
Property FunctionDesc As %Library.String(MAXLEN = 200);

/// 更新日期
Property UpdateDate As %Library.Date;

/// 更新时间 
Property UpdateTime As %Library.Time;

/// 功能状态
Property Status As %Library.String(MAXLEN = 20);

}
