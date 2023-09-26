Include webimport

IncludeGenerator webimport

/// 输血申请单和自体血采血申请单
Class web.DHCBldSymptom Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      wwh
/// CreatDate：    2011-5-18
/// Description:： 根据就诊号获取病人登记号
/// Table：        无
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatDebtorID(admID As %String) As %String
{
	
    S admID=$g(admID)
    S tDeli=$C(2)
    S ret=""
    Q:'$l(admID) ret
    S dFlag=$D(^PAADM(admID))
    Q:dFlag=0 ret
    S tData=$g(^PAADM(admID))
    Q:'$L(tData) ret
    
    S papmiDr=$P(tData,"^",1)
    S patType=$P(tData,"^",2)
    Q:'$l(papmiDr) ret
    Q:$D(^PAPER(papmiDr))=0 ret
    S ret=$P($g(^PAPER(papmiDr,"PAT",1)),"^",1)
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-18
/// Description:： 获取所有反应类型
/// Table：        DHC_BldSymptomType
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatInfo(recordID As %String, admID As %String) As %String
{
	N (recordID,admID)
	S recordID=$g(recordID),admID=$g(admID)
	S recordData=recordID_$C(2)_admID
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	zn dhcdata
	S ret=$$DoAction^DHCBldUtlReaction("QPATINFO",recordData,"")
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-18
/// Description:： 获取所有反应类型
/// Table：        DHC_BldSymptomType
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllSymptomType() As %String
{
	N
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	zn dhcdata
	S retVal=$$getall^DHCBldSymptomType()
	I retVal>0 {
		S index=""
		F{
			S index=$O(PLIST(index))
			Q:index=""
			S ret=ret_$g(PLIST(index))_$C(2)
		}	
	}
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2012-2-4
/// Description:： 获取记录单信息
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetRecordInfo(recordID As %String, admID As %String = "", userCode As %String = "") As %String
{
	N (recordID,admID,userCode)
	S recordID=$g(recordID),admID=$g(admID),userCode=$g(userCode)
	S recordData=recordID_$C(2)_admID
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	zn dhcdata
	S ret=$$DoAction^DHCBldUtlReaction("QRECORD",recordData,userCode)
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2012-2-16
/// Description:： 确定正常血袋
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod ConfirmNormalPack(packRowIDs As %String, admID As %String = "", userCode As %String = "") As %String
{
	N (packRowIDs,admID,userCode)
	S packRowIDs=$g(packRowIDs),admID=$g(admID),userCode=$g(userCode)
	S labdata=..GetLabDataNS()
	S recordData=packRowIDs_$C(2)_admID_$C(2)_labdata
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	zn dhcdata
	S ret=$$DoAction^DHCBldUtlReaction("CONFIRMNORMALPACK",recordData,userCode)
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-5-18
/// Description:： 获取所有血袋信息
/// Table：        
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetCurTransPacks(patAdmID As %String) As %String
{
	N (patAdmID)
	S ret=""
	Q:'$l(patAdmID) ret
	
	K ^TMP($ZN,$J)
	S patAdmCode=""
	F{
		S patAdmCode=$O(^TIND(5,patAdmID,patAdmCode))
		Q:'$l(patAdmCode)	
		S labno=""
		F{
			S labno=$O(^TIND(5,patAdmID,patAdmCode,labno))	
			Q:'$l(labno)
			D SetPackRowIDs(labno)
		}
    }
	I '$D(^TIND(5,patAdmID)) {
		S debtorID=..GetPatDebtorID(patAdmID)
		I $L(debtorID) {
			D SetPackRowIDsByDebtorID(debtorID)
		}
	}
	
	S labdata=..GetLabDataNS()
	S packMainID="",ret="",index=0,stFDeli=$C(3),stRDeli=$C(2)
	F{
		S packMainID=$O(^TMP($ZN,$J,"PACKS",packMainID))
		Q:'$l(packMainID)
		S packSubID=""
		F{
			S packSubID=$O(^TMP($ZN,$J,"PACKS",packMainID,packSubID))
			Q:'$l(packSubID)	
			Continue:'$D(^TBBP(packMainID,packSubID))
			Continue:$D(^[labdata]Dhcbbpackprice(packMainID,packSubID))&&($P($g(^[labdata]Dhcbbpackprice(packMainID,packSubID)),"\",6)="Y")
			S seq=+$g(^TMP($ZN,$J,"PACKS",packMainID,packSubID))
			s transCode=$P($G(^TBBP(packMainID,packSubID,"TRAN",seq)),"\",8)
			Continue:transCode'="T"
	   		S packData=$g(^TBBP(packMainID,packSubID))
	   		Continue:$D(^DHCBLDREACTIONi("PACK",packMainID,packSubID))'=0   //已处理的不良反应血袋
	   		Continue:$D(^DHCBLDREACTIONi("NORMALPACK",packMainID,packSubID))'=0   //已处理的正常血袋
	   		Continue:'$l(packData)
	   		S productDr=$P(packData,"\",4)
	   		S bldGroupDr=$P(packData,"\",5)
	   		S volume=$P(packData,"\",21)			//血量
	   		S packDesc=""		//描述
	   		S unit=""			//单位
	   		S productID=$P(packSubID," ",1)	 	//产品码
	   		S:'$L(productID) productID=productDr
	   		I $l(productDr),$D(^TTAB("BB-BP",productDr))'=0 {
		   		S packDesc=$P($g(^TTAB("BB-BP",productDr)),"\",1)
		   		S unit=$P($g(^TTAB("BB-BP",productDr,"REM",1)),"&",1) 
	   		}
	  		S bldGroup=""		//血型
	   		I $l(bldGroupDr),$D(^TTAB("BB-BG",bldGroupDr))'=0 {
		   		S bldGroup=$P($g(^TTAB("BB-BG",bldGroupDr)),"\",1)  
	   		}
	   		S index=index+1
       		S selected="false"	//是否选择
           
       		S ret=ret_index_stFDeli_packMainID_"||"_packSubID_stFDeli_packMainID_stFDeli_productID_stFDeli_packDesc_stFDeli
       		S ret=ret_bldGroup_stFDeli_volume_stFDeli_unit_stFDeli_selected_stRDeli
		}
	}
	
	K ^TMP($ZN,$J)
	Q ret
	
	//根据登记号查询血袋信息
SetPackRowIDsByDebtorID(debtorID)
	N (debtorID)
	Q:'$l(debtorID) 0
	S curDate=""
	F{
		S curDate=$O(^TBBPi("TR-Debtor",debtorID,curDate))
		Q:'$l(curDate)
		S curTime=""
		F{
			S curTime=$O(^TBBPi("TR-Debtor",debtorID,curDate,curTime))
			Q:'$l(curTime)
			S packMainID=""
			F{
				S packMainID=$O(^TBBPi("TR-Debtor",debtorID,curDate,curTime,packMainID))
				Q:'$l(packMainID)
				S packSubID=""
				F{
					S packSubID=$O(^TBBPi("TR-Debtor",debtorID,curDate,curTime,packMainID,packSubID))	
					Q:'$l(packSubID)
					S seq=""
					F{
						S seq=$O(^TBBPi("TR-Debtor",debtorID,curDate,curTime,packMainID,packSubID,seq))
						Q:'$l(seq)
						S oldSeq=+$g(^TMP($ZN,$J,"PACKS",packMainID,packSubID))
						I +seq>oldSeq {
							S ^TMP($ZN,$J,"PACKS",packMainID,packSubID)=seq	
						}	
					}
				}
			}	
		}	
	}	

	Q 0
	
	//根据检验号查询血袋信息
SetPackRowIDs(labno)
    N (labno)
    S labno=$g(labno)
    Q:'$l(labno) 0
	S tsCode=""
	F{
		S tsCode=$O(^TEPI(labno,1,tsCode))
		Q:'$l(tsCode)
		S tsCnt=""
		F{
			S tsCnt=$O(^TEPI(labno,1,tsCode,tsCnt))
			Q:'$l(tsCnt)
			S packMainID=""
			F{
				S packMainID=$O(^TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID))
				Q:'$l(packMainID)
				S packSubID=""
				F{
					S packSubID=$O(^TEPI(labno,1,tsCode,tsCnt,"BBP",packMainID,packSubID))	
					Q:'$l(packSubID)
					S debtorID=$p(^TEPI(labno),"\",18)
					S seq=$g(^TBBP(packMainID,packSubID,"AL",debtorID,labno_"||"_tsCode_"||"_tsCnt))
					S:$l(seq) ^TMP($ZN,$J,"PACKS",packMainID,packSubID)=seq
				}
			}	
		}
	}
	Q 0
}

/// Creator：      wwh
/// CreatDate：    2011-5-18
/// Description:： 获取所有血袋信息
/// Table：        
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatPack(packMainID As %String, patAdmID As %String, userCode As %String) As %String
{
	N (packMainID,patAdmID,userCode)
	S packMainID=$G(packMainID),patAdmID=$G(patAdmID),userCode=$G(userCode)
	S deli=$C(2)
	S ret=1_deli_""
	Q:'$l(packMainID) ret
	S debtorID=##class(web.DHCLabUtlCore).GetDebtorNoByAdm(patAdmID)
	S labdata=..GetLabDataNS()
	S packSubID="",stFDeli=$C(3),stRDeli=$C(2),storePackInfo="",fieldDeli=$C(2),index=0
	F{
		S packSubID=$O(^TBBP(packMainID,packSubID))
		Q:'$l(packSubID)
		Continue:$D(^[labdata]Dhcbbpackprice(packMainID,packSubID))&&($P($g(^[labdata]Dhcbbpackprice(packMainID,packSubID)),"\",6)="Y")
		S labRowID=$O(^TBBP(packMainID,packSubID,"AL",debtorID,""),-1)
		Continue:'$l(labRowID)
		S seq=$g(^TBBP(packMainID,packSubID,"AL",debtorID,labRowID))
		Continue:'$l(seq)
		s transCode=$P($G(^TBBP(packMainID,packSubID,"TRAN",seq)),"\",8)
		Continue:transCode'="T"
	   	S packData=$g(^TBBP(packMainID,packSubID))
	    Continue:$D(^DHCBLDREACTIONi("PACK",packMainID,packSubID))'=0   //已处理的不良反应血袋
	   	Continue:$D(^DHCBLDREACTIONi("NORMALPACK",packMainID,packSubID))'=0   //已处理的正常血袋
	   	Continue:'$l(packData)
	   	S productDr=$P(packData,"\",4)
	   	S bldGroupDr=$P(packData,"\",5)
	   	S volume=$P(packData,"\",21)			//血量
	   	S packDesc=""		//描述
	   	S unit=""			//单位
	   	S productID=$P(packSubID," ",1)	 	//产品码
	   	S:'$L(productID) productID=productDr
	   	I $l(productDr),$D(^TTAB("BB-BP",productDr))'=0 {
		   	S packDesc=$P($g(^TTAB("BB-BP",productDr)),"\",1)
		   	S unit=$P($g(^TTAB("BB-BP",productDr,"REM",1)),"&",1) 
	   	}
	  	S bldGroup=""		//血型
	   	I $l(bldGroupDr),$D(^TTAB("BB-BG",bldGroupDr))'=0 {
		   	S bldGroup=$P($g(^TTAB("BB-BG",bldGroupDr)),"\",1)  
	   	}
	   	S index=index+1
       	S selected="ture"	//是否选择
           
       	S storePackInfo=storePackInfo_index_stFDeli_packMainID_"||"_packSubID_stFDeli_packMainID_stFDeli_productID_stFDeli_packDesc_stFDeli
       	S storePackInfo=storePackInfo_bldGroup_stFDeli_volume_stFDeli_unit_stFDeli_selected_stRDeli
	}
	
	S storePackInfo=##class(web.DHCBldSymptomLayout).BuildStoreData("PACK",storePackInfo)
    S ret="0"_$C(2)_storePackInfo
	Q ret
}

/// Creator：      wwh
/// CreatDate：    2011-6-7
/// Description:： 保存记录单
/// Table：        DHC_BldTransReaction
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod Save(opType As %String, recordData As %String, userCode As %String) As %String
{
	N (opType,recordData,userCode)
	S recordData=$g(recordData),userCode=$g(userCode),opType=$g(opType)
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$DoAction^DHCBldUtlReaction(opType,recordData,userCode)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    2012-2-4
/// Description:： 根据数据域获取组代码
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       组代码
/// Others：       其它说明
ClassMethod GetDataFiledsGroupCode(fieldCode As %String) As %String
{
	N (fieldCode)
    S fieldCode=$g(fieldCode)
    S ret=""
    Q:'$l(fieldCode) ret
    S ret=$g(^DHCBLDREACTIONCFG("DF",fieldCode,"G"))
    Q ret
}

/// Creator：      wwh
/// CreatDate：    2012-2-1
/// Description:： 查询历史记录单信息
/// Table：        DHC_BldTransReaction
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod BuildAllHistoryForms(patAdmID As %String, userCode As %String) As %String
{
	N (patAdmID,userCode)
	S patAdmID=$g(patAdmID),userCode=$g(userCode)
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S ret=$$DoAction^DHCBldUtlReaction("QHISTORY",patAdmID,userCode)
	zn curNS
	
    Q ret
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        就诊号
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckPatAppForm(itmjs As %String = "", itmjsex As %String = "", appFormInfo As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="1^"
	Q:('$l(appFormInfo)) ret
	zn dhcdata
	S ret=$$SavePatAppFormByStr^DHCUtlBldAppForm(appFormInfo)
	zn curNS
	
    Q ret
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Meddata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetDataNS() As %String
{
	N
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S DataNS=Config.DataNamespace
	S:'$l(DataNS) DataNS="dhc-data"
 	Q DataNS
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取Labdata命名空间
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       命名空间
/// Others：       无
ClassMethod GetLabDataNS() As %String
{
	N
	S Config=##Class(websys.Configuration).%OpenId(1)
	S LABDATA=Config.LabDataNamespace
	S:'$l(LABDATA) LABDATA="labdata"
 	Q LABDATA
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAppFormInfo(formType As %String, appFormNumber As %String, admID As %String, regNo As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAppFormInfo^DHCUtlBldAppForm(formType,appFormNumber,admID,regNo)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPatAllAppForm(regNo As %String, admID As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetPatAllAppForm^DHCUtlBldAppForm(regNo,admID)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取申请单信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllUncheckAppFormByLoc(locID As %String, userCode As %String, userGroupID As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$GetAllAppFormByLoc^DHCUtlBldAppForm(locID,"A",userCode,userGroupID)
	zn curNS
	
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CheckAppForm(appFormID As %String, checkUserCode As %String, checkUserPwd As %String, curUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CheckAppForm^DHCUtlBldAppForm(appFormID,checkUserCode,checkUserPwd,curUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 取消审核申请单
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CancelCheckAppForm(appFormID As %String, checkUserCode As %String, checkUserPwd As %String, curUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CancelCheckAppForm^DHCUtlBldAppForm(appFormID,checkUserCode,checkUserPwd,curUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 取消申请
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod CancelApplyAppForm(appFormID As %String, applyUserCode As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret=""
	zn dhcdata
	S retStr=$$CancelApplyAppForm^DHCUtlBldAppForm(appFormID,applyUserCode)
	zn curNS
	//S retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
    //&javascript<#(retval)#>
    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20100618
/// Description:： 获取所有既往史信息
/// Table：        DHC_BldApplicationForm
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetPrintData(printType As %String, recordID As %String, patAdmID As %String, userCode As %String) As %String
{
	N (recordID,printType,patAdmID,userCode)
	S recordID=$g(recordID),printType=$g(printType),patAdmID=$g(patAdmID),userCode=$g(userCode)
	S labdata=..GetLabDataNS()
	S recordData=printType_$C(2)_recordID_$C(2)_patAdmID_$C(2)_labdata
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",PLIST=""
	zn dhcdata
	S ret=$$DoAction^DHCBldUtlReaction("QPRINTDATA",recordData,userCode)
	zn curNS
    Q ret
}

/// Creator：      wwh
/// CreatDate：    20110425
/// Description:： 获取所有标准备注
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllStdComment(stdComType As %String) As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	K PLIST
	S PLIST=""
	S retStr=$$GetAllStdCommentStr^DHCUtlBldAppForm(stdComType)
	zn curNS

    Q retStr
}

/// Creator：      wwh
/// CreatDate：    20110425
/// Description:： 获取所有其他报告
/// Table：        无
/// Input：        无
/// Output：       无
/// Return：       函数返回值的说明
/// Others：       其它说明
ClassMethod GetAllOtherReportStr() As %String
{
	S dhcdata=..GetDataNS()
	S curNS=$ZUTIL(5)
	S ret="",retStr=""
	zn dhcdata
	K PLIST
	S PLIST=""
	S retStr=$$GetAllOtherReportStr^DHCUtlBldAppForm()
	zn curNS

    Q retStr
}

}
