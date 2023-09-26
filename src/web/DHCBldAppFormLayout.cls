Class web.DHCBldAppFormLayout Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetFormLayout(patAdmID As %String) As %String
{
   S tDeli=$C(2),tFieldDeli=$C(3)
  
   S appFormData=##Class(web.DHCBldAppForm).GetAppFormInfo("N","",patAdmID,"")
   S historyAppForms=##class(web.DHCBldAppForm).GetPatAllAppForm("",patAdmID)
   S otherReport=##class(web.DHCBldAppForm).GetAllOtherReportStr()  //获取所有其他报告
   
   S tDataDeli=$C(4)
   S appFormBasicData=$P(appFormData,tDataDeli,1)
   S patBasicData=$P(appFormData,tDataDeli,2)
   S orders=$P(appFormData,tDataDeli,3)
   S testItems=$P(appFormData,tDataDeli,4)
   S anamnesisData=$P(appFormData,tDataDeli,5)
   
   //------------------------------------------------
   //病人血型代码
   S patABO=$P($P(patBasicData,tDeli,32),"型",1)
   S patRh=$P(patBasicData,tDeli,33)
   S patRh=$S(patRh["阳性":"POS",patRh["阴性":"NEG",1:"")
   S patBldTypeCode=patABO_patRh
   //------------------------------------------------
   
   S transPurData=$P(appFormData,tDataDeli,6)
   S transTypesData=$P(appFormData,tDataDeli,7)
   
   S orderSelf=$P(appFormData,tDataDeli,8)
   S testItemsSelf=$P(appFormData,tDataDeli,9)
   //病人基本信息
   S patInfo=..BuildFieldsData("PA",patBasicData)
   //既往史
   S anamnesisInfo=..BuildFieldsData("AN","")
   //输血目的
   S transPurposes=..GetTransPurLayout()
   //输血类型
   S transTypes=..GetTransTypeLayout()
   //生命体征
   S patSignInfo=""  //一般为固定项目,如果不固定可以调用BuildFieldsData方法
   //化验项目数据
   S testItemsData=..BuildStoreData("TESTITEMS",testItems)
   //医嘱数据
   S ordersData=..BuildStoreData("ORDERS",orders)
   //历史医嘱
   S historyAppFormsData=..BuildStoreData("HISTORY",historyAppForms)
   //自体血化验项目
   S testItemsSelfData=..BuildStoreData("TESTITEMS",testItemsSelf)
   //自体输血医嘱数据
   S orderSelfData=..GetOrderSelfLayout(orderSelf)
   //其他报告
   S otherReportJsonData=..BuildStoreData("OTHERREPORT",otherReport)

   S ret=patInfo_tDeli_anamnesisInfo_tDeli_transTypes_tDeli_transPurposes_tDeli_testItemsData_tDeli_ordersData_tDeli_historyAppFormsData_tDeli
   S ret=ret_orderSelfData_tDeli_testItemsSelfData_tDeli_otherReportJsonData_tDeli_patBldTypeCode_tDeli
   Q ret
}

ClassMethod GetTransOrdersFormLayout(patAdmID As %String) As %String
{
	s patAdmID=$g(patAdmID)
	S ret="",tDeli=$C(2)
	S transOrders=##class(web.DHCBldAppForm).GetAllTransOrdersStr(patAdmID)	//获取所有备血医嘱(顺序:APOS,ANEG,BPOS,BNEG,ABPOS,ABNEG,OPOS,ONEG,X)
    //备选医嘱
   	S transOrdersAPOSJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),1))
   	S transOrdersANEGJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),2))
   	S transOrdersBPOSJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),3))
   	S transOrdersBNEGJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),4))
   	S transOrdersABPOSJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),5))
   	S transOrdersABNEGJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),6))
   	S transOrdersOPOSJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),7))
   	S transOrdersONEGJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),8))
   	S transOrdersXJsonData=..BuildStoreData("TRANSORDERS",$P(transOrders,$C(4),9))
    S ret=ret_transOrdersAPOSJsonData_tDeli_transOrdersANEGJsonData_tDeli_transOrdersBPOSJsonData_tDeli_transOrdersBNEGJsonData_tDeli
    S ret=ret_transOrdersABPOSJsonData_tDeli_transOrdersABNEGJsonData_tDeli_transOrdersOPOSJsonData_tDeli_transOrdersONEGJsonData_tDeli_transOrdersXJsonData_tDeli
    Q ret
}

