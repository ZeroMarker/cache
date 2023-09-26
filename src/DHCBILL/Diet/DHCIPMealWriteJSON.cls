Import sqluser

/// Lid
/// 2010-04-29
/// JSON数据生成器
Class DHCBILL.Diet.DHCIPMealWriteJSON Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock ]
{

/// 通过Query生成JSON数据
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealType","FindMealType",5,5)
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealItm","FindMealItem",0,5,"mt")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealModality","FindMealModality",0,5,"","Y")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealItm","FindMealAlias",0,0,"15")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealCreateMenu","FindMealDeatil",0,15,"","2010-05-24")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealCreateMenu","FindMenuInfo",0,15,"","","","")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONDataByQuery("DHCBILL.Diet.DHCIPMealMenuLogic","GetWeekByMenuStDate",0,0,"2010-08-09")
ClassMethod WriteJSONDataByQuery(ClassName As %String, QueryName As %String, Start As %String = "", Limit As %String = "", p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
    New pcount Set pcount=$zutil(141)-4
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	Xecute execute
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
    
    q ..WriteJSONDataByResult(rset,Start,Limit)
}

/// 通过数据集Result生成JSON数据
ClassMethod WriteJSONDataByResult(rset As %ResultSet, Start As %String = "", Limit As %String = "") As %String
{
	   q:rset="" ""
	   
	   Set columns = rset.GetColumnCount()
       s myIdx=0,ind=0  ;计数器
	   s rowStr="["
       While (rset.Next()) {
	        s i=1
	        s myIdx=myIdx+1   ;累计总行数
	        i (+Limit>0)&&((ind<(+Start))!(ind>((+Start)+(+Limit)-1))) s ind=ind+1 continue  ;分页设置
	        s ind=ind+1
	        i rowStr="[" s tmp="{" 
	        e  s tmp=",{"
	        
	        f i=1:1:columns d
	        .s colName=rset.GetColumnName(i)
	        .s value=rset.Data(colName)	 
	        .i (tmp="{")!(tmp=",{") s tmp=tmp_"'"_colName_"':'"_value_"'"
	        .e  s tmp=tmp_","_"'"_colName_"':'"_value_"'" 
	  		s tmp=tmp_"}"
	  		s rowStr=rowStr_tmp
	  }
	  s rowStr=rowStr_"]"
	  s rtn="{totalCount:"_myIdx_",results:"_rowStr_"}" 
	  
	  q rtn
}

/// 生成JSON数据,用于动态生成列
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONStoreStrByQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindMealBookInfoByDate","",0,0,"2010-04-22","6")
ClassMethod WriteJSONStoreByResult(rset As %ResultSet, ColumnNameList As %String, Start As %String = "", Limit As %String = "") As %String
{
	   q:rset="" ""
	    Set columns = rset.GetColumnCount()
	    s ColumnNameList=""
	    s flag=0
	    While (rset.Next()) {
			f i=1:1:columns d  q:value=""
	        .s colName=rset.GetColumnName(i)
	        .s value=rset.Data(colName)
	        .i ColumnNameList="" s ColumnNameList=value
	        .e  s ColumnNameList=ColumnNameList_"^"_value
	        q
		}
	   b ;adfdf
	   s colSize=+$l(ColumnNameList,"^")-1
	   b
       s myIdx=0,ind=0  ;计数器
	   s rowStr="["     ;数据
	   s cmStr="["  ;列头
	   s fieldName="[" ;字段
	   s flag=1  ;开关(用于判断是否为第一行)
       While (rset.Next()) {
	        
	        s i=1
	        s myIdx=myIdx+1   ;累计总行数
	        i (+Limit>0)&&((ind<(+Start))!(ind>((+Start)+(+Limit)-1))) s ind=ind+1 continue  ;分页设置
	        s ind=ind+1
	        i rowStr="[" s tmp="{" 
	        e  s tmp=",{"
	        	        
	        f i=1:1:columns d
	        .q:i>colSize 
	        .;数据
	        .s colName=rset.GetColumnName(i)
	        .s value=rset.Data(colName)	 
	        .i (tmp="{")!(tmp=",{") s tmp=tmp_"'"_colName_"':'"_value_"'"
	        .e  s tmp=tmp_","_"'"_colName_"':'"_value_"'" 
	        .
	        .i flag=1 d
	        ..;列类型
            ..i fieldName="[" s fieldName=fieldName_"{'"_"name"_"':'"_colName_"'"_"}"
            ..e  s fieldName=fieldName_",{"_"'"_"name"_"':'"_colName_"'"_"}"	      
  	        ..;列模型
  	        ..i cmStr="[" s cmStr=cmStr_"new Ext.grid.RowNumberer(),{'"_"header"_"':'"_$p(ColumnNameList,"^",i)_"',dataIndex:"_"'"_colName_"'}"
            ..e  s cmStr=cmStr_",{"_"'"_"header"_"':'"_$p(ColumnNameList,"^",i)_"',dataIndex:"_"'"_colName_"'}"      

	  		s tmp=tmp_"}"
	  		s rowStr=rowStr_tmp
	  		s flag=2
	  }
	  s rowStr=rowStr_"]"
	  s data="data:"_rowStr   ;数据记录json串
	  
	  s fieldName="fieldsNames:"_fieldName_"]"
	  s columModle="columModle:"_cmStr_"]"
	  
      b ;1new Ext.grid.RowNumberer(),
	  s rtn="{totalCount:"_myIdx_","_data_","_columModle_","_fieldName_"}"
	  //s rtn="{"_data_","_columModle_","_fieldName_"}" 
	  b ;2
	  q rtn
}

