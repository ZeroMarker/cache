/**
 * 报表查询条件
 * @param {object} opts 选项
 */
function StatQueryView(opts){
    this.options=opts;
}

StatQueryView.prototype={
    init:function(){
        this.queryItemCount=1;
        this.dom=$(this.options.panel);
        this.addQueryItem(this.queryItemCount);
    },

    getDomHtml:function(rowId){
        var htmlArr=[];
        htmlArr.push("<div id='queryItem"+rowId+"'><div class='form-row'>");
        htmlArr.push("<div class='form-item-normal'><select id='item"+rowId+"' type='text' class='hisui-combobox item' data-rowid='"+rowId+"' style='width:100px'></select></div>");
        htmlArr.push("<div class='form-item-normal'><select id='operator"+rowId+"' type='text' class='hisui-combobox operator' data-rowid='"+rowId+"' data-opertype='' style='width:80px'></select></div>");
        htmlArr.push("<div class='form-item-normal'><input id='value"+rowId+"' type='text' class='hisui-validatebox value textbox' data-rowid='"+rowId+"' style='width:100px'></div>");
        htmlArr.push("<div class='form-item-normal'><select id='logical"+rowId+"' type='text' class='hisui-combobox logical' data-rowid='"+rowId+"' style='width:80px'></select></div>");
        htmlArr.push("<span class='form-btn'><a id='remove"+rowId+"' href='#' class='hisui-linkbutton remove' data-rowid='"+rowId+"'></a></span>");
        htmlArr.push("<span class='form-btn'><a id='add"+rowId+"' href='#' class='hisui-linkbutton add' data-rowid='"+rowId+"'></a></span>");
        htmlArr.push("</div></div>");
        return htmlArr.join("");
    },

    initQueryItem:function(rowId){
        var _this=this;
        $("#item"+rowId).combobox({
            valueField:"value",
            textField:"text",
            editable:false,
            data:[{
                value:"RegNo",
                text:"登记号",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PatName",
                text:"患者姓名",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PatGender",
                text:"性别",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PatAge",
                text:"年龄",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.NumberOperator
            },{
                value:"PatHeight",
                text:"身高",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.Text
            },{
                value:"PatWeight",
                text:"体重",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.NumberOperator
            },{
                value:"ASAClassDesc",
                text:"ASA分级",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.EqualOperator
            },{
                value:"SourceTypeDesc",
                text:"手术类型",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.EqualOperator
            },{
                value:"PreFastingDesc",
                text:"术前禁食",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.EqualOperator
            },{
                value:"BloodType",
                text:"血型",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.EqualOperator
            },{
                value:"RHBloodType",
                text:"RHD",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.EqualOperator
            },{
                value:"PreOperNote",
                text:"术前特殊情况",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PrevDiagnosis",
                text:"术前诊断",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PlanOperDesc",
                text:"拟施手术",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PreMedication",
                text:"术前用药",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"OperPositionDesc",
                text:"手术体位",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"PostDiagnosis",
                text:"术后诊断",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"OperDesc",
                text:"实施手术",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"AnaestMethodDesc",
                text:"麻醉方式",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"SurCareProv",
                text:"手术医生",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"AnaCareProv",
                text:"麻醉医生",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"ScrubNurseDesc",
                text:"器械护士",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"CircualNurseDesc",
                text:"巡回护士",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            },{
                value:"OperPositionDesc",
                text:"术后去向",
                cls:"CIS.AN.OperSchedule",
                operator:StatArray.TextOperator
            }],
            onSelect:function(record){
                var rowId=$(this).attr("data-rowid");
                $("#operator"+rowId).combobox("loadData",record.operator);
                if(record.operator===StatArray.NumberOperator){
                    $("#operator"+rowId).attr("data-opertype","number");
                }else{
                    $("#operator"+rowId).attr("data-opertype","text");
                }
            }
        });

        $("#operator"+rowId).combobox({
            valueField:"value",
            textField:"text",
            editable:false
        });

        $("#logical"+rowId).combobox({
            valueField:"value",
            textField:"text",
            data:StatArray.LogicalData,
            editable:false
        });

        $("#remove"+rowId).linkbutton({
            iconCls:"icon-remove",
            plain:true,
            onClick:function(){
                var rowId=$(this).attr("data-rowid");
                $("#queryItem"+rowId).remove();
            }
        });

        $("#add"+rowId).linkbutton({
            iconCls:"icon-add",
            plain:true,
            onClick:function(){
                var rowId=_this.queryItemCount;
                // var domHtml=_this.getDomHtml(rowId);
                // $(domHtml).appendTo(_this.dom);
                // _this.initQueryItem(rowId);
                _this.addQueryItem(rowId);
            }
        });
    },

    addQueryItem:function(rowId){
        var _this=this;
        var domHtml=_this.getDomHtml(rowId);
        $(domHtml).appendTo(_this.dom);
        _this.initQueryItem(rowId);
        _this.queryItemCount+=1;
    }
}

StatArray={
    NumberOperator:[{
        value:0,
        text:"等于"
    },{
        value:1,
        text:"不等于"
    },{
        value:2,
        text:"大于"
    },{
        value:3,
        text:"小于"
    },{
        value:4,
        text:"大于等于"
    },{
        value:5,
        text:"小于等于"
    }],
    TextOperator:[{
        value:0,
        text:"等于"
    },{
        value:1,
        text:"不等于"
    },{
        value:2,
        text:"包含"
    },{
        value:3,
        text:"不包含"
    }],
    EqualOperator:[{
        value:0,
        text:"等于"
    },{
        value:1,
        text:"不等于"
    }],
    LogicalData:[{
        value:0,
        text:"且(and)"
    },{
        value:1,
        text:"或(or)"
    }]
};