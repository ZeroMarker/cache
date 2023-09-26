/// 显示申请单信息
Class web.DHCBldActAppFormShow Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	/*
	S ret="{'success':"_"true"_",'info':'保存成功'}"
	S test=$g(request.Data("patAdmID",1))
	S test2=$g(request.Data("checkDoctor",1))
	S test3=response.CharSet
	
	//S test=request.CharSet
	S ret="{'success':"_"true"_",'info':'"_"CharSet:"_request.CharSet_",Response:"_test3_",POST:"_test_",URL:"_test2_"'}"
	w ret
	*/
	
 S EpisodeID=$g(request.Data("EpisodeID",1))
 //S %request.CharSet="UTF-8" 
 //S %response.CharSet="UTF-8" 
 //D %request.ConvertCharSet() 
 //S %response.HeaderCharSet="UTF-8" 

 S tDeli="^"
 S patAppInfo=##Class(web.DHCBldAppForm).GetPatAppForm("","",EpisodeID,"")
 
 //1patRegNo_tDeli_2admID_tDeli_3patLocDesc_tDeli_4patRoomDesc_tDeli_5patSex_tDeli_6patName_tDeli
 //7safetyNetCardNo_tDeli_8patBed_tDeli_9patBirth_tDeli_10patAge_tDeli_11patWardDesc_tDeli
 //12patHomeAddress_tDeli_13patHomeTel_tDeli_14patWorkTel_tDeli_15patMobileTel_tDeli
 //16patCardID_tDeli_17patType_tDeli_18patTypeDesc_tDeli_19patCountry_tDeli_20patPeople_tDeli_21patDiagnoseDesc_tDeli
 //22patApanage_tDeli_23isLocal_tDeli_24patLocationDr_tDeli_25patWardDr_tDeli_26patRoomDr_tDeli
 
 //----------------------------------------------------------------------------------------------->
 //病人基本信息
 S valPatRegNo=$P(patAppInfo,tDeli,1)		//登记号
 S valPatAdmID=$P(patAppInfo,tDeli,2)		//就诊号
 S valPatName=$P(patAppInfo,tDeli,6)		//姓名
 S valPatSex=$P(patAppInfo,tDeli,5)			//性别
 S valPatBOD=$P(patAppInfo,tDeli,9)			//生日
 S valPatAge=$P(patAppInfo,tDeli,10)		//年龄
 S valPatLoc=$P(patAppInfo,tDeli,3)			//科室
 S valPatBed=$P(patAppInfo,tDeli,8)			//床号
 S valPatAddress=$P(patAppInfo,tDeli,12)		//地址
 S valPatTel=$P(patAppInfo,tDeli,13)			//电话
 S valPatPepole=$P(patAppInfo,tDeli,20)		//民族
 S valPatDiag=$P(patAppInfo,tDeli,21)		//诊断
 S valPatBldTypeABO="A"
 S valPatBldTypeRH="Rh(D)阳性"
 S valPatBldTypeOther=""
 S valAppFormID=""			//申请单编号
 //----------------------------------------------------------------------------------------------->
 //既往史
 S anamnesisData="["
 
 S anamnesisData=anamnesisData_"{columnWidth:.33,layout: 'form',labelWidth: 70,items: [{"
 S xtype="textfield",fieldLabel="输血(次数)",fieldName="transTimes",allowBlank="true",value="'0'",vtype="'posInteger'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",vtype:"_vtype_",anchor:'90%'},{"
 S xtype="textfield",fieldLabel="输血反应史",fieldName="transAna",allowBlank="true",value="'无'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",anchor:'90%'}]"
 S anamnesisData=anamnesisData_"},"
 
 S anamnesisData=anamnesisData_"{columnWidth:.33,layout: 'form',labelWidth: 70,items: [{"
 S xtype="textfield",fieldLabel="孕(次数)",fieldName="ycs",allowBlank="true",value="'0'",vtype="'posInteger'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",vtype:"_vtype_",anchor:'90%'},{"
 S xtype="textfield",fieldLabel="药物过敏史",fieldName="gms",allowBlank="true",value="'无'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",anchor:'90%'}]"
 S anamnesisData=anamnesisData_"},"
 
 S anamnesisData=anamnesisData_"{columnWidth:.34,layout: 'form',labelWidth: 70,items: [{"
 S xtype="textfield",fieldLabel="产(次数)",fieldName="ccs",allowBlank="true",value="'0'",vtype="'posInteger'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",vtype:"_vtype_",anchor:'90%'},{"
 S xtype="textfield",fieldLabel="其他既往史",fieldName="otherjws",allowBlank="true",value="'无'"
 S anamnesisData=anamnesisData_"xtype:'"_xtype_"',fieldLabel: '"_fieldLabel_"',name: '"_fieldName_"',"
 S anamnesisData=anamnesisData_"allowBlank:"_allowBlank_",value:"_value_",anchor:'90%'}]"
 S anamnesisData=anamnesisData_"}];"
 

 
 //----------------------------------------------------------------------------------------------->
 //--输血类型
 S transTypeData="["
 //TODO:动态生成
 S trTypeName="手术输血",trTypeVal="ssxx"
 S transTypeData=transTypeData_"{name:'"_trTypeName_"',value:'"_trTypeVal_"'},"
 S trTypeName="常规治疗",trTypeVal="cczl"
 S transTypeData=transTypeData_"{name:'"_trTypeName_"',value:'"_trTypeVal_"'},"
 S trTypeName="紧急输血",trTypeVal="jjxx"
 S transTypeData=transTypeData_"{name:'"_trTypeName_"',value:'"_trTypeVal_"'},"
 S trTypeName="大量输血",trTypeVal="dlxx"
 S transTypeData=transTypeData_"{name:'"_trTypeName_"',value:'"_trTypeVal_"'}"
 
 S transTypeData=transTypeData_"]"
 S valTransType="手术输血"
 
 //----------------------------------------------------------------------------------------------->
 //--输血目的
 S transTargetData="["
 //TODO:动态生成
 S labelDesc="补充凝血因子",labelName="bcnxyz",checked="true"
 S transTargetData=transTargetData_"{boxLabel: '"_labelDesc_"', name: '"_labelName_"',checked:"_checked_"},"
 S labelDesc="补充红细胞",labelName="bchxb",checked="false"
 S transTargetData=transTargetData_"{boxLabel: '"_labelDesc_"', name: '"_labelName_"',checked:"_checked_"},"
 S labelDesc="补充血小板",labelName="bcxxb",checked="false"
 S transTargetData=transTargetData_"{boxLabel: '"_labelDesc_"', name: '"_labelName_"',checked:"_checked_"},"
 S labelDesc="补充粒细胞",labelName="bclxb",checked="false"
 S transTargetData=transTargetData_"{boxLabel: '"_labelDesc_"', name: '"_labelName_"',checked:"_checked_"},"
 S labelDesc="补充血容量",labelName="bcrxl",checked="false"
 S transTargetData=transTargetData_"{boxLabel: '"_labelDesc_"', name: '"_labelName_"',checked:"_checked_"}"
 
 S transTargetData=transTargetData_"];"
 //-----------------------------------------------------------------------------------------------<
 
 //----------------------------------------------------------------------------------------------->
 //--输血医嘱
 S orderData="["
 //TODO：动态生成
 S seq="1",OEOrdRowID="1234||1",labNo="23456789",orderDesc="备红细胞悬液",volume="400"
 S unit="ml",bldTypeABO="A",bldTypeRH="Rh(D)阴性",remark="备注123",select="true"
 S orderData=orderData_"['"_seq_"','"_OEOrdRowID_"','"_labNo_"','"_orderDesc_"',"_volume_",'"_unit_"','"_bldTypeABO_"','"_bldTypeRH_"','"_remark_"',"_select_"],"
 S seq="2",OEOrdRowID="1234||2",labNo="23456711",orderDesc="备新鲜冰冻血浆",volume="400"
 S unit="ml",bldTypeABO="B",bldTypeRH="Rh(D)阴性",remark="备注123",select="true"
 S orderData=orderData_"['"_seq_"','"_OEOrdRowID_"','"_labNo_"','"_orderDesc_"',"_volume_",'"_unit_"','"_bldTypeABO_"','"_bldTypeRH_"','"_remark_"',"_select_"],"
 S seq="3",OEOrdRowID="1234||3",labNo="23456722",orderDesc="备机采血小板",volume="400"
 S unit="ml",bldTypeABO="AB",bldTypeRH="Rh(D)阳性",remark="备注123",select="true"
 S orderData=orderData_"['"_seq_"','"_OEOrdRowID_"','"_labNo_"','"_orderDesc_"',"_volume_",'"_unit_"','"_bldTypeABO_"','"_bldTypeRH_"','"_remark_"',"_select_"],"
 S seq="4",OEOrdRowID="1234||4",labNo="23456733",orderDesc="备某某某",volume="400"
 S unit="ml",bldTypeABO="A",bldTypeRH="Rh(D)阴性",remark="备注123",select="false"
 S orderData=orderData_"['"_seq_"','"_OEOrdRowID_"','"_labNo_"','"_orderDesc_"',"_volume_",'"_unit_"','"_bldTypeABO_"','"_bldTypeRH_"','"_remark_"',"_select_"]"
 S orderData=orderData_"];"
 //-----------------------------------------------------------------------------------------------<
 
 //----------------------------------------------------------------------------------------------->
 //生命体征
 S valPatBodyWeight="72.2"			//体重
 S valPatHeight="178.5"				//身高
 S valPatBldPressure="60/120"		//血压
 S valPatPulse="78"					//脉搏
 S valPatBodyTemperature="36.7"		//体温
 
 //----------------------------------------------------------------------------------------------->
 //用血信息
 S valSelfUseBldDate="2010年12月11日"	//预定用血日期
 S valSelfUseBldTime="12:00 AM"			//预定用血时间
 S valSelfColBldVolume="450"			//预定用血量
 
 //----------------------------------------------------------------------------------------------->
 //化验项目
 S dataTestItems="["
 //TODO：动态生成
 S seq="1",itemCode="HIV",itemDesc="HIV",itemValue="阴性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"],"
 
 S seq="2",itemCode="HBV",itemDesc="HBV",itemValue="阴性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"],"
 
 S seq="3",itemCode="HCV",itemDesc="HCV",itemValue="阴性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"],"
 
 S seq="4",itemCode="HIV",itemDesc="HIV",itemValue="阴性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"],"
 
 S seq="5",itemCode="HIV",itemDesc="HIV",itemValue="阴性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"],"
 
 S seq="6",itemCode="HIV",itemDesc="HIV",itemValue="阳性"
 S dataTestItems=dataTestItems_"['"_seq_"','"_itemCode_"','"_itemDesc_"','"_itemValue_"'"_"]"
 
 S dataTestItems=dataTestItems_"];"
  
  &html<
	<HTML>
		<HEAD>
		<meta content="text/html; charset=utf-8">
		<!-- ** CSS ** -->
		<!-- base library -->
		<link rel="stylesheet" type="text/css" href="../scripts/lisjs/extjs/resources/css/ext-all.css" />
		<link rel="stylesheet" type="text/css" href="../scripts/lisjs/css/buttons.css"/>
		<!-- ** Javascript ** -->
		<!-- ExtJS library: base/adapter -->
		<script type="text/javascript" src="../scripts/lisjs/extjs/adapter/ext/ext-base.js"></script>
		<!-- ExtJS library: all widgets -->
		<script type="text/javascript" src="../scripts/lisjs/extjs/ext-all.js"></script>
		<script type="text/javascript" src="../scripts/lisjs/extjs/ext-lang-zh_CN.js" charset="utf-8"></script>
		<script type="text/javascript" src="../scripts/lisjs/extjs/validation.js"></script>
		<!-- overrides to base library -->
		<!-- page specific -->
		<script type="text/javascript" src="../scripts/lisjs/business/DHCBldAppForm.js"></script>
		<script type="text/javascript" src="../scripts/lisjs/extjs/CheckColumn.js"></script>
		
		<TITLE>hello</TITLE>
		 
		>
		w "<SCRIPT language=""Javascript"">",!
		w "var EpisodeID='"_$g(EpisodeID)_"';",!
 		w "var orderData =eval("""_$g(orderData)_""");",!
 	
 		W "var dataTestItems=eval("""_$g(dataTestItems)_""");",!
 		
			
			
			w "var transTargetData=eval("""_$g(transTargetData)_""");"	,!
			
			w "var transTypeData=eval("""_$g(transTypeData)_""");",!
			
			w "var valTransType='"_$g(valTransType)_"';",!
			//病人基本信息
			w "var valPatAdmID='"_$g(valPatAdmID)_"';",!
 			w "var valAppFormID='"_$g(valAppFormID)_"';",!
 			w "var valPatRegNo='"_$g(valPatRegNo)_"';",!
 			w "var valPatName='"_$g(valPatName)_"';",!
 			w "var valPatSex='"_$g(valPatSex)_"';",!
 			w "var valPatBOD='"_$g(valPatBOD)_"';",!
 			w "var valPatAge='"_$g(valPatAge)_"';",!
 			w "var valPatLoc='"_$g(valPatLoc)_"';",!
 			w "var valPatBed='"_$g(valPatBed)_"';",!
 			w "var valPatAddress='"_$g(valPatAddress)_"';",!
 			w "var valPatTel='"_$g(valPatTel)_"';",!
 			w "var valPatPepole='"_$g(valPatPepole)_"';",!
 			w "var valPatDiag='"_$g(valPatDiag)_"';",!
 			w "var valPatBldTypeABO='"_$g(valPatBldTypeABO)_"';",!
 			w "var valPatBldTypeRH='"_$g(valPatBldTypeRH)_"';",!
 			w "var valPatBldTypeOther='"_$g(valPatBldTypeOther)_"';",!
 
 			w "var valPatBodyWeight='"_$g(valPatBodyWeight)_"';",!			//体重
 			w "var valPatHeight='"_$g(valPatHeight)_"';",!					//身高
 			w "var valPatBldPressure='"_$g(valPatBldPressure)_"';",!			//血压
 			w "var valPatPulse='"_$g(valPatPulse)_"';",!					//脉搏
 			w "var valPatBodyTemperature='"_$g(valPatBodyTemperature)_"';",!	//体温
 
 			w "var valSelfUseBldDate='"_$g(valSelfUseBldDate)_"';",!		//预定用血日期
 			w "var valSelfUseBldTime='"_$g(valSelfUseBldTime)_"';",!		//预定用血时间
 			w "var valSelfColBldVolume='"_$g(valSelfColBldVolume)_"';",!	//预定用血量
 
 			//既往史									
 			w "var anamnesisData=eval("""_$g(anamnesisData)_""");",!
 			w "alert(anamnesisData)"
 			w "</SCRIPT><HEAD>",!
		
	     &html<
		 <BODY>	
    		<!-- use class="x-hide-display" to prevent a brief flicker of the content -->
    		<div id="west" class="x-hide-display">
        		<p>Hi. I'm the west panel.</p>
    		</div>
   			<div id="divSelfAppForm" class="x-hide-display"></div>
    		<div id="divNormalAppForm" class="x-hide-display"></div>
    
    		<div id="props-panel" class="x-hide-display" style="width:200px;height:200px;overflow:hidden;">
    		</div>
    		<div id="south" class="x-hide-display">
        		<p>south - generally for informational stuff, also could be for status bar</p>
    		</div>
    
    		<select name="bldTypeABO" id="bldTypeABO" style="display: none;">
    			<option value="A">A</option>
    			<option value="B">B</option>
    			<option value="AB">AB</option>
    			<option value="O">O</option>
    		</select>
    		<select name="bldTypeRH" id="bldTypeRH" style="display: none;">
    			<option value="Rh(D)阳性">Rh(D)阳性</option>
    			<option value="Rh(D)阴性">Rh(D)阴性</option>
    		</select>
    
     		<select name="bldUnit" id="bldUnit" style="display: none;">
    			<option value="ml">ml</option>
    			<option value="U">U</option>
   			</select>
			
			</BODY>
			</HTML>
			>
	Q 0
}

Parameter ActionID = "BLD.APPFORM.SHOW";

Parameter Version = "1.0.0.1";

}
