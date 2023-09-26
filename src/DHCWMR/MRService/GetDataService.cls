/// 名称: DHCWMR.MRService.GetDataService
/// 描述: 住院病案首页取值服务
/// 编写者：zhufei
/// 编写日期: 2015-09-28
Class DHCWMR.MRService.GetDataService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Set arr=##Class(DHCWMR.MRService.GetDataService).GetArrayOfData(1)
/// Set arr.GetAt("P00010000")
ClassMethod GetArrayOfData(aId As %String) As %Library.ArrayOfDataTypes
{
	New (aId)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:aId="" return
	
	Set obj=##Class(DHCWMR.MR.FrontPage).GetObjById(aId)
	Quit:'$IsObject(obj) return
	Do return.SetAt(obj.FPEpisodeID,"EpisodeID")
	Do return.SetAt(obj.FPPatientID,"PatientID")
	Do return.SetAt(obj.FPADMNo,"ADMNo")
	Do return.SetAt(obj.FPMRType,"MRType")
	
	//就诊信息
	Set Count=obj.ChildAdm.Count()
	If Count>0 {
		Set oref=obj.ChildAdm.GetAt(Count)
		Quit:'$IsObject(oref) return
		
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageAdm")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageAdm")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:($e(ivar,1,2)'="P0")&($e(ivar,1,2)'="P1")
			Set cmd="Set val=oref."_ivar
			Xecute cmd
			Do return.SetAt(val,ivar)
		}
	}
	
	//费用信息
	Set Count=obj.ChildFees.Count()
	If Count>0 {
		Set oref=obj.ChildFees.GetAt(Count)
		Quit:'$IsObject(oref) return
		
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageFees")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageFees")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:$e(ivar,1,2)'="P6"
			Set cmd="Set val=oref."_ivar
			Xecute cmd
			Do return.SetAt(val,ivar)
		}
	}
	
	//附页内容及附加项目
	Set Count=obj.ChildAdd.Count()
	For indD=1:1:Count {
		Set oref=obj.ChildAdd.GetAt(indD)
		Continue:'$IsObject(oref)
		Continue:oref.PACode=""
		Do return.SetAt(oref.PAValue,oref.PACode)
	}
	
	//诊断信息
	Set Count=obj.ChildICD.Count()
	For indD=1:1:Count {
		Set oref=obj.ChildICD.GetAt(indD)
		Continue:'$IsObject(oref)
		Set PDType=oref.PDType
		Set:$l(PDType)=1 PDType="0"_PDType
		Set PDIndex=oref.PDIndex
		Set:$l(PDIndex)=1 PDIndex="0"_PDIndex
		
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICD")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICD")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:($e(ivar,1,2)'="PD")
			Continue:ivar="PDType"
			Continue:ivar="PDIndex"
			Continue:ivar="PDSerialNumber"
			Set cmd="Set val=oref."_ivar
			Xecute cmd
			Set ivar="P"_PDType_PDIndex_$e(ivar,3,6)
			Do return.SetAt(val,ivar)
		}
	}
	
	//手术信息
	Set Count=obj.ChildOper.Count()
	For indD=1:1:Count {
		Set oref=obj.ChildOper.GetAt(indD)
		Continue:'$IsObject(oref)
		Set POType=oref.POType
		Set:$l(POType)=1 POType="0"_POType
		Set POIndex=oref.POIndex
		Set:$l(POIndex)=1 POIndex="0"_POIndex
		
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageOper")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageOper")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:($e(ivar,1,2)'="PO")
			Continue:ivar="POType"
			Continue:ivar="POIndex"
			Continue:ivar="POSerialNumber"
			Set cmd="Set val=oref."_ivar
			Xecute cmd
			Set ivar="P"_POType_POIndex_$e(ivar,3,6)
			Do return.SetAt(val,ivar)
		}
	}
	
	//重症监护信息
	Set Count=obj.ChildICU.Count()
	For indD=1:1:Count {
		Set oref=obj.ChildICU.GetAt(indD)
		Continue:'$IsObject(oref)
		Set PIType=oref.PIType
		Set:$l(PIType)=1 PIType="0"_PIType
		Set PIIndex=oref.PIIndex
		Set:$l(PIIndex)=1 PIIndex="0"_PIIndex
		
		// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICU")      // P7以下使用
		Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICU")              // P8以上
		Set inst=cdef.Properties.Count()
		For indP=1:1:inst {
			Set objProperty=cdef.Properties.GetAt(indP)
			Continue:objProperty.Private=1 //私有属性不能序列化
			Set ivar=objProperty.Name
			Continue:($e(ivar,1,2)'="PI")
			Set cmd="Set val=oref."_ivar
			Xecute cmd
			Set ivar="P"_PIType_PIIndex_$e(ivar,3,6)
			Do return.SetAt(val,ivar)
		}
	}
	
	//d $System.OBJ.Dump(return)
	Quit return
}

