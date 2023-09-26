var cureApplyAppDataGrid;
$(function(){
	InitCureApplyAppDataGrid();
	loadCureApplyAppDataGrid();
		
});

function InitCureApplyAppDataGrid()
{
	// Toolbar
	var cureApplyAppToolBar = [
	{
		id:'BtnDetailView',
		text:'������Ƽ�¼', 
		iconCls:'icon-add',  
		handler:function(){
					var OperateType=$('#OperateType').val();
					if (OperateType!="ZLYS")
	            	{
		           	 	$.messager.alert("����", "ֻ������ҽ������������Ƽ�¼", 'error')
		            	return false;
		        	}  
					var selected = cureApplyAppDataGrid.datagrid('getSelected');
					if (selected){
						if((typeof(selected.DCAAStatus) != "undefined")&&(selected.DCAAStatus=="ȡ��ԤԼ")){
							$.messager.alert("��ʾ","��ԤԼ��¼�Ѿ�ȡ��,������������Ƽ�¼");	
							return false;
						}
						if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
							var Rowid=selected.Rowid;
							OpenCureRecordDiag(Rowid);
						}
					}else{
					$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");	
				}
		}
	}
	,'-',
	{
		id:'BtnDelete',
		text:'ȡ��ԤԼ',
		iconCls:'icon-cut',
		handler:function(){
			    var OperateType=$('#OperateType').val();
	            if (OperateType=="ZLYS")
	            {
		            $.messager.alert("����", "ֻ������ǰ̨��ҽ������ȡ��ԤԼ", 'error')
		            return false;
		        }  
				var selected = cureApplyAppDataGrid.datagrid('getSelected');
					if (selected){
						if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
							var Rowid=selected.Rowid;
							var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","AppCancel",Rowid,session['LOGON.USERID']);
							if (ret==0){
								cureApplyAppDataGrid.datagrid('load');
           						cureApplyAppDataGrid.datagrid('unselectAll');
           						$.messager.alert("��ʾ","ȡ���ɹ�")
							}else{
								var mesage=""
								if(ret=="100")mesage="���Ϊ��"
								else if(ret=="101")mesage="ԤԼ״̬������ԤԼ�ļ�¼����ȡ��"
								else if(ret=="102")value="ִ�м�¼�Ѿ��ƷѲ���ȡ��,��ȡ�����û�ʿ��ʵ����ִ��"
								else mesage=ret
								$.messager.alert('��ʾ',"ȡ��ʧ��:"+mesage);
								return false
								
							}
						
							loadCureApplyAppDataGrid();
							if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
						}
					}else{
					$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");	
				}
		}
	}];
	// �������뵥ԤԼ��¼Grid
	cureApplyAppDataGrid=$('#tabCureApplyApp').datagrid({  
		fit : true,
		width : 450,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"Rowid",
		pageList : [15,50,100,200],
		columns :[[     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'����', width: 90, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 150, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 60, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 100, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 60, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 60, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 80, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '�Ű�״̬', width: 30, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: 'ԤԼ״̬', width: 50, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: 'ԤԼ������', width: 50, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 80, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '������', width: 50, align: 'center',resizable: true
					},
					{ field: 'LastUpdateDate', title: '����ʱ��', width: 80, align: 'center',resizable: true
					}   
    			 ]] ,
    	toolbar : cureApplyAppToolBar
	});
}
function loadCureApplyAppDataGrid(DCARowId)
{
	var DCARowId=$('#DCARowId').val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Appointment';
	queryParams.QueryName ='FindAppointmentList';
	queryParams.Arg1 =DCARowId;
	queryParams.Arg2 ="";
	queryParams.ArgCnt =2;
	var opts = cureApplyAppDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp";
	cureApplyAppDataGrid.datagrid('load', queryParams);
	cureApplyAppDataGrid.datagrid('unselectAll');
}
function OpenCureRecordDiag(DCAARowId)
{
	var OperateType=$('#OperateType').val();
	var href="dhcdoc.cure.curerecord.csp?OperateType="+OperateType+"&DCAARowId="+DCAARowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#cureRecordDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "���Ƽ�¼��",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });
    */ 
}

