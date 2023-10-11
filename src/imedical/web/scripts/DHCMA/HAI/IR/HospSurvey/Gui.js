//页面Gui
var obj = new Object();
function InitHospSurveryWin(){
	//初始化医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
			obj.reloadgridAdmLoad();
		}
	});
	//当前(前一天)日期
	var SelectDate = new Date();
	SelectDate.setDate(SelectDate.getDate() - 1);
	var SelectDate=Common_GetDate(SelectDate);
	Common_SetValue('dtDate',SelectDate);
	
	//全院概况
	 obj.gridHospSurvery = $HUI.datagrid("#gridHospSurvery",{
		fit: true,
		//title: "全院概况",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, 	//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, 	//如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//不换行(false为自动换行)
		fitColumns: true,	
		loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [10,20,50,100],
	   	url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.STAS.WelcomeSrv",
			QueryName:"QryHospSurvey",
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aDate:$("#dtDate").datebox('getValue')
	    },
		columns:[[
			{field:'LocDesc',title:'单位',width:150,align:'center' },
			{field:'NewPatCnt',title:'新入院人数',width:120,align:'center', sortable: true,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+1+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'AdmPatCnt',title:'在院人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+2+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'DischPatCnt',title:'出院人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+9+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'DeathPatCnt',title:'死亡人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+10+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'FeverPatCnt',title:'发热人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+3+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'PICCPatCnt',title:'中央血管导管',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+4+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'VAPPatCnt',title:'呼吸机插管',width:100,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+5+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'UCPatCnt',title:'泌尿道插管',width:100,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+6+'\',\''+LocDesc+'\')>'+value+'</a>';
				}},
			{field:'AntPatCnt',title:'抗菌药物使用人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+7+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			},
			{field:'OperPatCnt',title:'手术人数',width:120,align:'center', sortable: true ,
				formatter:function(value,row,index){
					var LocDesc=row.LocDesc;
					if(index==0)LocDesc=""
					return '<a href="#" onclick=obj.OpenPatInfo(\''+8+'\',\''+LocDesc+'\')>'+value+'</a>';
				}
			}
		]]
	});
	//病人基本信息
	obj.gridPatInfo = $HUI.datagrid("#gridPatInfo",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: false, 	//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, 	//如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//换行(false为自动换行)
		//fitColumns: true,	
		loadMsg:'数据加载中...', 
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		
		columns:[[
			{field:'MrNo',title:'病案号',width:90,align:'center',sortable: true },
			{field:'PatName',title:'姓名',width:80,align:'center',sortable: true},
			{field:'Sex',title:'性别',width:60,align:'center',sortable:true,sorter:Sort_int},
			{field:'Age',title:'年龄',width:60,align:'center',sortable:true,sorter:Sort_Age},
			{field:'AdmBed',title:'床位号',width:60,align:'center',sortable: true},
			
			{field:'AdmDiags',title:'入院诊断',width:120,align:'center',sortable: true},
			{field:'ZY',title:'摘要',width:50,align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>摘要</a>';
				}
			},
			{field:'ItemDesc1',title:'描述信息1',width:120,align:'center',sortable: true},
			{field:'ItemDesc2',title:'描述信息2',width:120,align:'center',sortable: true},
			{field:'ItemDesc3',title:'描述信息3',width:120,align:'center',sortable: true},
			{field:'ItemDesc4',title:'描述信息4',width:120,align:'center',sortable: true},
			{field:'ItemDesc5',title:'描述信息5',width:120,align:'center',sortable: true},
			{field:'ItemDesc6',title:'描述信息6',width:120,align:'center',sortable: true},
			{field:'ItemDesc7',title:'描述信息7',width:120,align:'center',sortable: true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitHospSurveryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}