$(document).ready(function() {

	InitForm();
	var type=""
});
function InitForm() {
	//�м����ҽ����Ա�б�
var ctlocCtcpData=$HUI.datagrid("#ctlocCtcpData",{
        fit:true,
        //singleSelect: true,
        selectOnCheck:true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        url:$URL,
        queryParams:{
            ClassName:"web.DHCOPDocLocAuthorize",
            QueryName:"FindCtcp"
        },
        onBeforeLoad:function(param)
        {
            param.OpDeptId=$('#ctloc').combobox('getValue');
            param.name=$('#name').val();
            param.WorkNo=$('#workno').val();
            param.OperId="";
        },	
	onClickRow: function(rowIndex, rowData) {
			selectctcpid = rowData["ctcpId"];
			$('#ctlocCtcpData').datagrid('clearSelections');
			$('#ctlocCtcpData').datagrid('selectRow',rowIndex);
			
		},
		onCheck: function(rowIndex, rowData) {
			selectctcpid = rowData["ctcpId"]
			var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
			var ctcpdatalen = ctcpdata.length;
			if(ctcpdatalen>1) {
					$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId="";
        			}
				}) 
				return;
			}
			else
			{
  				$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
			}
		}
	    ,toolbar:[{     
	                iconCls: 'icon-addauth',
	                text:'�����Ȩ', 
	                width: 120,        
	                handler: function(){
	                     AddCtcpOperData();
	                	}
	    			}
	    			,{     
	                iconCls: 'icon-delauth',
	                text:'ȡ����Ȩ',          
	                handler: function(){
	                     DeleteCtcpOperData();
	                	}
	    			}
	    			,{     
	                iconCls: 'icon-adddayauth',
	                text:'�ռ���Ȩ',          
	                handler: function(){
	                     AddDaySurgeryAuth();
	                	}
	    			},{     
	                iconCls: 'icon-deldayauth',
	                text:'ȡ���ռ���Ȩ',          
	                handler: function(){
	                     DeleteDaySurgeryAuth();
	                	}
	    			}
	    			],
		columns: [
			[
			{ field: "check",checkbox:true },
			{field: 'ctcpDesc',title: 'ҽ��',width: 80}, 
			{field: 'ctcpId',title: 'ҽ����ԱId',width: 90}, 
			{field: 'ctcpWorkNo',title: '����',width: 70},
			{field: 'dayAuth',title: '�ռ�',width: 70}]
		],
		pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]
	});
	
	//���ҿ���ҽ����Ա
	$('#btnfindctcp').bind('click', function() {
		 $HUI.datagrid("#ctlocCtcpData").load();
	});

	//----��������б�
	 var operList=$HUI.datagrid("#operData",{
		 url:$URL,
		 height:460,
		 headerCls:'panel-header-gray',
		 displayMsg:'',
		queryParams: {
			ClassName: "web.DHCOPDocLocAuthorize",
			QueryName: "FindOperation"
		},
		onBeforeLoad:function(param)
        {
            param.operDescAlias=$('#opdesc').val();
            param.operCat=$('#oplevel').combobox('getValue');
            param.isDayOper=$("#IsDayOper").checkbox('getValue')?"Y":"N";
        },
		onClickRow: function(rowIndex, rowData) {
			//���׼����ѡ������ɸѡ���ҽ����Ա
			/*
			operId = rowData["rowid"]
			var operdata = $('#operData').datagrid('getSelections');
			var ctcpdatalen = operdata.length;
			if(ctcpdatalen>1) {
					var queryParams = $("#operAuthData").datagrid('options').queryParams;
	  				queryParams.ClassName="web.DHCOPDocLocAuthorize";
					queryParams.QueryName="FindOperCtcp";
        			queryParams.Arg1 = '';
  					$('#ctlocCtcpData').datagrid('reload',queryParams); 
				return;
			}
				$('#ctlocCtcpData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOperCtcp",
						Arg1: operId,
						ArgCnt: 1
					}
				})
				*/
		},
		columns: [
			[
			{ field: "check",checkbox:true },
			{
				field: 'OPTypeDes',
				title: '��������',
				width: 200
			}, {
				field: 'rowid',
				title: '����ID'
			}
				]
		]		
		,pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]

	});
	//-----��������
	$('#btnfindoper').bind('click', function() {
		FindOperData();
	});

	function FindOperData() {
		$HUI.datagrid("#operData").load(	);
	}
	//�ռ�������Ȩ
	function AddDaySurgeryAuth()
	{
		//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("��ʾ", "��ѡ��ҽ����Ա", 'warning');
			return;
		}
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"AddDayOperAuth",
        ctcpIdStr:ctcpdatastr 
    		},false);
		if(data==0)
		{
			$.messager.alert("��ʾ", "��Ȩ�ɹ�", 'info');
			$('#ctlocCtcpData').datagrid('clearSelections');
			HUI.datagrid("#ctlocCtcpData").reload();
		}

	}
		//�ռ�������Ȩ
	function DeleteDaySurgeryAuth()
	{
				//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("��ʾ", "��ѡ��ҽ����Ա", 'warning');
			return;
		}
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteDayOperAuth",
        ctcpIdStr:ctcpdatastr 
    		},false);
		if(data==0)
		{
			$.messager.alert("��ʾ", "������Ȩ�ɹ�", 'info');
		}
	}
