/// 名称: User.DHCHMAbstract
/// 描述: 所有类的抽象父类
Class User.DHCHMAbstract Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

Parameter Delimiter = "^";

Parameter ClassName;

ClassMethod GetObjById(aId As %String, aLocId As %String = "") As %DataType
{
	New (aId,aLocId)
	Quit:..#ClassName="" ""
	Quit:'$ClassMethod(..#ClassName,"%ExistsId",aId) ""
	Quit:(aLocId'="")&(..GetLocShowDataFlag(aId,aLocId)'="Y") ""
	Set obj=$ClassMethod(..#ClassName,"%OpenId",aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：    zhufei
/// CreatDate：  2021-11-09
/// Description: 获取表ID对应科室有效权限（有效Y、无效N、无有效授权""）
/// Table：      表记录授权管理表DHC_PE_PowerControl
/// Input:       aId         ：数据ID
///              aLocId      ：科室ID
/// Return:      有效Y、无效N、无有效授权""、有授权显示权限&无使用权限YN
/// 替换##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocShowDataFlag(tableName,dataid,LocID,ParRef,Empower)
ClassMethod GetLocShowDataFlag(aId As %String, aLocId As %String) As %String
{
	New (aId,aLocId)
	Quit:..#ClassName="" ""
	Quit:(aId="")||(aLocId="") ""
	
    //获取表登记信息（数据公有、私有类型）
    Set PTLID=$o(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(..#ClassName,"U"),0))  //类名
    Quit:PTLID="" ""  //未维护权限的表都当做公有数据
    Set DataTypeFlag=$lg($g(^CT.PE.PowerTableListD(PTLID)),4)
    Set TableListDr=PTLID
    Set ClsCode=$lg($g(^CT.PE.PowerTableListD(PTLID)),5)  //自身类名
    Set ParCode=$lg($g(^CT.PE.PowerTableListD(PTLID)),6)  //父表表名
    //Quit:ParCode'="" ""
    //如果权限与父表一致，程序中通过父表ID判断是否有效
    
    If ParCode'="" {
	    //特殊表只能特殊处理
	    If $zcvt(ClsCode,"U")=$zcvt("User.DHCPEILLSAlias","U") {
		    Set aId=+$p($g(^DHCPEILLSA(aId)),"^",1)
	    } ElseIf $zcvt(ClsCode,"U")=$zcvt("User.DHCPEEDAlias","U") {
		    Set aId=+$p($g(^DHCPEEDA(aId)),"^",1)
	    } ElseIf $zcvt(ClsCode,"U")=$zcvt("User.DHCPEIDRelate","U") {
		    Set aId=+$p($g(^DHCPEIDR(aId)),"^",1)
	    } ElseIf $zcvt(ClsCode,"U")=$zcvt("User.DHCPEExpress","U") {
		    Set aId=+$lg($g(^User.DHCPEExpressD(aId)),3)
	    } Else {
		    Set aId=+aId
	    }
	    Set PTLID=$o(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(ParCode,"U"),0))  //类名
	    Quit:PTLID="" ""  //未维护权限的表都当做公有数据
	    Set DataTypeFlag=$lg($g(^CT.PE.PowerTableListD(PTLID)),4)
	    Set TableListDr=PTLID
	}
    
    Set return="N"
    
    If (DataTypeFlag="S") { //私有数据
        //获取科室对应的科室组默认科室ID
        Set LGLocID=""
        Set LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_aLocId,0))
    	Set:LGLocDR'="" LGLocID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //取默认科室
        Quit:LGLocID="" return
        
        //判断是否本科室组LGLocID的授权数据
        Quit:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y")) return
        //判断是否需要单独授权
        If $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,LGLocID,"Y","Y")){
	        //如果需要单独授权，判断是否本科室LocID的授权数据
	        If $d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,aLocId,"Y")) {
		        Set return="Y"
		    } Else {
			    Set return="YN"  //标识有授权显示权限，无使用权限
			}
        } Else {
	        Set return="Y"
	    }
    } ElseIf (DataTypeFlag="C") { //管控数据
        //判断是否本科室LocID的授权数据
        If $d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,aLocId,"Y")) {
	        Set return="Y"
	    } Else {
		    Set return="YN"  //标识有授权显示权限，无使用权限
		}
    } ElseIf (DataTypeFlag="A") { //绝对私有
	    //判断是否本科室LocID的授权数据
        If $d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,aLocId,"Y")) {
	        Set return="Y"
	    }
    } Else {
        Set return="Y"
    }
    Quit return
}

