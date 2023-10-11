/*
 * FileName: dhcpe/ct/messagetemplet.js
 * Author: xy
 * Date: 2021-08-08
 * Description: ����ģ��ά��
 */
var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_NewMessageTemplet";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	InitCombobox();
	  
	 //��ʼ�� ����ά��Grid  
    InitMessageTempletGrid();
    
    //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
		 BFind_click();
		}
	});
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
     
     
    //����
	$("#BClear").click(function() {	
		BClear_click();		
     });
        
      //����
     $('#BSave').click(function(){
    	BSave_click();
    });
    
       
    $('#Active').checkbox({
		onCheckChange:function(e,vaule){
			BFind_click();			
	    }			
    });    
   
})

//��ѯ
function BFind_click(){
		
	$("#MessageTempletGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.MessageTemplet",
			QueryName:"FindMessageTemplet",
			LocID:$("#LocList").combobox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			Type:$("#Type").combobox('getValue'),
			Templet:$.trim($("#Templet").val()),
			Active:$("#Active").checkbox('getValue') ? "1" : "0"
			
		});	

}


//����
function BClear_click()
{
	$("#VIPLevel,#Type").combobox('setValue','');
	$("#Templet").val("");
	$("#Active").checkbox('setValue',true);
	BFind_click();
	
}


//����
function LoadMessageTempletGrid()
{
	$("#MessageTempletGrid").datagrid('reload');
}

//����
function BAdd_click()
 {
	lastIndex = $('#MessageTempletGrid').datagrid('getRows').length - 1;
	$('#MessageTempletGrid').datagrid('selectRow', lastIndex);
	var selected = $('#MessageTempletGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#MessageTempletGrid').datagrid('appendRow', {
		TID: '',
		TTypeID:'',
		TType:'',
		TVIPID:'',
		TVIDesc:'',
		TTemplet:'',
		TActive:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUserName:''
		
	});
	lastIndex = $('#MessageTempletGrid').datagrid('getRows').length - 1;
	$('#MessageTempletGrid').datagrid('selectRow', lastIndex);
	$('#MessageTempletGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#MessageTempletGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#MessageTempletGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#MessageTempletGrid').datagrid('beginEdit', thisIndex);
		$('#MessageTempletGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
	
		var selected = $('#MessageTempletGrid').datagrid('getSelected');
		
		var thisEd = $('#MessageTempletGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TType'  
		});
		$(thisEd.target).combobox('select', selected.TTypeID);  
		
		var thisEd = $('#MessageTempletGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TVIDesc'  
		});
		$(thisEd.target).combobox('select', selected.TVIPID);  
			
		var thisEd = $('#MessageTempletGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTemplet'  
		});
		
		
	}
 }

//����
function BSave_click()
{
	$('#MessageTempletGrid').datagrid('acceptChanges');
	
	var selected = $('#MessageTempletGrid').datagrid('getSelected');
	if (selected) {
		
		if (selected.TID == "") {
			if ((selected.TVIDesc== "undefined")||(selected.TTemplet=="undefined")||(selected.TType == "undefined")||(selected.TVIDesc == "")||(selected.TTemplet=="")||(selected.TType == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadMessageTempletGrid();
				return;
			}
			
			var iActive=selected.TActive;
			if(iActive=="Y"){var iActive="1";}
			else{var iActive="0";}
			
			$.m({
				ClassName: "web.DHCPE.CT.MessageTemplet",
				MethodName: "Insert",
				VIP:selected.TVIDesc,
				Templet:selected.TTemplet,
				Type:selected.TType,
				Active:iActive,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				
			
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', rtnArr[1], 'error');
				}else{
					$.messager.popover({msg:  rtnArr[1],type:'success',timeout: 1000});	v
				}	
			LoadMessageTempletGrid();
			});
		} else {
			$.messager.confirm("ȷ��", "ȷ��Ҫ����������", function(r){
			if (r){
					$('#MessageTempletGrid').datagrid('selectRow', EditIndex);
					var selected = $('#MessageTempletGrid').datagrid('getSelected');
					if ((selected.TVIDesc == "undefined")||(selected.TTemplet=="undefined")||(selected.TType == "undefined")||(selected.TVIDesc == "")||(selected.TTemplet=="")||(selected.TType == "")) {
						$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
						LoadDiagnosisLevel()
						return;
					}
			var iActive=selected.TActive;
			if(iActive=="Y"){var iActive="1";}
			else{var iActive="0";}
			
				$.m({
						ClassName: "web.DHCPE.CT.MessageTemplet",
						MethodName: "Update",
						rowid: selected.TID,  
						VIP:selected.TVIDesc,
						Templet:selected.TTemplet,
						Type:selected.TType,
						Active:iActive,
						LocID:$("#LocList").combobox('getValue'),
						UserID:session['LOGON.USERID'],
						
				
					}, function (rtn) {
						var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){		
						$.messager.alert('��ʾ', rtnArr[1], 'error');
					}else{	
						$.messager.popover({msg:  rtnArr[1],type:'success',timeout: 1000});	
					
					}
			
					LoadMessageTempletGrid();
				});
			
			
				}
			});	
		
			
		}
	}
}


//��������  �����б�ֵ
var MessageTypeData = [{
	id: '�������',
	text: '�������'
}, {
	id: '��Σ����',
	text: '��Σ����'
}, {
	id: '��ͨ����',
	text: '��ͨ����'
}, {
	id: 'VIP����',
	text: 'VIP����'
}];
		


var MessageTempletColumns = [[
	{
		field:'ID',
		title:'ID',
		hidden:true
	},{
		field:'TType',
		title:'��������',
		width:250,
		panelHeight:"auto",
		sortable:true,
		//resizable:true,
		editor: {
			type:'combobox',
			options: {
				valueField: 'id',
				textField: 'text',
				data: MessageTypeData,
				required: true
			}
		 }
		},  {
		  field: 'TVIDesc',
		  title: 'VIP�ȼ�',
		  width: 200,
		  formatter:function(value,row){
          	return row.TVIDesc;
           },
		   editor:{
             type:'combobox',
             options:{
	         	required: true,
             	valueField:'id',
              	textField:'TDesc',
               	method:'get',
                url:$URL+"?ClassName=web.DHCPE.CT.VIPLevel&QueryName=FindVIPLevel&ResultSetType=array",
                onBeforeLoad:function(param){   
                	    
                   }
                        
                 }
             }
		},{
			field:'TTemplet',
			width: '300',
			title:'��������',
			editor: {
				type: 'textarea',
				options: {
					required: true,
					height:'60px'
						
				}
			}
	 },{
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
	}, {
		field: 'TUpdateDate',
		width: '120',
		title: '��������'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '����ʱ��'
	}, {
		field: 'TUserName',
		width: '120',
		title: '������'
	}	
			
]];
		
function InitMessageTempletGrid(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	// ��ʼ��DataGrid
	$('#MessageTempletGrid').datagrid({
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
		columns: MessageTempletColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.MessageTemplet",
			QueryName:"FindMessageTemplet",
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			LocID:LocID
			
		},
		onSelect: function (rowIndex, rowData) {

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});

	
}


function InitCombobox()
{		
	// ��������
	$HUI.combobox("#Type", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:MessageTypeData
	});
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.VIPLevel&QueryName=FindVIPLevel&ResultSetType=array",
		valueField:'id',
		textField:'TDesc',
		panelHeight:"auto"
		});
		
}
