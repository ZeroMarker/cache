/// 名称: DHCHAI.STATV2.AbstractComm
/// 描述: 统计类的抽象父类
/// 编写者：zhufei
/// 编写日期: 2019-10-18
Class DHCHAI.STATV2.AbstractComm Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符
Parameter SEPARATE = "^";

/// Creator：     zhufei
/// CreatDate：   2019-10-18
/// Description:  获取统计维度信息(取全部统计维护)
/// Table：       无
/// Input：       aStatDimens: 统计维度
///               aHospDr    : 医院ID
///               aGroupDr   : 科室组ID
///               aLocDr     : 科室ID
///               aWardDr    : 病区ID
///               aADMFlag   : 就诊标记（O门诊、I住院、E急诊）
///               aICUFlag   : ICU标记（1 ICU科室）
///               aNICUFlag  : NICU标记（1 NICU科室）
///               aOprFlag   : 外科标记（1 手术科室）
/// Return：      返回String
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetArrayStatDimens("AHGE","","","","","I","","","")
ClassMethod GetArrayStatDimens(aStatDimens As %String, aHospDr As %String = "", aGroupDr As %String = "", aLocDr As %String = "", aWardDr As %String = "", aADMFlag As %String = "", aICUFlag As %String = "", aNICUFlag As %String = "", aOPERFlag As %String = "") As %String
{
	New (aStatDimens,aHospDr,aGroupDr,aLocDr,aWardDr,aADMFlag,aICUFlag,aNICUFlag,aOPERFlag)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:aStatDimens="" return
	
	Set aHospDr=$tr(aHospDr,",","|")
	Set HospFlag=$l(aHospDr,"|")
	Set:aHospDr'="" aHospDr="|"_aHospDr_"|"
	Set aGroupDr=$tr(aGroupDr,",","|")
	Set:aGroupDr'="" aGroupDr="|"_aGroupDr_"|"
	Set aLocDr=$tr(aLocDr,",","|")
	Set:aLocDr'="" aLocDr="|"_aLocDr_"|"
	Set aWardDr=$tr(aWardDr,",","|")
	Set:aWardDr'="" aWardDr="|"_aWardDr_"|"
	Set aADMFlag=$tr(aADMFlag,",","|")
	Set:aADMFlag'="" aADMFlag="|"_aADMFlag_"|"
	
	Kill arrHospital
	Kill arrLocGroup
	Kill arrLocation
	
	//获取医院信息及排序
	Set HospGrpList=""
	Set xHospGrpID=0,HospIdx=0
	For {
		Set xHospGrpID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",xHospGrpID))
		Quit:xHospGrpID=""
		
		Set xHospID=0
		For {
			Set xHospID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",xHospGrpID,xHospID))
			Quit:xHospID=""
			Continue:(aHospDr'="")&&(aHospDr'[("|"_xHospID_"|"))
			
			Set HospData=$g(^DHCHAI.BT.HospitalD(xHospID))
			Continue:HospData=""
			Set IsActive=$lg(HospData,7)
			Continue:IsActive=""
			Set HospDesc=$lg(HospData,3)
			Set HospDesc2=$lg(HospData,4)
			Set:HospDesc2'="" HospDesc=HospDesc2
			If ((","_HospGrpList_",")'[(","_xHospGrpID_",")){
				Set HospGrpList=HospGrpList_","_xHospGrpID
			}
			Set HospIdx=HospIdx+1
			Set arrHospital("HospID",xHospID)=$lb(xHospID,HospDesc,HospIdx)
			Set arrHospital("HospIdx",HospIdx)=$lb(xHospID,HospDesc,HospIdx)
		}
	}
	Set:HospGrpList'="" HospGrpList=$e(HospGrpList,2,$l(HospGrpList))
	
	//获取科室分组信息及排序
	Set xLocGrpIndNo="",LocGrpIdx=0
	For {
		Set xLocGrpIndNo=$o(^DHCHAI.BT.LocGroupI("IndexIndNoGrpDesc",xLocGrpIndNo))
		Quit:xLocGrpIndNo=""
		
		Set xLocGrpDesc=""
		For {
			Set xLocGrpDesc=$o(^DHCHAI.BT.LocGroupI("IndexIndNoGrpDesc",xLocGrpIndNo,xLocGrpDesc))
			Quit:xLocGrpDesc=""
			
			Set xLocGrpID=0
			For {
				Set xLocGrpID=$o(^DHCHAI.BT.LocGroupI("IndexIndNoGrpDesc",xLocGrpIndNo,xLocGrpDesc,xLocGrpID))
				Quit:xLocGrpID=""
				Quit:(aGroupDr'="")&&(aGroupDr'[("|"_xLocGrpID_"|"))
				
				Set LocGrpData=$g(^DHCHAI.BT.LocGroupD(xLocGrpID))
			    Continue:LocGrpData=""
				Set LocGrpDesc=$lg(LocGrpData,3)
				
				Set LocGrpIdx=LocGrpIdx+1
				Set arrLocGroup("LocGrpID",xLocGrpID)=$lb(xLocGrpID,LocGrpDesc,LocGrpIdx)
				Set arrLocGroup("LocGrpIdx",LocGrpIdx)=$lb(xLocGrpID,LocGrpDesc,LocGrpIdx)
			}
		}
	}
	
	//获取科室信息及排序
	Set OthLocGrpDr=""
	Set xGrpID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
	If (xGrpID'=""){
		Set GroupData=$g(^DHCHAI.BT.LocGroupD(xGrpID))
		If (GroupData'=""){
			Set OthLocGrpDr=xGrpID
		}
	}
	Set xLocIndNo="",LocIdx=0
	For {
		Set xLocIndNo=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo))
		Quit:xLocIndNo=""
		
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo,xLocDesc))
			Quit:xLocDesc=""
			
			Set xLocID=0
			For {
				Set xLocID=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo,xLocDesc,xLocID))
				Quit:xLocID=""

				Set LocData=$g(^DHCHAI.BT.LocationD(xLocID))
				Continue:LocData=""
				Set BTHospDr=$lg(LocData,8)
			    Continue:BTHospDr=""
				Set HospID=BTHospDr
				Continue:$g(arrHospital("HospID",HospID))=""
				
				Set LocGrpID=OthLocGrpDr
				Set BTGroupDr=$lg(LocData,7)
				If (BTGroupDr'=""){
					Set LocGrpID=BTGroupDr
				}
				Continue:LocGrpID=""
				Continue:$g(arrLocGroup("LocGrpID",LocGrpID))=""
				//科室分类（执行科室、病房、其他）
				Set LocTypeCode=""
				Set BTTypeDr=$lg(LocData,5)
				If (BTTypeDr'=""){
					Set LocTypeData=$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
					Set LocTypeCode=$lg(LocTypeData,2)
				}
				Continue:(LocTypeCode'="E")&&(LocTypeCode'="W")
				Continue:(aStatDimens["E")&&(LocTypeCode'="E")
				Continue:(aStatDimens["W")&&(LocTypeCode'="W")
				
				//科室就诊类型（门诊、急诊、住院）
				Set LocAdmType=""
				Set BTCateDr=$lg(LocData,6)
				If (BTCateDr'=""){
					Set LocCateData=$g(^DHCHAI.BT.DictionaryD(BTCateDr))
					Set LocAdmType=$lg(LocCateData,2)
				}
				Continue:(aADMFlag'="")&&(aADMFlag'[("|"_LocAdmType_"|"))
				
				Set IsOPER=$lg(LocData,9)   //是否手术科室
				Continue:(aOPERFlag'="")&&(+aOPERFlag>0)&&(+IsOPER<1)
				Set IsICU=$lg(LocData,10)	//是否ICU病房
				Set IsNICU=$lg(LocData,11)	//是否新生儿病房
				Continue:(aICUFlag'="")&&(+aICUFlag>0)&&(+IsICU<1)&&(+IsNICU<1)
				Continue:(aNICUFlag'="")&&(+aNICUFlag>0)&&(+IsNICU<1)
				
				Set LocDesc=$lg(LocData,3)
				Set LocDesc2=$lg(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				Set IsActive=$lg(LocData,14)
				Set:(LocDesc["停用")||(LocDesc["作废") IsActive=0
				
				//关联科室筛查
				If ((LocTypeCode="W")&&(aLocDr'=""))||((LocTypeCode="E")&&(aWardDr'="")){
					Set IsLnkActive=0
					Set xLnkID=0
					For {
						Set xLnkID=$o(^DHCHAI.BT.LocationD(xLocID,"Link",xLnkID))
						Quit:xLnkID=""
						
						Set LnkInfo=$g(^DHCHAI.BT.LocationD(xLocID,"Link",xLnkID))
						Set LnkLocDr=$lg(LnkInfo,2)
						Set LnkIsActive=$lg(LnkInfo,3)
						Continue:LnkIsActive'=1
						If (LocTypeCode="W")&&(aLocDr'="") {
							Continue:(aLocDr'[("|"_LnkLocDr_"|"))
						} ElseIf (LocTypeCode="E")&&(aWardDr'="") {
							Continue:(aWardDr'[("|"_LnkLocDr_"|"))
						}
						Set IsLnkActive=1
						Quit
					}
					Continue:IsLnkActive<1
				}
				Set LocIdx=LocIdx+1
				If (aStatDimens["H")&&(aStatDimens["G"){
					Set arrLocation("LocIdx",HospID,LocGrpID,LocIdx)=$lb(xLocID,LocDesc,IsActive)
				} ElseIf (aStatDimens["H"){
					Set arrLocation("LocIdx",HospID,LocIdx)=$lb(xLocID,LocDesc,LocIdx,IsActive,LocGrpID)  //update 2022-09-16 与GetStatDimensInfo方法取值一致
				} Else {
					Set arrLocation("LocIdx",LocIdx)=$lb(xLocID,LocDesc,LocIdx,IsActive,HospID,LocGrpID)   //update 2022-09-16 与GetStatDimensInfo方法取值一致
				}
			}
		}
	}
	
	Set Count=0,DimenCode=""
	If aStatDimens["A" {  //全院
		Set DimenMark="A"
		Set DimenLevel=$find(aStatDimens,DimenMark)-1
		Set $p(DimenCode,"-",1)="0000"                          //医院ID
		Set $p(DimenCode,"-",2)="00"                            //科室分类ID
		Set $p(DimenCode,"-",3)="0000"                          //科室ID
		Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
		//update 20220906 因报表中取医院分组代码取的节点为5，导致医院分组不是1的全院查询数据有问题
		//Set $p(DimenCode,"-",5)=DimenLevel                      //层级
		If (HospFlag'=1){
			//update 20210707 全院统计维度代码按医院分组区分，防止汇总报表中的“全院”汇总数据与打开的明细报表中数据不一致（明细中包含其他医院组患者）			
			If ($l(HospGrpList,",")>1) {   //多个医院分组
			    For indh=1:1:$l(HospGrpList,",") {
					Set HospGrpDr=$p(HospGrpList,",",indh)
					Set DimensData=$lb(DimenCode_"-"_HospGrpDr,"","全院"_indh,"1")  //统一编码、代码、描述、是否有效
					Set Count=Count+1
					Do return.SetAt(DimensData,Count)
			    }
			
			}Else {
				Set DimensData=$lb(DimenCode_"-"_HospGrpList,"","全院","1")  //统一编码、代码、描述、是否有效
				Set Count=Count+1
				Do return.SetAt(DimensData,Count)
			}
		}
	}
	If (aStatDimens["H") {
		//医院列表
		Set xHospIdx=0
		For {
			Set xHospIdx=$o(arrHospital("HospIdx",xHospIdx))
			Quit:xHospIdx=""
			
			Set HospInfo=$g(arrHospital("HospIdx",xHospIdx))
			Set HospID=$lg(HospInfo,1)
			Set HospDesc=$lg(HospInfo,2)
			Continue:'$d(arrLocation("LocIdx",HospID))
			
			Set DimenMark="H"
			Set DimenLevel=$find(aStatDimens,DimenMark)-1
			Set $p(DimenCode,"-",1)=$e("0000"_HospID,*-3,*)       //医院ID
			Set $p(DimenCode,"-",2)="00"                            //科室分类ID
			Set $p(DimenCode,"-",3)="0000"                          //科室ID
			Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
			Set $p(DimenCode,"-",5)=DimenLevel                      //层级
			
			Set DimensData=$lb(DimenCode,HospID,HospDesc,"1")  //统一编码、代码、描述、是否有效
			Set Count=Count+1
			Do return.SetAt(DimensData,Count)
			
			If (aStatDimens["G") {
				//科室分组列表
				Set xLocGrpIdx=0
				For {
					Set xLocGrpIdx=$o(arrLocGroup("LocGrpIdx",xLocGrpIdx))
					Quit:xLocGrpIdx=""
					
					Set LocGrpInfo=$g(arrLocGroup("LocGrpIdx",xLocGrpIdx))
					Set LocGrpID=$lg(LocGrpInfo,1)
					Set LocGrpDesc=$lg(LocGrpInfo,2)
					Continue:'$d(arrLocation("LocIdx",HospID,LocGrpID))
					Set DimenMark="G"
					Set DimenLevel=$find(aStatDimens,DimenMark)-1
					Set $p(DimenCode,"-",1)=$e("0000"_HospID,*-3,*)       //医院ID
					Set $p(DimenCode,"-",2)=$e("00"_LocGrpID,*-1,*)       //科室分类ID
					Set $p(DimenCode,"-",3)="0000"                          //科室ID
					Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
					Set $p(DimenCode,"-",5)=DimenLevel                      //层级
					
					Set DimensData=$lb(DimenCode,LocGrpID,LocGrpDesc,"1")
					Set Count=Count+1
					Do return.SetAt(DimensData,Count)
				
					If (aStatDimens["E")||(aStatDimens["W") {
						//HGE或HGW科室列表
						Set xLocIdx=0,tLocIdx=0
						For {
							Set xLocIdx=$o(arrLocation("LocIdx",HospID,LocGrpID,xLocIdx))
							Quit:xLocIdx=""
							
							Set LocInfo=$g(arrLocation("LocIdx",HospID,LocGrpID,xLocIdx))
							Set LocID=$lg(LocInfo,1)
							Set LocDesc=$lg(LocInfo,2)
							Set IsActive=$lg(LocInfo,3)							
							Set tLocIdx=tLocIdx+1
							Set:(LocDesc["停用")||(LocDesc["作废") IsActive=0

							Set DimenMark=$s(aStatDimens["E":"E",aStatDimens["W":"W",1:"")
							Set DimenLevel=$find(aStatDimens,DimenMark)-1
							Set $p(DimenCode,"-",1)=$e("0000"_HospID,*-3,*)       //医院ID
							Set $p(DimenCode,"-",2)=$e("00"_LocGrpID,*-1,*)       //科室分类ID
							Set $p(DimenCode,"-",3)=$e("0000"_LocID,*-3,*)        //科室ID
							Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
							Set $p(DimenCode,"-",5)=DimenLevel                      //层级
							
							Set DimensData=$lb(DimenCode,LocID,"	"_LocDesc,IsActive)
							Set Count=Count+1
							Do return.SetAt(DimensData,Count)
						}
					}
				}
			} Else {
				If (aStatDimens["E")||(aStatDimens["W") {			
					//HE或HW科室列表
					Set xLocIdx=0,tLocIdx=0
					For {
						Set xLocIdx=$o(arrLocation("LocIdx",HospID,xLocIdx))
						Quit:xLocIdx=""
						
						Set LocInfo=$g(arrLocation("LocIdx",HospID,xLocIdx))
						Set LocID=$lg(LocInfo,1)
						Set LocDesc=$lg(LocInfo,2)
						Set IsActive=$lg(LocInfo,4)
						Set LocGrpID=$lg(LocInfo,5)
						Set tLocIdx=tLocIdx+1
						Set:(LocDesc["停用")||(LocDesc["作废") IsActive=0
						
						Set DimenMark=$s(aStatDimens["E":"E",aStatDimens["W":"W",1:"")
						Set DimenLevel=$find(aStatDimens,DimenMark)-1
						Set $p(DimenCode,"-",1)=$e("0000"_HospID,*-3,*)       //医院ID  //update 2022-09-16 与GetStatDimensInfo方法取值一致
						Set $p(DimenCode,"-",2)=$e("00"_LocGrpID,*-1,*)       //科室分类ID
						Set $p(DimenCode,"-",3)=$e("0000"_LocID,*-3,*)        //科室ID
						Set $p(DimenCode,"-",4)=DimenMark                     //层级标识
						Set $p(DimenCode,"-",5)=DimenLevel                    //层级
						
						Set DimensData=$lb(DimenCode,LocID,"	"_LocDesc,IsActive)
						Set Count=Count+1
						Do return.SetAt(DimensData,Count)
					}
				}
			}
		}
	} ElseIf (aStatDimens="G") {
		//科室分组列表
		Set xGrpID=0
		For {
			Set xGrpID=$o(arrLocGroup("LocGrpID",xGrpID))
			Quit:xGrpID=""
			
			Set LocGrpInfo=$g(arrLocGroup("LocGrpID",xGrpID))
			Set LocGrpID=$lg(LocGrpInfo,1)
			Set LocGrpDesc=$lg(LocGrpInfo,2)
			Set DimenMark="G"
			Set DimenLevel=$find(aStatDimens,DimenMark)-1
			Set $p(DimenCode,"-",1)="0000"                          //医院ID
			Set $p(DimenCode,"-",2)=$e("00"_LocGrpID,*-1,*)         //科室分类ID
			Set $p(DimenCode,"-",3)="0000"                          //科室ID
			Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
			Set $p(DimenCode,"-",5)=DimenLevel                      //层级
						
			Set DimensData=$lb(DimenCode,LocGrpID,LocGrpDesc,"1")
			Set Count=Count+1
			Do return.SetAt(DimensData,Count)
		}

	} Else {
		If (aStatDimens["E")||(aStatDimens["W") {
			//E或W科室列表
			Set xLocIdx=0,tLocIdx=0
			For {
				Set xLocIdx=$o(arrLocation("LocIdx",xLocIdx))
				Quit:xLocIdx=""
				
				Set LocInfo=$g(arrLocation("LocIdx",xLocIdx))
				Set LocID=$lg(LocInfo,1)
				Set LocDesc=$lg(LocInfo,2)
				Set IsActive=$lg(LocInfo,4)
				Set HospID=$lg(LocInfo,5)
				Set LocGrpID=$lg(LocInfo,6)
				Set tLocIdx=tLocIdx+1
				Set:(LocDesc["停用")||(LocDesc["作废") IsActive=0
				
				Set DimenMark=$s(aStatDimens["E":"E",aStatDimens["W":"W",1:"")
				Set DimenLevel=$find(aStatDimens,DimenMark)-1
				Set $p(DimenCode,"-",1)=$e("000"_HospID,*-3,*)        //医院ID  //update 2022-09-16 与GetStatDimensInfo方法取值一致
				Set $p(DimenCode,"-",2)=$e("00"_LocGrpID,*-1,*)       //科室分类ID
				Set $p(DimenCode,"-",3)=$e("0000"_LocID,*-3,*)        //科室ID
				Set $p(DimenCode,"-",4)=DimenMark                       //层级标识
				Set $p(DimenCode,"-",5)=DimenLevel                      //层级
				
				Set DimensData=$lb(DimenCode,LocID,"	"_LocDesc,IsActive)
				Set Count=Count+1
				Do return.SetAt(DimensData,Count)
			}
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2022-06-13
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
///               aInfTypeCode:1 医院感染 0：社区感染
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfo("10948","61086","66529")
ClassMethod GetInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfTypeCode As %String = "", aLocDr As %String = "", aWardDr As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfTypeCode,aLocDr,aWardDr)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	//1，判断本次感染是否是手术感染，手术感染关联手术是否是历史手术，历史手术本次就诊感染人数就不统计，
	//   按照手术日期统计到历史就诊上。
	//2，本次就诊的手术是否被后面就诊感染信息关联，关联即按照手术日期统计本次就诊感染。
	//3，针对手术部位感染的感染日期应调整为手术开始时间而不是医院感染报告中填写的感染时间。
	Set InfPosDescs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")   //只统计感染报告，新生儿的分开统计 20211104
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Continue:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			//报告日期
			Set RepDate=$lg(INFRepData,4)
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			//报告人
			Set RepUser=""
			Set RepUserDr=$lg(INFRepData,7)
			Set RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
			Set BTDesc=$lg(RepUserData,3)
			Set:RepUserDr'="" RepUser=BTDesc
			//代报标志
			Set ReplaceFlag=$lg(INFRepData,16)
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set InPosDiag = $lg(InfPosData,3)
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate = $lg(DiagsData,7)
				//1，判断本次感染是否是手术感染，手术感染关联手术是否是历史手术，历史手术本次就诊感染人数就不统计，
				//   按照手术日期统计到历史就诊上。
				Set OperInfFlag=0
				Set HisOperFlg=0   // 是否有历史手术标志
				If ((InPosDiag["表浅")||((InPosDiag["深部"))||((InPosDiag["器官和腔隙感染"))){
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xxSub))
						Quit:xxSub=""
			
						Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xxSub))
						Continue:INFRepExtData=""
						Set xOPSID = $lg(INFRepExtData,3)
						Continue:xOPSID=""
						Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
						Continue:OPSData=""
						Set OpsEpisodeDr = $lg(OPSData,2)  // 手术对应的就诊号
						Set IROperDr     = $lg(OPSData,3)
						Set IROperDate   = $lg(OPSData,7)
						Continue:IROperDate=""
						Set OperInfFlag=1
						If (OpsEpisodeDr=aEpisodeID){     // 本次就诊的手术，感染日期修改成手术开始日期
							Set InfDate = IROperDate
						}Else{                            // 历史就诊的手术，本次就诊不统计，设置感染日期为空
							Set HisOperFlg=1
							Set InfDate="" 
						}
					}
				}
				Set:HisOperFlg=1 InfDate=""
				Continue:InfDate=""
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set InfTypeCode=1
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:(OperInfFlag'=1)&(InfDate-AdmDate<2) InfType="社区感染",InfTypeCode=0  //社区感染判断
				}
				Continue:(aInfTypeCode'="")&&(aInfTypeCode'=InfTypeCode)
				
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				If (aWardDr'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardDr)				
				}
				If (aLocDr'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocDr)
				}
				
				//感染科室
				Set InfLocDesc=""
				Set IRInfLocDr=$lg(DiagsData,6)
				If (IRInfLocDr'=""){
					Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
					Set LocDesc2 = $lg(IRInfLocData,4)
					Set LocDesc  = $lg(IRInfLocData,3)
					Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				//转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				}
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_InPosDiag_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser
				}
			}
		}
	}
	//2，本次就诊的手术是否被后面就诊感染信息关联，关联即按照手术日期统计本次就诊感染。
	// 历史就诊，医院感染关联的手术
	Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",aEpisodeID,""))
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFLastAdm",LastAdmID)
	If (arrInfRep.Count()>0){
		For indIR=1:1:arrInfRep.Count() {
			Set InfRepData=arrInfRep.GetAt(indIR)
			Continue:InfRepData=""
			Set InfRepType=$lg(InfRepData,3)
			Continue:(InfRepType'=1)&(InfRepType'=2) //感染报告 新生儿感染报告
			Set ReportID=$lg(InfRepData,1)
			Set RepStatus=$lg(InfRepData,8)
			Set LinkEpsodeID=$lg(InfRepData,2)
			Continue:LinkEpsodeID=""
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			//报告日期
			Set RepDate=$lg(InfRepData,4)
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			//报告人
			Set RepUser=""
			Set RepUserDr=$lg(InfRepData,7)
			Set RepUserData=$g(^DHCHAI.BT.SysUserD(RepUserDr))
			Set BTDesc=$lg(RepUserData,3)
			Set:RepUserDr'="" RepUser=BTDesc
			//代报标志
			Set ReplaceFlag=$lg(InfRepData,16)
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),ReportID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set InPosDiag = $lg(InfPosData,3)
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Continue:BigCode=""
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate = $lg(DiagsData,7)
				//2，本次就诊的手术是否被后面就诊感染信息关联，关联即按照手术日期统计本次就诊感染。
				//   按照手术日期统计到历史就诊上。
				Set OperInfFlag=0
				If ((InPosDiag["表浅")||((InPosDiag["深部"))||((InPosDiag["器官和腔隙感染"))){
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),ReportID,xxSub))
						Quit:xxSub=""
			
						Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xxSub))
						Continue:INFRepExtData=""
						Set xOPSID = $lg(INFRepExtData,3)
						Continue:xOPSID=""
						Set OPSData      = $g(^DHCHAI.IR.INFOPSD(xOPSID))
						Continue:OPSData=""
						Set OpsEpisodeDr = $lg(OPSData,2)  // 手术对应的就诊号
						Continue:OpsEpisodeDr'=aEpisodeID
						Set IROperDr     = $lg(OPSData,3)
						Set IROperDate   = $lg(OPSData,7)
						Continue:IROperDate=""
						Set OperInfFlag=1
						Set InfDate = IROperDate
					}
				}
				Continue:OperInfFlag'=1   // 非手术感染
				Continue:InfDate=""
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set InfTypeCode=1
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(LinkEpsodeID)),20)
			   		Set:(OperInfFlag'=1)&(InfDate-AdmDate<2) InfType="社区感染",InfTypeCode=0  //社区感染判断
				}
				Continue:(aInfTypeCode'="")&&(aInfTypeCode'=InfTypeCode)
				
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,InfDate,"00:00:01")
				If (aWardDr'="") {
					Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
					Continue:(InfLocDr'=aWardDr)				
				}
				If (aLocDr'=""){
					Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
					Continue:(InfLocDr'=aLocDr)
				}
				
				//感染科室
				Set InfLocDesc=""
				Set IRInfLocDr=$lg(DiagsData,6)
				If (IRInfLocDr'=""){
					Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
					Set LocDesc2 = $lg(IRInfLocData,4)
					Set LocDesc  = $lg(IRInfLocData,3)
					Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				//转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				If (IRInfEffectDr'=""){
					Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
					Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				}
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_InPosDiag_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser
				}
			}
		}
	}
	
	
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-14
/// Description:  获取感染报告手术相关感染诊断信息---目前未使用
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfPosOperInfoOld(2598 65436 65496)
ClassMethod GetInfPosOperInfoOld(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs="",OPSIDs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""				
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_PosDesc_"^"_InfDate
				}
			}
			//获取手术切口感染关联手术切口调查表 add
			if (InfPosDescs'=""){
				Set LinkOPS=""
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xSub))
					Quit:xSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set xOPSID=$lg(INFRepExtData,3)
					Continue:xOPSID=""
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
					Continue:OPSData=""
				
					Set IROperDr=$lg(OPSData,3)
					Continue:IROperDr=""
				
					Set OPSID=IROperDr
					Set OPSIDs=OPSIDs_"^"_OPSID
				}
				Set:OPSIDs'="" OPSIDs = $e(OPSIDs,2,$l(OPSIDs))
			}
		}
	}
    Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs_"#"_OPSIDs
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-14
/// Description:  获取感染报告手术相关感染诊断信息，增加了历史手术感染
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfPosOperInfo("29","2019-02-27","2020-05-08")
ClassMethod GetInfPosOperInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs="",OPSIDs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""

			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Set InfEffectDr  = $lg(DiagsData,8)
				Set InfType  = $lg(DiagsData,18)
				Set InfTypeDesc=""
				Set:InfType="0" InfTypeDesc="社区感染"
				Set:InfType="1" InfTypeDesc="医院感染"
				Set InfEffectDesc=""
				If (InfEffectDr'="") {
					Set InfEffectData= $g(^DHCHAI.BT.DictionaryD(InfEffectDr))
					Set:InfEffectData'="" InfEffectDesc= $lg(InfEffectData,3)	
				}
				// Add 2021-07-21 手术感染通过关联手术判断,不走时间
				//Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				//Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set:InfPosDescs'[PosDesc InfPosDescs = InfPosDescs_"|"_DiagID_"^"_PosDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffectDesc_"^"_InfTypeDesc
				}
				
			}
			//获取手术切口感染关联手术切口调查表 add
			if (InfPosDescs'=""){
				
				;Set LinkOPS=##class(DHCHAI.IR.INFReport).GetRepLinkIDs("DHCHAI.IR.INFOPS")
				Set LinkOPS=""
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xSub))
					Quit:xSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set xOPSID=$lg(INFRepExtData,3)
					Continue:xOPSID=""
				
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
					Continue:OPSData=""
				
					Set IROperDr=$lg(OPSData,3)
					Continue:IROperDr=""
				
					Set OPSID=IROperDr
					Set OPSIDs=OPSIDs_"^"_OPSID
					
				}
			}
		}
	}
	// 历史就诊，医院感染关联的手术
	Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",aEpisodeID,""))
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFLastAdm",LastAdmID)
	If (arrInfRep.Count()>0){
		For indIR=1:1:arrInfRep.Count() {
			Set InfRepData=arrInfRep.GetAt(indIR)
			Continue:InfRepData=""
			Set InfRepType=$lg(InfRepData,3)
			Continue:(InfRepType'=1)&(InfRepType'=2) //感染报告 新生儿感染报告
			Set ReportID=$lg(InfRepData,1)
			Set RepStatus=$lg(InfRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),ReportID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
	
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					
					// 感染日期
					Set InfDate  = $lg(DiagsData,5)
				
					Set InfXDate  = $lg(DiagsData,7)
					Set xxSub=0
					For {
						Set xxSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),ReportID,xxSub))
						Quit:xxSub=""
					
						Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xxSub))
						Continue:INFRepExtData=""
						
						Set xOPSID=$lg(INFRepExtData,3)
						Continue:xOPSID=""			
						Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
						Continue:OPSData=""
						
						Set IROperDate   = $lg(OPSData,7)
						Set IROperDr=$lg(OPSData,3)
						Continue:IROperDr=""
						Set InfDate = IROperDate
						Set OPSID=IROperDr
						Set OPSIDs=OPSIDs_"^"_OPSID
						
						
					}
					Set InfEffectDr  = $lg(DiagsData,8)
					Set InfType  = $lg(DiagsData,18)
					Set InfTypeDesc=""
					Set:InfType="0" InfTypeDesc="社区感染"
					Set:InfType="1" InfTypeDesc="医院感染"
					Set InfEffectDesc=""
					If (InfEffectDr'="") {
					Set InfEffectData= $g(^DHCHAI.BT.DictionaryD(InfEffectDr))
					Set:InfEffectData'="" InfEffectDesc= $lg(InfEffectData,3)	
					}
					
					Set:InfPosDescs'[PosDesc InfPosDescs = InfPosDescs_"|"_DiagID_"^"_PosDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffectDesc_"^"_InfTypeDesc
				
				}
			}
		}
	}
	Set:OPSIDs'="" OPSIDs = $e(OPSIDs,2,$l(OPSIDs))	
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs_"#"_OPSIDs
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-14 
/// Description:  获取感染报告手术相关感染诊断信息，增加了历史手术感染
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfPosOperInfo2("29","2019-02-27","2020-05-08")
ClassMethod GetInfPosOperInfo2(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs="",OPSIDs=""
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
			
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)), 3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set:InfPosDescs'[PosDesc InfPosDescs = InfPosDescs_"|"_DiagID_"^"_PosDesc_"^"_InfDate
				}
			}
			//获取手术切口感染关联手术切口调查表 add
			if (InfPosDescs'=""){
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xSub))
					Quit:xSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set xOPSID=$lg(INFRepExtData,3)
					Continue:xOPSID=""
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
					Continue:OPSData=""
				
					Set IROperName=$lg(OPSData,4)
					Continue:IROperName=""
					Set OPSID=IROperName
					Set OPSIDs=OPSIDs_"^"_OPSID
				}
			}
		}
	}
	// 历史就诊，医院感染关联的手术
	Set LastAdmID=$o(^DHCHAI.IR.INFLastAdmI("IndexLastAdm",aEpisodeID,""))
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFLastAdm",LastAdmID)
	If (arrInfRep.Count()>0){
		For indIR=1:1:arrInfRep.Count() {
			Set InfRepData=arrInfRep.GetAt(indIR)
			Continue:InfRepData=""
			Set InfRepType=$lg(InfRepData,3)
			Continue:(InfRepType'=1)&(InfRepType'=2) //感染报告 新生儿感染报告
			Set ReportID=$lg(InfRepData,1)
			Set RepStatus=$lg(InfRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),ReportID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set:InfPosDescs'[PosDesc InfPosDescs = InfPosDescs_"|"_DiagID_"^"_PosDesc_"^"_InfDate
				}
			}
			//获取手术切口感染关联手术切口调查表 add
			if (InfPosDescs'=""){
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),ReportID,xSub))
					Quit:xSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(ReportID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set xOPSID=$lg(INFRepExtData,3)
					Continue:xOPSID=""
					Set OPSData = $g(^DHCHAI.IR.INFOPSD(xOPSID))
					Continue:OPSData=""
				
					Set IROperName=$lg(OPSData,4)
					Continue:IROperName=""
					
					Set OPSID=IROperName
					Set OPSIDs=OPSIDs_"^"_OPSID
				}
			}
		}
	}
	Set:OPSIDs'="" OPSIDs = $e(OPSIDs,2,$l(OPSIDs))	
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs_"#"_OPSIDs
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2022-06-08
/// Description:  取科室一段时间新入、在院、出院就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
///               aAdmType : 就诊类型（住院I、门诊O）
///               aOutType : 输出类型（A在科、A2在科、I入科、O出科）
/// Return：      返回%List 调整住院人数规则 当天入科计入住院人数，天数不计入
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate($zdh("2020-05-25",3),$zdh("2020-05-25",3),"W","29","I")
ClassMethod GetLocEpisByDate(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, aOutType As %String = "", ByRef aMsgErr As %String = "", aStatPar As %String = "0") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aOutType,aMsgErr,aStatPar)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetLocEpisByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetLocEpisByLocDateErr"
	
	If aLocID'="" {
		Set LocData=$g(^DHCHAI.BT.LocationD(aLocID))
		Quit:LocData="" return
		Set BTTypeDr=$lg(LocData,5)
		Quit:BTTypeDr="" return
		Set LocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
		Quit:LocType'=aLocType return
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	//Set:aOutType="" aOutType="A|A2|O"  //默认输出在科+出科，不输出入科
	Set:aOutType="" aOutType="A|A2|O|I"  //默认输出在科+出科+入科 调整20210705
	Set:aOutType'="" aOutType="|"_aOutType_"|"
   
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set:aStatPar=1 IsStatParWard=1
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:(xTransType="B")&&(IsStatParWard'=1) //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)&&(IsStatParWard'=1)
		Continue:(xTransType="W")&&(IsStatParWard=1)
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					;Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					;Continue:'$isobject(objTrans)
					;Continue:'$isobject(objTrans.PAEpisodeDr)
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Continue:TranData=""
					Set EpisodeDr=$lg(TranData,3)	//objTrans.PAEpisodeDr.%Id()
					Continue:EpisodeDr=""
					//没有分配床位的不算
					//Continue:'$d(^DHCHAI.DP.PAAdmTransI("IndexTransID","B",EpisodeDr))  //update 20230207 日间病房患者存在不分床的患者，就诊结束为D
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Set AdmStatus=$lg(AdmData,19)
					Continue:(AdmStatus="C")||(AdmStatus="P") //update 20230207 入院未分床的患者统一处理为预住院的患者
					Set AdmDate =$lg(AdmData,20)
					Set AdmType=$lg(AdmData,18)	;objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					;Continue:'$isobject(objTrans.PATransLocDr)
					;Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					;Set TransLocDr=objTrans.PATransLocDr.%Id()
					Set TransLocDr=$lg(TranData,5)	;objTrans.PATransLocDr.%Id()
					Continue:TransLocDr=""
					Continue:$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),5)=""	
					If (IsStatParWard=1)&&(aLocType'="E") {
						Set TransBedDr=$lg(TranData,6)	
						Continue:TransBedDr=""
						Set TransBedInfo = $g(^DHCHAI.BT.PACBedD(TransBedDr))
						Continue:TransBedInfo=""
						Set TransLocDr = $lg(TransBedInfo,11)
						Continue:TransLocDr=""
					}									
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					;Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=$lg(TranData,7)	;objTrans.PATransDate
					Set:TransDate<AdmDate TransDate=AdmDate    //按分床取入院时，转入科室日期早于入院日期不计入统计
					Set TransTime=$lg(TranData,8)	;objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=$lg(TranData,10)	;objTrans.PAOutLocDate
					Set OutLocTime=$lg(TranData,11)	;objTrans.PAOutLocTime
					//add 20221028 处理出院后转科未结束或出院后再产生的转科记录
					Set DischDate = $lg(AdmData,26)
					Continue:(AdmStatus="D")&(AdmDate>DischDate)
					Set:(AdmStatus="D")&(OutLocDate="") OutLocDate=DischDate
					Set:(AdmStatus="D")&(OutLocDate>DischDate) OutLocDate=DischDate  	
					
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					
					For xDate=TransDate:1:TransXDate {
						Continue:xDate<aDateFrom
						Quit:xDate>aDateTo
	                   	//Continue:(xTransType="W")&&($d(^TMP(ZIndex,JIndex,NIndex,"InvTransEpis",EpisodeDr,xDate)))
						Set ^TMP(ZIndex,JIndex,NIndex,"TransLocEpis",EpisodeDr,TransLocDr,xDate,xTransID)=""
						 
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xEpisodeDr=0
	//增加过滤特定患者如测试患者支持登记号、姓名、病案号 chenjb 20210714
	//w ##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	Set aExPaAdm=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	For {
		Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr))
		Quit:xEpisodeDr=""		
		If aExPaAdm'="" 
		{
			Set anPAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:anPAAdmData=""			
			Set anPapmiNo = $lg(anPAAdmData,4)  //登记号
			Set anMrNo = $lg(anPAAdmData,5)     //病案号
			Set anPatName = $lg(anPAAdmData,6)  //姓名
			Continue:(anPapmiNo'="")&(aExPaAdm[anPapmiNo)			
			Continue:(anMrNo'="")&(aExPaAdm[anMrNo)
			Continue:(anPatName'="")&(aExPaAdm[anPatName)
		}
		Set xLocDr=""
		For {
			Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr))
			Quit:xLocDr=""
			
			Set TransDates="",LnkLocDr="",TransIDs=""
			Set xDate=""
			For {
				Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate))
				Quit:xDate=""
				
				Set TransID=""
				Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"I"))
				Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"O"))
				If ICnt>OCnt {
					Set xStatus="I"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
				} ElseIf ICnt<OCnt {
					Set xStatus="O"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""),-1)
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""),-1)
				} ElseIf (ICnt=OCnt)&(ICnt>0) {
					//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
					//      先入再出，并且"转入次数=转出次数"，这种算在院A2
					Set tStatus="O",xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,xTime,""))
				} Else {
					Set xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					If TransID="" {
						Set xStatus="A2"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					}
				}
				Continue:TransID=""
				Continue:aOutType'[("|"_xStatus_"|")
				
				If aLocType="W" {
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set LnkLocDr=$lg(TranData,14)
				}
				//增加判断入科当天不算住院日天数,住院天数按零点计算
				if (xStatus'="I")&&(xStatus'="A2") {   
					Set:TransDates'="" TransDates=TransDates_","_xDate
					Set:TransDates="" TransDates=xDate
				}
				//附带每个在科记录的相关转科信息
				Set:(","_TransIDs_",")'[(","_TransID_",") TransIDs=TransIDs_","_TransID
				Set xTransID=""
				For {
					Set xTransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransLocEpis",xEpisodeDr,xLocDr,xDate,xTransID))
					Quit:xTransID=""
					Continue:xTransID=TransID
					Set:(","_TransIDs_",")'[(","_xTransID_",") TransIDs=TransIDs_","_xTransID
				}
			}

			//Continue:TransDates=""  //如果是当天入科的，非当天出不返回
			Set:TransIDs'="" TransIDs=$e(TransIDs,2,$l(TransIDs))
			Set Count=Count+1
		    //update 20220921 去掉转科日期，防止查询时间过长造成超长问题
		    Set LocEpidInfo=$lb(xEpisodeDr,xLocDr,aLocType,"",LnkLocDr,TransIDs)
			Do return.SetAt(LocEpidInfo,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetLocEpisByLocDateErr
    Set $ZT=""
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-11-01
/// Description:  获患者在科天数 
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetInDays(175,$zdh("2020-05-25",3),$zdh("2020-05-25",3),"665")
ClassMethod GetInDays(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTransIDs As %String) As %String
{
	new (aEpisodeID,aDateFrom,aDateTo,aTransIDs)
	Set return=0
	Quit:(aEpisodeID="")||(aTransIDs="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	Set AdmStatus=$lg(PAAdmData,19)
	Set AdmDate=$lg(PAAdmData,20)
	Set DischDate=$lg(PAAdmData,26)
	Set:aDateTo>+$h aDateTo=+$h
	Quit:(DischDate'="")&(DischDate<aDateFrom) return

	Set InDays=0
	For xTransInd=1:1:$l(aTransIDs,",") {
	    Set TransID=$p(aTransIDs,",",xTransInd)
	    Continue:TransID=""
	    Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransID))
	    Set TransDate	= $li(TranData,7)
	    Set OutLocDate	= $li(TranData,10)
	    Continue:(TransDate=OutLocDate)    //当天入当天出住院天数为0
	    Continue:(TransDate=aDateFrom)&(aDateFrom=aDateTo) 
	    //处理分床日期、出院日期问题
        Set:TransDate<AdmDate TransDate=AdmDate    
		Set:(AdmStatus="D")&(OutLocDate="") OutLocDate=DischDate
		Set:(AdmStatus="D")&(OutLocDate>DischDate) OutLocDate=DischDate
					
		Set DayCount=0
		//如果转科起止日期大于统计日期，以统计日期计算
		Set DateFrom=TransDate,DateTo=OutLocDate
		Set:TransDate<aDateFrom DateFrom = aDateFrom-1
		Set:(OutLocDate="")||(OutLocDate>aDateTo) DateTo = aDateTo
		
		Set DayCount=DateTo-DateFrom
		Set InDays=InDays+DayCount
	}
	Set return=InDays
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2023-02-07
/// Description:  剔除测试患者公共方法
/// w ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(175,"程")
ClassMethod ExcTestAdm(aEpisodeID As %String, aExAdmList As %String = "") As %String
{
	new (aEpisodeID,aExAdmList)
	Set return=0
	Set:aExAdmList="" aExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	Quit:aExAdmList="" return
	
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return			
	Set PapmiNo = $lg(PAAdmData,4)  //登记号
	Set MrNo    = $lg(PAAdmData,5)  //病案号
	Set PatName = $lg(PAAdmData,6)  //姓名
    
	Quit:(PapmiNo'="")&(aExAdmList[PapmiNo) 1		
	Quit:(MrNo'="")&(aExAdmList[MrNo) 1
	Quit:(PatName'="")&(aExAdmList[PatName) 1	
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2022-06-09
/// Description:  取每日新入、在院、出院就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
///               aAdmType : 就诊类型（住院I、门诊O）
/// Return：      返回%List
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetTransEpisByLocDate("2019-01-11","2019-02-11","W","99","I")
ClassMethod GetTransEpisByLocDate(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransEpisByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetTransEpisByLocDateErr"
	
	If aLocID'="" {
		Set LocData=$g(^DHCHAI.BT.LocationD(aLocID))
		Quit:LocData="" return
		Set BTTypeDr=$lg(LocData,5)
		Quit:BTTypeDr="" return
		Set LocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
		Quit:LocType'=aLocType return
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType="B" //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					;Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					;Continue:'$isobject(objTrans)
					;Continue:'$isobject(objTrans.PAEpisodeDr)
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Continue:TranData=""
					Set EpisodeDr=$lg(TranData,3)	//objTrans.PAEpisodeDr.%Id()
					Continue:EpisodeDr=""
					//没有分配床位的不算
					Continue:'$d(^DHCHAI.DP.PAAdmTransI("IndexTransID","B",EpisodeDr))
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$lg(AdmData,19)="C"
					
					Set AdmType=$lg(AdmData,18)	;objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					;Continue:'$isobject(objTrans.PATransLocDr)
					;Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					;Set TransLocDr=objTrans.PATransLocDr.%Id()
					Set TransLocDr=$lg(TranData,5)	;objTrans.PATransLocDr.%Id()
					Continue:TransLocDr=""
					Continue:$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),5)=""
					
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					;Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=$lg(TranData,7)	;objTrans.PATransDate
					Set TransTime=$lg(TranData,8)	;objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=$lg(TranData,10)	;objTrans.PAOutLocDate
					Set OutLocTime=$lg(TranData,11)	;objTrans.PAOutLocTime
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					
					For xDate=TransDate:1:TransXDate {
						Continue:xDate<aDateFrom
						Quit:xDate>aDateTo
						
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xEpisodeDr=0
	For {
		Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr))
		Quit:xEpisodeDr=""
		
		Set xLocDr=""
		For {
			Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr))
			Quit:xLocDr=""
			
			Set xDate=""
			For {
				Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate))
				Quit:xDate=""
				
				Set TransID=""
				Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"I"))
				Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"O"))
				If ICnt>OCnt {
					Set xStatus="I"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
				} ElseIf ICnt<OCnt {
					Set xStatus="O"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""),-1)
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""),-1)
				} ElseIf (ICnt=OCnt)&(ICnt>0) {
					//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
					//      先入再出，并且"转入次数=转出次数"，这种算在院A2
					Set tStatus="O",xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,xTime,""))
				} Else {
					Set xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					If TransID="" {
						Set xStatus="A2"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					}
				}
				Continue:TransID=""
				
				Set TransInfo=$lb(xDate,xEpisodeDr,xStatus,xLocDr,TransID)
				Set Count=Count+1
				Do return.SetAt(TransInfo,Count)
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetTransEpisByLocDateErr
	Set $ZT=""
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2022-06-09
/// Description:  取时间段内在院患者关联转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetTransInfoByLocDate("2019-01-11","2019-02-11","W","99","I")
ClassMethod GetTransInfoByLocDate(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransInfoByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetTransEpisByLocDateErr"
	
	If aLocID'="" {
		Set LocData=$g(^DHCHAI.BT.LocationD(aLocID))
		Quit:LocData="" return
		Set BTTypeDr=$lg(LocData,5)
		Quit:BTTypeDr="" return
		Set aLocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	Set xTransType="",Count=0
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType="B" //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			//xTransDays>0 表示出科病人
			Set xTransDate=""
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>=aDateTo  //转入日期大于等于截止日期，统计日期最后一天转入，算新入不算作在院
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Set EpisodeDr=$lg(TranData,3)	//objTrans.PAEpisodeDr.%Id()
					Continue:EpisodeDr=""
					//没有分配床位的不算
					Continue:'$d(^DHCHAI.DP.PAAdmTransI("IndexTransID","B",EpisodeDr))
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Continue:$lg(AdmData,19)="C"	
					Set AdmType=$lg(AdmData,18)	
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					Set TransLocDr=$lg(TranData,5)	
					Continue:TransLocDr=""
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					Set TransDate=$lg(TranData,7)	;objTrans.PATransDate
					Set TransTime=$lg(TranData,8)	;objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=$lg(TranData,10)	;objTrans.PAOutLocDate
					Set OutLocTime=$lg(TranData,11)	;objTrans.PAOutLocTime
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					Continue:(TransDate=OutLocDate) //当天转入转出不算作住院人数
					Set TransInfo=$lb(xTransID,TransDate,OutLocDate,EpisodeDr,TransLocDr)
					Set Count=Count+1
					Do return.SetAt(TransInfo,Count)
				}
			}
		}
	}
	Quit return
	
GetTransInfoByLocDateErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// add by zhugz
/// 2019-10-23
/// 获取维度类别信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetStatDimensStr()
ClassMethod GetStatDimensStr(aType As %String = "") As %String
{
	New (aType)
	Set return=""
	//根据系统参数配置是否显示'科室分组'
	Set IsShowGroup=##class(DHCHAI.BT.Config).GetValByCode("IsShowGroup")
	If (IsShowGroup=0) {
		If aType="E" {
			Set return="AHE"
		} Else {
			Set return="AHW"
		}
	}Else {
		If aType="E" {
			Set return="AHGE"
		} Else {
			Set return="AHGW"
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-09-17
/// Description:  查询维度类别信息
/// Table：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STATV2.AbstractComm","QryStatDimens","E")
Query QryStatDimens(aType As %String = "") As %Query(ROWSPEC = "ind:%String,Code:%String,Desc:%String,IsDefault:%String") [ SqlProc ]
{
}

ClassMethod QryStatDimensExecute(ByRef qHandle As %Binary, aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aType="" aType="W"
	Set StatDimens=##class(DHCHAI.BT.Config).GetValByCode("StatDimensType")
	Set:StatDimens="" StatDimens="AHG"_aType
	Set Count=0
	Kill arrDimens
	Kill arrResult
	
	Set arrDimens("A")="全院"
	Set arrDimens("H")="院区"
	Set arrDimens("G")="分组"
	Set arrDimens(aType)=$s(aType="W":"病区",1:"科室")
	
	Set IsDefault=1
	Set DimensCode="AHG"_aType 
	Set:(StatDimens[aType)&(DimensCode'=StatDimens) IsDefault=0
	Set:(StatDimens'[aType)&($e(StatDimens,1,*-1)_aType'=DimensCode) IsDefault=0

	Set DimensDesc=$g(arrDimens("A"))_"-"_$g(arrDimens("H"))_"-"_$g(arrDimens("G"))_"-"_$g(arrDimens(aType))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
  	Set DimensCode="AH"_aType 
  	Set:(StatDimens[aType)&(DimensCode'=StatDimens) IsDefault=0
	Set:(StatDimens'[aType)&($e(StatDimens,1,*-1)_aType'=DimensCode) IsDefault=0
	Set DimensDesc=$g(arrDimens("A"))_"-"_$g(arrDimens("H"))_"-"_$g(arrDimens(aType))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
 	Set DimensCode="HG"_aType 
	Set:(StatDimens[aType)&(DimensCode'=StatDimens) IsDefault=0
	Set:(StatDimens'[aType)&($e(StatDimens,1,*-1)_aType'=DimensCode) IsDefault=0
	Set DimensDesc=$g(arrDimens("H"))_"-"_$g(arrDimens("G"))_"-"_$g(arrDimens(aType))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
    Set DimensCode="HG"
  	Set:DimensCode'=StatDimens IsDefault=0
	Set DimensDesc=$g(arrDimens("H"))_"-"_$g(arrDimens("G"))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
    Set DimensCode="H"_aType 
    Set:DimensCode'=StatDimens IsDefault=0
    Set:(StatDimens'[aType)&(StatDimens'="HG")&($e(StatDimens,1,*-1)_aType=DimensCode) IsDefault=1
	Set DimensDesc=$g(arrDimens("H"))_"-"_$g(arrDimens(aType))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
	Set DimensCode="H"
	Set:DimensCode'=StatDimens IsDefault=0
	Set DimensDesc=$g(arrDimens("H"))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
	Set DimensCode="G"
	Set:DimensCode'=StatDimens IsDefault=0
	Set DimensDesc=$g(arrDimens("G"))
	Set Data=$lb(DimensCode,DimensDesc,IsDefault)
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)

	Set IsDefault=1
	Set DimensCode=aType
	Set:(DimensCode'=StatDimens)&("WE"'[StatDimens) IsDefault=0
	Set DimensDesc=$g(arrDimens(aType))
	Set Count=Count+1	
    Set arrResult(Count)=$lb(Count,DimensCode,DimensDesc,IsDefault)
   
    For indC=1:1:Count {
	    Set Data=arrResult(indC)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
    }
    
	Kill arrDimens
	Kill arrResult
	
	Quit $$$OK
}

ClassMethod QryStatDimensClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatDimensExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatDimensFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatDimensExecute ]
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

/// add by zhugz
/// 2019-10-23
/// 获取输出单位维度信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetStatDimensInfo("G",1,7,122,123)
ClassMethod GetStatDimensInfo(aStatDimens As %String, aHospDr As %String, aGroupDr As %String, aLocDr As %String, aWardDr As %String) As %String
{
	New (aStatDimens,aHospDr,aGroupDr,aLocDr,aWardDr)
	Set return=""
	Quit:aStatDimens="" return

	Quit:(aStatDimens["E")&(aLocDr="") return
	Quit:(aStatDimens["W")&(aWardDr="") return

	
	//add by zf 2020-02-28 处理科室和病区对应科室组不一致导致统计出问题
	If (aStatDimens["E") {
		Set aHospDr=$List($g(^DHCHAI.BT.LocationD(aLocDr)),8)	    //科室所在医院
		Set aGroupDr=$List($g(^DHCHAI.BT.LocationD(aLocDr)),7)		//科室所在科室组
	} ElseIf (aStatDimens["W") {
		Set aHospDr=$List($g(^DHCHAI.BT.LocationD(aWardDr)),8)	    //科室所在医院
		Set aGroupDr=$List($g(^DHCHAI.BT.LocationD(aWardDr)),7)		//科室所在科室组
	} Else { //默认按科室统计
		If (aLocDr) {
			Set aHospDr=$List($g(^DHCHAI.BT.LocationD(aLocDr)),8)	    //科室所在医院
			Set:aGroupDr="" aGroupDr=$List($g(^DHCHAI.BT.LocationD(aLocDr)),7)		//科室所在科室组
		}
	}
	If (aGroupDr="") {
		Set aGroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
	}
	 Quit:(aStatDimens["H")&(aHospDr="") return
       Quit:(aStatDimens="G")&(aGroupDr="") return
	Quit:(aHospDr="")||(aGroupDr="") return
	Set HospGrpDr=$List($g(^DHCHAI.BT.HospitalD(aHospDr)),5)    //医院所在医院分组  
	
	If aStatDimens["G" {
		If aGroupDr="" {
			Set GroupID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
			Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupID))
			If (GroupData'=""){
				Set aGroupDr=$lg(GroupData, 2)
			}
		}
		Quit:(aStatDimens["G")&(aGroupDr="") return
	}	
	Set StatDimensList=""
    Set:aStatDimens="G" aHospDr=""   // add 20220919 按分组统计时不分医院、汇总与明细一致问题通过增加医院入参解决
	Set HosCode=$e("0000"_aHospDr,*-3,*)       	//医院Code
	Set GroupCode=$e("00"_aGroupDr,*-1,*)       //科室分类Code
	Set LocCode=$e("0000"_aLocDr,*-3,*)        	//科室Code
	Set WardCode=$e("0000"_aWardDr,*-3,*)      	//病区Code
	For indSD=1:1:$l(aStatDimens) {
		Set DimenMark=$e(aStatDimens,indSD,indSD)
		Set DimenLevel=$find(aStatDimens,DimenMark)-1
		Set tTxt=""
		If DimenMark="A" {
			//update 20210707 全院统计维度代码按医院分组区分，防止汇总报表中的“全院”汇总数据与打开的明细报表中数据不一致（明细中包含其他医院组患者）			
			Set tTxt="0000-00-0000"_"-"_DimenMark_"-"_HospGrpDr  ////update 20220906 因报表中取医院分组代码取的节点为5，导致医院分组不是1的全院查询数据有问题
		} ElseIf DimenMark="H" {
			Set tTxt=HosCode_"-00-0000-"_DimenMark_"-"_DimenLevel
		} ElseIf DimenMark="G" {
			Set tTxt=HosCode_"-"_GroupCode_"-0000-"_DimenMark_"-"_DimenLevel
		} ElseIf DimenMark="E" {
			Set tTxt=HosCode_"-"_GroupCode_"-"_LocCode_"-"_DimenMark_"-"_DimenLevel
		} ElseIf DimenMark="W" {
			Set tTxt=HosCode_"-"_GroupCode_"-"_WardCode_"-"_DimenMark_"-"_DimenLevel
		}
		Continue:tTxt=""
		If StatDimensList="" {
			Set StatDimensList=$lb(tTxt)
		} Else {
			Set StatDimensList=StatDimensList_$lb(tTxt)
		}
	}
	Set return=$listtostring(StatDimensList,"^")
	Quit return
}

/// add by zhoub
/// 2019-10-23
/// 共用取病人信息方法，输出列和内容不要动！否则维度统计报表信息会混乱
ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	new (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	
	Set EpisodeIDx = $lg(PAAdmData,2)
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = $lg(PAAdmData,3)
	Set PapmiNo = $lg(PAAdmData,4)
	Set MrNo = $lg(PAAdmData,5)
	Set PatName = $lg(PAAdmData,6)
	Set Sex = $lg(PAAdmData,7)
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = $lg(PAAdmData,37)
	Set AdmType = $lg(PAAdmData,18)
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = $lg(PAAdmData,19)
	Set VisitStatus = $s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="C":"退院",VisitStatus="P":"预住院",VisitStatus="U":"作废",1:"")
	Set AdmDate = $lg(PAAdmData,20)
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = $lg(PAAdmData,21)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set TransData=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,AdmDate,AdmTime)  //换成取第一个科室、病区 ？？？？
	Quit:TransData="" return
	
	//Set AdmLocDr = $li(PAAdmData,22)
	Set AdmLocDr = $p(TransData,"^",1)
	Set:AdmLocDr="" AdmLocDr = $lg(PAAdmData,22)   //update20211009 处理急诊留观没有转科科室情况
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $lg(LocData,4)
		Set LocDesc  = $lg(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	//Set AdmWardDr = +$li(PAAdmData,23)
	Set AdmWardDr = $p(TransData,"^",2)
	Set:AdmWardDr="" AdmWardDr = $lg(PAAdmData,23)   //update20211009 处理急诊留观没有转科科室情况
	Set WardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
	Set AdmWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $lg(WardData,4)
		Set WardDesc  = $lg(WardData,3)
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmRoom  = $lg(PAAdmData,24)
	Set AdmBedDr = $lg(PAAdmData,25)
	Set AdmBedData=""
	Set AdmBed=""
	If (AdmBedDr'="") {
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
		If AdmBedData'="" {
			Set AdmBed = $lg(AdmBedData,3)
		}
	}
	Set DischDate = $lg(PAAdmData,26)
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = $lg(PAAdmData,27)
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set DischLocDr = $lg(PAAdmData,28)
    Set LocData=""
    If (DischLocDr'="") {
    	Set LocData = $g(^DHCHAI.BT.LocationD(DischLocDr))
    }
	Set DischLocDesc=""
	If LocData'="" {
		Set LocDesc2 = $lg(LocData,4)
		Set LocDesc  = $lg(LocData,3)
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set DischWardDr = $lg(PAAdmData,29)
	Set WardData=""
    If (DischWardDr'="") {
    	Set WardData = $g(^DHCHAI.BT.LocationD(DischWardDr))
    }
	Set DischWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $lg(WardData,4)
		Set WardDesc  = $lg(WardData,3)
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime
	
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// add by zhugz
/// 2019-11-12
/// 取病人给定时间段内抗菌药物使用记录
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetAntUseInfo(439,$zdh("2020-05-01",3),$zdh("2020-06-30",3))
ClassMethod GetAntUseInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aAntKeyList As %String = "0") As %Library.ArrayOfDataTypes
{
    new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aAntKeyList)
    Set return=##Class(%Library.ArrayOfDataTypes).%New()
    Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","
    //参数配置“抗菌药物治疗前送检排除医嘱名称关键字”，默认配置：克拉霉素片、呋南唑酮片、左氧氟沙星片、阿莫西林胶囊。
    Set AntDescKeyList=""
    If (aAntKeyList=1) {
		Set AntDescKeyList=##class(DHCHAI.BT.Config).GetValByCode("AntDescKeyList")
    }
   
    Set xScode = "",Count=0
    For {
        Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
        Quit:xScode=""
        
        Set xSttDate = ""
        For {
            Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
            Quit:xSttDate=""
            Continue:(xSttDate>aDateTo)
            
            Set xOrdItemID =""
            For {
                Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
                Quit:xOrdItemID=""
        
                Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
                Continue:$lg(OEOrdItemData,25)=0
               
	            Set SCode   = $lg(OEOrdItemData,28)
	           	Set OrdDesc = $lg(OEOrdItemData,4)
	           	Continue:OrdDesc=""     	
                Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID=""
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1   //add 20221122 过滤抗菌药物对照置无效的药物
			    Set IsAntDescKey=0
                For AntIndex=1:1:$Length(AntDescKeyList,","){
	                Quit:IsAntDescKey=1
	                Set AntDescKey=$p(AntDescKeyList,",",AntIndex)
	                Set:(AntDescKey'="")&&(OrdDesc[AntDescKey) IsAntDescKey=1
	            }
	            Continue:(IsAntDescKey=1) 

                Set SttDate = $lg(OEOrdItemData,15)
                Set SttTime = $lg(OEOrdItemData,16)
                Set EndDate = $lg(OEOrdItemData,17)
                Set EndTime = $lg(OEOrdItemData,18)
                Set AntExecDate= $lg(OEOrdItemData,45)
                Set AntExecTime= $lg(OEOrdItemData,46)
                
                Set Priority = $lg(OEOrdItemData,8) //医嘱类型      
                Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
                Continue:PriorityMap=""
                Continue:PriorityMap="OUT"   //add 20210212 统一过滤'出院带药'医嘱
            
                If PriorityMap="N"{
                    Set EndDate = SttDate
                    Set EndTime = SttTime
                }else{
                    If EndDate=""{      // 长期医嘱未停止只计算到传入结束日期
                        //1555798:统计分析V2-住院患者抗菌药物联用情况统计表-抗菌药物使用人数-弹出界面中【结束时间】统计错误
                        //Set EndDate = aDateTo
                        //Set EndTime = aTimeTo
                    }
                }
                Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
                If (EndDate=aDateFrom) {
                    If (EndTime'="") {
                        Continue:(aTimeFrom'="")&&(EndTime<aTimeFrom)  // 停药日期在转入日期前
                    }
                }
                Continue:(SttDate>aDateTo)  // 用药日期在转出日期后
                If (SttDate=aDateTo) {
                    If (SttTime'="") {
                        Continue:(aTimeTo'="")&&(SttTime>aTimeTo)   // 用药日期在转出日期后
                    }
                }
                Set Instruc = $lg(OEOrdItemData,20) //给药途径
                Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)      
                Continue:InstrucMapStr=""
                Set InstrucMap = $p(InstrucMapStr,"^",3)
                Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
                Set Generic=$lg(OEOrdItemData,19)
                Set OrdDate = $lg(OEOrdItemData,10)
                //update 20220923 为提升查询效率，日期时间转化在明细中处理
                //Set:OrdDate'="" OrdDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OrdDate)
                Set OrdTime = $lg(OEOrdItemData,11)
                //Set:OrdTime'="" OrdTime=$zt(OrdTime)
                Set OrdDateTime=OrdDate_" "_OrdTime
    
                //Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
                //Set:SttTime'="" SttTime=$zt(SttTime)
                Set SttDateTime=SttDate_" "_SttTime
                
                //Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
                //Set:EndTime'="" EndTime=$zt(EndTime)
                Set EndDateTime=EndDate_" "_EndTime

                Set OEOrdLocDr=$lg(OEOrdItemData,12)
                Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
                If OEOrdLocData'="" {
                    Set OrdLocDesc=$lg(OEOrdLocData,3)
                } Else {
                    Set OrdLocDesc=$lg(OEOrdItemData,39)  //ID|Code|Desc
                    Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
                }
                Set OrdDocDesc=$lg(OEOrdItemData,14)  //ID|Code|Desc
                Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
                Set UsePurpose = $lg(OEOrdItemData,30)
                Set:UsePurpose="" UsePurpose="其他"
                Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
                Set UsePurpose = $p(UsePurposeMapStr,"^",3)

                Set DrgPoison = $lg(OEOrdItemData,29) //抗菌用药等级
                Set OrdItemID = $lg(OEOrdItemData,24)
                Set OrdItemInfo=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison)
                Set Count=Count+1
                Do return.SetAt(OrdItemInfo,Count)
            }
        }
    }
    Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-09-28
/// 取病人给定时间段内抗菌药物使用记录及联合用药情况
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetAntCombInfo(509,$zdh("2020-05-01",3),$zdh("2023-05-31",3))
ClassMethod GetAntCombInfo(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aUsePurpose As %String = "") As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aUsePurpose)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetAntCombInfo"
	Kill ^TMP($zn,$j,NIndex)
	Kill arrOrdItem
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","

	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	
	           	        	
	           	Set AntiMapDesc="" //抗菌药物标准名称
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				If (AntiMapID) {   //为保证抗菌药物使用人数与其他报表数据一致，只在计算联用数时判断是否对照标准名称
			    	Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    	Continue:$lg(AntiMapData,7)'=1
			    	Set MapItemDr=$lg(AntiMapData,3)
			    	If (MapItemDr) {
	           			Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
	            		Set AntiMapDesc=$lg(AntiMastData,3)  //抗菌药物标准名称
			    	}
				}
	            Set SttDate = $li(OEOrdItemData,15)
	            Set SttTime = $li(OEOrdItemData,16)
				Set EndDate = $li(OEOrdItemData,17)
				Set EndTime	= $li(OEOrdItemData,18)
				
	            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
					Set EndTime	= SttTime
				}
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
				If (EndDate=aDateFrom) {
					If (EndTime'="") {
						Continue:(aTimeFrom'="")&&(EndTime<aTimeFrom)  // 停药日期在转入日期前
					}
				}
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			    If (SttDate=aDateTo) {
				    If (SttTime'="") {
						Continue:(aTimeTo'="")&&(SttTime>aTimeTo)	// 用药日期在转出日期后
					}
			    }
			    
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:(aUsePurpose'="")&(aUsePurpose'=UsePurpose)
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				Set OrdItemID = $li(OEOrdItemData,24)
				
				If (PriorityMap="N") { //停药那天不算联合用药
					Set CombEndDate=EndDate  
				}Else {
					Set CombEndDate=""
					Set:EndDate'="" CombEndDate=EndDate-1
					Set:CombEndDate="" CombEndDate = aDateTo
					Set:CombEndDate<SttDate CombEndDate=SttDate  //当天开当天停的长期医嘱
				}  			
				If (AntiMapDesc'="") {	
					For xUseDate=SttDate:1:CombEndDate {
						Set ^TMP($zn,$j,NIndex,"AntComb",xUseDate,AntiMapDesc)=xOrdItemID
					}
				} 
				Set Generic=$li(OEOrdItemData,19)
				Set OrdDate = $li(OEOrdItemData,10)
				Set OrdTime = $li(OEOrdItemData,11)
			    Set OrdDateTime=OrdDate_" "_OrdTime
	            Set SttDateTime=SttDate_" "_SttTime
	         	Set EndDateTime=EndDate_" "_EndTime
				Set OEOrdLocDr=$li(OEOrdItemData,12)
				Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
				If OEOrdLocData'="" {
					Set OrdLocDesc=$li(OEOrdLocData,3)
				} Else {
					Set OrdLocDesc=$li(OEOrdItemData,39)  //ID|Code|Desc
					Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
				}
				Set OrdDocDesc=$li(OEOrdItemData,14)  //ID|Code|Desc
				Set:$p(OrdDocDesc,"|",3)'="" OrdDocDesc=$p(OrdDocDesc,"|",3)
		
				Set OrdItemInfo=$lb(xOrdItemID,OrdItemID,OrdDesc,Generic,Priority,OrdDateTime,SttDateTime,OrdLocDesc,OrdDocDesc,EndDateTime,UsePurpose,Instruc,DrgPoison)
				Set arrOrdItem(xOrdItemID)=OrdItemInfo
				
			}
		}
	}
	
	Set CombCount=0
	For xDate=aDateFrom:1:aDateTo {
		Set Count=0
		Set xAntiDesc=""
		For{
			Set xAntiDesc=$o(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
		}
		Set:Count>CombCount CombCount=Count
	}
	Set Count=0
	Set xOrdItemID=""
	For {
		Set xOrdItemID=$o(arrOrdItem(xOrdItemID))
		Quit:xOrdItemID=""
		
		Set OrdItemInfo=$g(arrOrdItem(xOrdItemID))_$lb(CombCount)
		Set Count=Count+1
		Do return.SetAt(OrdItemInfo,Count)
	}
		
	Kill arrOrdItem
	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// Creator：     pylian    	
/// CreatDate：   2022-09-28
/// 取病人给定时间段内抗菌药物使用联合用药数
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetAntCombCnt(477,$zdh("2020-05-01",3),$zdh("2020-05-31",3))
ClassMethod GetAntCombCnt(aPaadm As %String, aDateFrom As %String, aDateTo As %String, aTimeFrom As %String = "", aTimeTo As %String = "", aUsePurpose As %String = "") As %Library.ArrayOfDataTypes
{
	new (aPaadm,aDateFrom,aDateTo,aTimeFrom,aTimeTo,aUsePurpose)
	Set return=0
	Quit:(aPaadm="")||(aDateFrom="")||(aDateTo="") return
	
	Set NIndex="GetAntCombCnt"
	Kill ^TMP($zn,$j,NIndex)
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","

	Set xScode = ""
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aPaadm,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0
	            
	            Set SCode   = $li(OEOrdItemData,28)
	           	Set OrdDesc = $li(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" 
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:AntiMapData=""
			    Continue:$lg(AntiMapData,7)'=1  //add 20221122 过滤抗菌药物对照置无效的药物
			    Set MapItemDr=$lg(AntiMapData,3)
			    Continue:MapItemDr=""
	            Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
	            Continue:AntiMastData=""  //过滤未对照
	            Set AntiMapDesc=$lg(AntiMastData,3)  //抗菌药物标准名称
	            Set SttDate = $li(OEOrdItemData,15)
	            Set SttTime = $li(OEOrdItemData,16)
				Set EndDate = $li(OEOrdItemData,17)
				Set EndTime	= $li(OEOrdItemData,18)
				
	            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
					Set EndTime	= SttTime
				}
				Continue:(EndDate<aDateFrom)&&(EndDate'="")  // 停药日期在转入日期前
				If (EndDate=aDateFrom) {
					If (EndTime'="") {
						Continue:(aTimeFrom'="")&&(EndTime<aTimeFrom)  // 停药日期在转入日期前
					}
				}
				Continue:(SttDate>aDateTo)	// 用药日期在转出日期后
			    If (SttDate=aDateTo) {
				    If (SttTime'="") {
						Continue:(aTimeTo'="")&&(SttTime>aTimeTo)	// 用药日期在转出日期后
					}
			    }
			    
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set UsePurpose = $li(OEOrdItemData,30)
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)
                Continue:(aUsePurpose'="")&(aUsePurpose'=UsePurpose)
				
				If (PriorityMap="N") { //停药那天不算联合用药
					Set CombEndDate=EndDate  
				}Else {
					Set CombEndDate=""
					Set:EndDate'="" CombEndDate=EndDate-1
					Set:CombEndDate="" CombEndDate = aDateTo
					Set:CombEndDate<SttDate CombEndDate=SttDate  //当天开当天停的长期医嘱
				}  
					
				For xUseDate=SttDate:1:CombEndDate {
					Set ^TMP($zn,$j,NIndex,"AntComb",xUseDate,AntiMapDesc)=xOrdItemID
				}
				
			}
		}
	}
	
	Set CombCount=0
	For xDate=aDateFrom:1:aDateTo {
		Set Count=0
		Set xAntiDesc=""
		For{
			Set xAntiDesc=$o(^TMP($zn,$j,NIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
		}
		Set:Count>CombCount CombCount=Count   //取最大联用数
	}
	
	Set return = CombCount

	Kill ^TMP($zn,$j,NIndex)
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-11
/// Description:  判断在一段时间内是否使用预防抗菌药物
/// Return：      1：使用    0：未使用
/// w ##class(DHCHAI.STATV2.AbstractComm).CheckUesAnti(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod CheckUesAnti(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","

	Set UseAntiFlg =0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:((xSCode="")||(UseAntiFlg=1))
		
		For xSttDate=aFromDate:1:aToDate {
			Quit:(UseAntiFlg=1)
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:((xID="")||(UseAntiFlg=1))
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xID))
				Continue:$lg(OEOrdItemData,25)=0
				Set AntUsePurpose = $lg(OEOrdItemData,30)
				Continue:AntUsePurpose'["预防"
				//add 20221122 过滤抗菌药物对照中置无效的药品
				Set SCode   = $lg(OEOrdItemData,28)
	           	Set OrdDesc = $lg(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" //过滤未对照
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1
			    
				//add 20210528 过滤非全身用药
				Set Instruc = $lg(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				Set OESttDate = $lg(OEOrdItemData,15)   // 执行医嘱日期
				Set OESttTime = $lg(OEOrdItemData,16)   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set UseAntiFlg=1
			}
		}
	}
	Set return=UseAntiFlg
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-11
/// Description:  获取一段时间内使用预防抗菌药物医嘱ID
/// Return：      医嘱ID,用逗号隔开
/// w ##class(DHCHAI.STATV2.AbstractComm).GetAntiOEDrList(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod GetAntiOEDrList(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=""
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","
	
	Set AntiOEDrList=""
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:(xSCode="")
		
		For xSttDate=aFromDate:1:aToDate {
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:(xID="")
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xID))
				Continue:$lg(OEOrdItemData,25)=0
				Set AntUsePurpose = $lg(OEOrdItemData,30)
				Continue:AntUsePurpose'["预防"
				//add 20221122 过滤抗菌药物对照中置无效的药品
				Set SCode   = $lg(OEOrdItemData,28)
	           	Set OrdDesc = $lg(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" //过滤未对照
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1
			    
				//add 20210528 过滤非全身用药
				Set Instruc = $lg(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))

				Set OESttDate = $lg(OEOrdItemData,15)   // 执行医嘱日期
				Set OESttTime = $lg(OEOrdItemData,16)   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set AntiOEDrList=AntiOEDrList_","_xID
			}
		}
	}
	Set:AntiOEDrList'="" AntiOEDrList=$e(AntiOEDrList,2,$l(AntiOEDrList))
	Set return = AntiOEDrList
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-12
/// Description:  获取一段时间内使用预防抗菌药物天数
/// Return：      使用抗菌药物天数
/// w ##class(DHCHAI.STATV2.AbstractComm).GetUesAntiDays(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod GetUesAntiDays(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","

	Set MinDate=+$h
	Set MaxDate=0
	Set UseAntiFlag=0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:(xSCode="")
		
		For xSttDate=aFromDate:1:aToDate {
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:(xID="")
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xID))
				Continue:$lg(OEOrdItemData,25)=0
				Set AntUsePurpose = $lg(OEOrdItemData,30)
				Continue:AntUsePurpose'["预防"
				
				Set SCode   = $lg(OEOrdItemData,28)
	           	Set OrdDesc = $lg(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID="" //过滤未对照
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1
				//add 20210528 过滤非全身用药
				Set Instruc = $lg(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set OESttDate = $lg(OEOrdItemData,15)   // 执行医嘱日期
				Set OESttTime = $lg(OEOrdItemData,16)   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set OEXDate = $lg(OEOrdItemData,17)       // 停止医嘱日期
				Set OEXTime = $lg(OEOrdItemData,18)       // 停止医嘱时间
				
				Set:OESttDate<MinDate MinDate=OESttDate
				//Set:OEXDate>MaxDate MaxDate=OEXDate
				Set UseAntiFlag=1
				Set OEPriority = $lg(OEOrdItemData,8)
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xSCode,"OEPriority",OEPriority)
                Continue:PriorityMap=""
             
				if ((PriorityMap = "S1")||(PriorityMap = "S2")||(PriorityMap = "OUT")){  //长期 、出院带药
					Set:OEXDate>MaxDate MaxDate=OEXDate
					Set:MaxDate=0 MaxDate=+$h
				}elseif (PriorityMap = "N"){  //临时、取药医嘱
					Set:xSttDate>MaxDate MaxDate=xSttDate
				}
			}
		}
	}
	Quit:UseAntiFlag'=1 return     // 无预防抗菌药物
	//Set:MaxDate=0 MaxDate=+$h      // 使用了预防抗菌药物,但都没有停止医嘱
	Set return=(MaxDate-MinDate)+1 // 如果无预防抗菌药物,加1也不影响两者之差
	Set:return<0 return=0
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-20
/// Description:  判断术后使用预防抗菌药物且24H内全部停药
/// Return：      1:24H内全部停药
/// w ##class(DHCHAI.STATV2.AbstractComm).GetEndAntiFlag(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod GetEndAntiFlag(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=""
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set:InstrucList'="" InstrucList=","_InstrucList_","

	// 手术结束时间24H后的时间 数字格式
	Set ChangeDateInfo = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(aFromDate,+aFromTime,"24","")
	Set Date1 = $p(ChangeDateInfo,",",1)
	Set Time1 = $p(ChangeDateInfo,",",2)
	Set NoFlag=""
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:((xSCode="")||(NoFlag=1))
		For xSttDate=aFromDate:1:aToDate {
			Set xID = ""
			Quit:(NoFlag=1)
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:((xID="")||(NoFlag=1))
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xID))
				Continue:$lg(OEOrdItemData,25)=0
				Set AntUsePurpose = $lg(OEOrdItemData,30)
				Continue:AntUsePurpose'["预防"
				Set SCode   = $lg(OEOrdItemData,28)
	           	Set OrdDesc = $lg(OEOrdItemData,4)	        
	           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
				Continue:AntiMapID=""
			    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
			    Continue:$lg(AntiMapData,7)'=1
				
				//add 20210528 过滤非全身用药
				Set Instruc = $lg(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xSCode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				Set OESttDate = $lg(OEOrdItemData,15)   // 执行医嘱日期
				Set OESttTime = $lg(OEOrdItemData,16)   // 执行医嘱时间
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(OESttTime<aFromTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(OESttTime>aToTime))
				}
				Set OEXDate    = $lg(OEOrdItemData,17)      // 结束医嘱日期
				Set OEXTime    = $lg(OEOrdItemData,18)      // 结束医嘱时间
				Set OEPriority = $lg(OEOrdItemData,8)       // 医嘱类型
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xSCode,"OEPriority",OEPriority)
                Continue:PriorityMap=""
                
				If (PriorityMap="N"){
					Set OEXDate = OESttDate
					Set OEXTime = OESttTime
				}
				If (OEXDate=""){
					Set NoFlag=1   // 未停药
				}Else{
					If (OEXDate>Date1){
						Set NoFlag=1   // 未停药
					}ElseIf (OEXDate=Date1){
						If (OEXTime>Time1){
							Set NoFlag=1   // 未停药
						}
					}Else{}
				}
			}
		}
	}
	Set:NoFlag="" return=1
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-07-20
/// Description:  判断术后使用预防抗菌药物且24H后所在那天的后一天内未使用预防用药
/// Return：      1:未使用预防抗菌药物(相当于停药)
/// w ##class(DHCHAI.STATV2.AbstractComm).GetEndAntiFlag2(3,"2017-07-13","00:23:00")
ClassMethod GetEndAntiFlag2(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime)
	Set return=""
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Quit:(aFromDate="") return
	
	// 手术结束时间24H后的时间 数字格式
	Set ChangeDateInfo = ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(aFromDate,+aFromTime,"24","")
	Set Date1 = $p(ChangeDateInfo,",",1)
	// 术后24H后所在那天的后一天是否使用预防抗菌药物
	Set Date2=Date1+1
	Set UseAntiFlag=..CheckUesAnti(aEpisodeDr,Date2,"00:00:00",Date2,"23:59:59")
	Set:UseAntiFlag'=1 return=1
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2019-11-19
/// Description:  获取一段时间内的出院人数
/// Return：      出院患者信息Array
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetDishPatient("64649","65012")
ClassMethod GetDishPatient(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aLocID As %String = "") As %Library.ArrayOfDataTypes
{
	new (aHospIDs,aDateFrom,aDateTo,aLocType,aLocID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set ExAdmList=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	Set xAdmType = "",Count=0
    For {
		Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")	//&&(xAdmType'="EP")[急诊单独统计]
		For xDishDate = aDateFrom:1:aDateTo{
			Set xDishTime = ""
			For {
				Set xDishTime = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime))
				Quit:xDishTime=""
				
				Set xPaadm = ""
				For {
					Set xPaadm = $o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDishDate,xDishTime,xPaadm))
					Quit:xPaadm=""
					
					Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(xPaadm))
					Continue:(PAAdmData="")
					//add 20221116 处理错误数据问题(有出院日期就诊状态不为D)
				    Set VisitStatus = $lg(PAAdmData,19)
				    Continue:(VisitStatus="P")||(VisitStatus="C")

                    //add 20230207剔除测试患者
                    Set ExcFlg= ##class(DHCHAI.STATV2.AbstractComm).ExcTestAdm(xPaadm,ExAdmList)
                    Continue:ExcFlg=1

					// 出院科室/病区
					Set DishLocID = $lg(PAAdmData,28)
				    Set DishWardID = $lg(PAAdmData,29)
				    Continue:(aLocType="E")&&(aLocID'="")&&(aLocID'=DishLocID)
				    Continue:(aLocType="W")&&(aLocID'="")&&(aLocID'=DishWardID)
				    
					Set LocData = $g(^DHCHAI.BT.LocationD(DishLocID))
					Set HospDr=$lg(LocData,8)
					//院区过滤
					Continue:(aHospIDs'="")&($lf(aHospIDs,HospDr)<1)
					Set GroupDr  = $lg(LocData,7)
					If GroupDr="" {
						Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
					}
					//就诊开始结束日期
					Set AdmDate = $lg(PAAdmData,20)
					Set DischDate = $lg(PAAdmData,26)
					Set AdmInfo=$lb(xPaadm,HospDr,GroupDr,DishLocID,DishWardID,AdmDate,DischDate)
					Set Count=Count+1
					Do return.SetAt(AdmInfo,Count)
				}
			}
		}
    }
    Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-09-23
