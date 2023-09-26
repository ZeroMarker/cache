Import sqluser

/// Author:      Sunhuiyong
/// CreateTime:  2020-3-3
/// Desc:        对照导入
Class web.DHCCKBImportCompare Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 导入药品对照信息
/// Table: w ##class(web.DHCCKBImportCompare).SavedrugRowData("项目数据代码^Q2H^项目数据描述^Q2H^医院^云南省滇东北区域中心医院^num^3","东华标准版数字化医院[总院]","DrugFreqData","111","1","2","116.131.31.222")
/// "DrugData","105","11879","2","113.140.81.66")
ClassMethod SavedrugRowData(rowData, hospDesc, dicCode, dicRowID, LgUserID, LgHospID, ClientIPAddress)
{
	n (rowData,hospDesc,dicCode,dicRowID,LgUserID,LgHospID,ClientIPAddress)
	s ^Tmp("SavedrugRowData")=$lb(rowData,hospDesc,dicCode,dicRowID,LgUserID,LgHospID,ClientIPAddress)
	s errNum=0,successNum=0
	s err=0,msg=""
	s rowdata=rowData
	s Code="",Desc="",HISCode="",HISDesc="",Hosptial="",Remark=""
	s:$p(rowdata,"^",1)="知识库数据代码" Code=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="知识库数据代码" Code=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="知识库数据代码" Code=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="知识库数据代码" Code=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="知识库数据代码" Code=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="知识库数据代码" Code=$p(rowdata,"^",12)
	
	s:$p(rowdata,"^",1)="知识库数据描述" Desc=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="知识库数据描述" Desc=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="知识库数据描述" Desc=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="知识库数据描述" Desc=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="知识库数据描述" Desc=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="知识库数据描述" Desc=$p(rowdata,"^",12)
	
	s:$p(rowdata,"^",1)="项目数据代码" HISCode=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="项目数据代码" HISCode=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="项目数据代码" HISCode=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="项目数据代码" HISCode=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="项目数据代码" HISCode=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="项目数据代码" HISCode=$p(rowdata,"^",12)
	
	s:$p(rowdata,"^",1)="项目数据描述" HISDesc=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="项目数据描述" HISDesc=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="项目数据描述" HISDesc=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="项目数据描述" HISDesc=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="项目数据描述" HISDesc=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="项目数据描述" HISDesc=$p(rowdata,"^",12)
	s Hosptial=""
	s:$p(rowdata,"^",1)="医院" Hosptial=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="医院" Hosptial=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="医院" Hosptial=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="医院" Hosptial=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="医院" Hosptial=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="医院" Hosptial=$p(rowdata,"^",12)
	
	//备注(厂家) 导入药品时用
	s Remark=""
	s:$p(rowdata,"^",1)="备注" Remark=$p(rowdata,"^",2)
	s:$p(rowdata,"^",3)="备注" Remark=$p(rowdata,"^",4)
	s:$p(rowdata,"^",5)="备注" Remark=$p(rowdata,"^",6)
	s:$p(rowdata,"^",7)="备注" Remark=$p(rowdata,"^",8)
	s:$p(rowdata,"^",9)="备注" Remark=$p(rowdata,"^",10)
	s:$p(rowdata,"^",11)="备注" Remark=$p(rowdata,"^",12)
	
	i (dicCode="DrugData")||(dicCode="ChineseDrugData")||(dicCode="ChineseHerbalMedicineData") d
	.s Code = $replace(Code,"（","(")   //sufan 2020-04-23 转换括号
	.s Code = $replace(Code,"）",")")
	.s Desc = $replace(Desc,"（","(")
	.s Desc = $replace(Desc,"）",")")	
	
	//一、检查外部字典表是否存在重复数据
	s:Hosptial="" ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"(医院不存在)"_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	Q:Hosptial="" "0"   //sufan 2020-07-16
	s:'$d(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial))) ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"(医院不存在)"_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	Q:'$d(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial))) "0"
	s Hospt=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial),""))
	s:Hospt="" ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"(医院不存在)"_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	Q:Hospt="" "0"
	s:(HISCode="")||(HISDesc="") ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"(HIS列不存在内容)"_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	Q:(HISCode="")||(HISDesc="") "HIS代码/HIS描述存在空值"    //sufan 2020-0-14 增加这个判断
	s:..QueryLibDicByID(Code,Desc,dicRowID)="N" ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"(知识库该字典不存在所匹配数据!)"_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial_"^知识库不存在该字典!"
	q:..QueryLibDicByID(Code,Desc,dicRowID)="N" "0"
	//判断数据错误或者已存
	TS
	i ..QueryDicByID(HISCode,Hospt)'="N"  d		
	.s errNum=errNum+1
	e  d
	.//存外部代码
	.s obj=##class(CKB.PDSS.ExtDiction).%New()
	.s obj.EDCode=HISCode
	.i (dicCode="DrugData")||(dicCode="ChineseDrugData")||(dicCode="ChineseHerbalMedicineData") d
	..s obj.EDDesc=HISDesc_"||"_Remark
	.e  d
	..s obj.EDDesc=HISDesc
	.s obj.EDType=dicCode       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
	.//如果表中存在医院取表中医院；若不存在取系统医院
	.s obj.EDHospital=Hospt
	.s ParrefDr=$o(^CKB.PDSS.ExtDictionI("Code","2",dicCode,""))
	.s obj.EDParrefDr=ParrefDr
	.s sc=obj.%Save()
	.d obj.%Close()
	.s successNum=1
	//三、插入关联关系表
	//s:(Code="")&&(Desc="") successNum=1
	i (Code="")&&(Desc="") d  //为空值则到表里寻找是否存在相关数据，存在则复制相关的code和desc，存到表里
	.i ((dicCode="DrugFreqData")||(dicCode="DrugPreMetData")) d
	..s status = ..QueryHisDesc(HISCode,HISDesc) //判断是否存在相关数据
	..i status="Y"  d
	...s successNum = ..SaveLib(HISCode, HISDesc, dicRowID, LgUserID, LgHospID, ClientIPAddress, Hospt) //复制数据然后存表
	..i status="N"  d
	...s successNum=1
	
	i (Code'="")&&(Desc'="")  d  //为空值插入外部代码表，不保存关联关系
	.i $d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc)))  d
	..s successNum=1
	..s index = Code
	..;s ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	.;Q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc)))
	.q:$o(^CKB.PDSS.ComContrastI("CCHospital",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc),Hospt,""))'=""
	.s obj=##class(CKB.PDSS.ComContrast).%New()
	.s obj.CCLibCode=Code                                        //知识库code
	.s obj.CCLibDesc=Desc                                        //知识库desc
	.s obj.CCHisCode=HISCode                                     //HIS代码
	.s obj.CCHisDesc=HISDesc                                     //HIS描述
	.s obj.CCDicType=dicRowID                                    //获取字典ID  
	.//如果表中存在医院取表中医院；若不存在取系统医院   -弃用医院字段 Sunhuiyong 2020-04-08--添加医院字段 2021-5-28
	.s obj.CCHospital=Hospt
	.s sc=obj.%Save()
	.s Thisid = obj.%Id()
	.d obj.%Close()
	.///四、插入授权表
	.s flag = ##class(web.DHCCKBWriteLog).InsertLogEmPower("DHC_CKBComContrast",Thisid,"grantAuth",LgUserID,"","","D",Hospt,ClientIPAddress,"acc")
	.s:(Thisid>0)&&(flag=0) successNum=1 
	.i flag'=0  d
	..s errNum=errNum+1
	..;s ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	;s:errNum=0 successNum=1				//sufan 修改，此处判断不合适，如果外部表存在就只保存对照
	i successNum'=1 tro
	Q:successNum'=1 successNum
	TC
	Q successNum
}

