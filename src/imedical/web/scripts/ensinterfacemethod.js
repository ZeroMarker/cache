var eventStatus="";
var arrayObj = new Array();
var d = new Dictionary();
var outputNote="";
var typeStatus=""

$(function(){
	Dictionary();
	loadEnsInterfaceMethod();
	// 查询按钮
	$("#methodDataSelectBtn").click(function () {
		reLoadEnsInterfaceMethod();
    });
    // 新增入参
	$("#methodInputAddBtn").click(function () {
		insertinputrow();
    });
    $("#methodOutputAddBtn").click(function () {
		insertoutputrow();
		$('#methodOutputAddBtn').attr("disabled",true);
    });
    //
    $("#methodRelSaveBtn").click(function () {
        var arrAllL = document.getElementById("selectL");
        var arrAllR = document.getElementById("selectR");
        var selectL="",selectR=""
        for (i = 0; i < arrAllL.length; i++) {
            if (arrAllL[i].tagName.toLowerCase() == "option") {
	            if (selectL=="") {
	                selectL=arrAllL[i].value;
	            }
	            else {
	                selectL=selectL+"^"+arrAllL[i].value;
	            }
            }
        }
        for (i = 0; i < arrAllR.length; i++) {
            if (arrAllR[i].tagName.toLowerCase() == "option") {
	            if (selectR=="") {
	                selectR=arrAllR[i].value;
	            }
	            else {
	                selectR=selectR+"^"+arrAllR[i].value;
	            }
            }
        }
    	var row = $('#methodListDg').datagrid('getSelected');
        var input=row["id"]+"@"+selectR;
		input=encodeURI(input);
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveEnsInMethodItem&input="+input,
			dateType: "json",
			success: function(data){
				var dataInfo=data.replace(/[\r\n]/g,"^")
				var arr = new Array();
				arr = dataInfo.split("^^");
				var length=arr.length;
				var obj=eval('('+arr[length-1]+')');				
				if (obj.retvalue=="1") {  
					$.messager.alert('提示','保存成功',"",function(){
						$('#addEnsInterfaceMethod').window('close');
				    });
				}
				else{  
					$.messager.alert('提示',obj.retinfo);
				}
			}
		})
	    
    });
    // 新增按钮
    $("#methodDataAddBtn").click(function () {    
	    eventStatus="add";
	    clearDetailContent();
		$('#methodDataCancleBtn').linkbutton('enable');     // 启用此 button 
		$('#methodDataCancleBtn').attr("disabled",false);
	    $('#methodCode').attr("readOnly",false);
		loadOutputDetail("");
		loadInputDetail("");
		arrayObj=[];
		outputNote="";
		$('#methodDetail').window('open');
    });
    // 保存按钮
	$("#methodDataSaveBtn").click(function () {
		var methodCode=$("#methodCode").val().replace(/\ /g,"");
		if (methodCode=="") {
			$.messager.alert('提示',"请输入方法代码");
			return;
		}
		var methodDesc=$("#methodDesc").val().replace(/\ /g,"");
		methodDesc=replaceTextarea1(methodDesc);
		if (methodDesc=="") {
			$.messager.alert('提示',"请输入方法描述");
			return;
		}	
		var procuctionnameDetail=$('#procuctionnameDetail').combobox('getText').replace(/\ /g,"");
		if (procuctionnameDetail=="") {
			$.messager.alert('提示',"请输入产品组");
			return;
		}	
		var methodStatus=$('#methodStatus').combobox('getValue');
		if (methodStatus=="") {
			$.messager.alert('提示',"请选择当前状态");
			return;
		}	
		var methodType=$('#methodType').combobox('getValue');
		if (methodType=="") {
			$.messager.alert('提示',"请选择方法类型");
			return;
		}	
		var methodClassName=$("#methodClassName").val().replace(/\ /g,"");
		if (methodClassName=="") {
			$.messager.alert('提示',"请输入类名称");
			return;
		}	
		var methodName=$("#methodName").val().replace(/\ /g,"");
		if (methodName=="") {
			$.messager.alert('提示',"请输入方法名称");
			return;
		}
		var methodNote=$("#methodNote").val().replace(/\ /g,"");
		methodNote=replaceTextarea1(methodNote);
		var inputGdRows=$('#inputListDg').datagrid('getRows');
		var outputGdRows=$('#outputListDg').datagrid('getRows');		
		var inputGdInfo="";		
		for (var i=0;i<inputGdRows.length;i++) {
			$('#inputListDg').datagrid('endEdit', i);
			var tmpType=inputGdRows[i]['type'];
			if (("undefined"==typeof(tmpType))||(""==tmpType)) {
				tmpType="undefined";
				continue;
			}
			var tmpFlag=inputGdRows[i]['flag'];
			var tmpDesc=inputGdRows[i]['desc'];
			var tmpDescLong=arrayObj[i];
			var inGdKey="inGd"+i+"=";
			var tmpRowInfo=inGdKey+tmpType+"&"+inGdKey+tmpFlag+"&"+inGdKey+tmpDesc+"&"+inGdKey+tmpDescLong;
			if (""==inputGdInfo) {
				inputGdInfo=tmpRowInfo;
			}else {
				var endFlag="inGd"+(i-1)+"="+"inGd"+i;  //最后一位标志位 记录是否有下一行数据
				inputGdInfo=inputGdInfo+"&"+endFlag+"&"+tmpRowInfo;
			}
		}
		var tOutPutType=""
		var tOutPutDesc=""
		var tOutputLongDesc="";
		for (var i=0;i<outputGdRows.length;i++) {
			$('#outputListDg').datagrid('endEdit', i);
			tOutPutType=outputGdRows[0]['type'];
			if (("undefined"==typeof(tOutPutType))||(""==tOutPutType)) {
				continue;
				//alert(typeof(tOutPutType));
			}
			tOutPutDesc=outputGdRows[0]['desc'];
			tOutputLongDesc=outputNote;
		}
		
		var methodInfo="input="+eventStatus+"&input="+methodCode+"&input="+methodDesc;
		var methodInfo=methodInfo+"&input="+procuctionnameDetail+"&input="+methodStatus+"&input="+methodType;
		var methodInfo=methodInfo+"&input="+methodClassName+"&input="+methodName+"&input="+methodNote;
		var methodInfo=methodInfo+"&input="+tOutPutType+"&input="+tOutPutDesc+"&input="+tOutputLongDesc;
		methodInfo=encodeURI(methodInfo);
		inputGdInfo=encodeURI(inputGdInfo);
		$.ajax({ 
			type: "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData&"+methodInfo+"&"+inputGdInfo,
			dateType: "json",
			success: function(data){
				var dataInfo=data.replace(/[\r\n]/g,"^")
				var arr = new Array();
				arr = dataInfo.split("^^");
				var length=arr.length;
				var obj=eval('('+arr[length-1]+')');				
				if (obj.retvalue=="1") {  
					$.messager.alert('提示','保存成功',"",function(){
						$('#methodInputAddBtn').attr("disabled",false);
						$('#methodOutputAddBtn').attr("disabled",false);
						reLoadEnsInterfaceMethod(); 
						$('#methodDetail').window('close');
				    });
				}
				else{  
					$.messager.alert('提示',obj.retinfo);
				}
			}
		}) 
    });
    // 取消按钮
	$("#methodDataCancleBtn").click(function () {	
		if ($(this).linkbutton('options').disabled == true) {
			return;
		}
	    clearDetailContent();
    });
    
    $('#inputDescDialog').dialog({
	    autoOpen: false,
	    title: '备注',
	    iconCls: 'icon-edit',
	    width: 500,
	    height: 250,
	    closed: true,
	    cache: false,
	    href: '',
	    modal: true,
	    resizable: true,
	    buttons: [{
		    	text: '取消',
		    	iconCls: 'icon-Cancel',
		    	handler: function(){
			    	$.messager.confirm("提示", "您确定要取消当前操作吗？", function (data) {
				    	if (data) {
					    	$('#inputDescDialog').dialog('close');
					    }
				    });
			    }
		    },{
		    	text: '保存',
		    	iconCls: 'icon-Save',
		    	handler: function(){
			    	var tVal=$('#inputDescDialog textarea').val();
			    	tVal=replaceTextarea1(tVal);
			    	var row = $('#inputListDg').datagrid('getSelected');
			    	var index = $('#inputListDg').datagrid('getRowIndex', row)
			    	if (typeStatus=="input") {
				    	arrayObj[index]=tVal;
			    	}
			    	else {
			    		outputNote=tVal;
			    	}
			    	//$('#ff1 table table td[field="descHidden"] table input[type="text"]').val(tVal);
			    	//$('#ff1 table table td[field="desc"] table input[type="text"]').val(tVal);
			    	$('#inputDescDialog').dialog('close');
			    }
		    }
	    ]
	});
	
	$('#inputDescDialogView').dialog({
	    autoOpen: false,
	    title: '查看 字段说明',
	    iconCls: 'icon-tip',
	    width: 500,
	    height: 250,
	    top:'35px',
	    closed: true,
	    cache: false,
	    href: '',
	    modal: true,
	    resizable: true
	});	
})

