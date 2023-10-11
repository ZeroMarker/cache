
/*
 * FileName: dhcpe/ct/station.js
 * Author: xy
 * Date: 2021-11-05
 * Description: վ��ά��-��Ժ��
 */
var STlastIndex = "";
var STEditIndex = -1;
var tableName = "DHC_PE_Station";
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//��ʼ��վ��Grid 
	InitStationGrid();
	
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
      
    $("#Code").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}		
      }); 
     
   $("#Desc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}		
      }); 
          
    //����
	$("#BClear").click(function() {	
		BClear_click();		
     });
    
     //������վ��ά����
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //�޸ģ�վ��ά����
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
     //���棨վ��ά����
    $('#BSave').click(function(){
    	BSave_click();
    });
    
    // ��������
    $("#RelateLoc").click(function() {	
		BRelateLoc_click();		
    }); 

    // ��׼������
    $("#RelateStandard").click(function() {  
        RelateStandard_click();     
    }); 
	
	// ��׼������ ������
	$('#ExamItemCatGrid_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#ExamItemCatGrid"),value,Public_gridsearch1);
		}
	});
	
    //��ť����Ȩ�ޣ��ܿ����ݣ�
    DisableButton();
})


/*******************************վ��start*************************************/
//��ť����Ȩ�ޣ��ܿ����ݣ�
function DisableButton(){
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
	if(flag=="S"){
		$('#RelateLoc').linkbutton('enable');
		$('#BSave').linkbutton('enable');
		$("#BUpdate").linkbutton('enable');
		$("#BAdd").linkbutton('enable');	
		$("#RelateStandard").linkbutton('enable');	
	}else{
		$('#RelateLoc').linkbutton('disable');
		$('#BSave').linkbutton('disable');
		$("#BUpdate").linkbutton('disable');
		$("#BAdd").linkbutton('disable');
		$("#RelateStandard").linkbutton('disable');
	}
}

//��ѯ
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationNew",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		LocID:LocID
	});	
}

//����
function BClear_click()
{
	var LocID=session['LOGON.CTLOCID'];
	$("#Code,#Desc,#StationID").val("");
	$("#LocList").combobox('setValue',LocID);
	BFind_click();
	
}

//���ݹ�������
function BRelateLoc_click()
{	
	var DateID=$("#StationID").val();
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}   
   var LocID=$("#LocList").combobox('getValue');
   //var LocID=session['LOGON.CTLOCID'];
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitStationGrid)
}

//��׼������
function RelateStandard_click()
{
    var DateID=$("#StationID").val();
    if (DateID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ���յļ�¼","info"); 
        return false;
    }
    $("#StandardWin").show();
    $("#ExamItemCatGrid_search").searchbox("setValue",'');
    var StandardWin = $HUI.dialog("#StandardWin", {
        width: 550,
        modal: true,
        height: 450,
        iconCls: '',
        title: '��׼������',
        resizable: true,
        buttonAlign: 'center',
        buttons: [{
            iconCls: 'icon-w-save',
            text: '����',
            id: 'save_btn',
            handler: function() {
                var selected = $('#ExamItemCatGrid').datagrid('getSelected');
                if(selected==null){
                    $.messager.alert("��ʾ", "��ѡ���׼���࣡", "info");
                    return false;
                }
                $.m({
					ClassName: "web.DHCPE.CT.Station",
					MethodName: "UpdateEx",
					ID:DateID,
					Code: selected.EICCode,
					Desc: selected.EICDesc
                }, function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('��ʾ', '����ɹ�', 'success');
					}
					
					LoadStaionGrid();
					$HUI.dialog("#StandardWin").close();
				});
            }
        },{
            iconCls: 'icon-w-close',
            text: '�ر�',
            handler: function() {
                $HUI.dialog("#StandardWin").close()
            }
        }],
        onOpen: function() {
			// ��ʼ��DataGrid
			$('#ExamItemCatGrid').datagrid({
				url:$URL,
				fit : true,
				border : false,
				striped : true,
				nowrap:true,
				fitColumns : false,
				autoRowHeight : false,
				rownumbers:true,
				pagination : true,
				loadMsg:'���ݼ�����...',
				pageSize: 20,
				pageList : [20,100,200],
				rownumbers : true,
				singleSelect: true,
				selectOnCheck: true,
				columns: [[
					{ field:'EICRowId', title:'EICRowId', hidden:true }
					,{ field:'EICCode', width: 70, title:'�ڲ�����', sortable: true, resizable: true }
					,{ field:'EICDesc', width: 100, title:'��������', sortable: true, resizable: true }
					,{ field:'EICDesc2', width: 200, title:'����', sortable: true, resizable: true }
					,{ field:'EICSort', width: 60, title:'˳���', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QueryExamItemCat",
					aType:"ST"
				},
				onLoadSuccess: function (data) {
					Public_gridsearch1 = [];
				}
			});
        }
    });
}

