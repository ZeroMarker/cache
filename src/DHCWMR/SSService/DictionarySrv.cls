/// 名称: DHCWMR.SSService.DictionarySrv
/// 描述: DHCWMR.SS.Dictionary字典表的常用操作
/// 编写者：zhouruimeng
/// 编写日期: 2014-08-21
Class DHCWMR.SSService.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-21
/// Description:  查询所有的字典或者字典项
/// Table：       DHCWMR.SS.Dictionary
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.DictionarySrv","QryDictionary","")
Query QryDictionary(aIsActive As %String = "1") As %Query(ROWSPEC = "DicRowID:%String,DicCode:%String,DicDesc:%String,CodeDesc:%String,DicType:%String,IsActive:%String,HospDr:%String,HospDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryExecute(ByRef qHandle As %Binary, aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set aDicType=""
 	For {
	 	Set aDicType = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode",aDicType))
 		Quit:aDicType=""
 		
 		Set aDicCode=""
 		For {
	 		Set aDicCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode",aDicType,aDicCode))
	 		Quit:aDicCode=""
 		
 			Set aHospID = ""
 			For {
 				Set aHospID = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode",aDicType,aDicCode,aHospID))
	 			Quit:aHospID=""
	 			
 			Set aDicRowID=0
 			For {
	 			Set aDicRowID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode",aDicType,aDicCode,aHospID,aDicRowID))
	 			Quit:aDicRowID=""
	 	
	 			Set objDic=##class(DHCWMR.SS.Dictionary).%OpenId(aDicRowID)
				If $IsObject(objDic){
					Set DicRowID = objDic.%Id()
		 			Set DicCode=objDic.SDCode
					Set DicDesc=objDic.SDDesc
					Set DicType=objDic.SDType
					Continue:DicType="SYS"
					Set DicHospID=objDic.SDHospID
					If DicHospID=""{
						Set DicHospDesc = $p($g(^CT("HOSP",xHospID)),"^",2)	
					}
					Else{
						Set DicHospDesc = ""
					}
					
					Set DicActive=objDic.SDIsActive
					Continue:DicActive'=1
					Set DicActive=$s(DicActive=1:"是",1:"否")
					Set Resume = objDic.SDResume
					Set CodeDesc = DicCode_"-"_DicDesc
					
					Set Data=$lb(DicRowID,DicCode,DicDesc,CodeDesc,DicType,DicActive,DicHospID,DicHospDesc,Resume)
	       	 		Set ^CacheTemp(repid,ind)=Data
	        		Set ind=ind+1
				}
				If objDic'="" Do objDic.%Close()
 				}
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCWMR.SSService.DictionarySrv).GetDicsByType("WorkFlowStep","","")
ClassMethod GetDicsByType(aType As %String, aHospID As %String = "", aActive As %String = "1") As %String
{
	New (aType,aHospID,aActive)
	Set return=""
	
	Set:aHospID="" aHospID = 0	
	
	
	Set aType=$ZCVT($g(aType),"U")
	Set TypeCode=""
	For {
		Set TypeCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode))
		Quit:TypeCode=""
		Set xHospID=""
		For {
			Set xHospID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID))
			Quit:xHospID=""
			Continue:(aHospID'=0)&&(xHospID'=" 0")&&(xHospID'=(" "_aHospID))
			
			Set RowID=0
			For {
				Set RowID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID,RowID))
				Quit:RowID=""
				Set objDic=##class(DHCWMR.SS.Dictionary).%OpenId(RowID)
				If $IsObject(objDic){
					Set Code=objDic.SDCode
					Set Description=objDic.SDDesc
					Set Type=objDic.SDType
					Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
					Set Active=objDic.SDIsActive
					Continue:(aActive'="")&&(Active'=aActive)
					If (Active="1"){
						Set Active="Yes"  
					}Else{
						Set Active="No"
					}
					Set HospitalDr=objDic.SDHospID
					Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
					
					Set return=return_RowID_$c(2)_Code_$c(2)_Description_$c(1)
				}
				If objDic'="" Do objDic.%Close()
			}
		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	
	Quit return
}

