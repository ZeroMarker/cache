/**
 * @name nur.needcareorderset.js
 * @author SongChao
 * @description 出入转及需关注配置
*/

var GV = {
    _CALSSNAME: "Nur.HISUI.NeedCareOrderSet",
    dischargeNeedArcimOBJ: {
        getMethod: 'getDischargeNeedArcim',
        combogrid: {
            getMethod: 'getArcim',
            valueField: 'id',
            textField: 'desc',
        },
        fieldName: 'arcimDesc',
        titleDesc: '医嘱项',
        globalNode: 'dischargeNeedArcim',
        operFormatter: outHospNeedOrderDelBtn,
        relBedFieldName:'releaseBedTime', //wk 增加一列的配置
        relBedTitleDesc:'床位释放日期差',
        relBedGlobalNode:'releaseBedTime',
        dischargeHandleFieldName:'dischargeHandleTime', //wk 增加一列的配置
        dischargeHandleTitleDesc:'办理出院日期差',
        dischargeHandleGlobalNode:'dischargeHandleTime'
    },
    deathDischargeNeedArcimOBJ: {
        getMethod: 'getDeathDischargeNeedArcim',
        combogrid: {
            getMethod: 'getArcim',
            valueField: 'id',
            textField: 'desc',
        },
        fieldName: 'arcimDesc',
        titleDesc: '医嘱项',
        globalNode: 'deathDischargeNeedArcim',
        operFormatter: outHospNeedOrderDelBtn,
        relBedFieldName:'releaseBedTime', //wk 增加一列的配置
        relBedTitleDesc:'床位释放日期差',
        relBedGlobalNode:'releaseBedTime',
        deathHandleFieldName:'deathHandleTime',
        deathHandleTitleDesc:'死亡日期填写限制(天)',
        deathHandleGlobalNode:'deathHandleTime'
    },
    diagBeforeDischOBJ: {
        getMethod: 'getDiagBeforeDisch',
        combogrid: {
            getMethod: 'getDiagType',
            valueField: 'id',
            textField: 'desc',
        },
        fieldName: 'dtypDesc',
        titleDesc: '诊断类型',
        globalNode: 'diagBeforeDisch',
        operFormatter: diagBeforeDischDelBtn,
		EmFlagFieldName:'EmFlag', ///wk 增加一列的配置
        EmFlagTitleDesc:'急诊生效',
        EmFlagGlobalNode:'EmFlag',
        MainDiagFlagFieldName:'MainDiagFlag', 
        MainDiagFlagTitleDesc:'是否主诊断',
        MainDiagFlagGlobalNode:'MainDiagFlag',
        DiagRepeatFlagFieldName:'DiagRepeatFlag', 
        DiagRepeatFlagTitleDesc:'是否重复',
        DiagRepeatFlagGlobalNode:'DiagRepeatFlag'
    },
    transNotControlLocOBJ: {
        getMethod: 'GetTransNotControlLoc',
        combogrid: {
            getMethod: 'getLocs',
            valueField: 'id',
            textField: 'desc',
        },
        fieldName: 'desc',
        titleDesc: '科室',
        globalNode: 'transNotControlLoc',
        operFormatter: transNotControlLocDelBtn,
        transNeedCareFieldName:'transNeedCareFlag',
        transNeedCareTitleDesc:'不控制需关注',
        transNeedCareGlobalNode:'transNeedCareFlag',
        transOrderFieldName:'transOrderFlag', 
        transOrderTitleDesc:'不必开立医嘱',
        transOrderGlobalNode:'transOrderFlag',
        transBackNeedCareFieldName:'transBackNeedCareFlag', 
        transBackNeedCareTitleDesc:'回转不控制需关注',
        transBackNeedCareGlobalNode:'transBackNeedCareFlag',
        transWardFieldName:'transNotControlWard', 
        transWardTitleDesc:'病区',
        transWardGlobalNode:'transNotControlWard'
    },
    notAlertGridInitedFlag:0
};
var editIndex = undefined;
var init = function () {
	$(".transNotControlDiv").css("height",$(window).height()-409);
	$(".outHospNeedDiagDiv").css("height",$(window).height()-553);
	initHospComb('Nur_IP_NeedCareOrderSet');
    initPageDom();
    initCheckBoxVal();
    // initEvent();
    /*initToolTip(2);
    initToolTip(3);*/
    $('#deathDischargeNeedArcim').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"床位释放日期差：指床位释放日期和出院/死亡医嘱开始日期的时间差。<br>&nbsp&nbsp&nbsp&nbsp不配置：开医嘱不释放床位；<br>&nbsp&nbsp&nbsp&nbsp配置0：按医嘱开始日期释放床位；<br>&nbsp&nbsp&nbsp&nbsp配置N(N >= 1)：则释放医嘱开始日期第(N+1)天的床位。<br><br>"+
		        "办理出院日期差：指办理出院日期和出院/死亡医嘱开始日期的时间差。<br>&nbsp&nbsp&nbsp&nbsp不配置:  开医嘱不提示医嘱超期；<br>&nbsp&nbsp&nbsp&nbsp配置0：按医嘱开始日期办理出院；<br>&nbsp&nbsp&nbsp&nbsp配置N(N >= 1)：开立出院医嘱N天内办理出院,未能在N天内出院，需关注页面出院医嘱提示超期。<br><br>"+
		        "死亡日期填写限制：指开立死亡医嘱时，死亡日期可填写的日期范围。<br>&nbsp&nbsp&nbsp&nbsp不配置:  早于或等于当天；<br>&nbsp&nbsp&nbsp&nbsp配置N(N>=0)：死亡日期范围为晚于或等于当天日期-N，早于或等于当天。"
    }));
    
    $('#nurDiaChargeTime').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"预计出院时间：医生开立的出院医嘱开始日期时间。<br>"+
		        "当前时间：护士操作出院的当前日期时间。<br>"+
		        "出院医嘱执行时间：护士执行出院医嘱日期时间。"
    }));
    $('#ifGetAdmDateTimeByBedCheck').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"已上线项目不可更改！<br>"+
		        "若患者办理入院前勾选取分床时间，在分床前取消勾选，会导致患者分床后入院时间为空。<br>"
    }));
    loadAuthItemHtml();
}
$(init)
function initPageDom() {
    //initOutHospKeywords();
    initTransLocNeedOrderGrid();
    inittransNotControlLocGrid();
    initOutHospNeedOrdeGrid();
    initOutHospNeedDiagGrid();
    initNeedCareSetGrid();
    initOtherNeedCareSetGrid();
    initDischNurExcute();
    initRecallDayLimit();
    onClickNeedCareSetRow(0, '');
    initEvent();
}
function initEvent() {
    $('#findCareSetBtn').bind('click', findCareSet);
    $("input[name='dischargeType']").radio({
	    onChecked:function(e,value){
			initOutHospNeedOrdeGrid();
		}
	});
	$("input[name='transType']").radio({
	    onChecked:function(e,value){
			initTransLocNeedOrderGrid();
		}
	});
	$("input[name='disChargeDateTime']").radio({
	    onChecked:function(e,value){
		    loadDisChargeDateTimeSet();
		 }
	 });
}
function reloadPage(){
	initPageDom();
    initCheckBoxVal();
	findCareSet();
	//initOutHospKeywords();
    initTransLocNeedOrderGrid();
    inittransNotControlLocGrid();
    initOutHospNeedOrdeGrid();
    initOutHospNeedDiagGrid();
    initNeedCareSetGrid();
    initOtherNeedCareSetGrid();
    initDischNurExcute();
    initRecallDayLimit();
	initCheckBoxVal();
}
function findCareSet() {
    var careType = $('#careTypeBox').combobox('getValue');
    var checkedRadioJObj = $("input[name='ctcptType']:checked");
    var ctcptType = checkedRadioJObj.val();
    $('#needCareSetGrid').datagrid('reload', {
        ClassName: GV._CALSSNAME,
        QueryName: 'getNeedCareSet',
        CareType: careType,
        PersonType: ctcptType,
        HospID: CONST_HOSPID
    })
    onClickNeedCareSetRow(0, '');
}
/*function initOutHospKeywords() {
    $("#outHospKeywords").keywords({
        singleSelect: true,
        width: 200,
        items: [
            { text: '出院医生需开医嘱', id: 'dischargeNeedArcim', selected: true },
            { text: '死亡出院医生需开医嘱', id: 'deathDischargeNeedArcim' },
            { text: '出院前医生必须开的诊断类型', id: 'diagBeforeDisch' },
            { text: '出院护士执行控制', id: 'dischNurExcute' },
            { text: '转入不需要相关控制科室', id: 'transNotControlLoc' }            
        ],
        onClick: function(record){
	        outHospKeywordsClick(record)
	    }
    });
}
function outHospKeywordsClick(record) {
	editIndex = undefined;
	if(record.id=="dischNurExcute"){
		$("#disNurExcute").show();
		initDischNurExcute();
	}else{
		initOutHospNeedOrdeGrid(record.id);
		$("#disNurExcute").hide();
	}    
}*/
/*
初始化出院前需开诊断类型列表
*/
function initOutHospNeedDiagGrid(){
	var outSetObj = GV.diagBeforeDischOBJ;
	$('#outHospNeedDiagGrid').datagrid({
		height:$(".outHospNeedDiagDiv").height(),
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CALSSNAME,
            MethodName: outSetObj.getMethod,
        	HospID: CONST_HOSPID
        },
        columns: initOutHospNeedOrdeGridColumn("outHospNeedDiagGrid", outSetObj),
        onClickRow: function (index) {
            var rows = $('#' + this.id).datagrid('getRows');
            if(outSetObj.relBedFieldName||outSetObj.EmFlagFieldName){ //wk 去掉限制，出院医嘱列表单击可编辑
            	if (editIndex != undefined) {
	            	$('#' + this.id).datagrid('rejectChanges');
	            }
	            initOtherEditGrid(this.id, index);
	        }else{
		        if ((index + 1) == rows.length) { 
		        	if (editIndex != undefined) {
		            	$('#' + this.id).datagrid('rejectChanges');
		            }
                	initOtherEditGrid(this.id, index);
            	}
		    }
        },
        onLoadSuccess: function (data) {
	        var rows=$('#' + this.id).datagrid('getRows');
	        if ((rows.length==0)||((rows[rows.length-1])&&(rows[rows.length-1].id))){
	            $('#' + this.id).datagrid('appendRow', { id: '', desc: '' });
            }
            $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
}
/**
 * @description 初始化出院设置列表
 */
function initOutHospNeedOrdeGrid() {
	editIndex = undefined;
	var outSetObj = getOutHospKeyObj();
    $('#outHospNeedOrdeGrid').datagrid({
	    fit:true,
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CALSSNAME,
            MethodName: outSetObj.getMethod,
        	HospID: CONST_HOSPID
        },
        columns: initOutHospNeedOrdeGridColumn("outHospNeedOrdeGrid", outSetObj), //mode=="transNotControlLoc" ? initNotAlertGridColumn("outHospNeedOrdeGrid",outSetObj) : initOutHospNeedOrdeGridColumn(this.id, outSetObj),
        onClickRow: function (index) {
            var rows = $('#' + this.id).datagrid('getRows');
            if(outSetObj.relBedFieldName||outSetObj.EmFlagFieldName){ //wk 去掉限制，出院医嘱列表单击可编辑
	            initOtherEditGrid(this.id, index);
	        }else{
		        if ((index + 1) == rows.length) { 
                	initOtherEditGrid(this.id, index);
            	}
		    }
            
        },
        onAfterEdit:function (rowIndex, rowData, changes){ //wk 编辑后保存
        	if(outSetObj.relBedGlobalNode){
	        	if(rowData.id){
		        	setDisArcimReleaseTime(outSetObj.relBedGlobalNode, rowData.id, rowData.releaseBedTime,this.id)
		        }	        	
	        }
	        if(outSetObj.dischargeHandleGlobalNode){
		    	 setDisArcimReleaseTime(outSetObj.dischargeHandleGlobalNode, rowData.id, rowData.dischargeHandleTime,this.id)   
		    }
		    if(outSetObj.deathHandleGlobalNode){
		    	 setDisArcimReleaseTime(outSetObj.deathHandleGlobalNode, rowData.id, rowData.deathHandleTime,this.id)   
		    }	
		},
        onLoadSuccess: function (data) {
	        var rows=$('#' + this.id).datagrid('getRows');
	        if ((rows.length==0)||((rows[rows.length-1])&&(rows[rows.length-1].id))){
            	$('#' + this.id).datagrid('appendRow', { id: '', desc: '' });
            }
             $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
    /*if($("#toolbar")){ 
     	var transInCheckType=$m({
			ClassName: GV._CALSSNAME,
			MethodName: "GetTransInCheckedType",
			HospID: CONST_HOSPID
		}, false);
    	$("#transNeedCare").checkbox({
	    	onCheckChange:function(e,value){
		    	var transInCheckType="", locId=""
		    	var transOrderFlag=$("#transOrder").radio('getValue')
		    	if(value){
			    	transInCheckType=transOrderFlag ? "A" : "N";	
			    }else{
				    transInCheckType=transOrderFlag ? "O" : "";
				}
				saveOutTransSet("transInCheckedType", transInCheckType);	
		    }	
	    });
	    $("#transOrder").checkbox({
	    	onCheckChange:function(e,value){
		    	var transInCheckType="";
		    	var transNeedCareFlag=$("#transNeedCare").radio('getValue')
		    	if(value){
			    	transInCheckType=transNeedCareFlag ? "A" : "O";	
			    }else{
				    transInCheckType=transNeedCareFlag ? "N" : "";
				}
				saveOutTransSet("transInCheckedType", transInCheckType);	
		    }	
	    });
    	if(transInCheckType=="A"){
	    	$("#transNeedCare,#transOrder").radio("check");
	    }
	    if(transInCheckType=="N"){
	    	$("#transNeedCare").radio("check");
	    }
	    if(transInCheckType=="O"){
	    	$("#transOrder").radio("check");
	    }
    };*/    
}
function getOutHospKeyObj() {
	var outSetObj = '';
	var chekced=$("input[name='dischargeType']:checked");
	if (chekced.length>0){
		var id=chekced[0].id;
		switch (id) {
	        case 'dischargeNeedArcim':
	            outSetObj = GV.dischargeNeedArcimOBJ;
	            break;
	        case 'deathDischargeNeedArcim':
	            outSetObj = GV.deathDischargeNeedArcimOBJ;
	            break;
	    }
	}
    /*switch (dischargeNeedArcim) {
        case 'dischargeNeedArcim':
            outSetObj = GV.dischargeNeedArcimOBJ;
            break;
        case 'deathDischargeNeedArcim':
            outSetObj = GV.deathDischargeNeedArcimOBJ;
            break;
        case 'diagBeforeDisch':
            outSetObj = GV.diagBeforeDischOBJ;
            break;
         case 'transNotControlLoc':
            outSetObj = GV.transNotControlLocOBJ;
            break
    }*/
    return outSetObj;
}
function initOutHospNeedOrdeGridColumn(tableID, outSetObj) {
    if (!tableID) tableID = 'outHospNeedOrdeGrid';
    
    return [[
        {
            field: outSetObj.fieldName,
            title: outSetObj.titleDesc,
            width: 150,
            formatter: function (value, row) {
                return row[outSetObj.fieldName];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: outSetObj.fieldName=="dtypDesc"?'local':'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 350,
                    idField: outSetObj.combogrid.valueField,
                    textField: outSetObj.combogrid.textField,
                    displayMsg: '',
                    multiple:outSetObj.fieldName=="dtypDesc"?true:false,
                    url: $URL,
                    queryParams: {
                        ClassName: GV._CALSSNAME,
                        QueryName: outSetObj.combogrid.getMethod,
						HospID: CONST_HOSPID
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: outSetObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
                        { field: outSetObj.combogrid.textField, title: outSetObj.titleDesc, width: 300 }
                    ]],

                    onSelect: function (rowIndex, rowData) {
	                    if (outSetObj.fieldName=="dtypDesc") return;
                        var arcimBeforeTrans = $('#' + tableID).datagrid('getData');
                          var ifExit =false;
                         arcimBeforeTrans.rows.forEach(function (row) {	              
	                        if(row.id == rowData.id){
                            	ifExit=true ;
                            	return false;
	                        }
                        })
                        if (!ifExit) {
	                        var rows = $('#' + tableID).datagrid('getRows');//wk  已经保存的重新选择医嘱项后不需再重新保存，否则会导致新加一条
	                        if ((editIndex + 1) >= rows.length) { 
                				endEditing(tableID);
                            	saveOutTransSet(outSetObj.globalNode, rowData.id, tableID);
            				}else{
	            				$('#' + tableID).datagrid('reload');
                				editIndex = undefined;
	            			}
                        }else {
                            $.messager.popover({ msg: outSetObj.titleDesc + '已存在！', type: 'alert', timeout: 2000 });
                        }
                    },
                    onHidePanel:function(){
	                    if (outSetObj.fieldName=="dtypDesc") {
							var val=$(this).combogrid("getValues").join("$");
							if (val==""){
								$.messager.popover({ msg: "请选择"+outSetObj.titleDesc, type: 'error' });
								return false;
							}
							var arcimBeforeTrans = $('#' + tableID).datagrid('getData');
	                        var ifExit =false,index=0;
	                         arcimBeforeTrans.rows.forEach(function (row) {	              
		                        if(((("$"+val+"$").indexOf("$"+row.id+"$")>=0)||(("$"+row.id+"$").indexOf("$"+val+"$")>=0))&&(index!=editIndex)){
	                            	ifExit=true ;
	                            	return false;
		                        }
		                        index++;
	                        })
	                        if (!ifExit) {
		                        var rows = $('#' + tableID).datagrid('getRows');
		                        if ((editIndex + 1) >= rows.length) { 
	                				endEditing(tableID);
	                            	saveOutTransSet(outSetObj.globalNode, val, tableID);
	            				}else{
		            				if (arcimBeforeTrans.rows[editIndex].id){
			            				updateDiagBeforeDisch(arcimBeforeTrans.rows[editIndex].id,val,tableID);
			            				endEditing(tableID);
			            			}else{
				            			$('#' + tableID).datagrid('reload');
	                					editIndex = undefined;
				            		}
		            			}
	                        }else {
	                            $.messager.popover({ msg: outSetObj.titleDesc + '已存在！', type: 'alert', timeout: 2000 });
	                        }
						}
	                }
                }
            },
        },
        
        { 
          id:'releaseBedTime',
          field: outSetObj.relBedFieldName?outSetObj.relBedFieldName:'releaseBedTime',  //wk 增加列
          title: outSetObj.relBedTitleDesc?outSetObj.relBedTitleDesc:'床位释放时间差', 
          width: 115, 
          hidden:!outSetObj.relBedFieldName,
          editor: {
	        type: 'numberbox', 
	        options: { 
	        	precision: 0 
	        	
	        }
	      }
	    }, 	
	    { 
          id:"dischargeHandleTime",
          field: outSetObj.dischargeHandleFieldName?outSetObj.dischargeHandleFieldName:'dischargeHandleTime',  //wk 增加列
          title: outSetObj.dischargeHandleTitleDesc?outSetObj.dischargeHandleTitleDesc:'办理出院日期差', 
          width: 115, 
          hidden:!outSetObj.dischargeHandleFieldName,
          editor: {
	        type: 'numberbox', 
	        options: { 
	        	precision: 0 
	        	
	        }
	      }
	    }, 	
	    { 
          id:"deathHandleTime",
          field: outSetObj.deathHandleFieldName?outSetObj.deathHandleFieldName:'deathHandleTime',
          title: outSetObj.deathHandleTitleDesc?outSetObj.deathHandleTitleDesc:'死亡日期填写限制(天)', 
          width: 150, 
          hidden:!outSetObj.deathHandleFieldName,
          editor: {
	        type: 'numberbox', 
	        options: { 
	        	precision: 0 
	        	
	        }
	      }
	    }, 		
		{ field: outSetObj.MainDiagFlagFieldName?outSetObj.MainDiagFlagFieldName:'MainDiagFlag',  ///wk 增加列
          title: outSetObj.MainDiagFlagTitleDesc?outSetObj.MainDiagFlagTitleDesc:'是否主诊断', 
          width: 115, 
          hidden:!outSetObj.MainDiagFlagGlobalNode,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$('#' + tableID).datagrid('getSelected');
							 if(outSetObj.MainDiagFlagGlobalNode){
								if(rowData.id){
									setMainDiagFlag(outSetObj.MainDiagFlagGlobalNode, rowData.id, rec.value,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
	        	
							}
						}
                    }
                }
	    }, 
		{ field: outSetObj.EmFlagFieldName?outSetObj.EmFlagFieldName:'EmFlag',  ///wk 增加列
          title: outSetObj.EmFlagTitleDesc?outSetObj.EmFlagTitleDesc:'急诊生效', 
          width: 115, 
          hidden:!outSetObj.EmFlagFieldName,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$('#' + tableID).datagrid('getSelected');
							 if(outSetObj.EmFlagGlobalNode){
								if(rowData.id){
									setEmFlag(outSetObj.EmFlagGlobalNode, rowData.id, rec.value,tableID) //wk
									
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
	        	
							}
						}
                    }
                }
	    }, 
	    { field: outSetObj.DiagRepeatFlagFieldName?outSetObj.DiagRepeatFlagFieldName:'DiagRepeatFlag', 
          title: outSetObj.DiagRepeatFlagTitleDesc?outSetObj.DiagRepeatFlagTitleDesc:'是否重复', 
          width: 115, 
          hidden:!outSetObj.DiagRepeatFlagFieldName,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						onSelect: function (rec) {
							var rowData=$('#' + tableID).datagrid('getSelected');
							 if(outSetObj.DiagRepeatFlagGlobalNode){
								if(rowData.id){
									setDiagRepeatFlag(outSetObj.DiagRepeatFlagGlobalNode, rowData.id, rec.value,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
	        	
							}
						}
                    }
                }
	    }, 
        { field: 'oper', title: '操作', width: 40, formatter: outSetObj.operFormatter }
    ]];
}
/**
 * @description 初始化转科不需控制科室表格
 */
