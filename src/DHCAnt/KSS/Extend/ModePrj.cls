/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 抗菌药物项目本地化的扩展业务类
Class DHCAnt.KSS.Extend.ModePrj Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 保存扩展数据
/// IN  :  
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.ModePrj).SaveModePrjInfo()
ClassMethod SaveModePrjInfo(useAimId As %String, AARowid As %String, ModePrjInfo As %String) As %String
{
	n (useAimId,AARowid,ModePrjInfo)
	
	s mRtn=0
 	s ModePrjDTO=##class(DHCAnt.Base.Dto.ModePrj).%New()
	d ModePrjDTO.XMLNodeDeserialize(.ModePrjDTO, "ModePrj", ModePrjInfo)
	s SaveOBJ=##class(User.DHCAntModePrj).%New()
	
	d SaveOBJ.AimDrSetObjectId(useAimId)
	d SaveOBJ.ApplyDrSetObjectId(AARowid)
	
	s SaveOBJ.HasGMis=ModePrjDTO.HasGMis
	s SaveOBJ.GMDrug=ModePrjDTO.GMDrug
	s SaveOBJ.GMClassify=ModePrjDTO.GMClassify
	
	s SaveOBJ.CRP=ModePrjDTO.CRP
	s SaveOBJ.N=ModePrjDTO.N
	s SaveOBJ.PCT=ModePrjDTO.PCT
	s SaveOBJ.T=ModePrjDTO.T
	s SaveOBJ.WBC=ModePrjDTO.WBC
	s SaveOBJ.GRQT=ModePrjDTO.GRQT
	s SaveOBJ.G=ModePrjDTO.G
	s SaveOBJ.GM=ModePrjDTO.GM
	
	s SaveOBJ.HasBYX=ModePrjDTO.HasBYX
	s SaveOBJ.BYXResult=ModePrjDTO.BYXResult
	
	s SaveOBJ.HasCombined=ModePrjDTO.HasCombined
	s SaveOBJ.CombinedDrug=ModePrjDTO.CombinedDrug
	s SaveOBJ.CombinedReason=ModePrjDTO.CombinedReason
	
	s SaveOBJ.JL=ModePrjDTO.JL
	d SaveOBJ.JLUomSetObjectId(ModePrjDTO.JLUom)
	s SaveOBJ.Freq=ModePrjDTO.Freq
	s SaveOBJ.Instruc=ModePrjDTO.Instruc
	d SaveOBJ.PriorSetObjectId(ModePrjDTO.Prior)
	s SaveOBJ.DrugReason=ModePrjDTO.DrugReason
	
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		Quit "-101"
	}
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 根据会诊ID获取：过敏史、感染情况、病原学检查、药品通用名、使用方法、药品选择理由
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.ModePrj).GetAntiInfoByConId(29264)
ClassMethod GetAntiInfoByConId(conid As %String, SP As %String = "^")
{
	n (conid,SP)
	s mRtn=""
	q:'$d(^DHCDAAi("Consult",conid)) mRtn
	s aaid=$o(^DHCDAAi("Consult",conid,""))
	q:aaid="" mRtn
	s modeid=$o(^BS.ANT.DHCAntModePrjI("ApplyDr",aaid,""))
	q:modeid="" mRtn
	
	s MPrjOBJ=##class(User.DHCAntModePrj).%OpenId(modeid)
	s aimDr=$p(^DHCDAA("ANT",aaid,1),"^",20)
	s useAimDr=$p(^DAUP("DAUP",aimDr),"^",20)
	s bodyPartDr=$p(^DAUP("DAUP",aimDr),"^",6)
	s useAimDesc=$p(^DHCAntBasePurposeDataConfigD(useAimDr),"^",3)	;使用目的
	s bodyPartDesc=$p(^DHCAntBasePurposeDataConfigD(bodyPartDr),"^",3)	;感染部位
	
	;过敏史
	s HasGMis=MPrjOBJ.HasGMis	;有无过敏史
	s GMDrug=MPrjOBJ.GMDrug		;其他过敏药物
	s GMClassify=MPrjOBJ.GMClassify		;过敏分类
	s GMClassifyName=""
	s Len=$l(GMClassify,",")
	i GMClassify'="" d
	.f i=1:1:Len d
	..s cid=$p(GMClassify,",",i)
	..s cname=..GetGMClassifyName(cid)
	..i GMClassifyName="" s GMClassifyName=cname
	..e  s GMClassifyName=GMClassifyName_","_cname
	
	;感染情况
	s T=MPrjOBJ.T		;T℃
	s WBC=MPrjOBJ.WBC	;WBC
	s N=MPrjOBJ.N		;N
	s CRP=MPrjOBJ.CRP	;CRP
	s PCT=MPrjOBJ.PCT	;PCT
	s G=MPrjOBJ.G		;G
	s GM=MPrjOBJ.GM		;GM
	s GRQT=MPrjOBJ.GRQT	;其他
    
    ;病原学检查
    s HasBYX=MPrjOBJ.HasBYX			;是否做过病原学检查
	s BYXResult=MPrjOBJ.BYXResult	;病原学检查结果
	
	;药品通用名
    s HasCombined=MPrjOBJ.HasCombined	;是否联用
	s CombinedDrug=MPrjOBJ.CombinedDrug	;联用药品通用名
	s CombinedReason=MPrjOBJ.CombinedReason	;联用理由
    
    ;使用方法
    s JL=MPrjOBJ.JL		;单次剂量
	s Freq=MPrjOBJ.Freq	;频次
	
	;药品选择理由
	s DrugReason=MPrjOBJ.DrugReason	;选择理由
    
    s mRtn=HasGMis_SP_GMDrug_SP_GMClassifyName_SP_T_SP_WBC_SP_N_SP_CRP_SP_PCT_SP_G_SP_GM_SP_GRQT_SP_HasBYX_SP_BYXResult
    s mRtn=mRtn_SP_HasCombined_SP_CombinedDrug_SP_CombinedReason_SP_JL_SP_Freq_SP_DrugReason
    s mRtn=mRtn_SP_useAimDesc_SP_bodyPartDesc
    q mRtn
}

