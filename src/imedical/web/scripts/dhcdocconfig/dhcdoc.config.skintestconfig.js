var ActionListDataGrid;
var ItemListDataGrid;
var ActRowid="";
var editRow = undefined;
$(function(){ 
  InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SkinTestConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		LoadItemListDataGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//皮试备注grid
		InitActionList();
		//皮试备注绑定的医嘱项
		InitItemList();
	}
}
function SaveSkinTestConfig()
{
	var SkinTestInstr=$("#Combo_SkinTestInstr").combobox("getValue");
	var Data="SkinTestInstr"+String.fromCharCode(1)+SkinTestInstr;
	var SkinTestFreq=$("#Combo_SkinTestFreq").combobox("getValue");
	Data=Data+String.fromCharCode(2)+"SkinTestFreq"+String.fromCharCode(1)+SkinTestFreq;
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:Data,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
   	if(value=="0"){
		 $.messager.show({title:"提示",msg:"保存成功"});	
		 return false;
	}
};
function InitActionList()
{
	ActionListColumns=[[ 
        { field: 'ActRowid', title: 'ID', width: 10,hidden:true},
		{ field: 'ACTDesc', title: '名称', width: 10}
    ]];
	ActionListDataGrid=$('#tabActionList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SkinTestConfig&QueryName=GetSkinAction",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ActRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ActionListColumns,
		onClickRow:function(rowIndex, rowData){
			/*ActionListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=ActionListDataGrid.datagrid('getRows'); */
			editRow = undefined
			ActRowid=rowData.ActRowid
			LoadItemListDataGrid();
		}
	});
};
/*function LoadActionListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.SkinTestConfig';
	queryParams.QueryName ='GetSkinAction';
	queryParams.ArgCnt =0;
	var opts = ActionListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	ActionListDataGrid.datagrid('load', queryParams);
};*/
function InitItemList()
{
	var ItemListToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
			    if(ActRowid==""){
					$.messager.alert('提示',"请先选择皮试备注");
					return false;
				}
                if (editRow != undefined) {
                    return;
                }else{
	                editRow = 0;
                    ItemListDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    ItemListDataGrid.datagrid("beginEdit", 0);
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = ItemListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',');
                            if (ID=="") {
	                            editRow = undefined;
				                ItemListDataGrid.datagrid("rejectChanges");
				                ItemListDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.SkinTestConfig", 
								MethodName:"delete",
								ARCIRowid:ID
							},false);
					        if(value=="0"){
						       ItemListDataGrid.datagrid('unselectAll').datagrid('load');
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
						       return;
					        }
					        editRow = undefined;
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
				var editors = ItemListDataGrid.datagrid('getEditors', editRow);
				var rows = ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                if(rows.Rowid){
	                var Rowid=rows.Rowid
	            }else{
		            var Rowid=""
		        }
		        var arcrowid=rows.ActIARCIMDR;
		        if (!arcrowid) arcrowid="";
				//var arcrowid = editors[0].target.combobox('getValue');
				if(arcrowid==""){
					$.messager.alert('提示',"医嘱项不能为空!");
					return false;
				}
				var qty=editors[1].target.val();
				if(+qty==0){
					$.messager.alert('提示',"数量不能为0或空");
					return false;
				}
				var r = /^\+?[1-9][0-9]*$/;
				if (!r.test(qty)){
					$.messager.alert('提示',"数量只能为正整数!");
					return false;
				}
				var InstrDR=rows['InstrDR'];
				if (!InstrDR) InstrDR="";	
				/*var rows = ItemListDataGrid.datagrid("getRows");
	            for(var i=0; i<rows.length; i++){
				   if(rows[i].ActIARCIMDR!=undefined){
					   if ((arcrowid==rows[i].ActIARCIMDR)&&(InstrDR==rows[i].InstrDR)){
						   $.messager.alert('提示',"不能增加,该记录已存在!");
						   return false;
					   }
				   }
				}*/
				var Dose=editors[3].target.val();
				if (Dose==undefined){Dose=""} 
				var DoseUomDR=rows.DoseUomDR;
				if (!DoseUomDR) DoseUomDR="";
				var value=$.m({ 
					ClassName:"DHCDoc.DHCDocConfig.SkinTestConfig", 
					MethodName:"Save",
					Rowid:Rowid,
					ActRowid:ActRowid,
					ArcimRowid:arcrowid,
					ActQty:qty,
					InstrDR:InstrDR,
					Dose:Dose,
					DoseUomDR:DoseUomDR,
					HospId:$HUI.combogrid('#_HospList').getValue()
				},false);
				if (value=="repeat") {
					$.messager.alert('提示',"保存失败！记录重复!");
			        return false;
				}else if(+value=="0"){
			       ItemListDataGrid.datagrid('unselectAll').datagrid('load');
			       $.messager.show({title:"提示",msg:"保存成功"});
		        }else if(value=="-1"){
			        $.messager.alert('提示',"请选择有效的医嘱项!");
			        return false;
			    }else{
			       $.messager.alert('提示',"保存失败:"+value);
			       return false;
		        }
		        editRow = undefined;
			}
		},{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                ItemListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        }];
	ItemListColumns=[[ 
		{ field: 'ActIARCIMDesc', title: '名称', width: 200, align: 'left', 
		  	editor:{
                     type:'combogrid',
                     options:{
                        required: true,
                        panelWidth:450,
						panelHeight:290,
                        idField:'ArcimRowID',
                        textField:'ArcimDesc',
                        value:'',//缺省值 
                        delay:500,
                        mode:'remote',
						pagination : true,//是否分页   
						rownumbers:true,//序号   
						collapsible:false,//是否可折叠的   
						fit: true,//自动大小   
						pageSize: 10,//每页显示的记录条数，默认为10   
						pageList: [10,20,30,100],//可以设置每页记录条数的列表  
                        url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SkinTestConfig&QueryName=FindItem", //DHCDoc.DHCDocConfig.ArcItemConfig
                        columns:[[
                            {field:'ArcimDesc',title:'名称',width:400,sortable:true},
		                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
		                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                         ]],onClickRow : function(rowIndex, rowData) {
                			var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                            if(rows) rows.ActIARCIMDR=rowData.ArcimRowID;
                            var editDoseObj=ItemListDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
							$(editDoseObj.target).val("");
                            var EditDoseUomObj=ItemListDataGrid.datagrid('getEditor', {index:editRow,field:'DoseUom'});
							EditDoseUomObj.target.combobox('reload').combobox('select',"");
		                 },
		                 onBeforeLoad:function(param){
			                 var desc=param['q'];
			                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
			             },
			             onSelect: function (rowIndex, rowData){
				             var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                            if(rows) rows.ActIARCIMDR=rowData.ArcimRowID;
				            var editDoseObj=ItemListDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
							$(editDoseObj.target).val("");
				            var EditDoseUomObj=ItemListDataGrid.datagrid('getEditor', {index:editRow,field:'DoseUom'});
							EditDoseUomObj.target.combobox('reload').combobox('select',"");
				         }
            		}
    			  }
		},
		{ field: 'ActIQty', title: '数量', width: 50, align: 'center', 
		  editor : {type : 'text',options : {}}
		},
		{ field: 'ActIARCIMDR', title: '名称', width: 10, align: 'center', hidden:true
		},
		{ field: 'InstrDR', title: '', width: 10, align: 'center', hidden:true
		},
		{field:'Instr',title:'用法',width:90,editor:{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=web.DHCDocItemDefault&QueryName=FindGlobal", 
					valueField:'RowId',
					textField:'Desc',
					onBeforeLoad:function(param){
						param = $.extend(param,{GlobalName:"^PHCIN(",DescNum:"1^2",Type:""});
					},
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(rec){
						var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        rows.InstrDR=rec.RowId;
					},
					onChange:function(newValue, oldValue){
						if (newValue==""){
							var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                            rows.InstrDR="";
						}
					},
					onHidePanel:function(){
						var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
						if (!$.isNumeric($(this).combobox('getValue'))) return;
						rows.InstrDR=$(this).combobox('getValue');
					}
				  }
			  },
			  formatter:function(value, record){
				  return record.Instr;
			  }
		},
		{field:'Dose',title:'单次剂量',width:70,editor : {type : 'text'}},
		{field:'DoseUomDR',hidden:true},
		{field:'DoseUom',title:'剂量单位',width:70,editor:{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=web.DHCDocItemDefault&QueryName=FindDoseUOM", //PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'RowId',
					textField:'Desc',
					required:false,
					onBeforeLoad:function(param){
						var ARCIMDR=""
						var editors = ItemListDataGrid.datagrid('getEditors', editRow); 
						if (editors[0]){
							var ARCIMDR=editors[0].target.combogrid('getValue');
						}
						if (ARCIMDR == undefined){
							ARCIMD="";
						}
						if ((ARCIMDR=="")||(ARCIMDR.indexOf("||")==-1)) {
							var ARCIMDR=ItemListDataGrid.datagrid("getData").rows[editRow].ActIARCIMDR;
						}
						if (ARCIMDR == undefined){
							ARCIMDR="";
						}
						param = $.extend(param,{ARCIMRowid:ARCIMDR,HOSPID:$HUI.combogrid('#_HospList').getValue()});
					},
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(rec){
						var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        rows.DoseUomDR=rec.RowId;
					},
					onChange:function(newValue, oldValue){
						if (!newValue) newValue="";
						if (newValue==""){
							var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
							if (rows) rows.DoseUomDR="";
						}
					},
					onHidePanel:function(){
						var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
						if (!$.isNumeric($(this).combobox('getValue'))) return;
						if (rows) rows.DoseUomDR=$(this).combobox('getValue');
					},
					onLoadSuccess:function(data){
						var editDoseObj=ItemListDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
						if (data.length==0) {
							editDoseObj.target.prop("readonly",true);
						}else{
							editDoseObj.target.prop("readonly",false);
						}
					}
				  }
			  },
			  formatter:function(value, record){
				  return record.DoseUom;
			  }
		}
    ]];
	// 列表Grid
	ItemListDataGrid=$('#tabItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SkinTestConfig&QueryName=GetSkinLinkItem&ActRowid=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemListColumns,
		toolbar:ItemListToolBar,
		onLoadSuccess:function(data){
			editRow = undefined;
		},
		onDblClickRow:function(rowIndex, rowData){
			if (editRow!==undefined){
				$.messager.alert("提示","有正在编辑的行,请选保存或取消编辑!");
				return false;
			}
			editRow=rowIndex;
			ItemListDataGrid.datagrid("beginEdit", rowIndex);
		},
		onBeforeLoad:function(queryParams){
			editRow=undefined;
			$('#tabItemList').datagrid("unselectAll");
		}
	});
};
function LoadItemListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.SkinTestConfig';
	queryParams.QueryName ='GetSkinLinkItem';
	queryParams.ActRowid=ActRowid;
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
	//queryParams.ArgCnt =1;
	var opts = ItemListDataGrid.datagrid("options");
	opts.url = $URL;
	ItemListDataGrid.datagrid('load', queryParams);
};
/*function InitInstr(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'InstrRowID',   
    	textField:'InstrDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SkinTestConfig';
			param.QueryName = 'FindAllInstr';
			param.Arg1 =param2;
			param.ArgCnt =1;
		}  
	});
};
function InitFreq(param1,param2)
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
};*/
function LoadItemData(q,obj1){
	var val = q //$('#Combo_Arcim').combogrid('getValue'); 
    var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ArcItemConfig';
	queryParams.QueryName ='FindAllItem';
	queryParams.Arg1 =val;
	queryParams.ArgCnt =1;
	var opts = obj1.combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	obj1.combogrid("grid").datagrid('load', queryParams);
};