var arrayObj=new Array(
	new Array("seeDTLaterOrdDT","ECSeeDTLaterOrdDT","Y"),
	new Array("seeDTLaterOrdSttDT","ECSeeDTLaterOrdSttDT"),
	new Array("seeDTBeforeDisDT","ECSeeDTBeforeDisDT","Y"),
	new Array("seeOrdShowNotes","ECSeeOrdShowNotes"),
	new Array("seeReceiveRequired","ECSeeReceiveRequired"),
	new Array("seeRefuseRequired","ECSeeRefuseRequired"),
	new Array("execLaterOrdDT","ECExecLaterOrdDT","Y"),
	new Array("execLaterOrdSttDT","ECExecLaterOrdSttDT","Y"),
	new Array("execBeforeDisDT","ECExecBeforeDisDT","Y"),
	new Array("longOrdLaterMin","ECLongOrdLaterMin"),
	new Array("tempOrdLaterMin","ECTempOrdLaterMin"),
	new Array("ordExectedNotCancel","ECOrdExectedNotCancel"),
	new Array("seeAndExecUserCanSame","ECSeeAndExecUserCanSame"),
	new Array("nurExecControl","ECExecControl"),
	new Array("skinTestNotesRequired","ECSkinTestNotesRequired"),
	new Array("skinOrdExecSequence","ECSkinOrdExecSequence"),
	new Array("skinResultDTLaterMin","ECSkinResultDTLaterMin"),
	new Array("SHOrdNeedSee","ECSHOrdNeedSee"),
	new Array("SZOrdOnlySurgeryRoomSee","ECSZOrdOnlySurgeryRoomSee"),
	new Array("SZOrdOnlySurgeryRoomExec","ECSZOrdOnlySurgeryRoomExec"),
	new Array("ClickAutoCheckRow","ECClickAutoCheckRow"),
	new Array("defaultDT","ECExecDefaultDT"),
	new Array("editeDefaultDT","ECEditeDefaultDT"),
	new Array("ordExecLimit","ECOrdLimitExecDT"),
	new Array("minute","ECLongOrdForwardMin"),
	new Array("minute2","ECTempOrdForwardMin"),
	new Array("LisOrdSyncVBDT","ECLisOrdSyncVBDT"),
	new Array("changeSkinTestResut","ECChangeSkinTestResut"),
	new Array("cancelExecOrder","ECCancelExecOrder"),
	new Array("drugAudit","ECExamLimitExec"),
	new Array("searchMaxPatNum","ECMaxPatNum"),
	new Array("docSign","ECDocSign"),
	new Array("checkRowBackColor","ECCheckRowBackColor"),
	new Array("chgSheetKeepSearchCondition","ECChgSheetKeepSearchCondition"),
	new Array("chgSheetKeepSearchContent","ECChgSheetKeepSearchContent"),
	new Array("filterCureApplyOrd","ECFilterCureApplyOrd"),
	new Array("patChangeAutoSearchOrd","ECPatChangeAutoSearchOrd"),
	new Array("execLaterOrdSeeDT","ECExecLaterOrdSeeDT","Y")
)
$(window).load(function() {
	$("#Loading").hide();
});
$(function(){ 
	InitHospList();
	InitEvent();
	$("input[id*='BackColor']").color({
		editable: false,
		onChange: function (value) {
		}
	})
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_ExecuteConfig"); //CF.NUR.NIS.ExecuteConfig
	hospComp.jdata.options.onSelect = function(e,t){
		getConfig();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		initSeeDTLaterOrdSttDTTab();
		getConfig();
	}
}
function InitEvent(){
	$("#BtnSave").click(SaveClick);
	$("#skinOrdExecSequence").click(function () {
        $(".current").removeClass("current");
        if ($(".ant-switch-checked").length) {
            $("#skinOrdExecSequence").removeClass("ant-switch-checked");
            $($(".switch label")[0]).addClass("current");
        } else {
            $("#skinOrdExecSequence").addClass("ant-switch-checked");
            $($(".switch label")[1]).addClass("current");
        }
        setSkinResultDTLaterMinStatus();
    });
}
var editIndex;
function initSeeDTLaterOrdSttDTTab(){
	var priorityData=$.cm({
		ClassName:"web.DHCDocItemDefault",
		QueryName:"FindGlobal",
		GlobalName:"^OECPR("
	},false)
	priorityData=priorityData.rows;
    $('#seeDTLaterOrdSttDTTab').datagrid({
        singleSelect: true,
        url: $URL,
        height:150,
        columns: [[
            {
                field: 'priorityId', title: '医嘱优先级',width:150,
                formatter: function (value, row) {
                    var index=$.hisui.indexOfArray(priorityData,"RowId",value);
                    if (index>=0){
                    	return priorityData[index].Desc;
                    }
                    return "";
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'RowId',
                        textField: 'Desc',
                        data:priorityData,
                        editable:false
                    }
                },
            },
            {
                field: 'time', title: '可晚于医嘱开始时间(min)', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'oper', title: '操作', width: 80, formatter: function(value,row,index){
	            var btns = '';
			    btns = '<a class="deletecls" href="#" onclick=del(\'' + row.priorityId + '\')></a>'
			    return btns;
	        }}
        ]],
        idField:'priorityId',
        rownumbers:false,
        onClickRow: function(index, rowData){
	        if ((editIndex!=undefined)&&(editIndex!=index)){
		        $('#seeDTLaterOrdSttDTTab').datagrid("endEdit",editIndex).datagrid("rejectChanges");
		    }
		    $('#seeDTLaterOrdSttDTTab').datagrid('selectRow', index).datagrid('beginEdit', index);
		    editIndex = index;
	    },
        onLoadSuccess: function (data) {
            $('#' + this.id).datagrid('appendRow', { priorityId: '', time: ''});
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
}
function del(priorityId){
	if (priorityId==""){
		$.messager.popover({msg: '未保存的行不能删除！',type: 'error'});
		return;
	}
	$.messager.confirm("提示", "确定要删除吗?",
    	function(r) {
        if (r) {
	        var index=$('#seeDTLaterOrdSttDTTab').datagrid("getRowIndex",priorityId);
	        if (index>=0){
		        $.cm({
					ClassName:"Nur.NIS.Service.OrderExcute.CommonConfig",
					MethodName:"delPrioritySeeDTLaterOrdSttDT",
					priorityId:priorityId,
					hospId:$HUI.combogrid('#_HospList').getValue()
				},function(rtn){
					if (rtn ==0) {
						$.messager.popover({msg: '删除成功！',type: 'success'});
						$('#seeDTLaterOrdSttDTTab').datagrid("deleteRow",index);
					}else{
						$.messager.popover({msg: '删除失败！',type: 'error'});
					}
				})
		    }else{
			    $.messager.popover({msg: '未保存的行不能删除！',type: 'error'});
			}
        }
    })
}
function SaveClick(){
	var saveDataArr=[];
	for (var i=0;i<arrayObj.length;i++) {
		var itemId=arrayObj[i][0];
		var propertyName=arrayObj[i][1];
		var defaultValue=arrayObj[i][2];
		var propertyValue="";
		var _$id=$("#"+itemId);
		if (_$id.length > 0){
			if (itemId=="skinOrdExecSequence") {
				if ($(".ant-switch-checked").length) {
					propertyValue=1;
				}else{
					propertyValue=0;
				}
			}else if(itemId=="checkRowBackColor"){
				propertyValue=$("#"+itemId).color("getValue");
			}else{
				propertyValue=getValueById(itemId);
				var objType=_$id.prop("type");
				if (objType=="checkbox"){
					propertyValue=propertyValue?"Y":"N";
				}
				if ((itemId=="defaultDT")&&(propertyValue=="")){
					propertyValue=2;
				}
			}
		}else{
			var _$nameId=$("input[name='"+itemId+"']:checked");
			if (_$nameId.length>0){
				propertyValue=_$nameId[0].value;
			}else{
				if (propertyName=="ECOrdLimitExecDT") {
					var longOrdExecLimit=getValueById("longOrdExecLimit");
					var tempOrdExecLimit=getValueById("tempOrdExecLimit");
					if ((!longOrdExecLimit)&&(!tempOrdExecLimit)) propertyValue=0;
					else if((longOrdExecLimit)&&(!tempOrdExecLimit)) propertyValue=1;
					else if((!longOrdExecLimit)&&(tempOrdExecLimit)) propertyValue=2;
					else if((longOrdExecLimit)&&(tempOrdExecLimit)) propertyValue=3;
				}
			}
		}
		saveDataArr.push({
			key:propertyName,
			value:propertyValue
		});
	}
	var reg1 = /^[0-9]*[1-9][0-9]*$/; //大于0的正整数
	var timeArr=[];
	var rows=$("#seeDTLaterOrdSttDTTab").datagrid("getRows");
	for (var j=0;j<rows.length;j++){
		var editors=$('#seeDTLaterOrdSttDTTab').datagrid('getEditors',j);
		if (editors.length ==0) {
			var priorityId=rows[j].priorityId;
			var time=rows[j].time;
			if (priorityId=="") continue;
		}else{
			var priorityId=editors[0].target.combobox("getValue");
			var time=$.trim(editors[1].target.val());
			if (time==""){
				$.messager.popover({msg: editors[0].target.combobox("getText")+' 可晚于医嘱开始时间不能为空！',type: 'error'});
				return false;
			}else if(!reg1.test(time)){
				$.messager.popover({msg: editors[0].target.combobox("getText")+' 可晚于医嘱开始时间请输入大于0的整数！',type: 'error'});
				return false;
			}
		}
		timeArr.push(priorityId+"$"+time);
	}
	saveDataArr.push({
		key:"ECPrioritySeeDTLaterOrdSttDT",
		value:timeArr.join("^")
	});
	$.m({
		ClassName:"Nur.NIS.Service.OrderExcute.CommonConfig",
		MethodName:"SaveExecuteConfig",
		dataArr:JSON.stringify(saveDataArr),
		hospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		var rtnArr=rtn.toString().split("^");
		if (rtnArr[0] == 0) {
			$.messager.popover({msg: rtnArr[1]?rtnArr[1]:'保存成功！',type: 'success'});
		}else{
			$.messager.popover({msg: rtnArr[1]?rtnArr[1]:'保存成功！',type: 'error'});
		}
		setSeeDTLaterOrdSttDTTab(timeArr.join("^"));
		loadAuthItemHtml();
	})
}
function getConfig(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.CommonConfig",
		MethodName:"GetExecuteConfig",
		hospId:$HUI.combogrid('#_HospList').getValue()
	},function(obj){
		setDataValue(obj);
		seeOrdShowNotesChange();
		setSkinResultDTLaterMinStatus();
		setTimeout(function(){
			setSeeDTLaterOrdSttDTTab(obj.ECPrioritySeeDTLaterOrdSttDT);
		});
		loadAuthItemHtml();
	})
}
function setSeeDTLaterOrdSttDTTab(data){
	var arr=[];
	for (var i=0;i<data.split("^").length;i++){
		var oneData=data.split("^")[i];
		if (oneData=="") continue;
		var obj={
			priorityId:oneData.split("$")[0],
			time:oneData.split("$")[1]
		}
		arr.push(obj);
	}
	$('#seeDTLaterOrdSttDTTab').datagrid("loadData",{"total":arr.length,"rows":arr});
}
function setDataValue(obj){
	for (var i=0;i<arrayObj.length;i++) {
		var itemId=arrayObj[i][0];
		var propertyName=arrayObj[i][1];
		var defaultValue=arrayObj[i][2];
		var propertyValue=obj[propertyName];
		if (defaultValue) propertyValue=defaultValue;
		var _$id=$("#"+itemId);
		if (_$id.length > 0){
			if (itemId=="skinOrdExecSequence") {
				$(".current").removeClass("current");
		        if (propertyValue==1) {
			        $("#skinOrdExecSequence").addClass("ant-switch-checked");
		            $($(".switch label")[1]).addClass("current");
		        } else {
		            $("#skinOrdExecSequence").removeClass("ant-switch-checked");
		            $($(".switch label")[0]).addClass("current");
		        }
			}else if(itemId=="checkRowBackColor"){
				if (propertyValue!=""){
					_$id.color('setValue', propertyValue);
				}else{
					_$id.color('clear');
				}
			}else{
				var objType=_$id.prop("type");
				var objClassInfo=_$id.prop("class");
				if (objType=="checkbox"){
					$("#"+itemId).checkbox("setValue",propertyValue=="Y"?true:false);
				}else if (objType=="select-one"){
					if ((itemId=="defaultDT")&&(propertyValue==2)){
						$("#"+itemId).combobox("select","");
					}else{
						$("#"+itemId).combobox("setValue",propertyValue);
					}
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combobox")>=0){
						$("#"+itemId).combobox("setValue",propertyValue);
					}else if(objClassInfo.indexOf("number")>=0){
						$("#"+itemId).numberbox("setValue",propertyValue);
					}
				}
			}
		}else{
			var _$nameId=$("input[name='"+itemId+"']");
			if (_$nameId.length>0){
				if ((itemId=="nurExecControl")&&(propertyValue=="")) propertyValue=0;
				_$nameId.radio("uncheck");
				for (var j=0;j<_$nameId.length;j++){
					if (_$nameId[j].value==propertyValue){
						$(_$nameId[j]).radio("check");
					}
				}
				
			}else{
				if (propertyName=="ECOrdLimitExecDT") {
					$("#longOrdExecLimit,#tempOrdExecLimit").checkbox("uncheck");
					if(propertyValue==1){
						$("#longOrdExecLimit").checkbox("check");
						$("##tempOrdExecLimit").checkbox("uncheck");
					}else if(propertyValue==2){
						$("#longOrdExecLimit").checkbox("uncheck");
						$("##tempOrdExecLimit").checkbox("check");
					}else if(propertyValue==3){
						$("#longOrdExecLimit,#tempOrdExecLimit").checkbox("check");
					}
				}
			}
		}
	}
}
function seeOrdShowNotesChange(){
	var val=$("#seeOrdShowNotes").checkbox("getValue");
	if (val){
		$("#seeReceiveRequired,#seeRefuseRequired").checkbox("setDisable",false);
	}else{
		$("#seeReceiveRequired,#seeRefuseRequired").checkbox("setDisable",true).checkbox("uncheck");
	}
}
function setSkinResultDTLaterMinStatus(){
	 if ($(".ant-switch-checked").length) {
		 $("#skinResultDTLaterMin").numberbox("setValue","");
		 $("#skinResultDTLaterMin").prop("disabled",true);
	 }else{
		 $("#skinResultDTLaterMin").prop("disabled",false);
     }
}
function loadAuthItemHtml(){
    $cm({ClassName:"Nur.NIS.Service.OrderExcute.CommonConfig",MethodName:"getAuthItem"},function(dataArr){
	    for (var i=0;i<dataArr.length;i++){
		    var rtn=$m({
		        ClassName: "BSP.SYS.SRV.AuthItemApply",
		        MethodName: 'GetStatusHtml',
		        AuthCode:dataArr[i].authCode
		    }, false);
		    if (rtn!=""){
			    $(".icon-stamp").remove();
				$(rtn).insertAfter('#'+dataArr[i].itemId+' + label');
			}
		}
	})
}
