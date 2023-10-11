//页面Gui
function InitHISUIWin(){
	var obj = new Object();

	//院区	
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboHosp = Common_ComboToSSHosp3("cboHosp","","","DHCMA_CPW_BT.PathLoc",SessionStr,"");
	$HUI.combobox('#cboHosp',{
	    onSelect:function(row){
			obj.pathList.load({
				ClassName:"DHCMA.CPW.BTS.PathLocSrv",
				QueryName:"QryPathMast",
				aTypeDr:Common_GetValue("cboTypeDr"),
				aKeyWord:$("#txtDesc").val(),
				aHospID:row.OID,
				aIsQryCompl:2
			});	    
		}
    });
	
	//科室
	obj.cboLocDr = $HUI.combobox("#cboLocDr",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboHosp").combobox('getValue'),
			param.ResultSetType='array'	
		},
		/*onShowPanel: function(){
			$(this).combobox('reload');	
		},*/
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});
	
	//初始化赋值	
	obj.cboTypeDr = $HUI.combobox("#cboTypeDr",{
		url:$URL,
		valueField:'BTID',
		textField:'BTDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathTypeSrv",
			param.QueryName="QryPathType",
			param.aHospID=$("#cboHosp").combobox('getValue'),
			param.ResultSetType='array'	
		},
		onShowPanel: function(){
			$(this).combobox('reload');	
		},
		onChange: function (n,o) {	
			obj.pathList.load({
				ClassName:"DHCMA.CPW.BTS.PathLocSrv",
				QueryName:"QryPathMast",
				aTypeDr:n,
				aKeyWord:$("#txtDesc").val(),
				aHospID:$('#cboHosp').combobox('getValue'),
				aIsQryCompl:2
			});
		}				
	});
	//主要
	obj.pathList = $HUI.datagrid("#pathList",{
		url:$URL,
		fit:true,
		title:"路径查询",
		iconCls:'icon-resort',
		headerCls:'panel-header-gray',
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathLocSrv",
			QueryName:"QryPathMast",
			aTypeDr:"",
			aKeyWord:"",
			aIsQryCompl:2,
			aHospID:$('#cboHosp').combobox('getValue'),
			aFlag:1
		},		
		columns:[[					
			{field:'BTDesc',width:'350',title:'路径列表'},
			{field:'BTTypeDesc',width:'200',title:'路径类型'},
			{field:'BTAdmTypeDesc',width:'80',title:'就诊类型'}
		]],
		onLoadSuccess:function(data){
		},
		singleSelect:true,
		pagination:true,
		pageSize:50,
		pageList:[50,100,200]
	});
	//主要
	obj.pathLocList = $HUI.datagrid("#pathLocList",{
		url:$URL,
		fit:true,
		title:"科室常用路径查询",
		iconCls:'icon-resort',
		headerCls:'panel-header-gray',
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathLocSrv",
			QueryName:"QryPathByLoc",
			aLocDr:""
		},		
		columns:[[					
			{field:'BTDesc',width:'350',title:'本科室常用路径'},
			{field:'BTTypeDesc',width:'200',title:'路径类型'},
			{field:'BTAdmTypeDesc',width:'80',title:'就诊类型'}
		]],
		singleSelect:true,
		pagination:true,
		pageSize:50,
		pageList:[50,100,200]
	});
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
