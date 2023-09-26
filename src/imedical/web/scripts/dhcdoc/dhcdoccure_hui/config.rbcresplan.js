var CureRBCResPlanDataGrid;
var CureWeekListObj;
var CureTimeDescListObj;
var CureServiceGroupListObj;
var CureResourceListObj;
$(document).ready(function(){
	//Init();
	InitHospUser()
 	InitEvent();
});	

function InitHospUser(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_SchePlan",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
	}
}
function CheckDocCureUseBase(){
	var UserHospID=Util_GetSelHospID();
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
		return true;
	}
}

function Init(){
	//��Դ�б�
	var CureResourceObj=$HUI.combobox('#Resource',{      
		valueField:'TRowid',   
		textField:'TResDesc'   
	});
	//�����б�
	$HUI.combobox("#LocName", {});
	InitLoc("LocName",CureResourceObj);
	
	InitCureRBCResPlan();	
	InitWinComb();
}

function InitLoc(parame,Obj){
	var HospDr=Util_GetSelHospID();
    $.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"QueryCureLoc",		
		HospID:	HospDr,	
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#"+parame+"", {
				valueField: 'LocId',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(record){
					var locId=record.LocId;
					var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+locId+"&ResultSetType=array";
					Obj.clear();
					Obj.reload(url);			
				}  
		 });
	});
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$('#btnFind').bind('click', function(){
		var LocName=$('#LocName').combobox('getValue');
		var Resource=$('#Resource').combobox('getValue');
		if (LocName==""){
			$.messager.alert("��ʾ", "��ѡ�����", 'error')
			return false;	
		}
		LoadCureRBCResPlanDataGrid();
	});
	$('#btnGen').bind('click', function(){
		CreateResApptSchulde();
	});	
}

