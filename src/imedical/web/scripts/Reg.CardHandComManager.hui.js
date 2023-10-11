var FieldJson={
	CCMCode:"Code",
	CCMDesc:"Name",
	CCMComGroupDR:"GroupName",
	CCMCLASSID:"ClassID",
	CCMOBJECTID:"ObjectID",
	CCMDLLType:"DLLType",
	CCMVersion:"Version",
	CCMCodeBase:"CodeBase",
	CCMJSFunctionName:"JsFunctionName",
	CCMEquipPort:"EquipPort",
	CCMDateFrom:"DateFrom",
	CCMDateTo:"DateTo"
}
var PageLogicObj={
	ComManagerId:"",
	DLLObj:""
}
$(function(){
	//��ʼ��
	Init()
	//�¼���ʼ��
	InitEvent()
	//Ӳ��������ʼ��
	ComManagerListGridLoad()
})
function Init(){
	InitComManagerListGrid()
	//InitDLLFunction()
	PageLogicObj.DLLObj=new InitWin()
	
}
function InitEvent(){
	$("#BFind").click(ComManagerListGridLoad)
}
function InitComManagerListGrid(){
	//ID:%String,Code:%String,Desc:%String,GroupName:%String,ClassID:%String,ObjectID:%String,Version:%String,CodeBase:%String,EquipPort:%String,JSFunctionName:%String,DLLType:%String,DateFrom:%String,DateTo:%String,GroupID:%String
	var Columns=[[ 
		{field:'ID',title:'',hidden:true},
		{field:'Code',title:'����',width:50},
		{field:'Desc',title:'����',width:80},
		{field:'GroupName',title:'Ӳ����',width:80},
		{field:'ClassID',title:'ClassID ',width:120},
		{field:'ObjectID',title:'ObjectID',width:120},
		{field:'Version',title:'�汾',width:80},
		{field:'CodeBase',title:'CodeBase',width:80},
		{field:'EquipPort',title:'�˿ں�',width:80},
		{field:'JSFunctionName',title:'JS����',width:80},
		{field:'DLLType',title:'DLL�ļ�����',width:100},
		{field:'DateFrom',title:'��ʼ����',width:100},
		{field:'DateTo',title:'��������',width:100},
		{field:'GroupID',title:'',width:100,align:'center',hidden:true}
	]]
	var ComManagerListGrid=$("#ComManagerList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//pagination : true,  
		//pageSize: 20,
		idField:'EpisodeID',
		columns :Columns,
		toolbar: [
		{
			iconCls: 'icon-add ',
			text:'����',
			handler: function(){
				PageLogicObj.ComManagerId=""
				$("#ComManagerList").datagrid("unselectAll")
				LoadComManagerWin("Add")
				clearComManagerWin()
			}
		},{
			iconCls: 'icon-write-order',
			text:'�޸�',
			handler: function(){
				if(PageLogicObj.ComManagerId==""){
					$.messager.alert("��ʾ", "��ѡ��Ӳ���豸!", 'info');
					return 
				}
				LoadComManagerWin("Update")
				setTimeout("LoadComManagerData('"+PageLogicObj.ComManagerId+"')",100)
				
			}
		}
		/*,{
			iconCls: 'icon-cancel',
			text:'ɾ��',
			handler: function(){
				
			}
		}*/
		],
		onCheck:function(index, row){
			
		},onSelect:function(index,rowData){
			var ComManagerId=rowData["ID"];
			PageLogicObj.ComManagerId=ComManagerId
			PageLogicObj.DLLObj.DataGridLoad(ComManagerId)
		},
		onDblClickRow:function(index, row){
			var ComManagerId=row["ID"];
			PageLogicObj.ComManagerId=ComManagerId
			LoadComManagerWin("Update")
			//LoadComManagerData(PageLogicObj.ComManagerId)
			setTimeout("LoadComManagerData('"+PageLogicObj.ComManagerId+"')",100)
		}
	});
	ComManagerListGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return ComManagerListGrid;
}
function ComManagerListGridLoad(){
	$.cm({
	    ClassName : "web.DHCBL.CARD.CardHardComManager",
	    QueryName : "CardHardComManagerQuery",
		CodeSearch:$("#SearchCode").val(),
		NameSearch:$("#SearchDesc").val(),
	    rows:99999
	},function(GridData){
		$("#ComManagerList").datagrid('uncheckAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function LoadComManagerWin(WinType){
	if(typeof $("#ComManagerWin")[0]=="undefined"){
			$.ajax("reg.cardhardcommanager.win.csp", {
			"type" : "GET",
			"dataType" : "html",
			"success" : function(data, textStatus) {
				$("#previewPanelTemp").html(data)
				var title="�豸Ӳ������"
				if(WinType=="Add"){
					title="�����������豸Ӳ��������"
				}
				$('#ComManagerWin').dialog({
					title:title,
					resizable:true,
					modal:true,
					closed:true
				});
				InitComManagerWin()
				$("#ComManagerWin").dialog("center")
				$("#ComManagerWin").dialog("open")
			}
		});
	}else{
		$("#ComManagerWin").dialog("center")
		$("#ComManagerWin").dialog("open")
		var title="�豸Ӳ������"
		if(WinType=="Add"){
			title="�����������豸Ӳ��������"
		}
		$("#ComManagerWin").dialog("setTitle",title)
	}
}
function InitComManagerWin(){
	
	var cbox = $HUI.datebox("#DateFrom", {})
	var cbox = $HUI.datebox("#DateTo", {})
	$HUI.combobox("#GroupName", {})
	$HUI.combobox("#DLLType", {})
	
	//��ʼ��Ӳ����
	$.cm({
			ClassName:"web.DHCBL.CARD.CardHardComGroup",
			QueryName:"CardHardGroupQuery",
			Name:"",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#GroupName", {
					valueField: 'ID',
					textField: 'Name', 
					editable:true,
					data: GridData["rows"],
					onChange:function(newValue,oldValue){
						if (newValue=="") $(this).combobox('setValue','');
					}
			 });
	});
	//��ʼ��DLL�ļ�����
	$.cm({
			ClassName:"web.DHCBL.UDHCCommFunLibary",
			QueryName:"InitListObjectValueNew",
			ClassName1:"User.DHCCardHardComManager",
			PropertyName:"CCMDLLType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#DLLType", {
					valueField: 'ValueList',
					textField: 'DisplayValue', 
					editable:true,
					data: GridData["rows"],
					onChange:function(newValue,oldValue){
						if (newValue=="") $(this).combobox('setValue','');
					}
			 });
	});
	
	
	$HUI.linkbutton("#Save",{})
	$("#Save").bind("click",SaveClick)
}

