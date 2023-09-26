/// 名称: DHCCPW.MR.FORM.ItemImplSrv
/// 描述: 表单项目执行相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-30
Class DHCCPW.MR.FORM.ItemImplSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-07-07
/// Description:  取表单项目关联医嘱列表
///               如果是医嘱套,就转换为医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       ItemID : 项目ID
///               TypeFlg ：类型（Impl：项目执行医嘱）
///               EpisodeID ：就诊号
/// Return：      返回%List
/// w ##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem("79||1||1||11")
ClassMethod GetArcimByItem(aItemID As %String, aTypeFlg As %String = "", aEpisodeID As %String = "") As %List
{
	New (aItemID,aTypeFlg,aEpisodeID)
	Set return=""
	Quit:(aItemID="") return
	
	Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(aItemID)
	Quit:'$IsObject(objItem) return
	
	For indGene=1:1:objItem.ChildItmGene.Count() {
		Set objGene=objItem.ChildItmGene.GetAt(indGene)
		Continue:'$IsObject(objGene)
		If aTypeFlg="Impl" {
			Continue:objGene.IGIsMain'="Y"
		}
		
		For indArc=1:1:objGene.IGArcimList.Count() {
			Set objArcim=objGene.IGArcimList.GetAt(indArc)
			Continue:'$IsObject(objArcim)
			Set ArcimID=objArcim.ITMARCIMDR
			Continue:ArcimID=""
			If $l(ArcimID,"||")=2 {
				Continue:$listfind(return,ArcimID)>0
				Set return=return_$lb(ArcimID)
			} Else {
				Set ARCOSID=ArcimID
				Set ARCOSDateID=##class(DHCCPW.IO.FromHisSrv).GetOrderSetDate(ARCOSID)
				Continue:ARCOSDateID=""
				Set xITMSub=0
				For {
					Set xITMSub=$o(^ARCOS(ARCOSID,"DATE",ARCOSDateID,"ITM",xITMSub))
					Quit:xITMSub=""
					
					Set tmpARCOS=^(xITMSub)
					Set ArcimID=$p(tmpARCOS,"^",1)
					Continue:ArcimID=""
					Continue:$listfind(return,ArcimID)>0
					Set return=return_$lb(ArcimID)
				}
				
				//下面是调出医嘱套里的医嘱套,属于嵌套调用
				Set xOSSub=0
				For {
					Set xOSSub=$o(^ARCOS(ARCOSID,"DATE",ARCOSDateID,"OS",xOSSub))
					Quit:xOSSub=""
					
					Set tmpARCOS=^(xOSSub)
					Set ARCOSID=+tmpARCOS
					Set ARCOSDateID=##class(DHCCPW.IO.FromHisSrv).GetOrderSetDate(ARCOSID)
					Continue:ARCOSDateID=""
					
					Set xITMSub=0
					For {
						Set xITMSub=$o(^ARCOS(ARCOSID,"DATE",ARCOSDateID,"ITM",xITMSub))
						Quit:xITMSub=""
						Set tmpARCOS=^(xITMSub)
						Set ArcimID=$p(tmpARCOS,"^",1)
						Continue:ArcimID=""
						Continue:$listfind(return,ArcimID)>0
						Set return=return_$lb(ArcimID)
					}
				}
			}
			
		}
	}
	
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-30
/// Description:	检查项目执行记录
/// Table:        	User.DHCMRClinicalPathWayImpl
/// Input:        	PathWayID ：出入径ID
///                 ItemID ：项目ID
/// Return:       	return=0：未执行     return=1：执行
/// w ##class(DHCCPW.MR.FORM.ItemImplSrv).CheckImplement("6","79||1||1||1","79||1||1","2014-01-01","2016-01-01")
ClassMethod CheckImplement(aPathWayID As %String, aItemID As %String, aStepID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPathWayID,aItemID,aStepID,aFromDate,aToDate)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="")||(aStepID="")||(aFromDate="")||(aToDate="") return
	
	Set xImplSub=""
	For {
		Set xImplSub=$o(^DHCMRi(0,"IMPL","IndexStepItemNew",aPathWayID,aStepID,aItemID,xImplSub))
		Quit:xImplSub=""
		Quit:return>0
		
		Set ImplID=aPathWayID_"||"_xImplSub
		Set objImpl=##class(User.DHCMRClinicalPathWayImpl).GetObjById(ImplID)
		Continue:'$IsObject(objImpl)
		Set IsActive=objImpl.CPWEActive
		Continue:IsActive'["Y"
		Set OEItemID=objImpl.CPWEOEORIDR
		If OEItemID'="" {
			Set CPWOrderID=$o(^DHCMRi("Order","IndexOEItem"," "_aPathWayID," "_OEItemID,0))
			Continue:CPWOrderID=""
			Set objCPWOrder=##class(User.DHCMRClinicalPathWayOrder).GetObjById(CPWOrderID)
			Continue:'$IsObject(objCPWOrder)
			Continue:objCPWOrder.CPWOIsActive'=1
		}
		Set return=1
	}
	Quit:return=1 return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set objItem=##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(aItemID)
	Quit:'$IsObject(objItem) return
	Set objSubCat=objItem.CPWSISubCategory
	Quit:'$IsObject(objSubCat) return
	Set SubCatDesc=objSubCat.SISCDesc
	Quit:SubCatDesc="" return
	Set SubCatPower=objSubCat.SISCPower
	
	//检查医嘱执行记录
	If (SubCatPower="OE")||(SubCatPower="NE") {
		Set return=..CheckOrderImpl(aPathWayID,aItemID,aFromDate,aToDate)
	}
	
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	检查医嘱执行记录
/// Table:        	User.DHCMRCClinPathWaysEpStepItem,User.DHCMRClinicalPathWayOrder
/// Input:        	PathWayID ：出入径ID
///                 ItemID ：项目ID
///                 FromDate ：开始日期
///                 ToDate ：结束日期
/// Return:       	return=0：未执行     return=1：执行
/// w ##class(DHCCPW.MR.FORM.ItemImplSrv).CheckOrderImpl("21","79||1||1||7","2014-01-01","2016-01-01")
ClassMethod CheckOrderImpl(aPathWayID As %String, aItemID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPathWayID,aItemID,aFromDate,aToDate)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="")||(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	Set ArcimList=##class(DHCCPW.MR.FORM.ItemImplSrv).GetArcimByItem(aItemID)
	Quit:ArcimList="" return
	For indArc=1:1:$listlength(ArcimList) {
		Quit:return=1
		Set ArcimID=$list(ArcimList,indArc)
		Continue:ArcimID=""
		
		Set PHCGeneDesc=""
		Set PHCGeneID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",20)  //通用名
		Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
		Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)    //医嘱名称
		
		Set xDays=0
		For {
			Set xDays=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,PHCGeneDesc,1,xDays))
			Quit:xDays=""
			Quit:return=1
			
			Set xDate=aFromDate-xDays
			For {
				Set xDate=$o(^DHCMRi("Order","IndexGeneric",aPathWayID,PHCGeneDesc,1,xDays,xDate))
				Quit:xDate=""
				Quit:xDate>aToDate
				
				Set return=1
				Quit
			}
		}
	}
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-30
/// Description:	检查诊疗/护理执行记录
/// Table:        	User.DHCMRCClinPathWaysItmImpl
/// Input:        	PathWayID ：出入径ID
///                 ItemID ：项目ID
///                 FromDate ：开始日期
///                 ToDate ：结束日期
/// Return:       	return=0：未执行     return=1：执行
/// Others:			w ##class(DHCCPW.MR.FORM.ItemImplSrv).CheckDiagnosImpl("","","","")
ClassMethod CheckDiagnosImpl(aPathWayID As %String, aItemID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPathWayID,aItemID,aFromDate,aToDate)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="")||(aFromDate="")||(aToDate="") return
	
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	检查诊疗执行记录
/// Table:        	User.DHCMRClinicalPathWayOrder
/// Input:        	PathWayID ：出入径ID
///                 ItemID ：项目ID
///                 FromDate ：开始日期
///                 ToDate ：结束日期
/// Return:       	return=0：未执行     return=1：执行
/// Others:			w ##class(DHCCPW.MR.FORM.ItemImplSrv).CheckNurseImpl("","","","")
ClassMethod CheckNurseImpl(aPathWayID As %String, aItemID As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPathWayID,aItemID,aFromDate,aToDate)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="")||(aFromDate="")||(aToDate="") return
	
	Quit return
}

}
