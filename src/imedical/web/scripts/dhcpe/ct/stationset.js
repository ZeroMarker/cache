
/*
 * FileName: dhcpe/ct/stationset.js
 * Author: xy
 * Date: 2021-08-09
 * Description: վ������ά��
 */

var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_StationSet";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//��ʼ��վ��Grid 
	InitStationGrid();
	 
	//��ʼ������վ������Grid 
	InitStationLocGrid();
	
	 //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	       
	        BClear_click();	 
       }
		
	});
	
	
	//��ѯ(վ��)
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
     $("#Desc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}
			
       });    
   
     
     //����������վ������ά����
	$("#BLAdd").click(function() {	
		BLAdd_click();		
     });
        
    //�޸ģ�����վ������ά����
	$("#BLUpdate").click(function() {	
		BLUpdate_click();		
     });
         
      //���棨����վ������ά����
     $('#BLSave').click(function(){
    	BLSave_click();
    });
          
	//���루����վ������ά����
     $('#BLImport').click(function(){
    	BLImport_click();
    });  
        
})


/*******************************վ��start*************************************/
//��ѯ(վ��)
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
		
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindEffStation",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		LocID:LocID
		
	});	
}

//����(վ��)
function BClear_click()
{
	$("#Code,#Desc,#StationID").val("");
	
	BFind_click();
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
	
	});	
}



function LoadStaionGrid()
{
	 $("#StaionGrid").datagrid('reload');
}


var StationColumns = [[
	{
		field:'TID',
		title:'TID',
		hidden:true
	},{  
		field:'TCode',
		width: '100',
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	 },{  
		field:'TDesc',
		width: '170',
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			 }
		}
	 }
			
]];

// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
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
		columns: StationColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindEffStation",
			LocID:LocID
			
		},
		onSelect: function (rowIndex,rowData) {
			
			if(rowIndex!="-1"){
				$("#StationID").val(rowData.TID);
				LoadStationLocGrid(rowData.TID);
				iniForm();
			}

		},
		onLoadSuccess: function (data) {
	        
	        //Ĭ��ѡ�е�һ��
			$("#StaionGrid").datagrid("selectRow",0);
			var selectrow = $('#StaionGrid').datagrid('getSelected');
			$("#StationID").val(selectrow.TID);
			LoadStationLocGrid($("#StationID").val());
			
		}
	});
	
}


/*******************************վ��end*************************************/

/*******************************����վ������start*************************************/


function LoadStationLocGrid(StaionID) {
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		StaionID:StaionID, 
		LocID:$("#LocList").combobox('getValue')
	});	
}


//����
function BLAdd_click()
 {
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TSTLID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSTSID:'',
		TPlace:'',
		TSequence:'',
		TAutoAudit:'',
		TLayoutTypeDR:'',
		TLayoutType:'',
		TButtonTypeDR:'',
		TButtonType:'',
		TReportSequence:'',
		TAllResultShow:'',
		TActive:'',
		
	});
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	$('#StationLocGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BLUpdate_click()
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
				field: 'TLayoutType'  
			});
	    $(thisEd.target).combobox('select',selected.TLayoutTypeDR); 	
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TButtonType'  
			});
	    $(thisEd.target).combobox('select',selected.TButtonTypeDR); 
	    	
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPlace'  
			});
		
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSequence'  
			});
			
		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TReportSequence'  
			});
						
		
	}
}
 

//����
function BLSave_click()
{
	
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var StationID=$("#StationID").val();
	
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	
	if (selected) {
		
		if (selected.TSTSID == "") {
			if((selected.TSequence == "undefined")||(selected.TReportSequence == "undefined")||(selected.TLayoutType == "undefined")||(selected.TButtonType == "undefined")||(selected.TSequence == "")||(selected.TReportSequence == "")||(selected.TLayoutType == "")||(selected.TButtonType == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				 $("#StationLocGrid").datagrid('reload');
				return;
			}
			
			$.m({
				ClassName: "web.DHCPE.CT.Station", 
				MethodName: "UpdateStationSet",
				ID:"",
			    InfoStr:selected.TPlace+"^"+selected.TSequence+"^"+selected.TAutoAudit+"^"+selected.TLayoutType+"^"+selected.TButtonType+"^"+selected.TReportSequence+"^"+selected.TAllResultShow+"^"+selected.TActive+"^"+LocID+"^"+UserID+"^"+StationID+"^"+tableName
				
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('��ʾ', '����ɹ�', 'success');
					
				}
			
				 $("#StationLocGrid").datagrid('reload');
			});
		} else {
			
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
			if((selected.TSequence == "undefined")||(selected.TReportSequence == "undefined")||(selected.TLayoutType == "undefined")||(selected.TButtonType == "undefined")||(selected.TSequence == "")||(selected.TReportSequence == "")||(selected.TLayoutType == "")||(selected.TButtonType == "")) {	
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				 $("#StationLocGrid").datagrid('reload');
				return;
			}
			
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "UpdateStationSet",
				ID:selected.TSTSID,
				InfoStr:selected.TPlace+"^"+selected.TSequence+"^"+selected.TAutoAudit+"^"+selected.TLayoutType+"^"+selected.TButtonType+"^"+selected.TReportSequence+"^"+selected.TAllResultShow+"^"+selected.TActive+"^"+LocID+"^"+UserID+"^"+StationID+"^"+tableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
				}
			
				 $("#StationLocGrid").datagrid('reload');
			});
		}
  }
}


