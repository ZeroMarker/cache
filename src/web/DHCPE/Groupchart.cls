Import SQLUser

/// 创建时间		：2006.06.08
/// 创建人
/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_GroupChart
/// 主要功能		：
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人	：
Class web.DHCPE.Groupchart Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/*
Parameter BUILD = 33;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

Query QueryList(Desc As %Library.String = "", ListTargetURL As %Library.String = "", ParamName As %Library.String = "") As %SQLQuery(ROWSPEC = "SSGRP_Desc:%String,SSGRP_RowId:%String")
{
	
SELECT SSGRP_Desc,SSGRP_RowId FROM Ss_group
}

Query QueryChart(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "Name:%String,ID:%String")
{
SELECT Name,ID FROM epr.chart where name %STARTSWITH :Desc
}

Query QueryAll(ParRef As %Library.String = "") As %SQLQuery(ROWSPEC = "GC_RowId:%String, GC_SSGRP_DR:%String, GC_Chart_DR:%String, GC_Read:%String, GC_Write:%String, GC_SSGRP_DR_Name:%String, GC_Chart_DR_Name:%String")
{
 select gc.GC_RowId, gc.GC_SSGRP_DR, gc.GC_Chart_DR, gc.GC_Read, gc.GC_Write
        ,g.SSGRP_Desc as GC_SSGRP_DR_Name, c.Name as GC_Chart_DR_Name
 from DHC_PE_GroupChart as gc
 inner join epr.chart as c on c.ID=gc.GC_Chart_DR
 inner join ss_group as g on g.SSGRP_RowId=gc.GC_SSGRP_DR
 where GC_SSGRP_DR=:ParRef
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %String = "")
{
	s Rowid=$p(InString,"^",1)
	s SSGRPDR=$p(InString,"^",2)
    s ChrtDR=$p(InString,"^",3)
    s iRead=$p(InString,"^",4)
    s iWrite=$p(InString,"^",5)

	if (""=Rowid)  d
	.s ReturnFlag=..Insert(Rowid,SSGRPDR,ChrtDR,iRead,iWrite)
	e  d
	.s ReturnFlag=..Update(Rowid,SSGRPDR,ChrtDR,iRead,iWrite)

	q ReturnFlag
}

ClassMethod IsHaveRecord(SSGRPDR As %String, ChrtDR As %String)
{
	&sql(select count(GC_Chart_DR) into :RCount from  DHC_PE_GroupChart 
	     where GC_SSGRP_DR=:SSGRPDR and GC_Chart_DR=:ChrtDR)
	q RCount
}

ClassMethod Insert(Rowid As %String, SSGRPDR As %String, ChrtDR As %String, Read As %String, Write As %String)
{
	s ReturnFlag=..IsHaveRecord(SSGRPDR,ChrtDR)
	if (ReturnFlag<1) d
	.&sql(insert into DHC_PE_GroupChart(GC_SSGRP_DR, GC_Chart_DR, GC_Read, GC_Write) values (:SSGRPDR, :ChrtDR,:Read,:Write))
	.s ReturnFlag=SQLCODE
	e  d
	.s ReturnFlag="Err 01"
	q ReturnFlag
}

ClassMethod Update(Rowid As %String, SSGRPDR As %String, ChrtDR As %String, Read As %String, Write As %String)
{

	&sql(update DHC_PE_GroupChart
	     set GC_SSGRP_DR =:SSGRPDR,
	         GC_Chart_DR =:ChrtDR,
	         GC_Read =:Read,
	         GC_Write =:Write
	     where GC_RowId= :Rowid
	     )
	 q SQLCODE
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	&sql(delete from DHC_PE_GroupChart where GC_RowId= :Rowid)
	q SQLCODE
}

/// 删除函数
ClassMethod Delete2(Rowid As %Library.String = "")
{
	&sql(delete from SQLUser.DHC_PE_GroupChart where GC_RowId= :Rowid)
	q SQLCODE
}
*/
}