function InitWinComb(){
	var HospDr=Util_GetSelHospID();
	//��Դ�б�
	var CureResourceListObj=$HUI.combobox('#ResourceList',{     
		valueField:'TRowid',   
		textField:'TResDesc'   
	});
	//�����б�
	var CureLocListObj=$HUI.combobox('#LocList',{});
	InitLoc("LocList",CureResourceListObj);
	
	//�����б�
	var CureWeekListObj=$HUI.combobox('#Week',{
		valueField:'WeekId',   
		textField:'WeekName',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryWeek&ResultSetType=array",
	});
	//ʱ���б�
	var CureTimeDescListObj=$HUI.combobox('#TimeDesc',{ 
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryBookTime&HospID="+HospDr+"&ResultSetType=array",
		onSelect:function(record){
			var Rowid=record.Rowid;
			var StartTime=record.StartTime;
			var EndTime=record.EndTime;
			var EndChargTime=record.EndChargTime;
			$("#StartTime").val(StartTime);
			$("#EndTime").val(EndTime);
			$("#ChargTime").val(EndChargTime);
			$HUI.timespinner("#StartTime").disable();
			$HUI.timespinner("#EndTime").disable();
			$HUI.timespinner("#ChargTime").disable();
			/*
			$.m({
				ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
				MethodName:"GetCureRBCTimePeriodSetById",
				'Id':Rowid,
			},function(objScope){
				if (objScope=="") return;
				var TempArr=objScope.split("^");
				$("#StartTime").val(TempArr[2]);
				$("#EndTime").val(TempArr[3]);
				$("#ChargTime").val(TempArr[4]);
				//$('#StartTime').timespinner("disable")
				//$('#EndTime').timespinner("disable")
				//$('#ChargTime').timespinner("disable")
				var SObj=$HUI.timespinner("#StartTime").disable();
				var EObj=$HUI.timespinner("#EndTime").disable();
				var CObj=$HUI.timespinner("#ChargTime").disable();
			})	*/		
		} 
	});
	//�������б�
	var CureServiceGroupListObj=$HUI.combobox('#ServiceGroup',{
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
	});	
}
function CheckData(){
	var LocId=$('#LocList').combobox('getValue');
	var LocId=CheckComboxSelData("LocList",LocId);
	if(LocId=="")
	{
		 $.messager.alert("����", "��ѡ�����", 'error')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	var ResourceId=CheckComboxSelData("ResourceList",ResourceId);
	if(ResourceId=="")
	{
		 $.messager.alert("����", "��ѡ����Դ", 'error')
        return false;
	}
	var Week=$('#Week').combobox('getValue');
	var Week=CheckComboxSelData("Week",Week);
	if(Week=="")
	{
		$.messager.alert('Warning','��ѡ������');   
        return false;
	}
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var TimeDesc=CheckComboxSelData("TimeDesc",TimeDesc);
	if(TimeDesc=="")
	{
		$.messager.alert('Warning','��ѡ��ʱ��');   
        return false;
	}
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var ServiceGroup=CheckComboxSelData("ServiceGroup",ServiceGroup);
	if(ServiceGroup=="")
	{
		$.messager.alert('Warning','��ѡ�������');   
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('Warning','����д��ʼʱ��');   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('Warning','����д����ʱ��');   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('Warning','����д���ԤԼ��');   
        return false;
	}
	var Max=parseFloat(Max);
	if(Max<=0){
		$.messager.alert("��ʾ","ԤԼ������д����0����");
		return false;		
	}
	var AutoNumber=""; //$("#AutoNumber").val();
	if ((+AutoNumber!=0)&&(parseInt(AutoNumber)>parseInt(Max))){
		$.messager.alert('Warning','�Զ�ԤԼ�����ܴ������ԤԼ��');   
        return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
	if(!CheckData()) return false;
	var Rowid=$("#Rowid").val();
	var LocId=$('#LocList').combobox('getValue');
	var ResourceId=$('#ResourceList').combobox('getValue');   
	var Week=$('#Week').combobox('getValue');
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var StartTime=$("#StartTime").val();
	var EndTime=$("#EndTime").val();
	var Max=$("#Max").val();
	var AutoNumber=""; //$("#AutoNumber").val();
	var ChargTime=$("#ChargTime").val();
	var InputPara=Rowid+"^"+LocId+"^"+ResourceId+"^"+Week+"^"+TimeDesc+"^"+ServiceGroup+"^"+StartTime+"^"+EndTime+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
		MethodName:"SaveCureRBCResPlan",
		'value':InputPara,
	},function testget(value){
		if(value=="0"){
			$.messager.show("��ʾ","����ɹ�")	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCResPlanDataGrid(true)
			return true;							
		}else{
			var errmsg="";
			if (value==100)errmsg=",�������ݲ���Ϊ�ջ��߲��Ϸ�";
			else if (value==101)errmsg=",�Ѿ�����ͬʱ�ε�ģ��,�����ظ����";
			else errmsg=value;
			$.messager.alert("����","����ʧ��"+errmsg)
			return false;
		}
	});
}
///�޸ı����
function UpdateGridData(){
	var rows = CureRBCResPlanDataGrid.datagrid('getSelections');
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:300,height:420,top: 10,left:400});
		//��ձ�����
		$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocId)
		//var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocId+"&ArgCnt=1";
		//$('#ResourceList').combobox('clear');
		//$('#ResourceList').combobox('reload',url);
		//$('#ResourceList').combobox('setValue',rows[0].ResSourceDR)
		var CureResourceListObj=$HUI.combobox("#ResourceList");
		var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+rows[0].LocId+"&ResultSetType=array";
		CureResourceListObj.clear();
		CureResourceListObj.reload(url);
		CureResourceListObj.setValue(rows[0].ResSourceDR);
		$('#Week').combobox('setValue',rows[0].TWeekNum)
		$('#TimeDesc').combobox('setValue',rows[0].TTimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].TSerivceGourpId)
		$('#add-form').form("load",{
			Rowid:rows[0].TRowid,
			StartTime:rows[0].TStartTime,
			EndTime:rows[0].TEndTime,
			Max:rows[0].TMax,
			AutoNumber:rows[0].TAutoNumber,
			ChargTime:rows[0].TChargTime	 	 
		})
		$('#btnSave').val("�޸�")    
	}else if (rows.length>1){
		$.messager.alert("����","��ѡ���˶��У�",'err')
	}else{
		$.messager.alert("����","��ѡ��һ�У�",'err')
	}

}

