Class BILL.DC.HospitalCtl Extends %RegisteredObject
{

/// Creator: tangzf
/// CreateDate: 2022-08-9
/// Descript: 界面院区下拉框获取
/// Table : 
/// Input:	
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.HospitalCtl","GetHospDataForCombo","","","","")
Query GetHospDataForCombo(rowid As %String, desc As %String, tablename As %String, SessionStr As %String) As websys.Query(ROWSPEC = "HOSPRowId,HOSPDesc")
{
}

ClassMethod GetHospDataForComboExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, tablename As %String, SessionStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//s HISVer=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer",$o(^CT("HOSP",0)),14)
	s MultHospFlag=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer","G",4)
 	if (MultHospFlag="Y"){
		Set rrset=##class(%ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCombo")
		do rrset.Execute(rowid, desc, tablename, SessionStr) 
		While (rrset.Next()) {
			s HOSPDesc=rrset.GetDataByName("HOSPDesc")
			s HOSPRowId=rrset.GetDataByName("HOSPRowId")
			d QueryPortList
		}
 	}else{
	 	for 
	 	{  
	        s RowId=$o(^CT("HOSP",RowId)) q:RowId=""
	        s HOSPDateTo=$p($g(^CT("HOSP",RowId)),"^",10)
	        continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h) 	                
			s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
			s HOSPRowId=RowId
			d QueryPortList
	    }
	 }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPortList
	set Data=$lb(HOSPRowId,HOSPDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2020-05-08
/// Descript: 取分组表 默认院区Id
/// 涉及表： 
/// Input:	
/// 		
/// Output: 
/// Return:  "G 表示公有数据"
/// DeBug: w ##class(BILL.DC.HospitalCtl).GetGroupDefaultHospId("INSUConBDPTableList","")
/// 该接口不允许随意修改 ！
ClassMethod GetGroupDefaultHospId(TableName As %String, ParmHospital As %String = "", date As %String = "") As %String
{
	quit:(TableName="") "-1"
	q:ParmHospital="G" "G"
	s MultHospFlag=##class(BILL.DC.BL.DicDataCtl).GetDicInfoByTypeCode("SYS","HISVer","G",4)
	q:(MultHospFlag'="Y") ParmHospital // 未启用基础平台多院区 传什么院区返回什么院区

	set BusinessCode=..GetDicCode(TableName)
	quit:BusinessCode="G" "G"
	set DataType=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BusinessCode)	 //获取数据公有私有类型 公有数据不带医院表示
	quit:DataType="G" "G"
	set DefaultHosp=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(BusinessCode,ParmHospital,date)
	quit DefaultHosp
}

/// Creator: tangzf
/// CreateDate: 2020-05-20
/// Descript: 根据医保字典 系统Code(AKC021ZZB)  查询表结构登记中的实际code(AKC021ZZB)
/// 涉及表： 
/// Input:	Code :      AKC021ZZB
/// Output: 
/// Return:  AKC021
/// DeBug: w ##class(BILL.DC.HospitalCtl).GetDicCode("DLLType")
ClassMethod GetDicCode(Code) As %String
{
	set rtn=""
	
	/*01-医保基础表数据取值*/
	set TableCode=Code
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(TableCode,"U"),0))
	quit:+tmpTableListID'=0 TableCode  //如果根据索引找到code则说明已经进行登记
	
	/*02-医保配置字典(不包括医保类型)取值*/
	set DicCfgCode="BILL_DCDic_"_Code
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(DicCfgCode,"U"),0))
	quit:+tmpTableListID'=0 DicCfgCode   //如果根据索引找到code则说明已经进行登记
	
	/*03-医保字典数据，医保对照数据(一般是带医保类型的字典)取值*/
	set DicCfgCode=""
	set DicDataId=$o(^DHCINDID("0","ITypeCode","BILLDCConBDPTableList",Code,""))
	set:DicDataId'="" DicCfgCode=$lg(^CT.BILL.DC.DicDataD(DicDataId),4)
	quit:DicCfgCode="" rtn
	set tmpTableListID=$o(^User.BDPTableListI("NameIndex"," "_$ZCONVERT(DicCfgCode,"U"),0))
	quit:+tmpTableListID'=0 Code   //如果根据索引找到code则说明已经进行登记
	quit rtn
	
	quit rtn
}

}