function inittransNotControlLocGrid(){
	var tableID = "transNotControlLocGrid";
	var outSetObj = getNotAlertObj("transNotControlLoc");
	$('#' + tableID).datagrid({
		height:$(".transNotControlDiv").height()-28,
        url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            MethodName: outSetObj.getMethod,
			HospID: CONST_HOSPID
        },
        columns: initNotAlertGridColumn("transNotControlLocGrid",outSetObj),
        onClickRow: function (index) {
            var rows = $('#' + tableID).datagrid('getRows');
            if(outSetObj.transNeedCareFieldName||outSetObj.transOrderTitleDesc){
	            initOtherEditGrid(tableID, index);
	        }else{
		        if ((index + 1) == rows.length) { 
                	initOtherEditGrid(tableID, index);
            	}
		    }
        },
        onLoadSuccess: function (data) {
	        var rows=$('#' + this.id).datagrid('getRows');
	        if ((rows.length==0)||((rows[rows.length-1])&&(rows[rows.length-1].id))){
            	$('#transNotControlLocGrid').datagrid('appendRow', { id: '', desc: '' });
            }
            $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
}
/**
 * @description 初始化转科需开医嘱子类表格
 */
function initTransLocNeedOrderGrid() {
	editIndex = undefined;
    $('#transLocNeedOrderGrid').datagrid({
        url: $URL,
        singleSelect:true,
        queryParams: {
            ClassName: GV._CALSSNAME,
            MethodName: 'getArcItmBeforeTrans',
			HospID: CONST_HOSPID
        },
        columns: [[
            {
                field: 'arcItemDesc', title: '医嘱子类', width: 412,
                formatter: function (value, row) {
                    return row.arcItemDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'id',
                        textField: 'desc',
                        defaultFilter: 4,
                        url: $URL + "?1=1&ClassName=" + GV._CALSSNAME + "&QueryName=getArcItmChart&ResultSetType=array&q=&HospID="+CONST_HOSPID,
                        onSelect: function (record) {
                            var arcimBeforeTrans = $('#transLocNeedOrderGrid').datagrid('getData');
                           var ifExit =false;
                         arcimBeforeTrans.rows.forEach(function (row) {	              
	                        if(row.id == record.id){
                            	ifExit=true ;
                            	return false;
	                        }
                        })
                        if (!ifExit) {
                                endEditing('transLocNeedOrderGrid');
                                var chekced=$("input[name='transType']:checked");
								if (chekced.length>0){
									var id=chekced[0].id;
									if (id=="transLoc"){
										saveOutTransSet('arcimBeforeTrans', record.id, 'transLocNeedOrderGrid');
									}else if(id=="transWard"){
										saveOutTransSet('arcimBeforeTransWard', record.id, 'transLocNeedOrderGrid');
									}
								}
                            }
                            else {
                                $.messager.popover({ msg: '医嘱子类已存在！', type: 'alert', timeout: 2000 });
                            }

                        }
                    }
                },
            },
            { field: 'oper', title: '操作', width: 40, formatter: transLocNeedOrderDelBtn }
        ]],
        onClickRow: function (index) {
            initOtherEditGrid(this.id, index);
        },
        onLoadSuccess: function (data) {
	        var rows=$('#' + this.id).datagrid('getRows');
	        if ((rows.length==0)||((rows[rows.length-1])&&(rows[rows.length-1].id))){
            	$('#' + this.id).datagrid('appendRow', { id: '', desc: '' });
            }
            $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad:function(param){
	        var chekced=$("input[name='transType']:checked");
			if (chekced.length>0){
				var id=chekced[0].id;
				if (id=="transLoc"){
					param.MethodName="getArcItmBeforeTrans";
				}else if(id=="transWard"){
					param.MethodName="getArcItmBeforeTransWard";
				}
			}
	    }
    });
}
var editTableID;
function initOtherEditGrid(tableID, index){
	if (editIndex!=undefined){
		if (tableID!="outHospNeedOrdeGrid") $("#"+editTableID).datagrid("rejectChanges");
	    endEditing(editTableID);
	}
	if (editIndex != index) {
        if (endEditing(tableID)) {
            $('#' + tableID).datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
            editTableID = tableID;
            if (tableID=="outHospNeedDiagGrid"){
	            var columnFields = $('#' + tableID).datagrid('getColumnFields');
		        columnFields.forEach(function (field) {
		            var ed = $('#' + tableID).datagrid('getEditor', { index: editIndex, field: field });
		            if (ed && ed.type && ed.type == 'combogrid') {
		                var desc = $(ed.target).combogrid('getText');
		                var diagTypeIds=$('#' + tableID).datagrid('getRows')[editIndex]["id"];
		                if (diagTypeIds!=""){
		                	$(ed.target).combogrid('setValues',diagTypeIds.toString().split("$"));
		                }else{
			                $(ed.target).combogrid('setValues',"");
			            }
		            }
		        });
	        }
        } else {
            $('#' + tableID).datagrid('selectRow', editIndex);
        }
    }
}
/**
 * @description 初始化表格编辑公共方法
 * @param {*} tableID 
 * @param {*} index 
 */
function initEditGrid(tableID, index) {
    if (editIndex != index) {
        if (endEditing(tableID)) {
            $('#' + tableID).datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
        } else {
            $('#' + tableID).datagrid('selectRow', editIndex);
        }
        notAlertTable=tableID;
    }
    if(notAlertTable&&notAlertTable!=tableID){
	    if (endEditing(notAlertTable)&&endEditing(endEditing(notAlertTable))) {
		     $('#' + tableID).datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editIndex = index;
	    }else {
            $('#' + tableID).datagrid('selectRow', editIndex);
        }
        notAlertTable=tableID;
    }
}
/**
 * @description 结束表格编辑公共方法
 * @param {*} tableID 
 */
function endEditing(tableID) {
    if (editIndex == undefined) { return true }
    if ($('#' + tableID).datagrid('validateRow', editIndex)) {
        var columnFields = $('#' + tableID).datagrid('getColumnFields');
        columnFields.forEach(function (field) {
            var ed = $('#' + tableID).datagrid('getEditor', { index: editIndex, field: field });
            if (ed && ed.type && ed.type == 'combobox') {
                var desc = $(ed.target).combobox('getText');
                $('#' + tableID).datagrid('getRows')[editIndex][field] = desc;
            }
            if (ed && ed.type && ed.type == 'combogrid') {
                var desc = $(ed.target).combogrid('getText');
                $('#' + tableID).datagrid('getRows')[editIndex][field+'Desc'] = desc;
            }
        });
        $('#' + tableID).datagrid('endEdit', editIndex);
        var desc=$('#' + tableID).datagrid('getRows')[editIndex].desc;
        if ((typeof(desc)!="undefined")&&(desc != "")&&(tableID!="transNotControlLocGrid")) {
            $('#' + tableID).datagrid('appendRow', { id: '', desc: '' });
        }
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}

function gridRowOper(funcName, tableID, setName, para) { //btnCls icon-cancel
    var btns = "";
    btns = '<a class="deletecls" href="#" onclick=' + funcName + '(\'' + tableID + '\',\'' + setName + '\',\'' + para + '\')></a>'
    return btns;
}
/**
 * @description 保存转科需开医嘱子类
 */
function saveOutTransSet(setName, value, tableID) {
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'saveOutTransSet',
        SetName: setName,
        Value: value,
		HospID: CONST_HOSPID,
		UserID:session['LOGON.USERID']
    }, function (rtn) {
	    var rtnArr=rtn.toString().split("^");
        if (rtnArr[0] == 0) {
            $.messager.popover({ msg: (((rtnArr[1]=="")&&(rtnArr.length>1))||(rtnArr[1]==undefined))?'保存成功！':rtnArr[1], type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
            loadAuthItemHtml();
        }else{
	        $.messager.popover({ msg: '保存失败！'+rtnArr[0], type: 'error'});
	    }
    });
}
function updateDiagBeforeDisch(oldDiagTypeIds,newDiagTypeIds,tableID){
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'updateDiagBeforeDisch',
        oldDiagTypeIds: oldDiagTypeIds,
        newDiagTypeIds: newDiagTypeIds,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setDiagRepeatFlag(setName, diagId, repeatFlag, tableID){
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setDiagRepeatFlag',
        SetName: setName,
        DiagId: diagId,
        repeatFlag: repeatFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setEmFlag(setName, diagId, EmFlag, tableID) { //wk 增加方法		        	
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setEmFlag',
        SetName: setName,
        DiagId: diagId,
        EmFlag: EmFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setMainDiagFlag(setName, diagId, MainDiagFlag, tableID){
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setMainDiagFlag',
        SetName: setName,
        DiagId: diagId,
        MainDiagFlag: MainDiagFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setTransNeedCare(setName, locId, TransNeedCareFlag, tableID){
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setTransNotControlLocFlag',
        SetName: setName,
        locId: locId,
        value: TransNeedCareFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setTransOrder(setName, locId, TransOrderFlag, tableID){
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setTransNotControlLocFlag',
        SetName: setName,
        locId: locId,
        value: TransOrderFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
/**
 * @description 保存出院医嘱项床位释放时间差
 */
function setDisArcimReleaseTime(setName, arcimId, releaseTime, tableID) { //wk 增加方法
		        	
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setDisArcimReleaseTime',
        SetName: setName,
        ArcimId: arcimId,
        ReleaseTime: releaseTime,
	HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });

}
/**
 * @description 更新转科需开医嘱子类
 */
function updateOutTransSet(tableID, setName, value) {
	if(value){
		$.messager.confirm('确认','确认想要删除记录吗？',function(r){    
		    if (r){    
		        $m({
			        ClassName: GV._CALSSNAME,
			        MethodName: 'updateOutTransSet',
			        SetName: setName,
			        Value: value,
			        HospID: CONST_HOSPID
			    }, function (txtData) {
			        if (txtData == 0) {
			            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
			            $('#' + tableID).datagrid('reload');
			            editIndex = undefined;
			        }
			    });
		    }    
		});  
	}else{
		$.messager.popover({ msg: '未保存的行不能删除！', type: 'alert', timeout: 2000 });
	}    
}
/**
 * @description  删除需开医嘱项配置
 * @param {*} val 
 * @param {*} row 
 * @param {*} index 
 */
function transLocNeedOrderDelBtn(val, row, index) {
	var chekced=$("input[name='transType']:checked");
	if (chekced.length>0){
		var id=chekced[0].id;
		if (id=="transLoc"){
			return gridRowOper('updateOutTransSet', 'transLocNeedOrderGrid', 'arcimBeforeTrans', row.id);
		}else if(id=="transWard"){
			return gridRowOper('updateOutTransSet', 'transLocNeedOrderGrid', 'arcimBeforeTransWard', row.id);
		}
	}
}
function diagBeforeDischDelBtn(val, row, index){
	return gridRowOper('updateOutTransSet', 'outHospNeedDiagGrid', 'diagBeforeDisch', row.id);
}
function transNotControlLocDelBtn(val, row, index){
	return gridRowOper('updateOutTransSet', 'transNotControlLocGrid', 'transNotControlLoc', row.id);
}
/**
 * @description  删除出院医生需开配置
 * @param {*} val 
 * @param {*} row 
 * @param {*} index 
 */
function outHospNeedOrderDelBtn(val, row, index) {
    var outSetObj = getOutHospKeyObj();
    if (row) {
        return gridRowOper('updateOutTransSet', 'outHospNeedOrdeGrid', outSetObj.globalNode, row.id);
    }
    return gridRowOper('updateOutTransSet', 'outHospNeedOrdeGrid', outSetObj.globalNode, '');
}
function nurseCareTypeChange(rec){
	$('#otherNeedCareSetGrid').datagrid("reload");
}
// 初始化出院及召回流程控制
function initOtherNeedCareSetGrid(){
	$('#otherNeedCareSetGrid').datagrid({
		fit:true,
        singleSelect: true,
        url: $URL,
        toolbar: '#DIV_toolbar',
        border:false,
        rownumbers: true,
        //height:165,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: 'getNeedCareOtherSet',
            CareType: $("#nurseCareType").combobox("getValue"), //careType,
            HospID: CONST_HOSPID
        },
        columns: [[
            { field: 'rowId', title: 'id', hidden: true, },
            {
                field: 'careType', title: '操作类型',width:'100',
                formatter: function (value, row) {
                    return row.careTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                        	{ value: 'T', desc: '转科' },
                            { value: 'W', desc: '转病区' },
                            { value: 'D', desc: '出院' },
                            { value: 'DR', desc: '出院召回' },
                            { value: 'CA', desc: '费用调整' },
                            { value: 'ECA', desc: '结束费用调整' }
                        ]
                    }
                },
            },
            {
                field: 'ifCare', title: '流程控制',
                formatter: function (value, row) {
                    return row.ifCareDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                },
            },
            {
                field: 'condition', title: '描述', width:'125', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'conditionDesc', title: '提示内容', width:'150', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'sequence', title: '提示顺序', editor: {
                    type: 'numberbox',
                    options: {
                        precision: 0
                    }
                }
            },
            {
                field: 'className', title: '类名', width:'160',editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'methodName', title: '方法名', width:'160',editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'linkUrl', title: '跳转链接', width:'160',editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'ifShow', title: '启用', width:'40',
                formatter: function (value, row) {
                    return row.ifShowDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                },
            },
            {
                field: 'ApplyPersonType', title: '适用人群', formatter: function (value, row) {
                    return row.ApplyPersonTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        multiple:true,
                        editable:false,
                        rowStyle:'checkbox',
                        data: [
                            //{ value: '', desc: '全部人群' },
                            { value: '1', desc: '成人' },
                            { value: '2', desc: '儿童' },
                            { value: '3', desc: '婴儿' },
                            { value: '4', desc: '新生儿' }
                        ]
                    }
                }
            },
            { field: 'oper', title: '操作', width: 80, formatter: otherNeedCareSetGridOper }
        ]],
        onDblClickRow: function(index, rowData){
	        //editIndex=undefined;
		    if (editNeedCareOtherSetIndex != index) {
		        if (endNeedCareSetEditing()) {
		            $('#otherNeedCareSetGrid').datagrid('selectRow', index)
		                .datagrid('beginEdit', index);
		            editNeedCareOtherSetIndex = index;
		            var ed = $('#needCareSetGrid').datagrid('getEditor', { index: editNeedCareOtherSetIndex, field: "ApplyPersonType" });
		            var ApplyPersonTypes=$('#needCareSetGrid').datagrid('getRows')[editNeedCareOtherSetIndex]["ApplyPersonType"];
		            if (ApplyPersonTypes!=""){
		            	$(ed.target).combobox('setValues',ApplyPersonTypes.toString().split(","));
		            }else{
		                $(ed.target).combobox('setValues',"");
		            }
		        } else {
		            $('#otherNeedCareSetGrid').datagrid('selectRow', editNeedCareOtherSetIndex);
		        }
		    }
	    },
        onLoadSuccess: function (data) {
            $('#' + this.id).datagrid('appendRow', { rowId: '', careType: '', condition: '', conditionDesc: '', ifShow: '', ifCare: '', sequence: '', className: '', methodName: '', careTypeDesc: '', ifShowDesc: '', ifCareDesc: '',ApplyPersonType:''});
        	$('.savecls').linkbutton({ text: '', plain: true, iconCls: 'icon-save' });
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad:function(param){
	        editNeedCareOtherSetIndex=undefined;
	        param.CareType=$("#nurseCareType").combobox("getValue");
	    }
    });
}
var editNeedCareOtherSetIndex = undefined;
function endNeedCareOtherSetEditing() {
    if (editNeedCareOtherSetIndex == undefined) { return true }
    if ($('#otherNeedCareSetGrid').datagrid('validateRow', editNeedCareOtherSetIndex)) {
        var columnFields = $('#otherNeedCareSetGrid').datagrid('getColumnFields');
        columnFields.forEach(function (field) {
            var ed = $('#otherNeedCareSetGrid').datagrid('getEditor', { index: editNeedCareOtherSetIndex, field: field });
            if (ed && ed.type && ed.type == 'combobox') {
                var desc = $(ed.target).combobox('getText');
                $('#otherNeedCareSetGrid').datagrid('getRows')[editNeedCareOtherSetIndex][field + "Desc"] = desc;
            }
        });
        $('#otherNeedCareSetGrid').datagrid('endEdit', editNeedCareOtherSetIndex);
        editNeedCareOtherSetIndex = undefined;
        return true;
    } else {
        return false;
    }
}

function otherNeedCareSetGridOper(val, row, index) {
    var btns = '';
    btns = '<a class="savecls" href="#" onclick=saveotherNeedCareSetGridOper(\'' + index + '\')></a>'
        + '<a class="deletecls" href="#" onclick=delotherNeedCareSetGridOper(\'' + row.rowId + '\')></a>'
    return btns;
}

/**
 * @description 保存护士出入转及召回配置函数
 * @param {*} index 
 */
function saveotherNeedCareSetGridOper(index) {
    endNeedCareOtherSetEditing();
    var rows = $('#otherNeedCareSetGrid').datagrid('getRows');
    var row = rows[index];
    var NullValColumnArr=[];
    var editors=$('#otherNeedCareSetGrid').datagrid('getEditors',index);
    for (var k=0;k<editors.length;k++){
	    var field=editors[k].field;
	    var fieldOpts = $('#otherNeedCareSetGrid').datagrid('getColumnOption',field);
	    if (fieldOpts.editor.options){
			if ((fieldOpts.editor.options.required)&&(!row[field])){
				NullValColumnArr.push(fieldOpts.title);
			}
		}
	}
	if (NullValColumnArr.length>0){
		$.messager.alert("提示",NullValColumnArr.join("、")+"不能为空！");
		return false;
	}
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'saveNeedCareOtherSet',
        RowId:row.rowId,
        CareType: row.careType,
        Condition: row.condition,
		ConditionDesc: row.conditionDesc,
        IfShow: row.ifShow,
        IfCare: row.ifCare,
        Sequence: row.sequence,
        ClassDesc: row.className,
        MethodDesc: row.methodName,
        HospID: CONST_HOSPID,
        linkUrl:row.linkUrl,
        ApplyPersonType:row.ApplyPersonType        
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            $('#otherNeedCareSetGrid').datagrid('reload');
        }
    })
}

function delotherNeedCareSetGridOper(rowId) {
	$.messager.confirm('确认','确认想要删除记录吗？',function(r){    
	    if (r){ 
		    $m({
		        ClassName: GV._CALSSNAME,
		        MethodName: 'delNeedCareOtherSet',
		        RowId: rowId
		    }, function (txtData) {
		        if (txtData == 0) {
		            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
		            $('#otherNeedCareSetGrid').datagrid('reload');
		        }
		    })
		}
    })
}
/**
 * @description 初始化需关注设置列表
 */
function initNeedCareSetGrid() {
    var careType = $('#careTypeBox').combobox('getValue');
    var checkedRadioJObj = $("input[name='ctcptType']:checked");
    var ctcptType = checkedRadioJObj.val();
    $('#needCareSetGrid').datagrid({
        singleSelect: true,
        url: $URL,
        rownumbers: true,
        height:$(window).height() - 527,
        width:$(window).width() - 42,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: 'getNeedCareSet',
            CareType: careType,
            PersonType: ctcptType,
            HospID: CONST_HOSPID
        },
        columns: [[
            { field: 'rowId', title: 'id', hidden: true, },
            {
                field: 'careType', title: '需关注类型',
                formatter: function (value, row) {
                    return row.careTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'D', desc: '出院' },
                            { value: 'T', desc: '转科' },
                            { value: 'W', desc: '转病区' },
                        ]
                    }
                },
            },
            {
                field: 'personType', title: '人员类型',
                formatter: function (value, row) {
                    return row.personTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'NURSE', desc: '护士' },
                            { value: 'DOCTOR', desc: '医生' },
                        ]
                    }
                },
            },
            {
                field: 'condition', title: '需处理情况', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'ifShow', title: '启用',
                formatter: function (value, row) {
                    return row.ifShowDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                },
            },
            {
                field: 'ifCare', title: '流程控制',
                formatter: function (value, row) {
                    return row.ifCareDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ]
                    }
                },
            },
            {
                field: 'sequence', title: '提示顺序', editor: {
                    type: 'numberbox',
                    options: {
                        precision: 0
                    }
                }
            },
            {
                field: 'className', title: '类名', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'methodName', title: '方法名', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'ifEmCare', title: '急诊留观是否显示', formatter: function (value, row) {
                    return row.ifEmCareDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						required: true
                    }
                },
            },
            {
                field: 'ifAllowExec', title: '是否允许执行', formatter: function (value, row) {
                    return row.ifAllowExecDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '是' },
                            { value: 'N', desc: '否' },
                        ],
						required: true
                    }
                },
            },
            {
                field: 'ApplyPersonType', title: '适用人群', formatter: function (value, row) {
                    return row.ApplyPersonTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        multiple:true,
                        editable:false,
                        rowStyle:'checkbox',
                        data: [
                            { value: '1', desc: '成人' },
                            { value: '2', desc: '儿童' },
                            { value: '3', desc: '婴儿' },
                            { value: '4', desc: '新生儿' }
                        ]
                    }
                }
            },
            { field: 'oper', title: '操作', width: 80, formatter: needCareSetGridOper }
        ]],
        onClickRow: onClickNeedCareSetRow,
        onDblClickRow: onDblClickNeedCareSetRow,
        onLoadSuccess: function (data) {
            $('#' + this.id).datagrid('appendRow', { rowId: '', careType: '', personType: '', condition: '', ifShow: '', ifCare: '', sequence: '', className: '', methodName: '', ifEmCare: '', careTypeDesc: '', personTypeDesc: '', ifShowDesc: '', ifCareDesc: '', ifEmCareDesc: '',ApplyPersonType:'' });
        	$('.savecls').linkbutton({ text: '', plain: true, iconCls: 'icon-save' });
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
}
function onClickNeedCareSetRow(index, row) {
	editIndex=undefined;
    endNeedCareSetEditing();
    var tables = ['notAlertOrderLocGrid','notAlertRecLocGrid', 'notAlertOrderCatGrid', 'notAlertArcCatGrid', 'notAlertArcItmGrid']
    if (row.rowId && row.rowId != '') {
        tables.forEach(function (tab) {
			endEditing(tab);
            initNotAlertGrid(row.rowId, tab);
        });
    } else if(GV.notAlertGridInitedFlag ==1) {
        tables.forEach(function (tab) {
			endEditing(tab);
            $('#' + tab).datagrid('loadData', { total: 0, rows: [] });
        });
    }

}
function onDblClickNeedCareSetRow(index) {
	editIndex=undefined;
    if (editNeedCareSetIndex != index) {
        if (endNeedCareSetEditing()) {
            $('#needCareSetGrid').datagrid('selectRow', index)
                .datagrid('beginEdit', index);
            editNeedCareSetIndex = index;
            var ed = $('#needCareSetGrid').datagrid('getEditor', { index: editNeedCareSetIndex, field: "ApplyPersonType" });
            var ApplyPersonTypes=$('#needCareSetGrid').datagrid('getRows')[editNeedCareSetIndex]["ApplyPersonType"];
            if (ApplyPersonTypes!=""){
            	$(ed.target).combobox('setValues',ApplyPersonTypes.toString().split(","));
            }else{
                $(ed.target).combobox('setValues',"");
            }
        } else {
            $('#needCareSetGrid').datagrid('selectRow', editNeedCareSetIndex);
        }
    }
}

