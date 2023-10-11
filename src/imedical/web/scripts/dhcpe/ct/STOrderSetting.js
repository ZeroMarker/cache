/*
 * FileName: STOrderSetting.js
 * Author: zhufei
 * Date: 2021-12-07
 * Description: վ��ҽ��������
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];
var Public_gridsearch3 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){
	//��ʼ�����
    InitGridSTOrder();
    InitGridARCIM();
	$('#gridSTOrder').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridARCIM').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	
	$('#gridSTOrder_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridSTOrder"),value,Public_gridsearch1);
		}
	});
	
	$('#gridARCIM_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridARCIM"),value,Public_gridsearch2);
		}
	});
	
	//��ȡ���������б�
	GetLocComp(SessionStr);
	Common_ComboToExamItemCode("cboExamItemCode2"); //��׼��Ŀ
	Common_ComboToReportFormat("cboReportFormat2");	//�����ʽ
	
	//��������
	$HUI.combobox('#LocList',{
	    onSelect:function(row){
			//����վ�������б�
			Common_ComboToStation("cboStation");
			//����ҽ�����������б�
			Common_ComboToARCIC("cboARCItemCat");
			//�������ﵥ��������б�
			Common_ComboToUsherItemCat("cboUsherItemCat");
			Common_ComboToUsherItemCat("cboUsherItemCat2");
	    }
    });
	
	//վ������
	$HUI.combobox('#cboStation',{
	    onSelect:function(row){
			LoadGridSTOrder();
	    }
    });
	
	//ҽ����������
	$HUI.combobox('#cboARCItemCat',{
	    onSelect:function(row){
			LoadGridARCIM();
	    }
    });
	
	
    //����
    $("#btnSetting").click(function() {
		/***ֻ�ܵ������� start***/
		//var ARCIMID = $("#gridARCIM_ID").val();
		//AddSTOrder(ARCIMID);
		/***ֻ�ܵ������� end***/

		/***֧���������� start***/
		var UserID=session['LOGON.USERID'];

		var LocID = $("#LocList").combobox('getValue');
		if (!LocID){
			$.messager.alert('��ʾ', "��ѡ�����", 'info');
       	 	return;
		}
		var ARCICID = $("#cboARCItemCat").combobox('getValue');
		if (!ARCICID){
			$.messager.alert('��ʾ', "��ѡ��ҽ���ӷ���", 'info');
        	return;
		}
		
    	var ARCIMIDStr=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
    	if(ARCIMIDStr==""){
	    	$.messager.alert('��ʾ', "�빴ѡҽ���", 'info');
        	return;
    	}
    	var ARCIMIDArr=ARCIMIDStr.split("^");
    	var ARCIMLength=ARCIMIDStr.split("^").length;
	    for ( var i = 1; i <=ARCIMLength; i++) {
		    if(i==ARCIMLength){ 
			    //ѡ�����Ŀ���óɹ�������ѡ�е�ҽ����
    			var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,"");
    			LoadGridARCIM()    
		    }else{
		    	AddSTOrder(ARCIMIDArr[i]);
		    }
		    
		    
	    } 
		/***֧���������� end***/

    });
	
    //ɾ��
    $("#btnDelete").click(function() {
		var ID = $("#gridSTOrder_ID").val();
		DeleteSTOrder(ID);
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridSTOrder').datagrid('getSelected');
		winExamItemCodeEdit_layer(rd);
    });
	
    //����վ����Ŀ
    $("#btnNewStationOrder").click(function() {
		var ID = $("#gridSTOrder_ID").val();
		NewStationOrder(ID);
    });
	
    //��������վ����Ŀ
    $("#btnBatchNewStationOrder").click(function() {
		BatchNewStationOrder();
    });
	
	//������-��ʼ��
	InitWinExamItemCodeEdit();
})

