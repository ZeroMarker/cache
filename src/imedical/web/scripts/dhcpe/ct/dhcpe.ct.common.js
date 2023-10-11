/*
 * FileName: dhcpe.ct.common.js
 * Author: xy
 * Date: 2021-08-04
 * Description: ��Ժ�����칫������
 */



//���ܣ���ȡ���������б�
//������SessionStr(�û�ID^��ȫ��ID^��ǰ��¼����ID^��ǰ��¼ҽԺID),SelectLocID(ѡ�п���ID)
function GetLocComp(sessionStr,SelectLocID) {

	if((SelectLocID=="undefined")||(SelectLocID==undefined)){var SelectLocID="";}

    $("#LocList").combobox({
        panelHeight: "auto",
        //width: 358,
        url: $URL + '?ClassName=web.DHCPE.CT.DHCPEMappingLoc&QueryName=GetLocDataForCombo&ResultSetType=array&SessionStr='+sessionStr+"&SelectLocID="+SelectLocID,
        method: 'get',
        valueField: 'LocRowId',
        textField: 'LocDesc',
        editable: false,
        blurValidValue: true,
        onLoadSuccess: function(data) {
            if(SelectLocID!=""){
		        $("#LocList").combobox('select', SelectLocID);
	        }else{
            	$("#LocList").combobox('select', session['LOGON.CTLOCID']);
	        }
        },
        onSelect: function() {
            //$("#LocList").combobox('getValue')

        }
    });
}


//���ܣ���Ȩ���ҵ���
//������
function OpenLocWin(tableName, DateID, sessionStr, LocID, callback) {
    //alert(LocID)
    $("#LocListWin").show();
    var LocListWin = $HUI.dialog("#LocListWin", {
        width: 550,
        modal: true,
        height: 400,
        iconCls: '',
        title: '���ݹ�������(������๴ѡ��ѡ���ݣ�Ȼ�������水ť)',
        resizable: true,
        buttonAlign: 'center',
        buttons: [{
            iconCls: 'icon-w-save',
            text: '����',
            id: 'save_btn',
            handler: function() {
                SaveDataToPowerControl(tableName, DateID, sessionStr, callback)
            }
        }, {
            iconCls: 'icon-w-close',
            text: '�ر�',
            handler: function() {
                $HUI.dialog("#LocListWin").close()

            }
        }],
        onOpen: function() {

            var gridObj = $HUI.datagrid("#LocListGrid", {
                url: $URL,
                fit: true,
                border: false,
                pagination: false,
                showPageList: false,
                showRefresh: false,
                singleSelect: false,

                queryParams: {
                    ClassName: "web.DHCPE.CT.DHCPEMappingLoc",
                    QueryName: "GetLocDataForCombo",
                    SessionStr: sessionStr,
                    SelectLocID: LocID,
                },

                columns: [[
					{ field: 'EffPower', title: "��Ȩ���", align: "center", checkbox: true }
					,{ field: 'LocRowId', hidden: true, width: 100 }
					,{ field: 'LocDesc', title: '��������', width: 200 }
					,{ field: 'LGLocDesc', title: '������Ĭ�Ͽ���', width: 200 }
                ]],
                onLoadSuccess: function(rowData) {

                    $('#LocListGrid').datagrid('unselectAll');
                    $('#LocListGrid').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
                    //$("#LocListGrid").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");

                    var rows = $('#LocListGrid').datagrid('getRows');
                    for (var i = 0; i < rows.length; i++) {
                        var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc", "GetSDataPowerControl", tableName, DateID, rowData.rows[i].LocRowId);
                        //alert(flag)
                        if (flag == "Y") {
                            $("#LocListGrid").datagrid("selectRow", i);

                        }
                    }


                }
            });


        }


    });
}


