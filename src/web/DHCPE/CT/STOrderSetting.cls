Import SQLUser

/// 名称: web.DHCPE.CT.STOrderSetting
/// 描述: 站点医嘱项设置
/// 编写者：zhufei
/// 编写日期: 2021-12-07
Class web.DHCPE.CT.STOrderSetting Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2021-12-14
/// Description:   检查站点医嘱项是否有效
/// Input：        aLocID：科室ID
///                aItmMastDR: 医嘱项ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).CheckSTOrder()
ClassMethod CheckSTOrder(aLocID As %String, aItmMastDR As %String) As %String
{
	New (aLocID,aItmMastDR)
	Set return=0
	Quit:(aLocID="")||(aItmMastDR="") return
	
	Set OrderDR=""
	Set xSTID=""
	For {
		Set xSTID=$o(^DHCPEST(0,"STORD_ARCIM",aItmMastDR,xSTID))
		Quit:xSTID=""
		
		Set xOrdSub=""
		For {
			Set xOrdSub=$o(^DHCPEST(0,"STORD_ARCIM",aItmMastDR,xSTID,xOrdSub))
			Quit:xOrdSub=""
			
			Continue:##class(User.DHCPEStationOrder).GetLocShowDataFlag(xSTID_"||"_xOrdSub,aLocID)'="Y"
			Set OrderDR=xSTID_"||"_xOrdSub
		}
	}
	If OrderDR'="" {
		Set return="-1^已存在站点项目组合信息"
		Set xODRID=0
		For {
			Set xODRID=$o(^DHCPEODR(0,"OrderID",OrderDR,xODRID))
			Quit:xODRID=""
			
			Continue:##class(User.DHCPEOrderDetailRelate).GetLocShowDataFlag(xODRID,aLocID)'="Y"
			Set return="-1.1^已存在对应大项项组合信息"
			Quit
		}
	}
	Quit:(+return)<0 return
	
	Set return=1
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-12-09
/// Description:   生成站点项目
/// Input：        aID：记录ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).NewStationOrder(10,1)
ClassMethod NewStationOrder(aID As %String, aUpdateUser As %String) As %String
{
	New (aID,aUpdateUser)
	Set return=-1
	Quit:(aID="") return
	
	Set $ZT="NewStationOrderErr"
	
	Set obj=##class(User.DHCPESTOrderSetting).GetObjById(aID)
	Quit:'$IsObject(obj) return
	Quit:obj.STOSActive'="Y" "-100^站点医嘱项设置无效"
	Quit:obj.STOSNewOrdFlag="Y" "-101^已生成站点项目"
	
	Quit:obj.STOSItmMastDR="" return
	Quit:obj.STOSLocDR="" return
	Quit:'$IsObject(obj.STOSStationDR) return
	Quit:obj.STOSReportFormat="" return
	Quit:'$IsObject(obj.STOSUsherItemCatDR) return
	
	Set StationID=obj.STOSStationDR.%Id()
	Set ItmMastDR=obj.STOSItmMastDR
	Set LocDR=obj.STOSLocDR
	Set ReportFormat=obj.STOSReportFormat
	Set UsherItemCatDR=obj.STOSUsherItemCatDR.%Id()
	Set OrderType=obj.STOSOrderType
	Set ItemCode=obj.STOSItemCode
	Set ItemDesc=obj.STOSItemDesc
	
	Set flg=..CheckSTOrder(LocDR,ItmMastDR)
	Quit:(+flg)<0 "-102^已站点项目组合信息"
	
	Set StationType=##class(web.DHCPE.CT.HISUICommon).GetStationTypeByID(StationID,LocDR)
	If (StationType="LIS")||(StationType="RIS"){
		//检查、检验：自动生成站点大项、站点细项、以及大项细项组合
		
		//参数：站点ID^ ^医嘱项ID^Y^^科室ID^用户ID^N^报告格式ID^导诊单类别ID
		Set InputStr=StationID_"^^"_ItmMastDR_"^Y^^"_LocDR_"^"_aUpdateUser_"^N^"_ReportFormat_"^"_UsherItemCatDR
		Set return=##class(web.DHCPE.CT.StationOrder).Insert(InputStr)
	} Else {
		If (OrderType="R")||(OrderType="M") {
			//药品、耗材：只生成站点大项
			
			//参数：站点ID^ ^医嘱项ID^Y^^科室ID^用户ID^N^报告格式ID^导诊单类别ID
			Set InputStr=StationID_"^^"_ItmMastDR_"^Y^^"_LocDR_"^"_aUpdateUser_"^N^"_ReportFormat_"^"_UsherItemCatDR
			Set return=##class(web.DHCPE.CT.StationOrder).Insert(InputStr)
		} Else {
			//常规检查项目、手工录入项目、外送项目
			Quit:ItemCode="" "-103^常规检查项目必须关联标准项目"
			
			//参数：站点ID^ ^医嘱项ID^Y^^科室ID^用户ID^N^报告格式ID^导诊单类别ID
			Set InputStr=StationID_"^^"_ItmMastDR_"^Y^^"_LocDR_"^"_aUpdateUser_"^N^"_ReportFormat_"^"_UsherItemCatDR
			Set return=##class(web.DHCPE.CT.StationOrder).Insert(InputStr)
			If (+return)>-1 {
				//同步生成细项、细项选择、大项细项组合
				Set OrderDR=""
				Set xSTID=""
				For {
					Set xSTID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,xSTID))
					Quit:xSTID=""
					
					Set xOrdSub=""
					For {
						Set xOrdSub=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,xSTID,xOrdSub))
						Quit:xOrdSub=""
						
						Continue:##class(User.DHCPEStationOrder).GetLocShowDataFlag(xSTID_"||"_xOrdSub,LocDR)'="Y"
						Set OrderDR=xSTID_"||"_xOrdSub
					}
				}
				Set return=##class(web.DHCPE.KBA.SynchroService).SynchroOrdDtlByItemCode(OrderDR,ItemCode,LocDR,aUpdateUser)
			}
		}
	}
	If (+return)>-1 {
		//更新生成标记
		Set InputStr=aID_"^"_"Y"_"^"_aUpdateUser
		Set flg=##class(User.DHCPESTOrderSetting).UpdateNewOrdFlag(InputStr)
	}
	Quit return
	
