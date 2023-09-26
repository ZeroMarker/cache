function InitApplyAppListEvent(){
	$HUI.checkbox("#OnlyApp",{
		onChecked:function(e,val){
			setTimeout("CureApplyAppDataGridLoad();",10)
		},
		onUnchecked:function(e,val){
			setTimeout("CureApplyAppDataGridLoad();",10)
		},
	})	
}

function InitCureApplyAppDataGrid()
{
	var cureApplyAppToolBar = [
	{
		id:'BtnDelete',
		text:'取消预约',
		iconCls:'icon-cancel',
		handler:function(){
			CancelCureAppoint();
		}
	},
	{
		id:'BtnPrint',
		text:'打印预约治疗凭证',
		iconCls:'icon-print',
		handler:function(){
			BtnPrintApplyClick();
		}
	},{
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
		pageList : [10,25,50],
		columns :[[     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
					}, 
					{field:'RowCheck',checkbox:true},
					{field:'PatientNo',title:'登记号',width:100,align:'left'},   
        			{field:'PatientName',title:'姓名',width:80,align:'left'},  
					{field:'ArcimDesc',title:'治疗项目',width:150,align:'left'},
					{ field: 'DDCRSDate', title:'日期', width: 90, align: 'left', sortable: true, resizable: true  
					},
					{field:'DCASeqNo',title:'排队序号',width:80,align:'left'},
					{ field: 'LocDesc', title:'科室', width: 150, align: 'left', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 100, align: 'left', resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 100, align: 'left', resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 80, align: 'left',resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 80, align: 'left',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'left',resizable: true
					},
					{ field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true
					},
					{ field: 'DCAAStatus', title: '预约状态', width: 80, align: 'left',resizable: true
					},
					{ field: 'ReqUser', title: '预约操作人', width: 80, align: 'left',resizable: true
					},
					{ field: 'ReqDate', title: '预约操作时间', width: 80, align: 'left',resizable: true
					},
					{ field: 'LastUpdateUser', title: '更新人', width: 80, align: 'left',resizable: true
					},
					{ field: 'LastUpdateDate', title: '更新时间', width: 80, align: 'left',resizable: true
					}   
    			 ]] ,
    	//toolbar : cureApplyAppToolBar,
    	onBeforeLoad:function(){
			//$("div.datagrid-toolbar [id ='BtnDetailView']").eq(0).hide();  
            //$("div.datagrid-toolbar [id ='BtnDetailViews']").eq(0).hide();  

	    }
	});
}
function CureApplyAppDataGridLoad()
{
	
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
	var DCARowId=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowId').val();
		
	var QueryState="";
	var OperateType=$('#OperateType').val();
	var CheckOnlyApp="";
	var OnlyApp=$("#OnlyApp").prop("checked");
	if (OnlyApp){QueryState="^I^"};

	if(DCARowIdStr!="")DCARowId=DCARowIdStr;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		QueryName:"FindAppointmentListHUI",
		'DCARowId':DCARowId,
		'QueryState':QueryState,
		'Type':"",
		Pagerows:CureApplyAppDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureApplyAppDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		CureApplyAppDataGrid.datagrid("clearSelections");
		CureApplyAppDataGrid.datagrid("clearChecked");	
	})
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
						if(window.frames.parent.CureApplyDataGrid){
							window.frames.parent.RefreshDataGrid();
						}else{
							RefreshDataGrid();	
						}
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
	   					if(window.frames.parent.CureApplyDataGrid){
							window.frames.parent.RefreshDataGrid();
						}else{
							RefreshDataGrid();	
						}
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

function BtnPrintApplyClick(){
	DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrt"); 
	var OperateType=$('#OperateType').val();
	var SelectIDArr={};
	var rows = CureApplyAppDataGrid.datagrid("getSelections");
	if (rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            var Rowid=rows[i].Rowid;
            if(Rowid=="")continue;
            var DCARowID=Rowid.split("||")[0];
	        var FindFlag=false;
	        for (var key in SelectIDArr) {
		        if (key == DCARowID) {
		            if (SelectIDArr[key].indexOf(Rowid) == -1){
			            if(SelectIDArr[key] == "") {
		                	SelectIDArr[key]=Rowid;
			            }else{
				        	SelectIDArr[key]+="^"+Rowid;
				        }
		            }
		            FindFlag=true;
		        }
		    }
			if(!FindFlag){
				SelectIDArr[DCARowID]=Rowid;
			}

        }
        for (var keyVal in SelectIDArr) {
	        var DCAARowIdStr=SelectIDArr[keyVal];
	        //alert(DCAARowIdStr)
	        if(keyVal=="")continue;
			PrintCureAppXML(keyVal,DCAARowIdStr);
        }
	}else{
		$.messager.alert("提示","请选择需要打印的患者预约记录");	
	}	
}

function PrintCureAppXML(ID,IDStr)
{
	//var DCARowId=DCAARowId.split("||")[0];
	var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",ID)
	//alert(AppointRtnStr)
	if(RtnStr==""){
		$.messager.alert("提示","获取申请单信息错误")
		return false
	}
	var MyList="";
	var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",ID,IDStr)
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
			//DHCP_PrintFunNew(myobj,MyPara,MyList);
			DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
			MyList="";
		}
	}
	if((AppointRtnLen%LimitRow)>0){
		var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
		//var MyPara=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
		//alert(MyPara)
		//DHCP_PrintFunNew(myobj,MyPara,MyList);
		DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
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
		
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息		
		
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