﻿var PageLogicObj={
	 m_CalUomTabDataGrid:"",
	 m_AppendItemDataGrid:"",
	 m_AddItemDataGrid:"",
	 editRow2:undefined,
	 editRow1:undefined,
	 editRow:undefined,
	 ChargeCateStr:[{"Code":"Material","Desc":"材料费"},{"Code":"Service","Desc":"加工费"},{"Code":"Add","Desc":"附加费"}]
}
$(function(){
	InitHospList();
	$("#BSave").click(SavePrescTypeCharge);
	$("#BCalUomConfig").click(BCalUomConfigOpen);
	document.onkeydown = Doc_OnKeyDown;
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CookModeCharge");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Text_PrescQtyStt,#Text_PrescQtyEnd").val("");
		$("#LessMinQtyNotAllowOrd,#MoreMaxQtyNotAllowOrd").switchbox('setValue',false);
		Init();
		LoadAppendItemDataGrid();
		LoadAddItemDataGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		PageLogicObj.m_AppendItemDataGrid=InittabAppendItem();
		PageLogicObj.m_AddItemDataGrid=InittabAddItem();
		LoadAppendItemDataGrid();
		LoadAddItemDataGrid();
	}
}
function Init(){
	//处方类型
	InitListPrescType("List_PrescType");
	//煎药方式
	InitListCookMode("List_DefaultCookMode");
	///单处方限定单位
	InitComboPrescBoundUnit("Combo_PrescBoundUnit","PrescTypePrescBound");
}
function SavePrescTypeCharge()
{
	var PrescType=$("#List_PrescType").combobox("getValue");
	if (!PrescType) {
		$.messager.alert('提示',"处方类型不能为空!");
	   return false;
	}
	var CookModeData=$("#List_DefaultCookMode").combobox("getData");
    var CookMode=$("#List_DefaultCookMode").combobox("getValue");
    if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
	   CookMode="";
    }
    var PrescBoundUnit=$("#Combo_PrescBoundUnit").combobox("getValue");
	var PrescBoundUnitData=$("#Combo_PrescBoundUnit").combobox('getData');
	if ($.hisui.indexOfArray(PrescBoundUnitData,"CTUomDr",PrescBoundUnit)<0) PrescBoundUnit="";
	if(PrescBoundUnit==""){
		$.messager.alert('提示',"请选择处方限定单位!");
		return false;
	}
	var PrescQtyStt=$("#Text_PrescQtyStt").val();
	var PrescQtyEnd=$("#Text_PrescQtyEnd").val();
	var LessMinQtyNotAllowOrd=$("#LessMinQtyNotAllowOrd").switchbox('getValue')?1:0;
	var MoreMaxQtyNotAllowOrd=$("#MoreMaxQtyNotAllowOrd").switchbox('getValue')?1:0;
	var str=PrescBoundUnit+"^"+PrescQtyStt+"^"+PrescQtyEnd+"^"+LessMinQtyNotAllowOrd+"^"+MoreMaxQtyNotAllowOrd;
	if (CookMode) {
		Node1=PrescType+"^"+CookMode;
	}else{
		Node1=PrescType;
	}
	var objScope=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"SaveConfig1",
		 Node:"PrescTypePrescBound",
		 Node1:Node1,
		 NodeValue:str,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	$.messager.show({title:"提示",msg:"保存成功"});	
}
function InitListPrescType(param1)
{
	$("#"+param1+"").combobox({ 
		editable:false,     
    	valueField:'Code',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CMDocConfig';
			param.QueryName = 'FindCMPrescType';
			param.Arg1=$HUI.combogrid('#_HospList').getValue();
			param.Arg2="Y";
			param.ArgCnt =2;
		},
		onSelect: function (CatDr,o) {	
			LoadCookModeChargeData();
		},
		onChange:function(newValue,oldValue){
			if (!newValue) {
				$("#"+param1+"").combobox('select','');
			}
		}
	});
}
function InitListCookMode(param1)
{
	$("#"+param1+"").combobox({ 
    	valueField:'RowID',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.DocConfig';
			param.QueryName = 'FindCookMode';
			param.Arg1 ="";
			param.Arg2 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =2;
		},
		onSelect: function (CatDr,o) {	
			LoadCookModeChargeData();
		},
		onChange:function(newValue,oldValue){
			if (!newValue) {
				$("#"+param1+"").combobox('select','');
			}
		}
	});
}
function InitComboPrescBoundUnit(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'CTUomDr',   
    	textField:'CTUomDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CookModeCharge';
			param.QueryName = 'QueryCalUomTypeConfig';
			param.Arg1 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =1;
		}  
	});
}
function InittabAppendItem()
{
	var AppendItemToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
             	var PrescCookCode=GetPrescCookCode();
            	if (!PrescCookCode) return false; 
			    PageLogicObj.editRow = undefined;
                PageLogicObj.m_AppendItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                PageLogicObj.m_AppendItemDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {
						ARCIMRowID:"",
						CTUomDr:"",
						ChargeCateDr:""
					}
                });
                PageLogicObj.m_AppendItemDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.editRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = PageLogicObj.m_AppendItemDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var PrescType=$("#List_PrescType").combobox("getValue");
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ARCIMRowID);
                            }
                            var ARCIMRowID=ids.join(',');
                            if ((!ARCIMRowID)||(PrescType=="")){
	                            ditRow = undefined;
				                PageLogicObj.m_AppendItemDataGrid.datagrid("rejectChanges");
				                PageLogicObj.m_AppendItemDataGrid.datagrid("unselectAll");
				                return false;
	                        }
							if(PrescType==""){
								$.messager.alert('提示',"请先选择加工方式");
								return false;
							}
							var CookModeData=$("#List_DefaultCookMode").combobox("getData");
							var CookMode=$("#List_DefaultCookMode").combobox("getValue");
							if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
								CookMode="";
							}
						    var node1=PrescType;
						    if (CookMode) {
							    node1=node1+"^"+CookMode;
							}
							var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.CookModeCharge",
								 MethodName:"delete",
								 node:"PrescTypeCharge",
								 node1:node1,
								 node2:ARCIMRowID,
								 HospId:$HUI.combogrid('#_HospList').getValue()
							},false);
							if(value=="0"){
								PageLogicObj.m_AppendItemDataGrid.datagrid('load');
								PageLogicObj.m_AppendItemDataGrid.datagrid('unselectAll');
								$.messager.show({title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
							}
							PageLogicObj.editRow = undefined;
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
			  if(PageLogicObj.editRow==undefined){
				  return false;
			  }
			  var PrescType=$("#List_PrescType").combobox("getValue");
			  if(PrescType==""){
				 $.messager.alert('提示',"请先选择处方类型");
				 return false;
			  }
			  var CookModeData=$("#List_DefaultCookMode").combobox("getData");
			  var CookMode=$("#List_DefaultCookMode").combobox("getValue");
			  if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
				  CookMode="";
			  }
                var rows = PageLogicObj.m_AppendItemDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(PageLogicObj.editRow==i){
						   var editors = PageLogicObj.m_AppendItemDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
						   var ArcimRowid=rows[i].ARCIMRowID //editors[0].target.combogrid('getValue');
						   if(!ArcimRowid){
								$.messager.alert('提示',"请选择医嘱项");
								return false;
				           }
							var Qty=editors[1].target.val();
							if(Qty=="") Qty=1;
							var CTUom=rows[i].CTUomDr;
							if(CTUom==""){
								$.messager.alert('提示',"计算单位不能为空!");
								return false;
							}
							var EqualQty=editors[3].target.val();
							if (EqualQty=="") {
								$.messager.alert('提示',"等效收费数量不能为空!");
								return false;
							}
							var MinQty=editors[4].target.val();
							var ChargeCateDr=rows[i].ChargeCateDr;
							if (ChargeCateDr=="") {
								$.messager.alert('提示',"处方打印分类不能为空!");
								return false;
							}
						    var ChargeInfo=Qty+"!"+CTUom+"!"+MinQty+"!"+EqualQty+"!"+ChargeCateDr;
						    var node1=PrescType;
						    if (CookMode) {
							    node1=node1+"^"+CookMode;
							}
						    var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.CookModeCharge",
								 MethodName:"save",
								 node:"PrescTypeCharge",
								 node1:node1,
								 node2:ArcimRowid,
								 value:ChargeInfo,
								 HospId:$HUI.combogrid('#_HospList').getValue()
							},false);
							if(value=="0"){
								PageLogicObj.m_AppendItemDataGrid.datagrid("endEdit", PageLogicObj.editRow);
								PageLogicObj.editRow = undefined;
								PageLogicObj.m_AppendItemDataGrid.datagrid('load');
								PageLogicObj.m_AppendItemDataGrid.datagrid('unselectAll');
								$.messager.show({title:"提示",msg:"保存成功"});
							}else{
								$.messager.alert('提示',"保存失败:"+"请选择医嘱项");
								return false;
							}
							PageLogicObj.editRow = undefined;
					   }
				   }
				}
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.editRow = undefined;
                PageLogicObj.m_AppendItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },'-',{
				id:'tip',
				iconCls: 'icon-help',
				text:'使用说明',
				handler: function(){
					$("#tip").popover('show');
				}
		}];
			AppendItemColumns=[[    
		            { field: 'ARCIMRowID', title: '', width: 200,hidden:true},
					{ field: 'ARCIMDesc', title: '医嘱项名称', width: 200,
		        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
					     			delay:500,
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
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             },
						             onSelect: function (rowIndex, rowData){
										var rows=PageLogicObj.m_AppendItemDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
										if(rows) rows.ARCIMRowID=rowData.ArcimRowID
									 },
		                             onClickRow : function(rowIndex, rowData) {
		                    			var rows=PageLogicObj.m_AppendItemDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
		                                if(rows) rows.ARCIMRowID=rowData.ArcimRowID
					                 }
			                	}
		        		}
					},
					{ field: 'Qty', title: '计算数量', width: 100,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'CTUomDr', title: '', width: 100,hidden:true},
					{ field: 'CTUomDesc',title: '计算单位', width: 100, 
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CookModeCharge&QueryName=QueryCalUomTypeConfig&rows=99999",
								valueField:'CTUomDr',
								textField:'CTUomDesc',
								required:true,
								onBeforeLoad:function(param){
					                 param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					            },
								loadFilter:function(data){
								    return data['rows'];
								},
								onSelect:function(record){
									if (record) {
										var rows=PageLogicObj.m_AppendItemDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
										if(rows) rows.CTUomDr=record.CTUomDr;
									}
								},
								onChange:function(newValue,oldValue){
									if (!newValue) {
										var rows=PageLogicObj.m_AppendItemDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
										if(rows) rows.CTUomDr="";
									}
								}
							 }
     					}
					},
					{ field: 'EqualQty', title: '等效收费数量', width: 110,
					   editor : {type : 'text',options : {}}
					},
					{ field: 'MinQty', title: '收费数量最小值', width: 120,
					   editor : {type : 'text',options : {}}
					},
					{ field: 'ChargeCateDr', title: '', width: 100,hidden:true},
					{ field: 'ChargeCate', title: '处方打印分类(材料/加工费)', width: 180, align: 'center', sortable: true,
					  editor :{  
							type:'combobox',  
							options:{
								valueField:'Code',
								textField:'Desc',
								required:true,
								editable:false,
								data:PageLogicObj.ChargeCateStr,
								onSelect:function(record){
									if (record) {
										var rows=PageLogicObj.m_AppendItemDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
										if(rows) rows.ChargeCateDr=record.Code;
									}
								}
							 }
     					}
					}
    			 ]];
	AppendItemDataGrid=$('#tabAppendItem').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		//idField:"ARCIMRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :AppendItemColumns,
		toolbar :AppendItemToolBar,
		onDblClickRow:function(rowIndex, rowData){
			if ((PageLogicObj.editRow != undefined)&&(PageLogicObj.editRow!=rowIndex)) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}else{
				PageLogicObj.m_AppendItemDataGrid.datagrid("beginEdit", rowIndex);
			}
			PageLogicObj.editRow=rowIndex;
		},
		onBeforeLoad:function(param){
			PageLogicObj.editRow = undefined;
			$('#tabAppendItem').datagrid("unselectAll");
		}
	});
	InitTip();
	return AppendItemDataGrid;
}
function BCalUomConfigOpen(){
	$("#CalUom-dialog").dialog("open");
	if (PageLogicObj.m_CalUomTabDataGrid=="") {
		PageLogicObj.m_CalUomTabDataGrid=InitCalUomTabDataGrid();
	}else{
		PageLogicObj.m_CalUomTabDataGrid.datagrid("reload");
	}
}
function InitCalUomTabDataGrid(){
	var Columns=[[ 
		{ field: 'CTUomDr', title: '', hidden:true},
		{ field: 'CTUomDesc', title: '计算单位', width: 100, align: 'center', sortable: true,
			editor :{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CookModeCharge&QueryName=GetCTUomList&value=&CookMode=&rows=99999",
					valueField:'CTUOMRowId',
					textField:'CTUOMDesc',
					required:true,
					onBeforeLoad:function(param){
			             param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
			        },
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(record){
						if (record) {
							var rows=PageLogicObj.m_CalUomTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
							rows.CTUomDr=record.CTUOMRowId;
						}
					},
					onChange:function(newValue,oldValue){
						if (!newValue) {
							var rows=PageLogicObj.m_CalUomTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
							rows.CTUomDr="";
						}
					}
				 }
			}
		},
		{ field: 'ChargeCateDr', title: '', hidden:true},
		{ field: 'ChargeCate', title: '单位类型', width: 180, align: 'center', sortable: true,
		  editor :{  
				type:'combobox',  
				options:{
					valueField:'Code',
					textField:'Desc',
					required:true,
					editable:false,
					data:[{"Code":"WeightUom","Desc":"重量单位"},{"Code":"DurUom","Desc":"付数单位"}],
					onSelect:function(record){
						if (record) {
							var rows=PageLogicObj.m_CalUomTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
							rows.ChargeCateDr=record.Code;
						}
					}
				 }
			}
		}
    ]]
    var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { 
        	if (!isNaN(PageLogicObj.editRow1)){
            	$.messager.alert("提示","请先保存")
            	return false
            }
            PageLogicObj.editRow1=0;
            PageLogicObj.m_CalUomTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
	                rowid:"",
	                ChargeCateDr:"",
	                CTUomDr:""
	            }
            });
            PageLogicObj.m_CalUomTabDataGrid.datagrid("beginEdit", 0);
        }
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {
	        var rows = PageLogicObj.m_CalUomTabDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
				var rowid=rows[rows.length-1].rowid;
				if (rowid==0) {
					PageLogicObj.m_CalUomTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
		    		PageLogicObj.editRow1 = undefined;
				}else{
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.CookModeCharge",
						MethodName:"DelCalUomTypeConfig",
					   	rowid:rowid
					},false);
					PageLogicObj.m_CalUomTabDataGrid.datagrid("reload");
					$("#Combo_PrescBoundUnit").combobox("select","").combobox("reload");
				}
            } else {
                $.messager.alert("提示", "请选择操作行", "error");
            }
	    }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	        if (isNaN(PageLogicObj.editRow1)){
            	$.messager.alert("提示","请先添加");
            	return false;
            }
            var rows = PageLogicObj.m_CalUomTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
			var Rowid=rows.rowid;
			var CTUomDr=rows.CTUomDr;
			var ChargeCateDr=rows.ChargeCateDr;
			if (!CTUomDr) {
				$.messager.alert("提示","请选择计算单位!");
            	return false;
			}
			if (!ChargeCateDr) {
				$.messager.alert("提示","请选择单位类型!");
            	return false;
			}
			var value=$.m({
				ClassName:"DHCDoc.DHCDocConfig.CookModeCharge",
				MethodName:"SaveCalUomTypeConfig",
			   	ChargeCateDr:ChargeCateDr,
			   	CTUomDr:CTUomDr,
			   	rowid:Rowid
			},false);
			if (value=="-1"){
   				$.messager.alert("提示","保存失败：该计算单位已存在!");
			}else{
       			PageLogicObj.editRow1=undefined;
       			PageLogicObj.m_CalUomTabDataGrid.datagrid("reload");
       			$("#Combo_PrescBoundUnit").combobox("select","").combobox("reload");
       		}
	    }
    },{
		iconCls: 'icon-arrow-right-top',
		text:'取消编辑',
		handler: function(){
			if ((PageLogicObj.editRow1!=="")&&(typeof PageLogicObj.editRow1 !="undefined")){
		    	PageLogicObj.m_CalUomTabDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
		    	PageLogicObj.editRow1 = undefined;
		    }
		}
	}];
	CalUomTabDataGrid=$('#CalUomTab').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CookModeCharge&QueryName=QueryCalUomTypeConfig",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"rowid",
		columns :Columns,
		toolbar :toobar,
		onBeforeLoad:function(param){
             param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
        },
		onLoadSuccess:function(data){
			PageLogicObj.editRow1=undefined;
			PageLogicObj.m_CalUomTabDataGrid.datagrid("unselectAll");
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow1!=undefined)&&(PageLogicObj.editRow1!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow1=index;
			PageLogicObj.m_CalUomTabDataGrid.datagrid("beginEdit", index);
		}
	});
	return CalUomTabDataGrid;	
}
function LoadCookModeChargeData(){
	var PrescType=$("#List_PrescType").combobox("getValue");
	if (!PrescType) return;
	var CookModeData=$("#List_DefaultCookMode").combobox("getData");
	var CookMode=$("#List_DefaultCookMode").combobox("getValue");
	if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
		CookMode="";
	}
	var SubNode=PrescType;
	if (CookMode) SubNode=SubNode+"^"+CookMode
	if (PrescType!=""){
		LoadAppendItemDataGrid();
		LoadAddItemDataGrid();
		var objScope=$.m({
			 ClassName:"web.DHCDocConfig",
			 MethodName:"GetConfigNode1New",
			 Node:"PrescTypePrescBound",
			 SubNode:SubNode,
			 HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		objScope=eval("(" + objScope + ")");
		var PrescBoundUnit=objScope.result.split("^")[0];
		var PrescQtyStt=objScope.result.split("^")[1];
		var PrescQtyEnd=objScope.result.split("^")[2];
		var LessMinQtyNotAllowOrd=objScope.result.split("^")[3];
		var MoreMaxQtyNotAllowOrd=objScope.result.split("^")[4];
		var PrescBoundUnitData=$("#Combo_PrescBoundUnit").combobox('getData');
		if ($.hisui.indexOfArray(PrescBoundUnitData,"CTUomDr",PrescBoundUnit)<0) PrescBoundUnit="";
		$("#Combo_PrescBoundUnit").combobox('select',PrescBoundUnit);
		$("#Text_PrescQtyStt").val(PrescQtyStt);
		$("#Text_PrescQtyEnd").val(PrescQtyEnd);
		$("#LessMinQtyNotAllowOrd").switchbox('setValue',LessMinQtyNotAllowOrd==1?true:false);
		$("#MoreMaxQtyNotAllowOrd").switchbox('setValue',MoreMaxQtyNotAllowOrd==1?true:false);
	}
}

function LoadAppendItemDataGrid()
{ 
	var PrescType=$("#List_PrescType").combobox("getValue");
	var CookModeData=$("#List_DefaultCookMode").combobox("getData");
	var CookMode=$("#List_DefaultCookMode").combobox("getValue");
	if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
		CookMode="";
	}
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CookModeCharge';
	queryParams.QueryName ='GetAppendItem';
	queryParams.value ="PrescTypeCharge";
	queryParams.CookMode =(CookMode=="")?PrescType:(PrescType+"^"+CookMode);
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
	var opts = PageLogicObj.m_AppendItemDataGrid.datagrid("options");
	opts.url = $URL;
	PageLogicObj.m_AppendItemDataGrid.datagrid('load', queryParams);
};
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>草药加工方式收费设置使用说明</li>" +
		"<li style='color:#008FF0;'>一、计算单位维护</li>" +
		"<li>1、计算单位列表只显示与<span class='high-span'>g</span>或<span class='high-span'>付</span>在单位转换页面维护转换系数的单位。</li>" + 
		"<li>2、单位类型只有重量单位和付数单位两种。重量单位是指在业务中使用处方各医嘱数量之和进行规则验证，付数单位是指使用处方付数进行规则验证。</li>" +
		"<li style='color:#008FF0;'>二、草药加工方式规则维护</li>" +
		"<li>1、草药加工方式收费设置可按照<span class='high-span'>院区+处方类型</span>或<span class='high-span'>院区+处方类型+煎药方式</span>维护规则。</li>" +
		"<li>2、单处方限定单位、计算单位均取自计算单位维护列表。</li>" + 
		"<li>3、所录入处方符合单处方总量范围时进行右侧医嘱的规则验证。</li>" +
		"<li>4、右侧绑定医嘱数量计算规则：</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp4.1、计算单位类型是重量单位：<span class='high-span'>绑定数量=(单处方总数*处方疗程系数/(计算数量*计算单位与基本单位G转换系数))*等效收费数量</span>。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp4.2、计算单位类型是付数单位：<span class='high-span'>绑定数量=(处方疗程系数/(计算数量*计算单位与基本单位付转换系数))*等效收费数量</span>。</li>" +
		"<li>5、当收费数量最小值不为空且绑定医嘱数量小于该值时不进行绑定。</li>" +
		"<li>6、保存处方时若处方煎药方式不为空,系统自动进行配置页面处方类型和处方类型+煎药方式的医嘱绑定。</li>" +
		"<li>7、处方打印分类是指在打印草药处方时所绑定医嘱所属分类。</li>" +
		"</ul>" 
		
	$("#tip").popover({
		width:700,
		trigger:'hover',
		content:_content
	});
}

