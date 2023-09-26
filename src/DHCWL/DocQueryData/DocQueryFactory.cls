Class DHCWL.DocQueryData.DocQueryFactory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 返回表的记录总数
/// w ##class(DHCWL.DocQueryData.DocQueryFactory).GetTableCount("DHCWL.MSingle.Stock")
ClassMethod GetTableCount(className As %String) As %String
{
        s tableName=##class(DHCWL.util.GetSetService).GetTableName(className)  
	    s sql = "SELECT count(*) cNum FROM "_tableName
 		s rs = ##class(%Library.ResultSet).%New()
 		s sc = rs.Prepare(sql)
 		s sc = rs.Execute()
 		While(rs.Next()){
			s count = rs.Data("cNum")
 		}
		d rs.Close()
		q count
}

/// 返回表的记录总数带条件的
/// w ##class(DHCWL.DocQueryData.DocQueryFactory).GetTableConditionsCount("DUH.Stock.StockBase","ID,stockCode,stockOpdisk,stockCldisk,stockName,stockLow,stockHeight,stockWeave,stockPerlow,stockPerheight,stockDate,stockPrelow,stockPreheight,stockKline,stockHand","^DOC001^^^^")
ClassMethod GetTableConditionsCount(className As %String, jsonPros As %String, str As %String) As %String
{
	n (className,jsonPros,str)
	//s className = "DHCWL.DocQuery.DocKpiDef"
	//s jsonPros = "ID,MDocKPIDefCode,MDocKPIDefDesc,MDocKPIUpdateDate,MDocKPIDefClass,MDocKPIDefCategory"
	s sqlFields=##class(DHCWL.util.GetSetService).MapFildFromClassProByStr(className,jsonPros)
    s tableName=##class(DHCWL.util.GetSetService).GetTableName(className) 
    s cons = ##class(DUH.Stock.Dao.DaoFactory).SpellStr(className,jsonPros,str) 
    i cons'="" s sql = "SELECT count(*) cNum FROM "_tableName_" where "_cons
    e  s sql = "SELECT count(*) cNum FROM "_tableName
 	s rs = ##class(%Library.ResultSet).%New()
 	s sc = rs.Prepare(sql)
 	s sc = rs.Execute()
 	While(rs.Next()){
		s count = rs.Data("cNum")
 	}
	d rs.Close()
	q count
}

/// 返回global遍历到的第几条~第几条记录ID
/// w ##class(DHCWL.DocQueryData.DocQueryFactory).GetSearchID(0,10)
ClassMethod GetSearchID(start As %Integer, end As %Integer) As %String
{
	n (start,end)
	k page
	s total = (end-start+1)
	s tNum = 0
	i start=1  d
	.s tempId = 0  f  s tempId=$o(^DHCWL.MSingle.StockD(tempId)) q:tempId=""  d
	..q:(tNum>total)
    ..s page(tempId)=""   //把start到end 的id拿到
    ..s tNum = $g(tNum)+1
    e  d
    .s tempId = 0  f  s tempId=$o(^DHCWL.MSingle.StockD(tempId)) q:tempId=""  d
    ..s tNum = $g(tNum)+1
	..q:(tNum<start)
    ..s page(tempId)=""   //把start到end 的id拿到
	s ids = "" s tId = 0 f  s tId = $o(page(tId))  q:tId=""  d
	.s ids = ids_tId_","  // 1,2,3,4
	s ids=$e(ids,1,$l(ids)-1)
	k page
	q ids
}

//解析csp中过来的字符串

//"demo1^demo2^demo3^2015-11-12^demo4^demo5"

ClassMethod AnalysisUpArrow(str As %String) As %String
{
	//s sqlFields=##class(DHCWL.util.GetSetService).MapFildFromClassProByStr("DHCWL.MSingle.Project","proCode")
    //s tableName=##class(DHCWL.util.GetSetService).GetTableName("DHCWL.MSingle.Project")
	//s regex = "\d{4}-\d{2}-\d{2}"
	s len = $l(str,"^")
	f i = 1:1:len  d
	.s varI = $p(str,"^",i)
}

/// 返回拼接字符串
/// w ##class(DHCWL.DocQueryData.DocQueryFactory).SpellStr("DUH.Stock.StockBase","ID,stockCode,stockOpdisk,stockCldisk,stockName,stockLow,stockHeight,stockWeave,stockPerlow,stockPerheight,stockDate,stockPrelow,stockPreheight,stockKline,stockHand","^^^^^^^^^^^^^^")
ClassMethod SpellStr(className As %String, jsonPros As %String, str As %String) As %String
{
 n (className,jsonPros,str)
 s sqlFields=##class(DHCWL.util.GetSetService).MapFildFromClassProByStr(className,jsonPros)
 s tableName=##class(DHCWL.util.GetSetService).GetTableName(className)
 s length = $l(str,"^")
 i $p(str,"^",1)'="" s cons = $p(sqlFields,",",1)_"= '"_$p(str,"^",1)_"' and "
 f tp=2:1:length  d
 .i tp'=length  d
 ..i ($p(str,"^",tp)'="") s cons = $g(cons)_$p(sqlFields,",",tp)_" like '%"_$p(str,"^",tp)_"%' and "
 .e   d
 ..i ($p(str,"^",tp)'="") s cons = $g(cons)_$p(sqlFields,",",tp)_" like '%"_$p(str,"^",tp)_"%'"
 ..e  d
 ...s conLen = $l($g(cons))
 ...s cons = $e($g(cons),1,conLen-4)
 q cons
}

/// w ##class(DHCWL.DocQueryData.DocQueryFactory).GetConditionID("DUH.Stock.StockBase","ID,stockCode,stockOpdisk,stockCldisk,stockName,stockLow,stockHeight,stockWeave,stockPerlow,stockPerheight,stockDate,stockPrelow,stockPreheight,stockKline,stockHand","^^^^^^^^^^^^^^")
ClassMethod GetConditionID(str As %String)
{
	n (str)
	k ^TEMPDHCWLDUH
	s rs = ##class(%Library.ResultSet).%New()
 		s sc = rs.Prepare(str)
 		s sc = rs.Execute()
 		While(rs.Next()){
 			s ID=rs.Data("ID") 	
 			s ^TEMPDHCWLDUH("condition",ID) = ""		
 		}
}

/// w ##class(DHCWL.DocQueryData.DocQueryFactory).GetConditionID("DUH.Stock.StockBase","ID,stockCode,stockOpdisk,stockCldisk,stockName,stockLow,stockHeight,stockWeave,stockPerlow,stockPerheight,stockDate,stockPrelow,stockPreheight,stockKline,stockHand","^^^^^^^^^^^^^^")
ClassMethod GetConditionCount(str As %String) As %String
{
	n (str)
	s rs = ##class(%Library.ResultSet).%New()
 		s sc = rs.Prepare(str)
 		s sc = rs.Execute()
 		While(rs.Next()){
 			s cnt=rs.Data("cnt") 	
 					
 		}
 	q cnt
}

}
