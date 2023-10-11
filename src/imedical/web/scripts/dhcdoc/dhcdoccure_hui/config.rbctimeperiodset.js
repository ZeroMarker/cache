var PageLogicObj={
	CureRBCTimePeriodSetDataGrid:"",
	CureRBCServiceGroupSetDataGrid:"",
	m_ReHospitalDataGrid:""
}
$(document).ready(function(){ 	
	InitHospUser();
	InitEvent();
	//RBCTimePeriodSetDataLoad();	
});	
function Init(){
	PageLogicObj.CureRBCTimePeriodSetDataGrid=InitCureRBCTimePeriodSetDataGrid();
	PageLogicObj.CureRBCServiceGroupSetDataGrid=InitRBCServiceGroupSetDataGrid();
}
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		RBCTimePeriodSetDataLoad();	
		CureRBCServiceGroupSetDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
		//RBCTimePeriodSetDataLoad();	
		//CureRBCServiceGroupSetDataGridLoad();
	}	
}

function CheckDocCureUseBase(){
	var UserHospID=GetUserHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
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
		 $.messager.alert("��ʾ", "���벻��Ϊ��","warning")
        return false;
	}
	var DDCTSDesc=$("#DDCTSDesc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('��ʾ','ʱ�����������Ϊ��',"warning");   
        return false;
	}
	var DDCTSStartTime=$("#DDCTSStartTime").val();
	if(DDCTSStartTime=="")
	{
		$.messager.alert('��ʾ','��ʼʱ�䲻��Ϊ��',"warning");   
        return false;
	}
	var DDCTSEndTime=$("#DDCTSEndTime").val();
	if(DDCTSEndTime=="")
	{
		$.messager.alert('��ʾ','����ʱ�䲻��Ϊ��',"warning");   
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
	var DDCTSEndAppointTime=$("#DDCTSEndAppointTime").val();
	var DDCTSNotAvailFlag="";
	if ($("#DDCTSNotAvailFlag").is(":checked")) {
		DDCTSNotAvailFlag="Y";
	}
	var InputPara=DDCTSROWID+"^"+DDCTSCode+"^"+DDCTSDesc+"^"+DDCTSStartTime+"^"+DDCTSEndTime+"^"+DDCTSEndAppointTime+"^"+DDCTSNotAvailFlag;
	 //alert(InputPara)
	 var UserHospID=GetUserHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
		MethodName:"SaveCureRBCTimePeriodSet",
		'value':InputPara,
		HospID:UserHospID
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			$("#add-dialog").dialog( "close" );
			RBCTimePeriodSetDataLoad();
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�����ظ�";
			else err=value;
			$.messager.alert('��ʾ',err,"error");   
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
			DDCTSEndAppointTime:rows[0].EndAppointTime	 
		})
     	$('#updateym').val("�޸�")    
     }else if (rows.length>1){
	     $.messager.alert("��ʾ","��ѡ���˶���ʱ��μ�¼��",'warning')
     }else{
	     $.messager.alert("��ʾ","��ѡ��ʱ��μ�¼��",'warning')
     }

}
function InitCureRBCTimePeriodSetDataGrid()
{
	var TimePeriodSetToolBar = [
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
		},{
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
		}/*,{
			text: '����',
			iconCls: 'icon-translate-word',
			handler: function() {
				translateClick();
			}
		}*/];
	var TimePeriodSetColumns=[[    
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
			{ field: 'EndAppointTime', title: '��ֹԤԼʱ��', width: 150, sortable: true,resizable: true
			},
			{ field: 'NotAvailFlag', title: '�����ñ��', width: 150, sortable: true,resizable: true
			}
		]];
	var CureRBCTimePeriodSetDataGrid=$("#tabCureRBCTimePeriodSet").datagrid({  //$HUI.datagrid("#tabCureRBCTimePeriodSet",{  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.RBCTimePeriodSet&QueryName=QueryBookTime",
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"Rowid",
		pageSize: 15,
		pageList : [15,50,100],
		columns :TimePeriodSetColumns,
		toolbar:TimePeriodSetToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("reload",{TPRowID:rowData.Rowid});
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       	},onBeforeLoad:function(param){
	       	$("#tabCureRBCTimePeriodSet").datagrid("clearChecked").datagrid("clearSelections");
			$.extend(param,{HospID:GetUserHospID()});
       	}
	});
	return CureRBCTimePeriodSetDataGrid;
}
function RBCTimePeriodSetDataLoad()
{
	$("#tabCureRBCTimePeriodSet").datagrid("reload");
};

