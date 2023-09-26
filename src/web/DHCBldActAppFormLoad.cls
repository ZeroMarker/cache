/// 申请单数据加载
Class web.DHCBldActAppFormLoad Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S ret="{'success':"_"true"_",'info':'保存成功'}"
	
	S $ZT="ERR"
	S formType=$g(request.Data("formType",1))
	S patAdmID=$g(request.Data("patAdmID",1))
	S appFormID=$g(request.Data("appFormID",1))
	S ret=##Class(web.DHCBldAppFormLayout).GetFormLayoutByFormID(formType,appFormID,patAdmID)
	W ret
	Q ret
ERR
  //S ^DEBUG($zn)=$ECODE
  Q
}

/// 获取输血类型Json数据
/// w ##class(web.DHCBldActAppFormLoad).GetTransTypesJsonStr()
ClassMethod GetTransTypesJsonStr(transTypeStr As %String) As %String
{
	//S transTypeStr=##class(web.DHCBldAppForm).GetAllTransType()
	S nameVals="",resutls=0,dataDeli=$C(2),fieldDeli=$C(3)
	F i=1:1:$l(transTypeStr,dataDeli) {
		S nameVal=$P(transTypeStr,dataDeli,i)
		S name=$P(nameVal,fieldDeli,2)
		S value=$P(nameVal,fieldDeli,1)
		I $l(name) {
			S nameVals=nameVals_name_"|"_value_"^"
			S resutls=resutls+1	
		}
	}
	
 	S rows=##class(web.Util.DHCLabUtilJSON).GetComboJsonData(nameVals)
 	S jsonStr="""{resutls:"_resutls_",rows:"_rows_"}"""
	Q jsonStr
}

/// 获取输血目的Json数据
/// w ##class(web.DHCBldActAppFormLoad).GetTransTargetsJsonStr()
ClassMethod GetTransTargetsJsonStr(transTargetStr As %String, appFormID As %String = "", formType As %String = "") As %String
{
	//S transTargetStr=##class(web.DHCBldAppForm).GetAllTransTarget(appFormID,formType)
	S nameVals="",resutls=0,dataDeli=$C(2),fieldDeli=$C(3)
	F i=1:1:$l(transTargetStr,dataDeli) {
		S nameVal=$P(transTargetStr,dataDeli,i)
		S label=$P(nameVal,fieldDeli,2)
		S name=$P(nameVal,fieldDeli,1)
		S value=$P(nameVal,fieldDeli,3)
		I $l(name) {
			S nameVals=nameVals_label_"|"_name_"|"_value_"^"
			S resutls=resutls+1	
		}
	}
	
 	S rows=##class(web.Util.DHCLabUtilJSON).GetCheckboxJsonData(nameVals)
 	S jsonStr=""""_rows_""""
	Q jsonStr
}

