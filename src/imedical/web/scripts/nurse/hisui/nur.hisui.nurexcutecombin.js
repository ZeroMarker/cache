var hospID=session['LOGON.HOSPID'],groupID=session['LOGON.GROUPID'],wardID=session['LOGON.WARDID'],locID=session['LOGON.CTLOCID'],userID=session['LOGON.USERID'];
var typeList=[
	{
		value:"0",
		label:$g("医嘱子分类")	
	},{
		value:"1",
		label:$g("医嘱用法")
	},{
		value:"2",
		label:$g("医嘱项")	
	},{
		value:"3",
		label:$g("打印标记")	
	},{
		value:"4",
		label:$g("处置状态")
	},{
		value:"5",
		label:$g("发药状态")	
	},{
		value:"6",
		label:$g("接收科室")	
	},{
		value:"7",
		label:$g("执行设备")	
	},{
		value:"8",
		label:$g("标本名称")	
	}
];
$(function(){
	// 单据
	getSheets("");
	// 类型
	$("#type").combobox({
		valueField:"value",
		textField:"label",
		data:typeList,
		onSelect:function(record){
			$("#itemset").form("load",{Item:[],Order:[]})
			if(record.value=="2"){
				$(".item").hide();
				$(".order").show();
				getLinkOrderData("order","","");	
			}else{
				$(".item").show();
				$(".order").hide();
				getLinkList("item",record.value,"");
			}	
		}	
	});
	$("#type").combobox("setValue","0");
	$("#operType").combobox({
		valueField:"value",
		textField:"label",
		editable:false,
		data:[{value:"F",label:$g("筛选")},{value:"E",label:$g("排除")}]
	});
	$("#operType").combobox("setValue","F");
	getLinkList("item","0","");
	// 初始化table
	initCondition();
	reloadConditionGrid()
	
	initItem();
})
// 获取当前病区单据
function getSheets(sheetId)
{
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"GetCurrentSheets",
		groupID:groupID,
		locId:locID,
		rows:99999
	},function(data){
		$("#sheet").combobox({
			valueField:"rowId",
			textField:"desc",
			data:data,
			onLoadSuccess:function(){
				if(sheetId){
					$(this).combobox("setValue",sheetId);
					sheetId="";	
				}	
			}
		});
	})	
}
// 根据类型获取对应的项目列表
function getLinkList(obj,type,idStr){
	if(type=="0"){ // 医嘱子分类
		getLinkOrdCat(obj,idStr);
	}else if(type=="1"){ // 用法
		getLinkOrdPhcin(obj,idStr);
	}else if(type=="3"){ // 打印标记
		getLinkPrintFlag(obj,idStr);
	}else if(type=="4"){ // 处置状态
		getLinkDispStatus(obj,idStr);
	}else if(type=="5"){ // 发药状态
		getLinkDrugInfo(obj,idStr);
	}else if(type=="6"){ // 接收科室
		getLinkLoc(obj,idStr);
	}else if(type=="7"){
		//renderCombobox(obj,idStr,[{ID:"emergency",Desc:"加急"}]);
		renderCombobox(obj,idStr,[{ID:"PC",Desc:"PC"},{ID:"PDA",Desc:"PDA"}]);
	}else if(type=="8"){ //标本名称
		getLinkSpecimenName(obj,idStr);
	}	
}
// 关联的标本名称
function getLinkSpecimenName(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetSpecimenName",
		HospId:session['LOGON.HOSPID'],
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})		
}
// 关联的发药状态
function getLinkDrugInfo(obj,idStr){
	$HUI.combobox("#"+obj,
	{
		valueField:"value",
		textField:"label",
		multiple:true,
		data:[{value:"TC",label:$g("未发药")},{value:"C",label:$g("已发药")},{value:"PC",label:$g("部分发")}]
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
		renderCombobox(obj,idStr,data);
	})	
}
// 获取关联的用法
function getLinkOrdPhcin(obj,idStr){	
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOrdPhcin",
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})	
}
// 获取关联医嘱列表
function getLinkOrderData(obj,arcItmDR,arcItmName) { 	
	//医嘱类型
	$("#"+obj).combogrid({
		headerCls:'panel-header-gray',
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
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
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
			param = $.extend(param,{arcimdesc:desc,HospId:hospID});
		},
		onLoadSuccess:function(){			 
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	})
}
// 处置状态
function getLinkDispStatus(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		QueryName:"GetDataRelationList",
		hospDR:hospID,
		category:"3", // 处置状态
		transFlag:"Y",
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"rowid",
			textField:"desc",
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
// 关联接收科室
function getLinkLoc(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetLoc",
		rows:99999
	},function(data){
		renderCombobox(obj,idStr,data);
	})		
}
function renderCombobox(obj,idStr,data){
	$("#"+obj).combobox({
		valueField:"ID",
		textField:"Desc",
		data:data.rows ? data.rows : data,
		multiple:true,
		onLoadSuccess:function(){
			if(idStr){
				$(this).combobox("setValues",idStr.split("^"));
				idStr="";	
			}	
		}
	});
}
// 打印标记
function getLinkPrintFlag(obj,idStr){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig",
		QueryName:"QuerySheetPrtSignConfig",
		transFlag:"Y",
		rows:99999
	},function(data){
		$("#"+obj).combobox({
			valueField:"SPSSCode",
			textField:"SPSSDesc",
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
	/*$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllExecuteButton",
		hospId:hospID,
		rows:99999
	},function(data){
		var newData=[];
		var record=data.rows;
		if(record.length>0){
			record.forEach(function(val,index){
				if(val.PrintFlag!=""){
					newData.push(val);	
				}	
			})
		}
		console.log(newData);
		$("#"+obj).combobox({
			valueField:"PrintFlag",
			textField:"PrintFlagDesc",
			data:newData,
			multiple:true,
			onLoadSuccess:function(){
				if(idStr){
					$(this).combobox("setValues",idStr.split("^"));
					idStr="";	
				}	
			}
		});
	})*/
}
// 初始化条件配置
function initCondition(){
	$('#dg').datagrid({
		headerCls:'panel-header-gray',
		fit : true,
		rownumbers:true,
		itColumns:true,
		columns :[[ 
	    	{field:'SheetDesc',title:'单据',width:150},
	    	{field:'Desc',title:'类型'}	    	 
	    ]],
	    ///toolbar:"#conditionset",
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			$("#conditionset").form("clear");
			$("#conditionset").form("load",{Sheet:rowData.sheetId,Condition:rowData.Desc});	
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:"0",Item:[],Order:[]});	
			$("#operType").combobox("setValue","F");
			getLinkList("item","0","");		
			reloadItemGrid(rowData.ID);
		}
	});	
}
function reloadConditionGrid(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetCombinedQuery",
		wardId:wardID,
		groupId:groupID,
		rows:99999
	},function(data){
		$("#dg").datagrid("loadData",data);
	})	
}
// 初始化项目配置
function initItem(){
	$('#dg2').datagrid({
		headerCls:'panel-header-gray',
		fit : true,
		rownumbers:true,
		itColumns:true,
		columns :[[ 
	    	{field:'type',title:'类型',width:150,formatter:function(value,row,index){
		    	var desc=""
		    	var newData=typeList.filter(function(item){
					return value==item.value;	
				})
				if(newData.length>0) desc=newData[0].label;
				return desc;
		    }},
	    	{field:'itemDesc',title:'项目',formatter:function(value,row,index){
		    	return value ? value.replace(/\^/g,"、") : value;	
		    }},
		    {field:'operTypeDesc',title:'操作',formatter:function(value,row,index){
			    return $g(value);
			 }}   	 
	    ]],
	    ///toolbar:"#itemset",
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:rowData.type});
			if(rowData.type=="2"){
				$(".item").hide();
				$(".order").show();
				var itemDesc=rowData.itemDesc.replace("^",",")
				getLinkOrderData("order",rowData.item,itemDesc);	
			}else{
				$(".item").show();
				$(".order").hide();
				getLinkList("item",rowData.type,rowData.item);	
			}
			$("#operType").combobox("setValue",rowData["operType"])
		}
	});	
}
function reloadItemGrid(conditionId){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetCombinedQuerySub",
		CQRowID:conditionId,
		rows:99999
	},function(data){
		$("#dg2").datagrid("loadData",data);
	})	
}
// 条件配置维护
function handleCondition(event,flag){
	var rowID="";
	if(event=="DELETE" || !flag){ // 删除/修改
		var rows=$("#dg").datagrid("getSelections");
		if(rows.length>0){
			rowID=rows[0].ID;	
		}else{
			var msg=event=="DELETE" ? "删除" : "修改";
			return $.messager.popover({ msg: "请选择要"+msg+"的数据！", type:'info' });		
		}
	}
	if(event=="DELETE"){
		$.messager.confirm("简单提示", "确定要删除该条件配置吗", function (r) {
			if (r) {
				setCondition(event,flag,rowID);
			}
		});	
	}else{
		setCondition(event,flag,rowID);	
	}			
}
function setCondition(event,flag,rowID){
	var sheetId=$("#sheet").combobox("getValue");
	var desc=$.trim($("#condition").val());	
	desc=flag==2 ? desc+"-副本" : desc;
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleCondition",
		"rowID":rowID,
		"sheetId":sheetId,
		"desc":desc,
		"wardId":wardID,
		"groupId":groupID,
		"userId":userID,
		"event":event
	},function testget(result){
		var msg=event=="SAVE" ? "保存" : "删除";
		if(result>=0){
			$.messager.popover({ msg: msg+"成功！", type:'success' });
			$('#conditionset').form("clear");
			if(flag==2){ // 复制
				var itemRows=$("#dg2").datagrid("getRows");
				if(itemRows.length>0){
					for(var i=0;i<itemRows.length;i++){
						handleItem(result,"",itemRows[i].type,itemRows[i].item,itemRows[i].operType,"SAVE");
					}			
				}		
			}
			reloadConditionGrid();	
			if(event=="DELETE") $("#dg2").datagrid("loadData",[]);					
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}
	});		
}
// 项目配置维护
function handleCombinedQuerySub(event,flag){
	var selRows=$("#dg").datagrid("getSelections");
	if(selRows.length>0){
		var CQRowID=selRows[0].ID;
		var rowID="";
		if(event=="DELETE" || !flag){ // 删除/修改
			var rows=$("#dg2").datagrid("getSelections");
			if(rows.length>0){
				rowID=rows[0].ID;	
			}else{
				var msg=event=="DELETE" ? "删除" : "修改";
				return $.messager.popover({ msg: "请选择要"+msg+"的数据！", type:'info' });		
			}
		}
		var type=$("#type").combobox("getValue");
		// 判断是否添加重复类型
		var repeatFlag=false;
		var itemRows=$("#dg2").datagrid("getRows");
		if(itemRows.length>0){
			itemRows.forEach(function(val,index){
				if(val.ID!=rowID){
					if(val.type==type) repeatFlag=true;	
				}	
			});	
		}
		if(repeatFlag) return $.messager.popover({ msg: "该类型已存在，请勿重复添加！", type:'alert' });		
		var item="";
		var itemArr=type=="2" ? $("#order").combobox("getValues") : $("#item").combobox("getValues");
		if(itemArr.length>0) item=itemArr.join("^");
		var operType=$("#operType").combobox('getValue');
		handleItem(CQRowID,rowID,type,item,operType,event);	
	}else{
		$.messager.popover({ msg: "请选择条件配置数据！", type:'info' });	
	}		
}
function handleItem(CQRowID,rowID,type,item,operType,event){
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		MethodName:"HandleCombinedQuerySub",
		"CQRowID":CQRowID,
		"rowID":rowID,
		"type":type,
		"item":item,
		"userId":userID,
		"operType":operType,
		"event":event
	},function testget(result){
		var msg=event=="SAVE" ? "保存" : "删除";
		if(result==0){
			$.messager.popover({ msg: msg+"成功！", type:'success' });
			$("#itemset").form("clear");
			$("#itemset").form("load",{Type:"0",Item:[],Order:[]});
			$("#type").combobox("setValue","0");	
			getLinkList("item","0","");	
			$("#operType").combobox("setValue","F");	
			reloadItemGrid(CQRowID);								
		}else{
			$.messager.popover({ msg: msg+"失败！", type:'error' });	
		}
	});	
}
// 复制
function copy(){
	var selRows=$("#dg").datagrid("getSelections");
	if(selRows.length>0){
		handleCondition("SAVE",2);		
	}else{
		$.messager.popover({ msg: "请选择要复制的条件配置！", type:'info' });
	}
}
	