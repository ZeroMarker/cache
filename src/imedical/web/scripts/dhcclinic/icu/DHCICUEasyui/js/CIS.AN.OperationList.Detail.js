var operScheduleList={
    opts:{},
    /**
     * 初始化页面
     */
    initPage:function(){
        var _this=operScheduleList;
        _this.loadCommonData();
        _this.initSearchForm();
        _this.setDefValue();
        _this.list.initOperListBox();
    },

    /**
     * 初始化查询条件
     */
    initSearchForm:function(){
        var opts=this.opts;
        $("#AppDept").combobox({
            valueField:"RowId",
            textField:"Description",
            filter:function(q,row){
                var filterDesc=q.toUpperCase();
                var desc=row.Description.toUpperCase();
                var alias=row.Alias.toUpperCase();
                return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
            },
            data:opts.appDepts
        });

        $("#PatWard").combobox({
            valueField:"RowId",
            textField:"Description",
            filter:function(q,row){
                var filterDesc=q.toUpperCase();
                var desc=row.Description.toUpperCase();
                var alias=row.Alias.toUpperCase();
                return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
            },
            data:opts.patWards
        });

        $("#OperRoom").combobox({
            valueField:"RowId",
            textField:"Description",
            data:opts.operRooms
        });

        $("#OperStatus").combobox({
            valueField:"RowId",
            textField:"Description",
            data:opts.operStatus
        });

        $("#btnQuery").linkbutton({
            onClick:function(){
                $("#operlistBox").datagrid("reload");
            }
        });

        dhccl.parseDateFormat();

    },

    /**
     * 加载配置
     */
    loadConfig:function(){
        var _this=operScheduleList;
        var optsDataStr=dhccl.runServerMethodNormal(ANCLS.BLL.OperScheduleList,"GetOperListConfig",session.GroupID);
        var optsDatas=JSON.parse(optsDataStr);
        if(optsDatas && optsDatas.length>0){
            _this.opts=$.extend(optsDatas[0],_this.opts);
        }
    },

    /**
     * 加载公共数据
     */
    loadCommonData:function(){
        var _this=operScheduleList;
        var queryPara = [{
            ListName: "appDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1:"",
            Arg2:"INOPDEPT^OUTOPDEPT^EMOPDEPT",
            ArgCnt: 2
        },
        {
            ListName: "operRooms",
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindOperRoom",
            Arg1:"",
            Arg2:"R",
            ArgCnt: 2
        },
        {
            ListName: "operStatus",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperStatus",
            ArgCnt: 0
        },
        {
            ListName: "patWards",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindWard",
            ArgCnt: 0
        }];

        var queryData = dhccl.getDatas(ANCSP.DataQueries, {
            jsonData: dhccl.formatObjects(queryPara)
        }, "json");
        if (queryData) {
            for (var key in queryData) {
                _this.opts[key] = queryData[key];
            }
        }
    },

    /**
     * 设置查询条件默认值
     */
    setDefValue:function(){
        var todayDate=new Date();
        var startDate=todayDate.format("yyyy-MM-dd");
        var endDate=todayDate.format("yyyy-MM-dd");
        $("#OperStartDate").datebox("setValue",startDate);
        $("#OperEndDate").datebox("setValue",endDate);
        $("#AppDept").combobox("disable");
        $("#AppDept").combobox("setValue",session.DeptID);
    },

    /**
     * 手术列表处理对象
     */
    list:{
        editRow:{
            index:-1,
            data:null,
            field:null
        },
        /**
         * 初始化手术列表
         */
        initOperListBox:function(){
            var _this=operScheduleList.list;
            var columns=[[
                {field:"CheckStatus",title:"勾选",checkbox:true},
                {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
                    return "background-color:" + row.StatusColor + ";";
                }}, 
                {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
                    switch (row.SourceType) {
                        case "B":
                            return "background-color:"+SourceTypeColors.Book+";";
                        case "E":
                            return "background-color:"+SourceTypeColors.Emergency+";";
                        default:
                            return "background-color:white;";
                    }
                }},
                {field:"OperDate",title:"手术日期",width:100},
                {field:"OperRoomDesc",title:"手术间",width:69},
                {field:"OperSeq",title:"台次",width:60},
                {field:"PlanSeq",title:"拟台",width:45},
                {field:"PatName",title:"患者姓名",width:76},
                {field:"PatGender",title:"性别",width:45},
                {field:"PatAge",title:"年龄",width:50},
                {field:"PatDeptDesc",title:"科室",width:120},
                {field:"PrevDiagnosisDesc",title:"术前诊断",width:160},
                {field:"OperDesc",title:"手术名称",width:200},
                {field:"PlanSurgeonDesc",title:"主刀",width:62},
                {field:"PlanAsstDesc",title:"助手",width:80},
                {field:"ScrubNurseDesc",title:"器械护士",width:112},
                {field:"CircualNurseDesc",title:"巡回护士",width:112},
                {field:"AnaMethodDesc",title:"麻醉方法",width:160},
                {field:"AnesthesiologistDesc",title:"麻醉医生",width:80},
                {field:"AnaExpertDesc",title:"麻醉指导",width:80},
                {field:"AnaAssistant",title:"麻醉助手",width:120},
                {field:"InfectionOperDesc",title:"感染",width:48},
                {field:"OperPositionDesc",title:"体位",width:62},
                {field:"AntibiosisDesc",title:"抗生素",width:52},
                {field:"SurgicalMaterials",title:"特殊器械",width:80},
                {field:"HighConsume",title:"高值耗材",width:80},
                {field:"OperNote",title:"备注",width:120}
                
            ]];

            $("#operlistBox").datagrid({
                fit:true,
                title:"手术列表",
                headerCls:"panel-header-gray",
                iconCls:"icon-paper",
                rownumbers: true,
                pagination: true,
                pageSize: 300,
                pageList: [50, 100, 200,300,400,500],
                remoteSort: false,
                checkbox: true,
                checkOnSelect:true,
                selectOnCheck:false,
                singleSelect:true,
                toolbar:"#operlistTool",
                columns:columns,
                url:ANCSP.DataQuery,
                onBeforeLoad:function(param){
                    param.ClassName=ANCLS.BLL.OperScheduleList;
                    param.QueryName="FindOperScheduleList";
                    param.Arg1=$("#OperStartDate").datebox("getValue");
                    param.Arg2=$("#OperEndDate").datebox("getValue");
                    param.Arg3=session.DeptID;
                    param.Arg4="";
                    param.Arg5=$("#AppDept").combobox("getValue");
                    param.Arg6=$("#PatWard").combobox("getValue");
                    param.Arg7=$("#OperStatus").combobox("getValue");
                    param.Arg8=$("#OperRoom").combobox("getValue");
                    param.Arg9=$("#RegNo").val();
                    param.Arg10=$("#MedcareNo").val(); 
                    param.Arg11="";
                    param.Arg12="N";
                    param.Arg13="N";
                    param.ArgCnt=13;
                }
            });
        }
    }
}

$(document).ready(operScheduleList.initPage);






