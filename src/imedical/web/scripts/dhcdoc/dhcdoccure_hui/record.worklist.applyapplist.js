var workList_AppListObj=(function(){
	var CureWorkApplyAppDataGrid;
	var TransExpStr=session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + PageWorkListAllObj.cspName;
	function InitCureApplyAppDataGrid(){
		var cureApplyAppToolBar = [
		/*{
			id:'BtnDetailAdd',
			text:'������Ƽ�¼', 
			iconCls:'icon-add',  
			handler:function(){
				AddCureRecord();
			}
		},*/{
			id:'BtnDetailAdds',
			text:'������Ƽ�¼',
			iconCls:'icon-add',
			handler:function(){
				GenAddCureRecord();
			}
		},{
			id:'BtnDetailView',
			text:'������Ƽ�¼', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				DetailView();
			}
		},{
			id:'BtnCancelRecord',
			text:'�������Ƽ�¼', 
			iconCls:'icon-cancel',  
			handler:function(){
				CancelRecord();
			}
		},"-",
		{
			id:'BtnPrint',
			text:'��ӡԤԼ����ƾ֤',
			iconCls:'icon-print',
			handler:function(){
				BtnPrintApplyClick()
			}
		},{
			id:'BtnUploadPic',
			text:'�ϴ�ͼƬ', 
			iconCls:'icon-upload-cloud',  
			handler:function(){
				UploadPic();
			}
		}];
		CureWorkApplyAppDataGrid=$('#tabCureWorkApplyApp').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize:10,
			pageList : [10,25,50],
			columns :[[     
				{field:'Rowid', title: '����ԤԼ��¼ID', width: 1, align: 'left',hidden:true}, 
				{field:'RowCheck',checkbox:true},
				{field:'PatientNo',title:'�ǼǺ�',width:100,align:'left'},   
				{field:'PatientName',title:'����',width:80,align:'left'},  
				{field:'ArcimDesc',title:'������Ŀ',width:150,align:'left'},
				{field:'DDCRSDate', title:'����', width: 100, align: 'left', resizable: true},
				{field:'DCASeqNo',title:'�Ŷ����',width:70,align:'left'},
				{field:'LocDesc', title:'����', width: 150, align: 'left', resizable: true},
				{field:'ResourceDesc', title: '��Դ', width: 100, align: 'left', resizable: true},
				{field:'TimeDesc', title: 'ʱ��', width: 60, align: 'left', resizable: true},
				{field:'DCAAStatus', title: '����״̬', width: 80, align: 'left',resizable: true},
				{field:'DCRIsAssess',title:'�Ƿ���������',width:100, hidden: true} ,
				{field:'DCRTitle',title:'���Ƽ�¼����',width:200},  
				{field:'DCRCreateUser',title:'���Ƽ�¼������',width:120},
				{field:'DCRCreateDate',title:'���Ƽ�¼����ʱ��',width:150},
				{field:'DCRIsPicture',title:'�Ƿ���ͼƬ',width:80,
					formatter:function(value,row,index){
						if(value!=""){
							return '<a href="###" id= "'+row["DCRRowId"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=workList_AppListObj.ShowCureRecordPic(\''+row.DCRRowId+'\');>'+$g("�鿴ͼƬ")+"</a>"
						}else{
		        			return "";	
		        		}
					},
					styler:function(value,row){
						return "color:blue;text-decoration: underline;"
					}
				},
				{field: 'DCRTrance', title: '���ƹ���׷��', width:100, align: 'center', 
					formatter: function (value, rowData, rowIndex) {
						retStr = "<a href='#' title='���ƹ���׷��'  onclick='workList_RecordListObj.ShowReportTrace(\""+rowData.DCRRowId+"\","+"\""+rowData.Rowid+"\")'><span class='icon-track' title='���ƹ���׷��')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
						return retStr;
					}
				},
				{field:'DCRUpdateUser',title:'������������',width:110},
				{field:'DCRUpdateDate',title:'����������ʱ��',width:150},
				{field:'DCRRowId',title:'���Ƽ�¼ID',width:50,hidden: true},
				{field:'DCAssRowId',title:'��������ID',width:50,hidden: true},
				{field:'OEOREDR',title:'ִ�м�¼ID',width:50,hidden: true},
				{field: 'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',hidden: true},
				{field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'left',hidden: true
				},
				{field: 'EndTime', title: '����ʱ��', width: 80, align: 'left',hidden: true
				},
				{field: 'ServiceGroupDesc', title: '������', width: 80, align: 'left',hidden: true
				},
				{field: 'ReqUser', title: 'ԤԼ������', width: 80, align: 'left',hidden: true
				},
				{field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 80, align: 'left',hidden: true
				},
				{field: 'LastUpdateUser', title: '������', width: 80, align: 'left',hidden: true
				},
				{field: 'LastUpdateDate', title: '����ʱ��', width: 80, align: 'left',hidden: true
				} 
			 ]] ,
	    	toolbar : cureApplyAppToolBar,
	    	onDblClickRow: function(index,row) {
				var DCRRowId=GetSelectDCRRowId();
				if (DCRRowId=="") return;
		        if (websys_emit){
			        var OperateType=$('#OperateType').val();
				    var Obj={OperateType:"",DCAARowId:"",DCRRowId:DCRRowId};
					websys_emit("onOpenCureRecordInfo",Obj);
				}
	        }
            
		});
		CureWorkApplyAppDataGridLoad();
	}
	/**
	*���Ƽ�¼�б����ݼ���
	**/
	function CureWorkApplyAppDataGridLoad(){
		var DCARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID; 
		var DCARowId=PageWorkListAllObj._WORK_SELECT_DCAROWID;
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
			ExpStr:TransExpStr,
			Pagerows:CureWorkApplyAppDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			CureWorkApplyAppDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			CureWorkApplyAppDataGrid.datagrid("clearSelections");
			CureWorkApplyAppDataGrid.datagrid("clearChecked");	
		})
	}
	/**
	*���Ƽ�¼���
	**/
	function GenAddCureRecord(){ 
		var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
		if(rows.length==0){
			$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼.","warning");
			return false;
		}
		var selIDAry=new Array();
		for(var i=0;i<rows.length;i++){
			var Rowid=rows[i].Rowid;
			if(Rowid!=""){
				selIDAry.push(Rowid)
			}
		}
		if(selIDAry.length>0){
			var selRowid=selIDAry.join("^");
			if(CheckBeforeSelect(selRowid)){
				OpenCureRecordDiag(selRowid);
			}	
		}
	}
	/**
	*���Ƽ�¼���֮ǰ���в�����֤
	**/
	function CheckBeforeSelect(selRowid){
		var ChkMsg=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"CheckBeforeUpdateBatch",
			DCAARowIdStr:selRowid,
			UserID:session['LOGON.USERID'],
			TransExpStr:TransExpStr,
			dataType:"text"
		},false)
		if(ChkMsg!=""){
			$.messager.alert("��ʾ",ChkMsg, 'warning');
			return false;	
		}
		return true;
	}
	function AddCureRecord(){
		
	}
	/**
	*���Ƽ�¼��д���ڵ���
	**/
	function OpenCureRecordDiag(DCAARowId)
	{
		var argObj={
			DHCDocCureRecordLinkPage:ServerObj.DHCDocCureRecordLinkPage,
			DCAARowId:DCAARowId,
			Source:"",
			callback:AfterSaveCureRecord
		}
		com_openwin.ShowCureRecordDiag(argObj);
	}
	function AfterSaveCureRecord(){
		CureWorkApplyAppDataGridLoad();	
		if(ServerObj.LayoutConfig=="1"){
			if(window.frames.parent.CureWorkListDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}	
		}
	}
	/**
	*ԤԼƾ֤��ӡ
	**/
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
		        if(keyVal=="")continue;
				PrintCureAppXML(keyVal,DCAARowIdStr);
	        }
		}else{
			$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�Ļ���ԤԼ��¼", 'error');	
		}	
	}
	/**
	*ԤԼƾ֤��ӡ
	**/
	function PrintCureAppXML(ID,IDStr)
	{
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",ID)
		if(RtnStr==""){
			$.messager.alert("��ʾ","��ȡ���뵥��Ϣ����", 'error')
			return false
		}
		var MyList="";
		var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",ID,IDStr)
		if(AppointRtnStr==""){
			$.messager.alert("��ʾ","δ������ԤԼ��ԤԼ��¼,��ȷ��.", 'error')
			return false
		}
		var AppointRtnArr=AppointRtnStr.split("^");
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
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
		var LimitRow=6;
		var PrintPage=0;
		var PageTotal=Math.ceil(AppointRtnArr.length/LimitRow);
		var AppointRtnLen=AppointRtnArr.length;
		for(var i=1;i<=AppointRtnLen;i++){
			if(MyList==""){MyList=AppointRtnArr[i-1];}
			else{MyList=MyList+String.fromCharCode(2)+AppointRtnArr[i-1];}
			if ((i>1)&&(i%LimitRow==0)) {
				var PrintPage=PrintPage+1;
				var PrintPageText="�� "+PrintPage+" ҳ  �� "+PageTotal+" ҳ"
				//DHCP_PrintFunNew(myobj,MyPara,MyList);
				DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
				MyList="";
			}
		}
		if((AppointRtnLen%LimitRow)>0){
			var PrintPageText="�� "+PageTotal+" ҳ  �� "+PageTotal+" ҳ"
			//DHCP_PrintFunNew(myobj,MyPara,MyList);
			DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
		}
		
		//��ӡ�ɹ�������߷��Ͷ���
		//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","SendMessage",DCARowId,session['LOGON.USERCODE'])
		//if(ret!="0"){
		//	$.messager.alert("��ʾ","���ż�¼����ʧ��,��ȷ��.")
		//	return false
		//}
	}
	
	function GetSelectDCRRowId(MultiFlag){
		var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
		if (rows.length==0){
			$.messager.alert("��ʾ","��ѡ��һ�����Ƽ�¼",'warning');
			return "";
		}else if (rows.length>1 && MultiFlag!="Y"){
	 		$.messager.alert("��ʾ","��ѡ���˶�����Ƽ�¼��",'warning')
	 		return "";
		}
		var DCRRowId="";
		var selIDAry=new Array();
		for(var i=0;i<rows.length;i++){
			var Rowid=rows[i].DCRRowId;
			if(Rowid!=""){
				selIDAry.push(Rowid)
			}
		}
		if(selIDAry.length>0){
			DCRRowId=selIDAry.join("^");
		}
		if(DCRRowId==""){
			$.messager.alert("��ʾ","��������������Ƶļ�¼,��ȷ��.",'warning')
	 		return "";
		}
		return DCRRowId;
	}
	/**
	*���Ƽ�¼���������record.worklist.curerecordlist.js����
	**/
	function DetailView(){
		var DCRRowId=GetSelectDCRRowId()
		if(DCRRowId==""){
			return false;
		}
		workList_RecordListObj.ShowCureRecordDiag(DCRRowId,CureWorkApplyAppDataGridLoad);	
	}
	/**
	*���Ƽ�¼����������record.worklist.curerecordlist.js����
	**/
	function CancelRecord(){
		var DCRRowIdStr=GetSelectDCRRowId("Y");
		if(DCRRowIdStr==""){
			return false;
		}
		workList_RecordListObj.CancelRecordBatch(DCRRowIdStr,AfterSaveCureRecord)
	}
	/**
	*���Ƽ�¼ͼƬ�ϴ�������record.worklist.curerecordlist.js����
	**/
	function UploadPic(){
		var DCRRowId=GetSelectDCRRowId()
		if(DCRRowId==""){
			return false;
		}
		workList_RecordListObj.UploadPic(DCRRowId,CureWorkApplyAppDataGridLoad);
	}
	/**
	*���Ƽ�¼ͼƬ���������record.worklist.curerecordlist.js����
	**/
	function ShowCureRecordPic(DCRRowId){
		if(DCRRowId=="" || typeof DCRRowId=="undefined"){
			var DCRRowId=GetSelectDCRRowId()
			if(DCRRowId==""){
				return false;
			}
		}
		workList_RecordListObj.ShowCureRecordPic(DCRRowId,CureWorkApplyAppDataGridLoad);
	}
	
	return {
		"InitCureApplyAppDataGrid":InitCureApplyAppDataGrid,
		"ShowCureRecordPic":ShowCureRecordPic,
		"CureWorkApplyAppDataGridLoad":CureWorkApplyAppDataGridLoad
	}
})()
