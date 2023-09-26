/// 名称:基础数据授权 	
/// 描述:获取授权字符串，保存授权
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期: 2014-8-14
Class web.DHCBL.BDP.Authorize Extends web.BDP.sys.ExtPreferences [ Not ProcedureBlock ]
{

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.BDP.Authorize).GetAutJson("G","1","CT_Spec")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String, AutCode) As %String
{
	s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(AutCode)
	s AppKey="BD"
	s AppSubKey=AutCode
	s strAut=..DHCGetBDAuthorizeData(ObjectType,ObjectReference,AppKey,AppSubKey)
	q strAut
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// w ##class(web.DHCBL.BDP.Authorize).GetTreeJson("CT_Loc","menuTreeRoot","G","1",0,20,"^^10","")
/// /{data:[{"id":"7","text":"基督","checked":false,"leaf":true},{"id":"8","text":"天主","checked":false,"leaf":true},{"id":"9","text":"伊斯兰","checked":false,"leaf":true}],totalCount:3}
ClassMethod GetTreeJson(AutCode As %String, ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	s $zt="ERROE"
	n (AutCode,ParentID,ObjectType,ObjectReference,start,limit,query,FilterCK,%session) //要加，否则通过表名和字段名取desc和rowid时有问题
	s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(AutCode)
	s classAllName=$p(strClassInfo,"^",1)
	s propertyName=$p(strClassInfo,"^",2)
	s AppKey="BD"
	s AppSubKey=AutCode

	
	//2022-07-19
	s hospid=""
	if (AutCode="CT_CarPrvTp"){
		s InternalType=$p(query,"^",2) //类型
	}
	elseif (AutCode="SS_User"){
		s CarPrvTpDR=$p(query,"^",4)  //医护人员类型
		s SSUSRGroup=$p(query,"^",3)  //安全组DR
		s DefaultDeptDR=$p(query,"^",2)  //登录科室DR
	}
	elseif (AutCode="CT_CareProv"){
		s ActiveFlag=$p(query,"^",3)  //状态
		s CarePrvTp=$p(query,"^",2)  //医护人员类型DR
	}
	elseif (AutCode="CT_Loc"){
		s DepDR=$p(query,"^",3)  //部门组DR
		s LOCType=$p(query,"^",2)  //科室类型
	}
	elseif (AutCode="CT_PayMode"){
		s GrpCode=$p(query,"^",2) //支付类型
	}
	elseif (AutCode="OEC_OrderCategory"){
		s OCGRPRowId=$p(query,"^",2) //医嘱类组
	}
	elseif (AutCode="ARC_ItemCat"){
		s OrderCat=$p(query,"^",3)  //医嘱分类
		s OrderType=$p(query,"^",2)  //医嘱类型
	}
	elseif (AutCode="PAC_OutcomeOfPregnancy"){
		s OutcomeType=$p(query,"^",2) //分娩类型结果
	}
	elseif (AutCode="PAC_EpisodeSubType"){
		s AdmType=$p(query,"^",2) //就诊类型
	}
	elseif (AutCode="PAC_AdmSource"){
		s EpisodeType=$p(query,"^",2) //Episode Type
	}
	elseif (AutCode="CT_Country"){
		s active=$p(query,"^",2) //激活标志
	}
	elseif (AutCode="CT_Province"){
		s regiondr=$p(query,"^",2) //区域
	}
	elseif (AutCode="CT_City"){
		s provincedr=$p(query,"^",2) //省份
	}
	elseif (AutCode="CT_CityArea"){
		s citydr=$p(query,"^",2) //市
	}
	elseif (AutCode="MRC_AllType"){
		s TagDescription=$p(query,"^",2) //过敏源标签
	}
	elseif (AutCode="ORC_Operation"){
		s icd9=$p(query,"^",3) //ICD10
		s icd10=$p(query,"^",2) //ICD10
	}
	elseif (AutCode="MRC_ICDDx"){
		s icd10=$p(query,"^",2) //ICD10
	}
	elseif (AutCode="PHC_Instruc"){
		s desc2=$p(query,"^",2) //国外名称
		s desc2=$ZCONVERT(desc2,"U")
	}
	elseif (AutCode="PHC_Freq"){
		s factor=$p(query,"^",3) //系数
		s factor=$ZCONVERT(factor,"U")
		s desc2=$p(query,"^",2) //中文描述
		s desc2=$ZCONVERT(desc2,"U")
	}
	s DataType=##class(web.DHCBL.BDP.BDPTableList).GetDataType(AutCode)
	if (DataType'="G")  //非公有菜单，增加医院入参
	{
		s length=$l(query,"^")	
		if length>1 s hospid=$p(query,"^",length)
	}
	s query=$p(query,"^",1)
	
	
	
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000

	s myJsonStr=""
	s myImage=""
	
	s rowid=0
	s count=0
	s end=start+limit
	s desc=""
	//try{   ///2016-8-24
	
	//获取授权JSON
	s AuStr=..DHCGetBDAuthorizeData(ObjectType,ObjectReference,AppKey, AppSubKey)

	s BDPTableListid = $o(^User.BDPTableListI("UqIndex"," "_$zcvt(classAllName,"U"),0))
	if BDPTableListid'=""
	{
		S xGlobal=$listget($g(^User.BDPTableListD(BDPTableListid)),9)  
		s DescProName=$o(^User.BDPTableListI("SubProDescIndex",classAllName,0))
		if xGlobal'=""
		{
			s RowId=0
			if $e(xGlobal,$l(xGlobal))=")" s xRowIdStr="s RowId=$o("_$e(xGlobal,1,$l(xGlobal)-1)_",RowId)"_")"
			else  s xRowIdStr="s RowId=$o("_xGlobal_"(RowId)"_")"
			for 
			{		
				x xRowIdStr q:(RowId="")||(RowId'>0)
				s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_RowId_""")"
				//if classAllName="User.ARCItmMast" s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_RowId_"||1"_""")"  //医嘱项特殊
				x xobjStr
				if (dataobj)&&(propertyName'="")
				{
					s DescXstr="s desc=dataobj."_propertyName
					x DescXstr
					d dataobj.%Close()
					S rowid=RowId
					///过滤乱码、回车符
					s desc=##class(ext.util.String).EvalJSON(desc)
					continue:desc=""
					//过滤已选、未选
					s AuStr2="{ID:"_rowid_"}"
					if (FilterCK="checked") {
						if (AuStr[AuStr2) 
						else  continue
					}
					elseif (FilterCK="unchecked") {
						if (AuStr[AuStr2) continue
					}
					s flag="" //判断是否满足筛选条件
					///筛选条件
					if (AutCode="CT_CarPrvTp"){ //医护人员类型
						s CTCPTInternalType=$p($g(^CT("CPT",rowid)),"^",4)
						if (CTCPTInternalType=InternalType)||(InternalType=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="SS_User"){ //用户
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",rowid)),"^",4)     //登录科室DR
						s SSUSRGroupD=$p($g(^SSU("SSUSR",rowid)),"^",5)  //安全组DR
						
						s SSUSRCareProvDR=$p($g(^SSU("SSUSR",rowid)),"^",14)      //医护人员DR
						s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
						s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
						
						s:SSUSRCareProvDR'="" CTPCPSpecDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",10)      //医护人员专长ID
						s:SSUSRCareProvDR="" CTPCPSpecDR=""
						s ChildSub=0
						s FlagU=0
						//其他登录科室
						for 
						{
							s ChildSub=$o(^SSU("SSUSR",rowid,"OTHLL",ChildSub)) q:ChildSub=""
							s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",rowid,"OTHLL",ChildSub)),"^",1)  //登陆科室id
							s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",rowid,"OTHLL",ChildSub)),"^",2)  //安全组id	
							if ((OTHLLCTLOCDR=DefaultDeptDR)&(OTHLLUserGroupDR=SSUSRGroup))||((DefaultDeptDR="")&(OTHLLUserGroupDR=SSUSRGroup))||((OTHLLCTLOCDR=DefaultDeptDR)&(SSUSRGroup="")){
								s FlagU=1
							}

						}
						
						if ((((SSUSRGroupD=SSUSRGroup)||(SSUSRGroup=""))&((SSUSRDefaultDeptDR=DefaultDeptDR)||(DefaultDeptDR="")))||(FlagU=1))&((CTPCPCarPrvTpDR=CarPrvTpDR)||(CarPrvTpDR=""))
						{
							s flag="Y"
						}
						else
						{
							continue
						} 
						
					}
					elseif (AutCode="CT_CareProv") //医护人员
					{ 
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s CTPCPCarPrvTpDR1=$p($g(^CTPCP(rowid,1)),"^",4)    //人员类型ID
						s CTPCPActiveFlag=$p($g(^CTPCP(rowid,1)),"^",9)      //是否激活
						if ((CTPCPCarPrvTpDR1=CarePrvTp)||(CarePrvTp=""))&(CTPCPActiveFlag[ActiveFlag){
							s flag="Y"
						}else{
							continue
						} 
						
					}
					elseif (AutCode="CT_Loc"){ //科室/病区
						s CTLOCHospitalDR=$p($g(^CTLOC(rowid)),"^",22)     //医院
						if hospid'=""
						{
							continue:(CTLOCHospitalDR'=hospid)
						}
						s CTLOCType=$p($g(^CTLOC(rowid)),"^",13) 		//类型
						s CTLOCDepDR=$p($g(^CTLOC(rowid)),"^",19)		//科室部门组 
						if ((CTLOCType=LOCType)||(LOCType="")) & ((CTLOCDepDR=DepDR)||(DepDR="")){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="CT_PayMode"){ //支付方式
						s CTPMGrpCode=$p($g(^CT("CTPM",rowid)),"^",4)
						if (CTPMGrpCode[GrpCode){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="OEC_OrderCategory"){ //医嘱大类
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s ORCATOCGroupDR = $p($g(^OEC("ORCAT",rowid)),"^",15)
						if (ORCATOCGroupDR=OCGRPRowId)||(OCGRPRowId=""){
							s flag="Y"
						}else{
							continue
						} 
						
					}
					elseif (AutCode="ARC_ItemCat"){ //医嘱子分类
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s ARCICOrderType=$p($g(^ARC("IC",rowid)),"^",7)
						s ARCICOrdCatDR=$p($g(^ARC("IC",rowid)),"^",8)
						if ((ARCICOrderType=OrderType)||(OrderType=""))&((ARCICOrdCatDR=OrderCat)||(OrderCat="")){
							s flag="Y"
						}else{
							continue
						}
						
					}
					elseif (AutCode="PAC_OutcomeOfPregnancy"){ //妊娠结果
						s OPREGOutcomeType=$p($g(^PAC("OPREG",rowid)),"^",4)
						if (OPREGOutcomeType=OutcomeType)||(OutcomeType=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="PAC_EpisodeSubType"){ //就诊子类型
						s SUBTAdmType=$p($g(^PAC("SUBT",rowid)),"^",3)
						if (SUBTAdmType=AdmType)||(AdmType=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="PAC_AdmSource"){ //许可来源
						s ADSOUEpisodeType=$p($g(^PAC("ADSOU",rowid)),"^",7)
						if (ADSOUEpisodeType=EpisodeType)||(EpisodeType=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="CT_Country"){ //国家
						s CTCOUActive=$p($g(^CT("COU",rowid)),"^",3)
						if (CTCOUActive=active)||(active=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="CT_Province"){ //区域
						s CTRGRowId=$p($g(^CT("PROV",rowid)),"^",3)
						if (CTRGRowId=regiondr)||(regiondr=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="CT_City"){ //城市
						s PROVRowId=$p($g(^CT("CIT",rowid)),"^",4)
						if (PROVRowId=provincedr)||(provincedr=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="CT_CityArea"){ //城市区域
						s CTCITRowId=$p($g(^CT("CITAREA",rowid)),"^",3)
						if (CTCITRowId=citydr)||(citydr=""){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="MRC_AllType"){ //过敏源分类
						s MRCATTagDescription=$p($g(^MRC("AT",rowid)),"^",6)
						if (MRCATTagDescription[TagDescription){
							s flag="Y"
						}else{
							continue
						} 
					}
					elseif (AutCode="ORC_Operation"){ //手术过程
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s OPERICD10=$p($g(^ORC("OPER",rowid)),"^",14)
						s OPERICD9Map=$p($g(^ORC("OPER",rowid)),"^",21)
						if (OPERICD10[icd10)&(OPERICD9Map[icd9){
							s flag="Y"
						}else{
							continue
						} 
						
					}
					elseif (AutCode="MRC_ICDDx"){ //诊断
						if hospid'=""
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s MRCIDICD9CMCode=$p($g(^MRC("ID",rowid)),"^",4)     ///ICD10
						if (MRCIDICD9CMCode[icd10){
							s flag="Y"
						}else{
							continue
						} 
						
					}
					elseif (AutCode="PHC_Instruc"){ //药品用法
						s PHCINDesc2 = $p($g(^PHCIN(rowid)),"^",3)
						s PHCINDesc21=$ZCONVERT(PHCINDesc2,"U")
						if (PHCINDesc21[desc2){
							s flag="Y"
						}else{
							s flag="N"
						} 
					}
					elseif (AutCode="PHC_Freq"){ //频次
						s PHCFRFactor = $p($g(^PHCFR(rowid)),"^",2)
						s PHCFRFactor1=$ZCONVERT(PHCFRFactor,"U")
						s PHCFRDesc2 = $p($g(^PHCFR(rowid)),"^",4)
						s PHCFRDesc21=$ZCONVERT(PHCFRDesc2,"U")
						if (PHCFRFactor1[factor)&(PHCFRDesc21[desc2){
							s flag="Y"
						}else{
							continue
						} 
					}
					else
					{
						///考虑医院多院区过滤
						if (DataType'="G")&&(hospid'="")
						{
							s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(AutCode,rowid,hospid)
	  						continue:showflag="N"
						}
						s flag="Y"
					}
					if ($ZCONVERT(desc,"U")[$ZCONVERT(query,"U")){
						s count=count+1
						if ((count>start) & (count<=end)) || (end=0) {
							s AuStr2="{ID:"_rowid_"}"
							if (AuStr[AuStr2) s myEnable=1
							else  s myEnable=0
							
							s:(myJsonStr'="") myJsonStr=myJsonStr_","
							s myJsonStr=myJsonStr_"{"
							s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_""","
							
							if (+myEnable) {
								s myJsonStr=myJsonStr_"""checked"":true,"
							}else {
								s myJsonStr=myJsonStr_"""checked"":false,"
							}
							s myJsonStr=myJsonStr_"""leaf"":true"
							s myJsonStr=myJsonStr_"}"
						}
					}
					
				}
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	q myJsonStr
ERROE
	q "{success:'false',info:'Please conform to the condition'}"
}

/// 陈莹
/// 保存基础数据授权
/// w ##class(web.DHCBL.BDP.Authorize).SaveBDAuthorizeData("G","1","[{ID:1},{ID:2}]","CT_Spec")
ClassMethod SaveBDAuthorizeData(ObjectType As %String, ObjectReference As %String, Data As %String, AutCode As %String) As %String
{
	s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(AutCode)

	s AppKey="BD"
	s AppSubKey=AutCode

	s flag=""
	s flag = ..DHCSaveBDDataToServer(ObjectType,ObjectReference,Data,AppKey,AppSubKey)
	if (flag=0){
		s result = "{msg:"_flag_"}"
	}else{
		s result = "{msg:"_flag_"}"
	}
	q result
}

/// 陈莹
ClassMethod DHCSaveBDDataToServer(ObjectType As %String, ObjectReference As %String, Data As %String, AppKey, AppSubKey) As %String
{
	; w ##class(web.BDP.sys.PatEnroll).DHCSaveDataToServer("G",125,^TMPXmlData)
	; 生成 web.DHCEntity.Configure.ObjectPreferences 对象
	
	s ^TMPXmlData=Data
	
	s myrtn=0
	
	s mySaveXmlData = Data
	
	s myPreObj=##class(web.Entity.BDP.ObjectPreferences).%New()
	
	s myPreObj.AppKey=AppKey
	s myPreObj.AppSubKey=AppSubKey
	s myPreObj.Data=mySaveXmlData
	s myPreObj.DataSplitString = ..#DataSplitString
	s myPreObj.ObjectReference=ObjectReference
	s myPreObj.ObjectType =ObjectType
	s myrtn=..DHCBDSaveInfo(myPreObj)
	
	;d myDataObj.%Close()
	d myPreObj.%Close()
	k myPreObj
	
	q myrtn
}

/// 获取对应的值 ReadDataByReference
/// 基础数据授权 获取授权字符串
/// 陈莹2014-8-14
ClassMethod DHCGetBDAuthorizeData(ObjectType As %String, ObjectReference As %String, AppKey As %String, AppSubKey As %String) As %String
{
	s myPRowID=..DHCGetRowIDForBD(ObjectType, ObjectReference,AppKey, AppSubKey)
	s myData=""
	q:(myPRowID="") myData
	s myObj=##class(User.BDPPreferences).%OpenId(myPRowID)
	s myData=myObj.Data
	
	d myObj.%Close()
	
	q myData
}

/// w ##class(web.DHCBL.BDP.Authorize).DHCGetRowIDForBD("G","1","BD",AutCode)
/// 基础数据授权 获取授权字符串
/// 陈莹2014-8-14
ClassMethod DHCGetRowIDForBD(ObjectType As %String, ObjectReference As %String, AppKey As %String, AppSubKey As %String) As %String
{
	;^User.BDPPreferencesI("UqIndex"," U"," 12"," E"," CARD",1)=
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	q:(AppKey="") myRowID
	q:(AppSubKey="") myRowID
	
	s myObjectType=" "_$ZConvert(ObjectType,"U")
	s myObjectReference=" "_$ZConvert(ObjectReference,"U")
	s myParaAppKey=" "_$ZConvert(AppKey,"U")
	s myParaAppSubKey=" "_$ZConvert(AppSubKey,"U")
	
	s myRowID=$o(^User.BDPPreferencesI("UqIndex", myObjectType, myObjectReference, myParaAppKey, myParaAppSubKey, 0))
	
	q myRowID
}

/// 通过RowID 获取Object==User.DBPPreferrences
ClassMethod DHCGetBDDataObjectByRowID(PRowID As %String) As %ObjectHandle
{
	s myDataObj=""
	
	s myObj=##class(User.BDPPreferences).%OpenId(PRowID)
	s myData=myObj.Data
	s myDataSplitString = myObj.DataSplitString
	
	q myObj
}

/// 保存基本信息, 包换 Add Update
/// 保存信息 By XML
/// web.Entity.BDP.ObjectPreferences
/// web.DHCEntity.Configure.ObjectPreferences
ClassMethod DHCBDSaveInfo(ObjPref As web.Entity.BDP.ObjectPreferences) As %String
{
	s myrtn=0
	s myPRowID=..DHCGetBDRowID(ObjPref.ObjectType, ObjPref.ObjectReference,ObjPref.AppSubKey)
	i myPRowID="" d
	.s myobj=##class(User.BDPPreferences).%New()
	e  d
	.s myobj=##class(User.BDPPreferences).%OpenId(myPRowID)
	.s JsonStrU="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	
	s myobj.AppKey = ObjPref.AppKey
	s myobj.AppSubKey = ObjPref.AppSubKey
	s myobj.Data = ObjPref.Data
	s myobj.DataMapMode = ObjPref.DataMapMode
	s myobj.DataSplitString = ObjPref.DataSplitString
	s myobj.ObjectReference = ObjPref.ObjectReference
	s myobj.ObjectType = ObjPref.ObjectType
	
	s sc=myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"	;卡状态信息保存失败
	}
	
	s JsonStr="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	
	if (myPRowID'="")
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPPreferences","基础数据授权",myPRowID,myobj.ObjectType_"->"_myobj.ObjectReference,"U",JsonStr,JsonStrU)
	}
	else
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPPreferences","基础数据授权",myobj.%Id(),myobj.ObjectType_"->"_myobj.ObjectReference,"A",JsonStr)
	}
	d myobj.%Close()
	
	q myrtn
}

ClassMethod DHCGetBDRowID(ObjectType As %String, ObjectReference As %String, AppSubKey) As %String
{
	;^User.BDPPreferencesI("UqIndex"," U"," 12"," E"," CARD",1)=
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	//q:(AppKey="") myRowID
	q:(AppSubKey="") myRowID
	
	s myObjectType=" "_$ZConvert(ObjectType,"U")
	s myObjectReference=" "_$ZConvert(ObjectReference,"U")
	s myParaAppKey=" BD"
	s myParaAppSubKey=" "_$ZConvert(AppSubKey,"U")
	
	s myRowID=$o(^User.BDPPreferencesI("UqIndex", myObjectType, myObjectReference, myParaAppKey, myParaAppSubKey, 0))
	
	q myRowID
}

/// GetList里获取授权字符串
/// 根据Session获取Data数据
ClassMethod DHCGetBDDataByDefaultSession(AppSubKey As %String) As %String
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDOByDefaultSession()
	;m ^TMPSSSSS=%session.Data
	;%session.Get("")
	s mySessionStr=..DHCGetBDDefaultSystemSession()
	
	s myData = ""
	s myobj=..DHCGetBDDataObjectBySession(mySessionStr,AppSubKey)
	if ($IsObject(myobj)){
		s myData = myobj.Data
	}
	
	k myobj
	
	q myData
}

ClassMethod DHCGetBDDefaultSystemSession() As %String
{
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDefaultSystemSession()
	s myIP=$g(%session.Data("REMOTE_ADDR"))		;$g(%session.Get(""))
	s myUserID=$g(%session.Data("LOGON.USERID"))
	s myLocID=$g(%session.Data("LOGON.CTLOCID"))
	s myGroupID=$g(%session.Data("LOGON.GROUPID"))
	s myHospitalID=""		;$g(%session.Get(""))
	s mySiteCODE=$g(%session.Data("LOGON.SITECODE"))
	s context=""
	
	s mystr=myIP_"^"_myUserID_"^"_myLocID_"^"_myGroupID_"^"_myHospitalID_"^"_mySiteCODE_"^"_context
	q mystr
}

ClassMethod DHCGetBDDataObjectBySession(SessionStr As %String, AppSubKey) As %ObjectHandle
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDataObjectBySession("^^1^^^^")
	s ^TMPSessionStr=SessionStr
	i SessionStr=""{
		;s SessionStr=..DHCGetDefaultSystemSession()
	}
	s myIP=$p(SessionStr,"^",1)
	s myUserID=$p(SessionStr,"^",2)
	s myLocID=$p(SessionStr,"^",3)
	s myGroupID=$p(SessionStr,"^",4)
	s myHospitalID=$p(SessionStr,"^",5)
	s mySiteCODE=$p(SessionStr,"^",6)
	s context=""
	
	s myobj=..DHCGetBDDataObject(myIP, myUserID, myLocID, myGroupID, myHospitalID, mySiteCODE, context,AppSubKey)
	q myobj
}

/// IP As %Library.String, 
/// UserID As %Library.String, 
/// GroupID As %Library.String, 
/// SiteCODE As %Library.String, 
/// context As %Library.String, 
/// ByRef app As %Library.String, 
/// key As %Library.String, 
/// subkey As %Library.String, 
/// LocID As %String = ""
/// 
/// prior List
/// IP, UserID, LocID, GroupID, User.CTHospital SiteCode
/// IP, U, L, G, H, S
ClassMethod DHCGetBDDataObject(IP As %Library.String, UserID As %Library.String, LocID As %String = "", GroupID As %Library.String, HospitalID As %String, SiteCODE As %Library.String, context As %Library.String = "", AppSubKey) As %ObjectHandle
{
	s IP=$g(IP)
	
	s myPreObj=""
	s myPRowID=""
	;1. IP
	s myPRowID=..DHCGetBDRowIDForPriority("IP", IP,AppSubKey)
	
	;2. User
	if (myPRowID=""){
		s myPRowID=..DHCGetBDRowIDForPriority("U", UserID,AppSubKey)
		
	}
	
	;3. LocID
	i myPRowID=""{
		s myPRowID=..DHCGetBDRowIDForPriority("L", LocID,AppSubKey)
		
	}
	
	;4. GroupID
	i myPRowID=""{
		s myPRowID=..DHCGetBDRowIDForPriority("G", GroupID,AppSubKey)
	}
	
	;5. Hospital
	i myPRowID=""{
		;HospitalCode
		s myPRowID=..DHCGetBDRowIDForPriority("H", HospitalID,AppSubKey)
	}
	
	;6. SiteCODE
	i myPRowID=""{
		s myPRowID=..DHCGetBDRowIDForPriority("S", SiteCODE,AppSubKey)
	}
	
	i myPRowID'=""{
		
		s myPreObj=..DHCGetBDDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

/// 判断优先级是获取RowID的方法   
ClassMethod DHCGetBDRowIDForPriority(ObjectType As %String, ObjectReference As %String, AppSubKey) As %String
{
	s myRowID=..DHCGetBDRowID(ObjectType,ObjectReference,AppSubKey)
	if myRowID'=""			//判断存在数据时，是否为不受限状态，若为不受限，MyRowID依旧为空，不走此授权。
	{
		s myPreObj=..DHCGetBDDataObjectByRowID(myRowID)
		if (myPreObj.Data["limited:0") & (AppSubKey'="HospPre") //排除医院级别授权
		{
			s myRowID = ""
		}
	}
	
	q myRowID
}

}
