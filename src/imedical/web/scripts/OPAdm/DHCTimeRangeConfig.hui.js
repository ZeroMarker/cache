var PageLogicObj={
	m_DHCTimeRangeConfigListDataGrid:"",
	m_ReHospitalDataGrid:"",
	dw:$(window).width()-150,
	dh:$(window).height()-100,
	ReportTID:""
};
$(function(){
	var hospComp = GenUserHospComp();
	//ҳ�����ݳ�ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	hospComp.jdata.options.onSelect = function(e,t){
		//���س���ʱ���б�����
		DHCTimeRangeConfigListDataGridLoad();
		InitSortType();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//���س���ʱ���б�����
		DHCTimeRangeConfigListDataGridLoad();
		InitSortType();
	}
	InitCache();
	InitPopover();
});
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent(){
	var myobj=websys_$('TRStartTime');
	if (myobj) myobj.onchange=CheckTRStartTime;

	var myobj=websys_$('TRCancelTime');
	if (myobj) myobj.onchange=CheckTRCancelTime;

	var myobj=websys_$('TREndTime');
	if (myobj) myobj.onchange=CheckTREndTime;

	var myobj=websys_$('TRReturnTime');  
	if (myobj) myobj.onchange=CheckTRReturnTime;
	
	var myobj=websys_$('TRRegSTTime');
	if (myobj) myobj.onchange=CheckTRRegSTTime;

	var myobj=websys_$('TRRegEndTime');  
	if (myobj) myobj.onchange=CheckTRRegEndTime;

	$("#BtnSearch").click(DHCTimeRangeConfigListDataGridLoad);
	$("#BtnClear").click(ClearClickHander);
	$("#BtnAdd").click(AddClickHandle);
	$("#BtnUpdate").click(UpdateClickHandle);
	$("#ReportTimeClick").click(ReportTimeClickHandle);
	$("#SaveConfig").click(SaveConfigClick);
}
function Init(){
	PageLogicObj.m_DHCTimeRangeConfigListDataGrid=InitDHCTimeRangeConfigListDataGrid();
}
function InitDHCTimeRangeConfigListDataGrid(){
	var Columns=[[ 
		{field:'TID',hidden:true,title:''},
		{field:'TTRCode',title:'����',width:40,align:'center'},
		{field:'TTRDesc',title:'����',width:60,align:'center'},
		{field:'TTRStartTime',title:'���￪ʼʱ��',width:100,align:'center'},
		{field:'TTREndTime',title:'�������ʱ��',width:100,align:'center'},
		{field:'TTRReturnTime',title:'ԤԼ�Żع�ʱ���',width:125,align:'center'},
		{field:'TTRCancelTime',title:'�˺�ʱ���',width:90,align:'center'},
		{field:'TTRValidStartDate',title:'��Ч��ʼ����',width:100,align:'center',formatter:function(value,row,index){
			if(value!=""){
				return tkMakeServerCall("websys.Conversions","DateLogicalToHtml",value);	
			}
		}},
		{field:'TRValidEndDate',title:'��Ч��ֹ����',width:100,align:'center',formatter:function(value,row,index){
			if(value!=""){
				return tkMakeServerCall("websys.Conversions","DateLogicalToHtml",value);	
			}
		}},
		{field:'TTRRegSTTime',title:'�Һſ�ʼʱ��',width:100,align:'center'},
		{field:'TTRRegEndTime',title:'�ҺŽ���ʱ��',width:100,align:'center'},
		{field:'TRAllowSpaceReturnDay',title:'��������պ��˺�����',width:150,align:'center'},
		{field:'TRCheckin',title:'��Ҫ����',width:60,align:'center'},
    ]]
	var DHCTimeRangeConfigListDataGrid=$("#DHCTimeRangeConfigList").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true, 
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TID',
		toolbar:[{
			text: '��ȨҽԺ',
	        iconCls: 'icon-house',
	        handler:ReHospitalHandle
		},{
			text: '����ʱ������',
	        iconCls: 'icon-write-order',
	        handler:ReportTimeHandle
		},"-",{
	        text: '����',
	        iconCls: 'icon-sort',
	        handler: function() { SortBtn("User.DHCTimeRange");}
   		 },{
	        text: '���򷽰�ѡ��',
	        iconCls: 'icon-filter',
	        handler: function() { 
	        	SetDefConfig("TimeRangeSort","TimeRangeSort")
				$("#TimeRange-dialog").dialog("open")
	        }
   		 }/*,{
	        text: '����',
	        iconCls: 'icon-translate-word',
	        handler: function() { 
	        	var SelectedRow = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
				if (!SelectedRow){
					$.messager.alert("��ʾ","��ѡ����Ҫ�������!","info");
					return false;
				}
				CreatTranLate("User.DHCTimeRange","TRDesc",SelectedRow["TTRDesc"])
	        }
   		 }*/
   		 ],
		columns :Columns,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearClickHander();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return DHCTimeRangeConfigListDataGrid;
}
function DHCTimeRangeConfigListDataGridLoad(){
	var selrow=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if (selrow){
		var oldIndex=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getRowIndex',selrow);
		PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('unselectRow',oldIndex);
	}
	$.q({
	    ClassName : "web.DHCBL.CARD.DHCTimeRange",
	    QueryName : "QueryTimeRange",
	    TRCode:$("#TRCode").val(),
	    TRDesc:$("#TRDesc").val(),
	    HospID:$HUI.combogrid('#_HospUserList').getValue(),
	    Pagerows:PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('loadData',GridData);
	}); 
}
function ClearClickHander(){
	$("#ID,#TRCode,#TRDesc,#TRCancelTime,#TRStartTime,#TREndTime,#TRReturnTime,#TRRegSTTime,#TRRegEndTime,#AllowSpaceReturnDay").val("");
	$("#TRValidStartDate,#TRValidEndDate").datebox('setValue',"");
	$("#Checkin").checkbox("setValue",false);
	var selrow=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if (selrow){
		var oldIndex=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getRowIndex',selrow);
		PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('unselectRow',oldIndex);
	}
}

