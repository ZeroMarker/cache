/// 名称: DHCHAI.ClassMethodService
/// 描述: 运行类方法
Class DHCHAI.ClassMethodService Extends (DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod RunClassMethod(ClassName, MethodName, Arg...)
{
	 Set ret=$ZOBJCLASSMETHOD(ClassName,MethodName,Arg...)
     Quit ret
}

}
