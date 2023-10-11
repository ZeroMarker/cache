
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
    if (IsManyHosps == 1) //多院区业务
    {
        //初始化医院
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp("Nur_IP_Quality.OmitAdverseConfig", sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
            clear();
            initSearchForm();  //初始化查询
            initGrid();        //初始化表格
            locAry = $cm({
                ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getLocs",
                locType: "W",
                hospId: getHospId(),
                tableName: "Nur_IP_Quality.OmitAdverseConfig"
            },false);
            initWin();         //初始化窗口
            /*
            searchBtn();
            locAry = $cm({
                ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getLocs",
                locType: "W",
                hospId: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : ""),
                tableName: "Nur_IP_Quality.OmitAdverseConfig"
            },false);
            //适用科室
            $('#areLocSelect').combobox("loadData",locAry)
            //不适用科室
            $('#unAreLocSelect').combobox("loadData",locAry)
			
			var arcAry = $cm({
				ClassName:"Nur.Quality.Service.Comm",
                MethodName:"getMedicine",
                codes: "",
                HospID: (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
			},false)
			//医嘱选择
			$('#orderSelect').combobox("loadData",arcAry)
			*/

        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    searchBtn();
	    }
    }
    initSearchForm();  //初始化查询
    initGrid();        //初始化表格
    initWin();         //初始化窗口
}