//����
function BAdd_click()
 {
	STlastIndex = $('#StaionGrid').datagrid('getRows').length - 1;
	$('#StaionGrid').datagrid('selectRow', STlastIndex);
	
	var selected = $('#StaionGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((STEditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#StaionGrid').datagrid('appendRow', {
		TID: '',
		TCode: '',
		TDesc: '',
	});
	STlastIndex = $('#StaionGrid').datagrid('getRows').length - 1;
	$('#StaionGrid').datagrid('selectRow', STlastIndex);
	$('#StaionGrid').datagrid('beginEdit', STlastIndex);
	STEditIndex = STlastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#StaionGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StaionGrid').datagrid('getRowIndex', selected);
		if ((STEditIndex != -1) && (STEditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#StaionGrid').datagrid('beginEdit', thisIndex);
		$('#StaionGrid').datagrid('selectRow', thisIndex);
		STEditIndex = thisIndex;
		var selected = $('#StaionGrid').datagrid('getSelected');

		var STthisEd = $('#StaionGrid').datagrid('getEditor', {
				index: STEditIndex,
				field: 'TCode'  
			});
			
			
		var STthisEd = $('#StaionGrid').datagrid('getEditor', {
				index: STEditIndex,
				field: 'TDesc'  
			});
		
	}
 }

//����
function BSave_click()
{
	var UserID=session['LOGON.USERID'];
	$('#StaionGrid').datagrid('acceptChanges');
	var selected = $('#StaionGrid').datagrid('getSelected');
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TCode == "undefined") || (selected.TDesc == "undefined")||(selected.TCode == "") ||(selected.TDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadStaionGrid();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "Insert",
				Code: selected.TCode,
				Desc: selected.TDesc,
				UserID:UserID
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.alert('��ʾ', '����ɹ�', 'success');		
				}

				LoadStaionGrid();
			});
		} else {
			$('#StaionGrid').datagrid('selectRow', STEditIndex);
			var selected = $('#StaionGrid').datagrid('getSelected');
			if ((selected.TCode == "undefined") || (selected.TDesc == "undefined")||(selected.TCode == "") ||(selected.TDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadStaionGrid();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "Update",
				ID: selected.TID,
				Code: selected.TCode,
				Desc: selected.TDesc,
				UserID:UserID
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
				}
			
				LoadStaionGrid();
			});
		}
	}
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
		width: '150',
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
		width: '300',
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
		field:'TEffPowerFlag',
		width:'100',
		align:'center',
		title:'��ǰ������Ȩ',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	},{
		field:'TSTKBItemCatDesc',
		width:200,
		title:'֪ʶ���������'
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
			QueryName:"FindStationNew",
			LocID:LocID	
		},
		onSelect: function (rowIndex,rowData) {
			$("#StationID").val(rowData.TID);
		},
		onLoadSuccess: function (data) {
			STEditIndex = -1;
		}
	});
}
/*******************************վ��end*************************************/

