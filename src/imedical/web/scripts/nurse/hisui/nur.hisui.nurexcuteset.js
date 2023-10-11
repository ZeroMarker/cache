var _GV={
	OrdCatData:[],
	InstrData:[],
	SpecData:[],
	RecLocData:[]
}
var hospComp="",hospID = session['LOGON.HOSPID']
var deptTypeList=[
	{
		value:"A",
		label:"全部"	
	},
	{
		value:"C",
		label:"本科室及病区"	
	},
	{
		value:"O",
		label:"其他科室"	
	}
];
// 医嘱执行双签类型（医嘱子类,用法,药品信息,医嘱项）
var typeList=[
	{
		value:"0",
		label:"医嘱子类"	
	},
	{
		value:"1",
		label:"用法"
	},
	{
		value:"2",
		label:"药品信息"
	},
	{
		value:"3",
		label:"医嘱项"
	}
];
$(function() {
	hospComp = GenHospComp("Nur_IP_ExecuteSheet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;   
		$(".search .hisui-searchbox").searchbox("setValue",""); 
		getLinkOrderData("arcimList","","");	
    	// 显示设置
		reloadSheetParamsGrid();
		// 单据 
    	reloadBillGrid(); 
    	// 通用配置
    	//initCommConfig();       	
	}  ///选中事件	
	
	initUI();
})

// 初始化页面
function initUI(){
	// 显示设置
	initTable();
	initPrintFlagCom();
	reloadSheetParamsGrid();
	// 初始化单据
	initBillList();
	// 单据按钮
    initBillBtnColList("B","btn");    
    // 单据列
    initBillBtnColList("C","col");  
    //医嘱附加信息
    initOrdAdditionTab();
    //医嘱排序
    initSheetOrdSortTab();
    // 加载数据
    reloadBillGrid();        
	// 初始化通用配置
	//initCommConfig();	
}

// 初始化单据列表
function initBillList(){
	$('#dg').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
	    	{field:'Code',title:'代码',width:100},  
	    	{field:'Name',title:'名称',width:130}, 
	    	{field:'OrdDepType',title:'开单科室',width:100,hidden:true,formatter:function(value,row,index){
		    	var desc="全部";
		    	if(value!=""){
			    	deptTypeList.forEach(function(val){
				    	if(value==val.value){
					    	desc=val.label;	
					    }	
				    })	
			    }	
			    return desc;
		    }}, 
	    	{field:'InfusionFlag',title:'输液单',width:55,hidden:true,formatter:function(value, row, index){
	        	return value == "Y" ? "是" : ""	
	        }},
	        {field:'ApplyService',title:'适用业务',width:100,formatter:function(value, row, index){
	        	return row["ApplyServiceDesc"];
	        }},
	        {field:'sheetType',title:'单据类型',width:100,formatter:function(value, row, index){
	        	return row["sheetTypeDesc"];
	        }}
	        /*{field:'ExecRecordFlag',title:'执行记录单据',width:100,formatter:function(value, row, index){
	        	return value == "Y" ? "是" : ""	
	        }},
	    	{field:'PCExecFlag',title:'电脑执行原因',width:100,formatter:function(value, row, index){
	        	return value == "Y" ? "启用" : ""	
	        }},
	        {field:'EmergencyFlag',title:'加急医嘱',width:80,formatter:function(value, row, index){
	        	return value == "Y" ? "是" : ""	
	        }}*/	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
		            //$("span.note,span.note1").hide();
					$("#sheet-dialog").dialog({title:"新增单据",iconCls:'icon-w-add'}).dialog("open")
	 				//清空表单数据
	 				$('#sheet-form').form("clear");
	 				$("#ordDepType").combobox({
						valueField:"value",
						textField:"label",
						data:deptTypeList,
						onLoadSuccess:function(){
							$(this).combobox("setValue","A");
						}
					});
					//$HUI.switchbox("#switch,#switch2").setValue(false);
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	var rows=$("#dg").datagrid("getSelections");
                	if(rows.length>0){
	                	$.messager.confirm("简单提示", "确定要删除该单据配置吗？", function (r) {
							if (r) {
								handleSheet("DELETE",rows[0].ID);
							}
						});
	                }else{
		                $.messager.popover({ msg: "请选择要删除的单据！", type:'info' });	
		            }
            	}
         	},{
	            text: '翻译',
	            iconCls: 'icon-translate-word',
	            handler: function() {
		            Translate("dg","CF.NUR.NIS.NurseSheetSet","NSSName","Name")	
	            }
	        }
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onSelect:function(rowIndex,rowData){ //onClickRow
			reloadSheetBtnColData(rowData.ID,"B","btn");
			reloadSheetBtnColData(rowData.ID,"C","col");
			getFilterSet(rowData.ID);
			loadFilterArcim(rowData.ID);
			loadSheetOtherSet(rowData.ID);
			setPCExecFlagStatus(rowData.sheetType);
			$("#ordAddition,#sheetOrdSortTab").datagrid("reload");
		},
		onDblClickRow:function(rowIndex,rowData){
			// 数据回显	
		 	$('#sheet-form').form("load",{
		 		Rowid: rowData.ID,
		 		Code: rowData.Code,
		 		Name: rowData.Name		
	 		});
	 		$("#ordDepType").combobox({
				valueField:"value",
				textField:"label",
				data:deptTypeList,
				onLoadSuccess:function(){
					var type=rowData.OrdDepType ? rowData.OrdDepType : "A";
					$(this).combobox("setValue",type);
				}
			})
	 		/*if(rowData.InfusionFlag == "Y"){
		 		$("#infusionFlag").checkbox("check");	
		 	}else{
			 	$("#infusionFlag").checkbox("uncheck");	
			}
			if(rowData.ExecRecordFlag == "Y"){
		 		$("#execRecordFlag").checkbox("check");	
		 	}else{
			 	$("#execRecordFlag").checkbox("uncheck");	
			}*/
			if (rowData["ApplyService"]){
				$("#ApplyServiceList").combobox("setValues",rowData["ApplyService"].split("^"));
			}else{
				$("#ApplyServiceList").combobox("setValues","");
			}
			$("#sheetType").combobox("setValue",rowData.sheetType);
			$("#sheet-dialog").dialog({title:"修改单据",iconCls:'icon-w-edit'}).dialog("open");
		}
	});
}

// 单据列表数据加载
function reloadBillGrid(flag)
{
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllSheet",
		hospId:hospID,
		filter:"",
		rows:99999
	},function(data){
		var len=data.rows.length;
		var defaultSelSheetId="",defaultSelSheetCode="";
		var index=0;
		/*if(len>0){
			if(flag=="add") defaultSelSheetId=data.rows[len-1].ID,defaultSelSheetCode=data.rows[len-1].Code,index=len-1;
			if(!flag) defaultSelSheetId=data.rows[0].ID,defaultSelSheetCode=data.rows[0].Code;
		}
		if(flag!="modify"){
			reloadSheetBtnColData(defaultSelSheetId,"B","btn");
			reloadSheetBtnColData(defaultSelSheetId,"C","col");	 
			getFilterSet(defaultSelSheetId);
			loadFilterArcim(defaultSelSheetId);
			loadSheetOtherSet(defaultSelSheetId);
			setPCExecFlagStatus(defaultSelSheetCode);
		}else{
			var row=$("#dg").datagrid("getRows");//getSelections
			index=$("#dg").datagrid("getRowIndex",row[0]);	
		}
		$("#dg").datagrid('loadData',data).datagrid("selectRow",index); 
		$("#ordAddition").datagrid("reload");*/
		if (len>0){
			if(flag=="add") index=len-1;
		}
		$("#dg").datagrid('loadData',data).datagrid("selectRow",index); 
	})	
}

// 保存单据
function handleSheet(event,sheetId){
	var rowid="",code="",name="",ordDepType="A",emergencyFlag="",execRecordFlag="",PCExecFlag="",sheetType="";
	var ApplyService="";
	if(event=="SAVE"){
		rowid=$("#rowid").val();
		code=$.trim($("#code").val());
		name=$.trim($("#name").val());
		ApplyService=$("#ApplyServiceList").combobox("getValues").join("^");
		sheetType=$("#sheetType").combobox("getValue");
		//execRecordFlag = $("#execRecordFlag").radio('getValue') ? "Y" : "N";
		if(code=="") return $.messager.popover({ msg: "代码不能为空！", type:'error' });
		if(name=="") return $.messager.popover({ msg: "名称不能为空！", type:'error' });
		if(ApplyService=="") return $.messager.popover({ msg: "适用业务不能为空！", type:'error' });
		if(sheetType=="") return $.messager.popover({ msg: "单据类型不能为空！", type:'error' });		
	}	
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleSheetItem",
		"rowID":event=="SAVE" ? rowid : sheetId,
		"code":code,
		"name":name,
		"execRecordFlag":execRecordFlag,
		"hospId":hospID,
		"ApplyService":ApplyService,
		"sheetType":sheetType,
		"event":event
	},function testget(result){
		$("#sheet-dialog").dialog( "close" );
		var msg=event=="SAVE" ? "保存" : "删除";
		var flag=(event=="SAVE" && rowid=="") ? "add" : "modify";
		if(result==0){
			$.messager.popover({ msg: msg+"成功！", type:'success' });
			reloadBillGrid(flag);							
		}else{
			msg=result==-1 ? msg+"失败！" : result;
			$.messager.popover({ msg: msg, type:'error' });	
		}
	});	
}
// 初始化单据按钮/列
function initBillBtnColList(type,ele){
	var columns=[];
	if(type=="B"){
		columns=[[  
	    	{field:'Name',title:'名称',width:100},  
	    	{field:'Desc',title:'描述',width:130,formatter: function(value,row,index){		                	
            	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
            }},
            {field:'FormWorkDesc',title:'打印模板',width:100,editor:{type:'combobox'}} 	       
		]];
	}else{
		columns=[[
	    	{field:'Desc',title:'名称',width:120},  
	    	{field:'Name',title:'项目',width:200,formatter: function(value,row,index){		                	
            	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
            }}    	       
		]];
	}
	$('#dg-'+ele).datagrid({
		fit : true,
		fitColumns:type=="B"? false : true,
		autoSizeColumn:false,
		autoRowHeight:false,
		columns :columns,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
		            addBtnCol(type,ele);		            
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	deleteBtnCol(ele);
            	}
         	},{
	            iconCls: 'icon-save',
	            text: '保存',
	            handler: function () {								
					HandleSheetBtnCol(type,ele);
	            }
			}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onLoadSuccess:function(){
			editRowIndex=undefined;
			$(this).datagrid('enableDnd');
		},
		onDrop:function(targetRow,sourceRow,point){
			var rows=$("#dg-btn").datagrid("getRows");
			//dropBtnCol("dg-btn","B");
		},
		onDblClickRow:function(rowIndex, rowData){
			if(type=="B"){
				if(editRowIndex!=undefined) $(this).datagrid("endEdit", editRowIndex);
				editRowIndex=rowIndex;				
				$(this).datagrid("beginEdit", editRowIndex);
				// 获取打印模板信息
				$.cm({
					ClassName:"Nur.NIS.Service.Base.BedConfig",
					QueryName:"GetXMLFomworkList",
					hospId:hospID,
					type:"Ord",
					rows:99999
				},function(data){
					var ed = $('#dg-btn').datagrid('getEditor', {index:rowIndex,field:'FormWorkDesc'});
					$(ed.target).combobox({
						valueField:"RowID",
						textField:"SPSName",
						width:100,
						//panelWidth:150,
						data:data.rows,
						onLoadSuccess:function(){
							if(rowData.FormWorkId){
								$(this).combobox("setValue",rowData.FormWorkId);
							}	
						},
						onSelect:function(record){
							rowData.FormWorkId=record.RowID;
							rowData.FormWorkDesc=record.SPSName;	
						},
						onChange:function(newValue,OldValue){
							if (!newValue) {
								rowData.FormWorkId="";
								rowData.FormWorkDesc="";
							}
						}
					});
				})
			}	
		}
	});
}
// 按钮列表数据加载
function reloadSheetBtnColData(sheetId,type,ele)
{
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetSheetButtonColumn",
		sheetId:sheetId,
		type:type,
		rows:99999
	},function(data){
		$("#Loading").hide();
		$("#dg-"+ele).datagrid('loadData',data); 
	})
}

