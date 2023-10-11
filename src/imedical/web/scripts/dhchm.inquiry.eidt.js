/**
 * ����֪ʶ��ά��  dhchm.inquiry.eidt.js
 * @Author   wangguoying
 * @DateTime 2021-05-08
 */

$("#S_TypeCode").keydown(function(e){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		type_find_onclick();
	}
});
$("#S_TypeDesc").keydown(function(e){
	 var Key=websys_getKey(e);
	if ((13==Key)) {
		type_find_onclick();
	}
});
$("#S_ResultCode").keydown(function(e){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		result_find_onclick();
	}
});
$("#S_ResultDesc").keydown(function(e){
	 var Key=websys_getKey(e);
	if ((13==Key)) {
		result_find_onclick();
	}
});

$HUI.datagrid("#TypeList",{
	url:$URL,
	title:"",
	border:false,
	bodyCls:'panel-body-gray',
	singleSelect:true,
	queryParams:{
		ClassName:"web.DHCPE.HM.Inquiry",
		QueryName:"QueryType"
	},
	onSelect:function(rowIndex,rowData){
		init_result_datagird();
	},
	onDblClickRow:function(index,row){
		edit_type();														
	},	
	onLoadSuccess:function(data){
		init_result_datagird();
	},
	columns:[[
		{field:'TRowID',hidden:true,sortable:'true'},
		{field:'Operation',width:50,title:'����',align:'center',
			formatter:function(value,row,index){
				return "<a href='#' onclick='delete_type(\""+row.TRowID+"\")'>\
				<img style='padding-top:4px;' title='ɾ��' alt='ɾ��' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
				</a>";

			}
                    
		},
		{field:'TCode',width:100,title:'����'},
		{field:'TDesc',width:150,title:'����'},
		{field:'TSort',width:80,title:'˳���',align:"center"}
	]],
	fitColumns:true,
	pagination:true,
	pageSize:20,
	fit:true,
	toolbar:[
	{
		iconCls:'icon-add',
		text:'����',
		handler:function(){
			win_clean();
			$("#Win_H_Type").val("TYPE");
			$("#TypeEidtDialog").panel("setTitle","��������");
			$("#RelateTR").hide();
			$("#TypeEidtDialog").dialog("open");
		}
	},{
		iconCls:'icon-edit',
		text:'�༭',
		handler:function(){
			edit_type();
		}
	}]
});


function type_find_onclick(){
	var sCode = $("#S_TypeCode").val();
	var sDesc = $("#S_TypeDesc").val();
	$("#TypeList").datagrid("load",{
		ClassName:"web.DHCPE.HM.Inquiry",
		QueryName:"QueryType",
		Code:sCode,
		Desc:sDesc
	});
}

function result_find_onclick(){
	var row = $("#TypeList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({msg:"��ѡ����������",type:"alert",timeout:2000});
		return false;
	}
	var sCode = $("#S_ResultCode").val();
	var sDesc = $("#S_ResultDesc").val();
	$("#ResultList").datagrid("load",{
		ClassName:"web.DHCPE.HM.Inquiry",
		QueryName:"QueryResult",
		ParRef:row.TRowID,
		Code:sCode,
		Desc:sDesc
	});
}

