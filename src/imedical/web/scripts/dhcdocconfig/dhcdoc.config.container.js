var ContainerListDataGrid;
var ItemListDataGrid;
var ConCode="";
var editRow = undefined;
var PAADMTypeStr=[{"code":"I","desc":"住院"},{"code":"O","desc":"门诊"},{"code":"E","desc":"急诊"}];

$(function(){ 
  InitBloodFlag();
  InitContainerList();
  InitItemList();
  $("#BSave").click(SaveBloodFlag);
});
function SaveBloodFlag()
{
	if(ConCode==""){
		$.messager.alert('提示',"请先选择检验容器");
		return false;
	};
	var BloodFlag=$("#Combo_BloodFlag").combobox("getValue");
	var value=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.Container",
		 MethodName:"updateContainerBloodFlag",
		 rowid:ConCode,
		 BloodFlag:BloodFlag
	},false);
	if(value=="0"){
		ContainerListDataGrid.datagrid('load');
   		ContainerListDataGrid.datagrid('unselectAll');
	}else{
		$.messager.alert('提示',"保存失败:"+value);
	}
};
function InitBloodFlag()
{
	$("#Combo_BloodFlag").combobox({      
    	valueField:'BloodFlag',   
    	textField:'BloodFlagDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.Container';
			param.QueryName = 'GetBloodFlagList';
			param.Arg1 =ConCode;
			param.ArgCnt =1;
		}  
	});
};
function InitContainerList()
{
	ContainerListColumns=[[    
                    { field: 'ConCode', title: 'ID', width: 1,hidden:true},
        			{ field: 'ConDesc', title: '名称', width: 80},
					{ field: 'BloodFlag', title: '名称', width: 50,hidden:true},
					{ field: 'BloodFlagDesc', title: '取血类型', width: 50}
    			 ]];
	ContainerListDataGrid=$('#tabContainerList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.Container&QueryName=GetContainerList",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ConCode",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ContainerListColumns,
		onClickRow:function(rowIndex, rowData){
			ConCode=rowData.ConCode
			$("#Combo_BloodFlag").empty();
			InitBloodFlag();
			LoadItemListDataGrid();
		}
	});
};
function LoadContainerListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Container';
	queryParams.QueryName ='GetContainerList';
	queryParams.ArgCnt =0;
	var opts = ContainerListDataGrid.datagrid("options");
	opts.url = $URL;
	ContainerListDataGrid.datagrid('load', queryParams);
};
function InitItemList()
{
	var ToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
				editRow = undefined;
				ItemListDataGrid.datagrid("rejectChanges");
				ItemListDataGrid.datagrid('unselectAll');
			    if(ConCode==""){
					$.messager.alert('提示',"请先选择检验容器");
					return false;
				}
                if (editRow != undefined) {
                    return;
                }else{
                    ItemListDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    ItemListDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
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
                                ids.push(rows[i].rowid);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
				                ItemListDataGrid.datagrid("rejectChanges");
				                ItemListDataGrid.datagrid("unselectAll");
				                return;
		                    }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.Container",
								 MethodName:"Delete",
								 rowid:ID
							},false);
					        if(value=="0"){
						       ItemListDataGrid.datagrid('load');
       					       ItemListDataGrid.datagrid('unselectAll');
       					      $.messager.popover({msg: '删除成功!',type:'success'});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
							   return false;
					        }
					        editRow = undefined;
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
                editRow = undefined;
                ItemListDataGrid.datagrid("rejectChanges");
                ItemListDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (editRow == undefined){
					$.messager.alert('提示',"没有需要保存的数据!");
					return false;
				}
				var rows = ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var rowid=rows["rowid"];
				if (!rowid) rowid="";
				var editors = ItemListDataGrid.datagrid('getEditors', editRow);
				var arcrowid = rows['SPECIARCIMDR'] //editors[0].target.combobox('getValue');
				var LocDr=rows['LocDr'];
				var AdmType=editors[2].target.combobox("getValue");			
				var RepelOther =  editors[3].target.is(':checked');
				if (RepelOther) RepelOther="Y";
				else RepelOther="N";
				var qty=$.trim(editors[4].target.val()," ","");
				//qty=Number(qty);
				if (!arcrowid){
					$.messager.alert('提示',"请选择医嘱项目");
					return false;
				}
			    if (qty==""){
					$.messager.alert('提示',"请填写数量!");
					return false;
				}
				var r = /^\+?[1-9][0-9]*$/;
				if(!r.test(qty)){
					$.messager.alert('提示',"数量只能为正整数!");
					return false;
				}
				var value=$.m({
					 ClassName:"DHCDoc.DHCDocConfig.Container",
					 MethodName:"Save",
					 code:ConCode,
					 arcrowid:arcrowid,
					 qty:qty,
					 UserDeptDr:LocDr,
					 AdmType:AdmType,
					 RepelOther:RepelOther,
					 rowid:rowid
				},false);
		        if(value=="0"){
			       ItemListDataGrid.datagrid('load');
			       ItemListDataGrid.datagrid('unselectAll');
			       $.messager.popover({msg: '保存成功!',type:'success'});
		        }else if(value=="-1"){
					$.messager.alert('提示',"该记录已存在");
					return false;
				}else if(value=="-2"){
					$.messager.alert('提示',"请在下拉框中选择有效的医嘱项!");
					return false;
				}else{
			       $.messager.alert('提示',"保存失败:"+value);
				   return false;
		        }
		        editRow = undefined;
			}
		}];
	ItemListColumns=[[    
                    { field: 'SPECIARCIMDR',hidden:true},
					{ field: 'rowid',hidden:true},
        			{ field: 'SPECIARCIMDesc', title: '名称', width: 120,
        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
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
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"]});
						             },
						             onChange:function(newValue, oldValue){
							             if (newValue=="") {
								             var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    	 rows.SPECIARCIMDR="";
								         }
							         },
							         onSelect: function (rowIndex, rowData){
										var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
										rows.SPECIARCIMDR=rowData.ArcimRowID
									},
									onClickRow: function (rowIndex, rowData){
										var rows=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
										rows.SPECIARCIMDR=rowData.ArcimRowID
									}
                        		}
		        			  }
					},
					{ field: 'UserDeptDesc', title: '开单科室', width: 120,
						editor :{
							type:'combobox', 
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindLoc&Type=O^E^I&rows=99999",
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onSelect:function(record){
									var ArcimSelRow=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (editRow!=undefined){
										var ArcimSelRow=ItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected"); 
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
										   
					},
					{ field: 'LocDr', title: '开单科室', hidden: true},
					{
                      field : 'AdmType',title : '就诊类型',width: 80,
                           editor : {
                                type:'combobox',
						        options:{
							      valueField:'code',
							      textField:'desc',
							      data:PAADMTypeStr
						        }
                            }
                    },
					{field : 'RepelOther',title : '启用绑定优先级',width: 100,
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
                     },
					{ field: 'SPECIQty', title: '数量', width: 50,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	ItemListDataGrid=$('#tabItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.Container&QueryName=GetItemByConCode&ConCode="+ConCode,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"rowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemListColumns,
		toolbar :ToolBar,
		onDblClickRow:function(rowIndex, rowData){
			if ((editRow!=undefined)&&(editRow1!=rowIndex)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow=rowIndex
			ItemListDataGrid.datagrid("beginEdit", rowIndex);
		},
		onLoadSuccess:function(data){
			editRow=undefined;
			ItemListDataGrid.datagrid("unselectAll");
		}
	});
	//LoadItemListDataGrid();
};
function LoadItemListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Container';
	queryParams.QueryName ='GetItemByConCode';
	queryParams.ConCode =ConCode;
	queryParams.ArgCnt =1;
	var opts = ItemListDataGrid.datagrid("options");
	opts.url = $URL;
	editRow = undefined;
	ItemListDataGrid.datagrid("rejectChanges");
    ItemListDataGrid.datagrid("unselectAll");
	ItemListDataGrid.datagrid('load', queryParams);
};