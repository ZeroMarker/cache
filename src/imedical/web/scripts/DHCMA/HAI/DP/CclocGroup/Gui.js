
//��๤����Gui
function InitCCLocGroupLocWin(){
   
    obj={
        LocID:"",
        SysUserID:"",
        LocGrpID:"",
        UserID:"",
        UserDesc:"",
        PhoneNum:"",
        type:""
    }
    //����������
    obj.cboLocGrpType = $HUI.combobox("#cboLocGrpType,#cboLocGrpTypeT", {
        url:$URL,
        editable: true,       
        defaultFilter:4,     
        valueField: 'ID',
        textField: 'DicDesc',
        onBeforeLoad: function (param) {
            param.ClassName = 'DHCHAI.BTS.DictionarySrv';
            param.QueryName = 'QryDic';
            param.aTypeCode = 'CCLocGroupType';
            param.aActive = '1';
            param.ResultSetType = 'array'
        },
        onLoadSuccess:function(){  
            var data=$(this).combobox('getData');
            if (data.length>0){
                $(this).combobox('select',data[0]['ID']);
            }
        }
    });
    //ҽԺ
	obj.cboHospital = $HUI.combobox("#cboHospital,#cboHospitalT", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospital&ResultSetType=array";
		   	$(this).combobox('reload',url);
		}
	});
    obj.gridLocation = $HUI.datagrid("#gridLocation",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryLoc',
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'), 
			aLocCate:"",
			aLocType:"",
			aIsActive:""
		},
		columns:[[
			{field:'LocDesc',title:'��������',width:160},
			{field:'LocTypeDesc',title:'��������',width:80},
			{field:'LocCateDesc',title:'��������',width:80},
			{field:'HospDesc',title:'ҽԺ',width:200},
			{field:'IsOPER',title:'��������',width:80},
			{field:'IsICU',title:'��֢����',width:80},
			{field:'IsNICU',title:'����������',width:80},
			{field:'ICUTpDesc',title:'ICU����',width:80},
	        {field:'IsActive',title:'�Ƿ���Ч',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocID) {
                    obj.LocID="";
                    $("#btnAdd").linkbutton("disable");
                    obj.gridLocation.clearSelections();
                } else {
                    obj.LocID=rowData["ID"]
                    $("#btnAdd").linkbutton("enable");
                }
				obj.gridUserLoad();
			}
		}
	});

	 obj.gridSysUser = $HUI.datagrid("#gridSysUser",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.BTS.SysUserSrv',
			QueryName:'QrySysUserList',
			aLocID:"", 
			aTypeID:"", 
			aUserName:"",
			aUserCode:"", 
			aIsActive:"",
			aHospIDs:$("#cboHospital").combobox('getValue')
		},
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'UserCode',title:'�û�����',width:100},
			{field:'UserDesc',title:'�û�����',width:120},
			{field:'LocDesc',title:'��������',width:180},
			{field:'TypeDesc',title:'ҽ������',width:100},
		    {field:'PhoneNo',title:'�ֻ���',width:135},
	        {field:'ActiveDesc',title:'�Ƿ���Ч',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.SysUserID) {
                    obj.SysUserID="";
                    obj.UserDesc="";
					obj.PhoneNum="";
                    $("#btnEditT").linkbutton("disable");
                    $("#btnAdd").linkbutton("disable");
                    obj.gridSysUser.clearSelections();
                } else {
                    obj.SysUserID=rowData["ID"];
                    obj.UserDesc=rowData["UserDesc"];
					obj.PhoneNum=rowData["PhoneNo"];
                    $("#btnEditT").linkbutton("enable");
                    $("#btnAdd").linkbutton("enable");
                }
                obj.gridLocLoad();
			}
		},
		onLoadSuccess:function(data){
            if (obj.SysUserID=="") {
                $("#btnEditT").linkbutton("disable");
                $("#btnEdit").linkbutton("disable");
            }else{
                $("#btnEditT").linkbutton("enable");
                $("#btnEdit").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
	
    //�����û���������
	$("#cboUser").lookup({
		panelWidth:238,
		url:$URL,
		editable: true,
		mode:'remote',      //������Ϊ 'remote' ģʽʱ���û������ֵ���ᱻ��Ϊ��Ϊ 'q' �� http ����������͵����������Ի�ȡ�µ����ݡ�
		valueField: 'ID',
		textField: 'UserDesc',
		queryParams:{
			ClassName: 'DHCHAI.BTS.SysUserSrv',
			QueryName: 'QrySysUserList',
			aIsActive: 1
		},
		columns:[[  
			{field:'UserCode',title:$g('����'),width:90},
			{field:'UserDesc',title:$g('����'),width:100}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q']; 
			param = $.extend(param,{aUserName:desc}); //������qת��Ϊ���еĲ���
		},
		onSelect:function(index,rowData){
			 obj.UserID=rowData['ID'];
		},
		pagination:true,
	    showPageList:false, showRefresh:false,displayMsg:'',
		loadMsg:'���ڲ�ѯ',
		isCombo:true,             //�Ƿ������ַ��������¼�����������
		minQueryLen:1             //isComboΪtrueʱ����������Ҫ����ַ���С����
	});

    InitCCLocGroupLocWinEvent(obj);
    return obj;
}
function loadgridUser(){
	var TabDataGrid = $HUI.datagrid("#gridUser",{
		fit: true,
		title: '������ά��',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUser',
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aLocID:"",
            aAlias:$('#searchbox').searchbox('getValue'), 
			aIsActive:""
		},
		columns:[[
			{field:'UserCode',title:'�û�����',width:100},
            {field:'UserDesc',title:'�û�����',width:120},
            {field:'PhoneNo',title:'�ֻ���',width:135},
            {field:'BTEffectDate',title:'��Ч����',width:100},
            {field:'BTExpiryDate',title:'��ֹ����',width:100},
			{field:'IsActive',title:'�Ƿ���Ч',width:80},
            {field:'UpdateDate',title:'��������',width:120},
			{field:'UpdateUser',title:'������Ա',width:100}
			
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocGrpID) {
                    obj.LocGrpID="";
                    $("#btnAdd").linkbutton("enable");
                    $("#btnEdit").linkbutton("disable");
                    $("#btnDelete").linkbutton("disable");
                    $('#gridUser').datagrid('clearSelections');
                } else {
                    obj.LocGrpID=rowData["ID"];
                    $("#btnAdd").linkbutton("disable");
                    $("#btnEdit").linkbutton("enable");
                    $("#btnDelete").linkbutton("enable");
                }
				
			}
		},
		onLoadSuccess:function(data){
            if ((obj.LocID=="")&&(obj.SysUserID=="")) {
                $("#btnAdd").linkbutton("disable");
            }else{
                $("#btnAdd").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
}

function loadgridLoc(){
	var TabDataGrid = $HUI.datagrid("#gridUser",{
		fit: true,
		title: '���ο���ά��',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUserLocGroup',
			aHospIDs:$("#cboHospitalT").combobox('getValue'),
			aGrpType:$("#cboLocGrpTypeT").combobox('getValue'),
			aUserID: obj.SysUserID
		},
		columns:[[
			{field:'ID',title:'ID',width:80},
            {field:'LocCode',title:'���Ҵ���',width:120},
            {field:'LocDesc',title:'��������',width:135},
            {field:'LocTypeDesc',title:'��������',width:100},
            {field:'LocCateDesc',title:'��������',width:100},
            {field:'EffectDate',title:'��Ч����',width:120},
			{field:'ExpiryDate',title:'��ֹ����',width:120},
			{field:'IsActDesc',title:'�Ƿ���Ч',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocGrpID) {
                    obj.LocGrpID="";
                    $("#btnAdd").linkbutton("enable");
                    $("#btnEdit").linkbutton("disable");
                    $("#btnDelete").linkbutton("disable");
                    $('#gridUser').datagrid('clearSelections');
                } else {
                    obj.LocGrpID=rowData["ID"];
                    $("#btnAdd").linkbutton("disable");
                    $("#btnEdit").linkbutton("enable");
                    $("#btnDelete").linkbutton("enable");
                }
			}
		},
		onLoadSuccess:function(data){
            if ((obj.LocID=="")&&(obj.SysUserID=="")) {
                $("#btnAdd").linkbutton("disable");
            }else{
                $("#btnAdd").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
}


$(function(){
    InitCCLocGroupLocWin();
    loadgridUser();

})

