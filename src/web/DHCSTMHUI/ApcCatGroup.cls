Import sqluser

/// Descript:	供应商类组授权
/// Creater:	tsr
/// CreateDate:	2018-08-13
Class web.DHCSTMHUI.ApcCatGroup Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:获取授权的叶子类组
/// Creator:	tsr
/// CreatDate:	2018-08-13
/// Table:		DHC_ApcCatGroup
/// Input:		供应商Id
/// Return:		有权限的类组串(^隔开)
ClassMethod GetAuthorLeafScg(Vendor As %String) As %String
{
	n (Vendor)
	q:Vendor="" ""
	s result=""
	&Sql(declare Scg cursor for
		select ACG_SCG_Dr From DHC_ApcCatGroup
		where ACG_APCVM_Dr=:Vendor)
	&sql(open Scg)
	f  &sql(fetch Scg into :scg) q:SQLCODE  d
	.i result="" s result=+scg
	.e  s result=result_"^"_+scg
	&sql(close Scg)
	q result
}

/// Description:保存供应商授权类组
/// Creator:	tsr
/// CreatDate:	2018-08-13
/// Table:		DHC_ApcCatGroup
/// Input:		供应商Id串,类组Id串
/// Return:		
/// w ##class(web.DHCSTMHUI.ApcCatGroup).SaveAuthorData("[{""RowId"":""2""}]","")
ClassMethod SaveAuthorData(VenStr As %String, ScgStr As %String) As %String
{
	n (VenStr,ScgStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(VenStr)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Vendor=Obj.%Get("RowId")
		s RtnObj=..SaveVendorAuthor(Vendor,ScgStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Description:保存某个供应商授权类组
/// Creator:	tsr
/// CreatDate:	2018-08-21
/// Table:		DHC_ApcCatGroup
/// Input:		供应商Id,类组Id串
/// Return:		
ClassMethod SaveVendorAuthor(Vendor As %String, ScgStr As %String) As RtnObj
{
	n (Vendor,ScgStr)
	i ScgStr["^" s ScgStr=$tr(ScgStr,"^",",")
	s RtnObj=##class(RtnObj).%New()
	i Vendor="" q RtnObj.Err(-1,Vendor,"供应商Id不能为空!","",0)
	i ScgStr'="" d
	.&sql(DELETE FROM DHC_ApcCatGroup WHERE ACG_APCVM_Dr=:Vendor AND ACG_SCG_Dr NOT IN (:ScgStr))
	e  d
	.&sql(DELETE FROM DHC_ApcCatGroup WHERE ACG_APCVM_Dr=:Vendor)
	i SQLCODE<0 q RtnObj.Err(-2,Vendor,Vendor_"原授权类组取消失败:"_SQLCODE)
	
	i ScgStr'="" d
	.s ScgLen=$l(ScgStr,",")
	.f i=1:1:ScgLen q:RtnObj.success'=0  d
	..s Scg=$p(ScgStr,",",i)
	..q:Scg=""
	..&sql(select * from SQLUser.DHC_ApcCatGroup where ACG_APCVM_Dr=:Vendor and ACG_SCG_Dr=:Scg)
	..i SQLCODE=100 d
	...&sql(insert into SQLUser.DHC_ApcCatGroup (ACG_APCVM_Dr, ACG_SCG_Dr, ACG_UseFlag)
		values (:Vendor,:Scg,'Y'))
	...i SQLCODE'=0 d RtnObj.Err(-3,Vendor,Vendor_"类组授权失败!")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

}
