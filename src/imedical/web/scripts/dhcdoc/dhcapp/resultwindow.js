/// ҳ���ʼ������
function initPageDefault(){
	initcolumns();	 /// ��ʼ����������
}
function initcolumns()
{
	/// ����datagrid
	var symcolumns=[[
		{field:'EpisodeID',title:'����ID',width:50,hidden:true},
		{field:'PatStmTom',title:'����',width:430},
		{field:'amSave',title:'�������',width:50,hidden:true},
		{field:'amPointer',title:'��ӦID',width:50,hidden:true},
		{field:'opUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'amRowId',title:'ID',width:40,hidden:true},
	
	]];
	
	///  ����datagrid  
	var symoption = {
		rownumbers : true,
		singleSelect : true,
		columns:symcolumns,
		onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
           var rowsData = $("#patsymtomlist").datagrid('getSelected');
           window.parent.$("#arPatSym").val(rowsData.PatStmTom);
           parent.$('#winonline').window('close');
        } 
	};

	var symuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patsymtomlist', symcolumns, symuniturl, symoption).Init();
	
	
	/// �ֲ�ʷ datagrid
	var precolumns=[[
		
		{field:'EpisodeID',title:'����ID',width:50,hidden:true},
		{field:'PatPreHis',title:'�ֲ�ʷ',width:430},
		{field:'apSave',title:'�������',width:50,hidden:true},
		{field:'apPointer',title:'��ӦID',width:50,hidden:true},
		{field:'opUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'apRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  ����datagrid  
	var preoption = {
		rownumbers : true,
		singleSelect : true,
		columns:precolumns,
		onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
           var rowsData = $("#patprehislist").datagrid('getSelected');
           window.parent.$("#arDisHis").val(rowsData.PatPreHis);
           parent.$('#winonline').window('close');
        } 
	};

	var preuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patprehislist', precolumns, preuniturl, preoption).Init(); 
	
	
	/// ���� datagrid
	var signcolumns=[[
		
		{field:'EpisodeID',title:'����ID',width:50,hidden:true},
		{field:'PatSign',title:'����',width:430},
		{field:'aptSave',title:'�������',width:50,hidden:true},
		{field:'aptPointer',title:'��ӦID',width:50,hidden:true},
		{field:'optUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'aptRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  ����datagrid  
	var signoption = {
		rownumbers : true,
		singleSelect : true,
		columns:signcolumns,
		onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
           var rowsData = $("#patsignlist").datagrid('getSelected');
           window.parent.$("#arPhySig").val(rowsData.PatSign);
           parent.$('#winonline').window('close');
        } 
	};

	var signuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patsignlist', signcolumns, signuniturl, signoption).Init(); 
	
		/// ���Ŀ�� datagrid
	var purcolumns=[[
		
		{field:'EpisodeID',title:'����ID',width:50,hidden:true},
		{field:'PatPur',title:'���Ŀ��',width:430},
		{field:'aptSave',title:'�������',width:50,hidden:true},
		{field:'aptPointer',title:'��ӦID',width:50,hidden:true},
		{field:'optUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'aptRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  ����datagrid  
	var puroption = {
		rownumbers : true,
		singleSelect : true,
		columns:purcolumns,
		onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
           var rowsData = $("#patpurposelist").datagrid('getSelected');
           window.parent.$("#ExaPurp").val(rowsData.PatPur);
           parent.$('#winonline').window('close');
        } 
	};
	var puruniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patpurposelist', purcolumns, puruniturl, puroption).Init(); 
}

/// ������������
function quotesymdata()
{
	var rowsData = $("#patsymtomlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫ���õ����ݣ�");
		return;
		}
	window.parent.$("#arPatSym").val(rowsData.PatStmTom);
	parent.$('#winonline').window('close');
}
/// ɾ������ģ��
function deletesymrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patsymtomlist").datagrid('getSelected'); //ѡ��Ҫɾ������
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
				runClassMethod("web.DHCAPPExaReport","DeletePatSymTom",{"amRowId":rowsData.amRowId,"OpUserId":rowsData.opUserDr},function(jsonString){
					$('#patsymtomlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
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
/// ���ü��Ŀ������
function quotepurdata()
{
	var rowsData = $("#patpurposelist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("��ʾ", "��ѡ��Ҫ���õ����ݣ�");
		return;
		}
	window.parent.$("#ExaPurp").val(rowsData.PatPur);
	parent.$('#winonline').window('close');
}
/// ɾ������ģ��
function deletepurrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patpurposelist").datagrid('getSelected'); //ѡ��Ҫɾ������
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
				runClassMethod("web.DHCAPPExaReport","DeletePur",{"aptRowId":rowsData.aptRowId,"OpUserId":rowsData.optUserDr},function(jsonString){
					$('#patpurposelist').datagrid('reload'); //���¼���
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
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPublicFormat&params="+Saveas;
	$('#patsymtomlist').datagrid({url:uniturl});
}


///��ȡ���߸���ģ��
function symtompersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPersonalFormat&params="+Saveas;
	$('#patsymtomlist').datagrid({url:uniturl});
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
/// ��ȡ���Ŀ�Ŀ���ģ��
function purpublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPublicFormat&params="+Saveas;
	$('#patpurposelist').datagrid({url:uniturl});
}
/// ��ȡ���Ŀ�ĸ���ģ��
function purpersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPersonalFormat&params="+Saveas;
	$('#patpurposelist').datagrid({url:uniturl});
}
/// JQuery ��ʼ��ҳ��
$(function(){initPageDefault(); })