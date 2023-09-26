/// 方案权限设置
Class dhc.pa.udata.uUserSchemAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取用户
/// Table：dhc_pa_data.JXUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uUserSchemAudit).GetJXUser(0,10,"")
ClassMethod GetJXUser(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SS_User where %ID>0"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		s name = result.Data("SSUSR_Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: 刘洋
/// CreatDate: 2011-12-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uUserSchemAudit).GetJXSchem("","","","",0,25,"医技")
ClassMethod GetJXSchem(searchField, searchValue, sortField, sortDir, start, limit, schemCombo) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit,schemCombo)
		
		s Stratagem = ""
		s curreStratagemDr = ""
		f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
		.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
		..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
		...s curreStratagem = $P(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
		...if curreStratagem="Y" d
		....s curreStratagemDr = Stratagem
		
		s sqlStr="SELECT Schem_rowid,Schem_parRef,Schem_code,Schem_name,Schem_shortcut,Schem_appSysDr,Schem_frequency,Schem_KPIDr,Schem_desc,Schem_active,Schem_level FROM dhc_pa_data.Schem WHERE Schem_childSub>0 and Schem_name like '%"_schemCombo_"%' and Schem_parRef="_curreStratagemDr
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="Schem_rowid"
		.i sortField="parRef" s sortField1="Schem_parRef"
		.i sortField="code" s sortField1="Schem_code"
		.i sortField="name" s sortField1="Schem_name"
		.i sortField="shortcut" s sortField1="Schem_shortcut"
		.i sortField="appSysDr" s sortField1="Schem_appSysDr"
		.i sortField="frequency" s sortField1="Schem_frequency"
		.i sortField="KPIDr" s sortField1="Schem_KPIDr"
		.i sortField="desc" s sortField1="Schem_desc"
		.i sortField="active" s sortField1="Schem_active"
		.i sortField="level" s sortField1="Schem_level"
	
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr="  ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr="  ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^parRef^code^name^shortcut^appSysDr^frequency^KPIDr^KPIName^desc^level^appSys^quency^shortCutFreQuency"
		
		While(result.Next())
		{
			s rowid=result.Data("Schem_rowid")
			s parRef=result.Data("Schem_parRef")
			s code=result.Data("Schem_code")
			s name=result.Data("Schem_name")
			s shortcut=result.Data("Schem_shortcut")
			s appSysDr=result.Data("Schem_appSysDr")
			s appSys = appSysDr
			i appSysDr="1" s appSysDr="全院"
			i appSysDr="2" s appSysDr="科室"
			i appSysDr="3" s appSysDr="护理"
			i appSysDr="4" s appSysDr="医疗"
			i appSysDr="5" s appSysDr="个人"
			s frequency=result.Data("Schem_frequency")
			s shortCutFreQuency=shortcut_"!"_frequency
			s quency = frequency
			i frequency="M" s frequency="月份"
			i frequency="Q" s frequency="季度"
			i frequency="Y" s frequency="年度"
			i frequency="H" s frequency="半年"
			s KPIDr=result.Data("Schem_KPIDr")
			s KPIName=""
			i KPIDr'="" d
			.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
			..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
			...s KPIName = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s desc=result.Data("Schem_desc")
			s level=result.Data("Schem_level")
			
			s tmp=rowid_"^"_parRef_"^"_code_"^"_name_"^"_shortcut_"^"_appSysDr_"^"_frequency_"^"_KPIDr_"^"_KPIName_"^"_desc_"^"_level_"^"_appSys_"^"_quency_"^"_shortCutFreQuency
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.q:(searchField="shortcut")&(shortcut'[searchValue)
			.q:(searchField="desc")&(desc'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator:  刘洋
/// CreatDate: 2011-12-12
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.SchemAudit
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uUserSchemAudit).List("","","","","0","25")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit)
	
		s sqlStr="SELECT * from dhc_pa_data.SchemAudit  WHERE %ID>0  "
		;w name ,!
		
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="SAudit_rowid"

		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		;w sqlStr,!
		
		s result=##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^user^schem"
		
		While(result.Next())
		{	
			s rowid=result.Data("SAudit_rowid")

			s userDr=result.Data("SAudit_userDr")
			
			s user=""
			i userDr'="" d
			.i $D(^SSU("SSUSR",userDr)) d
			..i $G(^SSU("SSUSR",userDr))'="" d
			...s user=$P(^SSU("SSUSR",userDr),"^",2)
			
			
			s schem=""
			s schemDr=result.Data("SAudit_SchemDr")
			i schemDr'=""  s schem=..GetSchemName(schemDr)

			s tmp=rowid_"^"_user_"^"_schem
			s count=count+1
			i searchValue'="" d
			.q:(searchField="code")&(code'[searchValue)
			.q:(searchField="name")&(name'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			
		}
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description: 获取方案名称
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uUserSchemAudit).GetSchemName()
ClassMethod GetSchemName(Id) As %String
{
	n (Id)
    s name = ""  

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.Schem   "
	s whereStr=""
	i Id '="" s whereStr=" where  Schem_rowid = '"_Id_"'" 
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
	
		s name = result.Data("Schem_name")
	}
	d result.Close()

	q name
}

/// Creator：ban
/// CreatDate：2016-6-24
/// Description: 判断添加的方案权限数据是否存在
/// Table： dhc_pa_data.SchemAudit
/// Input：user  用户id, schem  方案id
/// Output：
/// Return：返回rowid
/// Others：w ##class(dhc.pa.udata.uUserSchemAudit).IfRepUserSchem("1","1||6")
ClassMethod IfRepUserSchem(user, schem) As %String
{
	n (user, schem)
    s rowid = ""  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SAudit_rowid  from  dhc_pa_data.SchemAudit where  SAudit_userDr = '"_user_"'  "
	s whereStr=""
	i schem '="" s whereStr="  and  SAudit_SchemDr = '"_schem_"'" 
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	While(result.Next()){
	
		s rowid = result.Data("SAudit_rowid")
	}
	d result.Close()

	q rowid
}

/// Creator: 刘洋
/// CreatDate:  2011-12-12
/// Description: 插入新记录
/// Table:dhc.pa.data.SchemAudit
/// Others: w ##class(dhc.pa.udata.uUserSchemAudit).InsertRec("1","1||7")
ClassMethod InsertRec(user, schem) As %String
{
		n (user, schem)

		k PLIST

		i schem'="" s PLIST(2)=schem
		i user'="" s PLIST(3)=user
		
		s RowId=..IfRepUserSchem(user,schem)
		q:RowId'="" "RepName"

		&sql(INSERT INTO  dhc_pa_data.SchemAudit  VALUES PLIST())
		q SQLCODE
}

/// Others: w ##class(dhc.pa.udata.uUserSchemAudit).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&sql(delete from  dhc_pa_data.SchemAudit   where %ID=:rowid)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUserSchemAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