/**
 * [�༭����]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function edit_type(){
	var row = $("#TypeList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({msg:"��ѡ����Ҫ�޸ĵļ�¼",type:"alert",timeout:1000});
		return false;
	}
	win_clean();
	$("#RelateTR").hide();
	$("#Win_H_Type").val("TYPE");
	$("#Win_H_ID").val(row.TRowID);
	$("#Win_Code").val(row.TCode);
	$("#Win_Desc").val(row.TDesc);
	$("#Win_Sort").val(row.TSort);
	$("#TypeEidtDialog").panel("setTitle","��������");
	$("#TypeEidtDialog").dialog("open");
}


/**
 * [���ڱ����¼�]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function win_save(){
	var type = $("#Win_H_Type").val();
	var id = $("#Win_H_ID").val();
	var code = $("#Win_Code").val();
	var desc = $("#Win_Desc").val();
	var sort = $("#Win_Sort").val();
	if(!$("#Win_Code").validatebox("isValid") || !$("#Win_Desc").validatebox("isValid") || !$("#Win_Sort").validatebox("isValid")){
		$.messager.popover({msg:"������Ϊ��",type:"error",timeout:2000});
		return false;
	}
	var ret = "";
	if(type == "TYPE") { //����
		var properties = "ITCode^ITDesc^ITSort";
		var inString = code+"^"+desc+"^"+sort; 
		ret = tkMakeServerCall("User.DHCHMInquiryType","SaveData",id,inString,properties);
	}else{ //���
		var properties = "IRParRef^IRCode^IRDesc^IRSort^IRClassName^IRMethodName";
		var parRefRow = $("#TypeList").datagrid("getSelected");
		if(parRefRow == null){
			$.messager.popover({msg:"��ѡ����������",type:"error",timeout:2000});
			return false;
		}
		var clsName = $("#Win_Class").combotree("getValue");
		var methodName = $("#Win_Method").combobox("getValue");
		var inString = parRefRow.TRowID+"^"+code+"^"+desc+"^"+sort+"^"+clsName+"^"+methodName; 
		ret = tkMakeServerCall("User.DHCHMInquiryResult","SaveData",id,inString,properties);
	}
	var tmp = ret.split("^");
	if(parseInt(tmp[0]) < 0){
		$.messager.alert("��ʾ",tmp[1],"error");
		return false;
	}else{
		$.messager.popover({msg:"����ɹ�",type:"success",timeout:1000});
		$("#TypeEidtDialog").dialog("close");
		if(type == "TYPE"){
			$("#TypeList").datagrid("reload");
			$("#TypeList").datagrid("clearSelections");
		}
		init_result_datagird();
	}
}


/**
 * [ɾ������]
 * @param    {[int]}    id [����ID]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function delete_type(id){
	$.messager.confirm("ɾ��","ȷ��ɾ����������<lable style='color:red'>�ò����Ὣ������������һ��ɾ����</label>",function(r){
		if(r){
			var ret = tkMakeServerCall("User.DHCHMInquiryType","Delete",id);
			var tmp = ret.split("^");
			if(parseInt(tmp[0]) < 0){
				$.messager.alert("��ʾ",tmp[1],"error");
				return false;
			}else{
				$.messager.popover({msg:"ɾ���ɹ�",type:"success",timeout:1000});
				$("#TypeList").datagrid("reload");
				$("#TypeList").datagrid("clearSelections");
				init_result_datagird();
			}
		}
	});	
}

/**
 * [�༭��������]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function win_clean(){
	$("#Win_H_Type").val("");
	$("#Win_H_ID").val("");
	$("#Win_Code").val("");
	$("#Win_Desc").val("");
	$("#Win_Sort").val("");
	$("#Win_Class").combotree("setValue","");
	$("#Win_Method").combobox("setValue","");
}

/**
 * [��ʼ������б�]
 * @param    {[int]}    index 	[������ɺ��Զ�ѡ�е�������]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function init_result_datagird(index){
	$("#S_ResultCode").val("");
	$("#S_ResultDesc").val("");
	$("#Introduce").val("");
	$("#Advice").val("");
	$("#Remark").val("");
	var row = $("#TypeList").datagrid("getSelected");
	var parRef = row==null?"":row.TRowID;
	$HUI.datagrid("#ResultList",{
		url:$URL,
		title:"",
		border:false,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCPE.HM.Inquiry",
			QueryName:"QueryResult",
			ParRef:parRef
		},
		onSelect:function(rowIndex,rowData){
			$("#Introduce").val(rowData.TIntroduce);
			$("#Advice").val(rowData.TAdvice);
			$("#Remark").val(rowData.TRemark);
		},
		onDblClickRow:function(index,row){
			edit_result();														
		},	
		onLoadSuccess:function(data){
			if(index != undefined && index >= 0 ){
				$(this).datagrid("selectRow",index);
			}
		},
		columns:[[
			{field:'TRowID',hidden:true,sortable:'true'},
			{field:'Operation',width:80,title:'����',align:'center',
				formatter:function(value,row,index){
					return "<a href='#' onclick='delete_result(\""+row.TRowID+"\")'>\
					<img style='padding-top:4px;' title='ɾ��' alt='ɾ��' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
					</a>\
					<a href='#' onclick='relate_detail(\""+row.TRowID+"\",\""+row.TDesc+"\")'>\
						<img style='padding-top:4px;margin-left:4px;' title='�����ʾ�' alt='�����ʾ�' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_switch.png' border=0/>\
					</a>";

				}
	                    
			},
			{field:'TCode',width:100,title:'����'},
			{field:'TDesc',width:150,title:'����'},
			{field:'TSort',width:80,title:'˳���',align:"center"},
			{field:'TClassName',width:100,title:'����'},
			{field:'TMethodName',width:100,title:'������'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		toolbar:[
		{
			iconCls:'icon-add',
			text:'����',
			handler:function(){
				win_clean();
				$("#Win_H_Type").val("RESULT");
				$("#TypeEidtDialog").panel("setTitle","������");
				$("#RelateTR").fadeIn();
				initClass();
				$("#TypeEidtDialog").dialog("open");
			}
		},{
			iconCls:'icon-edit',
			text:'�༭',
			handler:function(){
				edit_result();
			}
		}]
	});
}


/**
 * [ɾ�����]
 * @param    {[int]}    id [���ID]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function delete_result(id){
	$.messager.confirm("ɾ��","ȷ��ɾ���ý����",function(r){
		if(r){
			var ret = tkMakeServerCall("User.DHCHMInquiryResult","Delete",id);
			var tmp = ret.split("^");
			if(parseInt(tmp[0]) < 0){
				$.messager.alert("��ʾ",tmp[1],"error");
				return false;
			}else{
				$.messager.popover({msg:"ɾ���ɹ�",type:"success",timeout:1000});
				init_result_datagird();
			}
		}
	});	
}

/**
 * [�༭���]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function edit_result(){
	var row = $("#ResultList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({msg:"��ѡ����Ҫ�޸ĵļ�¼",type:"alert",timeout:1000});
		return false;
	}
	win_clean();
	$("#RelateTR").fadeIn();
	initClass();
	$("#Win_H_Type").val("RESULT");
	$("#Win_H_ID").val(row.TRowID);
	$("#Win_Code").val(row.TCode);
	$("#Win_Desc").val(row.TDesc);
	$("#Win_Sort").val(row.TSort);
	$("#Win_Class").combotree("setValue",row.TClassName);
	$("#Win_Method").combobox("setValue",row.TMethodName);
	$("#TypeEidtDialog").panel("setTitle","������");
	$("#TypeEidtDialog").dialog("open");
}

/**
 * [��������]
 * @Author   wangguoying
 * @DateTime 2021-05-10
 */