// 维护选中单据的按钮及列
function initAddBtnTable(){
	$('#dg-addbtn').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
			{field:'ck',title:'ck',checkbox:true},  
	    	{field:'Desc',title:'按钮描述',width:180,editor:{type:'validatebox'}},
	    	{field:'Name',title:'按钮名称',width:180,editor:{type:'validatebox'}},  
	    	{field:'Func',title:'JS函数名',width:230,editor:{type:'validatebox'}},
	    	{field:'Icon',title:'图片名称',width:100,editor:{type:'validatebox'}},
	    	{field:'ShowWin',title:'弹窗',width:50,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    }},   
	    	{field:'Sign',title:'签名',width:50,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    }}        	       
		]],
		loadMsg : '加载中..'
	});
}
function initAddColTable(){
	$('#dg-addcol').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
			{field:'ck',title:'ck',checkbox:true},  
	    	{field:'Desc',title:'列名',width:160,editor:{type:'validatebox'}},
	    	{field:'BasicData',title:'项目',width:300,editor:{type:'validatebox'}},  
	    	{field:'Width',title:'列宽',width:50,editor:{type:'validatebox'}}        	       
		]],
		loadMsg : '加载中..'
	});
}
// 新增按钮/列
function addBtnCol(type,ele){
	var rows=$("#dg").datagrid("getSelections");
    if(rows.length>0){
        $("#dialog-add"+ele).dialog("open");
        if(type=="B"){
	        var checkedRows=$("#dg-btn").datagrid("getRows")
	   		initAddBtnTable();
			reloadBtnSetData("","dg-addbtn",checkedRows)
	    }else{
		    var checkedRows=$("#dg-col").datagrid("getRows")
			initAddColTable();
			reloadColSetData("","dg-addcol",checkedRows)    
		}
    }else{
        $.messager.popover({ msg: "请选择单据！", type:'info' });
    }
}
// 确定新增
function sureAddBtnCol(type,ele){
	$("#dialog-add"+ele).dialog( "close" );
	var selectedRows=$("#dg-add"+ele).datagrid("getSelections");
	if(selectedRows.length>0){
		var array=[];
		allSaveRows=$("#dg-"+ele).datagrid("getRows");
		selectedRows.forEach(function(val,index){	
			if(allSaveRows.length>0){
				var newData=allSaveRows.filter(function(val2){
					return val.ID==val2.ItemId;
				})
				if(newData.length==0){
					$('#dg-'+ele).datagrid('appendRow',{ID:"",ItemId:val.ID,Desc:val.Desc,Name:type=="B" ? val.Name : val.BasicData}).datagrid('enableDnd');;		
				} 
			}else{
				$('#dg-'+ele).datagrid('appendRow',{ID:"",ItemId:val.ID,Desc:val.Desc,Name:type=="B" ? val.Name : val.BasicData}).datagrid('enableDnd');;					
			}
		})
	}else{
		$.messager.popover({ msg: "请选择要新增的数据！", type:'info' });	
	}	
}
// 删除按钮/列
function deleteBtnCol(ele){
	var rows=$("#dg-"+ele).datagrid("getSelections");
    if(rows.length>0){
	    $.messager.confirm("确认", "确定要删除配置数据吗？", function (r) {
		    if (r) {
			    var index=$("#dg-"+ele).datagrid("getRowIndex",rows[0]);
        		$("#dg-"+ele).datagrid("deleteRow",index);
			}
		})
    }else{
        $.messager.popover({ msg: "请选择要删除的数据！", type:'error' });
    }    	
}
// 保存选中单据的按钮及列
function HandleSheetBtnCol(type,ele){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length>0){	
		var allSaveRows=$("#dg-"+ele).datagrid("getRows");
		var array=[],tempArr=[];
		if(allSaveRows.length>0){
			allSaveRows.forEach(function(val,index){
				array.push(val.ItemId);
				tempArr.push(val.FormWorkId);
			})
		}		
		$.m({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"HandleSheetButtonColumn",
			"sheetId":rows[0].ID,
			"type":type,
			"IdStr":array.join("^"),
			"FormWorkIdStr":tempArr.join("^")
		},function testget(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				reloadSheetBtnColData(rows[0].ID,type,ele);							
			}else{
				$.messager.popover({ msg: "保存失败！", type:'error' });			
			}
		});
	}else{
		$.messager.popover({ msg: "请选择单据！", type:'info' });
	}	
}
// 拖放行数据调整顺序
function dropBtnCol(ele,type){
	var selSheet=$("#dg").datagrid("getSelections");
	var rows=$("#"+ele).datagrid("getRows");
	var array=[];
	rows.forEach(function(val,index){
		array.push(val.ID);	
	})
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleSheetButtonColumn",
		"sheetId":selSheet[0].ID,
		"type":type,
		"IdStr":array.join("^")
	},function testget(result){
		
	});	
}

// 按钮维护
function setBtn(){
	$("#dialog-setbtn").dialog("open");
	editBtnIndex=undefined;
	initBtnSetTable();
	reloadBtnSetData("","dg-setbtn");
}
//初始化按钮维护列表
var editBtnIndex
function initBtnSetTable(){
	$('#dg-setbtn').datagrid({
		fit : true,
		fitColumns:true,
		autoRowHeight:false,
		autoSizeColumn:false,
		columns :[[
	    	{field:'ID',title:'ID',width:50},  
	    	{field:'Desc',title:'按钮描述',editor:{type:'validatebox'},width:120},
	    	{field:'Name',title:'按钮名称',editor:{type:'validatebox'},width:120}, 
	    	{field:'Code',title:'代码',editor:{type:'validatebox'},width:150},  
	    	{field:'Func',title:'JS函数名',editor:{type:'validatebox'},width:150},
	    	{field:'Icon',title:'图片名称',editor:{type:'validatebox'},width:150},
	    	{field:'ShowWin',title:'弹窗',editor:{type:'icheckbox',options:{on:'Y',off:'N'}},width:50},
	    	{field:'Sign',title:'签名',editor:{type:'icheckbox',options:{on:'Y',off:'N'}},width:50},
	    	{field:'PrintFlag',title:'打印标记',editor:{type:'validatebox'},hidden:true},
	    	{field:'PrintFlagDesc',title:'打印标记描述',editor:{type:'validatebox'},hidden:true}  	    	       	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editBtnIndex!=undefined){
						handleBtnRow(1,"SAVE");
					}else{
						addBtnRow();	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
	            	var rows=$('#dg-setbtn').datagrid("getSelections");
					if (rows.length == 1) {
						$.messager.confirm("简单提示", "确定要删除该按钮吗？", function (r) {
							if (r) {
								handleBtnRow("","DELETE");
							}
						});				
				 	}else{
				    	$.messager.alert("简单提示", "请选择要删除的按钮", "info");
				 	}
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	handleBtnRow("","SAVE");
            	}
         	},{
	            text: '翻译',
	            iconCls: 'icon-translate-word',
	            handler: function() {
		            Translate("dg-setbtn","CF.NUR.NIS.ButtonConfig","BCName","Name")	
	            }
	        }
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editBtnIndex!=undefined)&&(editBtnIndex!=rowIndex)&&!handleBtnRow("","SAVE")) return;
			$('#dg-setbtn').datagrid("endEdit",editBtnIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(!ifBtnEdit) return;
			editBtnIndex=rowIndex;
			$('#dg-setbtn').datagrid("beginEdit", editBtnIndex);			
		}
	});
}
// 加载按钮数据
function reloadBtnSetData(flag,ele,checkedRows){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllExecuteButton",
		rows:99999
	},function(data){
		$("#"+ele).datagrid('loadData',data); 
		if(flag) addBtnRow();
		if (checkedRows) {
			setTimeout(function(){
				for (var i=0;i<checkedRows.length;i++){
					var rows=$("#"+ele).datagrid('getRows'); 
					var index=$.hisui.indexOfArray(rows,"ID",checkedRows[i].ItemId);
					if (index>=0){
						$("#"+ele).datagrid('checkRow',index); 
					}
				}
			})
		}
	})	
}
// 新增按钮行
function addBtnRow(){
	editBtnIndex=$('#dg-setbtn').datagrid('getRows').length;
	var row={
		ID:"",
		Desc:"",
		Name:"",
		Code:"",
		Func:"",
		Icon:"",
		ShowWin:"",
		PrintFlag:""
	};
	$('#dg-setbtn').datagrid("insertRow", {row: row}).datagrid("beginEdit", editBtnIndex).datagrid("selectRow",editBtnIndex);
	var ed = $('#dg-setbtn').datagrid('getEditor', {index:editBtnIndex,field:'Desc'});
	$(ed.target).validatebox({required:true});
	var ed2 = $('#dg-setbtn').datagrid('getEditor', {index:editBtnIndex,field:'Name'});
	$(ed2.target).validatebox({required:true});
	var ed3 = $('#dg-setbtn').datagrid('getEditor', {index:editBtnIndex,field:'Code'});
	$(ed3.target).validatebox({required:true});
	var ed4 = $('#dg-setbtn').datagrid('getEditor', {index:editBtnIndex,field:'Func'});
	$(ed4.target).validatebox({required:true});
}
var ifBtnEdit=true;
// 保存按钮行
function handleBtnRow(flag,event) {
	var row="",rowid="",desc="",name="",code="",func="",icon="",showWin="",sign="",printFlag="",printFlagDesc="";
	if(editBtnIndex!=undefined){
		rows=$("#dg-setbtn").datagrid("getRows");
		rowid=rows[editBtnIndex].ID;
		rowEditors=$('#dg-setbtn').datagrid('getEditors',editBtnIndex);
		desc=$.trim($(rowEditors[0].target).val());
		name=$.trim($(rowEditors[1].target).val());
		code=$.trim($(rowEditors[2].target).val());
		func=$.trim($(rowEditors[3].target).val());
		icon=$.trim($(rowEditors[4].target).val());
		showWin=$(rowEditors[5].target).radio('getValue') ? "Y" : "N";
		sign=$(rowEditors[6].target).radio('getValue') ? "Y" : "N";
		printFlag=$.trim($(rowEditors[7].target).val());
		printFlagDesc=$.trim($(rowEditors[8].target).val());
		if(printFlag!="" && printFlagDesc==""){
			var ed = $('#dg-setbtn').datagrid('getEditor', {index:editBtnIndex,field:'PrintFlagDesc'});
			$(ed.target).validatebox({required:true});
			ifBtnEdit=false;	
			return $.messager.popover({ msg: "打印标记描述不能为空！", type:'alert' });;
		}	
	}else{
		rows=$("#dg-setbtn").datagrid("getSelections");
		rowid=rows[0].ID;
	}	
	if(event=="SAVE"){
		if(desc=="" || name=="" || code=="" || func=="") ifBtnEdit=false;
		if(desc=="") return $.messager.popover({ msg: "按钮描述不能为空！", type:'alert' });
		if(name=="") return $.messager.popover({ msg: "按钮名称不能为空！", type:'alert' });
		if(code=="") return $.messager.popover({ msg: "代码不能为空！", type:'alert' });
		if(func=="") return $.messager.popover({ msg: "JS函数名不能为空！", type:'alert' });	
	}
	ifBtnEdit=true;
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleExecuteButton",
		"rowID":rowid,
		"desc":desc,
		"name":name,
		"code":code,
		"func":func,
		"icon":icon,
		"showWin":showWin,
		"sign":sign,
		"printFlag":printFlag,
		"printFlagDesc":printFlagDesc,
		"event":event
	},function testget(result){				
		if(result==0){
			if(editBtnIndex!=undefined){
				$('#dg-setbtn').datagrid("endEdit", editBtnIndex);
				editBtnIndex=undefined;	
			}	
			// flag判断是否新增，新增时保存当前编辑行，列表重新加载后添加新的编辑行		
			reloadBtnSetData(flag,"dg-setbtn");
			return true;			
		}else{	
			$.messager.popover({ msg: result, type:'error' });
			return;	
		}
	});
}
// 列定义维护
var editColIndex;
function setCol(){
	$("#dialog-setcol").dialog("open");
	editColIndex=undefined;
	initColSetTable();
	reloadColSetData("","dg-setcol");
}
// 列定义维护列表
function initColSetTable(){
	$('#dg-setcol').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
	    	{field:'ID',title:'ID',width:50},  
	    	{field:'Desc',title:'列名',width:160,editor:{type:'validatebox'}},
	    	{field:'BasicData',title:'项目',width:300,editor:{type:'combobox'}}, 
	    	{field:'Width',title:'列宽',width:50,editor:{type:'numberbox',options:{min:60}}},  
	    	{field:'ShowSubOrder',title:'是否显示子医嘱',width:110,formatter:function(value,row,index){
		    	return value=="Y" ? value : "";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}       	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editColIndex!=undefined){
						handleColRow(1,"SAVE");
					}else{
						addColRow();	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
	            	var rows=$('#dg-setcol').datagrid("getSelections");
					if (rows.length == 1) {
						$.messager.confirm("简单提示", "确定要删除该数据吗？", function (r) {
							if (r) {
								handleColRow("","DELETE");
							}
						});				
				 	}else{
				    	$.messager.alert("简单提示", "请选择要删除的数据", "info");
				 	}
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	handleColRow("","SAVE");
            	}
         	},{
	            text: '翻译',
	            iconCls: 'icon-translate-word',
	            handler: function() {
		            Translate("dg-setcol","CF.NUR.NIS.ColumnConfig","CCDesc","Desc")	
	            }
	        }
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editColIndex!=undefined)&&(editColIndex!=rowIndex)&&!handleColRow("","SAVE")) return;
			$('#dg-setcol').datagrid("endEdit",editColIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(!ifColEdit) return;
			editColIndex=rowIndex;
			$('#dg-setcol').datagrid("beginEdit", editColIndex);
			getOrderItem(rowData.CodeDR);			
		}
	});
}
// 加载列维护数据
function reloadColSetData(flag,ele,checkedRows){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllExecuteColumn",
		rows:99999
	},function(data){
		$("#"+ele).datagrid('loadData',data); 
		if(flag) addColRow();
		if (checkedRows) {
			setTimeout(function(){
				for (var i=0;i<checkedRows.length;i++){
					var rows=$("#"+ele).datagrid('getRows'); 
					var index=$.hisui.indexOfArray(rows,"ID",checkedRows[i].ItemId);
					if (index>=0){
						$("#"+ele).datagrid('checkRow',index); 
					}
				}
			})
		}
	})	
}
// 新增列维护
function addColRow(){
	editColIndex=$('#dg-setcol').datagrid('getRows').length;
	var row={
		ID:"",
		Desc:"",
		BasicData:"",
		Width:"",
		ShowSubOrder:""
	};
	$('#dg-setcol').datagrid("insertRow", {row: row}).datagrid("beginEdit", editColIndex).datagrid("selectRow",editColIndex);
	// 获取项目编辑器
	getOrderItem();
}
// 保存列维护行
var ifColEdit=true;
function handleColRow(flag,event) {
	var rowid="",desc="",itemId="",width="",subFlag="";
	if(editColIndex!=undefined){
		rows=$("#dg-setcol").datagrid("getRows");
		rowid=rows[editColIndex].ID;
		rowEditors=$('#dg-setcol').datagrid('getEditors',editColIndex);
		desc=$.trim($(rowEditors[0].target).val());
		itemId=$(rowEditors[1].target).combobox("getValue");
		width=$.trim($(rowEditors[2].target).val());
		subFlag=$(rowEditors[3].target).radio('getValue') ? "Y" : "N";	
	}else{
		rows=$("#dg-setcol").datagrid("getSelections");
		rowid=rows[0].ID;
	}
	if(event=="SAVE"){
		if(desc=="" || itemId=="" || width=="") ifColEdit=false;
		if(desc=="") return $.messager.popover({ msg: "列名不能为空！", type:'alert' });	
		if(itemId=="") return $.messager.popover({ msg: "项目不能为空！", type:'alert' });
		if(width=="") return $.messager.popover({ msg: "宽度不能为空！", type:'alert' });	
	}
	ifColEdit=true;	
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleExecuteColumn",
		"rowID":rowid,
		"desc":desc,
		"itemId":itemId,
		"width":width,
		"subFlag":subFlag,
		"event":event
	},function testget(result){				
		if(result=="0"){
			if(editColIndex!=undefined){				
				$('#dg-setcol').datagrid("endEdit", editColIndex);
				editColIndex=undefined;	
			}	
			// flag判断是否新增，新增时保存当前编辑行，列表重新加载后添加新的编辑行		
			reloadColSetData(flag,"dg-setcol")
			return true;			
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
			return;
		}
	});
}
// 获取医嘱信息
function getOrderItem(itemDR){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		QueryName:"GetNurseBasicDataList",
		searchName:"",
		searchType:"1^2",
		filter:0,
		rows:99999
	},function(data){
		var ed = $('#dg-setcol').datagrid('getEditor', {index:editColIndex,field:'BasicData'});
		$(ed.target).combobox({
			valueField:"RowID",
			textField:"text",
			width:300,
			data:data,
			loadFilter:function(data){
				var newData=[];
				for(var i=0;i<data.total;i++){
					var obj=data.rows[i];
					obj.text=obj.NBDNote +"/"+obj.NBDCode;
					newData.push(obj);	
				}
				return newData;
			},
			onLoadSuccess:function(){
				if(itemDR){
					$(this).combobox("setValue",itemDR);
					itemDR="";	
				}	
			}
		});
	})	
}