/// 生成JSON数据,用于动态生成列
ClassMethod WriteJSONStoreByResultOLD(rset As %ResultSet, ColumnNameList As %String, Start As %String = "", Limit As %String = "") As %String
{
	   q:rset="" ""
	   
	   s colSize=+$l(ColumnNameList,"^")
	   
	   Set columns = rset.GetColumnCount()
       s myIdx=0,ind=0  ;计数器
	   s rowStr="["     ;数据
	   s cmStr="["  ;列头
	   s fieldName="[" ;字段
	   s flag=0  ;开关(用于判断是否为第一行)
       While (rset.Next()) {
	        s i=1
	        s myIdx=myIdx+1   ;累计总行数
	        i (+Limit>0)&&((ind<(+Start))!(ind>((+Start)+(+Limit)-1))) s ind=ind+1 continue  ;分页设置
	        s ind=ind+1
	        i rowStr="[" s tmp="{" 
	        e  s tmp=",{"
	        	        
	        f i=1:1:columns d
	        .q:i>colSize 
	        .;数据
	        .s colName=rset.GetColumnName(i)
	        .s value=rset.Data(colName)	 
	        .i (tmp="{")!(tmp=",{") s tmp=tmp_"'"_colName_"':'"_value_"'"
	        .e  s tmp=tmp_","_"'"_colName_"':'"_value_"'" 
	        .
	        .i flag=0 d
	        ..;列类型
            ..i fieldName="[" s fieldName=fieldName_"{'"_"name"_"':'"_colName_"'"_"}"
            ..e  s fieldName=fieldName_",{"_"'"_"name"_"':'"_colName_"'"_"}"	      
  	        ..;列模型
  	        ..i cmStr="[" s cmStr=cmStr_"new Ext.grid.RowNumberer(),{'"_"header"_"':'"_$p(ColumnNameList,"^",i)_"',dataIndex:"_"'"_colName_"'}"
            ..e  s cmStr=cmStr_",{"_"'"_"header"_"':'"_$p(ColumnNameList,"^",i)_"',dataIndex:"_"'"_colName_"'}"      

	  		s tmp=tmp_"}"
	  		s rowStr=rowStr_tmp
	  		s flag=1
	  }
	  s rowStr=rowStr_"]"
	  s data="data:"_rowStr   ;数据记录json串
	  
	  s fieldName="fieldsNames:"_fieldName_"]"
	  s columModle="columModle:"_cmStr_"]"
	  
      b ;1new Ext.grid.RowNumberer(),
	  s rtn="{totalCount:"_myIdx_","_data_","_columModle_","_fieldName_"}"
	  //s rtn="{"_data_","_columModle_","_fieldName_"}" 
	  b ;2
	  q rtn
}

/// 动态生成列
/// //w "{'data':[{'number':'333','text1': '0.3','info1': '4','special1': '2010-01-01'}],'columModle':[{'header': '序号','dataIndex': 'number','width':40},{'header': '编码','dataIndex': 'text1'},{'header': '名称','dataIndex': 'info1'},{'header': '金额','dataIndex': 'special1'}],'fieldsNames':[{name: 'number'},{name: 'text1'}, {name: 'info1'},{name: 'special1'}]}"
/// DHCBILL.Diet.DHCIPMealBookMealPrint.FindMealBookInfoByDate
/// GetMealColumnName
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONStoreStrByQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindMealBookInfoByDate","病区^馒头^西红柿^红烧鱼^宫保鸡丁",0,0,"2010-05-13","6")
/// w ##class(DHCBILL.Diet.DHCIPMealWriteJSON).WriteJSONStoreStrByQuery("DHCBILL.Diet.DHCIPMealBookMealPrint","FindMealBookInfoByDate","",0,0,"2010-05-13","6")
ClassMethod WriteJSONStoreStrByQuery(ClassName As %String, QueryName As %String, ColumnNameList As %String, Start As %String = "", Limit As %String = "", p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
	 New pcount Set pcount=$zutil(141)-5
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	Xecute execute
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
    
    q ..WriteJSONStoreByResult(rset,ColumnNameList,Start,Limit)
}

/// date:   2010-12-13
/// author: wanghc
/// @param: className 
/// @param: QueryName 
/// @param: Start  从Start行开始输出 
/// @param: Limit  一共输出Limit行
/// @param: query的参数
/// 
/// @desc:    
/// Query自带Header是界面上的cm->header
/// Query的第一个行数据,默认为列名----用返回串会超长
/// fieldsNames:[{name:Query.GetColumnName()}]   columModle:[{header:'query第一行的值',dataIndex:'Query.GetColumnName()'}]
/// 			data:[{columnName:value,columnName:value,columnName():value}]  -->打印列是通过第一行数据决定
ClassMethod CreateGridJsonByQuery(ClassName As %String, QueryName As %String, Start As %String = 0, Limit As %String = 10, p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
	 New pcount Set pcount=$zutil(141)-4
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	Xecute execute
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
    d ..CreateGridJsonByResult(rset,Start,Limit)
}