function AddClickHandle(){
	var rtn=CheckNull();
    if (!rtn){
	    return false;
    } 

	//�������˽�������
	var ParseInfo="TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRRegSTTime^TRRegEndTime^AllowSpaceReturnDay";
	var DHCTimeRange=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
	//alert(DHCTimeRange);
	
	var TRValidStartDate=$HUI.datebox("#TRValidStartDate").getValue();
	var TRValidEndDate=$HUI.datebox("#TRValidEndDate").getValue();
	var TRCheckin="N"
	if ($("#Checkin").checkbox("getValue")) TRCheckin="Y"
	var DHCTimeRange=DHCTimeRange.split("</TransContent>")[0]+"<TRValidStartDate>"+TRValidStartDate+"</TRValidStartDate>"+"<TRValidEndDate>"+TRValidEndDate+"</TRValidEndDate>"
	
	var DHCTimeRange=DHCTimeRange+"<TRCheckin>"+TRCheckin+"</TRCheckin>"+"</TransContent>"
	
	$.cm({
		ClassName:"web.DHCBL.CARD.DHCTimeRangeBuilder",
		MethodName:"DHCTimeRangeInsert",
		dataType:"text",
		DHCTimeRangeInfo:DHCTimeRange,
		HospID:$HUI.combogrid('#_HospUserList').getValue()
	},function(rtn){
		if(rtn=='10'){
			$.messager.alert("��ʾ","����ʧ��!����������Ѿ�����!","info",function(){
				$("#TRCode").focus();
			}); 
		}else if(rtn!='-100' && rtn!='10'){
			$.messager.popover({msg: '�����ɹ�!',type:'success',timeout: 1000});
			DHCTimeRangeConfigListDataGridLoad()
		}else{
		  	$.messager.alert("��ʾ","����ʧ��!")
		}
	});
}

