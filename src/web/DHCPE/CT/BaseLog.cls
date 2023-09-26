/// 名称: 基础表更新日志查询
/// 编写者：xy
/// 编写日期: 2021-08-19
Class web.DHCPE.CT.BaseLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xy 
/// CreatDate：  20210819
/// Description: 基础表更新日志查询
/// Table：      基础表公用更新日志表  User.DHCPECTUpdateLog
/// Input:       TabName:表名, ClsName:类名
/// Return：
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.BaseLog","FindUpdateLog","DHC_PE_RoomSpecimen")
Query FindUpdateLog(TabName As %String = "", ClsName As %String = "") As websys.Query(ROWSPEC = "TTableCode,TTableDesc,TID,TRecordID,TStatus,TOldRecord,TNewRecord,TUpdateDate,TUpdateTime,TUpdateUser")
{
}

ClassMethod FindUpdateLogExecute(ByRef qHandle As %Binary, TabName As %String = "", ClsName As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
    s ^TMP("DHCPE","FindUpdateLog")=$lb(TabName,ClsName)
    i (TabName="")&&(ClsName=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
   
    s objPowerType=##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeObj(TabName)
    q:'$IsObject(objPowerType) $$$OK
    s TableListDR=objPowerType.%Id()
    s TableCode=objPowerType.PTTabCode
    s TableDesc=objPowerType.PTTabDesc
    
    s Date=""
    f  s Date=$o(^CF.PE.CTUpdateLogI("IdxOfTabUpdateDate",TableListDR,Date))  q:Date=""  d
    .s ID=""
    .f  s ID=$o(^CF.PE.CTUpdateLogI("IdxOfTabUpdateDate",TableListDR,Date,ID))  q:ID=""  d
    ..s RecordID=$lg($g(^CF.PE.CTUpdateLogD(ID)),3)
    ..s Status=$lg($g(^CF.PE.CTUpdateLogD(ID)),4)
    ..s Status=##class("web.DHCPE.CT.BaseLog").GetStatusDesc(Status)
    ..s OldRecord=$lg($g(^CF.PE.CTUpdateLogD(ID)),5)
    ..s NewRecord=$lg($g(^CF.PE.CTUpdateLogD(ID)),6)
    ..s UpdateDate=$lg($g(^CF.PE.CTUpdateLogD(ID)),7)
    ..i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    ..s UpdateTime=$lg($g(^CF.PE.CTUpdateLogD(ID)),8)
    ..i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)    
	..s UpdateUserDR=$lg($g(^CF.PE.CTUpdateLogD(ID)),9)  
    ..i UpdateUserDR'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	..s ^CacheTemp(repid,ind)=$lb(TableCode,TableDesc,ID,RecordID,Status,OldRecord,NewRecord,UpdateDate,UpdateTime,UpdateUser)
	..s ind=ind+1 
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：    xy 
/// CreatDate：  20210819
/// Description: 获取基础表更新日志表状态描述
/// Table：      
/// Input:        Status：状态 
/// Return：      return=状态描述
/// debug: d ##class("web.DHCPE.CT.BaseLog").GetStatusDesc()
ClassMethod GetStatusDesc(Status As %String = "")
{
	
	n (Status)
	q:Status ""
	s Desc=""
	s:Status="I" Desc="新增"
	s:Status="U" Desc="更新"
	s:Status="D" Desc="删除"
	q Desc
}

/// Creator：    xy 
/// CreatDate：  20221214
/// Description: 插入基础数据操作日志
/// Table：      基础数据操作日志表  DHC_PE_CTUpdateLog
/// Input:       TableDR：表名，RecordID： 表记录ID，Status：状态，
///              OldRecord：原始记录（ ^分割的字符串）， NewRecord：更新记录（ ^分割的字符串）
///              UserID：操作人
/// Return：     成功：记录ID；失败：-1^错误信息
/// Debug: w ##class(web.DHCPE.CT.BaseLog).InsertRecordLog()
ClassMethod InsertRecordLog(TableDR, RecordID, Status, OldRecord, NewRecord, UserID)
{
	s ^TMP("DHCPE","InsertRecordLog")=$LB(TableDR, RecordID, Status, OldRecord, NewRecord)
	
	q:(TableDR="") "-1^表名不能为空"
	
	S TableID=""
	S TableID=$o(^CT.PE.PowerTableListI("IdxOfCode"," "_$zcvt(TableDR,"U"),0))
	q:TableID="" "-1^参数表名不正确"
	
	s Logobj=##Class(User.DHCPECTUpdateLog).%New()
	d Logobj.CTULTableDRSetObjectId(TableID) 
	s Logobj.CTULStatus=Status
	s Logobj.CTULRecordID=RecordID
	s Logobj.CTULOldRecord=OldRecord
	s Logobj.CTULNewRecord=NewRecord
	s Logobj.CTULUpdateDate=+$H
	s Logobj.CTULUpdateTime=$p($h,",",2)
	s Logobj.CTULUpdateUserDR =UserID
	s sc=Logobj.%Save()
	d Logobj.%Close()
	
	if ($System.Status.IsError(sc)){
		q "-1^"_$System.Status.GetErrorText(sc)
	}
	else{
		q Logobj.%Id()
	}
}

}
