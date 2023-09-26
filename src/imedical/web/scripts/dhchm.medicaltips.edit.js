/**
 * ������ʾά��  dhchm.medicaltips.edit.js
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
		message: '�����Ѵ���'
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
			{field:'MTCode',width:100,title:'����'},
			{field:'MTDesc',width:120,title:'����'},
			{field:'MTActive',width:60,title:'����',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'MTAlias',width:100,title:'����'},
			{field:'MTRemark',width:200,title:'��ע'},
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
 * ����
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
 * ����
 * @Author   wangguoying
 * @DateTime 2019-06-03
 */
function Save_onclick(){
	var ID=$("#MTID").val();
	var Code=$("#ECode").val();
	var Desc=$("#EDesc").val();
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if(!$("#ECode").validatebox("isValid")){
		$.messager.alert("��ʾ","�����Ѵ���","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
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
		$.messager.alert("��ʾ",ret.split("^")[1],"error");
	}else{
		$.messager.alert("��ʾ","����ɹ�","success");
		MTDataGrid.reload();
		Clear_onclick();
	}
}


