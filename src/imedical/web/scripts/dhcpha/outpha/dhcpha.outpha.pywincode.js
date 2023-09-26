/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҳ-��˵�-��ҩ���ڶ���
createdate:2016-07-07
creator:dinghongying
*/

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
	InitPYWinCodeList();	
	var LocDescCombo=new ListCombobox("LocDesc",commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'','',combooption);
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
	}
	if(WinDesc==""){
		$.messager.alert('��ʾ',"�����봰������!","info");
	}
	else{
		var retValue= tkMakeServerCall("web.DHCOutPhCode","insertPhPyWin",LocRowId,WinDesc,BoxNum,SendCode);
		if(retValue==0){
			$.messager.alert('��ʾ',"���ӳɹ�!","info");
			$('#PYWinCodedg').datagrid('reload');
		}else if(retValue==-2){
			$.messager.alert('��ʾ',"����ҩ�����Ѷ��壬�����½������!","warning");
		}else if(retValue==-4){
			$.messager.alert('��ʾ',"����������ҩ������ά�������Ӹ�ҩ��!","warning");
		}else{
			$.messager.alert('��ʾ',"���ʧ��,�������:"+retValue,"warning");
		}
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
	else{
		var RowId=selected.TPhPyWin;
		var WinDesc=$("#WinDesc").val();
	    var BoxNum=$("#BoxNum").val();
	    var SendCode=$("#SendCode").val();
		var retValue=tkMakeServerCall("web.DHCOutPhCode","UpdatePhPyWin",RowId,WinDesc,BoxNum,SendCode);
		if(retValue==0){
			$.messager.alert('��ʾ',"�޸ĳɹ�!");
			$('#PYWinCodedg').datagrid('reload');
		}else if (retValue=="-1"){
			$.messager.alert('��ʾ',"�޸ĺ󴰿������Ѵ���!","info");
		}
		else {
			$.messager.alert('��ʾ',"�޸�ʧ��,�������:"+retValue);
		}
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
				var retValue=tkMakeServerCall("web.DHCOutPhCode","DeletePhPyWin",RowId);
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
	var params=$("#LocDesc").combobox("getValue");
	$('#PYWinCodedg').datagrid('options').queryParams.params = params;//����ֵ  
    $("#PYWinCodedg").datagrid('reload');//���¼���table  
}

function Clear(){
	$("#LocDesc").combobox("setValue","");
	$("#WinDesc").val("");
	$("#BoxNum").val("");
	$("#SendCode").val("");
	$('#PYWinCodedg').datagrid('options').queryParams.params = "";
    $("#PYWinCodedg").datagrid('reload');	
}