function GetPrescCookCode(){
	var PrescType = $("#List_PrescType").combobox("getValue");
    if (PrescType == "") {
        $.messager.alert('提示', "请先选择处方类型!");
        return false;
    }
    var CookModeData = $("#List_DefaultCookMode").combobox("getData");
    var CookMode = $("#List_DefaultCookMode").combobox("getValue");
    if ((CookMode) && ($.hisui.indexOfArray(CookModeData, "RowID", CookMode) < 0)) {
        CookMode = "";
    }
    var node1 = PrescType;
    if (CookMode) {
        node1 = node1 + "^" + CookMode;
    }
    return node1;
}
function InittabAddItem() {
    var AddItemToolBar = [{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        var PrescCookCode=GetPrescCookCode();
            if (!PrescCookCode) return false; 
            if (!isNaN(PageLogicObj.editRow2)){
            	$.messager.alert("提示","请先保存数据")
            	return false
            }
            PageLogicObj.m_AddItemDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.m_AddItemDataGrid.datagrid("insertRow", { index: 0,row: {ARCIMRowID:"",MinUomDr:"",TypeCateDr:""}});
            PageLogicObj.m_AddItemDataGrid.datagrid("beginEdit", 0);
            PageLogicObj.editRow2 = 0;
        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            var RowObj=PageLogicObj.m_AddItemDataGrid.datagrid('getSelected');
            if (RowObj){
            	var ARCIMRowID = RowObj.ARCIMRowID;
                $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var PrescCookCode=GetPrescCookCode();
                            if (!PrescCookCode) return false;
                            var value = $.m({
                                ClassName: "DHCDoc.DHCDocConfig.CookModeCharge",
                                MethodName: "delete",
                                node: "PrescTypeAddCharge",
                                node1: PrescCookCode,
                                node2: ARCIMRowID,
                                HospId: $HUI.combogrid('#_HospList').getValue()
                            }, false);
                            if (value == "0") {
                                LoadAddItemDataGrid();
                                PageLogicObj.m_AddItemDataGrid.datagrid('unselectAll');
                                $.messager.show({ title: "提示", msg: "删除成功" });
                            } else {
                                $.messager.alert('提示', "删除失败:" + value);
                            }
                            PageLogicObj.editRow2 = undefined;
                        }
                    });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            if (PageLogicObj.editRow2 == undefined) {
                return false;
            }
            if (!PageLogicObj.m_AddItemDataGrid.datagrid('validateRow', PageLogicObj.editRow2)){
	            $.messager.alert('提示', "请输入必填信息");
                return false;
            }
            var PrescCookCode=GetPrescCookCode();
            if (!PrescCookCode) return false;
            //因为只能一行行保存，故改为行数据保存，不在使用getEditors方式获取数据(如果后期移动字段顺序，取值方式就需修改，操作麻烦)
            PageLogicObj.m_AddItemDataGrid.datagrid('endEdit', PageLogicObj.editRow2).datagrid('selectRow', PageLogicObj.editRow2);
            var RowObj=PageLogicObj.m_AddItemDataGrid.datagrid('getSelected');
            if (!CheckAddItemRow(RowObj,PrescCookCode)) return false;
            RowObj.SaveFlag="Y";		//保存标识
            var JsonStr=JSON.stringify(RowObj);
            var value=$.m({
				 ClassName:"DHCDoc.DHCDocConfig.CookModeCharge",
				 MethodName:"save",
				 node:"PrescTypeAddCharge",
				 node1:PrescCookCode,
				 node2:RowObj.ARCIMRowID,
				 value:JsonStr,
				 HospId:$HUI.combogrid('#_HospList').getValue()
			},false);  
			if (value == "0") {
				LoadAddItemDataGrid();
                PageLogicObj.editRow2 = undefined;
                PageLogicObj.m_AddItemDataGrid.datagrid('unselectAll');
                $.messager.show({ title: "提示", msg: "保存成功" });
            } else {
                $.messager.alert('提示', "保存失败:" + "请选择医嘱项");
                return false;
            }
            PageLogicObj.editRow2 = undefined;
        }
    }, {
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            LoadAddItemDataGrid();
        }
    }, '-', {
        id: 'addtip',
        iconCls: 'icon-help',
        text: '使用说明',
        handler: function() {
            $("#addtip").popover('show');
        }
    }];
    var AddItemColumns = [[
		{ field: 'ARCIMRowID', title: '', width: 200, hidden: true, editor: { type: 'text', options: {}}},
		{ field: 'ARCIMDesc', title: '医嘱项名称', width: 200,
			editor: {
				type: 'combogrid',
				options: {
					required: true,
					panelWidth: 450,
					panelHeight: 350,
					idField: 'ArcimDesc',
					textField: 'ArcimDesc',
					delay: 500,
					value: '', //缺省值 
					mode: 'remote',
					pagination: true, //是否分页   
					rownumbers: true, //序号   
					collapsible: false, //是否可折叠的   
					fit: true, //自动大小   
					pageSize: 10, //每页显示的记录条数，默认为10   
					pageList: [10,20], //可以设置每页记录条数的列表  
					url: $URL + "?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
					columns: [[
						{ field: 'ArcimDesc', title: '名称', width: 350, sortable: true },
						{ field: 'ArcimRowID', title: 'ID', width: 120, sortable: true },
						{ field: 'selected', title: 'ID', width: 120, sortable: true, hidden: true }
					]],
					onBeforeLoad: function(param) {
						var desc = param['q'];
						param = $.extend(param, { Alias: param["q"], HospId: $HUI.combogrid('#_HospList').getValue() });
					},
					onBeforeSelect: function(rowIndex, rowData) {
					},
					onSelect: function(rowIndex, rowData) {
						if (rowData){
							SetDatagridFieldVal("tabAddItem",PageLogicObj.editRow2,"ARCIMRowID",rowData.ArcimRowID);
						}
					}
				}
			}
		},
		{ field: 'MinQty', title: '起始数量', width: 100, editor: {type:'numberbox',options:{min:0,precision:2}}},
		{ field: 'MinUomDr', title: '', width: 100, hidden: true, editor: { type: 'text', options: {}}},
		{ field: 'MinUomDesc', title: '起始数量单位', width: 100,
			editor: {
				type: 'combobox',			
				options: {
					data: [{"CTUomDr":"味","CTUomDesc":"味"}],
					valueField: 'CTUomDesc',
					textField: 'CTUomDesc',
					required: true,
					editable: false,
					onSelect: function(rowData) {
						if (rowData) {
							SetDatagridFieldVal("tabAddItem",PageLogicObj.editRow2,"MinUomDr",rowData.CTUomDr);
						}
					},
					onChange: function(newValue, oldValue) {
						if (!newValue) {
							SetDatagridFieldVal("tabAddItem",PageLogicObj.editRow2,"MinUomDr","");
						}
					}
				}
			}
		},
		{ field: 'MinEqualQty', title: '起始等效数量', width: 100, editor: {type:'numberbox',options:{min:0,precision:2}}},
		{ field: 'MinNeedBind', title: '小于起始是否绑定', width: 120, align: 'center',
			editor: {
		        type: 'icheckbox',
		        options: {on: 'Y',off: ''}
		    },
		    styler: function(value, row, index) {
		        if (value == "Y") {
		            return 'color:#21ba45;';
		        } else {
		            return 'color:#f16e57;';
		        }
		    },
		    formatter: function(value, record) {
		        if (value == "Y") return "是";
		        else return "否";
		    }
		},
		{ field: 'OverQty', title: '超出数量', width: 70, editor: {type:'numberbox',options:{min:0,precision:2}}},
		{ field: 'OverEqualQty', title: '超出等效数量', width: 100, editor: {type:'numberbox',options:{min:0,precision:2}}},	
		{ field: 'OverNeedBind', title: '超出不足是否绑定', width: 120, align: 'center',
			editor: {
		        type: 'icheckbox',
		        options: {on: 'Y',off: ''}
		    },
		    styler: function(value, row, index) {
		        if (value == "Y") {
		            return 'color:#21ba45;';
		        } else {
		            return 'color:#f16e57;';
		        }
		    },
		    formatter: function(value, record) {
		        if (value == "Y") return "是";
		        else return "否";
		    }
		},
		{ field: 'TypeCateDr', title: '', width: 100, hidden: true, editor: { type: 'text', options: {}}},
		{ field: 'TypeCate', title: '分类', width: 100, 
			editor: {
				type: 'combobox',
				options: {
					valueField: 'Desc',
					textField: 'Desc',
					required: true,
					editable: false,
					data: PageLogicObj.ChargeCateStr,
					onSelect: function(rowData) {
						if (rowData) {
							SetDatagridFieldVal("tabAddItem",PageLogicObj.editRow2,"TypeCateDr",rowData.Code);
						}
					}
				}
			}
		}
	]];
    
	var AddItemDataGrid = $('#tabAddItem').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        loadMsg: '加载中..',
        pagination: true,
        rownumbers: true, 
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: AddItemColumns,
        toolbar: AddItemToolBar,
        onDblClickRow: function(rowIndex, rowData) {
            if ((PageLogicObj.editRow2 != undefined) && (PageLogicObj.editRow2 != rowIndex)) {
                $.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
                return false;
            } else {
                PageLogicObj.m_AddItemDataGrid.datagrid("beginEdit", rowIndex);
            }
            PageLogicObj.editRow2 = rowIndex;
        },
        onBeforeLoad: function(param) {
            PageLogicObj.editRow2 = undefined;
            $('#tabAddItem').datagrid("unselectAll");
        }
    });
    return AddItemDataGrid;
}

