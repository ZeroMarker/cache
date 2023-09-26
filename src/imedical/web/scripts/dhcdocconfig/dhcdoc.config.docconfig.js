var editRow1 = undefined; //定义全局变量：当前编辑的行
var editRow2 =undefined;
var editRow3 =undefined;
var editRow4 =undefined;
var SelCNMedCookMode=undefined;
var SelectedRow=""
var CNMeditemInstrDataGrid; 
var CNMedPackModeDataGrid;
var CHNPHFrequenceDataGrid;
var CNMedCookModeDataGrid;
var CNMedAddLongOrderGrid;
var DefaultCNMedNormKL="1" //普通/颗粒 中的普通
//草药子分类 颗粒剂子分类 协定处方设置
var arrayObj1=new Array(
      new Array("List_CNMedItemCat","CNMedItemCat"),
      new Array("List_CNMedKLItemCat","CNMedKLItemCat"),
	  new Array("List_FormulaItemCat","FormulaItemCat")
	  
);
//默认频次
var arrayObj2 = new Array(
      new Array("Combo_DefaultFrequence","CNMedDefaultFrequence")
);
//默认疗程
var arrayObj3 = new Array(
      new Array("SSDBCombo_DefaultDuration","CNMedDefaultDuration")
);
//附加材料 代煎费
var arrayObj4 = new Array(
      new Array("SSDBCombo_Item","CNMedAppendItem"),
	  new Array("SSDBCombo_CookModeFee","CNMedCookModeFeeItem") //,
	 // new Array("SSDBCombo_CNMedAddLongOrder","CNMedAddLongOrder")
	  
);
//默认用法
var arrayObj5 = new Array(
      new Array("Combo_DefaultInstr","CNMedDefaultInstruction")
);
//默认
/*
,
	  new Array("Check_CNMedAppendItemQtyCalcu","CNMedAppendItemQtyCalcu"),
	  new Array("Check_IPCookModeFeeNoAutoAdd","IPCookModeFeeNoAutoAdd")
*/
var arrayObj6 = new Array(
      new Array("Text_DefaultQty","CNMedDefaultQty"),
	  new Array("Txt_ViewGroupSum","ViewGroupSum"),
	  new Array("Check_CNMedAppendItemQtyCalcu","CNMedAppendItemQtyCalcu"),
	  new Array("Check_IPCookModeFeeNoAutoAdd","IPCookModeFeeNoAutoAdd"),
	  new Array("Check_ApperFormulaItem","ApperFormulaItem"),
	  new Array("Check_PrintFormulaItem","PrintFormulaItem")
);
//接受科室
//,new Array("List_CNMedNormKLRefLoc","CNMedNormKL")
var arrayObj7 = new Array(
      new Array("List_CNMedCookDep","CNMedCookDep"),
	  new Array("List_EPCNMedCookDep","EPCNMedCookDep")
);
var arrayObj8 = new Array(
      new Array("List_CNMedItemCat","CNMedItemCat"),
	  new Array("List_CNMedKLItemCat","CNMedKLItemCat"),
	  new Array("List_CNMedPrior","CNMedPrior"),
	  new Array("List_CNMedCookDep","CNMedCookDep"),
	  new Array("List_EPCNMedCookDep","EPCNMedCookDep"),
	  new Array("List_FormulaItemCat","FormulaItemCat")
  );
  //Combox的保存
var arrayObj9 = new Array(
      new Array("SSDBCombo_Item","CNMedAppendItem"),
	  new Array("SSDBCombo_CookModeFee","CNMedCookModeFeeItem"),
	  new Array("Combo_DefaultFrequence","CNMedDefaultFrequence"),
	  new Array("SSDBCombo_DefaultDuration","CNMedDefaultDuration"),
	  new Array("Combo_DefaultInstr","CNMedDefaultInstruction"),
	  new Array("SSDBCombo_CHNPHBillsub","CHNPHBillSub") //,
	  //new Array("SSDBCombo_CNMedAddLongOrder","CNMedAddLongOrder")
);

