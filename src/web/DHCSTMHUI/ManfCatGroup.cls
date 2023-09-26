Import sqluser

/// Descript:	生产厂家类组维护
/// Creator:	tsr
/// CreateDate:	2018-10-09
Class web.DHCSTMHUI.ManfCatGroup Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:获取授权的叶子类组
/// Creator:	tsr
/// CreatDate:	2018-10-09
/// Table:		DHC_ManfCatGroup
/// Input:		供应商Id
/// Return:		有权限的类组串(^隔开)
ClassMethod GetAuthorLeafScg(Manf As %String) As %String
{
	n (Manf)
	q:Manf="" ""
	s result=""
	&Sql(declare Scg cursor for
		select MCG_SCG_Dr From DHC_ManfCatGroup
		where MCG_Manf_Dr=:Manf)
	&sql(open Scg)
	f  &sql(fetch Scg into :scg) q:SQLCODE  d
	.i result="" s result=+scg
	.e  s result=result_"^"_+scg
	&sql(close Scg)
	q result
}

/// Description:保存生产厂家授权类组
/// Creator:	tsr
/// CreatDate:	2018-10-09
/// Table:		DHC_ManfCatGroup
/// Input:		生产厂家Id串,类组Id串
/// Return:		
ClassMethod SaveAuthorData(ManfStr As %String, ScgStr As %String) As %String
{
	n (ManfStr,ScgStr)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ManfStr)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Manf=Obj.%Get("RowId")
		s RtnObj=..SaveManfAuthor(Manf,ScgStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Description:保存某个生产厂家授权类组
/// Creator:	tsr
/// CreatDate:	2018-10-09
/// Table:		DHC_ManfCatGroup
/// Input:		生产厂家Id,类组Id串
/// Return:		
ClassMethod SaveManfAuthor(Manf As %String, ScgStr As %String) As RtnObj
{
	n (Manf,ScgStr)
	s RtnObj=##class(RtnObj).%New()
	i Manf="" q RtnObj.Err(-1,Manf,"生产厂家Id不能为空!","",0)
	s ScgStr=$replace(ScgStr,"^",",")
	i ScgStr'="" d
	.&sql(DELETE FROM DHC_ManfCatGroup WHERE MCG_Manf_Dr=:Manf AND MCG_SCG_Dr NOT IN (:ScgStr))
	e  d
	.&sql(DELETE FROM SQLUser.DHC_ManfCatGroup WHERE MCG_Manf_Dr=:Manf)
	i SQLCODE<0 q RtnObj.Err(-2,Manf,Manf_"原授权类组取消失败!")
	
	i ScgStr'="" d
	.s ScgLen=$l(ScgStr,",")
	.f i=1:1:ScgLen q:RtnObj.success'=0  d
	..s Scg=$p(ScgStr,",",i)
	..q:Scg=""
	..&sql(select * from SQLUser.DHC_ManfCatGroup where MCG_Manf_Dr=:Manf and MCG_SCG_Dr=:Scg)
	..i SQLCODE=100 d
	...&sql(insert into SQLUser.DHC_ManfCatGroup (MCG_Manf_Dr, MCG_SCG_Dr, MCG_UseFlag)
		values (:Manf,:Scg,'Y'))
	...i SQLCODE'=0 d RtnObj.Err(-3,Manf,Manf_"类组授权失败!")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

}
