Class web.HXGYPrinter.PrintObject Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CreatePrintObject()
{
	w "<object ID='hxgyPrinter' WIDTH=0 HEIGHT=0 CLASSID='CLSID:919D4EC0-59B0-416d-9433-ED72009D28F2' codebase='../addins/client/Report.exe'>"
	w "</object>",!
}

}