function loadEnsInterfaceMethod() {
    $('#methodListDg').datagrid({
        title:'方法列表',
        pagination:true,
        fit:true,
        nowrap: false,        
        fitCloumns: true,
        minimized:false,
        striped:true,
        cache:false, 
        method:'get',
        url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodlist',
        singleSelect:true,
		columns:[[   
		    {field:'id',title:'序号',sortable:true,width:60},   
		    {field:'code',title:'方法代码',sortable:true,width:260}, 
		    {field:'desc',title:'方法描述',width:300},  
		    {field:'type',title:'方法类型',width:80},  
		    {field:'productionName',title:'产品组',sortable:true,width:100}, 
		    {field:'status',title:'状态',sortable:true,width:40,
		    	formatter:function(v,rec){
			    	var status="";
		    		if (rec.status=="Y") {
			    		status="运行";
		    		}
		    		else {
			    		status="停用";
		    		}
		    		return status;
		    	}		    
		    }, 
		    {field:'event',title:' ',float:'left',width:250,
		    	formatter:function(v,rec){ 
	                var editBtn = '<a href="#this" class="editcls" onclick="editRow('+(rec.id)+')">修改</a>';
	                var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow('+(rec.id)+')">删除</a>';
	                if (rec.status=="Y") {
	                	var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus('+(rec.id)+')">停用</a>';
	                }
	                else {
	                	var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus('+(rec.id)+')">运行</a>';
	                }
	                var testBtn = '<a href="#this" class="testcls" onclick="testRow('+(rec.id)+')">测试</a>';
	                return editBtn+" "+deleteBtn+" "+statusBtn+" "+testBtn;
	                //return editBtn+" "+deleteBtn+" "+statusBtn;
				}
		    }
		]],
		view: detailview,
		rowStyler: function(index,row){
			if (row.status == 'N'){
				return 'background-color:#6293BB;color:#fff;';
			}
		},
		detailFormatter:function(rowIndex, rowData){
			return "<div id='detailDiv"+rowIndex+"' style='color:black;height:auto;'><div/>"; ;  
		},
		onExpandRow: function(index,row){              
			loadDetailView(row.id,index);	        
		},
	    onLoadSuccess:function(data){  
	        $('.editcls').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
	        $('.deletecls').linkbutton({text:'删除',plain:true,iconCls:'icon-cancel'});
	        $('.testcls').linkbutton({text:'测试',plain:true,iconCls:'icon-ok'});
	        $('.stopcls').linkbutton({text:'停用',plain:true,iconCls:'icon-lock'});
	        $('.startcls').linkbutton({text:'运行',plain:true,iconCls:'icon-lock'});
	        
	        // 列表一列跟二列对齐
	        $('td[field="_expander"] div').css('padding-top','2');
	        $('td[field="_expander"] div').css('padding-right','4');
	        $('td[field="_expander"] div').css('margin-top','1');
	        $('td[field="_expander"] div').css('margin-bottom','1');
	        // 行与行之间对齐
	        $('#divMethodListDg  div[class="datagrid-body"] table tr td[field="desc"] div').css('height','18');
	        $('#divMethodListDg  div[class="datagrid-body"] table tr ').css('height','27');
	    } 
    })
}
function loadDetailView(id,index) {
	var detailHtml="";
	$.ajax({
		type : "get",   
		url : "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=expandMethodDetail&input="+id,   
		dataType: "json",   
		success : function(data) {
			var detailHtml="<table style='width:750px;color:blue;font-size:12px;font-weight:bold;'>";  
			$.each(data,function(i,list){
				if (list.methodType=="classMethod") {
					detailHtml+="<tr><td>调用方法："+list.methodPublishClassName+"</td></tr>";
				}
				else {
					detailHtml+="<tr><td>wsdl地址："+list.wsdlAddress+"</td></tr>";
					detailHtml+="<tr><td>方法名称：DHCWebInterface(KeyName As %String, input1 As %GlobalCharacterStream)</td></tr>";
					//detailHtml+="<tr><td>入参格式描述：KeyName:事件代码,InputParameter:详细内容</td></tr>";
				}
				detailHtml+="<tr><td>入参格式描述："+list.methodInputDesc+"</td></tr>";
				detailHtml+="<tr><td>返回值："+list.methodOutputDesc+"</td></tr>";
				detailHtml+="<tr><td>方法描述："+list.methodDesc+"</td></tr>";
				detailHtml+="<tr><td>备注："+list.methodNote+"</td></tr>";
			});    
			detailHtml+="</table>";
			$('#detailDiv'+index).html(detailHtml);
			$('#methodListDg').datagrid('fixDetailRowHeight',index);
		}
	})
}
function editRow(id) {
    eventStatus="update";
	$('#methodDataCancleBtn').linkbutton('disable'); 
	$('#methodDataCancleBtn').attr("disabled",true);
	$('#methodInputAddBtn').attr("disabled",false);
	arrayObj=[];
	outputNote="";
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodDetail&input="+id,
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			$('#methodCode').attr("readOnly",true);
			$('#methodDataCancleBtn').attr("disabled",true);
			$('#methodCode').val(obj.methodCode);
			var methodDesc=replaceTextarea2(obj.methodDesc);
			$('#methodDesc').val(methodDesc);
			$('#methodClassName').val(obj.methodClassName);
			$('#methodName').val(obj.methodName);
			var methodNote=replaceTextarea2(obj.methodNote);
			$('#methodNote').val(methodNote);			
			$('#procuctionnameDetail').combobox('select',obj.procuctionnameDetail);
			$('#methodStatus').combobox('select',obj.methodStatus);
			$('#methodType').combobox('select',obj.methodType);
			loadInputDetail(id);
			loadOutputDetail(id);
			$('#methodDetail').window('open');
		}
	});
}

