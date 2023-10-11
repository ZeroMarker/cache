var CMPrescTypeEditRow; 
var CMPrescTypeLinkFeeEditRow;
var CNMeditemInstrDataGrid,InstrDataGridEditRow;
var CNMedPackModeDataGrid,PackModeDataGridEditRow;
var CHNPHFrequenceDataGrid,CHNPHFrequenceDataGridEditRow;
var CNMedCookModeDataGrid,CNMedCookModeDataGridEditRow,SelCNMedCookMode=undefined;
var CNMedAddLongOrderGrid,CNMedAddLongOrderEditRow;
var CNMedCookArcModeDataGrid,CookArcModeDataGridEditRow;
//附加材料 代煎费
var arrayObj1 = new Array(
      //new Array("SSDBCombo_Item","CNMedAppendItem"),
	  new Array("SSDBCombo_CookModeFee","CNMedCookModeFeeItem")
);
//默认频次
var arrayObj2 = new Array(
      new Array("Combo_DefaultFrequence","CNMedDefaultFrequence")
);
//默认用法
var arrayObj3 = new Array(
      new Array("Combo_DefaultInstr","CNMedDefaultInstruction")
);
//默认疗程
var arrayObj4 = new Array(
      new Array("SSDBCombo_DefaultDuration","CNMedDefaultDuration")
);
//子分类设置
var arrayObj5=new Array(
      new Array("List_CMPrescTypeItemCat","CMPrescTypeItemCat",0),
      new Array("List_FormulaItemCat","FormulaItemCat",1)
);
//接收科室设置
var arrayObj6 = new Array(
      new Array("List_CNMedCookDep","CNMedCookDep"),
	  new Array("List_EPCNMedCookDep","EPCNMedCookDep")
);
//check类型
var arrayObj7 = new Array(
      new Array("Check_FormulaCanChangeDose","FormulaCanChangeDose"),
	  new Array("Check_FormulaCanAppendItem","FormulaCanAppendItem"),
	  new Array("Check_NotDisplayZeroStockCMItem","NotDisplayZeroStockCMItem"),
	  new Array("Check_CMOpenForAllHosp","CMOpenForAllHosp"),
	  //new Array("Check_CMOrdNeedTCMDiag","CMOrdNeedTCMDiag"),
	  new Array("Check_CMOrdSameArcName","CMOrdSameArcName"),
	  new Array("Check_CMNoStockOnePrompt","CMNoStockOnePrompt")
);
//默认煎药方式
var arrayObj8 = new Array(
      new Array("SSDBCombo_DefaultCookMode","CNMedDefaultCookMode")
);
$(function(){
	InitHospList();
	$("#SaveDetails").click(SaveDetailsClickHandle);
	$("#SavePublic").click(SavePublicClickHandle);
	$("#ConfigTakingMedicineMethod").click(SaveTakingMedicineMethodHandle);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CMDocConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
		$('#dataTabs').tabs({
			onSelect:function(title,index){
				if(index==1){
					InitPublicTerritory();
				}
			}
		});
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	//初始化处方类型列表
	InittabCMPrescType();
	//debugger
	//初始化右侧界面
	InitPrescTypeDetail("");
	//初始化公共配置区域
	InitPublicTerritory();
}
function LoadCNMedIPDefaultRefLoc()
{
	$("#List_CNMedNormIPDefaultRefLoc").combobox({ 
		mode:'remote',     
    	valueField:'CTLOCRowID',   
    	textField:'CTLOCDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
	    	var desc="";
	    	if (param['q']) {
		    	desc=param['q'];
		    }
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindDep';
			param.Arg1 ="";
			param.Arg2 =desc;
			param.Arg3 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =3;
		}  
	});
}
function SavePublicClickHandle(){
	// 草药录入显示列组数  
	var ViewGroupSum=$("#Txt_ViewGroupSum").val();
	if(ViewGroupSum>4){
		$.messager.alert("提示", "目前系统最多支持4列", "error");
		return false;
	}
	var Data="ViewGroupSum"+String.fromCharCode(1)+ViewGroupSum
	
	var CNMedPrior="";
	var size = $("#List_CNMedPrior option").size();
	if(size>0){
		$.each($("#List_CNMedPrior option:selected"), function(i,own){
			var svalue = $(own).val();
			if (CNMedPrior=="") CNMedPrior=svalue
			else CNMedPrior=CNMedPrior+"^"+svalue
		})
	}
	Data=Data+String.fromCharCode(2)+"CNMedPrior"+String.fromCharCode(1)+CNMedPrior;
	
	var FormulaItemCat="";
	var size = $("#List_FormulaItemCat option").size();
	if(size>0){
		$.each($("#List_FormulaItemCat option:selected"), function(i,own){
			var svalue = $(own).val();
			if (FormulaItemCat=="") FormulaItemCat=svalue
			else FormulaItemCat=FormulaItemCat+"^"+svalue
		})
	}
	Data=Data+String.fromCharCode(2)+"FormulaItemCat"+String.fromCharCode(1)+FormulaItemCat;
	for( var i=0;i<arrayObj7.length;i++) {
		   var param1=arrayObj7[i][0];
		   var param2=arrayObj7[i][1];
	       var CheckedValue=0;
	       if ($("#"+param1+"").is(":checked")) {
	         CheckedValue=1;
           }
          if(Data=="") Data=param2+String.fromCharCode(1)+CheckedValue;
		  else  Data=Data+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
	}
	//就诊类型/药物使用方式
	var AdmType=$("#List_AdmType").combobox('getValue');
	var AdmTypeInstr="";
	var size = $("#List_Instr"+ " option").size();
	if((size>0)&&(AdmType!="")){
		$.each($("#List_Instr"+" option:selected"), function(i,own){
	      var svalue = $(own).val();
		  if (AdmTypeInstr=="") AdmTypeInstr=svalue
		  else AdmTypeInstr=AdmTypeInstr+"^"+svalue
		})
		var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig1",
		   	Node:"AdmTypeInstr",
		   	Node1:AdmType,
		   	NodeValue:AdmTypeInstr,
		   	HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
	}
	var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
	   	Coninfo:Data,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	$.messager.popover({msg: '保存成功!',type:'success'});
}
function SaveDetailsClickHandle(){
	var rows = CMPrescTypeDataGrid.datagrid("getSelections");
	if (rows.length ==0) {
		$.messager.alert("提示","请选择需要保存的处方类型!");
		return
	}
	var PrescTypeCode=rows[rows.length-1].Code;
	
	var CNMedAppendItem=""; //$("#SSDBCombo_Item").combobox("getValue");
	if (!CNMedAppendItem) CNMedAppendItem="";
	//var CNMedCookModeFeeItem=$("#SSDBCombo_CookModeFee").combobox("getValue");
	//if (!CNMedCookModeFeeItem) CNMedCookModeFeeItem="";
	var CNMedCookModeFeeItem=""
	var CNMedDefaultFrequence=$("#Combo_DefaultFrequence").combobox("getValue");
	if (!CNMedDefaultFrequence) CNMedDefaultFrequence="";
	var CNMedDefaultInstruction=$("#Combo_DefaultInstr").combobox("getValue");
	if (!CNMedDefaultInstruction) CNMedDefaultInstruction="";
	var DefaultQtyID=$("#SSDBCombo_DefaultQty").combobox("getValue") 
	var CNMedDefaultDuration=$("#SSDBCombo_DefaultDuration").combobox("getValue");
	if (!CNMedDefaultDuration) CNMedDefaultDuration="";
	var CNMedDefaultCookMode=$("#SSDBCombo_DefaultCookMode").combobox("getValue");
	if (!CNMedDefaultCookMode) CNMedDefaultCookMode="";
	var CNItemCat="";
	var size = $("#List_CMPrescTypeItemCat"+ " option").size();
	if(size>0){
		$.each($("#List_CMPrescTypeItemCat"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (CNItemCat=="") CNItemCat=svalue
			else CNItemCat=CNItemCat+"^"+svalue
		})
	}

	var CNMedCookDep="";
	var size = $("#List_CNMedCookDep"+ " option").size();
	if(size>0){
		$.each($("#List_CNMedCookDep"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (CNMedCookDep=="") CNMedCookDep=svalue
			else CNMedCookDep=CNMedCookDep+"^"+svalue
		})
	}
	
	var EPCNMedCookDep="";
	var size = $("#List_EPCNMedCookDep"+ " option").size();
	if(size>0){
		$.each($("#List_EPCNMedCookDep"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (EPCNMedCookDep=="") EPCNMedCookDep=svalue
			else EPCNMedCookDep=EPCNMedCookDep+"^"+svalue
		})
	}
	
	var CNMedAppendItemQtyCalcu=0; //$("#Check_CNMedAppendItemQtyCalcu").checkbox('getValue')?1:0;
	
	var IPCookModeFeeNoAutoAdd=0; //$("#Check_IPCookModeFeeNoAutoAdd").checkbox('getValue')?1:0;
	
	var ApperFormulaItem=$("#Check_ApperFormulaItem").checkbox('getValue')?1:0;
	
	var PrintFormulaItem=$("#Check_PrintFormulaItem").checkbox('getValue')?1:0;
	var NotAllowChangeCook=$("#Check_NotAllowChangeCook").checkbox('getValue')?1:0;
	var CNMedNormDefaultRefLoc=$("#List_CNMedNormDefaultRefLoc").combobox("getValue");
	var CNMedNormIPDefaultRefLoc=$("#List_CNMedNormIPDefaultRefLoc").combobox("getValue");
	var IPDefaultCMPrescType=$("#Check_IPDefaultCMPrescType").checkbox('getValue')?1:0;
	var OPDefaultCMPrescType=$("#Check_OPDefaultCMPrescType").checkbox('getValue')?1:0;
	var rows=$('#tabCMPrescTypeLinkFee').datagrid("getRows");
	var CMPrescTypeLinkFeeStr="";
	for (i=0;i<rows.length;i++){
		var ARCIMRowid=rows[i].ARCIMRowid;
		if (!ARCIMRowid) continue;
		if (CMPrescTypeLinkFeeStr=="") CMPrescTypeLinkFeeStr=ARCIMRowid;
		else  CMPrescTypeLinkFeeStr=CMPrescTypeLinkFeeStr+"^"+ARCIMRowid;
	}
	var o=$HUI.combobox("#Combo_TakingMedicineMethod");
	var TakingMedicineMethod=o.getValues().join("!");
	//1-5
	var SaveStr=CNMedAppendItem+"#"+CNMedCookModeFeeItem+"#"+CNMedDefaultFrequence+"#"+CNMedDefaultInstruction+"#"+CNMedDefaultDuration
	//6-10
	var SaveStr=SaveStr+"#"+CNItemCat+"#"+DefaultQtyID+"#"+CNMedCookDep+"#"+EPCNMedCookDep+"#"+CNMedAppendItemQtyCalcu
	//11-15
	var SaveStr=SaveStr+"#"+IPCookModeFeeNoAutoAdd+"#"+ApperFormulaItem+"#"+PrintFormulaItem+"#"+CNMedNormDefaultRefLoc+"#"+NotAllowChangeCook
	var SaveStr=SaveStr+"#"+CNMedNormIPDefaultRefLoc+"#"+IPDefaultCMPrescType+"#"+OPDefaultCMPrescType+"#"+CMPrescTypeLinkFeeStr+"#"+CNMedDefaultCookMode;
	var SaveStr=SaveStr+"#"+TakingMedicineMethod
	var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
		MethodName:"SaveCMPrescDetails",
	   	PrescTypeCode:PrescTypeCode,
	   	DetailsInfo:SaveStr,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (value!="0"){
		$.messager.alert("提示","保存失败,"+value);
		return
	}
	$.messager.popover({msg: '保存成功!',type:'success'});
	LoadCMPrescTypeDetail(PrescTypeCode);
}
function LoadCMPrescTypeDetail(Code){
	CMPrescTypeLinkFeeEditRow=undefined;
	ClearLinkFeeGrid();
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var value=tkMakeServerCall("DHCDoc.DHCDocConfig.CMDocConfig","GetCMPrescDetails",Code,HospId);		 
		var ValArr=value.split("#");
		if (ValArr[0]!="0"){
			$.messager.alert("提示","保存失败"+value);
			return
		}
		var CNMedAppendItem=ValArr[1];
		var CNMedCookModeFeeItem=ValArr[2];
		var CNMedDefaultFrequence=ValArr[3];
		var CNMedDefaultInstruction=ValArr[4];
		var CNMedDefaultDuration=ValArr[5];
		var CNItemCat=ValArr[6];
		var DefaultQtyID=ValArr[7];
		var CNMedCookDep=ValArr[8];
		var EPCNMedCookDep=ValArr[9];
		
		var CNMedAppendItemQtyCalcu=ValArr[10];
		var IPCookModeFeeNoAutoAdd=ValArr[11];
		var ApperFormulaItem=ValArr[12];
		var PrintFormulaItem=ValArr[13];
		var CNMedNormDefaultRefLoc=ValArr[14];
		var NotAllowChangeCook=ValArr[15];
		var CNMedAppendItemDesc=ValArr[16];
		var CNMedCookModeFeeItemDesc=ValArr[17];
		var CNMedNormIPDefaultRefLoc=ValArr[18];
		var IPDefaultCMPrescType=ValArr[19];
		var OPDefaultCMPrescType=ValArr[20];
		var CMPrescTypeLinkFeeStr=ValArr[21];
		var CNMedDefaultCookMode=ValArr[22];
		var TakingMedicineMethod=ValArr[23];
		/*$("#SSDBCombo_Item").combobox('setValue', CNMedAppendItem);
		
		window.setTimeout(function (){
			$("#SSDBCombo_Item").combobox('setText', CNMedAppendItemDesc);
		},500)*/
		$("#SSDBCombo_CookModeFee").combobox('setValue', CNMedCookModeFeeItem);
		window.setTimeout(function (){
			$("#SSDBCombo_CookModeFee").combobox('setText', CNMedCookModeFeeItemDesc);
		},500)
		
		
		$("#Combo_DefaultFrequence").combobox('setValue', CNMedDefaultFrequence);
		$("#Combo_DefaultInstr").combobox('setValue', CNMedDefaultInstruction);
		$("#SSDBCombo_DefaultQty").combobox("reload");
		$("#SSDBCombo_DefaultQty").combobox("setValue",DefaultQtyID);
		$("#SSDBCombo_DefaultDuration").combobox('setValue', CNMedDefaultDuration);
		SetSelList("List_CMPrescTypeItemCat",CNItemCat);
		//SetSelList("List_CNMedCookDep",CNMedCookDep);
		//SetSelList("List_EPCNMedCookDep",EPCNMedCookDep);
		
		//SetCheckFlag("Check_CNMedAppendItemQtyCalcu",CNMedAppendItemQtyCalcu);
		//SetCheckFlag("Check_IPCookModeFeeNoAutoAdd",IPCookModeFeeNoAutoAdd);
		SetCheckFlag("Check_ApperFormulaItem",ApperFormulaItem);
		SetCheckFlag("Check_PrintFormulaItem",PrintFormulaItem);
		$("#List_CNMedNormDefaultRefLoc").combobox('setValue', CNMedNormDefaultRefLoc);
		SetCheckFlag("Check_NotAllowChangeCook",NotAllowChangeCook);
		$("#List_CNMedNormIPDefaultRefLoc").combobox('setValue', CNMedNormIPDefaultRefLoc);
		SetCheckFlag("Check_IPDefaultCMPrescType",IPDefaultCMPrescType);
		SetCheckFlag("Check_OPDefaultCMPrescType",OPDefaultCMPrescType);
		$("#SSDBCombo_DefaultCookMode").combobox('setValue', CNMedDefaultCookMode);
		if (CMPrescTypeLinkFeeStr!=""){
			for (var i=0;i<CMPrescTypeLinkFeeStr.split("^").length;i++){
				$('#tabCMPrescTypeLinkFee').datagrid('insertRow',{
					index: i,	// 索引从0开始
					row: {
						ARCIMRowid:CMPrescTypeLinkFeeStr.split("^")[i].split("$")[0],
						ARCIMDesc:CMPrescTypeLinkFeeStr.split("^")[i].split("$")[1]
					}
				});
			}
		}
		var sbox = $HUI.combobox("#Combo_TakingMedicineMethod");
		var TakingMedicineMethodvalue=sbox.getValues();
		for (i=0;i<TakingMedicineMethodvalue.length;i++){
			if (TakingMedicineMethodvalue[i]!="")  sbox.unselect(TakingMedicineMethodvalue[i]);
		}
		var TakingMedicineMethodArr=TakingMedicineMethod.split("!");
		for (i=0;i<TakingMedicineMethodArr.length;i++){
			if (TakingMedicineMethodArr[i]!="")  sbox.select(TakingMedicineMethodArr[i]);
		}
}

