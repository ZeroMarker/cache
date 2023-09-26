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
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
            var ItemCatDr=getValue('List_ItemCat');
			if (ItemCatDr==""){
				$.messager.alert('��ʾ',"����ѡ��ҽ������!");
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
									$.messager.popover({"msg":"ɾ���ɹ�!",type:"success"});
									AppendItemInItemCatDataGridLoad();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
									return false;
								}
							});
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������!");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                editRow = undefined;
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
			    SaveClickHandle();
			}
		}
		];
	Columns=[[
			{ field: 'DHCIAARCICDesc', title: '��������', width: 100
			},
            { field: 'ARCIMRowid', title: '����', width: 100,hidden:true
			}, 
			{ field: 'ARCIMDesc', title:'ҽ������', width: 230,
			   editor:{
                         type:'combogrid',
                         options:{
	                         enterNullValueClear:false,
                             required: true,
                             panelWidth:450,
							 panelHeight:290,
                             idField:'ArcimRowID',
                             textField:'ArcimDesc',
                            value:'',//ȱʡֵ 
                            mode:'remote',
							pagination : true,//�Ƿ��ҳ   
							rownumbers:true,//���   
							collapsible:false,//�Ƿ���۵���   
							fit: true,//�Զ���С   
							pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
							pageList: [10],//��������ÿҳ��¼�������б�  
                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                            columns:[[
                                {field:'ArcimDesc',title:'����',width:400,sortable:true},
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
			{ field: 'Qty', title: '��С����', width: 100,
			  editor : {type : 'text',options : {required:true}}
			},{ field: 'Loc', title: '����', width: 200, resizable: true,
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
			},{ field: 'RecLoc', title: '���տ���', width: 200, resizable: true,
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
			{ field: 'DHCIAInstr', title: '�÷�', width: 100, resizable: true,
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
				$.messager.alert("��ʾ","�����ڱ༭����,��ȡ���༭�򱣴�!");
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
			$.messager.alert('��ʾ',"����ѡ��ҽ������!");
			return false;
		}
		var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
		var editors = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditors', editRow);
		var ARCIMRowid = rows.ARCIMRowid;
		if(typeof(ARCIMRowid)=="undefined"){
			ARCIMRowid=""
		}
		if(ARCIMRowid==""){
			$.messager.alert('��ʾ',"��ѡ��ҽ����");
			return false;
		};
		var Qty = editors[1].target.val();
		if(Qty==""){
			$.messager.alert('��ʾ',"����������");
			return false;
		};
		var r = /^\+?[1-9][0-9]*$/;
		if(!r.test(Qty)){
			$.messager.alert('��ʾ',"����ֻ��Ϊ������!");
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
				$.messager.popover({msg: '����ɹ�!',type:'success'});
				AppendItemInItemCatDataGridLoad();
			}else if(rtn=="-1"){
				$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			}else if(rtn=="-2"){
				$.messager.alert('��ʾ',"������������ѡ����Ч��ҽ����!");
			}else{
		       $.messager.alert('��ʾ',"����ʧ��:"+rtn);
	        }
		});
	 }
}
function AppendItemInItemCatDataGridLoad(){
	var ItemCatDr=getValue('List_ItemCat');
	if (ItemCatDr==""){
		//$.messager.alert('��ʾ',"����ѡ��ҽ������!");
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
		//����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
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