//����վ����Ŀ
function NewStationOrder(ID){
	if (!ID){
		$.messager.alert('��ʾ', "��ѡ������վ����Ŀ��¼", 'info');
        return;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫ����վ����Ŀ��¼��", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "NewStationOrder",
				aID:ID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					if (parseInt(rtn)==-100) {
						$.messager.alert('��ʾ', 'վ��ҽ������Ч', 'error');
					} else if (parseInt(rtn)==-101) {
						$.messager.alert('��ʾ', 'վ��ҽ�������ò������ظ�����վ����Ŀ', 'error');
					} else if (parseInt(rtn)==-102) {
						$.messager.alert('��ʾ', '�Ѵ���վ����Ŀ�����Ϣ���������ظ����', 'error');
					} else if (parseInt(rtn)==-103) {
						$.messager.alert('��ʾ', '��������Ŀ���������׼��Ŀ', 'error');
					}else {
						$.messager.alert('��ʾ', '����վ����Ŀʧ��', 'error');
					}
				} else {
					$.messager.popover({msg:'����վ����Ŀ�ɹ�',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//��������վ����Ŀ
function BatchNewStationOrder(){
	var LocID = $("#LocList").combobox('getValue');
	var StationID = $("#cboStation").combobox('getValue');
	if (!LocID){
		$.messager.alert('��ʾ', "��ѡ�����ɿ���", 'info');
        return;
	}
	if (!StationID){
		$.messager.alert('��ʾ', "��ѡ������վ��", 'info');
        return;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫ��������վ����Ŀ��", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "BatchNewStationOrder",
				aLocID:LocID,
				aStationID:StationID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					$.messager.alert('��ʾ', '��������վ����Ŀʧ��', 'error');
				} else {
					$.messager.popover({msg:'��������վ����Ŀ�ɹ�',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//���ò���
function AddSTOrder(ARCIMID){
	if (!ARCIMID){
		$.messager.alert('��ʾ', "��ѡ������ҽ����", 'info');
        return;
	}
	var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('��ʾ', "��ѡ�����", 'info');
        return;
	}
	var StationID = $("#cboStation").combobox('getValue');
	if (!StationID){
		$.messager.alert('��ʾ', "��ѡ��վ��", 'info');
        return;
	}
    var ItemCode = Common_GetValue("cboExamItemCode2");
    var ItemDesc = Common_GetText("cboExamItemCode2");
    var ReportFormat = Common_GetValue("cboReportFormat2");
	if (!ReportFormat){
		$.messager.alert('��ʾ', "��ѡ�񱨸��ʽ", 'info');
        return;
	}
    var UsherItemCatDR = Common_GetValue("cboUsherItemCat2");
	if (!UsherItemCatDR){
		$.messager.alert('��ʾ', "��ѡ���ﵥ���", 'info');
        return;
	}
	var InputStr = ARCIMID + "^" + LocID + "^" + StationID + "^" + session['LOGON.USERID'] + "^" + ItemCode + "^" + ItemDesc + "^" + ReportFormat + "^" + UsherItemCatDR;
	
	$.m({
		ClassName: "web.DHCPE.CT.STOrderSetting",
		MethodName: "AddSTOrder",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			if (parseInt(rtn)==-101){
				$.messager.alert('��ʾ', 'վ��ҽ�����¼�������ظ����', 'error');
			} else if (parseInt(rtn)==-102){
				$.messager.alert('��ʾ', '�Ѵ���վ����Ŀ�����Ϣ���������ظ����', 'error');
			} else if (parseInt(rtn)==-103){
				$.messager.alert('��ʾ', 'ҽ������վ�㲻�������������', 'error');
			} else {
				$.messager.alert('��ʾ', 'վ��ҽ�������ʧ��', 'error');
			}
		} else {
			$.messager.popover({msg:'վ��ҽ������ӳɹ�',type:'success',timeout: 1000});
			LoadGridSTOrder();
		}
	})
}

//ɾ������
function DeleteSTOrder(ID){
	if (!ID){
		$.messager.alert('��ʾ', "��ѡ��ɾ����¼", 'info');
        return;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ����¼��", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "DeleteSTOrder",
				aId:ID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					if (parseInt(rtn)==-101) {
						$.messager.alert('��ʾ', '������վ����Ŀ������ɾ��', 'error');
					} else {
						$.messager.alert('��ʾ', 'ɾ��վ��ҽ����ʧ��', 'error');
					}
				} else {
					$.messager.popover({msg:'ɾ��վ��ҽ����ɹ�',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//������-�������
function winExamItemCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var OrderType = Common_GetValue("cboOrderType");
    var ItemCode = Common_GetValue("cboExamItemCode");
    var ItemDesc = Common_GetText("cboExamItemCode");
    var Active = (Common_GetValue("chkActive") ? 'Y' : 'N');
    var ReportFormat = Common_GetValue("cboReportFormat");
    var UsherItemCatDR = Common_GetValue("cboUsherItemCat");
	
	if (!ReportFormat){
		$.messager.alert('��ʾ', "��ѡ�񱨸��ʽ", 'info');
        return;
	}
	if (!UsherItemCatDR){
		$.messager.alert('��ʾ', "��ѡ���ﵥ���", 'info');
        return;
	}
	var InputStr = ID + "^" + OrderType + "^" + ItemCode + "^" + ItemDesc + "^" + Active + "^" + session['LOGON.USERID'] + "^" + ReportFormat + "^" + UsherItemCatDR;
	
	$.m({
		ClassName: "web.DHCPE.CT.STOrderSetting",
		MethodName: "EditSTOrder",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			if (parseInt(rtn)==-101) {
				$.messager.alert('��ʾ', '������վ����Ŀ������༭', 'error');
			}
			$.messager.alert('��ʾ', '�༭վ��ҽ����ʧ��', 'error');
		} else {
			$.messager.popover({msg:'�༭վ��ҽ����ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winExamItemCodeEdit').close();
			LoadGridSTOrder();
		}
	})
}

//������-Open����
function winExamItemCodeEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('chkActive',(rd['Active']=='Y'));
		//Common_SetValue('cboOrderType',rd['OrderType'],rd['OrderTypeDesc']);
		//Common_SetValue('cboExamItemCode',rd['ItemCode'],rd['ItemDesc']);
		//Common_SetValue('cboReportFormat',rd['ReportFormat'],rd['ReportFormatDesc']);
		//Common_SetValue('cboUsherItemCat',rd['UsherItemCatID'],rd['UsherItemCatDesc']);
		$("#cboOrderType").combobox('select',rd['OrderType']);
		$("#cboExamItemCode").combobox('select',rd['ItemCode']);
		$("#cboReportFormat").combobox('select',rd['ReportFormat']);
		$("#cboUsherItemCat").combobox('select',rd['UsherItemCatID']);
	}else{
		Public_layer_ID = "";
		Common_SetValue('chkActive',0);
		Common_SetValue('cboOrderType','','');
		Common_SetValue('cboExamItemCode','','');
		Common_SetValue('cboReportFormat','','');
		Common_SetValue('cboUsherItemCat','','');
	}
	$HUI.dialog('#winExamItemCodeEdit').open();
}

function InitWinExamItemCodeEdit(){
	//��ʼ���༭��
	$('#winExamItemCodeEdit').dialog({
		title: '��׼��Ŀ',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: $g('����'),
			handler:function(){
				winExamItemCodeEdit_btnSave_click();
			}
		},{
			text:$g('�ر�'),
			handler:function(){
				$HUI.dialog('#winExamItemCodeEdit').close();
			}
		}]
	});
	//��ʼ�����ؼ���������
	Common_ComboToOrderType("cboOrderType");
	Common_ComboToExamItemCode("cboExamItemCode");
	Common_ComboToReportFormat("cboReportFormat");	//�����ʽ
	Common_ComboToUsherItemCat("cboUsherItemCat");	//���ﵥ���
}

function LoadGridSTOrder(){
	$('#gridSTOrder').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"web.DHCPE.CT.STOrderSetting",
		QueryName:"QrySTOrder",
		aLocID:$("#LocList").combobox('getValue'),
		aStationID:$("#cboStation").combobox('getValue'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridSTOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridSTOrder(){
    // ��ʼ��DataGrid
    $('#gridSTOrder').datagrid({
		fit: true,
		//title: "վ��ҽ����",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //�����Ƿ���ʾ���������
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			,{ field:'ItmMastDR', width: 80, title:'ҽ����ID', sortable: true, resizable: true}
			,{ field:'ItmMastDesc', width: 180, title:'ҽ����', sortable: true, resizable: true}
			//,{ field:'LocDesc', width: 60, title:'����', sortable: true, resizable: true}
			,{ field:'ItmCatDesc', width: 80, title:'ҽ������', sortable: true, resizable: true}
			,{ field:'OrderTypeDesc', width: 60, title:$g('ҽ��<br>����'), sortable: true, resizable: true}
			,{ field:'StationDesc', width: 80, title:'վ��', sortable: true, resizable: true}
			,{ field:'ReportFormatDesc', width: 100, title:'�����ʽ', sortable: true, resizable: true}
			,{ field:'UsherItemCatDesc', width: 100, title:'���ﵥ���', sortable: true, resizable: true}
			,{ field:'ItemDesc', width: 100, title:'��׼�����Ŀ', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:$g('�Ƿ�<br>��Ч'), sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'��������', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
			,{ field:'UpdateUser', width: 80, title:'������', sortable: true, resizable: true}
			,{ field:'NewOrdFlagDesc', width: 50, title:$g('����<br>���'), sortable: true, resizable: true}
			,{ field:'NewOrdDate', width: 90, title:'��������', sortable: true, resizable: true}
			,{ field:'NewOrdTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
			,{ field:'NewOrdUser', width: 80, title:'������', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate").linkbutton("disable");
					$("#btnDelete").linkbutton("disable");
					$("#btnNewStationOrder").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate").linkbutton("enable");
					$("#btnDelete").linkbutton("enable");
					$("#btnNewStationOrder").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winExamItemCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch1 = [];
			$("#btnUpdate").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnNewStationOrder").linkbutton("disable");
			$("#btnBatchNewStationOrder").linkbutton("enable");
        }
    });
}


function LoadGridARCIM(){
	//$('#gridARCIM').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"web.DHCPE.CT.STOrderSetting",
		QueryName:"QryARCIM",
		aLocID:$("#LocList").combobox('getValue'),
		aARCICID:$("#cboARCItemCat").combobox('getValue'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridARCIM').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
		//$('#gridARCIM').datagrid().datagrid('loadData', rs);
		var LocID = $("#LocList").combobox('getValue');
	var ARCICID = $("#cboARCItemCat").combobox('getValue');
	       
    $("#gridARCIM").datagrid('unselectAll');
	var info=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
		var objtbl = $("#gridARCIM").datagrid('getRows');
		if (objtbl) {
		 	//����datagrid����            
		 		$.each(objtbl, function (index) { 
		 		
	        		if(info.indexOf("^"+objtbl[index].ID+"^")>=0){
		        		//alert(objtbl[index].ID)
				 		//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
				 		$('#gridARCIM').datagrid('checkRow',index);
					 }
			   });
		}
			
	});

}

function InitGridARCIM(){
    // ��ʼ��DataGrid
    $('#gridARCIM').datagrid({
		fit: true,
		//title: "ҽ�����б�",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect:false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //�����Ƿ���ʾ���������
        columns: [[
             { field:'ID', checkbox:true }
			,{ field:'Desc', width: 240, title:'ҽ��������', sortable: true, resizable: true}
			,{ field:'OrderTypeDesc', width: 50, title:$g('ҽ��<br>����'), sortable: true, resizable: true}
			,{ field:'ItmCatDesc', width: 80, title:'ҽ������', sortable: true, resizable: true}
			,{ field:'OrdCatDesc', width: 80, title:'ҽ������', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnSetting").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnSetting").linkbutton("enable");
				}
			}
        },
		 //ѡ���к���
		onCheck:function(rowIndex,rowData){
				AddSelectItem(rowIndex,rowData); 
				
			},
        //ȡ��ѡ���к���	
		onUncheck:function(rowIndex,rowData){
				RemoveSelectItem(rowIndex,rowData);
			},
		onCheckAll: function (rows) { 
				//����datagrid���� 
		 		$.each(rows, function (index) {
			 		$('#gridARCIM').datagrid('checkRow',index);
			 	});
			 		
				
		},
		onUncheckAll: function (rows) { 
				//����datagrid���� 
		 		$.each(rows, function (index) {
			 		$('#gridARCIM').datagrid('uncheckRow',index);
			 	});	 		
				
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				var ARCIMID = rowData["ID"];
				AddSTOrder(ARCIMID);
			}
		},
        onLoadSuccess: function (rowData) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch2 = [];
			$("#btnSetting").linkbutton("disable");
			
			var LocID = $("#LocList").combobox('getValue');
	        var ARCICID = $("#cboARCItemCat").combobox('getValue');
			$("#gridARCIM").datagrid('unselectAll');
			var info=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
	    	var objtbl = $("#gridARCIM").datagrid('getRows');
	        if (rowData) {
		         //����datagrid����            
		 		$.each(rowData.rows, function (index) { 
	        		if(info.indexOf(objtbl[index].ID)>=0){
				 		//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
				 		$('#gridARCIM').datagrid('checkRow',index);
					 }
			   });
	        }
        }
    });
}
var SelectItems=[];

function FindSelectItem(ID) { 
 	//alert("SelectItems.length:"+SelectItems.length)
      for (var i = 0; i < SelectItems.length; i++) { 
            if (SelectItems[i] == ID) return i; 
         } 
       return -1; 
  } 

function AddSelectItem(rowIndex,rowData)
{
	 var SelectIds="";
	
     if (FindSelectItem(rowData.ID) == -1) { 
         SelectItems.push(rowData.ID);  	
      }
                
      for (var i = 0; i < SelectItems.length; i++) { 
          if(SelectIds==""){
	          var SelectIds="^"+SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }
               
       }              
    
    var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('��ʾ', "��ѡ�����", 'info');
        return;
	}
    var ARCICID = $("#cboARCItemCat").combobox('getValue');
	if (!ARCICID){
		$.messager.alert('��ʾ', "��ѡ��ҽ���ӷ���", 'info');
        return;
	}
	if(SelectIds!=""){
		$("#btnSetting").linkbutton("enable");
	}else{
		$("#btnSetting").linkbutton("disable");
	}
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,SelectIds);
	  
}

function RemoveSelectItem(rowIndex, rowData) { 

    var SelectIds="";
    
    var k = FindSelectItem(rowData.ID); 
    
    if (k != -1) { 
             SelectItems.splice(k,1);
      } 
      
     
    for (var i = 0; i < SelectItems.length; i++) { 
           if(SelectIds==""){
	          var SelectIds="^"+SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }  
      }
      
	 if(SelectIds=="^"){var SelectIds="";}
	
	 if(SelectIds!=""){
		$("#btnSetting").linkbutton("enable");
	}else{
		$("#btnSetting").linkbutton("disable");
	}
    var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('��ʾ', "��ѡ�����", 'info');
        return;
	}
	var ARCICID = $("#cboARCItemCat").combobox('getValue');
	if (!ARCICID){
		$.messager.alert('��ʾ', "��ѡ��ҽ���ӷ���", 'info');
        return;
	}
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,SelectIds);
                     
  } 
 
//����վ��������
function Common_ComboToStation(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		allowNull: true,
		valueField: 'TID',
		textField: 'TDesc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'web.DHCPE.CT.Station';
			param.QueryName = 'FindStation';
			param.Code = "";
			param.Desc = "";
			param.LocID = $("#LocList").combobox('getValue');
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['TID']);
			}
		}
	});
	return  cbox;
}

