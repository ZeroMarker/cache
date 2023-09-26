///���: lmm 2016-12-09 
///����:΢�Ų�����־��ѯ
/// -------------------------------
var preRowID=0
var GlobalObj = {
	UserDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="User") this.UserDR="";
	},
	ClearAll : function()
	{
		this.UserDR="";
	}
}

$(document).ready(function()
{
	initCombobox();
	initDocument();
	$('#tdhceqwchatoperationlogfind').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		fit:'true',
		queryParams:{
			ClassName:"web.DHCEQWChatUser",
			QueryName:"GetWChatOperationLog",
			Arg1:$("#LogType").combobox('getValue'),
			Arg2:$("#ChatID").val(),
			Arg3:GlobalObj.UserDR,
			Arg4:$("#StartDate").datebox("getText"),
			Arg5:$("#EndDate").datebox("getText"),
			Arg6:$("#MethodDesc").combobox('getValue'),
			ArgCnt:6
			},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-search',
				text:'��ѯ',
				handler:function(){FindGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},  
			{field:'TLogTypeID',title:'��־����ID',width:100,align:'center',hidden:true}, 
			{field:'TLogType',title:'��־����',width:100,align:'center'},
			{field:'TChatID',title:'΢��ID',width:50,align:'center'}, 
			{field:'TUserDR',title:'�û�ID',width:50,align:'center',hidden:true}, 
			{field:'TUser',title:'�û�',width:100,align:'center'},
			{field:'TGroupDR',title:'��ȫ��ID',width:100,align:'center',hidden:true},
			{field:'TGroup',title:'��ȫ��',width:100,align:'center'},
			{field:'TLocDR',title:'����ID',width:100,align:'center',hidden:true},
			{field:'TLoc',title:'����',width:100,align:'center'},
			{field:'TLogDate',title:'��־����',width:120,align:'center'}, 
			{field:'TLogTime',title:'��־ʱ��',width:120,align:'center'},
			{field:'TBindType',title:'������',width:55,align:'center'},
			{field:'TPermission',title:'���',width:50,align:'center'},
			{field:'TMethodCode',title:'��������',width:55,align:'center'},
			{field:'TMethodDescC',title:'��������',width:270,align:'center'},
			{field:'TMethodDescE',title:'��������(��)',width:270,align:'center',hidden:true},
			]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});
	
});
function ClearElement()
{
	$('#RowID').val('');
	$('#LogType').combobox('setValue',"");
	$('#ChatID').val('');
	$('#UserDR').combogrid('setValue','');
	$('#UserDR').combogrid('setText','');
	$('#StartDate').datebox('setValue','');
	$('#EndDate').datebox('setValue','');
	$('#MethodDesc').combobox('setValue',"");

}

function initDocument()
{
	GlobalObj.ClearAll();
	initUserPanel();
	initUserData();
}

function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="User") {initUserData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="User") {GlobalObj.UserDR = CurValue;}
}


function FindGridData() 
{
	$('#tdhceqwchatoperationlogfind').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQWChatUser',
			QueryName:'GetWChatOperationLog',
			Arg1:$("#LogType").combobox('getValue'),
			Arg2:$("#ChatID").val(),
			Arg3:GlobalObj.UserDR,
			Arg4:$("#StartDate").datebox("getText"),
			Arg5:$("#EndDate").datebox("getText"),
			Arg6:$("#MethodDesc").combobox('getValue'),
			ArgCnt:6
		}
	});
}




