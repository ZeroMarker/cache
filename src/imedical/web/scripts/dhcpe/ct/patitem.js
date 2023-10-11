/*
 * FileName: dhcpe/ct/patitem.js
 * Author: xy
 * Date: 2021-08-15
 * Description: ���ﵥ���ά��
 */
 
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_UsherItemCat";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//���������б�change
	$("#LocList").combobox({
       onSelect:function(){
			BFind_click();
		}
	})
	
	//��ʼ�� ���ﵥ���Grid
	InitPatItemGrid();
	
	//��ѯ
     $('#BFind').click(function(){
    	BFind_click();
    })
    
    //����
     $('#BAdd').click(function(){
    	BAdd_click();
    })
    
    //�޸�
     $('#BUpdate').click(function(){
    	BUpdate_click();
    })
    
    //����
     $('#BSave').click(function(){
    	BSave_click();
    })
    
	$('#PINoActive').checkbox({
		onCheckChange:function(e,vaule){
			BFind_click();			
	    }			
    });
	
	$("#PatItemName").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
     });
          	    
})

//��ѯ
function BFind_click()
{
	$("#PatItemGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.PatItem",
		QueryName:"FindPatItem",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#PatItemName").val(),
		NoActive:$("#PINoActive").checkbox('getValue') ? "Y" : "N"
			
	});	
}
//����
function BAdd_click()
 {
	lastIndex = $('#PatItemGrid').datagrid('getRows').length - 1;
	$('#PatItemGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PatItemGrid').datagrid('getSelected');
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
	$('#PatItemGrid').datagrid('appendRow', {
		TID: '',
		TCategory: '',
		TSort: '',
		TPlace: '',
		TDocSignName: '',
		TPatSignName: '',
		TNoActive: ''
		
			});
	lastIndex = $('#PatItemGrid').datagrid('getRows').length - 1;
	$('#PatItemGrid').datagrid('selectRow', lastIndex);
	$('#PatItemGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#PatItemGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PatItemGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#PatItemGrid').datagrid('beginEdit', thisIndex);
		$('#PatItemGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#PatItemGrid').datagrid('getSelected');
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TCategory'  
			});
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSort'  
			});
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPlace'  
			});
		
	}
 }

//TID,TCategory,TSort,TPlace,TDocSignName,TPatSignName,TNoActive,TUpdateDate,TUpdateTime,TUserName
//����
function BSave_click()
{
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	
	$('#PatItemGrid').datagrid('acceptChanges');
	var selected = $('#PatItemGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TCategory == "undefined") || (selected.TSort == "undefined")||(selected.TCategory == "") ||(selected.TSort == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadPatItemGrid();
				return;
			}
			var InfoStr=selected.TID+"^"+selected.TCategory+"^"+selected.TSort+"^"+selected.TPlace+"^"+selected.TDocSignName+"^"+selected.TPatSignName+"^"+selected.TNoActive+"^"+LocID+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.PatItem",
				MethodName: "SavePatItem",
				InfoStr:InfoStr,
				tableName:tableName
						
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('��ʾ', '����ɹ�', 'success');
					
				}
			
				
				LoadPatItemGrid();
			});
		} else {
			$('#PatItemGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PatItemGrid').datagrid('getSelected');
			if ((selected.TCategory == "undefined") || (selected.TSort == "undefined")||(selected.TCategory == "") ||(selected.TSort == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadPatItemGrid();
				return;
			}
		   var InfoStr=selected.TID+"^"+selected.TCategory+"^"+selected.TSort+"^"+selected.TPlace+"^"+selected.TDocSignName+"^"+selected.TPatSignName+"^"+selected.TNoActive+"^"+LocID+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.PatItem",
				MethodName: "SavePatItem",
				InfoStr:InfoStr,
				tableName:tableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
				}
			
				LoadPatItemGrid();
			});
		}
	}
}

function LoadPatItemGrid()
{
	 $("#PatItemGrid").datagrid('reload');
}

function InitPatItemGrid(){
	// ��ʼ��Grid
	$('#PatItemGrid').datagrid({
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
		columns: PatItemColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PatItem",
			QueryName:"FindPatItem",
			LocID:session['LOGON.CTLOCID']
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


//����
var PatItemColumns = [[
	{
		field:'TID',
		title:'ID',
		hidden:true
	},{
		field:'TCategory',
		width: '200',
		title:'���',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TSort',
		width: '90',
		title:'˳��',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'numberbox',
			options: {
				required: true
			}
		}
	},{
		field:'TPlace',
		width: '250',
		title:'λ��',
		editor: 'text',
		//sortable: false,
		resizable: true,
		editor: {
			type: 'textarea',
			options: {
				height:'50px'
						
			}
		}
	 },{
		field: 'TDocSignName',
		width: '90',
		title: 'ҽ��ǩ��',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TPatSignName',
		width: '90',
		title: '����ǩ��',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TNoActive',
		width: '80',
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