function clearDetailContent() {
	/*
	var inputs = document.getElementById("methodDetail").getElementsByTagName("input");  
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].type=="text"){
			if (inputs[i].id=="procuctionnameDetail"){
			    $('#procuctionnameDetail').combobox('clear');
			}
			else{
				inputs[i].value ="";  //text 清空
			}
		}  
    }
    */
    $('#methodCode').val(""); 
    $('#methodName').val("");
    $('#methodClassName').val("");
    $('#procuctionnameDetail').combobox('clear');
    $('#methodStatus').combobox('setValue','Y');
	$("#methodType").combobox('setValue',"classMethod");
    $('textarea').val("");
    //$('#methoDesc').val("");
	$('#methodNote').val("");    
}
function reLoadEnsInterfaceMethod(){
	var methodCode=$("#code").val().replace(/\ /g,"");
	var methodDesc=$("#desc").val().replace(/\ /g,"");
	var procuctionnameDetail=$('#procuctionname').combobox('getText').replace(/\ /g,"");
	var methodStatus=$('#status').combobox('getValue');
	var methodType=$('#type').combobox('getValue');
	var selectInfo=methodCode+"^"+methodDesc+"^"+procuctionnameDetail+"^"+methodStatus+"^"+methodType;
	selectInfo=escape(selectInfo);
	$('#methodListDg').datagrid({ url:"web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodlist&input="+selectInfo,method:"get"});
	$('#methodListDg').datagrid('load');
}
function updateStatus(id) {
	$.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行修改操作吗？", function (data) {
	    if (data) {
		   $.ajax({ 
				type: "get",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=updateMethodStatus&input="+id,
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length
					var obj=eval('('+arr[length-1]+')');
					if (obj.retvalue=="1") {  
						$.messager.alert('提示','修改成功',"",function(){
							reLoadEnsInterfaceMethod(); 
			    		});
					}
					else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			}); 
		}else{
			
		}
	});
}

