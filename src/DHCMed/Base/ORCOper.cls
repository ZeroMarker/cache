/// 名称: DHCMed.Base.ORCOper
/// 描述: 手术字典表(ORC_Operation)的业务封装，定义常用属性和方法
/// 编写者：zf
/// 编写日期: 2010-04-10
Class DHCMed.Base.ORCOper Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// ORC_Operation表Id  ORC_Operation.OPER_RowId
Property OperRowid As %Integer;

/// 手术代码 ORC_Operation.OPER_Code
Property OperCode As %String(TRUNCATE = 1);

/// 手术名称 ORC_Operation.OPER_Desc
Property OperDesc As %String(TRUNCATE = 1);

/// ICD编码 ORC_Operation.OPER_ICD9Map
Property OperICD As %String(TRUNCATE = 1);

/// ICD副编码 ORC_Operation.OPER_ICD10Map
Property OperICD1 As %String(TRUNCATE = 1);

/// 起始日期 ORC_Operation.OPER_DateActiveFrom
Property OperDateFrom As %Library.Date;

/// 是否有效 ORC_Operation.OPER_Valid
Property OperValid As %Boolean;

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)="" {
		set separete=..#SEPARATE
	}
	set return=..OperRowid
	set return=return_separete_..OperCode_separete_..OperDesc
	set return=return_separete_..OperICD_separete_..OperICD1
	set return=return_separete_..OperDateFrom_separete_..OperValid
	quit return
}

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  根据ORC_Operation.OPER_RowId取手术字典信息
/// Table：       ORC_Operation
/// Input：       OperRowid    ORC_Operation.OPER_RowId
/// Return：      返回obj
/// Others：      
ClassMethod GetObjById(OperRowid As %String) As DHCMed.Base.ORCOper
{
	new (OperRowid)
	set return=""
	quit:OperRowid="" return
	quit:'$d(^ORC("OPER",+OperRowid))="" return
	set obj=##Class(DHCMed.Base.ORCOper).%New()
	set obj.OperRowid=+OperRowid
	set obj.OperCode=$p($g(^ORC("OPER",+OperRowid)),"^",1)
	set obj.OperDesc=$p($g(^ORC("OPER",+OperRowid)),"^",2)
	set obj.OperICD=$p($g(^ORC("OPER",+OperRowid)),"^",21)
	set obj.OperICD1=$p($g(^ORC("OPER",+OperRowid)),"^",20)
	set obj.OperDateFrom=$p($g(^ORC("OPER",+OperRowid)),"^",5)
	set obj.OperValid=$p($g(^ORC("OPER",+OperRowid)),"^",22)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zf
/// CreatDate：   2010-04-10
/// Description:  根据ORC_Operation.OPER_RowId取手术字典信息
/// Table：       ORC_Operation
/// Input：       OperRowid: ORC_Operation.OPER_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.ORCOper).GetStringById(1)
ClassMethod GetStringById(OperRowid As %String, separete As %String) As %String
{
	new (OperRowid,separete)
	set return=""
	set obj=..GetObjById(OperRowid)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}
	quit return
}

}
