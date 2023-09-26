//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	var aHospID = session['LOGON.HOSPID']+"!!1";
	obj.cboHosp = $HUI.combobox("#cboHosp",{
		url:$URL+"?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&aHospID="+aHospID+"&aIsActive=1&ResultSetType=array",
		valueField:'OID',
		textField:'Desc',
		defaultFilter:4
	});
	//医院科室联动
	$HUI.combobox('#cboHosp',{
	    onSelect:function(row){
		    var HospID=row["OID"];
		    obj.cboLocDr = $HUI.combobox("#cboLocDr",{
				url:$URL+"?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=array&aHospID="+HospID,
				valueField:'OID',
				textField:'Desc',
				defaultFilter:4
			});
	    }
    });
	
	//初始化赋值	
	obj.cboTypeDr = $HUI.combobox("#cboTypeDr",{
		url:$URL+"?ClassName=DHCMA.CPW.BTS.PathTypeSrv&QueryName=QryPathType&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc',
		onChange: function (n,o) {	
			obj.pathList.load({
				ClassName:"DHCMA.CPW.BTS.PathLocSrv",
				QueryName:"QryPathMast",
				aTypeDr:n,
				aKeyWord:$("#txtDesc").val()
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
			aKeyWord:""
		},		
		columns:[[					
			{field:'BTDesc',width:'400',title:'路径列表'},
			{field:'BTAdmTypeDesc',width:'85',title:'就诊类型'}
		]],
		onLoadSuccess:function(data){
		},
		singleSelect:true,
		pagination:false,
		pageSize:2000,
		pageList:[12,14]
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
			{field:'BTDesc',width:'485',title:'本科室常用路径'},
			{field:'BTAdmTypeDesc',width:'85',title:'就诊类型'}
		]],
		singleSelect:true,
		pagination:false,
		pageSize:2000,
		pageList:[12,14]
	});
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