//获取权限Json数据

ClassMethod GetUserGroupGrantJsonData(userGrpID As %String, userCode As %String = "") As %String
{
	S ret="{",tDeli=$C(2)
	S grantData=##class(web.DHCBldAppForm).GetUserGroupGrant(userGrpID,userCode)
	F i=1:1:$l(grantData,tDeli) {
		S data=$P(grantData,tDeli,i)
		Continue:'$l(data)
		S itmCode=$P(data,$C(3),1)
		S isGrant=$P(data,$C(3),4)	
		S itmVal=$P(data,$C(3),5)
		Continue:'$l(itmCode)
		S grantVal="false"
		I itmVal="Y",isGrant="1" {
			S grantVal="true"	
		}
		I itmVal'="N",itmVal'="Y",$l(itmVal),isGrant="1" {
			S grantVal=itmVal
		}
		
		S ret=ret_itmCode_":"_$S(grantVal="true":"true",grantVal="false":"false",1:"'"_grantVal_"'")_","
	}
	I ret'="{" {
		S ret=$P(ret,",",1,$L(ret,",")-1)	
	}	 
	S ret=ret_"}"
   	//S ret=..BuildStoreData("GROUPGRANT",$P(grantData,$C(4),1))
    Q ret
}

ClassMethod FormatOrderSelf(orders As %String) As %String
{
     S fieldDeli=$C(3),recordDeli=$C(2),tDeli1="#",tDeli2="^",ordStr=""
     F i=1:1:$l(orders,recordDeli) {
          S record=$P(orders,recordDeli,i)
          Continue:'$L(record)
          S ordRowID=..StrToValueStr($P(record,fieldDeli,1))
          S OrderDesc=..StrToValueStr($P(record,fieldDeli,2))
          S Status=..StrToValueStr($P(record,fieldDeli,3))
          S LabNo=..StrToValueStr($P(record,fieldDeli,4))
          S TestSet=..StrToValueStr($P(record,fieldDeli,5))
          S Amount=..StrToValueStr($P(record,fieldDeli,6))
          S Unit=..StrToValueStr($P(record,fieldDeli,7))
          S OrderDetails=..StrToValueStr($P(record,fieldDeli,8))
          S ABO=..StrToValueStr($P(record,fieldDeli,9))
          S Rh=..StrToValueStr($P(record,fieldDeli,10))
          S Remark=..StrToValueStr($P(record,fieldDeli,11))
          S Sequence=..StrToValueStr($P(record,fieldDeli,12))
          
          S ordStr=ordStr_Sequence_tDeli1_ordRowID_tDeli1_LabNo_tDeli1_OrderDesc_tDeli1
          S ordStr=ordStr_Amount_tDeli1_Unit_tDeli1_ABO_tDeli1_Rh_tDeli1
          S ordStr=ordStr_Remark_tDeli1_tDeli2
     }
     Q ordStr
}

ClassMethod GetOrderSelfLayout(orders As %String) As %String
{
	S fieldDeli=$C(3),recordDeli=$C(2),tDeli1="#",tDeli2="^",ordStr="["
	F i=1:1:$l(orders,recordDeli) {
		S record=$P(orders,recordDeli,i)
		Continue:'$L(record)
		S ordRowID=$P(record,fieldDeli,1)
		S OrderDesc=$P(record,fieldDeli,2)
		S Status=$P(record,fieldDeli,3)
		S LabNo=$P(record,fieldDeli,4)
		S TestSet=$P(record,fieldDeli,5)
		S Amount=$P(record,fieldDeli,6)
		S Unit=$P(record,fieldDeli,7)
		S OrderDetails=$P(record,fieldDeli,8)
		S ABO=$P(record,fieldDeli,9)
		S Rh=$P(record,fieldDeli,10)
		S Remark=$P(record,fieldDeli,11)
		S Sequence=$P(record,fieldDeli,12)
		
		S ordList=Sequence_tDeli1_ordRowID_tDeli1_LabNo_tDeli1_OrderDesc_tDeli1
		S ordList=ordList_Amount_tDeli1_Unit_tDeli1_ABO_tDeli1_Rh_tDeli1
		S ordList=ordList_Remark_tDeli1_tDeli2
	    
	    S ordStr=ordStr_"['"_ordList_"','"_OrderDesc_"']," 
   }
   S ordStr=$P(ordStr,",",1,$l(ordStr,",")-1)
   S:'$L(ordStr) ordStr="["
   S ordStr=ordStr_"]"
	Q ordStr
}

