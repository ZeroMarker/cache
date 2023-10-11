
var locAry = $cm({
    ClassName:"Nur.Quality.Service.Comm",
    MethodName:"getLocs",
    locType: "W",
    hospId: session['LOGON.HOSPID'],
    tableName: "Nur_IP_Quality.OmitAdverseConfig"
},false);
$(function() {
    initUI()
})

function initUI(){
    if (IsManyHosps == 1) //��Ժ��ҵ��
    {
        //��ʼ��ҽԺ
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp("Nur_IP_Quality.OmitAdverseConfig", sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
            clear();
            initSearchForm();  //��ʼ����ѯ
            initGrid();        //��ʼ�����
            locAry = $cm({
                ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getLocs",
                locType: "W",
                hospId: getHospId(),
                tableName: "Nur_IP_Quality.OmitAdverseConfig"
            },false);
            initWin();         //��ʼ������
            /*
            searchBtn();
            locAry = $cm({
                ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getLocs",
                locType: "W",
                hospId: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : ""),
                tableName: "Nur_IP_Quality.OmitAdverseConfig"
            },false);
            //���ÿ���
            $('#areLocSelect').combobox("loadData",locAry)
            //�����ÿ���
            $('#unAreLocSelect').combobox("loadData",locAry)
			
			var arcAry = $cm({
				ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getMedicine",
                codes: "",
                HospID: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
			},false)
			//ҽ��ѡ��
			$('#orderSelect').combobox("loadData",arcAry)
			*/

        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    searchBtn();
	    }
    }
    initSearchForm();  //��ʼ����ѯ
    initGrid();        //��ʼ�����
    initWin();         //��ʼ������
}

function initSearchForm()
{
    $('#inputTitleInput').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            searchBtn();
        }
    });

      /**�¼����� */
      $('#inpuEventSelect').combobox({
        valueField: 'id',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEventListInterface&parameter1=&parameter2=' +getHospId(),
        filter: filter,
        onSelect: function(){
            searchBtn();
        }
    })

    $('#searchBtn').on('click',function(){
        searchBtn()
    })


}

function initGrid()
{
    $('#patOmitAdverseConfigTable').datagrid({
        url: $URL,
        queryParams:{
            ClassName: 'Nur.Quality.Service.OmitAdverseConfig',
            QueryName: 'getAdverseConfigList',
            SearchTitle: $('#inputTitleInput').val(),
            SearchEvent: $('#inpuEventSelect').combobox("getValue"),
            HospId: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : ""),
        },
        method: 'post',
        loadMsg: '����װ����......',
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'title', title: '����', width: 110, align:'left' },
            { field: 'event', title: '�¼�', width: 70, align:'left'},
            { field: 'type', title: '����', width: 120, align:'center' },
            { field: 'status', title: '״̬', width: 80, align:'center' },
            { field: 'updateDateTime', title: '�޸�ʱ��', width: 80, align:'center' },
            { field: 'updateUser', title: '�޸���', width: 60, align:'left' },
            { field: 'configID', title: 'configID', width: 60, hidden:true }
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar:[{
                iconCls: 'icon-add',
                text: '����',
                handler: function() {
                    clear()
                    setConfigvisibility('P')
                    $('#orderConfigWin').window('open')
                    
                    
                }
            }, 
            {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
                   var selectRow = $('#patOmitAdverseConfigTable').datagrid("getSelected")
                   if (selectRow == null){
                        $.messager.popover({msg: "��ѡ��һ��",type:'error',timeout: 1000});
                        return
                   }

                   $.messager.confirm("ɾ��", "ȷ��ɾ��?", function (r) {
                    if (r) {
                        runClassMethod("Nur.Quality.Service.OmitAdverseConfig","adverseConfigHandler",{
                            parameter1: selectRow.configID,
                            parameter2: '',
                            parameter3: 'delete',
                            parameter4: session['LOGON.USERID']
                       },function(data){
                           if (data == "0")
                           {
                                $.messager.popover({msg: "ɾ���ɹ�",type:'success',timeout: 1000});
                                $('#patOmitAdverseConfigTable').datagrid("load")
                           }else{
                                $.messager.popover({msg: data, type:'error',timeout: 1000});
                           }
                       })
                    }
                    });
                }
            }],
        onDblClickRow:function(rowIndex, rowData){
            var configID = rowData["configID"]
            setConfigvisibility(rowData["type"])
            $('#orderConfigWin').window({
	            title: '�༭',
        		iconCls:'icon-w-update'
	        })
            setDetailValue(configID)
        }
    })
    
}

