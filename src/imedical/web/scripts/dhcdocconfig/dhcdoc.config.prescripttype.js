var editRow = undefined;
var PrescriptTypeDataGrid;
var PTRowid="";
var dialog1;
$(function(){ 
	InitHospList();
    $("#cmd_OK").click(function(){
		 SaveCatSelect(PTRowid);
    });
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_PrescriptType");
	hospComp.jdata.options.onSelect = function(e,t){
		PTRowid="";
		$('#tabPrescriptType').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPrescriptType();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function SaveCatSelect(PTRowid)
{
	var CatIDStr="";
	var size = $("#List_ItemCat"+ " option").size();
	   if(size>0){
			$.each($("#List_ItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue;
			  else CatIDStr=CatIDStr+"^"+svalue;
			})
	}	
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig1",
		Node:"PrescriptItemCat",
		Node1:PTRowid,
		NodeValue:CatIDStr,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);   
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});	
		dialog1.dialog( "close" );							
	}
};
function InitPrescriptType()
{
	var PrescriptTypeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    return;
                }else{
                    PrescriptTypeDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    PrescriptTypeDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PrescriptTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].PTRowid);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
				                PrescriptTypeDataGrid.datagrid("rejectChanges");
				                PrescriptTypeDataGrid.datagrid("unselectAll");
								PTRowid="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.PrescriptType", 
								MethodName:"delete",
								Rowid:ID
							},false); 
					        if(value=="0"){
						       PrescriptTypeDataGrid.datagrid('load');
       					       PrescriptTypeDataGrid.datagrid('unselectAll');
							    PTRowid="";
       					       $.messager.show({title:"提示",msg:"删除成功"});
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
                PrescriptTypeDataGrid.datagrid("rejectChanges");
                PrescriptTypeDataGrid.datagrid("unselectAll");
				PTRowid=""
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=PrescriptTypeDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = PrescriptTypeDataGrid.datagrid('getEditors', editRow);
				var PTCode = editors[0].target.val();
				if(PTCode==""){
					$.messager.alert('提示',"代码不能为空");
					return false;
				};
				var PTDescription=editors[1].target.val();
				if(PTDescription==""){
					$.messager.alert('提示',"名称不能为空");
					return false;
				};
				var PTAllowFlag=""
				var PTWarnFlag=""
				var PTLimitSum=editors[2].target.val();
				var PTLimitCount=""
				var PTLimitQty=editors[3].target.val();
				var PTLimitType=editors[4].target.combobox('getValue');
				if(!PTLimitType){
					$.messager.alert('提示',"请选择限制类型!");
					return false;
				};
				var PTBillType=editors[5].target.combobox('getValue');
				if(!PTBillType){
					$.messager.alert('提示',"请选择收费类型!");
					return false;
				};
				var PTIsSpecDis=editors[6].target.is(':checked');
				if(PTIsSpecDis) PTIsSpecDis="1";
				else  PTIsSpecDis="0";
				//var rows = PrescriptTypeDataGrid.datagrid("getRows");
				var Str=PTCode+"^"+PTDescription+"^"+PTAllowFlag+"^"+PTWarnFlag+"^"+PTLimitSum+"^"+PTLimitCount+"^"+PTLimitQty+"^"+PTLimitType+"^"+PTBillType+"^"+PTIsSpecDis+"^"+"";
                if(rows.PTRowid){
	                var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PrescriptType", 
						MethodName:"Update",
						Rowid:rows.PTRowid,
						str:Str
					},false); 
					if(value==0){
					   PTRowid="";
					   PrescriptTypeDataGrid.datagrid('unselectAll').datagrid('load');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else if(value=="repeat"){
						$.messager.alert('提示',"保存失败!代码或名称重复!");
						return false;
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return false;
					}
					editRow = undefined;
				}else{
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PrescriptType", 
						MethodName:"insert",
						Str:Str,
						HospId:$HUI.combogrid('#_HospList').getValue()
					},false); 
					if(value==0){
					   PrescriptTypeDataGrid.datagrid('load');
					   PrescriptTypeDataGrid.datagrid('unselectAll');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else if(value=="repeat"){
						$.messager.alert('提示',"保存失败!代码或名称重复!");
						return false;
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return false;
					}
					editRow = undefined;
				}
				
			 }
			}
		},'-',{
			text: '子类定义',
			iconCls: 'icon-edit',
			handler: function() {
				if(PTRowid==""){
					$.messager.alert('提示',"请先选择一条记录");
					return false;
				}
				var rows = PrescriptTypeDataGrid.datagrid("getSelections");
                if (rows.length <= 0) {
	               $.messager.alert('提示',"请先选择一条记录");
					return false; 
	                }
				$("#dialog-ItemCatSelect").css("display", ""); 
				dialog1 = $("#dialog-ItemCatSelect" ).dialog({
				  autoOpen: false,
				  height: 400,
				  width: 220,
				  modal: true
				});
				$("#List_ItemCat").empty();
				var objScope=$.cm({ 
					ClassName:"DHCDoc.DHCDocConfig.PrescriptType", 
					QueryName:"GetAllowItemCatIDList",
					PTRowid:PTRowid,
					value:"PrescriptItemCat",
					HospId:$HUI.combogrid('#_HospList').getValue(),
					rows:99999
				},false);
				$("#List_ItemCat").find("option").remove();
			   var vlist = ""; 
			   var selectlist="";
			   jQuery.each(objScope.rows, function(i, n) { 
						selectlist=selectlist+"^"+n.selected
						vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
			   });
			   $("#List_ItemCat").append(vlist); 
			   for (var j=1;j<=selectlist.split("^").length;j++){
						if(selectlist.split("^")[j]=="true"){
							$("#List_ItemCat").get(0).options[j-1].selected = true;
						}
				}
	          dialog1.dialog( "open" );
			}
		}/*,{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
		         var SelectedRow = PrescriptTypeDataGrid.datagrid('getSelected');
				if (!SelectedRow){
				$.messager.alert("提示","请选择需要翻译的行!","info");
				return false;
				}
				CreatTranLate("User.DHCPrescriptType","PTDescription",SelectedRow["PTDescription"])
		       }
     }*/
	 ];
	PrescriptTypeColumns=[[    
                    { field: 'PTRowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'PTCode', title:'代码', width: 10, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'PTDescription', title: '名称', width: 20, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					/*{ field: 'PTAllowFlag', title: '处方范围', width: 20, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}
					},*/
					/*{ field: 'PTWarnFlag', title: '提示范围', width: 20, align: 'center', sortable: true, resizable: true,
					   editor : {type : 'text',options : {}}
					},*/
					{ field: 'PTLimitSum', title: '限制金额', width: 20, align: 'center', sortable: true, resizable: true,
					  editor : {type : 'text',options : {}}
					},
					/*{ field: 'PTLimitCount', title: '限制数量', width: 20, align: 'center', sortable: true, resizable: true,  
                        editor : {type : 'text',options : {}}
					},*/
					{ field: 'PTLimitQty', title: '限制页面未审金额', width: 20, align: 'center', sortable: true,       resizable: true,  
                        editor : {type : 'text',options : {}}
					},
					{ field: 'PTLimitTypeDesc', title: '限制类型', width: 20, align: 'center', sortable: true,resizable: true,
					  hidden:true
                       
					},
					{ field: 'PTLimitType', title: '限制类型', width: 20, align: 'center', sortable: true,resizable: true,
					   editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'PTLimitType',
								textField:'PTLimitTypeDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								}
							  }
     					  },
						  formatter:function(value, record){
							  return record.PTLimitTypeDesc;
						  }
					},
					{ field: 'PTBillTypeDesc', title: '收费类别', width: 20, align: 'center', sortable: true,resizable: true, 
                      hidden:true			
					  
					},
					{ field: 'PTBillType', title: '收费类别', width: 20, align: 'center', sortable: true,resizable: true,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value="+"&rows=9999",
								valueField:'BillTypeRowid',
								textField:'BillTypeDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
									param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					  },
						  formatter:function(BillTypeRowid,record){
							  return record.PTBillTypeDesc;
						  }
					},
					{ field: 'PTIsSpecDis', title: '录入不还原到默认处方', width: 20, align: 'center', sortable: true, 
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					}
					
    			 ]];
	PrescriptTypeDataGrid=$('#tabPrescriptType').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetPrescriptTypeList",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"PTRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PrescriptTypeColumns,
		toolbar:PrescriptTypeToolBar,
		onClickRow:function(rowIndex, rowData){
			PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		    PTRowid=rowData.PTRowid 
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PrescriptTypeDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   $('#tabPrescriptType').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }
	});
}
