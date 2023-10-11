
/*
 * FileName: dhcpe/ct/stationlocordersort.js
 * Author: xy
 * Date: 2021-08-11
 * Description: վ������Ӧ��Ŀά��
 */
var SOSlastIndex = "";
var SOSEditIndex = -1;

var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_StationOrdCatSort"; //����վ�������ű�
 
var SOStableName = "DHC_PE_StationOrderSort"; //����վ����Ŀ��ű�

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 $(function(){	
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//���������б�change
	$("#LocList").combobox({
       onSelect:function(){    
	     BFind_click();	
	     $("#StationID").val('');
	     $("#SOCSID").val('');
	     InitStationLocDetailGrid();
	     InitStationLocGrid();  
	 
       }
		
	});
	 
	InitCombobox();
	
	//��ʼ��վ��Grid 
	InitStationGrid();
	 
	//��ʼ���������Grid 
	InitStationLocGrid(); 
	
	//��ʼ�������Ӧ��ĿGrid 
	InitStationLocDetailGrid()
	
	//��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
      //����(�������)
     $('#BAdd').click(function(e){
    	BAdd_click();
    });
    
    //�޸�(�������)
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
      //����(������ţ�
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //���ݹ������ң�������ţ�
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
    //����(�����Ӧ��Ŀ)
     $('#BSOSAdd').click(function(e){
    	BSOSAdd_click();
    });
    
    //�޸�(�����Ӧ��Ŀ)
     $('#BSOSUpdate').click(function(){
    	BSOSUpdate_click();
    });
    
     //����(�����Ӧ��Ŀ��
     $('#BSOSSave').click(function(){
    	BSOSSave_click();
    });
    
     //���ݹ������ң������Ӧ��Ŀ��
	$("#BSOSRelateLoc").click(function() {	
		BSOSRelateLoc_click();		
        });
          
	
 })
 
 /*******************************�����Ӧ��Ŀ start*****************************************/