function initWin(){
    //���¼�
    $('#eventSelect').combobox({
        valueField: 'id',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEventListInterface&parameter1=&parameter2=' +getHospId(),
        filter: filter
    })
    //���ÿ���
    $('#areLocSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:locAry,
        multiple:true,
        filter: filter
    })
    //�����ÿ���
    $('#unAreLocSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:locAry,
        multiple:true,
        filter: filter
    })
    //�Ƿ�����
    $('#ifOpenSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"Y", desc:"��"},{ID:"N", desc:"��"}]
    })
     //�Զ�����ʱ��
     $('#autoLinkTimeInput').numberbox({
        min: 0
    });
    //��������
    $('#conditionTypeSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"O", desc:"�ظ�ҽ��"},{ID:"P", desc:"�������仯"},{ID:"R", desc:"�����¼"}],
        onSelect: function(record){
            //debugger
            setConfigvisibility(record.ID)
        }
    })
     //���ʱ��
    $('#orderIntervalTimeInput').numberbox({
        min: 0
    });
    //���ʱ��
    $('#timeTypeSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"day", desc:"��"},{ID:"hour", desc:"Сʱ"}]
    })
    //ҽ��ѡ��
    $('#orderSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getMedicine&parameter1=&parameter2=' + getHospId(),
        multiple:true,
        filter: filter
    })

    //�����仯
    $('#pgItemConfigTable').datagrid({
        // url: $URL,
        // queryParams:{
        //     ClassName: 'Nur.Quality.Service.OmitAdverseConfig',
        //     QueryName: 'getAdverseConfigList',
        //     title: "",
        //     event: ""
        // },
        method: 'post',
        loadMsg: '����װ����......',
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'emrItemDesc', title: '��Ŀ����',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'oldEmrItem', title: '��Ŀ����',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'oldCondition', title: 'ԭ����',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'newEmrItem', title: '��Ŀ����',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'newCondition', title: '������',  height: 20,width: 80, align:'left',editor:{type:'text'}},
        ]],
        pagination: true,
        toolbar:[{
                iconCls: 'icon-add',
                text: '����',
                handler: function() {
                    $('#pgItemConfigTable').datagrid('endEdit',0)
                    $('#pgItemConfigTable').datagrid('insertRow',{
                        index: 0,
                        row:{}
                    });
                    editIndex = 0
                    $('#pgItemConfigTable').datagrid('beginEdit',0)
                }
            }, 
            {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function() {
                   var selectRow = $('#pgItemConfigTable').datagrid('getSelected')
                   if (selectRow == null){
                    $.messager.popover({msg: "��ѡ��һ��",type:'error',timeout: 1000});
                    return
                   }
                   var selectIndex = $('#pgItemConfigTable').datagrid('getRowIndex', selectRow)
                   $('#pgItemConfigTable').datagrid('deleteRow', selectIndex)
                }
            }]
    })

    //��¼�����û�ȡ��¼��ģ��
    $('#recordEmrCodeSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.Quality.Service.Comm&MethodName=getEmrCodeList&HospId=' + getHospId(),
        filter: filter,
        onSelect: function(record){
            $('#recordEmrItemSelect').combobox("setValues","")
            $('#recordEmrItemSelect').combobox("reload", $URL + '?ClassName=Nur.Quality.Service.Comm&MethodName=getEmrCodeItemList&EmrCode=' + record.ID)
        }
    })

     $('#recordEmrItemSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        //url: $URL + '?ClassName=Nur.Quality.Service.Comm&MethodName=getEmrCodeList',
        filter: filter,
        multiple:true,
    })

    //�������(��)
    $('#recordTouchDayInput').numberbox({
        min: 0
    });

    //����
    $('#saveBtn').on('click',function(){
        save_click()
    })

    //�ر�
    $('#closeBtn').on('click',function(){
        $('#orderConfigWin').window('close')
    })

    // �༭����
    $('#orderConfigWin').window({
	    top:"30px",
        width: 620,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: '����',
        iconCls:'icon-w-add'
    })
    /*icon-w-paper*/
}