var editNeedCareSetIndex = undefined;
function endNeedCareSetEditing() {
    if (editNeedCareSetIndex == undefined) { return true }
    if ($('#needCareSetGrid').datagrid('validateRow', editNeedCareSetIndex)) {
        var columnFields = $('#needCareSetGrid').datagrid('getColumnFields');
        columnFields.forEach(function (field) {
            var ed = $('#needCareSetGrid').datagrid('getEditor', { index: editNeedCareSetIndex, field: field });
            if (ed && ed.type && ed.type == 'combobox') {
                var desc = $(ed.target).combobox('getText');
                $('#needCareSetGrid').datagrid('getRows')[editNeedCareSetIndex][field + "Desc"] = desc;
            }
        });
        $('#needCareSetGrid').datagrid('endEdit', editNeedCareSetIndex);
        editNeedCareSetIndex = undefined;
        return true;
    } else {
	    $('#needCareSetGrid').datagrid('endEdit', editNeedCareSetIndex).datagrid('rejectChanges');
        return false;
    }
}

function needCareSetGridOper(val, row, index) {
    var btns = '';
    btns = '<a class="savecls" href="#" onclick=saveNeedCareSetGridOper(\'' + index + '\')></a>'
        + '<a class="deletecls" href="#" onclick=delNeedCareSetGridOper(\'' + row.rowId + '\')></a>'
    return btns;
}

