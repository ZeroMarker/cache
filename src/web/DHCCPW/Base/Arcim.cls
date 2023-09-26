/// 名称: web.DHCCPW.Base.Arcim
/// 描述: 医嘱项目(ARC_ItmMast、ARC_ItemCat、OEC_OrderCategory)的业务封装，定义常用属性和方法
/// 编写者：刘学峰
/// 编写日期: 2010-04-06
Class web.DHCCPW.Base.Arcim Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//1、ARC_ItmMast表字段

//ARCIM_RowId 

//ARCIM_Code              代码

//ARCIM_Desc              描述

//ARCIM_ShortDesc         短描述

//ARCIM_ItemCat_DR        ARC_ItemCat医嘱子类

//ARCIM_BillSub_DR        ARC_BillSub收费子类

//ARCIM_PHCDF_DR          PHC_DrgForm药学形态

/// 1.1 Id  ARCIM_RowId 
Property ARCIMRowId As %Integer;

/// 1.2 代码 ARCIM_Code
Property ARCIMCode As %String;

/// 1.3 描述 ARCIM_Desc
Property ARCIMDesc As %String;

/// 1.4 短描述 ShortDesc
Property ARCIMShortDesc As %String;

/// 1.5 医嘱子类 ARCIM_ItemCat_DR 指向ARC_ItemCat
Property ARCIMItemCatDR As %String;

/// 1.6 收费子类 ARCIM_BillSub_DR 指向ARC_BillSub
Property ARCIMBillSubDR As %String;

/// 1.7 药学形态 ARCIM_PHCDF_DR   指向PHC_DrgForm
Property ARCIMPHCDFDR As %String;

//2、ARC_ItemCat医嘱子类表字段：

//ARCIC_RowId

//ARCIC_Code              代码

//ARCIC_Desc              描述

//ARCIC_OrdCat_DR         OEC_OrderCategory医嘱大类

//ARCIC_OrderType

//	Drug				||R-药品

//	Diet				||D

//	IV					||I

//	Consultation		||C-会诊

//	Normal				||N

//	Dental				||T

//	LabTrak				||L-检验

//	RehabMedicine		||X

//	Price				||P

//	BloodBank			||B

//	Diet Supplement		||S

//	Hardware			||H

//	Diet Enteral Feed	||E

//	Day Book			||A

//	DFT					||F

//	Diet Thickened Fluid||DTF

//	Bulk Meal			||BM

/// 2.1 医嘱子类代码 ARCIC_Code
Property ARCICCode As %String;

/// 2.2 医嘱子类描述 ARCIC_Desc
Property ARCICDesc As %String;

/// 2.3 医嘱大类指针 ARCIC_OrdCat_DR   指向OEC_OrderCategory
Property ARCICOrdCatDR As %String;

/// 2.4 医嘱类型 ARCIC_OrderType         L-检验  R-药品
Property ARCICOrderType As %String;

//3、OEC_OrderCategory医嘱大类表字段：

//ORCAT_RowId

//ORCAT_Code              代码

//ORCAT_Desc              描述

/// 3.1 医嘱大类代码 ORCAT_Code
Property ORCATCode As %String;

/// 3.2 医嘱大类描述 ORCAT_Desc
Property ORCATDesc As %String;

//4、ARC_Alias别名表字段：