function UpdateClickHandle(){
	var SelectedRow = PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ����Ҫ�������ݵ���!","info");
		return false;
	}
	var rtn=CheckNull();
    if (!rtn){
	    return false;
    }

	//�������˽�������
	var ParseInfo="TransContent^ID^TRCancelTime^TRCode^TRDesc^TREndTime^TRReturnTime^TRStartTime^TRRegSTTime^TRRegEndTime^AllowSpaceReturnDay";
	var DHCTimeRange=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
	//alert(DHCTimeRange);
	
	var TRValidStartDate=$HUI.datebox("#TRValidStartDate").getValue();
	var TRValidEndDate=$HUI.datebox("#TRValidEndDate").getValue();
	var TRCheckin="N"
	if ($("#Checkin").checkbox("getValue")) TRCheckin="Y"
	var DHCTimeRange=DHCTimeRange.split("</TransContent>")[0]+"<TRValidStartDate>"+TRValidStartDate+"</TRValidStartDate>"+"<TRValidEndDate>"+TRValidEndDate+"</TRValidEndDate>"
	var DHCTimeRange=DHCTimeRange+"<TRCheckin>"+TRCheckin+"</TRCheckin>"+"</TransContent>"
	
	$.cm({
		ClassName:"web.DHCBL.CARD.DHCTimeRangeBuilder",
		MethodName:"DHCTimeRangeUpdate",
		dataType:"text",
		DHCTimeRangeInfo:DHCTimeRange,
	},function(rtn){
		if ((rtn=='-100')||(rtn=="0")){
			$.messager.popover({msg: '���³ɹ�!',type:'success',timeout: 1000});
			ClearClickHander()
			DHCTimeRangeConfigListDataGridLoad()
		}else if(rtn=='10'){
			$.messager.alert("��ʾ","����ʧ��!����������ظ�!");
		}else{
		  	$.messager.alert("��ʾ","����ʧ��!")
	  	}
	});
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function SetSelRowData(row){
	$("#ID").val(row["TID"]);
	$("#TRCode").val(row["TTRCode"]);
	$("#TRDesc").val(row["TTRDesc"]);
	$("#TRCancelTime").val(row["TTRCancelTime"]);
	$("#TRStartTime").val(row["TTRStartTime"]);
	$("#TREndTime").val(row["TTREndTime"]);
	$("#TRReturnTime").val(row["TTRReturnTime"]);
	$("#TRRegSTTime").val(row["TTRRegSTTime"]);
	$("#TRRegEndTime").val(row["TTRRegEndTime"]);
	$("#AllowSpaceReturnDay").val(row["TRAllowSpaceReturnDay"]);
	var ValidStartDate=row["TTRValidStartDate"]
	if (ValidStartDate!="") var ValidStartDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",ValidStartDate);
	var ValidEndDate=row["TRValidEndDate"]
	if (ValidEndDate!="") var ValidEndDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",ValidEndDate);
	$HUI.datebox("#TRValidStartDate").setValue(ValidStartDate);
	$HUI.datebox("#TRValidEndDate").setValue(ValidEndDate);	
	$("#Checkin").checkbox("setValue",(row["TRCheckin"]=="Y")?true:false)
}

//��֤�����ֶ�
function CheckNull()
{
	if ($("#TRCode").val()=="")
	{
		$.messager.alert("��ʾ","�����������!");
		$("#TRCode").focus();
		return false;
	}	

	if ($("#TRDesc").val()=="")
	{
		$.messager.alert("��ʾ","���Ʊ�������!");
		$("#TRDesc").focus();
		return false;
	}	

	if ($("#TRCancelTime").val()=="")
	{
		$.messager.alert("��ʾ","�˺�ʱ��㲻��Ϊ��!");
		$("#TRCancelTime").focus();
		return false;
	}	

	if ($("#TRReturnTime").val()=="")
	{
		$.messager.alert("��ʾ","ԤԼ�Żع�ʱ��㲻��Ϊ��!");
		$("#TRReturnTime").focus();
		return false;
	}	

	if ($("#TRStartTime").val()=="")
	{
		$.messager.alert("��ʾ","���￪ʼʱ�䲻��Ϊ��!");
		$("#TRStartTime").focus();
		return false;
	}	

	if ($("#TREndTime").val()=="")
	{
		$.messager.alert("��ʾ","�������ʱ�䲻��Ϊ��!");
		$("#TREndTime").focus();
		return false;
	}	

	return true;
}

function CheckTRReturnTime()
{
	var myobj=websys_$('TRReturnTime');
	CheckTime(myobj);		
}

function CheckTREndTime()
{
	var myobj=websys_$('TREndTime');
	CheckTime(myobj);
}
function CheckTRStartTime()
{
	var myobj=websys_$('TRStartTime');
	CheckTime(myobj);
}

function CheckTRCancelTime()
{
	var myobj=websys_$('TRCancelTime');
	CheckTime(myobj);
} 

function CheckTRRegSTTime()
{
	var myobj=websys_$('TRRegSTTime');
	CheckTime(myobj);
}
function CheckTRRegEndTime()
{
	var myobj=websys_$('TRRegEndTime');
	CheckTime(myobj);
}

