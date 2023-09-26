if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
var CureExecDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();
	CureExecDataGridLoad();
})

function Init(){
	InitCureExecDataGrid();	
}

function InitEvent(){
	$HUI.checkbox("#OnlyNoExcute",{
		onChecked:function(e,val){
			setTimeout("CureExecDataGridLoad();",10)
		},
		onUnchecked:function(e,val){
			setTimeout("CureExecDataGridLoad();",10)
		},
	})	
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
		pagination : true,  //
		rownumbers : true,  //
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
        			{field:'OEOREExStDate',title:'要求执行时间',width:130,align:'left'},
        			{field:'OEOREQty',title:'执行数量',width:80,align:'left'} ,
        			{field:'OEOREStatus',title:'执行状态',width:100,align:'left'},
        			{field:'OEOREUpUser',title:'执行人',width:100,align:'left'},
        			{field:'OEOREExDate',title:'操作时间',width:130,align:'left'} ,
        			{field:'OEOREType',title:'医嘱类型',width:100,align:'left'} ,
        			{field:'ApplyStatus',title:'申请状态',width:100,align:'left'} ,
        			{field:'ApplyStatusCode',title:'ApplyStatusCode',width:100,align:'left',hidden:true} ,
        			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}    
    			 ]] ,
    	//toolbar : cureExecToolBar,
	});
}
function CureExecDataGridLoad()
{
	var DCARowIdStr=$('#DCARowIdStr').val();
	var CheckOnlyNoExcute="";
	var OnlyNoExcute=$("#OnlyNoExcute").prop("checked");
	if (OnlyNoExcute){CheckOnlyNoExcute="ON"};
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		QueryName:"FindCureExecList",
		'DCARowId':DCARowIdStr,
		'OnlyNoExcute':CheckOnlyNoExcute,
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
			$.messager.show({title:"提示",msg:"操作完成"});	
			if(IncludeNotInpFlag==1){
				$.messager.alert("提示","非住院临时医嘱无需停止执行,已自动过滤.");		
			}	
			CureExecDataGridLoad();
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
	var ApplyStatusCode=selected.ApplyStatusCode;
	var DCRRowId=selected.DCRRowId;
	if(ApplyStatusCode=="C"){
		$.messager.alert("提示","该申请已撤销,无法执行.", 'error');	
		return false;
	}
	if ((DCRRowId!="")&&(DCRRowId!=undefined)){
		$.messager.alert("提示","该执行记录已执行,不允许添加治疗记录,如需修改,请使用浏览执行进行修改.", 'error');	
		return false;
	}
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+OEORERowID+"&source="+"exec";
	websys_showModal({
		url:href,
		title:'添加治疗记录', 
		width:760,height:500,
		CallBackFunc:function(ReturnValue){
			websys_showModal("close");
			if (ReturnValue != "" && typeof(ReturnValue) != "undefined") {
				if(ReturnValue){CureExecDataGridLoad();}
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
		var MyrowIndex = CureExecDataGrid.datagrid("getRowIndex", rows[i]);
		
		var Rowid=rows[i].OEORERowID;
		var DCRRowId=rows[i].DCRRowId;
		var OEOREExStDate=rows[i].OEOREExStDate;
		if ((DCRRowId!="")&&(DCRRowId!=undefined)){
			$.messager.alert("提示",OEOREExStDate+"该执行记录已执行,不允许批量执行", 'error');	
			return false;
		}
		var ApplyStatusCode=rows[i].ApplyStatusCode;
		if(ApplyStatusCode=="C"){
			$.messager.alert("提示",OEOREExStDate+"该申请已撤销,无法执行.", 'error');	
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
					}else{
						$.messager.alert('提示',"操作失败:"+value);
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
	//var DCRRowId=myselected[MyrowIndex].DCRRowId;
	if(DCRRowId=="")
	{
		$.messager.alert('Warning','该执行记录未执行,请先执行后浏览！');
		return false;
	}
	var href="doccure.curerecord.hui.csp?DCAARowId="+"&OperateType="+"ZLYS"+"&DCRRowId="+DCRRowId+"&OEORERowID="+"&source="+"exec";
	websys_showModal({
		url:href,
		title:'修改治疗记录', 
		width:760,height:500,
		CallBackFunc:function(ReturnValue){
			websys_showModal("close");
			if (ReturnValue != "" && typeof(ReturnValue) != "undefined") {
				$.messager.show({title:"提示",msg:"修改治疗记录成功!"});
			}
		}
	})	
}
/*
function CreateWindow(param1) {
	//默认宽高
	var winWidth=250;
	var winHeight=150;
	var ExecType=$("#ExecType").val();
	//alert(ExecType)
	var myTitle="填写执行次数";
	if(ExecType="C"){
		myTitle="填写撤销执行次数"
	}
	$("#"+param1+"").dialog({
		width:winWidth,    
		height:winHeight,
		title:myTitle,
		closed:false,
		closable:false,
		cache: false,
		modal:true,
		inline:true,
		buttons:[{
			text:'保存',
			iconCls:'icon-save',
			handler:function(){
				var returnstr="";				
				var Exec=$("#Exec").val();
				if(Exec==""){
					//$.messager.alert("提示信息","请填写次数");
					//return false;	
				}
				var returnstr=Exec;
				window.returnValue=returnstr;
				window.close();
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
				window.returnValue=null;
				window.close();
			}
		}]
	});
}

function SetDefaultDate(){
    var Defaultnumber=$("#DefaultNum").val();
   	$("#Exec").numberbox("setValue",Defaultnumber);  
} 
*/	