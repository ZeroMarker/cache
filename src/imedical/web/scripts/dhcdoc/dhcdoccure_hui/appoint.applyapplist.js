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
		text:'添加治疗记录', 
		iconCls:'icon-add',  
		handler:function(){
			AddCureRecord();
		}
	}
	,'-',
	{
		id:'BtnDelete',
		text:'取消预约',
		iconCls:'icon-cancel',
		handler:function(){
			CancelCureAppoint();
		}
	},'-',
	/*{
		id:'BtnPrint',
		text:'打印预约治疗凭证',
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
					$.messager.alert("提示","请选择一条预约记录");	
				}
		}
	},'-',*/
	{
		id:'BtnPrint',
		text:'打印预约治疗凭证',
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
					$.messager.alert("提示","请选择需要打印的患者预约记录");	
				}
		}
	},'-',{
		id:'BtnDetailViews',
		text:'批量添加治疗记录',
		iconCls:'icon-add',
		handler:function(){
			GenAddCureRecord();
		}
	},'-',{
		id:'BtnDeletes',
		text:'批量取消预约记录',
		iconCls:'icon-cancel',
		handler:function(){
			GenCancelCureAppoint();
		}
	}];
	// 治疗申请单预约记录Grid
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
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:10,
		pageList : [10,25,50,100],
		columns :[[     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{field:'RowCheck',checkbox:true},
					{field:'PatientNo',title:'登记号',width:40,align:'center'},   
        			{field:'PatientName',title:'姓名',width:40,align:'center'},  
					{field:'ArcimDesc',title:'治疗项目',width:150,align:'center'},
					{ field: 'DDCRSDate', title:'日期', width: 90, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 150, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 60, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 100, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '排班状态', width: 60, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: '预约状态', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: '预约操作人', width: 60, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: '预约操作时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '更新人', width: 60, align: 'center',resizable: true
					},
					{ field: 'LastUpdateDate', title: '更新时间', width: 80, align: 'center',resizable: true
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
        $.messager.alert("错误", "取消预约请到治疗预约平台", 'error')
        return false;
    }  
    var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	//alert(length)
	if(length>1){
		$.messager.alert("提示","只能取消预约一条预约记录,如需多条取消，请选择批量取消预约功能.");	
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
						$.messager.show({title:"提示",msg:"取消成功"});
					}else{
						if(value=="100")value="入参为空"
						else if(value=="101")value="预约状态不是已预约的记录不能取消"
						$.messager.alert('提示',"取消失败:"+value);
					}
				});
			}
	}else{
		$.messager.alert("提示","请选择一条预约记录");	
	}	
}

function GenCancelCureAppoint(){
	var OperateType=$('#OperateType').val();
	if (OperateType!="ZLYY")
    {
        $.messager.alert("错误", "取消预约请到治疗预约平台", 'error')
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
		$.messager.confirm('确认','是否确认操作?',function(r){    
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
	   					$.messager.show({title:"提示",msg:"取消成功"});	
	   					CureApplyAppDataGridLoad();
					}else{
						$.messager.alert('提示',"取消失败:"+RtnStr);
					}
				})
		    }
		})
	}else{
		$.messager.alert("提示","请选择一条预约记录");		
	}	
}

