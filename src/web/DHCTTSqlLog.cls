Class web.DHCTTSqlLog Extends %RegisteredObject
{

/// @data 2013-06-20
/// @input: {%Date} stDate 更新日期
/// @input: {%Date} endDate 更新日期
/// @input: {%String} token 类型 INSERT UPDATE SELECT DELETE ...
/// @debug d ##class(%ResultSet).RunQuery("web.DHCTTSqlLog","Find",+$h-10,+$h,"")
Query Find(stDate, endDate, token As %String = "") As websys.Query(ROWSPEC = "FirstToken,SQLStatement,StatementTables,UpdateDate,UpdateTime,UserName,AffectedRow,Computer")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, stDate, endDate, token As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    set Computer=""    
    i stDate="" s stDate=+$h
    i endDate="" s endDate=+$h
  	for date = stDate:1:endDate {
	  	set rowid=0
  		set rowid=$o(^User.DHCTTSqlLogI("UpdateDate",date,rowid))
  		set UpdateDate = $zd(date,3)
  		while(+rowid){
	  		set g = ^User.DHCTTSqlLogD(rowid)
	  		set FirstToken = $lg(g,4)
	  		IF (token="")||(FirstToken=token){
		  		set SQLStatement = $lg(g,2)
		  		set StatementTables = $lts($lg(g,3))		  	
		  		set AffectedRow = $lg(g,5)
		  		set UserDr = $lg(g,6)
		  		set UserName = "UserID_"_UserDr
		  		If $d(^SSU("SSUSR",UserDr)) Set UserName = $p(^SSU("SSUSR",UserDr),"^",2)
		  		set UpdateTime = $zt($lg(g,8))
		  		set Computer = $lg(g,9)
		  		set Data = $lb(FirstToken,SQLStatement,StatementTables,UpdateDate,UpdateTime,UserName,AffectedRow,Computer)
		  	  	Set ^CacheTemp(repid,ind)=Data	  		
		 		Set ind=ind+1
	  		}
	  		set rowid=$o(^User.DHCTTSqlLogI("UpdateDate",date,rowid))
	  	} 			  	  
  	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod Save(SQLStatement, StatementTables, FirstToken, AffectRow, UserDR) As %Status
{
	
	#dim logObj As User.DHCTTSqlLog
	Set logObj = ##class(User.DHCTTSqlLog).%New()
	Set logObj.SQLStatement = SQLStatement
	Set logObj.StatementTables = StatementTables 
	Set logObj.FirstToken = FirstToken
	Set logObj.AffectedRow = AffectRow
	Set logObj.Computer = ""
	if $d(%session),$d(%session.Data("LOGON.SSUSERLOGINID"))#2 {
		Set Info = ##class(User.DHCClientLogin).GetInfo(%session.Data("LOGON.SSUSERLOGINID"))
		Set ^Temp("l",2)=Info
		Set logObj.Computer = $p(Info,"^",1)
	}
	
	Set logObj.UserDR = UserDR
	Set logObj.UpdateDate = +$h
	Set logObj.UpdateTime = $p($h,",",2)
	Set sc = logObj.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		Quit ""
	}
	
	Set rowid = logObj.%Id()
	Do logObj.%Close()
	Set logObj = ""
	q rowid
}

ClassMethod SaveBySql(sqlStatement, AffectRow, UserDR)
{
	Set updateSqlObj = ##class(web.Util.DHCPlatformSQLParser).%New(sqlStatement)
	Set sc = ..Save(sqlStatement,updateSqlObj.StatementTables,updateSqlObj.FirstToken,AffectRow,UserDR)
	Set updateSqlObj = ""
	q sc
}

ClassMethod ExecuteSQL(SQLStatement, RuntimeMode, Namespace = "")
{
	ts
	Set CuNS = $Namespace
	Set $Namespace = Namespace
	set tStatement = ##class(%SQL.Statement).%New(RuntimeMode)
	do tStatement.prepare(.SQLStatement)
	set tResult = tStatement.%Execute()	
	Set $Namespace = CuNS	
	if tResult.%SQLCODE<0{
		tro
		do tResult.%Display()
	}else{
		set sc=##class(web.DHCTTSqlLog).SaveBySql(SQLStatement,tResult.%ROWCOUNT,%session.Data("LOGON.USERID"))
		i sc="" tro  w "Insert Log Error!"
		e  do tResult.%Display() tc
	}
	Set tResult=""
	Set tStatement="" 
	quit $$$OK
}