/// Description:	检测字典表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-03-04	
/// Input:			
/// return:			存在：Y   不存在：N
/// other:			w ##class(web.DHCCKBImportCompare).QueryDicByID("XY0000011","96")
ClassMethod QueryDicByID(diccode As %String = "", hosptial = "") As %String
{
	n (diccode,hosptial)
	s h = 0
	q:diccode="" "NULL ERR"
	q:'$d(^CKB.PDSS.ExtDictionI("Code",hosptial,diccode)) "N"
	q "Y"
}

/// Description:	疾病字典对照数据后台导入
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-04-16
/// Input:			
/// return:			
/// other:	w ##class(web.DHCCKBImportCompare).ImportDatas("1","2","111.205.100.101")
ClassMethod ImportDatas(LgUserID, LgHospID, ClientIPAddress) As %String
{
	n (LgUserID,LgHospID,ClientIPAddress)	
	TSTART
	;s ^TmpCount("count")=""
	s stepOneCount = 0
	s stepTwoCount = 0
	s stepThreeCount = 0
	s stepFourCount = 0
	s stepFiveCount = 0
	s stepSixCount = 0
	s errNum=0
	s count = 0
	s dicCode = "DiseaseData"
	s dicRowID = ##class(web.DHCCKBCommon).GetDiseaseData() //疾病字典id
	s file=##class(%File).%New("D:\icd导入-授权.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s Code = $p(Line,",",1)  //知识库数据代码
		continue:Code=""
		s Desc = $p(Line,",",2)  //知识库数据描述	
		s HISCode = $p(Line,",",3)  //HIS数据代码
		s HISDesc = $p(Line,",",4)  //HIS数据描述
		s Hospt="2"	
		//一、检查外部字典表是否存在重复数据
		i ..QueryDicByID(HISCode,Hospt)="N"  d
		.//二、保存HIS对照数据 
		.s obj=##class(CKB.PDSS.ExtDiction).%New()
		.s obj.EDCode=HISCode
		.s obj.EDDesc=HISDesc
		.s obj.EDType=dicCode       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
		.s obj.EDHospital=Hospt
		.s sc=obj.%Save()
		.d obj.%Close()
		.s stepOneCount = stepOneCount+1   //记录数量1
		//EX1、判断症状字典里是否存在 id:116
		i (..QueryDicdataByID(116,0,Code)'="N")&&(..QueryDicdataByID(115,0,Code)="N")  d
		.s flagid = ..QueryDicdataByID(116,0,Code)
		.s $list(^CT.CKB.PDSS.CommonDictionD(flagid),4)="115"
		.s stepTwoCount = stepTwoCount+1    //记录数量2
	    //EX2、判断所取数据第一列是否存在疾病字典  id:115   
		i ..QueryDicdataByID(115,0,Code)="N"  d
		.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
		.s obj.CDCode=Code
		.s obj.CDDesc=Desc
		.d obj.CDParrefDrSetObjectId("115")
		.s sc=obj.%Save()
		.s drugid=obj.%Id()
		.d obj.%Close()
		.s stepThreeCount = stepThreeCount+1  //记录数量3
		e  d
		.s drugid=..QueryDicdataByID(115,0,Code)
		//三、插入关联关系表
		i ..QueryConsdataByID(Code,HISCode)="N"  d
		.s obj=##class(CKB.PDSS.ComContrast).%New()
		.s obj.CCLibCode=Code                                        //知识库code
		.s obj.CCLibDesc=Desc                                        //知识库desc
		.s obj.CCHisCode=HISCode                                     //HIS代码
		.s obj.CCHisDesc=HISDesc                                     //HIS描述
		.s obj.CCDicType=dicRowID                                    //获取字典ID  
		.s sc=obj.%Save()
		.s Thisid = obj.%Id()
		.d obj.%Close()
		.s stepFourCount = stepFourCount+1  //记录数量4
		e  d
		.s Thisid = ..QueryConsdataByID(Code,HISCode)
		///四、插入授权表
		i '$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",Thisid,"grantAuth"))  d
		.s flag = ##class(web.DHCCKBWriteLog).InsertLogEmPower("DHC_CKBCommonDiction",Thisid,"grantAuth",LgUserID,"","","D",LgHospID,ClientIPAddress,"acc")
		.b:flag'=0  //11675 
		.s stepFiveCount = stepFiveCount+1 
		///EX3 添加核实标记
		//检查该数据是否添加核实标记
		i '$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugid,"confirm"))  d
		.s acFlag = ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugid,"confirm",LgUserID,"","","D",LgHospID,ClientIPAddress,"log") 
		.b:acFlag'=0
		.s stepSixCount = stepSixCount+1
		s ^TmpCount("shy")="外部字典表新增："_stepOneCount_"，症状字典转疾病："_stepTwoCount_"，知识库疾病新增："_stepThreeCount_"，关联表新增："_stepFourCount_"，授权："_stepFiveCount_"，核实："_stepSixCount 
		s count=count+1
		w "导入第"
		w count
		w "条数据,请稍后...",!	
	}  
	w "导入完成！"
	w "外部字典表新增："_stepOneCount_"，症状字典转疾病："_stepTwoCount_"，知识库疾病新增："_stepThreeCount_"，关联表新增："_stepFourCount_"，授权："_stepFiveCount_"，核实："_stepSixCount 
	q ""
}

