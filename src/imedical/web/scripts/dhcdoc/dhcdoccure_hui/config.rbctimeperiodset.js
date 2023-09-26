var PageLogicObj={
	CureRBCTimePeriodSetDataGrid:"",
	m_ReHospitalDataGrid:""
}
$(document).ready(function(){ 	
	PageLogicObj.CureRBCTimePeriodSetDataGrid=Init();
	InitEvent();
	InitHospUser();
	//RBCTimePeriodSetDataLoad();	
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		RBCTimePeriodSetDataLoad();	
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		if (!CheckDocCureUseBase()){
			return;
		}
		RBCTimePeriodSetDataLoad();	
	}	
}

function CheckDocCureUseBase(){
	var UserHospID=GetUserHospID();
	var DocCureUseBase=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode",
		Node: "DocCureUseBase",
		HospId:UserHospID,
		dataType:"text",
	},false);
	if (DocCureUseBase=="1"){
		$(".window-mask.alldom").show();
		return false;
	}else{
		$(".window-mask.alldom").hide();
		$(".hisui-layout").layout("resize");
		return true;
	}
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$("#ReHospital").click(ReHospitalHandle);
}

function CheckData(){
	var DDCTSCode=$("#DDCTSCode").val();
	if(DDCTSCode=="")
	{
		 $.messager.alert("����", "���벻��Ϊ��", 'error')
        return false;
	}
	var DDCTSDesc=$("#DDCTSDesc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('Warning','ʱ�����������Ϊ��');   
        return false;
	}
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	if(DDCTSStartTime=="")
	{
		$.messager.alert('Warning','��ʼʱ�䲻��Ϊ��');   
        return false;
	}
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	if(DDCTSEndTime=="")
	{
		$.messager.alert('Warning','����ʱ�䲻��Ϊ��');   
        return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
	if(!CheckData()) return false;    
	var DDCTSROWID=$("#DDCTSROWID").val();
	var DDCTSCode=$("#DDCTSCode").val();
	var DDCTSDesc=$("#DDCTSDesc").val();
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	var DDCTSEndChargeTime=$("#DDCTSEndChargeTime").val();
	var DDCTSNotAvailFlag="";
	if ($("#DDCTSNotAvailFlag").is(":checked")) {
		DDCTSNotAvailFlag="Y";
	}
	var InputPara=DDCTSROWID+"^"+DDCTSCode+"^"+DDCTSDesc+"^"+DDCTSStartTime+"^"+DDCTSEndTime+"^"+DDCTSEndChargeTime+"^"+DDCTSNotAvailFlag;
	 //alert(InputPara)
	 var UserHospID=GetUserHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
		MethodName:"SaveCureRBCTimePeriodSet",
		'value':InputPara,
		HospID:UserHospID
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			RBCTimePeriodSetDataLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�����ظ�";
			else err=value;
			$.messager.alert('Warning',err);   
			return false;
		}
	});
}
///�޸ı����
function UpdateGridData(){
	var rows = PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelections");
	//PageLogicObj.CureRBCTimePeriodSetDataGrid.getSelections();
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
		//��ձ�����
		$('#add-form').form("clear")
		if(rows[0].NotAvailFlag=="Y")
		{
		var NotAvailFlag=true
		}else{
		var NotAvailFlag=false
		}
		$HUI.checkbox("#DDCTSNotAvailFlag",{
				checked:NotAvailFlag	
		})
		$('#add-form').form("load",{
			DDCTSROWID:rows[0].Rowid,
			DDCTSCode:rows[0].Code,
			DDCTSDesc:rows[0].Desc,
			DDCTSStartTime:rows[0].StartTime,
			DDCTSEndTime:rows[0].EndTime,
			DDCTSEndChargeTime:rows[0].EndChargeTime	 
		})
     	$('#updateym').val("�޸�")    
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}
function Init()
{
	var cureRBCTimePeriodSetToolBar = [
        {
			text: '����',
			iconCls: 'icon-add',
			handler: function() { 
				$("#add-dialog").dialog("open");
				//��ձ�����
				$('#add-form').form("clear");
				$HUI.checkbox("#DDCTSNotAvailFlag",{
					checked:false	
				})
				$('#submitdata').val("���")  
			}
		},
        /*{
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCTimePeriodSetDataGrid.getSelections();
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
                            $.m({
								ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
								MethodName:"DeleteCureRBCTimePeriodSet",
								'Rowid':ID
							},function(value){
								if(value=="0"){
							       //PageLogicObj.CureRBCTimePeriodSetDataGrid.load();
							       RBCTimePeriodSetDataLoad();
           					       PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("unselectAll");
           					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						        }else{
							       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						        }
							})							
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },*/{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},{
			text: '����ҽԺ',
			iconCls: 'icon-house',
			handler: function() {
				ReHospitalHandle();
			}
		}];
	var cureRBCTimePeriodSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'����', width: 200, sortable: true  
					},
        			{ field: 'Desc', title: 'ʱ�������', width: 250, sortable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 150, sortable: true, resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 150, sortable: true,resizable: true
					},
					{ field: 'EndChargeTime', title: '��ֹ�շ�ʱ��', width: 150, sortable: true,resizable: true
					},
					{ field: 'NotAvailFlag', title: '�����ñ��', width: 150, sortable: true,resizable: true
					}
					
    			 ]];
	var CureRBCTimePeriodSetDataGrid=$("#tabCureRBCTimePeriodSet").datagrid({  //$HUI.datagrid("#tabCureRBCTimePeriodSet",{  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : $URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"Rowid",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :cureRBCTimePeriodSetColumns,
		toolbar:cureRBCTimePeriodSetToolBar,
		onClickRow:function(rowIndex, rowData){
			//PTRowid=rowData.Rowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       	}
	});
	//RBCTimePeriodSetDataLoad();
	return CureRBCTimePeriodSetDataGrid;
}
function RBCTimePeriodSetDataLoad()
{
	var UserHospID=GetUserHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
		QueryName:"QueryBookTime",
		HospID:UserHospID,
		Pagerows:PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
	
};

function ReHospitalHandle(){
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCTimePeriodSet",row["Rowid"])
	return;
	//���û���ƽ̨���
	$("#ReHospital-dialog").dialog("open");
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
	LoadReHospitalDataGrid();
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
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"DHC_DocCureRBCTimePeriodSet",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("��ʾ","��ѡ��ҽԺ","info");
		return false;
	}
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"DHC_DocCureRBCTimePeriodSet",
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
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"DHC_DocCureRBCTimePeriodSet",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
		LoadReHospitalDataGrid();
	})
	
}
function GetUserHospID(){
	var UserHospID="";
	if($('#_HospUserList').length>0){
		UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	}
	if ((!UserHospID)||(UserHospID=="")) {
		UserHospID=session['LOGON.HOSPID'];
	}
	return UserHospID
}