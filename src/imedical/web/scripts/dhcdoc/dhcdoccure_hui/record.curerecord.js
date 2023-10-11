var PageRecordObj={
	SelectKeyword:"U",
	ModalListDataGrid:"",
	TextArrayObj : new Array("DCRTitle","DCRContent","DCRResponse","DCREffect","CreateUser","CreateDate","UpdateUser","UpdateDate","ReConfirmUser"),
	TimeArrayObj : new Array("DCRCureExecDate","DCRCureDate","DCRCureEndDate"),
	ComboArrayObj : new Array("DCRCurePOA")
}
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
	CureRecordInfoLoad();
	LoadModalListDataGrid(PageRecordObj.SelectKeyword);
});

function Init(){
	PageRecordObj.ModalListDataGrid=InitModalListDataGrid();
	InitKeyWords();
	if(ServerObj.EpisodeID!=""){
		opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID,$(window).width()-30);  /// 加载病人信息
	}else{
		$(".PatInfoItem").html("<label style='color:red;font-weight:bold'>抱歉,获取患者信息错误...</label>")	
	}
}

function InitEvent(){
	$('#btnSave').click(SaveCureRecord);
	$('#SaveModel').click(SaveModel);	
}

function PageHandle(){
	var DCRRowId=$('#DCRRowId').val();
	//dhcdoccure_hui/asstemp/CRCommon.js
	//封装到模板功能js中复用
	if(typeof CRCommon=='object'){
		CRCommon.PageInit();
	}
}

function InitCurePOA(callBack){
	//dhcdoccure_hui/asstemp/CRCommon.js
	//封装到模板功能js中复用
	if(typeof CRCommon=='object'){
		CRCommon.InitCurePOA(ServerObj.DCARowID,callBack);
	}
	/*$HUI.combobox("#DCRCurePOA",{
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=FindCureItemPOA&DCARowId="+ServerObj.DCARowID+"&ResultSetType=array",
		valueField:'CAPPartDR',
		textField:'CAPPart',
		onLoadSuccess:function(){
			var data=$(this).combobox("getData");
			if(data.length==0){
				$(this).combobox("disable");	
			}
			callBack();	
		}
	})*/
}

function CureRecordInfoLoad(){
	new Promise(function(resolve,rejected){
		InitCurePOA(resolve);
	}).then(function(){
		var DCRRowId=$('#DCRRowId').val();
		var DCAARowId=$('#DCAARowId').val();
		var OEORERowID=$('#OEORERowID').val();
		var ret="";
		if(DCRRowId!=""){
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"GetCureRecord",
				DCRRowId:DCRRowId
			},function(objScope){
				SetValue(objScope);
			})
		}else{
			var regS = new RegExp("\\^","g");
			var CureRecordContent=ServerObj.CureRecordContent;
			CureRecordContent=CureRecordContent.replace(regS,String.fromCharCode(10))
			$("#DCRContent").val(CureRecordContent);
			$("#DCRCureDate").datetimebox('setValue',ServerObj.CurrentDateTime);	
		}
	})
}
function SetValue(val){
	if (val=="") return;
	var TempArr=val.split("^");
	var DCRTitle=TempArr[2];
	var DCRContent=TempArr[3];
	var CreateUser=TempArr[5];
	var CreateDate=TempArr[6];
	var UpdateUser=TempArr[8];
	var UpdateDate=TempArr[9];
	var DCRCureDate=TempArr[11];
	var DCRResponse=TempArr[12];
	var DCREffect=TempArr[13];
	var DCRDoseage=TempArr[14];
	var DCRCureEndDate=TempArr[15];
	var DDCISRowid=TempArr[16];
	var DCRCurePOAID=TempArr[17];
	var DCRCureExecDate=TempArr[18];
	var ReConfirmUser=TempArr[20];
	$("#DCRTitle").val(DCRTitle);
	$("#DCRContent").val(DCRContent);
	$("#CreateUser").val(CreateUser);
	$("#CreateDate").val(CreateDate);
	$("#UpdateUser").val(UpdateUser);
	$("#UpdateDate").val(UpdateDate);	
	$("#ReConfirmUser").val(ReConfirmUser);	
	$("#DCRCureDate").datetimebox('setValue',DCRCureDate);
	$("#DCRCureEndDate").datetimebox('setValue',DCRCureEndDate);
	$("#DCRResponse").prop("innerText",DCRResponse);	
	$("#DCREffect").prop("innerText",DCREffect);	
	$("#DCRDosage").prop("innerText",DCRDoseage);
	$("#DCRCureExecDate").datetimebox('setValue',DCRCureExecDate);
	if(DCRCurePOAID!=""){
		$HUI.combobox("#DCRCurePOA").setValues(DCRCurePOAID.split(String.fromCharCode(1)));
	}
}

