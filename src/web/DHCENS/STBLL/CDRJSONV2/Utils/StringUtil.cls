Class web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil Extends (%RegisteredObject, %XML.Adaptor)
{

/// 历史数据数据导出terminal提示
ClassMethod point(strpatRowId, endpatRowId, con, RowId) As %String
{
	set $zt="Exception"
	set sum=(+endpatRowId)-(+strpatRowId)+1
	set now=(+endpatRowId)-(+RowId)
	set percentage=$fn((1-(now/sum))*100,"",0)_"%"
	i con#100=0 w "count:"_con_"    id:"_RowId_"   "_percentage,!
	q 0
Exception
	quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2014—04-17
/// Description：导出工程下所有类文件到指定路径
/// Table：
/// Input：package:保存路径,input:工程名称
/// Return："1^"_返回应导出文件个数
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).ExportClass("D:\work\mediwaygitlab\hdcv2-cache\release_v2.3.02\HIS\","HDC2")
ClassMethod ExportClass(package As %String, input As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New("%Studio.Project:ProjectItemsList")
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(input)
	set rowData="",i=0	
	for  q:rs.Next()=0  d
	.set name=rs.GetData(2)
	.set type=rs.GetData(3)
	.if type'="CLS" d
	..set className=name
	.e  d
	..set className=name_"."_type
	.set sc=##class(%File).Exists(package_name_".xml")
	.if sc d
	..set sc=##class(%File).Delete(package_name_".xml")
	.set sc=$SYSTEM.OBJ.Export(className,package_name_".xml","","UTF8")
	.set i=i+1
	Quit "1^"_i
Exception
	Quit "-1^"_$ze
}

}
