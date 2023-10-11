//NICU患者日志-科室患者信息-Gui(SurveryDate,LocID,IsApgar)
var objScreen = new Object();
function InitNLocPatientsWin() {
    var obj = objScreen;
   
    //是否启用Apgar评分
    var ColTitle = (IsApgar == 1) ? "Apgar<br>评分" : "入院<br>体重(g)";
    var ColFiled = (IsApgar == 1) ? "PatApgar" : "PatWeight";
    //NICU科室患者信息
    obj.gridNICULoc = $HUI.datagrid("#gridNICULoc", {
        fit: true,
        title: "在科患者列表",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
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
			{ field: 'PAAdmBed', title: '床号', width: 50 },
		    {
		        field: 'Paadm', title: '摘要', width: 50,
		        formatter: function (value, row, index) {
		            return " <a href='#' style='white-space:normal; ' onclick='objScreen.OpenView(\"" + row.Paadm + "\");'>"+$g("摘要")+"</a>";
		        }
		    },
            { field: 'PAAdmDate', title: '入科日期', width: 100 },
            { field: 'PADischDate', title: '出科日期', width: 100 },
            { field: ColFiled, title: $g(ColTitle), width: 60 },
             {
                 field: 'IsPICC', title: $g('中央血管导管'), width: 100,
                 formatter: function (value, row, index) {
                     var rst = "";
                     if (value == "1") {
                         rst = '<input type="checkbox" name="NICU' + row.RowID + '" value="PICC" checked/></div>';
                     }
                     else {
                         rst = '<input type="checkbox" name="NICU' + row.RowID + '" value="PICC"/>';
                     }
                     return rst
                 }
             },
              {
                  field: 'IsVAP', title: '呼吸机', width: 70,
                  formatter: function (value, row, index) {
                      var rst = "";
                      if (value == "1") {
                          rst = '<input type="checkbox" name="NICU' + row.RowID + '" value="VAP" checked/></div>';
                      }
                      else {
                          rst = '<input type="checkbox" name="NICU' + row.RowID + '" value="VAP"/>';
                      }
                      return rst
                  }
              },
               {
                   field: 'SetWeight', title: '操作', width: 80,
                   formatter: function (value, row, index) {
                       if (IsApgar == 1) {
                           var ret = " <a href='#' style='white-space:normal;' onclick='objScreen.OpenApgar(\"" + row.Paadm + "\", \""+row.PatApgar+"\");'>"+$g("补Apgar评分")+"</a>";
                       }
                       else {
                           var ret = " <a href='#' style='white-space:normal;' onclick='objScreen.OpenWeight(\"" + row.Paadm + "\", \""+row.PatWeight+"\");'>"+$g("补体重")+"</a>";
                       }
                      
                       return ret
                   }
               }
        ]],
        onSelect: function (Index, rowData) {
            obj.SelectPaadm = rowData.EpisodeDr;
            //点击刷新医嘱信息
            obj.refreshgridNICUOE(rowData.EpisodeDr, 0);
        }
    });
    //NICU患者医嘱信息
    obj.gridNICUOE = $HUI.datagrid("#gridNICUOE", {
        fit: true,
        title: "三管医嘱",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: false,   //自动换行
        loadMsg: '数据加载中...',      
        pageSize: 999,
        columns: [[
			{ field: 'OeItemDesc', title: '医嘱名称', width: '150' },
			{ field: 'StartDt', title: '开嘱时间', width: '110' },
			{ field: 'EndDt', title: '停嘱时间', width: '110' }
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

    InitNLocPatientsWinEvent(obj);
	return obj;
}