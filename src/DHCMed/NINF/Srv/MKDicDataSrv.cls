/// 名称: DHCMed.NINF.Srv.MKDicDataSrv
/// 描述: 基础字典数据对照程序
/// 编写者：zhufei
/// 编写日期: 2013-06-13
Class DHCMed.NINF.Srv.MKDicDataSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照抗生素字典(检验->院感)
/// Table：       CT_Antibiotics(检验抗生素字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToInfAntiDic()
ClassMethod ProcessDataToInfAntiDic() As %String
{
	New
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTAntibioticsD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTAntibiotics).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.IsActive'=1
		Set AntiCode=obj.Code
		Set AntiName=obj.CName
		Continue:AntiName=""
		
		Set Category="InfDicAntibiotics"
		Set SrcValue=AntiCode
		Set SrcDesc=AntiName
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToANT("ANTDesc",SrcDesc)    //抗生素
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,2)
			Set TargetDesc=$list(tmpTarget,3)
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照病原体字典(检验->院感)
/// Table：       CT_Bugs(检验病原体字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToInfPyDic()
ClassMethod ProcessDataToInfPyDic() As %String
{
	New
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTOrganismD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set PyCode=obj.Code
		Set PyName=obj.CName
		Continue:PyName=""
		
		Set Category="InfDicPathogeny"
		Set SrcValue=PyCode
		Set SrcDesc=PyName
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToPY("PYDesc",SrcDesc)    //病原体
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,2)
			Set TargetDesc=$list(tmpTarget,3)
		} Else {
			Set tmpSrcDesc=$tr(SrcDesc,"氏","")
			Set tmpTarget=..GetTargetToPY("PYDesc",tmpSrcDesc)    //病原体
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,2)
				Set TargetDesc=$list(tmpTarget,3)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照病原体字典(检验->民科)
/// Table：       DHCMed.NINF.Dic.Pathogeny(院感病原体字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToMKPyDic01()
ClassMethod ProcessDataToMKPyDic01() As %String
{
	New
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTOrganismD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTOrganism).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set PyCode=obj.Code
		Set PyName=obj.CName
		Continue:PyName=""
		
		Set Category="MKPathogeny"
		Set SrcValue=PyName
		Set SrcDesc=PyCode
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToMKDIC("000001007","Description",SrcValue)    //病原体
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,3)
			Set TargetDesc=$list(tmpTarget,4)
		} Else {
			Set tmpTarget=..GetTargetToMKDIC("000001007","[Description]",SrcValue)    //病原体
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,3)
				Set TargetDesc=$list(tmpTarget,4)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照病原体字典(院感->民科)
/// Table：       DHCMed.NINF.Dic.Pathogeny(院感病原体字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToMKPyDic02()
ClassMethod ProcessDataToMKPyDic02() As %String
{
	New
	
	Set PyID=""
	For {
		Set PyID=$o(^DHCMed.NINFD("Py",PyID))
		Quit:PyID=""
		
		Set objDic=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(PyID)
	 	Continue:'$IsObject(objDic)
	 	Set Active=objDic.PYActive
	 	Continue:Active'=1
	 	Set Code=objDic.PYCode
	 	Set Desc=objDic.PYDesc
	 	Continue:Desc=""
	 	Set Desc1=objDic.PYDesc1
	 	Set Pinyin=objDic.PYPinyin
	 	Set Whonet=objDic.PYWhonet
	 	
		Set Category="MKPathogeny"
		Set SrcValue=Desc
		Set SrcDesc=Desc1
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToMKDIC("000001007","Description",SrcValue)    //病原体
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,3)
			Set TargetDesc=$list(tmpTarget,4)
		} Else {
			Set tmpTarget=..GetTargetToMKDIC("000001007","Description",SrcDesc)    //病原体
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,3)
				Set TargetDesc=$list(tmpTarget,4)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照抗生素字典(检验->民科)
