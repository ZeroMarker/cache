Import SQLUser

/// 名称: web.DHCPE.KBA.SynchroService
/// 描述: 健康体检知识库应用同步服务
/// 编写者：zhufei
/// 编写日期: 2021-11-04
Class web.DHCPE.KBA.SynchroService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  20211210
/// Description: 常规检查项目-自动插入细项表、细项扩展表，且进行大项细项关联
/// Input:  	 aItemCode   : 标准项目ID
///              aLocID      : 科室ID
///              aUpdateUser : 用户ID
/// Return：     0(成功)
/// Debug: w ##class(web.DHCPE.KBA.SynchroService).SynchroOrdDtlByItemCode("9978||1")
ClassMethod SynchroOrdDtlByItemCode(aOrderDr As %String, aItemCode As %String, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (aOrderDr,aItemCode,aLocID,aUpdateUser)
	Set return=0,Count=0,Count2=0
	Quit:(aOrderDr="")||(aItemCode="")||(aLocID="") return
	
	Set ErrorInfo=""
	Set ZT="SynchroOrdDtlByItemCodeErr"
	
	Set LGLocID=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(aLocID)
	Quit:LGLocID="" return
	Set LGLocList=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocListByLoc(aLocID)
	Quit:LGLocList="" return
	Set ARCIMDR=$p($g(^DHCPEST(+aOrderDr,"O",$p(aOrderDr,"||",2))),"^",1)
	Quit:ARCIMDR="" return
	
	Set arrItemCode=##class(HMS.IO.ToPESrv).GetItemDtlByItemCode(aItemCode)
	Quit:arrItemCode.Count()<1 return
	Set ItemID       = arrItemCode.GetAt("ID")          //ID
	Set ItemCode     = arrItemCode.GetAt("Code")        //项目代码
	Set ItemDesc     = arrItemCode.GetAt("Desc")        //项目名称
	Set ItemCatCode  = arrItemCode.GetAt("ItemCatCode") //项目分类代码
	Set ItemCatDesc  = arrItemCode.GetAt("ItemCatDesc") //项目分类名称
	
	Set OrderDetailArray = arrItemCode.GetAt("OrderDetailArray")  //站点细项列表
	Quit:OrderDetailArray.Count()<1 return
	Set Cnt=OrderDetailArray.Count()
	For idxOrdDtl=1:1:Cnt {
		Set objOrdDtl=OrderDetailArray.GetAt(idxOrdDtl)
		Continue:'$IsObject(objOrdDtl)
		
		//同步站点细项
		Set flg=..UpdateOrderDetail(objOrdDtl,LGLocID,aUpdateUser)
		If (+flg)<1 {
			Set ErrorInfo="-1:同步站点细项错误,返回值="_flg
			Goto SynchroOrdDtlByItemCodeErr
		}
		Set OrderDetailDr=flg
		Set Count=Count+1
		
		Set ODStandardArray = objOrdDtl.GetAt("ODStandardArray")  //细项选择数组
		Continue:'$IsObject(ODStandardArray)
		Continue:ODStandardArray.Count()<1
		Set ODStandardCnt=ODStandardArray.Count()
		For idxODStandard=1:1:ODStandardCnt {
			Set objODStandard=ODStandardArray.GetAt(idxODStandard)
			Continue:'$IsObject(objODStandard)
			
			//同步站点细项选择
			Set flg=..UpdateODStandard(OrderDetailDr,objODStandard,LGLocID,aUpdateUser)
			If (+flg)<1 {
				Set ErrorInfo="-2:同步站点细项选择错误,返回值="_flg
				Goto SynchroOrdDtlByItemCodeErr
			}
			Set Count2=Count2+1
		}
		
		Set ODSequence=idxOrdDtl
		Set flg=..UpdateOrderDetailRelate(aOrderDr,ARCIMDR,OrderDetailDr,LGLocID,ODSequence,aUpdateUser)
		If (+flg)<1 {
			Set ErrorInfo="-1:同步大项细项组合错误,返回值="_flg
			Goto SynchroOrdDtlByItemCodeErr
		}
		
		For indLGL=1:1:$ll(LGLocList){
			Set LocID=$lg(LGLocList,indLGL)
			Continue:LocID=""
			
			Set flg=..UpdateOrderDetailSet(OrderDetailDr,LocID,aUpdateUser)
			If (+flg)<1 {
				Set ErrorInfo="-1:同步站点细项扩展表错误,返回值="_flg
				Goto SynchroOrdDtlByItemCodeErr
			}
		}
	}
	
	Set return=Count_","_Count2
	Quit return
	
SynchroOrdDtlByItemCodeErr
	Set $ZT=""
	If ErrorInfo'="" {
		Set return=ErrorInfo
	} Else {
		Set return="-999^"_$ZError
	}
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-12-09
/// Description:   同步专家建议和疾病
/// Input：        aLocID：科室ID
///                aHospTagCode：医院版本定义
/// Return：       ret>0:成功、ret<=0:失败
/// w ##class(web.DHCPE.KBA.SynchroService).SynchroDiagnosAndDisease(152,"U01110001")
ClassMethod SynchroDiagnosAndDisease(aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (aLocID,aUpdateUser)
	Set return=0
	Quit:(aLocID="") return
	
	Set LGLocID=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(aLocID)
	Quit:LGLocID="" return
	
	Set HospTagCode=##class(web.DHCPE.HISUICommon).GetHospTagsCode(aLocID)
	Quit:HospTagCode="" return
	
	//同步专家建议+建议条件
	Set flg=##class(web.DHCPE.KBA.SynchroService).SynchroDiagnos(aLocID,HospTagCode,aUpdateUser)
	If (+flg)<1 {
		Set flg=##class(web.DHCPE.HISUICommon).SetSettingByLoc(LGLocID,"KBHospTagsCode",HospTagCode_"/0")
		return
	}
	
	//同步体检疾病+疾病建议对照
	Set flg=##class(web.DHCPE.KBA.SynchroService).SynchroDisease(aLocID,HospTagCode,aUpdateUser)
	If (+flg)<1 {
		Set flg=##class(web.DHCPE.HISUICommon).SetSettingByLoc(LGLocID,"KBHospTagsCode",HospTagCode_"/0")
		return
	}
	
	Set return=1
	Set flg=##class(web.DHCPE.HISUICommon).SetSettingByLoc(LGLocID,"KBHospTagsCode",HospTagCode_"/1")
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-11-15
/// Description:   同步站点细项（只同步常规检查项目）
/// Input：        aLocID：科室ID
/// Return：       ret>0:成功、ret<=0:失败
/// w ##class(web.DHCPE.KBA.SynchroService).SynchroOrderDetail(152,"U01110001")
ClassMethod SynchroOrderDetail(aLocID As %String, aHospTagCode As %String = "", aUpdateUser As %String = "") As %String
{
	New (aLocID,aHospTagCode,aUpdateUser)
	Set return=0,Count=0,Count2=0
	Quit:(aLocID="")||(aHospTagCode="") return
	
	Set ErrorInfo=""
	Set $ZT="SynchroOrderDetailErr"
	
	Set arrOrdDtl=##class(HMS.IO.ToPESrv).GetItemDtlArray(aHospTagCode)
	Quit:arrOrdDtl.Count()<1 return
	Set Cnt=arrOrdDtl.Count()
	For idxOrdDtl=1:1:Cnt {
		Set objOrdDtl=arrOrdDtl.GetAt(idxOrdDtl)
		Continue:'$IsObject(objOrdDtl)
		
		Set ItemCatCode  = objOrdDtl.GetAt("ItemCatCode")   //站点项目分类代码
		Set ItemCatDesc  = objOrdDtl.GetAt("ItemCatDesc")   //站点项目分类名称
		//非常规检查项目不同步
		If $e(ItemCatCode,1,2)'="U1" {
			Write "-101^非常规检查项目不同步,Code="_ItemCatCode
			Continue
		}
		
		//同步站点细项
		Set flg=..UpdateOrderDetail(objOrdDtl,aLocID,aUpdateUser)
		If (+flg)<1 {
			Set ErrorInfo="-1:同步站点细项错误,返回值="_flg
			Goto SynchroOrderDetailErr
		}
		Set OrderDetailDr=flg
		Set Count=Count+1
		
		Set ODStandardArray = objOrdDtl.GetAt("ODStandardArray")  //细项选择数组
		Continue:'$IsObject(ODStandardArray)
		Continue:ODStandardArray.Count()<1
		Set ODStandardCnt=ODStandardArray.Count()
		For idxODStandard=1:1:ODStandardCnt {
			Set objODStandard=ODStandardArray.GetAt(idxODStandard)
			Continue:'$IsObject(objODStandard)
			
			//同步站点细项选择
			Set flg=..UpdateODStandard(OrderDetailDr,objODStandard,aLocID,aUpdateUser)
			If (+flg)<1 {
				Set ErrorInfo="-2:同步站点细项选择错误,返回值="_flg
				If (+flg)=-101 {
					//Write ErrorInfo,!
					Continue //数据对照问题，不再同步
				}
				Goto SynchroOrderDetailErr
			}
			Set Count2=Count2+1
		}
	}
	
	Set return=Count_","_Count2
	Quit return
	
SynchroOrderDetailErr
	Set $ZT=""
	If ErrorInfo'="" {
		Set return=ErrorInfo
	} Else {
		Set return="-999^"_$ZError
	}
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-11-04
/// Description:   同步主检结论及建议（包括专家建议条件）
/// Input：        aLocID：科室ID
///                aHospTagCode：医院版本定义
/// Return：       ret>0:成功、ret<=0:失败
/// w ##class(web.DHCPE.KBA.SynchroService).SynchroDiagnos(152,"U01110001")
ClassMethod SynchroDiagnos(aLocID As %String, aHospTagCode As %String, aUpdateUser As %String = "") As %String
{
	New (aLocID,aHospTagCode,aUpdateUser)
	Set return=0,Count=0,Count2=0
	Quit:(aLocID="")||(aHospTagCode="") return
	
	Set ErrorInfo=""
	Set $ZT="SynchroDiagnosErr"
	
	Set arrDiagnos=##class(HMS.IO.ToPESrv).GetDiagnosArray(aHospTagCode)
	Quit:arrDiagnos.Count()<1 return
	Set Cnt=arrDiagnos.Count()
	For idxDiagnos=1:1:Cnt {
		Set objDiagnos=arrDiagnos.GetAt(idxDiagnos)
		Continue:'$IsObject(objDiagnos)
		
		//同步专家建议表
		Set flg=..UpdateExpertDiagnosis(objDiagnos,aLocID,aUpdateUser)
		If (+flg)<1 {
			Set ErrorInfo="-1:同步专家建议表错误,返回值="_flg
			If (+flg)=-101 {
				//Write ErrorInfo,!
				Continue //数据对照问题，不再同步
			}
			Goto SynchroDiagnosErr
		}
		Set DiagnosDr=flg
		Set Count=Count+1
		
		Set ExpressArray = objDiagnos.GetAt("ExpressArray")  //表达式数组
		Continue:'$IsObject(ExpressArray)
		Continue:ExpressArray.Count()<1
		Set ExpCnt=ExpressArray.Count()
		For idxExp=1:1:ExpCnt {
			Set objExpress=ExpressArray.GetAt(idxExp)
			Continue:'$IsObject(objExpress)
			
			//同步专家建议表达式
			Set flg=..UpdateEDExpress(DiagnosDr,objExpress,aLocID,aUpdateUser)
			If (+flg)<1 {
				Set ErrorInfo="-2:同步专家建议表达式错误,返回值="_flg
				If (+flg)=-101 {
					//Write ErrorInfo,!
					Continue //数据对照问题，不再同步
				}
				Goto SynchroDiagnosErr
			}
			Set Count2=Count2+1
		}
	}
	
	Set return=Count_","_Count2
	Quit return
	
SynchroDiagnosErr
	Set $ZT=""
	If ErrorInfo'="" {
		Set return=ErrorInfo
	} Else {
		Set return="-999^"_$ZError
	}
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-11-04
/// Description:   同步疾病及疾病建议对照
/// Input：        aLocID：科室ID
///                aHospTagCode：医院版本定义
/// Return：       ret>0:成功、ret<=0:失败
/// w ##class(web.DHCPE.KBA.SynchroService).SynchroDisease(152,"U01110001")
ClassMethod SynchroDisease(aLocID As %String, aHospTagCode As %String, aUpdateUser As %String = "") As %String
{
	New (aLocID,aHospTagCode,aUpdateUser)
	Set return=0,Count=0,Count2=0
	Quit:(aLocID="")||(aHospTagCode="") return
	
	Set ErrorInfo=""
	Set $ZT="SynchroDiseaseErr"
	
	Set arrDisease=##class(HMS.IO.ToPESrv).GetDiseaseArray(aHospTagCode)
	Quit:arrDisease.Count()<1 return
	Set Cnt=arrDisease.Count()
	For idxDisease=1:1:Cnt {
		Set objDisease=arrDisease.GetAt(idxDisease)
		Continue:'$IsObject(objDisease)
		
		//同步疾病表
		Set flg=..UpdateIllnessStandard(objDisease,aLocID,aUpdateUser)
		If (+flg)<1 {
			Set ErrorInfo="-1:同步疾病表错误,返回值="_flg
			If (+flg)=-101 {
				//Write ErrorInfo,!
				Continue //数据对照问题，不再同步
			}
			Goto SynchroDiseaseErr
		}
		Set DiseaseDr=flg
		Set Count=Count+1
		
		Set DiagnosArray = objDisease.GetAt("DiagnosArray")  //疾病建议数组
		Continue:'$IsObject(DiagnosArray)
		Continue:DiagnosArray.Count()<1
		Set DDCnt=DiagnosArray.Count()
		For idxDD=1:1:DDCnt {
			Set objDD=DiagnosArray.GetAt(idxDD)
			Continue:'$IsObject(objDD)
			
			Set flg=..UpdateIDRelate(DiseaseDr,objDD,aLocID,aUpdateUser)	//同步疾病建议对照
			If (+flg)<1 {
				Set ErrorInfo="-2:同步疾病建议对照表错误,返回值="_flg
				If (+flg)=-101 {
					//Write ErrorInfo,!
					Continue //数据对照问题，不再同步
				}
				Goto SynchroDiseaseErr
			}
			Set Count2=Count2+1
		}
	}
	
	Set return=Count_","_Count2
	Quit return
	
SynchroDiseaseErr
	Set $ZT=""
	If ErrorInfo'="" {
		Set return=ErrorInfo
	} Else {
		Set return="-999^"_$ZError
	}
	Quit return
}