////����Ȩ����
 var operAuList=$HUI.datagrid("#operAuthData",{
		 url:$URL,
        headerCls:'panel-header-gray',
        displayMsg:'',
		queryParams: {
			ClassName: "web.DHCOPDocLocAuthorize",
			QueryName: "FindOrcDocOper"
		},
		onBeforeLoad:function(param)
        {
            param.OpDocId="";
        },
		columns: [
			[
			{ field: "check",checkbox:true },
			{
				field: 'tOperDesc',
				title: '��������',
				width: 120,
				sortable: true
				
			}, {
				field: 'tOperId',
				title: '����ID'
				,width: 1
				, hidden: true
			}
			,{
				field: 'tOperLevel',
				title: '����'
				,width: 60
				}
			,{
				field: 'tDayOper',
				title: '�ռ�'
				,width: 60
				}
			,
			{
				field: 'tRowId',
				title: 'tRowId'
				,width: 1
				, hidden: true
				}
			]]
		,toolbar:[
				{
		    		iconCls: 'icon-delauth',
	                text:'ȡ����Ȩ',          
	                handler: function(){
	                     deleteAuthOperData();
	                	}
	    			}
		]
		,pagination: true,
		pageSize: 50,
		pageNumber: 1,
		pageList: [10, 20, 30, 40,50]
	});


