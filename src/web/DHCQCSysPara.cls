/// 质控系统基础参数设置
/// 保存到临时Global里面。
Class web.DHCQCSysPara Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20130125
/// Description:： 获得系统默认参数
/// Table：       
/// Input：        NameSpaceString:LIS,HIS名字空间
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// d ##Class(web.DHCQCSysPara).SaveDefaultNameSpace("")
ClassMethod SaveDefaultNameSpace(NameSpaceString As %String, UserId As %String) As %String
{
	Set NameSpaceString=$Get(NameSpaceString),UserId=$Get(UserId)
	If $Length(NameSpaceString)<1 Quit "输入信息为空！"
	If $Length(UserId)<1 Quit "用户代码不能为空！"
	Set LABDATA=$Piece(NameSpaceString,"^",1)
	Set HISNameSpace=$Piece(NameSpaceString,"^",2)
	Set HISDataNameSpace=$Piece(NameSpaceString,"^",3)
	If $Data(^DHCQCSYSParameter(UserId,1)) Do
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",1)=LABDATA
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",2)=HISNameSpace
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",6)=HISDataNameSpace
	.If $Length(LABDATA) Set $Piece(^DHCQCSYSParameter(1),"^",1)=LABDATA
	.If $Length(HISNameSpace) Set $Piece(^DHCQCSYSParameter(1),"^",2)=HISNameSpace
	.If $Length(HISDataNameSpace) Set $Piece(^DHCQCSYSParameter(1),"^",6)=HISDataNameSpace
	Else  Do
	.Set ^DHCQCSYSParameter(UserId,1)="^^^^^^^^^^^"
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",1)=LABDATA
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",2)=HISNameSpace
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",6)=HISDataNameSpace
	.If $Length(LABDATA) Set $Piece(^DHCQCSYSParameter(1),"^",1)=LABDATA
	.If $Length(HISNameSpace) Set $Piece(^DHCQCSYSParameter(1),"^",2)=HISNameSpace
	.If $Length(HISDataNameSpace) Set $Piece(^DHCQCSYSParameter(1),"^",6)=HISDataNameSpace
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20130125
/// Description:： 获得系统默认参数
/// Table：       
/// Input：        DeptMach:科室,仪器名字空间
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// d ##Class(web.DHCQCSysPara).SaveDefaultNameSpace("")
ClassMethod SaveDefaultDeptMachine(DeptMach As %String, UserId As %String) As %String
{
	Set DeptMach=$Get(DeptMach)
	If $Length(DeptMach)<1 Quit "输入信息为空！"
	If $Length(UserId)<1 Quit "用户代码不能为空！"
	Set DeptCode=$Piece(DeptMach,"^",1)
	Set MachineCode=$Piece(DeptMach,"^",2)
	If $Data(^DHCQCSYSParameter(UserId,1)) Do
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",3)=DeptCode
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",4)=MachineCode
	.Set $Piece(^DHCQCSYSParameter(1),"^",3)=""
	.Set $Piece(^DHCQCSYSParameter(1),"^",4)=""
	Else  Do
	.Set ^DHCQCSYSParameter(UserId,1)=""
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",3)=DeptCode
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",4)=MachineCode 
	.Set $Piece(^DHCQCSYSParameter(1),"^",3)=""
	.Set $Piece(^DHCQCSYSParameter(1),"^",4)=""
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20130125
/// Description:： 获得系统默认参数
/// Table：       
/// Input：        PathFile:路径
/// Output：       
/// Return：       0:无,1:有
/// Others：
/// d ##Class(web.DHCQCSysPara).SaveDefaultNameSpace("")
ClassMethod SaveDefaultPathFile(PathFile As %String, UserId As %String) As %String
{
	Set PathFile=$Get(PathFile)
	If $Length(PathFile)<1 Quit "输入信息为空！"
	If $Length(UserId)<1 Quit "用户代码不能为空！"
	If $Data(^DHCQCSYSParameter(UserId,1)) Do
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",5)=PathFile
	.If $Length(PathFile) Set $Piece(^DHCQCSYSParameter(1),"^",5)=PathFile 
	Else  Do
	.Set ^DHCQCSYSParameter(UserId,1)=""
	.Set $Piece(^DHCQCSYSParameter(UserId,1),"^",5)=PathFile
	.If $Length(PathFile) Set $Piece(^DHCQCSYSParameter(1),"^",5)=PathFile
	Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20130125
/// Description:： 查询系统默认参数
/// Table：       
/// Input：        SysCode:1
/// Output：       
/// Return：       RetString
/// Others：       修改记录：如果不维护相应的信息的话，取默认信息维护
/// d ##Class(web.DHCQCSysPara).QueryDefaultNameSpace("1","demo")
ClassMethod QueryDefaultNameSpace(SysCode As %String, UserId As %String) As %String
{
	Set SysCode=$Get(SysCode)
	Set UserId=$Get(UserId)
	Set Ret=0
	If UserId="" Quit Ret=0
	If $Length(SysCode)="" Quit Ret=0
	Else  Do
	.Set Ret=$Get(^DHCQCSYSParameter(UserId,SysCode))
	.//If Ret="" Set Ret=$Get(^DHCQCSYSParameter(SysCode))
	.If $Length(Ret,"^")<5  Set Ret=$Get(^DHCQCSYSParameter(SysCode))
	Quit Ret
}

}
