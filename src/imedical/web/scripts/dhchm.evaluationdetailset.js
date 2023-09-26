/**
 * ��������ά��  dhchm.evaluationdetailset.js
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
		message: '�����Ѵ���'
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
			{field:'EDCode',width:'200',title:'����'},
			{field:'EDDesc',width:'250',title:'����'},
			{field:'EDDataSource',width:'400',title:'������Դ'},
			{field:'EDSex',width:'100',title:'�Ա�',
			formatter:function(value,row,index){
					var ret="";
					switch(value)
					{
						case "N":
							ret="����";
							break;
						case "M":
							ret="��";
							break;
						case "F":
							ret="Ů";
							break;
					}
					return ret;
			}},
			{field:'EDType',width:'100',title:'����',
			formatter:function(value,row,index){
					var ret="";
					switch(value)
					{
						case "T":
							ret="˵����";
							break;
						case "N":
							ret="��ֵ��";
							break;
						case "C":
							ret="�����б�";
							break;
						case "D":
							ret="������";
							break;
					}
					return ret;
			}},
			{field:'EDUnit',width:'100',title:'��λ'},
			{field:'EDActive',width:'150',title:'����',align:"center",
			formatter:function(value,row,index){
					var checked=value=="true"? "checked":"";
					return "<input type='checkbox' disabled class='hisui-checkbox' "+checked+" >";
			}}
		]],
		toolbar: [{
			iconCls: 'icon-add',
			text:'����',
			handler: function(){
				WinClear_onclick();
				$("#EDEditWin").window("open");
			}	
		},{
			iconCls: 'icon-edit',
			text:'�༭',
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
					$.messager.alert("��ʾ","��ѡ��Ҫ�༭������","info");
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
 * �༭���������¼�
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
 * �༭���ڱ����¼�
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
		$.messager.alert("��ʾ","��¼�ֶβ���Ϊ��","info");
		return false;
	}
	if(!$("#Win_Code").validatebox("isValid")){
		$.messager.alert("��ʾ","�����Ѵ���","info");
		return false;
	}
	var property = 'EDActive^EDCode^EDDataSource^EDDesc^EDSex^EDType^EDUnit';
	var valList=Active+"^"+Code+"^"+DataSource+"^"+Desc+"^"+Sex+"^"+Type+"^"+Unit;
	
	try{
		var ret=tkMakeServerCall("web.DHCHM.EvaluationDetailSet","EDSave",ID,valList,property);
		if (parseInt(ret)<0) {
			var errMsg=ret.split("^").length>1?":"+ret.split("^")[1]:"";
            $.messager.alert("����","����ʧ��"+errMsg,"error");
			return false;
        }else {
        	$.messager.alert("�ɹ�","����ɹ�","success");      	
            EvaDetailDataGrid.load({ClassName:"web.DHCHM.EvaluationDetailSet",QueryName:"FindEVADetail"});
            $("#EDEditWin").window("close");
        }
	}catch(err){
		$.messager.alert("����","����ʧ�ܣ�"+err.description,"error");
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
	$("#EvaDetailList").datagrid('getPanel').css("border-radius",0)// ȥ�����Բ����ʽ
}

$(init);