function initCombobox()
{	
	jQuery("#StartDate").datebox("setText",jQuery("#CurDate").val());
	if (jQuery("#MethodDesc").prop("type")!="hidden")
	{
		jQuery("#MethodDesc").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'ȫ��'
			},{
				id: '0001',
				text: 'ɨ���豸����õ��豸������Ϣ'
			},{
				id: '0002',
				text: 'ά�޻�������'
			},{
				id: '0003',
				text: '����ά�޵�'
			},{
				id: '0004',
				text: '�Զ�����ά�޶���'
			},{
				id: '0005',
				text: '������ά�޵��ݲ�ѯ'
			},{
				id: '0006',
				text: '�ύά�޵�'
			},{
				id: '0007',
				text: 'ά������,��ɲ���'
			},{
				id: '0008',
				text: '��ȡά��ͼƬ'
			},{
				id: '0010',
				text: '��ȡһ��ά�޵���'
			},{
				id: '0011',
				text: '��ȡά��������Ŀ'
			},{
				id: '0012',
				text: '��ȡ�����б�'
			},{
				id: '0013',
				text: '�����û���ȡ����'
			},{
				id: '0014',
				text: '����ά��������Ϣ'
			},{
				id: '0015',
				text: 'Զ�̻�ȡFTP��Ϣ'
			},{
				id: '0018',
				text: '��ȡ�����豸ά�޵�'
			},{
				id: '0019',
				text: '����ά�޽��ȱ���'
			},{
				id: '0020',
				text: '��ȡά�޽��ȱ�����Ϣ'
			},{
				id: '0021',
				text: '��ȡһ��������Ϣ'
			},{
				id: '0022',
				text: '����ά��ͼƬ��Ϣ'
			},{
				id: '0023',
				text: '��ȡά��ͼƬ��Ϣ'
			},{
				id: '0024',
				text: '��ȡ��ȫ��ɷ��ʲ˵�����'
			},{
				id: '0025',
				text: 'ά�޴����б�'
			},{
				id: '0026',
				text: '�����̶�'
			},{
				id: '0027',
				text: '��Ա�б�'
			},{
				id: '0028',
				text: '��������'
			},{
				id: '0029',
				text: '����ԭ��'
			},{
				id: '0030',
				text: '�������'
			},{
				id: '0031',
				text: 'ά�޷�ʽ'
			},{
				id: '0032',
				text: '����ҵ���б�'
			},{
				id: '0033',
				text: '��������'
			},{
				id: '0034',
				text: '��ȡ�ɱ༭�ֶ�'
			},{
				id: '0035',
				text: '��ȡ����������'
			},{
				id: '0036',
				text: '��ȡ��ת����'
			},{
				id: '0037',
				text: '��ȡ��������Ϣ'
			},{
				id: '0038',
				text: '���س̶�'
			},{
				id: '0039',
				text: 'ά�޸����б�'
			},{
				id: '0040',
				text: '������'
			},{
				id: '0041',
				text: 'ά�޽��'
			},{
				id: '0042',
				text: '��֤��½��Ϣ�Ƿ���ȷ'
			},{
				id: '0043',
				text: '��ȡ��ȫ���½����'
			},{
				id: '0044',
				text: '��֤��ȫ���Ƿ���ȷ'
			},{
				id: '0045',
				text: '��id'
			},{
				id: '0046',
				text: '�����û�΢���Ƿ��'
			},{
				id: '0047',
				text: '��Ϣ��ȡ'
			},{
				id: '0048',
				text: 'FTP����������'
			},{
				id: '0049',
				text: 'ά����Ա��Ϣ'
			},{
				id: '0050',
				text: 'ά�������ɾ��'
			},{
				id: '0051',
				text: '�����ϸ�ύ���'
			},{
				id: '0052',
				text: '�����ϸȡ���ύ���'
			},{
				id: '0053',
				text: 'ά�޵�����б���Ϣ'
			},{
				id: '0054',
				text: '��������'
			},{
				id: '0055',
				text: '��Ӧ��'
			},{
				id: '0056',
				text: '�������'
			},{
				id: '0057',
				text: '������б���Ϣ'
			},{
				id: '0058',
				text: '����ͼƬ�ϴ���־'
			},{
				id: '0059',
				text: '����ͳ��'
			},{
				id: '0060',
				text: '���������Ϣ'
			},{
				id: '0061',
				text: '�����豸��Ϣ'
			},{
				id: '0062',
				text: '�����豸��'
			},{
				id: '0063',
				text: '��ȡ�������Ŀ���ID'
			},{
				id: '0064',
				text: '���޵���SavaData����'
			},{
				id: '0065',
				text: '����ID��ȡ������ϸ'
			},{
				id: '0066',
				text: '��ȡ̨�˱��豸��Ϣ'
			},{
				id: '0067',
				text: '���޵����б�'
			},{
				id: '0068',
				text: '����������δ�黹�豸'
			},{
				id: '0069',
				text: '��ȡ������˵���Ϣ'
			},{
				id: '0070',
				text: '��ȡ����������Ϣ'
			},{
				id: '0071',
				text: '��ȡά�޶����б�'
			}],
			
			onSelect: function() {}
		});
			}
	}