NewStationOrderErr
	Set $ZT=""
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-12-09
/// Description:   批量生成站点项目
/// Input：        aLocID：科室ID
///                aStationID: 站点ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).BatchNewStationOrder(152,"",1)
ClassMethod BatchNewStationOrder(aLocID As %String, aStationID As %String, aUpdateUser As %String) As %String
{
	New (aLocID,aStationID,aUpdateUser)
	Set return=-1,Count=0
	Quit:(aLocID="") return
	
	Set $ZT="BatchNewStationOrderErr"
	
	Set LGLocID=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(aLocID)
	Quit:LGLocID="" return
	
	Set xStationID=0
	For {
		Set xStationID=$o(^User.DHCPESTOrderSettingI("IdxOfStationDR",xStationID))
		Quit:xStationID=""
		Continue:(aStationID'="")&(aStationID'=xStationID)
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPESTOrderSettingI("IdxOfStationDR",xStationID,xID))
			Quit:xID=""
			
			Continue:##class(User.DHCPESTOrderSetting).GetLocShowDataFlag(xID,LGLocID)'="Y"
			Set flg=..NewStationOrder(xID,aUpdateUser)
			If (+flg)>0 {
				Set Count=Count+1
			}
		}
	}
	Set return=Count
	Quit return
	
BatchNewStationOrderErr
	Set $ZT=""
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-12-08
/// Description:   编辑站点医嘱项记录
/// Input：        aId：记录ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).EditSTOrder("4^X^^^Y^12187^RF_RIS^37")
ClassMethod EditSTOrder(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set $ZT="EditSTOrderErr"
	
	Set ID            = $p(aInputStr,aDelimiter,1)  //医嘱项ID
	Set OrderType     = $p(aInputStr,aDelimiter,2)  //医嘱类型
	Set ItemCode      = $p(aInputStr,aDelimiter,3)  //标准项目代码
	Set ItemDesc      = $p(aInputStr,aDelimiter,4)  //标准项目名称
	Set Active        = $p(aInputStr,aDelimiter,5)  //是否有效
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,6)  //更新人
	Set ReportFormat  = $p(aInputStr,aDelimiter,7)  //报告格式
	Set UsherItemCatDR= $p(aInputStr,aDelimiter,8)  //导诊单类别
	Quit:(ID="")||(OrderType="")||(ReportFormat="")||(UsherItemCatDR="") return
	
	Set obj=##class(User.DHCPESTOrderSetting).GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.STOSNewOrdFlag="Y" -101 //生成完数据不允许再修改
	Set ItmMastDR  = obj.STOSItmMastDR
	Set LocDR      = obj.STOSLocDR
	Set ItmCatDR   = obj.STOSItmCatDR
	Set StationDR  = obj.STOSStationDR.%Id()
	
	Set InputStr=""
	Set $p(InputStr,aDelimiter,1)  = ID             //ID
	Set $p(InputStr,aDelimiter,2)  = ItmMastDR      //医嘱项ID
	Set $p(InputStr,aDelimiter,3)  = LocDR          //科室ID
	Set $p(InputStr,aDelimiter,4)  = ItmCatDR       //医嘱子类ID
	Set $p(InputStr,aDelimiter,5)  = OrderType      //医嘱类型
	Set $p(InputStr,aDelimiter,6)  = StationDR      //站点ID
	Set $p(InputStr,aDelimiter,7)  = ItemCode       //标准项目代码
	Set $p(InputStr,aDelimiter,8)  = ItemDesc       //标准项目描述
	Set $p(InputStr,aDelimiter,9)  = Active         //是否有效
	Set $p(InputStr,aDelimiter,10) = UpdateUserDR   //更新人
	Set $p(InputStr,aDelimiter,11) = ReportFormat   //报告格式
	Set $p(InputStr,aDelimiter,12) = UsherItemCatDR //导诊单类别
	Set return=##class(User.DHCPESTOrderSetting).Update(InputStr,aDelimiter)
	If (+return)>0 {
		Set flg=##class(User.DHCPESTOrderSetting).SaveDataToPowerControl(+return,LocDR,UpdateUserDR,"N")
	}
	Quit return
	
