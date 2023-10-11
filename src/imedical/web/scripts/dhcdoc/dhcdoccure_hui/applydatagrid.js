var CureReportObj=(function(){
	var PageLogic={ 
		m_PatientCureTabDataGrid:"", 
		m_CureDetailDataGrid:""
	};
	var ServerObj={
		DocCureUseBase:tkMakeServerCall("DHCDoc.DHCDocCure.VersionControl","UseBaseControl",session['LOGON.HOSPID']),
		DHCDocCureLinkPage:tkMakeServerCall("web.DHCDocConfig","GetConfigNode","DHCDocCureLinkPage"),
		myTriage:""
	}
	
	function InitPatientCureTabDataGrid(){
		var PatientCureToolBar = [{
			id:'BtnDetailView',
				text:'���뵥���', 
				iconCls:'icon-funnel-eye',  
				handler:function(){
					CureReportObj.OpenApplyDetailDiag();
				}
			},"-",{
				id:'BtnAssessment',
				text:'��������', 
				iconCls:'icon-paper-table',  
				handler:function(){
					CureReportObj.UpdateAssessment();
				}
			}
		];
		var PatientCureColumn=[[ 
			{field:'ApplyNo',title:'���뵥��',width:120,align:'left', resizable: true},  
			{field:'PatNo',title:'�ǼǺ�',width:100,align:'left', resizable: true},   
			{field:'PatName',title:'����',width:60,align:'left', resizable: true},   
			{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true},
			{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true},
			{field:'OrdOtherInfo',title:'ҽ��������Ϣ',width:150,align:'left', resizable: true}, 
			{field:'OrdAddLoc',title:'��������',width:100,align:'left', resizable: true},  
			{field:'OrdUnitPrice',title:'����',width:50,align:'left', resizable: true}, 
			{field:'OrdQty',title:'����',width:50,align:'left', resizable: true}, 
			{field:'OrdBillUOM',title:'��λ',width:50,align:'left', resizable: true}, 
			{field:'OrdPrice',title:'�ܽ��',width:60,align:'left', resizable: true}, 
			{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
			{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
			{field:'ApplyFinishTimes',title:'����������',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false,
				formatter:function(value,row,index){
						//return '<a href="###" id= "'+row["TIndex"]+'"'+' onmouseover=CureReportObj.ShowCureEexcDetail(this);'+' ondblclick=CureReportObj.ShowCureDetail('+row.TIndex+','+row.DCARowId+');>'+row.ApplyFinishTimes+"</a>"
						return '<a href="###" id= "'+row["DCARowId"]+'"'+' onmouseover=CureReportObj.ShowCureEexcDetail(this);'+' ondblclick=CureReportObj.ShowCureDetail('+row.DCARowId+');>'+row.ApplyFinishTimes+"</a>"
					},
					styler:function(value,row){
						return "color:blue;text-decoration: underline;"
					}
			},
			{field:'ApplyNoFinishTimes',title:'δ��������',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
			{field:'OrdBilled',title:'�Ƿ�ɷ�',width:70,align:'left', resizable: true,
				formatter:function(value,row,index){
					if (value == "��"){
						return "<span class='fillspan-nobilled'>"+value+"</span>";
					}else{
						return "<span class='fillspan'>"+value+"</span>";
					}
				}
			},
			{field:'OrdReLoc',title:'���տ���',width:100,align:'left', resizable: true},   
			{field:'ServiceGroup',title:'������',width:80,align:'left', resizable: true}, 
			{ field: 'ApplyExec', title: '�Ƿ��ԤԼ', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
				,styler: function(value,row,index){
					if (value.indexOf("ֱ��ִ��")>=0){
						return 'color:#FF6347;';
					}
				}
			},
			{field:'ApplyStatus',title:'����״̬',width:80,align:'left', resizable: true},
			{field:'ApplyUser',title:'����ҽ��',width:80,align:'left', resizable: true},
			{field:'ApplyDateTime',title:'����ʱ��',width:80,align:'left', resizable: true},
			{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
			{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
				   
		 ]]
		var fitColumnVal=false;
		if(ServerObj.DocCureUseBase==1){
			fitColumnVal=true;
		}
		var PatientCureTabDataGrid=$('#PatientCureTab').datagrid({  
			fit : true,
			width : 'auto',
			//height: 700,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : fitColumnVal,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : '',
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"DCARowId",
			pageSize : 20,
			pageList : [20,50,100],
			columns : PatientCureColumn,
			toolbar : PatientCureToolBar,
			onSelect:function(index, row){
				var frm=dhcsys_getmenuform();
				if (frm){
					var DCARowId=row["DCARowId"];
					var Info=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Common",
						MethodName:"GetPatAdmIDByDCA",
						DCARowId:DCARowId,
						dataType:"text"
					},false); 
					if(Info!=""){
						var PatientID=Info.split("^")[1];
						var EpisodeID=Info.split("^")[0]
						frm.PatientID.value=PatientID;
						frm.EpisodeID.value=EpisodeID;
					}
				}
			},
			onBeforeSelect:function(index, row){
				var oldSelRow=$(this).datagrid('getSelected');
				var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
				if (oldSelIndex==index){
					$(this).datagrid('unselectRow',index);
					var frm=dhcsys_getmenuform();
					if (frm){
						frm.PPRowId.value="";
						frm.EpisodeID.value="";
					}
					return false;
				}
			}
		});
		PageLogic.m_PatientCureTabDataGrid=PatientCureTabDataGrid;
		return PatientCureTabDataGrid
	}
	function OpenApplyDetailDiag(){
		var rows = PageLogic.m_PatientCureTabDataGrid.datagrid("getSelections");
		if (rows.length==0) {
			$.messager.alert("��ʾ","��ѡ��һ�����뵥!","warning");
			return;
		}else if (rows.length>1){
			$.messager.alert("��ʾ","��ѡ���˶�����뵥!","warning")
			return;
	    }
		var DCARowId="";
		for(var i=0;i<rows.length;i++){
			var DCARowId=rows[i].DCARowId;
			if(DCARowId!=""){
				break;	
			}
		}
		if(DCARowId==""){
			$.messager.alert('��ʾ','��ѡ��һ�����뵥!',"warning");
			return false;
		}
		com_openwin.ShowApplyDetail(DCARowId+"&PageShowFromWay=ShowFromEmrList",ServerObj.DHCDocCureLinkPage,PatientCureTabDataGridLoad);
	}
	function UpdateAssessment(){
		var rows = PageLogic.m_PatientCureTabDataGrid.datagrid("getSelections");
		if (rows.length==0) 
		{
			$.messager.alert("��ʾ","��ѡ��һ�����뵥!","warning");
			return false;
		}
		var DCARowIdStr=""
		for(var i=0;i<rows.length;i++){
			var DCARowIds=rows[i].DCARowId;
			var OrdBilled=rows[i].OrdBilled;
			var ApplyExec=rows[i].ApplyExec;
			var ApplyStatusCode=rows[i].ApplyStatusCode;
			var rowIndex = PageLogic.m_PatientCureTabDataGrid.datagrid("getRowIndex", rows[i]);
			if((OrdBilled!="��")&&(ApplyStatusCode!="C")){
				if(DCARowIdStr==""){
					DCARowIdStr=DCARowIds;
				}else{
					DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
				}
			}
		}	
		if(DCARowIdStr==""){
			$.messager.alert('��ʾ','δ�пɽ�����������������,��ȷ�������Ƿ��ѽɷѻ��Ƿ��ѳ���!',"warning");
			return false;	
		}
		var OperateType="";
		var href="doccure.cureassessmentlist.csp?OperateType="+OperateType+"&DCARowIdStr="+DCARowIdStr+"&PageShowFromWay=ShowFromEmrList";
	    websys_showModal({
			url:href,
			title:'��������',
			//width:screen.availWidth-200,height:screen.availHeight-200
			width:"95%",height:screen.availHeight-200
		});
	}
	function ShowCureEexcDetail(that){
		var title=""
		var content="˫�������ϸ��Ϣ"
		$(that).webuiPopover({
			title:title,
			content:content,
			trigger:'hover',
			placement:'top',
			style:'inverse'
		});
		$(that).webuiPopover('show');
	}
	function ShowCureDetail(id){
		var dhwid=window.screen.availWidth-100;
		var dhhei=window.screen.availHeight-200;
		$('#add-dialog').window('open') //.window("closable",true)
		.window('resize',{
			width:dhwid,
			height:dhhei,
			top: ($(window).height() - dhhei) * 0.5,
			left:($(window).width() - dhwid) * 0.5
		});
		var CureDetailDataGrid=$('#tabCureDetail').datagrid({  
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
			singleSelect:false,    
			url : '',
			loadMsg : '������..',  
			pagination : true,  
			rownumbers : true,  
			idField:"OEORERowID",
			//pageNumber:0,
			pageSize : 20,
			pageList : [20,50,100],
			columns :[[ 
    			{field:'DCARowId',title:'',width:1,hidden:true}, 
    			{field:'PapmiNo',title:'�ǼǺ�',width:100},   
    			{field:'PatientName',title:'����',width:100},
    			{field:'ArcimDesc',title:'������Ŀ',width:220,align:'left'},  
    			//{field:'OEOREExStDate',title:'Ҫ��ִ��ʱ��',width:130,align:'left'},
    			{field:'DCRContent',title:'���Ƽ�¼',width:220,align:'left'} ,
    			{field:'OEOREQty',title:'ִ������',width:80,align:'left'} ,
    			{field:'OEOREStatus',title:'ִ��״̬',width:80,align:'left'},
    			{field:'OEOREUpUser',title:'ִ����',width:60,align:'left'},
    			{field:'DCRIsPicture',title:'�Ƿ���ͼƬ',width:80,
        			formatter:function(value,row,index){
						return '<a href="###" id= "'+row["OEORERowID"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=workList_RecordListObj.ShowCureRecordPic(\''+row.DCRRowId+'\');>'+row.DCRIsPicture+"</a>"
					},
					styler:function(value,row){
						return "color:blue;text-decoration: underline;"
				}},
    			{field:'DCRCureDate',title:'����ʱ��',width:160,align:'left'} ,
    			{field:'DCRResponse',title:'���Ʒ�Ӧ',width:220,align:'left'} ,
    			{field:'DCREffect',title:'����Ч��',width:220,align:'left'} ,
    			{field:'OEOREExDate',title:'����ʱ��',width:160,align:'left'} ,
    			{field:'OEOREType',title:'ҽ������',width:100,align:'left'} ,
    			{field:'DCRRowId',title:'DCRRowId',width:100,align:'left',hidden:true} ,
    			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}  
		 	]]
		});
		PageLogic.m_CureDetailDataGrid=CureDetailDataGrid;
		CureReportObj.CureDetailDataGridLoad(id);
		return CureDetailDataGrid	
	}

	function CureDetailDataGridLoad(id){
		var CheckOnlyNoExcute="";
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.ExecApply",
			QueryName:"FindCureExecList",
			'DCARowId':id,
			'OnlyNoExcute':CheckOnlyNoExcute,
			'OnlyExcute':"Y",
			Pagerows:PageLogic.m_CureDetailDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			PageLogic.m_CureDetailDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		})
		PageLogic.m_CureDetailDataGrid.datagrid("clearChecked");
		PageLogic.m_CureDetailDataGrid.datagrid("clearSelections");
	}
	function PatientCureTabDataGridLoad(Obj){
		$.cm({
            ClassName: "DHCDoc.DHCDocCure.Apply",
            QueryName: "FindAllCureApplyListHUI",
            'PatientID': (Obj.PatientID==undefined)?"":Obj.PatientID,
            'StartDate': (Obj.StartDate==undefined)?"":Obj.StartDate,
            'EndDate': (Obj.EndDate==undefined)?"":Obj.EndDate,
            'outCancel': (Obj.outCancel==undefined)?"":Obj.outCancel,
            'FinishDis': (Obj.FinishDis==undefined)?"":Obj.FinishDis,
            'PatName': (Obj.PatName==undefined)?"":Obj.PatName,
            'TriageFlag': (Obj.TriageFlag==undefined)?"":Obj.TriageFlag,
            'LogLocID': (Obj.LocID==undefined)?"":Obj.LocID,
            'LogUserID': (Obj.UserID==undefined)?"":Obj.UserID,
            'ApplyNo': (Obj.ApplyNo==undefined)?"":Obj.ApplyNo,
            'queryOrderLoc':(Obj.queryOrderLoc==undefined)?"": Obj.queryOrderLoc,
            'LongOrdPriority': (Obj.LongOrdPriority==undefined)?"":Obj.LongOrdPriority,
            'CheckAdmType': (Obj.CheckAdmType==undefined)?"":Obj.CheckAdmType,
            'queryArcim': (Obj.queryArcim==undefined)?"":Obj.queryArcim,
            'queryOrderLoc': (Obj.queryOrderLoc==undefined)?"":Obj.queryOrderLoc,
            'ExecFlag': (Obj.ExecFlag==undefined)?"": Obj.ExecFlag,
            'queryExpStr': (Obj.queryExpStr==undefined)?"": Obj.queryExpStr,
            Pagerows: PageLogic.m_PatientCureTabDataGrid.datagrid("options").pageSize,
            rows: 99999
        },function(GridData){
			PageLogic.m_PatientCureTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			PageLogic.m_PatientCureTabDataGrid.datagrid("clearSelections");
			PageLogic.m_PatientCureTabDataGrid.datagrid("clearChecked");	
		})
	}
	return {
		"InitPatientCureTabDataGrid":InitPatientCureTabDataGrid,
		"OpenApplyDetailDiag":OpenApplyDetailDiag,
		"UpdateAssessment":UpdateAssessment,
		"ShowCureEexcDetail":ShowCureEexcDetail,
		"ShowCureDetail":ShowCureDetail,
		"CureDetailDataGridLoad":CureDetailDataGridLoad,
		"PatientCureTabDataGridLoad":PatientCureTabDataGridLoad,
		"PageLogic":PageLogic,
		"ServerObj":ServerObj
	}
})()