Class CIS.AN.DTO.OP.Procedure Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Procedure";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 手术申请Id
Property ApplicationID As %String(TRUNCATE = 1);

/// 过程代码
Property Code As %String;

/// 过程描述
Property Description As %String;

/// 操作日期
Property Date As %String;

/// 操作时间
Property Time As %String;

/// 操作人ID
Property UserID As %String;

/// 操作人
Property User As %String;

/// 操作代码
Property ActionCode As %String;

/// 操作
Property Action As %String;

/// 说明
Property Note As %String(MAXLEN = 200);

/// 顺序
Property Seq As %String;

Method Validate(ByRef message As %String) As %Boolean
{
	set valid=1
	
	if ##this.ApplicationID=""
	{
		set valid=0,message="ApplicationID can not be null!"
	}
	elseif ##this.Code=""
	{
		set valid=0,message="Code can not be null!"
	}
	
	quit valid
}

}