//���ݹ������ң������Ӧ��Ŀ��
function BSOSRelateLoc_click()
{
	var SOSID=$("#SOSID").val()
	if (SOSID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
   //alert(SOStableName+"^"+SOSID+"^"+SessionStr+"^"+LocID)
   OpenLocWin(SOStableName,SOSID,SessionStr,LocID,InitStationLocDetailGrid)
}
      
 //����(�����Ӧ��Ŀ)
function BSOSAdd_click()
 {
	  var SOCSID=$("#SOCSID").val();
	 if(SOCSID==""){
		 $.messager.alert('��ʾ', "��ѡ��������", 'info');
		return;
	 }

	SOSlastIndex = $('#StationLocDetailGrid').datagrid('getRows').length - 1;
	$('#StationLocDetailGrid').datagrid('selectRow', SOSlastIndex);
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSOSID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((SOSEditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#StationLocDetailGrid').datagrid('appendRow', {	
		TSOSID:'',
		TSOSOrderDR:'',
		TARCIMDesc:'',
		TSOSSort:''
		
		});
	SOSlastIndex = $('#StationLocDetailGrid').datagrid('getRows').length - 1;
	$('#StationLocDetailGrid').datagrid('selectRow', SOSlastIndex);
	$('#StationLocDetailGrid').datagrid('beginEdit', SOSlastIndex);
	SOSEditIndex = SOSlastIndex;
 }
 
 //�޸�(�������)
 function BSOSUpdate_click()
 {
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StationLocDetailGrid').datagrid('getRowIndex', selected);
		if ((SOSEditIndex != -1) && (SOSEditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#StationLocDetailGrid').datagrid('beginEdit', thisIndex);
		$('#StationLocDetailGrid').datagrid('selectRow', thisIndex);
		SOSEditIndex = thisIndex;
		var selected = $('#StationLocDetailGrid').datagrid('getSelected');

		var thisEd = $('#StationLocDetailGrid').datagrid('getEditor', {
				index: SOSSEditIndex,
				field: 'TSOSSort'  
			});
		
		var thisEd = $('#StationLocDetailGrid').datagrid('getEditor', {
				index: OSEditIndex,
				field: 'TARCIMDesc'  
				
			});	
		$(thisEd.target).combobox('select', selected.TSOSOrderDR);  
				
		
	}
 }

//����
function BSOSSave_click()
{
	var SOCSID=$("#SOCSID").val();
	var OrderID=$("#OrderID").val();
	$('#StationLocDetailGrid').datagrid('acceptChanges');
	var selected = $('#StationLocDetailGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TSOSID == "") {
			if ((selected.TARCIMDesc == "undefined") || (selected.TSOSSort == "undefined") ||(selected.TARCIMDesc=="")||(selected.TSOSSort == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#StationLocDetailGrid").datagrid('reload');
				return;
			}
			var OrderDR=selected.TARCIMDesc;
			if((OrderDR != "") && (OrderDR.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ����Ŀ","info");
				return false;
			}
			var SOSSort=selected.TSOSSort; 
			var tableName=SOStableName;
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			
			var flag = tkMakeServerCall("web.DHCPE.CT.StationLoc","IsExsistSort",SOCSID,"",LocID,tableName,SOSSort);
			if(flag==1){
				$.messager.alert("��ʾ","˳����ظ���","info");
				return false;
			}
			
			var InputStr=""+"^"+SOCSID+"^"+OrderDR+"^"+SOSSort+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStatOrderSort",
				InputStr:InputStr			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
				}
				
				$("#StationLocDetailGrid").datagrid('reload');
			});
		} else {
			$('#StationLocDetailGrid').datagrid('selectRow', SOSEditIndex);
			var selected = $('#StationLocDetailGrid').datagrid('getSelected');
			if ((selected.TSOSSort == "undefined") || (selected.TARCIMDesc == "undefined") ||(selected.TSOSSort=="")||(selected.TARCIMDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#StationLocDetailGrid").datagrid('reload');
				return;
			}
			var ID=selected.TSOSID;
			var OrderDR=OrderID;
			//var OrderDR=selected.TARCIMDesc;
			if((OrderDR != "") && (OrderDR.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ����Ŀ","info");
				return false;
			}
			var SOSSort=selected.TSOSSort; 
			
			
			var tableName=SOStableName;
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			
			var flag = tkMakeServerCall("web.DHCPE.CT.StationLoc","IsExsistSort",SOCSID,ID,LocID,tableName,SOSSort);
			if(flag==1){
				$.messager.alert("��ʾ","˳����ظ���","info");
				return false;
			}
			var InputStr=ID+"^"+SOCSID+"^"+OrderDR+"^"+SOSSort+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStatOrderSort",
				InputStr:InputStr	
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});
				}
			
				$("#StationLocDetailGrid").datagrid('reload');
			});
		}
	}
}

	
var StationLocDetailColumns = [[
	{
		field:'TSOSID',
		title:'SOSID',
		hidden:true
	},{
		field:'TSOSOrderDR',
		title:'TSOSOrderDR',
		hidden:true
	},{
		field:'TSOSSort',
		width: '60',
		title:'˳���',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
	},{
		field: 'TARCIMDesc',
		title: '��Ŀ',
		width: 230,
		formatter:function(value,row){
            return row.TARCIMDesc;
         },
		editor:{
           type:'combobox',
           options:{
	           required: true,
                valueField:'TOrderID',
                textField:'TARCIMDesc',
                method:'get',
                url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindStationOrder&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.ARCIMDesc = param.q;
			       	param.StationID=$("#StationID").val();
					param.Type="B";
					param.LocID=session['LOGON.CTLOCID'];
					param.hospId = session['LOGON.HOSPID']; 
					param.tableName="DHC_PE_StationOrder"              
                  }
                        
               }
         }
	},{
		field:'TARCIMDR',
		title:'TARCIMDR',
		hidden:true
	},{
		field: 'TEmpower',
		width: '70',
		title: '������Ȩ',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		},
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}

	},{ field:'TEffPowerFlag',
		width:100,
		align:'center',
		title:'��ǰ������Ȩ',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	}
]];

//��ʼ�������Ӧ��ĿGrid  
function InitStationLocDetailGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$('#StationLocDetailGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationLocDetailColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrderSort",
			SOCSID:$("#SOCSID").val(),
			tableName:SOStableName,
			LocID:locId
		},
		onSelect: function (rowIndex, rowData) {
			if(rowIndex!="-1"){
			if(rowData.TEmpower=="Y"){		
				$("#BSOSRelateLoc").linkbutton('enable');
			}else{
				$("#BSOSRelateLoc").linkbutton('disable');
			}
	
			$("#SOSID").val(rowData.TSOSID);
			$("#OrderID").val(rowData.TSOSOrderDR);
			}

		},
		onLoadSuccess: function (data) {
			SOSEditIndex = -1;
		}
	});
	
	
}

function LoadStationLocDetailGrid(SOCSID)
{
	 
	$("#StationLocDetailGrid").datagrid('load',{
	ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrderSort",
			SOCSID:SOCSID,
			tableName:SOStableName,
			LocID:$("#LocList").combobox('getValue')
		
	});	
	
}


 /*******************************�����Ӧ��Ŀ end*****************************************/
 
 /*******************************������� start*****************************************/
 //���ݹ�������
