var PageLogicObj={
	m_PilotProRemListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-200
};
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//ҳ�����ݳ�ʼ��
	Init();
	//���ط������������
	PilotProRemListTabDataGridLoad();
	//�¼���ʼ��
	InitEvent();
});
function PageHandle(){
	LoadStartUser();
}
function LoadStartUser(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"Finduse",
		dataType:"json",
		Desc:"",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#PPRReceiver", {
			valueField: 'SSUSR_RowId',
			textField: 'SSUSR_Name', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#PPRReceiver");
					cbox.setValue("");
				}
			},
			onLoadSuccess:function(){
				$(this).combobox("select",session['LOGON.USERID']);
			}
	 });
}
function InitEvent(){
	$("#BSave").click(SaveClickHander);
	$('input:text:first').focus(); 
	var $inp = $('input:text'); 
	$inp.bind('keydown', function (e) { 
		var key = e.which; 
		if (key == 13) { 
			e.preventDefault(); 
			var nxtIdx = $inp.index(this) + 1; 
			if ($(":input:text:eq(" + nxtIdx + ")").css("display")=="none"){
				nxtIdx=nxtIdx+1;
			}
			$(":input:text:eq(" + nxtIdx + ")").focus(); 
		} 
	});
}
function SaveClickHander(){
	if (!CheckBeforeSave()) return false;
	try{
		var myProRemInfo=getProRemInfo();
		if (myProRemInfo==""){
			$.messager.alert("��ʾ","������ϢΪ��");
			return false;
		}
		$.messager.confirm('ȷ�϶Ի���', '�Ƿ�ȷ�ϱ����¼��Ϣ��ȷ������󽫲����޸�!', function(r){
			if (r){
				$.cm({
					ClassName:"web.PilotProject.DHCDocPilotProject",
					MethodName:"InsertProjectRem",
					dataType:"text",
					ProjectRemInfo:myProRemInfo,
					PPRowId:ServerObj.PPRowId
				},function(rtn){
					var myArray=rtn.split("^");
					if (myArray[0]=='0'){
						$.messager.alert("��ʾ","����ɹ�!","info",function(){
							PilotProRemListTabDataGridLoad();
							ClearData();
						});
					}else{
						$.messager.alert("��ʾ","����: "+myArray[1]);
					}
				});
			}
		});
	}catch(E){
		$.messager.alert("��ʾ",E.message);
		return;
	}
}
function DeleteClickHander () {
	var selected = $("#PilotProRemListTab").datagrid("getSelected");
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info");
		return false;
	}
	$.messager.confirm('ȷ��', '�Ƿ�ɾ����������¼��', function(r){
		if (r){
			$.cm({
				ClassName:"web.PilotProject.Extend.E1",
				MethodName:"DeleteProjectRem",
				dataType:"text",
				PPRemId:selected.PPRRowId
			},function(rtn){
				if (rtn=='0'){
					$.messager.alert("��ʾ","ɾ���ɹ�!","info",function(){
						PilotProRemListTabDataGridLoad();
						ClearData();
						$("#PilotProRemListTab").datagrid("clearSelections")
					});
				}else{
					$.messager.alert("��ʾ","����: "+rtn);
				}
			});
		}
	});
}
function ClearData(){
	$("#PPRDate").datebox("setValue","");
	$("#PPRRemAmount").val("");
	$("#PPRRemitter").val("");
	$("#PPRRemark").val("");
	$("#PPRReceiver").combobox("select",session['LOGON.USERID']);
}
function getProRemInfo(){
	var myxml="";
	var myparseinfo = ServerObj.InitProRemEntity;
	var myxml=GetEntityClassInfoToXML(myparseinfo)
	return myxml;
}
function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			var myval="";
			xmlobj.BeginNode(myary[myIdx]);
			var _$id=$("#"+myary[myIdx]);
			if (_$id.length==0){
				var node=myary[myIdx];
				//if (node=="PPRRemUserDr"){
					//var myval=$("#PPRReceiver").combobox("getValue");
				//}else{
					var Len=node.length-2;
					var id=node.substring(0,Len);
					if ($("#"+id).length>0){
						if ($("#"+id).hasClass("hisui-combobox")){
							var myval=$("#"+id).combobox("getValue");
						}else if($("#"+id).hasClass("hisui-datebox")){
							var myval=$("#"+id).datebox("getValue");
						}else{
							var myval=$("#"+id).val();
						}
				    }
				//}
				
			}else{
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue");
				}else if(_$id.hasClass("hisui-datebox")){
					var myval=_$id.datebox("getValue");
				}else{
					var myval=_$id.val();
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err){
		$.messager.alert("��ʾ","Error: " + Err.description);
	}	
	return myxmlstr;
}
function CheckBeforeSave(){
	var PPRDate=$("#PPRDate").datebox("getValue");
	PPRDate=PPRDate.replace(/(^\s*)|(\s*$)/g,'');
	if (PPRDate==""){
		$.messager.alert("��ʾ","��ѡ��������!","info",function(){
			$("#PPRDate").focus();
		});
		return false;
	}
	if(ServerObj.sysDateFormat=="4"){
		var sd=PPRDate.split("/");
    	var IDateCompare = new Date(sd[2],sd[1]-1,sd[0]);
	}else{
		var sd=PPRDate.split("-");
    	var IDateCompare = new Date(sd[0],sd[1]-1,sd[2]);
	}
    var TodayDate=new Date()
    if (IDateCompare>TodayDate){
		$.messager.alert("��ʾ","�������ڴ��ڲ�������,������ѡ��!","info",function(){
			$("#PPRDate").focus();
		}); 
		return false; 
	}
	var PPRReceiverLook=$("#PPRReceiver").combobox("getValue"); 
	var PPRReceiverLook=CheckComboxSelData("PPRReceiver",PPRReceiverLook); 
	if (PPRReceiverLook==""){
		$.messager.alert("��ʾ","��ѡ������û�!","info",function (){
			$('#PPRReceiver').next('span').find('input').focus();
		})
		return false;
	}
	return true;
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		  var CombValue=Data[i].SSUSR_RowId  
		  var CombDesc=Data[i].SSUSR_Name
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function Init(){
	PageLogicObj.m_PilotProRemListTabDataGrid=InitPilotProRemListTabDataGrid();
}
function InitPilotProRemListTabDataGrid(){
    /*PPRRowId:%String,PPRRemAmount:%String,PPRRemitter:%String,PPRRemUser:%String,
    PPRDateAdd:%String,PPRTimeAdd:%String,PPDesc:%String,PPRState:%String,Account:%String,
    PPRTypeDr,PPRType,PPCode,ProStartUser,User,PPRowId,UserDr,count,Job,PayContract,PayContractDesc,PPRDate,PPRReceiver,PPRRemark*/
	var Columns=[[ 
		{field:'PPRRowId',hidden:true,title:''},
		{field:'PPRDate',title:'��������',width:100},
		{field:'PPRRemAmount',title:'���˽��',width:100},
		{field:'PPRRemitter',title:'�����/��λ',width:100},
		{field:'PPRReceiver',title:'������',width:100},
		{field:'PPRDateAdd',title:'��������',width:100},
		{field:'PPRTimeAdd',title:'����ʱ��',width:100},
		{field:'PPRRemUser',title:'������',width:100},
		{field:'PPRRemark',title:'��ע',width:200},
		{field:'PPDesc',title:'',hidden:true},		
		{field:'Account',title:'',hidden:true},
		{field:'PPRTypeDr',title:'',hidden:true},
		{field:'PPRType',title:'',hidden:true},
		{field:'PPCode',title:'',hidden:true},
		{field:'PPRowId',title:'',hidden:true},
		{field:'UserDr',title:'',hidden:true},
		{field:'count',title:'',hidden:true},
		{field:'Job',title:'',hidden:true},
		{field:'PayContract',title:'',hidden:true},
		{field:'PPRState',title:'',hidden:true}
    ]]
	var PilotProListTabDataGrid=$("#PilotProRemListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'PPRRowId',
		columns :Columns,
		toolbar:[{
			text:'ɾ��',
			id:'i-delete',
			iconCls: 'icon-cancel',
			handler: function(){
				DeleteClickHander()				
			}
		}]
	}); 
	return PilotProListTabDataGrid;
}
function PilotProRemListTabDataGridLoad(){
	$.q({
	    ClassName : "web.PilotProject.DHCDocPilotProject",
	    QueryName : "FindProRem",
	    PPRowId:ServerObj.PPRowId,
	    Flag:ServerObj.Flag,
	    SttDate:"",
	    EndDate:"",
	    PPStartUserDr:"",
	    PPCreateDepartmentDr:"",
	    Pagerows:PageLogicObj.m_PilotProRemListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PilotProRemListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}