ClassMethod GetFormLayoutByFormID(formType As %String, appFormID As %String, patAdmID As %String) As %String
{
   S tDeli=$C(2),tFieldDeli=$C(3)
   S appFormData=##Class(web.DHCBldAppForm).GetAppFormInfo(formType,appFormID,patAdmID,"")
  
   S tDataDeli=$C(4)
   S appFormBasicData=$P(appFormData,tDataDeli,1)
   //appFormID-1,typeDr-2,statusCode-3,transTypeDr-4,dateOfTrans-5,timeOfTrans-6,dateOfColl-7
   //timeOfColl-8,colBlddVolume-9,isConsent-10,otherTransPurpose-11,otherTransType-12,
   //isIrradiatedBld-13,isFilterOutWBC-14,remark-15,typeDesc-16,statusDesc-17,
   //transTypeDesc-18,lstSaveUserCode-19,lstSaveUserDesc-20,lstSaveDate_" "_lstSaveTime-21
   //lstReqUserCode-22,lstReqUserDesc-23,lstReqDate_" "_lstReqTime-24
   //lstCheckUserCode-25,lstCheckUserDesc-26,lstCheckDate_" "_lstCheckTime-27
   //lstOpUserCode-28,lstOpUserDesc-29,lstOpDate_" "_lstOpTime-30,lstOpType-31,isOxygenBld-32
   //$C(2)
   S formType=$P(appFormBasicData,$C(2),2)
   S patBasicData=$P(appFormData,tDataDeli,2)
   //patRegNo-1, admID-2,patLocDesc-3,patRoom-4,patSex-5,patName-6,safetyNetCardNo-7,patBed-8,patBirth-9
   //patAge-10,patWardDesc-11,patHomeAddress-12,patHomeTel-13,patWorkTel-14,patMobileTel-15,patCardID-16
   //patType-17,patTypeDesc-18, patCountryDesc-19,patNationDesc-20,patDiagnos-21, patProvinceDesc-22
   //patApanageType-23,patLocDr-24,curWardDr-25,roomDr-26,patBodyWeight-27,patHeight-28,patBldPressure-29
   //patPulse-30,patBodyTemper-31, bldGroupABO-32,bldGroupRH-33,bldGroupOther-34,patMedicare-35
   //$C(2)
   S orders=$P(appFormData,tDataDeli,3)
   S testItems=$P(appFormData,tDataDeli,4)
   S anamnesisData=$P(appFormData,tDataDeli,5)
   S transPurData=$P(appFormData,tDataDeli,6)
   S transTypesData=$P(appFormData,tDataDeli,7)
   //构建MAP 
   S fieldDatas("PA")=patBasicData		//病人基本数据
   //S fieldDatas("AN")=anamnesisData	//既往史数据
   S fieldDatas("SI")=patBasicData		//生命体征数据
   S fieldDatas("TR")=appFormBasicData	//输血信息数据
   S fieldDatas("OT")=appFormBasicData	//其他信息数据
   S fieldDatas("ST")=appFormBasicData	//自体输血用血数据
  
   S lType="",fieldDeli=$C(2),(fieldKeys,fieldVals)=""
   F{
		S lType=$O(^DHCBLDAPPFORMc("LAYOUT",lType))
		Q:'$l(lType)
		Continue:'$l($g(fieldDatas(lType)))
		S fieldCode=""
		F{
			S fieldCode=$O(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode))
			Q:'$l(fieldCode)
			S fieldPos=+$P(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode),fieldDeli,13)
			S xtype=$P(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode),fieldDeli,3)
			I fieldPos>0 {
				S fieldData=$g(fieldDatas(lType))
				S fieldValue=$P(fieldData,fieldDeli,fieldPos)
				I '$l(appFormID) {
					S:fieldCode="otherFilterWBC" fieldValue="Y"
					S:fieldCode="consentLetter" fieldValue="Y"	
				}
				
				
				I xtype="checkbox" {
					I fieldValue="Y"{
						S fieldValue="true"
						S transPurData=transPurData_fieldCode_","
					}ELSE{
						S fieldValue="false"	
					}
				}
				Continue:xtype="checkbox"   //"checkbox"类型放到输血目的中加载
				I xtype="datefield" {
					S fieldValue=$TR(fieldValue,"-","/")
				}
				I xtype="timefield" {
					S fieldValue=$P(fieldValue,":",1,2)
				}
				S fieldKeys=fieldKeys_fieldCode_fieldDeli
				S fieldVals=fieldVals_fieldValue_fieldDeli
			}
		}   
	}
   S patAdmID=$P(patBasicData,fieldDeli,2)
   S fieldKeys=fieldKeys_"patAdmID"_fieldDeli
   S fieldVals=fieldVals_patAdmID_fieldDeli
   
   //化验项目数据
   S testItemsData=..BuildStoreData("TESTITEMS",testItems)
   S:$L(testItemsData) testItemsData=""""_testItemsData_""""
   //医嘱数据
   S ordersData=..BuildStoreData("ORDERS",orders)
   S:$L(ordersData) ordersData=""""_ordersData_""""
   
   S fieldKeys=fieldKeys_"testItems"_fieldDeli
   S fieldVals=fieldVals_testItemsData_fieldDeli
   S fieldKeys=fieldKeys_"orders"_fieldDeli
   S fieldVals=fieldVals_ordersData_fieldDeli
   
   //自体血医嘱
   I formType="S" {
   		S ordersData="" //..FormatOrderSelf(orders)
   		S fieldKeys=fieldKeys_"orderSelfVal"_fieldDeli
   		S fieldVals=fieldVals_ordersData_fieldDeli
   }
   //输血目的
   S fieldKeys=fieldKeys_"transPorpuses"_fieldDeli
   S fieldVals=fieldVals_transPurData_fieldDeli
   //既往史
   F i=1:1:$l(anamnesisData,$C(2)) D
   .S fieldData=$P(anamnesisData,$C(2),i)
   .Q:'$l(fieldData)
   .S fieldCode=$P(fieldData,$C(3),1)
   .Q:'$l(fieldCode)
   .S fieldValue=$P(fieldData,$C(3),7)
   .S fieldKeys=fieldKeys_fieldCode_fieldDeli
   .S fieldVals=fieldVals_fieldValue_fieldDeli
   b
   K ^TMP($zn,$j)
   S ^TMP($zn,$j,0)=fieldKeys
   S ^TMP($zn,$j,1)=fieldVals
   S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
   S ret=jsonStr
   Q ret
}