function SetDatagridFieldVal(Element,Index,Field,Val){
	var ed=$("#"+Element).datagrid('getEditor',{index:Index, field:Field});	
	if (ed){
		$(ed.target).val(Val);
		return true
	}
	return false;
}

function CheckAddItemRow(RowObj,PrescCookCode) {
    if (!RowObj) {
        $.messager.alert('提示', "行数据不是对象,请检查!");
        return false;
    }
    if ((!RowObj.ARCIMRowID) || (!RowObj.ARCIMDesc)) {
        $.messager.alert('提示', "请选择医嘱项!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    var ItemRet = tkMakeServerCall("DHCDoc.DHCDocConfig.CookModeCharge", "CheckAvailItem", RowObj.ARCIMRowID, RowObj.ARCIMDesc);
    var ItemArr = ItemRet.split("^");
    if (ItemArr[0] != 0) {
        $.messager.alert('提示', "请选择有效医嘱项!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    if (RowObj.SaveFlag!="Y"){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var ItemRet = tkMakeServerCall("DHCDoc.DHCDocConfig.CookModeCharge", "CheckExitAddItem", RowObj.ARCIMRowID,"PrescTypeAddCharge",PrescCookCode,HospID);
	    var ItemArr = ItemRet.split("^");
	    if (ItemArr[0] == 0) {
	        $.messager.alert('提示', "该医嘱项已存在，请修改对应数据!");
	        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
	        return false;
	    }
    }
    if (!RowObj.MinQty) {
        $.messager.alert('提示', "请输入起始数量!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    if (!RowObj.MinUomDr) {
        $.messager.alert('提示', "请选择起始数量单位!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    if (RowObj.MinNeedBind == "Y") {
        if (!RowObj.MinEqualQty) {
            $.messager.alert('提示', "请选择起始等效数量!");
            PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
            return false;
        }
    }
    if (((!RowObj.OverQty) && (RowObj.OverEqualQty)) || ((RowObj.OverQty) && (!RowObj.OverEqualQty))) {
        $.messager.alert('提示', "超出数量和超出等效数量需要同时维护!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    if (!RowObj.TypeCateDr) {
        $.messager.alert('提示', "请选择分类!");
        PageLogicObj.m_AddItemDataGrid.datagrid('beginEdit', PageLogicObj.editRow2)
        return false;
    }
    return true;
}

function LoadAddItemDataGrid(){
	var PrescType=$("#List_PrescType").combobox("getValue");
	var CookModeData=$("#List_DefaultCookMode").combobox("getData");
	var CookMode=$("#List_DefaultCookMode").combobox("getValue");
	if ((CookMode)&&($.hisui.indexOfArray(CookModeData,"RowID",CookMode)<0)) {
		CookMode="";
	}
	var CookMode=(CookMode=="")?PrescType:(PrescType+"^"+CookMode);
	PageLogicObj.editRow2=undefined;
	$.cm({
		ClassName: "DHCDoc.DHCDocConfig.CookModeCharge",
		MethodName: "GetAddItem",
		Value: "PrescTypeAddCharge", 
		CookMode: CookMode, 
		HospID: $HUI.combogrid('#_HospList').getValue()
	},function(GridData) {
		PageLogicObj.m_AddItemDataGrid.datagrid({loadFilter: DocToolsHUI.lib.pagerFilter}).datagrid('loadData', GridData);
		//此种异步模式加载，会去除掉按钮的悬浮模式，需再一次定义
	    InitAddTip();
	});
}
function InitAddTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>草药加工方式收费设置使用说明</li>" +
		"<li style='color:#008FF0;'>一、草药加工方式规则维护</li>" +
		"<li>1、草药加工方式收费设置可按照<span class='high-span'>院区+处方类型</span>或<span class='high-span'>院区+处方类型+煎药方式</span>维护规则。</li>" +
		"<li>2、现在计算单位为：<span class='high-span'>味</span>(单处方的总药品味数)。</li>" + 
		"<li>3、小于起始数量默认不绑定起始等效数量，如要绑定则需维护小于起始是否绑定。</li>" + 
		"<li>4、超出数量不足默认向下取整超出数量，如不足也要绑定则需维护超出不足是否绑定。</li>" + 
		"<li>5、绑定医嘱数量计算规则说明：</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp<span class='high-span'>起始绑定数量=(单处方总味数-起始数量)>=0?起始等效数量:(小于需绑定==Y?起始等效数量:0)</span>。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp<span class='high-span'>超出倍数=(单处方总味数-起始数量)/超出数量</span>。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp<span class='high-span'>超出整倍数=超出倍数>0?(超出不足需绑定==Y?超出倍数向上取整:超出倍数向下取整):0。</span>。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp<span class='high-span'>超出绑定数量=超出整倍数*超出等效数量</span>。</li>" +
		"<li>&nbsp&nbsp&nbsp&nbsp<span class='high-span'>绑定总数量=起始绑定数量+超出绑定数量</span>。</li>" +
		"<li>6、处方打印分类是指在打印草药处方时所绑定医嘱所属分类。</li>" +
		"</ul>" 
	$("#addtip").popover({
		width:700,
		trigger:'hover',
		content:_content
	});	
}

function Doc_OnKeyDown(e) {
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
	var keyEvent;   
	if(e.keyCode==8){   
	   	var d=e.srcElement||e.target;   
	    if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
	        keyEvent=d.readOnly||d.disabled;   
	    }else{   
	        keyEvent=true;   
	    }   
	}else{   
	    keyEvent=false;   
	}   
	if(keyEvent){   
	    e.preventDefault();   
	}   
	
}
