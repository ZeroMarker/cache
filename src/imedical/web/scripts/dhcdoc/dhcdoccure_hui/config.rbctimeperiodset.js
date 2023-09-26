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
		 $.messager.alert("错误", "代码不能为空", 'error')
        return false;
	}
	var DDCTSDesc=$("#DDCTSDesc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('Warning','时间段描述不能为空');   
        return false;
	}
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	if(DDCTSStartTime=="")
	{
		$.messager.alert('Warning','开始时间不能为空');   
        return false;
	}
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	if(DDCTSEndTime=="")
	{
		$.messager.alert('Warning','结束时间不能为空');   
        return false;
	}
	return true;
}
///修改表格函数
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
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			RBCTimePeriodSetDataLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="101") err="代码重复";
			else err=value;
			$.messager.alert('Warning',err);   
			return false;
		}
	});
}
///修改表格函数
function UpdateGridData(){
	var rows = PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelections");
	//PageLogicObj.CureRBCTimePeriodSetDataGrid.getSelections();
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
		//清空表单数据
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
     	$('#updateym').val("修改")    
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
function Init()
{
	var cureRBCTimePeriodSetToolBar = [
        {
			text: '增加',
			iconCls: 'icon-add',
			handler: function() { 
				$("#add-dialog").dialog("open");
				//清空表单数据
				$('#add-form').form("clear");
				$HUI.checkbox("#DDCTSNotAvailFlag",{
					checked:false	
				})
				$('#submitdata').val("添加")  
			}
		},
        /*{
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCTimePeriodSetDataGrid.getSelections();
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
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
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
							})							
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },*/{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},{
			text: '关联医院',
			iconCls: 'icon-house',
			handler: function() {
				ReHospitalHandle();
			}
		}];
	var cureRBCTimePeriodSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'代码', width: 200, sortable: true  
					},
        			{ field: 'Desc', title: '时间段描述', width: 250, sortable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 150, sortable: true, resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 150, sortable: true,resizable: true
					},
					{ field: 'EndChargeTime', title: '截止收费时间', width: 150, sortable: true,resizable: true
					},
					{ field: 'NotAvailFlag', title: '不可用标记', width: 150, sortable: true,resizable: true
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
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
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
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCTimePeriodSet",row["Rowid"])
	return;
	//采用基础平台插件
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
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'医院',width:100}
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
		$.messager.alert("提示","请选择一行！")
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
		$.messager.alert("提示","请选择医院","info");
		return false;
	}
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
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
			$.messager.alert("提示","增加重复","info");
		}else{
			$.messager.popover({msg: data.split("^")[1],type:'success',timeout: 1000});
			LoadReHospitalDataGrid();
		}
	})
}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("提示","请选择一行","info");
		return false;
	}
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
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
		$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
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