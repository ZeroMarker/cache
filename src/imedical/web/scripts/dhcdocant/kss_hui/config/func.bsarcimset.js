/**
 * func.bsnormal.js
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: ""
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})

function Init(){
	InitHospList();
	InitArcimList();
	InitGrid();
	
}

function InitEvent(){
	$("#BFind").click(findCfg)
}

function PageHandle(){
	//
}

function InitGrid() {
	var ToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {//添加列表的操作按钮添加,修改,删除等
			    editRow = undefined;
				PageLogicObj.m_Grid.rejectChanges();
				PageLogicObj.m_Grid.unselectAll();
                if (editRow != undefined) {
					PageLogicObj.m_Grid.endEdit(editRow);
                    return;
                }else{
	                //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
					PageLogicObj.m_Grid.insertRow({
						index: 0,
                        row: {
							cqmx:"N",
							tgc:"N",
							lab:"N"
						}
					});
                    //将新插入的那一行开户编辑状态
					PageLogicObj.m_Grid.beginEdit(0);
                    editRow = 0;
                }
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
				var rows = PageLogicObj.m_Grid.getSelections();
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowId);
                            }
                            var ids = ids.join(',');
                            if (ids == ""){
	                            editRow = undefined;
								PageLogicObj.m_Grid.rejectChanges();
								PageLogicObj.m_Grid.unselectAll();
				                return;
	                        }
							
                            var result = $.m({
								 ClassName:"DHCAnt.KSS.Config.ArcimSet",
								 MethodName:"Delete",
								 ids:ids
							},false);
							
							if(result == "0"){
								PageLogicObj.m_Grid.load();
								PageLogicObj.m_Grid.unselectAll();
	           					$.messager.popover({msg:"删除成功!",type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:" + result);
								return;
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
				if(editRow == undefined){
					return false;
				}
				PageLogicObj.m_Grid.selectRow(editRow);
				var rows = PageLogicObj.m_Grid.getSelected();
				if(rows.rowId){
	                var rowId = rows.rowId
	            }else{
		            var rowId = ""
		        }
		        var editors = PageLogicObj.m_Grid.getEditors(editRow);
				//var ArcimRowid=editors[0].target.combobox('getValue');
				var ArcimRowid = rows.arcim;
				if ((ArcimRowid=="")||(ArcimRowid==undefined)){
					$.messager.alert('提示',"请选择医嘱项！","warning");
					return false;
				}
				var cqmx = editors[1].target.is(':checked')?"Y":"N";
				var tgc = editors[2].target.is(':checked')?"Y":"N";
				var lab = editors[3].target.is(':checked')?"Y":"N";
				var inHosp = PageLogicObj.m_Hosp.getValue()||"";
				if (inHosp == "") {
					$.messager.alert('提示',"请选择院区！","warning");
					return false;
				}
				var inPara = rowId + "^" + ArcimRowid + "^" + cqmx + "^" + tgc + "^" + lab + "^" + inHosp;
				
				var result = $.m({
					 ClassName:"DHCAnt.KSS.Config.ArcimSet",
					 MethodName:"Save",
					 inPara:inPara
				},false);
				
				if(result == 1) {
					PageLogicObj.m_Grid.endEdit(editRow);
					editRow = undefined;
					PageLogicObj.m_Grid.load();
					PageLogicObj.m_Grid.unselectAll();
					$.messager.popover({msg:"保存成功!",type:'success'});
				} else if (result == "-1") {
					$.messager.alert('提示',"配置已存在！", "warning");
					return false;
				} else {
					$.messager.alert('提示',"保存失败:" + result);
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
				PageLogicObj.m_Grid.rejectChanges();
				PageLogicObj.m_Grid.unselectAll();
            }
        }];
	var Columns = [[    
                    { field: 'rowId', title: 'ID', width: 1,hidden:true},
                    { field: 'arcimDesc', title: '名称', width: 250,
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
									 onSelect : function(rowIndex, rowData) {
										PageLogicObj.m_Grid.selectRow(editRow);
										var rows = PageLogicObj.m_Grid.getSelected();
										//var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                        if(rows)rows.arcim = rowData.ArcimRowID
				                     },
				                     onBeforeLoad:function(param){
						                 var desc=param['q'];
										 var HospId = PageLogicObj.m_Hosp.getValue()||"";
										 if (HospId=="") {
											HospId = session['LOGON.HOSPID'];
										 }
										 param = $.extend(param,{Alias:param["q"],HospId:HospId});
						             }
                        		}
		        			}
					},
        			{ field: 'arcim', title: '医嘱项ID', width: 250,hidden:true},
					{ field: 'cqmx', title: '是否碳青霉烯', width: 100,
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
					{ field: 'tgc', title: '是否替加环素', width: 100,
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
					{ field: 'lab', title: '是否送检', width: 100,
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
					{field:'hospName',title:'所属院区',width:200
						
						/*,formatter:function(value,row){
							return row.hospName;
						},
						editor:{
							type:'combobox',
							options:{
								valueField:'hosp',
								textField:'hospName',
								defaultFilter:4,
								//multiple:true,
								url:$URL+"?ClassName=DHCAnt.KSS.Config.ArcimSet&QueryName=QryHosp&ResultSetType=array",
								mode:'remote',
								//data:PageLogicObj.m_HisDoc,
								required:false,
								blurValidValue:true
							},
							onBeforeLoad:function(param){
								//param.q = param["q"];
							}
						}*/
					}
    			 ]];
				 
	PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.ArcimSet",
			QueryName : "QryANTArcim",
			InHosp:session['LOGON.HOSPID']
		},
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"rowId",	//DARCIMRowid
		pageSize:15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			//ItemOrderQtyLimitDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.m_Grid.beginEdit(rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(param){
			var ArcimRowid = $('#Combo_Arcim').combogrid('getValue'); 
			param = $.extend(param,{ArcimRowid:ArcimRowid});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			editRow=undefined;
		}
	});
	
}

function InitHospList() {
	PageLogicObj.m_Hosp = GenHospComp("Ant_Config_Func_ArcimSet");
	PageLogicObj.m_Hosp.jdata.options.onSelect = function(e,t){
		findCfg();
	}
	PageLogicObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function InitArcimList() {
	
	//院区
	/*PageLogicObj.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(record) {
			
		}
		
	});	*/
	
	//$('#Combo_Arcim').combogrid({
	PageLogicObj.m_Arcim = $HUI.combogrid("#Combo_Arcim", {
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#Combo_Arcim').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_Arcim').combogrid("options").value=selected.ArcimRowID;
			}
		 },
		 onBeforeLoad:function(param){
             var desc=param['q'];
			 var HospId = PageLogicObj.m_Hosp.getValue()||"";
			 if (HospId=="") {
				HospId = session['LOGON.HOSPID'];
			 }
             param = $.extend(param,{Alias:param["q"],HospId:HospId});
         }
	});
};

function findCfg () {
	var ArcimRowid = PageLogicObj.m_Arcim.getValue()||"";
	var InHosp = PageLogicObj.m_Hosp.getValue()||"";
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Config.ArcimSet",
		QueryName : "QryANTArcim",
		ArcimRowid: ArcimRowid,
		InHosp:InHosp
	})	
}
 