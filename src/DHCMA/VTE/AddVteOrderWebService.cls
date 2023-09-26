/// DHCMA.VTE.AddVteOrderWebService
Class DHCMA.VTE.AddVteOrderWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "AddVteOrderWebService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:VTE系统调用该方法 把医嘱插入医嘱界面审核列表
/// Input:  EpisodeID:就诊ID,必填项;LocDr:使用科室ID(CT_Loc),非必填，指定使用科室时传入;UserDr:使用用户ID(SS_User),非必填，指定使用用户时传入;
///         OrderList +=(i+1)+"^"+orderIdArr[i]+"^^^^^^^^S/NORM^^N^^^^"+"θ"; 由于$c(1)这个字符在java里面无法拼接而且webservices无法传输 使用θ 然后再在这里转成$c(1)
///         序号:非关联医嘱为自增,关联医嘱的子医嘱为[主医嘱序号.子医嘱序号]。例如序号1有两条子医嘱，第一条子医嘱为1.1，第二条子医嘱为1.2；第二组医嘱的序号分别为2，2.1，2.2
/// Return: 0：成功 其他：失败
Method AddVteOrder(EpisodeID As %String, LocDr As %String, UserDr As %String, OrderList As %String) As %String [ WebMethod ]
{
	Set listLength=$L(OrderList,"#")
	Set CopyItemList = ""
	For i=1:1:listLength{
		s OneOrderStr=$P(OrderList,"#",i)
		continue:(OneOrderStr="")
		//把VTE传过来的优先级S/NORM 转成数字
		//取长期医嘱优先级代码 $O(^OECPR(0,"Code","S",0))
		//取临时医嘱优先级代码 $O(^OECPR(0,"Code","NORM",0))
		s priority = $p(OneOrderStr,"^",10)
		s $p(OneOrderStr,"^",10) = $O(^OECPR(0,"Code",priority,0))
		s CopyItemList = CopyItemList_OneOrderStr_$c(1) 
	}
	Set result = ##class(DHCDoc.Interface.Inside.Service).InsertCopyItem(EpisodeID,LocDr,UserDr,CopyItemList)
	Quit result
}

}