ClassMethod BuildFieldsData(layoutType As %String, valData As %String) As %String
{
   N (layoutType,valData)
   S layoutType=$g(layoutType),valData=$g(valData)
   Q:'$l(layoutType) ""
   S rset = ##class(%ResultSet).%New("web.DHCBldAppFormConfig:SelectLayoutFields")
   S columns = rset.GetColumnCount()
   S sc = rset.Execute(layoutType)
   S layoutData="",num=0,totalCols=5,tDeli=$C(2)
   S totalCols=+$g(^DHCBLDAPPFORMc("LAYOUT",layoutType))
   S:totalCols<=0 totalCols=4
   
   F i=1:1:totalCols D
   .S cols(i)=""
   
   S curCol=0
   While (rset.Next()) {
        S curCol=curCol+1
        I $D(cols(curCol))=0 {
               S curCol=1
          }
        S fieldCode=rset.Data("fieldCode")
        S fieldDesc=rset.Data("fieldDesc")
        S dataType=rset.Data("dataType")
        S xtype=rset.Data("xtype")
        S isReadOnly=rset.Data("isReadOnly")
        S isReadOnly=$S((isReadOnly="Y")!(isReadOnly="true"):"true",1:"false")
        S isAllowBlank=rset.Data("isAllowBlank")
        S isAllowBlank=$S((isAllowBlank="Y")!(isAllowBlank="true"):"true",1:"false")
        S defaultVal=rset.Data("defaultVal")
        S hidden=rset.Data("hidden")
        S hidden=$S((hidden="Y")!(hidden="true"):"true",1:"false")
        S vtype=rset.Data("vtype")
        S style=rset.Data("style")
        S activity=rset.Data("activity")
        S valRef=+rset.Data("valRef")
        S seqNumber=rset.Data("seqNumber")
        S anchor="95%"
        S value=""
        S:valRef>0 value=$P(valData,tDeli,valRef)
        I '$l(value),$l(defaultVal) {
          S value=defaultVal
          }
        S fieldStr="{"
        S fieldStr=fieldStr_"xtype:'"_..StrToPropertyStr(xtype)_"',"
        S fieldStr=fieldStr_"fieldLabel:'"_..StrToPropertyStr(fieldDesc)_"',"
        S fieldStr=fieldStr_"name:'"_..StrToPropertyStr(fieldCode)_"',"
        I $l(vtype){
            S fieldStr=fieldStr_"vtype:'"_..StrToPropertyStr(vtype)_"'," 
            }
	    I xtype="combo"{
		  S fieldStr=fieldStr_"store:['无','有']," 
		  S fieldStr=fieldStr_"triggerAction:'all'," 
		   }
        S fieldStr=fieldStr_"value:'"_..StrToValueStr(value)_"',"
        S fieldStr=fieldStr_"allowBlank:"_..StrToPropertyStr(isAllowBlank)_","
        S fieldStr=fieldStr_"readOnly:"_..StrToPropertyStr(isReadOnly)_","
        S fieldStr=fieldStr_"hidden:"_..StrToPropertyStr(hidden)_","
        S fieldStr=fieldStr_"hideLabel:"_..StrToPropertyStr(hidden)_","
        S fieldStr=fieldStr_"anchor:'"_..StrToPropertyStr(anchor)_"'}"
        S cols(curCol)=cols(curCol)_fieldStr_","
   }
   D rset.Close()
   
   S layoutData="[",columnWidth=1/totalCols
   F curCol=1:1:totalCols {
             S data=$g(cols(curCol))
             Continue:'$L(data)
             S data=$P(data,",",1,$l(data,",")-1)
          S layoutData=layoutData_"{columnWidth:"_columnWidth_",layout:'form',items:["_data_"]},"
     }
   S layoutData=$P(layoutData,",",1,$l(layoutData,",")-1)_"]"
   Q layoutData
}