function clearComManagerWin(){
	$("#Code").val("")
	$("#Desc").val("")
	$("#GroupName").combobox("setValue","")
	$("#ClassID").val("")
	$("#ObjectID").val("")
	$("#DLLType").combobox("setValue","")
	$("#Version").val("Version")
	
}
function SaveClick(){
	if(!CheckBefore()) return 
	var dataJson={}
	$.each(FieldJson,function(name,value){
		var val=getValue(value)
		val='"'+val+'"'
		eval("dataJson."+name+"="+val)
	})
	var jsonStr=JSON.stringify(dataJson)
	$m({
		ClassName:"web.DHCBL.CARD.CardHardComManager",
		MethodName:"SaveByJson",
		ComManagerId:PageLogicObj.ComManagerId,
		JsonStr:jsonStr
	},function(txtData){
		if(txtData==0){
			//alert("�����ӿ����ͳɹ�")
			ComManagerListGridLoad()
			$('#ComManagerWin').dialog('close')
		}else{
			$.messager.alert("��ʾ", "���ݱ���ʧ��", 'info');
		}
	});
}
///����ǰ����ȷ���ж�
function CheckBefore(){
	var Code=$.trim($("#Code").val())
	if(Code==""){
		$.messager.alert("��ʾ", "���벻��Ϊ��", 'info');
		$("#Code").focus()
		return false
	}
	var Desc=$.trim($("#Name").val())
	if(Desc==""){
		$.messager.alert("��ʾ", "��������Ϊ��", 'info');
		$("#Desc").focus()
		return false
	}
	var DateFrom=$("#DateFrom").datebox("getValue")
	if(DateFrom==""){
		$.messager.alert("��ʾ", "��ʼ���ڲ���Ϊ��", 'info');
		$("#DateFrom").focus()
		return false
	}
	var GroupName=$("#GroupName").combobox("getValue");
	if (GroupName==undefined) GroupName="";
	if(GroupName==""){
		$.messager.alert("��ʾ", "Ӳ���鲻��Ϊ��", 'info');
		$("#DateFrom").focus()
		return false
	}
	var EquipPort=$.trim($("#EquipPort").val())
	if((EquipPort!="1")&&(EquipPort!="0")&&(EquipPort!="3")&&(EquipPort!="2")&&(EquipPort!="4")&&(EquipPort!="5")){
		var EquipPortflag=dhcsys_confirm("�豸�˿ں�Ϊ�գ�������д0,1,2,3,4,5���Ƿ��������?")
		if(!EquipPortflag){
			$("#DateFrom").focus()
			return false
		}
	}
	return true 
}
///�����豸����
function LoadComManagerData(ComManagerId){
	clearComManagerWin()
	$.cm({
		ClassName:"web.DHCBL.CARD.CardHardComManager",
		MethodName:"GetComManagerDataJson",
		ComManagerId:ComManagerId,
		jsonFiledStr:JSON.stringify(FieldJson)
	},function(CardTypeData){
		if(CardTypeData!=""){
			$.each(CardTypeData,function(name,value){
				setValue(name,value)
			})
			$("#ComManagerWin").dialog("setTitle","�����޸ġ�"+$("#Name").val()+"��")
		}
	});
}


///����Ԫ�ص�classname��ȡԪ��ֵ
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return ""
	}
	if(className.indexOf("hisui-switchbox")>=0){
		var val=$("#"+id).switchbox("getValue")
		return val=(val?'Y':'N')
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
///��Ԫ�ظ�ֵ
function setValue(id,val){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return ""
	}
	if(className.indexOf("hisui-switchbox")>=0){
		val=(val=="Y"?true:false)
		$("#"+id).switchbox("setValue",val)
	}else if(className.indexOf("hisui-combobox")>=0){
		$("#"+id).combobox("setValue",val)
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else{
		$("#"+id).val(val)
	}
	return ""
}
///�����ͱ༭��������
function clearComManagerWin(){
	$.each(FieldJson,function(name,value){
		var val='"'+""+'"'
		setValue(value,"")
	})
}
