Class dhc.qm.udata.uCheckPointMake Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wjt
/// CreatDate:2015-7-22
/// Description:
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:返回检查项目
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).List("","",0,25)	
ClassMethod List(sortField, sortDir, start, limit) As %String
{
		
	n (sortField, sortDir, start, limit)
	s sqlStr = "SELECT QMSchem_RowID,QMSchem_Code,QMSchem_name,QMSchem_Arcitem as arc,QMSchem_active, QMSchem_periodType, QMSchem_importType, QMSchem_dataType FROM dhc_qm_data.QMSchem WHERE %ID>'0'"
	;s zuhe="QMSchem_Arcitem"_","_"QMSchem_Arcitem"
	;s sqlStr = "SELECT qm.QMSchem_RowID,qm.QMSchem_Code,qm.QMSchem_name,ai.ARCIM_Abbrev as arc FROM dhc_qm_data.QMSchem qm,arc_itmmast ai WHERE qm.QMSchem_Arcitem IN (ai.ARCIM_RowId) AND qm.%ID>'0' "
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="rowid^schemcode^schemname^linker^schemeType^importType^checkType^active" 
	while(result.Next())
	{
		s rowid=result.Data("QMSchem_RowID")
		s qmSCode=result.Data("QMSchem_Code")
		s qmSName=result.Data("QMSchem_name")
		s qmSAritem=result.Data("arc")
		s qmSAritem=..Listarcname(qmSAritem)
			
		s active=result.Data("QMSchem_active")
		s schemeType=result.Data("QMSchem_periodType")
		s importType=result.Data("QMSchem_importType")
		s checkType=result.Data("QMSchem_dataType")
		
		s tem=rowid_"^"_qmSCode_"^"_qmSName_"^"_qmSAritem_"^"_schemeType_"^"_importType_"^"_checkType_"^"_active
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// others: w ##class(dhc.qm.udata.uCheckPointMake).Listarcname("10002||1,10003||1")
ClassMethod Listarcname(arc) As %String
{
 
	n (arc)
	
	s arc=..MyArray(arc)
	s sqlStr = "SELECT %id,arcim_desc FROM arc_itmmast WHERE %id IN ("_arc_")"

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()

	s resultString="" 

	while(result.Next())
	{
		s resultString=resultString_","_result.Data("ARCIM_Desc")

	}

	q $E(resultString,2,$L(resultString))
}

/// w ##class(dhc.qm.udata.uCheckPointMake).Listright("","",0,25,5)	
ClassMethod Listright(sortField, sortDir, start, limit, schemcode) As %String
{
	n (sortField,sortDir,start,limit,schemcode)
	
    s sqlStr="SELECT qd.QMSchemDetail_rowid,qd.QMSchemDetail_order,qd.QMSchemDetail_CheckDr->Check_spcil as spcil,qd.QMSchemDetail_CheckDr->Check_name as name FROM dhc_qm_data.QMSchemDetail qd,dhc_qm_data.QMSchem qms "
            _"WHERE qms.QMSchem_RowID = qd.QMSchemDetail_parRef AND qd.QMSchemDetail_parRef =  "_schemcode
    
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name^no^singleno"
	While(result.Next())
	{   
		s RowId= result.Data("QMSchemDetail_rowid")
		s Code= result.Data("QMSchemDetail_order")
		s name= result.Data("name")
		s singleno= result.Data("spcil")
		
		i singleno="Y"   s singleno="单项否决"
		i singleno="N"   s singleno="非单项否决"
		s tmp=RowId_"^"_name_"^"_Code_"^"_singleno
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.qm.udata.uCheckPointMake).CheckList("","",0,25,"8",1)	 
ClassMethod CheckList(sortField, sortDir, start, limit, schemId, importType) As %String
{
	n (sortField, sortDir, start, limit,schemId,importType)	
		
	/*20160518 cyl add
	*根据schemid 得到改方案的间所有检查点
	*然后筛选掉已有的检查点
	*/
	
	
	s sqlStr="select Check_rowid,Check_name from dhc_qm_data.CheckInfo where %ID>'0' "
			_" and Check_rowid not in("
				_"SELECT qd.QMSchemDetail_CheckDr  FROM dhc_qm_data.QMSchemDetail qd,dhc_qm_data.QMSchem qms "
           		_"WHERE qms.QMSchem_RowID = qd.QMSchemDetail_parRef AND qd.QMSchemDetail_parRef ="_schemId_")"
    i importType=2  s sqlStr=sqlStr_" and Check_colType in (1,4)"
	e  	s sqlStr=sqlStr_" and Check_colType in (2,3)"	 	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="groupRowid^groupName" 
	while(result.Next())
	{
		s groupRowid=result.Data("Check_rowid")
		s groupName=result.Data("Check_name")	
		s tem=groupRowid_"^"_groupName
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator:wjt
/// CreatDate:2015-7-22
/// Description:
/// Table:arc_itmmast
/// Output:
/// Return:返回医嘱的字符串
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).Listcheckproj("","",0,25,"气管")	
ClassMethod Listcheckproj(sortField, sortDir, start, limit, fuzzyquery) As %String
{
 
	n (sortField, sortDir, start, limit,fuzzyquery)
	
	
	s sqlStr = "SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_EffDateTo FROM arc_itmmast WHERE %ID>'0'"
	i fuzzyquery'=""  s sqlStr=sqlStr_" and ARCIM_Desc like '"_fuzzyquery_"%' and (ARCIM_EffDateTo>='"_$p($h,",",1)_"' or ARCIM_EffDateTo is null )"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="Rowid^name" 
	while(result.Next())
	{
		s arcRowid=result.Data("ARCIM_RowId")
		s arcName=result.Data("ARCIM_Desc")
		s dateTo=result.Data("ARCIM_EffDateTo")	
		s tem=arcRowid_"^"_arcName
		s count=count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tem)
		
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator:wjt
/// CreatDate:2015-7-22
/// Description:
/// Table:dhc_qm_data.CheckInfo
/// Output:
/// Return:删除检查点的字符串
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).Delete(1)	
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM dhc_qm_data.QMSchem WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator:wjt
/// CreatDate:2015-7-22
/// Description:
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:插入医嘱的字符串
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).QmSInsert()
ClassMethod QmSInsert(schemcode, schemname, linker) As %String
{
	n (schemecode,schemname,linker)
	&sql(insert into dhc_qm_data.QMSchem(QMSchem_Code,QMSchem_name,QMSchem_Arcitem) values(:schemecode,:schemname,:linker))
	q SQLCODE
}

/// Creator:wjt
/// CreatDate:2015-7-22
/// Description:
/// Table:dhc_qm_data.QMSchem
/// Output:
/// Return:修改医嘱的字符串
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).QmSUpdate(30,"26","项目26","11350||1,11351||1,11352||1,11353||1,11354||1,11355||1,11356||1,11357||1,11358||1,10008||1,1000||1,10468||1,10011||1,10014||1")
ClassMethod QmSUpdate(rowid, schemecode, schemname, linker, schemeType, importType, checkType, active) As %String
{
	n (rowid,schemecode,schemname,linker,schemeType,importType,checkType,active)
	
	i schemecode = ""    s schemecode=$list(^DHCCJXQMQMSchemD(rowid),2)
	i schemname = ""     s schemname=$list(^DHCCJXQMQMSchemD(rowid),3)
	i linker = ""        s linker=$list(^DHCCJXQMQMSchemD(rowid),7)
	i schemeType = ""    s schemeType=$list(^DHCCJXQMQMSchemD(rowid),8)
	i importType = ""    s importType=$list(^DHCCJXQMQMSchemD(rowid),9)
	i checkType = ""     s checkType=$list(^DHCCJXQMQMSchemD(rowid),10)
	i active =""         s active=$list(^DHCCJXQMQMSchemD(rowid),6)   
	
	//判编码和名称重复 20160518 cyl add
	s isRef=..IfRepSchem(schemecode,schemname,rowid)
	
	s isPc=..importTypeTT(rowid,importType)
	if (isRef="")&&(isPc=""){
		&SQL(update dhc_qm_data.QMSchem set QMSchem_Code=:schemecode,QMSchem_name=:schemname,QMSchem_Arcitem=:linker,
		QMSchem_active=:active,QMSchem_periodType=:schemeType, QMSchem_importType=:importType, QMSchem_dataType=:checkType where %ID=:rowid)
		s linker=..Listarcname(linker)
		s returnStr=SQLCODE
	}else{
		s returnStr=isRef_"^"_isPc
	}
	q returnStr
}

ClassMethod checkdel(rowid) As %String
{
	
	n (rowid)
	&SQL(DELETE FROM dhc_qm_data.QMSchemDetail WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: wjt
/// CreatDate:  2015-07-28
/// Description: 插入检查点新记录
/// Table: dhc.qm.data.SchemDetail
/// Input: data-待插入的数据(name^code^active)
/// Output: 
/// Others: w ##class(dhc.qm.udata.uCheckPointMake).Add("")
/// w ##class(dhc.qm.udata.uCheckPointMake).Add("1,2,3^1^6")
ClassMethod Add(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s mysq="重复添加"
		s checkdrs=$p(data,"^",1)
		s schemedr=$p(data,"^",2)

        s len=$l(checkdrs,",")

        s i=1
        TSTART
        f i=i:1:len   d
		.s rowid=0
		.s checkdr=$P(checkdrs,",",i)
		.;w "c  "_checkdrs_"  schemedr"_schemedr,!
		.s rowid=..IfRepCheck(schemedr,checkdr)
		.q:rowid>0  s mysq="RepCheck"		
		.i checkdr'="" s PLIST(3)=checkdr
		.i schemedr'="" s PLIST(2)=schemedr
		.&sql(SELECT nvl(max(QMSchemDetail_order),0)+1 into :Code FROM dhc_qm_data.QMSchemDetail WHERE QMSchemDetail_parRef=:schemedr)
		.i Code'="" s PLIST(4)=Code
		.;i Uisstop'="" s PLIST(7)=Uisstop

		.&sql(INSERT INTO dhc_qm_data.QMSchemDetail VALUES PLIST())
		.;w SQLCODE
		.s mysq=SQLCODE
		i mysq'=0  TROLLBACK
		e  TCOMMIT
		q mysq
}

/// 入参： data 组成 :1^17^7^H^2^1^Y
/// Code(项目编码),Cname（项目名称）,auser（登录用户）,schemeType（项目类型）,importType（数据导入类型）,checkType（不合格检查点类型）,active（是否启用）;
/// w ##class(dhc.qm.udata.uCheckPointMake).AddLeft("11^名称^^M^2^1^Y")
ClassMethod AddLeft(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s mysq="添加重复"
		s projdrs=$p(data,"^",1)
		s projname=$p(data,"^",2)
		s linker=$p(data,"^",3)
		s schemeType=$p(data,"^",4)
		s importType=$p(data,"^",5)
		s checkType=$p(data,"^",6)
		s active=$p(data,"^",7)
		
        s len=$l(projdrs,",")
        s i=1
        TSTART
        f i=i:1:len   d
        .s rowid=0
        .s projdr=$P(projdrs,",",i)
		.s resturnStr=..IfRepSchem(projdrs,projname,"") //20160518 cyl edit
		.if resturnStr'=""  s mysq=resturnStr
		.q:resturnStr'=""
		
		.i projdr'="" s PLIST(2)=projdr
		.i projname'="" s PLIST(3)=projname
		.i linker'="" s PLIST(7)=linker
		.i schemeType'="" s PLIST(8)=schemeType
		.i importType'="" s PLIST(9)=importType
		.i checkType'="" s PLIST(10)=checkType
		.i active'="" s PLIST(6)=active
		
		.&sql(INSERT INTO dhc_qm_data.QMSchem VALUES PLIST())
		.s mysq=SQLCODE
		i mysq'=0  TROLLBACK
		e  TCOMMIT
		q mysq
}

/// w ##class(dhc.qm.udata.uCheckPointMake).IfRepCheck("1","2")
ClassMethod IfRepCheck(schemedr, checkdrs) As %String
{
	n (schemedr,checkdrs)
	q:checkdrs="" ""
	q:schemedr="" ""
	
	s rowid=0
	s rowid=$o(^DHCCJXQMQMSchemDetailI("QMSchemDrCheckDr",schemedr,checkdrs,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// update：cyl 20160517   添加项目代码盘重复 
/// input :prorowid用做修改功能的判重复
/// return : RefSchemCode(代码重复) RefSchemName（名称重复）
/// w ##class(dhc.qm.udata.uCheckPointMake).IfRepSchem("0060103","手术知情同意书1",1)
ClassMethod IfRepSchem(projdrs, projname, prorowid) As %String
{
	n (projdrs,projname,prorowid)
	q:projdrs="" ""
	q:projname="" ""
	

	s returnStr=""
	s schenName=""
	s schemName=$o(^DHCCJXQMQMSchemI("QMSchemCodeName",projdrs,""))
	if (schemName'=""){
		s schemRowid=$o(^DHCCJXQMQMSchemI("QMSchemCodeName",projdrs,schemName,""))
		if (schemRowid'=prorowid) d
		.s returnStr=returnStr_"RefSchemCode"
	}
	&sql(select QMSchem_RowID into:rowid from dhc_qm_data.QMSchem where QMSchem_name=:projname)
	if ((rowid'=prorowid)&&(rowid'="")){
		 s returnStr=returnStr_"^RefSchemName"
	}
		
	q returnStr
}

/// others:w ##class(dhc.qm.udata.uCheckPointMake).MyArray("1||4,1||6,1||7")
ClassMethod MyArray(s) As %String
{
	n (s)
	s len=$L(s,",")
	s resultString=""
	for i=1:1:len{
		i resultString="" {
		s resultString=resultString_"'"_$p(s,",",i)_"'"}else{
		s resultString=resultString_",'"_$p(s,",",i)_"'"	
			}
		}
	q resultString
}

/// 医嘱项名称列表
/// Table：
/// w ##Class(dhc.qm.udata.uCheckPointMake).ListLeftEdit(0,19,5)
ClassMethod ListLeftEdit(start, limit, rowid As %String) As %String
{
	n (start, limit, rowid)
	;s (name,range,isthehos,ParticipantsName)=""
	;w "rowid"_rowid_"rowid"
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="Rowid^name"

	s name=..GetChkName(rowid)
    i name'="" d
    .s len=$L(name,",")
	.f i=1:1:len d
	..s id=$p(name,",",i)
	..s UserName=..Listarcname(id)
    ..s tmp=id_"^"_UserName
    ..;w tmp,!
    ..s count=count+1
	..i (count>=start)&(count<=end) d
	...d json.InsertRowData(tmp)
	
	s resultString = json.getJsonData(jsonTitle,count)
	k json
    q resultString
}

/// w ##Class(dhc.qm.udata.uCheckPointMake).GetChkName(5)
ClassMethod GetChkName(id As %String) As %String
{
	n (id)
	s ChkName=""
	&sql(select QMSchem_Arcitem into :ChkName from dhc_qm_data.QMSchem where QMSchem_RowID=:id )
	;w ChkName,!
	;s linker=..Listarcname(ChkName)
	q ChkName
}

/// Creator:初雅莉
/// CreatDate:2016-9-12
/// Description:修改检查项目数据来源，判断现有的检查点时候为对应的采集方式
///            importType=1  Check_colTyle=2,3   ; importType=2  Check_colTyle=1,4   
/// Output:
/// Return:插入医嘱的字符串
/// Others:w ##class(dhc.qm.udata.uCheckPointMake).importTypeTT(3,1)
ClassMethod importTypeTT(schemId, importType) As %String
{
	n (schemId,importType)
	s sqlStr="SELECT qd.QMSchemDetail_CheckDr->Check_name as checkName,qd.QMSchemDetail_CheckDr->Check_colType FROM dhc_qm_data.QMSchemDetail qd,dhc_qm_data.QMSchem qms "
			_" WHERE qms.QMSchem_RowID = qd.QMSchemDetail_parRef "
			_" AND qd.QMSchemDetail_parRef = "_schemId
    i importType=2  s sqlStr=sqlStr_" and qd.QMSchemDetail_CheckDr->Check_colType not in (1,4)"
	e  	s sqlStr=sqlStr_" and qd.QMSchemDetail_CheckDr->Check_colType not in (2,3)"	 	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	
	//s count=0
	s resultStr=""
	while(result.Next()){
		s checkName=result.Data("checkName")
		s resultStr=resultStr_"<br/>"_checkName
		//s count=count+1
	}
	//if count>0  s resultStr=resultStr
	//e  s resultStr=0
	q resultStr
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uCheckPointMakeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
