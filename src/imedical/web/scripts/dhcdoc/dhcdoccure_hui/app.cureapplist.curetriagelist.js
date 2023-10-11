var appList_triageListObj=(function(){
	var CureTriageListDataGrid;
	function InitCureTriageListEvent(){
		$('#btnTriageListSearch').bind("click",function(){
			CureTriageListDataGridLoad();	
		})
		$('#btnTriageListCancel').bind("click",function(){
			BtnTLCancelClick();	
		})	
		$HUI.checkbox("#CheckCancel",{
			onCheckChange:function(e,value){
				setTimeout("appList_triageListObj.CureTriageListDataGridLoad();",10)
			}
		})
	}

	function InitCureTriageListDataGrid()
	{
		CureTriageListDataGrid=$('#tabCureTriageList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : true,
			autoRowHeight : true,
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize : 10,
			pageList : [5,10,50],
			columns :[[   
				{field:'RowCheck',checkbox:true},
    			{field:'Rowid',title:'',width:1,hidden:true}, 
    			{field:'PatientNo',title:'�ǼǺ�',width:80,align:'left'},   
    			{field:'PatientName',title:'����',width:60,align:'left'},
    			{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left'},
    			{field:'DDCTRCTLoc',title:'����',width:100,align:'left'},  
    			{field:'DDCTRCTPCP',title:'��Դ',width:60,align:'left'},
    			{field:'DDCTRStatus',title:'״̬',width:50,align:'left'},
    			{field:'DDCTRUser',title:'������',width:60,align:'left'},
    			{field:'DDCTRDate',title:'����ʱ��',width:100,align:'left'}
   			 ]]
		});
	}
	function CureTriageListDataGridLoad()
	{
		var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
		var DDCTRIRowID="";
		var CheckCancel="";
		var Check=$("#CheckCancel").prop("checked");
		if (Check){CheckCancel="C"}
		var SessionStr=com_Util.GetSessionStr();
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Triage",
			QueryName:"QueryTriageList",
			'DCARowIDStr':DCARowIdStr,
			'DDCTRIRowID':DDCTRIRowID,
			'Status':CheckCancel,
			SessionStr:SessionStr,
			Pagerows:CureTriageListDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			CureTriageListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			CureTriageListDataGrid.datagrid("clearSelections");
			CureTriageListDataGrid.datagrid("clearChecked");
		})
	}

	function BtnTLCancelClick(){
		var selectrows=""
		var rowobj=$('#tabCureTriageList').datagrid("getSelections")
		var length=rowobj.length
		if (length==0){
			$.messager.alert("��ʾ","��ѡ��һ�������¼.");
			return;
		}
		var success=true;
		for (var i=0;i<length;i++){
			var Rowid=rowobj[i].Rowid
			if (Rowid==""){continue}
			if (("^"+selectrows+"^").indexOf("^"+Rowid+"^")>=0){continue}
			if (selectrows!=""){selectrows=selectrows+"^"+Rowid}else{selectrows=Rowid}
			var PatientName=rowobj[i].PatientName;
			var ArcimDesc=rowobj[i].ArcimDesc;
			var value=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Triage",
				MethodName:"CancelTriaged",
				'DDCTRRowID':Rowid,
				'UserID':session['LOGON.USERID'],
				dataType:"text"
			},false)
			if(value == "0"){
				//$.messager.show({title:"��ʾ",msg:"ȡ���ɹ�"});
			}else{
				if(value=="100")value="����Ϊ��"
				else if(value=="101")value="����Ϊ��"
				else if(value=="102")value=PatientName+",["+ArcimDesc+"]�Ƿ���״̬�Ĳ�����ȡ��"
				else if(value=="103")value=PatientName+",["+ArcimDesc+"]�Ѿ�ԤԼ������ȡ��"
				else if(value=="104")value=PatientName+",["+ArcimDesc+"]ִ�м�¼�Ѿ�ִ�в�����ȡ��"
				else if(value=="-301")value=PatientName+",["+ArcimDesc+"]��������¼ʧ��"
				else if(value=="-300")value=PatientName+",["+ArcimDesc+"]�������뵥״̬ʧ��"
				$.messager.alert("��ʾ","ȡ��ʧ��,"+value);
				success=false;
			}
		}
		if(success){
			$.messager.popover({msg: 'ȡ���ɹ���',type:'success',timeout: 3000})
		}
		CureTriageListDataGridLoad();
		if(ServerObj.LayoutConfig=="1"){
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}
		}
	}
	
	return{
		"InitCureTriageListEvent":InitCureTriageListEvent,
		"InitCureTriageListDataGrid":InitCureTriageListDataGrid,
		"CureTriageListDataGridLoad":CureTriageListDataGridLoad	
	}
})()