ClassMethod GetTransPurLayout() As %String
{
   S transPurData=##Class(web.DHCBldAppForm).GetAllStdComment("P||输血目的")
   S layoutData="",num=0,totalCols="",tDeli=$C(2)
   S totalCols=+$g(^DHCBLDAPPFORMc("LAYOUT","TP"))
   S:totalCols<=0 totalCols=4
  
   F i=1:1:totalCols D
   .S cols(i)=""
   
   S curCol=0
   F i=1:1:$l(transPurData,$C(3)) {
        S trPurData=$P(transPurData,$C(3),i)
        Continue:'$l(trPurData)
        S curCol=curCol+1
        I $D(cols(curCol))=0 {
               S curCol=1
          }
        S trPurCode=$P(trPurData,$C(2),1)
        S trPurDesc=$P(trPurData,$C(2),2)
        S isActivity=$P(trPurData,$C(2),4)
        Continue:isActivity'="Y"
        S isDefault=$P(trPurData,$C(2),5)
       
        S trPurVal="false"
        S:isDefault="Y" trPurVal="true"
        S fieldStr="{"
        S fieldStr=fieldStr_"xtype:'checkbox',"
        S fieldStr=fieldStr_"boxLabel:'"_..StrToPropertyStr(trPurDesc)_"',"
        S fieldStr=fieldStr_"name:'"_..StrToPropertyStr(trPurCode)_"',"
        S fieldStr=fieldStr_"checked:"_..StrToPropertyStr(trPurVal)_","
        S fieldStr=fieldStr_"anchor:'95%'}"
        S cols(curCol)=cols(curCol)_fieldStr_","
   }
   
   S layoutData="[",columnWidth=1/totalCols
   F curCol=1:1:totalCols {
             S data=$g(cols(curCol))
             Continue:'$L(data)
             S data=$P(data,",",1,$l(data,",")-1)
          S layoutData=layoutData_"{columnWidth:"_columnWidth_",items:["_data_"]},"
     }
   S layoutData=$P(layoutData,",",1,$l(layoutData,",")-1)_"]"
   
   Q layoutData
}

