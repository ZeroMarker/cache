var init = function(){
	var maxWidth=$(window).width()||1366;    //��ȡ��ǰ���
	var maxHeight=$(window).height()||750;   //��ȡ��ǰ�߶�
	$("#panelTop").panel("resize",{width:maxWidth-10})
	var currentDate=getNowFormatDate()
	$("#startDate").datebox('setValue',currentDate);
    $("#endDate").datebox('setValue',currentDate);
	
	var DHCVISFindWarnObj = $HUI.datagrid("#DHCVISFindWarn",{
		
		title:"������Ϣ�б�",
		width:maxWidth-10,
		height:maxHeight-160,
		mode:'remote',
		delay:200,
		idField:'RowId',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISWarnQuery",
			QueryName:"FindWarnInfoByLoc"	
		},
	   columns:[[
			{field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'hospitalName',title:'ҽԺ����',width:160},
			{field:'locId',title:'locId',width:160,hidden:true},
			{field:'locName',title:'��������',width:160},
			{field:'roomName',title:'��������',width:160},
			{field:'wranTime',title:'����ʱ��',width:160},
			{field:'bulidName',title:'¥������',width:160}
			
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			return false;
		}
	
	});
	//ѡ�����
	var LocDescObj = $HUI.combogrid("#LocDesc",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindLocInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'LocName',
		onBeforeLoad:function(param){
			param.Name = param.q;
			
		},
		onShowPanel:function () {
			var LocDesc=LocDescObj.getText();
			$('#LocDesc').combogrid('grid').datagrid('reload',{q: LocDesc});
    	},
		columns:[[
			{field:'RowId',title:'����ID',width:50},
			{field:'LocCode',title:'���Ҵ���',width:130},
			{field:'LocName',title:'��������',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	//��ȡ��ǰ����YYYY-MM-DD
	function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate;
        return currentdate;
    }
	//��ѯ
	$("#Search").click(function(){
		var endDate=$HUI.datebox("#endDate").getValue();
		var startDate=$HUI.datebox("#startDate").getValue();
		var Loc=LocDescObj.getValue();
		var flag=tkMakeServerCall('web.DHCVISWarnQuery','CompareDate',startDate,endDate)
		if(flag!="Y"){
			$.messager.alert("��ʾ��Ϣ",flag);
			return false;
		}
		var queryParams={
			ClassName:"web.DHCVISWarnQuery",
			QueryName:"FindWarnInfoByLoc",
			startDate:startDate,
	    	endDate:endDate,
	    	Loc:Loc
	    
		}
		DHCVISFindWarnObj.load(queryParams);
	
		
		})	
	
};
$(init);