// 电脑执行原因维护
var editReasonIndex;
function PCExeReasonSet(){
	$("#pcexecset-dialog").dialog("open");
	editReasonIndex=undefined;
	initReasonTable();
	reloadReasonData();
}
function initReasonTable(){
	$('#dg-pcexecset').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
	    	{field:'ID',title:'ID',width:50},  
	    	{field:'Desc',title:'原因描述',width:180,editor:{type:'validatebox'}},
	    	{field:'Code',title:'代码',width:180,editor:{type:'validatebox'}},  
	    ]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editReasonIndex!=undefined){
						handleReasonRow(1,"SAVE");
					}else{
						addReasonRow();	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
	            	var rows=$('#dg-pcexecset').datagrid("getSelections");
					if (rows.length == 1) {
						$.messager.confirm("简单提示", "确定要删除该配置吗？", function (r) {
							if (r) {
								handleReasonRow("","DELETE");
							}
						});				
				 	}else{
				    	$.messager.alert("简单提示", "请选择要删除的配置", "info");
				 	}
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	handleReasonRow("","SAVE");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editReasonIndex!=undefined)&&(editReasonIndex!=rowIndex)&&!handleReasonRow("","SAVE")) return;
			$('#dg-pcexecset').datagrid("endEdit",editReasonIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			editReasonIndex=rowIndex;
			$('#dg-pcexecset').datagrid("beginEdit", editReasonIndex);			
		}
	});
}
// 加载电脑执行原因维护数据
function reloadReasonData(flag){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllPCExecuteReason",
		hospId:hospID,
		rows:99999
	},function(data){
		$("#dg-pcexecset").datagrid('loadData',data); 
		if(flag) addReasonRow();
	})	
}
// 新增原因行
function addReasonRow(){
	editReasonIndex=$('#dg-pcexecset').datagrid('getRows').length;
	var row={
		ID:"",
		Desc:"",
		Code:""
	};
	$('#dg-pcexecset').datagrid("insertRow", {row: row}).datagrid("beginEdit", editReasonIndex).datagrid("selectRow",editReasonIndex);
}
// 保存原因行
function handleReasonRow(flag,event) {
	var row="",rowid="",desc="",code="";
	if(editReasonIndex!=undefined){
		rows=$("#dg-pcexecset").datagrid("getRows");
		rowid=rows[editReasonIndex].ID;
		rowEditors=$('#dg-pcexecset').datagrid('getEditors',editReasonIndex);
		desc=$(rowEditors[0].target).val();
		code=$(rowEditors[1].target).val();	
	}else{
		rows=$("#dg-pcexecset").datagrid("getSelections");
		rowid=rows[0].ID;
	}	
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandlePCExecuteReason",
		"rowID":rowid,
		"desc":desc,
		"code":code,
		"hospId":hospID,
		"event":event
	},function testget(result){				
		if(result==0){
			if(editReasonIndex!=undefined){
				$('#dg-pcexecset').datagrid("endEdit", editReasonIndex);
				editReasonIndex=undefined;	
			}	
			// flag判断是否新增，新增时保存当前编辑行，列表重新加载后添加新的编辑行		
			reloadReasonData(flag)			
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 初始化通用配置（执行设置、查询设置）todo
/*function initCommConfig(){
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"GetExecuteConfig",
		"hospId":hospID
	},function(data){		
		var data=JSON.parse(data);
		// 执行设置
		$("#defaultTime").combobox("setValue",data.ExecDefaultDT);		
		if(data.EditeDefaultDT=="Y"){
		 	$("#cb").checkbox("check");	
	 	}else{	
		 	$("#cb").checkbox("uncheck");	
		}
		if(data.OrdLimitExecDT==3){
		 	$("#cb2,#cb3").checkbox("check");	
	 	}else if(data.OrdLimitExecDT==2){	
	 		$("#cb3").checkbox("check");
	 		$("#cb2").checkbox("uncheck");	
		}else if(data.OrdLimitExecDT==1){	
	 		$("#cb2").checkbox("check");
	 		$("#cb3").checkbox("uncheck");	
		}else{
			$("#cb2,#cb3").checkbox("uncheck");	
		}
		$("#minute").numberbox('setValue',data.LongOrdForwardMin);
		$("#minute2").numberbox('setValue',data.TempOrdForwardMin);
		if(data.LisOrdSyncVB=="Y"){
			$("#cb4").checkbox("check");
		}else{
			$("#cb4").checkbox("uncheck");
		}
		if(data.ChangeSkinTestResut=="Y"){
			$("#cb5").checkbox("check");
		}else{
			$("#cb5").checkbox("uncheck");
		}
		if(data.CancelExecOrder!==""){
			$("#radio_"+data.CancelExecOrder).radio("check");	
		}else{
			$("input[name=cancel]").radio("uncheck");
		}		
		//$("#hour").numberbox('setValue',data.CancelExecLimitMin);
		if(data.ExamLimitExec=="Y"){
			$("#cb6").checkbox("check");
		}else{
			$("#cb6").checkbox("uncheck");
		}
		if(data.DocSign=="Y"){
			$("#docSign").checkbox("check");
		}else{
			$("#docSign").checkbox("uncheck");
		}
		// 查询设置
		$("#start").numberbox('setValue',data.StartDate);
		$('#startTime').timespinner('setValue',data.StartTime); 
		$("#end").numberbox('setValue',data.EndDate);
		$('#endTime').timespinner('setValue',data.EndTime);
		$("#patNums").numberbox('setValue',data.MaxPatNum);
		if(data.ExecTimes=="Y"){
			$("#cb7").checkbox("check");
		}else{
			$("#cb7").checkbox("uncheck");
		}
		if(data.DspStat=="Y"){
			$("#cb8").checkbox("check");
		}else{
			$("#cb8").checkbox("uncheck");
		}
		if(data.PrintFlag=="Y"){
			$("#cb9").checkbox("check");
		}else{
			$("#cb9").checkbox("uncheck");
		}
		if(data.CAShowFlag=="Y"){
			$("#cb10").checkbox("check");
		}else{
			$("#cb10").checkbox("uncheck");
		}
		if(data.JPFlag=="Y"){
			$("#cb11").checkbox("check");
		}else{
			$("#cb11").checkbox("uncheck");
		}
		//$("#consultDays").numberbox('setValue',data.ConsultDay);
		//$("#transDays").numberbox('setValue',data.TransferDay);
	});
}
// 保存右侧通用配置（执行设置、查询设置）todo需要和单据关联
function saveCommConfig(flag){
	if(flag==1){// 执行设置
		var ExecDefaultDT=$("#defaultTime").combobox("getValue");
		var EditeDefaultDT=$("#cb").radio('getValue') ? "Y" : "N";
		var long=$("#cb2").radio('getValue');
		var temp=$("#cb3").radio('getValue');
		var OrdLimitExecDT=0;
		if(long) OrdLimitExecDT=1;
		if(temp) OrdLimitExecDT=2;		
		if(long && temp) OrdLimitExecDT=3;
		var LongOrdForwardMin=$.trim($("#minute").val());
		var TempOrdForwardMin=$.trim($("#minute2").val());
		var LisOrdSyncVB=$("#cb4").radio('getValue') ? "Y" : "N";
		var ChangeSkinTestResut=$("#cb5").radio('getValue') ? "Y" : "N";
		var CancelExecOrder=$("input[name=cancel]:checked").val();
		//var CancelExecLimitMin=$.trim($("#hour").val());
		var CancelExecLimitMin="";
		var ExamLimitExec=$("#cb6").radio('getValue') ? "Y" : "N";
		var DocSign=$("#docSign").radio('getValue') ? "Y" : "N";
		var data={
			ExecDefaultDT:ExecDefaultDT,
			EditeDefaultDT:EditeDefaultDT,
			OrdLimitExecDT:OrdLimitExecDT,
			LongOrdForwardMin:LongOrdForwardMin,
			TempOrdForwardMin:TempOrdForwardMin,
			LisOrdSyncVB:LisOrdSyncVB,
			ChangeSkinTestResut:ChangeSkinTestResut,
			CancelExecOrder:CancelExecOrder,
			CancelExecLimitMin:CancelExecLimitMin,
			ExamLimitExec:ExamLimitExec,
			DocSign:DocSign
		}
	}else{ // 查询设置
		var StartDate=$.trim($("#start").numberbox("getValue"));
		var StartTime=$('#startTime').timespinner('getValue');  
		var EndDate=$.trim($("#end").numberbox("getValue"));
		var EndTime=$('#endTime').timespinner('getValue');
		var MaxPatNum=$.trim($("#patNums").val());
		var ExecTimes=$("#cb7").radio('getValue') ? "Y" : "N"; 
		var DspStat=$("#cb8").radio('getValue') ? "Y" : "N"; 
		var PrintFlag=$("#cb9").radio('getValue') ? "Y" : "N"; 
		var CAShowFlag=$("#cb10").radio('getValue') ? "Y" : "N";
		var JPFlag=$("#cb11").checkbox('getValue') ? "Y" : "N";
		//var ConsultDay=$.trim($("#consultDays").val());
		//var TransferDay=$.trim($("#transDays").val());
		var data={
			StartDate:StartDate,
			StartTime:StartTime,
			EndDate:EndDate,
			EndTime:EndTime,
			MaxPatNum:MaxPatNum,
			ExecTimes:ExecTimes,
			DspStat:DspStat,
			PrintFlag:PrintFlag,
			CAShowFlag:CAShowFlag,
			JPFlag:JPFlag
			//ConsultDay:ConsultDay,
			//TransferDay:TransferDay
		}
	}	
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"SaveExecuteConfig",
		saveDataJson:JSON.stringify(data),
		saveType:flag,
		hospId:hospID
	},function testget(result){
		if(result==0){
			$.messager.popover({ msg: "保存成功！", type:'success' });		
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}		
	})
}*/

// 初始化显示设置
function initTable(){
	getLinkOrderData("arcimList","","");
	//过滤医嘱项
	$('#arcim-filter').datagrid({
		fit:true,
		autoSizeColumn:false,
		fitColumns:true,
		autoRowHeight:false,
		idField:"ID",
		border:false,
		columns :[[
			{field:'Desc',title:'医嘱项',width:200,
				formatter: function(value,row,index){		                	
    				return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    			}
    		},
    		{ field: 'ID', title: '操作', width: 70, 
    			formatter: function(val, row, index){
                	var deleteBtn = '<a href="#this" class="deletecls" onclick="delArcimFilter(\'' + (row.ID) + '\')"></a>'
                	return deleteBtn;
	        	} 
	        }
    	]],
    	onLoadSuccess: function (data) {
	    	$('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
	    }
    });
	// 处置状态
	$('#dg2').datagrid({
		fit:true,
		autoSizeColumn:false,
		fitColumns:true,
		autoRowHeight:false,
		idField:"rowid",
		frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],
		columns :[[
			{field:'desc',title:'处置状态',width:160,
				formatter: function(value,row,index){		                	
					return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
				}
			}
		]]
    });
	// 医嘱优先级
	$('#dg3').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'医嘱优先级',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 医嘱分类
	$('#dg4').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'医嘱分类',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 医嘱状态
	$('#dg5').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'医嘱状态',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 医嘱用法
	$('#dg6').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'医嘱用法',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 医嘱阶段
	$('#dg7').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'医嘱阶段',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 标本名称
	$('#dg8').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'标本名称',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 接收科室
	$('#dg9').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'接收科室',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
	// 开单科室
	$('#dg10').datagrid({fit:true,autoSizeColumn:false,fitColumns:true,autoRowHeight:false,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'开单科室',width:160,formatter: function(value,row,index){		                	
    	return value ? '<span title="'+value+'" style="display:inline-block;width:100%;overflow:hidden;white-space:nowrap;text-overflow:ellipsis">'+value+'</span>' : ''    
    }}]]});	
}
// 加载选中单据的显示配置
function reloadSheetParamsGrid(){
	// 处置状态
	$.cm({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		QueryName:"GetDataRelationList",
		hospDR:hospID,
		category:"3", // 处置状态
		rows:99999
	},function(data){
		$("#dg2").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 医嘱优先级
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOecpr",
		rows:99999
	},function(data){
		$("#dg3").datagrid("unselectAll").datagrid("unselectAll").datagrid('loadData',data); 
	}) 
	// 医嘱分类
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdCat",
		hospId:hospID,
		rows:99999
	},function(data){
		_GV.OrdCatData=data.rows;
		$("#dg4").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 医嘱状态
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdStat",
		rows:99999
	},function(data){
		$("#dg5").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 医嘱用法
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdPhcin",
		rows:99999
	},function(data){
		_GV.InstrData=data.rows;
		$("#dg6").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 医嘱阶段
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdStage",
		rows:99999
	},function(data){
		$("#dg7").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 标本名称
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetSpecCode",
		hospId:hospID,
		rows:99999
	},function(data){
		_GV.SpecData=data.rows;
		$("#dg8").datagrid("unselectAll").datagrid('loadData',data); 
	})
	// 接收科室/开单科室
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetLoc",
		rows:99999
	},function(data){
		_GV.RecLocData=data.rows;
		$("#dg9,#dg10").datagrid("unselectAll").datagrid('loadData',data); 
	})
	//过滤医嘱项
	loadFilterArcim("");	
}
// 保存显示配置 todo需要考虑过滤条件
function HandleFilterSet(){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length>0){		
		var rows2=$("#dg2").datagrid("getSelections");
		var rows3=$("#dg3").datagrid("getSelections");
		var rows4=$("#dg4").datagrid("getSelections");
		var rows5=$("#dg5").datagrid("getSelections");
		var rows6=$("#dg6").datagrid("getSelections");
		var rows7=$("#dg7").datagrid("getSelections");
		var rows8=$("#dg8").datagrid("getSelections");
		var rows9=$("#dg9").datagrid("getSelections");
		var rows10=$("#dg10").datagrid("getSelections");
		if(rows2.length==0 && rows3.length==0 && rows4.length==0 && rows5.length==0 && rows6.length==0 && rows7.length==0 && rows8.length==0 && rows9.length==0 && rows10.length==0){
			return $.messager.popover({ msg: "请选择要保存的数据！", type:'info' });	
		}
		var disposeStat=getStr(rows2); // 处置状态
		var oecpr=getStr(rows3);       // 医嘱优先级
		var ordCat=getStr(rows4);      // 医嘱分类
		var ordStat=getStr(rows5);     // 医嘱状态
		var ordPhcin=getStr(rows6);    // 医嘱用法
		var ordStage=getStr(rows7);    // 医嘱阶段
		var specCode=getStr(rows8);    // 标本名称
		var recloc=getStr(rows9);      // 接收科室
		var ordDep=getStr(rows10);     // 开单科室
		
		var notSelOrdCat=getNotSelStr("dg4");
		var notSelordPhcin=getNotSelStr("dg6");
		var notSelSpec=getNotSelStr("dg8");
		var notSelRecloc=getNotSelStr("dg9");
		var sheetFilterPreOrd=$("#sheetFilterPreOrd").checkbox("getValue")?"Y":"N";
		var sheetDocNurFilterSubOrd=$("#sheetDocNurFilterSubOrd").checkbox("getValue")?"Y":"N";
		var sheetOnlyShowCurRecLocOrd=$("#sheetOnlyShowCurRecLocOrd").checkbox("getValue")?"Y":"N";
		var sheetShowAnaestheAllStageOrd=$("#sheetShowAnaestheAllStageOrd").checkbox("getValue")?"Y":"N";
		$.m({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"HandleFilterSetting",
			"rowID":rows[0].ID,
			"disposeStat":disposeStat,
			"oecpr":oecpr,
			"ordCat":ordCat,
			"ordStat":ordStat,
			"ordPhcin":ordPhcin,
			"ordStage":ordStage,
			"specCode":specCode,
			"recloc":recloc,
			notSelOrdCat:notSelOrdCat,
			notSelordPhcin:notSelordPhcin,
			notSelSpec:notSelSpec,
			notSelRecloc:notSelRecloc,
			sheetFilterPreOrd:sheetFilterPreOrd,
			sheetDocNurFilterSubOrd:sheetDocNurFilterSubOrd,
			sheetOnlyShowCurRecLocOrd:sheetOnlyShowCurRecLocOrd,
			sheetShowAnaestheAllStageOrd:sheetShowAnaestheAllStageOrd
			//"ordDep":ordDep
			//"ordDep":""
		},function testget(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });								
			}else{
				$.messager.popover({ msg: "保存失败！", type:'error' });	
			}
		});	
	}else{		
		$.messager.popover({ msg: "请选择单据！", type:'info' });
	}		
}
function getNotSelStr(tableId){
	var rows=$('#'+tableId).datagrid('getRows');
	var GridSelectArr=$('#'+tableId).datagrid('getSelections');
	var subPara="";
	for (var i=0;i<rows.length;i++){
		var ID=rows[i].ID ? rows[i].ID : rows[i].code;
		if ($.hisui.indexOfArray(GridSelectArr,rows[i].ID ? "ID" : "code",ID)<0) {
			if (subPara == "") subPara = ID;
			else  subPara = subPara + "^" + ID;
		}
	}
	return subPara;
}
function getStr(data){
	var str=""
	if(data.length>0){
		var array=[];
		data.forEach(function(val,index){
			var value=val.ID ? val.ID : val.code;			
			array.push(value);	
		})
		str=array.join("^");	
	}	
	return str;	
}