function InitPrescTypeDetail(){
	///初始化下拉列表
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       LoadDefaultItemData(param1,"null");	    
	}
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		LoadDefaultFreqData(param1,"null");	    
	}
	for( var i=0;i<arrayObj3.length;i++) {
		   var param1=arrayObj3[i][0];
		   var param2=arrayObj3[i][1];
	       LoadDefaultInstrData(param1,"null");	    
   	}
	for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       LoadDefaultDurData(param1,"null");	    
	}
	for( var i=0;i<arrayObj5.length;i++) {
		var param1=arrayObj5[i][0];
		var param2=arrayObj5[i][1];
		var param3=arrayObj5[i][2];
		if (param3=="1"){
			LoadListData(param1,param2);
		}else{
			LoadListData(param1,"");	    
		}
	}
	for( var i=0;i<arrayObj6.length;i++) {
		   var param1=arrayObj6[i][0];
		   var param2=arrayObj6[i][1];
	       LoadDefaultLocData(param1,"");	    
	}
	LoadDefaultQty();
	LoadCNMedDefaultRefLoc();
	LoadCNMedIPDefaultRefLoc();
	InitCMPrescTypeLinkFeeGrid();
	LoadDefaultCookModeData();
	InitTakingMedicineMethod();
}
function InitPublicTerritory(){
	//就诊类型 药物使用方式 List_Instr  LoadListData
	LoadInstrData("List_Instr","O");
	//用法
	InitCNMeditemInstr();
	//包装方式
	InitCNMedPackMode();
	//使用频率
	InitCHNPHFrequence();
	//煎药费账单子类
	InitCNMedCookMode();
	//医嘱单长期医嘱
	InitCNMedAddLongOrderGrid();
	//煎药方式
	InitCNMedCookArcMode();
	// 用法类型对照
	InitCNMedInstrContrast();
	///可用医嘱类型
	LoadCNMedPrior("List_CNMedPrior");
	//账单大类
	LoadFindARCBillGrpData("SSDBCombo_BillGroup","CHNPHBillSub");
	//账单子类
	LoadFindARCBillSubpData("SSDBCombo_CHNPHBillsub","CHNPHBillSub");
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"getDefaultData",
	   	value:"ViewGroupSum",
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		$("#Txt_ViewGroupSum").val(objScope.result);
	});
	//所有的checkbox radio元素初始化 
	for( var i=0;i<arrayObj7.length;i++) {
		   var param1=arrayObj7[i][0];
		   var param2=arrayObj7[i][1];
	       LoadCheckData(param1,param2);	    
	}
}
function LoadCheckData(param1,param2)
{
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"getDefaultData",
	   	value:param2,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if ((objScope.result==1)){
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function InitCNMeditemInstr(){
	///用法
	 var CNMeditemInstrToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	InstrDataGridEditRow = undefined;
                CNMeditemInstrDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMeditemInstrDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMeditemInstrDataGrid.datagrid("beginEdit", 0);
                InstrDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMeditemInstrDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							CNMeditemInstrDataGrid.datagrid("selectRow",SelectedRow)
							CNMeditemInstrDataGrid.datagrid('deleteRow',SelectedRow);
							SaveCNMeditemInstrData();
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                InstrDataGridEditRow = undefined;
                CNMeditemInstrDataGrid.datagrid("rejectChanges");
                CNMeditemInstrDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMeditemInstrData();
			}
		}];
	 ///用法列表columns
    var CNMeditemInstrColumns=[[    
                    { field: 'Code', title: '代码', width: 30,editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 30,editor : {type : 'text',options : {}}
					}
    			 ]];
	// 用法列表Grid
	CNMeditemInstrDataGrid=$('#tabCNMeditemInstr').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=Find&value=CNMedItemPhSpecInstr",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"Code",
		//pageList : [15,50,100,200],
		columns :CNMeditemInstrColumns,
		toolbar :CNMeditemInstrToolBar,
		onClickRow:function(rowIndex, rowData){
			CNMeditemInstrDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMeditemInstrDataGrid.datagrid('getRows'); 
		},
		onBeforeLoad:function(param){
			param.HospId=$HUI.combogrid('#_HospList').getValue();
		}
	});
	//LoadCNMeditemInstrDataGrid();
}
/*function LoadCNMeditemInstrDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='Find';
	queryParams.Arg1="CNMedItemPhSpecInstr"
	queryParams.ArgCnt =1;
	var opts = CNMeditemInstrDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CNMeditemInstrDataGrid.datagrid('load', queryParams);
}*/
function SaveCNMeditemInstrData()
{
	var str=""  //CNMedItemPhSpecInstr
	var rows = CNMeditemInstrDataGrid.datagrid("getRows");	
	for(var i=0; i<rows.length; i++){
        if(rows[i].Code!=undefined){
		     if(str==""){
		      	str=rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
	         }else{
		      	str=str+"^"+rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
	  		 }
	    }	  
	}
	var editors = CNMeditemInstrDataGrid.datagrid('getEditors', InstrDataGridEditRow);
    if(+editors!=0){
		var Code =  editors[0].target.val();
	    var Desc= editors[1].target.val();
		if((Code=="")||(Desc=="")){
			$.messager.alert("提示", "代码或描述不能为空", "error");
			return false;
		}
        if(str==""){
		 str=Code+String.fromCharCode(1)+Desc;
	    }else{
		 str=str+"^"+Code+String.fromCharCode(1)+Desc;
	    }
		InstrDataGridEditRow = undefined;
		CNMeditemInstrDataGrid.datagrid("rejectChanges");
        CNMeditemInstrDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig2",
	   	Node:"CNMedItemPhSpecInstr",
	   	NodeValue:str,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});	
        CNMeditemInstrDataGrid.datagrid('load');			
	}
}
function InitCNMedPackMode(){
	///包装方式
	 var CNMedPackModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	PackModeDataGridEditRow = undefined;
                CNMedPackModeDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMedPackModeDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMedPackModeDataGrid.datagrid("beginEdit", 0);
                PackModeDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMedPackModeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							CNMedPackModeDataGrid.datagrid("selectRow",SelectedRow)
							CNMedPackModeDataGrid.datagrid('deleteRow',SelectedRow);
							SaveCNMedPackModeData();
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PackModeDataGridEditRow = undefined;
                CNMedPackModeDataGrid.datagrid("rejectChanges");
                CNMedPackModeDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMedPackModeData();
			}
		}];
	 ///包装方式列表columns
    var CNMedPackModeColumns=[[    
                    { field: 'Code', title: '代码', width: 30,editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 30,editor : {type : 'text',options : {}}
					}
    			 ]];
	// 包装方式列表Grid
	CNMedPackModeDataGrid=$('#tabCNMedPackMode').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=Find&value=CNMedPackMode&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"Code",
		//pageList : [15,50,100,200],
		columns :CNMedPackModeColumns,
		toolbar :CNMedPackModeToolBar,
		onClickRow:function(rowIndex, rowData){
			CNMedPackModeDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedPackModeDataGrid.datagrid('getRows'); 
		}
	});
}

