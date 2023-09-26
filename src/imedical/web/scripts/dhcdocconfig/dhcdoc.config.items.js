var ItemListDataGrid;
var AppendItemListDataGrid;
var editRow=undefined;
$(function(){ 
   InitHospList();
   $("#BFind").click(FindClickHandle);
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_ItmAdd");
	hospComp.jdata.options.onSelect = function(e,t){
		InitItemCategory("Combo_ItemCategory"); 
	    InitOrderCategory("Combo_OrderCategory");
		LoadAppendItemListDataGrid("");
		FindClickHandle();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitItemCategory("Combo_ItemCategory"); 
	    InitOrderCategory("Combo_OrderCategory");
	    InitItemListDataGrid();
	    InitAppendItemListDataGrid();
	}
}
function InitItemListDataGrid()
{
	ItemListColumns=[[    
                    { field: 'ARCIMRowID', title: 'ID', width: 1,hidden:true}, 
					{ field: 'ARCIMType', title:'类型', width: 10},
        			{ field: 'ORCATDesc', title: '大类', width: 10},
					{ field: 'ARCICDesc', title: '子类', width: 20},
					{ field: 'ARCIMDesc', title: '项目名称', width: 20}
    			 ]];
	ItemListDataGrid=$('#tabItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : $URL+"?ClassName=DHCDoc.DHCDocConfig.Items&QueryName=GetItemList&Item=&ARCICRowId=",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"ARCIMRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemListColumns,
		onClickRow:function(rowIndex, rowData){
			LoadAppendItemListDataGrid(rowData.ARCIMRowID)
			//LoadAliasList("List_ItemAlias",rowData.ARCIMRowID);
		},
		onBeforeLoad:function(param){
			$(this).datagrid("unselectAll");
		}
	});
	ItemListDataGrid.datagrid('loadData', { total: 0, rows: [] });  
};
function LoadItemListDataGrid(param1,param2,param3)
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Items';
	queryParams.QueryName ='GetItemList';
	queryParams.Item =param1;
	queryParams.ARCICRowId =param2;
	queryParams.ORCATRowId =param3;
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue()
	//queryParams.ArgCnt =2;
	var opts = ItemListDataGrid.datagrid("options");
	opts.url = $URL;
	ItemListDataGrid.datagrid('load', queryParams);
};
function InitAppendItemListDataGrid()
{
	var AppendItemListBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
			    
			    var rows = ItemListDataGrid.datagrid("getSelections");
                if (rows.length <= 0) {
					$.messager.alert("提示", "请先选择一条主医嘱", "error");
					return false;
				}
				 editRow = undefined;
                AppendItemListDataGrid.datagrid("rejectChanges");
                AppendItemListDataGrid.datagrid("unselectAll");
                if (editRow != undefined) {
                    AppendItemListDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    AppendItemListDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    AppendItemListDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = AppendItemListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DHCIARowid);
                            }
                            var DHCIARowid=ids.join(',');
                            if (DHCIARowid==""){
	                            editRow = undefined;
				                AppendItemListDataGrid.datagrid("rejectChanges");
				                AppendItemListDataGrid.datagrid("unselectAll");
	                            return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.Items", 
								MethodName:"deleteAppendItem",
								Rowid:DHCIARowid
							},false);
							if(value=="0"){
								AppendItemListDataGrid.datagrid('load');
	           					AppendItemListDataGrid.datagrid('unselectAll');
	           					$.messager.show({title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
							}
							editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
			  if(editRow==undefined){
				  return false;
			  }
              var rows = ItemListDataGrid.datagrid("getSelections");
			  
               if (rows.length > 0)
               { 
                   var ids = [];
                   for (var i = 0; i < rows.length; i++) {
						ids.push(rows[i].ARCIMRowID);
				   }
				  var ARCIMRowID=ids.join(',')
                  var rows1=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                  if(rows1.DHCIARowid){
	                  var DHCIARowid=rows1.DHCIARowid
	              }else{
		              var DHCIARowid=""
		          }
		          var editors = AppendItemListDataGrid.datagrid('getEditors', editRow);
		          //var AddARCIMRowID =  editors[0].target.combobox('getValue');
		          var AddARCIMRowID=rows1.AddItmDR
		          if ((AddARCIMRowID=="")||(AddARCIMRowID==undefined)){
						$.messager.alert('提示',"请选择需要添加的医嘱项目!");
						return false;
				  }
				   var OrdQty =  editors[1].target.val();
				   if(OrdQty==""){
						$.messager.alert('提示',"请填写数量!");
						return false;
					}
					var r = /^\+?[1-9][0-9]*$/;
					if(!r.test(OrdQty)){
						$.messager.alert('提示',"数量只能为正整数!");
						return false;
					}
					///取科室和接收科室
					var LocId=rows1.DHCIALocId;
					var RecLocId=rows1.DHCIARecLocId;
					var DHCIAInstrId=rows1.DHCIAInstrId;
					if(typeof(LocId)=="undefined"){
						LocId=""
					}
					if(typeof(RecLocId)=="undefined"){
						RecLocId=""
					}
					if(typeof(DHCIAInstrId)=="undefined"){
						DHCIAInstrId=""
					}
				 	var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.Items", 
						MethodName:"saveAppendItem",
						Rowid:DHCIARowid,
						ARCIMRowID:ARCIMRowID,
						AddARCIMRowID:AddARCIMRowID,
						OrdQty:OrdQty,
						LocId:LocId,
						RecLocId:RecLocId,
						DHCIAInstrId:DHCIAInstrId,
						HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					if(value=="0"){
						AppendItemListDataGrid.datagrid("endEdit", editRow);
						editRow = undefined;
						AppendItemListDataGrid.datagrid('unselectAll').datagrid('load');
						$.messager.show({title:"提示",msg:"保存成功"});           					
					}else if(value=="-1"){
						$.messager.alert('提示',"已存在此记录");
						return false;
					}else if(value=="-2"){
						$.messager.alert('提示',"请选择有效的医嘱项目");
						return false;
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}
					editRow = undefined;
             }else{
	            $.messager.alert("提示", "请先选择一条主医嘱"); 
	         }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow = undefined;
                AppendItemListDataGrid.datagrid("rejectChanges");
                AppendItemListDataGrid.datagrid("unselectAll");
            }
        }];
	AppendItemListColumns=[[    
                    { field: 'DHCIARowid', title: 'ID', width: 1,hidden:true
					}, 
					{ field: 'AddItmDR', title:'医嘱项名称', width: 10,hidden:true
					},
        			{ field: 'AddItmDesc', title: '名称', width: 100,
        			   editor:{
		                         type:'combogrid',
		                         options:{
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
									 onSelect : function(rowIndex, rowData) {
											  var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                              if(rows)rows.AddItmDR=rowData.ArcimRowID
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
					{ field: 'DHCIAQty', title: '数量', width: 20,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'DHCIALoc', title: '科室', width: 50,
					  editor : {type : 'combobox',options : {
						valueField:'LocRowID',   
						textField:'LocDesc',
						url:"./dhcdoc.cure.query.combo.easyui.csp",
						onBeforeLoad:function(param){
							param.ClassName = 'DHCDoc.DHCDocConfig.LocExt';
							param.QueryName = 'GetLocExtConfigNew';
							param.Arg1 ="";
							param.Arg2=$HUI.combogrid('#_HospList').getValue();
							param.ArgCnt =2;
						},onChange:function(newValue, oldValue) {
							if (newValue==""){
								var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                        	if(rows)rows.DHCIALocId="";
							}
						},onSelect:function(record) {
							var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                        if(rows)rows.DHCIALocId=record.LocRowID
						},filter: function(q, row){
							var opts = $(this).combobox('options');
							var str=q.toUpperCase();
							var LocDesc=row[opts.textField]
							var LocAlias=row["LocAlias"]
							if(LocDesc.toUpperCase().indexOf(str)>=0) return true
							if(LocAlias.toUpperCase().indexOf(str)>=0) return true
							return false;
						}	
					  }
					  }
					},{ field: 'DHCIALocId', title: '', width: 1,hidden:true
					},{ field: 'DHCIARecLoc', title: '接收科室', width: 50, resizable: true,
					  editor : {type : 'combobox',options : {
						valueField:'LocRowID',   
						textField:'LocDesc',
						url:"./dhcdoc.cure.query.combo.easyui.csp",
						onBeforeLoad:function(param){
							param.ClassName = 'DHCDoc.DHCDocConfig.LocExt';
							param.QueryName = 'GetLocExtConfigNew';
							param.Arg1 ="";
							param.Arg2=$HUI.combogrid('#_HospList').getValue();
							param.ArgCnt =2;
						},onSelect:function(record) {
							var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                        if(rows)rows.DHCIARecLocId=record.LocRowID
							
						},onChange:function(newValue, oldValue) {
							if (newValue==""){
								var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                        	if(rows)rows.DHCIARecLocId="";
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
					},
					{ field: 'DHCIAInstr', title: '用法', width: 50, resizable: true,
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
								var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
		                        if(rows)rows.DHCIAInstrId=record.InstrRowID
								
							},onChange:function(newValue, oldValue) {
								if (newValue==""){
									var rows=AppendItemListDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
		                        	if(rows)rows.DHCIAInstrId="";
								}
							},
							loadFilter: function(data){
								return data['rows'];
							}	
						  }
					  }
					},
					{ field: 'DHCIAInstrId', title: '', width: 1,hidden:true},
					{ field: 'DHCIARecLocId', title: '', width: 1,hidden:true}
    			 ]];
	AppendItemListDataGrid=$('#tabAppendItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.Items&QueryName=GetAppendItemList&ARCIMRowId=",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DHCIARowid",
		pageSize:15,
		pageList : [15,50,100,200],  
		columns :AppendItemListColumns,
		toolbar :AppendItemListBar,
		onDblClickRow:function(rowIndex, rowData){
			if (editRow!==undefined){
				$.messager.alert("提示","有正在编辑的行,请选保存或取消编辑!");
				return false;
			}
			AppendItemListDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(param){
		    editRow=undefined;
		    if (AppendItemListDataGrid)  AppendItemListDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
         }
	});
};
function LoadAppendItemListDataGrid(ARCIMRowID)
{
	editRow=undefined;
	//if(ARCIMRowID=="") return false;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.Items';
	queryParams.QueryName ='GetAppendItemList';
	queryParams.ARCIMRowId =ARCIMRowID;
	queryParams.HospId =$HUI.combogrid('#_HospList').getValue()
	//queryParams.ArgCnt =1;
	var opts = AppendItemListDataGrid.datagrid("options");
	opts.url = $URL;
	AppendItemListDataGrid.datagrid('load', queryParams);
};
function InitItemCategory(param1)
{
	$("#"+param1+"").combobox({      
    	valueField:'ORCATRowId',   
    	textField:'ORCATDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.Items';
			param.QueryName = 'GetCategoryList';
			param.Arg1=$HUI.combogrid('#_HospList').getValue()
			param.ArgCnt =1;
		},
		onChange: function (CatDr,o) {	
           $("#Combo_OrderCategory").empty();
		   InitOrderCategory("Combo_OrderCategory");
        } 
	});
};
function InitOrderCategory(param1)
{
	var ORCATRowId=$("#Combo_ItemCategory").combobox('getValue');
	$("#"+param1+"").combobox({      
    	valueField:'ARCICRowId',   
    	textField:'ARCICDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.Items';
			param.QueryName = 'GetOrdCategoryList';
			param.Arg1 =ORCATRowId;
			param.Arg2=$HUI.combogrid('#_HospList').getValue()
			param.ArgCnt =2;
		}
	});
};
function LoadAliasList(param1,param2) //List_ItemAlias
{
	$("#"+param1+"").empty();
	var objScope=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.Items",
		QueryName:"GetAliasByArcim",
	   	ARCIMRowId:param2
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.ALIASRowId + ">" + n.ALIASText + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]==1){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function FindClickHandle(){
	var Item="",ARCICRowId=""
    if ($("#Check_Desc").checkbox("getValue")) {
		Item=$("#item").val();
		if ($.trim(Item)=="") {
			$.messager.alert("提示", "请输入模糊检索码", "error");
			return false;
		}
	}else{
		 var ORCATRowId=$("#Combo_ItemCategory").combobox('getValue');
		 if (!ORCATRowId) ORCATRowId="";
		 if(ORCATRowId==""){
			//$.messager.alert("提示", "请选择大类!");
			//return false;
		 }
		 ARCICRowId=$("#Combo_OrderCategory").combobox('getValue');
		 if (!ARCICRowId) ARCICRowId="";
		 if(ARCICRowId==""){
			//$.messager.alert("提示", "请选择子类!");
			//return false;
		 }
	}
	LoadItemListDataGrid(Item,ARCICRowId,ORCATRowId);
}
