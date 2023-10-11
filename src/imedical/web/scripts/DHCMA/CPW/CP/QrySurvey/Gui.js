//页面Gui
function InitQrySurveyWin(){
	var obj = new Object();		
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",session['DHCMA.HOSPID'],"");
	
    //科室
	obj.cboLoc = $HUI.combobox("#cboLoc",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aAdmType="I",
			param.aType="E",
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});
	
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));// 日期初始赋值
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));
	
   obj.GridQrySurvey = $HUI.datagrid("#GridQrySurvey",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'Title',title:'问卷名',width:'180'},
			{field:'MrNo',title:'病案号',width:'80'},
			{field:'PatName',title:'姓名',width:'80'},
			{field:'PatSex',title:'性别',width:'50'},
			//{field:'PatAge',title:'年龄',width:'50'},
			{field:'AdmLocDesc',title:'就诊科室',width:'100'},
			{field:'TotalScore',title:'问卷得分',width:'80'},
			{field:'CPWDesc',title:'路径名称',width:'150'}, 
			{field:'CPWStatus',title:'状态',width:'50'},
			{field:'InUserDesc',title:'入径人',width:'80'},
			{field:'InLocDesc',title:'入径科室',width:'100'}, 
			{field:'InDtime',title:'入径日期',width:'180'}, 
			{field:'OutDtime',title:'出径日期',width:'180'},
			{field:'link',title:'住院病历',width:'120',align:'center',sortable:true,
				formatter: function(value,row,index){
						var paadm=row.EpisodeID.split('!!')[0];
						var patientID=row.PatientID;
						return '<a href="#" onclick=DisplayEPRView('+paadm+","+patientID+')>病历浏览</a>';
				}			
			
			},
			{field:'AdmDate',title:'入院日期',width:'100'},
			{field:'DischDate',title:'出院日期',width:'100'}, 
			{field:'LocDesc',title:'问卷操作科室',width:'100'}, 
			{field:'UserDesc',title:'问卷操作人',width:'130'}, 
			{field:'ActDTime',title:'问卷操作时间',width:'180'}
			
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.GridQrySurvey_onDblClick(rowIndex,rowData);
			}
		},
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#center .hisui-panel").attr("style","border-color:#E2E2E2;border-top:0;border-radius:0 0 4px 4px;")
				}
			}
		}
	});
	DisplayEPRView = function(EpisodeID,PatientID){
		var strUrl = cspUrl+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&2=2";
			 websys_showModal({
				url:strUrl,
				title:'浏览病历',
				iconCls:'icon-w-edit', 
				originWindow:window,
				width:1300,
				height:600
			});
	};
	
	InitCheckQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