function getFilterSet(sheetId){
	if(sheetId){
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"GetFilterSetting",
			rowID:sheetId,
			rows:99999
		},function(data){
			var disposeStat=data.DisposeStat;
			echoFilterSet(disposeStat,"dg2");
			var oecpr=data.Oecpr;
			echoFilterSet(oecpr,"dg3");
			var ordCat=data.OrdCat;
			echoFilterSet(ordCat,"dg4");
			var ordStat=data.OrdStat;
			echoFilterSet(ordStat,"dg5");
			var ordPhcin=data.OrdPhcin;
			echoFilterSet(ordPhcin,"dg6");
			var ordStage=data.OrdStage;
			echoFilterSet(ordStage,"dg7");
			var specCode=data.SpecCode;
			echoFilterSet(specCode,"dg8");
			var recloc=data.Recloc;
			echoFilterSet(recloc,"dg9");
			var ordDep=data.OrdDep;
			echoFilterSet(ordDep,"dg10");
			$("#sheetFilterPreOrd").checkbox("setValue",data.sheetFilterPreOrd=="Y"?true:false);
			$("#sheetDocNurFilterSubOrd").checkbox("setValue",data.sheetDocNurFilterSubOrd=="Y"?true:false);
			$("#sheetOnlyShowCurRecLocOrd").checkbox("setValue",data.sheetOnlyShowCurRecLocOrd=="Y"?true:false);
			$("#sheetShowAnaestheAllStageOrd").checkbox("setValue",data.sheetShowAnaestheAllStageOrd=="Y"?true:false);
		})
	}else{
		$("#dg2,#dg3,#dg4,#dg5,#dg6,#dg7,#dg8,#dg9,#dg10").datagrid("unselectAll");		
	}		
}
function echoFilterSet(result,obj){
	$("#"+obj).datagrid("unselectAll");	
	if(result){
		if(obj!="dg2"){
			if(typeof result=="number"){
				result=JSON.stringify(result);	
			}
			var array=result.split("^");
			array.forEach(function(val,index){
				$("#"+obj).datagrid("selectRecord",val);	
			});	
		}else{ // 处置状态
			var rows=$("#dg2").datagrid("getRows");
			var array=result.split("^");
			array.forEach(function(val){
				var newData=rows.filter(function(val2){
					return val==val2.code;	
				})
				if (newData.length>0){
					var id=newData[0].rowid;
					$("#"+obj).datagrid("selectRecord",id);	
				}
			});
		}					
	}		
}

