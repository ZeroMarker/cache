var cureRBCResPlanDataGrid;
var cureWeekList;
var cureTimeDescList;
var cureServiceGroupList;
$(function(){ 
  $('#btnSave').bind('click', function(){
	  if(!SaveFormData())return false;
   });
   $('#btnFind').bind('click', function(){
	  LoadCureRBCResPlanDataGrid();
   });
   $('#btnGen').bind('click', function(){
	  CreateResApptSchulde();
   });
   //��Դ�б�
    cureResourceList=$('#Resource').combobox({      
    	valueField:'TRowid',   
    	textField:'TResDesc'   
	});
  //�����б�
    $('#LocName').combobox({      
    	valueField:'LocId',   
    	textField:'LocDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'QueryCureLoc'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var locId=record.LocId;
			var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+locId+"&ArgCnt=1";
			cureResourceList.combobox('clear');
			cureResourceList.combobox('reload',url);		
		}  
	});
	//��Դ�б�
    $('#ResourceList').combobox({      
    	valueField:'TRowid',   
    	textField:'TResDesc'   
	});
  //�����б�
    $('#LocList').combobox({      
    	valueField:'LocId',   
    	textField:'LocDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'QueryCureLoc'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var locId=record.LocId;
			var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+locId+"&ArgCnt=1";
			$('#ResourceList').combobox('clear');
			$('#ResourceList').combobox('reload',url);		
		}  
	});
	//�����б�
    cureWeekList=$('#Week').combobox({      
    	valueField:'WeekId',   
    	textField:'WeekName',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCResPlan';
						param.QueryName = 'QueryWeek'
						param.ArgCnt =0;
		}
	});
	//ʱ���б�
    cureTimeDescList=$('#TimeDesc').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCResPlan';
						param.QueryName = 'QueryBookTime'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var Rowid=record.Rowid;
			//alert(Rowid);
			var ret=tkMakeServerCall("DHCDoc.DHCDocCure.RBCTimePeriodSet","GetCureRBCTimePeriodSetById",Rowid)		
			if (ret!="")
			{
				var TempArr=ret.split("^");
				$("#StartTime").val(TempArr[2]);
				$("#EndTime").val(TempArr[3]);
				$("#ChargTime").val(TempArr[4]);
			}
		} 
	});
	//�������б�
    cureServiceGroupList=$('#ServiceGroup').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCServiceGroupSet';
						param.QueryName = 'QueryServiceGroup'
						param.ArgCnt =0;
		}
	});
	InitCureRBCResPlan();
});	
function CheckData(){
	var LocId=$('#LocList').combobox('getValue');
	if(LocId=="")
	{
		 $.messager.alert("����", "��ѡ�����", 'error')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	if(ResourceId=="")
	{
		 $.messager.alert("����", "��ѡ����Դ", 'error')
        return false;
	}
	var Week=$('#Week').combobox('getValue');
	if(Week=="")
	{
		$.messager.alert('Warning','��ѡ������');   
        return false;
	}
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	if(TimeDesc=="")
	{
		$.messager.alert('Warning','��ѡ��ʱ��');   
        return false;
	}
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
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
	    var AutoNumber=$("#AutoNumber").val();
	    var ChargTime=$("#ChargTime").val();
	    var InputPara=Rowid+"^"+LocId+"^"+ResourceId+"^"+Week+"^"+TimeDesc+"^"+ServiceGroup+"^"+StartTime+"^"+EndTime+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResPlan","SaveCureRBCResPlan","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			//LoadCureRBCResPlanDataGrid()
			return true;							
		}else{
			var errmsg="";
			if (value==100)errmsg=",�������ݲ���Ϊ�ջ��߲��Ϸ�";
			else if (value==101)errmsg=",�Ѿ�����ͬʱ�ε�ģ��,�����ظ����";
			else errmsg=value;
			$.messager.alert("����","����ʧ��"+errmsg)
			return false;
		}
	   },"","",InputPara);
}
///�޸ı����
function UpdateGridData(){
   var rows = cureRBCResPlanDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
	 $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //��ձ�����
	 	$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocId)
		var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocId+"&ArgCnt=1";
		$('#ResourceList').combobox('clear');
		$('#ResourceList').combobox('reload',url);
		$('#ResourceList').combobox('setValue',rows[0].ResSourceDR)
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
function InitCureRBCResPlan()
{
	var cureRBCResPlanToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
              //$("#add-dialog").dialog("open");
              $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
	 			//��ձ�����
	 		  $('#add-form').form("clear") 
            }
        },
        '-', {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCResPlanDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].TRowid);
                            }
                            var ID=ids.join(',')
                            //alert(ID);
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResPlan","DeleteCureRBCResPlan","false",function testget(value){
						        if(value=="0"){
							       cureRBCResPlanDataGrid.datagrid('load');
           					       cureRBCResPlanDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						        }else{
							       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						        }
						  
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },'-',{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	var cureRBCResPlanColumns=[[    
                    { field: 'TRowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LocDesc', title:'����', width: 80, align: 'center', sortable: true,resizable: true  
					},
					{ field: 'LocId', title:'LocId', width: 10, align: 'center', sortable: true ,hidden:true 
					},
					{ field: 'ResSourceDR', title:'ResSourceDR', width: 100, align: 'center', sortable: true ,hidden:true  
					},
					{ field: 'ResourceDesc', title:'��Դ', width: 10, align: 'center', sortable: true ,resizable: true 
					}, 
					{ field: 'TWEEK', title:'����', width: 10, align: 'center', sortable: true,resizable: true  
					},
        			{ field: 'TTimeDesc', title: 'ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TServiceGroup', title: '������', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'TStartTime', title: '��ʼʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TEndTime', title: '����ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TMax', title: '���ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TAutoNumber', title: '�Զ�ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TChargTime', title: '��ֹ�ɷ�ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TWeekNum', title: 'TWeekNum', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'TSerivceGourpId', title: 'TServiceGroupId', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'TTimePeriodCode', title: 'TTimePeriodCode', width: 1, align: 'center', sortable: true,hidden:true
					}
    			 ]];
	cureRBCResPlanDataGrid=$('#tabCureRBCResPlan').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"TRowid",
		pageList : [15,50,100,200],
		columns :cureRBCResPlanColumns,
		toolbar:cureRBCResPlanToolBar,
		onClickRow:function(rowIndex, rowData){
			TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();	
       }

	});
	LoadCureRBCResPlanDataGrid();
}
function LoadCureRBCResPlanDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResPlan';
	queryParams.QueryName ='QueryResourceWeekPlan';
	queryParams.Arg1 =$('#LocName').combobox('getValue');
	queryParams.Arg2 =$('#Resource').combobox('getValue');
	queryParams.ArgCnt =2;
	var opts = cureRBCResPlanDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResPlanDataGrid.datagrid('load', queryParams);
}
///������Դ�Ű�
function CreateResApptSchulde()
{
	var LocId=$('#LocName').combobox('getValue');
	var StartDate=$('#StartDate').combobox('getValue');
	var EndDate=$('#EndDate').combobox('getValue');
	if(LocId=="")
	{
		 $.messager.alert("����", "��ѡ�����", 'error')
        return false;
	}
	var Info=LocId+"^"+StartDate+"^"+EndDate;
	$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","CreateResApptSchulde","false",function testget(value){
	if(value=="0"){
           	$.messager.show({title:"��ʾ",msg:"������Դ�ƻ��ɹ�!"});
	}else{
		    var err=""
		    if(value=="1000") err="�����Ű�ģ�������Ƿ��������"
			$.messager.alert('��ʾ',"������Դ�ƻ�ʧ��!"+err);
	}
						  
	},"","",Info,session['LOGON.USERID']);
}