/// Description:  取询患者转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetTransInfo(791,$zdh("2020-06-01",3),$zdh("2020-06-30",3),"W")
ClassMethod GetTransInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aLocType As %String = "", aLocID As %String = "") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aLocType,aLocID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()

	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	Set Count=0
	
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		Continue:(aDateFrom'="")&(xDate<aDateFrom)
	    Continue:(aDateTo'="")&(xDate>aDateTo)

		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
		
			Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xID))
			Set TranLocDr   = $lg(TranData,5)
			Continue:TranLocDr=""
			Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
			Set TranLocDesc = $lg(TranLocData,3)
			Set TranLocDesc2 = $lg(TranLocData,4)
			Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
			
			Set TransBedDr  = $lg(TranData,6)
		    Set TransDate	= $lg(TranData,7)
		    Set OutLocDate	= $lg(TranData,10)
		    Set TransTime	= $lg(TranData,8)
			Set OutLocTime	= $lg(TranData,11)
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:TransTime'="" TransTime =$zt(TransTime)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set:OutLocTime'="" OutLocTime =$zt(OutLocTime)
			Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
			Set AdmInfo=$lb(xID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
			Set Count=Count+1
			Do return.SetAt(AdmInfo,Count)
		}
			
	}
	
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2019-11-19
/// Description:  获取病人送检信息
/// Return：      微生物送检信息Array
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetLabInfo(599,$zdh("2020-05-01",3),$zdh("2020-05-31",3),"","","",76226,3620)
ClassMethod GetLabInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aSpecimen As %String = "", aTestSetCat As %String = "", aStaOELab As %String = "", aTimeFrom As %String = "", aTimeTo As %String = "", aLabSubType As %String = "", aSubDateType As %String = "") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aTestSetCat,aDateFrom,aDateTo,aSpecimen,aStaOELab,aTimeFrom,aTimeTo,aLabSubType,aSubDateType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	//送检项目名称
	Set:aTestSetCat'="" TestSetList=aTestSetCat
	Set:aTestSetCat="" TestSetList = ##class(DHCHAI.BT.Config).GetValByCode("LabTestSetList")
	Set:TestSetList'="" TestSetList=","_TestSetList_","	
	Set TestSetList =$tr(TestSetList,"，",",")
	
	Set EpisodeList =""
	If (aStaOELab=1) {
		Set xBookID=""
    	For {
	    	Set xBookID=$o(^MA.HAI.DP.PADocBookingI("IndexEpisodeDr",aEpisodeID,xBookID))
	    	Quit:xBookID=""
	    	
	    	Set BookData=$g(^MA.HAI.DP.PADocBookingD(xBookID))
	    	Continue:BookData=""
	    	Set EpisodeIDF = $lg(BookData,3)    //门诊就诊ID 
	    	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeIDF))
			Continue:(PAAdmData="")
			Set AdmDate=$lg(PAAdmData,20)
			Set AdmTime=$lg(PAAdmData,21)
			Set:(aDateFrom'="")&(AdmDate<aDateFrom) aDateFrom=AdmDate   //取门诊就诊日期
			Set:(aTimeFrom'="")&(AdmTime<aTimeFrom) aTimeFrom=AdmTime   //取门诊就诊时间	   	
	    	Set EpisodeList=EpisodeList_$lb(EpisodeIDF)
    	}
	}
	Set EpisodeList=EpisodeList_$lb(aEpisodeID)

	Set Count=0
	For indexL=1:1:$ll(EpisodeList) {
		Set xEpisodeID=$lg(EpisodeList,indexL)
		Quit:xEpisodeID=""	
		Set xVisitNumberDr=""
		For {
			Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",xEpisodeID,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
			Continue:VisitData=""
			Set LabIsActive		=$lg(VisitData,18)
			Continue:LabIsActive'=1
			Set SCode 			=$lg(VisitData,14)
			Set CollDate 		=$lg(VisitData,8)				//采集日期
			Set CollTime		=$lg(VisitData,9)				//采集时间
			Set EpisodeNo		=$lg(VisitData,3)   			//标本号
			Set RecDate 		=$lg(VisitData,11)				//接收日期
			Set RecTime 		=$lg(VisitData,12)				//接收时间
			Set Specimen 		=$lg(VisitData,6)
			Continue:(aSpecimen'="")&(Specimen'[aSpecimen)
			Set CollDate=$s(CollDate'="":CollDate,1:RecDate)	//送检日期优先用采集日期
			Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
			If (aSubDateType="2") {				//医嘱开立日期
				Set (OrdID,SubID,OEOrdDate,OEOrdTime)=""
				Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
				Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
				Set OEOrdDate=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",7) 			//开医嘱日期（OEORI_Date）
				Set OEOrdTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",17)			//开医嘱时间（OEORI_TimeOrd）
				Continue:(aDateFrom'="")&(OEOrdDate'="")&(OEOrdDate<aDateFrom)
				Continue:(aDateTo'="")&(OEOrdDate'="")&(OEOrdDate>aDateTo)
				Continue:(aTimeFrom'="")&(OEOrdTime'="")&(OEOrdDate=aDateFrom)&(OEOrdTime<aTimeFrom)
				Continue:(aTimeTo'="")&(OEOrdTime'="")&(OEOrdDate=aDateTo)&(OEOrdTime>aTimeTo)
			}Else {
				Continue:CollDate=""
				Continue:(aDateFrom'="")&(CollDate<aDateFrom)
				Continue:(aDateTo'="")&(CollDate>aDateTo)
				Continue:(aTimeFrom'="")&(CollDate=aDateFrom)&(CollTime<aTimeFrom)
				Continue:(aTimeTo'="")&(CollDate=aDateTo)&(CollTime>aTimeTo)
			}
			//标本名称对照
			Set MapID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
			Set LabSpecMapData=$lb("","","","","","","","","")
			Set:MapID'="" LabSpecMapData=$g(^DHCHAI.DP.LabSpecMapD(MapID))
			Set MapActive	=$lg(LabSpecMapData,6)
			Set MapItemDr	=$lg(LabSpecMapData,3)
			if (MapItemDr'="")&&(MapActive=1) {
				Set MapItemData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
				If (MapItemData'=""){
					Set MapItemActive=$lg(MapItemData,5)
					Set:MapItemActive Specimen = $lg(MapItemData,3)
				}
			}
		
			Set xTestSetDesc = "",CheckFlg=0
			For {
				Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
				Quit:xTestSetDesc=""
				Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,0))
				if (TestSetMapID'=""){
					Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
					Continue:TestSetMapData=""
					Continue:'$lg(TestSetMapData,7) 		//无效判断
					Set TSMapItemDr=$lg(TestSetMapData,4)
					Set TSMapItemData=""
					Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))				
					If (TSMapItemData'="") {    //检验医嘱对照
						Continue:'$lg(TSMapItemData,5)	//无效判断
						Set TestSet	= $lg(TSMapItemData,3)	
						Continue:(TestSetList'="")&&(TestSetList'[(","_TestSet_","))
						Set CheckFlg = 1
						Quit
					}				
				}
			}
			
			If (CheckFlg=0) {  //检查检验项目是否存在于检验结果中
				Set xTestSetDr=""
				For {
					Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
					Quit:xTestSetDr=""
					Quit:CheckFlg=1
					
					//最新检验报告
					Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
					Quit:xOrder=""
					Set xVisitReportDr=0
					For {
						Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
						Quit:xVisitReportDr=""
						Quit:CheckFlg=1
						
						Set xTestCode=""
						For {
							Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
							Quit:xTestCode=""
							Quit:CheckFlg=1
						
							Set xMapItemDr=0
							For {
								Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
								Quit:xMapItemDr=""
								
								Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
								
								Continue:TSMapItemData=""	  //检验医嘱对照
								Continue:'$lg(TSMapItemData,5)	//无效判断
								Set TestSet	= $lg(TSMapItemData,3)
								Continue:(TestSetList'="")&&(TestSetList'[(","_TestSet_","))
								Set CheckFlg = 1
								Quit										
							}
						}
					}
				}
			}
			Continue:CheckFlg=0	//过滤非指定类型的送检
			
			Set LabInfo=$lb(xVisitNumberDr,CollDate,Specimen,SCode,EpisodeNo,CollTime,TestSet)
			Set Count=Count+1
			Do return.SetAt(LabInfo,Count)
		}	
	}
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2019-11-22
/// Description:  获取病人送检结果信息
/// Return：      微生物送检结果信息Array
/// Input		  aVisitNumber:检验标本Dr
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetLabResultInfo(18)
ClassMethod GetLabResultInfo(aVisitNumber As %String) As %Library.ArrayOfDataTypes
{
	new (aVisitNumber)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:aVisitNumber="" return
	Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(aVisitNumber))
	Quit:VisitData="" return
	Set SCode =$lg(VisitData,14)
   	Set xTestSetDr="",Count=0
	For {
		Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumber,xTestSetDr))
		Quit:xTestSetDr=""
		
		//最新检验报告
		Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumber,xTestSetDr,""),-1)
		Set xVisitReportDr=0
		For {
			Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitNumber,xTestSetDr,xOrder,xVisitReportDr))
			Quit:xVisitReportDr=""
			
				Set VisitReportData=$g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
				Continue:VisitReportData=""
				
				Set Status = $lg(VisitReportData,6)
				Continue:Status=6	//作废
				Set IsActive = $lg(VisitReportData,18)
				Continue:IsActive=0
				
				Set VisitReportID 	= xVisitReportDr
				Set LabReportID 	= $lg(VisitReportData,3)
				Set LabRepOrder 	= $lg(VisitReportData,4)
				Set AuthDate		= $lg(VisitReportData,10)
				Set AuthTime		= $lg(VisitReportData,11)
				Set:AuthDate'="" AuthDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AuthDate)
				Set:AuthTime'="" AuthTime=$zt(AuthTime,1)
				
				Set VisitTestSetDr	= $lg(VisitReportData,13)
				Continue:VisitTestSetDr=""
				Set VisitTestSetData=$g(^DHCHAI.DP.LabVisitTestSetD(VisitTestSetDr))
				Set TestSetDesc	= $lg(VisitTestSetData,3)
				Set OrdTsDesc	= $lg(VisitTestSetData,5)
				Set xResultID="",ResultList=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
					Quit:xResultID=""
					Set ResultData=$g(^DHCHAI.DP.LabVisitRepResultD(xResultID))
					Continue:ResultData=""
					Set RstFormat	= $lg(ResultData,5)
					Continue:RstFormat=""
					Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
					Continue:MapRstFormat=""
					Continue:MapRstFormat'="M"
					Set Bacteria	= $lg(ResultData,6)
					Continue:Bacteria=""
					Continue:(Bacteria["阴性")||(Bacteria["-")
					Continue:(Bacteria["大于3种菌")
					Continue:(Bacteria["无")&&(Bacteria["生长")
					Continue:(Bacteria["未见")&&(Bacteria["菌")
					Continue:(Bacteria["未检出")&&(Bacteria["菌")
					Continue:$listfind(ResultList,Bacteria)>0  //判断是否同种菌
					Set ResultList=ResultList_$lb(Bacteria)		
				}
				Set ResultStr=""
				Set:ResultList'="" ResultStr=$lts(ResultList)
				Set LabInfo=$lb(xVisitReportDr,AuthDate,ResultStr)
				Set Count=Count+1
				Do return.SetAt(LabInfo,Count)
			}
		}	
	Quit return
}

/// Creator：     zhugz
/// CreatDate：   2022-06-09
/// Description:  判断体温异常
/// Return：      1：体温异常    0：体温正常
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetFeverAbno(18,"2018-03-01","2018-12-31")
ClassMethod GetFeverAbno(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Set Count=0
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
    Set ItmMastID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","MR-ObsFever",0))
    Set ItmMastData=$g(^DHCHAI.IR.CCItmMastD(ItmMastID))
    Quit:ItmMastData="" return
    Set ItemID=ItmMastID
    Quit:ItemID="" return
    
	For xDate=aDateFrom:1:aDateTo {
		Quit:return=1
 		Set xID=0
		For {
	 		Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,ItemID,xDate,xID))
	 		Quit:(xID="")||(return=1)
	 		Set RtlData	= $g(^DHCHAI.IR.CCResultD(xID))
	 		Continue:RtlData=""
			Continue:'$lg(RtlData,14) //无效判断
	 		Set KeyDr 	= $lg(RtlData,20)
	 		Continue:KeyDr=""
	 		Set KeyData	= $g(^DHCHAI.IR.CCKeyWordD(KeyDr))
 			Set CCDesc	= $lg(KeyData,2)
 			Continue:CCDesc'="发热"
 			Set Result=$lg(RtlData,4)
 			Set ActDate=$lg(RtlData,8)
 			Set ActTIme=$lg(RtlData,9)
 			Set AbnoInfo=$lb(Result,ActDate,ActTIme)
 			Set Count=Count+1
 			Do return.SetAt(AbnoInfo,Count)
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-14
/// Description:  取现患感染信息
/// Table：       DHCHAI.IR.INFCSS、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aEpisodeID：就诊ID
///               aInfType:（医院感染，社区感染）
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.AbstractComm).GetCSSInfDianosInfo(4,"46","医院感染")
ClassMethod GetCSSInfDianosInfo(aSurNumID As %String, aEpisodeID As %String, aInfType As %String = "") As %String
{
    New (aSurNumID,aEpisodeID,aInfType)
    Set return=""
    Quit:(aSurNumID="")||(aEpisodeID="") return
    Quit:'..CheckCssRep(aSurNumID,aEpisodeID) return
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    Set CSSInfFlag=0,CSSInfPos=""
    Set xCSSID=0
    For {
        Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
        Quit:xCSSID=""
        
        Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
        Continue:CSSData=""
        Continue:$lg(CSSData,5)'=1
        Continue:$lg(CSSData,6)=""
        Set InfCategory = ""
        Set IRInfCategoryDr=$lg(CSSData, 7)
        Set:IRInfCategoryDr'="" InfCategory = $lg($g(^DHCHAI.BT.DictionaryD(IRInfCategoryDr)),3)
        Set InfectionDesc = $lg($g(^DHCHAI.BT.DictionaryD($lg(CSSData,6))),3)
        Set:InfectionDesc="不存在" InfCategory=""
        Continue:'..CheckInfType(aInfType,InfCategory)
        //过滤删除的报告
        Set ReportID=""
        Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
        For indRep=1:1:arrReport.Count() {
            Set RepData=arrReport.GetAt(indRep)
            Continue:RepData=""
            Set ReportID=$lg(RepData,1)
            Set IRStatusDr=$lg(RepData,8)
            Continue:IRStatusDr=""
            Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
            //1保存、2提交、3审核、4作废、5退回、6取消审核
            Continue:(RepStatus="4")
        }
        // 感染诊断信息
        Set CSSInfPos=""
        // 医院感染信息
        Set IRInfPathogen1 = $lg(CSSData, 8)
        Set IRInfPathogen2 = $lg(CSSData, 9)
        Set IRInfPathogen3 = $lg(CSSData, 10)
        Set InfPosDr1 = $p(IRInfPathogen1,"#",1)
        Set InfPosDr2 = $p(IRInfPathogen2,"#",1)
        Set InfPosDr3 = $p(IRInfPathogen3,"#",1)
        Set InfPosDesc1="",InfPosDesc2="",InfPosDesc3=""
        if (+CSSRepPosDispalyConfig=0){
            Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr1)),3)
            Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr2)),3)
            Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr3)),3)
        }else{
             Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr1)),3)
            Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr2)),3)
            Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr3)),3)
        }
        
        Set:InfPosDesc1'="" CSSInfPos=InfPosDesc1
        Set:InfPosDesc2'="" CSSInfPos=CSSInfPos_"^"_InfPosDesc2
        Set:InfPosDesc3'="" CSSInfPos=CSSInfPos_"^"_InfPosDesc3 
        Set:CSSInfPos="^^" CSSInfPos=""
        Set:CSSInfPos="^" CSSInfPos=""
        // 社区感染信息
        Set CSSComInfPos=""
        Set IRComInfPathogen1 = $lg(CSSData, 12)
        Set IRComInfPathogen2 = $lg(CSSData, 13)
        Set IRComInfPathogen3 = $lg(CSSData, 14)
        Set InfPosDr1 = $p(IRComInfPathogen1,"#",1)
        Set InfPosDr2 = $p(IRComInfPathogen2,"#",1)
        Set InfPosDr3 = $p(IRComInfPathogen3,"#",1)
        Set InfPosDesc1="",InfPosDesc2="",InfPosDesc3=""

        if (+CSSRepPosDispalyConfig=0){
            Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr1)),3)
            Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr2)),3)
            Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr3)),3)
        }else{
            Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr1)),3)
            Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr2)),3)
            Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr3)),3)
        }
        Set:InfPosDesc1'="" CSSComInfPos=InfPosDesc1
        Set:InfPosDesc2'="" CSSComInfPos=CSSComInfPos_"^"_InfPosDesc2
        Set:InfPosDesc3'="" CSSComInfPos=CSSComInfPos_"^"_InfPosDesc3 
        Set:CSSComInfPos="^^" CSSComInfPos=""
        Set:CSSComInfPos="^" CSSComInfPos=""
        
        Set:InfectionDesc="不存在" CSSInfPos="",CSSComInfPos=""
        Set return=ReportID_"!!"_xCSSID_"!!"_CSSInfPos_"!!"_CSSComInfPos_"!!"_InfCategory
    }
    Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-06-09