function SaveCNMedPackModeData(){
	var str=""  
	var rows = CNMedPackModeDataGrid.datagrid("getRows");	
	for(var i=0; i<rows.length; i++){
      if(rows[i].Code!=undefined){
		  if(str==""){
		  str=rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
	  }else{
		  str=str+"^"+rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
	  }
	 }	  
	}
	var editors = CNMedPackModeDataGrid.datagrid('getEditors', PackModeDataGridEditRow);
    if(+editors!=0){
		var Code =  editors[0].target.val();
	    var Desc= editors[1].target.val();
		if((Code=="")||(Desc=="")){
			$.messager.alert("提示", "代码或描述不能为空", "error");
			return false;
		}
        if(str==""){
		 str=Code+String.fromCharCode(1)+Desc;
	    }else{
		 str=str+"^"+Code+String.fromCharCode(1)+Desc;
	    }
		PackModeDataGridEditRow = undefined;
		CNMedPackModeDataGrid.datagrid("rejectChanges");
        CNMedPackModeDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig2",
	   	Node:"CNMedPackMode",
	   	NodeValue:str,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
        CNMedPackModeDataGrid.datagrid('load');			
	}
}
function InitCHNPHFrequence()
{
	///使用频率
	 var CHNPHFrequenceToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CHNPHFrequenceDataGridEditRow = undefined;
                CHNPHFrequenceDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CHNPHFrequenceDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CHNPHFrequenceDataGrid.datagrid("beginEdit", 0);
                CHNPHFrequenceDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CHNPHFrequenceDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].CPFRowid);
                            }
                            var id=ids.join(',');
                            if (id==""){
	                            CHNPHFrequenceDataGridEditRow = undefined;
				                CHNPHFrequenceDataGrid.datagrid("rejectChanges");
				                CHNPHFrequenceDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.DocConfig",
								MethodName:"deleteFrequence",
							   	Rowid:id
							},false);
						    if(value=="0"){
							  CHNPHFrequenceDataGrid.datagrid('load');
           					  CHNPHFrequenceDataGrid.datagrid('unselectAll');
           					  $.messager.popover({msg: '删除成功!',type:'success'});
						   	}else{
								$.messager.alert('提示',"删除失败:"+value);
						  	}
						  	CHNPHFrequenceDataGridEditRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CHNPHFrequenceDataGridEditRow = undefined;
                CHNPHFrequenceDataGrid.datagrid("rejectChanges");
                CHNPHFrequenceDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCHNPHFrequenceData();
			}
		}];
	 ///包装方式列表columns
    var CHNPHFrequenceColumns=[[ 
					{ field: 'CPFRowid', title: 'ID',hidden:true},	
                    { field: 'CPFFrequence', title: '频次', width: 30,
					   editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindFreqList&value=null&Type=CM&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'FreqRowId',
								textField:'FreqCode',
								required:true,
								loadFilter:function(data){
									return data['rows'];
								}
							  }
     					  }
					},
        			{ field: 'CPFFactor', title: '系数', width: 20,
					  editor : {
						  type : 'text',
						  options : {
						  }
					  }
					},
					{ field: 'CPFDefault', title: '默认', width: 20,
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					}
    			 ]];
	// 包装方式列表Grid
	CHNPHFrequenceDataGrid=$('#tabFrequence').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindCHNPHFrequence&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"CPFRowid",
		//pageList : [15,50,100,200],
		columns :CHNPHFrequenceColumns,
		toolbar :CHNPHFrequenceToolBar,
		onClickRow:function(rowIndex, rowData){
			//CHNPHFrequenceDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			//var selected=CHNPHFrequenceDataGrid.datagrid('getRows'); 
		}
		
	});
}
function SaveCHNPHFrequenceData()
{
	if (CHNPHFrequenceDataGridEditRow != undefined)
    {
		var editors = CHNPHFrequenceDataGrid.datagrid('getEditors', CHNPHFrequenceDataGridEditRow);   		
		var FreqDr =  editors[0].target.combobox('getValue');
		if (!FreqDr) {
			$.messager.alert('提示',"请选择频次!");
			return false;
		}
		var Factor =  editors[1].target.val();
		var Default=  editors[2].target.is(':checked')?"Y":"N";
		var value=$.m({
			ClassName:"DHCDoc.DHCDocConfig.DocConfig",
			MethodName:"saveFrequence",
		   	FreqDr:FreqDr,
		   	Factor:Factor,
		   	Default:Default,
		   	HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value=="0"){
			CHNPHFrequenceDataGrid.datagrid("endEdit", CHNPHFrequenceDataGridEditRow);
			CHNPHFrequenceDataGridEditRow = undefined;
			CHNPHFrequenceDataGrid.datagrid('load').datagrid('unselectAll');
			$.messager.popover({msg: '保存成功!',type:'success'});
		}else{
			if(value=="-1") value="项目重复,不能添加"
			$.messager.alert('提示',"保存失败:"+value);
			return false;
		}
		CHNPHFrequenceDataGridEditRow = undefined;
	}else{
		$.messager.alert("提示", "请选择一个要维护的频率", "error");
	}
}
function InitCNMedCookMode()
{
	///煎药费账单子类
	 var CNMedCookModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CNMedCookModeDataGridEditRow = undefined;
                SelCNMedCookMode=undefined;
                CNMedCookModeDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMedCookModeDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMedCookModeDataGrid.datagrid("beginEdit", 0);
                CNMedCookModeDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMedCookModeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							CNMedCookModeDataGrid.datagrid("selectRow",SelectedRow)
							CNMedCookModeDataGrid.datagrid('deleteRow',SelectedRow);
							SaveCNMedCookMode();
	
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CNMedCookModeDataGridEditRow = undefined;
                SelCNMedCookMode=undefined;
                CNMedCookModeDataGrid.datagrid("rejectChanges");
                CNMedCookModeDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMedCookMode();
			}
		}];
	 ///列表columns
    var CNMedCookModeColumns=[[ 
	                { field: 'ArcOrd', title: 'ID', width: 10,hidden:true},
					{ field: 'Code', title: '代码', width: 20,
					  editor : {type : 'text',options : {required:true}}

					},	
                    { field: 'Desc', title: '名称', width: 20,
					  editor : {type : 'text',options : {required:true}}
					},
        			{ field: 'ArcOrdID', title: '医嘱套名称', width: 45,
					   editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindArcOrd",
								valueField:'ARCOSRowId',
								textField:'ARCOSDesc',
								//required:true,
								loadFilter:function(data){
									return data['rows'];
								},
								onChange:function(newValue,oldValue){
									if (newValue==""){
										$(this).combobox('setValue','');
										var rows=CNMedCookModeDataGrid.datagrid("selectRow",CNMedCookModeDataGridEditRow).datagrid("getSelected");
	                                    rows.ArcOrdID="";
									}
								},
								onBeforeLoad:function(param){
									param.HospId=$HUI.combogrid('#_HospList').getValue();
								}
							  }
     					  },
     					  formatter:function(value, record){
							  return record.ArcOrd;
						  }
					},
					{ field: 'ActiveFlag', title: '可用', width: 20,
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					}
    			 ]];
	// 包装方式列表Grid
	CNMedCookModeDataGrid=$('#tabCNMedCookMode').datagrid({  
		fit : true,
		//width : 'auto',
		height:'150',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindCNMedCookMode&value=CNMedCookMode&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"CPFRowid",
		//pageList : [15,50,100,200],
		columns :CNMedCookModeColumns,
		toolbar :CNMedCookModeToolBar,
		onDblClickRow:function(rowIndex, rowData){
			if (CNMedCookModeDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			CNMedCookModeDataGrid.datagrid("beginEdit", rowIndex);
			CNMedCookModeDataGridEditRow=rowIndex
			SelCNMedCookMode=rowIndex
		},
		onClickRow:function(rowIndex, rowData){
			CNMedCookModeDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedCookModeDataGrid.datagrid('getRows'); 
		}
	});
}
function SaveCNMedCookMode()
{
	var str=""  
	var rows = CNMedCookModeDataGrid.datagrid("getRows");	
	for(var i=0; i<rows.length; i++){
      if((rows[i].Code!=undefined)&&(SelCNMedCookMode!=i)){
	      var ActiveFlag=rows[i].ActiveFlag
		   if(ActiveFlag=="Y") ActiveFlag=1
		   else  ActiveFlag=0
		  if(str==""){
		  str=rows[i].Code+String.fromCharCode(1)+rows[i].Desc+String.fromCharCode(1)+rows[i].ArcOrdID+String.fromCharCode(1)+ActiveFlag;
	  }else{
		  str=str+"^"+rows[i].Code+String.fromCharCode(1)+rows[i].Desc+String.fromCharCode(1)+rows[i].ArcOrdID+String.fromCharCode(1)+ActiveFlag;
	  }
	 }	  
	}
	var editors = CNMedCookModeDataGrid.datagrid('getEditors', CNMedCookModeDataGridEditRow);
    if(+editors!=0){
		var Code =  editors[0].target.val();
	    var Desc= editors[1].target.val();
		var ARCOrdID =  editors[2].target.combobox('getValue');
		if (!ARCOrdID) ARCOrdID="";
		var ActiveFlag=editors[3].target.is(':checked');
		if(ActiveFlag){
			ActiveFlag=1
		}
		else {
			ActiveFlag=0
		}
		if((Code=="")||(Desc=="")){
			$.messager.alert("提示", "代码或描述不能为空", "error");
			return false;
		}
        if(str==""){
		   str=Code+String.fromCharCode(1)+Desc+String.fromCharCode(1)+ARCOrdID+String.fromCharCode(1)+ActiveFlag;
	    }else{
		   str=str+"^"+Code+String.fromCharCode(1)+Desc+String.fromCharCode(1)+ARCOrdID+String.fromCharCode(1)+ActiveFlag;
	    }
		CNMedCookModeDataGridEditRow = undefined;
		SelCNMedCookMode=undefined;
		CNMedCookModeDataGrid.datagrid("rejectChanges");
        CNMedCookModeDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig2",
	   	Node:"CNMedCookMode",
	   	NodeValue:str,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
        CNMedCookModeDataGrid.datagrid('load');			
	}
}
function InitCNMedAddLongOrderGrid()
{
	///需要插入的医嘱单长期医嘱
	 var CNMedAddLongOrderToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CNMedAddLongOrderEditRow = undefined;
                CNMedAddLongOrderGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMedAddLongOrderGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMedAddLongOrderGrid.datagrid("beginEdit", 0);
                CNMedAddLongOrderEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMedAddLongOrderGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							if ((!rows[0].IDOut)||(rows[0].IDOut=="")){
		                        CNMedAddLongOrderEditRow = undefined;
						   		CNMedAddLongOrderGrid.datagrid('deleteRow',SelectedRow);
		                    }else{
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].IDOut);
                            }
                            var id=ids.join(',')
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.DocConfig",
								MethodName:"deleteCNMedAddLongOrder",
							   	Rowid:id,
							   	HospId:$HUI.combogrid('#_HospList').getValue()
							},false);
						    if(value=="0"){
							  CNMedAddLongOrderGrid.datagrid('load').datagrid('unselectAll');
           					  $.messager.popover({msg: '删除成功!',type:'success'});
						   }else{
							$.messager.alert('提示',"删除失败:"+value);
						  }
						   CNMedAddLongOrderEditRow = undefined;
						   CNMedAddLongOrderGrid.datagrid('deleteRow',SelectedRow);
		                   }							//SaveCHNPHFrequenceData();*/
							
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CNMedAddLongOrderEditRow = undefined;
                CNMedAddLongOrderGrid.datagrid("rejectChanges");
                CNMedAddLongOrderGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMedAddLongOrderData();
			}
		}];
	 ///包装方式列表columns
    var CNMedAddLongOrderColumns=[[ 
					{ field: 'IDOut', title: 'ID', width: 5},	
                    { field: 'DescOut', title: '名称', width: 20,
                    	/*editor :{  
							type:'combobox',  
							options:{
								url:$URL,
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								mode:'remote',
								delay:100,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.DocConfig";
									param.QueryName = "FindDefaultItem";
									//param.ArgCnt =3;
									param.value ="";
									param.Desc = $(this).combobox('getText');
									param.MaxFindNum = "20";
									param.HospId=$HUI.combogrid('#_HospList').getValue();
								},
								loadFilter:function(data){
									return data['rows'];
								}
							  }
     					  }*/
     					 editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=CNMedAddLongOrderGrid.datagrid("selectRow",CNMedAddLongOrderEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=CNMedAddLongOrderGrid.datagrid("selectRow",CNMedAddLongOrderEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								}
                    		}
	        			  }
					}
    			 ]];
	// 包装方式列表Grid
	CNMedAddLongOrderGrid=$('#tabCNMedAddLongOrder').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindCNMedLongOrder",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"IDOut",
		//pageList : [15,50,100,200],
		columns :CNMedAddLongOrderColumns,
		toolbar :CNMedAddLongOrderToolBar,
		onClickRow:function(rowIndex, rowData){
			CNMedAddLongOrderGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedAddLongOrderGrid.datagrid('getRows'); 
		},
		onBeforeLoad:function(param){
			CNMedAddLongOrderEditRow = undefined;
			param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
		}
		
	});
}
function SaveCNMedAddLongOrderData()
{
	if (CNMedAddLongOrderEditRow != undefined)
    {
	    var ArcimSelRow=CNMedAddLongOrderGrid.datagrid("selectRow",CNMedAddLongOrderEditRow).datagrid("getSelected"); 
		var ArcimID=ArcimSelRow.ARCIMRowid
		if (!ArcimID){
			$.messager.alert("提示","请选择医嘱!");
            return false;
	    }      	
		//var editors = CNMedAddLongOrderGrid.datagrid('getEditors', CNMedAddLongOrderEditRow);   		
		//var ArcimID =  editors[0].target.combobox('getValue');
		var value=$.m({
			ClassName:"DHCDoc.DHCDocConfig.DocConfig",
			MethodName:"saveCNMedAddLongOrder",
		   	ArcimID:ArcimID,
		   	HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value=="0"){
			CNMedAddLongOrderGrid.datagrid("endEdit", CNMedAddLongOrderEditRow);
			CNMedAddLongOrderEditRow = undefined;
			CNMedAddLongOrderGrid.datagrid('unselectAll').datagrid('load');
			$.messager.popover({msg: '保存成功!',type:'success'});      					
		}else{
			$.messager.alert('提示',"保存失败!请选择有效的医嘱项目!");
			return false;
		}
		CNMedAddLongOrderEditRow = undefined;
	}else{
		$.messager.alert("提示", "请选择医嘱项目", "error");
	}
}
function LoadDefaultInstrData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'InstrRowID',   
    	textField:'InstrDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindInstrList';
			param.Arg1 =param2;
			param.Arg2 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =2;
		},
		onSelect:function(record){
			$("#SSDBCombo_DefaultQty").combobox("reload");
		}
	});
} 
function LoadDefaultCookModeData()
{
	$("#SSDBCombo_DefaultCookMode").combobox({      
    	valueField:'RowID',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindCookMode';
			param.Arg1 ="";
			param.Arg2 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =2;
		},
		onSelect:function(record){
			
		}
	});
} 
function LoadDefaultItemData(param1,param2)
{
	$("#"+param1+"").combobox({    
		mode:'remote',  
		delay:500,
    	valueField:'ArcimRowID',   
    	textField:'ArcimDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
	    	var conditions=$("#"+param1+"").combobox("getText");
	    	if (conditions=="") param2="NULL"
	    	else param2=conditions
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindDefaultItem';
			param.Arg1 =param2;
			param.Arg2 =param2;
			param.Arg3="";
			param.Arg4=$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =4;
		}/*,onChange:function(newValue,oldValue){
			if (newValue!=""){
				$("#"+param1+"").combobox('setValue',""); 
			}
		},
		onSelect:function(record){
			window.setTimeout(function (){
				$("#"+param1+"").combobox("setValue",record.ArcimRowID);
				window.setTimeout(function (){
					$("#"+param1+"").combobox("setText",record.ArcimDesc);
				},100)
				
			},300)
		}*/
	});
} 

