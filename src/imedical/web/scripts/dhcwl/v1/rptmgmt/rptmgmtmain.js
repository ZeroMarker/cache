function dataLoaderOfGrp(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=getMRICDCate',
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
function dataLoaderOfDetail(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=GetICDCateDetails&ICDCId='+params.ICDCId,
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
var addParam={
	curAct:"",
	row:""
};
var showDetail=function(inx){
	var data=$('#rptmgmt-datashow').datagrid('getData');
	row=data.rows[inx];
	
	$("#MenuName").val(row.MenuName);
	$("#AuxiliaryMenuName").val(row.AuxiliaryMenuName);		
	$("#RaqName").val(row.RaqName);
	$("#CSPName").val(row.CSPName);
	$("#QueryName").val(row.QueryName);
	$("#Filter").val(row.Filter);
	$("#RowColShow").val(row.RowColShow);
	$("#CellSubgrpMap").val(row.CellSubgrpMap);
	$("#Spec").combobox("setValue",row.Spec);
	$("#HisTableName").combobox("setValue",row.HisTableName);
	$("#KPIName").val(row.KPIName);
	$("#ProgramLogic").val(row.ProgramLogic);
	$("#AdvUser").val(row.AdvUser);
	$("#ProMaintainer").val(row.ProMaintainer);
	$("#DepMaintainer").val(row.DepMaintainer);
	$("#UsedByDep").val(row.UsedByDep);		
	$("#CellSubgrpMap").val(row.CellSubgrpMap);	
	CKEDITOR.instances.idckeditor.setData(row.Demo); 
	
	addParam.curAct="browse";
	//addParam.row=row;
	//$('#rptmgmt-add .dialog-toolbar').eq(0).hide();
	$HUI.dialog("#rptmgmt-add",{
		title:'���',
		iconCls:'icon-w-update'}
	);			
	$('#rptmgmt-add').dialog('open');	

};


var showLink=function(inx){
	var data=$('#rptmgmt-datashow').datagrid('getData');
	row=data.rows[inx];
	/*
	var html=[];
	html.push('<h1 align="center">�������ı�</h1>');
	html.push('<hr>');
	html.push('���ɵĳ������ı�');
	html.push('<hr>');
	
	html.push('<p style="font-size: 15px;text-indent:2em;">');
	html.push("\"javascript:cpm_showWindow('DTHealth-DHCWL-����������.raq','inRaqName="+row.RaqName+"&inCSPName="+row.CSPName+"&inAuxiliaryMenuName="+row.AuxiliaryMenuName+"')\"");
	html.push('</p>');
	html.push('</br>');
	html.push('<p style="font-size: 14px;text-indent:2em;">���Խ����ı����Ƶ���Ǭ�ļ��У���Ϊ�����ӱ��ʽ��ֵ</p>');
	
	html.join('');	
	*/

	
	$HUI.dialog("#rptmgmt-showLinkDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,
			buttons:[{
				text:'�ر�',
				handler:function(){
					$('#rptmgmt-showLinkDlg').dialog('close');
				}
			}]
	});	

	showLinkText="\"javascript:cpm_showWindow('DTHealth-DHCWL-����������.raq','inRaqName="+row.RaqName+"&inCSPName="+row.CSPName+"&inAuxiliaryMenuName="+row.AuxiliaryMenuName+"')\"";
	$("#showLinkText").html(showLinkText);
	$('#rptmgmt-showLinkDlg').dialog('open');	
	
}


var init = function(){
	var outthis=this;
	////////////////////////////////////////////////////////
	///1�����������ҳ��
	///���������datagrid
	var rptmgmtGrid = $HUI.datagrid("#rptmgmt-datashow",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt2",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
			wantreturnval:0,
			searchValue:""
		},
		columns:[[
			{field:'action',title:'����',width:70,align:'center',
				formatter:function(value,row,index){
						//var s = '<a href="javascript:void(0)" data-options="iconCls:\'icon-apply-check\'" style="text-decoration: underline " onclick="showDetail('+index+')"></a> ';
						//var s = '<span class="icon icon-apply-check"  onclick="showDetail('+index+')">&nbsp</span> ';
						var s = "<a href='#' title='��ϸ' class='hisui-tooltip' ><span class='icon icon-apply-check'  onclick='showDetail("+index+")'>&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='�����ı�' class='hisui-tooltip' ><span class='icon icon-paper-link'  onclick='showLink("+index+")'>&nbsp;</span></a>";

						
						return s;
				} 
			},
			{field:'MenuName',title:'�˵�����',width:100,align:'left'},
			{field:'RaqName',title:'raq����',width:100,align:'left'},
			{field:'CSPName',title:'CSP����',width:100,align:'left'},	
			{field:'AuxiliaryMenuName',title:'��ǰҳ��(����)����',width:120,align:'left'},
			{field:'AdvUser',title:'�߼��ͻ�',width:70,align:'left'},
			{field:'ProMaintainer',title:'��Ŀ����ʦ',width:80,align:'left'},
			{field:'DepMaintainer',title:'��������ʦ',width:80,align:'left'},
			{field:'CreateDate',title:'����',width:70,align:'left',hidden:true},
			{field:'UPdateDate',title:'����������',width:100,align:'left'},
			{field:'UsedByDep',title:'ʹ��(����)����',width:100,align:'left'},
			{field:'Demo',title:'��ע',width:100,align:'left',hidden:true},	
			{title:'������query',field:'QueryName',align:'left',hidden:true},
			{title:'ͳ�ƿھ�',field:'Spec',align:'left',hidden:true},
			{title:'ҵ���',field:'HisTableName',align:'left',hidden:true},
			{title:'ָ��',field:'KPIName',align:'left',hidden:true},
			{title:'��������',field:'Filter',align:'left',hidden:true},
			{title:'��ʾ����',field:'RowColShow',align:'left',hidden:true},
			{title:'�߼�˵��',field:'ProgramLogic',align:'left',hidden:true},
			{title:'ID',field:'ID',align:'left',hidden:true},
			{title:'��Ԫ��-ͳ�������Ӧ��ϵ',field:'CellSubgrpMap',align:'left',hidden:true}



	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[1,2,5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select�¼���Ӧ����
		onSelect:function(rowIndex,rowData){

		}
	});
	

	
	
	
	
	///�������ѯ��Ӧ����
	//$('#searchdatashowText').searchbox({
	$('#searchBtn').searchbox({	
		searcher:function(value){
			rptmgmtGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt2",wantreturnval:0,searchValue:value});
		}
	});
	
	
	///�������¼�����
	$('#rptmgmt-datashow').datagrid({
		onSelect:function() {
			$('#btnmainmodify').linkbutton("enable");
		}
	});
	///������Ӧ����
	$("#btnmainadd").click(function (argument) {
		
		$("#MenuName").val("");
		$("#AuxiliaryMenuName").val("");	
		$("#RaqName").val("");
		$("#CSPName").val("");
		$("#QueryName").val("");
		$("#Filter").val("");
		$("#RowColShow").val("");
		$("#CellSubgrpMap").val("");
		$("#Spec").combobox("setValue","");
		$("#HisTableName").combobox("setValue","");
		$("#KPIName").val("");
		$("#ProgramLogic").val("");
		$("#AdvUser").val("");
		$("#ProMaintainer").val("");
		$("#DepMaintainer").val("");
		$("#UsedByDep").val("");	
		CKEDITOR.instances.idckeditor.setData(""); 
		
		addParam.curAct="add";	
		//$('#rptmgmt-add .dialog-toolbar').eq(0).show();
		$HUI.dialog("#rptmgmt-add",{
			title:'����',
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center']			
			
		});

					
		$('#rptmgmt-add').dialog('open');
	});	
	

	///�޸���Ӧ����
	$("#btnmainmodify").click(function (argument) {
		var row =rptmgmtGrid.getSelected();
		if (!row) {
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵ����ݣ�");
			return;
		}
		$("#MenuName").val(row.MenuName);
		$("#AuxiliaryMenuName").val(row.AuxiliaryMenuName);		
		$("#RaqName").val(row.RaqName);
		$("#CSPName").val(row.CSPName);
		$("#QueryName").val(row.QueryName);
		$("#Filter").val(row.Filter);
		$("#RowColShow").val(row.RowColShow);
		$("#CellSubgrpMap").val(row.CellSubgrpMap);
		$("#Spec").val(row.Spec);
		$("#HisTableName").val(row.HisTableName);
		$("#KPIName").val(row.KPIName);
		$("#ProgramLogic").val(row.ProgramLogic);
		$("#AdvUser").val(row.AdvUser);
		$("#ProMaintainer").val(row.ProMaintainer);
		$("#DepMaintainer").val(row.DepMaintainer);
		$("#UsedByDep").val(row.UsedByDep);		
		$("#CellSubgrpMap").val(row.CellSubgrpMap);	
		CKEDITOR.instances.idckeditor.setData(row.Demo); 
		
		addParam.curAct="modify";
		addParam.row=row;
		//$('#rptmgmt-add .dialog-toolbar').eq(0).hide();
		$HUI.dialog("#rptmgmt-add",{
			iconCls:'icon-w-edit',
			title:'�޸�'});			
		$('#rptmgmt-add').dialog('open');
		
		
		
	});


	//var ccObj=$HUI.combo('#CSPName',{});

	///////////////////////////////////////////////////////////
	///�����Ի���ҳ��
	///�����Ի���
	var rptAddDlgObj = $HUI.dialog("#rptmgmt-add",{
		iconCls:'icon-w-add',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		///open������д,��ʼ��ckeditor
		open: function () {
			$(this).find('textarea').ckeditor();
		},
		///close������д,�رնԻ���ʱ����ckeditor
		close: function () {
			$(this).find('textarea').each(function(){
				$(this).ckeditorGet().destroy();
			});
		},			
		toolbar:[{
			iconCls:'icon-add-diag',
			text:'����HIS�˵�����',
			//disabled:true,
			id:'btnLoadHisMenuData',
			handler:function(){
				$('#rptmgmt-add-importHISDataDlg').dialog('open');
				setFieldValue("importHisDataTB","MenuName", "");
				setFieldValue("importHisDataTB","RaqName", "");
				setFieldValue("importHisDataTB","CSPName", "");
				importHISGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"GetMenuCfg",wantreturnval:0,MenuName:"",RaqName:"raq",CSPName:""});
				
			}
			
		},{
			iconCls:'icon-add-note',
			text:'��������˵������',
			//disabled:true,
			id:'btnLoadOtherMgmtData',
			handler:function(){
				
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");				
				
				importOtherObj.open();
				importOtherObj.callBack=importOtherData;		
				importOtherGrid.load();
			}
		}],			
			
		buttons:[{
			id:'btnRptmgmtaddSave',
			text:'����',
			handler:OnSave
		},{
			id:'btnRptmgmtaddClose',
			text:'�ر�',
			handler:function(){
				$('#rptmgmt-add').dialog('close');
			}
		},{
			id:'btnRptmgmtaddConfirm',
			text:'ȷ��',
			handler:function(){
				$('#rptmgmt-add').dialog('close');
			}			
		}],
		onOpen:function(){
			if(addParam.curAct=="modify") {
				$("div#rptmgmt-add input").removeAttr("disabled");
				$("div#rptmgmt-add select").removeAttr("disabled");			
				$('#btnRptmgmtaddSave').show();
				$('#btnRptmgmtaddClose').show();
				$('#btnRptmgmtaddConfirm').hide();
				CKEDITOR.instances.idckeditor.setReadOnly(false);				
				
				
				$('#rptmgmt-add .dialog-toolbar').eq(0).hide();	
			}else if (addParam.curAct=="browse"){
				$("div#rptmgmt-add input").attr("disabled","true");
				$("div#rptmgmt-add select").attr("disabled","true");		
				$('#rptmgmt-add .dialog-toolbar').eq(0).hide();	
				$('#btnRptmgmtaddSave').hide();
				$('#btnRptmgmtaddClose').hide();
				$('#btnRptmgmtaddConfirm').show();
				CKEDITOR.instances.idckeditor.setReadOnly(true);
						
			}else if (addParam.curAct=="add") {
				$('#rptmgmt-add .dialog-toolbar').eq(0).show();	
				$("div#rptmgmt-add input").removeAttr("disabled");
				$("div#rptmgmt-add select").removeAttr("disabled");			
				$('#btnRptmgmtaddSave').show();
				$('#btnRptmgmtaddClose').show();
				$('#btnRptmgmtaddConfirm').hide();
				CKEDITOR.instances.idckeditor.setReadOnly(false);				
			}
		}
	});	
	
	

		
	///����-������Ӧ����
	function OnSave() {
		var ID="";
		var action="addRec";
		if (addParam.curAct=="modify") {
			action="updateRec";
			ID=addParam.row.ID;
		}
		
		var MenuName=$("#MenuName").val();
		var AuxiliaryMenuName=$("#AuxiliaryMenuName").val();
		var RaqName=$("#RaqName").val();
		var CSPName=$("#CSPName").val();
		var QueryName=$("#QueryName").val();
		var Filter=$("#Filter").val();
		var RowColShow=$("#RowColShow").val();
		var CellSubgrpMap=$("#CellSubgrpMap").val();
		var Spec=$("#Spec").combobox("getValue");
		var HisTableName=$("#HisTableName").combobox("getValue");
		var KPIName=$("#KPIName").val();
		var ProgramLogic=$("#ProgramLogic").val();
		var AdvUser=$("#AdvUser").val();
		var ProMaintainer=$("#ProMaintainer").val();
		var DepMaintainer=$("#DepMaintainer").val();
		var UsedByDep=$("#UsedByDep").val();
		var CellSubgrpMap=$("#CellSubgrpMap").val();
		var Demo=CKEDITOR.instances.idckeditor.getData(); 

		var beTestedV=""+MenuName+AuxiliaryMenuName+RaqName+CSPName+QueryName+Filter+RowColShow+CellSubgrpMap+Spec+HisTableName+KPIName+ProgramLogic+AdvUser+ProMaintainer+DepMaintainer+UsedByDep+CellSubgrpMap;
		var pattern=/[$%|\"\']/;
		if(pattern.test(beTestedV)) 
		{
			$.messager.alert("��ʾ","��д�����ݲ��ܰ��������ַ�:$,%,|,\",\'");
			return ;
		}
		if(pattern.test(MenuName)) 
		{
			$.messager.alert("��ʾ","����ֻ���� '��ĸ'��'����'��'-'��'_' ���!");
			return ;
		}			
		if (MenuName=="") {
			$.messager.alert("��ʾ","�˵����Ʋ���Ϊ��");
			return;
		}
		if (QueryName=="") {
			$.messager.alert("��ʾ","query���Ʋ���Ϊ��");
			return;
		}
		if (RaqName=="" && CSPName=="") {
			$.messager.alert("��ʾ","raq���ƻ�csp���Ʋ���ͬʱΪ��");
			return;
		}	
		if (RaqName!="") {
			if (CSPName=="") {
				$.messager.alert("��ʾ","csp���Ʋ���Ϊ��");
				return;
			}				
			if (Filter=="") {
				$.messager.alert("��ʾ","������������Ϊ��");
				return;
			}		
			if (RowColShow=="") {
				$.messager.alert("��ʾ","��ʾ��������Ϊ��");
				return;
			}	
			if (Spec=="") {
				$.messager.alert("��ʾ","ͳ�ƿھ�����Ϊ��");
				return;
			}
			if (HisTableName=="" && KPIName=="") {
				$.messager.alert("��ʾ","ҵ������ƻ�ָ�����Ʋ���ͬʱΪ��");
				return;
			}	

			if (ProgramLogic=="") {
				$.messager.alert("��ʾ","�߼�˵������Ϊ��");
				return;
			}	
		}
		if (AdvUser=="") {
			$.messager.alert("��ʾ","�߼��ͻ�����Ϊ��");
			return;
		}
		if (ProMaintainer=="") {
			$.messager.alert("��ʾ","��Ŀ����ʦ����Ϊ��");
			return;
		}	
		if (DepMaintainer=="") {
			$.messager.alert("��ʾ","��������ʦ����Ϊ��");
			return;
		}	
		if (UsedByDep=="") {
			$.messager.alert("��ʾ","ʹ�ã����ң����Ų���Ϊ��");
			return;
		}			
		if (AuxiliaryMenuName=="") {
			$.messager.alert("��ʾ","��ǰҳ��(����)���Ʋ���Ϊ��");
			return;
		}		
		var data = $.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"AddMgmtRec","ID":ID,"MenuName":MenuName,"RaqName":RaqName,"CSPName":CSPName,"QueryName":QueryName,"AuxiliaryMenuName":AuxiliaryMenuName,"Spec":Spec,"HisTableName":HisTableName,"KPIName":KPIName,"Filter":Filter,"RowColShow":RowColShow,"ProgramLogic":ProgramLogic,"AdvUser":AdvUser,"ProMaintainer":ProMaintainer,"DepMaintainer":DepMaintainer,"Demo":Demo,"UsedByDep":UsedByDep,"CellSubgrpMap":CellSubgrpMap
			},false,function(data){
				if("ok"==data.responseText){
					//detailAddDlgObj.close();
					rptmgmtGrid.load();
					$('#rptmgmt-add').dialog('close');
					
				}else{
					$.messager.alert("��ʾ",data.responseText);
				}
			});	
	}	
	

	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////����HIS�˵�����
	//����HIS�˵����ݽ���grid
	var importHISGrid = $HUI.datagrid("#rptmgmt-add-importHISDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"GetMenuCfg",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
			wantreturnval:0,
			MenuName:"",
			RaqName:"raq",
			CSPName:""
		},
		columns:[[
			{field:'MenuName',title:'�˵�����',width:100,align:'left'},
			{field:'RaqName',title:'�˵����ʽ',width:100,align:'left'},
			{field:'CSPName',title:'CSP����',width:100,align:'left'}			
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select�¼���Ӧ����
		onDblClickRow:function(rowIndex,rowData){
			importHisData();
			$('#rptmgmt-add-importHISDataDlg').dialog('close');
		}
	});	
	//����HIS�˵�����-˫����Ӧ����
	function importHisData() {
		var rowData=importHISGrid.getSelected();
		if (!!rowData)
		{
			$("#MenuName").val(rowData.MenuName);
			$("#RaqName").val(rowData.RaqName);
			$("#CSPName").val(rowData.CSPName);
			$("#AuxiliaryMenuName").val(rowData.CSPName);
		}	
	}
	//����HIS�˵����ݽ���dialog
	var importHISObj = $HUI.dialog("#rptmgmt-add-importHISDataDlg",{
		iconCls:'icon-w-paper',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			text:'ȷ��',
			handler:function(){
				importHisData();
				$('#rptmgmt-add-importHISDataDlg').dialog('close');	
			}
		},{
			text:'ȡ��',
			handler:function(){
				$('#rptmgmt-add-importHISDataDlg').dialog('close');	
			}
		}]
		
	});	
	
	//����HIS�˵�����-��ѯ ��Ӧ����
	$(function(){
		$('#searchHIsMenuText').bind('click', function(){
			var MenuName=getFieldValue("importHisDataTB","MenuName");
			var RaqName=getFieldValue("importHisDataTB","RaqName");
			var CSPName=getFieldValue("importHisDataTB","CSPName");
			importHISGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"GetMenuCfg",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName});
			
		});
	});

	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////��������˵������
	///����HIS�˵����ݽ���grid
	var importOtherGrid = $HUI.datagrid("#rptmgmt-add-importOtherDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
			wantreturnval:0,
			MenuName:"",
			RaqName:"",
			CSPName:""
		},
		columns:[[
			{field:'MenuName',title:'�˵�����',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'��ǰҳ��(����)����',width:100,align:'left'},
			{field:'RaqName',title:'raq����',width:100,align:'left'},
			{field:'CSPName',title:'CSP����',width:100,align:'left'},
			{field:'AdvUser',title:'�߼��ͻ�',width:100,align:'left',hidden:true},
			{field:'Demo',title:'������ע',width:100,align:'left',hidden:true},
			{field:'DepMaintainer',title:'��������ʦ',width:100,align:'left',hidden:true},
			{field:'Filter',title:'��������',width:100,align:'left',hidden:true},
			{field:'HisTableName',title:'ҵ���',width:100,align:'left',hidden:true},
			{field:'KPIName',title:'ָ��',width:100,align:'left',hidden:true},
			{field:'ProMaintainer',title:'��Ŀ����ʦ',width:100,align:'left',hidden:true},
			{field:'ProgramLogic',title:'�߼�˵��',width:100,align:'left',hidden:true},
			{field:'QueryName',title:'Query����',width:100,align:'left',hidden:true},
			{field:'RowColShow',title:'��ʾ����',width:100,align:'left',hidden:true},
			{field:'Spec',title:'ͳ�ƿھ�',width:100,align:'left',hidden:true},
			{field:'UsedByDep',title:'ʹ�ã����ң�����',width:100,align:'left',hidden:true},
			{field:'CellSubgrpMap',title:'��Ԫ��-ͳ�������Ӧ��ϵ',width:100,align:'left',hidden:true}
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select�¼���Ӧ����
		onDblClickRow:function(rowIndex,rowData){
			if (!!importOtherObj.callBack) {
				var rowData=importOtherGrid.getSelected();
				importOtherObj.callBack(rowData);
			};
			$('#rptmgmt-add-importOtherDataDlg').dialog('close');
		}
	});	
	//����HIS�˵�����-˫����Ӧ����
	function importOtherData(rowData) {
		if (!!rowData)
		{
			$("#MenuName").val(rowData.MenuName);
			$("#RaqName").val(rowData.RaqName);
			$("#CSPName").val(rowData.CSPName);
			$("#AuxiliaryMenuName").val(rowData.AuxiliaryMenuName);
			$("#AdvUser").val(rowData.AdvUser);
			$("#DepMaintainer").val(rowData.DepMaintainer);
			$("#Filter").val(rowData.Filter);	
			$("#HisTableName").combobox("setValue",rowData.HisTableName);		
			$("#KPIName").val(rowData.KPIName);
			$("#ProMaintainer").val(rowData.ProMaintainer);
			$("#ProgramLogic").val(rowData.ProgramLogic);
			$("#QueryName").val(rowData.QueryName);
			$("#RowColShow").val(rowData.RowColShow);
			$("#Spec").combobox("setValue",rowData.Spec);
			
			$("#UsedByDep").val(rowData.UsedByDep);
			$("#CellSubgrpMap").val(rowData.CellSubgrpMap);
			CKEDITOR.instances.idckeditor.setData(rowData.Demo); 
		}	
	}
	//�����������ݽ���dialog
	var importOtherObj = $HUI.dialog("#rptmgmt-add-importOtherDataDlg",{
		iconCls:'icon-w-paper',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			text:'ȷ��',
			handler:function(){
				if (!!importOtherObj.callBack) {
					var rowData=importOtherGrid.getSelected();
					importOtherObj.callBack(rowData);
				};
				$('#rptmgmt-add-importOtherDataDlg').dialog('close');	
			}
		},{
			text:'ȡ��',
			handler:function(){
				$('#rptmgmt-add-importOtherDataDlg').dialog('close');	
			}
		}]
		
	});	
	
	//������������˵������-��ѯ ��Ӧ����	
	$(function(){    
		$('#searchOtherDataText').bind('click', function(){
			var MenuName=getFieldValue("importOtherDataTB","MenuName");
			var RaqName=getFieldValue("importOtherDataTB","RaqName");
			var CSPName=getFieldValue("importOtherDataTB","CSPName");
			importOtherGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName});
			
		});
	});	
		
	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////�ȶ�
	//�ȶ�dialog
	var compareObj = $HUI.dialog("#rptmgmt-compareDlg",{
		iconCls:'icon-w-list',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		buttons:[{
			text:'ȷ��',
			handler:function(){
				$('#rptmgmt-compareDlg').dialog('close');	
			}
		}],	
		toolbar:[{
			iconCls:'icon-add-note',
			text:'����˵��1',
			plain:"false",
			handler:function(){	
			
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");			
				importOtherObj.open();
				importOtherObj.callBack=loadCfgToFirst;
			}
		},{
			iconCls:'icon-add-note',
			text:'����˵��2',
			handler:function(){
				
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");				
				importOtherObj.open();
				importOtherObj.callBack=loadCfgToSec;
			}
		}]		
	});	
	
	//��form���Դ���ֵ
	function loadRecord2(formID,rowData) {
		var x;
		for(x in rowData) {
			setFieldValue(formID,x,rowData[x]);
		}		
	}
	
	function clearForm(formID) {
		var selector="div#"+formID+" input";
		$(selector).each(function(){
			if (!$(this).attr("name")) return;
			//alert($(this).attr("name")+":"+$(this).val());
			$(this).val("");
		});		
		
	}	
	
	
	///�ȶ԰�ť��Ӧ����
	$("#btncompare").click(function (argument) {
		
		//�������ҳ����ѡ���˼�¼���Ͱ������¼���ص����ȶ�1���С�
		var row =rptmgmtGrid.getSelected();
		if (!!row) {
			loadRecord2("compare-firstCol",row);
			CKEDITOR.instances.idckeditor1.setData(row.Demo); 		
		}else{
			clearForm("compare-firstCol");
			CKEDITOR.instances.idckeditor1.setData(""); 
		}
		
		
		
		//��ա��ȶ�2��������		
		clearForm("compare-secCol");
		CKEDITOR.instances.idckeditor2.setData(""); 
		
		showDiff();
						
		$('#rptmgmt-compareDlg').dialog('open');
	});	
	
	//��form���Դ���ֵ
	function loadRecord(formID,rowData) {
		var aryFields=["MenuName","AuxiliaryMenuName","RaqName","CSPName","AdvUser","Demo","DepMaintainer","Filter","HisTableName","KPIName","ProMaintainer","ProgramLogic","QueryName","RowColShow","Spec","UsedByDep","CellSubgrpMap"];
		var x;
		for(x in aryFields) {
			setFieldValue(formID,aryFields[x],rowData[aryFields[x]]);
		}		
	}
	//��������1����
	function loadCfgToFirst(rowData) {
		var formID="compare-firstCol";
		loadRecord(formID,rowData);
		CKEDITOR.instances.idckeditor1.setData(rowData.Demo); 
		showDiff();
	}
	//��������2����
	function loadCfgToSec(rowData) {
		var formID="compare-secCol";
		loadRecord(formID,rowData);
		CKEDITOR.instances.idckeditor2.setData(rowData.Demo);
		showDiff();
	}
	//2�����ò�ͬʱ����ʾ��ɫ�߿�	
	function showDiff() {
		var aryFields=["MenuName","AuxiliaryMenuName","RaqName","CSPName","AdvUser","Demo","DepMaintainer","Filter","HisTableName","KPIName","ProMaintainer","ProgramLogic","QueryName","RowColShow","Spec","UsedByDep","CellSubgrpMap"];
		var formID1="compare-firstCol";
		var formID2="compare-secCol";
		var x;
		
		for(x in aryFields) {
			if (getFieldValue(formID1,aryFields[x])!=getFieldValue(formID2,aryFields[x])) {
				addCls4Field(formID2,aryFields[x],"borderred");
			}else{
				removeCls4Field(formID2,aryFields[x],"borderred");
			}
		}
		/*
		if (CKEDITOR.instances.idckeditor1.getData()!=CKEDITOR.instances.idckeditor2.getData()) {
			addCls4Field("cke_idckeditor2","idckeditor2","borderred");
			$("#cke_idckeditor2").addClass("borderred");
		}else{
			$("#cke_idckeditor2").removeClass("borderred");
			
		}	*/	
	
	}
	//ͨ�÷������õ�������
	function getField(formID,fieldName){
		$("div#"+formID+" [name='"+fieldName+"']");
	};
	//ͨ�÷������õ���ֵ
	function getFieldValue(formID,fieldName) {
		return $("div#"+formID+" [name='"+fieldName+"']").val();
	};
	//ͨ�÷��������ñ�ֵ
	function setFieldValue(formID,fieldName,value) {
		$("div#"+formID+" [name='"+fieldName+"']").val(value);		
	};
	//ͨ�÷��������ӱ���ʽ
	function addCls4Field(formID,fieldName,clsName) {
		$("div#"+formID+" [name='"+fieldName+"']").addClass(clsName);
	};
	//ͨ�÷��������߱���ʽ
	function removeCls4Field(formID,fieldName,clsName) {
		$("div#"+formID+" [name='"+fieldName+"']").removeClass(clsName);
	};
	

	//////////////////////////////////////////////////////////////////////////
	/////////����
	////�����Ի���
	var expDataObj = $HUI.dialog("#rptmgmt-expDataDlg",{
		iconCls:'icon-w-export',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			id:"btnExpData",
			text:'����',
			handler:function(){
				var aryRecID=new Array();
				var selExpList=$('#rptmgmt-expDataGrid').datagrid('getSelections');	
				
				if (selExpList.length==0) {
					$.messager.alert("��ʾ","��ѡ����Ҫ����������");
					return;
				}			
				
				
				for(var j=0;j<=selExpList.length-1;j++) {
					aryRecID.push(selExpList[j].ID);
				}		
				var expIDs=aryRecID.join();
			
				var rtn = $.cm({
					ResultSetType:"Excel",
					ExcelName:"excelname", //Ĭ��DHCCExcel
					ClassName:"web.DHCWL.V1.RptMgmt",
					QueryName:"QryExpExcel",
					ExpIDs:expIDs
					},false,
				
				function(json){
						parent.location.href = json.responseText
						//	"dhctt.file.csp?act=download&filename=excelname.csv&dirname=D:\\DtHealth\\app\\dthis\\web\\temp\\excel\\"
						}
						
							
						);
				$('#rptmgmt-expDataDlg').dialog('close');	
			}
		},{
			text:'ȡ��',
			handler:function(){
				$('#rptmgmt-expDataDlg').dialog('close');	
			}
		}]
		
	});		
	///����datagrid
	var expGrid = $HUI.datagrid("#rptmgmt-expDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
			wantreturnval:0,
			MenuName:"",
			RaqName:"",
			CSPName:""
		},
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'MenuName',title:'�˵�����',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'��ǰҳ��(����)����',width:100,align:'left'},
			{field:'RaqName',title:'raq����',width:100,align:'left'},
			{field:'CSPName',title:'CSP����',width:100,align:'left'},
			{field:'ID',title:'ID',width:100,hidden:true}
			
	    ]],
		fit:true,
		fitColumns:true
	});	

	///��ҳ�浼����ť��Ӧ����
	$("#btnexport").click(function () {	
		expGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:"",RaqName:"",CSPName:"",page:1,rows:0});
		//$('#btnExpData').linkbutton("disable");	
						
		setFieldValue("expDataTB","MenuName","");			
		setFieldValue("expDataTB","RaqName","");
		setFieldValue("expDataTB","CSPName","");
						
		$('#rptmgmt-expDataDlg').dialog('open');
	});	
	///����datagrid�¼���Ӧ����
	/*
	$('#rptmgmt-expDataGrid').datagrid({
		onCheck:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			$('#btnExpData').linkbutton("enable");
		},
		onUncheck:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
		},
		onCheckAll:function(){
			
			
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
			else $('#btnExpData').linkbutton("enable");
			
		},
		onUncheckAll:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
		}
	});	*/
	
	//����ҳ���ѯ-��Ӧ����
	$(function(){    
		$('#expDataSearchText').bind('click', function(){
			var MenuName=getFieldValue("expDataTB","MenuName");
			var RaqName=getFieldValue("expDataTB","RaqName");
			var CSPName=getFieldValue("expDataTB","CSPName");
			expGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName,page:1,rows:0});
			
		});
	});		

	
	//////////////////////////////////////////////////////////////////////////
	/////////����
	////����Ի���
	var impExlDataObj=new Array();
	var ImpFieldNames=["MenuName","RaqName","CSPName","QueryName","Spec","HisTableName","KPIName","Filter","RowColShow","ProgramLogic","AdvUser","ProMaintainer","DepMaintainer","Demo","CreateDate","UPdateDate","AuxiliaryMenuName","UsedByDep","RaqCSPName","CellSubgrpMap"];
	var impDataObj = $HUI.dialog("#rptmgmt-impDataDlg",{
		iconCls:'icon-w-imp',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		onClose:function(){
			$("#txtImpFileName").val("");
		}
		,buttons:[{
			id:"btnImpData",
			text:'����',
			handler:impDataFromFile
		},{
			text:'ȡ��',
			handler:function(){
				$('#rptmgmt-impDataDlg').dialog('close');	
			}
		}]
		
	});	
	///����grid
	var impGrid = $HUI.datagrid("#rptmgmt-impDataGrid",{
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'MenuName',title:'�˵�����',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'��ǰҳ��(����)����',width:100,align:'left'},
			{field:'RaqName',title:'raq����',width:100,align:'left'},
			{field:'CSPName',title:'CSP����',width:100,align:'left'},
			{field:'IsExist',title:'CSP����',width:100,align:'left',hidden:true},
			
	    ]],
		fit:true,
		fitColumns:true,
		rowStyler: function(index,row){
			if (row.IsExist==1){
				return 'background-color:#ffe3e3;color:#ff3d2c;'; // return inline style
			}
		}
	});	
	///����grid�¼���Ӧ����
	/*
	$('#rptmgmt-impDataGrid').datagrid({
		onLoadSuccess: function(data){
			if (data.total>0) {
				CheckSameRecs(data);	
			}
		},
		onCheck:function(){
			$('#btnImpData').linkbutton("enable");
		},
		onUncheck:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
		},
		onCheckAll:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
			else $('#btnImpData').linkbutton("enable");
		},
		onUncheckAll:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
		}
	});
	*/
	///�������ļ�¼�ں�̨���в����ڣ����Զ���ѡ��
	function CheckSameRecs(data) {
		var inputList=data.rows;

		for(var i=inputList.length-1;i>=0;i-- ){
			rd=inputList[i];
			if (rd.IsExist==0) {
				$('#rptmgmt-impDataGrid').datagrid('selectRow',i);
			}
		}		
	}
	///������Ӧ����
	$("#btnimport").click(function (argument) {	
		//�������
		setFieldValue("impDataTB","impFileName","");
		$('#rptmgmt-impDataGrid').datagrid('loadData', { total: 0, rows: [] });	
		//$('#btnImpData').linkbutton("disable");	
		
		$('#rptmgmt-impDataDlg').dialog('open');
	});
	
	///���ѡ���ļ�������ļ����ݵ�grid
	$("#impFileName").filebox({
		onChange: function(newVal,oldVal){
			outthis;
			if (newVal=="") return;
			if (newVal==oldVal) return;
			readImpDataFromFile(getFieldValue("impDataTB","impFileName"));
			loadImpGridData();
		}
	});
	
	
	$('#btnImpFileName').bind('click', function(){
		var fileName=$("#txtImpFileName").val();
		if (fileName=="") {
			$.messager.alert("��ʾ","�������ļ�·����");
			return;
		}
		if (false) readImpDataFromFile(fileName);
		else readImpDataFromFileChrome(fileName);
		loadImpGridData();
	});	
	
	function readImpDataFromFileChrome(fileName){
		aryFieldName.length=0;
		impExlDataObj.length=0;
		var recDelive=String.fromCharCode('30');
		var fieldDelive=String.fromCharCode('31');
		var str = "(function test(x){"+
		"var rtn='';"+
		"var recDelive=String.fromCharCode('30');"+
		"var fieldDelive=String.fromCharCode('31');"+
		"var aryFieldNameChrome=new Array();"+
		"var impExlDataObjChrome=new Array();"+
		"var msg='';"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
        "var xlBook = xlApp.Workbooks.Open('"+fileName+"');"+
		"var oSheet = xlBook.ActiveSheet;			"+
		"var rows =oSheet.usedrange.rows.count+1; "+
		"var colCnt =oSheet.usedrange.Columns.Count;"+
		"var fieldNameRowBegin=2;"+
		"var dataRowBegin=4;"+
		"var isValidFile=0;"+
		"for (var colInx = 1; colInx <= colCnt; colInx++) {"+
		"	var fieldName=oSheet.Cells(fieldNameRowBegin,colInx).value;"+
		"	aryFieldNameChrome.push(fieldName);"+
		"	if (fieldName=='MenuName') isValidFile=1;"+
		"}"+
		"if (isValidFile==0) {	"+
		"	oWB.Close();  "+
		"	oXL.Application.Quit();  "+
		"	CollectGarbage();"+
		"	msg='��ȷ���Ƿ�����ȷ�ĵ����ļ���';			"+
		"}else{"+
		"   impExlDataObjChrome.push(aryFieldNameChrome.join(fieldDelive));"+
		"	for (var i = dataRowBegin; i <= rows; i++) {"+
		"		var rec=[];"+
		"		for (var j=1;j<=colCnt;j++) {"+
		"			var cellData=oSheet.Cells(i, j).value;"+
		"			if (cellData==undefined) cellData='';"+
		"			if (oSheet.Cells(i, j).NumberFormatLocal=='yyyy/m/d' || oSheet.Cells(i, j).NumberFormatLocal=='yyyy-m-d') {	"+				
		"				var d = new Date(cellData);"+
		"				cellData=d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() ;"+					
		"			}"+
		"			rec.push(cellData);"+	
		"		}"+
		"		impExlDataObjChrome.push(rec.join(fieldDelive));	"+
		"	} "+
		"}"+
		"rtn=impExlDataObjChrome.join(recDelive);"+
		"return rtn;}());";		
		CmdShell.notReturn = 0;    //�з���ֵ����
		var rtn = CmdShell.EvalJs(str);     //���д����ҵõ�����ֵ		
				
		var aryDataObj=rtn.rtn.split(recDelive);
		if(aryDataObj.length>1)
			aryFieldName=aryDataObj[0].split(fieldDelive);
			
			
			for(var i=1;i<aryDataObj.length;i++){
				var rec={};
				var aryFv=aryDataObj[i].split(fieldDelive);
				for(var x in aryFieldName){
					
					rec[aryFieldName[x]]=aryFv[x];	
				}
				impExlDataObj.push(rec);	
			}
		
	}
		
	///��CSV���ݼ��ص�grid��
	function loadImpGridData() {
		var inputList=new Array();
		var gridData=new Array();
		for(var i=0;i<=impExlDataObj.length-1;i++) {
			var aryRec=[];
			var MenuName=impExlDataObj[i].MenuName;
			var RaqName=impExlDataObj[i].RaqName;
			var CSPName=impExlDataObj[i].CSPName;
			var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
			var rec={};
			rec["MenuName"]=MenuName;
			rec["RaqName"]=RaqName;
			rec["CSPName"]=CSPName;
			rec["AuxiliaryMenuName"]=AuxiliaryMenuName;
			rec["IsExist"]=0;
			inputList.push(rec);
			gridData.push(MenuName);
			gridData.push(RaqName);
			gridData.push(CSPName);
			gridData.push(AuxiliaryMenuName);				
		}
		
		gridData=gridData.join();
		///�ӱ��ж�ȡ���ݣ�Ȼ���ж�Ҫ��������������������Ƿ��ظ�	
		$.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"ImpChk","inputList":gridData,wantreturnval:0
			},false,function(data){
				if("OK"==data.statusText){
					var jsonData=eval('('+data.responseText+')');
					var repDatas=jsonData.root,conKpiCode="";
					var rd,repD="",contFlag=false;

					for(var i=inputList.length-1;i>=0;i-- ){
						contFlag=false;
						rd=inputList[i];
						repD=rd.RaqName+"^"+rd.CSPName+"^"+rd.AuxiliaryMenuName;
						repD=repD.toUpperCase( );
						for(var j=repDatas.length-1;j>-1;j--){
							conKpiCode=repDatas[j].repData;
							if(conKpiCode.toUpperCase( )==repD){
								inputList[i].IsExist=1;	///�������ظ��ġ���grid�л��Ժ�ɫ�߿���ʾ
							}
						} 
					}
					$('#rptmgmt-impDataGrid').datagrid({
						data:inputList
					});
					$('#rptmgmt-impDataGrid').datagrid('load');											
				}else{
					$.messager.alert("��ʾ",data.responseText);
				}
			});	
	

	}

	///��grid��¼д����̨����
	function impDataFromFile() {
		var realInputList=[];
		var selImpList=$('#rptmgmt-impDataGrid').datagrid('getSelections');	
		if (selImpList.length==0) {
			$.messager.alert("��ʾ","��ѡ����Ҫ���������");
			return;
		}
		
		for(var i=0;i<=impExlDataObj.length-1;i++) {
			var RaqName=impExlDataObj[i].RaqName;
			var CSPName=impExlDataObj[i].CSPName;
			var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
			for(var j=0;j<=selImpList.length-1;j++) {
				if (RaqName+"^"+CSPName+"^"+AuxiliaryMenuName==selImpList[j].RaqName+"^"+selImpList[j].CSPName+"^"+selImpList[j].AuxiliaryMenuName) {			
					for(var k=0;k<ImpFieldNames.length;k++) {
						var fieldName=ImpFieldNames[k];
						realInputList.push(impExlDataObj[i][fieldName]);
					}
				}
			}
		}

		$.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"impFromExl","fieldNames":ImpFieldNames.join(),wantreturnval:1,inputList:realInputList.join(String.fromCharCode(2))},false,function(data){
					if("ok"==data.responseText){
						$('#rptmgmt-impDataDlg').dialog('close');
						rptmgmtGrid.load();	
						$.messager.alert("��ʾ","����ɹ���");
					}else{
						$.messager.alert("��ʾ",data.responseText);
					}				
				});
	}
	
	var aryFieldName=new Array();
	///�����ļ����ݵ�����
	function readImpDataFromFile(filePath){
		/*
			var str = "(function test(x){"+
			"var Shell = new ActiveXObject('Shell.Application');"+
			"var Message = '��ѡ���ļ�';"+
			"var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);"+
			"return Folder;}());";
			CmdShell.notReturn = 0;    //�з���ֵ����
			var rtn = CmdShell.EvalJs(str);     //���д����ҵõ�����ֵ
		*/
			var str = "(function test(x){"+
			"var xlApp = new ActiveXObject('Excel.Application');"+
            //http://127.0.0.1/dthealth/med/Results/Template/tpl.xlsx
            //"var xlBook = xlApp.Workbooks.Open('d:\\\\excelname.csv.xls');"+
            "var xlBook = xlApp.Workbooks.Open('"+filePath+"');"+
            "var xlSheet = xlBook.ActiveSheet;"+
            "var rtn = xlSheet.Cells(2,2).Value;"+
            "rtn += '^'+xlSheet.Cells(3,2).Value;"+
            "rtn += '^'+xlSheet.Cells(4,2).Value;"+
            "rtn += '^'+xlSheet.Cells(5,2).Value;"+
            "xlApp.Visible = true;"+
            "xlApp.UserControl = false;"+
            "xlBook.Close(savechanges=false);"+
            "xlApp.Quit();"+
            "xlSheet=null;"+
            "xlBook=null;"+
            "xlApp=null;"+
            "return rtn;}());";
            CmdShell.notReturn = 0;    //�з���ֵ����
			var rtn = CmdShell.EvalJs(str);     //���д����ҵõ�����ֵ 		
		
		
		
		
		
		aryFieldName.length=0;
		impExlDataObj.length=0;
		try {
	 		oXL = new ActiveXObject('Excel.Application');
	 	}catch (e) {
	 		alert("�޷�����Excel!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����");
	 		return false;
	 	}		

        //��ָ��·����excel�ļ�   
		var oWB = oXL.Workbooks.open(filePath); 

		if (!oWB) {
			Ext.Msg.alert("��ʾ","���ļ�������ȷ���Ƿ�����ȷ��excel�ļ���");
			return;
		}
		var strImpData="";
		//������һ��sheet(��һ��ʼ��������)   
		try {
			
			var sheetInx=1;
			oWB.worksheets(sheetInx).select();  
			var oSheet = oWB.ActiveSheet;  
			//ʹ�õ�����   
			var rows =oSheet.usedrange.rows.count+1; 
			//ʹ�õ�����
			var colCnt =oSheet.usedrange.Columns.Count;
			//var clsNameRowbegin=2;
			var fieldNameRowBegin=2;
			var dataRowBegin=4;
			var strDataset="";

			//ȡ�ֶ�����,���ж��Ƿ�����ȷ�ĵ����ļ�
			var isValidFile=0;
			for (var colInx = 1; colInx <= colCnt; colInx++) {
				var fieldName=oSheet.Cells(fieldNameRowBegin,colInx).value;
				aryFieldName.push(fieldName);
				if (fieldName=="MenuName") isValidFile=1;
			}
			if (isValidFile==0) {	
				oWB.Close();  
				//�˳�����excel��ʵ������   
				oXL.Application.Quit();  
				CollectGarbage();
				//Ext.Msg.alert("��ʾ",e);
				$.messager.alert("��ʾ","��ȷ���Ƿ�����ȷ�ĵ����ļ���");
				return ;				
				
			}
			
			
			for (var i = dataRowBegin; i <= rows; i++) {
				var rec={};
				for (var j=1;j<=colCnt;j++) {
					var cellData=oSheet.Cells(i, j).value;
					if (cellData==undefined) cellData="";

					if (oSheet.Cells(i, j).NumberFormatLocal=="yyyy/m/d" || oSheet.Cells(i, j).NumberFormatLocal=="yyyy-m-d") {					
						var d = new Date(cellData);
						cellData=d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() ;						
					}
					
					rec[aryFieldName[j-1]]=cellData;	
				}
				impExlDataObj.push(rec);	
			} 
			
	
		}catch(e) {  
			oWB.Close();  
			//�˳�����excel��ʵ������   
			oXL.Application.Quit();  
			CollectGarbage();
			//Ext.Msg.alert("��ʾ",e);
			$.messager.alert("��ʾ","���ļ�������ȷ���Ƿ�����ȷ�ĵ����ļ���");

		}  

		oWB.Close();  
		//�˳�����excel��ʵ������   
		oXL.Application.Quit();  
		//�ֶ����������ռ���   
		CollectGarbage();         	

    }	

	///���ı��༭�������ù�������
	CKEDITOR.editorConfig = function( config ) {
		config.toolbarGroups = [
			{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
			{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
			{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
			{ name: 'forms', groups: [ 'forms' ] },
			'/',
			{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
			{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
			{ name: 'links', groups: [ 'links' ] },
			{ name: 'insert', groups: [ 'insert' ] },
			'/',
			{ name: 'styles', groups: [ 'styles' ] },
			{ name: 'colors', groups: [ 'colors' ] },
			{ name: 'tools', groups: [ 'tools' ] },
			{ name: 'others', groups: [ 'others' ] },
			{ name: 'about', groups: [ 'about' ] }
		];

		config.removeButtons = 'PasteText,PasteFromWord,Source,Save,NewPage,Preview,Print,Templates,Find,Replace,SelectAll,Scayt,Form,TextField,Textarea,Select,Button,ImageButton,HiddenField,RemoveFormat,Superscript,Subscript,Strike,NumberedList,BulletedList,Outdent,Indent,Blockquote,CreateDiv,BidiRtl,BidiLtr,Link,Unlink,Anchor,Image,Flash,Table,Smiley,HorizontalRule,SpecialChar,PageBreak,Iframe,Language,Styles,Format,Font,FontSize,TextColor,Maximize,About,ShowBlocks,BGColor';
	};

	
    ///���ı��༭����ʼ��
	CKEDITOR.replace( 'idckeditor', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	CKEDITOR.replace( 'idckeditor1', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	CKEDITOR.replace( 'idckeditor2', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	
	
	
};
$(init);

