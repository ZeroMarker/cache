
var LINK_CSP="dhcapp.broker.csp";

/// ҳ���ʼ������
function initPageDefault(){
	initcolumns();	 /// ��ʼ����������
}
function initcolumns()
{
	/// ����datagrid
	var symcolumns=[[
		{field:'CotText',title:'�������',width:430},
		{field:'CotID',title:'����ID',width:50,hidden:true}
	]];
	
	///  ����datagrid  
	var symoption = {
		height:200,
		rownumbers : true,
		singleSelect : true,
		columns:symcolumns,
		onDblClickRow: function (rowIndex, rowData) {
           var rowsData = $("#patcotlist").datagrid('getSelected');
           window.parent.$("#ConsOpinion").val(rowsData.CotText);
           parent.$('#winonline').window('close');
        } 
	};

	var symuniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByLoc&LocDr="+window.parent.session['LOGON.CTLOCID'];
	new ListComponent('patcotlist', symcolumns, symuniturl, symoption).Init();
	
}

/// ������������
function quotesymdata()
{
	var rowsData = $("#patcotlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫ���õ����ݣ�");
		return;
		}
	window.parent.$("#ConsOpinion").val(rowsData.CotText);
	parent.$('#winonline').window('close');
}
/// ɾ������ģ��
function deletesymrow()
{

	var UserID = window.parent.session['LOGON.USERID'];
	var LocID = window.parent.session['LOGON.CTLOCID'];
	var rowsData = $("#patcotlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null)
	{
		debugger;
		if((rowsData.CotLoc!="")&&(rowsData.CotLoc!=LocID)){
			$.messager.alert("��ʾ","û��Ȩ��ɾ��!");
			return;
		}
		
		if((rowsData.CotUser!="")&&(rowsData.CotUser!=UserID)){
			$.messager.alert("��ʾ","û��Ȩ��ɾ��!");
			return;
		}
		
		runClassMethod("web.DHCEMConsult","DeleteCot",{"CotID":rowsData.CotID},function(jsonString){
			$HUI.datagrid("#patcotlist").reload();
		})
	}
}

/// �����ֲ�ʷ����
function quoteprehisdata()
{
	
	var rowsData = $("#patprehislist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫ���õ����ݣ�");
		return;
		}
	window.parent.$("#arDisHis").val(rowsData.PatPreHis);
	parent.$('#winonline').window('close');
}
/// ɾ���ֲ�ʷģ��
function deleteprehisrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patprehislist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫɾ�������ݣ�");
		return;
		}
	if (UserId!=rowsData.opUserDr){
		$.messager.alert('��ʾ','��û�в���Ȩ��','warning');
		 return;
		}
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPExaReport","DeletePreHis",{"apRowId":rowsData.apRowId,"OpUserId":rowsData.opUserDr},function(jsonString){
					$('#patprehislist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ������������
function quotesigndata()
{
	var rowsData = $("#patsignlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫ���õ����ݣ�");
		return;
		}
	window.parent.$("#arPhySig").val(rowsData.PatSign);
	parent.$('#winonline').window('close');
}
/// ɾ������ģ��
function deletesignrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patsignlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫɾ�������ݣ�");
		return;
		}
	if (UserId!=rowsData.optUserDr){
		$.messager.alert('��ʾ','��û�в���Ȩ��','warning');
		 return;
		}
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPExaReport","DeleteSign",{"aptRowId":rowsData.aptRowId,"OpUserId":rowsData.optUserDr},function(jsonString){
					$('#patsignlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ��ȡ���߿���ģ��
function symtompublicmodel()
{
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByLoc&LocDr="+window.parent.session['LOGON.CTLOCID'];
	$('#patcotlist').datagrid({url:uniturl});
}


///��ȡ���߸���ģ��
function symtompersonalmodel()
{
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByUser&UserDr="+window.parent.session['LOGON.USERID'];
	$('#patcotlist').datagrid({url:uniturl});
}

/// ��ȡ�ֲ�ʷ����ģ��
function prehispublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPublicFormat&params="+Saveas;
	$('#patprehislist').datagrid({url:uniturl});
}

/// ��ȡ�ֲ�ʷ����ģ��
function prehispersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPersonalFormat&params="+Saveas;
	$('#patprehislist').datagrid({url:uniturl});
}

/// ��ȡ��������ģ��
function signpublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPublicFormat&params="+Saveas;
	$('#patsignlist').datagrid({url:uniturl});
}

/// ��ȡ��������ģ��
function signpersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPersonalFormat&params="+Saveas;
	$('#patsignlist').datagrid({url:uniturl});
}
/// JQuery ��ʼ��ҳ��
$(function(){initPageDefault(); })