EditSTOrderErr
	Set $ZT=""
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：      xueying
/// CreatDate：    2023-03-07
/// Description:   设置站点医嘱项时勾选的医嘱项的列表的数据
/// Input：        LocID：科室ID，UserID：用户ID，ARCICID：医嘱子类ID，selectIds ：勾选的医嘱项ID
/// Return：       0
/// debug: w ##class(web.DHCPE.CT.STOrderSetting).SetAddSTOrderStr()
ClassMethod SetAddSTOrderStr(LocID As %String = "", UserID As %String = "", ARCICID As %String = "", selectIds As %String = "") As %String
{
	//s ^tempdhcpe("SetAddSTOrderStr")=$lb(LocID,ARCICID,UserID,selectIds)
	q:(ARCICID="")||(LocID="")||(UserID="") 0
	i selectIds="" d 
	.k ^DHCPEDataEx("AddSTOrder","SelectIds",LocID,ARCICID)
	.k ^DHCPEDataEx("AddSTOrder","SelectIdsUser",LocID,ARCICID)
	e  d
	.s ^DHCPEDataEx("AddSTOrder","SelectIds",LocID,ARCICID)=selectIds
	.s ^DHCPEDataEx("AddSTOrder","SelectIdsUser",LocID,ARCICID)=UserID_"^"_$h
	q 0
}

/// Creator：      xueying
/// CreatDate：    2023-03-07
/// Description:   设置站点医嘱项时获取勾选的医嘱项的列表数据
/// Input：        LocID：科室ID，ARCICID：医嘱子类ID
/// Return：       0/勾选的医嘱项串
/// debug: w ##class(web.DHCPE.CT.STOrderSetting).GetAddSTOrderStr()
ClassMethod GetAddSTOrderStr(LocID As %String = "", ARCICID As %String = "")
{
	q:(ARCICID="")||(LocID="") 0
	s selectIds=$g(^DHCPEDataEx("AddSTOrder","SelectIds",LocID,ARCICID))
	q selectIds
}

