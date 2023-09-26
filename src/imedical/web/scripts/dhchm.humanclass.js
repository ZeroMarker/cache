/**
 * ��Ա����ά�� dhchm.humanclass.js
 * @Author   wangguoying
 * @DateTime 2019-06-06
 */

function init(){
	$.cm({
			wantreturnval: 1,
			ClassName: 'web.DHCHM.GetTreeInfo',
			MethodName: 'GetCTCOdeTreeJson',
			CodeType: '1004'
		},function(data){
			$('#CodeTree').tree({
				onClick: function(node){
					if(node.id!="AllCode"){
						$("#DetailPanel").panel("setTitle",node.text);
						HCClear();
						$("#Type").val(node.id);
						HCDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindHumClass",CodeType:node.id});
					}else{
						HCClear();
						$("#Type").val("");
						CodeDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindHumClass"});
					}					
				},
				data: data
			});
		});
	setGridLayout();
}
/**
 * ����DataGrid������ʽ
 * @Author   wangguoying
 * @DateTime 2019-08-07
 */
function setGridLayout(){
	$("#HCListDiv").height($("#DetailPanel").height()-92);
	$("#HCList").datagrid("resize");
	$("#HCList").datagrid('getPanel').css("border-radius",0)// ȥ�����Բ����ʽ
	$('#HCList').datagrid('getPanel').css('border-left-width',0);
	$('#HCList').datagrid('getPanel').css('border-right-width',0);
	$('#HCList').datagrid('getPanel').css('border-bottom-width',0);


}



var HCDataGrid=$HUI.datagrid("#HCList",{
		url:$URL,
		bodyCls:'panel-body-gray',
		singleSelect:true,
		queryParams:{
			ClassName:"web.DHCHM.HMCodeConfig",
			QueryName:"FindHumClass",
			CodeType:$("#Type").val()
		},
		onSelect:function(rowIndex,rowData){
			if(rowIndex>-1){
				$("#Code").val(rowData.HCCode);
				$("#Desc").val(rowData.HCDesc);
				$("#Remark").val(rowData.HCRemark);
				$("#HCMonths").val(rowData.HCMonths);
				$("#ExpandCode").val(rowData.HCExpandCode);
				$("#HCID").val(rowData.ID);
				if(rowData.HCActive=="true"){
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
			{field:'HCCode',width:100,title:'����'},
			{field:'HCDesc',width:150,title:'����'},
			{field:'HCRemark',width:100,title:'��ע'},
			{field:'HCMonths',width:80,title:'��ü��(��)'},
			{field:'HCActive',width:80,title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'HCExpandCode',width:100,title:'��չ'}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true
	});
/**
 * ����
 * @Author   wangguoying
 * @DateTime 2019-05-06
 */
function HCClear()
{
	$("#Code").val("");
	$("#Desc").val("");
	$("#Remark").val("");
	$("#HCMonths").val("");
	$("#ExpandCode").val("");
	$("#HCID").val("");
	$("#Active").checkbox("uncheck");
	
}

/**
 * ����
 * @Author   wangguoying
 * @DateTime 2019-03-30
 */
function HCSave(){
	var ID=$("#HCID").val();
	var Type=$("#Type").val();
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	var Remark=$("#Remark").val();
	var HCMonths=$("#HCMonths").val();
	var ExpandCode=$("#ExpandCode").val();
	var Active="N";
	if($("#Active").checkbox("getValue")){
		Active="Y";
	}
	if(Type==""){
		$.messager.alert("��ʾ","���Ͳ���Ϊ��","info");
		return false;
	}
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var property = 'HCActive^HCCode^HCDesc^HCExpandCode^HCMonths^HCRemark^HCType';
	var valList = Active+"^"+Code+"^"+Desc+"^"+ExpandCode+"^"+HCMonths+"^"+Remark+"^"+Type;
	try{
		var ret=tkMakeServerCall("web.DHCHM.HMCodeConfig","SaveHumClass",ID,valList);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");      	
            HCDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindHumClass",CodeType:Type});
            HCClear();
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}

$(init);