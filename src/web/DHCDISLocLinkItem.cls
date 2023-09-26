Import Sqluser

Class web.DHCDISLocLinkItem Extends %Persistent [ Not ProcedureBlock ]
{

/// w ##class(web.DHCDISLocLinkItem).SaveUpdUserLinkItem("19^0^10$$19^0^9")
ClassMethod SaveUpdUserLinkItem(params)
{
  
	s $Zt="Err"
  	TStart
  	s ret=0,flag=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s check=..CheckUserLinkItem(str)
  	.i check=10 s flag=1
  	q:flag=1 10
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s id=$p(str,"^",2)
  	.i id=0 d
  	..s ret=..SaveUserLinkItem(str)
  	.e  d
  	..s ret=..UpdUserLinkItem(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      yuliping
/// CreatDate：    2017-01-19
/// Description:   新增 陪送科室人员可配送项目表
/// Table：        DHC_DisLocUserLinkItm
/// Return：       保存成功 0，其他 失败 
/// w ##class(web.DHCDISLocLinkItem).SaveUserLinkItem("1^0^9")
ClassMethod SaveUserLinkItem(str As %String) As %String
{
	N (str)
	S LUParRef=$p(str,"^",1)
	S LUItemDr=$p(str,"^",3)
	b
 	&SQL(INSERT INTO DHC_DisLocUserLinkItm(LU_ParRef,LU_Item_Dr) VALUES(:LUParRef,:LUItemDr))
 	Q SQLCODE
}

/// Creator：      yuliping
/// CreatDate：    2017-01-19
/// Description:   更新 陪送科室人员可配送项目表
/// Table：        DHC_DisLocUserLinkItm
/// Return：       保存成功 0，其他 失败 
/// w ##class(web.DHCDISLocLinkItem).UpdUserLinkItem("1^10^13")
ClassMethod UpdUserLinkItem(str As %String) As %String
{
	
	N (str)
	S LUParRef=$p(str,"^",1)
	S LUChildSub=$p(str,"^",2)
	S LUItemDr=$p(str,"^",3)
	s ID=LUParRef_"||"_LUChildSub
	b
	&SQL(Update DHC_DisLocUserLinkItm Set LU_Item_Dr=:LUItemDr WHERE LinkItm_RowId=:ID)
 	Q SQLCODE
}

/// Creator：      yuliping
/// CreatDate：    2017-01-19
/// Description:   删除 陪送科室人员可配送项目表
/// Table：        DHC_DisLocUserLinkItm
/// Return：       保存成功 0，其他 失败 
/// w ##class(web.DHCDISLocLinkItem).RemoveUserLinkItem("1^9^5")
ClassMethod RemoveUserLinkItem(str As %String) As %String
{
	
	N (str)
	S LUParRef=$p(str,"^",1)
	S LUChildSub=$p(str,"^",2)
	S LUItemDr=$p(str,"^",3)
	s ID=LUParRef_"||"_LUChildSub
	&SQL(Delete From DHC_DisLocUserLinkItm WHERE LinkItm_RowId=:ID)
 	Q SQLCODE
}

/// Creator：      yuliping
/// CreatDate：    2017-01-19
/// Description:   判断人员关联科室存在与否
/// Table：        DHC_DisLocUserLinkItm
/// Return：       存在 0，1不存在
/// w ##class(web.DHCDISLocLinkItem).CheckUserLinkItem("1^3^15")
ClassMethod CheckUserLinkItem(str As %String) As %String
{
	N (str)
	s flag=0
	S LUParRef=$p(str,"^",1)
	S LUChildSub=$p(str,"^",2)
	S LUItemDr=$p(str,"^",3)
	s luid=""
	f  s luid=$o(^DHCDISLU(LUParRef,"LinkItm",luid))  q:luid=""  d
	.s itemDr=$p(^DHCDISLU(LUParRef,"LinkItm",luid),"^",3)
	.i itemDr=LUItemDr s flag=1
	
	q:flag=1 10
	q 11
}

Storage Default
{
<Data name="DHCDISLocLinkItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDISLocLinkItemD</DataLocation>
<DefaultData>DHCDISLocLinkItemDefaultData</DefaultData>
<IdLocation>^web.DHCDISLocLinkItemD</IdLocation>
<IndexLocation>^web.DHCDISLocLinkItemI</IndexLocation>
<StreamLocation>^web.DHCDISLocLinkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