/// 更新站点细项表
ClassMethod UpdateOrderDetail(objOrdDtl As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (objOrdDtl,aLocID,aUpdateUser)
	Quit:'$IsObject(objOrdDtl) 0
	
	Set XCode         = objOrdDtl.GetAt("Code")         //内部编码
	Set Desc         = objOrdDtl.GetAt("Desc")          //细项名称
	Set ItemCatCode  = objOrdDtl.GetAt("ItemCatCode")   //站点项目分类代码
	Set ItemCatDesc  = objOrdDtl.GetAt("ItemCatDesc")   //站点项目分类名称
	Set DataFormat   = objOrdDtl.GetAt("DataFormat")    //数据格式（T说明型，N数值型，C计算型，S选择型，A多行文本）
	Set Unit         = objOrdDtl.GetAt("Unit")          //单位
	Set Express      = objOrdDtl.GetAt("Express")       //计算公式
	Set Explain      = objOrdDtl.GetAt("Explain")       //说明
	Set Sex          = objOrdDtl.GetAt("Sex")           //性别
	Set Sort         = objOrdDtl.GetAt("Sort")          //顺序号
	Set Sort = +$e(Sort,2,*)
	Quit:(XCode="")||(Desc="") 0
	
	//非常规检查项目不同步
	Quit:$e(ItemCatCode,1,2)'="U1" "-101^非常规检查项目不同步,Code="_ItemCatCode
	
	//站点ID、站点分类ID
	Set StationID=""
	Set StationLocID=""
	Set xParref=0
	For {
		Set xParref=$o(^DHCPEST(0,"STL","KBXCode",$zcvt(ItemCatCode,"U"),xParref))
		Quit:xParref=""
		
		Set xSub=$o(^DHCPEST(0,"STL","KBXCode",$zcvt(ItemCatCode,"U"),xParref,0))
		Continue:xSub=""
    	Set StationLocID=xParref_"||"_xSub
    	Set StationID=xParref
    	Quit
	}
	If StationID="" {
		Set ItemCatCode=$e(ItemCatCode,1,4)
		Set xID=0
		For {
			Set xID=$o(^DHCPEST(0,"KBXCode",$zcvt(ItemCatCode,"U"),xID))
			Quit:xID=""
			
	    	Set StationID=xID
	    	Quit
		}
	}
	Quit:StationID="" "-101^站点或站点分类对照有问题,Code="_ItemCatCode
	
	//站点细项表ID
	Set OrderDetailDr=""
	Set xSub=0
	For {
		Set xSub=$o(^DHCPEST(0,"OD","KBXCode",$zcvt(XCode,"U"),StationID,xSub))
		Quit:xSub=""
		
    	Continue:##class(User.DHCPEOrderDetail).GetLocShowDataFlag(StationID_"||"_xSub,aLocID)'="Y"
    	Set OrderDetailDr=StationID_"||"_xSub
    	Quit
	}
	Quit:OrderDetailDr'="" OrderDetailDr
	
	If OrderDetailDr="" {
		//Set objOD=##class(User.DHCPEOrderDetail).%New()
		&SQL(Insert into DHC_PE_OrderDetail set OD_ParRef = :StationID)
		Quit:SQLCODE'=0 0
		Set OrderDetailDr=%ROWID
		Set objOD=##class(User.DHCPEOrderDetail).%OpenId(OrderDetailDr)
		Set Code=##class(web.DHCPE.CT.StationOrder).GetODCode(StationID)
	} Else {
		Set objOD=##class(User.DHCPEOrderDetail).%OpenId(OrderDetailDr)
		Set Code=objOD.ODCode
		If objOD.ODExpression'="" {
			Set Express=objOD.ODExpression
		}
	}
	Set objOD.ODCode                   = Code         //项目编号(体检系统中特殊处理，避免与检验子项目代码重复)
	Set objOD.ODDesc                   = Desc         //项目名称
	Set objOD.ODExpression             = Express      //计算公式
	Set objOD.ODExplain                = Explain      //说明
	Set objOD.ODSequence               = Sort         //顺序号
	Set objOD.ODSex                    = Sex          //性别
	Set objOD.ODType                   = DataFormat   //项目类型
	Set objOD.ODUnit                   = Unit         //单位
	Set objOD.ODNoActive               = "Y"          //作废标记
	Set objOD.ODUpdateDate             = +$h          //更新日期
	Set objOD.ODUpdateTime             = $p($h,",",2) //更新时间
	Set objOD.ODUpdateUserDR           = aUpdateUser  //更新人
	Set objOD.ODKBXCode                = XCode        //知识库外部码
	Set objOD.ODKBItemDtlDesc          = Desc         //知识库站点细项名称
	Set sc=objOD.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set OrderDetailDr=-1
	}Else{
		Set OrderDetailDr=objOD.%Id()
		Set flg=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(OrderDetailDr,aLocID,aUpdateUser)
	}
	Do objOD.%Close()
	
	Quit OrderDetailDr
}

