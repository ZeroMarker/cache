/**
 * ��������ά��  dhchm.ctcode.edit.js
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
		message: '�����Ѵ���'
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
 * ����DataGrid������ʽ
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
			{field:'CTCode',width:80,title:'����'},
			{field:'CTDesc',width:150,title:'����'},
			{field:'CTDefault',width:80,title:'Ĭ��',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'CTActive',width:80,title:'����',align:'center',
				formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
				}
			},
			{field:'CTRemark',width:300,title:'��ע'}
		]],
		fitColumns:true,
		fit:true,
		pagination:true,
		pageSize:20,
		rownumbers:true
	});
/**
 * ����
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
 * ����
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
		$.messager.alert("��ʾ","���Ͳ���Ϊ��","info");
		return false;
	}
	if(Code==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	if(!$("#Code").validatebox("isValid")){
		$.messager.alert("��ʾ","�����Ѵ���","info");
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	var property = 'CTActive^CTCode^CTDefault^CTDesc^CTExpandCode^CTRemark^CTType';
	var valList = Active+"^"+Code+"^"+Default+"^"+Desc+"^^"+Remark+"^"+Type;
	try{
		var ret=tkMakeServerCall("web.DHCHM.HMCodeConfig","SaveData",ID,valList);
		if (ret.split("^")[0] == -1) {
            $.messager.alert("����","����ʧ�ܣ�"+ret.split("^")[1],"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");      	
            CodeDataGrid.load({ClassName:"web.DHCHM.HMCodeConfig",QueryName:"FindCodebyType",CType:Type});
            CTClear();
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
		return false;
	}
}



$(init);