function deleteRow(id) {
	$.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
        if (data) {
	        $.ajax({ 
				type: "get",
				url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=delMethodData&input="+id,
				dateType: "json",
				success: function(data){
					var dataInfo=data.replace(/[\r\n]/g,"^")
					var arr = new Array();
					arr = dataInfo.split("^^");
					var length=arr.length
					var obj=eval('('+arr[length-1]+')');
					if (obj.retvalue=="0") {
						$.messager.alert('提示','删除成功',"",function(){
							reLoadEnsInterfaceMethod(); 
				    	});
					}
					else{  
						$.messager.alert('提示',obj.retinfo);
					}
				}
			});
        }
    });
}

function editinputrow(target){
	$('#inputListDg').datagrid('beginEdit', getRowIndex(target));
}
function getRowIndex(target){
	var tr = $(target).closest('tr.datagrid-row');
	return parseInt(tr.attr('datagrid-row-index'));
}
function updateInputActions(index){
	$('#inputListDg').datagrid('updateRow',{
		index: index
	});
}
function cancelinputrow(target){
	$('#inputListDg').datagrid('cancelEdit', getRowIndex(target));
}
function saveinputrow(target) {
	$('#inputListDg').datagrid('endEdit', getRowIndex(target));
}

function insertinputrow(){
	var data=$('#inputListDg').datagrid('getData');
	var index=data.total;
	/*
	var total=data.total;
	$('#inputListDg').datagrid('selectRow',total-1);
	var row = $('#inputListDg').datagrid('getSelected');
	var index=$('#inputListDg').datagrid('getRowIndex',row);
	index=index+1;
	alert(index);
	*/
	$('#inputListDg').datagrid('insertRow', {
		index: index,
		row:{
			flag:'N'
		}
	});
	//$('#inputListDg').datagrid('selectRow',index);
	$('#inputListDg').datagrid('beginEdit',index);
	//d.put(index, "入参测试"+index)
	arrayObj.push("")
}
function deleteinputrow(target){
	var index=getRowIndex(target);
	$('#inputListDg').datagrid('selectRow',getRowIndex(target));
	var row = $('#inputListDg').datagrid('getSelected');
	var type=row["type"];
	if (typeof(type) != "undefined") {
		$('#inputListDg').datagrid('deleteRow', index);
	}
	else {
		$('#inputListDg').datagrid('cancelEdit', index);
	}
	var data=$('#inputListDg').datagrid('getData');
	var total=data.total;
	for (i=index;i<total;i++) {
		arrayObj[index]=arrayObj[index+1];
	}
	arrayObj.splice(index,1);
	//var tVal=d.remove(index);
}
function showinputdetail(index) {
	//$('#inputListDg').datagrid('selectRow',index);
	//var row = $('#inputListDg').datagrid('getSelected');
	//var tVal=d.get(index);
	var tVal=arrayObj[index];
	typeStatus="input";
	bindInputDescDialog(tVal);
}
function loadInputDetail(rowId) {
	$('#inputListDg').datagrid({
		nowrap:false,
		singleSelect:true,
		idField:'code',
		method:'Get',
		fit:true,
	    url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=inputType&input='+rowId,
	    columns:[[
		    {field:'type',title:'数据类型',width:170,
				formatter:function(value,rowData){
					return value;
				},	    	
				editor:{
					id:"lookTable",
					type:'combobox',
					options:{
						valueField:'baseType',
						textField:'baseType',
						method:'get',
						url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=baseType'
					}
				}
		    },
			{field:'flag',title:'出参',width:40,align:'center',
				editor:{
					type:'checkbox',
					options:{
						on: 'Y',
						off: 'N'
					}
				}
			},
		    {field:'desc',title:'字段说明',width:230,editor:'text'},
		    // 设置隐藏域
		    {field:'descHidden',title:'字段说明',width:135,editor:'text',hidden:'true'},
			{field:'note',title:'备注',width:40,align:'center',
				formatter:function(value,row,index){
					var s = '<a href="#" onclick="showinputdetail('+(index)+')">Detail</a> ';
					return s;
				}
			},
			{field:'action',title:'',width:40,align:'center',
				formatter:function(value,row,index){
					var d = '<a href="#" onclick="deleteinputrow(this)">Delete</a>';
					return d;
				}
			}
	    ]],
		onBeforeEdit:function(index,row){
			row.editing = true;
			//updateInputActions(index);
		},
		onAfterEdit:function(index,row){
			row.editing = false;
			var methodCode=$("#methodCode").val().replace(/\ /g,"");
			if (methodCode=="") {
				$.messager.alert('提示',"方法代码为空");
				return;
			}
			//updateInputActions(index);
			bindDescTip();
		},
		onCancelEdit:function(index,row){
			var type=row["type"];
			if (typeof(type) == "undefined") {
				$('#inputListDg').datagrid('deleteRow', index)
				return;
			}
			else {
				row.editing = false;
				//updateInputActions(index);
			}
			//bindDescTip();
		},
		onLoadSuccess:function(data){
			bindDescTip();
			var data=$('#inputListDg').datagrid('getData');
			var total=data.total;
			for (i=0;i<total;i++) {
				//d.put(i, "入参测试"+i)
				//alert(total+":"+i);
				//row.editing = false;
				$('#inputListDg').datagrid('beginEdit',i);
				arrayObj.push(data.rows[i].descHidden)
			}
		}
    });
}
function insertoutputrow() {
	var data=$('#outputListDg').datagrid('getData');
	var index=data.total;
	$('#outputListDg').datagrid('insertRow', {
		index: index,
		row:{
			flag:'N'
		}
	});
	$('#outputListDg').datagrid('selectRow',index);
	$('#outputListDg').datagrid('beginEdit',index);
	outputNote="";
}
function editoutputrow(target){
	$('#outputListDg').datagrid('beginEdit', getRowIndex(target));
}
function updateOutputActions(index){
	$('#outputListDg').datagrid('updateRow',{
		index: index
	});
}
function canceloutputrow(target){
	$('#outputListDg').datagrid('cancelEdit', getRowIndex(target));
}
function saveoutputrow(target) {
	$('#outputListDg').datagrid('endEdit', getRowIndex(target));
}
function deleteoutputrow(target){
	var index=getRowIndex(target);
	$('#outputListDg').datagrid('selectRow',getRowIndex(target));
	var row = $('#outputListDg').datagrid('getSelected');
	var type=row["type"];
	if (typeof(type) != "undefined") {
		$('#outputListDg').datagrid('deleteRow', index);
	}
	else {
		$('#outputListDg').datagrid('cancelEdit', index);
	}
	$('#methodOutputAddBtn').attr("disabled",false);
}
function showoutputdetail(index) {
	$('#outputListDg').datagrid('selectRow',index);
	var row = $('#outputListDg').datagrid('getSelected');
	typeStatus="output";
	bindInputDescDialog(outputNote);
}
function loadOutputDetail(rowId) {
	$('#outputListDg').datagrid({
		nowrap:false,
		singleSelect:true,
		idField:'code',
		method:'Get',
		fit:true,
	    url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=outputType&input='+rowId,
	    columns:[[
		    {field:'type',title:'数据类型',width:170,
				formatter:function(value,rowData){
					return value;
				},	    	
				editor:{
					id:"lookTable",
					type:'combobox',
					options:{
						valueField:'baseType',
						textField:'baseType',
						method:'get',
						url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=baseType'
					}
				}
		    },
		    {field:'desc',title:'字段说明',width:260,editor:'text'},
		    // 设置隐藏域
		    {field:'descHidden',title:'字段说明',width:135,editor:'text',hidden:'true'},
			{field:'note',title:'备注',width:40,align:'center',
				formatter:function(value,row,index){
					var e = '<a href="#" onclick="showoutputdetail('+(index)+')">Detail</a> ';
					return e;
				}
			},
			{field:'action',title:'',width:40,align:'center',
				formatter:function(value,row,index){
					var d = '<a href="#" onclick="deleteoutputrow(this)">Delete</a>';
					return d;
				}
			}
	    ]],
		onBeforeEdit:function(index,row){
			row.editing = true;
			updateOutputActions(index);
		},
		onAfterEdit:function(index,row){
			row.editing = false;
			$('#hiddenOutputDesc').val(row['desc']);
			var methodCode=$("#methodCode").val().replace(/\ /g,"");
			if (methodCode=="") {
				$.messager.alert('提示',"方法代码为空");
				return;
			}
			updateOutputActions(index);
			bindOutputDescTip();
		},
		onCancelEdit:function(index,row){
			var type=row["type"];
			$('#methodOutputAddBtn').attr("disabled",false);
			if (typeof(type) == "undefined") {
				$('#outputListDg').datagrid('deleteRow', index)
				return;
			}
			else {
				row.editing = false;
			}
			bindOutputDescTip();
		},
		onLoadSuccess:function(){
			if ("update"==eventStatus){
				var data=$('#outputListDg').datagrid('getData');
				var index=data.total;
				if (index>0) {
					$('#methodOutputAddBtn').attr("disabled",true);
				}
				else {
					$('#methodOutputAddBtn').attr("disabled",false);
				}
			}
			else {
				$('#methodOutputAddBtn').attr("disabled",false);
			}
			var data=$('#outputListDg').datagrid('getData');
			var total=data.total;
			for (i=0;i<total;i++) {
				outputNote=data.rows[i].descHidden;
				$('#outputListDg').datagrid('beginEdit',i);
			}
			bindOutputDescTip();
		}
    });
}
function getMethodCode(){
	var retinfo=""
	$.ajax({
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodCode",
		dateType: "json",
		async: false,
		success: function(data){
			var dataInfo=data.replace(/[\r\n]/g,"^")
			var arr = new Array();
			arr = dataInfo.split("^^");
			var length=arr.length
			var obj=eval('('+arr[length-1]+')');
			if  (obj.retvalue=="0") {
				retinfo=obj.retinfo;
			}
			else {
				$.messager.alert('提示',obj.retinfo);
			}
		}
	});
	return retinfo;
}

