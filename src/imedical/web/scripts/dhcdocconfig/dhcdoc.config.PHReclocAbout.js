
var PageLogicObj={
	ItemCatExtDataGrid:"",
	editRow:undefined,
	LocRowID:""
}

$(function(){ 
	InitHospList();
    $("#BFind").click(LoadItemCatExtDataGrid);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_PHReclocAbout");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitComboPHRecLoc();
    InitItemCatExtDataGrid();
}
function InitItemCatExtDataGrid()
{
	var ItemCatExtTools = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            Save();
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.editRow = undefined;
                PageLogicObj.ItemCatExtDataGrid.datagrid("rejectChanges");
                PageLogicObj.ItemCatExtDataGrid.datagrid("unselectAll");
            }
        }];
        ///ItemCatDr:%String,ItemCatDesc:%String,NormSplitPackQty:%String,AutoCreatONEOrd
	var ItemCatExtColumns=[[    
                    { field: 'ItemCatDr',hidden:true},
        			{ field: 'ItemCatDesc', title: '药品子类', width: 150, align: 'center', sortable: true},
        			///非急诊留观押金模式下，计费、药房组无法处理
					{ field: 'NormSplitPackQty', title: '临时医嘱拆分整包装发药(仅在急诊留观押金的虚拟长期模式下有效)',  align: 'center', sortable: true,
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
					}/*,
					{ field: 'EMAutoCreatONEOrd', title: '急诊虚拟长期嘱托、自备药医嘱自动计算插入取药医嘱',  align: 'center', sortable: true,hidden:true,
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
					},
					{ field: 'EnableIPDispensingMode', title: '启用医生科室发药',  align: 'center', sortable: true,hidden:true,
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
					}*/
    			 ]];
	PageLogicObj.ItemCatExtDataGrid=$('#tabPHItemCatExtConfig').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ItemCatDr",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :ItemCatExtColumns,
		toolbar :ItemCatExtTools,
		onClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.ItemCatExtDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex
		}
	});
	LoadItemCatExtDataGrid();
};
function LoadItemCatExtDataGrid()
{
	var LocId=$("#Combo_PHRecLoc").combobox("getValue");
	PageLogicObj.LocRowID=LocId;
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.PHReclocAbout",
	    QueryName : "GetItemCatExtConfig",
	    PHRecloc:LocId,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.ItemCatExtDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.editRow = undefined;
		PageLogicObj.ItemCatExtDataGrid.datagrid('unselectAll');
		PageLogicObj.ItemCatExtDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
function InitComboPHRecLoc()
{
	var GridData=$.cm({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindDep",
	    desc:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},false);
	$("#Combo_PHRecLoc").combobox({   
		valueField:'CTLOCRowID',   
		textField:'CTLOCDesc',
		data:GridData['rows'],
		onSelect:function(){
			$("#BFind").click();
		}
	})
	$("#Combo_PHRecLoc").combobox("setValue","")
};
function Save(){
	if(PageLogicObj.LocRowID==""){
	  return false;
	}
	var rows = PageLogicObj.ItemCatExtDataGrid.datagrid("getRows"); 
	var NormSplitPackQty="0";
	var EMAutoCreatONEOrd="0";
	var EnableIPDispensingMode="0";
	var rows=PageLogicObj.ItemCatExtDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	var editors = PageLogicObj.ItemCatExtDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
	var selected=editors[0].target.is(':checked');
	if(selected) NormSplitPackQty="1";
	/*
	var selected=editors[1].target.is(':checked');
	if(selected) EMAutoCreatONEOrd="1";
	var selected=editors[2].target.is(':checked');
	if(selected) EnableIPDispensingMode="1";
	*/
	if ((EMAutoCreatONEOrd=="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('提示',"该子类无法同时拆包装发药且自动生成取药！");
		return false;
	}
	
	var HospDr=$HUI.combogrid('#_HospList').getValue();
	var UserEMVirtualtLong = $.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNode",
		    Node:"UserEMVirtualtLong",
		    HospId:HospDr,
			dataType:"text"
		},false)
	//目前药房判是否启用医生科室发药是根据虚拟长期勾选判断的，仅使用医生科室发药界面操作时才能按执行记录发药、计费、退药、退费
	//目前药房无法将判断修改为该勾选，因为涉及不同子类需要切换发药界面的问题。
	if ((UserEMVirtualtLong!="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('提示',"当前医院未开启急诊虚拟长期，无法配置临时医嘱拆分整包装发药！");
		return false;
	}
	/*
	if ((NormSplitPackQty=="1")&&(EnableIPDispensingMode=="0")){
		$.messager.alert('提示',"该子类在拆包装发药模式下,请务必启用住院发药模式！");
		return false;
	}
	*/
	var DHCFieldNumStr="1^2^3";
	var ValStr=NormSplitPackQty+"^"+EMAutoCreatONEOrd+"^"+EnableIPDispensingMode;

	$.m({
		ClassName:"DHCDoc.DHCDocConfig.PHReclocAbout",
		MethodName:"SetPHReclocAboutItemCatExtValue",
		PHRecloc:PageLogicObj.LocRowID, ItemCatDr:rows.ItemCatDr,DHCFieldNumStr:DHCFieldNumStr, ValStr:ValStr
	},function(value){
		if(value=="0"){
			PageLogicObj.ItemCatExtDataGrid.datagrid("endEdit", PageLogicObj.editRow);
			LoadItemCatExtDataGrid();
			$.messager.show({title:"提示",msg:"保存成功"});
		}else{
			$.messager.alert('提示',"保存失败:"+value);
			return false;
		}
	});
}
