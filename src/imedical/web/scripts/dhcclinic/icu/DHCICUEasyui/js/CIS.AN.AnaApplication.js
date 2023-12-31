var app={
    opts:{},
    initPage:function(){
        var _this=app;
        _this.loadAppConfig();
        if(session.OPSID){
            _this.loadPatData();
            _this.initPatInfo();
            _this.loadAppData();
            _this.initAppInfo();
        }else{
            _this.loadPatData();
            _this.initNewAppDefValue();
            _this.initPatInfo();
        }
        _this.initFormOptions();
        operDataManager.setCheckChange();
    },

    initFormOptions:function(){
        var _this=app;
        if(_this.newApp!=="Y"){
            $("#btnPatList").remove();
        }

        $("#btnSave").linkbutton({
            onClick:function(){
                _this.saveApplication();
            }
        });

        $("#btnRefresh").linkbutton({
            onClick:function(){
                window.location.reload();
            }
        });

        $("#Anesthesiologist").combobox({
            valueField:"RowId",
            textField:"Description",
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=CLCLS.BLL.Admission;
                param.QueryName="FindCareProvByLoc";
                param.Arg1=param.q?param.q:"";
                param.Arg2=_this.opts.defANDept;
                param.ArgCnt=2;
            }
        });
    },

    /**
     * 初始化患者信息
     */
    initPatInfo:function(){
        var patData=this.opts.patData;
        if(patData){
            for(var key in patData){
                $("#"+key).text(patData[key]);
            }
        }
    },

    /**
     * 初始化申请信息
     */
    initAppInfo:function(){
        if(this.opts.appData){
            $("#appForm").form("load",this.opts.appData);
        }
        $("#ANDeptDesc").val(this.opts.appData.OperDeptDesc);
        $("#ANDept").val(this.opts.appData.OperDeptID);
        $("#OperNote").val(this.opts.appData.OperNote);
        $("#DrugAllergyNote").val(this.opts.appData.DrugAllergyNote);
        $("#AppDocPhoneNo").val(this.opts.appData.AppDocPhoneNo);
        if(this.opts.appData.DrugAllergy==="Y") $("#DrugAllergy2").checkbox("setValue",true);
        else if(this.opts.appData.DrugAllergy==="N") $("#DrugAllergy1").checkbox("setValue",true);
        if(this.opts.appData.Operation==="一般麻醉") $("#Operation1").checkbox("setValue",true);
        else if(this.opts.appData.Operation==="分娩镇痛") $("#Operation2").checkbox("setValue",true);
    },

    /**
     * 新申请默认值
     */
    initNewAppDefValue:function(){
        var anaDate=(new Date()).addDays(1).format("yyyy-MM-dd");
        $("#OperDate").datebox("setValue",anaDate);
        $("#AppDeptDesc").val(session.DeptDesc);
        $("#AppDeptID").val(session.DeptID);
        $("#AppCareProvID").val(session.CareProvID);
        $("#AppCareProvDesc").val(session.CareProvDesc);

        // 默认麻醉科
        var defAnaDeptInfo=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"GetDefANDeptInfo",session.DeptID);
        if(defAnaDeptInfo){
            var defAnaDeptArr=defAnaDeptInfo.split("^");
            $("#ANDeptDesc").val(defAnaDeptArr[1]);
            $("#ANDept").val(defAnaDeptArr[0]);
        }
        
    },

    /**
     * 加载手术申请配置
     */
    loadAppConfig:function(){
        var _this=app;
        var appOptsDatas=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetAppConfig",session.DeptID,session.EpisodeID,session.OPSID,session.HospID);
        if(appOptsDatas && appOptsDatas.length>0){
            _this.opts=$.extend(appOptsDatas[0],app.opts);
        }
    },

    /**
     * 加载患者信息
     */
    loadPatData:function(){
        if(session.EpisodeID){
            var patDataList=dhccl.getDatas(ANCSP.DataQuery,{
                ClassName:CLCLS.BLL.Admission,
                QueryName:"FindPatient",
                Arg1:session.EpisodeID,
                ArgCnt:1
            },"json");
            if(patDataList && patDataList.length>0){
                app.opts.patData=patDataList[0];
            }
        }
    },

    /**
     * 加载申请信息
     */
    loadAppData:function(){
        if(session.OPSID){
            var _this=app;
            var queryPara = [{
                ListName: "appDatas",
                ClassName: ANCLS.BLL.OperScheduleList,
                QueryName:"FindOperScheduleList",
                Arg1:"",
                Arg2:"",
                Arg3:"",
                Arg4:session.OPSID,
                ArgCnt:4
            },
            {
                ListName: "operList",
                ClassName:ANCLS.BLL.OperationList,
                QueryName:"FindPlanOperationList",
                Arg1:session.OPSID,
                ArgCnt:1
            }];

            var queryData = dhccl.getDatas(ANCSP.DataQueries, {
                jsonData: dhccl.formatObjects(queryPara)
            }, "json");
            if (queryData) {
                for (var key in queryData) {
                    _this.opts[key] = queryData[key];
                }
                if(_this.opts.appDatas && _this.opts.appDatas.length>0){
                    _this.opts.appData=_this.opts.appDatas[0]; 
                }
            }
        }
    },

    saveApplication:function(){
        var _this=app;
        var appData=$("#appForm").serializeJson();
        appData.EpisodeID=session.EpisodeID;
        appData.AppUserID=session.UserID;
        appData.OperDeptID=_this.opts.defANDept;
        appData.RowId=session.OPSID;

        var operDatas=operDataManager.getFormOperDatas(".operdata");
        if(operDatas && operDatas.length>0){
            for(var i=0;i<operDatas.length;i++){
                var operData=operDatas[i];
                appData[operData.DataItem]=operData.DataValue;
            }
        }

        appData.DrugAllergy=appData.DrugAllergy==="有"?"Y":"N";

        var dataPara=dhccl.formatObjects([appData]);
        var saveRet=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"SaveAnaApplication",dataPara);
        if (saveRet.indexOf("S^")===0){
            $.messager.popover({msg:"保存麻醉预约成功。",type:"success",timeout:1000});
        }else{
            $.messager.alert("提示","保存麻醉预约失败。原因："+saveRet,"error");
        }
    }
}

$(document).ready(app.initPage);