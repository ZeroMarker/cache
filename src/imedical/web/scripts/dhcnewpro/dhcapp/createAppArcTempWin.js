
/// Creator:    bianshuai
/// CreateDate: 2016-04-30
/// Descript:   �������ҽ����ģ��

createAppArcTempWin = function(FN){
	
	//if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	//$('body').append('<div id="win"></div>');
	//$('#win').append('<div id="ArcTempList"></div>');

	$('#arcwin').window({
		title:'�������ҽ����ģ��',
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:460,
		onClose:function(){
			//$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 
	
	//��ʼ����ѯ��Ϣ�б�
	InitDataList();
	
	//��ʼ������Ĭ����Ϣ
	InitDefault();

	$('#arcwin').window('open');

	//��ʼ������Ĭ����Ϣ
	function InitDefault(){
		
		/* ������ */
		
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPComDataUtil&MethodName=GetAppArcCat&HospID=";
		var arcItemCatCombobox = new ListCombobox("arcitemcat",uniturl,'');
		arcItemCatCombobox.init();
	
		$('div#arctb a:contains("����")').bind('click',queryArcTempList);
		$('div#arctb a:contains("ѡ��")').bind('click',selectArcTempList);
		$('div#arctb a:contains("ɾ��ģ��")').bind('click',deleteArcTemp);
		
		$('input[type="radio"][name="itemCat"]').live('click',function(){
			queryArcTempList();
		})
	}
		
	/// ��ʼ�������б�
	function InitDataList(){
	
		/**
		 * ����columns
		 */
		var columns=[[
			{field:'arcTempCat',title:'������',width:130},
			{field:'arcTempDesc',title:'ģ������',width:700},
			{field:'arcTempID',title:'arcTempID',width:80}
		]];
	
		/**
		 * ����datagrid
		 */
		var option = {
			///title:'��ʷ�����¼',
			toolbar: '#arctb',
			singleSelect : true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    		FN(rowData.arcTempID);
				$('#arcwin').window('close');
	        }
		};
		
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPComDataUtil&MethodName=jsonAppArcTemp";
		var arcListComponent = new ListComponent('arcTempList', columns, uniturl, option);
		arcListComponent.Init();
	}

	/// ���ҵ�����
	function queryArcTempList(){
		
		var arcitemcat = $('input[name="itemCat"]:checked ').attr("id");
		var ListData = arcitemcat +"^"+ LgCtLocID +"^"+ LgUserID;
		$('#arcTempList').datagrid('reload',{"params":ListData});
	}

	/// ѡȡָ����
	function selectArcTempList(){
	
		var rowData = $("#arcTempList").datagrid('getSelected');
		if (rowData != null) {
			FN(rowData.arcTempID);
			$('#arcwin').window('close');
		}else{
			$.messager.alert('��ʾ','��ѡ��Ҫ��ȡ��ģ���¼','warning');
			return false; 
		}
	}
	
	
	/// ɾ��ѡ����
	function deleteArcTemp(){
	
		var rowsData = $("#arcTempList").datagrid('getSelected'); //ѡ��Ҫɾ������
		if (rowsData != null) {
			$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					runClassMethod("web.DHCAppArcTemp","delArcTemp",{'arcTempID':rowsData.arcTempID},function(jsonString){
						queryArcTempList(); //���¼���
					},'',false)
				}
			});
		}else{
			 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
			 return;
		}
	}

}
