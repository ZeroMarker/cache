/**
 * ģ��:ҩ��
 * ��ģ��:��ҩ����������Ƭת��ά��
 * ��д����:2017-08-04
 * ��д��:yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function(){
    InitHospCombo(); //����ҽԺ
	InitDict();
	InitGridConvert();
	$("#btnClose").on("click",function(){
		$('#maintainWin').window("close");
	});
	$("#btnSave").on("click",SaveContent);
	$("#btn-Search").on("click",Query);
});

/// ��ʼ���ֵ�
function InitDict(){
	/// ��������
	var options={
		ClassName:"web.DHCST.PhcConvert",
		QueryName:"GetCMPrescType",
		StrParams:HospId,
		mode:"remote",
		onBeforeLoad:function(params){
			params.StrParams=HospId
		}
    }
    $("#cmbPrescType").dhcstcomboeu(options);

	options.editable=false;
	options.onSelect=function(selData){
		$("#cmbFPhcDrg").combogrid("clear");
		$("#cmbFPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
		$("#cmbFPhcDrg").combogrid("grid").datagrid("reload");
		$("#txtFQty").numberbox("setValue","");
	}
    $("#cmbFPrescType").dhcstcomboeu(options);
	options.onSelect=function(selData){
		$("#cmbTPhcDrg").combogrid("clear");
		$("#cmbTPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
		$("#cmbTPhcDrg").combogrid("grid").datagrid("reload");
		$("#txtTQty").numberbox("setValue","");
	}
    $("#cmbTPrescType").dhcstcomboeu(options);
    /// ҩѧ������
    options={
	    ClassName:"web.DHCST.PhcConvert",
		QueryName:"QueryPHCDrgMast",
	    columns: [[
			{field:'phcId',title:'phcId',width:100,sortable:true,hidden:true},
			{field:'phcCode',title:'ҩƷ����',width:100,sortable:true},
			{field:'phcDesc',title:'ҩƷ����',width:200,sortable:true}
	    ]],
		idField:'phcId',
		textField:'phcDesc',
		strParams:'needNull',
		width:300,
		mode:"remote",
		pageSize:30, 
		pageList:[30,50,100],  
		pagination:true,
		onBeforeLoad: function(param) {
			var newQ=param.q||"";
			if (newQ==""){
				newQ="needNull";
			}else{
				var curPrescId=$("#cmbPrescType").combobox("getValue")||"";
				newQ=newQ+"|@|"+curPrescId+"|@|"+HospId;
			}
			param.q =newQ;
            param.StrParams =newQ;
        }
    }
    $("#cmbPhcDrg").dhcstcombogrideu(options);
    options.width='null';
	options.onBeforeLoad=function(param){
		var curFPrescId=$("#cmbFPrescType").combobox("getValue")||"";
		var newQ=param.q||"";
		if ((curFPrescId=="")){
			newQ="needNull";
		}else{
			newQ=newQ+"|@|"+curFPrescId+"|@|"+HospId;
		}
		param.q=newQ;
        param.StrParams =newQ;
	}
    $("#cmbFPhcDrg").dhcstcombogrideu(options);
	options.onBeforeLoad=function(param){
		var curTPrescId=$("#cmbTPrescType").combobox("getValue")||"";
		var newQ=param.q||"";
		if ((curTPrescId=="")){
			newQ="needNull";
		}else{
			newQ=newQ+"|@|"+curTPrescId+"|@|"+HospId;
		}
		param.q=newQ;
        param.StrParams =newQ;
	}
    $("#cmbTPhcDrg").dhcstcombogrideu(options);
}

function InitGridConvert(){
	var gridColumns=[[  
		{field:'pcId',title:'pcId',width:100,hidden:true},
        {field:'fromTypeDesc',title:'����',width:100},
        {field:'fromPhcDesc',title:'ҩƷ',width:300},
	    {field:'fromNum',title:'����',width:100,align:'right'},
	    {field:'toTypeDesc',title:'ת������',width:100},
        {field:'toPhcDesc',title:'ת��ҩƷ',width:300},
        {field:'toNum',title:'ת������',align:'right',width:100}
	]];
	var options={
		ClassName:'web.DHCST.PhcConvert',
		QueryName:'Query',
		queryParams:{
			StrParams:''
		},
	    toolbar:'#gridConvertBar',
        columns:gridColumns,
        rownumbers:false,
        singleSelect:true
        
	}
	$('#gridConvert').dhcstgrideu(options);
}

///��ѯ
function Query(){
	var prescType=$("#cmbPrescType").combobox('getValue')||"";
	if ($.trim($("#cmbPrescType").combobox('getText'))==""){
		prescType="";	
	}
	var phcId=$("#cmbPhcDrg").combobox('getValue')||"";
	if ($.trim($("#cmbPhcDrg").combobox('getText'))==""){
		phcId="";	
	}
	var params=prescType+"^"+phcId+"^"+HospId;
	$('#gridConvert').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

	
/// ά��������
function ButtonEdit(btnId){
	var title="��ҩ��������ת��ϵ��";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var seletcted = $("#gridConvert").datagrid("getSelected");
	var rowId="";
	if (modifyType=="A"){
		title=title+"����";
		var editOptions={
			title:title,
		}
		EditShow(editOptions);
		return;
	}
	if (modifyType=="U"){
		title=title+"�޸�";
		if(seletcted==null){
	        $.messager.alert('��ʾ',"��ѡ����Ҫ�޸ĵ���!","warning");
	        return;
	    }
		var editOptions={
			title:title,
		}
		EditShow(editOptions);
	}
	if (modifyType=="D"){
		if(seletcted==null){
	        $.messager.alert('��ʾ',"��ѡ����Ҫɾ������!","warning");
	        return;
	    }
	    $.messager.confirm('ɾ����ʾ', '��ȷ��ɾ����?', function(r){
			if (r){	
			    var pcId=seletcted.pcId
				var delRet=tkMakeServerCall("web.DHCST.PhcConvert","DeleteDHCPhcConvert",pcId,HospId)
				if(delRet==0){
					//$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
					Query();
				}else{
					$.messager.alert("������ʾ","ɾ��ʧ��","error");
				}
				return;
			}
	    });
	}
	
}

/// �༭����
function EditShow(_options){
	var options={
		title: 'ά��',
	    width: 640,
	    height: 180,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-edit',
	    closed: true,
	    minimizable: false,
	    maximizable: true,
	    collapsible: true,
	    top:null,
	    left:null,
		onBeforeClose:function(){ 
			ClearContent();
		}
	}
	var optionsNew = $.extend({},options, _options);
	var $modifyWin = $('#maintainWin').window(optionsNew);
	$modifyWin.window('open');
	if ((_options.title).indexOf("�޸�")>=0){
		var gridSelected=$("#gridConvert").datagrid("getSelected")
		var pcId=gridSelected.pcId;
		$.ajax({
			type:"POST",
			data:"json",
			url:"DHCST.QUERY.JSON.csp?&Plugin=EasyUI.ComboBox"+
			"&ClassName=web.DHCST.PhcConvert"+
			"&QueryName=QueryByRowId"+
			"&StrParams="+pcId,
			error:function(){        
				alert("��ȡ����ʧ��!");
			},
			success:function(retData){
				SetPhcConValues(retData)
			}
		})	
	}else{
		ClearContent();
	}
}

function SetPhcConValues(retData){
	var jsonData=JSON.parse(retData)[0];
	$("#cmbFPrescType").combobox("setValue",jsonData.cmbFPrescType);
	$("#cmbTPrescType").combobox("setValue",jsonData.cmbTPrescType);
	$("#txtFQty").numberbox("setValue",jsonData.txtFQty);
	$("#txtTQty").numberbox("setValue",jsonData.txtTQty);
	$("#cmbFPhcDrg").combogrid("setValue",jsonData.cmbFPhcDrg);
	$("#cmbTPhcDrg").combogrid("setValue",jsonData.cmbTPhcDrg);
	$("#cmbFPhcDrg").combogrid("setText",jsonData.cmbFPhcDrg_text);
	$("#cmbTPhcDrg").combogrid("setText",jsonData.cmbTPhcDrg_text);
}
function ClearContent(){
	$("#cmbPrescType").combobox("clear").combobox("reload");
	$("#cmbFPrescType").combobox("clear").combobox("reload");
	$("#cmbTPrescType").combobox("clear").combobox("reload");
	$("#txtFQty").numberbox("setValue","");
	$("#txtTQty").numberbox("setValue","");
	$("#cmbFPhcDrg").combogrid("clear");
	$("#cmbTPhcDrg").combogrid("clear");
	$("#cmbFPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmbTPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";
	$("#cmbFPhcDrg").combogrid("grid").datagrid("reload")
	$("#cmbTPhcDrg").combogrid("grid").datagrid("reload")
	$("#cmbPhcDrg").combogrid("clear");
	$("#cmbPhcDrg").combogrid("grid").datagrid("options").queryParams.q="";

	
}

/// ��������
function SaveContent(){
	var selected = $("#gridConvert").datagrid("getSelected");
	var pcId="";
	if (($('#maintainWin').window('options').title).indexOf("����")>=0){
		pcId="";
	}else{
		pcId=selected.pcId;
	}
	var inputStr=GetSaveConvertList();
	if (inputStr==""){
		return;
	}
	var saveRet= tkMakeServerCall("web.DHCST.PhcConvert","SavePhcConvert",pcId,inputStr);
	var saveArr=saveRet.split("^");
	if (saveArr[0]>0){
		//$.messager.alert("�ɹ���ʾ","����ɹ�","info");
		$('#maintainWin').window('close');
		Query();		
	}else{
		$.messager.alert("������ʾ",saveArr[1],"error");
	}

}

function GetSaveConvertList(){
	var fPrescTypeId=$("#cmbFPrescType").combobox("getValue")||"";
	if (fPrescTypeId==""){
		$.messager.alert("��ʾ","����ѡ������","warning");
		return "";
	}
	var fPhcDrgId=$("#cmbFPhcDrg").combogrid("getValue")||"";
	if (fPhcDrgId==""){
		$.messager.alert("��ʾ","��ѡ��ҩƷ","warning");
		return "";
	}
	var fQty=$("#txtFQty").numberbox("getValue")||"";
	if (fQty==""){
		$.messager.alert("��ʾ","������������","warning");
		return "";	
	}
	if(parseFloat(fQty)<=0){
		$.messager.alert("��ʾ","���Ⱥ˶�����,����С�ڻ����0","warning");
		return "";		
	}
	var tPrescTypeId=$("#cmbTPrescType").combobox("getValue")||"";
	if (tPrescTypeId==""){
		$.messager.alert("��ʾ","����ѡ��ת������","warning");
		return "";
	}
	var tPhcDrgId=$("#cmbTPhcDrg").combogrid("getValue")||"";
	if (tPhcDrgId==""){
		$.messager.alert("��ʾ","��ѡ��ת��ҩƷ","warning");
		return "";
	}
	var tQty=$("#txtTQty").numberbox("getValue")||"";
	if (tQty==""){
		$.messager.alert("��ʾ","������������","warning");
		return "";	
	}
	if(parseFloat(fQty)<=0){
		$.messager.alert("��ʾ","���Ⱥ˶�����,����С�ڻ����0","warning");
		return "";		
	}
	return fPrescTypeId+"^"+fPhcDrgId+"^"+fQty+"^"+tPrescTypeId+"^"+tPhcDrgId+"^"+tQty+"^"+HospId;

}
function InitHospCombo() {
    var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'DHC_PhcConvert'});
    if (typeof genHospObj === 'object') {
        //����ѡ���¼�
        $('#_HospList').combogrid('options').onSelect = function(index, record) {
            NewHospId = record.HOSPRowId;
            if (NewHospId != HospId) {
                HospId = NewHospId;
				ClearContent();
				//InitDict();
				Query();
            }
        };
    }
}
