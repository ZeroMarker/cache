//������뱨������ͼ���Ķ��������js
//wangxuejian  2017/02/23
var RhasRegArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];  
var RhasStudyNoArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];  
var RhasOtherArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var IhasRegArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];  
var IhasStudyNoArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];  
var IhasOtherArray=[{"value":"Y","text":'��'}, {"value":"N","text":'��'}];  
function initPageDefault()
{
	initParams();
	
	initLocItemList();       ///  ���ؿ��ұ����Ϣ
	
	initMethod();
	
	initBlButton();          ///  ҳ��Button���¼�
}

function initParams(){
	curSelLoc="";	
}

function initMethod(){
	$("#searchBtn").on("click",reloadTable)	
}

///��ʼ�����ұ�
function initLocItemList(){
	$HUI.combobox("#locList",{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMInComUseMethod&MethodName=JsonLocList',
		valueField:'value',
		textField:'text',
		mode:'remote'
	})
}


/// ҳ�� Button ���¼�
function initBlButton(){
	
	$('#find').bind('click',function(event){
         commonQuery(); //���ò�ѯ��������Ϣ
    })
    
    $('#Loc').combobox({ 
    url:'dhcapp.broker.csp?ClassName=web.DHCAPPLocLinkClinicSet&MethodName=SelAllLoc',

  	valueField:'val', 
  	textField:'text',
	editable:true
}); 

}
///����ִ�б������
function addReportRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LocDr':'','HasRegNo':'Y','HasStudyNo':'Y','HasOrdItm':'Y','HasOther':'Y','HasRepId':'Y'}})
}

///����Ӱ����ò���
function addImageRow(){
	var rowsMData = $("#locItemList").datagrid('getSelected'); //ѡ����ߵĿ�����Ŀ
	commonAddRow({'datagrid':'#ImageParam',value:{'LocDr':rowsMData.LocRowId,'IhasReg':'Y','IhasStudyNo':'Y','IhasOther':'Y','HasRepId':'Y'}})
}



///����ִ�б��������Ϣ
function onClickRowReport(index,row){	 
	CommonRowClick(index,row,"#datagrid");
} 
///����Ӱ����ò�����Ϣ
function onClickRowImage(index,row){
	RowClick(index,row,"#ImageParam");
} 
///����ִ�б����б�
function saveReportRow(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	var methodName = (index==0?"SaveReport":"SaveImage");

	saveByDataGrid("web.DHCAPPLocLinkClinicSet",methodName,"#datagrid",function(data){
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�');
		}
	    else{
			$.messager.alert('��ʾ','����ʧ��:'+data);
		}
		reloadTable();
	})
}

/// ɾ��ִ�б����е���
function deleteReportRow(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������(ɾ����ִ�б��������Ӱ�����������ɾ����", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPLocLinkClinicSet","DelReportImage",{"params":rowsData.RBCDr},function(jsonString){
					reloadTable(); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}


/// ɾ��Ӱ������е���
function deleteImageRow(){
	
	var rowsData = $("#ImageParam").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������(ɾ����ִ�б��������Ӱ�����������ɾ����", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPLocLinkClinicSet","DelReportImage",{"params":rowsData.Rowid},function(jsonString){
					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}



/// ������������ѯ����
function commonQuery() 
{
	var desc=$('#Loc').combobox('getText');
	/// ����
	var param=desc;
	$('#locItemList').datagrid('load',{params:param}); 
}

function reloadTable(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	var inLocID = $HUI.combobox("#locList").getValue();
	var reportType= (index==0?"R":"I");
	var params = reportType+"^"+inLocID;
	$HUI.datagrid('#datagrid').load({
		Params:params
	})
}




/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
