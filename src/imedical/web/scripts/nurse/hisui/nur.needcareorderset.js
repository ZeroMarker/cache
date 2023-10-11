/**
 * @name nur.needcareorderset.js
 * @author SongChao
 * @description ����ת�����ע����
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
        titleDesc: 'ҽ����',
        globalNode: 'dischargeNeedArcim',
        operFormatter: outHospNeedOrderDelBtn,
        relBedFieldName:'releaseBedTime', //wk ����һ�е�����
        relBedTitleDesc:'��λ�ͷ����ڲ�',
        relBedGlobalNode:'releaseBedTime',
        dischargeHandleFieldName:'dischargeHandleTime', //wk ����һ�е�����
        dischargeHandleTitleDesc:'�����Ժ���ڲ�',
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
        titleDesc: 'ҽ����',
        globalNode: 'deathDischargeNeedArcim',
        operFormatter: outHospNeedOrderDelBtn,
        relBedFieldName:'releaseBedTime', //wk ����һ�е�����
        relBedTitleDesc:'��λ�ͷ����ڲ�',
        relBedGlobalNode:'releaseBedTime',
        deathHandleFieldName:'deathHandleTime',
        deathHandleTitleDesc:'����������д����(��)',
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
        titleDesc: '�������',
        globalNode: 'diagBeforeDisch',
        operFormatter: diagBeforeDischDelBtn,
		EmFlagFieldName:'EmFlag', ///wk ����һ�е�����
        EmFlagTitleDesc:'������Ч',
        EmFlagGlobalNode:'EmFlag',
        MainDiagFlagFieldName:'MainDiagFlag', 
        MainDiagFlagTitleDesc:'�Ƿ������',
        MainDiagFlagGlobalNode:'MainDiagFlag',
        DiagRepeatFlagFieldName:'DiagRepeatFlag', 
        DiagRepeatFlagTitleDesc:'�Ƿ��ظ�',
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
        titleDesc: '����',
        globalNode: 'transNotControlLoc',
        operFormatter: transNotControlLocDelBtn,
        transNeedCareFieldName:'transNeedCareFlag',
        transNeedCareTitleDesc:'���������ע',
        transNeedCareGlobalNode:'transNeedCareFlag',
        transOrderFieldName:'transOrderFlag', 
        transOrderTitleDesc:'���ؿ���ҽ��',
        transOrderGlobalNode:'transOrderFlag',
        transBackNeedCareFieldName:'transBackNeedCareFlag', 
        transBackNeedCareTitleDesc:'��ת���������ע',
        transBackNeedCareGlobalNode:'transBackNeedCareFlag',
        transWardFieldName:'transNotControlWard', 
        transWardTitleDesc:'����',
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
        content:"��λ�ͷ����ڲָ��λ�ͷ����ںͳ�Ժ/����ҽ����ʼ���ڵ�ʱ��<br>&nbsp&nbsp&nbsp&nbsp�����ã���ҽ�����ͷŴ�λ��<br>&nbsp&nbsp&nbsp&nbsp����0����ҽ����ʼ�����ͷŴ�λ��<br>&nbsp&nbsp&nbsp&nbsp����N(N >= 1)�����ͷ�ҽ����ʼ���ڵ�(N+1)��Ĵ�λ��<br><br>"+
		        "�����Ժ���ڲָ�����Ժ���ںͳ�Ժ/����ҽ����ʼ���ڵ�ʱ��<br>&nbsp&nbsp&nbsp&nbsp������:  ��ҽ������ʾҽ�����ڣ�<br>&nbsp&nbsp&nbsp&nbsp����0����ҽ����ʼ���ڰ����Ժ��<br>&nbsp&nbsp&nbsp&nbsp����N(N >= 1)��������Ժҽ��N���ڰ����Ժ,δ����N���ڳ�Ժ�����עҳ���Ժҽ����ʾ���ڡ�<br><br>"+
		        "����������д���ƣ�ָ��������ҽ��ʱ���������ڿ���д�����ڷ�Χ��<br>&nbsp&nbsp&nbsp&nbsp������:  ���ڻ���ڵ��죻<br>&nbsp&nbsp&nbsp&nbsp����N(N>=0)���������ڷ�ΧΪ���ڻ���ڵ�������-N�����ڻ���ڵ��졣"
    }));
    
    $('#nurDiaChargeTime').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"Ԥ�Ƴ�Ժʱ�䣺ҽ�������ĳ�Ժҽ����ʼ����ʱ�䡣<br>"+
		        "��ǰʱ�䣺��ʿ������Ժ�ĵ�ǰ����ʱ�䡣<br>"+
		        "��Ժҽ��ִ��ʱ�䣺��ʿִ�г�Ժҽ������ʱ�䡣"
    }));
    $('#ifGetAdmDateTimeByBedCheck').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"��������Ŀ���ɸ��ģ�<br>"+
		        "�����߰�����Ժǰ��ѡȡ�ִ�ʱ�䣬�ڷִ�ǰȡ����ѡ���ᵼ�»��߷ִ�����Ժʱ��Ϊ�ա�<br>"
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
            { text: '��Ժҽ���迪ҽ��', id: 'dischargeNeedArcim', selected: true },
            { text: '������Ժҽ���迪ҽ��', id: 'deathDischargeNeedArcim' },
            { text: '��Ժǰҽ�����뿪���������', id: 'diagBeforeDisch' },
            { text: '��Ժ��ʿִ�п���', id: 'dischNurExcute' },
            { text: 'ת�벻��Ҫ��ؿ��ƿ���', id: 'transNotControlLoc' }            
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
��ʼ����Ժǰ�迪��������б�
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
            if(outSetObj.relBedFieldName||outSetObj.EmFlagFieldName){ //wk ȥ�����ƣ���Ժҽ���б����ɱ༭
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
 * @description ��ʼ����Ժ�����б�
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
            if(outSetObj.relBedFieldName||outSetObj.EmFlagFieldName){ //wk ȥ�����ƣ���Ժҽ���б����ɱ༭
	            initOtherEditGrid(this.id, index);
	        }else{
		        if ((index + 1) == rows.length) { 
                	initOtherEditGrid(this.id, index);
            	}
		    }
            
        },
        onAfterEdit:function (rowIndex, rowData, changes){ //wk �༭�󱣴�
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
	                        var rows = $('#' + tableID).datagrid('getRows');//wk  �Ѿ����������ѡ��ҽ������������±��棬����ᵼ���¼�һ��
	                        if ((editIndex + 1) >= rows.length) { 
                				endEditing(tableID);
                            	saveOutTransSet(outSetObj.globalNode, rowData.id, tableID);
            				}else{
	            				$('#' + tableID).datagrid('reload');
                				editIndex = undefined;
	            			}
                        }else {
                            $.messager.popover({ msg: outSetObj.titleDesc + '�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
                        }
                    },
                    onHidePanel:function(){
	                    if (outSetObj.fieldName=="dtypDesc") {
							var val=$(this).combogrid("getValues").join("$");
							if (val==""){
								$.messager.popover({ msg: "��ѡ��"+outSetObj.titleDesc, type: 'error' });
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
	                            $.messager.popover({ msg: outSetObj.titleDesc + '�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
	                        }
						}
	                }
                }
            },
        },
        
        { 
          id:'releaseBedTime',
          field: outSetObj.relBedFieldName?outSetObj.relBedFieldName:'releaseBedTime',  //wk ������
          title: outSetObj.relBedTitleDesc?outSetObj.relBedTitleDesc:'��λ�ͷ�ʱ���', 
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
          field: outSetObj.dischargeHandleFieldName?outSetObj.dischargeHandleFieldName:'dischargeHandleTime',  //wk ������
          title: outSetObj.dischargeHandleTitleDesc?outSetObj.dischargeHandleTitleDesc:'�����Ժ���ڲ�', 
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
          title: outSetObj.deathHandleTitleDesc?outSetObj.deathHandleTitleDesc:'����������д����(��)', 
          width: 150, 
          hidden:!outSetObj.deathHandleFieldName,
          editor: {
	        type: 'numberbox', 
	        options: { 
	        	precision: 0 
	        	
	        }
	      }
	    }, 		
		{ field: outSetObj.MainDiagFlagFieldName?outSetObj.MainDiagFlagFieldName:'MainDiagFlag',  ///wk ������
          title: outSetObj.MainDiagFlagTitleDesc?outSetObj.MainDiagFlagTitleDesc:'�Ƿ������', 
          width: 115, 
          hidden:!outSetObj.MainDiagFlagGlobalNode,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
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
		{ field: outSetObj.EmFlagFieldName?outSetObj.EmFlagFieldName:'EmFlag',  ///wk ������
          title: outSetObj.EmFlagTitleDesc?outSetObj.EmFlagTitleDesc:'������Ч', 
          width: 115, 
          hidden:!outSetObj.EmFlagFieldName,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
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
          title: outSetObj.DiagRepeatFlagTitleDesc?outSetObj.DiagRepeatFlagTitleDesc:'�Ƿ��ظ�', 
          width: 115, 
          hidden:!outSetObj.DiagRepeatFlagFieldName,
		  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
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
        { field: 'oper', title: '����', width: 40, formatter: outSetObj.operFormatter }
    ]];
}
/**
 * @description ��ʼ��ת�Ʋ�����ƿ��ұ��
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
 * @description ��ʼ��ת���迪ҽ��������
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
                field: 'arcItemDesc', title: 'ҽ������', width: 412,
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
                                $.messager.popover({ msg: 'ҽ�������Ѵ��ڣ�', type: 'alert', timeout: 2000 });
                            }

                        }
                    }
                },
            },
            { field: 'oper', title: '����', width: 40, formatter: transLocNeedOrderDelBtn }
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
 * @description ��ʼ�����༭��������
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
 * @description �������༭��������
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
 * @description ����ת���迪ҽ������
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
            $.messager.popover({ msg: (((rtnArr[1]=="")&&(rtnArr.length>1))||(rtnArr[1]==undefined))?'����ɹ���':rtnArr[1], type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
            loadAuthItemHtml();
        }else{
	        $.messager.popover({ msg: '����ʧ�ܣ�'+rtnArr[0], type: 'error'});
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
function setEmFlag(setName, diagId, EmFlag, tableID) { //wk ���ӷ���		        	
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setEmFlag',
        SetName: setName,
        DiagId: diagId,
        EmFlag: EmFlag,
		HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });
}
/**
 * @description �����Ժҽ���λ�ͷ�ʱ���
 */
