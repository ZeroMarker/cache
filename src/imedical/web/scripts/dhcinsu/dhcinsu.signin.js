/*
 * FileName:	dhcinsu.signin.js
 * User:		tangzf
 * Date:		2020-03-07
 * Function:	
 * Description: ҽ�� ǩ��/ǩ��
 */
 //ServerNameSpace = 'cn_iptcp:114.242.246.235[1972]:DHC-APP'
 var HospDr=session['LOGON.HOSPID'];
 $(function () { 
 
	setValueById('TStartDate',getDefStDate(0));
	setValueById('TEndDate',getDefStDate(0));
	//
	init_dg(); 
	// 
	init_INSUType();
	// ����Ա
	init_User();
	init_AdmType();
});
function init_User(){
	
	$HUI.combobox(('#TUser'),{
		defaultFilter:'4',
		valueField: 'RowId',
		textField: 'Desc',
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'INSU.COM.BaseData';
			param.QueryName= 'FindSSUser';
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
		},
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}		
	})	
}
function init_AdmType(){
	$HUI.combobox(('#TAdmType'),{
		valueField: 'id',
		textField: 'text',
		data:[{
    			"id" : '1',
    			"text":"����",
    			selected:true
    		},{
    			"id" : '2',
    			"text":"סԺ"	
    		}]
	})
					
}
/*
 * ҽ������
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'N',
		hospDr:HospDr
	}
	INSULoadDicData('TINSUType','DLLType',Options); 	
}
/*
 * datagrid
 */
function init_dg(){
	var dgColumns = [[

			{field:'INSUserCode',title:'����Ա����',width:150 },
			{field:'INSUserDesc',title:'����Ա',width:150},
			{field:'INSBusiNo',title:'ҵ��������ˮ��',width:150},
			{field:'INSActFlag',title:'��Ч��־',width:150},
			{field:'INSInsuType',title:'ҽ������',width:220},
			{field:'INSLgInDate',title:'ǩ������',width:150},
			{field:'INSLgOutDate',title:'ǩ������',width:150},
			{field:'INSiDate',title:'��������',width:150},
			{field:'INSLgInMAC',title:'ǩ��MAC��ַ',width:120},
			{field:'INSLgInIP',title:'ǩ��IP��ַ',width:150},
			{field:'INSLgOutMAC',title:'ǩ��MAC��ַ',width:150},	
			{field:'INSLgOutIP',title:'ǩ��IP��ַ',width:150},
			{field:'INSExpStr1',title:'�籣�������',width:150},
			{field:'INSExpStr2',title:'�Ƿ��ϴ�ǩ��',width:150},
			{field:'INSExpStr3',title:'�������˵��',width:150},
			{field:'INSYWLX',title:'ҵ������',width:150}, //��:ȫ���� 1:���2:סԺ
			{field:'INSHospDr',title:'Ժ��',width:150},
			{field:'INSUserDr',width:150,hidden:true }
			
		]];
	// ��ʼ��DataGrid
	$('#dg').datagrid({
		data:{'rows':[],'total':'0'},
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar:'#dgTB'
	});
		
}
/*
 * ǩ��
 */
function signInClick(){
	if(getValueById('TINSUType') == ''){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;
	}
	var Handle = 1;
	var UserId = session['LOGON.USERID'];
	var HospId = session['LOGON.HOSPID'];
	var AdmType = getValueById('TAdmType')
	var ExpString = getValueById('TINSUType') + '^^' + AdmType + '^' +  HospId;
	var rtn = InsuASSignIn(Handle,UserId,ExpString);
	if(rtn == 1){
		$.messager.alert('��ʾ','ǩ���ɹ�' ,'info',function(){
			loadDataGrid();
		});	
	}else{
		$.messager.alert('��ʾ','ǩ��ʧ�ܣ�' + rtn ,'info',function(){
			loadDataGrid();
		});		
	}
}
/*
 * ǩ��
 */
function signOutClick(){
	var  SelectRow = $('#dg').datagrid('getSelected');
	if(!SelectRow){
		$.messager.alert('��ʾ','��ѡ��Ҫǩ�˵�����','info');
		return;
	}
	if(getValueById('TINSUType') == ''){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;
	}
	var Handle = 0;
	var UserId = SelectRow.INSUserDr;
	var HospId = session['LOGON.HOSPID'];
	var AdmType = getValueById('TAdmType')
	var ExpString = getValueById('TINSUType') + '^^' + AdmType + '^' + SelectRow.INSBusiNo + '^' +   HospId;
	var rtn = InsuASSignOut(Handle,UserId,ExpString);
	if(rtn == '1'){
			$.messager.alert('��ʾ','ǩ�˳ɹ���' + rtn ,'info',function(){
			loadDataGrid();
		});	
	}else{
	        $.messager.alert('��ʾ','ǩ��ʧ�ܣ�' + rtn,'info',function(){
			loadDataGrid();
		});	
	}
}
/*
 * ��������
 */
function loadDataGrid(){
    var queryParams = {
	    ClassName : 'web.DHCINSUSSUserSgnCtl',
	    QueryName : 'QueryINSUSSUserSgn',
	    StartDate : getValueById('TStartDate'),
	    EndDate : getValueById('TEndDate'),
	    User : getValueById('TUser'),
	    HospId : session['LOGON.HOSPID'],
	    INSUType : getValueById('TINSUType'),
	    AdmType : ''
	}	
    loadDataGridStore('dg',queryParams);
} 