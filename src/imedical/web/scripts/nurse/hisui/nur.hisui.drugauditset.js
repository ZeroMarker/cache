$(function() {
	hospComp = GenHospComp("Nur_IP_NurseSetNew",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;    	
       	editIndex=undefined,editIndex2=undefined,editIndex3=undefined,editIndex4=undefined;
       	saveFlag=false,saveFlag2=false,saveFlag3=false,saveFlag4=false;
       	reloadGridData("dg","durgauditnew","west","");
       	reloadGridData("dg2","durgauditnew","north","");
       	reloadGridData("dg3","durgauditnew","south","");
       	reloadGridData("dg4","durgauditnew","error","");
       	reloadGridData("","durgauditnew","period",0);
		reloadGridData("","durgauditnew","other",0);
		reloadGridData("","durgauditnew","other",1);
	}  ///选中事件	
	
	initUI();
	//修正查询设置、其他设置-保存按钮在极简模式下，保存按钮名称与保存图标错位显示
	if (HISUIStyleCode=="lite"){
		$("#accPanel .icon-save,#accPanel2 .icon-save").css("padding-top","0");
		$("#accPanel .icon-save,#accPanel2 .icon-save").css("margin-left","0");
	}
})

// 初始化页面
function initUI(){
	// 查询条件
	initConditionTable();
	reloadGridData("dg","durgauditnew","west","");
	// 药品查询
	initDrugTable();
	reloadGridData("dg2","durgauditnew","north","");
	// 明细查询
	initDetailTable();
	reloadGridData("dg3","durgauditnew","south","");
	// 审核控制
	initAuditTable();
	reloadGridData("dg4","durgauditnew","error","");
	// 查询时间
	reloadGridData("","durgauditnew","period",0);
	// 其他设置
	reloadGridData("","durgauditnew","other",0);
	reloadGridData("","durgauditnew","other",1);
	loadAuthItemHtml();
}
// 初始化查询条件
function initConditionTable(){
	$('#dg').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'标签',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'字段',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'选中',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	        {field:'field4',title:'隐藏',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'顺序',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
		            if(editIndex!=undefined){
			            // 有编辑行，新增时保存编辑行，1：增加新的编辑行
						saveGridData("dg","durgauditnew","west","",1,editIndex);
					}else{
						addData("dg","durgauditnew","west","");	
					}					
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	deleteData("dg","durgauditnew","west");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	saveGridData("dg","durgauditnew","west","","",editIndex);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex!=undefined)&&(editIndex!=rowIndex)&&!saveGridData("dg","durgauditnew","west","","",editIndex)) return;
			$('#dg').datagrid("endEdit",editIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag) return;
			editIndex=rowIndex;
			$('#dg').datagrid("beginEdit", editIndex);			
		}
	});	
}
// 初始化药品查询
function initDrugTable(){
	$('#dg2').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'标签',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'字段',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'宽度',width:90,editor:{type:'numberbox'}},
	        {field:'field4',title:'隐藏',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'顺序',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editIndex2!=undefined){
			            // 有编辑行，新增时保存编辑行，1：增加新的编辑行
						saveGridData("dg2","durgauditnew","north","",1,editIndex2);
					}else{
						addData("dg2","durgauditnew","north","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
	            	deleteData("dg2","durgauditnew","north");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	saveGridData("dg2","durgauditnew","north","","",editIndex2);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex2!=undefined)&&(editIndex2!=rowIndex)&&!saveGridData("dg2","durgauditnew","north","","",editIndex2)) return;
			$('#dg2').datagrid("endEdit",editIndex2);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag2) return;
			editIndex2=rowIndex;
			$('#dg2').datagrid("beginEdit", editIndex2);			
		}
	});	
}
// 初始化明细查询
function initDetailTable(){
	$('#dg3').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'标签',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'字段',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'宽度',width:90,editor:{type:'numberbox'}},
	        {field:'field4',title:'隐藏',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'顺序',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editIndex3!=undefined){
			            // 有编辑行，新增时保存编辑行，1：增加新的编辑行
						saveGridData("dg3","durgauditnew","south","",1,editIndex3);
					}else{
						addData("dg3","durgauditnew","south","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	deleteData("dg3","durgauditnew","south");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	saveGridData("dg3","durgauditnew","south","","",editIndex3);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex3!=undefined)&&(editIndex3!=rowIndex)&&!saveGridData("dg3","durgauditnew","south","","",editIndex3)) return;
			$('#dg3').datagrid("endEdit",editIndex3);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag3) return;
			editIndex3=rowIndex;
			$('#dg3').datagrid("beginEdit", editIndex3);			
		}
	});	
}
// 初始化审核控制
function initAuditTable(){
	$('#dg4').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'标签',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'字段',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'颜色',width:90,editor:{type:'text'},styler: function(value,row,index){				
				return 'background-color:'+value;				
			}},
	        {field:'field4',title:'控制',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'顺序',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
					if(editIndex4!=undefined){
			            // 有编辑行，新增时保存编辑行，1：增加新的编辑行
						saveGridData("dg4","durgauditnew","error","",1,editIndex4);
					}else{
						addData("dg4","durgauditnew","error","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	deleteData("dg4","durgauditnew","error");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '保存',
            	handler: function () {
                	saveGridData("dg4","durgauditnew","error","","",editIndex4);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex4!=undefined)&&(editIndex4!=rowIndex)&&!saveGridData("dg4","durgauditnew","error","","",editIndex4)) return;
			$('#dg4').datagrid("endEdit",editIndex4);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag4) return;
			editIndex4=rowIndex;
			$('#dg4').datagrid("beginEdit", editIndex4);
			var ed = $('#dg4').datagrid('getEditor', {index:editIndex4,field:'field3'});
			$(ed.target).color({
				editable:true,
				width:90,
				height:30
			});			
		}
	});	
}
// 加载表数据
function reloadGridData(obj,index1,index2,index3,flag){
	$.cm({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		QueryName:"FindData",
		hospID:hospID,
		index1:index1,
		index2:index2,
		index3:index3,
		rows:99999
	},function(data){
		console.log(data);
		if(obj){
			$("#"+obj).datagrid('loadData',data);
			if(flag) addData(obj,index1,index2,index3);	
		}else{
			var record=data.rows;
			if(record.length>0){
				if(index2=="period"){
					// 查询时间		
					$("#rowid").val(record[0].rowid);	
					$("#start").numberbox('setValue',record[0].field3);
					$('#startTime').timespinner('setValue',record[0].field5); 
					$("#end").numberbox('setValue',record[0].field4);
					$('#endTime').timespinner('setValue',record[0].field6);		
				}else{
					// 其他设置	
					if(index3===0){
						$("#rowid2").val(record[0].rowid);
						if(record[0].field3=="Y"){
							$("#cb").checkbox("check");
						}else{
							$("#cb").checkbox("uncheck");
						}
						if(record[0].field4=="Y"){
							$("#cb6").checkbox("check");
						}else{
							$("#cb6").checkbox("uncheck");
						}	
						/*if(record[0].field5=="Y"){
							$("#cb7").checkbox("check");
						}else{
							$("#cb7").checkbox("uncheck");
						}
						if(record[0].field7=="Y"){
							$("#cb8").checkbox("check");
						}else{
							$("#cb8").checkbox("uncheck");
						}*/
						if(record[0].field8=="Y"){
							$("#cb9").switchbox("setValue",true);
							$("#cb11,#cb10").radio("enable");
						}else{
							$("#cb9").switchbox("setValue",false);
						}
						if(record[0].field9=="Y"){
							$("#cb10").radio("check");
						}else{
							$("#cb10").radio("uncheck");
						}
						if(record[0].field10=="Y"){
							$("#cb11").radio("check");
						}else{
							$("#cb11").radio("uncheck");
						}
						
						if(record[0].field11=="Y"){
							$("#cb12").radio("check");
						}else{
							$("#cb12").radio("uncheck");
						}
						if(record[0].field12=="Y"){
							$("#cb13").radio("check");
						}else{
							$("#cb13").radio("uncheck");
						}
						if(record[0].field13=="Y"){
							$("#cb14").radio("check");
						}else{
							$("#cb14").radio("uncheck");
						}
						if(record[0].field14=="Y"){
							$("#cb15").radio("check");
						}else{
							$("#cb15").radio("uncheck");
						}
						if(record[0].field15=="Y"){
							$("#cb16").checkbox("check");
						}else{
							$("#cb16").checkbox("uncheck");
						}
						
					}else{
						$("#rowid3").val(record[0].rowid);
						if(record[0].field3=="Y"){
							$("#cb2").checkbox("check");
						}else{
							$("#cb2").checkbox("uncheck");
						}
						if(record[0].field4=="Y"){
							$("#cb3").checkbox("check");
						}else{
							$("#cb3").checkbox("uncheck");
						}	
						if(record[0].field5=="Y"){
							$("#cb4").checkbox("check");
						}else{
							$("#cb4").checkbox("uncheck");
						}
						if(record[0].field6=="Y"){
							$("#cb5").checkbox("check");
						}else{
							$("#cb5").checkbox("uncheck");
						}
					}
				}
			}			
		}		
	})	
}

