//督查表评估查询[Event]
function InitIExAWinWinEvent(obj) {
    obj.LoadEvent = function () {
	    //刷新表格数据
	    obj.refreshGridIExA();
	    
	    //'查询'事件
	    $('#btnQuery').on('click', function () {
		    var aWardID = $('#cboLocal').combobox('getValue');      	//调查病区
	    	if(aWardID==""){
	     		$.messager.alert("提示", "病区不能为空!", 'info');
            	return;
	    	}
	    
	        obj.refreshGridIExA();
        });
	    //'导出'事件
	     $('#btnExport').on('click', function () {
	    	var rows = obj.gridIExA.datagrid('getRows');
        	if(rows.length==0){
	        	$.messager.alert("错误","无记录数据,不允许导出!", 'info');
				return;
	    	}
        	$('#gridIExA').datagrid('toExcel', 'ICU插拔管评估表.xls');   //导出
    	});
	    //'搜索框'事件
	    $('#searchbox').searchbox({
        	searcher: function (value, name) {
            	searchText($("#gridIExA"), value);
       	 	}
    	});
	    //'摘要'事件
	    obj.OpenView = function (EpisodeID) {
		    var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen'+"&LocFlag="+LocFlag;
	    	websys_showModal({
				url:url,
				title:$g('医院感染集成视图'),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
    	}
	    //'电子病历'事件
	    obj.btnEmrRecord_Click = function(EpisodeID,PatientID){		
			var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
			websys_showModal({
				url:url,
				title:$g('病历浏览'),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
		};
    }
    //刷新插拔管评估表列表[前台加载]
    obj.refreshGridIExA = function () {
        var aDateFrom 	= $('#dtDateFrom').datebox('getValue'); 	//调查开始日期
        var aDateTo 	= $('#dtDateTo').datebox('getValue'); 		//调查结束日期
        var aWardID = $('#cboLocal').combobox('getValue');      	//调查病区
        var aTubeType = $('#cboTubeType').combobox('getValue'); 	//插管类型(PICC|VAP|UC)
        
        if((aDateFrom=="")||(aDateTo=="")){
	    	$.messager.alert("提示", "开始/结束日期不能为空!", 'info');
            return;
	    }
	    if(Common_CompareDate(aDateFrom,Common_GetDate(new Date()))) {
           $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
        if(Common_CompareDate(aDateFrom,aDateTo)){
	     	$.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
	    }
	    
        $("#gridIExA").datagrid("loading"); 						//'加载中...'提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.ICUIExASrv',
            QueryName: 'QryIExA',
            ResultSetType: "array",
            aDateFrom: aDateFrom,
            aDateTo: aDateTo,
            aTubeType: aTubeType,
            aWardID: aWardID,
            page: 1,
            rows: 9999
        }, function (rs) {
            $('#gridIExA').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //打开'评估表'链接
    obj.OpenIExARep = function (IExAID, Paadm, TubeType) {
	    //存储选中患者
	    obj.SelPaadm=Paadm;
	    //存储选中插管类型
	    obj.SelTubeType=TubeType;
	    
	    if(IExAID!=""){
		    var url = '../csp/dhcma.hai.ir.icu.iexareport.csp?aIExAID=' + IExAID + '&aIsAdmin=' + obj.IsAdmin  + '&2=2';
            websys_showModal({
                url: url,
                title: $g("三管感染防控督查表"),
                iconCls:'icon-w-epr',
                closable: true,
                width: 1268,
                height: '95%',
                onBeforeClose: function () {
                	obj.refreshGridIExA();
                }
            });
	    }
	    else{
            $('#LayerIExA').show(); 			//显示界面
            var TubeDesc=""
            if(TubeType=="PICC") TubeDesc="<span>"+$g("血管导管")+"</span>";
            if(TubeType=="VAP") TubeDesc="<span>"+$g("呼吸机")+"</span>";
            if(TubeType=="UC") TubeDesc="<span>"+$g("导尿管")+"</span>";
        	$HUI.dialog('#LayerIExA', {
     			title: $g("新建防控督查表")+"-"+TubeDesc+"",
       			iconCls: 'icon-w-paper',
           	 	width: 800,
            	height: 400,
            	modal: true,
            	isTopZindex: true,
            	onBeforeClose: function () {
	        		obj.refreshGridIExA();
	        	}
       		})
    		//初始化'插管类型'    	
        	var DicList=$cm ({
				ClassName:"DHCHAI.IRS.ICUIExASrv",
				QueryName:"QryDicList",
				aRepType:1,				//ICU
				aTubeType:TubeType,
				aItemCode:"TubeType"	//插管类别
			},false);
        	$HUI.combobox("#cboBuildType",{
				valueField:'ID',
				textField:'Desc',
				editable:false,
				data:DicList.rows
			});
        	//初始化'插管日期'
        	$('#txtBuildDate').datebox('setValue',"");
        	
        	//刷新表
        	obj.refreshGridIExAReport();
        }
    }
    //刷新'患者''插拔管评估表'列表
	obj.refreshGridIExAReport=function(IsALL){
		var IsALL=Common_RadioValue("chkStatunit");
		
		$("#gridIExAReport").datagrid("loading"); 						//'加载中...'提示信息
		var Ret = $cm({
			ClassName: 'DHCHAI.IRS.ICUIExASrv',
			QueryName: 'QryIExARepList',
			aEpisodeID: obj.SelPaadm,
			aTubeType: obj.SelTubeType,
			aIsALL:IsALL,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridIExAReport').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
	}
	//'显示全部'选中事件
	$HUI.radio("[name='chkStatunit']", {
       	 onCheckChange: function () {
           	obj.refreshGridIExAReport();
		}
	})
    //'新建'插拔管评估表
    $('#btnBuild').click(function (e) {
	    //插管类型
	    var IntuType = $('#cboBuildType').combobox('getValue');
	    //置管日期
	    var IntuDate = $('#txtBuildDate').combobox('getValue'); 
           
        if (IntuType == "") {
            $.messager.alert("提示", "插管类型不能为空!", 'info');
            return;
        }
        
        var Flag=Common_CompareDate(IntuDate,Common_GetDate(new Date()));
        if(Flag=="-1"){
	    	$.messager.alert("提示", "置管日期不能为空!", 'info');
            return;
	    }
        if(Flag=="1") {
           $.messager.alert("提示", "置管日期不能大于当前日期!", 'info');
            return;
        }
       	//取患者出院日期
        var AdmData = $cm({
            ClassName: "DHCHAI.DPS.PAAdmSrv",
            QueryName: "QryAdmInfo",
            aEpisodeID: obj.SelPaadm
        }, false);
        var DischDate=AdmData.rows[0].DischDate;
        if((DischDate!="")&&(Common_CompareDate(IntuDate,DischDate))){
	     	$.messager.alert("提示", "置管日期不能大于出院日期!", 'info');
            return;  
	    }
        
        
        var text = $('#cboBuildType').combobox('getText');
        $.messager.confirm("提示", $g('插管类型')+':<font color="red">' + text + '</font><br>'+$g("插管日期")+':<font color="red">' + IntuDate + '</font><br>'+$g("是否生成督查表")+'?', function (r) {
            if (r) {
                var InputStr = "^" + obj.SelPaadm + "^" + IntuType + "^" + IntuDate + "^^^" + 1;
                var ret = $m({
                    ClassName: "DHCHAI.IR.ICUIExA",
                    MethodName: "Update",
                    aInputStr: InputStr
                }, false);
                if (parseInt(ret) > 0) {
                    $.messager.alert("提示", "生成成功!", 'info');
                    
                    obj.refreshGridIExAReport();
                } else {
                    $.messager.alert("提示", "生成失败!", 'info');
                }
            }
            else {
                return;
            }
        });
    })
    //'三管医嘱'
     $('#btnINFLabSync').click(function (e) {
	    switch (obj.SelTubeType) {
            case "PICC": var Flag = 1; break;
            case "VAP": var Flag = 2; break;
            case "UC": var Flag = 3; break;
            default: var Flag = 0
        };
        $('#LayerHisOEOrdItem').show();
        $HUI.dialog('#LayerHisOEOrdItem', {
            title: "历史插管医嘱信息",
            iconCls: 'icon-w-paper',
            width: 700,
            height: 350,
            top: 185,
            modal: true,
            isTopZindex: true
        })
        
        obj.refreshgridHisOEOrdItem(Flag);  		//刷新历史医嘱
	})
    //刷新'三管医嘱'
    obj.refreshgridHisOEOrdItem = function (Flag) {
	    $("#gridHisOEOrdItem").datagrid("loading"); 						//'加载中...'提示信息
		var Ret = $cm({
			ClassName: 'DHCHAI.IRS.ICULogSrv',
			QueryName: 'QryICUAdmOeItem',
			aPaAdm: obj.SelPaadm,
			aFlag: Flag,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridHisOEOrdItem').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
    }
    //删除|激活
    obj.UpdateStatus=function(IExAID,IsActive){
	    if(IsActive=="1"){
			var txt="激活";
		}
		else{
			var txt="删除";
		}
	    $.messager.confirm("提示", '是否'+txt+'评估表?', function (r) {
        	if (r) {
                var ret = $m({
					ClassName: "DHCHAI.IR.ICUIExA",
					MethodName: "UpdateIsActive",
					aIExAID:IExAID,
					aIsActive:IsActive
				}, false);
				if (parseInt(ret) > 0) {
					$.messager.alert("提示", "操作成功!", 'info');
           			 obj.refreshGridIExAReport();
				} else {
					$.messager.alert("提示", "操作失败!", 'info');
				}
            }
            else {
                return;
            }
        });
	}
}