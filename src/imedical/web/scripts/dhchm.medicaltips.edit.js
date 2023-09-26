/**
 * 健康提示维护  dhchm.medicaltips.edit.js
 * @Author   wangguoying
 * @DateTime 2019-05-31
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkCodeExist:{
		validator: function(value){
			var url=$URL;  
			var data={ClassName:'web.DHCHM.HMCodeConfig',MethodName:'CheckTipsCodeExist',Code:value,ID:$("#MTID").val()};
			var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
			return rtn==0;
		},
		message: '代码已存在'
	}
});


var MTDataGrid = $HUI.datagrid("#MTList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.BaseDataSet",
			QueryName:"GetCMedicalTips",
			params6:"6"
		},
		onSelect:function(rowIndex,rowData){
			//Clear_onclick();
			$("#MTID").val(rowData.ID);
			$("#ECode").val(rowData.MTCode);
			$("#EDesc").val(rowData.MTDesc);
			$("#EAlias").val(rowData.MTAlias);
			if(rowData.MTActive=="true"){
				$("#EActive").checkbox("check");
			}
			$("#ERemark").val(rowData.MTRemark);
			
			EditorObj.setData(rowData.MTDetail);
		},
		onDblClickRow:function(index,row){
															
		},	
		columns:[[
			{field:'ID',hidden:true,sortable:'true'},
			{field:'MTCode',width:100,title:'代码'},
			{field:'MTDesc',width:120,title:'描述'},
			{field:'MTActive',width:60,title:'激活',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'MTAlias',width:100,title:'别名'},
			{field:'MTRemark',width:200,title:'备注'},
			{field:'MTDetail',hidden:true,}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true
	});
var EditorObj;
function init(){
	var height=$(document).height()-380;
	EditorObj=CKEDITOR.replace('EDetail',{
			height:height,
			toolbar:[
			['Save','Preview'],
			['Cut','Copy','Paste','PasteText','PasteFromWord'],
			['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
       		['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button'],
			['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], 
			['Link','Unlink'],
			['TextColor','BGColor'],
			['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
			['Styles','Format','Font','FontSize'],						
			['HorizontalRule','Smiley','SpecialChar','-','Outdent','Indent'],
			['Maximize']       		
			]
	});
	setGridHeight();
}
$(init);
function setGridHeight()
{
	$("#GridDiv").height($(document).height()-124.5);
	$("#MTList").datagrid("resize");
}
/**
 * 清屏
 * @Author   wangguoying
 * @DateTime 2019-06-03
 */
function Clear_onclick()
{
	$("#MTID").val("");
	$("#ECode").val("");
	$("#EDesc").val("");
	$("#EAlias").val("");
	$("#EActive").checkbox("uncheck");
	$("#ERemark").val("");
	EditorObj.setData("");
}
/**
 * 保存
 * @Author   wangguoying
 * @DateTime 2019-06-03
 */
function Save_onclick(){
	var ID=$("#MTID").val();
	var Code=$("#ECode").val();
	var Desc=$("#EDesc").val();
	if(Code==""){
		$.messager.alert("提示","代码不能为空","info");
		return false;
	}
	if(!$("#ECode").validatebox("isValid")){
		$.messager.alert("提示","代码已存在","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	var Alias=$("#EAlias").val();
	var Active="N"
	if($("#EActive").checkbox("getValue")){
		Active="Y";
	}	
	var Remark=$("#ERemark").val();
	var Detail=EditorObj.getData();
	var valStr=Active+"^"+Code+"^"+Desc+"^"+Detail+"^"+Remark;
	var ret=tkMakeServerCall("web.DHCHM.BaseDataSet","CMedicalTipsSaveData",ID,valStr,Alias);
	if(parseInt(ret)<0){
		$.messager.alert("提示",ret.split("^")[1],"error");
	}else{
		$.messager.alert("提示","保存成功","success");
		MTDataGrid.reload();
		Clear_onclick();
	}
}