function bindInputDescDialog(tVal){
	//$('#ff1 table table td[field="note"] a').on('click',function(){
		//var tVal=$(this).val();
		//var tVal=row["desc"];
		tVal=replaceTextarea2(tVal);
		$('#inputDescDialog textarea').val(tVal);
	    $('#inputDescDialog').dialog("open");
	//});
}

function bindDescTip(){
	var tTR=$('#t1 tr:eq(5) div[class="datagrid-body"] table tr');
	tTR.css('height','25px');
	var tDesc=$('#t1 tr:eq(5) div[class="datagrid-body"] table td[field="desc"] div');
	tDesc.css('height','20px');
}

function bindOutputDescTip(){
	var tDesc=$('#t1 tbody').children(':eq(6)').find('div[class="datagrid-body"] table td[field="desc"] div');
	tDesc.css('height','20px');
}

function replaceTextarea1(str){
	var reg=new RegExp("\n","g");
	var reg1=new RegExp(" ","g");
	str=str.replace(reg,"<br>");
	str=str.replace(reg1,"<p>");
	return str;
}

function replaceTextarea2(str){
	var reg=new RegExp("<br>","g");
	var reg1=new RegExp("<p>","g");
	str=str.replace(reg,"\n");
	str=str.replace(reg1," ");
	return str;
}

