Class DHCEPRFS.Util.DateFormatUtil Extends %RegisteredObject
{

/// Desc: 根据系统配置的日期格式，把日期转换为标准格式：yyyy-MM-dd
/// Input: datebox返回的值
ClassMethod DateToNormalFormat(date As %String) As %String
{
	
	/// 1 MM/DD/YYYY  3 YYYY-MM-DD  4 DD/MM/YYYY
	s format = ##class(websys.Conversions).DateFormat()
	q:(format="1") $P(date,"/",3)_"-"_$P(date,"/",1)_"-"_$P(date,"/",2)
	q:(format="4") $P(date,"/",3)_"-"_$P(date,"/",2)_"-"_$P(date,"/",1)
	q date
}

}