/// Description:  根据感染诊断描述取对应部位描述
/// Table：       DHCHAI.BT.InfPos
/// Input：       aDesc : DHCHAI.BT.InfPos.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.STATV2.AbstractComm).GetDescByDesc("心内膜炎")
ClassMethod GetDescByDesc(aDesc As %String, CSSRepPosDispalyConfig As %String = "") As %String
{
    New (aDesc,CSSRepPosDispalyConfig)

    Set return=""
    Quit:(aDesc="") return
    if CSSRepPosDispalyConfig="" {
        Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    }
    if (+CSSRepPosDispalyConfig=0){
         Set PosDesc =aDesc
    }else{
        Set ID=$o(^DHCHAI.BT.InfPosI("IdxofDesc",aDesc,0))
        Set InfPosData=$g(^DHCHAI.BT.InfPosD(ID))
        Quit:(InfPosData="") return
        Set PosCode=$lg(InfPosData,2)
        Set BigCode=$e(PosCode,1,2)
        Set DiagID=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
        Set DiagData=$g(^DHCHAI.BT.InfPosD(DiagID))
        Quit:(DiagData="") return
        Set PosDesc=$lg(DiagData,3)
    }
    
    
    Quit PosDesc
}

/// Creator：     zhoubo
/// CreatDate：   2020-04-08
/// Description:  根据就诊号和手麻记录ID获取院感报卡与手术切口调查表的手术信息
/// Table：       DHCHAI.IR.INFOPS
/// Input：       aEpisodeDr : DHCHAI.DP.PAAdm.ID
///               aOperAnaesID: DHCHAI.DP.OROperAnaes.ID
/// Return：      返回String
/// w ##class(DHCHAI.STATV2.AbstractComm).GetOPSDataByAnaesDr("5606","1402")
ClassMethod GetOPSDataByAnaesDr(aEpisodeDr As %String, aOperAnaesID As %String) As %String
{
	New (aEpisodeDr,aOperAnaesID)
	Set return=""
	Quit:((aEpisodeDr="")||(aOperAnaesID="")) return
	//首先判断是否关联院感报卡或者手术切口调查表
	Set InfOpsDr = $o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",aEpisodeDr,aOperAnaesID,""))
	Set (OperName,OperName2,OperLocDr,OperStatus,OperDate,EndDate,SttTime,EndTime,OperHours,OperDocTxt,OperDocDr)=""
	Set (Assistant1,Assistant2,OperLoc,OperType,ORAnesMethod,Incision,Healing,InfTypeDr,ASAScore)=""
	Set (IncisionNum,EndoscopeFlag,ImplantFlag,BloodLossFlag,BloodLoss,BloodTransFlag,BloodTrans,NNISGrade)=""
	If (InfOpsDr'=""){	
		Set INFOPSData = $g(^DHCHAI.IR.INFOPSD(InfOpsDr))
		Quit:INFOPSData="" return
		Set OperName   = $lg(INFOPSData,4)
		Set OperName2  = $lg(INFOPSData,5)
		Set OperLocDr  = $lg(INFOPSData,6)
		Set OperDate   = $lg(INFOPSData,7)
		Set EndDate    = $lg(INFOPSData,8)
		Set SttTime    = $lg(INFOPSData,9)
		Set EndTime    = $lg(INFOPSData,10)
		Set OperHours  = $lg(INFOPSData,11)
		Set OperDocTxt = $lg(INFOPSData,12)
		Set OperDocDr  = $lg(INFOPSData,13)
		Set OperTypeDr = $lg(INFOPSData,14)
		If (OperTypeDr'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(OperTypeDr))
			Set:TypeData'="" OperType=$lg(TypeData,3)
		}
		Set AnesthesiaDr = $lg(INFOPSData,15)
		If (AnesthesiaDr'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(AnesthesiaDr))
			Set:TypeData'="" ORAnesMethod=$lg(TypeData,3)
		}
		Set NNISLevelDr = $lg(INFOPSData,16)
		If (NNISLevelDr'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(NNISLevelDr))
			Set:TypeData'="" NNISGrade=$lg(TypeData,3)
			
		}else{
			Set OPSAnaesData = $g(^DHCHAI.DP.OROperAnaesD(aOperAnaesID))
			Quit:OPSAnaesData="" return
			Set OperDate   = $lg(OPSAnaesData,6)
			Set SttTime    = $lg(OPSAnaesData,7)
			Set EndDate    = $lg(OPSAnaesData,8)
			Set EndTime    = $lg(OPSAnaesData,9)
			Set OperHours  = $lg(OPSAnaesData,10)
			Set Incision   = $lg(OPSAnaesData,16)
			//愈合等级(取对照后数据)
			Set Healing    = $lg(OPSAnaesData,17)
			Set MapHealing=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
			Set:MapHealing'="" Healing=$p(MapHealing,"^",3)
			//手术方法
			Set AnesMethod = $lg(OPSAnaesData,18)
			Set Anesthesia = $lg(OPSAnaesData,19)
			//ASA评分(取对照后数据)
			Set ASAScore   = $lg(OPSAnaesData,20)
			//NNIS等级(取对照后数据)
			Set NNISGrade  = $lg(OPSAnaesData,21)

			//NNIS计算--1:手术时长
			If OperHours=""{
				Set OperHours=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,SttTime,EndDate,EndTime)
			}
			//NNIS计算--2:手术切口等级
			Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
			If (IncisionInfo'="") {
				Set MapIncDicCode = $p(IncisionInfo,"^",2)
				Set MapIncDicDesc = $p(IncisionInfo,"^",3)
			}Else {
				Set MapIncDicCode = ""
				Set MapIncDicDesc = Incision
			}
			//NNIS计算--3:ASA评分
			Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","ASAScore",ASAScore)  
			If (ASAScoreInfo'="") {
				Set MapASADicCode = $p(ASAScoreInfo,"^",2)
				Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
			}Else {
				Set MapASADicCode = ""
				Set MapASADicDesc = ASAScore
			}
			// 接口抓取NNIS等级
			Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","NNISLevel",NNISGrade)  
			If (NNISGradeInfo'="") {
				Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
				Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
			}Else {
				Set MapNNISDicCode = ""
				Set MapNNISDicDesc = NNISGrade
			}
			// 如果接口获取NNIS为空则根据公式自动计算
			If (MapNNISDicDesc="") {
				Set:OperHours>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1				//时长超过3小时
				Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1		//切口等级Ⅲ,Ⅳ
				Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
				Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1		//ASA评分超过2
			}
			Set NNISGrade=+MapNNISDicDesc
			Set:NNISGrade'["级" NNISGrade=NNISGrade_"级"
		}
		Set CuteTypeDr = $lg(INFOPSData,17)
		If (CuteTypeDr'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(CuteTypeDr))
			Set:TypeData'="" Incision =$lg(TypeData,3)
		}
		Set CuteHealingDr = $lg(INFOPSData,18)
		If (CuteHealingDr'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(CuteHealingDr))
			Set Healing=$lg(TypeData,3)
		}
		Set IsOperInf   = $lg(INFOPSData,19)
		Set InfTypeDr   = $lg(INFOPSData,20)
		Set IsInHospInf = $lg(INFOPSData,21)
		Set ASAScore = $lg(INFOPSData,22)
		If (ASAScore'=""){
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(ASAScore))
			Set ASAScore=$lg(TypeData,3)
		}
		Set PreoperWBC      = $lg(INFOPSData,23)
		Set IncisionNum     = $lg(INFOPSData,24)
		Set EndoscopeFlag   = $lg(INFOPSData,25)
		Set ImplantFlag     = $lg(INFOPSData,26)
		Set PreoperAntiFlag = $lg(INFOPSData,27)
		Set BloodLossFlag   = $lg(INFOPSData,28)
		Set BloodLoss       = $lg(INFOPSData,29)
		Set BloodTransFlag  = $lg(INFOPSData,30)
		Set BloodTrans      = $lg(INFOPSData,31)
		Set PostoperComps   = $lg(INFOPSData,32)
		Set UpdateDate      = $lg(INFOPSData,33)
		Set UpdateTime      = $lg(INFOPSData,34)
		Set UpdateUserDr    = $lg(INFOPSData,35)
	}Else{
		Set OPSAnaesData = $g(^DHCHAI.DP.OROperAnaesD(aOperAnaesID))
		Quit:OPSAnaesData="" return
		Set OperName   = $lg(OPSAnaesData,4)
		Set OperType   = $lg(OPSAnaesData,5)
		Set OperStatus = $lg(OPSAnaesData,34)
		Set OperDate   = $lg(OPSAnaesData,6)
		Set SttTime    = $lg(OPSAnaesData,7)
		Set EndDate    = $lg(OPSAnaesData,8)
		Set EndTime    = $lg(OPSAnaesData,9)
		Set OperHours  = $lg(OPSAnaesData,10)
		Set OperLocDr  = $lg(OPSAnaesData,11)
		Set OperLoc    = $lg(OPSAnaesData,12)
		Set OperDocTxt = $lg(OPSAnaesData,13)
		Set Assistant1 = $lg(OPSAnaesData,14)
		Set Assistant2 = $lg(OPSAnaesData,15)
		Set Incision   = $lg(OPSAnaesData,16)
		//愈合等级(取对照后数据)
		Set Healing    = $lg(OPSAnaesData,17)
		Set MapHealing=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteHealing",Healing)
		Set:MapHealing'="" Healing=$p(MapHealing,"^",3)
		//手术方法
		Set AnesMethod = $lg(OPSAnaesData,18)
		Set Anesthesia = $lg(OPSAnaesData,19)
		//ASA评分(取对照后数据)
		Set ASAScore   = $lg(OPSAnaesData,20)
		//NNIS等级(取对照后数据)
		Set NNISGrade  = $lg(OPSAnaesData,21)

		//NNIS计算--1:手术时长
		If OperHours=""{
			Set OperHours=##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(OperDate,SttTime,EndDate,EndTime)
		}
		//NNIS计算--2:手术切口等级
		Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","CuteType",Incision)  
		If (IncisionInfo'="") {
			Set MapIncDicCode = $p(IncisionInfo,"^",2)
			Set MapIncDicDesc = $p(IncisionInfo,"^",3)
		}Else {
			Set MapIncDicCode = ""
			Set MapIncDicDesc = Incision
		}
		//NNIS计算--3:ASA评分
		Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","ASAScore",ASAScore)  
		If (ASAScoreInfo'="") {
			Set MapASADicCode = $p(ASAScoreInfo,"^",2)
			Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
		}Else {
			Set MapASADicCode = ""
			Set MapASADicDesc = ASAScore
		}
		// 接口抓取NNIS等级
		Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase("OPS01","NNISLevel",NNISGrade)  
		If (NNISGradeInfo'="") {
			Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
			Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
		}Else {
			Set MapNNISDicCode = ""
			Set MapNNISDicDesc = NNISGrade
		}
		// 如果接口获取NNIS为空则根据公式自动计算
		If (MapNNISDicDesc="") {
			Set:OperHours>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1				//时长超过3小时
			Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1		//切口等级Ⅲ,Ⅳ
			Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
			Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1		//ASA评分超过2
		}
		Set NNISGrade=+MapNNISDicDesc
		Set:NNISGrade'["级" NNISGrade=NNISGrade_"级"
		Set PreoperWBC = $lg(OPSAnaesData,24)
		Set IncisionNum   = $lg(OPSAnaesData,25)
		Set EndoscopeFlag = $lg(OPSAnaesData,26)
		Set ImplantFlag   = $lg(OPSAnaesData,27)
		Set BloodLoss     = $lg(OPSAnaesData,28)
		Set BloodTrans    = $lg(OPSAnaesData,29)
		Set IsActive      = $lg(OPSAnaesData,31)
		Set UpdateDate    = $lg(OPSAnaesData,32)
		Set UpdateTime    = $lg(OPSAnaesData,33)
	}
	Set:EndDate'="" EndDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
	Set:EndTime'="" EndTime=$zt(EndTime)
	Set:OperDate'="" OperDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
	Set:SttTime'="" SttTime=$zt(SttTime)
	Set Data=$lb(OperName,OperName2,OperLocDr,OperStatus,OperDate,EndDate,SttTime,EndTime,OperHours,OperDocTxt,OperDocDr)
	Set Data=Data_$lb(Assistant1,Assistant2,OperLoc,OperType,ORAnesMethod,Incision,Healing,InfTypeDr,ASAScore)
	Set Data=Data_$lb(IncisionNum,EndoscopeFlag,ImplantFlag,BloodLossFlag,BloodLoss,BloodTransFlag,BloodTrans,NNISGrade)
	Quit Data
}

