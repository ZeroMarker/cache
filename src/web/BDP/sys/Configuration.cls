Class web.BDP.sys.Configuration Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod Head() As %String
{
	n (%request,%session)
	
	;增加Ext内在JS文件
	w "<link rel=""stylesheet"" type=""text/css"" href=""../scripts_lib/ext3.2.1/ux/css/RowEditor.css"" />"
	w "<script type=""text/javascript"" src=""../scripts_lib/ext3.2.1/ux/RowEditor.js""></script>"
	
	;增加扩展js控件js文件或者css文件
	
	/// 增加css文件
	w "<link rel=""stylesheet"" type=""text/css"" href=""../scripts/bdp/Framework/css/style.css""/>"
	;bdp 组的扩展脚本库
	w "<script type=""text/javascript"" src=""../scripts/bdp/Framework/scripts/Ext.BDP.FunLib.js""></script>"
	
	;
	s myTMenuID = $g(%request.Data("BDPMENU",1))
	i myTMenuID'="" {
		s mySessionStr = ##class(web.BDP.sys.Preferences).DHCGetDefaultSystemSession()
		;
		d ##class(web.DHCBL.BDP.BDPMenuDefine).BuildAryByID(myTMenuID, mySessionStr)
		
		;s ^TMPAAA=%request.Data("extfilename",1)
	}
	
	q $$$OK
}

ClassMethod Body() As %String
{
	n (%request,%session)
	
	
	q $$$OK
}

}
