var editIndex;
var bpBERowId;
var selectBpIndex;


$(function(){
	InitFormItem();
	InitGroupData();
});
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
function InitFormItem()
{
	//��λ
	var cmbbed=$HUI.combobox("#bpbeBedDr",{
        url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBPCBed&ResultSetType=array",
        valueField:"tRowId",
        textField:"tBPCBDesc",
        onHidePanel: function () {
        	OnHidePanel("#bpbeBedDr");
        },
        onBeforeLoad:function(param)
        {

        }   
    });
    //�豸
    var cmbBPCEquip=$HUI.combobox("#bpbeBPCEquipDr",{
        url:$URL+"?ClassName=web.DHCBPCEquip&QueryName=FindEquip&ResultSetType=array",
        valueField:"tBPCERowId",
        textField:"tBPCEDesc",
        onHidePanel: function () {
        	OnHidePanel("#bpbeBPCEquipDr");
        },
        onBeforeLoad:function(param)
        {
            param.BPCEBPCEquipModelDr="";
            param.PurchaseDate="";
            param.BPCECode="";
            param.BPCENo="";
            param.Status="";
        }   
    })
	//�ɼ�����
	var cmbCollectType=$HUI.combobox("#bpbeCollectTypeDr",{
        url:$URL+"?ClassName=web.DHCANCCollectType&QueryName=FindDHCANCCollectType&ResultSetType=array",
        valueField:"trowid",
        textField:"tDesc",
        onHidePanel: function () {
        	OnHidePanel("#bpbeCollectTypeDr");
        },
        onBeforeLoad:function(param)
        {
            param.fltStr=""
            param.bedRowId="";
            param.Source="B";
        }   
    });
    //�Ƿ�����
    var cmbIfConnected=$HUI.combobox("#bpbeIfConnected",{
        url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBoolen&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        onHidePanel: function () {
        	OnHidePanel("#bpbeIfConnected");
        },
         onBeforeLoad:function(param)
        {
        }   
    });
    //��λ
	var cmbbed=$HUI.combobox("#FbpbeBedDr",{
        url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBPCBed&ResultSetType=array",
        valueField:"tRowId",
        textField:"tBPCBDesc",
        onHidePanel: function () {
        	OnHidePanel("#FbpbeBedDr");
        },
        onBeforeLoad:function(param)
        {

        }   
    });
    //�豸
    var cmbBPCEquip=$HUI.combobox("#FbpbeBPCEquipDr",{
        url:$URL+"?ClassName=web.DHCBPCEquip&QueryName=FindEquip&ResultSetType=array",
        valueField:"tBPCERowId",
        textField:"tBPCEDesc",        
         onBeforeLoad:function(param)
        {
            param.BPCEBPCEquipModelDr="";
            param.PurchaseDate="";
            param.BPCECode="";
            param.BPCENo="";
            param.Status="";
        },
        onHidePanel: function () {
        	OnHidePanel("#FbpbeBPCEquipDr");
        }, 
    })
	//�ɼ�����
	var cmbCollectType=$HUI.combobox("#FbpbeCollectTypeDr",{
        url:$URL+"?ClassName=web.DHCANCCollectType&QueryName=FindDHCANCCollectType&ResultSetType=array",
        valueField:"trowid",
        textField:"tDesc",
        panelHeight:"auto",
        onBeforeLoad:function(param)
        {
            param.fltStr=""
            param.bedRowId="";
            param.Source="";
        },
        onHidePanel: function () {
        	OnHidePanel("#FbpbeCollectTypeDr");
        },    
    });
    //�Ƿ�����
    var cmbIfConnected=$HUI.combobox("#FbpbeIfConnected",{
        url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBoolen&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        panelHeight:"auto",
        onHidePanel: function () {
        	OnHidePanel("#FbpbeIfConnected");
        },
        onBeforeLoad:function(param)
        {
        }   
    });
}

