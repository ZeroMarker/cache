var CureRecordDataGrid;

function InitCureRecordDataGrid()
{
	// Toolbar
	var cureRecordToolBar = [{
		id:'BtnDetailView',
		text:'浏览', 
		iconCls:'icon-funnel-eye',  
		handler:function(){
			DetailView();
		}
	},{
		id:'BtnCancelRecord',
		text:'撤消治疗记录', 
		iconCls:'icon-cancel',  
		handler:function(){
			CancelRecord();
		}
	},{
		id:'BtnUploadPic',
		text:'上传图片', 
		iconCls:'icon-upload-cloud',  
		handler:function(){
			UploadPic();
		}
	}];
	// 治疗申请单预约记录Grid
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
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"Rowid",
		pageSize : 5,
		pageList : [5,15,50,100],
		columns :[[   
        			{field:'Rowid',title:'',width:1,hidden:true}, 
        			{field:'PatientNo',title:'登记号',width:100,align:'left'},   
        			{field:'PatientName',title:'姓名',width:80,align:'left'},
        			{field:'DCRTitle',title:'标题',width:300},  
        			{field:'CreateUser',title:'创建人',width:100},
        			{field:'CreateDate',title:'创建时间',width:100},
        			{field:'IsPicture',title:'是否有图片',width:70,
	        			formatter:function(value,row,index){
							return '<a href="###" id= "'+row["Rowid"]+'"'+' onmouseover=ShowCurePopover(this);'+' onclick=ShowCureRecordPic(\''+row.Rowid+'\');>'+row.IsPicture+"</a>"
						},
						styler:function(value,row){
							return "color:blue;text-decoration: underline;"
					}},
					{ field: 'Trance', title: '过程追踪', width:60, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
					      retStr = "<a href='#' title='治疗过程追踪'  onclick='ShowReportTrace(\""+rowData.Rowid+"\")'><span class='icon-track' title='治疗过程追踪')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
						  return retStr;
					  }
					},
        			{field:'UpdateUser',title:'最后更新人',width:100},
        			{field:'UpdateDate',title:'最后更新时间',width:100} ,
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
		title:'治疗记录浏览',
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
	$.messager.confirm('确认','是否确认撤消治疗记录?',function(r){    
		if (r){    
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"CancelRecord",
				'DCRRowId':DCRRowId,
				'UserID':session['LOGON.USERID'],
				dataType:"text"
			},function testget(value){	
				if(value=="0"){
					$.messager.show({title:"提示",msg:"撤消成功"});	
					CureRecordDataGridLoad();
					if(window.frames.parent.CureApplyDataGrid){
						window.frames.parent.RefreshDataGrid();
					}else{
						RefreshDataGrid();	
					}
				}else{
					var msg=value.split("^")[1];
					$.messager.alert('提示',msg);
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
		title:'治疗记录图片上传',
		width:"580px",height:"320px",
		CureRecordDataGridLoad:CureRecordDataGridLoad
	});
}
function GetSelectRow(){
	var rows = CureRecordDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条治疗记录");
		return "";
	}else if (rows.length>1){
 		$.messager.alert("错误","您选择了多个治疗记录！",'err')
 		return "";
	}
	var DCRRowId=""
	var rowIndex = CureRecordDataGrid.datagrid("getRowIndex", rows[0]);
	if(rowIndex<0){
		$.messager.alert("提示","请选择一条治疗记录");
		return "";
	}
	var selected=CureRecordDataGrid.datagrid('getRows'); 
	var DCRRowId=selected[rowIndex].Rowid;
	if(DCRRowId=="")
	{
		$.messager.alert('提示','请选择一条治疗记录');
		return "";
	}
	return DCRRowId;
}
function ShowCurePopover(that){
	var title=""
	var content="单击浏览图片"
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
		title:'治疗记录图片浏览',
		width:"1000px",height:"700px",
		CureRecordDataGridLoad:CureRecordDataGridLoad
	});	
}
function ShowReportTrace(DCARRowID) {
	var width = document.body.clientWidth - 200;
	var height = 380;
	$("#win_ReportTrace").window({
		modal:true,
		title:'治疗过程追踪',
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