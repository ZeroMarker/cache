/*
 * FileName:	dhcinsu.signin.js
 * User:		tangzf
 * Date:		2020-03-07
 * Function:	
 * Description: 医保 签到/签退
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
	// 操作员
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
    			"text":"门诊",
    			selected:true
    		},{
    			"id" : '2',
    			"text":"住院"	
    		}]
	})
					
}
/*
 * 医保类型
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

			{field:'INSUserCode',title:'操作员工号',width:150 },
			{field:'INSUserDesc',title:'操作员',width:150},
			{field:'INSBusiNo',title:'业务周期流水号',width:150},
			{field:'INSActFlag',title:'有效标志',width:150},
			{field:'INSInsuType',title:'医保类型',width:220},
			{field:'INSLgInDate',title:'签到日期',width:150},
			{field:'INSLgOutDate',title:'签退日期',width:150},
			{field:'INSiDate',title:'操作日期',width:150},
			{field:'INSLgInMAC',title:'签到MAC地址',width:120},
			{field:'INSLgInIP',title:'签到IP地址',width:150},
			{field:'INSLgOutMAC',title:'签退MAC地址',width:150},	
			{field:'INSLgOutIP',title:'签退IP地址',width:150},
			{field:'INSExpStr1',title:'社保经办机构',width:150},
			{field:'INSExpStr2',title:'是否上传签到',width:150},
			{field:'INSExpStr3',title:'特殊情况说明',width:150},
			{field:'INSYWLX',title:'业务类型',width:150}, //空:全部、 1:门诊、2:住院
			{field:'INSHospDr',title:'院区',width:150},
			{field:'INSUserDr',width:150,hidden:true }
			
		]];
	// 初始化DataGrid
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
 * 签到
 */
function signInClick(){
	if(getValueById('TINSUType') == ''){
		$.messager.alert('提示','医保类型不能为空','info');
		return;
	}
	var Handle = 1;
	var UserId = session['LOGON.USERID'];
	var HospId = session['LOGON.HOSPID'];
	var AdmType = getValueById('TAdmType')
	var ExpString = getValueById('TINSUType') + '^^' + AdmType + '^' +  HospId;
	var rtn = InsuASSignIn(Handle,UserId,ExpString);
	if(rtn == 1){
		$.messager.alert('提示','签到成功' ,'info',function(){
			loadDataGrid();
		});	
	}else{
		$.messager.alert('提示','签到失败：' + rtn ,'info',function(){
			loadDataGrid();
		});		
	}
}
/*
 * 签退
 */
function signOutClick(){
	var  SelectRow = $('#dg').datagrid('getSelected');
	if(!SelectRow){
		$.messager.alert('提示','请选择要签退的数据','info');
		return;
	}
	if(getValueById('TINSUType') == ''){
		$.messager.alert('提示','医保类型不能为空','info');
		return;
	}
	var Handle = 0;
	var UserId = SelectRow.INSUserDr;
	var HospId = session['LOGON.HOSPID'];
	var AdmType = getValueById('TAdmType')
	var ExpString = getValueById('TINSUType') + '^^' + AdmType + '^' + SelectRow.INSBusiNo + '^' +   HospId;
	var rtn = InsuASSignOut(Handle,UserId,ExpString);
	if(rtn == '1'){
			$.messager.alert('提示','签退成功：' + rtn ,'info',function(){
			loadDataGrid();
		});	
	}else{
	        $.messager.alert('提示','签退失败：' + rtn,'info',function(){
			loadDataGrid();
		});	
	}
}
/*
 * 加载数据
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