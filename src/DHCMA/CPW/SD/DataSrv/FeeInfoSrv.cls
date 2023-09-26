Class DHCMA.CPW.SD.DataSrv.FeeInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s a=##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).GetDataByAdm(2687223)
ClassMethod GetDataByAdm(aEpisodeID As %String, aItemID As %String = "") As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aEpisodeID,aItemID)
	Set $zt="GetDataByAdmErr"
	Set return=""
	Set FeeID=$o(^DHCMA.CPW.SD.Data.FeeInfoI("IdxAdm",aEpisodeID,""),-1)
	If (FeeID="") {
		d ..SynFeeByAdm(aEpisodeID)	
		Set FeeID=$o(^DHCMA.CPW.SD.Data.FeeInfoI("IdxAdm",aEpisodeID,""),-1)
	}
	Quit:FeeID="" return
	Set return=##class(DHCMA.CPW.SD.Data.FeeInfo).GetObjById(FeeID)
	If (aItemID'=""){
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(objItem) return
		Set aItemDesc=objItem.BTDesc
		Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
		Quit:DicID="" return
		Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
		Quit:TabelInfo="" return
		Set Field=$p(TabelInfo,"^",2)
		set $property(return,Field)="*"_$property(return,Field)
	}
	Quit return
GetDataByAdmErr
	Quit return
}

/// w ##class(DHCMA.CPW.SD.DataSrv.FeeInfoSrv).SynFeeByAdm(2814486)
ClassMethod SynFeeByAdm(aEpisodeID As %String) As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aEpisodeID)
	Set return="未成功同步费用信息"
	Quit:(aEpisodeID="") return
	//荣县人民医院
	//自付金额
	Set zfje=""  //项目提供接口 取自付金额
	Set Treefee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(aEpisodeID,"")

	Set Fee1  = $p($p(Treefee,"!",1),"^",3)			//总费用
	Set Fee2  = zfje								//住院总费用其中自付金额
	Set Fee3  = $p($p(Treefee,"!",2),"^",3) 		//一般医疗服务费
	Set Fee4  = $p($p(Treefee,"!",3),"^",3)			//一般治疗操作费
	Set Fee5  = $p($p(Treefee,"!",4),"^",3)			//护理费住院费
	Set Fee6  = $p($p(Treefee,"!",5),"^",3)			//其他费用
	Set Fee7  = $p($p(Treefee,"!",6),"^",3)			//病理诊断费
	Set Fee8  = $p($p(Treefee,"!",7),"^",3)			//实验室诊断费
	Set Fee9  = $p($p(Treefee,"!",8),"^",3)			//影像学诊断费
	Set Fee10 = $p($p(Treefee,"!",9),"^",3)			//临床诊断项目费
	Set Fee11 = $p($p(Treefee,"!",10),"^",3)+$p($p(Treefee,"!",28),"^",3)	//非手术治疗项目费
	Set Fee12 = $p($p(Treefee,"!",28),"^",3)		//临床物理治疗费
	Set Fee13 = $p($p(Treefee,"!",11),"^",3)+$p($p(Treefee,"!",12),"^",3)	//手术治疗费
	Set Fee14 = $p($p(Treefee,"!",11),"^",3)		//麻醉费
	Set Fee15 = $p($p(Treefee,"!",12),"^",3)		//手术费
	Set Fee16 = $p($p(Treefee,"!",13),"^",3)		//康复费
	Set Fee17 = $p($p(Treefee,"!",14),"^",3)		//中医治疗费
	Set Fee18 = $p($p(Treefee,"!",16),"^",3)+$p($p(Treefee,"!",15),"^",3)	//西药费
	Set Fee19 = $p($p(Treefee,"!",15),"^",3)		//抗菌药物费
	Set Fee20 = $p($p(Treefee,"!",17),"^",3)		//中成药费
	Set Fee21 = $p($p(Treefee,"!",18),"^",3)		//中草药费
	Set Fee22 = $p($p(Treefee,"!",19),"^",3)		//血费
	Set Fee23 = $p($p(Treefee,"!",20),"^",3)		//白蛋白类制品费
	Set Fee24 = $p($p(Treefee,"!",21),"^",3)		//球蛋白类制品费
	Set Fee25 = $p($p(Treefee,"!",22),"^",3)		//凝血因子类制品费
	Set Fee26 = $p($p(Treefee,"!",23),"^",3)		//细胞因子类制品费
	Set Fee27 = $p($p(Treefee,"!",24),"^",3)		//耗材类:(21)检查用一次性医用材料费
	Set Fee28 = $p($p(Treefee,"!",25),"^",3)		//(22)治疗用一次性医用材料费
	Set Fee29 = $p($p(Treefee,"!",26),"^",3)		//(23)手术用一次性医用材料费
	Set Fee30 = $p($p(Treefee,"!",27),"^",3)		//其他类： (24)其他费
	Set xInputStr=aEpisodeID_"^"_Fee1_"^"_Fee2_"^"_Fee3_"^"_Fee4_"^"_Fee5_"^"_Fee6_"^"_Fee7_"^"_Fee8_"^"_Fee9_"^"_Fee10_"^"_Fee11_"^"_Fee12_"^"_Fee13_"^"_Fee14_"^"_Fee15_"^"_Fee16_"^"_Fee17_"^"_Fee18_"^"_Fee19_"^"_Fee20_"^"_Fee21_"^"_Fee22_"^"_Fee23_"^"_Fee24_"^"_Fee25_"^"_Fee26_"^"_Fee27_"^"_Fee28_"^"_Fee29_"^"_Fee30
	Set ret=##class(DHCMA.CPW.SD.Data.FeeInfo).Update(xInputStr,"^")
	Set:ret>0 return="同步费用信息成功"
	Quit return
}

}
