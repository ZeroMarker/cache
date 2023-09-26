/// 名称: DHCMed.Base.OeOrder
/// 描述: 医嘱表(OE_Order)的业务封装，定义常用属性和方法
/// 编写者：刘学峰
/// 编写日期: 2010-04-06
Class DHCMed.Base.OeOrder Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 医嘱Id  OEORD_RowId
Property Rowid As %Integer;

/// 就诊指向 OEORD_Adm_DR
Property EpisodeID As %String(TRUNCATE = 1);

/// 医嘱日期 OEORD_Date
Property Date As %Library.Date;

/// 医嘱时间 OEORD_Time
Property Time As %Library.Time;

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       OE_Order
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	s ret=..Rowid						//1
	s ret=ret_separete_..EpisodeID		//2
	s ret=ret_separete_..Date			//3
	s ret=ret_separete_..Time			//4
	quit ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据OE_Order.OEORD_RowId取医嘱信息
/// Table：       OE_Order
/// Input：       Rowid
/// Return：      返回obj
/// Others：      
/// w ##class(DHCMed.Base.OeOrder).GetObjById(1) 
ClassMethod GetObjById(Rowid As %String) As DHCMed.Base.OeOrder
{
	n (Rowid)
	s return=""
	q:+Rowid=0 return
	q:'$d(^OEORD(+Rowid)) return
	s obj=##Class(DHCMed.Base.OeOrder).%New()
	s obj.Rowid=+Rowid
	s obj.EpisodeID=$p($g(^OEORD(+Rowid)),"^",1)   	// OEORD_Adm_DR
	s obj.Date=$p($g(^OEORD(+Rowid)),"^",2)   		// OEORD_Date
	s obj.Time=$p($g(^OEORD(+Rowid)),"^",3)   		// OEORD_Time
	
	s return=obj
	q return
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据OE_Order.OEORD_RowId取医嘱信息
/// Table：       OE_Order
/// Input：       OE_Order.OEORD_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.OeOrder).GetStringById(1)
ClassMethod GetStringById(Rowid As %String, separete As %String) As %String
{
	n (Rowid,separete)
	s return=""
	q:+Rowid=0 return
	q:'$d(^OEORD(+Rowid)) return
	s obj=..GetObjById(Rowid)
	s return=obj.ToString($g(separete))
	q return
}

}
