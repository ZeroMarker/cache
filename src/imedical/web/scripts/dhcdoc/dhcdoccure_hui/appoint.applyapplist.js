var CureApplyAppDataGrid;
$(document).ready(function(){
	InitCureApplyAppDataGrid();
	CureApplyAppDataGridLoad();		
});

function InitCureApplyAppDataGrid()
{
	var cureApplyAppToolBar = [
	{
		id:'BtnDetailView',
		text:'������Ƽ�¼', 
		iconCls:'icon-add',  
		handler:function(){
			AddCureRecord();
		}
	}
	,'-',
	{
		id:'BtnDelete',
		text:'ȡ��ԤԼ',
		iconCls:'icon-cancel',
		handler:function(){
			CancelCureAppoint();
		}
	},'-',
	/*{
		id:'BtnPrint',
		text:'��ӡԤԼ����ƾ֤',
		iconCls:'icon-print',
		handler:function(){
			    var OperateType=$('#OperateType').val();
	            
				var selected = CureApplyAppDataGrid.datagrid('getSelected');
				if (selected){
					if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
						var Rowid=selected.Rowid;
						PrintCureApp(Rowid);
					}
				}else{
					$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");	
				}
		}
	},'-',*/
	{
		id:'BtnPrint',
		text:'��ӡԤԼ����ƾ֤',
		iconCls:'icon-print',
		handler:function(){
			    var OperateType=$('#OperateType').val();
				var selected = CureApplyAppDataGrid.datagrid('getSelected');
				if (selected){
					if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
						var Rowid=selected.Rowid;
						PrintCureAppXML(Rowid);
					}
				}else{
					$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�Ļ���ԤԼ��¼");	
				}
		}
	},'-',{
		id:'BtnDetailViews',
		text:'����������Ƽ�¼',
		iconCls:'icon-add',
		handler:function(){
			GenAddCureRecord();
		}
	},'-',{
		id:'BtnDeletes',
		text:'����ȡ��ԤԼ��¼',
		iconCls:'icon-cancel',
		handler:function(){
			GenCancelCureAppoint();
		}
	}];
	// �������뵥ԤԼ��¼Grid
	CureApplyAppDataGrid=$('#tabCureApplyApp').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:10,
		pageList : [10,25,50,100],
		columns :[[     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{field:'RowCheck',checkbox:true},
					{field:'PatientNo',title:'�ǼǺ�',width:40,align:'center'},   
        			{field:'PatientName',title:'����',width:40,align:'center'},  
					{field:'ArcimDesc',title:'������Ŀ',width:150,align:'center'},
					{ field: 'DDCRSDate', title:'����', width: 90, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'����', width: 150, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '��Դ', width: 60, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 100, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 80, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 80, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '�Ű�״̬', width: 60, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: 'ԤԼ״̬', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: 'ԤԼ������', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 80, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '������', width: 60, align: 'center',resizable: true
					},
					{ field: 'LastUpdateDate', title: '����ʱ��', width: 80, align: 'center',resizable: true
					}   
    			 ]] ,
    	toolbar : cureApplyAppToolBar
	});
}
function CureApplyAppDataGridLoad(DCARowId)
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var DCARowId=$('#DCARowId').val();
	if(DCARowIdStr!="")DCARowId=DCARowIdStr;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		QueryName:"FindAppointmentListHUI",
		'DCARowId':DCARowId,
		'QueryState':"",
		Pagerows:CureApplyAppDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureApplyAppDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}
function OpenCureRecordDiag(DCAARowId)
{
	var href="doccure.curerecord.hui.csp?DCAARowId="+DCAARowId+"&OperateType="+$('#OperateType').val()+"&DCRRowId=";;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:50em;dialogheight:25em;status:no;center:1;resizable:yes");
}

function CancelCureAppoint(){
	var OperateType=$('#OperateType').val();
    if (OperateType!="ZLYY")
    {
        $.messager.alert("����", "ȡ��ԤԼ�뵽����ԤԼƽ̨", 'error')
        return false;
    }  
    var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	//alert(length)
	if(length>1){
		$.messager.alert("��ʾ","ֻ��ȡ��ԤԼһ��ԤԼ��¼,�������ȡ������ѡ������ȡ��ԤԼ����.");	
		return false;	
	}
	var selected = CureApplyAppDataGrid.datagrid('getSelected');
		if (selected){
			if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
				var Rowid=selected.Rowid;
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Appointment",
					MethodName:"AppCancelHUI",
					'DCAARowId':Rowid,
					'UserDR':session['LOGON.USERID'],
				},function testget(value){
					if(value=="0"){
						//CureApplyAppDataGrid.datagrid('load');
						CureApplyAppDataGridLoad();
						CureApplyAppDataGrid.datagrid('unselectAll');
						$.messager.show({title:"��ʾ",msg:"ȡ���ɹ�"});
					}else{
						if(value=="100")value="���Ϊ��"
						else if(value=="101")value="ԤԼ״̬������ԤԼ�ļ�¼����ȡ��"
						$.messager.alert('��ʾ',"ȡ��ʧ��:"+value);
					}
				});
			}
	}else{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");	
	}	
}