/// Description:	检测字典表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-01-10	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）,描述
/// return:			存在：ID    不存在：N
/// other:			w ##class(web.DHCCKBImportCompare).QueryDicdataByID(116,0,"肝硬化")
ClassMethod QueryDicdataByID(id As %String = "", parrefFlag As %String = "", parDesc = "") As %String
{
	n (id,parrefFlag,parDesc)
	s h = 0
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	q:parDesc="" "N"
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""||h>0  d
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(parDesc=dicDesc)||(parDesc=dicCode) h = dicID 
	q:h=0 "N"	
    q:h>0 h
}

/// Description:	检测关联关系表中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-04-23	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportCompare).QueryConsdataByID("贫血","D53.001")
ClassMethod QueryConsdataByID(Code As %String = "", hisCode = "") As %String
{
	n (Code,hisCode)  
    s flag = ""
    i '$d(^CKB.PDSS.ComContrastI("LibCode",Code,hisCode))  d
    .s flag = "N"
    e  d
    .s flag = $o(^CKB.PDSS.ComContrastI("LibCode",Code,hisCode,flag))
    q flag
}

/// other:			w ##class(web.DHCCKBImportCompare).ImportExtData("C:\Users\Administrator\Desktop\知识库诊断和icd匹配情况.txt","DiseaseData")
ClassMethod ImportExtData(filepath, type)
{
	n (filepath,type)
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
 .s ret=..SaveExtData(listData,type)
	c filepath
	Q ret
}

