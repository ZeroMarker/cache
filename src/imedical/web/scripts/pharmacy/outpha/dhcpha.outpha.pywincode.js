/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҳ-��˵�-��ҩ���ڶ���
createdate:2016-07-07
creator:dinghongying
*/
var HospId=session['LOGON.HOSPID'];
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.pywincode.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitHospCombo();
	InitPYWinCodeList();	
	var LocDescCombo=new ListCombobox("LocDesc",commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'&HospId='+HospId,'',combooption);
	LocDescCombo.init(); //��ʼ��ҩ������	
	$('#Badd').on('click', Add);//�������
	$('#Bupdate').on('click', Update);//����޸�
	$('#BDelete').on('click', Delete);//���ɾ��
	$('#BDelete').hide();
	$('#Bfind').on('click',Query);//����ɾ����ť
	$("#BClear").on('click',Clear)
});

//��ʼ����ҩ���ڶ����б�
function InitPYWinCodeList(){
	//����columns
	var columns=[[
	    {field:'TLocId',title:'TLocId',width:200,hidden:true},
	    {field:'TPhPyWin',title:'TPhPyWin',width:200,hidden:true},
	    {field:'TPhlid',title:'TPhlid',width:200,hidden:true},
	    {field:'TLocDesc',title:'ҩ������',width:200,align:'left'},
	    {field:'TWinDesc',title:'��������',width:200,align:'left'},
	    {field:'TBoxNum',title:'ҩ����',width:200,align:'right'},
	    {field:'TSendCode',title:'����˿ں�',width:200,align:'right'}
	]];  
   //����datagrid	
   $('#PYWinCodedg').datagrid({    
        url:thisurl+'?action=GetPYWinCodeList',
     	queryParams:{
			HospId:HospId
		},
        fit:true,
	    border:false,
	    striped:true,
	    toolbar:'#btnbar',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onSelect:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowId'];
				var locdesc=rowData['TLocDesc'];
				var locid=rowData['TLocId'];
				var windesc=rowData['TWinDesc'];
				var boxnum=rowData['TBoxNum'];
				var sendcode=rowData['TSendCode'];
				$("#LocDesc").combobox('setValue',locid);
				$("#LocDesc").combobox('setText',locdesc);
				$("#WinDesc").val(windesc);
				$("#BoxNum").val(boxnum);
				$("#SendCode").val(sendcode);
				//$("#LocDesc").combobox('disable')
			}
		} 
   });
}
///��ҩ��������
function Add()
{
	var LocRowId=$("#LocDesc").combobox("getValue");
	var WinDesc=$("#WinDesc").val();
	var BoxNum=$("#BoxNum").val();
	var SendCode=$("#SendCode").val();
	if((LocRowId=="")||(LocRowId==undefined)){
		$.messager.alert('��ʾ',"��ѡ��ҩ������!","info");
		return;
	}
	if(WinDesc==""){
		$.messager.alert('��ʾ',"�����봰������!","info");
		return;
	}
	var retValue= tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Insert",LocRowId,WinDesc,BoxNum,SendCode);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('��ʾ', retMessage, "warning");
		return;
	} else {
		$.messager.alert('��ʾ',"���ӳɹ�!","info");
		$('#PYWinCodedg').datagrid('reload');
	}
}

///��ҩ�����޸�
function Update()
{
	var selected = $("#PYWinCodedg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�޸ĵ�����!","info");
		return;
	}
	var RowId=selected.TPhPyWin;
	var ctLocId=selected.TLocId;
	var LocRowId=$("#LocDesc").combobox("getValue");
	if (ctLocId != LocRowId) {
		$.messager.alert('��ʾ', "�������޸�ҩ��!", "warning");
		return;
	}
	var WinDesc=$("#WinDesc").val();
    var BoxNum=$("#BoxNum").val();
    var SendCode=$("#SendCode").val();
	var retValue=tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Update",RowId,WinDesc,BoxNum,SendCode);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('��ʾ', retMessage, "warning");
		return;
	} else {
		$.messager.alert('��ʾ', "�޸ĳɹ�!", "info");
		$('#PYWinCodedg').datagrid('reload');
	}
}

///��ҩ����ɾ��
function Delete(){
	var selected = $("#PYWinCodedg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫɾ��������!","info");
		return;
	}
	else{
		var RowId=selected.PhPyWin
		$.messager.confirm('��ʾ',"ȷ��ɾ����",function(r){
			if(r){
				var retValue=tkMakeServerCall("PHA.OP.CfPyWin.OperTab","Delete",RowId);
				if(retValue==0){
					$.messager.alert('��ʾ',"ɾ���ɹ�!");
					$('#PYWinCodedg').datagrid('reload');
				}
				else{
					$.messager.alert('��ʾ',"ɾ��ʧ��,�������:"+retValue,"warning");
				}
			}
		});
	}
}
///��ҩ�����б��ѯ
function Query(){
	var LocId=$("#LocDesc").combobox("getValue")
	var WinDesc=$("#WinDesc").val();
	var params=LocId+"^"+WinDesc;
	$('#PYWinCodedg').datagrid('options').queryParams.params = params;//����ֵ  
    $("#PYWinCodedg").datagrid('reload');//���¼���table  
}

function Clear(){
	$("#LocDesc").combobox("setValue","");
	$("#WinDesc").val("");
	$("#BoxNum").val("");
	$("#SendCode").val("");
	$('#PYWinCodedg').datagrid('options').queryParams.params = "";
	$('#PYWinCodedg').datagrid('options').queryParams.HospId = HospId;
    $("#PYWinCodedg").datagrid('reload');	
}

function InitHospCombo(){
	var genHospObj =DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-PreWindow'}); //����ҽԺ
	if (typeof genHospObj === 'object') {
		//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#LocDesc').combobox('loadData',[]);
				$('#LocDesc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+'&HospId='+HospId;
				$('#LocDesc').combobox('reload');	
				Clear();	
			}
		};
	}
}