/// w ##Class(DHCWMR.SSService.DictionarySrv).GetDicsByTypeA("WorkFlowStep","","")
ClassMethod GetDicsByTypeA(aType As %String, aHospID As %String = "", aActive As %String = "1") As %String
{
	New (aType,aHospID,aActive)
	Set return=""
	
	Set:aHospID="" aHospID = 0	
	
	Kill arrWFITypes
	Set aType=$ZCVT($g(aType),"U")
	Set TypeCode=""
	For {
		Set TypeCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode))
		Quit:TypeCode=""
		Set xHospID=""
		For {
			Set xHospID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID))
			Quit:xHospID=""
			Continue:(aHospID'=0)&&(xHospID'=" 0")&&(xHospID'=(" "_aHospID))
			
 			Set RowID=0
 			For {
	 			Set RowID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aType,TypeCode,xHospID,RowID))
	 			Quit:RowID=""
	 			Set objDic=##class(DHCWMR.SS.Dictionary).%OpenId(RowID)
				If $IsObject(objDic){
		 			Set Code=objDic.SDCode
					Set Description=objDic.SDDesc
					Set Type=objDic.SDType
					Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
					Set Active=objDic.SDIsActive
					Continue:(aActive'="")&&(Active'=aActive)
					If (Active="1"){
						Set Active="Yes"  
					}Else{
			  			Set Active="No"
					}
					Set HospitalDr=objDic.SDHospID
					Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
				
					Set tmp=RowID_$c(2)_Code_$c(2)_Description
					Set arrWFITypes(RowID)=tmp
				}
				If objDic'="" Do objDic.%Close()
			}
		}
	}
	
	Set xID=0
	For {
		Set xID=$o(arrWFITypes(xID))
		Quit:xID=""
		Set tmp=$g(arrWFITypes(xID))
		Continue:tmp=""
		Set return=return_tmp_$c(1)
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Kill arrWFITypes
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-26
/// Description:  根据Type查询字典或者字典项
/// Table：       DHCWMR.SS.Dictionary
/// Input：       
/// output:       符合条件的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.DictionarySrv","QryDicByType","WorkType","","")
Query QryDicByType(aDicType As %String, aHospID As %String = "", aIsActive As %String = "1") As %Query(ROWSPEC = "DicRowID:%String,DicCode:%String,DicDesc:%String,DicType:%String,IsActive:%String,HospDr:%String,HospDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryDicByTypeExecute(ByRef qHandle As %Binary, aDicType As %String, aHospID As %String, aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aDicType=""
 	
 	Set xDicCode=""
 	For {
	 	Set xDicCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(aDicType,"U"),xDicCode))
	 	Quit:xDicCode=""
 	
 		For {
	 		Set aHospID = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(aDicType,"U"),xDicCode,aHospID))
	 		Quit:aHospID=""
	 		
			Set xDicRowID=0
 			For {
	 			Set xDicRowID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(aDicType,"U"),xDicCode,aHospID,xDicRowID))
	 			Quit:xDicRowID=""
	 	
	 			Set objDic=##class(DHCWMR.SS.Dictionary).%OpenId(xDicRowID)
				If $IsObject(objDic){
					Set DicRowID = objDic.%Id()
		 			Set DicCode=objDic.SDCode
					Set DicDesc=objDic.SDDesc
					Set DicType=objDic.SDType
					Set DicHospID=objDic.SDHospID
					If DicHospID'=""{
						Set DicHospDesc = $p($g(^CT("HOSP",DicHospID)),"^",2)	
					}
					Else{
						Set DicHospDesc = ""
					}
					
					Set IsActive=objDic.SDIsActive
					Continue:(aIsActive'="")&&(aIsActive'=IsActive)
					Set IsActive=$s(IsActive=1:"是",1:"否")
					Set Resume = objDic.SDResume
					
					Set Data=$lb(DicRowID,DicCode,DicDesc,DicType,IsActive,DicHospID,DicHospDesc,Resume)
	       	 		Set ^CacheTemp(repid,ind)=Data
	        		Set ind=ind+1
 				}
 				If objDic'="" Do objDic.%Close()
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryDicByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-21
/// Description:  查询所有的字典或者字典项
/// Table：       DHCWMR.SS.Dictionary
/// Input：       
/// output:       所有的字典或者某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.DictionarySrv","QryDicToCbo","EpidemicNotAdmToGo")
Query QryDicToCbo(aDicType As %String, aAddItem As %String = "") As %Query(ROWSPEC = "DicRowId:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod QryDicToCboExecute(ByRef qHandle As %Binary, aDicType As %String, aAddItem As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDicType=$ZCVT(aDicType,"U")
 	Quit:aDicType="" $$$OK
 	
 	Set aAddItem=$g(aAddItem)
 	If aAddItem'="" {
	 	Set DicRowID=$p(aAddItem,"^",1)
	 	Set DicCode=$p(aAddItem,"^",1)
	 	Set DicDesc=$p(aAddItem,"^",2)
		Set Data=$lb(DicRowID,DicCode,DicDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
 	Set aDicCode=""
 	For {
	 	Set aDicCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aDicType,aDicCode))
	 	Quit:aDicCode=""
	 	
	 	Set aHospID=""
 		For {
	 		Set aHospID = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZCVT(aDicType,"U"),aDicCode,aHospID))
	 		Quit:aHospID=""
 			
 			Set aDicRowID=0
 			For {
	 			Set aDicRowID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_aDicType,aDicCode,aHospID,aDicRowID))
	 			Quit:aDicRowID=""
	 	
	 			Set objDic=##class(DHCWMR.SS.Dictionary).%OpenId(aDicRowID)
				If $IsObject(objDic){
					Set DicRowID = objDic.%Id()
		 			Set DicCode=objDic.SDCode
					Set DicDesc=objDic.SDDesc
					Set DicType=objDic.SDType
					Continue:(aDicType'="")&&(aDicType'=$ZCVT(DicType,"U"))
					Set DicActive=objDic.SDIsActive
					Continue:DicActive'=1
					
					Set Data=$lb(DicRowID,DicCode,DicDesc)
	       	 		Set ^CacheTemp(repid,ind)=Data
	        		Set ind=ind+1
				}
				If objDic'="" Do objDic.%Close()
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryDicToCboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicToCboExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicToCboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicToCboExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCWMR.SSService.DictionarySrv).ImportDics("","^")
ClassMethod ImportDics(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//类型	 代码 	描述	医院	
	Set Type    = $p(aInputStr,aSeparate,2)
	Set Code    = $p(aInputStr,aSeparate,3)
	Set Desc    = $p(aInputStr,aSeparate,4)
	Set HospID  = $p(aInputStr,aSeparate,5)
	Set TextA   = $p(aInputStr,aSeparate,6)
	Set TextB   = $p(aInputStr,aSeparate,7)
	Set TextC   = $p(aInputStr,aSeparate,8)
	Set TextD   = $p(aInputStr,aSeparate,9)
	Set IsActive= $p(aInputStr,aSeparate,10)
	Set Resume  = $p(aInputStr,aSeparate,11)
	
	Set DicRowID=""
	Set DicID=0
	For {
		Set DicID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," "_$ZConvert(Type,"T")," "_$ZCVT(Code,"U")," "_$ZCVT(HospID,"U"),DicID))
		Quit:DicID=""
		Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set DicRowID=DicID
	}
	
	Set InputStr=DicRowID_aSeparate_Type_aSeparate_Code_aSeparate_Desc_aSeparate_HospID_aSeparate_TextA_aSeparate_TextB_aSeparate_TextC_aSeparate_TextD_aSeparate_IsActive_aSeparate_Resume
	Set return=##Class(DHCWMR.SS.Dictionary).Update(InputStr,aSeparate)
	
	Quit return
}