function LoadDefaultFreqData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'FreqRowId',   
    	textField:'FreqCode',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'FindFreqList';
			param.Arg1 =param2;
			param.Arg2 ="CM";
			param.Arg3 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =3;
		}  
	});
}
function LoadDefaultDurData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'DurRowId',   
    	textField:'DurCode',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'FindDurList';
			param.Arg1 =param2;
			param.ArgCnt =1;
		}  
	});
}

function LoadDefaultQty(){
	$("#SSDBCombo_DefaultQty").combobox({      
    	valueField:'Code',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CMDocConfig';
			param.QueryName = 'FindInstrLinkOrderQty';
			param.Arg1 =function(){
				return $("#Combo_DefaultInstr").combobox("getValue");
			};
			param.ArgCnt =1;
		},
		onLoadSuccess:function(data){
			var Find=0;
			var OldValue=$("#SSDBCombo_DefaultQty").combobox('getValue');
			for (var i=0;i<data.length;i++){
				if (data[i]['Code']==OldValue){
					$(this).combobox('select',data[i]["Code"]);
					Find=1;
					break;
				}
			}
			if (Find==0){
				$(this).combobox('setValue','').combobox('select','');
			}
		}
	});
}
function InittabCMPrescType(){
	var CMPrescTypeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                //var EditRows=getEditRowIndex(CMPrescTypeDataGrid);
                if (!isNaN(CMPrescTypeEditRow)){
	            	$.messager.alert("提示","请先保存")
	            	return false
	            }
                
                CMPrescTypeEditRow=0;
                CMPrescTypeDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CMPrescTypeDataGrid.datagrid("beginEdit", 0);
            }
        },/*
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            disabled: true,
            handler: function() {
                var rows = CMPrescTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "此项操作将严重影响业务并不可恢复，请您再三核实确定要删除吗?",
                    function(r) {
                        if (r) {
							var Code=rows[rows.length-1].Code;
							$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CMDocConfig","DelCMPrescType","false",function testget(value){		 
       						 },"","",Code);	
							
							CMPrescTypeDataGrid.datagrid("reload");
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },*/{
            text: '启/禁用',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = CMPrescTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
					var Code=rows[rows.length-1].Code;
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
						MethodName:"ActiveCMPrescType",
					   	Code:Code,
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					CMPrescTypeDataGrid.datagrid("reload");
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (isNaN(CMPrescTypeEditRow)){
	            	$.messager.alert("提示","请先添加");
	            	return false;
	            }
				var row=CMPrescTypeDataGrid.datagrid("getEditors",CMPrescTypeEditRow);
				var Code=row[0].target.val();
				var Desc=row[1].target.val();
				if (Code=="" || Desc==""){
					$.messager.alert("提示","无效数据");
	            	return false;
				}
				var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
					MethodName:"SaveCMPrescType",
				   	Code:Code,
				   	Desc:Desc,
				   	HospId:$HUI.combogrid('#_HospList').getValue()
				},false);
   				if (value=="-1"){
       				$.messager.alert("提示","保存失败：该代码已存在，请重新输入"+value);
   				}else if (value=="-2"){
       				$.messager.alert("提示","保存失败：该代码已被系统占用，请重新输入。"+value);
       			}else{
	       			CMPrescTypeEditRow=undefined;
	       			CMPrescTypeDataGrid.datagrid("reload");
	       		}
			}
		},{
			text: '',
			iconCls: 'icon-up',
			handler: function() {
				var rows = CMPrescTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
	                var Index=CMPrescTypeDataGrid.datagrid("getRowIndex",rows[rows.length-1].Code)
					var Code=rows[rows.length-1].Code;
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
						MethodName:"ChangeNumberCMPrescType",
					   	TypeCode:Code, UPDown:"Up",
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					CMPrescTypeDataGrid.datagrid("reload");
					Index=parseFloat(Index)-1
					if (Index<0) Index=0
					setTimeout(function(){
				        CMPrescTypeDataGrid.datagrid("selectRow",Index)
				    },500)
                } else {
                    $.messager.alert("提示", "请选择要移动的行", "error");
                }
				} 
		},{
			text: '',
			iconCls: 'icon-down',
			handler: function() {
				var rows = CMPrescTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
	                var Index=CMPrescTypeDataGrid.datagrid("getRowIndex",rows[rows.length-1].Code)
					var Code=rows[rows.length-1].Code;
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
						MethodName:"ChangeNumberCMPrescType",
					   	TypeCode:Code, UPDown:"Down",
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					CMPrescTypeDataGrid.datagrid("reload");
					Index=parseFloat(Index)+1
					var rowlength=CMPrescTypeDataGrid.datagrid("getRows").length
					if (Index>=rowlength) Index=parseFloat(rowlength)-1
					setTimeout(function(){
				        CMPrescTypeDataGrid.datagrid("selectRow",Index)
				    },500)
                } else {
                    $.messager.alert("提示", "请选择要移动的行", "error");
                }
				} 		 
		}];
    CMPrescTypeColumns=[[    
                    { field: 'Code', title: '代码', width: 95,editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 80,editor : {type : 'text',options : {}}},
        			{ field: 'Active', title: '有效标志', width: 65}
    			 ]];
	CMPrescTypeDataGrid=$('#tabCMPrescType').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CMDocConfig&QueryName=FindCMPrescType&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"Code",
		columns :CMPrescTypeColumns,
		toolbar :CMPrescTypeToolBar,
		onSelect : function(rowIndex, rowData) {
			var Code=rowData.Code;
			LoadCMPrescTypeDetail(Code);
		},
		onBeforeLoad:function(param){
			CMPrescTypeEditRow=undefined;
			$('#tabCMPrescType').datagrid("unselectAll");
		}
	});
}
function AdmTypeChange(){
	$("#List_Instr").empty();
	var AdmType=$("#List_AdmType").combobox('getValue') ;
	LoadInstrData("List_Instr",AdmType);
}
function LoadInstrData(param1,param2){
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		QueryName:"FindInstrList",
	   	value:"AdmTypeInstr,"+param2,
	   	HospId:$HUI.combogrid('#_HospList').getValue(),
	   	rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.InstrRowID + ">" + n.InstrDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}