/// Creator：      zhufei
/// CreatDate：    2021-12-08
/// Description:   设置站点医嘱项记录
/// Input：        aId：记录ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).AddSTOrder("7158||1^152^2^12187^U000020^内科检查^RF_NOR^68")
ClassMethod AddSTOrder(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
	Set $ZT="AddSTOrderErr"
	
	Set ItmMastDR     = $p(aInputStr,aDelimiter,1)  //医嘱项ID
	Set LocDR         = $p(aInputStr,aDelimiter,2)  //科室ID
	Set StationDR     = $p(aInputStr,aDelimiter,3)  //站点ID
	Set UpdateUserDR  = $p(aInputStr,aDelimiter,4)  //更新人
	Set ItemCode      = $p(aInputStr,aDelimiter,5)  //标准项目代码
	Set ItemDesc      = $p(aInputStr,aDelimiter,6)  //标准项目描述
	Set ReportFormat  = $p(aInputStr,aDelimiter,7)  //报告格式
	Set UsherItemCatDR= $p(aInputStr,aDelimiter,8)  //导诊单类别
	Quit:(ItmMastDR="")||(LocDR="")||(StationDR="") return
	
	Set LGLocDR=##class(web.DHCPE.CT.LocGrpConfig).GetLGLocIDByLoc(LocDR)
	Set ItmCatDR=$p($g(^ARCIM(+ItmMastDR,+$p(ItmMastDR,"||",2),1)),"^",10)
	Set OrderType=$p($g(^ARC("IC",+ItmCatDR)),"^",7)
	Set StationCode=$p($g(^DHCPEST(StationDR)),"^",1)
	Set StationDesc=$p($g(^DHCPEST(StationDR)),"^",2)
	Set StationXCode=$p($g(^DHCPEST(StationDR)),"^",13)
	
	Set IsMapping=0
	Set StationType=##class(web.DHCPE.CT.HISUICommon).GetStationTypeByID(StationDR,LGLocDR)
	If (StationType="LIS"){
		Set:(OrderType="L") IsMapping=1
	} ElseIf (StationType="RIS"){
		Set:(OrderType="X") IsMapping=1
	} Else {
		If StationXCode'="" {
			If (OrderType="R"){
				Set:StationXCode="U491" IsMapping=1
			} ElseIf (OrderType="M"){
				Set:StationXCode="U499" IsMapping=1
			} Else {
				Set:$e(StationXCode,1,2)="U1" IsMapping=1
				Set:$e(StationXCode,1,2)="U4" IsMapping=1
			}
		} Else {
			Set IsMapping=1
		}
	}
	Quit:IsMapping<1 "-103^添加医嘱项与站点不符"
	
	Set flg=..CheckSTOrder(LGLocDR,ItmMastDR)
	Quit:(+flg)<0 "-102^已站点项目组合信息"
	
	Set ID=$o(^User.DHCPESTOrderSettingI("IdxOfItmMastDR"," "_$zcvt(ItmMastDR,"U")," "_$zcvt(LocDR,"U"),0))
	If ID'="" {
		Set obj=##class(User.DHCPESTOrderSetting).GetObjById(ID)
		If $IsObject(obj){
			Quit:obj.STOSNewOrdFlag="Y" "-101^已生成站点项目记录不允许重复添加"
			Set:ItemCode="" ItemCode=obj.STOSItemCode
			Set:ItemDesc="" ItemDesc=obj.STOSItemDesc
			Set:ReportFormat="" ReportFormat=obj.STOSReportFormat
			If UsherItemCatDR="" {
				If $IsObject(obj.STOSUsherItemCatDR){
					Set UsherItemCatDR=obj.STOSUsherItemCatDR.%Id()
				}
			}
		}
	}
	
	Set InputStr=""
	Set $p(InputStr,aDelimiter,1)  = ID             //ID
	Set $p(InputStr,aDelimiter,2)  = ItmMastDR      //医嘱项ID
	Set $p(InputStr,aDelimiter,3)  = LGLocDR        //科室ID
	Set $p(InputStr,aDelimiter,4)  = ItmCatDR       //医嘱子类ID
	Set $p(InputStr,aDelimiter,5)  = OrderType      //医嘱类型
	Set $p(InputStr,aDelimiter,6)  = StationDR      //站点ID
	Set $p(InputStr,aDelimiter,7)  = ItemCode       //标准项目代码
	Set $p(InputStr,aDelimiter,8)  = ItemDesc       //标准项目描述
	Set $p(InputStr,aDelimiter,9)  = "Y"            //是否有效
	Set $p(InputStr,aDelimiter,10) = UpdateUserDR   //更新人
	Set $p(InputStr,aDelimiter,11) = ReportFormat   //报告格式
	Set $p(InputStr,aDelimiter,12) = UsherItemCatDR //导诊单类别
	Set return=##class(User.DHCPESTOrderSetting).Update(InputStr,aDelimiter)
	If (+return)>0 {
		Set flg=##class(User.DHCPESTOrderSetting).SaveDataToPowerControl(+return,LGLocDR,UpdateUserDR,"N","")
	}
	Quit return
	
