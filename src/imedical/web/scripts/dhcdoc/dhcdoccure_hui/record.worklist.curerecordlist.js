var CureRecordDataGrid;

function InitCureRecordDataGrid()
{
	// Toolbar
	var cureRecordToolBar = [{
		id:'BtnDetailView',
		text:'���', 
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
	},{
		id:'BtnUploadPic',
		text:'�ϴ�ͼƬ', 
		iconCls:'icon-upload-cloud',  
		handler:function(){
			UploadPic();
		}
	}];
	// �������뵥ԤԼ��¼Grid
	CureRecordDataGrid=$('#tabCureRecordList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize : 5,
		pageList : [5,15,50,100],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'PatientNo',title:'�ǼǺ�',width:100,align:'left'},   
        			{field:'PatientName',title:'����',width:80,align:'left'},
        			{field:'DCRTitle',title:'����',width:300},  
        			{field:'CreateUser',title:'������',width:100},
        			{field:'CreateDate',title:'����ʱ��',width:100},
        			{field:'IsPicture',title:'�Ƿ���ͼƬ',width:70,
	        			formatter:function(value,row,index){
							return '<a href="###" id= "'+row["Rowid"]+'"'+' onmouseover=ShowCurePopover(this);'+' onclick=ShowCureRecordPic(\''+row.Rowid+'\');>'+row.IsPicture+"</a>"
						},
						styler:function(value,row){
							return "color:blue;text-decoration: underline;"
					}},
					{ field: 'Trance', title: '����׷��', width:60, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
					      retStr = "<a href='#' title='���ƹ���׷��'  onclick='ShowReportTrace(\""+rowData.Rowid+"\")'><span class='icon-track' title='���ƹ���׷��')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
						  return retStr;
					  }
					},
        			{field:'UpdateUser',title:'��������',width:100},
        			{field:'UpdateDate',title:'������ʱ��',width:100} ,
        			{field:'ID',title:'ID',width:50}    
    			 ]] ,
    	toolbar : cureRecordToolBar,
    	onDblClickRow:function(rowIndex, rowData){ 
			DetailView();
       }
	});
}
function CureRecordDataGridLoad()
{
	var DCARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID; //$('#DCARowIdStr').val();
	var DCARowId=""; //$('#DCARowId').val();
	if(DCARowIdStr!="")DCARowId=DCARowIdStr;
	//var DCAARowId=$('#DCAARowId').val();
	var DCAOEOREDR=""; //$('#DCAOEOREDR').val();
	if(CureRecordDataGrid){
		CureRecordDataGrid.datagrid({
			url:$URL,
			queryParams:{
				ClassName:"DHCDoc.DHCDocCure.Record",
				QueryName:"FindCureRecordList",
				'DCARowIdStr':DCARowId,
				'DCAOEOREDR':DCAOEOREDR,
				'Type':"APP",
			}	
		})
	}
	/*	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Record",
		QueryName:"FindCureRecordList",
		'DCARowIdStr':DCARowId,
		'DCAOEOREDR':DCAOEOREDR,
		Pagerows:CureRecordDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRecordDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})*/
}
function ShowCureRecordDiag(DCRRowId)
{
	var OperateType=$('#OperateType').val();
	var DCAARowId=""; //$('#DCAARowId').val();
	var href="doccure.curerecord.hui.csp?OperateType="+OperateType+"&DCAARowId="+DCAARowId+"&DCRRowId="+DCRRowId;
	/*var ReturnValue=window.showModalDialog(href,"","dialogwidth:50em;dialogheight:25em;status:no;center:1;resizable:yes");
	if (ReturnValue !== "" && ReturnValue !== undefined) 
    {
		if(ReturnValue){
			CureRecordDataGridLoad();	
		}
    }*/
    websys_showModal({
		url:href,
		title:'���Ƽ�¼���',
		width:"800px",height:"500px",
		onClose: function() {
			CureRecordDataGridLoad()
		}
	});
}

function DetailView(){
	var DCRRowId=GetSelectRow()
	if(DCRRowId==""){
		return false;
	}
	ShowCureRecordDiag(DCRRowId);	
}
function CancelRecord(){
	var DCRRowId=GetSelectRow()
	if(DCRRowId==""){
		return false;
	}
	$.messager.confirm('ȷ��','�Ƿ�ȷ�ϳ������Ƽ�¼?',function(r){    
		if (r){    
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"CancelRecord",
				'DCRRowId':DCRRowId,
				'UserID':session['LOGON.USERID'],
				dataType:"text"
			},function testget(value){	
				if(value=="0"){
					$.messager.show({title:"��ʾ",msg:"�����ɹ�"});	
					CureRecordDataGridLoad();
					if(window.frames.parent.CureApplyDataGrid){
						window.frames.parent.RefreshDataGrid();
					}else{
						RefreshDataGrid();	
					}
				}else{
					var msg=value.split("^")[1];
					$.messager.alert('��ʾ',msg);
					return false;	
				}
			})
		}
	})
}
function UploadPic(){
	var DCRRowId=GetSelectRow()
	if(DCRRowId==""){
		return false;
	}
	var posn="height="+500+",width="+400+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
	var href="doccure.curerecord.picupload.hui.csp?DCRRowId="+DCRRowId;
	//websys_createWindow(path,false,posn);
	websys_showModal({
		url:href,
		title:'���Ƽ�¼ͼƬ�ϴ�',
		width:"580px",height:"320px",
		CureRecordDataGridLoad:CureRecordDataGridLoad
	});
}
function GetSelectRow(){
	var rows = CureRecordDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ�����Ƽ�¼");
		return "";
	}else if (rows.length>1){
 		$.messager.alert("����","��ѡ���˶�����Ƽ�¼��",'err')
 		return "";
	}
	var DCRRowId=""
	var rowIndex = CureRecordDataGrid.datagrid("getRowIndex", rows[0]);
	if(rowIndex<0){
		$.messager.alert("��ʾ","��ѡ��һ�����Ƽ�¼");
		return "";
	}
	var selected=CureRecordDataGrid.datagrid('getRows'); 
	var DCRRowId=selected[rowIndex].Rowid;
	if(DCRRowId=="")
	{
		$.messager.alert('��ʾ','��ѡ��һ�����Ƽ�¼');
		return "";
	}
	return DCRRowId;
}
function ShowCurePopover(that){
	var title=""
	var content="�������ͼƬ"
	$(that).webuiPopover({
		title:title,
		content:content,
		trigger:'hover',
		placement:'top',
		style:'inverse'
	});
	$(that).webuiPopover('show');
}
function ShowCureRecordPic(DCRRowId){
	/*var DCRRowId=GetSelectRow()
	if(DCRRowId==""){
		return false;
	}*/
	var posn="height="+600+",width="+800+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
	var href="doccure.curerecord.picshow.hui.csp?DCRRowId="+DCRRowId+"&paramType=Original";
	//websys_createWindow(path,false,posn);
	websys_showModal({
		url:href,
		title:'���Ƽ�¼ͼƬ���',
		width:"1000px",height:"700px",
		CureRecordDataGridLoad:CureRecordDataGridLoad
	});	
}
function ShowReportTrace(DCARRowID) {
	var width = document.body.clientWidth - 200;
	var height = 380;
	$("#win_ReportTrace").window({
		modal:true,
		title:'���ƹ���׷��',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="doccure.curerecord.trace.hui.csp?DCARRowID='+DCARRowID+'" scrolling="no" frameborder="0" style="width:100%;height:90%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
}