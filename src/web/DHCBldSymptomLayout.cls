Class web.DHCBldSymptomLayout Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetFormLayout(patAdmID As %String) As %String
{
   S tDeli=$C(2),tFieldDeli=$C(3),tRecDeli=$C(2),tDataDeli=$C(4)
   S reDeli=$C(3),deli=$C(2),formRead=""
   
   //--------------------------------------------------------------------------------
   //构建FormRead基本字段
   S fCode=""
   F{
		S fCode=$O(^DHCBLDREACTIONCFG("F",fCode))  
		Q:'$l(fCode)
		S formRead=formRead_fCode_"^"
    }
   
   //--------------------------------------------------------------------------------
   //----反应症状
   S symArrayStr="[",symStoreData=""
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("S")
   S symClsData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(symClsData,reDeli) {
	  S data=$P(symClsData,reDeli,i)
	  S symClsCode=$P(data,deli,1)
	  S symClsDesc=$P(data,deli,2)
	  Continue:'$l(symClsCode)
	  S symArrayStr=symArrayStr_"{"
	  S symArrayStr=symArrayStr_"title:'"_symClsDesc_"',"
	  S symArrayStr=symArrayStr_"code:'"_symClsCode_"',"
	  S symArrayStr=symArrayStr_"autoScroll:true"
	  S symArrayStr=symArrayStr_"},"
	  
	  S symItem=""
	  S symItmData=##class(web.DHCLabUtlCore).GetDictGroupChilds(symClsCode)
	  F j=1:1:$l(symItmData,reDeli) {
		S data=$P(symItmData,reDeli,j)
		S symCode=$P(data,deli,1)
		Continue:'$l(symCode)
		S symDesc=$P(data,deli,2)
		S symSelected="N"
		S symItem=symItem_symCode_tFieldDeli_symDesc_tFieldDeli_symSelected_tFieldDeli_tRecDeli 
	  }
	  
	  I $l(symItem) {
		S symStoreData=symStoreData_symClsCode_"^"_..BuildStoreData("SYMPTOM",symItem)_$C(3)	  
	  }
   }
   I $l(symArrayStr,",")>0 {
	  S symArrayStr=$E(symArrayStr,1,$l(symArrayStr)-1)	 
   }
   S symArrayStr=symArrayStr_"]"
   
   
   //--------------------------------------------------------------------------------
   //----反应类型
   S reacTypeStr="[",reacTypeStoreData=""
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("T")
   S reacTypeClsData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(reacTypeClsData,reDeli) {
	  S data=$P(reacTypeClsData,reDeli,i)
	  S reacTypeClsCode=$P(data,deli,1)
	  S reacTypeClsDesc=$P(data,deli,2)
	  Continue:'$l(reacTypeClsCode)
	  S reacTypeStr=reacTypeStr_"{"
	  S reacTypeStr=reacTypeStr_"title:'"_reacTypeClsDesc_"',"
	  S reacTypeStr=reacTypeStr_"code:'"_reacTypeClsCode_"',"
	  S reacTypeStr=reacTypeStr_"autoScroll:true"
	  S reacTypeStr=reacTypeStr_"},"
	  
	  S reacTypeItem=""
	  S reacTypeItmData=##class(web.DHCLabUtlCore).GetDictGroupChilds(reacTypeClsCode)
	  F j=1:1:$l(reacTypeItmData,reDeli) {
		S data=$P(reacTypeItmData,reDeli,j)
		S reacTypeCode=$P(data,deli,1)
		Continue:'$l(reacTypeCode)
		S reacTypeDesc=$P(data,deli,2)
		S reacTypeSelected="N"
		S reacTypeItem=reacTypeItem_reacTypeCode_tFieldDeli_reacTypeDesc_tFieldDeli_reacTypeSelected_tFieldDeli_tRecDeli 
	  }
	  
	  I $l(reacTypeItem) {
		S reacTypeStoreData=reacTypeStoreData_reacTypeClsCode_"^"_..BuildStoreData("REACTIONTYPE",reacTypeItem)_$C(3)	  
	  }
   }
   I $l(reacTypeStr,",")>0 {
	  S reacTypeStr=$E(reacTypeStr,1,$l(reacTypeStr)-1)	 
   }
   S reacTypeStr=reacTypeStr_"]"
   
   /*
   //--------------------------------------------------------------------------------
   //----反应类型
   S reacTypeOther="",reacTypeStoreData=""
   S reacTypeStr="[{"	
   S reacTypeStr=reacTypeStr_"layout:'table',"
   S reacTypeStr=reacTypeStr_"layoutConfig:{"
   S reacTypeStr=reacTypeStr_"tableAttrs:{"
   S reacTypeStr=reacTypeStr_"	cellspacing : 4,"
   S reacTypeStr=reacTypeStr_"	cellpadding : 4, "
   S reacTypeStr=reacTypeStr_"	border:0 ,"
   S reacTypeStr=reacTypeStr_"	style:{width:'100%'}"
   S reacTypeStr=reacTypeStr_"},columns:6},"
   S reacTypeStr=reacTypeStr_"items:"				
   S reacTypeStr=reacTypeStr_"["
   S reactionData=##class(web.DHCLabUtlCore).GetDictGroupChilds("G009")
    F i=1:1:$l(reactionData,reDeli) {
	  S data=$P(reactionData,reDeli,i)
	  S reacTypeCode=$P(data,deli,1)
	  Continue:'$l(reacTypeCode)
	  S reacTypeDesc=$P(data,deli,2)
	  S layoutRowID=$P(data,deli,5)
	  S formRead=formRead_reacTypeCode_"^"
	  S layoutData=##class(web.DHCLabUtlCore).GetLayout(layoutRowID)
	  S layoutType=""
	  I $l(layoutData) {
	  	S layoutType=$ZCVT($P(layoutData,deli,1),"L")	  
	  }
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(reacTypeCode,reacTypeDesc,layoutRowID,"checkbox")
	  I $l(extItm) {
		  I layoutType'="textfield" {
		   	S reacTypeStr=reacTypeStr_extItm_","
		  }ELSE{
			S reacTypeOther=reacTypeOther_extItm_","
		  }
	  }
	  
	}
	I $l(reacTypeStr,",")>0 {
	  S reacTypeStr=$E(reacTypeStr,1,$l(reacTypeStr)-1)	 
    }
    I $l(reacTypeOther,",")>0 {
	  S reacTypeOther=$E(reacTypeOther,1,$l(reacTypeOther)-1)	 
    }
    S reacTypeStr=reacTypeStr_"]}"
    I $l(reacTypeOther) {
		S reacTypeStr=reacTypeStr_","_reacTypeOther
	}
    S reacTypeStr=reacTypeStr_"]"
    */
   //--------------------------------------------------------------------------------
   //----生命体征
   S vitalSign="["
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("VS")
   S vitalSignData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(vitalSignData,reDeli) {
	  S data=$P(vitalSignData,reDeli,i)
	  S vitalSignCode=$P(data,deli,1)
	  Continue:'$l(vitalSignCode)
	  S vitalSignDesc=$P(data,deli,2)
	  S formRead=formRead_vitalSignCode_"^"
	  S layoutRowID=$P(data,deli,5)
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(vitalSignCode,vitalSignDesc,layoutRowID,"textfield")
	  I $l(extItm) {
		 S labInfo="{xtype : 'label',text : '"_vitalSignDesc_":'}"
		 S vitalSign=vitalSign_labInfo_","_extItm_","
	  }
	}
	I $l(vitalSign,",")>0 {
	  S vitalSign=$E(vitalSign,1,$l(vitalSign)-1)	 
    }
    S vitalSign=vitalSign_"]"
    
    
   //--------------------------------------------------------------------------------
   //----临床处理情况
   S clinProcStr="["
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("CP")
   S clinProcData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(clinProcData,reDeli) {
	  S data=$P(clinProcData,reDeli,i)
	  S clinProcCode=$P(data,deli,1)
	  Continue:'$l(clinProcCode)
	  S clinProcDesc=$P(data,deli,2)
	  S formRead=formRead_clinProcCode_"^"
	  S layoutRowID=$P(data,deli,5)
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(clinProcCode,clinProcDesc,layoutRowID,"textfield")
	  S:$l(extItm) clinProcStr=clinProcStr_extItm_","
	}
	I $l(clinProcStr,",")>0 {
	  S clinProcStr=$E(clinProcStr,1,$l(clinProcStr)-1)	 
    }
    S clinProcStr=clinProcStr_"]"
    
   //--------------------------------------------------------------------------------
   //----不良反应结果
   S effectStr="["
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("E")
   S effectData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(effectData,reDeli) {
	  S data=$P(effectData,reDeli,i)
	  S effectCode=$P(data,deli,1)
	  Continue:'$l(effectCode)
	  S effectDesc=$P(data,deli,2)
	  S formRead=formRead_effectCode_"^"
	  S layoutRowID=$P(data,deli,5)
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(effectCode,effectDesc,layoutRowID,"radio","effect")
	  S:$l(extItm) effectStr=effectStr_extItm_","
	}
	I $l(effectStr,",")>0 {
	  S effectStr=$E(effectStr,1,$l(effectStr)-1)	 
    }
    S effectStr=effectStr_"]"

 	
   //输血科处理情况
    
   //--------------------------------------------------------------------------------
   //----血袋信息
   S packInfoData=##class(web.DHCBldSymptom).GetCurTransPacks(patAdmID)
   S packInfo=..BuildStoreData("PACK",packInfoData)
   //--------------------------------------------------------------------------------
   //病人基本信息
   S patInfoData=##class(web.DHCBldSymptom).GetPatInfo("",patAdmID)
   
   S layoutCols=5,num=1,colRate=$NUMBER(1/layoutCols,2)
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("PAT")
   S patInfoItem=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
   F i=1:1:$l(patInfoItem,reDeli) {
	  S data=$P(patInfoItem,reDeli,i)
	  S patInfoCode=$P(data,deli,1)
	  Continue:'$l(patInfoCode)
	  S:num>layoutCols num=1
	  I $g(layoutCol(num))="" {
	      S layoutCol(num)="{columnWidth:"_colRate_",layout:'form',items:[" 	
	  }
	  
	  S patInfoDesc=$P(data,deli,2)
	  S layoutRowID=$P(data,deli,5)
	  S dataPos=+$P(data,deli,8)
	  S other=$P(data,deli,9)
	  S value=""
	  S:dataPos>0 value=$P(patInfoData,deli,dataPos)
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(patInfoCode,patInfoDesc,layoutRowID,"textfield",value)
	  I $l(extItm) {
	  	 S layoutCol(num)=layoutCol(num)_extItm_","	
	  	 S num=num+1  
	  }
	}
	//既往史
	S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("H")
	S pastHistData=##class(web.DHCLabUtlCore).GetDictGroupChilds(gpCode)
	F i=1:1:$l(pastHistData,reDeli) {
	  S data=$P(pastHistData,reDeli,i)
	  S pastHistCode=$P(data,deli,1)
	  Continue:'$l(pastHistCode)
	  S:num>layoutCols num=1
	  I $g(layoutCol(num))="" {
	      S layoutCol(num)="{columnWidth:"_colRate_",layout:'form',items:["  	
	  }
	  S formRead=formRead_pastHistCode_"^"
	  S pastHistDesc=$P(data,deli,2)
	  S layoutRowID=$P(data,deli,5)
	  S extItm=##class(web.DHCLabUtlExtItem).GetLayoutExtData(pastHistCode,pastHistDesc,layoutRowID,"textfield")
	  I $l(extItm) {
	  	 S layoutCol(num)=layoutCol(num)_extItm_","	
	  	 S num=num+1  
	  }
	}
	
	S patInfo="["
	F num=1:1:layoutCols {
		I $g(layoutCol(num))="" {
	      S layoutCol(num)="{columnWidth:"_colRate_",layout:'form',items:[{}]}" 	
	  	}ELSE{
		  	I $l(layoutCol(num),",")>0 {
	  			S layoutCol(num)=$E(layoutCol(num),1,$l(layoutCol(num))-1)	 
    		}
    		S layoutCol(num)=layoutCol(num)_"]}"
		}
		S patInfo=patInfo_layoutCol(num)_","	
	}
	I $l(patInfo,",")>0 {
	  S patInfo=$E(patInfo,1,$l(patInfo)-1)	 
    }
    S patInfo=patInfo_"]"
  
   S formRead=formRead_"storePackInfo"_"^"
   S formRead=formRead_"arrReacType"_"^"
   S formRead=formRead_"arrSymptom"_"^"
   S formRead=formRead_"allChkBox"_"^"
   S formRead=formRead_"storePackInfo"_"^"
   S formRead=formRead_"effectType"_"^"
   
    
   S other=""
   S ret=patInfo_tDeli_packInfo_tDeli_symArrayStr_tDeli_symStoreData_tDeli_reacTypeStr_tDeli_reacTypeStoreData_tDeli_vitalSign_tDeli
   S ret=ret_clinProcStr_tDeli_effectStr_tDeli_other_tDeli_formRead_tDeli
   Q ret
}