/// 更新站点细项扩展表
ClassMethod UpdateOrderDetailSet(aOrderDetailDr As %String, aLocID As %String, aUpdateUser As %String = "")
{
	New (aOrderDetailDr,aLocID,aUpdateUser)
	Set return=0
	Quit:(aOrderDetailDr="")||(aLocID="") return
	
	Set Summary="Y",NoPrint="N",ODSetID=""
	Set UpdateDate=+$h,UpdateTime=$p($h,",",2)
	Set OrdDetailSetID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_aLocID,aOrderDetailDr,0))
	If OrdDetailSetID="" {
		&sql(insert into sqluser.DHC_PE_OrderDetailSet (
			ODS_OrderDtlDR,ODS_LocDR,ODS_Summary,ODS_NoPrint,
			ODS_UpdateDate,ODS_UpdateTime,ODS_UpdateUserDR
		) values (
			:aOrderDetailDr,:aLocID,:Summary,:NoPrint,
			:UpdateDate,:UpdateTime,:aUpdateUser
		))
		Quit:SQLCODE'=0 "-1^插入细项扩展表失败"
		Set return=%ROWID //细项扩展表ID
		Set flg=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(return,aLocID,aUpdateUser)
		Quit:(+flg)<0 "-1^细项扩展表插入记录授权表失败"
	} Else {
		Set return=OrdDetailSetID
	}
	Quit return
}

