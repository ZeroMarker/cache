Import SQLUSER

Class web.DHCICUBedDevice Extends %RegisteredObject
{

// d ##class(%ResultSet).RunQuery("web.DHCICUBedDevice","FindIcuBedDeviceByBedId","55||1")

Query FindIcuBedDeviceByBedId(bedId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    Select RowId,DeviceId,Note,DeviceId->DeviceNumber As DeviceNumber,DeviceId->DeviceName As DeviceName,BedId,BedId->BED_Code As Bed,BedId->BED_WARD_ParRef As DepartmentId,BedId->BED_WARD_ParRef->WARD_Desc As Department
    from DHC_ICU_BedDevice
    where BedId=:bedId
}

// d ##class(%ResultSet).RunQuery("web.DHCICUBedDevice","FindIcuBedDevice","23")

Query FindIcuBedDevice(departmentId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    Select RowId,DeviceId,Note,DeviceId->DeviceNumber As tDeviceNumber,DeviceId->DeviceName As Device,BedId,BedId->BED_Code As Bed,BedId->BED_WARD_ParRef As DepartmentId,BedId->BED_WARD_ParRef->WARD_Desc As Department
    from DHC_ICU_BedDevice
    Where BedId->BED_WARD_ParRef=:departmentId or (:departmentId is null)
}

// where DepartmentId=:departmentId

//    OR :departmentId IS null

/// w ##class(web.DHCICUBedDevice).FindLoc("1")
ClassMethod FindLoc(Department)
{
    &SQL(select CTLOC_RowID,CTLOC_Desc,CTLOC_Code into :ctlocId,:ctlocDesc,:ctlocCode from CT_Loc where CTLOC_RowID=:Department)
    q ctlocId_":"_ctlocDesc_":"_ctlocCode
}

// 增加设备(报错)

ClassMethod AddBedDevice(BedId, Device, Note)
{
    s rowId=$$Find(Device)
	if rowId'="" d
	.s obj=##class(User.DHCICUBedDevice).%OpenId(rowId)
	.i obj.BedId=BedId d
	..s obj.Note=Note
	..d obj.%Save()
	.e  d
	..;该设备已经关联传位
	..s rowId="该设备已经关联床位"
	.d obj.%Close()
	
	e  d
	.s rowId=$$Add()
	q rowId
Add()
	&SQL(insert into DHC_ICU_BedDevice (BedId,DeviceId,Note)
	values(:BedId,:Device,:Note))
	q:SQLCODE=0 $g(%ROWID)
	q SQLCODE
Find(devId)
    &sql(select RowId into:rowId from DHC_ICU_BedDevice
    where DeviceId=:devId)
    q rowId
}

/// 更新
ClassMethod UpdateBedDevice(RowId, BedId, Device, Note)
{
	&SQL(update DHC_ICU_BedDevice set BedId=:BedId,DeviceId=:Device,Note=:Note  where RowId=:RowId)
	
	q SQLCODE
}

/// 更新
ClassMethod ModifyBedDevice(RowId, DeviceId)
{
	// 清空该设备之前的床位关联
	d Clear
	&SQL(update DHC_ICU_BedDevice set DeviceId=:DeviceId  where RowId=:RowId)
	
	q SQLCODE
Clear
	&sql(update DHC_ICU_BedDevice set DeviceId=""
	where DeviceId=:DeviceId)
	q
}

// 删除

ClassMethod DeleteBedDevice(rw As %String)
{
	q:rw="" -1
	&SQL(Delete from DHC_ICU_BedDevice where RowId=:rw)
	q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCICUBedDevice","FindBed","","5")

Query FindBed(departmentId, filterStr) As %SQLQuery(CONTAINID = 1)
{
	select BED_RowID As Id,	BED_Code As Code from PAC_Bed
	where ((:filterStr<>'') AND BED_Code[:filterStr AND BED_WARD_ParRef=:departmentId) OR (:filterStr is NULL AND BED_WARD_ParRef=:departmentId)
}

Query FindICUBed(departmentId, filterStr) As %SQLQuery(CONTAINID = 1)
{
	
	select BED_RowID As Id,	BED_Code As Code from PAC_Bed
	where ((:filterStr<>'') AND BED_Code[:filterStr AND BED_WARD_ParRef=(SELECT WARD_RowID FROM PAC_Ward WHERE WARD_LocationDR=:departmentId)) OR (:filterStr is NULL AND BED_WARD_ParRef=(SELECT WARD_RowID FROM PAC_Ward WHERE WARD_LocationDR=:departmentId))
}

}