/**
 * @description 保存需关注配置函数
 * @param {*} index 
 */
function saveNeedCareSetGridOper(index) {
    if (!endNeedCareSetEditing()){
	    $.messager.popover({ msg: '行数据验证失败！请核实维护数据！', type: 'error'});
	    return false;
	}
    var rows = $('#needCareSetGrid').datagrid('getRows');
    var row = rows[index];
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'saveNeedCareSet',
        RowId:row.rowId,
        CareType: row.careType,
        PersonType: row.personType,
        Condition: row.condition,
        IfShow: row.ifShow,
        IfCare: row.ifCare,
        Sequence: row.sequence,
        ClassDesc: row.className,
        MethodDesc: row.methodName,
        IfEmCare: row.ifEmCare,
        ApplyPersonType: row.ApplyPersonType,
        ifAllowExec:row.ifAllowExec,
        HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            $('#needCareSetGrid').datagrid('reload');
        }
    })
}

function delNeedCareSetGridOper(rowId) {
	$.messager.confirm('确认','确认想要删除记录吗？',function(r){    
	    if (r){ 
		    $m({
		        ClassName: GV._CALSSNAME,
		        MethodName: 'delNeedCareSet',
		        RowId: rowId
		    }, function (txtData) {
		        if (txtData == 0) {
		            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
		            $('#needCareSetGrid').datagrid('reload');
		        }
		    })
		}
    })
}

