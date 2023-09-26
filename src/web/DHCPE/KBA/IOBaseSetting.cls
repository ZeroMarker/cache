/// 名称: web.DHCPE.KBA.IOBaseSetting
/// 描述: 配合导出、导入的公共设置类
Class web.DHCPE.KBA.IOBaseSetting Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// 分隔符
Parameter Delimiter = "^";

/// 原科室ID
Parameter OutLocID = 364;

/// 目标科室ID 多值"^"分割
Parameter InLocID = 364;

/// 可通过此方法查看科室组设置
/// d ##class(web.DHCPE.KBA.IOBaseSetting).ViewLocGrpInfo()
ClassMethod ViewLocGrpInfo() As %String
{
	New
	Kill arrLocGrp
	Set arrLocGrp(0,0)=$lb("科室ID","科室","别名","科室组ID","科室组","院区")
	Set xID=0
	For {
		Set xID=$o(^CF.PE.LocGrpConfigD(xID))
		Quit:xID=""
		
		Set LocID=$listget($g(^CF.PE.LocGrpConfigD(xID)),2) //科室ID
		Set LocGrpID=$listget($g(^CF.PE.LocGrpConfigD(xID)),3) //科室组默认科室ID
		Set LocDesc2=$listget($g(^CF.PE.LocGrpConfigD(xID)),4) //科室别名
		Set Active=$listget($g(^CF.PE.LocGrpConfigD(xID)),5) //激活
		Continue:Active'="Y"
		Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
		Set LocGrpDesc=$p($g(^CTLOC(+LocGrpID)),"^",2)
		Set HospDR=$p($g(^CTLOC(+LocID)),"^",22)
 		Set HospDesc=$P($g(^CT("HOSP",+HospDR)),"^",2)
 		
 		Set arrLocGrp(+LocGrpID,xID)=$lb(LocID,LocDesc,LocDesc2,LocGrpID,LocGrpDesc,HospDesc)
	}
	zw arrLocGrp
	Quit "OK"
}

/// 获取导出科室信息，用于导出时提醒
/// w ##class(web.DHCPE.KBA.IOBaseSetting).GetOutLocInfo()
ClassMethod GetOutLocInfo() As %String
{
	New
	Set OutLocID=..#OutLocID
	Quit:(OutLocID="") "0^原科室不允许为空"
	
	Set LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_OutLocID,0))
	Quit:LGLocDR="" "-1^原科室设置错误！"
	Set LocGrpID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //取默认科室
	Quit:LocGrpID="" "-1^原科室设置错误！"
	
	Set LocDesc=$p($g(^CTLOC(OutLocID)),"^",2)
	Set LocGrpDesc=$p($g(^CTLOC(LocGrpID)),"^",2)
	Quit "1^"_LocDesc_" 科室组:"_LocGrpDesc
}

/// 获取导入科室信息，用于导入时提醒
/// w ##class(web.DHCPE.KBA.IOBaseSetting).GetInLocInfo()
ClassMethod GetInLocInfo() As %String
{
	New
	Set InLocID=..#InLocID
	Quit:(InLocID="") "0^目标科室不允许为空"
	
	Set InLocStr=""
	For idxInLoc=1:1:$l(InLocID,"^"){
		Set xInLocID=$p(InLocID,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_xInLocID,0))
		Continue:LGLocDR=""
		Set LocGrpID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //取默认科室
		Continue:LocGrpID=""
		
		Set LocDesc=$p($g(^CTLOC(xInLocID)),"^",2)
		Set LocGrpDesc=$p($g(^CTLOC(LocGrpID)),"^",2)
		Set InLocStr=InLocStr_"^"_LocDesc_" 科室组:"_LocGrpDesc
	}
	Quit:InLocStr="" "-2^目标科室设置错误！"
	Quit:$l(InLocStr,"^")<$l(InLocID,"^") "-2^目标科室设置错误！"
	
	Quit "1"_InLocStr
}

}
