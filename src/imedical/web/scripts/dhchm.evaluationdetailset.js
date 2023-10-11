/**
 * 评估内容维护  dhchm.evaluationdetailset.js
 * @Author   wangguoying
 * @DateTime 2019-07-02
 */
$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.HMCodeConfig',MethodName:'CheckEDCodeExist',Code:value,ID:$("#Win_ID").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '代码已存在'
	}
});

var EvaDetailDataGrid=$HUI.datagrid("#EvaDetailList",{
		url:$URL,
		title:"",
		bodyCls:'panel-body-gray',
		queryParams:{
			ClassName:"web.DHCHM.EvaluationDetailSet",
			QueryName:"FindEVADetail"
		},
		onSelect:function(rowIndex,rowData){
			
		},
		onDblClickRow:function(index,row){
			edit_detail();															
		},	
		columns:[[
			{field:'EDID',hidden:true,sortable:'true'},
			{field:'TRelate',width:60,title:'关联问卷',align:'center',
				formatter:function(value,row,index){
					return "<a href='#' onclick='relate_detail(\""+row.EDID+"\",\""+row.EDDesc+"\")'>\
						<img style='padding-top:4px;' title='关联问卷' alt='关联问卷' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_switch.png' border=0/>\
					</a>";
				}             
			},
			{field:'EDCode',width:100,title:'编码'},
			{field:'EDDesc',width:180,title:'描述'},
			{field:'EDSex',width:50,title:'性别',
			formatter:function(value,row,index){
					var ret="";
					switch(value)
					{
						case "N":
							ret="不限";
							break;
						case "M":
							ret="男";
							break;
						case "F":
							ret="女";
							break;
					}
					return ret;
			}},
			{field:'EDType',width:80,title:'类型',
			formatter:function(value,row,index){
					var ret="";
					switch(value)
					{
						case "I":
							ret="评估项目";
							break;
						case "F":
							ret="评估因子";
							break;
						case "R":
							ret="评估结果";
							break;
					}
					return ret;
			}},
			//{field:'EDUnit',width:'100',title:'单位'},
			{field:'EDClassName',width:120,title:'类名'},
			{field:'EDMethodName',width:120,title:'方法名'},
			{field:'EDExpression',width:300,title:'计算公式'},
			{field:'EDRelateCode',width:100,title:'外部关联码'},
			{field:'EDSort',width:50,title:'顺序号'},
			{field:'EDActive',width:50,title:'激活',align:"center",
			formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
			}},
			{field:'EDUpdateDate',width:100,title:'更新日期'},
			{field:'EDUpdateTime',width:80,title:'更新时间'}
		]],
		toolbar: [{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				WinClear_onclick();
				$("#EDEditWin").window("open");
			}	
		},{
			iconCls: 'icon-edit',
			text:'编辑',
			handler: function(){
				edit_detail();
			}	
		}],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		fit:true,
		fitColumns: false,
		rownumbers:true
	});
	
function edit_detail(){
	WinClear_onclick();
	var rows = EvaDetailDataGrid.getSelections();
	if (rows.length>0){
		$("#Win_ID").val(rows[0].EDID);
		$("#Win_Code").val(rows[0].EDCode);
		$("#Win_Desc").val(rows[0].EDDesc);
		$("#Win_Type").combobox("setValue",rows[0].EDType);
		$("#Win_DataSource").val(rows[0].EDDataSource);
		$("#Win_Sex").combobox("setValue",rows[0].EDSex);
		$("#Win_Unit").val(rows[0].EDUnit);
		$("#Win_RelateCode").val(rows[0].EDRelateCode);
		$("#Win_Expression").val(rows[0].EDExpression);
		$("#Win_Sort").val(rows[0].EDSort);
		if(rows[0].EDActive=="true"){
			$("#Win_Active").checkbox("check");
		}else{
			$("#Win_Active").checkbox("uncheck");
		}
		$("#EDEditWin").window("open");	
		$("#Win_Class").combotree("setValue",rows[0].EDClassName);
		if(rows[0].EDClassName!=""){
			initMethod(rows[0].EDClassName)
			$("#Win_Method").combobox("setValue",rows[0].EDMethodName);
		}											
	}else{
		$.messager.alert("提示","请选择要编辑的数据","info");
	}
}	
	
	
/**
 * 编辑窗口清屏事件
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */
function WinClear_onclick(){
	$("#Win_ID").val("");
	$("#Win_Code").val("");
	$("#Win_Desc").val("");
	$("#Win_Type").combobox("setValue","");
	$("#Win_DataSource").val("");
	$("#Win_Sex").combobox("setValue","");
	$("#Win_Unit").val("");
	$("#Win_RelateCode").val("");
	$("#Win_Expression").val("");
	$("#Win_Sort").val("");
	$("#Win_Active").checkbox("check");
	$("#Win_Class").combotree("setValue","");
	$("#Win_Method").combobox("setValue","");
}