/// Table：       DHCMed.NINF.Dic.Antibiotics(院感抗生素字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToMKAntiDic01()
ClassMethod ProcessDataToMKAntiDic01() As %String
{
	New
	
	//update by zf 20160308 数据池相关程序修改(检验)
	Set xID=0
	For {
		Set xID=$o(^DHCMed.DC.LIS.BTAntibioticsD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCMed.DC.LIS.BTAntibiotics).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set AntiCode=obj.Code
		Set AntiName=obj.CName
		Continue:AntiName=""
		
		Set Category="MKAntibiotics"
		Set SrcValue=AntiName
		Set SrcDesc=AntiCode
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToMKDIC("000001005","Description",SrcValue)    //抗生素
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,3)
			Set TargetDesc=$list(tmpTarget,4)
		} Else {
			Set tmpTarget=..GetTargetToMKDIC("000001005","[Description]",SrcValue)    //抗生素
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,3)
				Set TargetDesc=$list(tmpTarget,4)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照抗生素字典(院感->民科)
/// Table：       DHCMed.NINF.Dic.Antibiotics(院感抗生素字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToMKAntiDic02()
ClassMethod ProcessDataToMKAntiDic02() As %String
{
	New
	
	Set AntiID=""
	For {
		Set AntiID=$o(^DHCMed.NINFD("Anti",AntiID))
		Quit:AntiID=""
		
		Set objDic=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(AntiID)
	 	Continue:'$IsObject(objDic)
	 	Set Active=objDic.ANTActive
	 	Continue:Active'=1
	 	Set Code=objDic.ANTCode
	 	Set Desc=objDic.ANTDesc
	 	Continue:Desc=""
	 	Set Desc1=objDic.ANTDesc1
	 	Set Pinyin=objDic.ANTPinyin
	 	Set Whonet=objDic.ANTWhonet
	 	
		Set Category="MKAntibiotics"
		Set SrcValue=Desc
		Set SrcDesc=Desc1
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToMKDIC("000001005","Description",SrcValue)    //抗生素
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,3)
			Set TargetDesc=$list(tmpTarget,4)
		} Else {
			Set tmpTarget=..GetTargetToMKDIC("000001005","Description",SrcDesc)    //抗生素
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,3)
				Set TargetDesc=$list(tmpTarget,4)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2013-06-13
/// Description:  自动对照诊断(ICD10)字典(院感->民科)
/// Table：       MRC_ICDDx(诊断(ICD10)字典)
///               DHCMed.NINF.Srv.MKDicMapping(基础字典对照表)
/// Input：       无
/// w ##class(DHCMed.NINF.Srv.MKDicDataSrv).ProcessDataToMKICDDic()
ClassMethod ProcessDataToMKICDDic() As %String
{
	New
	
	Set xID=""
	For {
		Set xID=$o(^MRC("ID",xID))
		Quit:xID=""
		
		Set tmpDic=$g(^MRC("ID",xID))
		Set ICDDesc=$p(tmpDic,"^",2)
		Continue:ICDDesc=""
		Set ICD10=$p(tmpDic,"^",4)
		
		Set Category="MKDiagnos"
		Set SrcValue=ICDDesc
		Set SrcDesc=ICD10
		Set TargetValue=""
		Set TargetDesc=""
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcValue,"U"),""))
		If ID'="" {
			Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetObjById(ID)
			If $IsObject(objMap) {
				Set TargetValue=objMap.Target
				Set TargetDesc=objMap.TargetDesc
			}
		}
		Continue:TargetValue'=""
		
		Set tmpTarget=..GetTargetToMKDIC("000001006","Description",SrcValue)    //抗生素
		If tmpTarget'="" {
			Set TargetValue=$list(tmpTarget,3)
			Set TargetDesc=$list(tmpTarget,4)
		} Else {
			Set tmpTarget=..GetTargetToMKDIC("000001006","Code",SrcDesc)    //抗生素
			If tmpTarget'="" {
				Set TargetValue=$list(tmpTarget,3)
				Set TargetDesc=$list(tmpTarget,4)
			}
		}
		
		Set aInputStr=ID
		Set aInputStr=aInputStr_"^"_Category
		Set aInputStr=aInputStr_"^"_SrcValue
		Set aInputStr=aInputStr_"^"_SrcDesc
		Set aInputStr=aInputStr_"^"_TargetValue
		Set aInputStr=aInputStr_"^"_TargetDesc
		Set aInputStr=aInputStr_"^"_""
		Write TargetValue_"///"_aInputStr,!
		Set flg=##Class(DHCMed.NINF.Srv.MKDicMapping).Update(aInputStr,"^")
		If flg<0 {
			Write "Arguments"_aInputStr,!
			Write "return="_flg,!
		}
	}
	
	Quit "OK"
}

