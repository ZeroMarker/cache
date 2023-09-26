var CureWorkApplyAppDataGrid;
function InitCureApplyAppDataGrid()
{
	var cureApplyAppToolBar = [
	{
		id:'BtnDetailAdd',
		text:'添加治疗记录', 
		iconCls:'icon-add',  
		handler:function(){
			AddCureRecord();
		}
	},
	{
		id:'BtnPrint',
		text:'打印预约治疗凭证',
		iconCls:'icon-print',
		handler:function(){
			BtnPrintApplyClick()
		}
	},{
		id:'BtnDetailAdds',
		text:'批量添加治疗记录',
		iconCls:'icon-add',
		handler:function(){
			GenAddCureRecord();
		}
	}];
	// 治疗申请单预约记录Grid
	CureWorkApplyAppDataGrid=$('#tabCureWorkApplyApp').datagrid({  
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
					{ field: 'DDCRSDate', title:'日期', width: 100, align: 'left', sortable: true, resizable: true  
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
    	toolbar : cureApplyAppToolBar,
    	onBeforeLoad:function(){
			//$("div.datagrid-toolbar [id ='BtnDetailView']").eq(0).hide();  
            //$("div.datagrid-toolbar [id ='BtnDetailViews']").eq(0).hide();  

	    }
	});
	CureWorkApplyAppDataGridLoad();
}
function CureWorkApplyAppDataGridLoad()
{
	
	var DCARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID; //$('#DCARowIdStr').val();
	var DCARowId=PageWorkListAllObj._WORK_SELECT_DCAROWID; //$('#DCARowId').val();
		
	var QueryState="";
	var OperateType=$('#OperateType').val();
	if(OperateType=="ZLYS"){
		QueryState="^I^A^";
	}
	if(DCARowIdStr!="")DCARowId=DCARowIdStr;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		QueryName:"FindAppointmentListHUI",
		'DCARowId':DCARowId,
		'QueryState':QueryState,
		'Type':"WORK",
		Pagerows:CureWorkApplyAppDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureWorkApplyAppDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		CureWorkApplyAppDataGrid.datagrid("clearSelections");
		CureWorkApplyAppDataGrid.datagrid("clearChecked");	
	})
}

function GenAddCureRecord(){
	var OperateType=$('#OperateType').val();
	if (OperateType!="ZLYS")
    {
        $.messager.alert("提示", "添加治疗记录请到治疗工作平台", 'error')
        return false;
    }  
	var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	var finflag=0;
	var selRowid="";
	for(var i=0;i<length;i++){
		
		var MyrowIndex = CureWorkApplyAppDataGrid.datagrid("getRowIndex", rows[i]);
		var myselected=CureWorkApplyAppDataGrid.datagrid('getRows'); 
		
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
					"LocDeptDr":session['LOGON.CTLOCID']
				},function testget(value){
					if(value==""){
						//CureWorkApplyAppDataGrid.datagrid('load');
	   					//CureWorkApplyAppDataGrid.datagrid('unselectAll');
	   					$.messager.show({title:"提示",msg:"添加成功"});	
	   					CureWorkApplyAppDataGridLoad();
	   					if(window.frames.parent.CureApplyDataGrid){
							window.frames.parent.RefreshDataGrid();
						}else{
							RefreshDataGrid();	
						}
					}else{
						$.messager.alert('提示',"添加失败:"+value);
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
        $.messager.alert("提示", "添加治疗记录请到治疗工作平台", 'error')
        return false;
    } 
    var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length>1){
		$.messager.alert("提示","只能为一条预约记录添加治疗记录,如需多条添加,请选择批量添加治疗记录功能.", 'error');	
		return false;	
	}
	var selected = CureWorkApplyAppDataGrid.datagrid('getSelected');
	if (selected){
		if(typeof(selected.DCAAStatus) != "undefined"){
			if(selected.DCAAStatus=="取消预约"){
				$.messager.alert("提示","该预约记录已经取消,不允许添加治疗记录", 'error');
				CureWorkApplyAppDataGrid.datagrid("clearSelections");
				CureWorkApplyAppDataGrid.datagrid("clearChecked");		
				return false;
			}
			else if(selected.DCAAStatus=="已治疗"){
				$.messager.alert("提示","该预约记录已治疗,不允许添加治疗记录,如需修改,请到治疗记录列表浏览修改.", 'error');	
				CureWorkApplyAppDataGrid.datagrid("clearSelections");
				CureWorkApplyAppDataGrid.datagrid("clearChecked");		
				return false;
			}
		}
		
		if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
			var Rowid=selected.Rowid;
			//alert(Rowid)
			OpenCureRecordDiag(Rowid);
		}
	}else{
		$.messager.alert("提示","请选择一条预约记录", 'error');	
	}	
}

function OpenCureRecordDiag(DCAARowId)
{
	var href="doccure.curerecord.hui.csp?DCAARowId="+DCAARowId+"&OperateType="+$('#OperateType').val()+"&DCRRowId=";;
	/*var ReturnValue=window.showModalDialog(href,"","dialogwidth:50em;dialogheight:25em;status:no;center:1;resizable:yes");
	if (ReturnValue !== "" && ReturnValue !== undefined) 
    {
		if(ReturnValue){
			CureWorkApplyAppDataGridLoad();	
			if(window.frames.parent.CureWorkListDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}
		}
    }*/
    websys_showModal({
		url:href,
		title:'新增治疗记录',
		width:"800px",height:"450px",
		//AfterSaveCureRecord:AfterSaveCureRecord
		onClose: function() {
			AfterSaveCureRecord();
		}
	});
}
function AfterSaveCureRecord(){
	CureWorkApplyAppDataGridLoad();	
	if(window.frames.parent.CureWorkListDataGrid){
		window.frames.parent.RefreshDataGrid();
	}else{
		RefreshDataGrid();	
	}	
}
function BtnPrintApplyClick(){
	DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrt"); 
	var OperateType=$('#OperateType').val();
	var SelectIDArr={};
	var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
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
		$.messager.alert("提示","请选择需要打印的患者预约记录", 'error');	
	}	
}

function PrintCureAppXML(ID,IDStr)
{
	var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",ID)
	if(RtnStr==""){
		$.messager.alert("提示","获取申请单信息错误", 'error')
		return false
	}
	var MyList="";
	var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",ID,IDStr)
	if(AppointRtnStr==""){
		$.messager.alert("提示","未有正常预约的预约纪录,请确认.", 'error')
		return false
	}
	var AppointRtnArr=AppointRtnStr.split("^");
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
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
	var LimitRow=6;
	var PrintPage=0;
	var PageTotal=Math.ceil(AppointRtnArr.length/LimitRow);
	var AppointRtnLen=AppointRtnArr.length;
	for(var i=1;i<=AppointRtnLen;i++){
		if(MyList==""){MyList=AppointRtnArr[i-1];}
		else{MyList=MyList+String.fromCharCode(2)+AppointRtnArr[i-1];}
		if ((i>1)&&(i%LimitRow==0)) {
			var PrintPage=PrintPage+1;
			var PrintPageText="第 "+PrintPage+" 页  共 "+PageTotal+" 页"
			//DHCP_PrintFunNew(myobj,MyPara,MyList);
			DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
			MyList="";
		}
	}
	if((AppointRtnLen%LimitRow)>0){
		var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
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
			$.messager.alert("提示","请选择需要打印的申请单据", 'error')
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
			$.messager.alert("提示","获取预约信息错误", 'error')
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