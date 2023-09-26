var PageEMRAppListAllObj={
	m_SelectArcimID:"",
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
	$("#StartDate").datebox('setValue',ServerObj.PerDate);	
	$("#EndDate").datebox('setValue',ServerObj.CurrDate);		
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
		{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
		{field:'PatNo',title:'登记号',width:100,align:'left', resizable: true},   
		{field:'PatName',title:'姓名',width:60,align:'left', resizable: true
		},   
		{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
		{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
		{field:'OrdOtherInfo',title:'医嘱其他信息',width:120,align:'left', resizable: true},
		{field:'OrdQty',title:'数量',width:50,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'单位',width:50,align:'left', resizable: true}, 
		{field:'OrdUnitPrice',title:'单价',width:50,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
		{field:'ApplyAppedTimes',title:'已预约次数',width:80,align:'left', resizable: true},
		{field:'ApplyNoAppTimes',title:'未预约次数',width:80,align:'left', resizable: true},
		{field:'ApplyFinishTimes',title:'已治疗次数',width:80,align:'left', resizable: true},
		{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80,align:'left', resizable: true},
		{field:'OrdBilled',title:'是否缴费',width:70,align:'left', resizable: true,
			styler: function(value,row,index){
				if (value == "否"){
					return 'background-color:#ffee00;color:red;';
				}
			}
		},
		{field:'OrdReLoc',title:'接收科室',width:80,align:'left', resizable: true},   
		{field:'ServiceGroup',title:'服务组',width:80,align:'left', resizable: true}, 
		{field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
		{field:'ApplyUser',title:'申请医生',width:80,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'申请时间',width:80,align:'left', resizable: true},
		{field:'ApplyPlan',title:'治疗方案',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>未填写</span>";
				}else {
					var Type="'Plan'";
					return '<a href="###" id= "'+row["DCARowId"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>单击查看</span>"+"</a>"
				}
			}
		},
		{field:'ApplyAssessment',title:'治疗评估',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>未填写</span>";
				}else {
					var Type="'Ass'";
					return '<a href="###" id= "'+row["DCARowId"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>单击查看</span>"+"</a>"
				}
			}
		},
		{field:'DCRecord',title:'治疗记录',width:80,align:'left',
			formatter:function(value,row,index){
				if (value == "") {
					return "<span class='fillspan'>未填写</span>";
				}else {
					var Type="'Record'";
					return '<a href="###" id= "'+row["TIndex"]+'"'+' onclick=ShowCureDetail('+Type+','+row.DCARowId+');>'+"<span class='fillspan-nosave'>单击查看</span>"+"</a>"
				}
			}
		},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
	 ]]
	// 治疗记录申请单Grid
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
		loadMsg : '加载中..',  
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
		title:'申请单浏览',
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
            {field:'ArcimDesc',title:'名称',width:320,sortable:true},
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
	$HUI.combobox("#ComboOrderLoc", {})
    $.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		'Loc':"",
		'CureFlag':"",
		'Hospital':session['LOGON.HOSPID'],
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboOrderLoc", {
				valueField: 'LocRowID',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
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
	var content=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"GetCurePlanAndAss",
		Type:Type,
		DCARowId:RowID,
		dataType:"text"
	},false)
	if(Type=="Plan"){
		var title="治疗方案";	
	}else if(Type=="Record"){
		ShowCureRecordDetail(RowID);
		return;
	}else{
		var title="治疗评估";		
	}
	if(content==""){
		content="暂无内容";
	}else{
		content=content.replace(/\\n/g,"<br/>");
		content=content.replace(/\\r/g,"<br/>");
	}
	var dhwid=($(document.body).width()-800)/2;
	var dhhei=($(document.body).height()-500)/2;
	content="<div style='float:left;'>"+content+"</div>";
	$("#detail-panel").append(content)
	$('#detail-dialog').window({
		title:title,
		onClose:function(){$("#detail-panel").empty()}
	})
	$('#detail-dialog').window('open').window('resize',{width:800,height:500,top: dhhei,left:dhwid});
}

function GetSelectRow(){
	var rows = PageEMRAppListAllObj.CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一个申请单!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("错误","您选择了多个申请单!","warning")
     	return "";
     }
	var DCARowId=rows[0].DCARowId;
	if(DCARowId=="")
	{
		$.messager.alert('提示','请选择一条申请单',"warning");
		return "";
	}	
	return DCARowId;
}

function ShowCureRecordDetail(id){
	var dhwid=$(document.body).width()-200;
	var dhhei=$(document.body).height()-200;
	$('#add-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:100});
	var CureDetailDataGrid=$('#tabCureDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:false,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:false,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEORERowID",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
        			{field:'DCARowId',title:'',width:1,hidden:true}, 
        			//{field:'PapmiNo',title:'登记号',width:100},   
        			//{field:'PatientName',title:'姓名',width:80},
        			{field:'ArcimDesc',title:'治疗项目',width:250,align:'left'},  
        			//{field:'OEOREExStDate',title:'要求执行时间',width:130,align:'left'},
        			{field:'DCRContent',title:'治疗记录',width:300,align:'left'} ,
        			{field:'OEOREQty',title:'执行数量',width:80,align:'left'} ,
        			{field:'OEOREStatus',title:'执行状态',width:100,align:'left'},
        			{field:'DCRCureDate',title:'治疗时间',width:100,align:'left'} ,
        			{field:'DCRResponse',title:'治疗反应',width:200,align:'left'} ,
        			{field:'DCREffect',title:'治疗效果',width:200,align:'left'} ,
        			{field:'OEOREUpUser',title:'执行人',width:100,align:'left'},
        			{field:'OEOREExDate',title:'操作时间',width:130,align:'left'} ,
        			{field:'OEOREType',title:'医嘱类型',width:100,align:'left'} ,
        			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}  
			 ]]
	});
	PageEMRAppListAllObj.m_CureDetailDataGrid=CureDetailDataGrid;
	CureDetailDataGridLoad(id);
	return CureDetailDataGrid	
}

function CureDetailDataGridLoad(id)
{
	var CheckOnlyNoExcute="";
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		QueryName:"FindCureExecList",
		'DCARowId':id,
		'OnlyNoExcute':CheckOnlyNoExcute,
		'OnlyExcute':"Y",
		Pagerows:PageEMRAppListAllObj.m_CureDetailDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageEMRAppListAllObj.m_CureDetailDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	PageEMRAppListAllObj.m_CureDetailDataGrid.datagrid("clearChecked");
	PageEMRAppListAllObj.m_CureDetailDataGrid.datagrid("clearSelections");
}