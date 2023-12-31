var placenta={
  init:function(){
    placenta.loadCommonData();
    placenta.initBox();
    placenta.initActions();
  },

  initBox:function(){
    $("#dataBox").datagrid({
      fit:true,
      toolbar:"#dataTools",
      border:false,
      rownumbers:true,
      url:ANCSP.DataQuery,
      onBeforeLoad:function(param){
        param.ClassName=ANCLS.BLL.SpecimenManager;
        param.QueryName="FindPlacentaList";
        param.Arg1=session.OPSID;
        param.ArgCnt=1;
      },
      columns:[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"RegNo",title:"登记号",width:120},
        {field:"PatName",title:"姓名",width:80},
        {field:"PatAge",title:"年龄",width:70},
        {field:"PatDeptDesc",title:"科室",width:120},
        {field:"RoomDesc",title:"手术间",width:80},
        {field:"MedcareNo",title:"住院号",width:100},
        {field:"ScrubNurseDesc",title:"洗手护士",width:130},
        {field:"PreserveTime",title:"留取时间",width:100,editor:{type:"validatebox"}},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"CircualNurseDesc",title:"巡回护士",width:130}
      ]],

    });

    $("#dataBox").datagrid("enableCellEditing");
  },

  initActions:function(){
    $("#btnSearch").linkbutton({
      onClick:function(){
        $("#dataBox").datagrid("reload");
      }
    });

    $("#btnAdd").linkbutton({
      onClick:function(){
        $("#dataBox").datagrid("appendRow",{
          RowId:"",
          RegNo:placenta.schedule.RegNo,
          MedcareNo:placenta.schedule.MedcareNo,
          OperDate:placenta.schedule.OperDate,
          RoomDesc:placenta.schedule.RoomDesc,
          PatAge:placenta.schedule.PatAge,
          PatName:placenta.schedule.PatName,
          PatDeptDesc:placenta.schedule.PatDeptDesc,
          ScrubNurseDesc:placenta.schedule.ScrubNurseDesc,
          CircualNurseDesc:placenta.schedule.CircualNurseDesc,
          OperSchedule:placenta.schedule.RowId,
          CreateUser:session.UserID,
          UpdateUser:session.UserID,
          PreserveTime:(new Date()).format("HH:mm")
        });
      }
    });

    $("#btnDel").linkbutton({
      onClick:function(){
        var checkRows=$("#dataBox").datagrid("getChecked");
        if(!checkRows || checkRows.length===0){
          $.messager.alert("提示","请先选择要删除的记录，再操作。","warning");
          return;
        }
        $.messager.confirm("提示","是否删除勾选的记录？",function(r){
          if(r){
            var removeParas=[];
            for(var i=0;i<checkRows.length;i++){
              var checkRow=checkRows[i];
              if(checkRow.RowId){
                removeParas.push({ClassName:ANCLS.Model.Placenta,RowId:checkRow.RowId});
              }
            }

            if(removeParas.length>0){
              var paraStr=dhccl.formatObjects(removeParas);
              var res=dhccl.removeDatas(paraStr);
              if(res.indexOf("S^")===0){
                $.messager.popover({type:"success",msg:"删除记录成功。",timeout:1500});

              }else{
                $.messager.alert("提示","删除记录失败，原因："+res,"error");
              }
            }
            
            placenta.removeRows(checkRows);
          }
        });
      }
    });

    $("#btnSave").linkbutton({
      onClick:function(){
        dhccl.endEditDataBox("dataBox");
        var dataRows=$("#dataBox").datagrid("getRows");
        for(var i=0;i<dataRows.length;i++){
          var dataRow=dataRows[i];
          dataRow.ClassName=ANCLS.Model.Placenta;
          if(dataRow.RowId){
            dataRow.UpdateUser=session.UserID;
          }
        }

        var paraStr=dhccl.formatObjects(dataRows);
        var res=dhccl.saveDatas(ANCSP.DataListService,{
          jsonData:paraStr
        });
        if(res.indexOf("S^")===0){
          $.messager.popover({type:"success",msg:"保存数据成功。",timeout:1500});
          $("#dataBox").datagrid("reload");
        }else{
          $.messager.alert("提示","保存数据失败，原因："+res,"error");
        }
      }
    });

    $("#btnPrintBarCode").linkbutton({
      onClick:function(){
        var checkedRows=$("#dataBox").datagrid("getChecked");
        if(!checkedRows && checkedRows.length===0){
          $.messager.alert("提示","请勾选需要打印条码的胎盘。","warning");
          return;
        }
        for(var i=0;i<checkedRows.length;i++){
          var checkedRow=checkedRows[i];
          if(!checkedRow.RowId){
            unSaveList.push("存在未保存的胎盘记录(留取时间："+checkedRow.PreserveTime+")，不能打印。");
          }
        }
        if(unSaveList.length>0){
          $.messager.alert("提示",unSaveList.join("<br>"),"warning");
          return;
        }
        var lodop=getLodop();
        lodop.PRINT_INIT("胎盘标签");
        lodop.SET_PRINT_PAGESIZE(1, "7cm", "5cm", "");

        for(var i=0;i<checkedRows.length;i++){
          var checkedRow=checkedRows[i];
          if(i>0) lodop.NEWPAGE();
          var htmlArr=[
            "<style> div {font-size:12px;marign-bottom:10px;}</style>",
            "<div style='margin-bottom:10px'>",
              "<span style='font-size:20px;margin-right:20px'>"+checkedRow.PatName+"</span>",
              "<span style='margin-right:20px'>"+checkedRow.PatAge+"</span>",
              "<span>"+checkedRow.RoomDesc+"</span>",
            "</div>",
            "<div>",
              "科室："+checkedRow.PatDeptDesc,
            "</div>",
            "<div>",
              "巡回："+checkedRow.CircualNurseDesc,
            "</div>",
            "<div>",
              "洗手："+checkedRow.ScrubNurseDesc,
            "</div>",
            "<div>",
              "<span style='margin-right:20px;'>留取时间："+checkedRow.PreserveTime+"</span>",
              "<span>标本：胎盘</span>",
            "</div>",
            "<div>",
              "住院号："+checkedRow.MedcareNo,
            "</div>",
            "<div style='margin-bottom:5px;'>",
              "登记号："+checkedRow.RegNo,
            "</div>"
          ];

          lodop.ADD_PRINT_HTM("0.2cm","0.5cm","100%","100%",htmlArr.join(""));
          lodop.ADD_PRINT_BARCODE("3.5cm","0.5cm","4cm","1cm","128A",checkedRow.RegNo);
        }

        lodop.PREVIEW();
      }
    });
  },

  loadCommonData:function(){
    placenta.schedule=operDataManager.getOperAppData();
  },

  removeRows:function(checkedRows){
    if(checkedRows && checkedRows.length>0){
      for(var i=0;i<checkedRows.length;i++){
        var checkedRow=checkedRows[i];
        var rowIndex=$("#dataBox").datagrid("getRowIndex",checkedRow);
        $("#dataBox").datagrid("deleteRow",rowIndex);
      }
    }
  }
}

$(document).ready(placenta.init);