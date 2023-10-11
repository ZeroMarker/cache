/**
	����ԤԼ Version 2.0
	appoint.applyreslist.js
	2022-06-02
*/
var appoint_ResListObj=(function(){
	var PageAppResListObj={
		m_CureAppointListDataGrid:"",
		m_SelectRBASId:"",
		m_InputTimeRange:"",
		cspName:"doccure.applyapplist.hui.csp"
	}
	function Appoint(ASRowID,Title,TRTimeRange){ 
	    var SelRow=PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected");
		if (!SelRow) {
			$.messager.alert("��ʾ", "��ѡ��һ�����߼�¼!");
			return false;
		}
		var PatientID=SelRow.PatientId;
		var PatName=SelRow.PatientName;
		var HasLong=SelRow.HasLong;
		var DCARowIdStr=SelRow.DCARowIdStr;
	    var mASRowID="",mTitle="";
	    if(ServerObj.ScheuleGridListOrTab==0){
		    var GridId=appList_appResListObj.GetCurrentGrid();
		    var rows = $("#"+GridId).datagrid("getSelections");
		    if (rows.length > 0) {
				var ids = [];
				for (var i = 0; i < rows.length; i++) {
					ids.push(rows[i].Rowid);
					mTitle=rows[i].LocDesc+" "+rows[i].ResourceDesc+" "+rows[i].TimeDesc+" "+rows[i].ServiceGroupDesc;
				}
				mASRowID=ids.join(',');
		    }
	    }
	    if(mASRowID == "" && typeof ASRowID!='undefined'){
		    mASRowID=ASRowID;
		    mTitle=Title;
		}
		var mTRTimeRange = "";
		if ((typeof TRTimeRange != "undefined")&&(TRTimeRange != "")) {
			mTRTimeRange = TRTimeRange;
		}
	    if(mASRowID!=""){
			var ExpStr=_PageCureObj.LogUserID+"^"+_PageCureObj.LogGroupID+"^"+_PageCureObj.LogHospID;
			var InsObj={
				PatientID:PatientID, 
				RBASId:mASRowID, 
				RegType:"0",  //����ԤԼ
				LongFlag:HasLong, 
				TimeRange:mTRTimeRange, 
				DCARowID:DCARowIdStr,
				ExpStr:ExpStr
			};
			var InsJson=JSON.stringify(InsObj);
			var RetObj=$.cm({
				ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
				MethodName:"AppInsertBroker",
				'InsJson':InsJson
			},false);
			var value=RetObj.ret;
			var ErrMsg=RetObj.ErrMsg;
			if(value=="0"){
				$.messager.popover({msg: 'ԤԼ�ɹ���',type:'success',timeout: 3000});
			}else{
				if(("^-1002^-1003^-1004^").indexOf("^"+value+"^")>-1){
				}
				err="'"+PatName+" '"+$g("ԤԼʧ��,ʧ��ԭ��")+":"+$g(ErrMsg);
				$.messager.alert("��ʾ", err, "warning");
			}
			RefreshDataGrid();
	    }else{
		    $.messager.alert("��ʾ", "��ѡ��ҪԤԼ����Դ", "warning");
		    return;
		}
	}
	
	function ShowAppointList(id,timeRange){
		PageAppResListObj.m_SelectRBASId=id;
		if(typeof(timeRange) != "undefined"){
			PageAppResListObj.m_InputTimeRange=timeRange;
		}
		var dhwid=$(document.body).width()-50;
		var dhhei=$(document.body).height()-100;
		$("#QryAllFlag").checkbox('setValue',false);
		$('#appointlist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:45});
		var CureAppointListDataGrid=$('#tabCureAppointList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			checkOnSelect:false,
			fitColumns : false,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AppointmentV2&QueryName=FindAppointmentList&rows=9999",
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"QueId",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
			//QueId:%String,QueDept:%String,QueDate:%String,ResDesc:%String,ASDate:%String,TimeRange:%String,SchedStTime:%String,SchedEdTime:%String,DDCRSStatus:%String,QueOperUser:%String,QueStatusDate:%String,DCAAStatus:%String,PatNo:%String,PatName:%String,QueNo:%String
	    			{field:'QueId', title: 'QueId', width: 1, align: 'left',hidden:true}, 
					{field:'PatNo',title:'�ǼǺ�',width:100,align:'left',hidden:true},   
	    			{field:'PatName',title:'����',width:80,align:'left'},  
					{field:'ASDate', title:'ԤԼ��������', width: 100, align: 'left', resizable: true  },
					{field:'QueNo',title:'�Ŷ����',width:80,align:'left'},
					{field:'DCAAStatus', title: 'ԤԼ״̬', width: 115, align: 'left',resizable: true
						,formatter:function(value,row,index){
							if (value==$g("��ԤԼ")){
								return "<span class='fillspan-fullnum'>"+value+"</span>";
							}else if(value==$g("ȡ��ԤԼ")){
								return "<span class='fillspan-xapp'>"+value+"</span>";
							}else{
								return "<span class='fillspan-nonenum'>"+value+"</span>";
							}
						}
					},
					{field:'QueDept', title:'����', width: 150, align: 'left', resizable: true  
					},
	    			{ field: 'ResDesc', title: '��Դ', width: 100, align: 'left', resizable: true
					},
					{ field: 'TimeRange', title: 'ʱ��', width: 140, align: 'left', resizable: true
					},
					{ field: 'SchedStTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true
					},
					{ field: 'SchedEdTime', title: '����ʱ��', width: 80, align: 'left',resizable: true
					},
					{ field: 'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',resizable: true
					},
					{ field: 'QueOperUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true
					},
					{ field: 'QueStatusDate', title: '������ʱ��', width: 180, align: 'left',resizable: true
					},
					{field:'Job',title:'',width:1,hidden:true}
			 ]],
			 toolbar : [{
					id:'BtnCall',
					text:'ȡ��ԤԼ',
					iconCls:'icon-cancel',
					handler:function(){
						CancelCureAppoint();
					}
			}],
			onBeforeLoad:function(param){
				$(this).datagrid("unselectAll");
				var OnlyApp="Y";
				var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
				if (QryAllFlag){OnlyApp=""};
				var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
				var ExpStr=PageAppResListObj.m_InputTimeRange;
				$.extend(param,{OnlyApp:OnlyApp,ResSchduleId:PageAppResListObj.m_SelectRBASId,SessionStr:SessionStr,ExpStr:ExpStr});
			}
		});
		PageAppResListObj.m_CureAppointListDataGrid=CureAppointListDataGrid;
		return CureAppointListDataGrid;
	}
	
	function CancelCureAppoint(){
		var row = PageAppResListObj.m_CureAppointListDataGrid.datagrid("getSelected");
		if(row){
			var QueId=row.QueId;
			var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
			$.messager.confirm('ȷ��','�Ƿ�ȷ��ȡ��ԤԼ��ѡԤԼ��¼?',function(r){    
			    if (r){ 
					$.m({
						ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
						MethodName:"AppCancelBatch",
						RowIdStr:QueId,
						UserDR:session['LOGON.USERID'],
						SessionStr:SessionStr
					},function testget(value){
						if(value==""){
							PageAppResListObj.m_CureAppointListDataGrid.datagrid("reload")
							RefreshDataGrid();
							$.messager.popover({msg: 'ȡ��ԤԼ�ɹ���',type:'success',timeout: 3000})
						}else{
							var msgwid=580;
							var msgleft=(document.body.clientWidth-msgwid)/2+document.body.scrollLeft;   
							$.messager.alert('��ʾ',$g("ȡ��ʧ��")+":"+value,"warning")
							.window({
								width:msgwid,
								left:msgleft
							}).css("overflow","auto");;
						}
					})
			    }
			})
		}else{
			$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼","warning");		
		}	
	}
	function CureAppointListDataGridLoad(){
		PageAppResListObj.m_CureAppointListDataGrid.datagrid("reload");	
	}
	
	function ExportAppointListData(){
		try{
			var OnlyApp="Y";
			var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
			if (QryAllFlag){OnlyApp=""};
			var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
			
			var RBASInfo=$.cm({
		    	ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		    	MethodName:"GetResApptSchuldeInfo",
		    	ASRowID:PageAppResListObj.m_SelectRBASId,
		    	dataType:"text"
		    },false)
		    var RBASInfoArr=RBASInfo.split("^");
		    var myret=RBASInfoArr[4]+RBASInfoArr[1]+RBASInfoArr[3]+RBASInfoArr[6];
			var Title=myret+"����ԤԼ��";
			var ExpStr=PageAppResListObj.m_InputTimeRange;
			//����
			//ResultSetType:Excelʱ��Ҫlocation.href = rtn��仰������ʱ��ѡ·�������Ƕ��ڵǼǺ�����ǰ�ߵ�0�ᱻʡ��
			//ResultSetType:ExcelPluginʱ����ѡ����·����ֱ�ӵ����������棬�Ḳ���Ѵ��ڵ��ļ�
			var rtn=$.cm({
				dataType:'text',
				ResultSetType:'ExcelPlugin', //Excel
				ExcelName:Title,
				ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
				QueryName:"FindAppointmentListExport",
				PatientId:"",
				OnlyApp:OnlyApp,
				ResSchduleId:PageAppResListObj.m_SelectRBASId,
				SessionStr:SessionStr,
				ExpStr:ExpStr
			},false);
		}catch(e){
			$.messager.alert("��ʾ",e.message,"error");	
		}
	}
	
	return {
		"Appoint":Appoint,
		"ShowAppointList":ShowAppointList,
		"CureAppointListDataGridLoad":CureAppointListDataGridLoad,
		"ExportAppointListData":ExportAppointListData
	}
})()