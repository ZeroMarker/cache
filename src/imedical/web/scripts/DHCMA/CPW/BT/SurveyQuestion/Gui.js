//页面Gui
function InitDicEditWin(){
	var obj = new Object();
	obj.SurveyID=""
	obj.QuestionID=""
	obj.OptionID=""
    $.parser.parse(); // 解析整个页面 
    //增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.Survey",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.Survey",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridSurvey.load({
				ClassName:"DHCMA.CPW.BTS.SurveySrv",
				QueryName:"QrySurvey",
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
		$(".combo").css('display','none');
	}
	$('#winSurvey').dialog({
		title: '调查问卷标题',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		onClose:function(){
			obj.SurveyID="";
			obj.gridSurvey.clearSelections();
			$("#btnAddS").linkbutton("enable");
			$("#btnEditS").linkbutton("disable");
			$("#btnDeleteS").linkbutton("disable");
			$("#btnAddQ").linkbutton("disable");
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			$("#btnAddO").linkbutton("disable");
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
			obj.gridOption.loadData([]);
			obj.gridQuestion.loadData([]);
		}
	});
	$('#winQuestion').dialog({
		title: '问卷题目',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		onClose:function(){
			obj.QuestionID=""
			obj.gridQuestion.clearSelections();
			$("#btnAddQ").linkbutton("enable");
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			$("#btnAddO").linkbutton("disable");
			obj.gridOption.loadData([]);
		}
	});
	$('#Qusetion').dialog({
		title: '问卷',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		width:850,
		height:750
	});
	$('#winOption').dialog({
		title: '题目选项',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		onClose:function(){
			obj.OptionID=""
			obj.gridOption.clearSelections();
			$("#btnAddO").linkbutton("enable");
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
		}
	});
	obj.ItemType=$HUI.combobox("#ItemType",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWQuesType&aIsActive=1&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc'
	})
	
	obj.gridSurvey = $HUI.datagrid("#gridSurvey",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		url:$URL,
		nowrap:false,
		fitColumns:true,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.SurveySrv",
			QueryName:"QrySurvey",
			aHospID: $("#cboSSHosp").combobox('getValue')
		},
		columns:[[
			{field:'BTCode',title:'问卷代码',width:'100'},
			{field:'BTTitle',title:'问卷标题',width:'180'}, 
			{field:'BTResume',title:'备注',width:'100'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSurvey_onDbselect(rowData);					
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSurvey_onSelect();	
			}
		},
		onLoadSuccess:function(data){
			$("#btnAddS").linkbutton("enable");
			$("#btnEditS").linkbutton("disable");
			$("#btnDeleteS").linkbutton("disable");
			$("#btnAddQ").linkbutton("disable");
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			$("#btnAddO").linkbutton("disable");
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
			obj.gridOption.loadData([]);
			obj.gridQuestion.loadData([]);
		}
	});
	
	obj.gridQuestion = $HUI.datagrid("#gridQuestion",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		nowrap:false,
		fitColumns:true,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.SurveyQuestionSrv",
			QueryName:"QryQuestion",	
		},
		columns:[[
			{field:'BTItemNo',title:'序号',width:'70'}, 
			{field:'BTItemDesc',title:'题目描述',width:'400'},
			{field:'BTItemTypeDesc',title:'题目类型',width:'100'}, 
			{field:'BTItemScore',title:'分值',width:'70'}, 
			{field:'BTItemResume',title:'备注',width:'100'},
			{field:'BTID',title:"ID",width:'50'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridQuestion_onDbselect(rowData);							
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQuestion_onSelect();
			}
		},
		onLoadSuccess:function(data){
			//$("#btnAddQ").linkbutton("enable");
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			obj.gridOption.loadData([]);
			
		}
	});
	//题目选项
	obj.gridOption = $HUI.datagrid("#gridOption",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		nowrap:false,
		fitColumns:true,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.SurveyOptionSrv",
			QueryName:"QryOption",
			aParRef:obj.QuestionID	
		},
		columns:[[
			{field:'BTOptionNo',title:'序号',width:'100'}, 
			{field:'BTOptionDesc',title:'选项描述',width:'500'},
			{field:'BTOptionScore',title:'分值',width:'70'},
			{field:'BTID',title:"ID",width:'50'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridOption_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOption_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			//$("#btnAddO").linkbutton("enable");
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
		}
	});
	
	InitDicEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


