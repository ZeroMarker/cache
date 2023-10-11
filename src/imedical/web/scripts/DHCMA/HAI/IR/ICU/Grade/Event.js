//ICU患者危险等级评定Event
function InitGradeWinEvent(obj) {
    //初始化
    obj.LoadEvent = function () {
	    //获取管理员权限
    	obj.IsAdmin = 0;
    	if (tDHCMedMenuOper['Admin'] == 1) {
        	obj.IsAdmin = 1;  //管理员权限
    	}
    	//加载院区
    	if (obj.IsAdmin != 1) {   //非管理员权限
    	 	$('#cboHospital').combobox('select',$.LOGON.HOSPID);
            $('#cboHospital').combobox('disable');
        }
	    //加载年-月
		var NowDate=month_formatter(new Date());
		var NowYear=NowDate.split("-")[0];		//当前年
		var NowMonth=NowDate.split("-")[1]		//当前月
       	$('#cboYear').combobox('select',NowYear);
       	$('#cboMonth').combobox('select',NowMonth);
       	//加载ICU病区
        obj.SelectLocID = "";
        //是否固定每月四次(系统参数)
       	obj.IsWeek4 = $m({
         	ClassName: "DHCHAI.BT.Config",
        	MethodName: "GetValByCode",
            aCode: "ICUGradeIsWeek4"
      	}, false);
    }
    //院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function () {
            obj.refreshLocList();   //更新ICU科室
        }
    });
    //年点击事件
    $HUI.combobox('#cboYear', {
        onSelect: function () {
            obj.refreshGrade(); 
        }
    });
    //月点击事件
    $HUI.combobox('#cboMonth', {
        onSelect: function () {
            obj.refreshGrade();
        }
    });
   
    //ICU危险登记表(总表)刷新事件
    obj.refreshGrade = function () {
	  	var Year=$('#cboYear').combobox('getValue');
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;
		//加载危险等级评定表
        obj.gridGrade.load({
            ClassName: "DHCHAI.IRS.ICUGradeSrv",
            QueryName: "QryIGByMonth",
            aLocID: obj.SelectLocID,
            aYYMM: aYYMM
        })
        //更新
        var new_date = new Date(Year,Month,"01");                //取当年当月中的第一天         
      	var AlterDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月最后一天日期
      	var bcolumn = $('#gridGrade').datagrid('getColumnOption', "IGWeek5");
        bcolumn.title = $g('第五周')+'(29~'+AlterDate+')';
        $('#gridGrade').datagrid();
        //每周评定时间
	   	var AssertDates = $m({
         	ClassName: "DHCHAI.IRS.ICUGradeSrv",
        	MethodName: "GetAssertDate",
            aYYMM: aYYMM
      	}, false);
      	var Date5=AssertDates.split("^")[4];
      	if(obj.IsWeek4==1){
	      	$('#gridGrade').datagrid('hideColumn', 'IGWeek5');
	    }
	    else{
			if(Date5==""){	//没有第五周不显示
				$('#gridGrade').datagrid('hideColumn', 'IGWeek5')
			}
			else{
				$('#gridGrade').datagrid('showColumn', 'IGWeek5');
			}	
		}	
        //需评估字体标红
        for(var i=1;i<=5;i++){
	    	var IsNeedAssert=$m({
         		ClassName: "DHCHAI.IRS.ICUGradeSrv",
        		MethodName: "GetIsNeedAssert",
            	aLocID:obj.SelectLocID,
            	aYYMM:aYYMM,
            	aWeek:i
      		}, false);
      		if(IsNeedAssert==1){
	      		$('.datagrid-htable td[field="IGWeek'+i+'"]').css("color", "red");
	      	}
	      	else{
		    	$('.datagrid-htable td[field="IGWeek'+i+'"]').css("color", "black");
		    }
	    }
    	//刷新图
        obj.ShowEChart();
    }
    //ICU危险登记表(明细表)刷新事件
    obj.refreshGradeExt = function () {
        var aLocID = obj.SelectLocID;
        var Year=$('#cboYear').combobox('getValue');
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;
        var aWeek = $("input[name='Week']:checked").val();

		$cm ({
		 	ClassName: 'DHCHAI.IRS.ICUGradeSrv',
            QueryName: 'QryIGByWeek',
			ResultSetType:"array",
			aLocID: aLocID,
           	aYYMM: aYYMM,
            aWeek: aWeek,
			page:1,
			rows:999
		},function(rs){
			$('#gridGradeExt').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var page=""
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen'+"&LocFlag="+LocFlag;
		//var ratio =detectZoom();
        var PageWidth=1320    //Math.round(1320*ratio);
		websys_showModal({
			url:strUrl,
			title:$g('医院感染集成视图'),
			iconCls:'icon-w-epr',
			closable:true,
			width:'80%',
			height:'95%',
			onBeforeClose: function () {
			}
		});
		
		
	};
    //ICU危险登记表(总表)-编辑事件
    $('#btnEdit').click(function (e) {
        obj.OpenLayerGradeExt();
	});
    //ICU危险登记表(总表)-导出事件
    $('#btnExport').click(function (e) {
        $('#gridGrade').datagrid('toExcel', 'ICU危险等级评定.xls');   //导出
    });
    //第几周改变事件
    $HUI.radio("[name='Week']", {
        onCheckChange: function (e, value) {
            var iWeek = $("input[name='Week']:checked").val();
            if (iWeek != undefined) {
               obj.refreshGradeExt();
            }
        }
    });
    //ICU危险登记表(明细表)-保存
    $('#btnSaveExt').click(function (e) {
        var Data = $("#gridGradeExt").datagrid("getRows");
        if(Data.length<=0){
	    	 $.messager.popover({ msg: '页面无数据!', type: 'success', timeout: 2000 });
             return false;
	    }
	    
	    var InputStrs="";
        for (var index = 0; index < Data.length; index++) {
            var rowData = Data[index];

            var iPaadm = rowData.Paadm;
            var iWeek = $("input[name='Week']:checked").val();

            var iItem1 = 0, iItem2 = 0, iItem3 = 0, iItem4 = 0, iItem5 = 0;
            for (var i = 1; i <= 5; i++) {
                var CellId = "#Item" + i + "-" + index;
                var text = $(CellId).text();
                if (text == "✔") {
                    switch (i) {
                        case 1: iItem1 = 1; break;
                        case 2: iItem2 = 1; break;
                        case 3: iItem3 = 1; break;
                        case 4: iItem4 = 1; break;
                        case 5: iItem5 = 1; break;
                    }
                }
            }
            var Year=$('#cboYear').combobox('getValue');
	  		var Month=$('#cboMonth').combobox('getValue');
	  		if((Year=="")||(Month==""))return;
	  	
            var UserID=rowData.UserID;
            if((iItem1!=rowData.Item1)||(iItem2!=rowData.Item2)||(iItem3!=rowData.Item3)||(iItem4!=rowData.Item4)||(iItem5!=rowData.Item5)){
	        	UserID=$.LOGON.USERID;
	        }
            if((iItem1=="0")&&(iItem2=="0")&&(iItem3=="0")&&(iItem4=="0")&&(iItem5=="0")){
	            UserID="";
	        }
	        
            var InputStr = "^" + iPaadm + "^" + obj.SelectLocID + "^" + Year + "^" + Month + "^" + iWeek + "^" + iItem1 + "^" + iItem2 + "^" +
                iItem3 + "^" + iItem4 + "^" + iItem5+ "^^^" + UserID;
                
            var InputStrs=InputStrs+"#"+InputStr;
		}
		//保存危险登记评定
		var ret = $m({
			ClassName: "DHCHAI.IRS.ICUGradeSrv",
            MethodName: "SaveGrade",
            aInputStrs: InputStrs,
           	aSeparete: "^"
      	}, false);
		if (parseInt(ret) <= 0) {
			$.messager.popover({ msg: '保存失败！', type: 'success', timeout: 2000 });
			return false;
		}
		else {
			$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 2000 });
		}
            
        obj.refreshGradeExt();	//刷新明细表
    });
    //ICU危险登记表(明细表)-关闭
    $('#btnCloseExt').click(function (e) {
        $HUI.dialog('#LayerGradeExt').close();
    });
    //打开明细表
    obj.OpenLayerGradeExt=function(){
		//1.显示页面
		$('#LayerGradeExt').show();
		//2.初始化页面
		///2.1初始化
	    $('#divWeek5').show();
	    $HUI.radio("#Week5").enable("true");$("#txtWeek5").css("color","black");
	    $HUI.radio("#Week4").enable("true");$("#txtWeek4").css("color","black");
	    $HUI.radio("#Week3").enable("true");$("#txtWeek3").css("color","black");
	    $HUI.radio("#Week2").enable("true");$("#txtWeek2").css("color","black");
	    $HUI.radio("#Week1").enable("true");$("#txtWeek1").css("color","black");
	    ///2.1取每周评定时间
	    var Year=$('#cboYear').combobox('getValue');
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;
	    var AssertDates = $m({
         	ClassName: "DHCHAI.IRS.ICUGradeSrv",
        	MethodName: "GetAssertDate",
            aYYMM:aYYMM
      	}, false);
      	var Date1=AssertDates.split("^")[0];
      	var Date2=AssertDates.split("^")[1];
      	var Date3=AssertDates.split("^")[2];
      	var Date4=AssertDates.split("^")[3];
      	var Date5=AssertDates.split("^")[4];
	    $('#txtWeek1').html($g("第一周")+"("+Date1.substring(5,10)+")");
	    $('#txtWeek2').html($g("第二周")+"("+Date2.substring(5,10)+")");
	    $('#txtWeek3').html($g("第三周")+"("+Date3.substring(5,10)+")");
	    $('#txtWeek4').html($g("第四周")+"("+Date4.substring(5,10)+")");
	    $('#txtWeek5').html($g("第五周")+"("+Date5.substring(5,10)+")");
	    ///2.2选中周
	    var SWeek=5;
	    if(Date5==""){SWeek=4;$('#divWeek5').hide();}	//没有第五周
	    if(obj.IsWeek4==1){			//固定四周
	    	//隐藏第五周相关内容
	    	$('#divWeek5').hide();
	     	SWeek=4;
	    }
	    var NowDate=Common_GetDate(new Date());
	    if((Date5!="")&&(Date5>NowDate)){SWeek=4;$HUI.radio("#Week5").disable("true");$("#txtWeek5").css("color","gray");}
	    if(Date4>NowDate){SWeek=3;$HUI.radio("#Week4").disable("true");$("#txtWeek4").css("color","gray");}
	    if(Date3>NowDate){SWeek=2;$HUI.radio("#Week3").disable("true");$("#txtWeek3").css("color","gray");}
	    if(Date2>NowDate){SWeek=1;$HUI.radio("#Week2").disable("true");$("#txtWeek2").css("color","gray");}
	    if(Common_CompareDate(Date1,NowDate)>0){
			SWeek=0;$HUI.radio("#Week1").disable("true");$("#txtWeek1").css("color","gray");
			$.messager.popover({
				msg: '还没到本月第一周预定的ICU危险等级评定日期，故暂不显示患者明细',
				type: 'info',
				timeout: 3000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
		}
	    
	    if(SWeek!=0)$HUI.radio("#Week"+SWeek).setValue(true);	//默认选中评估周
	    //3.弹出框
        $HUI.dialog('#LayerGradeExt', {
            title: "ICU危险等级评定明细",
            iconCls: 'icon-w-paper',
            width: 1000,
            height:600,
            modal: true,
            isTopZindex: true,
            onBeforeClose: function () {
                 obj.refreshGrade();
            }
        })
        //4.刷新明细表
        obj.refreshGradeExt();
	}
    //加载相关函数
    
    //刷新选中病区
    obj.refreshLocList = function () {
        var aHospID = $('#cboHospital').combobox('getValue');
        if (aHospID == "") return;
        var aLocID = "";    //管理员查询所有病区
        if (obj.IsAdmin != 1) {
			aLocID = $.LOGON.LOCID;     //非管理员查询当前病区
        }
        //刷新表格
        obj.gridLocList = $HUI.datagrid("#gridLocList", {
            fit: true,
            title: "查询条件",
            iconCls: "icon-resort",
            headerCls: 'panel-header-gray',
            singleSelect: true,
            loadMsg: '数据加载中...',
            url: $URL,
            pageSize: 999,
            queryParams: {
                ClassName: "DHCHAI.BTS.LocationSrv",
                QueryName: "QryICULoc",
                aHospIDs: aHospID,
                aLocID: aLocID,
                aTypeID:1	//只显示ICU
            },
            columns: [[{
                field: 'LocDesc2', title: '科室', width: 277,
                formatter: function (value, row, index) {
                   return '<span id="Loc-' + index + '"style="user-select: none;padding-left:20px;" >' + value + '</span>';
                }
            }]],
            onSelect: function (Index, rowData) {       //选中病区
                if (rowData != "") {
	                //选中字体加粗 
	                var rows = $('#gridLocList').datagrid('getRows');
	                for (var i = 0; i < rows.length; i++) {             
                        if (i == Index) {
                            $('#Loc-' + i).css('font-weight', 'bold');
                        }
                        else {
                            $('#Loc-' + i).css('font-weight', '');
                        }
                    }
	                //赋值
                    obj.SelectLocID = rowData.ID;                       				
                    //刷新危险登记表
                    obj.refreshGrade();        
                }
            },
            rowStyler: function (index, row) {
                if (row.IsICU == "未配置") return 'background-color:#f7f7f7;';        //未配置ICU显示灰色
            },
            onLoadSuccess: function (data) {
                if (data.total > 0) {
                    $('#gridLocList').datagrid('selectRow', 0);     //默认选中第一行
				}
                else {
                    $('#gridLocList').datagrid('appendRow', {
                        ID: $.LOGON.LOCID,
                        LocDesc2: '<b>' + $.LOGON.LOCDESC + '('+$g('未配置')+')</b>',
                        IsICU: "未配置"
                    });
                    obj.refreshGrade();        //刷新危险登记表
                }
            }
        });
        $('#west .datagrid-header').hide();     //隐藏头
    }
    
    //打开统计图
    obj.ShowEChart=function(){
		var aLocID = obj.SelectLocID;
    	var Year=$('#cboYear').combobox('getValue');
	  	var Month=$('#cboMonth').combobox('getValue');
	  	if((Year=="")||(Month==""))return;
	  	var aYYMM=Year+"-"+Month;

		$cm({
			ClassName:"DHCHAI.IRS.ICUGradeSrv",
			QueryName:"QryAvgICUGrade",
			aLocID:aLocID,
			aYYMM:aYYMM,
			page: 1,
			rows: 999
		},function(rs){
			obj.echartWeekGrade(rs);
		});

   	 	obj.echartWeekGrade = function(runQuery){
			if (!runQuery) return;
			var arrWeek = new Array();
			var arrAvgICUGrade = new Array();
			var arrRecord = runQuery.rows;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				rd["Week"]=$g(rd["Week"]);
				if(obj.IsWeek4==1){
					if(rd["Week"]==$g("第五周"))continue;
				}
				
				arrWeek.push(rd["Week"]);
				arrAvgICUGrade.push(parseFloat(rd["AvgICUGrade"]).toFixed(2));
			}
			var myChart = echarts.init(document.getElementById('EchartDiv'));
			var option = {
				grid:{
					x:62,
					y:31,
					x2:30,
					y2:34
				},
				tooltip : {
					trigger: 'axis'
				},
				calculable : true,
				xAxis : [{
					type : 'category',
					boundaryGap : false,
					data : arrWeek,
					axisLabel: {
						margin:4,
						textStyle: {
                			fontSize:'14'
            			}
					},	  
					splitLine:{
						show:false
					}
				}],
				yAxis : [{
				    type: 'value',
				    name: $g('平均病情严重程度'),
					axisLabel : {
						formatter: '{value}'
					},
					nameTextStyle :{
						fontSize: 14
					}
				}],
				series : [{
				    name: $g('平均病情严重程度'),
					type:'line',
					data:arrAvgICUGrade
				}]
			};
			myChart.setOption(option);
		}
	}
}