function ReHospitalHandle(){
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��ʱ��μ�¼��","warning")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCTimePeriodSet",row["Rowid"])
	
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
		$.messager.alert("��ʾ","��ѡ��ʱ��μ�¼��","warning")
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
		$.messager.alert("��ʾ","��ѡ��ҽԺ","warning");
		return false;
	}
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��ʱ��μ�¼��","warning")
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
			$.messager.alert("��ʾ","�����ظ�","warning");
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
		$.messager.alert("��ʾ","��ѡ��ʱ��μ�¼��","info")
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

function SaveLinkConfig(){
	var HospId=GetUserHospID();
	var row=PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelected");
	if ((!row)||(row.length==0)){
		 $.messager.alert('��ʾ',"��ѡ��һ��ʱ��μ�¼��","warning");
		 return;
	}
	var TPRowId=row.Rowid;
	var GSIDStr="";
	var rows=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (GSIDStr=="") GSIDStr=rows[i].Rowid;
		else GSIDStr=GSIDStr+"^"+rows[i].Rowid;
	}
	if(GSIDStr==""){
		$.messager.confirm('��ʾ',"δѡ�����������,ȷ����ȡ�����й���,�Ƿ����?",function(r){
			if(r){
				Save();
			}else{
				//CureRBCServiceGroupSetDataGridLoad();
				PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("reload");
			}
		});
	}else{
		Save();
	}
	function Save(){
		var DataList=TPRowId+String.fromCharCode(1)+GSIDStr;
		var value=$.m({ 
			ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet", 
			MethodName:"SaveTPLinkSG",
			DataList:DataList,
			HospID:GetUserHospID()
		},false);
		if(value=="0"){
			$.messager.popover({msg: '����ɹ���',type:'success'});
		}else{
			var ErrorMsg=value;
			if(value=="-100"){
				ErrorMsg="ʱ�β���Ϊ��"
			}else if(value=="-101"){
				ErrorMsg="��������ʧ��"
			}else if(value=="-102"){
				ErrorMsg="��������ʧ��"
			}
			$.messager.alert('��ʾ',"����ʧ��:"+ErrorMsg,"error");
			return;
		}	
	}
}

function InitRBCServiceGroupSetDataGrid()
{
	var GroupSetToolBar = [
        {
            text: '�������',
            iconCls: 'icon-save',
            handler: function() { 
            	SaveLinkConfig();
            }
        }];
	var GroupSetColumns=[[    
			{ field: 'Rowid', title: 'ID', checkbox: true
			}, 
			{ field: 'Desc', title: '����', width: 200, sortable: true
			},
			{ field: 'selected', title:'�ѹ���ʱ��', width: 100,
				formatter:function(v,rec){
					return '<a href="#this" class="editcls1" onclick="ShowLinkConfig('+(rec.Rowid)+')">&nbsp</a>';
				}
			}
		]];
	var CureRBCServiceGroupSetDataGrid=$("#tabCureRBCServiceGroupSet").datagrid({ //$HUI.datagrid('#tabCureRBCServiceGroupSet',{  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&rows=9999",
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false,
		idField:"Rowid",
		pageSize: 15,
		pageList : [15,25,50],
		columns :GroupSetColumns,
		toolbar:GroupSetToolBar,
		onClickRow:function(rowIndex, rowData){
		},onBeforeLoad:function(param){
			$(this).datagrid("clearChecked").datagrid("clearSelections");
			$.extend(param,{HospID:GetUserHospID()});
		},
		onLoadSuccess:function(data){
			$('.editcls1').linkbutton({text:'&nbsp',plain:true,iconCls:'icon-search'});
			for (var i=0;i<data.total;i++){
				if (data.rows[i].HasConfigFlag=="Y") {
					$(this).datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$(this).datagrid("scrollTo",0);
			})
		}
	});
	return CureRBCServiceGroupSetDataGrid;
}