/// Creator：    zhufei
/// CreatDate：  2021-11-09
/// Description: 获取表对应数据权限（公有G,私有S,管控C,绝对私有A），如果子表与父表权限一致，返回值带*号
/// Table：      表记录授权管理表DHC_PE_PowerControl
/// Input:       aId         ：数据ID
///              aLocId      ：科室ID
/// Return:      公有G,私有S,管控C,绝对私有A，如果子表与父表权限一致，返回值带*号
/// 替换##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeObj(tableName,aLocId)
ClassMethod GetTabPowerType(aLocId As %String = "") As %String
{
	New (aLocId)
	Quit:..#ClassName="" ""
	
    //获取表登记信息（数据公有、私有类型）
    Set PTLID=$o(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(..#ClassName,"U"),0))  //类名
    Quit:PTLID="" ""  //未维护权限的表都当做公有数据
    Set DataTypeFlag=$lg($g(^CT.PE.PowerTableListD(PTLID)),4)
    Set ParCode=$lg($g(^CT.PE.PowerTableListD(PTLID)),6)  //父表表名
    Set:ParCode'="" DataTypeFlag="*"_DataTypeFlag
    
    //公有G,私有S,管控C,绝对私有A
    //如果子表与父表权限一致，返回值带*号
    Set return=DataTypeFlag
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  20210817
/// Description: 获取表登记信息（数据类型：公有G ，私有S，管控C，绝对私有A）
/// Table：      表登记授权管理 User.DHCPEPowerTableList
/// Input:       aTableName 表名或类名
/// Return：     return=Object
/// 替换##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeObj("DHC_PE_EDClass")
ClassMethod GetPowerTypeObj(aLocId As %String = "") As User.DHCPEPowerTableList
{
    New (aLocId)
    Set return=""
	Quit:..#ClassName="" return
	
    //获取表登记信息（数据公有、私有类型）
    Set PTLID=$O(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(..#ClassName,"U"),0))  //类名
    Quit:PTLID="" return  //未维护权限的表都当做公有数据
    
    Quit:'##class(User.DHCPEPowerTableList).%ExistsId(PTLID) return
	Set obj=##Class(User.DHCPEPowerTableList).%OpenId(PTLID)
	Quit:'$IsObject(obj) return
	Do obj.%Close()
	
	Set return=obj
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2021-11-09
/// Description: 获取表ID对应数据权限（权限类型^是否单独授权^已授权科室）
/// Table：      表记录授权管理表DHC_PE_PowerControl
/// Input:       aId         ：数据ID
///              aLocId      ：科室ID
/// Return:      DataTypeFlag_"^"_IsEmpower_"^"_PowerLocStr （权限类型^是否单独授权^已授权科室）
/// 替换##class(web.DHCPE.CT.DHCPEMappingLoc).GetEmpowerFlag(tableName,id,LocID)
ClassMethod GetEmpowerFlag(aId As %String, aLocId As %String = "") As %String
{
	New (aId,aLocId)
	Quit:..#ClassName="" ""
	Quit:(aId="") ""
	
    Set TableListDr=$o(^CT.PE.PowerTableListI("IdxOfClsCode"," "_$zcvt(..#ClassName,"U"),0))  //类名
    Quit:TableListDr="" ""
	
	Set IsEmpower="",PowerLocStr=""
    Set DataTypeFlag=..GetTabPowerType(aLocId)
    If DataTypeFlag="S" {
	    
			//获取科室对应的科室组默认科室ID
       	 	Set xLocGrpID=""
        	Set LGLocDR=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_aLocId,0))
    		Set:LGLocDR'="" xLocGrpID=$listget($g(^CF.PE.LocGrpConfigD(LGLocDR)),3) //取默认科室
        	Quit:xLocGrpID="" DataTypeFlag_"^"_IsEmpower_"^"_PowerLocStr
			Quit:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,xLocGrpID,"Y")) DataTypeFlag_"^"_IsEmpower_"^"_PowerLocStr
			
			If $d(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDr,aId,xLocGrpID,"Y","Y")) {
				Set IsEmpower="Y"
			} Else {
				Set IsEmpower="N"
			}
			
			Set xLocID=0
			For {
				Set xLocID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,xLocID))
				Quit:xLocID=""
				Continue:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,xLocID,"Y"))
				
			    Set LGConfigID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_xLocID,0))
			    Continue:LGConfigID=""
			    Set LGLocID=$lg($g(^CF.PE.LocGrpConfigD(LGConfigID)),3)
			    Set LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(LGConfigID)),4)
			    Continue:LGLocID'=xLocGrpID
			    
			    Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
			    Continue:LocDesc=""
			    Set:LocDesc2'="" LocDesc=LocDesc2
			    If PowerLocStr'="" {
		        	Set PowerLocStr=PowerLocStr_","_LocDesc
		        } Else {
		            Set PowerLocStr=LocDesc
		        }
			}
		
    } ElseIf (DataTypeFlag="C")||(DataTypeFlag="A") {
		Set xLocID=0
	    For {
		    Set xLocID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,xLocID))
		    Quit:xLocID=""
			Continue:'$d(^CF.PE.PowerControlI("IdxOfLocPower",TableListDr,aId,xLocID,"Y"))
		    
		    Set LGConfigID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_xLocID,0))
		    Continue:LGConfigID=""
		    Set LGLocID=$lg($g(^CF.PE.LocGrpConfigD(LGConfigID)),3)
		    Set LocDesc2=$lg($g(^CF.PE.LocGrpConfigD(LGConfigID)),4)
		    
		    Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		    Continue:LocDesc=""
		    Set:LocDesc2'="" LocDesc=LocDesc2
		    If PowerLocStr'="" {
	        	Set PowerLocStr=PowerLocStr_","_LocDesc
	        } Else {
	            Set PowerLocStr=LocDesc
	        }
		}
    }
	Quit DataTypeFlag_"^"_IsEmpower_"^"_PowerLocStr
}