/// 一行输出 不是通过返回串
/// author: wanghc
ClassMethod CreateGridJsonByResult(rset As %ResultSet, Start As %String = 0, Limit As %String = 10) As %String
{
		q:rset="" ""
		Set columns = rset.GetColumnCount()
		;默认第一行为列名   
		;aa^bb^^cc第一行为空的不输出 只输出aa bb cc
		s ColumnNumberStr="" ; 要输出的列号串
		s ColumnNameList=""  
		s cmStr="["  ;列头
	    s fieldName="[" ;字段
		d rset.Next()
		f i=1:1:columns d
		.s colName=rset.GetColumnName(i)
		.s value=rset.GetData(i)
		.q:value=""
		.i ColumnNumberStr ="" s ColumnNumberStr=i,ColumnNameList=value
		.e  s ColumnNumberStr=ColumnNumberStr_"^"_i,ColumnNameList=ColumnNameList_"^"_value
		.;列类型
	    .i fieldName="[" s fieldName=fieldName_"{name:'"_colName_"'"_"}"
	    .e  s fieldName=fieldName_",{name:'"_colName_"'"_"}"	      
	    .;列模型
	    .i cmStr="[" s cmStr=cmStr_"new Ext.grid.RowNumberer(),{header:'"_value_"',dataIndex:"_"'"_colName_"'}"
	    .e  s cmStr=cmStr_",{header:'"_value_"',dataIndex:"_"'"_colName_"'}"      
	   	s fieldName="fieldsNames:"_fieldName_"]"
	  	s columModle="columModle:"_cmStr_"]"
	   
	   w "{"_fieldName_","_columModle_","
	   s columModle="columModle:"_cmStr_"]"
	   s gridColumnNum=$l(ColumnNumberStr,"^")
	   s totalCount=0
	   w "data:["
	   s printLine=0
       While (rset.Next()) {
	        s totalCount=totalCount+1   ;累计总行数
	        q:(+Start'=0)&&(totalCount<Start)
	        q:(totalCount>=(Start+Limit))&&(+Limit'=0)
	        s dataTmpStr=""
	        f i=1:1:gridColumnNum d
	        .s colName=rset.GetColumnName(+$p(ColumnNumberStr,"^",i))
	        .s value=rset.GetData(+$p(ColumnNumberStr,"^",i))	 
	        .i dataTmpStr="" s dataTmpStr=dataTmpStr_""_colName_":'"_value_"'"
	        .e  s dataTmpStr=dataTmpStr_","_""_colName_":'"_value_"'" 
	  		s printLine=printLine+1 		
	  		i printLine=1 w "{"_dataTmpStr_"}"
	  		e  w ",{"_dataTmpStr_"}"
	  		
	  }
	  w "]"
	  w ",totalCount:"_totalCount_"}"	
	  d rset.%Close()
	  q ""
}

/// 一行一行打印 不会字符串超长
/// author :wanghc
/// date:2010-12-15
ClassMethod WriteJSONDataByQueryNew(ClassName As %String, QueryName As %String, Start As %String = "", Limit As %String = "", p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
    New pcount Set pcount=$zutil(141)-4
	Set rset=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$zobjmethod(rset,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	Xecute execute
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
    d ..WriteJSONDataByResultNew(rset,Start,Limit)
}

/// 一行一行打印 不会字符串超长
/// author :wanghc
/// date:2010-12-15
ClassMethod WriteJSONDataByResultNew(rset As %ResultSet, Start As %String = "", Limit As %String = "") As %String
{
	   q:rset="" ""
	   Set columns = rset.GetColumnCount()
	   w "{results:["
       s printLine=0,totalCount=0,ind=0  ;计数器
       While (rset.Next()) {
	        s totalCount=totalCount+1   ;累计总行数
	        ;i (+Start'=0)&&(totalCount<Start) continue
	        ;i (totalCount>=(Start+Limit))&&(+Limit'=0) continue
	        i (+Limit>0)&&((ind<(+Start))!(ind>((+Start)+(+Limit)-1))) s ind=ind+1 continue  ;分页设置
	        s ind=ind+1
	        s dataTmpStr=""
	        f i=1:1:columns d
	        .s colName=rset.GetColumnName(i)
	        .s value=rset.GetData(i)	 
	        .i dataTmpStr="" s dataTmpStr=dataTmpStr_""_colName_":'"_value_"'"
	        .e  s dataTmpStr=dataTmpStr_","_""_colName_":'"_value_"'" 
	  		s printLine=printLine+1 		
	  		i printLine=1 w "{"_dataTmpStr_"}"
	  		e  w ",{"_dataTmpStr_"}"
	  }
	  w "],totalCount:"_totalCount_"}"
	  d rset.%Close()
	  q ""
}

}