function Dictionary(){
	this.data = new Array(); 
	this.put = function(key,value){
		this.data[key] = value;
	};
	this.get = function(key){
		return this.data[key];
	};
	this.remove = function(key){
		this.data[key] = null;
	}; 
	this.isEmpty = function(){
		return this.data.length == 0;
	};
	this.size = function(){
		return this.data.length;
	};
}

function testRow(id) {	
	$.ajax({
		type : "get",   
		url : "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=expandMethodDetail&input="+id,   
		dataType: "json",   
		success : function(data) {
			var detailHtml="<table style='width:600px;color:blue;font-size:12px;font-weight:bold;margin:15 auto;'>"; 
			$.each(data,function(i,list){
				detailHtml+="<tr><td>调用方法：</td><td>"+list.methodPublishClassName+"</td></tr>";	
				var arr = new Array();
				var inputInfo=list.methodInputDesc
				arr = inputInfo.split(",");
				var length=arr.length
				for (i=0;i<length;i++) {
					var inputdesc=arr[i];
					var ar= inputdesc.split(":");
					if (ar[0]=="KeyName(固定值)") {
						detailHtml+="<tr><td style='width:80px'>"+ar[0]+"：</td><td><input class='textbox' type='text' id='"+ar[0]+"' style='width:520px' value='"+ar[1]+"'></input></td></tr>";
					}
					else {
						detailHtml+="<tr><td style='width:80px'>"+ar[0]+"：</td><td><input class='textbox' type='text' id='"+ar[0]+"' style='width:520px'></input></td></tr>";
					}
				}
				detailHtml+="<tr><td></td><td style='text-align:right;'><a id='methodRelBtn' href='#' class='easyui-linkbutton'>方法关联</a>   <a id='testBtn' href='#' class='easyui-linkbutton'>测试</a></td></tr>"
				
				detailHtml+="<tr><td>结果：</td><td><label id='ttile'></label></td></tr>";
			}); 
			detailHtml+="</table>"; 
			$('#testMethod').html(detailHtml);
		    $('#testBtn').linkbutton({   
			    iconCls: 'icon-ok'  
			}); 
		    $('#methodRelBtn').linkbutton({   
			    iconCls: 'icon-edit'  
			}); 
		    $('#testBtn').bind('click', function(){
				var inputInfo="";
				var inputs = document.getElementById("testMethod").getElementsByTagName("input");  
				for(var i=0;i<inputs.length;i++){
					if(inputs[i].type=="text"){
						inputInfo=inputInfo+"&input="+inputs[i].value;
					}
				} 	
				inputInfo="input="+id+inputInfo	
				$.ajax({
					type: "get",
					url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=testMethodResult&"+inputInfo,
					dateType: "json",
					async: false,
					success: function(data){
						var dataInfo=data.replace(/[\r\n]/g,"^")
						var arr = new Array();
						arr = dataInfo.split("^^");
						var length=arr.length
						var obj=eval('('+arr[length-1]+')');
						var detailHtml="<table style='width:500px;color:blue;font-size:12px;font-weight:bold;margin:15 auto;'>"; 
						detailHtml+="<tr><td>"+obj.retinfo+"</td></tr>";
						//detailHtml+="<tr><td>"+inputInfo+"</td></tr>";
						detailHtml+="</table>"; 
						document.getElementById("ttile").innerHTML=detailHtml  
					}
				})
		    }); 
		    $('#methodRelBtn').bind('click', function(){
			    var leftSel = $("#selectL");
				var rightSel = $("#selectR");
				$("#toright").bind("click",function(){		
					leftSel.find("option:selected").each(function(){
						$(this).remove().appendTo(rightSel);
					});
				});
				$("#toleft").bind("click",function(){		
					rightSel.find("option:selected").each(function(){
						$(this).remove().appendTo(leftSel);
					});
				});
				leftSel.dblclick(function(){
					$(this).find("option:selected").each(function(){
						$(this).remove().appendTo(rightSel);
					});
				});
				rightSel.dblclick(function(){
					$(this).find("option:selected").each(function(){
						$(this).remove().appendTo(leftSel);
					});
				});
				$("#sub").click(function(){
					var selVal = [];
					rightSel.find("option").each(function(){
						selVal.push(this.value);
					});
					selVals = selVal.join(",");
					//selVals = rightSel.val();
					if(selVals==""){
						alert("没有选择任何项！");
					}else{
						alert(selVals);
					}
				});
			    loadMethodItemListInfo(id);
				$('#addEnsInterfaceMethod').window('open');
		    });
		}
	})  
	$('#testMethod').window('open');
}

function loadMethodItemListInfo(id){
	$.ajax({ 
		type: "get",
		url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=loadMethodItemListInfo&input="+id,
		dateType: "json",
		success: function(data){
			var obj=eval('('+data+')');
			var lSelectHTML="",rSelectHTML="";
			for (var i=0;i<obj.length;i++){
				if (obj[i].type=="right") {
					rSelectHTML = rSelectHTML+"<option value="+obj[i].id+">"+obj[i].code+"</option>";
				}
				else {
					lSelectHTML = lSelectHTML+"<option value="+obj[i].id+">"+obj[i].code+"</option>";
				}
			}
			$('#selectL').empty();
			$('#selectL').html(lSelectHTML);
			$('#selectR').empty();
			$('#selectR').html(rSelectHTML);
		}
	});
}