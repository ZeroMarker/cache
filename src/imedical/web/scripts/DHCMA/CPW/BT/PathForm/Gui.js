//页面Gui
var obj = new Object();
function InitHISUIWin(){
	obj.selVerID = "";
	obj.selVerEpID = "";
	obj.ItemRowData = null;
	obj.PathFormSympDr = "";
	
	obj.DescSearch="";
	//当前表单版本信息
	obj.CurrForm = new Object();
	obj.CurrForm.ID       = "";
	obj.CurrForm.PathDesc = "";
	obj.CurrForm.Version  = "";
	obj.CurrForm.IsActive = 0;
	obj.CurrForm.IsOpen   = 0;
	obj.CurrForm.PathType = "";
	obj.PreventUnMD=0
	obj.PreventUnOP=0
	obj.type="Y"
	
	//MA下权限检查
	obj.LocID=session['DHCMA.CTLOCID'];
	if(tDHCMedMenuOper['admin']>0) obj.LocID=0;
	
	//默认医院根据配置加载，走平台多院区则加载当前登录医院所属默认医院组，否则即当前登录医院
	obj.DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathMast",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	obj.cboHospValue=obj.DefHospOID;
	
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathMast",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(rec){
	  		obj.cboHospValue=rec.OID;	
	  	}
	 })
	 debugger
	//手术ICD维护
	obj.gridSlectOperOrds = $HUI.datagrid("#gridSlectOperOrds",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'数据加载中...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center'},
			{field:'ICD',title:'ICD代码',width:150,align:'center'},
			{field:'Desc',title:'手术名称',width:250,align:'center'}
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnOperMatch_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnOperMatch_click();
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) 
			{
				obj.btnOperMatch_click();
			}
		},
		onUncheckAll:function(rindex,rowData){
			if (obj.PreventUnOP==0){
				obj.btnOperMatch_click();
			}else{
				obj.PreventUnOP=0;
			}
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                  if(val.checked==1){
                    $('#gridSlectOperOrds').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                  }else{
	                $('#gridSlectOperOrds').datagrid("unselectRow", idx); 
	              }
            });
		}
	});
	//诊断ICD维护
	obj.gridSlectMDiagOrds = $HUI.datagrid("#gridSlectMDiagOrds",{
		fit:true,
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:true,
		striped:true,
		rownumbers:true, 
		checkOnSelect:true, 
		selectOnCheck:true, 
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 30,
		pageList : [10,30,50],
		loadMsg:'数据加载中...',
	    bodyCls:'no-border',
	    idField :'BTID',
		columns:[[	
			{field:'checked',checkbox:'true',align:'center'},
			{field:'ICD',title:'ICD代码',width:150,align:'center'},
			{field:'Desc',title:'诊断名称',width:250,align:'center'}
		]],
		onCheck:function(rindex,rowData){
			if (rowData.checked!=1) obj.btnMDiagMatch_click();
		},
		onCheckAll:function(rindex,rowData){
			obj.btnMDiagMatch_click();
		},
		onUncheck:function(rindex,rowData){
			if (rowData.checked==1) 
			{
				obj.btnMDiagMatch_click();
			}
		},
		onUncheckAll:function(rindex,rowData){
			if (obj.PreventUnMD==0){
				obj.btnMDiagMatch_click();
			}else{
				obj.PreventUnMD=0;
			}
		},
		onLoadSuccess:function(data){
			var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                  if(val.checked==1){
                    $('#gridSlectMDiagOrds').datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                  }else{
	                $('#gridSlectMDiagOrds').datagrid("unselectRow", idx); 
	              }
            });
		}
	});

	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.aHospID	= obj.cboHospValue;
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
		
	});
	//病种路径
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aIsActive = '1';
			param.aHospID	= obj.cboHospValue;
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
	});
	//病种付费
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'RowID',
		textField: 'Desc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCEntitySrv';
			param.QueryName = 'QryPCEntity';
			param.aIsActive = '1';
			param.ResultSetType = 'array'
		},
		onSelect:function(rec){
			var ret = $m({
				ClassName:"DHCMA.Util.BT.Config",
				MethodName:"GetValueByCode",
				aCode:"SDIsOpenPCModBaseCPW"
			},false);
	  		if(parseInt(ret)!=1) {
	  			$.messager.alert("提示", "未启用单病种付费提醒功能，请开启该模块配置后再维护此数据！", 'info');
	  			$("#cboPCEntityDr").combobox({disabled:true});
	  			return false;
	  		}	
		}
	});
	//病种质量
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.QCEntitySrv';
			param.QueryName = 'QryQCEntity';
			param.ResultSetType = 'array'
		}
	});
	
	//中药方剂维护-弹出窗体初始化
	$('#winPathFormSympEdit').dialog({
		title: '方剂证型维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//方剂证型维护-中药方剂加载
	obj.cboSympTCM = $HUI.combobox('#cboSympTCM', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTCMSrv';
			param.QueryName = 'QryPathTCM';
			param.ResultSetType = 'array';
			param.aWay="droplist";
			param.aHospID=obj.cboHospValue;
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
	});
	//方剂证型维护-路径版本加载
	obj.cboPathForm = $HUI.combobox('#cboPathForm', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'FormID',
		textField: 'FormVerDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathFormSrv';
			param.QueryName = 'QryPathForm';
			param.ResultSetType = 'array';
			param.aPathMastDr = $("#pathMastID").val();
		}
	});
	
	//方剂证型维护-中医症候维护
	obj.cboSympDiagnos = $HUI.combobox('#cboSympDiagnos',{
		//url:$URL,
		valueField: 'SympDiaID',
		textField: 'SympDiaDesc',
		multiple:true,  //多选
		mode: 'remote',
		rowStyle:'checkbox',
		selectOnNavigation:false,
		editable: false,
		onBeforeLoad: function (param) {
			/*
			var panel=$("#cboSympDiagnos").combo('panel');
			var preHtml="<input class=\"textbox\" id=\"txtSearch\" placeholder=\"  输入查询内容\" style=\"width:99%;\" οnkeyup=\"$(this).load()\" />";
			$(preHtml).prependTo($(panel).parent("div"));
			
			param.ClassName = 'DHCMA.CPW.BTS.PathFormSympSrv';
			param.QueryName = 'QuerySetPattern';
			param.ResultSetType = 'array';
			param.aAlias = $("#cboSympDiagnos").combobox('getText');
			param.aHospID = obj.cboHospValue;
			*/
		},
		onShowPanel:function(){
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=DHCMA.CPW.BTS.PathFormSympSrv&QueryName=QuerySetPattern&aAlias="+$("#cboSympDiagnos").combobox('getText')+"&aHospID="+obj.cboHospValue+"&ResultSetType=array";
				$(this).combobox('reload',url);
			}
			//$(this).combobox('reload');
		}
	})
	//证型搜索
	obj.cboSearchKey = $HUI.combobox('#cboSearchKey',{
		//url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:false,  //多选
		//mode: 'remote',
		//rowStyle:'checkbox',
		valueField: 'SympDiaID',
		textField: 'SympDiaDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onShowPanel:function(){
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=DHCMA.CPW.BTS.PathFormSympSrv&QueryName=QuerySetPattern&aAlias="+""+"&aHospID="+obj.cboHospValue+"&ResultSetType=array";
				$(this).combobox('reload',url);
			}
			//$(this).combobox('reload');
		},
		
		onSelect:function(row){
			//alert(row.SympDiaID+","+row.SympDiaDesc)
			var SympDiagnos = obj.cboSympDiagnos.getValues();
			var SympDiagnosDesc = obj.cboSympDiagnos.getText();
			var ret = SympDiagnos.indexOf(row.SympDiaID);
			if(ret>-1){
				$.messager.alert("提示","路径方剂已存在"+row.SympDiaDesc+"！");
			}
			
			SympDiagnos.push(row.SympDiaID);
			obj.cboSympDiagnos.setValues(SympDiagnos);
			if (SympDiagnosDesc==""){
				obj.cboSympDiagnos.setText(row.SympDiaDesc);
			}else{
				obj.cboSympDiagnos.setText(SympDiagnosDesc+","+row.SympDiaDesc);	
			}
			
			$("#cboSearchKey").combobox('setValue',"");
		}
	})
	
	//版本选择
	obj.PathVer = $HUI.combobox('#PathVer', {
		valueField: 'id',
		textField: 'text',
		value:'-1',
		data:[
			{id:'-1',text:'全部版本'},
			{id:'0',text:'当前版本'},		//当前版本，即有发布版本即指发布版本，无发布版本则指最新未发布版本
			{id:'1',text:'发布版本'},
			{id:'2',text:'最新版本'},
			{id:'-2',text:'无版本'}
		],
		onSelect:function(rec){
			if (rec.id == '-2'){
				$("#kwVersion").keywords('clearAllSelected');
				$("#kwPubStatus").keywords('clearAllSelected');
				$("#kwApplyStatus").keywords('clearAllSelected');	
			}	
		}
	});
	
	// 发布状态
	$("#kwPubStatus").keywords({
        singleSelect:false,
        labelCls:'blue',
	    items:[{
                text:"发布状态", 
                type:"section",
                items:[
                    {text:'未发布',id:'NotOpen'},
			        {text:'正使用',id:'Using'},
			        {text:'版本作废',id:'Cancel'}
                ]
            }
	        
	    ],
	    onClick:function(v){},
	    onUnselect:function(v){},
	    onSelect:function(v){
		    var valPathVer = $("#PathVer").combobox('getValue');
		    if (valPathVer == '-2'){
				$("#kwPubStatus").keywords('clearAllSelected');
			}
		}
	});
	
	// 申请状态
	$("#kwApplyStatus").keywords({
        singleSelect:false,
        labelCls:'blue',
	    items:[{
                text:"申请状态", 
                type:"section",
                items:[
                    {text:'未申请',id:'NoApply'},
			        {text:'申请中',id:'Applying'},
			        {text:'未通过',id:'ApplyRefused'},
			        {text:'已通过',id:'ApplyPass'}
                ]
            }
	        
	    ],
	    onClick:function(v){},
	    onUnselect:function(v){},
	    onSelect:function(v){
		    var valPathVer = $("#PathVer").combobox('getValue');
		    if (valPathVer == '-2'){
				$("#kwApplyStatus").keywords('clearAllSelected');	
			}
		}
	});
	
	// 版本特征
	$("#kwVersion").keywords({
        singleSelect:false,
        labelCls:'blue',
        text:"版本",
        type:"chapter",
	    items:[{
                text:"版本特征", 
                type:"section",
                items:[
                	{text:'无适用对象',id:'NotApplyDoc'},
			        {text:'无入径标准',id:'NotAdmitDoc'},
			        {text:'有方剂证型',id:'LinkSymp'},
			        {text:'未关联医嘱',id:'NotOrder'},
			        {text:'无参考天数',id:'NotDays'},
			        {text:'无参考费用',id:'NotFees'}
                ]
            }
	        
	    ],
	    onClick:function(v){},
	    onUnselect:function(v){},
	    onSelect:function(v){
		    var valPathVer = $("#PathVer").combobox('getValue');
		    if (valPathVer == '-2'){
				$("#kwVersion").keywords('clearAllSelected');
			}	
		}
	});
	
	// 路径特征
	$("#kwPath").keywords({
        singleSelect:false,
        labelCls:'blue',
	    items:[{
                text:"路径特征", 
                type:"section",
                items:[
                	{text:'无效路径',id:'NotActive'},
                	{text:'合并症路径',id:'ComplPath'},
                    {text:'手术路径',id:'OperPath'},
			        {text:'无单病种',id:'NotEntity'},
			        {text:'未关联科室',id:'NotLinkLoc'},
			        {text:'无准入信息',id:'NotDiag'},
			        {text:'无付费病种',id:'NotPCEntity'},
			        {text:'无质控病种',id:'NotQCEntity'}
                ]
            }
	        
	    ],
	    onClick:function(v){},
	    onUnselect:function(v){},
	    onSelect:function(v){	
		}
	});
	
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	
	//根据配置获取tab展示信息
	$m({ClassName:"DHCMA.Util.BT.Config",MethodName:"GetValueByCode",aCode:"CPWShowCPWTypeTab",aHospID:session['DHCMA.HOSPID']},function(ret){
		if(ret=="I"){
			$("#cpwTypeTab").tabs("getTab","门诊路径").panel("options").tab.hide();
			$("#OutCPW").hide();
			$("#tabsw").tabs("getTab","方剂证型维护").panel("options").tab.hide()
			
		}else if(ret=="O"){							
			$("#cpwTypeTab").tabs("getTab","住院路径").panel("options").tab.hide();
			$("#InCPW").hide();
			$("#cpwTypeTab").tabs("select","门诊路径");
		}else{
		}
	});
	
	return obj;
}