function initSearchForm()
{
    $('#inputTitleInput').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            searchBtn();
        }
    });

      /**事件类型 */
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
        loadMsg: '数据装载中......',
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'title', title: '名称', width: 110, align:'left' },
            { field: 'event', title: '事件', width: 70, align:'left'},
            { field: 'type', title: '类型', width: 120, align:'center' },
            { field: 'status', title: '状态', width: 80, align:'center' },
            { field: 'updateDateTime', title: '修改时间', width: 80, align:'center' },
            { field: 'updateUser', title: '修改人', width: 60, align:'left' },
            { field: 'configID', title: 'configID', width: 60, hidden:true }
        ]],
        pagination: true,
        pageSize: 20,
        pageList: [10, 20, 50],
        pagePosition: 'bottom',
        toolbar:[{
                iconCls: 'icon-add',
                text: '新增',
                handler: function() {
                    clear()
                    setConfigvisibility('P')
                    $('#orderConfigWin').window('open')
                    
                    
                }
            }, 
            {
                iconCls: 'icon-cancel',
                text: '删除',
                handler: function() {
                   var selectRow = $('#patOmitAdverseConfigTable').datagrid("getSelected")
                   if (selectRow == null){
                        $.messager.popover({msg: "请选择一行",type:'error',timeout: 1000});
                        return
                   }

                   $.messager.confirm("删除", "确定删除?", function (r) {
                    if (r) {
                        runClassMethod("Nur.Quality.Service.OmitAdverseConfig","adverseConfigHandler",{
                            parameter1: selectRow.configID,
                            parameter2: '',
                            parameter3: 'delete',
                            parameter4: session['LOGON.USERID']
                       },function(data){
                           if (data == "0")
                           {
                                $.messager.popover({msg: "删除成功",type:'success',timeout: 1000});
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
	            title: '编辑',
        		iconCls:'icon-w-update'
	        })
            setDetailValue(configID)
        }
    })
    
}

function initWin(){
    //绑定事件
    $('#eventSelect').combobox({
        valueField: 'id',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getEventListInterface&parameter1=&parameter2=' +getHospId(),
        filter: filter
    })
    //适用科室
    $('#areLocSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:locAry,
        multiple:true,
        filter: filter
    })
    //不适用科室
    $('#unAreLocSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:locAry,
        multiple:true,
        filter: filter
    })
    //是否启动
    $('#ifOpenSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"Y", desc:"是"},{ID:"N", desc:"否"}]
    })
     //自动关联时限
     $('#autoLinkTimeInput').numberbox({
        min: 0
    });
    //条件类型
    $('#conditionTypeSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"O", desc:"重复医嘱"},{ID:"P", desc:"评估量变化"},{ID:"R", desc:"护理记录"}],
        onSelect: function(record){
            //debugger
            setConfigvisibility(record.ID)
        }
    })
     //间隔时间
    $('#orderIntervalTimeInput').numberbox({
        min: 0
    });
    //间隔时间
    $('#timeTypeSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        data:[{ID:"day", desc:"天"},{ID:"hour", desc:"小时"}]
    })
    //医嘱选择
    $('#orderSelect').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: LINK_CSP + '?className=Nur.Quality.Service.Comm&methodName=getMedicine&parameter1=&parameter2=' + getHospId(),
        multiple:true,
        filter: filter
    })

    //评估变化
    $('#pgItemConfigTable').datagrid({
        // url: $URL,
        // queryParams:{
        //     ClassName: 'Nur.Quality.Service.OmitAdverseConfig',
        //     QueryName: 'getAdverseConfigList',
        //     title: "",
        //     event: ""
        // },
        method: 'post',
        loadMsg: '数据装载中......',
        nowrap: false,
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        columns: [[
            { field: 'emrItemDesc', title: '项目描述',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'oldEmrItem', title: '项目代码',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'oldCondition', title: '原条件',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'newEmrItem', title: '项目代码',  height: 20,width: 70, align:'left',editor:{type:'text'}},
            { field: 'newCondition', title: '新条件',  height: 20,width: 80, align:'left',editor:{type:'text'}},
        ]],
        pagination: true,
        toolbar:[{
                iconCls: 'icon-add',
                text: '新增',
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
                text: '删除',
                handler: function() {
                   var selectRow = $('#pgItemConfigTable').datagrid('getSelected')
                   if (selectRow == null){
                    $.messager.popover({msg: "请选中一条",type:'error',timeout: 1000});
                    return
                   }
                   var selectIndex = $('#pgItemConfigTable').datagrid('getRowIndex', selectRow)
                   $('#pgItemConfigTable').datagrid('deleteRow', selectIndex)
                }
            }]
    })

    //记录单配置获取记录单模板
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

    //触发间隔(天)
    $('#recordTouchDayInput').numberbox({
        min: 0
    });

    //保存
    $('#saveBtn').on('click',function(){
        save_click()
    })

    //关闭
    $('#closeBtn').on('click',function(){
        $('#orderConfigWin').window('close')
    })

    // 编辑窗口
    $('#orderConfigWin').window({
	    top:"30px",
        width: 620,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: '新增',
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
 * 获取编辑框table中值拼成json
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
        $.messager.popover({msg: "适用科室 和 不适用科室 存在相同的数据！" ,type:'error',timeout: 1000});
        return
    }
    if ((jsonData.title == "")||(jsonData.event == "")||(jsonData.ifValid == "")||(jsonData.conditionType == ""))
    {
	    $.messager.popover({msg: "有必填项,未填写。" ,type:'error',timeout: 1000});
        return
    }
    var detail = {}
    if (jsonData.conditionType == "O"){
        detail['order'] = $('#orderSelect').combobox("getValues")
        detail['orderIntervalTime'] = $('#orderIntervalTimeInput').val()
        detail['timeType'] = $('#timeTypeSelect').combobox("getValue")
        if ((detail.order == "")||(detail.orderIntervalTime == "")||(detail.timeType == ""))
        {
	        $.messager.popover({msg: "有必填项,未填写。" ,type:'error',timeout: 1000});
            return
        }
        detail['samePhcfrCode'] = $('#samePhcfrCode').checkbox("getValue")
        detail['samePhcinDesc'] = $('#samePhcinDesc').checkbox("getValue")
        detail['sameOecprDesc'] = $('#sameOecprDesc').checkbox("getValue")
        detail['sameDoseQtyUnit'] = $('#sameDoseQtyUnit').checkbox("getValue")
        detail['sameCtcpDesc'] = $('#sameCtcpDesc').checkbox("getValue")
    }
    else if(jsonData.conditionType == "P"){
        $('#pgItemConfigTable').datagrid('endEdit',0)  // 保存的时候将第一行编辑完成
        detail['pgEmrCode'] = $('#pgEmrCodeInput').val()
        var rows = $('#pgItemConfigTable').datagrid("getRows")
		if (rows.length == 0 )
		{
			$.messager.popover({msg: "项目描述等内容为空" ,type:'error',timeout: 1000});
            return
		}
        //debugger
        detail['pgItemConfig'] = rows
        if (detail.pgEmrCode == "")
        {
	        $.messager.popover({msg: "有必填项,未填写。" ,type:'error',timeout: 1000});
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
	        $.messager.popover({msg: "有必填项,未填写。" ,type:'error',timeout: 1000});
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
 * 给编辑框赋值
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
 * 设置详细信息的隐藏于显示
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
 * @description 比较两个数组是否存在相同的元素
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