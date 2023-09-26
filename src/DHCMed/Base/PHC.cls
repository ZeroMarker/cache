/// 名称: DHCMed.Base.PHC
/// 描述: 药学项目(PHC_DrgMast)的业务封装，定义常用属性和方法
/// 编写者：刘学峰
/// 编写日期: 2010-04-09
Class DHCMed.Base.PHC Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//1、PHC_DrgForm药学形态表字段：

//PHCDF_PHCD_ParRef       PHC_DrgMast药学项

//2、PHC_DrgMast药学项表字段：

//PHCD_RowId

//PHCD_Code               代码

//PHCD_Name               描述

//PHCD_PHCSC_DR           PHC_SubCat药学子类

//PHCD_MinSubCat_DR       PHC_MinorSubCat药学最小分类

/// 1、PHC_DrgForm表RowId PHCDF_RowId
Property PHCDFRowId As %Integer;

/// 2、药学项代码 PHCD_Code
Property PHCDCode As %String;

/// 3、药学项描述 PHCD_Name
Property PHCDName As %String;

/// 4、药学子类指向 PHCD_PHCSC_DR 指向PHC_SubCat
Property PHCSCDR As %String;

/// 5、药学项描述 PHCD_MinSubCat_DR 指向PHC_MinorSubCat
Property MinSubCatDR As %String;

//3、PHC_SubCat药理学子分类：

//PHCSC_RowId

//PHCSC_Code

//PHCSC_Desc

/// 6、药理学子分类代码 PHCSC_Code
Property PHCSCCode As %String;

/// 7、药理学子分类描述 PHCSC_Desc
Property PHCSCDesc As %String;

//4、PHC_MinorSubCat药理学最小分类：

//MIN_RowId

//MIN_Code

//MIN_Desc

/// 8、药理学最小分类代码 MIN_Code
Property MINCode As %String;

/// 9、药理学最小分类描述 MIN_Desc
Property MINDesc As %String;

//5、PHC_Cat药理学分类

//PHCC_RowId

//PHCC_Code

//PHCC_Desc

/// 10、药理学最小分类描述 PHCC_Code
Property PHCCCode As %String;

/// 11、药理学最小分类描述 PHCC_Desc
Property PHCCDesc As %String;

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       PHC_DrgMast、PHC_SubCat、PHC_MinorSubCat、PHC_Cat
/// Input：       sep:指定的分隔符
/// ret：      	  返回各属性值，按照sep分隔
///               1、PHCDRowId 2、ARCIMCode 3:ARCIMDesc、
Method ToString(sep As %String) As %String
{
	if $g(sep)=""{
		set sep=..#SEPARATE
		} 
	s ret=..PHCDFRowId				//1
	s ret=ret_sep_..PHCDCode		//2
	s ret=ret_sep_..PHCDName		//3
	s ret=ret_sep_..PHCSCDR			//4
	s ret=ret_sep_..MinSubCatDR		//5
	s ret=ret_sep_..PHCSCCode		//6
	s ret=ret_sep_..PHCSCDesc		//7
	s ret=ret_sep_..MINCode			//8
	s ret=ret_sep_..MINDesc			//9
	s ret=ret_sep_..PHCCCode		//10
	s ret=ret_sep_..PHCCDesc		//11

	q ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据PHCDRowId取药学项信息
/// Table：       PHC_DrgMast、PHC_SubCat、PHC_MinorSubCat、PHC_Cat
/// Input：       PHC_DrgForm表RowId(或PHC_DrgMast表RowId)
/// ret：      	  返回obj
/// ResumeText：  
/// w ##class(DHCMed.Base.PHC).GetObjById(1) 
ClassMethod GetObjById(PHCDFRowId As %String) As DHCMed.Base.PHC
{
	n (PHCDFRowId)
	s ret=""
	;^PHCD({PHC_DrgMast.PHCD_RowId},"DF",{PHCDF_ChildSub})
	q:+PHCDFRowId=0 ret
	q:'$d(^PHCD(+PHCDFRowId)) ret
	;s PHCDFChildSub=$p(PHCDFRowId,"||",2)
	;s:PHCDFChildSub="" PHCDFChildSub=1 
	s obj=##Class(DHCMed.Base.PHC).%New()
	;查询PHC_DrgMast表
	s obj.PHCDFRowId=PHCDFRowId
	s PHCDRowId=+PHCDFRowId			;PHC_DrgMast表RowId=+PHC_DrgForm表RowId
	s obj.PHCDCode=$p($g(^PHCD(+PHCDFRowId,1)),"^",1)
	s obj.PHCDName=$p($g(^PHCD(+PHCDFRowId,1)),"^",2)
	s obj.PHCSCDR=$p($g(^PHCD(+PHCDFRowId,1)),"^",3)	 ;PHCD_PHCSC_DR 药学子类  指向PHC_SubCat
	s obj.MinSubCatDR=$p($g(^PHCD(+PHCDFRowId,1)),"^",6)

	;查询PHC_SubCat药理学子分类表
	;^PHCC({PHC_Cat.PHCC_RowId},"SC",{PHCSC_ChildSub})
	s PHCSCChildSub=$p(obj.PHCSCDR,"||",2)
	s obj.PHCSCCode=$p($g(^PHCC(+obj.PHCSCDR,"SC",+PHCSCChildSub)),"^",1)
	s obj.PHCSCDesc=$p($g(^PHCC(+obj.PHCSCDR,"SC",+PHCSCChildSub)),"^",2)

	
	;查询PHC_MinorSubCat药理学最小分类表
	;^PHCC({PHC_Cat.PHCC_RowId},"SC",{PHC_SubCat.PHCSC_ChildSub},"MIN",{MIN_Childsub})
	s MINChildsub=$p(obj.MinSubCatDR,"||",3)
	s obj.MINCode=$p($g(^PHCC(+obj.MinSubCatDR,"SC",+PHCSCChildSub,"MIN",+MINChildsub)),"^",1)
	s obj.MINDesc=$p($g(^PHCC(+obj.MinSubCatDR,"SC",+PHCSCChildSub,"MIN",+MINChildsub)),"^",2)
	
	;查询PHC_Cat药理学分类表
	;^PHCC({PHCC_RowId})
	s obj.PHCCCode=$p($g(^PHCC(+obj.PHCSCDR)),"^",1)
	s obj.PHCCDesc=$p($g(^PHCC(+obj.PHCSCDR)),"^",2)
	
	s ret=obj
	q ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       PHC_DrgMast、PHC_SubCat、PHC_MinorSubCat、PHC_Cat
/// Input：       PHC_DrgForm表RowId(或PHC_DrgMast表RowId)
///               sep: 指定的分隔符
/// ret：         返回obj.ToString()
/// w ##class(DHCMed.Base.PHC).GetStringById(1)
ClassMethod GetStringById(PHCDFRowId As %String, sep As %String) As %String
{
	n (PHCDFRowId,sep)
	s ret=""
	q:+PHCDFRowId=0 ret
	q:'$d(^PHCD(+PHCDFRowId)) ret
	s obj=..GetObjById(PHCDFRowId)
	s ret=obj.ToString($g(sep))
	q ret
}

}
