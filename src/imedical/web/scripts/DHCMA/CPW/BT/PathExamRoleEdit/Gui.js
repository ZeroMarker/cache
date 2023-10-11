//ҳ��Gui
function InitExamRoleWin(){
	var obj = new Object();
	obj.RecRowID = "";	
    $.parser.parse(); // ��������ҳ�� 
	
	//����Ժ������ add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathExamRole",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathExamRole",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathExamRole.load({
				ClassName:"DHCMA.CPW.BTS.PathExamRoleSrv",
				QueryName:"QryPathExamRole",
				aHospID: $("#cboSSHosp").combobox('getValue')
			});
	  	}
	 })
	var retMultiHospCfg = $m({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSIsOpenMultiHospMode",
		aHospID:session['DHCMA.HOSPID']
	},false);
	if(retMultiHospCfg!="Y" && retMultiHospCfg!="1"){
		//$("#divHosp").hide();
		//$("#btnAuthHosp").hide();
		$("#layout").layout('panel',"north").hide();
		$("#layout").layout('panel',"center").panel({fit:true});		
		$("#layout").layout('resize');
		$("#layout").layout('panel',"center").parent().css({'top':'0'});	
	}
	
	obj.gridPathExamRole = $HUI.datagrid("#gridPathExamRole",{
		fit: true,
		title: "������˽�ɫά��",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathExamRoleSrv",
			QueryName:"QryPathExamRole",
			aHospID:DefHospOID
	    },
		columns:[[
			{field:'xID',title:'ID',width:'50',hidden:true},
			{field:'Code',title:'����',width:'100',sortable:true},
			{field:'Desc',title:'����',width:'350'},
			{field:'TypeCode',title:'���ʹ���',width:'100',hidden:true},	
			{field:'TypeDesc',title:'��������',width:'100'},
			{field:'Value',title:'��ɫֵ',width:'100',hidden:true}, 
			{field:'ValueDesc',title:'��ɫ����',width:'150'},
			{field:'Priority',title:'���ȼ�',width:'150'},
			{field:'IsActive',title:'�Ƿ���Ч',width:'100'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathExamRole_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathExamRole_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//��ɫ����
	obj.cboRoleType = $HUI.combobox("#cboRoleType",{
		//url:$URL,
		valueField: 'id',
		textField: 'text',
		data: [{
			id: 'U',
			text: '�û�'
		},{
			id: 'L',
			text: '����'
		}],
		editable: false,
		defaultFilter:4,
		onSelect:function(rec){
			switch(rec.id) {
		     case 'U':
		     	//��ɫ����-�����û�
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'Desc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {    	//�������������֮ǰ���������� false ��ȡ�����ض���
						param.ClassName = 'DHCMA.Util.EPS.SSUserSrv';
						param.QueryName = 'QryUserInfo';
						param.aHospID	= $("#cboSSHosp").combobox('getValue')
						param.ResultSetType = 'array';
					}
					/*,
					formatter:function(row){
						if (row.LocDesc!=undefined) return row.Desc+"��"+row.LocDesc+"��";
						else return row.Desc;
					}*/
				})
				
		        break;
		     case 'L':
		        //��ɫ����-���ؿ���
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'Desc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.ClassName = 'DHCMA.Util.EPS.LocationSrv';
						param.QueryName = 'QryLocInfo';
						param.aHospID = $("#cboSSHosp").combobox('getValue')
						param.aAdmType = '';
						param.ResultSetType = 'array';
					}
				})
		        break;
		     case 'G':
		        //��ɫ����-���ذ�ȫ��
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'GrpDesc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.ClassName = 'DHCMA.Util.EPS.SSGroupSrv';
						param.QueryName = 'QrySSGrpInfo';
						param.aAlias = '';
						param.aHospID	= $("#cboSSHosp").combobox('getValue')
						param.ResultSetType = 'array';
					}
				})
				$.parser.parse('#cboRoleValue'); 
				break;
			} 
		}
	});
	
	
	InitExamRoleEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