ClassMethod GetTransTypeLayout() As %String
{
   S transTypeData=##Class(web.DHCBldAppForm).GetAllStdComment("T||输血类型")
   S layoutData="[",tDeli=$C(2)
  
   F i=1:1:$l(transTypeData,$C(3)) {
	   S trTypeData=$P(transTypeData,$C(3),i)
	   Continue:'$l(trTypeData)
	   S trTypeCode=$P(trTypeData,$C(2),1)
	   S trTypeDesc=$P(trTypeData,$C(2),2)
	   S isActivity=$P(trTypeData,$C(2),4)
	   Continue:isActivity'="Y"
	   S isDefault=$P(trTypeData,$C(2),5)
	   S layoutData=layoutData_"['"_trTypeCode_"','"_trTypeDesc_"']," 
   }
   S layoutData=$P(layoutData,",",1,$l(layoutData,",")-1)
   S layoutData=layoutData_"]"
   
   Q layoutData
}

ClassMethod BuildStoreData(storeType As %String, valData As %String) As %String
{
	S storeType=$g(storeType),valData=$g(valData),ret="",tDeli=$C(2)
	S tRecDeli=$C(3),tFieldDeli=$C(2),index=0,jsonStr=""
	S storeFields=##Class(web.DHCBldAppFormConfig).GetStoreFields(storeType)
	
	S fields="",fieldPosIndexs=""
    F i=1:1:$l(storeFields,tRecDeli) {
		S record=$P(storeFields,tRecDeli,i)
		S fieldCode=$P(record,tFieldDeli,1)    
	    Continue:'$L(fieldCode)
	    S posIndex=+$P(record,tFieldDeli,6)    
	    S fields=fields_fieldCode_tDeli
	    S fieldPosIndexs=fieldPosIndexs_posIndex_tDeli
	}
	
	S tRecDeli=$C(2),tFieldDeli=$C(3)
	I $l(fields),$l(valData) {
		S ^TMP($zn,$j,0)=fields,index=0
		F i=1:1:$l(valData,tRecDeli) {
			S record=$P(valData,tRecDeli,i)
			Continue:'$L(record)
			S fieldDatas=""
			F j=1:1:$l(fields,tDeli) {
				S posIndex=$P(fieldPosIndexs,tDeli,j)
				S fieldVal=$P(record,tFieldDeli,posIndex)
				S fieldDatas=fieldDatas_fieldVal_tDeli
			}
			I $l(fieldDatas) {
				S index=index+1
				S ^TMP($zn,$j,index)=fieldDatas
			}
		}
		
		I index>0 {
			S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)	
		}
	}
	S:'$l(jsonStr) jsonStr="{resutls:0,rows:''}"
	//S jsonStr=""""_jsonStr_""""
	Q jsonStr
}

ClassMethod GetFormJsonReaderFields() As %String
{
	S ret="["
 	S lType="",fieldDeli=$C(2)
   	F{
		S lType=$O(^DHCBLDAPPFORMc("LAYOUT",lType))
		Q:'$l(lType)
		S fieldCode=""
		F{
			S fieldCode=$O(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode))
			Q:'$l(fieldCode)
			S fieldData=$g(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode))
			Continue:'$l(fieldData)
			S fieldType=$P(fieldData,fieldDeli,2)
			S ret=ret_"{name:'"_fieldCode_"',mapping:'"_fieldCode_"',type:'"_fieldType_"'},"
		}   
	}
	S fieldCode="transPorpuses",fieldType="string"
	S ret=ret_"{name:'"_fieldCode_"',mapping:'"_fieldCode_"',type:'"_fieldType_"'},"
	
	S fieldCode="testItems",fieldType="string"
	S ret=ret_"{name:'"_fieldCode_"',mapping:'"_fieldCode_"',type:'"_fieldType_"'},"
		
 	I $E(ret,$l(ret))="," {
 		S ret=$E(ret,1,$l(ret)-1)	 
 	}
 	S ret=ret_"]"
 	S:ret="[]" ret="[{}]" 
 	Q ret
}