/// w ##class(DHCHAI.STATV2.AbstractComm).GetHospListByLogon("1")
ClassMethod GetHospListByLogon(aLogonHospID As %String) As %List
{
	New (aLogonHospID)
	Set return=""
	Quit:aLogonHospID="" return
	Set aLogonHospID = $p(aLogonHospID,"|",1)  //取第一个即可
	// Add by zhaoyj 2022-06-14 Global方式
	Set HospData=$g(^DHCHAI.BT.HospitalD(aLogonHospID))
	Quit:HospData="" $$$OK
	Set BTGroupDr=$lg(HospData,5)
	Quit:BTGroupDr="" $$$OK
	Set HospGrpID=BTGroupDr
	Set HospGrpDesc=$lg($g(^DHCHAI.BT.HospGroupD(BTGroupDr)),3)
	Quit:HospGrpID="" return
	
	Set HospIDs=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",HospGrpID,xID))
		Quit:xID=""
		
	    Set HospData=$g(^DHCHAI.BT.HospitalD(xID))
	    Continue:HospData=""
	    Continue:$lg(HospData,7)'=1
	    Set HospCode=$lg(HospData,2)
	    Set HospDesc=$lg(HospData,3)
	   	
	   	Set return=return_$lb(xID)
	}
	
	Quit return
}

