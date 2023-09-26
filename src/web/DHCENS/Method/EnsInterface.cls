/// 类名：web.DHCENS.Method.DeleteEnsInterface
/// 描述：删除接口表中数据
/// 编写者：WuXianPu
/// 编写日期：2012-07-06
Class web.DHCENS.Method.EnsInterface Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod InsertEnsInterface(KeyName As %String, MethodType As %String, Input As %String, InputDesc As %String) As %String
{
	s $zt="Exception"
	s rowId=$o(^User.EnsInterfaceMethodI("MethodCode",MethodType,KeyName,""))
	s methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	if '$isobject(methodObj){
		q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		q "-1^方法未启用!"
	}
	s DateTimeString=$h
	s obj=##class(User.EnsInterface).%New()
	s obj.IntEventDesc=methodObj.methodDesc
	s obj.IntEventName=methodObj.methodCode
	s obj.IntInput=Input
	s obj.IntInputDesc=InputDesc
	s obj.IntInsDate=$p(DateTimeString,",",1)
	s obj.IntInsTime=$p(DateTimeString,",",2)
	s obj.IntKeyString=Input
	s sc=obj.%Save()
		
	if $$$ISOK(sc){
		s ret="0^成功"
	}
	else{
		s retContext=$SYSTEM.Status.GetErrorText(tSc)
		s retCode=$SYSTEM.Status.GetErrorCodes(tSc)
		s ret="-1^"_retCode_":"_retContext
	}	
	q ret
Exception
  	q -1_"^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2012-07-06
/// Description：删除接口表中数据
/// Table：
/// Input：
/// Return：0^成功
/// Others：w ##class(web.DHCENS.Method.DeleteEnsInterface).DeleteEnsInterface()
ClassMethod DeleteEnsInterface() As %String
{
	set IntDate=+$h-7
	&SQL(DELETE FROM SQLUSER.Ens_Interface WHERE Int_insDate<:IntDate)
	if (SQLCODE=0)
	{
		Quit "0^成功"
	}
	else
	{
		Quit "-1^失败"
	}
}

}
