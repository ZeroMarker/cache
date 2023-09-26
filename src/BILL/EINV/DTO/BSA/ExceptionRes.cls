Class BILL.EINV.DTO.BSA.ExceptionRes Extends %RegisteredObject
{

///  返回结果标识
Property result As %String(CAPTION = "返回结果标识", TRUNCATE = 1, XMLNAME = "result");

/// 返回结果内容
Property message As %String(CAPTION = "返回结果内容", XMLNAME = "message");

}
