var CureRBCResListDataGrid;
function InitTriageResListEvent(){
	$('#btnTriageResListSearch').bind('click', function(){
		   CureRBCResListDataGridLoad();
    });
    
    $('#btnTriage').bind('click', function(){
		   TriageOnClick();
    });	
}

function InitCureRBCResListDataGrid()
{
	CureRBCResListDataGrid=$('#tabCureRBCResList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DDCTRROWID",
		//pageNumber:0,
		pageSize : 5,
		pageList : [5,10,50,100],
		columns :[[ 
				//{field:'RowCheck',checkbox:true},     
				{field:'DDCTRROWID',title:'',width:35,align:'left',hidden:true},   
				{field:'DDCTRCTLoc',title:'����',width:100,align:'left'},   
				{field:'DDCTRResDesc',title:'��Դ����',width:100,align:'left'},   
				{field:'CureTriageNum',title:'�ѷ�������',width:50,align:'left'
				/*,formatter:function(value,row,index){	
							return '<a href="###" onclick=CureTriageNumClick('+index+');>�ѷ���:'+row.CureTriageNum+"</a>"
						}*/
				},
				{field:'DDCTRLeftCount',title:'ʣ��ɷ�������',width:50,align:'left'},
				{field:'DDCTRCount',title:'���ɷ�������',width:50,align:'left'},
				{field:'DDCTRHistoryRes',title:'�Ƿ���ʷ����',width:50,align:'left'
				,styler: function(value,row,index){
							if (value.indexOf("��")>=0){
								return 'color:#FF6347;';
							}
						}
				}
			 ]] 
	});
	CureRBCResListDataGridLoad();
}
function CureRBCResListDataGridLoad()
{
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
	var queryLoc=$("#ComboLoc").combogrid("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Triage",
		QueryName:"QueryTriageResource",
		'DCARowIDStr':DCARowIdStr,
		'LocRowID':queryLoc,
		'LogLocID':PageAppListAllObj._SELECT_DCARecLOCROWID, //session['LOGON.CTLOCID']
		Pagerows:CureRBCResListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function CureTriageNumClick(index){
	var selected=CureRBCResListDataGrid.datagrid('getRows'); 
	var DDCTRROWID=selected[index].DDCTRROWID;
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
	//var OperateType=$('#OperateType').val();
	var href="dhcdoc.cure.curetriagelist.csp?DCARowId="+DCARowIdStr+"&DDCTRIRowID="+DDCTRROWID;
	var ReturnValue=window.open(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	
}

function InitTriageLoc()
{
	//�����б�
    var DDCTRCTLocListObj=$HUI.combobox("#ComboLoc",{
		valueField:'LocId',   
    	textField:'LocDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryCureLoc&ResultSetType=array",		
	});
};

function TriageOnClick(){
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
	if(DCARowIdStr==""){
		$.messager.alert("����", "��ѡ�����������뵥", 'error')
		return false;	
	}
	var selected=CureRBCResListDataGrid.datagrid('getRows'); 
	var rows = CureRBCResListDataGrid.datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.alert("����", "��ѡ��������Դ", 'error')
		return false;
	}
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].DDCTRROWID);
		}
		var ID=ids.join(',');
		var DCARowIdArr=DCARowIdStr.split("!");
		var err="";
		var success=1;
		for(var j=0;j<DCARowIdArr.length;j++){	
			var oneDCARowId=DCARowIdArr[j];		
			var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
			var PatName="";
			var ArcimDesc="";
			if(CurePatInfo!=""){
				var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
				var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
				var PatName=CurePatInfo.split("^")[2];
				var ArcimDesc=CureInfo.split("^")[0];
			}
			
			//���˷��䣬��Ҫ����ͬ������
			var Para=oneDCARowId+"^"+session['LOGON.USERID'];
			var ObjScope=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Triage",
				MethodName:"CureTriaged",
				'DDCTRResID':ID,
				'Para':Para,
				'Type':'JSON',
			},false);
			var value=ObjScope.result;
			if(value=="0"){
				var obj=window.frames.parent
			}else{
				success=0;
				var err=value
				if (value==100) err="�в���Ϊ��";
				else if(value==101) err="������ԴIDΪ��";
				else if(value==102) err="�����뵥�ѷ���";
				else if(value==103) err="�÷�����Դ��Ա����.";
				else if(value==104) err="�����뵥�ѳ���.";
				else if(value=="-301") err="��������¼ʧ��";
				else if(value=="-300") err="�������뵥״̬ʧ��";
				$.messager.alert('��ʾ',"����ʧ��:"+err);	
			}
		}
		if(err==""){$.messager.show({title:"��ʾ",msg:"�������"});}
		CureRBCResListDataGridLoad();
		CureRBCResListDataGrid.datagrid('unselectAll');
		if(window.frames.parent.CureApplyDataGrid){
			window.frames.parent.RefreshDataGrid();
		}else{
			RefreshDataGrid();	
		}
		
    }
}