ClassMethod SaveExtData(listData, type)
{
	n (listData,type)
	//s $ZT="ErrMsg"
 ;b  //331
	s err = 0
	s libCode = $p(listData,"^",1)				//知识库代码
	s libDesc = $p(listData,"^",2)				//知识库代码
	s hisCode = $p(listData,"^",3)				//HIS库代码
	s hisDesc = $p(listData,"^",4)				//HIS库描述
	s note = $p(listData,"^",5)							//备注
	s hosp = $p(listData,"^",6)							//医院
	s type = $p(listData,"^",7)							//字典类型
	b:hosp=""   //11
	Q:hosp="" "-1"																				//医院为空
	Q:'$d(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp))) "-2"    //"医院与系统登录医院不符,请核实！"
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	Q:hospId="" "-3"																		//未取到医院Id
	
	q:$d(^CKB.PDSS.ExtDictionI("Code",hospId,hisCode)) "0"   //重复
	
	TS
	s list = libCode_"^"_libDesc_"^"_hisCode_"^"_hisDesc_"^"_note_"^"_hospId_"^"_"DiseaseData"
 ;b   //33
	s err = ..SaveDic(list)
	i err'=0 tro
	TC
ErrMsg
	w $ze
	Q err
}

/// w ##class(web.DHCCKBImportCompare).SaveDic("A00.000x001^古典生物型霍乱^94^DiseaseData")
ClassMethod SaveDic(lisData)
{
	n (lisData)
	s hisCode = $p(lisData,"^",3)
	s hisDesc = $p(lisData,"^",4)
 s note = $p(lisData,"^",5)
 s:note'="" hisDesc = hisDesc_"||"_note
	s hospId = $p(lisData,"^",6)
	s type = $p(lisData,"^",7)
	&sql(insert into CKB_PDSS.ExtDiction (ED_Code,ED_Desc,ED_Type,ED_Hospital) values(
		:hisCode,:hisDesc,:type,:hospId
	))
	Q SQLCODE
}

/// w ##class(web.DHCCKBImportCompare).SaveDic("A00.000x001^古典生物型霍乱^94^DiseaseData")
ClassMethod SaveConData(lisData)
{
	n (lisData)
	
	s libCode = $p(lisData,"^",1)
	s libDesc = $p(lisData,"^",2)
	s hisCode = $p(lisData,"^",3)
	s hisDesc = $p(lisData,"^",4)
 s note = $p(lisData,"^",5)
	s hospId = $p(lisData,"^",6)
	s type = $p(lisData,"^",7)
	s typeId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	Q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc))) 0
	
	
	&sql(insert into CKB_PDSS.ComContrast (CC_LibCode,CC_LibDesc,CC_HisCode,CC_HisDesc,CC_DicType) values(
		:libCode,:libDesc,:hisCode,:hisDesc,:typeId
	))
	Q SQLCODE
}