// 快速选择日期时间(2021-06-02 ShenC)

/// Creator：     ShenC
/// CreatDate：   2021-06-02
/// Description:  加载最近10年
/// Table：       
/// Input:        aYear： 多个医院用"|"连接
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.AbstractComm","QryYear1")
Query QryYear() As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryYearExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//日期
	Set Year=$p($zd(+$h,3),"-",1)

	For xYear=Year:-1:(Year-9){
		Set Data=$lb(xYear,xYear_"年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryYearExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2021-06-02
/// Description:  加载月/季度
/// Table：       
/// Input:        aTypeID： 1:月,2:季度,3:年
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.JiuJMain","QryMonth",1)
Query QryMonth(aTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryMonthExecute(ByRef qHandle As %Binary, aTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if ((aTypeID="")||(aTypeID=1)){
		Set Data=$lb(1,"1月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(2,"2月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(3,"3月")
		Set ^CacheTemp(repid,ind)=Data
   	 	Set ind=ind+1	
    	Set Data=$lb(4,"4月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(5,"5月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(6,"6月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(7,"7月")
		Set ^CacheTemp(repid,ind)=Data
   	 	Set ind=ind+1
   	 	Set Data=$lb(8,"8月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(9,"9月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(10,"10月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(11,"11月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
   	 	Set Data=$lb(12,"12月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	if ((aTypeID="")||(aTypeID=2)){
		Set Data=$lb("JD1","一季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD2","二季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD3","三季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD4","四季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
    if ((aTypeID="")||(aTypeID=3)){
		Set Data=$lb("BN1","上半年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
     	Set Data=$lb("BN2","下半年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
     	Set Data=$lb("QN","全年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-06-14
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// 			  1.区分'普通感染'和'手术部位感染'
/// 			  2.'手术部位感染'判断时以实际手术日期为准[关联多条手术]
/// 			  3.区别于'GetInfPosInfo'方法,不进行替换,防止其他页面出现BUG
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息(DiagID^InfPosDesc^InfDate^InfXDate^InfEffect^PosDesc^InfType^InfLocDesc^RepDate^ReplaceFlag^RepUser^OPSID)
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfPosInfoNew("8217","65592","65622")
ClassMethod GetInfPosInfoNew(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	//通过就诊号查询历史病人信息(病人主索引)
	Set PatData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PatData="" return
				
	Set PatientIDx=$lg(PatData,3)
	Set xEpisodeID=""
	For{
		//根据病人主索引查询所有就诊号
		Set xEpisodeID=$o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",PatientIDx,xEpisodeID),-1)
		Quit:xEpisodeID=""
		
		//关联院感报告
		Set xRepType=""
		For {
			Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'="1")		//院感报告
		
			Set xID = ""
			For {
				Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,xRepType,xID))
				Quit:xID=""
			
				Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
				Quit:INFRepData=""
				Set RepStatus=$lg(INFRepData,8)
				Continue:RepStatus=""
				Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"			//只统计已审核报告
			
				//代报标志
				Set ReplaceFlag=$lg(INFRepData,16)
				//报告日期
				Set RepDate=$lg(INFRepData,4)
				//报告人
				Set RepUser=""
				Set RepUserDr=$lg(INFRepData,7)
				Set:RepUserDr'="" RepUser=$lg($g(^DHCHAI.BT.SysUserD(RepUserDr)),3)
				
				// 感染信息
				Set xSub=0
				For {
					Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
					Quit:xSub=""
		
					Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
					Continue:INFRepExtData=""
					Set DiagID=$lg(INFRepExtData,3)
					Continue:DiagID=""
					Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
					Continue:DiagsData=""
					Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				
					// 感染日期
					Set InfDate  = $lg(DiagsData,5)
					// 感染诊断
					Set InfPosDr = $lg(DiagsData,3)
					Continue:InfPosDr=""
					Set InfPosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),3)
					//1.手术部位感染，手术部位感染以实际手术日期为准][不走表DHCHAI.IR.INFLastAdm(当前就诊记录不存)
					If ((InfPosDesc="表浅手术切口感染")||((InfPosDesc="深部手术切口感染"))||((InfPosDesc="器官和腔隙感染"))){
						//手术日期不在统计范围	
						Set LinkOPS=""
						Set xOPSub=0
						For {
							Set xOPSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xOPSub))
							Quit:xOPSub=""
							
							Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xOPSub))
							Continue:INFRepExtData=""
							Set OPSID=$lg(INFRepExtData,3)
							Continue:OPSID=""
							Set OPSData = $g(^DHCHAI.IR.INFOPSD(OPSID))
							Continue:OPSData=""
							Set OperDate=$lg(OPSData,7)
							Continue:(OperDate<aDateFrom)||(OperDate>aDateTo)
						}
					}
					//2.非手术部位感染以感染日期为准[不统计历史信息]
					else{
						Continue:xEpisodeID'=aEpisodeID
						Continue:(InfDate<aDateFrom)||(InfDate>aDateTo)		//感染日期不在统计范围				
					}
				
					// 感染结束日期
					Set InfXDate  = $lg(DiagsData,7)
					// 感染部位
					Set PosCode=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),2)
					Set BigCode=$e(PosCode,1,2)
					Continue:BigCode=""
					Set DiagID=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
					Set DiagData=$g(^DHCHAI.BT.InfPosD(DiagID))
					Set PosDesc=$lg(DiagData,3)
					//感染类别
					Set InfType="医院感染"
					Set InfTypeCode=$lg(DiagsData,18)
					if (InfTypeCode'=""){
						Set:InfTypeCode=0 InfType="社区感染"
					}else{
						Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(xEpisodeID)),20)
			   			Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
					}
					//感染科室
					Set InfLocDesc=""
					Set IRInfLocDr=$lg(DiagsData,6)
					If (IRInfLocDr'=""){
						Set LocDesc2 = $lg($g(^DHCHAI.BT.LocationD(IRInfLocDr)),4)
						Set LocDesc  = $lg($g(^DHCHAI.BT.LocationD(IRInfLocDr)),3)
						Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
					}
					//转归情况
					Set InfEffect=""
					Set IRInfEffectDr=$lg(DiagsData,8)
					Set:IRInfEffectDr'="" InfEffect = $lg($g(^DHCHAI.BT.DictionaryD(IRInfEffectDr)),3)
					If (InfPosDr'=""){
						Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_InfPosDesc_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser
					}
				}
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Description:  计算漏报率:获取应报感染例数(出院趋势分析)
/// Creator：     liuzhenhe
/// CreatDate：   2022-08-24
/// Table：       
/// Input:                      
/// w ##class(DHCHAI.STATV2.AbstractComm).GetInfDiagRep(503)      
ClassMethod GetInfDiagRep(aPaadm As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
    new (aPaadm,aDateFrom,aDateTo)
    Set xDiaID="",InfPosDescs=""
    For {
        Set xDiaID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aPaadm,xDiaID))
        Quit:xDiaID=""

        Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(xDiaID))
        Continue:DiagsData=""
        Continue:$lg(DiagsData,3)=""  
        // 感染日期
        Set InfDate  = $lg(DiagsData,5)
        Set InfXDate  = $lg(DiagsData,7)
        Continue:(aDateTo'="")&&(InfDate>aDateTo)   //感染日期大于查询截止日期，非查询期间发生感染
        Continue:(aDateFrom'="")&&(InfDate<aDateFrom)  //感染日期小于查询开始日期
        //感染类别
        Set InfType="医院感染"
        Set InfTypeCode=$lg($g(^DHCHAI.IR.INFDiagnosD(xDiaID)),18)
        if (InfTypeCode'=""){
            Set:InfTypeCode=0 InfType="社区感染"
        }else{
            Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aPaadm)),20)
            Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
        }
        // 感染诊断
        Set InfPos = $lg(DiagsData,3)
        Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
        Set PosCode=$lg(InfPosData,2)
        Set BigCode=$e(PosCode,1,2)
        Set PosDiagData=""
        Continue:BigCode=""
		Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
		Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
		Set PosDesc=$lg(PosDiagData,3)
        //感染科室
        Set InfLocDesc=""
        Set IRInfLocDr=$lg(DiagsData,6)
        If (IRInfLocDr'=""){
            Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
            Set LocDesc2 = $lg(IRInfLocData,4)
            Set LocDesc  = $lg(IRInfLocData,3)
            Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
        }
        //转归情况
        Set InfEffect=""
        Set IRInfEffectDr=$lg(DiagsData,8)
        If (IRInfEffectDr'=""){
            Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
            Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
        }
        Set RepList=""
        Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiaID)
        Continue:arrInfRep.Count()<1 
        For indIR=1:1:arrInfRep.Count() {
            Set objInfRep=arrInfRep.GetAt(indIR)
            Continue:'$IsObject(objInfRep)
            Set RepFlag=1
            Set (ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
            If $IsObject(objInfRep.IRStatusDr) {
                Set ReportStatusID=objInfRep.IRStatusDr.%Id()
                Set ReportStatusCode=objInfRep.IRStatusDr.BTCode
                Set ReportStatusDesc=objInfRep.IRStatusDr.BTDesc
            }
            //1保存、2提交、3审核、4作废、5退回、6取消审核
            Continue:(ReportStatusCode'="3")
            //Continue:(ReportStatusCode=="5")
            //Continue:(InfRepType'=1)&(InfRepType'=2) //感染报告 新生儿感染报告
            Set ReportID=objInfRep.%Id()
            Continue:$listfind(RepList,ReportID)>0
                //报告日期
            Set RepDate=objInfRep.IRRepDate
            //报告人
            Set RepUser=""
            Set RepUserDr=objInfRep.IRRepUser
            
            Set:$IsObject(RepUserDr) RepUser=RepUserDr.BTDesc
            
            //代报标志
            Set ReplaceFlag=objInfRep.IRReplaceFlag
            If (InfPos'=""){
                Set InfPosDescs = InfPosDescs_"|"_xDiaID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_RepDate_"^"_ReplaceFlag_"^"_RepUser_"^"_ReportID
            }

        }
    }

       Quit InfPosDescs
}

/// Description:  判断横断面是否属于相关感染类型
/// Table：     DHCHAI.IR.INFCSS 
/// Input:      aInfType:查询时入参描述   bInfType：单报告感染类型描述（医院感染=医院 社区感染=社区）              
/// return:     对应以下5种情形
/// w ##class(DHCHAI.IRS.INFCSSSrv).CheckInfType("","") ；1
/// w ##class(DHCHAI.IRS.INFCSSSrv).CheckInfType("医院+社区","医院") ;0
/// w ##class(DHCHAI.IRS.INFCSSSrv).CheckInfType("医院+社区","医院+社区") ;1
/// w ##class(DHCHAI.IRS.INFCSSSrv).CheckInfType("医院感染","医院+社区") ;1 
/// w ##class(DHCHAI.IRS.INFCSSSrv).CheckInfType("医院+社区","医院") ;0
/// CreatDate：   2022-11-1
ClassMethod CheckInfType(aInfType, bInfType)
{
    Set return=0
    if aInfType'="" {
        if bInfType'="" {
           Set AType=$replace(aInfType,"感染","")
           Set BType=$replace(bInfType,"感染","")    //规范参数值，方便判定包含
           Set:BType[AType return=1  // 报告感染类型包含入参a,医院+社区[医院
        }else {
           Set return=0      //入参a不为空，报告感染类型b为空，过滤
        }
    }else {
        Set return=1    //入参a为空，无论b是什么，通过
    }
    Quit return
}

/// Description:  判断此患者在本次调查中是否存在有效的横断面调查报告
/// Table：     DHCHAI.IR.INFCSS 
/// Input:      aSurNumID  调查唯一标识
///             aEpisodeID  就诊唯一标识          
/// return:     w ##class(DHCHAI.STATV2.AbstractComm).CheckCssRep(3,1)
/// CreatDate：   2023-03-09
ClassMethod CheckCssRep(aSurNumID As %String, aEpisodeID As %String)
{
    new (aSurNumID,aEpisodeID)
    Set return=0
    Quit:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID)) return //不通过
    Set xCSSID=0
    For {
        Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
        Quit:xCSSID=""
        
        Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
        Continue:CSSData=""
        Continue:$lg(CSSData,5)'=1
        Continue:$lg(CSSData,6)=""

        //过滤删除的报告
        Set ReportID=""
        Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
        For indRep=1:1:arrReport.Count() {
            Set RepData=arrReport.GetAt(indRep)
            Continue:RepData=""
            Set ReportID=$lg(RepData,1)
            Set IRStatusDr=$lg(RepData,8)
            Continue:IRStatusDr=""
            Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
            //1保存、2提交、3审核、4作废、5退回、6取消审核
            Continue:(RepStatus="4")
            Set return=1
        }
    }
    Quit return
}

/// Creator：     liutao
/// CreatDate：   2023-02-23
/// Description:  取询患者转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetTransInformation(32395,$zdh("2022-02-01",3),$zdh("2022-02-28",3),"W","")
ClassMethod GetTransInformation(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aLocType As %String = "", aLocID As %String = "") As %Library.ArrayOfDataTypes
{
	new (aEpisodeID,aDateFrom,aDateTo,aLocType,aLocID)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()

	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	Set Count=0
	
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		Continue:(aDateFrom="")
	    Continue:(aDateTo'="")&(xDate>aDateTo)

		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
		
			Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(xID))
			Set TranLocDr   = $lg(TranData,5)
			Continue:TranLocDr=""
			Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
			Set TranLocDesc = $lg(TranLocData,3)
			Set TranLocDesc2 = $lg(TranLocData,4)
			Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
			
			Set TransBedDr  = $lg(TranData,6)
		    Set TransDate	= $lg(TranData,7)
		    Set OutLocDate	= $lg(TranData,10)
		    Set TransTime	= $lg(TranData,8)
			Set OutLocTime	= $lg(TranData,11)
			
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set:TransTime'="" TransTime =$zt(TransTime)
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set:OutLocTime'="" OutLocTime =$zt(OutLocTime)
			Set TransDateTime =TransDate_" "_TransTime
			Set OutLocDateTime =OutLocDate_" "_OutLocTime
					
			Set AdmInfo=$lb(xID,TranLocDr,TranLocDesc,TransDateTime,OutLocDateTime)
			
			Set Count=Count+1
			Do return.SetAt(AdmInfo,Count)
		}
			
	}
	
	Quit return
}

