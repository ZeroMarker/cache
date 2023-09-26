//页面Gui
function InitPathMastListWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.cboHospValue="";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathMast = $HUI.datagrid("#gridPathMast",{
		fit: true,
		title: "路径字典维护",
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
		    ClassName:"DHCMA.CPW.BTS.PathMastSrv",
			QueryName:"QryPathMast"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'120',sortable:true},
			{field:'BTDesc',title:'名称',width:'200'}, 
			{field:'BTTypeDesc',title:'路径类型',width:'100'},
			{field:'BTEntityDesc',title:'病种路径',width:'100'},
			{field:'BTPCEntityDesc',title:'病种付费',width:'150'},
			{field:'BTQCEntityDesc',title:'病种质量',width:'150'},
			{field:'HospDescList',title:'关联医院',width:'150'},
			{field:'BTAdmType',title:'就诊类型',width:'100',formatter:function(v){
				if (v=="I") return "住院";
				else if (v=="O") return "门诊";
				else return "";
				}},
			{field:'BTIsActive',title:'是否有效',width:'80'},
			/*{field:'BTActDate',title:'处置日期',width:'100'},	
			{field:'BTActTime',title:'处置时间',width:'80'},*/
			{field:'BTActUserDesc',title:'处置人',width:'120'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				
				obj.gridPathMast_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathMast_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//路径类型
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.ResultSetType = 'array'
		}
	});
	//病种路径
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.ResultSetType = 'array'
		}
	});
		//病种付费
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCEntitySrv';
			param.QueryName = 'QryPCEntity';
			param.ResultSetType = 'array'
		}
	});
	//病种质量
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.QCEntitySrv';
			param.QueryName = 'QryQCEntity';
			param.ResultSetType = 'array'
		}
	});
	//就诊类型
	obj.AdmType = $HUI.combobox('#AdmType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text:'门诊'},
			{id:'I',text:'住院'}
		]
	})
	obj.cboHosp = $HUI.combobox('#cboHosp', {
		url: $URL,
		editable: false,
		multiple:true,
		selectOnNavigation:false,
		mode: 'remote',
		valueField: 'OID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.EPS.HospitalSrv';
			param.QueryName = 'QryHospInfo';
			param.aIsActive = '1';
			param.ResultSetType = 'array';
		}
		,formatter:function(row){  
			var opts;
			if(row.selected==true){
				opts = "<input type='checkbox' checked='checked' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}else{
				opts = "<input type='checkbox' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}
			return opts;
		},
		onSelect:function(rec) {
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',true);
			obj.cboHospValue=obj.cboHospValue+"^"+rec.OID+"-";
		}
		,onUnselect:function(rec){
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',false);
			var subStr="^"+rec.OID+"-";
			obj.cboHospValue=obj.cboHospValue.replace(subStr,"");
		}
	});
	InitPathMastListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