function BRelateLoc_click()
{
	var SOCSID=$("#SOCSID").val()
	if (SOCSID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
  
    OpenLocWin(tableName,SOCSID,SessionStr,LocID,InitStationLocGrid)
}


//����(�������)
function BAdd_click()
 {
	var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert('��ʾ', "��ѡ���ά����վ��", 'info');
		return;
	}

	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSOCSID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSOCSID:'',
		TOrdCatDR:'',
		TSOCSDesc:'',
		TSOCSSort:''
		
		
			});
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	$('#StationLocGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�(�������)
 function BUpdate_click()
 {
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StationLocGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#StationLocGrid').datagrid('beginEdit', thisIndex);
		$('#StationLocGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#StationLocGrid').datagrid('getSelected');

		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSOCSSort'  
			});
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSOCSDesc'  
				
			});	
		$(thisEd.target).combobox('select', selected.TOrdCatDR);  
				
		
	}
 }

//����
function BSave_click()
{
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TSOCSID == "") {
			if ((selected.TSOCSDesc == "undefined") || (selected.TSOCSSort == "undefined") ||(selected.TSOCSDesc=="")||(selected.TSOCSSort == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStationOrdCatSort",
				OrdCatID:selected.TSOCSDesc, 
				LocSort:selected.TSOCSSort, 
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'), 
				UserID:session['LOGON.USERID'], 
				Empower:selected.TEmpower
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
				}else{
					$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
				}
				$("#StationLocGrid").datagrid('reload');
			});
		} else {
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
		if ((selected.TSOCSDesc == "undefined") || (selected.TSOCSSort == "undefined") ||(selected.TSOCSDesc=="")||(selected.TSOCSSort == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "SaveStationOrdCatSort",
				ID:selected.TSOCSID,
				OrdCatID:selected.TSOCSDesc, 
				LocSort:selected.TSOCSSort, 
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'), 
				UserID:session['LOGON.USERID'], 
				Empower:selected.TEmpower
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});
				}
			
				$("#StationLocGrid").datagrid('reload');
			});
		}
	}
}

	
var StationLocColumns = [[
	{
		field:'TSOCSID',
		title:'SOCSID',
		hidden:true
	},{
		field:'TSOCSSort',
		width: '60',
		title:'˳���',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
	},{
		field:'TSOCSDesc',
		title:'��������',
		width:120,
		formatter:function(value,row){
            return row.TSOCSDesc;
         },
		editor:{
           type:'combobox',
           required: true,
           options:{
	           required: true,
                valueField:'TSLID',
                textField:'TSLDesc',
                method:'get',
                url:$URL+"?ClassName=web.DHCPE.CT.StationLoc&QueryName=FindStationLoc&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.StationID=$("#StationID").val();
					param.LocID=$("#LocList").combobox('getValue')
					          
                  }
                        
               }
         }
	},{
		field:'TOrdCatDR',
		title:'TOrdCatDR',
		hidden:true
	},{
		field: 'TEmpower',
		width: '70',
		title: '������Ȩ',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		},
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}

	},{ field:'TEffPowerFlag',
		width:100,
		align:'center',
		title:'��ǰ������Ȩ',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	}
]];
	
	
//��ʼ���������Grid 
function InitStationLocGrid(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$('#StationLocGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStatOrdCat",
			StationID:$("#StationID").val(),
			tableName:tableName,
			LocID:locId 
		},
		onSelect: function (rowIndex, rowData) {
			if(rowData!=undefined){
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
		    
				$("#SOCSID").val(rowData.TSOCSID);
				LoadStationLocDetailGrid(rowData.TSOCSID)
			}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
	
}


function LoadStationLocGrid(StationID)
{ 
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStatOrdCat",
		StationID:StationID,
		tableName:tableName,
		LocID:$("#LocList").combobox('getValue')
		
	});	
	
}
 /*******************************������� end*****************************************/
 
 /*******************************վ�� start*****************************************/

// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'����',width: 70},
			{field:'TStationDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:locId,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			LoadStationLocGrid(rowData.TStationID);
			$("#BRelateLoc").linkbutton('disable');
			$("#StationLocDetailGrid").datagrid('reload');
		
		},
		onLoadSuccess: function (data) {
			
		}
	});
	
}



//��ѯ��վ�㣩
function BFind_click(){
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y",
		
	});	
	
}
/*******************************վ�� end*************************************/

 function InitCombobox(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; } 
	
	 //վ�����
	var LocDescObj = $HUI.combobox("#LocDesc",{
		url:$URL+"?ClassName=web.DHCPE.CT.StationLoc&QueryName=FindStationLoc&ResultSetType=array&LocID="+LocID,
		valueField:'TSLID',
		textField:'TSLDesc',
	});
 }
 
 
 function isInteger(num) {
    if (!isNaN(num) && num % 1 === 0) {
       return true;
    } else {
      return false;
   }
}