function LoadListData(param1,param2){
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral",
		QueryName:"FindCatList",
	   	value:param2,
	   	HospId:$HUI.combogrid('#_HospList').getValue(),
	   	rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
} 
function LoadDefaultLocData(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		QueryName:"FindDep",
	   	value:param2,
	   	HospId:$HUI.combogrid('#_HospList').getValue(),
	   	rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
							
}

function LoadCNMedDefaultRefLoc()
{
	$("#List_CNMedNormDefaultRefLoc").combobox({ 
		mode:'remote',     
    	valueField:'CTLOCRowID',   
    	textField:'CTLOCDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
	    	var desc="";
	    	if (param['q']) {
		    	desc=param['q'];
		    }
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindDep';
			param.Arg1 ="";
			param.Arg2 =desc;
			param.Arg3 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =3;
		}
	});
}
function SetSelList(Param,SelStr){
	for (var j=0;j<$("#"+Param+"").get(0).length;j++){
		var optionValue=$("#"+Param+"").get(0)[j].value;
		if(("^"+SelStr+"^").indexOf("^"+optionValue+"^")>=0){
			$("#"+Param+"").get(0).options[j].selected = true;
		}else{
			$("#"+Param+"").get(0).options[j].selected = false;
		}
	}
	return;
}

function SetCheckFlag(Param,CheckFlag){
	if (CheckFlag=="1"){
		$("#"+Param+"").checkbox('check');
	}else{
		$("#"+Param+"").checkbox('uncheck');
	}
	return
}
function LoadCNMedPrior(param1)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		QueryName:"FindCNMedPrior",
	   	value:"CNMedPrior",
	   	HospId:$HUI.combogrid('#_HospList').getValue(),
	   	rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.OECPRRowId + ">" + n.OECPRDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function LoadFindARCBillGrpData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'ARCBGRowId',   
    	textField:'ARCBGDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindARCBillGrp';
			param.Arg1 =param2;
			param.Arg2 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =2;
		}  
	});
} 