/// qnp 2021/1/22临时导入用
/// w ##class(web.DHCCKBImportCompare).ImportContrastData("D:\知识图谱\武汉3院导入数据.txt","11871","111.18.133.225")
ClassMethod ImportContrastData(filepath, LgUserID, ClientIPAddress)
{
	
	n (filepath,LgUserID,ClientIPAddress)	 // "DrugData","105","11879","2","113.140.81.66")
	
	s successNum=0,errNum=0
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.s count=count+1
	.Q:count=1
	.s Code=$p(listData,"^",1)
	.s Desc=$p(listData,"^",2)
	.s HISCode=$p(listData,"^",3)
	.s HISDesc=$p(listData,"^",4)
	.s Remark=$p(listData,"^",5)	
	.s Hosptial=$p(listData,"^",6)	
	.s dicCode=$p(listData,"^",7)	
	.s dicRowID=##class(web.DHCCKBCommon).GetDicIdByCode(dicCode)
	.
	.//一、检查外部字典表是否存在重复数据	
	.Q:Hosptial=""   //sufan 2020-07-16	
	.Q:'$d(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial)))
	.s Hospt=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hosptial),""))
	.Q:Hospt=""
	.Q:(HISCode="")||(HISDesc="")   //sufan 2020-0-14 增加这个判断
	.
	.//判断数据错误或者已存
	.i ..QueryDicByID(HISCode,Hospt)'="N"  d		
	..s errNum=errNum+1
	.e  d
	..//存外部代码
	..s obj=##class(CKB.PDSS.ExtDiction).%New()
	..s obj.EDCode=HISCode
	..i (dicCode="DrugData")||(dicCode="ChineseDrugData")||(dicCode="ChineseHerbalMedicineData")||(dicCode="DrugFreqData")||(dicCode="DrugPreMetData")||(dicCode="UnitData")||(dicCode="DiseaseData")   d  
	...s obj.EDDesc=HISDesc_"||"_Remark
	..e  d
	...s obj.EDDesc=HISDesc
	..s obj.EDType=dicCode       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
	..//如果表中存在医院取表中医院；若不存在取系统医院
	..s obj.EDHospital=Hospt
	..s sc=obj.%Save()
	..d obj.%Close()
	.
	.//三、插入关联关系表
	.i (Code'="")&&(Desc'="")  d  //为空值插入外部代码表，不保存关联关系
	..i $d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc)))  d
	...s successNum=1
	...s index = Code
	..i $d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc))) s ^ImportContrastDataTmp("hasComcontrast",count)=Code_"^"_Desc_"^"_HISCode_"^"_HISDesc
	..Q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(Desc),$$UPPER^SSUTIL4(HISDesc)))
	..s obj=##class(CKB.PDSS.ComContrast).%New()
	..s obj.CCLibCode=Code                                        //知识库code
	..s obj.CCLibDesc=Desc                                        //知识库desc
	..s obj.CCHisCode=HISCode                                     //HIS代码
	..s obj.CCHisDesc=HISDesc                                     //HIS描述
	..s obj.CCDicType=dicRowID                                    //获取字典ID  
	..//如果表中存在医院取表中医院；若不存在取系统医院   -弃用医院字段 Sunhuiyong 2020-04-08
	..;s obj.CCHospId=Hospt
	..s sc=obj.%Save()
	..s Thisid = obj.%Id()
	..d obj.%Close()
	..///四、插入授权表
	..s flag = ##class(web.DHCCKBWriteLog).InsertLogEmPower("DHC_CKBComContrast",Thisid,"grantAuth",LgUserID,"","","D",Hospt,ClientIPAddress,"acc")
	..s ^ImportContrastDataTmp("success",count)=Code_"^"_Desc_"^"_HISCode_"^"_HISDesc
	..s:(Thisid>0)&&(flag=0) successNum=1 
	..i flag'=0  d
	...s errNum=errNum+1
	...;s ^TMPERR("DHCCKB","ICD",Code)=Code_"^"_Desc_"^"_HISCode_"^"_HISDesc_"^"_dicCode_"^"_Hosptial
	;.s:errNum=0 successNum=1				//sufan 修改，此处判断不合适，如果外部表存在就只保存对照

	c filepath
	Q 0
}

