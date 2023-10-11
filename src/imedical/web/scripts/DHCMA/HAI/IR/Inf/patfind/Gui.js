//页面Gui
var obj = new Object();
function InitPatFindWin(){
	var IsCheckFlag=false;

	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			obj.cboWard = Common_ComboMuLoc('cboWard',rec.ID,"","I|E","W");
			obj.cboLocation = Common_ComboMuLoc("cboLocation",rec.ID,"","I|E","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //联动表格需先初始化
	$('#cboWard').combobox({});
	
	//默认日期类型
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'入院日期'},
			{value:'2',text:'出院日期'},
			{value:'3',text:'在院日期'}
		],
		allowNull:true,
		valueField:'value',
		textField:'text'
	});
	 $HUI.combobox("#cboRelation",{
		data:[
			{value:'1',text:'或',selected:true},
			{value:'2',text:'且'}
		],
		valueField:'value',
		textField:'text'
	})
	
	//检测项目
	$HUI.combobox('#cboItems',{
		url:$URL+'?ClassName=DHCHAI.IRS.CCItmMastSrv&QueryName=QryItmMast&ResultSetType=Array',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		valueField:'ID',
		textField:'Desc',
		panelHeight:300,
		editable:true   		    
    });
	
	$HUI.combobox("#cboDischStatus",{
		data:[
			{value:'0',text:'正常'},
			{value:'1',text:'死亡'}
		],
		editable:true,
		allowNull:true,
		valueField:'value',
		textField:'text'
	})
	var HospIDs 	= $("#cboHospital").combobox('getValue');
	var DateType	= $("#cboDateType").combobox('getValue');
	var DateFrom 	= $("#DateFrom").datebox('getValue');
	var DateTo 		= $("#DateTo").datebox('getValue');
	var LocationID  = $("#cboLocation").combobox('getValue');
	var WardID	 	= $("#cboWard").combobox('getValue');
	var Items		= $("#cboItems").combobox('getValue');
	var PatName 	= $("#txtPatName").val();
	var PapmiNo 	= $("#txtPapmiNo").val();
	var MrNo 		= $("#txtMrNo").val();
	var Relation    = $('#cboRelation').combobox('getValue');
	var IsDeath     = $('#cboDischStatus').combobox('getValue');
	var aInputs = HospIDs+'^'+DateType+'^'+DateFrom+'^'+DateTo+'^'+LocationID+'^'+WardID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+'^'+Items+"^"+Relation+"^"+IsDeath;
	 //病例列表
	 obj.gridAdm = $HUI.datagrid("#gridAdm",{
		fit: true,
		title: "住院病人查找",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [20,50,100,200,1000],
		 //是否是服务器对数据排序
        sortOrder:'asc',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdm",
			aIntputs:aInputs,
			aPatInfo:''
	    },	    
		columns:[[
			{field:'PapmiNo',title:'登记号',width:100,align:'left',sortable:true},
			{field:'MrNo',title:'病案号',width:100,align:'left',sortable:true},
			{field:'AdmTimes',title:'住院次数',width:70,align:'left',sortable:true},
			{field:'PatName',title:'姓名',width:100,align:'left',sortable:true},
			{field:'Sex',title:'性别',width:50,align:'left',sortable:true},
			{field:'Age',title:'年龄',width:70,align:'left',sortable:true},
			{field:'IdentityCode',title:'身份证号码',width:200,align:'left',sortable:true},
			{field:'ZY',title:'摘要',width:70,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>摘要</a>';
				}
			},
			{field:'link',title:'电子病历',width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					var EpisodeIDx = row.EpisodeIDx;
					var EpisodeID = EpisodeIDx.split("||")[1];
					 return '<a href="#" onclick=obj.btnEmrRecord_Click(\''+EpisodeID+'\',\''+row.PatientIDx+'\')>电子病历</a>';
				}
			},
			{field:'expander',title:'院感报告',width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnReprot_Click(\''+row.EpisodeID+'\')>新建</a>';
				}
			},
			{field:'AdmType',title:'就诊类型',width:100,align:'left',sortable:true},
			{field:'AdmDate',title:'入院日期',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'AdmTime',title:'入院时间',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'AdmLocDesc',title:'科室',width:150,align:'left',sortable:true},
			{field:'AdmWardDesc',title:'病区',width:150,align:'left',sortable:true},
			{field:'AdmBed',title:'床号',width:70,align:'left',sortable:true},
			{field:'DischDate',title:'出院日期',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'DischTime',title:'出院时间',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'DischLocDesc',title:'出院科室',width:150,align:'left',sortable:true},
			{field:'DischWardDesc',title:'出院病区',width:150,align:'left',sortable:true},
			{field:'IsDeath',title:'死亡标志',width:70,align:'left',sortable:true},
			{field:'DeathDate',title:'死亡日期',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'DeathTime',title:'死亡时间',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'HomeAddress',title:'现住址',width:250,align:'left',sortable:true},
			{field:'Company',title:'工作单位',width:150,align:'left',sortable:true},
			{field:'RelativeName',title:'联系人',width:100,align:'left',sortable:true},
			{field:'RelativeTel',title:'联系人电话',width:150,align:'left',sortable:true},
            {field:'EpisodeIDx',title:'住院标识符',width:150,align:'left',sortable:true},
            {field:'EpisodeID',title:'就诊号',width:150,align:'left',sortable:true}
			
		]],
		onSelect:function(rowIndex,rowData){
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridAdm').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitPatFindWin();
});


//加载多选科室/病区公共方法
function Common_ComboMuLoc(){
	var ItemCode = arguments[0];
	var HospIDs = arguments[1];
	var Alias   = arguments[2];
	var LocCate = arguments[3];
	var LocType = arguments[4];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		//allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospIDs = HospIDs;
			param.aAlias = Alias;
			param.aLocCate = LocCate;
			param.aLocType = LocType;
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	return ;
}