/// w ##Class(DHCMed.NINF.Srv.MKDicDataSrv).GetTargetToPY("PYDesc","Enterobacter aerogenes(产气肠杆菌)")
ClassMethod GetTargetToPY(aFieldText As %String, aFieldValue As %String) As %List
{
	New (aFieldText,aFieldValue)
	Set return=""
	Quit:(aFieldText="")||(aFieldValue="") return
	
	//按照名称对照
	If aFieldText="PYDesc" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFDi("Py",0,"IndexDesc"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
		
			Set objDic=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	Set Active=objDic.PYActive
		 	Continue:Active'=1
		 	Set Code=objDic.PYCode
		 	Set Desc=objDic.PYDesc
		 	Continue:aFieldValue'=Desc
		 	Set Desc1=objDic.PYDesc1
		 	Set Pinyin=objDic.PYPinyin
		 	Set Whonet=objDic.PYWhonet
	 		
		 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
		}
		Quit:return'="" return
		
		Set xDesc=""
		For {
			Set xDesc=$o(^DHCMed.NINFDi("Py",0,"IndexDesc",xDesc))
			Quit:xDesc=""
			Quit:return'=""
			
			Continue:$zcvt(aFieldValue,"U")'[$e(xDesc,2,$l(xDesc))
			
			Set xID=0
			For {
				Set xID=$o(^DHCMed.NINFDi("Py",0,"IndexDesc",xDesc,xID))
				Quit:xID=""
				Quit:return'=""
				
				Set objDic=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(xID)
			 	Continue:'$IsObject(objDic)
			 	Set Active=objDic.PYActive
			 	Continue:Active'=1
			 	Set Code=objDic.PYCode
			 	Set Desc=objDic.PYDesc
			 	Set Desc1=objDic.PYDesc1
			 	Set Pinyin=objDic.PYPinyin
			 	Set Whonet=objDic.PYWhonet
		 		
			 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
			}
		}
	}
	
	//按照WHONET码对照
	If aFieldText="PYWhonet" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFDi("Py",0,"IndexWHONet"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	Set Active=objDic.PYActive
		 	Continue:Active'=1
		 	Set Code=objDic.PYCode
		 	Set Desc=objDic.PYDesc
		 	Set Desc1=objDic.PYDesc1
		 	Set Pinyin=objDic.PYPinyin
		 	Set Whonet=objDic.PYWhonet
		 	Continue:$zcvt(aFieldValue,"U")'=$zcvt(Whonet,"U")
	 		
		 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
		}
	}
	
	Quit return
}

ClassMethod GetTargetToANT(aFieldText As %String, aFieldValue As %String) As %List
{
	New (aFieldText,aFieldValue)
	Set return=""
	Quit:(aFieldText="")||(aFieldValue="") return
	
	//按照名称对照
	If aFieldText="ANTDesc" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	Set Active=objDic.ANTActive
		 	Continue:Active'=1
		 	Set Code=objDic.ANTCode
		 	Set Desc=objDic.ANTDesc
		 	Continue:aFieldValue'=Desc
		 	Set Desc1=objDic.ANTDesc1
		 	Set Pinyin=objDic.ANTPinyin
		 	Set Whonet=objDic.ANTWhonet
	 		
		 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
		}
		Quit:return'="" return
		
		Set xDesc=""
		For {
			Set xDesc=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc",xDesc))
			Quit:xDesc=""
			Quit:return'=""
			
			Continue:$zcvt(aFieldValue,"U")'[$e(xDesc,2,$l(xDesc))
			
			Set xID=0
			For {
				Set xID=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc",xDesc,xID))
				Quit:xID=""
				Quit:return'=""
				
				Set objDic=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(xID)
			 	Continue:'$IsObject(objDic)
			 	Set Active=objDic.ANTActive
			 	Continue:Active'=1
			 	Set Code=objDic.ANTCode
			 	Set Desc=objDic.ANTDesc
			 	Set Desc1=objDic.ANTDesc1
			 	Set Pinyin=objDic.ANTPinyin
			 	Set Whonet=objDic.ANTWhonet
		 		
			 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
			}
		}
	}
	
	//按照WHONET码对照
	If aFieldText="ANTWhonet" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFDi("Py",0,"IndexWHONet"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	Set Active=objDic.ANTActive
		 	Continue:Active'=1
		 	Set Code=objDic.ANTCode
		 	Set Desc=objDic.ANTDesc
		 	Set Desc1=objDic.ANTDesc1
		 	Set Pinyin=objDic.ANTPinyin
		 	Set Whonet=objDic.ANTWhonet
		 	Continue:$zcvt(aFieldValue,"U")'=$zcvt(Whonet,"U")
	 		
		 	Set return=$lb(xID,Code,Desc,Desc1,Pinyin,Whonet)
		}
	}
	
	Quit return
}