function DeleteGridData(){
	var rows = CureRBCResPlanDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        $.messager.confirm("��ʾ", "ȷ��ɾ����?",
        function(r) {
            if (r) {
				var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].TRowid);
                }
                var ID=ids.join(',')
                //alert(ID);
				$.m({
					ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
					MethodName:"DeleteCureRBCResPlan",
					'Rowid':ID,
				},function testget(value){
			        if(value=="0"){
				       //CureRBCResPlanDataGrid.datagrid('load');
				       LoadCureRBCResPlanDataGrid();
				       CureRBCResPlanDataGrid.datagrid('unselectAll');
				       //$.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
				       $.messager.alert('��ʾ',"ɾ���ɹ�");
			        }else{
				       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
			        }
			  
			   });
            }
        });
    } else {
        $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
    }	
}
function InitCureRBCResPlan()
{
	var CureRBCResPlanToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
              	$('#add-dialog').window('open').window('resize',{width:300,height:420,top: 10,left:400});
	 			//��ձ�����
	 		  	$('#add-form').form("clear") 
            }
        },
       {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
	            DeleteGridData();               
            }
        },{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		}];
	var CureRBCResPlanColumns=[[    
                    { field: 'TRowid', title: 'ID', width: 1, sortable: true,hidden:true
					},
					{ field: 'LocDesc', title:'����', width: 200, sortable: true,resizable: true  
					},
					{ field: 'LocId', title:'LocId', width: 10, sortable: true ,hidden:true 
					},
					{ field: 'ResSourceDR', title:'ResSourceDR', width: 10, sortable: true ,hidden:true  
					},
					{ field: 'ResourceDesc', title:'��Դ', width: 150, sortable: true ,resizable: true 
					}, 
					{ field: 'TWEEK', title:'����', width: 80, sortable: true,resizable: true  
					},
        			{ field: 'TTimeDesc', title: 'ʱ��', width: 80, sortable: true,resizable: true
					},
					{ field: 'TServiceGroup', title: '������', width: 120, sortable: true, resizable: true
					},
					{ field: 'TStartTime', title: '��ʼʱ��', width: 100, sortable: true,resizable: true
					},
					{ field: 'TEndTime', title: '����ʱ��', width: 100, sortable: true,resizable: true
					},
					{ field: 'TMax', title: '���ԤԼ��', width: 100, sortable: true,resizable: true
					},
					//{ field: 'TAutoNumber', title: '�Զ�ԤԼ��', width: 20, sortable: true,resizable: true
					//},
					{ field: 'TChargTime', title: '��ֹ�ɷ�ʱ��', width: 100, sortable: true,resizable: true
					},
					{ field: 'TWeekNum', title: 'TWeekNum', width: 1, sortable: true,hidden:true
					},
					{ field: 'TSerivceGourpId', title: 'TServiceGroupId', width: 1, sortable: true,hidden:true
					},
					{ field: 'TTimePeriodCode', title: 'TTimePeriodCode', width: 1, sortable: true,hidden:true
					}
    			 ]];
	CureRBCResPlanDataGrid=$('#tabCureRBCResPlan').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"TRowid",
		pageSize:10,
		pageList : [10,25,50],
		columns :CureRBCResPlanColumns,
		toolbar:CureRBCResPlanToolBar,
		onClickRow:function(rowIndex, rowData){
			//TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();	
       	}

	});
	LoadCureRBCResPlanDataGrid(true);
}
function LoadCureRBCResPlanDataGrid(init)
{
	var CureLocName=$('#LocName').combobox('getValue');
	var CureResource=$('#Resource').combobox('getValue');
	if((CureLocName=="")&&(!init)){
		$.messager.alert('��ʾ','��ѡ�����');   
        return false;	
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
		QueryName:"QueryResourceWeekPlan",
		'LocId':CureLocName,
		'ResourceId':CureResource,
		Pagerows:CureRBCResPlanDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResPlanDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="LocName")||(id=="LocList")){
			var CombValue=Data[i].LocId;
			var CombDesc=Data[i].LocDesc;
		}else if ((id=="Resource")||(id=="ResourceList")){
			var CombValue=Data[i].TRowid;
			var CombDesc=Data[i].TResDesc;
		}else if (id=="Week"){
			var CombValue=Data[i].WeekId  
			var CombDesc=Data[i].WeekName
		}else{
			var CombValue=Data[i].Rowid  
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
///������Դ�Ű�
function CreateResApptSchulde()
{
	var LocId=$('#LocName').combobox('getValue');
	var StartDate=$('#StartDate').combobox('getValue');
	var EndDate=$('#EndDate').combobox('getValue');
	var LocId=CheckComboxSelData("LocName",LocId);
	var ResourceId=$('#Resource').combobox('getValue');
	var ResourceId=CheckComboxSelData("Resource",ResourceId);
	if(LocId=="")
	{
		$.messager.alert("����", "��ѡ�����", 'error')
        return false;
	}
	var Info=LocId+"^"+StartDate+"^"+EndDate+"^"+ResourceId;
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		MethodName:"CreateResApptSchulde",
		'Info':Info,
		'UserID':session['LOGON.USERID'],
		'hisui':"1",
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"������Դ�ƻ��ɹ�!"});
		}else{
			var err=""
			if(value=="1000") err="�����Ű�ģ�������Ƿ��������"
			$.messager.alert('��ʾ',"������Դ�ƻ�ʧ��!"+err);
		}
						  
	});
}