ClassMethod BuildFormRead(formRead As %String) As %String
{
	N (formread)
	S formread=$g(formread)
	S ret=""
	Q:'$l(formread) ret
	
	S ret="["
	F i=1:1:$l(formread,"^") {
		S item=$P(formread,"^",i)
		Continue:'$L(item)
		S ret=ret_"{name:'"_item_"',mapping:'"_item_"',type:'string'},"
	}
	
	//加入自定义
	
	
	I $l(ret,",")>0 {
	  S ret=$E(ret,1,$l(ret)-1)	 
    }
    S ret=ret_"]"
	
	Q ret
}

/// ------------------------------------------------------------------------------------
/// Creator：		wwh
/// CreateDate：		2012-02-4
/// Description：	获取记录单布局数据
/// Table：			无
/// Input：			recordID:记录单号码,patAdmID:就诊号,userCode:当前用户代码
/// Output：			无
/// Return：			ret:布局Json格式数据
/// Others：			病人基本信息暂不加载
ClassMethod GetLayoutDataByRecordID(recordID As %String, patAdmID As %String, userCode As %String) As %String
{
   N (recordID,patAdmID,userCode)
   S tDeli=$C(2),tFieldDeli=$C(3)
   S recordData=##Class(web.DHCBldSymptom).GetRecordInfo(recordID,patAdmID,userCode)
   
   //除了Grid中展现的数据外,其他数据都通过Form自动赋值
   S index=1,fieldDataDeli=$C(2),fieldDeli3=$C(3),fieldDeli4=$C(4),stFDeli=$C(3),stRDeli=$C(2)
   S basicInfo=$P(recordData,fieldDataDeli,index),index=index+1	//基本信息
   S symptom=$P(recordData,fieldDataDeli,index),index=index+1	//症状类型
   S symptomPackRowIDs=$P(recordData,fieldDataDeli,index),index=index+1	//血袋信息(只查询RowID)
   S reacTypes=$P(recordData,fieldDataDeli,index),index=index+1	//反应类型
   S vitalSign=$P(recordData,fieldDataDeli,index),index=index+1  //生命体征
   S clinProc=$P(recordData,fieldDataDeli,index),index=index+1 	//临床处理情况
   S effect=$P(recordData,fieldDataDeli,index),index=index+1	//不良反应结果,需要特殊处理
   S pastHistory=$P(recordData,fieldDataDeli,index),index=index+1  //既往史	
   S bldBankProc=$P(recordData,fieldDataDeli,index),index=index+1  //输血科处理情况
   S other=$P(recordData,fieldDataDeli,index),index=index+1		//其他
   //-------------------------------------------------------------------------------------------
   S fieldDeli=$C(2),(fieldKeys,fieldVals)="",allChkBox=""
   //---------------------------------------------------1
   //基本信息
   
   K ^TMP($zn,$j,"BASIC")
   S statusCode=""
   S fCode=""
   F{
		S fCode=$O(^DHCBLDREACTIONCFG("F",fCode))  
		Q:'$l(fCode)
		S dataPos=$P($G(^DHCBLDREACTIONCFG("F",fCode)),"\",4)
		Continue:dataPos'?1.N
		S dataPos=+dataPos
		S iVal=$P(basicInfo,fieldDeli3,dataPos) 
		S fieldKeys=fieldKeys_fCode_fieldDeli
   		S fieldVals=fieldVals_iVal_fieldDeli
   		
   		S:fCode="patAdmID" patAdmID=iVal
   		S:fCode="recordID" recordID=iVal
   		S:fCode="statusCode" statusCode=iVal
    }
   
   //---------------------------------------------------2,String
   //症状类型,暂时只取代码,未考虑描述
   S arrSymptom=""
   F i=1:1:$L(symptom,fieldDeli3) {
       S data=$P(symptom,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S arrSymptom=arrSymptom_iCode_"^"
   }
   S fieldKeys=fieldKeys_"arrSymptom"_fieldDeli
   S fieldVals=fieldVals_arrSymptom_fieldDeli
   //---------------------------------------------------3,Store
   //血袋信息,需查询具体数据
   K ^TMP($zn,$j,"PACK")
   S storePackInfo="",index=0
   F i=1:1:$L(symptomPackRowIDs,fieldDeli3) {
       S data=$P(symptomPackRowIDs,fieldDeli3,i)
	   S packRowID=$P(data,fieldDeli4,1)
	   S packMainID=$P(packRowID,"||",1)  	//献血码
	   S packSubID=$P(packRowID,"||",2)
	   Continue:('$l(packMainID))||('$L(packSubID))
	   S packData=$g(^TBBP(packMainID,packSubID))
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
       S selected="true"	//是否选择
       
       S storePackInfo=storePackInfo_index_stFDeli_packRowID_stFDeli_packMainID_stFDeli_productID_stFDeli_packDesc_stFDeli
       S storePackInfo=storePackInfo_bldGroup_stFDeli_volume_stFDeli_unit_stFDeli_selected_stRDeli
       
	   S ^TMP($zn,$j,"PACK",packRowID)=""
   }
   //此处要根据记录单状态判断是否加载待选血袋信息
   I statusCode="S" {   //保存状态时,加载其他血袋
	   S packInfoData=##class(web.DHCBldSymptom).GetCurTransPacks(patAdmID)
	   F i=1:1:$L(packInfoData,stRDeli) {
			S data=$P(packInfoData,stRDeli,i)
			S packRowID=$P(data,stFDeli,2)
			Continue:'$l(packRowID)
			Continue:$D(^TMP($zn,$j,"PACK",packRowID))'=0
			S packMainID=$P(packRowID,"||",1),packSubID=$P(packRowID,"||",2)
			Continue:('$l(packMainID))||('$l(packSubID))
			S index=index+1
			S $P(data,stFDeli,1)=index
			S storePackInfo=storePackInfo_data_stRDeli
	   }
   }
   K ^TMP($zn,$j,"PACK")
   S storePackInfo=..BuildStoreData("PACK",storePackInfo)
   S:$L(storePackInfo) storePackInfo=""""_storePackInfo_""""
   S fieldKeys=fieldKeys_"storePackInfo"_fieldDeli
   S fieldVals=fieldVals_storePackInfo_fieldDeli
   
   //---------------------------------------------------4,String
   //反应类型
   S arrReacType=""
   F i=1:1:$L(reacTypes,fieldDeli3) {
       S data=$P(reacTypes,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S arrReacType=arrReacType_iCode_"^"
   }
   S fieldKeys=fieldKeys_"arrReacType"_fieldDeli
   S fieldVals=fieldVals_arrReacType_fieldDeli
   
   //---------------------------------------------------5,String
   //生命体征,需要找出CheckBox布局的元素
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("VS")
   F i=1:1:$L(vitalSign,fieldDeli3) {
       S data=$P(vitalSign,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S iVal=$P(data,fieldDeli4,2)
	   I $$IsCheckBox(gpCode,iCode) { 
	   		S allChkBox=allChkBox_iCode_"^"
	   }ELSE {
			S fieldKeys=fieldKeys_iCode_fieldDeli
            S fieldVals=fieldVals_iVal_fieldDeli  
	   }
   }
   
   //---------------------------------------------------6,String
   //临床处理情况,需要找出CheckBox布局的元素
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("CP")
   F i=1:1:$L(clinProc,fieldDeli3) {
       S data=$P(clinProc,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S iVal=$P(data,fieldDeli4,2)
	   I $$IsCheckBox(gpCode,iCode) { 
	   		S allChkBox=allChkBox_iCode_"^"
	   }ELSE {
			S fieldKeys=fieldKeys_iCode_fieldDeli
            S fieldVals=fieldVals_iVal_fieldDeli  
	   }
   }
   
   //---------------------------------------------------7,String
   //不良反应结果
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("E")
   S data=$P(effect,fieldDeli3,1)
   S iCode=$P(data,fieldDeli4,1)
   I $l(iCode) {
	   S iVal=$P(data,fieldDeli4,2)
	   S iValDate=$P(data,fieldDeli4,3)
	   S iValTime=$P(data,fieldDeli4,4)
	   S fieldKeys=fieldKeys_"effectReason"_fieldDeli
       S fieldVals=fieldVals_iVal_fieldDeli
       S fieldKeys=fieldKeys_"effectDate"_fieldDeli
       S fieldVals=fieldVals_iValDate_fieldDeli
       S fieldKeys=fieldKeys_"effectTime"_fieldDeli
       S fieldVals=fieldVals_iValTime_fieldDeli
       S fieldKeys=fieldKeys_"effectType"_fieldDeli
       S fieldVals=fieldVals_iCode_fieldDeli
   }
   
   //---------------------------------------------------8,String
   //既往史,需要找出CheckBox布局的元素
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("H")
   F i=1:1:$L(pastHistory,fieldDeli3) {
       S data=$P(pastHistory,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S iVal=$P(data,fieldDeli4,2)
	   I $$IsCheckBox(gpCode,iCode) { 
	   		S allChkBox=allChkBox_iCode_"^"
	   }ELSE {
			S fieldKeys=fieldKeys_iCode_fieldDeli
            S fieldVals=fieldVals_iVal_fieldDeli  
	   }
   }
   
   //---------------------------------------------------9,String
   //输血科处理情况,需要找出CheckBox布局的元素
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("BP")
   F i=1:1:$L(bldBankProc,fieldDeli3) {
       S data=$P(bldBankProc,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S iVal=$P(data,fieldDeli4,2)
	   I $$IsCheckBox(gpCode,iCode) { 
	   		S allChkBox=allChkBox_iCode_"^"
	   }ELSE {
			S fieldKeys=fieldKeys_iCode_fieldDeli
            S fieldVals=fieldVals_iVal_fieldDeli  
	   }
   }
   
   //---------------------------------------------------10,String
   //其他,需要找出CheckBox布局的元素
   S gpCode=##class(web.DHCBldSymptom).GetDataFiledsGroupCode("BP")
   F i=1:1:$L(other,fieldDeli3) {
       S data=$P(other,fieldDeli3,i)
	   S iCode=$P(data,fieldDeli4,1)
	   Continue:'$l(iCode)
	   S iVal=$P(data,fieldDeli4,2)
	   I $$IsCheckBox(gpCode,iCode) { 
	   		S allChkBox=allChkBox_iCode_"^"
	   }ELSE {
			S fieldKeys=fieldKeys_iCode_fieldDeli
            S fieldVals=fieldVals_iVal_fieldDeli  
	   }
   }
   S fieldKeys=fieldKeys_"allChkBox"_fieldDeli
   S fieldVals=fieldVals_allChkBox_fieldDeli
   
   //---------------------------------------------------11
   //绑定部分固定元素 
  
   //---------------------------------------------------12
   //绑定隐藏元素	
       
   K ^TMP($zn,$j)
   S ^TMP($zn,$j,0)=fieldKeys
   S ^TMP($zn,$j,1)=fieldVals
   S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
   S ret=jsonStr
  
   Q ret
   
IsCheckBox(gpCode,iCode)
   N (gpCode,iCode)
   S ret=##class(web.DHCLabUtlCore).CheckLayoutItem(gpCode,iCode,"checkbox")
   Q ret
}

ClassMethod BuildFieldsData(layoutType As %String, valData As %String) As %String
{
   S layoutType=$g(layoutType),valData=$g(valData)
   Q:'$l(layoutType) ""
   S rset = ##class(%ResultSet).%New("web.DHCBldSymptomConfig:SelectLayoutFields")
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
	   S fieldStr=fieldStr_"xtype:'"_xtype_"',"
	   S fieldStr=fieldStr_"fieldLabel:'"_fieldDesc_"',"
	   S fieldStr=fieldStr_"name:'"_fieldCode_"',"
	   I $l(vtype){
		  S fieldStr=fieldStr_"vtype:'"_vtype_"'," 
		  }
	   S fieldStr=fieldStr_"value:'"_value_"',"
	   S fieldStr=fieldStr_"allowBlank:"_isAllowBlank_","
	   S fieldStr=fieldStr_"readOnly:"_isReadOnly_","
	   S fieldStr=fieldStr_"hidden:"_hidden_","
	   S fieldStr=fieldStr_"hideLabel:"_hidden_","
	   S fieldStr=fieldStr_"anchor:'"_anchor_"'}"
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

ClassMethod BuildStoreData(storeType As %String, valData As %String) As %String
{
	N (storeType,valData)
	S storeType=$g(storeType),valData=$g(valData)
	S storeType=$g(storeType),valData=$g(valData),ret="",tDeli=$C(2)
	S tRecDeli=$C(3),tFieldDeli=$C(2),index=0,jsonStr=""
	S storeFields=##Class(web.DHCBldSymptomConfig).GetStoreFields(storeType)
	
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
	
 	I $E(ret,$l(ret))="," {
 		S ret=$E(ret,1,$l(ret)-1)	 
 	}
 	S ret=ret_"]"
 	S:ret="[]" ret="[{}]" 
 	Q ret
}

ClassMethod GetFormFieldData(ByRef request As %CSP.Request) As %String
{
   N (request)
   S request=$g(request)
   S deli=$C(3)
   //基本字段
   S patAdmID=$g(request.Data("patAdmID",1))			//就诊号
   S recordID=$g(request.Data("recordID",1))			//记录单ID
   S startTransDate=$g(request.Data("startTransDate",1))		//输血开始日期
   S startTransDate=##class(web.DHCLabUtlCore).CvnToSysDate(startTransDate)
   S startTransTime=$g(request.Data("startTransTime",1))		//输血开始时间
   S startTransTime=##class(web.DHCLabUtlCore).CvnToSysTime(startTransTime)
   S endTransDate=$g(request.Data("endTransDate",1))	//输血结束日期
   S endTransDate=##class(web.DHCLabUtlCore).CvnToSysDate(endTransDate)
   S endTransTime=$g(request.Data("endTransTime",1))	//输血结束时间
   S endTransTime=##class(web.DHCLabUtlCore).CvnToSysTime(endTransTime)
   S reactionOccurDate=$g(request.Data("reactionOccurDate",1))		//输血反应发生日期
   S reactionOccurDate=##class(web.DHCLabUtlCore).CvnToSysDate(reactionOccurDate)
   S reactionOccurTime=$g(request.Data("reactionOccurTime",1))		//输血反应发生时间
   S reactionOccurTime=##class(web.DHCLabUtlCore).CvnToSysTime(reactionOccurTime)
   S anesType=$g(request.Data("anesType",1))			//输血时麻醉方式
   S donorRelType=$g(request.Data("donorRelType",1))	//献血者关系类型
   S remark =$g(request.Data("remark",1))				//记录单备注
   S basicFiled=patAdmID_"^"_recordID_"^"_startTransDate_"^"_startTransTime_"^"_endTransDate_"^"
   S basicFiled=basicFiled_endTransTime_"^"_reactionOccurDate_"^"_reactionOccurTime_"^"
   S basicFiled=basicFiled_anesType_"^"_donorRelType_"^"_remark_"^"
   
   //基本数据
   S symptom=$g(request.Data("symptom",1))										//反应症状
   S symptomPacks=$g(request.Data("symptomPacks",1))							//血袋信息
   S reactionTypes=$g(request.Data("reactionTypes",1))							//反应类型
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("VS")
   S vitalSign=##class(web.DHCLabUtlCore).BuildRequestData(request,gpCode,1)	//生命体征
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("CP")
   S clinProc=##class(web.DHCLabUtlCore).BuildRequestData(request,gpCode,1)		//临床处理情况
   S effect=$g(request.Data("effect",1))										//不良反应结果
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("H")
   S pastHistory=##class(web.DHCLabUtlCore).BuildRequestData(request,gpCode,1)	//既往史
   S gpCode=##class(web.DHCBldSymptomConfig).GetDataFiledsGroupCode("BP")
   S bldBankProc=##class(web.DHCLabUtlCore).BuildRequestData(request,gpCode,1)	//输血科处理情况
   
   S ret=basicFiled_deli_symptom_deli_symptomPacks_deli_reactionTypes_deli_vitalSign_deli_clinProc_deli
   S ret=ret_effect_deli_pastHistory_deli_bldBankProc_deli
   Q ret
}

ClassMethod DEBUG(layoutType As %String) As %String
{
	S ret=0
 	Q ret
}

}