function searchBtn(){
    var queryParams = $('#patOmitAdverseConfigTable').datagrid('options').queryParams;
    queryParams.SearchTitle = $('#inputTitleInput').val()
    queryParams.SearchEvent = $('#inpuEventSelect').combobox("getValue")
    queryParams.HospId = (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
    $('#patOmitAdverseConfigTable').datagrid('options').queryParams = queryParams;
    $('#patOmitAdverseConfigTable').datagrid('load')
}

/**
 * ��ȡ�༭��table��ֵƴ��json
 */
function getTableJSON()
{
    var data = {}
    data['title'] = $('#titleInput').val()
    data['event'] = $('#eventSelect').combobox("getValue")
    data['area'] = $('#areLocSelect').combobox("getValues")
    data['unArea'] = $('#unAreLocSelect').combobox("getValues")
    data['ifValid'] = $('#ifOpenSelect').combobox("getValue")
    data['autoLinkTime'] = $('#autoLinkTimeInput').val()
    data['conditionType'] = $('#conditionTypeSelect').combobox("getValue")
    return data
}

function save_click()
{
    var jsonData = getTableJSON()
    if (isExitSameValue(jsonData['area'], jsonData['unArea']))
    {
        $.messager.popover({msg: "���ÿ��� �� �����ÿ��� ������ͬ�����ݣ�" ,type:'error',timeout: 1000});
        return
    }
    if ((jsonData.title == "")||(jsonData.event == "")||(jsonData.ifValid == "")||(jsonData.conditionType == ""))
    {
	    $.messager.popover({msg: "�б�����,δ��д��" ,type:'error',timeout: 1000});
        return
    }
    var detail = {}
    if (jsonData.conditionType == "O"){
        detail['order'] = $('#orderSelect').combobox("getValues")
        detail['orderIntervalTime'] = $('#orderIntervalTimeInput').val()
        detail['timeType'] = $('#timeTypeSelect').combobox("getValue")
        if ((detail.order == "")||(detail.orderIntervalTime == "")||(detail.timeType == ""))
        {
	        $.messager.popover({msg: "�б�����,δ��д��" ,type:'error',timeout: 1000});
            return
        }
        detail['samePhcfrCode'] = $('#samePhcfrCode').checkbox("getValue")
        detail['samePhcinDesc'] = $('#samePhcinDesc').checkbox("getValue")
        detail['sameOecprDesc'] = $('#sameOecprDesc').checkbox("getValue")
        detail['sameDoseQtyUnit'] = $('#sameDoseQtyUnit').checkbox("getValue")
        detail['sameCtcpDesc'] = $('#sameCtcpDesc').checkbox("getValue")
    }
    else if(jsonData.conditionType == "P"){
        $('#pgItemConfigTable').datagrid('endEdit',0)  // �����ʱ�򽫵�һ�б༭���
        detail['pgEmrCode'] = $('#pgEmrCodeInput').val()
        var rows = $('#pgItemConfigTable').datagrid("getRows")
		if (rows.length == 0 )
		{
			$.messager.popover({msg: "��Ŀ����������Ϊ��" ,type:'error',timeout: 1000});
            return
		}
        //debugger
        detail['pgItemConfig'] = rows
        if (detail.pgEmrCode == "")
        {
	        $.messager.popover({msg: "�б�����,δ��д��" ,type:'error',timeout: 1000});
            return
        }
    }
    else if(jsonData.conditionType == "R"){
        detail['recordEmrCode'] = $('#recordEmrCodeSelect').combobox("getValue")
        detail['recordEmrItem'] = $('#recordEmrItemSelect').combobox("getValues")
        detail['recordEmrItemDesc'] = $('#recordEmrItemSelect').combobox("getText")
        detail['recordTouch'] = $('#recordTouchCheckbox').checkbox("getValue")
        detail['recordTouchDay'] = $('#recordTouchDayInput').val()
        detail['recordEmrMainWord'] = $('#recordEmrMainWordInput').val()
        //debugger
        if ((detail.recordEmrCode == "")||(detail.recordEmrItem == ""))
        {
	        $.messager.popover({msg: "�б�����,δ��д��" ,type:'error',timeout: 1000});
            return
        }
    }
    jsonData['configDetail'] = detail
    runClassMethod("Nur.Quality.Service.OmitAdverseConfig","adverseConfigHandler",{
        parameter1: $('#configID').val(),
        parameter2: JSON.stringify(jsonData),
        parameter3: 'insert',
        parameter4: session['LOGON.USERID'],
        parameter5: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
    },function(data){
        if (data == "0"){
            $('#orderConfigWin').window('close')
            $('#patOmitAdverseConfigTable').datagrid('reload')
        }else{
            $.messager.popover({msg: data,type:'error',timeout: 1000});
        }
    })
}
/**
 * ���༭��ֵ
 */
function setDetailValue(configID){
    runClassMethod("Nur.Quality.Service.OmitAdverseConfig","getDataByConfigID",{
        parameter1: configID
    },function(jsonData){
        eval(jsonData)
        $('#configID').val(jsonData.configID)
        $('#titleInput').val(jsonData.title).validatebox("validate")
        $('#eventSelect').combobox("setValue",jsonData.event)
        $('#areLocSelect').combobox("setValues",jsonData.area)
        $('#unAreLocSelect').combobox("setValues",jsonData.unArea)
        $('#ifOpenSelect').combobox("setValue",jsonData.ifValid)
        $('#autoLinkTimeInput').val(jsonData.autoLinkTime)
        $('#conditionTypeSelect').combobox("setValue",jsonData.conditionType)

        if (jsonData.conditionType == "O")
        {
            $('#orderSelect').combobox("setValues",jsonData.configDetail.order)
            $('#timeTypeSelect').combobox("setValue",jsonData.configDetail.timeType)
            $('#orderIntervalTimeInput').val(jsonData.configDetail.orderIntervalTime).validatebox("validate");

            $('#samePhcfrCode').checkbox("setValue", jsonData.configDetail.samePhcfrCode ? true : false)
            $('#samePhcinDesc').checkbox("setValue", jsonData.configDetail.samePhcinDesc ? true : false)
            $('#sameOecprDesc').checkbox("setValue", jsonData.configDetail.sameOecprDesc ? true : false)
            $('#sameDoseQtyUnit').checkbox("setValue", jsonData.configDetail.sameDoseQtyUnit ? true : false)
            $('#sameCtcpDesc').checkbox("setValue", jsonData.configDetail.sameCtcpDesc ? true : false)

        }else if(jsonData.conditionType == "P")
        {
            $('#pgEmrCodeInput').val(jsonData.configDetail.pgEmrCode).validatebox("validate");
            $('#pgItemConfigTable').datagrid("loadData", jsonData.configDetail.pgItemConfig)

        }else if(jsonData.conditionType == "R")
        {
            debugger
            $('#recordEmrCodeSelect').combobox("setValue", jsonData.configDetail.recordEmrCode)

            $('#recordEmrItemSelect').combobox("reload", $URL + '?ClassName=Nur.Quality.Service.Comm&MethodName=getEmrCodeItemList&EmrCode=' + jsonData.configDetail.recordEmrCode)

            $('#recordEmrItemSelect').combobox("setValues", jsonData.configDetail.recordEmrItem)
            $('#recordTouchCheckbox').checkbox("setValue", jsonData.configDetail.recordTouch ? true : false)
            $('#recordTouchDayInput').val(jsonData.configDetail.recordTouchDay).validatebox("validate");
            $('#recordEmrMainWordInput').val(jsonData.configDetail.recordEmrMainWord)
        }

        $('#orderConfigWin').window('open')
    })
}

/**
 * ������ϸ��Ϣ����������ʾ
 */
function setConfigvisibility(ID)
{
    switch(ID)
    {
        case 'O':
            $('#orderConfig').css("display","block")
            $('#pgConfig').css("display","none")
            $('#recordConfig').css("display","none")
            break;
        case 'P':
            $('#orderConfig').css("display","none")
            $('#pgConfig').css("display","block")
            $('#pgConfig').css("visibility","visible")
            $('#recordConfig').css("display","none")
            break;
        case 'R':
            $('#orderConfig').css("display","none")
            $('#pgConfig').css("display","none")
            $('#recordConfig').css("display","block")
            break;

    }
}

function clear()
{
    $('#configID').val("")
    $('#titleInput').val("").validatebox("validate")
    $('#eventSelect').combobox("setValue","")
    $('#areLocSelect').combobox("setValues","")
    $('#unAreLocSelect').combobox("setValues","")
    $('#ifOpenSelect').combobox("setValue","")
    $('#autoLinkTimeInput').val("")
    $('#conditionTypeSelect').combobox("setValue","")
    $('#orderSelect').combobox("setValues","")
    $('#timeTypeSelect').combobox("setValue","")

    $('#orderIntervalTimeInput').val("").validatebox("validate")

    $('#samePhcfrCode').checkbox("setValue", false)
    $('#samePhcinDesc').checkbox("setValue", false)
    $('#sameOecprDesc').checkbox("setValue", false)
    $('#sameDoseQtyUnit').checkbox("setValue", false)
    $('#sameCtcpDesc').checkbox("setValue", false)

    $('#pgEmrCodeInput').val("").validatebox("validate");
    $('#pgItemConfigTable').datagrid("loadData",[])

    $('#recordEmrCodeSelect').combobox("setValue","")
    $('#recordEmrItemSelect').combobox("loadData",[])
    $('#recordEmrItemSelect').combobox("setValues","")
    $('#recordTouchDayInput').val("").validatebox("validate")
    $('#recordEmrMainWordInput').val("")
}


function setConfigAllHidden()
{
	$('#pgConfig').css("display","none")
	$('#orderConfig').css("display","none")
	$('#recordConfig').css("display","none")
}

function filter(q, row) {
    var opts = $(this).combobox('options');
    var text = row[opts.textField];
    var pyjp = getPinyin(text).toLowerCase();
    if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
        return true;
    }
    return false;
}

/**
 * @description �Ƚ����������Ƿ������ͬ��Ԫ��
 * @param Array newArray 
 * @param Array oldArray 
 */
function isExitSameValue(newArray, oldArray)
{
    var flag = false;
    for (var i = 0; i < newArray.length; i++)
    {
        if (flag) break;
        for (var j = 0; j < oldArray.length; j++){
            if (newArray[i] == oldArray[j])
            {
                flag = true
                break
            }
        }
    }
    return flag
}


function getHospId()
{
    return (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
}