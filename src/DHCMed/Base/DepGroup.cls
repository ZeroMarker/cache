/// 名称: DHCMed.Base.PacWard
/// 描述: 部门组（RBC_DepartmentGroup）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-04-07
Class DHCMed.Base.DepGroup Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 部门组Id  DEP_RowID
Property Rowid As %Integer;

/// 部门组代码 DEP_Code
Property Code As %String(TRUNCATE = 1);

/// 部门组描述 DEP_Desc
Property Descs As %String(TRUNCATE = 1);

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Descs
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据RBC_DepartmentGroup.DEP_RowID取部门组信息
/// Table：       RBC_DepartmentGroup
/// Input：       id:    RBC_DepartmentGroup.DEP_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.DepGroup).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.Base.DepGroup
{
	new (id)
	set return=""
	quit:id="" return
	quit:'$d(^RBC("DEP",+id)) return
	set obj=##Class(DHCMed.Base.DepGroup).%New()
	set obj.Rowid=+id
	set obj.Code=$p($g(^RBC("DEP",+id)),"^",1)    // 代码
	set obj.Descs=$p($g(^RBC("DEP",+id)),"^",2)   // 描述
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据RBC_DepartmentGroup.DEP_RowID取部门组信息
/// Table：       RBC_DepartmentGroup
/// Input：       id:    RBC_DepartmentGroup.DEP_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.DepGroup).GetStringById(1)
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
/// CreatDate：   2010-04-07
/// Description:  取所有部门组信息列表
/// Table：       RBC_DepartmentGroup
/// Return：      返回列表$c(1)分隔行 ^分隔列
/// w ##class(DHCMed.Base.DepGroup).GetAllRbcDepGroup()
ClassMethod GetAllRbcDepGroup() As %String
{
	new 
	set return=""
	set rbcId=$o(^RBC("DEP",""))
	while (rbcId'=""){
		set str=..GetStringById(+rbcId)
		if (str'=""){
			set return=return_str_$c(1)
		}
		set rbcId=$o(^RBC("DEP",rbcId))
	}
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-07
/// Description:  根据配置取所有部门组列表
/// Table：       RBC_DepartmentGroup、CT_Loc
/// Input：       HospId:     医院Id
/// Return：      返回列表$c(1)分隔行 ^分隔列
/// Others：      读取 DepartmentModel 配置
///               CCW:Ctloc/Ctloc/Ward 模式，默认
///               RCW:Rbc_DepGroup/Ctloc/Ward模式
/// w ##class(DHCMed.Base.DepGroup).GetByAllDepGrop()
ClassMethod GetByAllDepGrop(HospId As %String) As %String
{
	new (HospId)
	set HospId=+$g(HospId)
	set return=""
	
	set Setting=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DepartmentModel",HospId)
	set:Setting="" Setting="CCW"
	if Setting="CCW"{
		//默认只取执行科室列表
		set return=##class(DHCMed.Base.Ctloc).GetByDescAlias("","E")
	}
	elseif Setting="RCW"{
		set return=..GetAllRbcDepGroup()
	}	
	quit return
}

}