/// Description:	检测知识库中是否存在数据（导入用）
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-06-28	
/// Input:			
/// return:			存在：Y   不存在：N
/// other:			w ##class(web.DHCCKBImportCompare).QueryLibDicByID("藿香正气软胶囊0.45g(天津中新药业集团股份有限公司达仁堂制药厂)","藿香正气软胶囊0.45g(天津中新药业集团股份有限公司达仁堂制药厂)","81790")
ClassMethod QueryLibDicByID(HisCode As %String = "", HisDesc = "", dicRowID = "") As %String
{
	n (HisCode,HisDesc,dicRowID)
	s h = 0
	q:(HisCode="")&&(HisDesc="") "NULL ERR"
	s ECode=$replace(HisCode,"(","（")
	s ECode=$replace(ECode,")","）")
	s ZCode=$replace(ECode,"）",")")
	s ZCode=$replace(ZCode,"（","(")
	s QCode=$replace(ECode,"）",")")
	s HCode=$replace(ECode,"（","(")
	q:('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(HisCode))))&&('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ECode))))&&('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ZCode))))&&('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(QCode))))&&('$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(HCode)))) "N"
	s:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ECode))) HisCode=ECode
	s:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ZCode))) HisCode=ZCode
	s:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(QCode))) HisCode=QCode
	s:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(HCode))) HisCode=HCode
	s DicID=""
	s DicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(HisCode),DicID))
	i DicID=""  d
	.;s HisCode=$replace(HisCode,"(","（")
	.;s HisCode=$replace(HisCode,")","）")
	.s DicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(HisCode),DicID))
	q:DicID="" "N"
	;q:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),4)'=dicRowID "N"
	q "Y"
}

/// Description:	查询医院-字典数据数量以及对照数量
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-7-5	
/// Input:			
/// return:			字典数量^有映射关系得字典数量
/// other:			w ##class(web.DHCCKBImportCompare).QueryLibDicMount("101","ChineseDrugData")
ClassMethod QueryLibDicMount(hospital, type) As %String
{
	n (hospital,type)
	s dicMount=0,constMount=0
	s extRowID=""
	f  s extRowID=$o(^CKB.PDSS.ExtDictionI("Type",hospital,type,extRowID))  q:extRowID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extRowID))
	.s extCode= $lg(extData,2)
	.s extDesc= $lg(extData,3) 
	.s extDesc=$p(extDesc,"||",1)
	.q:(extCode="")||(extDesc="")
	.s ConstrastFlag=0
	.i $d(^CKB.PDSS.ComContrastI("HisCode",$zcvt(extCode,"U")))&($d(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(extDesc,"U")))) d
	..s conID = ""
	..f  s conID=$o(^CKB.PDSS.ComContrastI("HisDesc",$zcvt(extDesc,"U"),conID))  q:(conID="")||(ConstrastFlag=1)   d
	...s conCode = $lg(^CKB.PDSS.ComContrastD(conID),4)
	...s:conCode=extCode constMount=constMount+1 
	.s dicMount=dicMount+1
	q dicMount_"^"_constMount
}

