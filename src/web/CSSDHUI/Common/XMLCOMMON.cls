/// Descript:xml打印公共方法
/// Creater: ZhangDongmei
/// CreateDate: 2012-11-14
Class web.CSSDHUI.Common.XMLCOMMON Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter IOStrLen = 1000;

/// /此类的目的是?完成JS与Cache之间的交互?
ClassMethod ReadXML(CFlag As %String) As %Stream
{
	n (CFlag)
	
	s ^zdm("ReadXML")=CFlag
	s CFlag=$g(CFlag)
	s rtnval=""
	s mystream= ##class(web.DHCDataStream).ReadServerXML(CFlag)
	
	d mystream.Rewind()
	;JSName
	While (stream.AtEnd = 0) {
		s IOStrLen=2000
		s mystr=stream.Read(.IOStrLen)
		;b ;1
		i rtnval=""  d
		.;s rtnval=$ZCVT($g(mystr),"O","JS")
		.s rtnval=mystr
		e  d
		.;s rtnval=rtnval_$ZCVT($g(mystr),"O","JS")
		.s rtnval=rtnval_mystr
		//&javascript<#(rtnval)#>
	}
	;w rtnval
	//b ;2
	q rtnval	;;;;$ZCVT($g(mystr),"O","JS") ;;$l(dd,$c(13))			;;;stream.Size	;;"Test"
}

}
