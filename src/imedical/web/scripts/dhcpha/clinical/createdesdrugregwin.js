/// ���ҵ�������
createDesDrugRegWin = function(FN){
	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="newDdrWin"></div>');
	$('#newDdrWin').append('<div id="ddrNoList"></div>');
		
	/**
	 * ��ѯ����
	 */
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var newDdrWindowUX = new WindowUX('�����龫ҩƷ���ټ�¼', 'newDdrWin', '1200', '550', option);
	newDdrWindowUX.Init();
    
    //��ʼ����ѯ��Ϣ�б�
	InitDdrWinList();
		
	//��ʼ�����水ť�¼�
	InitDdrWinListener();
	
	//��ʼ������Ĭ����Ϣ
	InitDdrWinDefault();
	
	/// ���ҵ�����
	function QueryDdrNoList(){
		
		var ddrStartDate = $('#ddrStartDate').datebox('getValue');   //��ʼ����
		var ddrEndDate = $('#ddrEndDate').datebox('getValue'); 	     //��ֹ����
		var ddrWinDept = $('#ddrWinDept').combobox('getValue');      //���ٿ���
		var ddrWinUser = $('#ddrWinUser').combobox('getValue');  	 //������Ա

		var ListData = ddrStartDate + "^" + ddrEndDate + "^" + ddrWinDept + "^" + ddrWinUser;

		$('#ddrNoList').datagrid({
			url:url+'?action=QueryDesRegNoList',
			queryParams:{
				param : ListData}
		});
	}

	/// ѡȡָ����
	function SelDdrNoList(){
		
		var rows = $("#ddrNoList").datagrid('getSelected');
		if (rows != null) {
			FN(rows.ddrID);
			$('#newDdrWin').window('close');
		}else{
			$.messager.alert('��ʾ','��ѡ��Ҫ��ȡ�����ٵ���¼','warning');
			return false; 
		}
	}
	
	function InitDdrWinList(){
		// ����columns
		var columns=[[
			{field:"ddrNo",title:'���ٵ���',width:120},
			{field:"ddrCDate",title:'����',width:100},
			{field:"ddrCTime",title:'ʱ��',width:100},
			{field:'ddrDept',title:'���ٿ���',width:160},
			{field:'ddrUser',title:'������',width:100},
			{field:'ddrDesWayDesc',title:'���ٷ�ʽ',width:100},
			{field:'ddrComFlag',title:'�Ƿ����',width:80,align:'center'},
			{field:'ddrChkFlag',title:'�Ƿ�˶�',width:80,align:'center'},
			{field:'ddrChkDate',title:'�˶�����',width:100},
			{field:'ddrChkTime',title:'�˶�ʱ��',width:100},
			{field:'ddrChkTime',title:'�˶���',width:100},
			{field:'ddrID',title:'ddrID',width:80,hidden:true}
		]];
	
		/**
		 * ����datagrid
		 */
		var option = {
			title:'ҩƷ���ٵ��б�',
			//nowrap:false,
			toolbar: '#cmttb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			    FN(rowData.ddrID);
				$('#newDdrWin').window('close');
	        }
		};
		
		var ddrNoListComponent = new ListComponent('ddrNoList', columns, '', option);
		ddrNoListComponent.Init();

	}
	
	//��ʼ�����水ť�¼�
	function InitDdrWinListener(){
		
		$('a:contains("��ѯ�б�")').bind('click',QueryDdrNoList);
		$('a:contains("ѡȡ�б�")').bind('click',SelDdrNoList);
	}
	
	//��ʼ������Ĭ����Ϣ
	function InitDdrWinDefault(){
		
		/**
		 * ��������
		 */
		$("#ddrStartDate").datebox("setValue", formatDate(0));
		$("#ddrEndDate").datebox("setValue", formatDate(0));
	
		/**
		 * ���ٿƱ�
		 */
		var ddrWinDeptCombobox = new ListCombobox("ddrWinDept",url+'?action=QueryConDept','');
		ddrWinDeptCombobox.init();
	
		//$("#ddrWinDept").combobox("setValue",LgCtLocID);
	
		/**
		 * ������Ա
		 */
		var ddrWinUserCombobox = new ListCombobox("ddrWinUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
		ddrWinUserCombobox.init();
	
		//$("#ddrWinUser").combobox("setValue",LgUserID);
	}

}

