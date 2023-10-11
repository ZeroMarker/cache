var objEti = new Object();
function InitEtiologyEvi(obj){
	var obj = objEti;
	obj.EviRowID = ''; //��ԭѧ֤��ѡ����
	
	obj.gridEtiologyEvi = $HUI.datagrid("#gridEtiologyEvi",{ 
		title:'��ԭѧ֤��',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		columns:[[
			{field:'CollDate',title:'�ͼ�����',width:150},
			{field:'AuthDate',title:'��������',width:150},
			{field:'SpecimenDesc',title:'�걾����',width:120},
			{field:'ResultDesc',title:'���',width:150},
			{field:'BacteriaDesc',title:'ϸ������',width:320},
			{field:'IsResistQDesc',title:'�Ƿ���<br>̼��ùϩ',width:100},
			{field:'IsResistTDesc',title:'�Ƿ���<br>��ӻ���',width:100},
			{field:'IsRelevantDesc',title:'�ͼ�걾�Ƿ�<br>���Ⱦ������',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridEtiologyEvi_onSelect();
			}
		},
		onDblClickRow:function(rindex, rowdata) {
			if (rindex>-1) {
				obj.winEtiologyEviEdit_Open(rowdata,rindex);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEtiologyEviDel").linkbutton("disable");
		}
	});
	
	obj.gridEtiologyEvi_onSelect = function() {
		var rowData = obj.gridEtiologyEvi.getSelected();
		if (rowData["ID"] == obj.EviRowID) {
			obj.EviRowID="";
			$("#btnEtiologyEviDel").linkbutton("enable");
		} else {
			obj.EviRowID = rowData["ID"];
			$("#btnEtiologyEviDel").linkbutton("enable");
		}
	}
	
	// ��Ӳ�ԭѧ֤���¼�
	$("#btnEtiologyEviAdd").click(function(e){
		obj.winEtiologyEviEdit_Open('','');	
		obj.chkIsEtiologyEvi();
	});
	
	// ɾ����ԭѧ֤���¼�
	$("#btnEtiologyEviDel").click(function(e){
		var selectObj = obj.gridEtiologyEvi.getSelected();
		var index = obj.gridEtiologyEvi.getRowIndex(selectObj);  //��ȡ��ǰѡ���е��к�(��0��ʼ)
		if (!selectObj) {
			$.messager.alert("��ʾ", "��ѡ��һ��Ҫɾ��������?", 'info');
			return;
		}else {
			$.messager.confirm("��ʾ", "�Ƿ�Ҫɾ����ԭѧ֤��?", function (r) {
				if (r){				
					obj.gridEtiologyEvi.deleteRow(index);
					obj.chkIsEtiologyEvi();
				}
			});
		}
	});
	
	// ������ԭѧ֤�ݵ���
	obj.winEtiologyEviEdit_Open = function(rowData,rowIndex){
		$('#winEtiologyEviEdit').dialog({
			buttons:[{
				text:'����',
				handler:function(){
					obj.winEtiologyEviEdit_Save(rowData,rowIndex);
				}
			},{
				text:'ȡ��',
				handler:function(){$HUI.dialog('#winEtiologyEviEdit').close();}
			}]
		});
		$HUI.dialog('#winEtiologyEviEdit').open();
		
		obj.winEtiologyEviEdit_Init(rowData);
	}
	
	// ��ԭѧ֤�ݵ���
	$('#winEtiologyEviEdit').dialog({
		title:'��ԭѧ֤��--�༭',
		iconCls:'icon-w-paper',
		width: 880,    
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	
	// ��ԭѧ������ȡ�¼�
	$('#btnANTEtiSync').click(function(e){
		OpenINFLabSync();
	});
	//��ԭѧ������ȡ�����¼�
	obj.LayerOpenINFLabSync = $('#LayerOpenINFLabSync').dialog({
		title:"��ԭѧ����-��ȡ", 
		iconCls:'icon-w-paper',
		width: 1000,    
		height: 500, 
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	// ������ԭѧ������ȡ��
	function OpenINFLabSync(){
		refreshgridINFLabSync();
		$HUI.dialog('#LayerOpenINFLabSync').open();
	}
    //��ԭѧ�����б�
	function refreshgridINFLabSync(){	
		obj.gridINFLabSync = $HUI.datagrid("#gridINFLabSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //���Ϊtrue, ����ʾһ���к���
			singleSelect: true,
			autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
			loadMsg:'���ݼ�����...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
				QueryName:'QryPatEvi',
				aEpisodeID:EpisodeID
			},
			columns:[[
				{field:'CollDate',title:'�ͼ�����',width:120},
				{field:'LabRegDate',title:'��������',width:120},
				{field:'SpecimenDesc',title:'�ͼ�걾',width:120},
				{field:'ResultDesc',title:'���',width:100},
				{field:'BacteriaDesc',title:'ϸ��',width:150},
				{field:'YesNoTDesc',title:'�Ƿ�����ӻ���',width:120},
				{field:'AntDescTDesc',title:'������',width:100},
				//{field:'TMethodDesc',title:'ҩ������',width:100},
				//{field:'TNumber',title:'��ֵ',width:80,},
				{field:'YesNoQDesc',title:'�Ƿ���̼��ùϩ',width:120},
				{field:'AntDescQDesc',title:'������',width:100},
				//{field:'QMethodDesc',title:'ҩ������',width:100},
				//{field:'QNumber',title:'��ֵ',width:80}
			]],	
			onDblClickRow:function(rowIndex, rowData) {
				if (rowIndex>-1) {
					obj.openHandle(rowIndex,rowData);
				}
			$HUI.dialog('#LayerOpenINFLabSync').close();
			}		
		});		
	}
	obj.openHandle = function(rowIndex,rowData){
		$('#winEtiologyEviEdit').dialog({
			buttons:[{
				text:'����',
				handler:function(){
					obj.winEtiologyEviEdit_Save();
				}
			},{
				text:'ȡ��',
				handler:function(){$HUI.dialog('#winEtiologyEviEdit').close();}
			}]
		});
		$HUI.dialog('#winEtiologyEviEdit').open();
		obj.cboLSpecimen	= Common_ComboDicID("cboLSpecimen","ANTSpecimen");
		obj.cboLResult		= Common_ComboDicID("cboLResult","ANTResult");
		obj.cboLBacteria	= Common_ComboDicID("cboLBacteria","ANTBacteria");
		obj.cboLIsResistQ	= Common_ComboDicCode("cboLIsResistQ","ANTYesNo");
		obj.cboLQAnti		= Common_ComboDicID("cboLQAnti","ANTAntibiotic");
		obj.cboLQMethod		= Common_ComboDicID("cboLQMethod","ANTSenMethod");
		obj.cboLIsResistT	= Common_ComboDicCode("cboLIsResistT","ANTYesNo");
		obj.cboLTAnti		= Common_ComboDicID("cboLTAnti","ANTAntibiotic");
		obj.cboLTMethod		= Common_ComboDicID("cboLTMethod","ANTSenMethod");
		$('#txtLCollDate').datebox('setValue',rowData.CollDate);
		$('#txtLAuthDate').datebox('setValue',rowData.LabRegDate);
		$('#cboLSpecimen').combobox('setValue',rowData.SpecimenID);
		$('#cboLSpecimen').combobox('setText',rowData.SpecimenDesc);
		$('#cboLResult').combobox('setValue',rowData.ResultID);
		$('#cboLResult').combobox('setText',rowData.ResultDesc);
		$('#cboLBacteria').combobox('setValue',rowData.BacteriaID);
		$('#cboLBacteria').combobox('setText',rowData.BacteriaDesc);
		$('#cboLIsResistQ').combobox('setValue',rowData.YesNoQID);
		$('#cboLIsResistQ').combobox('setText',rowData.YesNoQDesc);
		$('#cboLQAnti').combobox('setValue',rowData.AntDescQID);
		$('#cboLQAnti').combobox('setText',rowData.AntDescQDesc);
		$('#cboLQMethod').combobox('setValue',rowData.QMethodID);
		$('#cboLQMethod').combobox('setText',rowData.QMethodDesc);
		$('#cboLIsResistT').combobox('setValue',rowData.YesNoTID);
		$('#cboLIsResistT').combobox('setText',rowData.YesNoTDesc);
		$('#cboLTAnti').combobox('setValue',rowData.AntDescTID);
		$('#cboLTAnti').combobox('setText',rowData.AntDescTDesc);
		$('#cboLTMethod').combobox('setValue',rowData.TMethodID);
		$('#cboLTMethod').combobox('setText',rowData.TMethodDesc);
		$('#txtLQNumber').val(rowData.QNumber);
		$('#txtLTNumber').val(rowData.TNumber);
	}
	// ��ԭѧ֤�ݱ༭���ʼ��
	obj.winEtiologyEviEdit_Init = function(rowData){
		obj.cboLSpecimen	= Common_ComboDicID("cboLSpecimen","ANTSpecimen");
		obj.cboLResult		= Common_ComboDicID("cboLResult","ANTResult");
		obj.cboLBacteria	= Common_ComboDicID("cboLBacteria","ANTBacteria");
		obj.cboLIsResistQ	= Common_ComboDicCode("cboLIsResistQ","ANTYesNo");
		obj.cboLQAnti		= Common_ComboDicID("cboLQAnti","ANTAntibiotic");
		obj.cboLQMethod		= Common_ComboDicID("cboLQMethod","ANTSenMethod");
		obj.cboLIsResistT	= Common_ComboDicCode("cboLIsResistT","ANTYesNo");
		obj.cboLTAnti		= Common_ComboDicID("cboLTAnti","ANTAntibiotic");
		obj.cboLTMethod		= Common_ComboDicID("cboLTMethod","ANTSenMethod");
		//$("#cboLQAnti").combobox('disable');
		//$("#cboLQMethod").combobox('disable');
		//$("#cboLTAnti").combobox('disable');
		//$("#cboLTMethod").combobox('disable'); 
		// �ؼ���ֵ
		if (rowData){
			$('#txtLCollDate').datebox('setValue',rowData.CollDate);
			$('#txtLAuthDate').datebox('setValue',rowData.AuthDate);
			$('#cboLSpecimen').combobox('setValue',rowData.SpecimenDr);
			$('#cboLSpecimen').combobox('setText',rowData.SpecimenDesc);
			$('#cboLResult').combobox('setValue',rowData.ResultDr);
			$('#cboLResult').combobox('setText',rowData.ResultDesc);
			$('#cboLBacteria').combobox('setValue',rowData.BacteriaDr);
			$('#cboLBacteria').combobox('setText',rowData.BacteriaDesc);
			$('#cboLIsResistQ').combobox('setValue',rowData.IsResistQ);
			$('#cboLIsResistQ').combobox('setText',rowData.IsResistQDesc);
			$('#cboLQAnti').combobox('setValue',rowData.QAntiDr);
			$('#cboLQAnti').combobox('setText',rowData.QAntiDesc);
			$('#cboLQMethod').combobox('setValue',rowData.QMethodDr);
			$('#cboLQMethod').combobox('setText',rowData.QMethodDesc);
			$('#cboLIsResistT').combobox('setValue',rowData.IsResistT);
			$('#cboLIsResistT').combobox('setText',rowData.IsResistTDesc);
			$('#cboLTAnti').combobox('setValue',rowData.TAntiDr);
			$('#cboLTAnti').combobox('setText',rowData.TAntiDesc);
			$('#cboLTMethod').combobox('setValue',rowData.TMethodDr);
			$('#cboLTMethod').combobox('setText',rowData.TMethodDesc);
			$('#txtLQNumber').val(rowData.QNumber);
			$('#txtLTNumber').val(rowData.TNumber);
			if (rowData.IsRelevant==1) {
				$('#chkIsRelevant').checkbox('setValue',true);
			} else {
				$('#chkIsRelevant').checkbox('setValue',false);
			}
		} else {
			$('#txtLCollDate').datebox('clear');
			$('#txtLAuthDate').datebox('clear');
			$('#cboLSpecimen').combobox('clear');
			$('#cboLResult').combobox('clear');
			$('#cboLBacteria').combobox('clear');
			$('#cboLIsResistQ').combobox('clear');
			$('#cboLQAnti').combobox('clear');
			$('#cboLQMethod').combobox('clear');
			$('#cboLIsResistT').combobox('clear');
			$('#cboLTAnti').combobox('clear');
			$('#cboLTMethod').combobox('clear');
			$('#txtLQNumber').val('');
			$('#txtLTNumber').val('');
			$('#chkIsRelevant').checkbox('setValue',false);
		}
		
	}
	
	//����̼��ùϩʱ���ú���ѡ��
	$('#cboLIsResistQ').combobox({
		onChange: function(	newValue,oldValue){
			if(newValue==1){
				$("#cboLQAnti").combobox("enable");
				$("#cboLQMethod").combobox("enable");
				$("#txtLQNumber").attr('disabled',false);
			}else{
				$("#cboLQAnti").combobox('clear');
				$("#cboLQAnti").combobox('disable');
				$("#cboLQMethod").combobox('clear');
				$("#cboLQMethod").combobox('disable');
				$("#txtLQNumber").val('');
				$("#txtLQNumber").attr('disabled',true);
			}
		}
	});
	//������ӻ���ʱ ���ú���ѡ��
	$('#cboLIsResistT').combobox({
		onChange: function(	newValue,oldValue){
			if(newValue==1){
				$("#cboLTAnti").combobox("enable");
				$("#cboLTMethod").combobox("enable");
				$("#txtLTNumber").attr('disabled',false);
			}else{
				$("#cboLTAnti").combobox('clear');
				$("#cboLTAnti").combobox('disable');
				$("#cboLTMethod").combobox('clear');
				$("#cboLTMethod").combobox('disable');
				$("#txtLTNumber").val('');
				$("#txtLTNumber").attr('disabled',true);
			}
		}
	});
	
	//����ƶ�֮���¼�
	$("#txtLQNumber").bind('change', function (e) {
		var QNumber = $.trim($('#txtLQNumber').val()); 
		QNumber = QNumber.replace(/[\,\'\"\\\/\b\f\n\r\t]/g, '');
		$('#txtLQNumber').val(QNumber);
	});
	 
	//����ƶ�֮���¼�
	$("#txtLTNumber").bind('change', function (e) {
		var TNumber = $.trim($('#txtLTNumber').val()); 	     
		TNumber = TNumber.replace(/[\,\'\"\\\/\b\f\n\r\t]/g, '');
		$('#txtLTNumber').val(TNumber);
	});
					   



	
	// ��Ӳ�ԭѧ֤�ݵ��б�
	obj.winEtiologyEviEdit_Save = function(rowData,rowIndex){
		var CollDate = $('#txtLCollDate').datebox('getValue');	    //�ͼ�����
		var AuthDate = $('#txtLAuthDate').datebox('getValue');	    //��������
		var SpecimenDr = $('#cboLSpecimen').combobox('getValue');	//�ͼ�걾
		var SpecimenDesc = $('#cboLSpecimen').combobox('getText');
		var ResultDr = $('#cboLResult').combobox('getValue');	    //���
		var ResultDesc = $('#cboLResult').combobox('getText');
		var BacteriaDr = $('#cboLBacteria').combobox('getValue');	//ϸ��
		var BacteriaDesc = $('#cboLBacteria').combobox('getText');
		var IsResistQ = $('#cboLIsResistQ').combobox('getText');	//�Ƿ���̼��ùϩ
		IsResistQ = (IsResistQ == '��' ? 1 : 0);
		var IsResistQDesc = $('#cboLIsResistQ').combobox('getText');
		var QAntiDr = $('#cboLQAnti').combobox('getValue');	        //������
		
		var QAntiDesc = $('#cboLQAnti').combobox('getText');
		var QMethodDr = $('#cboLQMethod').combobox('getValue');     //ҩ������
		var QMethodDesc = $('#cboLQMethod').combobox('getText');
		var QNumber = $.trim($('#txtLQNumber').val()); 	                    //ҩ��MIC��ֵ
		var IsResistT = $('#cboLIsResistT').combobox('getText');	//�Ƿ�����ӻ���
		IsResistT = (IsResistT == '��' ? 1 : 0);
		var IsResistTDesc = $('#cboLIsResistT').combobox('getText');
		var TAntiDr = $('#cboLTAnti').combobox('getValue');	         //������
		var TAntiDesc = $('#cboLTAnti').combobox('getText');
		var TMethodDr = $('#cboLTMethod').combobox('getValue');	     //ҩ������
		var TMethodDesc = $('#cboLTMethod').combobox('getText');
		var TNumber = $.trim($('#txtLTNumber').val()); 	                     //ҩ��MIC��ֵ
		var IsRelevant = $('#chkIsRelevant').checkbox('getValue');
		IsRelevant = (IsRelevant == true ? 1 : 0);	                 //�ͼ�걾�Ƿ����Ⱦ������
		if(IsRelevant == 1){
			var IsRelevantDesc = "��";
		}else{
			var IsRelevantDesc = "��";
		}
		
		var errinfo = "";
		var NowDate = Common_GetDate(new Date());
   		if (SpecimenDr==''){
			errinfo = errinfo + "�ͼ�걾����Ϊ��!<br>";
    	}
    	if (BacteriaDr==''){
			errinfo = errinfo + "ϸ������Ϊ��!<br>";
    	}
    	if (ResultDr==''){
    		errinfo = errinfo + "�������Ϊ��!<br>";
    	}
    	if (CollDate==''){
			errinfo = errinfo + "�ͼ����ڲ���Ϊ��!<br>";
    	}
    	if (AuthDate==''){
			errinfo = errinfo + "�������ڲ���Ϊ��!<br>";
    	}
		if (Common_CompareDate(CollDate,AuthDate)>0){
    		errinfo = errinfo + "�ͼ����ڲ����ڱ�������֮��<br>"; 
    	}
		if ((Common_CompareDate(CollDate,NowDate)>0)||(Common_CompareDate(AuthDate,NowDate)>0)) {
    		errinfo = errinfo + "�ͼ����ڡ��������ڲ����ڵ�ǰ����֮��!<br>"; 
    	}
    	/*if ((TAntiDesc!='')&&((TMethodDesc=='')||(TNumber==''))){
	    	errinfo = errinfo + "����д�Ƿ�����ӻ��ص�ҩ����������ֵ!<br>"; 	
	    }
	    if ((QAntiDesc!='')&&((QMethodDesc=='')||(QNumber==''))){
	    	errinfo = errinfo + "����д�Ƿ���̼��ùϩ��ҩ����������ֵ!<br>"; 	
	    }
		var type = /[^\0-9\.\<\>]/g ;�� //���ֻ�< �� >
    	if ((QMethodDesc=="K-B")&&(QNumber!="")) {
		    if ((type.test(QNumber))||((QNumber.replace("<")<6)||(QNumber.replace(">")>40)) //��ʽ�Ƿ���ȷ ����Χ��
	    	    ||((QNumber.indexOf("<")>=1)||(QNumber.indexOf(">")>=1))
	    	    ||((QNumber.indexOf("<")==0)&&(QNumber!='<6'))||((QNumber.indexOf(">")==0)&&(QNumber!='>40'))) {   
		    	errinfo = errinfo + "��̼��ùϩҩ������ΪֽƬ��ʱ��K-Bֵ���С��6��Ϊ<6������40��Ϊ>40��6-40֮������д������ֵ������!<br>"; 
	    	}	
    	}
    	if ((TMethodDesc=="K-B")&&(TNumber!="")) {
	    	if ((type.test(TNumber))||((TNumber.replace("<")<6)||(TNumber.replace(">")>40)) //��ʽ�Ƿ���ȷ ����Χ��
	    	    ||((TNumber.indexOf("<")>=1)||(TNumber.indexOf(">")>=1))
	    	    ||((TNumber.indexOf("<")==0)&&(TNumber!='<6'))||((TNumber.indexOf(">")==0)&&(TNumber!='>40'))) {   
		    	errinfo = errinfo + "����ӻ���ҩ������ΪֽƬ��ʱ��K-Bֵ���С��6��Ϊ<6������40��Ϊ>40��6-40֮������д������ֵ������!<br>"; 
	    	}	
    	}
	    
    	if ((QMethodDesc=="MIC")&&(QNumber!="")) {	 
	    	if ((type.test(QNumber))||((QNumber.replace("<")<0.004)||(QNumber.replace(">")>512)) //��ʽ�Ƿ���ȷ ����Χ��
	    	    ||((QNumber.indexOf("<")>=1)||(QNumber.indexOf(">")>=1))
	    	    ||((QNumber.indexOf("<")==0)&&(QNumber!='<0.004'))||((QNumber.indexOf(">")==0)&&(QNumber!='>512'))) {   
		    	errinfo = errinfo + "��̼��ùϩҩ������Ϊ�Զ�����ʱ��MICֵ���С��0.004��Ϊ<0.004������512��Ϊ>512��0.004-512֮������д������ֵ������!<br>"; 
	    	}
    	}
	    if ((TMethodDesc=="MIC")&&(TNumber!="")) {		
	    	if ((type.test(TNumber))||((TNumber.replace("<")<0.004)||(TNumber.replace(">")>512)) //��ʽ�Ƿ���ȷ ����Χ��
	    	    ||((TNumber.indexOf("<")>=1)||(TNumber.indexOf(">")>=1))
	    	    ||((TNumber.indexOf("<")==0)&&(TNumber!='<0.004'))||((TNumber.indexOf(">")==0)&&(TNumber!='>512'))) {   
		    	errinfo = errinfo + "����ӻ���ҩ������Ϊ�Զ�����ʱ��MICֵ���С��0.004��Ϊ<0.004������512��Ϊ>512��0.004-512֮������д������ֵ������!<br>"; 
	    	}
    	}	*/											
		if (errinfo !='') {
			$.messager.alert("��ʾ", errinfo, 'info');
			return ;
		}
		
    	if (rowData){
    		var ID = rowData.ID;
    	} else {
			var ID = '';
		}
		
		var row ={
			ID:ID,
			CollDate:CollDate,
			AuthDate:AuthDate,
			SpecimenDr:SpecimenDr,
			SpecimenDesc:SpecimenDesc,
			ResultDr:ResultDr,
			ResultDesc:ResultDesc,
			BacteriaDr:BacteriaDr,
			BacteriaDesc:BacteriaDesc,
			IsResistQ:IsResistQ,
			IsResistQDesc:IsResistQDesc,
			QAntiDr:QAntiDr,
			QAntiDesc:QAntiDesc,
			QMethodDr:QMethodDr,
			QMethodDesc:QMethodDesc,
			QNumber:QNumber,
			IsResistT:IsResistT,
			IsResistTDesc:IsResistTDesc,
			TAntiDr:TAntiDr,
			TAntiDesc:TAntiDesc,
			TMethodDr:TMethodDr,
			TMethodDesc:TMethodDesc,
			TNumber:TNumber,
			IsRelevant:IsRelevant,
			IsRelevantDesc:IsRelevantDesc,
			UpdateDate:'',
			UpdateTime:'',
			UpdateUserID:$.LOGON.USERID,
			UpdateUser:''
		}
		// ��������Ƿ��ظ�
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridEtiologyEvi.getRows().length;i++){
    		//r Ϊ�к�
			if ((parseInt(rowIndex) >-1)&&(rowIndex==i)) {	
				continue;	
			}
    		if ((CollDate==obj.gridEtiologyEvi.getRows()[i].CollDate)
			&&(AuthDate==obj.gridEtiologyEvi.getRows()[i].AuthDate)
			&&(SpecimenDr==obj.gridEtiologyEvi.getRows()[i].SpecimenDr)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
			$.messager.confirm("��ʾ", "�����ͼ����ڡ�����������걾������ͬ�ļ�¼���Ƿ������Ϣ?", function (txt) {
				if (txt){
					if (parseInt(rowIndex) > -1){
						//�޸� ����ָ����
						obj.gridEtiologyEvi.updateRow({
							index: rowIndex,	   // index��Ҫ����������������������ֵδ���壬��׷�����С�row�������ݡ�
							row:row
						});
					} else {
						//��� ����һ������
						obj.gridEtiologyEvi.appendRow({
							ID:ID,
							CollDate:CollDate,
							AuthDate:AuthDate,
							SpecimenDr:SpecimenDr,
							SpecimenDesc:SpecimenDesc,
							ResultDr:ResultDr,
							ResultDesc:ResultDesc,
							BacteriaDr:BacteriaDr,
							BacteriaDesc:BacteriaDesc,
							IsResistQ:IsResistQ,
							IsResistQDesc:IsResistQDesc,
							QAntiDr:QAntiDr,
							QAntiDesc:QAntiDesc,
							QMethodDr:QMethodDr,
							QMethodDesc:QMethodDesc,
							QNumber:QNumber,
							IsResistT:IsResistT,
							IsResistTDesc:IsResistTDesc,
							TAntiDr:TAntiDr,
							TAntiDesc:TAntiDesc,
							TMethodDr:TMethodDr,
							TMethodDesc:TMethodDesc,
							TNumber:TNumber,
							IsRelevant:IsRelevant,
							IsRelevantDesc:IsRelevantDesc,
							UpdateDate:'',
							UpdateTime:'',
							UpdateUserID:$.LOGON.USERID,
							UpdateUser:''
						});
					}
					$HUI.dialog('#winEtiologyEviEdit').close();
				}				
			});
    	}else{
			if (parseInt(rowIndex) > -1){
				//�޸� ����ָ����
				obj.gridEtiologyEvi.updateRow({
					index: rowIndex,	   // index��Ҫ����������������������ֵδ���壬��׷�����С�row�������ݡ�
					row:row
				});
			} else {
				//��� ����һ������
				obj.gridEtiologyEvi.appendRow({
					ID:ID,
					CollDate:CollDate,
					AuthDate:AuthDate,
					SpecimenDr:SpecimenDr,
					SpecimenDesc:SpecimenDesc,
					ResultDr:ResultDr,
					ResultDesc:ResultDesc,
					BacteriaDr:BacteriaDr,
					BacteriaDesc:BacteriaDesc,
					IsResistQ:IsResistQ,
					IsResistQDesc:IsResistQDesc,
					QAntiDr:QAntiDr,
					QAntiDesc:QAntiDesc,
					QMethodDr:QMethodDr,
					QMethodDesc:QMethodDesc,
					QNumber:QNumber,
					IsResistT:IsResistT,
					IsResistTDesc:IsResistTDesc,
					TAntiDr:TAntiDr,
					TAntiDesc:TAntiDesc,
					TMethodDr:TMethodDr,
					TMethodDesc:TMethodDesc,
					TNumber:TNumber,
					IsRelevant:IsRelevant,
					IsRelevantDesc:IsRelevantDesc,
					UpdateDate:'',
					UpdateTime:'',
					UpdateUserID:$.LOGON.USERID,
					UpdateUser:''
				});
			}
			$HUI.dialog('#winEtiologyEviEdit').close();
    	};
		obj.chkIsEtiologyEvi();
	}
    //��ԭѧ֤�ݹ�ѡ
	obj.chkIsEtiologyEvi = function(){
		if(obj.gridEtiologyEvi.getRows().length!=0){
			$HUI.radio("input[name='IsEtiologyEvi'][value='true']").setValue(true);
			$HUI.radio("input[name='IsEtiologyEvi'][value='false']").setValue(false);
		}else{
			$HUI.radio("input[name='IsEtiologyEvi'][value='false']").setValue(true);
			$HUI.radio("input[name='IsEtiologyEvi'][value='true']").setValue(false);
		}
	}
	// ȡֵ��ԭѧ֤���б�
	obj.GetRepEviData = function(ReportID){
    	var RepEviInfo = '';
    	for (var indEE=0;indEE<obj.gridEtiologyEvi.getRows().length;indEE++){
			var subID = "";
			if (obj.gridEtiologyEvi.getRows()[indEE].ID!="") {
				subID = obj.gridEtiologyEvi.getRows()[indEE].ID.split("||")[1];
			}
    		var rowData = subID;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].CollDate;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].AuthDate;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].SpecimenDr;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].ResultDr;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].BacteriaDr;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].IsResistQ;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].QAntiDr;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].QMethodDr;
			rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].QNumber;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].IsResistT;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].TAntiDr;
    		rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].TMethodDr;
			rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].TNumber;
			rowData += CHR_1 + obj.gridEtiologyEvi.getRows()[indEE].IsRelevant;
    		RepEviInfo = RepEviInfo + CHR_2 + rowData;
    	}
    	if (RepEviInfo) RepEviInfo = RepEviInfo.substring(1,RepEviInfo.length);
    	return RepEviInfo;
	}
}