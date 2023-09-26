Class User.Abstract Extends %Library.RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// by zhouzq 2011.06.02
ClassMethod OnAudit() [ CodeMode = objectgenerator, Final ]
{
}

/// ///by zhouzq 2011.06.02 Insert审计处理
ClassMethod OnAuditInsert() [ CodeMode = objectgenerator, Final ]
{
}

/// by zhouzq 2011.06.02
ClassMethod OnAuditDelete() [ CodeMode = objectgenerator, Final ]
{
}

/// by zhouzq 2011.06.02
ClassMethod OnAuditUpdate() [ CodeMode = objectgenerator, Final ]
{
}

/// by zhouzq 2011.06.02
/// 此方法需要实现,否则会导致执行SQL语句.提示找不到getOld方法
/// 在User包下继承此类的实体类不能建在二级目录下,否则代码会出错,因为生成的表不在SQLUser包下,
ClassMethod OnTrigger(rowid As %Library.String) [ CodeMode = objectgenerator, Final ]
{
}

ClassMethod GetTranByDesc(Prop, Desc, LangId = 20)
{
}

/// Get the old values from the database prior to update...(?)
/// This is a class method because .. is not avaiable in SQL updates
/// by zhouzq 2011.06.02
ClassMethod getOld(rowid As %Library.String) [ CodeMode = objectgenerator, Final ]
{
}

}