ClassMethod SelectToExcel(SQLStatement, RuntimeMode, Namespace = "", ExcelName = "")
{

	Set excelDir = "\temp\excel\"
	if ($p(ExcelName,".",$l(ExcelName,"."))="csv") { 	
	}else{
		Set ExcelName = ExcelName_".csv"
	}
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){ d ##class(%File).CreateDirectory(PhyDir) }
	Set $ZE = "SelectToExcelError"
	Set CuNS = $Namespace
	Set $Namespace = Namespace
	Set query = ##class(%ResultSet).%New()
	Set query.RuntimeMode=RuntimeMode
	Set %sc = query.Prepare(SQLStatement,0,"RUNTIME")
	If (+%sc=0) { Set $Namespace = CuNS Quit $system.Status.GetErrorText(%sc)}
	Set %sc = query.Execute()
	If (+%sc=0) {Set $Namespace = CuNS Quit $system.Status.GetErrorText(%sc)}	
	Set columns = query.GetColumnCount()
	if (columns>0){
		Set ROWCOUNT=0
		Set io=$io  			;记录当前的输出设备
		Set FileAllName = PhyDir_ExcelName
		Open FileAllName:("NWRS"):10
		Use FileAllName  			;到文件流中
		For i=1:1:columns Write query.GetColumnHeader(i)_","
		try{
			while(query.Next()){
				Write !
				For i=1:1:columns {
					Set val = query.GetData(i)
					/// ##class(ext.util.String). 其它名字空间没有此类
					i val["," Write """"_$Replace(val,"""","""""")_""","
					e  Write val_","
				}
				Set ROWCOUNT = ROWCOUNT+1
			}
		}catch(ex){
			Write $ZERROR
			//Set ^Wanghc("toExcel",$I(^Wanghc),"$ZERROR")=$ZERROR
		}
		Close FileAllName
		Use io  ;回到原来输出设备
		Set rs =""
	}
	Set $Namespace = CuNS
	Set tStatement=""
	set sc=##class(web.DHCTTSqlLog).SaveBySql(SQLStatement,ROWCOUNT,%session.Data("LOGON.USERID"))
	i sc="" {
		Quit "Export Excel Write Log Error!"
	}
	Quit "websys.file.utf8.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(ExcelName)_"&dirname="_PhyDir_"&servertype=HTTP"
	quit ""
SelectToExcelError
	Set $Namespace = CuNS
	Set err = $ze
	Set $zt=""
	Quit err
}

ClassMethod SelectToExcelBySQLStat(SQLStatement, RuntimeMode, Namespace = "", ExcelName = "")
{

	Set excelDir = "\temp\excel\"
	if ($p(ExcelName,".",$l(ExcelName,"."))="csv") { 	
	}else{
		Set ExcelName = ExcelName_".csv"
	}
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){ d ##class(%File).CreateDirectory(PhyDir) }
	
	Set CuNS = $Namespace
	Set $Namespace = Namespace
	set tStatement = ##class(%SQL.Statement).%New(RuntimeMode)
	do tStatement.%Prepare(.SQLStatement)
	#dim rs as %SQL.StatementResult
	set rs = tStatement.%Execute()
	if rs.%SQLCODE<0{
		do rs.%Display()
		Set rs=""
		Set tStatement=""
	}else{
		//0	XML,1	HTML,2	PDF (requires a renderer such as FOP),99	TXT
		//d rs.%DisplayFormatted(2, "ExcelNameABCD", .pMessages)
		//D $SYSTEM.OBJ.Dump(rs)
		Set columns = rs.%ResultColumnCount
		if (columns>0){
			Set columnsObj = rs.%GetMetadata().columns
			Set ROWCOUNT=0
			Set io=$io  ;记录当前的输出设备
			Set FileAllName = PhyDir_ExcelName
			Open FileAllName:("NWRS"):10
			;Set File = ##class(%File).%New(PhyDir_ExcelName)
			;do File.Open("NWRS") 
			Use FileAllName  ;到文件流中
			;d rs.%Display(",")  // 列头没有用,分割  ，会自动处理数据中包含,的情况
			For i=1:1:columns Write columnsObj.GetAt(i).colName_","
			while(rs.%Next()){
				Set obj = rs.%CurrentResult
				if (obj){
					//D $SYSTEM.OBJ.Dump(obj)
					Write !
					For i=1:1:columns {
						Set val = $PROPERTY(obj,columnsObj.GetAt(i).colName)
						i val["," Write """"_##class(ext.util.String).Replace(val,"""","""""")_""","
						e  Write val_","
					}
				}
			}
			Close FileAllName
			Use io  ;回来原来输出设备
			;Do File.Flush()
			;Do File.%Save()
			;Do File.Close()
			;Set File=""
			Set rs =""
		}
		Set $Namespace = CuNS
		Set tStatement=""
		set sc=##class(web.DHCTTSqlLog).SaveBySql(SQLStatement,ROWCOUNT,%session.Data("LOGON.USERID"))
		
		i sc="" {
			w "Export Excel Write Log Error!"
		}
		Quit "websys.file.utf8.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(ExcelName)_"&dirname="_PhyDir_"&servertype=HTTP"
	}
	quit ""
}

/// @param: {%String} name 
/// @param: {%String} codes 
/// @param: {%String} descs  如果为空刚默认为值等于codes
/// @param: {%String} selectedValue 当前选中的元素的值
/// @param: {%String} defaultValue 默认选中的值
/// @param: {%Int} size select的长度
/// 
/// d ##class(web.DHCTTSqlLog).CoustomSelect("token",",SELECT,UPDATE,INSERT","",$g(%request.Data("token",1)),"",1)
/// d ##class(web.DHCTTSqlLog).CoustomSelect("Type",",SELECT,UPDATE,INSERT","全部,查询,更新,插入",$g(%request.Data("Type",1)),"",1)
ClassMethod CoustomSelect(name, codes, descs, selectedValue As %String = "", defaultValue As %String = "", size As %String = 1)
{
	q:name="" -1
	q:codes="" -1
	i selectedValue="" s selectedValue=defaultValue
	if descs="" s descs=codes
	w "<select id='"_name_"' name='"_name_"' size='"_size_"'>"
	set len = $l(codes,",")
	f j=1:1:len {
		set code = $p(codes,",",j), desc = $p(descs,",",j)
		w "<option value='"_code_"' "_$s(selectedValue=code:"selected" ,1:"")_">"_desc_"</option>"
	}
	w "</select>"
	q 0
}

ClassMethod TokenList(id)
{
	set selectedValue = $g(%request.Data(id,1))
	q ..CoustomSelect(id,",SELECT,UPDATE,INSERT,DELETE","",selectedValue)
}

ClassMethod StatementTableItem(name, rowNumber, sql)
{
	 w "<label id="""_name_"z"_rowNumber_""" name="""_name_"z"_rowNumber_""">"_##class(web.Util.DHCPlatformSQLParser).GetSqlHtmlBySql(sql)_"</label>" 
	 q 0
}

}
