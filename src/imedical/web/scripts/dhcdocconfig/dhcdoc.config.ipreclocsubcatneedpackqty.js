var PageLogicObj={
	m_tabLimitItemDataGrid:""
}
var editRow=undefined;
$(function(){
	InitHospList();
	$('#List_RecLoc').click(function() {
		$("#List_MedItemCat").empty(); 
		LoadCatList("List_MedItemCat","IPRecLocSubCatNeedPackQty");
		AtabLimitItemDataGridLoad();
	});
	$('#BSave').click(Save);
	$("#List_RecLoc").css('height',$(window).height()-140);
	$("#List_MedItemCat").css('height',$(window).height()-180);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_IPReclocSubCatNeedPackQty");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
	}
}
function Init(){
	LoadCatList("List_MedItemCat","");
	LoadRecLoc("List_RecLoc","");
	PageLogicObj.m_tabLimitItemDataGrid=InittabLimitItemDataGrid();
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Save()
{
    var LocId=$("#List_RecLoc").find("option:selected").val();
	if (!LocId){
		$.messager.alert("提示", "请选择相应的接收科室!", "error")	
        return false;
	}
	var CatStr="";
    var size = $("#List_MedItemCat"+ " option").size();
    if(size>0){
		$.each($("#List_MedItemCat"+" option:selected"), function(i,own){
          var svalue = $(own).val();
		  if (CatStr=="") CatStr=svalue;
		  else CatStr=CatStr+"^"+svalue;
		})
    }
	var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"SaveConfig1",
		 Node:"IPRecLocSubCatNeedPackQty",
		 Node1:LocId,
		 NodeValue:CatStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value!="0"){
		$.messager.alert("提示", "保存失败!", "error")	
        return false;				
	}else{
		$.messager.show({title:"提示",msg:"保存成功"});	
	}
};
function LoadRecLoc(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		 QueryName:"FindDep",
		 value:param2,
		 desc:"",
		 HospId:$HUI.combogrid('#_HospList').getValue()
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
							
};
function LoadCatList(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var LocId=$("#List_RecLoc").find("option:selected").val();
	if(LocId==undefined){
		LocId="";
	};
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty",
		 QueryName:"FindCatList",
		 LocId:LocId,
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue()
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
							
};
function InittabLimitItemDataGrid(){
	var toolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
	            var LocId=$("#List_RecLoc").find("option:selected").val();
				if (!LocId){
					$.messager.alert("提示", "请选择相应的接收科室!", "error")	
			        return false;
				}
			    editRow = undefined;
                PageLogicObj.m_tabLimitItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                if (editRow != undefined) {
                    return;
                }else{
                    PageLogicObj.m_tabLimitItemDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {
	                        index:""
	                    }
                    });
                    PageLogicObj.m_tabLimitItemDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.m_tabLimitItemDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].index);
                            }
                            var index=ids.join(',')
                            if (index==""){
	                            editRow = undefined;
				                PageLogicObj.m_tabLimitItemDataGrid.datagrid("rejectChanges");
				                PageLogicObj.m_tabLimitItemDataGrid.datagrid("unselectAll");
				                return false;
	                        }
	                        var LocId=$("#List_RecLoc").find("option:selected").val();
	                        $.cm({
								ClassName:"DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty",
								MethodName:"DelOrdNeedPackQty",
								index:index,
								LocId:LocId,
								dataType:"text"
							},function(rtn){
								if (rtn=="0"){
									$.messager.popover({"msg":"删除成功!",type:"success"});
									AtabLimitItemDataGridLoad();
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
                PageLogicObj.m_tabLimitItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			   if (editRow != undefined) {
				    var LocId=$("#List_RecLoc").find("option:selected").val();
					if (!LocId){
						$.messager.alert("提示", "请选择相应的接收科室!", "error")	
				        return false;
					}
					var rows=PageLogicObj.m_tabLimitItemDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = PageLogicObj.m_tabLimitItemDataGrid.datagrid('getEditors', editRow);
					var ARCIMRowid = rows.ARCIMRowid;
					if(typeof(ARCIMRowid)=="undefined"){
						ARCIMRowid=""
					}
					if(ARCIMRowid==""){
						$.messager.alert('提示',"请选择医嘱项");
						return false;
					};
					var rowid= rows.index;
					var rtn=$.m({
						 ClassName:"DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty",
						 MethodName:"SaveOrdNeedPackQtyLimit",
						 Node:"IPRecLocArcItemNeedPackQty",
						 LocId:LocId,
						 ARCIMRowid:ARCIMRowid,
						 rowid:rowid
					},false);
					if (rtn=="0"){
						$.messager.popover({msg: '保存成功!',type:'success'});
						AtabLimitItemDataGridLoad();
					}else if(rtn=="-1"){
						$.messager.alert("提示","保存失败!记录重复!");
					}else{
				       $.messager.alert('提示',"保存失败:"+rtn);
			        }
			   }
			}
		}
		];
	Columns=[[
            { field: 'ARCIMRowid', title: '医嘱项ID', width: 100
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
					delay: 500,  
                    url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                    columns:[[
                        {field:'ArcimDesc',title:'名称',width:400,sortable:true},
	                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
	                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                     ]],
                     onSelect: function (rowIndex, rowData){
							var rows=PageLogicObj.m_tabLimitItemDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
							rows.ARCIMRowid=rowData.ArcimRowID
					 },
                     onClickRow : function(rowIndex, rowData) {
            			var rows=PageLogicObj.m_tabLimitItemDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
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
			}
		 ]];
	var tabLimitItemDataGrid=$("#tabLimitItem").datagrid({
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
		idField:'index',
		columns :Columns,
		toolbar:toolBar,
		onDblClickRow:function(rowIndex,rowData){
			if (editRow!= undefined){
				$.messager.alert("提示","有正在编辑的行,请取消编辑或保存!");
				return false;
			}
			PageLogicObj.m_tabLimitItemDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
		},
		onLoadSuccess:function(data){
			editRow = undefined;
			tabLimitItemDataGrid.datagrid("unselectAll");
		}
	});
	tabLimitItemDataGrid.datagrid('loadData',{"total":0,"rows":[]});
	return tabLimitItemDataGrid;
}
function AtabLimitItemDataGridLoad(){
	if (editRow!= undefined){
		PageLogicObj.m_tabLimitItemDataGrid.datagrid("rejectChanges");
	}
	var LocId=$("#List_RecLoc").find("option:selected").val();
	if (!LocId){
		LocId="";
	}
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.IPRecLocSubCatNeedPackQty",
	    QueryName : "FindOrdNeedPackQtyList",
	    LocId:LocId,
	    value:"IPRecLocArcItemNeedPackQty",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_tabLimitItemDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		editRow = undefined;
		PageLogicObj.m_tabLimitItemDataGrid.datagrid("uncheckAll").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}