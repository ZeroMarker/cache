Import SQLUser

/// 名称: 	DHCDocIPBKTempDtlCtl
/// 描述: 	住院证模板明细表DHCDocIPBKTempDtl操作
/// 编写者：	刘学峰
/// 编写日期:2008-10-27
Class web.DHCDocIPBKTempDtlCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

/// Creator：    刘学峰
/// CreatDate：  2008-10-27
/// Description：添加或修改住院证模板明细表
/// Table：      DHCDocIPBKTempDtl
/// Input：      RowID^TempID^ItemID^DefaultValue^IsNeed^ToolTip^ResumeText
/// Output：     SQLCODE/RowID
/// Debug:		 w ##class(web.DHCDocIPBKTempDtlCtl).Update("入参")
ClassMethod Update(InPut)
{

    n (InPut)  
    s RowID=$p(InPut,"^",1)
    s PLIST(2)=$p(InPut,"^",2)      ;TempID	模板ID 指向DHCDocIPBKTemplate              
    s PLIST(3)=$p(InPut,"^",3)      ;ItemID	项目ID 指向DHCDocIPBKTempItem            
    s PLIST(4)=$p(InPut,"^",4)      ;DefaultValue	默认值 字典项目可存指针
    s PLIST(5)=$p(InPut,"^",5)      ;IsNeed	是否必需           
    s PLIST(6)=$p(InPut,"^",6)      ;ToolTip	提示       
    s PLIST(7)=$p(InPut,"^",7)      ;ResumeText	备注             
    
    i RowID="" d
    .&sql(Insert into DHCDocIPBKTempDtl values :PLIST())
    e  d
    .&sql(Update DHCDocIPBKTempDtl values :PLIST() where RowID=:RowID)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod DeleteTemplateDetail(TemplateID)
{
	&sql(Delete from DHCDocIPBKTempDtl where TempID =:TemplateID)
	quit 1
}

/// Creator：    刘学峰
/// CreatDate：  2008-10-27
/// Description：根据DHCDocIPBKTemplate的RowID查询模板明细数据列表
/// Table：      DHCDocIPBKTempDtl
/// Input：      TempIDFlag:模板RowID
/// Output：     $c(1)分割字符串
/// Debug:		 w ##class(web.DHCDocIPBKTempDtlCtl).QueryDataByTempID("TempIDFlag")
ClassMethod QueryDataByTempID(TempIDFlag)
{
	;^DHCDocIPBKTD(0,TempItem,{TempID},{ItemID},{RowID})
	;RowID^TempID^ItemID^DefaultValue^IsNeed^ToolTip^ResumeText
	n (TempIDFlag)
	s ret=""	
	s RowID=0
	f  s RowID=$o(^DHCDocIPBKTD(RowID)) q:RowID=""  d
	.s str=$g(^DHCDocIPBKTD(RowID))
	.s TempID=$p(str,"^",1)
	.q:TempID'=TempIDFlag
	.s ItemID=$p(str,"^",2)
	.s DefaultValue=$p(str,"^",3)
	.s IsNeed=$p(str,"^",4)
	.s ToolTip=$p(str,"^",5)
	.s ResumeText=$p(str,"^",6)
	.s ret=ret_RowID_"^"_TempID_"^"_ItemID_"^"_DefaultValue_"^"_IsNeed_"^"_ToolTip_"^"_ResumeText_$c(1)
	s ret=$e(ret,1,$l(ret)-1)
	q ret
}

}
