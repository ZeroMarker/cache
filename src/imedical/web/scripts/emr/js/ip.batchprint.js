$(function(){
    initPrintListTable();
    getPrintListData();
});

///初始化批量打印列表
function initPrintListTable(){
    $HUI.treegrid("#printList",{
        fit:true,headerCls:'panel-header-gray',
        idField:'id',treeField:'text',
        rownumbers:true,autoSizeColumn:false,
        checkbox:true,singleSelect:false,
        toolbar:[{
            iconCls:'icon-checkin',text:emrTrans('选中所有'),
            handler:function(){
                var roots = treegridObj.getRoots();
                $.each(roots,function(index,item){
                    treegridObj.checkNode(item.id);
                });
            }
        },{
            iconCls:'icon-uncheckin',text:emrTrans('取消选中'),
            handler:function(){
                var roots = treegridObj.getRoots();
                $.each(roots,function(index,item){
                    treegridObj.uncheckNode(item.id);
                });
            }
        },{
            iconCls:'icon-print',text:emrTrans('打印'),
            handler: function(){
                var instanceIDs = new Array();
                var checkedItems = treegridObj.getCheckedNodes('checked');
                $.each(checkedItems,function(index,item){
                    if (item.nodeType == "instance"){
                        var temp = {
                            id:item.instanceId,
                            chartItemType:item.chartItemType,
                            pluginType:item.pluginType,
                            emrDocId:item.emrDocId,
                            isLeadframe:item.isLeadframe
                        };
                        instanceIDs.push(temp);
                    }
                });
                if (instanceIDs.length > 0){
                    envVar.BatchPrintList = envVar.BatchPrintList.concat(instanceIDs);
                    envVar.InsIDCount = instanceIDs.length;
                    setPrintInfo("true");
                    batchPrintDocument();
                }
            }
        }],
        columns:[[
            {field:'id',hidden:true},
            {field:'text',title:'病历名称',width:340,align:'left'},
            {field:'hasPrinted',title:'打印过标识',formatter:function(val,row){
                if (row.nodeType == "instance"){
                    if (val == '1'){
                        return '已打印过';
                    }else{
                        return '未打印过';
                    }
                }else{
                    return '';
                }
            },width:120,align:'right'},
            {field:'printQuality',title:'质控内容',width:180,align:'right',tipWidth:450,showTip:true,tipTrackMouse:true,styler:function(value,row,index){
                if(value != ""){
                  return 'color:#000;';
                }
            }},
            {field:'creator',title:'创建人',width:120,align:'left'},
            {field:'createDate',title:'创建日期',width:120,align:'left'},
            {field:'createTime',title:'创建时间',width:120,align:'left'},
            {field:'admDocDesc',title:'主管医师',width:120,align:'left'},
            {field:'operator',title:'最后修改人',width:120,align:'left'},
            {field:'status',title:'签名状态',width:160,align:'left'},
            {field:'signer',title:'最后签名人',width:120,align:'left'},
            {field:'signDate',title:'签名日期',width:120,align:'left'},
            {field:'signTime',title:'签名时间',width:120,align:'left'},
            {field:'hasSign',title:'签名标识',hidden:true}
        ]],
        rowStyler:function(index){
            if (index.nodeType == "instance"){
                if ((index.hasSign == "0")||(index.printQuality != "")){
                    return 'background:#f4f6f5;color:#ddd;';
                }else if (index.hasPrinted != "0"){
                    return 'background:#dcf0ff;color:#000;';
                }
            }
        },
        onBeforeCheckNode:function(row,checked){
            //未签名病历实例或触犯打印质控则取消选中
            if (row.nodeType == "instance"){
                if (checked){
                    if (row.hasSign == "0"){
                        $.messager.alert("简单提示", "【"+row.text+"】未签名不允许勾选打印，请检查！", 'info');
                        return false;
                    }
                    if (row.printQuality != ""){
                        $.messager.alert("质控提示", "【"+row.text+"】触犯打印质控不允许勾选打印，请检查！", 'info');
                        return false;
                    }
                }
            }else{
                var checkedFlag = true;
                if ((checked)&&(row.children.length > 0)){
                    $.each(row.children,function(index,item){
                        //未签名病历实例或触犯打印质控则取消选中
                        if (item.nodeType == "instance"){
                            if (checked){
                                if (item.hasSign == "0"){
                                    checkedFlag = false;
                                }
                                if (item.printQuality != ""){
                                    checkedFlag = false;
                                }
                                treegridObj.checkNode(item.id);
                            }
                        }
                    });
                }
                if (!checkedFlag){
                    return checkedFlag;
                }
            }
        },
        onLoadSuccess: function(row,data){
            $.each(data.rows,function(idx,val){
                if (val.nodeType == "instance"){
                    //选中已签名，但未触犯打印质控、未打印过的病历实例
                    if ((val.printQuality == "")&&(val.hasPrinted == "0")&&(val.hasSign != "0")){
                        treegridObj.checkNode(val.id);
                    }
                }
            });
        }
    });
}

///获取批量打印列表数据
function getPrintListData(){
    $.ajax({
        type: "POST",
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceListByCategory",
            "p1":episodeID,
            "p2":"Save",
            "p3":"ASCE"
        },
        success: function(data){
            if ((data != null)&&(data != ""))
            {
                treegridObj.loadData(data);
            }
        },
        error : function(d) {
            alert("GetInstanceListByCategory error");
        }
    });
}

///批量打印病历-开始
function batchPrintDocument(){
    var param = envVar.BatchPrintList[0];
    if (param.pluginType == "DOC")
    {
        wordDoc();
    }
    else if (param.pluginType == "GRID")
    {
        girdDoc();
    }
}

///批量打印病历-结束
function doAfterBatchPrint(){
    var checkedItems = treegridObj.getCheckedNodes('checked');
    $.each(checkedItems,function(index,item){
        treegridObj.uncheckNode(item.id);
        treegridObj.unselect(item.id);
    });
    getPrintListData();
}

///打印提示
function setPrintInfo(flag)
{
    if (flag == "true")
    {
        $.messager.progress({
            title: "提示",
            msg: '正在打印病历',
            text: '打印中....'
        });
    }
    else
    {
        $.messager.progress("close");
    }
}

