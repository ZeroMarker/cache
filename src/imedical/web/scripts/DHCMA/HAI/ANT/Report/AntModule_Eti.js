var objEti = new Object();
function InitEtiologyEvi(obj){
	var obj = objEti;
	obj.EviRowID = ''; //病原学证据选中行
	
	obj.gridEtiologyEvi = $HUI.datagrid("#gridEtiologyEvi",{ 
		title:'病原学证据',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'CollDate',title:'送检日期',width:150},
			{field:'AuthDate',title:'报告日期',width:150},
			{field:'SpecimenDesc',title:'标本类型',width:120},
			{field:'ResultDesc',title:'结果',width:150},
			{field:'BacteriaDesc',title:'细菌名称',width:320},
			{field:'IsResistQDesc',title:'是否耐<br>碳青霉烯',width:100},
			{field:'IsResistTDesc',title:'是否耐<br>替加环素',width:100},
			{field:'IsRelevantDesc',title:'送检标本是否<br>与感染诊断相关',width:120}
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
	
	// 添加病原学证据事件
	$("#btnEtiologyEviAdd").click(function(e){
		obj.winEtiologyEviEdit_Open('','');	
		obj.chkIsEtiologyEvi();
	});
	
	// 删除病原学证据事件
	$("#btnEtiologyEviDel").click(function(e){
		var selectObj = obj.gridEtiologyEvi.getSelected();
		var index = obj.gridEtiologyEvi.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		if (!selectObj) {
			$.messager.alert("提示", "请选择一行要删除的数据?", 'info');
			return;
		}else {
			$.messager.confirm("提示", "是否要删除病原学证据?", function (r) {
				if (r){				
					obj.gridEtiologyEvi.deleteRow(index);
					obj.chkIsEtiologyEvi();
				}
			});
		}
	});
	
	// 弹出病原学证据弹框
	obj.winEtiologyEviEdit_Open = function(rowData,rowIndex){
		$('#winEtiologyEviEdit').dialog({
			buttons:[{
				text:'保存',
				handler:function(){
					obj.winEtiologyEviEdit_Save(rowData,rowIndex);
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#winEtiologyEviEdit').close();}
			}]
		});
		$HUI.dialog('#winEtiologyEviEdit').open();
		
		obj.winEtiologyEviEdit_Init(rowData);
	}
	
	// 病原学证据弹框
	$('#winEtiologyEviEdit').dialog({
		title:'病原学证据--编辑',
		iconCls:'icon-w-paper',
		width: 880,    
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	
	// 病原学检验提取事件
	$('#btnANTEtiSync').click(function(e){
		OpenINFLabSync();
	});
	//病原学检验提取弹出事件
	obj.LayerOpenINFLabSync = $('#LayerOpenINFLabSync').dialog({
		title:"病原学检验-提取", 
		iconCls:'icon-w-paper',
		width: 1000,    
		height: 500, 
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	// 弹出病原学检验提取框
	function OpenINFLabSync(){
		refreshgridINFLabSync();
		$HUI.dialog('#LayerOpenINFLabSync').open();
	}
    //病原学检验列表
	function refreshgridINFLabSync(){	
		obj.gridINFLabSync = $HUI.datagrid("#gridINFLabSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
				QueryName:'QryPatEvi',
				aEpisodeID:EpisodeID
			},
			columns:[[
				{field:'CollDate',title:'送检日期',width:120},
				{field:'LabRegDate',title:'报告日期',width:120},
				{field:'SpecimenDesc',title:'送检标本',width:120},
				{field:'ResultDesc',title:'结果',width:100},
				{field:'BacteriaDesc',title:'细菌',width:150},
				{field:'YesNoTDesc',title:'是否耐替加环素',width:120},
				{field:'AntDescTDesc',title:'抗生素',width:100},
				//{field:'TMethodDesc',title:'药敏方法',width:100},
				//{field:'TNumber',title:'数值',width:80,},
				{field:'YesNoQDesc',title:'是否耐碳青霉烯',width:120},
				{field:'AntDescQDesc',title:'抗生素',width:100},
				//{field:'QMethodDesc',title:'药敏方法',width:100},
				//{field:'QNumber',title:'数值',width:80}
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
				text:'保存',
				handler:function(){
					obj.winEtiologyEviEdit_Save();
				}
			},{
				text:'取消',
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
	// 病原学证据编辑框初始化
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
		// 控件赋值
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
	
	//不耐碳青霉烯时禁用后面选框
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
	//不耐替加环素时 禁用后面选框
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
	
	//鼠标移动之后事件
	$("#txtLQNumber").bind('change', function (e) {
		var QNumber = $.trim($('#txtLQNumber').val()); 
		QNumber = QNumber.replace(/[\,\'\"\\\/\b\f\n\r\t]/g, '');
		$('#txtLQNumber').val(QNumber);
	});
	 
	//鼠标移动之后事件
	$("#txtLTNumber").bind('change', function (e) {
		var TNumber = $.trim($('#txtLTNumber').val()); 	     
		TNumber = TNumber.replace(/[\,\'\"\\\/\b\f\n\r\t]/g, '');
		$('#txtLTNumber').val(TNumber);
	});
					   



	
	// 添加病原学证据到列表
	obj.winEtiologyEviEdit_Save = function(rowData,rowIndex){
		var CollDate = $('#txtLCollDate').datebox('getValue');	    //送检日期
		var AuthDate = $('#txtLAuthDate').datebox('getValue');	    //报告日期
		var SpecimenDr = $('#cboLSpecimen').combobox('getValue');	//送检标本
		var SpecimenDesc = $('#cboLSpecimen').combobox('getText');
		var ResultDr = $('#cboLResult').combobox('getValue');	    //结果
		var ResultDesc = $('#cboLResult').combobox('getText');
		var BacteriaDr = $('#cboLBacteria').combobox('getValue');	//细菌
		var BacteriaDesc = $('#cboLBacteria').combobox('getText');
		var IsResistQ = $('#cboLIsResistQ').combobox('getText');	//是否耐碳青霉烯
		IsResistQ = (IsResistQ == '是' ? 1 : 0);
		var IsResistQDesc = $('#cboLIsResistQ').combobox('getText');
		var QAntiDr = $('#cboLQAnti').combobox('getValue');	        //抗生素
		
		var QAntiDesc = $('#cboLQAnti').combobox('getText');
		var QMethodDr = $('#cboLQMethod').combobox('getValue');     //药敏方法
		var QMethodDesc = $('#cboLQMethod').combobox('getText');
		var QNumber = $.trim($('#txtLQNumber').val()); 	                    //药敏MIC数值
		var IsResistT = $('#cboLIsResistT').combobox('getText');	//是否耐替加环素
		IsResistT = (IsResistT == '是' ? 1 : 0);
		var IsResistTDesc = $('#cboLIsResistT').combobox('getText');
		var TAntiDr = $('#cboLTAnti').combobox('getValue');	         //抗生素
		var TAntiDesc = $('#cboLTAnti').combobox('getText');
		var TMethodDr = $('#cboLTMethod').combobox('getValue');	     //药敏方法
		var TMethodDesc = $('#cboLTMethod').combobox('getText');
		var TNumber = $.trim($('#txtLTNumber').val()); 	                     //药敏MIC数值
		var IsRelevant = $('#chkIsRelevant').checkbox('getValue');
		IsRelevant = (IsRelevant == true ? 1 : 0);	                 //送检标本是否与感染诊断相关
		if(IsRelevant == 1){
			var IsRelevantDesc = "是";
		}else{
			var IsRelevantDesc = "否";
		}
		
		var errinfo = "";
		var NowDate = Common_GetDate(new Date());
   		if (SpecimenDr==''){
			errinfo = errinfo + "送检标本不能为空!<br>";
    	}
    	if (BacteriaDr==''){
			errinfo = errinfo + "细菌不能为空!<br>";
    	}
    	if (ResultDr==''){
    		errinfo = errinfo + "结果不能为空!<br>";
    	}
    	if (CollDate==''){
			errinfo = errinfo + "送检日期不能为空!<br>";
    	}
    	if (AuthDate==''){
			errinfo = errinfo + "报告日期不能为空!<br>";
    	}
		if (Common_CompareDate(CollDate,AuthDate)>0){
    		errinfo = errinfo + "送检日期不能在报告日期之后<br>"; 
    	}
		if ((Common_CompareDate(CollDate,NowDate)>0)||(Common_CompareDate(AuthDate,NowDate)>0)) {
    		errinfo = errinfo + "送检日期、报告日期不能在当前日期之后!<br>"; 
    	}
    	/*if ((TAntiDesc!='')&&((TMethodDesc=='')||(TNumber==''))){
	    	errinfo = errinfo + "请填写是否耐替加环素的药敏方法及数值!<br>"; 	
	    }
	    if ((QAntiDesc!='')&&((QMethodDesc=='')||(QNumber==''))){
	    	errinfo = errinfo + "请填写是否耐碳青霉烯的药敏方法及数值!<br>"; 	
	    }
		var type = /[^\0-9\.\<\>]/g ;　 //数字或< 或 >
    	if ((QMethodDesc=="K-B")&&(QNumber!="")) {
		    if ((type.test(QNumber))||((QNumber.replace("<")<6)||(QNumber.replace(">")>40)) //格式是否正确 、范围内
	    	    ||((QNumber.indexOf("<")>=1)||(QNumber.indexOf(">")>=1))
	    	    ||((QNumber.indexOf("<")==0)&&(QNumber!='<6'))||((QNumber.indexOf(">")==0)&&(QNumber!='>40'))) {   
		    	errinfo = errinfo + "耐碳青霉烯药敏方法为纸片法时，K-B值结果小于6记为<6，大于40记为>40，6-40之间需填写具体数值，请检查!<br>"; 
	    	}	
    	}
    	if ((TMethodDesc=="K-B")&&(TNumber!="")) {
	    	if ((type.test(TNumber))||((TNumber.replace("<")<6)||(TNumber.replace(">")>40)) //格式是否正确 、范围内
	    	    ||((TNumber.indexOf("<")>=1)||(TNumber.indexOf(">")>=1))
	    	    ||((TNumber.indexOf("<")==0)&&(TNumber!='<6'))||((TNumber.indexOf(">")==0)&&(TNumber!='>40'))) {   
		    	errinfo = errinfo + "耐替加环素药敏方法为纸片法时，K-B值结果小于6记为<6，大于40记为>40，6-40之间需填写具体数值，请检查!<br>"; 
	    	}	
    	}
	    
    	if ((QMethodDesc=="MIC")&&(QNumber!="")) {	 
	    	if ((type.test(QNumber))||((QNumber.replace("<")<0.004)||(QNumber.replace(">")>512)) //格式是否正确 、范围内
	    	    ||((QNumber.indexOf("<")>=1)||(QNumber.indexOf(">")>=1))
	    	    ||((QNumber.indexOf("<")==0)&&(QNumber!='<0.004'))||((QNumber.indexOf(">")==0)&&(QNumber!='>512'))) {   
		    	errinfo = errinfo + "耐碳青霉烯药敏方法为自动化法时，MIC值结果小于0.004记为<0.004，大于512记为>512，0.004-512之间需填写具体数值，请检查!<br>"; 
	    	}
    	}
	    if ((TMethodDesc=="MIC")&&(TNumber!="")) {		
	    	if ((type.test(TNumber))||((TNumber.replace("<")<0.004)||(TNumber.replace(">")>512)) //格式是否正确 、范围内
	    	    ||((TNumber.indexOf("<")>=1)||(TNumber.indexOf(">")>=1))
	    	    ||((TNumber.indexOf("<")==0)&&(TNumber!='<0.004'))||((TNumber.indexOf(">")==0)&&(TNumber!='>512'))) {   
		    	errinfo = errinfo + "耐替加环素药敏方法为自动化法时，MIC值结果小于0.004记为<0.004，大于512记为>512，0.004-512之间需填写具体数值，请检查!<br>"; 
	    	}
    	}	*/											
		if (errinfo !='') {
			$.messager.alert("提示", errinfo, 'info');
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
		// 检查数据是否重复
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridEtiologyEvi.getRows().length;i++){
    		//r 为行号
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
			$.messager.confirm("提示", "存在送检日期、报告日期与标本类型相同的记录，是否添加信息?", function (txt) {
				if (txt){
					if (parseInt(rowIndex) > -1){
						//修改 更新指定行
						obj.gridEtiologyEvi.updateRow({
							index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
							row:row
						});
					} else {
						//添加 插入一个新行
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
				//修改 更新指定行
				obj.gridEtiologyEvi.updateRow({
					index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
					row:row
				});
			} else {
				//添加 插入一个新行
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
    //病原学证据勾选
	obj.chkIsEtiologyEvi = function(){
		if(obj.gridEtiologyEvi.getRows().length!=0){
			$HUI.radio("input[name='IsEtiologyEvi'][value='true']").setValue(true);
			$HUI.radio("input[name='IsEtiologyEvi'][value='false']").setValue(false);
		}else{
			$HUI.radio("input[name='IsEtiologyEvi'][value='false']").setValue(true);
			$HUI.radio("input[name='IsEtiologyEvi'][value='true']").setValue(false);
		}
	}
	// 取值病原学证据列表
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