/// Creator：     liutao
/// CreatDate：   2023-03-15
/// Description:  取该条手术感染部位信息
/// Table：       DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID,aOperAnaesID:手术ID
/// return:       感染部位信息：InfPosDesc
/// w ##class(DHCHAI.STATV2.AbstractComm).GetOperPosInf("59623","59908")
ClassMethod GetOperPosInf(aEpisodeID As %String, aOperAnaesID As %String) As %String
{
	New (aEpisodeID,aOperAnaesID)
	
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aOperAnaesID="") return
	
	
	Set InfPosDescs=""
	Set xINFOPSID=""
	For{
		Set xINFOPSID=$o(^DHCHAI.IR.INFOPSI("IndexEpisodeOperDr",aEpisodeID,aOperAnaesID,xINFOPSID))
		
		Quit:xINFOPSID=""
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFOPS","U")," "_$zcvt(xINFOPSID,"U"),xRepID))
			Quit:xRepID=""
			
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
		
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xSub))
				Quit:xSub=""
				
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xRepID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""

				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				If (InfPos'=""){
					Set PosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPos)),3)
					Continue:((PosDesc'="表浅手术切口感染")&&((PosDesc'="深部手术切口感染"))&&((PosDesc'="器官和腔隙感染")))
					Set InfPosDescs=InfPosDescs_","_ PosDesc
					}
				
				}

			}

		}
		Set:InfPosDescs'="" InfPosDescs=$e(InfPosDescs,2,$L(InfPosDescs))
		Quit InfPosDescs
}