function GenAddCureRecord(){
	var OperateType=$('#OperateType').val();
	if (OperateType!="ZLYS")
    {
        $.messager.alert("错误", "添加治疗记录请到治疗工作平台", 'error')
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
		$.messager.confirm('确认','批量添加治疗记录将按照系统默认取值保存治疗记录内容,是否确认继续批量添加?',function(r){    
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
	   					$.messager.show({title:"提示",msg:"添加成功"});	
	   					CureApplyAppDataGridLoad();
					}else{
						$.messager.alert('提示',"添加失败:"+RtnStr);
					}
				})
		    }    
		});  
		
	}else{
		$.messager.alert("提示","请选择一条预约记录");		
	}
}
function AddCureRecord(){
	var OperateType=$('#OperateType').val();
    if (OperateType!="ZLYS")
    {
        $.messager.alert("错误", "添加治疗记录请到治疗工作平台", 'error')
        return false;
    } 
    var rows = CureApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length>1){
		$.messager.alert("提示","只能为一条预约记录添加治疗记录,如需多条添加,请选择批量添加治疗记录功能.");	
		return false;	
	}
	var selected = CureApplyAppDataGrid.datagrid('getSelected');
	if (selected){
		if((typeof(selected.DCAAStatus) != "undefined")&&(selected.DCAAStatus=="取消预约")){
			$.messager.alert("提示","该预约记录已经取消,不允许添加治疗记录");	
			return false;
		}
		if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
			var Rowid=selected.Rowid;
			//alert(Rowid)
			OpenCureRecordDiag(Rowid);
		}
	}else{
		$.messager.alert("提示","请选择一条预约记录");	
	}	
}

function PrintCureAppXML(DCAARowId)
{
	if (DCAARowId==""){
		$.messager.alert("提示","请选择需要打印的申请单据")
		return false
	}
	DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrt"); 
	var DCARowId=DCAARowId.split("||")[0];
	var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
	//alert(AppointRtnStr)
	if(RtnStr==""){
		$.messager.alert("提示","获取申请单信息错误")
		return false
	}
	var MyList="";
	var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",DCARowId)
	if(AppointRtnStr==""){
		$.messager.alert("提示","未有正常预约的预约纪录,请确认.")
		return false
	}
	var AppointRtnArr=AppointRtnStr.split("^");
	
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
	//alert(RtnStrArry)
	//return
	var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
	var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息		
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
			var PrintPageText="第 "+PrintPage+" 页  共 "+PageTotal+" 页"
			//var MyPara=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
			DHCP_PrintFunNew(myobj,MyPara,MyList);
			MyList="";
		}
	}
	if((AppointRtnLen%LimitRow)>0){
		var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
		//var MyPara=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
		//alert(MyPara)
		DHCP_PrintFunNew(myobj,MyPara,MyList);
	}
	
	//打印成功后给患者发送短信
	//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","SendMessage",DCARowId,session['LOGON.USERCODE'])
	//if(ret!="0"){
	//	$.messager.alert("提示","短信纪录发送失败,请确认.")
	//	return false
	//}
	
	
}
//Excel模板打印
function PrintCureApp(DCAARowId)
{
		if (DCAARowId==""){
			$.messager.alert("提示","请选择需要打印的申请单据")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
		//alert(getpath)

		//http://172.18.0.12/trakcarelive/trak/med/Templates/
		var Template=getpath+"DHCDocCurApplay.xls";
		var xlApp,xlsheet,xlBook
	 
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //用来指定模板的开始行数位置
		var xlsCurcol=1;  //用来指定开始的列数位置
		
		var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetCureAppointment",DCAARowId)
		if(AppointRtnStr==""){
			$.messager.alert("提示","获取预约信息错误")
			return false
		}
		var DCARowId=DCAARowId.split("||")[0];
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		//alert(AppointRtnStr)
		
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		//alert(RtnStrArry)
		//return
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息		
		
		//68^骨伤科门诊^5305^古永恒^10/12/2017^3^骨科1^08:00:00^08:30:00^3^骨科熏蒸治疗^正常^10^^^^2570^13977461||3||8^9147^古永恒^10/11/2017^17:04:54^手动^已预约^^^^
		var AppointRtnArr=AppointRtnStr.split(String.fromCharCode(1));
		var RSStrArr=AppointRtnArr[0].split("^");
		var AppointInfo=RSStrArr[1]+" "+RSStrArr[3]+" 预约时段:"+RSStrArr[4]+" "+RSStrArr[7]+"-"+RSStrArr[8]
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