//---------------ɾ�����ҽ����Ա��Ӧ����
function deleteAuthOperData()
{
	var operIdStr=""
		var rows = $('#operAuthData').datagrid('getSelections');
		var len = rows.length;
		if(len > 0) 
		{
			for(var i = 0; i < len; i++) {
				var operId = rows[i].tRowId;
				if(operIdStr!="")
				{
					operIdStr=operIdStr+"^"+operId
				}
				else
				{
					operIdStr=operId
				}
			}
		}
		if(operIdStr=="")
		{
			$.messager.alert("��ʾ", "��ѡ��һ����¼", 'warning');
			return;
		}
			var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteAuthOper",
        rowIdStr:operIdStr 
    		},false);
		if(data==0)
		{
			$.messager.alert("��ʾ", "ɾ���ɹ�", 'info');
			$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
		}
			

		
}
	//---------------------���ҽ����Ա�������
	function AddCtcpOperData() {
		var userId=session['LOGON.USERID'];
		//����
		var operdatas = $('#operData').datagrid('getSelections');
		var operdataslen = operdatas.length;
		var operdatastr = "";
		if(operdataslen > 0) {
			for(var i = 0; i < operdataslen; i++) {
				var operid = operdatas[i].rowid;
				if(operdatastr == "") {
					operdatastr = operid;
				} else {
					operdatastr = operdatastr + "^" + operid;
				}
			}
		}
		if(operdatastr=="")
		{
			$.messager.alert("��ʾ", "��ѡ������", 'warning');
			return;
		}
		//
		var ctcpdata = $('#ctlocCtcpData').datagrid('getSelections');
		var ctcpdatalen = ctcpdata.length;
		var ctcpdatastr = "";
		if(ctcpdatalen > 0) {
			for(var i = 0; i < ctcpdatalen; i++) {
				var ctcpid = ctcpdata[i].ctcpId;
				if(ctcpdatastr == "") {
					ctcpdatastr = ctcpid;
				} else {
					ctcpdatastr = ctcpdatastr + "^" + ctcpid;
				}
			}
		}
		if(ctcpdatastr=="")
		{
			$.messager.alert("��ʾ", "��ѡ��ҽ����Ա", 'warning');
			return;
		}
		
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"AddAuthOperSingle",
        ctcpIdStr:ctcpdatastr, 
        operIdStr:operdatastr,
         UserId:userId
    		},false);
		if(data==0)
		{
			$.messager.alert("��ʾ", "����ɹ�", 'info');
			$('#ctlocCtcpData').datagrid('clearSelections');
			$('#operData').datagrid('clearSelections');
		}
	
	}
//�ջ�������Ȩ
function DeleteCtcpOperData()
{
	var ctcpIdStr=""
	var rows = $('#ctlocCtcpData').datagrid('getSelections');
	var len = rows.length;
	if(len > 0) 
	{
		for(var i = 0; i < len; i++) {
			var opctcpId = rows[i].ctcpId;
			if(ctcpIdStr!="")
			{
				ctcpIdStr=ctcpIdStr+"^"+opctcpId
			}
			else
			{
				ctcpIdStr=opctcpId
			}
		}
	}
	if(ctcpIdStr=="")
		{
			$.messager.alert("��ʾ", "��ѡ��ҽ����Ա", 'warning');
			return;
		}
		
		var data=$.m({
        ClassName:"web.DHCOPDocLocAuthorize",
        MethodName:"DeleteDocOper",
        ctcpIdStr:ctcpIdStr
    		},false);
		if(data==0)
		{
			$.messager.alert("��ʾ", "ɾ���ɹ�", 'info');
			$('#operAuthData').datagrid({
					queryParams: {
						ClassName: "web.DHCOPDocLocAuthorize",
						QueryName: "FindOrcDocOper",
					},
					onBeforeLoad:function(param)
        			{
            			param.OpDocId=selectctcpid;
        			}
				})
			
		}
		
}

//====================
	////////////////////////////////////////////////////////////////////////////////////
	
		var objCtloc=$HUI.combobox("#ctloc",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
		multiple:false,
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
			param.EpisodeID="";
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
		,columns: [
				[{
					field: 'ctlocId',
					title: '����ID',
					hidden: true
				}, {
					field: 'ctlocDesc',
					title: '��������'
				}, {
					field: 'ctlocCode',
					title: '���Ҵ���',
					hidden: true
				}]
			]
		});
		//
		var objoplev=$HUI.combobox("#oplevel",{
		url:$URL+"?ClassName=web.DHCANCOrc&QueryName=FindORCOperationCategory&ResultSetType=array",
		valueField:'operCategId',
		textField:'operCategLDesc',
		multiple:false,
		panelHeight:'auto',
		onBeforeLoad:function(param){
	
		},
		onLoadSuccess:function(data) {
			    }
		,mode: "remote"	
		,columns: [
				[{
					field: 'operCategLDesc',
					title: '����',
					width: 100
				}, {
					field: 'operCategId',
					title: '����ID'
				}]
			]
		});
	}