/// w ##Class(DHCWMR.MRService.GetDataService).GetDataByCode(1,"P00060000")
ClassMethod GetDataByCode(aEpisodeID As %String, aCode As %String) As %String
{
	New (aEpisodeID,aCode)
	Set return=""
	Quit:(aEpisodeID="")||(aCode="") return
	
	Set FpID=$o(^DHCWMR.MR.FrontPageI("IndexEpisodeID"," "_aEpisodeID,0))
	Quit:FpID="" return
	Set obj=##Class(DHCWMR.MR.FrontPage).GetObjById(FpID)
	Quit:'$IsObject(obj) return
	
	Set arr=##Class(%Library.ArrayOfDataTypes).%New()
	If ($e(aCode,1,2)="P0")||($e(aCode,1,2)="P1") {
		//就诊信息
		Set Count=obj.ChildAdm.Count()
		If Count>0 {
			Set oref=obj.ChildAdm.GetAt(Count)
			Quit:'$IsObject(oref) return
			
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageAdm")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageAdm")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:aCode'=ivar  //代码筛查
				Continue:($e(ivar,1,2)'="P0")&($e(ivar,1,2)'="P1")
				Set cmd="Set val=oref."_ivar
				Xecute cmd
				Do arr.SetAt(val,ivar)
			}
		}
	} ElseIf ($e(aCode,1,2)="P6") {
		//费用信息
		Set Count=obj.ChildFees.Count()
		If Count>0 {
			Set oref=obj.ChildFees.GetAt(Count)
			Quit:'$IsObject(oref) return
			
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageFees")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageFees")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:aCode'=ivar  //代码筛查
				//Continue:$e(ivar,1,2)'="P6"
				Set cmd="Set val=oref."_ivar
				Xecute cmd
				Do arr.SetAt(val,ivar)
			}
		}
	} ElseIf ($e(aCode,1,2)="P2")||($e(aCode,1,2)="P3") {
		//诊断信息
		Set Count=obj.ChildICD.Count()
		For indD=1:1:Count {
			Set oref=obj.ChildICD.GetAt(indD)
			Continue:'$IsObject(oref)
			Set PDType=oref.PDType
			Set:$l(PDType)=1 PDType="0"_PDType
			Set PDIndex=oref.PDIndex
			Set:$l(PDIndex)=1 PDIndex="0"_PDIndex
			
			Set tCode="P"_PDType_PDIndex
			Continue:$e(aCode,1,$l(tCode))'=tCode  //代码筛查
			
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICD")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICD")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:($e(ivar,1,2)'="PD")
				Continue:ivar="PDType"
				Continue:ivar="PDIndex"
				Continue:ivar="PDSerialNumber"
				Continue:aCode'=("P"_PDType_PDIndex_$e(ivar,3,6))  //代码筛查
				Set cmd="Set val=oref."_ivar
				Xecute cmd
				Set ivar="P"_PDType_PDIndex_$e(ivar,3,6)
				Do arr.SetAt(val,ivar)
			}
		}
	} ElseIf ($e(aCode,1,2)="P4") {
		//手术信息
		Set Count=obj.ChildOper.Count()
		For indD=1:1:Count {
			Set oref=obj.ChildOper.GetAt(indD)
			Continue:'$IsObject(oref)
			Set POType=oref.POType
			Set:$l(POType)=1 POType="0"_POType
			Set POIndex=oref.POIndex
			Set:$l(POIndex)=1 POIndex="0"_POIndex
			
			Set tCode="P"_POType_POIndex
			Continue:$e(aCode,1,$l(tCode))'=tCode  //代码筛查
			
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageOper")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageOper")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:($e(ivar,1,2)'="PO")
				Continue:ivar="POType"
				Continue:ivar="POIndex"
				Continue:ivar="POSerialNumber"
				Continue:aCode'=("P"_POType_POIndex_$e(ivar,3,6))  //代码筛查
				Set cmd="Set val=oref."_ivar
				Xecute cmd
				Set ivar="P"_POType_POIndex_$e(ivar,3,6)
				Do arr.SetAt(val,ivar)
			}
		}
	} ElseIf ($e(aCode,1,2)="P5") {
		//重症监护信息
		Set Count=obj.ChildICU.Count()
		For indD=1:1:Count {
			Set oref=obj.ChildICU.GetAt(indD)
			Continue:'$IsObject(oref)
			Set PIType=oref.PIType
			Set:$l(PIType)=1 PIType="0"_PIType
			Set PIIndex=oref.PIIndex
			Set:$l(PIIndex)=1 PIIndex="0"_PIIndex
			
			Set tCode="P"_PIType_PIIndex
			Continue:$e(aCode,1,$l(tCode))'=tCode  //代码筛查
			
			// Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("DHCWMR.MR.FrontPageICU")      // P7以下使用
			Set cdef = ##class(%Library.CompiledClass).%OpenId("DHCWMR.MR.FrontPageICU")              // P8以上
			Set inst=cdef.Properties.Count()
			For indP=1:1:inst {
				Set objProperty=cdef.Properties.GetAt(indP)
				Continue:objProperty.Private=1 //私有属性不能序列化
				Set ivar=objProperty.Name
				Continue:($e(ivar,1,2)'="PI")
				Continue:aCode'=("P"_PIType_PIIndex_$e(ivar,3,6))  //代码筛查
				Set cmd="Set val=oref."_ivar
				Xecute cmd
				Set ivar="P"_PIType_PIIndex_$e(ivar,3,6)
				Do arr.SetAt(val,ivar)
			}
		}
	} Else {
		If aCode["P" {
			//附页内容及附加项目
			Set Count=obj.ChildAdd.Count()
			For indD=1:1:Count {
				Set oref=obj.ChildAdd.GetAt(indD)
				Continue:'$IsObject(oref)
				Continue:oref.PACode=""
				Continue:oref.PACode'=aCode
				Do arr.SetAt(oref.PAValue,oref.PACode)
			}
		} Else {
			Do arr.SetAt(obj.FPEpisodeID,"EpisodeID")
			Do arr.SetAt(obj.FPPatientID,"PatientID")
			Do arr.SetAt(obj.FPADMNo,"ADMNo")
			Do arr.SetAt(obj.FPMRType,"MRType")
		}
	}
	If arr.IsDefined(aCode) {
		Set return=arr.GetAt(aCode)
	}
	
	//d $System.OBJ.Dump(arr)
	Quit return
}

}
