if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
var CureExecDataGrid;
function InitExecEvent(){
	$HUI.checkbox("#OnlyNoExcute",{
		onCheckChange:function(e,value){
			setTimeout("CureExecDataGridLoad();",10)
		}
	})
}

function InitExecDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
	
    
    $("#Exec_StartDate,#Exec_EndDate").datebox({
		onChange: function(newValue, oldValue){
			if (typeof CureExecDataGrid === 'object'){
				if ((newValue!=oldValue)){ //&&(DATE_FORMAT.test(newValue))
					CureExecDataGridLoad()
				}
			}
		}
	});	
	$("#Exec_StartDate,#Exec_EndDate").datebox('setValue',CurDay);
}

function InitCureExecDataGrid()
{
	CureExecDataGrid=$('#tabCureExecList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		//url : '',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"OEORERowID",
		pageSize:10,
		pageList : [10,25,50],
		columns :[[ 
			{field:'RowCheck',checkbox:true},
			{field:'ApplyDate',title:'申请日期',width:130,align:'left'},  
			{field:'DCARowId',title:'',width:1,hidden:true}, 
			{field:'DCRRowId',title:'',width:1,hidden:true},
			{field:'PapmiNo',title:'登记号',width:100},   
			{field:'PatientName',title:'姓名',width:80},
			{field:'ArcimDesc',title:'治疗项目',width:280,align:'left'},  
			{field:'AppointFlag',title:'是否已预约',width:100,align:'left'},  
			{field:'OEOREExStDate',title:'要求执行时间',width:130,align:'left'},
			{field:'OEOREQty',title:'执行数量',width:80,align:'left'} ,
			{field:'OEOREStatus',title:'执行状态',width:100,align:'left'},
			{field:'OEOREUpUser',title:'执行人',width:100,align:'left'},
			{field:'OEOREExDate',title:'操作时间',width:130,align:'left'} ,
			{field:'OEOREType',title:'医嘱类型',width:100,align:'left'} ,
			{field:'OEOREStatusCode',title:'OEOREStatusCode',width:50,align:'left',hidden:true},
			{field:'OEORERowID',title:'ID',width:50,align:'left',hidden:true}    
		 ]],
		 rowStyler:function(index,row){   
	        if (row.AppointFlag=="已预约"){   
	            return 'background-color:#D3D3D3;';   
	        }   
	    }
	});
}
function CureExecDataGridLoad()
{
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
	var CheckOnlyNoExcute="";
	var OnlyNoExcute=$("#OnlyNoExcute").prop("checked");
	if (OnlyNoExcute){CheckOnlyNoExcute="ON"};
	var StartDate=$('#Exec_StartDate').datebox('getValue');
	var EndDate=$('#Exec_EndDate').datebox('getValue');
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		QueryName:"FindCureExecList",
		'DCARowId':DCARowIdStr,
		'OnlyNoExcute':CheckOnlyNoExcute,
		'StartDate':StartDate,
		'EndDate':EndDate,
		Pagerows:CureExecDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureExecDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	CureExecDataGrid.datagrid("clearChecked");
	CureExecDataGrid.datagrid("clearSelections");
}