/// 获取既往史Json数据
/// w ##class(web.DHCBldActAppFormLoad).GetAnamnesisJsonStr()
ClassMethod GetAnamnesisJsonStr(anaStr As %String, appFormID As %String = "", formType As %String = "") As %String
{
	//S anaStr=##class(web.DHCBldAppForm).GetAllAnamnesis(appFormID,formType)
	S resutls=0,dataDeli=$C(2),fieldDeli=$C(3)
	S columnWidth=".33",labelWidth="70",anchor="90%"
	
	S cols(0)="{columnWidth:"_columnWidth_",layout: 'form',labelWidth:"_labelWidth_",items: ["
	S cols(1)="{columnWidth:"_columnWidth_",layout: 'form',labelWidth:"_labelWidth_",items: ["
	S cols(2)="{columnWidth:"_columnWidth_",layout: 'form',labelWidth:"_labelWidth_",items: ["
	
	F i=1:1:$l(anaStr,dataDeli) {
		S data=$P(anaStr,dataDeli,i)
		S anaCode=$P(data,fieldDeli,1)
		S anaDesc=$P(data,fieldDeli,2)
		S xType=$P(data,fieldDeli,3)
		S isEdit=$P(data,fieldDeli,4)
		S isAllowBlank=$P(data,fieldDeli,5)
		S seq=$P(data,fieldDeli,6)
		S anaVal=$P(data,fieldDeli,7)
		S vtype=$P(data,fieldDeli,8)
		
		
		S:isEdit'="Y" isEdit="N"
		I isEdit="Y" {
			S isEdit="true"	
		}
		ELSE {
			S isEdit="false"	
		}
		
		S:isAllowBlank'="Y" isAllowBlank="N"
		I isAllowBlank="Y" {
			S isAllowBlank="true"	
		}
		ELSE {
			S isAllowBlank="false"	
		}
		
		S:'$l(xType) xType="textfield"
		
		I $l(anaCode) {
			
			S item="{xtype:'"_xType_"',fieldLabel: '"_anaDesc_"',name: '"_anaCode_"',"
			S item=item_"allowBlank:"_isAllowBlank_",value:'"_anaVal_"',vtype:'"_vtype_"',anchor:'"_anchor_"'}"
			
			S cols(resutls#3)=cols(resutls#3)_item_","
			S resutls=resutls+1	
		}
	}
	
	S col="",items=""
	F {
		S col=$O(cols(col))
		Q:col=""
		I $E(cols(col),$l(cols(col)))="," {
			S cols(col)=$E(cols(col),1,$l(cols(col))-1)
		}
		ELSE
		{
			S cols(col)=cols(col)_"{}"
			
		}
 		S cols(col)=cols(col)_"]}"	
 		S items=items_cols(col)_","
	}
	
	I $E(items,$l(items))="," {
		S items=$E(items,1,$l(items)-1)
	}
	
	S:'$l(items) items="{}"
 	
 	S jsonStr="""{layout:'column',items:["_items_"]}"""
	Q jsonStr
}

/// 获取备血医嘱的Json数据
/// w ##class(web.DHCBldActAppFormLoad).GetOrdersJsonStr()
ClassMethod GetOrdersJsonStr(orders As %String, admID As %String = "", appFormID As %String = "", formType As %String = "") As %String
{
	//S orders=##class(web.DHCBldAppForm).GetAllOrders(appFormID,admID,formType)
	S nameVals="",resutls=0,dataDeli=$C(2),fieldDeli=$C(3),index=0,tDeli=$C(2)
	K ^TMP($zn,$j)
	S ^TMP($zn,$j,0)="seq"_tDeli_"oeOrdID"_tDeli_"labNo"_tDeli_"oeOrdDesc"_tDeli_"volume"_tDeli
	S ^TMP($zn,$j,0)=^TMP($zn,$j,0)_"unit"_tDeli_"bldTypeABO"_tDeli_"bldTypeRH"_tDeli_"remark"_tDeli_"select"_tDeli
	F i=1:1:$l(orders,dataDeli) {
		S data=$P(orders,dataDeli,i)
		continue:'$l(data)
	    S ordRowID=$P(data,fieldDeli,1)
		S OrderDesc=$P(data,fieldDeli,2)
		S Status=$P(data,fieldDeli,3)
		S LabNo=$P(data,fieldDeli,4)
		S TestSet=$P(data,fieldDeli,5)
		S Amount=$P(data,fieldDeli,6)
		S Unit=$P(data,fieldDeli,7)
		S OrderDetails=$P(data,fieldDeli,8)
		S ABO=$P(data,fieldDeli,9)
		S Rh=$P(data,fieldDeli,10)
		S Remark=$P(data,fieldDeli,11)
		S Sequence=+$P(data,fieldDeli,12)
		S select="true"
	    
		I $l(ordRowID) {
			S index=index+1
			S ^TMP($zn,$j,index)=Sequence_tDeli_ordRowID_tDeli_LabNo_"||"_TestSet_tDeli_OrderDesc_tDeli
			S ^TMP($zn,$j,index)=^TMP($zn,$j,index)_Amount_tDeli_Unit_tDeli_ABO_tDeli_Rh_tDeli
			S ^TMP($zn,$j,index)=^TMP($zn,$j,index)_Remark_tDeli_select_tDeli
		}
	}
	
 	S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
 	S jsonStr=""""_jsonStr_""""
	Q jsonStr
}

/// 获取化验项目的Json数据
/// w ##class(web.DHCBldActAppFormLoad).GetTestItemsJsonStr()
ClassMethod GetTestItemsJsonStr(testItems As %String, regNo As %String = "", admID As %String = "", appFormID As %String = "", formType As %String = "") As %String
{
	//S testItems=##class(web.DHCBldAppForm).GetPatAllTestItems(appFormID,admID,regNo,formType)
	S resutls=0,dataDeli=$C(2),fieldDeli=$C(3),index=0,tDeli=$C(2)
	K ^TMP($zn,$j)
	S ^TMP($zn,$j,0)="seq"_tDeli_"itemCode"_tDeli_"itemDesc"_tDeli_"itemValue"_tDeli
	F i=1:1:$l(testItems,dataDeli) {
		S data=$P(testItems,dataDeli,i)
		continue:'$l(data)
	    S itemCode=$P(data,fieldDeli,1)
		S itemDesc=$P(data,fieldDeli,2)
		S itemValue=$P(data,fieldDeli,3)
		S seq=+$P(data,fieldDeli,4)
		
		I $l(itemCode) {
			S index=index+1
			S ^TMP($zn,$j,index)=seq_tDeli_itemCode_tDeli_itemDesc_tDeli_itemValue_tDeli
		}
	}
	
 	S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
 	S jsonStr=""""_jsonStr_""""
	Q jsonStr
}

Parameter ActionID = "BLD.APPFORM.LOAD";

Parameter Version = "1.0.0.1";

}
