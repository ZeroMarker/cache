var PageEMRAppListAllObj={
	m_SelectArcimID:"",
	m_CureApplistDataGrid:"",
	CureApplyDataGrid:"",
	m_CureDetailDataGrid:""
}

$(document).ready(function(){	
	Init();
	InitEvent();
	PageHandle();		
	CureApplyDataGridLoad();
});

function Init(){
	InitOrderLoc();
	InitArcimDesc();
	PageEMRAppListAllObj.CureApplyDataGrid=InitCureApplyDataGrid();
	//$("#StartDate").datebox('setValue',ServerObj.PerDate);	
	//$("#EndDate").datebox('setValue',ServerObj.CurrDate);		
}

function InitEvent(){
	$('#btnFind').bind('click', function(){
		CureApplyDataGridLoad();
	});
	
	$('#btnClear').bind('click', function(){
		ClearHandle();
	});
	
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureApplyDataGridLoad();
		}
	});
	$HUI.checkbox("#CancelDis",{
		onCheckChange:function(e,value){
			var cbox=$HUI.checkbox("#CancelDis");
			if (cbox.getValue()){
				$HUI.checkbox("#FinishDis").uncheck();
			}
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})
	$HUI.checkbox("#FinishDis",{
		onCheckChange:function(e,value){
			var cbox=$HUI.checkbox("#FinishDis");
			if (cbox.getValue()){
				$HUI.checkbox("#CancelDis").uncheck();
			}
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})	
	$HUI.checkbox("#LongOrdPriority",{
		onCheckChange:function(e,value){
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})	
}

function PageHandle(){
}

function ClearHandle(){
	$("#ApplyNo").val("");
	$("#StartDate,#EndDate").datebox("setValue","");	
	$("#CancelDis,#FinishDis").checkbox('uncheck');
	PageEMRAppListAllObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');
	$("#ComboOrderLoc").combobox('select','');
}

function InitCureApplyDataGrid()
{
	var fitcolumnval=false;
	var cureApplyColumn=[[ 
		{field:'ApplyNo',title:'���뵥��',width:110,align:'left', resizable: true},  
		{field:'PatNo',title:'�ǼǺ�',width:100,align:'left', resizable: true},   
		{field:'PatName',title:'����',width:60,align:'left', resizable: true},   
		{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true},
		{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true},
		{field:'OrdOtherInfo',title:'ҽ��������Ϣ',width:120,align:'left', resizable: true},
		{field:'OrdQty',title:'����',width:50,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'��λ',width:50,align:'left', resizable: true}, 
		{field:'OrdUnitPrice',title:'����',width:50,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'�ܽ��',width:60,align:'left', resizable: true}, 
		{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80,align:'left', resizable: true
			,formatter:function(value,row,index){
				var NumVal=Number(value);
				if ((NumVal == 0 ||typeof NumVal != 'number' || isNaN(NumVal))) {
					return "<span>"+value+"</span>";
				}else {
					var Type="'Applist'";
					return '<a href="###" id= "'+row["DCARowId"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+value+"</span>"+"</a>"
				}
			}},
		{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80,align:'left', resizable: true},
		{field:'ApplyFinishTimes',title:'�����ƴ���',width:80,align:'left', resizable: true},
		{field:'ApplyNoFinishTimes',title:'δ���ƴ���',width:80,align:'left', resizable: true},
		{field:'OrdBilled',title:'�Ƿ�ɷ�',width:70,align:'left', resizable: true,
			styler: function(value,row,index){
				if (value == "��"){
					return 'background-color:#ffee00;color:red;';
				}
			}
		},
		{field:'OrdReLoc',title:'���տ���',width:80,align:'left', resizable: true},   
		{field:'ServiceGroup',title:'������',width:80,align:'left', resizable: true}, 
		{field: 'ApplyExec', title: '�Ƿ��ԤԼ', width: 80, align: 'left',resizable: true},
		{field:'ApplyStatus',title:'����״̬',width:80,align:'left', resizable: true},
		{field:'ApplyUser',title:'����ҽ��',width:80,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'����ʱ��',width:80,align:'left', resizable: true},
		{field:'ApplyPlan',title:'���Ʒ���',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>"+$g("δ��д")+"</span>";
				}else {
					var Type="'Plan'";
					return '<a href="###" id= "'+row["DCARowId"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+$g("�����鿴")+"</span>"+"</a>"
				}
			}
		},
		{field:'ApplyAssessment',title:'��������',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>"+$g("δ��д")+"</span>";
				}else {
					var Type="'Ass'";
					return '<a href="###" id= "'+row["DCARowId"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+$g("�����鿴")+"</span>"+"</a>"
				}
			}
		},
		{field:'DCRecord',title:'���Ƽ�¼',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>"+$g("δ��д")+"</span>";
				}else {
					var Type="'Record'";
					return '<a href="###" id= "'+row["TIndex"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>"+$g("�����鿴")+"</span>"+"</a>"
				}
			}
		},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
	 ]]
	// ���Ƽ�¼���뵥Grid
	var CureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : fitcolumnval,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns : cureApplyColumn
	});
	return CureApplyDataGrid;
}

function CureApplyDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var ApplyNo=$("#ApplyNo").val()
	var DisCancelFlag="";
	var FinishDisFlag="";
	var CancelDis=$HUI.checkbox("#CancelDis").getValue()
	if (CancelDis){DisCancelFlag="Y"}
	var FinishDis=$HUI.checkbox("#FinishDis").getValue()
	if (FinishDis){FinishDisFlag="Y"}
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageEMRAppListAllObj.m_SelectArcimID="";
	var queryArcim=PageEMRAppListAllObj.m_SelectArcimID;
	var queryOrderLoc=$("#ComboOrderLoc").combobox("getValue");
	queryOrderLoc=CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindEMRCureApplyList",
		'EpisodeID':ServerObj.EpisodeID,
		'PatientID':"",
		'LongOnLoc':"",
		'outCancel':DisCancelFlag,
		'DocApplayNo':ApplyNo,
		'FinishDis':FinishDisFlag,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'queryArcim':queryArcim,
		'queryOrderLoc':queryOrderLoc,
		Pagerows:PageEMRAppListAllObj.CureApplyDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageEMRAppListAllObj.CureApplyDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		PageEMRAppListAllObj.CureApplyDataGrid.datagrid("clearSelections");
		PageEMRAppListAllObj.CureApplyDataGrid.datagrid("clearChecked");	
	})
}

function OpenApplyDetailDiag()
{
	var DCARowId=GetSelectRow();
	if(DCARowId=""){
		return;	
	}
	var href="doccure.apply.hui.csp?DCARowId="+DCARowId;
    websys_showModal({
		url:href,
		iconCls:"icon-w-paper",
		title:$g('���뵥���'),
		width:"1200px",height:"600px",
		//onBeforeClose:function(){CureApplyDataGridLoad();},
		CureApplyDataGridLoad:CureApplyDataGridLoad
	});
}

function InitArcimDesc()
{
	$("#ComboArcim").lookup({
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'ArcimRowID',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'����',width:320,sortable:true},
			{field:'ArcimRowID',title:'ID',width:100,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:420,
        panelHeight:260,
        isCombo:true,
        minQueryLen:1,
        rownumbers:true,
		fit: true,
		pageSize: 5,
		pageList: [5],
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: "DHCDoc.DHCDocCure.Apply",QueryName: 'FindAllItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var CureItemFlag="on"
			param = $.extend(param,{'Alias':desc,'CureItemFlag':CureItemFlag,'SubCategory':""});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['ArcimRowID'];
			PageEMRAppListAllObj.m_SelectArcimID=ID;
			$HUI.lookup("#ComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboArcim").getText();
            if((gtext=="")){
	        	PageEMRAppListAllObj.m_SelectArcimID="";    
	        }
		}
    });  
};
function InitOrderLoc(){
	com_withLocDocFun.InitComboLoc("ComboOrderLoc");
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if (id=="ComboOrderLoc"){
			var CombValue=Data[i].LocRowID;
			var CombDesc=Data[i].LocDesc;
		}else if(id=="RESSessionType"){
			var CombValue=Data[i].ID  
			var CombDesc=Data[i].Desc
		}else{
			var CombValue=Data[i].value  
			var CombDesc=Data[i].desc
		}
		if(selId==CombValue){
			selId=CombValue;
			Find=1;
			break;
		}
	}
	if (Find=="1") return selId
	return "";
}