ClassMethod GetGMClassifyName(gmcid)
{
	n (gmcid)
	s mRtn=""
	i gmcid=1 s mRtn="青霉素类"
	i gmcid=2 s mRtn="头孢菌素类"
	i gmcid=3 s mRtn="β-内酰胺酶抑制剂"
	
	i gmcid=4 s mRtn="氨基糖苷类"
	i gmcid=5 s mRtn="四环素类"
	i gmcid=6 s mRtn="大环内酯类"
	
	i gmcid=7 s mRtn="喹诺酮类"
	i gmcid=8 s mRtn="磺胺类"
	i gmcid=9 s mRtn="其他"
	
                    
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 获取感染数据
/// IN  :  
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.ModePrj).GetGRInfo(1)
ClassMethod GetGRInfo(admid) As %String
{
	n (admid)
	/*
		WBC		白细胞计数			WBC
		N		中性粒细胞百分比	GRAN
		CRP		C反应蛋白			CRP	
		PCT		降钙素原			PCT
		G		真菌D				GTEST
		GM		曲霉菌抗原定量		GMTEST
	*/
	s $ZT = "Err"
	s MInfoArr="WBC,GRAN,CRP,PCT,GTEST,GMTEST"
	s mRtn=""
	s patMas=$P(^PAADM(admid),"^",1)
	q:patMas="" mRtn
	s ipno=$p(^PAPER(patMas,"PAT",1),"^",1)
	Q:ipno="" mRtn
	s mRtn="[{"
	s Len=$l(MInfoArr,",")
	f i=1:1:Len {
		s cName=$p(MInfoArr,",",i)
		s cValue=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,cName),$c(2),3)
		i i=1 s mRtn=mRtn_""""_cName_""":"""_cValue_""""
		e  s mRtn=mRtn_","""_cName_""":"""_cValue_""""
	}
	s mRtn=mRtn_"}]"
	;s WBC=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"WBC"),$c(2),3)
	;s GRAN=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"GRAN"),$c(2),3)
	;s CRP=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"CRP"),$c(2),3)
	;s PCT=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"PCT"),$c(2),3)
	;s GTEST=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"GTEST"),$c(2),3)
	;s GMTEST=$p(##class(LabService.TCResult).GetTCResultByRegNo(ipno,"GMTEST"),$c(2),3)
	;S mRet=WBC_"^"_GRAN_"^"_CRP_"^"_PCT_"^"_GTEST_"^"_GMTEST
	
	q mRtn
Err
	q ""
}

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 获取扩展信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.ModePrj).GetModePrjInfo(295)
ClassMethod GetModePrjInfo(aaid)
{
	n (aaid)
	s mRtn=""
	s BSNoramlEntity=##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.ModePrj")
	s Len=$l(BSNoramlEntity,"^")
	
	s mprjId=$o(^BS.ANT.DHCAntModePrjI("ApplyDr",aaid,0))
	q:mprjId="" ""
	s mprjOBJ=##class(User.DHCAntModePrj).%OpenId(mprjId)
	
	s mRtn="[{"
	f i=2:1:Len {
		s cName=$p(BSNoramlEntity,"^",i)
		s cValue=$ZOBJPROPERTY(mprjOBJ, cName)
		i cName="JLUom" {
			s cValue=mprjOBJ.JLUomGetObjectId()
		}
		i cName="Prior" {
			s cValue=mprjOBJ.PriorGetObjectId()
		}
		i cName="DrugReason" {
			s cValue=..FilterValue(cValue)
		}
		
		i i=2 s mRtn=mRtn_""""_cName_""":"""_cValue_""""
		e  s mRtn=mRtn_","""_cName_""":"""_cValue_""""
			
	}
	s mRtn=mRtn_"}]"
	d mprjOBJ.%Close()
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 获取扩展信息
/// IN  : 
/// OUT : 
/// DATE: 2019-11-27
ClassMethod FilterValue(value) As %String
{

	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,$c(9),"")
	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,$c(10),"&#10;")
	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,$c(13),"&#10;")
	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,"\","\\")
	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,"'","\'")
	s value=##class(DHCAnt.Util.CacheServerBase).ReplaceStr(value,"""","")
	q value
}

/// CTOR: QP
/// DATE: 2021-12-14
/// DESC: 获取使用目的药敏和手术信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.ModePrj).GetDaupJson("460")
ClassMethod GetDaupJson(aaid As %String, ByRef TList) As %String
{
	n (aaid,TList)
	s ^TEMP("WXN")=aaid
	s daupid=$p(^DHCDAA("ANT",aaid,1),"^",20)
	s oper=$p(^DAUP("DAUP",daupid),"^",9)
	s ym=$p(^DAUP("DAUP",daupid),"^",11)
	s TList("oper")=oper
	s TList("ym")=ym
	
	Q ""
}

}
