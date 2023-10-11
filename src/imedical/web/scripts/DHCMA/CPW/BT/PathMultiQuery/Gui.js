//页面Gui
function InitCheckQueryWin(){
	var obj = new Object();		
    $.parser.parse(); // 解析整个页面
    obj.LgnRole="";
    obj.LgnRoleID="1";
    obj.LgnRoleDesc="医务部";
    
    //院区
    var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathMast",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathMast",SessionStr,"");
	$('#cboSSHosp').combobox({
  		 onSelect: function(title,index){
	  		 $('#cboLoc').combobox('reload');
	  	} 
	 })

    //科室
	obj.cboLoc = $HUI.combobox("#cboLoc",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aType="E",
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});

	// 路径类型
   obj.cboPathType = $HUI.combobox('#cboPathType', {
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathTypeSrv",
			param.QueryName="QryPathType",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:4
	});
	
	// 就诊类型
   obj.cboAdmType = $HUI.combobox('#cboAdmType', {
		valueField: 'id',
		textField: 'text',
		value:'I',
		data:[
			{id:'I',text:'住院'},
			{id:'O',text:'门诊'}
		]
	});
	
	// 路径有效
   obj.cboCPWIsActive = $HUI.combobox('#cboCPWIsActive', {
		valueField: 'id',
		textField: 'text',
		data:[
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		]
	});
	
	
	// 版本选择
   obj.cboPathVer = $HUI.combobox('#cboPathVer', {
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
				$("#cboApplyStatus").combobox('setValue','').combobox('disable')
				$("#cboPubStatus").combobox('setValue','').combobox('disable')
				$("#cboFormKWs").combobox('setValue','').combobox('disable')	
			}else{
				$("#cboApplyStatus").combobox('enable')
				$("#cboPubStatus").combobox('enable')
				$("#cboFormKWs").combobox('enable')	
			}	
		}
	});
	
   // 申请状态
   obj.cboApplyStatus = $HUI.combobox('#cboApplyStatus', {
		valueField: 'id',
		textField: 'text',
		data:[
			{id:'NoApply',text:'未申请'},
			{id:'Applying',text:'申请中'},
			{id:'ApplyRefused',text:'未通过'},
			{id:'ApplyPass',text:'已通过'}
		]
	});
	
	// 发布状态
	obj.cboPubStatus = $HUI.combobox('#cboPubStatus', {
		valueField: 'id',
		textField: 'text',
		data:[
			 {id:'NotOpen',text:'未发布'},
			 {id:'Using',text:'正使用'},
			 {id:'Cancel',text:'版本作废'}
		]
	});
	
	//路径特征
   obj.cboPathKWs = $HUI.combobox('#cboPathKWs', {
		valueField: 'id',
		textField: 'text',
		multiple:true,
		data:[
		{text:'合并症路径',id:'ComplPath'},
		{text:'手术路径',id:'OperPath'},
	        {text:'无单病种',id:'NotEntity'},
	        {text:'未关联科室',id:'NotLinkLoc'},
	        {text:'无准入信息',id:'NotDiag'},
	        {text:'无付费病种',id:'NotPCEntity'},
	        {text:'无质控病种',id:'NotQCEntity'}
		]
	});
	
	//版本特征
   obj.cboFormKWs = $HUI.combobox('#cboFormKWs', {
		valueField: 'id',
		textField: 'text',
		multiple:true,
		data:[
	        {text:'无适用对象',id:'NotApplyDoc'},
		{text:'无入径标准',id:'NotAdmitDoc'},
	        {text:'有方剂证型',id:'LinkSymp'},
	        {text:'未关联医嘱',id:'NotOrder'},
	        {text:'无参考天数',id:'NotDays'},
	        {text:'无参考费用',id:'NotFees'}
		]
	});
	
	//路径列表
   obj.GridPathMultiQry = $HUI.datagrid("#GridPathMultiQry",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 100,
		pageList : [100,300,500,1000],
		nowrap:false,
		columns:[[
			{field:'PathCode',title:'路径代码',width:'200',hidden:true},
			{field:'PathName',title:'路径名称',width:'200'},
			{field:'PathType',title:'路径类型',width:'80'},
			{field:'PathIsActive',title:'路径有效',width:'80',formatter:function(v,r,i){
				if (v=="1") return "是";
				else return "否";	
			}},
			{field:'PathEty',title:'路径病种',width:'100'},
			//{field:'PathPCEty',title:'付费病种',width:'100'},
			//{field:'PathQCEty',title:'质控病种',width:'200'},
			{field:'AdmType',title:'就诊类型',width:'100'},
			{field:'PathCompl',title:'合并症路径',width:'100',formatter:function(v,r,i){
				if (v=="1") return "是";
				else return "否";
					
			}}, 
			{field:'IsOper',title:'手术路径',width:'100',formatter:function(v,r,i){
				if (v=="1") return "是";
				else return "否";
					
			}},
			//{field:'StaCategory',title:'统计类别',width:'100'},
			{field:'FormVer',title:'版本信息',width:'200',formatter:function(v,r,i){
				if (v == ""){
					return "<span style='color:red'>无版本</span>";	
				}else return v;	
			}},
			{field:'ApplyStatus',title:'申请状态',width:'100'},
			{field:'FormIsActive',title:'版本有效',width:'100',formatter:function(v,r,i){
				if (v=="0") return "否";
				if (v=="1") return "是";	
			}}, 
			{field:'FormCost',title:'参考费用',width:'100'},	
			{field:'FormDays',title:'参考天数',width:'100'},
			{field:'ApplyDoc',title:'适用对象',width:'300'},
			{field:'AdmitDoc',title:'进入路径标准',width:'300'},
			{field:'FormUser',title:'发布人',width:'200'},
			{field:'FormVerDate',title:'发布日期',width:'200'},
		]] ,
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		} 
	});
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