function GenCancelCureAppoint(){
	var OperateType=$('#OperateType').val();
	if (OperateType!="ZLYY")
    {
        $.messager.alert("����", "ȡ��ԤԼ�뵽����ԤԼƽ̨", 'error')
        return false;
    }  
	var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	var finflag=0;
	var selRowid="";
	for(var i=0;i<length;i++){
		
		var MyrowIndex = CureApplyAppDataGrid.datagrid("getRowIndex", rows[i]);
		var myselected=CureApplyAppDataGrid.datagrid('getRows'); 
		
		var Rowid=myselected[MyrowIndex].Rowid;
		if(selRowid==""){
			selRowid=Rowid;
		}else{
			selRowid=selRowid+"^"+Rowid;	
		}
				 
	}
	if(selRowid!=""){
		$.messager.confirm('ȷ��','�Ƿ�ȷ�ϲ���?',function(r){    
		    if (r){ 
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Appointment",
					MethodName:"AppCancelBatch",
					"DCAARowIdStr":selRowid,
					"UserDR":session['LOGON.USERID'],
				},function testget(value){
					if(value==""){
						//CureApplyAppDataGrid.datagrid('load');
	   					CureApplyAppDataGrid.datagrid('unselectAll');
	   					$.messager.show({title:"��ʾ",msg:"ȡ���ɹ�"});	
	   					CureApplyAppDataGridLoad();
					}else{
						$.messager.alert('��ʾ',"ȡ��ʧ��:"+RtnStr);
					}
				})
		    }
		})
	}else{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");		
	}	
}

function GenAddCureRecord(){
	var OperateType=$('#OperateType').val();
	if (OperateType!="ZLYS")
    {
        $.messager.alert("����", "������Ƽ�¼�뵽���ƹ���ƽ̨", 'error')
        return false;
    }  
	var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	var finflag=0;
	var selRowid="";
	for(var i=0;i<length;i++){
		
		var MyrowIndex = CureApplyAppDataGrid.datagrid("getRowIndex", rows[i]);
		var myselected=CureApplyAppDataGrid.datagrid('getRows'); 
		
		var Rowid=myselected[MyrowIndex].Rowid;
		if(selRowid==""){
			selRowid=Rowid;
		}else{
			selRowid=selRowid+"^"+Rowid;	
		}
				 
	}
	if(selRowid!=""){
		$.messager.confirm('ȷ��','����������Ƽ�¼������ϵͳĬ��ȡֵ�������Ƽ�¼����,�Ƿ�ȷ�ϼ����������?',function(r){    
		    if (r){    
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Record",
					MethodName:"SaveCureRecordBatch",
					"DCRRowIdStr":selRowid,
					"UserDR":session['LOGON.USERID'],
				},function testget(value){
					if(value==""){
						//CureApplyAppDataGrid.datagrid('load');
	   					CureApplyAppDataGrid.datagrid('unselectAll');
	   					$.messager.show({title:"��ʾ",msg:"��ӳɹ�"});	
	   					CureApplyAppDataGridLoad();
					}else{
						$.messager.alert('��ʾ',"���ʧ��:"+RtnStr);
					}
				})
		    }    
		});  
		
	}else{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");		
	}
}
function AddCureRecord(){
	var OperateType=$('#OperateType').val();
    if (OperateType!="ZLYS")
    {
        $.messager.alert("����", "������Ƽ�¼�뵽���ƹ���ƽ̨", 'error')
        return false;
    } 
    var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length>1){
		$.messager.alert("��ʾ","ֻ��Ϊһ��ԤԼ��¼������Ƽ�¼,����������,��ѡ������������Ƽ�¼����.");	
		return false;	
	}
	var selected = CureApplyAppDataGrid.datagrid('getSelected');
	if (selected){
		if((typeof(selected.DCAAStatus) != "undefined")&&(selected.DCAAStatus=="ȡ��ԤԼ")){
			$.messager.alert("��ʾ","��ԤԼ��¼�Ѿ�ȡ��,������������Ƽ�¼");	
			return false;
		}
		if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
			var Rowid=selected.Rowid;
			//alert(Rowid)
			OpenCureRecordDiag(Rowid);
		}
	}else{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼");	
	}	
}

