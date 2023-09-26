/// 操作记录日志实现类
Class dhc.pa.uInter.OPLog Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: chuyali
/// CreatDate: 2016-12-02
/// Description: 插入日志记录
/// Table: dhc_pa_inter.OPLog
/// Input: 操作模块名称-ModuleName 操作方式-Mode 操作数据-Data 操作-User  noEditStr-固定的不修改的列信息
/// Others: w ##class(dhc.pa.uInter.OPLog).InsertLOG("lala","Q","02","1","d_d_d||11")
/// w ##class(dhc.pa.uInter.OPLog).InsertLOG("唯一值设置","E","11^>^120^0^2^1||1","11^>=^100^0^2^1||1","指标名称^公式^值^分数^方案","demo","dhc_pa_data.JXSetOnlyValue**2")
ClassMethod InsertLOG(ModuleName, Mode, OldData, newData, DataName, User, TableSub, noEditStr) As %String
{
	n (ModuleName,Mode,OldData,newData,DataName,User,TableSub,noEditStr)
	s Edata=..CompareData(OldData,newData,DataName)
	s EdataIn=noEditStr_"："_Edata
	s ret=""
	i Edata'="" d
	.&sql(INSERT INTO dhc_pa_inter.OPLog (OPLOG_ModuleName, OPLOG_Mode, OPLOG_Data, OPLOG_User, OPLOG_Time,OPLOG_TableSub)VALUES (:ModuleName,:Mode,:EdataIn,:User,{fn NOW()},:TableSub))
	.s ret=SQLCODE
	q ret
}