function UpdateExec(Type){
	var rows = CureExecDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条记录");
		return;
	}
	if(Type=="C"){
		var msg="是否确认撤销执行";
	}else if(Type=="S"){
		var msg="是否确认停止执行"	;
	}else{
		//var msg="是否确认执行"	;
		OpenCureRecordDiag();
		return ;
	}
	$.messager.confirm('确认',msg,function(r){    
	    if (r){
		    var UserID=session['LOGON.USERID'];
			var DCARowId="";
			var DCARowIdStr="";
			var IncludeNotInpFlag=0;
			var ErrFlag=0;
			var QuitArray=new Array();
			var AllowArray=new Array();
			for(var i=0;i<rows.length;i++){
				var PatientName=rows[i].PatientName;
				var ArcimDesc=rows[i].ArcimDesc;
				var DCARowIds=rows[i].DCARowId;
				var OEOREQty=rows[i].OEOREQty;
				var OEORERowID=rows[i].OEORERowID;
				var OEOREType=rows[i].OEOREType;
				if(Type=="S"){
					if(OEOREType.indexOf("住院")<0){
						IncludeNotInpFlag=1;
						continue;	
					}
				}
				if(QuitArray[DCARowIds]){
					continue;	
				}
				var RtnStr=$.cm({
					ClassName:"DHCDoc.DHCDocCure.ExecApply",
					MethodName:"CheckBeforeUpdateExec",
					dataType:"text",
					DCARowId:DCARowIds,
					UserID:session['LOGON.USERID'],
				},false);
				if(RtnStr!=""){
					QuitArray[DCARowIds]=DCARowIds;
					$.messager.alert('提示',PatientName+","+ArcimDesc+","+RtnStr);
					continue;
				}else{
					AllowArray.push(DCARowIds+"^"+OEOREQty+"^"+OEORERowID);
				}
			}
			for(var i=0;i<AllowArray.length;i++){
				var AllowArr=AllowArray[i].split("^");
				var DCARowIds=AllowArr[0];
				var OEOREQty=AllowArr[1];
				var OEORERowID=AllowArr[2];
				var RtnStr=$.cm({
					ClassName:"DHCDoc.DHCDocCure.ExecApply",
					MethodName:"FinishCureApply",
					dataType:"text",
					DCARowId:DCARowIds,
					UserID:session['LOGON.USERID'],
					EexcNum:OEOREQty,
					Type:Type,
					Resource:"",
					OEOREDRStr:OEORERowID,
					LocDeptDr:session['LOGON.CTLOCID']
				},false);
		        //var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.ExecApply","FinishCureApply",DCARowIds,session['LOGON.USERID'],OEOREQty,Type,"",OEORERowID)
				if(RtnStr=="0"){
					//$.messager.show({title:"提示",msg:"更新成功"});	
					//CureExecDataGridLoad();
				}else{
					if(RtnStr.indexOf("更新执行记录错误")>0){
						var msgcode=RtnStr.split(" ")[0];
						/*
						/// -303:执行记录状态没有变化, 不用改变
						/// -304:执行记录已经执行,不能停止
						/// -302:执行记录已经停止,不能再执行
						/// -305:执行记录没有执行,不需要撤销
						/// -306:执行记录保存失败
						/// -307:执行记录变化表保存失败
						/// -308:执行记录计费变化表保存失败
						/// -310:执行记录扩展表保存失败
						/// -301:停止医嘱执行记录失败
						/// -310:计费状态相同,不用改变
						/// -311:已经退费,不需要再免费
						/// -313:已经待计费,不需要取消免费
						/// -314:临时医嘱未停止或者撤销,不能停止执行
						/// -315:修改执行记录医嘱状态失败
						/// -316:已作废或撤销的临时医嘱的执行记录,不允许执行
						/// -317:长期医嘱停止时间后的执行记录不允许再执行
						/// -318:已经发药不允许停止执行(仅限门急诊)
						*/
						var msgdesc=msgcode;
						if(msgcode=="-303")msgdesc="执行记录状态没有变化,不能再次操作";
						else if(msgcode=="-302")msgdesc="执行记录已经停止,不能再执行"
						else if(msgcode=="-304")msgdesc="只有未执行或者撤销执行的记录可以停止执行."
						else if(msgcode=="-305")msgdesc="执行记录没有执行,不需要撤销"
						else if(msgcode=="-310")msgdesc="执行记录扩展表保存失败"
						else if(msgcode=="-316")msgdesc="已作废或撤销的临时医嘱的执行记录,不允许执行"
						else if(msgcode=="-314")msgdesc="临时医嘱未停止或者撤销,不能停止执行"
						RtnStr="更新执行记录错误,"+msgdesc;
					}
					ErrFlag=1;
					var msg=PatientName+","+ArcimDesc+",更新失败:"+RtnStr
					$.messager.alert('提示',msg);
				}
			}
			
			if(IncludeNotInpFlag==1){
				$.messager.alert("提示","非住院临时医嘱无需停止执行,已自动过滤.");		
			}else{
				if(AllowArray.length>0){
					$.messager.show({title:"提示",msg:"操作完成"});	
				}
			}	
			CureExecDataGridLoad();
			if(window.frames.parent.CureApplyDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}
	    }    
	});  
}
function OpenCureRecordDiag()
{
	var rows = CureExecDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length>1){
		$.messager.alert("提示","只能为一条执行记录进行执行,如需多条执行,请选择批量执行记录功能.", 'error');	
		return false;	
	}
	var selected = CureExecDataGrid.datagrid('getSelected');
	var PatientName=selected.PatientName;
	var ArcimDesc=selected.ArcimDesc;
	var DCARowIds=selected.DCARowId;
	var OEOREQty=selected.OEOREQty;
	var OEORERowID=selected.OEORERowID;
	var OEOREType=selected.OEOREType;
	var DCRRowId=selected.DCRRowId;
	var OEOREStatusCode=selected.OEOREStatusCode;
	var RtnStr=$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		MethodName:"CheckBeforeExec",
		dataType:"text",
		DCARowId:DCARowIds,
		UserID:session['LOGON.USERID'],
		OEORERowID:OEORERowID
	},false);
	if(RtnStr!=""){
		$.messager.alert("提示",RtnStr, 'error');	
		return false;	
	}
	
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+OEORERowID+"&source="+"exec";
	websys_showModal({
		url:href,
		title:'添加治疗记录', 
		width:785,height:500,
		CallBackFunc:function(ReturnValue){
			websys_showModal("close");
			if (ReturnValue != "" && typeof(ReturnValue) != "undefined") {
				CureExecDataGridLoad();
				if(window.frames.parent.CureApplyDataGrid){
					window.frames.parent.RefreshDataGrid();
				}else{
					RefreshDataGrid();	
				}
			}
		}
	})
}
// 批量执行
function GenAddCureRecord(){
	var rows = CureExecDataGrid.datagrid("getSelections");
	var length=rows.length;
	var finflag=0;
	var selRowid="";
	for(var i=0;i<length;i++){
		var Rowid=rows[i].OEORERowID;
		var DCRRowId=rows[i].DCRRowId;
		var OEOREExStDate=rows[i].OEOREExStDate;
		if ((DCRRowId!="")&&(DCRRowId!=undefined)){
			$.messager.alert("提示",OEOREExStDate+"该执行记录已执行,不允许批量执行", 'error');	
			return false;
		}
		
		// var OEORERowID=rows[i].OEORERowID;
		if(selRowid==""){
			selRowid=Rowid;
		}else{
			selRowid=selRowid+"^"+Rowid;	
		}
				 
	}
	
	if(selRowid!=""){
		$.messager.confirm('确认','批量执行将按照系统默认取值保存治疗记录内容,是否确认继续批量执行?',function(r){    
		    if (r){    
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Record",
					MethodName:"SaveCureRecordBatch",
					"DCRRowIdStr":selRowid,
					"UserDR":session['LOGON.USERID'],
					"LocDeptDr":session['LOGON.CTLOCID'],
					"Source":"E",
				},function testget(value){
					if(value==""){
	   					$.messager.show({title:"提示",msg:"操作成功"});	
	   					CureExecDataGridLoad();
	   					
	   					if(window.frames.parent.CureApplyDataGrid){
							window.frames.parent.RefreshDataGrid();
						}else{
							RefreshDataGrid();	
						}
		
					}else{
						$.messager.alert('提示',"操作失败:"+value);
						CureExecDataGridLoad();
					}
				})
		    }    
		});  
		
	}else{
		$.messager.alert("提示","请选择一条预约记录");		
	}
}
/// 浏览执行
function DetailExecView(){
	var rows = CureExecDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条执行记录查看");
		return;
	}else if (rows.length>1){
 		$.messager.alert("错误","您选择了多个执行记录！",'err')
 		return;
	}
	var DCRRowId=""
	var rowIndex = CureExecDataGrid.datagrid("getRowIndex", rows[0]);
	var selected=CureExecDataGrid.datagrid('getRows'); 
	var DCRRowId=selected[rowIndex].DCRRowId;
	if(DCRRowId==""){
		$.messager.alert('提示','该执行记录未执行,请先执行后浏览！');
		return false;
	}
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+"&source="+"exec";
    websys_showModal({
		url:href,
		title:'治疗记录浏览',
		width:780,height:550,
		onClose: function() {
			CureRecordDataGridLoad()
		}
	});
}