//����ҽ������������
function Common_ComboToARCIC(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		allowNull: true,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'web.DHCPE.CT.STOrderSetting';
			param.QueryName = 'QryARCIC';
			param.aLocID = $("#LocList").combobox('getValue');
			param.aAlias = "";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	return  cbox;
}

//������׼��Ŀ������
function Common_ComboToExamItemCode(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		allowNull: true,
		valueField: 'Code',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'web.DHCPE.CT.STOrderSetting';
			param.QueryName = 'QryExamItemCode';
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['Code']);
			}
		}
	});
	return  cbox;
}

//�������ݸ�ʽ������
function Common_ComboToOrderType(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: $g('����'), Code: 'L' }
			,{ Desc: $g('���'), Code: 'X' }
			,{ Desc: $g('ҩƷ'), Code: 'R' }
			,{ Desc: $g('�Ĳ�'), Code: 'M' }
			,{ Desc: $g('����'), Code: 'N' }
		],
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['Code']);
			}
		},
		defaultFilter:0
	});
	return  cbox;
}

//�������ﵥ���������
function Common_ComboToUsherItemCat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		allowNull: true,
		valueField: 'id',
		textField: 'desc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'web.DHCPE.CT.HISUICommon';
			param.QueryName = 'FindPatItem';
			param.LocID = $("#LocList").combobox('getValue');
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['id']);
			}
		}
	});
	return  cbox;
}

//���������ʽ������
function Common_ComboToReportFormat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Code: 'RF_CAT', Desc: $g('��ӡ��ʽ ���') }
			,{ Code: 'RF_LIS', Desc: $g('��ӡ��ʽ ����')}
			,{ Code: 'RF_NOR', Desc: $g('��ӡ��ʽ Ĭ��')}
			,{ Code: 'RF_RIS', Desc: $g('��ӡ��ʽ ���')}
			,{ Code: 'RF_EKG', Desc: $g('��ӡ��ʽ �ĵ�')}
			,{ Code: 'RF_PIS', Desc: $g('��ӡ��ʽ ����')}
		],
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['Code']);
			}
		},
		defaultFilter:0
	});
	return  cbox;
}

