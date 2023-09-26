/// 名称: DHCWMR.Base.Ctloc
/// 描述: 科室表（CT_Loc）的业务封装，定义常用属性和方法
/// 编写者：liyi
/// 编写日期: 2014-09-05
Class DHCWMR.Base.Ctloc Extends (%Persistent, DHCWMR.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 科室Id  CTLOC_RowID
Property Rowid As %Integer;

/// 科室代码 CTLOC_Code
Property Code As %String(TRUNCATE = 1);

/// 科室描述 CTLOC_Desc
Property Descs As %String(TRUNCATE = 1);

/// 科室类型 CTLOC_Type
Property Type As %String(TRUNCATE = 1);

/// 医院 CTLOC_Hospital_DR  指向CT_Hospital                 
Property HospitalDr As %Integer;

/// 部门组 CTLOC_Dep_DR  指向RBC_DepartmentGroup                 
Property DepGroupDr As %Integer;

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Desc 3:Type 5:HospitalDr 6:DepGroupDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs_separete_..Type
	set return=return_separete_..HospitalDr_separete_..DepGroupDr
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCWMR.Base.Ctloc).GetObjById(1)
ClassMethod GetObjById(ctloc As %String) As DHCWMR.Base.Ctloc
{
	new (ctloc)
	set return=""
	quit:ctloc="" return
	quit:'$d(^CTLOC(+ctloc)) return
	set obj=##Class(DHCWMR.Base.Ctloc).%New()
	set obj.Rowid=+ctloc
	set obj.Code=$p($g(^CTLOC(+ctloc)),"^",1)   // 科室代码 CTLOC_Code
	set obj.Descs=$p($g(^CTLOC(+ctloc)),"^",2)   // 科室描述 CTLOC_Desc
	set obj.Type=$p($g(^CTLOC(+ctloc)),"^",13)   // 科室类型 CTLOC_Type
	set obj.HospitalDr=+$p($g(^CTLOC(+ctloc)),"^",22)   // 医院 CTLOC_Hospital_DR
	set obj.DepGroupDr=+$p($g(^CTLOC(+ctloc)),"^",19)   // 部门组 CTLOC_Dep_DR
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-05
/// Description:  根据CT_Loc.CTLOC_RowID取科室信息
/// Table：       CT_Loc
/// Input：       ctloc:    CT_Loc.CTLOC_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCWMR.Base.Ctloc).GetStringById(1)
ClassMethod GetStringById(ctloc As %String, separete As %String) As %String
{
	new (ctloc,separete)
	set return=""
	set obj=..GetObjById(ctloc)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

}
