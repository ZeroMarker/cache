/// ���ҵ�������
createFindTindyDrugRegWin = function(FN){
	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="newTdrWin"></div>');
	$('#newTdrWin').append('<div id="tdrNoList"></div>');
		
	/**
	 * ��ѯ����
	 */
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var newTdrWindowUX = new WindowUX('����ҩƷ�����¼', 'newTdrWin', '1200', '550', option);
	newTdrWindowUX.Init();
    
    //��ʼ����ѯ��Ϣ�б�
	InitTdrWinList();
		
	//��ʼ�����水ť�¼�
	InitTdrWinListener();
	
	//��ʼ������Ĭ����Ϣ
	InitTdrWinDefault();
	
	/// ���ҵ�����
	function QueryTdrNoList(){
		
		var tdrStartDate = $('#tdrStartDate').datebox('getValue');   //��ʼ����
		var tdrEndDate = $('#tdrEndDate').datebox('getValue'); 	     //��ֹ����
		var tdrWinDept = $('#tdrWinDept').combobox('getValue');      //�������
		var tdrWinUser = $('#tdrWinUser').combobox('getValue');  	 //������Ա

		var ListData = tdrStartDate + "^" + tdrEndDate + "^" + tdrWinDept + "^" + tdrWinUser;

		$('#tdrNoList').datagrid({
			url:url+'?action=QueryTdrNo',
			queryParams:{
				param : ListData}
		});
	}

	/// ѡȡָ����
	function SelTdrNoList(){
		
		var rows = $("#tdrNoList").datagrid('getSelected');
		if (rows != null) {
			FN(rows.tdrID);
			$('#newTdrWin').window('close');
		}else{
			$.messager.alert('��ʾ','��ѡ��Ҫ��ȡ�Ĳ��㵥��¼','warning');
			return false; 
		}
	}
	
	function InitTdrWinList(){
		// ����columns
		var columns=[[
			{field:"tdrNo",title:'���㵥��',width:120},
			{field:"tdrCDate",title:'����',width:100},
			{field:"tdrCTime",title:'ʱ��',width:100},
			{field:'tdrDept',title:'�������',width:160},
			{field:'tdrUser',title:'������',width:100},
			{field:'tdrPurDesc',title:'����Ŀ��',width:100},
			{field:'tdrComFlag',title:'�Ƿ����',width:80,align:'center'},
			{field:'tdrChkFlag',title:'�Ƿ�˶�',width:80,align:'center'},
			{field:'tdrChkDate',title:'�˶�����',width:100},
			{field:'tdrChkTime',title:'�˶�ʱ��',width:100},
			{field:'tdrChkTime',title:'�˶���',width:100},
			{field:'tdrID',title:'tdrID',width:80,hidden:true}
		]];
	
		/**
		 * ����datagrid
		 */
		var option = {
			title:'ҩƷ���㵥�б�',
			//nowrap:false,
			toolbar: '#cmttb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			    FN(rowData.tdrID);
				$('#newTdrWin').window('close');
	        }
		};
		
		var tdrNoListComponent = new ListComponent('tdrNoList', columns, '', option);
		tdrNoListComponent.Init();

	}
	
	//��ʼ�����水ť�¼�
	function InitTdrWinListener(){
		
		$('a:contains("��ѯ�б�")').bind('click',QueryTdrNoList);
		$('a:contains("ѡȡ�б�")').bind('click',SelTdrNoList);
	}
	
	//��ʼ������Ĭ����Ϣ
	function InitTdrWinDefault(){
		
		/**
		 * ��������
		 */
		$("#tdrStartDate").datebox("setValue", formatDate(0));
		$("#tdrEndDate").datebox("setValue", formatDate(0));
	
		/**
		 * ����Ʊ�
		 */
		var tdrWinDeptCombobox = new ListCombobox("tdrWinDept",url+'?action=QueryConDept','');
		tdrWinDeptCombobox.init();
	
		//$("#tdrWinDept").combobox("setValue",LgCtLocID);
	
		/**
		 * ������Ա
		 */
		var tdrWinUserCombobox = new ListCombobox("tdrWinUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
		tdrWinUserCombobox.init();
	
		//$("#tdrWinUser").combobox("setValue",LgUserID);
	}

}

