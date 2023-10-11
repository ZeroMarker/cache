//页面Gui
function InitProEditWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_Util_BT.Config",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_Util_BT.Config",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridConfig.load({
				ClassName:"DHCMA.Util.BTS.ConfigSrv",
				QueryName:"QryByProduct",
				aProductCode:ProductCode,
				aKeyValue:$('#txtSearch').searchbox('getValue'),
				aHospID:$("#cboSSHosp").combobox('getValue')
			});
	  	}
	 })
	 /*
	var retMultiHospCfg = $m({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSIsOpenMultiHospMode",
		aHospID:session['DHCMA.HOSPID']
	},false);
	if(retMultiHospCfg!="Y" && retMultiHospCfg!="1"){
		$("#layout").layout('panel',"north").hide();
		$("#layout").layout('panel',"center").panel({fit:true});		
		$("#layout").layout('resize');
		$("#layout").layout('panel',"center").parent().css({'top':'0'});	
	}*/
	
	obj.gridConfig = $HUI.datagrid("#gridConfig",{
		fit: true,
		title: "系统参数配置",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.ConfigSrv",
			QueryName:"QryByProduct",
			aProductCode:ProductCode,
			aHospID:session['DHCMA.HOSPID'],
			aKeyValue:$('#txtSearch').searchbox('getValue')
	    },
		columns:[[
			{field:'ind',title:'序号',width:'50'},
			{field:'Code',title:'代码',width:'200'},
			{field:'Desc',title:'描述',width:'350',formatter: function (value) {
                return "<span title='" + value + "' class='hisui-tooltip'>" + value + "</span>";
            }},
			{field:'value',title:'配置值',width:'100'},
			{field:'Comments',title:'配置说明',width:'500',formatter: function (value) {
                return "<span title='" + value + "' class='hisui-tooltip'>" + value + "</span>";
            }},
			{field:'HospDesc',title:'医院',width:'150'},
			{field:'ProDesc',title:'产品线',width:'80'},
			{field:'IsActive',title:'是否有效',width:'70',align:'center'},
			{field:'ActDate',title:'处置日期',width:'100'},
			{field:'UserDesc',title:'处置人',width:'100'},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridConfig_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridConfig_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$(".hisui-tooltip").tooltip({
				onShow:function(){
					$(this).tooltip('tip').css({
						//可在此修改样式
					})	
				}	
			})
		}
	});
	obj.cboProduct = $HUI.combobox('#cboProduct', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ProID',
		textField: 'ProDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.ProductSrv';
			param.QueryName = 'QryProduct';
			param.aActive = '1';
			param.ResultSetType = 'array'
		}
	});
	
	//搜索框定义
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			obj.gridConfig.load({
				ClassName:"DHCMA.Util.BTS.ConfigSrv",
				QueryName:"QryByProduct",
				aProductCode:ProductCode,
				aKeyWords:value,
				aHospID:session['DHCMA.HOSPID'],
			});
		}, 
		prompt:'请输入代码/描述' 
	});
	
	InitProEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


