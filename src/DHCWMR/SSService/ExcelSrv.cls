/// 名称: DHCWMR.SSService.ExcelSrv
/// 描述: 导出Excel
/// 编写者：zhufei
/// 编写日期: 2014-05-25
Class DHCWMR.SSService.ExcelSrv Extends DHCWMR.Abstract [ Not ProcedureBlock ]
{

/// w ##Class(DHCWMR.SSService.ExcelSrv).ExportGrid("fillxlSheet","","","","")
ClassMethod ExportGrid(itmjs As %String, aClassName As %String, aQueryName As %String, aArguments As %String, aViewFields As %String, aRowIndex As %String = "") As %String
{
	new (itmjs,aClassName,aQueryName,aArguments,aViewFields,aRowIndex)
	set count=0
	quit:(aClassName="")||(aQueryName="")||(aViewFields="") count
	
	set rset = ##class(%Library.ResultSet).%New(aClassName_":"_aQueryName)
	set Arguments=""
	for indArg=1:1:$length(aArguments,$c(1)) {
		set Arg=$p(aArguments,$c(1),indArg)
		set Arg=""""_Arg_""""
		set Arguments=Arguments_","_Arg
	}
	set:Arguments'="" Arguments=$e(Arguments,2,$l(Arguments))
	set execute="do rset.Execute("_Arguments_")"
	X execute
	Set Properties=..GetQryProperties(aClassName,aQueryName)
	set aRowIndex=+$g(aRowIndex)
	set Row=$s(aRowIndex>1:aRowIndex,1:2)
	while (rset.Next()) {
		set RowData=""
		for Col=1:1:$length(aViewFields,$c(1)) {
			set Field=$p(aViewFields,$c(1),Col)
			set:$zcvt(Field,"U")="CHECKED" Field=""
			if Field'="" {
				if ($ListFind(Properties,Field)>0) {
					set FieldVal=rset.Data(Field)
				}else{
					if Field="RowNumberer" {
						set FieldVal=count+1
					} else {
						set FieldVal=""
					}
				}
			}else{
				set FieldVal=""
			}
			set RowData=RowData_$c(1)_FieldVal
		}
		continue:RowData=""
		set RowData=$e(RowData,2,$l(RowData))
		
		s retval=itmjs_"(xlSheet,'"_$ZCVT(RowData,"O","JS")_"',"_Row_","_1_");"
		&javascript<#(retval)#>
		
		set Row=Row+1
		set count=count+1
	}
	do rset.Close()
	
	quit count
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-07-19
/// Description:  取Query的ROWSPEC值（输出列）
/// Table：       
/// Input：       aClassName  : 类名称
///               aQueryName  : Query名称
/// Return：      
/// w ##class(DHCWMR.SSService.ExcelSrv).GetQryProperties("DHCWMR.SS.Dictionary","QueryByType")
ClassMethod GetQryProperties(aClassName As %String, aQueryName As %String) As %List
{
	New (aClassName,aQueryName)
	Set return=""
	Quit:(aClassName="")||(aQueryName="") return
	
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(aClassName)
	set count = cdef.Queries.Count() 
	For i = 1:1:count {
		if (cdef.Queries.GetAt(i).Name=aQueryName)
	 	 {		 	
		 	Set Propertystr = cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		 	if (Propertystr'="")
		 	{ 
		 		For indPro=1:1:$l(Propertystr,",") {
		 			Set Property=$p($p(Propertystr,",",indPro),":",1)
		 			Set return=return_$lb(Property)
		 		}
		 	}
		 }
	}
	//w $listtostring(return,"^"),!
	Quit return
}

/// w ##class(DHCWMR.SSService.ExcelSrv).GetCurrDateTime()
ClassMethod GetCurrDateTime()
{
	New
	Set CurrDate=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(+$h)
	Set CurrTime=$zt($p($h,",",2),1)
	Quit CurrDate_" "_CurrTime
}

}