function CheckTime(myobj)
{
  var tstr=myobj.value;
	if(tstr)
	{
		var tstr_Split=tstr.split(":")
		var hour=tstr_Split[0];			
		var minuts=tstr_Split[1];
		var seconds=tstr_Split[2];	
		if (seconds==undefined) seconds="00"
		if(minuts)
		{			
			if(minuts.length >2)
			 {	
			 	  minuts=minuts.substring(0,2);				 	  		 	  
			 }
			 else if(minuts.length==1)
			 {
			 			minuts='0'+minuts;
			 }
			 if(hour.length >2)
			 {
			 	  hour=hour.substring(0,2);			 	  
			 }
			 else if(hour.length==1)
				{
					hour='0'+hour;
				}
		}
		else 
			{			
			switch(hour.length)
			{
				case 1: {hour='0'+hour;minuts='00';break;}
				case 2: {minuts='00';break;}
				case 3: {minuts=hour.substring(2,4);hour=hour.substring(0,2);minuts='0'+minuts;break;}
				case 4: {minuts=hour.substring(2,4);hour=hour.substring(0,2);break;}
			}
		}
		if(hour>=24)
		{
			hour=23;
		}
		if(minuts>=60)
		{
			minuts=59;
		}
		if (seconds>=60){
			seconds=59;
		}
		//myobj.value=hour+':'+minuts+':00';
		myobj.value=hour+':'+minuts+':'+seconds;
	}
}
function ReHospitalHandle(){
	var row=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	GenHospWin("DHC_TimeRange",row.TID);
	/*$("#ReHospital-dialog").dialog("open");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			QueryName:"GetHos",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Hosp", {
				editable:false,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#Hosp").combobox('select','');
				}
			 });
	});
	PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
	LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'ҽԺ',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReHospitalTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["TID"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"DHC_TimeRange",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
	}); 
}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("��ʾ","��ѡ��ҽԺ","info");
		return false;
	}
	var row=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["TID"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"DHC_TimeRange",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("��ʾ","�����ظ�","info");
		}else{
			$.messager.popover({msg: data.split("^")[1],type:'success',timeout: 1000});
			LoadReHospitalDataGrid();
		}
	})
}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ��һ��","info");
		return false;
	}
	var row=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["TID"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"DHC_TimeRange",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
		LoadReHospitalDataGrid();
	})
	
}
function ReportTimeHandle(){
	var row=PageLogicObj.m_DHCTimeRangeConfigListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["TID"]
	PageLogicObj.ReportTID=ID
	$("#ReportTime").dialog("open");
	var cbox = $HUI.combobox("#SplitStartTimelist,#SplitEndTimelist", {
			valueField: 'id',
			textField: 'Desc', 
			editable:true,
			data: [{"id":"1","Desc":"ǰ"},{"id":"2","Desc":"��"}]
	 });
	LoadReportTime()
}
function ReportTimeClickHandle(){
	if (PageLogicObj.ReportTID==""){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ReportStr=""
	ReportStr="UnSplitStartTime" +"!"+$("#UnSplitStartTime").timespinner('getValue'); 
	ReportStr=ReportStr+"^"+"UnSplitEndTime" +"!"+$("#UnSplitEndTime").timespinner('getValue'); 
	ReportStr=ReportStr+"^"+"SplitStartTimelist" +"!"+$("#SplitStartTimelist").combobox("getValue");
	ReportStr=ReportStr+"^"+"SplitStartTime" +"!"+$("#SplitStartTime").val(); 
	ReportStr=ReportStr+"^"+"SplitEndTimelist" +"!"+$("#SplitEndTimelist").combobox("getValue");
	ReportStr=ReportStr+"^"+"SplitEndTime" +"!"+$("#SplitEndTime").val(); 
	var HospID=$HUI.combogrid('#_HospUserList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveReportTimeRange",
		HospId:HospID,
		TimeRangeID:PageLogicObj.ReportTID,
		TimeRangeStr:ReportStr,
		dataType:"text",
	},function(data){
		$.messager.alert("��ʾ","����ɹ�")
		$("#ReportTime").dialog("close");
	})
	
	}
function LoadReportTime(){
	if (PageLogicObj.ReportTID==""){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var HospID=$HUI.combogrid('#_HospUserList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetReportTimeRange",
		HospId:HospID,
		TimeRangeID:PageLogicObj.ReportTID,
		dataType:"text",
	},function(data){
		if(data!=""){
			var DataAry=data.split("^")
			$("#UnSplitStartTime").timespinner('setValue',DataAry[0].split("!")[1]);
			$("#UnSplitEndTime").timespinner('setValue',DataAry[1].split("!")[1]);
			$("#SplitStartTimelist").combobox("setValue",DataAry[2].split("!")[1]);
			$("#SplitStartTime").val(DataAry[3].split("!")[1]); 
			$("#SplitEndTimelist").combobox("setValue",DataAry[4].split("!")[1]);
			$("#SplitEndTime").val(DataAry[5].split("!")[1]); 
		}else{
			$("#UnSplitStartTime,#UnSplitEndTime").timespinner('setValue',"");
			$("#SplitStartTimelist,#SplitEndTimelist").combobox('setValue',"");
			$("#SplitStartTime,#SplitEndTime").val('');
		}
	})
}
function InitFunLib(usertableName){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var indexs="";var sortstr="";
	var sortWin='<div id="sortWin" style="width:570px;height:450px;"></div>';
	var sortGrid='<table id="sortGrid"></table>';
	$('body').append(sortWin);
	$('#sortWin').append(sortGrid);
	  var columns=[[
	    {field:'SortId',title:'SortId',hidden:true},
	    {field:'RowId',title:'��Ӧ��RowId',hidden:true},
	    {field:'Desc',title:'����',width:180},
	    {field:'SortType',title:'��������',hidden:true},
	    {field:'SortNum',title:'˳���',editor:{'type':'numberbox'},width:180}
	  ]];
  var sortGrid=$HUI.datagrid('#sortGrid',{
      url: $URL,
      queryParams:{
        ClassName:"web.DHCBL.BDP.BDPSort",
        QueryName:"GetList",
        'tableName':usertableName,
        'hospid':HospID
      },
      columns: columns,  //����Ϣ
      pagination: true,   //pagination  boolean ����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
      pageSize:20,
      pageList:[5,10,14,15,20,25,30,50,75,100,200,300,500,1000],
      singleSelect:true,
      idField:'SortId',
      fit:true,
      rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
      fitColumns:true, //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����
      //remoteSort:false,  //�����Ƿ�ӷ������������ݡ������Ƿ�ӷ������������ݡ�true
      //toolbar:'#mytbar'
      toolbar:[],
      onClickCell:function(index, field, value){
        if(indexs!==""){
           $(this).datagrid('endEdit', indexs);
        }
        $(this).datagrid('beginEdit', index);
        indexs=index;
      },
      onAfterEdit:function(index, row, changes){
        var type=$HUI.combobox('#TextSort').getText();
        if(JSON.stringify(changes)!="{}"){
          if(sortstr!==""){
            sortstr=sortstr+'*'+usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }else{
            sortstr=usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
        }
      },
      onClickRow:function(index,row){
      },
      onDblClickRow:function(index, row){
      }
  });
  var toolbardiv='<div id="Sortb">��������&nbsp;<input id="TextSort" style="width:207px"></input><a plain="true" id="SortRefreshBtn" >����</a><a plain="true" id="SortSaveBtn" >����</a><a plain="true" id="SortUpBtn" >����</a><a plain="true" id="SortLowBtn" >����</a></div>';

  $('#sortWin .datagrid-toolbar tr').append(toolbardiv);
  $('#SortRefreshBtn').linkbutton({
      iconCls: 'icon-reload'
  });
  $('#SortSaveBtn').linkbutton({
      iconCls: 'icon-save'
  });
  $('#SortUpBtn').linkbutton({
      iconCls: 'icon-arrow-top'
  });
  $('#SortLowBtn').linkbutton({
      iconCls: 'icon-arrow-bottom'
  });
  $('#SortRefreshBtn').click(function(event) {
    //$('#TextSort').combobox('reload');
    $HUI.combobox('#TextSort').reload();
    $HUI.combobox('#TextSort').setValue();
    GridLoad(usertableName,'','');


  });

  $('#SortUpBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'ASC')
  });
  $('#SortLowBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'DESC')
  });
  $('#SortSaveBtn').click(function(event){
    var type=$HUI.combobox('#TextSort').getText();
    if(type==""){
      $.messager.alert('��ʾ','�������Ͳ���Ϊ�գ�','error');
      return
    }
    if(indexs!=""){
      $('#sortGrid').datagrid('endEdit', indexs);
    }
    if(sortstr==""){
      $.messager.alert('��ʾ','û���޸�����˳����������豣�棡','error');
      return
    }
    var NewSortArr=new Array();
	for (var i=0;i<sortstr.split("*").length;i++){
		var onesort=sortstr.split("*")[i];
		var onesortArr=onesort.split("^");
		onesortArr[2]=type;
		NewSortArr.push(onesortArr.join("^"));
	}
	sortstr=NewSortArr.join("*");
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData",
      data:{
            "sortstr":sortstr,
            MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
      },
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
            $.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
         
          var types=$HUI.combobox('#TextSort').getText();
          GridLoad(usertableName,types,'')
          //$HUI.combobox('#TextSort').reload();
        }
        else{
          var errorMsg="�޸�ʧ�ܣ�";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>������Ϣ:'+data.errorinfo
          }
          $.messager.alert('������ʾ',errorMsg,'error')
        }
      }
    });
  });
  
};
function SortBtn(usertableName){
	 InitFunLib(usertableName)
	var Sortwin=$HUI.dialog('#sortWin',{
	  iconCls:'icon-w-list',
	  resizeable:true,
	  title:'����(�������Ϳ��ֶ�¼��)',
	  modal:true,
	  onClose:function(){
		  InitSortType();
	  }
	});
	GridLoad(usertableName,'','');
	$('#TextSort').combobox({
	  url:$URL+"?ClassName=web.DHCBL.BDP.BDPSort&QueryName=GetDataForCmb1&ResultSetType=array",
	  valueField:'SortType',
	  textField:'SortType',
	  onBeforeLoad:function(param){
	    param.tableName=usertableName;
	    param.hospid=$HUI.combogrid('#_HospUserList').getValue();
	  },
	  onLoadSuccess:function(){
	  },
	  onSelect:function(record){
	    var type=record.SortType;
	    GridLoad(usertableName,type,'')
	  }
	});
};
function GridLoad (usertableName,type,dir){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
    sortstr="";
    $('#sortGrid').datagrid('load',{
      ClassName:"web.DHCBL.BDP.BDPSort",
      QueryName:"GetList",
      'tableName':usertableName,
      'type':type,
      'dir':dir,
      'hospid':HospID
    });
    $('#sortGrid').datagrid('unselectAll');
  };
var SortTypeData="";
function InitSortType(){
	$.q({
		ClassName:"web.DHCBL.BDP.BDPSort",
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.DHCTimeRange",hospid:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:"json"
	},function(Data){
		SortTypeData=Data.rows;
		$("#TimeRangeSort").combobox({
			textField:"SortType",
			valueField:"ID",
			data:Data.rows,
			OnChange:function(newValue,OldValue){
				if (!newValue) {
					$(this).combobox('setValue',"");
				}
			}
		})
	})
	}

function SetDefConfig(Node1, TypeId) {
	var HospId=$HUI.combogrid('#_HospUserList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		if ($.hisui.indexOfArray($("#"+TypeId).combobox('getData'),"SortType",rtn) >=0) {
			$("#"+TypeId).combobox("setText",rtn);
		}else{
			$("#"+TypeId).combobox("setText","");
		}
	})
	
}
function SaveConfigClick() {
	var TimeRangeSort=$("#TimeRangeSort").combobox("getText");
	if (($.hisui.indexOfArray(SortTypeData,"SortType",TimeRangeSort)<0)&&(TimeRangeSort!="")) {
		$.messager.alert("��ʾ","��ѡ��ʱ���б�����","info",function(){
			$("#TimeRangeSort").next('span').find('input').focus();
		});
		return false;
	}
	var SortConfig="TimeRangeSort"+"!"+TimeRangeSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"��ʾ",msg:"����ɹ�"});
	$("#TimeRange-dialog").dialog("close")
}
function SaveConfig(SortConfig) {
	var HospId=$HUI.combogrid('#_HospUserList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveConfigHosp",
		Coninfo:SortConfig,
		HospID:HospId
	},false)
}
function InitPopover(){
	$("#Checkin").next().popover({
		title:'��Ҫ�����жϹ���',
		style:'inverse',
		content:"�����жϷ������ű���գ�����Ƿ������������ʱ�Ρ�",
		placement:'bottom',
		trigger:'hover'
	});
	$("[for='Checkin']").popover({
		title:'��Ҫ�����жϹ���',
		style:'inverse',
		content:"�����жϷ������ű���գ�����Ƿ������������ʱ�Ρ�",
		placement:'bottom',
		trigger:'hover'
	});
	}
