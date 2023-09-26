/// 名称: DHCMed.Base.CtPcp
/// 描述: 医护人员表（CT_CareProv）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-04-09
Class DHCMed.Base.CtPcp Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 医护人员Id  CTPCP_RowId
Property Rowid As %Integer;

/// 医护人员代码 CTPCP_Code
Property Code As %String(TRUNCATE = 1);

/// 医护人员姓名 CTPCP_Desc
Property Name As %String(TRUNCATE = 1);

/// 医护人员类型Id  CTPCP_CarPrvTp_DR 指向 CT_CarPrvTp
Property CarPrvTypeDr As %Integer;

/// 医护人员类型代码 CTCPT_COde
Property CarPrvTypeCode As %String(TRUNCATE = 1);

/// 医护人员类型描述 CTCPT_Desc
Property CarPrvTypeDesc As %String(TRUNCATE = 1);

/// 医护类别 CT_CarPrvTp.CTCPT_InternalType
Property InternalType As %String(TRUNCATE = 1);

/// Creator：     wuqk
/// CreatDate：   2010-04-09
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Name 4:CarPrvTypeDr 5:CarPrvTypeCode 6:CarPrvTypeDesc 7:InternalType
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Name_separete_..CarPrvTypeDr
	set return=return_separete_..CarPrvTypeCode_separete_..CarPrvTypeDesc_separete_..InternalType
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-09
/// Description:  根据CT_CareProv.CTPCP_RowID取医护信息
/// Table：       CT_CareProv/CT_CarPrvTp
/// Input：       id:    CT_CareProv.CTPCP_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.CtPcp).GetObjById(2)
ClassMethod GetObjById(id As %String) As DHCMed.Base.CtPcp
{
	new (id)
	set return=""
	quit:id="" return
	quit:'$d(^CTPCP(+id)) return
	set obj=##Class(DHCMed.Base.CtPcp).%New()
	set obj.Rowid=+id
	set obj.Code=$p($g(^CTPCP(+id,1)),"^",1)     // 代码
	set obj.Name=$p($g(^CTPCP(+id,1)),"^",2)     // 姓名
	set obj.CarPrvTypeDr=$p($g(^CTPCP(+id,1)),"^",4)   // 医护人员类型
	set obj.CarPrvTypeCode=$p($g(^CT("CPT",+obj.CarPrvTypeDr)),"^",1)   // 医护人员类型代码
	set obj.CarPrvTypeDesc=$p($g(^CT("CPT",+obj.CarPrvTypeDr)),"^",2)   // 医护人员类型描述
	set obj.InternalType=$p($g(^CT("CPT",+obj.CarPrvTypeDr)),"^",4)   // 医护类型
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-09
/// Description:  根据CT_CareProv.CTPCP_RowID取医护信息
/// Table：       CT_CareProv/CT_CarPrvTp
/// Input：       id:    CT_CareProv.CTPCP_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.CtPcp).GetStringById(2)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-09
/// Description:  根据SS_User.SSUSR_RowID取医护信息
/// Table：       SS_User、CT_CareProv
/// Input：       id:    SS_User.SSUSR_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.CtPcp).GetByUserId(1)
ClassMethod GetByUserId(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set objUser=##class(DHCMed.Base.SSUser).GetObjById(id)
	if $IsObject(objUser) {
		set CtpcpDr=+objUser.CtpcpDr
		if CtpcpDr>0{
			set return=..GetStringById(CtpcpDr,$g(separete))
		}
	}
	quit return
}

}
