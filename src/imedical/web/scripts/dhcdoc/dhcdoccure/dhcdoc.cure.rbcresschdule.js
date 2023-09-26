var cureRBCResSchduleDataGrid;
var cureResourceList;
var cureTimeDescList;
var cureServiceGroupList;
$(function(){ 
	$('#btnSave').bind('click', function(){
	  if(!SaveFormData())return false;
   });
   $('#btnFind').bind('click', function(){
	  LoadCureRBCResSchduleDataGrid();
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
	InitCureRBCResSchdule();
});	
function InitCureRBCResSchdule()
{
	var cureRBCResSchduleToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
                //$("#add-dialog").dialog("open");
                $('#LocList').combobox("enable")
	 			$('#ResourceList').combobox("enable")
	 			$('#TimeDesc').combobox("enable") 
	 			$('#Date').datebox("enable") 
                $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
	 			//��ձ�����
	 		  $('#add-form').form("clear")  
            }
        },'-',{
            text: 'ͣ��/����ͣ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCResSchduleDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫͣ��/����ͣ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","StopOneRBCSchedule","false",function testget(value){
						        if(value=="0"){
							       cureRBCResSchduleDataGrid.datagrid('load');
           					       cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"��ʾ",msg:"ִ�гɹ�"});
						        }else if(value=="101"){
							        $.messager.alert('��ʾ',"ִ��ʧ��:"+"������Ч����ͬ��¼,�޷�����ͣ��");
							    }else{
							       $.messager.alert('��ʾ',"ִ��ʧ��:"+value);
						        }
						  
						   },"","",ID,session['LOGON.USERID']);
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫͣ�����", "error");
                }
            }
        },'-',{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	var cureRBCResSchduleColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'����', width: 25, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 60, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 40, align: 'center', sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 50, align: 'center', sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '״̬', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '���ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '�Զ�ԤԼ��', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ChargeTime', title: '��ֹ�ɷ�ʱ��', width: 20, align: 'center', sortable: true,resizable: true
					}
					/*,
					{ field: 'AvailPatType', title: '��������', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '�Զ�ԤԼ���ÿ���', width: 20, align: 'center', sortable: true
					}*/,
					{ field: 'LocDr', title: 'LocDr', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'ResourceDr', title: 'ResourceDr', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'TimePeriodCode', title: 'TimePeriodCode', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'ServiceGroupDr', title: 'ServiceGroupDr', width: 1, align: 'center', sortable: true,hidden:true
					}
    			 ]];
	cureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
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
		columns :cureRBCResSchduleColumns,
		toolbar:cureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();	
       }
	});
	LoadCureRBCResSchduleDataGrid();
}
function LoadCureRBCResSchduleDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
	queryParams.QueryName ='QueryResApptSchdule';
	queryParams.Arg1 =$('#LocName').combobox('getValue');
	queryParams.Arg2 =$('#Resource').combobox('getValue');
	queryParams.Arg3 =$('#BookDate').datebox('getValue');
	queryParams.ArgCnt =3;
	var opts = cureRBCResSchduleDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResSchduleDataGrid.datagrid('load', queryParams);
}
function CheckData(){
	var Date=$('#Date').datebox('getValue');
	if(Date=="")
	{
		$.messager.alert('Warning','��ѡ������');   
        return false;
	}
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
   		var Date=$('#Date').datebox('getValue');
   		var LocId=$('#LocList').combobox('getValue');
   		var ResourceId=$('#ResourceList').combobox('getValue');   
	    var TimeDesc=$('#TimeDesc').combobox('getValue');
	    var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	    var StartTime=$("#StartTime").val();
	    var EndTime=$("#EndTime").val();
	    var Max=$("#Max").val();
	    var AutoNumber=$("#AutoNumber").val();
	    var ChargTime=$("#ChargTime").val();
	    if (Rowid=="")
	    {
	    var InputPara=Date+"^"+LocId+"^"+ResourceId+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		//alert(InputPara);
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","InsertOneRBCSchedule","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCResSchduleDataGrid()
			return true;							
		}else{
			var err=value
			if ((value==101)) err="����Դͬһʱ���Ѿ��Ź����";
             $.messager.alert('��ʾ',"����ʧ��:"+err);
			return false;
		}
	   },"","",InputPara,session['LOGON.USERID']);
	    }else{
		var InputPara=Rowid+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","UpdateOneRBCSchedule","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCResSchduleDataGrid()
			return true;							
		}else{
			if ((value==104)||(value==105)) err="����ִ�м�¼����";
            $.messager.alert('��ʾ',"����ʧ��:"+err);
			return false;
		}
	   },"","",InputPara,session['LOGON.USERID']);	
		}
}
///�޸ı����
function UpdateGridData(){
   var rows = cureRBCResSchduleDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
	 	$('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //��ձ�����
	 	$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocDr)
		var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocDr+"&ArgCnt=1";
		$('#ResourceList').combobox('clear');
		$('#ResourceList').combobox('reload',url);
		$('#ResourceList').combobox('setValue',rows[0].ResourceDr)
		$('#TimeDesc').combobox('setValue',rows[0].TimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].ServiceGroupDr)
		 $('#add-form').form("load",{
		 Rowid:rows[0].Rowid,
		 Date:rows[0].DDCRSDate,
		 StartTime:rows[0].StartTime,
		 EndTime:rows[0].EndTime,
		 Max:rows[0].MaxNumber,
		 AutoNumber:rows[0].AutoNumber,
		 ChargTime:rows[0].ChargTime	 	 
	 })
	 $('#LocList').combobox("disable")
	 $('#ResourceList').combobox("disable")
	 $('#TimeDesc').combobox("disable") 
	 $('#Date').datebox("disable")    
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}