function LoadFindARCBillSubpData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'ARCSGRowId',   
    	textField:'ARCSGDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindARCBillSub';
			param.Arg1=param2;
			param.Arg2 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =2;
		}  
	});
} 
///处方剂型关联费用列表
function InitCMPrescTypeLinkFeeGrid()
{
	 var ToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	var rows = CMPrescTypeDataGrid.datagrid("getSelections");
				if (rows.length ==0) {
					$.messager.alert("提示","请先选择处方类型!");
					return false;
				}
                if (CMPrescTypeLinkFeeEditRow != undefined) {
                    return;
                }else{
                    tabCMPrescTypeLinkFeeGrid.datagrid("appendRow", {
                        row: {}
                    });
                    var appendRowIndex=tabCMPrescTypeLinkFeeGrid.datagrid('getRows').length-1;
                    tabCMPrescTypeLinkFeeGrid.datagrid("beginEdit", appendRowIndex);
                    CMPrescTypeLinkFeeEditRow = appendRowIndex;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = tabCMPrescTypeLinkFeeGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
						   CMPrescTypeLinkFeeEditRow = undefined;
						   tabCMPrescTypeLinkFeeGrid.datagrid('deleteRow',SelectedRow1);
						   SaveDetailsClickHandle();
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行");
                }
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if (CMPrescTypeLinkFeeEditRow != undefined){
		            var CMPrescTypeRow=tabCMPrescTypeLinkFeeGrid.datagrid("selectRow",CMPrescTypeLinkFeeEditRow).datagrid("getSelected"); 
		           	var ARCIMRowid=CMPrescTypeRow.ARCIMRowid;
		           	if ((!ARCIMRowid)||(ARCIMRowid=="")){
			           	$.messager.alert("提示", "请维护一条数据进行保存");
			           	return false
			           	}
			       SaveDetailsClickHandle();
	            }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
	            if (CMPrescTypeLinkFeeEditRow == undefined) { 
	            	return;
	            }
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CMPrescTypeLinkFeeEditRow = undefined;
                tabCMPrescTypeLinkFeeGrid.datagrid("rejectChanges");
                tabCMPrescTypeLinkFeeGrid.datagrid("unselectAll");
                var rows = CMPrescTypeDataGrid.datagrid("getSelections");
				var PrescTypeCode=rows[rows.length-1].Code;
				LoadCMPrescTypeDetail(PrescTypeCode);
            }
        }];
	 ///列表columns
    var Columns=[[ 
					{ field: 'ARCIMRowid', title: 'ID', width: 5},	
                    { field: 'ARCIMDesc', title: '名称', width: 20,
                    	editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&HospId="+$HUI.combogrid('#_HospList').getValue(), //PUBLIC_CONSTANT.URL.QUERY_GRID_URL
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=tabCMPrescTypeLinkFeeGrid.datagrid("selectRow",CMPrescTypeLinkFeeEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=tabCMPrescTypeLinkFeeGrid.datagrid("selectRow",CMPrescTypeLinkFeeEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									/*var CurrentOrdName=$(this).combogrid('getValue');
									if(CurrentOrdName!=""){
										if (CurrentOrdName.indexOf("||")>=0){
											$(this).combogrid("setValue","");
											$(this).combo("setText", "")
										}
									}*/
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc});
								}
                    		}
	        			  }
					}
    			 ]];
	// 处方剂型关联费用列表
	tabCMPrescTypeLinkFeeGrid=$('#tabCMPrescTypeLinkFee').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"ARCIMRowid",
		columns :Columns,
		toolbar :ToolBar,
		onClickRow:function(rowIndex, rowData){
			tabCMPrescTypeLinkFeeGrid.datagrid('selectRow',rowIndex);
			SelectedRow1=rowIndex
			var selected=tabCMPrescTypeLinkFeeGrid.datagrid('getRows'); 
		}
	});
}
function ClearLinkFeeGrid(){
	var rows=$('#tabCMPrescTypeLinkFee').datagrid("getRows");
	if (!rows) return;
	for (i=rows.length-1;i>=0;i--){
		$('#tabCMPrescTypeLinkFee').datagrid("deleteRow",i);
	}
}
function InitCNMedCookArcMode(){
	///煎药方式
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CookArcModeDataGridEditRow = undefined;
                CNMedCookArcModeDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMedCookArcModeDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMedCookArcModeDataGrid.datagrid("beginEdit", 0);
                CookArcModeDataGridEditRow = 0;              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMedCookArcModeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = CNMedCookArcModeDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocConfig",
									MethodName:"DelectCookMode",
								   	RowID:Rowid,
								   	HospId:$HUI.combogrid('#_HospList').getValue()
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadCNMedCookDataGrid()		
								}
	                        }else{
								CookArcModeDataGridEditRow = undefined;
				                CNMedCookArcModeDataGrid.datagrid("rejectChanges");
				                CNMedCookArcModeDataGrid.datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CookArcModeDataGridEditRow = undefined;
                CNMedCookArcModeDataGrid.datagrid("rejectChanges");
                CNMedCookArcModeDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMedCookArcModeData();
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedCookArcModeColumns=[[   
    				{ field: 'RowID',hidden:true },
                    { field: 'Code', title: '代码', width: 40,editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 40,editor : {type : 'text',options : {}}
					},
					{field:'ArcItem',title:'附加医嘱',width:70,sortable:true,
						formatter:function(value,rec){  
							var btn=""
							if (rec.Rowid!=""){
		                   		var btn = '<a href="#"  class="editcls"  onclick="ArcItemShow(\'' + rec.RowID + '\')">'+'附加医嘱'+'</a>';
							}
							return btn;
               		 	}
					},
					{field:'RecLocID',title:'接收科室',width:70,sortable:true,
						formatter:function(value,rec){  
							var btn=""
							if (rec.Rowid!=""){
			                   var btn = '<a href="#"  class="editcls"  onclick="RecLocShow(\'' + rec.RowID + '\')">'+'接收科室'+'</a>';
							}
							return btn;
               			}
					},
					{field:'LimitInstr',title:'使用方式',width:70,sortable:true,
						formatter:function(value,rec){  
							var btn=""
							if (rec.Rowid!=""){
			                   var btn = '<a href="#"  class="editcls"  onclick="LimitInstrShow(\'' + rec.RowID + '\')">'+'使用方式'+'</a>';
							}
							return btn;
               			}
					}
     ]];
	// 煎药方式列表Grid
	CNMedCookArcModeDataGrid=$('#tabCNMedCookArcMode').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindCNMedCookMode&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			CNMedCookArcModeDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedCookArcModeDataGrid.datagrid('getRows'); 
		}
	});
	setTimeout(function(){
        LoadCNMedCookDataGrid()
    },500)
}
function LoadCNMedCookDataGrid()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindCookMode",
	    value:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:CNMedCookArcModeDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CNMedCookArcModeDataGrid.datagrid('loadData',GridData);
	})
}
function RecLocShow(RowID){
	if ($.isNumeric(RowID)===false){
		$.messager.alert("提示", "请先保存行数据", "error");
		return;
	}
	$("#CookRecLoc-dialog").dialog("open");
	CookArcRowid=RowID
	InitCookRecLoc()
}
var CookRecLocDataGrid,CookRecLocDataGridEditRow,CookArcRowid;
function InitCookRecLoc(){
	///煎药方式
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CookRecLocDataGridEditRow = undefined;
                CookRecLocDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CookRecLocDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CookRecLocDataGrid.datagrid("beginEdit", 0);
                CookRecLocDataGridEditRow = 0;
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CookRecLocDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = CookRecLocDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocConfig",
									MethodName:"DelectCookModeLoc",
								   	Rowid:CookArcRowid,subRowid:Rowid,
								   	HospId:$HUI.combogrid('#_HospList').getValue(),
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadCookRecLocDataGrid();	
								}
	                        }else{
		                        CookRecLocDataGridEditRow = undefined;
				                CookRecLocDataGrid.datagrid("rejectChanges");
				                CookRecLocDataGrid.datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CookRecLocDataGridEditRow = undefined;
                CookRecLocDataGrid.datagrid("rejectChanges");
                CookRecLocDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (CookRecLocDataGridEditRow != undefined){
		            var ArcimSelRow=CookRecLocDataGrid.datagrid("selectRow",CookRecLocDataGridEditRow).datagrid("getSelected"); 
		           	var LocDr=ArcimSelRow.LocDr
		           	if ((LocDr==undefined)||(LocDr=="")){
							$.messager.alert("提示", "请选择科室", "error");
	                        return false;
			        } 
			        var editors = CookRecLocDataGrid.datagrid('getEditors', CookRecLocDataGridEditRow);
			        var Type=editors[0].target.combobox('getText')
			        var subrowid=ArcimSelRow.RowID
			        var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.DocConfig",
						MethodName:"SaveCookModeLoc",
					   	Rowid:CookArcRowid, Type:Type, LocDR:LocDr,subrowid:subrowid,
					   	HospId:$HUI.combogrid('#_HospList').getValue(),
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        LoadCookRecLocDataGrid()		
					}else{
						if(value=="Repeat"){
							$.messager.alert("提示","数据重复","warning");	
						}else{
							$.messager.alert("提示",value,"warning");	
						}	
					}
			            
		        }
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedCookArcModeColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
					{ field: 'CookType', title: '类型', width: 20,
					   editor :{  
							type:'combobox',  
							options:{
								//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"O","Desc":"门诊"},{"ID":"I","Desc":"住院"},{"ID":"E","Desc":"急诊"},{"ID":"H","Desc":"体检"},{"ID":"N","Desc":"新生儿"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"O","Desc":"门诊"},{"ID":"I","Desc":"住院"},{"ID":"E","Desc":"急诊"},{"ID":"H","Desc":"体检"},{"ID":"N","Desc":"新生儿"}]  
									return data;
								}
							  }
     					  }
					},
        			{ field: 'LocDesc', title: '接收科室', width: 100,
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindLoc&Type=&rows=99999&HospId=",
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onSelect:function(record){
									var ArcimSelRow=CookRecLocDataGrid.datagrid("selectRow",CookRecLocDataGridEditRow).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (CookRecLocDataGridEditRow!=undefined){
										var ArcimSelRow=CookRecLocDataGrid.datagrid("selectRow",CookRecLocDataGridEditRow).datagrid("getSelected"); 
										if (newValue=="") ArcimSelRow.LocDr="";
								    }
								},
								loadFilter:function(data){
									return data['rows'];
								},
							    filter: function(q, row){
									var opts = $(this).combobox('options');
									return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
								}
							  }
     					  }
										   
					}
    			 ]];
	// 煎药方式列表Grid
	CookRecLocDataGrid=$('#CookRecLoc').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			CookRecLocDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CookRecLocDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (CookRecLocDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			CookRecLocDataGrid.datagrid("beginEdit", rowIndex);
			CookRecLocDataGridEditRow=rowIndex
		}
	});
	LoadCookRecLocDataGrid()
}
function LoadCookRecLocDataGrid(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindCookModeLoc",
	    CookArcRowid:CookArcRowid,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:CookRecLocDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CookRecLocDataGrid.datagrid('loadData',GridData);
		CookRecLocDataGridEditRow=undefined
		CookRecLocDataGrid.datagrid("clearSelections")
	})
}
function ArcItemShow(RowID){
	if ($.isNumeric(RowID)===false){
		$.messager.alert("提示", "请先保存行数据", "error");
		return;
	}
	$("#CookArcItem-dialog").dialog("open");
	CookArcRowid=RowID
	InitCookArcItemRecLoc()
}
var CookArcItemDataGrid,CookArcItemDataGridEditRow;
function InitCookArcItemRecLoc(){
	///煎药方式
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	CookArcItemDataGridEditRow = undefined;
                CookArcItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                CookArcItemDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CookArcItemDataGrid.datagrid("beginEdit", 0);
                CookArcItemDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CookArcItemDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = CookArcItemDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocConfig",
									MethodName:"DelectCookModeArcim",
								   	Rowid:CookArcRowid,subRowid:Rowid,
								   	HospId:$HUI.combogrid('#_HospList').getValue()
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadCookArcItemDataGrid()	
								}
	                        }else{
								CookArcItemDataGridEditRow = undefined;
                				CookArcItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                CookArcItemDataGridEditRow = undefined;
                CookArcItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (CookArcItemDataGridEditRow != undefined){
		            var ArcimSelRow=CookArcItemDataGrid.datagrid("selectRow",CookArcItemDataGridEditRow).datagrid("getSelected"); 
		           	var ArcimRowID=ArcimSelRow.ARCIMRowid
		           	if (!ArcimRowID){
						$.messager.alert("提示","请选择医嘱!");
                        return false;
			        } 
			        var editors = CookArcItemDataGrid.datagrid('getEditors', CookArcItemDataGridEditRow);
			        var Number=editors[1].target.val()
					if (Number==""){
				        $.messager.alert("提示","请填写数量!");
                        return false;
				        }
			        var subrowid=ArcimSelRow.RowID
			        var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.DocConfig",
						MethodName:"SaveCookModeArcim",
					   	Rowid:CookArcRowid, Arcim:ArcimRowID, number:Number,subrowid:subrowid,
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        LoadCookArcItemDataGrid()		
					}else{
						if(value=="Repeat"){
							$.messager.alert("提示","数据重复","warning");	
						}else{
							$.messager.alert("提示",value,"warning");	
						}	
					}
		        }
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedCookArcModeColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
					{ field: 'ARCIMDesc', title: '医嘱名称', width: 20,
                    	editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=CookArcItemDataGrid.datagrid("selectRow",CookArcItemDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=CookArcItemDataGrid.datagrid("selectRow",CookArcItemDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								}
                    		}
	        			  }
					},
        			{ field: 'Number', title: '数量', width: 20,editor:{type:'numberbox',options:{min:0,precision:2}}
					}
    			 ]];
	// 煎药方式列表Grid
	CookArcItemDataGrid=$('#CookArcItem').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			CookArcItemDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CookArcItemDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (CookArcItemDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			CookArcItemDataGrid.datagrid("beginEdit", rowIndex);
			CookArcItemDataGridEditRow=rowIndex;
		}
	});
	LoadCookArcItemDataGrid()
	
}
function LoadCookArcItemDataGrid(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindCookModeArcim",
	    CookArcRowid:CookArcRowid,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:CookArcItemDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CookArcItemDataGrid.datagrid('loadData',GridData);
		CookArcItemDataGridEditRow=undefined
		CookArcItemDataGrid.datagrid("clearSelections")
	})
}
function LimitInstrShow(RowID){
	if ($.isNumeric(RowID)===false){
		$.messager.alert("提示", "请先保存行数据", "error");
		return;
	}
	$('#CookInstr-dialog').dialog("open");
	$('#CookInstrList').empty();
	var selInstrStr=$.cm({
		ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    MethodName : "GetCookModeInstr",
		Rowid:RowID, 
		HospId:$HUI.combogrid('#_HospList').getValue(),
		dataType:'text'
	},false);
	var selInstrArr=selInstrStr.split('^');
	var rows=$('#Combo_DefaultInstr').combobox('getData');
	for(var i=0;i<rows.length;i++){
		var row=rows[i];
		var selected=selInstrArr.indexOf(row.InstrRowID)>-1;
		$("<option></option>").val(row.InstrRowID).text(row.InstrDesc).attr('selected',selected).appendTo('#CookInstrList');
	}
	$('#BCookInstrSave').unbind('click').bind('click',function(){
		var InstrArr=new Array();
		$("#CookInstrList").find('option:selected,li[selected]').each(function(){
			InstrArr.push($(this).val());
		});
		var ret=$.cm({
			ClassName : "DHCDoc.DHCDocConfig.DocConfig",
			MethodName : "SaveCookModeInstr",
			Rowid:RowID, 
			InstrStr:InstrArr.join('^'),
			HospId:$HUI.combogrid('#_HospList').getValue(),
			dataType:'text'
		},false);
		$.messager.popover({msg: '保存成功!',type:'success'});
	});
}
function SaveCNMedCookArcModeData(){
	var str=""  
	var rows = CNMedCookArcModeDataGrid.datagrid("getRows");	
	for(var i=0; i<rows.length; i++){
	    if(rows[i].Code!=undefined){
			  if(str==""){
			  str=rows[i].RowID+String.fromCharCode(1)+rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
		  }else{
			  str=str+"^"+rows[i].RowID+String.fromCharCode(1)+rows[i].Code+String.fromCharCode(1)+rows[i].Desc;
		  }
	 	}	  
	}
	var editors = CNMedCookArcModeDataGrid.datagrid('getEditors', CookArcModeDataGridEditRow);
    if(+editors!=0){
		var Code =  editors[0].target.val();
	    var Desc= editors[1].target.val();
		if((Code=="")||(Desc=="")){
			$.messager.alert("提示", "代码或描述不能为空", "error");
			return false;
		}
        if(str==""){
		 	str=""+String.fromCharCode(1)+Code+String.fromCharCode(1)+Desc;
	    }else{
		 	str=str+"^"+String.fromCharCode(1)+Code+String.fromCharCode(1)+Desc;
	    }
		CookArcModeDataGridEditRow = undefined;
		CNMedCookArcModeDataGrid.datagrid("rejectChanges");
        CNMedCookArcModeDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"SaveCookMode",
	   	Str:str,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
       	LoadCNMedCookDataGrid()			
	}
}
var ConfigTakingMedDataGrid,ConfigTakingMedEditRow;
function SaveTakingMedicineMethodHandle(){
	$("#ConfigTakingMedicineMethod-dialog").dialog("open");
	InitConfigTakingMedDataGrid()
}