AddSTOrderErr
	Set $ZT=""
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：      zhufei
/// CreatDate：    2021-12-08
/// Description:   删除站点医嘱项记录
/// Input：        aId：记录ID
/// Return：       ret>=0:成功、ret<0:失败
/// w ##class(web.DHCPE.CT.STOrderSetting).DeleteSTOrder(7)
ClassMethod DeleteSTOrder(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:(aId="") return
	
	Set $ZT="DeleteSTOrderErr"
	
	Set obj=##class(User.DHCPESTOrderSetting).GetObjById(aId)
	Quit:'$IsObject(obj) return
	Quit:obj.STOSNewOrdFlag="Y" -101 //生成完数据不允许再删除
	
	Set return=##class(User.DHCPESTOrderSetting).DeleteById(aId)
	Quit return
	
DeleteSTOrderErr
	Set $ZT=""
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2021-12-07
/// Description: 站点医嘱项查询
/// Table：      User.DHCPESTOrderSetting
/// Input:       aLocID ：科室ID
///              aStationID ：站点ID
/// Return：     ROWSPEC =
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.STOrderSetting","QrySTOrder",152,9)
Query QrySTOrder(aLocID As %String, aStationID As %String) As websys.Query(ROWSPEC = "ID:%String,ItmMastDR:%String,ItmMastDesc:%String,LocDR:%String,LocDesc:%String,ItmCatDR:%String,ItmCatDesc:%String,OrderType:%String,OrderTypeDesc:%String,StationID:%String,StationDesc:%String,ItemCode:%String,ItemDesc:%String,Active:%String,ActiveDesc:%String,UpdateDate:%String,UpdateTime:%String,UpdateUser:%String,NewOrdFlag:%String,NewOrdFlagDesc:%String,NewOrdDate:%String,NewOrdTime:%String,NewOrdUser:%String,ReportFormat:%String,ReportFormatDesc:%String,UsherItemCatID:%String,UsherItemCatDesc:%String")
{
}

ClassMethod QrySTOrderExecute(ByRef qHandle As %Binary, aLocID As %String, aStationID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aLocID="")||(aStationID="") $$$OK
    Set HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(aLocID)
	Set xID=0
	For {
		Set xID=$o(^User.DHCPESTOrderSettingI("IdxOfStationDR",aStationID,xID))
		Quit:xID=""
		Continue:##class(User.DHCPESTOrderSetting).GetLocShowDataFlag(xID,aLocID)
		
		Set objSTOS=##class(User.DHCPESTOrderSetting).GetObjById(xID)
		Continue:'$IsObject(objSTOS)
		
		Set ItmMastDR     = objSTOS.STOSItmMastDR        // 医嘱项（指向表ARC_ItmMast）
		Set LocDR         = objSTOS.STOSLocDR            // 医嘱科室ID
		Set ItmCatDR      = objSTOS.STOSItmCatDR         // 医嘱子类（指向表ARC_ItemCat）
		Set OrderType     = objSTOS.STOSOrderType        // 医嘱类型（指向表ARC_ItemCat.ARCIC_OrderType）
		Set ItemCode      = objSTOS.STOSItemCode         // 标准项目代码（指向HM.BT.ExamItemCode.EICCode）
		Set ItemDesc      = objSTOS.STOSItemDesc         // 标准项目名称（指向HM.BT.ExamItemCode.EICDesc）
		Set Active        = objSTOS.STOSActive           // 是否有效
		Set UpdateDate    = objSTOS.STOSUpdateDate       // 更新日期
		Set UpdateTime    = objSTOS.STOSUpdateTime       // 更新时间
		Set UpdateUser    = objSTOS.STOSUpdateUserDR     // 更新人 指向SS_User
		Set NewOrdFlag    = objSTOS.STOSNewOrdFlag       // 生成站点项目标记
		Set NewOrdDate    = objSTOS.STOSNewOrdDate       // 生成站点项目日期
		Set NewOrdTime    = objSTOS.STOSNewOrdTime       // 生成站点项目时间
		Set NewOrdUser    = objSTOS.STOSNewOrdUserDR     // 生成站点项目人 指向SS_User
		Set ReportFormat  = objSTOS.STOSReportFormat     // 报告格式
		
		Set (ItmMastDesc,LocDesc,ItmCatDesc)=""
		If ItmMastDR'="" {
			Set ItmMastDesc=$p($g(^ARCIM(+ItmMastDR,+$p(ItmMastDR,"||",2),1)),"^",2)
		}
		If LocDR'="" {
			Set LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
		}
		
		Set HOSPshowFlag=""
		If (aLocID'="")&&(ItmMastDR'="") {
			Set HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ItmMastDR,HospID)
		}
		Continue:HOSPshowFlag="N"
		
		If ItmCatDR'="" {
			Set ItmCatDesc=$p($g(^ARC("IC",ItmCatDR)),"^",2)
		}
		Set (StationID,StationDesc)=""
		If $IsObject(objSTOS.STOSStationDR){
			Set StationID = objSTOS.STOSStationDR.%Id()
			Set StationDesc = objSTOS.STOSStationDR.STDesc
		}
		Set ReportFormatDesc=$s(ReportFormat="RF_CAT":"打印格式 多层",ReportFormat="RF_LIS":"打印格式 检验",ReportFormat="RF_NOR":"打印格式 默认",ReportFormat="RF_RIS":"打印格式 检查",ReportFormat="RF_EKG":"打印格式 心电",ReportFormat="RF_PIS":"打印格式 病理",1:ReportFormat)
		Set (UsherItemCatID,UsherItemCatDesc)=""
		If $IsObject(objSTOS.STOSUsherItemCatDR){
			Set UsherItemCatID=objSTOS.STOSUsherItemCatDR.%Id()
			Set UsherItemCatDesc=objSTOS.STOSUsherItemCatDR.PICategory
		}
		
		Set OrderTypeDesc=$s(OrderType="L":"检验",OrderType="X":"检查",OrderType="R":"药品",OrderType="M":"耗材",OrderType="N":"其他",1:OrderType)
		Set ActiveDesc=$s(Active="Y":"是",Active="N":"否",1:Active)
		Set:UpdateDate'="" UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
		Set:UpdateTime'="" UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
		Set:UpdateUser'="" UpdateUser=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
		Set NewOrdFlagDesc=$s(NewOrdFlag="Y":"是",NewOrdFlag="N":"否",1:NewOrdFlag)
		Set:NewOrdDate'="" NewOrdDate=##class(websys.Conversions).DateLogicalToHtml(NewOrdDate)
		Set:NewOrdTime'="" NewOrdTime=##class(websys.Conversions).TimeLogicalToHtml(NewOrdTime)
		Set:NewOrdUser'="" NewOrdUser=$p($g(^SSU("SSUSR",NewOrdUser)),"^",2)
		
		;d TranslateQrySTOrder
		Set Data=$lb(xID,ItmMastDR,ItmMastDesc,LocDR,LocDesc,ItmCatDR,ItmCatDesc,OrderType,OrderTypeDesc,StationID,StationDesc,ItemCode,ItemDesc,Active,ActiveDesc,UpdateDate,UpdateTime,UpdateUser,NewOrdFlag,NewOrdFlagDesc,NewOrdDate,NewOrdTime,NewOrdUser,ReportFormat,ReportFormatDesc,UsherItemCatID,UsherItemCatDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    Quit $$$OK
TranslateQrySTOrder
	s ItemDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCode",ItemDesc,"EICDesc","cls")
	s ItmCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItemCat",ItmCatDesc,"ARCICDesc","cls")
	s ItmMastDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ItmMastDesc,"ARCIMDesc","cls")
	s LocDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTLoc",LocDesc,"CTLOCDesc","cls")
	s StationDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStation",StationDesc,"STDesc","cls")
	s UpdateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUser,"SSUSRName","cls")
	s UsherItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEUsherItemCat",UsherItemCatDesc,"PICategory","cls")
	
	s ActiveDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",ActiveDesc)
	s NewOrdFlagDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",NewOrdFlagDesc)
	s ReportFormatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",ReportFormatDesc)
	s OrderTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",OrderTypeDesc)
}

