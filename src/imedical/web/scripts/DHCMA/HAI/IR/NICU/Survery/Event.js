//NICU患者日志->Event
function InitSurveryWinEvent(obj) {
	//初始化信息
	obj.LoadEvent = function () {
		//加载管理员权限
    	obj.Admin = 0;
    	if (tDHCMedMenuOper['Admin'] == 1) {
        	obj.Admin = 1;  
    	} 
        //加载日期时间
		var NowDate=month_formatter(new Date());
		var NowYear=NowDate.split("-")[0];		//当前年
		var NowMonth=NowDate.split("-")[1]		//当前月
		
		var NowDay = new Date().getDate();
		if (NowDay<FormDay) {
			if((NowMonth-1)>0){					//显示前一个月 年-月格式
				NowMonth=NowMonth-1;
			}
			else{
				NowYear=NowYear-1;
				NowMonth=12;
			} 
		}
       	$('#cboYear').combobox('select',NowYear);
       	$('#cboMonth').combobox('select',NowMonth);
	    //加载院区+科室
	    obj.cboHospital = $HUI.combobox("#cboHospital", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'ID',
            textField: 'HospDesc',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.BTS.HospitalSrv';
                param.QueryName = 'QryHospListByLogon';
                param.aLogonHospID = $.LOGON.HOSPID;
                param.ResultSetType = 'array';
            },
            onLoadSuccess: function () {   //初始加载赋值
            	var data = $(this).combobox('getData');
            	for (var ind = 0; ind < data.length; ind++) {
               		if (data[ind]['ID'] == $.LOGON.HOSPID) {
               			$(this).combobox('select', $.LOGON.HOSPID);
               		}
          		}
            }
        });
        if (obj.Admin != 1){
	    	$('#cboHospital').combobox('disable');
	    }
        //初始值
        obj.SelectLocID = "";   //选中科室
    }
    //院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function () {
            refreshLocList();   //刷新ICU科室
        }
    });
    //年点击事件
    $HUI.combobox('#cboYear', {
        onSelect: function () {
        	if (IsApgar == 1) {
        		obj.refreshNICUA();
        	} else {
        		obj.refreshNICUW();
          	} 
        }
    });
    //月点击事件
    $HUI.combobox('#cboMonth', {
        onSelect: function () {
            if (IsApgar == 1) {
        		obj.refreshNICUA();
        	} else {
        		obj.refreshNICUW();
          	} 
        }
    });
    //加载NICU患者日志(Apgar评分)[表]
    obj.refreshNICUA = function () {
	    $('#LayerNICULogsA').show();
	    $('#LayerNICULogsW').hide();
	    var aLocDr=obj.SelectLocID;						//科室
	    var Year=$('#cboYear').combobox('getValue');	//日期
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;
	    //加载表[前台加载]
        $("#gridNICULogsA").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryNAISByMonth",
            aYYMM: aYYMM,
            aLocDr: aLocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridNICULogsA').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //加载NICU患者日志(体重)[表]
    obj.refreshNICUW = function () {
	    $('#LayerNICULogsA').hide();
	    $('#LayerNICULogsW').show();
	    
		var aLocDr=obj.SelectLocID;						//科室
	    var Year=$('#cboYear').combobox('getValue');	//日期
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;
	    //加载表[前台加载]
        $("#gridNICULogsW").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
            QueryName: "QryNAISByMonth",
            aYYMM: aYYMM,
            aLocDr: aLocDr,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridNICULogsW').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //NICU患者日志(Apgar评分)导出
    $("#btnNICUExportA").on('click', function () {
		var rows = obj.gridNICULogsA.getRows().length;  
		var Year=$('#cboYear').combobox('getValue');	//日期
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var YYMM=Year+"-"+Month;

		if (rows>0) {
			  ExportNICUData(YYMM,obj.SelectLocID,2);
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
    });
    //NICU患者日志(体重评分)导出
    $("#btnNICUExportW").on('click', function () {
		var rows = obj.gridNICULogsW.getRows().length;  
		var Year=$('#cboYear').combobox('getValue');	//日期
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var YYMM=Year+"-"+Month;

		if (rows>0) {
			 ExportNICUData(YYMM,obj.SelectLocID,1);
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
    });
    //科室患者明细(NICU)
    obj.OpenNICULocExt = function (SurveryDate, LocDesc) {
        var strUrl = "./dhcma.hai.ir.nicu.locpatients.csp?LocID=" + obj.SelectLocID + "&SurveryDate=" + SurveryDate+"&LocFlag="+LocFlag;
        websys_showModal({
            url: strUrl,
            title: $g('NICU插管情况')+'(' + LocDesc + " " + SurveryDate + ')',
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%',
            onBeforeClose: function () {
                if (IsApgar == 1) {
                    obj.refreshNICUA();	//关闭前刷新
                }
                else {
                    obj.refreshNICUW();	//关闭前刷新
                }
            }
        });
    }
    //方法
    //1.指定列求和
    obj.computeNICUA = function (colName) {
        var rows = $('#gridNICULogsA').datagrid('getRows');

        var total = 0;
        for (var i = 0; i < rows.length; i++) {
            if (parseInt(rows[i][colName]) > 0) total = total + parseInt(rows[i][colName]);
        }
        return total;
    }
    obj.computeNICUW = function (colName) {
        var rows = $('#gridNICULogsW').datagrid('getRows');

        var total = 0;
        for (var i = 0; i < rows.length; i++) {
            if (parseInt(rows[i][colName]) > 0) total = total + parseInt(rows[i][colName]);
        }
        return total;
    }
    //2.刷新科室[NICU]
    function refreshLocList() {
         var HospID = $('#cboHospital').combobox('getValue');	//院区
        if (HospID == "") return;
        
        var LocID = ""; 
        if (obj.Admin != 1) {
            LocID = $.LOGON.LOCID;     							//当前病区
        }
        //加载科室[ICU]
        $HUI.datagrid("#gridLocList", {
            fit: true,
            title: "筛查条件",
            iconCls: "icon-resort",
            headerCls: 'panel-header-gray',
            singleSelect: true,
            loadMsg: '数据加载中...',           
			pagination: false,
            pageSize: 999,			
			url: $URL,
			queryParams:{
                ClassName: "DHCHAI.BTS.LocationSrv",
                QueryName: "QryICULoc",
                aHospIDs: HospID,
                aLocID: LocID,
                aTypeID:2
            },
            columns: [[
			{ field: 'LocDesc2', title: '科室', width: 277,
                formatter: function (value, row, index) {
                    var str = '<span id="Loc-' + index + '"style="user-select: none;padding-left:20px;" >' + value + '</span>';
                    var str = str + '<span style="width:45px;background-color:orange;color:white;display:block;text-align:center;float:right;">NICU</span>'
                    return str;
                }
            }]],
            onSelect: function (Index, rowData) {
                if (rowData != "") {
                    obj.SelectLocID = rowData.ID;       //赋值[选中科室]
					//选中事件[字体加粗+背景色]
                    var rows = $('#gridLocList').datagrid('getRows');
                    for (var i = 0; i < rows.length; i++) {              
                        if (i == Index) {
                            $('#Loc-' + i).css('font-weight', 'bold');
                        }
                        else {
                            $('#Loc-' + i).css('font-weight', '');
                        }
                    }
                    //加载表格
                   	if (IsApgar == 1) {
        				obj.refreshNICUA();
        			} else {
        				obj.refreshNICUW();
          			} 
                }
            },
            rowStyler: function (index, row) {
                if (row.IsNICU == $g("未配置")) return 'background-color:#f7f7f7;';        //未配置ICU显示灰色
            },
            onLoadSuccess: function (data) {
                if (data.total > 0) {
                    $('#gridLocList').datagrid('selectRow', 0);     //默认选中第一行
                } else {
                    $('#gridLocList').datagrid('appendRow', {
                        ID: $.LOGON.LOCID,
                        LocDesc2: '<b>' + $.LOGON.LOCDESC + '('+$g("未配置")+')'+'</b>',
                        IsNICU: $g("未配置")
                    });
                    //加载表格
                   	if (IsApgar == 1) {
        				obj.refreshNICUA();
        			} else {
        				obj.refreshNICUW();
          			} 
                }
            }
        });
		$('#west .datagrid-header').hide();     //隐藏头
    }
}