function CheckBeforSave(){
	var OperateType=$('#OperateType').val();;
    if(OperateType!="ZLYS"){
	   	$.messager.alert("提示","只有治疗医师才可修改治疗记录","info");
		return false; 
	}
	
    var DCRTitle=GetValue("DCRTitle");
	if (DCRTitle==""){
		$.messager.alert("提示","治疗标题不能为空","info");
		return false;
	}
	var DCRContent=GetValue("DCRContent");
	if (DCRContent==""){
		$.messager.alert("提示","治疗记录不能为空","info");
		return false;
	}
	var DCRCureDate=$("#DCRCureDate").datetimebox('getValue');
	if (DCRCureDate=="")
	{
		$.messager.alert("提示","治疗开始时间不能为空","info");
		return false;
	}
	var DCRCureEndDate=$("#DCRCureEndDate").datetimebox('getValue');
	if (DCRCureEndDate=="")
	{
		$.messager.alert("提示","治疗结束时间不能为空","info");
		return false;
	}
	var DCRDosage="";
	var DCRResponse=$("#DCRResponse").val();
	if (DCRResponse==""){
		//$.messager.alert("提示","治疗反应不能为空","info");
		//return false;
	}
	var DCREffect=$("#DCREffect").val();
	if (DCREffect==""){
		//$.messager.alert("提示","治疗效果不能为空","info");
		//return false;
	}
	//record.common.js
	if(typeof CheckSaveInfo == 'function'){
		var rtn=CheckSaveInfo();
		if(!rtn){
			return false;	
		}
	}
	return true;
}

function SaveCureRecord()
{
    var UpdateObj={}
	new Promise(function(resolve,rejected){
		if (!CheckBeforSave()){
			return false;
		}else{
			resolve();
		}
	}).then(function (){
		return new Promise(function(resolve,rejected){
			//电子签名
			CASignObj.CASignLogin(resolve,"CureRecord",false)
		}).then(function(CAObj){
			return new Promise(function(resolve,rejected){
		    	if (CAObj == false) {
		    		return websys_cancel();
		    	} else{
			    	$.extend(UpdateObj, CAObj);
			    	resolve(true);
		    	}
			})
		})	
	}).then(function(){
		var DCRRowId=$('#DCRRowId').val();
		var DCAARowId=$('#DCAARowId').val();
		var OEORERowID=$('#OEORERowID').val();
		var source=$('#source').val();
		var RowIdStr=ServerObj.DCAARowIdStr;
		if(RowIdStr==""){RowIdStr=ServerObj.OEORERowIDS;}
	    if((DCRRowId=="")&&(RowIdStr=="")){
		    return false;
	    }
	    
		if(source=="")source="R";
		var ParaObj={};
		for( var i=0;i<PageRecordObj.TextArrayObj.length;i++) {
		   	var param=PageRecordObj.TextArrayObj[i];
		   	var value=$("#"+param).val();
		   	ParaObj[param]=value;
		}	
		for( var i=0;i<PageRecordObj.TimeArrayObj.length;i++) {
		   	var param=PageRecordObj.TimeArrayObj[i];
		   	var value=$("#"+param).datetimebox('getValue');
		   	var obj={param:value};
		   	ParaObj[param]=value;
		}
		
		var CurePOAData=$HUI.combobox("#DCRCurePOA").getData();
		var CurePOAID="";
		if(CurePOAData.length>0){
			CurePOAID=$HUI.combobox("#DCRCurePOA").getValues();
			if (CurePOAID==""){
			}else{
				CurePOAID=CurePOAID.join(String.fromCharCode(1));
			}
		}
				
		ParaObj.CurePOA=CurePOAID;
		ParaObj.UserDR=session['LOGON.USERID'];
		ParaObj.LogonLocDr=session['LOGON.CTLOCID'];
		ParaObj.HospId=session['LOGON.HOSPID'];
		ParaObj.DCRRowId=DCRRowId;
		if(RowIdStr!=""){
			ParaObj.DCAARowId="";
			ParaObj.OEORERowID="";
			var ParaJson=JSON.stringify(ParaObj);
			//var Para=DCRRowId+"^"+""+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+"";
			//var Para=Para+"^"+DCRCureDate+"^"+DCRDosage+"^"+DCRResponse+"^"+DCREffect+"^"+DCRCureEndDate+"^"+CurePOAID;
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"SaveCureRecordBatch",
				ParaJson:ParaJson,
				RowIdStr:RowIdStr,
				UserDR:session['LOGON.USERID'],
				Source:source
			},function(value){
				var ErrMsg=value.split(String.fromCharCode(1))[0];
				var SuccIDStr=value.split(String.fromCharCode(1))[1];
				if(SuccIDStr!=""){
					if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, SuccIDStr, "CureRecord");
				}
				if(ErrMsg==""){
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					websys_showModal("close");
				}else{
					//errmsg='保存失败'+",错误代码:"+value
					$.messager.alert('错误',ErrMsg,"error");
				}
			})
		}else{
			ParaObj.DCAARowId=DCAARowId;
			ParaObj.OEORERowID=OEORERowID;
			var ParaJson=JSON.stringify(ParaObj);
			//var Para=DCRRowId+"^"+DCAARowId+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+OEORERowID;
			//var Para=Para+"^"+DCRCureDate+"^"+DCRDosage+"^"+DCRResponse+"^"+DCREffect+"^"+DCRCureEndDate+"^"+CurePOAID;
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"SaveCureRecord",
				ParaJson:ParaJson
			},function(value){
				var RetDCRRowId="";
				if(value.indexOf("^")>0){
					var RetCode=value.split("^")[0];
					RetDCRRowId=value.split("^")[1];		
				}else{
					var RetCode=value;	
				}
				if(RetCode==0){
					if( RetDCRRowId!=""){
						if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, RetDCRRowId, "CureRecord");
					}
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					websys_showModal("close");
				}else if(RetCode=="100"){
					$.messager.alert('警告','保存失败,新增治疗记录,必须选择一条预约记录');
				}else if(RetCode=="101"){
					$.messager.alert('警告','保存失败,保存失败,一个预约仅限添加一条治疗记录');
				}else if(RetCode=="102"){
					$.messager.alert('警告','保存失败,预约记录没有对应的执行记录,不能做治疗');
				}else if(RetCode=="103"){
					$.messager.alert('警告','保存失败,已取消预约的不能够添加治疗记录');
				}else if(RetCode=="104"){
					$.messager.alert('警告','保存失败,治疗开始时间不能晚于治疗结束时间');
				}else if(RetCode=="-303"){
					$.messager.alert('警告','保存失败,该预约记录已被执行!');
				}else{
					errmsg='保存失败'+",错误代码:"+RetCode;
					$.messager.alert('错误',errmsg);
				}
			})
		}
	})
}
function InitKeyWords(){
	$("#ModalType").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'个人模板',id:'U'},
	        {text:'科室模板',id:'L'},
	        {text:'通用模板',id:'C',selected:true}
	    ],
	    onClick:function(v){
		    $("#delModal").linkbutton("enable");
		    LoadModalListDataGrid(v.id)
		},
	    onSelect:function(v){}
	});
	$("#ModalType").keywords("select",PageRecordObj.SelectKeyword)
}

