Import SQLUser

/// 创建时间		：2006.06.07
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		：
/// 主要功能		：导入基础数据
/// 最后修改时间	：
/// 最后修改人	：
/// 完成
Class web.DHCPE.DHCPEIMPBaseData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 57;

/// w ##class(web.DHCPE.DHCPEIMPBaseData).OpenFile("\TrakCare\qqq.TXT","test")
ClassMethod OpenFile(File As %String, Node As %String)
{
	k ^xwmTemp("IMP")
	s $zt="close^"_$zn
 	w "File Upload Starting...",!
 	o File:"RS":2
 	u File
 	
 	f  d
 	.r sRec
 	.s num=+$g(^xwmTemp("IMP", $zn,Node,0))+1
 	.s ^xwmTemp("IMP", $zn, Node, 0)=num
 	.s ^xwmTemp("IMP", $zn,Node,num)=$tr(sRec,$c(4),"^")
 	c File

 	w "File Upload Finished!",!!
 	q "C"
}

/// 导入站点
/// ##class(web.DHCPE.DHCPEIMPBaseData).IMPStation("D:\qqq.txt")
ClassMethod IMPStation(DataFile As %String)
{
}

Storage Default
{
<Data name="DHCPEIMPBaseDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.DHCPEIMPBaseDataD</DataLocation>
<DefaultData>DHCPEIMPBaseDataDefaultData</DefaultData>
<IdLocation>^web.DHCP.DHCPEIMPBaseDataD</IdLocation>
<IndexLocation>^web.DHCP.DHCPEIMPBaseDataI</IndexLocation>
<StreamLocation>^web.DHCP.DHCPEIMPBaseDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