$(function(){ 
	 for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       LoadListData(param1,param2);	    
   }
   for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj2[i][0];
		   var param2=arrayObj2[i][1];
	       LoadDefaultFreqData(param1,param2);	    
   }
   for( var i=0;i<arrayObj3.length;i++) {
		   var param1=arrayObj3[i][0];
		   var param2=arrayObj3[i][1];
	       LoadDefaultDurData(param1,param2);	    
   }
   for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       LoadDefaultItemComboData(param1,param2);	 
	       LoadDefaultItemData(param1,param2);
	          
   }
   for( var i=0;i<arrayObj5.length;i++) {
		   var param1=arrayObj5[i][0];
		   var param2=arrayObj5[i][1];
	       LoadDefaultInstrData(param1,param2);	    
   }
   for( var i=0;i<arrayObj6.length;i++) {
		   var param1=arrayObj6[i][0];
		   var param2=arrayObj6[i][1];
	       LoadDefaultData(param1,param2);	    
   }
  for( var i=0;i<arrayObj7.length;i++) {
		   var param1=arrayObj7[i][0];
		   var param2=arrayObj7[i][1];
	       LoadDefaultLocData(param1,param2);	    
   }
   ///可用医嘱类型
   LoadCNMedPrior("List_CNMedPrior")
   //账单大类
   LoadFindARCBillGrpData("SSDBCombo_BillGroup","CHNPHBillSub");
   //账单子类
   LoadFindARCBillSubpData("SSDBCombo_CHNPHBillsub","CHNPHBillSub");
   //就诊类型 药物使用方式 List_Instr  LoadListData
   LoadInstrData("List_Instr","O");
   //医嘱子类 药物加工方式
   LoadCNMedItemCat2Data("List_CNMedItemCat2","");
   //
   LoadNMedNormKLInStrData(DefaultCNMedNormKL)
   LoadCNMedNormKLCookModeData(DefaultCNMedNormKL);
   LoadCNMedNormKLRefLoc(DefaultCNMedNormKL);
   LoadCNMedNormKLItemCat(DefaultCNMedNormKL);
   LoadListCookModeData("List_CookMode","");
   $("#List_CNMedItemCat2").combobox({
       onChange: function (CatDr,o) {	
           $("#List_CookMode").empty();
		   LoadListCookModeData("List_CookMode",CatDr);
       }
   })
   
    //加载DataGrid数据
     InitCNMeditemInstr();
	 InitCNMedPackMode();
	 InitCHNPHFrequence();
	 //煎药费账单子类 datagrid
	 InitCNMedCookMode();
	 InitCNMedAddLongOrderGrid();
	 //保存按钮
     $("#BSave").click(function(){
		 SaveAllCNMedInfo();
     });
})
function LoadDefaultItemData(param1,param2){
   var $param1=$("#"+param1+"")
   $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.ArcItemConfig","getDefaultData","false",function(objScope,value,extraArg){
			$param1.combobox('setValue', objScope.result.split("^")[0]);
			$param1.combobox('setText', objScope.result.split("^")[1]);
   },"","",param2);
}
function AdmTypeChange()
{
	$("#List_Instr").empty();
	var AdmType=$("#List_AdmType").val() ;
	LoadInstrData("List_Instr",AdmType);
}
function CNMedNormKLChange()
{
	$("#Combo_CNMedNormKLInStr").empty();
	$("#Combo_CNMedNormKLCookMode").empty();
	$("#List_CNMedNormKLRefLoc").empty();
	$("#List_CNMedNormKLItemCat").empty();
	var id=$("#Combo_CNMedNormKL").val() ;
	LoadNMedNormKLInStrData(id);
	LoadCNMedNormKLCookModeData(id);
	LoadCNMedNormKLRefLoc(id);
	LoadCNMedNormKLItemCat(id);
}
function LoadCNMeditemInstrDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='Find';
	queryParams.Arg1="CNMedItemPhSpecInstr"
	queryParams.ArgCnt =1;
	var opts = CNMeditemInstrDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CNMeditemInstrDataGrid.datagrid('load', queryParams);
}  
function LoadCNMedPackModeDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='Find';
	queryParams.Arg1="CNMedPackMode"
	queryParams.ArgCnt =1;
	var opts = CNMedPackModeDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CNMedPackModeDataGrid.datagrid('load', queryParams);
}
function LoadCHNPHFrequenceDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCHNPHFrequence';
	queryParams.ArgCnt =0;
	var opts = CHNPHFrequenceDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CHNPHFrequenceDataGrid.datagrid('load', queryParams);
}
function LoadCNMedCookModeDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCNMedCookMode';
	queryParams.Arg1="CNMedCookMode";
	queryParams.ArgCnt =1;
	var opts = CNMedCookModeDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CNMedCookModeDataGrid.datagrid('load', queryParams);
}
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
	var editors = CNMeditemInstrDataGrid.datagrid('getEditors', editRow2);
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
		editRow2 = undefined;
		CNMeditemInstrDataGrid.datagrid("rejectChanges");
        CNMeditemInstrDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig2","false",function testget(value){
						if(value=="0"){
							$.messager.show({title:"提示",msg:"保存成功"});	
                            CNMeditemInstrDataGrid.datagrid('load');			
						}
	},"","","CNMedItemPhSpecInstr",str);
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
	var editors = CNMedPackModeDataGrid.datagrid('getEditors', editRow1);
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
		editRow1 = undefined;
		CNMedPackModeDataGrid.datagrid("rejectChanges");
        CNMedPackModeDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig2","false",function testget(value){
						if(value=="0"){
							$.messager.show({title:"提示",msg:"保存成功"});	
                            CNMedPackModeDataGrid.datagrid('load');			
						}
	},"","","CNMedPackMode",str);
}
function SaveCHNPHFrequenceData()
{
	if (editRow3 != undefined)
    {
		var editors = CHNPHFrequenceDataGrid.datagrid('getEditors', editRow3);   		
		var FreqDr =  editors[0].target.combobox('getValue');
		var Factor =  editors[1].target.val();
		var Default=  editors[2].target.val();
        $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","saveFrequence","false",function testget(value){
			if(value=="0"){
				CHNPHFrequenceDataGrid.datagrid("endEdit", editRow3);
				editRow3 = undefined;
				CHNPHFrequenceDataGrid.datagrid('load');
				CHNPHFrequenceDataGrid.datagrid('unselectAll');
				$.messager.alert({title:"提示",msg:"保存成功"});           					
			}else{
				if(value=="-1") value="项目重复,不能添加"
				$.messager.alert('提示',"保存失败:"+value);
				return false;
			}
			editRow3 = undefined;
			},"","",FreqDr,Factor,Default);			
	}else{
		$.messager.alert("提示", "请选择一个要维护的频率", "error");
	}
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
	var editors = CNMedCookModeDataGrid.datagrid('getEditors', editRow4);
    if(+editors!=0){
		var Code =  editors[0].target.val();
	    var Desc= editors[1].target.val();
		var ARCOrdID =  editors[2].target.combobox('getValue');
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
		editRow4 = undefined;
		SelCNMedCookMode=undefined;
		CNMedCookModeDataGrid.datagrid("rejectChanges");
        CNMedCookModeDataGrid.datagrid("unselectAll");
	}
	//增加方法SaveConfig2
	$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig2","false",function testget(value){
				if(value=="0"){
					$.messager.show({title:"提示",msg:"保存成功"});	
                    CNMedCookModeDataGrid.datagrid('load');			
				}
	},"","","CNMedCookMode",str);
}
function InitCNMeditemInstr(){
	///用法
	 var CNMeditemInstrToolBar = [{
            text: '添加',
            //iconCls: 'icon-add',
            handler: function() { 
                if (editRow2 != undefined) {
                    //CNMeditemInstrDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
                    CNMeditemInstrDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    CNMeditemInstrDataGrid.datagrid("beginEdit", 0);
                    editRow2 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            //iconCls: 'icon-remove',
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
        },
        '-', {
            text: '取消编辑',
            //iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow2 = undefined;
                CNMeditemInstrDataGrid.datagrid("rejectChanges");
                CNMeditemInstrDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			handler: function() {
				SaveCNMeditemInstrData();
			}
		}];
	 ///用法列表columns
    CNMeditemInstrColumns=[[    
                    { field: 'Code', title: '代码', width: 10, align: 'center', sortable: true, resizable: true,
					   editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	// 用法列表Grid
	CNMeditemInstrDataGrid=$('#tabCNMeditemInstr').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"Code",
		//pageList : [15,50,100,200],
		columns :CNMeditemInstrColumns,
		toolbar :CNMeditemInstrToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			CNMeditemInstrDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMeditemInstrDataGrid.datagrid('getRows'); 
		}
	});
	LoadCNMeditemInstrDataGrid();
}
function InitCNMedPackMode(){
	///包装方式
	 var CNMedPackModeToolBar = [{
            text: '添加',
            //iconCls: 'icon-add',
            handler: function() { 
                if (editRow1 != undefined) {
                    //CNMedPackModeDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
                    CNMedPackModeDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    CNMedPackModeDataGrid.datagrid("beginEdit", 0);
                    editRow1 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            //iconCls: 'icon-remove',
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
        },
        '-', {
            text: '取消编辑',
            //iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow1 = undefined;
                CNMedPackModeDataGrid.datagrid("rejectChanges");
                CNMedPackModeDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			handler: function() {
				SaveCNMedPackModeData();
			}
		}];
	 ///包装方式列表columns
    CNMedPackModeColumns=[[    
                    { field: 'Code', title: '代码', width: 10, align: 'center', sortable: true, resizable: true,
					   editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	// 包装方式列表Grid
	CNMedPackModeDataGrid=$('#tabCNMedPackMode').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"Code",
		//pageList : [15,50,100,200],
		columns :CNMedPackModeColumns,
		toolbar :CNMedPackModeToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			CNMedPackModeDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedPackModeDataGrid.datagrid('getRows'); 
		}
	});
	LoadCNMedPackModeDataGrid();
}
function InitCHNPHFrequence()
{
	///使用频率
	 var CHNPHFrequenceToolBar = [{
            text: '添加',
            //iconCls: 'icon-add',
            handler: function() { 
                if (editRow3 != undefined) {
                    //CHNPHFrequenceDataGrid.datagrid("endEdit", editRow3);
                    return;
                }else{
                    CHNPHFrequenceDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    CHNPHFrequenceDataGrid.datagrid("beginEdit", 0);
                    editRow3 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            //iconCls: 'icon-remove',
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
                            var id=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","deleteFrequence","false",function testget(value){
						    if(value=="0"){
							  CHNPHFrequenceDataGrid.datagrid('load');
           					  CHNPHFrequenceDataGrid.datagrid('unselectAll');
           					  $.messager.show({title:"提示",msg:"删除成功"});
						   }else{
							$.messager.alert('提示',"删除失败:"+value);
						  }
						   editRow3 = undefined;
						  },"","",id);
							/*CHNPHFrequenceDataGrid.datagrid("selectRow",SelectedRow)
							CHNPHFrequenceDataGrid.datagrid('deleteRow',SelectedRow);
							//SaveCHNPHFrequenceData();*/
							
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },
        '-', {
            text: '取消编辑',
            //iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow3 = undefined;
                CHNPHFrequenceDataGrid.datagrid("rejectChanges");
                CHNPHFrequenceDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			handler: function() {
				SaveCHNPHFrequenceData();
			}
		}];
	 ///包装方式列表columns
    CHNPHFrequenceColumns=[[ 
					{ field: 'CPFRowid', title: 'ID', width: 1, align: 'center', sortable: true, resizable: true,hidden:true

					},	
                    { field: 'CPFFrequence', title: '名称', width: 20, align: 'center', sortable: true, resizable: true,
					   editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'FreqRowId',
								textField:'FreqDesc1',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.FreqOPDispensingTime";
									param.QueryName = "FindFreq";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  }
					},
        			{ field: 'CPFFactor', title: '系数', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {
						  type : 'text',
						  options : {
						  }
					  }
					},
					{ field: 'CPFDefault', title: '默认', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {
                                type : 'checkbox',
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
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"CPFRowid",
		//pageList : [15,50,100,200],
		columns :CHNPHFrequenceColumns,
		toolbar :CHNPHFrequenceToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			CHNPHFrequenceDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CHNPHFrequenceDataGrid.datagrid('getRows'); 
		}
		
	});
	LoadCHNPHFrequenceDataGrid();
}
function InitCNMedCookMode()
{
	///煎药费账单子类
	 var CNMedCookModeToolBar = [{
            text: '添加',
            //iconCls: 'icon-add',
            handler: function() { 
                if (editRow4 != undefined) {
                    //CNMedCookModeDataGrid.datagrid("endEdit", editRow4);
                    return;
                }else{
                    CNMedCookModeDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    CNMedCookModeDataGrid.datagrid("beginEdit", 0);
                    editRow4 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            //iconCls: 'icon-remove',
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
        },
        '-', {
            text: '取消编辑',
            //iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow4 = undefined;
                SelCNMedCookMode=undefined;
                CNMedCookModeDataGrid.datagrid("rejectChanges");
                CNMedCookModeDataGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			handler: function() {
				SaveCNMedCookMode();
			}
		}];
	 ///列表columns
    CNMedCookModeColumns=[[ 
	                { field: 'ArcOrd', title: 'ID', width: 10, align: 'center', sortable: true, resizable: true,hidden:true

					},
					{ field: 'Code', title: '代码', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}

					},	
                    { field: 'Desc', title: '名称', width: 20, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'ArcOrdID', title: '医嘱套名称', width: 35, align: 'center', sortable: true, resizable: true,
					   editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'ARCOSRowId',
								textField:'ARCOSDesc',
								required:true,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.DocConfig";
									param.QueryName = "FindArcOrd";
									param.ArgCnt = 0;
								},
								onSelect:function(rec){
								}
							  }
     					  },
     					  formatter:function(value, record){
							  return record.ArcOrd;
						  }
					},
					{ field: 'ActiveFlag', title: '可用', width: 10, align: 'center', sortable: true, resizable: true,
					  editor : {
                                type : 'checkbox',
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
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"CPFRowid",
		//pageList : [15,50,100,200],
		columns :CNMedCookModeColumns,
		toolbar :CNMedCookModeToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow4 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			CNMedCookModeDataGrid.datagrid("beginEdit", rowIndex);
			editRow4=rowIndex
			SelCNMedCookMode=rowIndex
		},
		onClickRow:function(rowIndex, rowData){
			CNMedCookModeDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedCookModeDataGrid.datagrid('getRows'); 
		}
	});
	LoadCNMedCookModeDataGrid();
}
function LoadListData(param1,param2){
	
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.SubCatContral';
	queryParams.QueryName ='FindCatList';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
                               });
		                       $("#"+param1+"").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#"+param1+"").get(0).options[j-1].selected = true;
										}
								}
							
	});
} 
function LoadInstrData(param1,param2)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindInstrList';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.InstrRowID + ">" + n.InstrDesc + "</option>"; 
                               });
		                       $("#"+param1+"").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#"+param1+"").get(0).options[j-1].selected = true;
										}
								}
							
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
						param.ArgCnt =1;
		}  
	});
}
function LoadCNMedItemCat2Data(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'ARCICRowId',   
    	textField:'ARCICDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
						param.QueryName = 'FindCatList';
						param.Arg1 =param2;
						param.ArgCnt =1;
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
//
function LoadDefaultItemComboData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'ArcimRowID',   
    	textField:'ArcimDesc',
    	mode:'remote',
    	delay:100,
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindDefaultItem';
			param.Arg1 =param2;
			param.Arg2 = $("#"+param1+"").combobox("getText")
			param.Arg3 = 20
			param.ArgCnt =3;
		}  
	});
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
						param.ArgCnt =1;
		}  
	});
} 
function LoadDefaultLocData(param1,param2)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindDep';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
                               });
		                       $("#"+param1+"").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#"+param1+"").get(0).options[j-1].selected = true;
										}
								}
							
	});
}
function LoadDefaultData(param1,param2)
{
	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","getDefaultData","false",function(objScope,value,extraArg){
		                  //alert(objScope+":" + value + ":" + extraArg)
						    $("#"+param1+"").val(objScope.result);
							
							if (((param2=="CNMedAppendItemQtyCalcu")||(param2=="IPCookModeFeeNoAutoAdd")||(param2=="ApperFormulaItem")||(param2=="PrintFormulaItem"))&&(objScope.result==1)){
								
								$("#"+param1+"").attr('checked', true);
							}
							
						  },"","",param2);
	
}
function LoadCNMedPrior(param1)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCNMedPrior';
	queryParams.Arg1 ="CNMedPrior";
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.OECPRRowId + ">" + n.OECPRDesc + "</option>"; 
                               });
		                       $("#"+param1+"").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#"+param1+"").get(0).options[j-1].selected = true;
										}
								}
							
	});
	
}
function LoadListCookModeData(param1,param2)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCNMedCookModeByCat';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.Code + ">" + n.Desc + "</option>"; 
                               });
		                       $("#"+param1+"").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#"+param1+"").get(0).options[j-1].selected = true;
										}
								}
							
	});
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
						param.ArgCnt =1;
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
						param.Arg1 =param2;
						param.ArgCnt =1;
		}  
	});
} 
function LoadNMedNormKLInStrData(param1)
{
	$("#Combo_CNMedNormKLInStr").combobox({      
    	valueField:'InstrRowID',   
    	textField:'InstrDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
						param.QueryName = 'FindInstrByKL';
						param.Arg1 =param1;
						param.ArgCnt =1;
		}  
	});
} 
function LoadCNMedNormKLCookModeData(param1)
{
	$("#Combo_CNMedNormKLCookMode").combobox({      
    	valueField:'Code',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
						param.QueryName = 'FindCNMedCookModeByKL';
						param.Arg1 =param1;
						param.ArgCnt =1;
		}  
	});
}
function LoadCNMedNormKLRefLoc(param1)
{
	$("#List_CNMedNormKLRefLoc").combobox({      
    	valueField:'CTLOCRowID',   
    	textField:'CTLOCDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
						param.QueryName = 'FindCNMedNormKLRefLoc';
						param.Arg1 =param1;
						param.ArgCnt =1;
		}  
	});
}
function LoadCNMedNormKLItemCat(param1)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCatListByKL';
	queryParams.Arg1 =param1;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		                       var vlist = ""; 
							   var selectlist="";
							   jQuery.each(objScope.rows, function(i, n) { 
									    selectlist=selectlist+"^"+n.selected
                                        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
                               });
		                       $("#List_CNMedNormKLItemCat").append(vlist); 
							   for (var j=1;j<=selectlist.split("^").length;j++){
										if(selectlist.split("^")[j]==1){
											$("#List_CNMedNormKLItemCat").get(0).options[j-1].selected = true;
										}
								}
							
	});
}
function SaveAllCNMedInfo() 
{
	var Data=""
	// 草药录入显示列组数  
	var ViewGroupSum=$("#Txt_ViewGroupSum").val();
	if(ViewGroupSum>4){
		$.messager.alert("提示", "目前系统最多支持4列", "error");
		return false;
	}
	var Data="ViewGroupSum"+String.fromCharCode(1)+ViewGroupSum
	var CNMedDefaultQty=$("#Text_DefaultQty").val();
	Data=Data+String.fromCharCode(2)+"CNMedDefaultQty"+String.fromCharCode(1)+CNMedDefaultQty
	for( var i=0;i<arrayObj9.length;i++) {
		   var param1=arrayObj9[i][0];
		   var param2=arrayObj9[i][1];
	       var value=$("#"+param1+"").combobox("getValue") 
		   if(Data=="") Data=param2+String.fromCharCode(1)+value
		   else  Data=Data+String.fromCharCode(2)+param2+String.fromCharCode(1)+value
		   
   }
	//自动计算附加材料数量
	var  CNMedAppendItemQtyCalcu=0;
	var IPCookModeFeeNoAutoAdd=0
	if ($("#Check_CNMedAppendItemQtyCalcu").is(":checked")) {
		 CNMedAppendItemQtyCalcu=1	 
	}
	Data=Data+String.fromCharCode(2)+"CNMedAppendItemQtyCalcu"+String.fromCharCode(1)+CNMedAppendItemQtyCalcu
	//住院自动增加代煎费 
	if ($("#Check_IPCookModeFeeNoAutoAdd").is(":checked")) {
		 IPCookModeFeeNoAutoAdd=1
	}
	Data=Data+String.fromCharCode(2)+"IPCookModeFeeNoAutoAdd"+String.fromCharCode(1)+IPCookModeFeeNoAutoAdd;
	//协定处方是否显示明细
	var ApperFormulaItem=0;
	if ($("#Check_ApperFormulaItem").is(":checked")) {
		 ApperFormulaItem=1
	}
	Data=Data+String.fromCharCode(2)+"ApperFormulaItem"+String.fromCharCode(1)+ApperFormulaItem
	//协定处方是否打印明细
	var PrintFormulaItem=0;
	if ($("#Check_PrintFormulaItem").is(":checked")) {
		 PrintFormulaItem=1
	}
	Data=Data+String.fromCharCode(2)+"PrintFormulaItem"+String.fromCharCode(1)+PrintFormulaItem
	/*$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig","false",function(objScope,value,extraArg){				
	},"","",Data);*/
	for( var i=0;i<arrayObj8.length;i++) {
	   var Str="";
	   var param1=arrayObj8[i][0];
	   var param2=arrayObj8[i][1];
	   var DataList=param2
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (Str=="") Str=svalue
			  else Str=Str+"^"+svalue
			})
			//var param3=param2+String.fromCharCode(1)+Str
			/*$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig2","false",function(objScope,value,extraArg){				
	        },"","",param2,Str);*/
			Data=Data+String.fromCharCode(2)+param2+String.fromCharCode(1)+Str;
	   }	   
   }
   $.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig","false",function(objScope,value,extraArg){				
	},"","",Data);
   //普通颗粒设置
   var CNMedNormKL=$("#Combo_CNMedNormKL ").val(); 
   var CNMedNormKLInStr=$("#Combo_CNMedNormKLInStr ").combobox("getValue");
   var CNMedNormKLCookMode=$("#Combo_CNMedNormKLCookMode ").combobox("getValue");
   var RefLocStr=$("#List_CNMedNormKLRefLoc ").combobox("getValue");
   var CNMedNormKLItemCat=""; //List_CNMedNormKLItemCat
   var size = $("#List_CNMedNormKLItemCat"+ " option").size();
   if(size>0){
			$.each($("#List_CNMedNormKLItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CNMedNormKLItemCat=="") CNMedNormKLItemCat=svalue
			  else CNMedNormKLItemCat=CNMedNormKLItemCat+"^"+svalue
			})
	}
	var param3=CNMedNormKL+"$"+CNMedNormKLInStr+"$"+CNMedNormKLCookMode+"$"+RefLocStr+"$"+CNMedNormKLItemCat
    $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","saveCNMedNormKL","false",function(objScope,value,extraArg){				
    },"","",param3);
   //就诊类型/药物使用方式
   var AdmType=$("#List_AdmType ").val();
   var AdmTypeInstr="";
   var size = $("#List_Instr"+ " option").size();
   if((size>0)&&(AdmType!="")){
			$.each($("#List_Instr"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (AdmTypeInstr=="") AdmTypeInstr=svalue
			  else AdmTypeInstr=AdmTypeInstr+"^"+svalue
			})
		$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig1","false",function testget(value){		 
        },"","","AdmTypeInstr",AdmType,AdmTypeInstr);	
	}
    //医嘱子类/药物加工方式
   var CNMedItemCat2=$("#List_CNMedItemCat2").combobox("getValue");
   var ItemCatCookMode="";
   var size = $("#List_CookMode"+ " option").size();
	if((size>0)&&(CNMedItemCat2!="")){
			$.each($("#List_CookMode"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (ItemCatCookMode=="") ItemCatCookMode=svalue
			  else ItemCatCookMode=ItemCatCookMode+"^"+svalue
			})
			var para4="ItemCatCookMode"+"$"+CNMedItemCat2+"$"+ItemCatCookMode
			$.dhc.util.runServerMethod("web.DHCDocConfig","SaveConfig1","false",function testget(value){		 
            },"","","ItemCatCookMode",CNMedItemCat2,ItemCatCookMode);
	}
    $.messager.show({title:"提示",msg:"保存成功"});

}


