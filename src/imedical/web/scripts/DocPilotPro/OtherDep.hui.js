var PageLogicObj={
	m_PilotProOtherDepListTabDataGrid:"",
	m_Loc:""
};
$(function(){
	//ҳ�����ݳ�ʼ��
	Init();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	PilotProOtherDepListTabDataLoad();
});
function PageHandle(){
	//����
	PageLogicObj.m_Loc=LoadDepartment();  
	//��Ҫ�о���   
	LoadStartUser();  
}
function Init(){
	PageLogicObj.m_PilotProOtherDepListTabDataGrid=InitPilotProOtherDepListTabDataGrid();
}
function InitPilotProOtherDepListTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {SaveClickHandle();}
    }];
	var Columns=[[ 
		{field:'TPPDRowId',hidden:true,title:''},
		{field:'TPPCreateDepartment',title:'�������',width:200},
		{field:'TPPStartUser',title:'������',width:200},
		{field:'TPPStartUserDr',title:'',hidden:true},
		{field:'TPPCreateDepartmentDr',title:'',hidden:true}
    ]]
	var PilotProOtherDepListTabDataGrid=$("#PilotProOtherDepListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		idField:'TPPDRowId',
		columns :Columns,
		toolbar:toobar
	}); 
	return PilotProOtherDepListTabDataGrid;
}
function PilotProOtherDepListTabDataLoad(){
	if (ServerObj.OtherDepStr=="") return;
	var DataArr=new Array();
	var arr=ServerObj.OtherDepStr.split("^");
	var arr1=ServerObj.OtherDepartment.split(";");
	var len=arr.length
	for (var i=0;i<len;i++){
		var onearr=arr[i].split("-");
		var onearr1=arr1[i].split("-");
		if (((arr1[i].split("-"))[0]=="")||((arr1[i].split("-"))[1]=="")) continue;
		PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('appendRow',{
			TPPDRowId: i,
			TPPCreateDepartmentDr: onearr[0],
			TPPStartUserDr: onearr[1],
			TPPCreateDepartment:onearr1[0],
			TPPStartUser:onearr1[1]
		});
	}
}
var LastSelLocId="";
function LoadDepartment(){
	var cbox = $HUI.combobox("#PPCreateDepartment", {
		url:$URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc=&InHosp="+ServerObj.InHosp+"&ResultSetType=array",
		valueField:'RowId',
		textField:'Desc',
		filter: function(q, row){
			q=q.toUpperCase();
			return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
		},
		onChange:function(newValue,OldValue){
			if (newValue==""){
				var cbox = $HUI.combobox("#PPCreateDepartment");
				cbox.setValue("");
			}
		},
		onBeforeLoad: function(param){
			LastSelLocId=$("#PPCreateDepartment").combobox('getValue');
		},
		onLoadSuccess:function(){
			var DefLocId="";
			var rows=$("#PPCreateDepartment").combobox('getData');
			for (var i=0;i<rows.length;i++){
				if ((rows[i].RowId==LastSelLocId)||((LastSelLocId=="")&&(rows.length==1))) {
					DefLocId=rows[i].RowId;
					break;
				}
			}
			$("#PPCreateDepartment").combobox('select',DefLocId);
		}
	})
	return cbox;
	/*$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindLoc",
		dataType:"json",
		Loc:"",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#PPCreateDepartment", {
				valueField: 'RowId',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PPCreateDepartment");
						cbox.setValue("");
					}
				},
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
				}
		 });
	});*/
	
}
function LoadStartUser(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindStartUser",
		dataType:"json",
		PPStartUser:"",
		ShowCode:"Y",
		InHosp:ServerObj.InHosp,
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#PPStartUser", {
			valueField: 'Hidden',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#PPStartUser");
					cbox.setValue("");
					
					var sid = "";
					var loc=""
					url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&InHosp="+ServerObj.InHosp+"&User="+sid+"&ResultSetType=array";
					PageLogicObj.m_Loc.reload(url);
					PageLogicObj.m_Loc.setValue("");
				}
			},
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["SSUSRInitials"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (record) {
				var sid = record.Hidden;
				var loc=""
				url = $URL+"?ClassName=web.PilotProject.DHCDocPilotProject&QueryName=FindLoc&Loc="+loc+"&InHosp="+ServerObj.InHosp+"&User="+sid+"&ResultSetType=array";
				PageLogicObj.m_Loc.reload(url);
				PageLogicObj.m_Loc.setValue("");
			}
	 });
	/*$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"FindStartUser",
		dataType:"json",
		PPStartUser:"",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#PPStartUser", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PPStartUser");
						cbox.setValue("");
					}
				},
				filter: function(q, row){
					q=q.toUpperCase();
					return (row["Desc"].toUpperCase().indexOf(q) >= 0)||(row["SSUSRInitials"].toUpperCase().indexOf(q) >= 0);
				}
		 });
	}); */
}
function AddClickHandle(){
	var cbox = $HUI.combobox("#PPCreateDepartment");
	var TPPCreateDepartmentDr=cbox.getValue();
	var TPPCreateDepartment=cbox.getText();
	TPPCreateDepartmentDr=CheckComboxSelData("PPCreateDepartment",TPPCreateDepartmentDr);
	if (TPPCreateDepartmentDr==""){
		$.messager.alert("��ʾ","��ѡ���������!","info",function(){
			$('#PPCreateDepartment').next('span').find('input').focus();
		});
		return false;
	}
	var cbox = $HUI.combobox("#PPStartUser");
	var TPPStartUserDr=cbox.getValue();
	var TPPStartUser=cbox.getText();
	TPPStartUserDr=CheckComboxSelData("PPStartUser",TPPStartUserDr);
	if (TPPStartUserDr=="") TPPStartUser="";
	if (TPPStartUserDr=="") {
		$.messager.alert("��ʾ","��ѡ������!","info",function(){
			$('#PPStartUser').next('span').find('input').focus();
		});
		return false;
	}
	var data=PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('getRows');
	for (var i=0;i<data.length;i++){
		if ((data[i].TPPCreateDepartmentDr==TPPCreateDepartmentDr)&&(data[i].TPPStartUserDr==TPPStartUserDr)){
			$.messager.alert("��ʾ","��¼�ظ�!");
			return false;
		}
	}
	var dynObj = $cm({
			ClassName: "web.PilotProject.CFG.FindGCP",
			MethodName: "GetPI",
			PPRowId: ServerObj.PPRowId
		},false)
	if ((dynObj.user==TPPStartUserDr)&&(dynObj.loc==TPPCreateDepartmentDr)) {
		$.messager.alert("��ʾ","����Ҫ�о��ߺ���������ظ���","warning");
		return false;
	}
	PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('appendRow',{
		TPPDRowId: 3,
		TPPCreateDepartmentDr: TPPCreateDepartmentDr,
		TPPStartUserDr: TPPStartUserDr,
		TPPCreateDepartment:TPPCreateDepartment,
		TPPStartUser:TPPStartUser.split("(")[0]
	});
	ResetOtherDepData("Add");
}
function DelClickHandle(){
	var row=PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼!");
		return false;
	}
	var index=PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('getRowIndex',row);
	PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('deleteRow',index);
	ResetOtherDepData("Del");
}
function SaveClickHandle(){
	if (ServerObj.PPRowId=="") {
		$.messager.alert("��ʾ","ֻ�����������Ŀ�ſɱ���!");
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"DeleteProjectDeptChild",
		dataType:"text",
		PPDRowId:ServerObj.PPRowId
	},false); 	 
	ResetOtherDepData("Save");
	$.messager.alert("��ʾ","����ɹ�!");
}
function ResetOtherDepData(type){
	var OtherDepStr="";
	var OtherDepartment="";
	var GridData=PageLogicObj.m_PilotProOtherDepListTabDataGrid.datagrid('getData');
	for (var i=0;i<GridData.rows.length;i++){
		var oneRowData=GridData.rows[i];
		var PPCreateDepartmentDr=oneRowData["TPPCreateDepartmentDr"];
		var PPStartUserDr=oneRowData["TPPStartUserDr"];
		if (OtherDepStr=="") {
			OtherDepStr=PPCreateDepartmentDr+"-"+PPStartUserDr;
		}else {
			OtherDepStr=OtherDepStr+"^"+PPCreateDepartmentDr+"-"+PPStartUserDr;;
		}
		if(OtherDepartment=="") {
			OtherDepartment=oneRowData["TPPCreateDepartment"]+"-"+oneRowData["TPPStartUser"];
		}else {
			OtherDepartment=OtherDepartment+";"+oneRowData["TPPCreateDepartment"]+"-"+oneRowData["TPPStartUser"];
		}
		if ((type=="Save")&&(ServerObj.PPRowId!="")){
			var rtn=$.cm({
				ClassName:"web.PilotProject.DHCDocPilotProject",
				MethodName:"InsertProjectDept",
				dataType:"text",
				PPRowId:ServerObj.PPRowId,
				PPCreateDepartmentDr:PPCreateDepartmentDr,
				PPStartUserDr:PPStartUserDr
			},false);
		}
	}
	ServerObj.OtherDepStr=OtherDepStr;
	ServerObj.OtherDepartment=OtherDepartment;
	parent.ResetOtherDepData(OtherDepStr,OtherDepartment);
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="PPCreateDepartment"){
			var CombValue=Data[i].RowId;
		 	var CombDesc=Data[i].Desc;
	     }else if(id=="PPStartUser"){
		    var CombValue=Data[i].Hidden;
		 	var CombDesc=Data[i].Desc;
		 }else{
		    var CombValue=Data[i].rowid  
		 	var CombDesc=Data[i].Desc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}