function InitConfigTakingMedDataGrid(){
	///煎药方式
	 var ConfigTakingMedicineMethodToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	ConfigTakingMedEditRow = undefined;
                ConfigTakingMedDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                ConfigTakingMedDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {RowID:""}
                });
                ConfigTakingMedDataGrid.datagrid("beginEdit", 0);
                ConfigTakingMedEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = ConfigTakingMedDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?如果删除会影响已经维护的数据",
                    function(r) {
                        if (r) {
	                        var rows = ConfigTakingMedDataGrid.datagrid("getSelections");
	                        RowID=rows[0].RowID
	                        if (RowID){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocConfig",
									MethodName:"DelectTakingMedicineMethod",
								   	RowID:RowID
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadConfigTakingMedDataGrid();
									InitTakingMedicineMethod();
								}
	                        }else{
								ConfigTakingMedEditRow = undefined;
                				ConfigTakingMedDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                ConfigTakingMedEditRow = undefined;
                ConfigTakingMedDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (ConfigTakingMedEditRow != undefined){
		            var ArcimSelRow=ConfigTakingMedDataGrid.datagrid("selectRow",ConfigTakingMedEditRow).datagrid("getSelected"); 
		           	var RowID=ArcimSelRow.RowID
			        var editors = ConfigTakingMedDataGrid.datagrid('getEditors', ConfigTakingMedEditRow);
			        var Code=editors[0].target.val()
			        if (Code==""){
						$.messager.alert("提示","代码不能为空");
                        return false;
			        } 
			        var Desc=editors[1].target.val()
			         if (Desc==""){
						$.messager.alert("提示","描述不能为空");
                        return false;
			        } 
			        var ToStock=editors[2].target.is(':checked');
					if(ToStock){ ToStock="Y";}else{ToStock="N";}
			        var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.DocConfig",
						MethodName:"SaveTakingMedicineMethod",
					   	RowID:RowID, Code:Code, Desc:Desc,ToStock:ToStock
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        LoadConfigTakingMedDataGrid();	
				        InitTakingMedicineMethod();
				        var rows = CMPrescTypeDataGrid.datagrid("getSelections");
						var PrescTypeCode=rows[rows.length-1].Code;
						LoadCMPrescTypeDetail(PrescTypeCode);	
					}else{
						$.messager.alert("提示",value);
                        return false;
						}
			            
		        }
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var ConfigTakingMedColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        			{ field: 'Code', title: '代码', width: 20,editor : {type : 'text',options : {}}},
        			{ field: 'Desc', title: '描述', width: 20,editor : {type : 'text',options : {}}},
					{ field: 'ToStock', title: '是否判断库存', width: 70,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
                            }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 				},
		 				formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 		}
					}
    			 ]];
	// 煎药方式列表Grid
	ConfigTakingMedDataGrid=$('#ConfigTakingMedicineMethodtab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :ConfigTakingMedColumns,
		toolbar :ConfigTakingMedicineMethodToolBar,
		onClickRow:function(rowIndex, rowData){
			ConfigTakingMedDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=ConfigTakingMedDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (ConfigTakingMedEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			ConfigTakingMedDataGrid.datagrid("beginEdit", rowIndex);
			ConfigTakingMedEditRow=rowIndex;
		}
	});
	LoadConfigTakingMedDataGrid()
	}