function ShowLinkConfig(RowID){
	var index=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getRowIndex",RowID);
	var rows=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getRows");
	$("#dialog-HasConfig").dialog('setTitle',"������<span style='color:yellow;'>"+rows[index].Desc +"</span>�ѹ���ʱ���б�").dialog("open");
	InitHasConfigTab(RowID);
}

function SaveConfigBySubSGId(){
	var HospId=GetUserHospID();
	var url=$("#HasConfigTab").datagrid("options").url;
	var SGRowID=GetQueryString(url,"SGRowID");
	var ConfigIdStr="";
	var rows=$("#HasConfigTab").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (ConfigIdStr=="") ConfigIdStr=rows[i].Rowid;
		else ConfigIdStr=ConfigIdStr+"^"+rows[i].Rowid;
	}
	
	if(ConfigIdStr==""){
		$.messager.confirm('��ʾ',"δѡ�����ʱ���,ȷ����ȡ�����й���,�Ƿ����?",function(r){
			if(r){
				Save();
			}else{
				$("#HasConfigTab").datagrid("reload");
			}
		});
	}else{
		Save();
	}
	function Save(){
		$.m({ 
			ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet", 
			MethodName:"SaveSGLinkTP",
			DataList:ConfigIdStr,
			SGRowID:SGRowID,
			HospID:GetUserHospID()
		},function(value){
			if(value=="0"){
				$.messager.popover({msg: '����ɹ���',type:'success'});
			}else{
				var ErrorMsg=value;
				if(value=="-100"){
					ErrorMsg="�����鲻��Ϊ��"
				}else if(value=="-101"){
					ErrorMsg="��������ʧ��"
				}else if(value=="-102"){
					ErrorMsg="��������ʧ��"
				}
				$.messager.alert('��ʾ',"����ʧ��:"+ErrorMsg,"error");
				return;
			}	
		});
	}
}

function InitHasConfigTab(RowID){
	var ToolBar = [{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { 
        	SaveConfigBySubSGId();
        }
    }]
	var Columns=[[
		{ field: 'Rowid', checkbox: true},   
		{ field: 'Code', title: 'ʱ�δ���', width: 100},
		{ field: 'Desc', title: 'ʱ������', width: 250}
	]];
	$("#HasConfigTab").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.RBCTimePeriodSet&QueryName=QueryBookTime&SGRowID="+RowID+"&rows=99999",
		loadMsg : '������..',  
		pagination : false,  
		rownumbers : false, 
		idField:"Rowid",
		columns :Columns,
		toolbar:ToolBar,
		onBeforeLoad:function(param){
			$("#HasConfigTab").datagrid("clearChecked").datagrid("clearSelections");
			$.extend(param,{HospID:GetUserHospID(),SGRowID:RowID});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.total;i++){
				if (data.rows[i].HasConfigFlag =="Y") {
					$("#HasConfigTab").datagrid("selectRow",i);
				}	
			}
			setTimeout(function() {
				$("#HasConfigTab").datagrid("scrollTo",0);
			})
		}
	});
}

function CureRBCServiceGroupSetDataGridLoad()
{
	PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("reload",{TPRowID:""});
};
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

function GetQueryString(url,name) { 
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
    var r = url.substr(1).match(reg);  //��ȡurl��"?"������ַ���������ƥ��
    var context = ""; 
    if (r != null) 
         context = r[2]; 
    reg = null; 
    r = null; 
    return context == null || context == "" || context == "undefined" ? "" : context; 
}

function translateClick(){
	var SelectedRow =  PageLogicObj.CureRBCTimePeriodSetDataGrid.datagrid("getSelected");
	if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ����Ҫ�������!","info");
		return false;
	}
	CreatTranLate("User.DHCDocCureRBCTimePeriodSet","DDCTSDesc",SelectedRow["Desc"])
}