/// Creator：    zhufei
/// CreatDate：  2021-12-07
/// Description: 医嘱项列表查询
/// Table：      User.DHCPESTOrderSetting
/// Input:       aLocID ：科室ID
///              aARCICID ：医嘱项子类ID
/// Return：     ROWSPEC =
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.STOrderSetting","QryARCIM",152,1)
Query QryARCIM(aLocID As %String, aARCICID As %String) As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ItmCatDR:%String,ItmCatDesc:%String,OrderType:%String,OrderTypeDesc:%String,OrdCatDR:%String,OrdCatDesc:%String")
{
}

ClassMethod QryARCIMExecute(ByRef qHandle As %Binary, aLocID As %String, aARCICID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aLocID="")||(aARCICID="") $$$OK
    Set HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(aLocID)
    
    Set xSub=0
    For {
	    Set xSub=$o(^ARCIM(0,"ARCIC_DR",aARCICID,xSub))
	    Quit:xSub=""
	    
	    Set xVer=0
	    For {
		    Set xVer=$o(^ARCIM(0,"ARCIC_DR",aARCICID,xSub,xVer))
		    Quit:xVer=""
		    
		    Set ID=xSub_"||"_xVer
		    Set EffDate=$p($g(^ARCIM(xSub,xVer,7)),"^",1) 
            if EffDate="" Set EffDate=+$H+1
            Continue:EffDate<+$H                       //过滤停止的医嘱项
		    Continue:##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ID,HospID)'="Y"
		    
	    	Set Code=$p($g(^ARCIM(xSub,xVer,1)),"^",1)
	    	Set Desc=$p($g(^ARCIM(xSub,xVer,1)),"^",2)
	    	Set ItmCatDR=$p($g(^ARCIM(xSub,xVer,1)),"^",10)
	    	Set ItmCatDesc=$p($g(^ARC("IC",+ItmCatDR)),"^",2)
	    	Set OrderType=$p($g(^ARC("IC",+ItmCatDR)),"^",7)
	    	Set OrdCatDR=$p($g(^ARC("IC",+ItmCatDR)),"^",8)
	    	Set OrdCatDesc=$p($g(^OEC("ORCAT",+OrdCatDR)),"^",2)
	    	
	    	Set:(OrderType'="L")&&(OrderType'="X")&&(OrderType'="R")&&(OrderType'="M")&&(OrderType'="N") OrderType="N"
	    	Set OrderTypeDesc=$s(OrderType="L":"检验",OrderType="X":"检查",OrderType="R":"药品",OrderType="M":"耗材",OrderType="N":"其他",1:"其他")
	    	
	    	/*
	    	//检验、检查、药品、耗材不检查医嘱科室和接收科室
	    	If (OrderType'="L")&&(OrderType'="X")&&(OrderType'="R")&&(OrderType'="M"){
		    	Set CheckHospFlag=0
		    	//ARC_ItemMast对应表ARC_ItmRecLoc
		    	Set xSub=0
		    	For {
			    	Set xSub=$o(^ARCRL(+ID,xSub))
			    	Quit:xSub=""
			    	Quit:CheckHospFlag=1
			    	
			    	Set OrdLocDr=$p($g(^ARCRL(+ID,xSub)),"^",1)
			    	Set RecLocDr=$p($g(^ARCRL(+ID,xSub)),"^",2)
			    	If (aLocID=OrdLocDr)||(LGLocID=OrdLocDr)||(aLocID=RecLocDr)||(LGLocID=RecLocDr){
					    Set CheckHospFlag=1
			    	}
			    }
		    	//ARC_ItemCat子表ARC_ItemCatRecLoc
			    If CheckHospFlag=0 {
			    	Set xSub=0
			    	For {
				    	Set xSub=$o(^ARC("IC",+ItmCatDR,"RL",xSub))
				    	Quit:xSub=""
				    	Quit:CheckHospFlag=1
				    	
				    	Set OrdLocDr=$p($g(^ARC("IC",+ItmCatDR,"RL",xSub)),"^",2)
				    	Set RecLocDr=$p($g(^ARC("IC",+ItmCatDR,"RL",xSub)),"^",3)
				    	If (aLocID=OrdLocDr)||(LGLocID=OrdLocDr)||(aLocID=RecLocDr)||(LGLocID=RecLocDr){
						    Set CheckHospFlag=1
				    	}
				    }
			    }
			    //OEC_OrderCategory子表OEC_OrdCatRecLoc
			    If CheckHospFlag=0 {
			    	Set xSub=0
			    	For {
				    	Set xSub=$o(^OEC("ORCAT",+OrdCatDR,"RL",xSub))
				    	Quit:xSub=""
				    	Quit:CheckHospFlag=1
				    	
				    	Set OrdLocDr=$p($g(^OEC("ORCAT",+OrdCatDR,"RL",xSub)),"^",2)
				    	Set RecLocDr=$p($g(^OEC("ORCAT",+OrdCatDR,"RL",xSub)),"^",3)
				    	If (aLocID=OrdLocDr)||(LGLocID=OrdLocDr)||(aLocID=RecLocDr)||(LGLocID=RecLocDr){
						    Set CheckHospFlag=1
				    	}
				    }
			    }
			    Continue:CheckHospFlag'=1
	    	}
	    	*/
	    	;d TranslateQryARCIM
			Set Data=$lb(ID,Code,Desc,ItmCatDR,ItmCatDesc,OrderType,OrderTypeDesc,OrdCatDR,OrdCatDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
    Quit $$$OK
TranslateQryARCIM
	s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",Desc,"ARCIMDesc","cls")
	s ItmCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItemCat",ItmCatDesc,"ARCICDesc","cls")
	s OrdCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.OECOrderCategory",OrdCatDesc,"ORCATDesc","cls")
	s OrderTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",OrderTypeDesc)
}

/// Creator：    zhufei
/// CreatDate：  2021-12-07
/// Description: 医嘱子类下拉框查询
/// Table：      ARC_ItemCat
/// Input:       aLocID ：科室ID
///              aAlias ：别名
/// Return：     ROWSPEC =
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.STOrderSetting","QryARCIC",152,"")
Query QryARCIC(aLocID As %String, aAlias As %String) As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,OrderType:%String,OrderTypeDesc:%String,OrdCatDR:%String,OrdCatDesc:%String")
{
}

ClassMethod QryARCICExecute(ByRef qHandle As %Binary, aLocID As %String, aAlias As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aLocID="") $$$OK
    Set LGLocID=$o(^CF.PE.LocGrpConfigI("IdxOfLoc"," "_aLocID,0))
    Set HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(aLocID)
    
    Set xID=0
    For {
    	Set xID=$o(^ARC("IC",xID))
    	Quit:xID=""
    	
    	Continue:##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItemCat",xID,HospID)'="Y"
    	
    	Set Code=$p($g(^ARC("IC",xID)),"^",1)
    	Set Desc=$p($g(^ARC("IC",xID)),"^",2)
    	Set OrderType=$p($g(^ARC("IC",xID)),"^",7)
    	Set OrdCatDR=$p($g(^ARC("IC",xID)),"^",8)
    	Set OrdCatDesc=$p($g(^OEC("ORCAT",+OrdCatDR)),"^",2)
    	Continue:(aAlias'="")&($zcvt(Desc,"U")'[$zcvt(aAlias,"U"))
    	
		Set OrderTypeDesc=$s(OrderType="L":"检验",OrderType="X":"检查",OrderType="R":"药品",OrderType="M":"耗材",OrderType="N":"其他",1:OrderType)
    	/*
    	//检验、检查、药品、耗材不检查医嘱科室和接收科室
    	If (OrderType'="L")&&(OrderType'="X")&&(OrderType'="R")&&(OrderType'="M"){
	    	Set CheckHospFlag=0
	    	//ARC_ItemCat子表ARC_ItmRecLoc
	    	Set xSub=0
	    	For {
		    	Set xSub=$o(^ARC("IC",xID,"RL",xSub))
		    	Quit:xSub=""
		    	Quit:CheckHospFlag=1
		    	
		    	Set OrdLocDr=$p($g(^ARC("IC",xID,"RL",xSub)),"^",2)
		    	Set RecLocDr=$p($g(^ARC("IC",xID,"RL",xSub)),"^",3)
		    	If (aLocID=OrdLocDr)||(LGLocID=OrdLocDr)||(aLocID=RecLocDr)||(LGLocID=RecLocDr){
				    Set CheckHospFlag=1
		    	}
		    }
		    If CheckHospFlag=0 {
		    	//OEC_OrderCategory子表OEC_OrdCatRecLoc
		    	Set xSub=0
		    	For {
			    	Set xSub=$o(^OEC("ORCAT",+OrdCatDR,"RL",xSub))
			    	Quit:xSub=""
			    	Quit:CheckHospFlag=1
			    	
			    	Set OrdLocDr=$p($g(^OEC("ORCAT",+OrdCatDR,"RL",xSub)),"^",2)
			    	Set RecLocDr=$p($g(^OEC("ORCAT",+OrdCatDR,"RL",xSub)),"^",3)
			    	If (aLocID=OrdLocDr)||(LGLocID=OrdLocDr)||(aLocID=RecLocDr)||(LGLocID=RecLocDr){
					    Set CheckHospFlag=1
			    	}
			    }
		    }
		    Continue:CheckHospFlag'=1
    	}
    	*/
	    ;d TranslateQryARCIC
		Set Data=$lb(xID,Code,Desc,OrderType,OrderTypeDesc,OrdCatDR,OrdCatDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
    Quit $$$OK
TranslateQryARCIC
	s Code=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItemCat",Code,"ARCICCode","cls")
	s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItemCat",Desc,"ARCICDesc","cls")
	s OrderTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.ct.stordersetting.csp",OrderTypeDesc)
	s OrdCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.OECOrderCategory",OrdCatDesc,"ORCATDesc","cls")
}

/// Creator：    zhufei
/// CreatDate：  2021-12-07
/// Description: 查询标准体检项目列表
/// Table：      HM.BT.ExamItemCode
/// Input:       无
/// Return：     ROWSPEC =
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.STOrderSetting","QryExamItemCode")
Query QryExamItemCode() As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ItemCatCode:%String,ItemCatDesc:%String,Sort:%String")
{
}

ClassMethod QryExamItemCodeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
    
	Set arrItemCode=##class(HMS.IO.ToPESrv).GetItemCodeArray()
	Quit:arrItemCode.Count()<1 return
	Set Cnt=arrItemCode.Count()
	For idxItemCode=1:1:Cnt {
		Set objItemCode=arrItemCode.GetAt(idxItemCode)
		Continue:'$IsObject(objItemCode)
		
		Set ID           = objItemCode.GetAt("ID")            //ID
		Set Code         = objItemCode.GetAt("Code")          //内部编码
		Set Desc         = objItemCode.GetAt("Desc")          //项目名称
		Set ItemCatCode  = objItemCode.GetAt("ItemCatCode")   //站点项目分类代码
		Set ItemCatDesc  = objItemCode.GetAt("ItemCatDesc")   //站点项目分类名称
		Set Sort         = objItemCode.GetAt("Sort")          //顺序号
		
		;d TranslateQryExamItemCode
		Set Data=$lb(ID,Code,Desc,ItemCatCode,ItemCatDesc,Sort)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    Quit $$$OK
TranslateQryExamItemCode
	s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCode",Desc,"EICDesc","cls")
	s ItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("HM.BT.ExamItemCat",ItemCatDesc,"EICDesc","cls")
}

}
