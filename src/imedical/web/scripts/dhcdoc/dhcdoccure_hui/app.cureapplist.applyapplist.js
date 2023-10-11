var appList_appListObj=(function(){
	var CureApplyAppDataGrid;
	function InitApplyAppListEvent(){
		$HUI.checkbox("#OnlyApp",{
			onCheckChange:function(e,value){
				setTimeout("appList_appListObj.CureApplyAppDataGridLoad();",10)
			}
		})	
	}

	function InitCureApplyAppDataGrid()
	{
		CureApplyAppDataGrid=$('#tabCureApplyApp').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			remoteSort:false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : true,
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize:10,
			pageList : [10,25,50],
			columns :[[     
				{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
				{field:'RowCheck',checkbox:true},
				//{field:'PatientNo',title:'登记号',width:100,align:'left'},   
				//{field:'PatientName',title:'姓名',width:80,align:'left'},  
				//{field:'ArcimDesc',title:'治疗项目',width:150,align:'left'},
				{field: 'DDCRSDate', title:'日期', width: 90, align: 'left', sortable: true, resizable: true},
				{field: 'LocDesc', title:'科室', width: 130, align: 'left', resizable: true},
				{field: 'ResourceDesc', title: '资源', width: 80, align: 'left', resizable: true},
				{field: 'DCAAStatus', title: '预约状态', width: 100, align: 'left',resizable: true
					,formatter:function(value,row,index){
						if (value==$g("已预约")){
							return "<span class='fillspan-fullnum'>"+value+"</span>";
						}else if(value==$g("取消预约")){
							return "<span class='fillspan-xapp'>"+value+"</span>";
						}else{
							return "<span class='fillspan-nonenum'>"+value+"</span>";
						}
					}
				},
				{field: 'TimeDesc', title: '时段', width: 80, align: 'left', resizable: true},
				{field: 'StartTime', title: '开始时间', width: 80, align: 'left',resizable: true},
				{field: 'EndTime', title: '结束时间', width: 80, align: 'left',resizable: true},
				{field: 'DCASeqNo',title:'排队序号',width:80,align:'left'},
				{field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'left',resizable: true},
				{field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true},
				{field: 'ReqUser', title: '预约操作人', width: 80, align: 'left',resizable: true},
				{field: 'ReqDate', title: '预约操作时间', width: 150, align: 'left',resizable: true},
				{field: 'LastUpdateUser', title: '更新人', width: 80, align: 'left',resizable: true},
				{field: 'LastUpdateDate', title: '更新时间', width: 150, align: 'left',resizable: true}   
			 ]]
		});
	}
	function CureApplyAppDataGridLoad()
	{
		var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
		var DCARowId=PageAppListAllObj._SELECT_DCAROWID;
			
		var QueryState="";
		var OperateType=$('#OperateType').val();
		var CheckOnlyApp="";
		var OnlyApp=$("#OnlyApp").prop("checked");
		if (OnlyApp){QueryState="^I^"};
		if(DCARowIdStr!="")DCARowId=DCARowIdStr;
		var ExpStr=session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + "doccure.cureapplist.hui.csp";
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Appointment",
			QueryName:"FindAppointmentListHUI",
			'DCARowId':DCARowId,
			'QueryState':QueryState,
			'Type':"",
			ExpStr:ExpStr,
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
	        $.messager.alert("提示", "取消预约请到治疗预约平台", 'info')
	        return false;
	    }  
	    var rows = CureApplyAppDataGrid.datagrid("getSelections");
		var length=rows.length;
		if(length>1){
			$.messager.alert("提示","只能取消预约一条预约记录,如需多条取消，请选择批量取消预约功能.","info");	
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
						AfterCancelAppoint();
						$.messager.popover({msg: '取消预约成功！',type:'success',timeout: 3000})
					}else{
						if(value=="100")value="入参为空"
						else if(value=="101")value="预约状态不是已预约的记录不能取消"
						else if(value=="-1001")value="释放预约号源失败"
						$.messager.alert('提示',"取消失败:"+value,"warning");
					}
				});
			}
		}else{
			$.messager.alert("提示","请选择一条预约记录","info");	
		}	
	}

	function GenCancelCureAppoint(){
		var OperateType=$('#OperateType').val();
		if (OperateType!="ZLYY")
	    {
	        $.messager.alert("提示", "取消预约请到治疗预约平台", 'info')
	        return false;
	    }  
		var rows = CureApplyAppDataGrid.datagrid("getSelections");
		var length=rows.length;
		var finflag=0;
		var selRowid="";
		for(var i=0;i<length;i++){
			var Rowid=rows[i].Rowid;
			if(selRowid==""){
				selRowid=Rowid;
			}else{
				selRowid=selRowid+"^"+Rowid;	
			}
		}
		if(selRowid!=""){
			$.messager.confirm('确认','是否确认取消预约所选预约记录?',function(r){    
			    if (r){ 
			    	var ExpStr=session['LOGON.HOSPID']+"^"+session['LOGON.LANGID'];
					$.m({
						ClassName:"DHCDoc.DHCDocCure.Appointment",
						MethodName:"AppCancelBatch",
						"DCAARowIdStr":selRowid,
						"UserDR":session['LOGON.USERID'],
						ExpStr:ExpStr
					},function testget(value){
						if(value==""){
							AfterCancelAppoint();
							$.messager.popover({msg: '取消预约成功！',type:'success',timeout: 3000})
						}else{
							var msgwid=580;
							var msgleft=(document.body.clientWidth-msgwid)/2+document.body.scrollLeft;   
							$.messager.alert('提示',value,"warning")
							.window({
								width:msgwid,
								left:msgleft
							}).css("overflow","auto");;
						}
					})
			    }
			})
		}else{
			$.messager.alert("提示","请选择一条预约记录","info");		
		}	
	}
	
	function AfterCancelAppoint(){
		CureApplyAppDataGridLoad();
		if(ServerObj.LayoutConfig=="1"){
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}	
		}else if(ServerObj.LayoutConfig=="2"){
			appList_appResListObj.CureRBCResSchduleDataGridLoad();
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
		        if(keyVal=="")continue;
				PrintCureAppXML(keyVal,DCAARowIdStr);
	        }
		}else{
			$.messager.alert("提示","请选择需要打印的患者预约记录","info");	
		}	
	}

	function PrintCureAppXML(ID,IDStr)
	{
		var JsonObj=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Appointment",
			MethodName:"GetCureAppPrtInfo",
			DCARowId:ID,
			DCAARowIdStr:IDStr
		},false)
		debugger 
		var DCAInfo=JsonObj.DCAInfo;
		var DCAAppInfo=JsonObj.DCAAppInfo;
		if(DCAInfo=="" || typeof(DCAInfo) == "undefined"){
			$.messager.alert("提示","获取申请单信息错误","warning")
			return false
		}
		if(DCAAppInfo=="" || typeof(DCAAppInfo) == "undefined"){
			$.messager.alert("提示","未有正常预约的预约纪录,请确认.","warning")
			return false
		}
		var RtnStrArry=DCAInfo.split(String.fromCharCode(1));
		var AppointRtnArr=DCAAppInfo.split("^");
		
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
		
		var MyList="",MyPara="";
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
	
	return {
		"InitApplyAppListEvent":InitApplyAppListEvent,
		"InitCureApplyAppDataGrid":InitCureApplyAppDataGrid,
		"CureApplyAppDataGridLoad":CureApplyAppDataGridLoad,
		"CancelCureAppoint":CancelCureAppoint,
		"BtnPrintApplyClick":BtnPrintApplyClick,
		"GenCancelCureAppoint":GenCancelCureAppoint
	}
})()