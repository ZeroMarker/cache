
/*
 * FileName: dhcpe/ct/stationloc.js
 * Author: xy
 * Date: 2021-08-10
 * Description: վ�����ά��
 */
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_StationLoc";
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//��ʼ��վ��Grid 
	InitStationGrid();
	 
	//��ʼ��վ�����Grid 
	InitStationLocGrid();
	
   //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	      BFind_click();
	      $('#StationID,#SLDesc,#Desc,#STLocID').val("");
		  BLFind_click();	 		 
       }
		
	});
	
	//��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click();
			
     });
           
	 
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
	
    //��ѯ��վ�����ά����
	$("#BLFind").click(function() {	
		BLFind_click();		
     });
         
    	 
	$("#SLDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BLFind_click();
		}
	});


	   
     //������վ�����ά����
	$("#BLAdd").click(function() {	
		BLAdd_click();		
     });
        
    //�޸ģ�վ�����ά����
	$("#BLUpdate").click(function() {	
		BLUpdate_click();		
     });
         
     //���棨վ�����ά����
     $('#BLSave').click(function(){
    	BLSave_click();
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

/*******************************վ�����ά��start*************************************/

//��ť����Ȩ�ޣ��ܿ����ݣ�
function DisableButton(){
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
	
	if(flag=="S"){
		$('#RelateLoc').linkbutton('enable');
		$('#BLSave').linkbutton('enable');
		$("#BLUpdate").linkbutton('enable');
		$("#BLAdd").linkbutton('enable');	
		$("#RelateStandard").linkbutton('enable');	
	}else{
		$('#RelateLoc').linkbutton('disable');
		$('#BLSave').linkbutton('disable');
		$("#BLUpdate").linkbutton('disable');
		$("#BLAdd").linkbutton('disable');
		$("#RelateStandard").linkbutton('disable');
	}
}



//���ݹ�������
function BRelateLoc_click()
{	
	var STLocID=$('#STLocID').val();
	if (STLocID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}   
   var LocID=$("#LocList").combobox('getValue');
   //var LocID=session['LOGON.CTLOCID'];
   OpenLocWin(tableName,STLocID,SessionStr,LocID,InitStationLocGrid) 
    
}

function RelateStandard_click()
{
    var STLocID=$('#STLocID').val();
    if (STLocID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ���յļ�¼","info"); 
        return false;
    }   
    $("#StandardWin").show();
	$('#ExamItemCatGrid_search').searchbox("setValue",'');
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
                
                if(selected==null)
                {
                    $.messager.alert("��ʾ", "��ѡ���׼���࣡", "info");
                    return false;
                }
                $.m({
                ClassName: "web.DHCPE.CT.StationLoc",
                MethodName: "UpdateStationLocEx",
                ID:STLocID,
                Code: selected.EICCode,
                Desc: selected.EICDesc
            
                }, function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('��ʾ', '����ɹ�', 'success');      
					}
					
					$("#StationLocGrid").datagrid('reload');
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
				fitColumns : false,
				autoRowHeight : false,
				rownumbers:true,
				pagination : true,
				pageSize: 20,
				pageList : [20,100,200],  
				rownumbers : true,  
				singleSelect: true,
				selectOnCheck: true,
				columns: [[
					{ field:'EICRowId', title:'EICRowId', hidden:true }
					,{ field:'EICCode', width: 70, title:'�ڲ�����', sortable: true, resizable: true}
					,{ field:'EICDesc', width: 100, title:'��������', sortable: true, resizable: true }
					,{ field:'EICDesc2', width: 200, title:'����', sortable: true, resizable: true }
					,{ field:'EICSort', width: 60, title:'˳���', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QueryExamItemCat",
					aType:"STC"
				},
				onLoadSuccess: function (data) {
					Public_gridsearch1 = [];
				}
			});
        }
    });
}
//��ѯ��վ����ࣩ
function BLFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStationLocNew",
		StationID:$("#StationID").val(), 
		Desc:$("#SLDesc").val(),
		LocID:LocID
		
	});	
	
	
}

//����
function BLAdd_click()
 {
	 var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert('��ʾ',"��ѡ����Ҫά����վ��",'info');
		return;
	}

	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TSLID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSLID: '',
		TSLDesc: '',
	});
	
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow',lastIndex);
	$('#StationLocGrid').datagrid('beginEdit',lastIndex);
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
				field: 'TSLDesc'  
		});
		
	}
 }

//����
function BLSave_click()
{ 
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('��ʾ', "��ѡ������������", 'info');
		return;
	}

	if (selected) {
			
		if (selected.TSLID == "") {
			if ((selected.TSLDesc == "undefined")||(selected.TSLDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "UpdateStationLoc",
				StationID: $("#StationID").val(),
				LocDesc: selected.TSLDesc
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				}

				$("#StationLocGrid").datagrid('reload');
			});
		} else {
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
			if ((selected.TSLDesc == "undefined")||(selected.TSLDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "UpdateStationLoc",
				ID: selected.TSLID,
				LocDesc: selected.TSLDesc	
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});	
				}
			 $("#StationLocGrid").datagrid('reload');
			});
		}
	}
}



var StationLocColumns = [[
	{
		field:'TSLID',
		title:'TSLID',
		hidden:true
	},{  
		field:'TSLDesc',
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
	},{ field:'TEffPowerFlag',width:'100',align:'center',title:'��ǰ������Ȩ',
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

// ��ʼ������վ������ά��DataGrid
function InitStationLocGrid()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
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
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStationLocNew",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:LocID

			
		},
		onSelect: function (rowIndex, rowData) {
			if(rowIndex!="-1"){
				$('#STLocID').val(rowData.TSLID)
			}
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}
 
 function LoadStationLocGrid(StationID){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];

	 $("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStationLocNew",
		StationID:StationID,
		LocID:LocID
	});	
 }

/*******************************վ�����ά��end*************************************/


/*******************************վ��start******************************************/

// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
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
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',title:'����',width: 70},
			{field:'TDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationNew",
			LocID:LocID	
			
		},
		onSelect: function (rowIndex,rowData) {
			$("#StationID").val(rowData.TID)
			LoadStationLocGrid(rowData.TID)

		},
		onLoadSuccess: function (data) {
			
		}
	});
	
}


//��ѯ��վ�㣩

function BFind_click(){
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStation",
		Desc:$("#Desc").val(),
		LocID:LocID
	});
}
/*******************************վ��end*************************************/

