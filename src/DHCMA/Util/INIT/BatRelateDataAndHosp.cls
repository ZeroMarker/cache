/// 名称: DHCMA.Util.INIT.InitBatRelDataAndHosp
/// 描述: 批量生成各产品基础数据/配置数据与院区关系
/// 编写者：yankai
/// 编写日期: 2021-08-03
Class DHCMA.Util.INIT.BatRelateDataAndHosp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 入参：取值"Y"为启用基于基础数据平台的多院区配置；取值为"N"为不启用；
/// 一键修改多院区参数配置（执行将更新所有院区下参数"SYSIsOpenMultiHospMode"的配置值）
/// w ##class(DHCMA.Util.INIT.BatRelateDataAndHosp).ChangeMultiHospCfgValue("Y")
ClassMethod ChangeMultiHospCfgValue(aValue As %String) As %String
{
	New (aValue)
	Set return=""
	Quit:aValue="" return
	
	Set aCode="SYSIsOpenMultiHospMode"
	Quit:(aValue'="Y")&&(aValue'="N") "Error^请按规则赋值"
	Set xHospID=""
	For {
		Set xHospID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U"),xHospID))
		Quit:xHospID="" 
		
		Set xID="",aInputStr=""
		For {
			Set xID=$o(^DHCMA.Util.BT.ConfigI("IdxofCode"," "_$zcvt(aCode,"U"),xHospID,xID))
			Quit:xID=""
			
			Set objConf=##class(DHCMA.Util.BT.Config).GetObjById(xID)
			Continue:'$IsObject(objConf)
			
			Set aInputStr=xID_"^"_objConf.BTCode_"^"_objConf.BTDesc_"^"_aValue_"^"_$tr(xHospID," ")_"^"_objConf.BTProductDr.%Id()_"^"_objConf.BTIsActive_"^"_objConf.BTActUserID_"^"_objConf.BTComments
			Set ret=##class(DHCMA.Util.BT.Config).Update(aInputStr,"^")
			Set:ret<0 return=ret_"^"_xID
			Quit:return'=""
		}
		Quit:return'=""
	}
	
	Set:return="" return=1
	Quit return
}

/// 批量生成临床路径下基础数据与指定院区关系
/// w ##class(DHCMA.Util.INIT.BatRelateDataAndHosp).BatSaveRelRecsToCPW("2!!1")
ClassMethod BatSaveRelRecsToCPW(aHospID As %String) As %String
{
	New (aHospID)
	Set return=""
	Quit:aHospID="" return
	
	//MA下产品基础字典
	Do ..BatSaveRelRecsToMA(aHospID,"CPW")
	
	//路径类型字典：DHCMA_CPW_BT.PathType
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathTypeD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathType",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathType",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "路径类型字典：DHCMA_CPW_BT.PathType，更新成功"_Count_"条",!
	
	//表单项目分类：DHCMA_CPW_BT.PathItemCat
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathItemCatD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathItemCat",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathItemCat",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "表单项目分类：DHCMA_CPW_BT.PathItemCat，更新成功"_Count_"条",!
	
	//变异类型维护：DHCMA_CPW_BT.PathVarCat
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathVarCatD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathVarCat",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathVarCat",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "变异类型维护：DHCMA_CPW_BT.PathVarCat，更新成功"_Count_"条",!
	
	//变异字典维护：DHCMA_CPW_BT.PathVariat
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathVariatD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathVariat",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathVariat",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "变异字典维护：DHCMA_CPW_BT.PathVariat，更新成功"_Count_"条",!
	
	//病种字典维护：DHCMA_CPW_BT.PathEntity
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathEntityD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathEntity",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathEntity",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "病种字典维护：DHCMA_CPW_BT.PathEntity，更新成功"_Count_"条",!
	
	
	//合并症维护：DHCMA_CPW_BT.PathCompl
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathComplD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathCompl",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathCompl",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "合并症维护：DHCMA_CPW_BT.PathCompl，更新成功"_Count_"条",!
	
	//中药方剂维护：DHCMA_CPW_BT.PathTCM
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathTCMD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathTCM",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathTCM",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "中药方剂维护：DHCMA_CPW_BT.PathTCM，更新成功"_Count_"条",!
	
	//路径字典维护：DHCMA_CPW_BT.PathMast
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.PathMastD(xID)) 
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.PathMast",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.PathMast",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "路径字典维护：DHCMA_CPW_BT.PathMast，更新成功"_Count_"条",!
	
	//调查问卷维护：DHCMA_CPW_BT.Survey
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.CPW.BT.SurveyD(xID))
		Quit:xID=""
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_CPW_BT.Survey",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_CPW_BT.Survey",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "临床路径问卷：DHCMA_CPW_BT.Survey，更新成功"_Count_"条",!
	Quit ""
}

/// 批量生成重点患者下基础数据与指定院区关系
/// w ##class(DHCMA.Util.INIT.BatRelateDataAndHosp).BatSaveRelRecsToIMP("2!!1")
ClassMethod BatSaveRelRecsToIMP(aHospID As %String) As %String
{
	New (aHospID)
	Set return=""
	Quit:aHospID="" return
	
	//MA下产品基础字典
	Do ..BatSaveRelRecsToMA(aHospID,"IMP")
	
	Quit ""
}

/// Desc:	批量生成MA基础程序下基础数据与指定院区关系
/// Input：	aHospID:指定院区oid 
/// 		aProCode:产品代码（DHCMA.Util.BT.Product表ProCode）
/// Output:	
/// w ##class(DHCMA.Util.INIT.BatRelateDataAndHosp).BatSaveRelRecsToMA("2!!1","CPW")
ClassMethod BatSaveRelRecsToMA(aHospID As %String, aProCode As %String) As %String
{
	New (aHospID,aProCode)
	Set return=""
	Quit:(aHospID="")||(aProCode="") return
	
	//获取产品
	Set objPro=##class(DHCMA.Util.BT.Product).GetObjByCode(aProCode)
	Quit:'$IsObject(objPro) "-1"
	Set ProID=objPro.%Id()
	
	//产品字典：DHCMA_Util_BT.Dictionary
	Set xID=0,Count=0
	For
	{ 
		Set xID=$o(^DHCMA.Util.BT.DictionaryD(xID)) 
		Quit:xID=""
		
		Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjById(xID)
		Continue:'$IsObject(objDic)
		Continue:objDic.BTTypeDr.BTProductDr.%Id()'=ProID
		   
		If '$d(^User.BDPMappingHospI("HospRef","DHCMA_Util_BT.Dictionary",xID))
		{
			Set ret=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHCMA_Util_BT.Dictionary",xID,$p(aHospID,"!!",1))
			Set:$p(ret,"^",1)>0 Count=Count+1
		}
	}
	w "产品字典：DHCMA_Util_BT.Dictionary，更新成功"_Count_"条",!
	
	Quit ""
}

}
