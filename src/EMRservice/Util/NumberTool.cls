/// 名称:	EMRservice.Util.NumberTool
/// 描述:	数字处理工具类
/// 编写者:	yejian
/// 编写日期: 	2022-12-2
/// 产品组：	电子病历产品组
Class EMRservice.Util.NumberTool Extends %RegisteredObject
{

/// Desc:		自动左侧补0
/// Creator:     yejian
/// CreateDate:  2022-12-2
/// Input:      target 传入值
/// 			num 返回的位数
/// Output:     返回格式0001
/// Debug:	w ##class(EMRservice.Util.NumberTool).ZeroPadding(12,4)
ClassMethod ZeroPadding(target, num)
{
    q $tr($j(target, num), " ", "0")
}

/// Desc:		根据日期生成顺序递增的唯一编码
/// Creator:     yejian
/// CreateDate:  2022-12-2
/// Input:      
/// Output:     返回格式202212020001
/// Debug:	w ##class(EMRservice.Util.NumberTool).GetUniqueCodeByDate()
ClassMethod GetUniqueCodeByDate() As %String
{
	s strRes = ""
	s curData = $zd($h,8)
	s oldData = $g(^Tempc0)
	if (curData=oldData)
	{
		s numb = $i(^Tempc1)
		s numb = ##class(EMRservice.Util.NumberTool).ZeroPadding(numb,4)
		s strRes = curData_numb
	}
	else
	{
		s ^Tempc0 =curData
		s ^Tempc1 =0
		s numb = $i(^Tempc1)
		s numb = ##class(EMRservice.Util.NumberTool).ZeroPadding(numb,4)
		s strRes = curData_numb
	}
	q strRes
}

}
