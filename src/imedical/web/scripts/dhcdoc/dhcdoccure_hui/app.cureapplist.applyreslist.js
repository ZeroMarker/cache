function InitApplyResListEvent(){
	$('#btnSearchApp').bind("click",function(){
		CureRBCResSchduleDataGridLoad();	
	})
	$('#btnApp').bind("click",function(){
		BtnAppClick();	
	})
}

function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
	var EndDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		'a':"7",
		dataType:"text"   
	},false);
    $("#Apply_StartDate").datebox('setValue',CurDay);	
    $("#Apply_EndDate").datebox('setValue',EndDay);		
}

function InitCureRBCResSchduleDataGrid()
{  
	var cureRBCResSchduleColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'����', width: 30, align: 'left', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 60, align: 'left', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 20, align: 'left', sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 40, align: 'left', sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 30, align: 'left', sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 30, align: 'left', sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 50, align: 'left', sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '״̬', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AppedLeftNumber', title: 'ʣ���ԤԼ��', width: 30, align: 'left', sortable: true,resizable: true,
						styler: function(value,row,index){
							value=parseFloat(value)
							row.MaxNumber=parseFloat(row.MaxNumber)
							if (value ==0){
								return 'background:red;';
							}else if((value >0)&&(value<row.MaxNumber)){
								return 'background:#ffee00;';
							}else{
								return 'background:green;';
							}
						}
					},
					{ field: 'AppedNumber', title: '��ԤԼ��', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '���ԤԼ��', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '�Զ�ԤԼ��', width: 20, align: 'left', sortable: true,resizable: true, hidden: true
					},
					{ field: 'ChargeTime', title: '��ֹ�ɷ�ʱ��', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AvailPatType', title: '��������', width: 20, align: 'left', hidden: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '�Զ�ԤԼ���ÿ���', width: 20, align: 'left', hidden: true
					}
    			 ]];
	CureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		//width : 500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:10,
		pageList : [10,50,100,200],
		columns :cureRBCResSchduleColumns,
		rowStyler:function(rowIndex, rowData){
 			if (rowData.DDCRSStatus!="����"){
	 			return 'color:#788080;';
	 		}
		},
		
	});
	CureRBCResSchduleDataGridLoad();
}
function CureRBCResSchduleDataGridLoad()
{
	var DCARowId="" //$('#DCARowId').val();
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID //$('#DCARowIdStr').val();
	//var AppDate=$('#Apply_AppDate').datebox('getValue');
	var AppStartDate=$('#Apply_StartDate').datebox('getValue');
	var AppEndDate=$('#Apply_EndDate').datebox('getValue');
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		QueryName:"QueryAvailResApptSchdule",
		'DCARowId':DCARowIdStr,
		'BookDate':"",
		'DCARowIdStr':DCARowIdStr,
		'StartDate':AppStartDate,
		'EndDate':AppEndDate,
		Pagerows:CureRBCResSchduleDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResSchduleDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function BtnAppClick(){
	var OperateType=$('#OperateType').val();
    if (OperateType=="ZLYS")
    {
        $.messager.alert("��ʾ", "ֻ������ǰ̨��ҽ��������ԤԼ", 'error')
        return false;
    }  
    var DCARowId=$('#DCARowId').val();
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID //$('#DCARowIdStr').val();
    if(DCARowIdStr=="")
    {
        $.messager.alert("��ʾ", "��ѡ��һ�����뵥", 'error')
		return false;
    }
    var rows = CureRBCResSchduleDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].Rowid);
		}
		var ID=ids.join(',')
		var DCARowIdArr=DCARowIdStr.split("!");
		var err="";
		for(var j=0;j<DCARowIdArr.length;j++){	
			var oneDCARowId=DCARowIdArr[j];		
			var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
			var PatName="";
			var ArcimDesc="";
			if(CurePatInfo!=""){
				var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
				var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
				var PatName=CurePatInfo.split("^")[2];
				var ArcimDesc=CureInfo.split("^")[0];
			}
			/*var ApplyNoAppTimes=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetApplyNoAppTimes",oneDCARowId);
			if(ApplyNoAppTimes==1){
				var myerr="'"+PatName+" "+ArcimDesc+"'"+",��������Ϊ���һ�ο�ԤԼ";
				$.messager.alert('��ʾ',myerr);
			}
			*/
			var Para=oneDCARowId+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID'];
			//����ԤԼ����Ҫ����ͬ������
			var ObjScope=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Appointment",
				MethodName:"AppInsertHUI",
				'Para':Para,
				'JSONType':"JSON",
			},false);
			var value=ObjScope.result;
			if(value=="0"){
				//var obj=window.frames.parent
			}else{
				var err=value
				if (value==100) err="�в���Ϊ��";
				else if(value==101) err="ͣ����Ű಻��ԤԼ";
				else if(value==1001) err="�ѳ��������벻��ԤԼ";
				else if(value==102) err="���Ű��Ѿ�����ԤԼʱ��,����ԤԼ"; //��ǰ����ԤԼʱ��>��Դ��ʼʱ��
				else if(value==103) err="�����뵥��������Ŀ�����Ѿ�Լ��"; //ҽ������-�Ѿ�ԤԼ������=0�򲻿���ԤԼ
				else if(value==1031) err="�����뵥��ԤԼ��������";
				else if((value==104)||(value==105)) err="����ִ�м�¼����";
				else if(value==106) err="���Ű���ԤԼ��,������ԤԼ";
				else if(value==107) err="�����������Ч��ԤԼδ���Ƶļ�¼,�����ظ�ԤԼ";
				else if(value==108) err="������ҽ��δ�ɷ�,�޷�����ԤԼ";
				else if(value==109) err="������ҽ��Ϊ����,�޷�����ԤԼ,��ֱ��ִ��";
				else if(value=="202") err="������Ϊֱ��ִ������ҽ��,����ԤԼ";
				else if(value=="203") err="������ҽ����ֹͣ,����ԤԼ";
				err="'"+PatName+" "+ArcimDesc+"'"+"ԤԼʧ��,ʧ��ԭ��:"+err;
				$.messager.alert('��ʾ',"ԤԼʧ��:"+err);
			}
		}
		//CureRBCResSchduleDataGrid.datagrid('load');
		CureRBCResSchduleDataGridLoad();
		CureRBCResSchduleDataGrid.datagrid('unselectAll');
		if(err==""){$.messager.show({title:"��ʾ",msg:"ԤԼ�ɹ�"});}
		if(window.frames.parent.CureApplyDataGrid){
			window.frames.parent.RefreshDataGrid();
		}else{
			RefreshDataGrid();	
		}
    } else {
        $.messager.alert("��ʾ", "��ѡ��ҪԤԼ����Դ", "error");
    }
}