ClassMethod GetTargetToMKDIC(aMainCode As %String, aFieldText As %String, aFieldValue As %String) As %List
{
	New (aMainCode,aFieldText,aFieldValue)
	Set return=""
	Quit:(aMainCode="")||(aFieldText="")||(aFieldValue="") return
	
	//按照名称对照
	If aFieldText="Description" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFSi("MKDic",0,"IndexDesc"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IDCode=objDic.IDCode
			Continue:$e(IDCode,1,$l(aMainCode))'=aMainCode
			Set CurrIDCode=" "_IDCode
			Set NextIDCode=$o(^DHCMed.NINFSi("MKDic",0,"IndexIDCode",CurrIDCode))
			Continue:$e(NextIDCode,1,$l(CurrIDCode))=CurrIDCode
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set Spell=objDic.Spell
		 	Set return=$lb(xID,IDCode,Code,Desc,Spell)
		}
	}
	
	//按照名称包含对照
	If aFieldText="[Description]" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFS("MKDic",xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IDCode=objDic.IDCode
			Continue:$e(IDCode,1,$l(aMainCode))'=aMainCode
			Set CurrIDCode=" "_IDCode
			Set NextIDCode=$o(^DHCMed.NINFSi("MKDic",0,"IndexIDCode",CurrIDCode))
			Continue:$e(NextIDCode,1,$l(CurrIDCode))=CurrIDCode
			Set IDDesc=objDic.Description
			Continue:$zcvt(aFieldValue,"U")'[$zcvt(IDDesc,"U")
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set Spell=objDic.Spell
		 	Set return=$lb(xID,IDCode,Code,Desc,Spell)
		}
	}
	
	//按照代码对照
	If aFieldText="Code" {
		Set xID=0
		For {
			Set xID=$o(^DHCMed.NINFSi("MKDic",0,"IndexCode"," "_$zcvt(aFieldValue,"U"),xID))
			Quit:xID=""
			Quit:return'=""
			
			Set objDic=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IDCode=objDic.IDCode
			Continue:$e(IDCode,1,$l(aMainCode))'=aMainCode
			Set CurrIDCode=" "_IDCode
			Set NextIDCode=$o(^DHCMed.NINFSi("MKDic",0,"IndexIDCode",CurrIDCode))
			Continue:$e(NextIDCode,1,$l(CurrIDCode))=CurrIDCode
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set Spell=objDic.Spell
		 	Set return=$lb(xID,IDCode,Code,Desc,Spell)
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.NINF.Srv.MKDicDataSrv).Test()
ClassMethod Test()
{
	New
	
	Set ID=0
	For {
		Set ID=$o(^DHCMed.NINFS("MKDic",ID))
		Quit:ID=""
		
		Set obj=##Class(DHCMed.NINF.Srv.MKDicMapping).%OpenId(ID)
		Continue:'$IsObject(obj)
		Set SrcValue=obj.SrcObjectID
		Set SrcDesc=obj.SrcDescription
		Set SrcValue=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcValue)
		Set SrcDesc=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcDesc)
		
		Set obj.SrcObjectID=SrcValue
		Set obj.SrcDescription=SrcDesc
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {  //检查Save是否成功
	   		Do $System.OBJ.DisplayError(sc)
	   		w !,SrcValue_"///"_SrcDesc,!
	   		Set return=-1
		} Else {
			Set return=obj.%Id()
		}
		Do obj.%Close()
	}
	
	Quit "OK"
}

}
