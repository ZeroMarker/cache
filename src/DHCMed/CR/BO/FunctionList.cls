/// 名称: DHCMed.CR.BO.FunctionList
/// 描述: Javascript函数处理
/// 编写者：wuqk
/// 编写日期: 2012-11-27
Class DHCMed.CR.BO.FunctionList Extends (%RegisteredObject, %XML.Adaptor)
{

Property list As list Of DHCMed.CR.PO.Function(XMLNAME = "root");

/// d ##class(DHCMed.CR.BO.FunctionList).ExportFunction()
ClassMethod ExportFunction()
{
	set writer=##class(%XML.Writer).%New()
	//set writer.Charset="UTF-8"
	set sc=writer.OutputToString()
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	set sc=writer.RootElement("root")
	//set list = ..%New()
	set id=0
	for {
		set id = $o(^DHCMed.CR.PO.FunctionD(id))
		quit:id=""
		set funcion = ##class(DHCMed.CR.PO.Function).%OpenId(id)
		//do list.list.Insert(funcion)
		set sc=writer.Object(funcion,"funcion")
	 	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	}
	s sc=writer.EndRootElement()
	s string=writer.GetXMLString()
	w string
	q
}

}