function InitCNMedAddLongOrderGrid()
{
	///需要插入的医嘱单长期医嘱
	
	 var CNMedAddLongOrderToolBar = [{
            text: '添加',
            //iconCls: 'icon-add',
            handler: function() { 
                if (editRow3 != undefined) {
                    return;
                }else{
                    CNMedAddLongOrderGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    CNMedAddLongOrderGrid.datagrid("beginEdit", 0);
                    editRow3 = 0;
                }
              
            }
        },
        '-', {
            text: '删除',
            //iconCls: 'icon-remove',
            handler: function() {
                var rows = CNMedAddLongOrderGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].IDOut);
                            }
                            var id=ids.join(',')
                            
							$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","deleteCNMedAddLongOrder","false",function testget(value){
						    if(value=="0"){
							  CNMedAddLongOrderGrid.datagrid('load');
           					  CNMedAddLongOrderGrid.datagrid('unselectAll');
           					  $.messager.show({title:"提示",msg:"删除成功"});
						   }else{
							$.messager.alert('提示',"删除失败:"+value);
						  }
						   editRow3 = undefined;
						  },"","",id);
							
							CNMedAddLongOrderGrid.datagrid('deleteRow',SelectedRow);
							//SaveCHNPHFrequenceData();*/
							
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },
        '-', {
            text: '取消编辑',
            //iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow3 = undefined;
                CNMedAddLongOrderGrid.datagrid("rejectChanges");
                CNMedAddLongOrderGrid.datagrid("unselectAll");
            }
        },'-',{
			text: '保存',
			handler: function() {
				SaveCNMedAddLongOrderData();
			}
		}];
	 ///包装方式列表columns
    CNMedAddLongOrderColumns=[[ 
					{ field: 'IDOut', title: 'ID', width: 5, align: 'center', sortable: true, resizable: true

					},	
                    { field: 'DescOut', title: '名称', width: 20, align: 'center', sortable: true, resizable: true,
                    	
                    	editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'ArcimRowID',
								textField:'ArcimDesc',
								required:true,
								mode:'remote',
								delay:100,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.DocConfig";
									param.QueryName = "FindDefaultItem";
									param.ArgCnt =3;
									param.Arg1 ="";
									param.Arg2 = $(this).combobox('getText');
									param.Arg3 = "20";
									
								},
								onSelect:function(rec){
								}
							  }
     					  }
     					
					}
					
    			 ]];
	// 包装方式列表Grid
	CNMedAddLongOrderGrid=$('#tabCNMedAddLongOrder').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : '',
		queryParams : '',
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"IDOut",
		//pageList : [15,50,100,200],
		columns :CNMedAddLongOrderColumns,
		toolbar :CNMedAddLongOrderToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){ 
		},
		onClickRow:function(rowIndex, rowData){
			CNMedAddLongOrderGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=CNMedAddLongOrderGrid.datagrid('getRows'); 
		}
		
	});
	
	//LoadCHNPHFrequenceDataGrid();
	LoadCNMedAddLongOrderData();
}
function LoadCNMedAddLongOrderData()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.DocConfig';
	queryParams.QueryName ='FindCNMedLongOrder';
	queryParams.ArgCnt =0;
	var opts = CNMedAddLongOrderGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	CNMedAddLongOrderGrid.datagrid('load', queryParams);
}


///
function SaveCNMedAddLongOrderData()
{
	
	if (editRow3 != undefined)
    {
		var editors = CNMedAddLongOrderGrid.datagrid('getEditors', editRow3);   		
		var ArcimID =  editors[0].target.combobox('getValue');
        $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","saveCNMedAddLongOrder","false",function testget(value){
			if(value=="0"){
				CNMedAddLongOrderGrid.datagrid("endEdit", editRow3);
				editRow3 = undefined;
				CNMedAddLongOrderGrid.datagrid('load');
				CNMedAddLongOrderGrid.datagrid('unselectAll');
				$.messager.alert('提示',"保存成功");           					
			}else{
				$.messager.alert('提示',"保存失败");
				return false;
			}
			editRow3 = undefined;
			},"","",ArcimID);			
	}else{
		$.messager.alert("提示", "请选择医嘱项目", "error");
	}
}