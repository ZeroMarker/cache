//ICU患者日志-科室患者信息-Gui(SurveryDate,LocID)
var objScreen = new Object();
function InitLocPatientsWin() {
    var obj = objScreen;
	 obj.ICUPatLogSplit = $cm ({							
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"ICUPatLogSplit"
	},false);
    //ICU科室患者信息
    obj.gridICULoc = $HUI.datagrid("#gridICULoc", {
        fit: true,
        title: "在科患者列表",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: false,   //自动换行
        loadMsg: '数据加载中...',
        url: $URL,
        pageSize: 999,
        queryParams: {
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryICUAdmStr",
            aDate: SurveryDate,
            aLocDr: LocID
        },
        columns: [[
			{ field: 'RowID', title: '序号', width: 50 },
			{ field: 'PapmiNo', title: '病案号', width: 95 },
			{ field: 'PatientName', title: '姓名', width: 80 },
			{ field: 'Sex', title: '性别', width: 50 },
			{ field: 'Age', title: '年龄', width: 50 },
			{ field: 'PAAdmBed', title: '床号', width: 60 },
		    {
		        field: 'Paadm', title: '摘要', width: 50,
		        formatter: function (value, row, index) {
		            return " <a href='#' style='white-space:normal;text-decoration:underline;color:#339eff;' onclick='objScreen.OpenView(\"" + row.Paadm + "\");'>"+$g("摘要")+"</a>";
		        }
		    },
            { field: 'PAAdmDate', title: '入科日期', width: 100 },
            { field: 'PADischDate', title: '出科日期', width: 100 },
            {
                 field: 'IsCVC', title: 'CVC', width: 80,
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (value == "1") {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="CVC" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="CVC"/>';
                     }
                     return rst
                 }
             },
            {
                 field: 'IsPICC1', title: 'PICC', width: 80,hidden:(obj.ICUPatLogSplit!=1?true:false),
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (row.IsPICC == "1") {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PICC" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PICC"/>';
                     }
                     return rst
                 }
             },
            {
                 field: 'IsPICC', title: '中央血管导管', width: 100,hidden:(obj.ICUPatLogSplit!=1?false:true),
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (value == "1") {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PICC" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PICC"/>';
                     }
                     return rst
                 }
             },
            {
                 field: 'IsCRRT', title: '血透(CRRT)', width: 100,
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (value == "1") {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="CRRT" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="CRRT"/>';
                     }
                     return rst
                 }
             },
            {
                 field: 'IsPORT', title: '输液港(PORT)', width: 100,
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (value == "1") {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PORT" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="PORT"/>';
                     }
                     return rst
                 }
             },
              {
                  field: 'IsVAP', title: '呼吸机', width: 65,
                  formatter: function (value, row, index) {
                      var rst = "";
                      if (value == "1") {
                          rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="VAP" checked/></div>';
                      }
                      else {
                          rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="VAP"/>';
                      }
                      return rst
                  }
              },
               {
                   field: 'IsUC', title: '泌尿道插管', width: 90,
                   formatter: function (value, row, index) {
                       var rst = "";
                       if (value == "1") {
                           rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="UC" checked/></div>';
                       }
                       else {
                           rst = '<input type="checkbox" name="ICU' + row.RowID + '" value="UC"/>';
                       }
                       return rst
                   }
               }
        ]],
        onSelect: function (Index, rowData) {
            obj.SelectPaadm = rowData.EpisodeDr;
            //点击刷新医嘱信息
            obj.refreshgridICUOE(rowData.EpisodeDr, 0);
        },
        onLoadSuccess: function (data) {
            if (obj.ICUPatLogSplit!=1){
	            $('#gridICULoc').datagrid("hideColumn","IsCVC");
	            $('#gridICULoc').datagrid("hideColumn","IsCRRT");
	            $('#gridICULoc').datagrid("hideColumn","IsPORT");
            }
        }
    });
    //ICU患者医嘱信息
    obj.gridICUOE = $HUI.datagrid("#gridICUOE", {
        fit: true,
        title: "三管医嘱",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: false,   //自动换行
        loadMsg: '数据加载中...',
        pageSize: 999,
        columns: [[
			{ field: 'OeItemDesc', title: '医嘱名称', width: '120'},
			{ field: 'StartDt', title: '开嘱时间', width: '155'},
			{ field: 'EndDt', title: '停嘱时间', width: '155'}
        ]],
        rowStyler: function (index, row) {
            if (row.TypeValue == "临时医嘱") {
                return 'background-color:pink;';
            }
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
   
    InitLocPatientsWinEvent(obj);
	return obj;
}