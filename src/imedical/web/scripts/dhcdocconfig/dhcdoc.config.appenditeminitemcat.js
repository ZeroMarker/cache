var PageLogicObj={
	m_AppendItemInItemCatDataGrid:""
}
var editRow=undefined;
$(function(){
	InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_ItmSubCatAdd");
	hospComp.jdata.options.onSelect = function(e,t){
		PageHandle();
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('loadData',{"total":0,"rows":[]});
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		PageHandle();
	}
}
function Init(){
	PageLogicObj.m_AppendItemInItemCatDataGrid=InitAppendItemInItemCatDataGrid();
}
function PageHandle(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.SubCatContral",
	    QueryName : "FindCatList",
	    value:"AppendItemCat",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#List_ItemCat", {
				valueField: 'ARCICRowId',
				textField: 'ARCICDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ARCICDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(row){
					AppendItemInItemCatDataGridLoad();
				},
				onUnselect:function(row){
					AppendItemInItemCatDataGridLoad();
				},
		 });
	});
}
function InitAppendItemInItemCatDataGrid(){
	var toolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            var ItemCatDr=getValue('List_ItemCat');
			if (ItemCatDr==""){
				$.messager.alert('提示',"请先选择医嘱子类!");
				return false;
			}
			    editRow = undefined;
				RowBillType="";
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
                if (editRow != undefined) {
                    return;
                }else{
                    PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DHCICARowid);
                            }
                            var DHCICARowid=ids.join(',')
                            if (DHCICARowid==""){
	                            editRow = undefined;
								RowBillType="";
				                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
				                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
				                return false;
	                        }
	                        $.cm({
								ClassName:"DHCDoc.DHCDocConfig.AppendItemInItemCat",
								MethodName:"delete",
								DHCICARowid:DHCICARowid
							},function(rtn){
								if (rtn=="0"){
									$.messager.popover({"msg":"删除成功!",type:"success"});
									AppendItemInItemCatDataGridLoad();
								}else{
									$.messager.alert("提示","删除失败!"+rtn);
									return false;
								}
							});
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行!");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                editRow = undefined;
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			    SaveClickHandle();
			}
		}
		];
	Columns=[[
			{ field: 'DHCIAARCICDesc', title: '子类描述', width: 100
			},
            { field: 'ARCIMRowid', title: '名称', width: 100,hidden:true
			}, 
			{ field: 'ARCIMDesc', title:'医嘱名称', width: 230,
			   editor:{
                         type:'combogrid',
                         options:{
	                         enterNullValueClear:false,
                             required: true,
                             panelWidth:450,
							 panelHeight:290,
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
                             onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
							 },
                             onClickRow : function(rowIndex, rowData) {
                    			var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                if(rows) rows.ARCIMRowid=rowData.ArcimRowID
			                 },
							onLoadSuccess:function(data){
								$(this).next('span').find('input').focus();
							},
							onBeforeLoad:function(param){
								if (param['q']) {
									var desc=param['q'];
								}else{
									//return false;
								}
								param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
							}
                		}
        			  }
			  
			},
			{ field: 'Qty', title: '最小数量', width: 100,
			  editor : {type : 'text',options : {required:true}}
			},{ field: 'Loc', title: '科室', width: 200, resizable: true,
			  editor : {
				   type : 'combobox',options : {
					valueField:'LocRowID',   
					textField:'LocDesc',
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocExt&QueryName=GetLocExtConfigNew&LocId=&rows=99999",
					onSelect:function(record) {
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                    if(rows)rows.LocId=record.LocRowID
					},
					onBeforeLoad:function(param){
			            if (param['q']) {
							var desc=param['q'];
						}else{
							var desc="";
						}
						param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					},
					loadFilter:function(data){
					    return data['rows'];
					},
					onChange:function(NewValue,OldValue) {
						if (NewValue==""){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                    	if(rows)rows.LocId="";
						}
					},filter: function(q, row){
						var opts = $(this).combobox('options');
						var str=q.toUpperCase()
						var LocDesc=row[opts.textField]
						var LocAlias=row["LocAlias"]
						if(LocDesc.toUpperCase().indexOf(str)>=0) return true
						if(LocAlias.toUpperCase().indexOf(str)>=0) return true
						return false;
					}		
				  }
			  }
			},{ field: 'LocId', title: '', width: 1,hidden:true
			},{ field: 'RecLoc', title: '接收科室', width: 200, resizable: true,
			  editor : {type : 'combobox',options : {
				valueField:'LocRowID',   
				textField:'LocDesc',
				url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocExt&QueryName=GetLocExtConfigNew&LocId=&rows=99999",
				onChange:function(NewValue,OldValue) {
					if (NewValue==""){
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                    	if(rows)rows.RecLocId="";
					}
				},onSelect:function(record) {
					var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                    if(rows)rows.RecLocId=record.LocRowID
					
				},loadFilter:function(data){
					    return data['rows'];
				},filter: function(q, row){
					var opts = $(this).combobox('options');
					var str=q.toUpperCase()
					var LocDesc=row[opts.textField]
					var LocAlias=row["LocAlias"]
					if(LocDesc.toUpperCase().indexOf(str)>=0) return true
					if(LocAlias.toUpperCase().indexOf(str)>=0) return true
					return false;
				}	
			  }
			  }
			},{ field: 'RecLocId', title: '', width: 1,hidden:true
			},
			{ field: 'RowIndex', title: '', width: 1,hidden:true
			},
			{ field: 'DHCIAInstr', title: '用法', width: 100, resizable: true,
			  editor : {
				  type : 'combobox',
				  options : {
					mode:'remote',
					valueField:'InstrRowID',   
					textField:'InstrDesc',
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindInstr&InstrAlias=",
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}else{
							var desc="";
						}
						param = $.extend(param,{InstrAlias:desc});
					},onSelect:function(record) {
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        if(rows)rows.DHCIAInstrId=record.InstrRowID
						
					},onChange:function(newValue, oldValue) {
						if (newValue==""){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        	if(rows)rows.DHCIAInstrId="";
						}
					},
					loadFilter: function(data){
						return data['rows'];
					}	
				  }
			  }
			},
			{ field: 'DHCIAInstrId', title: '', width: 1,hidden:true}
			
		 ]];
	var AppendItemInItemCatDataGrid=$("#tabAppendItemInItemCat").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'DHCICARowid',
		columns :Columns,
		toolbar:toolBar,
		onDblClickRow:function(rowIndex,rowData){
			if (editRow!= undefined){
				$.messager.alert("提示","有正在编辑的行,请取消编辑或保存!");
				return false;
			}
			PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
		},
		onLoadSuccess:function(data){
			editRow = undefined;
			AppendItemInItemCatDataGrid.datagrid("unselectAll");
		}
	});
	AppendItemInItemCatDataGrid.datagrid('loadData',{"total":0,"rows":[]});
	return AppendItemInItemCatDataGrid;
}
function SaveClickHandle(){
	if (editRow != undefined) {
		var ItemSubCat=getValue('List_ItemCat');
		if (ItemSubCat==""){
			$.messager.alert('提示',"请先选择医嘱子类!");
			return false;
		}
		var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
		var editors = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditors', editRow);
		var ARCIMRowid = rows.ARCIMRowid;
		if(typeof(ARCIMRowid)=="undefined"){
			ARCIMRowid=""
		}
		if(ARCIMRowid==""){
			$.messager.alert('提示',"请选择医嘱项");
			return false;
		};
		var Qty = editors[1].target.val();
		if(Qty==""){
			$.messager.alert('提示',"请输入数量");
			return false;
		};
		var r = /^\+?[1-9][0-9]*$/;
		if(!r.test(Qty)){
			$.messager.alert('提示',"数量只能为正整数!");
			return false;
		}
		var LocId=rows.LocId;
		var RecLocId=rows.RecLocId;
		var DHCIAInstrId=rows.DHCIAInstrId;
		if(typeof(LocId)=="undefined"){
			LocId=""
		}
		if(typeof(RecLocId)=="undefined"){
			RecLocId=""
		}
		if(typeof(DHCIAInstrId)=="undefined"){
			DHCIAInstrId=""
		}
		var DHCICARowid=rows.DHCICARowid;
		if(typeof(DHCICARowid)=="undefined"){
			DHCICARowid=""
		}
		$.cm({
			ClassName:"DHCDoc.DHCDocConfig.AppendItemInItemCat",
			MethodName:"save",
			DHCICARowid:DHCICARowid,
			ItemSubCat:getValue('List_ItemCat'),
			ARCIMRowid:ARCIMRowid, Qty:Qty, LocId:LocId, RecLocId:RecLocId,DHCIAInstrId:DHCIAInstrId,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},function(rtn){
			if (rtn=="0"){
				$.messager.popover({msg: '保存成功!',type:'success'});
				AppendItemInItemCatDataGridLoad();
			}else if(rtn=="-1"){
				$.messager.alert("提示","保存失败!记录重复!");
			}else if(rtn=="-2"){
				$.messager.alert('提示',"请在下拉框中选择有效的医嘱项!");
			}else{
		       $.messager.alert('提示',"保存失败:"+rtn);
	        }
		});
	 }
}
function AppendItemInItemCatDataGridLoad(){
	var ItemCatDr=getValue('List_ItemCat');
	if (ItemCatDr==""){
		//$.messager.alert('提示',"请先选择医嘱子类!");
		//return false;
	}
	if (editRow!= undefined){
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
	}
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.AppendItemInItemCat",
	    QueryName : "GetAppendItemInItemCat",
	    ItemSubCat:ItemCatDr,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		editRow = undefined;
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("uncheckAll").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}