/// 删除基础字典
ClassMethod DeleteDictionarys(aTypeCode As %String, aHospID As %String) As %String
{
	New (aTypeCode)
	Set return=-1
	Quit:aTypeCode="" return
	
	Set $ZT="DeleteDictionarysErr"
	
	Set DicCode=""
	For {
		Set DicCode=$o(^DHCWMR.SS.DictionaryI("IdxofType"," "_$ZCVT(aTypeCode,"U"),DicCode))
		Quit:DicCode=""
		
		Set DicID=0
		For {
			Set DicID = $o(^DHCWMR.SS.DictionaryI("IdxofType"," "_$ZCVT(aTypeCode,"U"),DicCode,aHospID,DicID))
			Quit:DicID=""
			
			Set flg=##class(DHCWMR.SS.Dictionary).DeleteById(DicID)
		}
	}
	
	Set DicID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode"," SYS"," "_$ZCVT(aTypeCode,"U")," "_aHospID,0))
	If DicID'="" {
		Set flg=##class(DHCWMR.SS.Dictionary).DeleteById(DicID)
	}
	
	Set return=1
	Quit return
	
DeleteDictionarysErr
	Write "Error:"_$ZError,!
	Quit -999
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  导出字典
/// Table：       DHCWMR.SS.Dictionary
/// w ##Class(DHCWMR.SSService.DictionarySrv).ExportDics()
ClassMethod ExportDics() As %String
{
	Set return=""
	
	Set xId = ""
	For {
		Set xId = $o(^DHCWMR.SS.DictionaryD(xId))
		Quit:xId=""
		Set Ind=0
		
		Set objDic = ##class(DHCWMR.SS.Dictionary).GetObjById(xId)
		Continue:'$IsObject(objDic)
		
		Set Id     = objDic.%Id()
		Set Type   = objDic.SDType
		Set Code   = objDic.SDCode
		Set Desc   = objDic.SDDesc
	 	Set HospID = objDic.SDHospID
	 	If (HospID="")||(HospID=0){
		 	Set HospDesc= ""
	 	}
	 	Else{
	 		Set HospDesc = $p($g(^CT("HOSP",+HospID)),"^",2)	
	 	}
	 	Set TextA  = objDic.SDTextA
	 	Set TextB  = objDic.SDTextB
	 	Set TextC  = objDic.SDTextC
	 	Set TextD  = objDic.SDTextD
	 	Set IsActive  = $s(objDic.SDIsActive=1:"是",1:"否")
	 	Set Resume    = objDic.SDResume 
	 	Set Ind=Ind+1
		Set return=return_"||"_Ind_"^"_Id_"^"_Type_"^"_Code_"^"_Desc_"^"_HospID_"^"_HospDesc_"^"_TextA_"^"_TextB_"^"_TextC_"^"_TextD_"^"_IsActive_"^"_Resume
	}
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  查询基础字典，导出用
/// Table：       DHCWMR.SS.Dictionary
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.DictionarySrv","QrytoExport")
Query QrytoExport() As %Query(ROWSPEC = "Ind:%String,ID:%String,DicType:%String,DicCode:%String,DicDesc:%String,HospID:%String,HospDesc:%String,TextA:%String,TextB:%String,TextC:%String,TextD:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QrytoExportExecute(ByRef qHandle As %Binary, aCategory As %String, aActType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set Ind=0
 	Set xDicType=""
	For {
		Set xDicType=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode",xDicType))
		Quit:xDicType=""
		
		Set xDicCode = ""
		For {
			Set xDicCode = $o(^DHCWMR.SS.DictionaryI("IndexTypeCode",xDicType,xDicCode))
			Quit:xDicCode=""
			
	 		Set xID=0
	 		For {
				Set xID=$o(^DHCWMR.SS.DictionaryI("IndexTypeCode",xDicType,xDicCode,xID))
				Quit:xID=""
		
				Set objDic = ##class(DHCWMR.SS.Dictionary).GetObjById(xID)
				Continue:'$IsObject(objDic)
		
				Set Id     = objDic.%Id()
				Set Type   = objDic.SDType
				Set Code   = objDic.SDCode
				Set Desc   = objDic.SDDesc
	 			Set HospID = objDic.SDHospID
	 			If (HospID="")||(HospID=0){
		 			Set HospDesc= ""
	 			}
	 			Else{
	 				Set HospDesc = $p($g(^CT("HOSP",+HospID)),"^",2)	
	 			}
	 			Set TextA  = objDic.SDTextA
	 			Set TextB  = objDic.SDTextB
	 			Set TextC  = objDic.SDTextC
	 			Set TextD  = objDic.SDTextD
	 			Set IsActive  = objDic.SDIsActive
	 			Set IsActiveDesc = $s(IsActive=1:"是",1:"否")
	 			Set Resume    = objDic.SDResume 
	 			Set Ind=Ind+1
		 		Set Data=$lb(Ind,Id,Type,Code,Desc,HospID,HospDesc,TextA,TextB,TextC,TextD,IsActive,IsActiveDesc,ResumeText)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QrytoExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrytoExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrytoExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrytoExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