// 医嘱执行双签维护
function doubleSignSet(){
	$("#doublesign-dialog").dialog("open");
	$(".subType,.linkOrder,.linkOrder2").hide();
	$(".linkValue,.linkValue2,.icon-plus").show();
	if(subFlag){
		subFlag=false;
		resizeDoubleSign();	
	}	
	//清空表单数据
	$('#doublesign').form("clear");
	$('#doublesign').form("load",{
 		Type:"0",
 		SubType:"0",	
	});
	// 医嘱执行双签类型
    $HUI.combobox("#signType",
	{
		panelHeight:"150",
		valueField:"value",
		textField:"label",
		data:typeList,
		onSelect:function(record){
			// 切换类型时，清空值选项
			$('#doublesign').form("load",{
				Value:[],
				Value2:[]	
			});
			if(record.value!="3"){
				getLinkList("linkValue",record.value,"","");
				$(".linkValue").show();
				$(".linkOrder").hide();	
				if(subFlag){
					$("#signType2").combobox({"disabled":false});
				}							
			}else{
				getLinkOrderData("linkOrder","","");
				$(".linkValue").hide();
				$(".linkOrder").show();	
				if(subFlag){
					$("#signType2").combobox({"disabled":true});
					var subType=$("#signType2").combobox("getValue");	
					if(subType!="1"){
						$("#signType2").combobox({"value":"1"});	
						getLinkList("linkValue2","1","");		
					}										
				}			
			}				
		}
	});	
	$HUI.combobox("#signType2",
	{
		panelHeight:"150",
		valueField:"value",
		textField:"label",
		data:typeList,
		onSelect:function(record){
			// 切换类型时，清空值选项
			$('#doublesign').form("load",{
				SubValue:[],
				SubValue2:[]	
			});
			if(record.value!="3"){
				$(".linkValue2").show();
				$(".linkOrder2").hide();				
				getLinkList("linkValue2",record.value,"","");	
			}else{
				$(".linkValue2").hide();
				$(".linkOrder2").show();
				getLinkOrderData("linkOrder2","","");
			}	
		}
	});	
	getLinkList("linkValue","0","");
	getLinkList("linkValue2","1","");
	initDoubleSignTable();
	reloadDoubleSignGrid();
}
// 根据所选类型获取对应的值列表
function getLinkList(obj,type,idStr){
	if(type=="0"){ // 医嘱子类
		getLinkOrdCat(obj,idStr);
	}else if(type=="1"){ // 用法
		getLinkOrdPhcin(obj,idStr);
	}else if(type=="2"){ // 药品信息
		getLinkDrugInfo(obj,idStr);
	}	
}
// 关联的药品信息
function getLinkDrugInfo(obj,idStr){
	$HUI.combobox("#"+obj,
	{
		valueField:"value",
		textField:"label",
		multiple:true,
		data:[{value:"C",label:"化疗药"},{value:"H",label:"高警示"}]
	});
	if(idStr){
		$("#"+obj).combobox("setValues",idStr.split("^"));	
	}	
}
// 获取关联的子类
function getLinkOrdCat(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdCat",
		hospId:hospID,
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"ID",
			textField:"Desc",
			data:data.rows,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})	
}
// 获取关联的用法
function getLinkOrdPhcin(obj,idStr){	
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdPhcin",
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"ID",
			textField:"Desc",
			data:data.rows,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})	
}
// 获取关联医嘱列表
function getLinkOrderData(obj,arcItmDR,arcItmName) { 	
	//医嘱类型
	$("#"+obj).combogrid({
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimDR',title:'项目ID',width:30}
		]],
		pagination : false,
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=&arcimOwnFlag=&rows=999999",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){   
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){			 
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	})
}
// 添加子类型
var subFlag=false;
function resizeDoubleSign(){
	if(subFlag){
		$(".subType").show();
		$(".icon-plus").css("visibility","hidden");
		$(".doublesignList").css("height",'calc(100% - 91px)');
		var height=$("#doublesign-dialog .datagrid-body").height();
		$("#doublesign-dialog .datagrid-body").css("height",(height-40)+"px");	
	}else{
		$(".subType").hide();
		$(".icon-plus").css("visibility","visible");
		$(".doublesignList").css("height",'calc(100% - 51px)');
		var height=$("#doublesign-dialog .datagrid-body").height();
		$("#doublesign-dialog .datagrid-body").css("height",(height+40)+"px");		
	}
}
function addSubType(){
	subFlag=true;
	resizeDoubleSign();
	var type=$("#signType").combobox("getValue");
	var subType=$("#signType2").combobox("getValue");
	if(type=="3"){
		$("#signType2").combobox({"disabled":true,"value":"1"});	
		getLinkList("linkValue2","1","");	
	}else{		
		$("#signType2").combobox({"disabled":false,"value":subType});	
	}	
}
// 删除子类型
function deleteSubType(){
	subFlag=false;
	resizeDoubleSign();
}
function initDoubleSignTable(){
	$('#dg-doublesign').datagrid({
		fit : true,
		autoSizeColumn:false,
		columns :[[
	    	{field:'ID',title:'ID',width:50},  
	    	{field:'Desc',title:'描述',width:150},
	    	{field:'allType',title:'类型',width:150},  
	    	{field:'allValue',title:'值（可多选）',width:600}	    	 
	    ]],
	    //toolbar:"#doublesign",
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			var value=[],value2=[],subValue=[],subValue2=[];	
			if(rowData.Type!="3"){
				$(".linkValue").show();
				$(".linkOrder").hide();	
				getLinkList("linkValue",rowData.Type,rowData.Value);	
			}else{
				$(".linkValue").hide();
				$(".linkOrder").show();	
				getLinkOrderData("linkOrder",rowData.Value,rowData.ValueDesc);
			}
			if(rowData.SubType==""){
				if(subFlag){
					subFlag=false;
					resizeDoubleSign();		
				}				
			}else{
				if(!subFlag){
					subFlag=true;
					resizeDoubleSign();		
				}					
				if(rowData.SubType!="3"){
					$(".linkValue2").show();
					$(".linkOrder2").hide();
					$("#signType2").combobox({disabled:false});
					getLinkList("linkValue2",rowData.SubType,rowData.SubValue);	
				}else{
					$(".linkValue2").hide();
					$(".linkOrder2").show();
					$("#signType2").combobox({disabled:true});
					getLinkOrderData("linkOrder2",rowData.SubValue,rowData.SubValueDesc);
				}	
			}			
			$('#doublesign').form("load",{
		 		Desc: rowData.Desc,
		 		Type: rowData.Type,
		 		SubType: rowData.SubType,	
	 		});
		}
	});	
}
function reloadDoubleSignGrid(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetDoubleSign",
		hospId:hospID,
		rows:99999
	},function(data){
		var result=data.rows;
		if(result.length>0){			
			result.forEach(function(val,index){	
				var allType="";
				var allValue="";			
				if(val.Type!=""){
					var newData=typeList.filter(function(type){
						return val.Type==type.value;	
					})
					if(newData.length>0) allType=newData[0].label;
				}				
		    	if(val.SubType!=""){
					var newData=typeList.filter(function(subtype){
						return val.SubType==subtype.value;	
					})
					if(newData.length>0) allType=allType!=="" ? allType+"/"+newData[0].label : allType;
				}	
			    result[index].allType=allType;	
			    var reg = new RegExp("^","g");//g,表示全部替换。
			    if(val.ValueDesc!=="") allValue=val.ValueDesc.replace(/\^/g,"、");
				if(val.SubValueDesc!=="") allValue=allValue!=="" ? allValue+"/"+val.SubValueDesc.replace("^","、") : allValue; 
				result[index].allValue=allValue;
			})
		}
		$("#dg-doublesign").datagrid("loadData",data);
	})	
}
// 维护双签信息
function HandleDoubleSignInfo(event,flag){	
	var rowID="";
	if(event=="DELETE" || !flag){ // 删除/修改
		var rows=$("#dg-doublesign").datagrid("getSelections");
		if(rows.length>0){
			rowID=rows[0].ID;	
		}else{
			var msg=event=="DELETE" ? "删除" : "修改";
			return $.messager.popover({ msg: "请选择要"+msg+"的数据！", type:'info' });		
		}
	}
	var desc=$.trim($("#desc").val());	
	var type=$("#signType").combobox("getValue");
	var value=""
	var valArr=type!="3" ? $("#linkValue").combobox("getValues") : $("#linkOrder").combogrid("getValues");
	value=valArr.length>0 ? valArr.join("^") : value;
	var subType="",subValue="";
	if(subFlag){
		subType=$("#signType2").combobox("getValue");
		var valArr2=subType!="3" ? $("#linkValue2").combobox("getValues") : $("#linkOrder2").combogrid("getValues");
		subValue=valArr2.length>0 ? valArr2.join("^") : subValue;	
	}
	if(event=="SAVE"){
		if(desc=="") return $.messager.popover({ msg: "描述不能为空！", type:'alert' });
		if(type==="") return $.messager.popover({ msg: "主类型不能为空！", type:'alert' });
		if(value==="") return $.messager.popover({ msg: "主类型值不能为空！", type:'alert' });
		if(type==subType) return $.messager.popover({ msg: "主子类型不能重复！", type:'alert' });
	}			
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleDoubleSignInfo",
		"rowID":rowID,
		"desc":desc,
		"type":type,
		"value":value,
		"subType":subType,
		"subValue":subValue,
		"hospId":hospID,
		"event":event
	},function testget(result){
		var msg=event=="SAVE" ? "保存" : "删除";
		if(result==0){
			$.messager.popover({ msg: msg+"成功！", type:'success' });
			$('#doublesign').form("clear");
			$('#doublesign').form("load",{
		 		Type: "0",
		 		SubType: "0",	
			});
			$(".linkValue").show();
			$(".linkOrder").hide();	
			getLinkOrdCat("linkValue","");
			reloadDoubleSignGrid();	
			if (subFlag){
				$("#signType2").combobox({"disabled":false});
				getLinkOrdCat("linkValue2","");
			}						
		}else{
			$.messager.popover({ msg: msg+"失败！", type:'error' });	
		}
	});		
}
// 清空双签维护信息
function ClearForm(){
	$('#doublesign').form("clear");	
	var rows=$("#dg-doublesign").datagrid("unselectAll");
	$(".linkValue").show();
	$(".linkOrder").hide();	
	getLinkOrdCat("linkValue","");
	if (subFlag){
		$("#signType2").combobox("setValue","").combobox({"disabled":false});
		getLinkOrdCat("linkValue2","");
	}	
}

// 翻译
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'请选择要翻译的数据！',type:'alert'});
	}		
}

