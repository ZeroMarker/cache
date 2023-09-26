/**
 * 基础代码维护  dhchm.ctcode.edit.js
 * @Author   wangguoying
 * @DateTime 2019-03-29
 */
$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.HMCodeConfig',MethodName:'CheckCodeExist',Type:$("#Type").val(),Code:value,ID:$("#CodeID").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '代码已存在'
	}
});


function init(){
	$.cm({
			wantreturnval: 1,
			ClassName: 'web.DHCHM.GetTreeInfo',
			MethodName: 'GetCTCOdeTreeJson',
			CodeType: '1001'
		},function(data){
			$('#CodeTree').tree({
				onClick: function(node){
					if(node.id!="AllCode"){
						$("#DetailPanel").panel("setTitle",node.text);
						CTClear();
						$("#Type").val(node.id);
						CodeDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindCodebyType",CType:node.id});
					}else{
						CTClear();
						$("#Type").val("");
						CodeDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindCodebyType"});
					}					
				},
				data: data
			});
		});
	setGridLayout();
}
/**
 * 设置DataGrid布局样式
 * @Author   wangguoying
 * @DateTime 2019-08-07
 */
function setGridLayout(){
	//alert($("#DetailPanel").height()-90);
	$("#CodeListDiv").height($("#DetailPanel").height()-92);
	$("#CodeList").datagrid("resize");


}


var CodeDataGrid=$HUI.datagrid("#CodeList",{
		url:$URL,
		nowrap:false,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.HMCodeConfig",
			QueryName:"FindCodebyType",
			CType:$("#Type").val()
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				$("#Code").val(rowData.CTCode);
				$("#Desc").val(rowData.CTDesc);
				$("#Remark").val(rowData.CTRemark);
				$("#CodeID").val(rowData.ID);
				if(rowData.CTDefault=="true"){
					$("#Default").checkbox("check");
				}else{
					$("#Default").checkbox("uncheck");
				}
				if(rowData.CTActive=="true"){
					$("#Active").checkbox("check");
				}else{
					$("#Active").checkbox("uncheck");
				}
			}
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'CTCode',width:80,title:'代码'},
			{field:'CTDesc',width:150,title:'描述'},
			{field:'CTDefault',width:80,title:'默认',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'CTActive',width:80,title:'激活',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'CTRemark',width:300,title:'备注'}
		]],
		fitColumns:true,
		fit:true,
		pagination:true,
		pageSize:20,
		rownumbers:true
	});
/**
 * 清屏
 * @Author   wangguoying
 * @DateTime 2019-05-06
 */
function CTClear()
{
	$("#Code").val("");
	$("#Desc").val("");
	$("#Remark").val("");
	$("#CodeID").val("");
	$("#Default").checkbox("uncheck");
	$("#Active").checkbox("uncheck");
	
}

/**
 * 保存
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function CTSave(){
	var ID=$("#CodeID").val();
	var Type=$("#Type").val();
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var Remark=$("#Remark").val();
	var Active="N";
	var Default="N";
	if($("#Active").checkbox("getValue")){
		Active="Y";
	}
	if($("#Default").checkbox("getValue")){
		Default="Y";
	}
	if(Type==""){
		$.messager.alert("提示","类型不能为空","info");
		return false;
	}
	if(Code==""){
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	if(!$("#Code").validatebox("isValid")){
		$.messager.alert("提示","编码已存在","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var property = 'CTActive^CTCode^CTDefault^CTDesc^CTExpandCode^CTRemark^CTType';
	var valList = Active+"^"+Code+"^"+Default+"^"+Desc+"^^"+Remark+"^"+Type;
	try{
		var ret=tkMakeServerCall("web.DHCHM.HMCodeConfig","SaveData",ID,valList);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("错误","保存失败："+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("成功","保存成功","success");      	
            CodeDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindCodebyType",CType:Type});
            CTClear();
        }
	}catch(err){
		$.messager.alert("错误","保存失败："+err.description,"error");
		return false;
	}
}



$(init);