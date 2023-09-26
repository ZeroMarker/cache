function InitOper(obj){
	obj.OperRowID = ''; //手术信息选中行
	obj.OperID = '';
	obj.OperLocID = '';
	obj.OperDocID = '';
	
	obj.OperDate = '';
	obj.IsHist=""; //当IsHist为1时获取病人索引,查询历史信息
	obj.EpisodeIDs=""; // 选择历次就诊手术信息对应的就诊号
	obj.DelEpisodeIDs=""; // 删除手术信息时，如果手术信息关联的非本次就诊，需同步删除医院感染历史就诊表信息
	// 手术信息
	obj.refreshgridINFOPS = function(){
		
		obj.gridINFOPS = $HUI.datagrid("#gridINFOPS",{ 
			title:'手术信息',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			columns:[[
				{field:'OperName',title:'手术名称',width:200},
				{field:'OperType',title:'手术类型',width:90},
				{field:'OperLoc',title:'手术科室',width:130},
				{field:'OperDate',title:'手术开始时间',width:100,
					formatter: function(value,row,index){
						return row.OperDate+" "+row.SttTime;	
					}
				},
				{field:'EndDate',title:'手术结束时间',width:100,
					formatter: function(value,row,index){
						return row.EndDate+" "+row.EndTime;	
					}
				},
				{field:'OperDocTxt',title:'手术医生',width:90},
				{field:'Anesthesia',title:'麻醉方式',width:80},
				{field:'CuteType',title:'切口类型',width:70},
				{field:'NNISLevel',title:'NNIS分级',width:75},
				{field:'CuteHealing',title:'愈合情况',width:70,align:'center'},
				{field:'IsOperInf',title:'切口感染',width:70,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "是";
						}else {
							return "否";
						}
					}
				},
				{field:'InfType',title:'感染类型',width:80},
				{field:'IsInHospInf',title:'引起院感',width:70,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "是";
						}else {
							return "否";
						}
					}
				}
			]],
			onSelect:function(rindex,rowData){
				if (obj.OperRowID === rindex) {
					obj.OperRowID="";
					$("#btnINFOPSDel").linkbutton("disable");
					obj.gridINFOPS.clearSelections();  //清除选中行
				} else {
					obj.OperRowID = rindex;
					$("#btnINFOPSDel").linkbutton("enable");
				}	
			},
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFOPSEdit(rowdata,rindex);
				}
			},
			onLoadSuccess:function(data){
				$("#btnINFOPSDel").linkbutton("disable");
			}
		});
			
		if (ReportID) {			
			$cm ({
				ClassName:"DHCHAI.IRS.INFOPSSrv",
				QueryName:"QryINFOPSByRep",		
				aReportID: ReportID
			},function(rs){
				$('#gridINFOPS').datagrid('loadData', rs);				
			});
		}
	}
	obj.refreshgridINFOPS();
	
	obj.LayerOpenINFOPS = function() {
		OpenINFOPSSync();
	}

    // 手术信息提取事件
	$('#btnINFOPSSync').click(function(e){
		/// TODO同步手术
		$m({
			ClassName:"DHCHAI.DI.DHS.SyncOpsInfo",
			MethodName:"SyncOperByDateAdm",
			aSCode:OPSSCode,
			aEpisodeIDX:EpisodeIDx,
			aDateFrom:ServiceDate,
			aDateTo:ServiceDate
		});
		OpenINFOPSSync();
	});
	//手术信息提取弹出事件
	obj.LayerOpenINFOPSSync = function() {
		$HUI.dialog('#LayerOpenINFOPSSync',{
			title:"手术信息-提取 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 1200,    
			height: 500, 
			modal: true,
			isTopZindex:true
		});
	}
	// 弹出手术信息提取框
	function OpenINFOPSSync(){
		refreshgridINFOPSSync();
		$('#LayerOpenINFOPSSync').show();
		obj.LayerOpenINFOPSSync();
	}
    //手术信息列表
	function refreshgridINFOPSSync(){
		obj.gridINFOPSSync = $HUI.datagrid("#gridINFOPSSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.IRS.INFOPSSrv',
				QueryName:'QryINFOPSByRep',
				aEpisodeID:EpisodeID,
				IsHist:obj.IsHist
			},
			columns:[[
				{field:'OperName',title:'手术名称',width:200},
				{field:'OperType',title:'手术类型',width:80},
				{field:'OperLoc',title:'手术科室',width:150},
				{field:'OperDate',title:'手术开始时间',width:120,
					formatter: function(value,row,index){
						return row.OperDate+" "+row.SttTime;	
					}
				},
				{field:'EndDate',title:'手术结束时间',width:120,
					formatter: function(value,row,index){
						return row.EndDate+" "+row.EndTime;	
					}
				},
				{field:'OperDocTxt',title:'手术医生',width:100},
				{field:'Anesthesia',title:'麻醉方式',width:100},
				{field:'CuteType',title:'切口类型',width:80},
				{field:'CuteHealing',title:'愈合情况',width:80},
				{field:'NNISLevel',title:'NNIS分级',width:80}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFOPSEdit(rowdata,'');
					$HUI.dialog('#LayerOpenINFOPSSync').close();
				}
			}	
		});		
	}
	
	// 添加 手术信息事件
	$("#btnINFOPSAdd").click(function(e){
		obj.OperAnaesID = '';
		OpenINFOPSEdit('','');	
	});
	// 弹出手术信息弹框
	function OpenINFOPSEdit(d,r){
		$('#LayerOpenINFOPSEdit').show();
		obj.LayerOpenINFOPSEdit();
		$('#LayerOpenINFOPSEdit').dialog({
			buttons:[{
				text:'保存',
				handler:function(){	
					INFOPSAdd(d,r);
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerOpenINFOPSEdit').close();}
			}]
		});
		
		InitINFOPSEditData(d);
	}
	
	// 手术信息弹框
	obj.LayerOpenINFOPSEdit = function() {
		$HUI.dialog('#LayerOpenINFOPSEdit',{
			title:'手术信息-编辑',
			iconCls:'icon-w-paper',
			width: 700,    
			modal: true,
			isTopZindex:true
		});
	}

	$('#chkIsOperInf').checkbox({   //切口感染
		onCheckChange:function(e,value){
			if (value) {	
				$('#cboInfType').combobox("enable");
			}else{
				$('#cboInfType').combobox('clear');
				$('#cboInfType').combobox('disable');
			}
		}
	});
		
	// 手术编辑框信息初始化
	function InitINFOPSEditData(d){
		
		obj.cboOperType = Common_ComboDicID("cboOperType","HAIOperType");
		obj.cboAnesMethod = Common_ComboDicID("cboAnesMethod","Anesthesia");
		obj.cboIncisionr = Common_ComboDicID("cboIncisionr","CuteType");
		obj.cboHealing = Common_ComboDicID("cboHealing","CuteHealing");
		obj.cboNNISLevel = Common_ComboDicID("cboNNISLevel","NNISLevel");
		
		obj.cboInfType = $HUI.combobox("#cboInfType", {
			editable: true,       
			defaultFilter:4,     
			valueField: 'ID',
			textField: 'Desc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosByCode&ResultSetType=array&aPosCode=07";
			   	$("#cboInfType").combobox('reload',url);
			}
		});
		$('#cboInfType').combobox('disable');
		
		obj.cboOper = $HUI.lookup("#cboOper", {
			panelWidth:450,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,            //isCombo为true时，可以搜索要求的字符最小长度
			valueField: 'id',
			textField: 'BTOperDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.OROperDxSrv',QueryName: 'QryOROperDxByInput'},
			columns:[[  
				{field:'BTOperCode',title:'手术代码',width:80},   
				{field:'BTOperDesc',title:'手术名称',width:340}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;        
				param = $.extend(param,{InputStr:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.OperID = rowData['id'];				
			}
		});
		obj.cboOperLoc = $HUI.lookup("#cboOperLoc", {
			panelWidth:450,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			valueField: 'ID',
			textField: 'LocDesc',
			queryParams:{ClassName: 'DHCHAI.BTS.LocationSrv',QueryName: 'QryLocSrv',aHospID:$.LOGON.HOSPID,aLocCate:"I",aLocType:"E",aIsActive:1,aIsGroup:1},
			columns:[[  
				{field:'LocCode',title:'科室代码',width:160},   
				{field:'LocDesc',title:'科室名称',width:260}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;   	
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.OperLocID = rowData['ID'];			
			}
		});
		
		var UseTypeID = $cm({
			ClassName:"DHCHAI.BTS.DictionarySrv",
			MethodName:"GetIDByCode",		
			aType: 'UserType',
			aCode:'D',
			aActive:1
		},false);
		obj.cboOperDoctor = $HUI.lookup("#cboOperDoctor", {
			panelWidth:450,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			valueField: 'ID',
			textField: 'UserDesc',
			queryParams:{ClassName: 'DHCHAI.BTS.SysUserSrv',QueryName: 'QrySysUserList',aTypeID:UseTypeID,aActive:1},
			columns:[[  
				{field:'UserCode',title:'代码',width:160},   
				{field:'UserDesc',title:'姓名',width:260}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;    				
				param = $.extend(param,{aUserName:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.OperDocID = rowData['ID'];			
			}
		});
		
		// 控件赋值
		if (d){
			obj.OperID = d.OperID;
			obj.OperLocID = d.OperLocID;
			obj.OperDocID = d.OperDocID;
			if ((!obj.OperDocID)&&(d.OperDocCode)) {   //update 20191115 根据医生工号查找ID
				obj.OperDocID = $cm({
					ClassName:"DHCHAI.BT.SysUser",
					MethodName:"GetIDByCode",		
					aUserCode: d.OperDocCode
				},false);
			}
		   
			$('#cboOperType').combobox('setValue',d.OperTypeID);
			$('#cboOperType').combobox('setText',d.OperType);
			$('#cboAnesMethod').combobox('setValue',d.AnesthesiaID);
			$('#cboAnesMethod').combobox('setText',d.Anesthesia);
			$('#cboIncisionr').combobox('setValue',d.CuteTypeID);
			$('#cboIncisionr').combobox('setText',d.CuteType);
			$('#cboNNISLevel').combobox('setValue',d.NNISLevelID);
			$('#cboNNISLevel').combobox('setText',d.NNISLevel);
			$('#cboHealing').combobox('setValue',d.CuteHealingID);
			$('#cboHealing').combobox('setText',d.CuteHealing);
			
		    if (d.InfTypeID) {
				$('#cboInfType').combobox('enable');
				$('#cboInfType').combobox('setValue',d.InfTypeID);
				$('#cboInfType').combobox('setText',d.InfType);
			}
			$('#txtOperSttDateTime').datetimebox('setValue',d.OperDate+' '+d.SttTime);
			if ((d.EndDate!='')&&(d.EndTime!='')){
				$('#txtOperEndDateTime').datetimebox('setValue',d.EndDate+' '+d.EndTime);
			}else{
				$('#txtOperEndDateTime').datetimebox('setValue','');
			}
			var OperID = d.ID;
			$("#cboOper").lookup('setText',d.OperName);
			
			var OperLocID = d.OperLocID;
			if ((d.OperLocID=='')||(d.OperLocID=='-1')){
				OperLocID = -1;
				$("#cboOperLoc").lookup('setText','');
			}else {
				$("#cboOperLoc").lookup('setText',d.OperLoc);
			}
			var OperDocID = obj.OperDocID;
			if ((obj.OperDocID=='')||(obj.OperDocID=='-1')){
				OperDocID = -1;
				$("#cboOperDoctor").lookup('setText','');
			}else{
				$("#cboOperDoctor").lookup('setText',d.OperDocTxt);
			}		
					
			if (d.IsOperInf==1){
				$("#chkIsOperInf").checkbox('setValue',true);
			}
			if (d.IsInHospInf==1){
				$("#chkIsInHospInf").checkbox('setValue',true);
			}
			if (d.ImplantFlag==1){
				$("#chkImplants").checkbox('setValue',true);
			}	
		}else {
			$('#cboOperType').combobox('clear');
			$('#cboAnesMethod').combobox('clear');
			$('#cboIncisionr').combobox('clear');
			$('#cboNNISLevel').combobox('clear');
			$('#cboHealing').combobox('clear');
			$('#cboInfType').combobox('clear');
			$('#txtOperSttDateTime').datetimebox('clear');
			$('#txtOperEndDateTime').datetimebox('clear');
			$("#cboOper").lookup('setText','');
			$("#cboOperLoc").lookup('setText','');
			$("#cboOperDoctor").lookup('setText','');
			$("#chkIsOperInf").checkbox('setValue',false);
			$("#chkIsInHospInf").checkbox('setValue',false);
			$("#chkImplants").checkbox('setValue',false);
		}
	}

	// 添加手术信息到列表
	function INFOPSAdd(d,r){
		var NowDate = Common_GetDate(new Date()); 
		var NowTime = Common_GetTime(new Date());
		
		var OperTypeID = $('#cboOperType').combobox('getValue');
		if (OperTypeID==''){
			var OperType='';
		}else{
			var OperType = $('#cboOperType').combobox('getText');
		}
		
		var SttDateTime = $('#txtOperSttDateTime').datetimebox('getValue');
		var OperDate = SttDateTime.split(' ')[0];
		if (obj.IsHist==1){
			var TransInfo = $m({
				ClassName:"DHCHAI.DPS.PAAdmTransSrv",
				MethodName:"GetTransInfoByDate",		
				aEpisodeDr: EpisodeID,
				aDate:OperDate
			},false);
			var InfLoc =TransInfo.split("^")[0];
			var objLoc = $cm({
				ClassName:"DHCHAI.BT.Location",
				MethodName:"GetObjById",		
				aId: InfLoc
			},false);
			if (InfLoc){
				$('#txtInfLoc').val(InfLoc);	
				$('#cboInfLoc').lookup('setText',objLoc.BTDesc);	
			}
			$('#txtInfDate').datebox('setValue',OperDate);
		}
		var SttTime = SttDateTime.split(' ')[1];
		var EndDateTime = $('#txtOperEndDateTime').datetimebox('getValue');
		var EndDate = EndDateTime.split(' ')[0];
		var EndTime = EndDateTime.split(' ')[1];
		
		var AnesthesiaID = $('#cboAnesMethod').combobox('getValue');
		if (AnesthesiaID==''){
			var Anesthesia = '';
		}else{
			var Anesthesia = $('#cboAnesMethod').combobox('getText');
		}
		var CuteTypeID = $('#cboIncisionr').combobox('getValue');
		if (CuteTypeID==''){
			var CuteType = '';
		}else{
			var CuteType = $('#cboIncisionr').combobox('getText');
		}
		var NNISLevelID = $('#cboNNISLevel').combobox('getValue');
		if (NNISLevelID==''){
			var NNISLevel = '';
		}else{
			var NNISLevel = $('#cboNNISLevel').combobox('getText');
		}
		var CuteHealingID = $('#cboHealing').combobox('getValue');
		if (CuteHealingID==''){
			var CuteHealing = '';
		}else{
			var CuteHealing = $('#cboHealing').combobox('getText');
		}
		
   		var InfTypeID = $('#cboInfType').combobox('getValue');
   		if (InfTypeID==''){
			var InfType = '';
		}else{
			var InfType = $('#cboInfType').combobox('getText');
		}
		
		var OperName = $('#cboOper').lookup('getText');
		var OperID = obj.OperID;
		var OperLoc = $('#cboOperLoc').lookup('getText');
		var OperLocID = obj.OperLocID;
		var OperDocTxt = $('#cboOperDoctor').lookup('getText');
		var OperDoc = $('#cboOperDoctor').lookup('getText');
		var OperDocID = obj.OperDocID;
			
		var IsInHospInf = $('#chkIsInHospInf').checkbox('getValue')? '1':'0';
		var ImplantFlag = $('#chkImplants').checkbox('getValue')? '1':'0';
		var IsOperInf = $('#chkIsOperInf').checkbox('getValue')? '1':'0';
   		
		var errinfo = "";
   		if (OperTypeID==''){
			errinfo = errinfo + "手术类型不能为空!<br>";
    	}
    	if (obj.OperID==''){
			errinfo = errinfo + "请选择标准手术名称!<br>";
    	}
    	if (obj.OperLocID==''){
    		errinfo = errinfo + "请选择标准科室名称!<br>";
    	}
    	if (SttDateTime==''){
			errinfo = errinfo + "开始时间不能为空!<br>";
    	}
    	if (EndDateTime==''){
			errinfo = errinfo + "结束时间不能为空!<br>";
    	}
		if ((Common_CompareDate(OperDate,EndDate)>0)||((EndDate == OperDate)&&(SttTime>EndTime))){
    		errinfo = errinfo + "开始时间不能在结束时间之后!<br>"; 
    	}

		if ((Common_CompareDate(OperDate,NowDate)>0)||((OperDate == NowDate)&&(SttTime>NowTime))||
			(Common_CompareDate(EndDate,NowDate)>0)||((EndDate == NowDate)&&(EndTime>NowTime))) {
    		errinfo = errinfo + "开始时间、结束时间不能在当前时间之后!<br>"; 
    	}
    	
    	if (obj.OperDocID==''){
			errinfo = errinfo + "手术医生不能为空!<br>";
    	}
    	if (AnesthesiaID==''){
			errinfo = errinfo + "麻醉方式不能为空!<br>";
    	}
    	if (NNISLevelID==''){
			errinfo = errinfo + "NNIS分级不能为空!<br>";
    	}
    	if (CuteTypeID==''){
			errinfo = errinfo + "切口类型不能为空!<br>";
    	}
    	if ((IsOperInf==1)&&(InfTypeID=='')){
			errinfo = errinfo + "感染类型不能为空!<br>";
    	}
		if (errinfo !='') {
			$.messager.alert("提示", errinfo, 'info');
			return ;
		}
	
    	var ID ='';
    	var OperAnaesID=''
    	if (d){
    		ID = d.ID;
    		OperAnaesID = d.OperAnaesID;
    	}
    	// 手麻记录ID特殊处理
		if (OperAnaesID=='-1') OperAnaesID = '';
		var row ={
			ID:ID,
			EpisodeID:EpisodeID,
			OperAnaesID:OperAnaesID,
			OperID:OperID,  //增加一个字段用于判断输入的手术名称是否标准手术
			OperName:OperName,
			OperName2:'',
			OperLocID:OperLocID,
			OperLoc:OperLoc,
			OperDate:OperDate,
			EndDate:EndDate,
			SttTime:SttTime,
			EndTime:EndTime,
			OperHours:'',
			OperDocTxt:OperDocTxt,
			OperDocID:OperDocID,
			OperDoc:OperDoc,
			OperTypeID:OperTypeID,
			OperType:OperType,
			AnesthesiaID:AnesthesiaID,
			Anesthesia:Anesthesia,
			NNISLevelID:NNISLevelID,
			NNISLevel:NNISLevel,
			CuteTypeID:CuteTypeID,
			CuteType:CuteType,
			CuteHealingID:CuteHealingID,
			CuteHealing:CuteHealing,
			IsOperInf:IsOperInf,
			InfTypeID:InfTypeID,
			InfType:InfType,
			IsInHospInf:IsInHospInf,
			ASAScoreID:'',
			ASAScore:'',
			PreoperWBC:'',
			CuteNumber:'',
			EndoscopeFlag:'',
			ImplantFlag:ImplantFlag,
			PreoperAntiFlag:'',
			BloodLossFlag:'',
			BloodLoss:'',
			BloodTransFlag:'',
			BloodTrans:'',
			PostoperComps:'',
			UpdateDate:'',
			UpdateTime:'',
			UpdateUserID:$.LOGON.USERID,
			UpdateUser:''
		}
	
		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFOPS.getRows().length;i++){
    		//r 为行号
			if ((parseInt(r) >-1)&&(r==i)) {	
				continue;	
			}
			if ((OperAnaesID!="")&&(OperAnaesID==obj.gridINFOPS.getRows()[i].OperAnaesID)) {
				$.messager.alert("提示", '同一条手术记录只允许提取添加一次,如需修改请选择已添加的手术记录!', 'info');
				return;
			}
		
    		if ((OperName==obj.gridINFOPS.getRows()[i].OperName)&&(OperDate==obj.gridINFOPS.getRows()[i].OperDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
			$.messager.confirm("提示", "存在手术日期、手术名称相同的记录,是否添加手术信息?", function (t) {
				if (t){	
					if (parseInt(r) >-1){  //修改
						obj.gridINFOPS.updateRow({  //更新指定行
							index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
							row:row
						});
					}else{	//添加
						obj.gridINFOPS.appendRow({  //插入一个新行
							ID:ID,
							EpisodeID:EpisodeID,
							OperAnaesID:OperAnaesID,
							OperID:OperID,  //增加一个字段用于判断输入的手术名称是否标准手术
							OperName:OperName,
							OperName2:'',
							OperLocID:OperLocID,
							OperLoc:OperLoc,
							OperDate:OperDate,
							EndDate:EndDate,
							SttTime:SttTime,
							EndTime:EndTime,
							OperHours:'',
							OperDocTxt:OperDocTxt,
							OperDocID:OperDocID,
							OperDoc:OperDoc,
							OperTypeID:OperTypeID,
							OperType:OperType,
							AnesthesiaID:AnesthesiaID,
							Anesthesia:Anesthesia,
							NNISLevelID:NNISLevelID,
							NNISLevel:NNISLevel,
							CuteTypeID:CuteTypeID,
							CuteType:CuteType,
							CuteHealingID:CuteHealingID,
							CuteHealing:CuteHealing,
							IsOperInf:IsOperInf,
							InfTypeID:InfTypeID,
							InfType:InfType,
							IsInHospInf:IsInHospInf,
							ASAScoreID:'',
							ASAScore:'',
							PreoperWBC:'',
							CuteNumber:'',
							EndoscopeFlag:'',
							ImplantFlag:ImplantFlag,
							PreoperAntiFlag:'',
							BloodLossFlag:'',
							BloodLoss:'',
							BloodTransFlag:'',
							BloodTrans:'',
							PostoperComps:'',
							UpdateDate:'',
							UpdateTime:'',
							UpdateUserID:$.LOGON.USERID,
							UpdateUser:''
						});
					}
					$HUI.dialog('#LayerOpenINFOPSEdit').close();
				}				
			});
    	}else{
			if (parseInt(r) >-1){  //修改
				obj.gridINFOPS.updateRow({  //更新指定行
					index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
					row:row
				});
			}else{	//添加
				obj.gridINFOPS.appendRow({  //插入一个新行
					ID:ID,
					EpisodeID:EpisodeID,
					OperAnaesID:OperAnaesID,
					OperID:OperID,  //增加一个字段用于判断输入的手术名称是否标准手术
					OperName:OperName,
					OperName2:'',
					OperLocID:OperLocID,
					OperLoc:OperLoc,
					OperDate:OperDate,
					EndDate:EndDate,
					SttTime:SttTime,
					EndTime:EndTime,
					OperHours:'',
					OperDocTxt:OperDocTxt,
					OperDocID:OperDocID,
					OperDoc:OperDoc,
					OperTypeID:OperTypeID,
					OperType:OperType,
					AnesthesiaID:AnesthesiaID,
					Anesthesia:Anesthesia,
					NNISLevelID:NNISLevelID,
					NNISLevel:NNISLevel,
					CuteTypeID:CuteTypeID,
					CuteType:CuteType,
					CuteHealingID:CuteHealingID,
					CuteHealing:CuteHealing,
					IsOperInf:IsOperInf,
					InfTypeID:InfTypeID,
					InfType:InfType,
					IsInHospInf:IsInHospInf,
					ASAScoreID:'',
					ASAScore:'',
					PreoperWBC:'',
					CuteNumber:'',
					EndoscopeFlag:'',
					ImplantFlag:ImplantFlag,
					PreoperAntiFlag:'',
					BloodLossFlag:'',
					BloodLoss:'',
					BloodTransFlag:'',
					BloodTrans:'',
					PostoperComps:'',
					UpdateDate:'',
					UpdateTime:'',
					UpdateUserID:$.LOGON.USERID,
					UpdateUser:''
				});
			}
			$HUI.dialog('#LayerOpenINFOPSEdit').close();
    	};
	}
     
	// 删除手术信息事件
	$("#btnINFOPSDel").click(function(e){
		var selectObj = obj.gridINFOPS.getSelected();
		var index = obj.gridINFOPS.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		if (!selectObj) {
			$.messager.alert("提示", "请选择一行要删除的手术数据!", 'info');
			return;
		}else {
			$.messager.confirm("提示", "是否要删除手术信息："+selectObj.OperName+" ?", function (r) {
				if (r){				
					obj.gridINFOPS.deleteRow(index);
					var tmpEpisodeID = selectObj.EpisodeID;
					if (tmpEpisodeID!=EpisodeID) {
			    		obj.DelEpisodeIDs = obj.DelEpisodeIDs+"^"+tmpEpisodeID;
		    		}
				}
			});
		}				
	});
	
	obj.OPR_Save = function(){
		// 手术信息
    	var OPS = '';
    	for (var i=0;i<obj.gridINFOPS.getRows().length;i++){
    		var Input = obj.gridINFOPS.getRows()[i].ID;
    		var tmpEpisodeID=obj.gridINFOPS.getRows()[i].EpisodeID;
    		if (tmpEpisodeID==EpisodeID) {
	    		obj.EpisodeIDs = obj.EpisodeIDs+"^"+tmpEpisodeID;
	    		if (obj.DelEpisodeIDs.indexOf(tmpEpisodeID)>=0){
		    		obj.DelEpisodeIDs=obj.DelEpisodeIDs.replace(tmpEpisodeID,"");
		    	}
    		}
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperAnaesID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperLocID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperName;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperName2;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperDate;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].SttTime;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].EndTime;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperHours;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperDocTxt;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperDocID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].OperTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].AnesthesiaID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].NNISLevelID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].CuteTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].CuteHealingID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].IsOperInf;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].InfTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].IsInHospInf;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].ASAScoreID;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].PreoperWBC;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].CuteNumber;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].EndoscopeFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].ImplantFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].PreoperAntiFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].BloodLoss;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].BloodLossFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].BloodTrans;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].BloodTransFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.getRows()[i].PostoperComps;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		OPS = OPS + CHR_2 + Input;
    	}
    	if (OPS) OPS = OPS.substring(1,OPS.length);

    	return OPS;
	}

}