//
/**
 * 异常提醒
 * @author yongyang 2020-05-09
 */
(function(global, factory) {
    if (!global.AnaRegView) factory(global.AnaRegView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new AnaRegView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function AnaRegView(opt) {
        this.options = $.extend({ width: 1200, height: 500 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    AnaRegView.prototype = {
        constructor: AnaRegView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            /*var btn_save = $('<a href="#"></a>').linkbutton({
                text: '启动',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);*/
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            var htmlArr=[
                "<div id='regview' class='hisui-layout' data-options='fit:true'>",
                    "<div data-options='region:\"center\",border:false' style='padding:10px;'>",
                        "<table id='anaRegBox'></table>",
                        "<div id='anaRegTool'>",
                            "<form id='anaRegForm'>",
                                "<div class='form-row-group'>",
                                "<div><div class='form-row'>",
                                    "<div class='form-title-normal'>模板</div>",
                                    "<div class='form-item-normal'>",
                                        "<select id='regTemplate' class='hisui-combobox'></select>",
                                    "</div>",
                                    "<span class='form-btn'>",
                                        "<a href='#' class='hisui-linkbutton' id='btnSaveTemplate'>保存模板</a>",
                                    "</span>",
                                    "<span class='form-btn'>",
                                        "<a href='#' class='hisui-linkbutton' id='btnDelTemplate'>删除模板</a>",
                                    "</span>",
                                "</div></div>",
                                "</div>",
                                "<div class='form-row-group' style='padding:3px 0;'>",
                                    "<a href='#' class='hisui-linkbutton' id='btnBatchAddData'>保存数据</a>",
                                    "<a href='#' class='hisui-linkbutton' id='btnBatchDelData'>批量删除</a>",
                                "</div>",
                            "</form>",
                        "</div>",
                    "</div>",
                    "<div data-options='region:\"east\",border:false' style='width:360px;padding:10px 10px 10px 0;'>",
                        "<div id='operActionTabs' class='hisui-tabs tabs-gray'></div>",
                    "</div>",
                "</div>"
            ];

            this.dataContainer = $(htmlArr.join("")).appendTo(this.dom);
            //$.parser.parse(this.dom);
           $("#regview").layout();
            this.dom.dialog({
                right: 200,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '术中登记',
                modal: true,
                closed: true,
                resizable: true,
                iconCls: 'icon-w-msg',
                //buttons: buttons,
                onOpen: function() {
                    //$("#anaRegBox").datagrid("reload");
                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.initAnaRegBox();
            this.initOperActions();
        },

        initAnaRegBox:function(){
            var _this=this;
            $("#anaRegBox").datagrid({
                title:"术中登记",
                fit:true,
                headerCls:"panel-header-gray",
                toolbar:"#anaRegTool",
                iconCls:"icon-paper",
                rownumber:true,
                url: ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    param.ClassName=ANCLS.BLL.AnaestRecord;
                    param.QueryName="FindEventDrugDatas";
                    param.Arg1=session.RecordSheetID;
                    param.ArgCnt=1;
                },
                columns:[[
                    {field:"CheckStatus",title:"选择",checkbox:true},
                    {field:"DataItemDesc",title:"项目",width:120},
                    {field:"StartDT",title:"开始时间",width:160,editor:{type:"datetimebox"}},
                    {field:"EndDT",title:"开始时间",width:160,editor:{type:"datetimebox"}},
                    {field:"DoseQty",title:"剂量",width:80,editor:{type:"numberbox"}},
                    {field:"DoseUnit",title:"单位",width:80,editor:{type:"combobox"},formatter:function(value,row,index){
                        return row.DoseUnitDesc;
                    }}
                ]]
            });

            $("#anaRegBox").datagrid("enableCellEditing");

            $("#regTemplate").combobox({
                valueField:"RowId",
                textField:"Description",
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    param.ClassName=ANCLS.BLL.ConfigQueries;
                    param.QueryName="FindModuleTemplate";
                    param.Arg1=session.DeptID;
                    param.Arg2=session.UserID;
                    param.Arg3=session.ModuleID;
                    param.ArgCnt=3;
                },

                onSelect:function(record){
                    $("#anaRegBox").datagrid("reload");
                }
            });

            $("#btnSaveTemplate").linkbutton({
                iconCls:"icon-w-save",
                onClick:function(){

                }
            });

            $("#btnDelTemplate").linkbutton({
                iconCls:"icon-w-cancel",
                onClick:function(){

                }
            });

            $("#btnBatchDelData").linkbutton({
                iconCls:"icon-remove",
                plain:true,
                onClick:function(){

                }
            });

            $("#btnBatchAddData").linkbutton({
                iconCls:"icon-save",
                plain:true,
                onClick:function(){

                }
            });
        },

        initOperActions:function(){
            var eventDrugItems=[];
            if(this.options.categoryItems && this.options.categoryItems.length>0){
                for(var i=0;i<this.options.categoryItems.length;i++){
                    var categoryItem=this.options.categoryItems[i];
                    if(categoryItem.ItemCategory==="D" || categoryItem.ItemCategory==="E"){
                        if(categoryItem.ItemCategory==="D" && categoryItem.$dataCategory && categoryItem.$dataCategory.$mainCategory && categoryItem.$dataCategory.$mainCategory.$displayCategory){
                            categoryItem.GroupDesc= categoryItem.$dataCategory.$mainCategory.$displayCategory.title;
                        }else if(categoryItem.ItemCategory==="E"){
                            categoryItem.GroupDesc=categoryItem.CategoryDesc;
                        }
                        eventDrugItems.push(categoryItem);
                    }
                }
            }

            var itemGroups=dhccl.group(eventDrugItems,"ItemCategoryDesc");
            // $("#operActionsBox").datagrid({
            //     title: "事件与药品",
            //     fit:true,
            //     iconCls:"icon-paper",
            //     headerCls:"panel-header-gray",
            //     data:eventDrugItems,
            //     columns:[[
            //         {field:"CheckStatus",title:"选择",checkbox:true},
            //         {field:"ItemDesc",title:"项目",width:120},
            //     ]],
            //     view: groupview,
            //     groupField: "ItemCategoryDesc",
            //     groupFormatter: function (value, rows) {

            //         return value;
            //     }
            // });

            $("#operActionTabs").tabs({
                fit:true
            });

            for(var i=0;i<itemGroups.length;i++){
                var itemGroup=itemGroups[i];
                var firstItem=itemGroup.data[0];
                var boxId=firstItem.ItemCategory+"Box";
                $("#operActionTabs").tabs("add",{
                    title:itemGroup.id,
                    content:"<table id='"+boxId+"'></table>"
                });

                $("#"+boxId).datagrid({
                    border:false,
                    fit:true,
                    iconCls:"icon-paper",
                    headerCls:"panel-header-gray",
                    data:itemGroup.data, 
                    toolbar:"<div style='padding:3px 0'><a href='#' id='btnAdd"+firstItem.ItemCategory+"'>批量增加</a>",
                    columns:[[
                        {field:"CheckStatus",title:"选择",checkbox:true},
                        {field:"ItemDesc",title:"项目",width:120},
                    ]],
                    onDblClickRow:function(rowIndex,rowData){
                        var now=(new Date()).format("yyyy-MM-dd HH:mm");
                        $("#anaRegBox").datagrid("appendRow",{
                            DataItem:rowData.DataItem,
                            DataItemDesc:rowData.ItemDesc,
                            StartDT:now,
                            EndDT:now
                        });
                    }
                    // view: groupview,
                    // groupField: "ItemCategoryDesc",
                    // groupFormatter: function (value, rows) {

                    //     return value;
                    // }
                });

                $("#btnAdd"+firstItem.ItemCategory).linkbutton({
                    linkedBox:boxId,
                    iconCls:"icon-add",
                    plain:true,
                    onClick:function(){
                        var opts=$(this).linkbutton("options");
                        var checkedRows=$("#"+opts.linkedBox).datagrid("getChecked");
                        //var anaDatas=[];
                        var now=(new Date()).format("yyyy-MM-dd HH:mm");
                        for(var i=0;i<checkedRows.length;i++){
                            var checkedRow=checkedRows[i];
                            $("#anaRegBox").datagrid("appendRow",{
                                DataItem:checkedRow.DataItem,
                                DataItemDesc:checkedRow.ItemDesc,
                                StartDT:now,
                                EndDT:now
                            });
                        }

                        $("#"+opts.linkedBox).datagrid("clearChecked");
                    }
                });
            }

            $("#operActionTabs").tabs("add",{
                title:"事件明细"
            });

            $("#operActionTabs").tabs("select",0);
        },
        open: function() {
            this.dom.dialog('open'); 
        },
        close: function() {
            this.dom.dialog('close');
            if (this.onClose) this.onClose();
        },
        clear: function() {
        },
        save: function() {

        }
    }
}));