function setDisArcimReleaseTime(setName, arcimId, releaseTime, tableID) { //wk ���ӷ���
		        	
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'setDisArcimReleaseTime',
        SetName: setName,
        ArcimId: arcimId,
        ReleaseTime: releaseTime,
	HospID: CONST_HOSPID
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
            if (tableID) {
                $('#' + tableID).datagrid('reload');
                editIndex = undefined;
            }
        }
    });

}
/**
 * @description ����ת���迪ҽ������
 */
function updateOutTransSet(tableID, setName, value) {
	if(value){
		$.messager.confirm('ȷ��','ȷ����Ҫɾ����¼��',function(r){    
		    if (r){    
		        $m({
			        ClassName: GV._CALSSNAME,
			        MethodName: 'updateOutTransSet',
			        SetName: setName,
			        Value: value,
			        HospID: CONST_HOSPID
			    }, function (txtData) {
			        if (txtData == 0) {
			            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 2000 });
			            $('#' + tableID).datagrid('reload');
			            editIndex = undefined;
			        }
			    });
		    }    
		});  
	}else{
		$.messager.popover({ msg: 'δ������в���ɾ����', type: 'alert', timeout: 2000 });
	}    
}
/**
 * @description  ɾ���迪ҽ��������
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
 * @description  ɾ����Ժҽ���迪����
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
// ��ʼ����Ժ���ٻ����̿���
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
                field: 'careType', title: '��������',width:'100',
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
                        	{ value: 'T', desc: 'ת��' },
                            { value: 'W', desc: 'ת����' },
                            { value: 'D', desc: '��Ժ' },
                            { value: 'DR', desc: '��Ժ�ٻ�' },
                            { value: 'CA', desc: '���õ���' },
                            { value: 'ECA', desc: '�������õ���' }
                        ]
                    }
                },
            },
            {
                field: 'ifCare', title: '���̿���',
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
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                },
            },
            {
                field: 'condition', title: '����', width:'125', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'conditionDesc', title: '��ʾ����', width:'150', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'sequence', title: '��ʾ˳��', editor: {
                    type: 'numberbox',
                    options: {
                        precision: 0
                    }
                }
            },
            {
                field: 'className', title: '����', width:'160',editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'methodName', title: '������', width:'160',editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'linkUrl', title: '��ת����', width:'160',editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'ifShow', title: '����', width:'40',
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
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                },
            },
            {
                field: 'ApplyPersonType', title: '������Ⱥ', formatter: function (value, row) {
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
                            //{ value: '', desc: 'ȫ����Ⱥ' },
                            { value: '1', desc: '����' },
                            { value: '2', desc: '��ͯ' },
                            { value: '3', desc: 'Ӥ��' },
                            { value: '4', desc: '������' }
                        ]
                    }
                }
            },
            { field: 'oper', title: '����', width: 80, formatter: otherNeedCareSetGridOper }
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
 * @description ���滤ʿ����ת���ٻ����ú���
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
		$.messager.alert("��ʾ",NullValColumnArr.join("��")+"����Ϊ�գ�");
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
            $('#otherNeedCareSetGrid').datagrid('reload');
        }
    })
}

function delotherNeedCareSetGridOper(rowId) {
	$.messager.confirm('ȷ��','ȷ����Ҫɾ����¼��',function(r){    
	    if (r){ 
		    $m({
		        ClassName: GV._CALSSNAME,
		        MethodName: 'delNeedCareOtherSet',
		        RowId: rowId
		    }, function (txtData) {
		        if (txtData == 0) {
		            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 2000 });
		            $('#otherNeedCareSetGrid').datagrid('reload');
		        }
		    })
		}
    })
}
/**
 * @description ��ʼ�����ע�����б�
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
                field: 'careType', title: '���ע����',
                formatter: function (value, row) {
                    return row.careTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'D', desc: '��Ժ' },
                            { value: 'T', desc: 'ת��' },
                            { value: 'W', desc: 'ת����' },
                        ]
                    }
                },
            },
            {
                field: 'personType', title: '��Ա����',
                formatter: function (value, row) {
                    return row.personTypeDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'NURSE', desc: '��ʿ' },
                            { value: 'DOCTOR', desc: 'ҽ��' },
                        ]
                    }
                },
            },
            {
                field: 'condition', title: '�账�����', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'ifShow', title: '����',
                formatter: function (value, row) {
                    return row.ifShowDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                },
            },
            {
                field: 'ifCare', title: '���̿���',
                formatter: function (value, row) {
                    return row.ifCareDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                },
            },
            {
                field: 'sequence', title: '��ʾ˳��', editor: {
                    type: 'numberbox',
                    options: {
                        precision: 0
                    }
                }
            },
            {
                field: 'className', title: '����', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'methodName', title: '������', editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            {
                field: 'ifEmCare', title: '���������Ƿ���ʾ', formatter: function (value, row) {
                    return row.ifEmCareDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ],
						required: true
                    }
                },
            },
            {
                field: 'ifAllowExec', title: '�Ƿ�����ִ��', formatter: function (value, row) {
                    return row.ifAllowExecDesc;
                },
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ],
						required: true
                    }
                },
            },
            {
                field: 'ApplyPersonType', title: '������Ⱥ', formatter: function (value, row) {
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
                            { value: '1', desc: '����' },
                            { value: '2', desc: '��ͯ' },
                            { value: '3', desc: 'Ӥ��' },
                            { value: '4', desc: '������' }
                        ]
                    }
                }
            },
            { field: 'oper', title: '����', width: 80, formatter: needCareSetGridOper }
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
 * @description �������ע���ú���
 * @param {*} index 
 */
