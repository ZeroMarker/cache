var CureTriageResourceDataGrid;
var ServiceGroupListObj;
$(document).ready(function(){
	//Init();
	InitHospList();
	InitEvent();
});	

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_TriageRes",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SLocDesc").searchbox("setValue","");
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
		CureTriageResourceDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
		CureTriageResourceDataGridLoad();
	}
}
function CheckDocCureUseBase(){
	var UserHospID=GetSelHospID();
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
		return true;
	}
}
function InitEvent(){
	$('#btnSave').bind('click', function(){
	  	if(!SaveFormData())return false;
   	});	   	
}

function Init()
{
	InitCureTriageResourceDataGrid();
	InitWinComb();
}

function AddGridData(){
  	$('#add-dialog').window('open');
  	$('#add-form').form("clear")
  	$('#ServiceGroupList').combobox('enable')
  	$HUI.checkbox("#DDCTRActive",{
		checked:false	
	})
  	$('#submitdata').val("���")  	
}

function InitCureTriageResourceDataGrid(){
	var CureTriageResourceToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
              	AddGridData();
            }
        },
        /*{
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows =CureTriageResourceDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DDCTRROWID);
                            }
                            var ID=ids.join(',')
							$.m({
								ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
								MethodName:"DeleteTriageResource",
								'Rowid':ID,
							},function testget(value){
						        if(value=="0"){
							       //CureTriageResourceDataGrid.datagrid('load');
							       CureTriageResourceDataGridLoad();
           					       CureTriageResourceDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
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
        },*/{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	var CureTriageResourceColumns=[[    
			{ field: 'DDCTRROWID', title: 'DDCTRROWID', width: 1, sortable: true,hidden:true
			}, 
			{ field: 'DDCTRServiceGroup', title:'����������', width: 200, sortable: true  
			},
			{ field: 'DDCTRServiceGroupID', title:'', width: 20,hidden:true
			},
			{ field: 'DDCTRCTLoc', title:'��������', width: 300, sortable: true  
			},
			{ field: 'DDCTRCTLocID', title:'', width: 20,hidden:true
			},
			{ field: 'DDCTRCTPCP', title: '��Դ����', width: 250
			},
			{ field: 'DDCTRCTPCPID', title:'', width: 20,hidden:true
			},
			{ field: 'DDCTRCount', title:'�ɷ�������', width: 150
			},
			{ field: 'DDCTRActive', title: '�Ƿ���Ч', width: 150
			}
		]];
	CureTriageResourceDataGrid=$('#tabCureTriageResource').datagrid({  
		fit : true,
		remoteSort:false,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"Rowid",
		pageSize:20,
		pageList : [20,50,100],
		columns :CureTriageResourceColumns,
		//toolbar:CureTriageResourceToolBar,
		onClickRow:function(rowIndex, rowData){
			//PTRowid=rowData.PTRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       }
	});	
}

function InitWinComb(){
	var HospID=GetSelHospID();
	//��Դ�б�
    var ResourceListObj=$HUI.combobox("#ResourceList",{
		valueField:'TRowid',   
    	textField:'TResDesc' 	
	})
	
	//�����б�
	$HUI.combobox("#DDCTRCTLocList", {});
	InitWinLoc(ResourceListObj)
  
	//�������б�
    var ServiceGroupListObj=$HUI.combobox(('#ServiceGroupList'),{  
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospID+"&ResultSetType=array",
		valueField:'Rowid',
		textField:'Desc',
	});	
}

function InitWinLoc(Obj){
	var HospID=GetSelHospID();
    $.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"QueryCureLoc",		
		HospID:	HospID,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#DDCTRCTLocList", {
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

function CheckData(){
	var ServiceGroup=$('#ServiceGroupList').combobox('getValue');
	var ServiceGroup=CheckComboxSelData("ServiceGroupList",ServiceGroup);
	if(ServiceGroup=="")
	{
		$.messager.alert('��ʾ','��ѡ�������');   
        return false;
	}
	
	var LocId=$('#DDCTRCTLocList').combobox('getValue');
	var LocId=CheckComboxSelData("DDCTRCTLocList",LocId);
	if(LocId=="")
	{
		 $.messager.alert("��ʾ", "��ѡ�����", 'error')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	var ResourceId=CheckComboxSelData("ResourceList",ResourceId);
	if(ResourceId=="")
	{
		 $.messager.alert("��ʾ", "��ѡ����Դ", 'error')
        return false;
	}
	
	var Max=$("#DDCTRCount").val();
	if(Max!="")
	{
		var Max=parseFloat(Max);
		if(Max<=0){
			$.messager.alert("��ʾ","�ɷ�����������д����0����", 'error');
			return false;		
		}
	}
	return true;
}

function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="DDCTRCTLocList")||(id=="LocList")){
			var CombValue=Data[i].LocId;
			var CombDesc=Data[i].LocDesc;
		}else if ((id=="Resource")||(id=="ResourceList")){
			var CombValue=Data[i].TRowid;
			var CombDesc=Data[i].TResDesc;
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

///�޸ı����
function SaveFormData(){
	if(!CheckData()) return false;    
    var Rowid=$("#DDCTRROWID").val();
	var DDCTRCTLoc=$('#DDCTRCTLocList').combobox('getValue');
	var DDCTRCTPCP=$('#ResourceList').combobox('getValue');   
    var ServiceGroup=$('#ServiceGroupList').combobox('getValue');
    var DDCTRActive=$('#DDCTRActive').is(":checked");
    if(DDCTRActive){
		DDCTRActive="N"; 
	}else{
		DDCTRActive="Y";	
	}
    var DDCTRCount=$('#DDCTRCount').numberbox('getValue');
    var InputPara=Rowid+"^"+DDCTRCTLoc+"^"+DDCTRCTPCP+"^"+ServiceGroup+"^"+DDCTRActive+"^"+DDCTRCount;
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"SaveTriageResource",
		'str':InputPara,
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ���"});	
			$("#add-dialog").dialog( "close" );
			CureTriageResourceDataGridLoad();
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ�գ�";
			else if ((value=="101")||(value=="102")) err="����Դ������,��ȷ�ϣ�";
			else err=value;
			$.messager.alert('��ʾ',err,"warning");
			return false;
		}
	});
}
///�޸ı����
function UpdateGridData(){
	var rows = CureTriageResourceDataGrid.datagrid('getSelections');
	if (rows.length ==1) {
		$('#add-dialog').window('open');
		//��ձ�����
		$('#add-form').form("clear");
		$('#DDCTRCTLocList').combobox('setValue',rows[0].DDCTRCTLocID)
		var ResourceLisObj=$HUI.combobox("#ResourceList");
		var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+rows[0].DDCTRCTLocID+"&ResultSetType=array";
		if(typeof ResourceLisObj!=undefined){
			ResourceLisObj.clear();
			ResourceLisObj.reload(url);
			ResourceLisObj.setValue(rows[0].DDCTRCTPCPID);
		}
		//$('#ResourceList').combobox('clear');
		//$('#ResourceList').combobox('reload',url);
		//setTimeout(function(){$('#ResourceList').combobox('setValue',rows[0].DDCTRCTPCPID);},100)
		$('#ServiceGroupList').combobox('setValue',rows[0].DDCTRServiceGroupID);
		$('#ServiceGroupList').combobox('disable');
		if(rows[0].DDCTRActive!=""){
			$HUI.checkbox("#DDCTRActive",{
				checked:true,	
			})
		}else{
			$HUI.checkbox("#DDCTRActive",{
				checked:false,	
			})
		}
		$('#DDCTRCount').numberbox('setValue',rows[0].DDCTRCount);
		$('#add-form').form("load",{
			DDCTRROWID:rows[0].DDCTRROWID	 
		})

		$('#updateym').val("�޸�")    
	}else if (rows.length>1){
		$.messager.alert("��ʾ","��ѡ���˶��У�",'warning')
	}else{
		$.messager.alert("��ʾ","��ѡ��һ�У�",'warning')
	}

}

function CureTriageResourceDataGridLoad()
{
	var HospID=GetSelHospID();
	var LocDesc=$("#SLocDesc").searchbox("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		QueryName:"QueryTriageResource",
		LocRowID:"",
		HospID:HospID,
		LocDesc:LocDesc,
		Pagerows:CureTriageResourceDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureTriageResourceDataGrid.datagrid('unselectAll').datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
};

function GetSelHospID(){
	var HospID=session['LOGON.HOSPID'];
	if($('#_HospList').length>0){
		HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
	}
	return HospID;
}