ClassMethod GetFormFieldData(ByRef request As %CSP.Request, layoutType As %String) As %String
{
	S layoutType=$g(layoutType)
	S ret="",fieldDeli=$C(2),typeDeli=$C(3)
 	S lType="",fieldValues=""
 	S:$l(layoutType) lType=$O(^DHCBLDAPPFORMc("LAYOUT",layoutType),-1)
   	F{
		S lType=$O(^DHCBLDAPPFORMc("LAYOUT",lType))
		Q:'$l(lType)
		Continue:$l(layoutType)&(layoutType'=lType)
		S fieldCode=""
		F{
			S fieldCode=$O(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode))
			Q:'$l(fieldCode)
			S fieldData=$g(^DHCBLDAPPFORMc("LAYOUT",lType,"FIELD",fieldCode))
			Continue:'$l(fieldData)
			S fieldValuePos=+$P(fieldData,fieldDeli,14)
			Continue:fieldValuePos<=0
			S val=$g(request.Data(fieldCode,1))
			S:lType="AN" val=fieldCode_"^"_val  //既往史数据需要保存代码
			S $P(fieldValues(lType),fieldDeli,fieldValuePos)=val
		}   
	}
	I $l(layoutType) {
		S ret=$g(fieldValues(layoutType))_typeDeli	
	}ELSE{
		//PA,AN,OT,TR,SI,ST,OP  
		S ret=ret_$g(fieldValues("PA"))_typeDeli	//1,病人基本信息(目前只取其他血型)
		S ret=ret_$g(fieldValues("AN"))_typeDeli	//2,既往史
		S ret=ret_$g(fieldValues("OT"))_typeDeli	//3,普通输血申请单:氧和血,辐照,滤白,是否签订同意书
		S ret=ret_$g(fieldValues("TR"))_typeDeli	//4,普通输血申请单:用血日期时间,输血类型,其他等信息
		S ret=ret_$g(fieldValues("SI"))_typeDeli	//5,生命体征
		S ret=ret_$g(fieldValues("ST"))_typeDeli	//6,自体输血申请单:用血日期时间,采集血量,备注等
		S ret=ret_$g(fieldValues("OP"))_typeDeli	//7,操作信息:操作类型,操作者,申请单类型
		S ret=ret_$g(request.Data("testItems",1))_typeDeli	//8,化验项目结果
	}
	
 	
 	Q ret
}

ClassMethod GetUsrCPMaxVolume(UsrRowID As %String) As %String
{
    s ret=100
    s chkUsrCareProv=$P($g(^SSU("SSUSR",UsrRowID)),"^",14)
    Q:'$l(chkUsrCareProv) ret
    s chkUsrCPCode=$p($g(^CTPCP(chkUsrCareProv,1)),"^",4)
    Q:'$l(chkUsrCPCode) ret
    s chkUsrCPDesc=$p($g(^CT("CPT",chkUsrCPCode)),"^",2)
    Q:'$l(chkUsrCPDesc) ret
    i chkUsrCPDesc="主任医师" s ret=800
    i chkUsrCPDesc="副主任医师" s ret=1200
    i chkUsrCPDesc="科室主任" s ret=2000
	Q ret
}