//���ܣ�������Ȩ
//������
var SelectLocIDs = []
function SaveDataToPowerControl(tableName, DateID, sessionStr, callback) {
    var LocIDs = "";
    SelectLocIDs = []
    var rows = $("#LocListGrid").datagrid("getRows");
    var selectrow = $("#LocListGrid").datagrid("getChecked"); //��ȡ�������飬��������
    //alert(selectrow.length)	
    for (var i = 0; i < rows.length; i++) {
        var LocID = rows[i].LocRowId;
        var EffPowerFlag = "N";
        for (var j = 0; j < selectrow.length; j++) {
            SelectLocIDs.push(selectrow[j].LocRowId);

        }

        if (SelectLocIDs.indexOf(LocID) > "-1") {

            var EffPowerFlag = "Y";

        }
        if (LocIDs == "") {
            var LocIDs = LocID + "," + EffPowerFlag;
        } else {
            var LocIDs = LocIDs + "^" + LocID + "," + EffPowerFlag;
        }


    }
    //�����������
    var UserID = sessionStr.split("^")[0];
    $cm({
        ClassName: "web.DHCPE.CT.DHCPEMappingLoc",
        MethodName: "SaveSDataToPowerControl",
        tableName: tableName,
        dataid: DateID,
        LocIDStr: LocIDs,
        UserID: UserID,
        dataType: 'text'
    }, function(rtn) {
        //alert("rtn:"+rtn)
        var rtnArr = rtn.split("^");
        if (rtnArr[0] == 0) {
            if ("function" == typeof callback) callback();
            $HUI.dialog("#LocListWin").close();
        } else {
            $.messager.popover({
                msg: rtn.rtnArr[1],
                type: 'alert',
                timeout: 2000
            });
        }
    });
}

// ��ҳ���ݵĲ���(��ѯ���浼�������õ�)
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	//  �ж������Ƿ�������
		data = {
			total: data.length,
			rows: data
		}
	}
	
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	var sortName = opts.sortName;
    var sortOrder = opts.sortOrder;
 	
 	if (!data.originalRows) {
        data.originalRows = data.rows;
	}
    if ((!opts.remoteSort)&& (sortName != null)) {	    
        data.originalRows.sort(function (obj1, obj2) {
            var val1 = obj1[sortName];
            var val2 = obj2[sortName];
            if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                val1 = Number(val1);
                val2 = Number(val2);
            }
            var $sorter = dg.datagrid("getColumnOption", sortName).sorter;  //sorter���򷽷�
            if ($sorter) {
                return (sortOrder == "asc") ? $sorter(val1, val2) : $sorter(val2, val1);
            } else {
                if(val1<val2){
                    return (sortOrder == "desc") ? 1 : -1;
                } else if (val1 > val2) {
                    return (sortOrder == "desc") ? -1 : 1;
                } else {
                    return 0
                }
            }
        })
    }
     
    if (!opts.pagination)    //�Ƿ��ҳ
        return data;
	pager.pagination({
		onSelectPage: function (pageNum, pageSize) {
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh', {
				pageNumber: pageNum,
				pageSize: pageSize
			});
			dg.datagrid('loadData', data);
		}
	});
	
	//��ҳ���ѯ���ݱ仯����һ����ʾ�հ����⴦��
	if (data.originalRows.length<=opts.pageSize) opts.pageNumber=1;  
	if ((data.originalRows.length>opts.pageSize)&&(data.originalRows.length<=((opts.pageNumber-1)*opts.pageSize))) {
	   opts.pageNumber = Math.ceil(data.originalRows.length/opts.pageSize);  //����ȡ��
	}
	var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

//��չdatagrid:��̬���ɾ��editor
$.extend($.fn.datagrid.methods, {    
    addEditor : function(jq, param) {   
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item.field); 
                e.editor = item.editor; }); 
            } else {    
                var e = $(jq).datagrid('getColumnOption', param.field);    
                e.editor = param.editor;  
            }   
        },  
    removeEditor : function(jq, param) {    
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item);   
                e.editor = {};  
                }); 
        } else {    
            var e = $(jq).datagrid('getColumnOption', param);
            e.editor = {};  
        }   
    }
});


var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

//ȡֵ
function Common_GetValue()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
	if ($this.attr("class")){
		var className = $this.attr("class").split(' ')[0];
		if (className == 'textbox') {  //�ı���
			itmValue = $this.val();
		}else if (className == 'hisui-numberbox') {  //����
			itmValue = $this.val();	    
		}else if (className == 'hisui-datebox') {  //����
			itmValue = $this.datebox('getValue');	    
		}else if (className == 'hisui-timespinner') {  //ʱ���
			itmValue = $this.timespinner('getValue');	
		}else if (className == 'hisui-combobox') {  //�����򣨶�ѡ������û�з�װ��
			itmValue = $this.combobox('getValue');
		}else if (className == 'hisui-switchbox') {  //����
			itmValue = $this.switchbox('getValue');	
		}else if (className == 'hisui-checkbox') {  // ������ѡ��
			itmValue = $this.checkbox('getValue');	    
		}else if (className == 'hisui-radio') {  //������ѡ��
			itmValue = $this.radio('getValue');
		}else if (className == 'hisui-searchbox') {  //��ѯ���
			itmValue = $this.searchbox('getValue');	
		}
	} else {
		itmValue = $this.val();
	}
	return itmValue;
}

