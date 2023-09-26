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
			QueryName:"FindEVADetail",
		},
		onSelect:function(rowIndex,rowData){
			
		},
		onDblClickRow:function(index,row){
																	
		},	
		columns:[[
			{field:'EDID',hidden:true,sortable:'true'},
			{field:'EDCode',width:'200',title:'编码'},
			{field:'EDDesc',width:'250',title:'描述'},
			{field:'EDDataSource',width:'400',title:'数据来源'},
			{field:'EDSex',width:'100',title:'性别',
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
			{field:'EDType',width:'100',title:'类型',
			formatter:function(value,row,index){
					var ret="";
					switch(value)
					{
						case "T":
							ret="说明型";
							break;
						case "N":
							ret="数值型";
							break;
						case "C":
							ret="下拉列表";
							break;
						case "D":
							ret="日期型";
							break;
					}
					return ret;
			}},
			{field:'EDUnit',width:'100',title:'单位'},
			{field:'EDActive',width:'150',title:'激活',align:"center",
			formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
			}}
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
					if(rows[0].EDActive=="true"){
						$("#Win_Active").checkbox("check");
					}else{
						$("#Win_Active").checkbox("uncheck");
					}
					$("#EDEditWin").window("open");												
				}else{
					$.messager.alert("提示","请选择要编辑的数据","info");
				}
			}	
		}],
		singleSelect:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
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
	$("#Win_Active").checkbox("check");
}

/**
 * 编辑窗口保存事件
 * @Author   wangguoying
 * @DateTime 2019-07-04
 */
function WinSave_onclick(){
	var ID=$("#Win_ID").val();
	var Code=$("#Win_Code").val();
	var Desc=$("#Win_Desc").val();
	var Type=$("#Win_Type").combobox("getValue");
	var DataSource=$("#Win_DataSource").val();
	var Sex=$("#Win_Sex").combobox("getValue");
	var Unit=$("#Win_Unit").val();
	var Active="N";
	if($("#Win_Active").checkbox("getValue")){
		Active="Y";
	}
	if((Code=="")||(Desc=="")||(Type=="")||(Sex=="")){
		$.messager.alert("提示","必录字段不可为空","info");
		return false;
	}
	if(!$("#Win_Code").validatebox("isValid")){
		$.messager.alert("提示","编码已存在","info");
		return false;
	}
	var property = 'EDActive^EDCode^EDDataSource^EDDesc^EDSex^EDType^EDUnit';
	var valList=Active+"^"+Code+"^"+DataSource+"^"+Desc+"^"+Sex+"^"+Type+"^"+Unit;
	
	try{
		var ret=tkMakeServerCall("web.DHCHM.EvaluationDetailSet","EDSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("错误","保存失败"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");      	
            EvaDetailDataGrid.load({ClassName:"web.DHCHM.EvaluationDetailSet",QueryName:"FindEVADetail"});
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
	EvaDetailDataGrid.load({ClassName:"web.DHCHM.EvaluationDetailSet",QueryName:"FindEVADetail",Code:SCode,Desc:SDesc});	
}

function clean_click()
{
	$("#Code").val("");
	$("#Desc").val("");
}

function init(){
	setLayoutSize();
}

function setLayoutSize(){
	var dHeight=$(document).height();
	$("#TabDiv").height(dHeight-160);
	$("#EvaDetailList").datagrid("resize");
	$("#EvaDetailList").datagrid('getPanel').css("border-radius",0)// 去掉表格圆角样式
}

$(init);