function onChangeSheetType(rec){
	//var code=$.trim($("#code").val());
	if(rec.value=="DefaultSee"){
		$HUI.switchbox("#PCExecFlag").setValue(false);
		$HUI.switchbox("#PCExecFlag").setActive(false);
		$("span.note").show();
		$("span.note1").hide()
	}else if(rec.value=="BGYZD"){
		$HUI.switchbox("#PCExecFlag").setValue(false);
		$HUI.switchbox("#PCExecFlag").setActive(false);
		$("span.note").hide();
		$("span.note1").show();
	}else{
		$HUI.switchbox("#PCExecFlag").setActive(true);
		$("span.note,span.note1").hide();
	}	
}
//删除过滤医嘱项
function delArcimFilter(arcimId){
	$.messager.confirm("确认", "确定要删除该过滤医嘱项吗？", function (r) {
		if (r) {
			var rows=$("#dg").datagrid("getSelections");
			var rowID=rows[0].ID;
			var index=$('#arcim-filter').datagrid('getRowIndex',arcimId);
			$('#arcim-filter').datagrid('deleteRow',index);
			if(rows.length>0){
				var arcimRows=$("#arcim-filter").datagrid("getRows");	
				var savedArcimStr=getStr(arcimRows);
				$.m({
					ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
					MethodName:"HandleFilterArcimSetting",
					"rowID":rowID,
					arcimStr:savedArcimStr
				},false);	
			}
		}
	});
}
function addFilterArcim(){
	var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){	
		var arcimArr=$("#arcimList").combogrid("getValues");
		if (arcimArr.length==0){
			$.messager.popover({msg:'请选择需要添加的医嘱项！',type:'alert'});
			return false;
		}
		var arcimStr=arcimArr.join("^");
		var rows=$("#arcim-filter").datagrid("getRows");
		var savedArcimStr=""
		if(rows.length>0){
			var array=[],repeatArr=[];
			rows.forEach(function(val,index){
				var value=val.ID;			
				array.push(value);
				if (("^"+arcimStr+"^").indexOf("^"+value+"^")>=0) {
					repeatArr.push(val.Desc);
				}	
			})
			if (repeatArr.length>0) {
				$.messager.popover({msg:repeatArr.join("、")+"重复！",type:'alert'});
				return false;
			}
			savedArcimStr=array.join("^");	
		}	
		if (savedArcimStr!="") arcimStr=savedArcimStr+"^"+arcimStr;
		$.m({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"HandleFilterArcimSetting",
			"rowID":sheetRows[0].ID,
			arcimStr:arcimStr
		},function testget(result){
			if(result==0){
				$("#arcimList").combogrid("setValues","");	
				$("#arcimList").combogrid("grid").datagrid("load",{arcimdesc:""})
				loadFilterArcim(sheetRows[0].ID);			
			}else{
				$.messager.popover({ msg: "添加失败！", type:'error' });	
			}
		});	
	}else{
		$.messager.popover({ msg: "请选选择单据！", type:'error' });	
	}
}
function loadFilterArcim(sheetId){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetFilterArcim",
		sheetId:sheetId,
		rows:99999
	},function(data){
		$("#arcim-filter").datagrid("unselectAll").datagrid('loadData',data); 
	})
}
//保存其他设置
function HandleOtherSet(){
	var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){	
		var StartDate=$.trim($("#start").numberbox("getValue"));
		var StartTime=$('#startTime').timespinner('getValue');  
		var EndDate=$.trim($("#end").numberbox("getValue"));
		var EndTime=$('#endTime').timespinner('getValue');
		var ExecTimes=$("#cb7").radio('getValue') ? "Y" : "N"; 
		var DspStat=$("#cb8").radio('getValue') ? "Y" : "N"; 
		var PrintFlag=$("#cb9").radio('getValue') ? "Y" : "N"; 
		var CAShowFlag=$("#cb10").radio('getValue') ? "Y" : "N";
		var JPFlag=$("#cb11").checkbox('getValue') ? "Y" : "N";
		var OrdBindDetail=$("#cb12").checkbox('getValue') ? "Y" : "N";
		var displayDefaultMode=$("#OrdMode").radio("getValue")?"Ord":($("#OrdExecMode").radio("getValue")?"OrdExec":"");
		var OrdExecFold=$("#OrdExecFold").switchbox("getValue")?"Y":"N";
		var PCExecFlag=$("#PCExecFlag").switchbox("getValue")?"Y":"N";
		var DateSwitch=$("#cb13").checkbox('getValue') ? "Y" : "N"; 
		var OrdChangeFilter=$("#cb17").checkbox('getValue') ? "Y" : "N"; 
		var OrdConfirmFilter=$("#cb18").checkbox('getValue') ? "Y" : "N"; 
		var PrintFilter=$("#cb19").checkbox('getValue') ? "Y" : "N"; 
		var NotPrintFilter=$("#cb20").checkbox('getValue') ? "Y" : "N"; 
		var EmergencyFlag=$("#cb21").checkbox('getValue') ? "Y" : "N"; 
		var PrintFilterFlag=$("#cb22").combobox('getValues').join("^"); 
		var NotPrintFilterFlag=$("#cb23").combobox('getValues').join("^"); 
		var NotExecutedFilter=$("#cb24").checkbox('getValue') ? "Y" : "N"; 
		var printedFlagFilterRule1=$("#cb25").checkbox('getValue'); 
		var printedFlagFilterRule2=$("#cb26").checkbox('getValue'); 
		var printFlagFilterRule=printedFlagFilterRule1?"AND":"OR";
		
		var noPrintFlagFilterRule1=$("#cb27").checkbox('getValue'); 
		var noPrintFlagFilterRule2=$("#cb28").checkbox('getValue'); 
		var notPrintFlagFilterRule=noPrintFlagFilterRule1?"AND":"OR";
		
		var data={
			sheetId:sheetRows[0].ID,
			StartDate:StartDate,
			StartTime:StartTime,
			EndDate:EndDate,
			EndTime:EndTime,
			ExecTimes:ExecTimes,
			DspStat:DspStat,
			PrintFlag:PrintFlag,
			CAShowFlag:CAShowFlag,
			JPFlag:JPFlag,
			OrdBindDetail:OrdBindDetail,
			displayDefaultMode:displayDefaultMode,
			OrdExecFold:OrdExecFold,
			PCExecFlag:PCExecFlag,
			DateSwitch:DateSwitch, 
			OrdChangeFilter:OrdChangeFilter,
			OrdConfirmFilter:OrdConfirmFilter,
			PrintFilter:PrintFilter,
			NotPrintFilter:NotPrintFilter,
			EmergencyFlag:EmergencyFlag,
			PrintFilterFlag:PrintFilterFlag,
			NotPrintFilterFlag:NotPrintFilterFlag,
			NotExecutedFilter:NotExecutedFilter,
			printFlagFilterRule:printFlagFilterRule,
			notPrintFlagFilterRule:notPrintFlagFilterRule
		}
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"SaveSheetOtherConfig",
			saveDataJson:JSON.stringify(data)
		},function testget(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });		
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}else{
		$.messager.popover({ msg: "请选选择单据！", type:'error' });	
	}
}
//设置"电脑执行原因"switch状态
function setPCExecFlagStatus(sheetType){
	if(sheetType=="DefaultSee"){
		$HUI.switchbox("#PCExecFlag").setValue(false);
		$HUI.switchbox("#PCExecFlag").setActive(false)
		$("span.note").show();
		$("span.note1").hide();
		$("#OrdMode").radio("check").radio("disable");
		$("#OrdExecMode").radio("uncheck").radio("disable");
		$("#cb18").checkbox("enable");
		$("#cb12").checkbox("uncheck").checkbox("disable");
	}else if(sheetType=="BGYZD"){
		$HUI.switchbox("#PCExecFlag").setValue(false);
		$HUI.switchbox("#PCExecFlag").setActive(false)
		$("span.note").hide();
		$("span.note1").show();
		$("#OrdMode").radio("check").radio("disable");
		$("#OrdExecMode").radio("uncheck").radio("disable");
		$("#cb18").checkbox("uncheck").checkbox("disable");
		$("#cb12").checkbox("uncheck").checkbox("disable");
	}else{
		$HUI.switchbox("#PCExecFlag").setActive(true);
		$("span.note,span.note1").hide();
		$("#OrdMode,#OrdExecMode").radio("enable");
		$("#cb18").checkbox("uncheck").checkbox("disable");
		$("#cb12").checkbox("enable");
	}
}
//加载单据其他设置
function loadSheetOtherSet(sheetId){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"GetSheetOtherConfig",
		sheetId:sheetId
	},function(result){
		$("#start").numberbox("setValue",result["StartDate"]);
		$("#startTime").timespinner("setValue",result["StartTime"]);
		$("#end").numberbox("setValue",result["EndDate"]);
		$("#endTime").timespinner("setValue",result["EndTime"]);
		$("#cb7").checkbox('setValue',result["ExecTimes"]=="Y"?true:false);
		$("#cb8").checkbox('setValue',result["DspStat"]=="Y"?true:false);
		$("#cb9").checkbox('setValue',result["PrintFlag"]=="Y"?true:false);
		$("#cb10").checkbox('setValue',result["CAShowFlag"]=="Y"?true:false);
		$("#cb11").checkbox('setValue',result["JPFlag"]=="Y"?true:false);
		$("#cb12").checkbox('setValue',result["OrdBindDetail"]=="Y"?true:false);
		
		$("#OrdMode,#OrdExecMode").radio("setValue",false);
		var displayDefaultMode=result["displayDefaultMode"];
		if (displayDefaultMode=="Ord"){
			$("#OrdMode").radio("setValue",true);
		}else if(displayDefaultMode=="OrdExec"){
			$("#OrdExecMode").radio("setValue",true);
		}
		OrdModeCheckChange();
		$("#OrdExecFold").switchbox("setValue",result["OrdExecFold"]=="Y"?true:false);
		$("#PCExecFlag").switchbox("setValue",result["PCExecFlag"]=="Y"?true:false);
		$("#cb13").checkbox("setValue",result["DateSwitch"]=="Y"?true:false);
		$("#cb17").checkbox("setValue",result["OrdChangeFilter"]=="Y"?true:false);
		$("#cb18").checkbox("setValue",result["OrdConfirmFilter"]=="Y"?true:false);
		$("#cb19").checkbox("setValue",result["PrintFilter"]=="Y"?true:false);
		$("#cb20").checkbox("setValue",result["NotPrintFilter"]=="Y"?true:false);
		$("#cb21").checkbox("setValue",result["EmergencyFlag"]=="Y"?true:false);
		$("#cb22").combobox("setValues",result["PrintFilterFlag"].toString().split("^"));
		$("#cb23").combobox("setValues",result["NotPrintFilterFlag"].toString().split("^"));
		$("#cb24").checkbox("setValue",result["NotExecutedFilter"]=="Y"?true:false);
		$("#sheetOrdSortSwitch").switchbox("setValue",result["SheetOrdSortSwitch"]=="Y"?true:false);
		$("#cb25").radio("setValue",result["printFlagFilterRule"]=="AND"?true:false);
		$("#cb26").radio("setValue",result["printFlagFilterRule"]=="OR"?true:false);
		$("#cb27").radio("setValue",result["notPrintFlagFilterRule"]=="AND"?true:false);
		$("#cb28").radio("setValue",result["notPrintFlagFilterRule"]=="OR"?true:false);
		
		PrintCheckChange();
		notPrintCheckChange();
	})
}
function OrdModeCheckChange(e,value){
	var value=$("#OrdMode").checkbox("getValue");
	if (value){
		$HUI.switchbox("#OrdExecFold").setActive(true);
	}else{
		$HUI.switchbox("#OrdExecFold").setValue(false);
		$HUI.switchbox("#OrdExecFold").setActive(false)
	}
}
var editSheetOrdSortIndex;
function initSheetOrdSortTab(){
	$("#sheetOrdSortTab").datagrid({
		fit:true,
        url: $URL,
        idField:'sortSetId',
        singleSelect:true,
        queryParams: {
            ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
            QueryName: 'getOrdSortSet'
        },
        bodyCls:'panel-header-gray',
        columns: [[
        	{
                field: 'EOSSSerialNo', title: '顺序', width: 45
            },
            {
                field: 'EOSSArcimDR', title: '医嘱项', width: 300,
                formatter: function (value, row) {
				    return row["EOSSArcimDesc"]
                },
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
						delay: 500,
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
				             var ArcimRowID=rowData.ArcimRowID;
				             saveOrdSortSet(ArcimRowID);
				         }
            		}
	    		}
            },
            { field: 'rowid', title: '操作', width: 120, formatter: function(val, row, index){
                var deleteBtn = '<a href="#this" class="deletecls1" onclick="delOrdSortSet(\'' + (row.sortSetId) + '\')"></a>';
                var sortUpBtn = '<a href="#this" class="sortUpcls" onclick="ordSortUp(\'' + (row.sortSetId) + '\')"></a>';
                var sortDownBtn = '<a href="#this" class="sortDowncls" onclick="ordSortDown(\'' + (row.sortSetId) + '\')"></a>';
                return deleteBtn + " " + sortUpBtn + " " + sortDownBtn;
	        } }
        ]],
        onDblClickRow: function (index,row) {
	        var sheetRows=$("#dg").datagrid("getSelections");
			if(sheetRows.length==0){
				$.messager.popover({ msg: '请先选择左侧筛选范围！', type: 'error' });
				return false;
			}	
			var sheetId=sheetRows[0].ID;
	        if (editSheetOrdSortIndex != index) {
		        if(editSheetOrdSortIndex !=undefined){
			        $('#sheetOrdSortTab').datagrid('endEdit', editSheetOrdSortIndex);
				}
	            $('#sheetOrdSortTab').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editSheetOrdSortIndex = index;
		    }
        },
        onLoadSuccess: function (data) {
	        $('#sheetOrdSortTab').datagrid('appendRow', { sortSetId: '', EOSSSerialNo:'',EOSSArcimDR: '',EOSSArcimDesc:''});
	        $('.deletecls1').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
	        $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        $('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
        },
        onBeforeLoad:function(param){
	        if (editSheetOrdSortIndex!=undefined){
		        $('#sheetOrdSortTab').datagrid('endEdit', editSheetOrdSortIndex);
		        editSheetOrdSortIndex = undefined
		    }
	        $('#sheetOrdSortTab').datagrid('unselectAll');
	        var sheetId="";
	        var sheetRows=$("#dg").datagrid("getSelections");
			if(sheetRows.length>0){
				sheetId=sheetRows[0].ID;
			}
	        param.sheetId=sheetId;
	    }
    });
}
function initOrdAdditionTab(){
	$("#ordAddition").datagrid({
		fit:true,
        url: $URL,
        queryParams: {
            ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
            QueryName: 'getOrdAdditionSet'
        },
        bodyCls:'panel-header-gray',
        columns: [[
        	{
                field: 'EOASSeqNo', title: '顺序', width: 45,
                editor:{
	                type: 'numberbox'
                }
            },
            {
                field: 'EOASName', title: '项目描述', width: 150,
                editor:{
	                type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
            },
            {
                field: 'EOASBasicItem', title: '基础数据项目', width: 150,
                formatter: function (value, row) {
				    return row["EOASBasicItemDesc"]
                },
                editor: {
                    type:'combobox',  
					options:{
						required: true,
						mode:"remote",
						//multiple:true,
						//editable:false,
						rowStyle:"checkbox",
						url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&filter=1&rows=99999",
						valueField:'RowID',
						textField:'NBDName',
						loadFilter: function(data){
							return data['rows'];
						},
						onBeforeLoad:function(param){
							$.extend(param, {
								searchType:"1^2",
								searchName:param["q"]
							});
						}
					}
                }
            },
            {
                field: 'EOASShowMode', title: '显示模式', width: 100,
                formatter: function (value, row) {
				    return row["EOASShowModeDesc"]
                },
                editor: {
                    type:'combobox',  
					options:{
						editable:false,
						required: true,
						valueField:'id',
						textField:'text',
						data:[{"id":"ALL","text":"全部"},{"id":"Ord","text":"医嘱模式"},{"id":"OrdExec","text":"执行记录模式"}]
					}
                }
            },
            {
                field: 'EOASSubOrdShow', title: '子医嘱是否显示', width: 110,
                formatter: function (value, row) {
                    if (value=="Y") {
		                return "是";
		            }else if(value=="N"){
			            return "否"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    editable:false,
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                }
            },
            {
                field: 'EOASBackgroundColor', title: '背景颜色', width: 90,
                editor:{
	                type: 'text',
	                options: {
	                    required: false
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
            },
            {
                field: 'EOASFontColor', title: '字体颜色', width: 90,
                editor:{
	                type: 'text',
	                options: {
	                    required: false
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
            },
            {
                field: 'EOASActive', title: '是否启用', width: 70,
                formatter: function (value, row) {
                    if (value=="Y") {
		                return "是";
		            }else if(value=="N"){
			            return "否"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    editable:false,
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                }
            },
            { field: 'rowid', title: '操作', width: 75, formatter: function(val, row, index){
	            var saveBtn = '<a href="#this" class="savecls" onclick="saveOrdAdditionSet(' + (index) + ')"></a>';
                var deleteBtn = '<a href="#this" class="deletecls" onclick="delOrdAdditionSet(\'' + (row.rowid) + '\')"></a>'
                return saveBtn + " " + deleteBtn
	        } }
        ]],
        onDblClickRow: function (index,row) {
	        var sheetRows=$("#dg").datagrid("getSelections");
			if(sheetRows.length==0){
				$.messager.popover({ msg: '请先选择左侧筛选范围！', type: 'error' });
				return false;
			}	
			var sheetId=sheetRows[0].ID;
	        if (editOrdAdditionIndex != index) {
		        if(editOrdAdditionIndex !=undefined){
			        $('#ordAddition').datagrid('endEdit', editOrdAdditionIndex);
				}
	            $('#ordAddition').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editOrdAdditionIndex = index;
	            var ed = $('#ordAddition').datagrid('getEditor', {index:editOrdAdditionIndex,field:'EOASFontColor'});
				$(ed.target).color({
					//required: true,
					editable:true,
					width:90,
					height:30
				});
				var ed = $('#ordAddition').datagrid('getEditor', {index:editOrdAdditionIndex,field:'EOASBackgroundColor'});
				$(ed.target).color({
					//required: true,
					editable:true,
					width:90,
					height:30
				});
		    }
        },
        onLoadSuccess: function (data) {
	        $('#ordAddition').datagrid('appendRow', { rowid: '', EOASSeqNo:'',EOASName: '', EOASBasicItem: '', EOASBackgroundColor: '', EOASFontColor: '', EOASActive: ''});
        	$('.savecls').linkbutton({ text: '', plain: true, iconCls: 'icon-save' });
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad:function(param){
	        if (editOrdAdditionIndex!=undefined){
		        $('#ordAddition').datagrid('endEdit', editOrdAdditionIndex);
		        editOrdAdditionIndex = undefined
		    }
	        $('#ordAddition').datagrid('unselectAll');
	        var sheetId="";
	        var sheetRows=$("#dg").datagrid("getSelections");
			if(sheetRows.length>0){
				sheetId=sheetRows[0].ID;
			}
	        param.sheetId=sheetId;
	    }
    });
}
var editOrdAdditionIndex;
function saveOrdAdditionSet(){
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
    if (sheetId==""){
        $.messager.popover({ msg: '请先选择单据！', type: 'error' });
		return false;
    }
	var NullValColumnArr=[],SeqNoArr=[];
    var rows = $('#ordAddition').datagrid('getRows');
    for (var i=0;i<rows.length;i++){
	    if (i==editOrdAdditionIndex) continue;
	    if (rows[i]["PLSSSeqNo"]!=""){
	    	SeqNoArr[rows[i]["PLSSSeqNo"]]=1;
	    }
	}
    var row = rows[editOrdAdditionIndex];
    var editors=$('#ordAddition').datagrid('getEditors',editOrdAdditionIndex);
	for (var k=0;k<editors.length;k++){
	    var field=editors[k].field;
	    var fieldOpts = $('#ordAddition').datagrid('getColumnOption',field);
	    if (fieldOpts.editor.type=="combobox") {
		    if (fieldOpts.editor.options.multiple){
			    row[field]=$(editors[k].target).combobox("getValues").join("^");
			}else{
				row[field]=$(editors[k].target).combobox("getValue");
			}
		}else if((field=="EOASBackgroundColor")||(field=="EOASFontColor")){
			row[field]=$.trim($(editors[k].target).color("getValue"));
		}else if(fieldOpts.editor.type=="numberbox"){
			row[field]=$.trim($(editors[k].target).numberbox("getValue"));
			if (SeqNoArr[row[field]]){
				$.messager.popover({ msg: '序号重复！', type: 'error' });
				return false;
			}else if(row[field]!=""){
				SeqNoArr[row[field]]=1;
			}
		}else{
			row[field]=$.trim($(editors[k].target).val());
		}
	    if (fieldOpts.editor.options){
			if ((fieldOpts.editor.options.required)&&(!row[field])){
				NullValColumnArr.push(fieldOpts.title);
			}
		}
	}
	if (NullValColumnArr.length>0){
		$.messager.alert("提示",NullValColumnArr.join("、")+"不能为空！");
		return false;
	}
    var saveObj={
	    sheetId:sheetId,
	    additionSetId:row["rowid"]
	}
	$.extend(saveObj,row);
    var SaveDataArr=[];
    SaveDataArr.push(saveObj);
    $m({
        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
        MethodName: 'handleOrdAdditionSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success'});
            $('#ordAddition').datagrid('reload');
        }else{
	        $.messager.popover({ msg: '保存失败！'+txtData, type: 'error'});
	    }
    })
}
function delOrdAdditionSet(rowid){
	$.messager.confirm('确认','确认是否删除？',function(r){    
	    var SaveDataArr=[rowid];
		$m({
	        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
	        MethodName: 'handleOrdAdditionSet',
	        SaveDataArr:JSON.stringify(SaveDataArr),
	        EVENT:"DELETE"
	    }, function (txtData) {
	        if (txtData == 0) {
	            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
	            $('#ordAddition').datagrid('reload');
	        }
	    })    
    });
}
function delOrdSortSet(rowid){
	$.messager.confirm('确认','确认是否删除？',function(r){    
	    var SaveDataArr=[rowid];
		$m({
	        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
	        MethodName: 'handleOrdSortSet',
	        SaveDataArr:JSON.stringify(SaveDataArr),
	        EVENT:"DELETE"
	    }, function (txtData) {
	        if (txtData == 0) {
	            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
	            $('#sheetOrdSortTab').datagrid('reload');
	        }
	    })    
    });
}
function initPrintFlagCom(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig",
		QueryName:"QuerySheetPrtSignConfig",
		rows:99999
	},function(data){
		$("#cb22,#cb23").combobox({
			editable:false,
			multiple:true,
			rowStyle:'checkbox',
			valueField:"SPSSID",
			textField:"SPSSDesc",
			data:data.rows,
			disabled:true,
			onLoadSuccess:function(){
				$(this).combobox("setValues","");
			}
		})
	})
}
function PrintCheckChange(e,value){
	value=$("#cb19").checkbox("getValue");
	if (value){
		$("#cb22").combobox("enable");
	}else{
		$("#cb22").combobox("setValues","").combobox("disable");
	}
}
function notPrintCheckChange(e,value){
	value=$("#cb20").checkbox("getValue");
	if (value){
		$("#cb23").combobox("enable");
	}else{
		$("#cb23").combobox("setValues","").combobox("disable");
	}
}
function searchOrdCat(value,name){
	$("#dg4").datagrid("unselectAll");	
	value=value.toUpperCase();
	if (value=="") newData=_GV.OrdCatData;
	else {
		var newData=[];
		for (var i=0;i<_GV.OrdCatData.length;i++){
			var Desc=_GV.OrdCatData[i].Desc;
			if (Desc.toUpperCase().indexOf(value)>=0) newData.push(_GV.OrdCatData[i]);
		}
	}
	$("#dg4").datagrid('loadData',{"total":newData.length,rows:newData});
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	if (sheetId){
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"GetFilterSetting",
			rowID:sheetId,
			rows:99999
		},function(data){
			var ordCat=data.OrdCat;
			echoFilterSet(ordCat,"dg4");
		})
	}
}
function searchInstr(value,name){
	$("#dg6").datagrid("unselectAll");	
	value=value.toUpperCase();
	if (value=="") newData=_GV.InstrData;
	else {
		var newData=[];
		for (var i=0;i<_GV.InstrData.length;i++){
			var Desc=_GV.InstrData[i].Desc;
			if (Desc.toUpperCase().indexOf(value)>=0) newData.push(_GV.InstrData[i]);
		}
	}
	$("#dg6").datagrid('loadData',{"total":newData.length,rows:newData});
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	if (sheetId){
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"GetFilterSetting",
			rowID:sheetId,
			rows:99999
		},function(data){
			var ordPhcin=data.OrdPhcin;
			echoFilterSet(ordPhcin,"dg6");
		})
	}
}
function searchSpec(value,name){
	$("#dg8").datagrid("unselectAll");	
	value=value.toUpperCase();
	if (value=="") newData=_GV.SpecData;
	else {
		var newData=[];
		for (var i=0;i<_GV.SpecData.length;i++){
			var Desc=_GV.SpecData[i].Desc;
			if (Desc.toUpperCase().indexOf(value)>=0) newData.push(_GV.SpecData[i]);
		}
	}
	$("#dg8").datagrid('loadData',{"total":newData.length,rows:newData});
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	if (sheetId){
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"GetFilterSetting",
			rowID:sheetId,
			rows:99999
		},function(data){
			var specCode=data.SpecCode;
			echoFilterSet(specCode,"dg8");
		})
	}
}
function searchRecLoc(value,name){
	$("#dg9").datagrid("unselectAll");	
	value=value.toUpperCase();
	if (value=="") newData=_GV.RecLocData;
	else {
		var newData=[];
		for (var i=0;i<_GV.RecLocData.length;i++){
			var Desc=_GV.RecLocData[i].Desc;
			if (Desc.toUpperCase().indexOf(value)>=0) newData.push(_GV.RecLocData[i]);
		}
	}
	$("#dg9").datagrid('loadData',{"total":newData.length,rows:newData});
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	if (sheetId){
		$.cm({
			ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
			MethodName:"GetFilterSetting",
			rowID:sheetId,
			rows:99999
		},function(data){
			var recloc=data.Recloc;
			echoFilterSet(recloc,"dg9");
		})
	}
}
var editRowIndex;
$.extend($.fn.datagrid.defaults, {
	onBeforeDrag: function(row){},	// return false to deny drag
	onStartDrag: function(row){},
	onStopDrag: function(row){},
	onDragEnter: function(targetRow, sourceRow){},	// return false to deny drop
	onDragOver: function(targetRow, sourceRow){},	// return false to deny drop
	onDragLeave: function(targetRow, sourceRow){},
	onBeforeDrop: function(targetRow, sourceRow, point){},
	onDrop: function(targetRow, sourceRow, point){},	// point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
	enableDnd: function(jq, index){
		return jq.each(function(){
			var target = this;
			var state = $.data(this, 'datagrid');
			state.disabledRows = [];
			var dg = $(this);
			var opts = state.options;
			if (index != undefined){
				var trs = opts.finder.getTr(this, index);
			} else {
				var trs = opts.finder.getTr(this, 0, 'allbody');
			}
			trs.draggable({
				disabled: false,
				revert: true,
				cursor: 'pointer',
				proxy: function(source) {
					var index = $(source).attr('datagrid-row-index');
					var tr1 = opts.finder.getTr(target, index, 'body', 1);
					var tr2 = opts.finder.getTr(target, index, 'body', 2);
					var p = $('<div style="z-index:9999999999999"></div>').appendTo('body');
					tr2.clone().removeAttr('id').removeClass('droppable').appendTo(p);
					tr1.clone().removeAttr('id').removeClass('droppable').find('td').insertBefore(p.find('td:first'));
					$('<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>').insertBefore(p.find('td:first'));
					p.find('td').css('vertical-align','middle');
					p.hide();
					return p;
				},
				deltaX: 15,
				deltaY: 15,
				onBeforeDrag:function(e){
					if(editRowIndex!=undefined) return false;
					if (opts.onBeforeDrag.call(target, getRow(this)) == false){return false;}
					if ($(e.target).parent().hasClass('datagrid-cell-check')){return false;}
					if (e.which != 1){return false;}
					opts.finder.getTr(target, $(this).attr('datagrid-row-index')).droppable({accept:'no-accept'});
				},
				onStartDrag: function() {
					$(this).draggable('proxy').css({
						left: -10000,
						top: -10000
					});
					var row = getRow(this);
					opts.onStartDrag.call(target, row);
					state.draggingRow = row;
				},
				onDrag: function(e) {
					var x1=e.pageX,y1=e.pageY,x2=e.data.startX,y2=e.data.startY;
					var d = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
					if (d>3){	// when drag a little distance, show the proxy object
						$(this).draggable('proxy').show();
						var tr = opts.finder.getTr(target, parseInt($(this).attr('datagrid-row-index')), 'body');
						$.extend(e.data, {
							startX: tr.offset().left,
							startY: tr.offset().top,
							offsetWidth: 0,
							offsetHeight: 0
						});
					}
					this.pageY = e.pageY;
				},
				onStopDrag:function(){
					for(var i=0; i<state.disabledRows.length; i++){
						var index = dg.datagrid('getRowIndex', state.disabledRows[i]);
						if (index >= 0){
							opts.finder.getTr(target, index).droppable('enable');
						}
					}
					state.disabledRows = [];
					var index = dg.datagrid('getRowIndex', state.draggingRow);
					dg.datagrid('enableDnd', index);
					opts.onStopDrag.call(target, state.draggingRow);
				}
			}).droppable({
				accept: 'tr.datagrid-row',
				onDragEnter: function(e, source){
					if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false){
						allowDrop(source, false);
						var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(getRow(this));
					}
				},
				onDragOver: function(e, source) {
					var targetRow = getRow(this);
					if ($.inArray(targetRow, state.disabledRows) >= 0){return;}
					var pageY = source.pageY;
					var top = $(this).offset().top;
					var bottom = top + $(this).outerHeight();
					
					allowDrop(source, true);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					if (pageY > top + (bottom - top) / 2) {
						tr.children('td').css('border-bottom','1px solid red');
					} else {
						tr.children('td').css('border-top','1px solid red');
					}
					
					if (opts.onDragOver.call(target, targetRow, getRow(source)) == false){
						allowDrop(source, false);
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(targetRow);
					}
				},
				onDragLeave: function(e, source) {
					allowDrop(source, false);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					opts.onDragLeave.call(target, getRow(this), getRow(source));
				},
				onDrop: function(e, source) {
					var sourceIndex = parseInt($(source).attr('datagrid-row-index'));
					var destIndex = parseInt($(this).attr('datagrid-row-index'));
					
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					var td = tr.children('td');
					var point =  parseFloat(td.css('border-top-width')) ? 'top' : 'bottom';
					td.css('border','');
					
					var rows = dg.datagrid('getRows');
					var dRow = rows[destIndex];
					var sRow = rows[sourceIndex];
					if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false){
						return;
					}
					insert();
					opts.onDrop.call(target, dRow, sRow, point);
					
					function insert(){
						var row = $(target).datagrid('getRows')[sourceIndex];
						var index = 0;
						if (point == 'top'){
							index = destIndex;
						} else {
							index = destIndex+1;
						}
						if (index < sourceIndex){
							dg.datagrid('deleteRow', sourceIndex).datagrid('insertRow', {
								index: index,
								row: row
							});
							dg.datagrid('enableDnd', index);
						} else {
							dg.datagrid('insertRow', {
								index: index,
								row: row
							}).datagrid('deleteRow', sourceIndex);
							dg.datagrid('enableDnd', index-1);
						}
					}
				}
			});
			
			function allowDrop(source, allowed){
				var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
				icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
			}
			function getRow(tr){
				return opts.finder.getRow(target, $(tr));
			}
		});
	}
});
function saveOrdSortSet(ArcimRowID){
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
    if (sheetId==""){
        $.messager.popover({ msg: '请先选择单据！', type: 'error' });
		return false;
    }
    var rows=$("#sheetOrdSortTab").datagrid("getRows");
    var row = rows[editSheetOrdSortIndex];
	row["EOSSArcimDR"]=ArcimRowID;
	if (!row["EOSSSerialNo"]){
		var SerialNo=1;
		for (var i=rows.length-1;i>=0;i--){
			if (rows[i].EOSSSerialNo){
				SerialNo=parseInt(rows[i].EOSSSerialNo)+1;
				break;
			}
		}
		row["EOSSSerialNo"]=SerialNo;
	}
    var saveObj={
	    sheetId:sheetId,
	    sortSetId:row["rowid"]
	}
	$.extend(saveObj,row);
    var SaveDataArr=[];
    SaveDataArr.push(saveObj);
    $m({
        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
        MethodName: 'handleOrdSortSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success'});
            $('#sheetOrdSortTab').datagrid('reload');
        }else{
	        $.messager.popover({ msg: '保存失败！'+txtData, type: 'error'});
	    }
    })
}
function ordSortUp(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '请先保存后再调整顺序!'+txtData, type: 'error'});
		return false;
	}
	var index=$("#sheetOrdSortTab").datagrid("getRowIndex",sortSetId);
	if (index==0) return false;
	var rows=$("#sheetOrdSortTab").datagrid("getRows"); 
	var preRow=rows[index-1];
	var curRow=rows[index];
	var preRowSerialNo=preRow["EOSSSerialNo"];
	var curRowSerialNo=curRow["EOSSSerialNo"];
	preRow["EOSSSerialNo"]=curRowSerialNo;
	curRow["EOSSSerialNo"]=preRowSerialNo;
	$('#sheetOrdSortTab').datagrid('getData').rows[index] = preRow;
    $('#sheetOrdSortTab').datagrid('getData').rows[index - 1] = curRow;
    $('#sheetOrdSortTab').datagrid('refreshRow', index);
    $('#sheetOrdSortTab').datagrid('refreshRow', index - 1).datagrid('selectRow', index - 1);
    saveOrdSortNoChange(curRow,preRow);
}
function ordSortDown(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '请先保存后再调整顺序!'+txtData, type: 'error'});
		return false;
	}
	var index=$("#sheetOrdSortTab").datagrid("getRowIndex",sortSetId);
	var rows=$("#sheetOrdSortTab").datagrid("getRows");
	if (index==(rows.length-1)) return;
	var nextRow=rows[index+1];
	var curRow=rows[index];
	var nextRowSerialNo=nextRow["EOSSSerialNo"];
	var curRowSerialNo=curRow["EOSSSerialNo"];
	nextRow["EOSSSerialNo"]=curRowSerialNo;
	curRow["EOSSSerialNo"]=nextRowSerialNo;
	$('#sheetOrdSortTab').datagrid('getData').rows[index] = nextRow;
    $('#sheetOrdSortTab').datagrid('getData').rows[index + 1] = curRow;
    $('#sheetOrdSortTab').datagrid('refreshRow', index);
    $('#sheetOrdSortTab').datagrid('refreshRow', index + 1).datagrid('selectRow', index + 1);
    saveOrdSortNoChange(curRow,nextRow);
}
function saveOrdSortNoChange(curRow,exchangeRow){
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	var SaveDataArr=[];
    var saveObj={
	    sheetId:sheetId,
	    sortSetId:curRow["rowid"]
	}
	$.extend(saveObj,curRow);
    SaveDataArr.push(saveObj);
    
    var saveObj={
	    sheetId:sheetId,
	    sortSetId:exchangeRow["rowid"]
	}
	$.extend(saveObj,exchangeRow);
    SaveDataArr.push(saveObj);
    $m({
        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
        MethodName: 'handleOrdSortSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
            $('.deletecls1').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
	        $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        $('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
        }else{
	        $.messager.popover({ msg: '保存失败！'+txtData, type: 'error'});
	    }
    })
}
function sheetOrdSortSwitch(e,obj){
	var sheetId="";
    var sheetRows=$("#dg").datagrid("getSelections");
	if(sheetRows.length>0){
		sheetId=sheetRows[0].ID;
	}
	if (sheetId==""){
        $.messager.popover({ msg: '请先选择单据！', type: 'error' });
		return false;
    }
	var val=obj.value?"Y":"N";
	 $m({
        ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
        MethodName: 'saveSheetOrdSortSwitch',
        sheetId:sheetId,
        sheetOrdSortSwitch:obj.value?"Y":"N"
    }, false)
}