function InitGroupData()
{
	    $("#bedequipListData").datagrid({
		url:$URL,
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		//checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		//selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,        
        queryParams:{
            ClassName:"web.DHCBPBedEquip",
            QueryName:"FindBedEquip"
        },
        onBeforeLoad: function(param) {
	        param.bed=$("#bpbeBedDr").combobox('getText');
	        param.equip=$("#bpbeBPCEquipDr").combobox('getText');
	        param.hospId=session['LOGON.HOSPID']
        },
        columns:[
            [
               {field: "tBPBEBed", title: "��λ", width: 60, sortable: true},
               {field: "tBPBEBPCEquip", title: "�豸", width: 60, sortable: true},
               {field: "tBPBETcpipAddress", title: "�豸IP", width: 60, sortable: true},
               {field: "tBPBEPort", title: "�豸�˿�", width: 60, sortable: true},
               {field: "tBPBECollectType", title: "�ɼ�����", width: 60, sortable: true},
               {field: "tBPBEDefaultInterval", title: "ȱʡ�������", width: 60, sortable: true},
               {field: "tBPBEEditTcpipAddress", title: "�༭����IP", width: 60, sortable: true},
               {field: "tBPBEIfConnected", title: "�Ƿ�����", width: 60, sortable: true},
		    	{field:'tBPBEIfConnectedB',title:'tBPBEIfConnectedB',width:50,hidden:true},
		    	{field:'tBPBECollectTypeDr',title:'tBPBECollectTypeDr',width:50,hidden:true},
		    	{field:'tBPBEBedDr',title:'tBPBEBedDr',width:50,hidden:true},
		    	{field:'tBPBERowId',title:'tID',width:50,hidden:true},
		    	{field:'tBPBEBPCEquipDr',title:'tBPBEBPCEquipDr',width:50,hidden:true}

            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�޸�',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'ɾ��',
			    handler: function(){
                    deleteRow();
                }
            }
        ],
        onSelect:function(rowIndex, rowData){
	        selectBpIndex=rowIndex;
	        bpBERowId=rowData.tBPBERowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#bedequipListData").reload();
    });
}
function InitOperDiag()
{
	$('#FbpbeBedDr').combobox("reload");
	$('#FbpbeBedDr').combobox('setValue',"");
	$('#FbpbeBPCEquipDr').combobox("reload");
	$('#FbpbeCollectTypeDr').combobox("reload");
	$('#FbpbeIfConnected').combobox("reload");

}
//����
function appendRow()
{
	    $("#bedequipDlg").dialog({
        title: "���������໤�豸",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#bedequipDlg").dialog("open");

}
function editRow()
{
	var selectRow=$("#bedequipListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#bedequipDlg").dialog({
            title: "�޸ľ����໤�豸",
            iconCls: "icon-w-edit"
        });
        var bedDr=selectRow.tBPBEBedDr;
        var equipDr=selectRow.tBPBEBPCEquipDr;
        var tcpip=selectRow.tBPBETcpipAddress;
        var port=selectRow.tBPBEPort;
        var collectTypeDr=selectRow.tBPBECollectTypeDr;
        var defaultInterval=selectRow.tBPBEDefaultInterval;
        var editTcpip=selectRow.tBPBEEditTcpipAddress;
        var ifConnectedBDr=selectRow.tBPBEIfConnectedB;
        var bpBERowId=selectRow.tBPBERowId;
        $("#FbpbeBedDr").combobox('setValue',bedDr)        
        $("#FbpbeBPCEquipDr").combobox('setValue',equipDr)
        $("#FbpbeTcpipAddress").val(tcpip);
        $("#FbpbePort").val(port);
        $("#FbpbeCollectTypeDr").combobox('setValue',collectTypeDr)
        $("#FbpbeDefaultInterval").val(defaultInterval);
        $("#FbpbeEditTcpipAddress").val(editTcpip);
        $("#FbpbeIfConnected").combobox('setValue',ifConnectedBDr)         
        
        $("#bedequipDlg").window("open");
        $("#EditBedEquip").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#bedequipListData").datagrid("getSelected");
    if(selectRow)
    {	    
	    var datas=$.m({
        ClassName:"web.DHCBPBedEquip",
        MethodName:"DeleteBedEquip",
        bpbeRowId:selectRow.tBPBERowId,
        equipID:selectRow.tBPBEBPCEquipDr,
    },false);
    if(datas==0)
    {
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#bedequipListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
        return;
    }	
}
function saveBedEquip()
{

	var bedDr=$("#FbpbeBedDr").combobox('getValue');
	var bed=$("#FbpbeBedDr").combobox('getText');
	var equipDr=$("#FbpbeBPCEquipDr").combobox('getValue');
	var equip=$("#FbpbeBPCEquipDr").combobox('getText');
	var tcpip=$("#FbpbeTcpipAddress").val();
    var port=$("#FbpbePort").val();
    var collectTypeDr=$("#FbpbeCollectTypeDr").combobox('getValue');
    var collectType=$("#FbpbeCollectTypeDr").combobox('getText');
    var defaultInterval=$("#FbpbeDefaultInterval").val();
    var editTcpip=$("#FbpbeEditTcpipAddress").val();
    var ifConnectedBDr=$("#FbpbeIfConnected").combobox('getValue'); 
    var ifConnectedB=$("#FbpbeIfConnected").combobox('getText'); 
    if($("#FbpbeBedDr").combobox('getValue')==""){
		$.messager.alert("��ʾ","��λ����Ϊ��","error");
		return;
	}
	if($("#FbpbeBPCEquipDr").combobox('getValue')==""){
		$.messager.alert("��ʾ","�豸����Ϊ��","error");
		return;
	}	
    var rowdata={
	    tBPBEBed:bed,	    
	    tBPBEBPCEquip:equip,
	    tBPBEPort:port,
        tBPBETcpipAddress:tcpip,
        tBPBECollectType:collectType,
        tBPBEDefaultInterval:defaultInterval,
        tBPBEEditTcpipAddress:editTcpip,
    	tBPBEIfConnected:ifConnectedB,
    	tBPBEBedDr:bedDr, 
    	tBPBEBPCEquipDr:equipDr,   
    	tBPBECollectTypeDr:collectTypeDr,       
        tBPBEIfConnectedB:ifConnectedBDr,           
    }	    	
    if($("#EditBedEquip").val()=="Y")
    {
    	var datas=$.m({
        ClassName:"web.DHCBPBedEquip",
        MethodName:"UpdateBedEquip",
        bpbeRowId:bpBERowId,
        bpbeBedDr:bedDr,
        bpbeBPCEquipDr:equipDr,
        bpbeTcpipAddress:tcpip,
        bpbePort:port,
        bpbeCollectTypeDr:collectTypeDr,
        bpbeDefaultInterval:defaultInterval,
        bpbeEditTcpipAddress:editTcpip,
        bpbeIfConnected:ifConnectedBDr,
        hospId:session['LOGON.HOSPID']
    	},false);
    	if (datas==0)
    	{
    		$HUI.datagrid("#bedequipListData").updateRow({index:selectBpIndex,row:rowdata});
    		$.messager.alert("��ʾ", "��ӳɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCBPBedEquip",
        MethodName:"InsertBedEquip",
        bpbeBedDr:bedDr,
        bpbeBPCEquipDr:equipDr,
        bpbeTcpipAddress:tcpip,
        bpbePort:port,
        bpbeCollectTypeDr:collectTypeDr,
        bpbeDefaultInterval:defaultInterval,
        bpbeEditTcpipAddress:editTcpip,
        bpbeIfConnected:ifConnectedBDr,
        hospId:session['LOGON.HOSPID']
    	},false);
    	if (datas==0)
    	{	    	
    		$HUI.datagrid("#bedequipListData").appendRow(rowdata);
    		$.messager.alert("��ʾ", "��ӳɹ���", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("��ʾ", datas, 'error');
        	return;
	    }
    }
     $("#bedequipListData").datagrid("reload");
	$HUI.dialog("#bedequipDlg").close();	
}