/// Description:	疾病字典ICD对照数据后台导入
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-7-30	
/// other:	w ##class(web.DHCCKBImportCompare).ImportICDData("11869","2","222.132.155.206")
ClassMethod ImportICDData(lgUserID, lgHospID, clientIPAddress) As %String
{
	n (lgUserID,lgHospID,clientIPAddress)	
	TSTART
	s extComAddCount = 0  //用于输出：外部字典新增数量
	s systoSickCount = 0  //症状转疾病的数量
	s libSickAddCount = 0 //知识库疾病新增数量
	s consAddCount = 0    //对照表新增数量
	s granAuthCount = 0   //授权数量
	s confirmCount = 0    //核实数量
	
	s errNum=0
	s count = 0
	s dicCode = "DiseaseData"
	s dicRowID = ##class(web.DHCCKBCommon).GetDiseaseData() //疾病字典id
	s file=##class(%File).%New("D:\知识库疾病与icd10对照关系.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s line=file.Read()
		continue:line=""
		s code = $p(line,",",1)  //知识库数据代码
		continue:code=""
		s desc = $p(line,",",2)  //知识库数据描述	
		s hisCode = $p(line,",",3)  //HIS数据代码
		s hisDesc = $p(line,",",4)  //HIS数据描述
		continue:(hisCode="")||(hisDesc="")
		s hospt="2"	
		//一、检查外部字典表是否存在重复数据
		i ..QueryDicByID(hisCode,hospt)="N"  d
		.//二、保存HIS对照数据 
		.s obj=##class(CKB.PDSS.ExtDiction).%New()
		.s obj.EDCode=hisCode
		.s obj.EDDesc=hisDesc
		.s obj.EDType=dicCode       //添加药品数据存入CKB_PDSS.ExtDiction表中数据类型
		.s obj.EDHospital=hospt
		.s sc=obj.%Save()
		.d obj.%Close()
		.s extComAddCount = extComAddCount+1   //记录数量
		//EX1、判断症状字典里是否存在 id:116
		;i (..QueryDicdataByID(116,0,code)'="N")&&(..QueryDicdataByID(115,0,code)="N")  d
		;.s flagid = ..QueryDicdataByID(116,0,code)
		;.s $lg($g(^CT.CKB.PDSS.CommonDictionD(flagid)),4)="115"
		;.s systoSickCount = systoSickCount+1    //记录数量
	    
	    //EX2、判断所取数据第一列是否存在疾病字典 
		i ..QueryDicdataByID(dicRowID,0,code)="N"  d
		.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
		.s obj.CDCode=code
		.s obj.CDDesc=desc
		.d obj.CDParrefDrSetObjectId(dicRowID)
		.s sc=obj.%Save()
		.s drugid=obj.%Id()
		.d obj.%Close()
		.s insertSickDic=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugid,"add",lgUserID,"","","D",lgHospID,clientIPAddress,"log")
		.s libSickAddCount = libSickAddCount+1  //记录数量
		e  d
		.s drugid=..QueryDicdataByID(dicRowID,0,code)
		//三、插入关联关系表
		i ..QueryConsdataByID(code,hisCode)="N"  d
		.s obj=##class(CKB.PDSS.ComContrast).%New()
		.s obj.CCLibCode=code                                        //知识库code
		.s obj.CCLibDesc=desc                                        //知识库desc
		.s obj.CCHisCode=hisCode                                     //HIS代码
		.s obj.CCHisDesc=hisDesc                                     //HIS描述
		.s obj.CCDicType=dicRowID                                    //获取字典ID  
		.s sc=obj.%Save()
		.s thisId = obj.%Id()
		.d obj.%Close()
		.s consAddCount = consAddCount+1  //记录数量
		.s insertConsDic=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBComContrast",thisId,"add",lgUserID,"","","D",lgHospID,clientIPAddress,"log")
		e  d
		.s thisId = ..QueryConsdataByID(code,hisCode)
		///四、插入授权表
		i '$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",thisId,"grantAuth"))  d
		.s flag = ##class(web.DHCCKBWriteLog).InsertLogEmPower("DHC_CKBCommonDiction",thisId,"grantAuth",lgUserID,"","","D",lgHospID,clientIPAddress,"acc")
		.b:flag'=0  //11675 
		.s granAuthCount = granAuthCount+1 
		///EX3 添加核实标记
		//检查该数据是否添加核实标记
		;i '$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugid,"confirm"))  d
		s acFlag = ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugid,"confirm",lgUserID,"","","D",lgHospID,clientIPAddress,"log") 
		b:acFlag'=0
		s confirmCount = confirmCount+1
		s ^TMP("DHCCKB","web.DHCCKBImportCompare","ImportICDData")="外部字典表新增："_extComAddCount_"，症状字典转疾病："_systoSickCount_"，知识库疾病新增："_libSickAddCount_"，关联表新增："_consAddCount_"，授权："_granAuthCount_"，核实："_confirmCount 
		s count=count+1
		w "导入第"
		w count
		w "条数据,请稍后...",!	
	}  
	w "导入完成！"
	w "外部字典表新增："_extComAddCount_"，症状字典转疾病："_systoSickCount_"，知识库疾病新增："_libSickAddCount_"，关联表新增："_consAddCount_"，授权："_granAuthCount_"，核实："_confirmCount 
	q ""
}

/// Description:	后台导入知识库字典
/// Creator:		Sunhuiyong 
/// CreateDate:		2021-7-30	
/// other:	w ##class(web.DHCCKBImportCompare).ImportDictionaryData("11869","2","222.132.155.206")
ClassMethod ImportDictionaryData(lgUserID, lgHospID, clientIPAddress) As %String
{
	n (lgUserID,lgHospID,clientIPAddress)	
	TSTART
	s libSickAddCount = 0 //知识库疾病新增数量
	s confirmCount = 0  //核实
	s errNum=0
	s count = 0
	s dicCode = "DiseaseData"
	s dicRowID = 123 ;检验项字典
	s file=##class(%File).%New("D:\检验项标准字典.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	while 'file.AtEnd
	{
		s line=file.Read()
		continue:line=""
		s code = $p(line,",",1)  //知识库数据代码
		continue:code=""
		s desc = $p(line,",",2)  //知识库数据描述	
	    //EX1、判断所取数据第一列是否存在字典 
		i ..QueryDicdataByID(dicRowID,0,code)="N"  d
		.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
		.s obj.CDCode=code
		.s obj.CDDesc=desc
		.d obj.CDParrefDrSetObjectId(dicRowID)
		.s sc=obj.%Save()
		.s drugid=obj.%Id()
		.d obj.%Close()
		.s insertSickDic=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugid,"add",lgUserID,"","","D",lgHospID,clientIPAddress,"log")
		.s libSickAddCount = libSickAddCount+1  //记录数量
		
		///EX2 添加核实标记
		//检查该数据是否添加核实标记
		s acFlag = ##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",drugid,"confirm",lgUserID,"","","D",lgHospID,clientIPAddress,"log") 
		s confirmCount = confirmCount+1
		s count=count+1
		w "导入第"
		w count
		w "条数据,请稍后...",!	
	}  
	w "导入完成！"
	w "知识库疾病新增："_libSickAddCount_"核实："_confirmCount 
	q ""
}

