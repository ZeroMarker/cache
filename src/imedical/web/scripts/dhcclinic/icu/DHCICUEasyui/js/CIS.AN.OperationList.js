var operScheduleList = {
  opts: {},
  /**
   * 初始化页面
   */
  initPage: function () {
    var _this = operScheduleList;
    _this.loadConfig();
    _this.loadCommonData();
    _this.initSearchForm();
    _this.initPatList();
    _this.setDefValue();
    _this.list.initOperListBox();
    _this.list.initBoxSetting();
    _this.list.initActionPermission();
  },

  /**
   * 初始化查询条件
   */
  initSearchForm: function () {
    var opts = this.opts;
    $("#AppDept,#patLoc").combobox({
      valueField: "RowId",
      textField: "Description",
      filter: function (q, row) {
        var filterDesc = q.toUpperCase();
        var desc = row.Description.toUpperCase();
        var alias = row.Alias.toUpperCase();
        return desc.indexOf(filterDesc) >= 0 || alias.indexOf(filterDesc) >= 0;
      },
      data: opts.appDepts,
    });

    $("#PatWard").combobox({
      valueField: "RowId",
      textField: "Description",
      filter: function (q, row) {
        var filterDesc = q.toUpperCase();
        var desc = row.Description.toUpperCase();
        var alias = row.Alias.toUpperCase();
        return desc.indexOf(filterDesc) >= 0 || alias.indexOf(filterDesc) >= 0;
      },
      data: opts.patWards,
    });

    $("#OperRoom").combobox({
      valueField: "RowId",
      textField: "Description",
      data: opts.operRooms,
    });

    $("#OperStatus").combobox({
      valueField: "RowId",
      textField: "Description",
      data: opts.operStatus,
    });

    $("#RegNo").keyup(function (e) {
      if (e.keyCode === 13) {
        var text = $(this).val();
        if (text && text.length < 10) {
          var zeroArr = [];
          for (var i = 0; i < 10 - text.length; i++) {
            zeroArr.push(0);
          }
          $(this).val(zeroArr.join("") + text);
        }
        operScheduleList.action.qryOperList();
      }
    });

    $("#MedcareNo").keyup(function (e) {
      if (e.keyCode === 13) {
        var text = $(this).val();
        if (text && text.length < 6) {
          var zeroArr = [];
          for (var i = 0; i < 6 - text.length; i++) {
            zeroArr.push(0);
          }
          $(this).val(zeroArr.join("") + text);
        }
        operScheduleList.action.qryOperList();
      }
    });
	
    $("#btnQuery").linkbutton({
      onClick: operScheduleList.action.qryOperList,
    });
    $("#btnClean").linkbutton({
      onClick: function () {
        $("#conditionForm").form("clear");
        operScheduleList.initSearchForm();
        operScheduleList.setDefValue();
      },
    });

    dhccl.parseDateFormat();
  },

  /**
   * 初始化患者列表
   */
  initPatList: function () {
    var columns = [
      [
        { field: "PatientID", title: "PatientID", width: 55, hidden: true },
        { field: "PAPMIName", title: "姓名", width: 100 },
        { field: "PAPMISex", title: "性别", width: 40 },
        { field: "Age", title: "年龄", width: 60 },
        { field: "PAAdmDepCodeDR", title: "科室", width: 140 },
        { field: "PAAdmWard", title: "病区", width: 140 },
        { field: "PAAdmBed", title: "床位", width: 60 },
        { field: "EpisodeID", title: "就诊号", width: 80 },
      ],
    ];

    $("#patientsList").datagrid({
      fit: true,
      singleSelect: true,
      pagination: true,
      iconCls: "icon-paper",
      headerCls: "panel-header-gray",
      url: ANCSP.DataQuery,
      toolbar: "#patListTool",
      rownumbers: true,
      border: true,
      bodyCls: "panel-body-gray",
      queryParams: {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocDocCurrentAdm",
        ArgCnt: 13,
      },
      onBeforeLoad: function (param) {
        var locId = $("#patLoc").combobox("getValue");
        param.Arg1 = locId;
        param.Arg2 = session.ExtUserID;
        param.Arg3 = "";
        param.Arg4 = "";
        param.Arg5 = "";
        param.Arg6 = $("#patientNo").val();
        param.Arg7 = "";
        param.Arg8 = "";
        locId == "" ? (param.Arg9 = "") : (param.Arg9 = "on");
        param.Arg10 = "";
        param.Arg11 = "on";
        param.Arg12 = ""; //$("#patWard").combobox("getValue");
        param.Arg13 = "";
      },
      columns: columns,
      onDblClickRow: function (rowIndex, rowData) {
        var patLocId = $("#patLoc").combobox("getValue");
        var patWardId = ""; //$("#patWard").combobox("getValue");
        var showDialog = "Y";
        var url =
          "cis.an.operapplication.csp?EpisodeID=" +
          rowData.EpisodeID +
          "&PatientID=" +
          rowData.PatientID +
          "&mradm=" +
          rowData.mradm +
          "&patLocId=" +
          patLocId +
          "&patWardId=" +
          patWardId +
          "&showDialog=" +
          showDialog;
        operScheduleList.dialog = new ANDialog({
          title: rowData.PAPMIName + "的手术申请",
          width: 1200,
          height: 800,
          iconCls: "icon-w-add",
          csp: url,
          queryParams: true,
        });
        $("#patListDialog").dialog("close");
        operScheduleList.dialog.open();
      },
    });

    $("#btnFindPatients").linkbutton({
      onClick: function () {
        $("#patientsList").datagrid("reload");
      },
    });

    $("#patLoc").combobox("setValue", session.DeptID);
  },

  /**
   * 加载配置
   */
  loadConfig: function () {
    var _this = operScheduleList;
    var optsDataStr = dhccl.runServerMethodNormal(
      ANCLS.BLL.OperScheduleList,
      "GetOperListConfig",
      session.GroupID
    );
    var optsDatas = JSON.parse(optsDataStr);
    if (optsDatas && optsDatas.length > 0) {
      _this.opts = $.extend(optsDatas[0], _this.opts);
    }
  },

  /**
   * 加载公共数据
   */
  loadCommonData: function () {
    var operDeptId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetDefOperDeptID","");
	var _this = operScheduleList;
    var queryPara = [
      {
        ListName: "appDepts",
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocationOld",
        Arg1: "",
        Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        ArgCnt: 2,
      },
      {
        ListName: "operRooms",
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: operDeptId,
        Arg2: "R",
        ArgCnt: 2,
      },
      {
        ListName: "operStatus",
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindOperStatus",
        ArgCnt: 0,
      },
      {
        ListName: "patWards",
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindWard",
        ArgCnt: 0,
      },
      {
        ListName: "anaMethodList",
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindAnaestMethod",
        Arg1: "",
        ArgCnt: 1,
      },
      {
        ListName: "careProvs",
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindCareProvByLoc",
        Arg1: "",
        Arg2: session.DeptID,
        Arg3: "N",
        ArgCnt: 3,
      },
      {
        ListName: "seqList",
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindDictDataByCode",
        Arg1: "OperSeq",
        ArgCnt: 1,
      },
    ];

    var queryData = dhccl.getDatas(
      ANCSP.DataQueries,
      {
        jsonData: dhccl.formatObjects(queryPara),
      },
      "json"
    );
    if (queryData) {
      for (var key in queryData) {
        _this.opts[key] = queryData[key];
      }
    }
  },

  /**
   * 设置查询条件默认值
   */
  setDefValue: function () {
    var todayDate = new Date();
    var qryCondition = operScheduleList.opts.QryCondition;
    var startDate = todayDate
      .addDays(qryCondition.startDate)
      .format("yyyy-MM-dd");
    var endDate = todayDate.addDays(qryCondition.endDate).format("yyyy-MM-dd");
    $("#OperStartDate").datebox("setValue", startDate);
    $("#OperEndDate").datebox("setValue", endDate);
    if (qryCondition.appDeptEnable === 0) {
      $("#AppDept").combobox("disable");
    }
    if (qryCondition.appDeptDefValue === 1) {
      $("#AppDept").combobox("setValue", session.DeptID);
    }
  },

  /**
   * 手术列表处理对象
   */
  list: {
    editRow: {
      index: -1,
      data: null,
      field: null,
    },
    /**
     * 初始化手术列表
     */
    initOperListBox: function () {
      var _this = operScheduleList.list;
      var _arrange = operScheduleList.arrange;
      var operRoomOptions = _arrange.getOperRoomOptions();
      // var scrubNurseOptions=_arrange.getScrubNurseOptions();
      var scrubNurseOptions = _arrange.getCareProvOptions(
        "ScrubNurseDesc",
        true
      );
      // var circualNurseOptions=_arrange.getCircualNurseOptions();
      var circualNurseOptions = _arrange.getCareProvOptions(
        "CircualNurseDesc",
        true
      );
      // var anaDocOptions=_arrange.getAnaDocOptions();
      // var anaExpertOptions=_arrange.getAnaExpertOptions();
      // var anaAssistantOptions=_arrange.getAnaAssistantOptions();
      var anaDocOptions = _arrange.getCareProvOptions(
        "AnesthesiologistDesc",
        false
      );
      var anaExpertOptions = _arrange.getCareProvOptions(
        "AnaExpertDesc",
        false
      );
      var anaAssistantOptions = _arrange.getCareProvOptions(
        "AnaAssistantDesc",
        true
      );
      var anaMethodOptions = _arrange.getAnaMethodOptions();
      var operSeqOptions = _arrange.getOperSeqOptions();
      var planOperSeqOptions = _arrange.getPlanOperSeqOptions();
      var columns = [
        [
          { field: "CheckStatus", title: "勾选", checkbox: true },
          {
            field: "StatusDesc",
            title: "状态",
            width: 50,
            styler: function (value, row, index) {
              return "background-color:" + row.StatusColor + ";color:white;text-align:center";
            },
          },
          {
            field: "SourceTypeDesc",
            title: "类型",
            width: 50,
            styler: function (value, row, index) {
              switch (row.SourceType) {
                case "B":
                  return "background-color:" + SourceTypeColors.Book + ";color:white;text-align:center";
                case "E":
                  return "background-color:" + SourceTypeColors.Emergency + ";color:white;text-align:center";
                default:
                  return "background-color:white;color:white;text-align:center";
              }
            },
          },
          { field: "OperDate", title: "手术日期", width: 100 },
          {
            field: "OperRoom",
            title: "手术间",
            width: 69,
            DescField: "RoomDesc",
            editor: { type: "combobox", options: operRoomOptions },
            formatter: function (value, row, index) {
              return row.RoomDesc;
            },
          },
          { field: "ArrPrintFlag", title: "打印", width: 48 },
          {
            field: "OperSeq",
            title: "台次",
            width: 60,
            editor: { type: "combobox", options: operSeqOptions },
          },
          {
            field: "PlanSeq",
            title: "申请台次",
            width: 76,
            editor: { type: "combobox", options: planOperSeqOptions },
          },
          { field: "PatName", title: "患者姓名", width: 76 },
          { field: "PatGender", title: "性别", width: 45 },
          { field: "PatAge", title: "年龄", width: 50 },
          { field: "PatBedCode",title:"床号",width:50},
          { field: "PatDeptDesc", title: "科室", width: 120 },
          { field: "PrevDiagnosisDesc", title: "术前诊断", width: 160, showTip:true, tipWidth:250, tipTrackMouse:true},
          { field: "OperDesc", title: "手术名称", width: 200, showTip:true, tipWidth:250, tipTrackMouse:true},
          { field: "SurgeonDesc", title: "主刀", width: 62 },
          { field: "AsstDesc", title: "助手", width: 80, showTip:true, tipWidth:250, tipTrackMouse:true},
          {
            field: "ScrubNurse",
            title: "器械护士",
            width: 112,
            DescField: "ScrubNurseDesc",
            editor: { type: "combobox", options: scrubNurseOptions },
            formatter: function (value, row, index) {
              return row.ScrubNurseDesc;
            }, showTip:true, tipWidth:250, tipTrackMouse:true
          },
          {
            field: "CircualNurse",
            title: "巡回护士",
            width: 112,
            DescField: "CircualNurseDesc",
            editor: { type: "combobox", options: circualNurseOptions },
            formatter: function (value, row, index) {
              return row.CircualNurseDesc;
            }, showTip:true, tipWidth:250, tipTrackMouse:true
          },
          {
            field: "AnaMethod",
            title: "麻醉方法",
            width: 160,
            DescField: "AnaMethodDesc",
            editor: { type: "combobox", options: anaMethodOptions },
            formatter: function (value, row, index) {
              return row.AnaMethodDesc;
            },
          },
          {
            field: "Anesthesiologist",
            title: "麻醉医生",
            width: 80,
            DescField: "AnesthesiologistDesc",
            editor: { type: "combobox", options: anaDocOptions },
            formatter: function (value, row, index) {
              return row.AnesthesiologistDesc;
            },
          },
          {
            field: "AnaExpert",
            title: "麻醉指导",
            width: 80,
            DescField: "AnaExpertDesc",
            editor: { type: "combobox", options: anaExpertOptions },
            formatter: function (value, row, index) {
              return row.AnaExpertDesc;
            },
          },
          {
            field: "AnaAssistant",
            title: "麻醉助手",
            width: 120,
            DescField: "AnaAssistantDesc",
            editor: { type: "combobox", options: anaAssistantOptions },
            formatter: function (value, row, index) {
              return row.AnaAssistantDesc;
            },
          },
          {
            field: "AnaStaff",
            title: "麻醉实习进修",
            width: 120,
            editor: { type: "validatebox" },
          },
          { field: "InfectionOperDesc", title: "感染", width: 48 },
          { field: "OperPositionDesc", title: "体位", width: 62, showTip:true, tipWidth:250, tipTrackMouse:true},
          { field: "AntibiosisDesc", title: "抗生素", width: 52 },
          { field: "SurgicalMaterials", title: "特殊器械", width: 80 },
          { field: "HighConsume", title: "高值耗材", width: 80 },
          //{field:"OperRequirementDesc",title:"备注",width:120},
          { field: "DaySurgery", title: "日间", width: 45 }, //202002+dyl
          { field: "IsCanDayOper", title: "日间准入", width: 80 }, //20210617+dyl
          { field: "OPAdmType", title: "门诊手术", width: 1, hidden: true }, //202003+dyl
          { field: "OperNote", title: "备注", width: 120, showTip:true, tipWidth:250, tipTrackMouse:true},
          { field: "OperRequirement",title:"手术要求",width:120, showTip:true, tipWidth:250, tipTrackMouse:true},
          { field: "ANFeeFlagDesc", title: "麻醉费用", width: 80 },
          { field: "OPFeeFlagDesc", title: "手术费用", width: 80 },
		  { field: "StandardDesc",  title: "医保名称", width: 120},
		  { field: "StandardCode",  title: "医保编码", width: 120},
          // {field:"OperRiskAssessment",title:"风险评估",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"手术风险评估");
          //     return ret;
          // }},
          // {field:"OperSafetyCheck",title:"安全核查",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"手术安全核查");
          //     return ret;
          // }},
          // {field:"OperCount",title:"手术清点",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"手术清点记录");
          //     return ret;
          // }},
          // {field:"AnaestConsent",title:"麻醉知情",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉知情同意书");
          //     return ret;
          // }},
          // {field:"PrevANVist",title:"麻醉前访视",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉前访视记录");
          //     return ret;
          // }},
          // {field:"PostANVisit",title:"麻醉后访视",width:90,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉后访视记录");
          //     return ret;
          // }},
          // {field:"AnaestRecord",title:"麻醉记录",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉记录");
          //     return ret;
          // }},
          // {field:"PACURecord",title:"麻醉恢复记录",width:104,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉恢复记录");
          //     return ret;
          // }},
          // {field:"AnaConclusion",title:"麻醉小结",width:80,formatter:function(value,row,index){
          //     var ret=_this.formatArchive(value,row,"麻醉小结");
          //     return ret;
          // }}
        ],
      ];

      var columnsConfig = dhccl.runServerMethod(
        "CIS.AN.BL.DataGrid",
        "GetDataColumns",
        session.ModuleID,
        "operlistBox",
        session.GroupID,
        session.UserID,
		window.location.host
      );
      _this.initColumns(columns[0], columnsConfig);

      _this.setColumnsEditor(columns[0]);

      $("#operlistBox").datagrid({
        fit: true,
        title: "手术列表",
        headerCls: "panel-header-gray",
        iconCls: "icon-paper",
        rownumbers: true,
        pagination: true,
        // view:scrollview,
        pageSize: 300,
        pageList: [50, 100, 200, 300, 400, 500],
        remoteSort: false,
        checkbox: true,
        checkOnSelect: false,
        selectOnCheck: false,
        singleSelect: true,  //选择行时只能单选，多选要选择勾选框，涉及患者信息写入头菜单的问题。 YL 20220120
        toolbar: "#operlistTool",
        columns: columns,
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.QueryName = "FindOperScheduleList";
          param.Arg1 = $("#OperStartDate").datebox("getValue");
          param.Arg2 = $("#OperEndDate").datebox("getValue");
          param.Arg3 = session.DeptID;
          param.Arg4 = "";
          param.Arg5 = $("#AppDept").combobox("getValue");
          param.Arg6 = $("#PatWard").combobox("getValue");
          param.Arg7 = $("#OperStatus").combobox("getValue")?$("#OperStatus").combobox("getValue"):(operScheduleList.opts.DefOperStatus);
          param.Arg8 = $("#OperRoom").combobox("getValue");
          param.Arg9 = $("#RegNo").val();
          param.Arg10 = $("#MedcareNo").val();
          param.Arg11 = "";
          param.Arg12 = $("#chkIsDayOper").checkbox("getValue") ? "Y" : "N";
          param.Arg13 = $("#IsOutOper").checkbox("getValue") ? "Y" : "N";
          param.Arg14 = "";
		  param.Arg15 = session.HospID;
          param.ArgCnt = 15;
        },
        onLoadError: function () {
          console.log("ABC");
        },
        onBeforeEdit: function (rowIndex, rowData) {
			if (operScheduleList.opts.CanArrangeStatus) {
				var arrangeStatusArr =
				operScheduleList.opts.CanArrangeStatus.split(",");
				if (!(arrangeStatusArr.indexOf(rowData.Status) >= 0)) return false;
				if (rowData.VisitStatus==="D") {
					$.messager.alert("提示","该患者已出院不能安排手术间","info");
					return false;
				}
				if (rowData.VisitStatus==="C") {
					$.messager.alert("提示","该患者已退号不能安排手术间","info");
					return false;
				}
			} else {
				return false;
			}
			_this.editRow.index = rowIndex;
			_this.editRow.data = rowData;
			console.log("onBeforeEdit:" + _this.editRow.field);
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
          if (changes) {
            // var arrangeData={
            //     OperRoom:rowData.OperRoom,
            //     OperSeq:rowData.OperSeq,
            //     ScrubNurse:rowData.ScrubNurse,
            //     CircualNurse:rowData.CircualNurse
            // };
            // var arrangeDataStr=dhccl.formatObjects([arrangeData]);
            // var arrangeRet=dhccl.runServerMethodNormal(ANCLS.BLL.OperArrange,"SaveOperListArrange",rowData.RowId,arrangeDataStr,session.UserID);
            // if(_this.editRow.field==="OperSeq" && !changes.OperSeq){
            //     changes.OperSeq=rowData.OperSeq;
            // }
            var arrangeCode = "",
              arrangeInfo = "",
              arrangeRet = "";
            if (
              changes.OperRoom ||
              changes.PlanOperSeq ||
              changes.OperSeq ||
              changes.ScrubNurse ||
              changes.CircualNurse
            ) {
              for (var key in changes) {
                arrangeCode = key;
                arrangeInfo = changes[key];
              }
              arrangeRet = dhccl.runServerMethodNormal(
                ANCLS.BLL.OperArrange,
                "ArrangeOperation",
                rowData.RowId,
                arrangeInfo,
                arrangeCode,
                session.UserID
              );
            } else if (
              changes.AnaMethod ||
              changes.AnaExpert ||
              changes.Anesthesiologist ||
              changes.AnaAssistant
            ) {
              for (var key in changes) {
                arrangeCode = key;
                arrangeInfo = changes[key];
              }
              arrangeRet = dhccl.runServerMethodNormal(
                ANCLS.BLL.OperArrange,
                "ArrangeAnaest",
                rowData.RowId,
                arrangeInfo,
                arrangeCode,
                session.UserID
              );
            }
            if (arrangeRet === "") return;
            if (arrangeRet.indexOf("S^") >= 0) {
            } else {
              $.messager.alert(
                "提示",
                "手术排班错误，原因：" + arrangeRet,
                "error"
              );
            }
          }
        },

        onClickRow: function (rowIndex, rowData) {
          // operScheduleList.endEdit("#operlistBox");
          // $(this).datagrid("beginEdit",rowIndex);
        },
        onCheck: function (rowIndex, rowData) {
          //$("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#000","background-color":"#fff"});
        },
        onSelect: function (rowIndex, rowData) {
          dhccl.setHeaderParam(rowData);     //选择勾选框时不允许将患者信息写入头菜单，选择行时才允许将患者信息写入头菜单。 YL 20220120
        },
        onUnselect: function (rowIndex, rowData) {
          // $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#000","background-color":"#fff"});
          // if(rowData && rowData.SourceType){
          //     switch(rowData.SourceType){
          //         case "B":
          //             $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":SourceTypeColors.Book});
          //             break;
          //         case "E":
          //             $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":SourceTypeColors.Emergency});
          //             break;
          //     }
          // }
          // $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='StatusDesc']").css({"color":"#000","background-color":""+rowData.StatusColor+""});
        },
        onLoadSuccess: function (data) {
          //setArchive();
        },

        onClickCell: function (rowIndex, field, value) {
          // if(field==="CheckStatus"){
          //     $(this).datagrid({singleSelect:false});
          // }else{
          //     $(this).datagrid({singleSelect:true});
          // }
          _this.editRow.field = field;
          console.log("onClickCell:", _this.editRow);
          if (
            !_this.editRow.data.OperSeq &&
            _this.editRow.data.OperRoom &&
            field === "OperSeq"
          ) {
            var editor = $(this).datagrid("getEditor", {
              index: _this.editRow.index,
              field: _this.editRow.field,
            });
            if (editor && editor.target) {
              var newSeq = operScheduleList.arrange.getNewSeq(
                _this.editRow.data.OperRoom
              );
              $(editor.target).combobox("setValue", newSeq);
              //_this.editRow.data.OperSeq=newSeq;
              //$(this).datagrid("acceptChanges");
            }
          }
        },
      });

      $("#operlistBox").datagrid("enableCellEditing");
    },

    initBoxSetting: function () {
      var testIcon = dhccl.runServerMethod(
        "CIS.AN.BL.OperScheduleList",
        "GetOperConfig",
        "OperListEdit"
      );
      if (testIcon.result == "Y") {
        $("#operlistBox").datagrid("enableGridSetting", {
          clickHandler: function (columnOptList) {
            var columnEditor = new DataGridEditor({
              title: "手术列表",
              data: columnOptList,
              moduleId: session.ModuleID,
              elementId: "operlistBox",
              closeCallBack: function () {
                window.location.reload();
              },
            });
            columnEditor.open();
          },
        });
      }
    },

    initColumns: function (columns, columnsConfig) {
      for (var i = 0; i < columns.length; i++) {
        for (var j = 0; j < columnsConfig.length; j++) {
          var test = columns[i].field;
          var test1 = columnsConfig[j].field;
          if (columns[i].field == columnsConfig[j].field) {
            if (columnsConfig[j].hidden == "true") columns[i].hidden = true;
            else columns[i].hidden = false;
            if (columnsConfig[j].sortable == "true") columns[i].sortable = true;
            else columns[i].sortable = false;
            columns[i].width = columnsConfig[j].width;
            columns[i].SeqNo = columnsConfig[j].SeqNo;
          }
        }
      }
      columns.sort(function (a, b) {
        return a.SeqNo - b.SeqNo;
      });
    },

    setColumnsEditor: function (columns) {
      if (columns && columns.length > 0) {
        var editColumnStr = operScheduleList.opts.OperListEditColumns;
        var editColumns = editColumnStr.split(",");
        for (var i = 0; i < columns.length; i++) {
          var column = columns[i];
          if (editColumns.indexOf(column.field) < 0) {
            column.editor = null;
          }
        }
      }
    },

    formatArchive: function (value, row, title) {
      if (value) {
        return (
          "<a href='javascript:void(0)' class='archived' data-url='" +
          value +
          "' data-title='" +
          row.PatName +
          "的" +
          title +
          "'>已归档</a>"
        );
      } else {
        return "未归档";
      }
    },
	initActionPermission: function () {
		var actionPermissions=dhccl.getDatas(ANCSP.DataQuery,{
			ClassName:ANCLS.BLL.ConfigQueries,
			QueryName:"FindActionPermission",
			Arg1:session.GroupID,
			Arg2:session.ModuleID,
			Arg3:"Y",
			ArgCnt:3
		},"json");
		var needAuditOperation=dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration,"GetValueByKey","NeedAuditOperation");
        var needAuditEMOperation=dhccl.runServerMethodNormal(ANCLS.BLL.DataConfiguration,"GetValueByKey","NeedAuditEMOperation");
        if(actionPermissions && actionPermissions.length>0){
			for(var i=0;i<actionPermissions.length;i++){
				var actionPermission=actionPermissions[i];
				if((actionPermission.ElementID=="btnAuditOperation")&(needAuditOperation!="Y")&(needAuditEMOperation!="Y")){
					$("#"+actionPermission.ElementID).remove();
				}
				if((actionPermission.ElementID=="btnCancelAudit")&(needAuditOperation!="Y")&(needAuditEMOperation!="Y")){
					$("#"+actionPermission.ElementID).remove();
				}
			}
			$(".hisui-linkbutton").each(function(index,item){
				var id=$(item).attr("id");
				var permission=getActionPermssion(id);
				if(!permission){
					$(item).remove();
				}
			});
		}else{
			$(".hisui-linkbutton").each(function(index,item){
				$(item).remove();
			});
		}
	},
	getActionPermssion: function (elID){
		var result=null;
        if(actionPermissions && actionPermissions.length>0){
            for(var actionIndex=0;actionIndex<actionPermissions.length;actionIndex++){
                permission=actionPermissions[actionIndex];
                if(permission.ElementID===elID){
                    result=permission;
                }
            }
        }
        return result;
    }
  },

  /**
   * 操作按钮处理对象
   */
  action: {
    /**
     * 新增手术申请
     */
    addOperation: function () {
      // var url="CIS.AN.OperApplication.New.csp?showDialog=Y&EpisodeID=";
      //window.open(url);
      // dhccl.showModalDialog(url,1200,800,function(ret){
      //     $("#operlistBox").datagrid("reload");
      // });
      // var dialog=new ANDialog({
      //     title:"手术申请",
      //     width:1200,
      //     height:800,
      //     iconCls:"icon-w-add",
      //     csp:url,
      //     queryString:"&showDialog=Y"
      // });
      // dialog.open();
      $("#patListDialog").dialog("open");
    },

    /**
     * 修改手术申请
     */
    editOperation: function () {
      var rowData = $("#operlistBox").datagrid("getSelected");
      if (!rowData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }

      var canEditOperation = dhccl.runServerMethodNormal(
        ANCLS.BLL.OperApplication,
        "CanEditOperation",
        rowData.OPSID,
        session.UserID,
        session.GroupID,
        "btnEditOperation"
      );
      if (canEditOperation.indexOf("E^") === 0) {
        $.messager.alert("提示", canEditOperation, "warning");
        return;
      }
      var patLocId = $("#patLoc").combobox("getValue");
      var patWardId = ""; //$("#patWard").combobox("getValue");
      var showDialog = "Y";
      var url =
        "cis.an.operapplication.csp?opsId=" +
        rowData.OPSID +
        "&opaId=" +
        rowData.OPAID +
        "&EpisodeID=" +
        rowData.EpisodeID +
        "&PatientID=" +
        rowData.PatientID +
        "&mradm=" +
        rowData.mradm +
        "&patLocId=" +
        patLocId +
        "&patWardId=" +
        patWardId +
        "&showDialog=" +
        showDialog +
        "&moduleCode=AN_OPA_001";
      operScheduleList.dialog = new ANDialog({
        title: rowData.PatName + "的手术申请",
        width: 1200,
        height: 600,
        iconCls: "icon-w-edit",
        csp: url,
        queryParams: true,
      });
      operScheduleList.dialog.open();
    },
    /**
     * 取消手术申请
     */
    cancelOperation: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再取消手术。", "warning");
        return;
      }
      var selectedRows = $("#operlistBox").datagrid("getSelections");
      if (selectedRows && selectedRows.length > 1) {
        $.messager.alert(
          "提示",
          "请选择单条手术进行操作，不能取消多条。",
          "warning"
        );
        return;
      }
	  //临床入径管理
	  CheckExitCPW(selectedData.EpisodeID,selectedData.Operation);
	  var canCancelOperation = dhccl.runServerMethodNormal(
		ANCLS.BLL.OperApplication,
		"CanCancelOperation",
		selectedData.OPSID,
		session.UserID,
		session.GroupID,
		"btnCancelOperation"
	  );
	  if (canCancelOperation.indexOf("E^") === 0) {
		$.messager.alert("提示", canCancelOperation, "warning");
		return;
	  }
	  $.messager.confirm("提示", "请先确认是否已经联系病区护士取消医嘱执行(医嘱ID为："+selectedData.OeoreID+"),否则无法取消手术", function (r) {
		if (r) {
		  // $("#operCancelReason").dialog("open");
		  var reason = new Reason({
			title: "手术取消原因",
			reasonHandle: function (reason) {
			  var ret = dhccl.runServerMethodNormal(
				ANCLS.BLL.OperScheduleList,
				"CancelOperation",
				selectedData.OPSID,
				reason,
				session.UserID
			  );
			  if (ret.indexOf("S^") === 0) {
				$.messager.popover({
				  msg: "手术取消成功",
				  timeout: 1500,
				  type: "success",
				});
				$("#operlistBox").datagrid("reload");
			  } else {
				$.messager.alert("提示", "手术取消失败，原因：" + ret, "error");
			  }
			},
		  });
		  reason.open();
		  var ret = SignTool.signData("revokeOperList", selectedRows, function(userCertCode, signCode, hashData, signedData, certNo){
			var opsId = selectedData.OPSID;
			var recordSheetID=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetRecordSheetIdByModCode", opsId, session.ModuleCode, session.ExtUserID);
			var saveRet = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "Sign", recordSheetID, userCertCode, signCode, hashData, signedData, "", certNo);
			if (saveRet.indexOf("S^") === 0) {
				$.messager.popover({
					msg: "签名成功!",
					type: "success"
				});
			} else {
				$.messager.alert("提示", "签名失败，原因：" + saveRet, "error");
			}
		  });
		}else{
			return;
		}
	  })
    },

    /**
     * 审核手术申请
     */
    auditOperation: function () {
      var selectedRows = $("#operlistBox").datagrid("getChecked");
      if (!selectedRows || selectedRows.length < 1) {
        $.messager.alert("提示", "请勾选手术记录，再审核手术。", "warning");
        return;
      }
      var needAuditOperation = dhccl.runServerMethodNormal(
        ANCLS.BLL.DataConfiguration,
        "GetValueByKey",
        "NeedAuditOperation"
      );
      var needAuditEMOperation = dhccl.runServerMethodNormal(
        ANCLS.BLL.DataConfiguration,
        "GetValueByKey",
        "NeedAuditEMOperation"
      );
      var opsIdArr = [];
      var operRows = ""; //20191211 YuanLin 只有申请状态的手术允许审核
      var operAuditRows = ""; //20200610 YuanLin 手术申请是否审核配置为【是】时才允许审核
      for (var i = 0; i < selectedRows.length; i++) {
        if (selectedRows[i].StatusDesc != "申请") {
          if (operRows == "") operRows = i + 1;
          else operRows = operRows + "," + (i + 1);
          continue;
        } else {
          if (
            (selectedRows[i].SourceType == "E" &&
              needAuditEMOperation == "N") ||
            (selectedRows[i].SourceType == "B" && needAuditOperation == "N")
          ) {
            if (operAuditRows == "") operAuditRows = i + 1;
            else operAuditRows = operAuditRows + "," + (i + 1);
            continue;
          }
        }
        opsIdArr.push(selectedRows[i].OPSID);
      }
      var opsIdStr = opsIdArr.join(";");
      //var canAudit=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CanAuditOperation",opsIdStr);
      //if(canAudit.indexOf("N^")===0){
      //$.messager.alert("提示",canAudit,"warning");
      //return;
      //}
      $.messager.confirm("提示", "是否审核勾选的手术？", function (r) {
        if (!r) return;
        var ret = dhccl.runServerMethod(
          ANCLS.BLL.OperApplication,
          "AuditOperation",
          opsIdStr,
          session.UserID
        );
        if (ret.success) {
          if (operRows == "")
            $.messager.popover({
              msg: "审核手术成功",
              type: "success",
              timeout: 1500,
            });
          if (operRows != "") {
            $.messager.alert("提示", "其余手术审核成功", "info");
            $.messager.alert(
              "提示",
              "其中所勾选手术中第" + operRows + "条手术非申请状态不予审核!",
              "warning"
            );
          }
          if (operAuditRows != "")
            $.messager.alert(
              "提示",
              "其中所勾选手术中第" +
                operAuditRows +
                "条手术无审核权限，需修改审核配置为【是】",
              "warning"
            );
          $("#operlistBox").datagrid("reload");
          $("#operlistBox").datagrid("clearChecked");
        } else {
          $.messager.alert(
            "提示",
            "审核手术失败，原因：" + ret.result,
            "error"
          );
          if (operRows != "")
            $.messager.alert(
              "提示",
              "所勾选手术中第" + operRows + "条手术非申请状态不予审核!",
              "warning"
            );
          if (operAuditRows != "")
            $.messager.alert(
              "提示",
              "所勾选手术中第" +
                operAuditRows +
                "条手术无审核权限，需修改审核配置为【是】",
              "warning"
            );
        }
      });
    },

    /**
     * 取消审核手术申请
     */
    cancelAudit: function () {
      var selectedRows = $("#operlistBox").datagrid("getChecked");
      if (!selectedRows || selectedRows.length < 1) {
        $.messager.alert("提示", "请勾选手术记录，再取消审核手术。", "warning");
        return;
      }

      $.messager.confirm("提示", "是否取消审核勾选的手术？", function (r) {
        if (!r) return;
        var opsIdArr = [];
        for (var i = 0; i < selectedRows.length; i++) {
          if (selectedRows[i].StatusCode !== "Audit") continue;
          opsIdArr.push(selectedRows[i].OPSID);
        }
        var opsIdStr = opsIdArr.join(";");
        if (opsIdStr === "") {
          $.messager.alert(
            "提示",
            "没有[审核]状态的手术，请重新勾选。",
            "warning"
          );
          return;
        }
        var ret = dhccl.runServerMethod(
          ANCLS.BLL.OperApplication,
          "CancelAudit",
          opsIdStr,
          session.UserID
        );
        if (ret.success) {
          $.messager.popover({
            msg: "取消审核手术成功",
            type: "success",
            timeout: 1500,
          });
          $("#operlistBox").datagrid("reload");
          $("#operlistBox").datagrid("clearChecked");
        } else {
          $.messager.alert(
            "提示",
            "取消审核手术失败，原因：" + ret.result,
            "error"
          );
        }
      });
    },

    finishOperation: function () {
      var selectedRows = $("#operlistBox").datagrid("getChecked");
      if (!selectedRows || selectedRows.length < 1) {
        $.messager.alert("提示", "请先勾选手术，再批量完成。", "warning");
        return;
      }

      $.messager.confirm("提示", "是否批量完成勾选的手术？", function (r) {
        var opsIdArr = [];
        for (var i = 0; i < selectedRows.length; i++) {
          opsIdArr.push(selectedRows[i].OPSID);
        }
        var opsIdStr = opsIdArr.join("^");
        var ret = dhccl.runServerMethod(
          ANCLS.BLL.OperApplication,
          "BatchFinishOperation",
          opsIdStr,
          session.UserID
        );
        if (ret.success) {
          $.messager.popover({
            msg: "批量完成手术成功",
            type: "success",
            timeout: 1000,
          });
          $("#operlistBox").datagrid("reload");
          $("#operlistBox").datagrid("clearChecked");
        } else {
          $.messager.alert(
            "提示",
            "批量完成手术失败，原因：" + ret.result,
            "error"
          );
        }
      });
    },
    sendPhoneMessage: function () {
      var selectedRows = $("#operlistBox").datagrid("getChecked");
      if (!selectedRows || selectedRows.length < 1) {
        $.messager.alert("提示", "请勾选手术记录，再发送短信。", "warning");
        return;
      }
      var opsIdArr = [];
      for (var i = 0; i < selectedRows.length; i++) {
        opsIdArr.push(selectedRows[i].OPSID);
      }
      var opsIdStr = opsIdArr.join("^");
      var url = "an.phonemessage.csp?opsIdStr=" + opsIdStr;
      websys_showModal({
        title: "发送短信",
        iconCls: "icon-w-msg",
        url: url,
        width: "800",
        height: "614",
      });
    },
    operFollowup: function () {
        var selectedData=$("#operlistBox").datagrid("getSelected");
        if(!selectedData){
            $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
            return;
        }
        if(!selectedData.DaySurgery)
		{
			$.messager.alert("提示","只能操作日间手术。","warning");
			return; 
        }
		var actionPermission = operationListConfig.getActionPermission(session.GroupID,session.ModuleID,"btnOperFollowup");
		if(actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0)
		{
			$.messager.alert("提示","当前安全组或当前状态无权限。","warning");
			return;
		}
        var url="CIS.AN.OperFollowupDayCommon.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
        
        var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
        $("#operFollowup").dialog({
            content:href,
            title:selectedData.PatName+"的术后随访",
            iconCls:"icon-w-edit",
          resizable:true,
        height:667
        });
        
        $("#operFollowup").dialog("open");
    
    
    },