function GetKeyWord(){
	var KeyWord="";
	var keyobj=$("#ModalType").keywords("getSelected");
	if(keyobj.length>0){
		KeyWord=keyobj[0].id;	
	}
	return KeyWord;
}
function LoadModalListDataGrid(Type)
{
	if((Type=="")||(typeof(Type)=="undefined")){
		Type=GetKeyWord();	
	}
	$("#ModalListDataGrid").datagrid("unselectAll");
	if(Type=="C"){
		var Pointer="";
	}else{
		var Pointer=(Type=="L"?_PageCureObj.LogCTLocID:_PageCureObj.LogUserID);	
	}
	$cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		QueryName:"FindCRT",
		DDCISRowid:ServerObj.DDCISRowidStr,
		Query:"",
		SaveAs:Type,
		ResultSetType:"array",
		Pointer:Pointer,
		page:1,    //可选项，页码，默认1
		rows:99999    //可选项，获取多少条数据，默认50
	},function(GridData){
		$("#ModalListDataGrid").datagrid('loadData', GridData);
	});
}

function InitCRTTitle(){
}

function SaveModel(){
	var DCRTitle=GetValue("DCRTitle");
	var DCRContent=GetValue("DCRContent");
	var DCRResponse=GetValue("DCRResponse");
	var DCREffect=GetValue("DCREffect");
	if((DCRTitle=="")&&(DCRContent=="")&&(DCRResponse=="")&&(DCREffect=="")){
		$.messager.alert('提示','您要保存什么?');
		return false;
	}
	$code='<div id="win_modal">'
	$code=$code+'<div style="margin-top:20px;">'
	$code=$code+'<a href="#" class="hisui-linkbutton btn-lightgreen m-left-20" onclick="SaveLocModel()">科室模板</a>'
	$code=$code+'<a href="#" class="hisui-linkbutton m-left-20" onclick="SaveUserModel()">个人模板</a>'
	$code=$code+'</div>'
	$code=$code+'</div>'
	com_Util.createModalDialog("SaveModelDiag","选择模板", 250, 110,"icon-w-save","",$code,"");  
}
function SaveLocModel(){
	SaveSelectModel("L");
}
function SaveUserModel(){
	SaveSelectModel("U");
}
function SaveSelectModel(Type)
{
	var DCRTitle=GetValue("DCRTitle");
	var DCRContent=GetValue("DCRContent");
	var DCRResponse=GetValue("DCRResponse");
	var DCREffect=GetValue("DCREffect");
	var SaveAs=(Type=="L"?_PageCureObj.LogCTLocID:_PageCureObj.LogUserID);
	var DCRTExpStr=Type+"^"+SaveAs+"^"+_PageCureObj.LogUserID;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveRecordTemp",
		RowidStr:ServerObj.DDCISRowidStr,
		CRTTitle:DCRTitle,
		CRTDetail:DCRContent,
		CRTType:"",
		CRTResponse:DCRResponse,
		CRTEffect:DCREffect,
		CRTExpStr:DCRTExpStr
	},function(ret){
		if(ret==0){
			$.messager.popover({msg: "保存成功!",type:'success'});
			com_Util.destroyDialog("SaveModelDiag");
			$("#ModalType").keywords("select",Type)
		}else{
			$.messager.alert("提示","保存失败!错误代码:"+ret,"warning");	
		}
	})
	
}
function InitModalListDataGrid(){
	var ModalListDataGrid=$('#ModalListDataGrid').datagrid({
		view:scrollview,
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		fitColumns : false,
		rownumbers:true,
		singleSelect:true,
		autoRowHeight:false,
		pagination:false,
		idField:"CRTRowID",
		columns :[[ 
			{field:'ArcimDesc',title:'医嘱名称',width:100,align:'left', resizable: true},
			{field:'CRTTitle',title:'标题',width:500,align:'left', resizable: true},
			{field:'CRTSaveUser',title:'保存用户',width:100,align:'left', resizable: true},
			{field:'CRTSavePointer',title:'CRTSavePointer',width:20,align:'left', hidden: true},
			{field:'CRTSaveUserDr',title:'CRTSaveUserDr',width:20,align:'left', hidden: true},
			{field:'CRTRowID',title:'CRTRowID',width:20,align:'left', hidden: true}, 
			{field:'CRTDetail',title:'记录',width:120,align:'left', hidden: true},
			{field:'CRTResponse',title:'反应',width:120,align:'left', hidden: true},
			{field:'CRTEffect',title:'效果',width:120,align:'left', hidden: true}
		]],
		toolbar:[{
	        text: '引用',
	        iconCls: 'icon-copy',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
					SetValueByModal(row);
		        }else{
			        $.messager.alert("警告","请选择一行需要引用的记录.","warning")
			    }
	        }
	    },{
	        text: '删除',
	        id: "delModal",
	        iconCls: 'icon-remove',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
			        var CRTRowID=row.CRTRowID;
			        var CRTSaveUserDr=row.CRTSaveUserDr;
			   		if(CRTSaveUserDr!=_PageCureObj.LogUserID){
				   		$.messager.alert("警告","非本人保存模板无法删除.","warning");
						return false;	
				   	}
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.CureItemSet",
						MethodName:"DelItemSetRecordTemp",
						DDCRTRowid:	CRTRowID
					},function(ret){
						if(ret==0){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							LoadModalListDataGrid();
						}else{
							$.messager.alert("警告","删除失败,错误代码:"+ret,"warning");
							return false;		
						}
					})	
		        }else{
			        $.messager.alert("警告","请选择一行需要删除的记录","warning")
			    }
	        }
	    }
		],
		onClickRow:function(rowIndex, rowData){
			var KeyWord=GetKeyWord();	
			if (KeyWord=="C"){
				$("#delModal").linkbutton("disable");
			}else{
				$("#delModal").linkbutton("enable");
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			SetValueByModal(rowData);
		},
		detailFormatter:function(rowIndex, rowData){
			return '<table><tr>' +
				'<td style="border:0;padding-right:10px">' +
				'<p>标题: ' + rowData.CRTTitle + '</p>' +
				'<p>记录: ' + rowData.CRTDetail + '</p>' +
				'<p>反应: ' + rowData.CRTResponse + '</p>' +
				'<p>效果: ' + rowData.CRTEffect + '</p>' +
				'</td>' +
				'</tr></table>';
		}	
	});
	return ModalListDataGrid;
}

function SetValueByModal(row){
	var val=$("#DCRTitle").val();
	//if(val==""){
		var CRTTitle=row.CRTTitle;
		if(CRTTitle=="")CRTTitle=row.ArcimDesc;
		$("#DCRTitle").val(row.CRTTitle);
	//}
	$("#DCRContent").val(row.CRTDetail);
	$("#DCRResponse").val(row.CRTResponse);
	$("#DCREffect").val(row.CRTEffect);		
}
function GetValue(id){
	var regS = new RegExp("\\^","g");
	var val=$("#"+id).val();
	val=val.replace(regS,"");
	return val;
}