/// Creator：    zhufei
/// CreatDate：  2021-11-09
/// Description: 保存数据到表记录授权管理表
/// Table：      表记录授权管理表DHC_PE_PowerControl
/// Input:       aId         ：数据ID
///              aLocId      ：科室ID
///              aUpdateUser ：登录用户ID
///              aEffPower   ：是否有效授权
///              aEmpower    ：是否单独授权
///              aLocIDStr   : 多科室授权
/// Return:      保存成功/失败
/// 参考##class(web.DHCPE.CT.DHCPEMappingLoc).SaveDataToPowerControl()
/// 参考##class(web.DHCPE.CT.DHCPEMappingLoc).SaveSDataToPowerControl()
ClassMethod SaveDataToPowerControl(aId As %String, aLocId As %String, aUpdateUser As %String, aEmpower As %String = "N", aLocIDStr As %String = "") As %String
{
	New (aId,aLocId,aUpdateUser,aEmpower,aLocIDStr)
	Quit:..#ClassName="" -1
	
	Set TabPowerType=..GetTabPowerType(aLocId)
	Quit:TabPowerType["*" 1  //授权中如果子表与父表权限一致，子表不再保存授权记录
	Set return=-1
	If (TabPowerType="C")&(aLocId'=""){  //管控数据授权
		Set return=##class(web.DHCPE.CT.DHCPEMappingLoc).SaveDataToPowerControl(..#ClassName,aId,aLocId,aUpdateUser)
		Quit:(+return)<0 return
	}
	If (TabPowerType="A")&(aLocId'=""){  //绝对私有数据授权
		Set return=##class(web.DHCPE.CT.DHCPEMappingLoc).SaveDataToPowerControl(..#ClassName,aId,aLocId,aUpdateUser)
		Quit:(+return)<0 return
	}
	If (TabPowerType="S")&(aLocId'=""){  //私有数据授权
		Set:aEmpower="" aEmpower="N"
		Set return=##class(web.DHCPE.CT.DHCPEMappingLoc).SaveDataToPowerControl(..#ClassName,aId,aLocId,aUpdateUser,aEmpower)
		Quit:(+return)<0 return
	}
	If (TabPowerType="C")&(aLocIDStr'=""){  //管控数据按科室授权
		Set return=##class(web.DHCPE.CT.DHCPEMappingLoc).SaveSDataToPowerControl(..#ClassName,aId,aLocIDStr,aUpdateUser)
	}
	If (TabPowerType="S")&(aEmpower="Y")&(aLocIDStr'=""){  //私有数据按科室授权
		Set return=##class(web.DHCPE.CT.DHCPEMappingLoc).SaveSDataToPowerControl(..#ClassName,aId,aLocIDStr,aUpdateUser)
	}
	Quit return
}

ClassMethod Update(aInputStr As %String, aDelimiter As %String = "") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aDelimiter="" aDelimiter=..#Delimiter
	
	Quit return
}

ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Quit:..ClassName="" 0
	Set sc=$ClassMethod(..#ClassName,"%DeleteId",aId)
	If $system.Status.IsError(sc) {  //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

ClassMethod GetJsonStrByID(id As %String = "")
{
	n (id)
	s str=""
	s clsDef=##class(%Library.ClassDefinition).%OpenId(..#ClassName)
	s obj=$ZOBJCLASSMETHOD(..#ClassName,"%OpenId",id)
	q:'$ISOBJECT(obj) "-1^没有生成对象" 
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		continue:proName["%"
		continue:clsPro.Cardinality="children"
		continue:clsPro.Cardinality="parent"
		s childPro=""
		s cls=clsPro.Type
		i cls["%" d
		.s value=$ZOBJPROPERTY(obj,proName)
		.i cls="%Date" d
		..s value = ##class(web.DHCHM.Abstract).TransDateToPage(value,3)
		.i str="" d
		..s str=""""_proName_""""_":"_""""_value_""""
		.e  d
		..s str=str_","""_proName_""""_":"_""""_value_""""
		e  d
		.s value=$ZOBJPROPERTY(obj,proName)
		.i $ISOBJECT(value) d
		..s value=value.%Id()
		.e  d
		..s value=""
		.i str="" d
		..s str=""""_proName_""""_":"_""""_value_""""
		.e  d
		..s str=str_","""_proName_""""_":"_""""_value_""""
		.s childPro=##class(web.DHCHM.Tools).GetPros(cls,"Desc")
		.i value'="" d
		..s value=$ZOBJPROPERTY($ZOBJPROPERTY(obj,proName),childPro)
		..s str=str_","""_childPro_""""_":"_""""_value_""""
	}
	s str=str_","""_"ID"_""""_":"_""""_id_""""
	q "{"_str_"}"
}

/// 成功返回ID，不成功返回-1^错误信息
/// w ##class(User.DHCHMOEvaluationRecord).SaveData("","1^1^2^4^208^1^2010-09-25^61684","QOBaseInfoDR^QCOccupationDR^QCEducationDR^QCMaritalDR^QHMDR^QAddUserDR^QAddDate^QAddTime")
ClassMethod SaveData(ID As %String = "", valueStr, propertieStr, transFlag As %String = "N")
{
	n (ID,valueStr,propertieStr,transFlag)
	q:##class(%Library.ClassDefinition).%ExistsId(..#ClassName)=0 "-1^实体类不存在"
	s clsDef=##class(%Library.ClassDefinition).%OpenId(..#ClassName)
	s obj=..GetObj(ID)
	q:'$ISOBJECT(obj) "-1^没有生成对象" 
	i transFlag="Y" TSTART
	k ^TempDHCHM($J,..#ClassName)
	s i=$l(valueStr,"^")
	f j=1:1:i
	{
		s ^TempDHCHM($J,..#ClassName,$p(propertieStr,"^",j))=$p(valueStr,"^",j)
		;w $p(propertieStr,"^",j)_":"_$p(valueStr,"^",j),!
	}
	s clsProList=clsDef.Properties
	f Num=1:1:clsProList.Count()
	{
		s clsPro=clsProList.GetAt(Num)
		s proName=clsPro.Name
		//没有传值退出当前循环
		continue:'$D(^TempDHCHM($J,..#ClassName,proName))
		s value=$G(^TempDHCHM($J,..#ClassName,proName))
		//普通类型%还需要分
		s cls=clsPro.Type
		i cls["%" d
		.i cls="%Date" d
		..s value=##class(web.DHCHM.Abstract).TransDateToDB(value)
		e  d
		.s:value'="" value=$zobjclassmethod(cls,"%OpenId",value)
		i clsPro.Type="%GlobalCharacterStream"{
			s str="d obj."_proName_".Write(value)"
			x str
		}else{
			s $ZOBJPROPERTY(obj,proName)=value
		}
	}
	k ^TempDHCHM($J,..#ClassName)
	s sc=obj.%Save()  //成功的话sc为1
	If ($System.Status.IsError(sc))	
	{
		i transFlag="Y" TROLLBACK
		Set myrtn = "-1^"_$System.Status.GetErrorText(sc)
	}else{
		i transFlag="Y" TCOMMIT
		s myrtn = obj.%Id()
	}
	d obj.%Close()
	q myrtn
}

ClassMethod GetObj(id As %String = "")
{
	n (id)
	q:id="" $zobjclassmethod(..#ClassName,"%New")
	s obj=$zobjclassmethod(..#ClassName,"%OpenId",id)
	q obj
}

ClassMethod Delete(id As %String = "", transFlag As %String = "N")
{
	n (id,transFlag)
	i transFlag="Y" TSTART
	s sc=$zobjclassmethod(..#ClassName,"%DeleteId",id)  //成功的话sc为1
	If ($System.Status.IsError(sc))	
	{
		i transFlag="Y" TROLLBACK
		Set myrtn = "-1^"_$System.Status.GetErrorText(sc)
	}else{
		i transFlag="Y" TCOMMIT
		s myrtn = "0^"
	}
	q myrtn
}

}
