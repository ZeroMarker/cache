Import SQLUser

/// 运行类方法
/// 作者：李阳
/// 2010-5-2
Class DHCMed.ClassMethodService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.ClassMethodService).StaticObject("DHCMed.CCService.AutoProcess.CompileExpressLib")
ClassMethod StaticObject(strClassName) As %String
{
	// s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(strClassName)      // P7以下使用
	s cdef = ##class(%Library.CompiledClass).%OpenId(strClassName)              // P8以上
	s ret=""
	s cr=$c(9)
	s ret=ret_ "var objTmp = { aafn : function(){return true;}"_cr
	s intMethodCnt=cdef.Methods.Count()
	f i=1:1:intMethodCnt  d
	.s objMethod=cdef.Methods.GetAt(i)
	.q:objMethod.ClassMethod=0 //Modified By LiYang 2012-06-30 只序列化类方法，不序列化实例方法
	.s strMethodName=$tr(objMethod.Name,"%","_") //处理函数中包含“%”的情况 ADD By LiYang 2010-4-17
	.q:((strMethodName["IsValid")!(strMethodName["DisplayToLogical")!(strMethodName["GetStored")!(strMethodName["Normalize")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.q:((strMethodName["LogicalToXSD")!(strMethodName["OdbcToLogical")!(strMethodName["XSDToLogical")!(strMethodName["LogicalToDisplay")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.q:((strMethodName["LogicalToDisplay")!(strMethodName["LogicalToOdbc")!(strMethodName["_")!(strMethodName["XML")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.;w strMethodName_"  "_objMethod.ClassName_"  "_objMethod.ClassMethod_" "_objMethod.ReturnType,!
	.s strReturnType=objMethod.ReturnType
	.s ret=ret_","_strMethodName_" : function(){"_cr
	.s ret=ret_"return ExtTool.RunServerMethod1('"_strClassName_"','"_strMethodName_"',arguments);"_cr
	.s ret=ret_"}"_cr
	s ret=ret_"};"
	d cdef.%Close()
	k cdef
	q ret
}

ClassMethod RunClassMethod(ClassName, MethodName, Arg...)
{
	 s ret=$ZOBJCLASSMETHOD(ClassName,MethodName,Arg...)
	 
	 s cr=$c(9)
	 i $IsObject(ret)=0  d
	 .i $l(ret,$c(0))=1  d
	 ..s ret="<RESULT>OK</RESULT>"_ret
	 .e  d
	 ..s ret=$p(ret,$c(0),2)
	 e  d
	 .i ret.%ClassName(1)="%Library.ListOfObjects"  d
	 ..s retStr="<RESULT>OK</RESULT>["_cr
	 ..s intCnt=ret.Count()
	 ..f i=1:1:intCnt  d
	 ...s tmpObj=ret.GetAt(i)
	 ...s retStr=retStr_..SerializeObject(tmpObj)
	 ...s:i<intCnt retStr=retStr_","_cr
	 ..d ret.%Close()
	 ..k ret
	 ..s ret=retStr_"]"
	 .e  d
	 ..s tmp="<RESULT>OK</RESULT>"_..SerializeObject(ret)
	 ..d ret.%Close()
	 ..k ret
	 ..s ret=tmp
	 
     q ret
}

ClassMethod ReplaceString(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

ClassMethod SerializeObject(obj) As %String
{
	n (obj)
	// s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))      // P7以下使用
	s cdef = ##class(%Library.CompiledClass).%OpenId(obj.%ClassName(1))              // P8以上
	s RowID=""
	s cr=$c(9)
	//s:cdef.Storages.Count()>0 RowID=obj.%Id() //Add By LiYang 2010-4-17 处理没有存储的对象
	//s:cdef.Super["%Persistent" RowID=obj.%Id()      //P8以上
	s:cdef.Persistent=1 RowID=obj.%Id()               //P7以下使用
	s ret="<ResultObject>var objTmp = {"_cr_"RowID : '"_RowID_"'"
	s intPropertyCnt=cdef.Properties.Count()
	f i=1:1:intPropertyCnt  d
	.//Modified By LiYang 2011-06-18 如果某个属性是对象，则返回其Rowid，否则返回其值
	.s objProperty=cdef.Properties.GetAt(i)
	.q:objProperty.Private=1 //私有属性不能序列化
	.s ret=ret_","_cr
	.s strPropertyName=$tr(objProperty.Name,"%","_")
	.s strType=objProperty.Type
	.s %strValue=$ZObjProperty(obj,objProperty.Name)
	.i $IsObject(%strValue)  d
	..s objProClass=##class(%Dictionary.ClassDefinition).%OpenId(%strValue.%ClassName(1))
	..;w %strValue.%ClassName(1)_"    "_objProClass
	..q:$IsObject(objProClass)=0 
	..s:objProClass.Super["%Persistent" %strValue=%strValue.%Id()
	..;s expression="s %strValue=obj."_strPropertyName_".%Id()"
	.s:((strType["Date")&&(%strValue'="")) %strValue=$zd(%strValue,3)
	.s:((strType["Time")&&(%strValue'="")) %strValue=$zt(%strValue,1)
	.s strValue=..ReplaceString(%strValue,$c(13),"\r")
	.s strValue=..ReplaceString(strValue,$c(10),"\n")
	.s strValue=..ReplaceString(strValue,"'","\'")
	.s ret=ret_strPropertyName_":'"_strValue_"'"
	//.w strPropertyName_":'"_strValue_"'",!
	s ret=ret_"};"
	d cdef.%Close()
	k cdef
	q ret
}

/// Creator：     PanLei
/// CreatDate：   2014-06-27
/// Description:  根据提供的ICD诊断字典数据,更新HIS基础字典ICD诊断表MRC_ICDDx数据
/// Table：       MRC_ICDDx
/// Input：       argInput:""
///               argSeparate:"^"分隔符
/// Return：      return<0:程序错误
/// W ##class(DHCMed.ClassMethodService).UpdateIntoMRCICDDx("","^")
ClassMethod UpdateIntoMRCICDDx(argInput As %String, argSeparate As %String) As %String
{
	New (argInput,argSeparate)
	Set return = 0
	Quit:argInput="" return
	
	Set $ZT = "UpdateIntoMRCICDDxErr"
	
	If ($g(argSeparate) = "") {
		Set argSeparate = ..#SEPARATE
	}
	
	// Set ^PanLei("MRC") = argInput
	
	// 开始处理诊断数据更新,先更新诊断字典主表数据,再更新诊断子表(别名表等)数据
	// 诊断字典RowID,Number类型
	Set MRCIDRowID = $p(argInput,argSeparate,1)
	
	// 诊断字典Code,Text类型
	Set MRCIDCode = $p(argInput,argSeparate,2)
	Quit:MRCIDCode="" return
	Set PLIST(2) = MRCIDCode						// MRCID_Code
	
	// 诊断字典描述,Text类型
	Set PLIST(3) = $p(argInput,argSeparate,3)		// MRCID_Desc
	
	// 诊断字典描述,Text类型
	Set PLIST(4) = $p(argInput,argSeparate,4)		// MRCID_ShortDesc
	
	// MRCID_InsDesc,Text类型
	Set PLIST(5) = $p(argInput,argSeparate,5)		// MRCID_InsDesc
	
	// ICD10编码,M800000/0,Text类型
	Set PLIST(6) = $p(argInput,argSeparate,6)		// MRCID_ICD9CM_Code
	
	// MRCID_MaxWaitPeriod,Number类型
	Set PLIST(7) = $p(argInput,argSeparate,7)		// MRCID_MaxWaitPeriod
	
	// 生效日期,Date类型
	Set tmpDateActiveFrom = $p(argInput,argSeparate,8)
	Set:tmpDateActiveFrom'="" tmpDateActiveFrom = $ZDH(tmpDateActiveFrom,3)
	Set PLIST(8) = tmpDateActiveFrom				// MRCID_DateActiveFrom
	
	// 截止日期,Date类型
	Set PLIST(9) = $p(argInput,argSeparate,9)		// MRCID_DateActiveTo
	
	// MRCID_AgeFrom,Text类型
	Set PLIST(10) = $p(argInput,argSeparate,10)		// MRCID_AgeFrom
	
	// MRCID_AgeTo,Text类型
	Set PLIST(11) = $p(argInput,argSeparate,11)		// MRCID_AgeTo
	
	// 性别,指向CT_Sex表CTSEX_RowId
	Set PLIST(12) = $p(argInput,argSeparate,12)		// MRCID_Sex_DR
	
	// 费用类别1,指向ARC_BillSub表ARCSG_RowId
	Set PLIST(13) = $p(argInput,argSeparate,13)		// MRCID_Billsub1_DR
	
	// 费用类别2,指向ARC_BillSub表ARCSG_RowId
	Set PLIST(14) = $p(argInput,argSeparate,14)		// MRCID_Billsub2_DR
	
	// MRCID_BillFlag1,Yes/No类型
	Set PLIST(15) = $p(argInput,argSeparate,15)		// MRCID_BillFlag1
	
	// MRCID_BillFlag2,Yes/No类型
	Set PLIST(16) = $p(argInput,argSeparate,16)		// MRCID_BillFlag2
	
	// MRCID_BillFlag3,Yes/No类型	
	Set PLIST(17) = $p(argInput,argSeparate,17)		// MRCID_BillFlag3
	
	// MRCID_PayorGroup_DR,指向MRC_PayorICDGroup表PID_RowId
	Set PLIST(18) = $p(argInput,argSeparate,18)		// MRCID_PayorGroup_DR
	
	// MRCID_SeriousDis,Yes/No类型
	Set PLIST(19) = $p(argInput,argSeparate,19)		// MRCID_SeriousDis
	
	// MRCID_BodySysProbStat_DR,指向MRC_BodySystemProbStatus表STAT_RowId
	Set PLIST(20) = $p(argInput,argSeparate,20)		// MRCID_BodySysProbStat_DR
	
	// MRCID_BodyArea_DR,指向MRC_BodyArea表BODAR_RowId
	Set PLIST(21) = $p(argInput,argSeparate,21)		// MRCID_BodyArea_DR
	
	// MRCID_Age2From,Text类型
	Set PLIST(22) = $p(argInput,argSeparate,22)		// MRCID_Age2From
	
	// MRCID_Age2To,Text类型
	Set PLIST(23) = $p(argInput,argSeparate,23)		// MRCID_Age2To
	
	// MRCID_AgeCheckType,枚举类型
	Set PLIST(24) = $p(argInput,argSeparate,24)		// MRCID_AgeCheckType
	
	// MRCID_SexCheckType,枚举类型
	Set PLIST(25) = $p(argInput,argSeparate,25)		// MRCID_SexCheckType
	
	// MRCID_Age2CheckType,枚举类型
	Set PLIST(26) = $p(argInput,argSeparate,26)		// MRCID_Age2CheckType
	
	// MRCID_ExternalCause,Yes/No类型
	Set PLIST(27) = $p(argInput,argSeparate,27)		// MRCID_ExternalCause
	
	// MRCID_UnacceptablePDx,Yes/No类型
	Set PLIST(28) = $p(argInput,argSeparate,28)		// MRCID_UnacceptablePDx
	
	// MRCID_Valid,Yes/No类型
	Set PLIST(29) = $p(argInput,argSeparate,29)		// MRCID_Valid
	
	// MRCID_SexCheckTypeDR,指向MRC_SexCheckType表SEXCHK_RowId
	Set PLIST(30) = $p(argInput,argSeparate,30)		// MRCID_SexCheckTypeDR
	
	// MRCID_AgeCheckType1DR,指向MRC_AgeCheckType表AGECHK_RowId
	Set PLIST(31) = $p(argInput,argSeparate,31)		// MRCID_AgeCheckType1DR
	
	// MRCID_AgeCheckType2_DR,指向MRC_AgeCheckType表AGECHK_RowId
	Set PLIST(32) = $p(argInput,argSeparate,32)		// MRCID_AgeCheckType2_DR
	
	// MRCID_AreaCodeRestraintDR,指向MRC_AreaCodeRestraint表AREACR_RowId
	Set PLIST(33) = $p(argInput,argSeparate,33)		// MRCID_AreaCodeRestraintDR
	
	// MRCID_DaggerNAsteriskEditDR,指向MRC_DaggerAnAsteriskEdit表DAST_RowId
	Set PLIST(34) = $p(argInput,argSeparate,34)		// MRCID_DaggerNAsteriskEditDR
	
	// MRCID_AdditionalCodeREqDR,指向MRC_AdditCodeReq表ADDCR_RowId
	Set PLIST(35) = $p(argInput,argSeparate,35)		// MRCID_AdditionalCodeREqDR
	
	// MRCID_CodingPracticesDR,指向MRC_CodingPractices表CODPR_RowId
	Set PLIST(36) = $p(argInput,argSeparate,36)		// MRCID_CodingPracticesDR
	
	// MRCID_ICD9_Map,Text类型
	Set PLIST(37) = $p(argInput,argSeparate,37)		// MRCID_ICD9_Map
	
	// MRCID_LongDescription,Text类型
	Set PLIST(38) = $p(argInput,argSeparate,38)		// MRCID_LongDescription
	
	// MRCID_AlternateDesc,Text类型
	Set PLIST(39) = $p(argInput,argSeparate,39)		// MRCID_AlternateDesc
	
	// MRCID_MorphologyCode,Yes/No类型
	Set PLIST(40) = $p(argInput,argSeparate,40)		// MRCID_MorphologyCode
	
	// MRCID_Cancer,枚举类型
	Set PLIST(41) = $p(argInput,argSeparate,41)		// MRCID_Cancer
	
	// 病理诊断标记,Yes/No类型
	Set PLIST(42) = $p(argInput,argSeparate,42)		// MRCID_MetastaticSite
	
	// 损伤或中毒诊断标记,Yes/No类型
	Set PLIST(43) = $p(argInput,argSeparate,43)		// MRCID_InjuryPoisoningCode
	
	// MRCID_ValidMCodeExt,Number类型
	Set PLIST(44) = $p(argInput,argSeparate,44)		// MRCID_ValidMCodeExt
	
	// MRCID_2ndCodeInPair,Text类型
	Set PLIST(45) = $p(argInput,argSeparate,45)		// MRCID_2ndCodeInPair
	
	// MRCID_AllowToDuplicate,Yes/No类型
	Set PLIST(46) = $p(argInput,argSeparate,46)		// MRCID_AllowToDuplicate
	
	// 更新数据
	If (MRCIDRowID = "") {
    	&sql(insert into SQLUser.MRC_ICDDx values :PLIST())
	} Else {
    	&sql(update SQLUser.MRC_ICDDx values :PLIST() where MRCID_RowId = :MRCIDRowID)
	}
    Quit:SQLCODE SQLCODE
    
    /*
    Set MRCIDCode = $ZCVT(MRCIDCode,"U")
    Set RowID = 0
    Set RowID = $o(^MRC("ID",0,"Code",MRCIDCode,RowID))
    Set return = RowID
    */
    
    Set return = $p(%ROWID,$c(1))
	Quit return
	
UpdateIntoMRCICDDxErr
	Set return = -1
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2014-06-27
/// Description:  根据提供的ICD诊断字典数据检索别名,更新HIS基础字典ICD诊断别名MRC_ICDAlias表数据
/// Table：       MRC_ICDAlias
/// Input：       argInput:""
///               argSeparate:","分隔符
/// Return：      return<0:程序错误
/// W ##class(DHCMed.ClassMethodService).UpdateIntoMRCICDAlias("",",")
ClassMethod UpdateIntoMRCICDAlias(argParRef As %String, argInput As %String, argSeparate As %String) As %String
{
	New (argParRef,argInput,argSeparate)
	Set return = 0
	Quit:(argParRef="")||(argInput="") return
	
	Set $ZT = "UpdateIntoMRCICDAliasErr"
	
	If ($g(argSeparate) = "") {
		Set argSeparate = ..#SEPARATE
	}
	
	// 别名数据
	// LXZL,良性肿瘤,良性,肿瘤
	Set AliasInputLength = $Length(argInput,argSeparate)
	For indAlias=1:1:AliasInputLength {
		Set tmpAliasValue = $p(argInput,argSeparate,indAlias)
		Continue:tmpAliasValue=""
		
		Set MRCALIASRowId = argParRef_"||"_indAlias
		
		Set PLIST(0) = argParRef
		Set PLIST(1) = MRCALIASRowId
		Set PLIST(2) = indAlias
		Set PLIST(3) = tmpAliasValue
		
		// 更新数据
		&sql(insert into SQLUser.MRC_ICDAlias values :PLIST())
	    Quit:SQLCODE
	    
	    Set tmpRowID = $p(%ROWID,$c(1))
	    Set tmpRowID = $p(tmpRowID,"||",1)
	    Set return = tmpRowID
	}
	
	Quit return
	
UpdateIntoMRCICDAliasErr
	Set return = -1
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-05-09
/// Description:  测试器,调试方法
/// Table：       
/// Input：       
/// Return：      return<0:程序错误
/// W ##class(DHCMed.ClassMethodService).TestClassMethod()
ClassMethod TestClassMethod() As %String
{
	Set return = ""
	Set $ZT = "TestClassMethodErr"
	
	// 对于Yes/No类型,前台字符串插入仅允许插入"Y"或"N"或""
	// 错误写法 Set inputString = "^29724^良性肿瘤^良性肿瘤^^M800000/0^^2014-6-28^^^^^^^0^0^0^^0^^^^^^^^0^0^0^^^^^^^^^^^0^^1^0^^^0"
	
	Set inputString = "^29724^良性肿瘤^良性肿瘤^^M800000/0^^2014-6-28^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Y^N^^^"
	Set separate = "^"
	Set returnPar = ##class(DHCMed.ClassMethodService).UpdateIntoMRCICDDx(inputString,separate)
	
	If (returnPar > 0) {
		Set retAlias = ##class(DHCMed.ClassMethodService).UpdateIntoMRCICDAlias(returnPar,"LXZL,良性肿瘤,良性,肿瘤",",")
		If (retAlias > 0) {
			Set return = retAlias
		}
	}
	
	Quit return
	
TestClassMethodErr
	Set return = -1
	Quit return
}

Storage Default
{
}

}