function PrintCureAppXML(DCAARowId)
{
	if (DCAARowId==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�����뵥��")
		return false
	}
	DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrt"); 
	var DCARowId=DCAARowId.split("||")[0];
	var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
	//alert(AppointRtnStr)
	if(RtnStr==""){
		$.messager.alert("��ʾ","��ȡ���뵥��Ϣ����")
		return false
	}
	var MyList="";
	var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",DCARowId)
	if(AppointRtnStr==""){
		$.messager.alert("��ʾ","δ������ԤԼ��ԤԼ��¼,��ȷ��.")
		return false
	}
	var AppointRtnArr=AppointRtnStr.split("^");
	
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
	//alert(RtnStrArry)
	//return
	var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
	var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ		
	var PatID=PatientArr[0]
	var PatNo=PatientArr[1];
	var PatName=PatientArr[2];
	var PatSex=PatientArr[3];
	var PatAge=PatientArr[4];
	//var PatType=PatientArr[6];
	var PatTel=PatientArr[24];
	var PatAddress=PatientArr[10];
	var ApplyUser=CureApplyArr[7]
	var ArcimDesc=CureApplyArr[0]
	var AppReloc=CureApplyArr[4];
	
	var MyPara="";
    MyPara="PAPMINo"+String.fromCharCode(2)+PatNo;
    MyPara=MyPara+"^Name"+String.fromCharCode(2)+PatName;
    MyPara=MyPara+"^Age"+String.fromCharCode(2)+PatAge;
    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+PatSex;
    MyPara=MyPara+"^Mobile"+String.fromCharCode(2)+PatTel;
    MyPara=MyPara+"^RecDep"+String.fromCharCode(2)+AppReloc;
    MyPara=MyPara+"^ArcimDesc"+String.fromCharCode(2)+ArcimDesc;
    MyPara=MyPara+"^ApplyDoc"+String.fromCharCode(2)+ApplyUser;
    MyPara=MyPara+"^PatientCode"+String.fromCharCode(2)+PatNo;
    
    var myobj=document.getElementById("ClsBillPrint");
	//var MyList="";
	var LimitRow=6;
	var PrintPage=0;
	var PageTotal=Math.ceil(AppointRtnArr.length/LimitRow);
	var AppointRtnLen=AppointRtnArr.length;
	for(var i=1;i<=AppointRtnLen;i++){
		if(MyList==""){MyList=AppointRtnArr[i-1];}
		else{MyList=MyList+String.fromCharCode(2)+AppointRtnArr[i-1];}
		//alert(i+"&&&"+(i%LimitRow))
		if ((i>1)&&(i%LimitRow==0)) {
			var PrintPage=PrintPage+1;
			var PrintPageText="�� "+PrintPage+" ҳ  �� "+PageTotal+" ҳ"
			//var MyPara=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
			DHCP_PrintFunNew(myobj,MyPara,MyList);
			MyList="";
		}
	}
	if((AppointRtnLen%LimitRow)>0){
		var PrintPageText="�� "+PageTotal+" ҳ  �� "+PageTotal+" ҳ"
		//var MyPara=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
		//alert(MyPara)
		DHCP_PrintFunNew(myobj,MyPara,MyList);
	}
	
	//��ӡ�ɹ�������߷��Ͷ���
	//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","SendMessage",DCARowId,session['LOGON.USERCODE'])
	//if(ret!="0"){
	//	$.messager.alert("��ʾ","���ż�¼����ʧ��,��ȷ��.")
	//	return false
	//}
	
	
}
//Excelģ���ӡ
function PrintCureApp(DCAARowId)
{
		if (DCAARowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�����뵥��")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
		//alert(getpath)

		//http://172.18.0.12/trakcarelive/trak/med/Templates/
		var Template=getpath+"DHCDocCurApplay.xls";
		var xlApp,xlsheet,xlBook
	 
		//���ұ߾�
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
		var xlsCurcol=1;  //����ָ����ʼ������λ��
		
		var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetCureAppointment",DCAARowId)
		if(AppointRtnStr==""){
			$.messager.alert("��ʾ","��ȡԤԼ��Ϣ����")
			return false
		}
		var DCARowId=DCAARowId.split("||")[0];
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		//alert(AppointRtnStr)
		
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		//alert(RtnStrArry)
		//return
		var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
		var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ		
		
		//68^���˿�����^5305^������^10/12/2017^3^�ǿ�1^08:00:00^08:30:00^3^�ǿ�Ѭ������^����^10^^^^2570^13977461||3||8^9147^������^10/11/2017^17:04:54^�ֶ�^��ԤԼ^^^^
		var AppointRtnArr=AppointRtnStr.split(String.fromCharCode(1));
		var RSStrArr=AppointRtnArr[0].split("^");
		var AppointInfo=RSStrArr[1]+" "+RSStrArr[3]+" ԤԼʱ��:"+RSStrArr[4]+" "+RSStrArr[7]+"-"+RSStrArr[8]
		var AppointUser=AppointRtnArr[1].split("^")[3];
		var CureDateTime=AppointRtnArr[1].split("^")[12];
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var AdmID=CureApplyArr[15]
		var AppLoc=CureApplyArr[16]
		var AppInsertDate=CureApplyArr[17]
		var UnitPrice=CureApplyArr[18]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		
		
		//xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
		xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
		xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
		xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=UnitPrice
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyDate
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ArcimDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppointInfo
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppointUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=session['LOGON.USERNAME']
		xlsheet.cells(xlsrow,xlsCurcol+6)=CureDateTime
	
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    xlBook.printout()
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	
}