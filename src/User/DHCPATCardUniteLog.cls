Class User.DHCPATCardUniteLog Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCPATCardUniteLog ]
{

/// 各产品组业务数据表名
Property CUTableName As %String(TRUNCATE = 1) [ Required ];

/// 被合并的PA_PatMas的ID
Property CUOldPAPMIRowid As %String(TRUNCATE = 1) [ Required ];

/// 合并到的PA_PatMas的ID
Property CUNewPAPMIRowid As %String(TRUNCATE = 1) [ Required ];

/// 各产品组更新数据的ID
Property CURecordID As %String(TRUNCATE = 1) [ Required ];

/// 合并时插入标志1  逆向操作时修改标志为0
Property CUActiveFlag As %String(TRUNCATE = 1) [ Required ];

/// 合并时插入如果修改的不是PA_PatMas表的ID记录其它原数据
Property CUOtherInfo As %String(TRUNCATE = 1);

/// 合并操作人
Property CUInsertUserID As %String(TRUNCATE = 1);

/// 合并操作日期
Property CUInsertDate As %Date;

/// 合并操作时间
Property CUInsertTime As %Time;

/// 逆向操作人
Property CUConverseUserID As %String(TRUNCATE = 1);

/// 逆向操作日期
Property CUConverseDate As %Date;

/// 逆向操作时间
Property CUConverseTime As %Time;

/// 合并原因
Property CUUnitReason As %String(TRUNCATE = 1);

/// 根据此寻找合并的记录(老->新)
Index OldNewPAPMI On (CUActiveFlag, CUOldPAPMIRowid, CUNewPAPMIRowid, CUTableName As AlphaUp);

/// 根据此寻找合并的记录(新->老)
Index NewOldPAPMI On (CUActiveFlag, CUNewPAPMIRowid, CUOldPAPMIRowid, CUTableName As AlphaUp);

/// 合并日期索引
Index UnitDate On (CUInsertDate, CUOldPAPMIRowid, CUNewPAPMIRowid);

/// 合并时插入合并日志   -1  错误  0  插入成功
ClassMethod InsertLog(TabName As %String, OldPAPMIRowID As %String, NewPAPMIRowID As %String, RecordID As %String, OtherInfo As %String = "", CurUser As %String = "", UnitReason As %String = "")
{
	//s CurUser=%session.Get("LOGON.USERID")
	n (TabName, OldPAPMIRowID, NewPAPMIRowID, RecordID, OtherInfo,CurUser,UnitReason)
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	/*s rtn=0
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	s obj=##class(User.DHCPATCardUniteLog).%New()
	s obj.CUTableName=TabName
	s obj.CUOldPAPMIRowid=OldPAPMIRowID
	s obj.CUNewPAPMIRowid=NewPAPMIRowID
	s obj.CURecordID=RecordID
	s obj.CUActiveFlag="1"
	s obj.CUOtherInfo=OtherInfo
	s obj.CUInsertUserID=CurUser
	s obj.CUInsertDate=CurDate
	s obj.CUInsertTime=CurTime
	s sc=obj.%Save()
	If ($System.Status.IsError(sc))	
	{
		s rtn=-1
	}
	b //$p(%ROWID,$c(1))
	d obj.%Close()
	q rtn*/
	&SQL(insert into SQLUser.DHCPATCardUniteLog
		(CUTableName,CUOldPAPMIRowid,CUNewPAPMIRowid,CURecordID,CUActiveFlag,
		CUOtherInfo,CUInsertUserID,CUInsertDate,CUInsertTime,CUUnitReason)
		Values(:TabName,:OldPAPMIRowID,:NewPAPMIRowID,:RecordID,'1',
		:OtherInfo,:CurUser,:CurDate,:CurTime,:UnitReason))
	i SQLCODE=0{
		s $list(^User.DHCPATCardUniteLogD(%ROWID),19)=OtherInfo
	}
	b //1233
	Q SQLCODE
}

/// 逆向操作时修改日志  -1  错误  0  修改成功
ClassMethod UpdateLog(LogID, CurUser As %String = "")
{
	//s CurUser=%session.Get("LOGON.USERID")
	n (LogID,CurUser)
	s rtn=0
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	s obj=##class(User.DHCPATCardUniteLog).%OpenId(LogID)
	s obj.CUActiveFlag="0"
	s obj.CUConverseUserID=CurUser
	s obj.CUConverseDate=CurDate
	s obj.CUConverseTime=CurTime
	s sc=obj.%Save()
	If ($System.Status.IsError(sc))	
	{
		s rtn=-1
	}
	d obj.%Close()
	q rtn
}

Storage Default
{
<Data name="DHCPATCardUniteLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActiveFlag</Value>
</Value>
<Value name="3">
<Value>NewPAPMIRowid</Value>
</Value>
<Value name="4">
<Value>OldPAPMIRowid</Value>
</Value>
<Value name="5">
<Value>RecordID</Value>
</Value>
<Value name="6">
<Value>TableType</Value>
</Value>
<Value name="7">
<Value>CUActiveFlag</Value>
</Value>
<Value name="8">
<Value>CUNewPAPMIRowid</Value>
</Value>
<Value name="9">
<Value>CUOldPAPMIRowid</Value>
</Value>
<Value name="10">
<Value>CURecordID</Value>
</Value>
<Value name="11">
<Value>CUTableType</Value>
</Value>
<Value name="12">
<Value>CUTableName</Value>
</Value>
<Value name="13">
<Value>CUInsertDate</Value>
</Value>
<Value name="14">
<Value>CUInsertUserID</Value>
</Value>
<Value name="15">
<Value>CUInsertTime</Value>
</Value>
<Value name="16">
<Value>CUConverseDate</Value>
</Value>
<Value name="17">
<Value>CUConverseTime</Value>
</Value>
<Value name="18">
<Value>CUConverseUserID</Value>
</Value>
<Value name="19">
<Value>CUOtherInfo</Value>
</Value>
<Value name="20">
<Value>CUUnitReason</Value>
</Value>
</Data>
<DataLocation>^User.DHCPATCardUniteLogD</DataLocation>
<DefaultData>DHCPATCardUniteLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPATCardUniteLogD</IdLocation>
<IndexLocation>^User.DHCPATCardUniteLogI</IndexLocation>
<StreamLocation>^User.DHCPATCardUniteLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