function saveNeedCareSetGridOper(index) {
    if (!endNeedCareSetEditing()){
	    $.messager.popover({ msg: '��������֤ʧ�ܣ����ʵά�����ݣ�', type: 'error'});
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
            $('#needCareSetGrid').datagrid('reload');
        }
    })
}

function delNeedCareSetGridOper(rowId) {
	$.messager.confirm('ȷ��','ȷ����Ҫɾ����¼��',function(r){    
	    if (r){ 
		    $m({
		        ClassName: GV._CALSSNAME,
		        MethodName: 'delNeedCareSet',
		        RowId: rowId
		    }, function (txtData) {
		        if (txtData == 0) {
		            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 2000 });
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
                titleDesc: '����',
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
                titleDesc: 'ҽ������',
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
                titleDesc: 'ҽ������',
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
                titleDesc: 'ҽ����',
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
 * @description ��ʼ������ʾ�����б�
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
	                            if(setObj.globalNode=="transNotControlLoc"){ // ת�벻��Ҫ��ؿ��ƿ���
		                            //var wardObj=$('#' + tableID).datagrid('getEditor', {index:editIndex,field:setObj.transWardFieldName});
									//wardObj.target.combobox('reload');
									saveOutTransSet(setObj.globalNode, rowData.id, tableID);
		                        }else{
			                        saveNotAlertSet(tableID, rowData);
			                    }  
	                        }
	                        else {
	                            $.messager.popover({ msg: setObj.titleDesc + '�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
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
	        {title:'ת�����',field:'', align:'left',halign:'center',colspan:2},
	        {title:'ת������',field:'', align:'left',halign:'center',colspan:2},
		    { field: setObj.transBackNeedCareFieldName?setObj.transBackNeedCareFieldName:'transBackNeedCareFlag',
	          title: setObj.transBackNeedCareTitleDesc?setObj.transBackNeedCareTitleDesc:'��ת���������ע', 
	          width: 125, 
	          rowspan:2,
	          hidden:!setObj.transBackNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
	        { field: 'oper', title: '����', width: 40, rowspan:2,formatter: setObj.operFormatter }
	    ],[
	    	{ field: setObj.transNeedCareFieldName?setObj.transNeedCareFieldName:'transNeedCare',  ///wk ������
	          title: setObj.transNeedCareTitleDesc?setObj.transNeedCareTitleDesc:'���������ע', 
	          width: 100, 
	          hidden:!setObj.transNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
		    { field: setObj.transOrderFieldName?setObj.transOrderFieldName:'transOrder',  ///wk ������
	          title: setObj.transOrderTitleDesc?setObj.transOrderTitleDesc:'���ؿ���ת��ҽ��', 
	          width: 100, 
	          hidden:!setObj.transOrderGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
	          title: '���������ע', 
	          width: 100, 
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
		    { field: 'transOutOrderFlag',  ///wk ������
	          title: '���ؿ���ҽ��', 
	          width: 100, 
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
	                            if(setObj.globalNode=="transNotControlLoc"){ // ת�벻��Ҫ��ؿ��ƿ���
		                            //var wardObj=$('#' + tableID).datagrid('getEditor', {index:editIndex,field:setObj.transWardFieldName});
									//wardObj.target.combobox('reload');
									saveOutTransSet(setObj.globalNode, rowData.id, tableID);
		                        }else{
			                        saveNotAlertSet(tableID, rowData);
			                    }  
	                        }
	                        else {
	                            $.messager.popover({ msg: setObj.titleDesc + '�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
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
	        { field: setObj.transNeedCareFieldName?setObj.transNeedCareFieldName:'transNeedCare',  ///wk ������
	          title: setObj.transNeedCareTitleDesc?setObj.transNeedCareTitleDesc:'���������ע', 
	          width: 100, 
	          hidden:!setObj.transNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
		    { field: setObj.transOrderFieldName?setObj.transOrderFieldName:'transOrder',  ///wk ������
	          title: setObj.transOrderTitleDesc?setObj.transOrderTitleDesc:'���ؿ���ת��ҽ��', 
	          width: 100, 
	          hidden:!setObj.transOrderGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
	          title: setObj.transBackNeedCareTitleDesc?setObj.transBackNeedCareTitleDesc:'��ת���������ע', 
	          width: 125, 
	          hidden:!setObj.transBackNeedCareGlobalNode,
			  editor: {
	                    type: 'combobox',
	                    options: {
	                        valueField: 'value',
	                        textField: 'desc',
	                        data: [
	                            { value: 'Y', desc: '��' },
	                            { value: 'N', desc: '��' },
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
	        { field: 'oper', title: '����', width: 40, formatter: setObj.operFormatter }
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
            $.messager.popover({ msg: '����ɹ���', type: 'success', timeout: 2000 });
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
		$.messager.confirm('ȷ��','ȷ����Ҫɾ����¼��',function(r){    
		    if (r){ 
			    $m({
			        ClassName: GV._CALSSNAME,
			        MethodName: 'delNotAlertSet',
			        RowID: rowId,
			    }, function (txtData) {
			        if (txtData == 0) {
			            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 2000 });
			            $('#' + tableID).datagrid('reload');
			            editIndex = undefined;
			        }
			    });
			}
	    })
	}else{
		$.messager.popover({ msg: 'δ������в���ɾ����', type: 'alert', timeout: 2000 });
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
	var tips="ָ��λ�ͷ����ںͳ�Ժ/����ҽ����ʼ���ڵ�ʱ���粻���ã���ҽ�����ͷŴ�λ��<br>������Ϊ0����ҽ����ʼ�����ͷŴ�λ��������Ϊ1���ͷ�ҽ����ʼ���ڵڶ���Ĵ�λ��";
	if(index==3){
		tips="ָ�����Ժ���ںͳ�Ժ/����ҽ����ʼ���ڵ�ʱ���粻���ã���ҽ������ʾҽ�����ڣ�<br>������Ϊ0����ҽ����ʼ���ڰ����Ժ��������Ϊ1���ʾ������Ժҽ��1���ڰ����Ժ����"
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

// �����Ժ��ʿִ��Ȩ��
function saveDischNurExcute(){
	var orderSearchFlag=$("#cb1").radio('getValue') ? "Y" : "N";
	var orderExcuteFlag=$("#cb2").radio('getValue') ? "Y" : "N";
	var orderCancelFlag=$("#cb3").radio('getValue') ? "Y" : "N";
	var orderPrintFlag=$("#cb4").radio('getValue') ? "Y" : "N";
	var orderFlag=orderSearchFlag+"^"+orderExcuteFlag+"^"+orderCancelFlag+"^"+orderPrintFlag;
	saveOutTransSet("dischNurExcute", orderFlag, "");
}
// ��ȡ��Ժ��ʿִ��Ȩ��
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
//�����Ժ�ٻ���������
function saveRecallDayLimit(){
	var data=$("#recallDayLimit").combobox("getData");
	var val=$("#recallDayLimit").combobox("getValue");
	if (val==undefined) val="";
	if (val!=""){
		var index=$.hisui.indexOfArray(data,"value",val);
		if (index<0){
			$.messager.popover({ msg: '������������ѡ�����ݣ�', type: 'error'});
			return false;
		}
	}
	saveOutTransSet("recallLimitDays", val, "");
}
//��ȡ��Ժ�ٻ���������
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