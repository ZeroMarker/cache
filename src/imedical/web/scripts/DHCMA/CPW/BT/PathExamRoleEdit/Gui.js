//页面Gui
function InitExamRoleWin(){
	var obj = new Object();
	obj.RecRowID = "";	
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathExamRole",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathExamRole",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathExamRole.load({
				ClassName:"DHCMA.CPW.BTS.PathExamRoleSrv",
				QueryName:"QryPathExamRole",
				aHospID: $("#cboSSHosp").combobox('getValue')
			});
	  	}
	 })
	var retMultiHospCfg = $m({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSIsOpenMultiHospMode",
		aHospID:session['DHCMA.HOSPID']
	},false);
	if(retMultiHospCfg!="Y" && retMultiHospCfg!="1"){
		//$("#divHosp").hide();
		//$("#btnAuthHosp").hide();
		$("#layout").layout('panel',"north").hide();
		$("#layout").layout('panel',"center").panel({fit:true});		
		$("#layout").layout('resize');
		$("#layout").layout('panel',"center").parent().css({'top':'0'});	
	}
	
	obj.gridPathExamRole = $HUI.datagrid("#gridPathExamRole",{
		fit: true,
		title: "发布审核角色维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathExamRoleSrv",
			QueryName:"QryPathExamRole",
			aHospID:DefHospOID
	    },
		columns:[[
			{field:'xID',title:'ID',width:'50',hidden:true},
			{field:'Code',title:'代码',width:'100',sortable:true},
			{field:'Desc',title:'名称',width:'350'},
			{field:'TypeCode',title:'类型代码',width:'100',hidden:true},	
			{field:'TypeDesc',title:'类型描述',width:'100'},
			{field:'Value',title:'角色值',width:'100',hidden:true}, 
			{field:'ValueDesc',title:'角色对象',width:'150'},
			{field:'Priority',title:'优先级',width:'150'},
			{field:'IsActive',title:'是否有效',width:'100'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathExamRole_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathExamRole_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//角色类型
	obj.cboRoleType = $HUI.combobox("#cboRoleType",{
		//url:$URL,
		valueField: 'id',
		textField: 'text',
		data: [{
			id: 'U',
			text: '用户'
		},{
			id: 'L',
			text: '科室'
		}],
		editable: false,
		defaultFilter:4,
		onSelect:function(rec){
			switch(rec.id) {
		     case 'U':
		     	//角色对象-加载用户
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'Desc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {    	//在请求加载数据之前触发，返回 false 则取消加载动作
						param.ClassName = 'DHCMA.Util.EPS.SSUserSrv';
						param.QueryName = 'QryUserInfo';
						param.aHospID	= $("#cboSSHosp").combobox('getValue')
						param.ResultSetType = 'array';
					}
					/*,
					formatter:function(row){
						if (row.LocDesc!=undefined) return row.Desc+"【"+row.LocDesc+"】";
						else return row.Desc;
					}*/
				})
				
		        break;
		     case 'L':
		        //角色对象-加载科室
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'Desc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.ClassName = 'DHCMA.Util.EPS.LocationSrv';
						param.QueryName = 'QryLocInfo';
						param.aHospID = $("#cboSSHosp").combobox('getValue')
						param.aAdmType = '';
						param.ResultSetType = 'array';
					}
				})
		        break;
		     case 'G':
		        //角色对象-加载安全组
				obj.cboRoleValue = $HUI.combobox("#cboRoleValue",{
					url:$URL,
					valueField: 'OID',
					textField: 'GrpDesc',
					editable: true,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.ClassName = 'DHCMA.Util.EPS.SSGroupSrv';
						param.QueryName = 'QrySSGrpInfo';
						param.aAlias = '';
						param.aHospID	= $("#cboSSHosp").combobox('getValue')
						param.ResultSetType = 'array';
					}
				})
				$.parser.parse('#cboRoleValue'); 
				break;
			} 
		}
	});
	
	
	InitExamRoleEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