/// 更新大项细项组合
ClassMethod UpdateOrderDetailRelate(aOrderDr As %String, aARCIMDR As %String, aOrderDetailDr As %String, aLocID As %String, aSequence As %String, aUpdateUser As %String = "")
{
	New (aOrderDr,aARCIMDR,aOrderDetailDr,aLocID,aSequence,aUpdateUser)
	Set return=0
	Quit:(aOrderDr="")||(aARCIMDR="")||(aOrderDetailDr="")||(aLocID="") return
	
	Set UpdateDate=+$h,UpdateTime=$p($h,",",2)
	Set IsExsistODRelate=##class(web.DHCPE.CT.OrderDetailRelate).IsExsistODRelate(aOrderDr,aOrderDetailDr,aLocID)
	If IsExsistODRelate="0" {
		&SQL(insert into sqluser.DHC_PE_OrderDetailRelate (
			ODR_OrderDR,ODR_ARCIM_DR,ODR_OD_DR,ODR_Sequence,ODR_Required,ODR_NoActive,ODR_UpdateDate,ODR_UpdateTime,ODR_UpdateUserDR
		) values (
			:aOrderDr,:aARCIMDR,:aOrderDetailDr,:aSequence,'Y','Y',:UpdateDate,:UpdateTime,:aUpdateUser
		))
		Quit:SQLCODE'=0 "-1^插入大项细项组合表失败"
 		Set return=%ROWID //大项细项组合表ID
 		Set flg=##class(User.DHCPEOrderDetailRelate).SaveDataToPowerControl(return,aLocID,aUpdateUser,"N")
		Quit:(+flg)<0 "-1^大项细项组合插入记录授权表失败"
	} Else {
		Set return=1
	}
	Quit return
}

