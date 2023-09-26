/// 名称: DHCHAI.Utils.ToJSON（参考：ext.util.JsonObject、%DynamicObject）
/// 描述: 解析json对象为json串
/// 编写者：zhufei
/// 编写日期: 2017-10-26
Class DHCHAI.Utils.ToJSON Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock ]
{

Property Data As %String(MAXLEN = "") [ MultiDimensional ];

Property Keys As %List;

Method %Set(key As %String, element As %String) As ToJSON
{
	Set %this.Keys=%this.Keys_$lb(key)
	Kill i%Data(key)
	Set i%Data(key)=element
	Quit %this
}

Method %ToJSON() As %String
{
	Set json=""
	Set Keys=%this.Keys
	For indKey=1:1:$listlength(Keys){
		Set key=$listget(Keys,indKey)
		Continue:key=""
		Set value=$g(i%Data(key))
		Set key=..evalChar(key)
		Set key=""""_key_""""
		Set value=..evalChar(value)
		Set value=""""_value_""""
		If json="" {
			Set json=key_":"_value
		} Else {
			Set json=json_","_key_":"_value
		}
	}
	Set json="{"_json_"}"
	Quit json
}

/// 对JSON数据字符特殊字符处理
ClassMethod evalChar(instr As %String) As %String
{
	Quit:(instr="") instr
	
	//特殊字符处理
	//Set instr = $ZCVT(instr,"O","JSON")
	Set instr = ..Replace(instr, $c(0), "\u0000")
	Set instr = ..Replace(instr, $c(1), "\u0001")
	Set instr = ..Replace(instr, $c(2), "\u0002")
	Set instr = ..Replace(instr, $c(3), "\u0003")
	Set instr = ..Replace(instr, $c(4), "\u0004")
	Set instr = ..Replace(instr, $c(5), "\u0005")
	Set instr = ..Replace(instr, $c(6), "\u0006")
	Set instr = ..Replace(instr, $c(7), "\u0007")
	Set instr = ..Replace(instr, $c(8), "\b")      //Backspace
	Set instr = ..Replace(instr, $c(9), "\t")      //Tab 空白
	Set instr = ..Replace(instr, $c(10), "\n")     //换行
	Set instr = ..Replace(instr, $c(11), "\u000b")
	Set instr = ..Replace(instr, $c(12), "\f")     //换页 空白
	Set instr = ..Replace(instr, $c(13), "\r")     //回车
	Set instr = ..Replace(instr, $c(14), "\u000e")
	Set instr = ..Replace(instr, $c(15), "\u000f")
	Set instr = ..Replace(instr, $c(16), "\u0010")
	Set instr = ..Replace(instr, $c(17), "\u0011")
	Set instr = ..Replace(instr, $c(18), "\u0012")
	Set instr = ..Replace(instr, $c(19), "\u0013")
	Set instr = ..Replace(instr, $c(20), "\u0014")
	Set instr = ..Replace(instr, $c(21), "\u0015")
	Set instr = ..Replace(instr, $c(22), "\u0016")
	Set instr = ..Replace(instr, $c(23), "\u0017")
	Set instr = ..Replace(instr, $c(24), "\u0018")
	Set instr = ..Replace(instr, $c(25), "\u0019")
	Set instr = ..Replace(instr, $c(26), "\u001a")
	Set instr = ..Replace(instr, $c(27), "\u001b")
	Set instr = ..Replace(instr, $c(28), "\u001c")
	Set instr = ..Replace(instr, $c(29), "\u001d")
	Set instr = ..Replace(instr, $c(30), "\u001e")
	Set instr = ..Replace(instr, $c(31), "\u001f")
	Set instr = ..Replace(instr, "\", "\\")
	Set instr = ..Replace(instr, """", "\""")
	Quit instr
}

ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	Quit ##class(DHCHAI.Utils.CommonSrv).Replace(instr,substr,replacement)
}

/// Do ##Class(DHCHAI.Utils.ToJSON).Test()
ClassMethod Test()
{
	New
	
	Set aaa=""
	For i=0:1:127 {
		Set aaa=aaa_$c(i)
	}
	
	//%DynamicObject
	Set objDynamic=##class(%DynamicObject).%New()
	Set objDynamic=objDynamic.%Set("Doc_Title",aaa)
	Set objDynamic=objDynamic.%Set("Patient_Id'",222)
	Set objDynamic=objDynamic.%Set("Hospital_Id",333)
	Set objDynamic=objDynamic.%Set("Doc_Content",444)
	Set objDynamic=objDynamic.%Set("NULL","NULL")
	Set objDynamic=objDynamic.%Set("TRUE","TRUE")
	Set objDynamic=objDynamic.%Set("FALSE","FALSE")
   	Set json=objDynamic.%ToJSON()
	Write json,!
	
	//DHCHAI.Utils.ToJSON
	Set objToJSON=##Class(DHCHAI.Utils.ToJSON).%New()
	Set objToJSON=objToJSON.%Set("Doc_Title",aaa)
	Set objToJSON=objToJSON.%Set("Patient_Id'",222)
	Set objToJSON=objToJSON.%Set("Hospital_Id",333)
	Set objToJSON=objToJSON.%Set("Doc_Content",444)
	Set objToJSON=objToJSON.%Set("NULL","NULL")
	Set objToJSON=objToJSON.%Set("TRUE","TRUE")
	Set objToJSON=objToJSON.%Set("FALSE","FALSE")
	Set json=objToJSON.%ToJSON()
	Write json,!
	
	Quit
}

}