function getNotAlertObj(tableID) {
    var obj = {};
    switch (tableID) {
        case 'notAlertOrderLocGrid': case 'notAlertRecLocGrid':
            obj = {
                combogrid: {
                    getMethod: 'getLocs',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'notAlert',
                titleDesc: '科室',
                operFormatter: notAlertDelBtn
            };
            break;
        case 'notAlertOrderCatGrid':
            obj = {
                combogrid: {
                    getMethod: 'getOrdCat',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'notAlert',
                titleDesc: '医嘱大类',
                operFormatter: notAlertDelBtn
            };
            break;
        case 'notAlertArcCatGrid':
            obj = {
                combogrid: {
                    getMethod: 'getArcItmChart',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'notAlert',
                titleDesc: '医嘱子类',
                operFormatter: notAlertDelBtn
            };
            break;
        case 'notAlertArcItmGrid':
            obj = {
                combogrid: {
                    getMethod: 'getArcim',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'notAlert',
                titleDesc: '医嘱项',
                operFormatter: notAlertDelBtn
            };
            break;
        case 'transNotControlLoc':
            obj = GV.transNotControlLocOBJ;
            break;
    }

    return obj;
}
var notAlertTable = undefined;
/**
 * @description 初始化不提示设置列表
 */
function initNotAlertGrid(conditionID, tableID) {
    var setObj = getNotAlertObj(tableID);
    $('#' + tableID).datagrid({
	    fitColumns:true,
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CALSSNAME,
            MethodName: 'getNotAlert',
            ConditionID: conditionID,
            TableID: tableID
        },
        columns: initNotAlertGridColumn(tableID, setObj),
        onClickRow: function (index) {
            if (notAlertTable&&notAlertTable != tableID) {
                endEditing(notAlertTable);
                //notAlertTable = tableID;
            }
            var rows = $('#' + tableID).datagrid('getRows');
            if ((index + 1) == rows.length) {
                initEditGrid(tableID, index);
            }
            notAlertTable = tableID;
        },
        onLoadSuccess: function (data) {
           $('#' + tableID).datagrid('appendRow', { id: '', desc: '' });
	       $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        }
    });
    GV.notAlertGridInitedFlag=1;
}

function initNotAlertGridColumn(tableID, setObj) {
	if (tableID=="transNotControlLocGrid"){
		return [[
	        {
	            field: setObj.fieldName,
	            title: setObj.titleDesc,
	            width: setObj.globalNode=="transNotControlLoc" ? 160 : 260,
	            rowspan:2,
	            formatter: function (value, row) {
	                return setObj.globalNode=="transNotControlLoc" ? row[setObj.fieldName] : row[setObj.fieldName+'Desc'];
	            },
	            editor: {
	                type: 'combogrid',
	                options: {
	                    mode: 'remote',
	                    delay: 500,
	                    panelWidth: 330,
	                    panelHeight: 200,
	                    idField: setObj.combogrid.valueField,
	                    textField: setObj.combogrid.textField,
	                    displayMsg: '',
	                    url: $URL,
	                    queryParams: {
	                        ClassName: GV._CALSSNAME,
	                        QueryName: setObj.combogrid.getMethod,
	                        HospID: CONST_HOSPID,
	                        ConfigName:'Nur_IP_NeedCareOrderSet',
	                        locAdmTypes:"I"
	                    },
	                    pagination: true,
	                    pageSize: 10,
	                    columns: [[
	                        { field: setObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
	                        { field: setObj.combogrid.textField, title: setObj.titleDesc, width: 300 }
	                    ]],

	                    onSelect: function (rowIndex, rowData) {
	                        var arcimBeforeTrans = $('#' + tableID).datagrid('getData');
	                        var ifExit =false;
	                         arcimBeforeTrans.rows.forEach(function (row) {	              
		                        if(row.id == rowData.id){
	                            	ifExit=true ;
	                            	return false;
		                        }
	                        })
	                        if (!ifExit) {
		                        endEditing(tableID);
	                            if(setObj.globalNode=="transNotControlLoc"){ // 转入不需要相关控制科室
		                            //var wardObj=$('#' + tableID).datagrid('getEditor', {index:editIndex,field:setObj.transWardFieldName});
									//wardObj.target.combobox('reload');
									saveOutTransSet(setObj.globalNode, rowData.id, tableID);
		                        }else{
			                        saveNotAlertSet(tableID, rowData);
			                    }  
	                        }
	                        else {
	                            $.messager.popover({ msg: setObj.titleDesc + '已存在！', type: 'alert', timeout: 2000 });
	                        }
	                    }
	                }
	            },
	        },
	        {
	            field: setObj.transWardFieldName,
	            title: setObj.transWardTitleDesc,
	            width: 160,
	            rowspan:2,
	            hidden:!setObj.transWardGlobalNode,
	            formatter: function (value, row) {
	                return row[setObj.transWardFieldName+'Desc'];
	            },
	            editor: {
	                type: 'combobox',
	                options: {
	                    url:$URL+"?ClassName=Nur.NIS.Service.Base.Loc&MethodName=GetTransLocLinkWards",
	                    valueField: "wardID",
	                    textField: "wardDesc",
	                    multiple:true,
	                    rowStyle:'checkbox',
	                    onBeforeLoad:function(param){
		                    var rows=$('#' + tableID).datagrid("selectRow",editIndex).datagrid("getSelected");
							param = $.extend(param,{locID:rows.id});
		                },
	                    onHidePanel:function(){
		                    var val=$(this).combobox("getValues").join("^");
			                var rowData=$('#' + tableID).datagrid('getSelected');
							 if(setObj.transWardGlobalNode){
								if(rowData.id){
									setTransNeedCare(setObj.transWardGlobalNode, rowData.id, val,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
							}
		                },
		                filter: function(q, row){
							return (row["wardDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onLoadSuccess:function(){
							 var rowData=$('#' + tableID).datagrid('getSelected');
							 var transNotControlWard=rowData.transNotControlWard;
							 if ((transNotControlWard)&&(transNotControlWard!="")){
								 $(this).combobox("setValues",transNotControlWard.split("^"));
							 }
						}
	                }
	            },
	        },
	        {title:'转入控制',field:'', align:'left',halign:'center',colspan:2},
	        {title:'转出控制',field:'', align:'left',halign:'center',colspan:2},
		    { field: setObj.transBackNeedCareFieldName?setObj.transBackNeedCareFieldName:'transBackNeedCareFlag',
	          title: setObj.transBackNeedCareTitleDesc?setObj.transBackNeedCareTitleDesc:'回转不控制需关注', 
	          width: 125, 
	          rowspan:2,
	          hidden:!setObj.transBackNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transBackNeedCareGlobalNode){
									if(rowData.id){
										setTransOrder(setObj.transBackNeedCareGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	                }
		    },
	        { field: 'oper', title: '操作', width: 40, rowspan:2,formatter: setObj.operFormatter }
	    ],[
	    	{ field: setObj.transNeedCareFieldName?setObj.transNeedCareFieldName:'transNeedCare',  ///wk 增加列
	          title: setObj.transNeedCareTitleDesc?setObj.transNeedCareTitleDesc:'不控制需关注', 
	          width: 100, 
	          hidden:!setObj.transNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transNeedCareGlobalNode){
									if(rowData.id){
										setTransNeedCare(setObj.transNeedCareGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	                }
		    },
		    { field: setObj.transOrderFieldName?setObj.transOrderFieldName:'transOrder',  ///wk 增加列
	          title: setObj.transOrderTitleDesc?setObj.transOrderTitleDesc:'不必开立转科医嘱', 
	          width: 100, 
	          hidden:!setObj.transOrderGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transOrderGlobalNode){
									if(rowData.id){
										setTransOrder(setObj.transOrderGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	              }
		    },
		    { field: 'transOutNeedCareFlag',
	          title: '不控制需关注', 
	          width: 100, 
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								if(rowData.id){
									setTransNeedCare("transOutNeedCareFlag", rowData.id, rec.value,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
							}
	                    }
	                }
		    },
		    { field: 'transOutOrderFlag',  ///wk 增加列
	          title: '不必开立医嘱', 
	          width: 100, 
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								if(rowData.id){
									setTransOrder("transOutOrderFlag", rowData.id, rec.value,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
							}
	                    }
	              }
		    }
	    ]];
	}else{
		return [[
	        {
	            field: setObj.fieldName,
	            title: setObj.titleDesc,
	            width: setObj.globalNode=="transNotControlLoc" ? 160 : 260,
	            formatter: function (value, row) {
	                return setObj.globalNode=="transNotControlLoc" ? row[setObj.fieldName] : row[setObj.fieldName+'Desc'];
	            },
	            editor: {
	                type: 'combogrid',
	                options: {
	                    mode: 'remote',
	                    delay: 500,
	                    panelWidth: 330,
	                    panelHeight: 200,
	                    idField: setObj.combogrid.valueField,
	                    textField: setObj.combogrid.textField,
	                    displayMsg: '',
	                    url: $URL,
	                    queryParams: {
	                        ClassName: GV._CALSSNAME,
	                        QueryName: setObj.combogrid.getMethod,
	                        HospID: CONST_HOSPID,
	                        ConfigName:'Nur_IP_NeedCareOrderSet',
	                        locAdmTypes:"I"
	                    },
	                    pagination: true,
	                    pageSize: 10,
	                    columns: [[
	                        { field: setObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
	                        { field: setObj.combogrid.textField, title: setObj.titleDesc, width: 300 }
	                    ]],

	                    onSelect: function (rowIndex, rowData) {
	                        var arcimBeforeTrans = $('#' + tableID).datagrid('getData');
	                        var ifExit =false;
	                         arcimBeforeTrans.rows.forEach(function (row) {	              
		                        if(row.id == rowData.id){
	                            	ifExit=true ;
	                            	return false;
		                        }
	                        })
	                        if (!ifExit) {
		                        endEditing(tableID);
	                            if(setObj.globalNode=="transNotControlLoc"){ // 转入不需要相关控制科室
		                            //var wardObj=$('#' + tableID).datagrid('getEditor', {index:editIndex,field:setObj.transWardFieldName});
									//wardObj.target.combobox('reload');
									saveOutTransSet(setObj.globalNode, rowData.id, tableID);
		                        }else{
			                        saveNotAlertSet(tableID, rowData);
			                    }  
	                        }
	                        else {
	                            $.messager.popover({ msg: setObj.titleDesc + '已存在！', type: 'alert', timeout: 2000 });
	                        }
	                    }
	                }
	            },
	        },
	        {
	            field: setObj.transWardFieldName,
	            title: setObj.transWardTitleDesc,
	            width: 160,
	            hidden:!setObj.transWardGlobalNode,
	            formatter: function (value, row) {
	                return row[setObj.transWardFieldName+'Desc'];
	            },
	            editor: {
	                type: 'combobox',
	                options: {
	                    url:$URL+"?ClassName=Nur.NIS.Service.Base.Loc&MethodName=GetTransLocLinkWards",
	                    valueField: "wardID",
	                    textField: "wardDesc",
	                    multiple:true,
	                    rowStyle:'checkbox',
	                    onBeforeLoad:function(param){
		                    var rows=$('#' + tableID).datagrid("selectRow",editIndex).datagrid("getSelected");
							param = $.extend(param,{locID:rows.id});
		                },
	                    onHidePanel:function(){
		                    var val=$(this).combobox("getValues").join("^");
			                var rowData=$('#' + tableID).datagrid('getSelected');
							 if(setObj.transWardGlobalNode){
								if(rowData.id){
									setTransNeedCare(setObj.transWardGlobalNode, rowData.id, val,tableID);
								}else{
									$('#' + tableID).datagrid('reload');
									editIndex = undefined;
								}
							}
		                },
		                filter: function(q, row){
							return (row["wardDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["searchCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
						},
						onLoadSuccess:function(){
							 var rowData=$('#' + tableID).datagrid('getSelected');
							 var transNotControlWard=rowData.transNotControlWard;
							 if ((transNotControlWard)&&(transNotControlWard!="")){
								 $(this).combobox("setValues",transNotControlWard.split("^"));
							 }
						}
	                }
	            },
	        },
	        { field: setObj.transNeedCareFieldName?setObj.transNeedCareFieldName:'transNeedCare',  ///wk 增加列
	          title: setObj.transNeedCareTitleDesc?setObj.transNeedCareTitleDesc:'不控制需关注', 
	          width: 100, 
	          hidden:!setObj.transNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transNeedCareGlobalNode){
									if(rowData.id){
										setTransNeedCare(setObj.transNeedCareGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	                }
		    },
		    { field: setObj.transOrderFieldName?setObj.transOrderFieldName:'transOrder',  ///wk 增加列
	          title: setObj.transOrderTitleDesc?setObj.transOrderTitleDesc:'不必开立转科医嘱', 
	          width: 100, 
	          hidden:!setObj.transOrderGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transOrderGlobalNode){
									if(rowData.id){
										setTransOrder(setObj.transOrderGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	                }
		    },
		    { field: setObj.transBackNeedCareFieldName?setObj.transBackNeedCareFieldName:'transBackNeedCareFlag',
	          title: setObj.transBackNeedCareTitleDesc?setObj.transBackNeedCareTitleDesc:'回转不控制需关注', 
	          width: 125, 
	          hidden:!setObj.transBackNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '是' },
	                            { value: 'N', desc: '否' },
	                        ],
							onSelect: function (rec) {
								var rowData=$('#' + tableID).datagrid('getSelected');
								 if(setObj.transBackNeedCareGlobalNode){
									if(rowData.id){
										setTransOrder(setObj.transBackNeedCareGlobalNode, rowData.id, rec.value,tableID);
									}else{
										$('#' + tableID).datagrid('reload');
										editIndex = undefined;
									}
		        	
								}
							}
	                    }
	                }
		    },
	        { field: 'oper', title: '操作', width: 40, formatter: setObj.operFormatter }
	    ]];
	}
}

function saveNotAlertSet(tableID, rowData) {
    var selRow = $('#needCareSetGrid').datagrid('getSelected');
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'saveNotAlertSet',
        ConditionID: selRow.rowId,
        TableID: tableID,
        NotAlertStr: rowData.id
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
            $('#' + tableID).datagrid('reload');
            editIndex = undefined;
        }else{
	        $.messager.popover({ msg: txtData, type: 'error', timeout: 2000 });
	         
	        }
    });
}

function notAlertDelBtn(val, row, index) {
    var btns = '';
    btns = '<a class="deletecls" href="#" onclick=delNotAlertGridOper(\'' + row.id + '\',\'' + row.tableID + '\')></a>'
    return btns;
}

function delNotAlertGridOper(rowId, tableID) {
	if(rowId){
		$.messager.confirm('确认','确认想要删除记录吗？',function(r){    
		    if (r){ 
			    $m({
			        ClassName: GV._CALSSNAME,
			        MethodName: 'delNotAlertSet',
			        RowID: rowId,
			    }, function (txtData) {
			        if (txtData == 0) {
			            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 2000 });
			            $('#' + tableID).datagrid('reload');
			            editIndex = undefined;
			        }
			    });
			}
	    })
	}else{
		$.messager.popover({ msg: '未保存的行不能删除！', type: 'alert', timeout: 2000 });
	}    
}

function checkChangeEvent(e, val) {
    var checkID = e.currentTarget.id;
    var globalNode = checkID.replace('Check', '')
    if (val) {
        saveOutTransSet(globalNode, "Y");
    }
    else { saveOutTransSet(globalNode, "N"); }
}
function clearBedControlClick(){
	$("input[name='transWardBedControl']").radio({
	    onChecked:function(e,value){
		   
		}
	 });
}
function initBedControlClick(){
	$("input[name='transWardBedControl']").radio({
	    onChecked:function(e,value){
		    var val = e.currentTarget.value;
		    saveOutTransSet("transWardBedControl", val);
		}
	 });
}
function initCheckBoxVal() {
	clearBedControlClick();
	
    var checkboxs = ['ifGetAdmDateTimeByBedCheck', 'ifGetDischgDateTimeByDocCheck', 'ifAlertLonOldCheck', 'ifTakeDisDrugCheck','ifActiveJustODCheck','ifUpdateDispWardAfterTransWard','ifNotAlertNurseNormOrdCheck','ifNotAlertNurseLongOrdCheck','transWardBedControl']
    checkboxs.forEach(function (checkbox) {
        var globalNode = checkbox.replace('Check', '');
        $m({
            ClassName: GV._CALSSNAME,
            MethodName: 'getSetGlobalVal',
            SetType: 'Disch',
            Node: globalNode,
            HospID:CONST_HOSPID
        }, function (txtData) {
			/*if (globalNode=="nurDiaChargeTime"){
				$("#nurDiaChargeTime").combobox("setValue",txtData==""?"EstimDischargeDateTime":txtData);
			}else */if(globalNode=="transWardBedControl"){
				$("input[name='transWardBedControl']").radio("uncheck");
				if(txtData===""){
					$($("input[name='transWardBedControl']")[2]).radio("check");
				}else if (txtData==0){
					$($("input[name='transWardBedControl']")[0]).radio("check");
				}else if(txtData==1){
					$($("input[name='transWardBedControl']")[1]).radio("check");
				}
				initBedControlClick();
			}else{
	            if (txtData == "Y") {
	                $HUI.checkbox('#' + checkbox, { checked: true, onCheckChange: checkChangeEvent })
	            } else {
	                $HUI.checkbox('#' + checkbox, { checked: false, onCheckChange: checkChangeEvent })
	            }
            }
        })
    });
    loadDisChargeDateTimeSet();
}

/*function initToolTip(index){
	var tips="指床位释放日期和出院/死亡医嘱开始日期的时间差，如不配置，则开医嘱不释放床位；<br>如配置为0，按医嘱开始日期释放床位；如配置为1则释放医嘱开始日期第二天的床位。";
	if(index==3){
		tips="指办理出院日期和出院/死亡医嘱开始日期的时间差，如不配置，则开医嘱不提示医嘱超期；<br>如配置为0，按医嘱开始日期办理出院；如配置为1则表示开立出院医嘱1天内办理出院，。"
	}
	$('#main > div.panel.layout-panel.layout-panel-west.layout-split-west > div > div > div.hisui-panel.panel-noscroll.panel-body > div > div.panel.layout-panel.layout-panel-center.layout-split-center > div > div > div.datagrid-wrap.panel-body > div > div.datagrid-view2 > div.datagrid-header > div > table > tbody > tr > td:nth-child('+index+')').tooltip({
		position: 'right',
		content: '<span style="color:red">'+tips+'</span>',
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#FFF',
				borderColor: '#666'
			});
		}
	});
}*/

// 保存出院护士执行权限
function saveDischNurExcute(){
	var orderSearchFlag=$("#cb1").radio('getValue') ? "Y" : "N";
	var orderExcuteFlag=$("#cb2").radio('getValue') ? "Y" : "N";
	var orderCancelFlag=$("#cb3").radio('getValue') ? "Y" : "N";
	var orderPrintFlag=$("#cb4").radio('getValue') ? "Y" : "N";
	var orderFlag=orderSearchFlag+"^"+orderExcuteFlag+"^"+orderCancelFlag+"^"+orderPrintFlag;
	saveOutTransSet("dischNurExcute", orderFlag, "");
}
// 获取出院护士执行权限
function initDischNurExcute(){
	$('#cb1,#cb2,#cb3,#cb4').checkbox({
	    onCheckChange:function(e,value){
		}
	})
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'GetDischNurExcute',
        HospID:CONST_HOSPID
    }, function (txtData) {
	    if(txtData){
		    var arr=txtData.split("^");
		    arr.forEach(function(val,index){
			  	if(val=="Y"){
			 		$("#cb"+(index+1)).checkbox("check");	
			 	}else{	
				 	$("#cb"+(index+1)).checkbox("uncheck");	
				}
			});		    
		}
		$('#cb1,#cb2,#cb3,#cb4').checkbox({
		    onCheckChange:function(e,value){
			    saveDischNurExcute();
			}
		})
    })	
}
//保存出院召回限制天数
function saveRecallDayLimit(){
	var data=$("#recallDayLimit").combobox("getData");
	var val=$("#recallDayLimit").combobox("getValue");
	if (val==undefined) val="";
	if (val!=""){
		var index=$.hisui.indexOfArray(data,"value",val);
		if (index<0){
			$.messager.popover({ msg: '请在下拉框中选择数据！', type: 'error'});
			return false;
		}
	}
	saveOutTransSet("recallLimitDays", val, "");
}
//获取出院召回限制天数
function initRecallDayLimit(){
	$("#recallDayLimit").combobox({
		mode:'remote',
		onHidePanel:function(){}
	});
	$m({
        ClassName: GV._CALSSNAME,
        MethodName: 'GetRecallLimitDays',
        HospID:CONST_HOSPID
    }, function (value) {
		$("#recallDayLimit").combobox("setValue",value);
		$("#recallDayLimit").combobox({
			onHidePanel:saveRecallDayLimit
		});	    
    })	
}
function nurDiaChargeTimeHandler(rec){
	var checkedRadioJObj = $("input[name='disChargeDateTime']:checked");
    var ctcptType = checkedRadioJObj.val();
	saveOutTransSet(checkedRadioJObj.val(), rec.value);
}
function loadDisChargeDateTimeSet(){
    var checkedRadioJObj = $("input[name='disChargeDateTime']:checked");
	var globalNode = checkedRadioJObj.val();
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'getSetGlobalVal',
        SetType: 'Disch',
        Node: globalNode,
        HospID:CONST_HOSPID
    },function(txtData){
        $("#nurDiaChargeTime").combobox("setValue",txtData==""?"EstimDischargeDateTime":txtData);
    })
}
function loadAuthItemHtml(){
    $cm({ClassName:"Nur.HISUI.NeedCareOrderSet",MethodName:"getAuthItem"},function(dataArr){
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