/// 更新站点细项选择表
ClassMethod UpdateODStandard(aOrderDetailDr As %String, objODStandard As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (aOrderDetailDr,objODStandard,aLocID,aUpdateUser)
	Quit:'$IsObject(objODStandard) 0
	
	Set Sex         = objODStandard.GetAt("Sex")         //适用性别
	Set AgeMax      = objODStandard.GetAt("AgeMax")      //年龄上限
	Set AgeMin      = objODStandard.GetAt("AgeMin")      //年龄下限
	Set TextVal     = objODStandard.GetAt("TextVal")     //文本值
	Set Unit        = objODStandard.GetAt("Unit")        //单位
	Set Max         = objODStandard.GetAt("Max")         //值上限
	Set Min         = objODStandard.GetAt("Min")         //值下限
	Set NatureValue = objODStandard.GetAt("NatureValue") //是否正常值
	Set HDValue     = objODStandard.GetAt("HDValue")     //荒诞值
	Set EyeSee      = objODStandard.GetAt("EyeSee")      //所见
	Set Default     = objODStandard.GetAt("Default")     //默认
	Set Sort        = objODStandard.GetAt("Sort")        //顺序号
	Quit:(TextVal="")&&(Max="")&&(Min="") 0
	
	//站点细项选择表ID
	Set ODStandardDr=""
	Set xSub=0
	For {
		Set xSub=$o(^DHCPEST(+aOrderDetailDr,"OD",+$p(aOrderDetailDr,"||",2),"ODS",xSub))
		Quit:xSub=""
		
		Set objODS=##class(User.DHCPEODStandard).GetObjById(aOrderDetailDr_"||"_xSub)
		Continue:'$IsObject(objODS)
		If objODS.ODSTextVal'="" {
			Continue:(objODS.ODSTextVal'=TextVal)
		} Else {
			Continue:(objODS.ODSMax'=Max)&&(objODS.ODSMin'=Min)
		}
		
    	Set ODStandardDr=aOrderDetailDr_"||"_xSub
    	Quit
	}
	
	If ODStandardDr="" {
		//Set objODS=##class(User.DHCPEODStandard).%New()
		&SQL(Insert into DHC_PE_ODStandard set ODS_ParRef = :aOrderDetailDr)
		Quit:SQLCODE'=0 0
		Set ODStandardDr=%ROWID
		Set objODS=##class(User.DHCPEODStandard).%OpenId(ODStandardDr)
	} Else {
		Set objODS=##class(User.DHCPEODStandard).%OpenId(ODStandardDr)
	}
	Set objODS.ODSSex                   = Sex            //适应性别
	Set objODS.ODSAgeMax                = AgeMax         //年龄上限
	Set objODS.ODSAgeMin                = AgeMin         //年龄下限
	Set objODS.ODSTextVal               = TextVal        //文本值
	Set objODS.ODSUnit                  = Unit           //单位
	Set objODS.ODSMax                   = Max            //上限
	Set objODS.ODSMin                   = Min            //下限
	Set objODS.ODSNatureValue           = NatureValue    //是否正常值
	Set objODS.ODSHDValue               = HDValue        //荒诞值
	Set objODS.ODSEyeSee                = EyeSee         //所见
	Set objODS.ODSDefault               = Default        //默认
	Set objODS.ODSNoActive              = "Y"            //作废标记
	Set objODS.ODSUpdateDate            = +$h            //更新日期
	Set objODS.ODSUpdateTime            = $p($h,",",2)   //更新时间
	Set objODS.ODSUpdateUserDR          = aUpdateUser    //更新人
	Set objODS.ODSTemplate              = $e(Sort,2,*)   //顺序号(字母去掉)
	Set sc=objODS.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ODStandardDr=-1
	}Else{
		Set ODStandardDr=objODS.%Id()
		Set flg=##class(User.DHCPEODStandard).SaveDataToPowerControl(ODStandardDr,aLocID,aUpdateUser)
	}
	Do objODS.%Close()
	
	Quit ODStandardDr
}