/// 4.1  别名ALIAS_Text
Property ALIASText As %String;

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       ARC_ItmMast
/// Input：       sep:指定的分隔符
/// ret：      	  返回各属性值，按照sep分隔
Method ToString(sep As %String) As %String
{
	if $g(sep)=""{
		set sep=..#SEPARATE
		} 
	s ret=..ARCIMRowId
	s ret=ret_sep_..ARCIMCode			//1
	s ret=ret_sep_..ARCIMDesc			//2
	s ret=ret_sep_..ARCIMShortDesc		//3
	s ret=ret_sep_..ARCIMItemCatDR		//4
	s ret=ret_sep_..ARCIMBillSubDR		//5
	s ret=ret_sep_..ARCIMPHCDFDR		//6
	s ret=ret_sep_..ARCICCode			//7
	s ret=ret_sep_..ARCICDesc			//8
	s ret=ret_sep_..ARCICOrdCatDR		//9
	s ret=ret_sep_..ARCICOrderType		//10
	s ret=ret_sep_..ORCATCode			//11
	s ret=ret_sep_..ORCATDesc			//12
	s ret=ret_sep_..ALIASText			//13
	quit ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据ARCIM_RowId取医嘱信息
/// Table：       ARC_ItmMast、ARC_ItemCat、OEC_OrderCategory
/// Input：       ARCIMRowId：格式"2||1"(如果为"2",则无法获取别名ALIASText)
/// ret：      	  返回obj
/// ResumeText：  ^ARCIM的数据都存在于^ARCIM(n,1,n)节点下
/// w ##class(web.DHCCPW.Base.Arcim).GetObjById(1) 
ClassMethod GetObjById(ARCIMRowId As %String) As web.DHCCPW.Base.Arcim
{
	n (ARCIMRowId)
	s ret=""
	q:+ARCIMRowId=0 ret
	q:'$d(^ARCIM(+ARCIMRowId)) ret
	s obj=##Class(web.DHCCPW.Base.Arcim).%New()
	s obj.ARCIMRowId=+ARCIMRowId
	s obj.ARCIMCode=$p($g(^ARCIM(+ARCIMRowId,1,1)),"^",1)
	s obj.ARCIMDesc=$p($g(^ARCIM(+ARCIMRowId,1,1)),"^",2)
	s obj.ARCIMShortDesc="" 
	s obj.ARCIMItemCatDR=$p($g(^ARCIM(+ARCIMRowId,1,1)),"^",10)
	s obj.ARCIMBillSubDR=$p($g(^ARCIM(+ARCIMRowId,1,1)),"^",9)  
	s obj.ARCIMPHCDFDR=$p($g(^ARCIM(+ARCIMRowId,1,1)),"^",12) 
	//查询ARC_ItemCat医嘱子类
	s obj.ARCICCode=$p($g(^ARC("IC",+obj.ARCIMItemCatDR)),"^",1)
	s obj.ARCICDesc=$p($g(^ARC("IC",+obj.ARCIMItemCatDR)),"^",2)
	s obj.ARCICOrdCatDR=$p($g(^ARC("IC",+obj.ARCIMItemCatDR)),"^",8)
	s obj.ARCICOrderType=$p($g(^ARC("IC",+obj.ARCIMItemCatDR)),"^",7)
	
	//查询OEC_OrderCategory医嘱大类
	//^OEC("ORCAT",{ORCAT_RowId})
	s obj.ORCATCode=$p($g(^OEC("ORCAT",+obj.ARCICOrdCatDR)),"^",1)
	s obj.ORCATDesc=$p($g(^OEC("ORCAT",+obj.ARCICOrdCatDR)),"^",2) 
	
	//查询ARC_Alias医嘱项别名表
	//^ARC("ALIAS",0,"ARCIM",{ALIAS_ARCIM_DR},{ALIAS_RowId})
	s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,""))
	s:ALIASRowId'="" obj.ALIASText=$ZCVT($p(^ARC("ALIAS",ALIASRowId),"^",6),"U") //ARC_Alias表ALIAS_Text
	
	s ret=obj
	q ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据ARCIM_RowId取科室信息
/// Table：       ARC_ItmMast、ARC_ItemCat、OEC_OrderCategory
/// Input：       ARCIMRowId
///               sep: 指定的分隔符
/// ret：      	  返回obj.ToString()
/// w ##class(web.DHCCPW.Base.Arcim).GetStringById(1)
ClassMethod GetStringById(ARCIMRowId As %String, sep As %String) As %String
{
	n (ARCIMRowId,sep)
	s ret=""
	q:+ARCIMRowId=0 ret
	q:'$d(^ARCIM(+ARCIMRowId)) ret
	s obj=..GetObjById(ARCIMRowId)
	s ret=obj.ToString($g(sep))
	q ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-14
/// Description:  根据ARCIM_Desc汉字描述或其别名表的拼音首字母查询
/// Table：       ARC_ItmMast
/// Input：       ARCIMDesc:ARC_ItmMast.ARCIM_Desc汉字描述或ARC_Alias.ARC_Alias首字母别名
/// 				  OrderType:ARC_ItemCat.ARCIC_OrderType医嘱项类型(R、L、C、D等)
/// Return：      ResultSet
/// Others：      医嘱项别名表：ARC_Alias
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.Base.Arcim","QueryByDescAlias","qms","R")
Query QueryByDescAlias(ARCIMDesc As %String, OrderType As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ARCIMCode:%String,ArcimDR:%String")
{
}

ClassMethod QueryByDescAliasExecute(ByRef qHandle As %Binary, Alias As %String, OrderType As %String) As %Status
{
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;q:Alias="" $$$OK
	
    s Alias=$ZCVT(Alias,"U")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 
	.f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s objArcim=..GetObjById(ArcimDR)
	..q:'$IsObject(objArcim)
	..s ArcimDesc=objArcim.ARCIMDesc
	..s AliasText=objArcim.ALIASText
	..s ArcimDesc=AliasText_"-"_ArcimDesc
	..q:ArcimDesc'[Alias			//按照别名过滤
	..s ARCICOrderType=objArcim.ARCICOrderType
	..q:ARCICOrderType'[OrderType
	..Do OutputRow

	Quit $$$OK
OutputRow
	set Data=$lb(ArcimDesc,objArcim.ARCIMCode,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

 	quit
}

ClassMethod QueryByDescAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDescAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByDescAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDescAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