function detail_save(){
	 
	var row = $("#ResultList").datagrid("getSelected");
	
	if(row == null){
		$.messager.popover({msg:"��ѡ����Ҫ����ļ�¼",type:"alert",timeout:1000});
		return false;
	}
	var index = $("#ResultList").datagrid("getRowIndex",row);
	var introduce = $("#Introduce").val();
	var advice = $("#Advice").val();
	var remark = $("#Remark").val();
	var id = row.TDetailID;
	if(introduce == "" || advice == ""){
		$.messager.popover({msg:"�������ܺͽ������鲻��Ϊ��",type:"alert",timeout:1000});
		return false;
	}
	var properties = "IRDParRef^IRDIntroduce^IRDAdvice^IRDRemark";
	var inString = row.TRowID+"^"+introduce+"^"+advice+"^"+remark;
	var ret = tkMakeServerCall("User.DHCHMInquiryResultDetail","SaveData",id,inString,properties);
	var tmp = ret.split("^");
	if(parseInt(tmp[0]) < 0){
		$.messager.alert("��ʾ",tmp[1],"error");
		return false;
	}else{
		$.messager.popover({msg:"����ɹ�",type:"success",timeout:1000});
		$("#ResultList").datagrid("reload");
		init_result_datagird(index);
	}
}



/**
 * [��ʼ�������ֶ�]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-12-23
 */
function initClass() {
	$('#Win_Class').combotree({
		url: $URL + "?ClassName=web.DHCPE.HM.DataSource&MethodName=GetPackageTree&wantreturnval=1",
		mode: 'remote',
		delay: 200,
		enterNullValueClear: false,
		blurValidValue: true,
		selectOnNavigation: false,
		onBeforeSelect: function(node) {
			if (node.children == undefined || node.children.length == 0) {
			}else{
				$.messager.alert("��ʾ", "��ѡ�������������ǰΪ����", "info");
				return false;
			}
		},
		onChange: function(newValue, oldValue) {
			initMethod(newValue);
		},
		keyHandler: {
			enter: function() {
				var curV = $('#Win_Class').combotree("getText")
				$('#Win_Class').combotree("reload", $URL + "?ClassName=web.DHCPE.HM.DataSource&MethodName=GetPackageTree&wantreturnval=1User&Class=" + curV);
			}
		},
		editable: true
	});
}

function initMethod(clsName){
	$("#Win_Method").combobox({
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		mode:'remote',
		blurValidValue:true,
		enterNullValueClear:false,
		url:$URL+"?ClassName=web.DHCPE.HM.DataSource&MethodName=GetMethods&ClsName="+clsName+"&ResultSetType=array"
	});
}

function relate_detail(Id,Desc){
	var lnk = "dhchm.inquiry.relate.csp?IRID='+Id+'";
	$HUI.window("#RelateWin",{
		title:"�����ʾ�ά��---"+Desc,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:900,
		height:600,
		content:'<iframe src= "' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
	});
}