/// Description:	检测关联表中是否存在HisDesc
/// Creator:		Lidong 
/// CreateDate:		2022-04-21	
/// Input:			HisDesc
/// return:			Y 存在 N 不存在
/// other:			w ##class(web.DHCCKBImportCompare).QueryHisDesc("St","即刻")
/// 
ClassMethod QueryHisDesc(HisCode As %String = "", HisDesc As %String = "") As %String
{
	n (HisCode,HisDesc)  
    s flag = ""

    &SQL(
    SELECT Count(*) INTO :Num 
    FROM   CKB_PDSS.ComContrast
    WHERE  CC_HisCode=:HisCode AND CC_HisDesc=:HisDesc
    )
    
    i Num=0  d
    .s flag = "N"
    e  d
    .s flag = "Y"
    q flag
}

/// Description:	复制表中已存在的LibCode和LibDesc
/// Creator:		Lidong 
/// CreateDate:		2022-04-21	
/// Input:			status, HISCode, HISDesc, dicRowID, LgUserID, LgHospID, ClientIPAddress, Hospt
/// return:			
/// other:			w ##class(web.DHCCKBImportCompare).SaveLib("St","即刻","111","12018","2","113.140.81.66","3")
/// 				w ##class(web.DHCCKBComContrast).SaveContrastData("呼吸道感染^呼吸道感染^36.1000^主动脉冠状动脉旁路移植，为心脏血管再形成术^115","1^1^1^1^2","113.140.81.66")
/// $o(^CKB.PDSS.ComContrastI("HisDesc",$$ALPHAUP^SSUTIL4("测试1"),""))  $o(^CKB.PDSS.ComContrastI("HisCodeHisDesc",$$ALPHAUP^SSUTIL4("222"),$$ALPHAUP^SSUTIL4("222"),""))
ClassMethod SaveLib(HISCode, HISDesc, dicRowID, LgUserID, LgHospID, ClientIPAddress, Hospt) As %String
{
	n (HISCode,HISDesc,dicRowID,LgUserID, LgHospID, ClientIPAddress,Hospt)
	s successNum= ""
	s LibList=""
	s ID=""
	f  s ID=$o(^CKB.PDSS.ComContrastI("HisCodeHisDesc",$$ALPHAUP^SSUTIL4(HISCode),$$ALPHAUP^SSUTIL4(HISDesc),ID))  q:ID=""  d
    .s ConData = $g(^CKB.PDSS.ComContrastD(ID))
    .s LibCode = $lg(listData,2)
	.s LibDesc = $lg(listData,3)
	.s Lib=LibCode_"^"_LibDesc
	.i $lf(LibList,Lib)=0  d
	..s $list(LibList,*+1) = Lib

	s result = 0
	TS
	f i=1:1:$listlength(LibList)  q:result'=0  d	
	.s LibCode = $p($lg(LibList,i),"^",1)
	.s LibDesc = $p($lg(LibList,i),"^",2)
    .s listdata = LibCode_"^"_LibDesc_"^"_HISCode_"^"_HISDesc_"^"_dicRowID
    .s loginInfo =LgUserID _"^"_"" _"^"_"" _"^"_"" _"^"_LgHospID
    .s clientIP = ClientIPAddress
    .s selHospId= Hospt
    .s result=##class(web.DHCCKBComContrast).saveConDataBat(listdata,loginInfo,clientIP,selHospId)
    .q:result'=0
	i result'=0 Tro
	q:result'=0 result
	TC
	i result = "0" d
    .s successNum =1
    e  d
    .s successNum=-1
    q successNum
}

}