function ShowCureDetail(Type,RowID){
	if(Type=="Record"){
		ShowCureRecordDetail(RowID);
		return;
	}else if(Type=="Ass"){
		ShowCureAssListDetail(RowID);
		return;
	}else if(Type=="Applist"){
		ShowCureApplistDetail(RowID);
		return;
	}else{
		var title=$g("���Ʒ���");	
	}
	var content=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"GetCurePlanAndAss",
		Type:Type,
		DCARowId:RowID,
		dataType:"text"
	},false)
	if(content==""){
		content=$g("��������");
	}else{
		content=content.replace(/\\n/g,"<br/>");
		content=content.replace(/\\r/g,"<br/>");
	}
	content="<div style='height:100%;width:100%;padding:10px'><div class='hisui-panel panel-header-gray' data-options='border:true,fit:true'>"+content+"</div></div>";
	websys_showModal({
		content:content,
		title:$g(title),
		iconCls:'icon-w-paper',
		width:'60%',height:'60%'
	});
	/*	
	var dhwid=($(document.body).width()-800)/2;
	var dhhei=($(document.body).height()-500)/2;
	content="<div style='float:left;'>"+content+"</div>";
	$("#detail-panel").append(content)
	$('#detail-dialog').window({
		title:title,
		iconCls:"icon-w-paper",
		onClose:function(){$("#detail-panel").empty()}
	})
	$('#detail-dialog').window('open').window('resize',{width:800,height:500,top: dhhei,left:dhwid});
	*/
}

function GetSelectRow(){
	var rows = PageEMRAppListAllObj.CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ�����뵥!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("����","��ѡ���˶�����뵥!","warning")
     	return "";
     }
	var DCARowId=rows[0].DCARowId;
	if(DCARowId=="")
	{
		$.messager.alert('��ʾ','��ѡ��һ�����뵥',"warning");
		return "";
	}	
	return DCARowId;
}

function ShowCureAssListDetail(id){
	var OperateType="";
	var href="doccure.cureassessmentlist.csp?OperateType="+OperateType+"&DCARowIdStr="+id+"&PageShowFromWay="+ServerObj.PageShowFromWay;
    websys_showModal({
		url:href,
		iconCls:'icon-w-list',
		title:$g('��������'),
		width:'90%',height:'80%'
	});
}

function ShowCureRecordDetail(id){
	var href="doccure.workreport.execview.hui.csp?OperateType=&DCARowId="+id+"&PageShowFromWay="+ServerObj.PageShowFromWay;
    websys_showModal({
		url:href,
		title:$g('���Ƽ�¼��ϸ'),
		iconCls:'icon-w-list',
		width:'90%',height:'80%'
	});
}

function ShowCureApplistDetail(id){
	var dhwid=$(document.body).width()-50;
	var dhhei=$(document.body).height()-200;
	$('#applist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:20});
	var CureApplistDataGrid=$('#tabCureApplist').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.Appointment&QueryName=FindAppointmentListHUI&QueryState=&Type=&DCARowId="+id,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"Rowid",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[     
				{field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
				{field:'PatientNo',title:'�ǼǺ�',width:100,align:'left'},   
				{field:'PatientName',title:'����',width:80,align:'left'},  
				{field:'ArcimDesc',title:'������Ŀ',width:150,align:'left'},
				{field: 'DDCRSDate', title:'����', width: 100, align: 'left', sortable: true, resizable: true},
				{field:'DCASeqNo',title:'�Ŷ����',width:80,align:'left'},
				{field: 'LocDesc', title:'����', width: 150, align: 'left', sortable: true, resizable: true},
				{field: 'ResourceDesc', title: '��Դ', width: 100, align: 'left', resizable: true},
				{field: 'TimeDesc', title: 'ʱ��', width: 100, align: 'left', resizable: true},
				{field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true},
				{field: 'EndTime', title: '����ʱ��', width: 80, align: 'left',resizable: true},
				{field: 'ServiceGroupDesc', title: '������', width: 80, align: 'left',resizable: true},
				{field: 'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',resizable: true},
				{field: 'DCAAStatus', title: 'ԤԼ״̬', width: 80, align: 'left',resizable: true},
				{field: 'ReqUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true},
				{field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 120, align: 'left',resizable: true},
				{field: 'LastUpdateUser', title: '������', width: 80, align: 'left',resizable: true},
				{field: 'LastUpdateDate', title: '����ʱ��', width: 120, align: 'left',resizable: true}   
		]],
		onBeforeLoad:function(row,param){
			$(this).datagrid("clearChecked").datagrid("clearSelections");
		}
	});
	return CureApplistDataGrid;
}
