var arrange={
  opts:{
    curMonth:{
      startDate:"",
      endDate:"",
      month:-1,
      year:-1
    }
  },

  init:function(){
    arrange.loadCommonData();
    arrange.initArrangeBox();
    arrange.initOperActions();
  },

  loadCommonData:function(){
    var queryPara = [{
        ListName: "careProvs",
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindCareProvByLoc",
        Arg1:"",
        Arg2:session.DeptID,
        ArgCnt: 2
    }];

    var queryData = dhccl.getDatas(ANCSP.DataQueries, {
        jsonData: dhccl.formatObjects(queryPara)
    }, "json");
    if (queryData) {
        for (var key in queryData) {
            arrange.opts[key] = queryData[key];
        }
    }
  },

  initOperActions:function(){
    $("#btnNextMonth").linkbutton({
      onClick:function(){
        var dayColumns=arrange.getDayColumns(1);
        var columns=[dayColumns];
        $("#dataBox").datagrid({
          columns:columns
        });
      }
    });

    $("#btnPrevMonth").linkbutton({
      onClick:function(){
        var dayColumns=arrange.getDayColumns(-1);
        var columns=[dayColumns];
        $("#dataBox").datagrid({
          columns:columns
        });
      }
    });

    $("#btnImport").linkbutton({
      onClick:function(){
        $("#upload").click();
      }
    });

    $("#upload").on("change",function(e){
      var files=e.target.files;
      var fileReader=new FileReader();
      fileReader.onload=function(ev){
        try {
          var data=ev.target.result,
              workbook=XLSX.read(data,{
                type:"binary"
              }),
              arrangeList=[];
        } catch (error) {
          console.log("文件类型不正确");
          return;
        }

        var fromTo="";
        for(var sheet in workbook.Sheets){
          if(workbook.Sheets.hasOwnProperty(sheet)){
            fromTo = workbook.Sheets[sheet]['!ref'];
            console.log(fromTo);
            arrangeList = arrangeList.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
            break;
          }
        }
      }
    });
  },

  initArrangeBox:function(){
    var dayColumns=arrange.getDayColumns(0);
    var arrangeData=arrange.getArrangeData();
    var columns=[dayColumns];
    $("#dataBox").datagrid({
      title:"科室月排班",
      fit:"true",
      iconCls:"icon-cal-open",
      singleSelect:true,
      rownumbers:true,
      headerCls:"panel-header-gray",
      toolbar:"#dataTools",
      columns:columns,
      data:arrangeData,
      onClickCell:function(rowIndex,field,value){
        arrange.toggleAStatus(rowIndex,field,value);
      }
    });
  },

  getYearMonth:function(addMonth){
    var today=moment();
    if(arrange.opts.today){
      today=arrange.opts.today;
    }
    if(addMonth>=0){
      today=today.add(addMonth,"M");
    }else{
      today=today.subtract(addMonth*(-1),"M");
    }
    arrange.opts.today=today;
    var year=today.get("year");
    var month=today.get("month")+1;
    return {year:year,month:month};
  },

  /**
   * 获取某年某月日期列集合
   * @param {Number} month 月份
   */
  getDayColumns:function(addMonth){
    var yearMonth=arrange.getYearMonth(addMonth);
    var year=yearMonth.year,month=yearMonth.month;
    var columns=[];
    var date=new Date(year,month-1,1);
    arrange.opts.curMonth.startDate=date.format("yyyy-MM-dd");
    arrange.opts.curMonth.month=month;
    arrange.opts.curMonth.year=year;
    while(date.getMonth()===month-1){
      columns.push({
        field:date.format("yyyy-MM-dd"),
        title:date.getDate(),
        width:40,
        formatter:function(value,row,index){
          if(value==="B"){
            return "休息";
          }

          return value;
        }
      });
      date.setDate(date.getDate()+1);
      arrange.opts.curMonth.endDate=date.format("yyyy-MM-dd");
    }

    columns.unshift({
      title:(year+"年"+month+"月"),
      field:"CareProvDesc",
      width:120
    });

    return columns;
  },

  getArrangeData:function(){
    var dataList=[];
    if(arrange.opts.careProvs && arrange.opts.careProvs.length>0){
      var year=arrange.opts.curMonth.year;
      var month=arrange.opts.curMonth.month;
      arrange.loadAttendanceList();
      for(var i=0;i<arrange.opts.careProvs.length;i++){
        var careProv=arrange.opts.careProvs[i];
        var row={
          RowId:"",
          CareProvID:careProv.RowId,
          CareProvDesc:careProv.Description
        };
        var date=new Date(year,month-1,1);
        while(date.getMonth()===month-1){
          var columnDate=date.format("yyyy-MM-dd");
          var attendance=arrange.getAttendance(columnDate,careProv.RowId);
          if(attendance && attendance.StatusDesc){
            row[columnDate]=attendance.StatusDesc;
          }
          date.setDate(date.getDate()+1);
        }
        dataList.push(row);
      }
    }

    return dataList;
  },

  loadAttendanceList:function(){
    var startDate=arrange.opts.curMonth.startDate;
    var endDate=arrange.opts.curMonth.endDate;
    var retList=dhccl.getDatas(ANCSP.DataQuery,{
      ClassName:ANCLS.BLL.DataQueries,
      QueryName:"FindAttendanceByDateRange",
      Arg1:startDate,
      Arg2:endDate,
      Arg3:session.DeptID,
      ArgCnt:3
    },"json");
    arrange.opts.attendanceList=retList;
  },

  getAttendance:function(attendDate,member){
    var attendanceList=arrange.opts.attendanceList;
    var res=null;
    if(attendanceList && attendanceList.length>0){
      for(var i=0;i<attendanceList.length;i++){
        var attendance=attendanceList[i];
        if(attendance.Member===member && attendance.AttendLocalDate===attendDate){
          res=attendance;
          break;
        }
      }
    }

    return res;
  },

  toggleAStatus:function(rowIndex,field,value){
    var rows=$("#dataBox").datagrid("getRows");
    var rowData=rows[rowIndex];
    if(!value){
      rowData[field]="A";
    }else if(value==="A"){
      rowData[field]="B";
    }else if(value==="B"){
      rowData[field]="";
    }
    arrange.saveData(rowData.CareProvID,field,rowData[field]);
    $("#dataBox").datagrid("refreshRow",rowIndex);
  },

  toggleBStatus:function(rowIndex,field,value){
    var rows=$("#dataBox").datagrid("getRows");
    var rowData=rows[rowIndex];
    if(!value){
      rowData[field]="B";
    }else{
      rowData[field]="";
    }
    $("#dataBox").datagrid("refreshRow",rowIndex);
  },

  saveData:function(careProv,arrangeDate,status,rowData,rowIndex){
    var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperArrange,"SaveAttendance",session.DeptID,careProv,arrangeDate,status,session.UserID);
    if(res.indexOf("S^")===0){
      
    }else{
      $.messager.alert("提示","保存排班失败，原因："+res,"error");
    }
  }
}

$(document).ready(arrange.init);