var PrescriptSetDataGrid;
var editRow = undefined;
var RowID="";
var dialog1;
$(function(){
	InitHospList();
	 $("#cmd_OK").click(function(){
		 SaveCatSelect(RowID);
    });
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SplitPrescriptSetting");
	hospComp.jdata.options.onSelect = function(e,t){
		//InitPrescript();
		$('#tabPrescriptSet').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPrescript();
	}
}
function SaveCatSelect(RowID){
	var CatIDStr="";
	var size = $("#List_ItemCat"+ " option").size();
	   if(size>0){
			$.each($("#List_ItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue;
			  else CatIDStr=CatIDStr+"$"+svalue;
			})
	}	
	var value=$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.PrescriptSet", 
		MethodName:"SavePrescriptCat",
		RowID:RowID,
		CatIDStr:CatIDStr,
	},false);   
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});	
		dialog1.dialog( "close" );							
	}
}
function InitPrescript()
{
	var PrescriptTypeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    editRow = undefined;
	                PrescriptSetDataGrid.datagrid("rejectChanges");
	                PrescriptSetDataGrid.datagrid("unselectAll");
					RowID=""
                }
                PrescriptSetDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PrescriptSetDataGrid.datagrid("beginEdit", 0);
                editRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PrescriptSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow = undefined;
				                PrescriptSetDataGrid.datagrid("rejectChanges");
				                PrescriptSetDataGrid.datagrid("unselectAll");
								RowID="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.PrescriptSet", 
								MethodName:"delete",
								Rowid:ID
							},false); 
					        if(value=="0"){
						       PrescriptSetDataGrid.datagrid('load');
       					       PrescriptSetDataGrid.datagrid('unselectAll');
							   RowID="";
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
                PrescriptSetDataGrid.datagrid("rejectChanges");
                PrescriptSetDataGrid.datagrid("unselectAll");
				RowID=""
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=PrescriptSetDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = PrescriptSetDataGrid.datagrid('getEditors', editRow);
				var PSCode = editors[0].target.val();
				if(PSCode==""){
					$.messager.alert('提示',"代码不能为空");
					return false;
				};
				var PSDesc=editors[1].target.val();
				if(PSDesc==""){
					$.messager.alert('提示',"名称不能为空");
					return false;
				};
				var PSType=editors[2].target.combobox('getValue');
				if(!PSType){
					$.messager.alert('提示',"请选择类型!");
					return false;
				};
				var PSCreatUser=session['LOGON.USERID']
				var PSActive="Y"
				var Str=PSCode+"^"+PSDesc+"^"+PSType+"^"+PSCreatUser+"^"+PSActive;
                if(rows.RowID){
	                var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PrescriptSet", 
						MethodName:"Update",
						Rowid:rows.RowID,
						str:Str,
						dataType:"text"
					},false); 
					if(value==0){
					   PTRowid="";
					   PrescriptSetDataGrid.datagrid('load');
					   PrescriptSetDataGrid.datagrid('unselectAll');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return ;
					}
					editRow = undefined;
				}else{
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.PrescriptSet", 
						MethodName:"insert",
						Str:Str,
						HospId:$HUI.combogrid('#_HospList').getValue(),
						dataType:"text"
					},false); 
					if(value==0){
					   PrescriptSetDataGrid.datagrid('load');
					   PrescriptSetDataGrid.datagrid('unselectAll');
					   $.messager.show({title:"提示",msg:"保存成功"});
					}else{
					   $.messager.alert('提示',"保存失败:"+value);
					   return ;
					}
					editRow = undefined;
				}
				
			 }
			}
		},'-',{
			text: '子类设置',
			iconCls: 'icon-edit',
			handler: function() {
				if(RowID ==""){
					$.messager.alert('提示',"请先选择一条记录");
					return false;
				}
				if (!RowID) return false;
				$("#dialog-ItemCatSelect").css("display", ""); 
				dialog1 = $("#dialog-ItemCatSelect" ).dialog({
				  autoOpen: false,
				  height: 400,
				  width: 220,
				  modal: true
				});
				$("#List_ItemCat").empty();
				var objScope=$.cm({ 
					ClassName:"DHCDoc.DHCDocConfig.PrescriptSet", 
					QueryName:"GetAllowItemCatIDList",
					RowID:RowID,
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
		}];
	PrescriptTypeColumns=[[    
                    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'PSCode', title:'代码', width: 10, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
        			{ field: 'PSDesc', title: '名称', width: 20, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					
					{ field: 'PSType', title: '类型', width: 20, align: 'center', sortable: true,resizable: true,
					   editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptSet&QueryName=GetPrescriptSet",
								valueField:'PSType',
								textField:'PSTypeDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								}
							  }
     					  },
						  formatter:function(value, record){
							  return record.PSTypeDesc;
						  }
					},
					{ field: 'PSTypeDesc', title: '限制类型', width: 20, align: 'center', sortable: true,resizable: true,
					  hidden:true
                       
					},
					
    			 ]];
	PrescriptSetDataGrid=$('#tabPrescriptSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptSet&QueryName=GetPrescriptSetList&HospId=",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PrescriptTypeColumns,
		toolbar:PrescriptTypeToolBar,
		onClickRow:function(rowIndex, rowData){
			RowID=rowData.RowID
		},
		onDblClickRow:function(rowIndex, rowData){ 
		    RowID=rowData.RowID 
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PrescriptSetDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   RowID="";
		   $('#tabPrescriptSet').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }
	});
}