//202109+dyl退出日间
quitDaySurgery: function () {
  var selectedData=$("#operlistBox").datagrid("getSelected");
  if(!selectedData){
      $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
      return;
  }
  if((selectedData.StatusDesc!="日间")||(selectedData.StatusDesc!="完成")||(selectedData.StatusDesc!="申请"))
  {
if(selectedData.DaySurgery!="Y")
{
      $.messager.alert("提示","只能操作日间、申请或完成状态的日间手术。","warning");
      return; 
}
  }
  var url="CIS.AN.DaySurgeryDecline.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
  
  var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
  $("#DaySurgeryEst").dialog({
      content:href,
      title:selectedData.PatName+"退出日间",
      iconCls:"icon-w-cancel",
    resizable:true,
    width:360,
  height:370
  });
  
  $("#DaySurgeryEst").dialog("open");

},


    /**
     * 关联电子病历文书
     */
    linkEMRecords: function () {
      var selectedRow = $("#operlistBox").datagrid("getSelected");
      if (!selectedRow) {
        $.messager.alert(
          "提示",
          "请先选择一条手术记录，再进行关联。",
          "warning"
        );
      } else {
        var actionPermission = operationListConfig.getActionPermission(
          session.GroupID,
          session.ModuleID,
          "btnLinkEMRecords"
        );
        if (
          actionPermission.OperStatusCode.indexOf(selectedRow.StatusCode) < 0
        ) {
          $.messager.alert(
            "提示",
            "当前安全组或当前状态无关联病历的权限。",
            "warning"
          );
          return;
        }
        var view = new EMRLinkView({
          title: "关联病历",
          PrevAnaMethodDesc: selectedRow.PrevAnaMethodDesc,
          OperClass: selectedRow.OperClassDesc,
          EpisodeID: selectedRow.EpisodeID,
          OPSID: selectedRow.OPSID,
          OPAID: selectedRow.OPAID,
          SourceType: selectedRow.SourceType,
        });
        if (needLinkEMR) {
          view.open();
        } else {
          $.messager.alert("提示", "不满足管控条件", "info");
        }
      }
    },

    /**
     * 导出手术列表
     */
    exportOperList: function () {
      var rows = $("#operlistBox").datagrid("getChecked");
      if (!rows || rows.length < 1) {
        $.messager.alert(
          "提示",
          "请先选勾选需要导出的手术，再进行操作。",
          "warning"
        );
        return;
      }
      var columnFields = $("#operlistBox").datagrid("getColumnFields");
      if (!columnFields || columnFields.length < 1) return;
      var aoa = [], // array of array
        fieldArray = [];
      for (var fieldInd = 0; fieldInd < columnFields.length; fieldInd++) {
        var columnField = columnFields[fieldInd];
        var columnOpts = $("#operlistBox").datagrid(
          "getColumnOption",
          columnField
        );
        fieldArray.push(columnOpts.title);
      }
      aoa.push(fieldArray);
      for (var i = 0; i < rows.length; i++) {
        var row = rows[i],
          valueArray = [];
        for (var j = 0; j < columnFields.length; j++) {
          var columnField = columnFields[j];
          var columnOpts = $("#operlistBox").datagrid(
            "getColumnOption",
            columnField
          );
          if (
            columnOpts.DescField &&
            columnOpts.DescField !== "" &&
            columnOpts.DescField !== columnOpts.field
          ) {
            if (columnOpts.DescField === "RoomDesc")
              var NewField = columnOpts.DescField;
            else var NewField = columnOpts.field + "Desc";
            valueArray.push(row[NewField] || "");
          } else {
            valueArray.push(row[columnOpts.field] || "");
          }
        }
        aoa.push(valueArray);
      }
      if (aoa.length > 0 && window.excelmgr) {
        window.excelmgr.aoa2excel(aoa, "手术列表.xlsx");
      }
    },

    /**
     * 打印手术列表
     */
    printOperList: function () {
      var rows = $("#operlistBox").datagrid("getChecked");
      if (!rows || rows.length < 1) {
        $.messager.alert(
          "提示",
          "请先选勾选需要打印的手术，再进行操作。",
          "warning"
        );
        return;
      }
      //var Auditret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"CheckIsNeedAuditAudit");
      var needAuditOperation = dhccl.runServerMethodNormal(
        ANCLS.BLL.DataConfiguration,
        "GetValueByKey",
        "NeedAuditOperation"
      );
      var needAuditEMOperation = dhccl.runServerMethodNormal(
        ANCLS.BLL.DataConfiguration,
        "GetValueByKey",
        "NeedAuditEMOperation"
      );
      var canPrintRows = [];
      var opsIdArr = [];
      for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        const row = rows[rowIndex];
        if (row.StatusCode !== "Application" && row.StatusCode !== "Audit")
          continue;
        if (
          needAuditOperation == "Y" &&
          row.StatusCode !== "Audit" &&
          row.SourceType == "B"
        )
          continue;
        if (
          needAuditEMOperation == "Y" &&
          row.StatusCode !== "Audit" &&
          row.SourceType == "E"
        )
          continue;
        // alert(row.StatusCode)
        canPrintRows.push(row);
        opsIdArr.push(row.OPSID);
      }

      if (
        (!canPrintRows || canPrintRows.length < 1) &&
        needAuditOperation !== "Y"
      ) {
        $.messager.alert("提示", "只能打印申请或审核状态的手术。", "warning");
        return;
      }
      if (
        (!canPrintRows || canPrintRows.length < 1) &&
        needAuditOperation == "Y"
      ) {
        $.messager.alert("提示", "只能打印审核状态的手术。", "warning");
        return;
      }
      var firstRow = canPrintRows[0];

      var LODOP = getLodop();
      LODOP.PRINT_INIT("手术通知单");
      // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "SSS");
      LODOP.SET_PRINT_PAGESIZE("2", "", "", "A4");
	  LODOP.ADD_PRINT_TEXT(10, 300, 500, 60, session.HospDesc);
	  LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
	  LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
	  LODOP.SET_PRINT_STYLEA(0, "Bold",1);
      LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	  LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
      LODOP.ADD_PRINT_TEXT(40, 300, 500, 40, session.DeptDesc + "手术通知单");
      LODOP.SET_PRINT_STYLEA(0, "FontName", "宋体");
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
      LODOP.SET_PRINT_STYLEA(0, "Bold",1);
      LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
      LODOP.ADD_PRINT_TEXT(75, 20, "100%", 28, "科室：" + session.DeptDesc);
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_TEXT(75, 300, "100%", 28, "日期：" + firstRow.OperDate);
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_TEXT(
        75,
        700,
        "100%",
        28,
        "总计：" + canPrintRows.length + "台手术"
      );
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_HTM(
        75,
        900,
        "100%",
        28,
        "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>"
      );
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);

      var columns = [
        {
          title: "姓名",
          field: "PatName",
          width: 30,
          uom: "pt",
        },
        {
          title: "性别",
          field: "PatGender",
          width: 30,
          uom: "pt",
        },
        {
          title: "年龄",
          field: "PatAge",
          width: 30,
          uom: "pt",
        },
        {
          title: "病区",
          field: "PatWardDesc",
          width: 84,
          uom: "pt",
        },
        {
          title: "床位",
          field: "PatBedCode",
          width: 30,
          uom: "pt",
        },
        {
          title: "台次",
          field: "PlanOperSeq",
          width: 30,
          uom: "pt",
        },
        {
          title: "术前诊断",
          field: "PrevDiagnosisDesc",
          width: 84,
          uom: "pt",
        },
        {
          title: "手术名称",
          field: "OperDesc",
          width: 136,
          uom: "pt",
        },
        {
          title: "主刀",
          field: "SurgeonDesc",
          width: 45,
          uom: "pt",
        },
        {
          title: "助手",
          field: "AsstDesc",
          width: 84,
          uom: "pt",
        },
        {
          title: "感染",
          field: "InfectionOperDesc",
          width: 30,
          uom: "pt",
        },
        {
          title: "抗生素",
          field: "AntibiosisDesc",
          width: 45,
          uom: "pt",
        },
        {
          title: "器械",
          field: "SurgicalMaterials",
          width: 84,
          uom: "pt",
        },
        {
          title: "耗材",
          field: "HighConsume",
          width: 84,
          uom: "pt",
        },
        {
          title: "备注",
          field: "OperNote",
          width: 84,
          uom: "pt",
        },
      ];

      var totalWidth = 0;
      for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const element = columns[columnIndex];
        totalWidth += element.width;
      }
      var htmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style>",
        "<table style='" + totalWidth + "pt'><thead><tr>",
      ];

      for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
        const column = columns[columnIndex];
        htmlArr.push(
          "<th width='" +
            column.width +
            column.uom +
            "'>" +
            column.title +
            "</th>"
        );
      }

      htmlArr.push("</tr></thead><tbody>");

      for (var rowIndex = 0; rowIndex < canPrintRows.length; rowIndex++) {
        const row = canPrintRows[rowIndex];
        htmlArr.push("<tr>");
        for (var columnIndex = 0; columnIndex < columns.length; columnIndex++) {
          const column = columns[columnIndex];
          //if((column.field==="SurgicalMaterials")&&(row["Requirement"]!=="")){
          //htmlArr.push("<td>"+(row["Requirement"].split(";")[1] || '')+"</td>");
          //}else if((column.field==="HighConsume")&&(row["Requirement"]!=="")){
          //htmlArr.push("<td>"+(row["Requirement"].split(";")[2] || '')+"</td>");
          //}else{
          htmlArr.push("<td>" + (row[column.field] || "") + "</td>");
          //}
        }
        htmlArr.push("</tr>");
      }
      htmlArr.push("</tbody></table>");
      LODOP.ADD_PRINT_TABLE(
        105,
        20,
        "100%",
        "100%",
        htmlArr.join("")
      );
      LODOP.PREVIEW();
      var res = dhccl.runServerMethodNormal(
        ANCLS.BLL.OperArrange,
        "SaveTicketPrintFlag",
        opsIdArr.join(",")
      );
      if (res.indexOf("E^") === 0) {
        $.messager.alert("提示", "保存打印标志失败，原因：" + res, "error");
      }
    },

    /**
     * 深圳南山医院打印手术排班通知单
     * @author ccq 20200913
     */
    printTicketList: function () {
      var checkedRows = $("#operlistBox").datagrid("getChecked");
      if (!checkedRows || checkedRows.length === 0) {
        $.messager.alert(
          "提示",
          "请先勾选要打印的手术，再进行操作。",
          "warning"
        );
        return;
      }
      var lodop = getLodop();
      lodop.PRINT_INIT("手术排班通知单");
      lodop.SET_PRINT_PAGESIZE("1", "22cm", "9.31cm", ""); // 打印纸张宽x高：22cm x 9cm

      var opsIdArr = [];
      for (var i = 0; i < checkedRows.length; i++) {
        var checkedRow = checkedRows[i];
        opsIdArr.push(checkedRow.OPSID);
        var firstAssistant = "",
          secondAssistant = "",
          firstSurgeon = "",
          firstOperClass = "";
        if (checkedRow.AssistantDesc) {
          var assistantArr = checkedRow.AssistantDesc.split(",");
          firstAssistant = assistantArr[0];
          if (assistantArr.length > 1) secondAssistant = assistantArr[1];
        }
        if (checkedRow.SurgeonDesc) {
          var surgeonDescArr = checkedRow.SurgeonDesc.split(",");
          firstSurgeon = surgeonDescArr[0];
        }
        if (checkedRow.OperClassDesc) {
          var operClassDescArr = checkedRow.OperClassDesc.split(",");
          firstOperClass = operClassDescArr[0];
        }
        if (i > 0) lodop.NEWPAGE(); // 多选：每个通知单打一页
        var htmlArr = [
          "<style>td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:9pt;} .title {text-align:center} table{table-layout:fixed;}</style>",
          "<div style='text-align:center'>手术排班通知单</div>",
          "<table style='width:560pt'>",
          "<tr>",
          "<td class='title' style='border:none'>手术申请日期</td>",
          "<td colspan='5' style='border:none'>" + checkedRow.AppDT + "</td>",
          "<td rowspan='2' style='font-size:20px;border:none'>" +
            checkedRow.SourceTypeDesc +
            "</td>",
          "</tr>",
          "<tr>",
          "<td class='title' style='border:none'>手术审核日期</td>",
          "<td colspan='2' style='border:none'>" + checkedRow.AuditDT + "</td>",
          "<td style='border:none;text-align:right'>手术日期</td>",
          "<td colspan='2' style='border:none'>" +
            checkedRow.OperDate +
            "</td>",
          "<td style='border:none'>住院号:" + checkedRow.MedcareNo + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title' style='width:63pt'>登记号</td>",
          "<td style='width:75pt'>" + checkedRow.RegNo + "</td>",
          "<td class='title' style='width:42pt'>姓名</td>",
          "<td style='width:93pt'>" + checkedRow.PatName + "</td>",
          "<td class='title' style='width:42pt'>性别</td>",
          "<td style='width:51pt'>" + checkedRow.PatGender + "</td>",
          "<td class='title' style='width:80pt'>年龄</td>",
          "<td style='width:110pt'>" + checkedRow.PatAge + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>科室</td>",
          "<td>" + checkedRow.PatDeptDesc + "</td>",
          "<td class='title'>病区</td>",
          "<td>" + checkedRow.PatWardDesc + "</td>",
          "<td class='title'>床号</td>",
          "<td>" + checkedRow.PatBedCode + "</td>",
          "<td class='title'>预计手术时间</td>",
          "<td>" + checkedRow.OperTime + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>术前诊断</td>",
          "<td colspan='7'>" + checkedRow.PrevDiagnosisDesc + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>手术名称</td>",
          "<td colspan='7'>" + checkedRow.OperDesc + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>手术医师</td>",
          "<td>" + checkedRow.SurgeonDesc + "</td>",
          "<td class='title'>助手一</td>",
          "<td>" + firstAssistant + "</td>",
          "<td class='title'>助手二</td>",
          "<td>" + secondAssistant + "</td>",
          "<td class='title'>体位</td>",
          "<td>" + checkedRow.OperPositionDesc + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>麻醉方式</td>",
          "<td>" + checkedRow.AnaMethodDesc + "</td>",
          "<td class='title'>麻醉医师</td>",
          "<td>" + checkedRow.AnesthesiologistDesc + "</td>",
          "<td class='title'>洗手护士</td>",
          "<td>" + checkedRow.ScrubNurseDesc + "</td>",
          "<td class='title'>巡回护士</td>",
          "<td>" + checkedRow.CircualNurseDesc + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>手术房间</td>",
          "<td>" + checkedRow.RoomDesc + "</td>",
          "<td class='title'>手术台号</td>",
          "<td>" + checkedRow.OperSeq + "</td>",
          "<td class='title'>手术级别</td>",
          "<td>" + checkedRow.OperClassDesc + "</td>",
          "<td class='title'>切口等级</td>",
          "<td>" + checkedRow.BladeTypeDesc + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>特殊检查</td>",
          "<td colspan='2'></td>",
          "<td class='title'>感染筛查</td>",
          "<td colspan='2'>" + checkedRow.Infection + "</td>",
          "<td class='title'>本科室手术顺序</td>",
          "<td>" + checkedRow.PlanOperSeq + "</td>",
          "</tr>",
          "<tr>",
          "<td class='title'>手术要求</td>",
          "<td colspan='7'>" + checkedRow.Requirement + "</td>",
          "</tr>",
          "</table>",
        ];
        lodop.ADD_PRINT_HTM("0.3cm", "0.3cm", "560pt", "8cm", htmlArr.join(""));
      }

      var printTimes = lodop.PREVIEW();
      if (printTimes > 0) {
        var res = dhccl.runServerMethodNormal(
          ANCLS.BLL.OperArrange,
          "SaveTicketPrintFlag",
          opsIdArr.join(",")
        );
        if (res.indexOf("E^") === 0) {
          $.messager.alert("提示", "保存打印标志失败，原因：" + res, "error");
        }
      }
    },

    /**
     * 深圳南山医院打印手术一览表
     * @author ccq 20200913
     */
    printArrangeList: function () {
      var checkedRows = $("#operlistBox").datagrid("getChecked");
      if (!checkedRows || checkedRows.length === 0) {
        $.messager.alert(
          "提示",
          "请先勾选要打印的手术，再进行操作。",
          "warning"
        );
        return;
      }
      var lodop = getLodop();
      lodop.PRINT_INIT("手术排班通知单");
      lodop.SET_PRINT_PAGESIZE("3", 2200, 0, ""); // 打印纸张宽x高：22cm x 9cm

      var htmlArr = [
        "<style>td {font-size:9pt;} .title {text-align:center} table{table-layout:fixed;}",
        ".cell-top-border {border-top:1px solid black} .cell-left-border {border-left:1px solid black}",
        ".cell-right-border {border-right:1px solid black}",
        "table {border:1px solid black;border-top:none}",
        ".cell-bottom-border {border-bottom:1px solid black;}</style>",
        "<div style='text-align:center'>手术排班一览表</div>",
        "<table style='width:560pt'>",
        "<tr>",
        "<td>病人信息</td>",
        "<td>术者</td>",
        "<td>麻醉</td>",
        "<td>洗手</td>",
        "<td>巡回</td>",
        "<td>手术台</td>",
        "<td>手术日期</td>",
        "<td>术始时</td>",
        "<td>术毕时</td>",
        "<td>夜班</td>",
        "<td>急诊</td>",
        "</tr>",
      ];
      for (var i = 0; i < checkedRows.length; i++) {
        var checkedRow = checkedRows[i];
        var firstAssistant = "",
          secondAssistant = "",
          firstSurgeon = "",
          firstOperClass = "",
          firstCircualNurse = "",
          secondCircualNurse = "",
          firstScrubNurse = "",
          secondScrubNurse = "";
        if (checkedRow.AssistantDesc) {
          var assistantArr = checkedRow.AssistantDesc.split(",");
          firstAssistant = assistantArr[0];
          if (assistantArr.length > 1) secondAssistant = assistantArr[1];
        }
        if (checkedRow.SurgeonDesc) {
          var surgeonDescArr = checkedRow.SurgeonDesc.split(",");
          firstSurgeon = surgeonDescArr[0];
        }
        if (checkedRow.OperClassDesc) {
          var operClassDescArr = checkedRow.OperClassDesc.split(",");
          firstOperClass = operClassDescArr[0];
        }
        if (checkedRow.ScrubNurseDesc) {
          var scrubNurseDescArr = checkedRow.ScrubNurseDesc.split(",");
          firstScrubNurse = scrubNurseDescArr[0];
          if (scrubNurseDescArr.length > 1)
            secondScrubNurse = scrubNurseDescArr[1];
        }
        if (checkedRow.CircualNurseDesc) {
          var circualNurseDescArr = checkedRow.CircualNurseDesc.split(",");
          firstCircualNurse = circualNurseDescArr[0];
          if (circualNurseDescArr.length > 1)
            secondCircualNurse = circualNurseDescArr[1];
        }
        var rowHtmlArr = [
          "<tr>",
          "<td class='cell-top-border cell-left-border'>" +
            checkedRow.PatName +
            "</td>",
          "<td class='cell-top-border'>" + firstSurgeon + "</td>",
          "<td class='cell-top-border'>" +
            checkedRow.AnesthesiologistDesc +
            "</td>",
          "<td class='cell-top-border'>" + firstScrubNurse + "</td>",
          "<td class='cell-top-border cell-right-border'>" +
            firstCircualNurse +
            "</td>",
          "<td class='cell-top-border cell-left-border'>" +
            checkedRow.RoomDesc +
            "</td>",
          "<td class='cell-top-border'>" + checkedRow.OperDate + "</td>",
          "<td class='cell-top-border'>" + checkedRow.OperTime + "</td>",
          "<td class='cell-top-border'></td>",
          "<td class='cell-top-border'></td>",
          "<td class='cell-top-border cell-right-border'>" +
            (checkedRow.SourceType === "E" ? "是" : "否") +
            "</td>",
          "</tr>",
          "<tr>",
          "<td class='cell-left-border'>" + checkedRow.RegNo + "</td>",
          "<td>" + firstAssistant + "</td>",
          "<td></td>",
          "<td>" + secondScrubNurse + "</td>",
          "<td class='cell-right-border'>" + secondCircualNurse + "</td>",
          "<td class='cell-left-border'>术前诊断：</td>",
          "<td class='cell-right-border' colspan='5'>" +
            checkedRow.PrevDiagnosisDesc +
            "</td>",
          "</tr>",
          "<tr>",
          "<td class='cell-left-border'>" + checkedRow.PatDeptDesc + "</td>",
          "<td>" + secondAssistant + "</td>",
          "<td></td>",
          "<td></td>",
          "<td class='cell-right-border'></td>",
          "<td class='cell-left-border'>手术方式：</td>",
          "<td class='cell-right-border' colspan='5'>" +
            checkedRow.OperDesc +
            "</td>",
          "</tr>",
          "<tr>",
          "<td class='cell-bottom-border cell-left-border'>" +
            checkedRow.PatBedCode +
            "</td>",
          "<td class='cell-bottom-border'></td>",
          "<td class='cell-bottom-border'></td>",
          "<td class='cell-bottom-border'></td>",
          "<td class='cell-bottom-border cell-right-border'></td>",
          "<td class='cell-bottom-border cell-left-border'>麻醉方式：</td>",
          "<td class='cell-bottom-border cell-right-border' colspan='5'>" +
            checkedRow.AnaMethodDesc +
            "</td>",
          "</tr>",
        ];
        htmlArr.push(rowHtmlArr.join(""));
      }
      htmlArr.push("<tr style='height:21pt'><td colspan='11'></td></tr>");
      htmlArr.push("<tr style='height:21pt'><td colspan='11'></td></tr>");
      htmlArr.push("</table>");
      lodop.ADD_PRINT_HTM(
        "3mm",
        "2mm",
        "RightMargin:2mm",
        "BottomMargin:3mm",
        htmlArr.join("")
      );
      lodop.PRINT();
    },

    /**
     * 打开麻醉工作站
     */
    openANWorkstation: function () {
      var rowData = $("#operlistBox").datagrid("getSelected");
      if (!rowData) {
        $.messager.alert(
          "提示",
          "请先选择一条手术，再进入麻醉工作站！",
          "warning"
        );
      }
      var menuCode = "ANWSMenu";

      var href =
        "cis.an.workstation.csp?opsId=" +
        rowData.RowId +
        "&opaId=" +
        rowData.OPAID +
        "&PatientID=" +
        rowData.PatientID +
        "&EpisodeID=" +
        rowData.EpisodeID +
        "&AnaesthesiaID=" +
        rowData.ExtAnaestID +
        "&QueryDate=" +
        rowData.OperDate +
        "&menuCode=" +
        menuCode;
      window.location.href = href;
    },

    /**
     * 审核麻醉费用
     */
    auditANFee: function () {
      var selectedDatas = $("#operlistBox").datagrid("getChecked");
      if (!selectedDatas || selectedDatas.length <= 0) {
        $.messager.alert(
          "提示",
          "请先选择需要审核费用的手术，然后再审核麻醉费用！",
          "warning"
        );
        return;
      }
      $.messager.confirm(
        "提示",
        "(审核之前请确认费用完整性，防止漏费。)是否审核麻醉费用？",
        function (r) {
          if (r) {
            var opsIdArr = [];
            for (var i = 0; i < selectedDatas.length; i++) {
              var element = selectedDatas[i];
              opsIdArr.push(element.RowId);
            }
            var auditRet = dhccl.runServerMethodNormal(
              ANCLS.BLL.OperScheduleList,
              "AuditANFee",
              opsIdArr.join(","),
              session.UserID
            );
            if (auditRet.indexOf("S^") === 0) {
              $.messager.alert("提示", "麻醉费用审核成功！", "info");
              $("#operlistBox").datagrid("reload");
              $("#operlistBox").datagrid("clearChecked");
            } else {
              $.messager.alert(
                "提示",
                "麻醉费用审核失败！原因：" + auditRet,
                "error"
              );
            }
          }
        }
      );
    },

    /**
     * 打开手术工作站
     */
    openOPWorkstation: function () {
      var rowData = $("#operlistBox").datagrid("getSelected");
      if (!rowData) {
        $.messager.alert(
          "提示",
          "请先选择一条手术，再进入手术工作站！",
          "warning"
        );
        return;
      }
      var defOperStatus =
        "^" +
        dhccl.runServerMethodNormal(
          ANCLS.BLL.OperScheduleList,
          "GetDefOperStatus",
          session.GroupID
        ) +
        "^";
      var statusCodeStr = "^" + rowData.StatusCode + "^";
      if (!(defOperStatus.indexOf(statusCodeStr) >= 0)) {
        $.messager.alert("提示", "当前手术状态无法进入手术工作站！", "warning");
        return;
      }
      var menuCode = "OPWSMenu";
      var href =
        "cis.an.workstation.csp?opsId=" +
        rowData.RowId +
        "&opaId=" +
        rowData.OPAID +
        "&PatientID=" +
        rowData.PatientID +
        "&EpisodeID=" +
        rowData.EpisodeID +
        "&AnaesthesiaID=" +
        rowData.ExtAnaestID +
        "&QueryDate=" +
        rowData.OperDate +
        "&menuCode=" +
        menuCode;
      window.location.href = href;
    },

    /**
     * 审核手术费用
     */
    auditOPFee: function () {
      var selectedDatas = $("#operlistBox").datagrid("getChecked");
      if (!selectedDatas || selectedDatas.length <= 0) {
        $.messager.alert(
          "提示",
          "请勾选需要审核费用的手术，然后再审核手术费用！",
          "warning"
        );
        return;
      }
      $.messager.confirm(
        "提示",
        "(审核之前请确认费用完整性，防止漏费。)是否审核手术费用？",
        function (r) {
          if (r) {
            var opsIdArr = [];
            for (var i = 0; i < selectedDatas.length; i++) {
              var element = selectedDatas[i];
              opsIdArr.push(element.RowId);
            }
            var auditRet = dhccl.runServerMethodNormal(
              ANCLS.BLL.OperScheduleList,
              "AuditOPFee",
              opsIdArr.join(","),
              session.UserID
            );
            if (auditRet.indexOf("S^") === 0) {
              $.messager.alert("提示", "手术费用审核成功！", "info");
              $("#operlistBox").datagrid("reload");
              $("#operlistBox").datagrid("clearChecked");
            } else {
              $.messager.alert(
                "提示",
                "手术费用审核失败！原因：" + auditRet,
                "error"
              );
            }
          }
        }
      );
    },

    /**
     * 手术拒绝
     */
    declineArrange: function () {
      var selectedDatas = $("#operlistBox").datagrid("getChecked");
      if (!selectedDatas || selectedDatas.length <= 0) {
        $.messager.alert(
          "提示",
          "请勾选要拒绝的手术，然后再拒绝手术！",
          "warning"
        );
        return;
      }
      $.messager.confirm("提示", "是否拒绝选择的手术？", function (r) {
        if (r) {
          var opsIdArr = [];
          for (var i = 0; i < selectedDatas.length; i++) {
            var element = selectedDatas[i];
            opsIdArr.push(element.RowId);
          }
          var auditRet = dhccl.runServerMethodNormal(
            ANCLS.BLL.OperArrange,
            "DeclineOperation",
            opsIdArr.join(","),
            session.UserID
          );
          if (auditRet.indexOf("S^") === 0) {
            $.messager.alert("提示", "拒绝手术成功！", "info");
            $("#operlistBox").datagrid("reload");
            $("#operlistBox").datagrid("clearChecked");
          } else {
            $.messager.alert(
              "提示",
              "拒绝手术失败！原因：" + auditRet,
              "error"
            );
          }
        }
      });
    },

    /**
     * 取消拒绝
     */
    cancelDecline: function () {
      var selectedDatas = $("#operlistBox").datagrid("getChecked");
      if (!selectedDatas || selectedDatas.length <= 0) {
        $.messager.alert(
          "提示",
          "请勾选要取消拒绝的手术，然后再取消拒绝！",
          "warning"
        );
        return;
      }
      $.messager.confirm("提示", "是否取消拒绝选择的手术？", function (r) {
        if (r) {
          var opsIdArr = [];
          for (var i = 0; i < selectedDatas.length; i++) {
            var element = selectedDatas[i];
            opsIdArr.push(element.RowId);
          }
          var auditRet = dhccl.runServerMethodNormal(
            ANCLS.BLL.OperArrange,
            "CancelDecline",
            opsIdArr.join(","),
            session.UserID
          );
          if (auditRet.indexOf("S^") === 0) {
            $.messager.alert("提示", "取消拒绝手术成功！", "info");
            $("#operlistBox").datagrid("reload");
            $("#operlistBox").datagrid("clearChecked");
          } else {
            $.messager.alert(
              "提示",
              "取消拒绝手术失败！原因：" + auditRet,
              "error"
            );
          }
        }
      });
    },

    /**
     * 保存排班
     */
    saveArrange: function () {
      operScheduleList.endEdit("#operlistBox");
      $("#operlistBox").datagrid("reload");
    },

    /**
     * 打印麻醉排班表
     */
    printAnaArrangeList: function () {},

    /**
     * 打印手术排班表
     */
    printOPArrangeList: function () {
      var printDatas = $("#arrangeBox").datagrid("getChecked");
      if (printDatas && printDatas.length > 0) {
      } else {
        $.messager.alert("提示", "列表无数据可打印", "warning");
        return;
      }
      var LODOP = getLodop();
      var configCode = "arrange";
      var arrangeConfig = getArrangeConfig();
      if (!arrangeConfig) {
        $.messager.alert(
          "提示",
          "排班配置不存在，请联系系统管理员！",
          "warning"
        );
        return;
      }
      var printConfig = getPrintConfig(arrangeConfig, configCode);
      if (!printConfig) {
        $.messager.alert(
          "提示",
          "打印配置不存在，请联系系统管理员！",
          "warning"
        );
        return;
      }
      // 标题信息(手术日期、手术室)
      var titleInfo = {
        OperationDate: $("#operDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc,
      };
      // var LODOP = getLodop();
      var printSetting = operListConfig.print;
      var hospital = getHospital(); //YuanLin 20191210 医院名称自动获取
      var printtitle = hospital[0].HOSP_Desc + "手术排班表";
      LODOP.PRINT_INIT(printtitle);
      // LODOP.SET_PRINT_PAGESIZE(printSetting.direction, printSetting.paperSize.width, printSetting.paperSize.height, "");
      LODOP.SET_PRINT_PAGESIZE("2", "", "", "SSS");
      LODOP.ADD_PRINT_TEXT(15, 250, 500, 40, printtitle);
      LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 18);
      LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "HOrient", 2);
      LODOP.ADD_PRINT_TEXT(
        55,
        20,
        "100%",
        28,
        "科室：" + titleInfo.OperDeptDesc
      );
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_TEXT(
        55,
        400,
        "100%",
        28,
        "日期：" + titleInfo.OperationDate
      );
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_TEXT(
        55,
        700,
        "100%",
        28,
        "总计：" + printDatas.length + "台手术"
      );
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
      LODOP.ADD_PRINT_HTM(
        55,
        900,
        "100%",
        28,
        "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>"
      ); // 设置页码，pageNO和pageCount是Lodop提供的全局变量。
      LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
      LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
      LODOP.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
      var totalWidth = operListConfig.print.paperSize.rect.width;
      var html =
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-left:none;border-right:none;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table style='" +
        totalWidth +
        "pt'><thead><tr>";
      //var totalWidth=0;
      for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        //totalWidth+=column.width;
        html +=
          "<th style='width:" + column.width + "pt'>" + column.title + "</th>"; // 使用pt绝对单位，不会造成分辨率变化导致元素显示变动
      }
      html += "</tr></thead><tbody>";
      var curRoom = "",
        preRoom = "";
      for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        curRoom = printData.RoomDesc;
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
          var column = printConfig.columns[j];
          var printValue = printData[column.field];
          printValue = printValue ? printValue : "";
          if (column.field === "RoomDesc" && curRoom === preRoom) {
            printValue = "";
          }
          html +=
            "<td style='" +
            (column.style ? column.style : "") +
            "'>" +
            printValue +
            "</td>";
        }
        html += "</tr>";
        preRoom = printData.RoomDesc;
      }
      html += "</tbody></table>";

      LODOP.ADD_PRINT_TABLE(80, 10, totalWidth + "pt", "100%", html); // 高度设置成100%，表示占用剩余整页的高度。
      LODOP.PREVIEW();

      function getArrangeConfig() {
        var result = null;
        $.ajaxSettings.async = false;
        $.getJSON(
          "../service/dhcanop/data/operarrange.json?random=" + Math.random(),
          function (data) {
            result = data;
          }
        ).error(function (message) {
          alert(message);
        });
        $.ajaxSettings.async = true;
        return result;
      }

      function getPrintConfig(arrangeConfig, configCode) {
        var result = null;
        if (
          arrangeConfig &&
          arrangeConfig.print &&
          arrangeConfig.print.length > 0
        ) {
          for (var i = 0; i < arrangeConfig.print.length; i++) {
            var element = arrangeConfig.print[i];
            if (element.code == configCode) {
              result = element;
            }
          }
        }
        return result;
      }
    },

    /**
     * 查询手术列表
     */
    qryOperList: function () {
      operScheduleList.endEdit("#operlistBox");
      $("#operlistBox").datagrid("reload");
    },

    /**
     * 清空
     */
    clearCondition: function () {},

    /**
     * 修改日间手术
     */
    editDaySurgery: function () {},

    /**
     * 日间手术确认
     */
    confirmDaySurgery: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnConfirmDaySurgery"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      var url =
        "CIS.AN.DaySurgeryApp.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID +
        "&IsConfirm=" +
        "Y";
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#editDaySurgeryApp").dialog({
        content: href,
        title: selectedData.PatName + "的日间手术确认",
        iconCls: "icon-w-save",
        resizable: true,
	width:1200,
        height: 700,
      });

      $("#editDaySurgeryApp").dialog("open");
    },

    /**
     * 日间术前麻醉评估
     */
    preDaySurgery: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }
      var curStatus = selectedData.DaySurgery;
      if (curStatus != "Y") {
        $.messager.alert("提示", "请先选择日间手术，再进行修改。", "warning");
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnPreDaySurgery"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      var url =
        "CIS.AN.DaySurgeryPreAccess.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID;
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#DaySurgeryEst").dialog({
        content: href,
        title: selectedData.PatName + "的日间麻醉术前评估",
        iconCls: "icon-w-edit",
        resizable: true,
		width:900,
        height: 535,
      });
      DaySurgeryEst;

      $("#DaySurgeryEst").dialog("open");
    },

    /**
     * 日间手术后麻醉评估
     */
    postDaySurgery: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }
      var curStatus = selectedData.DaySurgery;
      if (curStatus != "Y") {
        $.messager.alert("提示", "请先选择日间手术，再进行修改。", "warning");
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnPostDaySurgery"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      var url =
        "CIS.AN.DaySurgeryPost.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID;
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#DaySurgeryEst").dialog({
        content: href,
        title: selectedData.PatName + "的日间恢复评估",
        iconCls: "icon-w-edit",
        resizable: true,
        width:1037,
        height: 590
      });

      $("#DaySurgeryEst").dialog("open");
    },

    outDaySurgery: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnOutDaySurgery"
      );
      if (actionPermission) {
        if (
          actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
        ) {
          $.messager.alert(
            "提示",
            "当前安全组或当前状态无修改手术的权限。",
            "warning"
          );
          return;
        }
      } else {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }
      var url =
        "CIS.AN.DaySurgeryOut.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID +
        "&IsConfirm=" +
        "N";
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#DaySurgeryEst").dialog({
        content: href,
        title: selectedData.PatName + "的日间手术出院评估",
        iconCls: "icon-w-edit",
        resizable: true,
        width:1040,
        height: 692
      });

      $("#DaySurgeryEst").dialog("open");
    },

    editOutOper: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert("提示", "请先选择手术记录，再进行修改。", "warning");
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnEditOutOper"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      var url =
        "CIS.AN.OutOperApp.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID;
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#OutOperShow").dialog({
        content: href,
        title: selectedData.PatName + "的门诊手术修改",
        iconCls: "icon-w-edit",
        resizable: true,
        height: 700,
      });

      $("#OutOperShow").dialog("open");
    },
    /**
     * 手术风险评估
     */
    OperRiskAssessment: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert(
          "提示",
          "请先选择手术记录，再进行手术风险评估。",
          "warning"
        );
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnOperRiskAssessment"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      let url =
        "CIS.AN.OperRiskAssessment.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.RegNo +
        "&AnaesthesiaID=" +
        selectedData.MRAdmID +
        "&moduleCode=AN_OPS_003";
      //var url="CIS.AN.OperRiskAssessment.csp?PatientID=81&amp;EpisodeID=99&amp;opsId=664&amp;moduleCode=AN_OPS_003&amp;opaId=639&amp;AnaesthesiaID=99||11"
      let href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#OperRiskAssessment").dialog({
        content: href,
        title: selectedData.PatName + "的手术风险评估",
        resizable: true,
        height: 700,
      });

      $("#OperRiskAssessment").dialog("open");
    },

    OperSafetyCheck: function () {
      var selectedData = $("#operlistBox").datagrid("getSelected");
      if (!selectedData) {
        $.messager.alert(
          "提示",
          "请先选择手术记录，再进行手术安全核查。",
          "warning"
        );
        return;
      }
      var actionPermission = operationListConfig.getActionPermission(
        session.GroupID,
        session.ModuleID,
        "btnOperSafetyCheck"
      );
      if (
        actionPermission.OperStatusCode.indexOf(selectedData.StatusCode) < 0
      ) {
        $.messager.alert(
          "提示",
          "当前安全组或当前状态无修改手术的权限。",
          "warning"
        );
        return;
      }

      var url =
        "CIS.AN.OperSafetyCheck.csp?opsId=" +
        selectedData.OPSID +
        "&EpisodeID=" +
        selectedData.EpisodeID +
        "&PatientID=" +
        selectedData.PatientID +
        "&MRAdmID=" +
        selectedData.MRAdmID +
        "&moduleCode=AN_ANS_007";
      var href =
        "<iframe scrolling='yes' frameborder='0' src='" +
        url +
        "' style='width:100%;height:100%'></iframe>";
      $("#OperSafetyCheck").dialog({
        content: href,
        title: selectedData.PatName + "的手术安全核查",
        iconCls: "icon-edit",
        resizable: true,
        height: 700,
      });

      $("#OperSafetyCheck").dialog("open");
    },
  },

  arrange: {
    /**
     * 获取手术护士编辑控件选项
     */
    getScrubNurseOptions: function () {
      var opts = operScheduleList.opts;
      var operList = operScheduleList.list;
      return {
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
          var operDeptID = operList.editRow.data.OperDeptID;
          var operDate = operList.editRow.data.OperDate;
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.MethodName = "GetOperNurseJSON";
          param.Arg1 = operDate;
          param.Arg2 = param.q ? param.q : "";
          param.Arg3 = operDeptID;
          param.Arg4 = "Y";
          param.ArgCnt = 4;
        },
        data: operScheduleList.opts.careProvs,
        panelWidth: 330,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        multiple: true,
        columns: [
          [
            { field: "CheckStatus", title: "勾选", checkbox: true },
            { field: "RowId", title: "ID", hidden: true },
            { field: "Description", title: "手术护士", width: 100 },
            { field: "ArrangeInfo", title: "今日已排", width: 160 },
          ],
        ],
        // mode: "remote",
        onSelect: function (rowIndex, rowData) {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            //$.messager.alert("提示","未安排手术间，请先排班手术间再操作。","warning");
            return;
          }
          var selectedDatas = $(this).datagrid("getSelections");
          var text = "";
          if (selectedDatas && selectedDatas.length > 0) {
            var textArr = [];
            for (var i = 0; i < selectedDatas.length; i++) {
              var selectedData = selectedDatas[i];
              textArr.push(selectedData.Description);
            }
            text = textArr.join(",");
          }
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "ScrubNurseDesc",
            "Description"
          );
        },

        onShowPanel: function () {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            $.messager.alert(
              "提示",
              "未安排手术间，请先选择手术间再操作。",
              "warning"
            );
            $(this).combo("clear");
            $(this).combo("hidePanel");
            return;
          }
        },
      };
    },

    /**
     * 获取手术护士编辑控件选项
     */
    getCareProvOptions: function (descField, multiple) {
      return {
        // url: ANCSP.MethodService,
        data: operScheduleList.opts.careProvs,
        valueField: "RowId",
        textField: "Description",
        descField: descField,
        multiple: multiple,
        rowStyle: "checkbox",
        panelWidth: 200,
        editable: false,
        onSelect: function (record) {
          var text = $(this).combobox("getText");
          var opts = $(this).combobox("options");
          var descField = opts.descField ? opts.descField : "";
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            descField,
            "Description"
          );
        },
        onUnselect: function (record) {
          var text = $(this).combobox("getText");
          var opts = $(this).combobox("options");
          var descField = opts.descField ? opts.descField : "";
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            descField,
            "Description"
          );
        },
        onChange: function (newValue, oldValue) {
          if (!newValue && oldValue) {
            var text = "";
            var opts = $(this).combobox("options");
            var descField = opts.descField ? opts.descField : "";
            operScheduleList.arrange.setComboboxFieldDesc(
              { Description: text },
              descField,
              "Description"
            );
          }
        },
        filter: function (q, row) {
          var filterDesc = q.toUpperCase();
          var desc = row.Description.toUpperCase();
          var alias = row.Alias.toUpperCase();
          return (
            desc.indexOf(filterDesc) >= 0 || alias.indexOf(filterDesc) >= 0
          );
        },
        onShowPanel: function () {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            $.messager.alert(
              "提示",
              "未安排手术间，请先选择手术间再操作。",
              "warning"
            );
            $(this).combobox("clear");
            $(this).combobox("hidePanel");
            return;
          }
        },
      };
    },
    /**
     * 获取手术护士编辑控件选项
     */
    getCircualNurseOptions: function () {
      var opts = operScheduleList.opts;
      var operList = operScheduleList.list;
      return {
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
          var operDeptID = operList.editRow.data.OperDeptID;
          var operDate = operList.editRow.data.OperDate;
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.MethodName = "GetOperNurseJSON";
          param.Arg1 = operDate;
          param.Arg2 = param.q ? param.q : "";
          param.Arg3 = operDeptID;
          param.Arg4 = "Y";
          param.ArgCnt = 4;
        },
        // data:operScheduleList.opts.careProvs,
        panelWidth: 330,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        multiple: true,
        columns: [
          [
            { field: "CheckStatus", title: "勾选", checkbox: true },
            { field: "RowId", title: "ID", hidden: true },
            { field: "Description", title: "手术护士", width: 100 },
            { field: "ArrangeInfo", title: "今日已排", width: 160 },
          ],
        ],
        mode: "remote",
        onSelect: function (rowIndex, rowData) {
          var selectedDatas = $(this).datagrid("getSelections");
          var text = "";
          if (selectedDatas && selectedDatas.length > 0) {
            var textArr = [];
            for (var i = 0; i < selectedDatas.length; i++) {
              var selectedData = selectedDatas[i];
              textArr.push(selectedData.Description);
            }
            text = textArr.join(",");
          }
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "CircualNurseDesc",
            "Description"
          );
        },
        onShowPanel: function () {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            $.messager.alert(
              "提示",
              "未安排手术间，请先选择手术间再操作。",
              "warning"
            );
            $(this).combo("clear");
            $(this).combo("hidePanel");
            return;
          }
        },
      };
    },

    /**
     * 获取手术间编辑控件选项
     */
    getOperRoomOptions: function () {
      var opts = operScheduleList.opts;
      return {
        valueField: "RowId",
        textField: "Description",
        data: opts.operRooms,
        editable: false,
        onSelect: function (record) {
          var text = record.Description;
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "RoomDesc",
            "Description"
          );
        },
        onChange: function (newValue, oldValue) {
          //operScheduleList.arrange.genNewSeq(newValue);
        },
      };
    },

    /**
     * 获取麻醉指导和麻醉医生编辑控件选项
     */
    getAnaExpertOptions: function () {
      var operList = operScheduleList.list;
      return {
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
          var anaDeptID = operList.editRow.data.AnaDept;
          var operDate = operList.editRow.data.OperDate;
          var filterDesc = param.filterDesc ? param.filterDesc : "";
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.MethodName = "GetAnaDocJSON";
          param.Arg1 = operDate;
          param.Arg2 = filterDesc;
          param.Arg3 = anaDeptID;
          param.Arg4 = "Y";
          param.ArgCnt = 4;
        },
        panelWidth: 330,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        columns: [
          [
            { field: "CheckStatus", title: "勾选", checkbox: true },
            { field: "RowId", title: "ID", hidden: true },
            { field: "Description", title: "麻醉医生", width: 100 },
            { field: "ArrangeInfo", title: "今日已排", width: 160 },
          ],
        ],
        mode: "remote",
        onSelect: function (rowIndex, rowData) {
          var text = rowData.Description;
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "AnaExpertDesc",
            "Description"
          );
        },
      };
    },

    /**
     * 获取麻醉指导和麻醉医生编辑控件选项
     */
    getAnaDocOptions: function () {
      var operList = operScheduleList.list;
      return {
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
          var anaDeptID = operList.editRow.data.AnaDept;
          var operDate = operList.editRow.data.OperDate;
          var filterDesc = param.filterDesc ? param.filterDesc : "";
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.MethodName = "GetAnaDocJSON";
          param.Arg1 = operDate;
          param.Arg2 = filterDesc;
          param.Arg3 = anaDeptID;
          param.Arg4 = "Y";
          param.ArgCnt = 4;
        },
        panelWidth: 330,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        columns: [
          [
            { field: "CheckStatus", title: "勾选", checkbox: true },
            { field: "RowId", title: "ID", hidden: true },
            { field: "Description", title: "麻醉医生", width: 100 },
            { field: "ArrangeInfo", title: "今日已排", width: 160 },
          ],
        ],
        mode: "remote",
        onSelect: function (rowIndex, rowData) {
          var text = rowData.Description;
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "AnesthesiologistDesc",
            "Description"
          );
        },
      };
    },

    /**
     * 获取手术护士编辑控件选项
     */
    getAnaDocOptionsNew: function (descField, multiple) {
      return {
        url: ANCSP.MethodService,
        data: operScheduleList.opts.careProvs,
        valueField: "RowId",
        textField: "Description",
        multiple: multiple,
        rowStyle: "checkbox",
        onSelect: function (record) {
          var text = $(this).combobox("getText");
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            descField,
            "Description"
          );
        },
        filter: function (q, row) {
          var filterDesc = q.toUpperCase();
          var desc = row.Description.toUpperCase();
          var alias = row.Alias.toUpperCase();
          return (
            desc.indexOf(filterDesc) >= 0 || alias.indexOf(filterDesc) >= 0
          );
        },
        onShowPanel: function () {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            $.messager.alert(
              "提示",
              "未安排手术间，请先选择手术间再操作。",
              "warning"
            );
            $(this).combobox("clear");
            $(this).combobox("hidePanel");
            return;
          }
        },
      };
    },

    /**
     * 获取麻醉指导和麻醉医生编辑控件选项
     */
    getAnaAssistantOptions: function () {
      var operList = operScheduleList.list;
      return {
        url: ANCSP.MethodService,
        onBeforeLoad: function (param) {
          var anaDeptID = operList.editRow.data.AnaDept;
          var operDate = operList.editRow.data.OperDate;
          var filterDesc = param.filterDesc ? param.filterDesc : "";
          param.ClassName = ANCLS.BLL.OperScheduleList;
          param.MethodName = "GetAnaDocJSON";
          param.Arg1 = operDate;
          param.Arg2 = filterDesc;
          param.Arg3 = anaDeptID;
          param.Arg4 = "Y";
          param.ArgCnt = 4;
        },
        panelWidth: 330,
        panelHeight: 450,
        idField: "RowId",
        textField: "Description",
        multiple: true,
        columns: [
          [
            { field: "CheckStatus", title: "勾选", checkbox: true },
            { field: "RowId", title: "ID", hidden: true },
            { field: "Description", title: "麻醉医生", width: 100 },
            { field: "ArrangeInfo", title: "今日已排", width: 160 },
          ],
        ],
        mode: "remote",
        onSelect: function (rowIndex, rowData) {
          var selectedDatas = $(this).datagrid("getSelections");
          var text = "";
          if (selectedDatas && selectedDatas.length > 0) {
            var textArr = [];
            for (var i = 0; i < selectedDatas.length; i++) {
              var selectedData = selectedDatas[i];
              textArr.push(selectedData.Description);
            }
            text = textArr.join(",");
          }
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "AnaAssistantDesc",
            "Description"
          );
        },
      };
    },

    /**
     * 获取麻醉方法编辑控件选项
     */
    getAnaMethodOptions: function () {
      var opts = operScheduleList.opts;
      return {
        valueField: "RowId",
        textField: "Description",
        data: opts.anaMethodList,
        multiple: true,
        rowStyle: "checkbox",
        onSelect: function (record) {
          var text = $(this).combobox("getText");
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "AnaMethodDesc",
            "Description"
          );
        },
        onUnselect: function (record) {
          var text = $(this).combobox("getText");
          operScheduleList.arrange.setComboboxFieldDesc(
            { Description: text },
            "AnaMethodDesc",
            "Description"
          );
        },
      };
    },

    /**
     * 获取手术台次编辑控件选项
     */
    getOperSeqOptions: function () {
      return {
        valueField: operScheduleList.opts.SeqType,
        textField: operScheduleList.opts.SeqType,
        //data:CommonArray.OperSeqList,
        data: operScheduleList.opts.seqList,
        editable: false,
        onSelect: function (record) {
          var rowData = operScheduleList.list.editRow.data;
          if (!rowData) return;
          var rowIndex = operScheduleList.list.editRow.index;
          var operDate = rowData.OperDate;
          var operSeq = record.value;
          var operRoomEditor = $("#operlistBox").datagrid("getEditor", {
            index: rowIndex,
            field: "OperRoom",
          });
          if (!operRoomEditor) return;
          var operRoom = $(operRoomEditor.target).combobox("getValue");
          var RoomDesc = $(operRoomEditor.target).combobox("getText");
          if (operRoom && operDate && operSeq) {
            var existsOperSeq = dhccl.runServerMethodNormal(
              ANCLS.BLL.OperArrange,
              "ExistsOperSeq",
              operDate,
              operRoom,
              operSeq
            );
            if (existsOperSeq === "Y") {
              $.messager.alert(
                "提示",
                RoomDesc + "已存在台次为" + operSeq + "的手术。",
                "warning"
              );
            }
          }
        },
        onShowPanel: function () {
          var roomArranged = operScheduleList.arrange.arrangedOperRoom();
          if (!roomArranged) {
            $.messager.alert(
              "提示",
              "未安排手术间，请先选择手术间再操作。",
              "warning"
            );
            $(this).combo("clear");
            $(this).combo("hidePanel");
            return;
          }
        },
      };
    },

    /**
     * 获取手术台次编辑控件选项
     */
    getPlanOperSeqOptions: function () {
      return {
        valueField: operScheduleList.opts.PlanSeqType,
        textField: operScheduleList.opts.PlanSeqType,
        //data:CommonArray.OperSeqList,
        data: operScheduleList.opts.seqList,
        editable: false,
        onSelect: function (record) {
          var rowData = operScheduleList.list.editRow.data;
          if (!rowData) return;
          var rowIndex = operScheduleList.list.editRow.index;
          var operDate = rowData.OperDate;
          var operSeq = record.value;
          var operRoomEditor = $("#operlistBox").datagrid("getEditor", {
            index: rowIndex,
            field: "OperRoom",
          });
          if (!operRoomEditor) return;
          var operRoom = $(operRoomEditor.target).combobox("getValue");
          var RoomDesc = $(operRoomEditor.target).combobox("getText");
          if (operRoom && operDate && operSeq) {
            // var existsOperSeq=dhccl.runServerMethodNormal(ANCLS.BLL.OperArrange,"ExistsOperSeq",operDate,operRoom,operSeq);
            // if(existsOperSeq==="Y"){
            //     $.messager.alert("提示",RoomDesc+"已存在台次为"+operSeq+"的手术。","warning");
            // }
          }
        },
        onShowPanel: function () {
          // var roomArranged=operScheduleList.arrange.arrangedOperRoom();
          // if(!roomArranged){
          //     $.messager.alert("提示","未安排手术间，请先选择手术间再操作。","warning");
          //     $(this).combo("clear");
          //     $(this).combo("hidePanel");
          //     return;
          // }
        },
      };
    },

    /**
     * 下拉框选择后，对表格的相应描述字段进行赋值。
     * 这样表格相应行结束编辑状态后，相应字段就不会显示成ID。
     * 相应字段显示方式参考列选项的formatter函数。
     * @param {object} record 下拉框选择项
     * @param {String} descField 表格描述字段
     * @param {String} textField 下拉框文本字段
     */
    setComboboxFieldDesc: function (record, descField, textField) {
      var rowData = operScheduleList.list.editRow.data;
      if (rowData) {
        rowData[descField] = record[textField];
      }
    },

    /**
     * 安排手术间后，生成最新台次
     * @param {String} roomId 手术间ID
     */
    genNewSeq: function (roomId) {
      var operDate = operScheduleList.list.editRow.data.OperDate;
      var newSeq = "";
      if (roomId)
        newSeq = dhccl.runServerMethodNormal(
          ANCLS.BLL.OperArrange,
          "GetNextSeq",
          operDate,
          roomId
        );
      // var editor=$("#operlistBox").datagrid("getEditor",{index:operScheduleList.list.editRow.index,field:"OperSeq"});
      // if(editor && editor.target){
      //     var oriValue=$(editor.target).combobox("getValue");
      //     if(!oriValue){
      //         $(editor.target).combobox("setValue",newSeq);
      //     }
      // }
      if (!operScheduleList.list.editRow.data.OperSeq) {
        operScheduleList.list.editRow.data.OperSeq = newSeq;
      }
    },

    /**
     * 安排手术间后，生成最新台次
     * @param {String} roomId 手术间ID
     */
    getNewSeq: function (roomId) {
      var operDate = operScheduleList.list.editRow.data.OperDate;
      var newSeq = "";
      if (roomId)
        newSeq = dhccl.runServerMethodNormal(
          ANCLS.BLL.OperArrange,
          "GetNextSeq",
          operDate,
          roomId
        );
      return newSeq;
    },

    /**
     * 判断是否选择了手术间
     */
    arrangedOperRoom: function () {
      var arranged = false;
      // var editor=$("#operlistBox").datagrid("getEditor",{index:operScheduleList.list.editRow.index,field:"OperRoom"});
      // if(editor && editor.target){
      //     var oriValue=$(editor.target).combobox("getValue");
      //     if(oriValue){
      //         arranged=true;
      //     }
      // }
      if (operScheduleList.list.editRow.data.OperRoom) {
        arranged = true;
      }
      return arranged;
    },
  },

  /**
   * 结束编辑状态
   * @param {String} selector Datagrid选择器
   */
  endEdit: function (selector) {
    var rows = $(selector).datagrid("getRows");
    for (var i = 0; i < rows.length; i++) {
      $(selector).datagrid("endEdit", i);
    }
  },
};

$(document).ready(operScheduleList.initPage);

function closeDaySurgeryDialog() {
  $("#editDaySurgeryApp").dialog("close");
  $("#operlistBox").datagrid("clearSelections");
  $("#operlistBox").datagrid("reload");
}
function closePreDaySurgery() {
  $("#DaySurgeryEst").dialog("close");
  $("#operlistBox").datagrid("clearSelections");
  $("#operlistBox").datagrid("reload");
}
//202109+dyl
function closeDaySurgeryDiag()
{
    $("#DaySurgeryEst").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}
function closeOutOperDialog() {
  $("#OutOperShow").dialog("close");
  $("#operlistBox").datagrid("clearSelections");
  $("#operlistBox").datagrid("reload");
}

function closeDialog() {
  operScheduleList.dialog.close();
  $("#operlistBox").datagrid("reload");
}

//点日间手术
function DayOrOut(event, value) {
  if ((value = true)) {
    $("#IsOutOper").checkbox("setValue", false);
  }
}
//点击门诊手术
function OutOrDay(event, value) {
  if ((value = true)) {
    $("#chkIsDayOper").checkbox("setValue", false);
  }
}