function LoadConfigTakingMedDataGrid(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindTakingMedicineMethod",
	    Pagerows:ConfigTakingMedDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		ConfigTakingMedDataGrid.datagrid('loadData',GridData);
		ConfigTakingMedEditRow=undefined
		ConfigTakingMedDataGrid.datagrid("clearSelections")
	})
	}
function InitTakingMedicineMethod(){
	$("#Combo_TakingMedicineMethod").combobox({ 
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindTakingMedicineMethod",
		valueField:'RowID',
		textField:'Desc',
		multiple:true,
		//rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		loadFilter:function(data){
			return data['rows'];
		},
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.Desc+"<span id='i"+row.RowID+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.Desc+"<span id='i"+row.RowID+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	}
var CNMedInstrContrastDataGrid,InstrContrastDataGridEditRow;

function InitCNMedInstrContrast(){
	///煎药方式
	 var CNMedInstrContrastToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	InstrContrastDataGridEditRow = undefined;
                CNMedInstrContrastDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                CNMedInstrContrastDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                CNMedInstrContrastDataGrid.datagrid("beginEdit", 0);
                InstrContrastDataGridEditRow = 0;     
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = CNMedInstrContrastDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = CNMedInstrContrastDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DocConfig",
									MethodName:"DelectInstrContrast",
								   	RowID:Rowid,
								   	HospId:$HUI.combogrid('#_HospList').getValue()
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadInstrContrastDataGrid()		
								}
	                        }else{
								InstrContrastDataGridEditRow = undefined;
				                CNMedInstrContrastDataGrid.datagrid("rejectChanges");
				                CNMedInstrContrastDataGrid.datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                InstrContrastDataGridEditRow = undefined;
                CNMedInstrContrastDataGrid.datagrid("rejectChanges");
                CNMedInstrContrastDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveCNMedInstrContrastData();
			}
		}];
	 ///煎药方式列表columns 附加医嘱，接收科室
    var CNMedInstrContrastColumns=[[   
		{ field: 'RowID', title: 'RowID', width: 10,hidden:true },
        { field: 'CMPrescType', title: '医嘱类型', width: 60,
        	editor : {
            	type : 'combobox',
            	options : {
                	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindLinkInstrContrast&ValType=PrescType&Value=CNMedPrior&HospId="+$HUI.combogrid('#_HospList').getValue(),
                	valueField:'RowId',
					textField:'Desc',
					required:true,
					loadFilter:function(data){
						return data['rows'];
					}
                }
            },
			formatter:function(value, record){
			  return record.CMPrescTypeDesc;
			}
		},
		{ field: 'CMPrescInstr', title: '用法', width: 60,
			editor : {
				type : 'combobox',
				options : {
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindLinkInstrContrast&ValType=PrescInstr&Value=AdmTypeInstr,0&HospId="+$HUI.combogrid('#_HospList').getValue(),
                	valueField:'RowId',
					textField:'Desc',
					required:true,
					loadFilter:function(data){
						return data['rows'];
					}
				}
			},
			formatter:function(value, record){
			  return record.CMPrescInstrDesc;
			}
		}
     ]];
	// 煎药方式列表Grid
	CNMedInstrContrastDataGrid=$('#tabCNMedInstrContrast').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindInstrContrast&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedInstrContrastColumns,
		toolbar :CNMedInstrContrastToolBar,
		onClickRow:function(rowIndex, rowData){
			CNMedInstrContrastDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedInstrContrastDataGrid.datagrid('getRows'); 
		}
	});
	LoadInstrContrastDataGrid()
}
function LoadInstrContrastDataGrid(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindInstrContrast",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:CNMedInstrContrastDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CNMedInstrContrastDataGrid.datagrid('loadData',GridData);
		InstrContrastDataGridEditRow=undefined
		CNMedInstrContrastDataGrid.datagrid("clearSelections")
	})
}
function SaveCNMedInstrContrastData(){
	if (InstrContrastDataGridEditRow != undefined){
		var InstrContrastSelRow=CNMedInstrContrastDataGrid.datagrid("selectRow",InstrContrastDataGridEditRow).datagrid("getSelected"); 
		var CMPrescType=InstrContrastSelRow.CMPrescType;
		var editors = CNMedInstrContrastDataGrid.datagrid('getEditors', InstrContrastDataGridEditRow);   		
		var CMPrescType = editors[0].target.combobox('getValue');
		var CMPrescTypeDesc = editors[0].target.combobox('getText');
		if (!CMPrescType){
			$.messager.alert("提示","请选择医嘱类型!");
            return false;
	    }
		var CMPrescInstr= editors[1].target.combobox('getValue');
		var CMPrescInstrDesc = editors[1].target.combobox('getText');
		if ((CMPrescInstrDesc=="")||(CMPrescInstr=="")){
			$.messager.alert("提示","请选择用法!");
            return false;
	    }
	    var SameFlag=0
	    var rows = CNMedInstrContrastDataGrid.datagrid("getRows");	
		for(var i=0; i<rows.length; i++){
	      if (InstrContrastDataGridEditRow==i) continue;
	      if (rows[i].CMPrescType==CMPrescType){
		      SameFlag=1
		      
		      }
		}	  
		if (SameFlag==1){
			$.messager.alert("提示","医嘱类型重复!");
            return false;
	    }
		var value=$.m({
			ClassName:"DHCDoc.DHCDocConfig.DocConfig",
			MethodName:"SaveCNMedInstrContrastData",
		   	CMPrescType:CMPrescType+"^"+CMPrescTypeDesc,
		   	CMPrescInstr:CMPrescInstr+"^"+CMPrescInstrDesc,
		   	HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value=="0"){
			CNMedInstrContrastDataGrid.datagrid("endEdit", InstrContrastDataGridEditRow);
			InstrContrastDataGridEditRow = undefined;
			CNMedInstrContrastDataGrid.datagrid('unselectAll').datagrid('load');
			$.messager.popover({msg: '保存成功!',type:'success'});      					
		}else{
			$.messager.alert('提示',"保存失败!请选择有效的处方类型和用法!");
			return false;
		}
		InstrContrastDataGridEditRow = undefined;
	}else{
		$.messager.alert("提示", "请选择医嘱类型和用法", "error");
	}
}
