function CostTravelPage(mainId,reqtarget,infotarget,row,checkBeforeSave,saveOrder,itemGrid){
    var billstate=itemGrid.billstate;
    var IsCurStep=itemGrid.IsCurStep;
    // console.log(billstate+"^"+"^"+"测试");
    ///datetimebox定义
    // $.extend($.fn.datagrid.defaults.editors, {
    //     datetimebox: {// datetimebox就是你要自定义editor的名称
    //         init: function (container, options) {
    //             var input = $('<input class="easyuidatetimebox">').appendTo(container);
    //             return input.datetimebox({
    //                 formatter: function (date) {
    //                     return new Date(date).format("yyyy-MM-dd hh:mm:ss");
    //                 }
    //             });
    //         },
    //         getValue: function (target) {
    //             return $(target).parent().find('input.combo-value').val();
    //         },
    //         setValue: function (target, value) {
    //             $(target).datetimebox("setValue", value);
    //         },
    //         resize: function (target, width) {
    //             var input = $(target);
    //             // if ($.boxModel == true) {
    //             //     input.width(width - (input.outerWidth() - input.width()));
    //             // } else {
    //             //     input.width(width);
    //             // }
    //             input.datetimebox("resize",width);                    
    //         }
    //     }
    // });
    //增加按钮  
    var AddTrBtn={
        id: 'AddTrBtn',
        iconCls: 'icon-add',
        text: '增加',
        handler: function(){
            AddTrRow()  //增加一行函数
        }
    }
    //删除按钮
    var DelTrBtn= {
        id: 'DelTrBt',
        iconCls: 'icon-del-diag',
        text: '删除',
        handler: function(){                
            RemRecd()
        }
    }
    //初始化报销单窗口        
    var $AddTravel;
    $AddTravel = $('#AddTravel').window({
        title: '差旅费填报',
        width: 950,
        height: 400,
        top: ($(window).height() - 400) * 0.5,
        left: ($(window).width() - 950) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-save',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
           $("#AddMainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });

    $AddTravel.window('open');

    //列配置对象
    TravelColumns=[[ 
        {field:'ckbox',checkbox:true,rowspan:2},//复选框 
        {field:'',title:'ID',width:30,hidden: true},
        {field:'',title:'起讫日期',colspan:2},
        {field:'',title:'出差地点',colspan:2},
        {field:'',title:'交通费',colspan:3},
        {field:'',title:'伙食费',colspan:2},
        {field:'',title:'住宿费',colspan:3},
        {field:'',title:'其他费',colspan:13}            
        ],[
        {field:'rowid',title:'ID',width:30,hidden: true},
        {field:'mainId',title:'主表ID',width:150,hidden: true},
        {field:'startDT',title:'开始时间',align:'left',width:160,editor:{type:'datebox',options:{required:'true'}}                
            //         onSelect:function(date){
            //             var y = date.getFullYear();
            //             var m = date.getMonth()+1;
            //             var d = date.getDate();
            //             var H = date.getHours();
            //             var i = date.getMinutes();
            //             var s = date.getSeconds();
            //             // console.info(y+"-"+m+"-"+d+" "+H+":"+i+":"+s);
            //             var value=y+"-"+m+"-"+d;
            //             var curindex=$(this).index();
            //             var startDTtarget = $('#TravelGrid').datagrid('getEditor', {'index':curindex,'field':'startDT'}).target;
            //             $(startDTtarget).datebox("setValue",value);
            //             console.info(value);
            //         }
            //     }
            // }
        },            
        {field:'endDT',title:'结束时间',align:'left',width:160,editor:'datebox'},    
        {field:'startAddr',title:'起始地点',align:'left',width:80,
            editor:{type:'validatebox',options:{required:'true',validType:'chinese'}}},    
        {field:'endAddr',title:'出差地点',align:'left',width:80,
            editor:{type:'validatebox',options:{required:'true',validType:'chinese'}}},        
        {field:'travelTool',title:'交通工具',align:'left',width:80,
            editor:{type:'validatebox',options:{required:'true',validType:'chinese'}}},    
        {field:'travelFee',title:'交通费',align:'right',width:100,
            editor: { type: 'numberbox', options: { required: true,precision:2} }},
        {field:'travelSheets',title:'交通费票据张数',align:'right',width:120,
            editor:{type:'validatebox',options:{required:'true',validType:'NotNegIntNum'}}},        
        {field:'foodSubsidies',title:'伙食补助',align:'right',width:120,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'foodSubsDays',title:'伙食补助天数',align:'right',width:100,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'stayFee',title:'住宿金额',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'stayDays',title:'住宿天数',align:'right',width:80,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'staySheets',title:'住宿票据张数',align:'right',width:100,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'inCityFee',title:'市内交通费',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'inCitySheets',title:'市内交通费票据张数',align:'right',width:140,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'otherFee',title:'其他费',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'otherSheets',title:'其他费票据张数',align:'right',width:120,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'standByFirFee',title:'备用金额1',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'standByFirShets',title:'备用金额1票据张数',align:'right',width:140,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'standBySecFee',title:'备用金额2',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'standBySecShets',title:'备用金额2票据张数',align:'right',width:140,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'standByThiFee',title:'备用金额3',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'standByThiShets',title:'备用金额3票据张数',align:'right',width:140,
            editor:{type:'validatebox',options:{validType:'NotNegIntNum'}}},    
        {field:'reqFee',title:'借款',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'backFee',title:'应退回',align:'right',width:100,
            editor: { type: 'numberbox', options: { precision:2} }},    
        {field:'supplyFee',title:'应补给',align:'right',width:80,
            editor: { type: 'numberbox', options: { precision:2} }},
     ]];
    //定义表格
    var TravelGrid = $HUI.datagrid("#TravelGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.ubudgcostclaimapplytravel",
            MethodName:"List",
            mainId :    mainId
        },            
        checkOnSelect: true, //选中行复选框勾选
        selectOnCheck: true, //选中行复选框勾选        
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: false, //为true时只允许选中一行,为false时多选   若注释掉，默认单选
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
           TrClickCell(index); 
        }, 
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            }
        },           
        fit:true,
        pagination:true,
        columns:TravelColumns,
        toolbar: [AddTrBtn,'-',DelTrBtn]       
    });
    if(!(IsCurStep== 1&&billstate=="提交")){
        $('#AddTrBtn').linkbutton("disable");
        $('#DelTrBt').linkbutton("disable");        
    }    
    //增加一行方法
    function AddTrRow(){
        $("#TravelGrid").datagrid("insertRow", {
            index: 0, // index start with 0
            row: {
                rowid:'',
                mainId:'',
                startDT:'',
                endDT:'',
                startAddr:'',
                endAddr:'',
                travelTool:'',
                travelFee:'',
                travelSheets:'',
                foodSubsidies:'',
                foodSubsDays:'',
                stayFee:'',
                stayDays:'',
                staySheets:'',
                inCityFee:'',
                inCitySheets:'',
                otherFee:'',
                otherSheets:'',
                standByFirFee:'',
                standByFirShets:'',
                standBySecFee:'',
                standBySecShets:'',
                standByThiFee:'',
                standByThiShets:'',
                reqFee:'',
                backFee:'',
                supplyFee:''
            }
        });
        // $("#AddMainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
        $("#AddMainGrid").datagrid('selectRow', 0);
        //将新插入的那一行开户编辑状态
        $("#TravelGrid").datagrid("beginEdit", 0);
    }
    //点击单元格时，选中该行，开启行编辑。
    function TrClickCell(index){
        $('#TravelGrid').datagrid('selectRow', index);
        if((IsCurStep== 1)&&(billstate=="提交")){
            $('#TravelGrid').datagrid('beginEdit', index); //当前行开启编辑       
        }
    }
    function RemRecd(){
       var rows = $('#TravelGrid').datagrid("getSelections");
        if(rows.length<1){
           $.messager.popover({
                msg: '请先选中要删除的数据!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
        }else{
            $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
                if(t){
                    for (i=0;i<rows.length;i++) {
                        var rowid = "";
                        rowid = rows[i].rowid;
                        if(rowid>0){
                            $.m({
                                ClassName:'herp.budg.hisui.udata.ubudgcostclaimapplytravel',MethodName:'Delete',rowid:rowid},
                                function(Data){
                                    if(Data==0){
                                        $.messager.popover({
                                            msg: '删除成功！',
                                            type:'success',
                                            showType:'show',
                                            style:{
                                                "position":"absolute", 
                                                "z-index":"9999",
                                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                                top:10
                                            }               
                                        });
                                        $('#TravelGrid').datagrid("reload")
                                    }else{
                                        $.messager.popover({
                                            msg: '错误信息:' +Data,
                                            type:'error',
                                            showType:'show',
                                            style:{
                                                "position":"absolute", 
                                                "z-index":"9999",
                                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                                top:10
                                            }               
                                        });
                                        $('#TravelGrid').datagrid("reload");
                                    }
                                }
                            );
                        }  
                    }                          
                }                     
            })
        }            
    }
    function checkBefSave() {
        var ret = 0;
        var message = "";
        store= $('#TravelGrid').datagrid('getRows');
        for (i=0;i<store.length;i++){
            $('#TravelGrid').datagrid('endEdit',i);
            r=$('#TravelGrid').datagrid('getRows')[i];
            if(!r.startDT){
                ret = 1;
                message = "出发时间不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.endDT) {
                ret = 1;
                message = "结束时间不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.startAddr) {
                ret = 1;
                message = "起始地点不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.endAddr) {
                ret = 1;
                message = "出差地点不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.travelTool) {
                ret = 1;
                message = "交通工具不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.travelFee) {
                ret = 1;
                message = "交通费不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
            if (!r.travelSheets) {
                ret = 1;
                message = "交通费票据张数不能为空!";
                // $.messager.alert('提示',message,'warning')
                return false;
            }
        }
        return true;
    }        
    //保存差旅费明细
    $("#TrSave").unbind('click').click(function(){
        // console.log("点击!");
        if (checkBefSave()) {
            var data = "";
            var totalFee = 0;
            var rowsData = $('#TravelGrid').datagrid('getRows');
            var rowCount = rowsData.length;
            // console.log(rowCount);
            if (rowCount > 0) {
                for (var i = 0; i < rowCount; i++) {                        
                    var r = rowsData[i];
                    var travelFee = r.travelFee != "" ? Number(r.travelFee) : 0;
                    var foodSubsidies = r.foodSubsidies != "" ? Number(r.foodSubsidies) : 0;
                    var stayFee = r.stayFee != "" ? Number(r.stayFee) : 0;
                    var inCityFee = r.inCityFee != "" ? Number(r.inCityFee) : 0;
                    var otherFee = r.otherFee != "" ? Number(r.otherFee) : 0;
                    var standByFirFee = r.standByFirFee != "" ? Number(r.standByFirFee) : 0;
                    var standBySecFee = r.standBySecFee != "" ? Number(r.standBySecFee) : 0;
                    var standByThiFee = r.standByThiFee != "" ? Number(r.standByThiFee) : 0;
                    //统计报销总金额
                    totalFee = Number(totalFee)
                         + Number(travelFee)
                         + Number(foodSubsidies)
                         + Number(stayFee)
                         + Number(inCityFee)
                         + Number(otherFee)
                         + Number(standByFirFee)
                         + Number(standBySecFee)
                         + Number(standByThiFee);
                    var stDT = r.startDT.split("/")[2]+"-"+r.startDT.split("/")[1]+"-"+r.startDT.split("/")[0];
                    var edDT = r.endDT.split("/")[2]+"-"+r.endDT.split("/")[1]+"-"+r.endDT.split("/")[0];
                    // console.log(stDT+"^"+edDT+"^"+"时间");
                    if (data == "") {
                        data = r.rowid + "&" + r.mainId
                             + "&" + stDT
                             + "&" + edDT
                             + "&" + r.startAddr + "&" + r.endAddr
                             + "&" + r.travelTool + "&" + r.travelFee + "&" + r.travelSheets
                             + "&" + r.foodSubsidies + "&" + r.foodSubsDays
                             + "&" + r.stayFee + "&" + r.stayDays + "&" + r.staySheets
                             + "&" + r.inCityFee + "&" + r.inCitySheets
                             + "&" + r.otherFee + "&" + r.otherSheets
                             + "&" + r.standByFirFee + "&" + r.standByFirShets
                             + "&" + r.standBySecFee + "&" + r.standBySecShets
                             + "&" + r.standByThiFee + "&" + r.standByThiShets
                             + "&" + r.reqFee + "&" + r.backFee + "&" + r.supplyFee
                    } else{
                        data = data + ";" + r.rowid + "&" + r.mainId
                             + "&" + stDT
                             + "&" + edDT
                             + "&" + r.startAddr + "&" + r.endAddr
                             + "&" + r.travelTool + "&" + r.travelFee + "&" + r.travelSheets
                             + "&" + r.foodSubsidies + "&" + r.foodSubsDays
                             + "&" + r.stayFee + "&" + r.stayDays + "&" + r.staySheets
                             + "&" + r.inCityFee + "&" + r.inCitySheets
                             + "&" + r.otherFee + "&" + r.otherSheets
                             + "&" + r.standByFirFee + "&" + r.standByFirShets
                             + "&" + r.standBySecFee + "&" + r.standBySecShets
                             + "&" + r.standByThiFee + "&" + r.standByThiShets
                             + "&" + r.reqFee + "&" + r.backFee + "&" + r.supplyFee
                    }
                }
                // $(reqtarget).val(totalFee);// 报销申请赋值
                $(reqtarget).text(totalFee);
                row['reqpay']=totalFee;                    
                $(infotarget).text(data);
                row['reqpaydetinfo']=data;
                if (checkBeforeSave() == true) {
                    saveOrder(); //保存方法
                } else {
                    return;
                }
            } else {
                $(infotarget).text("");
            }
            $AddTravel.window('close');
        }
    })
    //关闭差旅费明细窗口
    $("#TrClose").click(function(){$AddTravel.window('close');})
}