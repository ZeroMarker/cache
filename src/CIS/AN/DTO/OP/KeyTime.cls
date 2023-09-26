Class CIS.AN.DTO.OP.KeyTime Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "KeyTime";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property Code As %String;

/// 描述
Property Description As %String;

/// 日期（yyyy-MM-dd）
Property Date As %String;

/// 时间（HH:mm:ss）
Property Time As %String;

/// 备注
Property Note As %String;

/// 构造一个实例
ClassMethod Construct(timeStamp As %String, code As %String) As CIS.AN.DTO.OP.KeyTime
{
	set instance=##class(CIS.AN.DTO.OP.KeyTime).%New()
	set instance.Code=code
	set instance.Description=$case(code,"AreaIn":"入手术室","RoomIn":"入手术间","AnaStart":"麻醉开始","TubeIn":"插管","OperStart":"手术开始","OperEnd":"手术结束","TubeOut":"拔管","AnaEnd":"麻醉结束","RoomOut":"出手术间","PACUIn":"入恢复室","PACUOut":"出恢复室","AreaOut":"出手术室")
	set instance.Date=$p(timeStamp," ",1)
	set instance.Time=$p(timeStamp," ",2)
	set instance.Note=""
	
	quit instance
}

Method ToDateTime() As %String
{
	set list=""
	if ##this.Date'=""
	{
		set list=$lb(##this.Date)
		if ##this.Time'="" set list=list_$lb(##this.Time)
		else  set list=list_$lb("00:00:00")
	}
	quit $LISTTOSTRING(list," ")
}

}
