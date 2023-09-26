/// 单病种质控项目选项对照（标准抗菌药）
Class DHCMA.CPW.SDS.QCOptionMatchAntiSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMA.CPW.SDS.QCOptionMatchAntiSrv).SaveAntiStr()
ClassMethod SaveAntiStr(aOptionDr As %String, aInputStr As %String) As %String
{
	n (aOptionDr,aInputStr)
	Set return=""
	Quit:((aOptionDr="")||(aInputStr="")) return
	//清除原有维护信息
	Set xRowID=""
	for {
		Set xRowID=$o(^DHCMA.CPW.SD.QCOptionMatchAntiI("IndexOfOptionDr",aOptionDr,xRowID))
		Quit:xRowID=""
		d ##class(DHCMA.CPW.SD.QCOptionMatchAnti).DeleteById(xRowID)
	}
	//存入选择抗菌药信息
	Set Err=""
	for i=1:1:$L(aInputStr,"^")	{
		Set AntiCode=$p(aInputStr,"^",i)
		continue:AntiCode=""
		Set AntiObj=##class(DHCMA.CPW.SDMatch.AntiItem).GetObjByCode(AntiCode)
		Continue:'$IsObject(AntiObj)
		Set AntiId=AntiObj.%Id()
		Set inputStr=aOptionDr_"^"_AntiId
		Set flg=##class(DHCMA.CPW.SD.QCOptionMatchAnti).Update(inputStr)
		if (flg<0) {
			Set Err=Err_AntiId_"保存失败！<br>"
			}
		}
	Set return="1^保存成功！"
	Set:Err'="" return="-1^"_Err
	Quit return
}

/// 获取项目值域关联的标准抗菌药医嘱Code
/// w ##class(DHCMA.CPW.SDS.QCOptionMatchAntiSrv).GetAntiCodeStr(1245)
ClassMethod GetAntiCodeStr(aOptionDr As %String) As %String
{
	n (aOptionDr)
	Set xRowID="",CodeStr=""
	for {
		Set xRowID=$o(^DHCMA.CPW.SD.QCOptionMatchAntiI("IndexOfOptionDr",aOptionDr,xRowID))
		Quit:xRowID=""
		Set MatchObj=##class(DHCMA.CPW.SD.QCOptionMatchAnti).GetObjById(xRowID)
		Continue:'$Isobject(MatchObj)
		Set AntiItem=MatchObj.AntiItem
		Continue:'$Isobject(AntiItem)
		Set CodeStr=CodeStr_"^"_AntiItem.BTCode
	}
	Quit CodeStr
}

/// 从Excel文档导入表单值域与标准抗菌药字典对照关系
ClassMethod ImportMatchRules(aInputStr As %String) As %String
{
	n (aInputStr)
	Set return=""
	Set DicType		=$p(aInputStr,"^",1)
	Set DicCode		=$p(aInputStr,"^",2)
	Set AntiItemDesc=$p(aInputStr,"^",3)
	Set AntiCatCode	=$p(aInputStr,"^",4)
	Set QCAbb		=$p(aInputStr,"^",5)
	Set VerCode		=$p(aInputStr,"^",6)
	Set QCID=$o(^DHCMA.CPW.SD.QCEntityI("IdxofAbb",QCAbb,0))
	Quit:QCID="" return
	Set VersionObj=##class(DHCMA.CPW.SD.QCEntityVersion).GetObjByCode(VerCode)
	Quit:'$IsOBject(VersionObj) return
	Set VerID=VersionObj.%Id()
	Set DicObj=##class(DHCMA.CPW.SDS.DictionarySrv).GetObjByPCodeItemCode(QCID,VerID,DicType,DicCode)
	Quit:'$IsObject(DicObj) return
	Set DicId=DicObj.%Id()
	Set rs=##Class(%ResultSet).%New("DHCMA.CPW.SDMatchSrv.AntiItemSrv:QryAntiItem")
  	Set sc=rs.Execute(AntiCatCode)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	Set Err=""
    While (rs.Next()){
	    Set AntiCode=rs.Data("BTCode") 
	    Set AntiDec=rs.Data("BTDesc")
	    Set AntiID=rs.Data("BTID")  
	    continue:(AntiItemDesc'="")&&(AntiDec'=AntiItemDesc)
	    Set InputStr=DicId_"^"_AntiID
		Set ret=##class(DHCMA.CPW.SD.QCOptionMatchAnti).Update(InputStr)
		if (+ret<0) {
				Set Err=Err_"^"_AntiCode
			}
    }
    Set:Err="" return=1
    b:Err'=""
    Quit +return
}

}
