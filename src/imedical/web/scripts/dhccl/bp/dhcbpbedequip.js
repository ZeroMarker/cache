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
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
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
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
function InitFormItem()
{
	//床位
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
    //设备
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
	//采集代码
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
    //是否连接
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
    //床位
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
    //设备
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
	//采集代码
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
    //是否连接
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
		//checkOnSelect:true,	///easyui取消单击行选中状态
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
               {field: "tBPBEBed", title: "床位", width: 60, sortable: true},
               {field: "tBPBEBPCEquip", title: "设备", width: 60, sortable: true},
               {field: "tBPBETcpipAddress", title: "设备IP", width: 60, sortable: true},
               {field: "tBPBEPort", title: "设备端口", width: 60, sortable: true},
               {field: "tBPBECollectType", title: "采集代码", width: 60, sortable: true},
               {field: "tBPBEDefaultInterval", title: "缺省采样间隔", width: 60, sortable: true},
               {field: "tBPBEEditTcpipAddress", title: "编辑电脑IP", width: 60, sortable: true},
               {field: "tBPBEIfConnected", title: "是否连接", width: 60, sortable: true},
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
			    text:'新增',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'修改',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'删除',
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
//新增
function appendRow()
{
	    $("#bedequipDlg").dialog({
        title: "新增净化监护设备",
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
            title: "修改净化监护设备",
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
        $.messager.alert("提示", "请先选择要修改的记录！", 'error');
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
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#bedequipListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'error');
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
		$.messager.alert("提示","床位不能为空","error");
		return;
	}
	if($("#FbpbeBPCEquipDr").combobox('getValue')==""){
		$.messager.alert("提示","设备不能为空","error");
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
    		$.messager.alert("提示", "添加成功！", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("提示", datas, 'error');
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
    		$.messager.alert("提示", "添加成功！", 'info');  
    	}
    	else
    	{
	    	$.messager.alert("提示", datas, 'error');
        	return;
	    }
    }
     $("#bedequipListData").datagrid("reload");
	$HUI.dialog("#bedequipDlg").close();	
}
