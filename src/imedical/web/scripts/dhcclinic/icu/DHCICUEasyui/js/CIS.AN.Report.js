/**
 * 报表类
 * @param {object} opts 报表选项
 */
function Report(opts){
    this.options=$.extend(opts,{});
}

Report.prototype={
    /**
     * 初始化报表
     */
    init:function(){
        this.dataBox=$("<table></table>").appendTo("body");
        this.toolbar=this.options.toolbar;
        if(!this.toolbar){
            var dateRange="";
            if(this.options.enableDateRange){
                var dateRangeArr=[
                    "<div class='form-title-normal'>",
                        "<input class='hisui-radio' type='radio' label='今日' name='DateRange' value='Day' data-options='radioClass:\"hischeckbox_square-blue\"'>",
                    "</div>",
                    "<div class='form-title-normal'>",
                        "<input class='hisui-radio' type='radio' label='本周' name='DateRange' value='Week' data-options='radioClass:\"hischeckbox_square-blue\"'>",
                    "</div>",
                    "<div class='form-title-normal'>",
                        "<input class='hisui-radio' type='radio' label='本月' name='DateRange' value='Month' data-options='radioClass:\"hischeckbox_square-blue\"'>",
                    "</div>",
                    "<div class='form-title-normal'>",
                        "<input class='hisui-radio' type='radio' label='本季' name='DateRange' value='Quarter' data-options='radioClass:\"hischeckbox_square-blue\"'>",
                    "</div>",
                    "<div class='form-title-normal'>",
                        "<input class='hisui-radio' type='radio' label='本年' name='DateRange' value='Year' data-options='radioClass:\"hischeckbox_square-blue\"'>",
                    "</div>"
                ];
                dateRange=dateRangeArr.join("");
            }
            var toolbarArr=[
                "<form id='toolbar'>",
                "<div class='form-row-group'>",
                    "<div>",
                        "<div class='form-row'>",
                            "<div class='form-title-normal'>开始日期</div>",
                            "<div class='form-item-normal'>",
                                "<input type='text' class='hisui-datebox' id='startDate'>",
                            "</div>",
                            "<div class='form-title-normal'>结束日期</div>",
                            "<div class='form-item-normal'>",
                                "<input type='text' class='hisui-datebox' id='endDate'>",
                            "</div>",
                            dateRange,
                        "</div>",
                    "</div>",
                "</div>",
                "<div class='form-row-group' style='padding:3px 0'>",
                    "<a href='#' class='hisui-linkbutton' iconCls='icon-search' plain='true' id='btnSearch'>查询</a>",
                    "<a href='#' class='hisui-linkbutton' iconCls='icon-export' plain='true' id='btnExport'>导出Excel</a>",
                "</div>",
                "</form>"
            ];


            this.toolbar="#toolbar";
            $(toolbarArr.join("")).appendTo("body");
        }
        this.initQueryOptions();
        this.initDataGrid();
        
    },

    /**
     * 初始化报表表格
     */
    initDataGrid:function(){
        var box=this.dataBox;

        box.datagrid({
            fit:true,
            iconCls:"icon-paper",
            headerCls:"panel-header",
            border:false,
            rownumbers: true,
            pagination: true,
            pageSize:50,
            pageList: [50, 100, 200,300,400,500],
            toolbar:this.toolbar,
            columns:this.options.columns,
            url:this.options.url,
            onBeforeLoad:this.options.onBeforeLoad
        });
    },

    /**
     * 初始化报表查询条件
     */
    initQueryOptions:function(){
        var _this=this;
        $(".hisui-radio").radio({
            onCheckChange:function(e,value){
                if(value){
                    _this.options.dateRange=$(this).val();
                    _this.initQueryDate();
                }
            }   
        });
        $("#btnSearch").linkbutton({
            onClick:function(){
                _this.dataBox.datagrid("reload");
            }
        });

        $("#btnExport").linkbutton({
            onClick:function(){
                var rows=_this.dataBox.datagrid("getRows");
                if (!rows || rows.length<1){
                    $.messager.alert("提示","请先选勾选需要导出的手术，再进行操作。","warning");
                    return;
                }
                var columnFields=_this.dataBox.datagrid("getColumnFields");
                if(!columnFields || columnFields.length<1) return;
                var aoa=[],     // array of array
                    fieldArray=[];
                for(var fieldInd=0;fieldInd<columnFields.length;fieldInd++){
                    var columnField=columnFields[fieldInd];
                    var columnOpts=_this.dataBox.datagrid("getColumnOption",columnField);
                    if(columnOpts.hidden || columnOpts.checkbox) continue;
                    fieldArray.push(columnOpts.title);
                }
                aoa.push(fieldArray);
                for(var i=0;i<rows.length;i++){
                    var row=rows[i],
                        valueArray=[];
                    for(var j=0;j<columnFields.length;j++){
                        var columnField=columnFields[j];
                        var columnOpts=_this.dataBox.datagrid("getColumnOption",columnField);
                        if(columnOpts.hidden || columnOpts.checkbox) continue;
                        valueArray.push(row[columnOpts.field] || '');
                    }
                    aoa.push(valueArray);
                }
                if (aoa.length>0 && window.excelmgr){
                    var timeStamp=moment().valueOf();
                    window.excelmgr.aoa2excel(aoa,_this.options.title+timeStamp+".xlsx");
                }
            }
        });

        _this.initQueryDate();
    },

    /**
     * 初始化报表日期
     */
    initQueryDate:function(){
        var _this=this;
        if(!_this.options.dateRange) _this.options.dateRange="Day";
        var startDate,endDate;
        switch(_this.options.dateRange){
            case "Year":
                startDate = moment().year(moment().year()).startOf('year').format('YYYY-MM-DD');
                endDate = moment().year(moment().year()).endOf('year').format('YYYY-MM-DD');
                break;
            case "Quarter":
                startDate = moment().quarter(moment().quarter()).startOf('quarter').format('YYYY-MM-DD');
                endDate = moment().quarter(moment().quarter()).endOf('quarter').format('YYYY-MM-DD');
                break;
            case "Month":
                startDate = moment().month(moment().month()).startOf('month').format('YYYY-MM-DD');
                endDate = moment().month(moment().month()).endOf('month').format('YYYY-MM-DD');
                break;
            case "Week":
                startDate = moment().week(moment().week()).startOf('week').format('YYYY-MM-DD');
                endDate = moment().week(moment().week()).endOf('week').format('YYYY-MM-DD');
                break;
            case "Day":
                startDate = moment().format('YYYY-MM-DD'); 
                endDate = moment().format('YYYY-MM-DD'); 
                break;
        }

        if(startDate && $("#startDate").length>0 && $("#startDate").datebox()){
            $("#startDate").datebox("setValue",startDate);
        }

        if(endDate && $("#endDate").length>0 && $("#endDate").datebox()){
            $("#endDate").datebox("setValue",endDate);
        }
    }
}