/// Creator: chuyali
/// CreatDate: 2016-12-04
/// Description: 比较修改哪些内容  返回比较的描述
/// Table: dhc_pa_inter.OPLog
/// Input: 
/// Others: w ##class(dhc.pa.uInter.OPLog).InsertLOG("lala","Q","02","1","d_d_d||11")
/// w ##class(dhc.pa.uInter.OPLog).CompareData("11^>^120^0^2^1||1","11^>=^100^0^2^1||1","指标名称^公式^值^分数^方案")
ClassMethod CompareData(OldData, newData, DataName) As %String
{
	n (OldData,newData,DataName)
	s oldDataLen=$l(OldData,"^")
	s retStr=""
	s countComp=0
	if (newData'=""){
		for i=1:1:oldDataLen  d
		.s oldD=$p(OldData,"^",i)
		.s newD=$p(newData,"^",i)
		.if $ISVALIDNUM(oldD)=1 s oldD= $NUMBER(oldD) 
		.if $ISVALIDNUM(newD)=1 s newD= $NUMBER(newD)
		.i oldD'=newD d
		..s nameD=$p(DataName,"^",i)
		..i nameD["指标" d //20161206
		...i oldD'="" s oldD=$p(^DHCCJXPAKPIINDEX1(oldD),"^",2)
		...i newD'="" s newD=$p(^DHCCJXPAKPIINDEX1(newD),"^",2)
		..i nameD["方案"  d
		...i oldD'="" &sql(SELECT Schem_name into:oldD FROM dhc_pa_data.Schem WHERE Schem_rowid =:oldD)
		...i newD'="" &sql(SELECT Schem_name into:newD FROM dhc_pa_data.Schem WHERE Schem_rowid =:newD)
		..s retStr=retStr_" ；"_nameD_"："_oldD_" 改为 "_newD
		..s countComp=countComp+1
	}else{
		for i=1:1:oldDataLen  d
		.s oldD=$p(OldData,"^",i)
		.s nameD=$p(DataName,"^",i)
		.i nameD["指标" d //20161206
		..i oldD'="" s oldD=$p(^DHCCJXPAKPIINDEX1(oldD),"^",2)
		.i nameD["方案"  d
		..i oldD'="" &sql(SELECT Schem_name into:oldD FROM dhc_pa_data.Schem WHERE Schem_rowid =:oldD)
		.s retStr=retStr_" ；"_nameD_"："_oldD
		.s countComp=countComp+1
		s retStr="原始数据为：" _retStr
	
	}
	i countComp=0 s retStr=""
	q retStr
}

/// Creator: chuyali
/// CreatDate: 2016-12-02
/// Description: 插入日志记录
/// Table: dhc_pa_inter.OPLog
/// Input: 操作模块名称-ModuleName 操作方式-Mode 操作数据-Data 操作-User 开始时间-startTime 结束时间-endTime
/// Others: w ##class(dhc.pa.uInter.OPLog).ListLOG(0,10,"","","","","")
ClassMethod ListLOG(start, limit, moduleName, mode, userID, startTime, endTime) As %String
{
	n (start,limit,moduleName,mode,userID,startTime,endTime)
	
  s sqlStr = "SELECT OPLOG_RowID, OPLOG_ModuleName, OPLOG_Mode, OPLOG_Data, OPLOG_User, OPLOG_Time "
			_" FROM dhc_pa_inter.OPLog where %ID>0 "
  if moduleName'=""  s sqlStr=sqlStr_ "and OPLOG_ModuleName like '%"_moduleName_"%' "  ;模块名称
  if mode'=""  s sqlStr=sqlStr_" and OPLOG_Mode="_mode  ;操作方式：D删除，E修改
  if userID'=""  s sqlStr=sqlStr_ "and OPLOG_User='"_userID_"' " 
  if (startTime'="")&&(endTime'="")  s sqlStr=sqlStr_" and (OPLOG_Time  between '"_startTime_"' and '"_endTime_"')"  ;操作方式：D删除，E修改
  
  
  s resultSql =##class(%Library.ResultSet).%New()
  d resultSql.Prepare(sqlStr)
  d resultSql.Execute()
  s count=0

 
  s json=##class(dhc.pa.comm.JsonObj).%New()
  s jsonTitle="rowid^opModuleName^opMode^opData^opUser^opTime^opUserName"
  s end=start+limit-1
  while(resultSql.Next()){
	  s rowid=resultSql.Data("OPLOG_RowID")
	  s opModuleName=resultSql.Data("OPLOG_ModuleName")
	  s opMode=resultSql.Data("OPLOG_Mode")
	  s opData=resultSql.Data("OPLOG_Data")
	  s opUser=resultSql.Data("OPLOG_User")
	  s opTime=resultSql.Data("OPLOG_Time")
	  s opUserName=""
	  i opUser'=""  s opUserName = $p($g(^SSU("SSUSR",opUser)),"^",2)
	  s $p(opTime," ",1)=##class(websys.Conversions).DateLogicalToHtml($zdh($p(opTime," ",1),3))
	  s temp=rowid_"^"_opModuleName_"^"_opMode_"^"_opData_"^"_opUser_"^"_opTime_"^"_opUserName
	  i (count>=start)&(count<=end) d
	  .d json.InsertRowData(temp)
	  s count=count+1
 }
 d resultSql.Close()
 s resultString = json.getJsonData(jsonTitle,count)
 k json
 q resultString
}

/// Creator: chuyali
/// CreatDate: 2016-12-03
/// Description: 取操作前的记录，用在修改的时候
/// Table: 参数
/// Input: tableName表名  ，field字段,rowid操作数据的rowid
/// Others: w ##class(dhc.pa.uInter.OPLog).GetOldData("dhc_pa_inter.OPLog","OPLOG_RowID,OPLOG_ModuleName,OPLOG_Mode,OPLOG_Data,OPLOG_User,OPLOG_Time",5)
ClassMethod GetOldData(tableName, field, rowid) As %String
{
	n (tableName, field,rowid)
	
	 s sqlStr = "SELECT  "_field
			_" FROM "_tableName_" where %ID='"_rowid_"'"
	  s resultSql =##class(%Library.ResultSet).%New()
	  d resultSql.Prepare(sqlStr)
	  d resultSql.Execute()
	  s count=0
	  s fieldLen=$l(field,",")
	  s count=0
	  s temp=""
  
	  while(resultSql.Next()){
		For i = 1:1:fieldLen  d
		.;s lala=$char(34)_$p(field,",",i)_$char(34)
		.s fieldData=resultSql.%GetData(i)
		.i count=0 d
		..s temp=fieldData 
		..s count=1
		.e  s temp=temp_"^"_fieldData 
	 }
 d resultSql.Close()
 q temp
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.OPLogS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