// 判断序号是否重复
function ifRepeat(records, repeatValue,curRowid) {
	var count = 0;
	for (var i = 0; i < records.length; i++) {
		if(records[i].rowid!=curRowid){
			if (repeatValue && repeatValue == records[i].field2) {
				count++;
				if (count > 0) {
					return true;
				}			
			}	
		}		
	}
	return false;	
}
// 查询条件新增/保存
var editIndex,editIndex2,editIndex3,editIndex4;
function addData(obj,index1,index2,index3){
	var index=$('#'+obj).datagrid('getRows').length;
	if(obj=="dg") editIndex=index;
	if(obj=="dg2") editIndex2=index;
	if(obj=="dg3") editIndex3=index;
	if(obj=="dg4") editIndex4=index;
	var row={
		rowid:"",
		index3:"",
		field1:"",
		field2:"",
		field3:"",
		field4:"",
		field5:"",
		field6:""
	};
	$('#'+obj).datagrid("insertRow", {row: row}).datagrid("beginEdit", index).datagrid("selectRow",index);
	var ed = $('#dg4').datagrid('getEditor', {index:index,field:'field3'});
	$(ed.target).color({
		editable:true,
		width:90,
		height:30
	});	
}
var saveFlag=false,saveFlag2=false,saveFlag3=false,saveFlag4=false;
// 保存行数据
function saveGridData(obj,index1,index2,index3,flag,curEditIndex) {
	if (curEditIndex==undefined) {
		return $.messager.popover({msg: '无需要保存的数据！',type:'alert'});
	}
	var rowid="",field1="",field2="",field3="",field4="",field5="",field6="";
	var records=$("#"+obj).datagrid("getRows");
	var rowEditors=$('#'+obj).datagrid('getEditors',curEditIndex);	
	rowid=$(rowEditors[0].target).val();
	field1=$.trim($(rowEditors[1].target).val());
	index3=$.trim($(rowEditors[2].target).val());
	if(obj=="dg") field3=$(rowEditors[3].target).radio("getValue") ? "Y" : "";	
	if(obj=="dg2" || obj=="dg3") field3=$(rowEditors[3].target).numberbox("getValue");
	if(obj=="dg4") field3=$(rowEditors[3].target).color("getValue");
	field4=$(rowEditors[4].target).radio("getValue") ? "Y" : "";
	field2=$.trim($(rowEditors[5].target).numberbox("getValue"));
	var isInvalid=false;
	if (field1=="" || index3=="") {
		$.messager.popover({ msg: '标签和字段不能为空！', type:'alert' });
		isInvalid=true;
	}
	if (ifRepeat(records,field2,rowid)) {
		$.messager.popover({ msg: '该顺序号已存在，请核实！', type:'alert' });
		isInvalid=true;
	}
	if(!isInvalid){
		if(obj=="dg") saveFlag=false;
		if(obj=="dg2") saveFlag2=false;
		if(obj=="dg3") saveFlag3=false;
		if(obj=="dg4") saveFlag4=false;
	}else{
		if(obj=="dg") saveFlag=true;
		if(obj=="dg2") saveFlag2=true;
		if(obj=="dg3") saveFlag3=true;
		if(obj=="dg4") saveFlag4=true;
		return;
	}
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6;
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"SaveData",
		parr:parr,
		hospID:hospID,
		UserID:session['LOGON.USERID']
	},function testget(result){			
		if(result>0){
			$('#'+obj).datagrid("endEdit", curEditIndex);
			if(obj=="dg") editIndex=undefined;	
			if(obj=="dg2") editIndex2=undefined;	
			if(obj=="dg3") editIndex3=undefined;	
			if(obj=="dg4") editIndex4=undefined;	
			// flag判断是否新增，新增时保存当前编辑行，列表重新加载后添加新的编辑行	
			reloadGridData(obj,index1,index2,"",flag);
			return true;	
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
			return false;
		}
	});
}
// 保存查询时间/其他设置	
function saveTime(index1,index2){
	var rowid="",index3=0,field1="",field2="",field3="",field4="",field5="",field6="";
	rowid=$.trim($("#rowid").val());	
	field3=$.trim($("#start").numberbox("getValue"));
	field5=$.trim($('#startTime').timespinner('getValue'));  
	field4=$.trim($("#end").numberbox("getValue"));
	field6=$.trim($('#endTime').timespinner('getValue'));
	if(field3=="" || field4=="" || field5=="" || field6==""){
		return $.messager.popover({ msg: '查询时间不能为空！', type:'alert' });
	}
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6;
	save(parr);
}
function saveOther(index1,index2){
	// 成组审核、领药审核前需处理接受或完成医嘱、今日新开医嘱处理接受或完成后自动领药审核、是否显示未处理医嘱
	var rowid="",index3=0,field1="",field2="",field3="",field4="",field5="",field6="",field7="";	
	rowid=$.trim($("#rowid2").val());
	field3=$("#cb").radio("getValue") ? "Y" : "";	
	field4=$("#cb6").radio("getValue") ? "Y" : ""; 
	field5=""; //$("#cb7").radio("getValue") ? "Y" : "";
	field7=""; //$("#cb8").radio("getValue") ? "Y" : "";
	field8=$("#cb9").switchbox("getValue") ? "Y" : "";
	field9=$("#cb10").radio("getValue") ? "Y" : "";
	field10=$("#cb11").radio("getValue") ? "Y" : "";
	
	field11=$("#cb12").radio("getValue") ? "Y" : "";
	field12=$("#cb13").radio("getValue") ? "Y" : "";
	field13=$("#cb14").radio("getValue") ? "Y" : "";
	field14=$("#cb15").radio("getValue") ? "Y" : "";
	field15=$("#cb16").checkbox("getValue") ? "Y" : "";
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6+"^"+field7+"^"+field8+"^"+field9+"^"+field10+"^"+field11+"^"+field12+"^"+field13+"^"+field14+"^"+field15;
	save(parr);
	// 库存提示、库存控制、包含已审未发提示、包含已审未发控制
	rowid=$.trim($("#rowid3").val());
	index3=1;
	field3=$("#cb2").radio("getValue") ? "Y" : "";	
	field4=$("#cb3").radio("getValue") ? "Y" : ""; 
	field5=$("#cb4").radio("getValue") ? "Y" : "";
	field6=$("#cb5").radio("getValue") ? "Y" : "";
	var parr2=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6+"^"+field7+"^"+field8+"^"+field9+"^"+field10+"^"+field11+"^"+field12+"^"+field13+"^"+field14+"^"+field15;
	save(parr2);
}
function save(parr){
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"SaveData",
		parr:parr,
		hospID:hospID,
		UserID:session['LOGON.USERID']
	},function testget(result){			
		if(result>0){
			$.messager.popover({ msg: "保存成功！", type:'success' });	
			loadAuthItemHtml();	
		}else{	
			$.messager.popover({ msg: "保存失败", type:'error' });	
		}
	});	
}
// 删除配置数据
function deleteData(obj,index1,index2){	
	var rows=$("#"+obj).datagrid("getSelections");
	if(rows.length>0){
    	$.messager.confirm("简单提示", "确定要删除该配置数据吗？", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.DrugAudit.Setting",
					MethodName:"DeleteData",
					rw:rows[0].rowid
				},function testget(result){			
					if(result>0){
						$.messager.popover({ msg: "删除成功！", type:'success' });
						reloadGridData(obj,index1,index2,"");		
					}else{	
						$.messager.popover({ msg: "删除失败！", type:'error' });	
					}
				});
			}
		});
    }else{
        $.messager.popover({ msg: "请选择要删除的配置数据！", type:'info' });	
    }		
}
function stockControlCheck(){
	$("#cb2").checkbox("check");
}
function stockAlertUnCheck(){
	$("#cb3").checkbox("uncheck");
}
function inTheWayControlCheck(){
	$("#cb4").checkbox("check");
}
function inTheWayAlertUnCheck(){
	$("#cb5").checkbox("uncheck");
}
function switchChangeHandle(e,obj){
	if (obj.value){
		$("#cb11,#cb10").radio("enable");
	}else{
		$("#cb11,#cb10").radio("uncheck").radio("disable");
	}
}
function loadAuthItemHtml(){
    $cm({ClassName:"Nur.NIS.Service.DrugAudit.Setting",MethodName:"getAuthItem"},function(dataArr){
	    for (var i=0;i<dataArr.length;i++){
		    var rtn=$m({
		        ClassName: "BSP.SYS.SRV.AuthItemApply",
		        MethodName: 'GetStatusHtml',
		        AuthCode:dataArr[i].authCode
		    }, false);
		    if (rtn!=""){
			    $(".icon-stamp").remove();
				$(rtn).insertAfter('#'+dataArr[i].itemId+' + label');
			}
		}
	})
}