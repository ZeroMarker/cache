Class DHCWL.MKPIIO.util.InputInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
导入接口方法，通过该方法的返回值决定如何进行导入操作
该方法返回值类型为字符串，有一些组合情况：
00：数据库中没有该值，且不将该值导入数据库
01：数据库中没有该值，且将该值导入到数据库
10：数据库中有该值，且不将该值导入数据库
11：数据库中有该值，且将该值更新到数据库
Parameter：classFullName：被导入对象的类全名；primaryFieldValue：被导入对象的唯一标示编码。
	primaryField:被导入对象的字段名称。refClassFullName：被导入对象所在类的类全名。refPrimayValue：被导入对象所在类的唯一标示值。
Return：0：不进行导入操作；1：导入时若已存在和primaryFieldValue相同的标示编码则忽略导入操作；2：导入时进行覆盖操作
*/
Method JudgeInput(classFullName As %String, primaryFieldValue As %String = "", primaryField As %String = "") As %String
{
	n (classFullName,primaryFieldValue,primaryField)
	q "11"
}

}
