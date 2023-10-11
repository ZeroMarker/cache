//督查表评估查询[Gui]
var objScreen = new Object();
function InitIExAWin() {
    var obj = objScreen;
    
    //管理员权限
    obj.IsAdmin = 0;
    if (tDHCMedMenuOper['Admin'] == 1) {
        obj.IsAdmin = 1;
    }
    //初始化院区
    var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false); 
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:HospList.rows,
		onSelect:function(rec){
			//初始化ICU病区
    		var LocalList = $cm ({
				ClassName:"DHCHAI.BTS.LocationSrv",
				QueryName:"QryICULoc",
				aHospIDs:$('#cboHospital').combobox('getValue'),
				aLocID:(obj.IsAdmin!=1 ? $.LOGON.LOCID:""),
				aTypeID:1				//ICU
			},false);
   			$HUI.combobox("#cboLocal",{
				valueField:'ID',
				textField:'LocDesc2',
				editable:false,
				data:LocalList.rows,
				onLoadSuccess:function(data){
					if(data!=""){
						if(obj.IsAdmin!=1){
							$('#cboLocal').combobox('select',data[0].ID);
							$('#cboLocal').combobox('disable');	
						}
					}
				}
			});
		},
		onLoadSuccess:function(data){
			if(data!=""){
				$('#cboHospital').combobox('select',data[0].ID);
				if(obj.IsAdmin!=1){
					$('#cboHospital').combobox('disable');	
				}
			}
		}
	});
    
    //初始化调查日期(默认当前日期)
    obj.dtDateFrom=$('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
    obj.dtDateTo=$('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
    
  	//初始化插管类型(PICC|VAP|UC)
    $HUI.combobox("#cboTubeType",{
		data:[
			{value:'ALL',text:$g('全部'),selected:true},
			{value:'PICC',text:$g('中央血管导管')},
			{value:'VAP',text:$g('呼吸机')},
			{value:'UC',text:$g('导尿管')}
		],
		valueField:'value',
		textField:'text'
	})
	
    //加载插拔管评估表列表
    obj.gridIExA = $('#gridIExA').datagrid({
        fit: true,
        title: '三管感染防控督查表查询',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',	
        rownumbers: false, 			
        singleSelect: true,
        loadMsg: '数据加载中...',
        //是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false, 

        pagination: true, 		
        pageSize: 20,
        pageList: [20, 50, 100, 200],
        columns: [[
			{ field: 'MrNo', title: '病案号', width: 100, align: 'center',sortable:true,sorter:Sort_int},
			{ field: 'PatName', title: '姓名', width: 80, align: 'center',sortable:true,sorter:Sort_int},
			{ field: 'Sex', title: '性别', width: 50, align: 'center',sortable:true,sorter:Sort_int},
			{ field: 'Age', title: '年龄', width: 80, align: 'center',sortable:true,sorter:Sort_int},
			{ field: 'AdmBed', title: '床号', width: 60, align: 'center',sortable:true,sorter:Sort_int},
			{
			    field: 'ZY', title: '摘要', width: 60, align: 'center',
			    formatter: function (value, row, index) {
			        return "<a href='#' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>"+$g('摘要')+"</a>";
			    }
			},
            {
                field: 'PICCData', title: '中央血管导管', width: 200, align: 'center',sortable:true,sorter:Sort_int,
                formatter: function (value, row, index) {
                    if (value == "首次评估") {
                        var src = '<img src=" ../scripts/DHCMA/HAI/img/评估.png" >';
                        return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenIExARep(\"" + "" + "\",\"" + row.EpisodeID + "\",\"" + "PICC" + "\");'>" + src + "</a>";
                    }
                    else {
                        var Ret = "";
                        for (var i = 0; i < value.split("^").length ; i++) {
                            var IExAData = value.split("^")[i];

                            var IExAID = IExAData.split("|")[0];
                            
                            var TypeDesc = IExAData.split("|")[2];
                            var IntuDate = IExAData.split("|")[3];
                            var IsNeedAssert = IExAData.split("|")[5];
                            
                            var str = TypeDesc + " " + IntuDate;
                            if (IsNeedAssert == 1) {
                                Ret=Ret+"<a href='#' style='white-space:normal; color:Red' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "PICC" + "\");'>" + str + "</a><br>";
                            }
                            else {
                                Ret = Ret + "<a href='#' style='white-space:normal; color:Blue' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "PICC" + "\");'>" + str + "</a><br>";
                            }
                        }
                        return Ret;
                    }
                }
            },
			{
			    field: 'VAPData', title: '呼吸机', width: 200, align: 'center',sortable:true,sorter:Sort_int,
			    formatter: function (value, row, index) {
			        if (value == "首次评估") {
                        var src = '<img src=" ../scripts/DHCMA/HAI/img/评估.png" >';
                        return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenIExARep(\"" + "" + "\",\"" + row.EpisodeID + "\",\"" + "VAP" + "\");'>" + src + "</a>";
                    }
                    else {
                        var Ret = "";
                        for (var i = 0; i < value.split("^").length ; i++) {
                            var IExAData = value.split("^")[i];

                            var IExAID = IExAData.split("|")[0];
                            
                            var TypeDesc = IExAData.split("|")[2];
                            var IntuDate = IExAData.split("|")[3];
                            var IsNeedAssert = IExAData.split("|")[5];
                            
                            var str = TypeDesc + " " + IntuDate;
                            if (IsNeedAssert == 1) {
                                Ret=Ret+"<a href='#' style='white-space:normal; color:Red' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "VAP" + "\");'>" + str + "</a><br>";
                            }
                            else {
                                Ret = Ret + "<a href='#' style='white-space:normal; color:Blue' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "VAP" + "\");'>" + str + "</a><br>";
                            }
                        }
                        return Ret;
                    }
			    }
			},
			{
			    field: 'UCData', title: '导尿管', width: 200, align: 'center',sortable:true,sorter:Sort_int,
			    formatter: function (value, row, index) {
			        if (value == "首次评估") {
                        var src = '<img src=" ../scripts/DHCMA/HAI/img/评估.png" >';
                        return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenIExARep(\"" + "" + "\",\"" + row.EpisodeID + "\",\"" + "UC" + "\");'>" + src + "</a>";
                    }
                    else {
                        var Ret = "";
                        for (var i = 0; i < value.split("^").length ; i++) {
                            var IExAData = value.split("^")[i];

                            var IExAID = IExAData.split("|")[0];
                            
                            var TypeDesc = IExAData.split("|")[2];
                            var IntuDate = IExAData.split("|")[3];
                            var IsNeedAssert = IExAData.split("|")[5];
                            
                            var str = TypeDesc + " " + IntuDate;
                            if (IsNeedAssert == 1) {
                                Ret=Ret+"<a href='#' style='white-space:normal; color:Red' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "UC" + "\");'>" + str + "</a><br>";
                            }
                            else {
                                Ret = Ret + "<a href='#' style='white-space:normal; color:Blue' onclick='objScreen.OpenIExARep(\"" + IExAID + "\",\"" + row.EpisodeID + "\",\"" + "UC" + "\");'>" + str + "</a><br>";
                            }
                        }
                        return Ret;
                    }
			    }
			},
			{ field: 'InfTube', title: '插管感染', width: 180, align: 'center',sortable:true,sorter:Sort_int,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field: 'Diag', title: '诊断', width: 250, align: 'center',sortable:true,sorter:Sort_int,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field: 'AdmDateTime', title: '入院日期', width: 160, align: 'center',sortable:true,sorter:Sort_int},
           	{ field: 'DischDateTime', title: '出院日期', width: 160, align: 'center',sortable:true,sorter:Sort_int}
	    ]],
	    onLoadSuccess: function (data) {
	        dispalyEasyUILoad(); 		//隐藏效果
	    }
	});
	//加载'患者'对应类别的评估表
	obj.gridIExAReport = $('#gridIExAReport').datagrid({
		fit: true,
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true, 			//如果为true, 则显示一个行号列
		singleSelect: false,
		fitColumns: true,
		loadMsg: '数据加载中...',
        columns: [[
			{ field: 'DicDesc', title: '插管类型', width: 200 },
			{ field: 'IntuDate', title: '置管日期', width: 100 },
			{ field: 'ExtuDate', title: '拔管日期', width: 120 },
			{
				field: 'IsActive', title: '操作', width: 60, align: 'center',
				formatter: function (value, row, index) {
					if (value == 1) {
						return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.UpdateStatus(\"" + row.IExAID + "\",\"" + 0 + "\");'>"+$g("删除")+"</a>";
					}
					else {
						return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.UpdateStatus(\"" + row.IExAID + "\",\"" + 1 + "\");'>"+$g("激活")+"</a>"
					}
				}
			}
		]],
		rowStyler: function (index, row) {
			if (row.IsActive == 0) {
				return 'color:#bcb9b9;';
			}
			else {
				return 'color:black;';
			}
		},
	    onLoadSuccess: function (data) {
	        dispalyEasyUILoad(); 		//隐藏效果
	    }
	});
	//加载'患者'三管医嘱
	obj.gridHisOEOrdItem = $HUI.datagrid("#gridHisOEOrdItem", {
            fit: true,
            headerCls: 'panel-header-gray',
            iconCls: 'icon-paper',
            rownumbers: true, //如果为true, 则显示一个行号列
            singleSelect: true,
            fitColumns: true,
            loadMsg: '数据加载中...',
            columns: [[
				{ field: 'OeItemDesc', title: '医嘱名称', width: 150,showTip:true,tipWidth:200,tipTrackMouse:true},
				{ field: 'StartDt', title: '医嘱开始日期', width: 200,showTip:true,tipWidth:200,tipTrackMouse:true },
				{ field: 'EndDt', title: '医嘱结束日期', width: 200,showTip:true,tipWidth:200,tipTrackMouse:true},
                { field: 'TypeValue', title: '医嘱类型', width: 120 }
            ]],
	    	onLoadSuccess: function (data) {
	        	dispalyEasyUILoad(); 		//隐藏效果
	   	 	}
        });
	
	
	InitIExAWinWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
