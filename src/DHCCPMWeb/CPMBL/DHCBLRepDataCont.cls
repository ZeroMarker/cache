Class DHCCPMWeb.CPMBL.DHCBLRepDataCont Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", CompileAfter = (DHCCPM.DHCRepDataCont, DHCCPMWeb.CPMSevice.entity.DHCERepDataCont), Inheritance = right, Not ProcedureBlock ]
{

/// 验证是否能够保存,数据库类型和Net端数据类型
ClassMethod CheckType(DBType As %String, DBStr As %String, NetStr As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).CheckType("C","%")
	n (DBType, DBStr, NetStr)
	s myrtn=0
	
	;^DHCCPM.DHCRepDataContI("RDCDBDataTypeIndex","C","%Boolean",123,1)
	;RDCDBType As String, RDCDBDataType As String, RDCDNDataType As String
	
	i $d(^DHCCPM.DHCRepDataContI("RDCDBDataTypeIndex", DBType, DBStr, NetStr)) d
	.s myrtn=-1101
	
	q myrtn
}

/// 删除数据类型对照 Success=0  fail<>0
ClassMethod DELETE(RowID As %String) As %String
{
	n (RowID)
	s $ZT="ERROR^DHCSSERR"
	
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).DELETE()
	s myrtn=0
	
	TSTart
	
	Set mysc = ##class(DHCCPM.DHCRepDataCont).%DeleteId(RowID)
	
	If $$$ISERR(mysc) {
    	s myrtn=-106
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	QUIT myrtn
}

/// 根据数据库端的数据类型获取DotNet端的数据类型
ClassMethod GetNetTypeByDBType(DBType As %String, DBDataType As %String, ExpStr As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).GetNetTypeByDBType("C","%Library.Date","")
	n (DBType, DBDataType, ExpStr)
	s myrtn="string"
	
	Set rset = ##class(%ResultSet).%New("DHCCPM.DHCRepDataCont:SelectByDBDataType")
	Set columns = rset.GetColumnCount()
	//如果数据类型包含包:
	i DBDataType["." d
	.s DBDataType=$p(DBDataType,".",2)
	i DBDataType'["%" d
	.s DBDataType="%"_DBDataType
	
	Set rs = rset.Execute(DBType, DBDataType)
	
	s myIdx=0
	While (rset.Next()) {
		s myrtn=rset.Data("RDC_DNDataType")
	}
	d rset.Close()
	
	q myrtn
}

/// 新增数据对照 Success=0  fail<>0
ClassMethod INSERT(RepDataCont As DHCCPMWeb.CPMSevice.entity.DHCERepDataCont) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).INSERT(myobj)
	;判断保存成功时
	;If ($$$ISOK(sc)){} 可以执行下一步
	;
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	
	;验证这个对照是否存在
	s myDBType=RepDataCont.RDCDBType
	s myDBDataType=RepDataCont.RDCDBDataType
	s myNetType=RepDataCont.RDCDNDataType
	s myrtn=..CheckType(myDBType,myDBDataType, myNetType)
	
	q:(+myrtn) myrtn
	
	TSTart
	
	s myobj=##class(DHCCPM.DHCRepDataCont).%New()
	
	s myobj.RDCDBDataType=RepDataCont.RDCDBDataType
	s myobj.RDCDBType=RepDataCont.RDCDBType
	s myobj.RDCDNDataType=RepDataCont.RDCDNDataType
	s myobj.RDCPackageType=RepDataCont.RDCPackageType
	s myobj.RDCSCType=RepDataCont.RDCSCType
	
	s mysc=myobj.%Save()
	
	d myobj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	if (myrtn=0){
		TCommit
	}else{
		TRollback
	}
	
	q myrtn
}

/// 获取全部的数据类型对照 返回DataSet
ClassMethod SelectByDBType(DBType As %String) As DHCCPMWeb.CPMSevice.dataset.DHCDSRepDataContDataSet
{
 New (DBType)
 
 Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCDSRepDataContDataSet).%New()
 Do result.SetArgs(DBType)
 Quit result
}

/// 更新数据类型对照 Success=0  fail<>0
ClassMethod UPDATE(RepDataCont As DHCCPMWeb.CPMSevice.entity.DHCERepDataCont) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).UPDATE(myobj)
	n (RepDataCont)
	;判断是否存在
	;否则更新失败
	;$IsObject
	;RepDataCont.RowID
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	
	TSTart
	s myRowID=RepDataCont.RowID
	
	s myobj=##class(DHCCPM.DHCRepDataCont).%OpenId(myRowID)
	
	if ('$IsObject(myobj)){
		s myrtn=-1102		;对象不存在错误
	}
	
	if (+myrtn=0){
		s myobj.RDCDBDataType=RepDataCont.RDCDBDataType
		s myobj.RDCDBType=RepDataCont.RDCDBType
		s myobj.RDCDNDataType=RepDataCont.RDCDNDataType
		s myobj.RDCPackageType=RepDataCont.RDCPackageType
		s myobj.RDCSCType=RepDataCont.RDCSCType
		
		s mysc=myobj.%Save()
		
		d myobj.%Close()
		
		If $$$ISERR(mysc) {
	    	s myrtn=-105
	    }
	}
	if (+myrtn=0){
		TCommit
	}else{
		TRollback
	}
	
	q myrtn
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO()
{
}

}