//��������  �����б�ֵ
var LayoutTypeData = [ 
	{id:'1',text:$g('��')},
    {id:'2',text:$g('��ϸ')},
    {id:'3',text:$g('��ͨ����')},
    {id:'4',text:$g('�ӿڻ���')},
    {id:'5',text:$g('��ͨ���')},
    {id:'6',text:$g('�ӿڼ��')},
    {id:'7',text:$g('����')},
    {id:'8',text:$g('ҩƷ')}
 ];
	
var ButtonTypeData = [
	{id:'1',text:$g('��׼')},
	{id:'2',text:$g('����')},
	{id:'3',text:$g('����')}
];	

var StationLocColumns = [[
	{
		field:'TSTSID', 
		title:'TSTSID',
		hidden:true
	}, {
		field: 'TActive',
		width: '60',
		title: '����',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{  
		field:'TSequence',
		width: '80',
		title:'�ܼ�˳��',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	 },{  
		field:'TReportSequence',
		width: '80',
		title:'����˳��',
		editor: 'text',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			 }
		}
	 },{
		field: 'TAllResultShow',
		width: '120',
		title: '�ܼ���ʾ���н��',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		   }					
	   }
	 },{
		field: 'TAutoAudit',
		width: '120',
		title: '�����Զ��ύ',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		   }					
	   }
	 },{
		field:'TLayoutTypeDR',
		title:'TLayoutTypeDR',
		hidden:true
	},{
		field:'TLayoutType',
		title:'��������',
		width:90,
		panelHeight:"auto",
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {
				valueField: 'id',
				textField: 'text',
				data: LayoutTypeData,
				required: true
			}
		 }
	},{
		field:'TButtonTypeDR',
		title:'TButtonTypeDR',
		hidden:true
	},{
		field:'TButtonType',
		title:'��ť����',
		width:90,
		panelHeight:"auto",
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {
				valueField: 'id',
				textField: 'text',
				data: ButtonTypeData,
				required: true
			}
		 }
	},{
		field:'TPlace',
		width: '130',
		title:'վ��λ��',
		editor: 'text',
		sortable: false,
		resizable: true,
		editor: {
			type: 'textarea',
			options: {
				height:'60px'
						
			}
		}
	 },{
		field: 'TUpdateDate',
		width: '120',
		title: '��������'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '����ʱ��'
	}, {
		field: 'TUpdateUserName',
		width: '120',
		title: '������'
	}	
			
]];


// ��ʼ������վ������ά��DataGrid
function InitStationLocGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
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
		pageList : [20,100,200],  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		frozenColumns:[[
			{
			field: 'TStationDesc',
			width: '100',
			title: 'վ��'
			}
		]],
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStaionSet",
			StaionID:$("#StationID").val(), 
		    LocID:LocID
			
		},
		onSelect: function (rowIndex, rowData) {
			

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}
 
function iniForm(){
	
	var StationID=$("#StationID").val();
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationType = tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationTypeByID",StationID,LocID);
	
    if(StationType=="LIS"){
	    $("#BLImport").show();
    }else{
        $("#BLImport").hide();
    }
	
}

//����
function BLImport_click(){
	var UserID=session['LOGON.USERID'];
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	if(LocID==""){
		$.messager.alert("��ʾ","���Ҳ���Ϊ�գ�","info");
		return false;
	}	
	
	var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert("��ʾ","վ�㲻��Ϊ�գ�","info");
		return false;
	}
		
	var LocGrpID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocGrpByLocID",LocID);
	if(LocGrpID.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","�ÿ���û��ά����Ӧ��Ĭ�Ͽ��ң�","info");
		return false;
		
	}
	
	var LocStr=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocIDByLocGrp",LocGrpID);
	if(LocStr.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","��������û�ж�Ӧ�Ŀ���ID��","info");
		return false;
		
	}
    
	var rtn=tkMakeServerCall("web.DHCPE.CT.Station","ImportLISOD",StationID,LocID,UserID,LocStr);
	var rtnone=rtn.split("^");
	if(rtnone[0]=="0"){
		$.messager.alert("��ʾ","������ɣ�","success");		
	}else{
		$.messager.alert("��ʾ",rtnone[1],"info");
	}
	
}
/*******************************����վ������end*************************************/