//ȡֵ
function Common_GetText()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
	if ($this.attr("class")){
		var className = $this.attr("class").split(' ')[0];
		if (className == 'textbox') {  //�ı���
			itmValue = $this.val();
		}else if (className == 'hisui-numberbox') {  //����
			itmValue = $this.val();	    
		}else if (className == 'hisui-datebox') {  //����
			itmValue = $this.datebox('getValue');	    
		}else if (className == 'hisui-timespinner') {  //ʱ���
			itmValue = $this.timespinner('getValue');	
		}else if (className == 'hisui-combobox') {  //������
			itmValue = $this.combobox('getText');
		}else if (className == 'hisui-switchbox') {  //����
			itmValue = $this.switchbox('getValue');	
		}else if (className == 'hisui-checkbox') {  // ������ѡ��
			itmValue = $this.attr("label");	    
		}else if (className == 'hisui-radio') {  //������ѡ��
			itmValue =$this.attr("label");
		}else if (className == 'hisui-searchbox') {  //��ѯ���
			itmValue = $this.searchbox('getValue');	
		}
	} else {
		itmValue = $this.val();
	}
	return itmValue;
}

//��ֵ
function Common_SetValue()
{
	var itmValue = '';
    
    var val = arguments[1];     
	var txt = arguments[2];
	
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	if (typeof val == 'undefined') val = '';
	if (typeof txt == 'undefined') txt = '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //�ı���
	    itmValue = $this.val(val);
    }else if (className == 'hisui-numberbox') {  //����
    	itmValue = $this.val(val);	    
    }else if (className == 'hisui-datebox') {  //����
    	itmValue = $this.datebox('setValue',val);   
    }else if (className == 'hisui-timespinner') {  //ʱ���
    	itmValue = $this.timespinner('setValue',val);	
    }else if (className == 'hisui-combobox') {  //������
    	if(val !="" && txt ==""){
   	  		itmValue = $this.combobox('setValue',val);
    	}else{
	    	itmValue = $this.combobox('setValue',txt);
		}
    }else if (className == 'hisui-switchbox') {  //����
    	itmValue = $this.switchbox('setValue',val);	
    }else if (className == 'hisui-checkbox') {  // ������ѡ��
    	if (val == '') val = 0;
    	itmValue = $this.checkbox('setValue',(val) ? true : false);
    }else if (className == 'hisui-radio') {  //������ѡ��
        if (val == '') val = 0;
    	itmValue = $this.radio('setValue',(val) ? true : false);
    }else if (className == 'hisui-searchbox') {  //��ѯ���
    	itmValue = $this.searchbox('setValue',val);	
    }
    
	return itmValue;	
}

//***��������  ֻ���ǰ̨��ҳ��ѯ������չʾ�� Start ***//
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

Array.prototype.contains = function(item){
	RegExp("\\b"+item+"\\b").test(this);
};
var originalData =[];   //��ʼ����
function searchText(dg,t,odata){ //������$("#datagrid")
	var tempIndex=[];	   //ƥ����	
	var state = dg.data('datagrid'); 
	
	//if (!odata) odata = originalData;
    if (!odata.total) {
	    var rows = state.data.originalRows||state.originalRows;
	   	odata = {
			selector : dg.selector,
			total: rows.length,
			rows: rows
		}
    } else {
	  var rows = odata.originalRows||odata.rows;
    }
    var columns = dg.datagrid('getColumnFields');
    var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
	
    var searchVal = t;
    if (searchVal) {
	    for(var i=0;i<rows.length;i++){
	        for(var j=1;j<columns.length;j++){
		        var col = dg.datagrid('getColumnOption', fields[j]);
		        if((col.hidden == true)||(col.checkbox == true)) {  //�����С���ѡ����
					continue;
				}
				if(col.formatter) {   //���ӡ���ʽ��������
					continue;
				}	
				if(!col.title) {  //�ޱ��⣨��ǰ̨չʾ�У�
					continue;
				}
	            if((rows[i][columns[j]])&&(rows[i][columns[j]].indexOf(searchVal)>=0)){
	                if(!tempIndex.contains(i)){
	                    tempIndex.push(i);
	                    break;
	                }
	            }
	        }
	    }
	   var RowsData=[];
	   for(var rowIndex=0;rowIndex<tempIndex.length;rowIndex++){  //ƥ����
		    var Index = tempIndex[rowIndex];
		    var row = rows[Index];
		    RowsData.push(row);   
	    }
	    data = {  //��������
			total: tempIndex.length,
			rows: RowsData
		}
		dg.datagrid('loadData', data);
	}else {
		dg.datagrid('loadData', odata);
	}
	return odata;
}
