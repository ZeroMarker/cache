Class web.BDP.sys.QueryReadBroker Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Query执行
/// 1. 分页功能  				pStart, pPageCount
///    需要传入 当前页  和每页多少行
/// 2. 排序功能(传入排序的列)	列名:Desc,列名:Asc
/// 3. 日期格式转换问题
ClassMethod CQPExecute(classname As %String, classquery As %String) As %String
{
	n rs, myrtn
	
	s rs=""
	s myrtn=""
	i ((classname="")||(classquery="")){
		q myrtn
	}
	
	s myIsVal=##class(websys.Conversions).IsValidClassName(classname)
	q:('myIsVal) myrtn
	s myIsVal=##class(websys.Conversions).IsValidQueryName(classname,classquery)
	q:('myIsVal) myrtn
	
	s rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	s paramcnt=rs.GetParamCount()
	n x,ival
	s x="s execstatus=$$InvokeMethod^%apiOBJ(""%ResultSet"",rs,""Execute"""
	f rowDataj=1:1:paramcnt {
		s paramname=rs.GetParamName(rowDataj)
		s val=$g(%request.Data(("P"_rowDataj),1))
		i $l(val,"""")>1 s val="" f ival=1:1:$l($g(%request.Data(paramname,1)),"""") s $p(val,"""""",ival)=$p(%request.Data(paramname,1),"""",ival)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["DATE" s val=##class(websys.Conversions).DateHtmlToLogical(val)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["TIME" s val=##class(websys.Conversions).TimeHtmlToLogical(val)
		s x=x_","""_val_""""
	}
	s x=x_")"
	x x
	s ^TMPExtRequest("QueryBroker.CQPExecute",%session.SessionId)=x
	s myjsonstr=""
	;
	;判断返回是否ResultSet
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i myIsVal{
		
		d ..GetRSJsonData(rs)
		
		d rs.%Close()
	}
	
	q myjsonstr
}

ClassMethod CQExecute(classname As %String, classquery As %String) As %String
{
	n rs, myrtn, mypageflag,mypagecount
	
	;默认分页
	s mypageflag=1
	s mypagecount=20
	s rs=""
	s myrtn=""
	i ((classname="")||(classquery="")){
		q myrtn
	}
	
	s myIsVal=##class(websys.Conversions).IsValidClassName(classname)
	q:('myIsVal) myrtn
	s myIsVal=##class(websys.Conversions).IsValidQueryName(classname,classquery)
	q:('myIsVal) myrtn
	
	s rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	s paramcnt=rs.GetParamCount()
	n x,ival
	s x="s execstatus=$$InvokeMethod^%apiOBJ(""%ResultSet"",rs,""Execute"""
	f paramj=1:1:paramcnt {
		s paramname=rs.GetParamName(paramj)
		s val=$g(%request.Data(paramname,1))
		i $l(val,"""")>1 s val="" f ival=1:1:$l($g(%request.Data(paramname,1)),"""") s $p(val,"""""",ival)=$p(%request.Data(paramname,1),"""",ival)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["DATE" s val=##class(websys.Conversions).DateHtmlToLogical(val)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["TIME" s val=##class(websys.Conversions).TimeHtmlToLogical(val)
		s x=x_","""_val_""""
	}
 	s x=x_")"
	x x
	s ^TMPExtRequest("QueryBroker.CQExecute")=x
	s myjsonstr=""
	;
	;判断返回是否ResultSet
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i myIsVal{
		d ..GetRSJsonData(rs)
		d rs.%Close()
	}
	
	q myjsonstr
}

ClassMethod GetRSXMLData(rs As %Library.ResultSet) As %String
{
}

ClassMethod GetRSJsonData(rs As %Library.ResultSet) As %String
{
	s mygridobj=##class(web.BDP.ext.entity.GridData).%New()
	s cnt=0
	s displayRows=0
	s rowData=""
	;w "["
	w "{data:[",!
	s columns=rs.GetColumnCount()
	;
	;ext默认的开始是0
	s startRecordNo=+$g(%request.Data("start",1))+1
	s limitRecordCnt=+$g(%request.Data("limit",1))
	
	f  q:rs.Next()=0  d
	.s cnt=cnt+1
	.i ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt=0)  d
	..w:displayRows>0 ","
	..w "{"
	..s rowData=""
	..f columni=1:1:columns  d
	...s:columni>1 rowData=rowData_","
	...s myColName=rs.GetColumnName(columni)
	...s:($ZCVT(myColName,"U")=..#LookupHidden) myColName=..#LookupHidden_columni
	...s rowData=rowData_""""_myColName_""":"		;;rs.GetColumnName(columni)
	...s tmpData=rs.GetData(columni)
	...s tmpData=##class(web.BDP.util.String).EvalList(tmpData)
	...s rowData=rowData_""""_tmpData_""""
	..w rowData
	..w "}",!
	..s displayRows=displayRows+1
	
	w "], success:true"
	w ", total:"_cnt_"}"
	;w "]"
	
	d mygridobj.%Close()
}

/// 自动获取一个RS的输出列表 
/// 返回Json格式
/// 
ClassMethod ReadRS(classname As %String, classquery As %String) As %String
{
	;w ##class(ext.websys.QueryBroker).ReadRS("ext.dataoffer.QueryTest","CTLocData")
	;w ##class(ext.websys.QueryBroker).ReadRS("web.DHCSTDISPSTAT2","GroupLoc")
	;w ##class(ext.websys.QueryBroker).ReadRS("web.SSLanguage","LookUp")
	n (classname,classquery)
	
	s myjosnstr=""
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(classname,classquery,"")	
	
	s mycms=##class(web.BDP.ext.entity.GridModal).%New()
	s myColLen=$l(myOutStr, ",")
	s:(myOutStr="") myColLen=""
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		;s myColumnName=$p(myColStr,":",1)
		s myColumnName=$TR($p(myColStr,":",1)," ","")
		s myColumnType=$p(myColStr,":",2)
		s myColumnCaption=$p(myColStr,":",3)
		
		s mycm=##class(web.BDP.ext.entity.ColumnModel).%New()
		if (($zconvert(myColumnName,"U"))'=..#LookupHidden){
			s mycm.header=$s(myColumnCaption'="":myColumnCaption,1: myColumnName)
			s mycm.dataIndex=myColumnName
			;s mycm.width=100
		}else{
			s mycm.header=..#LookupHidden_myIdx		;$s(myColumnCaption'="":myColumnCaption,1: myColumnName)
			s mycm.dataIndex=..#LookupHidden_myIdx
			s mycm.hidden="true"
		}
		d mycms.cms.Insert(mycm)
		
		s myfn=##class(web.BDP.ext.entity.Field).%New()
		s myfn.name=mycm.dataIndex		;;myColumnName
		d mycms.fns.Insert(myfn)
	}
	
	s myjosnstr=mycms.GetJosnData()
	
	q myjosnstr
}

/// trak lookup的特殊约定
Parameter LookupHidden = "HIDDEN";

}