/**
 * 编辑窗口保存事件
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */
function WinSave_onclick(){
	var subject = $("#cboCQDSubject").combobox("getValue");
	var ID=$("#Win_ID").val();
	var Code=$("#Win_Code").val();
	var Desc=$("#Win_Desc").val();
	var Type=$("#Win_Type").combobox("getValue");
	var DataSource=$("#Win_DataSource").val();
	var Sex=$("#Win_Sex").combobox("getValue");
	var Unit=$("#Win_Unit").val();
	var RelateCode = $("#Win_RelateCode").val();
	var Expression = $("#Win_Expression").val();
	var Sort = $("#Win_Sort").val();
	var clsName = $("#Win_Class").combotree("getValue");
	var methodName = $("#Win_Method").combobox("getValue");
	var Active="N";
	if($("#Win_Active").checkbox("getValue")){
		Active="Y";
	}
	if((Code=="")||(Desc=="")||(Type=="")){
		$.messager.alert("提示","必录字段不可为空","info");
		return false;
	}
	if(!$("#Win_Code").validatebox("isValid")){
		$.messager.alert("提示","编码已存在","info");
		return false;
	}
	var property = 'EDCQDSubjectDR^EDActive^EDCode^EDDataSource^EDDesc^EDSex^EDType^EDUnit^EDRelateCode^EDClassName^EDMethodName^EDExpression^EDSort^EDUpdateUserDR';
	var valList=subject+"^"+Active+"^"+Code+"^"+DataSource+"^"+Desc+"^"+Sex+"^"+Type+"^"+Unit+"^"+RelateCode+"^"+clsName+"^"+methodName+"^"+Expression+"^"+Sort+"^"+session["LOGON.USERID"];
	
	try{
		var ret=tkMakeServerCall("web.DHCHM.EvaluationDetailSet","EDSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");
			EvaDetailDataGrid.load({
				ClassName:"web.DHCHM.EvaluationDetailSet",
				QueryName:"FindEVADetail",
				Code:$("#Code").val(),
				Desc:$("#Desc").val(),
				aSubjectID:$("#cboCQDSubject").combobox('getValue')
			});
            $("#EDEditWin").window("close");
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}


function find_click()
{
	var SCode=$("#Code").val();
	var SDesc=$("#Desc").val();
	EvaDetailDataGrid.load({
		ClassName:"web.DHCHM.EvaluationDetailSet",
		QueryName:"FindEVADetail",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		aSubjectID:$("#cboCQDSubject").combobox('getValue')
	});
}

function clean_click()
{
	$("#Code").val("");
	$("#Desc").val("");
	find_click();
}


function setLayoutSize(){
	var dHeight=$(document).height();
	$("#TabDiv").height(dHeight-160);
	$("#EvaDetailList").datagrid("resize");
	$("#EvaDetailList").datagrid('getPanel').css("border-radius",0)// 去掉表格圆角样式
}

function relate_detail(evaluationId,evaluationDesc){
	var lnk = "dhchm.evaluationlink.csp?EvaluationDetail='+evaluationId+'";
	$HUI.window("#RelateWin",{
		title:"关联问卷维护---"+evaluationDesc,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		resizable:false,
		modal:true,
		width:1200,
		height:800,
		content:'<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
	});
}

$(init);

function init(){
	$HUI.combobox("#cboCQDSubject",{
		url:$URL+"?ClassName=web.DHCPE.CT.HM.CommonData&QueryName=QuerySubject&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc',
		onSelect:function(record){
			EvaDetailDataGrid.load({
				ClassName:"web.DHCHM.EvaluationDetailSet",
				QueryName:"FindEVADetail",
				Code:$("#Code").val(),
				Desc:$("#Desc").val(),
				aSubjectID:record.TID
			});
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['TID']);
			}
		}
	});
	setLayoutSize();
	initClass();
}

/**
 * [初始化类名字段]
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
				$.messager.alert("提示", "请选择具体类名，当前为包名", "info");
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