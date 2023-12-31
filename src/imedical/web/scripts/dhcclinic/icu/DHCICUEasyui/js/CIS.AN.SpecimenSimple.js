var specimen={
  opts:{},
  editRow:{
    index:-1,
    data:null,
    field:""
  },
  init:function(){
    specimen.loadCommonData();
    specimen.initBox();
    specimen.initActions();
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
        param.QueryName="FindSpecimenList";
        param.Arg1=session.OPSID;
        param.ArgCnt=1;
      },
      columns:[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"RegNo",title:"登记号",width:100},
        {field:"PatName",title:"姓名",width:60},
        {field:"PatGender",title:"性别",width:48},
        {field:"PatAge",title:"年龄",width:56},
        {field:"Description",title:"标本名称",width:100,editor:{type:"validatebox"}},
        {field:"SpecimenType",title:"标本类型",width:90,editor:{type:"combobox",options:{
          valueField:"Code",
          textField:"Description",
          data:specimen.opts.specimenType,
          onSelect:function(record){
            specimen.editRow.data.SpecimenTypeDesc=record.Description;
            if(record.Code==="P"){
              specimen.editRow.data.SendOutTime="";
            }else if(record.Code==="F"){
              specimen.editRow.data.SoakTime="";
            }
          },
          mode:"remote"
        }},formatter:function(value,row,index){
          return row.SpecimenTypeDesc
        }},
        {field:"OutTime",title:"离体时间",width:76,editor:{type:"validatebox"}},
        {field:"SoakTime",title:"浸泡时间",width:76,editor:{type:"validatebox"}},
        {field:"SendOutTime",title:"送出时间",width:76,editor:{type:"validatebox"}},
        {field:"Qty",title:"总数",width:48,editor:{type:"numberbox"}},
        {field:"PatDeptDesc",title:"科室",width:100},
        {field:"MedcareNo",title:"住院号",width:90},
        {field:"RoomDesc",title:"手术间",width:90},
        {field:"OperSeq",title:"台序",width:48},
        {field:"PrevDiagnosisDesc",title:"诊断",width:100},
        {field:"OperDesc",title:"术式",width:200},
        {field:"SurgeonDesc",title:"医生",width:62},
        {field:"CircualNurseDesc",title:"巡回",width:80},
        {field:"OperDate",title:"手术日期",width:90},
        {field:"UpdateUserDesc",title:"操作人",width:62}
        
      ]],
      onBeforeEdit:function(rowIndex,rowData){
        
        specimen.editRow.index=rowIndex;
        specimen.editRow.data=rowData;
      },

      onClickCell:function(rowIndex,field,value){
        specimen.editRow.field=field;
        if(specimen.editRow.data.SpecimenType==="P" && specimen.editRow.field==="SendOutTime"){
          $(this).datagrid("cancelEdit",rowIndex);
          return false;
        }
        if(specimen.editRow.data.SpecimenType==="F" && specimen.editRow.field==="SoakTime"){
          $(this).datagrid("cancelEdit",rowIndex);
          return false;
        }
      }
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
          RegNo:specimen.schedule.RegNo,
          MedcareNo:specimen.schedule.MedcareNo,
          OperDate:specimen.schedule.OperDate,
          RoomDesc:specimen.schedule.RoomDesc,
          PatAge:specimen.schedule.PatAge,
          PatName:specimen.schedule.PatName,
          PatGender:specimen.schedule.PatGender,
          PatDeptDesc:specimen.schedule.PatDeptDesc,
          ScrubNurseDesc:specimen.schedule.ScrubNurseDesc,
          CircualNurseDesc:specimen.schedule.CircualNurseDesc,
          OperSchedule:specimen.schedule.RowId,
          CreateUser:session.UserID,
          UpdateUser:session.UserID,
          UpdateUserDesc:session.UserName,
          PrevDiagnosisDesc:specimen.schedule.PrevDiagnosisDesc,
          OperDesc:specimen.schedule.OperDesc,
          Description:"",
          OutTime:"",
          SoakTime:"",
          SendOutTime:"",
          SpecimenType:"",
          SurgeonDesc:specimen.schedule.SurgeonDesc,
          OperSeq:specimen.schedule.OperSeq
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
                removeParas.push({ClassName:ANCLS.Model.Specimen,RowId:checkRow.RowId});
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
            
            specimen.removeRows(checkRows);
          }
        });
      }
    });

    $("#btnSave").linkbutton({
      onClick:function(){
        dhccl.endEditDataBox("dataBox");
        var dataRows=$("#dataBox").datagrid("getRows");
        var dataInterityList=[];
        for(var i=0;i<dataRows.length;i++){

          var dataRow=dataRows[i];
          var messages=[];
          if(!dataRow.Description){
            messages.push("标本名称");
          }
          if(!dataRow.SpecimenType){
            messages.push("标本类型");
          }
          if(!dataRow.OutTime){
            messages.push("离体时间");
          }
          if(!dataRow.SoakTime && dataRow.SpecimenType==="P"){
            messages.push("浸泡时间");
          }
          if(!dataRow.SendOutTime && dataRow.SpecimenType==="F"){
            messages.push("送出时间");
          }
          if(messages.length>0){
            dataInterityList.push("第"+(i+1)+"条标本记录数据不完整，不能保存。");
          }
          dataRow.ClassName=ANCLS.Model.Specimen;
          if(dataRow.RowId){
            dataRow.UpdateUser=session.UserID;
          }
        }

        if(dataInterityList.length>0){
          $.messager.alert("提示",dataInterityList.join("<br>"),"warning");
          return 
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
        if(!checkedRows || checkedRows.length===0){
          $.messager.alert("提示","请勾选需要打印条码的标本。","warning");
          return;
        }
        var unSaveList=[];
        for(var i=0;i<checkedRows.length;i++){
          var checkedRow=checkedRows[i];
          if(!checkedRow.RowId){
            unSaveList.push("存在未保存的标本记录("+(checkedRow.Description || '')+")，不能打印。");
          }
        }
        if(unSaveList.length>0){
          $.messager.alert("提示",unSaveList.join("<br>"),"warning");
          return;
        }
        var lodop=getLodop();
        lodop.PRINT_INIT("标本标签");
        lodop.SET_PRINT_PAGESIZE(1, "7cm", "5cm", "");

        for(var i=0;i<checkedRows.length;i++){
          var checkedRow=checkedRows[i];
          if(i>0) lodop.NEWPAGE();
          var htmlArr=[
            "<style> div {font-size:12px;marign-bottom:10px;}</style>",
            "<div style='margin-bottom:0'>",
              "<span style='font-size:20px;margin-right:20px'>"+checkedRow.PatName+"</span>",
              "<span style='margin-right:20px'>"+checkedRow.PatGender+"</span>",
              "<span style='margin-right:20px'>"+checkedRow.PatAge+"</span>",
              "<span>"+checkedRow.RoomDesc+"</span>",
            "</div>",
            "<div>",
              "登记号："+checkedRow.RegNo,
            "</div>",
            "<div>",
              "<span style='margin-right:20px'>科室："+checkedRow.PatDeptDesc+"</span>",
              "<span>"+checkedRow.OperDate+"</span>",
            "</div>",
            "<div>",
              "诊断："+checkedRow.PrevDiagnosisDesc,
            "</div>",
            "<div>",
              "术式："+checkedRow.OperDesc,
            "</div>",
            "<div>",
              "<span style='margin-right:20px'>医生："+checkedRow.SurgeonDesc+"</span>",
              "<span>巡回："+checkedRow.CircualNurseDesc+"</span>",
            "</div>",
            "<div>",
              "<span style='margin-right:20px'>"+checkedRow.SpecimenTypeDesc+"</span>",
              "<span>总数："+checkedRow.Qty+"</span>",
            "</div>",
            "<div>",
              "<span'>标本名称："+checkedRow.Description+"</span>",
            "</div>",
            "<div>",
              "<span style='margin-right:20px'>离体："+checkedRow.OutTime+"</span>",
              "<span>"+(checkedRow.SpecimenType==="P"?"浸泡":"送出")+"："+(checkedRow.SpecimenType==="P"?checkedRow.SoakTime:checkedRow.SendOutTime)+"</span>",
            "</div>"
          ];

          lodop.ADD_PRINT_HTM("0.2cm","0.5cm","100%","100%",htmlArr.join(""));
          lodop.ADD_PRINT_BARCODE("3.8cm","0.5cm","4cm","1cm","128A",checkedRow.RegNo);
        }

        lodop.PREVIEW();
      }
    });
  },

  loadCommonData:function(){
    specimen.schedule=operDataManager.getOperAppData();
    var queryPara = [{
          ListName: "specimenType",
          ClassName: ANCLS.BLL.CodeQueries,
          QueryName: "FindDictDataByCode",
          Arg1:"SpecimenType",
          ArgCnt: 1
      }];

      var queryData = dhccl.getDatas(ANCSP.DataQueries, {
          jsonData: dhccl.formatObjects(queryPara)
      }, "json");
      if (queryData) {
          for (var key in queryData) {
            specimen.opts[key] = queryData[key];
          }
      }
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

$(document).ready(specimen.init);