/// Creator：     zhufei
/// CreatDate：   2017-09-23
/// Description:  根据日期时间点，获取某日患者住院科室/病区/床位
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeDr : 就诊号
///               aDate : 日期
///               aTime : 时间
/// Return：      返回%String
/// w ##class(DHCHAI.STATV2.AbstractComm).GetTransInfoByDate("61538","66110","")
ClassMethod GetTransInfoByDateTime(aEpisodeDr As %String, aDate As %String, aTime As %String = "") As %String
{
	New (aEpisodeDr,aDate,aTime)
	Set return=""
	Quit:(aEpisodeDr="")||(aDate="") return
	
	//Set:aDate["-" aDate=$zdh(aDate,3)
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aTime[":" aTime=$zth(aTime,1)
	Set:aTime="" aTime=$zth("00:00:01",1)  //默认时间点为23:59:59  //默认时间点改为00:00:01
	
	Set TransLocDr="",TransWardDr="",TransBedDr="",TransWardID="",TransLocDesc=""
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		
		Set xDate=aDate+1
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate),-1)
			Quit:xDate=""
			Quit:(xTransType="E")&(TransLocDr'="")  //科室
			Quit:(xTransType="W")&(TransWardDr'="") //病区
			Quit:(xTransType="B")&(TransBedDr'="")  //床位
			
			Set xTime=$s(xDate=aDate:(+aTime+1),1:"")
			For {
				Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime),-1)
				Quit:xTime=""
				Quit:(xTransType="E")&(TransLocDr'="")  //科室
				Quit:(xTransType="W")&(TransWardDr'="") //病区
				Quit:(xTransType="B")&(TransBedDr'="")  //床位
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime,xTransID),-1)
					Quit:xTransID=""
					Quit:(xTransType="E")&(TransLocDr'="")  //科室
					Quit:(xTransType="W")&(TransWardDr'="") //病区
					Quit:(xTransType="B")&(TransBedDr'="")  //床位
					
					Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Continue:TransData=""
					Continue:$lg(TransData,5)=""
					Set TransDate=$lg(TransData, 7)
					Set TransTime=$lg(TransData, 8)
					Set TransType=$lg(TransData, 4)
					
					If TransType="E" {
						Set TransLocDr=$lg(TransData,5)
						Set TransLocDesc=$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),3)
					} ElseIf TransType="W" {
						Set TransWardDr=$lg(TransData,5)
						Set:TransWardDr'="" TransWardID=xTransID
					} ElseIf TransType="B" {
						//根据转床找病区，防止最新的被覆盖 add by 20171205 chenjb
						Set tTransWardDr=$lg(TransData,5)
						Set:tTransWardDr'="" TransWardDr=tTransWardDr
						Set:TransWardDr'="" TransWardID=xTransID
						Set:($lg(TransData,6)'="")&(TransBedDr="") TransBedDr=$lg(TransData, 6)
					}
				}
			}
		}
	}
	
	Set TransTypeList=""
	Set:TransLocDr="" TransTypeList=TransTypeList_$lb("E")  //科室
	Set:TransWardDr="" TransTypeList=TransTypeList_$lb("W") //病区
	Set:TransBedDr="" TransTypeList=TransTypeList_$lb("B")  //床位
	
	If TransTypeList'="" {
		For indTT=1:1:$listlength(TransTypeList) {
			Set xTransType=$listget(TransTypeList,indTT)
			Continue:xTransType=""
			
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,""))
			Continue:xDate=""
			Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,""))
			Continue:xTime=""
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime,0))
			Continue:xTransID=""
			
			Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
			Continue:TransData=""
			Continue:$lg(TransData,5)=""
			Set TransDate=$lg(TransData,7)
			Set TransTime=$lg(TransData,8)
			Set TransType=$lg(TransData,4)
			
			If TransType="E" {
				Set TransLocDr=$lg(TransData,5)
				Set TransLocDesc=$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),3)
			} ElseIf TransType="W" {
				Set TransWardDr=$lg(TransData,5)
				Set:TransWardDr'="" TransWardID=xTransID
			} ElseIf TransType="B" {
				//根据转床找病区，防止最新的被覆盖 add by 20171205 chenjb
				Set tTransWardDr=$lg(TransData,5)
				Set:tTransWardDr'="" TransWardDr=tTransWardDr
				Set:TransWardDr'="" TransWardID=xTransID
				Set:($lg(TransData,6)'="")&(TransBedDr="") TransBedDr=$lg(TransData,6)
			}
		}
	}
	Set (BedDesc,BedLocDr)=""
	Set BedLocDr=TransWardDr
	If TransBedDr'="" {
		Set BedData=$g(^DHCHAI.BT.PACBedD(TransBedDr))
		If (BedData'=""){
			Set BedDesc=$lg(BedData, 3)
			If ($lg(BedData,11)'=""){
				Set BedLocDr=$lg(BedData,11)
			}
		}
	}
	Set TranData	= $g(^DHCHAI.DP.PAAdmTransD(TransWardID))
	Set TranLocDr   = $lg(TranData,5)
	Quit:TranLocDr=""
	Set TranLocData = $g(^DHCHAI.BT.LocationD(TranLocDr))				
	Set TranLocDesc = $lg(TranLocData,3)
	Set TranLocDesc2 = $lg(TranLocData,4)
	Set:TranLocDesc2'="" TranLocDesc=TranLocDesc2
	
	Set TransBedDr  = $lg(TranData,6)
    Set TransDate	= $lg(TranData,7)
    Set OutLocDate	= $lg(TranData,10)
    Set TransTime	= $lg(TranData,8)
	Set OutLocTime	= $lg(TranData,11)
	
	Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
	Set:TransTime'="" TransTime =$zt(TransTime)
	Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	Set:OutLocTime'="" OutLocTime =$zt(OutLocTime)
	Set TransDateTime =TransDate_" "_TransTime
	Set OutLocDateTime =OutLocDate_" "_OutLocTime
			
	Set AdmInfo=TransWardID_"^"_TranLocDr_"^"_TranLocDesc_"^"_TransDateTime_"^"_OutLocDateTime
	Set return=AdmInfo
	
	Quit return
}

}