/// 更新疾病表
ClassMethod UpdateIllnessStandard(objDisease As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (objDisease,aLocID,aUpdateUser)
	Quit:'$IsObject(objDisease) 0
	
	Set ID           = objDisease.GetAt("ID")            //ID
	Set Code         = objDisease.GetAt("Code")          //内部编码
	Set Desc         = objDisease.GetAt("Desc")          //疾病名称
	Set Detail       = objDisease.GetAt("Detail")        //疾病建议
	Set Illness      = objDisease.GetAt("Illness")       //是否疾病
	Set CommonIll    = objDisease.GetAt("CommonIll")     //是否常见病
	Set ToReport     = objDisease.GetAt("ToReport")      //是否上报
	Set Sex          = objDisease.GetAt("Sex")           //性别
	Set Type         = objDisease.GetAt("Type")          //类型（1 团体报告、2  妇科统计、3 阳性统计）
	Set Alias        = objDisease.GetAt("Alias")         //首拼（多值%分割）
	Quit:(ID="")||(Code="")||(Desc="") 0
	
	//是否疾病、是否常见病
	Set Illness=$s(Illness["Y":"Y",Illness["N":"N",Illness["是":"Y",Illness["否":"N",1:Illness)
	Set CommonIll=$s(CommonIll["Y":"Y",CommonIll["N":"N",CommonIll["是":"Y",CommonIll["否":"N",1:CommonIll)
	
	//疾病表ID
	Set DiseaseDr=""
	Set xID=0
	For {
		Set xID=$o(^DHCPEILLS(0,"KBXCode",$zcvt(ID,"U"),xID))
		Quit:xID=""
		
    	Continue:##class(User.DHCPEIllnessStandard).GetLocShowDataFlag(xID,aLocID)'="Y"
    	Set DiseaseDr=xID
    	Quit
	}
	
	If DiseaseDr="" {
		Set objIS=##class(User.DHCPEIllnessStandard).%New()
	} Else {
		Set objIS=##class(User.DHCPEIllnessStandard).%OpenId(DiseaseDr)
	}
	Set objIS.ILLSCode                 = $e(Code,2,*) //编号
	Set objIS.ILLSDesc                 = Desc         //疾病描述
	Set objIS.ILLSDetail               = Detail       //疾病建议
	Set objIS.ILLSIllness              = Illness      //是否疾病
	Set objIS.ILLSCommonIllness        = CommonIll    //是否常见病
	Set objIS.ILLSToReport             = ToReport     //是否上报
	Set objIS.ILLSSex                  = Sex          //性别
	Set objIS.ILLSLocDR                = ""           //科室（作废）
	Set objIS.ILLSType                 = Type         //类型（1:团体分析疾病对照使用  2：妇科疾病对照使用  3：阳性统计）
	Set objIS.ILLSNoActive             = "Y"          //作废标记
	Set objIS.ILLSUpdateDate           = +$h          //更新日期
	Set objIS.ILLSTimeUpdate           = $p($h,",",2) //更新时间
	Set objIS.ILLSUserUpdateDR         = aUpdateUser  //更新人
	Set objIS.ILLSKBXCode              = ID           //知识库外部码
	Set sc=objIS.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set DiseaseDr=-1
	}Else{
		Set DiseaseDr=objIS.%Id()
		Set flg=##class(User.DHCPEIllnessStandard).SaveDataToPowerControl(DiseaseDr,aLocID,aUpdateUser)
	}
	Do objIS.%Close()
	Quit:DiseaseDr<1 DiseaseDr
	
	//更新专家建议别名
	If Alias'="" {
		For indAlias=1:1:$l(Alias,"%") {
			Set tAlias=$p(Alias,"%",indAlias)
			Continue:tAlias=""
			
			Set AliasDr=$o(^DHCPEILLSA(0,"ILLSDRText",DiseaseDr,$zcvt(tAlias,"U"),0))
			If AliasDr="" {
				Set objILLSA=##class(User.DHCPEILLSAlias).%New()
			} Else {
				Set objILLSA=##class(User.DHCPEILLSAlias).%OpenId(AliasDr)
			}
			Set objILLSA.ILLSAILLSDR  = ##class(User.DHCPEIllnessStandard).GetObjById(DiseaseDr)    //疾病
			Set objILLSA.ILLSAText    = tAlias       //别名
			Set sc=objILLSA.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
		   		Set AliasDr=-1
			}Else{
				Set AliasDr=objILLSA.%Id()
			}
			Do objILLSA.%Close()
		}
	}
	
	Quit DiseaseDr
}

ClassMethod UpdateIDRelate(aDiseaseDr As %String, objDD As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (aDiseaseDr,objDD,aLocID,aUpdateUser)
	Quit:'$IsObject(objDD) 0
	Quit:aDiseaseDr="" 0
	
	Set ID          = objDD.GetAt("ID")         //主检结论ID
	Set Code        = objDD.GetAt("Code")       //主检结论代码
	Set Diagnos     = objDD.GetAt("Diagnos")    //主检结论
	Quit:(Code="")||(ID="") 0
	
	//主检结论及建议（专家建议）表ID
	Set DiagnosDr=""
	Set xID=0
	For {
		Set xID=$o(^DHCPEED(0,"KBXCode",$zcvt(ID,"U"),xID))
		Quit:xID=""
		
    	Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xID,aLocID)'="Y"
    	Set DiagnosDr=xID
    	Quit
	}
	Quit:DiagnosDr="" 0
	
	Set IDRelateDr=$o(^DHCPEIDR(0,"ILLSED",aDiseaseDr,DiagnosDr,0))
	If IDRelateDr="" {
		Set objIDR=##class(User.DHCPEIDRelate).%New()
	} Else {
		Set objIDR=##class(User.DHCPEIDRelate).%OpenId(IDRelateDr)
	}
	Set objIDR.IDRILLSDR     = ##class(User.DHCPEIllnessStandard).GetObjById(aDiseaseDr)   //疾病Dr
	Set objIDR.IDREDDR       = ##class(User.DHCPEExpertDiagnosis).GetObjById(DiagnosDr)    //专家建议Dr
	Set objIDR.IDRNoActive              = "Y"          //作废标记
	Set objIDR.IDRUpdateDate            = +$h          //更新日期
	Set objIDR.IDRUpdateTime            = $p($h,",",2) //更新时间
	Set objIDR.IDRUpdateUserDR          = aUpdateUser  //更新人
	Set sc=objIDR.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set IDRelateDr=-1
	}Else{
		Set IDRelateDr=objIDR.%Id()
	}
	Do objIDR.%Close()
	
	Quit IDRelateDr
}

/// 参考##class(web.DHCPE.CT.ExpertDiagnosis).UpdateED()
ClassMethod UpdateExpertDiagnosis(objDiagnos As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (objDiagnos,aLocID,aUpdateUser)
	Quit:'$IsObject(objDiagnos) 0
	
	Set ID           = objDiagnos.GetAt("ID")            //ID
	Set Code         = objDiagnos.GetAt("Code")          //内部编码
	Set Diagnos      = objDiagnos.GetAt("Diagnos")       //主检结论
	Set Advice       = objDiagnos.GetAt("Advice")        //专家建议
	Set ItemCatCode  = objDiagnos.GetAt("ItemCatCode")   //站点或站点分类代码
	Set Illness      = objDiagnos.GetAt("Illness")       //是否疾病
	Set CommonIll    = objDiagnos.GetAt("CommonIll")     //是否常见病
	Set HighRisk     = objDiagnos.GetAt("HighRisk")      //高危
	Set Sex          = objDiagnos.GetAt("Sex")           //性别
	Set HBV          = objDiagnos.GetAt("HBV")           //乙肝
	Set Sort         = objDiagnos.GetAt("Sort")          //顺序号
	Set DiagnosClass = objDiagnos.GetAt("DiagnosClass")  //建议级别
	Set Alias        = objDiagnos.GetAt("Alias")         //首拼（多值%分割）
	Quit:(ID="")||(Code="")||(Diagnos="")||(Advice="")||(ItemCatCode="") 0
	
	//性别、是否疾病、是否常见病、高危、乙肝
	Set SexDr="",objSex=""
	If Sex'="" {
		Set SexDr=$o(^CT("SEX",0,"Code",$zcvt(Sex,"U"),0))
		Set:SexDr="" SexDr=$o(^CT("SEX",0,"Desc",$zcvt(Sex,"U"),0))
	}
	Set Illness=$s(Illness["Y":"Y",Illness["N":"N",Illness["是":"Y",Illness["否":"N",1:Illness)
	Set CommonIll=$s(CommonIll["Y":"Y",CommonIll["N":"N",CommonIll["是":"Y",CommonIll["否":"N",1:CommonIll)
	Set HighRisk=$s(HighRisk["Y":"Y",HighRisk["N":"N",HighRisk["是":"Y",HighRisk["否":"N",1:HighRisk)
	Set HBV=$s(HBV["Y":"Y",HBV["N":"N",HBV["是":"Y",HBV["否":"N",1:HBV)
	
	//站点ID、站点分类ID
	Set StationID=""
	Set StationLocID=""
	Set xParref=0
	For {
		Set xParref=$o(^DHCPEST(0,"STL","KBXCode",$zcvt(ItemCatCode,"U"),xParref))
		Quit:xParref=""
		
		Set xSub=$o(^DHCPEST(0,"STL","KBXCode",$zcvt(ItemCatCode,"U"),xParref,0))
		Continue:xSub=""
    	Set StationLocID=xParref_"||"_xSub
    	Set StationID=xParref
    	Quit
	}
	If StationID="" {
		Set ItemCatCode=$e(ItemCatCode,1,4)
		Set xID=0
		For {
			Set xID=$o(^DHCPEST(0,"KBXCode",$zcvt(ItemCatCode,"U"),xID))
			Quit:xID=""
			
	    	Set StationID=xID
	    	Quit
		}
	}
	Quit:StationID="" "-101^站点或站点分类对照有问题,Code="_ItemCatCode
	
	//主检结论及建议（专家建议）表ID
	Set DiagnosDr=""
	Set xID=0
	For {
		Set xID=$o(^DHCPEED(0,"KBXCode",$zcvt(ID,"U"),xID))
		Quit:xID=""
		
    	Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xID,aLocID)'="Y"
    	Set DiagnosDr=xID
    	Quit
	}
	
	If DiagnosDr="" {
		Set objED=##class(User.DHCPEExpertDiagnosis).%New()
	} Else {
		Set objED=##class(User.DHCPEExpertDiagnosis).%OpenId(DiagnosDr)
	}
	Set objED.EDCode                   = $e(Code,2,*)         //编号
	Set objED.EDDiagnoseConclusion     = Diagnos      //主检结论（疾病诊断）
	Set objED.EDDetail                 = Advice       //专家建议
	Set objED.EDStationDR    = ##class(User.DHCPEStation).GetObjById(StationID)    //站点
	Set objED.EDStationLocID = ##class(User.DHCPEStationLoc).GetObjById(StationLocID) //站点分类
	Set objED.EDIllness                = Illness      //是否疾病
	Set objED.EDCommonIllness          = CommonIll    //是否常见病
	Set objED.EDHighRisk               = HighRisk     //高危
	Set objED.EDSexDR                  = SexDr        //性别
	Set objED.EDYGCheck                = HBV          //乙肝
	Set objED.EDSort                   = Sort         //顺序号
	Set objED.EDActive                 = "Y"          //激活
	Set objED.EDDateUpdate             = +$h          //更新日期
	Set objED.EDTimeUpdate             = $p($h,",",2) //更新时间
	//Set objED.EDUserUpdateDR         = aUpdateUser  //更新人
    do objED.EDUserUpdateDRSetObjectId( aUpdateUser)  //更新人
	Set objED.EDKBXCode                = ID           //知识库外部码
	Set sc=objED.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set DiagnosDr=-1
	}Else{
		Set DiagnosDr=objED.%Id()
		Set flg=##class(User.DHCPEExpertDiagnosis).SaveDataToPowerControl(DiagnosDr,aLocID,aUpdateUser)
	}
	Do objED.%Close()
	Quit:DiagnosDr<1 DiagnosDr
	
	//更新专家建议级别
	If DiagnosClass'="" {
		Set DiagnosClassDr=$o(^DHCPEEDC(0,"Code",DiagnosClass,0))
		Set:DiagnosClassDr'="" DiagnosClassDr=$o(^DHCPEEDC(0,"Desc",DiagnosClass,0))
		
		Set RelateDr=$o(^DHCPEEDCR(0,"EDEDCDr",DiagnosDr,DiagnosClassDr,0))
		If RelateDr="" {
			Set objEDCR=##class(User.DHCPEEDCRelate).%New()
		} Else {
			Set objEDCR=##class(User.DHCPEEDCRelate).%OpenId(RelateDr)
		}
		Set objEDCR.EDCREDDR   = ##class(User.DHCPEExpertDiagnosis).GetObjById(DiagnosDr)  //主检结论及建议（专家建议）
		Set objEDCR.EDCREDCDR  = ##class(User.DHCPEEDClass).GetObjById(DiagnosClassDr) //建议级别
		Set sc=objEDCR.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc)
	   		Set RelateDr=-1
		}Else{
			Set RelateDr=objEDCR.%Id()
		}
		Do objEDCR.%Close()
	}
	
	//更新专家建议别名
	If Alias'="" {
		For indAlias=1:1:$l(Alias,"%") {
			Set tAlias=$p(Alias,"%",indAlias)
			Continue:tAlias=""
			
			Set AliasDr=$o(^DHCPEEDA(0,"EDAlias",DiagnosDr,$zcvt(tAlias,"U"),0))
			If AliasDr="" {
				Set objEDA=##class(User.DHCPEEDAlias).%New()
			} Else {
				Set objEDA=##class(User.DHCPEEDAlias).%OpenId(AliasDr)
			}
			Set objEDA.EDAEDDR   = ##class(User.DHCPEExpertDiagnosis).GetObjById(DiagnosDr)  //主检结论及建议（专家建议）
			Set objEDA.EDAText   = tAlias       //别名
			Set sc=objEDA.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
		   		Set AliasDr=-1
			}Else{
				Set AliasDr=objEDA.%Id()
			}
			Do objEDA.%Close()
		}
	}
	
	Quit DiagnosDr
}

ClassMethod UpdateEDExpress(aDiagnosDr As %String, objExpress As %DataType, aLocID As %String, aUpdateUser As %String = "") As %String
{
	New (aDiagnosDr,objExpress,aLocID,aUpdateUser)
	Quit:'$IsObject(objExpress) 0
	Quit:aDiagnosDr="" 0
	
	Set ID           = objExpress.GetAt("ID")            //ID
	Set PreBracket   = objExpress.GetAt("PreBracket")    //前置括号
	Set ItemDtlCode  = objExpress.GetAt("ItemDtlCode")   //细项代码
	Set ItemDtlDesc  = objExpress.GetAt("ItemDtlDesc")   //细项名称
	Set Operator     = objExpress.GetAt("Operator")      //操作费
	Set Reference    = objExpress.GetAt("Reference")     //参考值
	Set AfterBracket = objExpress.GetAt("AfterBracket")  //后置括号
	Set Relation     = objExpress.GetAt("Relation")      //关系
	Set AgeRange     = objExpress.GetAt("AgeRange")      //年龄区间
	Set Sex          = objExpress.GetAt("Sex")           //性别限定
	Set NoBloodFlag  = objExpress.GetAt("NoBloodFlag")   //非血标志
	Quit:(ID="")||(ItemDtlCode="")||(ItemDtlDesc="") 0
	
	//专家建议表达式ID
	Set ExpressDr=$o(^User.DHCPEExpressI("IdxOfKBXCode",aDiagnosDr,$zcvt(ID,"U"),0))
	If ExpressDr="" {
		Set objExp=##class(User.DHCPEExpress).%New()
	} Else {
		Set objExp=##class(User.DHCPEExpress).%OpenId(ExpressDr)
	}
	Set objExp.ESourceID                = aDiagnosDr   //编号
	Set objExp.EPreBracket              = PreBracket   //前置括号
	Set objExp.EItemDR                  = ""           //细项Dr
	Set objExp.EODStandardDR            = ""           //细项选项Dr
	Set objExp.EOperator                = Operator     //操作符
	Set objExp.EReference               = Reference    //参考值
	Set objExp.EAfterBracket            = AfterBracket //后置括号
	Set objExp.ERelation                = Relation     //关系
	Set objExp.EAgeRange                = AgeRange     //年龄范围
	Set objExp.ESex                     = Sex          //性别
	Set objExp.ENoBloodFlag             = NoBloodFlag  //非血标志
	Set objExp.EType                    = "ED"         //类型（ED 建议表达式维护、PR 阳性记录维护）
	Set objExp.EKBItemDtlCode           = ItemDtlCode  //知识库细项代码
	Set objExp.EKBItemDtlDesc           = ItemDtlDesc  //知识库细项描述
	Set objExp.EKBXCode                 = ID           //知识库外部码
	Set sc=objExp.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ExpressDr=-1
	}Else{
		Set ExpressDr=objExp.%Id()
	}
	Do objExp.%Close()
	
	Quit ExpressDr
}

}