ClassMethod GetBloodGroup() As %String
{
	S ret="",BloodGroups=""
	s BloodGroups=BloodGroups_"1"_$c(3)_"APOS"_$c(3)_"A型Rh阳性(+)"_$c(3)_"(+)"_$c(3,2)
	s BloodGroups=BloodGroups_"2"_$c(3)_"BPOS"_$c(3)_"B型Rh阳性(+)"_$c(3)_"(+)"_$c(3,2)
	s BloodGroups=BloodGroups_"3"_$c(3)_"ABPOS"_$c(3)_"AB型Rh阳性(+)"_$c(3)_"(+)"_$c(3,2)
	s BloodGroups=BloodGroups_"4"_$c(3)_"OPOS"_$c(3)_"O型Rh阳性(+)"_$c(3)_"(+)"_$c(3,2)
	s BloodGroups=BloodGroups_"5"_$c(3)_"ANEG"_$c(3)_"A型Rh阴性(-)"_$c(3)_"(-)"_$c(3,2)
	s BloodGroups=BloodGroups_"6"_$c(3)_"BNEG"_$c(3)_"B型Rh阴性(-)"_$c(3)_"(-)"_$c(3,2)
	s BloodGroups=BloodGroups_"7"_$c(3)_"ABNEG"_$c(3)_"AB型Rh阴性(-)"_$c(3)_"(-)"_$c(3,2)
	s BloodGroups=BloodGroups_"8"_$c(3)_"ONEG"_$c(3)_"O型Rh阴性(-)"_$c(3)_"(-)"_$c(3,2)
	S ret=..BuildStoreData("OTHERREPORT",BloodGroups)
	Q ret
}

ClassMethod DEBUG(layoutType As %String) As %String
{
	S ret=0
 	Q ret
}

/// Creator:           wwh
/// CreatDate:         20120425
/// Description:      格式化属性数据
/// Table:             无
/// Input:             str:待处理数据
/// Output:            无
/// Return:            处理完数据
/// Others:            无
ClassMethod StrToPropertyStr(str As %String) As %String
{
     N (str)
     S newStr=$G(str)
     Q:'$l(str) newStr
     
     //替换所有不可见字符
     S newStr=..DelInvisibleChar(newStr,"")
     
     //替换单引号
     S newStr=..Raplace(newStr,"'","")
     //去掉双引号
     S newStr=..Raplace(newStr,"""","")
     Q newStr
}

/// Creator:           wwh
/// CreatDate:         20120425
/// Description:      格式化属性数据
/// Table:             无
/// Input:             str:待处理数据
/// Output:            无
/// Return:            处理完数据
/// Others:            无
ClassMethod StrToValueStr(str As %String) As %String
{
     N (str)
     S newStr=$G(str)
     Q:'$l(str) newStr
     
     //替换所有不可见字符
     S newStr=..DelInvisibleChar(newStr,"")
     
     //替换单引号
     S newStr=..Raplace(newStr,"'","\\'")
     //替换双引号
     S newStr=..Raplace(newStr,"""","\""")
     Q newStr
}

/// Creator:           wwh
/// CreatDate:         20120425
/// Description:      删除不可见字符
/// Table:             无
/// Input:             str:待处理数据
/// Output:            无
/// Return:            处理完数据
/// Others:            无
ClassMethod DelInvisibleChar(str As %String, flag As %String = "") As %String
{
     N (str)
     S newStr=$G(str)
     Q:'$l(str) newStr
     F i=0:1:31 {
          S newStr=..Raplace(newStr,$C(i),"")     
     }
     S newStr=..Raplace(newStr,$C(127),"")
     Q newStr
}

/// Creator：          wwh
/// CreateDate：          2010-06-01
/// Description：     替换字符串
/// Table：               无
/// Input：               oStr:源字符串,fStr:查找的字符串,rStr:替换的字符串
/// Output：               无
/// Return：               ret:字符串
/// Others：               无
ClassMethod Raplace(oStr As %String, fStr As %String, rStr As %String) As %String
{
     N (oStr,fStr,rStr)
    S oStr=$g(oStr),fStr=$g(fStr),rStr=$g(rStr)
    S ret=oStr
    Q:('$l(oStr))||('$l(fStr)) ret
    Q:oStr'[fStr ret
    S tmpStr=oStr,newStr=""
    While tmpStr[fStr {
         S newStr=newStr_$P(tmpStr,fStr,1)_rStr
          S tmpStr=$P(tmpStr,fStr,2,$l(tmpStr,fStr))   
     }
    S newStr=newStr_tmpStr
    Q newStr
}

}
